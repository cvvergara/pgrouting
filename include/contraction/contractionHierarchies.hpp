/*PGR-GNU*****************************************************************
File: contractionhierarchies.hpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) Aurélie Bousquet - 2024
Mail: aurelie.bousquet at oslandia.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

#ifndef INCLUDE_CONTRACTION_CONTRACTIONHIERARCHIES_HPP_
#define INCLUDE_CONTRACTION_CONTRACTIONHIERARCHIES_HPP_
#pragma once


#include <queue>
#include <functional>
#include <vector>
#include <limits>
#include <set>
#include <string>
#include <utility>

#include <boost/graph/iteration_macros.hpp>
#include <boost/graph/filtered_graph.hpp>
#include <boost/graph/dijkstra_shortest_paths.hpp>

#include "cpp_common/alloc.hpp"
#include "cpp_common/messages.hpp"
#include "cpp_common/identifiers.hpp"
#include "cpp_common/interruption.hpp"

#include "c_common/e_report.h"

#include "visitors/dijkstra_visitors.hpp"

namespace pgrouting {
namespace contraction {

template < class G >
class Pgr_contractionsHierarchy : public Pgr_messages {
 private:
     using V = typename G::V;
     using E = typename G::E;
     using V_i = typename G::V_i;
     using E_i = typename G::E_i;
     using B_G = typename G::B_G;
     using PQ = typename G::PQ;

     PQ priority_queue;

 public:
     double compute_pmax(
        G &graph,
        V u,
        V v,
        Identifiers<V> out_vertices
    ) {
        double p_max;
        E e, f;
        bool found_e, found_f;

        p_max = 0;
        boost::tie(e, found_e) = boost::edge(u, v, graph.graph);

        if (found_e) {
            p_max = graph[e].cost;
            for (V w : out_vertices) {
                boost::tie(f, found_f) = boost::edge(v, w, graph.graph);
                if ((found_f) && (u != w)) {
                    if ((graph[e].cost + graph[f].cost) > p_max)
                        p_max = graph[e].cost + graph[f].cost;
                }
            }
        }
        return p_max;
    }

    /*! 
    @brief contracts vertex *v* 
    @param [in] G graph
    @param [in] v vertex_descriptor
    @param [in] log log output
    @param [in] err err output
    @return contraction metric: the node-contraction associated metrics
    */
    int64_t process_vertex_contraction(
        G &graph,
        V v,
        bool simulation,
        std::vector<CH_edge> &shortcuts,
        std::ostringstream &log,
        std::ostringstream &err
    ) {
        Identifiers<V> adjacent_in_vertices =
            graph.find_adjacent_in_vertices(v);
        Identifiers<V> adjacent_out_vertices =
            graph.find_adjacent_out_vertices(v);
        int64_t n_old_edges =
            static_cast<int64_t>(adjacent_in_vertices.size()) +
            static_cast<int64_t>(adjacent_out_vertices.size());
        int64_t n_shortcuts = 0;

        log << ">> Contraction of node " << graph[v].id << std::endl
            << num_vertices(graph.graph) << " vertices and "
            << num_edges(graph.graph) << " edges " << std::endl;

        for (auto &u : adjacent_in_vertices) {
            log << "  >> from " << graph[u].id << std::endl;
            compute_shortcuts(
                graph,
                u,
                v,
                adjacent_out_vertices,
                shortcuts,
                n_shortcuts,
                simulation,
                log,
                err);
        }
        if (!simulation) {
            for (auto &w : adjacent_out_vertices)
                boost::remove_edge(v, w, graph.graph);
            for (auto &u : graph.find_adjacent_in_vertices(v))
                boost::remove_edge(u, v, graph.graph);
            graph[v].clear_contracted_vertices();

            log << "  Size of the graph after contraction: "
                << num_vertices(graph.graph)
                << " vertices and " << num_edges(graph.graph)
                << " edges" << std::endl
                << "  " << n_shortcuts
                << " shortcuts created, " << n_old_edges
                << " old edges" << std::endl;
        }
        log << "  Metric: edge difference = "
            << n_shortcuts - n_old_edges << std::endl;

        return static_cast<int64_t>(n_shortcuts - n_old_edges);
    }

    void compute_shortcuts(
        G &graph,
        V u,
        V v,
        Identifiers<V> out_vertices,
        std::vector<CH_edge> &shortcuts,
        int64_t &n_shortcuts,
        bool simulation,
        std::ostringstream &log,
        std::ostringstream &err
    ) {
        std::vector<V> predecessors(graph.num_vertices());
        std::vector<double> distances(graph.num_vertices());
        V_i out_i, out_end;

        int64_t p_max = compute_pmax(graph, u, v, out_vertices);
        log << "    p_max = " << p_max << std::endl;

        if ( p_max > 0 ) {
            // Launch of a shortest paths query from u to all nodes
            // with distance less than p_max
            std::set<int64_t> reached_vertices_ids;
            try {
              boost::dijkstra_shortest_paths(
                graph.graph,
                u,
                boost::predecessor_map(&predecessors[0])
                .weight_map(get(&G::G_T_E::cost, graph.graph))
                .distance_map(&distances[0])
                .distance_inf(std::numeric_limits<double>::infinity())
                .visitor(pgrouting::visitors::dijkstra_max_distance_visitor<V>(
                    p_max, distances, reached_vertices_ids, log)));
            }
            catch ( pgrouting::max_dist_reached & ) {
                log << "    PgRouting exception during labelling!"
                    << std::endl;
                log << "    >>> Labelling interrupted"
                    << " because max distance is reached. " << std::endl;
                log << "    >>> Number of labelled vertices: "
                    << reached_vertices_ids.size() << std::endl;
                Identifiers<int64_t> r;
                r.set_ids(reached_vertices_ids);
                log << "    >>> Reached vertices: " << r << std::endl;
            }
            catch ( boost::exception const &except ) {
                err << std::endl << "Boost exception "
                    << "during vertex contraction! "
                    << dynamic_cast<std::exception const &>(except).what()
                    << std::endl;
            }
            catch ( ... ) {
                err << "    Unknown exception during labelling!" << std::endl;
            }
            /* abort in case of an interruption occurs
            (e.g. the query is being cancelled) */
            CHECK_FOR_INTERRUPTS();

            // Create a shortcut, for each w,
            // when c(u, v) + c(u, w) = cost(shortest path from u to v)
            for (const auto &w : out_vertices) {
                E e, f, g;
                bool found_e, found_f, found_g;
                double c;
                if ( u != w ) {
                    boost::tie(e, found_e) = boost::edge(u, v, graph.graph);
                    boost::tie(f, found_f) = boost::edge(v, w, graph.graph);
                    boost::tie(g, found_g) = boost::edge(u, w, graph.graph);
                    if (found_e && found_f &&
                    (!found_g || (found_g && (distances[w] < graph[g].cost)))) {
                        c = graph[e].cost + graph[f].cost;
                        if ((predecessors[w] == v) &&
                            (predecessors[v] == u) &&
                            (distances[w] == c) &&
                            (graph.is_shortcut_possible(u, v, w))) {
                            if (!simulation) {
                                pgrouting::CH_edge ch_e =
                                    graph.process_shortcut(u, v, w);
                                log << "    Shortcut = (" << graph[u].id
                                    << ", " << graph[w].id << "), ";
                                log << "cost = " << ch_e.cost << std::endl;
                                shortcuts.push_back(ch_e);
                            }
                            n_shortcuts++;
                        }
                    }
                }
            }
        }
    }

    void do_contraction(
        G &graph,
        std::ostringstream &log,
        std::ostringstream &err
    ) {
        // First iteration over vertices
        G graph_copy = graph;
        std::vector<pgrouting::CH_edge> shortcuts;

        // Fill the priority queue with a first search
        log << "Do contraction" << std::endl;
        log << std::endl << ">>>> FIRST LABELLING" << std::endl;
        PQ minPQ;
        for (const auto &v :
            boost::make_iterator_range(boost::vertices(graph.graph))) {
            if (!(graph.getForbiddenVertices()).has(v)) {
                minPQ.push(
                    std::make_pair(
                        process_vertex_contraction(
                            graph,
                            v,
                            false,
                            shortcuts,
                            log,
                            err), v));
            }
        }
        log << std::endl << ">>>> SECOND LABELLING" << std::endl;
        shortcuts.clear();
        graph = graph_copy;

        // Second iteration: lazy heuristics
        // The graph is reinitialized
        while (!minPQ.empty()) {
            std::pair< int64_t, V > ordered_vertex = minPQ.top();
            minPQ.pop();
            int64_t corrected_metric =
                process_vertex_contraction(
                    graph_copy,
                    ordered_vertex.second,
                    true,
                    shortcuts,
                    log,
                    err);
            log << "  Vertex: " << graph[ordered_vertex.second].id
                << ", min value of the queue: "
                << minPQ.top().first << std::endl
                << "  Lazy non-destructive simulation: initial order "
                << ordered_vertex.first << ", new order "
                << corrected_metric << std::endl;

            if (minPQ.top().first < corrected_metric) {
                log << "   Vertex reinserted in the queue" << std::endl;
                minPQ.push(
                    std::make_pair(corrected_metric, ordered_vertex.second));
            } else {
                std::pair< int64_t, V > contracted_vertex;
                V u = graph_copy.vertices_map[graph[ordered_vertex.second].id];
                contracted_vertex.first = process_vertex_contraction(
                    graph_copy,
                    u,
                    false,
                    shortcuts,
                    log,
                    err);
                log << "  Vertex endly contracted in the queue" << std::endl;
                contracted_vertex.second = ordered_vertex.second;
                priority_queue.push(contracted_vertex);
            }
        }
        log << std::endl << "Copy shortcuts" << std::endl;
        graph.copy_shortcuts(shortcuts, log);
        log << std::endl << "Priority queue: " << std::endl;
        graph.set_vertices_metric_and_hierarchy(priority_queue, log);
    }
};

}  // namespace contraction
}  // namespace pgrouting

#endif  // INCLUDE_CONTRACTION_CONTRACTIONHIERARCHIES_HPP_
