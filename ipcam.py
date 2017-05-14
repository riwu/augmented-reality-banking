from threading import Thread, Event, ThreadError
import threading
import time

import cv2
import requests

import numpy as np

class Cam():

    def __init__(self, url):
        self.stream = requests.get(url, stream=True)
        self.thread_cancelled = False
        self.thread = Thread(target=self.run)
        print("camera initialised")

    def start(self):
        self.thread.start()
        print("camera stream started")

    def compare_pixels(self, f, s):
        red_diff = abs(f[0] - s[0]) ** 2
        green_diff = abs(f[1] - s[1]) ** 2
        blue_diff = abs(f[2] - s[2]) ** 2

        return 2 * red_diff + 4 * green_diff + 3 * blue_diff

    def run(self):
        bytes = b''
        max_difference = self.compare_pixels([0, 0, 0], [255, 255, 255])

        while True:
            bytes += self.stream.raw.read(1024)
            a = bytes.find(b'\xff\xd8')
            b = bytes.find(b'\xff\xd9')
            if a != -1 and b != -1:
                jpg = bytes[a:b + 2]
                bytes = bytes[b + 2:]
                img = cv2.imdecode(np.fromstring(jpg, dtype=np.uint8), cv2.IMREAD_COLOR)
                if cv2.waitKey(1) == 27:
                    exit(0)

                cv2.imwrite('cam.jpg', img)
                (first_img, second_img) = [cv2.imread(f) for f in ('cam.jpg', 'cam.jpg')]  # TODO: need reference.jpg i.e. white floor
                if first_img.shape != second_img.shape:
                   raise Exception("Images have different dimensions")
                
                size = first_img.shape[0] * first_img.shape[1]
                count = 0
                for i in range(0, first_img.shape[0], 10):
                    for j in range(0, first_img.shape[1], 10):
                        if self.compare_pixels(first_img[i][j], second_img[i][j]) > max_difference / 10:
                            count += 1
                
                print("Surface area decreased from {0} to {1}".format(size, size - count))
            
    def is_running(self):
        return self.thread.isAlive()

    def shut_down(self):
        self.thread_cancelled = True
        # block while waiting for thread to terminate
        while self.thread.isAlive():
            time.sleep(1)
        return True

if __name__ == "__main__":
    url = 'http://10.0.14.207:8080/video'
    cam = Cam(url)
    cam.start()
