
/*-------------
//LAMBDA CREATION
--------------*/

resource "aws_lambda_function" "test_lambda" {
  runtime       = "python3.9"
  filename      = "code.zip"
  function_name = "lambaTerraform"
  handler       = "code.lambda_handler"
  role          = aws_iam_role.S3PutObjectRoleTf.arn
}

output "arn_lambda" {
  value = aws_lambda_function.test_lambda.arn
}

output "arn_lambda_arn" {
  value = aws_lambda_function.test_lambda.invoke_arn
}
