//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Redfield
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
// Function count: 153
//
// Implements: Moonlight Guardian, aka Wolf
//
// Description:
// A giant wolf with a sword in its mouth, guardian of the night.  Used in the
// impressive Raven Keep by Redfield.
//=============================================================================

$frame spin1 spin2 spin3 spin4 spin5 spin6 spin7 spin8
$frame spin9 spin10 spin11 spin12 spin13 spin14 spin15 spin16
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11
$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9 shoot10
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12
$frame slash1 slash2 slash3 slash4 slash5 slash6 slash7 slash8 slash9
$frame slash10 slash11 slash12 slash13 slash14 slash15 slash16 slash17
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 
$frame stand9 stand10 stand11 stand12 stand13
$frame howl1 howl2 howl3 howl4 howl5 howl6 howl7 howl8 howl9
$frame howl10 howl11 howl12 howl13 howl14 howl15 howl16 howl17
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10 pain11
$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10
$frame die11 die12 die13 die14 die15 die16

void() wolf_howl1	= [	$howl1,		wolf_howl2	] {
	self.pain_finished = time + 2;
	sound(self,CHAN_VOICE, self.sight_sound,1,ATTN_NORM);
	ai_stand();
};
void() wolf_howl2	= [	$howl2,		wolf_howl3	] { ai_stand(); };
void() wolf_howl3	= [	$howl3,		wolf_howl4	] { ai_stand(); };
void() wolf_howl4	= [	$howl4,		wolf_howl5	] { ai_stand(); };
void() wolf_howl5	= [	$howl5,		wolf_howl6	] { ai_stand(); };
void() wolf_howl6	= [	$howl6,		wolf_howl7	] { ai_stand(); };
void() wolf_howl7	= [	$howl7,		wolf_howl8	] { ai_stand(); };
void() wolf_howl8	= [	$howl8,		wolf_howl9	] { ai_stand(); };
void() wolf_howl9	= [	$howl9,		wolf_howl10	] { ai_stand(); };
void() wolf_howl10	= [	$howl10,	wolf_howl11	] { ai_stand(); };
void() wolf_howl11	= [	$howl11,	wolf_howl12	] { ai_stand(); };
void() wolf_howl12	= [	$howl12,	wolf_howl13	] { ai_stand(); };
void() wolf_howl13	= [	$howl13,	wolf_howl14	] { ai_stand(); };
void() wolf_howl14	= [	$howl14,	wolf_howl15	] { ai_stand(); };
void() wolf_howl15	= [	$howl15,	wolf_howl16	] { ai_stand(); };
void() wolf_howl16	= [	$howl16,	wolf_howl17	] { ai_stand(); };
void() wolf_howl17	= [	$howl17,	wolf_stand1	] { ai_stand(); };

void() wolf_stand1	= [	$stand1,	wolf_stand2	] { ai_stand(); };
void() wolf_stand2	= [	$stand2,	wolf_stand3	] { ai_stand(); };
void() wolf_stand3	= [	$stand3,	wolf_stand4	] { ai_stand(); monster_idle_sound(); };
void() wolf_stand4	= [	$stand4,	wolf_stand5	] { ai_stand(); };
void() wolf_stand5	= [	$stand5,	wolf_stand6	] { ai_stand(); };
void() wolf_stand6	= [	$stand6,	wolf_stand7	] { ai_stand(); };
void() wolf_stand7	= [	$stand7,	wolf_stand8	] { ai_stand(); };
void() wolf_stand8	= [	$stand8,	wolf_stand9	] { ai_stand(); };
void() wolf_stand9	= [	$stand9,	wolf_stand10	] { ai_stand(); };
void() wolf_stand10	= [	$stand10,	wolf_stand11	] { ai_stand(); };
void() wolf_stand11	= [	$stand11,	wolf_stand12	] { ai_stand(); };
void() wolf_stand12	= [	$stand12,	wolf_stand13	] { ai_stand(); };
void() wolf_stand13	= [	$stand13,	wolf_stand1	] {
if (random() < 0.05) {
		self.think = wolf_howl1;		// Howl
	}
	ai_stand();
};

void() wolf_walk1	= [	$walk1 ,	wolf_walk2	] { monster_footstep(FALSE); ai_walk(24); };
void() wolf_walk2	= [	$walk2 ,	wolf_walk3	] { ai_walk(24); };
void() wolf_walk3	= [	$walk3 ,	wolf_walk4	] { monster_footstep(FALSE); ai_walk(24); };
void() wolf_walk4	= [	$walk4 ,	wolf_walk5	] { ai_walk(24); };
void() wolf_walk5	= [	$walk5 ,	wolf_walk6	] { ai_walk(24); };
void() wolf_walk6	= [	$walk6 ,	wolf_walk7	] { ai_walk(24); };
void() wolf_walk7	= [	$walk7 ,	wolf_walk8	] { monster_footstep(FALSE); ai_walk(24); };
void() wolf_walk8	= [	$walk8 ,	wolf_walk9	] { ai_walk(24); };
void() wolf_walk9	= [	$walk9 ,	wolf_walk10	] { monster_footstep(FALSE); ai_walk(24); };
void() wolf_walk10	= [	$walk10 ,	wolf_walk11	] { ai_walk(24); };
void() wolf_walk11	= [	$walk11 ,	wolf_walk12	] { ai_walk(24); };
void() wolf_walk12	= [	$walk12 ,	wolf_walk1	] { ai_walk(24); };

void() wolf_run1	= [	$walk1  ,	wolf_run2	] { monster_footstep(FALSE); ai_run(34); self.skin = 0; };
void() wolf_run2	= [	$walk2  ,	wolf_run3	] { ai_run(34); };
void() wolf_run3	= [	$walk3  ,	wolf_run4	] { monster_footstep(FALSE); ai_run(34); };
void() wolf_run4	= [	$walk4  ,	wolf_run5	] { ai_run(34); };
void() wolf_run5	= [	$walk5  ,	wolf_run6	] { ai_run(34); };
void() wolf_run6	= [	$walk6  ,	wolf_run7	] { ai_run(34); };
void() wolf_run7	= [	$walk7  ,	wolf_run8	] { monster_footstep(FALSE); ai_run(34); };
void() wolf_run8	= [	$walk8  ,	wolf_run9	] { ai_run(34); };
void() wolf_run9	= [	$walk9  ,	wolf_run10	] { monster_footstep(FALSE); ai_run(34); };
void() wolf_run10	= [	$walk10  ,	wolf_run11	] { ai_run(34); };
void() wolf_run11	= [	$walk11  ,	wolf_run12	] { ai_run(34); };
void() wolf_run12	= [	$walk12  ,	wolf_run1	] { ai_run(34); };

// Alternate run sequence for howling start spawnflag
void() wolf_wake1	= [	$howl1,		wolf_wake2	] { ai_stand(); };
void() wolf_wake2	= [	$howl2,		wolf_wake3	] { ai_stand(); };
void() wolf_wake3	= [	$howl3,		wolf_wake4	] { ai_stand(); };
void() wolf_wake4	= [	$howl4,		wolf_wake5	] { ai_stand(); };
void() wolf_wake5	= [	$howl5,		wolf_wake6	] { ai_stand(); };
void() wolf_wake6	= [	$howl6,		wolf_wake7	] { ai_stand(); };
void() wolf_wake7	= [	$howl7,		wolf_wake8	] { ai_stand(); };
void() wolf_wake8	= [	$howl8,		wolf_wake9	] { ai_stand(); };
void() wolf_wake9	= [	$howl9,		wolf_wake10	] { ai_stand(); };
void() wolf_wake10	= [	$howl10,	wolf_wake11	] { ai_stand(); };
void() wolf_wake11	= [	$howl11,	wolf_wake12	] { ai_stand(); };
void() wolf_wake12	= [	$howl12,	wolf_wake13	] { ai_stand(); };
void() wolf_wake13	= [	$howl13,	wolf_wake14	] { ai_stand(); };
void() wolf_wake14	= [	$howl14,	wolf_wake15	] { ai_stand(); };
void() wolf_wake15	= [	$howl15,	wolf_wake16	] { ai_stand(); };
void() wolf_wake16	= [	$howl16,	wolf_wake17	] { ai_stand(); };
void() wolf_wake17	= [	$howl17,	wolf_run1	] { ai_stand(); };

void() wolf_setup_attachment = { // [FUNCTION]
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		setmodel(self.attachment, MODEL_BLUR_WOLF);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.state = TRUE;
	}
};

//Setup sword blur model effect
void(float blframe, float blalpha) wolf_blur = { // [FUNCTION]
	if (self.health < 1) return;

	SUB_CreateSelfAttachment("",1.0);
	if (blframe == 0 || blframe == 10 || blframe == 13) wolf_setup_attachment(); // Frame 0 is start of the sequence (move everything into place)
	setorigin(self.attachment, self.origin); // Place sword blur in correct loacation
	self.attachment.angles = self.angles;
	self.attachment.frame = blframe;
	self.attachment.alpha = blalpha;	
};

// Wolf Sword Melee.
void() wolf_melee = { // [FUNCTION]
	local float ldmg, oldrange;

	if (!self.enemy) return; // Removed before stroke

	ai_damagebreakable(15); // Damage any breakables
	oldrange = self.meleerange;
	self.meleerange = MONAI_MELEE2WOLF;
	if (!ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.meleerange = oldrange;
		return; // Too far away
	}

	self.meleerange = oldrange;	
	ldmg = (random() + random() + random()) * 5; // Wolf swings sword! 5-15 Damage
	if (ldmg < 5) ldmg = 5;
	T_Damage(self.enemy, self, self, ldmg, DAMARMOR);
	spawn_touchblood (self, self.enemy, ldmg*4); // Spawn some touch blood (no explicit direction)
};

void() wolf_slash1	= [	$slash1,	wolf_slash2	] { ai_face(); SUB_FinishAttachment(); };
void() wolf_slash2	= [	$slash2,	wolf_slash3	] { ai_face(); };
void() wolf_slash3	= [	$slash3,	wolf_slash4	] { ai_face(); };
void() wolf_slash4	= [	$slash4,	wolf_slash5	] { ai_chargenoturn(0); wolf_blur(10, 0.2); wolf_melee();
sound(self,CHAN_WEAPON,"redfield/wolf/sword_slash.wav",1,ATTN_NORM); };
void() wolf_slash5	= [	$slash5,	wolf_slash6	] { ai_chargenoturn(0); wolf_blur(11, 0.2); wolf_melee(); };
void() wolf_slash6	= [	$slash6,	wolf_slash7	] { ai_chargenoturn(0); wolf_blur(12, 0.1); wolf_melee(); };
void() wolf_slash7	= [	$slash7,	wolf_slash8	] { ai_chargenoturn(0); SUB_FinishAttachment(); };
void() wolf_slash8	= [	$slash8,	wolf_slash9	] { ai_chargenoturn(0); };
void() wolf_slash9	= [	$slash9,	wolf_slash10	] { ai_chargenoturn(0); };
void() wolf_slash10	= [	$slash10,	wolf_slash11	] { ai_chargenoturn(0); wolf_melee(); };
void() wolf_slash11	= [	$slash11,	wolf_slash12	] { ai_chargenoturn(0); wolf_blur(13, 0.2); wolf_melee(); };
void() wolf_slash12	= [	$slash12,	wolf_slash13	] { ai_chargenoturn(0); wolf_blur(14, 0.2); wolf_melee(); };
void() wolf_slash13	= [	$slash13,	wolf_slash14	] { ai_chargenoturn(0); wolf_blur(15, 0.1); wolf_melee(); };
void() wolf_slash14	= [	$slash14,	wolf_slash15	] { ai_chargenoturn(0); SUB_FinishAttachment(); };
void() wolf_slash15	= [	$slash15,	wolf_slash16	] { ai_chargenoturn(0); };
void() wolf_slash16	= [	$slash16,	wolf_slash17	] { ai_chargenoturn(0); };
void() wolf_slash17	= [	$slash17,	wolf_run1	] { ai_chargenoturn(0); };

void() wolf_spin1	= [	$spin1,		wolf_spin2	] { ai_chargenoturn(0); SUB_FinishAttachment(); };
void() wolf_spin2	= [	$spin2,		wolf_spin3	] { ai_chargenoturn(0);
sound(self,CHAN_WEAPON,"redfield/wolf/sword_spin.wav",1,ATTN_NORM); };
void() wolf_spin3	= [	$spin3,		wolf_spin4	] { ai_chargenoturn(0); };
void() wolf_spin4	= [	$spin4,		wolf_spin5	] { ai_chargenoturn(0); wolf_melee(); };
void() wolf_spin5	= [	$spin5,		wolf_spin6	] { ai_chargenoturn(0); };
void() wolf_spin6	= [	$spin6,		wolf_spin7	] { ai_chargenoturn(0); };
void() wolf_spin7	= [	$spin7,		wolf_spin8	] { ai_charge(40); wolf_blur(0, 0.2); wolf_melee(); };
void() wolf_spin8	= [	$spin8,		wolf_spin9	] { ai_charge(40); wolf_blur(1, 0.2); wolf_melee(); };
void() wolf_spin9	= [	$spin9,		wolf_spin10	] { ai_charge(40); wolf_blur(2, 0.2); wolf_melee(); };
void() wolf_spin10	= [	$spin10,	wolf_spin11	] { ai_charge(40); wolf_blur(3, 0.2); };
void() wolf_spin11	= [	$spin11,	wolf_spin12	] { ai_charge(40); wolf_blur(4, 0.2); };
void() wolf_spin12	= [	$spin12,	wolf_spin13	] { ai_charge(40); wolf_blur(5, 0.2); };
void() wolf_spin13	= [	$spin13,	wolf_spin14	] { ai_charge(40); wolf_blur(6, 0.2); };
void() wolf_spin14	= [	$spin14,	wolf_spin15	] { ai_charge(40); wolf_blur(7, 0.2); wolf_melee(); };
void() wolf_spin15	= [	$spin15,	wolf_spin16	] { ai_chargenoturn(0); wolf_blur(8, 0.1); wolf_melee(); };
void() wolf_spin16	= [	$spin16,	wolf_run1	] { ai_chargenoturn(0); SUB_FinishAttachment(); wolf_melee();
	if (ai_checkmelee(self.meleerange,self.meleerangez)) self.think = wolf_slash1;
};

// Magic Sword Attack
void(vector leftofsb, vector rightofsb) moonsword_charge = { // [FUNCTION]
	if (self.health < 1) return;


	// Work out 2 point positions on sword
	makevectors(self.angles);
	self.pos1 = self.origin + attack_vector(leftofsb);
	self.pos2 = self.origin + attack_vector(rightofsb);	

	// Spawn some particles around the sword
	particle_explode(self.pos1, 12+random()*2, 0.1+random()*0.2, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
	particle_explode(self.pos2, 12+random()*2, 0.1+random()*0.2, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
};

void() wolf_moonsword = { // [FUNCTION]
	local vector org, dir;

	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = normalize((self.enemy.origin + '0 0 -16')- org);
	self.attack_speed = SPEED_WOLFSWORD + (skill * SPEED_WOLFSKILL);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_MOONSWORD,self.attack_speed);
};

void() wolf_shoot1	= [	$shoot1,	wolf_shoot2	] { ai_face(); };
void() wolf_shoot2	= [	$shoot2,	wolf_shoot3	] { ai_face(); };
void() wolf_shoot3	= [	$shoot3,	wolf_shoot4	] { ai_face(); moonsword_charge('16 -72 28','0 -116 32');
sound(self,CHAN_WEAPON,"redfield/wolf/moonsword.wav",1,ATTN_NORM); };
void() wolf_shoot4	= [	$shoot4,	wolf_shoot5	] { ai_face(); moonsword_charge('0 -76 32','-24 -116 40'); self.skin = 1; };
void() wolf_shoot5	= [	$shoot5,	wolf_shoot6	] { ai_face(); };
void() wolf_shoot6	= [	$shoot6,	wolf_shoot7	] { wolf_moonsword(); };
void() wolf_shoot7	= [	$shoot7,	wolf_shoot8	] {};
void() wolf_shoot8	= [	$shoot8,	wolf_shoot9	] {};
void() wolf_shoot9	= [	$shoot9,	wolf_shoot10	] { self.skin = 0; };
void() wolf_shoot10	= [	$shoot10,	wolf_run1	] {};

// Only functions when monster spawns standing -- No walking / path corners.  Currently need solution to this problem so long as taunt animations are used
void() wolf_wakeup = { // [FUNCTION]
	// Dead already?
	if (self.health < 1) return;

	// No longer need howl spawnflag, remove it
	if (self.spawnflags & MON_WOLF_HOWL) {
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_WOLF_HOWL); }
	self.takedamage = DAMAGE_AIM;		// Can receive damage
	self.use = SUB_Null;				// no re-trigger
	
	// Restore all think state functions
	self.th_run = wolf_run1;
	self.th_melee = wolf_spin1;
	self.th_missile = wolf_shoot1;
	self.movetype = MOVETYPE_STEP;
	self.pain_finished = time + 2;		// No pain
	self.attack_finished = 1.7 + random();	// No skill adjustment
	wolf_wake1();
};

void() wolf_pain1	= [	$pain1,		wolf_pain2	] { self.skin = 0; };
void() wolf_pain2	= [	$pain2,		wolf_pain3	] {};
void() wolf_pain3	= [	$pain3,		wolf_pain4	] { ai_back(16); };
void() wolf_pain4	= [	$pain4,		wolf_pain5	] {};
void() wolf_pain5	= [	$pain5,		wolf_pain6	] {};
void() wolf_pain6	= [	$pain6,		wolf_pain7	] {};
void() wolf_pain7	= [	$pain7,		wolf_pain8	] { monster_footstep(FALSE); };
void() wolf_pain8	= [	$pain8,		wolf_pain9	] {};
void() wolf_pain9	= [	$pain9,		wolf_pain10	] {};
void() wolf_pain10	= [	$pain10,	wolf_pain11	] {};
void() wolf_pain11	= [	$pain11,	wolf_run1	] {};

void(entity inflictor, entity attacker, float damage) wolf_pain = {
	SUB_FinishAttachment(); //Reset blur attachment	

	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);	
		if (self.pain_check == 1) wolf_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 1.4;
			self.axhitme = 0;
			wolf_pain1();
		}
	}
};

void() wolf_die1	= [	$die1,		wolf_die2	] {};
void() wolf_die2	= [	$die2,		wolf_die3	] { sound(self,CHAN_VOICE, self.death_sound,1,ATTN_NORM); };
void() wolf_die3	= [	$die3,		wolf_die4	] {};
void() wolf_die4	= [	$die4,		wolf_die5	] {};
void() wolf_die5	= [	$die5,		wolf_die6	] {};
void() wolf_die6	= [	$die6,		wolf_die7	] {};
void() wolf_die7	= [	$die7,		wolf_die8	] {
particle_explode(self.origin + '0 0 -8', 96, 0.5+random()*0.5, PARTICLE_BURST_DBLUE, PARTICLE_BURST_UPWARD); };
void() wolf_die8	= [	$die8,		wolf_die9	] { self.solid = SOLID_NOT; self.skin = 2; self.alpha = 0.9; };
void() wolf_die9	= [	$die9,		wolf_die10	] { self.alpha = 0.75; };
void() wolf_die10	= [	$die10,		wolf_die11	] { self.alpha = 0.6; };
void() wolf_die11	= [	$die11,		wolf_die12	] { self.skin = 3; self.alpha = 0.5; };
void() wolf_die12	= [	$die12,		wolf_die13	] { self.alpha = 0.4;
particle_explode(self.origin + '0 0 48', 64, 1+random()*0.5, PARTICLE_BURST_DBLUE, PARTICLE_BURST_UPWARD); };
void() wolf_die13	= [	$die13,		wolf_die14	] { self.alpha = 0.25; };
void() wolf_die14	= [	$die14,		wolf_die15	] { self.skin = 4; self.alpha = 0.1;
self.effects = self.effects | EF_MUZZLEFLASH; };
void() wolf_die15	= [	$die15,		wolf_die16	] { self.alpha = 0.05;
self.effects = self.effects | EF_MUZZLEFLASH; };
void() wolf_die16	= [	$die16,		wolf_die16	] {
	// Stop thinking and hide entity (prevent wolf_death15 loop)
	self.nextthink = LARGE_TIMER;
	self.think = SUB_Null;
	entity_hide(self);
};

void() wolf_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	SUB_RemoveAttachment(); // Make sure attachments are removed
	if (!self.gibbed) wolf_die1();
};

void() monster_wolf_precache = {
	precache_model ("progs/redfield/mon_wolf.mdl");
	precache_model (MODEL_PROJ_MOONSWORD);
	precache_model (MODEL_BLUR_WOLF);
	precache_model (SEXP_ICE_BIG);		// Shard impact (ne_ruin)
	precache_sound("redfield/wolf/snarl.wav");
	precache_sound("redfield/wolf/moonsword.wav");
	precache_sound("redfield/wolf/sword_spin.wav");
	precache_sound("redfield/wolf/sword_slash.wav");
	precache_sound("redfield/wolf/w_pain.wav");
	precache_sound("redfield/wolf/d_howl.wav");
	precache_sound("redfield/wolf/s_howl.wav");
	precache_sound("drake/weapons/plasma1.wav");
};

// QUAKED monster_wolf (1 0 0) (-128 -128 -24) (128 128 128) Ambush
void() monster_wolf = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/redfield/mon_wolf.mdl";
	self.idle_sound = "redfield/wolf/snarl.wav";
	self.pain_sound = "redfield/wolf/w_pain.wav";
	self.death_sound = "redfield/wolf/d_howl.wav";
	self.sight_sound = "redfield/wolf/s_howl.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_MASSIVE;
	if (self.health < 1) self.health = 1400;
	self.gibhealth = MON_NEVERGIB;	// Cannot be gibbed by weapons
	self.gibbed = FALSE;
	self.pain_flinch = 275;				// Very High tolerance
	self.pain_timeout = 4;				// Long pause on pain
	self.pain_longanim = FALSE;			// Not able to be stunned with Cursed Blade
	self.infightextra = 2.5;			// Extreme damage to monsters
	self.steptype = FS_TYPELARGE;		// Big paws
	self.blockudeath = TRUE;			// No humanoid death sound
	self.attack_offset = '40 0 0';		// Sword attack offset
	self.meleeoffset = '40 0 16';		// Blood around sword
	self.deathstring = " was ravaged by a Wolf\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_cells = self.resist_rockets = 0.5;
	self.th_checkattack = WolfCheckAttack;
	self.meleerange = MONAI_MELEEWOLF;
	self.meleerangez = MONAI_MELEEZTALL;
	self.th_walk = wolf_walk1;
	self.th_pain = wolf_pain;
	self.th_die = wolf_die;
	self.th_stand = wolf_stand1;
	if (self.spawnflags & MON_WOLF_HOWL) { 	//Howling wolf start
		self.th_run = self.th_missile = self.th_melee = wolf_wakeup;
	} else { //Default wolf start
		self.th_melee = wolf_spin1;
		self.th_missile = wolf_shoot1;
		self.th_run = wolf_run1;
	}

	self.classgroup = CG_BOSS;
	self.classtype = CT_MONWOLF;
	self.classmove = MON_MOVEWALK;
	monster_start();
};