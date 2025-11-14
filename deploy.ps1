# PowerShell Deployment script for Flutter Web App

Write-Host "🚀 Starting deployment..." -ForegroundColor Green

# Build Docker image
Write-Host "📦 Building Docker image..." -ForegroundColor Yellow
docker build -t flutter-tanken-app:latest .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

# Stop and remove old container if exists
Write-Host "🛑 Stopping old container..." -ForegroundColor Yellow
docker stop flutter-tanken-app 2>$null
docker rm flutter-tanken-app 2>$null

# Run new container
Write-Host "▶️  Starting new container..." -ForegroundColor Yellow
docker run -d `
  --name flutter-tanken-app `
  -p 8088:8088 `
  --restart unless-stopped `
  flutter-tanken-app:latest

# Check if container is running
$running = docker ps -q -f name=flutter-tanken-app

if ($running) {
    Write-Host "✅ Deployment successful!" -ForegroundColor Green
    Write-Host "🌐 App is running at http://localhost:8080" -ForegroundColor Cyan
    docker logs flutter-tanken-app
} else {
    Write-Host "❌ Deployment failed!" -ForegroundColor Red
    docker logs flutter-tanken-app
    exit 1
}
