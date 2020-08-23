module "tf-remote-state" {
  source = "../modules/tf-remote-state"
  environment = "${var.env}"
  application = "${var.app}"
}



