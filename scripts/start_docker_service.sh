#!/bin/bash
set -e
echo "Starting Docker daemon..."
systemctl start docker || service docker start
sleep 5
docker info
