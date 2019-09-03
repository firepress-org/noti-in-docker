#!/usr/bin/env bash
# GNU v3 | Please credit my work if you are re-using some of it :)
# by Pascal Andy | https://pascalandy.com/blog/now/
set -eou

docker_image="redcoolbeans/dockerlint"

function fct_lint {
  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    ${docker_image}
}

function main() {
  clear
  fct_lint
}

# --- Entrypoint
main "$@"
