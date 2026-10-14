/*PGR-GNU*****************************************************************
File: hawickCircuits.cpp

Copyright (c) 2022-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2022 Nitish Chauhan
Mail: nitishchauhan0022 at gmail.com

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

#include "circuits/hawickcircuits.hpp"

#include <cstdint>
#include <set>
#include <utility>
#include <vector>

#include <boost/graph/hawick_circuits.hpp>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/circuits_t.hpp"
#include "cpp_common/interruption.hpp"


namespace  {


struct circuit_collector {
    std::vector<std::vector<pgrouting::DirectedGraph::V>>& circuits;
    const std::set<int64_t>& vertices;
    int64_t min_depth;
    int64_t max_depth;
    bool self_loops;
    std::set<std::vector<pgrouting::DirectedGraph::V>> seen;

    template <typename Vertices, typename G>
    void cycle(const Vertices& circuit, const G& g) {
        const auto depth = static_cast<int64_t>(circuit.size());
        if (depth == 1) {
            if (!self_loops) return;
        } else if (depth < min_depth || depth > max_depth) {
            return;
        }
        if (!vertices.empty() && vertices.find(g[circuit.front()].id) == vertices.end()) return;

        std::vector<pgrouting::DirectedGraph::V> vertex_circuit(circuit.begin(), circuit.end());
        if (!seen.insert(vertex_circuit).second) return;
        circuits.push_back(std::move(vertex_circuit));
    }
};


/** @brief Expands one vertex cycle over all its parallel arcs
 *
 * Every hop of the cycle is replaced by each of the parallel arcs that connect
 * the same pair of vertices, producing the cartesian product of the arcs.
 */
void
expand_parallel_arcs(
        const pgrouting::DirectedGraph& graph,
        const std::vector<pgrouting::DirectedGraph::V>& vertex_circuit,
        pgrouting::types::Circuits& circuits) {
    using E = pgrouting::DirectedGraph::E;

    const size_t size = vertex_circuit.size();
    std::vector<std::vector<E>> hops(size);
    for (size_t i = 0; i < size; ++i) {
        auto from = vertex_circuit[i];
        auto to = vertex_circuit[(i + 1) % size];
        auto edges = boost::out_edges(from, graph.graph);
        for (auto edge = edges.first; edge != edges.second; ++edge) {
            if (graph.target(*edge) == to) {
                hops[i].push_back(*edge);
            }
        }
        if (hops[i].empty()) return;
    }

    std::vector<size_t> indexes(size, 0);
    while (true) {
        pgrouting::types::Circuit circuit;
        circuit.reserve(size);
        for (size_t i = 0; i < size; ++i) {
            const auto edge = hops[i][indexes[i]];
            circuit.push_back({graph[vertex_circuit[i]].id, graph[edge].id, graph[edge].cost});
        }
        circuits.push_back(std::move(circuit));

        size_t i = 0;
        while (i < size && ++indexes[i] == hops[i].size()) {
            indexes[i] = 0;
            ++i;
        }
        if (i == size) break;
    }
}

}  // namespace

namespace pgrouting {
namespace functions {

/** @brief hawickcircuit function
 *
 * It does all the processing and returns the results.
 * @param graph  the graph containing the edges
 * @param min_depth  minimum depth of the circuits to be returned
 * @param max_depth  maximum depth of the circuits to be returned
 * @returns results, when results are found
 */
pgrouting::types::Circuits
hawickCircuits(
        const pgrouting::DirectedGraph &graph,
        const std::set<int64_t> &vertices,
        int64_t min_depth,
        int64_t max_depth,
        bool self_loops) {
    std::vector<std::vector<pgrouting::DirectedGraph::V>> vertex_circuits;

    circuit_collector collector{vertex_circuits, vertices, min_depth, max_depth, self_loops, {}};

    CHECK_FOR_INTERRUPTS();
    try {
        boost::hawick_circuits(graph.graph, collector);
    } catch (boost::exception const& ex) {
        (void)ex;
        throw;
    } catch (std::exception &e) {
        (void)e;
        throw;
    } catch (...) {
        throw;
    }

    pgrouting::types::Circuits circuits;
    for (const auto& vertex_circuit : vertex_circuits) {
        expand_parallel_arcs(graph, vertex_circuit, circuits);
    }

    return circuits;
}


/** @brief Connector to boost::hawick_unique_circuits
 *
 * It does all the processing and returns the results.
 * @param graph  the graph containing the edges
 * @param min_depth  minimum depth of the circuits to be returned
 * @param max_depth  maximum depth of the circuits to be returned
 * @returns results, when results are found
 */
UniqueCircuits
hawickUniqueCircuits(
        const pgrouting::DirectedGraph &graph,
        const std::set<int64_t> &vertices,
        int64_t min_depth,
        int64_t max_depth,
        bool self_loops) {
    UniqueCircuits circuits;

    circuit_collector collector{circuits, vertices, min_depth, max_depth, self_loops, {}};

    CHECK_FOR_INTERRUPTS();
    try {
        boost::hawick_unique_circuits(graph.graph, collector);
    } catch (boost::exception const& ex) {
        (void)ex;
        throw;
    } catch (std::exception &e) {
        (void)e;
        throw;
    } catch (...) {
        throw;
    }

    return circuits;
}


}  // namespace functions
}  // namespace pgrouting
