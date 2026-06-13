import json
from handler import lambda_handler


class TestLambdaHandler:
    """Test suite for Lambda handler - Employee Details API"""

    def test_handler_returns_employee_details_with_valid_id(self):
        """Test that handler returns employee details for valid employee ID"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"
        assert body["name"] == "John Doe"
        assert body["email"] == "john.doe@company.com"

    def test_handler_returns_employee_details_from_json_body(self):
        """Test that handler extracts employeeId from JSON body"""
        event = {"body": json.dumps({"employeeId": "EMP001"})}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"
        assert body["name"] == "John Doe"

    def test_handler_returns_employee_details_from_query_parameters(self):
        """Test that handler extracts employeeId from query parameters"""
        event = {"queryStringParameters": {"employeeId": "EMP002"}}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP002"
        assert body["name"] == "Jane Smith"

    def test_handler_returns_employee_details_from_path_parameters(self):
        """Test that handler extracts employeeId from pathParameters"""
        event = {"pathParameters": {"employeeId": "EMP003"}}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP003"
        assert body["name"] == "Bob Johnson"

    def test_handler_returns_404_for_nonexistent_employee(self):
        """Test that handler returns 404 for employee not found"""
        event = {"employeeId": "EMP999"}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 404
        body = json.loads(response["body"])
        assert "error" in body
        assert "not found" in body["error"]

    def test_handler_returns_400_for_missing_employee_id(self):
        """Test that handler returns 400 when employeeId is missing"""
        event = {}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400
        body = json.loads(response["body"])
        assert "error" in body
        assert "required" in body["error"]

    def test_handler_returns_400_for_empty_employee_id(self):
        """Test that handler returns 400 when employeeId is empty"""
        event = {"employeeId": ""}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400
        body = json.loads(response["body"])
        assert "error" in body

    def test_handler_returns_all_employee_fields(self):
        """Test that handler returns all employee fields"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert "id" in body
        assert "name" in body
        assert "email" in body
        assert "department" in body
        assert "position" in body
        assert "salary" in body

    def test_handler_returns_valid_json_response(self):
        """Test that handler returns valid JSON"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        # Should not raise an exception
        json.loads(response["body"])
        assert isinstance(response["body"], str)

    def test_handler_returns_500_on_exception(self):
        """Test that handler returns 500 on unexpected error"""
        # Pass invalid event type to trigger exception handling
        event = None
        response = lambda_handler(event, {})
        assert response["statusCode"] == 500
        body = json.loads(response["body"])
        assert "error" in body

    def test_handler_prioritizes_direct_event_over_query_parameters(self):
        """Test that direct event takes priority over query parameters"""
        event = {
            "employeeId": "EMP001",
            "queryStringParameters": {"employeeId": "EMP002"}
        }
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"  # Should use direct event, not query param
