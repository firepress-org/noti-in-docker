#!/usr/bin/env bash
# GNU v3 | Please credit my work if you are re-using some of it :)
# by Pascal Andy | https://pascalandy.com/blog/now/
set -eou



function lint {
  docker_image="redcoolbeans/dockerlint"
  
  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    ${docker_image}
}

function tag {
  echo "todo"
}

function main() {
  clear
  $1
}

# --- Entrypoint
# run example
# ./utility lint
main "$@"