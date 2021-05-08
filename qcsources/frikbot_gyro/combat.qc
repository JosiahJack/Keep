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

//qb: add urqc items
// 2001-08-30 Negative damage ("healing") fix by Maddes
//            recognizing negative damage in t_damage function
// 2001-08-01 No silmultaneous shots fix by Maddes
//            restructuring t_damage function
// 1999-02-04 Doors no quad power fix by Zoid
//            recognizing doors
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            recognizing OctaPower in DM4 mode
// 1998-10-04 Hit outside water by a discharge fix by Maddes
//            recognizing a discharge in CanDamage
//            and using CanDamage in T_RadiusDamage plus T_BeamDamage
// 1998-09-16 CanDamage fix by Maddes/Kryten
//            checking half-sized bounding box
// 1998-08-12 Option: Drowning doesn't hurt armor by Maddes/Athos
//            recognizing new deathtype in T_Damage function
// 1998-07-24 Wrong obituary messages fix by Zoid
//            expanding T_RadiusDamage function with parameter dtype
// 1998-07-29 Teamplay 1 fix by Maddes
//            players hurting themselves
// 1998-07-07 T_RadiusDamage workaround by Robert Field
//            hurting attacker after all other players in T_RadiusDamage()

#include "directives.qh"	// 2001-04-22 by Maddes

void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============*/

float(entity targ, entity inflictor) CanDamage =
{
	// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;

		if (trace_ent == targ)
			return TRUE;

		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);

// 1998-10-04 Hit outside water by a discharge fix by Maddes  start
//	if (dtype == "discharge")
//	{
//		if (targ.waterlevel < 1)
//			return FALSE;			// only entities in liquid are hit
//		if (trace_inopen && trace_inwater)
//			return FALSE;			// only entities in the SAME liquid are hit
//				// it doesn't matter if water changes into slime as long as they are connected
//				// and walls don't protect anymore (you can discharge through walls)
//		return TRUE;
//	}
// 1998-10-04 Hit outside water by a discharge fix by Maddes  end

	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	local vector	dif;

	// testing middle of half-size bounding box
	dif_z = 0;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
//	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end

	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...front left
	dif_x = targ.mins_x * 0.5;
//	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...back left
	dif_y = targ.mins_y * 0.5;
//	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// ...back right
	dif_x = targ.maxs_x * 0.5;
//	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
// 1998-09-16 CanDamage fix by Maddes/Kryten end
	if (trace_fraction == 1)
		return TRUE;

// 1998-09-16 CanDamage fix by Maddes/Kryten start
	// testing top of half-sized bounding box
	dif_z = targ.maxs_z * 0.5;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...front left
	dif_x = targ.mins_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back left
	dif_y = targ.mins_y * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back right
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// testing bottom of half-sized bounding box
	dif_z = targ.mins_z * 0.5;

	// ...front right
	dif_y = targ.maxs_y * 0.5;
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...front left
	dif_x = targ.mins_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back left
	dif_y = targ.mins_y * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	// ...back right
	dif_x = targ.maxs_x * 0.5;
	traceline(inflictor.origin, targ.origin + dif, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
// 1998-09-16 CanDamage fix by Maddes/Kryten end

	return FALSE;
};


/*============
Killed
============*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	
	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die ();
		self = oself;

		return;
	}

	self.enemy = attacker;

	// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();
	
	self = oself;
};


/*============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	float	save;
	local	float	take;
// 2001-08-01 No silmultaneous shots fix by Maddes  start
	local	float	search;
	local	entity	damage_collector;
	local	entity	damage_inflictor;
	local	entity	last_damage_inflictor;
// 2001-08-01 No silmultaneous shots fix by Maddes  end

	if (!targ.takedamage)
		return;

	//gnounc -- shub kill crash fix.
	if (targ.classname == "monster_oldone" && damage < 9999)
		return;

	// used by buttons and triggers to set activator for target firing
//	damage_attacker = attacker;		// 2001-08-01 No silmultaneous shots fix by Maddes

	// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time && inflictor.classname != "door")	// 1999-02-04 Doors no quad power fix by Zoid
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
		if (deathmatch == 4)
			damage = damage * 8;
		else
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end
		damage = damage * 4;

	// save damage based on the target's armor level

// 1998-08-12 Option: Drowning doesn't hurt armor by Maddes/Athos  start
	if ( (targ.deathtype == "drowning" )
	||   ( damage <= 0 ) )	// 2001-08-30 Negative damage ("healing") fix by Maddes
	{
		save = 0;
	}
	else
	{
// 1998-08-12 Option: Drowning doesn't hurt armor by Maddes/Athos  end
	save = ceil(targ.armortype*damage);

	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
	}	// 1998-08-12 Option: Drowning doesn't hurt armor by Maddes/Athos  start
	
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

	// add to the damage total for clients, which will be sent as a single
	// message at the end of the frame
	// FIXME: remove after combining shotgun blasts?
// 2001-08-01 Maddes comment: needed for player bob kick when hit, hence before team play damage avoidance
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
// 2001-08-30 Negative damage ("healing") fix by Maddes  start
		if ( targ.dmg_take < 0 )
		{
			targ.dmg_take = 0;
		}
// 2001-08-30 Negative damage ("healing") fix by Maddes  end
	}

	// figure momentum add
	if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}

	// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
	
		return;
	}

	// team play damage avoidance
// 1998-07-29 Teamplay 1 fix by Maddes  start
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team)
	&& (targ != attacker)
	&& (attacker.classname == "player")
	&& (inflictor.classname !="door") )	// because squishing a teammate is still possible
// 1998-07-29 Teamplay 1 fix by Maddes  end
		return;

// 2001-08-01 No silmultaneous shots fix by Maddes  start
	// searching for existing damage collector entity
	damage_collector = find (world, classname, "damage_collector");
	search = 1;
	while ( ( damage_collector != world ) && ( search != 0 ) )
	{
		if ( damage_collector.owner == targ )
		{
			// found
			search = 0;
		}
		else
		{
			// search next
			damage_collector = find (damage_collector, classname, "damage_collector");
		}
	}

	// creating new damage collector entity if not found
	if (damage_collector == world)
	{
		damage_collector = spawn();
		damage_collector.classname = "damage_collector";
		damage_collector.owner = targ;
		damage_collector.count = 0;
		damage_collector.nextthink = time;
		damage_collector.think = SUB_Null;
	}

	// searching for existing damage entity
	last_damage_inflictor = damage_collector;
	damage_inflictor = damage_collector.enemy;
	while ( damage_inflictor )
	{
		if ( damage_inflictor.oldenemy == attacker )
		{
			if ( damage_inflictor.dmg_inflictor == inflictor )
			{
				if ( damage_inflictor.deathtype == targ.deathtype )
				{
					break;	// found
				}
			}
		}
		last_damage_inflictor = damage_inflictor;
		damage_inflictor = damage_inflictor.enemy;
	}

	// creating new damage entity if not found
	if (!damage_inflictor)
	{
		damage_inflictor = spawn();
		damage_inflictor.classname = "damage_inflictor";
		damage_inflictor.owner = targ;
		damage_inflictor.deathtype = targ.deathtype;
		damage_inflictor.oldenemy = attacker;
		damage_inflictor.dmg_inflictor = inflictor;
		damage_inflictor.dmg_take = 0;
		damage_inflictor.dmg_save = 0;

		last_damage_inflictor.enemy = damage_inflictor;

		if ( targ != attacker )
		{
			damage_collector.count = damage_collector.count + 1;
		}
	}

	// add the damage
	damage_inflictor.dmg_take = damage_inflictor.dmg_take + take;
	damage_inflictor.dmg_save = damage_inflictor.dmg_save + save;
};

void(entity damage_collector) RemoveDamageCollector =
{
	local	entity	damage_inflictor;
	local	entity	last_damage_inflictor;

	damage_inflictor = damage_collector.enemy;
	while ( damage_inflictor )
	{
		last_damage_inflictor = damage_inflictor;
		damage_inflictor = damage_inflictor.enemy;
		remove(last_damage_inflictor);
	}
	remove(damage_collector);
};

void(entity damage_collector) ProcessDamageCollector =
{
	local	entity	damage_inflictor;
	local	entity	targ, attacker;
	local	entity	oldself;
	local	float	take;

	targ = damage_collector.owner;

	// process all damages
	damage_inflictor = damage_collector.enemy;
	while ( damage_inflictor )
	{
		attacker = damage_inflictor.oldenemy;
		damage_attacker = attacker;	// used by buttons and triggers to set activator for target firing
		targ.deathtype = damage_inflictor.deathtype;
		targ.dmg_inflictor = damage_inflictor.dmg_inflictor;
		take = damage_inflictor.dmg_take;
// 2001-08-01 No silmultaneous shots fix by Maddes  end

	// do the damage
// 2001-08-30 Negative damage ("healing") fix by Maddes  start
		if ( ( take > 0 )	// real damage
		||   ( targ.health < targ.max_health ) )	// heal only when necessary
		{
// 2001-08-30 Negative damage ("healing") fix by Maddes  end
	targ.health = targ.health - take;
// 2001-08-30 Negative damage ("healing") fix by Maddes  start
			if ( ( take < 0 ) && ( targ.health > targ.max_health ) )	// avoid "over-healing"
			{
				targ.health = targ.max_health;
			}
		}
// 2001-08-30 Negative damage ("healing") fix by Maddes  end

		// react to the damage
		other = targ;
			
	if (targ.health <= 0)
	{
		Killed (targ, attacker);
		return;
	}

	//react to the damage
	oldself = self;
	self = targ;

	if ( (self.flags & FL_MONSTER) && attacker != world)
	{
		//get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy)
		{
			if ( (self.classname != attacker.classname) || (self.classname == "monster_army" ) )
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;

				self.enemy = attacker;
				FoundTarget ();
			}
		}
	}

// 2001-08-30 Negative damage ("healing") fix by Maddes  start
		if ( take > 0 )		// real damage
		{
// 2001-08-30 Negative damage ("healing") fix by Maddes  end
	if (self.th_pain)
	{
		self.th_pain (attacker, take);
		// nightmare mode monsters don't go into pain frames often
		if (skill == 3)
			self.pain_finished = time + 5;		
	}
		}	// 2001-08-30 Negative damage ("healing") fix by Maddes

	self = oldself;

// 2001-08-01 No silmultaneous shots fix by Maddes  start
		damage_inflictor = damage_inflictor.enemy;
	}
// 2001-08-01 No silmultaneous shots fix by Maddes  end
};

/*============
T_RadiusDamage
============
*/
// 1998-07-24 Wrong obituary messages fix by Zoid  added parameter dtype
void(entity inflictor, entity attacker, float damage, entity ignore, string dtype) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;
// 1998-07-07 T_RadiusDamage workaround by Robert Field  start
	local	float	attacker_damaged;
	local	float	attacker_points;
// 1998-07-07 T_RadiusDamage workaround by Robert Field  end

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);

				if (points < 0)
					points = 0;

				points = damage - points;
// 1998-07-07 T_RadiusDamage workaround by Robert Field  start
/*
				if (head == attacker)
					points = points * 0.5;
*/
// 1998-07-07 T_RadiusDamage workaround by Robert Field  end
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
//					if (CanDamage (head, inflictor, dtype))	// 1998-10-04 Hit outside water by a discharge fix by Maddes
					{
						head.deathtype = dtype;	// 1998-07-24 Wrong obituary messages fix by Zoid
// 1998-07-07 T_RadiusDamage workaround by Robert Field  start
						if (head != attacker)
						{
// 1998-07-07 T_RadiusDamage workaround by Robert Field  end
						// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")						
							T_Damage (head, inflictor, attacker, points*0.5);

						else
							T_Damage (head, inflictor, attacker, points);
// 1998-07-07 T_RadiusDamage workaround by Robert Field  start
						}
						else
						{
							attacker_damaged = TRUE;
							attacker_points = points * 0.5;
						}
// 1998-07-07 T_RadiusDamage workaround by Robert Field  end
					}
				}
			}
		}
		head = head.chain;
	}

// 1998-07-07 T_RadiusDamage workaround by Robert Field  start
	if (attacker_damaged)
		T_Damage (attacker, inflictor, attacker, attacker_points);
// 1998-07-07 T_RadiusDamage workaround by Robert Field  end
};

/*============
T_BeamDamage
============*/
void(entity attacker, float damage) T_BeamDamage =
{
	local	float 	points;
	local	entity	head;
	
	head = findradius(attacker.origin, damage+40);
	
	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;

			points = damage - points;

			if (head == attacker)
				points = points * 0.5;

			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler")						
						T_Damage (head, attacker, attacker, points*0.5);

					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};

