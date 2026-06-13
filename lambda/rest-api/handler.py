import json


# Mock employee database
EMPLOYEES = {
    "EMP001": {
        "id": "EMP001",
        "name": "John Doe",
        "email": "john.doe@company.com",
        "department": "Engineering",
        "position": "Senior Developer",
        "salary": 120000,
    },
    "EMP002": {
        "id": "EMP002",
        "name": "Jane Smith",
        "email": "jane.smith@company.com",
        "department": "Product",
        "position": "Product Manager",
        "salary": 110000,
    },
    "EMP003": {
        "id": "EMP003",
        "name": "Bob Johnson",
        "email": "bob.johnson@company.com",
        "department": "Sales",
        "position": "Sales Executive",
        "salary": 95000,
    },
}


def lambda_handler(event, context):
    """
    Lambda handler for REST API - Get employee details by ID

    Expected event formats:
    1. JSON body: {"employeeId": "EMP001"}
    2. Query string: ?employeeId=EMP001

    Returns:
    {
        "statusCode": 200,
        "body": {employee details}
    }
    or
    {
        "statusCode": 400/404,
        "body": {error message}
    }
    """
    try:
        # Extract employee ID from event
        employee_id = event.get("employeeId")
        
        # If not in direct event, check body (for JSON POST)
        if not employee_id and event.get("body"):
            try:
                body = json.loads(event["body"])
                employee_id = body.get("employeeId")
            except (json.JSONDecodeError, TypeError):
                pass
        
        # If not in body, check query parameters
        if not employee_id:
            query_params = event.get("queryStringParameters") or {}
            employee_id = query_params.get("employeeId")
        
        # If still not found, check path parameters
        if not employee_id:
            path_params = event.get("pathParameters") or {}
            employee_id = path_params.get("employeeId")

        if not employee_id:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "employeeId is required"}),
            }

        # Look up employee
        employee = EMPLOYEES.get(employee_id)

        if not employee:
            return {
                "statusCode": 404,
                "body": json.dumps(
                    {"error": f"Employee {employee_id} not found"}
                ),
            }

        return {
            "statusCode": 200,
            "body": json.dumps(employee),
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
