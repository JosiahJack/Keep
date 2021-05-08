/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : waypoint.qc  "waypoint system methods and waypoints"     */
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
// Waypoint initialization, creation and information
//

// prototypes - local functions
void   (string name,
        float  number,
        string prev,
        string next,
        vector origin,
        float flags)     Waypoint_Create;
void ()                  button_touch;     // buttons.qc




// implementation - info
//
//   waypoints map on entities reusing standard entities fields
//   - netname     -> waypoint name
//   - noise1      -> prev waypoint (string name)
//   - noise2      -> next waypoint (string name)
//   - movetarget  -> prev waypoint
//   - goalentity  -> next waypoint
//   - enemy       -> button to be triggered
//   - weaponframe -> direction ("both", "positive", "negative")
//   - ammo_shells -> waypoint number
//   - ammo_nails  -> waypoint type (standard, assembly_square, assembly_line)
//   - ammo_cells  -> assembly point offset
//   - search_time -> time last visited (assembled)



// Waypoint                  - spawns and sets up waypoint -
//                             waypoint connections still have
//                             to be made
//
void () waypoint =
{ // in spawn, netname, noise1, noise2, enemy, and ammo_shells get set
  // automatically.
  // however, ammo_nails/weaponframe has yet to be determined
  self.weaponframe = (self.spawnflags & 3);
  self.ammo_nails  = (self.spawnflags & 252);

  // set last visit time
  self.search_time = time - 60; // allow any fast assembly

  // set touch function
  self.solid = SOLID_TRIGGER;
  self.touch = Waypoint_Touch;
};




// Waypoint_Create           - manually creates nd sets up waypoint -
//                             waypoint connections still have
//                             to be made
//
void   (string name,
        float  number,
        string prev,
        string next,
        vector pos,
        float  wp_flags) Waypoint_Create =
{ // (1) create and setup waypoint
  local entity point;
  point = spawn();

  // (2) set the values constant for every waypoint
  // give all waypoints a specific class name
  point.classname  = "waypoint";

  // (3) process name, origin, number, offset, visit time and flag
  point.netname     = name;
  setorigin(point, pos);
  point.ammo_shells = number;
  point.ammo_cells  = 0;
  point.noise1      = prev;
  point.noise2      = next;
  // set last visit time
  point.search_time = time - 60; // allow any fast assembly


  if ((wp_flags & FL_WAYPOINT_DIR_POS) &&
      (wp_flags & FL_WAYPOINT_DIR_NEG)
     )
    point.weaponframe = 0;
  else
  if (wp_flags & FL_WAYPOINT_DIR_POS)
    point.weaponframe = 1;
  else
  if (wp_flags & FL_WAYPOINT_DIR_NEG)
    point.weaponframe = 2;

  point.ammo_nails = 0;
  point.ammo_nails = point.ammo_nails |
                     (wp_flags &
                              (FL_WAYPOINT_SCRIPT_POS      |
                               FL_WAYPOINT_SCRIPT_NEG      |
                               FL_WAYPOINT_ASSEMBLY_SQUARE |
                               FL_WAYPOINT_ASSEMBLY_LINE   |
                               FL_WAYPOINT_SPREAD
                              )
                     );
  // (3) init those attributes that already can be initialized
  // look for func_button's that contain the waypoint
  // because bots do not seem to reach and trigger every button
  local entity button;
  local entity thing;

  button = world;
  thing  = findradius(point.origin, 32);     // does actually find one?
  while (thing)
    { if (thing.classname == "func_button")
        button = thing;
      thing = thing.chain;
    }

  // now store button in waypoints' .enemy (world, if no button)
  point.enemy = button;

  // debugging info
  if ((WAYPOINT_DEBUG) && (button != world))
    { dprint("waypoint connects to func_button @ ");
      local vector button_center;
      button_center = button.mins + 0.5 * button.size;
      dprint(vtos(button_center));
      dprint("\n");
    }

  // (4) set touch function
  point.solid = SOLID_TRIGGER;
  point.touch = Waypoint_Touch;
  point.size  = '64 64 32';
};



// Waypoint_AreAvailable - test if waypoints are available;
//                         if not available, tries to create.
//                         return final result
//
float () Waypoint_AreAvailable =
{ // try to create them, if necessary
  Waypoint_Init();

  // test if waypoints available
  local entity point;
  point = find(world, classname, "waypoint");
  if (point != world)
    return TRUE;
  else
    return FALSE;
};



// Waypoint_Precache         - inits global waypoint entities
//                             at start of level
//
//
void () Waypoint_Precache =
{ precache_model ("progs/s_bubble.spr");
  precache_model ("progs/lavaball.mdl");
  waypointsVisible = FALSE;
};



// Waypoint_FillMap          - add waypoints to map, if not already
//                             defined (currently only e1m1 supported)
//                             (split in two sections to prevent
//                              "run away error"
//                             )
//
void () Waypoint_FillMap =
{ // first test if any waypoints already available
  local entity point;
  point = find(world, classname, "waypoint");
  if (point != world)
    { local float dummy;
      // not much to do
    }
  else
  if (mapname == "e1m1")
    { // area start building
      Waypoint_Create("start",             100,
                      "1st corner", "1st corner",
                      '476  -266    72',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("1st corner",        102,
                      "start", "thru door",
                      '485   563    24',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("hi start hall",     104,
                      "near armor", "1st corner",
                      '654   727   104',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("near armor",        106,
                      "hi start hall", "hi start hall",
                      '682   503   104',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("thru door",         108,
                      "1st corner", "elevator but. up",
                      '131   576    24',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("elevator but. up",  110,
                      "thru door", "elevator down",
                      '-50   576    40',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("elevator down",     112,
                      "thru door",
                      "outside elevator",
                      '4 561 -208',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("elevator but. dn",  114, "elevator down", "before bridge",
                      '93  728  -176',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      // outside start building, bridge and water
      Waypoint_Create("outside elevator",  200,
                      "thru door", "before bridge",
                      '8   923  -200',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("before bridge",     202,
                      "elevator but. dn", "after bridge",
                      '149  1010  -200',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("water bridge",      204,
                      "water deep1", "water deep1",
                      '125  1210  -300',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("water deep1",       206,
                      "water bridge", "water deep2",
                      '462 1202 -312',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("water deep2",       208,
                      "water deep1", "podium water",
                      '596  1005  -312',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("podium water",      210,
                      "water deep1", "water elevator",
                      '914   1019  -248',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("water elevator",    212,
                      "podium water", "near armor",
                      '765   520  -162',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("after bridge",      214,
                      "before bridge", "door building",
                      '122  1500  -200',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      // main building
      Waypoint_Create("door building",     300,
                      "after bridge", "after door",
                      '126  1668  -200',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("after door",        301,
                      "door building", "aside pillar",
                      '118  1924  -168',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("aside pillar",      302,
                      "after door", "near pillar",
                      '418  2157  -168',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("near pillar",       304,
                      "door building", "near chemicals",
                      '341  2004  -168',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("near chemicals",    306,
                      "near pillar", "left of door",
                      '54   2006  -184',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("left of door",      308,
                      "near chemicals", "underneath catwalk",
                      '-320  2000  -136',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("underneath catwalk",310,
                      "left of door", "corner near basin",
                      '-335 2259 -136',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("small elevator",    312,
                      "small elevator top", "corner near basin",
                      '-565  2655   -84',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("small elevator top",313,
                      "upstairs corner", "corner near basin",
                      '-565  2655   56',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("upstairs corner",   314,
                      "upstairs room", "corner near basin",
                      '-564  2335   56',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("upstairs room",     316,
                      "underneath catwalk", "upstairs corner",
                      '75    2362  40',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("corner near basin", 318,
                      "small elevator", "basin button",
                      '-308  2788   -72',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("basin button",      320,
                      "corner near basin", "before hallway",
                      '-41  2676   -32',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("before basin stairs", 326,
                      "basin button", "basin button",
                      '-77 2969 -36',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("basin stairs",      324,
                     "before basin stairs", "before basin stairs",
                     '122 2964 -80',
                     FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("in basin",          322,
                      "basin stairs", "basin stairs",
                      '253 2891 -152',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("before hallway",    328,
                      "basin button", "in hallway",
                      '377  2808   -56',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      // hallway and boardwalk
      Waypoint_Create("in hallway",        400,
                      "before hallway", "hallway corner",
                      '557  2784   -56',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("hallway corner",    402,
                      "before hallway", "stairs but. 1",
                      '840  2780   -56',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("before stairs",     404,
                      "hallway corner", "stairs but. 1",
                      '841  2611   -88',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("slime platform",    406,
                      "hallway door", "hallway door",
                      '1052 2125 -424',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("slime 1",           408,
                      "slime platform", "slime platform",
                      '1081 2575 -504',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("slime 2",           410,
                      "slime 1", "slime 1",
                      '719 2546 -514',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("slime 3",           412,
                      "slime platform", "slime platform",
                      '1140 1946 -504',
                      FL_WAYPOINT_DIR_POS);
      Waypoint_Create("stairs but. 1",     414,
                      "hallway corner", "stairs but. 2",
                      '810  2010  -128',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("stairs but. 2",     416,
                      "stairs but. 1", "stairs but. 3",
                      '1276  2058  -192',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("stairs but. 3",     418,
                      "stairs but. 2", "stairs no but.",
                      '1232  2490  -280',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("stairs no but.",    420,
                      "stairs but. 3", "hallway door",
                      '790  2436  -341',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      // exit building
      Waypoint_Create("hallway door",      500,
                      "stairs no but.", "snd last corner",
                      '833  2054  -408',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("snd last corner",   502,
                      "hallway door", "last corner",
                      '813  1754  -408',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("last corner",       504,
                      "snd last corner", "exit",
                      '1300  1790  -400',
                      FL_WAYPOINT_DIR_POS | FL_WAYPOINT_DIR_NEG);
      Waypoint_Create("exit",              506,
                      "last corner", "last corner",
                      '1318   983  -256',
                      FL_WAYPOINT_DIR_NEG);

      // define assemblypoints and shortcuts
      Waypoint_AddScript("1st corner",
                         FL_WAYPOINT_ASSEMBLY_SQUARE | FL_WAYPOINT_SCRIPT_POS,
                         0);
      Waypoint_AddScript("elevator down",
                         FL_WAYPOINT_SPREAD | FL_WAYPOINT_SCRIPT_POS,
                         150);
      Waypoint_AddScript("after bridge",
                         FL_WAYPOINT_ASSEMBLY_SQUARE | FL_WAYPOINT_SCRIPT_POS,
                         0);
      Waypoint_AddScript("door building",
                         FL_WAYPOINT_SPREAD | FL_WAYPOINT_SCRIPT_POS,
                         170);
      Waypoint_AddScript("after door",
                         FL_WAYPOINT_SPREAD | FL_WAYPOINT_SCRIPT_NEG,
                         170);
      Waypoint_AddScript("before hallway",
                         FL_WAYPOINT_SPREAD | FL_WAYPOINT_SCRIPT_NEG,
                         0);
      Waypoint_AddScript("in hallway",
                         FL_WAYPOINT_ASSEMBLY_LINE | FL_WAYPOINT_SCRIPT_POS,
                         0);
      Waypoint_AddScript("before stairs",
                         FL_WAYPOINT_ASSEMBLY_LINE | FL_WAYPOINT_SCRIPT_POS,
                         0);
    }
};



// Waypoint_Init             - complete relations between waypoints
//                             defined for map
//
//
void () Waypoint_Init =
{ // iterate over all waypoints and try to resolve prev and next
  local entity point, otherwaypoint;
  local float  match;

  // first, fill map with waypoints if not defined in map itself
  Waypoint_FillMap();

  // two iterations - outer to visit every waypoint
  //                  inner to find matching next and prevs
  point = find(world, classname, "waypoint");
  while (point != world)
    { // use otherwaypoint for finding prev and next
      match = 0;
      otherwaypoint = find(world, netname, point.noise1);
      if (otherwaypoint != world)
        { point.movetarget = otherwaypoint;
          match = match + 1;
        }
      otherwaypoint = find(world, netname, point.noise2);
      if (otherwaypoint != world)
        { point.goalentity = otherwaypoint;
          match = match + 1;
        }

      // generate output in case of unmatched prev/next
      if (match < 2)
        { dprint("Waypoint_Init -");
          dprint(point.netname);
          dprint(" couldn't match ");
          dprint(point.noise1);
          dprint(" and/or ");
          dprint(point.noise2);
          dprint("\n");
        }

      // remove strings from noise1 and noise2 fields
      // point.noise1 = "";
      // point.noise2 = "";

      // debug output

      // set waypoint to next waypoint to visit
      point = find(point, classname, "waypoint");
    }
};



// Waypoint_Nearest    - returns nearest waypoint
//
//
//
entity (entity member) Waypoint_Nearest =
{ local float  min_distance;
  local float  tmp_distance;
  local entity nearest_waypoint;
  local entity next_point;

  // init
  next_point       = find(world, classname, "waypoint");
  min_distance     = vlen (member.origin - next_point.origin);
  nearest_waypoint = next_point;

  // test
  next_point = find(next_point, classname, "waypoint");
  while (next_point != world)
    { tmp_distance = vlen (member.origin - next_point.origin);
      if (tmp_distance < min_distance)
        {   min_distance = tmp_distance;
            nearest_waypoint = next_point;
        }
      next_point = find(next_point, classname, "waypoint");
    }

  return nearest_waypoint;
};




// Waypoint_NearestInContents - returns nearest waypoint
//                              in the same contents (water, slime,
//                              lava)
//
entity (entity member) Waypoint_NearestInContents =
{ local vector member_feet;
  local float  member_feet_contents;
  // calculate feet position and contents member is standing in
  member_feet          = Squad_MemberFeetPosition(member);
  member_feet_contents = pointcontents(member_feet);

  local float  min_distance;
  local float  tmp_distance;
  local entity nearest_waypoint;
  local entity next_point;

  // init iteration
  min_distance     = 30000;
  nearest_waypoint = world;

  // iterate
  next_point = find(world, classname, "waypoint");
  while (next_point != world)
    { //bprint("consider: ");
      //bprint(next_point.netname);

      // only consider points in same contents
      if (pointcontents(next_point.origin) == member_feet_contents)
        { tmp_distance = vlen (member.origin - next_point.origin);
          //bprint(" at distance ");
          if (tmp_distance < min_distance)
            {   min_distance = tmp_distance;
                nearest_waypoint = next_point;
            }
          //bprint(ftos(tmp_distance));
        }
      //else
      //  bprint(" in other contents");
      //bprint("\n");
      next_point = find(next_point, classname, "waypoint");
    }
  return nearest_waypoint;
};




// Waypoint_Next        - returns next waypoint
//
//
//
entity (entity point) Waypoint_Next =
{ return point.goalentity;
};



// Waypoint_Previous        - returns previous waypoint
//
//
//
entity (entity point) Waypoint_Previous =
{ return point.movetarget;
};



// Waypoint_Get - return the waypoint corresponding with
//                the given waypointnumber
//
//
//
entity (float waypointnumber) Waypoint_Get =
{ local entity point;
  local float  match;

  match = FALSE;

  point = find(world, classname, "waypoint");
  while ((point != world) && (!match))
    { match = (point.ammo_shells == waypointnumber);
      if (!match)
        point = find(point, classname, "waypoint");
    }

  // either waypoint == world or match
  return point;
};



// Waypoint_GetByName - return the waypoint corresponding with
//                      the given name
//
//
//
entity (string waypointname) Waypoint_GetByName =
{ local entity point;
  local float  match;

  match = FALSE;

  point = find(world, classname, "waypoint");
  while ((point != world) && (!match))
    { match = (point.netname == waypointname);
      if (!match)
        point = find(point, classname, "waypoint");
    }

  // either waypoint == world or match
  return point;
};



// Waypoint_GetNumber - returns waypoint's sequence number
//
//
//
float (entity point) Waypoint_GetNumber =
{ return point.ammo_shells;
};



// Waypoint_GetVisitingDirection - returns direction this
//                                 waypoint shall be traversed
//
//
float (entity point) Waypoint_GetVisitingDirection =
{ return point.weaponframe;
};




// Waypoint_AddScript - adds instruction (assembly locations,
//                      spread out location, etc.) to waypoint
//
//
void (string waypointname, float flag, float offset) Waypoint_AddScript =
{ local entity point;
  point = Waypoint_GetByName(waypointname);
  if (point == world)
    return;
  point.ammo_nails = point.ammo_nails | flag;
  point.ammo_cells = offset;
};




// Waypoint_IsAssemblyLocation - returns whether the waypoint
//                               is to be used for team assembly
//
//
float (entity point, float dir) Waypoint_IsAssemblyLocation =
{ return ((((point.ammo_nails & FL_WAYPOINT_SCRIPT_POS)
            &&
            (dir == SQUAD_WAYPOINT_DIRECTION_POS)
           )
           ||
           ((point.ammo_nails & FL_WAYPOINT_SCRIPT_NEG)
            &&
            (dir == SQUAD_WAYPOINT_DIRECTION_NEG)
           )
          )
          &&
          ((point.ammo_nails & FL_WAYPOINT_ASSEMBLY_SQUARE)
           ||
           (point.ammo_nails & FL_WAYPOINT_ASSEMBLY_LINE)
          )
         );
};




// Waypoint_IsSpreadLocation - returns whether the team
//                             shall spread when hitting this
//                             waypoint
//
float (entity point, float dir) Waypoint_IsSpreadLocation =
{ return ((((point.ammo_nails & FL_WAYPOINT_SCRIPT_POS)
            &&
            (dir == SQUAD_WAYPOINT_DIRECTION_POS)
           )
           ||
           ((point.ammo_nails & FL_WAYPOINT_SCRIPT_NEG)
            &&
            (dir == SQUAD_WAYPOINT_DIRECTION_NEG)
           )
          )
          &&
          (point.ammo_nails & FL_WAYPOINT_SPREAD)
         );
};



// Waypoint_IsVisible - similar to visible, determines if
//                      a waypoint can be seen by viewer; however,
//                      now looks thru lava, slime, water and doors
//
float (entity point, entity viewer) Waypoint_IsVisible =
{ local vector    spot1, spot2;

  spot1 = viewer.origin   + viewer.view_ofs;
  spot2 = point.origin + point.view_ofs;
  traceline (spot1, spot2, TRUE, self);   // see through other monsters

  return ((trace_fraction == 1) || (trace_ent.classname == "door"));
};



// Waypoint_GetAssemblyYaw - returns facing direction for team
//                           assembly (if applicable, 0 otherwise)
//
//
float (entity point) Waypoint_GetAssemblyYaw =
{ // return direction point.next - point
  // signal how positions shall be filled up
  //                     n
  //                     ^
  //                     |
  //            p -----> w    (top view, n = next, w = waypoint, p = prev)
  //
  local vector vSpotDir;
  local float  fSpotDir;
  local entity next_waypoint;
  next_waypoint = Waypoint_Next(point);
  vSpotDir      = next_waypoint.origin - point.origin;
  fSpotDir      = vectoyaw(vSpotDir);

  local vector vApproachDir;
  local float  fApproachDir;
  local entity prev_waypoint;
  prev_waypoint = Waypoint_Previous(point);
  vApproachDir  = prev_waypoint.origin - point.origin;
  fApproachDir  = vectoyaw(vApproachDir);

  // determine if assembly positions shall be filled
  // clockwise or counterclockwise
  local float angle;
  angle = 360 + fSpotDir - fApproachDir;
  angle = anglemod(angle);

  if (angle < 180)
    // counterclockwise - signal by subtracting 360 degrees
    fSpotDir = fSpotDir - 360;

  return fSpotDir;
};




// Waypoint_GetAssemblyFormation - returns formation, 0 if not assembly
//
//
//
float (entity point) Waypoint_GetAssemblyFormation =
{ return point.ammo_nails;
};



// Waypoint_GetAssemblyOffset - returns offset
//
//
//
float (entity point) Waypoint_GetAssemblyOffset =
{ return point.ammo_cells;
};



// Waypoint_Touch - react to collisions with other entities
//
//
//
void () Waypoint_Touch =
{ if (other.classname == "bot")
    { // process any buttons attached to waypoint
      if (self.enemy != world)
        { // touch button (adjust self and other)
          local entity this;
          this = self;
          self  = this.enemy;
          button_touch();
          self = this;
        }
      Squad_Behavior_ReachedWaypoint(other, self);
    }
/*
  else
  if (other.classname == "player")
    { bprint("player touches waypoint \"");
      bprint(self.netname);
      bprint("\"\n");
    }
*/
};



// Waypoint_UpdateLastVisitTime   - set last time waypoint has
//                                  been visited (for re-assembly
//                                  purposes)
//
void (entity point, float visittime) Waypoint_UpdateLastVisitTime =
{ point.search_time = visittime;
};



// Waypoint_GetTimeSincePreviousVisit - returns last recorded visit
//                                      time
//
//
float (entity point) Waypoint_GetTimeSincePreviousVisit =
{ return time - point.search_time;
};




// Waypoint_ToggleVisibility   - changes visibility of waypoints
//
//
//
void () Waypoint_ToggleVisibility =
{ local entity next_point;

  // toggle
  waypointsVisible = !waypointsVisible;

  // init
  next_point       = find(world, classname, "waypoint");
  if (next_point == world)
    return;

  if (waypointsVisible)
    { Waypoint_Show(next_point); }
  else
    { Waypoint_Hide(next_point); }

  // test
  next_point = find (next_point, classname, "waypoint");
  while (next_point != world)
    { if (waypointsVisible)
        { Waypoint_Show(next_point); }
      else
        { Waypoint_Hide(next_point); }

      next_point = find (next_point, classname, "waypoint");
    }

  // dump info
  local entity point;
  point = find(world, classname, "waypoint");
  while (point != world)
    { dprint("waypoint ");
      dprint(point.netname);
      dprint(" [p: ");
      if (point.movetarget != world)
        dprint(point.movetarget.netname);
      else
        dprint("world");
      dprint(", n:");
      if (point.goalentity != world)
        dprint(point.goalentity.netname);
      else
        dprint("world");
      dprint(", d:");
      if ((point.weaponframe == 0) || (point.weaponframe & 1))
        dprint("+");
      if ((point.weaponframe == 0) || (point.weaponframe & 2))
        dprint("-");
      dprint(", s:");
      if (point.ammo_nails & FL_WAYPOINT_SCRIPT_POS)
        dprint("+");
      if (point.ammo_nails & FL_WAYPOINT_SCRIPT_NEG)
        dprint("-");
      dprint(", f:");
      if (point.ammo_nails & FL_WAYPOINT_ASSEMBLY_SQUARE)
        dprint("s");
      if (point.ammo_nails & FL_WAYPOINT_ASSEMBLY_LINE)
        dprint("l");
      dprint(", s:");
      if (point.ammo_nails & FL_WAYPOINT_SPREAD)
        dprint("s");
      dprint("] in:");

      if (pointcontents(point.origin) == CONTENT_LAVA)
        dprint("lava");
      else
      if (pointcontents(point.origin) == CONTENT_SLIME)
        dprint("slime");
      else
      if (pointcontents(point.origin) == CONTENT_WATER)
        dprint("water");
      else
      if (pointcontents(point.origin) == CONTENT_SOLID)
        dprint("solid");
      else
        dprint("free space");
      dprint("\n");
      // iterate
      point = find(point, classname, "waypoint");
  }
};



// Waypoint_Hide               - removes any visible aspects of
//                               the waypoint
//
void (entity point) Waypoint_Hide =
{ setmodel(point, "");
};



// Waypoint_Show               - enables the visible aspects of
//                               the waypoint
//
void (entity point) Waypoint_Show =
{ if (Waypoint_IsAssemblyLocation(point, SQUAD_WAYPOINT_DIRECTION_POS))
    setmodel(point, "progs/lavaball.mdl");
  else
  if (Waypoint_IsAssemblyLocation(point, SQUAD_WAYPOINT_DIRECTION_NEG))
    setmodel(point, "progs/lavaball.mdl");
  else
  if (Waypoint_IsSpreadLocation(point, SQUAD_WAYPOINT_DIRECTION_NEG))
    setmodel(point, "progs/armor.mdl");
  else
  if (Waypoint_IsSpreadLocation(point, SQUAD_WAYPOINT_DIRECTION_POS))
    setmodel(point, "progs/armor.mdl");
  else
    setmodel(point, "progs/s_bubble.spr");
};


/*
// Waypoint_Display            - displays info about specific waypoint
//
//
void (entity point) Waypoint_Display =
{ local entity next_point;
  local float  point_nr;
  local string output;

  // init
  point_nr         = 0;
  next_point       = find(world, classname, "waypoint");

  // test
  while (next_point != point)
    { next_point = find(next_point, classname, "waypoint");
    }

  // output
  dprint("going to wp ");
  dprint(next_point.netname);
  dprint("[");
  output = ftos();
  dprint(output);
  dprint("] at coords[");
  output = vtos(point.origin);
  dprint(output);
  dprint("]\n");
};
*/


// Waypoint_PlotPosition     - dumps position of self to output
//
//
void () Waypoint_PlotPosition =
{ local entity new_waypoint;
  local string output;

  new_waypoint = spawn();
  new_waypoint.origin = self.origin;
  setmodel(new_waypoint, "progs/s_bubble.spr");

  // origin_x
  sprint(self, "Plot position: [x = ");
  output= ftos(self.origin_x);
  sprint(self, output);

  // origin_y
  sprint(self, ", y = ");
  output= ftos(self.origin_y);
  sprint(self, output);

  // origin_z
  sprint(self, ", z = ");
  output= ftos(self.origin_z);
  sprint(self, output);
  sprint(self, "]\n");
};
