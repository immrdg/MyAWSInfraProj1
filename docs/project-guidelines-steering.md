# REST API Lambda Project Guidelines

## Project Overview
This is a Python-based AWS Lambda function for handling REST API requests. It's a sub-project within the PrivateApiGateWay infrastructure.

## Project Structure
- `handler.py` - Lambda handler entry point
- `test_handler.py` - Unit tests
- `requirements.txt` - Production dependencies
- `pyproject.toml` - Project configuration and dev dependencies
- `Makefile` - Build and development commands
- `.venv/` - Virtual environment (auto-created)

## Development Workflow

### Setup
```bash
make install-dev    # Install with dev tools
make venv          # Create fresh virtual environment
```

### Testing & Quality
```bash
make test          # Run tests with coverage (100% required)
make lint          # Run flake8 + mypy
make format        # Format with black
```

### Building
```bash
make build         # Create lambda-function.zip for deployment
```

### Cleanup
```bash
make clean         # Remove build artifacts
make clean-venv    # Remove virtual environment
```

## Key Standards

### Code Quality
- All code must be formatted with `black` (line-length: 100)
- Linting: `flake8` with no errors
- Type hints: `mypy` enabled (check_untyped_defs: true)
- Test coverage: 100% required

### Testing
- Use `pytest` for all tests
- Test file naming: `test_*.py`
- Coverage reports: HTML + terminal output
- Run: `make test`

### Handler Requirements
- Entry point: `handler.lambda_handler(event, context)`
- Must return proper HTTP response format
- Must handle AWS Lambda context properly

## Deployment
1. Ensure all tests pass: `make test`
2. Build package: `make build`
3. Upload `lambda-function.zip` to AWS Lambda
4. Set handler to: `handler.lambda_handler`
5. Configure runtime: Python 3.11

## Python Version
- Target: Python 3.9+
- Recommended: Python 3.11
- See `.python-version` for pyenv configuration

## Dependencies

### Production (requirements.txt)
- boto3: AWS SDK
- requests: HTTP library

### Development (optional in pyproject.toml)
- pytest: Testing framework
- pytest-cov: Coverage reporting
- black: Code formatter
- flake8: Linter
- mypy: Type checker
