-- =====================================================
-- Data Source Name: Republishers_Improvement.sql
-- Size: ~106 MB
-- Description: Script to create a complete table consisting of article infos and gained views
-- Author: MA
-- Created Date: 2024-05-22
-- Last Modified By: MA
-- Last Modified Date: 2024-05-22
-- Version: 1.0
-- =====================================================
-- TODO: Implement parameterization to the script
-- FIXME: ...
-- =====================================================
-- Please read the Change Log at the end of the script

WITH content_ed AS(
  SELECT
    id AS content_id,
    CASE
      WHEN REGEXP_CONTAINS(title, r'^\s*$') THEN NULL
      ELSE REGEXP_REPLACE(title, r'^\s+$', '')
      END AS judul,
    region_id,
    lead_author_id,
    editor_id
  FROM `mycompany.content`c
  JOIN UNNEST(editor_ids) AS editor_id ON TRUE
  WHERE id IS NOT NULL AND region_id = 40 
  GROUP BY 1,2,3,4,5
), content_sec AS(
  SELECT
    id AS content_id,
    CASE
      WHEN REGEXP_CONTAINS(title, r'^\s*$') THEN NULL
      ELSE REGEXP_REPLACE(title, r'^\s+$', '')
      END AS judul, 
    region_id,
    lead_author_id,
    section_id,
  FROM `mycompany.content`c
  JOIN UNNEST(page_ids) AS section_id ON TRUE
  WHERE id IS NOT NULL AND region_id = 40 AND section_id <> 3401
  GROUP BY 1,2,3,4,5
), content_ed2 AS(
  SELECT
    content_id,
    judul,
    lead_author_id,
    editor_id,
    c1.region_id,
    lead_author_id,
    e.name AS editor_name,
  FROM content_ed c1
  LEFT JOIN `mycompany.editors` e ON e.id = c1.editor_id
), content_sec2 AS(
  SELECT
    content_id,
    judul, 
    lead_author_id,
    section_id,
    c1.region_id,
    lead_author_id,
    s.title AS section_name,
  FROM content_sec c1
  LEFT JOIN `mycompany.sections` s ON s.id = c1.section_id
), agg_editor AS(
  SELECT
    content_id,
    STRING_AGG(editor_name, ', ') AS semua_editor,
FROM content_ed2
GROUP BY 1
), agg_section AS(
  SELECT
    content_id,
    STRING_AGG(section_name, ', ') AS semua_section,
FROM content_sec2
GROUP BY 1
), content_views AS(
  SELECT day, content_id, total_views AS gained_views
  FROM `mycompany.daily_views` tv
), alltime_views AS(
  SELECT source, av.content_id, av.total_views
  FROM `mycompany.total_views`av
), lead_au AS(
  SELECT
    c.id,
    lead_author_id,
    name AS lead_au_name,
  FROM `mycompany.content`c
  LEFT JOIN `mycompany.authors` a ON a.id = lead_author_id
  WHERE c.region_id = 40
), unnest_aus AS(
  SELECT
    c.id,
    author_id
  FROM `mycompany.content`c
  JOIN UNNEST(author_ids) AS author_id ON TRUE
  WHERE c.region_id = 40
), join_aus AS(
  SELECT
    au.id, name AS other_author
  FROM unnest_aus au
  LEFT JOIN `mycompany.authors` a ON a.id = au.author_id
), other_aus AS(
  SELECT id, STRING_AGG(other_author, ', ') AS authors, COUNT(other_author) AS authors_count
  FROM join_aus
  GROUP BY 1
), repub_data AS(
  SELECT DATETIME(f.timestamp, 'Asia/Jakarta') AS time_rep, content_id, republisher_id, name AS nama_repub, logo_url AS logo_repub
  FROM `mycompany.republications`f
  LEFT JOIN `mycompany.republishers` r ON f.republisher_id = r.id
  WHERE EXISTS(SELECT id FROM `mycompany.content` c WHERE c.id = f.content_id) and republisher_id <> 420
), repub_gained_view AS(
  SELECT
    day, re.content_id, republisher_id,
    SUM(re.count) AS gained_rep_views,
  FROM `mycompany.daily_republishers_views` re
  WHERE EXISTS(SELECT id FROM `mycompany.content` c WHERE c.id = re.content_id) AND republisher_id <> 420
  GROUP BY 1,2,3
), unnest_topic AS (
  SELECT topic_id, c.id
  FROM `mycompany.content`c
  JOIN UNNEST(topic_ids) AS topic_id ON TRUE
  WHERE c.region_id = 40
), topic AS (
  SELECT STRING_AGG(name, ', ') AS nama_topik, ut.id
  FROM `mycompany.topics` t
  RIGHT JOIN unnest_topic ut ON topic_id = t.id
  GROUP BY 2
), republisher_table AS(
SELECT
    nama_repub, 
    logo_repub,
    time_rep,
    republisher_id,
    ae.semua_editor,
    gs.semua_section,
    CONCAT('mycompany.com/', slug) AS article_url,
    t.nama_topik,
FROM `mycompany.content` c2
LEFT JOIN agg_editor ae ON ae.content_id = c2.id
LEFT JOIN agg_section gs ON gs.content_id = c2.id
LEFT JOIN topic t ON t.id = c2.id
LEFT JOIN repub_data rd ON rd.content_id = c2.id 
WHERE region_id = 40 and published_at >= '2022-01-01' GROUP BY 1,2,3,4,5,6,7,8)

SELECT DISTINCT
    republisher_id, nama_repub, logo_repub,     
    CASE
      WHEN MAX(time_rep) < '2024-01-01' THEN 'has not'
      ELSE 'yes it has'
    END AS has_republish,
FROM republisher_table
GROUP BY 1,2,3

-- =====================================================
-- Change Log:
-- 2024-05-22: Initial script creation (Moh Alfarizqy)
-- 2024-0x-0x: ...
