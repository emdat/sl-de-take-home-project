-- ============================================================================
-- NYC COLLISION DATA TRANSFORMATIONS
-- Creates analytical tables from raw collision, vehicle, and person data
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 8. Aggregated collision summary by contributing factor combinations 
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS analytics.contrib_factor_breakdown;


CREATE TABLE analytics.contrib_factor_breakdown AS
SELECT
    cf as contributing_factor,
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
from clean.collisions
INNER JOIN (
    select distinct cf from (
        select contributing_factor_vehicle_1 as cf from clean.collisions
        UNION 
        select contributing_factor_vehicle_2 as cf from clean.collisions
        UNION 
        select contributing_factor_vehicle_3 as cf from clean.collisions
        UNION 
        select contributing_factor_vehicle_4 as cf from clean.collisions
        UNION 
        select contributing_factor_vehicle_5 as cf from clean.collisions
    ) as contrib_factors
) as all_contrib_factors
    ON all_contrib_factors.cf = contributing_factor_vehicle_1 OR 
    all_contrib_factors.cf = contributing_factor_vehicle_2 OR 
    all_contrib_factors.cf = contributing_factor_vehicle_3 OR 
    all_contrib_factors.cf = contributing_factor_vehicle_4 OR 
    all_contrib_factors.cf = contributing_factor_vehicle_5
group by cf
order by cf
; 