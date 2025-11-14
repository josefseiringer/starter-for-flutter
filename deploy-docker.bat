@echo off
REM Quick deployment script for Docker Compose on Windows

echo.
echo ============================================
echo    Flutter Tank App - Docker Deployment
echo ============================================
echo.

REM Check if .env files exist
if not exist "backend_proxy\.env" (
    echo ERROR: backend_proxy\.env not found!
    echo Copy backend_proxy\.env.production to backend_proxy\.env and configure it.
    pause
    exit /b 1
)

if not exist ".env" (
    echo WARNING: .env not found, using .env_example
    copy .env_example .env
)

echo [OK] Environment files found
echo.

REM Build and start
echo Building and starting containers...
docker-compose up -d --build

if errorlevel 1 (
    echo ERROR: Docker Compose failed!
    pause
    exit /b 1
)

echo.
echo Waiting for services to start...
timeout /t 10 /nobreak >nul

echo.
echo ============================================
echo    Health Checks
echo ============================================

curl -s http://localhost:8088/health >nul 2>&1
if errorlevel 1 (
    echo [WARN] Backend Proxy: Not responding
) else (
    echo [OK] Backend Proxy: Healthy
)

curl -s http://localhost:8089/health >nul 2>&1
if errorlevel 1 (
    echo [WARN] Flutter Web: Not responding
) else (
    echo [OK] Flutter Web: Healthy
)

echo.
echo ============================================
echo    Container Status
echo ============================================
docker-compose ps

echo.
echo ============================================
echo    Services Running
echo ============================================
echo Backend Proxy: http://localhost:8088
echo Flutter Web:   http://localhost:8089
echo.
echo View logs: docker-compose logs -f
echo Stop:      docker-compose down
echo.
echo Deployment complete!
echo.
pause
