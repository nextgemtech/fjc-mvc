#!/bin/bash
set -e

echo "DATABASE_URL: $DATABASE_URL"

# Function to wait for PostgreSQL using DATABASE_URL
wait_for_postgres() {
  local database_url="$1"
  local max_attempts=20
  local attempt=1

  until pg_isready -d "$database_url"; do
    if [ "$attempt" -eq "$max_attempts" ]; then
      echo "Postgres is unavailable - exiting after $attempt attempts."
      exit 1
    fi
    echo "Postgres is unavailable - sleeping ($attempt/$max_attempts)"
    attempt=$((attempt + 1))
    sleep 5
  done

  echo "Postgres is up - continuing..."
}

# Wait for PostgreSQL to be available
wait_for_postgres "$DATABASE_URL"

# Remove any existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Run database setup
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# Exec the container's main process (CMD)
exec "$@"
