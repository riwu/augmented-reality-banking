class Floor:

    def __init__(self, floor_num):
        self.floor_num = floor_num
        self.is_up_pressed = False
        self.is_down_pressed = False
        self.people_count = 0

    # in actual use, will be detected through opencv
    def get_people_count(self):
        return self.people_count