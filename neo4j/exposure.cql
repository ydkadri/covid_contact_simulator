
//Find where an individual was exposed
MATCH (p:Person {person_id: 411})
WITH p
MATCH (p)-[:REGISTERS]-(v1:Visit)-[:AT]-(l:Location)-[v2:VISITS]-(q:Person {status: "Sick"})
WHERE v1.time = v2.time
AND v1.time = p.detected_time - 10
AND v1.time <= p.detected_time - 5
RETURN p, q, l, v1
;

