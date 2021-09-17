# DCNN-Accelerator
VLSI (_CMP305_) course project - Spring 2021.

## Project Description
- As part of a larger ASIC chip, this implements the fully-connected layer of a Convolutional Neural
Network which processes images and classifies written digits in them.
- After convolution and pooling layers are applied (locally & high-level analysis), the fully-connected
network is applied to globally analyze the whole image, using features extracted from the CNN layers. 
- Fully-connected layers are applied by matrix multiplication of the last CNN layer output & adding a bias. Finally a softmax layer chooses the most probable label for the image.
- We have also synthesized and routed two submodules, both of which passed the testbenches written for their respective HDL files.
