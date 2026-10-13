:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2022-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0


.. index:: Circuits Family

|

Circuits - Family of Functions
===============================================================================

The following functions work on circuits of directed graphs.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. experimental-start

* :doc:`pgr_hawickCircuits` - Hawick's circuits algorithm.
* :doc:`pgr_hawickUniqueCircuits` - Hawick's unique circuits algorithm.

.. experimental-end

.. toctree::
    :hidden:

    pgr_hawickCircuits
    pgr_hawickUniqueCircuits

Description
-------------------------------------------------------------------------------

.. circuits_characteristics_start

Hawick Circuit algorithm, is published in 2008 by Ken Hawick and Heath A. James.
This algorithm solves the problem of detecting and enumerating circuits in graphs.

It is capable of circuit enumeration in graphs with directed-arcs, multiple arcs
and self arcs with a memory efficient and high-performance implementation.

It is an extension of Johnson's Algorithm of finding all the elementary circuits
of a directed graph.

There are 2 variations defined in the Boost Graph Library.
In pgRouting, we have implemented the "hawick unique circuits" variation, where
the circuits caused by parallel edges are filtered out.

**The main characteristics are:**

- The algorithm implementation works only for directed graph
- The algorithm outputs the distinct circuits present in the graph.
- Time Complexity: :math:`O((V + E) (c + 1))`

  - where :math:`|E|` is the number of edges in the graph,
  - where :math:`|V|` is the number of vertices in the graph.
  - where :math:`|c|` is the number of circuits in the graph.

.. circuits_characteristics_end

|Boost| Boost Graph Inside

Parameters
-------------------------------------------------------------------------------

.. circuits_parameters_start

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Parameter
     - Type
     - Default
     - Description
   * - `Edges SQL`_
     - ``TEXT``
     -
     - `Edges SQL`_ as described below.

.. circuits_parameters_end

Optional parameters
...............................................................................

.. circuits_optionals_start

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Parameter
     - Type
     - Default
     - Description
   * - ``min_depth``
     - ``BIGINT``
     - ``3``
     - Minimum number of vertices in a circuit. Self loops are not affected.
   * - ``max_depth``
     - ``BIGINT``
     - ``9223372036854775807``
     - Maximum number of vertices in a circuit. Self loops are not affected.
   * - ``self_loops``
     - ``BOOLEAN``
     - ``true``
     - * When ``true`` self loops are included in the results.
       * When ``false`` self loops are excluded from the results.
       * Self loops are included or excluded regardless of ``min_depth`` and ``max_depth``.

.. circuits_optionals_end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
    :start-after: basic_edges_sql_start
    :end-before: basic_edges_sql_end

Result columns
-------------------------------------------------------------------------------

.. circuits_result_columns_start

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``seq``
     - ``INTEGER``
     - Sequential value starting from ``1``
   * - ``path_id``
     - ``INTEGER``
     - Id of the circuit starting from ``1``
   * - ``depth``
     - ``INTEGER``
     - Relative position in the circuit. Has value **1** for the beginning of a
       circuit
   * - ``start_vid``
     - ``BIGINT``
     - Identifier of the starting vertex of the circuit.
   * - ``end_vid``
     - ``BIGINT``
     - Identifier of the ending vertex of the circuit.
   * - ``node``
     - ``BIGINT``
     - Identifier of the node in the path from a vid to next vid.
   * - ``edge``
     - ``BIGINT``
     - Identifier of the edge used to go from ``node`` to the next node in
       the path sequence. ``-1`` for the last node of the path.
   * - ``cost``
     - ``FLOAT``
     - Cost to traverse from ``node`` using ``edge`` to the next node in the
       path sequence.
   * - ``agg_cost``
     - ``FLOAT``
     - Aggregate cost from ``start_vid`` to ``node``.

.. circuits_result_columns_end

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
