/*PGR-GNU*****************************************************************
 * File: tsp_driver.h
 *
 * Generated with Template by:
 * Copyright (c) 2015 pgRouting developers
 * Mail: project@pgrouting.org
 *
 * Function's developer:
 * Copyright (c) 2021 Celia Virginia Vergara Castillo
 * Copyright (c) 2015 Celia Virginia Vergara Castillo
 * Mail: vicky_vergara@hotmail.com
 *
 * ------

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

#ifndef INCLUDE_DRIVERS_TSP_TSP_DRIVER_H_
#define INCLUDE_DRIVERS_TSP_TSP_DRIVER_H_
#pragma once

/* for size-t */
#ifdef __cplusplus
#   include <cstddef>
#else
#   include <stddef.h>
#endif

#include "c_types/matrix_cell_t.h"
typedef struct TSP_tour_rt TSP_tour_rt;


#ifdef __cplusplus
extern "C" {
#endif

void
do_pgr_tsp(
        Matrix_cell_t *distances, size_t total_distances,
        int64_t start_vid,
        int64_t end_vid,
        bool strict,

        TSP_tour_rt **results,
        size_t *total_results,
        char **log_msg,
        char **notice_msg,
        char **err_msg);

#ifdef __cplusplus
}
#endif

#endif  // INCLUDE_DRIVERS_TSP_TSP_DRIVER_H_
