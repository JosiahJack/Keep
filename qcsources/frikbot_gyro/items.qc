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

//qb: from urqp
// 2000-07-02 Fire key targets only once by Spinal/Maddes
//            using additional flag (.deadflag)
// 1999-10-17 Delayed powerups on map start by Maddes  start
//            delaying powerup spawning
// 1999-08-13 Missing parameters fix by Maddes
//            adding missing parameters
// 1999-07-10 Enhanced item_weapon function by Athos
//            enhancing item_weapon function
// 1999-05-04 Stating which items fell out of level by Lord Sméagol/Maddes
//            displaying classname
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            recognizing QctaPower
//            and removing cells/armor when pickung up OctaPower in DM4 mode
//            and players not picking up health/armor/backpack when having pentagram in DM4 mode
//            and megahealth not rotting/respawning in DM4 mode
//            and weapons stay in DM3 mode
//            and no weapons in DM4 and DM5 modes
//            and ammo respawns after 15 seconds in DM3 and DM5 modes
//            and no ammo in DM4 mode
//            and giving 10 additional health when picking up backpacks in DM4 mode up to 300
//            and giving quad/pent when reaching 300 health in DM4 mode
//            and having a minium of 5 rockets when picking up backpacks in DM3 und DM5 modes
//            and dropping backpack in axeonly matches in DM4 mode, although no ammo to drop
// 1999-02-04 Option: Drop Quad/Ring by Zoid/Maddes
//            defining new functions for dropping a quad/ring and touching a lost quad/ring
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol
//            using .weapon/.items in if-clauses instead of .classname
// 1998-10-03 Some weapon name corrections
//            correcting some weapon names
// 1998-08-15 Improved weapon switching on pickups by Maddes
//            for weapon, ammo and backpack
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes
//            for health, armor, weapon, ammo and keys
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos
//            using an extra entity to rot down health instead of megahealth entities
// 1998-07-23 Better performance in handling of powerups by Maddes
//            new handling of powerups (eyes model, quad/pentagram glow)
// 1998-01-04 event skin support by Maddes
//            setting event skin on powerup pickup
// 1997-12-30 skin support by Maddes
//            setting skin 0 on powerup pickup (ring of shadows)
// 1997-12-23 Thunderbolt fix by Maddes
//            correct weapon selection (don't switch to thunderbolt underwater)
//            for SinglePlayer/Coop and DeathMatch

#include "directives.qh"	// 2001-04-22 by Maddes

void() W_SetCurrentAmmo;
/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */


void() SUB_regen =
{
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
};



/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void() noclass =
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};

// 1999-02-04 Option: Drop Quad/Ring by Zoid/Maddes  start
void() q_touch =
{
	local float	s;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	self.mdl = self.model;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | IT_QUAD;
	self.model = string_null;

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		other.armortype = 0;
		other.armorvalue = 0;	// * 0.01;
		other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		other.ammo_cells = 0;

		local entity stemp;
		stemp = self;
		self = other;
		W_SetCurrentAmmo();
		self = stemp;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

// do the apropriate action
	s=rint(self.cnt - time);	// time fix by Maddes
	bprint (other.netname);

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
		bprint (" recovered an OctaPower with ");
	else
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		bprint (" recovered a Quad with ");
	bprint (ftos(s));
	if (s == 1)
		bprint(" second remaining");
	else
		bprint(" seconds remaining");

	other.super_time = 1;
	if (other.super_damage_finished <= time)	// time fix by Maddes
	{
		other.super_damage_finished = self.cnt;
	}
	else
	{
		other.super_damage_finished = other.super_damage_finished + (self.cnt - time);
		if (other.super_damage_finished > time + 30)
			other.super_damage_finished = time + 30;

		s=rint(other.super_damage_finished - time);
		bprint(" for a total of ");
		bprint(ftos(s));
		if (s == 1)
			bprint(" second");
		else
			bprint(" seconds");
	}
	bprint("\n");
	other.effects = other.effects | EF_DIMLIGHT;	// 1998-07-23 Better performance in handling of powerups by Maddes

	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};

void(float timeleft) DropQuad =
{
	local entity    item;

	item = spawn();
	item.origin = self.origin;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.noise = "items/damage.wav";
	setmodel (item, "progs/quaddama.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.cnt = time + timeleft;
	item.touch = q_touch;
	item.nextthink = time + timeleft;    // remove it with the time left on it
	item.think = SUB_Remove;
};

void() r_touch =
{
	local float	s;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	self.mdl = self.model;

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | IT_INVISIBILITY;
	self.model = string_null;

// do the apropriate action
	s=rint(self.cnt - time);
	bprint (other.netname);
	bprint (" recovered a ring with ");
	bprint (ftos(s));
	if (s == 1)
		bprint(" second remaining");
	else
		bprint(" seconds remaining");

	other.invisible_time = 1;
	if (other.invisible_finished <= time)	// time fix by Maddes
	{
		other.invisible_finished = self.cnt;
	}
	else
	{
		other.invisible_finished = other.invisible_finished + (self.cnt - time);
		if (other.invisible_finished > time + 30)
			other.invisible_finished = time + 30;

		s=rint(other.invisible_finished - time);
		bprint(" for a total of ");
		bprint(ftos(s));
		if (s == 1)
			bprint(" second");
		else
			bprint(" seconds");
	}
	bprint("\n");
	SetSkin(other);		// 1997-12-30 skin support by Maddes
// 1998-07-23 Better performance in handling of powerups by Maddes  start
	other.frame = 0;
	other.modelindex = modelindex_eyes;
// 1998-07-23 Better performance in handling of powerups by Maddes  end

	activator = other;
	SUB_UseTargets();                               // fire all targets / killtargets
};

void(float timeleft) DropRing =
{
	local entity    item;

	item = spawn();
	item.origin = self.origin;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.noise = "items/inv1.wav";
	setmodel (item, "progs/invisibl.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.cnt = time + timeleft;
	item.touch = r_touch;
	item.nextthink = time + timeleft;    // remove after 30 seconds
	item.think = SUB_Remove;
};
// 1999-02-04 Option: Drop Quad/Ring by Zoid/Maddes  end


/*
============
PlaceItem

plants the object on the floor
============*/
void() PlaceItem =
{
	local float	oldz;

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor(0,0))		// 1999-08-13 Missing parameters fix by Maddes
	{
// 1999-05-04 Stating which items fell out of level by Lord Sméagol/Maddes  start
//		dprint ("Bonus item fell out of level at ");
		dprint ("Bonus item \"");
		dprint (self.classname);	// 2000-06-27 Corrected
		dprint ("\" fell out of level at ");
// 1999-05-04 Stating which items fell out of level by Lord Sméagol/Maddes  end
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}

// 1999-10-17 Delayed powerups on map start by Maddes  start
	if (deathmatch && (savedgamecfg & SAVEDGAMECFG_DELAYED_POWERUPS))
	{
		if ((self.items == IT_INVULNERABILITY)
		||  (self.items == IT_INVISIBILITY)
		||  (self.items == IT_QUAD))
		{
			self.model = string_null;
			self.solid = SOLID_NOT;

			self.think = SUB_regen;
			self.nextthink = time + 15 + 4*(random() - 0.5);
		}
	}
// 1999-10-17 Delayed powerups on map start by Maddes  end
};

/*============
StartItem

Sets the clipping size and plants the object on the floor
============*/
void() StartItem =
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

/*=========================================================================

HEALTH BOX

=========================================================================*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float (entity e, float healamount, float ignore) T_Heal =
{
	if (e.health <= 0)
		return 0;

	if ((!ignore) && (e.health >= other.max_health))
		return 0;

	healamount = ceil(healamount);

	e.health = e.health + healamount;

	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;
		
	if (e.health > 250)
		e.health = 250;

	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

float	H_ROTTEN = 1;
float	H_MEGA = 2;
.float	healamount, healtype;
void() health_touch;
void() item_megahealth_rot;

void() item_health =
{	
	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");

		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}

	else if (self.spawnflags & H_MEGA)
	{
		precache_model("maps/b_bh100.bsp");
		precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}

	else
	{
		precache_model("maps/b_bh25.bsp");
		precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}

	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  start
void(entity rotowner, float oldhealth) MakeHealthRot =
{
	local entity rot;
	rot = spawn ();
	rot.classname = "health_rot";
	rot.nextthink = time + 5;
	rot.think = item_megahealth_rot;
	rot.owner = rotowner;

	rot.max_health = oldhealth;	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
					// megahealth now works correctly with additional health on respawn
};
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  end

void() health_touch =
{
	local	string	s;
	local float	donttake;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes
	local float	oldhealth;	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
					// megahealth now works correctly with additional health on respawn

	
	if (other.classname != "player")
		return;
	
	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
		if (other.invincible_time > 0)
//			return;
			donttake = 1;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		oldhealth = other.health;	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
						// megahealth now works correctly with additional health on respawn

		if (other.health >= 250)
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
		else
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
		if (!T_Heal(other, self.healamount, 1))
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
	}

	else
	{
		if (!T_Heal(other, self.healamount, 0))
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
	}
	
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
	if (!donttake)
	{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

	sprint(other, "You receive ");
	s = ftos(self.healamount);
	sprint(other, s);
	sprint(other, " health\n");
	
	// health touch sound
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

	stuffcmd (other, "bf\n");
	
	self.model = string_null;
	self.solid = SOLID_NOT;

	// Megahealth = rot down the player's super health
	if (self.healtype == 2)
	{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
		if (deathmatch != 4)
		{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  start
			local entity	stemp;

			// search player's health rot entity
			stemp = find (world, classname, "health_rot");
			while ( (stemp!=world) && (stemp.owner != other) )
			{
				stemp = find(stemp,classname,"health_rot");
			}

			if (stemp)
			{
				// delay health rotting again
				stemp.nextthink = time + 5;
				stemp.think = item_megahealth_rot;
			}
			else
				MakeHealthRot(other, oldhealth);	// create rot entity
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  end
		other.items = other.items | IT_SUPERHEALTH;
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  start
/*
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
*/
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
//			if (deathmatch == 1)	// deathmatch 2 is silly old rules
			if (deathmatch && deathmatch != 2)
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
			{
				self.nextthink = time + self.healamount + 25;	// delay (5) + health + respawn wait (20)
				self.think = SUB_regen;
			}
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  end
		}	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	}

	else
	{
		if (deathmatch != 2)		// deathmatch 2 is the silly old rules
		{
			if (deathmatch)
				self.nextthink = time + 20;
			self.think = SUB_regen;
		}
	}
	
	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};	

void() item_megahealth_rot =
{
	other = self.owner;
	
	if ((other.health > other.max_health)
	   && (other.health > self.max_health))	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
						// megahealth now works correctly with additional health on respawn
		other.health = other.health - 1;

	if ((other.health > other.max_health)
	   && (other.health > self.max_health))	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
						// megahealth now works correctly with additional health on respawn
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;

		return;
	}

	// it is possible for a player to die and respawn between rots, so don't
	// just blindly subtract the flag off
	other.items = other.items - (other.items & IT_SUPERHEALTH);
	
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  start
	remove (self);
/*
	if (deathmatch == 1)	// deathmatch 2 is silly old rules
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
*/
// 1998-08-11 Multiple megahealth rot down too fast fix by Maddes/Athos  end
};

/*===============================================================================

ARMOR

===============================================================================*/

void() armor_touch =
{
	local	float	type, value, bit;
	local float	donttake;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes
	
	if (other.health <= 0)
		return;

	if (other.classname != "player")
		return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}

	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}

	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}

	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

	if (other.armortype*other.armorvalue >= type*value)
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//		return;
		donttake = 1;
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 && other.invincible_time > 0)
		donttake = 1;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
	if (!donttake)
	{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
		
	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

	self.solid = SOLID_NOT;
	self.model = string_null;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
//	if (deathmatch == 1)
	if (deathmatch && deathmatch != 2)
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		self.nextthink = time + 20;

	self.think = SUB_regen;

	sprint(other, "You got armor\n");
	// armor touch sound
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	
	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)*/

void() item_armor1 =
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)*/

void() item_armor2 =
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)*/

void() item_armorInv =
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

void() bound_other_ammo =
{
	if (other.ammo_shells > 100)
		other.ammo_shells = 100;

	if (other.ammo_nails > 200)
		other.ammo_nails = 200;

	if (other.ammo_rockets > 100)
		other.ammo_rockets = 100;		

	if (other.ammo_cells > 100)
		other.ammo_cells = 100;		
};

// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//float(float w) RankForWeapon =
float(entity ent, float w) RankForWeapon =
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
{
	if (w == IT_LIGHTNING && ent.waterlevel <= 1)		// 1997-12-23 Thunderbolt fix by Maddes  recognize waterlevel
		return 1;

	if (w == IT_ROCKET_LAUNCHER)
		return 2;

	if (w == IT_SUPER_NAILGUN)
		return 3;

	if (w == IT_GRENADE_LAUNCHER)
		return 4;

	if (w == IT_SUPER_SHOTGUN)
		return 5;

	if (w == IT_NAILGUN)
		return 6;

	return 7;
};

/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//void(float old, float new) Deathmatch_Weapon =
void(entity ent, float new) Deathmatch_Weapon =
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
{
	local float or, nr;

	// change self.weapon if desired
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//	or = RankForWeapon (self.weapon);
//	nr = RankForWeapon (new);
	or = RankForWeapon (ent, ent.weapon);
	nr = RankForWeapon (ent, new);
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
	if ( nr < or )
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//		self.weapon = new;
		ent.weapon = new;
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
};

/*=============
weapon_touch
=============*/
float() W_BestWeapon;

void() weapon_touch =
{
//	local float	hadammo;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes
//	local float	old;		// 1998-08-15 Improved weapon switching on pickups by Maddes
//	local float	new;		// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol
	local float	best;
	local	entity	stemp;
	local	float	leave;
	local float	donttake;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	if (!(other.flags & FL_CLIENT))
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	if (deathmatch == 2 || deathmatch == 3 || coop)	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
		leave = 1;

	else
		leave = 0;
	
	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//            *** This is a total rewrite ***
	if (leave && (other.items & self.weapon))	// weapons stay = no ammo check
		donttake = 1;
	else if (self.weapon == IT_AXE)
	{
		if (other.items & self.weapon)
			donttake = 1;
	}
	else if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN)
	{
		if ((other.items & self.weapon) && (other.ammo_shells >= 100))
			donttake = 1;
		else
		other.ammo_shells = other.ammo_shells + 5;
	}
	else if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN)
	{
		if ((other.items & self.weapon) && (other.ammo_nails >= 200))
			donttake = 1;
		else
			other.ammo_nails = other.ammo_nails + 30;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER || self.weapon == IT_GRENADE_LAUNCHER)
	{
		if ((other.items & self.weapon) && (other.ammo_rockets >= 100))
			donttake = 1;
		else
		other.ammo_rockets = other.ammo_rockets + 5;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		if ((other.items & self.weapon) && (other.ammo_cells >= 100))
			donttake = 1;
		else
		other.ammo_cells = other.ammo_cells + 15;
	}
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	else
		objerror ("weapon_touch: unknown classname");

// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
	if (!donttake)
	{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
	// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

	// change to the weapon
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//	old = other.items;
// ...always if new one
		if ( !other.items & self.weapon)
			Deathmatch_Weapon (other, self.weapon);
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
	other.items = other.items | self.weapon;
	
	stemp = self;
	self = other;

// 1997-12-23 Thunderbolt fix by Maddes  start
/* don't seperate between SinglePlayer/Coop and Deathmatch
	if (!deathmatch)
		self.weapon = new;

	else
*/
// 1997-12-23 Thunderbolt fix by Maddes  end
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//		Deathmatch_Weapon (old, new);
		if ( other.weapon == best )
		{
			self.weapon = W_BestWeapon();
		}
// 1998-08-15 Improved weapon switching on pickups by Maddes  end

	W_SetCurrentAmmo();

	self = stemp;

// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//	if (leave)
//		return;
	if (!leave)
	{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

	// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
//		if (deathmatch == 1)
		if (deathmatch && deathmatch!=2 && deathmatch!=3)
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
			self.nextthink = time + 30;
		self.think = SUB_regen;

	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supershotgun =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 || deathmatch == 5)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_nailgun =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 || deathmatch == 5)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Nailgun";	// 1998-10-03 Some weapon name corrections
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_supernailgun =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 || deathmatch == 5)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_grenadelauncher =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 || deathmatch == 5)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	self.weapon = 3;
	self.weapon = IT_GRENADE_LAUNCHER;
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_rocketlauncher =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 || deathmatch == 5)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	self.weapon = 3;
	self.weapon = IT_ROCKET_LAUNCHER;
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_lightning =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 || deathmatch == 5)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	self.weapon = 3;
	self.weapon = IT_LIGHTNING;
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
};


/*
===============================================================================

AMMO

===============================================================================
*/

void() ammo_touch =
{
	local entity	stemp;
	local float		best;
	local float	donttake;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	donttake = 0;	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
		else
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

	// spikes
	else if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
		else
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

	//	rockets
	else if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
		else
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

	//	cells
	else if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//			return;
			donttake = 1;
		else
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
	if (!donttake)
	{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

	bound_other_ammo ();
	
	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
	// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	// change to a better weapon if appropriate
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
	stemp = self;
	self = other;
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
	if ( other.weapon == best )
	{
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//		stemp = self;
//		self = other;
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
		self.weapon = W_BestWeapon();
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//		W_SetCurrentAmmo ();
//		self = stemp;
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
	}

	// if changed current ammo, update it
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//	stemp = self;
//	self = other;
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
	W_SetCurrentAmmo();
	self = stemp;

	// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
// Xian -- If playing in DM 3.0 mode, halve the time ammo respawns
	if (deathmatch == 3 || deathmatch == 5)
		self.nextthink = time + 15;
//	if (deathmatch == 1)
	else if (deathmatch && deathmatch != 2)
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		self.nextthink = time + 30;
	
	self.think = SUB_regen;

	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};




float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big*/

void() item_shells =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}

	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}

	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big*/

void() item_spikes =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}

	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}

	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void() item_rockets =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}

	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}

	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big*/

void() item_cells =
{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		remove(self);
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}

	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}

	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!*/

float WEAPON_SHOTGUN = 1;
float WEAPON_ROCKET = 2;
float WEAPON_SPIKES = 4;
float WEAPON_BIG = 8;
void() item_weapon =
{
// 1999-07-10 Enhanced item_weapon function by Athos  start
//            *** This is a total rewrite ***
	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		self.spawnflags = self.spawnflags - WEAPON_SHOTGUN;	// remove old flag
		if (self.spawnflags & WEAPON_BIG)
		{
			self.spawnflags = self.spawnflags - WEAPON_BIG;	//remove old flag
			self.spawnflags = self.spawnflags | WEAPON_BIG2;
		}
		self.classname = "item_shells";
		item_shells();
	}
	else if (self.spawnflags & WEAPON_ROCKET)
	{
		self.spawnflags = self.spawnflags - WEAPON_ROCKET;	// remove old flag
		if (self.spawnflags & WEAPON_BIG)
		{
			self.spawnflags = self.spawnflags - WEAPON_BIG;	//remove old flag
			self.spawnflags = self.spawnflags | WEAPON_BIG2;
		}
		self.classname = "item_rockets";
		item_rockets();
	}
	else if (self.spawnflags & WEAPON_SPIKES)
	{
		self.spawnflags = self.spawnflags - WEAPON_SPIKES;	// remove old flag
		if (self.spawnflags & WEAPON_BIG)
		{
			self.spawnflags = self.spawnflags - WEAPON_BIG;	//remove old flag
			self.spawnflags = self.spawnflags | WEAPON_BIG2;
		}
		self.classname = "item_spikes";
		item_spikes();
	}
// 1999-07-10 Enhanced item_weapon function by Athos  end
};


/*
===============================================================================

KEYS

===============================================================================
*/

void() key_touch =
{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes
//	local entity	stemp;
//	local float	best;
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  start
//	if (other.items & self.items)
//		return;
	if (!other.items & self.items)
	{
// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes  end

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = other.items | self.items;

	if (!coop)
	{	
		self.solid = SOLID_NOT;
		self.model = string_null;
	}

	}	// 1998-08-15 Do not take unnecessary items but fire all targets by Maddes

// 2000-07-02 Fire key targets only once by Spinal/Maddes  start
	if (!self.deadflag)
	{
		self.deadflag = 1;	// only fired once
// 2000-07-02 Fire key targets only once by Spinal/Maddes  end
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	}		// 2000-07-02 Fire key targets only once by Spinal/Maddes
};


void() key_setsounds =
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}

	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}

	if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base*/

void() item_key1 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}

	else if (world.worldtype == 1)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}

	else if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_s_key.mdl");
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}

	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base*/

void() item_key2 =
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}

	if (world.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}

	if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}

	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

void() sigil_touch =
{

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	centerprint (other, "You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";		// so rune doors won't find it
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

void() item_sigil =
{
	if (!self.spawnflags)
		objerror ("no spawnflags");

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
	}

	if (self.spawnflags & 2)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
	}

	if (self.spawnflags & 4)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
	}

	if (self.spawnflags & 8)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
	}
	
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*
===============================================================================

POWERUPS

===============================================================================
*/

void() powerup_touch;


void() powerup_touch =
{
	local	entity	stemp;

	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;
		
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//		if ((self.classname == "item_artifact_invulnerability") ||
//			(self.classname == "item_artifact_invisibility"))
		if ((self.items == IT_INVULNERABILITY) ||
			(self.items == IT_INVISIBILITY))
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
			self.nextthink = time + 60*5;
		else
			self.nextthink = time + 60;
		
		self.think = SUB_regen;
	}	

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

	// do the apropriate action
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	if (self.classname == "item_artifact_envirosuit")
	if (self.items == IT_SUIT)
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
		SetSkin(other);		// 1998-01-04 event skin support by Maddes  set biosuit skin
	}
	
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	if (self.classname == "item_artifact_invulnerability")
	if (self.items == IT_INVULNERABILITY)
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
		other.effects = other.effects | EF_DIMLIGHT;	// 1998-07-23 Better performance in handling of powerups by Maddes
	}
	
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	if (self.classname == "item_artifact_invisibility")
	if (self.items == IT_INVISIBILITY)
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
		SetSkin(other);		// 1997-12-30 skin support by Maddes
// 1998-07-23 Better performance in handling of powerups by Maddes  start
		other.frame = 0;
		other.modelindex = modelindex_eyes;
// 1998-07-23 Better performance in handling of powerups by Maddes  end
	}

// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  start
//	if (self.classname == "item_artifact_super_damage")
	if (self.items == IT_QUAD)
// 1998-12-24 Improved weapon and powerup touch functions by Maddes/Sméagol  end
	{
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
		if (deathmatch == 4)
		{
			other.armortype = 0;
			other.armorvalue = 0;	// * 0.01;
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
			other.ammo_cells = 0;

			stemp = self;
			self = other;
			W_SetCurrentAmmo();
			self = stemp;
		}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

		other.super_time = 1;
		other.super_damage_finished = time + 30;
		other.effects = other.effects | EF_DIMLIGHT;	// 1998-07-23 Better performance in handling of powerups by Maddes
	}	

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};



/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds*/
void() item_artifact_invulnerability =
{
	self.touch = powerup_touch;

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds*/
void() item_artifact_envirosuit =
{
	self.touch = powerup_touch;

	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds*/
void() item_artifact_invisibility =
{
	self.touch = powerup_touch;

	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage*/
void() item_artifact_super_damage =
{
	self.touch = powerup_touch;

	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
		self.netname = "OctaPower";
	else
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

//the entirety of BackpackTouch
//copypasta'd directly from gpl'd qw source on github.
void() BackpackTouch =
{
	local string    s;
	local float	best, new;
//	local float	old;		// 1998-08-15 Improved weapon switching on pickups by Maddes
	local           entity  stemp;
	local   float   acount;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4 && other.invincible_time > 0)
		return;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		
	acount = 0;
	sprint (other, "You get ");

// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if (deathmatch == 4)
	{
		other.health = other.health + 10;
		sprint (other, "10 additional health\n");
		if ((other.health > 250) && (other.health < 300))
			sound (other, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
		else
			sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
		stuffcmd (other, "bf\n");
		remove(self);

		if (other.health >299)
		{
			other.invincible_time = 1;
			other.invincible_finished = time + 30;
			other.items = other.items | IT_INVULNERABILITY;

			other.super_time = 1;
			other.super_damage_finished = time + 30;
			other.items = other.items | IT_QUAD;

			other.effects = other.effects | EF_DIMLIGHT;	// 1998-07-23 Better performance in handling of powerups by Maddes

			other.armortype = 0;
			other.armorvalue = 0;	// * 0.01;
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
			other.ammo_cells = 0;

			stemp = self;
			self = other;
			W_SetCurrentAmmo();
			self = stemp;

			sound (other, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
			stuffcmd (other, "bf\n");
			bprint (other.netname);
			bprint (" attains bonus powers!!!\n");
		}
		self = other;
		return;
	}
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	if (self.items)
		if ((other.items & self.items) == 0)
		{
			acount = 1;
			sprint (other, "the ");
			sprint (other, self.netname);
		}
 
	// if the player was using his best weapon, change up to the new one if better          
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

	// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;

	new = self.items;
	if (!new)
		new = other.weapon;
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//	old = other.items;
// ...always if new one
	if (!other.items & new)
		Deathmatch_Weapon (other, new);
// 1998-08-15 Improved weapon switching on pickups by Maddes  end
	other.items = other.items | new;
	
	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");	

		acount = 1;
		s = ftos(self.ammo_shells);
		sprint (other, s);
		sprint (other, " shells");
	}

	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		s = ftos(self.ammo_nails);
		sprint (other, s);
		sprint (other, " nails");
	}

	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint (other, s);
		sprint (other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");

		acount = 1;
		s = ftos(self.ammo_cells);
		sprint (other, s);
		sprint (other, " cells");
	}
	
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
	if ( (deathmatch==3 || deathmatch==5) && ( new==IT_GRENADE_LAUNCHER || new==IT_ROCKET_LAUNCHER ) && (other.ammo_rockets < 5) )
		other.ammo_rockets = 5;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

	sprint (other, "\n");

	// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// remove the backpack, change self to the player
	remove(self);
	self = other;
	
	// change to the weapon
// 1997-12-23 Thunderbolt fix by Maddes  start
/* don't seperate between SinglePlayer/Coop and Deathmatch
	if (!deathmatch)
		self.weapon = new;
		else
*/
// 1997-12-23 Thunderbolt fix by Maddes  end
// 1998-08-15 Improved weapon switching on pickups by Maddes  start
//		Deathmatch_Weapon (old, new);
		if ( other.weapon == best )
		{                
			self.weapon = W_BestWeapon();
		}
// 1998-08-15 Improved weapon switching on pickups by Maddes  end

	W_SetCurrentAmmo ();

};


/*===============
DropBackpack
===============*/
void() DropBackpack =
{
	local entity    item;

	if (!(deathmatch == 4 && axeonly))	// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return; // nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';
	
	item.items = self.weapon;

	if (item.items == IT_AXE)
		item.netname = "Axe";

	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";

	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";

	else if (item.items == IT_NAILGUN)
		item.netname = "Nailgun";

	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";

	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";

	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";

	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";

	else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	item.nextthink = time + 120;    // remove after 2 minutes
	item.think = SUB_Remove;
};