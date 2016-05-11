.. 
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _pgr_analyze_graph:

pgr_analyzeGraph
===============================================================================

.. index:: 
	single: pgr_analyzeGraph(text,double precision,text,text,text,text,text)
	module: common

Name
-------------------------------------------------------------------------------

``pgr_anlizeGraph`` — Analyzes the network topology.


Synopsis
-------------------------------------------------------------------------------

The function returns:

  - ``OK`` after the analysis has finished.
  - ``FAIL`` when the analysis was not completed due to an error. 

.. code-block:: sql

	varchar pgr_analyzeGraph(text edge_table, double precision tolerance, 
                           text the_geom:='the_geom', text id:='id',
                           text source:='source',text target:='target',text rows_where:='true')

Description
-------------------------------------------------------------------------------

.. rubric:: Prerequisites

The  edge table to be analyzed must contain a source column and a target column filled with id's of the vertices of the segments and the corresponding vertices table <edge_table>_vertices_pgr that stores the vertices information.

  - Use :ref:`pgr_createVerticesTable <pgr_create_vert_table>` to create the vertices table.
  - Use :ref:`pgr_createTopology <pgr_create_topology>` to create the topology and the vertices table. 

.. rubric:: Parameters

The analyze graph function accepts the following parameters:

:edge_table: ``text`` Network table name. (may contain the schema name as well)
:tolerance: ``float8`` Snapping tolerance of disconnected edges. (in projection unit)
:the_geom: ``text``  Geometry column name of the network table. Default value is ``the_geom``.  
:id: ``text``  Primary key column name of the network table. Default value is ``id``. 
:source: ``text`` Source column name of the network table. Default value is ``source``.
:target: ``text``  Target column name of the network table.  Default value is ``target``. 
:rows_where: ``text``   Condition to select  a subset or rows.  Default value is ``true`` to indicate all rows.

The function returns:

  - ``OK`` after the analysis has finished.

    * Uses the vertices table: <edge_table>_vertices_pgr.
    * Fills completly the ``cnt`` and ``chk`` columns of the vertices table.
    * Returns the analysis of the section of the network defined by  ``rows_where``

  - ``FAIL`` when the analysis was not completed due to an error. 

    * The vertices table is not found.
    * A required column of the Network table is not found or is not of the appropriate type.
    * The condition is not well formed.
    * The names of source , target or id are the same.
    * The SRID of the geometry could not be determined.


.. rubric:: The Vertices Table

The vertices table can be created with :ref:`pgr_createVerticesTable <pgr_create_vert_table>` or :ref:`pgr_createTopology <pgr_create_topology>`

The structure of the vertices table is:

:id: ``bigint`` Identifier of the vertex.
:cnt: ``integer`` Number of vertices in the edge_table that reference this vertex. 
:chk: ``integer``  Indicator that the vertex might have a problem. 
:ein: ``integer`` Number of vertices in the edge_table that reference this vertex as incoming. See :ref:`pgr_analyzeOneway <pgr_analyze_oneway>`.
:eout: ``integer`` Number of vertices in the edge_table that reference this vertex as outgoing. See :ref:`pgr_analyzeOneway <pgr_analyze_oneway>`. 
:the_geom: ``geometry`` Point geometry of the vertex.

.. rubric:: History

* New in version 2.0.0

Usage when the edge table's columns MATCH the default values:
-------------------------------------------------------------------------------
 
.. rubric:: The simplest way to use pgr_analyzeGraph is: 

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q01
   :end-before: -- q02

.. rubric:: When the arguments are given in the order described in the parameters:

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q02
   :end-before: -- q03

We get the same result as the simplest way to use the function.

.. warning::  | An error would occur when the arguments are not given in the appropriate order: In this example, the column ``id`` of the table ``mytable`` is passed to the function as the geometry column, and the geometry column ``the_geom`` is passed to the function as the id column. 
 | ``SELECT  pgr_analyzeGraph('edge_table',0.001,'id','the_geom','source','target');``
 | ERROR: Can not determine the srid of the geometry "id" in table public.edge_table

.. rubric:: When using the named notation

The order of the parameters do not matter:

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q03
   :end-before: -- q04

.. code-block:: sql
	
.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q04
   :end-before: -- q05

Parameters defined with a default value can be ommited, as long as the value matches the default:

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q05
   :end-before: -- q06

.. rubric:: Selecting rows using rows_where parameter

Selecting rows based on the id. Displays the analysis a the section of the network.

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q06
   :end-before: -- q07

Selecting the rows where the geometry is near the geometry of row with ``id`` =5 .

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q07
   :end-before: -- q08

Selecting the rows where the geometry is near the geometry of the row with ``gid`` =100 of the table ``othertable``.

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q08
   :end-before: -- q09



Usage when the edge table's columns DO NOT MATCH the default values:
-------------------------------------------------------------------------------
 
For the following table

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q09
   :end-before: -- q10

.. rubric:: Using positional notation: 

The arguments need to be given in the order described in the parameters:

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q10
   :end-before: -- q11

.. warning::  | An error would occur when the arguments are not given in the appropriate order: In this example, the column ``gid`` of the table ``mytable`` is passed to the function as the geometry column, and the geometry column ``mygeom`` is passed to the function as the id column.
 | ``SELECT  pgr_analyzeGraph('mytable',0.001,'gid','mygeom','src','tgt');``
 | ERROR: Can not determine the srid of the geometry "gid" in table public.mytable


.. rubric:: When using the named notation

The order of the parameters do not matter:

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q11
   :end-before: -- q12

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q12
   :end-before: -- q13

In this scenario omitting a parameter would create an error because the default values for the column names do not match the column names of the table.


.. rubric:: Selecting rows using rows_where parameter

Selecting rows based on the id.

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q13
   :end-before: -- q14

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q14
   :end-before: -- q15

Selecting the rows WHERE the geometry is near the geometry of row with ``id`` =5 .

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q15
   :end-before: -- q16

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q16
   :end-before: -- q17

Selecting the rows WHERE the geometry is near the place='myhouse' of the table ``othertable``. (note the use of quote_literal)

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q17
   :end-before: -- q18

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q18
   :end-before: -- q19



Examples
-------------------------------------------------------------------------------

.. code-block:: sql

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q19
   :end-before: -- q20

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q20
   :end-before: -- q21

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q21
   :end-before: -- q22
	

-- Simulate removal of edges
.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q22
   :end-before: -- q23

 .. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q23
   :end-before: -- q24

.. literalinclude::      doc-pgr_analyzeGraph.queries
   :start-after: -- q24
   :end-before: -- q25                   

The examples use the :ref:`sampledata` network.


See Also
-------------------------------------------------------------------------------

* :ref:`topology`  for an overview of a topology for routing algorithms.
* :ref:`pgr_analyze_oneway` to analyze directionality of the edges.
* :ref:`pgr_createVerticesTable <pgr_create_vert_table>` to reconstruct the vertices table based on the source and target information.
* :ref:`pgr_nodeNetwork <pgr_node_network>` to create nodes to a not noded edge table.

