..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|



``pgr_contractionHierarchies``
===============================================================================

``pgr_contractionHierarchies`` — Performs graph contraction according to 
the contraction hierarchies method and returns the contracted vertices and 
shortcut edges created.

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/libs/graph/doc/table_of_contents.html

   Boost Graph Inside

.. rubric:: Availability

* Version 4.0.0

  * New **experimental** function


Description
-------------------------------------------------------------------------------

In large graphs, like the road graphs or electric networks, graph contraction
can be used to speed up some graph algorithms. Contraction hierarchies can reduce
the size of explored graph by adding shortcut edges and by introducing an order
between nodes, which gives a notion of priority to the shortest path algorithm
used to find point to point paths. In this way, it decreases the total time and
explored space of shortest path algorithms.

This implementation allows the user to forbid contraction of a set of nodes.
The process is done on edges with positive costs. 

As for ``pgr_contraction`` method, it does not return the full
contracted graph, only the changes: added shortcut edges and contracted nodes.
Furthermore, the returned values are ordered as follows:

  - column ``id`` ascending when type is ``v`` (vertex);
  - column ``id`` descending when type is ``e`` (edge).


Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

The ``pgr_contractionHierarchies`` function has the following signature:

.. index::
   single: contraction

.. admonition:: \ \
   :class: signatures

   | pgr_contractionHierarchies(`Edges SQL`_, [**options**])

   | **options:** ``[ forbidden_vertices, directed]``
   | Returns set of |result-contraction-hierarchies|

:Example: Building contraction hierarchies on an undirected graph.

.. literalinclude:: contractionHierarchies.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Parameter
     - Type
     - Description
   * - `Edges SQL`_
     - ``TEXT``
     - `Edges SQL`_ as described below.

Optional parameters
...............................................................................

.. include:: dijkstra-family.rst
    :start-after: dijkstra_optionals_start
    :end-before: dijkstra_optionals_end

Contraction hierarchies optional parameters
...............................................................................

.. list-table::
   :width: 81
   :widths: 19 22 7 40
   :header-rows: 1

   * - Column
     - Type
     - Default
     - Description
   * - ``forbidden_vertices``
     - ``ARRAY[`` **ANY-INTEGER** ``]``
     - **Empty**
     - Identifiers of vertices forbidden for contraction.
   * - ``directed``
     - ``BOOLEAN``
     - :math:`1`
     - True if the graph is directed, False otherwise.

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
    :start-after: basic_edges_sql_start
    :end-before: basic_edges_sql_end

Result columns
-------------------------------------------------------------------------------

Returns set of |result-contraction-hierarchies|

The function returns many rows (one per vertex and one per shortcut edge created).
The columns of the rows are:

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``type``
     - ``TEXT``
     - Type of the ``id``.

       * ``v`` when the row is a vertex.

         * Column ``id`` has a positive value
       * ``e`` when the row is an edge.

         * Column ``id`` has a negative value
   * - ``id``
     - ``BIGINT``
     - All numbers on this column are ``DISTINCT``

       * When ``type`` = **'v'**.

         * Identifier of the modified vertex.

       * When ``type`` = **'e'**.

         * Decreasing sequence starting from **-1**.
         * Representing a pseudo `id` as is not incorporated in the set of
           original edges.
   * - ``contracted_vertices``
     - ``ARRAY[BIGINT]``
     - Array of contracted vertex identifiers.
   * - ``source``
     - ``BIGINT``
     - * When ``type`` = **'v'**: :math:`-1`
       * When ``type`` = **'e'**: Identifier of the source vertex of the current
         edge (``source``, ``target``).
   * - ``target``
     - ``BIGINT``
     - * When ``type`` = **'v'**: :math:`-1`
       * When ``type`` = **'e'**: Identifier of the target vertex of the current
         edge (``source``, ``target``).
   * - ``cost``
     - ``FLOAT``
     - * When ``type`` = **'v'**: :math:`-1`
       * When ``type`` = **'e'**: Weight of the current edge (``source``,
         ``target``).
   * - ``metric``
     - ``BIGINT``
     - * When ``type`` = **'v'**: :math:`-1`
       * When ``type`` = **'e'**: Weight of the current edge (``source``,
         ``target``).
   * - ``vertex_order``
     - ``BIGINT``
     - * When ``type`` = **'v'**: :math:`-1`
       * When ``type`` = **'e'**: Weight of the current edge (``source``,
         ``target``).

Additional Examples
-------------------------------------------------------------------------------

:Example: with a set of forbidden vertices

.. literalinclude:: contractionHierarchies.queries
   :start-after: -- q2
   :end-before: -- q3

See Also
-------------------------------------------------------------------------------

* :doc:`contraction-family`

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`

