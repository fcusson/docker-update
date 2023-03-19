function main() {

    # copy script to sbin
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cp "${SCRIPT_DIR}/src/docker-update.sh" /usr/sbin/docker-update
    chmod +x /usr/sbin/docker-update

}

if [ "$EUID" -ne 0 ]; then
    echo "Setup must be run as root"
fi

main
