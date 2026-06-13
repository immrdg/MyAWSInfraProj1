# Development Guide for rest-api

## Quick Start

```bash
# One-time setup
make install-dev

# Development loop
make format    # Format code
make lint      # Check quality
make test      # Run tests
```

## Common Tasks

### Adding a New Function
1. Create function in `handler.py`
2. Add corresponding test in `test_handler.py`
3. Ensure test coverage remains at 100%
4. Run `make lint` to check quality

### Modifying the Handler
1. Update `handler.py`
2. Update tests in `test_handler.py`
3. Run `make test` to verify
4. Commit changes

### Running Individual Tests
```bash
. .venv/bin/activate
pytest test_handler.py::TestLambdaHandler::test_handler_returns_200_status_code -v
```

### Debugging
```bash
. .venv/bin/activate
python3 -c "from handler import lambda_handler; print(lambda_handler({}, {}))"
```

## Virtual Environment

The virtual environment is automatically created by `make install-dev`.

To manually activate it:
```bash
source .venv/bin/activate
```

To deactivate:
```bash
deactivate
```

## Environment Variables

Currently no environment variables are required for local development.

For AWS Lambda deployment, you may need to configure:
- AWS credentials (via IAM role)
- Environment variables for runtime configuration

## Dependencies

### Adding New Dependencies

For production use:
1. Add to `requirements.txt`
2. Add to `dependencies` in `pyproject.toml`
3. Run `make install-dev` to update venv

For development only:
1. Add to `project.optional-dependencies.dev` in `pyproject.toml`
2. Run `make install-dev` to update venv

## Troubleshooting

### Virtual Environment Issues
```bash
make clean-venv
make install-dev
```

### Import Errors
Ensure venv is activated:
```bash
. .venv/bin/activate
```

### Test Failures
```bash
make test    # Full test with coverage
```

### Linting Errors
```bash
make format  # Auto-fix with black
make lint    # Check remaining issues
```

## Pre-Commit Checklist

Before committing:
- [ ] `make test` passes (100% coverage)
- [ ] `make lint` passes (no errors)
- [ ] `make format` run (code formatted)
- [ ] All new functions have tests
- [ ] Docstrings added where needed
