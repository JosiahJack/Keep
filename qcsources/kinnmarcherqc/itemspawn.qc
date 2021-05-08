/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<

ITEM GROUPS

Allows you to group up to six items into a single edict, allowing for
very significant #edict reductions.

~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>*/

void() BDW_ItemListReport =
{
	//TODO: need to do this properly with find(), because it's dependant on the group list being intact at the mo...

	local entity igroup;
	local float n, num_groups, total_items;

	num_groups = total_items = 0;

	igroup = item_list;

	while(igroup)
	{
		n = 1;	//the group is an item too, remember

		if (igroup.count1)
			n = n + 1;
		if (igroup.count2)
			n = n + 1;
		if (igroup.count3)
			n = n + 1;
		if (igroup.count4)
			n = n + 1;
		if (igroup.count5)
			n = n + 1;
		
		dprint("item group ");
		dprint(igroup.netname);
		dprint(" contains ");
		dprint(ftos(n));
		dprint(" items\n");

		num_groups = num_groups + 1;
		total_items = total_items + n;

		igroup = igroup.next_ent;
	}

	dprint("a total of ");
	dprint(ftos(num_groups));
	dprint(" item groups contain ");
	dprint(ftos(total_items));
	dprint(" items\n");
};


void(entity igroup, float id) AddItemToGroup =
{
	if (igroup.targetname)
	{
		if ( (self.targetname != "") && (self.targetname != igroup.targetname) )
			objerror("item group - targetname mismatch\n");
	}
	else if (self.targetname)
		igroup.targetname = self.targetname;		

	if (!igroup.count1)
	{
		igroup.count1 	= id;
		igroup.dest1 	= self.origin;
		igroup.target1 	= self.target;
		igroup.delay1 	= self.delay;
		igroup.pos1_y	= self.spawnflags;		
	}
	else if (!igroup.count2)
	{
		igroup.count2 	= id;
		igroup.dest2 	= self.origin;
		igroup.target2 	= self.target;
		igroup.delay2 	= self.delay;
		igroup.pos1_z	= self.spawnflags;		
	}
	else if (!igroup.count3)
	{
		igroup.count3 	= id;
		igroup.dest3 	= self.origin;
		igroup.target3 	= self.target;
		igroup.delay3 	= self.delay;
		igroup.pos2_x	= self.spawnflags;		
	}
	else if (!igroup.count4)
	{
		igroup.count4 	= id;
		igroup.dest4 	= self.origin;
		igroup.target4 	= self.target;
		igroup.delay4 	= self.delay;
		igroup.pos2_y	= self.spawnflags;		
	}
	else if (!igroup.count5)
	{
		igroup.count5 	= id;
		igroup.dest5 	= self.origin;
		igroup.target5 	= self.target;
		igroup.delay5 	= self.delay;
		igroup.pos2_z	= self.spawnflags;	
	}
	else
		objerror("item_group has too many items\n");
};

void(float itype, vector iorg, string itarget, float idelay, float iflags) BDW_SpawnGroupItem =
{
	local entity item, spn;

	item = spawn();

	item.target = itarget;
	item.delay = idelay;
	item.spawnflags = iflags;

	spn = self;
	self = item;

	//todo - weapons, powerups...

	if (itype == IT_HEALTH)
		item_health_init();
	else if (itype == IT_SHELLS)
		item_shells_init();
	else if (itype == IT_NAILS)
		item_spikes_init();
	else if (itype == IT_ROCKETS)
		item_rockets_init();
	else if (itype == IT_CELLS)
		item_cells_init();
	else if (itype == IT_ARMOR1)
		item_armor1_init();
	else if (itype == IT_ARMOR2)
		item_armor2_init();
	else if (itype == IT_ARMOR3)
		item_armorInv_init();
	else if (itype == IT_KEY1)
		item_key1_init();
	else if (itype == IT_KEY2)
		item_key2_init();
	else if (itype == IT_SUPER_NAILGUN)
		weapon_supernailgun_init();		
	else if (itype == IT_GRENADE_LAUNCHER)
		weapon_grenadelauncher_init();	
	else if (itype == IT_ROCKET_LAUNCHER)
		weapon_rocketlauncher_init();
	else if (itype == IT_LIGHTNING)
		weapon_lightning_init();
	else
		objerror("BDW_SpawnGroupItem: bad item type\n");

	setorigin(self, iorg);
	PlaceItem();

	//sound(self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound

	self = spn;		//remember to always change self back at the end of the function!
};	

void() item_group_use =
{	
	BDW_SpawnGroupItem(self.count, self.origin, self.target, self.delay, self.spawnflags);

	if (self.count1)
		BDW_SpawnGroupItem(self.count1, self.dest1, self.target1, self.delay1, self.pos1_y);
	if (self.count2)
		BDW_SpawnGroupItem(self.count2, self.dest2, self.target2, self.delay2, self.pos1_z);
	if (self.count3)
		BDW_SpawnGroupItem(self.count3, self.dest3, self.target3, self.delay3, self.pos2_x);
	if (self.count4)
		BDW_SpawnGroupItem(self.count4, self.dest4, self.target4, self.delay4, self.pos2_y);
	if (self.count5)
		BDW_SpawnGroupItem(self.count5, self.dest5, self.target5, self.delay5, self.pos2_z);
	
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void(float id) BecomeItemGroup =
{
	self.classname = "item_group";
	self.count = id;
	self.use = item_group_use;	
};

float(float id) AddToItemList =
{
	entity igroup;

	if (!self.netname)
		return FALSE;	//not part of an item group

	if (item_list == world)
	{
		item_list = self;
		BecomeItemGroup(id);
		return TRUE;
	}

	igroup = item_list;

	while(1)
	{
		if (igroup.netname == self.netname)
		{			
			AddItemToGroup(igroup, id);
			remove(self);	//purge item from edicts list
			return TRUE;
		}

		if (!igroup.next_ent)	//reached end of list and still no match
		{
			igroup.next_ent = self;
			BecomeItemGroup(id);
			return TRUE;	//new item group
		}

		igroup = igroup.next_ent;
	}
	
	return FALSE;	//shut up compiler warnings
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<

AMMO CACHES

Allows you to spawn unlimited numbers of ammo and health in grid-like
formations, using a single edict. Obsoleted by item_groups with six 
items or less.

~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>*/

//spawnflags...
float CACHE_SMALL_SHELLS = 1;
float CACHE_SMALL_NAILS = 2;
float CACHE_SMALL_ROCKETS = 4;
float CACHE_SMALL_CELLS = 8;
float CACHE_SMALL_HEALTH = 16;
float CACHE_MEGA_HEALTH = 32;

void(float type, vector newpos) BDW_SpawnItem =
{
	local entity item, spn;

	item = spawn();

	spn = self;
	self = item;

	if (type == IT_HEALTH)
	{
		if (spn.spawnflags & CACHE_SMALL_HEALTH)
			self.spawnflags = H_ROTTEN;
		else if (spn.spawnflags & CACHE_MEGA_HEALTH)
			self.spawnflags = H_MEGA;

		item_health_init();
	}
	else if (type == IT_SHELLS)
	{
		if (!spn.spawnflags & CACHE_SMALL_SHELLS)
			self.spawnflags = WEAPON_BIG2;		

		item_shells_init();
	}
	else if (type == IT_NAILS)
	{
		if (!spn.spawnflags & CACHE_SMALL_NAILS)
			self.spawnflags = WEAPON_BIG2;		

		item_spikes_init();
	}
	else if (type == IT_ROCKETS)
	{
		if (!spn.spawnflags & CACHE_SMALL_ROCKETS)
			self.spawnflags = WEAPON_BIG2;		

		item_rockets_init();
	}
	else if (type == IT_CELLS)
	{
		if (!spn.spawnflags & CACHE_SMALL_CELLS)
			self.spawnflags = WEAPON_BIG2;		

		item_cells_init();
	}
	else
		objerror("BDW_SpawnItem: bad item type\n");

	//offset for normal quake bsp models... (bdw - check this, this might be a relic from when i had q2 items in
	newpos = newpos - '16 16 0';

	setorigin(self, newpos);

	PlaceItem();

	self = spn;		//remember to always change self back at the end of the function!
};		

void() BDW_AmmoCacheUse =
{
	local float c, r, type;
	local vector newpos;

	self.use = SUB_Null;	//don't trigger more than once
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;

	makevectors(self.angles);

	c = r = 0;

	while (1)
	{
		if (self.ammo_cells > 0) 
		{
			type = IT_CELLS;
			self.ammo_cells = self.ammo_cells - 1;
		}
		else if (self.ammo_rockets > 0) 
		{
			type = IT_ROCKETS;
			self.ammo_rockets = self.ammo_rockets - 1;
		}
		else if (self.ammo_nails > 0) 
		{
			type = IT_NAILS;
			self.ammo_nails = self.ammo_nails - 1;
		}
		else if (self.ammo_shells > 0) 
		{
			type = IT_SHELLS;
			self.ammo_shells = self.ammo_shells - 1;
		}
		else if (self.health > 0)
		{
			type = IT_HEALTH;
			self.health = self.health - 1;
		}		
		else
			return;	//we're done;

		//unlike monster spawners, ammo starts from the back and goes forward in a line...
		newpos = self.origin + (v_forward*self.distance*c) + (v_right*self.distance*r);

		BDW_SpawnItem(type, newpos);

		c = c+1;	//increment column
		if (c == self.volume)	//if at end of rank...
		{
			c = 0;		//...reset column...
			r = r+1;		//...increment row

		}		
	}	
};

void() bdw_ammo_cache =
{
	local float n, tempflags;

	if (!self.targetname)
	{
		dprint("warning: ammo cache with no targetname at: ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
		return;
	}

	n = self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells + self.health;

	if (n <= 0)
	{
		dprint("warning: ammo cache with no ammo at: ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
		return;
	}

	if (!self.volume)
		self.volume = n;	//if volume not specified, ammo will spawn in a line

	if (!self.distance)
		self.distance = 40;
	else if (self.distance < 32)
		self.distance = 32;		

	tempflags = self.spawnflags;

	if (self.ammo_shells)
	{
		if (tempflags & CACHE_SMALL_SHELLS)
			self.spawnflags = 0;
		else
			self.spawnflags = WEAPON_BIG2;

		item_shells_precache();
	}
	if (self.ammo_nails)
	{
		if (tempflags & CACHE_SMALL_NAILS)
			self.spawnflags = 0;
		else
			self.spawnflags = WEAPON_BIG2;

		item_spikes_precache();
	}
	if (self.ammo_rockets)
	{
		if (tempflags & CACHE_SMALL_ROCKETS)
			self.spawnflags = 0;
		else
			self.spawnflags = WEAPON_BIG2;

		item_rockets_precache();
	}
	if (self.ammo_cells)
	{
		if (tempflags & CACHE_SMALL_CELLS)
			self.spawnflags = 0;
		else
			self.spawnflags = WEAPON_BIG2;

		item_cells_precache();
	}
	if (self.health)
	{
		if (tempflags & CACHE_SMALL_HEALTH)
			self.spawnflags = H_ROTTEN;
		else if (tempflags & CACHE_MEGA_HEALTH)
			self.spawnflags = H_MEGA;
		else
			self.spawnflags = 0;

		item_health_precache();
	}

	self.spawnflags = tempflags;	

	self.use = BDW_AmmoCacheUse;
};


