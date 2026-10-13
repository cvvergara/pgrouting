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

   | pgr_hawickCircuits(`Edges SQL`_)

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
