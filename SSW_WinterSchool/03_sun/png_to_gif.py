from PIL import Image
from pathlib import Path

# List of PNG image file paths
png_files = sorted(Path("/Users/mgjeon/JHelioviewer-SWHV/Exports").glob("JHV_2025-01-14_05.56.31-*.png"))

# Open the images and store them in a list
frames = [Image.open(file) for file in png_files]

# Save the frames as a GIF
output_gif = "output.gif"
frames[0].save(output_gif, save_all=True, append_images=frames[1:], optimize=True, duration=1, loop=0)
# f = Image.open(output_gif)
# f.info['duration'] = 0.1
# f.save("output2.gif", save_all=True)

# import imageio
# for filename in png_files:

