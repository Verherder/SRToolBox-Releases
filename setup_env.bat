@echo off
chcp 65001 > nul

echo ========================================
echo SRToolBox Paddle Environment Setup
echo ========================================
echo.

where mamba >nul 2>nul
if errorlevel 1 (
    echo Mamba was not found. Install Miniforge first, then run this script again.
    goto :end
)

if not exist "environment.yml" (
    echo environment.yml not found
    goto :end
)

echo Creating or updating the paddle environment from environment.yml...
mamba env list | findstr /C:"paddle" >nul
if errorlevel 1 (
    mamba env create -f environment.yml
) else (
    mamba env update -n paddle -f environment.yml --prune
)
if errorlevel 1 (
    echo Environment setup failed
    goto :end
)

echo ========================================
echo Setup completed
echo ========================================
echo Environment name: paddle
echo Run app: mamba run -n paddle python app.py
echo ========================================

:end
echo.
echo Press Enter to exit...
pause > nul
