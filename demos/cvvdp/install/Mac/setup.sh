#!/usr/bin/env bash
# ============================================================================
# ColorVideoVDP — Mac Setup Script (one-liner install)
# Usage:  bash setup.sh
# ============================================================================
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CVVDP_REPO="$(cd "$SCRIPT_DIR/../../ColorVideoVDP" && pwd)"
VENV_DIR="$CVVDP_REPO/venv"

info()  { printf "${GREEN}[✔]${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}[!]${NC} %s\n" "$1"; }
fail()  { printf "${RED}[✘]${NC} %s\n" "$1"; exit 1; }

echo ""
echo "=============================="
echo " ColorVideoVDP — Mac Installer"
echo "=============================="
echo ""

# ------------------------------------------------------------------
# 1. Check Python 3
# ------------------------------------------------------------------
if command -v python3 &>/dev/null; then
    PY_VER="$(python3 --version 2>&1)"
    info "Python found: $PY_VER"
else
    fail "Python 3 not found. Install it from https://www.python.org/downloads/ or via Homebrew: brew install python"
fi

# ------------------------------------------------------------------
# 2. Check ffmpeg
# ------------------------------------------------------------------
if command -v ffmpeg &>/dev/null; then
    info "ffmpeg found: $(ffmpeg -version 2>&1 | head -1)"
else
    fail "ffmpeg not found. Install it before continuing:
       brew install ffmpeg          (Homebrew)
       or download from https://ffmpeg.org/download.html"
fi

# ------------------------------------------------------------------
# 3. Create / reuse virtual environment
# ------------------------------------------------------------------
if [ -d "$VENV_DIR" ] && [ -f "$VENV_DIR/bin/activate" ]; then
    info "Virtual environment already exists at $VENV_DIR"
else
    warn "Creating virtual environment at $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
    info "Virtual environment created."
fi

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
info "Activated venv (Python $(python --version 2>&1))"

# ------------------------------------------------------------------
# 4. Install PyTorch (MPS-capable on Apple Silicon, CPU on Intel)
# ------------------------------------------------------------------
if python -c "import torch" 2>/dev/null; then
    TORCH_VER="$(python -c 'import torch; print(torch.__version__)')"
    info "PyTorch already installed: v$TORCH_VER"
else
    warn "Installing PyTorch..."
    pip install torch torchvision
    info "PyTorch installed."
fi

# Verify MPS / CPU availability
python -c "
import torch
if torch.backends.mps.is_available():
    print('[✔] MPS (Apple Silicon GPU) is available — runs will be accelerated.')
else:
    print('[!] MPS not available — will run on CPU (slower for video).')
"

# ------------------------------------------------------------------
# 5. Install ColorVideoVDP from local repo
# ------------------------------------------------------------------
if [ ! -d "$CVVDP_REPO" ]; then
    fail "ColorVideoVDP repo not found at $CVVDP_REPO"
fi

warn "Installing ColorVideoVDP from $CVVDP_REPO..."
pip install -e "$CVVDP_REPO"
info "ColorVideoVDP installed."

# ------------------------------------------------------------------
# 6. Sanity check
# ------------------------------------------------------------------
echo ""
echo "--- Sanity Check ---"
if command -v cvvdp &>/dev/null; then
    info "'cvvdp' CLI is available on PATH."
else
    warn "'cvvdp' not found on PATH — make sure the venv is active."
fi

ASSETS_DIR="$(cd "$SCRIPT_DIR/../../assets" && pwd)"
cvvdp --display standard_fhd --test "$ASSETS_DIR/test-blur-20.mp4" \
      --ref "$ASSETS_DIR/ref.mp4" --quiet 2>/dev/null \
    && info "Test run succeeded — you're all set!" \
    || warn "Test run had issues. Check the output above for errors."

echo ""
echo "=============================="
echo " Setup complete!"
echo " To use:"
echo "   source $VENV_DIR/bin/activate"
echo "   cd $CVVDP_REPO"
echo "   cvvdp --help"
echo "=============================="
