/*PGR-GNU*****************************************************************

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2021 Vicky Vergara
Mail: vicky@georepublic.de

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

#include <utility>
#include <vector>
#include <deque>

#include "cpp_common/identifiers.hpp"
#include "cpp_common/pgr_messages.h"
#include "cpp_common/pgr_assert.h"


namespace {


bool
compare_tsp_path(
        std::deque<std::pair<int64_t, double>> lhs,
        std::deque<std::pair<int64_t, double>> rhs
        ) {
    pgassert(lhs.size() == rhs.size());
    double tot_lhs {0.0};
    for (const auto &e : lhs) {
        tot_lhs += e.second;
    }
    double tot_rhs {0.0};
    for (const auto &e : rhs) {
        tot_rhs += e.second;
    }
    return tot_lhs < tot_rhs;
}

std::deque<std::pair<int64_t, double>>
reverse_path(std::deque<std::pair<int64_t, double>> tsp_path) {
    std::reverse(tsp_path.begin(), tsp_path.end());
    double prev {0};
    for (auto &e : tsp_path) {
        std::swap(prev, e.second);
    }
    return tsp_path;
}


std::deque<std::pair<int64_t, double>>
start_vid_end_vid_are_fixed(
        std::deque<std::pair<int64_t, double>> tsp_path,
        int64_t start_vid,
        int64_t end_vid,
        int64_t special_cost) {
    /*
     * attach the correct cost value
     */
    auto where = std::find_if(tsp_path.begin(), tsp_path.end(),
            [&](std::pair<int64_t, double>& row){return row.first == start_vid || row.first == end_vid;});
    (where + 1)->second = special_cost;

    auto found_value = where->first;
    if (found_value == start_vid) {
        tsp_path = reverse_path(tsp_path);
    }

    tsp_path.pop_front();
    where = std::find_if(tsp_path.begin(), tsp_path.end(),
            [&](std::pair<int64_t, double>& row){return row.first == start_vid;});


    std::rotate(tsp_path.begin(), where, tsp_path.end());
    std::rotate(tsp_path.begin(), tsp_path.begin() + 1, tsp_path.end());
    tsp_path.push_front(std::make_pair(start_vid, 0));
    return tsp_path;
}

}  // namespace


namespace pgrouting {
namespace algorithm {

std::deque<std::pair<int64_t, double>>
TSP::tsp() {
    std::deque<std::pair<int64_t, double>> results;
    std::vector<V> tsp_path(num_vertices(graph));

#if 0
    CHECK_FOR_INTERRUPTS();
#endif
    bool bad_graph = false;
    try {
    boost::metric_tsp_approx_tour(
            graph,
            back_inserter(tsp_path));
    }  catch (...)  { bad_graph = true; }
    if (bad_graph) {
        log << "graph is incomplete";
        return results;
    }
    pgassert(!bad_graph);

    auto weight = get(boost::edge_weight, graph);
    auto u = graph.null_vertex();
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

std::deque<std::pair<int64_t, double>>
TSP::tsp(int64_t start_vid) {
    std::deque<std::pair<int64_t, double>> results;
    std::vector<V> tsp_path;
    /*
     * check that the start_vid, and end_vid exist on the data
     */
    if (id_to_V.find(start_vid) == id_to_V.end()) {
        log << "something went wrong '" << start_vid << "' node is missing\n";
        return results;
    }

    auto v = get_boost_vertex(start_vid);

#if 0
    CHECK_FOR_INTERRUPTS();
#endif
    bool bad_graph = false;
    try {
    boost::metric_tsp_approx_tour_from_vertex(
            graph,
            v,
            back_inserter(tsp_path));
    }  catch (...)  { bad_graph = true; }
    if (bad_graph) {
        log << "graph is incomplete";
        return results;
    }
    pgassert(!bad_graph);

    auto weight = get(boost::edge_weight, graph);
    auto u = graph.null_vertex();
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

std::deque<std::pair<int64_t, double>>
TSP::tsp(int64_t start_vid, int64_t end_vid) {
    std::deque<std::pair<int64_t, double>> result;

    if (start_vid == 0) std::swap(start_vid, end_vid);

    /*
     * just get a tsp result
     */
    if (start_vid == 0) return tsp();

    /*
     * the start has a value, so it has to be fixed
     */
    if ((end_vid == 0) || (start_vid == end_vid)) return tsp(start_vid);

    /*
     * check that the start_vid, and end_vid exist on the data
     */
    if (id_to_V.find(start_vid) == id_to_V.end()) {
        log << "something went wrong '" << start_vid << "' node is missing\n";
        return result;
    }

    if (id_to_V.find(end_vid) == id_to_V.end()) {
        log << "something went wrong '" << end_vid << "' node is missing\n";
        return result;
    }

    /*
     * start_vid and end_vid have values
     * find the edge (start_vid, end_vid)
     */
    auto u = get_boost_vertex(start_vid);
    auto v = get_boost_vertex(end_vid);
    auto e = boost::edge(u, v, graph);

    auto weight = get(boost::edge_weight_t(), graph, e.first);
    boost::put(boost::edge_weight_t(), graph, e.first, 0);


    for (auto vd : boost::make_iterator_range(boost::vertices(graph))) {
        auto tsp_path = tsp(get_vertex_id(vd));
        auto where = std::find_if(tsp_path.begin(), tsp_path.end(),
                [&](std::pair<int64_t, double>& row){return row.first == start_vid || row.first == end_vid;});
        if ((where + 1)->first == start_vid ||  (where + 1)->first == end_vid) {
            if (result.empty() || compare_tsp_path(tsp_path, result)) {
            /** there is an answer with a contiguos start_vid -> end_vid */
                result = tsp_path;
            }
        }
    }

    return result.empty()?
        tsp(start_vid):
        start_vid_end_vid_are_fixed(result, start_vid, end_vid, weight);
}


TSP::TSP(Matrix_cell_t *distances,
        size_t total_distances, bool) {
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
}


/** The postgres user might unadvertevly give duplicate points
 * the aproximation is quite right, for example
 * 1, 3.5, 1
 * 1, 3.499999999999 0.9999999
 * the aproximation is quite wrong, for example
 * 2 , 3.5 1
 * 2 , 3.6 1
 * but when the remove_duplicates flag is on, keep only the first row that has the same id
 */
TSP::TSP(Coordinate_t *coordinates,
        size_t total_coordinates,
        bool remove_duplicates) {
    log << "before total_coordinates" << total_coordinates;

    /*
     * Removing duplicates if so desired
     - keeping the relative order of the data
     * - so different order in input will give different sort result
     * - the first ocurrence will remain and kept
     */
    if (remove_duplicates) {
        std::stable_sort(coordinates, coordinates + total_coordinates,
                [](const Coordinate_t& lhs, const Coordinate_t& rhs){return lhs.id < rhs.id;});

        total_coordinates = static_cast<size_t>(std::distance(coordinates,
                    std::unique(coordinates, coordinates + total_coordinates,
                        [&](const Coordinate_t& lhs, const Coordinate_t& rhs){return lhs.id == rhs.id;})));
    }
    log << "-> " << total_coordinates << "\n";

    /*
     * Inserting vertices
     */
    Identifiers<int64_t> ids;
    for (size_t i = 0; i < total_coordinates; ++i) {
        ids += coordinates[i].id;
    }

    if (!remove_duplicates && ids.size() != total_coordinates) {
        log << "User data is wrong, duplicated ids found";
    } else if (remove_duplicates && ids.size() != total_coordinates) {
        log << "INTERNAL: duplicates were not removed correctly";
    }

    size_t i{0};
    for (const auto id : ids) {
        auto v = add_vertex(i, graph);
        id_to_V.insert(std::make_pair(id, v));
        V_to_id.insert(std::make_pair(v, id));
        ++i;
    }

    /*
     * Inserting edges
     */
    for (size_t i = 0; i < total_coordinates; ++i) {
        auto u = get_boost_vertex(coordinates[i].id);
        auto ux = coordinates[i].x;
        auto uy = coordinates[i].y;

        /*
         *  undirected, so only need traverse higher vertices for connections
         */
        for (size_t j = i + 1; j < total_coordinates; ++j) {
            auto v = get_boost_vertex(coordinates[j].id);
            auto vx = coordinates[j].x;
            auto vy = coordinates[j].y;

            auto const dx = ux - vx;
            auto const dy = uy - vy;

            /*
             * weight is euclidean distance
             */
            auto add_result = boost::add_edge(u, v, sqrt(dx * dx + dy * dy), graph);
            if (!add_result.second) {
                log << "INTERNAL: something went wrong when adding and edge with cost 0\n";
            }
        }
    }
}

#if Boost_VERSION_MACRO >= 106800
std::ostream& operator<<(std::ostream &log, const TSP& data) {
    log << "Number of Vertices is:" << num_vertices(data.graph) << "\n";
    log << "Number of Edges is:" << num_edges(data.graph) << "\n";
    log << "\n the print_graph\n";
    boost::print_graph(data.graph, boost::get(boost::vertex_index, data.graph), log);
#if 0
     // to print with edge weights:
    for (auto v : boost::make_iterator_range(boost::vertices(data.graph))) {
        for (auto oe : boost::make_iterator_range(boost::out_edges(v, data.graph))) {
            log << "Edge " << oe << " weight " << get(boost::edge_weight, data.graph)[oe] << "\n";
        }
    }
#endif
    return log;
}
#endif

}  // namespace algorithm
}  // namespace pgrouting

