#!/bin/bash
backend=${0}
jobid=${1}
cupsuser=${2}
jobtitle=${3}
jobcopies=${4}
joboptions=${5}
jobfile=${6}
dptrp1path=

useruuid=$(id -u ${cupsuser})

export DPT_KEY=/home/${cupsuser}/.dpapp/privatekey.dat
export DPT_ID=/home/${cupsuser}/.dpapp/deviceid.dat

# Get the device URL
DEVICEADDR=$(echo ${DEVICE_URI} | awk -F ":" '{print $2}')

printtime=$(date +%Y-%m-%d_%H-%M)
sanitized_jobtitle="$(echo ${jobtitle} | awk -F '/' '{print $NF}' | \
	tr [[:blank:]:/%\&=+?\\\\#\'\`\´\*] _ | \
	sed 's/ü/u/g;s/ä/a/g;s/ö/o/g;s/Ü/U/g;s/Ä/A/g;s/Ö/O/g;s/{\\ß}/ss/g' | \
	iconv -c -f utf-8 -t ascii - )"

sanitized_jobtitle="$(echo ${sanitized_jobtitle} | \
  sed 's/.pdf$\|.docx$//gI').pdf"
outname=/tmp/${printtime}_${sanitized_jobtitle}
docname=${printtime}_${sanitized_jobtitle}

# Hacky way to determine whether the original pdf file should be
# transfered to the DPT-RP1 or the file ceated by CUPS. If only
# some pages of the file should be printed, then the CUPS-generated
# file is used
function copy_original_or_not() {
  # Confirm that there is an original file as pdf
  if test -f "${jobtitle}"; then
    # Compare extension
    extension=$(basename ${jobtitle} | awk -F '.' '{print $NF}')
    if [ "$extension" = "pdf" ]; then
      # Compare number of pages
      npages_a=$(pdfinfo ${jobtitle} | awk '/^Pages:/ {print $2}')
      npages_b=$(pdfinfo ${jobfile} | awk '/^Pages:/ {print $2}')
      if [ "${npages_a}" = "${npages_b}" ]; then
        echo 1
      else
        echo 0
      fi
    else
      echo 0
    fi
  else
    echo 0
  fi
}

# Hacky way to determine whether the original pdf file should be
# transfered to the DPT-RP1 or the file ceated by CUPS. If only
# some pages of the file should be printed, then the CUPS-generated
# file is used
function copy_original_or_not() {
  # Confirm that there is an original file as pdf
  if test -f "${jobtitle}"; then
    # Compare extension
    extension=$(basename ${jobtitle} | awk -F '.' '{print $NF}')
    if [ "$extension" = "pdf" ]; then
      # Compare number of pages
      npages_a=$(pdfinfo ${jobtitle} | awk '/^Pages:/ {print $2}')
      npages_b=$(pdfinfo ${jobfile} | awk '/^Pages:/ {print $2}')
      if [ "${npages_a}" = "${npages_b}" ]; then
        echo 1
      else
        echo 0
      fi
    else
      echo 0
    fi
  else
    echo 0
  fi
}

case ${#} in
    0)
        # this case is for "backend discovery mode"
        echo "DPT-RP1 Printer \"Backend to print directly to DPT-RP1\""
        exit 0
        ;;
    5)
        # backend needs to read from stdin if number of arguments is 5
        cat - > ${outname}

        dptrp1 --addr=${DEVICEADDR} \
            --client=${DPT_ID} \
            --key=${DPT_KEY} \
            upload ${outname} Document/Printed/

        rm ${outname}

        # Send notification to user
        sudo -u ${cupsuser} DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${useruuid}/bus notify-send 'DPT-RP1' "${docname} Printed!"
        ;;

    6)
        # A hacky way to just copy the original PDF if the original document is PDF
        originalfile=$(copy_original_or_not)
        if [ ${originalfile} = 1 ]; then
          cp ${jobtitle} ${outname}
        else
          cat ${6} > ${outname}
        fi

        ${dptrp1path} --addr=${DEVICEADDR} \
            --client=${DPT_ID} \
            --key=${DPT_KEY} \
            upload ${outname} Document/Printed/

        rm ${outname}

        # Send notification to user
        sudo -u ${cupsuser} DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${useruuid}/bus notify-send 'DPT-RP1' "${docname} Printed!"
        ;;
esac
echo 1>&2
exit 0
