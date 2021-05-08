/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad_bh.qc  "low level squad member behavior"           */
/*      author(s): William van der Sterren                                  */
/*      version  : 0.5                                                      */
/*                                                                          */
/*      date (last revision):  Sep 08, 97                                   */
/*      date (creation)     :  Sep 08, 97                                   */
/*                                                                          */
/*                                                                          */
/*      revision history                                                    */
/*      -- date ---- | -- revision ---------------------- | -- revisor --   */
/*                   |                                    |                 */
/*                                                                          */
/****************************************************************************/

//
// Squad behavior
//

// prototypes - local functions



// implementation

// Squad_EveryFrame    - checks and updates, independent of the
//                       current state
//
//
void() Squad_EveryFrame =
{ // lava / slime processing
  if (self.watertype2 == CONTENT_LAVA)
    { T_Damage (self, world, world, 1.5*self.waterlevel);
      if (Squad_GetState(self) == SQUAD_MEMBERPATROL)
        self.think = self.th_run;
    }
  else if (self.watertype2 == CONTENT_SLIME)
    { T_Damage (self, world, world, 0.5*self.waterlevel);
      if (Squad_GetState(self) == SQUAD_MEMBERPATROL)
        self.think = self.th_run;
    }
};



// Squad_Behavior_Move  - checks for jumping/dropping, and moves
//
//
//
void (float dist) Squad_Behavior_Move =
{ // execute walking / running
  norse_movetogoal(dist);

  // update yaw (using self.velocity), if not jumping
  if (!(self.flags & FL_ONGROUND))    // was: FL_JUMPRELEASED
    self.angles_y = vectoyaw(self.velocity);

  // Roscoe Sincero code
  if (!(self.flags & FL_ONGROUND))
    self.jump_flag = self.velocity_z;

  if (self.flags & FL_WATERJUMP)
    { if (self.waterlevel <1)
         self.flags = self.flags - FL_WATERJUMP;
    }
  // correct any "stuck" bots - that is bots having
  // a "zero" velocity and either flying (not on ground
  // on platform), or stuck in the ground/platform
  local float f_speed;
  f_speed = vlen(self.velocity);
  if (f_speed < 0.01)
  { // test for bots that got stuck in the ground
    if (pointcontents(Squad_MemberFeetPosition(self)) == CONTENT_SOLID)
      { // raise bot a bit
        //bprint(self.netname);
        //bprint(" stuck in the ground\n");
        local vector neworigin;
        neworigin   = self.origin;
        neworigin_z = neworigin_z + 16;
        setorigin(self, neworigin);
      }
    // test for floating bots
    if (!(self.flags & FL_ONGROUND))
      { //bprint(self.netname);
        //bprint(" stuck in the air\n");
        // case: standing on top of each other?
        traceline(self.origin, self.origin - '0 0 200', FALSE, self);
        if (trace_ent != world)
        if (trace_ent != self)
        if ((trace_ent.classname == "bot") ||
            (trace_ent.classname == "door")
           )
          { // standing on top!
            //bprint("- tries jump\n");
            self.velocity_z = 100;
            self.velocity_x = 80 * (random() - 0.5);
            self.velocity_y = 80 * (random() - 0.5);
            return;
          }
        else
          { //bprint("- drop to floor\n");
            droptofloor();
          }
      }
  }
};



// Squad_Behavior_Strafe  - lightweight implementation of strafe,
//                          no checks
//
//
void (float dist) Squad_Behavior_Strafe =
{ if (self.squadStrafeDirection == SQUAD_STRAFE_DIRECTION_RIGHT)
    walkmove(self.angles_y - 90, dist);
  else
    walkmove(self.angles_y + 90, dist);
};





// Squad_Behavior_ReachedWaypoint - executed by waypoint upon touch by
//                                  bot (if patrolling)
//
//
void (entity member, entity point) Squad_Behavior_ReachedWaypoint =
{ // update last visited waypoint
  if (member.squadPreviousWaypoint != point)
    { member.squadPreviousWaypoint = point;
      // notify team coordination
      Squad_Team_UpdateMemberPosition(member, point);
    }

  // prevent check
  member.dest1_z = time;

  // in case member is patrolling, have member select next waypoint
  // also in case member is spreading out but currently following waypoints
  if ((member.squadmemberstate == SQUAD_MEMBERPATROL)        ||
      (member.squadmemberstate == SQUAD_MEMBERRUNTOHELP)     ||
      ((member.squadmemberstate == SQUAD_MEMBERSPREAD) &&
       (member.movetarget.classname == "waypoint")
      )
     )
    Squad_Behavior_SelectNextWaypoint(member, point);

  // in case of run for cover, enter state RUNFORCOVER again
  if (member.squadmemberstate == SQUAD_MEMBERRUNFORCOVER)
    { // hack, have member fake a different state to
      // force state change to have effect
      member.squadmemberstate = SQUAD_MEMBERPATROL;
      Squad_SetState(member, SQUAD_MEMBERRUNFORCOVER);
    }
};




// Squad_Behavior_SelectNextWaypoint - have member select next waypoint,
//                                     depending on his state and
//                                     the waypoint.
//
void (entity member, entity point) Squad_Behavior_SelectNextWaypoint =
{ local entity new_waypoint;
  // reset search time
  member.search_time = time;
  if (member.squadWaypointDirection == SQUAD_WAYPOINT_DIRECTION_POS)
    { new_waypoint = Waypoint_Next(point); }
  else
    { new_waypoint = Waypoint_Previous(point); }

  // test if waypoint just has been visited
  if (member.movetarget == new_waypoint)
      return;

  // more timeconsuming tests
  if (Waypoint_GetVisitingDirection(point) == WAYPOINT_POSITIVE_DIR_ONLY)
    { member.squadWaypointDirection = SQUAD_WAYPOINT_DIRECTION_POS;
      new_waypoint = Waypoint_Next(point);
    }
  else
  if (Waypoint_GetVisitingDirection(point) == WAYPOINT_NEGATIVE_DIR_ONLY)
    { member.squadWaypointDirection = SQUAD_WAYPOINT_DIRECTION_NEG;
      new_waypoint = Waypoint_Previous(point);
    }

  member.movetarget = new_waypoint;

  // toggle visibility of previous waypoint
  if (WAYPOINT_DEBUG)
    { Waypoint_Hide(point); }

  member.goalentity = member.movetarget;

  // adjust yaw accordingly
  member.ideal_yaw = vectoyaw(point.origin - member.origin);

  if (WAYPOINT_DEBUG)
    { Waypoint_Show(member.movetarget);
    }
};



// Squad_Behavior_ReselectWaypoint - after deviation from FollowWaypoints
//                                   find furthest nearby waypoint
//                                   taking into account the visit direction
//
void (entity member) Squad_Behavior_ReselectWaypoint =
{ // prevent some norse_movement errors
  member.movedir = '0 0 0';

  // oops, a difficult method to implement
  //
  // Basically, try to find a waypoint that is "on route",
  // preferably the next waypoint to be visited, given
  // the last waypoint, visiting direction and current position.
  //
  // The bot may have wandered a bit to pick up some stuff or
  // to disable some enemy.
  // The bot may also have no previous waypoint defined (world)
  // or the bot may have arrived in different contents (water,
  // slime, lava). In that case, try to find an exit by looking
  // solely for waypoints in the same contents.


  local entity current;      // last waypoint visited (or: world)
  local entity nearest;      // nearest waypoint in same contents
  local entity next;         // next waypoint on route
  local entity destination;  // the chosen waypoint

  current = member.squadPreviousWaypoint;
  nearest = Waypoint_NearestInContents(member);

  // nearest may be world if member is being dropped through solid
  if (nearest == world)
    nearest = Waypoint_Nearest(member);

  // correct case "current == world"
  if (current == world)
    current = nearest;

  // determine what next waypoint would be, given current
  // waypoint and visiting direction
  if (member.squadWaypointDirection == SQUAD_WAYPOINT_DIRECTION_POS)
    next     = Waypoint_Next(current);
  else
    next     = Waypoint_Previous(current);

  // now, up to 3 candidates are available:
  // - current, next and nearest (which might "overlap")

  // rule 0: current is a valid alternative
  destination = current;

  // rule 1: if first time in water, slime or lava, select nearest
  //         "first time" can be determined from pointcontents of current
  local vector feet_pos;
  local float  current_contents, previous_contents;
  feet_pos          = Squad_MemberFeetPosition(member);
  previous_contents = pointcontents(current.origin);
  current_contents  = pointcontents(feet_pos);

  if ((previous_contents != current_contents)
      &&
      ((current_contents == CONTENT_WATER) ||
       (current_contents == CONTENT_SLIME) ||
       (current_contents == CONTENT_LAVA)
      )
     )
    { destination = nearest;
    }
  else
    { // rule 2: if nearest different from current and quite close,
      //         and reachable, it is safe to choose nearest
      if ((current != nearest) &&
          (Waypoint_IsVisible(nearest, member))
         )
        { local float n_dist;
          n_dist = vlen(member.origin - nearest.origin);
          if (n_dist < 400)
            destination = nearest;
        }
      else
        { // rule 3: next is the one to choose if closer to next
          // than distance current - next
          local float dist_cur_nxt;
          local float dist_me_nxt;
          dist_cur_nxt = vlen(current.origin - next.origin);
          dist_me_nxt  = vlen(member.origin - next.origin);
          if (dist_me_nxt < dist_cur_nxt)
            destination = next;



          /*
          // rule 3: next might be more attractive because it is "en route"
          //         it is safe to select next if it very near, or member
          //         member is near to line between current and next
          if (Waypoint_IsVisible(next, member))
            { local float n_dist;
              n_dist = vlen(member.origin - next.origin);
              if (n_dist < 500)
                destination = next;
            }
          // do a binary search to get to the closest point on line
          // between current and next
          if (current != next)
            { local float  stepcount;
              local vector left, right, delta;
              stepcount = 10;
              left      = current.origin;
              right     = next.origin;
              while (stepcount > 0)
                { stepcount = stepcount - 1;
                  delta = right - left;
                  if (vlen(member.origin - left) < vlen(member.origin - right))
                    right = left + 0.5 * delta;
                  else
                    left  = left + 0.5 * delta;
                }
              // now, both left and right are quite close to member...
              // ... and still on the line current - next
              // do not weigh vertical distance that much
              delta = member.origin - left;
              delta_z = 0.25 * delta_z;
              if (vlen(delta) < 400)
                  destination = next;
            }
            */
        }
    }

  member.goalentity = destination;
  member.movetarget = destination;

  // adjust yaw accordingly
  member.ideal_yaw = vectoyaw(destination.origin - member.origin);
  member.angles_y = member.ideal_yaw;

  //debug
/*
  bprint(member.netname);
  bprint(" reselects [");
  bprint(current.netname);
  bprint(", ");
  bprint(next.netname);
  bprint(", ");
  bprint(nearest.netname);
  bprint("] -> ");
  bprint(destination.netname);
  bprint("\n");
*/
};




// Squad_Behavior_ReselectOtherWaypoint
//                                 - after deviation from FollowWaypoints
//                                   find furthest nearby waypoint
//                                   taking into account the visit direction,
//                                   while excluding excludedWaypoint
//
void (entity member, entity excludedWaypoint)
Squad_Behavior_ReselectOtherWaypoint =
{ Squad_Behavior_ReselectWaypoint(member);
  if (member.goalentity == excludedWaypoint)
    { // depending on visit direction select "previous"
      local entity previous;
      if (member.squadWaypointDirection == SQUAD_WAYPOINT_DIRECTION_NEG)
        previous = Waypoint_Next(excludedWaypoint);
      else
        previous = Waypoint_Previous(excludedWaypoint);

      member.goalentity = previous;
      member.movetarget = previous;

      // adjust yaw accordingly
      member.ideal_yaw = vectoyaw(previous.origin - member.origin);
      member.angles_y = member.ideal_yaw;
    }
};




// Squad_Behavior_DetermineWaypointDirection
//                                 - determine, based on game and team
//                                   settings, which direction to go.
//
//
void (entity member) Squad_Behavior_DetermineWaypointDirection =
{ // determine waypoint visit order (50% unchanged, 25% either direction)
  local float r;
  r = random();
  // in case of MISSION_STARTTOEXIT, MISSION_EXITTOSTART,
  // do not change visit direction
  if (!Squad_Game_IsInfiltrate()
     )
    { if ((r < 0.25) || (coop))
        member.squadWaypointDirection = SQUAD_WAYPOINT_DIRECTION_POS;
      else
      if (r < 0.5)
        member.squadWaypointDirection = SQUAD_WAYPOINT_DIRECTION_NEG;
    }
};




// Squad_Behavior_WaypointNodeDistance - returns the number of
//                         waypoints that should be visited by member1 to
//                         arrive near member2; returns negative numbers
//                         if member1 should change direction to
//                         arrive near member2;
float (entity member1, entity member2) Squad_Behavior_WaypointNodeDistance =
{ // first determine waypoints closest to memberX
  local entity waypoint1, waypoint2;
  waypoint1 = Waypoint_Nearest(member1);
  if (!Waypoint_IsVisible(waypoint1, member1))
    waypoint1 = member1.squadPreviousWaypoint;

  waypoint2 = Waypoint_Nearest(member2);
  if (!Waypoint_IsVisible(waypoint2, member2))
    waypoint2 = member2.squadPreviousWaypoint;

  // now, try to move from waypoint1 to waypoint2
  // (in upto SQUAD_MAX_NODES_SEARCH steps)
  local float  steps;
  local float  direction;
  local entity point;
  direction = member1.squadWaypointDirection;
  steps = 0;
  point = waypoint1;
  while ((steps < SQUAD_MAX_NODES_SEARCH) &&
         (point != waypoint2)
        )
    { if (direction == SQUAD_WAYPOINT_DIRECTION_POS)
        point = Waypoint_Next(point);
      else
        point = Waypoint_Previous(point);
      steps = steps + 1;
    }

  // return if member1 can reach member2
  if (steps < SQUAD_MAX_NODES_SEARCH)
    { /*
      bprint("Waypoint distance (");
      bprint(member1.netname);
      bprint(", ");
      bprint(member2.netname);
      bprint(") = ");
      bprint(ftos(steps));
      bprint("\n");
      */
      return steps;
    }

  // else try in reverse direction
  steps = 0;
  point = waypoint1;
  while ((steps < SQUAD_MAX_NODES_SEARCH) &&
         (point != waypoint2)
        )
    { if (direction == SQUAD_WAYPOINT_DIRECTION_POS)
        point = Waypoint_Previous(point);
      else
        point = Waypoint_Next(point);
      steps = steps + 1;
    }

  // return if member1 can reach member2 in reverse direction
  if (steps < SQUAD_MAX_NODES_SEARCH)
    { steps = -1 * steps;
      /*
      bprint("Waypoint distance (");
      bprint(member1.netname);
      bprint(", ");
      bprint(member2.netname);
      bprint(") = ");
      bprint(ftos(steps));
      bprint("\n");
      */
      return steps;
    }

  // swap waypoint1, waypoint2
  point = waypoint1; waypoint1 = waypoint2; waypoint2 = point;

  // now, try to move from waypoint1 to waypoint2
  // (in upto SQUAD_MAX_NODES_SEARCH steps)
  local float  steps;
  local float  direction;
  local entity point;
  direction = member1.squadWaypointDirection;
  steps = 0;
  point = waypoint1;
  while ((steps < SQUAD_MAX_NODES_SEARCH) &&
         (point != waypoint2)
        )
    { if (direction == SQUAD_WAYPOINT_DIRECTION_POS)
        point = Waypoint_Next(point);
      else
        point = Waypoint_Previous(point);
      steps = steps + 1;
    }

  // return if member2 can reach member1
  if (steps < SQUAD_MAX_NODES_SEARCH)
    { return steps * -1.0;
    }

  // else try in reverse direction
  steps = 0;
  point = waypoint1;
  while ((steps < SQUAD_MAX_NODES_SEARCH) &&
         (point != waypoint2)
        )
    { if (direction == SQUAD_WAYPOINT_DIRECTION_POS)
        point = Waypoint_Previous(point);
      else
        point = Waypoint_Next(point);
      steps = steps + 1;
    }

  // return if member2 can reach member1
  if (steps < SQUAD_MAX_NODES_SEARCH)
    { return steps;
    }

  return SQUAD_MAX_NODES_SEARCH;
};



// Squad_Behavior_TrySit    - depending on the .mdl used for member
//                            and the current state, the posture will
//                            be set to sit or remain unchanged
//
void (entity member) Squad_Behavior_TrySit =
{ // return if already sitting
  if (Squad_GetPosture(member) == SQUAD_POSTURE_SIT)
    return;
  // return if .mdl does not have sitting animations
  if (Squad_GetRole(member) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // allow sit while waiting, spotting or attacking
      if ((Squad_GetState(member) == SQUAD_MEMBERWAIT)  ||
          (Squad_GetState(member) == SQUAD_MEMBERGUARD) ||
          (Squad_GetState(member) == SQUAD_MEMBERATTACK)
         )
       Squad_SetPosture(member, SQUAD_POSTURE_SIT);
    }
  else
    { // allow sit while waiting, spotting or attacking
      if ((Squad_GetState(member) == SQUAD_MEMBERWAIT)  ||
          (Squad_GetState(member) == SQUAD_MEMBERGUARD) ||
          (Squad_GetState(member) == SQUAD_MEMBERATTACK)
         )
        { Squad_SetPosture(member, SQUAD_POSTURE_SIT);
        }
    }
};

