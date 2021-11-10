
//Find at-risk individuals
MATCH (p:Person {person_id: 699})
WITH p

// Find all healthy people at risk of exposure
MATCH path = (p)-[v1:VISITS]-(l:Location)-[v2:VISITS]-(p2:Person)
WHERE v2.time = v1.time
// Allow some time prior to detection
AND v2.time >= p.detected_time - 7
AND p2.status = "Healthy"
RETURN path
;

