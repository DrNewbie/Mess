from PIL import Image
from resizeimage import resizeimage
import sys

argv = sys.argv[1:]

inputfile = str(argv[0])
outputfile = str(argv[1])
re_w = int(argv[2])
re_h = int(argv[3])

img = Image.open(inputfile)

nim = img.resize((re_w, re_h), Image.BILINEAR)

nim.save(outputfile)