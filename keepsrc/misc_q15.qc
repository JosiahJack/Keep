void() light_fluoropost_dead = {
	local entity deadlight;
	local float oldz;
	
	precache_model ("progs/q15/lightp.mdl");
	deadlight = spawn();
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
	setmodel (deadlight, "progs/q15/lightp.mdl");
	deadlight.skin = 1;
	deadlight.origin_z = self.origin_z;
	deadlight.origin_x = self.origin_x;
	deadlight.origin_y = self.origin_y;
	setsize(deadlight, '-8 -8  -10', '8 8 43');
	deadlight.solid = SOLID_BBOX;
	deadlight.movetype = MOVETYPE_NONE;
	
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

void() light_break = {
	local vector center;

	self.takedamage = DAMAGE_NO;
	self.classname = "light_destruct";
	// did say self.owner
	sound (self, CHAN_VOICE, "misc/lightbrk.wav", 1, ATTN_NORM);
	center = (self.absmin + self.absmax) * 0.5;		// added to bring the explosion to the center of the explo_box model
	//particle (center, '0 0 0', 75, 255);			// edited to bring the explosion to the center of the explo_box model
	// particle (self.origin, '0 0 0', 75, 255);		// was original code (that made the explosion appear on lower corner of model)
	setorigin(self, (self.absmin + self.absmax) * 0.5);
	T_RadiusDamage (self, self, 5, world,DAMAGEALL);
	//remove(self);
	BecomeExplosion ();
	pointparticles(particleeffectnum("secret"), center, '0 0 0', 1);
};

void() light_det = {
	light_fluoropost_dead();
	lightstyle(self.style, "b");
	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
	self.think = light_break;
	self.nextthink = time;

	if (other.flags & FL_CLIENT) activator = other;
	SUB_UseTargets();
};

void() light_fluoropost = {
	local float	oldz;
	local vector center;
	
	center = (self.absmin + self.absmax) * 0.5;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("progs/q15/lightp.mdl");
	setmodel (self, "progs/q15/lightp.mdl");
	setsize(self, '-8 -8  -10', '8 8 43');
	precache_sound ("misc/lightbrk.wav");
	self.health = 20;
	self.th_die = light_det;
	self.takedamage = DAMAGE_YES;
	
	if (self.health == 20) {
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

//Ceiling Light
void() light_ceil_dead = {
	local entity deadlight;
	local float oldz;
	
	precache_model ("progs/q15/lightceil.mdl");
	deadlight = spawn();
	setmodel (deadlight, "progs/q15/lightceil.mdl");
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
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

void() light_cdet = {
	light_ceil_dead();
	lightstyle(self.style, "b");
	remove(self.owner);
	self.think = light_break;
	self.nextthink = time;
};

void() light_ceil = {
	local float	oldz;
	local vector center;
	local entity lightray;
	
	center = (self.absmin + self.absmax) * 0.5;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("progs/q15/lightceil.mdl");
	precache_model ("progs/q15/p_lightbeams.mdl");
	setmodel (self, "progs/q15/lightceil.mdl");
	precache_sound ("misc/lightbrk.wav");
	precache_sound ("misc/siren.wav");
	
	lightray = spawn();
	setorigin(lightray, self.origin);
	lightray.solid = SOLID_NOT;
	setmodel(lightray, "progs/q15/p_lightbeams.mdl");
	lightray.movetype = MOVETYPE_FLY;
	lightray.alpha = 0.6;
	lightray.effects = EF_FULLBRIGHT;
	lightray.avelocity = '0 300 0';
	self.owner = lightray;
	self.health = 20;
	self.th_die = light_cdet;
	self.takedamage = DAMAGE_YES;
	
	if (self.health == 20) {
		lightstyle(self.style, "m");
		ambientsound (self.origin, "misc/siren.wav", 0.5, ATTN_STATIC);
	}

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};

//New Ceiling fixture

void() light_fix_dead = {
	local entity deadlight;
	local float oldz;
	
	deadlight = spawn();
	if (self.skin == 0) {
		precache_model ("progs/q15/lightfix.mdl");
		setmodel (deadlight, "progs/q15/lightfix.mdl");
	} else {
		precache_model ("progs/q15/lightfixalt.mdl");
		setmodel (deadlight, "progs/q15/lightfixalt.mdl");
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
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
}

void() light_fdet = {
	light_fix_dead();
	lightstyle(self.style, "b");
	self.think = light_break;
	self.nextthink = time;
};

void() light_fix = {
	local float	oldz;
	local vector center;
	
	center = (self.absmin + self.absmax) * 0.5;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	if (self.skin == 0) {
		precache_model ("progs/q15/lightfix.mdl");
		setmodel (self, "progs/q15/lightfix.mdl");
	} else {
		precache_model ("progs/q15/lightfixalt.mdl");
		setmodel (self, "progs/q15/lightfixalt.mdl");
	}
	precache_sound ("misc/lightbrk.wav");
	self.health = 20;
	self.th_die = light_fdet;
	self.takedamage = DAMAGE_YES;
	
	if (self.health == 20) {
		lightstyle(self.style, "m");
		precache_sound ("ambience/fl_hum1.wav");
		ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
	}

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	//droptofloor();
	if (oldz - self.origin_z > 250) {
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
};