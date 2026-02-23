-- ============================================================================
-- NYC COLLISION DATA TRANSFORMATIONS
-- Creates analytical tables from raw collision, vehicle, and person data
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 4. Collision summary by basic demographic info 
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS analytics.sex_summary;
DROP TABLE IF EXISTS analytics.person_type_summary;
DROP TABLE IF EXISTS analytics.person_age_summary;
 
CREATE TABLE analytics.sex_summary AS
SELECT
    person_sex,
    COUNT(distinct clean.collisions.collision_id) AS total_collisions,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) AS injury_incidents,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) AS fatal_incidents,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(distinct clean.collisions.collision_id) AS injury_rate,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(distinct clean.collisions.collision_id) AS fatality_rate,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_persons_injured AS INTEGER) ELSE 0 END) AS total_persons_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_persons_killed AS INTEGER) ELSE 0 END) AS total_persons_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_pedestrians_injured AS INTEGER) ELSE 0 END) AS pedestrians_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_pedestrians_killed AS INTEGER) ELSE 0 END) AS pedestrians_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_cyclist_injured AS INTEGER) ELSE 0 END) AS cyclists_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_cyclist_killed AS INTEGER) ELSE 0 END) AS cyclists_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_motorist_injured AS INTEGER) ELSE 0 END) AS motorists_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_motorist_killed AS INTEGER) ELSE 0 END) AS motorists_killed
FROM clean.collisions
INNER JOIN (
    select 
        clean.collision_persons.collision_id, 
        clean.collision_persons.person_sex,
        ROW_NUMBER() OVER (
            PARTITION BY clean.collision_persons.collision_id, clean.collision_persons.person_sex 
            ORDER BY clean.collision_persons.collision_id
        ) AS seqnum
    FROM clean.collision_persons
) AS seq_persons
    ON clean.collisions.collision_id = seq_persons.collision_id
GROUP BY person_sex
ORDER BY person_sex
;


CREATE TABLE analytics.person_type_summary AS
SELECT
    person_type,
    COUNT(distinct clean.collisions.collision_id) AS total_collisions,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) AS injury_incidents,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) AS fatal_incidents,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(distinct clean.collisions.collision_id) AS injury_rate,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(distinct clean.collisions.collision_id) AS fatality_rate,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_persons_injured AS INTEGER) ELSE 0 END) AS total_persons_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_persons_killed AS INTEGER) ELSE 0 END) AS total_persons_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_pedestrians_injured AS INTEGER) ELSE 0 END) AS pedestrians_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_pedestrians_killed AS INTEGER) ELSE 0 END) AS pedestrians_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_cyclist_injured AS INTEGER) ELSE 0 END) AS cyclists_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_cyclist_killed AS INTEGER) ELSE 0 END) AS cyclists_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_motorist_injured AS INTEGER) ELSE 0 END) AS motorists_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_motorist_killed AS INTEGER) ELSE 0 END) AS motorists_killed
FROM clean.collisions
INNER JOIN (
    select 
        clean.collision_persons.collision_id, 
        clean.collision_persons.person_type,
        ROW_NUMBER() OVER (
            PARTITION BY clean.collision_persons.collision_id, clean.collision_persons.person_type 
            ORDER BY clean.collision_persons.collision_id
        ) AS seqnum
    FROM clean.collision_persons
) AS seq_persons
    ON clean.collisions.collision_id = seq_persons.collision_id
GROUP BY person_type
ORDER BY total_collisions DESC
;


CREATE TABLE analytics.person_age_summary AS
SELECT
    person_age,
    COUNT(distinct clean.collisions.collision_id) AS total_collisions,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) AS injury_incidents,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) AS fatal_incidents,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(distinct clean.collisions.collision_id) AS injury_rate,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 AND seqnum = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(distinct clean.collisions.collision_id) AS fatality_rate,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_persons_injured AS INTEGER) ELSE 0 END) AS total_persons_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_persons_killed AS INTEGER) ELSE 0 END) AS total_persons_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_pedestrians_injured AS INTEGER) ELSE 0 END) AS pedestrians_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_pedestrians_killed AS INTEGER) ELSE 0 END) AS pedestrians_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_cyclist_injured AS INTEGER) ELSE 0 END) AS cyclists_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_cyclist_killed AS INTEGER) ELSE 0 END) AS cyclists_killed,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_motorist_injured AS INTEGER) ELSE 0 END) AS motorists_injured,
    SUM(CASE WHEN seqnum = 1 THEN CAST(number_of_motorist_killed AS INTEGER) ELSE 0 END) AS motorists_killed
FROM clean.collisions
INNER JOIN (
    select 
        clean.collision_persons.collision_id, 
        clean.collision_persons.person_age,
        ROW_NUMBER() OVER (
            PARTITION BY clean.collision_persons.collision_id, clean.collision_persons.person_age 
            ORDER BY clean.collision_persons.collision_id
        ) AS seqnum
    FROM clean.collision_persons
) AS seq_persons
    ON clean.collisions.collision_id = seq_persons.collision_id
GROUP BY person_age
ORDER BY person_age ASC 
;