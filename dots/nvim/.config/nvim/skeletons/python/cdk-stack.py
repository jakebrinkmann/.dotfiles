from aws_cdk import CfnOutput, Stack
from constructs import Construct


class MyCdkPythonStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        CfnOutput(self, "QUEUE_URL", value="...")
        CfnOutput(self, "PIPE_ARN", value="...")
        CfnOutput(self, "STATE_MACHINE_ARN", value="...")
