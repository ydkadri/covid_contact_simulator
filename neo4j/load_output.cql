
MATCH (n) DETACH DELETE n;

// ":auto" required for periodic commit
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ydkadri/covid_contact_simulator/main/output.csv' AS row

MERGE (p:Person {person_id: toInteger(row.person)})
MERGE (l:Location {location_id: toInteger(row.location)})

WITH p, l, row
CREATE (p)-[:REGISTERS]->(v:Visit {time: toInteger(row.step)})-[:AT]->(l)
;

// Label the special case of a detection event
MATCH (l:Location {location_id: -1})
SET l.name = 'DETECTED'
;

// Create indices for query optimisation
CREATE INDEX ON :Person(person_id);
CREATE INDEX ON :Location(location_id);
CREATE INDEX ON :Visit(time);

// Create meta-visit relationship
MATCH (p:Person)--(v:Visit)--(l:Location)
CREATE (p)-[:VISITS {time: v.time}]->(l)
;

