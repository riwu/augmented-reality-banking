import cv2
import sys

def compare_pixels(f, s):
    red_diff = abs(f[0] - s[0]) ** 2
    green_diff = abs(f[1] - s[1]) ** 2
    blue_diff = abs(f[2] - s[2]) ** 2

    return 2 * red_diff + 4 * green_diff + 3 * blue_diff

max_difference = compare_pixels([0, 0, 0], [255, 255, 255])

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python {0} first_image.jpg second_image.jpg".format(sys.argv[0]))
        quit()

    (first_img, second_img) = [cv2.imread(f) for f in (sys.argv[1], sys.argv[2])]
    if first_img.shape != second_img.shape:
        raise Exception("Images have different dimensions")

    size = first_img.shape[0] * first_img.shape[1]
    count = 0
    for i in range(0, first_img.shape[0]):
        for j in range(0, first_img.shape[1]):
            if compare_pixels(first_img[i][j], second_img[i][j]) > max_difference / 10:
                count += 1

    print("Surface area decreased from {0} to {1}".format(size, size - count))
