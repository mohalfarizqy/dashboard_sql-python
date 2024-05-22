-- =====================================================
-- Data Source Name: Moving_Averages_Other_Republisher_Views.sql
-- Size: ~600 MB
-- Description: Script to create cumulative average views table for republishers other than 'The Conversation' (420) and 'Flipboard' (371)
-- Author: MA
-- Created Date: 2024-05-21
-- Last Modified By: MA
-- Last Modified Date: 2024-05-21
-- Version: 1.0
-- =====================================================
-- TODO: ...
-- FIXME: ...
-- =====================================================
-- Please read the Change Log at the end of the script


WITH agg_table1 AS (
  SELECT 
    day, 
    DATETIME_TRUNC(day, WEEK(MONDAY)) AS truncated, -- each week is started on Monday
    republisher_id, 
    republisher_views
  FROM 
    `mycompany.republisher_views` -- anonymized
  WHERE 
    EXISTS (
      SELECT id 
      FROM `mycompany.content` -- anonymized
      WHERE id = content_id AND region_id = 40 -- edit for the edition you work at
    )
    AND republisher_id NOT IN (420, 371) -- excluding TC and Flipboard
    AND day BETWEEN '2024-01-01' AND '2024-12-31' -- to minimize query size and cost
),
weekly_table AS (
  SELECT 
    truncated AS starting_week, 
    SUM(republisher_views) AS gained_views 
  FROM 
    agg_table1 
  GROUP BY 
    truncated
),
window_table AS ( 
  SELECT 
    starting_week, 
    gained_views, 
    SUM(gained_views) OVER (ORDER BY starting_week) AS rolling_sum, 
    AVG(gained_views) OVER (ORDER BY starting_week) AS rolling_avg 
  FROM 
    weekly_table
)
SELECT 
  starting_week, 
  gained_views, 
  rolling_sum, 
  ROUND(rolling_avg, 1) AS rolling_avg -- standardizing the decimal values
FROM 
  window_table
ORDER BY 
  starting_week;

-- =====================================================
-- Change Log:
-- 2024-05-21: Adding some comments for documentation (Moh Alfarizqy)
-- 2024-0x-xx: ...