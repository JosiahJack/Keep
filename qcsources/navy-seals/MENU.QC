/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : menu.qc  "on screen menu"                                */
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
// menu initialization, creation and information
//

// prototypes - local functions

// - menu renderer, displays messages repeatedly, until time out
// - menu input handler, processes user input according to menu
// - menu definition, defines tekst, input and responses, refers to other
// menus
// - menu manager, owns renderer and input handler




// implementation - info
//
//   menus map on entities reusing standard entities fields
//   - classname   -> "menu"
//
//   menu renderers map on entities reusing standard entities fields
//   - classname   -> "menu renderer"
//   - enemy       -> client for this menu
//   - movetarget  -> menu handler
//   - goalentity  -> menu definition, of which texts are displayed
//   - ammo_shells -> menu definition display duration
//
//
//   menu handler tests on user imput (impulse 1...4, 0)
//   - classname   -> "menu handler"
//   - goalentity  -> menu definition, of which texts are displayed
//   - enemy       -> client for this menu
//   - movetarget  -> menu renderer, controlled by handler
//   - ammo_shells -> clean up (TRUE, FALSE)
//
//
//   menu definitions map on entities reusing standard entities fields
//   - classname   -> "menu definition"
//   - netname     -> menu title
//   - noise1      -> menu texts
//   - th_stand    -> function called after choosing 1st  option ([1])
//   - th_walk     -> function called after choosing 2nd  option ([2])
//   - th_run      -> function called after choosing 3rd  option ([3])
//   - th_die      -> function called after choosing 4th  option ([4])
//   - th_pain     -> function called after choosing 5th  option ([5])
//   - th_missile  -> function called after choosing last option ([6])


// global declarations
entity menuHandler;


// local forward declarations
void (entity handler) MenuHandler_CleanUp;
void (entity user)    Menu_Init;
void ()               MenuAction_None;



// MenuRenderer_Create - creates new menu renderer entity
//
//
//
entity (entity handler, entity menuDefinition, entity user, float duration)
MenuRenderer_Create =
{ local entity renderer;
  renderer = spawn();
  renderer.classname   = "menu renderer";
  renderer.netname     = "menu renderer";
  renderer.enemy       = user;
  renderer.movetarget  = handler;
  renderer.goalentity  = menuDefinition;
  renderer.ammo_shells = duration;

  return renderer;
};



// MenuRenderer_Display - "think" routine to display menu text
//
//
//
void () MenuRenderer_Display =
{ if (self.search_time < time)
    { // time to destroy menu and renderer
      centerprint(self.enemy, "");
      MenuHandler_CleanUp(menuHandler);
      return;
    }

  self.nextthink = time + 0.2;

  // display
  if (self.goalentity == world)
    return;
  centerprint(self.enemy, self.goalentity.noise1);
};



// MenuRenderer_StartMenuDisplay - menu renderer starts displaying
//
//
//
void (entity renderer) MenuRenderer_StartMenuDisplay =
{ renderer.think       = MenuRenderer_Display;
  renderer.search_time = time + renderer.ammo_shells;
  renderer.nextthink   = time + 0.1;
};



// MenuRenderer_ReplaceMenu - menu continues displaying new menu;
//                            timeout is reset.
//
//
void (entity renderer, entity menudef) MenuRenderer_ReplaceMenu =
{ renderer.goalentity  = menudef;
  renderer.search_time = time + renderer.ammo_shells;
  renderer.nextthink   = time + 0.1;
};



// MenuHandler_Create - creates new menu handler entity
//
//
//
entity () MenuHandler_Create =
{ local entity handler;
  handler = spawn();
  handler.classname   = "menu handler";
  handler.netname     = "menu handler";
  handler.enemy       = world;
  handler.goalentity  = world;
  handler.movetarget  = world;
  handler.ammo_shells = TRUE;

  return handler;
};



// MenuHandler_CleanUp - removes renderer and menu,
//                       if allowed to clean up (new menu may
//                       have been set), otherwise allow
//
//
void (entity handler) MenuHandler_CleanUp =
{ if (handler.ammo_shells)
    { // stop renderer
      handler.movetarget.search_time = time;

      // remove renderer
      remove(handler.movetarget);
      handler.movetarget = world;

      // remove menu
      remove(handler.goalentity);
      handler.goalentity = world;
      // user info needs to be remembered
    }
  else
    handler.ammo_shells = TRUE;
};




// MenuHandler_ActivateMenu - runs new menu
//
//
//
void (entity handler, entity menudef, entity user) MenuHandler_ActivateMenu =
{ // set client
  handler.enemy       = user;

  // create new renderer
  local entity menuRenderer;
  menuRenderer = MenuRenderer_Create(handler, menudef, handler.enemy, 10);

  handler.movetarget  = menuRenderer;
  handler.goalentity  = menudef;

  // and start renderer
  MenuRenderer_StartMenuDisplay(menuRenderer);
};



// MenuHandler_GotoMenu - replaces current menu by other menu
//
//
//
void (entity handler, entity menudef) MenuHandler_GotoMenu =
{ // remember old menu
  local entity oldmenu;
  oldmenu = handler.goalentity;
  // store menudef
  handler.goalentity  = menudef;
  remove(oldmenu);
  // prevent cleanup
  handler.ammo_shells = FALSE;
  // have renderer replace and display menu
  MenuRenderer_ReplaceMenu(handler.movetarget, menudef);
};



// MenuHandler_GetUser - returns user that activate menu
//
//
//
entity (entity handler) MenuHandler_GetUser =
{ return handler.enemy;
};



// MenuHandler_ProcessInput - tries to react on impulses
//                            1-4, 9, 99
//                            returns FALSE if no reaction
//                            or if no action defined
//
float (entity handler, float keycode) MenuHandler_ProcessInput =
{ // create menu if no active menu and impulse == 99
  if (handler.goalentity == world)
    { if (keycode == 99)
       { Menu_Init(self);
         return TRUE;
       }
      else
        return FALSE;
    }

  if ((keycode > 6) && (keycode != 9))
    return FALSE;

  local entity menu;
  local float  result;
  menu   = handler.goalentity;
  result = FALSE;
  // test for keys
  if (keycode == 9)
    { // menu exit already done if result == true
      result = TRUE;
    }
  else
  if ((keycode == 1) && (MenuAction_None != menu.th_walk))
    { menu.th_walk();
      result = TRUE;
    }
  else
  if ((keycode == 2) && (MenuAction_None != menu.th_run))
    { menu.th_run();
      result = TRUE;
    }
  else
  if ((keycode == 3) && (MenuAction_None != menu.th_missile))
    { menu.th_missile();
      result = TRUE;
    }
  else
  if ((keycode == 4) && (MenuAction_None != menu.th_die))
    { menu.th_die();
      result = TRUE;
    }
  else
  if ((keycode == 5) && (MenuAction_None != menu.th_pain))
    { menu.th_pain();
      result = TRUE;
    }
  else
  if ((keycode == 6) && (MenuAction_None != menu.th_stand))
    { menu.th_stand();
      result = TRUE;
    }

  if (result)
    { MenuHandler_CleanUp(handler);
      sound (self, CHAN_AUTO, "weapons/gpull.wav", 0.5, ATTN_IDLE);
      self.impulse = 0;
    }

  return result;
};



// MenuDefinition_Create - creates menu definition
//
//
//
entity (string menuName,
        string menuText,
        void() menuAction1,
        void() menuAction2,
        void() menuAction3,
        void() menuAction4,
        void() menuAction5,
        void() menuAction6
        )
MenuDefinition_Create =
{ local entity menudef;
  menudef = spawn();
  menudef.classname   = "menu definition";
  menudef.netname     = menuName;
  menudef.noise1      = menuText;

  menudef.th_walk     = menuAction1;
  menudef.th_run      = menuAction2;
  menudef.th_missile  = menuAction3;
  menudef.th_die      = menuAction4;
  menudef.th_pain     = menuAction5;
  menudef.th_stand    = menuAction6;

  // return entity
  return menudef;
};




// Menu_Precache - initializes globals for menu
//
//
//
void () Menu_Precache =
{ menuHandler = MenuHandler_Create();
};



// forward menu actions
void () MenuAction_ExitMenu;
void () MenuAction_InsertSquad;
void () MenuAction_RemovePowerUpsAndWeapons;
void () MenuAction_MenuDebugSettings;
void () MenuAction_MenuWeaponSettings;
void () MenuAction_MenuGameSettings;
void () MenuAction_MenuSquadSettings;
void () MenuAction_Credits;





// Menu_Init - menu initialisation, create a new menu
//             (that has a limited life)
//
//
void (entity user) Menu_Init =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("main menu",
    "Navy SEALs + sQuad bots: main menu\n\n[1] Insert sQuad of bots    \n[2] Mission Settings...     \n[3] Weapons...              \n[4] Squad Settings...       \n[5] Remove power-ups/weapons\n[6] About / Credits...      \n\n[9] Exit Menu               ",
    MenuAction_InsertSquad,
    MenuAction_MenuGameSettings,
    MenuAction_MenuWeaponSettings,
    MenuAction_MenuSquadSettings,
    MenuAction_RemovePowerUpsAndWeapons,
    MenuAction_Credits
   );

  // activate menu
  MenuHandler_ActivateMenu(menuHandler, menu, user);
};




// MenuAction_ExitMenu - stops displaying menu
//
//
//
void () MenuAction_ExitMenu =
{ MenuHandler_CleanUp(menuHandler);
};




// MenuAction_None - no action (used for menu definitions)
//
//
//
void () MenuAction_None =
{ local float dummy;
};




// forward decl
void() weapon_touch; // in items.qc

void () menu_weapon_touch =
{ if (other.flags & FL_CLIENT)
    { weapon_touch();
      remove(self);
    }
};


// specific menu actions
//
//
//
void (entity theplayer, string wpnclassname, string spawnMessage)
MenuSpawnWeapon =
{ local vector wpnpos;
  local entity wpnmodel;
  makevectors(theplayer.v_angle);

  wpnpos             = theplayer.origin + v_forward * 80;

  // test for space, if fails, return world
  local float  result;
  local vector testpos;
  testpos = wpnpos + v_forward * 16 + v_right * 16;
  traceline(theplayer.origin, testpos, TRUE, theplayer);
  if (trace_fraction < 1.0)
    { sprint(theplayer,
           "мену╨ insufficient space to issue weapon\n");
      return;
    }
  testpos = wpnpos + v_forward * 16 - v_right * 16;
  traceline(theplayer.origin, testpos, TRUE, theplayer);
  if (trace_fraction < 1.0)
    { sprint(theplayer,
           "мену╨ insufficient space to issue weapon\n");
      return;
    }

  wpnmodel           = spawn();
  wpnmodel.classname = wpnclassname;
  if (wpnclassname == "weapon_nailgun")
    { setmodel(wpnmodel, "progs/g_mp5.mdl");
      wpnmodel.weapon  = WP_MP5;
      wpnmodel.netname = "HK MP5";
    }
  else
  if (wpnclassname == "weapon_supernailgun")
    { setmodel(wpnmodel, "progs/g_ashot.mdl");
      wpnmodel.weapon  = WP_ASHOT;
      wpnmodel.netname = "Assault Shotgun";
    }
  else
  if (wpnclassname == "weapon_supershotgun")
    { setmodel(wpnmodel, "progs/g_moss.mdl");
      wpnmodel.weapon   = WP_MOSS;
      wpnmodel.netname = "Mossberg Tactical Shotgun";
    }
  else
  if (wpnclassname == "weapon_rocketlauncher")
    { setmodel(wpnmodel, "progs/g_psg1.mdl");
      wpnmodel.weapon  = WP_PSG1;
      wpnmodel.netname = "PSG-1 Sniper Rifle";
    }
  else
  if (wpnclassname == "weapon_grenadelauncher")
    { setmodel(wpnmodel, "progs/g_m16.mdl");
      wpnmodel.weapon  = WP_M16;
      wpnmodel.netname = "M-16A2";
    }
  else
  if (wpnclassname == "weapon_lightning")
    { setmodel(wpnmodel, "progs/g_m60.mdl");
      wpnmodel.weapon  = WP_M60;
      wpnmodel.netname = "M-60 Light Machinegun";
    }

      if (wpnmodel.model == "progs/g_mp5.mdl" && theplayer.weapons & (theplayer.weapons & WP_MP5 & WP_MP5SD))
      {
        sprint(theplayer,
               "мену╨ you have already been issued this weapon\n");
        remove (wpnmodel);
        return;
      }
      if (wpnmodel.model == "progs/g_m16.mdl" && theplayer.weapons & (theplayer.weapons & WP_M16 & WP_M16RAW))
      {
        sprint(theplayer,
               "мену╨ you have already been issued this weapon\n");
        remove (wpnmodel);
        return;
      }
      if (wpnmodel.model == "progs/g_psg1.mdl" && theplayer.weapons & (theplayer.weapons & WP_PSG1 & WP_BARRETT))
      {
        sprint(theplayer,
               "мену╨ you have already been issued this weapon\n");
        remove (wpnmodel);
        return;
      }

  setsize (wpnmodel, '-16 -16 0', '16 16 56');
  wpnmodel.flags     = FL_ITEM;
  wpnmodel.solid     = SOLID_TRIGGER;
  wpnmodel.movetype  = MOVETYPE_TOSS;
  wpnmodel.touch     = menu_weapon_touch;
  setorigin(wpnmodel, wpnpos);
  wpnmodel.nextthink = time + 5;
  wpnmodel.think     = SUB_Remove;

  sprint(theplayer, spawnMessage);
};


void () MenuAction_ToggleTeamState =
{ SQUAD_TEAM_STATECHANGEINFO   = 1 - SQUAD_TEAM_STATECHANGEINFO;
  if (SQUAD_TEAM_STATECHANGEINFO)
    sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad team state debug on\n");
  else
    sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad team state debug off\n");
};


void () MenuAction_ToggleMemberState =
{ SQUAD_MEMBER_STATECHANGEINFO = 1 - SQUAD_MEMBER_STATECHANGEINFO;
  if (SQUAD_MEMBER_STATECHANGEINFO)
    sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad member state debug on\n");
  else
    sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad member state debug off\n");
};


void () MenuAction_ToggleWaypointVisibility =
{ Waypoint_ToggleVisibility();
  if (waypointsVisible)
    sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad waypoints visible\n");
  else
    sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad waypoints invisible\n");
};


void () MenuAction_TogglePlayerTargeting =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  if (client.flags & FL_NOTARGET)
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ player will be targeted\n");
      client.flags = client.flags - FL_NOTARGET;
    }
  else
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ player will not be targeted\n");
      client.flags = client.flags | FL_NOTARGET;
    }
};


void () MenuAction_ToggleSquadAutoRespawn =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  Squad_Game_ToggleSquadAutoRespawn(client);
  if (Squad_Game_DoesSquadAutoRespawn())
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ squad respawns after being destroyed\n");
    }
  else
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ squad will not respawn\n");
    }
};


void () MenuAction_ToggleItemAvailability =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  Squad_Game_ToggleItemAvailability(client);
  if (Squad_Game_DoesHaveItems())
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ items available (after restart)\n");
    }
  else
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ items removed (also after restart)\n");
    }
};



void () MenuAction_ToggleSquadComposition =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  Squad_Game_ToggleSquadComposition(client);
  if (Squad_Game_GetSquadComposition() == SQUAD_TEAM_HANDGUNONLY)
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ new squads will be handgun armed\n");
    }
  else
  if (Squad_Game_GetSquadComposition() == SQUAD_TEAM_MACHINEGUNONLY)
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ new squads will be machine gun armed\n");
    }
  else
    { sprint(MenuHandler_GetUser(menuHandler), "мену╨ new squads may use both hand- and machine guns\n");
    }
};


void () MenuAction_CurrentMemberState =
{ sprint(MenuHandler_GetUser(menuHandler), "мену╨ current state of player, bots and team\n");
  Squad_Info();
};


void () MenuAction_InfiltrateStartToExit =
{ Squad_Game_SetMissionStartToExit(MenuHandler_GetUser(menuHandler));
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad to defend exit\n");
};


void () MenuAction_InfiltrateExitToStart =
{ Squad_Game_SetMissionExitToStart(MenuHandler_GetUser(menuHandler));
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad to defend start\n");
};


void () MenuAction_SquadTeamSize1 =
{ SQUAD_MEMBERSMAX = 1;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad size set to 1\n");
};


void () MenuAction_SquadTeamSize2 =
{ SQUAD_MEMBERSMAX = 2;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad size set to 2\n");
};


void () MenuAction_SquadTeamSize3 =
{ SQUAD_MEMBERSMAX = 3;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad size set to 3\n");
};


void () MenuAction_SquadTeamSize4 =
{ SQUAD_MEMBERSMAX = 4;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad size set to 4\n");
};


void () MenuAction_InsertSquad =
{ sprint(MenuHandler_GetUser(menuHandler), "мену╨ sQuad team is inserted in this level\n");
  Squad_Team_Create();
};


void () MenuAction_RemovePowerUpsAndWeapons =
{ Squad_Game_RemoveItems();

  sprint(MenuHandler_GetUser(menuHandler),
         "мену╨ all powerups and weapons have been removed\n"
        );
};


void () MenuAction_GiveMP5 =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);

  // spawn a rotating mode in front player for some seconds
  MenuSpawnWeapon(client, "weapon_nailgun",
                  "мену╨ H&K MP5 has been issued\n"
                 );
};


void () MenuAction_GiveMP5SD =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);

  if (!client.weapons & WP_MP5)
  {
     centerprint(client, "Must have MP5 first\n");
     return;
  }
  // spawn a rotating mode in front player for some seconds
  MenuSpawnWeapon(client, "weapon_nailgun",
                  "мену╨ H&K MP5SD has been issued\n"
                 );
};


void () MenuAction_GiveM16 =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  /*
  client.items        = client.items | IT_GRENADE_LAUNCHER;
  client.ammo_nails   = client.ammo_nails +  40;
  client.ammo_rockets = client.ammo_rockets + 1;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ Colt M16 has been issued\n");
  */
  // spawn a rotating mode in front player for some seconds
  MenuSpawnWeapon(client, "weapon_grenadelauncher",
                  "мену╨ Colt M16-A2 has been issued\n"
                 );
};


void () MenuAction_GiveM16RAW =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  
  // spawn a rotating mode in front player for some seconds
  if (!client.weapons & WP_M16)
  {
     centerprint(client, "Must have M16-A2 first\n");
     return;
  }
  MenuSpawnWeapon(client, "weapon_grenadelauncher",
                  "мену╨ Colt M16-A2+RAW has been issued\n"
                 );
};


void () MenuAction_GiveMossberg =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  /*
  client.items        = client.items | IT_SUPER_SHOTGUN
  client.ammo_shells  = client.ammo_shells  + 60;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ Mossberg 590 shotgun has been issued\n");
  */
  // spawn a rotating mode in front player for some seconds
  MenuSpawnWeapon(client, "weapon_supershotgun",
                  "мену╨ Mossberg shotgun has been issued\n"
                 );
};


void () MenuAction_GiveAssaultGun =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  /*
  client.items        = client.items | IT_SUPER_NAILGUN;
  client.ammo_nails   = client.ammo_nails  + 20;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ Assault gun has been issued\n");
  */
  MenuSpawnWeapon(client, "weapon_supernailgun",
                  "мену╨ Assault shotgun has been issued\n"
                 );
};


void () MenuAction_GivePSG1 =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  /*
  client.items        = client.items | IT_ROCKET_LAUNCHER;
  client.ammo_rockets = client.ammo_rockets + 10;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ PSG1 has been issued\n");
  */
  MenuSpawnWeapon(client, "weapon_rocketlauncher",
                  "мену╨ PSG-1 sniper rifle has been issued\n"
                 );
};


void () MenuAction_GiveBarrett =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  if (!client.weapons & WP_PSG1)
  {
     centerprint(client, "Must have PSG-1 first\n");
     return;
  }
  MenuSpawnWeapon(client, "weapon_rocketlauncher",
                  "мену╨ Barrett M82 sniper rifle has been issued\n"
                 );
};


void () MenuAction_GiveM60 =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  /*
  client.items        = client.items | IT_LIGHTNING;
  client.ammo_cells   = client.ammo_cells   + 50;
  sprint(MenuHandler_GetUser(menuHandler), "мену╨ M60 has been issued\n");
  */
  MenuSpawnWeapon(client, "weapon_lightning",
                  "мену╨ M60 machine gun has been issued\n"
                 );
};



void () MenuAction_Restart =
{ local entity client;
  client              = MenuHandler_GetUser(menuHandler);
  stuffcmd(client, "restart\n");
};



// specific menus (and actions)
//
//
//
void () MenuAction_MenuDebugSettings =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("debug menu",
    "Navy SEALs + sQuad bots 2.0.1 : debug settings\n\n[1] Show/Hide Team State   \n[2] Show/Hide Member State \n[3] Show/Hide Waypoints    \n[4] Show team/bot states   \n[5] Toggle Player Targeting\n\n[9] Exit Menu              ",
    MenuAction_ToggleTeamState,
    MenuAction_ToggleMemberState,
    MenuAction_ToggleWaypointVisibility,
    MenuAction_CurrentMemberState,
    MenuAction_TogglePlayerTargeting,
    MenuAction_None
   );

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};



void () MenuAction_MenuGameSettings =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("game menu",
    "Navy SEALs + sQuad bots : game settings\n\n[1] Infiltrate start-to-exit\n[2] Infiltrate exit-to-start\n[3] Toggle sQuad respawn    \n[4] Toggle item availability\n[5] <not implemented>       \n[6] Restart mission         \n\n[9] Exit Menu               ",
    MenuAction_InfiltrateStartToExit,
    MenuAction_InfiltrateExitToStart,
    MenuAction_ToggleSquadAutoRespawn,
    MenuAction_ToggleItemAvailability,
    MenuAction_None,
    MenuAction_Restart
   );

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};


void () MenuAction_CloseRangeWeaponSettings;
void () MenuAction_MenuOtherWeapons;

void () MenuAction_MenuWeaponSettings =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("weapons menu",
    "Navy SEALs + sQuad bots : weapons\n\n[1] Close range firearms     \n[2] Other firearms           \n\n[9] Exit Menu                ",
    MenuAction_CloseRangeWeaponSettings,
    MenuAction_MenuOtherWeapons,
    MenuAction_None,
    MenuAction_None,
    MenuAction_None,
    MenuAction_None
   );

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};


void () MenuAction_MenuOtherWeapons =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("other weapons menu",
    "Navy SEALs + sQuad bots : other weapons\n\n[1] Give Colt M16-A2         \n[2] Give Colt M16-A2 + RAW   \n[3] Give PSG-1 sniper rifle  \n[4] Give Barrett M82 sniper  \n[5] Give M60 machine gun     \n\n[9] Exit Menu                ",
    MenuAction_GiveM16,
    MenuAction_GiveM16RAW,
    MenuAction_GivePSG1,
    MenuAction_GiveBarrett,
    MenuAction_GiveM60,
    MenuAction_None
   );

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};


void () MenuAction_CloseRangeWeaponSettings =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("close range weapons menu",
    "Navy SEALs + sQuad bots : close range\n\n[1] Give H&K MP5             \n[2] Give H&K MP5SD (silencer)\n[3] Give Mossberg shotgun    \n[4] Give assault shotgun     \n\n\n[9] Exit Menu                ",
    MenuAction_GiveMP5,
    MenuAction_GiveMP5SD,
    MenuAction_GiveMossberg,
    MenuAction_GiveAssaultGun,
    MenuAction_None,
    MenuAction_None
   );

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};


void () MenuAction_MenuSquadSettings =
{ // create menu definition
  local entity menu;
  menu = MenuDefinition_Create("squad menu",
    "Navy SEALs + sQuad bots : sQuad settings\n\n[1] Set sQuad team size = 1 \n[2] Set sQuad team size = 2 \n[3] Set sQuad team size = 3 \n[4] Set sQuad team size = 4 \n[5] Toggle sQuad composition\n[6] Debug sQuad bots/team   \n\n[9] Exit Menu               ",
    MenuAction_SquadTeamSize1,
    MenuAction_SquadTeamSize2,
    MenuAction_SquadTeamSize3,
    MenuAction_SquadTeamSize4,
    MenuAction_ToggleSquadComposition,
    MenuAction_MenuDebugSettings
   );

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};



void () MenuAction_Credits =
{ // create menu definition (stays on the screen for some time)
  local entity menu;
  menu = MenuDefinition_Create("credits menu",
/*
              "Navy SEALs 1.91 beta + sQuad bots - a Quake PC\n\n"
              "gooseman@smartt.com         - project, models, weapons\n"
              "skullhunter                 - models, weapons         \n
              "sterren@iae.nl              - bot/team AI, menus      \n"
              "alan.kivlin@cybersurf.co.uk - rankings code           \n"
              "legion@keg.zymurgy.org      - bot movement code       \n"
*/
    "Navy SEALs 2.0.1 + sQuad bots v2.0\n\na Quake PC\n\ngooseman@smartt.com         \n- project, models, weapons\nSkullhunter                 \n- models, weapons         \nsterren@iae.nl              \n- bot/team AI, menus      \nalan.kivlin@cybersurf.co.uk \n- rankings code           \nlegion@keg.zymurgy.org      \n- bot movement code       \nDnV@planetquake.com,        \nBlackhorse@poboxes.com      \n- web site + publicity    ",
    MenuAction_None,
    MenuAction_None,
    MenuAction_None,
    MenuAction_None,
    MenuAction_None,
    MenuAction_None);

  // activate menu
  MenuHandler_GotoMenu(menuHandler, menu);
};




