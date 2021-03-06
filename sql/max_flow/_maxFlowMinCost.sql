/*PGR-GNU*****************************************************************
File: _maxFlowMinCost.sql

Generated with Template by:
Copyright (c) 2016 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2018 Maoguang Wang
Mail: xjtumg1007@gmail.com

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

------------------------
------------------------
-- costFlow
------------------------
------------------------


------------------------
-- _pgr_maxFlowMinCost
------------------------


--v3.0
CREATE FUNCTION _pgr_maxFlowMinCost(
    edges_sql TEXT,
    sources ANYARRAY,
    targets ANYARRAY,

    only_cost BOOLEAN DEFAULT false,

    OUT seq INTEGER,
    OUT edge BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
'MODULE_PATHNAME'
LANGUAGE c IMMUTABLE STRICT;

--v3.2
CREATE FUNCTION _pgr_maxFlowMinCost(
    edges_sql TEXT,
    combinations_sql TEXT,
    only_cost BOOLEAN DEFAULT false,

    OUT seq INTEGER,
    OUT edge BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
'MODULE_PATHNAME'
LANGUAGE c IMMUTABLE STRICT;

-- COMMENTS

COMMENT ON FUNCTION _pgr_maxFlowMinCost(TEXT, ANYARRAY, ANYARRAY, BOOLEAN)
IS 'pgRouting internal function';

COMMENT ON FUNCTION _pgr_maxFlowMinCost(TEXT, TEXT, BOOLEAN)
IS 'pgRouting internal function';
