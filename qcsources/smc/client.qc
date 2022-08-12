
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float	modelindex_eyes, modelindex_player;

/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

// float	intermission_running;	// moved to defs.qc
// float	intermission_exittime;	// moved to defs.qc

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
};

void() DecodeLevelParms =
{
	if (serverflags)
	{
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
	}
	
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;
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
	if (cvar("samelevel"))	// if samelevel is set, stay on same level
		changelevel (mapname);
	else
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

void() intermission_delay =	// for custom CSQC-HUD random intermission camera (by SMITH)
{
	WriteByte (MSG_ALL, SVC_INTERMISSION);
};

void() execute_changelevel =	// edited for custom CSQC-HUD random intermission camera (by SMITH)
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
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		other = find (other, classname, "player");
	}
	self.think = intermission_delay;
	self.nextthink = time + 0.1;	
	//WriteByte (MSG_ALL, SVC_INTERMISSION);		
};

void() changelevel_touch =
{
	if (other.classname != "player")
		return;

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

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/

void() spawn_teleporter_particles_big =
{
	pointparticles(particleeffectnum("teleporter_particles_big"), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;		// weird value, isnt it ?  :)
	self.think = spawn_teleporter_particles_big;
};

void() spawn_slipgate_soak_in_effect =
{
	pointparticles(particleeffectnum("slipgate_soak_in_effect"), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;		// weird value, isnt it ?  :)
	self.think = spawn_slipgate_soak_in_effect;
};

void() spawn_slipgate_soak_in_and_fog =
{
	pointparticles(particleeffectnum("slipgate_soak_in_effect"), self.origin - '0 0 80', '0 0 0', 1); 
	pointparticles(particleeffectnum("slipgate_red_fog_effect"), self.origin, '0 0 0', 1);
	self.nextthink = time + 0.00065;		// weird value, isnt it ?  :)
	self.think = spawn_slipgate_soak_in_and_fog;
};

void() spawn_slipgate_rising_stars_effect =
{
	pointparticles(particleeffectnum("slipgate_rising_stars_effect"), self.origin, '0 0 0', 1); 
	self.nextthink = time + 0.00065;		// weird value, isnt it ?  :)
	self.think = spawn_slipgate_rising_stars_effect;
};

void() spawn_slipgate_red_fog_and_stars =
{
	pointparticles(particleeffectnum("slipgate_rising_stars_effect"), self.origin - '0 0 85', '0 0 0', 1); 
	pointparticles(particleeffectnum("slipgate_red_fog_effect"), self.origin, '0 0 0', 1);
	self.nextthink = time + 0.00065;		// weird value, isnt it ?  :)
	self.think = spawn_slipgate_red_fog_and_stars;
};

void() spawn_slipgate_red_fog_effect =
{
	pointparticles(particleeffectnum("slipgate_red_fog_effect"), self.origin, '0 0 0', 1);
	self.nextthink = time + 0.00065;		// weird value, isnt it ?  :)
	self.think = spawn_slipgate_red_fog_effect;
};

void() spawn_slipgate_red_fog_detection =
{
	traceline (self.origin, self.origin + '0 0 200', FALSE, self);	
	if (trace_fraction == 1.0)
		return;
	else
	{
		local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, trace_endpos);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if ((tex == "+0sliptop") || (tex == "+0slipbot"))
			{
				self.origin = trace_endpos;		// is upper slipgate position
				if (autocvar_teleporter_particles_slipgates == 4)
				{
					spawn_slipgate_soak_in_and_fog ();
					return;
				}
				if (autocvar_teleporter_particles_slipgates == 5)
				{
					spawn_slipgate_red_fog_and_stars ();
					return;
				}

				spawn_slipgate_red_fog_effect();
				return;
			}
			else
				spawn_teleporter_particles_big ();	// cannot find slipgate texture, so use standard effect instead
		}
	}
};


void() select_slipgate_particle_effect =
{
	if (autocvar_teleporter_particles_slipgates == 1)		// "soak in" effect
		spawn_slipgate_soak_in_effect ();
	else if (autocvar_teleporter_particles_slipgates == 2)		// "rising-stars" effect
		spawn_slipgate_rising_stars_effect ();
	else if (autocvar_teleporter_particles_slipgates > 2)		// "red-fog" effect  OR  combination of "red-fog" + "rising-stars"  OR  combination of "red-fog" + "soak in"	// added due to special request at quakeone.com
		spawn_slipgate_red_fog_detection ();
	else
		return;
};

void() trigger_changelevel =
{
	if (!self.map)
		objerror ("chagnelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
	
	local vector o;
	o = (self.mins + self.maxs)*0.5;
	if ((autocvar_teleporter_particles == 2) || (autocvar_teleporter_particles == 3))
	{
		local entity particle_spawner;
		particle_spawner = spawn();	
		if (world.model == "maps/e1m2.bsp")
			particle_spawner.origin = '-720 -500 517';
		else if (world.model == "maps/e1m3.bsp")
			particle_spawner.origin = '1340 1090 580';
		else if ((world.model == "maps/e1m4.bsp") && (self.map == "e1m5"))
			particle_spawner.origin = '1205 1070 1430';
		else if (world.model == "maps/e2m2.bsp")
			particle_spawner.origin = '2180 -180 225';
		else if ((world.model == "maps/e2m3.bsp") && (self.map == "e2m4"))
			particle_spawner.origin = '-740 -324 110';
		else if (world.model == "maps/e2m4.bsp")
			particle_spawner.origin = '-1650 1724 195';
		else if (world.model == "maps/e2m5.bsp")
			particle_spawner.origin = '-1380 2940 -44';
		else if (world.model == "maps/e4m2.bsp")
			particle_spawner.origin = '-1504 250 170';
		else if (world.model == "maps/e4m3.bsp")
			particle_spawner.origin = '-1440 258 175';
		else if (world.model == "maps/e4m4.bsp")
			particle_spawner.origin = '1375 -1488 56';
		else if ((world.model == "maps/e4m5.bsp") && (self.map == "e4m6"))
			particle_spawner.origin = '1248 2535 140';
		else if (world.model == "maps/e4m8.bsp")
			particle_spawner.origin = '2960 1160 217';
		else
			particle_spawner.origin = o;
		particle_spawner.velocity = '0 0 0';
		particle_spawner.movetype = MOVETYPE_NONE;
		particle_spawner.solid = SOLID_NOT;
		setsize (particle_spawner, '0 0 0', '0 0 0');
		particle_spawner.touch = SUB_Null;
		particle_spawner.owner = self;
		if ((world.worldtype == 2) || (world.model == "maps/start.bsp"))	// "base" type maps usualy have slipgates
			particle_spawner.think = select_slipgate_particle_effect;
		else
			particle_spawner.think = spawn_teleporter_particles_big;
		particle_spawner.nextthink = time + 0.1;
	}
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

if (autocvar_chasecam_death_view)
	{
	cvar_set ("chase_active", ftos(chaseactive));
	cvar_set ("chase_back", ftos(chaseback));
	cvar_set ("chase_up", ftos(chaseup));
	cvar_set ("chase_overhead", ftos(chaseoverhead));
	}

	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self, 30);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn		
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self, 30);
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
	else if (deathmatch)
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

	stuffcmd(self, "slowmo 1\n");	// always reset
	stuffcmd(self, "v_psycho 0\n");	// always reset

if (autocvar_chasecam_death_view)	// always reset if using this feature !
	{
	cvar_set ("chase_active", "0");
	cvar_set ("chase_back", "48");
	cvar_set ("chase_up", "24");
	cvar_set ("chase_overhead", "0");
	}

	chaseactive = cvar("chase_active");
	chaseback = cvar("chase_back");
	chaseup = cvar("chase_up");
	chaseoverhead = cvar("chase_overhead");

	spot = SelectSpawnPoint ();

	self.classname = "player";
	self.health = 100;
	self.health_initial = 100;
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

	if (autocvar_3rd_person_visible_weapons)
		setmodel (self, "progs/player_shot.mdl"); 
	else
	{
	if (autocvar_player_model == 1)
		setmodel (self, "progs/player1.mdl");
	else if (autocvar_player_model == 2)
		setmodel (self, "progs/player2.mdl");
	else if (autocvar_player_model == 3)
		setmodel (self, "progs/player3.mdl");
	else if (autocvar_player_model == 4)
		setmodel (self, "progs/player4.mdl");
	else
		setmodel (self, "progs/player.mdl");
	}
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

	player_stand1 ();
	
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin, self);

// can disable fog introduced in the via ent file
var float autocvar_ent_fog = 1;
if(!autocvar_ent_fog) localcmd("fog 0\n");

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
	local float	forward;

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
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};


void() PlayerJump =
{
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

	if (!cvar("chase_active"))	// we are in 1st person mode
	{
		if (autocvar_HUD_waterdrops_out_of_water)
		{
			if ((autocvar_HUD_waterdrops_out_of_water == 2) && (self.radsuit_finished) && (autocvar_biosuit_HUD_visor == 1))
			{
				if ((self.waterlevel > 1) && (self.waterlevel < 3) && (self.i_am_under_water == 1) && (self.watertype != CONTENT_LAVA))
					water_drops (self);
				if (self.waterlevel == 3)
					self.i_am_under_water = 1;
				else
					self.i_am_under_water = 0;	// reset
			}
			else if (autocvar_HUD_waterdrops_out_of_water == 1)
			{
				if ((self.waterlevel > 1) && (self.waterlevel < 3) && (self.i_am_under_water == 1) && (self.watertype != CONTENT_LAVA))
					water_drops (self);
				if (self.waterlevel == 3)
					self.i_am_under_water = 1;
				else
					self.i_am_under_water = 0;	// reset
			}
		}
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (autocvar_fire_projectiles_and_lava_inflame_time)
		{
			if ((autocvar_fire_projectiles_and_lava_inflame_particles) && (self.inflamed ==0)) // play sounds only once in lava
			{
				sound (self, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM); 		// play ignition sound
				sound (self, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
			}
			self.inflamed = 1;
			self.inflametime = time + autocvar_fire_projectiles_and_lava_inflame_time;		// max total time of fire hurting the player
			self.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence;  	// to avoid more damage from projectile
		}
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
		if (autocvar_wizard_projectiles_and_slime_poison_time)
		{
			self.poisoned = 1;
			self.poisontime = time + autocvar_wizard_projectiles_and_slime_poison_time;	 	// max total time of poison hurting the player
			self.poisonpause = time + autocvar_wizard_projectiles_and_slime_poison_frequence;  	// to avoid more damage from projectile
		}
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
	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used


	// Partial walkaround for "player in water reflection issue", in new Dark Places builds.	
	var float autocvar_player_reflection_fix = 1;		// "0"= for DP builds before 2012   "1"= for DP builds since 2012  (cvar to fix the player reflection issue when swimming in water when  r_water  is "1".  Since 2012 DP builds the issue exists. Independent to the "small mod compilation")
	if (autocvar_player_reflection_fix && (((self.waterlevel == 1 ) || (self.waterlevel == 2 )) && !( deathmatch || coop ) && (!cvar("chase_active"))))
		self.model = ""; 
	else
	{
		if (autocvar_3rd_person_visible_weapons)
			switch_vweps ();
		else	
		{
			if (autocvar_player_model == 1)
				self.model = "progs/player1.mdl"; 
			else if (autocvar_player_model == 2)
				self.model = "progs/player2.mdl"; 
			else if (autocvar_player_model == 3)
				self.model = "progs/player3.mdl"; 
			else if (autocvar_player_model == 4)
				self.model = "progs/player4.mdl"; 
			else
				self.model = "progs/player.mdl"; 
		}
	}

	CheckRules ();
	WaterMove ();
	
	if (self.rammed == 1)			// Used for Warlord monster: Player gets pushed back when Warlord uses special attack
	{
		self.velocity = self.velocity - (ramdirection * autocvar_warlord_ram_pushback);
		self.rammed = 0;
	}

	if (autocvar_player_wounded_bleeding)  
	{
		if (self.health <= 40) 			// if health is below 41 player shall bleed
		{
			if (self.health <= 20) 		// if health is below 21 player shall bleed more
   				Bleeding2(self);
			else
     				Bleeding1(self);
		}	
		else
			Bleedingnull(self);		// dont bleed
	}


	if (autocvar_player_wounded_aiming)  
	{
		if ((self.health <= 30) && (self.health > 0)) 		// if health is below 31, players aiming starts to suffer
		{
			if (self.health <= 15) 				// if health is below 16, player suffers a lot !!
				stuffcmd(self, "v_idlescale 7\n");
			else
				stuffcmd(self, "v_idlescale 3\n");
		}
		else
		{
			stuffcmd(self, "v_idlescale ");			// reset to desired value
			stuffcmd(self, ftos(autocvar_player_wounded_aiming_reset));
			stuffcmd(self, "\n");
		}
	}
	
	
	if (autocvar_player_wounded_heartbeat)  
	{
		if ((self.health <= 30) && (self.health > 0)) 		// if health is below 31, players heart starts pumping
		{
			if (self.health <= 15) 				// if health is below 16, player suffers a lot !!
			{
				if (self.playerheartbeat_finished < time)
					PlayerHeartbeat_quick ();
			}
			else
			{
				if (self.playerheartbeat_finished < time)
					PlayerHeartbeat_slow ();
			}
		}
	}


	if ((autocvar_player_changes_shirt_color_according_to_used_armor) && (!deathmatch))	// Player changes shirt color according/depending on used armor  (Only in single player or coop)
	{
		if (self.armortype == 0.3)
			stuffcmd(self, "topcolor 3\n");		
		else if (self.armortype == 0.6)
			stuffcmd(self, "topcolor 5\n");	
		else if (self.armortype == 0.8)
			stuffcmd(self, "topcolor 4\n");	
		else		
			stuffcmd(self, "topcolor 2\n");	
	}


	if ((autocvar_flying_dust) && (!deathmatch)) 			// Player is surrounded by flying dust (or ember, rain, snow).  (Only in single player or coop)
	{
		if (world.worldtype == 2)	// base map
		{
			if (autocvar_flying_dust == 2)
			{
				if (self.flying_dust_finished < time)
					spawn_flying_dust ();
			}
		}
		else
		{
			if (self.flying_dust_finished < time)
				spawn_flying_dust ();
		}
	}


	if ((self.poisoned == 1) && (self.health > 0))			// do wizard´s and/or slime poison damage
	{	
		if (self.poisontime > time && self.poisonpause < time && self.radsuit_finished < time && self.invincible_finished < time)
		{
			self.poisonpause = time + autocvar_wizard_projectiles_and_slime_poison_frequence + (crandom()*0.5);
			T_Damage (self, world, world, autocvar_wizard_projectiles_and_slime_poison_damage);
			if (autocvar_wizard_projectiles_and_slime_poison_flicker)
				te_customflash (self.origin, 5000, 0.33, '0 0.4 0.2');
		}
		if (self.watertype == CONTENT_WATER)
			self.poisoned = 0;	// cure wizards projectile poison when player jumps into water
	}

	if ((self.inflamed == 1) && (self.health > 0))			// do burning damage (inflamed player)
	{	
		if (self.inflametime > time && self.inflamepause < time && self.radsuit_finished < time && self.invincible_finished < time)
		{
			self.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence + (crandom()*0.5);
			T_Damage (self, world, world, autocvar_fire_projectiles_and_lava_inflame_damage);
			if (autocvar_fire_projectiles_and_lava_inflame_flicker)
				te_customflash (self.origin, 5000, 0.33, '0.4 0.1 0.1');
		}
		if (self.watertype == CONTENT_WATER)
		{
			self.inflamed = 0;	// cure burning when player jumps into water
			sound (self, 120, "misc/null.wav", 1, ATTN_NORM); 	// stop fire loop sound
		}
		if (self.inflametime < time)
		{
			self.inflamed = 0;
			sound (self, 120, "misc/null.wav", 1, ATTN_NORM); 	// stop fire loop sound
		}
		if (autocvar_fire_projectiles_and_lava_inflame_particles)
		{
			if (cvar("chase_active"))		// we are in 3rd person mode
			{
				if ((self.button0) && (!(self.weapon == IT_AXE)))	// fix player position in 3rd person mode when firing weapon
					pointparticles(particleeffectnum("burning_player"), self.origin + self.view_ofs + v_up * -22 + v_right * -10, self.velocity*10, 1);
				else
					pointparticles(particleeffectnum("burning_player"), self.origin, self.velocity*10, 1);
			}
			else					// we are in 1st person mode
				pointparticles(particleeffectnum("burning_player"), self.origin + self.view_ofs + v_up * -22 + v_forward*4, self.velocity*10, 1);
		}
	}

	
	if (the_matrix)				// starts a slowmotion effect (depending on cvar setting) when gibbing monsters
	{
		if (matrixcounter > time)
		{
			stuffcmd(self, "slowmo ");
			stuffcmd(self, ftos(autocvar_slowmotion_intensity));
			stuffcmd(self, "\n");
		}
		else
		{	
			stuffcmd(self, "slowmo 1\n");	// reset
			the_matrix = 0;			// reset
		}
	}

//	var float autocvar_psycho = 0;	  	 // visual screen effect when picking up quad and/or pent   0= disabled  1= enable when picking up quad   2= enable when picking up pent   3= enable when picking up quad OR pent
//	var float autocvar_evil_faces_psycho_effect = 0;  	 // visual screen effect when evil monster appears   0= disabled   1= enabled 
//	var float autocvar_ghost_follower_psycho_effect = 0.3;	// visual screen effect when ghost_follower touches player   0= disabled   Values < 0 = enabled  Set the value (in seconds) how long visual effect shall remain

	if ((autocvar_evil_faces_psycho_effect) || (autocvar_psycho) || (autocvar_ghost_follower_psycho_effect))	// starts the psycho screen effect
	{
		if ((pentpsycho && self.invincible_finished) || (quadpsycho && self.super_damage_finished) || ((face_psycho > time) && (autocvar_evil_faces_psycho_effect)) || ((ghost_follower_psycho > time) && (autocvar_ghost_follower_psycho_effect)))
			stuffcmd(self, "v_psycho 1\n");							
		else
			stuffcmd(self, "v_psycho 0\n");		// reset
	}		
		

	if (autocvar_taunt_sounds)
	{
		if (self.check_bodycount_frequence < time)
			check_bodycount();
	}


	if ((autocvar_mage_weapon) && (self.weapon == IT_LIGHTNING) && (self.health > 0))	// idle animation for mage view weapon
	{
		if ((self.animate_mage_weapon_frequence < time) && (!self.button0))
			animate_mage_weapon();
	}
	else
	{
		if ((autocvar_weapon_position_fully_adjustable) && (!autocvar_weapon_position_right))		// moves view_weapon position to ANY position
		{
			if (self.v_weapon_position_helper == 0)
			{
				self.v_weapon_position_helper = 1;
				v_weapon_position (self);
			}

			if (self.super_damage_finished)
			{
				if (autocvar_1st_person_extended_quad_effect) 
				{
					if (self.quad_v_weapon_position_helper == 0)
					{
						self.quad_v_weapon_position_helper = 1;
						add_Quake3_quad_effect_v_weapon_position (self);
					}
				}
			}
			else
				self.quad_v_weapon_position_helper = 0;		// reset
		}
		else
			self.v_weapon_position_helper = 0;		// reset
	}

	if ((invisweapon == 1) && (self.invisible_finished) && (!autocvar_weapon_position_fully_adjustable))	// adds transparent view weapon models during invisible (ring) phase
		add_transparent_weaponmodel (self);


	if ((autocvar_player_legs_visibility) && (!cvar("chase_active")) && !( deathmatch || coop ) && !(self.invisible_finished))	// adds player´s legs to 1st person view  (meant for Single player only !)
	{
		if (self.visible_legs_helper == 0)
		{
			self.visible_legs_helper = 1;
			player_legs (self);
		}
	}

	// adding special powerup effects
	if (cvar("chase_active"))	// we are in 3rd person mode
	{
		if ((self.invincible_finished) || (self.super_damage_finished))
		{
			if (self.invincible_finished)
			{
				if ((autocvar_3rd_person_extended_pent_effect == 1)||(autocvar_3rd_person_extended_pent_effect == 3))
					self.colormod = '2.5 1 1';
				if (autocvar_3rd_person_extended_pent_effect >= 2)
					pointparticles(particleeffectnum("3rd_person_pentagram"), self.origin, '0 0 0', 1);
			}	
			else if (self.super_damage_finished)
			{
				if ((autocvar_3rd_person_extended_quad_effect == 1)||(autocvar_3rd_person_extended_quad_effect == 3))
					self.colormod = '1 1 4';
				if ((autocvar_3rd_person_extended_quad_effect >= 2) && (autocvar_3rd_person_extended_ring_effect))
				{
					if (self.quad3_effect_helper == 0)
					{
						self.quad3_effect_helper = 1;
						add_Quake3_quad_effect_3rd (self);
					}
				}
			}
			if ((self.invincible_finished) && (self.super_damage_finished))
			{
				if (((autocvar_3rd_person_extended_quad_effect == 1)||(autocvar_3rd_person_extended_quad_effect == 3)) && ((autocvar_3rd_person_extended_pent_effect == 1)||(autocvar_3rd_person_extended_pent_effect == 3)))
					self.colormod = '2.5 1 4';
				if ((autocvar_3rd_person_extended_quad_effect >= 2) && (autocvar_3rd_person_extended_ring_effect))
				{
					if (self.quad3_effect_helper == 0)
					{
						self.quad3_effect_helper = 1;
						add_Quake3_quad_effect_3rd (self);
					}
				}
				if (autocvar_3rd_person_extended_pent_effect >= 2)
					pointparticles(particleeffectnum("3rd_person_pentagram"), self.origin, '0 0 0', 1);
			}
		}
		else
		{
			self.colormod = '1 1 1';				// reset
			self.quad3_effect_helper = 0;				// reset
		}	
	}
	else		// we are in 1st person mode
	{
		if (self.super_damage_finished)
		{
			if (autocvar_1st_person_extended_quad_effect) 
			{
				if (self.quad3_effect_helper_1st == 0)
				{
					self.quad3_effect_helper_1st = 1;
					add_Quake3_quad_effect_1st (self);
					add_Quake3_quad_effect_1st_legs (self);
				}
				if ((autocvar_3rd_person_extended_quad_effect == 1)||(autocvar_3rd_person_extended_quad_effect == 3))
					self.colormod = '1 1 4';	// also tint player model blueish, (as you can see yourself in mirrors)
			}
		}
		else
		{
			self.quad3_effect_helper_1st = 0;			// reset
			self.colormod = '1 1 1';				// reset
		}
	}
	   
	if (!cvar("chase_active"))	// we are in 1st person mode
	{
		if ((self.radsuit_picked_up) && (autocvar_biosuit_HUD_visor))	// spawn special biosuit HUD
		{
			if (autocvar_biosuit_HUD_visor == 1)
				biosuit_HUD (self);
			else
				biosuit_HUD_spinning_model (self);
			self.radsuit_picked_up = 0;	// reset
		}
		if ((self.quad_picked_up) && (autocvar_quad_HUD_visor))		// spawn special quad HUD
		{
			if (autocvar_quad_HUD_visor == 1)
				quad_HUD_texture (self);
			else
				quad_HUD_spinning_model (self);
			self.quad_picked_up = 0;	// reset
		}
		if ((self.pent_picked_up) && (autocvar_pent_HUD_visor))		// spawn special pent HUD
		{
			if (autocvar_pent_HUD_visor == 1)
				pent_HUD_texture (self);
			else
				pent_HUD_spinning_model (self);
			self.pent_picked_up = 0;	// reset
		}
		if ((self.ring_picked_up) && (autocvar_ring_HUD_visor))		// spawn special ring HUD
		{
			ring_HUD_spinning_model (self);
			self.ring_picked_up = 0;	// reset
		}
		if ((self.key_s_picked_up) && (autocvar_keys_HUD_visor))	// spawn special silver key HUD
		{
			key_s_HUD_spinning_model (self);
			self.key_s_picked_up = 0;	// reset
		}
		if ((self.key_g_picked_up) && (autocvar_keys_HUD_visor))	// spawn special gold key HUD
		{
			key_g_HUD_spinning_model (self);
			self.key_g_picked_up = 0;	// reset
		}
		if (self.mini_player_picked_up)					// spawn mini player HUD
		{
			player_HUD_model (self);
			self.mini_player_picked_up = 0;	// reset
		}
	}
		
	if ((autocvar_HUD_blood_splatter) && (blood_HUD_splat == 1))
	{
		blood_HUD_splat_start (self);	// spawn blood stains on player HUD
		blood_HUD_splat = 0;		// reset
	}

	if (autocvar_earthquake_interval)
	{
		if (self.earthquake_finished > time)		// starts random earthquake  (see random calculation in custom_effects.qc)
			start_earthquake ();
		else
			start_earthquake_think ();
	}

	if (view_zoom_out)					// adds "stretched" view animation when traveling with teleporters
	{
		if (self.viewzoom <= 1)
			self.viewzoom = self.viewzoom + 0.035;	// set speed of view animation here !
		else
			{
			view_zoom_out = 0;	
			self.viewzoom = 1;	// be sure to reset to exactly "1"
			}
	}
 	
	if ((autocvar_weapon_range_crosshair) && (!autocvar_player_health_crosshair) && (!autocvar_monster_health_crosshair))	// changes crosshair / color according to monster and weapon range
	{
		if (cvar("chase_active"))			// we are in 3rd person mode
		{
			if (autocvar_weapon_range_crosshair == 2)
				update_weapon_range_crosshair ();
		}
		else						// we are in 1st person mode
			update_weapon_range_crosshair ();
	}

	if ((!autocvar_weapon_range_crosshair) && (autocvar_player_health_crosshair) && (!autocvar_monster_health_crosshair))	// changes crosshair / color according to players health
		update_player_health_crosshair ();

	if ((!autocvar_weapon_range_crosshair) && (!autocvar_player_health_crosshair) && (autocvar_monster_health_crosshair))	// changes crosshair / color according to monsters health it aims at
		update_monster_health_crosshair ();

	if (autocvar_weapon_specific_crosshair)			// changes crosshair according to equipped weapon (feature can be used together with any other intractive crosshair feature except "animated_crosshair" )
		update_weapon_specific_crosshair ();

 	if (autocvar_animated_crosshair)			// animated crosshair when picking up quad-damage (feature can be used together with any interactive crosshair features except "weapon_specific_crosshair" )
	{
		if (self.super_damage_finished)
		{
			stuffcmd(self, "crosshair_color_red 0\n");		// change color to red
			stuffcmd(self, "crosshair_color_green 0.66\n");
			stuffcmd(self, "crosshair_color_blue 1.5\n");
			if (self.animated_crosshair_counter < time)
				update_animated_crosshair ();
		}
		else
		{
			stuffcmd(self, "crosshair_color_red 1\n");		// change color to red
			stuffcmd(self, "crosshair_color_green 0\n");
			stuffcmd(self, "crosshair_color_blue 0\n");
			stuffcmd(self, "crosshair 8\n");
		}		
	}

 	if (autocvar_distance_scale_crosshair)			// changes crosshair size depending on monster or surface distance (feature can be used together with any of the other interactive crosshair features)
		update_distance_scale_crosshair ();
 
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

SemisolidPreThink(); 

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

		if (autocvar_powerupcountdown == 2)
		{
			if ((self.invisible_finished < time + self.invisible_counter) && (self.invisible_counter > 3))	// starts with "30" and ends with "3"
			{
				self.invisible_counter = self.invisible_counter - 1;
				sprint (self, ftos(self.invisible_counter));
				sprint (self, "\n");
			}
		}

		if ( autocvar_powerupcountdown == 1 )
		{
			if ((self.invisible_finished <= time + 29.1)&&(self.invisible_finished >= time + 28.9)) {centerprint (self, "29");}
			if ((self.invisible_finished <= time + 28.1)&&(self.invisible_finished >= time + 27.9)) {centerprint (self, "28");}
			if ((self.invisible_finished <= time + 27.1)&&(self.invisible_finished >= time + 26.9)) {centerprint (self, "27");}
			if ((self.invisible_finished <= time + 26.1)&&(self.invisible_finished >= time + 25.9)) {centerprint (self, "26");}
			if ((self.invisible_finished <= time + 25.1)&&(self.invisible_finished >= time + 24.9)) {centerprint (self, "25");}
			if ((self.invisible_finished <= time + 24.1)&&(self.invisible_finished >= time + 23.9)) {centerprint (self, "24");}
			if ((self.invisible_finished <= time + 23.1)&&(self.invisible_finished >= time + 22.9)) {centerprint (self, "23");}
			if ((self.invisible_finished <= time + 22.1)&&(self.invisible_finished >= time + 21.9)) {centerprint (self, "22");}
			if ((self.invisible_finished <= time + 21.1)&&(self.invisible_finished >= time + 20.9)) {centerprint (self, "21");}
			if ((self.invisible_finished <= time + 20.1)&&(self.invisible_finished >= time + 19.9)) {centerprint (self, "20");}
			if ((self.invisible_finished <= time + 19.1)&&(self.invisible_finished >= time + 18.9)) {centerprint (self, "19");}
			if ((self.invisible_finished <= time + 18.1)&&(self.invisible_finished >= time + 17.9)) {centerprint (self, "18");}
			if ((self.invisible_finished <= time + 17.1)&&(self.invisible_finished >= time + 16.9)) {centerprint (self, "17");}
			if ((self.invisible_finished <= time + 16.1)&&(self.invisible_finished >= time + 15.9)) {centerprint (self, "16");}
			if ((self.invisible_finished <= time + 15.1)&&(self.invisible_finished >= time + 14.9)) {centerprint (self, "15");}
			if ((self.invisible_finished <= time + 14.1)&&(self.invisible_finished >= time + 13.9)) {centerprint (self, "14");}
			if ((self.invisible_finished <= time + 13.1)&&(self.invisible_finished >= time + 12.9)) {centerprint (self, "13");}
			if ((self.invisible_finished <= time + 12.1)&&(self.invisible_finished >= time + 11.9)) {centerprint (self, "12");}
			if ((self.invisible_finished <= time + 11.1)&&(self.invisible_finished >= time + 10.9)) {centerprint (self, "11");}
			if ((self.invisible_finished <= time + 10.1)&&(self.invisible_finished >= time + 9.9)) {centerprint (self, "10");}
			if ((self.invisible_finished <= time + 9.1)&&(self.invisible_finished >= time + 8.9)) {centerprint (self, "9");}
			if ((self.invisible_finished <= time + 8.1)&&(self.invisible_finished >= time + 7.9)) {centerprint (self, "8");}
			if ((self.invisible_finished <= time + 7.1)&&(self.invisible_finished >= time + 6.9)) {centerprint (self, "7");}
			if ((self.invisible_finished <= time + 6.1)&&(self.invisible_finished >= time + 5.9)) {centerprint (self, "6");}
			if ((self.invisible_finished <= time + 5.1)&&(self.invisible_finished >= time + 4.9)) {centerprint (self, "5");}
			if ((self.invisible_finished <= time + 4.1)&&(self.invisible_finished >= time + 3.9)) {centerprint (self, "4");}
			if ((self.invisible_finished <= time + 3.1)&&(self.invisible_finished >= time + 2.9)) {centerprint (self, "3");}
			if ((self.invisible_finished <= time + 2.1)&&(self.invisible_finished >= time + 1.9)) {centerprint (self, "2");}
			if ((self.invisible_finished <= time + 1.1)&&(self.invisible_finished >= time + 0.9)) {centerprint (self, "1");}
			if ((self.invisible_finished <= time + 0.3)&&(self.invisible_finished >= time + 0.1)) {centerprint (self, "QQQ powerup died QQQ");}
		}

		if ((autocvar_3rd_person_extended_ring_effect) && (cvar("chase_active")))
			self.alpha = autocvar_3rd_person_extended_ring_effect;
		else
		{
			// use the eyes
			self.frame = 0;
			self.modelindex = modelindex_eyes;
		}
					
	}
	else
	{
		if (!autocvar_3rd_person_visible_weapons)
			self.modelindex = modelindex_player;	// don't use eyes
		self.alpha = 1;					// always reset
	}

// invincibility
	if (self.invincible_finished)
	{
		self.poisoned = 0;	// cure poisoning when player uses pentagram
		self.inflamed = 0;	// cure player burning when using pentagram
		sound (self, 120, "misc/null.wav", 1, ATTN_NORM); 	// stop fire loop sound

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

		if (autocvar_powerupcountdown == 2)
		{
			if ((self.invincible_finished < time + self.invincible_counter) && (self.invincible_counter > 3))	// starts with "30" and ends with "3"
			{
				self.invincible_counter = self.invincible_counter - 1;
				sprint (self, ftos(self.invincible_counter));
				sprint (self, "\n");
			}
		}

		if ( autocvar_powerupcountdown == 1 )
		{
			if ((self.invincible_finished <= time + 29.1)&&(self.invincible_finished >= time + 28.9)) {centerprint (self, "29");}
			if ((self.invincible_finished <= time + 28.1)&&(self.invincible_finished >= time + 27.9)) {centerprint (self, "28");}
			if ((self.invincible_finished <= time + 27.1)&&(self.invincible_finished >= time + 26.9)) {centerprint (self, "27");}
			if ((self.invincible_finished <= time + 26.1)&&(self.invincible_finished >= time + 25.9)) {centerprint (self, "26");}
			if ((self.invincible_finished <= time + 25.1)&&(self.invincible_finished >= time + 24.9)) {centerprint (self, "25");}
			if ((self.invincible_finished <= time + 24.1)&&(self.invincible_finished >= time + 23.9)) {centerprint (self, "24");}
			if ((self.invincible_finished <= time + 23.1)&&(self.invincible_finished >= time + 22.9)) {centerprint (self, "23");}
			if ((self.invincible_finished <= time + 22.1)&&(self.invincible_finished >= time + 21.9)) {centerprint (self, "22");}
			if ((self.invincible_finished <= time + 21.1)&&(self.invincible_finished >= time + 20.9)) {centerprint (self, "21");}
			if ((self.invincible_finished <= time + 20.1)&&(self.invincible_finished >= time + 19.9)) {centerprint (self, "20");}
			if ((self.invincible_finished <= time + 19.1)&&(self.invincible_finished >= time + 18.9)) {centerprint (self, "19");}
			if ((self.invincible_finished <= time + 18.1)&&(self.invincible_finished >= time + 17.9)) {centerprint (self, "18");}
			if ((self.invincible_finished <= time + 17.1)&&(self.invincible_finished >= time + 16.9)) {centerprint (self, "17");}
			if ((self.invincible_finished <= time + 16.1)&&(self.invincible_finished >= time + 15.9)) {centerprint (self, "16");}
			if ((self.invincible_finished <= time + 15.1)&&(self.invincible_finished >= time + 14.9)) {centerprint (self, "15");}
			if ((self.invincible_finished <= time + 14.1)&&(self.invincible_finished >= time + 13.9)) {centerprint (self, "14");}
			if ((self.invincible_finished <= time + 13.1)&&(self.invincible_finished >= time + 12.9)) {centerprint (self, "13");}
			if ((self.invincible_finished <= time + 12.1)&&(self.invincible_finished >= time + 11.9)) {centerprint (self, "12");}
			if ((self.invincible_finished <= time + 11.1)&&(self.invincible_finished >= time + 10.9)) {centerprint (self, "11");}
			if ((self.invincible_finished <= time + 10.1)&&(self.invincible_finished >= time + 9.9)) {centerprint (self, "10");}
			if ((self.invincible_finished <= time + 9.1)&&(self.invincible_finished >= time + 8.9)) {centerprint (self, "9");}
			if ((self.invincible_finished <= time + 8.1)&&(self.invincible_finished >= time + 7.9)) {centerprint (self, "8");}
			if ((self.invincible_finished <= time + 7.1)&&(self.invincible_finished >= time + 6.9)) {centerprint (self, "7");}
			if ((self.invincible_finished <= time + 6.1)&&(self.invincible_finished >= time + 5.9)) {centerprint (self, "6");}
			if ((self.invincible_finished <= time + 5.1)&&(self.invincible_finished >= time + 4.9)) {centerprint (self, "5");}
			if ((self.invincible_finished <= time + 4.1)&&(self.invincible_finished >= time + 3.9)) {centerprint (self, "4");}
			if ((self.invincible_finished <= time + 3.1)&&(self.invincible_finished >= time + 2.9)) {centerprint (self, "3");}
			if ((self.invincible_finished <= time + 2.1)&&(self.invincible_finished >= time + 1.9)) {centerprint (self, "2");}
			if ((self.invincible_finished <= time + 1.1)&&(self.invincible_finished >= time + 0.9)) {centerprint (self, "1");}
			if ((self.invincible_finished <= time + 0.3)&&(self.invincible_finished >= time + 0.1)) {centerprint (self, "QQQ powerup died QQQ");}
		}
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

		if (autocvar_powerupcountdown == 2)
		{
			if ((self.super_damage_finished < time + self.super_damage_counter) && (self.super_damage_counter > 3))	// starts with "30" and ends with "3"
			{
				self.super_damage_counter = self.super_damage_counter - 1;
				sprint (self, ftos(self.super_damage_counter));
				sprint (self, "\n");
			}
		}

		if ( autocvar_powerupcountdown == 1 )
		{
			if ((self.super_damage_finished <= time + 29.1)&&(self.super_damage_finished >= time + 28.9)) {centerprint (self, "29");}
			if ((self.super_damage_finished <= time + 28.1)&&(self.super_damage_finished >= time + 27.9)) {centerprint (self, "28");}
			if ((self.super_damage_finished <= time + 27.1)&&(self.super_damage_finished >= time + 26.9)) {centerprint (self, "27");}
			if ((self.super_damage_finished <= time + 26.1)&&(self.super_damage_finished >= time + 25.9)) {centerprint (self, "26");}
			if ((self.super_damage_finished <= time + 25.1)&&(self.super_damage_finished >= time + 24.9)) {centerprint (self, "25");}
			if ((self.super_damage_finished <= time + 24.1)&&(self.super_damage_finished >= time + 23.9)) {centerprint (self, "24");}
			if ((self.super_damage_finished <= time + 23.1)&&(self.super_damage_finished >= time + 22.9)) {centerprint (self, "23");}
			if ((self.super_damage_finished <= time + 22.1)&&(self.super_damage_finished >= time + 21.9)) {centerprint (self, "22");}
			if ((self.super_damage_finished <= time + 21.1)&&(self.super_damage_finished >= time + 20.9)) {centerprint (self, "21");}
			if ((self.super_damage_finished <= time + 20.1)&&(self.super_damage_finished >= time + 19.9)) {centerprint (self, "20");}
			if ((self.super_damage_finished <= time + 19.1)&&(self.super_damage_finished >= time + 18.9)) {centerprint (self, "19");}
			if ((self.super_damage_finished <= time + 18.1)&&(self.super_damage_finished >= time + 17.9)) {centerprint (self, "18");}
			if ((self.super_damage_finished <= time + 17.1)&&(self.super_damage_finished >= time + 16.9)) {centerprint (self, "17");}
			if ((self.super_damage_finished <= time + 16.1)&&(self.super_damage_finished >= time + 15.9)) {centerprint (self, "16");}
			if ((self.super_damage_finished <= time + 15.1)&&(self.super_damage_finished >= time + 14.9)) {centerprint (self, "15");}
			if ((self.super_damage_finished <= time + 14.1)&&(self.super_damage_finished >= time + 13.9)) {centerprint (self, "14");}
			if ((self.super_damage_finished <= time + 13.1)&&(self.super_damage_finished >= time + 12.9)) {centerprint (self, "13");}
			if ((self.super_damage_finished <= time + 12.1)&&(self.super_damage_finished >= time + 11.9)) {centerprint (self, "12");}
			if ((self.super_damage_finished <= time + 11.1)&&(self.super_damage_finished >= time + 10.9)) {centerprint (self, "11");}
			if ((self.super_damage_finished <= time + 10.1)&&(self.super_damage_finished >= time + 9.9)) {centerprint (self, "10");}
			if ((self.super_damage_finished <= time + 9.1)&&(self.super_damage_finished >= time + 8.9)) {centerprint (self, "9");}
			if ((self.super_damage_finished <= time + 8.1)&&(self.super_damage_finished >= time + 7.9)) {centerprint (self, "8");}
			if ((self.super_damage_finished <= time + 7.1)&&(self.super_damage_finished >= time + 6.9)) {centerprint (self, "7");}
			if ((self.super_damage_finished <= time + 6.1)&&(self.super_damage_finished >= time + 5.9)) {centerprint (self, "6");}
			if ((self.super_damage_finished <= time + 5.1)&&(self.super_damage_finished >= time + 4.9)) {centerprint (self, "5");}
			if ((self.super_damage_finished <= time + 4.1)&&(self.super_damage_finished >= time + 3.9)) {centerprint (self, "4");}
			if ((self.super_damage_finished <= time + 3.1)&&(self.super_damage_finished >= time + 2.9)) {centerprint (self, "3");}
			if ((self.super_damage_finished <= time + 2.1)&&(self.super_damage_finished >= time + 1.9)) {centerprint (self, "2");}
			if ((self.super_damage_finished <= time + 1.1)&&(self.super_damage_finished >= time + 0.9)) {centerprint (self, "1");}
			if ((self.super_damage_finished <= time + 0.3)&&(self.super_damage_finished >= time + 0.1)) {centerprint (self, "QQQ powerup died QQQ");}
		}

	}

// suit	
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown
		self.poisoned = 0;			// cure poisoning when player uses biosuit
		self.inflamed = 0;			// cure player burning when using biosuit
		sound (self, 120, "misc/null.wav", 1, ATTN_NORM); 	// stop fire loop sound

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

		if (autocvar_powerupcountdown == 2)
		{
			if ((self.radsuit_finished < time + self.radsuit_counter) && (self.radsuit_counter > 3))	// starts with "30" and ends with "3"
			{
				self.radsuit_counter = self.radsuit_counter - 1;
				sprint (self, ftos(self.radsuit_counter));
				sprint (self, "\n");
			}
		}

		if ( autocvar_powerupcountdown == 1 )
		{
			if ((self.radsuit_finished <= time + 29.1)&&(self.radsuit_finished >= time + 28.9)) {centerprint (self, "29");}
			if ((self.radsuit_finished <= time + 28.1)&&(self.radsuit_finished >= time + 27.9)) {centerprint (self, "28");}
			if ((self.radsuit_finished <= time + 27.1)&&(self.radsuit_finished >= time + 26.9)) {centerprint (self, "27");}
			if ((self.radsuit_finished <= time + 26.1)&&(self.radsuit_finished >= time + 25.9)) {centerprint (self, "26");}
			if ((self.radsuit_finished <= time + 25.1)&&(self.radsuit_finished >= time + 24.9)) {centerprint (self, "25");}
			if ((self.radsuit_finished <= time + 24.1)&&(self.radsuit_finished >= time + 23.9)) {centerprint (self, "24");}
			if ((self.radsuit_finished <= time + 23.1)&&(self.radsuit_finished >= time + 22.9)) {centerprint (self, "23");}
			if ((self.radsuit_finished <= time + 22.1)&&(self.radsuit_finished >= time + 21.9)) {centerprint (self, "22");}
			if ((self.radsuit_finished <= time + 21.1)&&(self.radsuit_finished >= time + 20.9)) {centerprint (self, "21");}
			if ((self.radsuit_finished <= time + 20.1)&&(self.radsuit_finished >= time + 19.9)) {centerprint (self, "20");}
			if ((self.radsuit_finished <= time + 19.1)&&(self.radsuit_finished >= time + 18.9)) {centerprint (self, "19");}
			if ((self.radsuit_finished <= time + 18.1)&&(self.radsuit_finished >= time + 17.9)) {centerprint (self, "18");}
			if ((self.radsuit_finished <= time + 17.1)&&(self.radsuit_finished >= time + 16.9)) {centerprint (self, "17");}
			if ((self.radsuit_finished <= time + 16.1)&&(self.radsuit_finished >= time + 15.9)) {centerprint (self, "16");}
			if ((self.radsuit_finished <= time + 15.1)&&(self.radsuit_finished >= time + 14.9)) {centerprint (self, "15");}
			if ((self.radsuit_finished <= time + 14.1)&&(self.radsuit_finished >= time + 13.9)) {centerprint (self, "14");}
			if ((self.radsuit_finished <= time + 13.1)&&(self.radsuit_finished >= time + 12.9)) {centerprint (self, "13");}
			if ((self.radsuit_finished <= time + 12.1)&&(self.radsuit_finished >= time + 11.9)) {centerprint (self, "12");}
			if ((self.radsuit_finished <= time + 11.1)&&(self.radsuit_finished >= time + 10.9)) {centerprint (self, "11");}
			if ((self.radsuit_finished <= time + 10.1)&&(self.radsuit_finished >= time + 9.9)) {centerprint (self, "10");}
			if ((self.radsuit_finished <= time + 9.1)&&(self.radsuit_finished >= time + 8.9)) {centerprint (self, "9");}
			if ((self.radsuit_finished <= time + 8.1)&&(self.radsuit_finished >= time + 7.9)) {centerprint (self, "8");}
			if ((self.radsuit_finished <= time + 7.1)&&(self.radsuit_finished >= time + 6.9)) {centerprint (self, "7");}
			if ((self.radsuit_finished <= time + 6.1)&&(self.radsuit_finished >= time + 5.9)) {centerprint (self, "6");}
			if ((self.radsuit_finished <= time + 5.1)&&(self.radsuit_finished >= time + 4.9)) {centerprint (self, "5");}
			if ((self.radsuit_finished <= time + 4.1)&&(self.radsuit_finished >= time + 3.9)) {centerprint (self, "4");}
			if ((self.radsuit_finished <= time + 3.1)&&(self.radsuit_finished >= time + 2.9)) {centerprint (self, "3");}
			if ((self.radsuit_finished <= time + 2.1)&&(self.radsuit_finished >= time + 1.9)) {centerprint (self, "2");}
			if ((self.radsuit_finished <= time + 1.1)&&(self.radsuit_finished >= time + 0.9)) {centerprint (self, "1");}
			if ((self.radsuit_finished <= time + 0.3)&&(self.radsuit_finished >= time + 0.1)) {centerprint (self, "QQQ powerup died QQQ");}
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

SemisolidPostThink(); 

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
CheckSplash();
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
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
	if ((autocvar_player_changes_shirt_color_according_to_used_armor) && (!deathmatch))	// always reset if using this feature !  (Only in single player or coop)
		stuffcmd(self, "topcolor 2\n");	

	if (autocvar_chasecam_death_view)	// always reset if using this feature !
	{
		cvar_set ("chase_active", "0");
		cvar_set ("chase_back", "48");
		cvar_set ("chase_up", "24");
		cvar_set ("chase_overhead", "0");
	}

	if ((autocvar_weapon_range_crosshair) || (autocvar_player_health_crosshair) || (autocvar_monster_health_crosshair))	// always reset if using any of these features !
	{
		cvar_set ("crosshair_color_red", "1");
		cvar_set ("crosshair_color_green", "0");
		cvar_set ("crosshair_color_blue", "0");
	}
	if ((autocvar_weapon_specific_crosshair) || (autocvar_animated_crosshair))	// reset to crosshair 1  (be aware, that this might not be the previously used crosshair by the user)
		cvar_set ("crosshair", "1");		
 	if (autocvar_distance_scale_crosshair)			// reset to crosshair size as declared in autocvar_distance_scale_crosshair_default  (default: 1)
		cvar_set ("crosshair_size", ftos(autocvar_distance_scale_crosshair_default));

	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

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
			targ.frags = targ.frags - 1;
			bprint (targ.netname);

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_army")
					bprint (" was shot by a Grunt\n");
				if (attacker.classname == "monster_demon1")
					bprint (" was eviscerated by a Fiend\n");
				if (attacker.classname == "monster_dog")
					bprint (" was mauled by a Rottweiler\n");
				if (attacker.classname == "monster_dragon")
					bprint (" was fried by a Dragon\n");
				if (attacker.classname == "monster_enforcer")
				{
					if (attacker.enforcer_type == "monster_defender") 
 						bprint (" was executed by a Defender\n");
			 		else if (attacker.enforcer_type == "monster_eliminator") 
						bprint (" was pulverized by a Eliminator\n");
					else if (attacker.enforcer_type == "monster_pyro") 
						bprint (" was burned down by a Pyro\n");
					else
						bprint (" was blasted by an Enforcer\n");
				}
				if (attacker.classname == "monster_fish")
					bprint (" was fed to the Rotfish\n");
				if (attacker.classname == "monster_hell_knight")
					bprint (" was slain by a Death Knight\n");
				if (attacker.classname == "monster_hydra")
					bprint (" was drowned by a Hydra\n");
				if (attacker.classname == "monster_knight")
					bprint (" was slashed by a Knight\n");
				if (attacker.classname == "monster_ogre")
					bprint (" was destroyed by an Ogre\n");
				if (attacker.classname == "monster_oldone")
					bprint (" became one with Shub-Niggurath\n");
				if (attacker.classname == "monster_shalrath")
					bprint (" was exploded by a Vore\n");
				if (attacker.classname == "monster_shambler")
					bprint (" was smashed by a Shambler\n");
				if (attacker.classname == "monster_tarbaby")
					bprint (" was slimed by a Spawn\n");
				if (attacker.classname == "monster_vomit")
					bprint (" was vomited on by a Vomitus\n");
				if (attacker.classname == "monster_wizard")
					bprint (" was scragged by a Scrag\n");
				if (attacker.classname == "monster_zombie")
					bprint (" joins the Zombies\n");
				if (attacker.classname == "monster_spider")
					bprint (" got eaten by the Spiders\n");
				if (attacker.classname == "monster_afrit")
					bprint (" was burned down by the Afrits\n");
				if (attacker.classname == "monster_hell_knight2")
					bprint (" was crushed by a Warlord\n");
				if (attacker.classname == "monster_torment")
					bprint (" was gored by a Torment\n");
				if (attacker.classname == "monster_carnivean")
					bprint (" was sliced by a Carnivean\n");
				if (attacker.classname == "monster_yakman")
					bprint (" was crushed by a Yakman\n");
				if (attacker.classname == "monster_reiver")
					bprint (" was terrified by a Reiver\n");
				if (attacker.classname == "monster_necromancer")
					bprint (" was transformed into dead meat by a Necromancer\n");

				return;
			}

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" blew up\n");
				return;
			}
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

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" fell to his death\n");
				return;
			}

			// hell if I know; he's just dead!!!
			bprint (" died\n");
		}
	}
};
