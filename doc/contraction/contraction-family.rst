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

.. include:: proposed.rst
    :start-after: warning-begin
    :end-before: end-warning

.. proposed-start

* :doc:`pgr_contractionDeadEnd`

.. proposed-end

.. include:: experimental.rst
    :start-after: warning-begin
    :end-before: end-warning

.. experimental-start

* :doc:`pgr_contractionHierarchies`

.. experimental-end

.. toctree::
    :hidden:

    pgr_contraction
    pgr_contractionDeadEnd
    pgr_contractionLinear
    pgr_contractionHierarchies


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
through the ``pgr_contractionHierarchies`` method.

Both functions allow the user to forbid contraction on a set of nodes.

For the ``pgr_contraction`` method, the user can also decide the order of the
contraction algorithms and set the maximum number of times they will be executed.

See Also
-------------------------------------------------------------------------------

* https://www.cs.cmu.edu/afs/cs/academic/class/15210-f12/www/lectures/lecture16.pdf
* https://ae.iti.kit.edu/download/diploma_thesis_geisberger.pdf
* https://jlazarsfeld.github.io/ch.150.project/contents/

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
