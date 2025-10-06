#!/bin/bash
set -e
echo "Validating running containers..."
docker ps

if curl -f http://localhost:5000 > /dev/null 2>&1; then
  echo "Flask app is running successfully!"
else
  echo "Flask app did not respond properly."
  exit 1
fi
