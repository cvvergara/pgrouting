/*PGR-GNU*****************************************************************
File: max_flow_many_to_many_driver.cpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2016 Andrea Nardelli
Mail: nrd.nardelli@gmail.com

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

#include "./pgr_maxflow.hpp"

#include <sstream>
#include <vector>
#include <set>

#include "./max_flow_driver.h"

#include "../../common/src/pgr_assert.h"
#include "../../common/src/pgr_alloc.hpp"
#include "./../../common/src/pgr_types.h"


void
do_pgr_max_flow(
        pgr_edge_t *data_edges,
        size_t total_tuples,
        int64_t *source_vertices,
        size_t size_source_verticesArr,
        int64_t *sink_vertices,
        size_t size_sink_verticesArr,
        char *algorithm,
        bool only_flow,
        pgr_flow_t **return_tuples,
        size_t *return_count,
        char** log_msg,
        char** notice_msg,
        char **err_msg) {
    std::ostringstream log;
    std::ostringstream notice;
    std::ostringstream err;

    try {
        pgassert(data_edges);
        pgassert(source_vertices);
        pgassert(sink_vertices);

        pgrouting::graph::PgrFlowGraph<pgrouting::FlowGraph> G;
        std::set<int64_t> set_source_vertices;
        std::set<int64_t> set_sink_vertices;
        for (size_t i = 0; i < size_source_verticesArr; ++i) {
            set_source_vertices.insert(source_vertices[i]);
        }
        for (size_t i = 0; i < size_sink_verticesArr; ++i) {
            set_sink_vertices.insert(sink_vertices[i]);
        }
        std::set<int64_t> vertices(set_source_vertices);
        vertices.insert(set_sink_vertices.begin(), set_sink_vertices.end());
        if (vertices.size()
                != (set_source_vertices.size() + set_sink_vertices.size())) {
            *err_msg = pgr_msg("A source found as sink");
            // TODO(vicky) return as hint the sources that are also sinks
            return;
        }



        G.create_flow_graph(data_edges, total_tuples, set_source_vertices,
                set_sink_vertices, algorithm);

        int64_t max_flow;
        if (strcmp(algorithm, "push_relabel") == 0) {
            max_flow = G.push_relabel();
        } else if (strcmp(algorithm, "edmonds_karp") == 0) {
            max_flow = G.edmonds_karp();
        } else if (strcmp(algorithm, "boykov_kolmogorov") == 0) {
            max_flow = G.boykov_kolmogorov();
        } else {
            log << "Unspecified algorithm!\n";
            *err_msg = pgr_msg(log.str().c_str());
            (*return_tuples) = NULL;
            (*return_count) = 0;
            return;
        }


        std::vector<pgr_flow_t> flow_edges;

        if (only_flow) {
            pgr_flow_t edge;
            edge.edge = -1;
            edge.source = -1;
            edge.target = -1;
            edge.flow = max_flow;
            edge.residual_capacity = -1;
            flow_edges.push_back(edge);
        } else {
            G.get_flow_edges(flow_edges);
        }
        (*return_tuples) = pgr_alloc(flow_edges.size(), (*return_tuples));
        for (size_t i = 0; i < flow_edges.size(); ++i) {
            (*return_tuples)[i] = flow_edges[i];
        }
        *return_count = flow_edges.size();


        *log_msg = log.str().empty()?
            *log_msg :
            pgr_msg(log.str().c_str());
        *notice_msg = notice.str().empty()?
            *notice_msg :
            pgr_msg(notice.str().c_str());
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

