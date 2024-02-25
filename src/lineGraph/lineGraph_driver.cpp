/*PGR-GNU*****************************************************************
File: lineGraph_driver.cpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2017 Vidhan Jain
Mail: vidhanj1307 at gmail.com

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

#include "drivers/lineGraph/lineGraph_driver.h"

#include <sstream>
#include <deque>
#include <vector>
#include <utility>
#include <string>

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "c_types/edge_rt.h"

namespace pgrouting {
namespace b_g {

using B_G_R = boost::adjacency_list<
    boost::vecS, boost::vecS, boost::undirectedS,
    pgrouting::Basic_vertex, pgrouting::Basic_edge>;

template<typename B_G>
B_G_R line_graph(const B_G& original, std::ostringstream &log) {

    using V = typename boost::graph_traits<B_G_R>::vertex_descriptor;
    using IndexMap = std::map<int64_t, V>;

    B_G_R result;
    IndexMap id_to_descriptor;

    auto o_edges = boost::edges(original);
    log << "cycle edges\n";
    for (auto e = o_edges.first; e != o_edges.second; ++e) {
        auto v = add_vertex(result);
        result[v].id = original[*e].id;
        log << " add vertex" << original[*e].id << "(" << v << ")\n";
        id_to_descriptor[original[*e].id] =  v;
        log << original[*e].id << " id_to_descriptor" << id_to_descriptor[original[*e].id] << "\n";
    }

    /* for (each vertex v in original graph) */
    auto vs = boost::vertices(original);
    for (auto vertexIt = vs.first; vertexIt != vs.second; vertexIt++) {
        auto vertex = *vertexIt;

        log << "original vertex" << vertex << ":\n";
        /* for( all incoming edges in to vertex v) */
        auto o_inedges = boost::in_edges(vertex, original);
        for (auto ine = o_inedges.first; ine != o_inedges.second; ++ine) {
            auto s = original[*ine].id;
            log << "in edge " << s << "\t";

            auto o_out_edges = boost::out_edges(vertex, original);
            for (auto eout = o_out_edges.first; eout != o_out_edges.second; ++eout) {
                /* for( all outgoing edges out from vertex v) */
                auto t = original[*eout].id;
                log << "out edge " << t << "\t";
                /*
                 *  Prevent self-edges from being created in the Line Graph
                 */
                if (s == t) continue;
                log << s <<","<< t<<"\n";
                auto rs = id_to_descriptor[s];
                auto rt = id_to_descriptor[t];
                log << rs <<","<< rt<<"\n";
                auto e = boost::add_edge(rs, rt, result);
                result[e.first].id = static_cast<int64_t>(num_edges(result));
                log << e.first << " added edge \n";
                log << e.first << " added edge " << result[e.first].id <<"\n";
            }
            log <<"\n";
        }
        log <<"\n";
    }
    return result;
}
/** @brief converts a bg to Edges_t
 * @param[in] bg the boost grah
 * @returns a set of Edges_t that exist on the graph
 *   id, source, target, cost, reverse_cost
 *   source < target
 */
template<typename G>
std::vector<Edge_t> graph_to_existing_edges(const G &bg, std::ostringstream &log) {
    std::vector<Edge_t> results;

    std::map<std::pair<int64_t, int64_t>, Edge_t> st_to_edge;
    int64_t count = 0;

    log << "\n";
    auto bg_edges = boost::edges(bg);
    for (auto e = bg_edges.first; e != bg_edges.second; ++e) {
        auto s = bg[boost::source(*e, bg)].id;
        auto t = bg[boost::target(*e, bg)].id;
        log << "out " << s <<", "<< t<<"\n";

        /*
         * Reverse edge already been added
         */
        if (st_to_edge.find({t, s}) != st_to_edge.end()) {
            st_to_edge[std::pair<int64_t, int64_t>(t, s)].reverse_cost = 1.0;
            continue;
        }

        /*
         * Already been added
         */
        if (st_to_edge.find({s, t}) != st_to_edge.end()) continue;

        st_to_edge[std::pair<int64_t, int64_t>(s, t)] = {++count, s, t, 1, -1};
    }

    log << "\n";
    for (const auto &st : st_to_edge) {
        results.push_back(st.second);
    }
    return results;
}

}  // namespace b_g
}  // namespace pgrouting

namespace {

#if 0
template<typename G>
std::vector<Edge_rt> get_postgres_results(const G &graph, std::ostringstream &log) {
    std::vector<Edge_rt> results;

    typename G::E_i  edgeIt, edgeEnd;
    std::map<std::pair<int64_t, int64_t>, Edge_rt> unique;
    int64_t count = 0;

    log << "\n";
    for (boost::tie(edgeIt, edgeEnd) = boost::edges(graph.graph); edgeIt != edgeEnd; edgeIt++) {
        typename G::E e = *edgeIt;
        auto s = graph[graph.source(e)].id;
        auto t = graph[graph.target(e)].id;
        log << s <<","<< t<<"\n";

        if (unique.find({t, s}) != unique.end()) {
            log << "t,s found\n";
            unique[std::pair<int64_t, int64_t>(t, s)].reverse_cost = 1.0;
            auto e1 = unique[std::pair<int64_t, int64_t>(t, s)];
            log << e1.id << ","<< e1.source <<","<< e1.target<<" rev\n";
            continue;
        }
        log << "t,s not found\n";

        if (unique.find({s, t}) != unique.end()) continue;

        //log << "s,t not found\n";
        Edge_rt edge = {++count, s, t, 1.0, -1.0 };
        unique[std::pair<int64_t, int64_t>(s, t)] = edge;
        auto e1 = unique[std::pair<int64_t, int64_t>(s, t)];
        log << e1.id << ","<< e1.source <<","<< e1.target<<" add\n";

    }
    log << "\n";
    for (const auto &e : unique) {
        log << e.second.id << "," << "\n";
        results.push_back(e.second);
    }
    return results;
}

template<typename G>
void my_add_edge(const int64_t &source, const int64_t &target, G& graph) {
    bool inserted;
    typename G::E e;

    auto vm_s = graph.get_V(source);
    auto vm_t = graph.get_V(target);

    boost::tie(e, inserted) = boost::add_edge(vm_s, vm_t, graph.graph);

    graph.graph[e].id = static_cast<int64_t>(graph.num_edges());
}
#endif

#if 0
template<typename G>
pgrouting::UndirectedGraph line_graph(const G& original, std::ostringstream &log) {
    auto lg_result = pgrouting::b_g::line_graph(original.graph, log);

    pgrouting::UndirectedGraph result(false);
    result.graph = lg_result;

    auto new_result = pgrouting::b_g::graph_to_existing_edges(lg_result, log);

    return result;
}
#endif

template<typename G>
std::vector<Edge_t> line_graph(const G& original, std::ostringstream &log) {
    auto lg_result = pgrouting::b_g::line_graph(original.graph, log);

    return pgrouting::b_g::graph_to_existing_edges(lg_result, log);
}

#if 0
template<typename B_G>
pgrouting::UndirectedGraph line_graph(const B_G& original, std::ostringstream &log) {
    pgrouting::UndirectedGraph result(true);
    auto o_edges = boost::edges(original);
    log << "cycle edges\n";
    for (auto e = o_edges.first; e != o_edges.second; ++e) {
        result.add_V(original[*e].id);
    }
    log << "empty" << result;

    /* for (each vertex v in original graph) */
    auto vs = boost::vertices(original);
    for (auto vertexIt = vs.first; vertexIt != vs.second; vertexIt++) {
        auto vertex = *vertexIt;

        /* for( all incoming edges in to vertex v) */
        auto o_inedges = boost::in_edges(vertex, original);
        for (auto ine = o_inedges.first; ine != o_inedges.second; ++ine) {
            log << vertex << ":\t";
            log << "in " << *ine << "\t";

            auto o_out_edges = boost::out_edges(vertex, original);
            for (auto eout = o_out_edges.first; eout != o_out_edges.second; ++eout) {
                /* for( all outgoing edges out from vertex v) */
                auto s = original[*ine].id;
                auto t = original[*eout].id;
                /*
                 *  Prevent self-edges from being created in the Line Graph
                 */
                if (s == t) continue;
                log << s <<","<< t<<"\n";
                my_add_edge(s, t, result);
                log << result;
            }
            log <<"\n";
        }
    }
    return result;
}
#endif


}  // namespace

void
pgr_do_lineGraph(
        char *edges_sql,

        bool directed,
        Edge_rt **return_tuples,
        size_t *return_count,
        char ** log_msg,
        char ** notice_msg,
        char ** err_msg) {
    using pgrouting::pgr_msg;
    using pgrouting::pgr_free;

    std::ostringstream log;
    std::ostringstream err;
    std::ostringstream notice;
    char *hint = nullptr;

    try {
        pgassert(!(*log_msg));
        pgassert(!(*notice_msg));
        pgassert(!(*err_msg));
        pgassert(!(*return_tuples));
        pgassert(*return_count == 0);


        hint = edges_sql;
        auto edges = pgrouting::pgget::get_edges(std::string(edges_sql), true, false);
        if (edges.empty()) {
            *notice_msg = pgr_msg("No edges found");
            *log_msg = hint? pgr_msg(hint) : pgr_msg(log.str().c_str());
            return;
        }
        hint = nullptr;

        std::vector<Edge_t> line_graph_edges;
        if (directed) {
            pgrouting::DirectedGraph ograph(true);
            ograph.insert_edges(edges);
            line_graph_edges = line_graph(ograph, log);
        } else {
            pgrouting::UndirectedGraph ograph(false);
            ograph.insert_edges(edges);
            line_graph_edges = line_graph(ograph, log);
        }

        auto count = line_graph_edges.size();

        if (count == 0) {
            (*return_tuples) = NULL;
            (*return_count) = 0;
            *log_msg = pgr_msg(log.str().c_str());
            return;
        };

        size_t sequence = 0;
        using pgrouting::pgr_alloc;
        (*return_tuples) = pgr_alloc(line_graph_edges.size(), (*return_tuples));

        for (const auto &e : line_graph_edges) {
            auto rev_c = directed? e.reverse_cost : -1;
            (*return_tuples)[sequence] = {e.id, e.source, e.target, e.cost, rev_c};
            sequence++;
        }
        (*return_count) = sequence;

        pgassert(*err_msg == NULL);
        *log_msg = log.str().empty()?  *log_msg : pgr_msg(log.str().c_str());
        *notice_msg = notice.str().empty()?  *notice_msg : pgr_msg(notice.str().c_str());
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    } catch (const std::string &ex) {
        *err_msg = pgr_msg(ex.c_str());
        *log_msg = hint? pgr_msg(hint) : pgr_msg(log.str().c_str());
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
