//
//bdw - combined all the _monster_start_go functions into one...
//

/*float() BDW_CheckForDrop =
{
	if (self.monsterflags & MF_SHUFFLER_MINION)
		return FALSE;	
	if (self.spawnflags & M_NODROP)
		return FALSE;

	return TRUE;
};*/

void() bdw_monster_start_go =
{
	local entity t;

	if (self.flags & FL_FLY)
	{
		self.view_ofs = '0 0 25';
		if (!self.yaw_speed)
			self.yaw_speed = 10;
	}
	else if (self.flags & FL_SWIM)
	{
		self.view_ofs = '0 0 10';
		if (!self.yaw_speed)
			self.yaw_speed = 10;
	}
	else	//it's a walkmonster
	{
		self.view_ofs = '0 0 25';
		if (!self.yaw_speed)
			self.yaw_speed = 20;

		if ( (!(self.monsterflags & MF_SHUFFLER_MINION)) && (!(self.spawnflags & M_SPAWNNODROP)) )
		{		
			//self.origin_z = self.origin_z + 1;
			setorigin(self, self.origin + '0 0 1');		//bdw - link because droptofloor() may return false
			droptofloor();
		}		
	}

	if (!walkmove(0,0))
	{
		dprint ("monster can't move at: ");	//bdw - more general message
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	if (!self.mass)
		self.mass = 1;	//bdw

	/*if (skill == 0)	//bdw - new, cheap way of doing skill levels
	{
		if (self.health > 100)
			self.health = 100 + (self.health - 100)*0.5;
	}*/

	self.max_health = self.health;	//bdw - shufflers use this for pain anims

	self.flags = self.flags | FL_MONSTER;
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';	
	self.use = monster_use;

	if (self.target)
	{
		//bdw - i have changed this a fair bit...
		t = find(world, targetname, self.target);		
		if (!t)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
		
		if (t.classname == "path_corner")
		{
			self.goalentity = self.movetarget = t;
			self.ideal_yaw = vectoyaw(t.origin - self.origin);
			self.th_walk();
		}		
// this used to be an objerror			
		else
		{
		//bdw - i think there was an id bug here, where the parentheses were forgotten,
		//this caused all kinds of weirdness with the spawners, including the good old "attacking head" bug
			self.pausetime = 99999999;
			self.th_stand();
		}		
	}
	else
	{
		self.pausetime = 99999999;		
		self.th_stand();
	}	

// spread think times so they don't all happen at same time
// bdw - commented out (do we really need this?)
	//self.nextthink = time + 0.1 + random()*0.5;	
};



//============================================================================

void() bdw_monster_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = time + 0.1 + random()*0.5;	// ben - bugfix
   	self.think = bdw_monster_start_go;

	total_monsters = total_monsters + 1;	//be careful where you put this
};