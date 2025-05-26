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


#include <map>
#include <string>
#include <utility>
#include <deque>
#include <vector>
#include <cstdint>

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/version.hpp>

#include "c_types/iid_t_rt.h"
#include "cpp_common/coordinate_t.hpp"
#include "cpp_common/identifiers.hpp"
#include "cpp_common/messages.hpp"
#include "cpp_common/assert.hpp"
#include "cpp_common/undirectedHasCostBG.hpp"



namespace pgrouting {
namespace algorithm {

class TSP : public Pgr_messages {
 public:
    using TSP_graph = graph::UndirectedHasCostBG;
    using V = TSP_graph::V;

    /** @brief just a TSP value **/
    std::deque<std::pair<int64_t, double>> tsp(TSP_graph&);
    /** @brief order the results with a start vertex */
    std::deque<std::pair<int64_t, double>> tsp(TSP_graph&, int64_t);
    /** @brief order the results with a start vertex and an endig vertex*/
    std::deque<std::pair<int64_t, double>> tsp(TSP_graph&, int64_t, int64_t, int);
    /** @brief crossover optimization **/
    std::deque<std::pair<int64_t, double>> crossover_optimize(
            TSP_graph&,
            std::deque<std::pair<int64_t, double>> result,
            size_t limit, int cycles);

 private:
    std::deque<std::pair<int64_t, double>> eval_tour(TSP_graph&, const std::vector<V>&);
    double eval_tour(TSP_graph&, std::deque<std::pair<int64_t, double>>&tsp_tour);
};

}  // namespace algorithm

std::deque<std::pair<int64_t, double>> tsp(graph::UndirectedHasCostBG&, int64_t, int64_t, int);

}  // namespace pgrouting

#endif  // INCLUDE_TSP_TSP_HPP_
