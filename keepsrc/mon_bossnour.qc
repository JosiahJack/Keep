//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD), Lunaran
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 1
// Function count: 118
//
// Implements: Nouronihar (Nour for short) aka Scrag Mother
//
// Description:
// A larger scrag with four arms and able to spawn normal scrags as minions in
// waves.  Intended as a boss.  Dies in with lightning bolts shooting out.
//=============================================================================

// Original wizard idle
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8
$frame idle9 idle10 idle11

// Leaning forward flying pose
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 
$frame fly9 fly10 fly11 fly12 fly13

// A = Short recoil to right, B = Long recoil to left
$frame paina1 paina2 paina3 paina4 paina5 paina6
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9

// Very quick fall down backward death
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

// A - Typical spit/spike firing from all arms
$frame shota1 shota2 shota3 shota4 shota5 shota6 shota7 shota8
$frame shota9 shota10 shota11

// B - Long spit/spike firing from all arms
$frame shotb1 shotb2 shotb3 shotb4 shotb5 shotb6 shotb7 shotb8
$frame shotb9 shotb10 shotb11 shotb12 shotb13 shotb14 shotb15 shotb16 shotb17

// C - Slowly flick all arms upward (big attack)
$frame shotc1 shotc2 shotc3 shotc4 shotc5 shotc6 shotc7 shotc8
$frame shotc9 shotc10 shotc11 shotc12 shotc13 shotc14 shotc15 shotc16
$frame shotc17 shotc18 shotc19 shotc20 shotc21 shotc22 shotc23

// Rise upward and flee from the scene
$frame flee1 flee2 flee3 flee4 flee5 flee6 flee7 flee8
$frame flee9 flee10 flee11 flee12 flee13 flee14 flee15 flee16
$frame flee17 flee18

// Long reveal of extra arms, pretending to be wizard at first
$frame reveal1 reveal2 reveal3 reveal4 reveal5 reveal6 reveal7 reveal8
$frame reveal9 reveal10 reveal11 reveal12 reveal13 reveal14 reveal15 reveal16
$frame reveal17 reveal18 reveal19 reveal20 reveal21 reveal22 reveal23 reveal24
$frame reveal25 reveal26 reveal27 reveal28 reveal29 reveal30 reveal31 reveal32
$frame reveal33 reveal34 reveal35 reveal36

float NOUR_PHASE0 = -1;	// No boss wave/setup
float NOUR_PHASE1 = 1;	// Intro = Burst through floor
float NOUR_PHASE2 = 2;	// Fighting
float NOUR_PHASE3 = 3;	// Summon mode
float NOUR_PHASE4 = 4;	// Death

void() Fire_judgePlasma;

// Check the tether system
float() nour_CheckTether = {
	local float currentdist;
	
	// Check for boss mode
	if (!(self.spawnflags & MON_NOUR_BOSS)) return FALSE;

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


// MONSTER STATES (stand, walk run, attack, pain and death!

void() nour_stand1	= [	$idle1, nour_stand2] { monster_idle_sound(); ai_stand(); };
void() nour_stand2	= [	$idle2, nour_stand3] { ai_stand(); };
void() nour_stand3	= [	$idle3, nour_stand4] { ai_stand(); };
void() nour_stand4	= [	$idle4, nour_stand5] { ai_stand(); };
void() nour_stand5	= [	$idle5, nour_stand6] { ai_stand(); };
void() nour_stand6	= [	$idle6, nour_stand7] { ai_stand(); };
void() nour_stand7	= [	$idle7, nour_stand8] { ai_stand(); };
void() nour_stand8	= [	$idle8, nour_stand9] { ai_stand(); };
void() nour_stand9	= [	$idle9, nour_stand10] { ai_stand(); };
void() nour_stand10	= [	$idle10, nour_stand11] { ai_stand(); };
void() nour_stand11	= [	$idle11, nour_stand1] { ai_stand(); };

void() nour_walk1	= [	$idle1, nour_walk2] { monster_idle_sound(); ai_walk(8); };
void() nour_walk2	= [	$idle2, nour_walk3] { ai_walk(8); };
void() nour_walk3	= [	$idle3, nour_walk4] { ai_walk(8); };
void() nour_walk4	= [	$idle4, nour_walk5] { ai_walk(8); };
void() nour_walk5	= [	$idle5, nour_walk6] { ai_walk(8); };
void() nour_walk6	= [	$idle6, nour_walk7] { ai_walk(8); };
void() nour_walk7	= [	$idle7, nour_walk8] { ai_walk(8); };
void() nour_walk8	= [	$idle8, nour_walk9] { ai_walk(8); };
void() nour_walk9	= [	$idle9, nour_walk10] { ai_walk(8); };
void() nour_walk10	= [	$idle10, nour_walk11] { ai_walk(8); };
void() nour_walk11	= [	$idle11, nour_walk1] { ai_walk(8); };

void() nour_slideframe = { // [FUNCTION]
	// Check for boss mode (phase and wave check)
	if (self.spawnflags & MON_NOUR_BOSS) {
		if (self.style != NOUR_PHASE2) return;

		// Check for boss wave trigger events
		if (SUB_BossWaveCheck(0)) { self.th_summon(); return; }
	}
	
	// Dead monster?
	if (self.health < 1) return;
	if (self.walkframe == 0) monster_idle_sound();

	// Move frame forward, check for conditions
	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 10) self.walkframe = 0;
	self.nextthink = time + 0.1;
	self.think = nour_slideframe;
	
	// Setup current animation frame
	self.frame = $idle1 + self.walkframe;
	self.ideal_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin);
	
	// Check the BOSS tether system
	if (nour_CheckTether()) ai_run(0);
	else ai_run(8);
};

void() nour_slide1 = { self.walkframe = 0; nour_slideframe(); }; // [FUNCTION]


// RUN state - chasing the player

void() nour_runframe = { // [FUNCTION]
	// Check for boss mode (phase and wave check)
	if (self.spawnflags & MON_NOUR_BOSS) {
		if (self.style != NOUR_PHASE2) return;

		// Check for boss wave trigger events
		if (SUB_BossWaveCheck(0)) { self.th_summon(); return; }
	}
	
	if (self.health < 1) return;
	if (self.walkframe == 0) monster_idle_sound();
	
	// Move frame forward, check for conditions
	self.walkframe = self.walkframe + 1;
	if (self.walkframe > 12) self.walkframe = 0;
	self.nextthink = time + 0.1;
	self.think = nour_runframe;
	
	// Setup current animation frame
	self.frame = $fly1 + self.walkframe;
	self.ideal_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin);
	
	// Check the BOSS tether system
	if (nour_CheckTether()) ai_run(0);
	else ai_run(16);
};

void() nour_run1 = { self.walkframe = 0; nour_runframe(); }; // [FUNCTION]

// ATTACK A - Fire multiple spit/spikes
// Block pain function from interrupting magic attack
void(vector offset) nour_spike = { // [FUNCTION]
	local vector dtarget, starget, ftarget, sorg, forg, dir;
	
	if (!self.enemy) return;
	if (self.health < 1) return;

	self.effects = self.effects | EF_MUZZLEFLASH;
	self.attack_speed = SPEED_NOURSPIKE + (skill * SPEED_NOURSKILL);

	ai_face();
	// Work out direction line from self to enemy
	dtarget = SUB_orgEnemyTarget() - self.origin;
	dtarget = vectoangles(dtarget);
	makevectors(dtarget);
	
	// Work out correct source/target origins
	starget = self.origin + v_forward * 16 + v_up * offset_z;
	ftarget = SUB_orgEnemyTarget() + '0 0 16';

	// Add left/right offset
	sorg = starget + v_right * offset_x;
	forg = ftarget + v_right * offset_x;
	dir = normalize(forg - sorg);
	launch_projectile(sorg,dir,NO_SPIN,CT_PROJ_NOUR1,self.attack_speed);
	sorg = starget - v_right * offset_x;
	forg = ftarget - v_right * offset_x;
	dir = normalize(forg - sorg);
	launch_projectile(sorg,dir,NO_SPIN,CT_PROJ_NOUR1,self.attack_speed);
};

void() nour_atta1	= [	$shota1, nour_atta2] { ai_face();
	self.pain_finished = time + 1;
	sound(self,CHAN_WEAPON,"ad171/nour/attack1.wav",1,ATTN_NORM);
};
void() nour_atta2	= [$shota2, nour_atta3] { ai_face(); };
void() nour_atta3	= [$shota3, nour_atta4] { ai_face(); };
void() nour_atta4	= [$shota4, nour_atta5] { nour_spike('24,0,16'); };
void() nour_atta5	= [$shota5, nour_atta6] { nour_spike('20 0 8'); };
void() nour_atta6	= [$shota6, nour_atta7] { nour_spike('16 0 0'); };
void() nour_atta7	= [$shota7, nour_atta8] { nour_spike('12 0 -8'); };
void() nour_atta8	= [$shota8, nour_atta9] { nour_spike('8 0 -16'); };
void() nour_atta9	= [$shota9, nour_atta10] {};
void() nour_atta10	= [$shota10, nour_atta11] {};
void() nour_atta11	= [$shota11, nour_run1] {};

// ATTACK B - Fire one large blob (grenade) of spit
void(vector bombofs) Fire_NourBomb = {
	local vector org, torg, ang, dir, avel;

	SUB_FinishAttachment(); // Finished with bomb effect
	
	if (!self.enemy) return;
	if (self.health < 1) return;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"ad171/nour/attack1.wav",1,ATTN_NORM);
	ai_face();
	makevectors(self.angles);
	org = self.origin + attack_vector(bombofs);
	torg = SUB_orgEnemyTarget();
	self.attack_speed = SPEED_NOURBOMB;
	self.attack_elev = SUB_Elevation(ELEV_DEFAULT, org, torg, self.attack_speed);
	ang = vectoangles(torg - org);
	ang_x = -self.attack_elev;
	makevectors(ang);
	dir = v_forward * self.attack_speed;
	avel = vecrand(100,200,FALSE);
	launch_projectile(org,dir,avel,CT_PROJ_NOUR2,1);
};

void(vector bombofs, float bombframe) Setup_NourBomb = { // [FUNCTION]
	local vector org;
	if (self.health < 1) return;
	
	SUB_CreateSelfAttachment(MODEL_PROJ_NOUR2B,0.85);
	if (bombframe == 0) { // Frame 0 is start of the sequence (move everything into place)
		self.attachment.state = STATE_ON;
		setorigin(self.attachment, self.origin);
		setmodel(self.attachment, self.attachment.mdl);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		self.attachment.skin = 0;

		// Start growing bomb sound
		sound(self,CHAN_WEAPON,"ad171/wraith/attack3.wav",1,ATTN_NORM);
	}

	// Turn towards enemy and update model attachment
	// The offset is based on the nour facing forward
	ai_face();
	makevectors(self.angles);
	org = self.origin + attack_vector(bombofs);
	setorigin(self.attachment, org);
	self.attachment.angles = self.angles;
	self.attachment.angles_x = random()*360;
	self.attachment.frame = bombframe;
	// Random explosion like particles from ball as it grows
	particle_explode(self.attachment.origin, 10+random()*10, 0.5+random(), PARTICLE_BURST_YELLOW, 0);
};

void() nour_attb1	= [$shotb1, nour_attb2] { ai_face(); self.pain_finished = time + 1.5; };
void() nour_attb2	= [$shotb2, nour_attb3] { ai_face(); };
void() nour_attb3	= [$shotb3, nour_attb4] { ai_face(); };
void() nour_attb4	= [$shotb4, nour_attb5] { ai_face(); };
void() nour_attb5	= [$shotb5, nour_attb6] { Setup_NourBomb('24 0 0',0); };
void() nour_attb6	= [$shotb6, nour_attb7] { Setup_NourBomb('24 0 -2',1); };
void() nour_attb7	= [$shotb7, nour_attb8] { Setup_NourBomb('24 0 -4',2); };
void() nour_attb8	= [$shotb8, nour_attb9] { Setup_NourBomb('24 0 -8',3); };
void() nour_attb9	= [$shotb9, nour_attb10] { Setup_NourBomb('24 0 -12',4); };
void() nour_attb10	= [$shotb10, nour_attb11] { Setup_NourBomb('24 0 -16',5); };
void() nour_attb11	= [$shotb11, nour_attb12] { Setup_NourBomb('24 0 -12',6); };
void() nour_attb12	= [$shotb12, nour_attb13] { Fire_NourBomb('24 0 -12'); };
void() nour_attb13	= [$shotb13, nour_attb14] {};
void() nour_attb14	= [$shotb14, nour_attb15] {};
void() nour_attb15	= [$shotb15, nour_attb16] {};
void() nour_attb16	= [$shotb16, nour_attb17] { ai_face(); };
void() nour_attb17	= [$shotb17, nour_run1] { ai_face(); };

// Fire random plasma spikes while summoning wizard minions
void(vector minofs) Fire_NourPlasma = { // [FUNCTION]
	local vector org;

	makevectors(self.angles);
	org = self.origin + attack_vector(minofs);
	self.pos2 = vecrand(0,50,TRUE);
	self.pos3 = normalize(self.pos2);
	launch_projectile(org,self.pos3,NO_SPIN,CT_SUMMONLIGHT,SPEED_REFLECTION);
};

void(vector minofs) Spawn_NourMin = { // [FUNCTION]
	// Finished with bomb effect
	SUB_FinishAttachment();
	Fire_NourPlasma(minofs);
	
	// Cycle through spawn targets and spawn Tfog + Wizard
	self.lip = self.attack_summon;
	while(self.lip > 0) {
		self.bossminchain.think = spawn_tfog_self;
		self.bossminchain.nextthink = time + 0.01 + random()*0.3;

		// If the spawn locaiton all clear, spawn something!
		self.pos1 = self.bossminchain.origin;
		self.aflag = find_minionspace(self.pos1);			
		if (self.aflag == TRUE) {
			// Check for any spawnflags on spawn point
			if (random() < 0.5)
				minion_wizard(self.pos1, self.enemy, MON_WIZARD_ABOVE);
			else minion_wizard(self.pos1, self.enemy, 0);
		}
		
		// Next spawn point
		self.bossminchain = self.bossminchain.entchain;
		self.lip = self.lip - 1;
	}
};

void(vector minofs, float minframe) Setup_NourMinChain = {
	local vector org, ovec;

	// Move the energy ball into position infront of the nour
	makevectors(self.angles);
	if (self.classtype == CT_MONJUDGE) {
		ovec = self.attack_offset3 + (random() * self.attack_offset4);
		org = self.origin + attack_vector(ovec);
	} else org = self.origin + attack_vector(minofs);
	
	if (self.attachment) {
		setorigin(self.attachment, org);	
		self.attachment.angles = self.angles;
		self.attachment.angles_x = random()*360;
		self.attachment.frame = minframe;
	}

	particle_implode(org, 20+random()*20, 75, 75, PARTICLE_BURST_BLUE); // Slowly suck in particles to energy ball
	if (self.classtype == CT_MONJUDGE) Fire_judgePlasma(); // Random bolt.
	self.lip = self.attack_summon; // Cycle through spawn targets and fire Lightning per frame
	while(self.lip > 0) {
		self.pos1 = self.bossminchain.origin - org; // Traceline from spawn point to random direction
		self.pos2 = vecrand(0,50,TRUE);
		self.pos3 = normalize(self.pos1 + self.pos2);
		M_FireRandomLightningEffect(org,self.pos3,self.bossminchain);
		self.bossminchain = self.bossminchain.entchain; // Next spawn point
		self.lip = self.lip - 1;
	}
};

void(vector minofs, float minframe) Setup_NourMin = {
	SUB_CreateSelfAttachment(MODEL_PROJ_NOUR2B,0.85); // Attachment for lightning
	if (minframe == 0) { // Start of the sequence, move everything into place.
		self.attachment.state = STATE_ON;
		setorigin(self.attachment, self.origin);
		setmodel(self.attachment, self.attachment.mdl);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		self.attachment.skin = 1;
		sound(self,CHAN_WEAPON,"ad171/wraith/attack3.wav",1,ATTN_NORM); // Start Spawning sound
	} 
	Setup_NourMinChain(minofs,minframe);
	Fire_NourPlasma(minofs); // Generate a random bolt of electricity
};

void() nour_powersummon = { // [FUNCTION]
	// Block all damage while summoning stuff
	Resist_ChangeType(self, TRUE);
	
	// Reset attack state so it does not keep spawning
	self.attack_state = AS_STRAIGHT;
	self.lip = self.attack_summon;
	while (self.lip > 0) {
		self.cnt = 4;	// Try 4 times, no infinite loops
		while (self.cnt > 0) {
			// Work out 2 empty spaces around Nour for minions
			self.pos2 = vecrand(self.bossminbase, self.bossminrnd, TRUE);
			// Always spawn higher than boss
			if (self.pos2_z < self.maxs_z) self.pos2_z = self.maxs_z;
			self.pos1 = self.origin + self.pos2;
			// Check for available space for mininon
			self.aflag = find_minionspace(self.pos1);
			self.cnt = self.cnt - 1;
			// Space is right, save origin
			if (self.aflag == TRUE) self.cnt = -10;
		}
		// Found space, store origin for later
		if (self.cnt == -10) self.bossminchain.origin = self.pos1;
		else self.bossminchain.origin = self.origin;
		
		// Next spawn point
		self.bossminchain = self.bossminchain.entchain;
		self.lip = self.lip - 1;
	}
};

void() nour_attc1	= [$shotc1, nour_attc2] { // [FUNCTION]
	ai_face();
	// Make sure boss mode active for this attack
	if (!(self.spawnflags & MON_NOUR_BOSS)) { self.think = self.th_run; return; }

	nour_powersummon();
};
void() nour_attc2	= [$shotc2, nour_attc3] { ai_face(); };
void() nour_attc3	= [$shotc3, nour_attc4] { ai_face(); };
void() nour_attc4	= [$shotc4, nour_attc5] { Setup_NourMin('24 0 -24',0); };
void() nour_attc5	= [$shotc5, nour_attc6] { Setup_NourMin('24 0 -24',1); };
void() nour_attc6	= [$shotc6, nour_attc7] { Setup_NourMin('24 0 -22',2); };
void() nour_attc7	= [$shotc7, nour_attc8] { Setup_NourMin('24 0 -20',3); };
void() nour_attc8	= [$shotc8, nour_attc9] { Setup_NourMin('24 0 -16',4); };
void() nour_attc9	= [$shotc9, nour_attc10] { Setup_NourMin('24 0 -16',5); };
void() nour_attc10	= [$shotc10, nour_attc11] { Setup_NourMin('24 0 -12',6); };
void() nour_attc11	= [$shotc11, nour_attc12] { Setup_NourMin('24 0 -8',6); };
void() nour_attc12	= [$shotc12, nour_attc13] { Setup_NourMin('24 0 -4',7); };
void() nour_attc13	= [$shotc13, nour_attc14] { Setup_NourMin('24 0 -2',7); };
void() nour_attc14	= [$shotc14, nour_attc15] { Spawn_NourMin('24 0 0'); };
void() nour_attc15	= [$shotc15, nour_attc16] { Fire_NourPlasma('24 0 0'); };
void() nour_attc16	= [$shotc16, nour_attc17] {};
void() nour_attc17	= [$shotc17, nour_attc18] {};
void() nour_attc18	= [$shotc18, nour_attc19] {};
void() nour_attc19	= [$shotc19, nour_attc20] {};
void() nour_attc20	= [$shotc20, nour_attc21] {};
void() nour_attc21	= [$shotc21, nour_attc22] {};
void() nour_attc22	= [$shotc22, nour_attc23] { ai_face(); };
void() nour_attc23	= [$shotc23, nour_run1] { ai_face();
	// Restore ammo resistance to default
	Resist_ChangeType(self, FALSE);
	self.style = NOUR_PHASE2;	// Fight mode
};

void() nour_paina1 = [$paina1, nour_paina2 ] {};
void() nour_paina2 = [$paina2, nour_paina3 ] {};
void() nour_paina3 = [$paina3, nour_paina4 ] {};
void() nour_paina4 = [$paina4, nour_paina5 ] {};
void() nour_paina5 = [$paina5, nour_paina6 ] {};
void() nour_paina6 = [$paina6, nour_run1 ] {};

void() nour_painb1 = [$painb1, nour_painb2 ] {};
void() nour_painb2 = [$painb2, nour_painb3 ] {};
void() nour_painb3 = [$painb3, nour_painb4 ] {};
void() nour_painb4 = [$painb4, nour_painb5 ] {};
void() nour_painb5 = [$painb5, nour_painb6 ] {};
void() nour_painb6 = [$painb6, nour_painb7 ] {};
void() nour_painb7 = [$painb7, nour_painb8 ] {};
void() nour_painb8 = [$painb8, nour_painb9 ] {};
void() nour_painb9 = [$painb9, nour_run1 ] {};

void(entity inflictor, entity attacker, float damage) nour_pain = { // [FUNCTION]
	// Finish with all attachments
	SUB_FinishAttachment();

	if (self.spawnflags & MON_NOUR_BOSS) {
		// Check for boss wave trigger events
		if (SUB_BossWaveCheck(0)) { self.th_summon(); return; }
	}

	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		if (self.pain_check == 1 || self.pain_check == 2) {
			// Randomly pick which pain animation to play
			if (random() < 0.8) nour_paina1();		// Short recoil right
			else {
				nour_painb1();						// Long recoil left
				self.pain_finished = time + 2;		// long animation
			}
		}
	}
};

// Death comes to us all, even Nour!
void() nour_explode = { // [FUNCTION]
	if (self.message2 != "") trigger_strs(self.message2,self); // Final triggers
	entity_hide(self);
	Tent_Explosion2(self.origin,35,8); // Blue ID particle explosion

	// Check for any death radius damage
	if (self.death_dmg > 0) T_RadiusDamage(self,self,self.death_dmg,world,DAMAGEALL);
	
	// Classic sprite/DP explosion
	SpawnExplosion(EXPLODE_PLASMA_BIG,self.origin,"ad171/seeker/explode_major.wav");

	// Gib explosive fountain!?!
	self.max_health = MON_GIBEXPLOSION;
	ThrowGib(11, 2);	// Left Arm
	ThrowGib(12, 2);	// Right Arm
	ThrowGib(13, 1);	// Tail
	ThrowGib(4, 10 + rint(random()*3));
	ThrowGib(5, 10 + rint(random()*3));
};

// Spawn implosion effect and lightning.
void(float partcol) nour_lightningdeath = { // [FUNCTION]
	if (random() < 0.5) particle_implode(self.origin,20+random()*20,100,100,partcol);
	else { // Spawn particle smoke and explosive smoke
		SpawnProjectileSmoke(self.origin,150,100,300);
		particle_dust(self.origin, 10+random()*10,16,partcol);
	}
	
	// Check for any random lightning strikes outward
	if (random() < 0.5) {
		self.pos1 = self.origin - '0 0 16';
		self.pos2 = vecrand(0,50,TRUE);
		self.pos2_z = 25 + random()*25;	// Always up!
		self.pos3 = normalize(self.pos2);
		M_FireRandomLightningEffect(self.pos1,self.pos1 + self.pos3,self);
	}

	// Cycle through end phase
	self.lip = self.lip + 1;
	if (self.lip == 26) sound(self,CHAN_AUTO,"ad171/eidolon/implode_death.wav",1,ATTN_NONE);
	if (self.lip == 40) nour_explode();
};

void() nour_die1 = [$death1, nour_die2 ] {};
void() nour_die2 = [$death2, nour_die3 ] {};
void() nour_die3 = [$death3, nour_die4 ] { self.solid = SOLID_NOT; };
void() nour_die4 = [$death4, nour_die5 ] {};
void() nour_die5 = [$death5, nour_die6 ] {};
void() nour_die6 = [$death6, nour_die7 ] {};
void() nour_die7 = [$death7, nour_die8 ] {};
void() nour_die8 = [$death8, nour_die9 ] { self.lip = 0; };
void() nour_die9 = [$death9, nour_die9 ] {
	if (random() < 0.2) Fire_NourPlasma('0 0 -16'); // Check for a random bolt of plasma
	nour_lightningdeath(PARTICLE_BURST_BLUE); // No more Nour!
};

void() nour_die = { // [FUNCTION]
	self.deadflag = DEAD_DEAD;	// Nour bites the dust
	self.effects = 0;			// Remove effects on death
	SUB_FinishAttachment();	// Remove any attachments
	SUB_RemoveAttachment();
	sound(self,CHAN_VOICE,"ad171/nour/death.wav",1,ATTN_NORM);
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 100 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	nour_die1();
};

// Create minion entity chain
// Entities are created so that the spawning space can be tested
// before spawning the minions for possible collisions
float() nour_minionsetup = { // [FUNCTION]
	local entity min_prev, min_first;
	
	self.lip = self.attack_summon;
	min_prev = min_first = world;
	
	// Cycle through minion list
	while(self.lip > 0) {
		newmis = spawn();
		newmis.origin = self.origin;
		newmis.owner = self;
		// Is this the first pass through loop?
		if (!min_first) min_first = newmis;
		// Any previous entities created?
		if (!min_prev) min_prev = newmis;
		else {
			// Link previous to current entity
			// and move previous forward in chain
			min_prev.entchain = newmis;
			min_prev = newmis;
		}
		// Keep on looping
		self.lip = self.lip - 1;
	}
	// Close loop
	if (min_first) {
		newmis.entchain = min_first;
		self.bossminchain = min_first;
		return FALSE;
	}
	else return TRUE;
};

void() nour_spawntether = { // [FUNCTION]
	// temporary tether point
	self.movelast = spawn();
	self.movelast.owner = self;
	self.movelast.classtype = CT_TETHERENT;
	self.movelast.movetype = MOVETYPE_NONE;
	self.movelast.solid = SOLID_NOT;
	self.movelast.origin = self.origin;
	setsize (self.movelast, VEC_ORIGIN, VEC_ORIGIN);
};

// REVEAL PHASE (coming out of the ground)
void() nour_readyframe = { // [FUNCTION]
	self.walkframe = 0;				// Reset just in case
	self.height = MONAI_ABOVEDIST;	// Enemytarget distance above
	self.movetype = MOVETYPE_STEP;	// back to regular movement
	self.takedamage = DAMAGE_AIM;	// Can take damage
	self.style = NOUR_PHASE2;		// Time to fight!
	Resist_ChangeType(self,FALSE);	// restore resistance
	if (self.enemy) self.th_run();	// Hunt the player
	else self.th_stand();			// Wait for the player
};

void() nour_revealframe = { // [FUNCTION]
	// Beginning of animation block
	if (self.walkframe == 3) 
		sound(self,CHAN_BODY,"ad171/nour/reveal.wav",1,ATTN_NORM);
	else if (self.walkframe == 23)
		sound(self,CHAN_VOICE, self.idle_sound,1,ATTN_NORM);
	
	if (self.movetarget2 != world) { 
		// Work out remaining distance to go
		self.movedir = self.movetarget2.origin - self.origin;
		self.t_length = vlen(self.movedir);
		// Calc initial velocity boast (burst action)
		self.lip = (self.pausetime - time) / 3.6;
		self.t_width = 1 + (self.lip/2);

		// If time or distance too small, stop moving
		if (self.lip < 0.1 || self.t_length < 2) {
			self.velocity = '0 0 0';
		}
		// Update velocity every frame
		else self.velocity = self.movedir * self.t_width;
	}
	
	// Turn towards player
	if (self.enemy) ai_face();

	// Move frame forward, check for conditions
	self.walkframe = self.walkframe + 1;
	self.nextthink = time + 0.1;
	// Time to exit reveal?
	if (self.walkframe > 35) nour_readyframe();
	else {
		self.think = nour_revealframe;
		// Setup current animation frame
		self.frame = $reveal1 + self.walkframe;
	}
};

// Setup BOSS Nour after trigger event
void() nour_awake = { // [FUNCTION]
	// make sure boss mode selected
	if (!(self.spawnflags & MON_NOUR_BOSS)) return;

	self.use = SUB_Null;			// No more triggers
	self.style = NOUR_PHASE1;		// Bursting intro sequence
	self.flags = FL_MONSTER | FL_FLY;	// Reset flag (no user settings)
	self.frame = $idle1; self.skin = self.exactskin;
	monster_bbox();					// Setup bounding box

	self.noinfighting = TRUE;		// No infighting
	self.takedamage = DAMAGE_NO;	// Still immune to damage
	self.yaw_speed = 20;			// Average Speed
	self.velocity = '0 0 0';		// Make sure stationary
	self.walkframe = 0;				// reset for animation
	self.attack_summon = skill + 1;	// Total amount of minions

	if (self.tetherrange < 32) self.tetherrange = MONAI_MAXNOUR;
	if (self.bossminbase <= 64) self.bossminbase = MONAI_BOSS_SUMDIST;
	if (self.bossminrnd <= 64) self.bossminrnd = MONAI_BOSS_SUMRND;

	// skill modifier : Easy = 1, Normal = 2, Hard/NM = 3
	if (self.attack_summon > 3) self.attack_summon = 3;
	// Setup minion chain entity system
	if (nour_minionsetup()) {
		dprint("\b[NOUR]\b Cannot create minion chain!\n");
		spawn_marker(self.origin+'0 0 32','0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}
		
	// Check for tether system (special target field)
	if (self.tethertarget == "") {
		dprint("\b[NOUR]\b Generated tetherpoint!\n");
		nour_spawntether();
	}
	// Find the defined tether marker
	else self.movelast = find(world,targetname,self.tethertarget);
	
	// Does the tether entity exist?
	if (!self.movelast) {
		dprint("\b[NOUR]\b Tether target not found!\n");
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}

	// Show BOSS tetherpoint
	spawn_marker(self.movelast.origin+'0 0 8','0 0 0',0,SPNMARK_RED);
	
	// If message2 is not defined?
	if (self.message2 == "") {
		// No movement towards a reveal location
		self.movetarget2 = world;
		// Skip reveal sequence
		self.walkframe = 35;
		// Reset all combat entities
		self.enemy = self.goalentity = self.movetarget = world;
		// Zap (50K damage) anything in its place!
		if (self.nospawndamage == 0) 
			spawn_tdeath(self.origin, self);
		// Don't show spawning effect if nogfx
		if (!(self.spawnflags & MON_SPAWN_NOGFX)) 
			spawn_tfog(self.origin);
	} else {
		// Find spawning (move) destination
		self.movetarget2 = find(world,targetname,self.message2);
		if (!self.movetarget2) {
			dprint("\b[NOUR]\b Missing spawn destination!\n");
			spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
			entity_hide(self);
			return;
		}
		else {
			// After reveal, start attacking player
			if (activator.flags & FL_CLIENT) {
				self.goalentity = self.enemy = activator; }
			else self.enemy = world;
		}
	}
	
	// Start spawning BOSS
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;				// Alway fly
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
	
	// Trigger all spawning events (optional)
	if (self.message != "") {
		trigger_strs(self.message, self);
		self.message = "";
	}
	
	// Make sure all death triggers are setup ready
	self.message2 = self.target;
	self.target = self.target2 = self.deathtarget = "";

	// Time to keep pushing velocity upward
	self.pausetime = time + 3.6;
	// Time to rise from the ground or spawn regular
	nour_revealframe();
};

void() monster_nour_precache = {
	precache_model ("progs/ad171/mon_bossnour.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model (MODEL_PROJ_WIZ);	// Originally progs/w_spike.mdl
	precache_model ("progs/ad171/gib_wzarm1.mdl");
	precache_model ("progs/ad171/gib_wzarm2.mdl");
	precache_model ("progs/ad171/gib_wztail.mdl");
	precache_model (MODEL_PROJ_NOUR1);	// Spit
	precache_model (MODEL_PROJ_NOUR2B);	// Growing ball
	precache_model (MODEL_PROJ_NOUR2P);	// Warping projectile
	precache_model (MODEL_PROJ_NOUR2S);	// Explosive pieces
	precache_model (MODEL_PROJ_LIGHTNING2);
	precache_model (SBURST_POISON);		// Poison Burst
	precache_sound("ad171/nour/idle1.wav");
	precache_sound("ad171/nour/pain.wav");
	precache_sound("ad171/nour/sight.wav");
	precache_sound("ad171/nour/reveal.wav");
	precache_sound("ad171/nour/death.wav"); // Final death sequence
	precache_sound("ad171/seeker/explode_major.wav");
	precache_sound("ad171/eidolon/elec_arch1.wav");
	precache_sound("ad171/eidolon/elec_arch2.wav");
	precache_sound("ad171/eidolon/implode_death.wav");
	precache_sound("ad171/nour/attack1.wav"); // Attack A - Wizard style spit
	precache_sound("ad171/wraith/attack3.wav"); // Attack B - Large explosive ball
	precache_sound("ad171/nour/explode2.wav");
	precache_sound("ad171/wraith/bounce.wav");
	if (ext_dppart) particleeffectnum(DPP_TEBPOISON);
};

// QUAKED monster_nouronihar (1 0 0) (-16 -16 -24) (16 16 40)
void() monster_nour = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	
	self.mdl = "progs/ad171/mon_bossnour.mdl";
	self.headmdl = "progs/h_wizard.mdl";
	self.gib1mdl = "progs/ad171/gib_wzarm1.mdl";	// Left arm/stump
	self.gib2mdl = "progs/ad171/gib_wzarm2.mdl";	// Right arm/stump
	self.gib3mdl = "progs/ad171/gib_wztail.mdl";	// Tail section
	self.idle_sound = "ad171/nour/idle1.wav"; // sight/pain/death sounds
	self.pain_sound = "ad171/nour/pain.wav";
	self.sight_sound = "ad171/nour/sight.wav";
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	self.bboxtype = BBOX_WIDE;		// Wraith Body
	if (self.health < 1) self.health = 1200; // Regular monster with large HP
	self.gibhealth = MON_NEVERGIB;	// Cannot be gibbed by weapons
	self.gibbed = FALSE;			// Starts complete
	self.pain_flinch = 200;			// Strong Wizard level
	self.pain_timeout = 2;			// Stop constant pain
	if (self.infightextra <= 0) self.infightextra = 8;
	self.steptype = FS_FLYING;		// No foot sound
	self.blockudeath = TRUE;		// No player gib sound
	self.pain_longanim = FALSE;		// No axe advantage
	self.no_liquiddmg = TRUE;		// no slime/lava damage
	if (self.height < 1) self.height = MONAI_ABOVEDIST; // Custom height
	if (self.death_dmg < 1) self.death_dmg = DAMAGE_NOUR;
	self.poisonous = FALSE;			// Cannot be poisonous
	self.style = NOUR_PHASE0;		// No waves setup
	self.deathstring = " was picked apart by the Scragmother\n";
	self.attack_chance = SUB_ClampFloat(self.attack_chance,0,1); // Change balance of range (spit/bomb) attacks
	Resist_ChangeType(self,-1); // Setup Ammo Resistance
	if (self.spawnflags & MON_NOUR_BOSS) {
		self.resist_cells = 1;
		self.resist_plasma = 1;
	} else {
		// Regular Nour is not 100% resistant
		self.resist_plasma = 0.75;
		self.resist_cells = 0.75;
	}
	self.reflectlightning = TRUE;	// Reflect lightning strikes
	self.reflectplasma = TRUE;		// Reflect plasma projectiles
	self.th_checkattack = NourCheckAttack; // Restore all think functions
	self.th_stand = nour_stand1;
	self.th_walk = nour_walk1;
	self.th_run = nour_run1;
	self.th_slide = nour_slide1;
	self.th_melee = nour_atta1;
	self.th_missile = nour_attb1;
	self.th_summon = nour_attc1;
	self.th_pain = nour_pain;
	self.th_die = nour_die;	
	self.classtype = CT_MONNOUR;
	self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;
	if (self.minion_name == "") {
		self.minion_name = "monster_wizard";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }
	self.frame = 0; self.exactskin = self.skin; // Devmarker function changes skins, save for later
	monster_start();

	// Check for boss version of Nouronihar?
	if (self.spawnflags & MON_NOUR_BOSS) {
		// Reset spawnflag, other values not required
		if (self.health < 1) self.health = MEGADEATH;
		self.max_health = self.health;
		self.pain_finished = LARGE_TIMER;		
		self.takedamage = DAMAGE_NO;	// Immune to damage
		self.flags = FL_MONSTER;		// Reset flag (no user settings)
		self.bossflag = TRUE;			// Boss flag (like FL_MONSTER)		
		self.reflectaxe = TRUE;			// Prevent axe damage

		// Wait for trigger event...
		if (self.targetname != "")
			self.use = nour_awake;
		else
			nour_awake(); // ...or not, mapper didn't set us up right!
	}
};