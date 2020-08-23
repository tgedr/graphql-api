variable "application" {
  type        = string
}

variable "environment" {
  type        = string
#  default     = "dev|prod|sit|spt"
}

variable "function" {
  type        = string
#  default     = "helloworld"
}

variable "aws_region" {
  type        = string
#  default     = "eu-west-1"
}

variable "function_file" {
  type        = string
#  default     = "helloworld.zip"
}

variable "function_runtime" {
  type        = string
  default     = "nodejs12.x"
}

variable "function_memory" {
  type        = number
  default     = 512
}

variable "function_timeout" {
  type        = number
  default     = 30
}

variable "aws_account_id" {
  type        = string
  # default     = "..."
}
