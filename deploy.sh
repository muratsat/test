#!/bin/bash

BASE_DIR=/home/murat/Desktop/test

cd $BASE_DIR

git fetch

REQUIREMENTS_CHANGED=false
MIGRATIONS_CHANGED=false

if ! git diff --quiet HEAD..origin/main -- requirements.txt; then
  REQUIREMENTS_CHANGED=true
fi

if ! git diff --quiet HEAD..origin/main -- '*migrations*'; then
  MIGRATIONS_CHANGED=true
fi

git pull

if [ "$REQUIREMENTS_CHANGED" = true ]; then
  echo "Installing requirements..."
fi

if [ "$MIGRATIONS_CHANGED" = true ]; then
  echo "Running migrations..."
fi

