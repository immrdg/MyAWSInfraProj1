import json
from handler import lambda_handler, EMPLOYEES


class TestLambdaHandler:
    """Test suite for Lambda handler - Employee Details API"""

    # ============================================================================
    # Basic Functionality Tests
    # ============================================================================

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

    # ============================================================================
    # Error Handling Tests
    # ============================================================================

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

    def test_handler_returns_400_for_none_employee_id(self):
        """Test that handler returns 400 when employeeId is None"""
        event = {"employeeId": None}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400
        body = json.loads(response["body"])
        assert "error" in body

    def test_handler_returns_404_for_whitespace_only_employee_id(self):
        """Test that handler returns 404 when employeeId is whitespace only (not in database)"""
        event = {"employeeId": "   "}
        response = lambda_handler(event, {})
        # Whitespace-only IDs are not in the database, so should return 404
        assert response["statusCode"] == 404

    def test_handler_returns_500_on_exception(self):
        """Test that handler returns 500 on unexpected error"""
        # Pass invalid event type to trigger exception handling
        event = None
        response = lambda_handler(event, {})
        assert response["statusCode"] == 500
        body = json.loads(response["body"])
        assert "error" in body

    # ============================================================================
    # Data Validation Tests
    # ============================================================================

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

    def test_handler_response_has_status_code(self):
        """Test that response always has statusCode"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        assert "statusCode" in response
        assert isinstance(response["statusCode"], int)

    def test_handler_response_has_body(self):
        """Test that response always has body"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        assert "body" in response
        assert isinstance(response["body"], str)

    def test_employee_data_integrity(self):
        """Test that all employee data is returned correctly"""
        for emp_id in ["EMP001", "EMP002", "EMP003"]:
            event = {"employeeId": emp_id}
            response = lambda_handler(event, {})
            assert response["statusCode"] == 200
            body = json.loads(response["body"])
            # Verify against mock data
            expected = EMPLOYEES[emp_id]
            assert body == expected

    # ============================================================================
    # Input Priority & Resolution Tests
    # ============================================================================

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

    def test_handler_prioritizes_direct_over_body(self):
        """Test that direct event takes priority over JSON body"""
        event = {
            "employeeId": "EMP001",
            "body": json.dumps({"employeeId": "EMP002"})
        }
        response = lambda_handler(event, {})
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"

    def test_handler_prioritizes_body_over_query(self):
        """Test that JSON body takes priority over query parameters"""
        event = {
            "body": json.dumps({"employeeId": "EMP001"}),
            "queryStringParameters": {"employeeId": "EMP002"}
        }
        response = lambda_handler(event, {})
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"

    def test_handler_prioritizes_query_over_path(self):
        """Test that query parameters take priority over path parameters"""
        event = {
            "queryStringParameters": {"employeeId": "EMP001"},
            "pathParameters": {"employeeId": "EMP002"}
        }
        response = lambda_handler(event, {})
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"

    def test_handler_uses_path_when_others_empty(self):
        """Test that handler uses path parameters when others are empty"""
        event = {
            "queryStringParameters": None,
            "pathParameters": {"employeeId": "EMP003"}
        }
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP003"

    # ============================================================================
    # Edge Cases & Boundary Tests
    # ============================================================================

    def test_handler_with_empty_query_string_parameters(self):
        """Test that handler handles empty queryStringParameters"""
        event = {"queryStringParameters": {}}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400

    def test_handler_with_none_query_string_parameters(self):
        """Test that handler handles None queryStringParameters"""
        event = {"queryStringParameters": None}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400

    def test_handler_with_empty_path_parameters(self):
        """Test that handler handles empty pathParameters"""
        event = {"pathParameters": {}}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400

    def test_handler_with_none_path_parameters(self):
        """Test that handler handles None pathParameters"""
        event = {"pathParameters": None}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400

    def test_handler_with_malformed_json_body(self):
        """Test that handler handles malformed JSON gracefully"""
        event = {"body": "invalid json {{{"}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 400

    def test_handler_with_extra_fields_in_event(self):
        """Test that handler ignores extra fields in event"""
        event = {
            "employeeId": "EMP001",
            "extra_field": "should be ignored",
            "another": "also ignored"
        }
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"

    def test_handler_with_case_sensitive_id(self):
        """Test that employee IDs are case-sensitive"""
        event = {"employeeId": "emp001"}  # lowercase
        response = lambda_handler(event, {})
        assert response["statusCode"] == 404

    def test_handler_with_similar_but_wrong_id(self):
        """Test that similar but wrong IDs return 404"""
        similar_ids = ["EMP01", "EMP0001", "EMP001 ", " EMP001"]
        for emp_id in similar_ids:
            # Don't strip - test exact matching
            event = {"employeeId": emp_id}
            response = lambda_handler(event, {})
            # Only exact matches in EMPLOYEES database should return 200
            if emp_id in EMPLOYEES:
                assert response["statusCode"] == 200
            else:
                assert response["statusCode"] == 404

    # ============================================================================
    # Field Content Validation Tests
    # ============================================================================

    def test_emp001_complete_details(self):
        """Test EMP001 has all correct details"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"
        assert body["name"] == "John Doe"
        assert body["email"] == "john.doe@company.com"
        assert body["department"] == "Engineering"
        assert body["position"] == "Senior Developer"
        assert body["salary"] == 120000

    def test_emp002_complete_details(self):
        """Test EMP002 has all correct details"""
        event = {"employeeId": "EMP002"}
        response = lambda_handler(event, {})
        body = json.loads(response["body"])
        assert body["id"] == "EMP002"
        assert body["name"] == "Jane Smith"
        assert body["email"] == "jane.smith@company.com"
        assert body["department"] == "Product"
        assert body["position"] == "Product Manager"
        assert body["salary"] == 110000

    def test_emp003_complete_details(self):
        """Test EMP003 has all correct details"""
        event = {"employeeId": "EMP003"}
        response = lambda_handler(event, {})
        body = json.loads(response["body"])
        assert body["id"] == "EMP003"
        assert body["name"] == "Bob Johnson"
        assert body["email"] == "bob.johnson@company.com"
        assert body["department"] == "Sales"
        assert body["position"] == "Sales Executive"
        assert body["salary"] == 95000

    # ============================================================================
    # Integration & HTTP Compatibility Tests
    # ============================================================================

    def test_handler_with_api_gateway_http_event_format(self):
        """Test handler with realistic HTTP API Gateway event format"""
        event = {
            "version": "2.0",
            "routeKey": "$default",
            "rawPath": "/",
            "queryStringParameters": {"employeeId": "EMP001"},
            "headers": {"content-type": "application/json"},
            "requestContext": {
                "http": {
                    "method": "GET",
                    "path": "/",
                    "sourceIp": "192.168.1.1"
                }
            }
        }
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP001"

    def test_handler_with_post_event_format(self):
        """Test handler with POST event containing JSON body"""
        event = {
            "version": "2.0",
            "routeKey": "POST /",
            "rawPath": "/",
            "body": json.dumps({"employeeId": "EMP002"}),
            "headers": {"content-type": "application/json"},
            "isBase64Encoded": False,
            "requestContext": {
                "http": {
                    "method": "POST",
                    "path": "/"
                }
            }
        }
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200
        body = json.loads(response["body"])
        assert body["id"] == "EMP002"

    def test_response_structure_matches_http_format(self):
        """Test that response structure matches HTTP API Gateway format"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        
        # Check response structure
        assert isinstance(response, dict)
        assert "statusCode" in response
        assert "body" in response
        assert response["statusCode"] in [200, 400, 404, 500]
        
        # Body should always be a string
        assert isinstance(response["body"], str)
        
        # Body should be valid JSON
        json.loads(response["body"])

    # ============================================================================
    # HTTP Status Code Tests
    # ============================================================================

    def test_200_status_for_valid_employee(self):
        """Test that valid employee request returns 200"""
        for emp_id in ["EMP001", "EMP002", "EMP003"]:
            event = {"employeeId": emp_id}
            response = lambda_handler(event, {})
            assert response["statusCode"] == 200

    def test_400_status_for_missing_id(self):
        """Test that missing employee ID returns 400"""
        test_cases = [
            {},
            {"employeeId": ""},
            {"employeeId": None},
            {"queryStringParameters": None},
        ]
        for event in test_cases:
            response = lambda_handler(event, {})
            assert response["statusCode"] == 400

    def test_404_status_for_missing_employee(self):
        """Test that non-existent employee returns 404"""
        invalid_ids = ["EMP999", "EMP000", "INVALID", ""]
        for emp_id in invalid_ids[:-1]:  # Exclude empty string (400 case)
            event = {"employeeId": emp_id}
            response = lambda_handler(event, {})
            assert response["statusCode"] == 404

    def test_500_status_on_unexpected_error(self):
        """Test that unexpected errors return 500"""
        event = None
        response = lambda_handler(event, {})
        assert response["statusCode"] == 500

    # ============================================================================
    # Context Parameter Tests
    # ============================================================================

    def test_handler_with_empty_context(self):
        """Test that handler works with empty context"""
        event = {"employeeId": "EMP001"}
        response = lambda_handler(event, {})
        assert response["statusCode"] == 200

    def test_handler_with_context_object(self):
        """Test that handler works with various context objects"""
        event = {"employeeId": "EMP001"}
        
        # Mock context objects
        mock_contexts = [
            {},
            {"function_name": "private-api-rest-api-dev"},
            {"aws_request_id": "12345"},
            {"remaining_time_in_millis": 30000},
        ]
        
        for context in mock_contexts:
            response = lambda_handler(event, context)
            assert response["statusCode"] == 200
