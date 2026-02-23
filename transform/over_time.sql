-- ============================================================================
-- NYC COLLISION DATA TRANSFORMATIONS
-- Creates analytical tables from collision, vehicle, and person data
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 3. Collision summary by temporal patterns - Aggregations of key metrics grouped by date, hour, and day of week
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS analytics.date_summary;
DROP TABLE IF EXISTS analytics.hourly_summary;
DROP TABLE IF EXISTS analytics.day_of_week_summary;

CREATE TABLE analytics.date_summary AS
SELECT
    crash_date,
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
GROUP BY crash_date 
ORDER BY crash_date ASC
;


CREATE TABLE analytics.hourly_summary AS
SELECT
    CAST(LEFT(crash_time, POSITION(':' IN crash_time) - 1) AS INTEGER) AS crash_hour,
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
GROUP BY crash_hour 
order by crash_hour ASC
;


CREATE TABLE analytics.day_of_week_summary AS
SELECT
    TO_CHAR(TO_DATE(crash_date, 'YYYY-MM-DDT00:00:00.000'), 'Day') AS day_of_week,
    TO_CHAR(TO_DATE(crash_date, 'YYYY-MM-DDT00:00:00.000'), 'D') AS day_of_week_num,
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
GROUP BY day_of_week, day_of_week_num
ORDER BY day_of_week_num ASC
;


