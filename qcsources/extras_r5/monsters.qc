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
 Changes added by khreathor
 2018-07-18 - monster spawning changes

 pOx - several fixes from URQP below
 1998-12-23 Movetarget correction in monster start functions fix by Maddes
            correcting if-clause
 1998-08-14 Monsters sometimes do not move fix by Perged
            setting nextthink correctly
 1997-12-23 Fish fix by Maddes
            correct total monster addition (don't count fishes twice)

*/

///	Monster spawning flags (khreathor)
float	INITIALIZE_ONLY	= 4;		// Initialize but not spawn - flag
float	PARTICLES_ON_SPAWN = 8;		// Fire particles on spawn. Works only with INITIALIZE_ONLY
float	ATTACK_AFTER_SPAWN = 16;	// Make an enemy attack player after spawn. Works only with INITIALIZE_ONLY
float	CAN_DROWN = 32;				// Make an enemy able to drown

/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void() monster_use =
{
	if (self.health <= 0)
		return;
		
	if (self.enemy)	/// Don't execute use when monster has an enemy (khreathor)
		return;
	
	if (activator.classname != "player")
		return;
	
	if (activator.items & IT_INVISIBILITY)
		return;
	
	if(self.spawned == IS_NOTSPAWNED)	/// Spawn an enemy (khreathor)
	{
		if (self.spawnflags & PARTICLES_ON_SPAWN)
		{
			spawn_tfog (self.origin);
		}
		self.spawnfunc();
		
		///	Trigger enemy after spawn (khreathor)
		if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
		{
			self.enemy = activator;
			self.think = FoundTarget;
		}
	}
	else
	{
		// "notarget" check moved here, so we don't block enemies from spawning
		// when "notarget" is enabled (khreathor)
		if(activator.flags & FL_NOTARGET)
			return;
			
		// delay reaction so if the monster is teleported, its sound is still
		// heard
		self.enemy = activator;
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
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
	{
		self.flags = self.flags - FL_FLY;
		self.wait_for_drop = TRUE;
	}
	
	if (self.flags & FL_SWIM)
	{
		self.flags = self.flags - FL_SWIM;
		self.wait_for_drop = TRUE;
	}
	
	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

/*
======================
increase_monster_count

(khreathor)
Self explanatory. Moved from here(monsters.qc) to separate monsters code/files.
======================
*/
void() increase_monster_count =
{ 
	total_monsters = total_monsters + 1;
};

void() walkmonster_start_go =
{
	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor(0,0);			// 1999-08-13 Missing parameters fix by Maddes
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
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
	
	///	(khreathor) - Code below is a slightly modified version of an original code.
	///	Prepared for future changes, if I decide to port more stuff from Episode Jam progs.
	if (self.target && self.target != "player")
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
		{
			self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
			self.th_walk ();
		}
		else
		{	// 1998-12-23 Movetarget correction in monster start functions fix by Maddes
			self.pausetime = 99999999;
			self.th_stand ();
		}	// 1998-12-23 Movetarget correction in monster start functions fix by Maddes
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
	
	spawn_tdeath(self.origin,self);	///	Test if enemy should be gibbed on spawn (khreathor)
	
	// Attack immediately after spawn if ATTACK_AFTER_SPAWN is enabled
	// but don't attack if "notarget" is active (khreathor)
	if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
	{
		FoundTarget ();
	}
	else if(!(self.spawnflags & INITIALIZE_ONLY))
	{
		// delay reaction so if the monster is teleported, its sound is still
		// heard
		// spread think times so they don't all happen at same time
		// 1998-08-14 Monsters sometimes do not move fix by Perged  start
	//	self.nextthink = self.nextthink + random()*0.5;
		self.nextthink = time + 0.1 + random()*0.5;
		// 1998-08-14 Monsters sometimes do not move fix by Perged  end
	}
	self.spawned = IS_SPAWNED;	///	Mark enemy as spawned (khreathor)
};

/*
===========================
walkmonster_initialize_only

(khreathor)
Initialize monster, but don't spawn it. Can be triggered.
===========================
*/
void() walkmonster_initialize_only =
{
	self.spawned = IS_NOTSPAWNED;
	self.use = monster_use;
};

void() walkmonster_start =
{
	///	Attack player immediately when ATTACK_AFTER_SPAWN is set and not in NOTARGET mode (khreathor)
	if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
	{
		walkmonster_start_go();
	}
	else
	{
	// delay drop to floor to make sure all doors have been spawned
	// spread think times so they don't all happen at same time
	// 1998-08-14 Monsters sometimes do not move fix by Perged  start
	//	self.nextthink = self.nextthink + random()*0.5;
		self.nextthink = time + 0.1 + random()*0.5;
	// 1998-08-14 Monsters sometimes do not move fix by Perged  end
		self.think = walkmonster_start_go;
	}
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
		dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	///	(khreathor) - Code below is a slightly modified version of an original code.
	///	Prepared for future changes, if I decide to port more stuff from Episode Jam progs.
	if (self.target && self.target != "player")
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
		{
			self.th_walk ();
		}
		else
		{	// 1998-12-23 Movetarget correction in monster start functions fix by Maddes
			self.pausetime = 99999999;
			self.th_stand ();
		}	// 1998-12-23 Movetarget correction in monster start functions fix by Maddes
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
	
	spawn_tdeath(self.origin,self);	///	Test if enemy should be gibbed on spawn (khreathor)
	
	// Attack immediately after spawn if ATTACK_AFTER_SPAWN is enabled
	// but don't attack if "notarget" is active (khreathor)
	if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
	{
		FoundTarget ();
	}
	else if(!(self.spawnflags & INITIALIZE_ONLY))
	{
		// delay reaction so if the monster is teleported, its sound is still
		// heard
		// 1998-08-14 Monsters sometimes do not move fix by Perged  start
		self.nextthink = time + 0.1 + random()*0.5;
		// 1998-08-14 Monsters sometimes do not move fix by Perged  end
	}
	
	self.spawned = IS_SPAWNED;
};

/*
==========================
flymonster_initialize_only

(khreathor)
Initialize monster, but don't spawn it. Can be triggered.
==========================
*/
void() flymonster_initialize_only =
{
	self.spawned = IS_NOTSPAWNED;
	self.use = monster_use;
}

void() flymonster_start =
{
	///	Attack player immediately when ATTACK_AFTER_SPAWN is set and not in NOTARGET mode (khreathor)
	if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
	{
		flymonster_start_go ();
	}
	else
	{
		// 1998-08-14 Monsters sometimes do not move fix by Perged  start
		self.flags = self.flags | FL_FLY;	// don't let gravity affect them
		// spread think times so they don't all happen at same time
		//    self.nextthink = self.nextthink + random()*0.5;
		self.nextthink = time + 0.1 + random()*0.5;
		// 1998-08-14 Monsters sometimes do not move fix by Perged  end

		self.think = flymonster_start_go;
	}
};


void() swimmonster_start_go =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;
//	total_monsters = total_monsters + 1;		// 1997-12-23 Fish fix by Maddes  don't count fishes twice

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

	///	(khreathor) - Code below is a slightly modified version of an original code.
	///	Prepared for future changes, if I decide to port more stuff from Episode Jam progs.
	if (self.target && self.target != "player")
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

	spawn_tdeath(self.origin,self);	///	Test if enemy should be gibbed on spawn (khreathor)
	
	// Attack immediately after spawn if ATTACK_AFTER_SPAWN is enabled
	// but don't attack if "notarget" is active (khreathor)
	if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
	{
		FoundTarget ();
	}
	else if(!(self.spawnflags & INITIALIZE_ONLY))
	{
		// delay reaction so if the monster is teleported, its sound is still
		// heard
		// spread think times so they don't all happen at same time
		// 1998-08-14 Monsters sometimes do not move fix by Perged  start
		//	self.nextthink = self.nextthink + random()*0.5;
			self.nextthink = time + 0.1 + random()*0.5;
		// 1998-08-14 Monsters sometimes do not move fix by Perged  end
	}
	
	self.spawned = IS_SPAWNED;
};

/*
==========================
swimmonster_initialize_only

(khreathor)
Initialize monster, but don't spawn it. Can be triggered.
==========================
*/
void() swimmonster_initialize_only =
{
	self.spawned = IS_NOTSPAWNED;
	self.use = monster_use;
};

void() swimmonster_start =
{
	///	Attack player immediately when ATTACK_AFTER_SPAWN is set and not in NOTARGET mode (khreathor)
	if (self.spawnflags & ATTACK_AFTER_SPAWN && !(activator.flags & FL_NOTARGET))
	{
		swimmonster_start_go ();
	}
	else
	{
		// 1998-08-14 Monsters sometimes do not move fix by Perged  start
		self.flags = self.flags | FL_SWIM;    // don't let gravity affect them

	// spread think times so they don't all happen at same time
	//	self.nextthink = self.nextthink + random()*0.5;
		self.nextthink = time + 0.1 + random()*0.5;
	// 1998-08-14 Monsters sometimes do not move fix by Perged  end
		self.think = swimmonster_start_go;
	}
};


