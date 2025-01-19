import cv2
from pathlib import Path
import argparse
from tqdm import tqdm

def images_to_video(images, output_file, fps=30):
    # Get the list of image files
    # images = sorted([img for img in os.listdir(image_folder) if img.endswith(".png")])
    if not images:
        raise ValueError("No PNG images found in the specified folder.")
    
    # Get dimensions of the first image
    first_image_path = images[0]
    frame = cv2.imread(first_image_path)
    height, width, layers = frame.shape
    
    # Define the video codec and create a VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    video = cv2.VideoWriter(output_file, fourcc, fps, (width, height))
    
    # Add images to the video
    for image in tqdm(images):
        frame = cv2.imread(image)
        video.write(frame)
    
    # Release the VideoWriter object
    video.release()
    print(f"Video saved as {output_file}")

# Usage

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=str, default="")
    parser.add_argument("--doy", type=str, default=None, required=False)
    parser.add_argument("--sat", type=str, default=None, required=False)
    parser.add_argument("--fps", type=int, default=5)
    args = parser.parse_args()

    input_dir = Path(args.input_dir)
    
    sat = args.sat
    doy = args.doy 
    if sat is not None and doy is not None:
        png_files = sorted(input_dir.glob(f"*{sat}*.png"))
        output_file = input_dir / f"{args.doy}_{sat}.mp4"
    else:
        png_files = sorted(input_dir.glob("*.png"))
        output_file = input_dir / "output.mp4"
    print(len(png_files))
    images_to_video(png_files, output_file, args.fps)


# eventdoys = ["2024083", "2024084", "2024085"]

# for eventdoy in eventdoys:
#     png_files = sorted((f/eventdoy).glob("*F17*.png"))
#     print(len(png_files))

#     output_file = f"{eventdoy}_F17.mp4"
#     fps = 5  # Frames per second
#     images_to_video(png_files, output_file, fps)

#     png_files = sorted((f/eventdoy).glob("*F18*.png"))
#     print(len(png_files))
#     output_file = f"{eventdoy}_F18.mp4"
#     fps = 5  # Frames per second
#     images_to_video(png_files, output_file, fps)
