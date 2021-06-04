/*PGR-GNU*****************************************************************
File: tsp.hpp

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2021 Celia Virginia Vergara Castillo

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

#ifndef INCLUDE_TSP_TSP_HPP_
#define INCLUDE_TSP_TSP_HPP_
#pragma once


#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/metric_tsp_approx.hpp>

#include <map>
#include <string>
#include <utility>
#include <vector>
#include <set>
#include <limits>

#include "c_types/matrix_cell_t.h"
#include "cpp_common/interruption.h"
#include "cpp_common/pgr_messages.h"


namespace pgrouting {
namespace algorithm {

class TSP : public Pgr_messages {
    using TSP_Graph =
        boost::adjacency_list<boost::setS, boost::listS, boost::undirectedS,
        boost::property<boost::vertex_index_t, int>,
        boost::property<boost::edge_weight_t, double>,
        boost::no_property>;

    using V       = boost::graph_traits<TSP_Graph>::vertex_descriptor;
    using E       = boost::graph_traits<TSP_Graph>::edge_descriptor;
    using V_it    = boost::graph_traits<TSP_Graph>::vertex_iterator;
    using E_it    = boost::graph_traits<TSP_Graph>::edge_iterator;
    using Eout_it = boost::graph_traits<TSP_Graph>::out_edge_iterator;

 public:
    std::vector<std::pair<int64_t, double>> tsp();

    TSP(Matrix_cell_t *distances, size_t total_distances);
    TSP() = delete;

    friend std::ostream& operator<<(std::ostream &, const TSP&);

 private:
    V get_boost_vertex(int64_t id) const {
        return id_to_V.at(id);
    }

    int64_t get_vertex_id(V v) const {
        return V_to_id.at(v);
    }

    int64_t get_edge_id(E e) const {
        return E_to_id.at(e);
    }


 private:
    TSP_Graph graph;
    std::map<int64_t, V> id_to_V;
    std::map<V, int64_t> V_to_id;
    std::map<E, int64_t> E_to_id;
};

}  // namespace graph
}  // namespace pgrouting

#endif  // INCLUDE_TSP_TSP_HPP_
