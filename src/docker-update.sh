#!/usr/bin/env bash

function main () {


    if [ $# -eq 0 ]; then
        file="./docker-compose.yaml"
    else
        file="$1"

    directory=$(dirname "$file")

    if [ ! -f $file ]; then
        echo "$file does not exist"
        exit 1
    fi

    if [[ "$file" != *"docker-compose.yaml"  ]] && [[ "$file" != *"docker-compose.yml" ]]; then
        echo "$file is not a docker file"
        exit 1
    fi

    if [ ! -f "${directory}/service_name" ]; then
        echo "${directory} does not contain a service_name file."
        exit 1
    fi

    # get service name
    service_name=$(cat "${directory}/service_name")

    # pull the new image
    docker-compose -f $file pull

    # stop service
    systemctl stop "${service_name}"

    # remove container
    docker-compose -f $file rm --force

    # reactivate container
    docker-compose -f $file up -d
    sleep 5
    docker-compose -f $file stop

    # start service
    systemctl start ${service_name}

}

if [ "$EUID" -ne 0 ]; then 
    echo "Script must be run as root"
    exit 1
fi

main $1
