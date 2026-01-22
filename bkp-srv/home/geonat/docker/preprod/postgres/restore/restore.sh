#!/usr/bin/env bash
# Encoding : UTF-8
# Script to restore GeoNature database custom dump into Postgresql container.
# TODO: try to use postgres as default user with superuser rights. Create geonatadmin via initdb scripts.

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes


# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE) [options]
     -h | --help: display this help
     -v | --verbose: display more infos
     -x | --debug: display debug script infos
     -c | --config: path to config file to use (default : settings.ini)

Specific options:
     -d | --dump-file: database dump file name
EOF
    exit 0
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parseScriptOptions() {
    # Transform long options to short ones
    for arg in "${@}"; do
        shift
        case "${arg}" in
            "--help") set -- "${@}" "-h" ;;
            "--verbose") set -- "${@}" "-v" ;;
            "--debug") set -- "${@}" "-x" ;;
            "--config") set -- "${@}" "-c" ;;
            "--dump-file") set -- "${@}" "-d" ;;
            "--"*) exitScript "ERROR : parameter '${arg}' invalid ! Use -h option to know more." 1 ;;
            *) set -- "${@}" "${arg}"
        esac
    done

    while getopts "hvxc:d:" option; do
        case "${option}" in
            "h") printScriptUsage ;;
            "v") readonly verbose=true ;;
            "x") readonly debug=true; set -x ;;
            "c") setting_file_path="${OPTARG}" ;;
            "d") setting_dump_file="${OPTARG}" ;;
            *) exitScript "ERROR : parameter invalid ! Use -h option to know more." 1 ;;
        esac
    done
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    #+----------------------------------------------------------------------------------------------------------+
    # Load utils
    source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"

    #+----------------------------------------------------------------------------------------------------------+
    # Init script
    initScript "${@}"
    parseScriptOptions "${@}"
    loadScriptConfig "${setting_file_path-}"
    #redirectOutput "${default_log_file}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "${app_name} script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
    setConstants
    printInfos
    restoreGeoNatureDbDump


    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

# DESC: Define value of gnrs_dump_file variable
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: variable gnrs_dump_file indicating command-line parameters and options
function setConstants() {
    readonly gnrs_dump_file="${setting_dump_file-${POSTGRES_RESTORE_FILE-'geonature2db.dump'}}"
    readonly gnrs_pgrestore_log="/restore/$(date +"%Y-%m-%d")_pgrestore.log"
}


function printInfos() {
    printVerbose "Informations about this script..." ${Yel}
    printVerbose "\tScript running:${Whi} ${script_path} ${script_params}" ${Gra}
    printVerbose "\tDump file:${Whi} ${gnrs_dump_file}" ${Gra}
    printVerbose "\tsetting_dump_file:${Whi} ${setting_dump_file}" ${Gra}
    printVerbose "\tPOSTGRES_RESTORE_FILE:${Whi} ${POSTGRES_RESTORE_FILE}" ${Gra}
    printVerbose "\tDatabase:${Whi} ${gnrs_db_name} @ ${gnrs_db_host}:${gnrs_db_port} used by ${gnrs_db_user}" ${Gra}
}

function restoreGeoNatureDbDump() {
    # Define the database to restore
    local db_to_restore=""
    if [[ "${gnrs_dump_file}" =~ .*"gnatlas".* ]]; then
        db_to_restore="gnatlas"
    elif [[ "${gnrs_dump_file}" =~ .*"geonature2db".* ]]; then
        db_to_restore="geonature2db"
    else
        printExit "Unknown database name in ${gnrs_dump_file} ! Known : gnatlas, geonature2db."
    fi

    # Remove previously loaded database
    if psql --username "${gnrs_db_user}" -lqt | cut -d \| -f 1 | grep -qw "${db_to_restore}"; then
        psql --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --command \
            "SELECT pg_terminate_backend(pg_stat_activity.pid)
            FROM pg_stat_activity
            WHERE pg_stat_activity.datname = '${db_to_restore}' AND pid <> pg_backend_pid();"
        dropdb --username "${gnrs_db_user}" --echo --if-exists "${db_to_restore}"
    fi

    # Create new database
    createdb --username "${gnrs_db_user}" --echo --template template0 "${db_to_restore}"

    # Make specific stuff !
    if [[ "${db_to_restore}" = "gnatlas" ]]; then
        # Create specific pre-prod FDW Server
        psql --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --command \
            "ALTER USER ${gnrs_atlas_db_user} WITH PASSWORD '${gnrs_atlas_db_password}';"
        psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
            "CREATE EXTENSION IF NOT EXISTS postgres_fdw;"
        psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
            "CREATE EXTENSION IF NOT EXISTS postgis;"
        psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
            "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
        psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
            "DROP SERVER IF EXISTS geonaturedbserver CASCADE;"
        psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
            "CREATE SERVER geonaturedbserver FOREIGN DATA WRAPPER postgres_fdw
            OPTIONS (
                host 'localhost',
                dbname '${gnrs_db_name}',
                port '${gnrs_db_port}',
                fetch_size '100000'
            );"
        psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
            "CREATE USER MAPPING FOR ${gnrs_db_user}
            SERVER geonaturedbserver OPTIONS (user '${gnrs_db_user}', password '${gnrs_db_password}');"
    fi

    # Add pg_stat_statements extension to monitor queries
    psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
        "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"

    # Grant all privileges on DB to restore to registred Docker Postgreqsl user
    psql --username "${gnrs_db_user}" --dbname "${db_to_restore}" --command \
        "GRANT ALL PRIVILEGES ON DATABASE ${db_to_restore} TO ${gnrs_db_user};"

    # Run database restore
    if [[ "${gnrs_dump_file}" =~ .*".sql" ]]; then
        psql --echo-queries \
            --username "${gnrs_db_user}" \
            --dbname "${db_to_restore}" \
            --file "/restore/${gnrs_dump_file}" 2>&1 | tee "${gnrs_pgrestore_log}"
    else
        pg_restore --verbose \
            --username "${gnrs_db_user}" \
            --dbname "${db_to_restore}" \
            --jobs "$(nproc)" \
            "/restore/${gnrs_dump_file}" 2>&1 | tee "${gnrs_pgrestore_log}"
    fi
}

main "${@}"

