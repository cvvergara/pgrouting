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
        pgrouting::types::Circuits& circuits,
        bool u_turn_on_edge) {
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

        /*
        * Guard:
        * If one vertex pair of the cycle has no connecting arc, the vertex cycle cannot be realized
        * as an edge circuit at all.
        * So a partial expansion must not be emitted
        * — drop the whole circuit.
        */
        if (hops[i].empty()) return;
    }

    std::vector<size_t> indexes(size, 0);
    pgrouting::types::Circuits u_turns;
    size_t kept = 0;

    while (true) {
        pgrouting::types::Circuit circuit;
        circuit.reserve(size);

        for (size_t i = 0; i < size; ++i) {
            const auto edge = hops[i][indexes[i]];
            circuit.push_back({graph[vertex_circuit[i]].id, graph[edge].id, graph[edge].cost});
        }

        /*
         * A circuit with 2 edges total that uses the same edge id on both hops
         * is a u-turn on that edge: when u_turn_on_edge is false it is dropped
         * in favor of expansions using different edges.
         */
        bool keep = true;
        if (!u_turn_on_edge && size == 2) {
            keep = circuit[0].edge != circuit[1].edge;
        }

        if (keep) {
            ++kept;
            circuits.push_back(std::move(circuit));
        } else {
            u_turns.push_back(std::move(circuit));
        }

        size_t i = 0;
        while (i < size && ++indexes[i] == hops[i].size()) {
            indexes[i] = 0;
            ++i;
        }
        if (i == size) break;
    }

    /* No expansion using different edges exists: keep the only option. */
    if (kept == 0) {
        for (auto& u_turn : u_turns) {
            circuits.push_back(std::move(u_turn));
        }
    }
}

/** @brief Resolves one unique circuit over the graph's edges
 *
 * Every hop of the vertex cycle is resolved to exactly one edge
 * keeping a single circuit per vertex cycle.
 */
void
resolve_unique_circuit(
        const pgrouting::DirectedGraph& graph,
        const std::vector<pgrouting::DirectedGraph::V>& vertex_circuit,
        pgrouting::types::Circuits& circuits) {
    const size_t size = vertex_circuit.size();
    pgrouting::types::Circuit circuit;
    circuit.reserve(size);

    for (size_t i = 0; i < size; ++i) {
        const auto to = vertex_circuit[(i + 1) % size];
        double cost = 0;
        const auto edge_id = graph.get_edge_id(vertex_circuit[i], to, cost);
        circuit.push_back({graph[vertex_circuit[i]].id, edge_id, cost});
    }

    circuits.push_back(std::move(circuit));
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
        bool self_loops,
        bool u_turn_on_edge) {
    std::vector<std::vector<pgrouting::DirectedGraph::V>> vertex_circuits;

    circuit_collector collector{vertex_circuits, vertices, min_depth, max_depth, self_loops};

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

    pgrouting::types::Circuits circuits;
    for (const auto& vertex_circuit : vertex_circuits) {
        expand_parallel_arcs(graph, vertex_circuit, circuits, u_turn_on_edge);
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
pgrouting::types::Circuits
hawickUniqueCircuits(
        const pgrouting::DirectedGraph &graph,
        const std::set<int64_t> &vertices,
        int64_t min_depth,
        int64_t max_depth,
        bool self_loops) {
    std::vector<std::vector<pgrouting::DirectedGraph::V>> vertex_circuits;

    circuit_collector collector{vertex_circuits, vertices, min_depth, max_depth, self_loops};

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

    pgrouting::types::Circuits circuits;
    for (const auto& vertex_circuit : vertex_circuits) {
        resolve_unique_circuit(graph, vertex_circuit, circuits);
    }

    return circuits;
}


}  // namespace functions
}  // namespace pgrouting
