#!/bin/bash
# Source: https://mwender.com/bashscript-dropbox-uploader-db-backup/

# Parameters
# Dropbox config file
dbx_cfg_file="${1:-/root/.dropbox_uploader}"
# Name of directory on Dropbox where backup list
dbx_dir="${2:-backup}"
# List of files to upload to Dropbox
bkp_list="${@:3}"
bkp_arr=(${bkp_list})

# Current directory
current_dir="$( cd "$(dirname "$0")" ; pwd -P )"
# Dropbox uploader file path
# Requires [Dropbox Uploader](https://github.com/andreafabrizi/Dropbox-Uploader)
dbx_uploader="${current_dir}/dropbox_uploader.sh"

# Functions
function in_array() {
    local hay needle=$1
    shift
    for hay; do
        [[ $hay == $needle ]] && return 0
    done
    return 1
}

# Start
echo "Start at $(date '+%Y-%m-%d %T')"

# Get array of local files
local_files=()
for path in "${bkp_arr[@]}"; do
    filename=$(basename -- "${path}")
    local_files+=("${filename}")
done

# Get array of Dropbox files before upload
dbx_files=($(${dbx_uploader} -f ${dbx_cfg_file} list /${dbx_dir} | awk 'NR!=1{ print $3 }'))

echo "Analysing files to upload on Dropbox..."
upload=()
for file in "${local_files[@]}"; do
    if ! in_array ${file} "${dbx_files[@]}" ; then
        echo " > File to upload: '${file}'"
        upload+=(${file})
    fi
done

# Upload files to Dropbox
if [[ "${#upload[@]}" > 0 ]]; then
    echo "Uploading list of backups to Dropbox..."
    for path in "${bkp_arr[@]}"; do
        filename=$(basename -- "${path}")
        if in_array ${filename} "${upload[@]}" ; then
            echo " > Upload: ${path}"
            "${dbx_uploader}" -f "${dbx_cfg_file}" upload "${path}" "/${dbx_dir}"
        fi
    done
else
    echo "All files already on Dropbox !"
fi

# Remove old Dropbox files
echo "Building Dropbox and local files lists..."
# Get array of Dropbox files after upload
dbx_files=($(${dbx_uploader} -f ${dbx_cfg_file} list /${dbx_dir} | awk 'NR!=1{ print $3 }'))

echo "Analysing files to delete/keep on Dropbox..."
keep=()
delete=()
for file in "${dbx_files[@]}"; do
    if in_array ${file} "${local_files[@]}" ; then
        echo " > File to keep: '${file}'"
        keep+=(${file})
    else
        echo " > File to delete: '${file}'"
        delete+=(${file})
    fi
done

echo "Deleting files on Dropbox only if at least one file is remaining..."
if [[ "${#keep[@]}" > 0 ]]; then
    for file in "${delete[@]}"; do
        ${dbx_uploader} -f ${dbx_cfg_file} delete "/${dbx_dir}/${file}"
    done
else
    echo "Deleting Dropbox files stopped because no files remaining on Dropbox after deleting !"
fi

# End
echo "End at $(date '+%Y-%m-%d %T')"
