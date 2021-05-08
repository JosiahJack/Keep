
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

void() info_target = {};

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

//NEW LIGHT


void() light_fluoropost_dead
{
	local entity deadlight;
	local float oldz;
	
	
	
	precache_model ("progs/lightp.mdl");
	deadlight = spawn();
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
	setmodel (deadlight, "progs/lightp.mdl");
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	setsize(deadlight, '-8 -8  -10', '8 8 43');
	deadlight.solid = SOLID_BBOX;
	deadlight.movetype = MOVETYPE_NONE;
	
	
	
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
}

void() light_break =
{
local vector center;
	self.takedamage = DAMAGE_NO;
	self.classname = "light_destruct";
	// did say self.owner
	sound7 (self, CHAN_VOICE, "misc/lightbrk.wav", 1, ATTN_NORM, SNDSPD);
	center = (self.absmin + self.absmax) * 0.5;		// added to bring the explosion to the center of the explo_box model
	//particle (center, '0 0 0', 75, 255);			// edited to bring the explosion to the center of the explo_box model
	// particle (self.origin, '0 0 0', 75, 255);		// was original code (that made the explosion appear on lower corner of model)
	setorigin(self, (self.absmin + self.absmax) * 0.5);
	T_RadiusDamage (self, self, 5, world);
	//remove(self);
	BecomeExplosion ();
	pointparticles(particleeffectnum("secret"), center, '0 0 0', 1);
};

void() light_det =
{
	light_fluoropost_dead();
	lightstyle(self.style, "b");
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
	self.think = light_break;
	self.nextthink = time;
	
};


void() light_fluoropost =
{
	local float	oldz;
	local vector center;
	local entity plight;
	
	center = (self.absmin + self.absmax) * 0.5;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("progs/lightp.mdl");
	setmodel (self, "progs/lightp.mdl");
	setsize(self, '-8 -8  -10', '8 8 43');
	precache_sound ("misc/lightbrk.wav");
	self.health = 20;
	self.th_die = light_det;
	self.takedamage = DAMAGE_YES;
	
	if (self.health == 20)
	{
		lightstyle(self.style, "m");
		precache_sound ("ambience/fl_hum1.wav");
		ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
	}

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};


//END LIGHT

//Ceiling Light

void() light_ceil_dead
{
	local entity deadlight;
	local float oldz;
	
	precache_model ("progs/lightceil.mdl");
	deadlight = spawn();
	setmodel (deadlight, "progs/lightceil.mdl");
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	deadlight.solid = SOLID_BBOX;
	setsize(deadlight, '-8 -8 -8', '8 8 8');
	deadlight.movetype = MOVETYPE_NONE;
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
	
	
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
}

void() light_cdet =
{
	light_ceil_dead();
	lightstyle(self.style, "b");
	remove(self.owner);
	self.think = light_break;
	self.nextthink = time;
	
}

void() light_ceil =
{
	local float	oldz;
	local vector center;
	local entity plight, lightray;
	
	center = (self.absmin + self.absmax) * 0.5;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	
	precache_model ("progs/lightceil.mdl");
	precache_model ("progs/p_lightbeams.mdl");
	
	setmodel (self, "progs/lightceil.mdl");
	precache_sound ("misc/lightbrk.wav");
	precache_sound ("misc/siren.wav");
	
	
	lightray = spawn();
	setorigin(lightray, self.origin);
	lightray.solid = SOLID_NOT;
	setmodel(lightray, "progs/p_lightbeams.mdl");
	lightray.movetype = MOVETYPE_FLY;
	lightray.alpha = 0.6;
	lightray.effects = EF_FULLBRIGHT;
	lightray.avelocity = '0 300 0';
	
	self.owner = lightray;
	
	self.health = 20;
	self.th_die = light_cdet;
	self.takedamage = DAMAGE_YES;
	
	if (self.health == 20)
	{
		lightstyle(self.style, "m");
		ambientsound (self.origin, "misc/siren.wav", 0.5, ATTN_STATIC);
	}

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};


//END LIGHT

//New Ceiling fixture


void() light_fix_dead
{
	local entity deadlight;
	local float oldz;
	
	deadlight = spawn();
	if (self.skin == 0)
	{
		precache_model ("progs/lightfix.mdl");
		setmodel (deadlight, "progs/lightfix.mdl");
	}
	else
	{
		precache_model ("progs/lightfixAlt.mdl");
		setmodel (deadlight, "progs/lightfixAlt.mdl");
	}
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	setsize(deadlight, VEC_HULL2_MIN, VEC_HULL2_MAX);
	deadlight.solid = SOLID_BBOX;
	deadlight.movetype = MOVETYPE_NONE;
	
	
	
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
}

void() light_fdet =
{
	light_fix_dead();
	lightstyle(self.style, "b");
	self.think = light_break;
	self.nextthink = time;
	
}

void() light_fix =
{
	local float	oldz;
	local vector center;
	local entity plight;
	
	center = (self.absmin + self.absmax) * 0.5;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	if (self.skin == 0)
	{
		precache_model ("progs/lightfix.mdl");
		setmodel (self, "progs/lightfix.mdl");
	}
	else
	{
		precache_model ("progs/lightfixAlt.mdl");
		setmodel (self, "progs/lightfixAlt.mdl");
	}
	precache_sound ("misc/lightbrk.wav");
	self.health = 20;
	self.th_die = light_fdet;
	self.takedamage = DAMAGE_YES;
	
	if (self.health == 20)
	{
		lightstyle(self.style, "m");
		precache_sound ("ambience/fl_hum1.wav");
		ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
	}

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};


//END LIGHT

//END MONITOR

void() FireAmbient =
{
	precache_sound ("ambience/fire1.wav");
	// attenuate fast
	ambientsound (self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};


void() spriteflameloop =		// for ALL sprite flames
{
pointparticles(particleeffectnum("spriteflame"), self.origin, '0 0 0', 1);
	self.nextthink = time + 0.1;
};


void() particleflamelooptorch =	// for particle flames (ONLY torch flame)
{
//pointparticles(particleeffectnum("particleflamesmall"), self.origin, '0 0 0', 1);
	//sendParticle("particleflamesmall", self.origin, '0 0 0', 1);
	//self.traileffectnum = particleeffectnum("particleflamesmall");
	//self.nextthink = time + 0.02;  
};

void() particleflameloop =		// for particle flames (ALL flames, except torch flame)
{
//pointparticles(particleeffectnum("particleflamebig"), self.origin, '0 0 0', 1);
	sendParticle("particleflamebig", self.origin, '0 0 0', 1);
	self.nextthink = time + 0.02;  
};

void() particleflameloop_start_map =	// for particle flames (ALL flames, except torch flame; BUT ONLY FOR START MAP)
{
//pointparticles(particleeffectnum("particleflamebig_startmap"), self.origin, '0 0 0', 1);
	sendParticle("particleflamebig_startmap", self.origin, '0 0 0', 1);
	self.nextthink = time + 0.02;  
};


void() flamespawn =     //  for sprite flames (for ALL flames EXCEPT torches )
{
	newmis = spawn();
	setorigin(newmis, self.origin + self.dest + '0 0 -5');
	setmodel(newmis, "progs/torchflamebase.spr32");
	newmis.effects = EF_ADDITIVE;
	newmis.scale = self.scale;

	newmis = spawn();
	setorigin(newmis, self.origin + self.dest);
	setmodel(newmis, "progs/torchflametop.spr32");
	newmis.scale = self.scale;
	newmis.think = spriteflameloop;
	newmis.nextthink = time + 0.1;
};

void() flamespawntorch =     //  for sprite flames (only for torches. Reason: repositioning of base sprite)
{
	newmis = spawn();
	setorigin(newmis, self.origin + self.dest + '0 0 -3.5'); // was: '0 0 -5' // with 25% higher base flame sprite: '0 0 -3.5'
	setmodel(newmis, "progs/torchflamebase25higher.spr32");  
	newmis.effects = EF_ADDITIVE;
	newmis.scale = self.scale;

	newmis = spawn();
	setorigin(newmis, self.origin + self.dest);
	setmodel(newmis, "progs/torchflametop.spr32");   
	newmis.scale = self.scale;
	newmis.think = spriteflameloop;
	newmis.nextthink = time + 0.1;
};


void() flamespawnparticle =     //  for particle flames (for ALL flames EXCEPT torches )
{
	//newmis = spawn();
	//setorigin(newmis, self.origin + self.dest);
	//newmis.scale = self.scale;
	if (world.model == "maps/start.bsp")
	{
		//newmis.think = particleflameloop_start_map;   // ONLY FOR START MAP !!
		//newmis.nextthink = time + 0.1;
		sendParticle("particleflamebig_startmap", self.origin + self.dest, '0 0 0', 1, 0.02);
		
	}
	else
	{
		//newmis.think = particleflameloop;   	// for all other maps
		//newmis.nextthink = time + 0.1;
		sendParticle("particleflamebig", self.origin + self.dest, '0 0 0', 1, 0.02);
	}
	self.think = flamespawnparticle;
	self.nextthink = time + 0.03;
};

void() flamespawntorchparticle =     //  for particle flames (only for torches. Reason: repositioning of particles)
{
	//newmis = spawn();
	//setorigin(newmis, self.origin + self.dest + '0 0 -1.5'); 
	//setmodel(newmis, "progs/globe.spr");
	//newmis.scale = 0.1;
	//newmis.alpha = 0.01;
	sendParticle("particleflamesmall", self.origin + self.dest + '0 0 -1.5', '0 0 0', 1, 0.02);
	self.think = flamespawntorchparticle;
	self.nextthink = time + 0.05;
	//newmis.traileffectnum = particleeffectnum("particleflamesmall");
	//newmis.think = particleflamelooptorch;
	//newmis.nextthink = time + 0.1;
};



void() torchflame =		// for sprite flames (except torches)
{
	FireAmbient();
	precache_model ("progs/torchflametop.spr32");
	precache_model ("progs/torchflamebase.spr32");
	self.think = flamespawn;
	self.nextthink = time + 0.1;
};

void() torchflametorch = 	//  for sprite flames  (only torches. Reason: repositioning of base sprite)
{
	FireAmbient();
	precache_model ("progs/torchflametop.spr32");
	precache_model ("progs/torchflamebase25higher.spr32");
	self.think = flamespawntorch;
	self.nextthink = time + 0.1;
};


void() torchflameparticle =	// for particle flames (except torches)
{
	FireAmbient();
	self.think = flamespawnparticle;
	self.nextthink = time + 0.1;
};

void() torchflametorchparticle = 	//  for particle flames  (only torches. Reason: repositioning of particle)
{
	FireAmbient();
	self.think = flamespawntorchparticle;
	self.nextthink = time + 0.1;
};


/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
Short wall torch
Default light value is 200
Default style is 0
*/
void() light_torch_small_walltorch =
{
	var float autocvar_flamestyle = 2;    			// set cvar 'flamestyle' default to 2
	var float autocvar_torch_tilted = 1;			// set cvar 'torch_tilted' default to 1
	var float autocvar_torch_tilted_angle = 20;		// set cvar 'torch_tilted_angle' default to 20
	var float autocvar_torch_tilted_walldistance = 9;	// set cvar 'torch_tilted_walldistance' default to 9
	var float autocvar_torch_tilted_newmodel = 1;		// set cvar 'torch_tilted_newmodel' default to 1

	if (autocvar_flamestyle == 0)			// if 'flamestyle' is set via autoexec.cfg to '0' use ID1 poly flames
	{
		FireAmbient ();
		precache_model ("progs/flame_withtop.mdl");
		setmodel (self, "progs/flame_withtop.mdl");
		makestatic (self);
	}		
	else if (autocvar_flamestyle == 2)		// if 'flamestyle' is set via autoexec.cfg to '2' use particle flames
	{
		self.dest = '0 0 16';
		if (autocvar_torch_tilted)		// if 'torch_tilted' is enabled, autodetect the correct angle and distance towards nearest wall and tilt torch accordingly
		{
			self.angles_x = autocvar_torch_tilted_angle;	// tilt the torch that much ...

			if (autocvar_torch_tilted_newmodel == 1)	// if 'torch_tilted_newmodel' is set to "1", use model: flame_notop_torch1.mdl
			{
				precache_model ("progs/flame_notop_torch1.mdl"); 
				setmodel (self, "progs/flame_notop_torch1.mdl"); 
			}
			else if (autocvar_torch_tilted_newmodel == 2)	// if 'torch_tilted_newmodel' is set to "2", use model:  flame_notop_torch2.mdl 
			{
				precache_model ("progs/flame_notop_torch2.mdl"); 
				setmodel (self, "progs/flame_notop_torch2.mdl"); 
			}
			else if (autocvar_torch_tilted_newmodel == 3)	// if 'torch_tilted_newmodel' is set to "3", use model:  flame_notop_torch3.mdl (this one is NOT included in SMC due to copyright/legal reasons)
			{
				precache_model ("progs/flame_notop_torch3.mdl"); 
				setmodel (self, "progs/flame_notop_torch3.mdl");  
			}
			else if (autocvar_torch_tilted_newmodel == 4)	// if 'torch_tilted_newmodel' is set to "4", use model:  flame_notop_torch4.mdl (this one is NOT included in SMC due to copyright/legal reasons)
			{
				precache_model ("progs/flame_notop_torch4.mdl"); 
				setmodel (self, "progs/flame_notop_torch4.mdl");  
			}
			else if (autocvar_torch_tilted_newmodel == 5)	// if 'torch_tilted_newmodel' is set to "5", use model:  flame_notop_torch5.mdl (this one is NOT included in SMC due to copyright/legal reasons)
			{
				precache_model ("progs/flame_notop_torch5.mdl"); 
				setmodel (self, "progs/flame_notop_torch5.mdl");  
			}
			else 						// if 'torch_tilted_newmodel' is set to "0", use standard model:  flame_notop_torch0.mdl
			{
				precache_model ("progs/flame_notop_torch0.mdl"); 
				setmodel (self, "progs/flame_notop_torch0.mdl"); 
			}

			// Detect distance towards walls around the torch (do this every 15°. This should be enough accurate)   // x = cos a * Hypo   Hypo is always 15    // y = sin a * Hypo   Hypo is always 15
				traceline(self.origin, self.origin + '15 0 0' ,FALSE, self);		// 0°
				self.vlen1 = vlen (trace_endpos - self.origin);
				self.trace_endpos1 = trace_endpos;
				traceline(self.origin, self.origin + '14.5 3.9 0' ,FALSE, self);
				self.vlen2 = vlen (trace_endpos - self.origin);
				self.trace_endpos2 = trace_endpos;
				traceline(self.origin, self.origin + '13 7.5 0' ,FALSE, self);
				self.vlen3 = vlen (trace_endpos - self.origin);
				self.trace_endpos3 = trace_endpos;
				traceline(self.origin, self.origin + '10.6 10.6 0' ,FALSE, self);
				self.vlen4 = vlen (trace_endpos - self.origin);
				self.trace_endpos4 = trace_endpos;
				traceline(self.origin, self.origin + '7.5 13 0' ,FALSE, self);
				self.vlen5 = vlen (trace_endpos - self.origin);
				self.trace_endpos5 = trace_endpos;
				traceline(self.origin, self.origin + '3.9 14.5 0' ,FALSE, self);
				self.vlen6 = vlen (trace_endpos - self.origin);
				self.trace_endpos6 = trace_endpos;

				traceline(self.origin, self.origin + '0 15 0' ,FALSE, self);		// 90°
				self.vlen7 = vlen (trace_endpos - self.origin);
				self.trace_endpos7 = trace_endpos;
				traceline(self.origin, self.origin + '-3.9 14.5 0' ,FALSE, self);
				self.vlen8 = vlen (trace_endpos - self.origin);
				self.trace_endpos8 = trace_endpos;
				traceline(self.origin, self.origin + '-7.5 13 0' ,FALSE, self);
				self.vlen9 = vlen (trace_endpos - self.origin);
				self.trace_endpos9 = trace_endpos;
				traceline(self.origin, self.origin + '-10.6 10.6 0' ,FALSE, self);
				self.vlen10 = vlen (trace_endpos - self.origin);
				self.trace_endpos10 = trace_endpos;
				traceline(self.origin, self.origin + '-13 7.5 0' ,FALSE, self);
				self.vlen11 = vlen (trace_endpos - self.origin);
				self.trace_endpos11 = trace_endpos;
				traceline(self.origin, self.origin + '-14.5 3.9 0' ,FALSE, self);
				self.vlen12 = vlen (trace_endpos - self.origin);
				self.trace_endpos12 = trace_endpos;

				traceline(self.origin, self.origin + '-15 0 0' ,FALSE, self);		// 180°
				self.vlen13 = vlen (trace_endpos - self.origin);
				self.trace_endpos13 = trace_endpos;
				traceline(self.origin, self.origin + '-14.5 -3.9 0' ,FALSE, self);
				self.vlen14 = vlen (trace_endpos - self.origin);
				self.trace_endpos14 = trace_endpos;
				traceline(self.origin, self.origin + '-13 -7.5 0' ,FALSE, self);
				self.vlen15 = vlen (trace_endpos - self.origin);
				self.trace_endpos15 = trace_endpos;
				traceline(self.origin, self.origin + '-10.6 -10.6 0' ,FALSE, self);
				self.vlen16 = vlen (trace_endpos - self.origin);
				self.trace_endpos16 = trace_endpos;
				traceline(self.origin, self.origin + '-7.5 -13 0' ,FALSE, self);
				self.vlen17 = vlen (trace_endpos - self.origin);
				self.trace_endpos17 = trace_endpos;
				traceline(self.origin, self.origin + '-3.9 -14.5 0' ,FALSE, self);
				self.vlen18 = vlen (trace_endpos - self.origin);
				self.trace_endpos18 = trace_endpos;

				traceline(self.origin, self.origin + '0 -15 0' ,FALSE, self);		// 270°
				self.vlen19 = vlen (trace_endpos - self.origin);
				self.trace_endpos19 = trace_endpos;
				traceline(self.origin, self.origin + '3.9 -14.5 0' ,FALSE, self);
				self.vlen20 = vlen (trace_endpos - self.origin);
				self.trace_endpos20 = trace_endpos;
				traceline(self.origin, self.origin + '7.5 -13 0' ,FALSE, self);
				self.vlen21 = vlen (trace_endpos - self.origin);
				self.trace_endpos21 = trace_endpos;
				traceline(self.origin, self.origin + '10.6 -10.6 0' ,FALSE, self);
				self.vlen22 = vlen (trace_endpos - self.origin);
				self.trace_endpos22 = trace_endpos;
				traceline(self.origin, self.origin + '13 -7.5 0' ,FALSE, self);
				self.vlen23 = vlen (trace_endpos - self.origin);
				self.trace_endpos23 = trace_endpos;
				traceline(self.origin, self.origin + '14.5 -3.9 0' ,FALSE, self);
				self.vlen24 = vlen (trace_endpos - self.origin);
				self.trace_endpos24 = trace_endpos;


			// Now find shortest distance towards walls around the torch and name it:  self.vlenmin
				self.vlenmin = self.vlen1;		// start with something
				if (self.vlen2 < self.vlenmin)
					self.vlenmin = self.vlen2;
				if (self.vlen3 < self.vlenmin)
					self.vlenmin = self.vlen3;
				if (self.vlen4 < self.vlenmin)
					self.vlenmin = self.vlen4;
				if (self.vlen5 < self.vlenmin)
					self.vlenmin = self.vlen5;
				if (self.vlen6 < self.vlenmin)
					self.vlenmin = self.vlen6;
				if (self.vlen7 < self.vlenmin)
					self.vlenmin = self.vlen7;
				if (self.vlen8 < self.vlenmin)
					self.vlenmin = self.vlen8;
				if (self.vlen9 < self.vlenmin)
					self.vlenmin = self.vlen9;
				if (self.vlen10 < self.vlenmin)
					self.vlenmin = self.vlen10;
				if (self.vlen11 < self.vlenmin)
					self.vlenmin = self.vlen11;
				if (self.vlen12 < self.vlenmin)
					self.vlenmin = self.vlen12;
				if (self.vlen13 < self.vlenmin)
					self.vlenmin = self.vlen13;
				if (self.vlen14 < self.vlenmin)
					self.vlenmin = self.vlen14;
				if (self.vlen15 < self.vlenmin)
					self.vlenmin = self.vlen15;
				if (self.vlen16 < self.vlenmin)
					self.vlenmin = self.vlen16;
				if (self.vlen17 < self.vlenmin)
					self.vlenmin = self.vlen17;
				if (self.vlen18 < self.vlenmin)
					self.vlenmin = self.vlen18;
				if (self.vlen19 < self.vlenmin)
					self.vlenmin = self.vlen19;
				if (self.vlen20 < self.vlenmin)
					self.vlenmin = self.vlen20;
				if (self.vlen21 < self.vlenmin)
					self.vlenmin = self.vlen21;
				if (self.vlen22 < self.vlenmin)
					self.vlenmin = self.vlen22;
				if (self.vlen23 < self.vlenmin)
					self.vlenmin = self.vlen23;
				if (self.vlen24 < self.vlenmin)
					self.vlenmin = self.vlen24;


			// Now spin the torch into the correct angle (away from the closest wall) and also correct the distance to a specific value (mapper are lazy and always use a different torch pos :P )
				if (self.vlenmin == self.vlen1)
				{
					self.angles_y = 0;
					self.origin_x = self.trace_endpos1_x + (-1 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos1_y;
					self.origin_z = self.trace_endpos1_z;
				}	
				if (self.vlenmin == self.vlen2)
				{
					self.angles_y = 15;
					self.origin_x = self.trace_endpos2_x + (-0.966 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos2_y + (-0.259 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos2_z;
				}	
				if (self.vlenmin == self.vlen3)
				{
					self.angles_y = 30;
					self.origin_x = self.trace_endpos3_x + (-0.866 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos3_y + (-0.5 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos3_z;
				}	
				if (self.vlenmin == self.vlen4)
				{
					self.angles_y = 45;
					self.origin_x = self.trace_endpos4_x + (-0.707 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos4_y + (-0.707 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos4_z;
				}	
				if (self.vlenmin == self.vlen5)
				{
					self.angles_y = 60;
					self.origin_x = self.trace_endpos5_x + (-0.5 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos5_y + (-0.866 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos5_z;
				}	
				if (self.vlenmin == self.vlen6)
				{
					self.angles_y = 75;
					self.origin_x = self.trace_endpos6_x + (-0.259 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos6_y + (-0.966 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos6_z;
				}	
				if (self.vlenmin == self.vlen7)
				{
					self.angles_y = 90;
					self.origin_x = self.trace_endpos7_x;
					self.origin_y = self.trace_endpos7_y + (-1 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos7_z;
				}	
				if (self.vlenmin == self.vlen8)
				{
					self.angles_y = 105;
					self.origin_x = self.trace_endpos8_x + (0.259 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos8_y + (-0.966 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos8_z;
				}	
				if (self.vlenmin == self.vlen9)
				{
					self.angles_y = 120;
					self.origin_x = self.trace_endpos9_x + (0.5 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos9_y + (-0.866 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos9_z;
				}	
				if (self.vlenmin == self.vlen10)
				{
					self.angles_y = 135;
					self.origin_x = self.trace_endpos10_x + (0.707 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos10_y + (-0.707 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos10_z;
				}	
				if (self.vlenmin == self.vlen11)
				{
					self.angles_y = 150;
					self.origin_x = self.trace_endpos11_x + (0.866 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos11_y + (-0.5 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos11_z;
				}	
				if (self.vlenmin == self.vlen12)
				{
					self.angles_y = 165;
					self.origin_x = self.trace_endpos12_x + (0.966 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos12_y + (-0.259 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos12_z;
				}	
				if (self.vlenmin == self.vlen13)
				{
					self.angles_y = 180;
					self.origin_x = self.trace_endpos13_x + (1 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos13_y;
					self.origin_z = self.trace_endpos13_z;
				}	
				if (self.vlenmin == self.vlen14)
				{
					self.angles_y = 195;
					self.origin_x = self.trace_endpos14_x + (0.966 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos14_y + (0.259 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos14_z;
				}	
				if (self.vlenmin == self.vlen15)
				{
					self.angles_y = 210;
					self.origin_x = self.trace_endpos15_x + (0.866 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos15_y + (0.5 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos15_z;
				}	
				if (self.vlenmin == self.vlen16)
				{
					self.angles_y = 225;
					self.origin_x = self.trace_endpos16_x + (0.707 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos16_y + (0.707 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos16_z;
				}	
				if (self.vlenmin == self.vlen17)
				{
					self.angles_y = 240;
					self.origin_x = self.trace_endpos17_x + (0.5 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos17_y + (0.866 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos17_z;
				}	
				if (self.vlenmin == self.vlen18)
				{
					self.angles_y = 255;
					self.origin_x = self.trace_endpos18_x + (0.256 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos18_y + (0.966 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos18_z;
				}	
				if (self.vlenmin == self.vlen19)
				{
					self.angles_y = 270;
					self.origin_x = self.trace_endpos19_x;
					self.origin_y = self.trace_endpos19_y + (1 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos19_z;
				}	
				if (self.vlenmin == self.vlen20)
				{
					self.angles_y = 285;
					self.origin_x = self.trace_endpos20_x + (-0.259 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos20_y + (0.966 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos20_z;
				}	
				if (self.vlenmin == self.vlen21)
				{
					self.angles_y = 300;
					self.origin_x = self.trace_endpos21_x + (-0.5 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos21_y + (0.866 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos21_z;
				}	
				if (self.vlenmin == self.vlen22)
				{
					self.angles_y = 315;
					self.origin_x = self.trace_endpos22_x + (-0.707 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos22_y + (0.707 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos22_z;
				}	
				if (self.vlenmin == self.vlen23)
				{
					self.angles_y = 330;
					self.origin_x = self.trace_endpos23_x + (-0.866 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos23_y + (0.5 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos23_z;
				}	
				if (self.vlenmin == self.vlen24)
				{
					self.angles_y = 345;
					self.origin_x = self.trace_endpos24_x + (-0.966 * autocvar_torch_tilted_walldistance);
					self.origin_y = self.trace_endpos24_y + (0.259 * autocvar_torch_tilted_walldistance);
					self.origin_z = self.trace_endpos24_z;
				}	
		
		}
		else
		{
			if (autocvar_torch_tilted_newmodel == 1)	// if 'torch_tilted_newmodel' is set to "1", use model: flame_notop_torch1.mdl
			{
				precache_model ("progs/flame_notop_torch1.mdl"); 
				setmodel (self, "progs/flame_notop_torch1.mdl"); 
			}
			else 						// if 'torch_tilted_newmodel' is set to "0", use standard model:  flame_notop.mdl
			{
				precache_model ("progs/flame_notop_torch0.mdl"); 
				setmodel (self, "progs/flame_notop_torch0.mdl"); 
			}
		}
		//torchflametorchparticle();
		self.traileffectnum = particleeffectnum("particleflamesmall"); 
	}
	else 						// if 'flamestyle' is set to '1' use sprite flames
	{
		self.dest = '0 0 15.75';   		//  was 0 0 16
		precache_model ("progs/flame_notop_torch0.mdl"); 
		setmodel (self, "progs/flame_notop_torch0.mdl"); 
		torchflametorch();
	}
};


/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame ball
*/
void() light_flame_large_yellow =
{
	var float autocvar_flamestyle = 2;    	// set cvar 'flamestyle' default to 2
	if (autocvar_flamestyle == 0)			// if 'flamestyle' is set via autoexec.cfg to '0' use ID1 poly flames
		{
		precache_model ("progs/flame2.mdl");
		setmodel (self, "progs/flame2.mdl");
		self.frame = 1;
		FireAmbient ();
		makestatic (self);
		}		
	else if (autocvar_flamestyle == 2)		// if 'flamestyle' is set via autoexec.cfg to '2' use particle flames
		{
		self.dest = '0 0 5';
		torchflameparticle();
		}
	else 							// if 'flamestyle' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1' use sprite flames
		{
		self.scale = 1.8;	// was 2  
		self.dest = '0 0 10';		// was '0 0 16'  
		torchflame();
		}
};


/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame ball
*/
void() light_flame_small_yellow =
{
	var float autocvar_flamestyle = 2;    	// set cvar 'flamestyle' default to 2
	if (autocvar_flamestyle == 0)			// if 'flamestyle' is set via autoexec.cfg to '0' use ID1 poly flames
		{
		precache_model ("progs/flame2.mdl");
		setmodel (self, "progs/flame2.mdl");
		FireAmbient ();
		makestatic (self);
		}		
	else if (autocvar_flamestyle == 2)		// if 'flamestyle' is set via autoexec.cfg to '2' use particle flames
		{
		self.dest = '0 0 4';
		torchflameparticle();
		}
	else 							// if 'flamestyle' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1' use sprite flames
		{
		self.dest = '0 0 0';
		torchflame();
		}
};

/*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
Small white flame ball
*/
void() light_flame_small_white =
{
	var float autocvar_flamestyle = 2;    	// set cvar 'flamestyle' default to 2
	if (autocvar_flamestyle == 0)			// if 'flamestyle' is set via autoexec.cfg to '0' use ID1 poly flames
		{
		precache_model ("progs/flame2.mdl");
		setmodel (self, "progs/flame2.mdl");
		FireAmbient ();
		makestatic (self);
		}		
	else if (autocvar_flamestyle == 2)		// if 'flamestyle' is set via autoexec.cfg to '2' use particle flames
		{
		self.dest = '0 0 0';
		//torchflameparticle();
		if (world.model == "maps/start.bsp")
			self.traileffectnum = particleeffectnum("particleflamebig_startmap"); 
		else
			self.traileffectnum = particleeffectnum("particleflamebig");
		}
	else 							// if 'flamestyle' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1' use sprite flames
		{
		self.dest = '0 0 0';
		torchflame();
		}
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
	precache_sound ("misc/burn.wav");
	self.classname = "fireball";
	self.nextthink = time + (random() * 5);
	self.think = fire_fly;
	if (!self.speed)
		self.speed = 1000;
};

void() fire_fly =
{
local entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 800';
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
fireball.traileffectnum = particleeffectnum("lavaball_trail");
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	//fireball.nextthink = time + 5;
	//fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	fireball.avelocity = '400 50 80';
	fireball.gravity = 0.8;
	
	
	self.nextthink = time + (random() * 5) + 3;
	self.think = fire_fly;
};


void() fire_touch =
{
	T_Damage (other, self, self, 20);
	pointparticles(particleeffectnum("lavasplashbig"), self.origin, '0 0 0', 1);
	sound (self, CHAN_AUTO, "misc/burn.wav", 1, ATTN_NORM);
	remove(self);
};

//============================================================================


vector(vector m1, vector m2) randompos =
{
	local vector v;
	m2 = m2 - m1;
	v_x = m2_x * random() + m1_x;
	v_y = m2_y * random() + m1_y;
	v_z = m2_z * random() + m1_z;
	return  v;
};


void() barrel_explode =
{
local vector center;
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	
	self.deathtype = "exploding";
	// did say self.owner
	spawn_fire();
	sound7 (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);
	sound7 (self, CHAN_AUTO, "weapons/explodedist.wav", .5, ATTN_NONE, SNDSPD);
	sparklers();
	sparklers();
	sparklers(2);
	sparklers(2);
	center = (self.absmin + self.absmax) * 0.5;	// added to bring the explosion to the center of the explo_box model
	particle (center, '0 0 0', 75, 255);		// edited to bring the explosion to the center of the explo_box model
	// particle (self.origin, '0 0 0', 75, 255);	// was original code (that made the explosion appear on lower corner of model)

if (autocvar_debris == 1)		    // if 'debris' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
{
local vector v, v2;
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris1.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris2.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris3.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris4.mdl");
//v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris5.mdl");
//v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris6.mdl");
//v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 30; Throwdebris (v, v2, "progs/debris7.mdl");
/*v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 30; Throwdebris (v, v2, "progs/debris8.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 30; Throwdebris (v, v2, "progs/debris9.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 30; Throwdebris (v, v2, "progs/debris10.mdl");*/
}
	setorigin(self, (self.absmin + self.absmax) * 0.5);
	T_RadiusDamage (self, self, 160, world);
	sparklers();
	self.classname = "misc_explobox";
	BecomeExplosion ();
//pointparticles(particleeffectnum("rocket_explosion"), center, '0 0 0', 1);
};

void() barrel_explode2 =
{
local vector center;
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";
	self.deathtype = "exploding";
	spawn_fire();
	// did say self.owner
	sound7 (self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);
	sound7 (self, CHAN_AUTO, "weapons/explodedist.wav", .3, ATTN_NONE, SNDSPD);
	sparklers();
	sparklers(2);
	sparklers(2);
	center = (self.absmin + self.absmax) * 0.5;		// added to bring the explosion to the center of the explo_box model
	particle (center, '0 0 0', 75, 255);			// edited to bring the explosion to the center of the explo_box model
	// particle (self.origin, '0 0 0', 75, 255);		// was original code (that made the explosion appear on lower corner of model)

if (autocvar_debris == 1)		    // if 'debris' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
{
local vector v, v2;
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris1.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris2.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris3.mdl");
//v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris4.mdl");
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris5.mdl");
//v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 3; Throwdebris (v, v2, "progs/debris6.mdl");
}
	setorigin(self, (self.absmin + self.absmax) * 0.5);
	T_RadiusDamage (self, self, 160, world);
	sparklers();
	BecomeExplosion ();
//pointparticles(particleeffectnum("rocket_explosion"), center, '0 0 0', 1);
};

void() barrel_damage =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";

	self.nextthink = time + 0.2;
	self.think = barrel_explode;
}

void() barrel_damage2 =
{
	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";

	self.nextthink = time + 0.2;
	self.think = barrel_explode2;
}

void() barrel_det =
{
	
	self.think = barrel_damage;
	self.nextthink = time;
};

void() barrel_det2 =
{
	
	self.think = barrel_damage2;
	self.nextthink = time;
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
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_det;
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
	self.th_die = barrel_det2;
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

void(vector org, vector vec) LaunchLaser2;

void() spikeshooter_use =
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		LaunchLaser2 (self.origin, self.movedir);
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
	if (!self.cnt)
		bubble.cnt = 0;
	else
		bubble.cnt = self.cnt;
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
local float	rnd1, rnd2, rnd3;

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
	sound7 (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM, SNDSPD);
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


// ============================================================================
/*  Rain effect from dpmod
*/


void() regenton =               // Seven: added rain sound
{
if (random()> 0.94)		// recommended: leave this value as it is (for best rain sound)
		sound (self, CHAN_VOICE, "ambience/rain.wav", 1, ATTN_NORM);   //  rain sound    
	else
		return;
};


void() blitzton =    		  // Seven: added thunder sound
{
if (random()> 0.997)		// play with this value to have thunder sound more or less often (smaller value: more often)
		sound (self, CHAN_WEAPON, "ambience/thunderrain.wav", 1, ATTN_NORM);   //  thunder sound
	else
		return;
};


var float autocvar_ent_rain = 1;

void() rain_think =
{
	if (!cvar("cl_particles_rain"))
		return;

	if(autocvar_ent_rain)
	{
		self.nextthink = time + 0.1;
		te_particlerain(self.absmin, self.absmax, self.dest, self.count, self.cnt);
		blitzton();  // Seven:   call for thunder sound
		regenton();  // Seven:   call for rain sound
	}
	else remove(self);

//	te_particlesnow(self.absmin, self.absmax, self.dest * 0.25, self.count, self.cnt);
//	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
//	WriteByte (MSG_BROADCAST, TE_PARTICLERAIN);
//	WriteVec (MSG_BROADCAST, self.absmin);
//	WriteVec (MSG_BROADCAST, self.absmax);
//	WriteVec (MSG_BROADCAST, self.dest);
//	WriteShort (MSG_BROADCAST, self.count);
//	WriteByte (MSG_BROADCAST, self.cnt);
};

/*QUAKED func_rain (0 .5 .8) ?
This is an invisible area like a trigger, which rain falls inside of.

Keys:
"velocity"
 falling direction (should be something like '0 0 -700', use the X and Y velocity for wind)
"cnt"
 sets color of rain (default 12 - white)
"count"
 adjusts rain density, this many particles fall every second, experiment to see the effects (default is based on area size)
*/

void() rain_small_think =
{
	self.nextthink = time + self.pausetime;
	te_particlerain(self.absmin, self.absmax, self.dest, self.count, self.cnt);
	blitzton();  // Seven:   call for thunder sound
	regenton();  // Seven:   call for rain sound
};


void() rain_init =
{
	if (!self.dest)
		self.dest = '0 0 -700';
	if (!self.cnt)
		self.cnt = 2;
	if (!self.count) self.count = 1;
	self.count = self.count * fabs((self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/16384);
	self.count = self.count * autocvar_ent_rain;
	if (self.count < 0.01)
	{
		remove(self);
		return;
	}
	if (self.count < 1) 
	{ 
		if ( self.count < 0.4 ) 
		{
			//self.cnt = self.cnt*self.count*2.5;
			self.pausetime = 0.25;
		}
		else self.pausetime = 0.1/self.count;
		self.count = 1;
		self.think = rain_small_think;
	}
	else self.think = rain_think;
	self.nextthink = time + 0.1;
};


/*
void() func_rain =
{
	self.dest = self.velocity;
	self.velocity = '0 0 0';
	if (!self.dest)
		self.dest = '0 0 -700';
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.model = "";
	if (!self.cnt)
		self.cnt = 12;
	if (!self.count)
		self.count = (self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/8192;
	if (self.count < 1)
	{
		remove(self);
		return;
	}
	// convert from per second to per 0.1 sec,
	self.count = ceil(self.count * 0.1);
	self.think = rain_think;
	self.nextthink = time + 0.5;
};
*/


// ============================================================================
/*  Snow effect from dpmod
*/

var float autocvar_ent_snow = 1;

void() snow_think =
{
	if ( autocvar_ent_snow )
	{
		self.nextthink = time + 0.1;
		te_particlesnow(self.absmin, self.absmax, self.dest, self.count, self.cnt);
	}
	else remove(self);

//	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
//	WriteByte (MSG_BROADCAST, TE_PARTICLESNOW);
//	WriteVec (MSG_BROADCAST, self.absmin);
//	WriteVec (MSG_BROADCAST, self.absmax);
//	WriteVec (MSG_BROADCAST, self.dest);
//	WriteShort (MSG_BROADCAST, self.count);
//	WriteByte (MSG_BROADCAST, self.cnt);
};

/*QUAKED func_snow (0 .5 .8) ?
This is an invisible area like a trigger, which snow falls inside of.

Keys:
"velocity"
 falling direction (should be something like '0 0 -300', use the X and Y velocity for wind)
"cnt"
 sets color of rain (default 12 - white)
"count"
 adjusts snow density, this many particles fall every second, experiment to see the effects (default is based on area size)
*/

void() snow_init =
{
	if (autocvar_ent_snow == 2) 
	{
		autocvar_ent_rain = 0;
		self.think = snow_think;
		self.nextthink = time + 0.1;
	}
	else remove(self);
};


/*
void() func_snow =
{
	self.dest = self.velocity;
	self.velocity = '0 0 0';
	if (!self.dest)
		self.dest = '0 0 -300';
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.model = "";
	if (!self.cnt)
		self.cnt = 12;
	if (!self.count)
		self.count = (self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/8192;
	if (self.count < 1)
	{
		remove(self);
		return;
	}
	// convert from per second to per 0.1 sec,
	self.count = ceil(self.count * 0.1);
	self.think = snow_think;
	self.nextthink = time + 0.5;
};
*/
 
 


/*
void() flash_think =
{
	if (IS_FLASHING == 1)
		self.alpha = 0.8;
	else
		self.alpha = 0.001;
		
	IS_FLASHING = 0;
		
	self.think = flash_think;
	self.nextthink = time + 0.2;


}


void() trigger_stormflash =
{
	setmodel (self,self.model);
	self.solid = SOLID_NOT;
	
	//self.effects = self.effects | EF_NODRAW;
	
	self.think = flash_think;
	self.nextthink = time + 0.02;
}

*/


void() misc_rain = 
{
	precache_model ("progs/null.spr");
	
	setmodel(self,"progs/null.spr");	
	
	if (self.skin == 0)
		self.traileffectnum = particleeffectnum("area_rain");
	else if (self.skin == 1)
		self.traileffectnum = particleeffectnum("area_rain_small");
	else if (self.skin == 2)
		self.traileffectnum = particleeffectnum("area_rain_tiny");
		
	if ((!coop || deathmatch))
	{
		if (self.spawnflags & 2)
			remove(self);
	}
}