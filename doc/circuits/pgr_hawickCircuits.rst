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

  * New optional parameters: ``start_ids``, ``max_depth`` and ``self_loops``.
  * The ``min_depth`` parameter is compulsory.
  * Deprecated signature: ``pgr_hawickCircuits(text)``.

* Version 3.4.0

  * New experimental function.

Description
-------------------------------------------------------------------------------

.. include:: circuits-family.rst
   :start-after: circuits_characteristics_start
   :end-before: circuits_characteristics_end

Signatures
-------------------------------------------------------------------------------

.. admonition:: \ \
   :class: signatures

   | pgr_hawickCircuits(`Edges SQL`_, ``min_depth`` [, ``start_ids``] [, ``max_depth``] [, ``self_loops``])

   | Returns set of |circuits-result|
   | OR EMPTY SET

:Example: Circuits present in the pgRouting :doc:`sampledata`

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q1
   :end-before: -- q2

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
   * - ``min_depth``
     - ``BIGINT``
     -
     - Minimum number of vertices in a circuit. Self loops are not affected.

Optional parameters
...............................................................................

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Parameter
     - Type
     - Default
     - Description
   * - ``start_ids``
     - ``BIGINT[]``
     - ``'{}'``
     - Array of identifiers of the starting vertices of the circuits. When
       empty all the circuits are returned.
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

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
