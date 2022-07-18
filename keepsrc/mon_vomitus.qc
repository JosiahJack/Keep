//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Qmaster, id1, Drake by Patrick Martin
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
// Entity count: 3
// Function count: 104
//
// Implements: Vomitus
//
// Description:
// The vomitus monster, originally part of qtest and implemented in various
// mods in various fashions.  This one is from Drake and seems to be the best.
//=============================================================================

$cd id1/models/vomitus
$origin 0 0 24
$base base        
$skin skin
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13
$frame pain1 pain2 pain3
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15

// Vomitus attacks are placed here since they may be called during a
// non-attack animation scene.

// Vomits chunks of meat at the enemy.
void(float no) Vomit_Meat = {
    local   vector  org, dir, err;
    local   float   side, up;

    err = VEC_ORIGIN;
    if (no > 0) {
        if (random() < no) return;
        err_x = 10;
    }
    side = crandom() * 3;
    up = random() * 300;
    makevectors(self.angles);
    org = self.origin + v_forward*20 + v_right*side - v_up*6;
	dir = (self.enemy.origin - org);
	dir = normalize(dir);
	dir = dir + err;

    up = random();
    Meat_Launch (org, dir);
    if (up < 0.2) setmodel(newmis, "progs/gib1.mdl");
    else { // Bigger gibs...
        newmis.dmg = random() * 15 + 15;
        if (up < 0.4) setmodel(newmis, "progs/ad181/h_zombie.mdl");
        else if (up < 0.7) setmodel(newmis, "progs/gib2.mdl");
        else setmodel(newmis, "progs/gib3.mdl");
    }
    setsize(newmis,VEC_ORIGIN, VEC_ORIGIN);
};

// Spews forth a tarbaby.
void() Vomit_Spawn = {
    // 100% chance of vomiting meat when we've spit up all our minion spawns.
	if (self.minion_count >= self.minion_maxcount) { Vomit_Meat(0); return; }

	self.minion_count = self.minion_count + 1;
	newmis = spawn();
	sound(newmis,CHAN_VOICE,"rogue/blob/mytosis.wav",1,ATTN_NORM);
	newmis.classname = "monster_tarbaby";
	newmis.classtype = CT_MONSPAWN;
	newmis.classgroup = CG_SPAWN;
	newmis.movetype = MOVETYPE_STEP;
	newmis.classmove = MON_MOVEWALK;
	newmis.resist_shells = newmis.resist_nails = 0;
	newmis.resist_rockets = newmis.resist_cells = 0;
	newmis.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	newmis.bboxtype = BBOX_TALL;
	newmis.gibbed = FALSE;
	newmis.pain_flinch = 20;
	newmis.death_dmg = DAMAGE_TARBABY;
	newmis.health = 80;
	newmis.owner = newmis.master = self;
	newmis.death_sound = "blob/death1.wav";
	newmis.idle_sound = "blob/sight1.wav";
	newmis.sight_sound = self.idle_sound;
	newmis.pain_sound = self.idle_sound;
	newmis.solid = SOLID_SLIDEBOX;
	newmis.takedamage = DAMAGE_AIM;
	newmis.skin = self.skin;
	newmis.lastorigin = newmis.origin;           
    newmis.angles_x   = 0;
    newmis.angles_y   = self.angles_y;
    newmis.angles_z   = 0;
    newmis.fixangle   = TRUE;
	newmis.th_stand = tbaby_stand1;
	newmis.th_walk = tbaby_walk1;
	newmis.th_run = tbaby_run1;
	newmis.th_jump = tbaby_jump1;
	newmis.th_jumpexit = tbaby_jump5;
	newmis.th_missile = tbaby_jump1;
	newmis.th_melee = tbaby_jump1;
	newmis.th_die = tbaby_die1;
	newmis.th_pain = tbaby_pain;
	// Override normal ai with flying ai, since it is launched out of vomitus.
    newmis.enemy = self.enemy;
	monster_bbox();
	setmodel(newmis, "progs/qmaster/mon_tarbaby.mdl");
	setorigin(newmis, self.origin);
	setsize (newmis, '-16 -16 -24', '16 16 40');
	newmis.think = tbaby_jump5;
	newmis.nextthink = time + 0.05;
	AddToTotals(newmis);
};

// Vomitus chews on the target.
// Note:  This is called during running instead of an attack sequence.
void() vom_melee = {
    local entity targ;
    local float ldmg;

    targ = self.enemy;
    if (!targ) return; // Removed before stroke
    if (!CanDamage (targ, self)) return; // PM:  Added just in case.
    if (!infront (targ)) return; // PM:  Unusual -- must be in front of mouth.
    if (!InMeleeRange (80)) return; // PM:  Dragons-related.  Vomitus has short range for a fat monster.
    if (IsGhost(targ)) return; // Cannot hit wraith.

	// Vomitus does the following on a successful attack:
	// * Inflicts anywhere from 1 to 30 damage.
	// * Life leech: 10% of damage inflicted is given back as health to vomitus.
	// * 10% of eating the target's current weapon.
    sound(self,CHAN_VOICE, "fish/bite.wav",1,ATTN_NORM);
    // Update 6/17/2011:  Removed poison code.
    // if (random() < 0.1)     // Eat the player's weapon on a critical hit.
        // War_Steal (self, targ, "Vomitus ate your ");
    // Heal a little as it feeds on its victim.
    ldmg = SUB_MeleeDamage (10);
    T_Damage(targ, self, self, ldmg, DAMARMOR);
};

float(entity targ) IsZombieDown = {
    if (targ.classgroup == CG_ZOMBIE)
        if (targ.solid == SOLID_NOT)
            if (targ.frame == 172)  // paine11.
                return TRUE;
    return FALSE;
};

// Crushes all nearby corpses into edible gibs, healing vomitus.
void() Vomit_Crush = {
    if (GibFloorBody(self.origin,100)) T_Heal(self,30,TRUE); // Can exceed max.
};

void() ai_vomit_stand = { Vomit_Crush(); ai_stand(); };
void(float dist) ai_vomit_walk = { Vomit_Crush(); ai_walk(dist); };
void(float dist) ai_vomit_run  = {
    local float close;

    close = QC_CloseEnough(dist);
    Vomit_Crush();
    if (close) {
	   if (self.gorging) {
		   if ((self.enemy.health <= 0) && (self.enemy.solid == SOLID_NOT))
			   { walkmove (self.angles_y, dist);  return; }
		   if (self.enemy.touch == TouchGib)
			   { walkmove (self.angles_y, dist);  return; }
	   } else {
            // Move over the fallen zombie and crush it for an instakill.
            if (IsZombieDown (self.enemy))
                { walkmove (self.angles_y, dist);  return; }
            // Turn around so it can bite the target while on the run.
            if (self.enemy) ai_face();
        }
    }
    ai_run(dist);
};

void() vom_stand1 = [$walk1, vom_stand2 ] { ai_vomit_stand(); };
void() vom_stand2 = [$walk2, vom_stand3 ] { ai_vomit_stand(); };
void() vom_stand3 = [$walk3, vom_stand4 ] { ai_vomit_stand(); };
void() vom_stand4 = [$walk4, vom_stand5 ] { ai_vomit_stand(); };
void() vom_stand5 = [$walk5, vom_stand6 ] { ai_vomit_stand(); };
void() vom_stand6 = [$walk4, vom_stand7 ] { ai_vomit_stand(); };
void() vom_stand7 = [$walk3, vom_stand8 ] { ai_vomit_stand(); };
void() vom_stand8 = [$walk2, vom_stand1 ] { ai_vomit_stand(); };

void() vom_idle_sfx = {
	// Yes, use attn_norm instead of attn_idle.
    sound(self,CHAN_VOICE, "zerstorer/gibfnt/gf_plop.wav",1,ATTN_NORM);
};

void() vom_walk1  = [$walk1,  vom_walk2  ] {
    if (random() < 0.5) vom_idle_sfx();
    ai_vomit_walk(2);
};
void() vom_walk2  = [$walk2,  vom_walk3  ] { ai_vomit_walk(2); };
void() vom_walk3  = [$walk3,  vom_walk4  ] { ai_vomit_walk(2); };
void() vom_walk4  = [$walk4,  vom_walk5  ] { ai_vomit_walk(2); };
void() vom_walk5  = [$walk5,  vom_walk6  ] { ai_vomit_walk(2); };
void() vom_walk6  = [$walk6,  vom_walk7  ] { ai_vomit_walk(2); };   // 2
void() vom_walk7  = [$walk7,  vom_walk8  ] { ai_vomit_walk(2); };
void() vom_walk8  = [$walk8,  vom_walk9  ] { ai_vomit_walk(2); };
void() vom_walk9  = [$walk9,  vom_walk10 ] { ai_vomit_walk(2); };
void() vom_walk10 = [$walk10, vom_walk11 ] { ai_vomit_walk(2); };   // 1
void() vom_walk11 = [$walk11, vom_walk12 ] { ai_vomit_walk(2); };
void() vom_walk12 = [$walk12, vom_walk13 ] { ai_vomit_walk(2); };
void() vom_walk13 = [$walk13, vom_walk14 ] { ai_vomit_walk(2); };
void() vom_walk14 = [$walk14, vom_walk15 ] { ai_vomit_walk(2); };
void() vom_walk15 = [$walk15, vom_walk16 ] { ai_vomit_walk(2); };
void() vom_walk16 = [$walk16, vom_walk17 ] { ai_turn(); };
void() vom_walk17 = [$walk17, vom_walk18 ] { ai_turn(); };
void() vom_walk18 = [$walk18, vom_walk19 ] { ai_turn(); };
void() vom_walk19 = [$walk19, vom_walk20 ] { ai_turn(); };
void() vom_walk20 = [$walk20, vom_walk21 ] { ai_turn(); };
void() vom_walk21 = [$walk21, vom_walk22 ] { ai_turn(); };
void() vom_walk22 = [$walk22, vom_walk23 ] { ai_turn(); };
void() vom_walk23 = [$walk23, vom_walk24 ] { ai_turn(); };
void() vom_walk24 = [$walk24, vom_walk25 ] { ai_turn(); };
void() vom_walk25 = [$walk25, vom_walk1  ] { ai_turn(); };

void() vom_run1  = [$run1,  vom_run2  ] {
    if (random() < 0.2)
        vom_idle_sfx();
    ai_vomit_run(4);
};

void vom_die();

void() vom_run2  = [$run2,  vom_run3  ] { ai_vomit_run(4); };
void() vom_run3  = [$run3,  vom_run4  ] { ai_vomit_run(4); };
void() vom_run4  = [$run4,  vom_run5  ] { vom_melee(); ai_vomit_run(4); };
void() vom_run5  = [$run5,  vom_run6  ] { ai_vomit_run(4); };
void() vom_run6  = [$run6,  vom_run7  ] { ai_vomit_run(4); };
void() vom_run7  = [$run7,  vom_run8  ] { ai_vomit_run(4); };
void() vom_run8  = [$run8,  vom_run1  ] { ai_vomit_run(4); if (self.health < 1) vom_die(); };

void() vom_end1 = [$attack11, vom_end2     ] { ai_face(); };
void() vom_end2 = [$attack12, vom_end3     ] { ai_face(); };
void() vom_end3 = [$attack13, vom_run1     ] { ai_face(); };

void() vom_attack1  = [$attack1,  vom_attack2  ] {
    self.pain_finished = time + 1.2;    // Ignore pain during attack.
    sound(self,CHAN_WEAPON,"zerstorer/gibfnt/gf_sprt1.wav",1,ATTN_NORM);
    ai_face();
};
void() vom_attack2  = [$attack2,  vom_attack3  ] { ai_face(); };
void() vom_attack3  = [$attack3,  vom_attack4  ] { ai_face(); };
void() vom_attack4  = [$attack4,  vom_attack5  ] { ai_face(); };
void() vom_attack5  = [$attack5,  vom_attack6  ] { ai_face(); };
void() vom_attack6  = [$attack6,  vom_attack7  ] { ai_face(); };
void() vom_attack7  = [$attack7,  vom_attack8  ] { ai_face(); };
void() vom_attack8  = [$attack8,  vom_attack9  ] { ai_face(); };
void() vom_attack9  = [$attack9,  vom_attack10 ] { ai_face(); };
void() vom_attack10 = [$attack10, vom_attack11 ] { ai_face();
    if (random() < 0.5)
        sound(self,CHAN_WEAPON,"drake/vomitus/flesh1.wav",1,ATTN_NORM);
    else
        sound(self,CHAN_WEAPON,"drake/vomitus/flesh2.wav",1,ATTN_NORM);

	Vomit_Spawn();
	self.think = vom_end1;
};
void() vom_attack11 = [$attack11, vom_attack12 ] { ai_face(); Vomit_Meat(0.5); };
void() vom_attack12 = [$attack12, vom_attack13 ] { ai_face(); Vomit_Meat(0.5); };
void() vom_attack13 = [$attack13, vom_run1     ] { ai_face(); Vomit_Meat(0.5); };

void() vom_pain1  = [$pain1,  vom_pain2  ] {};
void() vom_pain2  = [$pain2,  vom_pain3  ] {};
void() vom_pain3  = [$pain3,  vom_pain4  ] {};
void() vom_pain4  = [$pain2,  vom_pain5  ] {};
void() vom_pain5  = [$pain1,  vom_run1   ] {};

void(entity inflictor, entity attacker, float damage) vom_pain = {
    if (self.pain_finished > time) return; // don't make multiple pain sounds right after each other

    self.pain_finished = time + 2;
    sound(self,CHAN_VOICE, "nehahra/vomit/groan.wav",1,ATTN_NORM);        

    if (SUB_IgnorePain ()) return; // No pain anims in Nightmare.

    vom_pain1();
};

// Death
void(float dm) vom_gib = {
	// PM:  Don't even think about calling T_RadiusDamage here!
	// This is because gib functions may be called by T_Damage,
	// which may be called within in T_RadiusDamage loop.
	sound(self,CHAN_VOICE, "blob/death1.wav",1,ATTN_NORM);
	if (self.skin) {
		// Meatwad
		Tent_Explosion2 (self.origin, 64, 16);  // Last could be an 8.
		ThrowGib(1,2);
		ThrowGib(2,2);
		ThrowGib(3,2);
		ThrowGib(25,1);
	} else {
		// Tar mother
		Tent_Point (TE_TAREXPLOSION, self.origin);
		ThrowGib(11,6);
	}
};

void() vom_die1  = [$death1,  vom_die2    ] {};
void() vom_die2  = [$death2,  vom_die3    ] {};
void() vom_die3  = [$death3,  vom_die4    ] { self.solid = SOLID_NOT; };
void() vom_die4  = [$death4,  vom_die5    ] { DropCoin(2); };
void() vom_die5  = [$death5,  vom_die6    ] {};
void() vom_die6  = [$death6,  vom_die7    ] { DropCoin(3); };
void() vom_die7  = [$death7,  vom_die8    ] {};
void() vom_die8  = [$death8,  vom_die9    ] { DropCoin(3); };
void() vom_die9  = [$death9,  vom_die10   ] {};
void() vom_die10 = [$death10, vom_die11   ] { DropCoin(3); };
void() vom_die11 = [$death11, vom_die12   ] {};
void() vom_die12 = [$death12, vom_die13   ] {};
void() vom_die13 = [$death13, vom_die14   ] { DropCoin(3); };
void() vom_die14 = [$death14, vom_die15   ] {};
void() vom_die15 = [$death15, vom_die16   ] {};
void() vom_die16 = [$death15, vom_die16 ] {
    self.health = self.gibhealth - 1;
    vom_gib(self.health);      // Pop into gibs.
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void() vom_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities.
    sound(self,CHAN_VOICE, "drake/vomitus/death.wav",1,ATTN_NORM);
    vom_die1();
};

void() monster_vomit_precache = {
    precache_model ("progs/drake/h_vomit.mdl");
    precache_model ("progs/ad181/h_zombie.mdl");
    precache_model ("progs/drake/tar_gib.mdl");
    precache_model ("progs/drake/vomitus.mdl");
    precache_model ("progs/zom_gib.mdl");
    precache_model ("progs/gib1.mdl");
    precache_model ("progs/gib2.mdl");
    precache_model ("progs/gib3.mdl");
	precache_model ("progs/qmaster/mon_tarbaby.mdl");
    precache_sound("zerstorer/cube/bc_attck.wav");
    precache_sound("zerstorer/cube/bc_gulp.wav");
    precache_sound("blob/death1.wav");
    precache_sound("fish/bite.wav");
    precache_sound("nehahra/vomit/groan.wav");
    precache_sound("drake/vomitus/death.wav");
    precache_sound("drake/vomitus/flesh1.wav");
    precache_sound("drake/vomitus/flesh2.wav");
    precache_sound("zombie/z_miss.wav");
    precache_sound("zombie/z_hit.wav");
    precache_sound("blob/death1.wav");
	precache_sound("blob/hit1.wav");
	precache_sound("blob/land1.wav");
	precache_sound("blob/sight1.wav");
	precache_sound("rogue/blob/mytosis.wav");
    precache_sound("zerstorer/gibfnt/gf_plop.wav");
    precache_sound("zerstorer/gibfnt/gf_sbig.wav");
    precache_sound("zerstorer/gibfnt/gf_sprt1.wav");
};

// QUAKED monster_vomit (1 0 0) (-32 -32 -24) (32 32 24) Ambush
// Bbox should be '-40 40 -24' to '40 40 24', but then it would need
// multiple bboxs.  Since Nehahra used standard shambler size, and
// the shambler is nearly as fat, use that size.
// Note to self:  Quoth's gug is even fatter, yet it uses shambler bbox.
void() monster_vomit = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.gib1mdl = "progs/drake/tar_gib.mdl";
	self.mdl = "progs/drake/vomitus.mdl";
	self.idle_sound = "zerstorer/gibfnt/gf_plop.wav";
	self.sight_sound = "zerstorer/gibfnt/gf_sbig.wav";
	self.pain_sound = "nehahra/vomit/groan.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_WIDEFLAT;
	if (self.health < 1) self.health = 400;  // Nehahra used 300 health, but Doom cacodemon has 400.   Note from Qmaster...OK, not sure how that's relevant lol
	self.gibhealth = MON_NEVERGIB;
	self.gibbed = FALSE;
	self.pain_flinch = 20;
	if (self.death_dmg < 1) self.death_dmg = DAMAGE_TARBABY; // Allow for extra functionality (death damage and poison)
    self.mass   = MASS_HEAVY;
    self.th_stand   = vom_stand1;
    self.th_walk    = vom_walk1;
    self.th_run     = vom_run1;
    self.th_missile = vom_attack1;
    self.th_pain    = vom_pain;
    self.th_die     = vom_die;
	if (self.deathstring == "") self.deathstring = " was vomited on by a Vomitus\n";
	if (!self.yaw_speed) self.yaw_speed = 15;    // Slower than normal.
	self.headmdl   = "progs/drake/h_vomit.mdl";

	if (self.minion_maxcount == 0) {
		if (skill == 1) self.minion_maxcount = 1;
		else self.minion_maxcount = 3;
	}

	if (self.minion_name == "") {
        self.minion_name = "monster_tarbaby";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }

	if (self.exactskin == 0) {
		self.headmdl   = "progs/drake/tar_gib.mdl";
		self.bloodtype  = BLOOD_PURPLE;
	} else {
		if (self.deathstring == "") self.deathstring = " was meatpummeled by a Vomitus Meatwad\n";
		self.minion_maxcount = 0;
	}

	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.classtype = CT_MONVOMITUS;
	self.classgroup = CG_SPAWN;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

void() monster_vomitus = { self.classname = "monster_vomit"; monster_vomit(); };

// Vomitus with meat skin.  Looks a bit like Meatwad.  Now where's Master Shake and Frylock?
void() monster_meatwad = {
    self.exactskin = self.skin = 1;
    self.classname = "monster_vomit";
    monster_vomit();
};
