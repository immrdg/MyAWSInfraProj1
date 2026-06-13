resource "aws_apigatewayv2_api" "main" {
  name          = "${var.api_name}-${var.environment}"
  protocol_type = "HTTP"
  description   = "REST API Gateway for ${var.api_name} - ${var.environment}"

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.api_name}-${var.environment}"
    }
  )
}

# Note: HTTP APIs (APIGatewayV2) do not have a test feature in AWS Console.
# If you need console testing, you would need to switch to REST API (APIGateway V1).
# REST APIs are more expensive ($3.50/M requests vs $0.30/M for HTTP),
# but they have the full test feature with mock integration.
#
# For now, testing is recommended via:
# 1. curl command line
# 2. CloudWatch logs (API_DOCUMENTATION.md)
# 3. External tools (Postman, Insomnia)
# 4. AWS Lambda console (invoke Lambda directly with test events)

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
      integrationLatency = "$context.integration.latency"
      error          = "$context.error.message"
      errorType      = "$context.error.messageString"
    })
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.api_name}-${var.environment}-stage"
    }
  )

  depends_on = [aws_cloudwatch_log_group.api_logs]
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/${var.api_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "${var.api_name}-${var.environment}-logs"
    }
  )
}

# Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.lambda_invoke_arn
  payload_format_version = "2.0"
}

# Default route for all methods and paths (catch-all)
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = var.authorization_type
}

# Explicit GET route for testing in console
resource "aws_apigatewayv2_route" "get_root" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = var.authorization_type
}

# Explicit POST route for testing in console
resource "aws_apigatewayv2_route" "post_root" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = var.authorization_type
}

# Lambda permission for API Gateway invocation
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
