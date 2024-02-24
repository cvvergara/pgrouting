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

#if 0
#include "cpp_common/linear_directed_graph.hpp"
#include "lineGraph/pgr_lineGraph.hpp"
#endif
namespace {

void get_postgres_result(
        const std::vector<Edge_rt> &edge_result,
        Edge_rt **return_tuples,
        size_t &sequence) {
    using pgrouting::pgr_alloc;
    (*return_tuples) = pgr_alloc(edge_result.size(), (*return_tuples));

    for (const auto &edge : edge_result) {
        (*return_tuples)[sequence] = {edge.id, edge.source, edge.target, edge.cost, edge.reverse_cost};
        sequence++;
    }
}

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

#if 0
        e_source *= -1;
        e_target *= -1;
        if (unique.find({e_target, e_source}) != unique.end()) {
            unique[std::pair<int64_t, int64_t>(e_target,
                    e_source)].reverse_cost = 1.0;
            continue;
        }
        e_source *= -1;
        e_target *= -1;

        Edge_rt edge = { ++count, e_source, e_target, 1.0, -1.0 };
        unique[std::pair<int64_t, int64_t>(e_source, e_target)] = edge;
#endif
    }
#if 1
    log << "\n";
    for (const auto &e : unique) {
        log << e.second.id << "," << "\n";
        results.push_back(e.second);
    }
#endif
    return results;
}

template<typename G, typename T_V, typename T_E>
void my_add_edge(const int64_t &source, const int64_t &target, G& graph) {
    bool inserted;
    typename G::E e;

    auto vm_s = graph.get_V(source);
    auto vm_t = graph.get_V(target);

    boost::tie(e, inserted) = boost::add_edge(vm_s, vm_t, graph.graph);

    graph.graph[e].id = static_cast<int64_t>(graph.num_edges());
}

#if 0
template<typename B_G>
void line_graph(const B_G& original, pgrouting::UndirectedGraph& graph, std::ostringstream &log) {
    typename G::V_i vertexIt, vertexEnd;
    typename G::EO_i e_outIt, e_outEnd;
    typename G::EI_i e_inIt, e_inEnd;

    auto es = boost::edges(original.graph);
    log << "cycle edges\n";
    for (auto eit = es.first; eit != es.second; ++eit) {
        log << boost::source(*eit, original.graph) << ' ' << boost::target(*eit, original.graph) << std::endl;
        log << original.graph[*eit].id << "\n";
        graph.add_V(original[*eit].id);
    }
    log << "end cycle edges\n";
    log << graph;

    /* for (each vertex v in original graph) */
    for (boost::tie(vertexIt, vertexEnd) = boost::vertices(original.graph); vertexIt != vertexEnd; vertexIt++) {
        auto vertex = *vertexIt;

        /* for( all incoming edges in to vertex v) */
        for (boost::tie(e_outIt, e_outEnd) = boost::out_edges(vertex, original.graph); e_outIt != e_outEnd; e_outIt++) {

            /* for( all outgoing edges out from vertex v) */
            for (boost::tie(e_inIt, e_inEnd) = boost::in_edges(vertex, original.graph); e_inIt != e_inEnd; e_inIt++) {
                /*
                 *  TODO Prevent self-edges from being created in the Line Graph
                 */
                auto s = graph.graph[*e_inIt].id;
                auto t = graph.graph[*e_outIt].id;
                if (s == t) continue;
                log << s <<","<< t<<"\n";
                my_add_edge<pgrouting::UndirectedGraph, pgrouting::Basic_vertex, pgrouting::Basic_edge>(s, t, graph);
            }
        }
    }
}
#endif

template<typename G>
pgrouting::UndirectedGraph line_graph(const G& original, std::ostringstream &log) {
    typename G::V_i vertexIt, vertexEnd;
    typename G::EO_i e_outIt, e_outEnd;
    typename G::EI_i e_inIt, e_inEnd;

    pgrouting::UndirectedGraph result(false);
    auto es = boost::edges(original.graph);
    log << "cycle edges\n";
    for (auto eit = es.first; eit != es.second; ++eit) {
        result.add_V(original[*eit].id);
    }
    log << result;

    /* for (each vertex v in original graph) */
    for (boost::tie(vertexIt, vertexEnd) = boost::vertices(original.graph); vertexIt != vertexEnd; vertexIt++) {
        auto vertex = *vertexIt;

        /* for( all incoming edges in to vertex v) */
        for (boost::tie(e_outIt, e_outEnd) = boost::out_edges(vertex, original.graph); e_outIt != e_outEnd; e_outIt++) {

            /* for( all outgoing edges out from vertex v) */
            for (boost::tie(e_inIt, e_inEnd) = boost::in_edges(vertex, original.graph); e_inIt != e_inEnd; e_inIt++) {
                /*
                 *  TODO Prevent self-edges from being created in the Line Graph
                 */
                auto s = result.graph[*e_inIt].id;
                auto t = result.graph[*e_outIt].id;
                if (s == t) continue;
                log << s <<","<< t<<"\n";
                my_add_edge<pgrouting::UndirectedGraph, pgrouting::Basic_vertex, pgrouting::Basic_edge>(s, t, result);
            }
        }
    }
    return result;
}

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

#if 1
        pgrouting::UndirectedGraph ograph(false);
        ograph.insert_edges(edges);
#else
        pgrouting::DirectedGraph ograph(true);
        ograph.insert_edges(edges);
#endif
        log << ograph;

#if 1
        auto graph = line_graph<pgrouting::UndirectedGraph>(ograph, log);
#else
        line_graph<pgrouting::DirectedGraph>(ograph, graph, log);
#endif
        auto line_graph_edges = get_postgres_results(graph, log);

        auto count = line_graph_edges.size();

        if (count == 0) {
            (*return_tuples) = NULL;
            (*return_count) = 0;
            notice << "Only vertices graph";
        } else {
            size_t sequence = 0;

            get_postgres_result(
                line_graph_edges,
                return_tuples,
                sequence);
            (*return_count) = sequence;
        }
        pgassert(*err_msg == NULL);
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
