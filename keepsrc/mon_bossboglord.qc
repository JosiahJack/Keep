//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Entity count: 
// Function count: 
//
// Implements: Bog Lord and Fire Shambler
//
// Description:
// The Bog Lord is a slime shambler boss and the Fire Shambler is a fire
// version.  Both are more powerful than normal shamblers.
//=============================================================================

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12
$frame run1 run2 run3 run4 run5 run6
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12
$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9
$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9
$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11

void() bogl_stand1	= [	$stand1,	bogl_stand2	] { monster_idle_sound(); ai_stand(); };
void() bogl_stand2	= [	$stand2,	bogl_stand3	] { ai_stand(); };
void() bogl_stand3	= [	$stand3,	bogl_stand4	] { ai_stand(); };
void() bogl_stand4	= [	$stand4,	bogl_stand5	] { ai_stand(); };
void() bogl_stand5	= [	$stand5,	bogl_stand6	] { ai_stand(); };
void() bogl_stand6	= [	$stand6,	bogl_stand7	] { ai_stand(); };
void() bogl_stand7	= [	$stand7,	bogl_stand8	] { ai_stand(); };
void() bogl_stand8	= [	$stand8,	bogl_stand9	] { ai_stand(); };
void() bogl_stand9	= [	$stand9,	bogl_stand10] { ai_stand(); };
void() bogl_stand10	= [	$stand10,	bogl_stand11] { ai_stand(); };
void() bogl_stand11	= [	$stand11,	bogl_stand12] { ai_stand(); };
void() bogl_stand12	= [	$stand12,	bogl_stand13] { ai_stand(); };
void() bogl_stand13	= [	$stand13,	bogl_stand14] { ai_stand(); };
void() bogl_stand14	= [	$stand14,	bogl_stand15] { ai_stand(); };
void() bogl_stand15	= [	$stand15,	bogl_stand16] { ai_stand(); };
void() bogl_stand16	= [	$stand16,	bogl_stand17] { ai_stand(); };
void() bogl_stand17	= [	$stand17,	bogl_stand1	] { ai_stand(); };

void() bogl_walk1	= [$walk1, bogl_walk2 ] { monster_idle_sound(); ai_walk(10); };
void() bogl_walk2	= [$walk2, bogl_walk3 ] { monster_footstep(FALSE); ai_walk(9); };
void() bogl_walk3	= [$walk3, bogl_walk4 ] { ai_walk(9); };
void() bogl_walk4	= [$walk4, bogl_walk5 ] { ai_walk(5); };
void() bogl_walk5	= [$walk5, bogl_walk6 ] { ai_walk(6); };
void() bogl_walk6	= [$walk6, bogl_walk7 ] { ai_walk(12); };
void() bogl_walk7	= [$walk7, bogl_walk8 ] { monster_footstep(FALSE); ai_walk(8); };
void() bogl_walk8	= [$walk8, bogl_walk9 ] { ai_walk(3); };
void() bogl_walk9	= [$walk9, bogl_walk10] { ai_walk(13); };
void() bogl_walk10	= [$walk10, bogl_walk11] { ai_walk(9); };
void() bogl_walk11	= [$walk11, bogl_walk12] { ai_walk(7); };
void() bogl_walk12	= [$walk12, bogl_walk1 ] { ai_walk(7); };

void() bogl_run1 = [$run1, bogl_run2 ] { monster_idle_sound(); ai_run(20); };
void() bogl_run2 = [$run2, bogl_run3 ] { monster_footstep(FALSE); ai_run(24); };
void() bogl_run3 = [$run3, bogl_run4 ] { ai_run(20); };
void() bogl_run4 = [$run4, bogl_run5 ] { ai_run(20); };
void() bogl_run5 = [$run5, bogl_run6 ] { monster_footstep(FALSE); ai_run(24); };
void() bogl_run6 = [$run6, bogl_run1 ] { ai_run(20); };

// RANGE ATTACK 1 - overhead SMASH/slime
void(vector leftofs, vector rightofs) bogl_throwslime = {
	local vector org, btarg, dir, avel;
	
	SUB_FinishAttachments(); // Finished with growing balls of slime
	if (!self.enemy) return;
	if (self.health < 1) return;

	ai_face();
	makevectors(self.angles);
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.attack_speed = SPEED_BLORDBALL + (skill * SPEED_BLORDSKILL);

	// Fire left hand off center and at players feet
	org = self.origin + attack_vector(leftofs);
	btarg =self.enemy.origin + v_right*8 - v_up*8;
	dir = normalize(btarg - org);
	avel = vecrand(100,200,FALSE);
	launch_projectile(org,dir,avel,CT_PROJ_BLORD,self.attack_speed);

	// Fire right hand off center and at players feet
	org = self.origin + attack_vector(rightofs);
	btarg =self.enemy.origin - v_right*8 - v_up*8;
	dir = normalize(btarg - org);
	avel = vecrand(100,200,FALSE);
	launch_projectile(org,dir,avel,CT_PROJ_BLORD,self.attack_speed);
};

void(vector leftofs, vector rightofs, float sbframe, float chfeet) bogl_slimeball = {
	local vector org;
	if (self.health < 1) return;

	SUB_CreateSelfAttachment("",0.85); // Check if attachment has been setup yet
	SUB_CreateSelfAttachment2("",0.85);
	SUB_CreateSelfAttachment3("",1.00);
	
	// Frame 0 is start of the sequence (move everything into place)
	if (sbframe == 0) {
		setorigin(self.attachment, self.origin);
		if (self.spawnflags & MON_BOGL_STRONG) 
			setmodel(self.attachment, MODEL_PROJ_BLORD2B);
		else setmodel(self.attachment, MODEL_PROJ_BLORD1B);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		
		setorigin(self.attachment2, self.origin);
		if (self.spawnflags & MON_BOGL_STRONG) 
			setmodel(self.attachment2, MODEL_PROJ_BLORD2B);
		else setmodel(self.attachment2, MODEL_PROJ_BLORD1B);
		setsize (self.attachment2, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment2.movetype = MOVETYPE_NONE;
		self.attachment2.solid = SOLID_NOT;
	}
	
	// Move+Turn towards enemy and make vector
	ai_charge(chfeet);
	makevectors(self.angles);
	
	// Generate attachment in hand (left)
	org = self.origin + attack_vector(leftofs);
	setorigin(self.attachment, org);
	self.attachment.angles_y = rint(random()*359);
	self.attachment.frame = sbframe;

	// Generate attachment in hand (right)
	org = self.origin + attack_vector(rightofs);
	setorigin(self.attachment2, org);
	self.attachment2.angles_y = rint(random()*359);
	self.attachment2.frame = sbframe;
};

void() bogl_smash1  = [$smash1,  bogl_smash2 ] { ai_charge(2);
	// Cycle around the melee sounds
	self.meleeattack = self.meleeattack + 1;
	if (self.meleeattack > 2) self.meleeattack = 0;
	// Never play the same melee sound twice
	if (self.meleeattack == 0) {
		sound(self,CHAN_VOICE, "ad171/boglord/melee1.wav",1,ATTN_NORM); }
	else if (self.meleeattack == 1) {
		sound(self,CHAN_VOICE, "ad171/boglord/melee2.wav",1,ATTN_NORM); }
	else { sound(self,CHAN_VOICE, "ad171/boglord/melee3.wav",1,ATTN_NORM); }
};
void() bogl_smash2  = [$smash2,  bogl_smash3 ] { monster_footstep(FALSE);
	bogl_slimeball('21 70 60','32 -53 64',0,6); };
void() bogl_smash3  = [$smash3,  bogl_smash4 ] {
	bogl_slimeball('-5 66 102','2 -58 104',1,6); };
void() bogl_smash4  = [$smash4,  bogl_smash5 ] {
	bogl_slimeball('-34 48 122','-34 -48 124',2,5); };
void() bogl_smash5  = [$smash5,  bogl_smash6 ] {
	bogl_slimeball('-58 30 114','-60 -30 114',3,4); };
void() bogl_smash6  = [$smash6,  bogl_smash7 ] {
	bogl_slimeball('-58 20 109','-62 -17 110',4,1); };
void() bogl_smash7  = [$smash7,  bogl_smash8 ] {
	bogl_slimeball('-24 20 114','-26 -14 124',5,0); };
void() bogl_smash8  = [$smash8,  bogl_smash9 ] {
	bogl_slimeball('32 24 108','42 -18 108',6,0); };
void() bogl_smash9  = [$smash9,  bogl_smash10] {
	bogl_throwslime('32 24 108','42 -18 108'); };
void() bogl_smash10 = [$smash10, bogl_smash11] { ai_charge(0); };
void() bogl_smash11 = [$smash11, bogl_smash12] { ai_charge(5); };
void() bogl_smash12 = [$smash12, bogl_run1	 ] { ai_charge(4); };

// RANGE ATTACK 2 - Projectile Lightning attack
void() bogl_lightning = { // [FUNCTION]
	local vector org, dir, vec;
	if (self.health < 1) return;
	
	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;

	// Setup skill based attack speed
	self.attack_speed = SPEED_BLORDBOLT + (skill * SPEED_BLORDSKILL);
	sound(self,CHAN_WEAPON,"ad171/gaunt/plasma_fire.wav",1,ATTN_NORM);	

	// Aim around player
	makevectors(self.angles);
	org = self.pos3 + vecrand(10,10,1);
	vec = v_right*(crandom()*(20+random()*50));
	dir = normalize((self.enemy.origin + vec) - org);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_BLBOLT,self.attack_speed);	
	org = self.pos3 + vecrand(10,10,1);
	vec = v_right*(crandom()*(20+random()*50));
	dir = normalize((self.enemy.origin + vec) - org);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_BLBOLT,self.attack_speed);	
};

void(vector leftofs, vector rightofs, float sbframe) bogl_casting = {
	local vector dir, tang;
	local float midpoint;
	if (self.health < 1) return;

	SUB_CreateSelfAttachment("",0.85); // Check if attachment has been setup yet
	SUB_CreateSelfAttachment2("",0.85);
	SUB_CreateSelfAttachment3("",1.00);
	if (sbframe == 0) { // Frame 0 is start of the sequence (move everything into place)
		setorigin(self.attachment, self.origin);
		if (self.spawnflags & MON_BOGL_STRONG) 
			setmodel(self.attachment, MODEL_PROJ_BLORDBEAM2);
		else setmodel(self.attachment, MODEL_PROJ_BLORDBEAM1);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		self.attachment.frame = 1;

		setorigin(self.attachment2, self.origin);
		if (self.spawnflags & MON_BOGL_STRONG) 
			setmodel(self.attachment2, MODEL_PROJ_BLORDBEAM2);
		else setmodel(self.attachment2, MODEL_PROJ_BLORDBEAM1);
		setsize (self.attachment2, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment2.movetype = MOVETYPE_NONE;
		self.attachment2.solid = SOLID_NOT;
		self.attachment2.frame = 1;

		setorigin(self.attachment3, self.origin);
		if (self.spawnflags & MON_BOGL_STRONG) 
			setmodel(self.attachment3, MODEL_PROJ_BLORD2B);
		else setmodel(self.attachment3, MODEL_PROJ_BLORD1B);
		setsize (self.attachment3, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment3.movetype = MOVETYPE_NONE;
		self.attachment3.solid = SOLID_NOT;
	}
	
	// Turn toward enemy
	ai_face();
	makevectors(self.angles);

	// Work out each hand position
	self.pos1 = self.origin + attack_vector(leftofs);
	self.pos2 = self.origin + attack_vector(rightofs);
	dir = normalize(self.pos2 - self.pos1);
	tang = vectoangles(dir);
	// Calculate the mid point between the hands for the orb
	midpoint = vlen(self.pos2 - self.pos1) * 0.5;
	self.pos3 = self.pos1 + (dir*midpoint);

	// Move beam sections into place along vector
	setorigin(self.attachment, self.pos1+(dir*16));
	setorigin(self.attachment2, self.pos2-(dir*16));
	self.attachment.angles = self.attachment2.angles = tang;
	
	// Place orb in the center of the electricity
	setorigin(self.attachment3, self.pos3);
	self.attachment3.angles_y = rint(random()*359);
	self.attachment3.frame = sbframe+8;
	
	particle_explode(self.pos1, 5+random()*5, 1, self.part_style, PARTICLE_BURST_LOSTUP);
	particle_explode(self.pos2, 5+random()*5, 1, self.part_style, PARTICLE_BURST_LOSTUP);	
};

void() bogl_magic1 = [$magic1, bogl_magic2 ] { ai_face();
	self.pain_finished = time + 1;
	sound(self,CHAN_WEAPON,"ad171/boglord/attack2.wav",1,ATTN_NORM); };
void() bogl_magic2 = [$magic2, bogl_magic3 ] { bogl_casting('0 53 86','21 -10 102',0); };
void() bogl_magic3 = [$magic3, bogl_magic4 ] { bogl_casting('-16 50 95','11 0 108',1); };
void() bogl_magic4 = [$magic4, bogl_magic5 ] { monster_footstep(FALSE); bogl_casting('-28 48 100','6 3 110',2); };
void() bogl_magic5 = [$magic5, bogl_magic6 ] { bogl_casting('-3 34 119','19 -15 110',3); };
void() bogl_magic6 = [$magic6, bogl_magic9 ] { bogl_lightning();
	// Finished with growing ball of energy
	SUB_FinishAttachments();
	SpawnExplosion(self.part_life, self.pos3, "quoth/drole/explode3.wav");
};
void() bogl_magic9 = [$magic9, bogl_magic10 ] { bogl_lightning(); };
void() bogl_magic10 = [$magic10, bogl_magic11 ] { bogl_lightning();monster_footstep(FALSE); };
void() bogl_magic11 = [$magic11, bogl_magic12 ] {
	if (skill == SKILL_NIGHTMARE) bogl_lightning(); };
void() bogl_magic12 = [$magic12, bogl_run1 ] {};

void() bogl_tetherattack = { // [FUNCTION]
	// Completely randomize tether attack chance 50/50
	// Both attacks have different advantages with different
	// skill levels, might as well make it equal chance
	if (random() > 0.5) self.th_melee();
	else self.th_missile();
};

void() bogl_pain1 = [$pain1, bogl_pain2 ] {};
void() bogl_pain2 = [$pain2, bogl_pain3 ] {};
void() bogl_pain3 = [$pain3, bogl_pain4 ] {};
void() bogl_pain4 = [$pain4, bogl_pain5 ] {};
void() bogl_pain5 = [$pain5, bogl_pain6 ] {};
void() bogl_pain6 = [$pain6, bogl_run1  ] {};

void(entity inflictor, entity attacker, float damage) bogl_pain = {
	// Finish with all attachments
	SUB_FinishAttachments();

	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		if (random() < 0.5) sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		else sound(self,CHAN_VOICE, self.pain_sound2,1,ATTN_NORM);
		if (self.pain_check == 1 || self.pain_check == 2) bogl_pain1();
	}
};

// Classic death pose! Dead Boggy!
void() bogl_death1  = [$death1,  bogl_death2  ] {};
void() bogl_death2  = [$death2,  bogl_death3  ] { monster_check_gib(); };
void() bogl_death3  = [$death3,  bogl_death4  ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() bogl_death4  = [$death4,  bogl_death5  ] {};
void() bogl_death5  = [$death5,  bogl_death6  ] {};
void() bogl_death6  = [$death6,  bogl_death7  ] {};
void() bogl_death7  = [$death7,  bogl_death8  ] {};
void() bogl_death8  = [$death8,  bogl_death9  ] {};
void() bogl_death9  = [$death9,  bogl_death10 ] {};
void() bogl_death10 = [$death10, bogl_death11 ] { monster_death_postcheck(); };
void() bogl_death11 = [$death11, bogl_death11 ] { monster_deadbody_check(); };

void() bogl_die = {
	SUB_FinishAttachments(); // Finish and remove all attachments
	SUB_RemoveAttachments();
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	if (!self.gibbed) { // Regular death
		sound(self,CHAN_VOICE,"ad171/boglord/death1.wav",1,ATTN_NORM);
		bogl_death1();
	} else { // Explosion for gib death!
		T_RadiusDamage(self,self,self.dmg,world,DAMAGEALL);
		Tent_Explosion(self.origin); // Show classic grenade explosion effect
		SpawnExplosion(EXPLODE_SMALL,self.origin,SOUND_REXP3); // Play original explosion sound or replacement
	}
};

// Special wakeup animation for attacking/breaking something infront
// The monster should be setup facing the right direction before call
// Starts in large overhead swing downwards (no damage checks)
void() bogl_wakeup1 = [$smash7,		bogl_wakeup2 ] {};
void() bogl_wakeup2 = [$smash8,		bogl_wakeup3 ] { sound(self,CHAN_VOICE, "ad171/boglord/melee3.wav",1,ATTN_NORM); };
void() bogl_wakeup3 = [$smash9,		bogl_wakeup4 ] {};
void() bogl_wakeup4 = [$smash10,	bogl_wakeup5 ] {};
void() bogl_wakeup5 = [$smash11,	bogl_wakeup6 ] {};
void() bogl_wakeup6 = [$smash12,	bogl_run1 ] {};

void() monster_boglord_precache = {
	precache_poisongibs(); // precache gibs
	precache_model ("progs/ad171/mon_bossboglord.mdl");
	precache_model ("progs/ad171/h_boglordb.mdl");
	precache_model ("progs/ad171/gib_blclaw1b.mdl");
	precache_model ("progs/ad171/gib_blclaw2b.mdl");
	precache_model ("progs/ad171/gib_blfoot1b.mdl");
	precache_model ("progs/ad171/gib_blfoot2b.mdl");
	precache_model ("progs/ad171/h_boglord.mdl");
	precache_model ("progs/ad171/gib_blclaw1.mdl");
	precache_model ("progs/ad171/gib_blclaw2.mdl");
	precache_model ("progs/ad171/gib_blfoot1.mdl");
	precache_model ("progs/ad171/gib_blfoot2.mdl");
	precache_model (MODEL_PROJ_BLORD1B);	// Slime ball
	precache_model (MODEL_PROJ_BLORD2B);	// Fire ball
	precache_model (MODEL_PROJ_BLORD1S);	// Floor blobs
	precache_model (MODEL_PROJ_BLORDBEAM1);	// Lightning between hands
	precache_model (MODEL_PROJ_BLORDBEAM2);
	precache_model (MODEL_PROJ_BLORDBOLT1);	// Large Bolt Projectile
	precache_model (MODEL_PROJ_BLORDBOLT2);
	precache_sound("ad171/boglord/idle1.wav");
	precache_sound("ad171/boglord/idle2.wav");
	precache_sound("ad171/boglord/death1.wav");
	precache_sound("ad171/boglord/pain1.wav");
	precache_sound("ad171/boglord/pain2.wav");
	precache_sound("ad171/boglord/melee1.wav");
	precache_sound("ad171/boglord/melee2.wav");
	precache_sound("ad171/boglord/melee3.wav");
	precache_sound("ad171/gaunt/plasma_fire.wav");
	precache_sound("ad171/boglord/attack2.wav");
	precache_sound("quoth/drole/explode3.wav");
	precache_sound("ad171/wraith/bounce.wav");
	precache_sound("ad171/boglord/sight.wav");
	precache_sound("ad171/boglord/thud.wav");
	precache_sound("ad171/boglord/bangdoor1.wav");
	precache_sound("ad171/boglord/bangdoor2.wav");
};

// QUAKED monster_boglord (1 0 0) (-32 -32 -24) (32 32 64) Ambush
void() monster_boglord = {
	self.mdl = "progs/ad171/mon_bossboglord.mdl"; // One model, two skins.
	// Detect version types
	if (self.spawnflags & MON_BOGL_STRONG) {
		// Unique models for blood trail on model flag
		self.headmdl = "progs/ad171/h_boglordb.mdl";		// +2 skins
		self.gib1mdl = "progs/ad171/gib_blclaw1b.mdl";	// Left claw
		self.gib2mdl = "progs/ad171/gib_blclaw2b.mdl";	// Right claw
		self.gib3mdl = "progs/ad171/gib_blfoot1b.mdl";	// foot
		self.gib4mdl = "progs/ad171/gib_blfoot2b.mdl";	// foot
		self.part_style = PARTICLE_BURST_RED;
		self.part_life = EXPLODE_MED;
		if (self.health < 1) self.health = 2000;
		self.exactskin = 1;			// Dark red/purple
		self.poisonous = FALSE;		// Cannot be poisonous
		self.deathstring = " was toasted by a Fire Shambler\n";
	} else {
		// Unique models for wizard trail on model flags
		self.headmdl = "progs/ad171/h_boglord.mdl";		// +2 skins
		self.gib1mdl = "progs/ad171/gib_blclaw1.mdl";		// Left claw
		self.gib2mdl = "progs/ad171/gib_blclaw2.mdl";		// Right claw
		self.gib3mdl = "progs/ad171/gib_blfoot1.mdl";		// foot
		self.gib4mdl = "progs/ad171/gib_blfoot2.mdl";		// foot
		self.part_style = PARTICLE_BURST_YELLOW;
		self.part_life = EXPLODE_POISON_MED;
		if (self.health < 1) self.health = 1200;
		self.exactskin = 0;				// Swampy green
		self.poisonous = TRUE;			// Green vulcan blood!
		self.gibtype = GIBTYPE_POISON;	// Liquid Poison
		self.deathstring = " was obliterated by The Bog Lord\n";
	}	
	
	self.idle_sound = "ad171/boglord/idle1.wav";
	self.idle_sound2 = "ad171/boglord/idle2.wav";
	self.pain_sound = "ad171/boglord/pain1.wav";
	self.pain_sound2 = "ad171/boglord/pain2.wav";
	self.sight_sound = "ad171/boglord/sight.wav";
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) {
		self.bbmins = '-32 -32 -24';	// Special Size
		self.bbmaxs = '32 32 80';
		self.bboxtype = BBOX_CUSTOM;	// Custom size
	}

	self.gibhealth = -60;			// Shambler gibness!
	self.gibbed = FALSE;			// Starts complete
	self.pain_flinch = 400;			// Really low chance of pain
	self.pain_timeout = 2;			// long pause on pain
	if (self.infightextra <= 0) self.infightextra = 8;
	self.steptype = FS_TYPELARGE;	// Large stomping feet
	self.blockudeath = TRUE;		// No player gib sound
	self.pain_longanim = FALSE;		// cannot be chopped with shadow axe
	self.no_liquiddmg = TRUE;		// no slime/lava damage
	self.tetherturn = TRUE;			// Always turn towards enemy
	self.tetherpause = 0.9;			// Rarely pauses to attacks
	self.dmg = 40;					// Radius dmg for gibondeath
	
	// Special Rage attack mode ( >0 = enabled )
	// Closer to 0 = Lightning attack, Closer to 1 = Ball attack
	// Make sure percentage chance within range of 0-1
	self.attack_rage = SUB_ClampFloat(self.attack_rage,0,1);
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_rockets = self.resist_cells = 0.75;
	self.resist_multi_rockets = 0.75;
	self.resist_plasma = 0.75;
	self.reflectlightning = TRUE;	// Reflect lightning strikes
	self.reflectplasma = TRUE;		// Reflect plasma projectiles
	self.th_checkattack = BogLordCheckAttack;
	self.th_stand = bogl_stand1;
	self.th_walk = bogl_walk1;
	self.th_run = bogl_run1;
	self.th_melee = bogl_smash1;
	self.th_missile = bogl_magic1;
	self.th_pain = bogl_pain;
	self.th_die = bogl_die;
	self.th_wakeup = bogl_wakeup1;
	self.th_tether = bogl_tetherattack;
	self.classtype = CT_MONBOGLORD;
	self.classgroup = CG_DEMON;
	self.classmove = MON_MOVEWALK;
	monster_start();
};