"""
Configuration settings for the chain of events model

The initial conditions are configured through people/locations
as well as a probability for any person to visit any location
at a given timestep.

From that, and a configured target number of events, the
required number of timesteps is calculated. Note that this
model removes a person from the pool once they have been
marked as infected - this could be interpreted as isolation
or future immunity for the infected individual.

Probabilities are configured for both a random infection (or
rather one whose source cannot be identified) and a contact
infection should two individuals be identified in the same
place at the same time.

Finally the asymptomatic time is the time between an infection
and that individual receiving a positive test and therefore
being removed from the population
"""

# Upper bound for likely number of events
# Note that as paths terminate with an identified infection
# this is unlikely to be realised
_TARGET_EVENTS = 45000

# Initial conditions for the simulation
PLACES = 100
PEOPLE = 1000
P_VISIT = 0.25

TIMESTEPS = int(_TARGET_EVENTS / (PEOPLE * P_VISIT))

# Probabilities of random and contact based infection
P_RANDOM_INFECTION = 0.0001
P_CONTACT_INFECTION = 0.25

# Time between being infected and identifying an infection
ASYMPTOMATIC_TIME = 10
ASYMPTOMATIC_VARIANCE = 3
