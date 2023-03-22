/*-------------
//APIGateway Creation
--------------*/
resource "aws_api_gateway_rest_api" "api" {
  name        = "terraformAPII"
  description = "created from terraform"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "add"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
  credentials             = aws_iam_role.S3PutObjectRoleTf.arn
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

/*-------------
//deploy API
--------------*/

resource "aws_api_gateway_deployment" "deploy_api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method_response.response_200, aws_api_gateway_integration.integration
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deploy_api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}

/*-------------
//Query path and URL
--------------*/
data "aws_api_gateway_rest_api" "my_rest_api" {
  name = "terraformAPI"
  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}

data "aws_api_gateway_resource" "my_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.my_rest_api.id
  path        = "/add"
  depends_on = [
    data.aws_api_gateway_rest_api.my_rest_api
  ]
}

output "url" {
  value = aws_api_gateway_stage.stage.invoke_url
}

output "path" {
  value = data.aws_api_gateway_resource.my_resource.path
}