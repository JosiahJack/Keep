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
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes
//            displaying and counting shots
// 1999-10-22 Improved non-weapon-related impulses by Maddes
//            removing non-weapon-related impulses from ImpulseCommands()
// 1999-10-21 Correction: Discharge is an explosion by Zoid/Maddes
//            adding explosion on discharge
// 1999-09-05 Grenades bounce off skies fix by MaNiAc/Maddes
//            enhancing grenade touch function
// 1999-02-20 Functions to locate map bugs by Maddes
//            defining impulses (moved to client.qc)
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            increasing axe damage in DM4 mode
//            and having unlimited ammo in DM4 mode
//            and electrocuting player when discharge into water in DM3, DM4 and DM5 modes
// 1999-02-02 Enhanced info system by Maddes
//            new impulses IMPULSE_CLIENT_INFO and IMPULSE_SERVER_INFO
//            and using information display functions
// 1999-02-02 Option: Toggle for previous optional functions by Maddes
//            new impulses IMPULSE_MONSTER_SKINS_MORE, IMPULSE_MONSTER_SKINS_LESS and IMPULSE_MONSTER_SKINS_RANDOM
// 1998-10-04 Hit outside water by a discharge fix by Maddes
//            using CanDamage
// 1998-08-14 Constantly checking all impulses fix by Perged/Kryten
//            checking .selfimpulse and using else
// 1998-07-24 Wrong obituary messages fix by Zoid
//            setting .deathtype for nails, grenades and rockets
//            using T_RadiusDamage
// 1998-07-29 Cheats coop fix by Maddes  start
//            allowing cheats in coop
// 1997-12-30 skin support by Maddes
//            new impulses IMPULSE_SKIN_NEXT, IMPULSE_SKIN_PREV
// 1997-12-26 auto-aim toggle by Maddes
//            new impulse IMPULSE_TOGGLE_AIM and recognizing toggle when firing

#include "directives.qh"

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore, string dtype) T_RadiusDamage;	// 1998-07-24 Wrong obituary messages fix by Zoid
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;


// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
		if (deathmatch > 3)
			T_Damage (trace_ent, self, self, 75);
		else
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		T_Damage (trace_ent, self, self, 20);
	}

	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
	// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;

	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);
	}

	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

// 1997-12-26 auto-aim toggle by Maddes  start
	local float save_aim;
	local string set_aim;

	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			save_aim = cvar("sv_aim");
			set_aim = ftos(save_aim);
		}

		cvar_set("sv_aim", "1");		// disable auto-aiming by setting sv_aim to 1
	}
// 1997-12-26 auto-aim toggle by Maddes  end

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);	

	self.punchangle_x = -2;
	
	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');

// 1997-12-26 auto-aim toggle by Maddes  start
	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			cvar_set("sv_aim", set_aim);	// reset sv_aim to previous setting
		}
		else
		{
			cvar_set("sv_aim", "0.93");	// set sv_aim to id's standard of 0.93
		}
	}
// 1997-12-26 auto-aim toggle by Maddes  end
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
// 1997-12-26 auto-aim toggle by Maddes  start
	local float save_aim;
	local string set_aim;

	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			save_aim = cvar("sv_aim");
			set_aim = ftos(save_aim);
		}

		cvar_set("sv_aim", "1");		// disable auto-aiming by setting sv_aim to 1
	}
// 1997-12-26 auto-aim toggle by Maddes  end

	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	self.punchangle_x = -4;
	
	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');

// 1997-12-26 auto-aim toggle by Maddes  start
	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			cvar_set("sv_aim", set_aim);	// reset sv_aim to previous setting
		}
		else
		{
			cvar_set("sv_aim", "0.93");	// set sv_aim to id's standard of 0.93
		}
	}
// 1997-12-26 auto-aim toggle by Maddes  end
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

// pOx - new explosion
void()	s_explode2_1	=	[0,		s_explode2_2] {self.nextthink = time+0.05;};
void()	s_explode2_2	=	[1,		s_explode2_3] {self.nextthink = time+0.05;};
void()	s_explode2_3	=	[2,		s_explode2_4] {self.nextthink = time+0.05;};
void()	s_explode2_4	=	[3,		s_explode2_5] {self.nextthink = time+0.05;};
void()	s_explode2_5	=	[4,		s_explode2_6] {self.nextthink = time+0.05;};
void()	s_explode2_6	=	[5,		s_explode2_7] {self.nextthink = time+0.05;};
void()	s_explode2_7	=	[6,		s_explode2_8] {self.nextthink = time+0.05;};
void()	s_explode2_8	=	[7,		s_explode2_9] {self.nextthink = time+0.05;};
void()	s_explode2_9	=	[8,		s_explode2_10] {self.nextthink = time+0.05;};
void()	s_explode2_10	=	[9,		s_explode2_11] {self.nextthink = time+0.05;};
void()	s_explode2_11	=	[10,	s_explode2_12] {self.nextthink = time+0.05;};
void()	s_explode2_12	=	[11,	SUB_Remove] {self.nextthink = time+0.05;};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
//	setmodel (self, "progs/s_explod.spr");
	setmodel (self, "progs/explod2.spr");// pOx - new explosion
	self.solid = SOLID_NOT;
	
//	s_explode1 ();
	s_explode2_1 ();// pOx - new explosion
};

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100 + random()*20;
	
	if (other.health)
	{
		other.deathtype = "rocket";	// 1998-07-24 Wrong obituary messages fix by Zoid
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other, "rocket");	// 1998-07-24 Wrong obituary messages fix by Zoid

	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity missile;

// 1997-12-26 auto-aim toggle by Maddes  start
	local float save_aim;
	local string set_aim;

	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			save_aim = cvar("sv_aim");
			set_aim = ftos(save_aim);
		}

		cvar_set("sv_aim", "1");		// disable auto-aiming by setting sv_aim to 1
	}
// 1997-12-26 auto-aim toggle by Maddes  end
	
	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
	// set missile speed	
	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_MissileTouch;
	
	// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

// 1997-12-26 auto-aim toggle by Maddes  start
	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			cvar_set("sv_aim", set_aim);	// reset sv_aim to previous setting
		}
		else
		{
			cvar_set("sv_aim", "0.93");	// set sv_aim to id's standard of 0.93
		}
	}
// 1997-12-26 auto-aim toggle by Maddes  end
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}

	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}

	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local   float           cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
		if (deathmatch > 3 && random() <= 0.5)
		{
			self.deathtype = "selfwater";
			T_Damage (self, self, self.owner, 35*cells );
		}
		else
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
// 1999-10-21 Correction: Discharge is an explosion by Zoid/Maddes  start
		{
			self.items = self.items - IT_LIGHTNING;	// lightning gun explodes and gets lost
			self.weapon = W_BestWeapon ();		// weapon for backpack

//			T_RadiusDamage (self, self, 35*cells, world, "discharge");	// 1998-07-24 Wrong obituary messages fix by Zoid
//											// 1998-10-04 Hit outside water by a discharge fix by Maddes
			T_RadiusDamage (self, self, 7*cells, world, "discharge");	// lowered explosion

			other = self;
			self = spawn();
			self.classname = "temp_explosion";
			setorigin(self, other.origin);
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_EXPLOSION);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
			BecomeExplosion ();
			self = other;
		}
// 1999-10-21 Correction: Discharge is an explosion by Zoid/Maddes  end
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 120, world, "grenade");	// 1998-07-24 Wrong obituary messages fix by Zoid

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

// 1999-09-05 Grenades bounce off skies fix by MaNiAc/Maddes  start
void() RespawnGrenade =
{
//NOTE: This is nearly a copy of a part from W_FireGrenade().
//I had to make a new grenade because using a null model for the old one would
//screw up its bouncing when the model was changed back, and if the grenade
//was left in its original position or placed in the void, it would still make
//the "splash" sound when it hit something.

	local entity	missile;

	missile = spawn ();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = self.solid;
	missile.classname = self.classname;
	missile.velocity = self.movedir;
	missile.avelocity = self.avelocity;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = self.touch;

	missile.think = self.use;
	missile.nextthink = self.attack_finished;

	setmodel (missile, self.mdl);
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.oldorigin);

	remove (self);
};

void() FindNewGrenadePosition =
{
// calculate the way the grenade would fly outside and where it reenters the level

	local float	checks, maxchecks, del, contents, realtime, maxtime;
	local vector	pos, newvel, lastinsolid;

	maxtime = self.nextthink - time;	//find time until grenade will explode
	del = 0.05;				//delay time between checks(seems to be the maximum acceptable)
	maxchecks = ceil(maxtime/del);		//max number before grenade would blow up anyway

	checks = 0;
	pos = self.origin;
	newvel = self.velocity;			//I can use this because bouncing velocity is
						//not changed until after the touch function is called

	do
	{
		newvel_z = newvel_z - cvar("sv_gravity")*del;	//account for gravity
		pos = pos + newvel*del;				//measure where grenade should now be each time increment
		contents = pointcontents (pos);
		if (contents == CONTENT_SOLID)
			lastinsolid = pos;	//record this to make grenade explode
						//even if it never enters the level again
		checks = checks + 1;
	} while (((contents == CONTENT_SKY) ||
		  (contents == CONTENT_SOLID)) &&
		  (checks < maxchecks));

	realtime = checks*del;				//find time the grenade will "take" to fall
	traceline (pos, pos - newvel*0.2, TRUE, self);	//trace to see if grenade
							//has fallen out of sky (and not the ceiling)
	if (trace_fraction < 1)
			trace_endpos = trace_endpos + normalize(newvel);	//move endpos forward so it is not on a wall

	if ((contents != CONTENT_SKY) &&
	    (contents != CONTENT_SOLID) &&
	    (pointcontents(trace_endpos) == CONTENT_SKY))
	{
		self.mdl = self.model;
		setmodel (self, string_null);

		self.movetype = MOVETYPE_NONE;
		self.movedir = newvel;			//store new velocity
		self.oldorigin = pos;			//store new position
		self.attack_finished = self.nextthink;	//store nextthink

		self.use = self.think;			//store think
		self.think = RespawnGrenade;
		self.nextthink = time + realtime;	//time when grenade should fall from sky
	}
	else
	{
		if (lastinsolid)	//the grenade will explode where it was last in a solid
					//(usually either way out in the void or right above a ceiling)
		{
			setmodel (self, string_null);
			self.movetype = MOVETYPE_NONE;
			setorigin (self, lastinsolid);
		}
		else
			remove (self);	//remove if all else fails (this should theoretically never happen)
	}
};
// 1999-09-05 Grenades bounce off skies fix by MaNiAc/Maddes  end

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}

// 1999-09-05 Grenades bounce off skies fix by MaNiAc/Maddes  start
	if (pointcontents (self.origin) == CONTENT_SKY)
	{
		FindNewGrenadePosition ();
		return;
	}
// 1999-09-05 Grenades bounce off skies fix by MaNiAc/Maddes  end

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound

	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local	entity missile;

// 1997-12-26 auto-aim toggle by Maddes  start
	local float save_aim;
	local string set_aim;

	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			save_aim = cvar("sv_aim");
			set_aim = ftos(save_aim);
		}

		cvar_set("sv_aim", "1");		// disable auto-aiming by setting sv_aim to 1
	}
// 1997-12-26 auto-aim toggle by Maddes  end
	
	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed	

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;


	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenadeTouch;
	
	// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);

// 1997-12-26 auto-aim toggle by Maddes  start
	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			cvar_set("sv_aim", set_aim);	// reset sv_aim to previous setting
		}
		else
		{
			cvar_set("sv_aim", "0.93");	// set sv_aim to id's standard of 0.93
		}

	}
// 1997-12-26 auto-aim toggle by Maddes  end
};


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector	dir;

// 1997-12-26 auto-aim toggle by Maddes  start
	local float save_aim;
	local string set_aim;

	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			save_aim = cvar("sv_aim");
			set_aim = ftos(save_aim);
		}

		cvar_set("sv_aim", "1");		// disable auto-aiming by setting sv_aim to 1
	}
// 1997-12-26 auto-aim toggle by Maddes  end
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;

// 1997-12-26 auto-aim toggle by Maddes  start
	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			cvar_set("sv_aim", set_aim);	// reset sv_aim to previous setting
		}
		else
		{
			cvar_set("sv_aim", "0.93");	// set sv_aim to id's standard of 0.93
		}
	}
// 1997-12-26 auto-aim toggle by Maddes  end
};

void(float ox) W_FireSpikes =
{
	local vector	dir;
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// 1997-12-26 auto-aim toggle by Maddes  start
	local float save_aim;
	local string set_aim;

	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			save_aim = cvar("sv_aim");
			set_aim = ftos(save_aim);
		}

		cvar_set("sv_aim", "1");		// disable auto-aiming by setting sv_aim to 1
	}
// 1997-12-26 auto-aim toggle by Maddes  end

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	if (deathmatch != 4)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
	spawn_ngspark(ox);// pOx - throw a spark


// 1997-12-26 auto-aim toggle by Maddes  start
	if (self.autoaim_off)
	{
		if (correct_cvars)
		{
			cvar_set("sv_aim", set_aim);	// reset sv_aim to previous setting
		}
		else
		{
			cvar_set("sv_aim", "0.93");	// set sv_aim to id's standard of 0.93
		}
	}
// 1997-12-26 auto-aim toggle by Maddes  end
};

void() spike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		other.deathtype = "nail";	// 1998-07-24 Wrong obituary messages fix by Zoid
		T_Damage (other, self, self.owner, 9);
	}

	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);

		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);

		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);

		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		other.deathtype = "supernail";	// 1998-07-24 Wrong obituary messages fix by Zoid
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetCurrentAmmo =
{
	if (self.health > 0)		// 1998-08-12 avoiding ghosts by Athos
	player_run ();		// get out of any weapon firing states
	self.weaponframe = 0;

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
	}
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )

		return IT_LIGHTNING;
	else if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	else if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	else if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	else if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;

	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
	// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);		// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();

		else if (r<0.5)
			player_axeb1 ();

		else if (r<0.75)
			player_axec1 ();

		else
			player_axed1 ();
		self.attack_finished = time + 0.5;
	}

	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}

	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}

	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}

	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}

	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}

	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}

	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
	local	float	it, am, fl;
	
	fl = it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}

	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;

		if (self.ammo_shells < 1)
			am = 1;
	}

	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;

		if (self.ammo_shells < 2)
			am = 1;
	}		

	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;

		if (self.ammo_nails < 1)
			am = 1;
	}

	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;

		if (self.ammo_nails < 2)
			am = 1;
	}

	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;

		if (self.ammo_rockets < 1)
			am = 1;
	}

	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}

	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}
	
	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = fl;		
	W_SetCurrentAmmo ();
};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
// 1998-07-29 Cheats coop fix by Maddes  start
//	if (deathmatch || coop)
	if (deathmatch && !developer)
// 1998-07-29 Cheats coop fix by Maddes  end
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}

		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;

			if (self.ammo_shells < 1)
				am = 1;
		}

		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;

			if (self.ammo_shells < 2)
				am = 1;
		}		

		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;

			if (self.ammo_nails < 1)
				am = 1;
		}

		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;

			if (self.ammo_nails < 2)
				am = 1;
		}

		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;

			if (self.ammo_rockets < 1)
				am = 1;
		}

		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;

			if (self.ammo_rockets < 1)
				am = 1;
		}

		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;

			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (self.items & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};


/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local float it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;

			if (self.ammo_rockets < 1)
			am = 1;
		}
	
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;

			if (self.ammo_rockets < 1)
			am = 1;
		}

		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;

			if (self.ammo_nails < 2)
			am = 1;
		}

		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;

			if (self.ammo_nails < 1)
			am = 1;
		}

		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;

			if (self.ammo_shells < 2)
			am = 1;
		}

		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;

			if (self.ammo_shells < 1)
			am = 1;
		}

		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}

		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;

			if (self.ammo_cells < 1)
			am = 1;
		}

		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};



/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
// 1998-07-29 Cheats coop fix by Maddes  start
	if (deathmatch)
		return;
// 1998-07-29 Cheats coop fix by Maddes  end
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
// 1998-07-29 Cheats coop fix by Maddes  start
//	if (deathmatch || coop)
	if (deathmatch)
// 1998-07-29 Cheats coop fix by Maddes  end
		return;

	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == 9)
		CheatCommand ();
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == 10)
		CycleWeaponCommand ();
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == 11)
		ServerflagsCommand ();
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == 12)
		CycleWeaponReverseCommand();
	else	// 1998-08-14 Constantly checking all impulses fix by Kryten
	if (self.impulse == 255)
		QuadCheat ();
		
	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	if (self.impulse)	// gb, stop wasting performance
		ImpulseCommands ();
	
	// check for attack
	if (self.button0)
	{
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  start
#ifdef DEBUG_SHOTS
		dprint(self.netname);
		dprint(" shoots on ");
		dprint(ftos(time));
		dprint(" time and frame ");
		dprint(ftos(framecount));
		dprint("\n");

		local entity	thing;
		thing = find (world, classname, "debug_shots");
		while (thing != world)
		{
			thing.count = thing.count + 1;
			thing = find (thing, classname, "debug_shots");
		}
#endif
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  end
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};


