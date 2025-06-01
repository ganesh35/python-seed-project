# generate-python-project.sh

A comprehensive Bash script to scaffold modern Python projects with optional Git, Docker, GitHub Actions CI/CD integration, and `.env` support.

---

## 🚀 Features

- 📁 Creates a clean Python project structure with:
  - `src/` (with `main.py`, `config.py`, and `__init__.py`)
  - `tests/` with example test
  - `config/.env` and `env.sample` support
  - `setup.py` configured for console entry points
  - `.vscode/settings.json` for dev setup
- 🧪 Sets up `pytest`, `black`, `python-dotenv`
- 🔧 Initializes a virtual environment and installs dependencies
- 🐳 Optionally generates a Dockerfile and `.dockerignore`
- ⚙️ Adds CI and CD GitHub Actions workflows if desired
- 🧰 Git initialization (optional or via `ALLOW_GIT_COMMANDS=true`)
- 🧼 Auto runs and formats code after setup
- 🧽 Automatically converts project names like `hello-py` → `hello_py` for module-safe naming

---

## 🧑‍💻 Usage

```bash
./generate-python-project.sh -n <project_name> [options]
```

### Options

| Option              | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `-n`, `--name`       | **(Required)** Name of the Python project                                  |
| `-f`, `--force`      | Overwrite existing project folder                                           |
| `-g`, `--git`        | Initialize Git (or set `ALLOW_GIT_COMMANDS=true`)                          |
| `-t`, `--target-dir` | Target directory to create the project (default: current directory)        |
| `-d`, `--docker`     | Include Dockerfile and `.dockerignore`                                     |
| `-ci`, `--ci`        | Add GitHub Actions CI workflow                                             |
| `-cd`, `--cd`        | Add GitHub Actions CD workflow (build/push Docker image)                   |

---

## 📂 Project Structure

```
<project_name>/
├── src/
│   └── <module_name>/
│       ├── __init__.py
│       ├── main.py
│       └── config.py
├── tests/
│   └── test_main.py
├── config/
│   ├── .env
│   └── env.sample
├── .vscode/
│   └── settings.json
├── .gitignore
├── README.md
├── requirements.txt
├── setup.py
├── pytest.ini
├── Dockerfile* (if --docker is set)
└── .github/
    └── workflows/
        ├── python-ci.yml* (if --ci is set)
        ├── python-ci-reusable.yml* (if --ci is set)
        ├── python-cd.yml* (if --cd is set)
        └── python-cd-reusable.yml* (if --cd is set)
```

---

## 🐍 How to Run

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
PYTHONPATH=src python -m <module_name>.main
```

### 4. Run tests

```bash
PYTHONPATH=src pytest
```

### 5. Format code

```bash
black .
```

---

## 📦 GitHub Actions CI/CD

- **CI (`--ci`)**:
  - Checks code formatting with `black`
  - Runs `pytest` tests
- **CD (`--cd`)**:
  - Builds Python wheel
  - Builds Docker image with installed wheel
  - Pushes image to Artifactory (supporting secrets for auth)

---

## ✅ Example

```bash
./generate-python-project.sh -n my-app --git --docker --ci --cd
```

This will create a full-featured Python project with Git, Docker, CI, and CD support.

---

## 📘 License

MIT — free to use, modify, and distribute.
