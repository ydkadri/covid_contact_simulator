
// Find candidates for spreading infections
MATCH (p:Person {status: "Sick"})-[vp:VISITS]-
    (l:Location)-[vq:VISITS]-
    (q:Person {status: "Sick"})
WHERE vp.time = vq.time
AND p.detected_time < q.detected_time
AND p.detected_time >= q.detected_time - 10
RETURN
    p.person_id AS spreader,
    q.person_id AS infected,
    p.detected_time AS spreader_detection,
    q.detected_time AS infected_detection,
    l.location_id AS location_of_interest
;

