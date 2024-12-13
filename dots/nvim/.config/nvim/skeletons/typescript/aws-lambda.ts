import { DynamoDB } from "aws-sdk";

const TABLE_NAME = "orders";
const REGION = "us-east-1";

const ddb = new DynamoDB.DocumentClient({ region: REGION });

export const handler = async (event: any, context: any) => {
  try {
    const pathParameters = event.pathParameters;
    if (!pathParameters) {
      return { statusCode: 400, body: "Missing path parameters" };
    }

    const orderId = pathParameters.order_id;
    if (!orderId) {
      return { statusCode: 400, body: "Missing order_id" };
    }

    const storeId = pathParameters.store_id;
    if (!storeId) {
      return { statusCode: 400, body: "Missing store_id" };
    }

    const params = {
      TableName: TABLE_NAME,
      Key: {
        order_id: orderId,
        store_id: storeId,
      },
    };

    const response = await ddb.get(params).promise();
    const order = response.Item;

    if (order) {
      return {
        statusCode: 200,
        body: JSON.stringify(order),
      };
    } else {
      return {
        statusCode: 404,
        body: `Order ${orderId} not found`,
      };
    }
  } catch (error) {
    console.error("Error fetching order:", error);
    return {
      statusCode: 500,
      body: `Internal Server Error: ${error.message}`,
    };
  }
};
