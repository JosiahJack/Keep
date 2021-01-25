/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

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

//=============================================================================

//============================================================================
//  BANDIT / GOBLIN  (Soldier variant armed with a bow.)
//============================================================================

// ATTACK - - - - - - - - - - - - - - -
void() bandit_fire =
{
    local   vector  org, dir;
    local   float   artype;

    ai_face ();

    makevectors (self.angles);
    dir = (v_forward*9) + (v_right*6) + (v_up*16);
    org = self.origin + dir;
    dir = self.enemy.origin + dir;
//    if (ARROW_FLY)
        dir = Maim_Line (org, dir, AKARROW_SPEED_FLY, world, '0 0 0');
//    else
//        dir = Maim_Toss (org, dir, AKARROW_SPEED_TOSS, 200, world, '0 0 0');

    sound (self, CHAN_WEAPON, "drake/archer/arrowg.wav", 1, ATTN_NORM);
    // PM:  Assumes skin is 0 or 1.  If 2+, rewrite!
    if (self.ryuflags & RYU_REBEL)
        artype = 0;     // Rebel arrows are stronger.
    else
        artype = 4 + (self.skin & 1);
    AkArrow_Launch (org, dir, artype);
};

// SoE:  Check if shot is blocked.  Used by rebel to avoid friendly fire.
void() bandit_short = {
    if (self.ryuflags & RYU_REBEL) {
        local   vector  p1, p2;

        p1 = self.origin + self.view_ofs;
        p2 = self.enemy.origin + self.enemy.view_ofs;

        traceline (p1, p2, ARROW_FLY, self);
        if (trace_ent != self.enemy)
        if (trace_fraction < 1)
        if (trace_ent.flags & FLx_CREATURE)
        if (DontHurtMe (trace_ent)) {
            StopSound (self, CHAN_WEAPON);
            self.think = army_run1;
        }
    }
};

// SoE:  Shoot scene modified from shooting a gun to drawing a bow.
void() bandit_atk1  =[ $shoot1,   bandit_atk2    ] {ai_face();};
void() bandit_atk2  =[ $shoot2,   bandit_atk3    ] {ai_face(); sound (self, CHAN_WEAPON, "drake/archer/draw.wav", 1, ATTN_NORM);};
void() bandit_atk3  =[ $shoot3,   bandit_atk4    ] {ai_face();};
void() bandit_atk4  =[ $shoot4,   bandit_atk5    ] {ai_face();};
void() bandit_atk5  =[ $shoot5,   bandit_atk6    ] {ai_face();};
void() bandit_atk6  =[ $shoot5,   bandit_atk7    ] {ai_face();bandit_short();};
void() bandit_atk7  =[ $shoot6,   bandit_atk8    ] {ai_face();bandit_fire();};
void() bandit_atk8  =[ $shoot7,   army_run1      ] {ai_face();
    if (self.ryuflags & RYU_REBEL)
    {   // Rebels have their own refire check.
        if (self.enemy.health > 0)
        {
            if (random() < 0.4)
            {   // If shot cannot hit enemy, stop.
                local   vector  p1, p2;

                p1 = self.origin + self.view_ofs;
                p2 = self.enemy.origin + self.enemy.view_ofs;

                traceline (p1, p2, ARROW_FLY, self);
				
				// Refire.
                if (trace_ent == self.enemy) {   
                    if (self.attack_finished)
                        self.attack_finished = self.attack_finished + 0.5;
                    self.think = bandit_atk4;
                    return;
                }
            }
        }
    }
    else
        SUB_CheckRefire (bandit_atk3);
};
//void() bandit_atk8  =[ $shoot8,   bandit_atk9    ] {ai_face();};
//void() bandit_atk9  =[ $shoot9,   army_run1      ] {ai_face();};

// PAIN - - - - - - - - - - - - - - - -
void(entity inflictor, entity attacker, float damage) bandit_pain = {
    if (self.pain_finished > time)
        return;

    if (SUB_IgnorePain ()) {
        self.pain_finished = time + 0.6;
        if (self.classname == "monster_bandit")
            sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drake/goblin/pain1.wav", 1, ATTN_NORM);
        return;         // No pain anims in Nightmare.
    }

    local   float   r;
    local   float   p1, p2;
    
    r = random();
    if (self.ryuflags & RYU_REBEL)
        {p1 = 0.85; p2 = 0.925;}
    else
        {p1 = 0.2;  p2 = 0.6;}

    if ((r < p1) || (skill >= 3))
    {
        self.pain_finished = time + 0.6;
        army_pain1 ();
        if (self.classname == "monster_bandit")
            sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drake/goblin/pain1.wav", 1, ATTN_NORM);
    }
    else if (r < p2)
    {
        self.pain_finished = time + 1.1;
        army_painb1 ();
        if (self.classname == "monster_bandit")
            sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drake/goblin/pain1.wav", 1, ATTN_NORM);
    }
    else
    {
        self.pain_finished = time + 1.1;
        army_painc1 ();
        if (self.classname == "monster_bandit")
            sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drake/goblin/pain2.wav", 1, ATTN_NORM);
    }
    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

void() bandit_die = {
    // if (Shattered ())
        // return;
    // if (Decapitated ())
    // {
        // if (random() < 0.5)
            // monster_decap ('-8 0 24', army_decap1);
        // else
            // monster_decap ('-11 0 23', army_decapb1);
        // return;
    // }

	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	DropCoin(1);
	DropCoin(1); // 2 coins because they are annoying

	// regular death
	if (!self.gibbed) {
		// regular death
		if (self.classname == "monster_bandit") {
			sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
		} else {
			if (random() < 0.5) {
				sound (self, CHAN_VOICE, "drake/goblin/death1.wav", 1, ATTN_NORM);
			} else {
				sound (self, CHAN_VOICE, "drake/goblin/death2.wav", 1, ATTN_NORM);
			}
		}
		if (random() < 0.5) army_die1 ();		// Forward
		else army_cdie1 ();									// Backward/side
	}

};


// OTHER - - - - - - - - - - - - - - - -
void(float hello) bandit_sight =
{
    if (self.classname == "monster_bandit")
    {
        if (!hello)
            sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
        else if (!(self.ryuflags & RYU_REBEL))
            sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_NORM);
        return;
    }
    if (hello)
        sound (self, CHAN_VOICE, "drake/goblin/idle1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "drake/goblin/sight1.wav", 1, ATTN_NORM);
};


//============
// QUAKED monster_bandit (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_bandit = {    
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/drake/bandit.mdl";
	self.headmdl = "progs/drake/h_bandit.mdl";
    precache_model ("progs/drake/arrow.mdl");
    precache_model (self.mdl);
    precache_model (self.headmdl);
    precache_sound ("drake/archer/arrow1.wav");
    precache_sound ("drake/archer/arrow2.wav");
    precache_sound ("drake/archer/arrow3.wav");
    precache_sound ("drake/archer/arrowbrk.wav");
    precache_sound ("drake/archer/arrowg.wav");
    precache_sound ("drake/archer/draw.wav");
    precache_sound ("soldier/death1.wav");
    precache_sound ("soldier/idle.wav");
    precache_sound ("soldier/pain1.wav");
    precache_sound ("soldier/pain2.wav");
    precache_sound ("soldier/sight1.wav");
    precache_sound ("drake/goblin/death1.wav");
    precache_sound ("drake/goblin/death2.wav");
    precache_sound ("drake/goblin/idle1.wav");
    precache_sound ("drake/goblin/idle2.wav");
    precache_sound ("drake/goblin/pain1.wav");
    precache_sound ("drake/goblin/pain2.wav");
    precache_sound ("drake/goblin/sight1.wav");

	if (self.deathstring == "")  self.deathstring = " was shot by a Bandit\n";

	if (self.classname == "monster_goblin") {
		if (self.deathstring == "")  self.deathstring = " was shot by a Goblin\n";
		self.sight_sound = "drake/goblin/sight1.wav";
		self.idle_sound = "drake/goblin/idle1.wav";
		self.idle_sound2 = "drake/goblin/idle2.wav";
		self.pain_sound = "drake/goblin/pain1.wav";
		self.pain_sound2 = "drake/goblin/pain2.wav";
	} else {
		self.sight_sound = "soldier/sight1.wav";
		self.idle_sound = "soldier/idle.wav";
		self.pain_sound = "soldier/pain1.wav";
		self.pain_sound2 = "soldier/pain2.wav";
	}

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
    self.mass       = MASS_MEDIUM;

	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

    self.th_stand   = army_stand1;      // Same frames as base grunt.
    self.th_walk    = army_walk1;
    self.th_run     = army_run1;
    self.th_missile = bandit_atk1;
    self.th_pain    = bandit_pain;
    self.th_die     = bandit_die;
    //- - - - - - - -
    self.th_checkattack = SoldierCheckAttack;
    self.th_sight   = bandit_sight;
    //self.th_revive  = army_revive;
    self.th_spawn   = monster_bandit;

    self.height     = 2;
    self.ryuflags   = RYU_INSANE;
    //if (soul_evil)
    //    monster_guns (0, 0, 10, 0, 0);
    //monster_purse (2, 0.2, 0);      // Bandits may drop some coins.
	// SoE:  Modified stats for nsoe2 rebel fighters.

    // if (!self.skin && (self.spawnflags & SPAWN_WHITE) && !self.spawned)
    // {
        // if (self.health < 100)
            // {self.health = self.max_health = 100;}
        // self.ryuflags = RYU_ALERT | RYU_REBEL;
		// if (self.deathstring == "")  self.deathstring = " was shot by friendly fire\n";
    // }

	self.classtype = CT_MONBANDIT;
	if (self.classname == "monster_goblin") self.classtype = CT_MONRAKEGOBLIN;
	self.classgroup = CG_KNIGHT;
	self.classmove = MON_MOVEWALK;

    monster_start ();
};

void() monster_goblin = {self.skin = 1;  monster_bandit ();};