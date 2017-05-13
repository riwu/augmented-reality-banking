from Floor import Floor
from Lift import Lift

class Building:
    def __init__(self, floor_count, lift_count):
        self.floors = [Floor(floor_num=i, lift_count=lift_count) for i in range(1, floor_count + 1)]
        self.lifts = [Lift(max_weight=1000, current_floor=1) for i in range(lift_count)]

    def compute_waiting_time(self, floor, lift, for_up):
        pass

building = Building(10, 2)
building.compute_waiting_time()
