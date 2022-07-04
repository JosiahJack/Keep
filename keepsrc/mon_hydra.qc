/*
==============================================================================

Hydra

Model from Hexen2 (with reworked animations for Quake)
Quake implementation by Seven

Monster properties:
1 melee attack
1 ranged attack: Spits out toxic tint that paralyzes the player and makes him blind for a short (adjustable) time
Adjustable replacement monster for the Quake�s fish monsters (via cvar)
Originally designed exclusively for DarkPlaces.
==============================================================================
*/

$cd id1/models/hydra
$origin 0 0 24
$base base		
$skin skin

void(string action, float value) ai_fish_movement;

$frame attack1 attack2 attack3 attack4 attack5 attack6 
$frame attack7 attack8 attack9 attack10 attack11 attack12 attack13 
$frame attack14 attack15 attack16 attack17 attack18 attack19
$frame attack20 attack21 attack22 attack23 attack24 

$frame death1 death2 death3 death4 death5 death6 death7 
$frame death8 death9 death10 death11 death12 death13 death14 death15 
$frame death16 death17 death18 death19 death20 death21 

$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8 
$frame swim9 swim10 swim11 swim12 swim13 swim14 swim15 swim16 swim17 
$frame swim18 

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 
$frame pain9 

$frame hspit1 hspit2 hspit3 hspit4 hspit5 hspit6 hspit7 hspit8 
$frame hspit9 hspit10 hspit11 hspit12

void() hydra_stand1  =[      $swim1, hydra_stand2 ] {ai_stand();monster_idle_sound();};
void() hydra_stand2  =[      $swim2, hydra_stand3 ] {ai_stand();};
void() hydra_stand3  =[      $swim3, hydra_stand4 ] {ai_stand();};
void() hydra_stand4  =[      $swim4, hydra_stand5 ] {ai_stand();};
void() hydra_stand5  =[      $swim5, hydra_stand6 ] {ai_stand();};
void() hydra_stand6  =[      $swim6, hydra_stand7 ] {ai_stand();};
void() hydra_stand7  =[      $swim7, hydra_stand8 ] {ai_stand();};
void() hydra_stand8  =[      $swim8, hydra_stand9 ] {ai_stand();};
void() hydra_stand9  =[      $swim9, hydra_stand10  ] {ai_stand();};
void() hydra_stand10 =[      $swim10, hydra_stand11 ] {ai_stand();};
void() hydra_stand11 =[      $swim11, hydra_stand12 ] {ai_stand();};
void() hydra_stand12 =[      $swim12, hydra_stand13 ] {ai_stand();};
void() hydra_stand13 =[      $swim13, hydra_stand14 ] {ai_stand();};
void() hydra_stand14 =[      $swim14, hydra_stand15 ] {ai_stand();};
void() hydra_stand15 =[      $swim15, hydra_stand16 ] {ai_stand();};
void() hydra_stand16 =[      $swim16, hydra_stand17 ] {ai_stand();};
void() hydra_stand17 =[      $swim17, hydra_stand18 ] {ai_stand();};
void() hydra_stand18 =[      $swim18, hydra_stand1 ] {ai_stand();};


void() hydra_walk1  =[      $swim1, hydra_walk2 ] {ai_walk(20);monster_idle_sound();};
void() hydra_walk2  =[      $swim2, hydra_walk3 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk3  =[      $swim3, hydra_walk4 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk4  =[      $swim4, hydra_walk5 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk5  =[      $swim5, hydra_walk6 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk6  =[      $swim6, hydra_walk7 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk7  =[      $swim7, hydra_walk8 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk8  =[      $swim8, hydra_walk9 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk9  =[      $swim9, hydra_walk10  ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk10 =[      $swim10, hydra_walk11 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk11 =[      $swim11, hydra_walk12 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk12 =[      $swim12, hydra_walk13 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk13 =[      $swim13, hydra_walk14 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk14 =[      $swim14, hydra_walk15 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk15 =[      $swim15, hydra_walk16 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk16 =[      $swim16, hydra_walk17 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk17 =[      $swim17, hydra_walk18 ] {ai_fish_movement("ai_walk",12);};
void() hydra_walk18 =[      $swim18, hydra_walk1 ] {ai_fish_movement("ai_walk",12);};


void() hydra_run1  =[      $swim1, hydra_run2 ] 
{
	// Swim faster after player is paralyzed (khreathor)
	if (self.aflag > time)
		self.speed = 32;
	else
		self.speed = 24;
	
	ai_fish_movement("ai_run",self.speed);
	monster_idle_sound();
};
void() hydra_run2  =[      $swim3, hydra_run3 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run3  =[      $swim5, hydra_run4 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run4  =[      $swim7, hydra_run5 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run5  =[      $swim9, hydra_run6 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run6  =[      $swim11, hydra_run7 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run7  =[      $swim13, hydra_run8 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run8  =[      $swim15, hydra_run9 ] {ai_fish_movement("ai_run",self.speed);};
void() hydra_run9  =[      $swim17, hydra_run1 ] {ai_fish_movement("ai_run",self.speed);};


void() hydra_melee = {
	local vector	delta;
	local float 	ldmg;

	ai_fish_movement("ai_charge",16);
	
	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	// distance changed from 60 to 80 (khreathor)
	if (vlen(delta) > 80)
		return;
		
	sound (self, CHAN_VOICE, "extras_r5/hydra/hydra_tent.wav", 1, ATTN_NORM);
	//var float autocvar_hydra_tentacle = 4;				// set damage value of Hydra�s tentacle attacks
	ldmg = (random() + random()) * 4;		// default 4
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
};


void() hydra_attack1        =[      $attack1,       hydra_attack2 ] {ai_fish_movement("ai_charge",16);};
void() hydra_attack2        =[      $attack2,       hydra_attack3 ] {ai_fish_movement("ai_charge",16);};
void() hydra_attack3        =[      $attack3,       hydra_attack4 ] {ai_fish_movement("ai_charge",16);};	
void() hydra_attack4        =[      $attack4,       hydra_attack5 ] {ai_fish_movement("ai_charge",16);};
void() hydra_attack5        =[      $attack5,       hydra_attack6 ] {ai_fish_movement("ai_charge",16);};
void() hydra_attack6        =[      $attack6,       hydra_attack7 ] {hydra_melee();};	// one for each tentacle
void() hydra_attack7        =[      $attack7,       hydra_attack8 ] {ai_fish_movement("ai_charge",16);};
void() hydra_attack8        =[      $attack8,       hydra_attack9 ] {ai_fish_movement("ai_charge",16);};
void() hydra_attack9        =[      $attack9,       hydra_attack10] {ai_fish_movement("ai_charge",16);};
void() hydra_attack10       =[      $attack10,      hydra_attack11] {hydra_melee();};	// one for each tentacle
void() hydra_attack11       =[      $attack11,      hydra_attack12] {ai_fish_movement("ai_charge",16);};
void() hydra_attack12       =[      $attack12,      hydra_attack13] {ai_fish_movement("ai_charge",16);};
void() hydra_attack13       =[      $attack13,      hydra_attack14] {ai_fish_movement("ai_charge",16);};
void() hydra_attack14       =[      $attack14,      hydra_attack15] {hydra_melee();};	// one for each tentacle
void() hydra_attack15       =[      $attack15,      hydra_attack16] {ai_fish_movement("ai_charge",16);};
void() hydra_attack16       =[      $attack16,      hydra_attack17] {ai_fish_movement("ai_charge",16);};
void() hydra_attack17       =[      $attack17,      hydra_attack18] {ai_fish_movement("ai_charge",16);};
void() hydra_attack18       =[      $attack18,      hydra_attack19] {ai_fish_movement("ai_charge",16);};
void() hydra_attack19       =[      $attack19,      hydra_attack20] {ai_fish_movement("ai_charge",16);};
void() hydra_attack20       =[      $attack20,      hydra_attack21] {ai_fish_movement("ai_charge",16);};
void() hydra_attack21       =[      $attack21,      hydra_attack22] {ai_fish_movement("ai_charge",16);};
void() hydra_attack22       =[      $attack22,      hydra_attack23] {hydra_melee();};	// one for each tentacle
void() hydra_attack23       =[      $attack23,      hydra_attack24] {ai_fish_movement("ai_charge",16);};
void() hydra_attack24       =[      $attack24,      hydra_run1] {ai_fish_movement("ai_charge",16);};


void() hydra_spit_touch = {
	if (other == self.owner)
		return;
	if (other.solid == SOLID_TRIGGER)
		return;	
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
// hit something that bleeds
	if (other.takedamage) {
		if (other.classname == "player") {
			self.owner.aflag = time + 5;
			other.slowdowntime = time + 3;	//	we slowdown player instead of pausing him (khreathor)
			//other.pausetime = time + 2;	// player cannot walk and see during this time
			spawn_touchblood (self, other, 7);
			T_Damage (other, self, self.owner, 7, DAMARMOR);	// default 7
			sound (self, CHAN_WEAPON, "extras_r5/hydra/spit_impact_player.wav", 1, ATTN_NORM);
			///	TODO: Add paralyze effect?
		}
	} else {	
		///	TODO: Add some particles on collision
		sound (self, CHAN_WEAPON, "player/tornoff2.wav", 1, ATTN_NORM);
	}
	remove(self);
};


void() hydra_spit_start = {
	local	vector	offang, org, vec, follow;
	local	entity	spit;
	
	if (!(self.enemy.flags & FL_CLIENT) && !(self.enemy.flags & FL_MONSTER)) {
		self.enemy = self.oldenemy;
	}
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors(offang);
	org = self.origin + v_up * 1 + v_forward * 5;
	
	spit = spawn();
	spit.classgroup = CG_PROJALL;
	spit.classname = "spit";
	setorigin (spit, org);
	setmodel (spit, "progs/w_spike.mdl");
	setsize (spit, VEC_ORIGIN, VEC_ORIGIN);		
	spit.movetype = MOVETYPE_FLYMISSILE;
	spit.solid = SOLID_BBOX;
		follow = self.enemy.velocity*0.2;		// "guess" players future position to make it harder to dodge
		follow_z = 0;	
	vec = normalize ((self.enemy.origin + '0 0 10' + follow) - org);
	spit.velocity = vec*555;
	spit.angles = vectoangles(vec);
	///	Add a sprite trail here?

	spit.owner = self;
	spit.enemy = self.enemy;
	spit.touch = hydra_spit_touch;

	spit.think = SUB_Remove;
	spit.nextthink = time + 5;

	sound (self, CHAN_WEAPON, "extras_r5/hydra/hydra_spit.wav", 1, ATTN_NORM);
};


void()	Hydra_Spit1	=[	$hspit1,	Hydra_Spit2] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit2	=[	$hspit2,	Hydra_Spit3] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit3	=[	$hspit3,	Hydra_Spit4] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit4	=[	$hspit4,	Hydra_Spit5] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit5	=[	$hspit5,	Hydra_Spit6] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit6	=[	$hspit6,	Hydra_Spit7] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit7	=[	$hspit7,	Hydra_Spit8] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit8	=[	$hspit8,	Hydra_Spit9] {ai_face(); hydra_spit_start ();};
void()	Hydra_Spit9	=[	$hspit9,	Hydra_Spit10] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit10	=[	$hspit10,	Hydra_Spit11] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit11	=[	$hspit11,	Hydra_Spit12] {ai_face();self.nextthink = time + 0.07;};
void()	Hydra_Spit12	=[	$hspit12,	hydra_run1] {ai_face(); SUB_AttackFinished (1 + random());};

void() hydra_death1 =[      $death1,        hydra_death2        ] {monster_check_gib();};
void() hydra_death2 =[      $death2,        hydra_death3        ] {monster_check_gib();};
void() hydra_death3 =[      $death3,        hydra_death4        ] {self.solid = SOLID_NOT;};
void() hydra_death4 =[      $death4,        hydra_death5        ] {};
void() hydra_death5 =[      $death5,        hydra_death6        ] {};
void() hydra_death6 =[      $death6,        hydra_death7        ] {};
void() hydra_death7 =[      $death7,        hydra_death8        ] {};
void() hydra_death8 =[      $death8,        hydra_death9        ] {};
void() hydra_death9 =[      $death9,        hydra_death10       ] {};
void() hydra_death10 =[      $death10,       hydra_death11       ] {};
void() hydra_death11 =[      $death11,       hydra_death12       ] {};
void() hydra_death12 =[      $death12,       hydra_death13       ] {};
void() hydra_death13 =[      $death13,       hydra_death14       ] {};
void() hydra_death14 =[      $death14,       hydra_death15       ] {};
void() hydra_death15 =[      $death15,       hydra_death16       ] {};
void() hydra_death16 =[      $death16,       hydra_death17       ] {};
void() hydra_death17 =[      $death17,       hydra_death18       ] {};
void() hydra_death18 =[      $death18,       hydra_death19       ] {};
void() hydra_death19 =[      $death19,       hydra_death20       ] {};
void() hydra_death20 =[      $death20,       hydra_death21       ] {monster_death_postcheck();};
void() hydra_death21 =[      $death21,       hydra_death21       ] {monster_deadbody_check();};

void() hydra_pain1  =[      $pain1, hydra_pain2 ] {};
void() hydra_pain2  =[      $pain2, hydra_pain3 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain3  =[      $pain3, hydra_pain4 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain4  =[      $pain4, hydra_pain5 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain5  =[      $pain5, hydra_pain6 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain6  =[      $pain6, hydra_pain7 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain7  =[      $pain7, hydra_pain8 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain8  =[      $pain8, hydra_pain9 ] {ai_fish_movement("ai_pain",6);};
void() hydra_pain9  =[      $pain9, hydra_run1 ] {ai_fish_movement("ai_pain",6);};

void(entity inflictor, entity attacker, float damage)	hydra_pain = {
	if (random() > 0.875) {
		if (self.pain_finished > time)
			return;

		self.pain_finished = time + 1;
		sound (self, CHAN_AUTO, "extras_r5/hydra/hydra_pain.wav", 1, ATTN_NORM);
		hydra_pain1 ();
	}
};

void() hydra_death= {
	// If fish in water, reduce self gravity to pretend to slowly sink
	if (pointcontents(self.origin) == CONTENT_WATER) self.gravity = 0.25;

	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// regular death
	if (!self.gibbed) {
		sound (self, CHAN_VOICE, "extras_r5/hydra/hydra_death.wav", 1, ATTN_NORM);
		hydra_death1();
	}
};

void() monster_hydra_precache = {
	precache_model ("progs/extras_r5/hydra.mdl");
	precache_model ("progs/extras_r5/hydragib.mdl");
	precache_model ("progs/w_spike.mdl");
	precache_sound ("extras_r5/hydra/hydra_death.wav");
	precache_sound ("extras_r5/hydra/spit_impact_player.wav");
	precache_sound ("extras_r5/hydra/hydra_pain.wav");
	precache_sound ("extras_r5/hydra/hydra_spit.wav");
	precache_sound ("extras_r5/hydra/hydra_idle.wav");
	precache_sound ("extras_r5/hydra/hydra_idle2.wav");
	precache_sound ("extras_r5/hydra/hydra_tent.wav");
	precache_sound ("player/tornoff2.wav");
};

// QUAKED monster_hydra (1 0 0) (-16 -16 -24) (16 16 24) Ambush
void() monster_hydra = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.idle_sound = "extras_r5/hydra/hydra_idle.wav";
	self.idle_sound2 = "extras_r5/hydra/hydra_idle2.wav";
	self.sight_sound = self.idle_sound;
	self.gib1mdl = "progs/extras_r5/hydragib.mdl";
	self.mdl = "progs/extras_r5/hydra.mdl";
	self.headmdl = "progs/extras_r5/hydragib.mdl";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.gibhealth = -35;
	self.gibbed = FALSE;
	self.pain_flinch = 1;				// Always in pain
	self.steptype = FS_FLYING;			// It has fins!?!
	self.blockudeath = TRUE;			// No humanoid death sound
	if (self.bboxtype < 1) self.bboxtype = BBOX_FISH;
	if (self.health < 1) self.health = 160;//75;	// I gave hydra more life (khreathor)
	if (self.deathstring == "") self.deathstring = " was choked by a Hydra\n";
	if (self.spawnflags & MON_LIQUIDBLOCK) self.liquidblock = TRUE; // Check for water sightline wakeup
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_stand = hydra_stand1;
	self.th_walk = hydra_walk1;
	self.th_run = hydra_run1;
	self.th_die = hydra_death;
	self.th_pain = hydra_pain;
	self.th_melee = hydra_attack1;
	self.th_missile = Hydra_Spit1;
	self.classtype = CT_MONHYDRA;
	self.classgroup = CG_FISH;
	self.classmove = MON_MOVESWIM;
	monster_start();
};