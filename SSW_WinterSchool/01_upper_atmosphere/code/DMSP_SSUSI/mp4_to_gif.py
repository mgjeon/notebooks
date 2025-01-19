from moviepy.video.io.VideoFileClip import VideoFileClip
from pathlib import Path
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=str, default="")
    parser.add_argument("--width", type=int, default=None)
    args = parser.parse_args()

    input_dir = Path(args.input_dir)

    mp4_files = sorted(Path(input_dir).glob("*.mp4"))
    for mp4_file in mp4_files:
        # Load video clip
        clip = VideoFileClip(mp4_file)

        # Resize the clip (optional, adjust width to reduce size)
        if args.width:
            clip = clip.resized(width=args.width) # Change width as needed

        output_gif = mp4_file.with_suffix(".gif")

    # Write the GIF file
        clip.write_gif(output_gif, fps=10)  # Adjust FPS if needed