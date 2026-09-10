import json

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    api_request = "requestContext" in event and "http" in event["requestContext"]

    if api_request:
        try:
            body = json.loads(event.get("body") or "{}")
        except json.JSONDecodeError:
            return http_response(400, {"message": "Invalid JSON request"})
    else:
        body = event

    order_id = body.get("orderId")
    amount = body.get("amount", 0)
    simulate_failure = body.get("simulateFailure", False)

    if simulate_failure:
        raise Exception("Deliberate failure for retry and destination testing")

    if not order_id:
        result = {"status": "REJECTED", "reason": "orderId is required"}
        status_code = 400
    elif amount <= 0:
        result = {
            "orderId": order_id,
            "status": "REJECTED",
            "reason": "Amount must be greater than zero"
        }
        status_code = 400
    else:
        result = {
            "orderId": order_id,
            "amount": amount,
            "status": "ACCEPTED",
            "message": "Order accepted for processing"
        }
        status_code = 200

    if api_request:
        return http_response(status_code, result)
    return result


def http_response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": {"content-type": "application/json"},
        "body": json.dumps(body)
    }