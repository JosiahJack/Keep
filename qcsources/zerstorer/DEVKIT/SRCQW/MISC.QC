
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

	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
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

//=======================================================================
//==START GIB FOUNTAIN MOD===============================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8) NOTHING GIB_FOUNTAIN
Lava Balls and Gib Fountain.  "speed" field for vertical velocity.
*/

float GIB_FOUNTAIN = 2; //just because I made the zombies and push brush = 2

void() fire_fly;
void() fire_touch;
void() gib_touch; 
void() fire_use;

void() misc_fireball =
{
      if (self.spawnflags & GIB_FOUNTAIN)
	{
		if (!(self.delay == 1))
		{
              precache_sound ("gibfnt/gf_sprt1.wav");
              precache_sound ("gibfnt/gf_sprt2.wav");
              precache_sound ("gibfnt/gf_plop.wav");
              precache_sound ("gibfnt/gf_sbig.wav");
		}
		precache_model ("progs/gib4.mdl");
	}
      else
              precache_model ("progs/lavaball.mdl");

      if (self.spawnflags & GIB_FOUNTAIN)
              self.nextthink = time + (random() * 2);
      else
              self.nextthink = time + (random() * 5);

	if (self.targetname)
	{
		self.nextthink = 0;
		self.use = fire_use;
	}
	
      self.classname = "fireball";
      self.think = fire_fly;
      if (!self.speed)
              self.speed == 1000;
};

void() fire_use =
{
	self.nextthink = time + 0.5;
};

void() TossGibs =
{
local entity	gib1, gib2, ghead, cube;

        gib1 = spawn();
        gib1.solid = SOLID_TRIGGER;
        gib1.velocity = '0 0 1000';
        gib1.velocity_x = (random() * 100) - 50;
        gib1.velocity_y = (random() * 100) - 50;
        gib1.velocity_z = self.speed + (random() * 200);
        gib1.classname = "fireball";
        gib1.movetype = MOVETYPE_BOUNCE;
	  gib1.avelocity_x = random() * 200;
	  gib1.avelocity_y = random() * 100;
	  gib1.avelocity_z = random() * 300;
        setsize (gib1, '0 0 0', '0 0 0');
	  setmodel (gib1, "progs/gib2.mdl");
        setorigin (gib1, self.origin);
        gib1.touch = gib_touch;
  	  cube = find(world, classname, "BloodCube");
	  while(cube != world)
	  {
	    if (cube.delay == 1)
	 	if (visible(cube))
	 	{
			gib1.movetype = MOVETYPE_FLY;
			gib1.solid = SOLID_BBOX;
			gib1.enemy = cube;
			gib1.think = SeekCube;
			gib1.nextthink = time + 0.2 + random()*1;
			//return;
	 	}
	    cube = find(cube, classname, "BloodCube");
	  }

        gib2 = spawn();
        gib2.solid = SOLID_TRIGGER;
        gib2.velocity = '0 0 1000';
        gib2.velocity_x = (random() * 100) - 50;
        gib2.velocity_y = (random() * 100) - 50;
        gib2.velocity_z = self.speed + (random() * 200);
        gib2.classname = "fireball";
        gib2.movetype = MOVETYPE_BOUNCE;
	  gib2.avelocity_x = random() * 100;
	  gib2.avelocity_y = random() * 200;
	  gib2.avelocity_z = random() * 300;
        setsize (gib2, '0 0 0', '0 0 0');
	  setmodel (gib2, "progs/gib3.mdl");
        setorigin (gib2, self.origin);
        gib2.touch = gib_touch;
  	  cube = find(world, classname, "BloodCube");
	  while(cube != world)
	  {
	    if (cube.delay == 1)
	 	if (visible(cube))
	 	{
			gib2.movetype = MOVETYPE_FLY;
			gib2.solid = SOLID_BBOX;
			gib2.enemy = cube;
			gib2.think = SeekCube;
			gib2.nextthink = time + 0.2 + random()*1;
			//return;
	 	}
	    cube = find(cube, classname, "BloodCube");
	  }

        ghead = spawn();
        ghead.solid = SOLID_TRIGGER;
        ghead.velocity = '0 0 1000';
        ghead.velocity_x = (random() * 100) - 50;
        ghead.velocity_y = (random() * 100) - 50;
        ghead.velocity_z = self.speed + (random() * 200);
        ghead.classname = "fireball";
        ghead.movetype = MOVETYPE_BOUNCE;
	  ghead.avelocity_x = random() * 300;
	  ghead.avelocity_y = random() * 200;
	  ghead.avelocity_z = random() * 100;
        setsize (ghead, '0 0 0', '0 0 0');
	  setmodel (ghead, "progs/h_player.mdl");
        setorigin (ghead, self.origin);
        ghead.touch = gib_touch;
  	  cube = find(world, classname, "BloodCube");
	  while(cube != world)
	  {
	    if (cube.delay == 1)
	 	if (visible(cube))
	 	{
			ghead.movetype = MOVETYPE_FLY;
			ghead.solid = SOLID_BBOX;
			ghead.enemy = cube;
			ghead.think = SeekCube;
			ghead.nextthink = time + 0.2 + random()*1;
			//return;
	 	}
	    cube = find(cube, classname, "BloodCube");
	  }
	
	  if (!(self.delay == 1))
	    sound (self, CHAN_AUTO, "gibfnt/gf_sbig.wav", 1, ATTN_NORM);
};

void() fire_fly =
{
local entity    fireball, cube;
local float	randmn;	

        fireball = spawn();
        fireball.solid = SOLID_TRIGGER;
        fireball.velocity_x = (random() * 100) - 50;
        fireball.velocity_y = (random() * 100) - 50;
        fireball.velocity_z = self.speed + (random() * 200);
        fireball.classname = "fireball";

        if (self.spawnflags & GIB_FOUNTAIN)
        {
		randmn = random();
		if (randmn < 0.15)
		{
		    setmodel (fireball, "progs/gib4.mdl");
		    TossGibs();
		}
            else if (randmn < 0.45)
                setmodel (fireball, "progs/gib1.mdl");
            else if (randmn < 0.85)
                setmodel (fireball, "progs/gib4.mdl");
            else
                setmodel (fireball, "progs/gib3.mdl");
            fireball.movetype = MOVETYPE_BOUNCE;
		fireball.avelocity = '100 200 300';

		if (!(self.delay == 1))
		{
		 if (random() < 0.5)
		  sound (self, CHAN_VOICE, "gibfnt/gf_sprt1.wav", 1, ATTN_NORM);
		 else
		  sound (self, CHAN_VOICE, "gibfnt/gf_sprt2.wav", 1, ATTN_NORM);
		}
// dhm - if there is an active bloodcube, go for it!
		cube = find(world, classname, "BloodCube");
		while(cube != world)
		{
		    if (cube.delay == 1)
		 	if (visible(cube))
		 	{
				fireball.movetype = MOVETYPE_FLY;
				fireball.solid = SOLID_BBOX;
				fireball.enemy = cube;
				fireball.think = SeekCube;
				fireball.nextthink = time + 0.2 + random()*1;
				//return;
		 	}
		    cube = find(cube, classname, "BloodCube");
		}
        }
        else
        {
                fireball.movetype = MOVETYPE_TOSS;
                setmodel (fireball, "progs/lavaball.mdl");
        }
        setsize (fireball, '0 0 0', '0 0 0');
        setorigin (fireball, self.origin);
	  if (!(fireball.think))
	  {
        	fireball.nextthink = time + 6;
        	fireball.think = SUB_Remove;
	  }
        if (self.spawnflags & GIB_FOUNTAIN)
                fireball.touch = gib_touch;
        else
                fireball.touch = fire_touch;

        self.nextthink = time + (random() * 5) + 3;
        self.think = fire_fly;
};


void() fire_touch =
{
        T_Damage (other, self, self, 20);
        remove(self);
};

void() gib_touch =
{
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
		self.solid = SOLID_NOT;
		self.touch = SUB_Null;
		self.think = SUB_Remove;
		self.nextthink = time + (6 * random()) + 2;
		return;
	}

	if (self.attack_finished < time)

	if (!(self.delay == 1))
	 if (pointcontents(self.origin) > -3)
	 {
		sound (self, CHAN_AUTO, "gibfnt/gf_plop.wav", 1, ATTN_NORM);   //bounce sound
		self.attack_finished = time + 0.3;
	 }
};

//=END GIB FOUNTAIN=======================================================

//=START PARTICLE-STREAM==================================================

void() particle_use =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	Particle_Beam(self.origin, self.enemy.origin, self.dmg, self.cnt, 40);
};

void() particle_stream_start =
{
local entity	pspot;

	pspot = find(world, targetname, self.target);
	if(!pspot)
	{
		dprint("Particle stream can't find target!");
		return;
	}

	self.enemy = pspot;
};

/*QUAKED misc_particle_stream (0 .5 .8) (-8 -8 -8) (8 8 8)
A particle stream!  It appears when triggered.  This entity is 
one end of the stream, target another entity as the other end-point.
I used the info_notnull, but you should be able to target anything 
(like monsters).

"target"   This entities origin is the end-point of the stream
"dmg"  1st Color  -  Use if you want a single color stream
"cnt"  2nd Color  -  Mixes particles of both colors
"noise"  Sound to play when triggered
*/
void() misc_particle_stream =
{
	if(!self.target)
		objerror("misc_particle_stream with not target!");

	if(!self.dmg)
		self.dmg = 73;
	if(!self.cnt)
		self.cnt = self.dmg;
	if(!self.noise)
		self.noise = "misc/null.wav";

      precache_sound(self.noise);

	self.use = particle_use;
	self.think = particle_stream_start;
	self.nextthink = time + 0.2;
};

//============================================================================


void() barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	// did say self.owner
	T_RadiusDamage (self, self, 160, world, "");
	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_EXPLOSION);
	WriteCoord (MSG_MULTICAST, self.origin_x);
	WriteCoord (MSG_MULTICAST, self.origin_y);
	WriteCoord (MSG_MULTICAST, self.origin_z+32);
	multicast (self.origin, MULTICAST_PHS);
	remove (self);
};



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
	setsize (self, '0 0 0', '32 32 64');
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
	setsize (self, '0 0 0', '32 32 32');
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

void() Laser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, 15);
		other.deathtype = "laser";
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
		WriteByte (MSG_MULTICAST, TE_GUNSHOT);
		WriteByte (MSG_MULTICAST, 5);
		WriteCoord (MSG_MULTICAST, org_x);
		WriteCoord (MSG_MULTICAST, org_y);
		WriteCoord (MSG_MULTICAST, org_z);
		multicast (org, MULTICAST_PVS);
	}
	
	remove(self);	
};

void(vector org, vector vec) LaunchLaser =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};

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
	remove (self);
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
};

/*QUAKED ambient_drone (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drone =
{
	precache_sound ("ambience/drone6.wav");
	ambientsound (self.origin, "ambience/drone6.wav", 0.5, ATTN_STATIC);
};

/*QUAKED ambient_flouro_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_flouro_buzz =
{
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_drip (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_drip =
{
	precache_sound ("ambience/drip1.wav");
	ambientsound (self.origin, "ambience/drip1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_comp_hum (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_comp_hum =
{
	precache_sound ("ambience/comp1.wav");
	ambientsound (self.origin, "ambience/comp1.wav", 1, ATTN_STATIC);
};
/*QUAKED ambient_light_buzz (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_light_buzz =
{
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp1 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp1 =
{
	precache_sound ("ambience/swamp1.wav");
	ambientsound (self.origin, "ambience/swamp1.wav", 0.5, ATTN_STATIC);
};
/*QUAKED ambient_swamp2 (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_swamp2 =
{
	precache_sound ("ambience/swamp2.wav");
	ambientsound (self.origin, "ambience/swamp2.wav", 0.5, ATTN_STATIC);
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


void() rain_touch = 
{
	// remove rain when it hits ground or any other object
	remove(self);
};

void() rain_think =
{
	local float temp1,temp2;
	local vector rain_org, rain_vel;
	local entity drop;

	rain_org = self.origin;
	temp1 = random();
		temp2 = random();

		// random direction from func_rain origin
		if (temp1 < 0.5)
			rain_org_x = rain_org_x - 32*random();
		else
			rain_org_x = rain_org_x + 32*random();
		if (temp2 < 0.5)
			rain_org_y = rain_org_y - 32*random();
		else
			rain_org_y = rain_org_y + 32*random();

		drop = spawn();
		setorigin (drop, rain_org);

		if (self.count)
			setmodel (drop, "progs/gl_rain.spr");
		else
			setmodel (drop, "progs/s_rain.spr");

		drop.classname = "raindrop";
		drop.movetype = MOVETYPE_TOSS;
		drop.solid = SOLID_BBOX;
		setsize (drop, '0 0 0', '0 0 0');
		rain_vel = '0 0 0';
		rain_vel_z = -20*random();
		drop.touch = rain_touch;

	self.nextthink = time + 0.5;
	self.think = rain_think;
};

/*QUAKED func_rain
ambient rain effect
*/
void() func_rain =
{
	if (cvar("gl_cull") == 1)
	{
		precache_model ("progs/gl_rain.spr");
		self.count = 1;
	}
	else
		precache_model ("progs/s_rain.spr");

	self.think = rain_think;
	self.nextthink = time  + random();
};

/*QUAKED ambient_rain (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
Use this for the rain sound
*/
void() ambient_rain =
{

	precache_sound("ambience/rain.wav");
	ambientsound (self.origin, "ambience/rain.wav", 1, ATTN_STATIC);
};

void() thunder_go_boom =
{
	if (random() < 0.5)
		sound (self, CHAN_AUTO, "ambience/thunder1.wav", 0.5, ATTN_NONE);
	else
		sound (self, CHAN_AUTO, "ambience/thunder2.wav", 0.5, ATTN_NONE);

	self.think = thunder_go_boom;
	self.nextthink = time + 40*random();
};

/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	//  changed from ambient to delayed sound (sounds better)
	precache_sound ("ambience/thunder1.wav");
	precache_sound ("ambience/thunder2.wav");
	self.think = thunder_go_boom;
	self.nextthink = time + random();
};

/****************************************/
/* ------------------------------ */
/* |	   trigger_gravity	  | */
/* ------------------------------ */
/*QUAKED trigger_gravity (.5 .5 .5) (-8 -8 -8) (8 8 32)
This will change the gravity for objects that are inside it.
Put the value to change gravity to in the "gravity" field.
Ziggurat Vertigo used '100' for its low gravity.
*/
void() gravity_use =
{
	if (self.cnt == -1)
	{
		dprint("Anti-gravity machine turned ON\n");
		self.cnt = 0;
	}
	else
	{
		dprint("Anti-gravity machine turned OFF\n");
		self.cnt = -1;
	}
};

void() gravity_touch =
{
	if(self.cnt == -1)
		return;
	if(other.deadflag < 2)
	if(other.velocity_z != 0)
	if(other.movetype != MOVETYPE_FLYMISSILE)
	if(other.classname != "BloodCube")
		other.velocity_z = other.velocity_z + (self.delay * frametime);
};

void() trigger_gravity = 
{
local float	worldGravity;

	InitTrigger ();
	worldGravity = cvar("sv_gravity");
	self.delay = worldGravity - self.gravity;
	self.touch = gravity_touch;

	if(self.targetname)
	{
		self.cnt = -1;
		self.use = gravity_use;
	}
};


/* ------------------------------ */
/* |	   trigger_quake		  | */
/* ------------------------------ */
/*QUAKED trigger_quake (.5 .5 .5) (-8 -8 -8) (8 8 32)
Starts an earthquake.  Players view will shake for amount of time you
put in "wait".  Place the richter scale of the quake in the "dmg" field.
It will also trigger all targets like a 'trigger_once'.
*/
void() q_trig =
{
	SUB_UseTargets();
	//remove(self);
};

void() trigger_quake =
{
	self.think = q_trig;
	self.nextthink = time + 0.5;
};
