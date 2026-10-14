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

  * New optional parameters: ``min_depth``, ``max_depth`` and ``self_loops``.
  * New signatures to select the starting vertices: **start vid** and
    **start vids**.
  * Deprecated signature: ``pgr_hawickCircuits(text)``.
  * The circuits are arc-distinct: each combination of parallel arcs is
    returned as a different circuit.

* Version 3.4.0

  * New experimental function.

Description
-------------------------------------------------------------------------------

.. include:: circuits-family.rst
   :start-after: circuits_characteristics_start
   :end-before: circuits_characteristics_end

The circuits are arc-distinct: when there are parallel arcs between two
vertices, each combination of arcs is returned as a different circuit.
:doc:`pgr_hawickUniqueCircuits` can be used to filter those duplicates out.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_ [, ``min_depth``] [, ``max_depth``] [, ``self_loops``])
   | pgr_hawickCircuits(`Edges SQL`_, **start vid** [, ``min_depth``] [, ``max_depth``] [, ``self_loops``])
   | pgr_hawickCircuits(`Edges SQL`_, **start vids** [, ``min_depth``] [, ``max_depth``] [, ``self_loops``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

.. index::
    single: pgr_hawickCircuits ; All circuits

All circuits
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_ [, ``min_depth``] [, ``max_depth``] [, ``self_loops``])

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

   | pgr_hawickCircuits(`Edges SQL`_, **start vid** [, ``min_depth``] [, ``max_depth``] [, ``self_loops``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits starting at vertex :math:`10`

Passing a single **start vid** restricts the result to the circuits that start
and end at vertex :math:`10`. The result has 12 rows (2 circuits):

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q2
   :end-before: -- q3

.. index::
    single: pgr_hawickCircuits ; Many start vertices

Many start vertices
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_, **start vids** [, ``min_depth``] [, ``max_depth``] [, ``self_loops``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits starting at vertices :math:`\{10, 11\}`

Passing an array of **start vids** returns the circuits that start and end at
any of the given vertices. The result has 17 rows: the 2 circuits of vertex
:math:`10` and the circuit of vertex :math:`11`:

.. literalinclude:: hawickCircuits.queries
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
     -
     - Identifier of the starting vertex of the circuits. When ``0`` all the
       circuits are returned.
   * - ``start vids``
     - ``BIGINT[]``
     -
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

The examples use a temporary table named ``c_example`` built from the pgRouting
:doc:`sampledata`. It keeps the edges with ``id`` :math:`4, 7, 8, 10, 11` and
:math:`12`, adds a self loop on vertex :math:`7` (``id`` :math:`100`), a
circuit through vertices :math:`20` and :math:`21`, and a parallel arc of the
arc :math:`10` between vertices :math:`7` and :math:`8` (``id`` :math:`104`):

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q4
   :end-before: -- q5

.. index::
    single: pgr_hawickCircuits ; Arc-distinct circuits

:Example 1: Arc-distinct circuits

There are two arcs from vertex :math:`7` to vertex :math:`8`: the arc with
``id`` :math:`10` (cost :math:`1`) and the arc with ``id`` :math:`104` (cost
:math:`1.5`). Because ``pgr_hawickCircuits`` is arc-distinct, the circuit
between :math:`7` and :math:`8` is returned once for each combination of those
arcs (``path_id`` 4 to 7 of the result):

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q5
   :end-before: -- q6

.. index::
    single: pgr_hawickCircuits ; Deprecated signature

:Example 2: Deprecated signature

Calling ``pgr_hawickCircuits`` with only the `Edges SQL`_ uses the deprecated
signature. It is equivalent to ``min_depth => 0``, so the same 29 rows of
Example 1 are returned:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q6
   :end-before: -- q7

.. index::
    single: pgr_hawickCircuits ; Self loops

:Example 3: Self loops

``c_example`` has the self loop with ``id`` :math:`100` on vertex :math:`7`.
With the default ``self_loops => true`` it is part of the result; in Examples 1
and 2 it is reported as ``path_id`` 8 and 9 (once for each direction of the
self loop).

With ``self_loops => false`` the self loops are removed, leaving only the
circuit of 3 vertices through vertices :math:`20` and :math:`21`:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q7
   :end-before: -- q8

.. index::
    single: pgr_hawickCircuits ; Depth range

:Example 4: ``min_depth`` and ``max_depth``

The ``min_depth`` and ``max_depth`` parameters limit the number of vertices of
a circuit. Self loops are not affected by them.

Only circuits with 1 vertex, that is, only the self loops:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q8
   :end-before: -- q9

Circuits with 1 to 2 vertices:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q9
   :end-before: -- q10

Circuits with 1 to 3 vertices, that is, all the circuits of ``c_example``:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q10
   :end-before: -- q11

Only circuits with 3 vertices (plus the self loops):

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q11
   :end-before: -- q12

.. index::
    single: pgr_hawickCircuits ; Single start vertex

:Example 5: Start vertex :math:`7`

The circuits that start and end at vertex :math:`7`, with the default
``min_depth => 3``:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q12
   :end-before: -- q13

The circuits of vertex :math:`7` without the self loops:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q13
   :end-before: -- q14

.. index::
    single: pgr_hawickCircuits ; Many start vertices

:Example 6: Start vertices :math:`\{6, 7\}` with a depth range

The circuits that start and end at vertices :math:`6` or :math:`7` with 3 to 6
vertices. Vertex :math:`6` only has circuits of 2 vertices, so only the self
loops and the circuit of vertex :math:`7` are returned:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q14
   :end-before: -- q15

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
