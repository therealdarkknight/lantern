------------------------------------------------------------------------------
-- Test HNSW index correctness
------------------------------------------------------------------------------

\ir utils/small_world_array.sql

-- Create index
CREATE INDEX ON small_world USING hnsw (v dist_l2sq_ops) WITH (dims=2, M=4);
SET enable_seqscan = off;

-- Get the results without the index
CREATE TEMP TABLE results_wo_index AS
SELECT
    ROW_NUMBER() OVER (ORDER BY l2sq_dist(v, '{0,0}')) AS row_num,
    id,
    l2sq_dist(v, '{0,0}') AS dist
FROM
    small_world;

-- Get the results with the index
CREATE TEMP TABLE results_w_index AS
SELECT
    ROW_NUMBER() OVER (ORDER BY v <-> '{0,0}') AS row_num,
    id,
    l2sq_dist(v, '{0,0}') AS dist
FROM
    small_world;

-- Validate that the results are same with and without the index (should be empty)
SELECT
    a.row_num,
    a.id as id_with_index,
    b.id as id_without_index,
    a.dist as dist_with_index,
    b.dist as dist_without_index
FROM 
    results_w_index a
JOIN 
    results_wo_index b
USING (row_num)
WHERE
    a.id != b.id;