# Python Seed Project

A modular Bash script to quickly scaffold a modern, testable, and container-ready Python project.

---

## 🚀 Features

- 📦 Creates Python project structure with:
  - `src/`-based layout
  - `tests/` with pytest
  - `setup.py` for packaging
  - `README.md`, `.gitignore`, and `.vscode/settings.json`
- 🧪 Sets up a virtual environment and installs `black`, `pytest`
- 🐳 Optional containerization support with clean multi-stage `Dockerfile`
- 🧰 Git initialization (optional via flag or `ALLOW_GIT_COMMANDS`)
- 💣 `--force` to overwrite existing folders
- 📂 `--target-dir` to customize project location
- 🧩 Modular helpers

---

## Options to start
There are multiple options to create a seed application for any python. 
### 01-basic-hello-world
This script will let you create a basic hello-world python application
Ideal for bootstrapping CLI tools, internal packages, or microservices
**More info is under:** [01-basic-hello-world](/01-basic-hello-world)

