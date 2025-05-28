/*PGR-GNU*****************************************************************
File: dijkstra.c

Function's developer:
Copyright (c) 2025 Celia Virginia Vergara Castillo
Mail: vicky_vergara at erosion.dev

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

#include "process/dijkstra_process.h"

extern "C" {
#include "c_common/postgres_connection.h"
#include "c_common/e_report.h"
#include "c_common/time_msg.h"
}

#include "c_types/path_rt.h"
#include "cpp_common/assert.hpp"
#include "drivers/dijkstra/dijkstra_driver.h"

/**
 which function is determined by the parameters

 This is c++ code, linked as C code, because pgr_process_dijkstra is called from C code
 */
void pgr_process_dijkstra(
        const char *edges_sql,
        const char *points_sql,
        const char *combinations_sql,

        ArrayType *starts,
        ArrayType *ends,

        bool directed,
        bool only_cost,
        bool normal,

        int64_t n_goals,
        bool global,

        const char *driving_side,
        bool details,

        Path_rt **result_tuples,
        size_t *result_count) {
    pgassert(edges_sql);
    pgassert(!(*result_tuples));
    pgassert(*result_count == 0);
    pgr_SPI_connect();
    char* log_msg = NULL;
    char* notice_msg = NULL;
    char* err_msg = NULL;

    clock_t start_t = clock();
    pgr_do_dijkstra(
            edges_sql,
            points_sql,
            combinations_sql,
            starts, ends,

            directed,
            only_cost,
            normal,

            n_goals,
            global,

            driving_side[0],
            details,

            result_tuples, result_count,
            &log_msg,
            &notice_msg,
            &err_msg);

    if (only_cost) {
        if (n_goals > 0) {
            time_msg("processing pgr_dijkstraNearCost", start_t, clock());
        } else {
            if (points_sql) {
                time_msg("processing pgr_withPointsCost", start_t, clock());
            } else {
                time_msg("processing pgr_dijkstraCost", start_t, clock());
            }
        }
    } else {
        if (n_goals > 0) {
            time_msg("processing pgr_dijkstraNear", start_t, clock());
        } else {
            if (points_sql) {
                time_msg("processing pgr_withPoints", start_t, clock());
            } else {
                time_msg("processing pgr_dijkstra", start_t, clock());
            }
        }
    }

    if (err_msg && (*result_tuples)) {
        pfree(*result_tuples);
        (*result_tuples) = NULL;
        (*result_count) = 0;
    }

    pgr_global_report(&log_msg, &notice_msg, &err_msg);

    pgr_SPI_finish();
}
