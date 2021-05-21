#!/usr/bin/env bash
# Encoding : UTF-8
# Script to store localy and transfert OVH backup instance beteen datacenters.

set -eo pipefail #Don't use '-u' option if you want source python virtualenv without error !

# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE) [options]
     -h | --help: display this help
     -v | --verbose: display more infos
     -x | --debug: display debug script infos
     -c | --config: path to config file to use (default : config/settings.ini)

Stop execution of specific operations:
     -a | --stop-all: don't execute all OpenStack operations
     -d | --stop-download: don't execute the download operation
     -u | --stop-upload: don't execute the upload operation
	 -r | --stop-remove: don't execute the remove operation
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
			"--stop-all") set -- "${@}" "-a" ;;
			"--stop-download") set -- "${@}" "-d" ;;
			"--stop-upload") set -- "${@}" "-u" ;;
			"--stop-remove") set -- "${@}" "-r" ;;
            "--config") set -- "${@}" "-c" ;;
            "--"*) exitScript "ERROR : parameter '${arg}' invalid ! Use -h option to know more." 1 ;;
            *) set -- "${@}" "${arg}"
        esac
    done

    while getopts "hvxadurc:" option; do
        case "${option}" in
            "h") printScriptUsage ;;
            "v") readonly verbose=true ;;
            "x") readonly debug=true; set -x ;;
			"a") readonly stop_all=true ;;
			"d") readonly stop_download=true ;;
			"u") readonly stop_upload=true ;;
			"r") readonly stop_remove=true ;;
            "c") setting_file_path="${OPTARG}" ;;
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
	# Don't leave a blank variable, unset it if it was empty
	if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi

    #+----------------------------------------------------------------------------------------------------------+
    # Init script
    initScript "${@}"
    parseScriptOptions "${@}"
    loadScriptConfig "${setting_file_path-}"
    redirectOutput "${bsi_log_file}"

	#+----------------------------------------------------------------------------------------------------------+
	# To be executed after script end !
	trap sendLogByEmail EXIT

	#+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "${app_name} script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
	printInfos
	downloadAllSrvBkpImg
	uploadAllSrvBkpImg
	removeAllOldSrvBkpImg

    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

function printInfos() {
	printVerbose "Informations about this script..." ${Yel}
	printVerbose "\tScript running:${Whi} ${script_path} ${script_params}" ${Gra}
	printVerbose "\tOpenStack Client version:${Whi} $(openstack --version)" ${Gra}
}

function downloadAllSrvBkpImg() {
	export OS_REGION_NAME="${bsi_source_region_name}"

	prepareStorageDir

	local servers=("${bsi_db_srv_backup_name}" "${bsi_web_srv_backup_name}")
	for srv in "${servers[@]}"; do
		downloadSrvImg "${srv}"
	done
}

function prepareStorageDir() {
    printMsg "Prepare for ${OS_REGION_NAME} the storage dir..."
	if ! [[ -d "${bsi_storage_dir}/" ]]; then
		mkdir -p "${bsi_storage_dir}/"
	else
		printPretty "\tStorage dir already exists at: ${bsi_storage_dir}" ${Gra}
	fi

	cd "${bsi_storage_dir}"

	printVerbose "\tSearching files to delete..."
	if [[ -z ${stop_all-} ]] && [[ -z ${stop_download-} ]]; then
		local msg="\t\t%f (DELETED)\n"
		find "${bsi_storage_dir}/" -name "*.${bsi_img_ext}" -type f -mmin +720 -printf "${msg}" -exec rm {} \;
	else
		local msg="\t\t %f (NOT deleted)\n"
		find "${bsi_storage_dir}/" -name "*.${bsi_img_ext}" -type f -mmin +720 -printf "${msg}"
	fi
}

# DESC: Download localy a server backup image
# ARGS: $1 (required): server backup image name
# OUTS: None
function downloadSrvImg() {
	if [[ $# -lt 1 ]]; then
        exitScript 'Missing required argument to downloadSrvImg()!' 2
    fi

	local srv_backup_name="${1}"
	local srv_name="${srv_backup_name%%_*}"

	printMsg "Extract from ${OS_REGION_NAME} the ${srv_name^^} last image id and date..."
	local id=""
	local max_date=""
	local last_img_id=""
	local img_ids=()
	mapfile img_ids < <(openstack image list --name "${srv_backup_name}" -c ID -f value)
	for id in "${img_ids[@]}"; do
		local new_date="$(openstack image show ${id} -c created_at -f value)"
		if [[ "${new_date}" > "${max_date}" ]]; then
			max_date="${new_date}"
			last_img_id="${id//[$'\r\n']}"
		fi
	done
	printVerbose "\tMax date: ${max_date} => Img id: ${last_img_id}"

	printMsg "Download from ${OS_REGION_NAME} the ${srv_name^^} instance backup image..."
	img_file_path="${bsi_storage_dir}/${max_date%T*}_${srv_backup_name%%_*}.${bsi_img_ext}"
	printVerbose "\tDownload ${last_img_id} to ${img_file_path}"
	if [[ -z ${stop_all-} ]] && [[ -z ${stop_download-} ]]; then
		openstack image save --file "${img_file_path}" "${last_img_id}"
	fi
}

function uploadAllSrvBkpImg() {
	export OS_REGION_NAME="${bsi_destination_region_name}"

	printMsg "Upload to ${OS_REGION_NAME} all instance backup images ..."
	local img_file_path=""
	find "${bsi_storage_dir}/" -name "*.${bsi_img_ext}" -type f -print0 | while read -d $'\0' img_file_path; do
		local image_file_name="${img_file_path##*/}"
		local image_upload_name="${image_file_name%.*}"
		local image_srv="${image_upload_name##*_}"
		printVerbose "\tUpload to ${OS_REGION_NAME} image ${img_file_path} with name ${image_upload_name} and tag ${image_srv}"
		if [[ -z ${stop_all-} ]] && [[ -z ${stop_upload-} ]]; then
			openstack image create \
				--private \
				--disk-format "${bsi_img_ext}" \
				--container-format bare \
				--tag "${image_srv}" \
				--file "${img_file_path}" \
				"${image_upload_name}"
		fi
	done
}

function removeAllOldSrvBkpImg() {
	export OS_REGION_NAME="${bsi_destination_region_name}"
	printMsg "Removing from ${OS_REGION_NAME} all old instance backup images..."

	local servers=("${bsi_db_srv_backup_name}" "${bsi_web_srv_backup_name}")
	for srv in "${servers[@]}"; do
		removeSrvImg "${srv}"
	done
}

# DESC: Remove server backup image from Datacenter Storage
# ARGS: $1 (required): server backup image name
# OUTS: None
function removeSrvImg() {
	if [[ $# -lt 1 ]]; then
        exitScript 'Missing required argument to removeSrvImg()!' 2
    fi

	local srv_backup_name="${1}"
	local srv_name="${srv_backup_name%%_*}"

	printMsg "Remove from ${OS_REGION_NAME} the ${srv_name^^} old images..."
	local img_infos=()
	mapfile img_infos < <(openstack image list --tag "${srv_name}" --sort name:asc -c ID -c Name -f value)

	printVerbose "\tSearching images to remove..."
	local max_older_date=$(date --date="${bsi_days_of_retention} days ago" +'%F')
	for infos in "${img_infos[@]}"; do
		local id=${infos%% *}
		local fmt_id="${id//[$'\r\n']}"
		local name=${infos##* }
		local fmt_name="${name//[$'\r\n']}"
		local date=${name%%_*}
		if [[ "${date}" < "${max_older_date}" ]]; then
			if [[ -z ${stop_all-} ]] && [[ -z ${stop_remove-} ]]; then
				openstack image delete ${fmt_id}
				printVerbose "\t\t${fmt_name} (REMOVED)\n"
			else
				printVerbose "\t\t${fmt_name} (NOT removed: ${date}, ${fmt_id})\n"
			fi
		else
			printVerbose "\t\t${fmt_name} (nothing to do: ${date}, ${fmt_id})"
		fi
	done
}

function sendLogByEmail() {
	printMsg "Sending email with log content..."
	stopRedirectOutput
	local subject="Backups - Instances images - $(date +'%F')"
	cat "${bsi_log_file}" | mail -s "${subject}" -r "${bsi_email_from}" "${bsi_email_to}"
}

main "${@}"
