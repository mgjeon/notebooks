import fitz  # PyMuPDF
from pathlib import Path
import argparse

def pdf_to_png(pdf_path, png_path):
    pdf_document = fitz.open(pdf_path)
    assert len(pdf_document) == 1
    page = pdf_document.load_page(0)
    pix = page.get_pixmap()
    pix.save(png_path)
    print(f"Saved: {png_path}")

    pdf_document.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=str, default="")
    args = parser.parse_args()

    input_dir = Path(args.input_dir)

    pdf_files = list(input_dir.glob("*.pdf"))
    print(len(pdf_files))

    for pdf_file in pdf_files:
        png_file = pdf_file.with_suffix(".png")
        pdf_to_png(pdf_file, png_file)

# eventdoys = ["2024083", "2024084", "2024085"]

# for eventdoy in eventdoys:
#     pdf_files = list((f/eventdoy).glob("*.pdf"))
#     print(len(pdf_files))

#     for pdf_file in pdf_files:
#         png_file = pdf_file.with_suffix(".png")
#         pdf_to_png(pdf_file, png_file)
#         print(pdf_file, png_file)
