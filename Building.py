from Floor import Floor
from Lift import Lift


class Building:
    max_people_count = 50
    wait_time_in = [3 * i for i in range(0, max_people_count + 1)]
    wait_time_out = [3 * i for i in range(0, max_people_count + 1)]
    wait_time_in_out = [wait_time_in * max_people_count]

    def __init__(self, floor_count, lift_count):
        self.floors = [Floor(floor_num=i) for i in range(floor_count)]
        self.lifts = [Lift(max_weight=1000, current_floor=0) for _ in range(lift_count)]

        self.floor_exit_counts = [[1 for _ in range(Building.max_people_count)] * floor_count]

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

building = Building(100, 2)
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

building.lifts[0].destinations = [2, 4, 80]
waiting_time = building.compute_waiting_time(10, building.lifts[0], for_up=False)
print(waiting_time)

