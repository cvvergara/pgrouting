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

#include <vector>

#include <boost/graph/hawick_circuits.hpp>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"


namespace  {


struct circuit_collector {
    pgrouting::functions::Circuits& circuits;

    template <typename Vertices, typename G>
    void cycle(const Vertices& circuit, const G&) {
        circuits.emplace_back(circuit.begin(), circuit.end());
    }
};

}  // namespace

namespace pgrouting {
namespace functions {

/** @brief hawickcircuit function
 *
 * It does all the processing and returns the results.
 * @param graph  the graph containing the edges
 * @returns results, when results are found
 */
Circuits
hawickCircuits(const pgrouting::DirectedGraph & graph) {
    // results storing the output
    Circuits circuits;

    // a circuit detector to provide the mechanism to store the circuit
    circuit_collector collector{circuits};

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
