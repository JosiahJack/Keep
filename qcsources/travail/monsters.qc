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
	local vector delta;
	local float x, y, pushang;

	//can cause problems for monsters on top of a player,  so only players
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	if ((!other.flags & FL_ONGROUND) && (other.absmin_z >= self.absmax_z - 2))
	{
		other.flags = other.flags + FL_ONGROUND;
		return;
	}

	//you can add other stuff like pushable players/monsters here
	if ( (self.classname != "monster_shambler") && (self.classname != "monster_oldone") && (self.classname != "monster_vermis") && (self.classname != "monster_shalrath") && (self.classname != "monster_boss") && (self.classname != "monster_armagon") && (self.model != "progs/uberscrag.mdl") && (!self.velocity_z) )
	{
		if (self.classname == "explo_box")
			self.flags = self.flags - FL_ONGROUND;

		delta = vectoangles(other.velocity);
		pushang = delta_y;
		if ( (self.classname == "monster_ogre") || (self.classname == "monster_hell_knight") || (self.classname == "monster_demon1") )
			walkmove(pushang, 8 * frametime);
		else
			walkmove(pushang, 16 * frametime);
	}
};


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

// delay reaction so if the monster is teleported, its sound is still
// heard
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
	local entity 	ent, otemp, stemp;

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

float() orig_random =
{
    	local float len;

    	len = vlen (self.origin);

    	return len - floor(len);
};

void() killed_monster =
{
    	if (cvar("developer") > 1)
      		print_self ("monster", "killed");

    	killed_monsters = killed_monsters + 1;
	WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
};

void() update_monster =
{
   	WriteByte (MSG_BROADCAST,SVC_UPDATESTAT);
   	WriteByte (MSG_BROADCAST,STAT_TOTALMONSTERS);
   	WriteLong (MSG_BROADCAST,total_monsters);
};

void(string type, string text) print_self =
{
	dprint (type);
	dprint (" '");
	dprint (self.classname);
	dprint ("' ");
	dprint (text);
	dprint (" at ");
	dprint (vtos(self.origin));
	dprint ("\n");
};

void() walkmonster_start_go =
{
local string	stemp;
local entity	etemp;

	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();

	if (!walkmove(0,0))
		print_self ("walkmonster", "in wall");

	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_MONSTER;

        // Abort if monster got telefragged upon level placement.
        if (self.health <= 0)
        {
		print_self ("walkmonster", "killed");
		return;
        }

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
			print_self ("walkmonster", "can't find target");
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
if(time < 1) //PREACH: fix for delayed start of func_spawn spawned monsters
	self.nextthink = time + 0.1 + random()*0.5;
};


void() walkmonster_start =
{
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = time + 0.1 + random()*0.5;
	self.flags = self.flags | FL_MONSTER;
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
		print_self ("flymonster", "in wall");

        // Abort if monster got telefragged upon level placement.
        if (self.health <= 0)
        {
		print_self ("flymonster", "killed");
		return;
        }

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
			print_self ("flymonster", "can't find target");
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
		{
			self.pausetime = 99999999;
			self.th_stand ();
		}
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
};

void() flymonster_start =
{
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

// spread think times so they don't all happen at same time
	self.nextthink = time + 0.1 + random()*0.5;
	self.flags = self.flags | FL_MONSTER;
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

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;

	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

	if (!walkmove(0,0))
		print_self ("swimmonster", "in wall");

        // Abort if monster got telefragged upon level placement.
        if (self.health <= 0)
        {
		print_self ("swimmonster", "killed");
		return;
        }

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
			print_self ("swimmonster", "can't find target");
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
	self.nextthink = time + 0.1 + random()*0.5;
};

void() swimmonster_start =
{
	self.touch = monster_touch;	// 1998-09-16 Sliding/not-jumping on monsters/boxes/players fix by Maddes/Kryten

// spread think times so they don't all happen at same time
	self.flags = self.flags | FL_MONSTER;
	self.nextthink = time + 0.1 + random()*0.5;
	self.think = swimmonster_start_go;
	total_monsters = total_monsters + 1;
};



/*
================
Monster Corpse Stuff

Monsters turn into corpses and stuff
================
*/

void() Corpse_Die =
{
	sound (self, CHAN_VOICE, "zombie/z_miss.wav", 1, ATTN_NONE);
	ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	remove(self);
};

void() Corpse_Pain = {self.health = self.max_health;};

void() Become_Corpse =
{
	setorigin (self, self.origin);
	self.solid = SOLID_TRIGGER;
	self.size_z = self.size_z*0.5;
	self.classname = "monster_corpse";
	CorpseThink ();
	self.flags = self.flags - FL_MONSTER;
	if (self.health < -50)
		self.health = -50;
	self.max_health = 60 + self.health;
	self.health = self.max_health;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = Corpse_Pain;
	self.th_die = Corpse_Die;
	self.takedamage = DAMAGE_YES;
	self.target = "";
};
