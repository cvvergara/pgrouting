/*PGR-GNU*****************************************************************

FILE: TSP_driver.cpp

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

#include "drivers/tsp/TSP_driver.h"

#include <string>
#include <sstream>
#include <vector>
#include <algorithm>

#include "tsp/tsp.hpp"

#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"


namespace {
/*
 * TODO
 * probably these functions in this namespace are also good for euclideanTSP
 */

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
        Matrix_cell_t *distances,
        size_t total_distances,
        int64_t start_vid,
        int64_t end_vid,
        std::string &err) {
    auto where1= std::find_if(distances, distances + total_distances,
            [&](const Matrix_cell_t& row) {return row.from_vid == start_vid && row.to_vid == end_vid && row.cost !=0;});
    auto where2= std::find_if(distances, distances + total_distances,
            [&](const Matrix_cell_t& row) {return row.to_vid == start_vid && row.from_vid == end_vid && row.cost !=0;});
    if (where1 == distances + total_distances && where2 == distances + total_distances) {
        err = "Problem with the data [from_vid, to vid] does not exist";
        return 0;
    }
    /*
     * The values are supoosedly equal so grab one
     */
    auto special_cost = where1->cost;

    /*
     * To make them be adjacent setting cost to 0
     */
    where1->cost = where2->cost = 0;
    return special_cost;
}

}  // namespace

void
do_pgr_tsp(
        Matrix_cell_t *distances,
        size_t total_distances,
        int64_t start_vid,
        int64_t end_vid,

        double ,
        double ,
        double ,
        int64_t ,
        int64_t ,
        int64_t ,
        bool ,
        double ,

        General_path_element_t **return_tuples,
        size_t *return_count,
        char **log_msg,
        char **notice_msg,
        char **err_msg) {
    std::ostringstream log;
    std::ostringstream notice;
    std::ostringstream err;

    try {
        /*
         * TODO
         * check that the data the required characteristics
         * otherwise boost's algorithm might create a server crash
         */

        /*
         * giving and end_vid (no start_vid) is like giving a start_vid
         */
        if (start_vid == 0) std::swap(start_vid, end_vid);

        /*
         * when both start_vid, end_vid are given
         * data & results need to be prepared
         * - preparing for the data
         */
        double special_cost{0};
        if (start_vid != 0 && end_vid != 0) {
            std::string error;
            special_cost = setup_for_start_vid_and_end_vid(distances, total_distances, start_vid, end_vid, error);
            if (!error.empty()) {
                *err_msg = pgr_msg(err.str().c_str());
                return;
            }
        }

        pgrouting::algorithm::TSP fn_tsp{distances, total_distances};

#if Boost_VERSION_MACRO >= 106800
        log << fn_tsp;
#endif
        auto tsp_path = fn_tsp.tsp();
        log << fn_tsp.get_log();

        /*
         * results need to be organized when there is a start_vid or end_vid
         */
        if (start_vid != 0 && end_vid != 0) {
            tsp_path = start_vid_end_vid_are_fixed(tsp_path, start_vid, end_vid, special_cost);
        } else  if (start_vid != 0) {
            tsp_path = start_vid_is_fixed(tsp_path, start_vid);
        }

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
