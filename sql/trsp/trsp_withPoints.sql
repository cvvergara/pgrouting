/*PGR-GNU*****************************************************************
File: trsp_withPoints.sql

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Celia Virginia Vergara Castillo
Mail: vicky at erosion.dev

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


--v4.0
CREATE FUNCTION pgr_trsp_withPoints(
  TEXT,   -- edges
  TEXT,   -- Restrictions SQL
  TEXT,   -- points
  BIGINT, -- start
  BIGINT, -- end
  CHAR,   -- driving side

  directed BOOLEAN DEFAULT true,
  details BOOLEAN DEFAULT false,

  OUT seq INTEGER,
  OUT path_seq INTEGER,
  OUT start_vid BIGINT,
  OUT end_vid BIGINT,
  OUT node BIGINT,
  OUT edge BIGINT,
  OUT cost FLOAT,
  OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
  SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
  FROM _pgr_trsp_withPoints_v4(
    _pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
    ARRAY[$4]::BIGINT[], ARRAY[$5]::BIGINT[],
    directed, $6, details);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST 100
ROWS 1000;


--v4.0
CREATE FUNCTION pgr_trsp_withPoints(
  TEXT,     -- edges
  TEXT,     -- Restrictions SQL
  TEXT,     -- points
  BIGINT,   -- start
  ANYARRAY, -- ends
  CHAR,     -- driving side

  directed BOOLEAN DEFAULT true,
  details BOOLEAN DEFAULT false,

  OUT seq INTEGER,
  OUT path_seq INTEGER,
  OUT start_vid BIGINT,
  OUT end_vid BIGINT,
  OUT node BIGINT,
  OUT edge BIGINT,
  OUT cost FLOAT,
  OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
  SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
  FROM _pgr_trsp_withPoints_v4(
    _pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
    ARRAY[$4]::BIGINT[], $5::BIGINT[],
    directed, $6, details);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST 100
ROWS 1000;


--v4.0
CREATE FUNCTION pgr_trsp_withPoints(
  TEXT,     -- edges
  TEXT,     -- Restrictions SQL
  TEXT,     -- points
  ANYARRAY, -- start
  BIGINT,   -- ends
  CHAR,     -- driving side

  directed BOOLEAN DEFAULT true,
  details BOOLEAN DEFAULT false,

  OUT seq INTEGER,
  OUT path_seq INTEGER,
  OUT start_vid BIGINT,
  OUT end_vid BIGINT,
  OUT node BIGINT,
  OUT edge BIGINT,
  OUT cost FLOAT,
  OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
  SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
  FROM _pgr_trsp_withPoints_v4(
    _pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
    $4::BIGINT[], ARRAY[$5]::BIGINT[],
    directed, $6, details);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST 100
ROWS 1000;


--v4.0
CREATE FUNCTION pgr_trsp_withPoints(
  TEXT,     -- edges
  TEXT,     -- Restrictions SQL
  TEXT,     -- points
  ANYARRAY, -- start
  ANYARRAY, -- ends
  CHAR,     -- driving side

  directed BOOLEAN DEFAULT true,
  details BOOLEAN DEFAULT false,

  OUT seq INTEGER,
  OUT path_seq INTEGER,
  OUT start_vid BIGINT,
  OUT end_vid BIGINT,
  OUT node BIGINT,
  OUT edge BIGINT,
  OUT cost FLOAT,
  OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
  SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
  FROM _pgr_trsp_withPoints_v4(
    _pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
    $4::BIGINT[], $5::BIGINT[],
    directed, $6, details);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST 100
ROWS 1000;


--v4.0
CREATE FUNCTION pgr_trsp_withPoints(
  TEXT,     -- edges
  TEXT,     -- Restrictions
  TEXT,     -- points
  TEXT,     -- combinations
  CHAR,     -- driving side

  directed BOOLEAN DEFAULT true,
  details BOOLEAN DEFAULT false,

  OUT seq INTEGER,
  OUT path_seq INTEGER,
  OUT start_vid BIGINT,
  OUT end_vid BIGINT,
  OUT node BIGINT,
  OUT edge BIGINT,
  OUT cost FLOAT,
  OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
  SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
  FROM _pgr_trsp_withPoints_v4(
    _pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
    _pgr_get_statement($4),
    directed, $5, details);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST 100
ROWS 1000;


COMMENT ON FUNCTION pgr_trsp_withPoints(TEXT, TEXT, TEXT, BIGINT, BIGINT, CHAR, BOOLEAN, BOOLEAN)
IS 'pgr_trsp_withPoints (One to One)
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
  - Restrictions SQL with columns: id, cost, path
  - Points SQL with columns: [pid], edge_id, fraction [,side]
  - From vertex/point identifier
  - To vertex/point identifier
  - driving side: directed graph [r,l], undirected graph [b]
- Optional Parameters
  - directed => true
  - details => false
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_trsp_withPoints.html
';


COMMENT ON FUNCTION pgr_trsp_withPoints(TEXT, TEXT, TEXT, BIGINT, ANYARRAY, CHAR, BOOLEAN, BOOLEAN)
IS 'pgr_trsp_withPoints(One to Many)
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
  - Restrictions SQL with columns: id, cost, path
  - Points SQL with columns: [pid], edge_id, fraction [,side]
  - From vertex/point identifier
  - To ARRAY[vertices/points identifiers]
  - driving side: directed graph [r,l], undirected graph [b]
- Optional Parameters
  - directed => true
  - details => false
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_trsp_withPoints.html
';

COMMENT ON FUNCTION pgr_trsp_withPoints(TEXT, TEXT, TEXT, ANYARRAY, BIGINT, CHAR, BOOLEAN, BOOLEAN)
IS 'pgr_trsp_withPoints(Many to One)
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
  - Restrictions SQL with columns: id, cost, path
  - Points SQL with columns: [pid], edge_id, fraction [,side]
  - From ARRAY[vertices/points identifiers]
  - To vertex/point identifier
  - driving side: directed graph [r,l], undirected graph [b]
- Optional Parameters
  - directed => true
  - details => false
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_trsp_withPoints.html
';

COMMENT ON FUNCTION pgr_trsp_withPoints(TEXT, TEXT, TEXT, ANYARRAY, ANYARRAY, CHAR, BOOLEAN, BOOLEAN)
IS 'pgr_trsp_withPoints(Many to Many)
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
  - Restrictions SQL with columns: id, cost, path
  - Points SQL with columns: [pid], edge_id, fraction [,side]
  - From ARRAY[vertices/points identifiers]
  - To ARRAY[vertices/points identifiers]
  - driving side: directed graph [r,l], undirected graph [b]
- Optional Parameters
  - directed => true
  - details => false
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_trsp_withPoints.html
';

COMMENT ON FUNCTION pgr_trsp_withPoints(TEXT, TEXT, TEXT, TEXT, CHAR, BOOLEAN, BOOLEAN)
IS 'pgr_trsp_withPoints(Combinations)
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
  - Restrictions SQL with columns: id, path, cost
  - Points SQL with columns: [pid], edge_id, fraction [,side]
  - Combinations SQL with columns: source, target
  - driving side: directed graph [r,l], undirected graph [b]
- Optional Parameters
  - directed => true
  - details => false
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_trsp_withPoints.html
';
