
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

float START_OFF = 1;

void() light_use =
{
	if (self.spawnflags & START_OFF)
	{
		lightstyle(self.style, "m");
		self.spawnflags = self.spawnflags - START_OFF;
	}
	else
	{
		lightstyle(self.style, "a");
		self.spawnflags = self.spawnflags + START_OFF;
	}
};

/*QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
*/
void() light =
{
	if (!self.targetname)
	{	// inert light
		remove(self);
		return;
	}
	
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
};

/*QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
Makes steady fluorescent humming sound
*/
void() light_fluoro =
{
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
	
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
	remove(self);
};

/*QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8)
Non-displayed light.
Default light value is 300
Default style is 10
Makes sparking, broken fluorescent sound
*/
void() light_fluorospark =
{
	if (!self.style)
		self.style = 10;

	precache_sound ("ambience/spark2.wav");
	ambientsound (self.origin, "ambience/spark2.wav", 0.5, ATTN_STATIC);
	remove(self);
};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
Sphere globe light.
Default light value is 300
Default style is 0
*/
void() light_globe =
{
	precache_model ("progs/s_light.spr");
	setmodel (self, "progs/s_light.spr");
	makestatic (self);
};

void() FireAmbient =
{
	precache_sound ("ambience/fire1.wav");
// attenuate fast
	ambientsound (self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_candle (0 .5 0) (-8 -8 -8) (8 8 8)
SOE: Rogue Candle
*/
void() light_candle =
{
	precache_model ("progs/candle.mdl");
	setmodel (self, "progs/candle.mdl");
	makestatic(self);
};

/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
Short wall torch
Default light value is 200
Default style is 0
*/
void() light_torch_small_walltorch =
{
	precache_model ("progs/flame.mdl");
	setmodel (self, "progs/flame.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame ball
*/
void() light_flame_large_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	self.frame = 1;
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame ball
*/
void() light_flame_small_yellow =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
Small white flame ball
*/
void() light_flame_small_white =
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
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
	self.nextthink = time + (random() * 5);
	self.think = fire_fly;
	if (!self.speed)
		self.speed == 1000;
};

void() fire_fly =
{
local entity	fireball;

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


//----------------------------------------------------/ Code Change /-----//
//  This fixes a bug in which barrel explosions cancel other explosions.
//  Here, the barrel explosion is delayed for one frame so that other
//  explosions can occur without interference from the barrel.
//------------------------------------------------------------------------//
void() barrel_damage =
{
    T_RadiusDamage (self, self, 160, world);
    setorigin (self, self.origin + '0 0 32');
    self.effects = self.effects | EF_MUZZLEFLASH;
    BecomeExplosion ();
};

void() barrel_explode =
{
    self.takedamage = DAMAGE_NO;
    self.classname = "explo_box";
    sound (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
    particle (self.origin + '0 0 32', '0 0 0', 75, 255);
    self.nextthink = time + 0.1;
    self.think = barrel_damage;
};
//------------------------------------------------------------/ END /-----//



/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void() misc_explobox =
{
	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("maps/b_explob.bsp");
	setmodel (self, "maps/b_explob.bsp");
	precache_sound ("weapons/r_exp3.wav");
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
	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model2 ("maps/b_exbox2.bsp");
	setmodel (self, "maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");
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

float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;

void(vector org, vector vec) LaunchLaser;

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser (self.origin, self.movedir);
	}
	else
	{
		sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
		launch_spike (self.origin, self.movedir);
		newmis.velocity = self.movedir * 500;
		if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
			newmis.touch = superspike_touch;
	}
};

void() shooter_think =
{
	spikeshooter_use ();
	self.nextthink = time + self.wait;
	newmis.velocity = self.movedir * 500;
};


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

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
	else
		precache_sound ("weapons/spike2.wav");
};


/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/
void() trap_shooter =
{
	trap_spikeshooter ();
	
	if (self.wait == 0)
		self.wait = 1;
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
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
local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void() bubble_split =
{
local entity	bubble;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = 10;
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

void() viewthing =

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
};


/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void() func_wall_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void() func_wall =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};


/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void() func_illusionary =

{
	if (notHere())
	{
		remove(self);
		return;
	}
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	makestatic ();
};

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void() func_episodegate =

{
	if (!(serverflags & self.spawnflags))
		return;			// can still enter episode

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*QUAKED func_bossgate (0 .5 .8) ?
This bmodel appears unless players have all of the episode sigils.
*/
void() func_bossgate =

{
	if ( (serverflags & 15) == 15)
		return;		// all episodes completed
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

//============================================================================
/*QUAKED ambient_suck_wind (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_suck_wind =
{
	precache_sound ("ambience/suck1.wav");
	ambientsound (self.origin, "ambience/suck1.wav", 1, ATTN_STATIC);
	remove(self);
};

// SoE ambiences
void() ambient_wind1 =
{
	precache_sound ("ambience/wind1.wav");
	ambientsound (self.origin, "ambience/wind1.wav", 1, ATTN_STATIC);
	remove(self);
};

void() ambient_lava =
{
	precache_sound ("ambience/lava1.wav");
	ambientsound (self.origin, "ambience/lava1.wav", 1, ATTN_STATIC);
};

void() ambient_water1 =
{
	precache_sound ("ambience/current1.wav");
	ambientsound (self.origin, "ambience/current1.wav", 1, ATTN_STATIC);
	remove(self);
};

void() ambient_water2 =
{
	precache_sound ("ambience/mov_watr.wav");
	ambientsound (self.origin, "ambience/mov_watr.wav", 1, ATTN_STATIC);
	remove(self);
};

void() ambient_throb1 =
{
	precache_sound ("ambience/amb21.wav");
	ambientsound (self.origin, "ambience/amb21.wav", 1, ATTN_STATIC);
	remove(self);
};

void() ambient_throb2 =
{
	precache_sound ("ambience/amb22.wav");
	ambientsound (self.origin, "ambience/amb22.wav", 1, ATTN_STATIC);
	remove(self);
};

void() ambient_throb3 =
{
	precache_sound ("ambience/amb23.wav");
	ambientsound (self.origin, "ambience/amb23.wav", 1, ATTN_STATIC);
	remove(self);
};

void() ambient_throb4 =
{
	precache_sound ("ambience/amb24.wav");
	ambientsound (self.origin, "ambience/amb24.wav", 1, ATTN_STATIC);
	remove(self);
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drone =
{
	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
	remove(self);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_flouro_buzz =
{
	precache_sound ("ambience/spark2.wav");
	ambientsound (self.origin, "ambience/spark2.wav", 1, ATTN_STATIC);
	remove(self);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
Uses sound from Q2 demo
*/
void() ambient_drip =
{
	precache_sound ("ambience/drip_amb.wav");
	ambientsound (self.origin, "ambience/drip_amb.wav", 0.5, ATTN_STATIC);
	remove(self);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_comp_hum =
{
	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
	remove(self);
};
/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
	remove(self);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_light_buzz =
{
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
	remove(self);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp1 =
{
	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
	remove(self);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp2 =
{
	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
	remove(self);
};

//============================================================================

void() noise_think =
{
	self.nextthink = time + 0.5;
	sound (self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound (self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound (self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound (self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound (self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound (self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
};

/*QUAKED misc_noisemaker (1 0.5 0) (-10 -10 -10) (10 10 10)

For optimzation testing, starts a lot of sounds.
*/

void() misc_noisemaker =

{
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/idle1.wav");

	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};

/*QUAKED misc_tree (1 0 1) (-16 -16 -24) (16 16 56) CAN_KILL
Decorative tree.
cnt = style of tree (0 to 2)
spawnflag 1 makes tree take damage
health = strength of tree. default is 200
targetname = trees that are targeted will disintegrate (die)
target = objects targeted after felling
*/
float CAN_KILL = 1;

void() tree_die = {
	// Make disintegration noise
    sound (self, CHAN_VOICE, "misc/woodbrk.wav", 1, ATTN_NORM);
	// Spawn some rubble
	ThrowGib ("progs/rubble1.mdl", self.health);
	ThrowGib ("progs/rubble2.mdl", self.health);
	ThrowGib ("progs/rubble3.mdl", self.health);
	ThrowGib ("progs/rubble4.mdl", self.health);
	// Fire targets
	SUB_UseTargets();
	// Remove self
	remove(self);
};

void() tree_pain = {
    sound (self, CHAN_VOICE, "misc/met2wd.wav", 1, ATTN_NORM);
};

void() misc_tree = {
	if (notHere())
	{
		remove(self);
		return;
	}
	if (!self.cnt)
		self.cnt = 0;

	if (self.cnt < 0 && self.cnt > 3)
		self.cnt = 0;

	if (self.spawnflags & CAN_KILL){
		self.th_pain = tree_pain;
		self.th_die = tree_die;
		self.takedamage = DAMAGE_AIM;
		if (!self.health)
			self.health = 200;
		precache_model("progs/rubble1.mdl");
		precache_model("progs/rubble2.mdl");
		precache_model("progs/rubble3.mdl");
		precache_model("progs/rubble4.mdl");
	}
	else {
		self.takedamage = DAMAGE_NO;
	}
	
	if (self.targetname)
		self.use = tree_die;

	precache_sound("misc/woodbrk.wav");
	precache_sound("misc/met2wd.wav");

	if (self.cnt == 0){
		precache_model("progs/tree.mdl");
		setmodel(self, "progs/tree.mdl");
	}
	else {
		precache_model("progs/tree2.mdl");
		setmodel(self, "progs/tree2.mdl");
		if (self.cnt == 2)
			self.skin = 1;
	}

	setsize(self, '-16 -16 0', '16 16 128');
	self.solid = SOLID_BBOX;
	droptofloor();
};

// SoE: Random sounds from Painkeep
float() rand_time =
{
  return time + 1 + random() * 30;
};

void() func_thumpsound_play =
{

    local float r;
    local string sname;
    r = random() * 8;
    if (r < 1)
      sname = "random/thump/thump_1.wav";
    else if (r < 2)
      sname = "random/thump/thump_2.wav";
    else if (r < 3)
      sname = "random/thump/thump_3.wav";
    else if (r < 4)
      sname = "random/thump/thump_4.wav";
    else if (r < 5)
      sname = "random/thump/thump_5.wav";
    else if (r < 6)
      sname = "random/thump/thump_6.wav";
    else if (r < 7)
      sname = "random/thump/thump_7.wav";
    else
      sname = "random/thump/thump_8.wav";
    sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
    self.nextthink = rand_time();
};

void() func_sound_thump =
{
  // precaches
  precache_sound("random/thump/thump_1.wav");
  precache_sound("random/thump/thump_2.wav");
  precache_sound("random/thump/thump_3.wav");
  precache_sound("random/thump/thump_4.wav");
  precache_sound("random/thump/thump_5.wav");
  precache_sound("random/thump/thump_6.wav");
  precache_sound("random/thump/thump_7.wav");
  precache_sound("random/thump/thump_8.wav");

  self.think = func_thumpsound_play;
  self.nextthink = rand_time();
};
void() func_wind_play =
{

    local float r;
    local string sname;
    r = random() * 5;
    if (r < 1)
      sname = "random/wind_1.wav";
    else if (r < 2)
      sname = "random/wind_2.wav";
    else if (r < 3)
      sname = "random/wind_3.wav";
    else if (r < 4)
      sname = "random/wind_4.wav";
    else if (r < 5)
      sname = "random/wind_5.wav";
    sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
    self.nextthink = rand_time();
};

void() func_sound_wind =
{
  // precaches
  precache_sound("random/wind_1.wav");
  precache_sound("random/wind_2.wav");
  precache_sound("random/wind_3.wav");
  precache_sound("random/wind_4.wav");
  precache_sound("random/wind_5.wav");

  self.think = func_wind_play;
  self.nextthink = rand_time();
};

void() corpse_die =
{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
    sound (self, CHAN_VOICE, "misc/decomp.wav", 1, ATTN_NORM);
	SUB_UseTargets();
	remove(self);
};

void() misc_corpse =
{
//	precache_model ("progs/player.mdl");
	precache_sound ("misc/decomp.wav");
	setmodel (self, "progs/player.mdl");
	self.frame = 49;
	setsize (self, '-16 -16 -24', '16 16 -8');
	self.solid = SOLID_BBOX;
	self.health = 75;
	self.th_die = corpse_die;
	self.takedamage = DAMAGE_AIM;
	droptofloor();
};

/*QUAKED misc_meat (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is a decorative pile of rotting meat/gibs.  Dogs will stop what they are doing to enjoy this tasty meal.  Good for ambience.
OUM: May find a use for this :)
*/
void() meat_die =
{
	remove(self);
};

void() misc_meat =
{
local entity	meat1,meat2,meat3,meathead;
local vector	org;

	meat1 = spawn ();
	meat1.owner = self;
	meat1.movetype = MOVETYPE_BOUNCE;
	meat1.solid = SOLID_BBOX;
	meat1.takedamage = DAMAGE_AIM;
	meat1.touch = SUB_Null;
	meat1.velocity_z = 50 * random();
	meat1.avelocity = '100 300 200';
	org = self.origin + '20 5 5';
	meat1.classname = "gib";
	meat1.think = SUB_Null;
	meat1.health = 10;
	meat1.th_pain = SUB_Null;
	meat1.th_die = meat_die;
	setmodel (meat1, "progs/gib3.mdl");
	setsize (meat1, '0 0 0', '0 0 0');		
	setorigin (meat1, org);

	meat2 = spawn ();
	meat2.owner = self;
	meat2.movetype = MOVETYPE_BOUNCE;
	meat2.solid = SOLID_BBOX;
	meat2.takedamage = DAMAGE_AIM;
	meat2.touch = SUB_Null;
	meat2.velocity_z = 50 * random();
	meat2.avelocity = '200 100 300';
	org = self.origin + '10 20 5';
	meat2.classname = "gib";
	meat2.health = 10;
	meat2.th_pain = SUB_Null;
	meat2.th_die = meat_die;
	meat2.think = SUB_Null;
	setmodel (meat2, "progs/gib2.mdl");
	setsize (meat2, '0 0 0', '0 0 0');		
	setorigin (meat2, org);

	meat3 = spawn ();
	meat3.owner = self;
	meat3.movetype = MOVETYPE_BOUNCE;
	meat3.solid = SOLID_BBOX;
	meat3.takedamage = DAMAGE_AIM;
	meat3.touch = SUB_Null;
	meat3.velocity_z = 50 * random();
	meat3.avelocity = '500 10 200';
	org = self.origin + '-10 -20 5';
	meat3.classname = "gib";
	meat3.health = 10;
	meat3.th_pain = SUB_Null;
	meat3.th_die = meat_die;
	meat3.think = SUB_Null;
	setmodel (meat3, "progs/gib2.mdl");
	setsize (meat3, '0 0 0', '0 0 0');		
	setorigin (meat3, org);

	meathead = spawn ();
	meathead.owner = self;
	meathead.movetype = MOVETYPE_BOUNCE;
	meathead.solid = SOLID_BBOX;
	meathead.takedamage = DAMAGE_AIM;
	meathead.touch = SUB_Null;
	meathead.velocity_z = 50 * random();
	meathead.avelocity = '150 350 225';
	org = self.origin + '2 2 5';
	meathead.classname = "meat";
	meathead.health = 10;
	meathead.th_pain = SUB_Null;
	meathead.th_die = meat_die;
	meathead.think = SUB_Null;
	setmodel (meathead, "progs/h_player.mdl");
	setsize (meathead, '-16 -16 0', '16 16 26');
	setorigin (meathead, org);

	remove(self);
};

/*QUAKED misc_statue (.8 .5 .5) (-16 -16 -24) (16 16 40)
A statue of the player.
*/
void() misc_statue ={
	setmodel (self, "progs/player.mdl");
	self.skin = 1; // stone
	self.frame = 13;
	setsize (self, '-16 -16 -24', '16 16 40');
	self.solid = SOLID_BBOX;
	self.takedamage = DAMAGE_NO;
	droptofloor();
};

void() play_sound_use =
   {
   if (self.spawnflags & 1)
      {
      if (self.state == 0)
         {
         self.state = 1;
         sound (self, self.impulse, self.noise, self.volume, self.speed);
         }
      else
         {
         self.state = 0;
         sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
         }
      }
   else
      {
      sound (self, self.impulse, self.noise, self.volume, self.speed);
      }
   };

void() PlaySoundThink =
   {
   local float t;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   play_sound_use();
   };

/*QUAKED play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
play a sound when it is used
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"noise" sound to play
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound_triggered =
   {
   precache_sound (self.noise);
   precache_sound ("misc/null.wav");
   if (self.volume == 0)
      self.volume = 1;
   if (self.speed == 0)
      self.speed = 1;
   if (self.speed == -1)
      self.speed = 0;
   if (self.spawnflags & 1)
      if (self.impulse == 0)
         self.impulse = 7;
   self.use = play_sound_use;
   };

/*QUAKED play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
play a sound on a periodic basis
"volume" how loud (1 default full volume)
"noise" sound to play
"wait" random time between sounds (default 20)
"delay" minimum delay between sounds (default 2)
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound =
   {
   local float t;

   play_sound_triggered();
   if (self.wait == 0)
      self.wait = 20;
   if (self.delay == 0)
      self.delay = 2;
   self.think = PlaySoundThink;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   };
