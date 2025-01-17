..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************


.. index:: Contraction Family

|

Contraction - Family of functions
===============================================================================

.. official-start

* :doc:`pgr_contraction`

.. official-end

.. toctree::
    :hidden:

    pgr_contraction


Introduction
-------------------------------------------------------------------------------

In large graphs, like the road graphs, or electric networks, graph contraction
can be used to speed up some graph algorithms.
Contraction can reduce the size of the graph by removing some of the vertices
and edges and adding edges that represent a sequence of original edges
(the original ones can be kept in some methods). In this way, it decreases
the total time and space used by graph algorithms.

This implementation gives a flexible framework for adding contraction algorithms
in the future, currently, it supports three algorithms. The two first ones correspond
to the method ``pgr_contraction``:

1. Dead end contraction
2. Linear contraction

A third one corresponds to the *contraction hierarchies* method and is implemented
through the ``pgr_contraction_hierarchies`` method.

In both cases, it allows the user to forbid contraction on a set of nodes.

For the ``pgr_contraction`` method, the user can also decide the order of the
contraction algorithms and set the maximum number of times they will be executed.

Dead end contraction
-------------------------------------------------------------------------------

Contraction of the leaf nodes of the graph.

Dead end
..............................................................................

A node is considered a **dead end** node when

* On undirected graphs:

  * The number of adjacent vertices is 1.

* On directed graphs:

  * The number of adjacent vertices is 1.
  * There are no outgoing edges and has at least one incoming edge.
  * There are no incoming edges and has at least one outgoing edge.


When the conditions are true then the `Operation: Dead End Contraction`_ can be
done.

Dead end vertex on undirected graph
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

- The green nodes are `dead end`_ nodes
- The blue nodes have an unlimited number of edges.

.. graphviz::

    graph G {
        u, v [shape=circle;style=filled;width=.4;color=deepskyblue];
        a, b [style=filled; color=green];
        G [shape=tripleoctagon;width=1.5;style=filled;
           color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        G -- {u, v} [dir=none, weight=1, penwidth=3];
        u -- a [color=black];
        u -- a [color=darkgray];
        v -- b;
    }

.. list-table::
   :width: 80
   :widths: auto
   :header-rows: 1

   * - Node
     - Adjacent nodes
     - Number of adjacent nodes
   * - :math:`a`
     - :math:`\{u\}`
     - 1
   * - :math:`b`
     - :math:`\{v\}`
     - 1


Dead end vertex on directed graph
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

- The green nodes are `dead end`_ nodes
- The blue nodes have an unlimited number of incoming and/or outgoing edges.

.. graphviz::

    digraph G {
        u, v, w, x, y [shape=circle;style=filled;width=.4;color=deepskyblue];
        a, b, c, d, e [style=filled; color=green];
        G [shape=tripleoctagon;width=1.5;style=filled;
           color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        G -> {u, v, w} [dir=none, weight=1, penwidth=3];
        {x, y} -> G [dir=none, weight=1, penwidth=3];
        u -> a -> u;
        v -> b;
        {w, v} -> c;
        d -> x;
        e -> {x, y};
    }


.. list-table::
   :width: 80
   :widths: auto
   :header-rows: 1

   * - Node
     - Adjacent nodes
     - Number of adjacent nodes
     - Number of incoming edges
     - Number of outgoing edges
   * - :math:`a`
     - :math:`\{u\}`
     - 1
     -
     -
   * - :math:`b`
     - :math:`\{v\}`
     - 1
     -
     -
   * - :math:`c`
     - :math:`\{v, w\}`
     - 2
     - 2
     - 0
   * - :math:`d`
     - :math:`\{x\}`
     - 1
     -
     -
   * - :math:`e`
     - :math:`\{x, y\}`
     - 2
     - 0
     - 2


From above, nodes :math:`\{a, b, d\}` are dead ends because the
number of adjacent vertices is 1. No further checks are needed for those nodes.

On the following table, nodes :math:`\{c, e\}` because the
even that the number of adjacent vertices is not 1 for

* :math:`c`

  * There are no outgoing edges and has at least one incoming edge.

* :math:`e`

  * There are no incoming edges and has at least one outgoing edge.

Operation: Dead End Contraction
...............................................................................

The dead end contraction will stop until there are no more dead end nodes.
For example from the following graph where :math:`w` is the `dead end`_ node:

.. graphviz::

    digraph G {
        u, v [shape=circle;style=filled;width=.4;color=deepskyblue];
        w [style=filled; color=green];
        "G" [shape=tripleoctagon;style=filled;
        color=deepskyblue; label = "Rest of the Graph"];

        rankdir=LR;
        G -> u [dir=none, weight=1, penwidth=3];
        u -> v -> w;
    }


After contracting :math:`w`, node :math:`v` is now a `dead end`_ node and is
contracted:

.. graphviz::

    digraph G {
        u [shape=circle;style=filled;width=.4;color=deepskyblue];
        v [style=filled; color=green, label="v{w}"];
        "G" [shape=tripleoctagon;style=filled;
            color=deepskyblue; label = "Rest of the Graph"];

        rankdir=LR;
        G -> u [dir=none, weight=1, penwidth=3];
        u -> v;
    }

After contracting :math:`v`, stop. Node :math:`u` has the information of nodes
that were contrcted.

.. graphviz::

    digraph G {
        u [style=filled; color=green, label="u{v,w}"];
        "G" [shape=tripleoctagon;style=filled;
             color=deepskyblue; label = "Rest of the Graph"];

        rankdir=LR;
        G -> u [dir=none, weight=1, penwidth=3];
    }

Node :math:`u` has the information of nodes that were contracted.


Linear contraction
-------------------------------------------------------------------------------
In the algorithm, linear contraction is represented by 2.

Linear
................................................................................

In case of an undirected graph, a node is considered a `linear` node when

* The number of adjacent vertices is 2.

In case of a directed graph, a node is considered a `linear` node when

* The number of adjacent vertices is 2.
* Linearity is symmetrical

Linear vertex on undirected graph
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

- The green nodes are `linear`_ nodes
- The blue nodes have an unlimited number of incoming and outgoing edges.


.. rubric:: Undirected

.. graphviz::

    graph G {
        u, w [shape=circle;style=filled;width=.4;color=deepskyblue];
        v [style=filled; color=green];
        G [shape=tripleoctagon;width=1.5;style=filled;
           color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        w -- G -- u [dir=none, weight=1, penwidth=3];
        u -- v -- w;
    }

.. list-table::
   :width: 80
   :widths: auto
   :header-rows: 1

   * - Node
     - Adjacent nodes
     - Number of adjacent nodes
   * - :math:`v`
     - :math:`\{u, w\}`
     - 2

Linear vertex on directed graph
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

- The green nodes are `linear`_ nodes
- The blue nodes have an unlimited number of incoming and outgoing edges.
- The white node is not linear because the linearity is not symetrical.

  * It is possible to go :math:`y \rightarrow c \rightarrow z`
  * It's not possible to go :math:`z \rightarrow c \rightarrow y`

.. graphviz::

    digraph G {
        u, v, w, x, y, z [shape=circle;style=filled;width=.4;color=deepskyblue];
        a, b [style=filled; color=green];
        G [shape=tripleoctagon;width=1.5;style=filled;
          color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        {u, v} -> G -> {x, w, y, z} [dir=none, weight=1, penwidth=3];
        u -> a -> v;
        w -> b -> x;
        x -> b -> w [color=darkgray];
        y -> c -> z -> c;
    }

.. list-table::
   :width: 80
   :widths: auto
   :header-rows: 1

   * - Node
     - Adjacent nodes
     - Number of adjacent nodes
     - Is symmetrical?
   * - :math:`a`
     - :math:`\{u, v\}`
     - 2
     - yes
   * - :math:`b`
     - :math:`\{w, x\}`
     - 2
     - yes
   * - :math:`c`
     - :math:`\{y, z\}`
     - 2
     - no

Operation: Linear Contraction
...............................................................................

The linear contraction will stop when there are no more linear nodes.
For example from the following graph where :math:`v` and :math:`w` are `linear`_
nodes:

.. graphviz::

    digraph G {
        u, z [shape=circle;style=filled;color=deepskyblue];
        v, w [style=filled; color=green];
        "G" [shape=tripleoctagon; style=filled;
             color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        G -> {u, z} [dir=none, weight=1, penwidth=3];
        u -> v -> w -> z;
    }

Contracting :math:`w`,

* The vertex :math:`w` is removed from the graph
* The edges :math:`v \rightarrow w` and :math:`w \rightarrow z` are removed
  from the graph.
* A new edge :math:`v \rightarrow z` is inserted represented with red color.

.. graphviz::

    digraph G {
        u, z [shape=circle;style=filled;color=deepskyblue];
        v [style=filled; color=green];
        "G" [shape=tripleoctagon; style=filled;
             color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        G -> {u, z} [dir=none, weight=1, penwidth=3];
        u -> v;
        v -> z [label="{w}";color=red]
    }

Contracting :math:`v`:

* The vertex :math:`v` is removed from the graph
* The edges :math:`u \rightarrow v` and :math:`v \rightarrow z` are removed
  from the graph.
* A new edge :math:`u \rightarrow z` is inserted represented with red color.


.. graphviz::

    digraph G {
        u, z [shape=circle;style=filled;color=deepskyblue];
        "G" [shape=tripleoctagon; style=filled;
             color=deepskyblue;label = "Rest of the Graph"];

        rankdir=LR;
        G -> {u, z} [dir=none, weight=1, penwidth=3];
        u -> z [label="{v, w}";color=red]
    }

Edge :math:`u \rightarrow z` has the information of nodes that were contracted.

Contraction hierarchies
-------------------------------------------------------------------------------

Contraction of edges and nodes ordered by importance.


Principles
...............................................................................

A total node order is given. If u < v, then u is less important than v. 
A hierarchy is now constructed by contracting the nodes in this order. 

A node v is contracted by removing from the graph and adding shortcuts by replacing 
former paths of the form (u, v, w) by an edge (u, w). The shortcut (u, w) is only 
needed when (u, v, w) is the only shortest path between u and w.

The contraction process adds all discovered shortcuts to the edge set E, giving 
a "contraction hierarchy". Finding an optimal node ordering is a difficult problem.
Nevertheless, very simple local heuristics work quite well, according to Geisberger 
et al. [2].

The basic idea is to keep the nodes in a priority queue sorted by some estimate of how 
attractive is their contraction. We estimate that with the "edge difference" given by 
the difference between the number of shortcuts produced by the node contraction minus
the number of incident edges in the original graph. Finally, the aim is to reduce 
with cleverness the size of the graph, without loosing optimality. 

Initialize the queue with a first vertices order
...............................................................................

For each vertex ``v`` of the graph, build contraction of ``v``:

.. graphviz::

    graph G {
        p, r, u, w [shape=circle;style=filled;width=.4;color=deepskyblue];
        v [style=filled; color=green];

        rankdir=LR;
        v -- p [dir=both, weight=10, arrowhead=vee, arrowtail=vee, label="  10"];
        v -- r [dir=both, weight=3, arrowhead=vee, arrowtail=vee, label="  3"];
        v -- u [dir=both, weight=6, arrowhead=vee, arrowtail=vee, label="  6"];
        p -- u [dir=both, weight=16, arrowhead=vee, arrowtail=vee, label="  12"];
        r -- w [dir=both, weight=5, arrowhead=vee, arrowtail=vee, label="  5"];
        u -- w [dir=both, weight=5, arrowhead=vee, arrowtail=vee, label="  5"];
        p -- r [dir=both, weight=13, arrowhead=vee, arrowtail=vee, label="  13", style="invis"];
        u -- r [dir=both, weight=9, arrowhead=vee, arrowtail=vee, label="  9", style="invis"];
    }

.. list-table::
   :width: 80
   :widths: auto
   :header-rows: 1

   * - Node
     - Adjacent nodes
   * - :math:`v`
     - :math:`\{p, r, u, w\}`
   * - :math:`p`
     - :math:`\{r, v\}`
   * - :math:`u`
     - :math:`\{r, v, w\}`
   * - :math:`r`
     - :math:`\{v, w\}`
   * - :math:`w`
     - :math:`\{r, u\}`

Remove adjacent edges.

.. graphviz::

    graph G {
        p, r, u, w [shape=circle;style=filled;width=.4;color=deepskyblue];
        v [style=filled; color=green];

        rankdir=LR;
        v -- p [dir=both, weight=10, arrowhead=vee, arrowtail=vee, label="  10", style="invis"];
        v -- r [dir=both, weight=3, arrowhead=vee, arrowtail=vee, label="  3", style="invis"];
        v -- u [dir=both, weight=6, arrowhead=vee, arrowtail=vee, label="  6", style="invis"];
        p -- r [dir=both, weight=13, arrowhead=vee, arrowtail=vee, label="  13", color=red, style="invis"];
        u -- r [dir=both, weight=9, arrowhead=vee, arrowtail=vee, label="  9", color=red, style="invis"];
        p -- u [dir=both, weight=16, arrowhead=vee, arrowtail=vee, label="  12"];
        r -- w [dir=both, weight=5, arrowhead=vee, arrowtail=vee, label="  5"];
        u -- w [dir=both, weight=5, arrowhead=vee, arrowtail=vee, label="  5"];
    }

Build shortcuts from predecessors of ``v`` to successors of ``v`` if and only if the path through ``v``
corresponds to the only shortest path between the predecessor and the successor of ``v`` in the graph.

.. graphviz::

    graph G {
        p, r, u, w [shape=circle;style=filled;width=.4;color=deepskyblue];
        v [style=filled; color=green];

        rankdir=LR;
        v -- p [dir=both, weight=10, arrowhead=vee, arrowtail=vee, label="  10", style="invis"];
        v -- r [dir=both, weight=3, arrowhead=vee, arrowtail=vee, label="  3", style="invis"];
        v -- u [dir=both, weight=6, arrowhead=vee, arrowtail=vee, label="  6", style="invis"];
        p -- r [dir=both, weight=13, arrowhead=vee, arrowtail=vee, label="  13", color=red];
        u -- r [dir=both, weight=9, arrowhead=vee, arrowtail=vee, label="  9", color=red];
        p -- u [dir=both, weight=16, arrowhead=vee, arrowtail=vee, label="  12"];
        r -- w [dir=both, weight=5, arrowhead=vee, arrowtail=vee, label="  5"];
        u -- w [dir=both, weight=5, arrowhead=vee, arrowtail=vee, label="  5"];
    }

Take the following vertex and contract it. Go on until you have contracted every node of the graph. 
At the end, there are no more edges in the graph.

This first contraction will give you a vertex order, given by ordering them in ascending order on
the metric (edge difference). Keep the vertices into a queue.

Build the final vertex order
...............................................................................

Once you have built the first order, use it to browse the graph once again. For each vertex taken
in the queue, simulate contraction and calculate its edge difference. If the computed value is
greater than the one of the next vertex to be contracted, then put it back in the queue. 
Otherwise contract it permanently.

At the end, take the initial graph (before edges deletions) and add the shortcut edges to it.
You will have your contracted graph, ready to use with a specialized Dijkstra algorithm,
which takes into account the order of the nodes in the hierarchy.


Application of the cycle of methods (for algorithms of the ``pgr_contraction`` function)
-------------------------------------------------------------------------------

Contracting a graph, can be done with more than one operation.
The order of the operations affect the resulting contracted graph, after
applying one operation, the set of vertices that can be contracted
by another operation changes.

This implementation, cycles ``max_cycles`` times through ``operations_order`` .

.. parsed-literal::

    <input>
    do max_cycles times {
        for (operation in operations_order)
         { do operation }
    }
    <output>


Contracting sample data
-------------------------------------------------------------------------------

In this section, building and using a contracted graph will be shown by example.

- The :doc:`sampledata` for an undirected graph is used
- a dead end operation first followed by a linear operation.


.. contents::
   :local:

Construction of the graph in the database
...............................................................................

.. rubric:: Original Data

The following query shows the original data involved in the contraction
operation.

.. literalinclude:: contraction-family.queries
   :start-after: -- q00
   :end-before: -- q01

The original graph:

.. image:: /images/Fig6-undirected.png
   :scale: 25%

Contraction results
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The results do not represent the contracted graph.
They represent the changes done to the graph after applying the contraction
algorithm.

Observe that vertices, for example, :math:`6` do not appear in the results
because it was not affected by the contraction algorithm.

.. literalinclude:: contraction-family.queries
   :start-after: -- q2
   :end-before: -- q3

After doing the dead end contraction operation:

.. image:: images/undirected_sampledata_b.png
   :scale: 25%

After doing the linear contraction operation to the graph above:

.. image:: images/undirected_sampledata_c.png
   :scale: 25%

The process to create the contraction graph on the database:

.. contents::
   :local:

Add additional columns
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Adding extra columns to the ``edge_table`` and ``edge_table_vertices_pgr``
tables, where:

.. list-table::
   :width: 80
   :widths: auto
   :header-rows: 1

   * - Column
     - Description
   * - ``contracted_vertices``
     - The vertices set belonging to the vertex/edge
   * - ``is_contracted``
     - On the vertex table

       * when ``true`` the vertex is contracted, its not part of the contracted
         graph.
       * when ``false`` the vertex is not contracted, its part of the contracted
         graph.
   * - ``is_new``
     - On the edge table

       * when ``true`` the edge was generated by the contraction algorithm. its
         part of the contracted graph.
       * when ``false`` the edge is an original edge, might be or not part of
         the contracted graph.

.. literalinclude:: contraction-family.queries
   :start-after: -- q1
   :end-before: -- q2

Store contraction information
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Store the `contraction results`_ in a table

.. literalinclude:: contraction-family.queries
   :start-after: -- q3
   :end-before: -- q4


The vertex table update
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Use ``is_contracted`` column to indicate the vertices that are contracted.

.. literalinclude:: contraction-family.queries
   :start-after: -- q4
   :end-before: -- q5

Fill ``contracted_vertices`` with the information from the results tha belong to
the vertices.

.. literalinclude:: contraction-family.queries
   :start-after: -- q6
   :end-before: -- q7

The modified vertices table:

.. literalinclude:: contraction-family.queries
   :start-after: -- q7
   :end-before: -- q8

The edge table update
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Insert the new edges generated by pgr_contraction.

.. literalinclude:: contraction-family.queries
   :start-after: -- q8
   :end-before: -- q9

The modified ``edge_table``.

.. literalinclude:: contraction-family.queries
   :start-after: -- q9
   :end-before: -- q10


The contracted graph
...............................................................................

Vertices that belong to the contracted graph.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. literalinclude:: contraction-family.queries
   :start-after: -- q10
   :end-before: -- q11

Edges that belong to the contracted graph.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. literalinclude:: contraction-family.queries
   :start-after: -- q11
   :end-before: -- case1

Contracted graph
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. image:: images/newgraph.png
   :scale: 25%

Using the contracted graph
...............................................................................

Using the contracted graph with ``pgr_dijkstra``

There are three cases when calculating the shortest path between a given source
and target in a contracted graph:

- Case 1: Both source and target belong to the contracted graph.
- Case 2: Source and/or target belong to an edge subgraph.
- Case 3: Source and/or target belong to a vertex.

Case 1: Both source and target belong to the contracted graph.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Using the `Edges that belong to the contracted graph.`_ on lines 11 to 20.

.. literalinclude:: contraction-family.queries
   :emphasize-lines: 11-20
   :start-after: -- case1
   :end-before: -- use1
   :linenos:

.. rubric:: Case 1

When both source and target belong to the contracted graph, a path is found.

.. literalinclude:: contraction-family.queries
   :start-after: -- use1
   :end-before: -- use1-1

.. rubric:: Case 2

When source and/or target belong to an edge subgraph then a path is not found.

In this case, the contracted graph do not have an edge connecting with
node :math:`4`.

.. literalinclude:: contraction-family.queries
   :start-after: -- use1-1
   :end-before: -- use1-2

.. rubric:: Case 3

When source and/or target belong to a vertex then a path is not found.

In this case, the contracted graph do not have an edge connecting with
node :math:`7` and of node :math:`4` of the second case.

.. literalinclude:: contraction-family.queries
   :start-after: -- use1-2
   :end-before: -- case2

Case 2: Source and/or target belong to an edge subgraph.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Refining the above function to include nodes that belong to an edge.

- The vertices that need to be expanded are calculated on lines 11 to 17.
- Adding to the contracted graph that additional section on lines 26 to 28.

.. literalinclude:: contraction-family.queries
   :emphasize-lines: 11-17, 26-28
   :start-after: -- case2
   :end-before: -- use2
   :linenos:

.. rubric:: Case 1

When both source and target belong to the contracted graph, a path is found.

.. literalinclude:: contraction-family.queries
   :start-after: -- use2
   :end-before: -- use2-1

.. rubric:: Case 2

When source and/or target belong to an edge subgraph, now, a path is found.

The routing graph now has an edge connecting with node :math:`4`.

.. literalinclude:: contraction-family.queries
   :start-after: -- use2-1
   :end-before: -- use2-2

.. rubric:: Case 3

When source and/or target belong to a vertex then a path is not found.

In this case, the contracted graph do not have an edge connecting with
node :math:`7`.

.. literalinclude:: contraction-family.queries
   :start-after: -- use2-2
   :end-before: -- case3

Case 3: Source and/or target belong to a vertex.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Refining the above function to include nodes that belong to an edge.

- The vertices that need to be expanded are calculated on lines 19 to 24.
- Adding to the contracted graph that additional section on lines 38 to 40.

.. literalinclude:: contraction-family.queries
   :emphasize-lines: 19-24, 39-41
   :start-after: -- case3
   :end-before: -- use3
   :linenos:

.. rubric:: Case 1

When both source and target belong to the contracted graph, a path is found.

.. literalinclude:: contraction-family.queries
   :start-after: -- use3
   :end-before: -- use3-1

.. rubric:: Case 2

The code change do not affect this case so when source and/or target belong
to an edge subgraph, a path is still found.

.. literalinclude:: contraction-family.queries
   :start-after: -- use3-1
   :end-before: -- use3-2

.. rubric:: Case 3

When source and/or target belong to a vertex, now, a path is found.

Now, the routing graph has an edge connecting with node :math:`7`.

.. literalinclude:: contraction-family.queries
   :start-after: -- use3-2
   :end-before: -- end


Application of the contraction hierarchies method
-------------------------------------------------------------------------------

We finally show an example of contraction hierarchies building, on the same
sample graph as before, also with an undirected graph.

he following query shows the original data involved in the contraction
operation.

.. literalinclude:: contraction-family.queries
   :start-after: -- q0
   :end-before: -- q1

The original graph:

.. image:: /images/Fig6-undirected.png
   :scale: 25%

Contraction results
...............................................................................

The results do not represent the contracted graph.
They represent the changes done to the graph after applying the contraction
algorithm.

Vertices are all represented in the result (except of course forbidden ones)
as long as the contraction hierarchies are applied (method 3), since the method
gives an order to all contracted vertices in the graph.

Otherwise, when applying linear or dead-end contractions, vertices that are not
affected by the contraction will not appear in the result (see ).

.. literalinclude:: contraction-family.queries
   :start-after: -- q2
@@ -472,10 +601,14 @@ After doing the linear contraction operation to the graph above:
.. image:: images/undirected_sampledata_c.png
   :scale: 25%

After computing the contraction hierarchies, the graph stays unchanged.
Nevertheless, an order is now given to the vertices, in order to be used
with a specific Dijkstra algorithm (implementation coming in a future version),
which speeds up the search. As a consequence, if method 3 is used, all vertices
browsed by the contraction will be represented in the result.

The process to create the graph in the database is the same as before.


See Also
-------------------------------------------------------------------------------

* :doc:`pgr_contraction`
* :doc:`sampledata`
* https://www.cs.cmu.edu/afs/cs/academic/class/15210-f12/www/lectures/lecture16.pdf
* https://ae.iti.kit.edu/download/diploma_thesis_geisberger.pdf
* https://jlazarsfeld.github.io/ch.150.project/contents/

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
