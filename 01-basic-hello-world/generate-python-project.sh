#!/bin/bash

set -e

source "$(dirname "$0")/lib.sh"

PROJECT_NAME=""
TARGET_DIR="."
FORCE=false
ALLOW_GIT_COMMANDS=false
INCLUDE_DOCKER=false

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

if [ -d "$TARGET_DIR/$PROJECT_NAME" ]; then
  if [ "$FORCE" = true ]; then
    echo "⚠️ Removing existing project: $TARGET_DIR/$PROJECT_NAME"
    rm -rf "$TARGET_DIR/$PROJECT_NAME"
  else
    echo "⚠️ Project '$PROJECT_NAME' already exists in '$TARGET_DIR'. Use -f to overwrite."
    exit 1
  fi
fi

echo "📁 Creating Python project in: $TARGET_DIR/$PROJECT_NAME"
create_structure
generate_files

if [ "$INCLUDE_DOCKER" = true ]; then
  generate_docker_files
fi

setup_virtualenv
initialize_git

echo "✅ Project '$PROJECT_NAME' created successfully in '$TARGET_DIR'."
echo "📘 See '$TARGET_DIR/$PROJECT_NAME/README.md' for usage."
