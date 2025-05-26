/*PGR-GNU*****************************************************************
File: undirectedHasCostBG.cpp

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2025 Vicky Vergara
Mail: vicky at erosion.dev

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

#include "cpp_common/undirectedHasCostBG.hpp"

#include <utility>
#include <vector>
#include <deque>
#include <string>
#include <limits>

#include <boost/graph/metric_tsp_approx.hpp>
#include <boost/graph/connected_components.hpp>
#include <boost/graph/dijkstra_shortest_paths.hpp>
#include <boost/graph/graph_utility.hpp>
#include <boost/version.hpp>

#include "c_types/iid_t_rt.h"
#include "cpp_common/coordinate_t.hpp"
#include "cpp_common/identifiers.hpp"
#include "cpp_common/messages.hpp"
#include "cpp_common/assert.hpp"
#include "cpp_common/interruption.hpp"

#include "visitors/dijkstra_visitors.hpp"


namespace pgrouting {
namespace graph {

TSP_graph::TSP_graph(std::vector<IID_t_rt> &distances) {
    /*
     * Inserting vertices
     */
    Identifiers<int64_t> ids;
    for (auto &d : distances) {
        ids += d.from_vid;
        ids += d.to_vid;
        /*
         * Its undirected graph:
         * keeping from_vid < to_vid
         */
        if (d.to_vid > d.from_vid) {
            std::swap(d.to_vid, d.from_vid);
        }
    }

    for (const auto &id : ids) {
        insert_vertex(id);
    }

    /*
     * Inserting edges
     */
    for (const auto &edge : distances) {
        /*
         * skip loops
         */
        if (edge.from_vid == edge.to_vid) continue;
        auto v1 = get_boost_vertex(edge.from_vid);
        auto v2 = get_boost_vertex(edge.to_vid);
        auto e_exists = boost::edge(v1, v2, m_graph);
        if (e_exists.second) {
            auto weight = get(boost::edge_weight_t(), m_graph, e_exists.first);
            /*
             * skip duplicated edges with less cost
             */
            if (weight < edge.cost) continue;
            if (edge.cost < weight) {
                /*
                 * substitute edge with new lesser cost found
                 */
                boost::put(boost::edge_weight_t(), m_graph, e_exists.first, edge.cost);
            }
            continue;
        }

        auto add_result = boost::add_edge(v1, v2, edge.cost, m_graph);
        if (!add_result.second) {
            throw std::make_pair(
                    std::string("INTERNAL: something went wrong adding and edge\n"),
                    std::string(__PGR_PRETTY_FUNCTION__));
        }
    }

    /*
     * Check data validity
     * - One component
     * Not checking triangle inequality
     */
    std::vector<V> components(boost::num_vertices(m_graph));
    CHECK_FOR_INTERRUPTS();
    try {
        if (boost::connected_components(m_graph, &components[0]) > 1) {
            throw std::make_pair(
                    std::string("Graph is not fully connected"),
                    std::string("Check graph before calling"));
        }
    } catch (...) {
        throw;
    }
}


/**
 * The postgres user might inadvertently give duplicate points with the same id
 * the approximation is quite right, for example
 * 1, 3.5, 1
 * 1, 3.499999999999 0.9999999
 * the approximation is quite wrong, for example
 * 2 , 3.5 1
 * 2 , 3.6 1
 * but when the remove_duplicates flag is on, keep only the first row that has the same id
 */
TSP_graph::TSP_graph(const std::vector<Coordinate_t> &coordinates) {
    /*
     * Inserting edges
     */
    for (size_t i = 0; i < coordinates.size(); ++i) {
        insert_vertex(coordinates[i].id);
        auto u = get_boost_vertex(coordinates[i].id);
        auto ux = coordinates[i].x;
        auto uy = coordinates[i].y;

        /*
         *  undirected, so only need traverse higher coordinates for connections
         */
        for (size_t j = i + 1; j < coordinates.size(); ++j) {
            insert_vertex(coordinates[j].id);
            auto v = get_boost_vertex(coordinates[j].id);

            /*
             * ignoring duplicated coordinates
             */
            if (boost::edge(u, v, m_graph).second) continue;

            auto vx = coordinates[j].x;
            auto vy = coordinates[j].y;

            auto const dx = ux - vx;
            auto const dy = uy - vy;

            /*
             * weight is euclidean distance
             */
            auto add_result = boost::add_edge(u, v, sqrt(dx * dx + dy * dy), m_graph);
            if (!add_result.second) {
                throw std::make_pair(
                        std::string("INTERNAL: something went wrong adding and edge\n"),
                        std::string(__PGR_PRETTY_FUNCTION__));
            }
        }
    }
}


bool
TSP_graph::has_vertex(int64_t id) const {
    return id_to_V.find(id) != id_to_V.end();
}

void
TSP_graph::insert_vertex(int64_t id) {
    try {
        if (has_vertex(id)) return;
        auto v = add_vertex(ids.size(), m_graph);
        id_to_V.insert(std::make_pair(id, v));
        V_to_id.insert(std::make_pair(v, id));
        ids += id;
    } catch (...) {
        throw std::make_pair(
                std::string("INTERNAL: something went wrong when inserting a vertex"),
                std::string(__PGR_PRETTY_FUNCTION__));
    }
}

TSP_graph::V
TSP_graph::get_boost_vertex(int64_t id) const {
    try {
        return id_to_V.at(id);
    } catch (...) {
        throw std::make_pair(
                std::string("INTERNAL: something went wrong when getting the vertex descriptor"),
                std::string(__PGR_PRETTY_FUNCTION__));
    }
}

int64_t
TSP_graph::get_vertex_id(V v) const {
    try {
        return V_to_id.at(v);
    } catch (...) {
        throw std::make_pair(
                std::string("INTERNAL: something went wrong when getting the vertex id"),
                std::string(__PGR_PRETTY_FUNCTION__));
    }
}

int64_t
TSP_graph::get_edge_id(E e) const {
    try {
        return E_to_id.at(e);
    } catch (...) {
        throw std::make_pair(
                std::string("INTERNAL: something went wrong when getting the edge id"),
                std::string(__PGR_PRETTY_FUNCTION__));
    }
}



#if BOOST_VERSION >= 106800
std::ostream& operator<<(std::ostream &log, const TSP_graph& data) {
    log << "Number of Vertices is:" << num_vertices(data.m_graph) << "\n";
    log << "Number of Edges is:" << num_edges(data.m_graph) << "\n";
    log << "\n the print_graph\n";
    boost::print_graph(data.m_graph, boost::get(boost::vertex_index, data.m_graph), log);
    return log;
}
#endif

}  // namespace graph

}  // namespace pgrouting
