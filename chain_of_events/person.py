"""The person class for infection modelling
"""
import random

from typing import List

from .location import Location
from .settings import (
    ASYMPTOMATIC_TIME,
    ASYMPTOMATIC_VARIANCE,
    P_VISIT,
    P_CONTACT_INFECTION,
    P_RANDOM_INFECTION,
)


class Person:
    """A person in an infection model

    A Person is initialised with an ID and an uninfected state.
    Methods exist for a person to possibly enter a location, and
    be infected either randomly or through a contact
    """

    def __init__(self, person_id):
        self.__person_id = person_id
        self.infected_status = "Healthy"

    @property
    def person_id(self):
        """Return the person ID"""
        return self.__person_id

    def enter_location(self, locations: List[Location]):
        """Enter a random location from a locations list"""
        if random.random() < P_VISIT:
            location = random.choice(locations)
            location.occupants.append(self)
            if self.infected_status == "Sick":
                location.infected_occupants = True

    def _infect(self, infected: dict):
        if self.infected_status == "Healthy":
            position = ASYMPTOMATIC_TIME - random.randint(0, ASYMPTOMATIC_VARIANCE)
            infected[position].append(self)
        self.infected_status = "Sick"

    def random_infect(self, infected: list):
        """Possibly become infected through random chance"""
        if random.random() < P_RANDOM_INFECTION:
            self._infect(infected)

    def contact_infect(self, infected: list):
        """Possibly become infected through contact"""
        if random.random() < P_CONTACT_INFECTION:
            self._infect(infected)
