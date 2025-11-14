#!/bin/bash

# Deployment script for Flutter Web App

echo "🚀 Starting deployment..."

# Build Docker image
echo "📦 Building Docker image..."
docker build -t flutter-tanken-app:latest .

# Stop and remove old container if exists
echo "🛑 Stopping old container..."
docker stop flutter-tanken-app 2>/dev/null || true
docker rm flutter-tanken-app 2>/dev/null || true

# Run new container
echo "▶️  Starting new container..."
docker run -d \
  --name flutter-tanken-app \
  -p 8080:8088 \
  --restart unless-stopped \
  flutter-tanken-app:latest

# Check if container is running
if [ $(docker ps -q -f name=flutter-tanken-app) ]; then
    echo "✅ Deployment successful!"
    echo "🌐 App is running at http://localhost:8080"
    docker logs flutter-tanken-app
else
    echo "❌ Deployment failed!"
    docker logs flutter-tanken-app
    exit 1
fi
