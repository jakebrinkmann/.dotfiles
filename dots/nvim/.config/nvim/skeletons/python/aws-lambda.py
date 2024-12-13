import boto3  # aws sdk

TABLE_NAME = "orders"
REGION = "us-east-1"

ddb_resource = boto3.resource("dynamodb", region_name=REGION)
table = ddb_resource.Table(TABLE_NAME)


def handler(event, context):
    try:
        path_params = event.get("pathParameters")
        if not path_params:
            return {"statusCode": 400, "body": "Missing path parameters"}

        order_id = path_params.get("order_id")
        if not order_id:
            return {"statusCode": 400, "body": "Missing order_id"}

        store_id = path_params.get("store_id")
        if not store_id:
            return {"statusCode": 400, "body": "Missing store_id"}

        response = table.get_item(
            Key={"order_id": {"S": order_id}, "store_id": {"S": store_id}}
        )
        order = response.get("Item")

        if order:
            return {"statusCode": 200, "body": order}
        else:
            return {"statusCode": 404, "body": f"order {order_id} not found"}

    except Exception as e:
        return {"statusCode": 500, "body": f"Internal Server Error: {str(e)}"}
