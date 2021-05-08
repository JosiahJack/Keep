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
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
//----------------------------------------------------/ Code Change /-----//
	if (self.health <= 0)
		return;
	if (activator.classname != "player")
		return;
	if (self.enemy)
		return;
    if (PM_EntIsGood (self))
        return;     // Good guys don't get angry.
	if (activator.items & IT_INVISIBILITY)
        return;     // PM:  Always even if monster can see the invisible.
	if (activator.flags & FL_NOTARGET)
		return;
//------------------------------------------------------------------------//

//SoE: triggering a "super ambush" monster means it acts as normal
	self.spawnflags2 = self.spawnflags2 - SUPER_AMBUSH;
	
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

//----------------------------------------------------/ Code Change /-----//
    // If killed by a player owned monster, make its killer's master
    // the activator.
    if (self.enemy.master.classname == "player")
        activator = self.enemy.master;
    else
        activator = self.enemy;
//------------------------------------------------------------------------//
	SUB_UseTargets ();
};


//============================================================================

//----------------------------------------------------/ New Code /--------//
//  This returns the view offset for the monster.
//------------------------------------------------------------------------//
vector() PM_SetEyeLevel =
{
    if (self.maxs_z >= 30)
        return '0 0 25';  // For most monsters.
    if (self.maxs_z >= 12)
        return '0 0 10';  // For small monsters (e.g. fish).
    return '0 0 0';    // For tiny monsters (e.g. Willy the Spider).
};
//------------------------------------------------------------------------//

void() walkmonster_start_go =
{
local string	stemp;
local entity	etemp;
local float n; // SoE

	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
//----------------------------------------------------/ Code Change /-----//
    // Moved from below to here, above the wall checks.
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
    self.view_ofs = PM_SetEyeLevel();
	self.use = monster_use;
//------------------------------------------------------------------------//
	
	self.flags = self.flags | FL_MONSTER;
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

//----------------------------------------------------/ New Code /--------//
    // Abort if monster got telefragged upon level placement.
    if (self.health <= 0)
    {
        dprint ("walkmonster killed at: ");
        dprint (vtos(self.origin));
        dprint ("\n");
        return;
    }
//--------------------------------------------------------------------------
	
// PM:  Takedamage, yaw, views, and use were here.

	if (self.target)
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
//----------------------------------------------------/ Code Change /-----//
// PM:  Fixed if-else block.
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
        {
			self.pausetime = 99999999;
			self.th_stand ();
        }
//------------------------------------------------------------------------//
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// PM:  Removed random delay.  Why?
//  * So sf64 monsters (and statues) move as soon as they are activated.

// SoE: In order to keep DMSP moving, we set the monster to have an enemy and head for 'em
	n = cvar("temp1");
	if (n)
	{
		n = random() * 16;
		n = ceil(n);
		etemp = world;
		while (n > 0)
		{
			etemp = find (etemp, classname, "player");
			if (etemp == world)
				etemp = find (etemp, classname, "player");
			n = n - 1;
		}
		self.enemy = etemp;
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
};

void() walkmonster_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
//----------------------------------------------------/ Code Change /-----//
    // Fix bug where monsters do not activate sometimes.
    self.nextthink = self.nextthink + 0.1 + random()*0.5;
	self.think = walkmonster_start_go;
    if (PM_CountMonster (self))
        total_monsters = total_monsters + 1;
//------------------------------------------------------------------------//
};



void() flymonster_start_go =
{
	local float n; local entity etemp;
	self.takedamage = DAMAGE_AIM;
//----------------------------------------------------/ New Code /--------//
    // Fix bug where monsters start lower than level placement.
    if (self.classname == "monster_nightshade")
        self.takedamage = DAMAGE_NO;
//------------------------------------------------------------------------//

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
//----------------------------------------------------/ Code Change /-----//
    self.view_ofs = PM_SetEyeLevel();
//------------------------------------------------------------------------//
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
//----------------------------------------------------/ New Code /--------//
    // Fix bug where monsters start lower than level placement.
    self.movetype = MOVETYPE_STEP;
//------------------------------------------------------------------------//

//----------------------------------------------------/ Code Change /-----//
    // NOTE:  'walkmove' does not work with flying monsters.
    // Check if monster is stuck in wall.
    if (PM_EntStartInWall (self, self.origin))
	{	dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

    // Abort if monster got telefragged upon level placement.
    if (self.health <= 0)
    {
        dprint ("flymonster killed at: ");
        dprint (vtos(self.origin));
        dprint ("\n");
        return;
    }
//------------------------------------------------------------------------//

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
//----------------------------------------------------/ Code Change /-----//
// PM:  Fixed if-else block.
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
        {
			self.pausetime = 99999999;
			self.th_stand ();
        }
//------------------------------------------------------------------------//
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// SoE: In order to keep DMSP moving, we set the monster to have an enemy and head for 'em
	n = cvar("temp1");
	if (n)
	{
		n = random() * 16;
		n = ceil(n);
		etemp = world;
		while (n > 0)
		{
			etemp = find (etemp, classname, "player");
			if (etemp == world)
				etemp = find (etemp, classname, "player");
			n = n - 1;
		}
		self.enemy = etemp;
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
};

void() flymonster_start =
{
// spread think times so they don't all happen at same time
//----------------------------------------------------/ Code Change /-----//
    // Fix two bugs -- frozen monsters and monsters that drop lower.
    self.movetype = MOVETYPE_NONE;
    self.nextthink = self.nextthink + 0.1 + random()*0.5;
	self.think = flymonster_start_go;
    if (PM_CountMonster (self))
        total_monsters = total_monsters + 1;
//------------------------------------------------------------------------//
};


void() swimmonster_start_go =
{
// PM:  Removed deathmatch conditional.

	self.takedamage = DAMAGE_AIM;
// PM:  Removed line that caused fish to be counted twice.

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
//----------------------------------------------------/ Code Change /-----//
    self.view_ofs = PM_SetEyeLevel();
//------------------------------------------------------------------------//
	self.use = monster_use;
	
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
//----------------------------------------------------/ New Code /--------//
    // Fix bug where monsters start lower than level placement.
    self.movetype = MOVETYPE_STEP;
//------------------------------------------------------------------------//

//----------------------------------------------------/ New Code /--------//
    // Add checks for swimming monsters (fish) as well.
    if (PM_EntStartInWall (self, self.origin))
	{	dprint ("swimmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

    // Abort if monster got telefragged upon level placement.
    if (self.health <= 0)
    {
        dprint ("swimmonster killed at: ");
        dprint (vtos(self.origin));
        dprint ("\n");
        return;
    }
//------------------------------------------------------------------------//

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

// PM:  Removed random delay.  Why?
//  * So sf64 monsters (and statues) move as soon as they are activated.
};

void() swimmonster_start =
{
// spread think times so they don't all happen at same time
//----------------------------------------------------/ Code Change /-----//
    // Fix two bugs -- frozen monsters and monsters that drop lower.
    self.movetype = MOVETYPE_NONE;
    self.nextthink = self.nextthink + 0.1 + random()*0.5;
	self.think = swimmonster_start_go;
    if (PM_CountMonster (self))
        total_monsters = total_monsters + 1;
//------------------------------------------------------------------------//
};
