#!/usr/bin/env bash

# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob

this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi
parent_folder=$(dirname "$this_folder")

. "$this_folder/bashutils.inc"

update_bashutils() {
  echo "[update_bashutils] ..."

  _pwd=$(pwd)
  cd "$this_folder"

  curl -s https://api.github.com/repos/tgedr/bashutils/releases/latest |
    grep "browser_download_url.*utils\.tar\.bz2" |
    cut -d '"' -f 4 | wget -qi -
  tar xjpvf utils.tar.bz2
  if [ ! "$?" -eq "0" ]; then echo "[update_bashutils] could not untar it" && cd "$_pwd" && return 1; fi
  rm utils.tar.bz2

  cd "$_pwd"
  echo "[update_bashutils] ...done."
}

usage() {
  cat <<EOM
  usage:
  $(basename $0) {
                  update-bashutils
                  tf-state {on|off}
                  deploy
                  undeploy
                  }

      - update-bashutils: updates local bashutils include file
      - tf-state: sets up or removes terraform remote state on aws (bucket for state and dynamo db table for lock)
      - deploy - deploys resources to aws
      - undeploy - destroys resources from aws

EOM
  exit 1
}

debug "1: $1 2: $2 3: $3 4: $4 5: $5 6: $6 7: $7 8: $8 9: $9"

case "$1" in
  update-bashutils)
    update_bashutils
    ;;
  deploy)
    # shellcheck disable=SC2119
    tf_resources_for_graphql_api_on
    ;;
  undeploy)
    # shellcheck disable=SC2119
    tf_resources_for_graphql_api_off
    ;;
  tf-state)
    case "$2" in
    on)
      tf_state_on
      ;;
    off)
      tf_state_off
      ;;
    *)
      usage
      ;;
    esac
    ;;
  *)
    usage
    ;;
esac
