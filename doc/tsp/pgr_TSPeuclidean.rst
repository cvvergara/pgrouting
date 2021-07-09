..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|

* **Supported versions:**
  `Latest <https://docs.pgrouting.org/latest/en/pgr_TSPeuclidean.html>`__
  (`3.2 <https://docs.pgrouting.org/3.2/en/pgr_TSPeuclidean.html>`__)
  `3.1 <https://docs.pgrouting.org/3.1/en/pgr_TSPeuclidean.html>`__
  `3.0 <https://docs.pgrouting.org/3.0/en/pgr_TSPeuclidean.html>`__
* **Unsupported versions:**
  `2.5 <https://docs.pgrouting.org/2.5/en/pgr_eucledianTSP.html>`__
  `2.4 <https://docs.pgrouting.org/2.4/en/pgr_eucledianTSP.html>`__
  `2.3 <https://docs.pgrouting.org/2.3/en/src/tsp/doc/pgr_eucledianTSP>`__

pgr_TSPeuclidean
=============================================================================

``pgr_TSPeuclidean`` - Using *Simulated Annealing* approximation algorithm

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/libs/graph/doc/metric_tsp_approx.html

   Boost Graph Inside


.. rubric:: Availability:

* Version 3.2.1

  * Metric Algorithm from `Boost library <:target: https://www.boost.org/libs/graph/doc/metric_tsp_approx.html>`__
  * Simulated Annealing Algorithm no longer supported

    * The Simulated Annealing Algorithm related parameters are ignored:
      max_processing_time, tries_per_temperature,
      max_changes_per_temperature, max_consecutive_non_changes,
      initial_temperature, final_temperature, cooling_factor,
      randomize

* Version 3.0.0

  * Name change from pgr_eucledianTSP

* Version 2.3.0

  * New **Official** function


Description
-------------------------------------------------------------------------------

.. include:: TSP-family.rst
   :start-after: tsp problem definition start
   :end-before: tsp problem definition end

.. include:: TSP-family.rst
   :start-after: tsp characteristics start
   :end-before: tsp characteristics end


Characteristics
...............................................................................

- Duplicated identifiers with different coordinates are not allowed

  - The coordinates are quite the same for the same identifier, for example
   ```
     1, 3.5, 1
     1, 3.499999999999 0.9999999
   ```
  - The coordinates are quite different for the same identifier, for example
   ```
    * 2 , 3.5 1
    * 2 , 3.6 1
   ```
  - Any duplicated identifier will be ignored. The coordinate that will be kept
    is arbitrarly.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. index::
    single: TSPeuclidean

.. code-block:: none

    pgr_TSPeuclidean(Coordinates SQL,
        [start_id], [end_id],
        [max_processing_time],
        [tries_per_temperature], [max_changes_per_temperature], [max_consecutive_non_changes],
        [initial_temperature], [final_temperature], [cooling_factor],
        [randomize])
    RETURNS SETOF (seq, node, cost, agg_cost)

:Example: Not having a random execution

.. literalinclude:: doc-pgr_TSPeuclidean.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

====================  =================================================
Parameter             Description
====================  =================================================
**Coordinates SQL**   an SQL query, described in the `Inner query`_
====================  =================================================

Optional Parameters
...............................................................................

.. include:: TSP-family.rst
   :start-after: tsp control parameters begin
   :end-before: tsp control parameters end

Inner query
-------------------------------------------------------------------------------

**Coordinates SQL**: an SQL query, which should return a set of rows with the following columns:

======= =========== =================================================
Column  Type        Description
======= =========== =================================================
**id**  ``BIGINT``  (optional) Identifier of the coordinate.

                    - When missing the coordinates will receive an **id** starting from 1, in the order given.

**x**   ``FLOAT``   X value of the coordinate.
**y**   ``FLOAT``   Y value of the coordinate.
======= =========== =================================================


Result Columns
-------------------------------------------------------------------------------

.. include:: TSP-family.rst
   :start-after: tsp return values begin
   :end-before: tsp return values end

Additional Examples
-------------------------------------------------------------------------------

:Example: Try :math:`3` times per temperature with cooling factor of :math:`0.5`, not having a random execution

.. literalinclude:: doc-pgr_TSPeuclidean.queries
   :start-after: -- q2
   :end-before: -- q3

:Example: Skipping the Simulated Annealing & showing some process information

.. literalinclude:: doc-pgr_TSPeuclidean.queries
   :start-after: -- q3
   :end-before: -- q4

The queries use the :doc:`sampledata` network.

See Also
-------------------------------------------------------------------------------

* :doc:`TSP-family`
* `Wikipedia: Traveling Salesman Problem <https://en.wikipedia.org/wiki/Traveling_salesman_problem>`__
* `Wikipedia: Simulated annealing <https://en.wikipedia.org/wiki/Simulated_annealing>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
