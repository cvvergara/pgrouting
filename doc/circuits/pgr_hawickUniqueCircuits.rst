:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2022-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Miscellaneous Algorithms ; pgr_hawickUniqueCircuits
   single: Hawick Unique Circuits - Experimental on v4.1

|

``pgr_hawickUniqueCircuits`` - Experimental
===============================================================================

``pgr_hawickUniqueCircuits`` — Returns the list of unique circuits using hawick
circuits algorithm.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.1.0

  * New experimental function.

Description
-------------------------------------------------------------------------------

.. include:: circuits-family.rst
   :start-after: circuits_characteristics_start
   :end-before: circuits_characteristics_end

When two vertices are connected by parallel arcs, each elementary circuit is
reported once: the parallel arcs do not produce extra circuits. Each hop of a
circuit uses a single edge.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_hawickUniqueCircuits(`Edges SQL`_ [, **options**])
   | pgr_hawickUniqueCircuits(`Edges SQL`_, **start vid** [, **options**])
   | pgr_hawickUniqueCircuits(`Edges SQL`_, **start vids** [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

   | Returns set of |circuits-result|
   | OR EMPTY SET

.. index::
    single: pgr_hawickUniqueCircuits ; All circuits

All circuits
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickUniqueCircuits(`Edges SQL`_ [, ``min_depth``] [, ``max_depth``] [, ``self_loops``] [, ``u_turn_on_edge``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits present in the pgRouting :doc:`sampledata`

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q1
   :end-before: -- q2

.. index::
    single: pgr_hawickUniqueCircuits ; Single start vertex

Single start vertex
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickUniqueCircuits(`Edges SQL`_, **start vid** [, ``min_depth``] [, ``max_depth``] [, ``self_loops``] [, ``u_turn_on_edge``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits starting at vertex :math:`10`

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q2
   :end-before: -- q3

.. index::
    single: pgr_hawickUniqueCircuits ; Many start vertices

Many start vertices
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickUniqueCircuits(`Edges SQL`_, **start vids** [, ``min_depth``] [, ``max_depth``] [, ``self_loops``] [, ``u_turn_on_edge``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits starting at vertices :math:`\{10, 11\}`

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q3
   :end-before: -- q4

Parameters
-------------------------------------------------------------------------------

.. include:: circuits-family.rst
    :start-after: circuits_parameters_start
    :end-before: circuits_parameters_end

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Parameter
     - Type
     - Default
     - Description
   * - ``start vid``
     - ``BIGINT``
     - ``0``
     - Identifier of the starting vertex of the circuits. When ``0`` (the
       default value) all the circuits are returned.
   * - ``start vids``
     - ``BIGINT[]``
     - ``'{}'``
     - Array of identifiers of the starting vertices of the circuits. When
       empty all the circuits are returned.

Optional parameters
...............................................................................

.. include:: circuits-family.rst
    :start-after: circuits_optionals_start
    :end-before: circuits_optionals_end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
    :start-after: basic_edges_sql_start
    :end-before: basic_edges_sql_end

Result columns
-------------------------------------------------------------------------------

.. include:: circuits-family.rst
    :start-after: circuits_result_columns_start
    :end-before: circuits_result_columns_end

Additional Examples
-------------------------------------------------------------------------------

The edges of the pgRouting :doc:`sampledata` do not have self loops, a
temporary self loop is added:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q4
   :end-before: -- q5

.. index::
    single: pgr_hawickUniqueCircuits ; All circuits

:Example 1: All circuits

``c_example`` has two arcs from vertex :math:`7` to vertex :math:`8`: the arc
with ``id`` :math:`10` (cost :math:`1`) and the arc with ``id`` :math:`104`
(cost :math:`1.5`). Because ``pgr_hawickUniqueCircuits`` is not arc-distinct,
the circuit between :math:`7` and :math:`8` is returned once, using both arcs:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q5
   :end-before: -- q6

.. index::
    single: pgr_hawickUniqueCircuits ; Self loops

:Example 2: Self loops

``c_example`` has the self loop with ``id`` :math:`100` on vertex :math:`7`.
With the default ``self_loops => true`` it is part of the result (``path_id``
2):

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q6
   :end-before: -- q7

With ``self_loops => false`` the self loop is excluded:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q7
   :end-before: -- q8

.. index::
    single: pgr_hawickUniqueCircuits ; Depth range

:Example 3: ``min_depth`` and ``max_depth``

The ``min_depth`` and ``max_depth`` parameters limit the number of vertices of
a circuit. The ``depth`` column starts at ``0`` for the first node of a
circuit. Self loops are not affected by them.

Only circuits with 1 vertex, that is, only the self loop:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q8
   :end-before: -- q9

Circuits with 1 to 2 vertices:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q9
   :end-before: -- q10

Circuits with 1 to 3 vertices, that is, all the circuits of ``c_example``:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q10
   :end-before: -- q11

Only circuits with 3 vertices (plus the self loop):

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q11
   :end-before: -- q12

.. index::
    single: pgr_hawickUniqueCircuits ; Single start vertex

:Example 4: Start vertex :math:`7`

The circuits that start and end at vertex :math:`7`, with the default
``min_depth => 1``:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q12
   :end-before: -- q13

The circuits of vertex :math:`7` without the self loop:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q13
   :end-before: -- q14

.. index::
    single: pgr_hawickUniqueCircuits ; Many start vertices

:Example 5: Start vertices :math:`\{10, 11\}` with a depth range

The circuits that start and end at vertices :math:`10` or :math:`11` with 3 to
6 vertices. The only circuit that touches vertex :math:`11` has 2 vertices, so
the result is empty:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q14
   :end-before: -- q15

.. index::
    single: pgr_hawickUniqueCircuits ; U-turn on edge

:Example 6: ``u_turn_on_edge``

With the default ``u_turn_on_edge => true`` a circuit can use an edge to go from
a vertex and immediately return on the same edge (a u-turn).

With ``u_turn_on_edge => false`` a circuit that uses the same edge on two
consecutive hops is excluded. The two-cycles that use a single edge (edges
:math:`4`, :math:`7` and :math:`8`) are removed. The self loop (edge
:math:`100`), the circuit of 3 vertices (edges :math:`101`, :math:`102` and
:math:`103`) and the two-vertex circuit that uses two different edges between
vertices :math:`7` and :math:`8` (edges :math:`104` and :math:`10`) are kept:

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q15
   :end-before: -- q16

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
