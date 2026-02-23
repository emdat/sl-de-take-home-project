-- ============================================================================
-- NYC COLLISION DATA TRANSFORMATIONS
-- Creates analytical tables from collision, vehicle, and person data
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 2. Collision summary by borough - Aggregations of key metrics grouped by borough 
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS analytics.borough_summary;

CREATE TABLE analytics.borough_summary AS
SELECT
    borough,
    COUNT(*) AS total_collisions,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 THEN 1 ELSE 0 END) AS injury_incidents,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 THEN 1 ELSE 0 END) AS fatal_incidents,
    SUM(CASE WHEN CAST(number_of_persons_injured AS INTEGER) > 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS injury_rate,
    SUM(CASE WHEN CAST(number_of_persons_killed AS INTEGER) > 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS fatality_rate,
    SUM(CAST(number_of_persons_injured AS INTEGER)) AS total_persons_injured,
    SUM(CAST(number_of_persons_killed AS INTEGER)) AS total_persons_killed,
    SUM(CAST(number_of_pedestrians_injured AS INTEGER)) AS pedestrians_injured,
    SUM(CAST(number_of_pedestrians_killed AS INTEGER)) AS pedestrians_killed,
    SUM(CAST(number_of_cyclist_injured AS INTEGER)) AS cyclists_injured,
    SUM(CAST(number_of_cyclist_killed AS INTEGER)) AS cyclists_killed,
    SUM(CAST(number_of_motorist_injured AS INTEGER)) AS motorists_injured,
    SUM(CAST(number_of_motorist_killed AS INTEGER)) AS motorists_killed
FROM clean.collisions
GROUP BY borough
ORDER BY borough
;

