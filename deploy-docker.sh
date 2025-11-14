#!/bin/bash
# Quick deployment script für Docker Compose

set -e

echo "🚀 Starting Flutter Tank App Deployment"
echo "========================================"
echo ""

# Check if .env files exist
if [ ! -f "backend_proxy/.env" ]; then
    echo "❌ ERROR: backend_proxy/.env not found!"
    echo "   Copy backend_proxy/.env.production to backend_proxy/.env and configure it."
    exit 1
fi

if [ ! -f ".env" ]; then
    echo "⚠️  WARNING: .env not found, using .env_example"
    cp .env_example .env
fi

echo "✅ Environment files OK"
echo ""

# Build and start
echo "📦 Building and starting containers..."
docker-compose up -d --build

echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 10

# Check health
echo ""
echo "🏥 Health Checks:"
echo "-----------------"

PROXY_HEALTH=$(curl -s http://localhost:8088/health || echo "FAILED")
if [[ "$PROXY_HEALTH" == *"healthy"* ]]; then
    echo "✅ Backend Proxy: healthy"
else
    echo "❌ Backend Proxy: unhealthy"
fi

WEB_HEALTH=$(curl -s http://localhost:8089/health || echo "FAILED")
if [[ "$WEB_HEALTH" == *"healthy"* ]]; then
    echo "✅ Flutter Web: healthy"
else
    echo "❌ Flutter Web: unhealthy"
fi

echo ""
echo "📊 Container Status:"
docker-compose ps

echo ""
echo "🌐 Services:"
echo "   Backend Proxy: http://localhost:8088"
echo "   Flutter Web:   http://localhost:8089"
echo ""
echo "📋 View logs: docker-compose logs -f"
echo "🛑 Stop:      docker-compose down"
echo ""
echo "✅ Deployment complete!"
