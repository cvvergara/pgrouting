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

:Example: Circuits present in the pgRouting :doc:`sampledata`

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

The edges of the pgRouting :doc:`sampledata` do not have self loops, a
temporary self loop is added. A parallel arc of the arc :math:`8` between
vertices :math:`7` and :math:`8` is also added:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q4
   :end-before: -- q5

:Example 1: Arc-distinct circuits

The parallel arcs between vertices :math:`7` and :math:`8` produce a different
circuit for each combination of arcs:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q5
   :end-before: -- q6

The ``min_depth`` and ``max_depth`` parameters limit the number of vertices of
each circuit. The last row of a circuit closes it by repeating the starting
vertex. Self loops are not affected by ``min_depth`` and ``max_depth``,
therefore ``self_loops => false`` is used so the self loop is not part of the
following examples.

:Example 2: Self loops

With the default ``self_loops => true`` the self loop circuit is included:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q6
   :end-before: -- q7

With ``self_loops => false`` the self loops are excluded:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q7
   :end-before: -- q8

:Example 3: Circuits from vertices :math:`\{10, 11\}` with a depth range

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q8
   :end-before: -- q9

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
