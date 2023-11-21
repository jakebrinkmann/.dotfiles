import json

from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.data_classes import EventBridgeEvent, event_source
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger(service="APP")


def hello(detail):
    return {"statusCode": 200, "body": json.dumps({"message": f"hello {detail}!"})}


@event_source(data_class=EventBridgeEvent)
def lambda_handler(event: EventBridgeEvent, context: LambdaContext = None):
    hello(event.detail)
