/*PGR-GNU*****************************************************************

FILE: euclideanTSP_driver.cpp

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

#include "drivers/tsp/euclideanTSP_driver.h"

#include <string.h>
#include <sstream>
#include <vector>
#include <algorithm>

#include "tsp/tsp.hpp"
#include "tsp/euclideanDmatrix.h"

#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"

void
do_pgr_euclideanTSP(
        Coordinate_t *coordinates,
        size_t total_coordinates,
        int64_t start_vid,
        int64_t end_vid,

        double,
        double,
        double,
        int64_t,
        int64_t,
        int64_t,
        bool,
        double,

        General_path_element_t **return_tuples,
        size_t *return_count,
        char **log_msg,
        char **notice_msg,
        char **err_msg) {
    std::ostringstream log;
    std::ostringstream notice;
    std::ostringstream err;

    try {
        pgrouting::algorithm::TSP fn_tsp{coordinates, total_coordinates, true};

#if Boost_VERSION_MACRO >= 106800
        log << fn_tsp;
#endif
        auto tsp_path = fn_tsp.tsp(start_vid, end_vid);
        log << fn_tsp.get_log();

        if (!tsp_path.empty()) {
        *return_count = tsp_path.size();
        (*return_tuples) = pgr_alloc(tsp_path.size(), (*return_tuples));

        size_t seq{0};
        double total{0};
        for (const auto e : tsp_path) {
            total += e.second;
            General_path_element_t data {0, 0, 0, e.first, 0, e.second, total};
            (*return_tuples)[seq] = data;
            seq++;
        }
        }

        pgassert(!log.str().empty());
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
