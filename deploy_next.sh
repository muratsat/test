#!/bin/bash

BASE_DIR=<path_to_cloned_location>

cd $BASE_DIR

git fetch

DEPENDENCIES_CHANGED=false
if ! git diff --quiet HEAD..origin/main -- package.json; then
  DEPENDENCIES_CHANGED=true
fi


MIGRATIONS_CHANGED=false
if ! git diff --quiet HEAD..origin/main -- src/server/db/schema.ts; then
  MIGRATIONS_CHANGED=true
fi

git pull


if [ "$DEPENDENCIES_CHANGED" = true ]; then
  echo "Installing dependencies..."
  pnpm i
fi


if [ "$MIGRATIONS_CHANGED" = true ]; then
  echo "Running migrations..."
  pnpm db:push
fi

pnpm build

pm2 reload <pm2_process_identifier>
