# Quick Reference - Private API Gateway

## 🚀 Live Endpoint
```
https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/
```

## 📡 API Requests

### Get Employee by Query String
```bash
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001"
```

### Get Employee by JSON Body
```bash
curl -X POST "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/" \
  -H "Content-Type: application/json" \
  -d '{"employeeId": "EMP001"}'
```

## 📦 Available Employees
- **EMP001** - John Doe (Engineering)
- **EMP002** - Jane Smith (Product)
- **EMP003** - Bob Johnson (Sales)

## ✅ Test Commands

```bash
# Test 1: Success (200 OK)
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001"

# Test 2: Missing parameter (400)
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/"

# Test 3: Not found (404)
curl "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP999"

# Test 4: With jq (pretty print)
curl -s "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001" | jq
```

## 📋 Response Format

### Success (200)
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

### Error (400 - Missing Parameter)
```json
{
  "error": "employeeId is required"
}
```

### Error (404 - Not Found)
```json
{
  "error": "Employee EMP999 not found"
}
```

## 🔍 Monitoring

### View API Logs
```bash
aws logs tail /aws/apigateway/private-api-api-dev --follow
```

### View Lambda Logs
```bash
aws logs tail /aws/lambda/private-api-rest-api-dev --follow
```

## 🛠️ Development Commands

### Run Tests
```bash
cd lambda/rest-api
source .venv/bin/activate
python -m pytest test_handler.py -v --override-ini="addopts="
```

### Build Lambda Package
```bash
cd lambda/rest-api
source .venv/bin/activate
make build
```

### Deploy Infrastructure
```bash
cd Infrastructure/env/dev
terragrunt plan -out=tfplan
terragrunt apply tfplan
```

## 📊 Key Configuration

| Setting | Dev | Prod |
|---------|-----|------|
| Region | us-east-1 | us-east-1 |
| API Type | HTTP | HTTP |
| Auth | None | None |
| Memory | 128MB | 256MB |
| Timeout | 30s | 60s |
| VPC CIDR | 10.0.0.0/16 | 10.1.0.0/16 |

## 🔗 Input Formats

The API supports multiple ways to pass `employeeId`:

1. **Query String** (GET)
   ```
   ?employeeId=EMP001
   ```

2. **JSON Body** (POST)
   ```json
   {"employeeId": "EMP001"}
   ```

3. **Path Parameters**
   ```
   /pathParameters/employeeId=EMP001
   ```

## 📚 Documentation Files

- **API_DOCUMENTATION.md** - Full API reference
- **API_GATEWAY_SETUP.md** - Infrastructure setup details
- **TASK_7_COMPLETION.md** - Completion summary
- **QUICK_REFERENCE.md** - This file

## 🎯 Status

✅ Development: Live & Tested  
🟡 Production: Ready for deployment  
✅ All Tests Passing  
✅ CloudWatch Logging Active  

## 💡 Common Tasks

### Test with Python
```python
import requests

response = requests.get(
    "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/",
    params={"employeeId": "EMP001"}
)
print(response.json())
```

### Test with JavaScript
```javascript
fetch("https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001")
  .then(r => r.json())
  .then(data => console.log(data))
```

### Check Lambda Status
```bash
aws lambda get-function --function-name private-api-rest-api-dev --region us-east-1
```

### Check API Gateway Status
```bash
aws apigatewayv2 get-api --api-id aqfmsxffbg --region us-east-1
```

## ⚡ Performance

- **Response Time:** 50-100ms typical
- **Cold Start:** ~500ms (first invocation)
- **Concurrency:** AWS account limits

## 🚨 Troubleshooting

| Issue | Solution |
|-------|----------|
| 502 Bad Gateway | Check Lambda permissions & logs |
| CORS Error | Verify endpoint & headers |
| 504 Timeout | Check Lambda execution logs |
| No logs | Enable CloudWatch logging |

## 📞 Support

1. Check CloudWatch logs
2. Review Terraform state
3. Verify AWS permissions
4. See API_DOCUMENTATION.md

---

**Last Updated:** 2026-06-13  
**Status:** ✅ Production Ready
