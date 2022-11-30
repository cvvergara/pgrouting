/*PGR-GNU*****************************************************************
File: maximum_cardinality_matching_driver.cpp

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Ignroing directed flag & works only for undirected graph
Refactoring
Copyright (c) 2022 Celia Vriginia Vergara Castillo
Mail: vicky_vergara at hotmail.com

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

#include "drivers/max_flow/maximum_cardinality_matching_driver.h"

#include <sstream>
#include <vector>
#include <string>

#include "max_flow/maxCardinalityMatch.hpp"

#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"

#include "c_types/edge_bool_t.h"

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "max_flow/maximumcardinalitymatching.hpp"


void
do_maxCardinalityMatch(
    Edges *data_edges,
    size_t total_tuples,

    int64_t **return_tuples,
    size_t *return_count,

    char** log_msg,
    char** notice_msg,
    char **err_msg) {
    using pgrouting::pgr_alloc;
    using pgrouting::to_pg_msg;
    using pgrouting::pgr_free;

    std::ostringstream log;
    std::ostringstream notice;
    std::ostringstream err;
    const char *hint = nullptr;

    try {
        pgrouting::graph::UndirectedNoCostsBG graph(data_edges, total_tuples);
        auto match = pgrouting::flow::maxCardinalityMatch(graph);

        (*return_tuples) = pgr_alloc(match.size(), (*return_tuples));
        size_t i {0};
        for (const auto e : match) {
            (*return_tuples)[i++] = e;
        }
        *return_count = match.size();
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (const std::string &ex) {
        *err_msg = to_pg_msg(ex);
        *log_msg = hint? to_pg_msg(hint) : to_pg_msg(log);
    } catch (std::exception &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch(...) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << "Caught unknown exception!";
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    }
}
