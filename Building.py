from Floor import Floor
from Lift import Lift
from time import sleep
import json
import random
import re
import ast

class Building:
    max_people_count = 50
    wait_time_in = [3 * i for i in range(0, max_people_count + 1)]
    wait_time_out = [3 * i for i in range(0, max_people_count + 1)]
    wait_time_in_out = [wait_time_in * max_people_count]

    def __init__(self, floor_count, lift_count):
        self.floors = [Floor(floor_num=i) for i in range(floor_count)]
        self.lifts = [Lift(max_weight=1000, current_floor=0) for _ in range(lift_count)]
        self.floor_exit_counts = [[1 for _ in range(Building.max_people_count)] * floor_count]

    def run(self):
        while True:
            f = open('javascript.json')
            data = None
            try:
                str = f.read()
                result = re.split('PARSE:(.*)", sou', str)
                if len(result) > 1:
                    data = result[1]
                    open('javascript.json').close()  # to clear content
                else:
                    print('no result')
            except Exception as e:
                print('error', e)
            finally:
                f.close()

            if data:
                data = json.loads(data)
                for floor_num, value in data['floors'].items():
                    floor = self.floors[int(floor_num)]
                    floor.people_count = value['people_count']
                    floor.is_up_pressed = value['is_up_pressed']
                    floor.is_down_pressed = value['is_down_pressed']
                    if floor.is_down_pressed:
                        print("pressed up")

            lift = self.lifts[0]
            if len(lift.destinations) == 0:
                for floor in self.floors:
                    if floor.is_up_pressed or floor.is_down_pressed:
                        lift.destinations.append(floor.floor_num)
            else:
                is_going_up = lift.current_floor < lift.destinations[0]
                increment = 1 if is_going_up else -1
                lift.current_floor += increment
                sleep(lift.speed)

                current_floor = self.floors[lift.current_floor]
                has_people_going_in = (is_going_up and current_floor.is_up_pressed) or \
                                      (not is_going_up and current_floor.is_down_pressed)
                if current_floor in lift.destinations:
                    lift.destinations.remove(lift.current_floor)
                    if lift.people_count >= 1:
                        lift.people_count -= random.randint(1, lift.people_count)
                    if has_people_going_in:
                        sleep(Building.wait_time_in_out[current_floor.get_people_count()][lift.get_people_count()])
                    else:
                        sleep(Building.wait_time_out[lift.get_people_count()])
                elif has_people_going_in and lift.has_vacancy():
                    sleep(Building.wait_time_in[current_floor.get_people_count()])

                if has_people_going_in and lift.has_vacancy():  # skip floor if no vacancy
                    # assign a random number of ppl to go in if both up and down pressed
                    people_remaining = 0 if (not floor.is_up_pressed or not floor.is_down_pressed) else \
                        random.randint(1, current_floor.people_count - 1)
                    while lift.has_vacancy() and (current_floor.people_count > people_remaining):
                        lift.people_count += 1
                        current_floor.people_count -= 1

                    if is_going_up:
                        floor.is_up_pressed = False
                    else:
                        floor.is_down_pressed = False

                    # randomly assign destination for new passenger
                    rand_increment = 0
                    while lift.current_floor + rand_increment >= 0 and lift.current_floor + rand_increment < len(
                            self.floors):
                        rand_increment += increment
                    lift.destinations.append(lift.current_floor + random.randint(1, rand_increment))

            self.write_to_file()

    def write_to_file(self):
        with open('python.json', 'w') as f:
            json_dump = {'floor': {
                floor.floor_num: {'people_count': floor.people_count, 'is_up_pressed': floor.is_up_pressed,
                                  'is_down_pressed': floor.is_down_pressed,
                                  'wait_time_up': self.compute_waiting_time(floor.floor_num, self.lifts[0], True),
                                  'wait_time_down': self.compute_waiting_time(floor.floor_num, self.lifts[0], False),
                                  'capacity_up': self.compute_capacity(floor, self.lifts[0], True),
                                  'capacity_down': self.compute_capacity(floor, self.lifts[0], False)}
                for floor in self.floors},
                'lift_people_count': self.lifts[0].people_count, 'lift_level': self.lifts[0].current_floor,
                'lift_destinations': self.lifts[0].destinations}
            f.write(json.dumps(json_dump))
            f.close()

    def compute_capacity(self, floor, lift, for_up):
        capacity = lift.get_capacity()
        has_reached_floor = False
        if len(lift.destinations) > 0:
            is_going_up = lift.current_floor < lift.destinations[0]
            final_destination = lift.destinations[-1] if is_going_up else lift.destinations[0]
            net_gain, has_reached_floor = self._compute_capacity(floor, lift, for_up, start=lift.current_floor,
                                                                 end=final_destination)
            capacity += net_gain
        else:
            final_destination = lift.current_floor

        if not has_reached_floor:
            time, _ = self._compute_capacity(floor, lift, for_up, start=final_destination, end=floor.floor_num)
            capacity = lift.get_max_capacity() + net_gain
        return capacity

    def _compute_capacity(self, floor, lift, for_up, start, end):
        net_gain = 0
        is_going_up = start < end
        increment = (1 if is_going_up else -1)
        for current_floor_num in range(start + increment, end + increment, increment):
            if current_floor_num == floor.floor_num and (is_going_up == for_up or not lift.is_moving):
                return (net_gain, True)

            current_floor = self.floors[current_floor_num]
            has_people_going_in = (is_going_up and current_floor.is_up_pressed) or \
                                  (not is_going_up and current_floor.is_down_pressed)
            if current_floor_num in lift.destinations:
                net_gain -= 1
            if has_people_going_in:
                net_gain += current_floor.people_count if (not floor.is_up_pressed or not floor.is_down_pressed)  else 1
        return (net_gain, False)

    def compute_waiting_time(self, floor_num, lift, for_up):
        total_time = 0
        has_reached_floor = False
        if len(lift.destinations) > 0:
            is_going_up = lift.current_floor < lift.destinations[0]
            final_destination = lift.destinations[-1] if is_going_up else lift.destinations[0]
            time, has_reached_floor = self._compute_travel_time(floor_num, lift, for_up, start=lift.current_floor,
                                                                end=final_destination, check_going_out=True)
            total_time += time
        else:
            final_destination = lift.current_floor

        if not has_reached_floor:
            time, _ = self._compute_travel_time(floor_num, lift, for_up, start=final_destination,
                                                end=floor_num, check_going_out=False)
            total_time += time

        return total_time

    def _compute_travel_time(self, floor_num, lift, for_up, start, end, check_going_out):
        time = 0
        is_going_up = start < end
        increment = (1 if is_going_up else -1)
        for current_floor_num in range(start + increment, end + increment, increment):
            if current_floor_num == floor_num and (is_going_up == for_up or not lift.is_moving):
                return (time, True)

            time += lift.speed

            current_floor = self.floors[current_floor_num]
            has_people_going_in = (is_going_up and current_floor.is_up_pressed) or \
                                  (not is_going_up and current_floor.is_down_pressed)
            if check_going_out and current_floor_num in lift.destinations:
                if has_people_going_in:
                    time += Building.wait_time_in_out[current_floor.get_people_count()][lift.get_people_count()]
                else:
                    time += Building.wait_time_out[lift.get_people_count()]
            elif has_people_going_in:
                time += Building.wait_time_in[current_floor.get_people_count()]

        return (time, False)

    def get_exit_count(self, floor_num, lift):
        if floor_num not in lift.destinations:
            return 0

        if len(lift.destinations) == 0:
            return lift.get_people_count()

        return self.floor_exit_counts[floor_num][lift.get_people_count()]


building = Building(50, 2)
waiting_time = building.compute_waiting_time(0, building.lifts[0], for_up=True)
print(waiting_time)
waiting_time = building.compute_waiting_time(10, building.lifts[0], for_up=True)
print(waiting_time)

building.lifts[0].is_moving = True
building.lifts[0].destinations = [2]
waiting_time = building.compute_waiting_time(10, building.lifts[0], for_up=True)
print(waiting_time)

building.lifts[0].destinations = [2, 20]
waiting_time = building.compute_waiting_time(10, building.lifts[0], for_up=True)
print(waiting_time)

building.lifts[0].destinations = [2, 4, 40]
waiting_time = building.compute_waiting_time(10, building.lifts[0], for_up=False)
print(waiting_time)

building = Building(5, 2)
building.lifts[0].people_count = 10
building.lifts[0].destinations = [2, 3]
building.write_to_file()

building.run()
