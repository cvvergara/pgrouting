..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. index::
   single: Utilities ; pgr_findCloseEdges
   single: findCloseEdges

|

``pgr_findCloseEdges``
===============================================================================

``pgr_findCloseEdges`` - Finds the close edges to a point geometry.

.. rubric:: Availability

.. rubric:: Version 3.8.0

* Error messages adjustment.
* Function promoted to official

.. rubric:: Version 3.4.0

* New proposed function.

Description
-------------------------------------------------------------------------------

``pgr_findCloseEdges`` - An utility function that finds the closest edge to a
point geometry.

* The geometries must be in the same coordinate system (have the same SRID).
* The code to do the calculations can be obtained for further specific
  adjustments needed by the application.
* ``EMTPY SET`` is returned on dryrun executions

|Boost| Boost Graph Inside

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_findCloseEdges(`Edges SQL`_, **point**, **tolerance**, [**options**])
   | pgr_findCloseEdges(`Edges SQL`_, **points**, **tolerance**, [**options**])
   | **options:** ``[cap, dryrun]``

   | Returns set of |result-find|
   | OR EMPTY SET

.. index::
    single: findCloseEdges ; One point

One point
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_findCloseEdges(`Edges SQL`_, **point**, **tolerance**, [**options**])
   | **options:** ``[cap, dryrun]``

   | Returns set of |result-find|
   | OR EMPTY SET

:Example: Get two close edges to points of interest with :math:`pid = 5`

* ``cap => 2``

.. literalinclude:: findCloseEdges.queries
   :start-after: -- q1
   :end-before: -- q2

.. index::
   single: findCloseEdges ; Many points

Many points
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_findCloseEdges(`Edges SQL`_, **points**, **tolerance**, [**options**])
   | **options:** ``[cap, dryrun]``

   | Returns set of |result-find|
   | OR EMPTY SET

:Example: For all points of interests, find the closest edges.

.. literalinclude:: findCloseEdges.queries
   :start-after: -- q2
   :end-before: -- q3

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
   * - **point**
     - ``POINT``
     - The point geometry
   * - **points**
     - ``POINT[]``
     - An array of point geometries
   * - **tolerance**
     - ``FLOAT``
     - Max distance between geometries


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
   * - ``cap``
     - ``INTEGER``
     - :math:`1`
     - Limit output rows
   * - ``dryrun``
     - ``BOOLEAN``
     - ``false``
     - * When ``false`` calculations are performed.
       * When ``true`` calculations are not performed and the query to do the
         calculations is exposed in a PostgreSQL ``NOTICE``.

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``id``
     - **ANY-INTEGER**
     - Identifier of the edge.
   * - ``geom``
     - ``geometry``
     - The geometry of the edge.

Result columns
-------------------------------------------------------------------------------

Returns set of |result-find|

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``edge_id``
     - ``BIGINT``
     - Identifier of the edge.

       * When :math:`cap = 1`, it is the closest edge.
   * - ``fraction``
     - ``FLOAT``
     - Value in <0,1> that indicates the relative postition from the first
       end-point of the edge.
   * - ``side``
     - ``CHAR``
     - Value in ``[r, l]`` indicating if the point is:

       * In the right ``r``.

         * When the point is on the line it is considered to be on the right.
       * In the left ``l``.
   * - ``distance``
     - ``FLOAT``
     - Distance from point to edge.
   * - ``geom``
     - ``geometry``
     - Original ``POINT`` geometry.
   * - ``edge``
     - ``geometry``
     - Geometry from the original point to the closest point of the edge with
       identifier ``edge_id``


.. rubric:: One point result

* The green nodes is the **original point**
* The geometry ``geom`` is a point on the :math:`sp \rightarrow ep` edge.
* The geometry ``edge`` is a line that connects the **original point** with
  ``geom``

.. graphviz::

   digraph D {
    splines=true;
    subgraph cluster0 {
    point [pos="0,1.5!";shape=circle;style=filled;color=green;fontsize=8;width=0.3;fixedsize=true];
    np [pos="1,1.5!";shape=point;color=black;size=0;fixedsize=true];
    sp, ep [shape=circle;fontsize=8;width=0.3;fixedsize=true];
    sp[pos="2,0!"]
    ep[pos="2,3!"]

    f1 [pos="1.5,2.25!" width=0.3; height=0.5; fixedsize=true; style=invis ];
    f2 [pos="1.5,0.75!" width=0.3; height=0.5;  fixedsize=true; style=invis];
    sp:nw ->  np:s [dir=none]
    np:n -> ep:w
    }

    subgraph cluster1 {
    geom [pos="3,1.5!";shape=circle;style=filled;color=green;fontsize=8;width=0.3;fixedsize=true];
    np1 [pos="4,1.5!";shape=point;color=black;size=0];
    sp1, ep1 [shape=circle;fontsize=8;width=0.3;fixedsize=true];
    sp1[pos="5,0!";label=sp]
    ep1[pos="5,3!";label=ep]

    f11 [pos="4.55,2.25!";width=0.3; height=0.5; fixedsize=true; style=invis];
    f21 [pos="4.557,0.75!";width=0.3; height=0.5; fixedsize=true; style=invis];
    sp1:nw ->  np1:sw [dir=none];
    np1:nw -> ep1:w;
    geom -> np1 [label="edge";color=red]
    }
   }

.. rubric:: Many point results

* The green nodes are the **original points**
* The geometry ``geom``, marked as **g1** and **g2** are the **original
  points**
* The geometry ``edge``, marked as **edge1** and **edge2** is a line that
  connects the **original point** with the closest point on the :math:`sp
  \rightarrow ep` edge.

.. graphviz::

   digraph G {
     splines = false;
     subgraph cluster0 {
        p1 [shape=circle;style=filled;color=green];
        g1 [shape=point;color=black;size=0];
        g2 [shape=point;color=black;size=0];
        sp, ep;
        p2 [shape=circle;style=filled;color=green];

        sp -> g1 [dir=none;weight=1, penwidth=3 ];
        g1 -> g2 [dir=none;weight=1, penwidth=3 ];
        g2 -> ep [weight=1, penwidth=3 ];

        g2 -> p2 [dir=none;weight=0, penwidth=0, color=red, partiallen=3];
        p1 -> g1 [dir=none;weight=0, penwidth=0, color=red, partiallen=3];
        p1 -> {g1, g2} [dir=none;weight=0, penwidth=0, color=red;]

        {rank=same; p1; g1}
        {rank=same; p2; g2}
     }
     subgraph cluster1 {
        p3 [shape=circle;style=filled;color=deepskyblue;label=g1];
        g3 [shape=point;color=black;size=0];
        g4 [shape=point;color=black;size=0];
        sp1 [label=sp]; ep1 [label=ep];
        p4 [shape=circle;style=filled;color=deepskyblue;label=g2];

        sp1 -> g3 [dir=none;weight=1, penwidth=3 ];
        g3 -> g4 [dir=none;weight=1, penwidth=3,len=10];
        g4 -> ep1 [weight=1, penwidth=3, len=10];

        g4 -> p4 [dir=back;weight=0, penwidth=3, color=red, partiallen=3,
                       label="edge2"];
        p3 -> g3 [weight=0, penwidth=3, color=red, partiallen=3,
                       label="edge1"];
        p3 -> {g3, g4} [dir=none;weight=0, penwidth=0, color=red];

        {rank=same; p3; g3}
        {rank=same; p4; g4}
     }
   }


Additional Examples
-------------------------------------------------------------------------------

.. contents::
   :local:

One point examples
...............................................................................

At most two answers
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* ``cap => 2``

  * Maximum two row answer.
* Default: ``dryrun => false``

  * Process query

.. literalinclude:: findCloseEdges.queries
   :start-after: -- o1
   :end-before: -- o2

.. rubric:: Understanding the result

* ``NULL`` on ``geom``, ``edge``
* ``edge_id`` identifier of the edge close to the **original point**

  * Two edges are withing :math:`0.5` distance units from the **original
    point**: :math:`{5, 8}`
* For edge :math:`5`:

  * ``fraction``: The closest point from the **original point** is at the
    :math:`0.8` fraction of the edge :math:`5`.
  * ``side``: The **original point** is located to the left side of edge
    :math:`5`.
  * ``distance``: The **original point** is located :math:`0.1` length units
    from edge :math:`5`.
* For edge :math:`8`:

  * ``fraction``: The closest point from the **original point** is at the
    :math:`0.89..` fraction of the edge :math:`8`.
  * ``side``: The **original point** is located to the right side of edge
    :math:`8`.
  * ``distance``: The **original point** is located :math:`0.19..` length units
    from edge :math:`8`.

One answer, all columns
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* Default: ``cap => 1``

  * Maximum one row answer.
* Default: ``dryrun => false``

  * Process query

.. literalinclude:: findCloseEdges.queries
   :start-after: -- o2
   :end-before: -- o3

.. rubric:: Understanding the result

* ``edge_id`` identifier of the edge **closest** to the **original point**

  * From all edges within :math:`0.5` distance units from the **original
    point**: :math:`{5}` is the closest one.
* For edge :math:`5`:

  * ``fraction``: The closest point from the **original point** is at the
    :math:`0.8` fraction of the edge :math:`5`.
  * ``side``: The **original point** is located to the left side of edge
    :math:`5`.
  * ``distance``: The **original point** is located :math:`0.1` length units
    from edge :math:`5`.
  * ``geom``: Contains the geometry of the closest point on edge :math:`5` from
    the **original point**.
  * ``edge``: Contains the ``LINESTRING`` geometry of the **original point** to
    the closest point on on edge :math:`5` ``geom``

At most two answers with all columns
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* ``cap => 2``

  * Maximum two row answer.
* Default: ``dryrun => false``

  * Process query

.. literalinclude:: findCloseEdges.queries
   :start-after: -- o3
   :end-before: -- o4

.. rubric:: Understanding the result:

* ``edge_id`` identifier of the edge close to the **original point**

  * Two edges are withing :math:`0.5` distance units from the **original
    point**: :math:`{5, 8}`
* For edge :math:`5`:

  * ``fraction``: The closest point from the **original point** is at the
    :math:`0.8` fraction of the edge :math:`5`.
  * ``side``: The **original point** is located to the left side of edge
    :math:`5`.
  * ``distance``: The **original point** is located :math:`0.1` length units
    from edge :math:`5`.
  * ``geom``: Contains the geometry of the closest point on edge :math:`5` from
    the **original point**.
  * ``edge``: Contains the ``LINESTRING`` geometry of the **original point** to
    the closest point on on edge :math:`5` ``geom``
* For edge :math:`8`:

  * ``fraction``: The closest point from the **original point** is at the
    :math:`0.89..` fraction of the edge :math:`8`.
  * ``side``: The **original point** is located to the right side of edge
    :math:`8`.
  * ``distance``: The **original point** is located :math:`0.19..` length units
    from edge :math:`8`.
  * ``geom``: Contains the geometry of the closest point on edge :math:`8` from
    the **original point**.
  * ``edge``: Contains the ``LINESTRING`` geometry of the **original point** to
    the closest point on on edge :math:`8` ``geom``

One point dry run execution
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* Returns ``EMPTY SET``.

* ``dryrun => true``

  * Do not process query
  * Generate a PostgreSQL ``NOTICE`` with the code used to calculate all columns

    * ``cap`` and **original point** are used in the code

.. literalinclude:: findCloseEdges.queries
   :start-after: -- o5
   :end-before: -- o6

Many points examples
...............................................................................

At most two answers per point
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* ``cap => 2``

  * Maximum two row answer.
* Default: ``dryrun => false``

  * Process query

.. literalinclude:: findCloseEdges.queries
   :start-after: -- m1
   :end-before: -- m2

.. rubric:: Understanding the result

* ``NULL`` on ``edge``
* ``edge_id`` identifier of the edge close to a **original point** (``geom``)

  * Two edges at most withing :math:`0.5` distance units from each of the
    **original points**:

    * For ``POINT(1.8 0.4)`` and ``POINT(0.3 1.8)`` only one edge was found.
    * For the rest of the points two edges were found.
* For point ``POINT(2.9 1.8)``

  * Edge :math:`5` is before :math:`8` therefore edge :math:`5` has the shortest
    distance to ``POINT(2.9 1.8)``.
  * For edge :math:`5`:

    * ``fraction``: The closest point from the **original point** is at the
      :math:`0.8` fraction of the edge :math:`5`.
    * ``side``: The **original point** is located to the left side of edge
      :math:`5`.
    * ``distance``: The **original point** is located :math:`0.1` length units
      from edge :math:`5`.
  * For edge :math:`8`:

    * ``fraction``: The closest point from the **original point** is at the
      :math:`0.89..` fraction of the edge :math:`8`.
    * ``side``: The **original point** is located to the right side of edge
      :math:`8`.
    * ``distance``: The **original point** is located :math:`0.19..` length
      units from edge :math:`8`.

One answer per point, all columns
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* Default: ``cap => 1``

  * Maximum one row answer.
* Default: ``dryrun => false``

  * Process query

.. literalinclude:: findCloseEdges.queries
   :start-after: -- m2
   :end-before: -- m3

.. rubric:: Understanding the result

* ``edge_id`` identifier of the edge **closest** to the **original point**

  * From all edges within :math:`0.5` distance units from the **original
    point**: :math:`{5}` is the closest one.
* For the **original point** ``POINT(2.9 1.8)``

  * Edge :math:`5` is the closest edge to the **original point**
  * ``fraction``: The closest point from the **original point** is at the
    :math:`0.8` fraction of the edge :math:`5`.
  * ``side``: The **original point** is located to the left side of edge
    :math:`5`.
  * ``distance``: The **original point** is located :math:`0.1` length units
    from edge :math:`5`.
  * ``geom``: Contains the geometry of the **original point** ``POINT(2.9 1.8)``
  * ``edge``: Contains the ``LINESTRING`` geometry of the **original point**
    (``geom``) to the closest point on on edge.

Many points dry run execution
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

* Returns ``EMPTY SET``.
* ``dryrun => true``

  * Do not process query
  * Generate a PostgreSQL ``NOTICE`` with the code used to calculate all columns

    * ``cap`` and **original point** are used in the code

.. literalinclude:: findCloseEdges.queries
   :start-after: -- m4
   :end-before: -- m5

Find at most two routes to a given point
...............................................................................

Using :doc:`pgr_withPoints`

.. literalinclude:: findCloseEdges.queries
   :start-after: -- o4
   :end-before: -- o5

A point of interest table
...............................................................................

Handling points outside the graph.

.. include:: sampledata.rst
   :start-after: pois_start
   :end-before: pois_end

Connecting disconnected components
...............................................................................

.. include:: pgRouting-concepts.rst
    :start-after: connecting_graph_start
    :end-before: connecting_graph_end


See Also
-------------------------------------------------------------------------------

* :doc:`withPoints-category`
* :doc:`sampledata`

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
