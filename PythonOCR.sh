#!/usr/bin/env bash

# =============================================================================
# Shell + embedded Python one-file solution to extract text from testfile.jpg
# Requires: tesseract-ocr, python3, pip packages: pillow, pytesseract
# =============================================================================

# You can install dependencies (on Ubuntu/Debian) with:
# sudo apt update && sudo apt install -y tesseract-ocr libtesseract-dev
# python3 -m pip install --user pillow pytesseract

OUTPUT_FILE="extracted_text.txt"

# ──────────────────────────────────────────────────────────────────────────────
# The embedded Python code
# ──────────────────────────────────────────────────────────────────────────────

read -r -d '' PYTHON_CODE << 'EOF'
import sys
from PIL import Image
import pytesseract

try:
    img = Image.open("testfile.jpg")
    text = pytesseract.image_to_string(img, lang="eng")
    
    # Clean up a bit (optional)
    text = text.strip()
    lines = [line.rstrip() for line in text.splitlines() if line.strip()]
    cleaned_text = "\n".join(lines)
    
    print(cleaned_text)
except FileNotFoundError:
    print("Error: testfile.jpg not found in current directory", file=sys.stderr)
    sys.exit(1)
except Exception as e:
    print(f"Error during OCR: {e}", file=sys.stderr)
    sys.exit(1)
EOF

# ──────────────────────────────────────────────────────────────────────────────

echo "Running OCR on testfile.jpg ..."

# Run the embedded python code and save result
python3 -c "$PYTHON_CODE" > "$OUTPUT_FILE"

if [ $? -eq 0 ] && [ -s "$OUTPUT_FILE" ]; then
    echo ""
    echo "Text extracted successfully and saved to: $OUTPUT_FILE"
    echo "───────────────────────────────────────────────"
    cat "$OUTPUT_FILE"
    echo "───────────────────────────────────────────────"
else
    echo ""
    echo "Failed to extract text or output file is empty."
    echo "Make sure:"
    echo "  • testfile.jpg exists in current directory"
    echo "  • tesseract-ocr is installed"
    echo "  • python packages pillow and pytesseract are installed"
    rm -f "$OUTPUT_FILE" 2>/dev/null
fi
