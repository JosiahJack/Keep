/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad_tm.qc  "methods for team behavior of members"      */
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
// Squad team initialization, creation and information
//

// implementation

// local forwards
void   ()                        Squad_Team_CreateMember;
void   ()                        Squad_Team_TouchAssemblyPosition;
entity (float teamId)            Squad_Team_GetNextAssemblyPosition;
void   (entity assemblyPosition,
        entity member)           Squad_Team_AssignAssemblyPositionOccupant;
float  (entity member)           Squad_Team_HasAssignedAssemblyPosition;
float  (entity assemblyPosition) Squad_Team_GetAssemblyPositionSpotDirection;
entity (entity member)           Squad_Team_GetMembersAssemblyPosition;
void   (entity assemblyPosition) Squad_Team_FreeAssemblyPosition;



// implementation - info - class squad_team
//
//   assembly positions map on entities reusing standard entities fields
//   - team          -> id of team
//   - memberstate   -> state
//   - ammo_shells   -> teamsize
//   - ammo_nails    -> assembly size
//   - ammo_rockets  -> formation size
//   - ammo_cells    -> formation, bitfields 0..3
//   - teleport_time -> time of last grenade thrown
//   - origin        -> location at which ambush is assembled
//   - oldorigin     -> location at which ambush is focussed
//   - goalentity    -> waypoint nearest to ambush target location
//   - weapon        -> used to choose between MP5 and MP5SD





// Squad_Team_StateToString - convert state value to string rep
//
//
//
string (float memberstate) Squad_Team_StateToString =
{ if (memberstate == SQUAD_TEAMUNCOORDINATED)
    return "Uncoordinated";
  if (memberstate == SQUAD_TEAMREGROUP)
    return "Regrouping";
  if (memberstate == SQUAD_TEAMCREATE)
    return "Creating";
  if (memberstate == SQUAD_TEAMCREATEASSEMBLE)
    return "Initial Assembly";
  if (memberstate == SQUAD_TEAMSPREADOUT)
    return "Spread Out";
  if (memberstate == SQUAD_TEAMAMBUSH)
    return "Ambush";
  if (memberstate == SQUAD_TEAMWAIT)
    return "Wait";
  else
    return "Undefined";
};



// Squad_Team_GetState - returns current state of squad team
//
//
//
float (entity member) Squad_Team_GetState =
{ return member.squadmemberstate;
};



// Squad_Team_SetState - defines new state for squad team
//
//
//
void (entity squad, float newstate) Squad_Team_SetState =
{ local float memberstate;
  memberstate = newstate;

  // first prohibit invalid state changes
  if (squad.squadmemberstate == memberstate)
    return;
  if ((memberstate == SQUAD_TEAMSPREADOUT) &&
      (squad.squadmemberstate == SQUAD_TEAMCREATE)
     )
   return;
  if ((memberstate == SQUAD_TEAMREGROUP) &&
      (squad.squadmemberstate == SQUAD_TEAMCREATE)
     )
    memberstate = SQUAD_TEAMCREATEASSEMBLE;

  // state exit processing

  // change state - prohibit invalid transitions
  //

  squad.squadmemberstate = memberstate;

  // debug info
  if (SQUAD_TEAM_STATECHANGEINFO == 1)
    { local string sState;
      sState = Squad_Team_StateToString(memberstate);
      dprint("squad team ");
      dprint(squad.netname);
      dprint(" enters state ");
      dprint(sState);
      dprint("\n");
    }

  // state entry processing
  if (squad.squadmemberstate == SQUAD_TEAMUNCOORDINATED)
    { // degroup
      Squad_Team_Degroup(squad);

      // have team create a member shortly
      squad.think       = Squad_Team_Idle;
      squad.nextthink   = time + 0.1;
    }
  else
  if (squad.squadmemberstate == SQUAD_TEAMWAIT)
    { // wait - will switch to squadnextmemberstate in .search-time time
      squad.think     = Squad_Team_Wait;
      squad.nextthink = time + 0.1;
    }
  else
  if (squad.squadmemberstate == SQUAD_TEAMCREATE)
    { // set team size - using ammo_shells field
      squad.ammo_shells = 0;
      // preprare creation positions
      Squad_Team_PrepareCreatePositions(squad);
      // have team create a member shortly
      squad.think       = Squad_Team_CreateMember;
      squad.nextthink   = time + 0.1;
    }
  else
  if (squad.squadmemberstate == SQUAD_TEAMCREATEASSEMBLE)
    { // have team create a member shortly
      squad.search_time = time;
      squad.think       = Squad_Team_CreateMember;
      squad.nextthink   = time + 0.1;
    }
  else
  if (squad.squadmemberstate == SQUAD_TEAMREGROUP)
    { squad.search_time = time;
      squad.think       = Squad_Team_Regroup;
      squad.nextthink   = time + 0.1;
    }
  else
  if (squad.squadmemberstate == SQUAD_TEAMSPREADOUT)
    { squad.search_time = time + SQUAD_MAXSPREADTIME;
      squad.think       = Squad_Team_SpreadOut;
      squad.nextthink   = time + 0.1;
    }
  else
  if (squad.squadmemberstate == SQUAD_TEAMAMBUSH)
    { squad.search_time = time + SQUAD_AMBUSHDURATION;
      squad.think       = Squad_Team_Ambush;
      squad.nextthink   = time + 0.1;
    }
};



// Squad_Team_IsRegrouping - tells whether squad is currently
//                           in a regrouping state
//
//
float  (entity squad) Squad_Team_IsRegrouping =
{ return ((squad.squadmemberstate == SQUAD_TEAMREGROUP) ||
          (squad.squadmemberstate == SQUAD_TEAMCREATEASSEMBLE));
};



// Squad_Team_IsPointMan   - tells whether a member is pointman
//                           of his squad
//
//
float  (entity member) Squad_Team_IsPointMan =
{ return (member == alphaPointMember);
};



// Squad_Team_Idle         - "idle" thinks for team entity
//
//
//
void ()  Squad_Team_Idle =
{ // kill team entity if no members
  if (alphaTeamConfig == 0)
    { // auto respawn?
      if (Squad_Game_DoesSquadAutoRespawn())
        { self.ammo_shells = 0;
          self.search_time = time + 2 + 6 * random();
          self.squadmembernextstate = SQUAD_TEAMCREATE;
          Squad_Team_SetState(self, SQUAD_TEAMWAIT);
        }
      else
        { activeSquads = activeSquads - 1;
          remove(teamAlpha);
          teamAlpha    = world;
        }
    }
  else
    self.nextthink   = time + 0.5;
};



// Squad_Team_Wait         - "delayed state change" think
//
//
//
void ()  Squad_Team_Wait =
{ self.nextthink   = time + 0.1;
  if (time > self.search_time)
    Squad_Team_SetState(self, self.squadmembernextstate);
};



// Squad_Team_Regroup      - think for regrouping
//
//
//
void ()  Squad_Team_Regroup =
{ // do not think too often
  self.nextthink = time + 0.5;

  // now have nearby members assemble near location,
  // unless they are attacking something
  local float  spotters;
  local entity candidate;
  spotters  = 0;
  candidate = find(world, classname, "bot");
  while (candidate != world)
    { Squad_AI_TryAssembly(candidate, alphaAssemblyLocation);
      if (Squad_GetState(candidate) == SQUAD_MEMBERGUARD)
        spotters = spotters + 1;
      // ... and iterate
      candidate = find(candidate, classname, "bot");
    }

  // if > 2 members have assembled, or if team complete,
  // have members reload if necessary. If reloading
  // required, adjust regroup time
  if ((self.ammo_nails > 2) ||
      (spotters == self.ammo_nails)
     )
    { // test if members need reload
      local entity reloader;
      reloader = world;
      if (alphaAssembly1 != world)
      if (Squad_AI_GetReloadUrgency(alphaAssembly1) != SQUAD_RELOAD_UNNEEDED)
        reloader = alphaAssembly1;
      if (alphaAssembly2 != world)
      if (Squad_AI_GetReloadUrgency(alphaAssembly2) != SQUAD_RELOAD_UNNEEDED)
        reloader = alphaAssembly2;
      if (alphaAssembly3 != world)
      if (Squad_AI_GetReloadUrgency(alphaAssembly3) != SQUAD_RELOAD_UNNEEDED)
        reloader = alphaAssembly3;
      if (alphaAssembly1 != world)
      if (Squad_AI_GetReloadUrgency(alphaAssembly4) != SQUAD_RELOAD_UNNEEDED)
        reloader = alphaAssembly4;

      // if reloader != world, someone needs to reload
      if (reloader != world)
        { // adjust timeout for formation, if needed
          self.search_time = self.search_time + 2.0;
          // do not think again before reloader is finished
          self.nextthink = time + 2.0;
          // have reloader reload
          Squad_AI_StartReload(reloader);

          // and exit this think
          return ;
        }
    }

  // Finally, test if regroup is complete
  // thus, if assemblyCount == (#member that is spotting)
  // then, change state
  // A Degroup will be called as a consequence.


  // Also, change state after time-out
  if ((spotters == self.ammo_nails)                  ||
      (time - self.search_time > SQUAD_TEAMREGROUPTIME)
     )
    { // change team state (delayed transition to uncoordinated)
      self.squadmembernextstate = SQUAD_TEAMUNCOORDINATED;
      self.search_time          = time + 2.0;
      Squad_Team_SetState(self, SQUAD_TEAMWAIT);
    }
/*
  // dump regrouping info
  local string output;
  bprint("regroup[a:s] = [");
  bprint(ftos(self.ammo_nails));
  bprint(":");
  bprint(ftos(self.ammo_rockets));
  bprint("]\n");
  local string output;
  bprint("regroup[t:s] = [");
  bprint(ftos(alphaAssemblyCount));
  bprint(":");
  bprint(ftos(spotters));
  bprint("]");
  bprint(", 1:");
  if ((alpha1 != world) &&
      ((alpha1.squadmemberstate == SQUAD_MEMBERASSEMBLE) ||
       (alpha1.squadmemberstate == SQUAD_MEMBERPOSITION) ||
       (alpha1.squadmemberstate == SQUAD_MEMBERGUARD)
      )
     )
    bprint("+");
  else
    bprint("-");

  bprint(", 2:");
  if ((alpha2 != world) &&
      ((alpha2.squadmemberstate == SQUAD_MEMBERASSEMBLE) ||
       (alpha2.squadmemberstate == SQUAD_MEMBERPOSITION) ||
       (alpha2.squadmemberstate == SQUAD_MEMBERGUARD)
      )
     )
    bprint("+");
  else
    bprint("-");

  bprint(", 3:");
  if ((alpha3 != world) &&
      ((alpha3.squadmemberstate == SQUAD_MEMBERASSEMBLE) ||
       (alpha3.squadmemberstate == SQUAD_MEMBERPOSITION) ||
       (alpha3.squadmemberstate == SQUAD_MEMBERGUARD)
      )
     )
    bprint("+");
  else
    bprint("-");

  bprint(", 4:");
  if ((alpha4 != world) &&
      ((alpha4.squadmemberstate == SQUAD_MEMBERASSEMBLE) ||
       (alpha4.squadmemberstate == SQUAD_MEMBERPOSITION) ||
       (alpha4.squadmemberstate == SQUAD_MEMBERGUARD)
      )
     )
    bprint("+");
  else
    bprint("-");
  bprint("\n");
*/
};



// Squad_Team_SpreadOut      - think for spread out; currently
//                             only preventing too many spread outs
//
//
void ()  Squad_Team_SpreadOut =
{ // do not think too often
  self.nextthink = time + 0.2;

  // Also, change state after time-out
  if (time > self.search_time)
    { // change team state to uncoordinated
      Squad_Team_SetState(self, SQUAD_TEAMUNCOORDINATED);
    }
};



// Squad_Team_StartAmbush    - starts ambush
//
//
//
void (entity squad, entity member) Squad_Team_StartAmbush =
{ if (Squad_Team_GetState(squad) == SQUAD_TEAMAMBUSH)
    return;
  // set new state
  Squad_Team_SetState(squad, SQUAD_TEAMAMBUSH);
  // look for waypoint nearest to enemy position
  local entity waypnt;
  waypnt = Waypoint_Nearest(member.enemy);
  //bprint("nearest waypoint to enemy == ");
  //bprint(waypnt.netname);
  //bprint("\n");
  // location info
  squad.goalentity = waypnt;
  squad.oldorigin  = member.enemy.origin;
  squad.origin     = member.origin;

  // now instruct bots
  local entity teamMate, candidate;
  teamMate  = find(world, classname, "bot");
  while (teamMate != world)
    { if ((teamMate.team == member.team) &&
          (!Squad_AI_IsMemberAttacking(teamMate))
         )
        { if ((vlen(member.origin - teamMate.origin) < 200)   ||
              (Waypoint_IsVisible(squad.goalentity, teamMate))
             )
            { Squad_AI_DestroyMarker(teamMate.squadmarker);
              teamMate.squadmarker =
                Squad_AI_CreateMarker(member.enemy.origin, world);
              teamMate.goalentity = teamMate.squadmarker;
              Squad_SetState(teamMate, SQUAD_MEMBERAMBUSH);
            }
        }
      teamMate = find(teamMate, classname, "bot");
    }
};



// Squad_Team_StartAttack    - starts attack (basically,
//                             stops ambush)
//
//
void (entity squad) Squad_Team_StartAttack =
{ if (Squad_Team_GetState(squad) == SQUAD_TEAMAMBUSH)
    { Squad_Team_SetState(squad, SQUAD_TEAMUNCOORDINATED);
      // now instruct bots to stop ambush
      local entity teamMate;
      teamMate  = find(world, classname, "bot");
      while (teamMate != world)
        { if (teamMate.team == squad.team)
          if (Squad_GetState(teamMate) == SQUAD_MEMBERAMBUSH)
            Squad_SetState(teamMate, SQUAD_MEMBERPATROL);

          teamMate = find(teamMate, classname, "bot");
        }
    }
};



// Squad_Team_Ambush         - think for ambush; have nearby bots
//                             ambush as well
//
//
void ()  Squad_Team_Ambush =
{ // do not think too often
  self.nextthink = time + 0.2;

  // have neary bots ambush as well
  local entity teammember;
  teammember  = find(world, classname, "bot");
  while (teammember != world)
    { if (teammember.team == self.team)
      if (Squad_GetState(teammember) != SQUAD_MEMBERAMBUSH)
        { if ((vlen(self.origin - teammember.origin) < 200)    ||
              (Waypoint_IsVisible(self.goalentity, teammember))
             )
            { Squad_AI_DestroyMarker(teammember.squadmarker);
              teammember.squadmarker =
                Squad_AI_CreateMarker(self.oldorigin, world);
              teammember.goalentity = teammember.squadmarker;
              Squad_SetState(teammember, SQUAD_MEMBERAMBUSH);
            }
        }

      teammember = find(teammember, classname, "bot");
    }

  // Also, change state after time-out
  if (time > self.search_time)
    { // have teammembers stop ambush
      Squad_Team_StartAttack(self);
      // change team state to uncoordinated
      Squad_Team_SetState(self, SQUAD_TEAMUNCOORDINATED);
    }
};



// Squad_Team_Degroup      - orders assembling members to
//                           move out
//
//
void (entity squad)  Squad_Team_Degroup =
{ // remove assembly locations
  Squad_Team_RemoveAssemblyPositions(squad.team);

  // have all members stop assembly/positioning/spotting
  local entity candidate;
  candidate = find(world, classname, "bot");
  // should take into account team
  while (candidate != world)
    { Squad_Team_DismissFromFormation(candidate);
      candidate = find(candidate, classname, "bot");
    }

};



// Squad_Team_PrepareCreatePositions - spawns positions
//                                     (alphaAssembly1..4) to create
//                                     members
//
void (entity squad) Squad_Team_PrepareCreatePositions =
{ // spawn assemblypoints (auto remove)
  local entity spawnlocation;
  local vector location;
  spawnlocation  = Squad_Team_SelectSpawnPoint();
  location       = spawnlocation.origin + '0 0 16';
  squad.origin   = location;
  alphaAssembly1 = spawn();
  setorigin(alphaAssembly1, location + '48 0 0');
  alphaAssembly1.nextthink = time + 2.0;
  alphaAssembly1.think     = SUB_Remove;
  alphaAssembly2 = spawn();
  setorigin(alphaAssembly2, location + '0 48 0');
  alphaAssembly2.nextthink = time + 2.0;
  alphaAssembly2.think     = SUB_Remove;
  alphaAssembly3 = spawn();
  setorigin(alphaAssembly3, location + '-48 48 0');
  alphaAssembly3.nextthink = time + 2.0;
  alphaAssembly3.think     = SUB_Remove;
  alphaAssembly4 = spawn();
  setorigin(alphaAssembly4, location + '-48 0 0');
  alphaAssembly4.nextthink = time + 2.0;
  alphaAssembly4.think     = SUB_Remove;
};




// Squad_Team_Create - construct new team
//
//
//
void ()  Squad_Team_Create =
{ if ((activeSquads < SQUAD_MAX) && (Waypoint_AreAvailable()))
    { activeSquads = activeSquads + 1;

      // spawn new SquadTeam entity
      local entity squad_team;
      squad_team = spawn();
      squad_team.classname     = "squad_team";
      squad_team.teleport_time = time;
      // now set .team to value != player.team
      local entity thePlayer;
      thePlayer = find(world, classname, "player");
      if (thePlayer == world)
        squad_team.team = 2;
      else
        { squad_team.team = thePlayer.team + 1;
          if (squad_team.team > 15)
            squad_team.team = 0;
        }

      // set name
      if (activeSquads == 1)
        { // first squad, init waypoints first
          // Waypoint_Init (); - now done in pre-cache

          // assign entity to global
          teamAlpha = squad_team;

          // init Squad_Team itself
          alphaPointMember   = world;
          alphaPointWaypoint = 0;
          alphaTeamConfig    = 0;
          squad_team.netname = "Alpha";
          sprint (self, "Team Alpha arriving\n");
        }
      else
      if (activeSquads == 2)
        { squad_team.netname  = "Bravo";
          sprint (self, "Team Bravo starts to clean up this mess\n");
        }
      else
      if (activeSquads == 3)
        { squad_team.netname  = "Charlie";
          sprint (self, "With Team Charlie, things start to go bloody\n");
        }
      else
      if (activeSquads == 4)
        { squad_team.netname  = "Delta";
          sprint (self, "Team Delta will make a difference\n");
        }

      // set state
      Squad_Team_SetState(squad_team, SQUAD_TEAMCREATE);
    }
  else
    sprint(self, "You really do not want another team hunting you!\n");
};



// Squad_Team_CreateMember - construct a new member for a team
//
//
//
void ()  Squad_Team_CreateMember =
{ // check for maximum team size
  if (self.ammo_shells < SQUAD_MEMBERSMAX)
    { self.ammo_shells = self.ammo_shells + 1;
      self.nextthink = time + SQUAD_CREATEDELAY;

      // create new member
      local entity member;
      local float  id, new;
      id = self.ammo_shells;

      new = FALSE;
      if (self.netname == "Alpha") // team Alpha
        { // take into account member id and if member already
          // exists
          if (id == 1)
            { if (alpha1 == world)
                { member = spawn();
                  alpha1 = member;
                  member.netname  = "Alpha One";
                  new    = TRUE;
                }
              else
                member = alpha1;

              // in case of first member, determine MP5 usage
              // for this squad
              if (random() > 0.5)
                self.weapon = WP_MP5; // MP5
              else
                self.weapon = WP_MP5SD;   // silencer MP5SD
            }
          else if (id == 2)
            { if (alpha2 == world)
                { member = spawn();
                  alpha2 = member;
                  member.netname  = "Alpha Two";
                  new    = TRUE;
                }
              else
                member = alpha2;
            }
          else if (id == 3)
            { if (alpha3 == world)
                { member = spawn();
                  alpha3 = member;
                  member.netname  = "Alpha Three";
                  new    = TRUE;
                }
              else
                member = alpha3;
            }
          else if (id == 4)
            { if (alpha4 == world)
                { member = spawn();
                  alpha4 = member;
                  member.netname  = "Alpha Four";
                  new    = TRUE;
                }
              else
                member = alpha4;
            }

          // set color
          member.colormap = 0;
          member.fShirt   = 11;
          member.fPants   = 11;
          // set role
          if (Squad_Game_GetSquadComposition() == SQUAD_TEAM_HANDGUNONLY)
            Squad_SetRole(member, SQUAD_ROLE_HANDGUNSOLDIER);
          else
          if (Squad_Game_GetSquadComposition() == SQUAD_TEAM_MACHINEGUNONLY)
            { Squad_SetRole(member, SQUAD_ROLE_MACHINEGUNSOLDIER);
            }
          else
            { if (random() > 0.5)
                Squad_SetRole(member, SQUAD_ROLE_HANDGUNSOLDIER);
              else
                Squad_SetRole(member, SQUAD_ROLE_MACHINEGUNSOLDIER);
            }

        }

      Squad_MemberInit(member);
      member.team  = self.team;

      if (new)
        botConnect(member);

      // HACK
      // redefine weapon, if necessary
      if ((Squad_GetRole(member) == SQUAD_ROLE_MACHINEGUNSOLDIER) &&
          (self.weapon == WP_MP5SD)
         )
        { member.weapon =  WP_MP5SD;
          member.items  = member.items - WP_MP5 + WP_MP5SD;
        }

      if (teamplay)
        { // use alphaAssembly's for origin
          if (id == 1)
            member.origin = alphaAssembly1.origin;
          else
          if (id == 2)
            member.origin = alphaAssembly2.origin;
          else
          if (id == 3)
            member.origin = alphaAssembly3.origin;
          else
          if (id == 4)
            member.origin = alphaAssembly4.origin;
        }
      spawn_tfog (member.origin);
      //spawn_tdeath(member.origin, member);
      setorigin(member, member.origin);
    }
  else
    { // if not assembling already, change state to UNCOORDINATED
      // else, change state to regroup
      if (Squad_Team_GetState(self) != SQUAD_TEAMCREATEASSEMBLE)
        Squad_Team_SetState(self, SQUAD_TEAMUNCOORDINATED);
      else
        Squad_Team_SetState(self, SQUAD_TEAMREGROUP);
    }
};




// Squad_Team_StartRegroup - forces state change and
//                           instructs squad members
//
//
void (entity squad, entity point, entity member) Squad_Team_StartRegroup =
{ Squad_Team_SetState(squad, SQUAD_TEAMREGROUP);

  local entity startAssemblyPoint;
  startAssemblyPoint
    = Squad_Team_SpawnAssemblyPositions(squad.team, point);

  // reset assembly and formation size
  squad.ammo_nails   = 0;
  squad.ammo_rockets = 0;

  // for now on, ignore squad parameter and assume alpha
  alphaAssemblyLocation  = startAssemblyPoint;

  alphaAssembly1         = world;
  alphaAssembly2         = world;
  alphaAssembly3         = world;
  alphaAssembly4         = world;

  // now have nearby members assemble near location,
  // unless they are attacking something
  local entity candidate;
  candidate = find(world, classname, "bot");
  while (candidate != world)
    { Squad_AI_TryAssembly(candidate, startAssemblyPoint);
      candidate = find(candidate, classname, "bot");
    }

  // overrule state for member - direct him to first assemblypoint
  Squad_Team_ArriveAtAssembly(member);
};



// Squad_Team_JoinAssembly - update count of members to assemble
//
//
//
void (entity squad, entity member) Squad_Team_JoinAssembly =
{ // update count
  squad.ammo_nails = squad.ammo_nails + 1;
};



// Squad_Team_JoinFormation - update count of members to form formation
//
//
//
void (entity squad, entity member, entity position) Squad_Team_JoinFormation =
{ // update count
  squad.ammo_rockets = squad.ammo_rockets + 1;
  // claim position
  if (position.ammo_shells == 1)
    alphaAssembly1 = member;
  if (position.ammo_shells == 2)
    alphaAssembly2 = member;
  if (position.ammo_shells == 3)
    alphaAssembly3 = member;
  if (position.ammo_shells == 4)
    alphaAssembly4 = member;
  // after second member, have position 1 sit (if formed up)
  if ((squad.ammo_rockets >= 2) && (alphaAssembly1 != world))
    Squad_Behavior_TrySit(alphaAssembly1);
};



// Squad_Team_LeaveAssembly - update count of members to assemble
//
//
//
void (entity squad, entity member) Squad_Team_LeaveAssembly =
{ // update count
  squad.ammo_nails = squad.ammo_nails - 1;
};



// Squad_Team_LeaveFormation - update count of members to form up
//
//
//
void (entity squad, entity member) Squad_Team_LeaveFormation =
{ // update count
  squad.ammo_rockets = squad.ammo_rockets - 1;
  // mark claimed position as free
  if (alphaAssembly1 == member)
    alphaAssembly1 = world;
  else
  if (alphaAssembly2 == member)
    alphaAssembly2 = world;
  else
  if (alphaAssembly3 == member)
    alphaAssembly3 = world;
  else
  if (alphaAssembly4 == member)
    alphaAssembly4 = world;
  // update positions, obtain pointer to free position
  local entity vacantPosition;
  vacantPosition = Squad_Team_GetMembersAssemblyPosition(member);
  if (vacantPosition != world)
    { //bprint(member.netname);
      //bprint(" leaves position ");
      //bprint(ftos(vacantPosition.ammo_shells));
      //bprint("\n");
      Squad_Team_FreeAssemblyPosition(vacantPosition);
    }
};



// Squad_Team_Join - used for member registration
//                   (to process dead and respawned
//                    members)
//
void (entity member) Squad_Team_Join =
{ local float flag;
  flag = 0;
  if (member == alpha1)
    flag = 1;
  else
  if (member == alpha2)
    flag = 2;
  else
  if (member == alpha3)
    flag = 4;
  else
  if (member == alpha4)
    flag = 8;

  alphaTeamConfig = alphaTeamConfig | flag;
  //bprint("new SquadTeam config = ");
  //bprint(ftos(alphaTeamConfig));
  //bprint("\n");
};



// Squad_Team_Leave - used for member registration
//                   (to process dead and respawned
//                    members)
//
void (entity member) Squad_Team_Leave =
{ local float flag;
  flag = 0;
  if (member == alpha1)
    flag = 1;
  else
  if (member == alpha2)
    flag = 2;
  else
  if (member == alpha3)
    flag = 4;
  else
  if (member == alpha4)
    flag = 8;

  alphaTeamConfig = alphaTeamConfig
                    - (alphaTeamConfig & flag);
/*
  bprint("SquadTeam config = ");
  bprint(ftos(alphaTeamConfig));
  bprint("\n");
*/
};



// Squad_Team_UpdateMemberPosition - member provides new
//                                   info to coordinating team
//
//
void (entity member, entity point) Squad_Team_UpdateMemberPosition =
{ // test for assembly
  if (Waypoint_IsAssemblyLocation(point, member.squadWaypointDirection))
  if (Waypoint_GetTimeSincePreviousVisit(point) > 45)
    { Waypoint_UpdateLastVisitTime(point, time);
      Squad_Team_StartRegroup(teamAlpha, point, member);
      return;
    }

  // test for spread out
  if (Waypoint_IsSpreadLocation(point, member.squadWaypointDirection))
  if (Waypoint_GetTimeSincePreviousVisit(point) > 30)
  if (Squad_Team_GetState(teamAlpha) != SQUAD_TEAMSPREADOUT)
    { Waypoint_UpdateLastVisitTime(point, time);
      // compute additional point
      local entity nextPoint;
      if (member.squadWaypointDirection == SQUAD_WAYPOINT_DIRECTION_POS)
        nextPoint = Waypoint_Next(point);
      else
        nextPoint = Waypoint_Previous(point);
      Squad_Team_StartSpreadOut(teamAlpha, point, nextPoint);
      return;
    }
/*
  local float waypointNumber;
  waypointNumber = Waypoint_GetNumber(point);
    if (waypointNumber > alphaPointWaypoint)
    { alphaPointWaypoint = waypointNumber;
      if (alphaPointMember != member)
        { alphaPointMember = member;
        }
    }
*/
};



// Squad_Team_ArriveAtAssembly - instruct member now he has
//                               arrived at assembly location
//
//
void (entity member) Squad_Team_ArriveAtAssembly =
{ // debug info
  if (!Squad_Team_HasAssignedAssemblyPosition(member))
    { // obtain position to move to
      local entity nextPosition;
      nextPosition = Squad_Team_GetNextAssemblyPosition(member.team);
      Squad_Team_AssignAssemblyPositionOccupant(nextPosition, member);
      // have member go there
      member.squadmarker
        = Squad_AI_CreateMarker(nextPosition.origin, nextPosition);
      Squad_SetState(member, SQUAD_MEMBERPOSITION);
    }
};



// Squad_Team_ArriveAtPosition - instruct member now he has
//                               arrived at exact assembly position
//
//
void (entity member, entity assemblyPosition) Squad_Team_ArriveAtPosition =
{ local float spotDirection;
  spotDirection
    = Squad_Team_GetAssemblyPositionSpotDirection(assemblyPosition);
  Squad_AI_InitSpotting(member, spotDirection, 45);
  Squad_SetState(member, SQUAD_MEMBERGUARD);
};



// Squad_Team_DismissFromFormation - have member operate on his
//                                   own (again)
//
//
void (entity member) Squad_Team_DismissFromFormation =
{ if (member != world)
    { if ((Squad_GetState(member) == SQUAD_MEMBERGUARD)    ||
          (Squad_GetState(member) == SQUAD_MEMBERPOSITION) ||
          (Squad_GetState(member) == SQUAD_MEMBERASSEMBLE)
         )
        Squad_SetState(member, SQUAD_MEMBERPATROL);
    }
};



// Squad_Team_NeedsSpreadOut - test if team members around point1 have a
//                             sufficient number of lines of fire
//                             to attack point2.
//
float (entity squad, entity point1, entity point2) Squad_Team_NeedsSpreadOut =
{ // lookup all members of the team near point1
  local entity member1, member2, member3, member4, member;
  local float  fDist, nrMembers, nrLinesOfFire;
  nrMembers     = 0;
  nrLinesOfFire = 0;
  //member1       = world;
  //member2       = world;
  //member3       = world;
  //member4       = world;
  member        = find(world, classname, "bot");
  while (member != world)
    { fDist = vlen(point1.origin - member.origin);
      if ((member.team == squad.team) &&
          (fDist < 200)
         )
        { if (Squad_AI_HasClearLineOfFire(member, point2))
            nrLinesOfFire = nrLinesOfFire + 1;
          /*
          // store in any of member1...member4
          if (member1 == world)
            member1 = member;
          else
          if (member2 == world)
            member2 = member;
          else
          if (member3 == world)
            member3 = member;
          else
            member4 = member;
          */
          nrMembers = nrMembers + 1;
        }
      member = find(member, classname, "bot");
    }

  // now, compute result
  if ((nrMembers < 3) || (nrLinesOfFire > 1))
    return FALSE;
  else
    return TRUE;
};



// Squad_Team_StartSpreadOut - have team spread out members
//                             to obtain better firing positions
//                             and be less vulnerable for attacks
//
void (entity squad, entity point1, entity point2) Squad_Team_StartSpreadOut =
{ // test if spread out occurred recently (in that case, team
  // is still in state spread out); otherwise change state to
  // spread out
  if (Squad_Team_GetState(squad) == SQUAD_TEAMSPREADOUT)
    return;

  // if point1 not a waypoint, test if members really too
  // close to each other
  if (point1.classname != "waypoint")
  if (!Squad_Team_NeedsSpreadOut(squad, point1, point2))
    return;
  else
    Squad_Team_SetState(squad, SQUAD_TEAMSPREADOUT);

  // adjust spreadout time (waypoint == 2s, enemy == 1s)
  if (point1.classname == "waypoint")
    squad.search_time = time + 2.0;
  else
    squad.search_time = time + 1.0;


  // compute direction
  local vector direction;
  direction   = point2.origin - point1.origin;

  // use the following spread formation
  //
  //              3
  //           2        1
  //                4
  //
  //
  // thus,  +20, -20, +60, -50
  //        1.1  1.1    1     1

  direction = normalize(direction);

  local entity marker1, marker2, marker3, marker4;
  // get an offset if point1 is a waypoint
  local float  offset;
  if (point1.classname == "waypoint")
    offset = Waypoint_GetAssemblyOffset(point1);
  else
    offset = 0;

  // put markers
  local vector dirAngles;
  dirAngles = vectoangles(direction);
  // marker1, +30, distance 1x
  dirAngles_y = anglemod(dirAngles_y - 30);
  makevectors(dirAngles);
  normalize(v_forward);
  marker1 =
    Squad_AI_CreateMarker(point1.origin + (v_forward * (offset + 100)), world);
  if (waypointsVisible)
    setmodel(marker1, "progs/armor.mdl");
  // marker2, -30, distance 1 x
  dirAngles_y = anglemod(dirAngles_y + 60);
  makevectors(dirAngles);
  normalize(v_forward);
  marker2 =
    Squad_AI_CreateMarker(point1.origin + (v_forward * (offset + 100)), world);
  if (waypointsVisible)
    setmodel(marker2, "progs/armor.mdl");
  // marker3, -10, distance 1.3x
  dirAngles_y = anglemod(dirAngles_y - 70);
  makevectors(dirAngles);
  normalize(v_forward);
  marker3 =
    Squad_AI_CreateMarker(point1.origin + (v_forward * (offset + 130)), world);
  if (waypointsVisible)
    setmodel(marker3, "progs/armor.mdl");
  // marker4, +10, distance .8
  dirAngles_y = anglemod(dirAngles_y + 20);
  makevectors(dirAngles);
  normalize(v_forward);
  marker4 =
    Squad_AI_CreateMarker(point1.origin + (v_forward * (offset +  80)), world);
  if (waypointsVisible)
    setmodel(marker4, "progs/armor.mdl");


  // now look up to four times for the nearest member
  // that should join spread and has not been assigned
  // a marker.
  // if a member is found, he is assigned the marker.
  local float  memberCount;
  local entity member, nearestMember;
  local float  dist, minDist;
  local vector vDist;

  memberCount    = 4; // teamsize
  nearestMember  = self; // hack, !world
  while ((memberCount > 0) && (nearestMember != world))
    { // look for another near(est)by member that is
      // not yet spreading out
      minDist       = 1000;
      nearestMember = world;
      member        = find(world, classname, "bot");
      while (member != world)
        { // test if member is near enough to spread point
          // vertical distance is weighed heavily.
          // test if member is closer than others
          // test also if member not already spreading
          vDist    = member.origin - point1.origin;
          vDist_z  = 2 * vDist_z;
          dist     = vlen(vDist);
          if ((dist < 150)                                   &&
              (dist < minDist)                               &&
              (Squad_GetState(member) != SQUAD_MEMBERSPREAD) &&
              (Squad_GetState(member) != SQUAD_MEMBERDIE)
             )
            { minDist = dist;
              nearestMember = member;
            }
          // find next
          member = find(member, classname, "bot");
        }
      // now give member a marker
      if (nearestMember != world)
        { // give marker, depending on memberCount
          local entity marker;
          if (memberCount == 4)
            marker = marker1;
          else
          if (memberCount == 3)
            marker = marker2;
          else
          if (memberCount == 2)
            marker = marker3;
          else
            marker = marker4;
          // set marker and state
          Squad_AI_DestroyMarker(nearestMember.squadmarker);
          nearestMember.squadmarker = marker;
          Squad_SetState(nearestMember, SQUAD_MEMBERSPREAD);
          // set timeout
          nearestMember.search_time = squad.search_time;

          // update counter
          memberCount = memberCount - 1;
        }

      // note: nearestMember == world breaks while loop
    }

  // now clean up markers that have not had a member assigned
  // to them
  if (memberCount >= 4)
    remove(marker1);
  if (memberCount >= 3)
    remove(marker2);
  if (memberCount >= 2)
    remove(marker3);
  if (memberCount >= 1)
    remove(marker4);
};



// Squad_Team_ShouldUseGrenade - determine if member is allowed
//                               to use a grenade against target
//
//
float  (entity member, entity subject) Squad_Team_ShouldUseGrenade =
{ local float  result;
  // don't have a grenade throwed to subject if in last
  // 3 seconds, a grenade has already been throwed
  if (time - teamAlpha.teleport_time < SQUAD_SPREAD_INTERGRENADETIME)
    return FALSE;

  // don't have a grenade throwed to subject if other
  // members near subject
  local entity teammember;
  local vector vDist;
  local float  fDist;
  result     = TRUE;
  teammember = find(world, classname, "bot");
  while ((result) && (teammember != world))
    { if ((teammember != member)           &&
          (teammember.team == member.team)
         )
       { // ignore vertical distance
         vDist   = teammember.origin - subject.origin;
         vDist_z = 0.3 * vDist_z;
         fDist   = vlen(vDist);
         // decide if safe
         result = (fDist > 300);

         //dprint(teammember.netname);
         //dprint(" is at about ");
         //dprint(ftos(fDist));
         //dprint(" distance\n");
       }
     if (result)
       teammember = find(teammember, classname, "bot");
    }
  if ((result) && (random() > 0.7))
    { // record grenade throwing
      teamAlpha.teleport_time = time;
      return TRUE;
    }
  else
    return FALSE;
};



// implementation - info - class AssemblyPosition
//
//   assembly positions map on entities reusing standard entities fields
//   - ammo_shells -> priority (ordering of positions)
//   - ammo_nails  -> position occupied
//   - enemy       -> squad member to occupy this position
//
//
//   assembly positions are used to have team members move into
//   programmed positions and to set their behavior from the
//   moment they've moved into position.
//   assembly positions have a priority (1 is highest, 5 is
//   lowest). if a member that has been assigned to visit
//   a specific assembly position visits that position, the
//   position is occupied.
//   typically, assembly (a Team Regroup) is caused by the point
//   man of a patrol touching a waypoint.
//   then, up to 4 assembly positions for the members, and
//   an additional "direction/routing" assembly position are
//   spawned. The first 4 positions are final positions, and
//   define the "next" behavior of the member which takes position
//   there.
//   In a regroup or assembly, all nearby members are targeted
//   to the fifth assembly point. This assembly point, upon
//   being touched, directs the to the highest priority unoccupied
//   assembly position.
//   Members that move to the 5th position via other positions,
//   are directed to the to the highest priority unoccupied
//   assembly position immediately.



// Squad_Team_SpawnAssemblyPosition - auxiliary function that spawns an
//                                    assembly position entity
//
//
entity (float teamId, vector assemblyLocation, float spotDirection,
        float priority)
Squad_Team_SpawnAssemblyPosition =
{ local entity assemblyPosition;
  assemblyPosition = spawn();
  // set teamid (for later removal), position, direction, and priority
  assemblyPosition.team        = teamId;
  setorigin (assemblyPosition, assemblyLocation);
  assemblyPosition.angles_y    = spotDirection;
  assemblyPosition.ammo_shells = priority;
  assemblyPosition.ammo_nails  = FALSE;
  assemblyPosition.enemy       = world;
  // set classname, and other attributes
  assemblyPosition.classname   = "assemblyposition";
  assemblyPosition.netname     = ftos(priority);
  // set touch function
  assemblyPosition.solid       = SOLID_TRIGGER;
  assemblyPosition.touch       = Squad_Team_TouchAssemblyPosition;
  if (waypointsVisible)
    setmodel(assemblyPosition, "progs/s_spike.mdl");
  assemblyPosition.size        = '16 16 32';
  return assemblyPosition;
};




// Squad_Team_TouchAssemblyPosition - touch function for assembly point
//
//
//
void () Squad_Team_TouchAssemblyPosition =
{ if (other.classname == "bot")
    { if ((!self.ammo_nails ) && (self.enemy == other))
        { // though member has not arrived at final
          // destination yet, already mark position as
          // occupied
          self.ammo_nails = TRUE;
          /*
          bprint(other.netname);
          bprint(" occupies ");
          bprint(ftos(self.ammo_shells));
          bprint("\n");
          */
        }
      else
      if ((self.enemy != other) &&
          (Squad_GetState(other) == SQUAD_MEMBERASSEMBLE)
         )
        { // direct member to position, if necessary
          if (!Squad_Team_HasAssignedAssemblyPosition(other))
            { // obtain position to move to
              local entity nextPosition;
              nextPosition = Squad_Team_GetNextAssemblyPosition(other.team);
              Squad_Team_AssignAssemblyPositionOccupant(nextPosition, other);
              // have member go there
              other.squadmarker
                = Squad_AI_CreateMarker(nextPosition.origin, nextPosition);
              Squad_SetState(other, SQUAD_MEMBERPOSITION);
            }
        }
    }

};



// Squad_Team_GetAssemblyPositionSpotDirection - returns spotting direction
//                                               for member in this position.
//
//
float  (entity assemblyPosition) Squad_Team_GetAssemblyPositionSpotDirection =
{ return assemblyPosition.angles_y;
};



// Squad_Team_SpawnAssemblyPositions - spawn entities containing information
//                                     for team members to assemble.
//                                     return the entity best suited for
//                                     initial assembly.
//
entity (float teamId, entity point) Squad_Team_SpawnAssemblyPositions =
{ // spawn assembly positions in x steps
  // 1. calculate center of assembly position (assemblyLocation)
  // 2. calculate main spotting direction (assemblyYaw)
  // 3. calculate individual locations, and corresponding spotting directions

  local vector assemblyLocation;
  local entity startAssemblyPoint;
  local float  assemblyYaw, assemblyFormation;
  local float  fillupDirection;
  // for now on, ignore squad parameter and assume alpha
  assemblyYaw       = Waypoint_GetAssemblyYaw(point);
  assemblyFormation = Waypoint_GetAssemblyFormation(point);

  // steps 1 and 2:
  // create an assembly location
  if (assemblyFormation & FL_WAYPOINT_ASSEMBLY_SQUARE)
    { assemblyLocation  = point.origin;
      if (assemblyYaw < 0)
        fillupDirection = -1;
      else
        fillupDirection =  1;
    }
  else
    { // both L and line formation look for nearest wall
      // and the direction of that wall
      local vector spot1, spot2;
      local vector direction;
      local float  fWallDist, fWallDistMin, i, iWallClosest;
      spot1        = point.origin;
      direction    = '0 0 0';
      fWallDistMin = 200;
      while (i < 360)
        { // look for nearest wall in all directions
          direction_y = i;
          makevectors(direction);
          direction   = normalize(direction);
          spot2       = spot1 + v_forward * 200;
          traceline(spot1, spot2, TRUE, point);
          fWallDist = vlen(trace_endpos - spot1);
          if (fWallDist < fWallDistMin)
            { fWallDistMin = fWallDist;
              iWallClosest = i;
            }
          i = i + 10;
        }

      // now use two points in direction iWallClosest to
      // determine direction of wall
      local float  yaw_guess;
      local vector p1, p2;
      direction_y = anglemod(iWallClosest - 5);
      makevectors(direction);
      direction   = normalize(direction);
      spot2       = spot1 + v_forward * 200;
      traceline(spot1, spot2, TRUE, point);
      p1 = trace_endpos;
      direction_y = anglemod(iWallClosest + 5);
      makevectors(direction);
      direction   = normalize(direction);
      spot2       = spot1 + v_forward * 200;
      traceline(spot1, spot2, TRUE, point);
      p2 = trace_endpos;

      direction = p1 - p2;
      direction = normalize(direction);

      yaw_guess = vectoyaw(direction);

      // finally, the direction

      // change if yaw_guess is about 180 degrees from yaw
      if (anglemod(assemblyYaw - yaw_guess) > 90)
        assemblyYaw = anglemod(180 - yaw_guess);
      if (anglemod(yaw_guess - assemblyYaw) > 90)
        assemblyYaw = anglemod(180 - yaw_guess);

      // compute the best assembly position
      assemblyLocation  = point.origin;
      // compute view direction for fillupDirection
      direction = spot1 - p2;
      direction = normalize(direction);
      yaw_guess = vectoyaw(direction);

      if (anglemod(assemblyYaw - yaw_guess) > 180)
        fillupDirection =  1;
      else
        fillupDirection = -1;
    }

  // step 3
  // now define final spot position, using memberDirection
  local float memberDirection;


  if (assemblyFormation & FL_WAYPOINT_ASSEMBLY_SQUARE)
    { // square formation,
      //                ^
      //                3
      //       <-  <1       2>
      //                4
      //                v

      local vector vAngles;
      local vector vOffset;
      vAngles         = '0 0 0';

      // position 1
      memberDirection = anglemod(assemblyYaw);
      vAngles_y       = memberDirection;
      makevectors(vAngles);
      vOffset   = v_forward;
      vOffset   = normalize(vOffset);
      vOffset   = assemblyLocation + 50 * v_forward;
      Squad_Team_SpawnAssemblyPosition(teamId, vOffset, memberDirection, 1);

      // position 2
      memberDirection = anglemod(assemblyYaw + 180 * fillupDirection);
      vAngles_y       = memberDirection;
      makevectors(vAngles);
      vOffset   = v_forward;
      vOffset   = normalize(vOffset);
      vOffset   = assemblyLocation + 50 * v_forward;
      Squad_Team_SpawnAssemblyPosition(teamId, vOffset, memberDirection, 2);

      // position 3
      memberDirection = anglemod(assemblyYaw + 270 * fillupDirection);
      vAngles_y       = memberDirection;
      makevectors(vAngles);
      vOffset   = v_forward;
      vOffset   = normalize(vOffset);
      vOffset   = assemblyLocation + 40 * v_forward;
      Squad_Team_SpawnAssemblyPosition(teamId, vOffset, memberDirection, 3);

      // position 4
      memberDirection = anglemod(assemblyYaw +  90 * fillupDirection);
      vAngles_y       = memberDirection;
      makevectors(vAngles);
      vOffset   = v_forward;
      vOffset   = normalize(vOffset);
      vOffset   = assemblyLocation + 40 * v_forward;
      startAssemblyPoint = Squad_Team_SpawnAssemblyPosition(teamId,
                             vOffset, memberDirection, 4);
    }
  else
    {
      // line formation
      //             <- 180 ->
      //       <-  <1  2   3    4>
      //             v    v
      local vector vAngles;
      local vector vOffset;
      vAngles   = '0 0 0';
      vAngles_y = anglemod(assemblyYaw);
      makevectors(vAngles);
      vOffset   = v_forward;
      vOffset   = normalize(vOffset);

      // position 1
      vOffset         = assemblyLocation + 150 * v_forward;
      memberDirection = anglemod(assemblyYaw);
      Squad_Team_SpawnAssemblyPosition(teamId, vOffset, memberDirection, 1);
      // position 2
      vOffset         = assemblyLocation +  90 * v_forward;
      memberDirection = anglemod(assemblyYaw +  45 * fillupDirection);
      Squad_Team_SpawnAssemblyPosition(teamId, vOffset, memberDirection, 2);
      // position 3
      vOffset         = assemblyLocation +  30 * v_forward;
      memberDirection = anglemod(assemblyYaw +  90 * fillupDirection);
      Squad_Team_SpawnAssemblyPosition(teamId, vOffset, memberDirection, 3);
      // position 4
      vOffset         = assemblyLocation -  30 * v_forward;
      memberDirection = anglemod(assemblyYaw + 180 * fillupDirection);
      startAssemblyPoint = Squad_Team_SpawnAssemblyPosition(teamId,
                             vOffset, memberDirection, 4);
    }

  // return the position members should to try to start assembling
  return startAssemblyPoint;
};



// Squad_Team_RemoveAssemblyPositions - removes all spawned assembly position
//                                      entities for a given team.
//
//
void (float teamId) Squad_Team_RemoveAssemblyPositions =
{ local entity assemblyPosition, alias;
  assemblyPosition = find(world, classname, "assemblyposition");
  while (assemblyPosition != world)
    { if (assemblyPosition.team == teamId)
        alias = assemblyPosition;
      // ... and iterate
      assemblyPosition = find(assemblyPosition, classname,
                              "assemblyposition");
      // ... and remove
      remove(alias);
    }
};



// Squad_Team_GetNextAssemblyPosition - returns highest priority unassigned
//                                      assembly position.
//
//
entity (float teamId) Squad_Team_GetNextAssemblyPosition =
{ local entity assemblyPosition;
  local entity bestPosition;
  local float  bestPriority;

  bestPosition = world;
  bestPriority = 100;
  assemblyPosition = find(world, classname, "assemblyposition");
  while (assemblyPosition != world)
    { //if (assemblyPosition.team == teamId)
      if ((assemblyPosition.enemy == world) &&
          (assemblyPosition.ammo_shells < bestPriority)
         )
        { bestPosition = assemblyPosition;
          bestPriority = assemblyPosition.ammo_shells;
        }
      // ... and iterate
      assemblyPosition = find(assemblyPosition, classname,
                              "assemblyposition");
    }
  /*
  // debug
  bprint("GetNextAssembly returns ");
  if (bestPosition == world)
    bprint("world");
  else
    { bprint(bestPosition.classname);
      bprint(" ");
      bprint("prio: ");
      bprint(ftos(bestPriority));
    }
  bprint("\n");
  */
  return bestPosition;
};



// Squad_Team_AssignAssemblyPositionOccupant - sets member to be occupant of
//                                             this assembly position.
//
//
void   (entity assemblyPosition,
        entity member)
Squad_Team_AssignAssemblyPositionOccupant =
{ assemblyPosition.enemy = member;
};





// Squad_Team_HasAssignedAssemblyPosition - returns whether a position had
//                                          been assigned for this member.
//
//
float (entity member) Squad_Team_HasAssignedAssemblyPosition =
{ local float result;
  result = FALSE;

  local entity assemblyPosition;
  assemblyPosition = find(world, classname, "assemblyposition");
  while ((!result) && (assemblyPosition != world))
    { if (assemblyPosition.enemy == member)
        result = TRUE;

      // ... and iterate
      assemblyPosition = find(assemblyPosition, classname,
                              "assemblyposition");
    }
  // return result
  return result;
};



// Squad_Team_GetMembersAssemblyPosition - returns the position occupied by
//                                         somemember; world if not found.
//
//
entity (entity member) Squad_Team_GetMembersAssemblyPosition =
{ local float result;
  result = FALSE;

  local entity assemblyPosition;
  assemblyPosition = find(world, classname, "assemblyposition");
  while ((!result) && (assemblyPosition != world))
    { if (assemblyPosition.enemy == member)
        result = TRUE;
      else
        // ... and iterate
        assemblyPosition = find(assemblyPosition, classname,
                                "assemblyposition");
    }
  // return resulting assemblyPosition
  if (result)
    return assemblyPosition;
  else
    return world;
};



// Squad_Team_FreeAssemblyPosition - clears occupation and assignment
//                                   of the assembly position
//
//
void (entity assemblyPosition) Squad_Team_FreeAssemblyPosition =
{ assemblyPosition.enemy = world;
};



// Squad_Team_MaybeRequestAssistance - test if need to call for assistance;
//                                     if so, activate nearby members (via
//                                     state HuntEnemy); have other members
//                                     run to "here", if appropiate
float  (entity member, entity aTarget,
        float  totalTargets)
Squad_Team_MaybeRequestAssistance =
{ // test for assistance need

  // no assistance if there has been a previous call
  if (Squad_GetState(member) == SQUAD_MEMBERATTACK)
    return FALSE;

  // try to get nearby assistance
  local float  result;
  local entity teamMate;
  result   = FALSE;
  teamMate = find(world, classname, "bot");
  while (teamMate != world)
    { // have teamMate assist, it is a teamMate, if he is
      // near, not currently attacking, defending, dieing,
      // spreading out,
      // waiting (delayed attack) or hunting enemies
      if (teamMate.team == member.team)
      if (teamMate != member)
      if (!Squad_AI_IsMemberAttacking(teamMate))
      if (Squad_GetState(teamMate) != SQUAD_MEMBERDIE)
        { local float enemyHops;
          enemyHops = Squad_Behavior_WaypointNodeDistance(teamMate, aTarget);

          // nearby or far member?
          local float hops;
          hops = Squad_Behavior_WaypointNodeDistance(teamMate, member);
          if ((hops > -2) && (hops < 2))
            { // create marker on enemy's position, then have
              // teamMate hunt enemy around the marker
              local entity marker;
              Squad_AI_DestroyMarker(teamMate.squadmarker);
              marker = Squad_AI_CreateMarker(aTarget.origin, world);
              // remove teamMate's ref to enemy
              teamMate.squadmarker = marker;
              teamMate.enemy       = world;
              // now decide if teamMate should go for marker
              // immediately, or via waypoints
              if ((Waypoint_IsVisible(marker, teamMate)) ||
                  (enemyHops == 0)
                 )
                Squad_SetState(teamMate, SQUAD_MEMBERHUNTENEMY);
              else
                Squad_SetState(teamMate, SQUAD_MEMBERRUNTOHELP);
              result = TRUE;
            }
          else
          if (((hops >  1) && (hops <  7)) ||
              ((hops < -1) && (hops > -7))
             )
            { // far member
              Squad_SetState(teamMate, SQUAD_MEMBERRUNTOHELP);
              result = TRUE;
            }
          // have teamMate change direction, if necessary
          if (result)
            Squad_AI_ConsiderChangeDirection(teamMate, aTarget);

          // debug
          if (hops > -2)
          if (SQUAD_MEMBER_STATECHANGEINFO == 1)
            { bprint(member.netname);
              bprint(" will be assisted by ");
              bprint(teamMate.netname);
              bprint("\n");
            }
        }

      // other team mates
      teamMate = find(teamMate, classname, "bot");
    }

  return result;
};



// Squad_Team_LostTouchWithEnemy - determine of whole team lost touch
//                                 with enemy. If enemy just searched for
//                                 cover, then ambush.
//                                 returns true if member has new state
//                                 only for enemy.class == player/bot
//
float (entity squad, entity member) Squad_Team_HasLostTouchWithEnemy =
{ // only consider situation if team does not yet ambush
  if (Squad_Team_GetState(squad) == SQUAD_TEAMAMBUSH)
    return FALSE;

  // only consider situation for enemy is bot or player
  if ((member.enemy.classname != "player") &&
      (member.enemy.classname != "bot")
     )
    return FALSE;

  local float  result, contact, ambushers, hops, membersInFront;
  local entity teamMate, candidate;
  membersInFront = 0;
  result         = FALSE;
  contact        = FALSE;
  ambushers      = 0;
  teamMate       = find(world, classname, "bot");
  while (teamMate != world)
    { // consider if teamMate is near and still has contact
      // with enemy
      if (teamMate.team == member.team)
      if (teamMate != member)
        { // teamMate is near if within a small number of
          // waypoint hops
          hops = Squad_Behavior_WaypointNodeDistance(teamMate, member);
          if ((hops >= -2) &&
              (hops <= 2)  &&
              ((teamMate.enemy == member.enemy) ||
               (teamMate.enemy == world)
              )
             )
            { local entity alias;
              alias = self;
              self  = teamMate;
              contact = Squad_AI_DoesSeeSubjectThruTeam(member, member.enemy);
              self  = alias;
              // determine if teamMate could help in ambush
              if (vlen(member.origin - teamMate.origin) < 300)
                candidate = teamMate;
              else
                candidate = world;
            }

          // if still contact, do consider further actions
          if (contact)
              return FALSE;
          // if another ambusher, record that
          if (candidate != world)
            ambushers = ambushers + 1;
          candidate = world;

          if (hops > 0)
            membersInFront = membersInFront + 1;
        }
      teamMate = find(teamMate, classname, "bot");
    }

  // display result
  if ((!contact) &&
      ((ambushers > 0) || (membersInFront == 0))
     )
    { Squad_Team_StartAmbush(squad, member);
      result = TRUE;
    }

  return result;
};



// Squad_Team_GetWaypointDirection - depending on game settings, set the
//                                   correct waypoint visiting direction
//
//
float (entity theTeam, entity member) Squad_Team_GetWaypointDirection =
{ if ((Squad_Game_IsInfiltrateStartToExit()) || (coop))
    return SQUAD_WAYPOINT_DIRECTION_NEG;
  else
  if (Squad_Game_IsInfiltrateExitToStart())
    return SQUAD_WAYPOINT_DIRECTION_POS;

  local float r;
  r = random();
  if (r > 0.5)
    return SQUAD_WAYPOINT_DIRECTION_POS;
  else
    return SQUAD_WAYPOINT_DIRECTION_NEG;
};




// Squad_Team_SelectSpawnPoint - depending on game settings, find a
//                               spawn point for the bot
//
//
entity () Squad_Team_SelectSpawnPoint =
{ // if no game settings specified, ordinary spawn position
  local float r;
  r = random();
  if (Squad_Game_IsInfiltrateStartToExit())
    { // spawn far from start (areas 2...5)
      if ((coop) || (r > 0.83))
        return Waypoint_GetByName("exit");
      else
      if (r > 0.67)
        return Waypoint_GetByName("before hallway");
      else
      if (r > 0.51)
        return Waypoint_GetByName("upstairs room");
      else
      if (r > 0.35)
        return Waypoint_GetByName("underneath catwalk");
      else
      if (r > 0.16)
        return Waypoint_GetByName("before bridge");
      else
        return Waypoint_GetByName("near chemicals");
    }
  else
  if ((Squad_Game_IsInfiltrateExitToStart()) ||
      (coop)
     )
    { // spawn near start
      if ((coop) || (r > 0.83))
        return Waypoint_GetByName("start");
      else
      if (r > 0.67)
        return Waypoint_GetByName("before hallway");
      else
      if (r > 0.51)
        return Waypoint_GetByName("upstairs room");
      else
      if (r > 0.35)
        return Waypoint_GetByName("underneath catwalk");
      else
      if (r > 0.16)
        return Waypoint_GetByName("before bridge");
      else
        return Waypoint_GetByName("near chemicals");
    }
  // else
  return SelectSpawnPoint();
};

