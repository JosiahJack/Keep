/*
bdw 23/03/04
lights used to be in misc.qc
*/

float START_OFF = 1;

float LIGHT_NOWARN = 2;	//bdw - flag this light so as to not cause a checkattenuation warning

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

/*
===========================================================================
	BDW_CheckAttenuation

	checks for incorrectly saved (*cough* worldcraft *cough*) self.delay
	for lights intended to uses tyrlite's attenuation feature.
	ben - 04/05/03

	update 23/03/04 - although i'm now using worldcraft 3.4 (hammer),
	this is still useful to have.
===========================================================================
*/

void() BDW_CheckAttenuation =
{
	// checks to see that static lights have 1/x^2 falloff,
	// and that dynamic (switchable or styled) have linear falloff
	// tells you if either is not the case.
	// it goes without saying that this only means anything if
	// the map has been lit with tyrlite, or a tyrlite-based light.exe
	
	// btw, this is still all really stupid...
	
	if (gameflags1 & GF1_ID_MAPNAME)
		return;	//don't print stuff with id maps
		
	if (self.spawnflags & LIGHT_NOWARN)
		return;
	
	if (!self.style)
	{
		if (self.delay != 2)
		{
			dprint("static light with incorrect attenuation at: ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
	}
	else		
	{
		if (self.delay)
		{
			dprint("warning! dynamic light with non-linear attenuation at: ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
	}

	if (self.wait != 2)
	{
		if (self.mangle == '0 0 0')	//not a spotlight
		{
			dprint(self.classname);
			dprint(" with wait != 2 at: ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
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
	BDW_CheckAttenuation();

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

//bdw
void() light_local_minlight =
{
	if (self.delay != 4)
	{
		dprint("local minlight with incorrect attenuation at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}

	remove(self);
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
	BDW_CheckAttenuation();

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

	BDW_CheckAttenuation();

	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
};

/*
bdw 22/03/04
light_plasmaball

this is a sort of souped-up light_globe using one of my cool plasma sprites
*/
void() light_plasmaball =
{
	BDW_CheckAttenuation();

	precache_model("sprites/shalrath/s_vore.spr");	//temporary until i get a unique one
	setmodel(self, "sprites/shalrath/s_vore.spr");
	//should be makestatic once i get a framegrouped one done
	//makestatic (self);

	//randomise the starting frame...
	local float f;
	f = random()*6;		
	f = ceil(f);
	f = f - 1;
	self.frame = f;

	self.idleweaponframe = 6;
	self.think = BDW_SpriteGenericLoop;
	self.nextthink = time + 0.05;

	//todo: do an ambient sound here
};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
Sphere globe light.
Default light value is 300
Default style is 0
*/
void() light_globe =
{
	BDW_CheckAttenuation();

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

//
//==================================
//

void() largefire_think =
{
	local float ang;

	ang = self.angles_y;

	ang = ang + 10;
	if (ang > 360)
		ang = ang - 360;

	self.angles_y = ang;
	self.nextthink = time + 0.1;
};

void() largefire_touch =
{
	if (time < self.attack_finished)
		return;

	if (other.takedamage)
	{
		T_Damage (other, self, self, 5);
		self.attack_finished = time + 0.1;
	}
};


void() bdw_misc_largefire =
{
	precache_model ("progs/flamebig.mdl");
	precache_sound ("ambience/fburn_bg.wav");
	
	self.solid = SOLID_TRIGGER;
	self.touch = largefire_touch;
	self.think = largefire_think;
	self.nextthink = time + 0.1;
	
	setmodel (self, "progs/flamebig.mdl");
	setsize(self, '-48 -48 0', '48 48 256');
	
	ambientsound (self.origin, "ambience/fburn_bg.wav", 1, ATTN_STATIC);
};

//==================================

//use if too many static ents...
void() light_candle_nonstatic =
{
	//BDW_CheckAttenuation();	

	self.angles_y = random()*360;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;

	precache_model ("progs/flamecan.mdl");
	setmodel (self, "progs/flamecan.mdl");
	setsize(self, '0 0 0', '0 0 0');
};

void() light_candle =
{
	light_candle_nonstatic();
	makestatic(self);
};

void() light_torch_lantern =
{
	BDW_CheckAttenuation();	

	precache_model ("progs/flameltn.mdl");
	setmodel (self, "progs/flameltn.mdl");

	FireAmbient();
	makestatic(self);
};

void() light_torch_castletorch =
{
	BDW_CheckAttenuation();	

	precache_model ("models/h2misc/cflmtrch.mdl");
	setmodel (self, "models/h2misc/cflmtrch.mdl");

	FireAmbient();
	makestatic(self);
};



/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
Short wall torch
Default light value is 200
Default style is 0
*/
void() light_torch_small_walltorch =
{
	BDW_CheckAttenuation();	

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
	BDW_CheckAttenuation();

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
	BDW_CheckAttenuation();

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
	BDW_CheckAttenuation();

	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};
