# ------------------------------------------
# ---------- CONSTANTS SECTION -------------
export MODULES_URL=https://github.com/jtviegas/terraform-modules/trunk/modules
export TERRAFORM_DIR=terraform
export TERRAFORM_STATE_DIR="${TERRAFORM_DIR}/tf-remote-state"
export TERRAFORM_RESOURCES_DIR="${TERRAFORM_DIR}/resources"
export TERRAFORM_RESOURCES_CONFIG_TEMPLATE="$TERRAFORM_DIR/config_tf.template"
export TERRAFORM_RESOURCES_CONFIG="$TERRAFORM_RESOURCES_DIR/config.tf"

# ------------------------------------------
# ---------- CUSTOMISABLE SECTION ----------

export APPLICATION=tgedr-graphql
export AWS_REGION=eu-west-1

# --- stage
export ENVIRONMENT=dev

# --- function
export FUNCTION_NAME=helloworld
export FUNCTION_FILE=helloworld.zip
export FUNCTION_REPO="tgedr/function-helloworld"


