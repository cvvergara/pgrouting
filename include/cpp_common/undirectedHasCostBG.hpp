/*PGR-GNU*****************************************************************
File: undirectedHasCostBG.hpp

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2025 Celia Virginia Vergara Castillo

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

#ifndef INCLUDE_CPP_COMMON_UNDIRECTEDHASCOSTBG_HPP_
#define INCLUDE_CPP_COMMON_UNDIRECTEDHASCOSTBG_HPP_
#pragma once


#include <map>
#include <string>
#include <vector>
#include <cstdint>

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/version.hpp>

#if 0
#include "c_types/iid_t_rt.h"
#include "cpp_common/coordinate_t.hpp"
#endif
#include "cpp_common/identifiers.hpp"
#include "cpp_common/messages.hpp"
#include "cpp_common/assert.hpp"

using Coordinate_t = struct Coordinate_t;
using IID_t_rt = struct IID_t_rt;


namespace pgrouting {
namespace graph {

class TSP_graph {
 public:
    using TSP_Graph =
        boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS,
        boost::property<boost::vertex_index_t, int>,
        boost::property<boost::edge_weight_t, double>,
        boost::no_property>;

    using V       = boost::graph_traits<TSP_Graph>::vertex_descriptor;
    using E       = boost::graph_traits<TSP_Graph>::edge_descriptor;
    using V_it    = boost::graph_traits<TSP_Graph>::vertex_iterator;
    using E_it    = boost::graph_traits<TSP_Graph>::edge_iterator;
    using Eout_it = boost::graph_traits<TSP_Graph>::out_edge_iterator;

 public:
    explicit TSP_graph(std::vector<IID_t_rt>&);
    explicit TSP_graph(const std::vector<Coordinate_t>&);
    TSP_graph() = delete;

#if BOOST_VERSION >= 106800
    friend std::ostream& operator<<(std::ostream &, const TSP_graph&);
#endif
    bool has_vertex(int64_t id) const;

    const TSP_Graph& graph() const {return m_graph;}
    TSP_Graph& graph() {return m_graph;}

    V get_boost_vertex(int64_t id) const;
    void insert_vertex(int64_t id);
    int64_t get_vertex_id(V v) const;
    int64_t get_edge_id(E e) const;


 private:
    TSP_Graph m_graph;
    std::map<int64_t, V> id_to_V;
    std::map<V, int64_t> V_to_id;
    std::map<E, int64_t> E_to_id;
    Identifiers<int64_t> ids;
};

}  // namespace graph


}  // namespace pgrouting

#endif  // INCLUDE_CPP_COMMON_UNDIRECTEDHASCOSTBG_HPP_
