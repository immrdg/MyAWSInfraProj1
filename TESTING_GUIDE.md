# API Gateway Testing Guide

## Why Can't I See Test Window for $default Route?

AWS API Gateway's test feature in the console has a limitation: **it doesn't support the `$default` route directly**. The `$default` route is a catch-all that matches all HTTP methods and paths, which makes the console test feature unable to determine what test request to send.

### Solution Implemented

I've added **explicit routes** alongside the `$default` catch-all:

1. **`GET /`** - Explicit GET route for testing in console
2. **`POST /`** - Explicit POST route for testing in console  
3. **`$default`** - Still there as fallback for all other paths/methods

This gives you **multiple ways to test**:

---

## Testing Methods

### 1. Using AWS Console Test Window (Now Available!)

**Steps:**
1. Go to AWS API Gateway console
2. Select your API (`private-api-api-dev`)
3. Click on **Routes** → Select **GET /** or **POST /**
4. Click **Test** button
5. Enter test payload

**Example for GET /:**
- Method: GET
- Query String: `?employeeId=EMP001`
- Click Test

**Response:**
```json
{
  "id": "EMP001",
  "name": "John Doe",
  "email": "john.doe@company.com",
  "department": "Engineering",
  "position": "Senior Developer",
  "salary": 120000
}
```

---

### 2. Using curl (Recommended for CLI)

**GET with Query Parameters:**
```bash
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001"
```

**POST with JSON Body:**
```bash
curl -X POST "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/" \
  -H "Content-Type: application/json" \
  -d '{"employeeId": "EMP001"}'
```

**Pretty Print with jq:**
```bash
curl -s "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001" | jq
```

---

### 3. Using Postman

1. Create new request
2. Method: GET
3. URL: `https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001`
4. Click Send

Or for POST:
1. Method: POST
2. URL: `https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/`
3. Body → Raw → JSON:
   ```json
   {"employeeId": "EMP001"}
   ```
4. Click Send

---

### 4. Using Python

```python
import requests

# GET request
response = requests.get(
    "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/",
    params={"employeeId": "EMP001"}
)
print(response.json())

# POST request
response = requests.post(
    "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/",
    json={"employeeId": "EMP001"}
)
print(response.json())
```

---

### 5. Using Node.js/JavaScript

```javascript
// Fetch GET
fetch("https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001")
  .then(r => r.json())
  .then(data => console.log(data));

// Fetch POST
fetch("https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/", {
  method: "POST",
  headers: {"Content-Type": "application/json"},
  body: JSON.stringify({"employeeId": "EMP001"})
})
  .then(r => r.json())
  .then(data => console.log(data));
```

---

## API Routes

Your API now has three routes:

| Route Key | Method | Path | Test Window? | Use Case |
|-----------|--------|------|--------------|----------|
| `GET /` | GET | `/` | ✅ Yes | Root path GET requests |
| `POST /` | POST | `/` | ✅ Yes | Root path POST requests |
| `$default` | ALL | ANY | ❌ No | Catch-all fallback |

**Route Priority:** Explicit routes (`GET /`, `POST /`) are checked first, then `$default` handles everything else.

---

## Testing the $default Route

Even though `$default` doesn't have a test window, you can still test it:

```bash
# These all hit $default route:
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/any/path?employeeId=EMP001"
curl -X PUT "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/"
curl -X DELETE "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/"
```

---

## CloudWatch Logs

Monitor all test requests in CloudWatch:

```bash
# View API logs
aws logs tail /aws/apigateway/private-api-api-dev --follow

# View Lambda logs
aws logs tail /aws/lambda/private-api-rest-api-dev --follow
```

---

## Test Scenarios

### Success Case (200)
```bash
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001"
# Response: 200 OK with employee data
```

### Missing Parameter (400)
```bash
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/"
# Response: 400 Bad Request
# Body: {"error": "employeeId is required"}
```

### Not Found (404)
```bash
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP999"
# Response: 404 Not Found
# Body: {"error": "Employee EMP999 not found"}
```

### Wrong Method Works
```bash
curl -X DELETE "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001"
# Response: 200 OK (caught by $default route)
# Works with any HTTP method!
```

---

## Infrastructure Changes

The API Gateway module was updated to support testing:

```terraform
# Explicit routes (now testable in console)
resource "aws_apigatewayv2_route" "get_root" {
  route_key = "GET /"
  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "post_root" {
  route_key = "POST /"
  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# Catch-all route (backup for other methods/paths)
resource "aws_apigatewayv2_route" "default" {
  route_key = "$default"
  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
```

**Result:** 3 routes → 1 integration → 1 Lambda function

---

## Troubleshooting

### Test Window Still Not Visible
1. Make sure you're clicking on **GET /** or **POST /**
2. Don't click on **$default**
3. Wait 10-15 seconds after deployment for changes to propagate

### "Integration Error" in Test
1. Check Lambda logs: `aws logs tail /aws/lambda/private-api-rest-api-dev --follow`
2. Verify Lambda permission is correct
3. Check Lambda execution role has CloudWatch permissions

### Request Blocked
1. Verify CORS headers: `Access-Control-Allow-Origin: *`
2. Check CloudWatch logs for blocked requests
3. Verify API authorization type: `NONE` (public)

---

## Performance Tips

1. **Use GET for read operations** - Slightly faster, cacheable
2. **Use POST for modifications** - Safe, follows REST conventions
3. **Use query parameters** - Easier to debug, visible in URL
4. **Use JSON body** - More structured, better for complex data

---

## Next Steps

- ✅ Test API in console using explicit routes
- ✅ Monitor with CloudWatch logs
- ✅ Consider adding authentication
- ✅ Add custom domain name
- ✅ Set up API usage plans/keys

---

## Summary

| Feature | Before | After |
|---------|--------|-------|
| Test Window Support | ❌ No | ✅ Yes (GET /, POST /) |
| $default Route | ✅ Works | ✅ Still works |
| API Functionality | ✅ Full | ✅ Full |
| All HTTP Methods | ✅ Yes | ✅ Yes |
| Custom Paths | ✅ Yes | ✅ Yes |

**API Status:** 🟢 Fully Functional & Console-Testable

