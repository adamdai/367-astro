import matplotlib.pyplot as plt
import numpy as np
from scipy import ndimage

def pad_furthest_corner(I, x, y):
    # Pads the image such that the x,y center is in the center of the image, and that the image can be fully rotated
    H,W = I.shape
    diag_dist = int(np.ceil(np.sqrt(max(y,H-y)**2+max(x,W-x)**2)))
    top_pad = diag_dist - y
    bot_pad = diag_dist - (H-y)
    left_pad = diag_dist - x
    right_pad = diag_dist - (W-x)
    pad_widths = [top_pad, bot_pad, left_pad, right_pad]
    I_pad = np.pad(I, ((top_pad,bot_pad),(left_pad,right_pad)), 'constant')
    return I_pad, pad_widths

def unpad_furthest_corner(I_pad, pad_widths):
    t,b,l,r = pad_widths
    return I_pad[t:-b, l:-r]

def rotate_blur_image(I, blur_th, x, y):
    I_pad, pad_widths = pad_furthest_corner(I, x, y)
    I_rot = I_pad
    blur_angles = np.linspace(0, blur_th, 100)
    for th in blur_angles:
        I_rot = I_rot + ndimage.rotate(I_pad, th, reshape=False)
        I_rot = normalize_01(I_rot)
        I_rot = I_rot > 0.25
    return unpad_furthest_corner(I_rot, pad_widths)

def normalize_01(I):
    # Normalizes image pixels to the range 0-1
    return (I-np.min(I))/(np.max(I)-np.min(I))

def make_dataset():
    H = 250
    W = 250

    thresh_vals = 1-np.logspace(-3, -1, 100)
    x_coords = range(50, 200)
    y_coords = range(50, 200)
    blur_th_vals = np.linspace(5, 15, 100)

    n_images = 100

    with open('neural_network_data/labels.txt', 'w') as f:
        for i in range(n_images):
            # Choose random values for sparsity threshold, (x,y) rotation center, and blur angle
            thresh = np.random.choice(thresh_vals)
            x = np.random.choice(x_coords)
            y = np.random.choice(y_coords)
            blur_th = np.random.choice(blur_th_vals)

            I = np.random.rand(H,W)
            I = I*(I > thresh)
            I_rot = rotate_blur_image(I, blur_th, x, y)

            plt.imsave('neural_network_data/img%d.jpg' % i, I_rot, cmap='gray')
            f.write('%d,%d\n' % (x,y))

if __name__ == '__main__':
    make_dataset()
