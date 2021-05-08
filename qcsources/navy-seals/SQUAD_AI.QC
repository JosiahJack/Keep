/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad_ai.qc "high level behavior for members"            */
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

// Squad_AI_HeadForMarker - sets yaw for bot to go to marker
//                          location
//
//
void (entity member) Squad_AI_HeadForMarker =
{ member.ideal_yaw
    = vectoyaw(member.squadmarker.origin - member.origin);
};



// Squad_AI_Wait - if state == SQUAD_MEMBERWAIT
//                   changes state to squadmembernextstate if
//                   time > self.search_time
//                 if state == SQUAD_MEMBERGUARD
//                   spot a certain field around squadSpotYaw;
//                   if squadSpotYaw > 360, turn right, otherwise
//                      turn left
void () Squad_AI_Wait =
{ if (Squad_GetState(self) == SQUAD_MEMBERWAIT)
    { if (time > self.search_time)
        Squad_SetState(self, self.squadmembernextstate);
      return;
    }

  if (Squad_GetState(self) == SQUAD_MEMBERGUARD)
    { if (Squad_GetPosture(self) == SQUAD_POSTURE_STAND)
        { // test if rotated through sector, and change direction
          local float endangle;
          if (self.squadSpotAngles_z == SQUAD_TURNRIGHT)
            { endangle = anglemod(self.squadSpotAngles_y
                                  + self.squadSpotAngles_x);
            }
          else
            { endangle = anglemod(self.squadSpotAngles_y
                                  - self.squadSpotAngles_x);
            }
          // test if very near to endangle
          if (anglemod(self.angles_y - endangle) < SQUAD_ROTATIONSTEP)
            { // change turn direction
              if (self.squadSpotAngles_z == SQUAD_TURNRIGHT)
                self.squadSpotAngles_z = SQUAD_TURNLEFT;
              else
                self.squadSpotAngles_z = SQUAD_TURNRIGHT;
            }

          // now perform actual rotation
          if (self.squadSpotAngles_z == SQUAD_TURNRIGHT)
            self.angles_y = anglemod(self.angles_y + SQUAD_ROTATIONSTEP);
          else
            self.angles_y = anglemod(self.angles_y - SQUAD_ROTATIONSTEP);
        }
    }
  else
  if (Squad_GetState(self) == SQUAD_MEMBERAMBUSH)
    { local float dummy;
    }

  // all remaining states
  // watch out for grenades
  if (Squad_AI_IncomingGrenadeDetect())
    { return;
    }

  // also check for enemies
  if (Squad_AI_DetectTarget ())
    return;
};



// Squad_AI_InitSpotting - prepares member for watching
//                         a certain direction/sector
//
//
void (entity member, float angle, float sector) Squad_AI_InitSpotting =
{ // first, set squadSpotAngles: angle and sector
  member.squadSpotAngles_y = angle;
  member.squadSpotAngles_x = sector;
  // now determine which direction to turn
  local float rotation;
  rotation = anglemod(angle + 360.0 - member.angles_y);
  if (rotation < 180.0)
    { // turn right
      member.squadSpotAngles_z = SQUAD_TURNRIGHT;
    }
  else
    { // turn left
      member.squadSpotAngles_z = SQUAD_TURNLEFT;
    }
};




// Squad_AI_TryAssembly - changes state to REGROUP if
//                        near enough to assembly location
//                        and not attacking, dieing or in
//                        bad contents.
//
void (entity member, entity location) Squad_AI_TryAssembly =
{ if ((Squad_GetState(member) != SQUAD_MEMBERATTACK)    &&
      (Squad_GetState(member) != SQUAD_MEMBERDRAW)      &&
      (Squad_GetState(member) != SQUAD_MEMBERDIE)       &&
      (Squad_GetState(member) != SQUAD_MEMBERASSEMBLE)  &&
      (Squad_GetState(member) != SQUAD_MEMBERPOSITION)  &&
      (Squad_GetState(member) != SQUAD_MEMBERRELOAD)    &&
      (Squad_GetState(member) != SQUAD_MEMBERHUNTENEMY) &&
      (Squad_GetState(member) != SQUAD_MEMBERGUARD)
     )
    { // also, bail out if member has feet in slime or similar
      local float fContents;
      fContents = pointcontents(Squad_MemberFeetPosition(member));
      if ((fContents == CONTENT_SLIME) ||
          (fContents == CONTENT_LAVA)
         )
        return;

      if (Waypoint_IsVisible(member, location))
        { // have member assemble
          Squad_AI_DestroyMarker(member.squadmarker);
          member.squadmarker
            = Squad_AI_CreateMarker(location.origin, world);
          Squad_SetState(member, SQUAD_MEMBERASSEMBLE);
        }
      else
        { // otherwise, if member is yet to reach assembly point,
          // have him hurry
          local float hops;
          hops = Squad_Behavior_WaypointNodeDistance(member, location);
          if (hops > 0)
            Squad_SetState(member, SQUAD_MEMBERRUNTOHELP);
        }
    }
};




// Squad_AI_Walk    - executes basic patrolling
//
//
//
void(float dist) Squad_AI_Walk =
{ // execute walking
  Squad_Behavior_Move(dist);

  // test for required state changes
  if (Squad_AI_IncomingGrenadeDetect())
    { return;
    }

  // waypoint visiting is taken care of by waypoints themselves
  // assembly position is taken care of by assembly positions
  // themselves
  if ((Squad_GetState(self) == SQUAD_MEMBERPATROL)
      && ((time - self.search_time) > SQUAD_MAXWAYPOINTTIME)
     )
  { self.search_time = time;
    // have member reselect waypoint without using history
    Squad_Behavior_ReselectWaypoint(self);
    return;
  }
  else
  if (Squad_GetState(self) == SQUAD_MEMBERPOSITION)
    { // go to marker, then change state to
      // TEAMSPOT
      local vector vToMarker;
      local entity assemblyPoint;
      vToMarker     = self.squadmarker.origin - self.origin;
      // less sensitive for vertical distance
      vToMarker_z = 0.5 * vToMarker_z;
      assemblyPoint = Squad_AI_GetMarkerEntity(self.squadmarker);
      if (vlen(vToMarker) < SQUAD_FORMATIONPOINTDIST)
        { Squad_Team_ArriveAtPosition(self, assemblyPoint);
          return;
        }
    }

  if (Squad_AI_DetectTarget ())
    return;

  // check side spaces
  Squad_AI_CheckSides(self);

  // only look for stuff if not pointman while patrolling
  if ((Squad_GetState(self) == SQUAD_MEMBERPATROL) &&
      (Squad_Team_IsPointMan(self))
     )
    return;

  // once in a while, while patrolling, consider a reload
  local float r;
  r = random();
  if (r < 0.05)
  if (Squad_AI_GetReloadUrgency(self) != SQUAD_RELOAD_UNNEEDED)
    { Squad_SetState(self, SQUAD_MEMBERRELOAD);
    }

  if (Squad_AI_DetectStuff())
    return;

};



// Squad_AI_Run     - executes basic running
//                    for states PATROL, ATTACK, HUNTENEMY, RUNTOHELP,
//                               RUNFORCOVER
//
void(float dist) Squad_AI_Run =
{ // execute running
  Squad_Behavior_Move(dist);

  // survive grenades
  if (Squad_AI_IncomingGrenadeDetect())
    { return;
    }

  // state SQUAD_MEMBERPATROL
  if ((Squad_GetState(self) == SQUAD_MEMBERPATROL) ||
      (Squad_GetState(self) == SQUAD_MEMBERRUNTOHELP)
     )
    { // process time out
      if ((time - self.search_time) > SQUAD_MAXWAYPOINTTIME)
      { self.search_time = time;
        // have member reselect waypoint without using history
        Squad_Behavior_ReselectWaypoint(self);
        return;
      }
      // process incoming rockets -> defend state
      if (Squad_AI_IncomingRocketDetect())
        { return;
        }
      // waypoints visiting is been taken care of by waypoints

      // look for targets
      if (Squad_AI_DetectTarget ())
        return;

      // look for stuff if not running to help
      if (Squad_GetState(self) != SQUAD_MEMBERRUNTOHELP)
        { // check side spaces
          Squad_AI_CheckSides(self);

          if (Squad_AI_DetectStuff())
            return;
        }
      else
        { // during runtohelp, look if marker is visible and
          // if targets can be seen near marker
          if (visible(self.squadmarker))
            Squad_SetState(self, SQUAD_MEMBERHUNTENEMY);
        }
    }
  else
  // state SQUAD_MEMBERASSEMBLE
  if (Squad_GetState(self) == SQUAD_MEMBERASSEMBLE)
    { // go to marker, then change state to
      // TEAMPOSITION
      local vector vToMarker;
      vToMarker = self.squadmarker.origin - self.origin;
      if (vlen(vToMarker) < WAYPOINT_REACHEDDISTANCE)
        { Squad_Team_ArriveAtAssembly(self);
          return;
        }
      // look for targets
      if (Squad_AI_DetectTarget ())
        return;
      // look for stuff, if not too close to assembly
      if (vlen(vToMarker) > 600)
      if (Squad_AI_DetectStuff())
        return;
    }
  else
  // state SQUAD_MEMBERATTACK
  if (Squad_GetState(self) == SQUAD_MEMBERATTACK)
    { // forget about rockets - just move to target
      local float dummy;
    }
  else
  // state SQUAD_MEMBERSPREAD
  if (Squad_GetState(self) == SQUAD_MEMBERSPREAD)
    { // forget about rockets and enemies, just move to marker
      // test for reaching spread position
      local float fDistance;
      fDistance = vlen(self.origin - self.squadmarker.origin);
      if (fDistance < SQUAD_FORMATIONPOINTDIST)
        { // now check position
          //bprint(self.netname);
          //bprint(" reached spread position\n");
          Squad_SetState(self, SQUAD_MEMBERCHECK);
          return;
        }
      else
      if ((fDistance > 100) && (fDistance < 150))
        { // try a roll to waypoint
          if ((random() > 0.7) && (Squad_MemberCanRoll(self)))
            {
              Squad_Anim_Roll();
            }
        }

      // test for time out
      if (time > self.search_time)
        { //bprint(self.netname);
          //bprint(" timed out during spread\n");
          if (!Squad_AI_DetectTarget())
            Squad_SetState(self, SQUAD_MEMBERCHECK);
          return;
        }

      // if not running to marker directly, see if marker
      // is becoming visible and go for it
      if (self.goalentity != self.squadmarker)
      if (visible(self.squadmarker))
        { self.goalentity           = self.squadmarker;
          self.movetarget           = self.squadmarker;
          Squad_AI_HeadForMarker(self);
          //bprint(self.netname);
          //bprint(" sees marker during spread\n");
        }
    }
  else
  // state SQUAD_MEMBERHUNTENEMY
  if (Squad_GetState(self) == SQUAD_MEMBERHUNTENEMY)
    { // during 1st .5 second of hunt, consider throwing
      // a grenade (if enemy still alive)
      if ((time - self.search_time < 0.5) && (self.enemy.health > 0))
      { local float fGrenadeType;
        fGrenadeType = Squad_AI_ShouldUseHandGrenade(self, self.squadmarker);
        if (fGrenadeType != SQUAD_NO_GRENADE)
        { self.enemy       = self.squadmarker;
          Squad_Anim_AttackHandGrenade(fGrenadeType);
          return ;
        }
      }

      // basically, move to marker
      local vector dist_marker;
      dist_marker = self.origin - self.squadmarker.origin;
      if ((self.squadmarker == world)
          || (WAYPOINT_REACHEDDISTANCE > vlen(dist_marker))
         )
        { // marker does not really help, start patrolling
          Squad_SetState(self, SQUAD_MEMBERPATROL);
          return;
        }

      // check for previous enemy, if !world
      if (self.enemy != world)
      if (visible(self.enemy) && (self.enemy.health >= 0))
        { // attack again
          Squad_SetState(self, SQUAD_MEMBERATTACK);
          return;
        }

      // check for targets, forget about stuff
      if (Squad_AI_DetectTarget ())
        return;

      // process timer for time-out
      if ((time - self.search_time) > SQUAD_MAXHUNTTIME)
        { Squad_SetState(self, SQUAD_MEMBERPATROL);
          return;
        }
    }
  else
  // state SQUAD_MEMBERRUNFORCOVER
  if (Squad_GetState(self) == SQUAD_MEMBERRUNFORCOVER)
    { if (time > self.search_time)
        { Squad_SetState(self, SQUAD_MEMBERPATROL);
          return;
        }
      if ((self.search_time - time < 0.5) &&
          (vlen(self.dest - self.origin) < 200)
         )
        { if (Squad_MemberCanRoll(self))
            { Squad_SetState(self, SQUAD_MEMBERDEFEND);
              return;
            }
        }
    }
};




// Squad_AI_Assault - executes basic running
//                    for states PATROL, ATTACK, HUNTENEMY
//
//
void (float dist) Squad_AI_Assault =
{ // execute running
  Squad_Behavior_Move(dist);

};




// Squad_AI_StrafeStart - starts strafing, either to the
//                        right or to the left
//
//
void (entity member) Squad_AI_StrafeStart =
{ // determine strafe direction
  local float  leftSideSpace;
  local float  rightSideSpace;
  local vector feet_position;

  feet_position   = member.origin;
  feet_position_z = feet_position_z - 16;

  makevectors(member.angles);
  // test available space at right side
  traceline(feet_position, member.origin + 600 * v_right, FALSE, member);
  rightSideSpace = trace_fraction;
  // test available space at left side
  traceline(feet_position, member.origin - 600 * v_right, FALSE, member);
  leftSideSpace  = trace_fraction;

  /*  bprint("strafespace : ");
      bprint(ftos(leftSideSpace));
      if (leftSideSpace > rightSideSpace)
        bprint(" <- ");
      else
        bprint(" -> ");
      bprint(ftos(rightSideSpace));
      bprint("\n");
  */

  // ... and decide: put result in
  if (rightSideSpace > leftSideSpace)
    member.squadStrafeDirection = SQUAD_STRAFE_DIRECTION_RIGHT;
  else
    member.squadStrafeDirection = SQUAD_STRAFE_DIRECTION_LEFT;
};




// Squad_AI_StrafeFinish - finishes strafing, either
//                         going to attack or walk
//                         depending on enemy visibility
//
void () Squad_AI_StrafeFinish =
{ if (Squad_AI_IsInFront(self.enemy))
    Squad_SetState(self, SQUAD_MEMBERATTACK);
  else
    Squad_SetState(self, SQUAD_MEMBERPATROL);
};



// Squad_AI_RollFinish - finishes rolling, either
//                       attack, continue spread out or
//                       patrol
//
void () Squad_AI_RollFinish =
{ if (Squad_AI_DetectTarget())
    return;

  if (Squad_GetState(self) == SQUAD_MEMBERSPREAD)
    Squad_SetState(self, SQUAD_MEMBERCHECK);

  // ... else
  Squad_SetState(self, SQUAD_MEMBERPATROL);
};



// Squad_AI_CheckFinish - finishes a check, either
//                        attack, turn 45 degrees and check
//                        again or patrol
//
void () Squad_AI_CheckFinish =
{ if (Squad_AI_DetectTarget())
    return;

  if (self.squadStrafeDirection <= 0)
    { Squad_SetState(self, SQUAD_MEMBERPATROL);
      return;
    }

  // ... else
  self.squadStrafeDirection = self.squadStrafeDirection - 1;
  // turn, as programmed
  local float turn;
  turn =  60 * self.squadSpotAngles_y;
  self.ideal_yaw = anglemod(self.angles_y + turn);
  Squad_Anim_Check();
};



// Squad_AI_GrenadeFinish - change behavior after attacking
//                          using a grenade
//
//
void () Squad_AI_GrenadeFinish =
{ // temporary implementation - better to warn
  // teammates and take cover
  if (Squad_GetState(self) == SQUAD_MEMBERHUNTENEMY)
    { // continue hunt enemy
      self.enemy = world;
      self.th_run();
    }
  else
    Squad_SetState(self, SQUAD_MEMBERHUNTENEMY);
};



// Squad_AI_DrawFinish - change behavior after drawing gun
//
//
//
void () Squad_AI_DrawFinish =
{ local float memberstate;
  memberstate = Squad_GetState(self);
  if ((memberstate == SQUAD_MEMBERATTACK) ||
      (memberstate == SQUAD_MEMBERDRAW)
     )
    Squad_Anim_Attack();
  else
  if ((memberstate == SQUAD_MEMBERGUARD) ||
      (memberstate == SQUAD_MEMBERAMBUSH)
     )
    Squad_Anim_Wait();
  else
    Squad_SetState(self, SQUAD_MEMBERPATROL);
};



// Squad_AI_HuntStuff - executes basic walking to stuff
//
//
//
void(float dist) Squad_AI_HuntStuff =
{ // execute walking
  Squad_Behavior_Move(dist);

  // drop if rocket is coming
  if (Squad_AI_IncomingGrenadeDetect())
    { return;
    }

  // look for targets
  if (Squad_AI_DetectTarget ())
    return;

  // test for time out during hunt
  if ((time - self.search_time) > SQUAD_MAXHUNTTIME)
    { // mark area
      self.forbiddenarea = self.stuff.origin;
      Squad_SetState(self, SQUAD_MEMBERPATROL);
      return;
    }

  // only set yaw in inital phase of hunt
  if (time - self.search_time < 3)
    self.ideal_yaw = vectoyaw(self.stuff.origin - self.origin);
};



// Squad_AI_IncomingRocketDetect - looks for rocket that is close
//                                 and incoming
//
//
float () Squad_AI_IncomingRocketDetect =
{ local float  result;
  local entity missile;

  result = FALSE;
  missile = find(world, model, "progs/missile.mdl");
  while ((!result) && (missile != world))
    { // check if missile is coming to target
      if (Squad_AI_IsInFront(missile))
        { // is it coming or going?
          local vector v_missile;
          local float dot;
          makevectors(missile.angles);
          v_missile = v_forward;
          makevectors(self.angles);
          dot = v_forward * v_missile;
          result = (dot < 0.1) &&
                   (vlen(missile.origin - self.origin) < SQUAD_ROCKET_DIVE_DISTANCE);
        }
      // get next missile
      missile = find(missile, model, "progs/missile.mdl");
    }
  return result;
};



// Squad_AI_IncomingGrenadeDetect - looks for grenade that is close,
//                                  incoming, and about to explode
//
//
float () Squad_AI_IncomingGrenadeDetect =
{ local float  result, fDist, dot;
  local entity grenade;
  local vector v_grenade;

  result = FALSE;
  grenade = find(world, classname, "grenade");
  while ((!result) && (grenade != world))
    { // check if grenade will land nearby
      fDist = vlen(self.origin - grenade.dest);

      // accept incoming flash grenades
      if ((grenade.grenadetype == 0 /* fragmentation */)
          ||
          (grenade.owner.team != self.team)
         )
      if ((fDist < 300) && (visible(grenade)))
        { local vector v_grenade;
          v_grenade = grenade.dest - self.origin;
          makevectors(v_grenade);
          v_grenade = v_forward;
          makevectors(self.movetarget.origin - self.origin);
          dot = v_forward * v_grenade;

          if ((dot < 0.1) || (fDist < 150))
            { // try to evade if not dieing or attacking
              if ((Squad_GetState(self) != SQUAD_MEMBERDIE)         &&
                  (Squad_GetState(self) != SQUAD_MEMBERATTACK)      &&
                  (Squad_GetState(self) != SQUAD_MEMBERRUNFORCOVER)
                 )
                { // set predicted position in self.dest
                  self.enemy            = grenade;
                  Squad_SetState(self, SQUAD_MEMBERRUNFORCOVER);
                }
            }
          /*
          else
            { // walking from grenade
              bprint(self.netname);
              bprint(" walking from grenade - ");
              bprint(ftos(fDist));
              bprint("\n");
            }
          */
          result = TRUE;
        }

      // get next missile
      if (!result)
        grenade = find(grenade, classname, "grenade");
    }
  return result;
};



// Squad_AI_InitSidesInfo  - inits sides info for patrolling
//                           member
//
//
void (entity member) Squad_AI_InitSidesInfo =
{ makevectors(member.angles);
  local vector left, right;
  left  = member.origin - 800 * v_right;
  right = member.origin + 800 * v_right;
  // init left
  traceline(member.origin, left, TRUE, member);
  member.dest1_x = 800 * trace_fraction;
  // init right
  traceline(member.origin, right, TRUE, member);
  member.dest1_y = 800 * trace_fraction;
  // init time
  member.dest1_z = time;
};



// Squad_AI_CheckSides  - checks if right and/or left side
//                        is open and needs inspection
//
//
float (entity member) Squad_AI_CheckSides =
{ makevectors(member.angles);
  local vector left, right;
  local float  fleft, fright;
  local float  cleft, cright;
  cleft  = FALSE;
  cright = FALSE;
  left   = member.origin - 800 * v_right;
  right  = member.origin + 800 * v_right;
  // check left
  traceline(member.origin, left, TRUE, member);
  fleft  = 800 * trace_fraction;
  //bprint("left/right = ");
  //bprint(ftos(800 * trace_fraction));
  //bprint(" / ");
  // check right
  traceline(member.origin, right, TRUE, member);
  fright = 800 * trace_fraction;
  //bprint(ftos(800 * trace_fraction));
  //bprint("\n");

  // see if check is needed
  if (time - member.dest1_z > SQUAD_INTERCHECKTIME)
    { if (fleft  - member.dest1_x > 200)
        cleft  = TRUE;
      if (fright - member.dest1_y > 200)
        cright = TRUE;
      if (cleft || cright)
        { member.dest1_z = time;
          // now check
          Squad_SetState(member, SQUAD_MEMBERCHECK);
          // if both cleft and cright, choose 1
          if (cleft && cright)
          if (random() > 0.5)
            cleft  = FALSE;
          else
            cright = FALSE;
          // reprogram direction and speed
          if (cleft)
            member.ideal_yaw = anglemod(member.ideal_yaw + 90);
          else
            member.ideal_yaw = anglemod(member.ideal_yaw - 90);
          // single check required, higher turn speed
          member.squadStrafeDirection =  0;
          member.yaw_speed            = 10.0;
        }
    }
  // store new values
  member.dest1_x = fleft;
  member.dest1_y = fright;
};




// Squad_AI_ValueStuff  - determines value for squad member
//                        of a given stuff, taking state into account
//
//
float (entity somestuff) Squad_AI_ValueStuff =
{ // special items
  if (somestuff.classname == "backpack") return 100;
  // ammo
  if (somestuff.netname   == "shells")   return 50;
  if (somestuff.netname   == "nails")    return 80;
  if (somestuff.netname   == "rockets")  return 90;
  if (somestuff.netname   == "cells")    return 50;
  // weapons
  if (somestuff.classname == "weapon_nailgun")         return 120;
  if (somestuff.classname == "weapon_supernailgun")    return 150;
  if (somestuff.classname == "weapon_supershotgun")    return 110;
  if (somestuff.classname == "weapon_rocketlauncher")  return 140;
  if (somestuff.classname == "weapon_grenadelauncher") return 120;
  if (somestuff.classname == "weapon_lightning")       return 140;
  // power ups
  if (somestuff.healtype  == 1)                        return 125 + somestuff.healamount;
  if (somestuff.healtype  == 2)                        return 160;
  return -1;
};



// Squad_AI_FoundStuff -  changes state after seeing
//                        attractive stuff
//
//
void (entity stufffound) Squad_AI_FoundStuff =
{ self.stuff    = stufffound;
  Squad_SetState(self, SQUAD_MEMBERHUNTSTUFF);
};



// Squad_AI_TouchedStuff -  if touched the stuff I was
//                          looking for, stop hunting
//
//
void  (entity member, entity somestuff) Squad_AI_TouchedStuff =
{ // update all states of bots looking for stuff (state == HUNTSTUFF)
  local entity bot;
  bot = find(world, classname, "bot");
  while (bot != world)
    { if (Squad_GetState(bot) == SQUAD_MEMBERHUNTSTUFF)
      if (bot.stuff == somestuff)
        { bot.forbiddenarea = SQUAD_FORBIDDENAREA;
          Squad_SetState(bot, SQUAD_MEMBERPATROL);
        }
      bot = find(bot, classname, "bot");
    }
};



// Squad_AI_DetectStuff - looks for armour, ammo, health,
//                        magic, boosts and weapons
//
//
float () Squad_AI_DetectStuff =
{ local entity head, selected;
  local float dist;  // distance to selected item
  local float value; // value of selected item, higher is better
  dist  = 200;
  value = 0;

  selected = world;

  // go and most valued best visible item
  head = findradius(self.origin, 400);

  while(head)
	 { if ((head.classname == "weapon_supershotgun") ||
          (head.classname == "weapon_nailgun") ||
          (head.classname == "weapon_supernailgun") ||
          (head.classname == "weapon_grenadelauncher") ||
          (head.classname == "weapon_rocketlauncher") ||
          (head.classname == "weapon_lightning") ||
          (head.classname == "backpack") ||
          ((self.ammo_shells < 100) && (head.netname == "shells")) ||
          ((self.ammo_nails < 200) && (head.netname == "nails")) ||
          ((self.ammo_rockets < 100) && (head.netname == "rockets")) ||
          ((self.ammo_rockets < 100) && (head.netname == "cells")) ||
          (head.classname == "item_armor1") ||
          (head.classname == "item_armor2") ||
          (head.classname == "item_armorInv") ||
          ((head.healtype == 1) && (self.health < 100)) ||
          ((head.healtype == 2) && (self.health < 100)))
      if (visible(head))
      if (Squad_AI_IsInFront(head))
        { // see if it is in the forbidden area
          local float fDist;
          fDist = vlen(self.forbiddenarea - head.origin);
          // determine value
          local float fSelectedValue;
          fSelectedValue = Squad_AI_ValueStuff(head);
          if ((fDist < SQUAD_FORBIDDENAREA_DIST)
              || (value < fSelectedValue)
             )
            { value = fSelectedValue;
              selected = head;
            }
        }
	   head = head.chain;
    } // while

  // now do something with the result
  if (selected == world)
	 return FALSE;
  else
    { Squad_AI_FoundStuff(selected);
		return TRUE;
    }
};



// Squad_AI_CreateMarker - creates new marker entity, to mark
//                         some position. If the position is related
//                         to some entity, that entity should be
//                         provided as a 2nd parameter.
//
entity (vector position, entity associatedEntity) Squad_AI_CreateMarker =
{ // create new dynamic entity, of class marker, at given position
  local entity marker;
  marker = spawn();
  marker.classname = "marker";
  marker.origin    = position;
  marker.solid     = SOLID_NOT;
  marker.aiment    = associatedEntity;
  //setmodel(marker, "progs/s_bubble.spr");
  return marker;
};



// Squad_AI_UpdateMarker - updates the marker entity, to mark
//                         last seen position of target
//
//
void (entity marker, vector position) Squad_AI_UpdateMarker =
{ // test if marker is valid (doesn't equal world entity)
  if (marker != world)
    marker.origin = position;
};




// Squad_AI_DestroyMarker - removes marker entity that marked
//                          last seen position of target
//
//
void (entity marker) Squad_AI_DestroyMarker =
{ // might do reference counting if marker gets shared among
  // squad members
  if (marker != world)
    remove (marker);
};



// Squad_AI_GetMarkerEntity - returns entity associated with
//                            marker
//
//
entity (entity marker) Squad_AI_GetMarkerEntity =
{ return marker.aiment;
};



// Squad_AI_ReceiveDamage - processes pain cause and changes
//                          state accordingly
//
//
void (entity attacker, float damage) Squad_AI_ReceiveDamage =
{ // return if already dieing
  if (Squad_GetState(self) == SQUAD_MEMBERDIE)
    return;

  /*
  bprint(self.netname);
  bprint("[");
  bprint(Squad_StateToString(Squad_GetState(self)));
  bprint("] -> ");
  bprint("ReceiveDamage(");
  bprint(attacker.classname);
  bprint("::");
  bprint(attacker.netname);
  bprint(", ");
  bprint(ftos(damage));
  bprint(") - health == ");
  bprint(ftos(self.health));
  bprint("\n");
  */

  if (self.health < 0)
    { Squad_Anim_Die();
      return;
    }

  // if hit by bullets or alike, try to shout for help (unless hit
  // by teammates and coop)
  if (attacker.flags & (FL_MONSTER | FL_CLIENT))
    { local float r;
      r = random();
      if (r < 0.8)
        { Squad_Team_MaybeRequestAssistance(self, self, 1);
        }

      // now, learn position of attacker
      if (((attacker.classname == "bot") && (attacker.team != self.team))
          ||
          (attacker.classname == "player")
         )
        self.enemy = attacker;
    }


  // if cause == contaminated water, search for new nearby waypoint
  local float contents;
  contents = pointcontents(Squad_MemberFeetPosition(self));
  if ((contents == CONTENT_SLIME) ||
      (contents == CONTENT_LAVA)  ||
      (attacker.flags & (FL_MONSTER | FL_CLIENT) == 0)
     )
    { Squad_SetState(self, SQUAD_MEMBERPATROL);
      // shout, random?
    }
  else
    { // show pain
      Squad_SetState(self, SQUAD_MEMBERPAIN);
    }
};



// Squad_AI_NeedIgnorePain - while suffering pain, see if pain
//                           should be ignored to continue attack
//
//
void () Squad_AI_NeedIgnorePain =
{ // default action is to defend...
  // however, if target can be seen try to attack
  // however, if weapon needs reload and enemy is not near,
  //   first reload
  if (Squad_AI_DetectTarget())
    { // detect target implies state change to attack
      // however, do I need to reload
      if (Squad_AI_GetReloadUrgency(self) == SQUAD_RELOAD_IMMEDIATE)
        { // change to state reload unless enemy near
          if ((range(self.enemy) == RANGE_FAR) ||
              (range(self.enemy) == RANGE_MID)
             )
             Squad_SetState(self, SQUAD_MEMBERRELOAD);
          else
            { // try melee attack or search cover.
              // tbd
             Squad_SetState(self, SQUAD_MEMBERATTACK);
            }
        }
      else
        Squad_SetState(self, SQUAD_MEMBERATTACK);

    }
  // no else clause, just continue to suffer
};




// Squad_AI_FinishedPain - after receiving some pain, decide
//                         what to do now
//
//
void () Squad_AI_FinishedPain =
{ // default action is to defend...
  // however, if target can be seen try to attack
  // however, if weapon needs reload and enemy is not near,
  //   first reload
  if (Squad_AI_DetectTarget())
    { // detect target implies state change to attack
      // however, do I need to reload
      if (Squad_AI_GetReloadUrgency(self) == SQUAD_RELOAD_IMMEDIATE)
        { // change to state reload unless enemy near
          if ((range(self.enemy) == RANGE_FAR) ||
              (range(self.enemy) == RANGE_MID)
             )
             Squad_SetState(self, SQUAD_MEMBERRELOAD);
          else
            { // try melee attack or search cover.
              // tbd
             Squad_SetState(self, SQUAD_MEMBERATTACK);
            }
        }
      else
        Squad_SetState(self, SQUAD_MEMBERATTACK);
    }
  else
    Squad_SetState(self, SQUAD_MEMBERDEFEND);
};




// Squad_AI_DetectTarget - looks for targets (players, bots)
//
//
//
float () Squad_AI_DetectTarget =
{ local entity selected, head;
  local float  dist, targets;
  dist     = 1500;  // awareness radius of bot, increasing it slows down game
  selected = world;
  targets  = 0;

  head = findradius(self.origin, dist);
  while(head)
    { if (((deathmatch)
           && (!(head.flags & FL_NOTARGET)
           && ((head.flags & FL_CLIENT) || (head.flags & FL_MONSTER))
          )) ||
          ((!deathmatch) &&
           (!(head.flags & FL_NOTARGET) && (head.flags & FL_MONSTER))
         ))
      if (((teamplay) &&  (head.team != self.team)) || (!teamplay))
      if (visible(head))
        { // compute distance to head
          local float fDistance;
          fDistance = vlen (self.origin - head.origin);
          if ((Squad_AI_IsInFront(head)) || (fDistance < 200))
          if ((head.health > 0) && (head !=self))
            { // update targets counter
              targets = targets + 1;
              // make head selected, if nearest
              if (trace_plane_dist < dist)
                { selected = head;
                  dist = trace_plane_dist;
                }
            }
        }
      head = head.chain;
    } // while

  if (selected == world)
    return FALSE;
  else
    { // stop team ambushing
      Squad_Team_StartAttack(teamAlpha);
      // call for spreading out
      Squad_Team_StartSpreadOut(teamAlpha, self, selected);
      // warn team, if needed
      if (Squad_Team_MaybeRequestAssistance(self, selected, targets))
        { // assistance asked and coming, so attack
          // take action
          Squad_AI_FoundTarget(selected);
        }
      else
        { // maybe move away?

          // for now, attack
          Squad_AI_FoundTarget(selected);
        }
      return TRUE;
    }
};



// Squad_AI_FoundTarget -  changes state after seeing
//                         target
//
//
void (entity targetfound) Squad_AI_FoundTarget =
{ self.enemy = targetfound;
  Squad_AI_ConsiderChangeDirection(self, targetfound);
  // hesitate fraction of a second before actually attacking
  Squad_SetState(self, SQUAD_MEMBERDRAW);
};



// Squad_AI_StartReload - determines whether to switch to
//                        the reload state, or perform reload
//                        while remaining in the SPOT state
//
void (entity member) Squad_AI_StartReload =
{ // if not in team formation (SPOT), change to next state
  if (Squad_GetState(member) != SQUAD_MEMBERGUARD)
    Squad_SetState(member, SQUAD_MEMBERRELOAD);
  else
    member.think = Squad_Anim_Reload;
};



// Squad_AI_PerformReload - updates ammo state
//
//
//
void (entity member) Squad_AI_PerformReload =
{
  if (Squad_GetRole(member) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // use mk23 handgun
      if (member.ammo_shells > 12)
        { member.mk23clip    = 12;
          member.ammo_shells = member.ammo_shells - 12;
        }
      else
        { member.mk23clip    = member.ammo_shells;
          member.ammo_shells = 0;
        }
    }
  else
    { // use mp5 machinegun
      if (member.ammo_shells > 30)
        { member.mp5clip     = 30;
          member.ammo_shells = member.ammo_shells - 30;
        }
      else
        { member.mp5clip     = member.ammo_shells;
          member.ammo_shells = 0;
        }
    }
};



// Squad_AI_FinishedReload - typically used to nofity team
//                           members you are ready to fight
//                           again (so they can reload)
//
void () Squad_AI_FinishedReload =
{ // if not in team formation (SPOT), patrol unless enemies visible
  if (Squad_GetState(self) != SQUAD_MEMBERGUARD)
    { if (!Squad_AI_DetectTarget())
        Squad_SetState(self, SQUAD_MEMBERPATROL);
    }
  else
    self.think = Squad_Anim_Wait;
};



// Squad_AI_GetReloadUrgency - returns how urgent member needs
//                             to reload mk23 handgun.
//
//
float (entity member) Squad_AI_GetReloadUrgency =
{ // no need to reload if no more shells available
  if (member.ammo_shells == 0)
    return SQUAD_RELOAD_UNNEEDED;

  if (Squad_GetRole(member) == SQUAD_ROLE_HANDGUNSOLDIER)
    { // reload immediate if mk23's clip empty
      if (member.mk23clip == 0)
        return SQUAD_RELOAD_IMMEDIATE;
      // reload urgent if less than 5 shells in mk23's clip
      if (member.mk23clip < 3)
        return SQUAD_RELOAD_URGENT;
    }
  else
    { // reload immediate if mp5's clip empty
      if (member.mp5clip  == 0)
        return SQUAD_RELOAD_IMMEDIATE;
      // reload urgent if less than 5 shells in mp5's clip
      if (member.mp5clip  < 6)
        return SQUAD_RELOAD_URGENT;
    }

  return SQUAD_RELOAD_UNNEEDED;
};




// Squad_AI_StartAttack - start attack
//
//
//
void () Squad_AI_StartAttack =
{ // hesitate fraction of a second before actually attacking
  Squad_SetState(self, SQUAD_MEMBERDRAW);
};



// Squad_AI_EveryAttack - generic attack state processing,
//                        changes state if attack is not
//                        possible
//
void (float am) Squad_AI_EveryAttack =
{ // wake up monsters up
  self.show_hostile = time + 0.5;

  // test for incoming grenades
  if (Squad_AI_IncomingGrenadeDetect())
    { Squad_SetState(self, SQUAD_MEMBERDEFEND);
      return;
    }

  // test if target is still available
  if ((self.enemy == world)
      || (self.enemy.health <= 0)
      || (self.enemy.solid == SOLID_NOT)
      || (self.enemy.deadflag  == DEAD_DEAD)
     )
    { // start patrolling again
      Squad_SetState(self, SQUAD_MEMBERPATROL);
      return;
    }
  else
  if (!visible (self.enemy))
    { if (!Squad_Team_HasLostTouchWithEnemy(teamAlpha, self))
        { // hunt for enemy using last known location
          Squad_SetState(self, SQUAD_MEMBERHUNTENEMY);
        }
      return;
    }

  // enemy available and visible
  // remember enemy's position
  Squad_AI_UpdateMarker(self.squadmarker, self.enemy.origin);

  // again, look at enemy
  ai_face();

  // select best weapon
  local float r;
  r = Squad_AI_BestWeapon(self, self.enemy);
  Squad_AI_ChangeWeapon(self, r);

  if (self.weapon != IT_AXE)
    { // check for clear line of fire
      local entity obstacle;
      obstacle = Squad_AI_HasClearLineOfFire(self, self.enemy);
      if (obstacle != world)
      if (obstacle != self)
      if (obstacle.team == self.team)
        { /*
          bprint(self.netname); bprint(" finds ");
          bprint(obstacle.netname);
          bprint(", posture = ");
          bprint(Squad_PostureToString(Squad_GetPosture(obstacle)));
          bprint(" in line of fire\n");
          */
          if (!Squad_AI_AskMoveOutOfWay(obstacle, self))
            { /*
              bprint(obstacle.netname);
              bprint(" cannot move out\n");
              */
              Squad_SetState(self, SQUAD_MEMBERSTRAFE);
            }
          else
            { /*
              bprint(obstacle.netname);
              bprint(" will move out\n");
              */
              self.squadmembernextstate = SQUAD_MEMBERATTACK;
              self.search_time          = time + SQUAD_PRE_ATTACKDELAY;
              Squad_SetState(self, SQUAD_MEMBERWAIT);
            }
        }
    }
};




// Squad_AI_ChargeTarget -  nearby attack at target
//
//
//
void(float dist) Squad_AI_ChargeTarget =
{ ai_face ();
  // execute walking
  Squad_Behavior_Move(dist);
};




// Squad_AI_AskMoveOutOfWay -  receiver is requested to move
//                             out of the way; won't do so in
//                             states ...; otherwise, won't hear
//                             request in some cases; if moving
//                             out, strafe or roll
float (entity receiver, entity sender) Squad_AI_AskMoveOutOfWay =
{ // check space in front of receiver TBD

  local float r;
  r = random();
  if (r > 0.8)
    return FALSE;
  else
    { if ((r > 0.5) && (Squad_MemberCanRoll(receiver)))
        Squad_SetState(receiver, SQUAD_MEMBERDEFEND);
      else
      if (r > 0.2)
        Squad_Behavior_TrySit(receiver);
      else
        Squad_SetState(receiver, SQUAD_MEMBERSTRAFE);
      return TRUE;
    }
};




/*
// Squad_AI_AttackAxe -  attack using axe
//
//
//
void() Squad_AI_AttackAxe =
{ Squad_FI_FireAxe();
};
*/


// Squad_AI_AttackSomeHandgun - attack using one of the handguns
//
//
//
void() Squad_AI_AttackSomeHandgun =
{ Squad_FI_FireHandgun();
};



// Squad_AI_AttackSomeMachinegun - attack using one of the machineguns
//
//
//
void() Squad_AI_AttackSomeMachinegun =
{ Squad_FI_FireMachinegun();
};



// Squad_AI_ShouldUseHandGrenade - determine whether a hand grenade
//                                 is to be used
//
//
float (entity member, entity subject) Squad_AI_ShouldUseHandGrenade =
{ // test if sufficient ammo available
  if (self.ammo_rockets < 1)
    return SQUAD_NO_GRENADE;

  // test if enemy is not too near
  local float fDist;
  fDist = vlen(subject.origin - self.origin);
  if (fDist < 200)
    return SQUAD_NO_GRENADE;

  // test if subject can be hit
  local entity receiver;
  receiver = Squad_FI_CanThrowGrenade(member, subject);
  if (receiver != subject)
    return SQUAD_NO_GRENADE;

  // test if team allows the use of hand grenade
  if (!Squad_Team_ShouldUseGrenade(member, subject))
    return SQUAD_NO_GRENADE;

  // now determine type of grenade
  if ((fDist < 400) || (random() < 0.2))
    return SQUAD_FLASHBANG_GRENADE;
  else
    return SQUAD_FRAG_GRENADE;
};



// Squad_AI_AttackHandGrenade - attack using a hand grenade
//
//
//
void () Squad_AI_AttackHandGrenade =
{ // use previously calculated speed and direction, if available
  Squad_FI_ThrowHandGrenade(self.dest, self.grenadetype);
};



/*
// Squad_AI_SetCurrentAmmo - updates the amount of ammo
//                           resulting from a touch
//
//
void (entity member) Squad_AI_SetCurrentAmmo =
{ member.items = member.items
    - ( member.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
  if (member.weapon == IT_AXE)
    member.currentammo = 0;
  else
  if ((member.weapon == IT_SHOTGUN) || (member.weapon == IT_SUPER_SHOTGUN))
    { member.currentammo = member.ammo_shells;
      member.items = member.items | IT_SHELLS;
    }
  else
  if ((member.weapon == IT_NAILGUN) || (member.weapon == IT_SUPER_NAILGUN))
    { member.currentammo = member.ammo_nails;
      member.items = member.items | IT_NAILS;
    }
  else
  if ((member.weapon == IT_GRENADE_LAUNCHER) ||
      (member.weapon == IT_ROCKET_LAUNCHER)
     )
    { member.currentammo = member.ammo_rockets;
      member.items = member.items | IT_ROCKETS;
    }
  else
  if (member.weapon == IT_LIGHTNING)
    { member.currentammo = member.ammo_cells;
      member.items = member.items | IT_CELLS;
    }
  else
    { member.currentammo = 0;
    }
};
*/



// Squad_AI_ChangeWeapon - tries to change current weapon for some
//                         better weapon (returns FALSE if
//                         unsuccessfull)
//
//
void  (entity member, float someWeapon) Squad_AI_ChangeWeapon =
{
  // NS squadbot hack
  return;

/*
  // test for no change
  if (someWeapon == member.weapon)
    return;
  // filter errors
  if ((someWeapon == IT_SHOTGUN) && (member.ammo_shells < 1))
    return;
  if ((someWeapon == IT_SUPER_SHOTGUN) && (member.ammo_shells < 2))
    return;
  if (((someWeapon == IT_NAILGUN) ||
       (someWeapon == IT_SUPER_NAILGUN)
      ) && (member.ammo_nails < 1)
     )
    return;
  if (((someWeapon == IT_GRENADE_LAUNCHER) ||
       (someWeapon == IT_ROCKET_LAUNCHER)
      ) && (member.ammo_rockets < 1)
     )
    return;
  if ((someWeapon == IT_LIGHTNING) && (member.ammo_cells < 1))
    return;

  // all filtering done - now implement delay
  member.weapon = someWeapon;
  Squad_AI_SetCurrentAmmo(member);

  // delay some time sec
  member.search_time = time + SQUAD_CHANGEWEAPON_DELAY;
  member.squadmembernextstate = member.squadmemberstate;
  Squad_SetState(member, SQUAD_MEMBERWAIT);
*/
};



// Squad_AI_SelectWeapon - return current weapon best
//                         suited for given enemy
//                         (== world, if none)
//
//
float (entity member, entity bogey) Squad_AI_BestWeapon =
{ local float it;
  local float dist;

  // NS squadbot hack
  return member.weapon;
/*
  // test for enemy
  if (bogey != world)
    { // enemy found, estimate distance
      dist = vlen(member.enemy.origin - member.origin);
      dist = dist + ((random() * 100) - 50);
    }
  else
    { dist = 300;
    }

  it = member.items;
  if ((member.ammo_cells > 0)
      && (it & IT_LIGHTNING) && ( dist < 575 )
     )
    return IT_LIGHTNING;
  else
  if ((member.ammo_rockets > 0)
      && (it & IT_ROCKET_LAUNCHER) && ( dist > 75 )
     )
    return IT_ROCKET_LAUNCHER;
  else
  if ((member.ammo_nails > 1) && (it & IT_SUPER_NAILGUN))
    return IT_SUPER_NAILGUN;
  else
  if ((member.ammo_shells > 1)
      && (it & IT_SUPER_SHOTGUN) && ( dist < 400 )
     )
    return IT_SUPER_SHOTGUN;
  else
  if ((member.ammo_nails > 0) && (it & IT_NAILGUN))
    return IT_NAILGUN;
  else
  if ((member.ammo_rockets > 0)
      && (it & IT_GRENADE_LAUNCHER) && (dist < 200)
      && (dist > 75)
     )
    return IT_GRENADE_LAUNCHER;
  else
  if (member.ammo_shells > 0)
    return IT_SHOTGUN;
  else
    return IT_AXE;
*/
};



// Squad_AI_HasClearLineOfFire - tests if in pyramid, top
//                               = member.origin, center = enemy
//                               teammembers might get hurt
//
entity (entity member, entity subject) Squad_AI_HasClearLineOfFire =
{ if (subject == world)
    return world;

  local vector spot1,   spot2;
  local vector v_aim_dir, v_spread;
  local float  size_h,  size_v, v_aim_len;
  local float  alpha_h, alpha_v;

  // define spread
  v_spread = '0.04 0.04 0';
  v_spread = (5 - skill) * v_spread;

  // do not use origin, but a more realistic point
  makevectors(member.v_angle);

  spot1   = member.origin + v_forward*10;
  spot1_z = member.absmin_z + member.size_z * 0.7;

  // construct v_aimdir
  spot2   = subject.origin;
  spot2_z = subject.absmin_z + subject.size_z * 0.7;
  v_aim_dir = spot2 - spot1;

  v_aim_len = vlen(v_aim_dir);
  if (member.weapon != IT_AXE)
    { // look beyond enemy - member does not necessarily hit
      // enemy
      v_aim_len = 2 * v_aim_len;
    }

  normalize(v_aim_dir);

  local vector r0, r1, r2, r3, r4;
  r0 = spot1 + v_aim_dir * v_aim_len;


  // cast some tracelines until teammember hit
  //
  //                          r1 <-- size_h ---> r2
  //            angle alpha
  //                          ^
  //     m.origin             |    e.origin + offset
  //                          |      = r0
  //                        size_h
  //                          |
  //                          v
  //                          r3                 r4
  //

  // test r0
  traceline(spot1, r0, FALSE, member);
  if ((trace_fraction < 1)
      && (trace_ent.team == member.team)
     )
    return trace_ent;

  // construct r1...r4
  makevectors(v_aim_dir);
  r1 = spot1 + v_aim_len * (v_aim_dir
                            - v_spread_x * v_right
                            + v_spread_y * v_up
                           );
  r2 = spot1 + v_aim_len * (v_aim_dir
                            + v_spread_x * v_right
                            + v_spread_y * v_up
                           );
  r3 = spot1 + v_aim_len * (v_aim_dir
                            - v_spread_x * v_right
                            - v_spread_y * v_up
                           );
  r4 = spot1 + v_aim_len * (v_aim_dir
                            + v_spread_x * v_right
                            - v_spread_y * v_up
                           );

  // test r1
  traceline(spot1, r1, FALSE, member);
  // test for teammates
  if ((trace_fraction < 1)
      && (trace_ent.team == member.team)
     )
    return trace_ent;


  // test r2
  traceline(spot1, r2, FALSE, member);
  if ((trace_fraction < 1)
      && (trace_ent.team == member.team)
     )
    return trace_ent;

  // test r3
  traceline(spot1, r3, FALSE, member);
  if ((trace_fraction < 1)
      && (trace_ent.team == member.team)
     )
    return trace_ent;

  // test r4
  traceline(spot1, r4, FALSE, member);
  if ((trace_fraction < 1)
      && (trace_ent.team == member.team)
     )
    return trace_ent;

  // no hits
  return world;
};



// Squad_AI_IsMemberAttacking - returns if member is performing
//                              some attack - typically, states
//                              MEMBERATTACK, MEMBERHUNTENEMY, MEMBERDEFEND
//                              MEMBERRELOAD and MEMBERWAIT,
//                              if next state is attack
float (entity member) Squad_AI_IsMemberAttacking =
{ if (Squad_GetState(member) == SQUAD_MEMBERATTACK)
    return TRUE;
  if (Squad_GetState(member) == SQUAD_MEMBERHUNTENEMY)
    return TRUE;
  if (Squad_GetState(member) == SQUAD_MEMBERDEFEND)
    return TRUE;
  if (Squad_GetState(member) == SQUAD_MEMBERRELOAD)
    return TRUE;
  if (Squad_GetState(member) == SQUAD_MEMBERSPREAD)
    return TRUE;
  if (Squad_GetState(member) == SQUAD_MEMBERDRAW)
    return TRUE;
  if ((Squad_GetState(member) == SQUAD_MEMBERWAIT) &&
      (member.squadmembernextstate == SQUAD_MEMBERATTACK)
     )
    return TRUE;
  return FALSE;
};



// Squad_AI_ConsiderChangeDirection - changes direction if member is
//                                    a negative number of nodes away
//                                    (and deathmatch)
//
void (entity member, entity subject) Squad_AI_ConsiderChangeDirection =
{ if (!Squad_Game_IsInfiltrate())
    return ;

  local float enemyHops;
  enemyHops = Squad_Behavior_WaypointNodeDistance(member, subject);
  // adjust waypoint visiting direction, if necessary
  if (enemyHops < 0)
    { local float direction;
      direction = member.squadWaypointDirection;
      if (direction == SQUAD_WAYPOINT_DIRECTION_POS)
        member.squadWaypointDirection
          = SQUAD_WAYPOINT_DIRECTION_NEG;
      else
        member.squadWaypointDirection
          = SQUAD_WAYPOINT_DIRECTION_POS;
      if (SQUAD_MEMBER_STATECHANGEINFO == 1)
        { bprint(member.netname);
          bprint(" changed direction\n");
        }
    }
};



// Squad_AI_DoesSeeSubjectThruTeam - determines whether a member is
//                                   able to see subject, even
//                                   through team mates
//
float (entity member, entity subject) Squad_AI_DoesSeeSubjectThruTeam =
{ local vector    spot1, spot2;

  spot1 = member.origin   + member.view_ofs;
  spot2 = subject.origin + subject.view_ofs;
  traceline (spot1, spot2, TRUE, self);   // see through other monsters

  return (trace_fraction == 1);
};



// Squad_AI_IsInFront - determines whether a member is
//                                   able to see subject, even
//                                   through team mates
//
float (entity subject) Squad_AI_IsInFront =
{ local vector vec;
  local float  dot;

  makevectors (self.angles);
  vec = normalize (subject.origin - self.origin);
  dot = vec * v_forward;

  if ( dot > 0.1)  // viewing angle 85 degrees
    return TRUE;
  return FALSE;
};

