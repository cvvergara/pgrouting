/*PGR-GNU*****************************************************************
File: kPathsWithPoints_driver.cpp

Copyright (c) 2026-2026 pgRouting developers
Mail: project@pgrouting.org

Design of one process & driver file by
Copyright (c) 2026 Celia Virginia Vergara Castillo
Mail: vicky at erosion.dev

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

#include "drivers/kPathsWithPoints_driver.hpp"

#include <sstream>
#include <deque>
#include <vector>
#include <string>

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/combinations.hpp"
#include "cpp_common/utilities.hpp"
#include "cpp_common/to_postgres.hpp"
#include "withPoints/withPoints.hpp"

#include "yen/yen.hpp"

namespace pgrouting {
namespace drivers {

void
do_kPathsWithPoints(
        const std::string &edges_sql,
        const std::string &points_sql,
        const std::string &combinations_sql,

        ArrayType *starts,
        ArrayType *ends,

        int64_t *start_vid,
        int64_t *end_vid,

        int k,
        char driving_side,

        bool directed,
        bool heap_paths,
        bool details,

        Which which,
        Path_rt* &return_tuples, size_t &return_count,
        std::ostringstream &log,
        std::ostringstream &notice,
        std::ostringstream &err) {


    std::string hint = "";

    try {
        if (edges_sql.empty()) {
            err << "Empty edges SQL";
            return;
        }

        if (points_sql.empty()) {
            err << "Empty points SQL";
        }

        if (k <= 0) {
            err << "Invalid value for k";
            return;
        }

        size_t K{static_cast<size_t>(k)};

        using pgrouting::pgget::get_edges;
        using pgrouting::pgget::get_points;
        using pgrouting::utilities::get_combinations;
        using pgrouting::to_postgres::get_tuples;
        using pgrouting::Path;
        using pgrouting::UndirectedGraph;
        using pgrouting::DirectedGraph;

        using pgrouting::algorithms::Yen;

        hint = combinations_sql;
        auto combinations = get_combinations(combinations_sql, starts, ends, true);
        hint = "";

        if (start_vid && end_vid) {
            combinations[*start_vid].insert(*end_vid);
        }

        if (combinations.empty() && !combinations_sql.empty()) {
            notice << "No (source, target) pairs found";
            log << combinations_sql;
            return;
        }

        std::string enop;
        std::string eofp;
        std::vector<Edge_t> edges;
        std::vector<Edge_t> edges_of_points;
        std::vector<Point_on_edge_t> points;

        if (points_sql.empty()) {
            hint = edges_sql;
            edges = get_edges(edges_sql, true, false);
            hint = "";
        } else {
            pgrouting::get_new_queries(edges_sql, points_sql, eofp, enop);

            hint = points_sql;
            points = get_points(points_sql);

            hint = eofp;
            edges_of_points = !eofp.empty()? get_edges(eofp, true, false) : std::vector<Edge_t>();

            hint = enop;
            edges = !enop.empty()? get_edges(enop, true, false) : std::vector<Edge_t>();
            hint = "";

            if (edges.empty() && edges_of_points.empty()) {
                notice << "No edges found";
                return;
            }
        }

        /*
         * processing points
         */
        pgrouting::Pg_points_graph pg_graph(points, edges_of_points,
                true,
                pgrouting::estimate_drivingSide(driving_side, which),
                directed);

        if (pg_graph.has_error()) {
            log << pg_graph.get_log();
            err << pg_graph.get_error();
            return;
        }
        auto new_edges = pg_graph.new_edges();

        edges.insert(edges.end(), new_edges.begin(), new_edges.end());

        if (edges.empty()) {
            notice << "No edges found";
            log << edges_sql;
            return;
        }
        hint = "";

        DirectedGraph digraph;
        UndirectedGraph undigraph;

        std::deque<Path> paths;
        if (directed) {
            digraph.insert_edges(edges);
            switch (which) {
                case KSPWITHPOINTS:
                    paths = Yen(digraph, combinations, K, heap_paths);
                    break;
                default:
                    err << "INTERNAL: wrong function call: " << which;
                    return;
            }
        } else {
            undigraph.insert_edges(edges);
            switch (which) {
                case KSPWITHPOINTS:
                    paths = Yen(undigraph, combinations, K, heap_paths);
                    break;
                default:
                    err << "INTERNAL: wrong function call: " << which;
                    return;
            }
        }


        if (!details) {
            for (auto &path : paths) path = pg_graph.eliminate_details(path);
        }

        return_count = get_tuples(paths, return_tuples);

        if (return_count == 0) {
            log << "No paths found";
        }
    } catch (AssertFailedException &except) {
        err << except.what();
    } catch (const std::pair<std::string, std::string>& ex) {
        err << ex.first;
        log << ex.second;
    } catch (const std::string &ex) {
        err << ex;
        log << hint;
    } catch (std::exception &except) {
        err << except.what();
    } catch (...) {
        err << "Caught unknown exception!";
    }
}

}  // namespace drivers
}  // namespace pgrouting
