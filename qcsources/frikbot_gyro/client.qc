/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

//qb: add urqp items
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin
//            waiting for button release when respawning in multiplayer games
// 2001-08-22 Storing armortype between levels in parm9 fix by Slot Zero
//            putting armortype into parm9 as it is
// 2001-04-22 Option: Random map rotation by Maddes
//            choosing random map when "SAMELEVEL" is >1 in deathmatch
//            and changed stuffcmd() string to "mapX"
//            and using "TEMP1" to save selected map alias to avoid repetitions
// 2000-07-16 Entity of disconnecting client not initialized fix by Maddes
//            initializing classname and health of disconnecting client
// 2000-07-15 Restructured fraglimit and timelimit by Maddes
//            removing old CheckRules() function including calls
// 2000-07-14 Model hacks information by Maddes
//            adding hint that hacking .modelindex directly is necessary for players
//            as otherwise player would loose hull for clipping :(
// 2000-07-14 Client's viewpoint not updated when has no model partial fix by Raymond Martineau
//            sending additional SVC message to client with no model
// 2000-07-14 Debug function for client view bug by Maddes
//            saving player model on spawn
//            new impulse IMPULSE_DEBUG_CLIENTVIEW for toggling client model
// 2000-06-29 Avoid warnings with FrikQCC by Maddes
//            always returning a value in FindIntermission()
// 1999-10-24 Custom wateralpha for maps by Maddes (idea by Daniel "Armadillo" Roberts)
//            sending custom wateralpha to connecting client
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes
//            adding impulse function
// 1999-10-22 Improved non-weapon-related impulses by Maddes
//            adding non-weapon-related impulses
// 1999-09-24 Firing during intermission fix by Athos
//            clearing player's nextthink on intermission
// 1999-08-30 Ghost eyes and hovering bodies fix by FrikaC/Maddes
//            fixing client disconnect
// 1999-06-03 Resume function by Jim Steers/Maddes
//            using resume functions
// 1999-04-20 Random respawn points by Xian/Maddes
//            searching free respawn points and take a random one
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            setting weapons/ammo/armor in DM4 and DM5 modes
//            and recognizing OctaPower in DM4 mode
//            and recognizing electrocution on player death in DM3, DM4 and DM5 modes
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos
//            removing megahealth on level changes
// 1999-02-03 Option: Map rotation by Maddes
//            recognizing SAVEDGAMECFG_MAP_ROTATION and "SAMELEVEL" in deathmatch
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes
//            recognizing SAVEDGAMECFG_RESPAWN_NAKED_ON_NEW_MAP in deathmatch
// 1999-02-02 Enhanced info system by Maddes
//            using client information display for respawn message
// 1999-02-01 Samelevel fix by Maddes
//            recognizing "SAMELEVEL" only in deathmatch
// 1998-12-24 Incorrect frag sentence when a player disconnects fix by Maddes
//            recognizing frag count
// 1998-12-24 Palette shift during intermission fix by Maddes
//            removing items during intermissions
// 1998-12-23 Monster attack player on intermission points fix by Maddes
//            removing variable definition
// 1998-09-16 No exclusive deathmessage for being killed by Chthon fix by Maddes
//            defining new deathmessage
// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
//            using new monster touch function on players
// 1998-09-15 Two minute warning by Maddes (inspired by an Inside3D tutorial)
//            removing timelimit check
// 1998-08-12 Option: Drowning doesn't hurt armor by Maddes/Athos
//            setting new deathtype
// 1998-08-10 Player drops backpack on suicide by Maddes
//            using "Killed()" function on suicide
//            setting and recognizing new deathtype
// 1998-07-27 Suicide during intermission fix by Zhenga
//            permitting suicide during intermission
// 1998-07-27 Timelimit/Fraglimit fix by Maddes
//            recognizing "timelimit"/"fraglimit" only in deathmatch
// 1998-07-26 Pentagram telefrag fix by Zoid/Maddes
//            changing handling of double pentagram telefrag
// 1998-07-24 Wrong obituary messages fix by Zoid
//            initializing .deathtype
//            recognizing .deathtype
// 1998-07-23 Better performance in handling of powerups by Maddes
//            new handling of powerups (eyes model, quad/pentagram glow)
// 1998-07-21 Moving after respawn fix by Xian
//            setting .velocity to zero
// 1998-07-21 Respawning where player died fix by Robert Field
//            setting .oldorigin
// 1998-07-17 Series of Message Of The Day (MOTD) by Maddes
//            changing MOTD handling
// 1998-07-16 Noexit without dying by Maddes (inspired by Robert Field)
//            recognizing "noexit" 3/4
// 1998-07-08 Noexit singleplayer/coop fix by Maddes
//            recognizing "noexit" only in deathmatch
// 1998-01-21 Episode fix by Maddes
//            recognizing deathmatch on new episodes
// 1998-01-04 event skin support by Maddes
//            remembering skin after powerup expires
// 1997-12-30 skin support by Maddes
//            remembering skin on respawn and after level changes
//            and displaying skin info on respawn and after level changes
//            and setting skin 0 on powerup pickup (ring of shadows)
//            and remembering skin after powerup expires (ring of shadows)
//            and recognizing Shub's killer for finale intermission
// 1997-12-26 auto-aim toggle by Maddes
//            remembering auto-aim on respawn and after level changes
//            and displaying auto-aim info on respawn and after level changes
// 1997-12-24 Message on respawn by Maddes
//            displaying info on respawn and after level changes
// 1997-12-24 Message Of The Day (MOTD) by Maddes
//            displaying MOTD after level changes

#include "directives.qh"	// 2001-04-22 by Maddes

// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

//float	modelindex_eyes, modelindex_player;	// 1998-07-23 Better performance in handling of powerups by Maddes

/*=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================*/

//float	intermission_running;	// 1998-12-23 Monster attack player on intermission points fix by Maddes
float	intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'*/
void() info_intermission =
{
};



void() SetChangeParms =
{
	if (self.health <= 0)
	{
		SetNewParms ();
		return;
	}
 
// remove items
	self.items = self.items - (self.items &
	(IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD | IT_SUPERHEALTH) );	// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (!(self.items & IT_AXE))
		self.items = self.items | IT_AXE;
	if (!(self.items & IT_SHOTGUN))
		self.items = self.items | IT_SHOTGUN;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
	
// cap super health
	if (self.health > 100)
		self.health = 100;

	if (self.health < 50)
		self.health = 50;

	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;

	if (self.ammo_shells < 25)
		parm4 = 25;

	else
		parm4 = self.ammo_shells;

	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (self.weapon == IT_AXE)
		self.weapon = IT_SHOTGUN;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
	parm8 = self.weapon;

// 2001-08-22 Storing armortype between levels in parm9 fix by Slot Zero  start
//	parm9 = self.armortype * 100;
	parm9 = self.armortype;
// 2001-08-22 Storing armortype between levels in parm9 fix by Slot Zero  end

	parm15 = self.skin_selected;		// 1997-12-30 skin support by Maddes  save skin on level changes

	parm16 = self.autoaim_off;		// 1997-12-26 auto-aim toggle by Maddes  save auto-aim on level changes
};

void() SetNewParms =
{
	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;

	// 1997-12-30 skin support by Maddes  self.skin_selected is only saved in parm15 on respawn (see there)

	// 1997-12-26 auto-aim toggle by Maddes  self.autoaim_off is only saved in parm16 on respawn (see there)
};

void() DecodeLevelParms =
{
// 1998-01-21 Episode fix by Maddes  start
	if (!deathmatch)
//	if (serverflags)
// 1998-01-21 Episode fix by Maddes  end
	{
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
	}
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes  start
	else
		if (savedgamecfg & SAVEDGAMECFG_RESPAWN_NAKED_ON_NEW_MAP)
			SetNewParms ();		// take away all stuff
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes  end
	
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
// 2001-08-22 Storing armortype between levels in parm9 fix by Slot Zero  start
//	self.armortype = parm9 * 0.01;
	self.armortype = parm9;
// 2001-08-22 Storing armortype between levels in parm9 fix by Slot Zero  end

// 1997-12-30 skin support by Maddes  start
	self.skin_selected = parm15;		// remember skin after respawn and level changes
	parm15 = 0;				// has to be cleared, because new clients get a copy of the "Parm..." variables from another client
						// and all clients should start with skin #0
// 1997-12-30 skin support by Maddes  end

// 1997-12-26 auto-aim toggle by Maddes  start
	self.autoaim_off = parm16;		// remember auto-aim after respawn and level changes
	parm16 = 0;				// has to be cleared, because new clients get a copy of the "Parm..." variables from another client
						// and all clients should start with auto-aiming on
// 1997-12-26 auto-aim toggle by Maddes  end
};

/*============
FindIntermission

Returns the entity to view from
============*/
entity() FindIntermission =
{
	local	entity spot;
	local	float cyc;

	// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");

			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}

		return spot;
	}

	// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
	// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
	return spot;// pOx - shut up compiler warning
};


string nextmap;
void() GotoNextMap =
{
// 1999-02-01 Samelevel fix by Maddes  start
	if (deathmatch)
	{
// 1999-02-01 Samelevel fix by Maddes  end

// 1999-02-03 Option: Map rotation by Maddes  start
		local float		follow_map;
		local string	new_current_map;	// 2001-04-22 Option: Random map rotation by Maddes

		if (samelevel < 0 || samelevel > 1)	// 2001-04-22 Option: Random map rotation by Maddes
		{
// 2001-04-22 Option: Random map rotation by Maddes  start
			if (samelevel > 1)
			{
				do
				{
					follow_map = ceil(random()*samelevel);	// 0.0 = 0, 0.000001 = 1, ..., 1 = samelevel
					if (follow_map == 0)
					{
						follow_map = 1;
					}
				} while (follow_map == current_map);	// avoid repetitions
			}
			else
			{
// 2001-04-22 Option: Random map rotation by Maddes  end
				follow_map = fabs(samelevel);
				cvar_set("samelevel", "0");	// to avoid endless loop when alias does not exist
// 2001-04-22 Option: Random map rotation by Maddes  start
			}

			new_current_map = ftos(follow_map);
			cvar_set("temp1", new_current_map);	// set for later random map rotations
// 2001-04-22 Option: Random map rotation by Maddes  end

			localcmd("map");
			localcmd(ftos(follow_map));
			localcmd("\n");
			return;
		}
	else
// 1999-02-03 Option: Map rotation by Maddes  end

// 1999-02-03 Option: Map rotation by Maddes  start
//		if (cvar("samelevel"))	// if samelevel is set, stay on same level
		if (samelevel)			// if samelevel is set, stay on same level
// 1999-02-03 Option: Map rotation by Maddes  end
		{			// 1999-02-01 Samelevel fix by Maddes
			changelevel (mapname);
// 1999-02-01 Samelevel fix by Maddes  start
			return;
		}
	}
//	else
// 1999-02-01 Samelevel fix by Maddes  end
		changelevel (nextmap);
};


void() ExitIntermission =
{
	// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
	
			if (!cvar("registered"))
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
	
			else
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
	
			return;
		}
	
		else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
	
			return;
		}
	
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
	
			return;
		}
	
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
	
			return;
		}

		GotoNextMap();
	}
	
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
	
			return;
		}
		
		if ( (serverflags&15) == 15)
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
	
			return;
		}
		
	}

	GotoNextMap();
};

/*============
IntermissionThink

When the player presses attack or jump, change to the next level
============*/
void() IntermissionThink =
{
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	ExitIntermission ();
};

void() execute_changelevel =
{
	local entity	pos;

	intermission_running = 1;

	// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;

	else
		intermission_exittime = time + 2;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	
	pos = FindIntermission ();

	other = find (world, classname, "player");

	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.think = SUB_Null;		// 1999-09-24 Firing during intermission fix by Athos
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
	if (other.classname != "player")
		return;

// 1998-07-08 Noexit singleplayer/coop fix by Maddes  start
	if (deathmatch)
	{
// 1998-07-08 Noexit singleplayer/coop fix by Maddes  end
	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}
// 1998-07-16 Noexit without dying by Maddes (inspired by Robert Field)  start
	if ((cvar("noexit") == 3) || ((cvar("noexit") == 4) && (mapname != "start")))
	{
		return;
	}
// 1998-07-16 Noexit without dying by Maddes (inspired by Robert Field)  end
	}	// 1998-07-08 Noexit singleplayer/coop fix by Maddes

	if (coop || deathmatch)
	{
	bprint (other.netname);
	bprint (" exited the level\n");
	}

	gameover = TRUE;	// 1998-09-15 Two minute warning by Maddes
	
	nextmap = self.map;

	SUB_UseTargets ();

	if ( (self.spawnflags & 1) && (deathmatch == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();

		return;
	}
	
	self.touch = SUB_Null;

	// we can't move people right now, because touch functions are called
	// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  
Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission 
spot and display stats.*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");

	//gnounc
	self.netname = "changelevel";
	self.killstring = " tried to leave\n";
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQueue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}

	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQueue (self);
		// set default spawn parms
		SetNewParms ();
		parm15 = self.skin_selected;		// 1997-12-30 skin support by Maddes  save skin on respawn
		parm16 = self.autoaim_off;		// 1997-12-26 auto-aim toggle by Maddes  save auto-aim on respawn
		// respawn		
		PutClientInServer ();
	}

	else
	{	// restart the entire server
		localcmd ("restart\n");
	}

	self.spawn_info = time + 0.1;			// 1997-12-24 Message on respawn by Maddes  wait a game tick
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
// 1998-07-27 Suicide during intermission fix by Zhenga  start
	if ((intermission_running)&&((coop)||(deathmatch)))  // not allowed during intermission
		return;
// 1998-07-27 Suicide during intermission fix by Zhenga  end

// 1998-08-10 Player drops backpack on suicide by Maddes  start
/*
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;

	self.skin = self.skin_selected;		// 1997-12-30 skin support by Maddes

	self.frags = self.frags - 2;	// extra penalty
	respawn ();
*/
	self.deathtype = "suicide";
	self.health = 0;
	Killed(self,self);
// 1998-08-10 Player drops backpack on suicide by Maddes  end
};

float(vector v) CheckSpawnPoint =
{
	return FALSE;
};

/*============
SelectSpawnPoint

Returns the entity to spawn at
============*/
entity() SelectSpawnPoint =
{
	local   entity spot, thing;
	local   float   numspots, totalspots;
	local   float   pcount;

	numspots = 0;
	totalspots = 0;

	// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
	// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
// 1999-04-20 Random respawn points by Xian/Maddes  start
//            *** Adapted from QW - this is a total rewrite ***
		local float	freespots;
		local entity	lastfreespot;

		totalspots = 0;

		// loop through all spots to find widely free spots (radius 84)
		freespots = 0;
		lastfreespot = world;

		spot = find (world, classname, "info_player_deathmatch");       

		while (spot)
		{
			totalspots = totalspots + 1;

			if (spot != lastspawn)
			{
			pcount=0;               
				thing = findradius(spot.origin, 84);		// search for players
				while ( (thing!=world) && (pcount == 0) )
				{
					if ((thing.classname == "player") && (thing.health > 0))	// player found
						pcount = 1;
					thing = thing.chain;
				}
				if (!pcount)					// this is a free spot
				{
					spot.goalentity = lastfreespot;		// create reverse free spot list
					lastfreespot = spot;			// begin of reverse free spot list
					freespots = freespots + 1;
				}
			}

			// Get the next spot in the chain
			spot = find(spot, classname, "info_player_deathmatch");
		}

		if (totalspots)
		{
			if (freespots)
			{
				// We now have the number of frre spots available on the map
				// Generate a random number between 0 and (freespots - 1)
				freespots = freespots - 0.01;	// random() result varies between 0.0 and (n-1).99
				freespots = floor(random() * freespots);

				spot = lastfreespot;
				while (freespots)
			{
					spot = spot.goalentity;
					freespots = freespots - 1;
				}

				lastspawn = spot;
				return spot;
			}

			// ack, they are all guarded
			// loop through all spots to find free spots (radius 32)
			freespots = 0;
			lastfreespot = world;

			spot = find(world, classname, "info_player_deathmatch");
			while (spot)
			{
				if (spot != lastspawn)
				{
					pcount = 0;
					thing = findradius(spot.origin, 32);		// search for players
					while ( (thing!=world) && (pcount == 0) )
					{
						if ((thing.classname == "player") && (thing.health > 0))	// player found
							pcount = 1;
				thing=thing.chain;      
			}
					if (!pcount)					// this is a free spot
			{
						spot.goalentity = lastfreespot;		// create reverse free spot list
						lastfreespot = spot;			// begin of reverse free spot list
						freespots = freespots + 1;
					}
			}

			// Get the next spot in the chain
			spot = find (spot, classname, "info_player_deathmatch");                
		}

			if (freespots)
		{
				// We now have the number of free spots available on the map
				// Generate a random number between 0 and (freespots - 1)
				freespots = freespots - 0.01;	// random() result varies between 0.0 and (n-1).99
				freespots = floor(random() * freespots);

				spot = lastfreespot;
				while (freespots)
			{
					spot = spot.goalentity;
					freespots = freespots - 1;
			}

				lastspawn = spot;
			return spot;
		}
		
			// ack, they are all full, just pick one at random
			// Generate a random number between 0 and (totalspots - 1)
			totalspots = totalspots - 0.01;	// random() result varies between 0.0 and (n-1).99
			totalspots = floor(random() * totalspots);
	
			spot = find(world, classname, "info_player_deathmatch");
			while (totalspots)
		{
				totalspots = totalspots - 1;
				spot = find(spot, classname, "info_player_deathmatch");
		}
	
			lastspawn = spot;
		return spot;
	}
// 1999-04-20 Random respawn points by Xian/Maddes  end
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
	
		if (spot)
			return spot;
	}
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
};

/*===========
PutClientInServer

called each time a player is spawned
============*/
void() DecodeLevelParms;
void() PlayerDie;
void() monster_touch;		// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

void() PutClientInServer =
{
	local	entity spot;

	spot = SelectSpawnPoint ();

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	DecodeLevelParms ();
	
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		self.ammo_shells = 0;
		self.ammo_nails = 0;
		self.ammo_rockets = 0;
		self.ammo_cells = 0;
		self.items = self.items - (self.items & (IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING));
		if (axeonly)		//axe only match
			self.weapon = IT_AXE;
		else
		{
			self.ammo_shells = 255;
			self.ammo_nails = 255;
			self.ammo_rockets = 255;
			self.ammo_cells = 255;
			self.items = self.items | IT_SHOTGUN;
			self.items = self.items | IT_SUPER_SHOTGUN;
			self.items = self.items | IT_NAILGUN;
			self.items = self.items | IT_SUPER_NAILGUN;
			self.items = self.items | IT_GRENADE_LAUNCHER;
			self.items = self.items | IT_ROCKET_LAUNCHER;
			self.items = self.items | IT_LIGHTNING;
		}
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 250;
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}

	if (deathmatch == 5)
	{
		self.ammo_nails = 80;
		self.ammo_shells = 30;
		self.ammo_rockets = 10;
		self.ammo_cells = 30;
		self.items = self.items | IT_SHOTGUN;
		self.items = self.items | IT_SUPER_SHOTGUN;
		self.items = self.items | IT_NAILGUN;
		self.items = self.items | IT_SUPER_NAILGUN;
		self.items = self.items | IT_GRENADE_LAUNCHER;
		self.items = self.items | IT_ROCKET_LAUNCHER;
		self.items = self.items | IT_LIGHTNING;
		self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + IT_ARMOR3;
		self.armorvalue = 200;
		self.armortype = 0.8;
		self.health = 200;
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 3;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
	
	self.deadflag = DEAD_NO;
	// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
//	spot = SelectSpawnPoint ();

	self.origin = self.oldorigin = spot.origin + '0 0 1';	// 1998-07-21 Respawning where player died fix by Robert Field
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

	// oh, this is a hack!
// 2000-07-14 Model hacks information by Maddes
// hack is necessary, as otherwise player would loose hull for clipping :(
	self.skin = 0;			// 1997-12-30 skin support by Maddes
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	self.skin = self.skin_selected;		// 1997-12-30 skin support by Maddes
// 2000-07-14 Debug function for client view bug by Maddes  start
#ifdef DEBUG_CLIENTVIEW
	self.mdl = self.model;
#endif
// 2000-07-14 Debug function for client view bug by Maddes  end

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

// Mod - Xian (May.20.97)
// Bug where player would have velocity from their last kill
	self.velocity = '0 0 0';	// 1998-07-21 Player moves after respawn fix by Xian

	player_stand1 ();
	
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin, self);
	
	stuffcmd(self, "-attack\n");            // Supa, prevent shooting after respawning in MP
	// pOx - START - func_water support
	self.fwatershift = TRUE;// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;// use unmodified sv_gravity
	// pOx - END - func_water support
};


/*=============================================================================

				QUAKED FUNCTIONS

=============================================================================*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};


/*
saved out by quaked in region mode
*/
void() testplayerstart =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
*/
void() NextLevel =
{
	local entity o;

	if (nextmap != "")
		return; // already done

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}

		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}

		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}

		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}

		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}
 
		o = spawn();
		o.map = mapname;
	}

	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");

		if (!o || mapname == "start")
		{       // go back to same map if no trigger_changelevel
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;
	gameover = TRUE; // gb

	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*============
CheckRules

Exit deathmatch games upon conditions
============
*/
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
/*
void() CheckRules =
{
//	local	float		timelimit;	// 1998-09-15 Two minute warning by Maddes
	local	float		fraglimit;
	
	if (gameover)	// someone else quit the game already
		return;
		
//	timelimit = cvar("timelimit") * 60;	// 1998-09-15 Two minute warning by Maddes
	fraglimit = cvar("fraglimit");
	
// 1998-09-15 Two minute warning by Maddes  start
//	if (deathmatch && timelimit && time >= timelimit)	// 1998-07-27 Timelimit/Fraglimit fix by Maddes
//	{
//		NextLevel ();
//		return;
//	}
// 1998-09-15 Two minute warning by Maddes  end
	
	if (deathmatch && fraglimit && self.frags >= fraglimit)	// 1998-07-27 Timelimit/Fraglimit fix by Maddes
	{
		bprint("\n∆Ú·ÁÏÈÌÈÙ ËÈÙ ≠ Õ·Ù„Ë ÔˆÂÚ\n");	// 1998-09-15 Two minute warning by Maddes
								// "Fraglimit hit - Match over"
		NextLevel ();
		return;
	}	
};
*/
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end

//============================================================================

void() PlayerDeathThink =
{
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  start
//	local entity	old_self;	// not used
	local float		do_respawn;
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  end
	local float		forward;

	// pOx - func_water support
	CheckFuncWaterDeath();//check cshift for dead players in func_water
	
	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;

		if (forward <= 0)
			self.velocity = '0 0 0';

		else	
			self.velocity = forward * normalize(self.velocity);
	}

	// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;

		self.deadflag = DEAD_RESPAWNABLE;

		return;
	}

	// wait for any button down
	do_respawn = 0;	// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin
	if (!self.button2 && !self.button1 && !self.button0)
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  start
	{
		// Player wants to respawn ASAP
		if (self.deadflag == DEAD_WAITING)
		{
			centerprint (self, "");     // Erase button release message
			do_respawn = 1;
		}
		else
		{
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  end
		return;
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  start
		}
	}

	// In netgames, don't respawn as long as a button is held
	if (!do_respawn)
	{
		if (deathmatch || coop)
		{
			// Player wants to respawn ASAP.
			self.deadflag = DEAD_WAITING;

			// Message not necessary, but useful nonetheless.
			if (self.button0)
			{
				centerprint (self, "Release attack to respawn");
			}
			else if (self.button1)
			{
				centerprint (self, "Release use to respawn");
			}
			else if (self.button2)
			{
				centerprint (self, "Release jump to respawn");
			}
		return;
		}
	}
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  end

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{	
	local float lad;// pOx - func_ladder support
	if (self.flags & FL_WATERJUMP)
		return;
	
	// pOx - START - func_ladder support
	if (self.laddertime > time && self.ladderjump < time) {
		
		// Allow jumping while on a ladder
		if (!(self.flags & FL_ONGROUND)) self.flags = self.flags + FL_ONGROUND;
		
		// Time out a bit so the player doesn't just re-grab the dang thing
		self.ladderjump = time+0.4;
		
		// Stop up move (avoid super-high jumps) but give'm a forward push
		self.velocity_z = 0;
		makevectors(self.angles);
		self.velocity = self.velocity + (v_forward*100);
		lad = 80;
	}
	// pOx - END - func_ladder support
		
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;

		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;

		else
			self.velocity_z = 50;

		/* pOx - commented out - Swimming sounds done in PreThink
		// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;

			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);

			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}*/

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
	// player jumping sound
	//sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	sound (self, CHAN_VOICE, "player/plyrjmp8.wav", 1, ATTN_NORM);// pOx - changed to CHAN_VOICE (!)
	
	// pOx - func_ladder support - not so high on ladders
//	self.velocity_z = self.velocity_z + 270;
	self.velocity_z = self.velocity_z + (270-lad);
};


/*===========
WaterMove

============*/
.float	dmgtime;

void() WaterMove =
{
	if (self.movetype == MOVETYPE_NOCLIP)
		return;

	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);

		else if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}

	else if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;

			if (self.dmg > 15)
				self.dmg = 10;
			self.deathtype = "drowning";	// 1998-08-12 Option: Drowning doesn't hurt armor by Maddes/Athos
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{	
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		
			// pOx - START - Swimming sounds - make sure muffle stops
			if (self.outwsound == 1)
			{
				sound (self, CHAN_BODY, "misc/owater2.wav", 1, ATTN_NORM);
				self.outwsound = FALSE;
				self.inwsound = TRUE;
				self.uwmuffle = FALSE;
			}
			// pOx - END - Swimming sounds	
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;

			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{	

		// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);

		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);

		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
	
	// pOx - START - Swimming Sounds
	if (self.waterlevel >= 3)
	{
		self.outwsound = TRUE;
	
		if (self.inwsound)
		{
			sound (self, CHAN_AUTO, "misc/inh2ob.wav", 1, ATTN_NORM);
			self.inwsound = FALSE;
		}
		
		// don't muffle in DM
		if (!self.uwmuffle && !deathmatch && !coop)
		{
			sound (self, CHAN_BODY, "misc/uwater.wav", 1, ATTN_NORM);
			self.uwmuffle = TRUE;
		}
	}
	
	if (self.waterlevel == 2)// head out, stop muffle
	{	
		if (self.outwsound)
		{
			sound (self, CHAN_BODY, "misc/owater2.wav", 1, ATTN_NORM);
			self.outwsound = FALSE;
			self.uwmuffle = FALSE;
			self.inwsound = TRUE;
		}
	}
	// pOx - END - Swimming Sounds
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);

	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);

		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net

			return;
		}
	}
};


/*================
PlayerPreThink

Called every frame before physics are run
================*/
void() PlayerPreThink =
{

// 2001-09-10 FrikBot support by FrikaC  start
	if (BotPreFrame())
		return;
// 2001-09-10 FrikBot support by FrikaC  end

	if (intermission_running)
	{
// 1998-12-24 Palette shift during intermission fix by Maddes  start
		self.items = self.items - (self.items &
		(IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
// 1998-12-24 Palette shift during intermission fix by Maddes  end
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

// 2000-07-14 Client's viewpoint not updated when has no model fix by Raymond Martineau  start
	if (self.modelindex == 0)
	{
		local float bits;

		msg_entity = self;
		bits = 128 + 32 + 1024 + 2 + 4 + 8;	// U_SIGNAL + U_NOLERP + U_MODEL + U_ORIGIN1 + U_ORIGIN2 + U_ORIGIN3
		WriteByte (MSG_ONE,bits);
		WriteByte (MSG_ONE,1);   // The model
		WriteCoord (MSG_ONE, self.origin_x);
		WriteCoord (MSG_ONE, self.origin_y);
		WriteCoord (MSG_ONE, self.origin_z);
	}
// 2000-07-14 Client's viewpoint not updated when has no model fix by Raymond Martineau  end

	makevectors (self.v_angle);		// is this still used
	// pOx - START - func_water & func_ladder support
	// Set cshift back to normal if eyes are out of func_water
	if (self.fwatershifttime < time) {
		if (self.fwatershift) {
			stuffcmd(self, "v_cshift 130 80 50 0\n");
			self.fwatershift = FALSE;
		}
	}
	// Both func_water and func_ladder require zero G to work properly.
	// Lucky for us, the Mission Pack build of Quake has a gravity modifier we can exploit.
	if (self.zerogtime < time)
		self.gravity = self.oldgravity;// reset normal gravity
	else
		self.gravity = 0.0001;// zero G (0 OR 1 is normal)
	// pOx - END  - func_water & func_ladder support

	self.deathtype = "";	// 1998-07-24 Wrong obituary messages fix by Zoid

//	CheckRules ();		// 2000-07-15 Restructured fraglimit and timelimit by Maddes
	WaterMove ();

	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING) {
		CheckFuncWaterDeath();// pOx - check cshift for dead players in func_water
		return;	// dying, so do nothing
	}

	if (self.button2)
	{
		PlayerJump ();
	}

	else
		self.flags = self.flags | FL_JUMPRELEASED;

	// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	if(time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};
	
/*================
CheckPowerups

Check for turning off powerups
================*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

	// invisibility
	if (self.invisible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
			self.modelindex = modelindex_player;	// 1998-07-23 Better performance in handling of powerups by Maddes
								// don't use eyes
			SetSkin(self);				// 1997-12-30 skin support by Maddes
		}
// 1998-07-23 Better performance in handling of powerups by Maddes  start
/*
	// use the eyes
		self.frame = 0;
		SetSkin(self);					// 1997-12-30 skin support by Maddes
		self.modelindex = modelindex_eyes;
*/
// 1998-07-23 Better performance in handling of powerups by Maddes  end
	}
// 1998-07-23 Better performance in handling of powerups by Maddes  start
/*
	else
	{
		self.modelindex = modelindex_player;	// don't use eyes
		SetSkin(self);				// 1997-12-30 skin support by Maddes
	}
*/
// 1998-07-23 Better performance in handling of powerups by Maddes  end

	// invincibility
	if (self.invincible_finished)
	{
	// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
// 1998-07-23 Better performance in handling of powerups by Maddes  start
			if (!self.super_damage_finished)
				self.effects = self.effects - (self.effects & EF_DIMLIGHT);
// 1998-07-23 Better performance in handling of powerups by Maddes  end
		}
// 1998-07-23 Better performance in handling of powerups by Maddes  start
/*
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;

		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
*/
// 1998-07-23 Better performance in handling of powerups by Maddes  end
	}

	// super damage
	if (self.super_damage_finished)
	{

		// sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
				if (deathmatch == 4)
					sprint (self, "OctaPower is wearing off\n");
				else
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
				sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
// 1998-07-23 Better performance in handling of powerups by Maddes  start
			if (!self.invincible_finished)
				self.effects = self.effects - (self.effects & EF_DIMLIGHT);
// 1998-07-23 Better performance in handling of powerups by Maddes  end
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
			if (deathmatch == 4)
			{
				if (!axeonly)		//axe only match
					self.ammo_cells = 255;
				self.armorvalue = 0;
				self.armortype = 0;
				self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
			}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		}
// 1998-07-23 Better performance in handling of powerups by Maddes  start
/*
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;

		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
*/
// 1998-07-23 Better performance in handling of powerups by Maddes  end
	}	

	// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

		// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
			SetSkin(self);				// 1998-01-04 event skin support by Maddes
		}
	}	

};

// 1999-10-22 Improved non-weapon-related impulses by Maddes  start
// do non-weapon stuff
void() ImmediateImpulseCommands =
{
	local float	value;
	local string	text;

// 1997-12-30 skin support by Maddes  start
	if (self.impulse == IMPULSE_SKIN_NEXT)	// Impulse to select next skin
	{
		ChangeSkin(self, 1);
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_SKIN_PREV)	// Impulse to select previous skin
	{
		ChangeSkin(self, -1);
	}
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_EVENT_SKINS)
	{
		if (!deathmatch)
{
			value = savedgamecfg & SAVEDGAMECFG_EVENT_SKINS;
			if (value)
				savedgamecfg = savedgamecfg - value;
			else
				savedgamecfg = savedgamecfg | SAVEDGAMECFG_EVENT_SKINS;

			text = ftos(savedgamecfg);
			cvar_set("savedgamecfg",text);
		
			PlayerSkinInfo();	// 1999-02-02 Enhanced info system by Maddes
		}
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_SKINS_MORE)
	{
		if (!deathmatch)
		{
			value = (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_SKIN_NUMBERS_BIT1;
			if (value<SAVEDGAMECFG_SKIN_NUMBERS_MAX)
			{
				value = value + 1;
				savedgamecfg = savedgamecfg - (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) + (value * SAVEDGAMECFG_SKIN_NUMBERS_BIT1);

				text = ftos(savedgamecfg);
				cvar_set("savedgamecfg",text);
			}
			else
	{
				sprint(self, "No more than ");
				text = ftos(SAVEDGAMECFG_SKIN_NUMBERS_MAX+1);
				sprint(self, text);
				sprint(self, " player skins are supported\n");
			}
	
			PlayerSkinInfo();	// 1999-02-02 Enhanced info system by Maddes
		}
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_SKINS_LESS)
	{
		if (!deathmatch)
		{
			value = (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_SKIN_NUMBERS_BIT1;
			if (value>0)
		{
				value = value - 1;
				savedgamecfg = savedgamecfg - (savedgamecfg & SAVEDGAMECFG_SKIN_NUMBERS_BITS) + (value * SAVEDGAMECFG_SKIN_NUMBERS_BIT1);

				text = ftos(savedgamecfg);
				cvar_set("savedgamecfg",text);
		}
	
		else
			{
				sprint(self, "One player skin must be present\n");
			}

		self.jump_flag = 0;
			PlayerSkinInfo();	// 1999-02-02 Enhanced info system by Maddes
		}

	}
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
// 1997-12-30 skin support by Maddes  end

// 1997-12-26 auto-aim toggle by Maddes  start
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_TOGGLE_AIM)	// Impulse to toggle auto-aim on/off
	{
		self.autoaim_off = 1 - self.autoaim_off;

		AutoAimInfo();	// 1999-02-02 Enhanced info system by Maddes
	}
// 1997-12-26 auto-aim toggle by Maddes  end

// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_MONSTER_SKINS_RANDOM)
	{
		if (!deathmatch)
		{
			value = savedgamecfg & SAVEDGAMECFG_MONSTER_RANDOM_SKINS;
			if (value)
				savedgamecfg = savedgamecfg - value;
			else
				savedgamecfg = savedgamecfg | SAVEDGAMECFG_MONSTER_RANDOM_SKINS;

			text = ftos(savedgamecfg);
			cvar_set("savedgamecfg",text);

			MonsterSkinInfo();	// 1999-02-02 Enhanced info system by Maddes
		}
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_MONSTER_SKINS_MORE)
	{
		if (!deathmatch)
		{
			value = (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1;
			if (value<SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_MAX)
			{
				value = value + 1;
				savedgamecfg = savedgamecfg - (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) + (value * SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1);

				text = ftos(savedgamecfg);
				cvar_set("savedgamecfg",text);
			}
			else
			{
				sprint(self, "No more than ");
				text = ftos(SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_MAX+1);
				sprint(self, text);
				sprint(self, " monster skins are supported\n");
			}

			MonsterSkinInfo();	// 1999-02-02 Enhanced info system by Maddes
		}
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_MONSTER_SKINS_LESS)
	{
		if (!deathmatch)
		{
			value = (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1;
			if (value>0)
			{
				value = value - 1;
				savedgamecfg = savedgamecfg - (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) + (value * SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1);

				text = ftos(savedgamecfg);
				cvar_set("savedgamecfg",text);
			}
			else
			{
				sprint(self, "One monster skin must be present\n");
			}

			MonsterSkinInfo();	// 1999-02-02 Enhanced info system by Maddes
		}
	}


// 1999-02-02 Enhanced info system by Maddes  start
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_CLIENT_INFO)
	{
		ClientInfo();
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_SERVER_INFO)
	{
		ServerInfo();
	}
// 1999-02-02 Enhanced info system by Maddes  end

// 1999-02-20 Functions to locate map bugs by Maddes  start
#ifdef DEBUG_MAPS
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_PLAYER_POSITION)
	{
		if (developer)
		{
			PrintPosition();
		}
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_LIVING_MONSTERS)
	{
		if (developer)
		{
			PrintNearMonsters();
		}
	}
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_TRIGGER_VISIBILITY)
	{
		if (developer)
		{
			ToggleTriggerVisibility();
		}
	}
#endif
// 1999-02-20 Functions to locate map bugs by Maddes  end

// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes
#ifdef DEBUG_SHOTS
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_DEBUG_SHOTS)
	{
		if (developer)
		{
			// modify all players
			value = time + 5;	// one fixed time for all
			thing = find (world, classname, "player");
			while (thing != world)
			{
				thing.health = 1;		// not necessary
				thing.ammo_shells = 10;		// not necessary
				thing.attack_finished = value;
				thing = find (thing, classname, "player");
			}

			// create counter entitiy
			thing = spawn();
			thing.classname = "debug_shots";
			thing.netname = "Shots";
			thing.count = 0;
			thing.think = DebugShowCounter;
			thing.nextthink = value + 0.2;
		}
	}
#endif
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes

// 2000-07-14 Debug function for client view bug by Maddes  start
#ifdef DEBUG_CLIENTVIEW
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == IMPULSE_DEBUG_CLIENTVIEW)
	{
		if (developer)
		{
			if (self.modelindex != 0)
			{
				self.modelindex = 0;
			}
			else
			{
				if (self.invisible_finished)
				{
					self.modelindex = modelindex_eyes;
				}
				else
				{
					self.modelindex = modelindex_player;
				}
			}
		}
	}
#endif
// 2000-07-14 Debug function for client view bug by Maddes  end

	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
		return;		// maybe a weapon impulse

	self.impulse = 0;	// clear non-weapon impulse
};
// 1999-10-22 Improved non-weapon-related impulses by Maddes  end

/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
void() PlayerPostThink =
{
if (BotPostFrame()) // FrikBot
		return;

// pOx - Advance frame based entities (noclip)
	SUB_PushFrameMovers();
	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

// 1999-06-03 Resume function by Jim Steers/Maddes  start
	if (deathmatch && resume && (time >= self.cnt))
	{
		UpdateResume();
		self.cnt = time + 0.5;		// update every half second
	}
// 1999-06-03 Resume function by Jim Steers/Maddes  end

	if (self.deadflag)
		return;

// 1999-10-22 Improved non-weapon-related impulses by Maddes  start
// do non-weapon stuff
	if (self.impulse)
		ImmediateImpulseCommands();
// 1999-10-22 Improved non-weapon-related impulses by Maddes  end

// do weapon stuff
	W_WeaponFrame ();

// check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		// pOx - commented this out (PreThink handles water sounds)
		/*if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else*/ if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5);
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();

// 1997-12-24 Message on respawn by Maddes  start
	if (self.spawn_info)			// time set?
	{
		if (self.spawn_info <= time)	// print after time is reached
		{
			self.spawn_info = 0;	// clear time

			ClientInfo();		// 1999-02-02 Enhanced info system by Maddes
		}
	}
// 1997-12-24 Message on respawn by Maddes  end

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();
};


/*===========
ClientConnect

called when a player connects to a server
============*/
void() ClientConnect =
{
	ClientInRankings();	// 2001-09-10 FrikBot support by FrikaC

	bprint (self.netname);
// 1999-06-03 Resume function by Jim Steers/Maddes  start
	if ( CheckResume() )
	{
		bprint (" re-entered the game with ");
		bprint (ftos(self.frags));
		bprint (" frag");
		if (self.frags == 1)
			bprint("\n");
		else
			bprint("s\n");

		self.cnt = time + 0.5;		// update every half second
	}
	else
// 1999-06-03 Resume function by Jim Steers/Maddes  end
	bprint (" entered the game\n");

	// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
	self.spawn_info = time + 1;		// 1997-12-24 Message on respawn by Maddes
						//            wait some seconds so client is ready and player can read the message
};


/*===========
ClientDisconnect

called when a player disconnects from a server
============*/
void() ClientDisconnect =
{
	ClientDisconnected();	// 2001-09-10 FrikBot support by FrikaC

	if (gameover)
		return;

	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
// 1998-12-24 Incorrect frag sentence when a player disconnects fix by Maddes  start
	if (self.frags == 1)
		bprint (" frag\n");
	else
// 1998-12-24 Incorrect frag sentence when a player disconnects fix by Maddes  end
	bprint (" frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);

// 1999-08-30 Ghost eyes and hovering bodies fix by FrikaC/Maddes  start
	if (self.modelindex == modelindex_eyes)
		setmodel(self, "progs/player.mdl");
	self.skin = self.skin_selected;		// 1997-12-30 skin support by Maddes

	self.items = self.items - (self.items &
	(IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );

	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.effects = 0;
// 1999-08-30 Ghost eyes and hovering bodies fix by FrikaC/Maddes  end

	set_suicide_frame ();

// 1999-08-30 Ghost eyes and hovering bodies fix by FrikaC/Maddes  start
	CopyToBodyQueue(self);	// make a copy of the dead body for appearances sake
	setmodel(self, string_null);
// 1999-08-30 Ghost eyes and hovering bodies fix by FrikaC/Maddes  end

// 2000-07-16 Entity of disconnecting client not initialized fix by Maddes  start
	self.classname = string_null;
	self.health = 0;
// 2000-07-16 Entity of disconnecting client not initialized fix by Maddes  end
};

/*===========
ClientObituary

called when a player dies
============*/
void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;
	deathstring = deathstring2 = "";
	// From GPL QW source
	local   float  attackerteam, targteam;	// gb
	
	// gb
	attackerteam = attacker.team;
	targteam = targ.team;

	rnum = random();

// 1997-12-30 skin support by Maddes/Zhenga  start
	if (targ.classname == "monster_oldone")
	{
		if (attacker.owner)
			ShubKiller = attacker.owner;
	}
// 1997-12-30 skin support by Maddes/Zhenga  end

	if (targ.classname == "player")
	{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
		if (targ.deathtype == "selfwater")
		{
			bprint (targ.netname);
			bprint (" electrocutes himself.\n");
			targ.frags = targ.frags - 1;
			return;
		}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			attacker.owner.frags = attacker.owner.frags + 1;

			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - 1;
			return;
		}

// 1998-07-26 Pentagram telefrag fix by Zoid/Maddes  start
		// double 666 telefrag
		// (can happen often in deathmatch 4 and levels with more than one pentagram)
		if (attacker.classname == "teledeath3")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("'s Satan's power\n");
// 1998-07-26 only telefrag player on spot by Maddes  start
//			targ.frags = targ.frags - 1;
			attacker.owner.frags = attacker.owner.frags + 1;
// 1998-07-26 only telefrag player on spot by Maddes  end
			return;
		}
// 1998-07-26 Pentagram telefrag fix by Zoid/Maddes  end

// 1998-07-24 Wrong obituary messages fix by Zoid  start
		if (targ.deathtype == "squish")
		{
			if (teamplay && targ.team == attacker.team && targ != attacker)
			{
				attacker.frags = attacker.frags - 1;
				bprint (attacker.netname);
				bprint (" squished a teammate\n");
				return;
			}
			else if (attacker.classname == "player" && targ != attacker)
			{
				bprint (attacker.netname);
				bprint (" squishes ");
				bprint (targ.netname);
				bprint ("\n");
				attacker.frags = attacker.frags + 1;
				return;
			}
			else
			{
				targ.frags = targ.frags - 1;            // killed self
				bprint (targ.netname);
				bprint (" was squished\n");
				return;
			}
			return;
		}
// 1998-07-24 Wrong obituary messages fix by Zoid  end

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - 1;
				bprint (targ.netname);
				
// 1998-08-10 Player drops backpack on suicide by Maddes  start
				if (targ.deathtype == "suicide")
				{
					attacker.frags = attacker.frags - 1;	// extra penalty
					bprint (" suicides\n");
					return;
				}
// 1998-08-10 Player drops backpack on suicide by Maddes  end

// 1998-07-24 Wrong obituary messages fix by Zoid  start
				if (targ.deathtype == "grenade")
				{
					bprint (" tries to put the pin back in\n");
					return;
				}
				else if (targ.deathtype == "rocket")
				{
					// 1998-07-24 enhanced obituary messages by Maddes  start
					if (targ.health < -40)
						bprint (" explodes with his own rocket\n");
					else
						bprint (" dies through his own rocket\n");
					// 1998-07-24 enhanced obituary messages by Maddes  end
					return;
				}
				else
// 1998-07-24 Wrong obituary messages fix by Zoid  end
				if (targ.weapon == IT_LIGHTNING && targ.waterlevel > 1)
				{
// 1998-07-24 Wrong obituary messages fix by Zoid  start
					if (targ.watertype == CONTENT_SLIME)
						bprint (" discharges into the slime\n");

					else if (targ.watertype == CONTENT_LAVA)
						bprint (" discharges into the lava\n");

					else
// 1998-07-24 Wrong obituary messages fix by Zoid  end
						bprint (" discharges into the water.\n");

					return;
				}
// 1998-07-24 Wrong obituary messages fix by Zoid  start
//				if (targ.weapon == IT_GRENADE_LAUNCHER)
//					bprint (" tries to put the pin back in\n");
//				else
// 1998-07-24 Wrong obituary messages fix by Zoid  end
					bprint (" becomes bored with life\n");
				return;
			}
			else if ( (teamplay == 2) && (targteam == attackerteam) &&
				(attackerteam != 0) )	// gb
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";

				else if (rnum < 0.50)
					deathstring = " checks his glasses\n";

				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";

				else
					deathstring = " loses another friend\n";

				bprint (attacker.netname);
				bprint (deathstring);
				attacker.frags = attacker.frags - 1;
				return;
			}

			else
			{
				attacker.frags = attacker.frags + 1;

				rnum = attacker.weapon;
// 1998-07-24 Wrong obituary messages fix by Zoid  start
				if (targ.deathtype == "nail")
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "supernail")
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				else if (targ.deathtype == "grenade")
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";

					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				else if (targ.deathtype == "rocket")
				{
					if (attacker.super_damage_finished > 0 && targ.health < -40)
					{
						rnum = random();

						if (rnum < 0.3)
							deathstring = " was brutalized by ";

						else if (rnum < 0.6)
							deathstring = " was smeared by ";

						else
						{
							bprint (attacker.netname);
							bprint (" rips ");
							bprint (targ.netname);
							bprint (" a new one\n");

							return;
						}
						deathstring2 = "'s quad rocket\n";
					}

					else
					{
						deathstring = " rides ";
						deathstring2 = "'s rocket\n";

						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
							deathstring2 = "'s rocket\n" ;
						}
					}
				}
				else
// 1998-07-24 Wrong obituary messages fix by Zoid  end
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				else	// 1998-07-24 Wrong obituary messages fix by Zoid
				if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				else	// 1998-07-24 Wrong obituary messages fix by Zoid
				if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
// 1998-07-24 Wrong obituary messages fix by Zoid  start
//				if (rnum == IT_NAILGUN)
//				{
//					deathstring = " was nailed by ";
//					deathstring2 = "\n";
//				}
//				if (rnum == IT_SUPER_NAILGUN)
//				{
//					deathstring = " was punctured by ";
//					deathstring2 = "\n";
//				}
//				if (rnum == IT_GRENADE_LAUNCHER)
//				{
//					deathstring = " eats ";
//					deathstring2 = "'s pineapple\n";
//					if (targ.health < -40)
//					{
//						deathstring = " was gibbed by ";
//						deathstring2 = "'s grenade\n";
//					}
//				}
//				if (rnum == IT_ROCKET_LAUNCHER)
//				{
//					deathstring = " rides ";
//					deathstring2 = "'s rocket\n";
//					if (targ.health < -40)
//					{
//						deathstring = " was gibbed by ";
//						deathstring2 = "'s rocket\n" ;
//					}
//				}
				else
// 1998-07-24 Wrong obituary messages fix by Zoid  end
				if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";

					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge\n";

					else
						deathstring2 = "'s shaft\n";
				}

				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				bprint (deathstring2);
			}
			return;
		}
		else
		{
			targ.frags = targ.frags - 1;
			bprint (targ.netname);

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" blew up\n");
				return;
			}
// 1998-07-24 Wrong obituary messages fix by Zoid  start
			if (targ.deathtype == "falling")
			{
				bprint (" fell to his death\n");
				return;
			}
/*
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint (" was squished\n");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (" was spiked\n");
				return;
			}
*/
			if (targ.deathtype == "nail" || targ.deathtype == "supernail")
			{
				bprint (" was spiked\n");
				return;
			}
			if (targ.deathtype == "laser")
			{
				bprint (" was zapped\n");
				return;
			}
// 1998-07-24 Wrong obituary messages fix by Zoid  end
			if (attacker.classname == "fireball")
			{
				bprint (" ate a lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the fishes\n");

				else
					bprint (" sucks it down\n");

				return;
			}

			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");

				else
					bprint (" can't exist on slime alone\n");

				return;
			}

			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}

				if (random() < 0.5)
					bprint (" turned into hot slag\n");

				else
					bprint (" visits the Volcano God\n");

				return;
			}

			if (attacker.solid == SOLID_BSP && attacker != world)
			{	
				bprint (" was squished\n");
				return;
			}

// 1998-07-24 Wrong obituary messages fix by Zoid  start
/*
			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" fell to his death\n");
				return;
			}
*/
// 1998-07-24 Wrong obituary messages fix by Zoid  end

			// killed by a monster?
			//FIXME string_nul ??? maybe not necessary	//gnounc
			if(attacker.killstring)
			{//gnounc
				bprint (attacker.killstring);
				return;
			}
			// pOx - START - allow custom death messages for emitters
			if (attacker.classname == "particle")
			{
				if (attacker.owner.message) {
					bprint (" ");
					bprint (attacker.owner.message);
					bprint ("\n");
				}
				else
					bprint (" died\n");
				
				return;
			}
			// pOx - END - allow custom death messages for emitters

			// hell if I know; he's just dead!!!
			bprint (" died\n");
		}
	}
};
