# py-hello

## How to Run

### 1. Create virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the application

```bash
PYTHONPATH=src python -m py_hello.main
```

### 4. Run tests

```bash
PYTHONPATH=src pytest
```

### 5. Format code

```bash
black .
```
