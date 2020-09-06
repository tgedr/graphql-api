module "tf-remote-state" {
  source = "../modules/aws/tf-remote-state"
  environment = "${var.env}"
  application = "${var.app}"
}



