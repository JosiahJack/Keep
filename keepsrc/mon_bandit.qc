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
// Entity count: 2
// Function count: 16
//
// Implements: Bandit and Goblin
//
// Description:
// Medieval soldier variant armed with a bow.
//=============================================================================

$cd id1/models/soldier3
$origin 0 -6 24
$base base        
$skin skin
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10
$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11
$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9
$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

// Extended scenes - - - - - - - - - - -
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9
$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6 decapb7 decapb8
$frame decapb9 decapb10 decapb11
$frame runb1 runb2 runb3 runb4 runb5 runb6
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame standb1 standb2 standb3 standb4 standb5 standb6

void() bandit_fire = { // [FUNCTION]
    local vector org, dir;
    local float artype;

    ai_face();
    makevectors(self.angles);
    dir = (v_forward*9) + (v_right*6) + (v_up*16);
    org = self.origin + dir;
    dir = self.enemy.origin + dir;
    dir = Maim_LineEx(org,dir,AKARROW_SPEED_FLY,world,'0 0 0',1);
    sound(self,CHAN_WEAPON,"drake/archer/arrowg.wav",1,ATTN_NORM);
    // PM:  Assumes skin is 0 or 1.  If 2+, rewrite!
    if (self.ryuflags & RYU_REBEL)
        artype = 0;     // Rebel arrows are stronger.
    else
        artype = 4 + (self.skin & 1);
    AkArrow_Launch (org, dir, artype);
};

// SoE:  Check if shot is blocked.  Used by rebel to avoid friendly fire.
void() bandit_short = { // [FUNCTION]
    local vector p1, p2;

    if (self.ryuflags & RYU_REBEL) {
        p1 = self.origin + self.view_ofs;
        p2 = self.enemy.origin + self.enemy.view_ofs;
        traceline (p1, p2, 2, self);
        if (trace_ent != self.enemy) {
			if ((trace_fraction < 1) && (trace_ent.flags & FLx_CREATURE) && (self.enemy.solid <= SOLID_TRIGGER || Align_Match(self,trace_ent) || trace_ent.enemy == self || trace_ent == self.oldenemy)) {
				StopSound(self,CHAN_WEAPON);
				self.think = army_run1;
			}
		}
    }
};

// SoE:  Shoot scene modified from shooting a gun to drawing a bow.
void() bandit_atk1  = [$shoot1,   bandit_atk2    ] { ai_face(); };
void() bandit_atk2  = [$shoot2,   bandit_atk3    ] { ai_face(); sound(self,CHAN_WEAPON,"drake/archer/draw.wav",1,ATTN_NORM); };
void() bandit_atk3  = [$shoot3,   bandit_atk4    ] { ai_face(); };
void() bandit_atk4  = [$shoot4,   bandit_atk5    ] { ai_face(); };
void() bandit_atk5  = [$shoot5,   bandit_atk6    ] { ai_face(); };
void() bandit_atk6  = [$shoot5,   bandit_atk7    ] { ai_face();bandit_short(); };
void() bandit_atk7  = [$shoot6,   bandit_atk8    ] { ai_face();bandit_fire(); };
void() bandit_atk8  = [$shoot7,   army_run1      ] {
	local vector p1, p2;

	ai_face();
    if (self.ryuflags & RYU_REBEL) { // Rebels have their own refire check.
        if (self.enemy.health > 0) {
            if (random() < 0.4) { // If shot cannot hit enemy, stop.
                p1 = self.origin + self.view_ofs;
                p2 = self.enemy.origin + self.enemy.view_ofs;
                traceline (p1, p2, 2, self);
				
				// Refire.
                if (trace_ent == self.enemy) {   
                    if (self.attack_finished) self.attack_finished = self.attack_finished + 0.5;
                    self.think = bandit_atk4;
                    return;
                }
            }
        }
    } else SUB_CheckRefire (bandit_atk3);
};
//void() bandit_atk8  = [$shoot8,   bandit_atk9    ] { ai_face(); };
//void() bandit_atk9  = [$shoot9,   army_run1      ] { ai_face(); };

// PAIN - - - - - - - - - - - - - - - -
void(entity inflictor, entity attacker, float damage) bandit_pain = {
    if (self.pain_finished > time)
        return;

    if (SUB_IgnorePain ()) {
        self.pain_finished = time + 0.6;
        if (self.classtype == CT_MONBANDIT)
            sound(self,CHAN_VOICE, "soldier/pain1.wav",1,ATTN_NORM);
        else
            sound(self,CHAN_VOICE, "drake/goblin/pain1.wav",1,ATTN_NORM);
        return;         // No pain anims in Nightmare.
    }

    local   float   r;
    local   float   p1, p2;
    
    r = random();
    if (self.ryuflags & RYU_REBEL)
        { p1 = 0.85; p2 = 0.925; }
    else
        { p1 = 0.2;  p2 = 0.6; }

    if ((r < p1) && !SUB_IgnorePain()) {
        self.pain_finished = time + 0.6;
        army_pain1();
        if (self.classtype == CT_MONBANDIT)
            sound(self,CHAN_VOICE, "soldier/pain1.wav",1,ATTN_NORM);
        else
            sound(self,CHAN_VOICE, "drake/goblin/pain1.wav",1,ATTN_NORM);
    } else if (r < p2) {
        self.pain_finished = time + 1.1;
        army_painb1();
        if (self.classtype == CT_MONBANDIT)
            sound(self,CHAN_VOICE, "soldier/pain2.wav",1,ATTN_NORM);
        else
            sound(self,CHAN_VOICE, "drake/goblin/pain1.wav",1,ATTN_NORM);
    } else {
        self.pain_finished = time + 1.1;
        army_painc1();
        if (self.classtype == CT_MONBANDIT)
            sound(self,CHAN_VOICE, "soldier/pain2.wav",1,ATTN_NORM);
        else
            sound(self,CHAN_VOICE, "drake/goblin/pain2.wav",1,ATTN_NORM);
    }
    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

void() bandit_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	DropCoin(1);
	DropCoin(1); // 2 coins because they are annoying

	// regular death
	if (!self.gibbed) {
        monster_deathsound();
		if (random() < 0.5) army_die1(); // Forward
		else army_cdie1();				 // Backward/side
	}
};

void() monster_bandit_precache = {
    precache_model ("progs/drake/arrow.mdl");
    precache_model ("progs/drake/bandit.mdl");
    precache_model ("progs/drake/h_bandit.mdl");
    precache_sound("drake/archer/arrow1.wav");
    precache_sound("drake/archer/arrow2.wav");
    precache_sound("drake/archer/arrow3.wav");
    precache_sound("drake/archer/arrowbrk.wav");
    precache_sound("drake/archer/arrowg.wav");
    precache_sound("drake/archer/draw.wav");
    precache_sound("soldier/death1.wav");
    precache_sound("soldier/idle.wav");
    precache_sound("soldier/pain1.wav");
    precache_sound("soldier/pain2.wav");
    precache_sound("soldier/sight1.wav");
    precache_sound("drake/goblin/death1.wav");
    precache_sound("drake/goblin/death2.wav");
    precache_sound("drake/goblin/idle1.wav");
    precache_sound("drake/goblin/idle2.wav");
    precache_sound("drake/goblin/pain1.wav");
    precache_sound("drake/goblin/pain2.wav");
    precache_sound("drake/goblin/sight1.wav");
    precache_sound("drake/goblin/sight2.wav");
    precache_sound("drake/goblin/sight3.wav");
};

// QUAKED monster_bandit (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_bandit = {
    if (world.model == "maps/mj4m1.bsp") {
        self.classname = "monster_goblin"; self.skin = self.exactskin = 1;
    }

	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/drake/bandit.mdl";
	self.headmdl = "progs/drake/h_bandit.mdl";
	if (self.deathstring == "")  self.deathstring = " was shot by a Bandit\n";
	if (self.classname == "monster_goblin") {
		self.classtype = CT_MONDRAKEGOBLIN;
		if (self.deathstring == "")  self.deathstring = " was shot by a Goblin\n";
		self.idle_sound = "drake/goblin/idle1.wav";
		self.idle_sound2 = "drake/goblin/idle2.wav";
		self.pain_sound = "drake/goblin/pain1.wav";
		self.pain_sound2 = "drake/goblin/pain2.wav";
		self.hello_sound = "drake/goblin/idle1.wav";
		self.sight_sound = "drake/goblin/sight1.wav";
		self.sight_sound2 = "drake/goblin/sight2.wav";
		self.sight_sound3 = "drake/goblin/sight3.wav";
		self.sight_sound4 = "drake/goblin/sight4.wav";
		self.death_sound = "drake/goblin/death1.wav";
		self.death_sound2 = "drake/goblin/death2.wav";
	} else {
		self.classtype = CT_MONBANDIT;
		self.idle_sound = "soldier/idle.wav";
		self.pain_sound = "soldier/pain1.wav";
		self.pain_sound2 = "soldier/pain2.wav";
		self.hello_sound = "soldier/idle.wav";
		self.sight_sound = "soldier/sight1.wav";
		self.death_sound = "soldier/death1.wav";
	}

	self.ammo_nails = rint(random()*3);
    self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	if (self.health < 1) self.health = 30;
	self.gibhealth = -35;				// Easy to gib
	self.gibbed = FALSE;				// Still together
	self.pain_flinch = 20;				// Easy to pain
	self.pain_longanim = TRUE;			// can be chopped with shadow axe
	self.steptype = FS_TYPEMEDIUM;		// Average feet
	self.attack_offset = '12 8 12';		// End of Gun
    self.mass = MASS_MEDIUM;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to 0 to be consistent.
    self.th_stand   = army_stand1;      // Same frames as base grunt.
    self.th_walk    = army_walk1;
    self.th_run     = army_run1;
    self.th_missile = bandit_atk1;
    self.th_pain    = bandit_pain;
    self.th_die     = bandit_die;
    self.th_checkattack = SoldierCheckAttack;
    self.height     = 2;
    self.ryuflags   = RYU_INSANE;

	// SoE:  Modified stats for nsoe2 rebel fighters.
    if (!self.skin && self.alignment > EVIL && !self.spawned) { // HACK!
        if (self.health < 100) { self.health = self.max_health = 100; }
        self.ryuflags = RYU_ALERT | RYU_REBEL;
		if (self.deathstring == "") {
            if (random() < 0.5) self.deathstring = " was hoodwinked by a Bandit\n";
			self.deathstring = " was shot by a Bandit\n";
			if (self.skin == 1) self.deathstring = " was shot by a Goblin\n";
		}
    }

	self.classgroup = CG_KNIGHT;
	self.classmove = MON_MOVEWALK;
    monster_start();
};

void() monster_goblin = { self.skin = self.exactskin = 1;  monster_bandit(); };