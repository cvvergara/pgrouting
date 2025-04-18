/*PGR-GNU*****************************************************************
File: vehicle.hpp

Copyright (c) 2016 pgRouting developers
Mail: project@pgrouting.org

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

/*! @file */

#ifndef INCLUDE_VRP_VEHICLE_HPP_
#define INCLUDE_VRP_VEHICLE_HPP_
#pragma once

#include <deque>
#include <iostream>
#include <algorithm>
#include <string>
#include <tuple>
#include <utility>
#include <vector>
#include <cstdint>


#include "cpp_common/identifier.hpp"
#include "vrp/vehicle_node.hpp"
using Schedule_rt = struct Schedule_rt;

namespace pgrouting {
namespace vrp {

class Pgr_pickDeliver;

/*! @class Vehicle
 *  @brief Vehicle with time windows
 *
 * General functionality for a vehicle in a VRP problem
 *
 * Recommended use:
 *
 * ~~~~{.c}
 *   Class my_vehicle : public vechicle
 * ~~~~
 *
 * @note All members return @b true when the operation is successful
 *
 * A vehicle is a sequence of @ref Vehicle_node
 * from @b starting site to @b ending site.
 * has:
 * @b capacity
 * @b speed
 * @b factor TODO(vicky)
 *
 * @sa @ref Vehicle_node
 */

class Vehicle : public Identifier {
 protected:
     typedef size_t POS;
     using difference_type = std::deque<Vehicle_node>::difference_type;
     std::deque< Vehicle_node > m_path;

     friend class PD_problem;

 private:
     double m_capacity;
     double m_factor;
     double m_speed;

 public:
     /*
      * (twv, cv, fleet_size, wait_time, duration)
      */
     typedef std::tuple< int, int, size_t, double, double > Cost;
     std::vector<Schedule_rt>
           get_postgres_result(int vid) const;

     Vehicle(
             size_t idx,
             int64_t id,
             const Vehicle_node &starting_site,
             const Vehicle_node &ending_site,
             double p_capacity,
             double p_speed,
             double p_factor);


     bool is_phony() const {return id() < 0;}
     double speed() const;

     /*! @name deque like functions

       @returns True if the operation was performed
       @warning Assertions are performed for out of range operations
       @warning no feasability nor time window or capacity violations
       checks are performed
       @todo TODO more deque like functions here
       */

     /*! @brief Invariant
      * The path must:
      *   - have at least 2 nodes
      *   - first node of the path must be Start node
      *   - last node of the path must be End node
      *
      * path: S ..... E
      */
     void invariant() const;


     /// @{

     /*! @brief Insert @b node at @b pos position.
      *
      * @param[in] pos The position that the node should be inserted.
      * @param[in] node The node to insert.
      *
      */
     void insert(POS pos, Vehicle_node node);


     /*! @brief Insert @b node in best position of the @b position_limits.
      *
      * @param[in] position_limits
      * @param[in] node The node to insert
      *
      * @returns position where it was inserted
      */
     POS insert(std::pair<POS, POS> position_limits, const Vehicle_node &node);






     /*! @brief Erase node.id()
      *
      * @note start and ending nodes cannot be erased
      *
      * Numbers are positions
      * before: S .... node.id() .... E
      * after: S .... .... E
      *
      */
     void erase(const Vehicle_node &node);



     /*! @brief Erase node at `pos` from the path.
      *
      * @note start and ending nodes cannot be erased
      *
      * Numbers are positions
      * before: S 1 2 3 4 5 6 pos 8 9 E
      * after: S 1 2 3 4 5 6 8 9 E
      *
      * @param[in] pos to be erased.
      */
     void erase(POS pos);

     /*! @brief return true when no nodes are in the truck
      *
      * ~~~~{.c}
      * True: S E
      * False: S <nodes> E
      * ~~~~
      */
     bool empty() const;

     /*! @brief return number of nodes in the truck
      *
      * ~~~~{.c}
      * True: S E
      * False: S <nodes> E
      * ~~~~
      */
     size_t size() const;


     /// @{
     Cost cost() const;
     bool cost_compare(const Cost&, const Cost&) const;

     double duration() const {
         return m_path.back().departure_time();
     }
     double total_wait_time() const {
         return m_path.back().total_wait_time();
     }
     double total_travel_time() const {
         return m_path.back().total_travel_time();
     }
     double total_service_time() const {
         return m_path.back().total_service_time();
     }
     int twvTot() const {
         return m_path.back().twvTot();
     }
     int cvTot() const {
         return m_path.back().cvTot();
     }
     bool has_twv() const {
         return twvTot() != 0;
     }
     bool has_cv() const {
         return cvTot() != 0;
     }

     bool is_feasable() const {
         return !(has_twv() ||  has_cv());
     }

     bool is_ok() const;

     Vehicle_node start_site() const {
         return m_path.front();
     }
     Vehicle_node end_site() const {
         return m_path.back();
     }
     double capacity() const {return m_capacity;}
     /// @}



     /*!
      * @brief Swap two nodes in the path.
      *
      * ~~~~{.c}
      * Before: S <nodesA> I <nodesB> J <nodesC> E
      * After: S <nodesA> J <nodesB> I <nodesC> E
      * ~~~~
      *
      * @param[in] i The position of the first node to swap.
      * @param[in] j The position of the second node to swap.
      */
     void swap(POS i, POS j);


     /*! @name Evaluation
      *
      *
      *
      * Path evaluation is done incrementally: from a given position to the
      * end of the path, and intermediate values are cached on each node.
      * So, for example, changing the path at position 100:
      * the evaluation function should be called as
      * @c evaluate(100, maxcapacity)
      * and from that position to the end of the path will be evaluated.
      * None of the "unaffected" positions get reevaluated
      *
      *
      *
      */

     ///@{

     /*! @brief Evaluate: Evaluate the whole path from the start. */
     void evaluate();

     /*! @brief Evaluate: Evaluate a path from the given position.
      *
      * @param[in] from The starting position in the path for evaluation to
      * the end of the path.
      */
     void evaluate(POS from);

     ///@}




     /*! @name accessors */
     ///@{

     std::deque< Vehicle_node > path() const;

     ///@}

     /*! @name operators */
     ///@{


     friend std::ostream& operator << (std::ostream &log, const Vehicle &v);

     std::string tau() const;

     friend bool operator<(const Vehicle &lhs, const Vehicle &rhs);

     ///@}



     std::pair<POS, POS> position_limits(const Vehicle_node node) const;
     std::pair<POS, POS> drop_position_limits(const Vehicle_node node) const;

     /** Pointer to problem */
     static Pgr_pickDeliver* problem;

     /** @brief Access to the problem's message */
     static Pgr_messages& msg();

 private:
     POS getDropPosLowLimit(const Vehicle_node &node) const;
     POS getPosLowLimit(const Vehicle_node &node) const;
     POS getPosHighLimit(const Vehicle_node &node) const;
};

}  // namespace vrp
}  // namespace pgrouting

#endif  // INCLUDE_VRP_VEHICLE_HPP_
