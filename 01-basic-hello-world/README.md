# generate-python-project.sh

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
- 🧩 Modular helpers (see `lib.sh`)

---

## 📥 Usage

```bash
./generate-python-project.sh -n <project_name> [options]
```

### Options

| Option         | Description                                       |
|----------------|---------------------------------------------------|
| `-n, --name`   | **(Required)** Name of your project               |
| `-f, --force`  | Overwrite existing project folder                 |
| `-g, --git`    | Initialize Git repo (or set `ALLOW_GIT_COMMANDS=true`) |
| `-t, --target-dir <dir>` | Target directory for project creation |
| `--docker`     | Include `Dockerfile` and `.dockerignore` for packaging-only containerization |

---

## 🐋 Dockerfile Behavior (With `--docker`)

- Uses `setup.py` to build and install the project (no raw `src/` in final image)
- Clean final container with only `.whl` package installed
- Based on Python 3.11-slim

---

## 📁 Output Structure

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
└── Dockerfile* (if -d/--docker is enabled)
```

---

## 🧪 Test Locally

```bash
cd <project_name>
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pytest
```

---

## 💡 Notes

- This script sources all helper logic from `lib.sh` — update this file to tweak scaffolding logic
- Ideal for bootstrapping CLI tools, internal packages, or microservices

---

## 🛠 Requirements

- Bash (Linux, macOS, Git Bash on Windows)
- Python 3.7+
- `pip`, `virtualenv`, `git` (optional), `docker` (optional)

---

## 🧑‍💻 Author

Crafted with ❤️ using Bash - GB.

