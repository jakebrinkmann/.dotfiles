from dataclasses import dataclass
from app import lambda_handler
import pytest

@pytest.fixture
def lambda_context():
    @dataclass
    class LambdaContext:
        function_name: str = "test"
        memory_limit_in_mb: int = 128
        invoked_function_arn: str = "arn:aws:lambda:eu-west-1:123456789012:function:test"
        aws_request_id: str = "da658bd3-2d6f-4e7b-8ec2-937234644fdc"

    return LambdaContext()


def test_lambda_handler(lambda_context):
    minimal_event = {
        "path": "/todos",
        "httpMethod": "GET",
        "requestContext": {"requestId": "227b78aa-779d-47d4-a48e-ce62120393b8"},  # correlation ID
    }
    # Example of API Gateway REST API request event:
    # https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html#apigateway-example-event
    ret = lambda_handler(minimal_event, lambda_context)
    assert ret["statusCode"] == 200
    assert ret["body"] != ""
