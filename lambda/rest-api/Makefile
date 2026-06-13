.PHONY: help venv install install-dev test lint format clean clean-venv build deploy-plan deploy

help:
	@echo "Available commands:"
	@echo "  make venv          - Create virtual environment"
	@echo "  make install       - Install dependencies in venv"
	@echo "  make install-dev   - Install dependencies with dev tools in venv"
	@echo "  make test          - Run tests with coverage"
	@echo "  make lint          - Run linting checks"
	@echo "  make format        - Format code with black"
	@echo "  make clean         - Remove build artifacts and cache"
	@echo "  make clean-venv    - Remove virtual environment"
	@echo "  make build         - Build deployment package"

venv:
	python3 -m venv .venv
	. .venv/bin/activate && pip install --upgrade pip setuptools wheel

install: venv
	. .venv/bin/activate && pip install -r requirements.txt

install-dev: venv
	. .venv/bin/activate && pip install -r requirements.txt && pip install -e ".[dev]"

test:
	. .venv/bin/activate && python3 -m pytest test_handler.py -v --cov=. --cov-report=term --cov-report=html

lint:
	. .venv/bin/activate && python3 -m flake8 handler.py test_handler.py
	. .venv/bin/activate && python3 -m mypy handler.py

format:
	. .venv/bin/activate && python3 -m black handler.py test_handler.py

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .coverage htmlcov dist build *.egg-info

clean-venv:
	rm -rf .venv

build: clean
	mkdir -p build
	cp handler.py build/
	cd build && zip -r ../lambda-function.zip . -x "*.git*" "__pycache__/*" "*.py[cod]"
	@echo "Built: lambda-function.zip (code only)"
