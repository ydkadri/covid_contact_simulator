"""The location class for infection modelling
"""


class Location:
    """A location into which a Person can scan

    A location is initialised and ends empty, and with a False
    flag for infected occupancy. This is updated by Persons
    entering the location and is reset in the end step
    """

    def __init__(self, location_id):
        self.__location_id = location_id
        self.occupants = []
        self.infected_occupants = False

    @property
    def location_id(self):
        """Return the location ID"""
        return self.__location_id

    def infect_occupants(self, infected: dict, step: int):
        """Infect the occupants of a location"""
        for occupant in self.occupants:
            if self.infected_occupants:
                occupant.contact_infect(infected)
            print(
                f"{step},{self.location_id},{occupant.person_id},{occupant.infected_status}"
            )

    def end_step(self):
        """Clean up the location after a step"""
        self.occupants = []
        self.infected_occupants = False
