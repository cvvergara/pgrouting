/*PGR-GNU*****************************************************************
File: floydWarshall_driver.cpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2015 Celia Virginia Vergara Castillo
Mail: vicky_vergara@hotmail.com

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

#include "drivers/allpairs/allpairs_driver.h"

#include <sstream>
#include <deque>
#include <vector>

#include "allpairs/pgr_allpairs.hpp"

#include "cpp_common/pgr_assert.h"

namespace {

template <typename G>
size_t count_rows(
        const G &graph,
        const std::vector< std::vector<double> > &matrix) {
    size_t result_tuple_count = 0;
    for (size_t i = 0; i < graph.num_vertices(); i++) {
        for (size_t j = 0; j < graph.num_vertices(); j++) {
            if (i == j) continue;
            if (matrix[i][j] != (std::numeric_limits<double>::max)()) {
                result_tuple_count++;
            }  // if
        }  // for j
    }  // for i
    return result_tuple_count;
}

template <typename G>
void make_result(
        const G &graph,
        const std::vector< std::vector<double> > &matrix,
        size_t &result_tuple_count,
        IID_t_rt **postgres_rows) {
    result_tuple_count = count_rows(graph, matrix);
    *postgres_rows = pgr_alloc(result_tuple_count, (*postgres_rows));


    size_t seq = 0;
    for (typename G::V v_i = 0; v_i < graph.num_vertices(); v_i++) {
        for (typename G::V v_j = 0; v_j < graph.num_vertices(); v_j++) {
            if (v_i == v_j) continue;
            if (matrix[v_i][v_j] != (std::numeric_limits<double>::max)()) {
                (*postgres_rows)[seq].from_vid = static_cast<int64_t>(graph[v_i].id);
                (*postgres_rows)[seq].to_vid = static_cast<int64_t>(graph[v_j].id);
                (*postgres_rows)[seq].cost =  matrix[v_i][v_j];
                seq++;
            }  // if
        }  // for j
    }  // for i
}

}  // namespace

void
do_allpairs(
        Edge_t  *data_edges,
        size_t total_edges,
        bool directed,
        int which,
        /* IDEA: have as a parameter the function name*/

        IID_t_rt **return_tuples,
        size_t *return_count,
        char ** log_msg,
        char ** err_msg) {
    std::ostringstream log;
    std::ostringstream err;

    try {
        pgassert(!(*log_msg));
        pgassert(!(*err_msg));
        pgassert(!(*return_tuples));
        pgassert(*return_count == 0);

        graphType gType = directed? DIRECTED: UNDIRECTED;

        std::vector<std::vector<double>> matrix;

        if (directed) {
            log << "Processing Directed graph\n";
            pgrouting::DirectedGraph digraph(gType);
            digraph.insert_edges(data_edges, total_edges);
            if (which == 0) {
                matrix = pgr_johnson(digraph);
            } else {
                matrix = pgr_floydWarshall(digraph);
            }
        } else {
            log << "Processing Undirected graph\n";
            pgrouting::UndirectedGraph undigraph(gType);
            undigraph.insert_edges(data_edges, total_edges);
            if (which == 0) {
                matrix = pgr_johnson(undigraph);
            } else {
                matrix = pgr_floydWarshall(undigraph);
            }
        }


        if (*return_count == 0) {
            err <<  "No result generated, report this error\n";
            *err_msg = pgr_msg(err.str().c_str());
            *return_tuples = NULL;
            *return_count = 0;
            return;
        }

        *log_msg = log.str().empty()?
            *log_msg :
            pgr_msg(log.str().c_str());
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    } catch (std::exception &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    } catch(...) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << "Caught unknown exception!";
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    }
}
