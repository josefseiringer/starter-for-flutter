@echo off
REM Production Proxy Server Starter

echo.
echo ========================================
echo   PTV Geocoding Proxy Server
echo ========================================
echo.

cd /d "%~dp0"

if not exist ".env" (
    echo ERROR: .env file not found!
    echo Please copy .env.example to .env and configure it.
    pause
    exit /b 1
)

echo Starting server...
echo.

dart run bin/server.dart

pause
