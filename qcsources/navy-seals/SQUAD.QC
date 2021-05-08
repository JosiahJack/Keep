/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad.qc    "basic methods for squad member properties"  */
/*      author(s): William van der Sterren                                  */
/*      version  : 0.5                                                      */
/*                                                                          */
/*      date (last revision):  Sep 08, 97                                   */
/*      date (creation)     :  Oct 05, 97                                   */
/*                                                                          */
/*                                                                          */
/*      revision history                                                    */
/*      -- date ---- | -- revision ---------------------- | -- revisor --   */
/*      Oct 05, 1997 | added posture methods              | william         */
/*                                                                          */
/****************************************************************************/



//
// Squad initialization, creation and information
//

// prototypes - local functions



// implementation

// Squad_Precache - say hello and initialize
//
//
//
void ()  Squad_Precache =
{ // copyright marker
  SQUAD_CREATOR = "email: sterren@iaehv.nl";
  SQUAD_CREATOR = "portions (C) gooseman@smartt.com";
  SQUAD_CREATOR = "portions (C) legion@keg.zymurgy.org";
  SQUAD_CREATOR = "portions (C) Alan Kivlin (alan.kivlin@cybersurf.co.uk)";
  SQUAD_CREATOR = "(C) 1997 William van der Sterren";

  // precache models
  precache_model ("progs/pdude.mdl");
  precache_model ("progs/guard.mdl");
  precache_model ("progs/armor.mdl");

  // solve model bug
  pdudemodelindex = -1;
  guardmodelindex = -1;


  // precache sounds
  precache_sound2 ("weapons/pdudegun.wav");
  precache_sound2 ("weapons/die1.wav");
  precache_sound2 ("weapons/die2.wav");
  precache_sound2 ("weapons/die3.wav");
  precache_sound2 ("weapons/pain1.wav");
  precache_sound2 ("weapons/pain2.wav");
  precache_sound2 ("weapons/pain3.wav");

  // init global variables
  //dprint("impulse 120 [p]   put waypoint\n");
  //dprint("impulse 110 [q]   squad info\n");

  // initialize number (and max number) of active squads
  SQUAD_MEMBERSMAX = 4;
  activeSquads     = 0;
  alphaTeamSize    = 0;

  // initialize team composition
  squadTeamComposition = 0;

  // initialize state machine debugging variables
  SQUAD_MEMBER_STATECHANGEINFO = 0;
  SQUAD_TEAM_STATECHANGEINFO   = 0;

};


// Squad_StateToString - convert state value to string rep
//
//
//
string (float memberstate) Squad_StateToString =
{ if (memberstate == SQUAD_MEMBERWAIT)
    return "Wait";
  if (memberstate == SQUAD_MEMBERPATROL)
    return "Patrol";
  if (memberstate == SQUAD_MEMBERHUNTSTUFF)
    return "Hunt Stuff";
  if (memberstate == SQUAD_MEMBERHUNTENEMY)
    return "Hunt Enemy";
  if (memberstate == SQUAD_MEMBERATTACK)
    return "Attack";
  if (memberstate == SQUAD_MEMBERDEFEND)
    return "Defend";
  if (memberstate == SQUAD_MEMBERSTRAFE)
    return "Strafe";
  if (memberstate == SQUAD_MEMBERDIE)
    return "Die";
  if (memberstate == SQUAD_MEMBERASSEMBLE)
    return "Assemble";
  if (memberstate == SQUAD_MEMBERPOSITION)
    return "Position";
  if (memberstate == SQUAD_MEMBERGUARD)
    return "Guard";
  if (memberstate == SQUAD_MEMBERPAIN)
    return "Pain";
  if (memberstate == SQUAD_MEMBERRELOAD)
    return "Reload";
  if (memberstate == SQUAD_MEMBERRUNTOHELP)
    return "Run to Help";
  if (memberstate == SQUAD_MEMBERSPREAD)
    return "Spread Out";
  if (memberstate == SQUAD_MEMBERCHECK)
    return "Check";
  if (memberstate == SQUAD_MEMBERRUNFORCOVER)
    return "Run for Cover";
  if (memberstate == SQUAD_MEMBERDRAW)
    return "Draw";
  if (memberstate == SQUAD_MEMBERAMBUSH)
    return "Ambush";
  return "Undefined";
};



// Squad_Info - dump squad state to screen
//
//
void ()  Squad_Info =
{ local string output;
  local entity head;

  // title
  sprint(self, "==Squad alpha[");
  output = Squad_Team_StateToString(Squad_Team_GetState(teamAlpha));
  sprint(self, output);
  sprint(self, "]======\n");

  // put player info first

  sprint(self, self.classname);
  sprint(self, " ");
  sprint(self, self.netname);
  sprint(self, " [unknown], f = ");
  output = ftos(self.frags);
  sprint(self, output);
  sprint(self, ", t = ");
  output = ftos(self.team);
  sprint(self, output);
  sprint(self, "\n");

  head = findradius(self.origin, 150000);
  while(head != world)
    { if (head.classname == "bot")
      {
        sprint(self, head.netname);
        sprint(self, " [");
        output = Squad_StateToString(head.squadmemberstate);
        sprint(self, output);
        sprint(self, "], trg = ");
        if (head.movetarget != world)
          { sprint(self, head.movetarget.classname);
            sprint(self, "::");
            sprint(self, head.movetarget.netname);
          }
        else
          sprint(self, "world");

        sprint(self, ", h = ");
        output = ftos(head.health);
        sprint(self, output);
        sprint(self, ", t = ");
        output = ftos(head.team);
        sprint(self, output);
        //sprint(self, ", pos = ");
        //output = Squad_PostureToString(Squad_GetPosture(head));
        //sprint(self, output);
        sprint(self, "\n");
      }
      head = head.chain;
    }

  sprint (self, "\n");
};



// Squad_SetState         - defines new state for squad member
//
//
//
void (entity member, float memberstate) Squad_SetState =
{ // first prohibit invalid state changes
  if (member.squadmemberstate == memberstate)
    return;
  if ((member.squadmemberstate == SQUAD_MEMBERDIE) &&
      (memberstate != SQUAD_MEMBERPATROL)
     )
    return;

  // record current old state
  local float previousState;
  previousState = member.squadmemberstate;

  // change some state changes if team is regrouping
  if ((Squad_Team_IsRegrouping(teamAlpha)) &&
      ((memberstate == SQUAD_MEMBERPATROL) ||
       (memberstate == SQUAD_MEMBERHUNTSTUFF))
     )
    { if (Squad_AI_TryAssembly(member, alphaAssemblyLocation))
        return;
    }

  // state exit processing
  if (member.squadmemberstate == SQUAD_MEMBERATTACK)
    { // correct th_run to normal AI processing
      member.th_run = Squad_Anim_Run;
    }
  else
  if ((member.squadmemberstate == SQUAD_MEMBERASSEMBLE)
      &&
      ((memberstate != SQUAD_MEMBERPOSITION) &&
       (memberstate != SQUAD_MEMBERGUARD)
      )
     )
    { // leaving team assembly
      Squad_Team_LeaveAssembly(teamAlpha, member);
    }
  else
  if (((member.squadmemberstate == SQUAD_MEMBERPOSITION) ||
       (member.squadmemberstate == SQUAD_MEMBERGUARD)
      )
      &&
      ((memberstate != SQUAD_MEMBERGUARD)
      )
     )
    { // leaving team formation
      Squad_Team_LeaveFormation(teamAlpha, member);
      // maybe also leave assembly
      if (memberstate != SQUAD_MEMBERASSEMBLE)
        Squad_Team_LeaveAssembly(teamAlpha, member);
    }

  // change state - prohibit invalid transitions
  //

  member.squadmemberstate = memberstate;

  // debug info
  if (SQUAD_MEMBER_STATECHANGEINFO == 1)
    { local string sState;
      sState = Squad_StateToString(memberstate);
      dprint("squad member ");
      dprint(member.netname);
      dprint(" enters state ");
      dprint(sState);
      dprint("\n");
    }

  // state entry processing
  if (memberstate == SQUAD_MEMBERWAIT)
    { // wait - will switch to squadnextmemberstate in .search-time time
      member.think     = Squad_Anim_Wait;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERSTRAFE)
    { Squad_AI_StrafeStart(member);
      member.think     = Squad_Anim_Strafe;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERPAIN)
    { member.think     = Squad_Anim_Pain;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERPATROL)
    { Squad_AI_DestroyMarker(member.squadmarker);
      // ... and set new marker
      member.squadmarker = world;

      // clear any reference to enemies
      member.enemy      = world;

      // set think and search time
      member.nextthink = time + 0.1;
      member.think = member.th_walk;
      // init travel time to current time
      member.search_time = time;

      // determine waypoint visit order
      Squad_Behavior_DetermineWaypointDirection(member);

      // select waypoint
      Squad_Behavior_ReselectWaypoint(member);
      if (member.squadPreviousWaypoint == world)
        member.squadPreviousWaypoint = member.goalentity;

      // init sides info
      Squad_AI_InitSidesInfo(member);
    }
  else
  if (memberstate == SQUAD_MEMBERDEFEND)
    { // dive
      member.think = Squad_Anim_Roll;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERRUNTOHELP)
    { // (re)select waypoint
      Squad_Behavior_ReselectWaypoint(member);
      if (member.squadPreviousWaypoint == world)
        member.squadPreviousWaypoint = member.goalentity;
      // set think and search time
      member.nextthink = time + 0.1;
      member.think = member.th_run;
      // init travel time to current time
      member.search_time = time;
    }
  else
  if (memberstate == SQUAD_MEMBERHUNTSTUFF)
    { if (member.squadmarker != world)
        { // clean up old marker...
          Squad_AI_DestroyMarker(member.squadmarker);
          // ... and set new marker
          member.squadmarker = world;
        }
      // set member.stuff as target
      member.goalentity = member.stuff;
      member.movetarget = member.stuff;
      // init searchtime to current time
      member.search_time = time;
      member.think = Squad_Anim_Stuff;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERHUNTENEMY)
    { // go to spot where enemy was seen latest
      // init searchtime to current time
      member.goalentity = member.squadmarker;
      member.movetarget = member.squadmarker;
      member.search_time = time;
      member.think = member.th_run;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERATTACK)
    { // assume member.enemy has been set
      member.goalentity = member.enemy;
      member.movetarget = member.enemy;
      // initialize marker for enemy
      if (member.squadmarker != world)
        { // clean up old marker...
          Squad_AI_DestroyMarker(member.squadmarker);
        }
      // ... and set new marker
      member.squadmarker
        = Squad_AI_CreateMarker(member.enemy.origin, member.enemy);
      member.th_run = Squad_Anim_Attack;
      member.think  = member.th_run;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERDRAW)
    { // assume member.enemy has been set
      member.goalentity = member.enemy;
      member.movetarget = member.enemy;
      // initialize marker for enemy
      if (member.squadmarker != world)
        { // clean up old marker...
          Squad_AI_DestroyMarker(member.squadmarker);
        }
      // ... and set new marker
      member.squadmarker
        = Squad_AI_CreateMarker(member.enemy.origin, member.enemy);
      member.think  = Squad_Anim_Draw;
      member.nextthink = time + 0.02;
    }
  else
  if (memberstate == SQUAD_MEMBERAMBUSH)
    { // assume member.squadmarker has been set
      member.goalentity = member.squadmarker;
      member.movetarget = member.squadmarker;
      Squad_AI_HeadForMarker(member);
      member.think  = Squad_Anim_Draw;
      member.nextthink = time + 0.02;
    }
  else
  if (memberstate == SQUAD_MEMBERDIE)
    { if (member.squadmarker != world)
        { // clean up old marker...
          Squad_AI_DestroyMarker(member.squadmarker);
          // ... and set new marker
          member.squadmarker = world;
        }
    }
  else
  if (memberstate == SQUAD_MEMBERASSEMBLE)
    { // run to marker, which already has been set,
      // followed by a transition to state MEMBERPOSITION
      member.goalentity = member.squadmarker;
      member.movetarget = member.squadmarker;
      Squad_AI_HeadForMarker(member);
      member.think      = member.th_run;
      member.nextthink  = time + 0.1;
      // signal participation in regroup
      Squad_Team_JoinAssembly(teamAlpha, member);
    }
  else
  if (memberstate == SQUAD_MEMBERPOSITION)
    { // walk to marker, which already has been set,
      // followed by a transition to state MEMBERSPOT
      member.goalentity = member.squadmarker;
      member.movetarget = member.squadmarker;
      Squad_AI_HeadForMarker(member);
      member.think      = member.th_walk;
      member.nextthink  = time + 0.1;
      // signal participation in regroup
      local entity assemblyPoint;
      assemblyPoint = Squad_AI_GetMarkerEntity(member.squadmarker);
      Squad_Team_JoinFormation(teamAlpha, member, assemblyPoint);
    }
  else
  if (memberstate == SQUAD_MEMBERGUARD)
    { // stand and observe in required direction,
      // using a field of 360/teamsize degrees
      member.think     = Squad_Anim_Wait;
      member.nextthink = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERRELOAD)
    { // reload weapon, continue with previousState afterwards
      member.squadmembernextstate = previousState;
      member.think                = Squad_Anim_Reload;
      member.nextthink            = time + 0.1;
    }
  else
  if (memberstate == SQUAD_MEMBERSPREAD)
    { // run or roll to marker position, ignore enemies and pain;
      // do so until search_time (set externally)
      member.squadmembernextstate = previousState;
      member.nextthink            = time + 0.1;
      //member.search_time          = time;
      // only run to marker if visible, otherwise
      // follow waypoints
      if (Waypoint_IsVisible(member.squadmarker, member))
        { member.goalentity           = member.squadmarker;
          member.movetarget           = member.squadmarker;
          Squad_AI_HeadForMarker(member);
        }
      else
        Squad_Behavior_ReselectWaypoint(member);
      member.think                = Squad_Anim_Run;
    }
  else
  if (memberstate == SQUAD_MEMBERCHECK)
    { // check two for enemies in two directions
      member.nextthink            = time + 0.1;
      member.search_time          = time;
      member.think                = Squad_Anim_Check;
      member.squadStrafeDirection = 1; // perform 2 checks
      // set current direction to be correct
      member.ideal_yaw            = member.angles_y;
      member.yaw_speed            = 5.0;
      // have member turn + or -
      if (random() > 0.5)
        member.squadSpotAngles = '0 -1 0';
      else
        member.squadSpotAngles = '0 1 0';
    }
  else
  if (memberstate == SQUAD_MEMBERRUNFORCOVER)
    { // grenade is specified by enemy
      // now select a waypoint to run to
      local vector v_grenade;
      v_grenade = member.enemy.origin - member.origin;
      local entity point1, point2, point3;
      local float  dot1, dot2, dot3;
      Squad_Behavior_ReselectWaypoint(member);
      point1 = member.movetarget;
      point2 = Waypoint_Next(point1);
      point3 = Waypoint_Previous(point1);
      makevectors(point1.origin - member.origin);
      dot1 = v_forward * v_grenade;
      makevectors(point2.origin - member.origin);
      dot2 = v_forward * v_grenade;
      makevectors(point3.origin - member.origin);
      dot3 = v_forward * v_grenade;
      if (dot2 < dot1)
        { if (dot3 < dot2)
            member.goalentity = point3;
          else
            member.goalentity = point2;
        }
      else
        { if (dot3 < dot1)
            member.goalentity = point3;
          else
            member.goalentity = point1;
        }
      member.movetarget = member.goalentity;
      member.squadmarker
        = Squad_AI_CreateMarker(member.movetarget.origin, world);
      Squad_AI_HeadForMarker(member);
      member.search_time = member.enemy.search_time; // explosion time
      member.nextthink   = time + 0.1;
      member.think       = Squad_Anim_Run;
    }
};



// Squad_GetState         - returns current state of squad member
//
//
//
float (entity member) Squad_GetState =
{ return member.squadmemberstate;
};



// Squad_MemberDeactivate - Bot readies itself for deactivation itself
//
//
void () Squad_MemberDeactivate =
{ // hide waypoint debug effects
  if (WAYPOINT_DEBUG)
  if (self.movetarget.classname == "waypoint")
     { Waypoint_Hide(self.movetarget); }

  // notify team
  Squad_Team_Leave(self);

  // lay down on floor
  droptofloor();

  self.solid    = SOLID_NOT;
  self.deadflag = DEAD_DEAD;
  if ((deathmatch)                         &&
      (!Squad_Game_IsInfiltrate())
     )
    { // create corpse, then hide SquadMember until reincarnation
      local entity corpse;

      // spawn corpse, if not already gibbed
      if ((self.model == "progs/pdude.mdl") ||
          (self.model == "progs/guard.mdl")
         )
        { corpse = spawn();
          corpse.origin = self.origin;
          corpse.angles = self.angles;
          corpse.solid  = SOLID_NOT;
          corpse.movetype = MOVETYPE_NONE;
          corpse.deadflag = DEAD_DEAD;
          setmodel (corpse, self.model);
          setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
          corpse.skin  = self.skin;
          corpse.frame = self.frame;
          corpse.think    = SUB_Remove;
          corpse.nextthink = time + 100 + random() * 20;
        }
      // else
      //   probably gibbed - looks good enough


      //setmodel (self, "");
      self.nextthink = time + 5.0;
      // Wait up to 5 sec before respawn
      self.think = Squad_RespawnMember;
    }
  else
    { // no deathmatch, just lie there
      self.think = SUB_Null;
      // botDisconnect(self);
    }
};



// Squad_RespawnMember - reincarnate member; similar to
//                       create, but less to do
//
//
void ()  Squad_RespawnMember =
{ Squad_MemberInit(self);
  spawn_tfog (self.origin);
  spawn_tdeath(self.origin, self);

  bprint(self.netname);
  bprint( " is back\n");

};



// Squad_MemberInit - subroutine for member initialization
//
//
//
void (entity member) Squad_MemberInit =
{ // pre: role attribute has been set

  // pre:  squadmarker does not point to any real marker

  local entity spot;

  member.solid    = SOLID_SLIDEBOX;
  member.movetype = MOVETYPE_STEP;

  Squad_MemberInitRole(member);

  member.squadPreviousWaypoint = world;
  member.squadmemberstate      = SQUAD_MEMBERUNDEFINED;
  member.squadleader           = member;
  member.squadmarker           = world;
  member.forbiddenarea         = SQUAD_FORBIDDENAREA;

  // init waypoint visit order
  member.squadWaypointDirection
    = Squad_Team_GetWaypointDirection(teamAlpha, member);

  member.classname  = "bot";
  member.health     = 100;
  member.max_health = 100;
  member.show_hostile = 0;
  member.effects = 0;

  member.flags      = FL_CLIENT;
  member.takedamage = DAMAGE_AIM;
  member.pausetime  = 0;
  member.deadflag   = DEAD_NO;
  member.ideal_yaw  = member.angles * '0 1 0';
  member.yaw_speed  = 60;
  member.view_ofs     = '0 0 25';
  member.th_stand     = Squad_Anim_Wait;
  member.th_walk      = Squad_Anim_Walk;
  member.th_run       = Squad_Anim_Run;
  member.th_pain      = Squad_AI_ReceiveDamage;
  member.th_die       = Squad_Anim_Die;
  member.th_missile   = Squad_AI_StartAttack;
  member.attack_state == AS_MISSILE;
  setsize (member, VEC_HULL_MIN, VEC_HULL_MAX);
  Squad_SetPosture(member, SQUAD_POSTURE_STAND);

  // determine place to be dropped and way to go
  spot = Squad_Team_SelectSpawnPoint();
  member.origin = spot.origin + '0 0 1';
  member.angles = spot.angles;

  // notify team
  Squad_Team_Join(member);

  member.squadmembernextstate = SQUAD_MEMBERPATROL;
  member.search_time          = time + 1;
  Squad_SetState(member, SQUAD_MEMBERWAIT);
  Squad_MemberAnnounce(member);
};



// Squad_MemberInitRole - subroutine for member initialization,
//                        role specific parts only
//
//
void (entity member) Squad_MemberInitRole =
{ // common
  member.ammo_nails   = 0;
  member.ammo_rockets = 4;  // 4 grenades
  member.ammo_cells   = 0;

  if (Squad_GetRole(member) == SQUAD_ROLE_HANDGUNSOLDIER)
    { member.weapon = IT_SHOTGUN;
      member.items  = IT_AXE | IT_SHOTGUN;
      member.ammo_shells  = 48; // 4 clips ?
      member.mk23clip     = 12;
      // set model
      setmodel (member, "progs/pdude.mdl");
      member.frame = 0;
      if (pdudemodelindex == -1)
        pdudemodelindex = member.modelindex;
      else
        member.modelindex = pdudemodelindex;
    }
  else
  if (Squad_GetRole(member) == SQUAD_ROLE_MACHINEGUNSOLDIER)
    { member.weapon = IT_NAILGUN;
      member.items  = IT_AXE | IT_NAILGUN;
      member.ammo_shells  = 60; // 2 clips ?
      member.mp5clip      = 30;
      // set model
      setmodel (member, "progs/guard.mdl");
      member.frame = 0;
      if (guardmodelindex == -1)
        guardmodelindex = member.modelindex;
      else
        member.modelindex = guardmodelindex;
    }
  else
    bprint("Squad_MemberInit - error: no role defined for bot\n");

  // common
  member.skin  = 0;
  member.frame = 0;
  // just to be sure - some testers had problems
  setmodel (member, member.model);
};




// Squad_MemberAnnounce - announces squad member (audio)
//
//
//
void (entity member) Squad_MemberAnnounce =
{ if (member.netname == "Alpha One")
    { //sound(member, CHAN_VOICE, "seal/alpha1.wav", 1, ATTN_NORM);
      return;
    }
  else if (member.netname == "Alpha Two")
    { //sound(member, CHAN_VOICE, "seal/alpha2.wav", 1, ATTN_NORM);
      return;
    }
  else if (member.netname == "Alpha Three")
    { //sound(member, CHAN_VOICE, "seal/alpha3.wav", 1, ATTN_NORM);
      return;
    }
  else if (member.netname == "Alpha Four")
    { //sound(member, CHAN_VOICE, "seal/alpha4.wav", 1, ATTN_NORM);
      return;
    }
};



// Squad_MemberFeetPosition - returns position of squad member's feet
//
//
//
vector (entity member) Squad_MemberFeetPosition =
{ local vector feet_pos;
  feet_pos   = member.origin;
  feet_pos_z = member.absmin_z + 1;
  return feet_pos;
};




// Squad_AdjustHeight - adjust height (above origin) to model
//                      ducking squad member
//
//
void (entity member, float factor)  Squad_AdjustHeight =
{ local vector v_new_max;
  // obtain original size
  setsize(member, VEC_HULL_MIN, VEC_HULL_MAX);
  v_new_max = member.maxs;
  // adjust size
  v_new_max_z = factor * v_new_max_z;
  setsize(member, VEC_HULL_MIN, v_new_max);
};



// Squad_PostureToString - returns string value for posture
//
//
//
string (float posture)  Squad_PostureToString =
{ if (posture == SQUAD_POSTURE_STAND)
    return "standing";
  if (posture == SQUAD_POSTURE_SIT)
    return "sitting/kneeling";
  if (posture == SQUAD_POSTURE_LAY)
    return "laying";
  if (posture == SQUAD_POSTURE_ROLL)
    return "rolling";
  return "undefined";
};



// Squad_SetPosture  - set posture attribute, to record the members
//                     position (standing, sitting, lieing, rolling)
//
//
void (entity member, float posture)  Squad_SetPosture =
{ member.height = posture;
  if ((posture == SQUAD_POSTURE_LAY) ||
      (posture == SQUAD_POSTURE_ROLL)
     )
    { Squad_AdjustHeight(member, 0.0);
      return;
    }
  else
  if (posture == SQUAD_POSTURE_SIT)
    { Squad_AdjustHeight(member, 0.5);
      return;
    }
  else //  (posture == SQUAD_POSTURE_STAND)
    Squad_AdjustHeight(member, 1.0);

  return;
};




// Squad_GetPosture  - returns posture attribute, to tell the members
//                     position (standing, sitting, lieing, rolling)
//
//
float (entity member)  Squad_GetPosture =
{ return member.height;
};



// Squad_GetRole  - returns type of character/model represented
//                  by member.
//
//
float (entity member)  Squad_GetRole =
{ return member.weaponframe;
};



// Squad_SetRole  - sets role for member
//
//
float (entity member, float role) Squad_SetRole =
{ member.weaponframe = role;
};



// Squad_MemberCanRoll  - returns if member is able to roll forward
//
//
//
float (entity member)  Squad_MemberCanRoll =
{ return (member.weaponframe == SQUAD_ROLE_HANDGUNSOLDIER);
};
