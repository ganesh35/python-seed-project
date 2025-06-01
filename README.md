# generate-python-project.sh

A simple but powerful Bash script to scaffold a Python project with virtual environment, auto-formatting, testing, and optional Git support.

---

## 🚀 Features

- 📁 Creates a clean Python project layout:
  - `src/<module_name>/` structure
  - `tests/` with an initial test
  - `setup.py` for packaging
  - `.vscode/settings.json` for editor formatting
  - `.gitignore` and `README.md`
- 🧪 Sets up a virtual environment and installs `black`, `pytest`
- 🎨 Automatically formats code and runs tests
- 🧰 Initializes Git (optional)
- 🧼 Supports project names with hyphens (e.g. `hello-py` → `hello_py` for module)

---

## 🧑‍💻 Usage

```bash
./generate-python-project.sh -n <project_name> [options]
```

### Options

| Option             | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `-n`, `--name`      | **(Required)** Name of the Python project                   |
| `-f`, `--force`     | Overwrite existing project folder if it exists              |
| `-g`, `--git`       | Initialize a Git repository (or set `ALLOW_GIT_COMMANDS=true`) |
| `-t`, `--target-dir`| Directory to create the project in (default: current folder) |

---

## 🐍 Project Structure

```
<project_name>/
├── src/
│   └── <module_name>/       # Hyphens in name become underscores
│       └── main.py
├── tests/
│   └── test_main.py
├── .vscode/
│   └── settings.json
├── .gitignore
├── README.md
├── requirements.txt
├── setup.py
├── pytest.ini
└── .venv/
```

---

## 📦 Run Your Project

```bash
# 1. Navigate to project
cd <project_name>

# 2. Create and activate virtualenv (already done by the script)
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# 3. Run the application
PYTHONPATH=src python -m <module_name>.main

# 4. Run tests
PYTHONPATH=src pytest

# 5. Format code
black .
```

---

## 🛠 Requirements

- Bash (Linux, macOS, or Git Bash on Windows)
- Python 3.7+
- `pip`, `virtualenv`
- (Optional) Git

---

## ✅ Example

```bash
./generate-python-project.sh -n hello-py --git --force
```

This creates a project in `hello-py/` using `hello_py` as the Python module.

---

## 📘 License

MIT — use it freely and adapt as needed.
