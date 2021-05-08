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
// 2000-06-27 Stating which monster is in wall by Maddes
//            displaying classname
// 1999-08-13 Missing parameters fix by Maddes
//            adding missing parameters
// 1999-02-02 Option: Toggle for previous optional functions by Maddes
//            recognizing SAVEDGAMECFG_MONSTER_... for monster skins
// 1998-12-23 Movetarget correction in monster start functions fix by Maddes
//            correcting if-clause
// 1998-09-17 Option: Skins for monsters by Maddes (idea by Jim "Tiger" Schmidt)
//            setting .skin to skill
// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten
//            defining new monster touch function
//            and using new monster touch function on monsterstart
// 1998-08-14 Monsters sometimes do not move fix by Perged
//            setting nextthink correctly
// 1997-12-23 Fish fix by Maddes
//            correct total monster addition (don't count fishes twice)

#include "directives.qh"	// 2001-04-22 by Maddes

/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };

// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten  start
/*
================
by: Philip Martin aka: Kryten
When on top of monsters or players you slide. This is a QuakeC problem.
The function below fixes that problem.
based on code given to Kryten by: Michael Turitzin (MaNiAc)
================
*/
void() monster_touch =
{
	//can cause problems for monsters on top of a player,  so only players
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if (( !other.flags & FL_ONGROUND) && (other.absmin_z >= self.absmax_z - 2))
		other.flags = other.flags + FL_ONGROUND;

	//you can add other stuff like pushable players/monsters here
};
// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten  end

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.enemy)
		return;

	if (self.health <= 0)
		return;

	if (activator.items & IT_INVISIBILITY)
		return;

	if (activator.flags & FL_NOTARGET)
		return;

	if (activator.classname != "player")
		return;
	
	// delay reaction so if the monster is teleported, its sound is still heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
	// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void() walkmonster_start_go =
{
	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor(0,0);			// 1999-08-13 Missing parameters fix by Maddes
	
	if (!walkmove(0,0))
	{
// 2000-06-27 Stating which monster is in wall by Maddes  start
//		dprint ("walkmonster in wall at: ");
		dprint ("Walkmonster \"");
		dprint (self.classname);
		dprint ("\" in wall at: ");
// 2000-06-27 Stating which monster is in wall by Maddes  end
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';

	if (!self.yaw_speed)
		self.yaw_speed = 20;

	self.view_ofs = '0 0 25';
	self.use = monster_use;
	
	self.flags = self.flags | FL_MONSTER;
	
	if (self.target != "")
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);

		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
	// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();

		else
			self.pausetime = 99999999;
			self.th_stand ();
	}

	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	// spread think times so they don't all happen at same time
// 1998-08-14 Monsters sometimes do not move fix by Perged  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Perged  end
};


void() walkmonster_start =
{
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
// 1998-09-17 Option: Skins for monsters by Maddes  start
	local float	max_skin;
	max_skin = (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1;
	if (max_skin)
		if (savedgamecfg & SAVEDGAMECFG_MONSTER_RANDOM_SKINS)
			self.skin = self.skin_selected = floor(random() * (max_skin + 0.9));	//random skins (n skins = n.9)
		else
		{
			self.skin = self.skin_selected = skill;
			if (self.skin > max_skin) self.skin = self.skin_selected = max_skin;
		}
// 1998-09-17 Option: Skins for monsters by Maddes  end
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  end

	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

	// delay drop to floor to make sure all doors have been spawned
	// spread think times so they don't all happen at same time
// 1998-08-14 Monsters sometimes do not move fix by Perged  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Perged  end
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + 1;
};



void() flymonster_start_go =
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';

	if (!self.yaw_speed)
		self.yaw_speed = 10;

	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;

	if (!walkmove(0,0))
	{
// 2000-06-27 Stating which monster is in wall by Maddes  start
//		dprint ("flymonster in wall at: ");
		dprint ("Flymonster \"");
		dprint (self.classname);
		dprint ("\" in wall at: ");
// 2000-06-27 Stating which monster is in wall by Maddes  end
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	if (self.target != "")
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);

		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();

		else
			self.pausetime = 99999999;
			self.th_stand ();
	}

	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
// 1998-08-14 Monsters sometimes do not move fix by Perged  start
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Perged  end
};

void() flymonster_start =
{
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
// 1998-09-17 Option: Skins for monsters by Maddes  start
	local float	max_skin;
	max_skin = (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1;
	if (max_skin)
		if (savedgamecfg & SAVEDGAMECFG_MONSTER_RANDOM_SKINS)
			self.skin = self.skin_selected = floor(random() * (max_skin + 0.9));	//random skins (n skins = n.9)
		else
		{
			self.skin = self.skin_selected = skill;
			if (self.skin > max_skin) self.skin = self.skin_selected = max_skin;
		}
// 1998-09-17 Option: Skins for monsters by Maddes  end
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  end

	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

// 1998-08-14 Monsters sometimes do not move fix by Perged  start
	self.flags = self.flags | FL_FLY;	// don't let gravity affect them

	// spread think times so they don't all happen at same time
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Perged  end
	self.think = flymonster_start_go;
	total_monsters = total_monsters + 1;
};


void() swimmonster_start_go =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;
	//	total_monsters = total_monsters + 1;	// gb, fish count bugfix

	self.ideal_yaw = self.angles * '0 1 0';

	if (!self.yaw_speed)
		self.yaw_speed = 10;

	self.view_ofs = '0 0 10';
	self.use = monster_use;
	
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

// 2000-06-27 Stating which monster is in wall by Maddes  start
	if (!walkmove(0,0))
	{
		dprint ("Flymonster \"");
		dprint (self.classname);
		dprint ("\" in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
// 2000-06-27 Stating which monster is in wall by Maddes  end

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);

		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}

	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

	// spread think times so they don't all happen at same time
// 1998-08-14 Monsters sometimes do not move fix by Perged  start
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Perged  end
};

void() swimmonster_start =
{
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
// 1998-09-17 Option: Skins for monsters by Maddes  start
	local float	max_skin;
	max_skin = (savedgamecfg & SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS) / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1;
	if (max_skin)
		if (savedgamecfg & SAVEDGAMECFG_MONSTER_RANDOM_SKINS)
			self.skin = self.skin_selected = floor(random() * (max_skin + 0.9));	//random skins (n skins = n.9)
		else
		{
			self.skin = self.skin_selected = skill;
			if (self.skin > max_skin) self.skin = self.skin_selected = max_skin;
		}
// 1998-09-17 Option: Skins for monsters by Maddes  end
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  end

	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

// 1998-08-14 Monsters sometimes do not move fix by Perged  start
	self.flags = self.flags | FL_SWIM;	// don't let gravity affect them

	// spread think times so they don't all happen at same time
//	self.nextthink = self.nextthink + random()*0.5;
	self.nextthink = time + 0.1 + random()*0.5;
// 1998-08-14 Monsters sometimes do not move fix by Perged  end
	self.think = swimmonster_start_go;
	total_monsters = total_monsters + 1;
};


