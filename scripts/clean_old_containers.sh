#!/bin/bash
set -e

echo "Cleaning old Docker containers and images..."

# Stop all running containers (if any)
if [ "$(docker ps -q)" ]; then
  docker stop $(docker ps -q)
fi

# Remove all containers (if any)
if [ "$(docker ps -aq)" ]; then
  docker rm -f $(docker ps -aq)
fi

# Remove the network 'twotier' if it exists
if docker network ls | grep -q 'twotier'; then
  docker network rm twotier
fi

# Prune all unused Docker data (containers, images, networks, etc.)
docker system prune -af || true
