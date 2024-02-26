/*PGR-GNU*****************************************************************
File: line_graph.hpp

Function's developer:
Copyright (c) 2024 Vicky Vergara
Mail: vicky at gmail.com

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

#ifndef INCLUDE_BGRAPH_LINEGRAPH_HPP_
#define INCLUDE_BGRAPH_LINEGRAPH_HPP_

#include <sstream>
#include <deque>
#include <vector>
#include <utility>
#include <string>

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "c_types/edge_rt.h"

namespace pgrouting {
namespace b_g {

using B_G_R = boost::adjacency_list<
    boost::vecS, boost::vecS, boost::undirectedS,
    pgrouting::Basic_vertex, pgrouting::Basic_edge>;

template<typename B_G>
B_G_R line_graph(const B_G& original, std::ostringstream &log) {

    using V = typename boost::graph_traits<B_G_R>::vertex_descriptor;
    using IndexMap = std::map<int64_t, V>;

    B_G_R result;
    IndexMap id_to_descriptor;

    auto o_edges = boost::edges(original);
    log << "cycle edges\n";
    for (auto e = o_edges.first; e != o_edges.second; ++e) {
        auto v = add_vertex(result);
        result[v].id = original[*e].id;
        log << " add vertex" << original[*e].id << "(" << v << ")\n";
        id_to_descriptor[original[*e].id] =  v;
    }

    /* for (each vertex v in original graph) */
    auto vs = boost::vertices(original);
    for (auto vertexIt = vs.first; vertexIt != vs.second; vertexIt++) {
        auto vertex = *vertexIt;

        log << "original vertex " << original[vertex].id << ":\n";
        /* for( all incoming edges in to vertex v) */
        auto o_inedges = boost::in_edges(vertex, original);
        for (auto ine = o_inedges.first; ine != o_inedges.second; ++ine) {
            auto s = original[*ine].id;
            log << "in edge " << s << "\n";

            auto o_out_edges = boost::out_edges(vertex, original);
            for (auto eout = o_out_edges.first; eout != o_out_edges.second; ++eout) {
                /* for( all outgoing edges out from vertex v) */
                auto t = original[*eout].id;
                log << "in edge " << s << "\t";
                log << "out edge " << t << "\t";
                /*
                 *  Prevent self-edges from being created in the Line Graph
                 */
                if (s == t) continue;
                log << s <<","<< t<<"\n";
                auto rs = id_to_descriptor[s];
                auto rt = id_to_descriptor[t];
                log << rs <<","<< rt<<"\n";
                auto e = boost::add_edge(rs, rt, result);
                result[e.first].id = static_cast<int64_t>(num_edges(result));
                log << e.first << " added edge \n";
                log << e.first << " added edge " << result[e.first].id <<"\n";
            }
            log <<"\n";
        }
        log <<"\n";
    }
    return result;
}

}  // namespace b_g
}  // namespace pgrouting

#endif  // INCLUDE_BGRAPH_LINEGRAPH_HPP_
