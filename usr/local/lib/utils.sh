# shellcheck shell=bash
# Utilities to be sourced for use in other scripts

# Constants
#
# Common function stack levels used

# declare -ir STACK_LEVEL_1="1"
declare -ir STACK_LEVEL_1="1"
# declare -ir STACK_LEVEL_2="2"
declare -ir STACK_LEVEL_2="2"

# Log Levels

# declare LOG_LEVEL="INFO"
# Intended to override with preferred LOG_LEVEL
declare LOG_LEVEL="INFO"
# declare -r LOG_LEVEL_WARN="WARN"
declare -r LOG_LEVEL_WARN="WARN"

# Boolean values

# declare -r BOOL_TRUE="true"
declare -r BOOL_TRUE="true"
# declare -r BOOL_FALSE="false"
declare -r BOOL_FALSE="false"

# log()
# Wrapper for echo that includes the function name prefixed by the provided message
#
# Args:
#   $1) msg - string
#       * Optional - If no message is provided logs only the stack level function
#       * Logs to stdout
#   $2) stack_level - int; optional, 
#       * Optional - Defaults to calling function
#       * Sets the function to prefix log messages
log() {
    local -r origin_func="${FUNCNAME[${2:-$STACK_LEVEL_1}]}"
    echo -e "$origin_func: ${1:-}"
}

# log_warn()
# Wrapper for log that prefixes the message with $LOG_LEVEL_WARN
# Only executes when [ "$LOG_LEVEL" == "$LOG_LEVEL_WARN" ]
#
# Args:
#   $1) msg - string
#       * Optional
#       * Additional messages to log before exiting
#   $2) origin_stack_level - int
#       * Optional
#       * passed to log to show the desired origin function
log_warn() {
    if [ "$LOG_LEVEL" == "$LOG_LEVEL_WARN" ]; then
        log "$LOG_LEVEL_WARN: ${1}" "${2:-$STACK_LEVEL_1}"
    fi
}

# abort()
# Wrapper for log that exits with an error code
#
# Args:
#   $1) msg - string
#       * Optional
#       * Additional messages to log before exiting
#   $2) origin_stack_level - int
#       * Optional
#       * passed to log to show the desired origin function
abort() {
    log "${1:-}" "${STACK_LEVEL_2}"

    log "Exiting"
    exit 1
}

# starting()
#
# Calls log with message "starting"
# Used to notify the user that a function is starting
#
# Args: none
starting() {
    log "starting"
}

# if_debug_set_xtrace()
# If DEBUG="$BOOL_TRUE" xtrace is set
#
# Args: none
if_debug_set_xtrace() {
    local set_xtrace="${DEBUG:-"$BOOL_FALSE"}"
    starting

    [ "$set_xtrace" == "$BOOL_TRUE" ] && set -x
    log "DEBUG=$set_xtrace"
}

# check_dir_exists()
# Checks if a directory exists
#
# Args:
#   $1)
#       * Directory to check
check_dir_exists() {
    [ -d "$1" ] || return 1
}

# check_file_exists()
# Checks if a file exists
# Args:
#   $1)
#       * File to check
check_file_exists() {
    [ -f "$1" ] || return 1
}

# cleanup()
# useful to call via trap for cleaning up files/directories
#
# Args:
#   $1) trash - nameref
#       * Array of files/directories to delete
cleanup() {
    local -n trash="$1"
    starting

    # shellcheck disable=SC2068
    for t in ${trash[@]}; do
        if [ -f "$t" ] || [ -d "$t" ]; then
            cmd=(
                "rm"
                "-rf"
                "$t"
            )

            log "Executing: ${cmd[*]}"
            # shellcheck disable=SC2068
            ${cmd[@]}
        else
            log "$t not found. Doing nothing."
        fi
    done
}
