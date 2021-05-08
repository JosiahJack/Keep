
// prototypes
void () W_WeaponFrame;
void() W_SetCurrentAmmo;
void() player_pain;
void() player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

float CTF = 1;

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6
$frame rockrun6

float	modelindex_eyes, modelindex_player;
.string vwep;

/*
===============================
	Model Attachments
===============================
*/



void() UpdateGunFrames =
{
	if (self.owner.health <= 0 || (self.owner.health <= 0 && self.owner.enemy.weapon == IT_LASER_CANNON))
	{
		remove(self);
		return;
	}
	switch (self.owner.weapon)
	{
		case IT_SHOTGUN:
			self.vwep = "progs/p_shot.md3";
			break;
		case IT_SUPER_SHOTGUN:
			if (autocvar_qc_ssg == 1)
				self.vwep =  "progs/QC/p_ssg.md3";
			else
				self.vwep =  "progs/p_ssg.md3";
			break;
		case IT_NAILGUN:
			self.vwep =  "progs/p_nail.md3";
			break;
		case IT_SUPER_NAILGUN:
			self.vwep =  "progs/p_nail2.md3";
			break;
		case IT_GRENADE_LAUNCHER:
			self.vwep =  "progs/p_rock.md3";
			break;
		case IT_ROCKET_LAUNCHER:
			self.vwep =  "progs/p_rock2.md3";
			break;
		case IT_LIGHTNING:
			self.vwep =  "progs/p_light.md3";
			break;
		case IT_CHAINSAW:
			self.vwep =  "progs/p_saw.md3";
			break;		
		case IT_LASER_CANNON:
			self.vwep =  "progs/p_laser.md3";
			break;	
	}		

	if (self.owner.items & IT_INVISIBILITY)
		self.alpha = .01;
	else
		self.alpha = 1;
		
	if (self.owner.items & IT_QUAD)
		self.effects = EF_NOSHADOW;
	else
		self.effects = 0;
		
	setmodel (self, self.vwep);
	self.frame = self.owner.frame;
	self.think = UpdateGunFrames;
	self.nextthink = time + 0.01;
		
};

void() UpdatePackFrames =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}	

	if (self.owner.items & IT_SUIT)
		setmodel (self, "progs/pack_attach.mdl");
	else
		setmodel (self, string_null);
		
	if (self.owner.items & IT_INVISIBILITY)
		self.alpha = .01;
	else
		self.alpha = 1;
	self.frame = self.owner.frame;
	self.think = UpdatePackFrames;
	self.nextthink = time + 0.01;
		
};

void() UpdateAxeFrames =
{
	if (self.owner.health <= 0)
	{
		remove(self);
		return;
	}
	if (self.owner.items & IT_INVISIBILITY)
		self.alpha = .01;
	else
		self.alpha = 1;
	if (self.owner.throwing == 0)
		setmodel (self, "progs/p_axe.md3");
	else
		setmodel (self, "");
	self.frame = self.owner.frame;
	self.think = UpdateAxeFrames;
	self.nextthink = time + 0.01;
		
};

void() AttachVwep =
{
	entity vwep;
	
	
	vwep = spawn();
	vwep.owner = self;
	vwep.solid = SOLID_NOT;
	vwep.movetype = MOVETYPE_NOCLIP;
	vwep.think = UpdateGunFrames;
	vwep.nextthink = time + 0.01;
	makevectors(vwep.angles);
	setorigin(vwep, vwep.origin + v_forward*5);	

	setattachment(vwep, self, "Gun");
};

void() AttachPack =
{
	entity pack;
	
	
	pack = spawn();
	pack.owner = self;
	pack.solid = SOLID_NOT;
	pack.movetype = MOVETYPE_NOCLIP;
	pack.think = UpdatePackFrames;
	pack.nextthink = time + 0.01;
	
	makevectors(pack.angles);
	setorigin(pack, pack.origin + v_forward*5);	

	setattachment(pack, self, "airpack");
};

void() AttachVAxe =
{
	entity vwep2;
	
	
	
	vwep2 = spawn();
	vwep2.owner = self;
	vwep2.solid = SOLID_NOT;
	vwep2.movetype = MOVETYPE_NOCLIP;
	vwep2.think = UpdateAxeFrames;
	vwep2.nextthink = time + 0.01;
	makevectors(vwep2.angles);
	
	setorigin(vwep2, vwep2.origin + v_forward*5);	

	setattachment(vwep2, self, "Axe");
};


var float autocvar_debug_frames = 0;

float(vector tor_ang) defineLmax =
{
	local float lmax;
	lmax = tor_ang_y + 90;
	
	if (lmax > 360)
		lmax-=360;
	else if (lmax <= 0)
		lmax+=360;
		
	if (tor_ang_y >=270 && tor_ang_y <= 360)
		lmax+=360;
		
	return lmax;
}

float(vector tor_ang) defineRmax =
{
	local float rmax;
	rmax = tor_ang_y - 90;
	
	if (rmax >= 360)
		rmax-=360;
	else if (rmax <= 0)
		rmax+=360;
		
	if (tor_ang_y <=90 && tor_ang_y >= 0)
		rmax-=360;
		
	return rmax;
}


void() DebugAngles =
{
	local vector plrang;
	local float lmax, rmax;
	
	
	if (self.owner.angles_y >= 0)
		plrang_y = self.owner.angles_y;
	else
		plrang_y = self.owner.angles_y + 360;
		
	lmax = defineLmax(plrang);
	rmax = defineRmax(plrang);
	
	if (autocvar_debug_frames)
		centerprint3(self.owner, strcat("player frame: ", ftos(self.owner.frame), " dummy leg frame: ", ftos(self.frame), "\n V_Right: ", ftos(checkUPS_right(self.owner)), "\n V_Forward: ", ftos(checkUPS_forward(self.owner))), strcat("\n legs angles: ", vtos(self.angles), "\n parent angles: ", vtos(plrang), "\n parent v_angle: ", vtos(self.owner.v_angle), "\n Legs left max: ", ftos(lmax)), strcat(" \n Legs right max: ", ftos(rmax)));
			
}

void() overrideTP =
{
	self.owner.angles_x = -self.owner.v_angle_x;
	self.owner.angles_y = self.owner.v_angle_y;
	self.owner.angles_z = self.owner.v_angle_z;
}

float() checkShootframes =
{
	local float framenum;
	
	if (!(checkSpeed(self.owner, 10)) || self.owner.swing)
	{
	
		if (self.owner.frame >= 113 && self.owner.frame <= 118)
			framenum = -101;
		if (self.owner.frame >= 107 && self.owner.frame <= 112)
			framenum = 148;
	}
	else if (checkSpeed(self.owner, 10))
	{
		if (self.owner.frame >= 103 && self.owner.frame <= 106)
		{
			
			if (time - self.delay >= 0.1)		
			{
				self.delay = time;
				self.walkframe++;
				
			}
			self.frame = self.walkframe;
			if (self.walkframe > 11 || !self.walkframe)
				self.walkframe = 6;
		}
		
	}
		
		
	return framenum;
}

void() legsOriginCheck =
{
	//hardcoded frame checks to account for origin when playing running rocket firing animation
	if (self.frame >= 108 && self.frame <= 112 && (checkSpeed(self.owner, 10)))
	{
		if (self.frame == 108)
			self.origin = self.owner.origin + v_forward*-8;
		else if (self.frame == 109)
			self.origin = self.owner.origin + v_forward*-10;
		else if (self.frame == 110)
			self.origin = self.owner.origin + v_forward*-9;
		else if (self.frame == 111)
			self.origin = self.owner.origin + v_forward*-8;
		else
			self.origin = self.owner.origin + v_forward*-6;
	}
	else 
		self.origin = self.owner.origin;
}

float() swimCheck =
{
	if (self.frame >= 207 && self.frame <= 213)
		return TRUE;
	else
		return FALSE;
}


void() UpdateLegFrames =
{
	local float frameoff;
	
	setmodel (self, "progs/player_low.mdl");

	if (self.owner.health <= 0 || intermission_running)
	{
		remove(self);
		return;
	}
	if (self.owner.model != "progs/player_torso.mdl" && self.owner.health > 0)
	{
		setmodel (self, string_null);
		return;
	}
	
	
		
	vector plranglemod, playerang;
	float lmax, rmax;
	
	if (self.owner.angles_y >= 0)
		playerang_y = self.owner.angles_y;
	else
		playerang_y = self.owner.angles_y + 360;
		
	lmax = defineLmax(playerang);
	rmax = defineRmax(playerang);
	
	self.skin = self.owner.skin;
	
	if (self.owner.items & IT_QUAD)
		self.effects = EF_FULLBRIGHT;
	else
		self.effects = self.owner.effects;
		
	self.colormod = self.owner.colormod;
	
	
	//if (checkUPS_forward(self.owner) > -10 && checkUPS_forward(self.owner) < 10 || self.owner.swing)
	frameoff = checkShootframes();

	
	makevectors(self.owner.angles);
	
	//disable rotation for bots since they switch angles rapidly sometimes
	if (self.owner.ishuman != 1 || self.owner.health <= 0 || swimCheck())
	{
		self.colormap = self.owner.colormap;
	
	
	
		self.frame = self.owner.frame + frameoff;
		self.origin = self.owner.origin;
		
		self.angles_y = self.owner.angles_y;
		
		self.think = UpdateLegFrames;
		self.nextthink = time + 0.001;
		
		return;
	}
	
	DebugAngles();
	
	

	plranglemod = vectoangles(self.owner.velocity);
	
	vector legmod = vectoangles(self.velocity);
	
	

	/*if (self.frame >= 207 && self.frame <= 213)
	{
		//only do this in 3rd person otherwise
		if (cvar("chase_active"))
		{
			self.owner.angles_y = plranglemod_y;
			self.angles = self.owner.angles;
		}
		else
			self.angles_y = playerang_y;
		
	}*/
	if (self.owner.swing && !(self.owner.flags & FL_ONGROUND) || self.owner.meleeing || (!self.owner.velocity_x && !self.owner.velocity_y))
		self.angles = playerang;
	else if ((checkUPS_right(self.owner) > 240))
		self.angles_y = rmax;
	else if (checkUPS_right(self.owner) < -240)
		self.angles_y = lmax;
	else if (checkUPS_forward(self.owner) >= 0)
	{
		self.angles_y = plranglemod_y;
		//check against the max angle for turning left
		if (self.angles_y > lmax)
			self.angles_y = lmax;
		//check against the max for turning right
		else if (self.angles_y < rmax)
			self.angles_y = rmax;
	}
	else
		self.angles_y = plranglemod_y + 180;
		
	
	
	self.colormap = self.owner.colormap;
	
	
	if (!(self.owner.frame >= 103 && self.owner.frame <= 106))
		self.frame = self.owner.frame + frameoff;
	

	legsOriginCheck();
	
	self.think = UpdateLegFrames;
	self.nextthink = time + 0.001;
	
	//gettaginfo(self.owner, gettaginfo_parent);
		
};

/*
void() UpdateLegFrames =
{
	local float frameoff;

	if (self.owner.health <= 0 && self.owner.model != "progs/player.mdl")
	{
		remove(self);
		return;
	}
	if (self.owner.model != "progs/player.mdl" && self.owner.health > 0)
	{
		setmodel (self, string_null);
		return;
	}
	vector plranglemod;
	
	setmodel (self, "progs/player_low.mdl");
	
	
	if (checkUPS_forward(self.owner) > -10 && checkUPS_forward(self.owner) < 10 || self.owner.swing)
		frameoff = checkShootframes();

	
	makevectors(self.owner.angles);
	
	//disable rotation for bots since they switch angles rapidly sometimes
	if (self.owner.ishuman != 1)
	{
		self.colormap = self.owner.colormap;
	
	
	
		self.frame = self.owner.frame + frameoff;
		self.origin = self.owner.origin;
		
		self.angles_y = self.owner.angles_y;
		
		self.think = UpdateLegFrames;
		self.nextthink = time + 0.001;
		
		return;
	}
	
	DebugAngles();
	
	plranglemod = vectoangles(self.owner.velocity);
	
	
	
	if (self.frame >= 207 && self.frame <= 213)
	{
		//only do this in 3rd person otherwise
		if (cvar("chase_active"))
		{
			self.owner.angles_y = plranglemod_y;
			self.angles_y = plranglemod_y;
		}
		else
		{
			self.angles_y = self.owner.angles_y;
		}
		
	}
	else if (self.owner.swing && !(self.owner.flags & FL_ONGROUND) || self.owner.meleeing)
		self.angles = self.owner.angles;
	else
	{
		if (!(checkUPS_forward(self.owner) <= 5) || ((checkUPS_right(self.owner) > 310) || (checkUPS_right(self.owner) < -310)))
		{
			if ((self.owner.velocity_x || self.velocity_y))
				self.angles_y = plranglemod_y;
			else
				self.angles = self.owner.angles;
		}
		else
		{
			//self.angles = self.owner.angles;
			if (checkUPS_forward(self.owner) < 1)
			{
				if ((self.owner.velocity_x || self.velocity_y))
					self.angles_y = plranglemod_y + 180;
			}
			else
				self.angles = self.owner.angles;
		}
	}
	//overrideTP();
	
	
	self.colormap = self.owner.colormap;
	
	
	
	self.frame = self.owner.frame + frameoff;
	self.origin = self.owner.origin;
	
	
	
	self.think = UpdateLegFrames;
	self.nextthink = time + 0.001;
	
	//gettaginfo(self.owner, gettaginfo_parent);
		
};
*/

void() AttachLegs =
{
	entity plegs, legmodel;
	
	plegs = spawn();
	setmodel (plegs, "progs/player_low.mdl");
	plegs.owner = self;
	plegs.netname = "playerlegs";
	plegs.solid = SOLID_NOT;
	plegs.movetype = MOVETYPE_NOCLIP;
	plegs.think = UpdateLegFrames;
	
	
	plegs.exteriormodeltoclient = self;
	plegs.nextthink = time;
	
	
		

};

void() muzzle_emitter_think =
{
	self.frame++;
	self.ltime++;
	self.alpha-=.02;
	self.scale-=.01;
	self.velocity_z = self.velocity_z+1;
	//self.velocity_x = self.velocity_x-25;
	self.think = muzzle_emitter_think;
	self.nextthink = time + 0.1;
	
	if (self.ltime > 35)
		remove(self);		
}

void(entity e, string spritepath, float spscale, vector pos_mod, vector startvelocity, vector velocityrandom, float startalpha, float emittertype) Sprite_Emitter =			//Spawns a first person sprite
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_NOT;
	newmis.viewmodelforclient = e;
	newmis.owner = e;
	newmis.classname = "particle";
	
	setmodel(newmis, spritepath);
	
	newmis.scale = spscale;
	newmis.scale+= random(-0.1, 0.1);
	newmis.alpha = startalpha;
	newmis.velocity = startvelocity;
	

	//newmis.velocity_x += random(velocitydecay_x-10, velocitydecay_x);
	//newmis.velocity_y += random(velocitydecay_y-30, velocitydecay_y);
	//newmis.velocity_z += random(velocitydecay_z-20, velocitydecay_z);
	
	newmis.velocity_x += random(-velocityrandom_x, velocityrandom_x);
	newmis.velocity_y += random(-velocityrandom_y, velocityrandom_y);
	newmis.velocity_z += random(-velocityrandom_z, velocityrandom_z);
	
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, '0 0 0');	
	
	if (emittertype == TYPE_STANDARD)
	{
		pos_mod_x += random(-.5, .5);
		pos_mod_y += random(-.3, .3);
		pos_mod_z += random(-.3, .3);
	}
		
	newmis.origin+= pos_mod;
	
	if (autocvar_centered_weapons)
		newmis.origin = newmis.origin + '0 8 -2';
	
		
	if (emittertype == TYPE_SMOKE)
		newmis.think = muzzle_smoke_think;
	else
		newmis.think = muzzle_emitter_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
};


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
	parm10 = self.grenade_ammo;
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
	self.grenade_ammo = parm10;
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
		else if (world.model == "maps/e2m8.bsp") //else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 7);
			WriteByte (MSG_ALL, 8);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		}
		else if (world.model == "maps/e3m8.bsp")
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
		intermission_exittime = time + 8;
	else
		intermission_exittime = time + 2;
		
	/*if (deathmatch)
		if(other.classname == "player")
			if (other.frags >= cvar("fraglimit"))
				other.winner = other.netname;*/

	if (autocvar_deathmatch_music == 1 && deathmatch)
	{
		WriteByte (MSG_ALL, SVC_CDTRACK);
		WriteByte (MSG_ALL, 16);
		WriteByte (MSG_ALL, 17);
	}
	else
	{
		WriteByte (MSG_ALL, SVC_CDTRACK);
		WriteByte (MSG_ALL, 3);
		WriteByte (MSG_ALL, 3);
	}
	
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

//level change state

.float issaved;

void() changelevel_touch;

void() savepos_clevel =
{
	if (!self.issaved && self.ltime == 0)
	{
		localcmd(strcat("save data/", world.model, ".state\n"));
		self.issaved = 1;
	}
	else if (self.issaved && self.ltime > 0)
		self.touch = changelevel_touch;
		
	self.ltime++;
}

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
	self.touch = changelevel_touch;//self.touch = savepos_clevel;//
	
	local vector o;
	o = (self.mins + self.maxs)*0.5;
	
	if (CTF_ENABLED)
		ctf_replacer(o);
	
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
		
	
	stuffcmd (self, strcat("chase_active ", ftos(chaseactive), "\n"));
	stuffcmd (self, strcat("chase_back ", ftos(chaseback), "\n"));
	stuffcmd (self, strcat("chase_up ", ftos(chaseup), "\n"));
	stuffcmd (self, strcat("chase_overhead ", ftos(chaseoverhead), "\n"));
	
	}
	
		
	if (coop)
	{
		if (autocvar_coop_life_pool == 1)
		{
			if (LIFE_BONUS >= 1)
			{
				self.lives+=1;
				lives_global+=1;
				LIFE_BONUS-=1;
			}
			if (self.lives <= 0 && lives_global > 0)
				return;
			//if limited lives is enabled check if all players are out of lives
			if (lives_global == 0)
				changelevel (mapname);
			
			stuffcmd(self, "chase_active 0\n");
		}
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self, 30);
		// get the spawn parms as they were at level start
		if (self.musicstart == 0)
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
			
		self.delay = time;
	}
	else
	{	// restart the entire server
		cvar_set("slowmo", "1");
		localcmd ("restart\n");
		//localcmd("load quick\n");
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
	//set_suicide_frame ();
	//change suicide through console to do damage - more consistent that way
	T_Damage(self, other, other, 300);
	//self.modelindex = modelindex_player;
	self.frags = self.frags - 2;	// extra penalty
	//respawn ();
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

float DED_PLR;
.float revivetimer;


/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void() DecodeLevelParms;
void() PlayerDie;

void() rebreather_think = 
{
	
	//if (self.owner.items & IT_SUIT)
	//{
		
			//Don't worry about this showing up in weird places on higher resolutions -
							// all viewmodels are scaled to fit the res perfectly
	//}
	//else
	//	setmodel(self, string_null); //hide when player does not have suit
		
	//self.think = rebreather_think;
}


void() SpawnRebreather =			//Spawns a first person mask for the biosuit
{
	if (self.classname == "item_artifact_envirosuit")
		self.owner = other;
	else
		self.owner = self;
		
	entity cammodel, glass;
	cammodel = spawn();
	
	cammodel.movetype = MOVETYPE_NONE;
	cammodel.solid = SOLID_NOT;
	cammodel.viewmodelforclient = self.owner;
	cammodel.owner = self.owner;
	cammodel.classname = "gasmask";
	cammodel.effects = cammodel.effects + EF_NOGUNBOB;
	
	//if (self.items & IT_SUIT)
	setmodel(cammodel, "progs/rebreather.mdl");
	
	
	//else
	cammodel.scale = 0.5;
	//newmis.alpha = 0.6;
	setsize(cammodel, '0 0 0', '0 0 0');
	setorigin(cammodel, '4 0 1');
	cammodel.think = SUB_Remove;
	cammodel.nextthink = time + 30;
	
	glass = spawn();
	
	glass.movetype = MOVETYPE_NONE;
	glass.solid = SOLID_NOT;
	glass.viewmodelforclient = self.owner;
	glass.owner = self.owner;
	glass.classname = "gasmask_glass";
	glass.effects = glass.effects + EF_NOGUNBOB;
	glass.alpha = 0.1;
	
	//if (self.items & IT_SUIT)
	setmodel(glass, "progs/rebr_glass.spr");
	
	setsize(glass, '0 0 0', '0 0 0');
	setorigin(glass, '89 -80 97');
	
	glass.think = SUB_Remove;
	glass.nextthink = time + 30;
	
};

/*
void() music_changer =
{
	//Deathmatch music player
	if (deathmatch && self.musicstart == 0 && autocvar_deathmatch_music == 1 && self.ishuman == 1)
	{
		if (random() <= 0.2)
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 12);
			WriteByte (MSG_ALL, 13);
		
		}
		else if (random() <= 0.4)
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 13);
			WriteByte (MSG_ALL, 14);
			
		}
		else if (random() <= 0.6)
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 14);
			WriteByte (MSG_ALL, 15);
			
		}
		else if (random() <= 0.8)
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 15);
			WriteByte (MSG_ALL, 16);
			
		}
		else
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			
		}
		self.musicstart = 1;
	}
}*/

void() music_changer =
{
	//Deathmatch music player - switched to stuffcmd instead of WriteByte to only play music clientside
	if (deathmatch && self.musicstart == 0 && autocvar_deathmatch_music == 1 && self.ishuman == 1)
	{
		if (random(100) <= 20)
			stuffcmd(self, "cd loop 12\n");
		else if (random(100) <= 40)
			stuffcmd(self, "cd loop 13\n");
		else if (random(100) <= 60)
			stuffcmd(self, "cd loop 14\n");
		else if (random(100) <= 80)
			stuffcmd(self, "cd loop 15\n");
		else
			stuffcmd(self, "cd loop 2\n");
			
		self.musicstart = 1;
	}
}

void() CTF_team_spawn =
{
	local entity teamspawn, players;
	if (self.side == BLUE)
		teamspawn = find(world, netname, "blue start");
	else 
		teamspawn = find(world, netname, "red start");
	
	if (pointcontents(teamspawn.origin) != CONTENT_SOLID)
		setorigin(self, teamspawn.origin);//self.origin = teamspawn.origin;
	else
	{
		if (self.side == BLUE)
			teamspawn = find(world, netname, "blue start");
		else 
			teamspawn = find(world, netname, "red start");
	}
}

//float GAME_STARTED;
.float plegs;

void() PutClientInServer =
{
	
	local	entity spot, spot2;

	if ((!deathmatch && !coop) || ((deathmatch || coop) && (!IN_SLOWMO)))
		localcmd("slowmo 1\n");//stuffcmd(self, "slowmo 1\n");	// always reset
	stuffcmd(self, "v_psycho 0\n");	// always reset

if (autocvar_chasecam_death_view)	// always reset if using this feature !
	{
	stuffcmd (self, "chase_active 0\n");
	stuffcmd (self, "chase_back 65\n");
	stuffcmd (self, "chase_up 10\n");
	stuffcmd (self, "chase_overhead 0\n");
	}

	chaseactive = cvar("chase_active");
	chaseback = cvar("chase_back");
	chaseup = cvar("chase_up");
	chaseoverhead = cvar("chase_overhead");

	if (!CTF_ENABLED)
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
	self.wetsuit_finished = 0;
	self.inflamed = 0;
	self.shocked = 0;
	
	
	
	
	
	
	if (autocvar_coop_life_pool == 1 && coop && self.health > 0 && self.lives == 0)
	{
		if (self.ishuman == 1)
			lives_global+=1;
		self.lives = autocvar_coop_lives;
		self.oldorigin = spot.origin;
	}
	
	DecodeLevelParms ();
	
	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
//	spot = SelectSpawnPoint ();
	
	//{
		//self.goalentity = find(world, classname, "player");
		//self.origin = self.goalentity.origin;
	//}
	
		

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	
	
	
	
	
	
	
	self.fixangle = TRUE;		// turn this way immediately
	
	if (coop && autocvar_coop_life_pool == 1 && autocvar_coop_revive == 1)
	{
		//make sure player is not stuck in a wall or a lava/slime pit before respawning in place
		if (pointcontents(self.oldorigin) != CONTENT_LAVA && pointcontents(self.oldorigin) != CONTENT_SLIME && pointcontents(self.oldorigin) != CONTENT_SOLID && pointcontents(self.oldorigin) != CONTENT_WATER)
			if (self.dmg_inflictor.classname != "trigger_hurt" && self.dmg_inflictor.classname != "door" && self.dmg_inflictor.classname != "func_train" && self.dmg_inflictor.classname != "trap_gravity_well")
				self.origin = self.oldorigin + '0 0 10';
	}
	

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
		setmodel (self, "progs/player_torso.mdl");
	}
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';
	
	if (CTF_ENABLED && !self.side)
	{
		choose_team();
		//self.GAME_STARTED+=1;
	}
	
	if (CTF_ENABLED)
	{
		self.has_flag = 0;
		self.gametype = CTF;
		CTF_team_spawn();
	}
	
	music_changer();
	
	//3rd person Weapon attachment
	AttachVwep();
	AttachVAxe();
	
	AttachLegs();
		
	
	AttachPack();
	
	if (self.ishuman == 1)
		SNGHeater();
	
	player_stand1 ();
	
	//Give player grenades at the start of each episode
	if (self.grenade_ammo <= 0 && world.model == "maps/start.bsp")
	{
		if (skill >= 2)
			self.grenade_ammo+=1;
		else
			self.grenade_ammo+=2;
	}
	else if (deathmatch)
	{
		self.grenade_ammo+=1;
	}
	
	if (deathmatch && autocvar_chainsaw_dm_spawn == 1)
	{
		self.items = self.items | 
		IT_CHAINSAW;
	}
	
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}
	
	self.bulletspeed = 900;	//bullet time sg/ssg projectile speed
	
	PLR_CNT+=1;
	self.revivetimer = 0;
	
	if (!coop && !deathmatch && autocvar_auto_save)
	{
		//stuffcmd(self, strcat("wait 3000;save autosaves_",world.model,".sav\n"));
		stuffcmd(self, "wait 3000;save autosaves/autosave\n");
		stuffcmd(self, "Echo Autosaving...\n");	
	}

	if (!CTF_ENABLED && self.ishuman == 1)
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
	if (CTF_ENABLED)
		ctf_replacer(self.origin);
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
	if (CTF_ENABLED)
		capture_limit = cvar("ctf_capture_limit");
	
	if (timelimit && time >= timelimit)
	{
		NextLevel ();
		return;
	}
	
	if (fraglimit && self.frags >= fraglimit && !CTF_ENABLED)
	{
		NextLevel ();
		return;
	}	
	
	if (capture_limit && (BLUE_CAPS >= capture_limit || RED_CAPS >= capture_limit))
	{
		NextLevel ();
		return;
	}
};

//============================================================================

void() checkPlayer;
void() revivePlayer;

void() Spectate =
{
	//spectator test
	entity whospec;
	
	if (time - self.delay >= 0.5)
		stuffcmd(self, "chase_active 1\n");
	
	if (self.button2 || self.button1 || self.button0)
		self.cnt++;
	if (self.clientcamera.health <= 0)
		self.clientcamera = self;
	if (self.cnt == 0)		
		whospec = find(whospec, classname, "player");
	if (self.cnt == 2 && whospec == self.clientcamera)
		whospec = find(whospec, classname, "player");
	
	if (self.cnt == 3)
	{
		if (self.button2 || self.button1 || self.button0)
		{
			if (self.clientcamera == self.enemy)
				whospec = self.clientcamera.enemy;
			else
				whospec = find(world, classname, self.enemy.classname);
			if (self.cnt > 3)
				self.cnt = 0;
		}
	}

	//if (whospec == whospec)
	//	whospec = find(whospec, classname, "player");
	//if(!whospec)
	//	whospec = find(world, classname, self.enemy.classname);
	/*if (self.button2 || self.button1 || self.button0)
	{
		whospec = find(world, classname, self.enemy.classname);	
		self.clientcamera = whospec;
	}*/
	
	
	
	if (whospec.health > 0 && whospec != self.clientcamera)
		self.clientcamera = whospec;
}

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
	
	if (autocvar_coop_life_pool)
	{
		if (self.ishuman == 1)
		{
			if (time - self.delay >= 1)
			{
				centerprint3(self, "\n\n\n\n\n\n\n\n\n\n\n\nYou are ^1DEAD \n", "\n\n\n\n\n\n\n\n^3lives left: ^1", ftos(self.lives), "\n\n^2Players left: ^1", ftos(lives_global));
				self.delay = time;
			}
		}
		if (self.lives == 0)	
			Spectate();	
	}
	

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (autocvar_coop_life_pool)
		{
			if(self.ishuman == 1 && !(self.button2 || self.button1 || self.button0))
			{
				self.lives-=1;
				autocvar_coop_lives = self.lives;
				if (self.lives == 0)
				{
					lives_global--;
					self.delay = time;
				}
			}
			
			
			self.oldorigin = self.origin; // store where player died
			DED_PLR+=1;
		}
		if (CTF_ENABLED)
			self.has_flag = 0; //let enemies return the flag if player hasn't respawned
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
	/*if (autocvar_coop_revive_sys == 1 && coop) //WIP AND BROKEN
	{
		checkPlayer();
		//if (!self.button2 && !self.button1 && !self.button0)
			//return;
		//revivePlayer();
	}
	else
	{*/
	
		//Check slope and adjust body angle
		bodyCheck();
		
		//Make jump quickload in SP games
		if (!coop && !deathmatch)
		{
			if (autocvar_auto_save)
				centerprint (self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n^9Press ^1FIRE^9 to load last autosave, ^3JUMP^9 to restart level" );
			else
				centerprint (self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n^9Press ^3FIRE ^9or ^3JUMP^9 to restart level" );
				
			if (self.button0)
			{
				cvar_set("slowmo", "1");	//fix for slowmo getting stuck on quickload
				//stuffcmd(self, "wait 100;disconnect;wait 50000;load quick\nslowmo 1\n"); //localcmd() is glitchy with quickload so i used stuffcmd instead
				if (autocvar_auto_save)
					stuffcmd(self, "wait 100;disconnect;wait 50000;load autosaves/autosave\n");
					//stuffcmd(self, strcat("wait 100;disconnect;wait 50000;load autosaves_",world.model,".sav\n"));

			}
		}
						
		if (!self.button2 && !self.button1 && !self.button0)
			return;

		self.button0 = 0;
		self.button1 = 0;
		self.button2 = 0;
		
		respawn();
	//}
};

void() player_jump;

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
				sound7 (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM, SNDSPD);
			else
				sound7 (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM, SNDSPD);
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
	sound7 (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM, SNDSPD);
	player_jump();
	self.velocity_z = self.velocity_z + 270;
};


/*
===========
WaterMove

============
*/
.float	dmgtime;

void(float num_bubbles) DeathBubbles;

void() WetsuitMove =
{
	//WETSUIT
	if (self.wetsuit_finished > time)
		{
		if (self.waterlevel==2)
			{
			self.velocity = self.velocity * 1.25;
			}
		if (self.waterlevel==3)
			{
			self.velocity = self.velocity * 1.5;
			}
      if (self.waterlevel >= 2)
         {
         // play scuba sound
		if (self.swim_flag < time)
		{
			    self.swim_flag = time + 7;
			    if (cvar("slowmo") < 0.9)
				sound7 (self, CHAN_BODY, "misc/wetsuit.wav", 1, ATTN_NORM, SNDSPD);
			    else
				sound (self, CHAN_BODY, "misc/wetsuit.wav", 1, ATTN_NORM);
		
		}
         //MED 01/17/97
         else
            {
            if (fabs(self.swim_flag - time - 6)<0.04)
               {
               DeathBubbles(1);
               }
            else if (fabs(self.swim_flag - time - 5.5)<0.04)
               {
               DeathBubbles(1);
               }
            else if (fabs(self.swim_flag - time - 5)<0.04)
               {
               DeathBubbles(1);
               }
            }
         }

     }
}

.float watertime;

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
			sound7 (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM, SNDSPD);
		else if (self.air_finished < time + 9)
			sound7 (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM, SNDSPD);
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
	
	if (self.waterlevel >= 3)
		if (self.items & IT_SUIT)
		{
			self.watertime++;
			if (self.watertime == 230)
			{
				 if (cvar("slowmo") < 0.9)
					sound7 (self, CHAN_AUTO, "misc/wetsuit.wav", 1, ATTN_NORM, SNDSPD);
				 else
					sound (self, CHAN_AUTO, "misc/wetsuit.wav", 1, ATTN_NORM);
			}
			if (self.watertime == 305)
			{
				DeathBubbles(1);
				Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 0 -20', '320 30 -10', '25 18 10', .7, TYPE_SMOKE);
			}
			if (self.watertime == 318)
			{
				DeathBubbles(1);
				Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 0 -20', '150 -10 -30', '25 18 10', .7, TYPE_SMOKE);
			}
			if (self.watertime == 331)
			{
				DeathBubbles(1);
				Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 0 -20', '220 10 -40', '25 18 10', .7, TYPE_SMOKE);
			}
			if (self.watertime == 342)
			{
				DeathBubbles(1);
				self.watertime = 0;
				Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 0 -20', '130 25 -20', '25 18 10', .7, TYPE_SMOKE);
			}
			
		}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (autocvar_fire_projectiles_and_lava_inflame_time)
		{
			if ((autocvar_fire_projectiles_and_lava_inflame_particles) && (self.inflamed == 0)) // play sounds only once in lava
			{
				if (time - self.delay >= 1.5)
				{
					sound (self, CHAN_AUTO, "player/inflame.wav", .5, ATTN_NORM); 		// play ignition sound
					sound (self, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
					self.delay = time;
				}
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
			sound7 (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM, SNDSPD);
		if (self.watertype == CONTENT_WATER)
			sound7 (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM, SNDSPD);
		if (self.watertype == CONTENT_SLIME)
			sound7 (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM, SNDSPD);

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

void() ChasecamInit =
{
	vector pang;
	
	pang = vectoangles(self.velocity);
	
	if (!(self.flags & FL_ONGROUND) && self.health > 0)
	{
		if (!self.velocity_x && !self.velocity_y)
			self.angles_y = self.v_angle_y;	
		else if (Dot(v_forward, self.velocity) < 160 && Dot(v_forward, self.velocity) > -160)
			self.angles_y = pang_y;
		else
			self.angles = pang;
	}
	else if (cvar("chase_active") && self.ishuman == 1 && self.health > 0)
	{
		
		
		if (!self.velocity_x && !self.velocity_y)
			self.angles_y = self.v_angle_y;	
		else if (self.weapon == IT_CHAINSAW && self.weaponframe < 5)
			self.angles_y = pang_y;
		else if (!self.button0 && self.weaponframe == 0)
			self.angles_y = pang_y;
	}
}

/*
void() ChasecamInit =
{
	if (self.health > 0)
	{
		//pang = vectoangles(self.velocity);
		
		if (!self.velocity_x && !self.velocity_y)
		{
			setmodel (self, "progs/player.mdl");
			modelindex_player = self.modelindex;

			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
			//self.angles_y = self.v_angle_y;
			
		}
		else if ((Dot(v_right,self.velocity) > -50 && Dot(v_right,self.velocity) < 50))
		{
			setmodel (self, "progs/player.mdl");
			modelindex_player = self.modelindex;

			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (Dot(v_right,self.velocity) > 50 && (Dot(v_forward,self.velocity) < 310))
		{
			setmodel (self, "progs/player_right.mdl");
			modelindex_player = self.modelindex;

			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		else if (Dot(v_right,self.velocity) < -50 && (Dot(v_forward,self.velocity) < 310))
		{
			setmodel (self, "progs/player_left.mdl");
			modelindex_player = self.modelindex;

			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
	}
}*/

void() NoclipMove =
{
	//centerprint(self,ftos(Dot(v_up,self.velocity)));
	if (self.movetype != MOVETYPE_NOCLIP)
		return;
		
	if (self.button2)
		self.noclip = 1100;
	else
		self.noclip = 400;
	if (Dot(v_forward,self.velocity) > .1 || Dot(v_up,self.velocity) <= -319 || Dot(v_up,self.velocity) >= 319)
		self.velocity = v_forward*self.noclip;
	else if (Dot(v_forward,self.velocity) < -.1 || Dot(v_up,self.velocity) <= -319 || Dot(v_up,self.velocity) >= 319)
		self.velocity = v_forward*-self.noclip;
		
	
		
}



/*
================
PlayerPreThink

Called every frame before physics are run
================
*/

.float resizeable;

void() LadderSound =
{
	if (self.timeladder < time) 
	{
	// Reset timer for next sound to play
	self.timeladder = time + self.entladder.waitmin;
	// Check for any sounds and query if footsteps are active
		if (self.entladder.sounds != 4) 
		{
			self.lip = random();
			if (self.lip < 0.25 && self.entladder.noise1) 
				sound (self, CHAN_BODY, self.entladder.noise1, 1, ATTN_NORM);
			else if (self.lip < 0.5 && self.entladder.noise2) 
				sound (self, CHAN_BODY, self.entladder.noise2, 1, ATTN_NORM);
			else if (self.lip < 0.75 && self.entladder.noise3) 
				sound (self, CHAN_BODY, self.entladder.noise3, 1, ATTN_NORM);
			else if (self.entladder.noise4) 
				sound (self, CHAN_BODY, self.entladder.noise4, 1, ATTN_NORM);
		}
	}
}

void() Ladder_ClimbJump =
{
	// Reset velocity upwards and all sideways movement
	// so that the player stays on the ladder and climbs
	// straight up with very little sidways movement
	self.velocity = '0 0 0';
	
	//Updated ladder movement - look in the direction you want to move and hold jump
	
	if (self.v_angle_x < -25)
		self.velocity_z = self.entladder.speed; //climb up with the ladder speed when player is looking up
	else if (self.v_angle_x > 25)
		self.velocity_z = -self.entladder.speed; //negate ladder speed when player looks down, was not possible to descend before
	else 
		self.velocity = v_forward*215; //holding jump while looking straight on will dismount the player
	//self.velocity_z = self.entladder.speed;
	LadderSound();
}

void() Ladder_ClimbMove =
{
	//Use Dot products to determine if user is trying to move up or down
	
	if (Dot(v_forward,self.velocity) > 2 || Dot(v_up,self.velocity) < -20 || Dot(v_up,self.velocity) > 20)
	{
		//self.velocity = v_forward*self.entladder.speed;
		if (self.v_angle_x < -25)
			self.velocity_z = self.entladder.speed; //climb up with the ladder speed when player is looking up
		else if (self.v_angle_x > 25)
		{
			self.velocity = v_forward*self.entladder.speed;
			self.velocity_z = -self.entladder.speed; //negate ladder speed when player looks down, was not possible to descend before
		}
		else 
			self.velocity = 0; //let the player hover on ladder when not moving forward
		LadderSound();		
	}
}


void() autosave_timer =
{		
	if (time - SAVE_TIMER >= 140)
	{
		stuffcmd(self, "Echo Autosaving...\n");
		//stuffcmd(self, strcat("save autosaves_",world.model,".sav\n"));
		stuffcmd(self, "save autosaves/autosave\n");
		SAVE_TIMER = time;
	}
	
}


void() PlayerPreThink =
{	
	if (CTF_ENABLED)
	{
		set_team_color();
		self.blue_captures = BLUE_CAPS;
		self.red_captures = RED_CAPS;
	}
	
	if (BotPreFrame()) // FrikBot
		return;
	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used
	
	//ChasecamInit();
	
	//dynamic pitch modulation
	if (autocvar_slowmo_pitch == 1)
		SNDSPD = 100 * cvar("slowmo");
	
	if (self.dmenu)
		DebugMenu();
	
	if (self.waterlevel >= 3 && self.ishuman == 1 && cvar("slowmo") == 1)
	{
		self.PLR_SNDSPD = 75;
		if (!coop && !deathmatch)
			SNDSPD = 75;
	}
	else if (autocvar_slowmo_pitch == 1)
		self.PLR_SNDSPD = 100 * cvar("slowmo");
	else
		self.PLR_SNDSPD = 100;
	
	if (autocvar_coop_life_pool && self.health > 0)
		self.clientcamera = self;
		
	if (!coop && !deathmatch && autocvar_auto_save)
		autosave_timer();

	// Partial walkaround for "player in water reflection issue", in new Dark Places builds.	
	var float autocvar_player_reflection_fix = 1;		// "0"= for DP builds before 2012   "1"= for DP builds since 2012  (cvar to fix the player reflection issue when swimming in water when  r_water  is "1".  Since 2012 DP builds the issue exists. Independent to the "small mod compilation")
	if (autocvar_player_reflection_fix && (((self.waterlevel == 1 ) || (self.waterlevel == 2 )) && !( deathmatch || coop ) && (!cvar("chase_active"))))
		self.model = ""; 
	else if (time - self.delay >= 0.3)
	{
		if (autocvar_3rd_person_visible_weapons)
			switch_saw ();
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
			{	
				
				if (self.health > 0)
				{
					
					//	setmodel (self, "progs/player_biosuit.mdl");
					//else
					setmodel (self, "progs/player_torso.mdl");
					
					if (self.items & IT_SUIT)
						self.skin = 1;	
					else if (self.items & IT_QUAD)
					{
						self.effects = EF_FULLBRIGHT | EF_BLUE;
						self.colormod = '0 0 6';
					}
					else
					{
						if (autocvar_bright_skins)
							self.effects = self.effects | EF_FULLBRIGHT;
						else
							self.effects = 0;
						
						self.skin = 0;
						self.colormod = '1 1 1';
					}
					
					modelindex_player = self.modelindex;
					setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
					
				
				}
				
			}
			
			
		
			
		}
		self.delay = time;
	}
	

	CheckRules ();
	WaterMove ();
	NoclipMove();
	
	WetsuitMove();
	
	
	
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


	/*if (autocvar_player_wounded_aiming)  
	{
		if ((self.health <= 30) && (self.health > 0)) 		// if health is below 31, players aiming starts to suffer
		{
			if (self.health <= 15) 				// if health is below 16, player suffers a lot !!
				stuffcmd(self, "v_idlescale 6\n");
			else
				stuffcmd(self, "v_idlescale 3\n");
		}
		else
		{
			stuffcmd(self, "v_idlescale ");			// reset to desired value
			stuffcmd(self, ftos(autocvar_player_wounded_aiming_reset));
			stuffcmd(self, "\n");
		}
	}*/
	
	
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


	if ((autocvar_player_changes_shirt_color_according_to_used_armor) && (!deathmatch) && (time - self.delay > 1))	// Player changes shirt color according/depending on used armor  (Only in single player or coop)
	{
		if (self.armortype == 0.3)
			stuffcmd(self, "topcolor 3\n");		
		else if (self.armortype == 0.6)
			stuffcmd(self, "topcolor 5\n");	
		else if (self.armortype == 0.8)
			stuffcmd(self, "topcolor 4\n");	
		else		
			stuffcmd(self, "topcolor 2\n");	
		
		self.delay = time;
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
			stuffcmd (self, "bf\n"); //Q1 screen effect
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
			self.traileffectnum = particleeffectnum("");
			self.inflamed = 0;
			sound (self, 120, "misc/null.wav", 1, ATTN_NORM); 	// stop fire loop sound
		}
		if (autocvar_fire_projectiles_and_lava_inflame_particles && self.inflamed == 1)
			self.traileffectnum = particleeffectnum("burning_player");
			
	
	}
	else
		self.traileffectnum = particleeffectnum("");

	
	if (the_matrix)				// starts a slowmotion effect (depending on cvar setting) when gibbing monsters
	{
		if (matrixcounter > time)
		{
			localcmd("slowmo ");
			localcmd(ftos(autocvar_slowmotion_intensity));
			localcmd("\n");
			
		}
		else
		{	
			localcmd("slowmo 1\n");	// reset
			the_matrix = 0;			// reset
		}
	}
	if (!matrixcounter && cvar("sv_cheats") != 1)
	{
		if (!self.slowmo_timer)	
			cvar_set("slowmo", "1");
	}
	


//	var float autocvar_psycho = 0;	  	 // visual screen effect when picking up quad and/or pent   0= disabled  1= enable when picking up quad   2= enable when picking up pent   3= enable when picking up quad OR pent
	if ( autocvar_psycho && time && self.delay >= 0.3)                   // prevents losing ability of using v_psycho via console
	{
		if ((pentpsycho && self.invincible_finished) || (quadpsycho && self.super_damage_finished))	// starts the psycho screen effect
			stuffcmd(self, "v_psycho 1\n");							
		else
			stuffcmd(self, "v_psycho 0\n");		// reset
		
		self.delay = time;
	}

//	var float autocvar_evil_faces_psycho_effect = 0;  	 // visual screen effect when evil monster appears   0= disabled   1= enabled 
	if ( autocvar_evil_faces_psycho_effect )            
	{
		if (face_psycho > time)
			stuffcmd(self, "v_psycho 1\n");							
		else
			stuffcmd(self, "v_psycho 0\n");		// reset
	}

//	var float autocvar_ghost_follower_psycho_effect = 0.3;	// visual screen effect when ghost_follower touches player   0= disabled   Values < 0 = enabled  Set the value (in seconds) how long visual effect shall remain
	if ( autocvar_ghost_follower_psycho_effect )            
	{
		if ( (autocvar_psycho) && ((pentpsycho && self.invincible_finished) || (quadpsycho && self.super_damage_finished)) )
		{
			// to prevent custom quad or pent psycho effect to interfere with ghost_followers psycho effect
		}
		else
		{
			if (ghost_follower_psycho > time)
				stuffcmd(self, "v_psycho 1\n");							
			else
				stuffcmd(self, "v_psycho 0\n");		// reset
		}
	}


	if (autocvar_taunt_sounds && self.delay >= 0.2)
	{
		if (self.check_bodycount_frequence < time)
			check_bodycount();
			
		self.delay = time;
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
		{
			self.v_weapon_position_helper = 0;		// reset
		}
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
	/*if (cvar("chase_active"))	// we are in 3rd person mode
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
	}*/

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

	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing
		
	
	
	// When the player/client starts in the map they don't want any velocity	
	if (time < self.pausetime) self.velocity = '0 0 0';

//end ladder code


	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time	
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	if(time > self.attack_finished && self.currentammo == 0 && self.weapon != IT_AXE && self.weapon != IT_CHAINSAW)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}

SemisolidPreThink(); 
		//----------------------------------------------------------------------
	// Rubicon Ladder Code - johnfitz
	// Modified by me to support diff climb sounds and on/off/toggle states
	//----------------------------------------------------------------------
	
	if (self.onladder) {
		self.onladder = 0;		// Reset ladder touch function
		if (self.button2) {		// Is jump key being pressed?
			
			//Climb Ladder with jump key
			Ladder_ClimbJump();
			
			if (self.health > 0)
				self.gravity = 0.0000001;
			
		}
		else {
			
			// Jump key released, stay floating on the ladder
			self.flags = self.flags | FL_JUMPRELEASED;
			self.velocity = 0.7 * self.velocity;
			self.velocity_z = 0;

			//climb ladder with forward key
			Ladder_ClimbMove();
			if (self.health > 0)
				self.gravity = 0.0000001;
			
			
		}
	}
	else {
		// Reset any ladder gravity settings
		self.gravity = 1;
		// Original jump conditions
		//if (self.button2) PlayerJump ();
		//else self.flags = self.flags | FL_JUMPRELEASED;
	}

};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() WetsuitTime =
{
	// wetsuit
	if (self.wetsuit_finished)
	{
	self.air_finished = time + 12;		// don't drown

	// sound and screen flash when items starts to run out
	if (self.wetsuit_finished < time + 3)
		{
			if (self.wetsuit_time == 1)
			{
				sprint (self, "Air supply in Wetsuit is running out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.wetsuit_time = time + 1;
			}

			if (self.wetsuit_time < time)
			{
				self.wetsuit_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.wetsuit_finished < time)
		{	// just stopped
//MED
		self.items = self.items - IT_SUIT;
			self.wetsuit_time = 0;
			self.wetsuit_finished = 0;
		}
	}
}

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
		else if (autocvar_powerupcountdown == 0 && (self.invisible_finished < time + self.invisible_counter))
			self.invisible_counter = self.invisible_counter - 1;

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
		else if (autocvar_powerupcountdown == 0 && (self.invincible_finished < time + self.invincible_counter))
			self.invincible_counter = self.invincible_counter - 1;

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
		else if (autocvar_powerupcountdown == 0 && (self.super_damage_finished < time + self.super_damage_counter))
			self.super_damage_counter = self.super_damage_counter - 1;

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
		else if (autocvar_powerupcountdown == 0 && (self.radsuit_finished < time + self.radsuit_counter))
			self.radsuit_counter = self.radsuit_counter - 1;

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
		
		WetsuitTime();
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
	
SemisolidPostThink(); 

//WETSUIT
	if (self.wetsuit_finished > time)
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
	//ChasecamInit();
	if ((autocvar_mp_grapple && deathmatch) || autocvar_cheat_hook_sp)
	CheckGrapHook();
	W_WeaponFrame ();

// check to see if player landed and play landing sound	
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5); 
			sound7 (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM, SNDSPD);
			self.deathtype = "falling";
		}
		else
			sound7 (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM, SNDSPD);

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
	ClientInRankings();
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
	ClientDisconnected();
	if ((autocvar_player_changes_shirt_color_according_to_used_armor) && (!deathmatch))	// always reset if using this feature !  (Only in single player or coop)
		stuffcmd(self, "topcolor 2\n");	

	if (autocvar_chasecam_death_view)	// always reset if using this feature !
	{
		stuffcmd (self, "chase_active 0\n");
		stuffcmd (self,"chase_back 65\n");
		stuffcmd (self,"chase_up 10\n");
		stuffcmd (self,"chase_overhead 0\n");
	}

	if ((autocvar_weapon_range_crosshair) || (autocvar_player_health_crosshair) || (autocvar_monster_health_crosshair))	// always reset if using any of these features !
	{
		stuffcmd (self, "crosshair_color_red 1\n");
		stuffcmd (self, "crosshair_color_green 0\n");
		stuffcmd (self, "crosshair_color_blue 0\n");
	}
	
	if (CTF_ENABLED)	
		if (self.side == BLUE)	//team counter to check balance
			BLUE_PLAYERS--;
		else
			RED_PLAYERS--;


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
			//Q3 style kill feed for DM
			if (deathmatch && attacker.ishuman == 1)
			{
				if (attacker.weapon == IT_CHAINSAW || attacker.weapon == IT_AXE)
					centerprint3 (attacker, "YOU ^1HUMILIATED ^7", targ.netname, "\n ^3You have ^7", ftos(attacker.frags + 1), " ^1frags" );
				else
					centerprint3 (attacker, "YOU ^2FRAGGED ^7", targ.netname, "\n ^3You have ^7", ftos(attacker.frags + 1), " ^1frags" );	
			}
			//centerprint (attacker, );
			
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
				if (targ.dmg_inflictor.classname == "proximity_grenade")
				{
				       bprint (targ.netname);
				       if (random()<0.5)
					  bprint (" got too friendly with ");
				       else
					  bprint (" did the rhumba with ");
				       bprint (attacker.netname);
				       bprint ("'s bomb\n");
				       return;
				}
				rnum = attacker.weapon;
				if (rnum == IT_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_CHAINSAW)
				{
					deathstring = " was split by ";
					deathstring2 = "'s bloody chainsaw\n";
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
				/*if (rnum == IT_LASER_CANNON)
				{
				if (random()<0.5)
				{
					deathstring = " was toasted by ";
				}
				else
				{
					deathstring = " was radiated by ";
				}
					deathstring2 = "'s laser\n";
				}*/
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
				if (attacker.classname == "monster_demon1" || attacker.netname == "monster_demon1")
					bprint (" was eviscerated by a Fiend\n");
				if (attacker.classname == "monster_dog")
					bprint (" was mauled by a Rottweiler\n");
				if (attacker.classname == "monster_dragon")
					bprint (" was fried by a Dragon\n");
				if (attacker.classname == "monster_enforcer" && (attacker.skin == 1 && autocvar_enforcer_defender == 1))
					bprint (" was blown away by a Defender\n");
				else if (attacker.classname == "monster_enforcer")
					bprint (" was blasted by an Enforcer\n");
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
				if (attacker.classname == "monster_freddie")
					bprint (" was murdered by a Freddie\n");
				if (attacker.classname == "monster_oldone")
					bprint (" became one with Shub-Niggurath\n");
				if (attacker.classname == "monster_shalrath" || attacker.netname == "monster_shalrath")
					bprint (" was exploded by a Vore\n");
				if (attacker.classname == "monster_shambler")
					bprint (" was smashed by a Shambler\n");
				if (attacker.classname == "monster_tarbaby")
					bprint (" was slimed by a Spawn\n");
				if (attacker.classname == "monster_vomit")
					bprint (" was vomited on by a Vomitus\n");
				if (attacker.classname == "monster_wizard" || attacker.netname == "monster_wizard")
					bprint (" was scragged by a Scrag\n");
				if (attacker.classname == "monster_zombiek" || attacker.netname == "monster_zombiek")
					bprint (" joins the Zombies\n");
				if (attacker.classname == "monster_zombie" || attacker.netname == "monster_zombie")
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
				if (attacker.classname == "monster_dfury")
					bprint (" felt the fury like a whirlwind\n");
				if (attacker.classname == "monster_dfury_boss")
					bprint (" felt the fury like a whirlwind\n");
				if (attacker.classname == "monster_shalrath_boss")
					bprint (" is a permanent addition to the hive\n");
				if (attacker.classname == "monster_voreling" || attacker.netname == "monster_voreling")
					bprint (" took one too many bites in the knee\n");
				if (attacker.classname == "monster_jim")
					bprint (" took the heat from jim\n");

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
				if (attacker.deathtype)
				{
					bprint (" ");	//space between the message
					bprint (attacker.deathtype); //uses .deathtype as a string message
					bprint ("\n"); //new line
					return;
				}
				else
				{
					bprint (" was squished\n");
					return;
				}
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
			
			//mapper defined death message
			if (attacker.classname == "trigger_hurt" && attacker.deathtype)
			{
				bprint (" ");	//space between the message
				bprint (attacker.deathtype); //uses .deathtype as a string message
				bprint ("\n"); //new line
				return;
			}
			// fell to their death?
			else if (targ.deathtype == "falling")
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
