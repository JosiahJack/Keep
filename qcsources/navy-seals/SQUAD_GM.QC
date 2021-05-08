/****************************************************************************/
/*                                                                          */
/*    project    : S.E.A.L. sQuad       (c) 1997 William van der Sterren    */
/*                                                                          */
/*      file     : squad_gm.qc  "methods for game settings"                 */
/*      author(s): William van der Sterren                                  */
/*      version  : 0.5                                                      */
/*                                                                          */
/*      date (last revision):  Nov 18, 97                                   */
/*      date (creation)     :  Nov 18, 97                                   */
/*                                                                          */
/*                                                                          */
/*      revision history                                                    */
/*      -- date ---- | -- revision ---------------------- | -- revisor --   */
/*                   |                                    |                 */
/*                                                                          */
/****************************************************************************/


//
// Squad game initialization, creation and information
//

// implementation

// local constants - use for cmdline var deathmatch
float  MISSION_FLAGS       = 15;
float  MISSION_STARTTOEXIT =  8;
float  MISSION_EXITTOSTART =  9;
float  SQUAD_FLAGS         = 48;
float  SQUAD_AUTORESPAWN   = 16;
float  ITEMS_FLAGS         = 64;
float  ITEMS_NOT_AVAILABLE = 64;

// local forwards


// Squad_UpdateDeathmatch - sets deathmatch console var to
//                          value; first resets coop
//
//
void (entity client, float value) Squad_UpdateDeathmatch =
{ deathmatch = value;
  coop       = 0;
  //bprint("deathmatch = ");
  //bprint(ftos(deathmatch));
  //bprint("\n");
  stuffcmd(client, "coop 0\n");
  if (deathmatch == 0)
    stuffcmd(client, "deathmatch 0\n");
  if (deathmatch == 8)
    stuffcmd(client, "deathmatch 8\n");
  if (deathmatch == 9)
    stuffcmd(client, "deathmatch 9\n");
  if (deathmatch == 24)
    stuffcmd(client, "deathmatch 24\n");
  if (deathmatch == 25)
    stuffcmd(client, "deathmatch 25\n");
  if (deathmatch == 40)
    stuffcmd(client, "deathmatch 40\n");
  if (deathmatch == 41)
    stuffcmd(client, "deathmatch 41\n");
  if (deathmatch == 64)
    stuffcmd(client, "deathmatch 64\n");
  if (deathmatch == 72)
    stuffcmd(client, "deathmatch 72\n");
  if (deathmatch == 73)
    stuffcmd(client, "deathmatch 73\n");
  if (deathmatch == 88)
    stuffcmd(client, "deathmatch 88\n");
  if (deathmatch == 89)
    stuffcmd(client, "deathmatch 89\n");
  if (deathmatch == 104)
    stuffcmd(client, "deathmatch 104\n");
  if (deathmatch == 105)
    stuffcmd(client, "deathmatch 105\n");
};




// Squad_Game_DoesSquadAutoRespawn  - returns whether game mode is
//                                    mission where squad has to
//                                    respawn after being killed
//                                    completely
//
float () Squad_Game_DoesSquadAutoRespawn =
{ return ((deathmatch & SQUAD_AUTORESPAWN) == SQUAD_AUTORESPAWN);
};




// Squad_Game_DoesHaveItems         - returns whether game mode
//                                    allows items, powerups, etc.
//
//
//
float () Squad_Game_DoesHaveItems =
{ return (!((deathmatch & ITEMS_NOT_AVAILABLE) == ITEMS_NOT_AVAILABLE));
};




// Squad_IsMissionStartToExit - returns whether game mode is
//                              infiltration mission
//
//
float () Squad_Game_IsInfiltrate =
{ local float dm;
  dm = (deathmatch & MISSION_FLAGS);
  return ((dm == MISSION_STARTTOEXIT) || (dm == MISSION_EXITTOSTART));
};


// Squad_Game_IsInfiltrateStartToExit - returns whether game mode is
//                                      mission to reach exit starting
//                                      at start
//
float () Squad_Game_IsInfiltrateStartToExit =
{ return ((deathmatch & MISSION_FLAGS) == MISSION_STARTTOEXIT);
};




// Squad_Game_IsInfiltrateExitToStart - returns whether game mode is
//                                      mission to reach start starting
//                                      at exit
//
float () Squad_Game_IsInfiltrateExitToStart =
{ return ((deathmatch & MISSION_FLAGS) == MISSION_EXITTOSTART);
};



// Squad_Game_ToggleSquadAutoRespawn - toggles squad autorespawn
//
//
//
void (entity client) Squad_Game_ToggleSquadAutoRespawn =
{ local float autorespawn;
  autorespawn = deathmatch & SQUAD_AUTORESPAWN;
  autorespawn = SQUAD_AUTORESPAWN - autorespawn;
  deathmatch  = deathmatch - (deathmatch & SQUAD_AUTORESPAWN)
                           + autorespawn;
  // update cmdline var
  Squad_UpdateDeathmatch(client, deathmatch);
};




// Squad_Game_GetSquadComposition - returns squad composition
//
//
//
float () Squad_Game_GetSquadComposition =
{  return squadTeamComposition;
};



// Squad_Game_ToggleSquadComposition - toggles squad composition
//
//
//
void (entity client) Squad_Game_ToggleSquadComposition =
{ squadTeamComposition = squadTeamComposition + 1;
  if (squadTeamComposition > 2)
    squadTeamComposition = 0;

  // update cmdline var
  //Squad_UpdateDeathmatch(client, deathmatch);
};




// Squad_Game_ToggleItemAvailability - toggles availability of items
//                                     and powerups
//
//
void (entity client) Squad_Game_ToggleItemAvailability =
{ local float autorespawn;
  autorespawn = deathmatch & ITEMS_NOT_AVAILABLE;
  autorespawn = ITEMS_NOT_AVAILABLE - autorespawn;
  deathmatch  = deathmatch - (deathmatch & ITEMS_NOT_AVAILABLE)
                           + autorespawn;
  // update cmdline var
  Squad_UpdateDeathmatch(client, deathmatch);

  // remove items, if required
  if (autorespawn)
    Squad_Game_RemoveItems();
};




// Squad_Game_SetMissionStartToExit - sets deathmatch to correct
//                                    mission mode without disturbing
//                                    other flags
//
void (entity client) Squad_Game_SetMissionStartToExit =
{ deathmatch = deathmatch - (deathmatch & MISSION_FLAGS)
                          + MISSION_STARTTOEXIT;
  // update cmdline var
  Squad_UpdateDeathmatch(client, deathmatch);
};



// Squad_Game_SetMissionExitToStart - sets deathmatch to correct
//                                    mission mode without disturbing
//                                    other flags
//
void (entity client) Squad_Game_SetMissionExitToStart =
{ deathmatch = deathmatch - (deathmatch & MISSION_FLAGS)
                          + MISSION_EXITTOSTART;
  // update cmdline var
  Squad_UpdateDeathmatch(client, deathmatch);
};




// Squad_Game_RemoveItems - removes powerups, weapons, etc.
//                          normally available on a level
//
//
void () Squad_Game_RemoveItems =
{ local entity iterator, thing;
  iterator = findradius(world.origin, 10000);

  while(iterator)
    { thing    = iterator;
      iterator = iterator.chain;
      if ((thing.classname == "weapon_supershotgun")           ||
          (thing.classname == "weapon_nailgun")                ||
          (thing.classname == "weapon_supernailgun")           ||
          (thing.classname == "weapon_grenadelauncher")        ||
          (thing.classname == "weapon_rocketlauncher")         ||
          (thing.classname == "weapon_lightning")              ||
          (thing.classname == "backpack")                      ||
          (thing.classname == "item_shells")                   ||
          (thing.classname == "item_spikes")                   ||
          (thing.classname == "item_rockets")                  ||
          (thing.classname == "item_cells")                    ||
          (thing.classname == "item_armor1")                   ||
          (thing.classname == "item_armor2")                   ||
          (thing.classname == "item_armorInv")                 ||
          (thing.classname == "item_health")                   ||
          (thing.classname == "item_megahealth_rot")           ||
          (thing.classname == "item_artifact_invulnerability") ||
          (thing.classname == "item_artifact_invisibility")    ||
          (thing.classname == "item_artifact_super_damage")
         )
        remove(thing);
    }
};
