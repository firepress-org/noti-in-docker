#!/usr/bin/env bash

# A best practices Bash script template with many useful functions. This file
# sources in the bulk of the functions from the .bashcheck.sh file which it expects
# to be in the same directory. Only those functions which are likely to need
# modification are present in this file. This is a great combination if you're
# writing several scripts! By pulling in the common functions you'll minimise
# code duplication, as well as ease any potential updates to shared functions.

# A better class of script...
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
#set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

# DESC: Usage help
# ARGS: None
# OUTS: None
function script_usage() {
    cat << EOF
Usage:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
    -nc|--no-colour             Disables colour output
    -cr|--cron                  Run silently unless we encounter an error
EOF
}


# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parse_params() {
    local param
    while [[ $# -gt 0 ]]; do
        param="$1"
        shift
        case $param in
            -h|--help)
                script_usage
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                ;;
            -nc|--no-colour)
                no_colour=true
                ;;
            -cr|--cron)
                cron=true
                ;;
            *)
                script_exit "Invalid parameter was provided: $param" 2
                ;;
        esac
    done
}


# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
  # shellcheck source=.bashcheck.sh
  source "$(dirname "${BASH_SOURCE[0]}")/.bashcheck.sh"

  trap script_trap_err ERR
  trap script_trap_exit EXIT

  script_init "$@"
  #parse_params "$@"
  cron_init
  colour_init
  #lock_init system

  # input mgmt
    input_1=$1
    if [[ -z "$2" ]]; then
      input_2="not-set"
    else
      input_2=$2
    fi
    if [[ -z "$3" ]]; then
      input_3="not-set"
    else
      input_3=$3
    fi

  $1
}

function lint {
  docker_image="redcoolbeans/dockerlint"

  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    ${docker_image}
}

###___###___###___###___###___###___###___###___###___###___###___###
# git functions

function hash {
  git rev-parse --short HEAD
}
function master {
  git checkout master
}
function edge {
  git checkout edge
}
function check {
  git checkout
}

function push {
  git status && \
  git add -A && \
  git commit -m "${input_2}" && \
  clear
  git push
}

function test {
  echo "\$1 is now $input_1"
  echo "\$2 is now $input_2"
  echo "\$3 is now $input_3"
}

function test2 {
  echo "$1 / $2"
}

# Entrypoint
main "$@"
