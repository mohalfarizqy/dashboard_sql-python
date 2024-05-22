-- =====================================================
-- Data Source Name: CAVG_All_Republishers_Views.sql
-- Size: ~600 MB
-- Description: Script to create a cumulative table for all republisher views
-- Author: MA
-- Created Date: 2024-05-22
-- Last Modified By: MA
-- Last Modified Date: 2024-05-22
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
    count 
  FROM 
    `mycompany.daily_republishers_views`
  WHERE 
    EXISTS (
      SELECT id 
      FROM `mycompany.content` 
      WHERE id = content_id AND region_id = 40
    )
    AND republisher_id != 420 -- exclude republisher with id 420
    AND day BETWEEN '2024-01-01' AND '2024-12-31'
  ORDER BY 
    day
), 
weekly_table AS (
  SELECT 
    truncated AS starting_week, 
    SUM(count) AS gained_views
  FROM 
    agg_table1 
  GROUP BY 
    1
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
  ROUND(rolling_avg, 1) AS rolling_avg 
FROM 
  window_table;

-- =====================================================
-- Change Log:
-- 2024-05-22: Initial script creation (MA)
-- 2024-0x-0x: ...
