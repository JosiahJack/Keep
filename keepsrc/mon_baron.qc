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
// Entity count: 5
// Function count: 214
//
// Implements: Baron, Fire Baron, Earth Baron, Wind Baron, Water Baron
//
// Description:
// Specialty knight with 4 alternative bosses with unique abilities, see below.
// Draws sword when alerted.  If Ambush spawnflag 1 is set, will not make idle
// noises.  Spawnflag 4 disables jumping.
//=============================================================================

//  Frames:
//     0 -  10  Wave (with sword on back -- idle taunt?)
//    11 -  21  Point (super missile attack for Rapture baron)
//    22 -  40  Crouch Stand
//    41 -  43  Pain #1
//    44 -  49  Death #1
//    50 -  55  Death #2
//    56 -  61  Run
//    62 -  66  Sword Draw
//    67 -  78  Smack -- melee punch attack
//    79 -  98  Stand
//    99 - 102  Pain #2
//   103 - 108  Blam -- melee sword attack
//   109 - 115  Magic Missile attack
//   116 - 124  Taunt
//   125 - 130  Jump

$cd progs/baron
$origin 0 0 24
$base base    
$skin base
$frame wave1 wave2 wave3 wave4 wave5 wave6 wave7 wave8 wave9 wave10 wave11
$frame point1 point2 point3 point4 point5 point6 point7 point8 point9
$frame point10 point11
$frame crstand1 crstand2 crstand3 crstand4 crstand5 crstand6 crstand7
$frame crstand8 crstand9 crstand10 crstand11 crstand12 crstand13 crstand14
$frame crstand15 crstand16 crstand17 crstand18 crstand19
$frame paina1 paina2 paina3
$frame diea1 diea2 diea3 diea4 diea5 diea6
$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6
$frame run1 run2 run3 run4 run5 run6
$frame draw1 draw2 draw3 draw4 draw5
$frame smack1 smack2 smack3 smack4 smack5 smack6 smack7 smack8 smack9
$frame smack10 smack11 smack12
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11
$frame idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 idle20
$frame painb1 painb2 painb3 painb4
$frame blam1 blam2 blam3 blam4 blam5 blam6
$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7
$frame taunt1 taunt2 taunt3 taunt4 taunt5 taunt6 taunt7 taunt8 taunt9
$frame jump1 jump2 jump3 jump4 jump5 jump6

float BSF_NO_JUMP = 4; // Disables jumping.
float BARON_SPEED = 32; // PM:  Baron model was designed to run 12 pixels per frame, but since Nehahra had fast barons, double the speed to 24.  Update:  Source diving reveals 32 was used by Nehahra.

void() baron_throw1;

// FALSE = sword in scabbard, TRUE = sword in hand.
float() baron_sword_drawn = {
    if (self.frame <= $wave11) return FALSE;
    if (self.frame >= $idle1 && self.frame <= $idle20) return FALSE;
    return TRUE;
};

// PM:  Unsheath sound is loud, so keep the volume down.
void() baron_draw_sound = { sound(self,CHAN_WEAPON,"drake/weapons/unsheath.wav", 0.5,ATTN_IDLE); };

void() baron_idle1  = [$draw5,  baron_idle2  ] { ai_stand(); };
void() baron_idle2  = [$draw4,  baron_idle3  ] { ai_stand(); };
void() baron_idle3  = [$draw3,  baron_idle4  ] { sound(self,CHAN_WEAPON,"drake/weapons/sheath.wav", 0.5,ATTN_IDLE); ai_stand(); };
void() baron_idle4  = [$draw2,  baron_idle5  ] { ai_stand(); };
void() baron_idle5  = [$draw1,  baron_idle6  ] { ai_stand(); };
void() baron_idle6  = [$idle1,  baron_idle7  ] { ai_stand(); };
void() baron_idle7  = [$idle2,  baron_idle8  ] { ai_stand(); };
void() baron_idle8  = [$idle3,  baron_idle9  ] { ai_stand(); };
void() baron_idle9  = [$idle4,  baron_idle10 ] { ai_stand(); };
void() baron_idle10 = [$idle5,  baron_idle11 ] { ai_stand(); };
void() baron_idle11 = [$idle6,  baron_idle12 ] { ai_stand(); };
void() baron_idle12 = [$idle7,  baron_idle13 ] { ai_stand(); };
void() baron_idle13 = [$idle8,  baron_idle14 ] { ai_stand(); };
void() baron_idle14 = [$idle9,  baron_idle15 ] { ai_stand(); };
void() baron_idle15 = [$idle10, baron_idle16 ] { ai_stand(); };
void() baron_idle16 = [$idle11, baron_idle17 ] { monster_idle_sound(); ai_stand(); };
void() baron_idle17 = [$idle12, baron_idle18 ] { ai_stand(); };
void() baron_idle18 = [$idle13, baron_idle19 ] { ai_stand(); };
void() baron_idle19 = [$idle14, baron_idle20 ] { ai_stand(); };
void() baron_idle20 = [$idle15, baron_idle21 ] { ai_stand(); };
void() baron_idle21 = [$idle16, baron_idle22 ] { ai_stand(); };
void() baron_idle22 = [$idle17, baron_idle23 ] { ai_stand(); };
void() baron_idle23 = [$idle18, baron_idle24 ] { ai_stand(); };
void() baron_idle24 = [$idle19, baron_idle25 ] { ai_stand(); };
void() baron_idle25 = [$idle20, baron_idle26 ] { ai_stand(); };
void() baron_idle26 = [$idle19, baron_idle27 ] { ai_stand(); };
void() baron_idle27 = [$idle18, baron_idle28 ] { ai_stand(); };
void() baron_idle28 = [$idle17, baron_idle29 ] { ai_stand(); };
void() baron_idle29 = [$idle16, baron_idle30 ] { ai_stand(); };
void() baron_idle30 = [$idle15, baron_idle31 ] { ai_stand(); };
void() baron_idle31 = [$idle14, baron_idle32 ] { ai_stand(); };
void() baron_idle32 = [$idle13, baron_idle33 ] { ai_stand(); };
void() baron_idle33 = [$idle12, baron_idle34 ] { ai_stand(); };
void() baron_idle34 = [$idle11, baron_idle35 ] { monster_idle_sound(); ai_stand(); };
void() baron_idle35 = [$idle10, baron_idle36 ] { ai_stand(); };
void() baron_idle36 = [$idle9,  baron_idle37 ] { ai_stand(); };
void() baron_idle37 = [$idle8,  baron_idle38 ] { ai_stand(); };
void() baron_idle38 = [$idle7,  baron_idle39 ] { ai_stand(); };
void() baron_idle39 = [$idle6,  baron_idle40 ] { ai_stand(); };
void() baron_idle40 = [$idle5,  baron_idle41 ] { ai_stand(); };
void() baron_idle41 = [$idle4,  baron_idle42 ] { ai_stand(); };
void() baron_idle42 = [$idle3,  baron_idle43 ] { ai_stand(); };
void() baron_idle43 = [$idle2,  baron_idle6  ] { ai_stand(); };

void() baron_stand = { // [FUNCTION]
    if (baron_sword_drawn ()) baron_idle1(); // Put sword away.
    else baron_idle6();
};

// Since baron model does not have a proper walk scene, animate the run scene at half speed.
void() baron_walk1  = [$draw1, baron_walk2  ] { baron_draw_sound(); ai_turn(); };
void() baron_walk2  = [$draw2, baron_walk3  ] { ai_turn(); };
void() baron_walk3  = [$draw3, baron_walk4  ] { ai_turn(); };
void() baron_walk4  = [$draw4, baron_walk5  ] { ai_turn(); };
void() baron_walk5  = [$draw5, baron_walk6  ] { ai_turn(); };
void() baron_walk6  = [$run1,  baron_walk7  ] { monster_footstep(FALSE); ai_walk(6); };
void() baron_walk7  = [$run1,  baron_walk8  ] { ai_walk(6); };
void() baron_walk8  = [$run2,  baron_walk9  ] { ai_walk(6); };
void() baron_walk9  = [$run2,  baron_walk10 ] { ai_walk(6); };
void() baron_walk10 = [$run3,  baron_walk11 ] { ai_walk(6); };
void() baron_walk11 = [$run3,  baron_walk12 ] { ai_walk(6); };
void() baron_walk12 = [$run4,  baron_walk13 ] { monster_footstep(FALSE); ai_walk(6); };
void() baron_walk13 = [$run4,  baron_walk14 ] { ai_walk(6); };
void() baron_walk14 = [$run5,  baron_walk15 ] { ai_walk(6); };
void() baron_walk15 = [$run5,  baron_walk16 ] { ai_walk(6); };
void() baron_walk16 = [$run6,  baron_walk17 ] { ai_walk(6); };
void() baron_walk17 = [$run6,  baron_walk6  ] { ai_walk(6); };

void() baron_walk = { // [FUNCTION]
    if (baron_sword_drawn ()) baron_walk6(); // Start jogging.
    else baron_walk1(); // Draw sword then move.
};

//  Victory
void() baron_look6  = [$crstand1,  baron_look6  ] {
    SUB_AdvanceFrame(22,40);
    if (self.frame == 40) {
		if (self.movetarget || self.charmer) self.think = self.th_walk;
		else self.think = self.th_stand;
	}
    ai_stand();
};

void() baron_owned1  = [$point1,  baron_owned1  ] {
    SUB_AdvanceFrame(11,21);
    if (self.frame == 21) {
		if (self.movetarget || self.charmer) self.think = self.th_walk;
		else self.think = self.th_stand;
	}
    ai_stand();
};

void() baron_win = { // [FUNCTION]
	local float r;

    if (baron_sword_drawn ()) {
        r = random();
        if (r >= 0.3) {
            if (r < 0.6) {
				sound(self,CHAN_VOICE, "nehahra/baron/idle.wav",1,ATTN_NORM);
                self.walkframe = 5;
                baron_look6();
            } else {
				self.walkframe = 0;
                baron_owned1();
            }
            return;
        }
    }
    if (self.movetarget || self.charmer) self.th_walk();
    else self.th_stand();
};

void() baron_run1  = [$draw1, baron_run2  ] { baron_draw_sound(); ai_face(); };
void() baron_run2  = [$draw2, baron_run3  ] { ai_face(); };
void() baron_run3  = [$draw3, baron_run4  ] { ai_face(); };
void() baron_run4  = [$draw4, baron_run5  ] { ai_face(); };
void() baron_run5  = [$draw5, baron_run6  ] { ai_face(); };
void() baron_run6  = [$run1,  baron_run7  ] { monster_footstep(FALSE); ai_run(BARON_SPEED); };
void() baron_run7  = [$run2,  baron_run8  ] { ai_run(BARON_SPEED); };
void() baron_run8  = [$run3,  baron_run9  ] { ai_run(BARON_SPEED); };
void() baron_run9  = [$run4,  baron_run10 ] { monster_footstep(FALSE); ai_run(BARON_SPEED); };
void() baron_run10 = [$run5,  baron_run11 ] { ai_run(BARON_SPEED); };
void() baron_run11 = [$run6,  baron_run6  ] { ai_run(BARON_SPEED); };

void() baron_run = { // [FUNCTION]
    if (baron_sword_drawn ()) baron_run6(); // Start running.
    else baron_run1(); // Draw sword then move.
};

void() baron_sword = { // [FUNCTION]
    local float damage;
    local float deep;

    if (!self.enemy) return; // Removed before stroke
    if (!CanDamage (self.enemy, self)) return;

    deep = InMeleeRange(60); // In Nehahra, ai_melee then chainsaw(0) were called.  Simulate ai_melee range.
    ai_charge(10); // As per ogre in Nehahra source.
    if (!deep && !InMeleeRange(100)) return;
    if (!self.level && IsGhost(self.enemy)) return; // Elemental bosses can hit, but not moogles.  Not allowed to hit wraith.

    if (self.level) damage = 8; // Rapture boss.  Rapture hits once with the sword.  Nehahra (and Drake) hit four times.  For Rapture damage, divide by four.
    else damage = 4;
    damage = SUB_MeleeDamage(damage); // Update:  Emulate Nehahra damage.
    if (deep) damage = damage + SUB_MeleeDamage(3);
    T_Damage(self.enemy, self, self, damage,DAMARMOR);
};

void() baron_skip1  = [$blam4,  baron_blam5  ] { ai_charge(6); };
void() baron_skip2  = [$blam4,  baron_blam10 ] { ai_charge(6); };

// Update:  Nehahra used ai_charge(3).  My guess of 2 was close, but wrong.
void() baron_blam1  = [$blam1,  baron_blam2  ] { ai_charge(3); };
void() baron_blam2  = [$blam2,  baron_blam3  ] { ai_charge(3); if (self.level) self.think = baron_skip1; };
void() baron_blam3  = [$blam3,  baron_blam4  ] { ai_charge(3); };
void() baron_blam4  = [$blam4,  baron_blam5  ] { ai_charge(3); };
void() baron_blam5  = [$blam5,  baron_blam6  ] { ai_charge(3); baron_sword(); };
void() baron_blam6  = [$blam6,  baron_blam7  ] { ai_charge(3); baron_sword(); };
void() baron_blam7  = [$blam5,  baron_blam8  ] { ai_charge(3); if (self.level) self.think = baron_skip2; };
void() baron_blam8  = [$blam4,  baron_blam9  ] { ai_charge(3); };
void() baron_blam9  = [$blam3,  baron_blam10 ] { ai_charge(3); };
void() baron_blam10 = [$blam2,  baron_blam11 ] { ai_charge(3); baron_sword(); };
void() baron_blam11 = [$blam1,  baron_run    ] { ai_charge(3); baron_sword(); };

void() baron_fist = { // [FUNCTION]
    local vector delta, dir;
	local float damage, up;
    
    ai_face();
    walkmove(self.ideal_yaw,12);    // allow a little closing
    delta = self.enemy.origin - self.origin;

    // Check if fist can hit.
    if (!InMeleeRange(self.meleerange)) return;
    if (!CanDamage(self.enemy,self)) return;
    if (!self.enemy.takedamage) return; // For mega-enforcer.
    if (!self.level && IsGhost(self.enemy)) return; // Elemental bosses can hit, but not moogles.  For wraith.
        
    // Fist connects.
    if (self.level) damage = SUB_MeleeDamage(45);  // Max damage of 135!  o_O
    else { // In Nehahra, baron had damage set to 1d11+10, but was overriden by 1d5+10.  Bug or intended, since his sword does so much more damage, I'll make it do 1d10+10.
        damage = random()*10 + 10; // 10-20 damage.
    }

    if (random() < 0.1) { // Crushing blow -- Knockback the target!
        up = 350;   //random() * 100 + 250;
        dir = normalize(self.enemy.origin - self.origin);
        dir = dir * 400;    //(random() * 100 + 200);
        if (self.enemy.flags & FLx_CREATURE) {
            self.enemy.velocity = self.enemy.velocity + dir;
            if (self.enemy.flags & FL_ONGROUND) {
                SUB_RemoveFlags(self.enemy,FL_ONGROUND);
                self.enemy.velocity_z = up;
            }
        }

        if (!self.level) self.think = baron_throw1; // Bosses won't dally around.  Unlike Nehahra, do extended anim only on a hit.
    }

    sound(self,CHAN_WEAPON,"nehahra/baron/smash.wav",1,ATTN_NORM);
    T_Damage(self.enemy, self, self, damage,DAMARMOR);
	SpawnMeatSpray(self, self.enemy,crandom() * 150);
	SpawnMeatSpray(self, self.enemy,crandom() * 150);
};

void() baron_throw1  = [$smack11, baron_throw2  ] { ai_face(); };
void() baron_throw2  = [$smack12, baron_throw3  ] { ai_face(); };
void() baron_throw3  = [$smack11, baron_throw4  ] { ai_face(); };
void() baron_throw4  = [$smack10, baron_throw5  ] { ai_face(); };
void() baron_throw5  = [$smack9,  baron_throw6  ] { ai_face(); };
void() baron_throw6  = [$smack8,  baron_throw7  ] { ai_face(); };
void() baron_throw7  = [$smack7,  baron_throw8  ] { ai_face(); };
void() baron_throw8  = [$smack6,  baron_throw9  ] { ai_face(); };
void() baron_throw9  = [$smack5,  baron_throw10 ] { ai_face(); };
void() baron_throw10 = [$smack4,  baron_throw11 ] { ai_face(); };
void() baron_throw11 = [$smack3,  baron_throw12 ] { ai_face(); };
void() baron_throw12 = [$smack2,  baron_throw13 ] { ai_face(); };
void() baron_throw13 = [$smack1,  baron_run     ] { ai_face(); };

void() baron_smack1  = [$smack1,  baron_smack2  ] { ai_charge(2); };
void() baron_smack2  = [$smack2,  baron_smack3  ] { ai_charge(2); };
void() baron_smack3  = [$smack3,  baron_smack4  ] { ai_charge(2); };
void() baron_smack4  = [$smack4,  baron_smack5  ] { ai_charge(2); };
void() baron_smack5  = [$smack5,  baron_smack6  ] { ai_charge(2); };
void() baron_smack6  = [$smack6,  baron_smack7  ] { ai_charge(2); };
void() baron_smack7  = [$smack7,  baron_smack8  ] { ai_charge(2); };
void() baron_smack8  = [$smack8,  baron_smack9  ] { ai_charge(2); };
void() baron_smack9  = [$smack9,  baron_smack10 ] { ai_charge(12); baron_fist(); };
void() baron_smack10 = [$smack10, baron_smack11 ] { ai_charge(2); };
void() baron_smack11 = [$smack11, baron_smack12 ] { ai_charge(2); };
void() baron_smack12 = [$smack12, baron_run     ] { ai_charge(2); };

void() baron_fasts1  = [$smack1,  baron_fasts2  ] { ai_charge(6); };
void() baron_fasts2  = [$smack3,  baron_fasts3  ] { ai_charge(4); };
void() baron_fasts3  = [$smack6,  baron_smack7  ] { ai_charge(2); };

void() baron_melee = { // [FUNCTION]
    if (self.state) {
		self.state = FALSE;
        if (self.level) self.think = baron_fasts1;
        else self.think = baron_smack1;
    } else {
		self.state = TRUE;
        if (self.level) self.think = baron_fasts1;
        else self.think = baron_blam1;
	}

    sound(self,CHAN_WEAPON,"nehahra/baron/woosh.wav",1,ATTN_NORM);
    self.think();
};


// Returns TRUE if baron can summon an earth elemental.  This only checks if summoning is allowed; nothing gets spawned here.
float() BaronGolem_Check = { return (self.minion_count < ceil(skill / 2) + 1); };

void(vector start, vector dir, float sped) Baron_Ice_Launch = { // [FUNCTION]
    Ice_Launch (start, dir, sped);
    newmis.delay = time + 5;
    newmis.dmg = 18;    //random() * 5 + 15;
};

void() Baron_Ice = { // [FUNCTION]
    local vector org, dir, err, base;
    local float loop;

    sound(self,CHAN_WEAPON,"drake/imp/shard.wav",1,ATTN_NORM);
    err = '6 4.5 0';     // arctan(err) = '0.105 0.0787 0'.
    loop = random() * 3 + 6;
    base = self.enemy.origin;
    makevectors(self.angles);
    org = self.origin + v_forward*16 + v_right*2 + v_up*20;
    base = normalize (base - self.origin);  // Like enforcers.
    while (loop > 0) {
        loop = loop - 1;
        if (!loop) err = '0 0 0';  // Last shot in loop uses unaltered velocity.
        dir = Maim_Scatter (base,err);
        Baron_Ice_Launch(org,dir,((random() * 100) + 830));
    }
};

void() Earth_Touch = { // [FUNCTION]
    if (Reflected()) return;

    if (other.takedamage) {
        spawn_touchblood (other,self,self.dmg);
        T_Damage(other,self,self.owner,self.dmg,DAMARMOR);
    } else {
        spawn_touchblood(other,self,self.dmg);     // Rock chunks.
        sound(self,CHAN_AUTO,"drake/baron/e_hit.wav",1,ATTN_NORM);
    }
    remove(self);
};

void(vector start, vector dir, float sped) Earth_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master       = newmis.owner      = self;
	newmis.classgroup = CG_PROJALL;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "earth";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity_x  = crandom() * 500;
    newmis.avelocity_y  = crandom() * 500;
    newmis.avelocity_z  = crandom() * 500;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = random() * 5 + 40;
    newmis.dest         = dir;
    newmis.touch        = Earth_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;
    if (random() < 0.5) setmodel(newmis, "progs/hipnotic/rubble1.mdl");
    else setmodel(newmis, "progs/hipnotic/rubble3.mdl");

    setsize (newmis, '0 0 0', '0 0 0');
    setorigin(newmis, start);
};

// Shoots a spray of rock chunks at the enemy.
void() Baron_Earth = { // [FUNCTION]
    local vector org, dir, err, base;
    local float loop;

    sound(self,CHAN_WEAPON,"drake/misc/wallbrk.wav",1,ATTN_NORM);
    err = '6 6 0';
    loop = random() * 3 + 5;
    base = self.enemy.origin;
    makevectors(self.angles);
    org = self.origin + v_forward*16 + v_right*2 + v_up*20;
    base = normalize (base - self.origin);  // Like enforcers.
    while (loop > 0) {
        loop = loop - 1;
        if (!loop) err = '0 0 0';  // Last shot in loop uses unaltered velocity.
        dir = Maim_Scatter (base, err);
        Earth_Launch (org,dir,((random() * 100) + 830));
    }
};

void() Geyser_Erupt = { // [FUNCTION]
    local   entity  swap;
    local   vector  org, dir, trig;
    local   float   loop, sped, ang, qcos, qsin;

	// Trace down to find endpoint...In case the ground was moved or deleted,
    traceline (self.origin + '0 0 1', self.origin - '0 0 2047', TRUE, self);
    if (trace_fraction == 1) return; // No ground to erupt from.
    org = trace_endpos + '0 0 1';
    setorigin(self, org);

    T_RadiusDamage(self, self.owner, 60, world, DAMAGEALL);
    sound(self,CHAN_WEAPON,"drake/misc/wallbrk.wav",1,ATTN_NORM);
	ShockWave(self.origin, RING_QUAKE, 5, "progs/drake/s_wave.spr",FALSE);

	// Do rock spray from below.
    swap = self;
    self = self.owner;
    loop = random() * 3 + 5;
    while (loop > 0) {
        // Find cosine and sine of offset angle.
        ang = random() * 30 + 60;   // 60-90 degrees, 90 is straight up. 
        trig = CoSine(ang);
        qcos = trig_x;
        qsin = trig_y;
        dir = '0 0 0';
        dir_y = random() * 360;
        makevectors(dir);
        dir = (v_forward * qcos) + (v_up * qsin);
        sped = random() * 100 + 500;    //830;
        Earth_Launch (org, dir, sped);
        newmis.movetype     = MOVETYPE_TOSS;
        newmis.master       = newmis.owner      = self;
        loop = loop - 1;
    }
    self = swap;
    remove (self);
};

void() Geyser_NextThink = { // [FUNCTION]
    self.nextthink = time + 0.05;
    if (self.delay <= self.nextthink) {
        self.nextthink  = self.delay;
        self.think      = Geyser_Erupt;
    }
};

void() Geyser_Think = { // [FUNCTION]
    local vector spot;

    self.distance = self.distance + 50;
    spot = self.oldorigin + (self.movedir * self.distance);
    spot_z = self.origin_z;
    traceline (spot + '0 0 1', spot - '0 0 1027', TRUE, self);
    if (trace_fraction < 1) ShockWave(trace_endpos + '0 0 2', RING2_QUAKE, 3, "progs/drake/s_wave2.spr",TRUE);
    Geyser_NextThink();
};

void() Baron_Geyser = { // [FUNCTION]
	// If target is within 'droptofloor' distance, spawn a geyser at his feet.
    traceline (self.enemy.origin, self.enemy.origin - '0 0 256', TRUE, self);
    if (trace_fraction == 1) return;

    newmis = spawn();
    setorigin(newmis, trace_endpos + '0 0 1');
    newmis.owner = self;
    newmis.enemy = self.enemy;
    newmis.oldorigin = self.origin;
    newmis.movedir = normalize (self.enemy.origin - self.origin);
    newmis.distance = 0;
    newmis.delay = vlen(self.enemy.origin - self.origin) / 1000 + time;
    newmis.think = Geyser_Think;
    SUB_ThinkImmediate (newmis, Geyser_NextThink);
};

// Lifts all enemies and their missiles in front of baron up into the air.
void() Baron_Air = { // [FUNCTION]
    local entity head;
    local vector ang;
    local float damage;
    local float str;
    local float hit;

	// Update:  Hit self.enemy, his allies, and their missiles.  Old code hit self.enemy only.
    head = nextent (world);
    while (head) {
        if (head.modelindex)
        if (head.solid != SOLID_NOT)
        if (head.touch != TouchGib) { // Hack to prevent heads from flying.
            if (head.flags & FLx_CREATURE)
                hit = 1;
            else if (IsMissile(head))
                hit = 2;
            else
                hit = 0;

            if (hit) {
                if (infront(head) && visible(head)) {
                    str = random();
                    damage = str * 5 + 10;
                    if (hit == 1) {
                        if (!Ally_Check(head,self)) {
                            ang = '0 0 0';
                            ang_y = random() * 360;
                            ang = vectoangles(ang);
                            ang_z = str * 250 + 250;
                            head.velocity = ang;
                            SUB_RemoveFlags(head,FL_ONGROUND);
                        } else hit = 0;
                    } else { // Check owner for missile control, not who launched.
                        if (!Ally_Check (head.owner,self)) ReflectMissile(head.owner,head,TRUE); // just go straight up!
                        else hit = 0;
                    }
                    if (hit) {
                        Particle_Gust(head);   // Show some dust.
                        T_Damage(head,self,self,damage,DAMARMOR);
                        sound(head,7,"drake/skullwiz/push.wav",1,ATTN_NORM);
                    }
                }
            }
        }
        head = nextent (head);
    }
};

// Replaced lightning bolt with plasma/ball lightning.
void(vector st) M_FireBaronPlasma = { // [FUNCTION]
    local vector p1, p2, dir;
    local entity targ;

    targ = world;
    makevectors(self.angles);
    p1 = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    p2 = Aimpoint (self.enemy);
    dir = Maim_LineEx(p1,p2,1000,targ,'0 0 0',1);
    self.effects = self.effects | EF_MUZZLEFLASH;
    RyuPlasma_Launch(p1,dir,1000,60);
};

void() baron_slam = { // [FUNCTION]
    local   vector  org, org2, dir;

    makevectors(self.angles);
    org = self.origin + (v_forward*32) + (v_right*12);
    traceline (org, org - '0 0 42', TRUE, self);
    org2 = trace_endpos;
    if ((trace_fraction < 1) || (pointcontents(org2) == CONTENT_SOLID)) {
        sound(self,CHAN_WEAPON,"drake/weapons/fwalltap.wav",1,ATTN_NORM);
        if (self.level == BARON_FIRE) {
			ShockWave(org2 + '0 0 4', RING_FIRE, 2, "progs/drake/s_wave.spr",TRUE);
            self.effects = self.effects | EF_MUZZLEFLASH;
            org = org + self.view_ofs;
            org2 = self.origin + self.view_ofs;
            dir = self.enemy.origin + self.enemy.view_ofs;
            dir = Maim_LineEx(org2,dir,SPEED_FIREWALL,world,'0 0 0',1);
            Firewall_Spawn(org,dir,self.enemy,FALSE);
            newmis.dmg = 120;
        } else {
            self.waitmax = time + 5;    // Don't spam.
            if (self.level == BARON_WATER)
                IceMine_Spawn (self.dest);
            else if (self.level == BARON_AIR)
                Tornado_Spawn (self.dest);
            else {
				ShockWave(org2 + '0 0 4', RING_QUAKE, 5, "progs/drake/s_wave.spr",FALSE);
				Quake_Spawn(self,800,6,org,FALSE,3,VEC_QUAKE);
                Baron_Geyser();
            }
        }
    }
};

void() baron_slam1  = [$smack1,  baron_slam2  ] { sound(self,CHAN_WEAPON,"nehahra/baron/woosh.wav",1,ATTN_NORM); ai_charge(2); self.dest = self.enemy.origin; };
void() baron_slam2  = [$smack2,  baron_slam3  ] { ai_charge(2); };
void() baron_slam3  = [$smack3,  baron_slam4  ] { ai_charge(2); };
void() baron_slam4  = [$smack4,  baron_slam5  ] { ai_charge(2); };
void() baron_slam5  = [$smack5,  baron_slam6  ] { ai_charge(2); };
void() baron_slam6  = [$smack6,  baron_slam7  ] { ai_charge(2); };
void() baron_slam7  = [$smack7,  baron_slam8  ] { ai_charge(2); };
void() baron_slam8  = [$smack8,  baron_slam9  ] { ai_charge(2); };
void() baron_slam9  = [$smack9,  baron_slam10 ] { ai_charge(12); baron_slam(); };
void() baron_slam10 = [$smack10, baron_slam11 ] { ai_charge(2); };
void() baron_slam11 = [$smack11, baron_slam12 ] { ai_charge(2); };
void() baron_slam12 = [$smack12, baron_run    ] { ai_charge(2); };

void() baron_cast1  = [$magica7,  baron_cast2  ] { sound(self,CHAN_WEAPON,"nehahra/baron/woosh.wav",1,ATTN_NORM); ai_face(); self.dest = self.enemy.origin; };
void() baron_cast2  = [$magica6,  baron_cast3  ] { ai_face();if (self.level == BARON_FIRE) self.nextthink = time + 0.2; };
void() baron_cast3  = [$magica5,  baron_cast4  ] { ai_face();if (self.level == BARON_FIRE) self.nextthink = time + 0.2; };
void() baron_cast4  = [$magica4,  baron_cast5  ] { ai_face();if (self.level == BARON_FIRE) self.nextthink = time + 0.2; };
void() baron_cast5  = [$magica3,  baron_cast6  ] { ai_face();
    if (self.level == BARON_WATER) RainStorm();
    else if (self.level == BARON_FIRE) BaronFireworks();
    else if (self.level == BARON_EARTH) {
        if (BaronGolem_Check ()) {
            //if (!SpawnMonster_Attack (self, CT_MONGOLEM)) { // TODO
            //    if (visible(self.enemy)) SpawnMonster (self, self.origin, CT_MONGOLEM, EntryPoint_Fan);
            //}
		}
    } else { // Lightnign bolt from the sky.
        LightZero_Set (20, 1, -4);
		Thunderstrike_Ex(self,self.dest,80);
    }
    self.dest = self.enemy.origin;
};
void() baron_cast6  = [$magica2,  baron_cast7  ] { ai_face(); };
void() baron_cast7  = [$magica1,  baron_run    ] { ai_face(); };

void() baron_point1  = [$point1,  baron_point2  ] { ai_face();
	// Set fireball counter.
    if (self.level) { // Rapture/Unforgiven elemental bosses.
        if (self.level == BARON_FIRE)   // 8/24/10:  Emulate the cyberdemon.
            self.shots_max = 3;     //random() * 4;
        else
            self.shots_max = 1;
    } else self.shots_max = random() * (skill + 1) / 2; // Nehahra/Drake version.  1 on Easy/Normal, 1-2 on Hard/NM.
    self.shots_left = self.shots_max = ceil(self.shots_max);
};
void() baron_point2  = [$point2,  baron_point3  ] { ai_face(); };
void() baron_point3  = [$point3,  baron_point4  ] { ai_face(); };
void() baron_point4  = [$point4,  baron_point5  ] { ai_face(); };
void() baron_point5  = [$point5,  baron_point6  ] { ai_face(); if (self.level == BARON_AIR) sound(self,CHAN_WEAPON,"rogue/plasma/fire.wav",1,ATTN_NORM); };
void() baron_point6  = [$point6,  baron_point7  ] { ai_face();
    if (self.level == BARON_EARTH)
        Baron_Earth();  //'16 2 20');
    else if (self.level == BARON_AIR)
        M_FireBaronPlasma ('16 2 20');
    else if (self.level == BARON_WATER)
        Baron_Ice();    //'16 2 20');
    else
        M_FireKnight('16 2 20', FALSE);
    self.dest = self.enemy.origin;
    self.shots_left = self.shots_left - 1;
    if (self.shots_left > 0)
        if (self.enemy)
            if (visible (self.enemy)) { // Got more shots left, and target is still in sight.
                self.think = baron_point3;
                return;
            }
    self.shots_left = self.shots_max = 0;   // Done firing.
};
void() baron_point7  = [$point7,  baron_point8  ] { ai_face(); };
void() baron_point8  = [$point8,  baron_point9  ] { ai_face(); };
void() baron_point9  = [$point9,  baron_point10 ] { ai_face(); };
void() baron_point10 = [$point10, baron_point11 ] { ai_face(); };
void() baron_point11 = [$point11, baron_run     ] { ai_face(); };

//- - - - - - - - -
//void(float offset) hknight_shot;

// SoE/Rapture:  Don't use hknight_shot like in Drake because of the
// various changes required for Tronyn's modified knights.
// The basic shot code is otherwise the same as the hell knights'.
void(float offset) baron_shot = { // [FUNCTION]
    local vector offang, org, vec;
    
    offang = vectoangles (self.enemy.origin - self.origin);
    offang_y = offang_y + offset * 6;
    makevectors(offang);
    org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
    vec = normalize(v_forward);
    vec_z = 0 - vec_z + (random() - 0.5)*0.1;
    // vec = Maim_Scatter (vec, '0 0 0'); // Added for invisibility.

	// PM:  No need to check classnames like Bane, hell knight, hell lord, etc.
    if (self.level == BARON_EARTH) {
        launch_projectile(org,vec,NO_SPIN,CT_PROJ_SNG,SPEED_PLAYSPIKE);
        // Old damage was 15, but use superspike's 18.
        sound(self,CHAN_WEAPON,"weapons/spike2.wav",1,ATTN_NORM);
    } else if (self.level == BARON_WATER) {
        Baron_Ice_Launch(org,vec,600);
        sound(self,CHAN_WEAPON,"drake/baron/icefire.wav",1,ATTN_NORM);
    } else { // Use offset as speed.
        if (self.level == BARON_FIRE) offset = 500;
        else offset = 300;
        self.attack_speed = SPEED_HKSPIKE + ( skill * SPEED_HKSKILL);
        launch_projectile(org,vec,NO_SPIN,CT_PROJ_HKN,self.attack_speed);
        if (self.level == BARON_FIRE) newmis.dmg  = 20;
        sound(self,CHAN_WEAPON,"hknight/attack1.wav",1,ATTN_NORM);
    }
};

void() baron_air1  = [$magica4,  baron_air2     ] { ai_face();
    Baron_Air();
    self.waitmax = time + 1;    // To prevent unfair lightning strike combo.
};
void() baron_air2  = [$magica5,  baron_air3     ] { ai_face(); };
void() baron_air3  = [$magica6,  baron_magica7  ] { ai_face(); };

// Use triangle pattern instead of Nehahra's off-center one.
// Me: 0, -1 1, -2 0 2.  Neh: 0, -1 -2, 0 1.
void() baron_magica1  = [$magica1,  baron_magica2  ] { ai_face(); };
void() baron_magica2  = [$magica2,  baron_magica3  ] { ai_face(); };
void() baron_magica3  = [$magica3,  baron_magica4  ] { ai_face();
    if (self.level == BARON_AIR)
        self.think = baron_air1;
};
void() baron_magica4  = [$magica4,  baron_magica5  ] { ai_face(); baron_shot(0); };
void() baron_magica5  = [$magica5,  baron_magica6  ] { ai_face(); baron_shot(-1); baron_shot(1); };
void() baron_magica6  = [$magica6,  baron_magica7  ] { ai_face(); baron_shot(-2); baron_shot(2);
    if (self.level)
        baron_shot(0);  // Extra shot for boss.
};
void() baron_magica7  = [$magica7,  baron_run      ] { ai_face(); };

void() baron_magic = { // [FUNCTION]
    if (self.level) {
        local   float   r;
        local   float   opt;

        opt = 2;
        if (self.level == BARON_AIR) {
            local   float   add, yes;

            opt = 1;
            add = 1;
            yes = 0;

            if (!super_active)
                if (self.waitmax < time)    // Don't combo from gust.
                    if (random() < 0.5) //0.33)
                        { baron_slam1();  return; }

            if (self.waitmax < time)
                if (UpIsSky (self.enemy.origin,self.enemy))
                    opt = opt + 1;
            if (self.waterlevel < 2)
                { add = 0;  opt = opt + 1;  yes = 1; }

            r = random() * opt + add;
            if ((r <= 1) && yes)
                baron_point1();
            else if (r <= 2)
                baron_magica1();
            else
                baron_cast1();
            return;
        }
        if (self.level == BARON_WATER) {
            opt = 3;
            if (!super_active)
                opt = opt + 1;

            r = random() * opt;
            if (r <= 1)
                baron_point1();
            else if (r <= 2)
                baron_magica1();
            else if (r <= 3)
                baron_slam1();
            else
                baron_cast1();
            return;
        }
        if ((self.level == BARON_FIRE) || (self.level == BARON_EARTH)) {
            if (self.waitmax < time) {
                if (!super_active)
                    if (random() < 0.5) //0.33)
                        if ((self.level != BARON_EARTH) || BaronGolem_Check ()) { baron_cast1();  return; }
                if (self.level == BARON_EARTH) {
                    if (QuakeHurts(self.enemy)) opt = opt + 1; // Enemy hurt by quake?
                } else {
                    if (M_FirewallCheck()) opt = opt + 1;
                }
            }

            r = random() * opt;
            if (r <= 1)
                baron_point1();
            else if (r <= 2)
                baron_magica1();
            else
                baron_slam1();
            return;
        }
    }

	// Nehahra style baron, with some Drake stuff.
	// SoE:  Barons need a special attack to make them unique among Banes' army.
	// Update 5/3/2010:  Keep nsoe barons for Drake.
    if (random() < 0.333)
        baron_point1();    // Fireball
    else
        baron_magica1();   // Classic missile spray
};

//  NOTE:  Much of the jump code was cut-and-paste from 'demon.qc'.

// Note:  Drake adds a leaping slash attack for the baron, similar to the
// Barbarian Leap Attack skill from Diablo 2.  Thus, the jump animation
// sequence as a bit different than Nehahra.
void() baron_jumptouch;

void() baron_jump1  = [$jump6,  baron_jump2  ] { ai_face(); self.waitmin = 5; };
void() baron_jump2  = [$jump5,  baron_jump3  ] { ai_face(); };
void() baron_jump3  = [$jump4,  baron_jump4  ] {
    ai_face();
// Not in Nehahra, but I like it so it stays.
    if (range(self.enemy) == RANGE_MELEE) {
        self.think = baron_melee;   // Abort jump and smackdown enemy.
    } else if (!FacingIdeal()) {
        // Not facing the right way... delay the jump or abort.
        self.waitmin = self.waitmin - 1;
        if (self.waitmin > 0)
            self.think = baron_jump3;
        else
            self.think = baron_magic;     // Abort jump and fling some magic.
    }
};
void() baron_jump4  = [$jump3,  baron_jump5  ] {
    local   float   sped, up;

	// Update:  Use Nehahra's values.
	sped  = 400;    // Player = 320.
	up    = 300;    // Player = 270.
	// Note:  If player cannot control his jumping, neither should humanoid NPCs.

    ai_face();

    // Make the jump;
    self.touch = baron_jumptouch;
    makevectors(self.angles);
//    self.origin_z   = self.origin_z + 1;
    self.velocity   = v_forward * sped;
    self.velocity_z = self.velocity_z + up;
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.nextthink = time + 0.2;
};
void() baron_jump5  = [$jump2,  baron_jump6  ] { self.nextthink = time + 0.2; };
void() baron_jump6  = [$jump1,  baron_jump7  ] { self.nextthink = time + 3; };
void() baron_jump7  = [$jump4,  baron_jump4  ] {};

void() baron_land1  = [$jump4,  baron_land2  ] {};
void() baron_land2  = [$jump5,  baron_land3  ] {};
void() baron_land3  = [$jump6,  baron_run    ] {};

// Jump initiated by trigger.
void() baron_tjump  = [$jump3,  baron_jump5  ] {
    self.touch = baron_jumptouch;
    // velocity and onground assumed to be set by jump trigger.
    self.nextthink = time + 0.2;
};

void() baron_jumptouch = { // [FUNCTION]
    if (self.health <= 0) return;

	// PM:  Check for leaping slash attack.
    if (self.frame != $blam6 )
    if (other)
    if (other == self.enemy) { // Hurt only the intended target.
        if ( vlen(self.velocity) > 300 ) {
            local   float   ldmg;

            if (self.level)
                ldmg = 40 + 10*random();    // Boss version.
            else
                ldmg = 20 + 10*random();

			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
            T_Damage(other, self, self, ldmg,DAMARMOR);
            if (self.health <= 0) return;     // PM:  Killed by thorns (empathy shields).

            if ((self.frame == $jump2 ) || (self.frame == $jump3 )) {   // Got an early hit.
                self.nextthink = time + 3;
                self.think = baron_jump7;
            }
            SpawnMeatSpray(self, self.enemy,crandom() * 150); // Throw 2 pieces of meat.
			SpawnMeatSpray(self, self.enemy,crandom() * 150);
            self.frame = $blam6;  // Go to a stab frame.
            sound(self,CHAN_WEAPON,"drake/weapons/axhit.wav",1,ATTN_NORM);
        }
    }

    if (!checkbottom(self)) {
        if (self.flags & FL_ONGROUND)
        {    // jump randomly to not get hung up
			//dprint ("popjump\n");
            self.touch = SUB_Null;
            self.think = baron_jump4;
            self.nextthink = time + 0.1;
        }
        return;    // not on ground yet
    }

    self.touch = SUB_Null;
    if (self.frame == $blam6 ) {   // We smacked the target with the leaping slash.
        self.state = TRUE;      // Follow up with fist smash.
        self.think = baron_blam7;
    } else {
        self.think = baron_land1;
		// PM:  If we landed close to our enemy, go directly to melee.
        if (self.enemy)
        if (CanDamage (self.enemy, self))
        if (InMeleeRange (100)) {
            sound(self,CHAN_WEAPON,"nehahra/baron/woosh.wav",1,ATTN_NORM);
            self.state = TRUE;
            self.think = baron_blam6;
        }
    }
    self.nextthink = time + 0.1;
};

// Ripped from Nehahra's ai2_tracetoss, adapted to Drake.
float(vector ang, float sped, vector add) baron_tracejump = { // [FUNCTION]
    local   vector  vel, end;
    local   float   pc;

    makevectors(ang);
    vel = (v_forward * sped) + add;
	TraceBallistic (self.origin,vel,FALSE,self,3,self.origin,MOVETYPE_TOSS); // Nehahra engine had a builtin 'tracetoss' function.  Here, use my QC version.  It was made for projectiles, but it'll do.
    end = trace_endpos;
    if (self.enemy)
        if (trace_ent)
            if (trace_ent != self.enemy)
                if (trace_ent.classname != self.classname) return FALSE;   // Hit something, but not the target.

    if (self.enemy.origin_z - end_z > 150) return FALSE;   // Too low.
    traceline (end, end - '0 0 400', FALSE, self);
    if (trace_fraction == 1) return FALSE;   // Can't find ground.
    pc = pointcontents (trace_endpos);
    if (pc <= CONTENT_WATER) return FALSE;   // Jumped into water or worse.
    return TRUE; // Go!
};

void() baron_missile = { // [FUNCTION]
    if (!(self.spawnflags & BSF_NO_JUMP))
        if (range(self.enemy) != RANGE_MELEE)   // range check not in Nehahra.
            if (random() < 0.3)     // Me: 0.2, Nehahra/Rapture: 0.3.
                if (baron_tracejump (self.angles, 400, '0 0 300')) { baron_jump1();  return; }

    baron_magic();
};

void() baron_paina1  = [$paina3,  baron_paina2  ] {};
void() baron_paina2  = [$paina2,  baron_paina3  ] {};
void() baron_paina3  = [$paina1,  baron_run     ] {};

void() baron_painb1  = [$painb1,  baron_painb2  ] {};
void() baron_painb2  = [$painb2,  baron_painb3  ] {};
void() baron_painb3  = [$painb3,  baron_painb4  ] {};
void() baron_painb4  = [$painb4,  baron_run     ] {};

void(entity inflictor, entity attacker, float damage) baron_pain = {
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;
    sound(self,CHAN_VOICE, "nehahra/baron/bpain1.wav",1,ATTN_NORM);
    if (self.touch == baron_jumptouch)
        return;     // can't flinch while jumping
    if ((random() * 30) > damage)   // Me: 40, Neh: 30.  I'll go 30.
        return;         // didn't flinch
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    if (random() < 0.4)     // Me: 0.5, Neh: 0.4.
        baron_paina1();
    else
        baron_painb1();

    attacker = attacker;    // Appease FrikQcc.
};

void() baron_diea1  = [$diea1,  baron_diea2  ] {
	self.reviveframestart = $diea6;
	self.reviveframeend = $diea1;
};
void() baron_diea2  = [$diea2,  baron_diea3  ] { ai_forward(2); monster_check_gib(); self.solid = SOLID_NOT; };
void() baron_diea3  = [$diea3,  baron_diea4  ] { ai_back(2); monster_check_gib(); };
void() baron_diea4  = [$diea4,  baron_diea5  ] { ai_back(6); };
void() baron_diea5  = [$diea5,  baron_diea6  ] { ai_back(2); monster_death_postcheck(); };
void() baron_diea6  = [$diea6,  baron_diea6  ] { ai_back(8); monster_deadbody_check(); };

void() baron_dieb1  = [$dieb1,  baron_dieb2  ] {
	self.reviveframestart = $dieb6;
	self.reviveframeend = $dieb1;
};
void() baron_dieb2  = [$dieb2,  baron_dieb3  ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() baron_dieb3  = [$dieb3,  baron_dieb4  ] { ai_forward(7); monster_check_gib(); };
void() baron_dieb4  = [$dieb4,  baron_dieb5  ] {};
void() baron_dieb5  = [$dieb5,  baron_dieb6  ] { ai_forward(20); monster_death_postcheck(); };
void() baron_dieb6  = [$dieb6,  baron_dieb6  ] { ai_forward(2); monster_deadbody_check(); };

void() baron_die = {
    monster_death_precheck();

    // regular death
    if (!self.gibbed) {
        sound(self,CHAN_VOICE, "drake/baron/death.wav",1,ATTN_NORM);
        if (random() < 0.5)     // Nehahra uses 0.3.
            baron_diea1();
        else
            baron_dieb1();
    }
};

void() monster_baron_precache = { // Baron files are derived from the Rapture pack.
    precache_model ("progs/drake/baron.mdl");
    precache_model ("progs/drake/h_baron.mdl");
    precache_model ("progs/drake/k_ball.mdl");
    precache_model ("progs/k_spike.mdl");
	precache_model (MODEL_PROJ_HKN);
    precache_sound("nehahra/baron/bpain1.wav");
    precache_sound("drake/baron/death.wav");
    precache_sound("drake/baron/fireball.wav");
    precache_sound("nehahra/baron/idle.wav");      // Win only.
    precache_sound("nehahra/baron/sight.wav");
    precache_sound("nehahra/baron/smash.wav");
    precache_sound("nehahra/baron/woosh.wav");
    precache_sound("hknight/attack1.wav");
    precache_sound("hknight/idle.wav");
    precache_sound("hknight/hit.wav");    // used by C code, so don't sound2
    precache_sound("drake/weapons/sheath.wav");
    precache_sound("drake/weapons/unsheath.wav");
    precache_model ("progs/drake/ice.mdl"); // Elemental boss barons, for Rapture maps.
    precache_model ("progs/drake/plasma.mdl");
    precache_model ("progs/custents/rubble1.mdl");
    precache_model ("progs/custents/rubble2.mdl");
    precache_model ("progs/custents/rubble3.mdl");
    precache_model ("progs/drake/s_wave2.spr");
    precache_model ("progs/drake/smoke.mdl");
    precache_sound("drake/bane/thunder.wav");    // Lightning Storm
    precache_sound("drake/baron/e_hit.wav");
    precache_sound("drake/baron/icefire.wav");
    precache_sound("drake/baron/tornado.wav");   // Tornado
    precache_sound("drake/dragon/icehit.wav");
    precache_sound("hipnotic/weapons/mjolhit.wav");
    precache_sound("drake/imp/shard.wav");
    precache_sound("hipnotic/misc/quake.wav");
    precache_sound("hipnotic/misc/quakeend.wav");
    precache_sound("drake/misc/wallbrk.wav");
    precache_sound("zerstorer/trog/bigboom.wav");
    precache_sound("rogue/plasma/explode.wav");
    precache_sound("rogue/plasma/fire.wav");
    precache_sound("drake/skullwiz/push.wav");
    precache_sound("drake/weapons/fwall.wav");
    precache_sound("drake/weapons/fwallhit.wav");
    precache_sound("drake/weapons/fwalltap.wav");
    precache_sound("drake/weapons/freeze.wav");  // Ice Mine
    precache_model ("progs/drake/akarrow.mdl");
    precache_model ("progs/drake/hk_golem.mdl");
    precache_model ("progs/drake/h_hkolem.mdl");
    precache_model ("progs/drake/st_gib1.mdl");
    precache_model ("progs/drake/st_gib2.mdl");
    precache_model ("progs/drake/st_gib3.mdl");
    precache_model ("progs/hipnotic/rubble1.mdl");
    precache_model ("progs/hipnotic/rubble3.mdl");
    precache_sound("hknight/grunt.wav");
    precache_sound("hknight/slash1.wav");
    precache_sound("drake/misc/wallbrk.wav");
    precache_sound("shambler/smack.wav");
    precache_sound("drake/weapons/mirv1.wav");   // In case MIRV is forbidden.
    precache_model ("progs/drake/s_wave.spr");
    precache_model ("progs/quoth/bigexp.spr");
    precache_model ("progs/drake/s_fancy.spr");
};

// --> QUAKED monster_baron (1 0 0) (-16 -16 -24) (16 16 40) Ambush x Nojump
void() monster_baron = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	if (self.minion_name == "") {
        self.minion_name = "monster_golem";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }
    self.mdl = "progs/drake/baron.mdl";
    self.sight_sound = "nehahra/baron/sight.wav";
	self.idle_sound = "hknight/idle.wav";
	self.exactskin = 0;
    if (self.level) {
        self.purse_x    = (self.level & 3) + 5;
		self.bossflag = TRUE;
		// Set default health for Rapture's elemental barons.
		if (self.level == BARON_WATER) {
			if (self.health < 1) self.health = 1000;
			if (self.deathstring == "") self.deathstring = " was liquidated by the Water Baron\n";
		} else if (self.level == BARON_FIRE) {
			if (self.health < 1) self.health = 1400;
			if (self.deathstring == "") self.deathstring = " was scorched by the Fire Baron\n";
		} else if (self.level == BARON_EARTH) {
			if (self.health < 1) self.health = 1900;
			if (self.deathstring == "") self.deathstring = " was buried by the Earth Baron\n";
			self.mass = MASS_SUPER;   // Is one with the earth.
		} else if (self.level == BARON_AIR) {
			if (self.health < 1) self.health = 2200;
			if (self.deathstring == "") self.deathstring = " was blown away by the Wind Baron\n";
		}
		if (skill >= 1) self.th_checkattack = BaronBossCheckAttack; // Only on hard??
    } else {
        if (self.health < 1) self.health = 500;
		if ( (random () < 0.500) ) {
			if (self.deathstring == "")  self.deathstring = " became a Baron's thrill kill\n";
		} else {
			if (self.deathstring == "")  self.deathstring = " was ruled by a Baron\n";
		}
    }
    self.gibhealth = -50; // Nehahra pegs gibhealth at -50.  Was -40 before I saw Nehahra source.
    if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
    self.headmdl   = "progs/drake/h_baron.mdl";
    self.mass       = MASS_HEAVY; // Really big, buff badass human.
    self.th_stand   = baron_stand;
    self.th_walk    = baron_walk;
    self.th_run     = baron_run;
    self.th_melee   = baron_melee;
	self.meleerange = 100;
	self.meleerangez = 48;
    self.th_missile = baron_missile;
    self.th_pain    = baron_pain;
    self.th_die     = baron_die;
    self.th_jump    = baron_tjump;
    self.blockudeath = FALSE; // Humanoid death sound
	self.hittype = HIT_METAL;
    self.state      = FALSE; // Use sword as the first attack.
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.classtype = CT_MONBARON;
	self.classgroup = CG_DCAPTAIN;
	self.classmove = MON_MOVEWALK;
    monster_start();
};

void() monster_baron_fire = {
	self.level = BARON_FIRE;
	self.classname = "monster_baron";
	monster_baron();
};

void() monster_baron_wind = {
	self.level = BARON_AIR;
	self.classname = "monster_baron";
	monster_baron();
};

void() monster_baron_earth = {
	self.level = BARON_EARTH;
	self.classname = "monster_baron";
	monster_baron();
};

void() monster_baron_water = {
	self.level = BARON_WATER;
	self.classname = "monster_baron";
	monster_baron();
};