
/*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for spotlights, etc.
*/
void() info_null =
{
	remove(self);
};

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void() info_notnull =
{
};

//============================================================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
Lava Balls
*/

void() fire_fly;
void() fire_touch;
void() misc_fireball =
{

	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";
	self.nextthink = time + 0.1 + (random() * 5);	// ben - bugfix
	self.think = fire_fly;
	if (!self.speed)
		self.speed = 1000;	// ben - typo
};

void() fire_fly =
{
	local entity fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	fireball.nextthink = time + 5;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;

	self.nextthink = time + (random() * 5) + 3;
	self.think = fire_fly;
};


void() fire_touch =
{
	T_Damage (other, self, self, 20);
	remove(self);
};

//============================================================================

// BDW - the original barrel_explode has been split into two functions
// to allow the inflictor to do its radius damage first.

void() barrel_damage =
{	
	T_RadiusDamage (self, self, 160, world);
	setorigin(self, self.origin + '0 0 32');

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";     
      self.nextthink = time + 0.1;
	self.think = barrel_damage;
};


/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void() misc_explobox =
{
	local float	oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;	
	precache_model("maps/b_explob.bsp");
	setmodel(self, "maps/b_explob.bsp");
//BDW 06/09/00 don't need sound
	//precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void() misc_explobox2 =
{
	// ben
	misc_explobox();
	return;
	// ben end

	local float	oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model2 ("maps/b_exbox2.bsp");
	setmodel (self, "maps/b_exbox2.bsp");
//BDW 06/09/00 don't need sound
	//precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

//============================================================================


void(vector org, vector vec) LaunchLaser;

//MED 11/09/96 added lava ball and rocket
void() spikeshooter_use =
{
   	local entity lavaball;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
      	if (!self.spawnflags & SPAWNFLAG_SILENT)
         	sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser (self.origin, self.movedir);
      	newmis.spawnflags = self.spawnflags;
	}
   	else if (self.spawnflags & SPAWNFLAG_LAVABALL)
   	{
      	if (!self.spawnflags & SPAWNFLAG_SILENT)
         	sound (self, CHAN_VOICE, "misc/spike.wav", 1, ATTN_NORM);
      	lavaball = spawn();
      	lavaball.movetype = MOVETYPE_FLYMISSILE;
      	lavaball.solid = SOLID_BBOX;
      	lavaball.classname = "lavaball";
      	// set lavaball speed
      	lavaball.velocity = self.movedir * 300;
      	lavaball.angles = vectoangles(lavaball.velocity);
      	lavaball.owner = self;
      	lavaball.touch = T_MissileTouch;
      	setmodel (lavaball, "progs/lavarock.mdl");
      	setsize (lavaball, '-4 -4 -4', '4 4 4');
      	setorigin (lavaball, self.origin);
      	lavaball.avelocity = '0 0 400';
      	lavaball.nextthink = time + 5;
      	lavaball.think = SUB_Remove;
   	}
   	else if (self.spawnflags & SPAWNFLAG_ROCKET)
   	{
      	if (!self.spawnflags & SPAWNFLAG_SILENT)
         	sound (self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);
      	W_FireRocket();
      	newmis.velocity = self.movedir*1000;
      	newmis.angles = vectoangles(newmis.velocity);
      	setorigin (newmis, self.origin + self.movedir*8);
   	}
   	else
	{
      	if (!self.spawnflags & SPAWNFLAG_SILENT)
         	sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
			newmis.touch = superspike_touch;
	}
};

//MED 11/01/96 added state capability
void() shooter_think =
{
   	if (self.state)
      	spikeshooter_use();
      	
   	self.nextthink = time + self.wait;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

//MED 11/01/96 commented out setmovedir
void() trap_spikeshooter =
{
   SetMovedir ();
	self.use = spikeshooter_use;
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2 ("progs/laser.mdl");

		precache_sound2 ("enforcer/enfire.wav");
		precache_sound2 ("enforcer/enfstop.wav");
	}
   else if (self.spawnflags & SPAWNFLAG_LAVABALL)
   {
      precache_model ("progs/lavarock.mdl");
//      self.classname = "fireball";
      precache_sound2 ("misc/spike.wav");
   }
   else if (self.spawnflags & SPAWNFLAG_ROCKET)
   {
      precache_model ("progs/missile.mdl");
      precache_sound ("weapons/sgun1.wav");
   }
   else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();

	if (self.wait == 0)
		self.wait = 1;
//MED 11/01/96 added state capability
   self.state = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
};

//MED 11/01/96 added new use function
void() trap_shooter_use =
   {
   self.state = 1 - self.state;
   };
//MED 11/01/96 added new function
/*QUAKED trap_switched_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
"state" 0 initially off, 1 initially on. (0 default)
*/
void() trap_switched_shooter =
   {
   trap_spikeshooter ();

	if (self.wait == 0)
		self.wait = 1;
//MED 11/01/96 added state capability
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
   self.use = trap_shooter_use;
   };

/*
===============================================================================


===============================================================================
*/

void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)

testing air bubbles
*/

void() air_bubbles =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void() make_bubbles =
{
	local entity bubble;

	bubble = spawn();

	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;

	setmodel(bubble, "progs/s_bubble.spr");
	setsize(bubble, '-8 -8 -8', '8 8 8');
	setorigin(bubble, self.origin);
	
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
	local entity bubble;

	bubble = spawn();

	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;

	setmodel(bubble, "progs/s_bubble.spr");
	setsize(bubble, '-8 -8 -8', '8 8 8');
	setorigin(bubble, self.origin);
	
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	
	self.frame = 1;
	self.cnt = 10;

	//bdw 07/11/04 - this doesn't work btw!
	if (self.waterlevel != 3)
		remove (self);
};

void() bubble_remove =
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void() bubble_bob =
{
local float		rnd1, rnd2, rnd3;
local vector	vtmp1, modi;

	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();	
	if (self.cnt == 20)
		remove(self);

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;

	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;

	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;

	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;

	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/

//bdw - commented out
/*void() viewthing =

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
};*/


/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =

{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic (self);	//bdw 05/11/04 - previously this had no parameters
};

void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

//bdw - 28/04/04 - invisible wall
//an invisible but solid barrier - good for blocking missiles and such.
void() func_invisible_wall =
{
	func_wall();
	self.use = SUB_Null;
	self.model = "";
};

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void() func_episodegate =
{
	if (!(serverflags & self.spawnflags))
		return;			// can still enter episode

	func_wall();
};

/*QUAKED func_bossgate (0 .5 .8) ?
This bmodel appears unless players have all of the episode sigils.
*/
void() func_bossgate =
{
	if ( (serverflags & 15) == 15)
		return;		// all episodes completed
	
	func_wall();
};