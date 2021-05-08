//function to handle gibbing effects like particles

void() bodyCheck;
float BLOOD_POOL_CNT;


float() blood_checkbounds =
{
	makevectors(self.angles);
	local vector t1start, t1end, t2start, t2end;
	local vector FLRCHK = '0 0 2';
	local vector fwd_bnds = '23 0 0';
	local vector side_bnds = '0 23 0';
	
	t1start = self.origin + fwd_bnds;
	t1end = t1start - FLRCHK;
	
	t2start = self.origin + side_bnds;
	t2end = t2start - FLRCHK;
	
	traceline(t1start, t1end, TRUE, self);
	
	
	if (trace_fraction == 1)
		return FALSE;
	if (trace_ent.solid != SOLID_BSP)
		return FALSE;
		
	t1start = self.origin + -fwd_bnds;
	t1end = t1start - FLRCHK;
	
	traceline(t1start, t1end, TRUE, self);
	
	if (trace_fraction == 1)
		return FALSE;
	if (trace_ent.solid != SOLID_BSP)
		return FALSE;
		
	traceline(t2start, t2end, TRUE, self);
	
	if (trace_fraction == 1)
		return FALSE;
	if (trace_ent.solid != SOLID_BSP)
		return FALSE;
		
	t2start = self.origin + -side_bnds;
	t2end = t2start - FLRCHK;
	
	traceline(t2start, t2end, TRUE, self);
	
	if (trace_fraction == 1)
		return FALSE;	
	if (trace_ent.solid != SOLID_BSP)
		return FALSE;
		
	if(trace_inwater)
		return FALSE;
		
	//centerprint3(find(world,classname,"player"), "blood org: ", vtos(self.origin), strcat("\n tstart org: ", vtos(t2start), "\n tend org: ", vtos(t2end), "\n trace_frac: ", ftos(trace_fraction)));	
	
	return TRUE;
		
	
}

void() bloodpool_grow =
{
	
	if (blood_checkbounds() && self.frame < 69)
		self.frame++;
	else
		self.nextthink = -1;
	
		
	if (!(self.flags & FL_ONGROUND) && self.frame > 20)
	{
		BLOOD_POOL_CNT--;
		remove(self);
	}
	
	if (self.flags & FL_ONGROUND)
		self.alpha = .92;
		
	//bodyCheck();
		
	self.think = bloodpool_grow;
	
	self.nextthink = time + 0.1;
}



void() bloodpool =
{
	
	makevectors(self.owner.angles);	
	setmodel(self, "progs/bloodpool.mdl");
	
	self.scale = .9;
	self.think = bloodpool_grow;
	
	self.gravity = 5;
	self.solid = SOLID_NOT;
	self.frame = 0;
	
	self.angles_y = random(-200, 200);
	self.effects = EF_LOWPRECISION;
	setsize(self, '0 0 0', '1 0 0');
	self.movetype = MOVETYPE_TOSS;
	self.alpha = 0.00001;
	self.netname = "blood";
	//if (pointcontents(bloodpool.origin) != CONTENT_EMPTY)
	//	remove(bloodpool);
	BLOOD_POOL_CNT++;
	if (self.owner.classname == "player")
		self.nextthink = time + 1.8;
	else
		self.nextthink = time + 1;
}

void(float del) spawn_bloodpool =
{
	if (BLOOD_POOL_CNT > 4 && random(100) < 40)	//reduce the amount of spawned blood pools after 4
		return;
	entity bloodpl = spawn();
	
	bloodpl.origin = self.origin;
	
	bloodpl.owner = self;
	bloodpl.think = bloodpool;
	bloodpl.nextthink = time + del;
}



void() fire_burn_out = 
{
	
	if (cvar("gl_flashblend") == 1)
		self.pflags = PFLAGS_CORONA | PFLAGS_NOSHADOW;
	else
		self.pflags = self.pflags | PFLAGS_FULLDYNAMIC | PFLAGS_CORONA | PFLAGS_NOSHADOW;
	self.spintimer++;
	self.think = fire_burn_out;
	self.nextthink = time + 0.1;
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		self.pflags = PFLAGS_CORONA | PFLAGS_NOSHADOW;
	if (self.light_lev > 20)
		self.light_lev -= 0.3;
	//else
	//	self.light_lev = 0;
	
	if (self.spintimer > 100)
		self.traileffectnum = particleeffectnum("rocket_burn_die");
	if (self.spintimer > 145)
		self.traileffectnum = particleeffectnum("rocket_burn_faint");
	if (self.spintimer > 255)
		self.traileffectnum = particleeffectnum("burning_gib_fade");
	if (self.spintimer > 380)
	{
		sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
		remove(self);
	}
}

void() spawn_fire =
{
	if (coop && random(100) > 15)
		return;
	if (deathmatch && random(100) > 5)
		return;
	if ((!coop || !deathmatch) && random(100) > 25)
		return;
		
	local entity fire;
	
	fire = spawn();
	fire.owner = self;
	
	setorigin(fire, self.origin+'0 0 2');
	
	if (pointcontents(self.origin) == CONTENT_SOLID)
		setorigin(fire, self.origin-'0 0 2');
		
	
	setmodel(fire, "progs/gib3.mdl");
	fire.movetype = MOVETYPE_TOSS;
	fire.solid = SOLID_TRIGGER;
	fire.effects = EF_LOWPRECISION;
	
	fire.light_lev = 140;
	fire.color = '11 3 .2';
	fire.style = 6;
	fire.pflags = fire.pflags | PFLAGS_FULLDYNAMIC | PFLAGS_CORONA | PFLAGS_NOSHADOW;
	
	
	setsize (fire, '0 0 -2', '0 0 0');
	
	sound7 (fire, CHAN_WEAPON, "zombie/corpse_fire.wav", 1, ATTN_NORM);
	
	fire.velocity = 0;
	fire.alpha = 0.01;
	fire.traileffectnum = particleeffectnum("rocket_burn");
	
	if (pointcontents(fire.origin) == CONTENT_WATER || pointcontents(fire.origin) == CONTENT_SLIME || pointcontents(fire.origin) == CONTENT_LAVA)
	{
		fire.traileffectnum = particleeffectnum("");
		fire.spintimer = 379;
	}
	
	fire.think = fire_burn_out;
	fire.nextthink = time;
	
	//remove(self);
	
}

float LIGHT_COUNT; //global to track how many gibs have lights attached, for performance

void() gibdeath_effects =
{
	if (self.enemy.weapon == IT_LASER_CANNON || self.enemy.classname == "monster_enforcer" || self.enemy.classname == "monster_jim")
	{
		if (random(100) > 50)
			sound7 (other, CHAN_VOICE, "hipweap/hipmelt2.wav", 1, ATTN_NORM, SNDSPD);
		else
			sound7 (other, CHAN_VOICE, "hipweap/hipmelt.wav", 1, ATTN_NORM, SNDSPD);
		sendParticle("hiplas_death", self.origin, '0 0 0', 1);
	}
	else if (self.shocked > 0)
		sendParticle("blood_spurt", self.origin, '0 0 0', 1);
	else if (autocvar_bloodextension == 1)
		sendParticle("blood_monster_gib", self.origin, '0 0 0', 1);
		
	//if (self.enemy.weapon == IT_ROCKET_LAUNCHER || self.enemy.weapon == IT_GRENADE_LAUNCHER || self.sticky == 1)
		
}

void() burngib_end_think = 
{
	self.traileffectnum = particleeffectnum("charred_gib");

	self.pflags = PFLAGS_CORONA | PFLAGS_NOSHADOW;
	self.light_lev = 0;
	
	//if (LIGHT_COUNT < 6)
		LIGHT_COUNT-=1;
	self.colormod = '0.15 0.2 0.2';
};

void() burngib_think =
{
	if (LIGHT_COUNT < 6)
	{
		self.light_lev = 40;
		self.style = 1;
		self.color = '3 1.1 .5';
		
		if (cvar("gl_flashblend") == 1)
			self.pflags = PFLAGS_CORONA | PFLAGS_NOSHADOW;
		else
			self.pflags = self.pflags | PFLAGS_FULLDYNAMIC | PFLAGS_CORONA | PFLAGS_NOSHADOW;
	}
	
	self.traileffectnum = particleeffectnum("burning_gib_fade");
	self.think = burngib_end_think;
	self.nextthink = time + 6;
	self.colormod = '0.35 0.4 0.4';
		
};

void() burngib_init =
{
	if (LIGHT_COUNT < 6)
	{
		self.light_lev = 60;
		self.style = 6;
		self.color = '3.5 1.3 .7';
		LIGHT_COUNT++;
		
		
		if (cvar("gl_flashblend") == 1)
			self.pflags = PFLAGS_CORONA | PFLAGS_NOSHADOW;
		else
			self.pflags = self.pflags | PFLAGS_FULLDYNAMIC | PFLAGS_CORONA | PFLAGS_NOSHADOW;
	}
	
	self.think = burngib_think;
	self.nextthink = time + 14;
	self.colormod = '0.75 0.8 0.8';
		
};

void(float amount) spawn_stickygibs;

//Gibbing sounds

void() play_gibsound =
{
	if (coop)
		spawn_stickygibs(random(4,7));
	else
		spawn_stickygibs(random(2,4));
	
	if (random(100) < 25)
		sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM, SNDSPD);
	else if (random(100) < 50 && random(100) < 75)
		sound7(self, CHAN_VOICE, "player/udeath2.wav", 1, ATTN_NORM, SNDSPD);
	else
		sound7(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM, SNDSPD);
}

//LG Gibs

float(entity to, float sendFlags) sprite_sendtocsqc =
{
	
   WriteByte( MSG_ENTITY, ENT_SPRITE_EMITTER);
   WriteByte( MSG_ENTITY, sendFlags);
   
   if (sendFlags & 1)
   {
	   // Emitter origin
	   WriteCoord( MSG_ENTITY, self.origin_x );
	   WriteCoord( MSG_ENTITY, self.origin_y );
	   WriteCoord( MSG_ENTITY, self.origin_z );

	  // Emitter velocity
	   WriteCoord( MSG_ENTITY, self.velocity_x );
	   WriteCoord( MSG_ENTITY, self.velocity_y );
	   WriteCoord( MSG_ENTITY, self.velocity_z );
	   
	   //Type of effect (smoke/drip/etc)
	   WriteCoord( MSG_ENTITY, self.effecttype );
	   
   }

   return TRUE;
};

void() sprite_smoke_think =
{
	self.frame++;
		
	self.ltime++;
	
	self.alpha-=.03;
	self.scale+=.004;
	if (self.velocity_z < 20)
		self.velocity_z = self.velocity_z+1;
		
	//self.velocity_x = self.velocity_x-25;
	self.think = sprite_smoke_think;
	self.nextthink = time + .07;
	
	if (self.ltime > 61)
		remove(self);		
}

void() chargib_think;

void() clientsmoke_spawner =
{
	local entity smoke;
	smoke = spawn();
	setorigin(smoke, self.origin);
	setmodel(smoke, "progs/s_smoke_muzz.spr");
	smoke.alpha = 0.0001;
	smoke.effecttype = EFF_SMOKE;
	smoke.SendEntity = sprite_sendtocsqc;
	smoke.SendFlags |= 1;
	smoke.think = SUB_Remove;
	smoke.nextthink = time + 0.1;
	
	self.weapontimer = 43;
	self.think = chargib_think;
	self.nextthink = time + 0.1;
	
	

}

var float autocvar_gibsduration;


void() chargib_think = 
{
	if (coop || deathmatch && !self.weapontimer)
	{
		self.think = clientsmoke_spawner;
		self.nextthink = time + 1.4;
		return;
	}
	
	local entity emit;
	emit = spawn();
	emit.movetype = MOVETYPE_NOCLIP;
	emit.solid = SOLID_NOT;
	
	
	
	//eprint(emit);
	self.weapontimer++;
	emit.velocity = self.velocity/4;
	
	if (self.ltime <= 5)
		self.velocity = self.velocity/5;
	
	setmodel(emit, "progs/s_smoke_muzz.spr");
	emit.scale = 0.3;
	emit.alpha = .8;
	emit.origin = self.origin;
	
	

	
	emit.frame = random(0,2);
	
	emit.velocity_x += random(-5, -5);
	emit.velocity_y += random(-5, 5);
	emit.velocity_z += random(-5, 5);
	
	emit.think = sprite_smoke_think;
	emit.nextthink = time + 0.1;
	
		
	if (self.weapontimer > 43)
	{
		if (autocvar_gibsduration == 0)
		{
			self.think = chargib_think;
			self.nextthink = -1;
		}
		else
		{
			self.think = chargib_think;
			self.nextthink = time + autocvar_gibsduration;
		}
		
		//self.weapontimer = 0;
	}
	else
	{
		self.think = chargib_think;
		self.nextthink = time + random(0.2,0.7);
	}
	
	
}

//sticky giblets

void() gibs_rest =
{
	self.touch = SUB_Null;
}

void() gibs_think =
{
	self.velocity = 0;
	self.movetype = MOVETYPE_BOUNCE;
	self.think = gibs_rest;
	self.nextthink = time + 8;
	
}

 void(vector org, vector vel, float damage) SpawnBlood;

void() gibs_touch =
{
		
	if (pointcontents(self.origin + '0 0 3') == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if(other.solid != SOLID_BSP)
		return;
		
	if (self.waitmin > time) return;
	
	// Block multiple touch of impact sound
	self.waitmin = time + .1 + random() * 1;
	
	if (self.velocity < 100)
	{
		if (random(100) > 50)
			sound(self, CHAN_ITEM, "gib/gibhit1.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_ITEM, "gib/gibhit6.wav", 1, ATTN_NORM);
			
		
			
	}
	

	

	SpawnBlood (self.origin, '-10 -10 20', 5);
	
	
	//spawn_decal_wall();
	
	if (self.movetype == MOVETYPE_TOSS)
	{
		sendParticle("hldecal", self.origin, '0 0 100', 2);
		self.movetype = MOVETYPE_NONE;
		self.cnt = 0;
	}
	if (self.movetype == MOVETYPE_BOUNCE)
	{
		self.cnt++;
	}
	
	
}

void() GibSticky =
{
	local entity dripper;
	local vector throwdir;
	
	throwdir_x = random(-130,130) * -self.health/25;
	throwdir_y = random(-130, 130) * -self.health/25;
	throwdir_z = random(160, 250) * -self.health/25;
	
	//if ((coop || deathmatch) && (BLD > MAX_DRIPS))
	//	return;
	
	dripper = spawn();
	

	//setmodel (dripper,"progs/player.mdl");
	
	setorigin(dripper, self.origin);
	
	setmodel(dripper, "progs/gib_4.mdl");
	
	setsize (dripper, '0 0 0', '0 0 0');  
		
		
	//dripper.gravity = 1;
	
	dripper.velocity = throwdir;
	
	dripper.avelocity_x = random(-400, 400);
	dripper.avelocity_y = random(-400, 400);
	dripper.avelocity_z = random(-400, 400);
	
	if (random(100) < 60)
		dripper.movetype = MOVETYPE_TOSS;
	else
		dripper.movetype = MOVETYPE_BOUNCE;
	//dripper.traileffectnum = particleeffectnum("gibceil");
	dripper.solid = SOLID_TRIGGER;
	dripper.touch = gibs_touch;
	dripper.think = gibs_think;
	dripper.nextthink = time + random(2, 5);
	dripper.netname = "stickygib";
	
	//dripper.nextthink = time;
}

void(float amount) spawn_stickygibs =
{
	if (self.cnt < 0)
		self.cnt = 0;
	while (self.cnt <= amount)
	{
		GibSticky();
		self.cnt++;
	}
}

/*void() chargib_think = 
{
	
	self.think = gibsmoke;
	self.nextthink = time + 0.7;
	self.traileffectnum = 0;
	
}*/