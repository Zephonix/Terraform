/*-------------
//variables file
--------------*/
variable "region" {
  default = "us-east-1"
}

variable "access_key" {
  default = "x"
}

variable "secret_key" {
  default = "cc"
}

variable "arn_lambda" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "arn_lambda_full" {
  type    = string
  default = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}
