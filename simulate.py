"""
Simulate a chain of events model for contact tracing
"""

from chain_of_events.settings import PEOPLE, PLACES, TIMESTEPS, ASYMPTOMATIC_TIME
from chain_of_events.person import Person
from chain_of_events.location import Location

people = {Person(i) for i in range(PEOPLE)}
places = [Location(j) for j in range(PLACES)]
infected = {k: [] for k in range(ASYMPTOMATIC_TIME + 1)}

print("step,location,person,infected")

for step in range(TIMESTEPS):
    for person in infected[0]:
        print(f"{step},DETECTED,{person.person_id},")
        people.remove(person)
        if len(people) == 0:
            print("finished")
            break

    for person in people:
        person.enter_location(places)

    for place in places:
        place.infect_occupants(infected, step)
        place.end_step()

    for person in people:
        person.random_infect(infected)

    infected = {n - 1: infected[n] for n in infected if n > 0}
    infected[ASYMPTOMATIC_TIME] = []
