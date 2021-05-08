
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void() Script_play;	//dhm - prototype
void() go_back;		//dhm - prototype
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float	modelindex_eyes, modelindex_player;

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

float	intermission_running;
float	intermission_exittime;

//----------------------------------------------------/ New Code /--------//
// This checks if an intermission is running.
float() PM_Intermission =
{
    return intermission_running;
};
//------------------------------------------------------------------------//

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
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
	(IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD) );
	
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
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
//----------------------------------------------------/ New Code /--------//
    parm10 = self.petflags - (self.petflags &
        (PET_READY | PET_STAY | PET_PATROL | PET_FORCED));
//------------------------------------------------------------------------//
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
//----------------------------------------------------/ New Code /--------//
    parm10 = 0;             // Players start with no dragon.
	serverflags = serverflags & 15;
//------------------------------------------------------------------------//
};

void() DecodeLevelParms =
{
	if (serverflags)
	{
		if (world.model == "maps/start.bsp" || world.model == "maps/soe.bsp" || world.model == "maps/soe2m1.bsp")
		{
			serverflags = serverflags & 15;
			SetNewParms ();		// take away all stuff on starting new episode
		}
	}
	if (world.model == "maps/soe2m1.bsp")
		SetNewParms();
	
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
//----------------------------------------------------/ New Code /--------//
    self.petflags = parm10;

    // Check if dragon can cross over to this level.
    if (self.petflags & PET_ALIVE)
        PM_CarryPetDragon ();
//------------------------------------------------------------------------//
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
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
};


string nextmap;
void() GotoNextMap =
{
//----------------------------------------------------/ New Code /--------//
    // If player has a dragon, make sure one of them is taken with him.
    PM_AutoPromote ();
//------------------------------------------------------------------------//

// SoE: Map change is hardwired
	local float i;
	i = cvar("temp1");

	if (i && nextmap == "start")
		cvar_set("temp1", "0");

	if (i == 1 || deathmatch)
	{
		if (mapname == "start" || mapname == "soe")
			nextmap = "soedm1";
		else if (mapname == "soedm1")
			nextmap = "soedm2";
		else if (mapname == "soedm2")
			nextmap = "soedm3";
		else if (mapname == "soedm3")
			nextmap = "soedm4";
		else if (mapname == "soedm4")
			nextmap = "soedm5";
		else if (mapname == "soedm5")
			nextmap = "soedm6";
		else if (mapname == "soedm6")
			nextmap = "soedm1";
		else if (mapname == "soe1m1")
			nextmap = "soe1m2";
		else if (mapname == "soe1m2")
			nextmap = "soe1m3";
		else if (mapname == "soe1m3")
			nextmap = "soe1m4";
		else if (mapname == "soe1m4")
			nextmap = "soe1m5";
		else if (mapname == "soe1m5")
			nextmap = "soe1m6";
		else if (mapname == "soe1m6")
			nextmap = "soe2m1";
		else if (mapname == "soe2m1")
			nextmap = "soe2m2";
		else if (mapname == "soe2m2")
			nextmap = "soe2m3";
		else if (mapname == "soe2m3")
			nextmap = "soe2m4";
		else if (mapname == "soe2m4")
			nextmap = "soe2m5";
		else if (mapname == "soe2m5")
			nextmap = "soe2m6";
		else if (mapname == "soe2m6")
			nextmap = "soe2m7";
		else if (mapname == "soe2m7")
			nextmap = "start";
	}
	if (cvar("samelevel"))	// if samelevel is set, stay on same level
		changelevel (mapname);
	else
		changelevel (nextmap);
};


void() ExitIntermission =
{
	local float i;
	i = cvar("temp1");
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
		else if (world.model == "maps/demoend.bsp" || world.model == "maps/soedemo3.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "You've just completed the preview release\nof Soul Of Evil. We released this to hold\nover fans who've had to suffer during the\nnearly year-long development period, and\nmore importantly, so that we could recieve\nmajor feedback prior to the full release.\n\nWe want your opinions! Please email any\nquestions, comments, bug finds, or anything\nelse remotely Quake or SoE related, to\nnetgames@netdp.com. If you are interested\nin becoming a tester for the full SoE\nproject you can email the same address\nabout that.");
			return;
		}
		else if (world.model == "maps/soe1m5.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "As the warlord Bane's twisted body falls\nwith the clang of steel into the autumn\nleaves, a sense of closure engulfs you.\nYour quest here is done; the land is\nsafe from his dire power and brutality.\nBecause of you, this world is free and\nthe people here can emerge from hiding\nand try to rebuild their lives.\nYet you know that one liberation is\nnot enough; the evil behind the Bane\nis infinite, and continually manifests\nitself in many worlds. Bane came\nfrom somewhere, and one dimension is as\ngood as any other.\nIt seems like a thousand years ago, you\ntook the fight away from Earth and to an\nenemy codenamed Quake. Having found the\nhidden portal the Bane must have used\nto gain his hold on this world, it is\nlikely that you are now able to reach\nwherever he came from, and punish those\nresponsible for sending him here.");
			return;
		}
		else if (world.model == "maps/soe2m6.bsp")
		{
			if (serverflags & 32)
			{
				WriteByte (MSG_ALL, SVC_CDTRACK);
				WriteByte (MSG_ALL, 2);
				WriteByte (MSG_ALL, 3);
	
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "You have failed to destroy the Shalrath\nCult-Lord, and his hideous plans have\ncome to full realization. The Cult Lord\nhas become a god, a god of death. His\nunholy combination of two of the three\nartifacts the Elders left to these\nuniverses has made him immortal, invincible,\nand unstoppable. These artifacts were to\nremain as widely seperated as possible,\nin different dimensions, universes, spaces,\ntimes. But the Cult Lord twisted the\nuniverses through his unspeakable magics\nand now, because you let him live, he has\ndone what no being ever should have done.");
			}
			else
			{
				WriteByte (MSG_ALL, SVC_CDTRACK);
				WriteByte (MSG_ALL, 2);
				WriteByte (MSG_ALL, 3);

				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "The Cult Lord's corpse bursts into its\ncomponent atoms as you break his spell\nand destroy the being. The Cult Lord\nhoped to become invincible; a God, by\nmanifesting two artifacts at once and\nobtaining the power of both. He would\nhave become the unstoppable scourge of\nmany worlds, your own among them,\nwere it not for your actions.\n\nThe Shalrath Cult, through the Bane,\nobtained a foothold on the last world\nyou visited. Now, with their leader gone\nand the Cult's heart ripped out, these\ndisciples of Quake's Evil will no longer\npose a threat to any human world for a\nvery, very long time.");
			}
			return;
		}
		else if (world.model == "maps/soeexit.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Soul Of Evil was created by the\nfollowing individuals:\n\nDustin 'Tronyn' Geeraert: Project Lead\nRob 'Fat Controller' Cruickshank: QuakeC\nTravis 'Skunk' Peterson: Website, Maps\nRich 'XeNoN' Thorne: Maps\nDean 'Rotpig' Turner: Maps\nDylan 'Lithiumbat' Sartain: Skins\nDavid Laurie: Maps\n\nWe hope you have enjoyed SOE. See the\ncredits section in the readme for more\ndetailed credits and for the\nacknowledgement of all those whose\nstuff was included herein...");
			return;
		}
		else if (world.model == "maps/soedm6.bsp" && (i == 1))
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "You have completed Soul Of Evil: Arena!\nYou have destroyed hundreds of monsters\nand defeated six dragons.\n\nCongratulations. Soul Of Evil: Arena is\nbased on DMSP by Wouter van Oortmerssen\n(http://wouter.fov120.com).\n\nOur thanks to Wouter for letting us use\nhis code and we hope you have enjoyed\nSoul Of Evil's arena mode.");
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
		else if (world.model == "maps/demoend.bsp" || world.model == "soedemo3.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "We have started to update the web site again,\nso you can check\nhttp://www.planetquake.com/tronyn/soul\nfor SoE-related news and information.");
			return;
		}
		else if (world.model == "maps/soe2m6.bsp" && !(serverflags & 32))
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "As a hero of hundreds of worlds and as\nmany names, and a tireless warrior, you\nfear not man, beast or devil; you have\nbested all three. But you cannot help\nbut hope that one day, a gate such as\nthe one in front of you will lead you\nback home, and to all that you left\nbehind...");
			return;
		}
		
	}

	GotoNextMap();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
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
	local float i;
	i = cvar("temp1");

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
//----------------------------------------------------/ New Code /--------//
        PM_KillFire (other);
//------------------------------------------------------------------------//
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);

		//SoE: play nice dreamy musick in DMSP
		if (i == 1)
			sound(other, CHAN_AUTO, "misc/pkdream.wav", 1, ATTN_NORM);

		//SoE: if a sound is specified, play it
		else if (self.noise)
			sound(other, CHAN_AUTO, self.noise, 1, ATTN_NORM);

		other = find (other, classname, "player");
	}	
//----------------------------------------------------/ New Code /--------//
    PM_ExitAllPets ();
//------------------------------------------------------------------------//

	WriteByte (MSG_ALL, SVC_INTERMISSION);
};


void() changelevel_touch =
{
	local entity	pos;

	if (other.classname != "player")
		return;

//SoE: DMSP mode is activated by setting serverflag 16.
	if ((self.spawnflags & 16) == 16)
		cvar_set("temp1", "1");
	if ((self.spawnflags & 8) == 8)
		cvar_set("temp1", "0");

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		bprint (other.netname);
		bprint (" exited the level\n");
	}
	
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

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION x x DMSP NO_DMSP
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
If spawnflag 16 is set, DMSP mode is activated.
If spawnflag 8 is set, DMSP mode is deactivated.
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("chagnelevel trigger doesn't have map");

	if (self.noise)
		precache_sound(self.noise);
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
//----------------------------------------------------/ New Code /--------//
    // Kill the client's dragons if they are alive.
    PM_KillAllPets (self, FALSE);

    // Remove resupply restrictions.
    PM_AllowResupply (self);
//------------------------------------------------------------------------//

	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// set default spawn parms
		SetNewParms ();
		// respawn		
		PutClientInServer ();
	}
	else
	{	// restart the entire server
		localcmd ("restart\n");
	}
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	self.frags = self.frags - 2;	// extra penalty
	respawn ();
};

float(vector v) CheckSpawnPoint =
{
	return FALSE;
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() SelectSpawnPoint =
{
	local	entity spot;
	local	entity thing;
	local	float  pcount;
	
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
	else if (deathmatch || (cvar("temp1") == 1))
	{
		spot = lastspawn;
		while (1)
		{
			spot = find(spot, classname, "info_player_deathmatch");
			if (spot != world)
			{
				if (spot == lastspawn)
					return lastspawn;
				pcount = 0;
				thing = findradius(spot.origin, 32);
				while(thing)
				{
					if (thing.classname == "player")
						pcount = pcount + 1;
					thing = thing.chain;
				}
				if (pcount == 0)
				{
					lastspawn = spot;
					return spot;
				}
			}
		}
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

/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;


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
  /* =========================================== */
  /* |  script_count is used for script timing | */
  /* =========================================== */
	self.script_count = 2;
	self.script_delay = 1;
	self.script_time = 0;
	self.diseased = 0;

//----------------------------------------------------/ New Code /--------//
// PM:  Make sure deathtype string is clear.
    self.deathtype = string_null;

// PM:  Napalm/Dragons code -- make sure no fire is burning on the player.
    PM_KillFire (self);
//------------------------------------------------------------------------//

	DecodeLevelParms ();
	
	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
//	spot = SelectSpawnPoint ();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';
//----------------------------------------------------/ New Code /--------//
    self.velocity = '0 0 0';    // From Zer; hold still.
//------------------------------------------------------------------------//
	player_stand1 ();
	
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
//----------------------------------------------------/ New Code /--------//
        // Give three second invulnerability in DM.
        if (deathmatch)
        {
            self.items = self.items | IT_INVULNERABILITY;
            self.invincible_finished = time + 3;
            self.invincible_time = time + 1;
        }
//------------------------------------------------------------------------//
	}

	spawn_tdeath (self.origin, self);
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
	local float i;
	i = cvar("temp1");

//----------------------------------------------------/ New Code /--------//
    // Similar to the Q2 coop hack, the player start entity is used to
    // add dragons into most of the original levels in Quake.
    if (PM_InvokeHack ())
    {
        PM_PrecacheHack();
        self.think = PM_DragonHack;
        self.nextthink = time + 0.1;
	}
//------------------------------------------------------------------------//
// SoE: DMSP stuff
	if (i == 1)
	{
		self.cnt = 10;
		DMSP_countdown();
	}
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
//SoE: DMSP stuff
	DMSP_checkSpawnSize();
	self.netname = "dmsp_spawn";
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
	if (!cvar("coop"))
		remove(self);
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
only called if a time or frag limit has expired
*/
void() NextLevel =
{
	local entity o;

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

		// go back to start if no trigger_changelevel
		if (!o)
		{
			mapname = "start";
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;
	gameover = TRUE;
	
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{
	local	float		timelimit;
	local	float		fraglimit;
	
	if (gameover)	// someone else quit the game already
		return;
		
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	
	if (timelimit && time >= timelimit)
	{
		NextLevel ();
		return;
	}
	
	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel ();
		return;
	}	
};

//============================================================================

void() PlayerDeathThink =
{
	local entity	old_self;
	local float		forward;

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

// SoE: Here we need to place some code so that the player jumps into an intermission
// when he's dead in SOE2M5
	if (world.model == "maps/soe2m5.bsp" && (serverflags & 32))
	{
		nextmap = "soe2m5";
		execute_changelevel();
	}

// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;

	respawn();
};


void() PlayerJump =
{
	local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

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
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.velocity_z = self.velocity_z + 270;
};


/*
===========
WaterMove

============
*/
.float	dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
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


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
	if (BotPreFrame()) // FrikBot
		return;

	local	float	mspeed, aspeed;
	local	float	r;
	local	entity	goback; //DHM

	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
	{
  /* --------------------------------------------
	If we are in camera mode, play the script.
     -------------------------------------------- */
		if (self.impulse == 1 && self.script_count != 1000000)
		{
			self.script_count = 1000000;
			goback = spawn();
			goback.nextthink = time + 3;
			goback.think = go_back;
		}

		if (self.script_count < self.script_delay && self.script_time < time)
			Script_play ();

		return;		// intermission or finale
	}

//	makevectors (self.v_angle);		// is this still used? SOE says "no"

	CheckRules ();
	WaterMove ();

	//SoE: Wetsuit code, altered to work for the biosuit
	if (self.radsuit_finished > time)
	{
		if (self.waterlevel==2)
		{
			self.velocity = self.velocity * 1.25;
		}
		if (self.waterlevel==3)
		{
			self.velocity = self.velocity * 1.5;
		}
	}
	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

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
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

// disease
	if ((self.diseased > 0)&&(self.disease_time < time))
	{
		self.disease_time = time + (10 - self.diseased);
		T_Damage (self, world, world, 1);
	}

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
		}
		
	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
		self.modelindex = modelindex_player;	// don't use eyes

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
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
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
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
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
		}
	}	

};


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

	local	float	mspeed, aspeed;
	local	float	r;

	//SoE: Radsuit
	if (self.radsuit_finished > time)
		{
		if (self.waterlevel==2)
			{
			self.velocity = self.velocity * 0.8;
			}
		if (self.waterlevel==3)
			{
			self.velocity = self.velocity * 0.66;
			}
      }

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale
	if (self.deadflag)
		return;
		
// do weapon stuff

	W_WeaponFrame ();

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
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
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
	ClientInRankings(); // FrikBot
	bprint (self.netname);
	bprint (" entered the game\n");
	
// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
if (self.ishuman)
	clientSetFree( self.fClientNo ); // FrikBot

	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

//----------------------------------------------------/ New Code /--------//
    // Kill the client's dragons if they are alive.
    PM_KillAllPets (self, FALSE);
//------------------------------------------------------------------------//

	// let everyone else know
	bprint (self.netname);
	bprint (" left the game with ");
	bprint (ftos(self.frags));
	bprint (" frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame ();
};

/*
===========
ClientObituary

called when a player dies
============
*/
void(entity targ, entity attacker) ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;
	rnum = random();

	if (targ.classname == "player")
	{
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
//----------------------------------------------------/ New Code /--------//
                if (targ.deathtype == "fire")
                {
					if (attacker.classname == "monster_dragon")
					{
						bprint(" was roasted by a ");
						if (attacker.skin == SKIN_RED)
							bprint("red\n");
						else if (attacker.skin == SKIN_GOLD)
							bprint("gold\n");
						bprint (" dragon\n");
					}
					else
	                    bprint (" became toast\n");
                    return;
                }
//------------------------------------------------------------------------//
		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - 1;
				bprint (targ.netname);
				
				if (targ.weapon == 64 && targ.waterlevel > 1)
				{
					bprint (" discharges into the water.\n");
					return;
				}
				if (targ.weapon == IT_GRENADE_LAUNCHER)
					bprint (" tries to put the pin back in\n");
				else
					bprint (" becomes bored with life\n");
				return;
			}
			else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) )
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
//----------------------------------------------------/ New Code /--------//
                if (targ.deathtype == "fire")
                {
                    bprint (targ.netname);
                    bprint (" was cremated by ");
                    bprint (attacker.netname);
                    bprint ("\n");
                    return;
                }
//------------------------------------------------------------------------//

				rnum = attacker.weapon;
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				if (rnum == IT_NAILGUN)
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_SUPER_NAILGUN)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_GRENADE_LAUNCHER)
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				if (rnum == IT_ROCKET_LAUNCHER)
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s rocket\n" ;
					}
				}
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
// (PM):  Score change done below.
			bprint (targ.netname);

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
//----------------------------------------------------/ Code Change /-----//
				if (attacker.classname == "monster_army" || attacker.classname == "dmsp_army")
					bprint (" was shot by a Goblin\n");
                else if (attacker.classname == "monster_demon1" || attacker.classname == "dmsp_demon1")
					bprint (" was eviscerated by a Fiend\n");
                else if (attacker.classname == "monster_dog" || attacker.classname == "dmsp_dog")
					bprint (" fed the wolves\n");
                else if (attacker.classname == "monster_dragon" || attacker.classname == "dmsp_dragon")
                    PM_DragonSlayer (targ, attacker, targ.deathtype);
                else if (attacker.classname == "monster_enforcer" || attacker.classname == "dmsp_enforcer")
					bprint (" was spiked by a Goblin\n");
                else if (attacker.classname == "monster_fish")
					bprint (" was fed to the Rotfish\n");
                else if (attacker.classname == "monster_hell_knight" || attacker.classname == "dmsp_hell_knight")
					bprint (" was slain by a Death Knight\n");
                else if (attacker.classname == "monster_knight" || attacker.classname == "dmsp_knight")
					bprint (" was slashed by a Knight\n");
                else if (attacker.classname == "monster_ogre" || attacker.classname == "dmsp_ogre")
					bprint (" was destroyed by an Ogre\n");
                else if (attacker.classname == "monster_oldone")
					bprint (" became one with Shub-Niggurath\n");
                else if (attacker.classname == "monster_shalrath" || attacker.classname == "dmsp_shalrath")
					bprint (" was exploded by a Vore\n");
                else if (attacker.classname == "monster_shambler" || attacker.classname == "dmsp_shambler")
					bprint (" was smashed by a Shambler\n");
                else if (attacker.classname == "monster_tarbaby" || attacker.classname == "dmsp_tarbaby")
					bprint (" was slimed by a Spawn\n");
                else if (attacker.classname == "monster_wizard" || attacker.classname == "dmsp_wizard")
					bprint (" didn't duck a Drake\n");
                else if (attacker.classname == "monster_zombie" || attacker.classname == "dmsp_zombie")
					bprint (" joins the Zombies\n");

				//CoE monsters
				else if (attacker.classname == "monster_acolyte" || attacker.classname == "dmsp_acolyte")
					bprint (" fell to a mere Acolyte of Ebony\n");
				else if (attacker.classname == "monster_sorceror" || attacker.classname == "dmsp_sorceror")
					bprint (" was bested by an Ebon Sorcerer\n");
				else if (attacker.classname == "monster_warlock" || attacker.classname == "dmsp_warlock")
					bprint (" was no match for an Ebon Warlock\n");
				else if (attacker.classname == "monster_lord" || attacker.classname == "dmsp_lord")
					bprint (" fell before a Hell Lord\n");
				else if (attacker.classname == "monster_bane")
					bprint (" provided sport for The Bane\n");
				else if (attacker.classname == "monster_troglodyte")
					bprint (" succumbed to a Demon Magus\n");
				else if (attacker.classname == "monster_trogboss")
					bprint (" failed to impress the Master\n");
				else if (attacker.classname == "monster_axeman" || attacker.classname == "dmsp_axeman")
					bprint (" was felled by an Axeman\n");

                // Nightshade.
                else if (attacker.classname == "monster_nightshade")
                    bprint (" succumbed to the dark side\n");

                // Don't know what killed him.
                else
                    bprint (" was killed by a monster\n");

                // Change score.  Familiars earn frags for their master.
                if ((attacker.master.classname == "player") && (attacker.master != targ))
                    attacker.master.frags = attacker.master.frags + 1;
                else
                    targ.frags = targ.frags - 1;
//------------------------------------------------------------------------//				if (attacker.classname == "monster_army")

				return;
			}

//----------------------------------------------------/ New Code /--------//
            // Subtract a point from the victim's score.
			targ.frags = targ.frags - 1;

            // Did Chthon kill him?
            if (attacker.classname == "monster_boss")
			{
                bprint (" was cremated by Chthon\n");
				return;
			}
//------------------------------------------------------------------------//

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" was blown up\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{	
				bprint (" was crushed\n");
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
//----------------------------------------------------/ New Code /--------//
                if (attacker.spawnflags & 2)
                {
                    // Shot by laser trap.
                    bprint (" was blasted\n");
                    return;
                }
//------------------------------------------------------------------------//
				bprint (" was spiked\n");
				return;
			}
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

//----------------------------------------------------/ Code Change /-----//
			// fell to their death?
            if (targ.deathtype == "falling")
			{
				bprint (" fell to his death\n");
				return;
			}
            // Burned by fire from an unknown source?
            if (targ.deathtype == "fire")
            {
                bprint (" was incinerated\n");
                return;
            }
//------------------------------------------------------------------------//
			if (self.diseased)
			{
				bprint (" died of the Black Plague\n");
				return;
			}

			bprint (" died of unnatural causes\n");
		}
	}
};
