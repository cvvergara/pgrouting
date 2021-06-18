/*PGR-GNU*****************************************************************
File: pgr_edgeColoring.hpp

Generated with Template by:
Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Veenit Kumar
Mail: 123sveenit@gmail.com

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

#ifndef INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
#define INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
#pragma once

#include <boost/property_map/property_map.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/vector_property_map.hpp>
#include <boost/type_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/edge_coloring.hpp>
#include <boost/graph/iteration_macros.hpp>
#include <boost/graph/properties.hpp>
#include <boost/config.hpp>

#include <limits>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>

#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.h"

/** @file pgr_edgeColoring.hpp
 * @brief The main file which calls the respective boost function.
 * Contains actual implementation of the function and the calling
 * of the respective boost function.
 */


namespace pgrouting {
namespace functions {


/**
 * This is a class comment for doxygen
 * - colors identifiers are of type size_t
 */

template < class G >
class Pgr_edgeColoring {
public:
    typedef typename G::V V;
    typedef typename G::E E;

    /** @name EdgeColoring
     * @{
     */
    /** @brief edgeColoring function
     * It does all the processing and returns the results.
     * @param graph      the graph containing the edges
     * @returns results, when results are found
     * @see [boost::edge_coloring]
     * (https://www.boost.org/libs/graph/doc/edge_coloring.html)
     *
     * Steps:
     * - Prepare the information needed by boost::edge_coloring
     * - Process
     */

    std::vector<pgr_vertex_color_rt> edgeColoring(G &graph) {
        std::vector<pgr_vertex_color_rt> results;

        auto i_map = boost::get(boost::edge_all, graph.graph);
        std::vector<size_t> colors(boost::num_edges(graph.graph));

        auto color_map = boost::make_iterator_property_map(colors.begin(), i_map);

#if 0
        CHECK_FOR_INTERRUPTS();
#endif

        try {
            boost::edge_coloring(graph.graph, color_map);
        } catch (boost::exception const& ex) {
            (void)ex;
            throw;
        } catch (std::exception &e) {
            (void)e;
            throw;
        } catch (...) {
            throw;
        }
#if 0
        results = get_results(colors, graph);
#endif
        return results;
    }
    //@}

private:
#if 0
    /** @brief to get the results
     * Uses the `colors` vector to get the results i.e. the color of every edge.
     * @param colors      vector which contains the color of every edge
     * @param graph       the graph containing the edges
     * @returns `results` vector
     */

    std::vector<pgr_vertex_color_rt> get_results(
        std::vector<size_t> &colors,
        const G &graph) {
        std::vector<pgr_vertex_color_rt> results;

        typedef typename G::E_i E_i;
        E_i e_i, e_end;

        for (boost::tie(e_i, e_end) = edges(graph.graph); e_i != e_end; ++e_i) {
            int64_t edge = graph[*e_i].id;
            int64_t color = colors[edge];
            results.push_back({edge, (color + 1)});
        }
        return results;
    }
#endif
};
}  // namespace functions
}  // namespace pgrouting
#endif  // INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
