# Python Project Generator

This project scaffolds a fully-configured Python application with optional Docker, Git, and GitHub Actions CI/CD support.

---

## 🧰 Features

- Python project structure with `src/` and `tests/`
- `pytest` for testing
- `black` for code formatting
- Preconfigured `.vscode/settings.json`
- Optional:
  - `Dockerfile` and `.dockerignore`
  - Git initialization with first commit
  - GitHub Actions CI/CD pipelines
- Auto setup of virtual environment and runs:
  - the app
  - tests
  - formatting

---

## 🚀 Usage

### 🛠 Prerequisites

- Bash shell (Linux/macOS or Git Bash on Windows)
- Python 3.7+
- `pip`, `venv`, `git` (optional), `docker` (optional)

---

### 📦 Run the Script

```bash
./generate.sh -n my_project [options]
```

### 🔧 Options

| Option       | Description                                              |
|--------------|----------------------------------------------------------|
| `-n`         | **Project name** (required)                              |
| `-f`         | Force overwrite if project folder already exists         |
| `-g`         | Initialize a Git repo (or set `ALLOW_GIT_COMMANDS=true`) |
| `-t`         | Target directory (default: current directory)            |
| `-d`         | Include Dockerfile and `.dockerignore`                  |
| `-ci`        | Add GitHub Actions CI pipelines                         |
| `-cd`        | Add GitHub Actions CD workflows for Docker builds       |

---

## 🧪 Generated Project Structure

```
my_project/
├── src/
│   └── main.py
├── tests/
│   └── test_main.py
├── .vscode/
│   └── settings.json
├── .gitignore
├── README.md
├── setup.py
├── requirements.txt
├── Dockerfile (optional)
├── .dockerignore (optional)
└── .github/
    └── workflows/
        ├── python-ci.yml (optional)
        ├── python-ci-reusable.yml (optional)
        ├── python-cd.yml (optional)
        └── python-cd-reusable.yml (optional)
```

---

## 🧰 Development Guide

### 🔁 Create a Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
```

### 📥 Install Dependencies

```bash
pip install -r requirements.txt
```

### ▶️ Run App

```bash
python src/main.py
```

### 🧪 Run Tests

```bash
pytest
```

### 🎨 Format Code

```bash
black .
```

---

## 🐳 Docker (Optional)

Build & run using the generated `Dockerfile`:

```bash
docker build -t my_project .
docker run my_project
```

---

## 🔄 CI/CD with GitHub Actions (Optional)

If `--ci` and/or `--cd` flags are passed, GitHub workflows will be added to `.github/workflows`.

### Example CI Trigger

```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

### Example CD Trigger

```yaml
on:
  push:
    branches: [ main, dev ]
```

Make sure you configure the necessary [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) for Artifactory if CD is enabled.

---

## 📄 License

MIT License – feel free to use and modify.
