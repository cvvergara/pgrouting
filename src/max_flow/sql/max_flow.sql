/*PGR-GNU*****************************************************************

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2016 Andrea Nardelli
mail: nrd.nardelli@gmail.com

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

/***********************************
        ONE TO ONE
***********************************/

--INTERNAL FUNCTIONS

CREATE OR REPLACE FUNCTION _pgr_maxflow(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertex BIGINT,
    algorithm TEXT DEFAULT 'push_relabel',
    only_flow BOOLEAN DEFAULT false,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
 '$libdir/${PGROUTING_LIBRARY_NAME}', 'max_flow_one_to_one'
    LANGUAGE c IMMUTABLE STRICT;

--FUNCTIONS

CREATE OR REPLACE FUNCTION pgr_maxFlowPushRelabel(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertex BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'push_relabel');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowBoykovKolmogorov(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertex BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'boykov_kolmogorov');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowEdmondsKarp(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertex BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'edmonds_karp');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

/***********************************
        ONE TO MANY
***********************************/

--INTERNAL FUNCTIONS

CREATE OR REPLACE FUNCTION _pgr_maxflow(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertices ANYARRAY,
    algorithm TEXT DEFAULT 'push_relabel',
    only_flow BOOLEAN DEFAULT false,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
 '$libdir/${PGROUTING_LIBRARY_NAME}', 'max_flow_one_to_many'
    LANGUAGE c IMMUTABLE STRICT;

--FUNCTIONS

CREATE OR REPLACE FUNCTION pgr_maxFlowPushRelabel(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertices ANYARRAY,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'push_relabel');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowBoykovKolmogorov(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertices ANYARRAY,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'boykov_kolmogorov');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowEdmondsKarp(
    edges_sql TEXT,
    source_vertex BIGINT,
    sink_vertices ANYARRAY,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'edmonds_karp');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

/***********************************
        MANY TO ONE
***********************************/

--INTERNAL FUNCTIONS

CREATE OR REPLACE FUNCTION _pgr_maxflow(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertex BIGINT,
    algorithm TEXT DEFAULT 'push_relabel',
    only_flow BOOLEAN DEFAULT false,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
 '$libdir/${PGROUTING_LIBRARY_NAME}', 'max_flow_many_to_one'
    LANGUAGE c IMMUTABLE STRICT;

--FUNCTIONS

CREATE OR REPLACE FUNCTION pgr_maxFlowPushRelabel(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertex BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'push_relabel');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowBoykovKolmogorov(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertex BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'boykov_kolmogorov');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowEdmondsKarp(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertex BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'edmonds_karp');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

/***********************************
        MANY TO MANY
***********************************/

--INTERNAL FUNCTIONS

CREATE OR REPLACE FUNCTION _pgr_maxflow(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertices ANYARRAY,
    algorithm TEXT DEFAULT 'push_relabel',
    only_flow BOOLEAN DEFAULT false,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
 '$libdir/${PGROUTING_LIBRARY_NAME}', 'max_flow_many_to_many'
    LANGUAGE c IMMUTABLE STRICT;

--FUNCTIONS

CREATE OR REPLACE FUNCTION pgr_maxFlowPushRelabel(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertices ANYARRAY,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'push_relabel');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowBoykovKolmogorov(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertices ANYARRAY,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'boykov_kolmogorov');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION pgr_maxFlowEdmondsKarp(
    edges_sql TEXT,
    source_vertices ANYARRAY,
    sink_vertices ANYARRAY,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT,
    OUT flow BIGINT,
    OUT residual_capacity BIGINT
    )
  RETURNS SETOF RECORD AS
  $BODY$
  BEGIN
        RETURN QUERY SELECT *
        FROM _pgr_maxflow(_pgr_get_statement($1), $2, $3, 'edmonds_karp');
  END
  $BODY$
  LANGUAGE plpgsql VOLATILE;

