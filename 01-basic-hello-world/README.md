# generate-python-project.sh

A powerful and flexible Bash script to scaffold Python projects with optional Git, Docker, and GitHub Actions CI setup.

---

## 🚀 Features

- 📁 Creates a modern Python project layout with:
  - `src/` and `tests/` structure
  - `setup.py` for packaging
  - `.vscode/settings.json` for editor formatting
- 🧪 Sets up virtual environment, installs `black`, `pytest`
- 🐳 Optionally creates a Dockerfile with clean multi-stage packaging (no raw source)
- 🧬 Optionally adds GitHub Actions CI workflow
- 🧰 Git initialization with optional flag or `ALLOW_GIT_COMMANDS=true`
- 🧼 Auto format & test run after creation

---

## 🧑‍💻 Usage

```bash
./generate-python-project.sh -n <project_name> [options]
```

### Options

| Option             | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| `-n`, `--name`      | **(Required)** Name of the Python project                                  |
| `-f`, `--force`     | Overwrite existing project folder if it exists                             |
| `-g`, `--git`       | Initialize Git repository (or set `ALLOW_GIT_COMMANDS=true`)               |
| `-t`, `--target-dir`| Target directory to create project (default: current directory)            |
| `-d`, `--docker`    | Include a Dockerfile and `.dockerignore` for packaging-based containerization |
| `-ci`, `--ci`       | Add GitHub Actions CI workflow in `.github/workflows/python-ci.yml`       |

---

## 🐍 Project Structure

```
<project_name>/
├── src/
│   └── main.py
├── tests/
│   └── test_main.py
├── .vscode/
│   └── settings.json
├── .gitignore
├── README.md
├── requirements.txt
├── setup.py
├── Dockerfile* (if --docker is set)
└── .github/workflows/python-ci.yml* (if --ci is set)
```

---

## 📦 Run Your Project

```bash
# 1. Navigate to project
cd <project_name>

# 2. Create virtualenv
python3 -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows

# 3. Install requirements
pip install -r requirements.txt

# 4. Run your app
python src/main.py

# 5. Run tests
pytest

# 6. Format code
black .
```

---

## 🛠 Requirements

- Bash (Linux, macOS, or Git Bash on Windows)
- Python 3.7+
- `pip`, `virtualenv`
- (Optional) Docker and Git

---

## 🧪 GitHub Actions CI

If `--ci` is used, a GitHub Actions workflow is created to:
- Set up Python
- Install dependencies
- Run `black --check`
- Run tests via `pytest`

---

## ✅ Example

```bash
./generate-python-project.sh -n myapp --git --docker --ci
```

This will create a Git-enabled Python project with Docker support and CI.

---

## 📘 License

MIT — use it freely and adapt for your needs.
