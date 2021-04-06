#!/bin/bash
backend=${0}
jobid=${1}
cupsuser=${2}
jobtitle=${3}
jobcopies=${4}
joboptions=${5}
jobfile=${6}
dptrp1path=

export DPT_KEY=/home/${cupsuser}/.dpapp/privatekey.dat
export DPT_ID=/home/${cupsuser}/.dpapp/deviceid.dat

# Get the device URL
DEVICEADDR=$(echo ${DEVICE_URI} | awk -F ":" {'print $2'})

printtime=$(date +%Y-%m-%d_%H-%M)
sanitized_jobtitle="$(echo ${jobtitle} | \
	tr [[:blank:]:/%\&=+?\\\\#\'\`\´\*] _ | \
	sed 's/ü/u/g;s/ä/a/g;s/ö/o/g;s/Ü/U/g;s/Ä/A/g;s/Ö/O/g;s/{\\ß}/ss/g' | \
	iconv -c -f utf-8 -t ascii - | rev | cut -f 2- -d '.' | rev ).pdf"
outname=/tmp/${printtime}_${sanitized_jobtitle}

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
        ;;

    6)
        cat ${6} > ${outname}
        ${dptrp1path} --addr=${DEVICEADDR} \
            --client=${DPT_ID} \
            --key=${DPT_KEY} \
            upload ${outname} Document/Printed/

        rm ${outname}
        ;;
esac
echo 1>&2
exit 0
