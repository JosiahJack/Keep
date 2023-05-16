//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake and An Old, Old Evil by Patrick Martin
//               id1
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
// Entity count: 4
// Function count: 70
//
// Implements: Scrag, Drake, Fire God's Minion aka Lava Scrag
//
// Description:
// A floating fleshy horror that spits slime at you.
//
// "Floats like a butterfly, stings like a bee. Ugly as hell. They're not 
//  real tough, but like to bushwhack you."  -id1 Quake manual
//
// The alternate Drake is a dark green version that is poisonous.
//
// The alternate Fire God's Minion, aka Lava Scrag, is made of lava, has
// chthon's face and fireball spit that has a chance to set things on fire.
//=============================================================================

$cd id1/models/a_wizard
$origin 0 0 24
$base wizbase	
$skin wizbase
$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14
$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10 magatt11 magatt12 magatt13
$frame pain1 pain2 pain3 pain4
$frame death1 death2 death3 death4 death5 death6 death7 death8

void()	wiz_stand1	= [	$hover1,		wiz_stand2	] { monster_idle_sound(); ai_stand(); };
void()	wiz_stand2	= [	$hover2,		wiz_stand3	] { ai_stand(); };
void()	wiz_stand3	= [	$hover3,		wiz_stand4	] { ai_stand(); };
void()	wiz_stand4	= [	$hover4,		wiz_stand5	] { ai_stand(); };
void()	wiz_stand5	= [	$hover5,		wiz_stand6	] { ai_stand(); };
void()	wiz_stand6	= [	$hover6,		wiz_stand7	] { ai_stand(); };
void()	wiz_stand7	= [	$hover7,		wiz_stand8	] { ai_stand(); };
void()	wiz_stand8	= [	$hover8,		wiz_stand1	] { ai_stand(); };

void()	wiz_walk1	= [	$hover1,		wiz_walk2	] { monster_idle_sound(); ai_walk(8); };
void()	wiz_walk2	= [	$hover2,		wiz_walk3	] { ai_walk(8); };
void()	wiz_walk3	= [	$hover3,		wiz_walk4	] { ai_walk(8); };
void()	wiz_walk4	= [	$hover4,		wiz_walk5	] { ai_walk(8); };
void()	wiz_walk5	= [	$hover5,		wiz_walk6	] { ai_walk(8); };
void()	wiz_walk6	= [	$hover6,		wiz_walk7	] { ai_walk(8); };
void()	wiz_walk7	= [	$hover7,		wiz_walk8	] { ai_walk(8); };
void()	wiz_walk8	= [	$hover8,		wiz_walk1	] { ai_walk(8); };

void()	wiz_side1	= [	$hover1,		wiz_side2	] { monster_idle_sound(); ai_run(8); };
void()	wiz_side2	= [	$hover2,		wiz_side3	] { ai_run(8); };
void()	wiz_side3	= [	$hover3,		wiz_side4	] { ai_run(8); };
void()	wiz_side4	= [	$hover4,		wiz_side5	] { ai_run(8); };
void()	wiz_side5	= [	$hover5,		wiz_side6	] { ai_run(8); };
void()	wiz_side6	= [	$hover6,		wiz_side7	] { ai_run(8); };
void()	wiz_side7	= [	$hover7,		wiz_side8	] { ai_run(8); };
void()	wiz_side8	= [	$hover8,		wiz_side1	] { ai_run(8); };

void()	wiz_run1	= [	$fly1,		wiz_run2	] { monster_idle_sound(); ai_run(16); };
void()	wiz_run2	= [	$fly2,		wiz_run3	] { ai_run(16); };
void()	wiz_run3	= [	$fly3,		wiz_run4	] { ai_run(16); };
void()	wiz_run4	= [	$fly4,		wiz_run5	] { ai_run(16); };
void()	wiz_run5	= [	$fly5,		wiz_run6	] { ai_run(16); };
void()	wiz_run6	= [	$fly6,		wiz_run7	] { ai_run(16); };
void()	wiz_run7	= [	$fly7,		wiz_run8	] { ai_run(16); };
void()	wiz_run8	= [	$fly8,		wiz_run9	] { ai_run(16); };
void()	wiz_run9	= [	$fly9,		wiz_run10	] { ai_run(16); };
void()	wiz_run10	= [	$fly10,		wiz_run11	] { ai_run(16); };
void()	wiz_run11	= [	$fly11,		wiz_run12	] { ai_run(16); };
void()	wiz_run12	= [	$fly12,		wiz_run13	] { ai_run(16); };
void()	wiz_run13	= [	$fly13,		wiz_run14	] { ai_run(16); };
void()	wiz_run14	= [	$fly14,		wiz_run1	] { ai_run(16); };

// Range attack
void()	WizardAttackFinished = {
	SUB_AttackFinished(2);
	if (enemy_range >= RANGE_MID || !enemy_vis) {
		self.attack_state = AS_STRAIGHT;
		self.think = wiz_run1;
	}
	else {
		self.attack_state = AS_SLIDING;
		self.think = wiz_side1;
	}
};

// Fire spit missile towards player position
// The missile is setup and defined beforehand
void() Wiz_FastFire = {
	local vector vec, dst;

	if (self.owner.health > 0) {
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;
		makevectors(SUB_angEnemyTarget());	
		dst = SUB_orgEnemyTarget() - 13*self.movedir;
		vec = normalize(dst - self.origin);
		self.attack_speed = SPEED_WIZSPIKE + (skill * SPEED_WIZSKILL);
		if (self.owner.classtype == CT_MONWIZBOSS) {
			sound(self,CHAN_WEAPON,"anevil/wizboss/wattack.wav",1,ATTN_NORM);
			newmis = launch_projectile(self.origin,vec,NO_SPIN,CT_PROJ_WIZBOSS,self.attack_speed);
			if (newmis) newmis.classname = "knightspike"; // Firey impact for lava ball spit.
		} else {
			sound(self,CHAN_WEAPON,"wizard/wattack.wav",1,ATTN_NORM);
			newmis = launch_projectile(self.origin,vec,NO_SPIN,CT_PROJ_WIZ,self.attack_speed);
		}
		if (newmis) newmis.owner = self.owner;
	}

	remove(self);
};

// Create two spit missiles ready for firing later (delay 0.6, 1.0)
// This code is hoping the player will strafe into the second shot
void() Wiz_StartFast = {
	if (self.classtype == CT_MONWIZBOSS) sound(self,CHAN_WEAPON,"anevil/wizboss/wattack.wav",1,ATTN_NORM);
	else sound(self,CHAN_WEAPON,"wizard/wattack.wav",1,ATTN_NORM);
	self.v_angle = self.angles;
	makevectors(self.angles);
	newmis = spawn();
	newmis.owner = self;
	newmis.nextthink = time + 0.6;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin(newmis, self.origin + self.attack_offset + v_forward*14 + v_right*14);
	newmis.enemy = SUB_entEnemyTarget();
	newmis.nextthink = time + 0.8;
	newmis.think = Wiz_FastFire;
	newmis.movedir = v_right;
	newmis = spawn();
	newmis.owner = self;
	newmis.nextthink = time + 1;
	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);		
	setorigin(newmis, self.origin + self.attack_offset + v_forward*14 + v_right* -14);
	newmis.enemy = SUB_entEnemyTarget();
	newmis.nextthink = time + 0.3;
	newmis.think = Wiz_FastFire;
	newmis.movedir = VEC_ORIGIN - v_right;
};

void()	wiz_fast1	= [	$magatt1,		wiz_fast2	] { ai_face();Wiz_StartFast(); };
void()	wiz_fast2	= [	$magatt2,		wiz_fast3	] { ai_face(); };
void()	wiz_fast3	= [	$magatt3,		wiz_fast4	] { ai_face(); };
void()	wiz_fast4	= [	$magatt4,		wiz_fast5	] { ai_face(); };
void()	wiz_fast5	= [	$magatt5,		wiz_fast6	] { ai_face(); };
void()	wiz_fast6	= [	$magatt6,		wiz_fast7	] { ai_face(); };
void()	wiz_fast7	= [	$magatt5,		wiz_fast8	] { ai_face(); };
void()	wiz_fast8	= [	$magatt4,		wiz_fast9	] { ai_face(); };
void()	wiz_fast9	= [	$magatt3,		wiz_fast10] { ai_face(); };
void()	wiz_fast10= [	$magatt2,		wiz_run1	] { WizardAttackFinished(); ai_face(); };

void()	wiz_wakeup = [$hover1, wiz_run1 ] {
	if (pointcontents(self.origin) == CONTENT_SOLID) { // Is the wizard stuck? cannot move?
		self.health = self.gibhealth;
		Killed(self, self); // Time to die!
	} else {
		monster_sightsound(); // Setup goals and warn other monsters
		FoundHuntTarget(TRUE);
		self.th_stand = wiz_stand1; // Restore all think state functions
		self.th_walk = wiz_walk1;
		self.th_run = wiz_run1;
		self.th_missile = wiz_fast1;
		self.th_slide = wiz_side1;
	}
};

void()	wiz_pain1	= [	$pain1,		wiz_pain2	] {};
void()	wiz_pain2	= [	$pain2,		wiz_pain3	] {};
void()	wiz_pain3	= [	$pain3,		wiz_pain4	] {};
void()	wiz_pain4	= [	$pain4,		wiz_run1	] {};

void(entity inflictor, entity attacker, float damage) wiz_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		if (self.pain_check == 1) wiz_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 0.4;
			self.axhitme = 0;
			wiz_pain1();
		}
	}
};

void()	wiz_death1	= [	$death1,		wiz_death2	] {};
void()	wiz_death2	= [	$death2,		wiz_death3	] { monster_check_gib(); };
void()	wiz_death3	= [	$death3,		wiz_death4	] { monster_check_gib(); self.solid = SOLID_NOT; };
void()	wiz_death4	= [	$death4,		wiz_death5	] {};
void()	wiz_death5	= [	$death5,		wiz_death6	] {};
void()	wiz_death6	= [	$death6,		wiz_death7	] {};
void()	wiz_death7	= [	$death7,		wiz_death8	] { monster_death_postcheck(); };
void()	wiz_death8	= [	$death8,		wiz_death8	] { monster_deadbody_check(); };

void() wiz_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	if (!self.gibbed) { 
		sound(self,CHAN_VOICE, "wizard/wdeath.wav",1,ATTN_NORM);
		self.velocity_x = -200 + 400*random();
		self.velocity_y = -200 + 400*random();
		self.velocity_z = 100 + 100*random();
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.movetype = MOVETYPE_TOSS;			// Affected by gravity
		wiz_death1();
	}
};

void() monster_wizard_precache = {
	precache_model ("progs/ad171/mon_wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model (MODEL_PROJ_WIZ);		// Originally progs/w_spike.mdl
	precache_model ("progs/ad171/gib_wzarm1.mdl");
	precache_model ("progs/ad171/gib_wzarm2.mdl");
	precache_model ("progs/ad171/gib_wztail.mdl");
	precache_model("progs/drake/wizard.mdl"); // Dark Green, called Drake
	precache_model ("progs/drake/h_drake.mdl"); // Dark Green, called Drake
	precache_model ("progs/drake/gr_gib.mdl"); // Dark Green, Drake gib
	precache_model ("progs/drake/gr_gib2.mdl"); // Dark Green, Drake gib
	precache_model ("progs/drake/gr_gib3.mdl"); // Dark Green, Drake gib
	precache_model("progs/anevil/wizboss.mdl"); // Lava version
	precache_model("progs/anevil/h_wboss.mdl"); // Lava version
	precache_model("progs/anevil/wbspike.mdl"); // Lava spit
	precache_sound("wizard/widle1.wav");
	precache_sound("wizard/widle2.wav");
	precache_sound("wizard/wdeath.wav");
	precache_sound("wizard/wpain.wav");
	precache_sound("wizard/hit.wav");		// used by c code
	precache_sound("wizard/wattack.wav");
	precache_sound("wizard/wsight.wav");
	precache_sound("anevil/wizboss/cwhit.wav");
	precache_sound("anevil/wizboss/wattack.wav");
	precache_sound("anevil/wizboss/wdeath.wav");
	precache_sound("anevil/wizboss/widle1.wav");
	precache_sound("anevil/wizboss/widle2.wav");
	precache_sound("anevil/wizboss/wpain.wav");
	precache_sound("anevil/wizboss/wsight.wav");
};

void() setup_wizard;

// QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_wizard = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/ad171/mon_wizard.mdl";
	self.headmdl = "progs/h_wizard.mdl";
	self.gib1mdl = "progs/ad171/gib_wzarm1.mdl";	// Left arm/stump
	self.gib2mdl = "progs/ad171/gib_wzarm2.mdl";	// Right arm/stump
	self.gib3mdl = "progs/ad171/gib_wztail.mdl";	// Tail section
	self.idle_sound = "wizard/widle1.wav";
	self.idle_sound2 = "wizard/widle2.wav";
	self.pain_sound = "wizard/wpain.wav";
	self.sight_sound = "wizard/wsight.wav";
	self.death_sound = "wizard/wdeath.wav";
	if (self.classtype != CT_CACHEWIZARD) setup_wizard(); // Cache gargoyle is a special class used for precache only
};

void() monster_wizboss = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/anevil/wizboss.mdl";
	self.headmdl = "progs/anevil/h_wboss.mdl";
	self.idle_sound = "anevil/wizboss/widle1.wav";
	self.idle_sound2 = "anevil/wizboss/widle2.wav";
	self.pain_sound = "anevil/wizboss/wpain.wav";
	self.sight_sound = "anevil/wizboss/wsight.wav";
	self.hello_sound = "anevil/wizboss/widle1.wav";
	self.death_sound = "anevil/wizboss/wdeath.wav";
	self.classtype = CT_MONWIZBOSS;
	setup_wizard();
};

void() monster_drake = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/drake/wizard.mdl";
	self.headmdl = "progs/h_wizard.mdl";
	self.idle_sound = "wizard/widle1.wav";
	self.idle_sound2 = "wizard/widle2.wav";
	self.pain_sound = "wizard/wpain.wav";
	self.sight_sound = "wizard/wsight.wav";
	self.death_sound = "wizard/wdeath.wav";
	self.exactskin = 1;
	self.classtype = CT_MONDRAKE;
	setup_wizard();
};

void() monster_nourminion = { // [ENTITY]
	self.classtype = CT_CACHEWIZARD; 
	monster_wizard();
};

void() setup_wizard = { // [FUNCTION]
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	self.gibbed = FALSE;				// Not fallen apart as of yet
	self.pain_flinch = 70;				// high pain threshold
	self.pain_longanim = TRUE;			// Has long pain animation for Shadow Axe
	self.blockudeath = TRUE;			// no humanoid death sound
	self.steptype = FS_FLYING;			// Wandering around!
	if (self.height == 0) self.height = MONAI_ABOVEDIST; // Custom height
	self.attack_offset = '0 0 30';		// Acid spit start location

	// Allow wizards to keep a certain distance above the enemy
	if (self.spawnflags & MON_WIZARD_ABOVE) {
		self.th_checkattack = StrafeFlyerCheckAttack;
	} else {
		// Default behaviour, really high distance checks
		self.th_checkattack = WizardCheckAttack;
	}
	self.th_pain = wiz_pain;
	self.th_die = wiz_die;
	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = wiz_fast1;
	self.th_slide = wiz_side1;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (!self.classtype) self.classtype = CT_MONWIZARD;
	if (!self.classgroup) self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;
	if (self.classtype == CT_MINIONWIZARD) {
		self.th_stand = self.th_walk = self.th_run = wiz_wakeup;
		self.th_missile = self.th_slide = wiz_wakeup;
		if (self.deathstring == "") self.deathstring = " was wrecked by a Scrag\n";
	} else if (self.classtype == CT_MONWIZBOSS) {
		if (self.health < 1) self.health = 300;
		if (self.gibhealth == 0) self.gibhealth = -40;
		self.bloodtype = BLOOD_FIRE;
		if (self.deathstring == "") self.deathstring = " was fried by the Fire God's minion\n";
	} else if (self.classtype == CT_MONDRAKE) {
		self.gib1skin = 2;
		self.bloodtype = BLOOD_GREEN;
		self.gib1mdl = "progs/h_wizard.mdl"; // Dark green skin with blood is here. drake/'s is all green.
		self.gib2mdl = "progs/drake/gr_gib.mdl";
		self.gib3mdl = "progs/drake/gr_gib2.mdl";
		self.gib4mdl = "progs/drake/gr_gib3.mdl";
		if (self.deathstring == "") self.deathstring = " was Martin murdered by a Drake\n";
		self.poisonous = 1;
	} else {
		if (self.deathstring == "") self.deathstring = " was scragged by a Scrag\n";
	}
	if (self.health < 1) self.health = 80;
	if (self.gibhealth == 0) self.gibhealth = -30;
	monster_start();
};

// A code way to spawn wizards (requires monster_nourminion entity)
void(vector minion_org, entity minion_targ, float minion_sflag) minion_wizard = {
	local entity minion;

	if (!InOpenOrLiquid(minion_org)) return; // Check if there is space to spawn entity
	
	// Self = minotaur, there is no egg 
	update_minioncount(self, 1);			// Update spawn counters	
	minion = spawn();
	minion.classname = "monster_wizard";	// For function searching
	setorigin(minion, minion_org);			// Move to new location
	minion.owner = self;					// Spawner Parent Link
	minion.effects = minion.flags = 0;		// make sure are blank
	minion.gibondeath = 1;					// Always gib on death
	minion.classtype = CT_MINIONWIZARD;		// Special minion class
	minion.enemy = minion_targ;				// Target to attack
	minion.spawnflags = minion_sflag;		// Spawnflags
	minion.classgroup = CG_WIZARD;			// Don't turn on master
	minion.minion_active = TRUE;			// Minion flag
	minion.bodyfadeaway = TRUE;				// Get rid of body
	minion.mdl = "progs/ad171/mon_wizard.mdl";
	minion.headmdl = "progs/h_wizard.mdl";
	minion.gib1mdl = "progs/ad171/gib_wzarm1.mdl";	// Left arm/stump
	minion.gib2mdl = "progs/ad171/gib_wzarm2.mdl";	// Right arm/stump
	minion.gib3mdl = "progs/ad171/gib_wztail.mdl";	// Tail section
	minion.pain_sound = "wizard/wpain.wav";
	minion.idle_sound = "wizard/widle1.wav";
	minion.idle_sound2 = "wizard/widle2.wav";
	minion.sight_sound = "wizard/wsight.wav";
	minion.death_sound = "wizard/wdeath.wav";
	minion.nextthink = time + 0.01;
	minion.think = setup_wizard;
};