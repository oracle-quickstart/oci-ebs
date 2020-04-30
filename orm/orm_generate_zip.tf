/*Copyright © 2020, Oracle and/or its affiliates.

The Universal Permissive License (UPL), Version 1.0*/

data "archive_file" "generate_zip" {
  type        = "zip"
  output_path = "${path.module}/dist/ebusinesssuite.zip"
  source_dir = "../"
  excludes    = [".gitignore" , "terraform.tfstate" , "terraform.tfstate.backup" , "terraform.tfvars", ".terraform", "_docs" , "orm" , ".git", "env-vars" ]
}
