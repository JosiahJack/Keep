/*==============================================================================
 GAUNT (Originally from Quoth - Kell/Necros/Preach)
 - Big thank you to necros for the code base for this monster
==============================================================================*/

// (000) Perched on a ledge (idling)
$frame perch1 perch2 perch3 perch4 perch5 perch6 perch7 perch8
$frame perch9 perch10 perch11 perch12 perch13 perch14 perch15 perch16

// (016) Lift off from perch position
$frame launch1 launch2 launch3 launch4 launch5 launch6 launch7 launch8

// (024) Idling in mid air
$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15 hover16
$frame hover17 hover18 hover19 hover20

// (044) range attack (lightning/plasma)
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15 attack16 
$frame attack17 attack18 attack19 attack20

// (064) Start of dive attack
$frame swoopStart1 swoopStart2 swoopStart3 swoopStart4
$frame swoopStart5 swoopStart6 swoopStart7 swoopStart8

// (072) Looped version of dive attack
$frame swoop1 swoop2 swoop3 swoop4 swoop5

// (077) Something, not sure what
$frame drop1 drop2 drop3 drop4 drop5

// (082) Swing wing around infront
$frame painA1 painA2 painA3 painA4 painA5 painA6

// (088) Knock head backward
$frame painB1 painB2 painB3 painB4 painB5

// (093) Fall backwards
$frame deathA1 deathA2 deathA3 deathA4 deathA5 deathA6 deathA7 deathA8

// (101) Fall forward
$frame deathB1 deathB2 deathB3 deathB4 deathB5 deathB6 deathB7 deathB8

void(float dist) gaunt_hadj = {
	local float hadj;
	local vector hadjvec;
	local float enemydistance;
	local vector oldorg;
	local vector reqvel;
	local float d;
	self.velocity = VEC_ORIGIN;
	enemydistance = vlen(self.enemy.origin - self.origin);
	self.origin2 = self.origin;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_run(dist);
	d = vlen(self.origin - oldorg);
	hadj = self.origin_z - self.origin2_z;
	if (visible(self.enemy)) hadj = hadj * self.vsightmultiplier;
	else hadj = hadj * self.vmultiplier;

	hadjvec_z = hadj;
	setorigin(self, self.origin + hadjvec);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + 5) {
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

void() GauntAttackFinished = { // [FUNCTION]
	if (enemy_range >= RANGE_MID || !enemy_vis) {
		self.attack_state = AS_STRAIGHT;
		self.think = gaunt_run1;
	} else {
		self.attack_state = AS_SLIDING;
		self.think = gaunt_side1;
	}
};

void() gaunt_strafe = { // [FUNCTION]
	local float ofs;
	local float hadj;
	local vector hadjvec;
	local vector oldorg;
	local vector reqvel;
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	ChangeYaw();
	if (self.lefty == 1) {
		ofs = 90;
	} else {
		ofs = -90;
	}
	self.origin2 = self.origin;
	oldorg = self.origin;
	walkmove(self.ideal_yaw - ofs, 8 * self.multiplier);
	hadj = self.origin_z - self.origin2_z;
	if (visible(self.enemy)) {
		hadj = hadj * self.vsightmultiplier;
	} else {
		hadj = hadj * self.vmultiplier;
	}
	hadjvec_z = hadj;
	setorigin(self, self.origin + hadjvec);
	if (self.lip == 0) {
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * SECRET_NO_SHOOT * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
	if (self.lip == 1) self.lip = 0;
};

void() gaunt_idle1 = [$hover1, gaunt_idle2 ] { monster_idle_sound(); ai_stand(); };
void() gaunt_idle2 = [$hover2, gaunt_idle3 ] { ai_stand(); };
void() gaunt_idle3 = [$hover3, gaunt_idle4 ] { ai_stand(); };
void() gaunt_idle4 = [$hover4, gaunt_idle5 ] { ai_stand(); };
void() gaunt_idle5 = [$hover5, gaunt_idle6 ] { gargoylewings(); ai_stand(); };
void() gaunt_idle6 = [$hover6, gaunt_idle7 ] { ai_stand(); };
void() gaunt_idle7 = [$hover7, gaunt_idle8 ] { ai_stand(); };
void() gaunt_idle8 = [$hover8, gaunt_idle9 ] { ai_stand(); };
void() gaunt_idle9 = [$hover9, gaunt_idle10 ] { ai_stand(); };
void() gaunt_idle10 = [$hover10, gaunt_idle11 ] { ai_stand(); };
void() gaunt_idle11 = [$hover11, gaunt_idle12 ] { ai_stand(); };
void() gaunt_idle12 = [$hover12, gaunt_idle13 ] { ai_stand(); };
void() gaunt_idle13 = [$hover13, gaunt_idle14 ] { ai_stand(); };
void() gaunt_idle14 = [$hover14, gaunt_idle15 ] { ai_stand(); };
void() gaunt_idle15 = [$hover15, gaunt_idle16 ] { gargoylewings(); ai_stand(); };
void() gaunt_idle16 = [$hover16, gaunt_idle17 ] { ai_stand(); };
void() gaunt_idle17 = [$hover17, gaunt_idle18 ] { ai_stand(); };
void() gaunt_idle18 = [$hover18, gaunt_idle19 ] { ai_stand(); };
void() gaunt_idle19 = [$hover19, gaunt_idle20 ] { ai_stand(); };
void() gaunt_idle20 = [$hover20, gaunt_idle1 ] { ai_stand(); };

void() gaunt_walk1 = [$hover1, gaunt_walk2 ] { monster_idle_sound(); ai_walk(8); };
void() gaunt_walk2 = [$hover2, gaunt_walk3 ] { ai_walk(8); };
void() gaunt_walk3 = [$hover3, gaunt_walk4 ] { gargoylewings(); ai_walk(8); };
void() gaunt_walk4 = [$hover4, gaunt_walk5 ] { ai_walk(8); };
void() gaunt_walk5 = [$hover5, gaunt_walk6 ] { ai_walk(8); };
void() gaunt_walk6 = [$hover6, gaunt_walk7 ] { ai_walk(8); };
void() gaunt_walk7 = [$hover7, gaunt_walk8 ] { ai_walk(8); };
void() gaunt_walk8 = [$hover8, gaunt_walk9 ] { ai_walk(8); };
void() gaunt_walk9 = [$hover9, gaunt_walk10 ] { ai_walk(8); };
void() gaunt_walk10 = [$hover10, gaunt_walk11 ] { ai_walk(8); };
void() gaunt_walk11 = [$hover11, gaunt_walk12 ] { ai_walk(8); };
void() gaunt_walk12 = [$hover12, gaunt_walk13 ] { ai_walk(8); };
void() gaunt_walk13 = [$hover13, gaunt_walk14 ] { ai_walk(8); };
void() gaunt_walk14 = [$hover14, gaunt_walk15 ] { ai_walk(8); };
void() gaunt_walk15 = [$hover15, gaunt_walk16 ] { gargoylewings(); ai_walk(8); };
void() gaunt_walk16 = [$hover16, gaunt_walk17 ] { ai_walk(8); };
void() gaunt_walk17 = [$hover17, gaunt_walk18 ] { ai_walk(8); };
void() gaunt_walk18 = [$hover18, gaunt_walk19 ] { ai_walk(8); };
void() gaunt_walk19 = [$hover19, gaunt_walk20 ] { ai_walk(8); };
void() gaunt_walk20 = [$hover20, gaunt_walk1 ] { ai_walk(8); };


void() gaunt_run1 = [$hover1, gaunt_run2 ] { // [FUNCTION]
	monster_idle_sound();
	SUB_FinishAttachment();
	// Switch direction of strafing (random duration)
	if (self.meleeattack < time) {
		self.meleeattack = time + 4 + (random() + random() + random() * 4);
		self.lefty = rint(1 - self.lefty);
	}
	ai_run(8);
};
void() gaunt_run2 = [$hover2, gaunt_run3 ] { ai_run(8); };
void() gaunt_run3 = [$hover3, gaunt_run4 ] { ai_run(8); };
void() gaunt_run4 = [$hover4, gaunt_run5 ] { ai_run(8); };
void() gaunt_run5 = [$hover5, gaunt_run6 ] { gargoylewings(); ai_run(8); };
void() gaunt_run6 = [$hover6, gaunt_run7 ] { ai_run(8); };
void() gaunt_run7 = [$hover7, gaunt_run8 ] { ai_run(8); };
void() gaunt_run8 = [$hover8, gaunt_run9 ] { ai_run(8); };
void() gaunt_run9 = [$hover9, gaunt_run10 ] { ai_run(8); };
void() gaunt_run10 = [$hover10, gaunt_run11 ] { ai_run(8); };
void() gaunt_run11 = [$hover11, gaunt_run12 ] { ai_run(8); };
void() gaunt_run12 = [$hover12, gaunt_run13 ] { ai_run(8); };
void() gaunt_run13 = [$hover13, gaunt_run14 ] { ai_run(8); };
void() gaunt_run14 = [$hover14, gaunt_run15 ] { ai_run(8); };
void() gaunt_run15 = [$hover15, gaunt_run16 ] { gargoylewings(); ai_run(8); };
void() gaunt_run16 = [$hover16, gaunt_run17 ] { ai_run(8); };
void() gaunt_run17 = [$hover17, gaunt_run18 ] { ai_run(8); };
void() gaunt_run18 = [$hover18, gaunt_run19 ] { ai_run(8); };
void() gaunt_run19 = [$hover19, gaunt_run20 ] { ai_run(8); };
void() gaunt_run20 = [$hover20, gaunt_run1 ] { ai_run(8); };

void() gaunt_side1 = [24, gaunt_side2] { gaunt_hadj(2 * self.multiplier); monster_idle_sound(); };
void() gaunt_side2 = [25, gaunt_side3] { gaunt_hadj(2 * self.multiplier); };
void() gaunt_side3 = [26, gaunt_side4] { gaunt_hadj(3 * self.multiplier); };
void() gaunt_side4 = [27, gaunt_side5] { gaunt_hadj(3 * self.multiplier); };
void() gaunt_side5 = [28, gaunt_side6] { gaunt_hadj(4 * self.multiplier); };
void() gaunt_side6 = [29, gaunt_side7] { gaunt_hadj(5 * self.multiplier); };
void() gaunt_side7 = [30, gaunt_side8] { gaunt_hadj(6 * self.multiplier); };
void() gaunt_side8 = [31, gaunt_side9] { gaunt_hadj(8 * self.multiplier); };
void() gaunt_side9 = [32, gaunt_side10] { gaunt_hadj(10 * self.multiplier); };
void() gaunt_side10 = [33, gaunt_side11] { gaunt_hadj(12 * self.multiplier); };
void() gaunt_side11 = [34, gaunt_side12] { gaunt_hadj(2 * self.multiplier); };
void() gaunt_side12 = [35, gaunt_side13] { gaunt_hadj(2 * self.multiplier); };
void() gaunt_side13 = [36, gaunt_side14] { gaunt_hadj(3 * self.multiplier); };
void() gaunt_side14 = [37, gaunt_side15] { gaunt_hadj(3 * self.multiplier); };
void() gaunt_side15 = [38, gaunt_side16] { gaunt_hadj(4 * self.multiplier); };
void() gaunt_side16 = [39, gaunt_side17] { gaunt_hadj(5 * self.multiplier); };
void() gaunt_side17 = [40, gaunt_side18] { gaunt_hadj(6 * self.multiplier); };
void() gaunt_side18 = [41, gaunt_side19] { gaunt_hadj(8 * self.multiplier); };
void() gaunt_side19 = [42, gaunt_side20] { gaunt_hadj(10 * self.multiplier); };
void() gaunt_side20 = [43, gaunt_side1] { gaunt_hadj(12 * self.multiplier); };

void(float fxframe) gaunt_lightning_fx = { // [FUNCTION]
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.owner.frame = fxframe;
	setorigin(self.owner, self.origin - VEC_ORIGIN);
	self.owner.angles = self.angles;
};

void() gaunt_fast1 = [44, gaunt_fast2] { // [FUNCTION]
	local entity o;
	if (random() < 0.5) {
		self.lefty = 1;
	} else {
		self.lefty = 0;
	}
	gaunt_strafe();
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.owner = spawn();
	o = self.owner;
	setmodel(o, "progs/quoth/g_fx.mdl");
	setorigin(o, self.origin - VEC_ORIGIN);
	o.angles = self.angles;
	o.nextthink = time + 1;
	o.think = SUB_Remove;
};
void() gaunt_fast2 = [45, gaunt_fast3] { gaunt_strafe(); gaunt_lightning_fx(1); };
void() gaunt_fast3 = [46, gaunt_fast4] { gaunt_strafe(); gaunt_lightning_fx(2); };
void() gaunt_fast4 = [47, gaunt_fast5] { gaunt_strafe(); gaunt_lightning_fx(3); };
void() gaunt_fast5 = [48, gaunt_fast6] { gaunt_strafe(); gaunt_lightning_fx(4); };
void() gaunt_fast6 = [49, gaunt_fast7] { gaunt_strafe(); gaunt_lightning_fx(5); };
void() gaunt_fast7 = [50, gaunt_fast8] { gaunt_strafe(); gaunt_lightning_fx(6); };
void() gaunt_fast8 = [51, gaunt_fast9] { gaunt_strafe(); gaunt_lightning_fx(7); };
void() gaunt_fast9 = [52, gaunt_fast10] { gaunt_strafe(); gaunt_lightning_fx(8); };
void() gaunt_fast10 = [53, gaunt_fast11] { gaunt_strafe(); gaunt_lightning_fx(9); };
void() gaunt_fast11 = [54, gaunt_fast12] { sound(self,CHAN_WEAPON,"weapons/lstart.wav",1,ATTN_NORM); gaunt_lightning(1); remove(self.owner); };
void() gaunt_fast12 = [55, gaunt_fast13] { gaunt_lightning(0); };
void() gaunt_fast13 = [56, gaunt_fast14] { gaunt_lightning(1); };
void() gaunt_fast14 = [57, gaunt_fast15] { gaunt_lightning(0); };
void() gaunt_fast15 = [58, gaunt_fast16] { gaunt_lightning(1); };
void() gaunt_fast16 = [59, gaunt_fast17] {};
void() gaunt_fast17 = [60, gaunt_fast18] {};
void() gaunt_fast18 = [61, gaunt_fast19] {};
void() gaunt_fast19 = [62, gaunt_fast20] {};
void() gaunt_fast20 = [63, gaunt_run1] { ai_face(); self.attack_state = AS_STRAIGHT; };

// RANGE - Plasma from arc infront
void() gaunt_plasma = { // [FUNCTION]
	local vector org, dir;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"ad171/gaunt/plasma_fire.wav",1,ATTN_NORM);
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = normalize(SUB_orgEnemyTarget() - self.origin);
	self.attack_speed = SPEED_GAUNTBOLT + (skill * SPEED_GAUNTSKILL);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_PLASMA,self.attack_speed);
};

void(float elecframe) gaunt_elecupdate = { // [FUNCTION]
	if (self.health < 1) return;

	SUB_CreateSelfAttachment(self.weaponglow,1.0);
	if (self.poisonous) self.attachment.skin = 1;
	if (elecframe == 0) {
		self.attachment.state = STATE_ON;
		self.pain_finished = time + 1.2;		//don't go into pain whilst firing
		setorigin(self.attachment, self.origin);
		setmodel(self.attachment, self.attachment.mdl);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		sound(self,CHAN_WEAPON,"ad171/gaunt/plasma_start.wav",1,ATTN_NORM);
	}

	ai_face();					// Turn towards enemy
	makevectors(self.angles);
	setorigin(self.attachment, self.origin);
	self.attachment.angles = self.angles;
	self.attachment.frame = elecframe;
};

void() gaunt_fire1 = [$attack1, gaunt_fire2 ] { gaunt_elecupdate(0); };
void() gaunt_fire2 = [$attack2, gaunt_fire3 ] { gaunt_elecupdate(1); };
void() gaunt_fire3 = [$attack3, gaunt_fire4 ] { gaunt_elecupdate(2); };
void() gaunt_fire4 = [$attack4, gaunt_fire5 ] { gaunt_elecupdate(3); };
void() gaunt_fire5 = [$attack5, gaunt_fire6 ] { gaunt_elecupdate(4);gargoylewings(); };
void() gaunt_fire6 = [$attack6, gaunt_fire7 ] { gaunt_elecupdate(5);gaunt_plasma(); };
void() gaunt_fire7 = [$attack7, gaunt_fire8 ] { gaunt_elecupdate(6); };
void() gaunt_fire8 = [$attack8, gaunt_fire9 ] { gaunt_elecupdate(7);gaunt_plasma(); };
void() gaunt_fire9 = [$attack9, gaunt_fire10 ] { gaunt_elecupdate(8); };
void() gaunt_fire10 = [$attack10, gaunt_fire11 ] { ai_face();
	if (skill > SKILL_NORMAL) gaunt_plasma();
	SUB_FinishAttachment(); };
void() gaunt_fire11 = [$attack11, gaunt_fire12 ] {};
void() gaunt_fire12 = [$attack12, gaunt_fire13 ] {};
void() gaunt_fire13 = [$attack13, gaunt_fire14 ] {};
void() gaunt_fire14 = [$attack14, gaunt_fire15 ] {};
void() gaunt_fire15 = [$attack15, gaunt_fire16 ] { gargoylewings(); };
void() gaunt_fire16 = [$attack16, gaunt_fire17 ] {};
void() gaunt_fire17 = [$attack17, gaunt_fire18 ] {};
void() gaunt_fire18 = [$attack18, gaunt_fire19 ] { ai_face(); };
void() gaunt_fire19 = [$attack19, gaunt_fire20 ] { ai_face(); };
void() gaunt_fire20 = [$attack20, gaunt_run1 ] {};

// PERCH + WAKEUP
void() gaunt_perch1 = [$perch1, gaunt_perch2 ] { monster_idle_sound(); ai_stand(); };
void() gaunt_perch2 = [$perch2, gaunt_perch3 ] { ai_stand(); };
void() gaunt_perch3 = [$perch3, gaunt_perch4 ] { ai_stand(); };
void() gaunt_perch4 = [$perch4, gaunt_perch5 ] { ai_stand(); };
void() gaunt_perch5 = [$perch5, gaunt_perch6 ] { ai_stand(); };
void() gaunt_perch6 = [$perch6, gaunt_perch7 ] { ai_stand(); };
void() gaunt_perch7 = [$perch7, gaunt_perch8 ] { ai_stand(); };
void() gaunt_perch8 = [$perch8, gaunt_perch9 ] { ai_stand(); };
void() gaunt_perch9 = [$perch9, gaunt_perch10 ] { ai_stand(); };
void() gaunt_perch10 = [$perch10, gaunt_perch11 ] { ai_stand(); };
void() gaunt_perch11 = [$perch11, gaunt_perch12 ] { ai_stand(); };
void() gaunt_perch12 = [$perch12, gaunt_perch13 ] { ai_stand(); };
void() gaunt_perch13 = [$perch13, gaunt_perch14 ] { ai_stand(); };
void() gaunt_perch14 = [$perch14, gaunt_perch15 ] { ai_stand(); };
void() gaunt_perch15 = [$perch15, gaunt_perch16 ] { ai_stand(); };
void() gaunt_perch16 = [$perch16, gaunt_perch1 ] { ai_stand(); };

// Sightsound and very quick animation while moving forward
void() gaunt_wakeup1 = [$launch1, gaunt_wakeup2 ] { monster_sightsound(); };
void() gaunt_wakeup2 = [$launch2, gaunt_wakeup3 ] { ai_forward(4); };
void() gaunt_wakeup3 = [$launch3, gaunt_wakeup4 ] { ai_forward(4); };
void() gaunt_wakeup4 = [$launch4, gaunt_wakeup5 ] { ai_forward(4); };
void() gaunt_wakeup5 = [$launch5, gaunt_wakeup6 ] { ai_forward(4); };
void() gaunt_wakeup6 = [$launch6, gaunt_wakeup7 ] { gargoylewings(); ai_forward(4); };
void() gaunt_wakeup7 = [$launch7, gaunt_wakeup8 ] { ai_forward(4); };
void() gaunt_wakeup8 = [$launch8, gaunt_run1 ] {
	FoundHuntTarget(TRUE);			// Setup goals and warn other monsters
	self.spawnstatue = FALSE;		// No longer stationary
	self.th_stand = gaunt_idle1;	// Restore all think state functions
	self.th_walk = gaunt_walk1;
	self.th_run = gaunt_run1;
	self.th_missile = gaunt_fire1;
};

void() gaunt_wakeup = { // [FUNCTION]
	// Dead already?
	if (self.health < 1) return;

	self.takedamage = DAMAGE_AIM;		// Can receive damage
	self.use = SUB_Null;				// no re-trigger
	self.th_walk = self.th_run = SUB_Null; // Only call wakeup function once

	// No longer need perch spawnflag, remove it
	if (self.spawnflags & MON_GAUNT_PERCH) {
		self.spawnflags = self.spawnflags - MON_GAUNT_PERCH;
	}

	// Allow gaunt to fly up, no more ground checks
	if (!(self.flags & FL_FLY)) self.flags = self.flags | FL_FLY;
	self.movetype = MOVETYPE_FLY;
	self.pain_finished = time + 1.5;		// No pain
	SUB_AttackFinished(2 + random());		// No attacking
	gaunt_wakeup1();
};


// PAIN

// Long - Swing wing around infront
void() 	gaunt_painA1 = [$painA1, gaunt_painA2 ] {};
void() 	gaunt_painA2 = [$painA2, gaunt_painA3 ] {};
void() 	gaunt_painA3 = [$painA3, gaunt_painA4 ] {};
void() 	gaunt_painA4 = [$painA4, gaunt_painA5 ] {};
void() 	gaunt_painA5 = [$painA5, gaunt_painA6 ] {};
void() 	gaunt_painA6 = [$painA6, gaunt_run1 ] {};

// Short - Knock head backward
void() 	gaunt_painB1 = [$painB1, gaunt_painB2 ] {};
void() 	gaunt_painB2 = [$painB2, gaunt_painB3 ] {};
void() 	gaunt_painB3 = [$painB3, gaunt_painB4 ] {};
void() 	gaunt_painB4 = [$painB4, gaunt_painB5 ] {};
void() 	gaunt_painB5 = [$painB5, gaunt_run1 ] {};

void(entity inflictor, entity attacker, float damage) gaunt_pain = { // [FUNCTION]
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);
	SUB_FinishAttachment(); // make sure any electricity is hidden

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		if (self.pain_check == 1 || self.pain_check == 2) {
			if (self.lip < 0.4) gaunt_painB1();	// Long
			else gaunt_painA1();				// Short
		}
	}
};

void() gaunt_deathA1 = [$deathA1, gaunt_deathA2 ] {};
void() gaunt_deathA2 = [$deathA2, gaunt_deathA3 ] { monster_check_gib(); };
void() gaunt_deathA3 = [$deathA3, gaunt_deathA4 ] { monster_check_gib();
	self.solid = SOLID_NOT; };
void() gaunt_deathA4 = [$deathA4, gaunt_deathA5 ] {};
void() gaunt_deathA5 = [$deathA5, gaunt_deathA6 ] {};
void() gaunt_deathA6 = [$deathA6, gaunt_deathA7 ] {};
void() gaunt_deathA7 = [$deathA7, gaunt_deathA8 ] { monster_death_postcheck(); };
void() gaunt_deathA8 = [$deathA8, gaunt_deathA8 ] { monster_deadbody_check(); };

void() gaunt_deathB1 = [$deathB1, gaunt_deathB2 ] {};
void() gaunt_deathB2 = [$deathB2, gaunt_deathB3 ] { monster_check_gib(); };
void() gaunt_deathB3 = [$deathB3, gaunt_deathB4 ] { monster_check_gib();
	self.solid = SOLID_NOT; };
void() gaunt_deathB4 = [$deathB4, gaunt_deathB5 ] {};
void() gaunt_deathB5 = [$deathB5, gaunt_deathB6 ] {};
void() gaunt_deathB6 = [$deathB6, gaunt_deathB7 ] {};
void() gaunt_deathB7 = [$deathB7, gaunt_deathB8 ] { monster_death_postcheck(); };
void() gaunt_deathB8 = [$deathB8, gaunt_deathB8 ] { monster_deadbody_check(); };

void() gaunt_die = { // [FUNCTION]
	// Check for perching gaunt, need to blow up in gibs
	// In an awkward pose that does not go well into death animations
	if (self.spawnflags & MON_GAUNT_PERCH) self.gibondeath = TRUE;
	StopSound(self,CHAN_ITEM); // Make sure any wings sound is silenced
	
	// If casting electricity, make it explode!
	if (self.attachment) {
		if (self.attachment.state == STATE_ON) {
			self.gibondeath = TRUE;
			SpawnProjectileSmoke(self.origin, 200, 50, 150);
			SpawnProjectileSmoke(self.origin, 200, 50, 150);
			particle_explode(self.origin-'0 0 16', 50+random()*50, 2, PARTICLE_BURST_BLUE, PARTICLE_BURST_UPWARD);
			makevectors(self.angles);
			self.oldorigin = self.origin + v_forward*8;
			SpawnExplosion(EXPLODE_PLASMA_BIG, self.oldorigin, SOUND_REXP3);
		}
		SUB_RemoveAttachment(); // make sure any electricity is hidden
	}
	
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// regular death
	if (!self.gibbed) {
		sound(self,CHAN_VOICE, "quoth/gaunt/death.wav",1,ATTN_NORM);
		self.velocity_x = -200 + 400*random();
		self.velocity_y = -200 + 400*random();
		self.velocity_z = 100 + 100*random();
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		if (random() < 0.5) gaunt_deathA1();
		else gaunt_deathB1();
	}
};

float() gaunt_checkswoop = { // [FUNCTION]
	local entity head;
	local float m;
	head = findradius(self.origin,1024);
	while (head) {
		if (head.targetname == self.pathtarget || head.flags & FLx_CREATURE) {
			m = vlen(self.enemy.origin - head.origin);
			if (m > 500 && visxray(self.enemy,head,self.view_ofs,self.enemy.view_ofs,TRUE)) {
				return TRUE;
			}
			if (m <= 500 && visxray(head,self.enemy,self.view_ofs,self.enemy.view_ofs,TRUE)) {
				return TRUE;
			}
		}
		head = head.chain;
	}
	return FALSE;
};

void() gaunt_flyswoop = { // [FUNCTION]
	self.velocity = self.goalentity.origin - self.origin + '0 0 32';
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 600;
	self.angles = vectoangles(self.velocity);
};

void() gaunt_charge1 = [72, gaunt_charge2] {};
void() gaunt_charge2 = [73, gaunt_charge3] { gaunt_flyswoop(); };
void() gaunt_charge3 = [74, gaunt_charge4] { gaunt_flyswoop(); };
void() gaunt_charge4 = [75, gaunt_charge5] { gaunt_flyswoop(); };
void() gaunt_charge5 = [76, gaunt_charge2] { gaunt_flyswoop(); };

void(float thespeed) gaunt_flyup = { self.movetype = MOVETYPE_FLYMISSILE; self.velocity_z = thespeed; };

void() gaunt_precharge1 = [64, gaunt_precharge2] { gaunt_flyup(SVC_INTERMISSION); self.pain_finished = time + SECRET_1ST_DOWN; };
void() gaunt_precharge2 = [65, gaunt_precharge3] { gaunt_flyup(40); };
void() gaunt_precharge3 = [66, gaunt_precharge4] { gaunt_flyup(50); };
void() gaunt_precharge4 = [67, gaunt_precharge5] { gaunt_flyup(60); };
void() gaunt_precharge5 = [68, gaunt_precharge6] { gaunt_flyup(80); };
void() gaunt_precharge6 = [69, gaunt_precharge7] { gaunt_flyup(100); };
void() gaunt_precharge7 = [70, gaunt_precharge8] { gaunt_flyup(120); };
void() gaunt_precharge8 = [71, gaunt_charge1] {
	gaunt_flyup(150);
	self.movetype = MOVETYPE_FLYMISSILE;
	makevectors(self.angles);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.origin_z = self.origin_z + 1;
	self.velocity = normalize(self.goalentity.origin - self.origin + '0 0 32') * 600;
	self.angles = vectoangles(self.velocity);
};

// Quoth lightning attack
void() gaunt_Missile = {
	self.attack_state = AS_STRAIGHT;
	self.movetype = MOVETYPE_STEP;
	// if (self.ltime < time && vlen(self.origin - self.enemy.origin) < 750 && self.enemy.carrymode == 0 && self.swoop != 0 && (self.enemy.flags & FL_CLIENT) && self.enemy.client_gaunt_swoop_time < time) {
		// if (!gaunt_checkswoop) return;

		// setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
		// self.ltime = time + TE_LAVASPLASH;
		// self.pain_finished = time + TE_WIZSPIKE;
		// gaunt_precharge1();
		// return;
	// }
	// if (self.swoop == 2) return;

	//if (random() < 0.4 && self.swoop == 1 && self.enemy.carrymode == 0) {
		//gaunt_fast1();
	//} else {
		//if (random() < 0.7 && self.swoop != 1 && self.enemy.carrymode == 0) gaunt_fast1();
	//}
	if (random() < 0.7) gaunt_fast1();
	return;
};

// Minion Wakeup
void()	gaunt_minwake = [$hover1, gaunt_run1 ] {
	// Is the gaunt stuck? cannot move?
	if (pointcontents(self.origin) == CONTENT_SOLID) {
		// Time to die!
		self.health = self.gibhealth;
		Killed(self, self);
	} else {
		monster_sightsound();
		// Setup goals and warn other monsters
		FoundHuntTarget(TRUE);
		// Restore all think state functions
		self.th_stand = gaunt_idle1;
		self.th_walk = gaunt_walk1;
		self.th_run = gaunt_run1;
		self.th_missile = gaunt_fire1;
	}
};

void() monster_gaunt_precache = {
	precache_model("progs/quoth/gaunt.mdl");
	precache_model("progs/ad171/h_gaunt.mdl");
	precache_model("progs/ad171/mon_gaunt_elec.mdl"); // Lightning effect
	precache_model("progs/quoth/g_fx.mdl"); // Lightning effect
	precache_model(MODEL_PROJ_GAPLASMA); // Plasma spike/bolt
	precache_poisongibs(); // precache gibs
	precache_model(MODEL_PROJ_GAPLASMAGRN);
	precache_sound("quoth/gaunt/idle1.wav");
	precache_sound("quoth/gaunt/idle3.wav");
	precache_sound("quoth/gaunt/idle2.wav");
	precache_sound("ad171/gaunt/idle2.wav");
	precache_sound("ad171/gargoyle/wings1.wav");
	precache_sound("ad171/gaunt/plasma_start.wav");
	precache_sound("ad171/gaunt/plasma_fire.wav");
	precache_sound("quoth/gaunt/pain.wav");
	precache_sound("quoth/gaunt/death.wav");
	precache_sound("quoth/gaunt/sight.wav");
	precache_sound("quoth/gaunt/sight.wav");
};

// QUAKED monster_gaunt (1 0.2 0) (-16 -16 -24) (16 16 24)
void() monster_gaunt = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/quoth/gaunt.mdl";
	self.headmdl = "progs/ad171/h_gaunt.mdl";
	self.weaponglow = "progs/ad171/mon_gaunt_elec.mdl";
	self.idle_sound = "quoth/gaunt/idle1.wav";
	self.idle_sound2 = "quoth/gaunt/idle3.wav";
	self.idle_soundcom = "quoth/gaunt/idle2.wav";
	self.idle_soundcom2 = "ad171/gaunt/idle2.wav"; // Different than quoth's, different tempo and no reverb
	self.pain_sound = "quoth/gaunt/pain.wav";
	self.sight_sound = "quoth/gaunt/sight.wav";
	if (self.poisonous) self.gibtype = GIBTYPE_POISON;	// Poisonous blood trails
	
	if (self.classtype == CT_CACHEGAUNT) return; // Cache gaunt is a special class used for precache only

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 120;
	self.gibhealth = -70;				// Need a powerful weapon to GIB
	self.gibbed = FALSE;				// no falling apart
	self.pain_flinch = 70;				// High pain threshold
	self.blockudeath = TRUE;			// no humanoid death sound
	if (self.height < 1) self.height = MONAI_ABOVEDIST;		// Enemytarget distance above
	self.attack_offset = '8 0 -4';		// Plasma start location
	if (self.spawnflags & 2) {
		self.th_checkattack = GauntCheckAttackQuoth;
	} else {
		self.th_checkattack = StrafeFlyerCheckAttack;
	}

	self.th_pain = gaunt_pain; 
	self.th_die = gaunt_die;
	if ( (random () < 0.500) ) {
		if (self.deathstring == "")  self.deathstring = " was blasted by a Gaunt\n";
	} else {
		if (self.deathstring == "")  self.deathstring = " was charred by a Gaunt\n";
	}

	if (self.spawnflags & MON_GAUNT_PERCH) {
		// Perched Gaunt have special idle animation + idle sounds
		self.th_stand = self.th_walk = gaunt_perch1;
		self.th_run = self.th_missile = gaunt_wakeup;
	} else {
		// Default gaunt setup
		self.th_stand = gaunt_idle1;
		self.th_walk = gaunt_walk1;
		self.th_run = gaunt_run1;

		// Check for and use Quoth lightning attack
		if (self.spawnflags & 2)
			self.th_missile = gaunt_Missile;
		else
			self.th_missile = gaunt_fire1;
	}

	if (!self.classtype) self.classtype = CT_MONGAUNT;
	if (!self.classgroup) self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_cells = 0.25;
	self.resist_plasma = 0.25;
	monster_start();
};

void() monster_judgeminion = { 
	self.classtype = CT_CACHEGAUNT; 
	self.poisonous = TRUE;	// Cache poison stuff (just in case)
	monster_gaunt();
};

void() setup_gaunt = { // [FUNCTION]
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 120;
	self.gibhealth = -70;				// Need a powerful weapon to GIB
	self.gibbed = FALSE;				// no falling apart
	self.pain_flinch = 70;				// High pain threshold
	self.blockudeath = TRUE;			// no humanoid death sound
	if (self.height < 1) self.height = MONAI_ABOVEDIST; // Custom height
	self.attack_offset = '8 0 -4';		// Plasma start location
	if ( (random () < 0.500) ) {
		if (self.deathstring == "")  self.deathstring = " was blasted by a Gaunt\n";
	} else {
		if (self.deathstring == "")  self.deathstring = " was charred by a Gaunt\n";
	}

	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_cells = 0.25;
	self.th_checkattack = StrafeFlyerCheckAttack;
	self.th_pain = gaunt_pain; 
	self.th_die = gaunt_die;
	if (self.spawnflags & MON_GAUNT_PERCH) {
		// Perched Gaunt have special idle animation + idle sounds
		self.th_stand = self.th_walk = gaunt_perch1;
		self.th_run = self.th_missile = gaunt_wakeup;
	} else if (self.classtype == CT_MINIONGAUNT) {
		self.th_stand = self.th_walk = gaunt_minwake;
		self.th_run = self.th_missile = gaunt_minwake;
	} else {
		// Default gaunt setup
		self.th_stand = gaunt_idle1;
		self.th_walk = gaunt_walk1;
		self.th_run = gaunt_run1;
		self.th_missile = gaunt_fire1;
	}

	if (!self.classtype) self.classtype = CT_MONGAUNT;
	if (!self.classgroup) self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;
	monster_start();
};