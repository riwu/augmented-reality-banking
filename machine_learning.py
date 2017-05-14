from sklearn import svm
import csv
import random
import matplotlib.pyplot as plt

def dump_data():
    arr = []
    x = []
    y = []
    for i in range(10):
        people_in_count = random.randint(0, 10)
        people_out_count = random.randint(0, 10)
        lift_width = random.randint(30, 100)
        lift_occupied_surface = random.randint(0, 50)
        wait_time = people_in_count + people_out_count + 100/lift_width + lift_occupied_surface
        wait_time_with_noise = random.randint(int(wait_time - wait_time / 10), int(wait_time + wait_time / 10))
        arr.append([wait_time_with_noise, people_in_count, people_out_count, lift_width, lift_occupied_surface])
        x.append([people_in_count, people_out_count, lift_width, lift_occupied_surface])
        y.append(wait_time_with_noise)
    with open('data.csv', 'w') as f:
        writer = csv.writer(f)
        writer.writerow(['wait_time', 'people_in_count', 'people_out_count', 'lift_width', 'lift_occupied_surface'])
        writer.writerows(arr)

    svc = svm.SVC(kernel = 'linear')
    svc.fit(x, y)
    print(svc.res)
    plt.scatter(x)



dump_data()

