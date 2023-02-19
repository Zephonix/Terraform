/*-------------
//policy and role creation
--------------*/
resource "aws_iam_policy" "LambdaToS3Write" {
  name        = "S3PutPolicyLambda"
  path        = "/"
  description = "policy to put file on s3"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "s3:PutObject",
        "Resource" : "*"
      }
    ]
  })
}

output "arn_policy" {
  value = aws_iam_policy.LambdaToS3Write.arn
}

resource "aws_iam_role" "S3PutObjectRoleTf" {
  name        = "S3PutObjectRoleTf"
  description = "role creado desde terraform"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "apigateway.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        }
      }
    ]
  })

}
//asign policy to role
resource "aws_iam_role_policy_attachment" "policy-attach-s3" {
  role       = aws_iam_role.S3PutObjectRoleTf.name
  policy_arn = aws_iam_policy.LambdaToS3Write.arn
}

resource "aws_iam_role_policy_attachment" "policy-attach-lambda" {
  role       = aws_iam_role.S3PutObjectRoleTf.name
  policy_arn = var.arn_lambda
}

resource "aws_iam_role_policy_attachment" "policy-attach-lambda-full" {
  role       = aws_iam_role.S3PutObjectRoleTf.name
  policy_arn = var.arn_lambda_full
}