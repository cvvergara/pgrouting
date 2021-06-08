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

#if 0
namespace {

std::deque<std::pair<int64_t, double>>
reverse_path(std::deque<std::pair<int64_t, double>> tsp_path){
    std::reverse(tsp_path.begin(), tsp_path.end());
    double prev {0};
    for(auto &e : tsp_path) {
        std::swap(prev, e.second);
    }
    return tsp_path;
}


std::deque<std::pair<int64_t, double>>
start_vid_is_fixed(
        std::deque<std::pair<int64_t, double>> tsp_path,
        int64_t start_vid) {
    /*
     * locate the position
     * */
    auto where = std::find_if(tsp_path.begin(), tsp_path.end(),
            [&](std::pair<int64_t, double>& row){return row.first == start_vid;});

    /*
     * Nothing to do, it is already in its place
     */
    if (where == tsp_path.begin()) return tsp_path;

    tsp_path = reverse_path(tsp_path);

    tsp_path.pop_front();
    where = std::find_if(tsp_path.begin(), tsp_path.end(),
            [&](std::pair<int64_t, double>& row){return row.first == start_vid;});


    std::rotate(tsp_path.begin(), where, tsp_path.end());
    std::rotate(tsp_path.begin(), tsp_path.begin() + 1, tsp_path.end());
    tsp_path.push_front(std::make_pair(start_vid,0));
    return tsp_path;
}


std::deque<std::pair<int64_t, double>>
start_vid_end_vid_are_fixed(
        std::deque<std::pair<int64_t, double>> tsp_path,
        int64_t start_vid,
        int64_t end_vid,
        int64_t special_cost){
    /*
     * attach the correct cost value
     */
    auto where = std::find_if(tsp_path.begin(), tsp_path.end(),
            [&](std::pair<int64_t, double>& row){return row.first == start_vid || row.first == end_vid;});
    (where + 1)->second = special_cost;

    auto found_value = where->first;
    if (found_value == start_vid) {
        tsp_path = reverse_path(tsp_path);
    }

    tsp_path.pop_front();
    where = std::find_if(tsp_path.begin(), tsp_path.end(),
            [&](std::pair<int64_t, double>& row){return row.first == start_vid;});


    std::rotate(tsp_path.begin(), where, tsp_path.end());
    std::rotate(tsp_path.begin(), tsp_path.begin() + 1, tsp_path.end());
    tsp_path.push_front(std::make_pair(start_vid,0));
    return tsp_path;
}

double
setup_for_start_vid_and_end_vid(
        Coordinate_t *coordinates,
        size_t total_coordinates,
        int64_t start_vid,
        int64_t end_vid,
        std::string &err) {
    auto u = std::find_if(coordinates, coordinates + total_coordinates,
            [&](const Coordinate_t& row) {return row.id == start_vid;});
    auto v = std::find_if(coordinates, coordinates + total_coordinates,
            [&](const Coordinate_t& row) {return row.id == end_vid;});

    if (u == coordinates + total_coordinates && v == coordinates + total_coordinates) {
        err = "Something went wrong";
        return 0;
    }

    auto ux = u->x;
    auto uy = u->y;
    auto vx = v->x;
    auto vy = v->y;

    auto const dx = ux - vx;
    auto const dy = uy - vy;

    /*
     * weight is euclidean distance
     */
    return sqrt(dx * dx + dy * dy);
}

}  // namespace
#endif

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
            General_path_element_t data {0,0,0,e.first,0,e.second,total};
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
