/*PGR-GNU*****************************************************************
File: kPaths_driver.cpp

Copyright (c) 2013-2026 pgRouting developers
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

#include "drivers/kPaths_driver.hpp"

#include <sstream>
#include <deque>
#include <vector>
#include <utility>
#include <string>

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/combinations.hpp"
#include "cpp_common/utilities.hpp"
#include "cpp_common/to_postgres.hpp"

#include "yen/yen.hpp"

namespace pgrouting {
namespace drivers {

void
do_ksp(
        const std::string &edges_sql,
        const std::string &combinations_sql,
        ArrayType *starts,
        ArrayType *ends,

        int64_t *start_vid,
        int64_t *end_vid,

        size_t k,
        bool directed,
        bool heap_paths,

        Which which,
        Path_rt* &return_tuples, size_t &return_count,
        std::ostringstream &log,
        std::ostringstream &notice,
        std::ostringstream &err) {
    using pgrouting::Path;

    std::string hint = "";

    try {
        if (edges_sql.empty()) {
            err << "Empty edges SQL";
            return;
        }

        if (k <= 0) {
            err << "Invalid value for k";
            return;
        }

        using pgrouting::pgget::get_edges;
        using pgrouting::utilities::get_combinations;
        using pgrouting::to_postgres::get_tuples;

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

        hint = edges_sql;
        auto edges = get_edges(std::string(edges_sql), true, false);

        if (edges.empty()) {
            notice << "No edges found";
            log << edges_sql;
            return;
        }
        hint = "";


        DirectedGraph digraph;
        UndirectedGraph undigraph;

        std::deque<Path>paths;

        if (directed) {
            digraph.insert_min_edges_no_parallel(edges);
            switch (which) {
                case KSP:
                    paths = Yen(digraph, combinations, k, heap_paths);
                    break;
                default:
                    err << "INTERNAL: wrong function call: " << which;
                    return;
            }
        } else {
            undigraph.insert_min_edges_no_parallel(edges);
            switch (which) {
                case KSP:
                    paths = Yen(undigraph, combinations, k, heap_paths);
                    break;
                default:
                    err << "INTERNAL: wrong function call: " << which;
                    return;
            }
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
