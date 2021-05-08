// PM:  Merged much of the miscellaneous Hipnotic code into this one file
// hip.qc.

// FIXME:  Put much of what's here into other files.

// -- Hipnotic files listed in Drake progs.src. --
// hip.qc   = Everything not found below.
// quake.qc = Earthquakes -- Removed because of custom code in 'cool.qc'.
// rotate.qc= Rotating walls and the like.  One big mess.
// spawn.qc = Entity copying, func_spawns, and Horn powerup.
// tesla.qc = Lightning traps.  Another mess.

//==========================================================================
//==========================================================================
//  HIPNOTIC FUNCTIONS
//==========================================================================

//==========================================================================




//- - - - - - - - - - - - - - - - - - -
// quake
//- - - - - - - - - - - - - - - - - - -
// rotate
//- - - - - - - - - - - - - - - - - - -
//==========================================================================


//- - - - - - - - - - - - - - - - - - -
//////////////////////////////////////////////////////////////////////////
//hipmisc.qc

/* Miscelanneous QuickC program
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

//============
// --> QUAKED info_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
// Stuffs a command into the console to allow map designers
// to set server variables.
//
// "message" is the command to send to the console.
//============
void() info_command =
{
    if (self.message)
        localcmd (self.message);
};

void() effect_teleport_use =
{
    Tent_Point (TE_TELEPORT, self.origin);
    sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
};

//============
// --> QUAKED effect_teleport (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
// Create a teleport effect when triggered
//============
void() effect_teleport =
{
    precache_sound("misc/r_tele1.wav");
    self.use = effect_teleport_use;
};


//===========================/  END OF FILE  /===========================//
