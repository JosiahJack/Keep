//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD), Twisted Christmas by Twisted Matrix
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
// Function count: 44
//
// Implements: Christmas Snowman
//
// Description:
// An angry snowman with a nailgun.
//=============================================================================

$frame stand1 // (000) Standing Still
$frame claw1 claw2 claw3 claw4 claw5 // (001 - 005) Fast Claw attack
$frame attack1 attack2 attack3 // (006 - 008) Fast Nail Attack
$frame base1 base2 // (009 - 010) Misc modelling stuff

void() snowm_stand1 = [$stand1, snowm_stand2 ] { monster_idle_sound(); ai_stand(); }
void() snowm_stand2 = [$stand1, snowm_stand3 ] { ai_stand(); };
void() snowm_stand3 = [$stand1, snowm_stand4 ] { ai_stand(); };
void() snowm_stand4 = [$stand1, snowm_stand5 ] { ai_stand(); };
void() snowm_stand5 = [$stand1, snowm_stand6 ] { ai_stand(); };
void() snowm_stand6 = [$stand1, snowm_stand7 ] { ai_stand(); };
void() snowm_stand7 = [$stand1, snowm_stand8 ] { ai_stand(); };
void() snowm_stand8 = [$stand1, snowm_stand1 ] { ai_stand(); };

void() snowm_walk1 = [$stand1, snowm_walk2 ] { monster_idle_sound(); ai_walk(0); }
void() snowm_walk2 = [$stand1, snowm_walk3 ] { ai_walk(0); };
void() snowm_walk3 = [$stand1, snowm_walk4 ] { ai_walk(0); };
void() snowm_walk4 = [$stand1, snowm_walk5 ] { ai_walk(0); };
void() snowm_walk5 = [$stand1, snowm_walk6 ] { ai_walk(0); };
void() snowm_walk6 = [$stand1, snowm_walk7 ] { ai_walk(0); };
void() snowm_walk7 = [$stand1, snowm_walk8 ] { ai_walk(0); };
void() snowm_walk8 = [$stand1, snowm_walk1 ] { ai_walk(0); };

void() snowm_run1 = [$stand1, snowm_run2 ] { monster_idle_sound(); ai_run(0); }
void() snowm_run2 = [$stand1, snowm_run3 ] { ai_run(0); };
void() snowm_run3 = [$stand1, snowm_run4 ] { ai_run(0); };
void() snowm_run4 = [$stand1, snowm_run5 ] { ai_run(0); };
void() snowm_run5 = [$stand1, snowm_run6 ] { ai_run(0); };
void() snowm_run6 = [$stand1, snowm_run7 ] { ai_run(0); };
void() snowm_run7 = [$stand1, snowm_run8 ] { ai_run(0); };
void() snowm_run8 = [$stand1, snowm_run1 ] { ai_run(0); };

// MELEE : Crows Claw
void() SnowmMelee = {
	local float ldmg;

	if (!self.enemy) return;
	if (self.health < 1) return;
		
	ai_damagebreakable(10);							// Damage any breakables
	if (!ai_checkmelee(self.meleerange,self.meleerangez)) return; // Too far away
	if (!self.enemy.takedamage) return; // Can the target bleed?

	sound(self,CHAN_WEAPON,"xmas/snowman/claw.wav", TRUE, TRUE);
	ldmg = (random() + random() + random()) * 5; // Claw attack is good (1-15)
	if (ldmg < 1) ldmg = 1;
	T_Damage(self.enemy, self, self, ldmg, DAMARMOR);
	spawn_touchblood (self, self.enemy, ldmg*3); // Spawn blood at claw
};

void() snowm_claw1 = [$claw1, snowm_claw2 ] { ai_face(); };
void() snowm_claw2 = [$claw2, snowm_claw3 ] { ai_face(); };
void() snowm_claw3 = [$claw3, snowm_claw4 ] { ai_face();SnowmMelee(); };
void() snowm_claw4 = [$claw4, snowm_claw5 ] {};
void() snowm_claw5 = [$claw5, snowm_run1 ] {
	// Check if snowman is within range to attack again
	if (ai_checkmelee(self.meleerange,self.meleerangez) && self.enemy.health > 0) {
		if (self.health > 0) self.think = snowm_claw1;
	}
};

// RANGE : Burst of Nails
void() SnowmFireNails = {
	local vector org, dir, vec;
	local float loopvar;
	
	// Check for death?
	if (self.health < 1) return;
	loopvar = 0;

	// Light up face, setup projectile speed and play fire sound
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.attack_speed = SPEED_NAILSNOWMPROJ + (skill * SPEED_NAILSNOWMSKILL);
	sound(self,CHAN_WEAPON,"xmas/snowman/nail_fire.wav",1,ATTN_NORM);

	// turn and face your enemy!
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	
	// Loop through the nail burst (all at once)
	while (loopvar < self.attack_count) {
		// Random circle spread pattern
		vec = (crandom()*20)*v_right + (crandom()*20)*v_up;
		dir = normalize((self.enemy.origin + vec) - org);
		// Generate a red hot nail projectile
		launch_projectile(org,dir,NO_SPIN,CT_PROJ_NG,self.attack_speed);
		loopvar = loopvar + 1;
	}
};

void() snowm_nail1 = [$attack1, snowm_nail2 ] { ai_face(); };
void() snowm_nail2 = [$attack2, snowm_nail3 ] { ai_face(); };
void() snowm_nail3 = [$attack3, snowm_nail4 ] { ai_face();SnowmFireNails(); };
void() snowm_nail4 = [$attack2, snowm_nail5 ] {};
void() snowm_nail5 = [$attack1, snowm_run1 ] { ai_face(); };


// PAIN : quick reflection

void() snowm_pain1 = [$claw4, snowm_pain2 ] {};
void() snowm_pain2 = [$claw3, snowm_pain3 ] {};
void() snowm_pain3 = [$claw2, snowm_pain4 ] {};
void() snowm_pain4 = [$claw1, snowm_run1 ] {};

void(entity inflictor, entity attacker, float damage) snowm_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		if (random() < 0.5) sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		else sound(self,CHAN_VOICE, self.pain_sound2,1,ATTN_NORM);
		if (self.pain_check == 1) snowm_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 0.6;
			self.axhitme = 0;
			snowm_pain1();
		}
	}
};

void() snowm_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	monster_deathsound();
	ExplosiveGibDeath(self.death_sound,0,0,0); // There is no death animation
};

void() monster_xmas_snowman_precache = {
	precache_model ("progs/xmas/mon_snowman.mdl");
	precache_model ("progs/xmas/h_snowman.mdl"); // Top Hat
	precache_model ("progs/xmas/gib_snowclaw.mdl"); // Claw
	precache_model ("progs/xmas/gib_snowgun.mdl"); // Gun
	precache_model ("progs/xmas/gib_snowball.mdl"); // Snow-BALLS!
	precache_model (MODEL_PROJ_NG); // Nails
	precache_sound("xmas/snowman/idle.wav");
	precache_sound("xmas/snowman/sight1.wav");
	precache_sound("xmas/snowman/sight2.wav");
	precache_sound("xmas/snowman/claw.wav"); // Melee/Range Attacks.  Original version used ice, switched to red nails.  Ice nails are really difficult to see.
	precache_sound("xmas/snowman/nail_fire.wav");
	precache_sound("xmas/snowman/pain1.wav");
	precache_sound("xmas/snowman/pain2.wav");
	precache_sound("xmas/snowman/death1.wav");
	precache_sound("xmas/snowman/death2.wav");
};

// QUAKED monster_snowman (1 0 0) (-16 -16 -24) (16 16 32) Ambush
void() monster_xmas_snowman = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/xmas/mon_snowman.mdl";		// Top Hat Snow
	self.headmdl = "progs/xmas/h_snowman.mdl";		// Top Hat
	self.gib1mdl = "progs/xmas/gib_snowclaw.mdl";	// Claw
	self.gib2mdl = "progs/xmas/gib_snowgun.mdl";	// Nail Gun
	self.gib3mdl = "progs/xmas/gib_snowball.mdl";	// Snowballs
	self.gib1sound = GIB_IMPACT_WOOD;
	self.gib2sound = GIB_IMPACT_METALA;
	self.idle_sound = "xmas/snowman/idle.wav";	// Rustling sound.  Idle for calm or angry
	self.sight_sound = "xmas/snowman/sight1.wav";	// Deep voice
	self.sight_sound2 = "xmas/snowman/sight2.wav";	// Growling
	self.pain_sound = "xmas/snowman/pain1.wav"; // precache sight, pain and death (changes on type)
	self.pain_sound2 = "xmas/snowman/pain2.wav";
	self.death_sound = "xmas/snowman/death1.wav";
	self.death_sound2 = "xmas/snowman/death2.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	if (self.health < 1) self.health = 125;
	if (self.death_dmg < 1) self.death_dmg = DAMAGE_SNOWMAN;
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	self.blockudeath = TRUE;			// No humanoid death sound
	self.gibbed = FALSE;				// Still in one peice
	self.pain_flinch = 30;				// Light pain threshold
	self.pain_longanim = FALSE;			// No long pain animation
	self.steptype = FS_TYPESLOW;		// Small sounding feet
	self.poisonous = FALSE;				// Not Supported
	self.meleeoffset = '24 0 20';		// Claw attack offset
	self.attack_offset = '24 0 20';		// Run + Gun vector
	self.bloodtype = self.bleedcolour = MON_BCOLOR_SILVER;// Red is odd for snow
	if (self.deathstring == "") self.deathstring = " was smashed on a Snowman\n";
	if (self.attack_count < 1) self.attack_count = 5; // Default amount of nails to burst fire (5x9=45dmg)
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent	
	self.th_checkattack = SnowmanCheckAttack;
	self.meleerange = MONAI_MELEESNOWMAN;
	self.meleerangez = 48;
	self.th_stand = snowm_stand1;
	self.th_walk = snowm_walk1;
	self.th_run = snowm_run1;
	self.th_melee = snowm_claw1;
	self.th_missile = snowm_nail1;
	self.th_pain = snowm_pain;
	self.th_die = snowm_die;
	self.classtype = CT_MONSNOWMAN;
	self.classgroup = CG_XMAS;
	self.classmove = MON_MOVEWALK;
	monster_start();	
};