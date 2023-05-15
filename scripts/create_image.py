import argparse
import os
from PIL import Image, ImageDraw, ImageFont

parser = argparse.ArgumentParser(description="Create PNG images with text.")
parser.add_argument("text", help="The text to add to the image.")
parser.add_argument("font", help="The font file to use.")
parser.add_argument("-s", "--size", type=int, default=12, help="The font size.")
parser.add_argument("-c", "--color", default="black", help="The text color.")
args = parser.parse_args()

# Define the font and size
font_path = args.font
font_size = args.size
font = ImageFont.truetype(font_path, font_size)

# Define the text and color
text = args.text
color = args.color

# Set the image size and color mode
img_size = (56, 90)
color_mode = 'RGBA'

# Create a new image with transparent background
img = Image.new(color_mode, img_size, (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Create a rectangle to hold the text
#rect = draw.textbbox((0, 0), text, font=font)

# Find the center point of the rectangle
#center_x = (img_size[0] - (rect[2] - rect[0])) / 2
#center_y = (img_size[1] - (rect[3] - rect[1])) / 2

# Draw the text in the center of the rectangle
#draw.text((center_x, center_y), text, font=font, fill=color)

# Create a rectangle to hold the text
textwidth, textheight = draw.textsize(text, font=font)
x = (img_size[0] - textwidth) / 2
y = img_size[1] - textheight
rect = (x, y, x + textwidth, y + textheight)

# Draw the text in the center of the rectangle
draw.text((x, y), text, font=font, fill=color, antialias=True)

# Draw the rectangle
#draw.rectangle(rect, outline="red")

# Save the image as PNG
dirname = f"./{font_path[:20]}_{font_size}_{color}"
# create directory if it does not exist
if not os.path.exists(dirname):
    os.makedirs(dirname)
filename = f"{dirname}/{text}.png"

# OPTIMIZE
img = img.convert("P", palette=Image.ADAPTIVE, colors=256)
img.save(filename, optimize=True)

print(f"Image saved as {filename}")