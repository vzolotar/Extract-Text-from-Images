#!/usr/bin/env bash
# Very compact version - good for copy-paste

python3 -c '
from PIL import Image
import pytesseract
try:
    print(pytesseract.image_to_string(Image.open("testfile.jpg"), lang="eng").strip())
except Exception as e:
    print("Error:", e, file=__import__("sys").stderr)
' > extracted_text.txt && {
    echo "Done. Result saved to extracted_text.txt"
    echo "----------------------------------------"
    cat extracted_text.txt
    echo "----------------------------------------"
} || echo "Failed. Check if testfile.jpg exists and pytesseract is installed."
