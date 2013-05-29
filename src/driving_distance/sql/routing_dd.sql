--
-- Copyright (c) 2005 Sylvain Pasche,
--               2006-2007 Anton A. Patrushev, Orkney, Inc.
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

-----------------------------------------------------------------------
-- Core function for driving distance.
-- The sql should return edge and vertex ids.
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgr_drivingDistance(sql text, source_id integer, distance float8, directed boolean, has_reverse_cost boolean)
    RETURNS SETOF pgr_costResult
    AS '$libdir/librouting_dd', 'driving_distance'
    LANGUAGE c IMMUTABLE STRICT;
                        
-----------------------------------------------------------------------
-- Core function for alpha shape computation.
-- The sql should return vertex ids and x,y values. Return ordered
-- vertex ids. 
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgr_alphashape(sql text, OUT x float8, OUT y float8)
    RETURNS SETOF record
    AS '$libdir/librouting_dd', 'alphashape'
    LANGUAGE c IMMUTABLE STRICT;
