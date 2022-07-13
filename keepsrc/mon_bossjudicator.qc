/*==============================================================================
 The Judicator Knight (model/animation by Benoit Stordeur)

  Interesting QC traits
  * Has a floor damage attack to encourage players to jump
  * Uses the new flame (sprite) projectile system
  * Has logic to break attacks and switch based on enemy distance
 
==============================================================================*/

// (000) 
$frame blank1

// (001-010) MELEE ATTACK, sword over head to ground
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8
$frame smash9 smash10

// (011-022) Walk
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12

// (023) 
$frame blank2

// (024-032) IDLE B, point sword forward
$frame taunt1 taunt2 taunt3 taunt4 taunt5 taunt6 taunt7 taunt8
$frame taunt9

// (033-042) BOSS ONLY summon gaunts
$frame summon1 summon2 summon3 summon4 summon5 summon6 summon7 summon8
$frame summon9 summon10

// (043-055) RANGE ATTACK, smash sword into ground
$frame flame1 flame2 flame3 flame4 flame5 flame6 flame7 flame8
$frame flame9 flame10 flame11 flame12 flame13

// (056-061) Run
$frame run1 run2 run3 run4 run5 run6

// (062) 
$frame blank3

// (063-066) Pain
$frame painA1 painA2 painA3 painA4

// (067-078) MELEE ATTACK, smash fist to the ground
$frame fist1 fist2 fist3 fist4 fist5 fist6 fist7 fist8
$frame fist9 fist10 fist11 fist12

// (079-094) STANDing with sword on shoulder, looking left/right
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15 stand16

// (095)
$frame blank5

// (096-102) Jump
$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7

// (103-111) Death B, fall backward
$frame deathB1 deathB2 deathB3 deathB4 deathB5 deathB6 deathB7 deathB8
$frame deathB9

// (112-121) Death A, fall forward
$frame deathA1 deathA2 deathA3 deathA4 deathA5 deathA6 deathA7 deathA8
$frame deathA9 deathA10

// (122-126) Move sword from BACK to hand
$frame drawA1 drawA2 drawA3 drawA4 drawA5

// (127-131) Move sword from SHOULDER to hand
$frame drawB1 drawB2 drawB3 drawB4 drawB5

// (132-143) Swing left-right while stationary
$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7 swing8
$frame swing9 swing10 swing11 swing12

// (144)
$frame blank6

// (145-156) Walk with sword out!
$frame walkB1 walkB2 walkB3 walkB4 walkB5 walkB6 walkB7 walkB8
$frame walkB9 walkB10 walkB11 walkB12

// (157)
$frame blank7

// (158-162) Move sword from SHOULDER to back
$frame drawC1 drawC2 drawC3 drawC4 drawC5

// (163-175) IdleC Inspect the sword
$frame idleC1 idleC2 idleC3 idleC4 idleC5 idleC6 idleC7 idleC8
$frame idleC9 idleC10 idleC11 idleC12 idleC13

// (176-180) Move sword from SHOULDER to Floor
$frame drawD1 drawD2 drawD3 drawD4 drawD5

// (181-194) IdleD chilling out with sword on floor
$frame idleD1 idleD2 idleD3 idleD4 idleD5 idleD6 idleD7 idleD8
$frame idleD9 idleD10 idleD11 idleD12 idleD13 idleD14

// (195-199) Move sword from FLOOR to hand
$frame drawE1 drawE2 drawE3 drawE4 drawE5

// (200-213) RANGE attack - fire grenade like arrows
$frame magicB1 magicB2 magicB3 magicB4 magicB5 magicB6 magicB7 magicB8
$frame magicB9 magicB10 magicB11 magicB12 magicB13 magicB14

// (214-225) RANGE ATTACK, flick sword up from ground
$frame flameT1 flameT2 flameT3 flameT4 flameT5 flameT6 flameT7 flameT8
$frame flameT9 flameT10 flameT11 flameT12

// (226-233) RANGE ATTACK, fire vorelike projectiles
$frame magicA1 magicA2 magicA3 magicA4 magicA5 magicA6 magicA7 magicA8

// (234-244) MELEE ATTACK, Charging while swinging sword
$frame charge1 charge2 charge3 charge4 charge5 charge6 charge7 charge8
$frame charge9 charge10 charge11 charge12

// Model state
float JUDGE_STAND = 1;
float JUDGE_TAUNT = 3;	// IdleB
float JUDGE_IDLEC = 5;	// IdleC
float JUDGE_IDLED = 7;	// IdleD
float JUDGE_WALK = 10;
float JUDGE_RUN = 15;
float JUDGE_MELEE = 20;
float JUDGE_JUMP = 25;
float JUDGE_MAGICA = 30;
float JUDGE_MAGICB = 32;
float JUDGE_FLAME = 34;
float JUDGE_LINE = 36;
float JUDGE_SUMMON = 38;
float JUDGE_PAIN = 40;
float JUDGE_DEAD = 42;

// Sword location (Back/Shoulder/Hand)
float JUDGE_SWBACK = 1;
float JUDGE_SWSHOULDER = 2;
float JUDGE_SWHAND = 3;
float JUDGE_SWFLOOR = 4;

// Sword changing sound fx
float JUDGE_SFXDEF = 0;
float JUDGE_SFXDRAW = 1;
float JUDGE_SFXSHEATH = 2;
float JUDGE_SFXSWOOSH = 3;
float JUDGE_SFXSILENT = 4;

float JUDGE_PHASE0 = -1;	// No boss wave/setup
float JUDGE_PHASE1 = 1;		// Intro
float JUDGE_PHASE2 = 2;		// Fighting
float JUDGE_PHASE3 = 3;		// Summon mode
float JUDGE_PHASE4 = 4;		// Death

// Different model animation speeds
float JUDGESPD_WALK = 7.4;
float JUSTICESPD_WALK = 5.8;
float JUDGESPD_SWING = 31.4;
float JUSTICESPD_SWING = 24.5;
float JUDGESPD_SMASH = 29.3;
float JUSTICESPD_SMASH = 22.9;

// Forward compiler refeence
void(float finalstate, float soundtype) judge_checksword;

// Check the tether system
float() judge_CheckTether = {
	local float currentdist;
	
	// Check for boss mode
	if (self.classtype == CT_MONJUSTICE) return FALSE;
	currentdist = vlen(self.origin - self.movelast.origin);
	// Check the most obvious first, inside tether range?
	if (currentdist < self.tetherrange) return FALSE;
	else {
		// If player or tether close to each other?
		if (infront(self.movelast) && infront(SUB_entEnemyTarget()) )
			return FALSE;
		// Stop moving around
		else return TRUE;
	}
};

// Attachment management (create, finish and remove)
void() justice_create_attachment = {
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.owner = self;
		self.attachment.classtype = CT_ATTACHMENT;
	}
};

void(float att_frame) justice_update_attachment = {
	makevectors(self.angles);
	self.attachment.origin = self.origin + attack_vector(self.meleeoffset);
	setorigin(self.attachment, self.attachment.origin);
	// Different frame count set to main model
	self.attachment.frame = att_frame;
};

void() justice_setup_attachment = {
	// Check if attachment has been setup yet
	if (!self.attachment) justice_create_attachment();
	self.attachment.state = STATE_ON;
	setmodel(self.attachment, self.weaponglow);
	self.attachment.skin = 0;
	// Display/sync with main model
	justice_update_attachment(0);
};

void() judge_standframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_standframe;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();
	
	// Beginning of animation block
	if (self.walkframe == 0) monster_idle_sound();
	
	// Update frame and move forward
	self.frame = $stand1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	
	// Finished animation set? (0-15 = 16 frames)
	if (self.walkframe > 15) {
		self.walkframe = 0;
		// Is there a walk timer active? Enough time for an idea?
		if (self.goalentity && time > (self.pausetime+0.5)) self.lip = 0;
		else self.lip = random();
		// Any chance for an idle
		if (self.lip < MON_IDLE_ANIMATION) {
			// Let blend animation happen before any walking
			if (self.pausetime > 0) 
				self.pausetime = self.pausetime + 0.5;
			// Make sure the idle animations don't repeat
			self.lip = self.lefty;
			while (self.lefty == self.lip) { 
				self.lefty = rint(random()*3); }
			if (self.lefty <= 1) {
				// IdleB = Point sword forward
				self.state = JUDGE_TAUNT;
				judge_checksword(JUDGE_SWSHOULDER,JUDGE_SFXSWOOSH);
			}
			else if (self.lefty <= 2) {
				// IdleC = Inspect the sword (for+back)
				self.state = JUDGE_IDLEC;
				judge_checksword(JUDGE_SWSHOULDER,JUDGE_SFXSWOOSH);
			}
			else {
				// Don't go into this idle animation if patrolling
				// This can last too long and be awkward to reset
				if (self.attack_switch == FALSE) {
					// IdleD = Place sword on floor
					self.state = JUDGE_IDLED;
					self.cnt = 0;
					judge_checksword(JUDGE_SWFLOOR,JUDGE_SFXSWOOSH);
				}
			}
		}
	}
	// Check for combat
	else ai_stand();	
};

//----------------------------------------------------------------------
void() judge_tauntframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_tauntframe;
	// Keep judge at path_corner idling
	if (self.pausetime > 0) self.pausetime = self.pausetime + 0.1;

	// Sword swoosh/whoosh noises
	if (self.walkframe == 3 || self.walkframe == 12) SwordSwipeSound();
	
	// Update frame and move forward
	// 00 01 02 03 04 05 06 07 -- (forward)
	//                      08    (pause)
	// 16 15 14 13 12 11 10 09    (backward)
	if (self.walkframe <= 7) self.frame = $taunt1 + self.walkframe;
	else if (self.walkframe == 8) self.frame = $taunt8;
	else self.frame = $taunt1 + (16-self.walkframe);
	
	self.walkframe = self.walkframe + 1;
	// Finished animation set?
	if (self.walkframe > 16 ) self.th_stand();
	else ai_stand();	
};

//----------------------------------------------------------------------
void() judge_idleCframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_idleCframe;
	// Keep judge at path_corner idling
	if (self.pausetime > 0) self.pausetime = self.pausetime + 0.1;

	// Sword swoosh/whoosh noises
	if (self.walkframe == 1 || self.walkframe == 22) SwordSwipeSound();
	
	// Update frame and move forward
	// 00 01 02 03 04 05 06 07 08 09 10 11 12 (forward)
	// 24 23 22 21 20 19 18 17 16 15 14 13    (backward)
	if (self.walkframe <= 12) self.frame = $idleC1 + self.walkframe;
	else self.frame = $idleC1 + (24-self.walkframe);
	
	self.walkframe = self.walkframe + 1;
	// Finished animation set?
	if (self.walkframe > 24 ) self.th_stand();
	else ai_stand();	
};

//----------------------------------------------------------------------
void() judge_idleDframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_idleDframe;
	// Keep judge at path_corner idling
	if (self.pausetime > 0) self.pausetime = self.pausetime + 0.1;

	// Update frame and move forward
	self.frame = $idleD1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	// Finished animation set?
	if (self.walkframe > 13 ) {
		// Chance to keep this animation active?
		if (random() < self.attack_chance) {
			// Animation does not end with shoulder position
			self.state = JUDGE_STAND;
			judge_checksword(JUDGE_SWSHOULDER,JUDGE_SFXSWOOSH);
		}
		// Keep looping
		else self.walkframe = 0;
		// Keep adding loop chance
		self.attack_chance = self.attack_chance + 0.2;
	}
	else ai_stand();	
};

//----------------------------------------------------------------------
void() judge_walkframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_walkframe;
	// Avoid idleD (its too long for walk patrols)
	self.attack_switch = TRUE;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Beginning of animation block
	if (self.walkframe == 0 || self.walkframe == 7) monster_footstep(FALSE);
	if (self.walkframe == 3) monster_idle_sound();

	// Update frame and move forward
	if (self.move_altwalk > 0) self.frame = $walkB1 + self.walkframe;
	else self.frame = $walk1 + self.walkframe;

	self.walkframe = self.walkframe + 1;
	// Finished animation set?
	if (self.walkframe > 11) self.walkframe = 0;
	// Jude/Justice different scales = different walks
	if (self.classtype == CT_MONJUDGE) ai_walk(JUDGESPD_WALK);
	else ai_walk(JUSTICESPD_WALK);
};

void() judge_runframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	
	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_runframe;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Beginning of animation block
	if (self.walkframe == 0 || self.walkframe == 4) monster_footstep(FALSE);
	if (self.walkframe == 2) monster_idle_sound();

	// Update frame and move forward
	self.frame = $run1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	// Finished animation set?
	if (self.walkframe > 5) self.walkframe = 0;

	// Check for less than half health for drole rampage speed
	if (self.classtype == CT_MONJUSTICE) {
		if (self.health < (self.max_health*0.5)) ai_run(28);
		else ai_run(24);
	} else {
		// Check the BOSS tether system
		if (judge_CheckTether()) ai_run(0);
		else ai_run(24);
	}
};

void() judge_fistframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	// Judge ONLY attack, make sure no Justice
	if (self.classtype == CT_MONJUSTICE) return;
	
	// Check for summoning condition?
	if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }

	self.nextthink = time + 0.1;
	self.think = judge_fistframe; // Keep looping
	if (self.walkframe >= 0  && self.walkframe <= 7) ai_face(); // Keep turning towards enemy
	self.frame = $fist1 + self.walkframe; // Update frame before so weapon glow can sync

	// Do specific stuff on certain animation frames
	if (self.walkframe == 0) {
		sound(self,CHAN_WEAPON,"ad181/judge/smash_roar.wav",1,ATTN_NORM); // Warn the player of impact
	} else if (self.walkframe == 6 && self.enemy) { // Sneaky distance check before floor smash (must have enemy as well)
		self.enemydist = range_distance(self.enemy, FALSE); // Check if player outside of slam attack range
		if (self.enemydist > MONAI_MELEEJUDGE) self.attack_sidestep = TRUE; // Cancel melee attack (fist smash ground)
	} else if (self.walkframe == 7) { // Time for fist meets ground?
		// Move toward enemy
		ai_chargenoturn(4); 
		self.meleehitsound = "ad181/judge/smash_ground.wav";
		// Pre-defined variables in defscustom.qc
		ai_shockwave(MONAI_JUDGEIMPACT, MONAI_JUDGESMASHDMG, MONAI_JUDGERADIUS, MONAI_JUDGEFORWARD, MONAI_JUDGEUP);
	}
	
	// Enemy has moved too far away for stomp attack to be useful
	// Switch to the jump attack to get closer to the enemy
	// Jump attack is instant so it can blend easily with exit point
	if (self.attack_sidestep) {
		self.walkframe = 0;
		if (random() < 0.7) self.th_jump();
		else self.th_missile();
	} else {
		// Update frame and move forward
		self.walkframe = self.walkframe + 1;
		// Finished animation set? (1-12)
		if (self.walkframe > 11) self.th_run();
	}
};

void() judge_chargeframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	// Frames don't exist for judge model anymore
	if (self.classtype == CT_MONJUDGE) return;
	
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_chargeframe;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Beginning of animation block
	// Sword swoosh/whoosh noises
	if (self.walkframe == 2 || self.walkframe == 8) SwordSwipeSound();
	// Stompy feet sounds
	else if (self.walkframe == 0 || self.walkframe == 3 ||
		self.walkframe == 6 || self.walkframe == 9) monster_footstep(FALSE);
	// Check for charging damage
	if (self.walkframe == 1 || self.walkframe == 2) ai_melee();
	else if (self.walkframe >= 5 && self.frame <= 9) ai_melee();

	// Update frame and move forward
	self.frame = $charge1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	// Finished animation set?
	if (self.walkframe > 11) self.th_run();
	// Turn towards enemy and push forward (walkmove)
	else {
		// Check for less than half health for drole rampage speed
		if (self.health < (self.max_health*0.5)) ai_faceforward(28);
		else ai_faceforward(20);
	}
};

void() judge_swingframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;

	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_swingframe;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Keep turning towards enemy
	ai_face();
	
	// Put left foot forward first!
	if (self.walkframe >= 1 && self.walkframe <= 4) {
		if (self.classtype == CT_MONJUDGE) ai_forward(JUDGESPD_SWING/4);
		else ai_forward(JUSTICESPD_SWING/4);
	}

	// Sword swoosh/whoosh noises
	if (self.walkframe == 2 || self.walkframe == 7) SwordSwipeSound();
	// sword meets flesh! or air ...
	else if (self.walkframe == 3 || self.walkframe == 8) {
		self.meleehitsound = "ad171/gibs/gibheavy.wav";
		self.meleecontact = TRUE;
		ai_meleesmash(MONAI_JUDGESWINGDMG);
	}
	
	// Update frame and move forward
	self.frame = $swing1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	// Finished animation set? (1-12)
	if (self.walkframe > 11) self.th_run();
};

void() judge_smashframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;

	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_smashframe;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Face enemy
	ai_face();
	
	// Put left foot forward first!
	if (self.walkframe >= 1 && self.walkframe <= 5) {
		if (self.classtype == CT_MONJUDGE) ai_forward(JUDGESPD_SMASH/5);
		else ai_forward(JUSTICESPD_SMASH/5);
	}

	// Sword swoosh/whoosh noises
	if (self.walkframe == 3) SwordSwipeSound();
	// sword meets flesh! or ground ...
	else if (self.walkframe == 5) {
		self.meleehitsound = "ad171/gibs/gibheavy2.wav";
		self.meleecontact = TRUE;
		ai_meleesmash(MONAI_JUDGESMASHDMG);
	}
	
	// Update frame and move forward
	self.frame = $smash1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	// Finished animation set? (1-10)
	if (self.walkframe > 9) self.th_run();
};

// (JUSTICE only) MAGIC PATTERN A - Giant arrow heads in diamond
void(float offset) judge_firemagicA = {
	local vector org, dir;
	
	if (!self.enemy) return;
	if (self.health < 1) return;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"ad181/justice/magic_fire.wav",1,ATTN_NORM);	

	// check for enemy origin (based on sight test)
	// if cannot see enemy fire at last known location
	ai_trackenemy();
	makevectors(self.angles);
	org = self.origin + attack_vector(self.meleeoffset);
	
	// Create perfect shot (no longer use offset)
	dir = normalize(self.enemy.origin - org);

	// Variable speed based on skill level with extra random spice
	self.attack_speed = SPEED_JUSTICEMISSILE + (skill * SPEED_JUSTICESKILL) + random()*10;
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_JUSTICER,self.attack_speed);
};

void() judge_magicAframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	// Justice ONLY attack, make sure no Judge (Boss)
	if (self.classtype == CT_MONJUDGE) return;

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_magicAframe;
	
	ai_face();
	// Do specific stuff on certain animation frames
	if (self.walkframe == 0) {
		// Warn the player of firing magic spikes
		sound(self,CHAN_WEAPON,"ad181/justice/magic_attack.wav",1,ATTN_NORM);
		self.frame = $magicA1;
		// Glow ball of magic infront of sword
		justice_setup_attachment();
		self.attack_track = self.enemy.origin;
	} else if (self.walkframe >= 1 && self.walkframe <= 3) {
		self.frame = $magicA2;
		justice_update_attachment(self.walkframe);
		particle_implode(self.attachment.origin, 20+random()*20, 100, 100, PARTICLE_BURST_YELLOW);
		ai_trackenemy();
	} else if (self.walkframe >= 4 && self.walkframe <= 7) { 
		self.frame = $magicA3 + (self.walkframe-4);
		justice_update_attachment(self.walkframe);
		judge_firemagicA(self.walkframe-4);
	} else if (self.walkframe == 8) {
		self.frame = $magicA7;
		SpawnExplosion(EXPLODE_BURST_SMOKE, self.attachment.origin, SOUND_RESIST_ROCKET);
		SUB_FinishAttachment();
	} else self.th_run();

	// Update frame and move forward
	self.walkframe = self.walkframe + 1;
};


// (JUSTICE only) FLAMES PATTERN 1 - wall arc infront (at players feet)

void(float fire_explode) judge_fireflamewall = {
	local vector org, eorg, torg, dir, ang;
	local float expl_type, targetang, fire_life;

	if (!self.enemy) return; // Cannot find target!
	if (self.health < 1) return; // we're dead Jim!

	// Facing angle
	ai_face();
	makevectors(self.angles);	
	org = self.origin + attack_vector(self.attack_offset);
	
	// Setup explosion origin (infront)
	eorg = org + attack_vector('16 0 16');
	
	// BIG EXPLOSION - infront and above impact point
	if (fire_explode == TRUE) {
		// Setup wall parameters
		self.proj_attarc = 1 + skill;
		// Within range? Easy = 3(-1/1), Normal = 5(-2/2), Hard/NM = 7(-3/3)
		if (self.proj_attarc > 3) self.proj_attarc = 3;
		// Invert maximum arc to create beginning/current
		self.proj_attarc = -self.proj_attarc;
		
		if (random() < 0.5) expl_type = EXPLODE_MED;
		else expl_type = EXPLODE_BIG;

		SpawnExplosion(expl_type, eorg, "ad171/wraith/attack1_explode.wav");
	}
	// SMALL EFFECTS
	else {
		// Quiet sfx + dust/smoke
		sound(self,CHAN_WEAPON,"ad181/justice/flame_fire.wav",1,ATTN_NORM);	
		if (random() > 0.5) SpawnProjectileSmoke(eorg, 200, 50, 250);
	}

	M_LaunchFlameWall(org,FLAME_RED);
	// Next arc position
	self.proj_attarc = self.proj_attarc + 1;
};

void() judge_flamewall = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	// Justice ONLY attack, make sure no Judge (Boss)
	if (self.classtype == CT_MONJUDGE) return;

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_flamewall;
	
	self.frame = $flame1 + self.walkframe;
	if (self.walkframe >= 0 && self.walkframe <=6) ai_face();
	
	// Do specific stuff on certain animation frames
	if (self.walkframe == 0) {
		// Reset rage counter
		self.attack_rage = 1;
		sound(self,CHAN_WEAPON,"ad171/wraith/attack1.wav",1,ATTN_NORM);
	}
	// BUILD up of attack ----------------------------------------
	// STRIKE into ground ----------------------------------------
	else if (self.walkframe == 6) { 
		// Sprite Count = Base (X) * (Skill * Y) Maximum = Z
		self.attack_count = SpriteCount_Flame(self.proj_attqty);
		judge_fireflamewall(TRUE);
	}
	// EXIT from attack ------------------------------------------
	else if (self.walkframe >= 12) {
		ai_face();
		// Slow down flame attacks with attack timer/blocker
		self.attack_timer = time + 1 + random();
		// Back to regular movement
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}
	// LOOP with sword in ground ---------------------------------
	else if (self.walkframe >= 7 && self.walkframe <= 10) { 
		// Check if the attack is blocked (extra wide for wall/monsters)
		if (visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) {
			// Attack is blocked, just exit wasting time
			self.walkframe = 11;  
			self.frame = $flame1 + self.walkframe;
		}
		else {
			// Keep counting down flame attacks (3/5/7 sets)
			self.attack_count = self.attack_count - 1;
			if (self.attack_count > 0) {
				// Keep looping around sword in ground cycle
				if (self.walkframe == 10) self.walkframe = 6;
				judge_fireflamewall(FALSE);
				self.nextthink = time + 0.05;
			}
			else { 
				// Sword out of ground, about to exit loop
				self.walkframe = 11;  
				self.frame = $flame1 + self.walkframe;
				// Anymore rage left? (Burst mode)
				self.attack_rage = self.attack_rage + 1;
				if (self.attack_rage <= 3-skill) {
					// Sprite Count = Base (X) * (Skill * Y) Maximum = Z
					self.attack_count = SpriteCount_Flame(self.proj_attqty);
					// Any sprite space left for flame burst attack?
					if (HazardProjectile_CheckLimit(self, self.attack_count)) {
						// Back around animation loop
						self.walkframe = 1;
					}
				}
			}
		}
	}

	// Update frame and move forward
	self.walkframe = self.walkframe + 1;
};

// (JUDGE only) MAGIC PATTERN B - Giant arrow heads in sweeping arc
void(float offset) judge_firemagicB = {
	local float projcol, fire_col;
	local vector org, dir, fire_pat;
	
	if (!self.enemy) return;
	if (self.health < 1) return;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"ad181/justice/magic_fire.wav",1,ATTN_NORM);	

	// Maximum speed, initial speed set in launch_projectile
	self.attack_speed = SPEED_JUDGEMISSILE + (skill * SPEED_JUDGESKILL);
	
	// check for enemy origin (based on sight test)
	// if cannot see enemy fire at last known location
	ai_trackenemy();
	makevectors(self.angles);
	org = self.origin + attack_vector(self.meleeoffset);
	
	// Create an arc pattern based on skill level
	fire_pat = '0 0 0';
	fire_pat_y = -2 + offset;
	org = org + attack_vector(fire_pat*16);
	
	// Initially travels outward using sweep/arc pattern
	dir = v_forward + (v_right * (fire_pat_y*0.2));
	// Setup colour scheme (was original red/blue flames)
	projcol = CT_PROJ_JUDGER;
	fire_col = FLAME_RED;
	
	// Skill based projectile fire 0=easy, 1=normal, 2=hard, 3=nm
	if (offset <= skill)
		launch_projectile(org,dir,NO_SPIN,projcol,self.attack_speed);
	
	// Chance of flame off first (offset=0) swing of sword
	if (offset == 0) {
		// Any sprite space left for flame burst attack?
		if (random() < 0.1 && HazardProjectile_CheckLimit(self, 1)) {
			// Fire that flame!
			dir = v_forward * (100 + (100 * random()));
			// target, origin, v_forward, colour, size, lifetime, speed
			Launch_Flame (self, org, dir, fire_col, FLAME_TINY, -1, SPEED_FLAME);		
		}
		// Majority of the time, spawn projectile dust
		else SpawnVelocitySmoke(org, dir+v_up, 200, 50);
	}
	// Spawn some projectile dust instead
	else SpawnVelocitySmoke(org, dir+v_up, 200, 50);
};

void() judge_magicBframe = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	// Boss ONLY attack, make sure no Justice
	if (self.classtype == CT_MONJUSTICE) return;

	if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_magicBframe;
	
	ai_face();
	self.frame = $magicB1 + self.walkframe;

	// Do specific stuff on certain animation frames
	if (self.walkframe == 0) {
		// Warn the player of firing magic
		sound(self,CHAN_WEAPON,"ad181/justice/magic_attack.wav",1,ATTN_NORM);
		self.attack_track = self.enemy.origin;
	}
	// Swinging arm backward
	else if (self.walkframe >= 1 && self.walkframe <= 4) {
		ai_trackenemy();
	}
	// Fire projectiles 1-4 based on skill level
	else if (self.walkframe >= 5 && self.walkframe <= 8) {
		judge_firemagicB(self.walkframe-5);
	}
	
	// Update frame and move forward
	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 13) self.th_run();
};

void() judge_flameline = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;
	// Boss ONLY attack, make sure no Justice
	if (self.classtype == CT_MONJUSTICE) return;

	// Check for boss wave trigger events
	if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_flameline;
	
	if (self.walkframe <= 6) ai_face();
	self.frame = $flameT1 + self.walkframe;
	// Do specific stuff on certain animation frames
	// Check for last frame (exit) first!
	if (self.walkframe == 0) { 
		sound(self,CHAN_WEAPON,"ad171/wraith/attack1.wav",1,ATTN_NORM);
	} else if (self.walkframe == 6) {
		judge_fireflameline();
	}
	else if (self.walkframe > 11) {
		// Slow down flame attacks with attack timer/blocker
		self.attack_timer = time + 1 + random();
		// Back to regular movement
		self.attack_state = AS_STRAIGHT;
		self.think = self.th_run;
	}

	// Update frame and move forward
	self.walkframe = self.walkframe + 1;
};

// Lunge forward (leaving ground) and do heavy damage on touch
void() judge_JumpTouch = {
	local float ldmg;
	
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;

	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	ai_jumpbreakable(30);			// Damage any breakables
	self.touch = SUB_Null;			// No more touching
	self.count = self.count + 1;	// Total amount of touch jumps
	self.think = self.th_jumpexit;	// Exit frame
	self.nextthink = time + 0.1;
		
	// Keep track of how many times touched the same object
	if (self.jumptouch == other) self.jump_flag = time + MONAI_JUMPTIMEOUT;
	self.jumptouch = other;			// Keep track of touch target

	// Do not damage other demons with jump attacks
	if (self.classtype != other.classtype && other.takedamage) {
		if ( vlen(self.velocity) > 300 ) {
			ldmg = 20 + 10*random();
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
			T_Damage (other, self, self, ldmg, DAMARMOR);	
			SpawnMeatSpray(self, other, FALSE);
			SpawnMeatSpray(self, other, FALSE);
			SpawnMeatSpray(self, other, FALSE);
		}
	}

	// Is the Judge floating in the air?
	if (!checkbottom(self)) {
		// Is the Judge standing on something?		
		if (self.flags & FL_ONGROUND) {	
			// Do an extra jump if got the count
			if (self.count < 2) self.think = self.th_jump;
		}
	}
	// Go straight into landing animation
	else self.th_jumpexit();
};

void() judge_jump1 = [$jump1, judge_jump2 ] { ai_face(); };
void() judge_jump2 = [$jump2, judge_jump3 ] {
	ai_face();
	// Same for Judge and Justice
	self.touch = judge_JumpTouch;
	sound(self,CHAN_WEAPON,"ad181/justice/leap1.wav",1,ATTN_NORM);
	if (self.classtype == CT_MONJUDGE)
		self.jump_flag = time + MONAI_JUMPJUDGETIME;
	else
		self.jump_flag = time + MONAI_JUMPJUSTICETIME;

	makevectors(self.angles);
	self.velocity = (v_forward*self.jumpdist_x) + ('0 0 1'*self.jumpdist_z);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.oldorigin = self.origin;
};

void() judge_jump3 = [$jump3, judge_jump4 ] {};
void() judge_jump4 = [$jump4, judge_jump5 ] {};
void() judge_jump5 = [$jump5, judge_jump5 ] {
	// Double check monster is still falling?
	if (CheckZeroVector(self.velocity) || self.oldorigin == self.origin) {
		self.ideal_yaw = random() * 360; 	//random jump angle
		self.think = self.th_jumpexit;
	}
	self.oldorigin = self.origin;
};

// Landed with a thud
void()	judge_jump6 = [$jump6, judge_jump7 ] { monster_footstep(FALSE); };
void()	judge_jump7 = [$jump7, judge_run ] {
	// Make sure attack state is reset (can then decide melee or range)
	self.attack_state = AS_STRAIGHT; ai_resetangles(); ai_face(); };

void() judge_jump = {
	// Entered combat once
	self.attack_active = TRUE;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();
	
	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	self.state = JUDGE_JUMP;
	// No pain + make sword in correct position
	self.pain_finished = time + 1;
	judge_checksword(JUDGE_SWHAND, JUDGE_SFXDEF);
};


// Entry point for Stand, Walk and Run monster states
// All have to cope with sword out/on back blend animations
void() judge_stand = { 
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Let blend animation happen before any walking
	if (self.pausetime > 0 && self.weaponstate != JUDGE_SWSHOULDER) 
		self.pausetime = self.pausetime + 0.5;
	// Standing around, check sword status first
	self.state = JUDGE_STAND;
	judge_checksword(JUDGE_SWSHOULDER, JUDGE_SFXDEF);
};

void() judge_walk =  {
	// Start walking
	self.state = JUDGE_WALK;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Which walk animation to use?
	if (self.move_altwalk > 0) judge_checksword(JUDGE_SWHAND, JUDGE_SFXDEF);
	else judge_checksword(JUDGE_SWBACK, JUDGE_SFXDEF);
};

void() judge_run = {
	// Don't start combat with a jump!
	if (!self.attack_active) self.jump_flag = time + 2;
	// Entered combat once
	self.attack_active = TRUE;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	self.state = JUDGE_RUN; 
	judge_checksword(JUDGE_SWHAND, JUDGE_SFXDEF);
};

void() judge_melee = {
	// Entered combat once
	self.attack_active = TRUE;
	// Reset jump attack decision branch
	self.attack_sidestep = FALSE;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	self.state = JUDGE_MELEE; 
	// No pain + make sword in correct position
	self.pain_finished = time + 1;
	judge_checksword(JUDGE_SWHAND, JUDGE_SFXDEF);
};

void() judge_range = {
	// Entered combat once
	self.attack_active = TRUE;
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	// Flame LINE and MagicB = JUDGE (boss) only
	if (self.classtype == CT_MONJUDGE) {
		// Magic range will always reach a monster
		if (self.enemy.flags & FL_MONSTER) self.state = JUDGE_MAGICB;
		else {
			// re-check enemy distance
			self.enemydist = range_distance(self.enemy, TRUE);
			// Flame line limited distance
			if (self.enemydist < MONAI_FLAMELINEJUDGE) self.state = JUDGE_LINE;
			else self.state = JUDGE_MAGICB;
			
			// Forced pause between FLAME attacks
			if (self.attack_timer < time) {
				// Any sprite space left for hazard projectiles?
				if ( !(HazardProjectile_CheckLimit(self, FLAME_TRCOUNT)) )
					self.state = JUDGE_MAGICB;
			}
			// Do magic attack instead
			else self.state = JUDGE_MAGICB;
		}
	} else { // Flame BURST and MagicA = JUSTICE only
		// Magic range will always reach a monster
		if (self.enemy.flags & FL_MONSTER) self.state = JUDGE_MAGICA;
		else {
			// Easy/Normal = get more spikes Hard/NM = get more flames
			// Easy=0.6, Normal=0.5, Hard=0.4, NM=0.3
			self.attack_chance = 0.6 - (skill * 0.1);
			if (random() > self.attack_chance) self.state = JUDGE_FLAME;
			else self.state = JUDGE_MAGICA;
			// Flame attack does not go up stairs or ledges very well
			if (self.enemy.origin_z > (self.origin_z+MONAI_STEPLARGE)) 
				self.state = JUDGE_MAGICA;
			
			// Forced pause between FLAME attacks
			if (self.attack_timer < time) {
				// Sprite Count = Base (X) * (Skill * Y) Maximum = Z
				self.attack_count = SpriteCount_Flame(self.proj_attqty);
				// Any sprite space left for hazard projectiles? (min = 1 wave)
				if ( !(HazardProjectile_CheckLimit(self, self.attack_count)) )
					self.state = JUDGE_MAGICA;
			}
			// Do magic attack instead
			else self.state = JUDGE_MAGICA;
		}
	}
	
	// No pain + make sure sword in correct position
	self.pain_finished = time + 1;
	judge_checksword(JUDGE_SWHAND, JUDGE_SFXDEF);
};


// Sword position blending, checked by all functions
// Blend animations ( Back / Shoulder / Hand )
//----------------------------------------------------------------------
void() judge_finishsword = {
	self.walkframe = self.attack_chance = 0;
	// Where to go next?
	if (self.state == JUDGE_STAND) judge_standframe();
	else if (self.state == JUDGE_TAUNT) judge_tauntframe();
	else if (self.state == JUDGE_IDLEC) judge_idleCframe();
	else if (self.state == JUDGE_IDLED) judge_idleDframe();
	else if (self.state == JUDGE_WALK) judge_walkframe();
	else if (self.state == JUDGE_MELEE) {
		if (self.classtype == CT_MONJUDGE) {
			// Special setup for monster infighting
			if (self.enemy.flags & FL_MONSTER) judge_smashframe();
			// Close enough for classic swing left/right
			else if (ai_checkmelee(self.meleerange,self.meleerangez)) 
				judge_swingframe();
			// Fist smash ground (Boss ONLY)
			else judge_fistframe();
		} else {
			// Simple flat (2d) range check
			self.enemydist = range_distance(self.enemy, TRUE);
			// Overhead smash or charging (swing + run)
			if (self.enemydist < MONAI_CLOSEJUSTICE) judge_smashframe();
			else judge_chargeframe();
		}
	}
	else if (self.state == JUDGE_JUMP) judge_jump1();
	else if (self.state == JUDGE_MAGICA) judge_magicAframe();
	else if (self.state == JUDGE_MAGICB) judge_magicBframe();
	else if (self.state == JUDGE_LINE) judge_flameline();
	else if (self.state == JUDGE_FLAME) judge_flamewall();
	// Default = in combat and running
	else judge_runframe();
};

void() judge_movesword = {
	// Check for boss wave trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_movesword;
	// Sword sound(defined beforehand)
	if (self.walkframe == 2) {
		// Allow for sound override
		if (self.blendsfx == JUDGE_SFXDRAW) {
			sound(self,CHAN_WEAPON,"ad181/justice/sword_draw.wav",1,ATTN_NORM);
		} else if (self.blendsfx == JUDGE_SFXSHEATH) {
			sound(self,CHAN_WEAPON,"ad181/justice/sword_sheath.wav",1,ATTN_NORM);
		}
		else if (self.blendsfx == JUDGE_SFXSWOOSH) SwordSwipeSound();
	}
	// Step through animation (check direction)
	if (self.blenddir == 1) self.frame = self.blendstart + self.walkframe;
	else self.frame = self.blendstart + (4-self.walkframe);
	self.walkframe = self.walkframe + 1;
	
	// Check if finished animation
	if (self.walkframe > 4) judge_finishsword();
};

void(float finalstate, float soundtype) judge_checksword = {
	// Judge Dead stops here!
	if (self.health < 1) return;
	if (self.state == JUDGE_DEAD) return;

	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	self.walkframe = 0;
	// Is sword in right position? - Move on to next animation
	if (finalstate == self.weaponstate) judge_finishsword();
	else {
		// Setup defaults
		self.blendstart = $drawA1; self.blenddir = 1;
		self.blendsfx = soundtype;

		// drawA1 = Move sword from BACK to hand
		// drawB1 = Move sword from HAND to shoulder
		// drawC1 = Move sword from SHOULDER to back
		// drawD1 = Move sword from SHOULDER to floor
		// drawE1 = Move sword from FLOOR to hand
		if (self.weaponstate == JUDGE_SWBACK) {
			if (finalstate == JUDGE_SWSHOULDER) {
				//dprint("BACK --> SHOULDER\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXDRAW;
				self.blendstart = $drawC1; self.blenddir = -1; }
			else if (finalstate == JUDGE_SWHAND) {
				//dprint("BACK --> HAND\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXDRAW;
				self.blendstart = $drawA1; self.blenddir = 1; }
			else if (finalstate == JUDGE_SWFLOOR) {
				//dprint("BACK --> FLOOR\n");
				// blend does not exist, use shoulder -> floor
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawD1; self.blenddir = 1;
			}
		}
		else if (self.weaponstate == JUDGE_SWSHOULDER) {
			if (finalstate == JUDGE_SWBACK) {
				//dprint("SHOULDER --> BACK\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawC1; self.blenddir = 1; }
			else if (finalstate == JUDGE_SWHAND) {
				//dprint("SHOULDER --> HAND\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawB1; self.blenddir = -1; }
			else if (finalstate == JUDGE_SWFLOOR) {
				//dprint("SHOULDER --> FLOOR\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawD1; self.blenddir = 1;
			}
		}
		else if (self.weaponstate == JUDGE_SWHAND) {
			if (finalstate == JUDGE_SWBACK) {
				//dprint("HAND --> BACK\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXDRAW;
				self.blendstart = $drawA1; self.blenddir = -1; }
			else if (finalstate == JUDGE_SWSHOULDER) {
				//dprint("HAND --> SHOULDER\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawB1; self.blenddir = 1; }
			else if (finalstate == JUDGE_SWFLOOR) {
				//dprint("HAND --> FLOOR\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawE1; self.blenddir = -1;
			}
		}
		else if (self.weaponstate == JUDGE_SWFLOOR) {
			if (finalstate == JUDGE_SWBACK) {
				//dprint("FLOOR --> BACK\n");
				// blend does not exist, use floor -> shoulder
				if (soundtype == 0) self.blendsfx = JUDGE_SFXDRAW;
				self.blendstart = $drawD1; self.blenddir = -1; }
			else if (finalstate == JUDGE_SWSHOULDER) {
				//dprint("FLOOR --> SHOULDER\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawD1; self.blenddir = -1; }
			else if (finalstate == JUDGE_SWHAND) {
				//dprint("FLOOR --> HAND\n");
				if (soundtype == 0) self.blendsfx = JUDGE_SFXSHEATH;
				self.blendstart = $drawE1; self.blenddir = -1; }
		}
	
		// Setup counter and update state
		self.weaponstate = finalstate;
		// Start blend animation
		judge_movesword();
	}
};


// Fire random plasma spikes while summoning gaunt minions
void() Fire_judgePlasma = {
	local vector org, ovec, rndvec, destvec;

	makevectors(self.angles);
	ovec = self.attack_offset3 + (random() * self.attack_offset4);
	org = self.origin + attack_vector(ovec);
	rndvec = vecrand(0,50,TRUE);
	destvec = normalize(rndvec);
	launch_projectile(org,destvec,NO_SPIN,CT_SUMMONLIGHT,SPEED_REFLECTION);
};

void() Spawn_judgeMin = {
	// Fire off some random plasma/lightning
	Fire_judgePlasma();
	
	// Cycle through spawn targets and spawn Tfog + Gaunt
	self.lip = self.attack_summon;
	while(self.lip > 0) {
		self.bossminchain.think = spawn_tfog_self;
		self.bossminchain.nextthink = time + 0.01 + random()*0.3;
		self.pos1 = self.bossminchain.origin;
		SpawnMinionInRadius(self.pos1); // If the spawn locaiton all clear, spawn something!
		self.bossminchain = self.bossminchain.entchain; // Next spawn point
		self.lip = self.lip - 1;
	}
};

void() judge_summonframe = {
	// Keep looping
	self.nextthink = time + 0.1;
	self.think = judge_summonframe;
	self.part_exitbusy = TRUE;

	// Only turn towards player on intro/outro
	if (self.walkframe < 4 || self.walkframe > 9) ai_face();
	
	// Beginning of animation block
	// INTRO sequence --------------------------------------
	if (self.walkframe >= 0 && self.walkframe <= 3) {
		self.frame = $summon1 + self.walkframe;
		// Setup animation sound/loop counter
		if (self.walkframe == 0) sound(self,CHAN_WEAPON,"ad181/justice/magic_attack.wav",1,ATTN_NORM);
	}
	// MAIN loop -------------------------------------------
	else if (self.walkframe >= 4 && self.walkframe <= 9) {
		self.frame = $summon1 + self.walkframe;
		if (self.walkframe == 9 && self.attack_count == 1) Spawn_judgeMin();
		else Setup_NourMinChain('0 0 0',0);
	}
	// OUTRO sequence --------------------------------------
	if (self.walkframe > 8) {
		// Keep counting down loop (6 frames)
		self.attack_count = self.attack_count - 1;
		if (self.attack_count > 0) self.walkframe = 3;
		// Setup outro (0-3 backward)
		else self.frame = $summon1 + (13-self.walkframe);		
	}
	
	// Next frame / loop
	self.walkframe = self.walkframe + 1;
	
	// End of sequence? ------------------------------------
	if (self.walkframe > 13) {
		self.walkframe = 0;
		// Restore ammo resistance to default
		Resist_ChangeType(self, FALSE);
		self.style = JUDGE_PHASE2;	// Fight mode
		self.part_exitbusy = FALSE;
		self.th_run();
	}
};

// Make sure boss ONLY active for this attack
void() judge_summon = {
	if (self.classtype == CT_MONJUSTICE) { self.think = self.th_run; return; }

	self.nextthink = time + 0.1;
	self.think = judge_summonframe; // Always reset the think
	nour_powersummon();
	self.walkframe = 0; self.attack_count = 2;
	judge_summonframe(); // Start spawning stuff!
};

// Pain, Death and Taxes!
void()	judge_painA1 = [$painA1, judge_painA2 ] {};
void()	judge_painA2 = [$painA2, judge_painA3 ] {};
void()	judge_painA3 = [$painA3, judge_painA4 ] {};
void()	judge_painA4 = [$painA4, judge_run ] {};

void(entity inflictor, entity attacker, float damage) judge_pain = {
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) SUB_FinishAttachment();

	if (self.classtype == CT_MONJUDGE) {
		// Check for boss wave trigger events
		if (SUB_BossWaveCheck(FALSE)) { self.th_summon(); return; }
	}

	// No pain animations if jumping
	//if (self.touch == judge_JumpTouch) return;

	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		self.pain_finished = time + 2;
		// Only do pain animation if required
		if (self.pain_check == 1 || self.pain_check == 2) judge_painA1();
	}
};

void() judge_dieA1 = [$deathA1, judge_dieA2 ] {};
void() judge_dieA2 = [$deathA2, judge_dieA3 ] { monster_check_gib(); };
void() judge_dieA3 = [$deathA3, judge_dieA4 ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() judge_dieA4 = [$deathA4, judge_dieA5 ] {};
void() judge_dieA5 = [$deathA5, judge_dieA6 ] {};
void() judge_dieA6 = [$deathA6, judge_dieA7 ] {
	sound(self,CHAN_WEAPON,GIB_SOUND_METALA,1,ATTN_NORM); };
void() judge_dieA7 = [$deathA7, judge_dieA8 ] {};
void() judge_dieA8 = [$deathA8, judge_dieA9 ] {};
void() judge_dieA9 = [$deathA9, judge_dieA10 ] { monster_death_postcheck(); };
void() judge_dieA10 = [$deathA10, judge_dieA10 ] { monster_deadbody_check(); };

//----------------------------------------------------------------------
void() judge_dieB1 = [$deathB1, judge_dieB2 ] {};
void() judge_dieB2 = [$deathB2, judge_dieB3 ] { monster_check_gib(); };
void() judge_dieB3 = [$deathB3, judge_dieB4 ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() judge_dieB4 = [$deathB4, judge_dieB5 ] {};
void() judge_dieB5 = [$deathB5, judge_dieB6 ] {};
void() judge_dieB6 = [$deathB6, judge_dieB7 ] {};
void() judge_dieB7 = [$deathB7, judge_dieB8 ] {
	sound(self,CHAN_WEAPON,GIB_SOUND_METALA,1,ATTN_NORM); };
void() judge_dieB8 = [$deathB8, judge_dieB9 ] { monster_death_postcheck(); };
void() judge_dieB9 = [$deathB9, judge_dieB9 ] { monster_deadbody_check(); };

//----------------------------------------------------------------------
void() judge_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();
	
	self.state = JUDGE_DEAD;	// Finally Judge Dead!
	self.effects = 0;			// Remove effects on death
	// Hide any glowing/sprite attachments
	if (self.classtype == CT_MONJUSTICE) {
		SUB_FinishAttachment();
		SUB_RemoveAttachment();
	}
	
	// Check for any final trigger events
	if (self.classtype == CT_MONJUDGE) {
		if (self.message2 != "") trigger_strs(self.message2,self);
	}
	
	// regular death
	if (!self.gibbed) {
		sound(self,CHAN_VOICE, self.death_sound,1,ATTN_NORM);
		if (random() > 0.5) judge_dieA1();
		else judge_dieB1();
	}
};

void() judge_spawntether = {
	// temporary tether point
	self.movelast = spawn();
	self.movelast.owner = self;
	self.movelast.classtype = CT_TETHERENT;
	self.movelast.movetype = MOVETYPE_NONE;
	self.movelast.solid = SOLID_NOT;
	self.movelast.origin = self.origin;
	setsize (self.movelast, VEC_ORIGIN, VEC_ORIGIN);
};

// INTRO PHASE (??)
void() judge_readyframe = {
	self.takedamage = DAMAGE_AIM;	// Can take damage
	self.style = JUDGE_PHASE2;		// Time to fight!
	Resist_ChangeType(self,FALSE);	// restore resistance
	
	// Let the judicator get angry and find targets
	// or stand or walk or run ...
	monster_targets();
	
	//if (self.enemy) self.th_run();	// Hunt the player
	//else self.th_stand();			// Wait for the player
};

// Setup BOSS Judicator after trigger event
void() judge_awake = {
	// make sure boss mode selected
	if (self.classtype == CT_MONJUSTICE) return;

	self.use = SUB_Null;			// No more triggers
	self.style = JUDGE_PHASE1;		// Bursting intro sequence
	self.flags = FL_MONSTER;		// Reset flag (no user settings)
	self.frame = $stand1; self.skin = self.exactskin;
	monster_bbox();					// Setup bounding box

	self.takedamage = DAMAGE_NO;	// Still immune to damage
	self.yaw_speed = 20;			// Average Speed
	self.velocity = '0 0 0';		// Make sure stationary
	self.walkframe = 0;				// reset for animation
	self.attack_summon = skill + 1;	// Total amount of minions

	if (self.tetherrange < 32) self.tetherrange = MONAI_MAXJUDGE;
	if (self.bossminbase <= 64) self.bossminbase = MONAI_BOSS_SUMDIST;
	if (self.bossminrnd <= 64) self.bossminrnd = MONAI_BOSS_SUMRND;

		// skill modifier : Easy = 1, Normal = 2, Hard/NM = 3
	if (self.attack_summon > 3) self.attack_summon = 3;
	// Setup minion chain entity system
	if (nour_minionsetup()) {
		dprint("\b[JUDGE]\b Cannot create minion chain!\n");
		spawn_marker(self.origin+'0 0 32','0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}
		
	// Check for tether system (special target field)
	if (self.tethertarget == "") {
		dprint("\b[JUDGE]\b Generated tetherpoint!\n");
		judge_spawntether();
	}
	// Find the defined tether marker
	else self.movelast = find(world,targetname,self.tethertarget);
	
	// Does the tether entity exist?
	if (!self.movelast) {
		dprint("\b[JUDGE]\b Tether target not found!\n");
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}

	// Show BOSS tetherpoint
	spawn_marker(self.movelast.origin+'0 0 8','0 0 0',0,SPNMARK_RED);
	
	// Zap (50K damage) anything in its place!
	if (self.nospawndamage == 0) 
		spawn_tdeath(self.origin, self);
	// Don't show spawning effect if nogfx
	if (!(self.spawnflags & MON_SPAWN_NOGFX)) 
		spawn_tfog(self.origin);

	// Start spawning BOSS
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, self.mdl);					// Setup model
	setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	Resist_Save(self);				// Save for Later
	Resist_ChangeType(self,TRUE);	// resist everything

	// Reset all combat flags and counters
	self.deadflag = DEAD_NO;
	self.liquidbase = self.liquidcheck = 0;
	self.dmgcombined = self.dmgtimeframe = 0;

	// Setup boss waves and overall health
	if (self.bosswave < 1) self.bosswavetotal = 4;
	else self.bosswavetotal = self.bosswave;
	
	// Setup boss waves and overall health
	self.bosswave = 1;
	if (self.bosswaveqty < 1) self.bosswaveqty = 500;
	self.max_health = self.bosswavetotal * self.bosswaveqty;
	// Setup boss wave HP + trigger event
	SUB_BossWaveSetupHP();

	self.pain_finished = time + 3;		// Make pain go away
	self.attack_finished = time + 2;	// Reset attack system
	
	// Reset all combat entities
	self.enemy = self.goalentity = self.movetarget = world;

	// Trigger all spawning events (optional)
	if (self.message != "") {
		trigger_strs(self.message, self);
		self.message = "";
	}
	
	// Make sure all death triggers are setup ready
	self.message2 = self.target;
	self.target = self.target2 = self.deathtarget = "";

	// Time for an intro?
	judge_readyframe();
};

void() monster_judicator_precache = {
	precache_model("progs/ad181/mon_judge.mdl");
	precache_model("progs/ad181/h_judge.mdl");
	precache_model("progs/ad181/w_judgesword.mdl");
	precache_model("progs/ad181/gib_judgeboot.mdl");
	precache_model("progs/ad181/gib_judgeshould.mdl");
	precache_model(MODEL_PROJ_RINGSHOCK); // Smash the floor with fist
	PreCache_Flame(); // Flames + explosions
	precache_model(MODEL_PROJ_JUDGER); // Projectile model
	precache_sound("ad181/justice/idle1.wav");
	precache_sound("ad181/judge/smash_roar.wav");
	precache_sound("ad181/judge/smash_ground.wav");
	precache_sound("ad181/justice/magic_attack.wav"); // Arrow attack
	precache_sound("ad181/justice/magic_fire.wav");
	precache_sound("ad181/justice/flame_fire.wav");
	precache_sound("ad181/justice/leap1.wav"); // Crazy leapin! (re-used from player)
	precache_sound("ad181/justice/sight1.wav");
	precache_sound("ad181/justice/pain1.wav");
	precache_sound("ad181/justice/death1.wav");
	precache_sound("ad171/eidolon/elec_arch1.wav");
	precache_sound("ad171/eidolon/elec_arch2.wav");
	precache_sound("ad181/justice/sword_draw.wav"); // New sword sweep/slash sounds
	precache_sound("ad181/justice/sword_sheath.wav");
};

// QUAKED monster_judicator (1 0 0) (-32 -32 -24) (32 32 80) Ambush
void() monster_judicator = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)
	
	self.mdl = "progs/ad181/mon_judge.mdl";			// Judicator Knight
	self.headmdl = "progs/ad181/h_judge.mdl";			// Bloody head
	self.gib1mdl = "progs/ad181/w_judgesword.mdl";	// Broken sword
	self.gib2mdl = "progs/ad181/gib_judgeboot.mdl";	// Boot lying down
	self.gib3mdl = "progs/ad181/gib_judgeshould.mdl";	// Shoulder pad
	self.gib1sound = GIB_IMPACT_METALA;
	self.idle_sound = "ad181/justice/idle1.wav";

	// Skin/Projectile/Flanes coloured differences (RED or BLUE)
	// Ran out of time trying to create good blue flames
	// Might add later in a patch, atm its just a skin change
	if (self.spawnflags & MON_JUDGE_BLUE) self.skin = 1;
	else self.skin = 0;
	
	self.sight_sound = "ad181/justice/sight1.wav"; // Strange roar of monks!
	self.pain_sound = "ad181/justice/pain1.wav";
	self.death_sound = "ad181/justice/death1.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_XMASSIVE;
	self.gibhealth = -60;
	self.gibbed = FALSE;				// Starts complete
	self.pain_flinch = 400;				// Really low chance of pain
	self.pain_longanim = FALSE;			// No axe advantage
	self.pain_timeout = 2;				// High pain level
	if (self.infightextra <= 0) self.infightextra = 4; // High infighting damage
	self.steptype = FS_TYPELARGE;		// Giant feet
	self.poisonous = FALSE;				// No Poison version
	self.no_liquiddmg = TRUE;			// Immune to slime/lava
	self.style = JUDGE_PHASE0;			// No waves setup
	self.state = JUDGE_STAND;			// Default state
	self.weaponstate = JUDGE_SWSHOULDER;// Default sword position
	self.attack_switch = FALSE;			// Avoid idleD if patrolling
	self.move_altwalk = FALSE;			// No alternative walk
	self.attack_active = FALSE;			// Not started combat yet
	self.meleerange = MONAI_CLOSEJUDGE;	// swing/smash range
	self.meleerangez = MONAI_MELEEZTALL;
	self.meleecontact = FALSE;			// Smash contact sound
	self.meleeoffset = '24 0 32';		// Arrow spawn height
	self.attack_offset = '32 0 -16';	// Firewall ground explosion
	self.attack_offset2 = '48 0 0';		// Fireline starting point
	self.attack_offset3 = '24 8 112';	// Hilt of summon sword
	self.attack_offset4 = '-16 -12 32';	// Movement vector along sword
	if (self.deathstring == "") self.deathstring = " was judged unworthy by The Judicator\n";
	self.attack_count = self.attack_timer = 0; // Setup default timer/counters for flame attacks
	self.part_exitpuff = self.part_exitsound = TRUE;
	self.part_exitfade = self.part_exitbusy = FALSE;
	if (self.proj_trqty <= 1) self.proj_trqty = 32;
	if (self.proj_trdist <= 1) self.proj_trdist = 32;
	if (self.proj_limit > PROJ_MAXLIMIT) self.proj_limit = PROJ_MAXLIMIT; // Default skill speed = 0=0.10, 1=0.08, 2=0.06, 3=0.04
	if (CheckZeroVector(self.proj_attqty)) self.proj_attqty = '3 2 7'; // Setup default Proj Count = Base (X) * (Skill * Y) Maximum = Z
	if (CheckZeroVector(self.jumpdist)) self.jumpdist = '450 0 225'; // Default jump forward/up distance
	if (self.jumprange_x <= 0) self.jumprange_x = MONAI_JUMPJUDGENEAR;
	if (self.jumprange_y <= self.jumprange_x) self.jumprange_y = MONAI_JUMPJUDGEFAR;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_rockets = self.resist_cells = 0.75;
	self.resist_multi_rockets = 0.75;
	self.resist_plasma = 0.75;
	self.reflectlightning = TRUE;	// Reflect lightning strikes
	self.reflectplasma = TRUE;		// Reflect plasma projectiles
	self.th_checkattack = JudgeCheckAttack;
	self.th_stand = judge_stand;
	self.th_walk = judge_walk;
	self.th_run = judge_run;
	self.th_melee = judge_melee;
	self.th_charge = SUB_Null;
	self.th_missile = judge_range;
	self.th_jump = judge_jump;
	self.th_jumpexit = judge_jump6;
	self.th_summon = judge_summon;
	self.th_pain = judge_pain;
	self.th_die = judge_die;
	self.classtype = CT_MONJUDGE;
	self.classgroup = CG_DCAPTAIN;
	self.classmove = MON_MOVEWALK;
	self.health = self.max_health = MEGADEATH;
	self.pain_finished = LARGE_TIMER;		
	self.takedamage = DAMAGE_NO;	// Immune to damage
	self.flags = FL_MONSTER;		// Reset flag (no user settings)
	self.bossflag = TRUE;			// Boss flag (like FL_MONSTER)		
	self.reflectaxe = TRUE;			// Prevent axe damage
	self.frame = 0;
	self.exactskin = self.skin; // Devmarker function changes skins, save for later
	if (self.minion_name == "") {
		self.minion_name = "monster_gaunt";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }
	monster_start();

	// Wait for trigger event
	if (self.targetname != "") {
		self.use = judge_awake;
	} else {
		self.flags = FL_MONSTER;		// Reset flag (no user settings)
		self.frame = $stand1; self.skin = self.exactskin;
		self.takedamage = DAMAGE_NO;	// Still immune to damage
		self.yaw_speed = 20;			// Average Speed
		self.attack_summon = skill + 1;	// Total amount of minions
		if (self.tetherrange < 32) self.tetherrange = MONAI_MAXJUDGE;
		if (self.bossminbase <= 64) self.bossminbase = MONAI_BOSS_SUMDIST;
		if (self.bossminrnd <= 64) self.bossminrnd = MONAI_BOSS_SUMRND;

			// skill modifier : Easy = 1, Normal = 2, Hard/NM = 3
		if (self.attack_summon > 3) self.attack_summon = 3;

		// Setup minion chain entity system
		if (nour_minionsetup()) dprint("\b[JUDGE]\b Cannot create minion chain!\n");
			
		// Check for tether system (special target field)
		if (self.tethertarget == "") {
			judge_spawntether();
		} else self.movelast = find(world,targetname,self.tethertarget); // Find the defined tether marker
		
		// Does the tether entity exist?
		if (!self.movelast) {
			dprint("\b[JUDGE]\b Tether target not found!\n");
			spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
			entity_hide(self);
			return;
		}

		// Setup boss waves and overall health
		if (self.bosswave < 1) self.bosswavetotal = 4;
		else self.bosswavetotal = self.bosswave;
		
		// Setup boss waves and overall health
		self.bosswave = 1;
		if (self.bosswaveqty < 1) self.bosswaveqty = 500;
		self.max_health = self.bosswavetotal * self.bosswaveqty;
		// Setup boss wave HP + trigger event
		SUB_BossWaveSetupHP();

		// self.pain_finished = time + 3;		// Make pain go away
		// self.attack_finished = time + 2;	// Reset attack system
		
		// Reset all combat entities
		self.enemy = self.goalentity = self.movetarget = world;

		// Trigger all spawning events (optional)
		if (self.message != "") {
			trigger_strs(self.message, self);
			self.message = "";
		}
		
		// Make sure all death triggers are setup ready
		self.message2 = self.target;
		self.target = self.target2 = self.deathtarget = "";

		// monster_start();
		self.max_health = self.bosswavetotal * self.bosswaveqty;
	}
};

void() monster_justice_precache = {
	precache_model ("progs/ad181/mon_justice.mdl");
	precache_model ("progs/ad181/h_justice.mdl");
	precache_model ("progs/ad181/w_justicesword.mdl");
	precache_model ("progs/ad181/gib_justiceboot.mdl");
	precache_model ("progs/ad181/gib_justiceshould.mdl");
	PreCache_Flame(); // Flames + explosions
	precache_model (MODEL_PROJ_JUDGER); // Projectile model
	precache_model ("progs/ad181/s_judgemagic.spr");
	precache_sound("ad181/justice/idle1.wav");
	precache_sound("ad171/gibs/gibheavy.wav"); // Swing sword over head at player
	precache_sound("ad171/gibs/gibheavy2.wav");
	precache_sound("ad181/justice/magic_attack.wav"); // Arrow attack
	precache_sound("ad181/justice/magic_fire.wav");
	precache_sound("ad181/justice/flame_fire.wav");
	precache_sound("ad171/wraith/attack1.wav"); // Flame BURST attack
	precache_sound("ad181/justice/flame_fire.wav");
	precache_sound("ad171/wraith/attack1_explode.wav");
	precache_sound("ad181/justice/leap1.wav"); // Crazy leapin! (re-used from player)
	precache_sound("ad181/justice/sight1.wav");	
	precache_sound("ad181/justice/pain1.wav");
	precache_sound("ad181/justice/death1.wav");
	precache_sound("ad181/justice/sword_draw.wav"); // New sword sweep/slash sounds
	precache_sound("ad181/justice/sword_sheath.wav");
};

// QUAKED monster_justice (1 0 0) (-16 -16 -24) (16 16 56) Ambush
void() monster_justice = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/ad181/mon_justice.mdl";				// Justice Knight
	self.headmdl = "progs/ad181/h_justice.mdl";			// Bloody head
	self.gib1mdl = "progs/ad181/w_justicesword.mdl";		// Broken sword
	self.gib2mdl = "progs/ad181/gib_justiceboot.mdl";		// Boot lying down
	self.gib3mdl = "progs/ad181/gib_justiceshould.mdl";	// Shoulder pad
	self.gib1sound = GIB_IMPACT_METALA;
	self.idle_sound = "ad181/justice/idle1.wav";
	self.weaponglow = "progs/ad181/s_judgemagic.spr"; // Spawning projectile attack
	self.sight_sound = "ad181/justice/sight1.wav"; // Strange roar of monks!
	self.pain_sound = "ad181/justice/pain1.wav";
	self.death_sound = "ad181/justice/death1.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_JUSTICE; // -16 -16 -24, 16 16 56	Vol 32 x 32 x 80
	if (self.health < 1) self.health = 600; // Regular monster with large HP
	self.gibhealth = -60;
	self.gibbed = FALSE;				// Starts complete
	self.pain_flinch = 400;				// Really low chance of pain
	self.pain_longanim = FALSE;			// No axe advantage
	self.pain_timeout = 2;				// High pain level
	if (self.infightextra <= 0) self.infightextra = 2; // High infighting damage
	self.steptype = FS_TYPELARGE;		// Giant feet
	self.poisonous = FALSE;				// No Poison version
	self.state = JUDGE_STAND;				// Default state
	self.weaponstate = JUDGE_SWSHOULDER;	// Default sword position
	self.attack_switch = FALSE;				// Avoid idleD if patrolling
	self.attack_active = FALSE;			// Not started combat yet
	self.meleerange = MONAI_CLOSEJUDGE;	// swing/smash range
	self.meleecontact = FALSE;			// Smash contact sound
	self.meleeoffset = '24 0 32';		// Arrow spawn height
	self.attack_offset = '32 0 -16';	// Firewall ground explosion
	self.deathstring = " was cut down by The Sword of Justice\n";
	self.attack_count = self.attack_timer = 0; // Setup default timer/counters for flame attacks
	self.part_exitpuff = self.part_exitsound = TRUE;
	self.part_exitfade = self.part_exitbusy = FALSE;
	if (self.proj_limit > PROJ_MAXLIMIT) self.proj_limit = PROJ_MAXLIMIT; // Default skill speed = 0=0.10, 1=0.08, 2=0.06, 3=0.04
	if (CheckZeroVector(self.proj_attqty)) self.proj_attqty = '3 2 7'; // Setup default Proj Count = Base (X) * (Skill * Y) Maximum = Z
	if (CheckZeroVector(self.jumpdist)) self.jumpdist = '500 0 250'; // Default jump forward/up distance
	if (self.jumprange_x <= 0) self.jumprange_x = MONAI_JUMPJUSTICENEAR;
	if (self.jumprange_y <= self.jumprange_x) self.jumprange_y = MONAI_JUMPJUSTICEFAR;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_checkattack = JusticeCheckAttack;
	self.th_stand = judge_stand;
	self.th_walk = judge_walk;
	self.th_run = judge_run;
	self.th_melee = judge_melee;
	self.th_charge = judge_chargeframe;
	self.th_missile = judge_range;
	self.th_jump = judge_jump;
	self.th_jumpexit = judge_jump6;
	self.th_pain = judge_pain;
	self.th_die = judge_die;
	self.classtype = CT_MONJUSTICE;
	self.classgroup = CG_DCAPTAIN;
	self.classmove = MON_MOVEWALK;
	monster_start();
};