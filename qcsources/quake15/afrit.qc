/*
==============================================================================

Afrit

Model by John "Psychikon" Jensen
Some sounds are reworked Heretic/Hexen sounds 
Quake implementation by Seven
Thank you to Tea Monster for converting model into .mdl
Thank you to webangel for modifying 2nd skin
Thank you to Ruohis for gib3.mdl, which I reworked for afrit_gib.mdl

Monster properties:
Based on Wizard code
Uses 3 rapid fireball attacks that follow the player a little bit to make it more difficult to dodge.
No melee attack.
Afrit can "hide"/use cocoon shape in which he is invulnerable.
Afrit can replace and/or support all id1 monsters (except swimming ones :).

Afrit is fully adjustable.
Almost everything can be adjusted via cvars to personal likings.
Please see cvar descriptions in included smc_config.cfg sample.

==============================================================================
*/

$cd id1/models/afrit
$origin 0 0 24
$base base
$skin skin

$frame wiggle1 wiggle2 wiggle3

$frame getup1 getup2 getup3 getup4 getup5 getup6 getup7 getup8 getup9 getup10
$frame getup11 getup12 getup13 getup14 getup15 getup16 getup17 getup18 getup19 getup20

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14 fly15 fly16

$frame paina1 paina2 paina3 paina4 paina5 paina6

$frame painb1 painb2 painb3

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 attack9 attack10
$frame attack11 attack12 attack13

$frame die1 die2 die3 die4


void() afrit_run1;
void() afrit_side1;

/*
=================
AfritCheckAttack
=================
*/
float()	AfritCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float	chance;

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			afrit_run1 ();
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
			afrit_run1 ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.6;
	else if (enemy_range == RANGE_MID)
		chance = 0.2;
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
			afrit_run1 ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			afrit_side1 ();
		}
	}
	
	return FALSE;
};

/*
=================
AfritAttackFinished
=================
*/
float()	AfritAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = afrit_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = afrit_side1;
	}
};


/*
==============================================================================
Rapid fireball attacks
==============================================================================
*/

void() spike_afrit_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (autocvar_afrit_fireball_damage);
		T_Damage (other, self, self.owner, autocvar_afrit_fireball_damage);
		if (autocvar_afrit_projectiles_inflame_chance)
		{
			local float zufal;
			zufal = random() * 100;
			if (zufal <= autocvar_afrit_projectiles_inflame_chance)		// checks if afrits projectile impact inflame the player
			{
				other.inflamed = 1;
				other.inflametime = time + autocvar_fire_projectiles_and_lava_inflame_time;		// max total time of fire hurting the player
				other.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence;  	// to avoid more damage from projectile
				stuffcmd (self, "bf\n"); //Q1 screen effect
				if (autocvar_fire_projectiles_and_lava_inflame_particles)
				{
					sound7 (other, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM, SNDSPD); 		// play ignition sound
					sound7 (other, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM, SNDSPD); 	       	// play fire loop sound
				}
			}
		}
	}
	else
	{
		if (self.owner.skin)
			pointparticles(particleeffectnum("TE_AFRITSPIKE_GREY"), self.origin, '0 0 0', 1);
		else
			pointparticles(particleeffectnum("TE_AFRITSPIKE_RED"), self.origin, '0 0 0', 1);
		sound7 (self, CHAN_WEAPON, "afrit/fireballtouch.wav", 0.6, ATTN_NORM, SNDSPD);
	}
	
	remove(self);
};


void(vector org, vector dir) launch_afrit_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_afrit_touch; 
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};


void() Afrit_RapidFire =
{
	local vector	vec, dst, follow;

	if (self.owner.health > 0)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;

		makevectors (self.enemy.angles);	
		follow = self.enemy.velocity*0.3;		// "guess" players future position to make it harder to dodge
		follow_z = 0;	
		dst = (self.enemy.origin + follow) - 13*self.movedir;
	
		vec = normalize(dst - self.origin);
		sound7 (self, CHAN_WEAPON, "afrit/attack.wav", 1, ATTN_NORM, SNDSPD);
		launch_afrit_spike (self.origin, vec);
		newmis.velocity = vec*600;
		newmis.owner = self.owner;
		newmis.classname = "afritspike";
		//newmis.alpha = 0.6;
		setmodel (newmis, "progs/k_spike.mdl");
		if (self.owner.skin)
			newmis.traileffectnum = particleeffectnum("TR_AFRITSPIKE_GREY");
		else
			newmis.traileffectnum = particleeffectnum("TR_AFRITSPIKE_RED");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	}

	remove (self);
};


void() Afrit_StartRapidFire =
{
	local	entity	missile;
	self.v_angle = self.angles;
	makevectors (self.angles);

	missile = spawn ();		// fireball 3
	missile.owner = self;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 13' + v_forward*10);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.61;
	missile.think = Afrit_RapidFire;
	missile.movedir = VEC_ORIGIN;

	missile = spawn ();		// fireball 2
	missile.owner = self;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 13' + v_forward*10);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.43;
	missile.think = Afrit_RapidFire;
	missile.movedir = VEC_ORIGIN;

	missile = spawn ();		// fireball 1
	missile.owner = self;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 13' + v_forward*10);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.25;
	missile.think = Afrit_RapidFire;
	missile.movedir = VEC_ORIGIN;
};



void()	afrit_stand1	=[	$fly1,		afrit_stand2	] {ai_stand();self.nextthink = time + 0.07;
if (random() < 0.2)
	 sound7 (self, CHAN_VOICE, "afrit/idle.wav", 1,  ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand2	=[	$fly2,		afrit_stand3	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand3	=[	$fly3,		afrit_stand4	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand4	=[	$fly4,		afrit_stand5	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand5	=[	$fly5,		afrit_stand6	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand6	=[	$fly6,		afrit_stand7	] {ai_stand();self.nextthink = time + 0.07;sound7 (self, CHAN_VOICE, "afrit/wingsflap.wav", 0.9, ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand7	=[	$fly7,		afrit_stand8	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand8	=[	$fly8,		afrit_stand9	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand9	=[	$fly9,		afrit_stand10	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand10	=[	$fly10,	afrit_stand11	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand11	=[	$fly11,	afrit_stand12	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand12	=[	$fly12,	afrit_stand13	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand13	=[	$fly13,	afrit_stand14	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand14	=[	$fly14,	afrit_stand15	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand15	=[	$fly15,	afrit_stand16	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_stand16	=[	$fly16,	afrit_stand1	] {ai_stand();self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_idle_grey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_idle_red"), self.origin, '0 0 0', 1); 
	}
};


void(entity attacker, float damage) afrit_Pain_dummy;
void(entity attacker, float damage) afrit_Pain;

void()	afrit_change_shape1	=[	$getup1,	afrit_change_shape2	] {self.nextthink = time + 0.1;
sound7 (self, CHAN_AUTO, "afrit/awake.wav", 1,  ATTN_NORM, SNDSPD);
self.takedamage = DAMAGE_NO;		// while transforming from cocoon shape, afrit is invulnerable
self.th_pain = afrit_Pain;};		// use real pain animation next time he gets hit (when DAMAGE_AIM is given in frame 18)
void()	afrit_change_shape2	=[	$getup2,	afrit_change_shape3	] {self.nextthink = time + 0.1;};
void()	afrit_change_shape3	=[	$getup3,	afrit_change_shape4	] {self.nextthink = time + 0.1;};
void()	afrit_change_shape4	=[	$getup4,	afrit_change_shape5	] {self.nextthink = time + 0.1;};
void()	afrit_change_shape5	=[	$getup5,	afrit_change_shape6	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape6	=[	$getup6,	afrit_change_shape7	] {self.nextthink = time + 0.07;
self.traileffectnum = particleeffectnum("monsternull");};	// stop the heavy fire from cocoon
void()	afrit_change_shape7	=[	$getup7,	afrit_change_shape8	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape8	=[	$getup8,	afrit_change_shape9	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape9	=[	$getup9,	afrit_change_shape10	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape10	=[	$getup10,	afrit_change_shape11	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape11	=[	$getup11,	afrit_change_shape12	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape12	=[	$getup12,	afrit_change_shape13	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape13	=[	$getup13,	afrit_change_shape14	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape14	=[	$getup14,	afrit_change_shape15	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape15	=[	$getup15,	afrit_change_shape16	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape16	=[	$getup16,	afrit_change_shape17	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape17	=[	$getup17,	afrit_change_shape18	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape18	=[	$getup18,	afrit_change_shape19	] {self.nextthink = time + 0.07;
	self.takedamage = DAMAGE_AIM;};	// stop afrits invulnerability
void()	afrit_change_shape19	=[	$getup19,	afrit_change_shape20	] {self.nextthink = time + 0.07;};
void()	afrit_change_shape20	=[	$getup20,	afrit_run1		] {self.nextthink = time + 0.07;
	self.attack_finished = time + 1;	// do not attack at once, fly a bit first.
	self.th_run = afrit_run1;
        self.th_stand = afrit_stand1;
	self.origin_z = self.origin_z + 7;	// lift him up a bit
};


void()	afrit_use_cocoon1	=[	$wiggle1,	afrit_use_cocoon2	] {ai_stand();self.nextthink = time + 0.1 + random()*0.35;};
void()	afrit_use_cocoon2	=[	$wiggle2,	afrit_use_cocoon3	] {ai_stand();self.nextthink = time + 0.1 + random()*0.35;};
void()	afrit_use_cocoon3	=[	$wiggle3,	afrit_use_cocoon1	] {ai_stand();self.nextthink = time + 0.1 + random()*0.4;
	self.th_run = afrit_change_shape1;
	self.th_pain = afrit_Pain_dummy;	// dont go into real pain animation yet, first transform into Afrit !
	self.in_cocoon_shape = 1;		// needed to make cocoon react to attacks, but invulnerable (see combat.qc T-Damage() for details)
	if (self.skin)
		self.traileffectnum = particleeffectnum("Afrit_cocoon_grey");
	else
		self.traileffectnum = particleeffectnum("Afrit_cocoon_red");
};


void()	afrit_stand_random =		// Afrit can either fly on 1 spot (idling), or use hides inside his cocoon (invulnerable)
{			
	local float cocoonchance;		
	cocoonchance = autocvar_afrit_waits_in_cocoon * 0.01;
	if (random() < cocoonchance)
		self.think = afrit_use_cocoon1;		// Use cocoon shape while idling
	else
		self.think = afrit_stand1;		// regular flying while idling
	self.nextthink = time + 0.4;			// time delay is necessary due to original Quake monster spawn process
};



void()	afrit_walk1	=[	$fly1,		afrit_walk2	] {ai_walk(6);self.nextthink = time + 0.07;
if (random() < 0.2)
	 sound7 (self, CHAN_VOICE, "afrit/idle.wav", 1,  ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk2	=[	$fly2,		afrit_walk3	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk3	=[	$fly3,		afrit_walk4	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk4	=[	$fly4,		afrit_walk5	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk5	=[	$fly5,		afrit_walk6	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk6	=[	$fly6,		afrit_walk7	] {ai_walk(6);self.nextthink = time + 0.07;sound7 (self, CHAN_VOICE, "afrit/wingsflap.wav", 0.9, ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk7	=[	$fly7,		afrit_walk8	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk8	=[	$fly8,		afrit_walk9	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk9	=[	$fly9,		afrit_walk10	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk10	=[	$fly10,	afrit_walk11	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk11	=[	$fly11,	afrit_walk12	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk12	=[	$fly12,	afrit_walk13	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk13	=[	$fly13,	afrit_walk14	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk14	=[	$fly14,	afrit_walk15	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk15	=[	$fly15,	afrit_walk16	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_walk16	=[	$fly16,	afrit_walk1	] {ai_walk(6);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};


void()	afrit_side1	=[	$fly1,		afrit_side2	] {ai_run(8);self.nextthink = time + 0.07;
if (random() < 0.2)
	 sound7 (self, CHAN_VOICE, "afrit/idle.wav", 1,  ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side2	=[	$fly2,		afrit_side3	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side3	=[	$fly3,		afrit_side4	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side4	=[	$fly4,		afrit_side5	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side5	=[	$fly5,		afrit_side6	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side6	=[	$fly6,		afrit_side7	] {ai_run(8);self.nextthink = time + 0.07;sound7 (self, CHAN_VOICE, "afrit/wingsflap.wav", 0.9, ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side7	=[	$fly7,		afrit_side8	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side8	=[	$fly8,		afrit_side9	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side9	=[	$fly9,		afrit_side10	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side10	=[	$fly10,	afrit_side11	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side11	=[	$fly11,	afrit_side12	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side12	=[	$fly12,	afrit_side13	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side13	=[	$fly13,	afrit_side14	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side14	=[	$fly14,	afrit_side15	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side15	=[	$fly15,	afrit_side16	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_side16	=[	$fly16,	afrit_side1	] {ai_run(8);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};


void()	afrit_run1	=[	$fly1,		afrit_run2	] {ai_run(16);self.nextthink = time + 0.07;
if (random() < 0.2)
	 sound7 (self, CHAN_VOICE, "afrit/idle.wav", 1,  ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run2	=[	$fly2,		afrit_run3	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run3	=[	$fly3,		afrit_run4	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run4	=[	$fly4,		afrit_run5	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run5	=[	$fly5,		afrit_run6	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run6	=[	$fly6,		afrit_run7	] {ai_run(16);self.nextthink = time + 0.07;sound7 (self, CHAN_VOICE, "afrit/wingsflap.wav", 0.9, ATTN_IDLE, SNDSPD);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run7	=[	$fly7,		afrit_run8	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run8	=[	$fly8,		afrit_run9	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run9	=[	$fly9,		afrit_run10	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run10	=[	$fly10,	afrit_run11	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run11	=[	$fly11,	afrit_run12	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run12	=[	$fly12,	afrit_run13	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run13	=[	$fly13,	afrit_run14	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run14	=[	$fly14,	afrit_run15	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run15	=[	$fly15,	afrit_run16	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_run16	=[	$fly16,	afrit_run1	] {ai_run(16);self.nextthink = time + 0.07;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};


void()	afrit_fast1	=[	$attack1,	afrit_fast2	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast2	=[	$attack2,	afrit_fast3	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast3	=[	$attack3,	afrit_fast4	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast4	=[	$attack4,	afrit_fast5	] {ai_face();Afrit_StartRapidFire();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast5	=[	$attack5,	afrit_fast6	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast6	=[	$attack6,	afrit_fast7	] {ai_face();self.nextthink = time + 0.17;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast7	=[	$attack7,	afrit_fast8	] {ai_face();self.nextthink = time + 0.16;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast8	=[	$attack8,	afrit_fast9	] {ai_face();self.nextthink = time + 0.13;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast9	=[	$attack9,	afrit_fast10	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast10	=[	$attack10,	afrit_fast11	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast11	=[	$attack11,	afrit_fast12	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast12	=[	$attack12,	afrit_fast13	] {ai_face();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_fast13	=[	$attack13,	afrit_run1	] {ai_face();SUB_AttackFinished (1+random());AfritAttackFinished ();
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};


void()	afrit_paina1	=[	$paina1,	afrit_paina2	] {self.nextthink = time + 0.12;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_paina2	=[	$paina2,	afrit_paina3	] {self.nextthink = time + 0.12;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_paina3	=[	$paina3,	afrit_paina4	] {self.nextthink = time + 0.12;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_paina4	=[	$paina4,	afrit_paina5	] {self.nextthink = time + 0.12;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_paina5	=[	$paina5,	afrit_paina6	] {self.nextthink = time + 0.12;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_paina6	=[	$paina6,	afrit_run1	] {self.nextthink = time + 0.12;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};


void()	afrit_painb1	=[	$painb1,	afrit_painb2	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_painb2	=[	$painb2,	afrit_painb3	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_painb3	=[	$painb3,	afrit_run1	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};


void(entity attacker, float damage) afrit_Pain =
{
	self.in_cocoon_shape = 0;	// remove invulnerability from cocoon shape
	if (random()*70 > damage)
		return;		// didn't flinch

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_afrit * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	if (random() > 0.37)
		{
		sound7 (self, CHAN_AUTO, "afrit/pain1.wav", 1, ATTN_NORM, SNDSPD);
		afrit_paina1 ();
		}
	else
		{
		sound7 (self, CHAN_AUTO, "afrit/pain2.wav", 1, ATTN_NORM, SNDSPD);
		afrit_painb1 ();
		}
};


void(entity attacker, float damage) afrit_Pain_dummy =
{
	self.in_cocoon_shape = 0;	// remove invulnerability from cocoon shape
	return;
};



var float autocvar_afritcorpsehealth = 60;	// set cvar 'afritcorpsehealth' default to 60
var float autocvar_afritcorpseburnable = 1;	// set cvar 'afritcorpseburnable' default to 1

void()	afrit_deatha1	=[	$die1,		afrit_deatha2	] {self.nextthink = time + 0.15;
self.velocity_x = -170 + 340*random();
self.velocity_y = -170 + 340*random();
self.velocity_z = 75 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha2	=[	$die2,		afrit_deatha3	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha3	=[	$die3,		afrit_deatha4	]{self.solid = SOLID_NOT;self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha4	=[	$die4,		afrit_deatha5	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha5	=[	$die4,		afrit_deatha6	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha6	=[	$die4,		afrit_deatha7	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha7	=[	$die4,		afrit_deatha8	] {self.nextthink = time + 0.15;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deatha8	=[	$die4,		afrit_deatha8	] {self.nextthink = time + 0.15;
if (autocvar_afritcorpseburnable == 1)		// corpses are burnable
	self.burnable_corpse = 1;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
self.delete_painskin = 1;		 	// remove painskin
CopyMonsterToBodyQue(autocvar_afritcorpsehealth, "progs/h_afrit.mdl");
};


void()	afrit_deathb1	=[	$die1,		afrit_deathb2	] {self.nextthink = time + 0.1;
self.velocity_x = -170 + 340*random();
self.velocity_y = -170 + 340*random();
self.velocity_z = 75 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deathb2	=[	$die2,		afrit_deathb3	] {self.nextthink = time + 0.1;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deathb3	=[	$die3,		afrit_deathb4	]{self.solid = SOLID_NOT;self.nextthink = time + 0.1;
if ( self.afrit_on_fire == 1 )
	{
	if (self.skin)
		pointparticles(particleeffectnum("Afrit_flygrey"), self.origin, '0 0 0', 1); 
	else
		pointparticles(particleeffectnum("Afrit_flyred"), self.origin, '0 0 0', 1); 
	}
};
void()	afrit_deathb4	=[	$die4,		afrit_deathb4	] {self.nextthink = time + 0.1;
sound7 (self, CHAN_AUTO, "afrit/body_explode.wav", 0.8, ATTN_NORM, SNDSPD);	// FIXME better sound
self.delete_painskin = 1;		 	// remove painskin
if (!self.skin)
	pointparticles(particleeffectnum("Afrit_death_explode"), self.origin, '0 0 0', 1); 
local vector v, v2;
if (self.skin)
{
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_gargwing2.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 1);
}
else
{
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_gargwing2.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
	v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowAfritGibs (v, v2, "progs/gib_afrit.mdl", 0);
}
v = randompos(self.mins, self.maxs) + self.origin; v2 = randomvec() * 275; ThrowHead ("progs/h_afrit.mdl", self.health);
return;
};


void() afrit_coal_touch = 	// afrits fall into pieces when falling on ground
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
self.think = afrit_coal_touch; 
self.nextthink = time + 0.001;   
};

void()	afrit_lightning_death	=[	$paina3,	afrit_lightning_death1	] {
self.delete_painskin = 1;		 	  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	lightninggun_death_fade();
	return;
	}
self.velocity_x = -170 + 340*random();
self.velocity_y = -170 + 340*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void()	afrit_lightning_death1	=[	$paina3,	afrit_lightning_death1	] {
self.touch = afrit_coal_touch;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
};


void() gib_afrit =
{
	sound7 (self, CHAN_VOICE, "afrit/body_explode.wav", 1, ATTN_NORM, SNDSPD);	// FIXME better sound
	self.delete_painskin = 1;
			 	// remove painskin
	ThrowGib ("progs/gib_gargwing2.mdl", self.health);
	ThrowGib ("progs/gib_gargwing2.mdl", self.health);
	ThrowGib ("progs/chop.mdl", self.health);
	ThrowGib ("progs/chop.mdl", self.health);
	ThrowGib ("progs/chop.mdl", self.health);
	ThrowGib ("progs/chop.mdl", self.health);

	ThrowHead ("progs/h_afrit.mdl", self.health);
	return;
}

void() afrit_die =
{
// Flush every sound channel to kill gun buzzing sound
	sound7(self, CHAN_WEAPON, SOUND_EMPTY, 1, ATTN_NORM);
	sound7(self, CHAN_VOICE, SOUND_EMPTY, 1, ATTN_NORM);
	sound7(self, CHAN_ITEM, SOUND_EMPTY, 1, ATTN_NORM);
	sound7(self, CHAN_AUTO, SOUND_EMPTY, 1, ATTN_NORM);
	sound7(self, CHAN_AUTO, SOUND_EMPTY, 1, ATTN_NORM);
	sound7(self, CHAN_AUTO, SOUND_EMPTY, 1, ATTN_NORM);
if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
	if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))		// when enemy was killed with lightning gun, go into baked mode
		{
		afrit_lightning_death();
		return;
		}
	}
	else 
	{
		if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
		{
			lg_death1();
			return;
		}		
	}

// check for gib
	if (self.health < -40)
	{
		
		//5 randomized blood droplets that drip if stuck to the ceiling
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		
		if (self.enemy.weapon == IT_LASER_CANNON)
			gibdeath_effects();
		
		self.delete_painskin = 1; 	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_afrit * 0.01))
				{
				the_matrix = 1;
				SNDSPD = 70;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		gib_afrit();
		return;
	}

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_afrit * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound7 (self, CHAN_VOICE, "afrit/death.wav", 1, ATTN_NORM, SNDSPD);

	var float autocvar_afrit_grey_death_style = 100;	// set cvar 'afrit_grey_death_style' default to 100.  Choose which death style you want for the GREY Afrit. Examples: "0"= always use death style A.  "100"= always use death style B.   "50"= use both death styles A and B randomly (50/50 %).  "75"= 75% chance to use death style B and 25% to use death style A
	//if (self.skin)
	//{
		local float zufal;
		zufal = autocvar_afrit_grey_death_style * 0.01;
		if (random() <= zufal)
			afrit_deathb1 ();
		else
			afrit_deatha1 ();
	//}
	//else
		//afrit_deathb1 ();
};


/*QUAKED monster_afrit (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/

void() monster_afrit =			// used only by supporting Afrits (and wizard replacments)
{
self.classname = "monster_afrit";
	if (deathmatch)
	{
		remove(self);
		return;
	}
/*	precache_model ("progs/afrit.mdl");	// all files precached in worldspawn() due to savegame-bug
	precache_model ("progs/h_afrit.mdl");
	precache_model ("progs/gib_afrit.mdl");
	precache_model ("progs/k_spike.mdl");

	precache_sound ("afrit/attack.wav");
	precache_sound ("afrit/awake.wav");
	precache_sound ("afrit/death.wav");
	precache_sound ("afrit/body_explode.wav");
	precache_sound ("afrit/idle.wav");
	precache_sound ("afrit/pain1.wav");
	precache_sound ("afrit/pain2.wav");
	precache_sound ("afrit/sight.wav");
	precache_sound ("afrit/wingsflap.wav");
	precache_sound ("afrit/fireballtouch.wav");
*/
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/afrit.mdl");

	var float autocvar_afrit_multiskin = 35;	// set cvar 'afrit_multiskin' default to 35.  Select chance for 2 available skins. Examples: "0"= always use skin 1.  "100"= always use skin 2.   "50"= use both skins 1 and 2 randomly (50/50 %).  "75"= 75% chance to use skin 2 and 25% to use skin 1
	local float zufal;
	zufal = autocvar_afrit_multiskin * 0.01;
	if (random() <= zufal)
		self.skin = 1;
	else
		self.skin = 0;

	self.monstermodel = 0;

	setsize (self, '-16 -16 -24', '16 16 24');
	if (!self.health)
		self.health = autocvar_afrit_health;		// default: 120
	self.health_initial = self.health;

	self.colormod = '1 1 1';
	self.scale = 1;

	self.th_stand = afrit_stand1;
	self.th_walk = afrit_walk1;
	self.th_run = afrit_run1;
	self.th_missile = afrit_fast1;
	self.th_melee = SUB_Null;		
	self.th_pain = afrit_Pain;
	self.th_die = afrit_die;

	var float autocvar_afrit_burning = 100;		// set cvar 'afrit_burning' default to 100 (= 100%).  Set your percentage how many afrits shall be surrounded by particle flames. (100= always; 0= never)
	local float zufall;
	zufall = autocvar_afrit_burning * 0.01;
	if (random() <= zufall)
		self.afrit_on_fire = 1;

	self.alpha = autocvar_monstertransparency * 0.01;

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

var float autocvar_afritmass = 1700;
MonsterPhysics (self, autocvar_afritmass);	
};

void() monster_minotaurminion =
{
	self.classname = "monster_afrit";
	monster_afrit();
}

void() monster_gargoyle =
{
	self.classname = "monster_afrit";
	monster_afrit();
}


void() monster_afrit_liftorigin =	// used only by replacing Afrits
{
self.classname = "monster_afrit";
	if (deathmatch)
	{
		remove(self);
		return;
	}
/*	precache_model ("progs/afrit.mdl");	// all files precached in worldspawn() due to savegame-bug
	precache_model ("progs/h_afrit.mdl");
	precache_model ("progs/gib_afrit.mdl");
	precache_model ("progs/k_spike.mdl");

	precache_sound ("afrit/attack.wav");
	precache_sound ("afrit/awake.wav");
	precache_sound ("afrit/death.wav");
	precache_sound ("afrit/body_explode.wav");
	precache_sound ("afrit/idle.wav");
	precache_sound ("afrit/pain1.wav");
	precache_sound ("afrit/pain2.wav");
	precache_sound ("afrit/sight.wav");
	precache_sound ("afrit/wingsflap.wav");
	precache_sound ("afrit/fireballtouch.wav");
*/
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

self.origin_z = self.origin_z + 18;		// Lift Afrit´s up a bit due to model size, bbox and animation (compared to walking monsters)

	setmodel (self, "progs/afrit.mdl");

	var float autocvar_afrit_multiskin = 35;	// set cvar 'afrit_multiskin' default to 35.  Select chance for 2 available skins. Examples: "0"= always use skin 1.  "100"= always use skin 2.   "50"= use both skins 1 and 2 randomly (50/50 %).  "75"= 75% chance to use skin 2 and 25% to use skin 1
	local float zufal;
	zufal = autocvar_afrit_multiskin * 0.01;
	if (random() <= zufal)
		self.skin = 1;
	else
		self.skin = 0;

	self.monstermodel = 0;

	setsize (self, '-16 -16 -24', '16 16 24');
	if (!self.health)
		self.health = autocvar_afrit_health;		// default: 120
	self.health_initial = self.health;

	self.colormod = '1 1 1';
	self.scale = 1;

	self.th_stand = afrit_stand_random;	// only Afrit´s, that do NOT support other monsters may go into cocoon shape
	self.th_walk = afrit_walk1;
	self.th_run = afrit_run1;
	self.th_missile = afrit_fast1;
	self.th_melee = SUB_Null;		
	self.th_pain = afrit_Pain;
	self.th_die = afrit_die;

	var float autocvar_afrit_burning = 100;		// set cvar 'afrit_burning' default to 100 (= 100%).  Set your percentage how many afrits shall be surrounded by particle flames. (100= always; 0= never)
	local float zufall;
	zufall = autocvar_afrit_burning * 0.01;
	if (random() <= zufall)
		self.afrit_on_fire = 1;

	self.alpha = autocvar_monstertransparency * 0.01;

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

var float autocvar_afritmass = 1700;
MonsterPhysics (self, autocvar_afritmass);	
};


void() monster_afrit_start =			// used only by supporting Afrits (and wizard replacements)
{
	local entity clone;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_afrit;
	clone.nextthink = time + 0.0001;
};

void() monster_afrit_liftorigin_start =		// used only by replacing Afrits
{
	local entity clone;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_afrit_liftorigin;
	clone.nextthink = time + 0.0001;
};



//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//    Code for adding  ADDITIONAL  Afrit monster into a map to support FLYING monsters
//    Afrit will be spawned near the flying monster
//////////////////////////////////////////////////////////////////////////////////////

void() add_afrit_support_fly =
{
   local entity clone, head;
   local float done, c, proceed;
   local vector ang, pos;

   done = 0;
   c = 0;
   ang = self.angles;
   while (done == 0)
      {
      makevectors(ang);
      pos = self.origin + (60 * v_forward) + (crandom() * 33 *v_right) + (crandom() * 30 *v_up);	// randomize the spawn position !!
      head = findradius(pos, 35);
      proceed = 1;
      while (head)
         {
         if ((head.health > 0) && (head.flags & (FL_MONSTER | FL_CLIENT)))
            proceed = 0;
         head = head.chain;
         }
      traceline(self.origin,pos,FALSE,self);
      if (trace_fraction == 1 && (proceed == 1))
         {
         traceline(self.origin,(pos-'40 40 0'),FALSE,self);
         if (trace_fraction == 1)
            {
            traceline(self.origin,(pos+'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
               {
                  done = 1;
               }
            }
         }
      if (done == 0)
         {
         ang_y = ang_y + 36;
         c = c + 1;
         if (c==10)
            {
            return;
            }
         }
      }
      
clone = spawn();
copyentity (self,clone);
setorigin(clone, pos);

clone.think = monster_afrit;
clone.nextthink = time + 0.0001;	
};




////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
//    Code for adding  ADDITIONAL  Afrit monster into a map to support WALKING monsters
//    Afrit will be spawned near the walking monster but a little bit higher
////////////////////////////////////////////////////////////////////////////////////////

void() add_afrit_support_walk =
{
   local entity clone, head;
   local float done, c, proceed;
   local vector ang, pos;

   done = 0;
   c = 0;
   ang = self.angles;
   while (done == 0)
      {
      makevectors(ang);
      pos = self.origin + (60 * v_forward) + (crandom() * 33 *v_right) + (45 *v_up);	// randomize the spawn position and LIFT Afrit up !!
      head = findradius(pos, 35);
      proceed = 1;
      while (head)
         {
         if ((head.health > 0) && (head.flags & (FL_MONSTER | FL_CLIENT)))
            proceed = 0;
         head = head.chain;
         }
      traceline(self.origin,pos,FALSE,self);
      if (trace_fraction == 1 && (proceed == 1))
         {
         traceline(self.origin,(pos-'40 40 0'),FALSE,self);
         if (trace_fraction == 1)
            {
            traceline(self.origin,(pos+'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
               {
               traceline(self.origin,(pos + '0 0 40'),FALSE,self);
               if (trace_fraction == 1)
                  {
                  traceline(self.origin,(pos - '0 0 80'),FALSE,self);
                  if (trace_fraction != 1)
                     {
	                done = 1;
                     }
                  }
               }
            }
         }
      if (done == 0)
         {
         ang_y = ang_y + 36;
         c = c + 1;
         if (c==10)
            {
            return;
            }
         }
      }
clone = spawn();
copyentity (self,clone);
setorigin(clone, pos);

clone.think = monster_afrit;
clone.nextthink = time + 0.0001;	
};

 