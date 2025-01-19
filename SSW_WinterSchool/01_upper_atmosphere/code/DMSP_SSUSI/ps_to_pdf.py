import os
from pathlib import Path
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=str, default="")
    args = parser.parse_args()

    input_dir = Path(args.input_dir)

    ps_files = sorted(input_dir.glob("*.ps"))
    print(len(ps_files))

    for ps_file in ps_files:
        pdf_file = ps_file.with_suffix(".pdf").name
        pdf_file = input_dir / pdf_file
        os.system(f"ps2pdf {ps_file} {pdf_file}")
        print(ps_file, pdf_file)

    # eventdoys = ["2024083", "2024084", "2024085"]

    # for eventdoy in eventdoys:
    #     (output_dir / eventdoy).mkdir(exist_ok=True, parents=True)
    #     ps_files = list((input_dir/eventdoy).glob("*.ps"))
    #     print(len(ps_files))

    #     for ps_file in ps_files:
    #         pdf_file = ps_file.with_suffix(".pdf").name
    #         pdf_file = output_dir / eventdoy / pdf_file
    #         os.system(f"ps2pdf {ps_file} {pdf_file}")
    #         print(ps_file, pdf_file)