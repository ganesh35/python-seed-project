#!/bin/bash

print_usage() {
  echo "Usage: $0 -n <project_name> [-f] [-g] [-t <target_dir>] [--docker]"
  echo "  -n, --name         Project name (required)"
  echo "  -f, --force        Overwrite existing project folder"
  echo "  -g, --git          Initialize Git (or set ALLOW_GIT_COMMANDS=true)"
  echo "  -t, --target-dir   Directory to create the project in (default: current folder)"
  echo "  --docker           Add Dockerfile for packaging-based containerization"
  exit 1
}

create_structure() {
  mkdir -p "$TARGET_DIR/$PROJECT_NAME"/{tests,src,.vscode}
  cd "$TARGET_DIR/$PROJECT_NAME" || exit 1
  touch src/__init__.py tests/__init__.py
}

generate_files() {
  cat > src/main.py << EOF
def main():
    print("Hello World!")
    return "Hello World!"

if __name__ == "__main__":
    main()
EOF

  cat > tests/test_main.py << EOF
from src import main

def test_main_output():
    assert main.main() == "Hello World!"
EOF

  cat > requirements.txt << EOF
pytest
black
EOF

  cat > .gitignore << EOF
__pycache__/
*.pyc
.env
.venv/
*.egg-info/
.vscode/
.git/
tests/
EOF

  cat > setup.py << EOF
from setuptools import setup, find_packages

setup(
    name="$PROJECT_NAME",
    version="0.1.0",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    install_requires=[],
    author="Your Name",
    author_email="your.email@example.com",
    description="A basic Python project",
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url="https://github.com/yourusername/$PROJECT_NAME",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License"
    ],
    entry_points={
        'console_scripts': [
            '$PROJECT_NAME=main:main',
        ],
    },
)
EOF

  cat > .vscode/settings.json << EOF
{
  "python.formatting.provider": "black",
  "editor.formatOnSave": true,
  "python.testing.pytestEnabled": true,
  "python.testing.pytestArgs": ["tests"]
}
EOF

  cat > README.md << EOF
# $PROJECT_NAME

## How to Run

### 1. Create virtual environment

\`\`\`bash
python3 -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
\`\`\`

### 2. Install dependencies

\`\`\`bash
pip install -r requirements.txt
\`\`\`

### 3. Run the application

\`\`\`bash
python src/main.py
\`\`\`

### 4. Run tests

\`\`\`bash
pytest
\`\`\`

### 5. Format code

\`\`\`bash
black .
\`\`\`
EOF
}

generate_docker_files() {
  cat > Dockerfile << EOF
FROM python:3.11-slim AS build

WORKDIR /app

COPY setup.py README.md requirements.txt ./
COPY src/ ./src/

RUN pip install --upgrade pip setuptools
RUN pip wheel . --wheel-dir=/wheels

FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt ./
COPY --from=build /wheels /wheels

RUN pip install --no-cache-dir /wheels/*.whl

CMD ["$PROJECT_NAME"]
EOF

  cat > .dockerignore << EOF
__pycache__/
*.pyc
.venv/
.vscode/
.git/
tests/
EOF
}

setup_virtualenv() {
  echo "🔧 Creating virtual environment..."
  python3 -m venv .venv || python -m venv .venv || {
    echo "❌ Failed to create virtual environment"
    exit 1
  }

  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PYTHON_EXEC=".venv/Scripts/python.exe"
    PIP_EXEC=".venv/Scripts/pip.exe"
    PYTEST_EXEC=".venv/Scripts/pytest.exe"
    BLACK_EXEC=".venv/Scripts/black.exe"
  else
    PYTHON_EXEC=".venv/bin/python"
    PIP_EXEC=".venv/bin/pip"
    PYTEST_EXEC=".venv/bin/pytest"
    BLACK_EXEC=".venv/bin/black"
  fi

  echo "📦 Installing dependencies..."
  "$PYTHON_EXEC" -m pip install --upgrade pip setuptools
  "$PIP_EXEC" install -r requirements.txt

  echo "🚀 Running main.py..."
  "$PYTHON_EXEC" src/main.py

  echo "🧪 Running tests..."
  "$PYTEST_EXEC"

  echo "🎨 Formatting code..."
  "$BLACK_EXEC" .
}

initialize_git() {
  if [ "$ALLOW_GIT_COMMANDS" = true ]; then
    if command -v git >/dev/null 2>&1; then
      if [ ! -d ".git" ]; then
        echo "🔧 Initializing Git repository..."
        git init -q
        git add .
        git commit -m "Initial commit" -q
      else
        echo "ℹ️ Git already initialized."
      fi
    else
      echo "⚠️ Git not found. Skipping Git init."
    fi
  else
    echo "ℹ️ Git initialization skipped (set -g or ALLOW_GIT_COMMANDS=true)"
  fi
}
