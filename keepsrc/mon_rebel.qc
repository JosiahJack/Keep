//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake by Patrick Martin
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
// Function count: 11
//
// Implements: Crossbow Rebel
//
// Description:
// Medieval Enforcer armed with a repeating crossbow.
//=============================================================================

$cd id1/models/enforcer
$origin 0 -6 24
$base base		
$skin skin
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14
$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11
$frame paina1 paina2 paina3 paina4
$frame painb1 painb2 painb3 painb4 painb5
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8
$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

void() rebel_fire = { // [FUNCTION]
    local   vector  org, dir;

    if (self.shots_left > 0) self.shots_left = self.shots_left - 1;
    makevectors (self.angles);
    dir = (v_forward*12) + (v_right*8.5) + (v_up*16);
    org = self.origin + dir;
    dir = self.enemy.origin + dir;
    dir = Maim_Line (org, dir, AKARROW_SPEED_FLY, self.enemy, '0 0 0');

    sound (self, CHAN_WEAPON, "drake/archer/arrowr.wav", 1, ATTN_NORM);
    AkArrow_Launch (org, dir, 0);
};

void() rebel_atk1  =[ $attack1,  rebel_atk2  ] {ai_face(); self.shots_left = 2;}; // [FUNCTION]
void() rebel_atk2  =[ $attack2,  rebel_atk3  ] {ai_face();}; // [FUNCTION]
void() rebel_atk3  =[ $attack3,  rebel_atk4  ] {ai_face();}; // [FUNCTION]
void() rebel_atk4  =[ $attack4,  rebel_atk6  ] {ai_face();}; // [FUNCTION]
void() rebel_atk6  =[ $attack6,  rebel_atk7  ] {rebel_fire();}; // [FUNCTION]
void() rebel_atk7  =[ $attack7,  rebel_atk8  ] {ai_face();}; // [FUNCTION]
void() rebel_atk8  =[ $attack8,  rebel_atk13 ] {ai_face();}; // [FUNCTION]
void() rebel_atk13 =[ $attack9,  rebel_atk14 ] {ai_face();}; // [FUNCTION]
void() rebel_atk14 =[ $attack10, enf_run1    ] {ai_face(); // [FUNCTION]
    if (self.shots_left > 0) self.think = rebel_atk6;
    else SUB_CheckRefire (rebel_atk1);
};

void() monster_rebel_precache = { // [FUNCTION]
    precache_model ("progs/drake/rebel.mdl");
	precache_model ("progs/drake/h_rebel.mdl");
    precache_model ("progs/drake/arrow.mdl");     // Replaced 'akarrow.mdl'.
    precache_model ("progs/gib1.mdl");
	precache_sound ("enforcer/idle1.wav");
	precache_sound ("enforcer/sight1.wav");
	precache_sound ("enforcer/sight2.wav");
	precache_sound ("enforcer/sight3.wav");
	precache_sound ("enforcer/sight4.wav");
	precache_sound ("enforcer/enfire.wav");
	precache_sound (SOUND_LASER_HIT);
	precache_sound ("enforcer/pain1.wav");
	precache_sound ("enforcer/pain2.wav");
	precache_sound ("enforcer/death1.wav");
    precache_sound ("drake/archer/arrow1.wav");
    precache_sound ("drake/archer/arrow2.wav");
    precache_sound ("drake/archer/arrow3.wav");
    precache_sound ("drake/archer/arrowbrk.wav");
    precache_sound ("drake/archer/arrowr.wav");
};

void() monster_rebel = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

    self.mdl = "progs/drake/rebel.mdl";
    self.headmdl   = "progs/drake/h_rebel.mdl";
	self.gib1mdl = "progs/gib1.mdl";
	self.idle_sound = "enforcer/idle1.wav";
	self.sight_sound = "enforcer/sight1.wav";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
    if (self.health < 1) self.health = 200;
    self.gibhealth = -40;
	self.ryuflags = RYU_ALERT | RYU_REBEL;   
    self.gibbed = FALSE;
    self.pain_flinch = 20;
    self.pain_longanim = TRUE;
    self.steptype = FS_TYPEMEDIUM;
    self.mass       = MASS_MEDIUM;
	self.attack_offset = '28 8.5 16';	// End of Gun
    self.th_stand = enf_stand1;
    self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
    self.th_missile = rebel_atk1;
    self.th_checkattack = SoldierCheckAttack;   // For Rebel AI.
	self.gib1skin = 0;
	if (self.deathstring == "")  self.deathstring = " was skewered by a Crossbow Rebel\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
    self.classtype = CT_MONREBEL;
	self.classgroup = CG_KNIGHT;
	self.classmove = MON_MOVEWALK;
	monster_start();
};