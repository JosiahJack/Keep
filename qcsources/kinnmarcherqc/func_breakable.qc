/*
=======================================================================

		     <>	BREAKABLE AND EXPLODING <>
				OBJECTS

			     By Ben Wooding

=======================================================================
*/

float BREAK_THRESHOLD	= 1;
float BREAK_EXPLODE	= 2;
float BREAK_ONTOUCH	= 4;

void() RubbleTouch = 
{
	if ( (other.takedamage) && (other.health > 0) )
	{
		sound (self, CHAN_VOICE, "zombie/z_hit.wav", 1, ATTN_NORM);
		spawn_touchblood (30);		
		remove (self);		
	}	
};

//=====================================================================

void() ThrowRubble = 
{
	local entity chunk;
	local string gibname;
	local float rand;
	local vector org;
	
	rand = random()*4;

	if (rand < 1)
		gibname = self.target1;
	else if (rand < 2)
		gibname = self.target2;
	else if (rand < 3)
		gibname = self.target3;
	else
		gibname = self.target4;	

	chunk = spawn();			
	
	chunk.movetype = MOVETYPE_BOUNCE;	
	chunk.flags = FL_NOSELECT;

	//do touch function here if damage set, calls rubble touch	

	org_x = self.origin_x + self.mins_x + random()*(self.maxs_x - self.mins_x);
	org_y = self.origin_y + self.mins_y + random()*(self.maxs_y - self.mins_y);
	org_z = self.origin_z + self.mins_z + random()*(self.maxs_z - self.mins_z);

	chunk.velocity_x = crandom()*50;
	chunk.velocity_y = crandom()*50;
	chunk.velocity_z = 100 + random()*300;

	chunk.avelocity_x = random()*600;
	chunk.avelocity_y = random()*600;
	chunk.avelocity_z = random()*600;	

	chunk.think = SUB_Remove;
	chunk.nextthink = time + 5 + random()*5;

	if (self.worldtype == 1)
		chunk.skin = 1;	//brown stone

	setmodel(chunk, gibname);
	setsize(chunk, '0 0 0', '0 0 0');
	setorigin(chunk, org);
};

//=====================================================================

void() breakable_use = 
{
	local entity e;

	self.takedamage = DAMAGE_NO;
	self.use = SUB_Null;
	self.th_die = SUB_Null;	
	self.touch = SUB_Null;
	
	while(self.cnt)
	{
		ThrowRubble();
		self.cnt = self.cnt - 1;
	}

	sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	//if (self.dmg)	 
		//do radius damage

//make sure all objects on top of the breakable know that the ground has been removed...
	e = nextent(world);
	while (e)
	{
		if (e.groundentity == self)
		{
			//dprint(e.classname);dprint(" set to fall\n");
			e.flags = e.flags - (e.flags & FL_ONGROUND);
		}

		e = nextent(e);
	}

	if (self.spawnflags & BREAK_EXPLODE)
	{
		particle (self.origin + '0 0 32', '0 0 0', 75, 255);
		sound (self, CHAN_BODY, "weapons/r_exp3.wav", 1, ATTN_NORM);
		self.origin_z = self.origin_z + 32;
		BecomeExplosion();
		return;
	}	

	BDW_TouchRemove(self);
	//remove(self);
};

void() breakable_threshold = 
{
	self.health = self.max_health;	// reset health
};

void() breakable_touch =
{
	if (self.spawnflags & BREAK_ONTOUCH)
	{
		if ( (other.flags & FL_MONSTER) || (other.classname == "player") )
		{
			other.flags = other.flags - (other.flags & FL_ONGROUND);

			breakable_use();
		}
	}

	if (other.classname == "player")
	{
		if (self.message != "")
		{
			if (self.voice_finished < time)
			{
				centerprint (other, self.message);
				sound(other, CHAN_AUTO, "misc/talk.wav", 1, ATTN_NORM);
				self.voice_finished = time + 2;
			}
		}
	}
};
	

//=====================================================================

/*
=======================================================================
QUAKED func_breakable_xxx (0 .5 .8) ?

<worldtype>	<0>	- grey stone
		<1>	- brown stone
		<2>	- wood
		<3>	- metal
<cnt>			- number of gibs to throw
<health> 		- will gib after this much damage
<gib_health>	- if set, gibs will hurt player <gib_health> amount
<dmg>			- if set, it will cause a radius damage of <dmg>
<target>		- set this if you want items on top of the breakable to fall down when it breaks
<message>		- will display this message if touched
<spawnflags> <1> 	- will ignore less than <health> damage
<spawnflags> <2>  - will become an explosion (good idea to set <dmg> also)
<spawnflags> <4>	- break on touch


(todo?: for break on touch - you could give a mass threshold, eg. won't break for small
monsters like spiders but will break with larger ones - needs to add up total mass though which could be tricky)

Appears like a normal brush but will gib when triggered or killed
=======================================================================
*/

//05/09/00

void() func_breakable =
{
	if (self.worldtype <= 1)
	{
		self.target1 = "progs/schunk1.mdl";
		self.target2 = "progs/schunk2.mdl";
		self.target3 = "progs/schunk3.mdl";
		self.target4 = "progs/schunk4.mdl";
		self.noise = "misc/wallbrk.wav";
	}
	else if (self.worldtype == 2)
	{
		self.target1 = "progs/wood1.mdl";
		self.target2 = "progs/wood2.mdl";
		self.target3 = "progs/wood3.mdl";
		self.target4 = "progs/wood4.mdl";
		self.noise = "misc/woodbrk.wav";
	}
	else
	{
		self.target1 = "progs/metlchk1.mdl";
		self.target2 = "progs/metlchk2.mdl";
		self.target3 = "progs/metlchk3.mdl";
		self.target4 = "progs/metlchk4.mdl";
		self.noise = "misc/metalbrk.wav";
	}

	precache_model(self.target1);
	precache_model(self.target2);
	precache_model(self.target3);
	precache_model(self.target4);
	precache_sound(self.noise);

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.classname = "breakable";	// for deathstring (if needed)

	if(!self.deathtype)		// c'mon - use your imagination!
		self.deathtype = "blew up";

	// if health is set, brush can be gibbed by normal damage

	if (self.health)	
	{
		self.takedamage = DAMAGE_YES;		
		self.th_die = breakable_use;

		// if threshold is set, brush will reset health if not fully gibbed
	
		if (self.spawnflags & BREAK_THRESHOLD)
		{
			self.max_health = self.health;
			self.th_pain = breakable_threshold;
		}
	}

	self.touch = breakable_touch;
	self.use = breakable_use;	// will gib if triggered

	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);
	setorigin (self, self.origin);
};
