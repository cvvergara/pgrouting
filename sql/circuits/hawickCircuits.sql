/*PGR-GNU*****************************************************************
File: hawickCircuits.sql

Generated with Template by:
Copyright (c) 2007-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Nitish Chauhan
Mail: nitishchauhan0022 at gmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/
---------------
-- pgr_hawickCircuits
---------------

--v4.1.0
CREATE FUNCTION pgr_hawickCircuits(
    TEXT,    -- edges_sql (required)

    -- TODO v5 min_depth has default 1
    min_depth INTEGER,
    start_ids BIGINT[] DEFAULT '{}',
    max_depth BIGINT DEFAULT 9223372036854775807,
    self_loops BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT path_id INTEGER,
    OUT depth INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)

RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT a.seq, a.path_id, a.depth, a.start_vid, a.end_vid, a.node, a.edge, a.cost, a.agg_cost
    FROM _pgr_hawickCircuits_v4(_pgr_get_statement($1), start_ids, min_depth, max_depth,self_loops) AS a;
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;

COMMENT ON FUNCTION pgr_hawickCircuits(TEXT,INTEGER,BIGINT[],BIGINT,BOOLEAN)
IS 'pgr_hawickCircuits
- EXPERIMENTAL
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
- Optional Parameters:
  - min_depth := 1
  - max_depth := 9223372036854775807
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_hawickCircuits.html
';
