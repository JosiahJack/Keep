/*
==============================================================================

Necromancer

Model from: Dawn of Darkness Q2-TC (necro.md2)

Monster properties:
Flying monster with various ranged combat abilities.
Can summon additional different monster types for reinforcement.

Abilities:
- Can cast death rays that instantly hits everybody in medium range who dares to challenge him
- When combat situation allows it, the Necromancer summons additional flying minions to support him
- Can cast flying, animated skulls that hunts his enemies mercilessly
- He will lose his human form when his health is low and will leave this world with a huge charge
- When the necromancer has been killed, he leaves a mystical evil symbol on the floor that gives the player some health
- Do not underestimate this creature and its evil skills

Necromancer is fully adjustable via cvars.
Please see cvar descriptions in included smc_config.cfg sample.

==============================================================================
*/


void() necro_run1;
void() necro_side1;

/*
=================
NecromancerCheckAttack
=================
*/
float() NecromancerCheckAttack =
{
	local vector spot1, spot2;	
	local entity targ;
	local float chance;

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			necro_run1();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			necro_run1();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.92;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		chance = 0.7;
	}
	else if (enemy_range == RANGE_MID)
	{
		chance = 0.333;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			necro_run1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			necro_side1();
		}
	}
	return FALSE;
};


float() NecromancerAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = necro_run1;
	}
	else
	{
		if ((random() < 0.22) && (enemy_range >= RANGE_NEAR))	// allow him to come nearer
		{
			self.attack_state = AS_STRAIGHT;
			self.think = necro_run1;
		}
		else
		{	
			self.attack_state = AS_SLIDING;
			self.think = necro_side1;
		}
	}
};





void(float combat) necro_idlesound =
{
local float randi;
	randi = random();
	
	if (combat)
	{
		if (randi < 0.3)
			sound(self, CHAN_VOICE, "necromancer/idle3.wav", 0.9, ATTN_NORM);
		else if (randi < 0.7)
			sound(self, CHAN_VOICE, "necromancer/idle4.wav", 0.666, ATTN_NORM);
		else
			sound(self, CHAN_VOICE, "necromancer/idle5.wav", 0.666, ATTN_NORM);
	}
	else
	{
		if (randi < 0.37)
			sound(self, CHAN_VOICE, "necromancer/idle1.wav", 1, ATTN_IDLE);
		else if (randi < 0.75)
			sound(self, CHAN_VOICE, "necromancer/idle3.wav", 0.8, ATTN_NORM);
		else
			sound(self, CHAN_VOICE, "necromancer/idle2.wav", 1, ATTN_IDLE);
	}
};






/////  Skull code

void() Necro_Skull_Touch =
{
	if (other == self.owner)
	{
		remove (self);
		return;
	}
	if (other.do_not_replace_me == 1)	// do not hurt spawned supporting minions !!!
	{
		remove (self);
		return;
	}

	if (other.takedamage)
	{
		spawn_touchblood (autocvar_necromancer_skull_damage);
		T_Damage (other, self, self.owner, autocvar_necromancer_skull_damage);		//  default 10
	}
	else
	{
		pointparticles(particleeffectnum("TE_AFRITSPIKE_RED"), self.origin, '0 0 0', 1);
		sound (self, CHAN_WEAPON, "afrit/fireballtouch.wav", 0.7, ATTN_NORM);
	}

	remove (self);
};


void () Necro_Skull_Homing =
{
local vector newdirection;
local float t, homingpower;

	if (self.enemy.health < 1)
		remove (self);

	if (self.maxlifetime < time)
		remove (self);

	self.velocity = normalize (self.velocity);
	newdirection = (self.enemy.origin + '0 0 12') - self.origin;
	newdirection = normalize (newdirection);
	t = time - self.ltime;
	self.ltime = time;

	if (skill == 0)
		homingpower = 0.1;	
	else if (skill == 1)
		homingpower = 0.2;	// 0.3
	else if (skill == 2)
		homingpower = 0.27;	// 0.4
	else 
		homingpower = 0.33;	// 0.5
	
	self.velocity = (self.velocity * (1 - homingpower) * t) + (newdirection * homingpower * t);
	self.velocity = normalize (self.velocity);
	self.velocity = self.velocity * 270;
	self.angles = vectoangles (self.velocity);
            
	self.think = Necro_Skull_Homing;
	self.nextthink = time + 0.2;
};


void(vector org, vector dir) Necro_Skull_Launch =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.enemy = self.enemy;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	
	newmis.touch = Necro_Skull_Touch; 
	setorigin (newmis, org);
	newmis.velocity = dir * 400;
	
	newmis.maxlifetime =  time + 5;
	newmis.think = Necro_Skull_Homing;
	newmis.nextthink = time + 0.1;
};


void() Necro_Skull =
{
	local vector vec, dst;

	if (self.owner.health > 0)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;
		makevectors (self.enemy.angles);
		dst = self.enemy.origin - 13*self.movedir;
		vec = normalize(dst - self.origin);
		sound(self, CHAN_WEAPON, "necromancer/skull.wav", 1, ATTN_NORM);
		Necro_Skull_Launch (self.origin, vec);

		newmis.velocity = vec * 270;
		newmis.owner = self.owner;
		newmis.classname = "Necro_Skull";
		setmodel (newmis, "progs/necromancer_skull.mdl");
		setsize (newmis, '0 0 0', '0 0 0');
		newmis.touch = Necro_Skull_Touch;
		newmis.alpha = 0.6;
	//	newmis.traileffectnum = particleeffectnum("TR_NECROMANCER_SKULL");		// FIXME:  new particle effect (something like grenade trail)
		newmis.traileffectnum = particleeffectnum("TR_GRENADE");			// FIXME:  new particle effect (something like grenade trail)
	}
	remove (self);
};


void() Necro_Skull_Start =
{
	local entity missile;

	makevectors (self.angles);
	missile = spawn();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize (missile, '0 0 0', '0 0 0');
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	setorigin (missile, self.origin + '0 0 23' + v_forward*7 + v_right*16);
	missile.think = Necro_Skull;
	missile.movedir = v_right;

	missile = spawn();
	missile.owner = self;
	missile.nextthink = time + 1;
	setsize (missile, '0 0 0', '0 0 0');
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.3;
	setorigin (missile, self.origin + '0 0 18' + v_forward*7 + v_right*-13);
	missile.think = Necro_Skull;
	missile.movedir = ('0 0 0' - v_right);
};








/////  Death Ray code

void() Necro_Ray_Touch =
{
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NOCLIP;

	if (other == self.owner)
	{
		remove (self);
		return;
	}
	
	if (other.do_not_replace_me == 1)	// do not hurt spawned supporting minions !
	{
		remove (self);
		return;
	}

	if (other.takedamage)
	{
		spawn_touchblood (autocvar_necromancer_ray_damage);
		T_Damage (other, self, self.owner, autocvar_necromancer_ray_damage);		//  default 2
	}
	else
	{
//		pointparticles(particleeffectnum("TE_AFRITSPIKE_GREY"), self.origin, '0 0 0', 1);
		pointparticles(particleeffectnum("TE_AFRITSPIKE_RED"), self.origin, '0 0 0', 1);	//  FIXME:  new effect
	}

	self.nextthink = time + 0.05;
	self.think = SUB_Remove;
};


/*
=============
Sets the given entities velocity and angles so that it will hit self.enemy
if self.enemy maintains it's current velocity
0.1 is moderately accurate, 0.0 is totally accurate
=============
*/
void() Necro_Ray_Start =
{
	local vector org, vec, move;
	local float fly;
	local entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "necro_ray";

	makevectors (self.angles);
	org = self.origin + '0 0 22' + v_forward*6 + v_right*15;
	vec = (self.enemy.origin + '0 0 4') - org;

	fly = vlen (vec) / 9999999;		// calc aproximate time for missile to reach enemy
	
	move = self.enemy.velocity;		// get enemies xy velocity
	move_z = 0;

	vec = vec + move * fly;			// project the target forward in time

	vec = normalize (vec);
	vec = vec + 0.1*v_up*(random()- 0.5) + 0.105*v_right*(random()- 0.5);		// 0.1
	
	missile.velocity = vec * 9999999;	// almost instant

	missile.scale = 0.1;
	missile.alpha = -1;

	missile.touch = Necro_Ray_Touch;
	
	missile.nextthink = time + 0.23;		// entity/particle beam lasts approx. 500 quake units
	missile.think = SUB_Remove;

	setmodel (missile, "progs/w_spike.mdl");
	setsize (missile, '0 0 0', '0 0 0');	

	missile.traileffectnum = particleeffectnum ("necromancer_beam");
	
	setorigin (missile, org);
};






/////  Summon minions

float() necro_check_summon =
{
	makevectors (self.angles);
	traceline (self.origin, self.origin + v_forward*80, TRUE, self);
	if (trace_fraction != 1)
		return (0);
	return (1);
};


void() add_wizard_support_fly;

void() necro_summon_monster =
{
	if (autocvar_necromancer_summon_minions == 1)
		add_wizard_support_fly (); 
	else if (autocvar_necromancer_summon_minions == 2)
	{
		if (random() < 0.5)
			add_wizard_support_fly (); 
		else
			add_afrit_support_fly (); 	
	}
	else if (autocvar_necromancer_summon_minions == 3)
	{
		local float sel;
		sel = random();
		if (sel > 0.66)
			add_wizard_support_fly ();
		else if (sel < 0.33)
			add_afrit_support_fly ();
		else
			add_reiver_support_fly (); 	
	}
	self.magiccounter = self.magiccounter + 1;
};






/// IDLE

void(float counta) pray_particle_effect_think =
{
	while (counta > 0)
	{
		pointparticles(particleeffectnum("necromancer_pray"), self.origin, '0 0 0', 1);
		counta = counta - 1;
	}
};


void() necro_pray01 = [ 174, necro_pray02 ] {self.nextthink = time + 0.1; ai_stand();	
	sound(self, CHAN_VOICE, "necromancer/pray.wav", 1, ATTN_IDLE);
	pray_particle_effect_think (1);};
void() necro_pray02 = [ 175, necro_pray03 ] {self.nextthink = time + 0.09; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray03 = [ 176, necro_pray04 ] {self.nextthink = time + 0.08; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray04 = [ 177, necro_pray05 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray05 = [ 178, necro_pray06 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray06 = [ 179, necro_pray07 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray07 = [ 180, necro_pray08 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray08 = [ 181, necro_pray09 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray09 = [ 182, necro_pray10 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray10 = [ 183, necro_pray11 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray11 = [ 184, necro_pray12 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray12 = [ 185, necro_pray13 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray13 = [ 186, necro_pray14 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray14 = [ 187, necro_pray15 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};

void() necro_pray15 = [ 188, necro_pray15a ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray15a = [ 188, necro_pray16 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};

void() necro_pray16 = [ 187, necro_pray17 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray17 = [ 186, necro_pray18 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray18 = [ 185, necro_pray19 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray19 = [ 184, necro_pray20 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray20 = [ 183, necro_pray21 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray21 = [ 182, necro_pray22 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray22 = [ 181, necro_pray23 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray23 = [ 180, necro_pray24 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray24 = [ 179, necro_pray25 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray25 = [ 178, necro_pray26 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray26 = [ 177, necro_pray27 ] {self.nextthink = time + 0.07; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray27 = [ 176, necro_pray28 ] {self.nextthink = time + 0.08; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray28 = [ 175, necro_pray29 ] {self.nextthink = time + 0.09; ai_stand();
	pray_particle_effect_think (1);};
void() necro_pray29 = [ 174, necro_idle01 ] {self.nextthink = time + 0.1; ai_stand();
	pray_particle_effect_think (1);};


void() necro_idle01 = [ 0, necro_idle02 ] {ai_stand();
	if (random() < 0.35)
		necro_idlesound(0);};
void() necro_idle02 = [ 1, necro_idle03 ] {ai_stand();};
void() necro_idle03 = [ 2, necro_idle04 ] {ai_stand();};
void() necro_idle04 = [ 3, necro_idle05 ] {ai_stand();};
void() necro_idle05 = [ 4, necro_idle06 ] {ai_stand();};
void() necro_idle06 = [ 5, necro_idle07 ] {ai_stand();};
void() necro_idle07 = [ 6, necro_idle08 ] {ai_stand();};
void() necro_idle08 = [ 7, necro_idle09 ] {ai_stand();};
void() necro_idle09 = [ 8, necro_idle10 ] {ai_stand();};
void() necro_idle10 = [ 9, necro_idle11 ] {ai_stand();};
void() necro_idle11 = [ 10, necro_idle12 ] {ai_stand();};
void() necro_idle12 = [ 11, necro_idle13 ] {ai_stand();};
void() necro_idle13 = [ 12, necro_idle14 ] {ai_stand();};
void() necro_idle14 = [ 13, necro_idle15 ] {ai_stand();};
void() necro_idle15 = [ 14, necro_idle16 ] {ai_stand();};
void() necro_idle16 = [ 15, necro_idle17 ] {ai_stand();};
void() necro_idle17 = [ 16, necro_idle18 ] {ai_stand();};
void() necro_idle18 = [ 17, necro_idle19 ] {ai_stand();};
void() necro_idle19 = [ 18, necro_idle20 ] {ai_stand();};
void() necro_idle20 = [ 19, necro_idle21 ] {ai_stand();};
void() necro_idle21 = [ 20, necro_idle22 ] {ai_stand();};
void() necro_idle22 = [ 21, necro_idle23 ] {ai_stand();};
void() necro_idle23 = [ 22, necro_idle24 ] {ai_stand();};
void() necro_idle24 = [ 23, necro_idle25 ] {ai_stand();};
void() necro_idle25 = [ 24, necro_idle26 ] {ai_stand();};
void() necro_idle26 = [ 25, necro_idle27 ] {ai_stand();};
void() necro_idle27 = [ 26, necro_idle28 ] {ai_stand();};
void() necro_idle28 = [ 27, necro_idle29 ] {ai_stand();};
void() necro_idle29 = [ 28, necro_idle30 ] {ai_stand();};
void() necro_idle30 = [ 29, necro_idle31 ] {ai_stand();};
void() necro_idle31 = [ 30, necro_idle32 ] {ai_stand();};
void() necro_idle32 = [ 31, necro_idle33 ] {ai_stand();};
void() necro_idle33 = [ 32, necro_idle34 ] {ai_stand();};
void() necro_idle34 = [ 33, necro_idle35 ] {ai_stand();};
void() necro_idle35 = [ 34, necro_idle36 ] {ai_stand();};
void() necro_idle36 = [ 35, necro_idle37 ] {ai_stand();};
void() necro_idle37 = [ 36, necro_idle38 ] {ai_stand();};
void() necro_idle38 = [ 37, necro_idle39 ] {ai_stand();};
void() necro_idle39 = [ 38, necro_idle40 ] {ai_stand();};
void() necro_idle40 = [ 39, necro_idle41 ] {ai_stand();};
void() necro_idle41 = [ 40, necro_idle42 ] {ai_stand();};
void() necro_idle42 = [ 41, necro_idle43 ] {ai_stand();};
void() necro_idle43 = [ 42, necro_idle44 ] {ai_stand();};
void() necro_idle44 = [ 43, necro_idle45 ] {ai_stand();};
void() necro_idle45 = [ 44, necro_idle46 ] {ai_stand();};
void() necro_idle46 = [ 45, necro_idle47 ] {ai_stand();};
void() necro_idle47 = [ 46, necro_idle48 ] {ai_stand();};
void() necro_idle48 = [ 47, necro_idle49 ] {ai_stand();};
void() necro_idle49 = [ 48, necro_idle50 ] {ai_stand();};
void() necro_idle50 = [ 49, necro_idle51 ] {ai_stand();};
void() necro_idle51 = [ 50, necro_idle52 ] {ai_stand();};
void() necro_idle52 = [ 51, necro_idle53 ] {ai_stand();};
void() necro_idle53 = [ 52, necro_idle54 ] {ai_stand();};
void() necro_idle54 = [ 53, necro_idle55 ] {ai_stand();};
void() necro_idle55 = [ 54, necro_idle56 ] {ai_stand();};
void() necro_idle56 = [ 55, necro_idle57 ] {ai_stand();};
void() necro_idle57 = [ 56, necro_idle58 ] {ai_stand();};
void() necro_idle58 = [ 57, necro_idle59 ] {ai_stand();};
void() necro_idle59 = [ 58, necro_idle60 ] {ai_stand();};
void() necro_idle60 = [ 59, necro_idle01 ] {ai_stand();
	if (random() < 0.27)
		necro_pray01 ();	// chance to go into magic pray animation
};





/// walk/fly

void() necro_fly_pray01 = [ 174, necro_fly_pray02 ] {self.nextthink = time + 0.1; ai_walk(0);	
	sound(self, CHAN_VOICE, "necromancer/pray.wav", 1, ATTN_IDLE);
	pray_particle_effect_think (1);};
void() necro_fly_pray02 = [ 175, necro_fly_pray03 ] {self.nextthink = time + 0.09; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray03 = [ 176, necro_fly_pray04 ] {self.nextthink = time + 0.08; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray04 = [ 177, necro_fly_pray05 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray05 = [ 178, necro_fly_pray06 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray06 = [ 179, necro_fly_pray07 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray07 = [ 180, necro_fly_pray08 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray08 = [ 181, necro_fly_pray09 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray09 = [ 182, necro_fly_pray10 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray10 = [ 183, necro_fly_pray11 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray11 = [ 184, necro_fly_pray12 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray12 = [ 185, necro_fly_pray13 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray13 = [ 186, necro_fly_pray14 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray14 = [ 187, necro_fly_pray15 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};

void() necro_fly_pray15 = [ 188, necro_fly_pray15a ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray15a = [ 188, necro_fly_pray16 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};

void() necro_fly_pray16 = [ 187, necro_fly_pray17 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray17 = [ 186, necro_fly_pray18 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray18 = [ 185, necro_fly_pray19 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray19 = [ 184, necro_fly_pray20 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray20 = [ 183, necro_fly_pray21 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray21 = [ 182, necro_fly_pray22 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray22 = [ 181, necro_fly_pray23 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray23 = [ 180, necro_fly_pray24 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray24 = [ 179, necro_fly_pray25 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray25 = [ 178, necro_fly_pray26 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray26 = [ 177, necro_fly_pray27 ] {self.nextthink = time + 0.07; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray27 = [ 176, necro_fly_pray28 ] {self.nextthink = time + 0.08; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray28 = [ 175, necro_fly_pray29 ] {self.nextthink = time + 0.09; ai_walk(0);
	pray_particle_effect_think (1);};
void() necro_fly_pray29 = [ 174, necro_fly01 ] {self.nextthink = time + 0.1; ai_walk(0);
	pray_particle_effect_think (1);};


void() necro_fly01 = [ 60, necro_fly02 ] {ai_walk(8);	
if (random() < 0.25)
	necro_idlesound(0);};
void() necro_fly02 = [ 61, necro_fly03 ] {ai_walk(8);};
void() necro_fly03 = [ 62, necro_fly04 ] {ai_walk(8);};
void() necro_fly04 = [ 63, necro_fly05 ] {ai_walk(8);};
void() necro_fly05 = [ 64, necro_fly06 ] {ai_walk(8);};
void() necro_fly06 = [ 65, necro_fly07 ] {ai_walk(8);};
void() necro_fly07 = [ 66, necro_fly08 ] {ai_walk(8);};
void() necro_fly08 = [ 67, necro_fly09 ] {ai_walk(8);};
void() necro_fly09 = [ 68, necro_fly10 ] {ai_walk(8);};
void() necro_fly10 = [ 69, necro_fly11 ] {ai_walk(8);};
void() necro_fly11 = [ 70, necro_fly12 ] {ai_walk(8);};
void() necro_fly12 = [ 71, necro_fly13 ] {ai_walk(8);};
void() necro_fly13 = [ 72, necro_fly14 ] {ai_walk(8);};
void() necro_fly14 = [ 73, necro_fly15 ] {ai_walk(8);};
void() necro_fly15 = [ 74, necro_fly16 ] {ai_walk(8);};
void() necro_fly16 = [ 75, necro_fly17 ] {ai_walk(8);};
void() necro_fly17 = [ 76, necro_fly18 ] {ai_walk(8);};
void() necro_fly18 = [ 77, necro_fly19 ] {ai_walk(8);};
void() necro_fly19 = [ 78, necro_fly20 ] {ai_walk(8);};
void() necro_fly20 = [ 79, necro_fly01 ] {ai_walk(8);
	if (random() < 0.17)
		necro_fly_pray01 ();	// chance to go into magic pray animation
};




/// SIDE

void() necro_side1 = [ 60, necro_side2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10); 
if (random() < 0.3)
	necro_idlesound(1);};
void() necro_side2 = [ 61, necro_side3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side3 = [ 62, necro_side4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side4 = [ 63, necro_side5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side5 = [ 64, necro_side6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side6 = [ 65, necro_side7 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side7 = [ 66, necro_side8 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side8 = [ 67, necro_side9 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side9 = [ 68, necro_side10 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side10 = [ 69, necro_side11 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side11 = [ 70, necro_side12 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side12 = [ 71, necro_side13 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side13 = [ 72, necro_side14 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side14 = [ 73, necro_side15 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side15 = [ 74, necro_side16 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side16 = [ 75, necro_side17 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side17 = [ 76, necro_side18 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side18 = [ 77, necro_side19 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side19 = [ 78, necro_side20 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};
void() necro_side20 = [ 79, necro_side1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(10);};




/// RUN

void() necro_run1 = [ 60, necro_run2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16); 
if (random() < 0.3)
	necro_idlesound(1);};
void() necro_run2 = [ 61, necro_run3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run3 = [ 62, necro_run4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run4 = [ 63, necro_run5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run5 = [ 64, necro_run6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run6 = [ 65, necro_run7 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run7 = [ 66, necro_run8 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run8 = [ 67, necro_run9 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run9 = [ 68, necro_run10 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run10 = [ 69, necro_run11 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run11 = [ 70, necro_run12 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run12 = [ 71, necro_run13 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run13 = [ 72, necro_run14 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run14 = [ 73, necro_run15 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run15 = [ 74, necro_run16 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run16 = [ 75, necro_run17 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run17 = [ 76, necro_run18 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run18 = [ 77, necro_run19 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run19 = [ 78, necro_run20 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};
void() necro_run20 = [ 79, necro_run1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); ai_run(16);};





/// RANGED ATTACK: RAY 

void() necro_ray1 = [ 80, necro_ray2 ] {ai_face();};
void() necro_ray2 = [ 81, necro_ray3 ] {ai_face();};
void() necro_ray3 = [ 82, necro_ray4 ] {ai_face();};
void() necro_ray4 = [ 83, necro_ray5 ] {ai_face();};
void() necro_ray5 = [ 84, necro_ray6 ] {ai_face(); sound(self, CHAN_WEAPON, "necromancer/ray.wav", 1, ATTN_NORM);};
void() necro_ray6 = [ 85, necro_ray7 ] {ai_face();};
void() necro_ray7 = [ 86, necro_ray7a  ] {ai_face();  self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray7a = [ 86, necro_ray8  ] {ai_face();  self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray8 =  [ 87, necro_ray8a ] {ai_face();  self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray8a = [ 87, necro_ray9  ] {ai_face();  self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray9 =  [ 88, necro_ray9a ] {ai_face();  self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray9a = [ 88, necro_ray10 ] {ai_face();  self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray10 = [ 89, necro_ray10a ] {ai_face(); self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray10a = [ 89, necro_ray11 ] {ai_face(); self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray11 =  [ 90, necro_ray11a] {ai_face(); self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray11a = [ 90, necro_ray12 ] {ai_face(); self.nextthink = time + 0.05; Necro_Ray_Start ();};
void() necro_ray12 = [ 91, necro_ray13 ] {ai_face();};
void() necro_ray13 = [ 92, necro_ray14 ] {ai_face();};
void() necro_ray14 = [ 93, necro_ray15 ] {ai_face();};
void() necro_ray15 = [ 94, necro_ray16 ] {ai_face();};
void() necro_ray16 = [ 95, necro_ray17 ] {ai_face();};
void() necro_ray17 = [ 96, necro_ray18 ] {ai_face();};
void() necro_ray18 = [ 97, necro_ray19 ] {ai_face();};
void() necro_ray19 = [ 98, necro_ray20 ] {ai_face();};
void() necro_ray20 = [ 99, necro_run1 ] {ai_face();
	SUB_AttackFinished(1.1);
	NecromancerAttackFinished();
};




/// RANGED ATTACK: SKULL

void() necro_skull1 = [ 150, necro_skull2 ] {ai_face(); self.nextthink = time + 0.085; Necro_Skull_Start ();};
void() necro_skull2 = [ 151, necro_skull3 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull3 = [ 152, necro_skull4 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull4 = [ 153, necro_skull5 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull5 = [ 154, necro_skull6 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull6 = [ 155, necro_skull7 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull7 = [ 156, necro_skull8 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull8 = [ 157, necro_skull9 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull9 = [ 158, necro_skull10 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull10 = [ 159, necro_skull11 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull11 = [ 160, necro_skull12 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull12 = [ 161, necro_skull13 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull13 = [ 162, necro_skull14 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull14 = [ 163, necro_skull15 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull15 = [ 164, necro_skull16 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull16 = [ 165, necro_skull17 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull17 = [ 166, necro_skull18 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull18 = [ 167, necro_skull19 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull19 = [ 168, necro_skull20 ] {ai_face(); self.nextthink = time + 0.085;};
void() necro_skull20 = [ 169, necro_run1 ] {ai_face();
	SUB_AttackFinished(1.1);
	NecromancerAttackFinished();
};




/// SUMMON MONSTER

void(float counta) summon_particle_effect_think =
{
	makevectors (self.angles);
	while (counta > 0)
	{
		pointparticles(particleeffectnum("necromancer_summon"), self.origin + v_up *10 + v_forward*23 + v_right*1, '0 0 0', 1);	
		counta = counta - 1;
	}
};

void () summon_sprite_effect_think =
{
	if (self.owner.health <= 0)
		remove (self);

	if (self.maxlifetime < time)
		remove (self);

	if (self.alpha <= 1)
		self.alpha = self.alpha + 0.06;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	self.think = summon_sprite_effect_think;
	self.nextthink = time + 0.1;
};

void() necro_summon001 = [ 100, necro_summon002 ] {ai_face(); self.nextthink = time + 0.035;
	sound (self, CHAN_WEAPON, "necromancer/summon.wav", 1, ATTN_NORM); 
};
void() necro_summon002 = [ 101, necro_summon003 ] {ai_face(); self.nextthink = time + 0.035;};
void() necro_summon003 = [ 102, necro_summon004 ] {ai_face(); self.nextthink = time + 0.035;};
void() necro_summon004 = [ 103, necro_summon005 ] {ai_face(); self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_sprite_effect)
	{
		local entity o;
		local vector opos;
		o = spawn();
		o.owner = self;
		o.alpha = 0.03;
		if (autocvar_necromancer_summon_sprite_effect == 1)
		{
			setmodel (o, "progs/necro_summon1.spr");
			o.scale = 0.3;				
			o.colormod = '0.9 0.65 0.65';
		}
		else if (autocvar_necromancer_summon_sprite_effect == 2)
		{
			setmodel (o, "progs/necro_summon2.spr");
			o.scale = 0.65;		
			o.colormod = '0.7 0.65 0.65';
		}
		else
		{
			if (random() < 0.5)
			{
				setmodel (o, "progs/necro_summon1.spr");
				o.scale = 0.3;				
				o.colormod = '0.9 0.65 0.65';
			}
			else
			{
				setmodel (o, "progs/necro_summon2.spr");
				o.scale = 0.65;		
				o.colormod = '0.7 0.65 0.65';
			}
		}
		o.movetype = MOVETYPE_FLY;
		o.solid = SOLID_NOT;
		makevectors (self.angles);
		opos = self.origin + v_up *10 + v_forward*23 + v_right*1;
		setorigin (o, opos);
		o.angles = self.angles;
		o.maxlifetime = time + 1.8;
		o.nextthink = time + 0.01;
		o.think = summon_sprite_effect_think;
	}
	
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (1.9);
};
void() necro_summon005 = [ 104, necro_summon006 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (1.9);};
void() necro_summon006 = [ 105, necro_summon007 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (1.9);};
void() necro_summon007 = [ 106, necro_summon008 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (3.9);};
void() necro_summon008 = [ 107, necro_summon009 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (3.9);};
void() necro_summon009 = [ 108, necro_summon010 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (3.9);};
void() necro_summon010 = [ 109, necro_summon011 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (5.9);};
void() necro_summon011 = [ 110, necro_summon012 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (5.9);};
void() necro_summon012 = [ 111, necro_summon013 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (5.9);};
void() necro_summon013 = [ 112, necro_summon014 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (7.9);};
void() necro_summon014 = [ 113, necro_summon015 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (7.9);};
void() necro_summon015 = [ 114, necro_summon016 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (7.9);};
void() necro_summon016 = [ 115, necro_summon017 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (9.9);};
void() necro_summon017 = [ 116, necro_summon018 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (9.9);};
void() necro_summon018 = [ 117, necro_summon019 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (9.9);};
void() necro_summon019 = [ 118, necro_summon020 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (11.9);};
void() necro_summon020 = [ 119, necro_summon021 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (11.9);};
void() necro_summon021 = [ 120, necro_summon022 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (11.9);};
void() necro_summon022 = [ 121, necro_summon023 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (13.9);};
void() necro_summon023 = [ 122, necro_summon024 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (13.9);};
void() necro_summon024 = [ 123, necro_summon025 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (13.9);};
void() necro_summon025 = [ 124, necro_summon026 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (15.9);};
void() necro_summon026 = [ 125, necro_summon027 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (15.9);};
void() necro_summon027 = [ 126, necro_summon028 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (15.9);};
void() necro_summon028 = [ 127, necro_summon029 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (17.9);};
void() necro_summon029 = [ 128, necro_summon030 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (17.9);};
void() necro_summon030 = [ 129, necro_summon031 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (17.9);};
void() necro_summon031 = [ 130, necro_summon032 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (19.9);};
void() necro_summon032 = [ 131, necro_summon033 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (19.9);};
void() necro_summon033 = [ 132, necro_summon034 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (19.9);};
void() necro_summon034 = [ 133, necro_summon035 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (21.9);};
void() necro_summon035 = [ 134, necro_summon036 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (21.9);};
void() necro_summon036 = [ 135, necro_summon037 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (21.9);};
void() necro_summon037 = [ 136, necro_summon038 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (23.9);};
void() necro_summon038 = [ 137, necro_summon039 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (23.9);};
void() necro_summon039 = [ 138, necro_summon040 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (23.9);};
void() necro_summon040 = [ 139, necro_summon041 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (25.9);};
void() necro_summon041 = [ 140, necro_summon042 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (25.9);};
void() necro_summon042 = [ 141, necro_summon043 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (25.9);};
void() necro_summon043 = [ 142, necro_summon044 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (27.9);};
void() necro_summon044 = [ 143, necro_summon045 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (27.9);};
void() necro_summon045 = [ 144, necro_summon046 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (27.9);};
void() necro_summon046 = [ 145, necro_summon047 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (29.9);};
void() necro_summon047 = [ 146, necro_summon048 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (29.9);};
void() necro_summon048 = [ 147, necro_summon049 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (29.9);};
void() necro_summon049 = [ 148, necro_summon050 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (31.9);};
void() necro_summon050 = [ 149, necro_summon051 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (31.9);};
void() necro_summon051 = [ 150, necro_summon052 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (31.9);};
void() necro_summon052 = [ 151, necro_summon053 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (31.9);};
void() necro_summon053 = [ 152, necro_summon054 ] {self.nextthink = time + 0.035;
	if (autocvar_necromancer_summon_particle_effect)
		summon_particle_effect_think (31.9);};
void() necro_summon054 = [ 153, necro_summon055 ] {necro_summon_monster ();};	///////////////////////////////
void() necro_summon055 = [ 154, necro_summon056 ] {self.nextthink = time + 0.035;};
void() necro_summon056 = [ 155, necro_summon057 ] {self.nextthink = time + 0.035;};
void() necro_summon057 = [ 156, necro_summon058 ] {self.nextthink = time + 0.035;};
void() necro_summon058 = [ 157, necro_summon059 ] {self.nextthink = time + 0.035;};
void() necro_summon059 = [ 158, necro_summon060 ] {self.nextthink = time + 0.035;};
void() necro_summon060 = [ 159, necro_summon061 ] {self.nextthink = time + 0.035;};
void() necro_summon061 = [ 160, necro_summon062 ] {self.nextthink = time + 0.035;};
void() necro_summon062 = [ 161, necro_summon063 ] {self.nextthink = time + 0.035;};
void() necro_summon063 = [ 162, necro_summon064 ] {self.nextthink = time + 0.035;};
void() necro_summon064 = [ 163, necro_summon065 ] {self.nextthink = time + 0.035;};
void() necro_summon065 = [ 164, necro_summon066 ] {self.nextthink = time + 0.035;};
void() necro_summon066 = [ 165, necro_summon067 ] {self.nextthink = time + 0.035;};
void() necro_summon067 = [ 166, necro_summon068 ] {self.nextthink = time + 0.035;};
void() necro_summon068 = [ 167, necro_summon069 ] {self.nextthink = time + 0.035;};
void() necro_summon069 = [ 168, necro_summon070 ] {self.nextthink = time + 0.035;};
void() necro_summon070 = [ 169, necro_run1 ] {
	SUB_AttackFinished(1.1);
	NecromancerAttackFinished();
};



/// RANGED ATTACK SELECTION

void() necro_Missile =
{
	local float r;
	r = random();

	if ((autocvar_necromancer_summon_minions) && (autocvar_necromancer_summon_minions_chance))
	{
		local float chance;		
		chance = autocvar_necromancer_summon_minions_chance * 0.01;	// adjustable chance to summon minions at all
		if (r <= chance) 
		{
			if ((self.wait_summon < time) && (self.magiccounter < 2))	// do not summon too many minions at the same time
			{
				self.wait_summon = time + autocvar_necromancer_summon_minions_min_time_interval;	// do not summon minions too often  (default = 6)
				if (necro_check_summon() == 1)
					necro_summon001 ();
				else
				{
					if ((random() > 0.37) && (enemy_range < RANGE_MID))
						necro_ray1 ();
					else
						necro_skull1 ();
				}	
			}
			else
			{ 
				if ((random() > 0.37) && (enemy_range < RANGE_MID))
					necro_ray1 ();
				else
					necro_skull1 ();
			}
		}
		else
		{
			if ((random() > 0.37) && (enemy_range < RANGE_MID))
				necro_ray1 ();
			else
				necro_skull1 ();
		}
	}
	else
	{
		if ((random() > 0.37) && (enemy_range < RANGE_MID))
			necro_ray1 ();
		else
			necro_skull1 ();
	}	
};





/// PAIN

void() necro_pain1 = [ 170, necro_pain2 ] {self.nextthink = time +  0.18;};
void() necro_pain2 = [ 171, necro_pain3 ] {self.nextthink = time +  0.15;};
void() necro_pain3 = [ 172, necro_pain4 ] {self.nextthink = time +  0.13;};
void() necro_pain4 = [ 173, necro_run1 ] {self.nextthink = time +  0.12;};

void(entity attacker, float damage) necro_Pain =
{
	sound(self, CHAN_VOICE, "necromancer/pain.wav", 1, ATTN_NORM);
	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
	if ((random() * 50) > damage)		// didn't flinch
	{
		return;
	}
	necro_pain1();
};





/// DEATH

void() necro_death1 = [ 174, necro_death2 ]
{
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 175 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.nextthink = time + 0.06;
};
void() necro_death2 = [ 175, necro_death3 ] { self.nextthink = time + 0.04;};
void() necro_death3 = [ 176, necro_death4 ] { self.nextthink = time + 0.04;};
void() necro_death4 = [ 177, necro_death5 ] { self.nextthink = time + 0.04; self.solid = SOLID_NOT;};
void() necro_death5 = [ 178, necro_death6 ] { self.nextthink = time + 0.04;
	sound (self, CHAN_VOICE, "necromancer/death.wav", 1, ATTN_NORM);
	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
};
void() necro_death6 = [ 179, necro_death7 ] { self.nextthink = time + 0.04;};
void() necro_death7 = [ 180, necro_death8 ] { self.nextthink = time + 0.04;};
void() necro_death8 = [ 181, necro_death9 ] { self.nextthink = time + 0.04;};
void() necro_death9 = [ 182, necro_death10 ] { self.nextthink = time + 0.04;};
void() necro_death10 = [ 183, necro_death11 ] { self.nextthink = time + 0.04;};
void() necro_death11 = [ 184, necro_death12 ] { self.nextthink = time + 0.04;};
void() necro_death12 = [ 185, necro_death13 ] { self.nextthink = time + 0.04;};
void() necro_death13 = [ 186, necro_death14 ] { self.nextthink = time + 0.04;};
void() necro_death14 = [ 187, necro_death15 ] { self.nextthink = time + 0.04;};
void() necro_death15 = [ 188, necro_death16 ] { self.nextthink = time + 0.04;};
void() necro_death16 = [ 189, necro_death17 ] { self.nextthink = time + 0.04;};
void() necro_death17 = [ 190, necro_death18 ] { self.nextthink = time + 0.04;};
void() necro_death18 = [ 191, necro_death19 ] { self.nextthink = time + 0.04;};
void() necro_death19 = [ 192, necro_death20 ] { self.nextthink = time + 0.04; self.alpha = 0.051;};
void() necro_death20 = [ 193, necro_death21 ] { self.nextthink = time + 0.04;};
void() necro_death21 = [ 194, necro_death22 ] { self.nextthink = time + 0.04; self.alpha = 1;};
void() necro_death22 = [ 195, necro_death23 ] { self.nextthink = time + 0.04;};
void() necro_death23 = [ 196, necro_death24 ] { self.nextthink = time + 0.04;};
void() necro_death24 = [ 197, necro_death25 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *9 + v_up *-7, '0 0 0', 1); 
};
void() necro_death25 = [ 198, necro_death26 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *14 + v_up *-7, '0 0 0', 1); 
};
void() necro_death26 = [ 199, necro_death27 ] { self.nextthink = time + 0.05; self.alpha = 0.051;};
void() necro_death27 = [ 200, necro_death28 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *19 + v_up *-5, '0 0 0', 1); 
};
void() necro_death28 = [ 201, necro_death29 ] { self.nextthink = time + 0.05;};
void() necro_death29 = [ 202, necro_death30 ] { self.nextthink = time + 0.05; self.alpha = 1;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *24 + v_up *2, '0 0 0', 1); 
};
void() necro_death30 = [ 203, necro_death31 ] { self.nextthink = time + 0.05;};
void() necro_death31 = [ 204, necro_death32 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *29 + v_up *6, '0 0 0', 1); 
};
void() necro_death32 = [ 205, necro_death33 ] { self.nextthink = time + 0.05;};
void() necro_death33 = [ 206, necro_death34 ] { self.nextthink = time + 0.05; self.alpha = 0.051;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *33 + v_up *-6, '0 0 0', 1); 
};
void() necro_death34 = [ 207, necro_death35 ] { self.nextthink = time + 0.05;};
void() necro_death35 = [ 208, necro_death36 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *38 + v_up *-10, '0 0 0', 1); 
};
void() necro_death36 = [ 209, necro_death37 ] { self.nextthink = time + 0.05; self.alpha = 1;};
void() necro_death37 = [ 210, necro_death38 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *44 + v_up *-11, '0 0 0', 1); 
};
void() necro_death38 = [ 211, necro_death39 ] { self.nextthink = time + 0.05;};
void() necro_death39 = [ 212, necro_death40 ] { self.nextthink = time + 0.05;};
void() necro_death40 = [ 213, necro_death41 ] { self.nextthink = time + 0.05;
makevectors (self.angles);
pointparticles(particleeffectnum("necromancer_heart"), self.origin + v_forward *48 + v_up *-15, '0 0 0', 1); 
};
void() necro_death41 = [ 214, necro_death42 ] { self.nextthink = time + 0.05;};
void() necro_death42 = [ 215, necro_death43 ] { self.nextthink = time + 0.04; self.alpha = 0.051;};
void() necro_death43 = [ 216, necro_death44 ] { self.nextthink = time + 0.04;};
void() necro_death44 = [ 217, necro_death45 ] { self.nextthink = time + 0.04; self.alpha = 1;};
void() necro_death45 = [ 218, necro_death46 ] { self.nextthink = time + 0.04;};
void() necro_death46 = [ 219, necro_death47 ] { self.nextthink = time + 0.04;};
void() necro_death47 = [ 220, necro_death48 ] { self.nextthink = time + 0.04;};
void() necro_death48 = [ 221, necro_death49 ] { self.nextthink = time + 0.04; self.alpha = 0.051;};
void() necro_death49 = [ 222, necro_death50 ] { self.nextthink = time + 0.04;};
void() necro_death50 = [ 223, necro_death51 ] { self.nextthink = time + 0.04;};
void() necro_death51 = [ 224, necro_death52 ] { self.nextthink = time + 0.04; self.alpha = 1;};
void() necro_death52 = [ 225, necro_death53 ] { self.nextthink = time + 0.04;};
void() necro_death53 = [ 226, necro_death54 ] { self.nextthink = time + 0.04;};
void() necro_death54 = [ 227, necro_death55 ] { self.nextthink = time + 0.04;};
void() necro_death55 = [ 228, necro_death56 ] { self.nextthink = time + 0.04;};
void() necro_death56 = [ 229, necro_death57 ] { self.nextthink = time + 0.04;};
void() necro_death57 = [ 230, necro_death58 ] { self.nextthink = time + 0.04; self.alpha = 0.051;};
void() necro_death58 = [ 231, necro_death59 ] { self.nextthink = time + 0.06;};
void() necro_death59 = [ 232, necro_death60 ] { self.nextthink = time + 0.06;};
void() necro_death60 = [ 233, necro_death61 ] { self.nextthink = time + 0.06; self.alpha = 1;};
void() necro_death61 = [ 234, necro_death62 ] { self.nextthink = time + 0.06;};
void() necro_death62 = [ 235, necro_death63 ] { self.nextthink = time + 0.06;};
void() necro_death63 = [ 236, necro_death64 ] { self.nextthink = time + 0.06;};
void() necro_death64 = [ 237, necro_death65 ] { self.nextthink = time + 0.06;};
void() necro_death65 = [ 238, necro_death66 ] { self.nextthink = time + 0.06;};
void() necro_death66 = [ 239, necro_death67 ] { self.nextthink = time + 0.06;};
void() necro_death67 = [ 240, necro_death68 ] { self.nextthink = time + 0.06;};
void() necro_death68 = [ 241, necro_death69 ] { self.nextthink = time + 0.06;};
void() necro_death69 = [ 242, necro_death70 ] { self.nextthink = time + 0.06;};
void() necro_death70 = [ 243, necro_death71 ] { self.nextthink = time + 0.06;};
void() necro_death71 = [ 244, necro_death72 ] { self.nextthink = time + 0.06;};
void() necro_death72 = [ 245, necro_death73 ] { self.nextthink = time + 0.06;};
void() necro_death73 = [ 246, necro_death74 ] { self.nextthink = time + 0.06;};
void() necro_death74 = [ 247, necro_death75 ] { self.nextthink = time + 0.06;};
void() necro_death75 = [ 248, necro_death76 ] { self.nextthink = time + 0.06;};
void() necro_death76 = [ 249, necro_death77 ] { self.nextthink = time + 0.06;};
void() necro_death77 = [ 250, necro_death78 ] { self.nextthink = time + 0.1;};
void() necro_death78 = [ 251, necro_death78 ]
{

	T_RadiusDamage (self, self, autocvar_necromancer_death_explosion_radius_damage, world);		// default 75	
	pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
	pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 0.7, ATTN_NORM);
	self.delete_painskin = 1;	 	 // remove painskin 

	local entity pentagram;
	pentagram = spawn ();
	pentagram.movetype = MOVETYPE_FLY;
	pentagram.solid = SOLID_TRIGGER;
	pentagram.velocity = '0 0 0.05';
	pentagram.avelocity = '0 40 0';
	pentagram.scale = 0.75;
	pentagram.touch = pentagram_touch;
	setmodel (pentagram, "progs/corpse_pent.mdl");
	setsize (pentagram, '-10 -10 -18', '10 10 40');		
	setorigin (pentagram, self.origin - '0 0 37');
	precache_sound ("zombie/penttouch.wav");
	pentagram.traileffectnum = particleeffectnum("corpse_pentagram");	
	pentagram.healamount = autocvar_necromancer_pentagram_health;		// default is 5
	pentagram.initial_amount = self.healamount;
	pentagram.nextthink = time + 0.1;
	pentagram.think = control_position_pentagram;	

	self.nextthink = time + 0.03;
	self.think = SUB_Remove;	
};



void() necro_coal_touch = 	// Necromancers falls into pieces when falling on ground
{       
	if (self.flags & FL_ONGROUND)
	{
		self.solid = SOLID_NOT;
		baked_explode();
		return;
	}
	else if(self.velocity == '0 0 0')
	{
		self.solid = SOLID_NOT;
		baked_explode();
		return;
	}
	if (self.origin == self.old_origin)		// when it got stuck somewhere. You never know...
	{
		self.solid = SOLID_NOT;
		baked_explode();
		return;
	}
	self.old_origin = self.origin;
	self.think = necro_coal_touch; 
	self.nextthink = time + 0.001;   
};

void()	necro_lightning_death =[ 185, necro_lightning_death1 ] {
	self.delete_painskin = 1;			  // remove painskin
	if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
		{
		self.movetype = MOVETYPE_NONE;
		self.velocity = '0 0 0';
		lightninggun_death_fade();
		return;
		}
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 100 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void()	necro_lightning_death1 =[ 185, necro_lightning_death1 ] {
	self.touch = necro_coal_touch;
	self.baked = 1;
	self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
};


void() necro_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			necro_lightning_death();
			return;
		}
	}

	if (autocvar_slowmotion >= 3)		// start slowmotion when regular killing living enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_wizard * 0.01))
		{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
		}
	}

	necro_death1 ();
};








/*
QUAKED monster_necromancer (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/

void() monster_necromancer =		
{
	self.classname = "monster_necromancer";
	if (deathmatch)
	{
		remove(self);
		return;
	}

/*
	precache_model ("progs/necro.mdl");		// all files precached in worldspawn() due to savegame-bug
	precache_model ("progs/necromancer_skull.mdl");	// summoned minions files for Afrit and Reiver already precached in worldspawn(), Wizard in its own function
	precache_model ("progs/necro_summon1.spr");
	precache_model ("progs/necro_summon2.spr");
	precache_sound ("necromancer/summon.wav");
	precache_sound ("necromancer/skull.wav");
	precache_sound ("necromancer/ray.wav");
	precache_sound ("necromancer/pray.wav");
	precache_sound ("necromancer/death.wav");
	precache_sound ("necromancer/idle1.wav");
	precache_sound ("necromancer/idle2.wav");
	precache_sound ("necromancer/idle3.wav");
	precache_sound ("necromancer/idle4.wav");
	precache_sound ("necromancer/idle5.wav");
	precache_sound ("necromancer/pain.wav");
	precache_sound ("necromancer/sight.wav");
*/
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/necro.mdl");

	local float zufall;
	if (autocvar_necromancer_skin == 1)	
		self.skin = 0;
	else if (autocvar_necromancer_skin == 2)
		self.skin = 1;
	else if (autocvar_necromancer_skin == 3)
		self.skin = 2;
	else	
	{
		zufall = random();
		if (zufall > 0.64)
			self.skin = 0;
		else if (zufall < 0.36)
			self.skin = 1;
		else
			self.skin = 2;
	}

	setsize (self, '-16 -16 -24', '16 16 40');
	self.scale = 1.14;				// approx. 13% bigger (nur alle 0.0625 Schritte)   entsp. ca. Z= 4  Unterschied
		
	if (!self.health)
		self.health = autocvar_necromancer_health;	// default: 150
	self.health_initial = self.health;

	self.colormod = '1 1 1';
	self.monstermodel = 0;
	self.painskin_helper = 4;				// "4" means necromancer (needed for painskin feature)
	self.alpha = autocvar_monstertransparency * 0.01;
	self.cansplash = TRUE;
	
	self.th_stand = necro_idle01;
	self.th_walk = necro_fly01;
	self.th_run = necro_run1;
	self.th_missile = necro_Missile;
	self.th_pain = necro_Pain;
	self.th_die = necro_die;

	if (autocvar_painskin_transparency)
	{
		entity pain_skin_entity;

		pain_skin_entity = spawn();
		pain_skin_entity.solid = SOLID_NOT;
		pain_skin_entity.movetype = MOVETYPE_NOCLIP;	
		pain_skin_entity.owner = self;
		setmodel (pain_skin_entity,self.model);
		setsize (pain_skin_entity, VEC_HULL2_MIN, VEC_HULL2_MAX);
		setorigin (pain_skin_entity, '0 0 0');
		pain_skin_entity.skin = self.skin;
		pain_skin_entity.colormod_x = self.colormod_x;
		pain_skin_entity.colormod_y = self.colormod_y;
		pain_skin_entity.colormod_z = self.colormod_z;
		pain_skin_entity.monstermodel = self.monstermodel;
		pain_skin_entity.frame = self.frame;	
		pain_skin_entity.alpha = autocvar_painskin_transparency;
		pain_skin_entity.think = pain_skin_entity_think;
		pain_skin_entity.nextthink = time;

		setattachment(pain_skin_entity, self, "test");	
	}

	flymonster_start ();

var float autocvar_necromancermass = 1700;
MonsterPhysics (self, autocvar_necromancermass);	
};



void() monster_necromancer_start =		// used only by supporting Necromancers (and wizard replacements)
{						
	local entity clone;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_necromancer;
	clone.nextthink = time + 0.0001;
};



