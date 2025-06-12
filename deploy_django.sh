#!/bin/bash

BASE_DIR=<path_to_cloned_location>

cd $BASE_DIR

source $BASE_DIR/.venv/bin/activate

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
  pip install -r requirements.txt
fi

if [ "$MIGRATIONS_CHANGED" = true ]; then
  echo "Running migrations..."
  python manage.py migrate
fi

python manage.py collectstatic --noinput

pm2 reload <pm2_process_identifier>
