@echo off
REM Setup script for Appointment Authentication API

echo.
echo ================================================
echo  Appointment Authentication API - Setup Script
echo ================================================
echo.

REM Check if .NET 8 is installed
echo Checking .NET installation...
dotnet --version
if %errorlevel% neq 0 (
    echo ERROR: .NET SDK not found!
    echo Please install .NET 8 from: https://dotnet.microsoft.com/en-us/download/dotnet/8.0
    pause
    exit /b 1
)

echo.
echo [1/4] Restoring NuGet packages...
dotnet restore
if %errorlevel% neq 0 (
    echo ERROR: Failed to restore packages!
    pause
    exit /b 1
)

echo.
echo [2/4] Installing EF Core tools (if not already installed)...
dotnet tool install --global dotnet-ef --version 8.0.0 >nul 2>&1
echo EF Core tools ready

echo.
echo [3/4] Creating database migration...
dotnet ef migrations add InitialCreate
if %errorlevel% neq 0 (
    echo ERROR: Failed to create migration!
    pause
    exit /b 1
)

echo.
echo [4/4] Applying migration to database...
dotnet ef database update
if %errorlevel% neq 0 (
    echo ERROR: Failed to update database!
    pause
    exit /b 1
)

echo.
echo ================================================
echo  Setup Complete! ✓
echo ================================================
echo.
echo Starting the application...
echo Swagger UI will open at: http://localhost:5000
echo.
dotnet run
pause
