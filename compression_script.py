from cv2 import imread
from cv2 import IMREAD_GRAYSCALE
from bitstring import BitArray
from os import listdir
from os.path import join, splitext
from sys import argv
from numpy import float32
from numpy import uint16
from numpy import append

# Read the file
def read_file(file_path):
    return imread(file_path, IMREAD_GRAYSCALE)

# Flatten image to be 1D
def flatten_image(img):
    return img.flatten()

# Scale image to be in range 0 -> 1
def scale_image(img):
    return img / 255

# Make sure image is float 32 bits
def make_32bits(img):
    return float32(img)

# Convert image to binary
def convert_binary(img):
    binary_img = ''

    for pixel in img:
        binary_img += BitArray(float=pixel, length=32).bin

    return binary_img

# Loop on image and do Run-Length-Encoding
def RLE_image(bit_string):
    encoding = uint16([])

    current_element = '0'
    current_count = 0

    for bit in bit_string:
        if bit == current_element:
            current_count += 1
        else:
            encoding = append(encoding, uint16(current_count))
            current_count = 1
            current_element = bit

    encoding = append(encoding, uint16(current_count))

    return encoding


def output_file(output_path, image_name, data):
    file = open(join(output_path, splitext(image_name)[0]), 'w')

    for num in data:
        file.write(str(num) + '\n')

    file.close()


# Composes the entire pipleline
def create_pipeline(input_path):
    def pipleline():
        return RLE_image(convert_binary(make_32bits(scale_image(flatten_image(read_file(input_path))))))
    
    return pipleline

input_path = argv[1]
output_path = argv[2]

for image_name in listdir(input_path):
    image_path = join(input_path, image_name)
    data = create_pipeline(image_path)()
    output_file(output_path, image_name, data)
