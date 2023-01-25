#!/usr/bin/env bash

function main () {

    directory=$(dirname "$1")

    if [ ! -f $1 ]; then
        echo "$1 does not exist"
        exit 1
    fi

    if [[ "$1" != *"docker-compose.yaml"  ]] && [[ "$1" != *"docker-compose.yml" ]]; then
        echo "$1 is not a docker file"
        exit 1
    fi

    if [ ! -f "${directory}/service_name" ]; then
        echo "${directory} does not contain a service_name file."
        exit 1
    fi

    # get service name
    service_name=$(cat "${directory}/service_name")

    # pull the new image
    docker-compose -f $1 pull

    # stop service
    systemctl stop "${service_name}"

    # remove container
    docker-compose -f $1 rm --force

    # reactivate container
    docker-compose -f $1 up -d
    sleep 5
    docker-compose -f $1 stop

    # start service
    systemctl start ${service_name}

}

if [ "$EUID" -ne 0 ]; then 
    echo "Script must be run as root"
    exit 1
fi

main $1
