#!/bin/bash
set -e
echo "Setting up Docker network..."
docker network create twotier || echo "Network already exists"
