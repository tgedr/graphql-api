MODULES_DIR=modules
MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules
export DB_CONTAINER=dynamodb4test
export DYNDBSTORE_TEST_ENDPOINT="http://localhost:8000"
export DB_IMAGE="amazon/dynamodb-local"
export TERRAFORM_STATE_DIR=terraform/state
export TERRAFORM_DIR=terraform
export APPLICATION=tgedr-generic-app
export ENVIRONMENT=dev
AWS_REGION=eu-west-1