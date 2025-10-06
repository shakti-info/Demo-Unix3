#!/bin/bash
set -e
echo "Cleaning old Docker containers and images..."
docker stop $(docker ps -aq) || true
docker rm -f $(docker ps -aq) || true
docker network rm twotier || true
docker system prune -af || true
