#!/bin/bash
set -e
cd /var/www/html

echo "Building Flask app Docker image..."
docker build -t flaskapp .

echo "Pulling MySQL image..."
docker pull mysql:5.7

echo "Running MySQL container..."
docker rm -f mysql1 || true
docker run -d -p 3306:3306 --network=twotier \
  -e MYSQL_DATABASE=mydb \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=admin \
  -e MYSQL_ROOT_PASSWORD=admin \
  --name=mysql1 mysql:5.7

echo "Waiting for MySQL to initialize..."
sleep 25

echo "Running Flask app container..."
docker rm -f newflaskapp || true
docker run -d -p 5000:5000 --network=twotier \
  -e MYSQL_HOST=mysql1 \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=admin \
  -e MYSQL_DB=mydb \
  --name=newflaskapp flaskapp:latest
