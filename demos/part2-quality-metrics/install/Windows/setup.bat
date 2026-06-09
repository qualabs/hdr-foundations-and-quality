@echo off
REM ============================================================================
REM ColorVideoVDP — Windows Setup Script (one-liner install)
REM Usage:  setup.bat
REM Run from:  demos\part2-quality-metrics\install\Windows\
REM ============================================================================
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "CVVDP_REPO=%SCRIPT_DIR%..\..\colorvideovdp"
set "VENV_DIR=%CVVDP_REPO%\venv"

echo.
echo ==============================
echo  ColorVideoVDP - Win Installer
echo ==============================
echo.

REM ------------------------------------------------------------------
REM 1. Check Python 3
REM ------------------------------------------------------------------
where python >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=*" %%V in ('python --version 2^>^&1') do echo [OK] %%V found.
) else (
    echo [ERR] Python not found.
    echo       Install it from https://www.python.org/downloads/
    echo       Make sure to check "Add Python to PATH" during installation.
    exit /b 1
)

REM ------------------------------------------------------------------
REM 2. Check ffmpeg
REM ------------------------------------------------------------------
where ffmpeg >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] ffmpeg found.
) else (
    echo [ERR] ffmpeg not found.
    echo       Install it before continuing:
    echo         - Download from https://ffmpeg.org/download.html
    echo         - Or via winget:  winget install Gyan.FFmpeg
    echo         - Or via choco:   choco install ffmpeg
    echo       Make sure ffmpeg is on your PATH after installation.
    exit /b 1
)

REM ------------------------------------------------------------------
REM 3. Create / reuse virtual environment
REM ------------------------------------------------------------------
if exist "%VENV_DIR%\Scripts\activate.bat" (
    echo [OK] Virtual environment already exists at %VENV_DIR%
) else (
    echo [..] Creating virtual environment at %VENV_DIR%...
    python -m venv "%VENV_DIR%"
    echo [OK] Virtual environment created.
)

call "%VENV_DIR%\Scripts\activate.bat"
echo [OK] Activated venv.

REM ------------------------------------------------------------------
REM 4. Install PyTorch with CUDA support
REM ------------------------------------------------------------------
python -c "import torch" 2>nul
if %ERRORLEVEL% equ 0 (
    for /f "tokens=*" %%V in ('python -c "import torch; print(torch.__version__)"') do (
        echo [OK] PyTorch already installed: v%%V
    )
) else (
    echo [..] Installing PyTorch with CUDA support...
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124
    echo [OK] PyTorch installed.
)

REM Check CUDA availability
python -c "import torch; print('[OK] CUDA available: ' + str(torch.cuda.is_available()) + (' (' + torch.cuda.get_device_name(0) + ')' if torch.cuda.is_available() else ' - will use CPU (slower for video)'))"

REM ------------------------------------------------------------------
REM 5. Install ColorVideoVDP from local repo
REM ------------------------------------------------------------------
if not exist "%CVVDP_REPO%\pyproject.toml" (
    echo [ERR] ColorVideoVDP repo not found at %CVVDP_REPO%
    echo       Make sure the folder structure is intact.
    exit /b 1
)

echo [..] Installing ColorVideoVDP from %CVVDP_REPO%...
pip install -e "%CVVDP_REPO%"
echo [OK] ColorVideoVDP installed.

REM ------------------------------------------------------------------
REM 6. Sanity check
REM ------------------------------------------------------------------
echo.
echo --- Sanity Check ---
where cvvdp >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [OK] 'cvvdp' CLI is available on PATH.
) else (
    echo [!!] 'cvvdp' not on PATH. Make sure the venv is active.
)

set "ASSETS_DIR=%SCRIPT_DIR%..\..\assets"
cvvdp --display standard_fhd --test "%ASSETS_DIR%\test-blur-20.mp4" --ref "%ASSETS_DIR%\ref.mp4" --quiet 2>nul
if %ERRORLEVEL% equ 0 (
    echo [OK] Test run succeeded - you're all set!
) else (
    echo [!!] Test run had issues. Check the output above for errors.
)

echo.
echo ==============================
echo  Setup complete!
echo  To use:
echo    %VENV_DIR%\Scripts\activate.bat
echo    cd %CVVDP_REPO%
echo    cvvdp --help
echo ==============================

endlocal
