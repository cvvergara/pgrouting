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

Hawick Circuit algorithm, is published in 2008 by Ken Hawick and Heath A. James.
This algorithm solves the problem of detecting and enumerating circuits in graphs.

It is capable of circuit enumeration in graphs with directed arcs, multiple arcs
and self arcs with a memory efficient and high-performance implementation.

**The main characteristics are:**

- The algorithm implementation works only for directed graph
- The algorithm outputs the distinct circuits present in the graph.
- A circuit is elementary: a vertex is not repeated within a circuit, except the
  starting vertex that closes the circuit.
- Time Complexity: :math:`O((V + E) (c + 1))`

  - where :math:`|E|` is the number of edges in the graph,
  - where :math:`|V|` is the number of vertices in the graph.
  - where :math:`|c|` is the number of circuits in the graph.

|Boost| Boost Graph Inside

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

   | pgr_hawickUniqueCircuits(`Edges SQL`_ [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

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

   | pgr_hawickUniqueCircuits(`Edges SQL`_, **start vid** [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

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

   | pgr_hawickUniqueCircuits(`Edges SQL`_, **start vids** [, **options**])
   | **options:** ``[min_depth, max_depth, self_loops, u_turn_on_edge]``

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

.. graph_start

The examples use the followeing table ``c_example``, that represent a cul_de_sac
where the exit is on vertex :math:`5` and the vehicle is on vertex :math:`1` but
pointing at the wrong direction of the exit.

.. graphviz::

   digraph G {
     graph [splines=false, sep=1];
     node [shape=circle;style=filled;fontsize=8;fixedsize=true;width=.4;color=deepskyblue];
     edge [arrowsize=0.5;color=blue;fontsize=8];

     1 [pos="0,0!"];
     2 [pos="0,2!"];
     3 [pos="2,0!"];
     4 [pos="-1,0!"];
     5 [pos="-1,1!"];

     1 -> 2 [label="1"];
     2 -> 1 [label="1"];
     2 -> 3 [label="2"];
     3 -> 2 [label="2"];
     1 -> 3 [label="3(1.5)"];
     3 -> 1 [label="3 (1.7)"];
     1 -> 3 [label="4"];
     3 -> 1 [label="4"];
     1 -> 4 [label="5"];
     4 -> 1 [label="5"];
     1 -> 5 [label="6"];
     1 -> 1 [headport=s, tailport=s, label="7"];
   }

.. graph_end

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q4
   :end-before: -- q5

:Example 0: All possible unique ways to return to vertex :math:`1`.

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q5
   :end-before: -- q6

:Example 2: Exclude self loops.

- purple is :math:`path\_id = 1`
- magenta is :math:`path\_id = 1`
- red is :math:`path\_id = 2`
- green is :math:`path\_id = 2`
- blue is :math:`path\_id = 3`

.. graphviz::

   digraph G {
       forcelabels=true;
     graph [splines=line, sep=1];
     node [shape=circle;style=filled;fontsize=8;fixedsize=true;width=.4;color=deepskyblue];
     edge [arrowsize=0.5;fontsize=8];

     1 [pos="0,0!"];
     2 [pos="0,2!"];
     3 [pos="2,1!"];
     4 [pos="-1,0!"];
     5 [pos="-1,1!"];

     1 -> 2 [color=purple,xlabel="1       "];
     2 -> 1 [color=purple,xlabel="1"];

     1 -> 3 [color=magenta,xlabel="4       "];
     3 -> 1 [color=magenta,xlabel="4"];


     1 -> 2 [color=red,xlabel="1  "];
     2 -> 3 [color=red,xlabel="2    "];
     3 -> 1 [color=red,xlabel="4    "];

     1 -> 3 [color=green,xlabel="3       "];
     3 -> 1 [color=green,xlabel="4"];

     1 -> 3 [color=blue,taillabel="                  3"];
     3 -> 2 [color=blue,xlabel="2  "];
     2 -> 1 [color=blue,xlabel="1"];
   }

.. literalinclude:: hawickUniqueCircuits.queries
   :start-after: -- q6
   :end-before: -- q7

:Example 3: Exclude self loops and U-turn on the same edge.

- red is :math:`path\_id = 1`
- green is :math:`path\_id = 2`
- blue is :math:`path\_id = 3`

.. graphviz::

   digraph G {
       forcelabels=true;
     graph [splines=line, sep=1];
     node [shape=circle;style=filled;fontsize=8;fixedsize=true;width=.4;color=deepskyblue];
     edge [arrowsize=0.5;fontsize=8];

     1 [pos="0,0!"];
     2 [pos="0,2!"];
     3 [pos="2,1!"];
     4 [pos="-1,0!"];
     5 [pos="-1,1!"];


     1 -> 2 [color=red];
     2 -> 3 [color=red];
     3 -> 1 [color=red,xlabel="3"];

     1 -> 3 [color=green,penwidth=5,xlabel="4"];
     3 -> 1 [color=green,xlabel="3"];

     1 -> 3 [color=blue,penwidth=5,taillabel="                 4"];
     3 -> 2 [color=blue];
     2 -> 1 [color=blue];
   }


.. literalinclude:: hawickUniqueCircuits.queries
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
