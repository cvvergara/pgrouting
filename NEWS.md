# pgRouting 3


## pgRouting 3.8


.. current

### pgRouting 3.8.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.8.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.8.0%22)

**Promotion to official function of pgRouting.**

* [#2772](https://github.com/pgRouting/pgrouting/issues/2772):
  pgr_extractVertices

  * Error messages adjustment.
  * Function promoted to official.

* [#2760](https://github.com/pgRouting/pgrouting/issues/2760):
  pgr_degree

  * Error messages adjustment.
  * New signature with only Edges SQL.
  * Function promoted to official.

* [#2774](https://github.com/pgRouting/pgrouting/issues/2774):
  pgr_findCloseEdges

  * Error messages adjustment.
  * ``partial`` option is removed.
  * Function promoted to official.

**Deprecation of functions.**

* [#2749](https://github.com/pgRouting/pgrouting/issues/2749):
  pgr_alphaShape
* [#2754](https://github.com/pgRouting/pgrouting/issues/2754):
  pgr_analyzeOneWay
* [#2753](https://github.com/pgRouting/pgrouting/issues/2753):
  pgr_analyzeGraph
* [#2750](https://github.com/pgRouting/pgrouting/issues/2750):
  pgr_createTopology
* [#2826](https://github.com/pgRouting/pgrouting/issues/2826):
  pgr_createVerticesTable

**Official functions changes**

* [#2786](https://github.com/pgRouting/pgrouting/issues/2786): pgr_contraction

  * New signature:
    * Previously compulsory parameter **Contraction order** is now optional with
      name ``methods``.
    * New name and order of optional parameters.
  * Deprecated signature pgr_contraction(text,bigint[],integer,bigint[],boolean)

**New proposed functions**

* Contraction

  * [#2790](https://github.com/pgRouting/pgrouting/issues/2790): pgr_contractionDeadEnd
  * [#2791](https://github.com/pgRouting/pgrouting/issues/2791): pgr_contractionLinear

## pgRouting 3.7

### pgRouting 3.7.3 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.7.3
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.7.3%22)

* [#2731](https://github.com/pgRouting/pgrouting/pull/2731) Build Failure on Ubuntu 22

### pgRouting 3.7.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.7.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.7.2%22)

**Build**

* [#2713](https://github.com/pgRouting/pgrouting/pull/2713) cmake missing
  some policies and min version

  - Using OLD policies: CMP0148, CMP0144, CMP0167
  - Minimum cmake version 3.12

**Bug fixes**

* [#2707](https://github.com/pgRouting/pgrouting/pull/2707) Build failure in
  pgRouting 3.7.1 on Alpine
* [#2706](https://github.com/pgRouting/pgrouting/pull/2706) winnie crashing
  on pgr_betweennessCentrality

### pgRouting 3.7.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.7.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.7.1%22)

**Bug fixes**

* [#2680](https://github.com/pgRouting/pgrouting/pull/2680) fails to compile
  under mingw64 gcc 13.2
* [#2689](https://github.com/pgRouting/pgrouting/pull/2689) When point is a
  vertex, the withPoints family do not return results.

**C/C++ code enhancemet**

* TRSP family

### pgRouting 3.7.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.7.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.7.0%22)

**Support**

* [#2656](https://github.com/pgRouting/pgrouting/pull/2656) Stop support of
  PostgreSQL12 on pgrouting v3.7

  * Stopping support of PostgreSQL 12
  * CI does not test for PostgreSQL 12

**New experimental functions**

* Metrics

  * pgr_betweennessCentrality

**Official functions changes**

* [#2605](https://github.com/pgRouting/pgrouting/pull/2605) Standardize
  spanning tree functions output

  * Functions:

    * ``pgr_kruskalDD``
    * ``pgr_kruskalDFS``
    * ``pgr_kruskalBFS``
    * ``pgr_primDD``
    * ``pgr_primDFS``
    * ``pgr_primBFS``

  * Standarizing output columns to ``(seq, depth, start_vid, pred, node, edge, cost, agg_cost)``
    * Added ``pred`` result columns.

**Experimental promoted to proposed.**

* [#2635](https://github.com/pgRouting/pgrouting/pull/2635) pgr_LineGraph
  ignores directed flag and use negative values for identifiers.

  * ``pgr_lineGraph``

    * Function promoted to proposed.
    * Works for directed and undirected graphs.

**Code enhancement**

* [#2599](https://github.com/pgRouting/pgrouting/pull/2599) Driving distance
  cleanup
* [#2607](https://github.com/pgRouting/pgrouting/pull/2607) Read postgresql
  data on C++
* [#2614](https://github.com/pgRouting/pgrouting/pull/2614) Clang tidy does
  not work

## pgRouting 3.6


### pgRouting 3.6.3 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.6.3
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.6.3%22)

**Build**

* Explicit minimum requirements:

  * postgres 11.0.0
  * postgis 3.0.0

* g++ 13+ is supported

**Code fixes**

* Fix warnings from cpplint.
* Fix warnings from clang 18.

**CI tests**

* Add a clang tidy test on changed files.
* Update test not done on versions: 3.0.1, 3.0.2, 3.0.3, 3.0.4, 3.1.0, 3.1.1,
  3.1.2

**Documentation**

* Results of documentation queries adujsted to  1.83.0 version:

  * pgr_edgeDisjointPaths
  * pgr_stoerWagner

**pgtap tests**

* bug fixes


### pgRouting 3.6.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.6.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.6.2%22)

**Upgrade fix**

* The upgrade was failing for same minor

**Code fixes**

* Fix warnings from cpplint

**Others**

* Adjust NEWS generator

  * Name change to `NEWS.md` for better visualization on GitHub

### pgRouting 3.6.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.6.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.6.1%22)

* [#2588](https://github.com/pgRouting/pgrouting/pull/2588) pgrouting 3.6.0
  fails to build on OSX

### pgRouting 3.6.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.6.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.6.0%22)

**Official functions changes**

* [#2516](https://github.com/pgRouting/pgrouting/pull/2516) Standardize output
  pgr_aStar

  * Standardize output columns to ``(seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost)``

    * pgr_aStar(One to One) added ``start_vid`` and ``end_vid`` columns.
    * pgr_aStar(One to Many) added ``end_vid`` column.
    * pgr_aStar(Many to One) added ``start_vid`` column.

* [#2523](https://github.com/pgRouting/pgrouting/pull/2523) Standardize output
  pgr_bdAstar

  * Standardize output columns to ``(seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost)``

    * pgr_bdAstar(One to One) added ``start_vid`` and ``end_vid``
      columns.
    * pgr_bdAstar(One to Many) added ``end_vid`` column.
    * pgr_bdAstar(Many to One) added ``start_vid`` column.

* [#2547](https://github.com/pgRouting/pgrouting/pull/2547) Standardize output
  and modifying signature pgr_KSP

  * Result columns standarized to: ``(seq, path_id, path_seq, start_vid, end_vid, node, edge, cost, agg_cost)``
  * pgr_ksp(One to One)
    * Added ``start_vid`` and ``end_vid`` result columns.
  * New proposed signatures:
    * pgr_ksp(One to Many)
    * pgr_ksp(Many to One)
    * pgr_ksp(Many to Many)
    * pgr_ksp(Combinations)

* [#2548](https://github.com/pgRouting/pgrouting/pull/2548) Standardize output
  pgr_drivingDistance

  * Standarizing output columns to ``(seq, depth, start_vid, pred, node, edge, cost, agg_cost)``
    * pgr_drivingDistance(Single vertex)
      * Added ``depth`` and ``start_vid`` result columns.
    * pgr_drivingDistance(Multiple vertices)
      * Result column name change: ``from_v`` to ``start_vid``.
      * Added ``depth`` and ``pred`` result columns.

**Proposed functions changes**

* [#2544](https://github.com/pgRouting/pgrouting/pull/2544) Standardize output
  and modifying signature pgr_withPointsDD

  * Signature change: ``driving_side`` parameter changed from named optional to
    unnamed compulsory **driving side**.
    * pgr_withPointsDD(Single vertex)
    * pgr_withPointsDD(Multiple vertices)
  * Standarizing output columns to ``(seq, depth, start_vid, pred, node, edge, cost, agg_cost)``
    * pgr_withPointsDD(Single vertex)
      * Added ``depth``, ``pred`` and ``start_vid`` column.
    * pgr_withPointsDD(Multiple vertices)
      * Added ``depth``, ``pred`` columns.
  * When ``details`` is ``false``:
    * Only points that are visited are removed, that is, points reached within the
      distance are included
  * Deprecated signatures
    * pgr_withpointsdd(text,text,bigint,double precision,boolean,character,boolean)``
    * pgr_withpointsdd(text,text,anyarray,double precision,boolean,character,boolean,boolean)``

* [#2546](https://github.com/pgRouting/pgrouting/pull/2546) Standardize output
  and modifying signature pgr_withPointsKSP

  * Standarizing output columns to ``(seq, path_id, path_seq, start_vid, end_vid, node, edge, cost, agg_cost)``
  * pgr_withPointsKSP(One to One)
    * Signature change: ``driving_side`` parameter changed from named optional to
      unnamed compulsory **driving side**.
    * Added ``start_vid`` and ``end_vid`` result columns.
  * New proposed signatures:
    * pgr_withPointsKSP(One to Many)
    * pgr_withPointsKSP(Many to One)
    * pgr_withPointsKSP(Many to Many)
    * pgr_withPointsKSP(Combinations)
  * Deprecated signature
    * pgr_withpointsksp(text,text,bigint,bigint,integer,boolean,boolean,char,boolean)``

**C/C++ code enhancements**

* [#2504](https://github.com/pgRouting/pgrouting/pull/2504) To C++ pg data get,
  fetch and check.

  * Stopping support for compilation with MSVC.

* [#2505](https://github.com/pgRouting/pgrouting/pull/2505) Using namespace.
* [#2512](https://github.com/pgRouting/pgrouting/pull/2512) [Dijkstra] Removing
  duplicate code on Dijkstra.
* [#2517](https://github.com/pgRouting/pgrouting/pull/2517) Astar code
  simplification.
* [#2521](https://github.com/pgRouting/pgrouting/pull/2521) Dijkstra code
  simplification.
* [#2522](https://github.com/pgRouting/pgrouting/pull/2522) bdAstar code
  simplification.

**Documentation**

* [#2490](https://github.com/pgRouting/pgrouting/pull/2490) Automatic page
  history links.

* ..rubric:: Standardize SQL

* [#2555](https://github.com/pgRouting/pgrouting/pull/2555) Standardize
  deprecated messages
* On new internal function: do not use named parameters and default parameters.

## pgRouting 3.5


### pgRouting 3.5.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.5.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.5.1%22)

**Documentation fixes**

Changes on the documentation to the following:

* pgr_degree
* pgr_dijkstra
* pgr_ksp
* Automatic page history links

  * using bootstrap_version 2 because 3+ does not do dropdowns

**Issue fixes**

* [#2565](https://github.com/pgRouting/pgrouting/issues/2565)
  pgr_lengauerTarjanDominatorTree triggers an assertion

**SQL enhancements**

* [#2561](https://github.com/pgRouting/pgrouting/issues/2561) Not use
  wildcards on SQL

**pgtap tests**

* [#2559](https://github.com/pgRouting/pgrouting/issues/2559) pgtap test using sampledata

**Build fixes**

* Fix winnie build

**Code fixes**

* Fix clang warnings

  * Grouping headers of postgres readers

### pgRouting 3.5.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.5.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.5.0%22)

**Official functions changes**

* Dijkstra

  * Standardize output columns to ``(seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost)``

    * pgr_dijkstra(One to One) added ``start_vid`` and ``end_vid`` columns.
    * pgr_dijkstra(One to Many) added ``end_vid`` column.
    * pgr_dijkstra(Many to One) added ``start_vid`` column.

## pgRouting 3.4


### pgRouting 3.4.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.4.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.4.2%22)

**Issue fixes**

* [#2394](https://github.com/pgRouting/pgrouting/issues/2394):
  pgr_bdAstar accumulates heuristic cost in visited node cost.
* [#2427](https://github.com/pgRouting/pgrouting/issues/2427):
  pgr_createVerticesTable & pgr_createTopology, variable should be of type Record.

### pgRouting 3.4.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.4.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.4.1%22)

**Issue fixes**

* [#2401](https://github.com/pgRouting/pgrouting/issues/2401):
  pgRouting 3.4.0 do not build docs when sphinx is too low or missing
* [#2398](https://github.com/pgRouting/pgrouting/issues/2398):
  v3.4.0 does not upgrade from 3.3.3

### pgRouting 3.4.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.4.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.4.0%22)

**Issue fixes**

* [#1891](https://github.com/pgRouting/pgrouting/issues/1891):
  pgr_ksp doesn't give all correct shortest path

**New proposed functions.**

* With points

  * pgr_withPointsVia(One Via)

* Turn Restrictions

  * Via with turn restrictions

    * pgr_trspVia(One Via)
    * pgr_trspVia_withPoints(One Via)

  * pgr_trsp

    * pgr_trsp(One to One)
    * pgr_trsp(One to Many)
    * pgr_trsp(Many to One)
    * pgr_trsp(Many to Many)
    * pgr_trsp(Combinations)

  * ``pgr_trsp_withPoints``

    * pgr_trsp_withPoints(One to One)
    * pgr_trsp_withPoints(One to Many)
    * pgr_trsp_withPoints(Many to One)
    * pgr_trsp_withPoints(Many to Many)
    * pgr_trsp_withPoints(Combinations)

* Topology

  * pgr_degree

* Utilities

  * pgr_findCloseEdges(One point)
  * pgr_findCloseEdges(Many points)

**New experimental functions**

* Ordering

  * pgr_cuthillMckeeOrdering

* Unclassified

  * pgr_hawickCircuits

**Official functions changes**

* Flow functions

  * pgr_maxCardinalityMatch(text)

    * Deprecating: pgr_maxCardinalityMatch(text,boolean)

**Deprecated Functions**

* Turn Restrictions

  * pgr_trsp(text,integer,integer,boolean,boolean,text)
  * pgr_trsp(text,integer,float8,integer,float8,boolean,boolean,text)
  * pgr_trspViaVertices(text,anyarray,boolean,boolean,text)
  * pgr_trspViaEdges(text,integer[],float[],boolean,boolean,text)

## pgRouting 3.3


### pgRouting 3.3.5 Release Notes

* [#2401](https://github.com/pgRouting/pgrouting/issues/2401):
  pgRouting 3.4.0 do not build docs when sphinx is too low or missing

### pgRouting 3.3.4 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.3.4
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.3.4%22)

**Issue fixes**

* [#2400](https://github.com/pgRouting/pgrouting/issues/2400):
  pgRouting 3.3.3 does not build in focal

### pgRouting 3.3.3 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.3.3
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.3.3%22)

**Issue fixes**

* [#1891](https://github.com/pgRouting/pgrouting/issues/1891):
  pgr_ksp doesn't give all correct shortest path

**Official functions changes**

* Flow functions

  * pgr_maxCardinalityMatch(text,boolean)

    * Ignoring optional boolean parameter, as the algorithm works only for
      undirected graphs.


### pgRouting 3.3.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.3.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.3.2%22)

* Revised documentation

  * Simplifying table names and table columns, for example:

    * ``edges`` instead of ``edge_table``

      * Removing unused columns ``category_id`` and ``reverse_category_id``.

    * ``combinations`` instead of ``combinations_table``

     * Using PostGIS standard for geometry column.

       * ``geom`` instead of ``the_geom``

  * Avoiding usage of functions that modify indexes, columns etc on tables.

    * Using ``pgr_extractVertices`` to create a routing topology

  * Restructure of the pgRouting concepts page.


**Issue fixes**

* [#2276](https://github.com/pgRouting/pgrouting/issues/2276):
  edgeDisjointPaths issues with start_vid and combinations
* [#2312](https://github.com/pgRouting/pgrouting/issues/2312):
  pgr_extractVertices error when target is not BIGINT
* [#2357](https://github.com/pgRouting/pgrouting/issues/2357):
  Apply clang-tidy performance-*

### pgRouting 3.3.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.3.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.3.1%22)
on Github.

**Issue fixes**

* [#2216](https://github.com/pgRouting/pgrouting/issues/2216): Warnings when using clang
* [#2266](https://github.com/pgRouting/pgrouting/issues/2266): Error processing restrictions


### pgRouting 3.3.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.3.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.3.0%22)
on Github.

**Issue fixes**

* [#2057](https://github.com/pgRouting/pgrouting/issues/2057): trspViaEdges columns in different order
* [#2087](https://github.com/pgRouting/pgrouting/issues/2087): pgr_extractVertices to proposed
* [#2201](https://github.com/pgRouting/pgrouting/issues/2201): pgr_depthFirstSearch to proposed
* [#2202](https://github.com/pgRouting/pgrouting/issues/2202): pgr_sequentialVertexColoring to proposed
* [#2203](https://github.com/pgRouting/pgrouting/issues/2203): pgr_dijkstraNear and pgr_dijkstraNearCost to proposed

**New experimental functions**

* Coloring

  * pgr_edgeColoring

**Experimental promoted to Proposed**

* Dijkstra

  * pgr_dijkstraNear

    * pgr_dijkstraNear(Combinations)
    * pgr_dijkstraNear(Many to Many)
    * pgr_dijkstraNear(Many to One)
    * pgr_dijkstraNear(One to Many)

  * pgr_dijkstraNearCost

    * pgr_dijkstraNearCost(Combinations)
    * pgr_dijkstraNearCost(Many to Many)
    * pgr_dijkstraNearCost(Many to One)
    * pgr_dijkstraNearCost(One to Many)

* Coloring

  * pgr_sequentialVertexColoring

* Topology

  * pgr_extractVertices

* Traversal

  * pgr_depthFirstSearch(Multiple vertices)
  * pgr_depthFirstSearch(Single vertex)

## pgRouting 3.2


### pgRouting 3.2.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.2.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.2.2%22)
on Github.

**Issue fixes**

* [#2093](https://github.com/pgRouting/pgrouting/issues/2093): Compilation on Visual Studio
* [#2189](https://github.com/pgRouting/pgrouting/issues/2189): Build error on RHEL 7

### pgRouting 3.2.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.2.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.2.1%22)
on Github.

**Issue fixes**

* [#1883](https://github.com/pgRouting/pgrouting/issues/1883): pgr_TSPEuclidean crashes connection on Windows

  * The solution is to use Boost::graph::metric_tsp_approx
  * To not break user's code the optional parameters related to the TSP Annaeling are ignored
  * The function with the annaeling optional parameters is deprecated


### pgRouting 3.2.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.2.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.2.0%22)
on Github.

**Build**

* [#1850](https://github.com/pgRouting/pgrouting/issues/1850): Change Boost
  min version to 1.56

  * Removing support for Boost v1.53, v1.54 & v1.55

**New experimental functions**

* pgr_bellmanFord(Combinations)
* pgr_binaryBreadthFirstSearch(Combinations)
* pgr_bipartite
* pgr_dagShortestPath(Combinations)
* pgr_depthFirstSearch
* Dijkstra Near

  * pgr_dijkstraNear

    * pgr_dijkstraNear(One to Many)
    * pgr_dijkstraNear(Many to One)
    * pgr_dijkstraNear(Many to Many)
    * pgr_dijkstraNear(Combinations)

  * pgr_dijkstraNearCost

    * pgr_dijkstraNearCost(One to Many)
    * pgr_dijkstraNearCost(Many to One)
    * pgr_dijkstraNearCost(Many to Many)
    * pgr_dijkstraNearCost(Combinations)

* pgr_edwardMoore(Combinations)
* pgr_isPlanar
* pgr_lengauerTarjanDominatorTree
* pgr_makeConnected
* Flow

  * pgr_maxFlowMinCost(Combinations)
  * pgr_maxFlowMinCost_Cost(Combinations)

* pgr_sequentialVertexColoring

**New proposed functions.**

* Astar

  * pgr_aStar(Combinations)
  * pgr_aStarCost(Combinations)

* Bidirectional Astar

  * pgr_bdAstar(Combinations)
  * pgr_bdAstarCost(Combinations)

* Bidirectional Dijkstra

  * pgr_bdDijkstra(Combinations)
  * pgr_bdDijkstraCost(Combinations)

* Flow

  * pgr_boykovKolmogorov(Combinations)
  * pgr_edgeDisjointPaths(Combinations)
  * pgr_edmondsKarp(Combinations)
  * pgr_maxFlow(Combinations)
  * pgr_pushRelabel(Combinations)

* pgr_withPoints(Combinations)
* pgr_withPointsCost(Combinations)

## pgRouting 3.1


### pgRouting 3.1.4 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.1.4
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.1.4%22)
on Github.

**Issues fixes**

* [#2189](https://github.com/pgRouting/pgrouting/issues/2189): Build error on
  RHEL 7


### pgRouting 3.1.3 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.1.3
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.1.3%22)
on Github.

**Issues fixes**

* [#1825](https://github.com/pgRouting/pgrouting/issues/1825): Boost versions
  are not honored
* [#1849](https://github.com/pgRouting/pgrouting/issues/1849): Boost 1.75.0
  geometry "point_xy.hpp" build error on macOS environment
* [#1861](https://github.com/pgRouting/pgrouting/issues/1861): vrp functions
  crash server


### pgRouting 3.1.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.1.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.1.2%22)
on Github.

**Issues fixes**

* [#1304](https://github.com/pgRouting/pgrouting/issues/1304): FreeBSD 12
  64-bit crashes on pgr_vrOneDepot tests Experimental Function
* [#1356](https://github.com/pgRouting/pgrouting/issues/1356):
  tools/testers/pg_prove_tests.sh fails when PostgreSQL port is not passed
* [#1725](https://github.com/pgRouting/pgrouting/issues/1725): Server crash
  on pgr_pickDeliver and pgr_vrpOneDepot on openbsd
* [#1760](https://github.com/pgRouting/pgrouting/issues/1760): TSP server
  crash on ubuntu 20.04 #1760
* [#1770](https://github.com/pgRouting/pgrouting/issues/1770): Remove
  warnings when using clang compiler


### pgRouting 3.1.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.1.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.1.1%22)
on Github.

**Issues fixes**

* [#1733](https://github.com/pgRouting/pgrouting/issues/1733): pgr_bdAstar
  fails when source or target vertex does not exist in the graph
* [#1647](https://github.com/pgRouting/pgrouting/issues/1647): Linear
  Contraction contracts self loops
* [#1640](https://github.com/pgRouting/pgrouting/issues/1640): pgr_withPoints
  fails when points_sql is empty
* [#1616](https://github.com/pgRouting/pgrouting/issues/1616): Path
  evaluation on C++ not updated before the results go back to C
* [#1300](https://github.com/pgRouting/pgrouting/issues/1300):
  pgr_chinesePostman crash on test data



### pgRouting 3.1.0 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.1.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.1.0%22)
on Github.

**New proposed functions.**

* pgr_dijkstra(combinations)
* pgr_dijkstraCost(combinations)

**Build changes**

* Minimal requirement for Sphinx: version 1.8

## pgRouting 3.0


### pgRouting 3.0.6 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.0.6
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.0.6%22)
on Github.

**Issues fixes**

* [#2189](https://github.com/pgRouting/pgrouting/issues/2189): Build error on
  RHEL 7


### pgRouting 3.0.5 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.0.5
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.0.5%22)
on Github.

**Backport issue fixes**

* [#1825](https://github.com/pgRouting/pgrouting/issues/1825): Boost versions
  are not honored
* [#1849](https://github.com/pgRouting/pgrouting/issues/1849): Boost 1.75.0
  geometry "point_xy.hpp" build error on macOS environment
* [#1861](https://github.com/pgRouting/pgrouting/issues/1861): vrp functions
  crash server


### pgRouting 3.0.4 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.0.4
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.0.4%22)
on Github.

**Backport issue fixes**

* [#1304](https://github.com/pgRouting/pgrouting/issues/1304): FreeBSD 12
  64-bit crashes on pgr_vrOneDepot tests Experimental Function
* [#1356](https://github.com/pgRouting/pgrouting/issues/1356):
  tools/testers/pg_prove_tests.sh fails when PostgreSQL port is not passed
* [#1725](https://github.com/pgRouting/pgrouting/issues/1725): Server crash
  on pgr_pickDeliver and pgr_vrpOneDepot on openbsd
* [#1760](https://github.com/pgRouting/pgrouting/issues/1760): TSP server
  crash on ubuntu 20.04 #1760
* [#1770](https://github.com/pgRouting/pgrouting/issues/1770): Remove
  warnings when using clang compiler



### pgRouting 3.0.3 Release Notes

**Backport issue fixes**

* [#1733](https://github.com/pgRouting/pgrouting/issues/1733): pgr_bdAstar
  fails when source or target vertex does not exist in the graph
* [#1647](https://github.com/pgRouting/pgrouting/issues/1647): Linear
  Contraction contracts self loops
* [#1640](https://github.com/pgRouting/pgrouting/issues/1640): pgr_withPoints
  fails when points_sql is empty
* [#1616](https://github.com/pgRouting/pgrouting/issues/1616): Path
  evaluation on C++ not updated before the results go back to C
* [#1300](https://github.com/pgRouting/pgrouting/issues/1300):
  pgr_chinesePostman crash on test data



### pgRouting 3.0.2 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.0.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.0.2%22)
on Github.

**Issues fixes**

* [#1378](https://github.com/pgRouting/pgrouting/issues/1378): Visual Studio
  build failing


### pgRouting 3.0.1 Release Notes

To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.0.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.0.1%22)
on Github.

**Issues fixes**

* [#232](https://github.com/pgRouting/pgrouting/issues/232): Honor client
  cancel requests in C /C++ code


### pgRouting 3.0.0 Release Notes


To see all issues & pull requests closed by this release see the [Git closed
milestone for 3.0.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%203.0.0%22)
on Github.

**Fixed Issues**

* [#1153](https://github.com/pgRouting/pgrouting/issues/1153): Renamed
  pgr_eucledianTSP to pgr_TSPeuclidean
* [#1188](https://github.com/pgRouting/pgrouting/issues/1188): Removed CGAL
  dependency
* [#1002](https://github.com/pgRouting/pgrouting/issues/1002): Fixed
  contraction issues:

  * [#1004](https://github.com/pgRouting/pgrouting/issues/1004): Contracts
    when forbidden vertices do not belong to graph
  * [#1005](https://github.com/pgRouting/pgrouting/issues/1005): Intermideate
    results eliminated
  * [#1006](https://github.com/pgRouting/pgrouting/issues/1006): No loss of
    information

**New Functions**

* Kruskal family

  * pgr_kruskal
  * pgr_kruskalBFS
  * pgr_kruskalDD
  * pgr_kruskalDFS

* Prim family

  * pgr_prim
  * pgr_primDD
  * pgr_primDFS
  * pgr_primBFS


**Proposed moved to official on pgRouting**

* aStar Family

  * pgr_aStar(One to Many)
  * pgr_aStar(Many to One)
  * pgr_aStar(Many to Many)
  * pgr_aStarCost(One to One)
  * pgr_aStarCost(One to Many)
  * pgr_aStarCost(Many to One)
  * pgr_aStarCost(Many to Many)
  * pgr_aStarCostMatrix

* bdAstar Family

  * pgr_bdAstar(One to Many)
  * pgr_bdAstar(Many to One)
  * pgr_bdAstar(Many to Many)
  * pgr_bdAstarCost(One to One)
  * pgr_bdAstarCost(One to Many)
  * pgr_bdAstarCost(Many to One)
  * pgr_bdAstarCost(Many to Many)
  * pgr_bdAstarCostMatrix

* bdDijkstra Family

  * pgr_bdDijkstra(One to Many)
  * pgr_bdDijkstra(Many to One)
  * pgr_bdDijkstra(Many to Many)
  * pgr_bdDijkstraCost(One to One)
  * pgr_bdDijkstraCost(One to Many)
  * pgr_bdDijkstraCost(Many to One)
  * pgr_bdDijkstraCost(Many to Many)
  * pgr_bdDijkstraCostMatrix

* Flow Family

  * pgr_pushRelabel(One to One)
  * pgr_pushRelabel(One to Many)
  * pgr_pushRelabel(Many to One)
  * pgr_pushRelabel(Many to Many)
  * pgr_edmondsKarp(One to One)
  * pgr_edmondsKarp(One to Many)
  * pgr_edmondsKarp(Many to One)
  * pgr_edmondsKarp(Many to Many)
  * pgr_boykovKolmogorov (One to One)
  * pgr_boykovKolmogorov (One to Many)
  * pgr_boykovKolmogorov (Many to One)
  * pgr_boykovKolmogorov (Many to Many)
  * pgr_maxCardinalityMatching
  * pgr_maxFlow
  * pgr_edgeDisjointPaths(One to One)
  * pgr_edgeDisjointPaths(One to Many)
  * pgr_edgeDisjointPaths(Many to One)
  * pgr_edgeDisjointPaths(Many to Many)

* Components family

  * pgr_connectedComponents
  * pgr_strongComponents
  * pgr_biconnectedComponents
  * pgr_articulationPoints
  * pgr_bridges

* Contraction:

  * Removed unnecessary column seq
  * Bug Fixes


**New experimental functions**

* pgr_maxFlowMinCost
* pgr_maxFlowMinCost_Cost
* pgr_extractVertices
* pgr_turnRestrictedPath
* pgr_stoerWagner
* pgr_dagShortestpath
* pgr_topologicalSort
* pgr_transitiveClosure
* VRP category

  * pgr_pickDeliverEuclidean
  * pgr_pickDeliver

* Chinese Postman family

  * pgr_chinesePostman
  * pgr_chinesePostmanCost

* Breadth First Search family

  * pgr_breadthFirstSearch
  * pgr_binaryBreadthFirstSearch

* Bellman Ford family

  * pgr_bellmanFord
  * pgr_edwardMoore

**Moved to legacy**

* Experimental functions

  * pgr_labelGraph - Use the components family of functions instead.
  * Max flow - functions were renamed on v2.5.0

    * pgr_maxFlowPushRelabel
    * pgr_maxFlowBoykovKolmogorov
    * pgr_maxFlowEdmondsKarp
    * pgr_maximumcardinalitymatching

  * VRP

    * pgr_gsoc_vrppdtw

* TSP old signatures
* pgr_pointsAsPolygon
* pgr_alphaShape old signature

# pgRouting 2


## pgRouting 2.6


### pgRouting 2.6.3 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.6.3
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.6.3%22%20)
on Github.

**Bug fixes**

* [#1219](https://github.com/pgRouting/pgrouting/pull/1219) Implicit cast for
  via_path integer to text
* [#1193](https://github.com/pgRouting/pgrouting/pull/1193) Fixed
  pgr_pointsAsPolygon breaking when comparing strings in WHERE clause
* [#1185](https://github.com/pgRouting/pgrouting/pull/1185) Improve
  FindPostgreSQL.cmake



### pgRouting 2.6.2 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.6.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.6.2%22%20)
on Github.

**Bug fixes**

* [#1152](https://github.com/pgRouting/pgrouting/issues/1152) Fixes driving
  distance when vertex is not part of the graph
* [#1098](https://github.com/pgRouting/pgrouting/issues/1098) Fixes windows
  test
* [#1165](https://github.com/pgRouting/pgrouting/issues/1165) Fixes build for
  python3 and perl5


### pgRouting 2.6.1 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.6.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.6.1%22%20)
on Github.

* Fixes server crash on several functions.

  * pgr_floydWarshall
  * pgr_johnson
  * pgr_aStar
  * pgr_bdAstar
  * pgr_bdDijstra
  * pgr_alphashape
  * pgr_dijkstraCostMatrix
  * pgr_dijkstra
  * pgr_dijkstraCost
  * pgr_drivingDistance
  * pgr_KSP
  * pgr_dijkstraVia (proposed)
  * pgr_boykovKolmogorov (proposed)
  * pgr_edgeDisjointPaths (proposed)
  * pgr_edmondsKarp (proposed)
  * pgr_maxCardinalityMatch (proposed)
  * pgr_maxFlow (proposed)
  * pgr_withPoints (proposed)
  * pgr_withPointsCost (proposed)
  * pgr_withPointsKSP (proposed)
  * pgr_withPointsDD (proposed)
  * pgr_withPointsCostMatrix (proposed)
  * pgr_contractGraph (experimental)
  * pgr_pushRelabel (experimental)
  * pgr_vrpOneDepot (experimental)
  * pgr_gsoc_vrppdtw (experimental)
  * Fixes for deprecated functions where also applied but not tested

* Removed compilation warning for g++8
* Fixed a fallthrugh on Astar and bdAstar.


### pgRouting 2.6.0 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.6.0
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.6.0%22%20)
on Github.


**New experimental functions**

* pgr_lineGraphFull

**Bug fixes**

* Fix pgr_trsp(text,integer,double precision,integer,double
  precision,boolean,boolean[,text])

  * without restrictions

    * calls pgr_dijkstra when both end points have a fraction IN (0,1)
    * calls pgr_withPoints when at least one fraction NOT IN (0,1)

  * with restrictions

    * calls original trsp code

**Internal code**

* Cleaned the internal code of trsp(text,integer,integer,boolean,boolean [,
  text])

  * Removed the use of pointers
  * Internal code can accept BIGINT

* Cleaned the internal code of withPoints

## pgRouting 2.5


### pgRouting 2.5.5 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.5.5
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.5.5%22%20)
on Github.

**Bug fixes**

* Fixes driving distance when vertex is not part of the graph
* Fixes windows test
* Fixes build for python3 and perl5


### pgRouting 2.5.4 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.5.4
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.5.4%22%20)
on Github.

* Fixes server crash on several functions.

  * pgr_floydWarshall
  * pgr_johnson
  * pgr_aStar
  * pgr_bdAstar
  * pgr_bdDijstra
  * pgr_alphashape
  * pgr_dijkstraCostMatrix
  * pgr_dijkstra
  * pgr_dijkstraCost
  * pgr_drivingDistance
  * pgr_KSP
  * pgr_dijkstraVia (proposed)
  * pgr_boykovKolmogorov (proposed)
  * pgr_edgeDisjointPaths (proposed)
  * pgr_edmondsKarp (proposed)
  * pgr_maxCardinalityMatch (proposed)
  * pgr_maxFlow (proposed)
  * pgr_withPoints (proposed)
  * pgr_withPointsCost (proposed)
  * pgr_withPointsKSP (proposed)
  * pgr_withPointsDD (proposed)
  * pgr_withPointsCostMatrix (proposed)
  * pgr_contractGraph (experimental)
  * pgr_pushRelabel (experimental)
  * pgr_vrpOneDepot (experimental)
  * pgr_gsoc_vrppdtw (experimental)
  * Fixes for deprecated functions where also applied but not tested

* Removed compilation warning for g++8
* Fixed a fallthrugh on Astar and bdAstar.


### pgRouting 2.5.3 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.5.3
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.5.3%22%20)
on Github.

**Bug fixes**

* Fix for postgresql 11: Removed a compilation error when compiling with
  postgreSQL


### pgRouting 2.5.2 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.5.2](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.5.2%22%20) on Github.

**Bug fixes**

* Fix for postgresql 10.1: Removed a compiler condition



### pgRouting 2.5.1 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.5.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.5.1%22%20)
on Github.

**Bug fixes**

* Fixed prerequisite minimum version of: cmake



### pgRouting 2.5.0 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.5.0
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.5.0%22+is%3Aclosed)
on Github.


**enhancement:**

* pgr_version is now on SQL language

**Breaking change on:**

* pgr_edgeDisjointPaths:

  * Added path_id, cost and agg_cost columns on the result
  * Parameter names changed
  * The many version results are the union of the One to One version

**New Signatures**

* pgr_bdAstar(One to One)

**New proposed functions.**

* pgr_bdAstar(One to Many)
* pgr_bdAstar(Many to One)
* pgr_bdAstar(Many to Many)
* pgr_bdAstarCost(One to One)
* pgr_bdAstarCost(One to Many)
* pgr_bdAstarCost(Many to One)
* pgr_bdAstarCost(Many to Many)
* pgr_bdAstarCostMatrix
* pgr_bdDijkstra(One to Many)
* pgr_bdDijkstra(Many to One)
* pgr_bdDijkstra(Many to Many)
* pgr_bdDijkstraCost(One to One)
* pgr_bdDijkstraCost(One to Many)
* pgr_bdDijkstraCost(Many to One)
* pgr_bdDijkstraCost(Many to Many)
* pgr_bdDijkstraCostMatrix
* pgr_lineGraph
* pgr_lineGraphFull
* pgr_connectedComponents
* pgr_strongComponents
* pgr_biconnectedComponents
* pgr_articulationPoints
* pgr_bridges

**Deprecated signatures**

* pgr_bdastar - use pgr_bdAstar instead

**Renamed functions**

* pgr_maxFlowPushRelabel - use pgr_pushRelabel instead
* pgr_maxFlowEdmondsKarp -use pgr_edmondsKarp instead
* pgr_maxFlowBoykovKolmogorov - use pgr_boykovKolmogorov instead
* pgr_maximumCardinalityMatching - use pgr_maxCardinalityMatch instead

**Deprecated Function**

* pgr_pointToEdgeNode


## pgRouting 2.4


### pgRouting 2.4.2 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.4.2
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.4.2%22%20)
on Github.

**Improvement**

* Works for postgreSQL 10

**Bug fixes**

* Fixed: Unexpected error column "cname"
* Replace __linux__ with __GLIBC__ for glibc-specific headers and functions




### pgRouting 2.4.1 Release Notes

To see the issues closed by this release see the [Git closed milestone for 2.4.1
](https://github.com/pgRouting/pgrouting/issues?utf8=%E2%9C%93&q=milestone%3A%22Release%202.4.1%22%20)
on Github.

**Bug fixes**

* Fixed compiling error on macOS
* Condition error on pgr_withPoints


### pgRouting 2.4.0 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.4.0
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.4.0%22+is%3Aclosed)
on Github.

**New Functions**

* pgr_bdDijkstra


**New proposed signatures:**

* pgr_maxFlow
* pgr_aStar(One to Many)
* pgr_aStar(Many to One)
* pgr_aStar(Many to Many)
* pgr_aStarCost(One to One)
* pgr_aStarCost(One to Many)
* pgr_aStarCost(Many to One)
* pgr_aStarCost(Many to Many)
* pgr_aStarCostMatrix

**Deprecated signatures.**

* pgr_bddijkstra - use pgr_bdDijkstra instead

**Deprecated Functions**

* pgr_pointsToVids

**Bug fixes**

* Bug fixes on proposed functions

  * pgr_withPointsKSP: fixed ordering

* TRSP original code is used with no changes on the compilation warnings

## pgRouting 2.3

### pgRouting 2.3.2 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.3.2
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.3.2%22+is%3Aclosed)
on Github.

**Bug Fixes**

* Fixed pgr_gsoc_vrppdtw crash when all orders fit on one truck.
* Fixed pgr_trsp:

  * Alternate code is not executed when the point is in reality a vertex
  * Fixed ambiguity on seq



### pgRouting 2.3.1 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.3.1
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.3.1%22+is%3Aclosed)
on Github.

**Bug Fixes**

* Leaks on proposed max_flow functions
* Regression error on pgr_trsp
* Types discrepancy on pgr_createVerticesTable



### pgRouting 2.3.0 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.3.0
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.3.0%22+is%3Aclosed)
on Github.

**New Signatures**

* pgr_TSP
* pgr_aStar

**New Functions**

* pgr_eucledianTSP


**New proposed functions.**

* pgr_dijkstraCostMatrix
* pgr_withPointsCostMatrix
* pgr_maxFlowPushRelabel(One to One)
* pgr_maxFlowPushRelabel(One to Many)
* pgr_maxFlowPushRelabel(Many to One)
* pgr_maxFlowPushRelabel(Many to Many)
* pgr_maxFlowEdmondsKarp(One to One)
* pgr_maxFlowEdmondsKarp(One to Many)
* pgr_maxFlowEdmondsKarp(Many to One)
* pgr_maxFlowEdmondsKarp(Many to Many)
* pgr_maxFlowBoykovKolmogorov (One to One)
* pgr_maxFlowBoykovKolmogorov (One to Many)
* pgr_maxFlowBoykovKolmogorov (Many to One)
* pgr_maxFlowBoykovKolmogorov (Many to Many)
* pgr_maximumCardinalityMatching
* pgr_edgeDisjointPaths(One to One)
* pgr_edgeDisjointPaths(One to Many)
* pgr_edgeDisjointPaths(Many to One)
* pgr_edgeDisjointPaths(Many to Many)
* pgr_contractGraph


**Deprecated signatures**

* pgr_tsp - use pgr_TSP or pgr_eucledianTSP instead
* pgr_aStar - use pgr_aStar instead


**Deprecated Functions**

* pgr_flip_edges
* pgr_vidsToDmatrix
* pgr_pointsToDMatrix
* pgr_textToPoints

## pgRouting 2.2


### pgRouting 2.2.4 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.2.4
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.2.4%22+is%3Aclosed)
on Github.

**Bug Fixes**

* Bogus uses of extern "C"
* Build error on Fedora 24 + GCC 6.0
* Regression error pgr_nodeNetwork


### pgRouting 2.2.3 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.2.3
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.2.3%22+is%3Aclosed)
on Github.

**Bug Fixes**

* Fixed compatibility issues with PostgreSQL 9.6.


### pgRouting 2.2.2 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.2.2
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.2.2%22+is%3Aclosed)
on Github.

**Bug Fixes**

* Fixed regression error on pgr_drivingDistance



### pgRouting 2.2.1 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.2.1
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A2.2.1+is%3Aclosed)
on Github.

**Bug Fixes**

* Server crash fix on pgr_alphaShape
* Bug fix on With Points family of functions



### pgRouting 2.2.0 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.2.0
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.2.0%22+is%3Aclosed)
on Github.


**Improvements**

- pgr_nodeNetwork

  - Adding a row_where and outall optional parameters

- Signature fix

  - pgr_dijkstra -- to match what is documented


**New Functions**

- pgr_floydWarshall
- pgr_Johnson
- pgr_dijkstraCost(One to One)
- pgr_dijkstraCost(One to Many)
- pgr_dijkstraCost(Many to One)
- pgr_dijkstraCost(Many to Many)

**Proposed Functionality**

- pgr_withPoints(One to One)
- pgr_withPoints(One to Many)
- pgr_withPoints(Many to One)
- pgr_withPoints(Many to Many)
- pgr_withPointsCost(One to One)
- pgr_withPointsCost(One to Many)
- pgr_withPointsCost(Many to One)
- pgr_withPointsCost(Many to Many)
- pgr_withPointsDD(single vertex)
- pgr_withPointsDD(multiple vertices)
- pgr_withPointsKSP
- pgr_dijkstraVia


**Deprecated Functions**

- pgr_apspWarshall use pgr_floydWarshall instead
- pgr_apspJohnson use pgr_Johnson instead
- pgr_kDijkstraCost use pgr_dijkstraCost instead
- pgr_kDijkstraPath use pgr_dijkstra instead

**Renamed and Deprecated Function**

- pgr_makeDistanceMatrix renamed to _pgr_makeDistanceMatrix

## pgRouting 2.1


### pgRouting 2.1.0 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.1.0
](https://github.com/pgRouting/pgrouting/issues?q=is%3Aissue+milestone%3A%22Release+2.1.0%22+is%3Aclosed)
on Github.

**New Signatures**

- pgr_dijkstra(One to Many)
- pgr_dijkstra(Many to One)
- pgr_dijkstra(Many to Many)
- pgr_drivingDistance(multiple vertices)

**Refactored**

- pgr_dijkstra(One to One)
- pgr_ksp
- pgr_drivingDistance(single vertex)

**Improvements**

- pgr_alphaShape function now can generate better (multi)polygon with holes and
  alpha parameter.

**Proposed Functionality**

- Proposed functions from Steve Woodbridge, (Classified as Convenience by the
  author.)

  - pgr_pointToEdgeNode - convert a point geometry to a vertex_id based on
    closest edge.
  - pgr_flipEdges - flip the edges in an array of geometries so the connect end
    to end.
  - pgr_textToPoints - convert a string of x,y;x,y;... locations into point
    geometries.
  - pgr_pointsToVids - convert an array of point geometries into vertex ids.
  - pgr_pointsToDMatrix - Create a distance matrix from an array of points.
  - pgr_vidsToDMatrix - Create a distance matrix from an array of vertix_id.
  - pgr_vidsToDMatrix - Create a distance matrix from an array of vertix_id.

- Added proposed functions from GSoc Projects:

  - pgr_vrppdtw
  - pgr_vrponedepot

**Deprecated Functions**

- pgr_getColumnName
- pgr_getTableName
- pgr_isColumnCndexed
- pgr_isColumnInTable
- pgr_quote_ident
- pgr_versionless
- pgr_startPoint
- pgr_endPoint
- pgr_pointToId

**No longer supported**

- Removed the 1.x legacy functions

**Bug Fixes**

- Some bug fixes in other functions


**Refactoring Internal Code**

- A C and C++ library for developer was created

  - encapsulates postgreSQL related functions
  - encapsulates Boost.Graph graphs

    - Directed Boost.Graph
    - Undirected Boost.graph.

  - allow any-integer in the id's
  - allow any-numerical on the cost/reverse_cost columns

- Instead of generating many libraries:
  - All functions are encapsulated in one library
  - The library has the prefix 2-1-0


## pgRouting 2.0


### pgRouting 2.0.1 Release Notes

Minor bug fixes.

**Bug Fixes**

* No track of the bug fixes were kept.

### pgRouting 2.0.0 Release Notes

To see the issues closed by this release see the [Git closed issues for 2.0.0
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+2.0.0%22+is%3Aclosed)
on Github.

With the release of pgRouting 2.0.0 the library has abandoned backwards
compatibility to `pgRouting 1.0`_ releases.
The main Goals for this release are:

* Major restructuring of pgRouting.
* Standardization of the function naming
* Preparation of the project for future development.

As a result of this effort:

* pgRouting has a simplified structure
* Significant new functionality has being added
* Documentation has being integrated
* Testing has being integrated
* And made it easier for multiple developers to make contributions.


**Important Changes**

* Graph Analytics - tools for detecting and fixing connection some problems in a
  graph
* A collection of useful utility functions
* Two new All Pairs Short Path algorithms (pgr_apspJohnson, pgr_apspWarshall)
* Bi-directional Dijkstra and A-star search algorithms (pgr_bdAstar,
  pgr_bdDijkstra)
* One to many nodes search (pgr_kDijkstra)
* K alternate paths shortest path (pgr_ksp)
* New TSP solver that simplifies the code and the build process (pgr_tsp),
  dropped "Gaul Library" dependency
* Turn Restricted shortest path (pgr_trsp) that replaces Shooting Star
* Dropped support for Shooting Star
* Built a test infrastructure that is run before major code changes are checked
  in
* Tested and fixed most all of the outstanding bugs reported against 1.x that
  existing in the 2.0-dev code base.
* Improved build process for Windows
* Automated testing on Linux and Windows platforms trigger by every commit
* Modular library design
* Compatibility with PostgreSQL 9.1 or newer
* Compatibility with PostGIS 2.0 or newer
* Installs as PostgreSQL EXTENSION
* Return types re factored and unified
* Support for table SCHEMA in function parameters
* Support for ``st_`` PostGIS function prefix
* Added ``pgr_`` prefix to functions and types
* Better documentation: https://docs.pgrouting.org
* shooting_star is discontinued

# pgRouting 1

## pgRouting 1.0


To see the issues closed by this release see the [Git closed issues for 1.x
](https://github.com/pgRouting/pgrouting/issues?q=milestone%3A%22Release+1.x%22+is%3Aclosed)
on Github.
The following release notes have been copied from the previous ``RELEASE_NOTES``
file and are kept as a reference.


Changes for release 1.05

* Bug fixes


Changes for release 1.03

* Much faster topology creation
* Bug fixes


Changes for release 1.02

* Shooting* bug fixes
* Compilation problems solved

Changes for release 1.01

* Shooting* bug fixes


Changes for release 1.0

* Core and extra functions are separated
* Cmake build process
* Bug fixes


Changes for release 1.0.0b

* Additional SQL file with more simple names for wrapper functions
* Bug fixes


Changes for release 1.0.0a

* Shooting* shortest path algorithm for real road networks
* Several SQL bugs were fixed


Changes for release 0.9.9

* PostgreSQL 8.2 support
* Shortest path functions return empty result if they could not find any path


Changes for release 0.9.8

* Renumbering scheme was added to shortest path functions
* Directed shortest path functions were added
* routing_postgis.sql was modified to use dijkstra in TSP search
