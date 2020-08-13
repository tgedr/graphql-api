#!/bin/bash

# http://bash.cumulonim.biz/NullGlob.html
shopt -s nullglob

this_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -z "$this_folder" ]; then
  this_folder=$(dirname $(readlink -f $0))
fi

debug(){
    local __msg="$1"
    echo " [DEBUG] `date` ... $__msg "
}

info(){
    local __msg="$1"
    echo " [INFO]  `date` ->>> $__msg "
}

warn(){
    local __msg="$1"
    echo " [WARN]  `date` *** $__msg "
}

err(){
    local __msg="$1"
    echo " [ERR]   `date` !!! $__msg "
}

if [ ! -f "$this_folder/variables.inc" ]; then
  warn "we DON'T have a 'variables.inc' file"
else
  . "$this_folder/variables.inc"
fi

if [ ! -f "$this_folder/secrets.inc" ]; then
  warn "we DON'T have a 'secrets.inc' file"
else
  . "$this_folder/secrets.inc"
fi

verify(){
  info "[verify] ..."
  local _r=0

  which npm 1>/dev/null
  if [ ! "$?" -eq "0" ] ; then err "please install npm" && return 1; fi

  which svn 1>/dev/null
  if [ ! "$?" -eq "0" ] ; then err "please install svn" && return 1; fi

  which terraform 1>/dev/null
  if [ ! "$?" -eq "0" ] ; then err "please install terraform" && return 1; fi

  info "[verify] ...done."
}


dependencies(){
  info "[dependencies] ..."
  _pwd=`pwd`
  cd "$this_folder"
  # npm install -g something
  # if [ ! "$?" -eq "0" ]; then err "[dependencies] could not install something" && cd "$_pwd" && return 1; fi
  cd "$_pwd"
  info "[dependencies] ...done."
}

publish(){
  info "[publish] ..."
  _pwd=`pwd`
  cd "$this_folder"
  npm config set "//${NPM_REGISTRY}/:_authToken" "${NPM_TOKEN}"
  npm publish . --access="public"
  if [ ! "$?" -eq "0" ]; then err "[publish] could not publish" && cd "$_pwd" && return 1; fi
  cd "$_pwd"
  info "[publish] ...done."
}

test(){
  info "[test] ..."
  _pwd=`pwd`

  info "...starting db container..."
  docker run -d -p 8000:8000 --name $DB_CONTAINER "$DB_IMAGE"
  if [ ! "$?" -eq "0" ]; then err "[test] could not kick off db image" && return 1; fi

  local __r=0

  cd "$this_folder"
  node_modules/istanbul/lib/cli.js cover node_modules/mocha/bin/_mocha -- -R spec test/*.js
  __r=$?
  if [ ! "$__r" -eq "0" ]; then err "[test] could not test and check coverage" ; fi

  cd "$_pwd"
  info "...stopping db container..."
  docker stop $DB_CONTAINER && docker rm $DB_CONTAINER

  info "[test] ...done."
  return $__r
}

terraformStateOn(){
  info "[terraformStateOn] ..."
  _pwd=`pwd`

  cd "$this_folder/$TERRAFORM_DIR"
  svn export -q "$MODULES_URL" "$MODULES_DIR"
  if [ ! "$?" -eq "0" ]; then err "[terraformState] could not download terraform modules" && cd "$_pwd" && return 1; fi

  cd "$this_folder/$TERRAFORM_STATE_DIR"

  terraform init
  terraform plan -var "region=$AWS_REGION" -var "app=$APPLICATION" -var "env=$ENVIRONMENT"
  terraform apply -var "region=$AWS_REGION" -var "app=$APPLICATION" -var "env=$ENVIRONMENT" -auto-approve -lock=true -lock-timeout=5m
  local outcome=$?
  cd "$_pwd"
  rm -r "$this_folder/$TERRAFORM_DIR/$MODULES_DIR"
  if [ ! "$outcome" -eq "0" ]; then err "[terraformStateOn] could not setup terraform remote state" && return 1; fi

  info "[terraformStateOn] ...done."
}

terraformStateOff(){
  info "[terraformStateOff] ..."
  _pwd=`pwd`

  cd "$this_folder/$TERRAFORM_DIR"
  svn export -q "$MODULES_URL" "$MODULES_DIR"
  if [ ! "$?" -eq "0" ]; then err "[terraformStateOff] could not download terraform modules" && cd "$_pwd" && return 1; fi

  cd "$this_folder/$TERRAFORM_STATE_DIR"

  terraform init
  terraform destroy -var "region=$AWS_REGION" -var "app=$APPLICATION" -var "env=$ENVIRONMENT" -auto-approve -lock=true -lock-timeout=5m
  local outcome=$?
  cd "$_pwd"
  rm -r "$this_folder/$TERRAFORM_DIR/$MODULES_DIR"
  if [ ! "$outcome" -eq "0" ]; then err "[terraformStateOff] could not remove terraform remote state" && return 1; fi

  info "[terraformStateOff] ...done."
}

deploy(){
  info "[publish] ..."
  _pwd=`pwd`
  cd "$this_folder"
  npm config set "//${NPM_REGISTRY}/:_authToken" "${NPM_TOKEN}"
  npm publish . --access="public"
  if [ ! "$?" -eq "0" ]; then err "[publish] could not publish" && cd "$_pwd" && return 1; fi
  cd "$_pwd"
  info "[publish] ...done."
}

usage() {
  cat <<EOM
  usage:
  $(basename $0) {
                  tf-state {on|off}
                  }

      - tf-state: sets up or removes terraform remote state on aws (bucket for state and dynamo db table for lock)

EOM
  exit 1
}

verify

debug "1: $1 2: $2 3: $3 4: $4 5: $5 6: $6 7: $7 8: $8 9: $9"


case "$1" in
  tf-state)
    case "$2" in
      on)
        terraformStateOn
        ;;
      off)
        terraformStateOff
        ;;
      *)
        usage
        ;;
    esac
    ;;
  test)
    test
    ;;
  *)
    usage
    ;;
esac