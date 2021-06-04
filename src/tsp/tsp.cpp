/*PGR-GNU*****************************************************************

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2016 Andrea Nardelli
Mail: nrd.nardelli@gmail.com

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

#include "tsp/tsp.hpp"
#include <boost/graph/graph_utility.hpp>

#include <limits>
#include <utility>
#include <vector>
#include <set>

#include "cpp_common/identifiers.hpp"
#include "cpp_common/pgr_messages.h"


namespace pgrouting {
namespace algorithm {

std::vector<std::pair<int64_t, double>>
TSP::tsp() {
#if 0
    std::vector<std::pair<double,double>> points {
        { 4., 9. }, // these can be randomized
        { 2., 6. },
        { 4., 1. },
        { 1., 1. }
    };
#endif
    std::vector<V> tsp_path(num_vertices(graph));

    //CHECK_FOR_INTERRUPTS();
    boost::metric_tsp_approx_tour(
            graph,
            back_inserter(tsp_path));

    auto weight = get(boost::edge_weight, graph);
    auto u = graph.null_vertex();
    std::vector<std::pair<int64_t, double>> results;
    for (auto v : tsp_path) {
        if (v != graph.null_vertex()) {
            auto node = get_vertex_id(v);
            double cost{0};
            if (u == graph.null_vertex()) {
                cost = 0;
            } else {
                /*
                 * the cost is the weight
                 */
                auto the_edge = boost::edge(u, v, graph);
                if (!the_edge.second) {
                    log << "something went wrong";
                } else {
                    cost = weight[the_edge.first];
                }
            }
            u = v;
            results.push_back(std::make_pair(node, cost));

        }
    }
    return results;
}


TSP::TSP(Matrix_cell_t *distances,
        size_t total_distances) {
#if 0
    /*
     * Example from https://stackoverflow.com/questions/63914077/boost-graph-metric-tsp-approx-solution-not-following-graph-edges
     */
    std::vector<std::pair<double,double>> points {
        { 4., 9. }, // these can be randomized
        { 2., 6. },
        { 4., 1. },
        { 1., 1. }
    };

    for (auto i = 0u; i < points.size(); ++i) {
        auto v = add_vertex(i, graph);
        id_to_V.insert(std::make_pair(i, v));
        V_to_id.insert(std::make_pair(v, i));
    }

    for (auto i = 0u; i < points.size(); ++i) {
        auto va = vertex(i, graph);

        // undirected, so only need traverse higher vertices for connections
        for (auto j = i + 1; j < points.size(); ++j) {
            auto vb = vertex(j, graph);

            auto const ax = points.at(i).first;
            auto const ay = points.at(i).second;
            auto const bx = points.at(j).first;
            auto const by = points.at(j).second;
            auto const dx = bx - ax;
            auto const dy = by - ay;

            add_edge(va, vb, sqrt(dx*dx + dy*dy), graph); // weight is euclidean distance
        }
    }
    return;
#else
    /*
     * Inserting vertices
     */
    Identifiers<int64_t> ids;
    for (size_t i = 0; i < total_distances; ++i) {
        ids += distances[i].from_vid;
        ids += distances[i].to_vid;
    }

    size_t i {0};
    for (const auto id : ids) {
        auto v = add_vertex(i, graph);
        id_to_V.insert(std::make_pair(id, v));
        V_to_id.insert(std::make_pair(v, id));
        ++i;
    }


    /*
     * Inserting edges
     */
    bool added;
    for (size_t i = 0; i < total_distances; ++i) {
        auto edge = distances[i];
        auto v1 = get_boost_vertex(edge.from_vid);
        auto v2 = get_boost_vertex(edge.to_vid);
        auto e_exists = boost::edge(v1, v2, graph);
        if (e_exists.second) continue;

        E e;
        boost::tie(e, added) = boost::add_edge(v1, v2, edge.cost, graph);
    }
#endif
}

#if Boost_VERSION_MACRO >= 106800
std::ostream& operator<<(std::ostream &log, const TSP& data) {
    log << "Number of Vertices is:" << num_vertices(data.graph) << "\n";
    log << "Number of Edges is:" << num_edges(data.graph) << "\n";
    log << "\n the print_graph\n";
    boost::print_graph(data.graph, boost::get(boost::vertex_index, data.graph), log);
    return log;
}
#endif

}  // namespace algorithm
}  // namespace pgrouting

