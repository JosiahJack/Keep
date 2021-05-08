
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
//	precache_model ("progs/s_torch7.spr");
//	precache_model ("progs/torch.mdl");
//	setmodel (self, "progs/torch.mdl");

/*	newmis = spawn ();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	setmodel (newmis, "progs/s_torch7.spr");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, self.origin + '0 0 10');
	makestatic (newmis);*/

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
//	precache_model ("progs/s_torch6.spr");
//	setmodel (self, "progs/s_torch6.spr");
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
//	precache_model ("progs/s_torch7.spr");
//	setmodel (self, "progs/s_torch7.spr");
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
//	precache_model ("progs/s_torch8.spr");
//	setmodel (self, "progs/s_torch8.spr");
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
	}
      else
	{
              precache_model ("progs/lavaball.mdl");
		  precache_sound ("ambience/fb_fly.wav");
	}

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
              self.speed = 1000;
};

void() fire_use =
{
	if (self.nextthink == 0)
		self.nextthink = time + 0.5;
	else
		remove(self);
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

	  if (!(self.delay == 1))
	    sound (self, CHAN_AUTO, "gibfnt/gf_sbig.wav", 1, ATTN_NORM);
};

void() fire_sound =
{
	sound (self, CHAN_AUTO, "ambience/fb_fly.wav", 1, ATTN_NORM);
	self.nextthink = time + 0.36;
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
		    setmodel (fireball, "progs/gib1.mdl");
		    TossGibs();
		}
            else if (randmn < 0.45)
                setmodel (fireball, "progs/gib1.mdl");
            else if (randmn < 0.85)
                setmodel (fireball, "progs/gib2.mdl");
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
        }
        else
        {
            fireball.movetype = MOVETYPE_TOSS;
            setmodel (fireball, "progs/lavaball.mdl");
		if (self.spawnflags & 4)
		{
			fireball.think = fire_sound;
			fireball.nextthink = time + 0.2;
		}
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

//============================================================================


//-------------------------------------------------------- Code Change -----
//  This fixes a bug in which barrel explosions cancel other explosions.
//  Here, the barrel explosion is delayed for one frame so that other
//  explosions can occur without interference from the barrel.
//--------------------------------------------------------------------------
void() barrel_damage =
{
	T_RadiusDamage (self, self, 160, world);

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

	newmis = spawn ();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.nextthink = time + 0.1;
	newmis.think = barrel_damage;
	newmis.classname = "explo_box";
	setmodel (newmis, "");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, self.origin + '16 16 32');

	remove(self);
};

void() barrel2_explode =
{
	self.takedamage = DAMAGE_NO;

	newmis = spawn ();
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	newmis.nextthink = time + 0.1;
	newmis.think = barrel_damage;
	newmis.classname = "explo_box";
	setmodel (newmis, "");
	setsize (newmis, '0 0 0', '0 0 0');
	setorigin (newmis, self.origin + '16 16 16');

	remove(self);
};

//---------------------------------------------------------------- END -----


/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void() misc_explobox =
{
	local float	oldz;
	local entity new;
	local vector newsize;


	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	if (self.spawnflags & 1)
	{
		precache_model ("progs/explob.mdl");
		setmodel (self, "progs/explob.mdl");
	}
	else
	{
		precache_model ("maps/b_explob.bsp");
		setmodel (self, "maps/b_explob.bsp");
	}
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	setsize (self, '0 0 0', '32 32 64');
	self.classname = "explo_box";

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		print_self ("item", "fell out of level");
		remove(self);
		return;
	}

 	self.touch = monster_touch;
};




/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void() misc_explobox2 =
{
	local float	oldz;
	local entity new;
	local vector newsize;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	if (self.spawnflags & 1)
	{
		precache_model ("progs/exbox2.mdl");
		setmodel (self, "progs/exbox2.mdl");
	}
	else
	{
		precache_model2 ("maps/b_exbox2.bsp");
		setmodel (self, "maps/b_exbox2.bsp");
	}
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel2_explode;
	self.takedamage = DAMAGE_AIM;
	setsize (self, '0 0 0', '32 32 32');
	self.classname = "explo_box";

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		print_self ("item", "fell out of level");
		remove(self);
		return;
	}

	self.touch = monster_touch;
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
		{
			newmis.touch = superspike_touch;
//			setmodel (newmis, "progs/s_spike.mdl");
// PREACH: setting the model without setting size causes lots of problems, so we skip it
		}
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
	{
		bubble_split();
		if (!self.model)
			return;
	}
	if (self.cnt == 20)
	{
		remove(self);
		return;
	}

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
	if (self.spawnflags & 1)
		self.solid = SOLID_NOT;
	else
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
	makestatic (self);
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
/*QUAKED ambient_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
*/
void() ambient_thunder =
{
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
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
void() ambient_lavagurg  =
{
	precache_sound ("ambience/lavagurg.wav");
	ambientsound (self.origin, "ambience/lavagurg.wav", 0.5, ATTN_STATIC);
};
void() ambient_hevifals   =
{
	precache_sound ("ambience/hevifals.wav");
	ambientsound (self.origin, "ambience/hevifals.wav", 0.5, ATTN_STATIC);
};
void() ambient_bublfals   =
{
	precache_sound ("ambience/bublfals.wav");
	ambientsound (self.origin, "ambience/bublfals.wav", 0.5, ATTN_STATIC);
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

void() misc_tree1 =
{
	precache_model ("progs/tree1.mdl");
	setmodel (self, "progs/tree1.mdl");
};

void() misc_tree2 =
{
	precache_model ("progs/tree2.mdl");
	setmodel (self, "progs/tree2.mdl");
};

void() misc_tree3 =
{
	precache_model ("progs/tree3.mdl");
	setmodel (self, "progs/tree3.mdl");
};

void() misc_tree4 =
{
	precache_model ("progs/tree4.mdl");
	setmodel (self, "progs/tree4.mdl");
};
