class Lift:
    # to be recomputed via automatic data collection
    lightest_passenger_weight = 40

    # max_weight: max weight capacity of the elevator
    def __init__(self, max_weight, current_floor):
        self._max_weight = max_weight
        self.current_floor = current_floor
        self.destinations = []
        # How many sec it takes to go up/down 1 floor
        self.speed = 1

    def get_people_count(self):
        return 1 # TODO count num of ppl currently in lift

    # Returns whether there's vacancy for at least one person
    def has_vacancy(self):
        return self._has_weight_capacity() and self._has_standing_capacity()

    # Get the current weight of the elevator. Done through weight sensor in elevator
    def _get_current_weight(self):
        return 0

    # Returns whether there's sufficient weight capacity left for one person
    def _has_weight_capacity(self):
        return self._get_current_weight + Lift.lightest_passenger_weight <= self._max_weight

    # Returns whether there's sufficient surface capacity left for one person to stand
    def _has_standing_capacity(self):
        return 0  # TODO use opencv to get this