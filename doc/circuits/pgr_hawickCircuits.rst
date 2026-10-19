:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2022-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Miscellaneous Algorithms ; pgr_hawickCircuits
   single: Hawick Circuits - Experimental on v3.4

|

``pgr_hawickCircuits`` - Experimental
===============================================================================

``pgr_hawickCircuits`` — Returns the list of circuits using hawick circuits algorithm.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.1.0

  * New optional parameters: ``min_depth``, ``max_depth``, ``self_loops`` and
    ``u_turn_on_edge``.
  * New signatures to select the starting vertices: **start vid** and
    **start vids**.
  * Deprecated signature: ``pgr_hawickCircuits(text)``.
  * The circuits are arc-distinct: each combination of parallel arcs is
    returned as a different circuit.
  * The ``depth`` column starts at ``0`` for the first node of a circuit.

* Version 3.4.0

  * New experimental function.

Description
-------------------------------------------------------------------------------

Hawick Circuit algorithm, is published in 2008 by Ken Hawick and Heath A. James.
This algorithm solves the problem of detecting and enumerating circuits in graphs.

Circuit enumeration in directed graphs, where parallel circuits are enumerated.

.. include:: pgr_hawickUniqueCircuits.rst
   :start-after: circuits_characteristics_start
   :end-before: circuits_characteristics_end

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_ [, **options**])
   | pgr_hawickCircuits(`Edges SQL`_, **start vid** [, **options**])
   | pgr_hawickCircuits(`Edges SQL`_, **start vids** [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

   | Returns set of |circuits-result|
   | OR EMPTY SET

.. index::
    single: pgr_hawickCircuits ; All circuits

All circuits
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_ [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: All the circuits of the pgRouting :doc:`sampledata`

When no starting vertex is given, all the circuits of the graph are returned.
The result has 94 rows, one ``path_id`` for each circuit:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q1
   :end-before: -- q2

.. index::
    single: pgr_hawickCircuits ; Single start vertex

Single start vertex
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_, **start vid** [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits that contain vertex :math:`10`

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q2
   :end-before: -- q3

.. index::
    single: pgr_hawickCircuits ; Many start vertices

Many start vertices
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_, **start vids** [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits that contain vertices :math:`\{10, 11\}`

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q3
   :end-before: -- q4

Parameters
-------------------------------------------------------------------------------

.. include:: circuits-family.rst
    :start-after: circuits_parameters_start
    :end-before: circuits_parameters_end

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

.. include:: pgr_hawickUniqueCircuits.rst
    :start-after: graph_start
    :end-before: graph_end

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q4
   :end-before: -- q5

:Example 1: All possible ways to return to vertex :math:`1`.

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q5
   :end-before: -- q6

:Example 2: Exclude self loops.

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q6
   :end-before: -- q7

:Example 3: Exclude self loops and U-turn on the same edge.

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q7
   :end-before: -- q8

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
