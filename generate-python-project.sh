#!/bin/bash

set -eo pipefail

print_usage() {
  echo "Usage: $0 -n <project_name> [-f] [-g] [-t <target_dir>] [--docker] [--ci] [--cd]"
  echo "  -n, --name         Project name (required)"
  echo "  -f, --force        Overwrite existing project folder"
  echo "  -g, --git          Initialize Git (or set ALLOW_GIT_COMMANDS=true)"
  echo "  -t, --target-dir   Directory to create the project in (default: current folder)"
  echo "  -d, --docker       Add Dockerfile for packaging-based containerization"
  echo "  -ci, --ci          Create necessary CI scripts"
  echo "  -cd, --cd          Create necessary CD scripts (deployment via GitHub Actions)"
  exit 1
}

# ---------------------------
# PYTHON VERSION CHECK
# ---------------------------
MIN_PYTHON=3.7
PYTHON_VERSION=$(
  python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null ||   python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null
)

create_structure() {
  echo "📁 Creating directory structure..."
  mkdir -p "$TARGET_DIR/$PROJECT_NAME/src/$MODULE_NAME" "$TARGET_DIR/$PROJECT_NAME/tests" "$TARGET_DIR/$PROJECT_NAME/.vscode"
  cd "$TARGET_DIR/$PROJECT_NAME" || exit 1
  touch "src/$MODULE_NAME/__init__.py" "tests/__init__.py"
}

generate_files() {
  cat > "src/$MODULE_NAME/main.py" << EOF
from $MODULE_NAME import config
def main():
    print(f"Hello {config.HELLO_MESSAGE}")
    return "Hello " + config.HELLO_MESSAGE

if __name__ == "__main__":
    main()
EOF
cat > "src/$MODULE_NAME/config.py" << EOF
import os
from dotenv import load_dotenv
from pathlib import Path

# Resolve path to config/.env from project root
env_path = Path(__file__).resolve().parents[2] / "config" / ".env"

print(f"🔍 Looking for .env at: {env_path}")
if not env_path.exists():
    print("❌ .env file not found!")
else:
    print("✅ .env file found")

load_dotenv(dotenv_path=env_path)
HELLO_MESSAGE = os.getenv("HELLO_MESSAGE", "All!")
EOF

cat > tests/test_main.py << EOF
from $MODULE_NAME import main

def test_main_output():
    assert main.main() == "Hello World!"
EOF

  cat > requirements.txt << EOF
pytest
black
python-dotenv
EOF

  cat > .gitignore << EOF
__pycache__/
*.pyc
.env
.venv/
*.egg-info/
.vscode/
.git/
EOF

  cat > setup.py << EOF
import os
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
    long_description=(open("README.md").read() if os.path.exists("README.md") else ""),
    long_description_content_type='text/markdown',
    url="https://github.com/yourusername/$PROJECT_NAME",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License"
    ],
    entry_points={
        'console_scripts': [            
          '$PROJECT_NAME=$MODULE_NAME.main:main',
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

  mkdir -p config
  cat > config/.env << EOF
HELLO_MESSAGE=World!
EOF

  cat > config/env.sample << EOF
# Rename this to .env
HELLO_MESSAGE=World!
EOF

  cat > pytest.ini << EOF
[pytest]
pythonpath = src
EOF
  cat > README.md << EOF
# $PROJECT_NAME

## How to Run

### 1. Create virtual environment

\`\`\`bash
python3 -m venv .venv
source .venv/bin/activate  # or .venv\\Scripts\\activate on Windows
\`\`\`

### 2. Install dependencies

\`\`\`bash
pip install -r requirements.txt
\`\`\`

### 3. Run the application

\`\`\`bash
PYTHONPATH=src python -m $MODULE_NAME.main
\`\`\`

### 4. Run tests

\`\`\`bash
PYTHONPATH=src pytest
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
EOF
}

setup_virtualenv() {
  echo "🔧 Creating virtual environment..."
  python3 -m venv .venv || python -m venv .venv || {
    echo "❌ Failed to create virtual environment"
    exit 1
  }

  case "$OSTYPE" in
    msys*|cygwin*|win32*)
      PYTHON_EXEC=".venv/Scripts/python.exe"
      PIP_EXEC=".venv/Scripts/pip.exe"
      PYTEST_EXEC=".venv/Scripts/pytest.exe"
      BLACK_EXEC=".venv/Scripts/black.exe"
      ;;
    *)
      PYTHON_EXEC=".venv/bin/python"
      PIP_EXEC=".venv/bin/pip"
      PYTEST_EXEC=".venv/bin/pytest"
      BLACK_EXEC=".venv/bin/black"
      ;;
  esac

  echo "📦 Installing dependencies..."
  "$PYTHON_EXEC" -m pip install --upgrade pip setuptools
  "$PIP_EXEC" install -r requirements.txt

  echo "🚀 Running app..."
  PYTHONPATH=src "$PYTHON_EXEC" -m "$MODULE_NAME.main"

  echo "🧪 Running tests..."
  PYTHONPATH=src "$PYTEST_EXEC"

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

generate_github_actions_ci() {
  mkdir -p .github/workflows
  cat > .github/workflows/python-ci-reusable.yml << EOF
name: Python CI Reusable

on:
  workflow_call:
    inputs:
      python-version:
        required: false
        type: string
        default: '3.11'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: \${{ inputs.python-version }}
        cache: 'pip'

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt

    - name: Lint with black
      run: black --check .

    - name: Run tests with pytest
      run: pytest
EOF

  cat > .github/workflows/python-ci.yml << EOF
name: Python CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  call-python-ci:
    uses: ./.github/workflows/python-ci-reusable.yml
    with:
      python-version: '3.11'
EOF
}

generate_github_actions_cd() {
  mkdir -p .github/workflows
  cat > .github/workflows/python-cd-reusable.yml << EOF
name: Build & Push Docker Image with Python Wheel

on:
  workflow_call:
    inputs:
      image_name:
        required: false
        type: string
      namespace:
        required: false
        type: string
        default: /com/gc
      artifactory_repository:
        required: false
        type: string
      artifactory_url:
        required: false
        type: string
        default: https://my-artifactory/artifactory
    secrets:
      ARTIFACTORY_USERNAME:
        required: false
      ARTIFACTORY_PASSWORD:
        required: false
      ARTIFACTORY_PUBLIC_USERNAME:
        required: false
      ARTIFACTORY_PUBLIC_PASSWORD:
        required: false

jobs:
  deploy:
    runs-on: ubuntu-latest
    timeout-minutes: 15

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'

    - name: Install Python build tools
      run: |
        python -m pip install --upgrade pip
        pip install build

    - name: Build Python wheel
      run: python -m build --wheel

    - name: Determine image tag
      id: get_tag
      run: |
        if [[ "\${GITHUB_REF##*/}" == "main" ]]; then
          echo "tag=\${GITHUB_SHA}" >> \$GITHUB_OUTPUT
        else
          version=\$(python setup.py --version)
          echo "tag=\$version" >> \$GITHUB_OUTPUT
        fi

    - name: Resolve image values
      id: resolve
      run: |
        REPO="\${{ inputs.artifactory_repository }}"
        if [[ -z "\$REPO" ]]; then
          if [[ "\${GITHUB_REF##*/}" == "main" ]]; then
            REPO=dkr-public-local
          else
            REPO=dkr-snapshot-local
          fi
        fi
        echo "repo=\$REPO" >> \$GITHUB_OUTPUT
        NS="\${{ inputs.namespace }}"
        echo "ns=\${NS%/}/" >> \$GITHUB_OUTPUT
        NAME="\${{ inputs.image_name }}"
        if [[ -z "\$NAME" ]]; then
          NAME="\${GITHUB_REPOSITORY##*/}"
        fi
        echo "name=\$NAME" >> \$GITHUB_OUTPUT

    - name: Set credentials based on repository
      id: creds
      run: |
        if [[ "\${{ steps.resolve.outputs.repo }}" == "dkr-public-local" ]]; then
          echo "user=\${{ secrets.ARTIFACTORY_PUBLIC_USERNAME }}" >> \$GITHUB_OUTPUT
          echo "pass=\${{ secrets.ARTIFACTORY_PUBLIC_PASSWORD }}" >> \$GITHUB_OUTPUT
        else
          echo "user=\${{ secrets.ARTIFACTORY_USERNAME }}" >> \$GITHUB_OUTPUT
          echo "pass=\${{ secrets.ARTIFACTORY_PASSWORD }}" >> \$GITHUB_OUTPUT
        fi

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Log in to Artifactory Docker Registry
      run: echo "\${{ steps.creds.outputs.pass }}" | docker login "\${{ inputs.artifactory_url }}" -u "\${{ steps.creds.outputs.user }}" --password-stdin

    - name: Build Docker image with wheel installed
      run: |
        cp dist/*.whl .
        docker build -t "\${{ inputs.artifactory_url }}/\${{ steps.resolve.outputs.repo }}\${{ steps.resolve.outputs.ns }}\${{ steps.resolve.outputs.name }}:\${{ steps.get_tag.outputs.tag }}" .

    - name: Push Docker image
      run: |
        docker push "\${{ inputs.artifactory_url }}/\${{ steps.resolve.outputs.repo }}\${{ steps.resolve.outputs.ns }}\${{ steps.resolve.outputs.name }}:\${{ steps.get_tag.outputs.tag }}"

    - name: Also tag and push as 'latest' (only on main)
      if: github.ref_name == 'main'
      run: |
        docker tag "\${{ inputs.artifactory_url }}/\${{ steps.resolve.outputs.repo }}\${{ steps.resolve.outputs.ns }}\${{ steps.resolve.outputs.name }}:\${{ steps.get_tag.outputs.tag }}" "\${{ inputs.artifactory_url }}/\${{ steps.resolve.outputs.repo }}\${{ steps.resolve.outputs.ns }}\${{ steps.resolve.outputs.name }}:latest"
        docker push "\${{ inputs.artifactory_url }}/\${{ steps.resolve.outputs.repo }}\${{ steps.resolve.outputs.ns }}\${{ steps.resolve.outputs.name }}:latest"

    - name: Logout from Docker Registry
      run: docker logout "\${{ inputs.artifactory_url }}"
EOF

  cat > .github/workflows/python-cd.yml << EOF
name: Deploy via Reusable Workflow

on:
  push:
    branches:
      - main
      - dev

jobs:
  call-deploy:
    uses: ./.github/workflows/python-cd-reusable.yml@main
    with:
      image_name: ${PROJECT_NAME}
      namespace: /team-x
      artifactory_repository: dkr-snapshot-local
    secrets:
      ARTIFACTORY_USERNAME: \${{ secrets.ARTIFACTORY_USERNAME }}
      ARTIFACTORY_PASSWORD: \${{ secrets.ARTIFACTORY_PASSWORD }}
      ARTIFACTORY_PUBLIC_USERNAME: \${{ secrets.ARTIFACTORY_PUBLIC_USERNAME }}
      ARTIFACTORY_PUBLIC_PASSWORD: \${{ secrets.ARTIFACTORY_PUBLIC_PASSWORD }}
EOF
}

# ---------------------------
# ARGUMENT PARSING
# ---------------------------
PROJECT_NAME=""
TARGET_DIR="."
FORCE=false
ALLOW_GIT_COMMANDS=false
INCLUDE_DOCKER=false
ENABLE_CI=false
ENABLE_CD=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    -f|--force)
      FORCE=true
      shift
      ;;
    -g|--git)
      ALLOW_GIT_COMMANDS=true
      shift
      ;;
    -t|--target-dir)
      TARGET_DIR="$2"
      shift 2
      ;;
    -cd|--cd)
      ENABLE_CD=true
      shift
      ;;
    -ci|--ci)
      ENABLE_CI=true
      shift
      ;;
    -d|--docker)
      INCLUDE_DOCKER=true
      shift
      ;;
    *)
      echo "❌ Unknown option: $1"
      print_usage
      ;;
  esac
done

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Project name is required."
  print_usage
fi
MODULE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_')
if [ -d "$TARGET_DIR/$PROJECT_NAME" ]; then
  if [ "$FORCE" = true ]; then
    echo "⚠️ Removing existing project: $TARGET_DIR/$PROJECT_NAME"
    rm -rf "$TARGET_DIR/$PROJECT_NAME"
  else
    echo "⚠️ Project '$PROJECT_NAME' already exists in '$TARGET_DIR'. Use -f to overwrite."
    exit 1
  fi
fi

# ---------------------------
# EXECUTION FLOW
# ---------------------------
echo "🚧 Starting project scaffolding..."
echo "📁 Creating Python project in: $TARGET_DIR/$PROJECT_NAME"
create_structure
generate_files

if [ "$INCLUDE_DOCKER" = true ]; then
  generate_docker_files
fi

if [ "$ENABLE_CI" = true ]; then
  generate_github_actions_ci
fi

if [ "$ENABLE_CD" = true ]; then
  generate_github_actions_cd
fi

setup_virtualenv
initialize_git

echo "🐍 Python version $PYTHON_VERSION detected – OK."
echo "✅ Project '$PROJECT_NAME' created successfully in '$TARGET_DIR'."
echo "📘 See '$TARGET_DIR/$PROJECT_NAME/README.md' for usage."
