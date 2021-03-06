module "graphql-api" {
  source = "../modules/aws/graphql-api"
  api = "${var.application}"
  environment = "${var.environment}"
  function = "${var.function}"
  region = "${var.aws_region}"
  function-artifact-location = "${var.function_file}"
  function-runtime = "${var.function_runtime}"
  function-memory = "${var.function_memory}"
  function-timeout = "${var.function_timeout}"
}



