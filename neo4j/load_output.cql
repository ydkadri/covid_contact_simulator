
MATCH (n) DETACH DELETE n;

// ":auto" required for periodic commit
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ydkadri/covid_contact_simulator/main/output.csv' AS row

MERGE (p:Person {person_id: toInteger(row.person)})
MERGE (l:Location {location_id: toInteger(row.location)})

WITH p, l, row
CREATE (p)-[:REGISTERS]->(v:Visit {time: toInteger(row.step)})-[:AT]->(l)
;

// Set the sick/healthy status
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ydkadri/covid_contact_simulator/main/output.csv' AS row

MATCH (p:Person {person_id: toInteger(row.person)})
SET p.status = row.status
;

// Create indices for query optimisation
CREATE INDEX idx_person_personid IF NOT EXISTS
    FOR (p:Person)
    ON (p.person_id)
;

CREATE INDEX idx_location_locationid IF NOT EXISTS
    FOR (l:Location)
    ON (l.location_id)
;

CREATE INDEX idx_visit_time IF NOT EXISTS
    FOR (v:Visit)
    ON (v.time)
;

// Create meta-visit relationship
MATCH (p:Person)--(v:Visit)--(l:Location)
CREATE (p)-[:VISITS {time: v.time}]->(l)
;

