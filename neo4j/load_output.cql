
MATCH (n) DETACH DELETE n;

// ":auto" required for periodic commit
:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ydkadri/covid_contact_simulator/main/output.csv' AS row

MERGE (p:Person {person_id: toInteger(row.person), status: "Healthy"})
MERGE (l:Location {location_id: toInteger(row.location)})

WITH p, l, row
CREATE (p)-[:REGISTERS]->(v:Visit {time: toInteger(row.step)})-[:AT]->(l)
SET p.status = row.status
;

// Set the infected status and detection time for sickness
MATCH (p:Person)-[:REGISTERS]-(v:Visit)
WHERE p.status = "Sick"

WITH p.person_id AS infected, MAX(v.time) AS last_time
MATCH (p:Person {person_id: infected})
SET p.detected_time = last_time
;

// Create indices for query optimisation
CREATE INDEX idx_person_personid IF NOT EXISTS
  FOR (p:Person)
  ON (p.person_id)
;

CREATE INDEX idx_person_status IF NOT EXISTS
  FOR (p:Person)
  ON (p.status)
;

CREATE INDEX idx_person_detectedtime IF NOT EXISTS
  FOR (p:Person)
  ON (p.detected_time)
;

CREATE INDEX idx_location_locationid IF NOT EXISTS
  FOR (l:Location)
  ON (l.location_id)
;
CREATE INDEX idx_visit_time IF NOT EXISTS
  FOR (v:Visit)
  ON (v.time)
;

CREATE INDEX idx_visit_time IF NOT EXISTS
  FOR (v:Visit)
  ON (v.time)
;

// Create meta-visit relationship
MATCH (p:Person)--(v:Visit)--(l:Location)
CREATE (p)-[:VISITS {time: v.time}]->(l)
;

// Give people names
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/ydkadri/covid_contact_simulator/main/names.csv' AS row
MATCH (p:Person {person_id: toInteger(row.person_id)})
SET p.name = row.name
;

