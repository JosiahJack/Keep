
// These are required by the Hipnotic code
//added update stat message
float SVC_UPDATESTAT = 3;
float SVC_CUTSCENE   = 34;
//added total monster message
float STAT_TOTALMONSTERS = 12;
float STAT_TOTALSECRETS = 11;

//=====================================================================
//
// Multi Spawner
//
//=====================================================================

//================
//
// spawn_think
//
//================

void() spawn_think =
   {
   self.think = spawn_think;
   self.nextthink = time + 1;
   };

//================
//
// spawn_use
//
//================

void(vector org) spawn_use =
{
	
	

	local entity spawnentity;
	local entity tempself;

	// spawn the new entity
	spawnentity = spawn();
	// copy the master mold
	SUB_CopyEntity(self.spawnmaster,spawnentity);

	//restore thinking function
	spawnentity.nextthink = time + 0.2;
	spawnentity.think = spawnentity.spawnthink;
		
	// restore the model
	spawnentity.model = spawnentity.spawnmodel;
	//restore solid flag
	spawnentity.solid = spawnentity.spawnsolidtype;

	setmodel (spawnentity, spawnentity.model);
	setorigin (spawnentity, org);
	spawnentity.mins = spawnentity.spawnmins;
	spawnentity.maxs = spawnentity.spawnmaxs;
	setsize (spawnentity, spawnentity.mins, spawnentity.maxs);

	spawnentity.enemy = self.enemy;
	spawnentity.awake = self.awake;

   };




void() spawn_loop =
{


	while (self.cnt < self.count)
	{
		//bprint (vtos(self.neworigin));
	
		spawn_use(self.neworigin);	
	


		
		self.neworigin_x = self.neworigin_x + self.lip;
		if (self.neworigin_x > self.origin_x + self.t_width)
	
		{
			self.neworigin_y = self.neworigin_y + self.lip;
			self.neworigin_x = self.origin_x - self.t_width;
		}
		
		if (self.neworigin_y > self.origin_y + self.t_width)
				SUB_Remove();
	
		self.cnt = self.cnt + 1;
		if (self.cnt >= self.count)
			SUB_Remove();
	
		//self.think = spawn_loop;
		//self.nextthink = time + 0.1;
	}
	

};


void() spawn_loop_start =
{
	if (self.awake == 1)
	{
		self.enemy = activator;
	}
	spawn_loop();
};

/*QUAKED func_multispawn (0 .5 .8) (-32 -32 -24) (32 32 64)

Adapted from Hipnotic's func_spawn function.
This is a powerful entity capable of spawning in hordes of monsters from one single entity.
Needless to say, this is an incredible edict saver.  Sadly, I cannot say that this was my idea, for this entity is inpired by Kinn's own gangspawn function.
Thanks for the inspiration, Kinn!  ^_^

The way this works is quite simple:
The entity will start spawning monsters at the south-west corner of it's zone, working it's way east, then north in increments of 'lip'.
To set the spawning zone, specify a 't_width'.

Example:
't_width' '128'
'lip' '64'

will start spawning monsters 128 units south and 128 units west of the entity's origin, with gaps of 64 units between each of the new monsters.
Obviously, this poses certain limitations on how many monsters can be spawned.  As a result, you can also specify a 'count' which will let the entity know exactly how many monsters you want spawned.


*/

void() func_multispawn =
{
/*	

	self.spawnfunction();


	self.use = spawn_use;

	setmodel (self, "");
	self.model = "";
	setsize (self, self.spawnmins, self.spawnmaxs);
	//save off solid flag
	self.spawnsolidtype = self.solid;
	self.solid = SOLID_NOT;
	//save off think func and
	//get rid of his thinking
	self.spawnthink = self.think;
	self.think = SUB_Null;
	self.nextthink = time + 1;

	//monster = self;
*/
	local entity tempself;
	local entity monster;
	local float tempdeathmatch;
	local float temptotal_monsters;
	local vector mn,mx;

	if (!self.count)
		self.count = 3;
	
	if (!self.t_width)
		self.t_width = 64;
	
	if (!self.lip)
		self.lip = 64;

	
	// save off deathmatch and zero it out
	tempself = self;
	tempdeathmatch = deathmatch;
	deathmatch = 0;

 	// spawn the new entity
 	self = spawn();
 	
 	// copy over everything
 	SUB_CopyEntity(tempself,self);
	

	// save off monster count so it doesn't get f'ed up
	temptotal_monsters = total_monsters;
	

	if (self.spawnclassname == string_null)
		objerror("No spawnclassname defined");
	

	self.classname = self.spawnclassname;
	

	// call the named spawn function
	self.spawnfunction();
	

	if (self.spawnmulti != 0)
	{
		// make sure monster count is correct
		total_monsters = temptotal_monsters;
	}
	
	self.spawnmodel = self.model;
	self.spawnmins = self.mins;
	self.spawnmaxs = self.maxs;
	setmodel (self, "");
	self.model = "";
	setsize (self, self.spawnmins, self.spawnmaxs);
	//save off solid flag
	self.spawnsolidtype = self.solid;
	self.solid = SOLID_NOT;
	//save off think func and
	//get rid of his thinking
	self.spawnthink = self.think;
	self.think = spawn_think;
	self.nextthink = time + 1;
	monster = self;

	self = tempself;
	deathmatch = tempdeathmatch;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	setmodel (self, self.model);  // set size and link into world
	

	self.neworigin = self.origin;

	self.neworigin_x = self.origin_x - self.t_width;

	self.neworigin_y = self.origin_y - self.t_width;
	

	self.use = spawn_loop_start;
	self.spawnmaster = monster;

	if (self.count)
	{
		total_monsters = temptotal_monsters + self.count;
		WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
		WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
		WriteLong (MSG_BROADCAST, total_monsters);
	}

};

//=================================================================================







void() horde_loop =
{

	if (!spawn_tcheck(self.origin))
	{
		spawn_use(self.origin);	
		spawn_tfog (self.origin);
		self.cnt = self.cnt + 1;
	}
	

	self.think = horde_loop;
	self.nextthink = time + 0.3;
	
	if (self.cnt >= self.count)
		SUB_Remove();
};


void() horde_loop_start =
{
	self.enemy = activator;

	horde_loop();
};






//================
//
// func_hordespawn
//
//================
void() func_hordespawn =
{

	local entity tempself;
	local entity monster;
	local float tempdeathmatch;
	local float temptotal_monsters;
	local vector mn,mx;

	temptotal_monsters = total_monsters;
	if (!self.count)
		self.count = 3;


	

	if (self.spawnclassname == string_null)
		objerror("No spawnclassname defined");

	

	monster = spawn();

	SUB_CopyEntity(self,monster);
	
	monster.classname = self.spawnclassname;
	tempself = self;

	self = monster;

	self.spawnfunction();	
	monster = self;

	self = tempself;
	



	monster.spawnmodel = monster.model;
	monster.spawnmins = monster.mins;
	monster.spawnmaxs = monster.maxs;
	setmodel (monster, "");
	monster.model = "";
	setsize (monster, monster.spawnmins, monster.spawnmaxs);
	//save off solid flag
	monster.spawnsolidtype = monster.solid;
	monster.solid = SOLID_NOT;
	//save off think func and
	//get rid of his thinking
	monster.spawnthink = monster.think;
	monster.think = spawn_think;
	monster.nextthink = time + 1;
	monster.enemy = activator;

	monster.awake = 1;
	self.enemy = activator;
	self.awake = 1;	

	

	self.spawnmaster = monster;	

	


	total_monsters = temptotal_monsters;
	total_monsters = total_monsters + self.count;
	WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
	WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
	WriteLong (MSG_BROADCAST, total_monsters);

	self.use = horde_loop_start;



};