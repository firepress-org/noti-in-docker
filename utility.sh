#!/usr/bin/env bash

#set -o nounset          # Disallow expansion of unset variables
# --- Find bad variables by using `./utility.sh test two three`, else disable it
# --- or remove $1, $2, $3 var defintions in @main

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)



### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# DOCKER
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
function lint {
  docker_image="redcoolbeans/dockerlint"

  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    ${docker_image}
}

function figlet {
  docker_image="devmtl/figlet:1.0"
  message="Hey figlet"

  docker run --rm ${docker_image} ${message}
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# Git
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

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
function ver {    # version
  App_is_input2_empty
  tag_version="${input_2}"

  echo "Do we need to first update CHANGELOG.md ?" sleep 5;

  sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"$tag_version\"/" Dockerfile 

  git add . && \
  git commit -m "Updated to version: $tag_version" && \
  git push && \
  sleep 1 && \
  # push tag
  git tag ${tag_version} && \
  git push --tags && \

  echo "Then, execute: release";
  
  # vars
  #GITHUB_TOKEN="3122133122133211233211233211233211322313123"
  #local_repo="$Users/.../docker-stack-this"

  # Find the latest tag
  tag_version="$(git tag --sort=-creatordate | head -n1)" && \
  echo ${tag_version} && \

  user="firepress-org"
  git_repo="ghostfire"
  GOPATH=$(go env GOPATH)

  # Requires https://github.com/aktau/github-release
  $GOPATH/bin/github-release release \
    --user ${user} \
    --repo ${git_repo} \
    --tag ${tag_version} \
    --name ${tag_version} \
    --description "Refer to [CHANGELOG.md](https://github.com/firepress-org/ghostfire/blob/master/CHANGELOG.md) for details about this release."

}
function version {
  ver
}
function tag {
  echo "Look for 'ver' instead."
}
function push {

  App_is_input2_empty

  git status && \
  git add -A && \
  git commit -m "${input_2}" && \
  clear
  git push
}

function App_is_input2_empty {
  if [[ -z "$2" ]]; then    #if empty
    echo "Error: You must provid a Git message."
    echo '       example: ./utility.sh push "Add this great feature"'
    App_stop
  fi
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# OTHER
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

function test {
  echo "\$1 is now ${input_1}"
  echo "\$2 is now ${input_2}"
  echo "\$3 is now ${input_3}"
  # Useful when trying to find bad variables along 'set -o nounset'
}

function App_stop {
  echo && exit 1
}

function doc {
cat << EOF
  Doc (documentation):

  This text is used as a placeholder. Words that will follow won't
  make any sense and this is fine. At the moment, the goal is to 
  build a structure for our site.

  Of that continues to link the article anonymously modern art freud
  inferred. Eventually primitive brothel scene with a distinction. The
  Enlightenment criticized from the history.
EOF
}
function docs { 
  doc
}

function main() {

  # input mgmt
  input_1=$1
  if [[ -z "$1" ]]; then    #if empty
    clear
    echo "Oups, you must provided at least one attribute."
    App_stop
  else
    input_1=$1
  fi

  if [[ -z "$2" ]]; then    #if empty
    input_2="not-set"
  else
    input_2=$2
  fi

  if [[ -z "$3" ]]; then    #if empty
    input_3="not-set"
  else
    input_3=$3
  fi

  # shellcheck source=.bashcheck.sh
  source "$(dirname "${BASH_SOURCE[0]}")/.bashcheck.sh"

  trap script_trap_err ERR
  trap script_trap_exit EXIT

  script_init "$@"
  cron_init
  colour_init
  #lock_init system

  clear
  $1
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# ENTRYPOINT
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
main "$@"
echo && pwd && echo
# https://github.com/firepress-org/bash-script-template