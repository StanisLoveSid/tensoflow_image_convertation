from keras import backend as K
import time
from multiprocessing.dummy import Pool
K.set_image_data_format('channels_first')
import cv2
import os
import glob
import numpy as np
from numpy import genfromtxt
import tensorflow as tf
from fr_utils import *
from inception_blocks_v2 import *

PADDING = 50
ready_to_detect_identity = True

FRmodel = faceRecoModel(input_shape=(3, 96, 96))

for file in glob.glob("images/*"):
    identity = os.path.splitext(os.path.basename(file))[0]
    encoded_image = img_path_to_encoding(file, FRmodel)
    f = open(identity,"w+")
    listed = encoded_image[0].tolist()
    str1 = ', '.join(map(str, listed))
    f.write(str1)
