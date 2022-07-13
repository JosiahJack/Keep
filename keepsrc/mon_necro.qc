// NECROMANCER (From Drake mod.  Used for Acolyte, Sorcerer, Warlock, and the boss Necromancer)
$cd progs/drake/necro
$origin 0 0 24
$base base        
$skin skin
$frame deathA1 deathA2 deathA3 deathA4 deathA5 deathA6 deathA7 deathA8
$frame deathA9 deathA10 deathA11 deathA12 deathA13 deathA14 deathA15
$frame deathA16 deathA17 deathA18 deathA19 deathA20
$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9 decap10
$frame decap11 decap12 decap13 decap14 decap15 decap16 decap17 decap18
$frame decap19 decap20
$frame Hatak1 Hatak2 Hatak3 Hatak4 Hatak5 Hatak6 Hatak7 Hatak8
$frame Hpain1 Hpain2 Hpain3 Hpain4 Hpain5 Hpain6 Hpain7 Hpain8
$frame Hrun1 Hrun2 Hrun3 Hrun4 Hrun5 Hrun6 Hrun7 Hrun8 Hrun9 Hrun10
$frame Hrun11 Hrun12
$frame Hwait1 Hwait2 Hwait3 Hwait4 Hwait5 Hwait6 Hwait7 Hwait8 Hwait9 Hwait10
$frame Hwait11 Hwait12
$frame Siatak1 Siatak2 Siatak3 Siatak4 Siatak5 Siatak6 Siatak7 Siatak8
$frame Siatak9 Siatak10 Siatak11 Siatak12
$frame Sipain1 Sipain2 Sipain3 Sipain4 Sipain5 Sipain6 Sipain7 Sipain8
$frame Sirun1 Sirun2 Sirun3 Sirun4 Sirun5 Sirun6 Sirun7 Sirun8 Sirun9 Sirun10
$frame Sirun11 Sirun12
$frame Siwait1 Siwait2 Siwait3 Siwait4 Siwait5 Siwait6 Siwait7 Siwait8
$frame Siwait9 Siwait10 Siwait11 Siwait12
$frame Statak1 Statak2 Statak3 Statak4 Statak5 Statak6 Statak7 Statak8
$frame Stpain1 Stpain2 Stpain3 Stpain4 Stpain5 Stpain6 Stpain7 Stpain8
$frame Strun1 Strun2 Strun3 Strun4 Strun5 Strun6 Strun7 Strun8 Strun9 Strun10
$frame Strun11 Strun12
$frame Stwait1 Stwait2 Stwait3 Stwait4 Stwait5 Stwait6 Stwait7 Stwait8
$frame Stwait9 Stwait10 Stwait11 Stwait12

float   NECRO_ACOLYTE   = 1;  // Used by self.height.
float   NECRO_SORCERER  = 2;
float   NECRO_WARLOCK   = 3;
float   NSA_CURSE               = 1;  // Used by self.worldtype.  NSA = Necro Special Attack.
float   NSA_CORPSE_EXPLOSION    = 2;
float   NSA_SUMMON_GOLEM        = 3;
float   NSA_SUMMON_IMPS         = 4;
float   NECRO_MAX_IMPS      = 5;    // Maximum imps.

// Alternate thinking for necrobolts.  Used by necromancer boss.
void() NecroBolt_Summon = {
    if (self.delay <= time) {
		if (self.master.flags & FLx_CREATURE)
		if (self.enemy) {
			if (visible (self.enemy)) {
				if (query_minionactive(self) == TRUE && self.minion_count < self.minion_maxcount) {
					makevectors(self.angles);
					self.pos1 = self.origin + self.view_ofs + v_forward*64 + v_up*32;
                    if (SpawnMinionInRadius(self.pos1)) self.pos2 = self.pos1 - '0 0 16';	// Origin of gargoyle
				}
			}
		}
	}
    NecroBolt_Think();
};

void() acolyte_fire = {
    local vector org, dir;

    makevectors(self.angles);
    org = self.origin + v_forward*14 - v_right*8 + v_up*12;     // '14 -2 19'
    dir = normalize (self.enemy.origin - self.origin);
    NecroSnake_Launch (org, dir, 600);
};

// 'hits' is number of bounces the shot begins with.  Used to change the
// number of bounces allowed before exploding.  With no bounces (hits = 0),
// the fireball may bounce up to the nemesant standard of three times without
// exploding.  What 'hits' does is change the bounces to 3 - hits.
void(float hits) sorcerer_fire =
    { M_FireSmart ('8 -5 12');  newmis.count = hits; };

void(vector st) warlock_fire = {
    local   vector  org, dir, vec;
    local   entity  targ;       // Lead shots toward this target.

    sound(self,CHAN_WEAPON,"drake/necro/att_w.wav",1,ATTN_NORM);
    self.effects = self.effects | EF_MUZZLEFLASH;

    targ = world;

    makevectors(self.angles);
    // old st was '12 7 26'.
    org = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;

    vec = Midpoint (self.enemy);
    vec_z = self.enemy.absmin_z + self.enemy.size_z*0.7;

    if (skill >= 2)     // In Hard/NM, aim at the enemy's feet occasionally.
    {
        if (org_z > self.enemy.absmin_z)
            if (random() < 0.2)
                if (vlen(vec - org) < 450)
                    vec_z = self.enemy.absmin_z;    // Aim for the feet.
		// DISABLED -- Warlock is dangerous enough without leading.
		//        if (random() < 0.1)
		//            targ = self.enemy;
    }
    MakeFancy (org, X32_STAR_RED, 2);
    dir = Maim_LineEx(org,vec,600,targ,'0 0 0',1);
    NecroBolt_Launch(org,dir);
// Update:  Secondary bolts from necro boss can spawn monsters.
    if (self.classtype == CT_MONNECRO)
        if (self.frame == $Hatak8 )
            newmis.think = NecroBolt_Summon;
};


//=============================================================================

// STAND - - - - - - - - - - - - - - - -
void() necro_idlesound = {
// PM:  Replaced fwiz code with nemesants'.  This is due to replaced sounds.
    if (self.waitmin < time)
    {
        local   float   wr;

    // Use voice channel instead of auto -- don't want slain magi talking.
        wr = random();
        if (wr > 0.7) 
            sound(self,CHAN_VOICE, "drake/necro/idle1.wav",1,ATTN_NORM);
        else if (wr < 0.3)
            sound(self,CHAN_VOICE, "drake/necro/idle2.wav",1,ATTN_NORM);
        self.waitmin = time + 10;
    }
};

// CoE Acolyte
void() necro1_stand1  = [$Siwait1,  necro1_stand2  ] { necro_idlesound(); ai_stand(); };
void() necro1_stand2  = [$Siwait2,  necro1_stand3  ] { ai_stand(); };
void() necro1_stand3  = [$Siwait3,  necro1_stand4  ] { ai_stand(); };
void() necro1_stand4  = [$Siwait4,  necro1_stand5  ] { ai_stand(); };
void() necro1_stand5  = [$Siwait5,  necro1_stand6  ] { ai_stand(); };
void() necro1_stand6  = [$Siwait6,  necro1_stand7  ] { ai_stand(); };
void() necro1_stand7  = [$Siwait7,  necro1_stand8  ] { ai_stand(); };
void() necro1_stand8  = [$Siwait8,  necro1_stand9  ] { ai_stand(); };
void() necro1_stand9  = [$Siwait9,  necro1_stand10 ] { ai_stand(); };
void() necro1_stand10 = [$Siwait10, necro1_stand11 ] { ai_stand(); };
void() necro1_stand11 = [$Siwait11, necro1_stand12 ] { ai_stand(); };
void() necro1_stand12 = [$Siwait12, necro1_stand1  ] { ai_stand(); };

// CoE Sorcerer
void() necro2_stand1  = [$Stwait1,  necro2_stand2  ] { necro_idlesound(); ai_stand(); };
void() necro2_stand2  = [$Stwait2,  necro2_stand3  ] { ai_stand(); };
void() necro2_stand3  = [$Stwait3,  necro2_stand4  ] { ai_stand(); };
void() necro2_stand4  = [$Stwait4,  necro2_stand5  ] { ai_stand(); };
void() necro2_stand5  = [$Stwait5,  necro2_stand6  ] { ai_stand(); };
void() necro2_stand6  = [$Stwait6,  necro2_stand7  ] { ai_stand(); };
void() necro2_stand7  = [$Stwait7,  necro2_stand8  ] { ai_stand(); };
void() necro2_stand8  = [$Stwait8,  necro2_stand9  ] { ai_stand(); };
void() necro2_stand9  = [$Stwait9,  necro2_stand10 ] { ai_stand(); };
void() necro2_stand10 = [$Stwait10, necro2_stand11 ] { ai_stand(); };
void() necro2_stand11 = [$Stwait11, necro2_stand12 ] { ai_stand(); };
void() necro2_stand12 = [$Stwait12, necro2_stand1  ] { ai_stand(); };

// CoE Warlock
void() necro3_stand1  = [$Hwait1,  necro3_stand2  ] { necro_idlesound(); ai_stand(); };
void() necro3_stand2  = [$Hwait2,  necro3_stand3  ] { ai_stand(); };
void() necro3_stand3  = [$Hwait3,  necro3_stand4  ] { ai_stand(); };
void() necro3_stand4  = [$Hwait4,  necro3_stand5  ] { ai_stand(); };
void() necro3_stand5  = [$Hwait5,  necro3_stand6  ] { ai_stand(); };
void() necro3_stand6  = [$Hwait6,  necro3_stand7  ] { ai_stand(); };
void() necro3_stand7  = [$Hwait7,  necro3_stand8  ] { ai_stand(); };
void() necro3_stand8  = [$Hwait8,  necro3_stand9  ] { ai_stand(); };
void() necro3_stand9  = [$Hwait9,  necro3_stand10 ] { ai_stand(); };
void() necro3_stand10 = [$Hwait10, necro3_stand11 ] { ai_stand(); };
void() necro3_stand11 = [$Hwait11, necro3_stand12 ] { ai_stand(); };
void() necro3_stand12 = [$Hwait12, necro3_stand1  ] { ai_stand(); };

void() necro1_walk1  = [$Sirun1,  necro1_walk2  ] { necro_idlesound(); monster_footstep(FALSE); ai_walk(8); };
void() necro1_walk2  = [$Sirun2,  necro1_walk3  ] { ai_walk(8); };
void() necro1_walk3  = [$Sirun3,  necro1_walk4  ] { ai_walk(8); };
void() necro1_walk4  = [$Sirun4,  necro1_walk5  ] { ai_walk(8); };
void() necro1_walk5  = [$Sirun5,  necro1_walk6  ] { ai_walk(8); };
void() necro1_walk6  = [$Sirun6,  necro1_walk7  ] { ai_walk(8); };
void() necro1_walk7  = [$Sirun7,  necro1_walk8  ] { monster_footstep(FALSE); ai_walk(8); };
void() necro1_walk8  = [$Sirun8,  necro1_walk9  ] { ai_walk(8); };
void() necro1_walk9  = [$Sirun9,  necro1_walk10 ] { ai_walk(8); };
void() necro1_walk10 = [$Sirun10, necro1_walk11 ] { ai_walk(8); };
void() necro1_walk11 = [$Sirun11, necro1_walk12 ] { ai_walk(8); };
void() necro1_walk12 = [$Sirun12, necro1_walk1  ] { ai_walk(8); };

void() necro2_walk1  = [$Strun1,  necro2_walk2  ] { necro_idlesound(); monster_footstep(FALSE); ai_walk(8); };
void() necro2_walk2  = [$Strun2,  necro2_walk3  ] { ai_walk(8); };
void() necro2_walk3  = [$Strun3,  necro2_walk4  ] { ai_walk(8); };
void() necro2_walk4  = [$Strun4,  necro2_walk5  ] { ai_walk(8); };
void() necro2_walk5  = [$Strun5,  necro2_walk6  ] { ai_walk(8); };
void() necro2_walk6  = [$Strun6,  necro2_walk7  ] { ai_walk(8); };
void() necro2_walk7  = [$Strun7,  necro2_walk8  ] { monster_footstep(FALSE); ai_walk(8); };
void() necro2_walk8  = [$Strun8,  necro2_walk9  ] { ai_walk(8); };
void() necro2_walk9  = [$Strun9,  necro2_walk10 ] { ai_walk(8); };
void() necro2_walk10 = [$Strun10, necro2_walk11 ] { ai_walk(8); };
void() necro2_walk11 = [$Strun11, necro2_walk12 ] { ai_walk(8); };
void() necro2_walk12 = [$Strun12, necro2_walk1  ] { ai_walk(8); };

void() necro3_walk1  = [$Hrun1,  necro3_walk2  ] { necro_idlesound(); monster_footstep(FALSE); ai_walk(8); };
void() necro3_walk2  = [$Hrun2,  necro3_walk3  ] { ai_walk(8); };
void() necro3_walk3  = [$Hrun3,  necro3_walk4  ] { ai_walk(8); };
void() necro3_walk4  = [$Hrun4,  necro3_walk5  ] { ai_walk(8); };
void() necro3_walk5  = [$Hrun5,  necro3_walk6  ] { ai_walk(8); };
void() necro3_walk6  = [$Hrun6,  necro3_walk7  ] { ai_walk(8); };
void() necro3_walk7  = [$Hrun7,  necro3_walk8  ] { monster_footstep(FALSE); ai_walk(8); };
void() necro3_walk8  = [$Hrun8,  necro3_walk9  ] { ai_walk(8); };
void() necro3_walk9  = [$Hrun9,  necro3_walk10 ] { ai_walk(8); };
void() necro3_walk10 = [$Hrun10, necro3_walk11 ] { ai_walk(8); };
void() necro3_walk11 = [$Hrun11, necro3_walk12 ] { ai_walk(8); };
void() necro3_walk12 = [$Hrun12, necro3_walk1  ] { ai_walk(8); };

// Casting scenes are used when necro uses special abilities such as
// teleportation, shielding, or summoning.
void() necro_face = {
    if (self.worldtype) {
		// Attempting a special atttack.
        if (self.fallen)
            ai_ritual();
        else if (!self.enemy)
            return;
    }
    ai_face();
};

void() necro_activate_special;

void() necro1_cast1  = [$Siatak1,  necro1_cast2  ] { ai_face(); };
void() necro1_cast2  = [$Siatak5,  necro1_cast3  ] { ai_face(); };
void() necro1_cast3  = [$Siatak6,  necro1_cast4  ] { ai_face(); self.nextthink = time + 0.2; };
void() necro1_cast4  = [$Siatak11, necro1_cast5  ] { ai_face(); necro_activate_special(); };
void() necro1_cast5  = [$Siatak12, necro1_run1   ] { ai_face(); };

void() necro2_cast1  = [$Statak1,  necro2_cast2  ] { ai_face(); };
void() necro2_cast2  = [$Statak2,  necro2_cast3  ] { ai_face(); };
void() necro2_cast3  = [$Statak5,  necro2_cast4  ] { ai_face(); };
void() necro2_cast4  = [$Statak6,  necro2_cast5  ] { ai_face(); };
void() necro2_cast5  = [$Statak7,  necro2_cast6  ] { ai_face(); necro_activate_special(); };
void() necro2_cast6  = [$Statak8,  necro2_run1   ] { ai_face(); };

void() necro3_cast1  = [$Hatak1,   necro3_cast2  ] { ai_face(); };
void() necro3_cast2  = [$Hatak2,   necro3_cast3  ] { ai_face(); };
void() necro3_cast3  = [$Hatak7,   necro3_cast4  ] { ai_face(); };
void() necro3_cast4  = [$Hatak8,   necro3_run1   ] { ai_face(); necro_activate_special(); };

void() necro_cast = {
    if (self.height == NECRO_ACOLYTE)
        necro1_cast1();
    else if (self.height == NECRO_SORCERER)
        necro2_cast1();
    else //if (self.height == NECRO_WARLOCK)
        necro3_cast1();
};

float   RANGE_NECROSHIELD   = 150;
float   DELAY_NECROSHIFT    = 1.5;  // Can't teleport to dodge missiles.

float(vector org) necro_clear = {
    local   entity  head;

    head = findradius(org, 120);
    while (head) {
        if (head.flags & FLx_CREATURE)
            if (head != self) {
                if (head.charmed) return FALSE;
			}
        head = head.chain;
    }
    return TRUE;
};

// 'drop':  0 = No bomb, 1 = drop bomb, 2 = teleport only when attacking.
float(entity targ, vector spot, float drop) necro_teleport = {
    local   vector  org;
    local   float   bomb;

	// Check if the necro can drop a bomb near an enemy.
    bomb = FALSE;
    if (drop) {
        if (self.enemy)
            if (InMeleeRange (120))
                if (CanDamage (self.enemy, self))
                    bomb = TRUE;
        if (drop == 2)
            if (!bomb)
                return FALSE;
    }

	// Do teleportation routine.
    org = self.origin;
    if (EntryPoint_Spawn (self, targ, spot, EntryPoint_Random)) {
        // Necro successfully teleported away.
        self.waitmax = time + DELAY_NECROSHIFT;
        if (bomb) {
			// Make sure necro and friends are a safe distance away before
            // dropping a explosive rune as a time bomb.
            if (vlen(org - self.origin) > 120)
                if (necro_clear (org))
                    NecroBomb (org);
        }
        spawn_tfog (org);
        spawn_tfog (self.origin);
        self.fallen = world;
        self.worldtype = 0;
        necro_cast();
    }
    return FALSE;
};

// Called when teleporting away from an attack.
float() necro_teledef = {
    if (self.waitmax <= time)   // Don't spam teleport as a defense.
        return  necro_teleport (self.enemy, self.origin, FALSE);
    return FALSE;
};

// Look for enemy missiles infront of the necro.  We don't care which
// missile is found, just whether or not any are found, so return T or F.
float() necro_find = {
    if (self.enemy)
    {
        local   entity  head;

        head = findradius (self.origin, RANGE_NECROSHIELD);
        while (head)
        {   // If missile came from enemy, or targets the necro, take it
            // if the missile is infront of the necro.
            if (IsMissile (head))
                if ((head.master == self.enemy) || (head.enemy == self))
                    if (visible (head))
                        if (infront (head))
                            return TRUE;
            head = head.chain;
        }
    }
    return FALSE;
};

// Searches for missiles to defend against.  If none are found, then move.
// Called by sorcerer and warlock.  Update:  Called by acolyte code now
// because necro boss starts in acolyte mode.
void() necro_run = {
    if (!self.mirror_finished)
        self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);

	// Sorcerer and warlock modes have special defenses.
    if (self.height >= NECRO_SORCERER) {
		if (necro_find ()) {
			if (self.height == NECRO_SORCERER) {
				// Sorcerer -- Teleport to random nearby point.
				if (necro_teledef ())
					return;
				// Made it here?  Teleportation failed, so just move.
			} else if (self.height == NECRO_WARLOCK) {
				// Warlock -- Raise shields if practical to do so.
				// Do NOT raise shields if the following apply:
				// 1) Enemy is too close.
				// 2) Necro is in a deadly environment (e.g., in lava).
				if (vlen(self.enemy.origin - self.origin) > (RANGE_NECROSHIELD + self.enemy.maxs_x)) {
					if (self.liquidbase >= CONTENT_WATER) {
						if ((self.liquidbase != CONTENT_WATER) || (self.waterlevel < 3)) {
							self.fallen = world;
							self.worldtype = 0;
							shieldon();
							necro3_cast1();
							return;
						}
					}
				}

				// Necro boss may teleport instead if shield cannot be raised.
				if (self.classtype == CT_MONNECRO)
					if (necro_teledef ()) return;

				shieldoff();
			}
			shieldoff();
			// At this point, no special defense was activated.
		}
		shieldoff();
	}
	// No defense activated, so move.
    local   float   d;

    d = 16;
    if (self.classtype == CT_MONNECRO) {
        // Boss may teleport to enemy.
        if (self.search_time + 5 < time) {
            local   entity  targ;

            targ = world;
            if (self.enemy)
                targ = self.enemy;
            else
                targ = self.charmer;

            if (targ)
            if (!visible (targ))
            if (necro_teleport (targ, targ.origin, TRUE)) {
                self.search_time = time;//+ 5; // Teleport to the enemy.
                return;
            }
        }
    }
    ai_run(d); // Move.  All running frames use the same speed.
};

// Update:  Acolytes use necro_run() instead of ai_run(16) since the necro boss uses all three necro modes.
void() necro1_run1  = [$Sirun1,  necro1_run2  ] { necro_idlesound(); monster_footstep(FALSE); necro_run(); };
void() necro1_run2  = [$Sirun3,  necro1_run3  ] { necro_run(); };
void() necro1_run3  = [$Sirun5,  necro1_run4  ] { necro_run(); };
void() necro1_run4  = [$Sirun7,  necro1_run5  ] { monster_footstep(FALSE); necro_run(); };
void() necro1_run5  = [$Sirun9,  necro1_run6  ] { necro_run(); };
void() necro1_run6  = [$Sirun11, necro1_run1  ] { necro_run(); };

void() necro2_run1  = [$Strun1,  necro2_run2  ] { necro_idlesound(); monster_footstep(FALSE); necro_run(); };
void() necro2_run2  = [$Strun3,  necro2_run3  ] { necro_run(); };
void() necro2_run3  = [$Strun5,  necro2_run4  ] { necro_run(); };
void() necro2_run4  = [$Strun7,  necro2_run5  ] { monster_footstep(FALSE); necro_run(); };
void() necro2_run5  = [$Strun9,  necro2_run6  ] { necro_run(); };
void() necro2_run6  = [$Strun11, necro2_run1  ] { necro_run(); };

void() necro3_run1  = [$Hrun1,  necro3_run2  ] { necro_idlesound(); monster_footstep(FALSE); necro_run(); };
void() necro3_run2  = [$Hrun3,  necro3_run3  ] { necro_run(); };
void() necro3_run3  = [$Hrun5,  necro3_run4  ] { necro_run(); };
void() necro3_run4  = [$Hrun7,  necro3_run5  ] { monster_footstep(FALSE); necro_run(); };
void() necro3_run5  = [$Hrun9,  necro3_run6  ] { necro_run(); };
void() necro3_run6  = [$Hrun11, necro3_run1  ] { necro_run(); };

// ATTACK - - - - - - - - - - - - - - -
void() ai_repel;    // In 'nemesant.qc'.

float() necro_encore = {
    if (self.classtype == CT_MONNECRO) return TRUE;
    if (SUB_IgnorePain()) return TRUE;
    if (skill >= 2 && random() < 0.25) return TRUE;
    return FALSE;
};

void() necro_run_check = { 
	// PM:  Hack for non-specials.
    if (self.height == NECRO_SORCERER)
        self.think = necro2_run1;
    else if (self.height == NECRO_WARLOCK)
        self.think = necro3_run1;
};

// PM:  Sped up acolyte's swings due to frame rate differences between
// Quake and Hexen2.
void() necro1_melee1 = [$Siatak2,  necro1_melee2 ] { ai_charge(3);
    if (self.classtype == CT_MONNECRO)
        self.cnt = 2;   // Extra swings.
    else
        self.cnt = 0;
};
void() necro1_melee2 = [$Siatak4,  necro1_melee3 ] {
    sound(self,CHAN_WEAPON,"knight/sword1.wav",1,ATTN_NORM);
    ai_charge(0); ai_melee();
};
void() necro1_melee3 = [$Siatak6,  necro1_melee4 ] { ai_charge(3); ai_melee(); };
void() necro1_melee4 = [$Siatak8,  necro1_melee5 ] { ai_charge(2); ai_melee();
    if (self.enemy.health > 0)
    if (self.cnt > 0)
    if (InMeleeRange (80))
    {   // Interrupt for a new attack, much like Zeal.
        self.cnt = self.cnt - 1;
        self.think = necro1_melee2;
        return;
    }
    self.cnt = 0;
};
void() necro1_melee5 = [$Siatak10, necro1_melee6 ] { ai_charge(1); };
void() necro1_melee6 = [$Siatak12, necro1_run1   ] { ai_charge(0); necro_run_check(); };
void() necro1_melee = {
    if (InMeleeRange (80))
        necro1_melee1();
    else
    {
        if (self.classtype == CT_MONNECRO)
            if (random() < 0.2)
            {   // In case the boss gets stuck, let him make some potshots.
                if (self.th_missile)
                    self.th_missile();
                return;
            }
        ai_charge (16);     // Not close enough -- continue march.
    }
};

void() necro1_attack1  = [$Siatak1,  necro1_attack2  ] { ai_face(); };
void() necro1_attack2  = [$Siatak5,  necro1_attack3  ] { ai_face(); self.cnt = 0; };
void() necro1_attack3  = [$Siatak6,  necro1_attack4  ] { ai_face();
    if (!self.cnt)
    {   // Set refire count.
        if (self.classtype == CT_MONNECRO)
            self.cnt = random() * 3 & 3 + 1;
        else if (necro_encore ())
            self.cnt = 1;
    }
    if (self.cnt)
        sound(self,CHAN_WEAPON,"drake/necro/att_a2.wav",1,ATTN_NORM);
    else
        sound(self,CHAN_WEAPON,"drake/necro/att_a.wav",1,ATTN_NORM);
    acolyte_fire();
// Make small poison cloud.  'makevectors' called in above function.
    local   vector  org;
    org = self.origin + v_forward*14 - v_right*8 + v_up*12;
    MakeFancy (org, X32_CLOUD_GREEN + 1, 3);
};
void() necro1_attack4  = [$Siatak6,  necro1_attack5  ] { ai_face();
    if (self.cnt)
    {
        acolyte_fire();
        self.cnt = self.cnt - 1;
        if (self.cnt)
            self.think = necro1_attack3;
    }
};
void() necro1_attack5  = [$Siatak11, necro1_attack6  ] { ai_face(); acolyte_fire(); };
void() necro1_attack6  = [$Siatak12, necro1_run1     ] { ai_face(); };

float() sorcerer_tele = {
//- - - - - - - - -
//  The main purpose of this teleportation check is to increase distance
//  between the enemy and the necro.  Otherwise, enemies that reach the
//  necro can layeth the smackdown on him.
//- - - - - - - - -
    return necro_teleport (self.enemy, self.origin, 2);
};
void() necro2_attack1  = [$Statak1,  necro2_attack2  ] { ai_face(); };
void() necro2_attack2  = [$Statak2,  necro2_attack3  ] { ai_face(); };
void() necro2_attack3  = [$Statak3,  necro2_attack4  ] { ai_face();
    if (!sorcerer_tele ())
        sorcerer_fire(2);
};
void() necro2_attack4  = [$Statak4,  necro2_attack5  ] { ai_face(); };
void() necro2_attack5  = [$Statak5,  necro2_attack6  ] { ai_face();
    if (necro_encore ())
        sorcerer_fire(3);
};
void() necro2_attack6  = [$Statak6,  necro2_attack7  ] { ai_face(); };
void() necro2_attack7  = [$Statak7,  necro2_attack8  ] { ai_face(); };
void() necro2_attack8  = [$Statak8,  necro2_run1     ] { ai_face(); };

float() necro4_gangup = {
    local   entity  head;

    head = findradius (self.origin, 120);
    while (head)
    {
        if (head.enemy == self)
            if (self.enemy != head)
                if (CanDamage (head, self))
                    return TRUE;
        head = head.chain;
    }
    return FALSE;
};
void() necro3_attack1  = [$Hatak1,  necro3_attack2  ] { ai_face(); };
void() necro3_attack2  = [$Hatak2,  necro3_attack3  ] { ai_face(); };
void() necro3_attack3  = [$Hatak4,  necro3_attack4  ] { ai_face();
    if (InMeleeRange (80))
        if (!(self.enemy.flags & (FL_FLY | FL_SWIM))) {
            if (self.classtype == CT_MONNECRO) { // Boss escapes instead if ganged-up by more enemies.
                if (necro4_gangup ())
                    if (sorcerer_tele ()) return;
            }
            ai_repel();
            return;
        }
// Shoving won't work, so zap the target instead.
    if (self.classname == "monster_necromancer")
    {   // Update:  Boss may teleport away instead.
        if (sorcerer_tele ())
            return;
    }
    warlock_fire('12 9 27');
};
void() necro3_attack4  = [$Hatak6,  necro3_attack5  ] { ai_face(); };
void() necro3_attack5  = [$Hatak8,  necro3_run1     ] { ai_face();
    if (necro_encore ())
        warlock_fire('14 8 27');
};
void() necro3_melee = {
// If necro is not close enough to repel target, he will zap the enemy
// continuously with bolts, which is a bit overkill.  Instead, charge
// most of the time.
    if (!InMeleeRange (80))
        if (random() < 0.6)     // 40% chance per frame to attack.
            { ai_charge (16);  return; }
    necro3_attack1();
};

void() necro_activate_special = {
    local   float   wtype;

    wtype = self.worldtype;
    if (!wtype) return;

    if (wtype == NSA_CURSE) {
		wtype = NSA_SUMMON_GOLEM;
		// Curses have a duration of ten seconds.
		/*
        if (self.enemy.flags & FL_MONSTER) {
			// Special cases for some monsters.
            if (self.enemy.classgroup == CG_ZOMBIE && targ.classtype != CT_MONMUMMY)) {
				// Supress zombie immortality so any damage can kill zombies.
                T_Curse (self.enemy, self, CURSE_ARMOR, 10);
                return;
            }

            // If target is mad at a friend of necro, try to redirect its rage.
            //if (Align_Match (self.enemy.enemy, self))
			if (self.enemy.charmed && self.enemy.enemy != world)
                if (T_Confuse (self.enemy, self))
                    return;
        }
        // Invoke one of several nasty status effects.
        T_Curse(self.enemy, self, 0, 10);
        return;*/
    }
    if (wtype == NSA_SUMMON_GOLEM) {
		// If necro cannot summon a golem near an enemy, summon one near
        // himself.  High-flying targets often prevent telebomb summoning. 
        //if (!SpawnMonster_Attack(self, ID_GOLEM_KNIGHT))
            //SpawnMonster_Fan(self, self.origin, ID_GOLEM_KNIGHT);

		if (query_minionactive(self) == TRUE) {
			// Findradius version
			makevectors(self.angles);
			self.pos1 = self.origin + self.view_ofs + v_forward*64 + v_up*32;
            if (SpawnMinionInRadius(self.pos1)) self.pos2 = self.pos1 - '0 0 16';	// Origin of gargoyle
		}
        return;
    }
    if (wtype == NSA_SUMMON_IMPS) {
		//local   float   loop;
        // loop = NECRO_MAX_IMPS - count_petclass(self, "monster_imp");
        // if (loop > self.height)
            // loop = self.height;
        // SpawnMonster_Horde (ID_IMP_KINN, loop);
			// Find out if there is enough space to spawn a gargoyle
		// has the gargoyle limit been reached?
		if (query_minionactive(self) == TRUE) {
            makevectors(self.angles);
            self.pos1 = self.origin + self.view_ofs + v_forward*64 + v_up*32;
            if (SpawnMinionInRadius(self.pos1)) self.pos2 = self.pos1 - '0 0 16';	// Origin of gargoyle
		}
        return;
    }
    if (wtype == NSA_CORPSE_EXPLOSION) {
		if (self.fallen.deadflag == DEAD_DEAD) {
			local   entity  swap;
			local   float   sfx;
	
			sfx = random() * 4 & 3;
	
			swap = self;
			self = self.fallen;
			self.health = self.gibhealth - 1;
			monster_check_gib();
			if (self.gibbed) {
				local  float damage, rgb;
	
				rgb = ((fabs(self.bloodtype) / 16) & 15) * 16;
				damage = self.max_health * (random() * 0.4 + 0.6) * 0.2;    //120
				if (damage > 120) damage = 120; // limit damage so it's not crazy hard when we explode a monster_boglord for instance
				Tent_Explosion2 (self.origin, rgb, 16);
				if (sfx == 1)
					sound(self,CHAN_AUTO,"drake/necro/pop1.wav",1,ATTN_NORM);
				else if (sfx == 2)
					sound(self,CHAN_AUTO,"drake/necro/pop2.wav",1,ATTN_NORM);
				else if (sfx == 3)
					sound(self,CHAN_AUTO,"drake/necro/pop3.wav",1,ATTN_NORM);
				else
					sound(self,CHAN_AUTO,"drake/necro/pop4.wav",1,ATTN_NORM);
				T_RadiusDamage(self, swap, damage, self, DAMAGEALL);
			}
			self = swap;
		}
        self.fallen = world;
        self.worldtype = 0;
        return;
    }
};

void() necro4_attack = {
    local   entity  head;
    local   float   safe, yes;

    self.worldtype = 0;
    safe = !InMeleeRange(80);

	// Check for cursing.
    if (safe) {
        if (self.height >= NECRO_SORCERER)      // Not in acolyte mode.
        if (!self.enemy.curse_type)
        if (random() < 0.5) {
            self.worldtype = NSA_CURSE;
            sound(self,CHAN_AUTO,"drake/necro/curse.wav",1,ATTN_NORM);
            necro_cast();
            return;
        }
    }
// Check for corpse explosion.
    if (safe) {
        if (self.minion_count >= self.minion_maxcount)
            yes = 1;
        else if (self.minion_count)
            yes = 0.75;
        else
            yes = 0.5;
    } else {
        yes = 0.25;
	}
    if (random() < yes) {
        if (self.height >= NECRO_SORCERER) {  // Not in acolyte mode. 
            self.fallen = world;
            head = QC_FindRadius (self.enemy.origin, 200);
            while (head) {
                if (head.deadflag == DEAD_DEAD) {
					if (infront (head)) {
						traceline (self.origin + self.view_ofs, head.origin, TRUE, self);
						if (trace_fraction == 1)
						{
							if (CanDamage (self.enemy, head))
							{   // Seek the corpse with the highest max health,
								// since damage is based on max health.
								if (head.max_health > self.fallen.max_health)
									self.fallen = head;
							}
						}
					}
				}
                head = head.chain;
            }
            if (self.fallen) {
                self.worldtype = NSA_CORPSE_EXPLOSION;
                sound(self,CHAN_AUTO,"drake/necro/pop.wav",1,ATTN_NORM);
                necro_cast();
                return;
            }
        }
    }
	// Check for summoning.
    if (safe) {
        if (random() < 0.75) {
        // Check for golem.  Do only in warlock mode.
            if (self.height == NECRO_WARLOCK) {
                yes = 1;
                head = find(world, classname, "monster_golem");
                while (head) {
                    if (head.charmer == self) {
                        if (head.deadflag < DEAD_DEAD) {
                            yes = 0;   // Already have a golem out.
                            if (self.enemy)
                            if (!((head.health <= 0) || head.deadflag))
                            if (!visxray(self,head,self.view_ofs,head.view_ofs,TRUE))
                            if (!visxray(head,self.enemy,self.view_ofs,head.view_ofs,TRUE)) {
								// Unsummon current, and summon new one.
                                T_Damage(head, self, self, (head.health + 1), NOARMOR);
                                if (head.health <= 0)   // Confirm destruction.
                                    self.worldtype = NSA_SUMMON_GOLEM;
                            }
                        }
                    }
                    if (yes)
                        head = find(head, classname, "monster_golem");
                    else
                        head = world;
                }
                if (yes)
                    self.worldtype = NSA_SUMMON_GOLEM;
            }
        // Check for imps.
            if (!self.worldtype)
            {
                if (random() < 0.75)
                {
                    if (self.minion_count < 2)    //self.height)
                        self.worldtype = NSA_SUMMON_IMPS;
                }
            }
        // Now see if necro will summon something.
            if (self.worldtype)
            {
                sound(self,CHAN_AUTO,"drake/necro/summon.wav",1,ATTN_NORM);
                necro_cast();
                return;
            }
        }
    }
// Just blast the enemy.
    if (self.height == NECRO_ACOLYTE)
        necro1_attack1();
    else if (self.height == NECRO_SORCERER)
        necro2_attack1();
    else
        necro3_attack1();
};

// PAIN
void(void() skip) necro_skip = { if (random() < 0.5) skip(); };

// Check for an escape during pain.
void() necro_telepain = {
    if (self.classtype == CT_MONNECRO) {
        if (self.enemy) {
            if ((random() < 0.25) || (self.liquidbase <= CONTENT_SLIME)) necro_teleport (self.enemy, self.origin, TRUE);
        }
    }
};

void() necro1_pain1  = [$Sipain1,  necro1_pain2  ] { necro_skip(necro1_pain2); };
void() necro1_pain2  = [$Sipain2,  necro1_pain3  ] {};
void() necro1_pain3  = [$Sipain3,  necro1_pain4  ] {};
void() necro1_pain4  = [$Sipain4,  necro1_pain5  ] {};
void() necro1_pain5  = [$Sipain5,  necro1_pain6  ] { necro_skip(necro1_pain6); };
void() necro1_pain6  = [$Sipain6,  necro1_pain7  ] {};
void() necro1_pain7  = [$Sipain7,  necro1_pain8  ] {};
void() necro1_pain8  = [$Sipain8,  necro1_run1   ] { necro_run_check(); };

void() necro2_pain1  = [$Stpain1,  necro2_pain2  ] { necro_skip(necro2_pain2); };
void() necro2_pain2  = [$Stpain2,  necro2_pain3  ] {};
void() necro2_pain3  = [$Stpain3,  necro2_pain4  ] { necro_skip(necro2_pain4); };
void() necro2_pain4  = [$Stpain4,  necro2_pain5  ] {};
void() necro2_pain5  = [$Stpain5,  necro2_pain6  ] { necro_skip(necro2_pain6); };
void() necro2_pain6  = [$Stpain6,  necro2_pain7  ] {};
void() necro2_pain7  = [$Stpain7,  necro2_pain8  ] { necro_skip(necro2_pain8); };
void() necro2_pain8  = [$Stpain8,  necro2_run1   ] { necro_telepain(); };

void() necro3_pain1  = [$Hpain2,  necro3_pain2  ] {};
void() necro3_pain2  = [$Hpain3,  necro3_pain3  ] { necro_skip(necro3_pain3); };
void() necro3_pain3  = [$Hpain4,  necro3_pain4  ] {};
void() necro3_pain4  = [$Hpain6,  necro3_pain5  ] {};
void() necro3_pain5  = [$Hpain7,  necro3_pain6  ] { necro_skip(necro3_pain6); };
void() necro3_pain6  = [$Hpain8,  necro3_run1   ] { necro_telepain(); };

// Named (foo)switch as C's switch.
void() necro_painswitch = {
    if (self.height == NECRO_ACOLYTE)
        necro1_pain1();
//    else if ((self.frame >= $Siatak1 ) && (self.frame <= $Siwait12 ))
//        necro1_pain1();
    else if (self.height == NECRO_SORCERER)
        necro2_pain1();
    else //if (self.height == NECRO_WARLOCK)
        necro3_pain1();
};

// Check for weapon breakage and update ai accordingly.
// As weapon breaks, the necro uses stronger moves.  Only boss should use.
float() Necro_WeaponBroke = {
    local   vector  org, vel, spin;
    local   float   head, shaft;

	// Check which parts need to break.
    head = shaft = FALSE;
    if (self.height < NECRO_WARLOCK) {
        if (self.health <= self.max_health / 2) shaft = TRUE;
        if (self.height < NECRO_SORCERER) {
            if (self.health <= self.max_health * 5 / 6) head = TRUE;
            else if (!shaft) return FALSE;   // Nothing broke.
        }
        else if (!shaft) return FALSE;   // Nothing broke.
    }
    else
        return FALSE;   // Weapon already broke!

    makevectors(self.angles);

	// Sickle head.
    if (head) {
        sound(self,CHAN_AUTO,"kinn/misc/metalbrk.wav",1,ATTN_NORM);
        vel = VelocityForDamage (0);
        spin_x = random()*600;
        spin_y = random()*600;
        spin_z = random()*600;
        org = self.origin + v_forward*17 + v_right*20 + v_up*31;    // '16.57 19.78 30.68'
		if (self.gib1mdl != "") ThrowGib(11, 1);

        if (!shaft) {
            self.height     = NECRO_SORCERER;
            self.th_stand   = necro2_stand1;
            self.th_walk    = necro2_walk1;
            self.th_run     = necro2_run1;
            self.th_missile = necro4_attack;
            self.th_melee   = necro4_attack;
        }
    }

	// Shaft.
    if (shaft) {
        sound(self,CHAN_AUTO,"drake/misc/woodbrk.wav",1,ATTN_NORM);
        vel = VelocityForDamage (0);
        vel = vel + v_right*50;
        spin_x = random()*600;
        spin_y = random()*600;
        spin_z = random()*600;
        org = self.origin + v_forward*15 + v_right*10 + v_up*25;
		if (self.gib2mdl != "") ThrowGib(12, 1);


        vel = VelocityForDamage (0);
        vel = vel - v_right*50;
        spin_x = random()*600;
        spin_y = random()*600;
        spin_z = random()*600;
        org = self.origin + v_forward*15 - v_right*7 + v_up*15;     // '14.12 9.67 24.54'
		if (self.gib3mdl != "") ThrowGib(13, 1);
    
        self.height     = NECRO_WARLOCK;
        self.th_stand   = necro3_stand1;
        self.th_walk    = necro3_walk1;
        self.th_run     = necro3_run1;
        self.th_missile = necro4_attack;
        self.th_melee   = necro4_attack;
    }

    return TRUE;
};

void(entity inflictor, entity attacker, float damage) necro_pain = {
	// Update:  Check for evolution/weapon breakage for boss necro.
    if (self.classtype == CT_MONNECRO)
    if (Necro_WeaponBroke ()) {
		// Must go into pain for weapon breaking effects to look right.
        self.pain_finished = time + 1;
        sound(self,CHAN_VOICE, "drake/necro/pain1.wav",1,ATTN_NORM);
        necro_painswitch();
        return;
    }

    if (self.pain_finished > time)
        return;   // Don't make multiple pain sounds right after each other.

    sound(self,CHAN_VOICE, "drake/necro/pain1.wav",1,ATTN_NORM);
    self.pain_finished = time + 1;      // time + 0.5 is too short.

    if (random()*50 > damage)       // Was flat 40.
        return;         // Didn't flinch
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

	// Will go into a pain anim, so turn off the shield if it is on.
    if (!self.mirror_finished)
        self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);

    necro_painswitch();
};

// Standard death functions.
void() necro_die1  = [$deathA2,  necro_die2  ] {
	self.reviveframestart = $deathA20;
	self.reviveframeend = $deathA2;
};
void() necro_die2  = [$deathA4,  necro_die3  ] { monster_check_gib(); };
void() necro_die3  = [$deathA6,  necro_die4  ] { monster_check_gib(); };
void() necro_die4  = [$deathA8,  necro_die5  ] {};
void() necro_die5  = [$deathA10, necro_die6  ] {};
void() necro_die6  = [$deathA12, necro_die7  ] {};
void() necro_die7  = [$deathA14, necro_die8  ] {};
void() necro_die8  = [$deathA16, necro_die9  ] { ai_forward(4); };
void() necro_die9  = [$deathA18, necro_die10 ] { ai_forward(4); };
void() necro_die10 = [$deathA19, necro_die11 ] { ai_forward(1); monster_death_postcheck(); };
void() necro_die11 = [$deathA20, necro_die11 ] { ai_forward(1); monster_deadbody_check(); };

void() necro_die = {
	self.gib1mdl = self.gib2mdl = self.gib3mdl = ""; // Don't drop more wands!

	// Wand is usable weapon so don't let the sorcerer drop his wand.
	monster_death_precheck();

	if (!self.gibbed) {
		if (random() < 0.5)
			sound(self,CHAN_VOICE, "drake/necro/death1.wav",1,ATTN_NORM);
		else
			sound(self,CHAN_VOICE, "drake/necro/death2.wav",1,ATTN_NORM);
		necro_die1();
	}
};

void() necro_cache = {
    precache_model("progs/drake/necro.mdl");
    precache_model("progs/drake/h_necro.mdl");
    precache_model("progs/drake/r_bolt.mdl");
    precache_model("progs/drake/smartbal.mdl");
    precache_model("progs/w_spike.mdl");
    precache_model("progs/drake/nec_rune.mdl");
    precache_model("progs/drake/nec_rod1.mdl");
    precache_model("progs/drake/nec_rod2.mdl");
    precache_model("progs/drake/nec_rod3.mdl");
    precache_model("progs/drake/s_spark.spr");
    precache_model("progs/drake/ice.mdl");
    precache_model("progs/drake/k_ball.mdl");
    precache_model("progs/drake/s_wave2.spr");
    precache_model("progs/drake/akarrow.mdl");
    precache_model("progs/drake/hk_golem.mdl");
    precache_model("progs/drake/h_hkolem.mdl");
    precache_model("progs/drake/st_gib1.mdl");
    precache_model("progs/drake/st_gib2.mdl");
    precache_model("progs/drake/st_gib3.mdl");
    precache_sound("drake/curse/x_armor.wav");
    precache_sound("drake/necro/att_a.wav");
    precache_sound("drake/necro/att_a2.wav");
    precache_sound("drake/necro/att_w.wav");
    precache_sound("drake/necro/death1.wav");
    precache_sound("drake/necro/death2.wav");
    precache_sound("drake/necro/idle1.wav");
    precache_sound("drake/necro/idle2.wav");
    precache_sound("drake/necro/pain1.wav");
    precache_sound("drake/necro/sight1.wav");
    precache_sound("zerstorer/trog/frblfly.wav");
    precache_sound("drake/skullwiz/push.wav");
    precache_sound("drake/curse/x_armor.wav");
    precache_sound("drake/curse/x_damage.wav");
    precache_sound("drake/curse/x_muddle.wav");
    precache_sound("drake/curse/x_slow.wav");
    precache_sound("drake/curse/x_weaken.wav");
    precache_sound("kinn/misc/metalbrk.wav");
    precache_sound("drake/misc/woodbrk.wav");
    precache_sound("drake/necro/curse.wav");
    precache_sound("drake/necro/pop.wav");
    precache_sound("drake/necro/pop1.wav");
    precache_sound("drake/necro/pop2.wav");
    precache_sound("drake/necro/pop3.wav");
    precache_sound("drake/necro/pop4.wav");
    precache_sound("drake/necro/summon.wav");
    precache_sound("drake/dragon/icehit.wav");
    precache_sound("hipnotic/grem/attack.wav");     // Replaces Hexen2 imp slash sfx.
    precache_sound("drake/imp/die.wav");
    precache_sound("drake/imp/fireball.wav");
    precache_sound("drake/imp/fly.wav");
    precache_sound("drake/imp/flywater.wav");
    precache_sound("drake/imp/shard.wav");
    precache_sound("drake/imp/swoop.wav");
    precache_sound("drake/imp/up.wav");
    precache_sound("drake/misc/pushston.wav");
    precache_sound("drake/misc/wallbrk.wav");
    precache_sound("ne_ruins/h2golem/death.wav");
    precache_sound("drake/golem/sight.wav");
    precache_sound("drake/golem/step.wav");
    precache_sound("hknight/grunt.wav");
    precache_sound("hknight/slash1.wav");
    precache_sound("drake/misc/wallbrk.wav");
    precache_sound("shambler/smack.wav");
    precache_sound("drake/weapons/mirv1.wav");   // In case MIRV is forbidden.
};

void() setup_necro;

// --> QUAKED monster_necromancer (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_necromancer = {
    local float nec;

	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

    if (self.classname == "monster_acolyte") {
		nec = NECRO_ACOLYTE;
		if (self.health < 1) self.health = 150;
		if (self.deathstring == "") self.deathstring = " was humiliated by an Acolyte\n";
	} else if (self.classname == "monster_sorcerer") {
		if (self.deathstring == "") self.deathstring = " was bested by a Sorcerer\n";
		nec = NECRO_SORCERER;
		if (self.health < 1) self.health = 300;
	} else if (self.classname == "monster_warlock") {
		if (self.deathstring == "") self.deathstring = " was no match for a Warlock\n";
		nec = NECRO_WARLOCK;
		if (self.health < 1) self.health = 450;
    } else {
		self.classtype = CT_MONNECRO;
		if (self.deathstring == "") self.deathstring = " was snuffed by a Necromancer\n";
		nec = 0;
		if (self.health < 1) self.health = 1800;
	}

	if (self.minion_name == "") {
        self.minion_name = "monster_gargoyle";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }
	self.mdl = "progs/drake/necro.mdl";
	self.headmdl = "progs/drake/h_necro.mdl";
    self.height = nec;
	self.idle_sound = "drake/necro/idle1.wav";
	self.idle_soundcom = "drake/necro/idle2.wav";
	self.sight_sound = "drake/necro/sight1.wav";
	self.hello_sound = "drake/necro/idle1.wav";
	self.pain_sound = "drake/necro/pain1.wav";

	// Special class used for precache only
	if (self.classtype != CT_CACHENECRO) setup_necro();
};

void() monster_necrominion = { 
	self.classtype = CT_CACHENECRO;
	monster_necromancer();
};

void() setup_necro = {
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	self.gibhealth = -40;				// Need a powerful weapon to GIB
	self.gibbed = FALSE;				// no falling apart
	self.pain_flinch = 70;				// High pain threshold
	self.blockudeath = TRUE;			// no humanoid death sound
    self.mass = MASS_MEDIUM;
	self.gib1mdl = "progs/drake/nec_rod1.mdl";
	self.gib2mdl = "progs/drake/nec_rod2.mdl";
	self.gib3mdl = "progs/drake/nec_rod3.mdl";
	if (self.classtype == CT_MONACOLYTE) {
		self.th_stand   = necro1_stand1;
		self.th_walk    = necro1_walk1;
		self.th_run     = necro1_run1;
		self.th_missile = necro1_attack1;
		self.th_melee   = necro1_melee;
	}
	if (self.classtype == CT_MONSORCERER) {
		self.th_stand   = necro2_stand1;
		self.th_walk    = necro2_walk1;
		self.th_run     = necro2_run1;
		self.th_missile = necro2_attack1;
		self.th_melee   = necro2_attack1;
	}
	if (self.classtype == CT_MONWARLOCK) {
		self.th_stand   = necro3_stand1;
		self.th_walk    = necro3_walk1;
		self.th_run     = necro3_run1;
		self.th_missile = necro3_attack1;
		self.th_melee   = necro3_melee;
	}

	if (self.classtype == CT_MONNECRO) {
		// Necromancer boss
        self.skin       = 1;
        self.classname  = "monster_necromancer";
        self.height     = NECRO_ACOLYTE;    // Start in acolyte mode.
        self.ryuflags   = RYU_ALERT;
        self.purse      = '20 1 0.5';
        self.bossflag = TRUE;
        self.th_stand   = necro1_stand1;
        self.th_walk    = necro1_walk1;
        self.th_run     = necro1_run1;
        self.th_missile = necro4_attack;    //necro1_attack1;
        self.th_melee   = necro1_melee;
    } else {
		// The other necroclass defaults for nonboss
		self.purse = '1 0.5 0.5';  // max = 1, 50% for 1, 50% gem.
		self.purse_x = 1 + self.height;
	}
    self.th_pain    = necro_pain;
    self.th_die     = necro_die;
    self.th_spawn   = setup_necro;
    self.waitmax    = 0;    // Teleport delay, similar to nemesant.
    Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (!self.classtype) self.classtype = CT_MONACOLYTE;
	if (!self.classgroup) self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEWALK;
	if (self.worldtype) {
		if (!self.minion_maxcount) self.minion_maxcount = 3;
	}
    monster_start();
};

void() monster_acolyte = { self.classtype = CT_MONACOLYTE; monster_necromancer(); };
void() monster_sorcerer = { self.classtype = CT_MONSORCERER; monster_necromancer(); };
void() monster_warlock = { self.classtype = CT_MONWARLOCK; monster_necromancer(); };

// Coven of Ebony entities.
void() monster_fragwiz = { monster_acolyte(); };
void() monster_sorceror = { monster_sorcerer(); };// PM:  Spelled 'sorcerer' NOT 'sorceror'.