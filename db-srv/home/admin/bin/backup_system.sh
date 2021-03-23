#!/bin/bash
# Encoding : UTF-8
# Backup system directories

# What to backup.
bkp_list="/etc /opt /root /usr/local /home/admin/bin /home/admin/docker"
# Where to backup to.
bkp_dest="/home/admin/backups/system"
# Create archive filename.
date="$(date +%F)"
hostname="$(hostname -s)"
archive_file="${date}_${hostname}.tar.bz2"
# Number of backups to keep by period
bkp_daily=5
bkp_weekly=3
bkp_monthly=3
bkp_yearly=1

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
echo "$(date '+%Y-%m-%d %T') - Backing up ${bkp_list} to ${bkp_dest}/${archive_file}"

# Create destination directory if necessary
mkdir -p "${bkp_dest}"

# Backup the files using tar.bz2
rm -f "${bkp_dest}/${archive_file}"
sudo tar jcf "${bkp_dest}/${archive_file}" ${bkp_list}

# Compiles dates to keep by period (daily, weekly, monthly, yearly)
keep=()
# Daily
for i in $(seq 0 ${bkp_daily}); do ((keep[$(date +%Y%m%d -d "-$i day")]++)); done
# Weekly
for i in $(seq 0 ${bkp_weekly}); do ((keep[$(date +%Y%m%d -d "sunday-$((i+1)) week")]++)); done
# Monthly
for i in $(seq 0 ${bkp_monthly}); do
        DW=$(($(date +%-W)-$(date -d $(date -d "$(date +%Y-%m-15) -$i month" +%Y-%m-01) +%-W)))
        for (( AY=$(date -d "$(date +%Y-%m-15) -$i month" +%Y); AY < $(date +%Y); AY++ )); do
                ((DW+=$(date -d $AY-12-31 +%W)))
        done
        ((keep[$(date +%Y%m%d -d "sunday-$DW weeks")]++))
done
# Yearly
for i in $(seq 0 ${bkp_yearly}); do
        DW=$(date +%-W)
        for (( AY=$(($(date +%Y)-i)); AY < $(date +%Y); AY++ )); do
                ((DW+=$(date -d $AY-12-31 +%W)))
        done
        ((keep[$(date +%Y%m%d -d "sunday-$DW weeks")]++))
done

# Transform keep indices to array of formated dates
dates=()
for date in ${!keep[@]}; do
	dates+=("${date:0:4}-${date:4:2}-${date:6}")
done

# Get array of local files
local_files=()
for path in $(ls "${bkp_dest}/"); do
    filename=$(basename -- "${path}")
    local_files+=("${filename}")
done

# Deleting not keeping files
for file in "${local_files[@]}"; do
	if in_array $(echo "${file}" | cut -d'_' -f1) "${dates[@]}" ; then
		echo "Keeping: ${file}"
	else
		echo "Deleting: ${file}"
		rm -f "${bkp_dest}/${file}"
	fi
done

# Display infos about archive
echo $(du -hs "${bkp_dest}/${archive_file}")

# End
echo "End at $(date '+%Y-%m-%d %T')"
