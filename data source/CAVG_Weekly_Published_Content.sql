-- =====================================================
-- Data Source Name: CAVG_Weekly_Published_Content.sql
-- Size: ~4 MB
-- Description: Script to create cumulative average weekly published content table
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


WITH daily_table AS (
  SELECT 
    DATE(published_at, 'Asia/Jakarta') AS published_at, -- adjust it to your timezone(s)
    id 
  FROM 
    `mycompany.content` -- anonymized
  WHERE 
    region_id = 40 -- edit for the edition you work at
),

weekly_table AS (
  SELECT 
    DATE_TRUNC(published_at, WEEK(MONDAY)) AS week_start_date,  -- each week is started on Monday
    COUNT(id) AS total_articles 
  FROM 
    daily_table 
  WHERE 
    published_at BETWEEN '2024-01-01' AND '2024-12-31'
  GROUP BY 
    1
),

window_table AS (
  SELECT 
    week_start_date,
    total_articles,
    SUM(total_articles) OVER (ORDER BY week_start_date) AS moving_total, 
    AVG(total_articles) OVER (ORDER BY week_start_date) AS moving_avg
  FROM 
    weekly_table  
)

SELECT 
  week_start_date AS isoweek_start_date,
  total_articles,
  moving_total,
  moving_avg 
FROM 
  window_table;

-- =====================================================
-- Change Log:
-- 2024-05-21: Adding some comments for documentation (MA)
-- 2024-0x-xx: ...