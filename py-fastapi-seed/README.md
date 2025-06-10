# py-fastapi-seed

## How to Run

### 1. Create virtual environment

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/fastapi-crud-app.git
cd fastapi-crud-app

# 2. Create a virtual environment named .venv
python -m venv .venv

# 3. Activate the virtual environment (Git Bash)
source .venv/Scripts/activate

# 4. Install dependencies
pip install -r requirements.txt

# 5. Run the application
python -m app.main
```

## Running Tests

To run all API and unit tests, use:

```bash
pytest
```

This will execute all tests in the `tests/` directory, including endpoint and probe tests.
