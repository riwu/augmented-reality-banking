class Floor:
    def __init__(self, floor_num):
        self.floor_num = floor_num
        self.is_up_pressed = False
        self.is_down_pressed = False
        self.has_people = False

    def compute_waiting_time_up(self, lift):
        return 0

    def get_waiting_time_down(self):
        return 0