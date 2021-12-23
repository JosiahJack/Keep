/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<
MONSTER GROUPS
Allows you to group up to six monsters into a single edict, allowing for
very significant #edict reductions.
~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>*/

void() BDW_MonsterListReport = {
	local entity mgroup;
	local float n, num_groups, num_monsters;

	num_groups = num_monsters = 0;
	mgroup = find(world, classname, "monster_group");	
	while(mgroup) {
		n = 1;	//the group is an monster too, remember
		if (mgroup.count1) n = n + 1;
		if (mgroup.count2) n = n + 1;
		if (mgroup.count3) n = n + 1;
		if (mgroup.count4) n = n + 1;
		if (mgroup.count5) n = n + 1;
		dprint("monster group ");
		dprint(ftos(mgroup.cnt));
		dprint(": ");
		dprint(mgroup.targetname);
		dprint(", contains ");
		dprint(ftos(n));
		dprint(" monsters\n");
		num_groups = num_groups + 1;
		num_monsters = num_monsters + n;
		mgroup = find(mgroup, classname, "monster_group");	
	}

	dprint("a total of ");
	dprint(ftos(num_groups));
	dprint(" monster groups contain ");
	dprint(ftos(num_monsters));
	dprint(" monsters\n");
	num_monsters = 0;
	mgroup = find(world, classname, "monster_spawned");
	while(mgroup) {
		num_monsters = num_monsters + 1;
		mgroup = find(mgroup, classname, "monster_spawned");
	}

	dprint("a total of ");
	dprint(ftos(num_monsters));
	dprint(" non-grouped monsters are spawned\n");		
};

void() monster_spawned_use = {
	//todo - the rest of the monsters...
	if (self.monstertype == MONSTER_IMP) monster_imp_init();
	else if (self.monstertype == MONSTER_BLACK_SHUFFLER) monster_black_shuffler_init();		
	else if (self.monstertype == MONSTER_WHITE_SHUFFLER) monster_white_shuffler_init();	
	else if (self.monstertype == MONSTER_SPIDER) monster_spider_init();	
	else objerror("BDW_SpawnGroupMonster: bad monster type\n");	
	
	bdw_monster_start_go();
	if (!(self.spawnflags & M_SPAWNSILENT)) spawn_tfog(self.origin);		
	spawn_tdeath(self.origin, self);
	if (self.spawnflags & M_SPAWNANGRY) {		
		if (activator.classname == "player")
		{
			if ( (activator.health > 0) && (!(activator.flags & FL_NOTARGET)) )
			{
				self.enemy = activator;
				self.think = FoundTarget;
			}
		}
	}

	self.nextthink = time + 0.2 + random()*0.1;	//increase delay before moving to give teledeaths a chance to dissapear.	
};

void(float mtype, vector morg, string mtarget, float mdelay, float mflags, float mangles) BDW_SpawnGroupMonster =
{
	local entity monster, oldself;

	monster = spawn();

	monster.monstertype = mtype;
	//gah! putting this here caused a nasty bug where the monster would get angry as SUB_UseTargets
	//continued to go through the entity list looking for matches
	//monster.targetname = self.targetname;	//so that you can use it again if you wish
	monster.target = mtarget;
	monster.delay = mdelay;
	monster.spawnflags = mflags;
	monster.angles_y = mangles;	
	setorigin(monster, morg);

	oldself = self;
	self = monster;
	monster_spawned_use();		
	self = oldself;		//remember to always change self back at the end of the function!
};	

void() monster_group_use =
{
	local float n;

	BDW_SpawnGroupMonster(self.count, self.origin, self.target, self.delay, self.spawnflags, self.angles_y);
	
	n = 1;

	if (self.count1)
	{
		BDW_SpawnGroupMonster(self.count1, self.dest1, self.target1, self.delay1, self.pos1_y, self.angles1_y);
		n = n + 1;
	}
	if (self.count2)
	{
		BDW_SpawnGroupMonster(self.count2, self.dest2, self.target2, self.delay2, self.pos1_z, self.angles1_z);
		n = n + 1;
	}
	if (self.count3)
	{
		BDW_SpawnGroupMonster(self.count3, self.dest3, self.target3, self.delay3, self.pos2_x, self.angles2_x);
		n = n + 1;
	}	
	if (self.count4)
	{
		BDW_SpawnGroupMonster(self.count4, self.dest4, self.target4, self.delay4, self.pos2_y, self.angles2_y);
		n = n + 1;
	}
	if (self.count5)
	{
		BDW_SpawnGroupMonster(self.count5, self.dest5, self.target5, self.delay5, self.pos2_z, self.angles2_z);
		n = n + 1;
	}
	
	dprint("monster group ");
	dprint(ftos(self.cnt));
	dprint(": ");
	dprint(self.targetname);
	dprint(", spawned ");
	dprint(ftos(n));
	dprint(" monsters\n");
	
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};


float(entity mgroup, float id) AddMonsterToGroup =
{
	if (!mgroup.count1)
	{
		mgroup.count1 	= id;
		mgroup.dest1 	= self.origin;
		mgroup.target1 	= self.target;
		mgroup.delay1 	= self.delay;
		mgroup.pos1_y	= self.spawnflags;
		mgroup.angles1_y = self.angles_y;
		return TRUE;
	}
	if (!mgroup.count2)
	{
		mgroup.count2 	= id;
		mgroup.dest2 	= self.origin;
		mgroup.target2 	= self.target;
		mgroup.delay2 	= self.delay;
		mgroup.pos1_z	= self.spawnflags;
		mgroup.angles1_z = self.angles_y;
		return TRUE;
	}
	if (!mgroup.count3)
	{
		mgroup.count3 	= id;
		mgroup.dest3 	= self.origin;
		mgroup.target3 	= self.target;
		mgroup.delay3 	= self.delay;
		mgroup.pos2_x	= self.spawnflags;	
		mgroup.angles2_x = self.angles_y;
		return TRUE;
	}
	if (!mgroup.count4)
	{
		mgroup.count4 	= id;
		mgroup.dest4 	= self.origin;
		mgroup.target4 	= self.target;
		mgroup.delay4 	= self.delay;
		mgroup.pos2_y	= self.spawnflags;	
		mgroup.angles2_y = self.angles_y;
		return TRUE;
	}
	if (!mgroup.count5)
	{
		mgroup.count5 	= id;
		mgroup.dest5 	= self.origin;
		mgroup.target5 	= self.target;
		mgroup.delay5 	= self.delay;
		mgroup.pos2_z	= self.spawnflags;	
		mgroup.angles2_z = self.angles_y;
		return TRUE;
	}
	
	return FALSE;	//group is full
};

void(float id) BecomeMonsterGroup =
{
	self.classname = "monster_group";
	self.count = id;
	self.use = monster_group_use;	
};

// AddMonsterToList
// Remember - if a monster becomes part of a group, 
// you only retain the following information:
// - monster type
// - origin
// - angles 
// - target/delay
// - spawnflags
float(float id) AddToMonsterList = {
	entity mgroup;	

	if (!(self.spawnflags & M_GROUP)) return FALSE;	//not part of an item group
	if (!self.targetname) { objerror("group monster with no targetname\n"); return FALSE; }

	if (!(self.spawnflags & M_SPAWNED)) self.spawnflags = self.spawnflags | M_SPAWNSILENT;	//monsters that wouldn't spawn normally are always silent

	if (monster_list == world) {
		monster_list = self;
		BecomeMonsterGroup(id);
		self.cnt = 1;	//this records the group's position in the list
		total_monsters = total_monsters + 1;
		return TRUE;
	}

	mgroup = monster_list;
	while(1) {
		if (mgroup.targetname == self.targetname) {			
			if (AddMonsterToGroup(mgroup, id)) {
				remove(self);	//purge item from edicts list
				total_monsters = total_monsters + 1;
				return TRUE;
			}
		}

		if (!mgroup.next_ent) { //reached end of list and still no match
			mgroup.next_ent = self;
			BecomeMonsterGroup(id);
			self.cnt = mgroup.cnt + 1;	//this records the group's position in the list
			total_monsters = total_monsters + 1;
			return TRUE;	//new item group
		}

		mgroup = mgroup.next_ent;
	}
	
	return FALSE;	//shut up compiler warnings
};

//this is called just after the precache and tells you
//whether the monster is spawned in later (true) or placed normally (false)
float(float id) MonsterSpawnedLater = {
	if (self.spawnhack) self.spawnflags = self.spawnflags | self.spawnhack;	//hack to compensate for hammer's gheyness...
	if (AddToMonsterList(id)) return TRUE;
	
	if (self.spawnflags & M_SPAWNED) {
		if (!self.targetname) { objerror("spawned monster with no targetname\n"); return FALSE; }
	
		self.monstertype = id;
		self.classname = "monster_spawned";
		self.use = monster_spawned_use;
		total_monsters = total_monsters + 1;		
		return TRUE;
	}

	return FALSE;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<

GANG SPAWNERS

Allows you to spawn any number of monsters into the level, in grid-like
formations. Excellent for creating epic horde combat situations.

~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>*/

void(float beastie, vector org, vector vel, float ang, float update, entity attacker) BDW_SpawnMonster = {
	local entity monster, spawner;

	if (!beastie) { objerror("monsterspawner: monster type is zero\n"); return; }

	monster = spawn();
	monster.spawnmaster = self;
	//remember ents don't clip against their owner, so this stops monsters getting stuck in solid spawners
	//if the spawner is a monster however, we want normal clipping to occur...
	if (self.flags & FL_MONSTER) { //if spawnmaster is a shuffler...
		monster.monsterflags = MF_SHUFFLER_MINION;
		monster.spawnflags = monster.spawnflags | M_REMOVECORPSE;
		self.frags = self.frags - 1;	//shufflers use this to store how many they can spawn
	} else {
		monster.monsterflags = MF_GANG_SPAWNED;
		monster.owner = self;	

		//pass properties over to the monster...
		monster.spawnflags = monster.spawnflags | self.monsterflags;	//spawnflags...confusing eh? hehe		
		if (self.spawnflags & SPAWN_NODROP) monster.spawnflags = monster.spawnflags | M_SPAWNNODROP; // Don't droptofloor()
		monster.target = self.target;	//call this before monster_start_go
		monster.targetname = self.netname;	//so you can wake spawned monsters up later
		monster.delay = self.delay;	//for triggering stuff later
		monster.height = self.height;		//for scripted jumps
		monster.speed = self.speed;		//for scripted jumps
	}

	spawner = self;
	self = monster;
	if (vel) self.angles = vectoangles(vel); // Do i need to set angles first? does no harm...
	else self.angles_y = ang;

	self.angles_x = self.angles_z = 0;

	// Do the stuff unique to each monster...
	if (beastie == MONSTER_IMP) monster_imp_init();	
	else if (beastie == MONSTER_BLACK_SHUFFLER) monster_black_shuffler_init();
	else if (beastie == MONSTER_WHITE_SHUFFLER) monster_white_shuffler_init();
	else if (beastie == MONSTER_SPIDER) monster_spider_init();
	else { objerror("monsterspawner: bad monster type\n"); return; }

	// Do the generic stuff...
	setorigin(self, org);	//set this before calling monster_start_go because of droptofloor stuff		
	bdw_monster_start_go();	
	if (self.monsterflags & MF_GANG_SPAWNED) {
		if (spawner.spawnflags & SPAWN_NODROP) self.velocity = vel;		

		if (!(spawner.spawnflags & SPAWN_SILENT)) spawn_tfog(self.origin);
	} else spawn_tfog(self.origin);

	spawn_tdeath(self.origin, self);
	if (attacker) {		
		if ( (attacker.flags & FL_CLIENT) || ( (attacker.flags & FL_MONSTER) && (self.monsterflags & MF_SHUFFLER_MINION) ) ) {
			if ( (attacker.health > 0) && (!(attacker.flags & FL_NOTARGET)) ) {
				self.enemy = attacker;
				self.think = FoundTarget;
			}
		}
	}

	if (update) {
		total_monsters = total_monsters + 1;
		WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
        WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
        WriteLong (MSG_BROADCAST, total_monsters);
	}

	self.nextthink = time + 0.2 + random()*0.1;	//increase delay before moving to give teledeaths a chance to dissapear.
	self = spawner;
};

// This determines the order in which monsters are placed, so choose sensibly...
// The monster ranking here is very important, as self.count1-4 refer to this order.
float(float next) BDW_GetNextMonsterType = {
	if (next & MONSTER_FIEND) return MONSTER_FIEND;	//fiends always in front
	if (next & MONSTER_DOG) return MONSTER_DOG;
	if (next & MONSTER_KNIGHT) return MONSTER_KNIGHT;
	if (next & MONSTER_GRUNT) return MONSTER_GRUNT;	
	if (next & MONSTER_SUPER_GRUNT) return MONSTER_SUPER_GRUNT;	
	if (next & MONSTER_SCRAG) return MONSTER_SCRAG;
	if (next & MONSTER_IMP) return MONSTER_IMP;
	if (next & MONSTER_OGRE) return MONSTER_OGRE;
	if (next & MONSTER_FLAK_OGRE) return MONSTER_FLAK_OGRE;
	if (next & MONSTER_HELL_KNIGHT) return MONSTER_HELL_KNIGHT;
	if (next & MONSTER_HELL_KNIGHT_WRAITH) return MONSTER_HELL_KNIGHT_WRAITH;	
	if (next & MONSTER_VORE) return MONSTER_VORE;
	if (next & MONSTER_SHAMBLER) return MONSTER_SHAMBLER;
	if (next & MONSTER_BLACK_SHUFFLER) return MONSTER_BLACK_SHUFFLER;
	if (next & MONSTER_WHITE_SHUFFLER) return MONSTER_WHITE_SHUFFLER;
	if (next & MONSTER_SPIDER) return MONSTER_SPIDER;
	if (next & MONSTER_ZOMBIE) return MONSTER_ZOMBIE;
	return FALSE;
};

float() BDW_CountMonsterTypes = {
	//this just checks self.items2 against all the known monster types and returns
	//the number of different valid types found; the order isn't important...

	local float n;

	if (self.items2 & MONSTER_KNIGHT)
		n = n+1;
	if (self.items2 & MONSTER_SCRAG)
		n = n+1;
	if (self.items2 & MONSTER_IMP)
		n = n+1;
	if (self.items2 & MONSTER_ZOMBIE)
		n = n+1;
	if (self.items2 & MONSTER_OGRE)
		n = n+1;
	if (self.items2 & MONSTER_FLAK_OGRE)
		n = n+1;
	if (self.items2 & MONSTER_HELL_KNIGHT)
		n = n+1;
	if (self.items2 & MONSTER_FIEND)
		n = n+1;
	if (self.items2 & MONSTER_VORE)
		n = n+1;
	if (self.items2 & MONSTER_HELL_KNIGHT_WRAITH)
		n = n+1;
	if (self.items2 & MONSTER_SHAMBLER)
		n = n+1;
	if (self.items2 & MONSTER_DOG)
		n = n+1;
	if (self.items2 & MONSTER_GRUNT)
		n = n+1;
	if (self.items2 & MONSTER_SUPER_GRUNT)
		n = n+1;
	if (self.items2 & MONSTER_WHITE_SHUFFLER)
		n = n+1;
	if (self.items2 & MONSTER_BLACK_SHUFFLER)
		n = n+1;
	if (self.items2 & MONSTER_SPIDER)
		n = n+1;

	return n;
};

float(float mtype, float mnum, float share) BDW_CheckNextMonster =
{
	local float c;

	if (mtype == 1)
		c = self.count1;
	else if (mtype == 2)
		c = self.count2;
	else if (mtype == 3)
		c = self.count3;
	else if (mtype == 4)
		c = self.count4;

	if (c)
	{
		if (mnum == c)
			return TRUE;
	}	
	else if (mnum == share)
		return TRUE;

	return FALSE;
};

void() BDW_GangMonsterSpawnerUse =
{
	local vector newpos;		//work out where to place next baddie
	local float n, r, c, mtype, mnum, share;
	local float beastie, next;
	local entity attacker;

//do counter stuff...
	self.cnt = self.cnt - 1;
	if (self.cnt > 0)
	{
		dprint("monsterspawner: ");
		dprint(ftos(self.cnt));
		dprint(" more to go...\n");
		return;
	}

//we're ready to spawn...

	next = self.items2;

	if (self.spawnflags & SPAWN_ANGRY)
		attacker = activator;
	else
		attacker = world;

//this is the no. of available slots to split between remaining monsters...
	n = self.count - (self.count1 + self.count2 + self.count3 + self.count4);
//count the total no. of monster types...
	share = BDW_CountMonsterTypes();
//of these types, which are unspecified?
	if (self.count1)
		share = share - 1;
	if (self.count2)
		share = share - 1;
	if (self.count3)
		share = share - 1;
	if (self.count4)
		share = share - 1;

	if ((share <= 0) && (n > 0))	//available slots, but we've run out of monster types
	{
		dprint("monsterspawner: no monster types specified to fill available slots\n");	
		self.count = self.count1 + self.count2 + self.count3 + self.count4;	//remove unused slots from self.count
		share = 0;
	}
	else
	{
		share = n / share;
		share = ceil(share);	//ceil'ing this is a bit hacky, as later monsters can get left out
	}

	//dprint(ftos(share));
	//dprint("\n");

	makevectors(self.angles);
	c = r = 0;	//current slot, column, row
	mtype = 1;		//current type of monster
	mnum = 0;		//current monster of type mtype
	n = 1;

	while(n <= self.count)
	{
		newpos = self.origin + (v_right*self.distance*c) - (v_forward*self.distance*r);
		beastie = BDW_GetNextMonsterType(next);		
		BDW_SpawnMonster(beastie, newpos, '0 0 0', self.angles_y, FALSE, attacker);

		mnum = mnum+1;
		if (BDW_CheckNextMonster(mtype, mnum, share))
		{
			next = next - beastie;		//subtract the current monsterflag - we're done with it
			mnum = 0;				//reset monster number
			mtype = mtype + 1;		//go to next monster type
		}

		c = c+1;			//increment column
		if (c == self.volume)	//if at end of rank...
		{
			c = 0;		//...reset column...
			r = r+1;		//...increment row
		}
		n = n+1;			//go to next slot
	}

	self.use = SUB_Null;	//don't trigger more than once or you'll spawn the same monsters all over again (and cause a huge gib shower)
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

// Do radial spawners as well?

// .count	total number of monsties to spawn
// .count1	no. of 1st type of monster
// .count2	no. of 2nd type of monster
// .count3	no. of 3rd type of monster
// .count4	no. of 4th type of monster
// You can explicitly set the numbers of up to four different monster types. the .count1-4 fields correspond
// to the first four monster types specified in .items2, any other monster types are spawned in equal preference
// if further slots are available.
// if .count is set, total monsters will never exceed .count
// if .count is set and monsters are specified which don't explicitly have an associated .countx number,
// they will be spawned in equal preference to fill all available slots
// if .count is not specified, only monsters which have an associated .countx number will be spawned
// e.g. .items2 = 1353 (knight, hellknight, scrag, fiend, shambler)
// .count1 = 5
// .count4 = 3
// .count = 12
// 5 knights and 3 fiends are spawned, the remainder (12 - 8 = 4) is split between the three other monster types,
// i.e. 2 hellknights, 1 scrag, 1 shambler; note that the available slots fill up starting with the weakest monster
// (the hellknight). (edit - no they don't)
// .cnt		no. of times it must be triggered before it activates - do not confuse with self.count
// .delay	delay before spawned monsters trigger their target after death
// .distance	distance between adjacent monsties
// .volume	number of monsters in each "rank". starting from the front left slot, monsters are placed from left to right, working down the ranks.
// .items2	this is a bit field representing what type of monsters to spawn - defaults to 1 (just knights).
// .monsterflags 	put all monster-specific spawnflags in here - note these will be the monster's .spawnflags NOT .monsterflags
// Spawnflags:
// SPAWN_SILENT (no teleport effect)
// SPAWN_NODROP (does not droptofloor() - i.e. spawns in midair.
// SPAWN_FACEINWARD (all monsters face the middle - use with skipfirst)
// SPAWN_FACEOUTWARD (all monsters face outward - overrides faceinward)
// SPAWN_ANGRY (monsters are already coming to mess you up)
// Minimum Distance Values:
// I have experimented with spawning monsters as close together as possible
// for large monsters, with xy dimensions of 64 (fiends, shamblers etc.) it is 68
// for small monstes, with xy dimensions of 32 (knights, hellknights etc.) it is 36
// basically, just add 4 units to the xy size. it adds a gap of one pixel between the monster
// and the teledeath box of the adjacent monster.
void() bdw_monsterspawn_gang = {
	local float c;

	if (!BDW_CountMonsterTypes()) objerror("monsterspawner: bad monstertype\n");
	if (!self.count) self.count = 1;
	c = self.count1 + self.count2 + self.count3 + self.count4;
	if (c > self.count) self.count = c;	
	if (!self.distance) self.distance = 80;
	if (!self.volume) self.volume = 3;

	if (!self.items2)
		self.items2 = MONSTER_KNIGHT;

	if (self.items2 & MONSTER_IMP)
		monster_imp_precache();
	if (self.items2 & MONSTER_BLACK_SHUFFLER)
		monster_black_shuffler_precache();
	if (self.items2 & MONSTER_WHITE_SHUFFLER)
		monster_white_shuffler_precache();
	if (self.items2 & MONSTER_SPIDER)
		monster_spider_precache();	

	self.use = BDW_GangMonsterSpawnerUse;
	total_monsters = total_monsters + self.count;
};