
//=================================================
/*
void() magical_spawner_die =
{
	local entity item, spn;
	local float rnd;
	local vector vel;

//reset health
	self.health = 100;

//this is a bit of a hack, but stops spawned fiends killing it with teledeath, amongst other things
	if (!damage_attacker.flags & FL_CLIENT)
		return;

//todo: force a minimum horizontal speed
	vel_z = self.height;
	vel_x = crandom() * self.speed;
	vel_y = crandom() * self.speed;

	rnd = random();

//spawn a fiend every now and then...
	if (rnd < 0.1)
	{
		//remember, angle is automatically determined from velocity...
		BDW_SpawnMonster(MONSTER_FIEND, self.origin, vel, 0, TRUE, damage_attacker);
		return;
	}

//otherwise spawn an item...
//TODO: make all this a separate function, BDW_SpawnItem, similar to the monster one.

	item = spawn();
	item.owner = self;
	item.spawnmaster = self;

	spn = self;
	self = item;

	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;

	self.velocity = vel;
	self.avelocity = crandom() * '0 600 0';

	if (rnd < 0.2)
	{
		self.spawnflags = WEAPON_BIG2;
		item_shells_init();
	}
	else if (rnd < 0.3)
	{
		self.spawnflags = WEAPON_BIG2;
		item_spikes_init();
	}
	else if (rnd < 0.4)
	{
		self.spawnflags = WEAPON_BIG2;
		item_rockets_init();
	}
	else if (rnd < 0.5)
	{
		self.spawnflags = WEAPON_BIG2;
		item_cells_init();
	}

	else if (rnd < 0.6)
	{
		item_health_init();
	}
	else if (rnd < 0.8)
	{
		self.spawnflags = H_ROTTEN;
		item_health_init();
	}
	else if (rnd < 0.9)
	{
		self.classname = "item_armor2";
		item_armor_init();
	}
	else
	{
		self.classname = "item_armorInv";
		item_armor_init();
	}	

	item = self;
	self = spn;

	setorigin(item, self.origin);
	spawn_tfog(self.origin);
};
*/
//TODO: make a unique sprite - white plasma - also have an inactive state when there are too many
//spawned items not picked up.
/*
void() magical_spawner_touch =
{
	if (other.movetype != MOVETYPE_WALK)
		return;

	if (time < self.wetsuit_time)
		return;

	other.velocity_z = other.velocity_z * -1.5;
	self.wetsuit_time = self.wetsuit_time + 1;
};
*/
/*
"speed" default to 100, the horizontal speed
"height" default to 300, the vertical speed
*/

void() func_magical_spawner =
{
	precache_model("sprites/plasma/plasmabig.spr");

//randomise the starting frame...
	local float f;
	f = random()*6;		
	f = ceil(f);
	f = f - 1;
	self.frame = f;

	self.idleweaponframe = 6;
	self.think = BDW_SpriteGenericLoop;
	self.nextthink = time + 0.05;

	self.solid = SOLID_BBOX;	//fixme - why does it always seem solid_slidebox ingame?
	self.movetype = MOVETYPE_NONE;

	setmodel(self, "sprites/plasma/plasmabig.spr");
	setsize(self, '-32 -32 -32', '32 32 32');

	//bdw - disable it temporarily...
	return;
/*
//ammo precache...
	precache_model("progs/q2items/shells.mdl");
	precache_model("progs/q2items/bullets.mdl");
	precache_model("progs/q2items/rockets.mdl");
	precache_model("progs/q2items/cells.mdl");
//health precache...
	precache_model("progs/q2items/mhealth.mdl");
	precache_sound("items/r_item1.wav");
	precache_model("progs/q2items/mega_h.mdl");
	precache_sound("items/r_item2.wav");	
	precache_model("progs/q2items/lhealth.mdl");
	precache_sound("items/health1.wav");
//armor precache...
	precache_model("progs/armor.mdl");
//fiend precache...
	monster_demon_precache();

//defaults are the same as backpacks...
	if (!self.speed)
		self.speed = 100;
	if (!self.height)
		self.height = 300;

	self.takedamage = DAMAGE_AIM;
	self.health = 100;
	self.th_die = magical_spawner_die;
	self.touch = magical_spawner_touch;

	self.spawnflags = self.spawnflags | SPAWN_NODROP;	
*/
};


/*
===================

TREE

Hexen II dead tree

===================
*/

void() bdw_misc_tree =
{
	precache_model("progs/tree.mdl");

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, "progs/tree.mdl");
	setsize(self, '-32 -32 0', '32 32 200');
};

void() bdw_misc_flag =
{
	precache_model("progs/flag10fps.mdl");

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, "progs/flag10fps.mdl");
	setsize(self, '-4 -4 -64', '4 4 140');
};

void() bdw_misc_barrel =
{
	precache_model("models/h2misc/barrel.mdl");

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, "models/h2misc/barrel.mdl");
	setsize(self, '-14 -14 0', '14 14 40');
};

float BELL_IDLE = 0;
float BELL_RINGING = 1;
float BELL_STOPPING = 2;

void() church_bell_ring =
{
	self.frame = self.frame + 1;

	if (self.frame > 30)
		self.frame = 0;

	if (self.frame == 7)
		sound(self, CHAN_VOICE, "misc/bell1.wav", 1, ATTN_NONE);

	self.nextthink = time + 0.1;
	if ( (self.state == BELL_STOPPING) && (self.frame == 30) )
	{
		self.state = BELL_IDLE;
		self.think = SUB_Null;
	}
	else
		self.think = church_bell_ring;
};

void() church_bell_use =
{
	if (self.state == BELL_IDLE)
	{
		church_bell_ring();
		self.state = BELL_RINGING;
	}
	else if (self.state == BELL_RINGING)
		self.state = BELL_STOPPING;
	else
		self.state = BELL_RINGING;
};	
		

void() bdw_misc_church_bell =
{
	precache_model("progs/bellring.mdl");
	precache_sound("misc/bell1.wav");

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	self.use = church_bell_use;
	self.state = BELL_IDLE;

	setmodel(self, "progs/bellring.mdl");
	setsize(self, '-100 -100 -210', '100 100 10');
};

/*
=======================================================================
			   <> RAIN CLOUD <>
=======================================================================

	

	"classname" "weather_rain_cloud"	
	"radius" "#" 	- Radius of cloud
	"cnt" "#" - Number of raindrops spawned in 0.1 sec
	"speed" "#"	- Initial downward velocity of raindrops
	"spawnflags" "1" - Big raindrops

	NOTES - Be careful not to set the raincount too high, resulting
		in packet overflows. I find that a raincount of 5 is
		adequate. A "speed" of around the 400 mark is fine.
		Add variation to your rain by using different ambient
		rain sounds, reflecting storminess etc. I've noticed 
		that rain coming from a jet black night sky looks
		great, and if your map can take transparent water, a
		thin layer on the ground at r_wateralpha 0.1 is nice.

=======================================================================
*/

float RAIN_BIG 		= 1;
float RAIN_BLOOD 	= 2;

void() s_rainsplash1	=	[0,	s_rainsplash2] {self.nextthink = time + 0.05;};
void() s_rainsplash2	=	[1,	s_rainsplash3] {self.nextthink = time + 0.05;};
void() s_rainsplash3	=	[2,	s_rainsplash4] {self.nextthink = time + 0.05;};
void() s_rainsplash4	=	[3,	s_rainsplash5] {self.nextthink = time + 0.05;};
void() s_rainsplash5	=	[4,	s_rainsplash6] {self.nextthink = time + 0.05;};
void() s_rainsplash6	=	[5,	SUB_Remove] {self.nextthink = time + 0.05;};

void() raindrop_touch =
{	
	if (other.classname == "drop")
		return;

	particle(self.origin + '0 0 8', '0 0 0', 35, 3);
	remove(self);

/*	
	self.touch = SUB_Null;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 8;

	setmodel(self, "progs/s_splash.spr");

	s_rainsplash1();
*/

/*
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);	// splash
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}	

	remove(self);
*/
};

//=====================================================================

void() RainDrop = 
{
	local entity drop;
	local vector orgd;

	// randomly place it within the bbox of the raincloud...	

	orgd_x = self.absmin_x + random()*(self.maxs_x - self.mins_x);
	orgd_y = self.absmin_y + random()*(self.maxs_y - self.mins_y);
	orgd_z = self.absmax_z;
	
	//orgd_x = self.radius - (random()*self.radius)*2;
	//orgd_y = self.radius - (random()*self.radius)*2;
	//orgd_z = 0;	
	
	// create new drop

	drop = spawn();

	drop.classname 	= "drop";
	drop.solid 	= SOLID_TRIGGER;
	drop.movetype 	= MOVETYPE_BOUNCE;
	drop.touch 	= raindrop_touch;
	drop.think	= SUB_Remove;
	drop.nextthink 	= time + 5;	// just for completeness

// If we ever want rain at an angle, we need to set a different movetype.

	drop.velocity_x = 0;	// necessary?
	drop.velocity_y = 0;
	drop.velocity_z = -1*self.speed;	// set initial downward speed	
	
	if (self.spawnflags & RAIN_BLOOD)
		drop.skin = 1;
	
	setmodel (drop, self.mdl);
	setsize (drop, '0 0 0', '0 0 0');
	setorigin (drop, orgd);
};	

//=====================================================================

void() rain_cloud_rain = 
{
	local float n;
	n = self.cnt;

	// spawn n drops every 0.1 sec

	self.nextthink = time + 0.1;

// no point raining if there's no-one there to see it...
	//if(!checkclient())
	//	return;

	while (n > 0)
	{
		RainDrop ();
		n = n - 1;
	}	
};	

//=====================================================================

void() misc_rain_cloud =
{	
	if (self.spawnflags & RAIN_BIG)
		self.mdl = "progs/rainbig.mdl";	
	else
		self.mdl = "progs/raindrop.mdl";
	
	precache_model(self.mdl);
	//precache_model("progs/s_splash.spr");

	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model); // set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;			// make sure it's invisible
	self.model = "";				// ditto
	
	self.think = rain_cloud_rain;
	self.nextthink = time + 0.1;
};

// BDW - generic decoration entity...
void() misc_model =
{
	//temp hack...
	if (self.mdl == "progs/imp.mdl")
		self.skin = 1;

	precache_model(self.mdl);
	setmodel(self, self.mdl);
	makestatic(self);
};

/*QUAKED bdw_info_notquitenull (0 0.5 0) (-4 -4 -4) (4 4 4)
An info notnull that removes itself after a couple of secs (identical to info_rotate)
*/
void() bdw_info_notquitenull =
{
// remove self after a little while, to make sure that entities that
// have targeted it have had a chance to spawn
   self.nextthink = time + 2;
   self.think = SUB_Remove;
};

void() bdw_lightning_think =
{
	if (checkclient())
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		WriteCoord (MSG_BROADCAST, self.dest_x);
		WriteCoord (MSG_BROADCAST, self.dest_y);
		WriteCoord (MSG_BROADCAST, self.dest_z);
	}

	self.nextthink = time + 0.1;
};

void() bdw_lightning_firstthink =
{
	local entity ent;

	ent = find(world, targetname, self.target);
	self.dest = ent.origin;

	self.think = bdw_lightning_think;
	self.nextthink = time + 0.1;
};

void() bdw_misc_lightning =
{
	if (!self.target)
		objerror("needs a target!");
	
	self.think = bdw_lightning_firstthink;
	self.nextthink = time + 0.2;	//give targets a chance to spawn
};