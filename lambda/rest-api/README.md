# REST API Lambda Function

A Python-based AWS Lambda function for handling REST API requests.

## Project Structure

```
.
├── handler.py          # Lambda handler entry point
├── test_handler.py     # Unit tests
├── requirements.txt    # Production dependencies
├── pyproject.toml      # Project configuration
├── Makefile           # Build and development commands
└── README.md          # This file
```

## Setup

### Prerequisites
- Python 3.9+
- pip or conda

### Installation

```bash
# Install production dependencies
make install

# Install with development dependencies
make install-dev
```

## Development

### Running Tests
```bash
make test
```

### Code Formatting
```bash
make format
```

### Linting
```bash
make lint
```

### Building Deployment Package
```bash
make build
```

This creates `lambda-function.zip` ready for deployment to AWS Lambda.

## Available Commands

```bash
make help     # Show all available commands
make install  # Install dependencies
make test     # Run tests with coverage
make lint     # Run linting checks
make format   # Format code
make clean    # Remove build artifacts
make build    # Create deployment zip
```

## Lambda Handler

The main handler is in `handler.py` with the entry point `lambda_handler(event, context)`.

## Deployment

1. Build the package: `make build`
2. Upload `lambda-function.zip` to AWS Lambda
3. Set handler to `handler.lambda_handler`
