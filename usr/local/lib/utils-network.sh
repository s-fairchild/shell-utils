# shellcheck shell=bash

# validate_subnet()
# Checks if the provided subnet is valid against regex string: "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(3[0-2]|[12]?[0-9])$"
#
# Args:
#   $1) subnet - string
#       * CIDR notation is required
validate_subnet() {
    local -r subnet_regex="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(3[0-2]|[12]?[0-9])$"
    log "starting"

    [[ $1 =~ $subnet_regex ]] || return 1
}

# validate_netdev()
# Checks if the provided string is a network link using ip link show
# stdout and stderr are sent to /dev/null
#
# Args:
#   $1) netdev - string
#       * Network device (link) to check for existence
validate_netdev() {
    log "starting"

    ip link show "$1" &> /dev/null || return 1
}
