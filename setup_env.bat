@echo off
chcp 65001 > nul

echo ========================================
echo Python 3.10 Setup Script
echo ========================================
echo.

:: Check Python 3.10
python --version 2>nul | find "Python 3.10" > nul
if %errorlevel% equ 0 (
    echo Python 3.10 is already installed
    goto :skip_python
) else (
    echo Python 3.10 not found, installing...
)

:: Download and install Python 3.10.11
set PYTHON_URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe
set PYTHON_EXE=python-3.10.11.exe

echo Downloading Python 3.10.11...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_EXE%'"

if not exist "%PYTHON_EXE%" (
    echo Download failed
    goto :end
)

echo Installing Python...
start /wait "" "%PYTHON_EXE%" /quiet InstallAllUsers=1 PrependPath=1
del /f /q "%PYTHON_EXE%" 2>nul
echo Python 3.10 installation completed
echo.

:skip_python

:: Check requirements.txt
if not exist "requirements.txt" (
    echo Warning: requirements.txt not found
)

:: Create venv if not exists
if not exist "D:\venv\Scripts\python.exe" (
    echo Creating virtual environment D:\venv...
    python -m venv D:\venv
) else (
    echo Virtual environment D:\venv already exists
)

:: Activate venv and install dependencies
echo Installing dependencies...
call D:\venv\Scripts\activate.bat

set PYTHONIOENCODING=utf-8
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo.

:: Install VC Redistributable (optional, last step)
echo Installing VC Redistributable (optional)...
set VC_URL=https://aka.ms/vc-redist.x86
set VC_EXE=vc_redist.x86.exe

if exist "%VC_EXE%" del /f /q "%VC_EXE%" 2>nul
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%VC_URL%' -OutFile '%VC_EXE%' -UserAgent 'Mozilla/5.0'"

if not exist "%VC_EXE%" (
    echo VC Redistributable download failed, skipping
    goto :skip_vc
)

"%VC_EXE%" /install /quiet /norestart
if errorlevel 1 (
    echo VC Redistributable installation failed, skipping
) else (
    echo VC Redistributable installed
)
del /f /q "%VC_EXE%" 2>nul

:skip_vc
echo.

echo ========================================
echo Setup completed
echo ========================================
echo Venv path: D:\venv
echo Run app: D:\venv\Scripts\python.exe src\app.py
echo ========================================

:end
echo.
echo Press Enter to exit...
pause > nul