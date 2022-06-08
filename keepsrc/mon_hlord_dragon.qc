/*
==============================================================================

DRAGON (Rogue)

==============================================================================
*/

// dragon.qc

$base dragrest
$skin dragskin

$frame dragon6

$frame drgfly01 drgfly02 drgfly03 drgfly04 
$frame drgfly05 drgfly06 drgfly07 drgfly08
$frame drgfly09 drgfly10 drgfly11 drgfly12 drgfly13

$frame drgtrn01 drgtrn02 drgtrn03 drgtrn04 drgtrn05 drgtrn06

$frame drgslh01 drgslh02 drgslh03 drgslh04 drgslh05 drgslh06
$frame drgslh07 drgslh08 drgslh09 drgslh10 drgslh11 drgslh12 drgslh13

$frame drgfir01 drgfir02 drgfir03 drgfir04 drgfir05
$frame drgfir06 drgfir07 drgfir08 drgfir09 drgfir10

$frame drgfix1a drgfix1b drgfix1c
$frame drgfix2a drgfix2b drgfix2c
$frame drgfix3a drgfix3b drgfix3c
$frame drgfix4a drgfix4b drgfix4c
$frame drgfix5a drgfix5b drgfix5c
$frame drgfix6a drgfix6b drgfix6c drgfix6d

$frame drgpan1a drgpan1b drgpan1c
$frame drgpan2a drgpan2b drgpan2c
$frame drgpan3a drgpan3b drgpan3c
$frame drgpan4a drgpan4b drgpan4c
$frame drgpan5a drgpan5b drgpan5c
$frame drgpan6a drgpan6b drgpan6c

$frame drgdth01 drgdth02 drgdth03 drgdth04 drgdth05 drgdth06
$frame drgdth07 drgdth08 drgdth09 drgdth10 drgdth11 drgdth12
$frame drgdth13 drgdth14 drgdth15 drgdth16 drgdth17 drgdth18
$frame drgdth19 drgdth20 drgdth21

//////////////////////////////////////
// Prototypes found in my 'ryu.qc'
float(float yaw, float dist) Wyrm_WalkMove;
void() ryu_sfx_fly;
//////////////////////////////////////
void() hlorddragon_fireball;
void() hlorddragon_melee1;

//////////////////////////////////////
// FIXME:  Use standard vars.
.float  hlorddragonPainSequence;
.vector hlorddragonLastVelocity;

void() hlorddragon_check_attack = {
    local   vector  vec;
    local   float   dot;

    if (self.dragonAttacking == TRUE) return;
    if (self.enemy.health < 1)
    {
        self.enemy = self.oldenemy;
        self.oldenemy = world;
        if (self.enemy.health < 1)
            self.enemy = world;
    }
    if (self.th_missile == SUB_Null)
        return;
    if (self.attack_finished > time)
        return;
// PM:  Moved enemy check up.
    if (self.enemy.flags & FL_NOTARGET)
        return;
    
    if (self.enemy == world)
        FindTarget ();
    else {
        makevectors (self.angles);
        vec = normalize (self.enemy.origin - self.origin);
        dot = vec * v_forward;
        if (dot > 0.3) {
            traceline (self.origin, self.enemy.origin, TRUE, world);
            if (trace_fraction == 1) {
                dot = vlen ( self.enemy.origin - self.origin );
                // dot was 350, but that was too much.
                if ((dot < 250) && !self.cnt) {
                    if (random() < 0.5)
                        self.cnt = 1;   // Use missile attack next time.
                    self.dragonAttacking = TRUE;
                    self.think = hlorddragon_melee1;
                    return;
                } else {
                    self.cnt = 0;
                    self.dragonAttacking = TRUE;
                    self.think = self.th_missile;
                }
            }
        }
    }
};

// ===================================
// dragon_untilt (Added by PM)
// ===================================
void() hlorddragon_untilt =
{
    if (self.angles_z != 0)
    {
        if (self.angles_z < -5)
            self.angles_z = self.angles_z + 5;
        else if (self.angles_z < 5)
            self.angles_z = 0;
        else //if (self.angles_z > 5)
            self.angles_z = self.angles_z - 5;
    }
};

// ===================================
// dragon_move 
// ===================================
void(float dist) hlorddragon_move = {
    local   vector  moveDir, moveAngles;
    local   float   leftTurn, rightTurn, turnOffset, onpath; // onpath is TRUE if flying toward path_corner.
    local   entity  oldEnemy, targ;       // Goal the dragon should aim/move toward.    

    if (self.health < 1) return; // PM:  Removed the remove statement.

    if (self.dragonAttacking == FALSE) hlorddragon_check_attack();
    oldEnemy = self.enemy;
    onpath = (self.movetarget.classname == "path_corner"); // Set the goal the dragon should seek this frame.
    if (onpath && self.classtype == CT_MONWYRM)
        targ = self.movetarget;
    else if (self.enemy) {
        if (self.enemy.health < 1)
            targ = world;
        else
            {targ = self.enemy; onpath = FALSE;}
    }
    else if (self.master)
        {targ = self.master; onpath = FALSE;}
    else if (onpath)
        targ = self.movetarget;
    else
        targ = world;
    self.goalentity = targ;

    if (self.dragonAttacking == FALSE) {
        if (targ) {   // Seeking a path_corner, enemy, or master...
            if (!onpath) {   // Dragon is seeking a target, not following a path.  Don't bother with fancy tilt code -- just untilt it.
                hlorddragon_untilt ();

                // Aim high above the target's head.
                temp_goal.origin = targ.origin;
                temp_goal.origin_z = temp_goal.origin_z + targ.maxs_z;
                setorigin (temp_goal, temp_goal.origin);

                self.enemy = temp_goal;
                if (!oldEnemy) {   // Following a master, not an enemy.
                    if (Wyrm_WalkMove (self.angles_y, dist)) {   // Direct movement successful, so stop here.
                        ai_face ();
                        self.enemy = oldEnemy;
                        return;
                    }
                }
                moveDir = self.origin;
                QC_MoveToGoal (dist);
                if (moveDir == self.origin) {
                    moveDir = self.origin;
                    Wyrm_WalkMove (self.angles_y, dist);
                    if (moveDir == self.origin)
                        if (QC_CloseEnough (dist))
                            ai_face ();
                }
                self.enemy = oldEnemy;
                return;
            }
            // Following a path.
            moveDir = targ.origin - self.origin;
            moveAngles = vectoangles (moveDir);
        } else { // No path or target, so fly forward.
            makevectors (self.angles);
            moveDir = v_forward;
            moveAngles = self.angles;
        }
        self.enemy = targ;
    } else { // Turn toward the enemy during an attack.
        moveDir = self.enemy.origin;
        if (targ)
            if (!onpath) moveDir_z = moveDir_z + self.enemy.maxs_z + 40; // If moving toward enemy, fly above its head.
        moveDir = moveDir - self.origin;
        moveAngles = vectoangles (moveDir);
    }
    
    turnOffset = self.angles_y - moveAngles_y;
    if (turnOffset != 0) {
        turnOffset = 180 - self.angles_y;
        leftTurn = anglemod (moveAngles_y + turnOffset) - 180;
        rightTurn = 180 - anglemod (moveAngles_y + turnOffset);
        
        if (leftTurn < 0)
            leftTurn = 360;
        else if (rightTurn < 0)
            rightTurn = 360;
    
		// PM:  yaw_speed already set at spawn time.
        if (rightTurn < 180) {
            if (self.yaw_speed < rightTurn)
                self.angles_y = self.angles_y - self.yaw_speed;
            else
                self.angles_y = moveAngles_y;
    
            if (rightTurn > 5) {
                self.angles_z = self.angles_z + 5;
                if (self.angles_z > 30) self.angles_z = 30;
            }
            turnOffset = rightTurn;
        } else  {
            if (self.yaw_speed < rightTurn)
                self.angles_y = self.angles_y + self.yaw_speed;
            else
                self.angles_y = moveAngles_y;

            if (leftTurn > 5) {
                self.angles_z = self.angles_z - 5;
                if (self.angles_z < -30) self.angles_z = -30;
            }
            turnOffset = leftTurn;
        }
    }
    else hlorddragon_untilt ();

	// PM:  Don't use setorigin because of clipping problems.
    if (moveDir_z > 5)
        ai_up (5);     //setorigin (self, self.origin + '0 0 5');
    else if (moveDir_z < -5) 
        ai_up (-5);    //setorigin (self, self.origin - '0 0 5');

    moveAngles = self.origin;
    Wyrm_WalkMove (self.angles_y, dist);
    if (moveAngles == self.origin) QC_MoveToGoal (dist);
    self.enemy = oldEnemy;
};

// attack A: start - walk1  stop - walk 5
void() hlorddragon_atk_a1=[$drgfix1a, hlorddragon_atk_a2 ] {hlorddragon_move(17);};
void() hlorddragon_atk_a2=[$drgfix1b, hlorddragon_atk_a3 ] {hlorddragon_move(17);hlorddragon_fireball();};
void() hlorddragon_atk_a3=[$drgfix1c, hlorddragon_walk5  ] {hlorddragon_move(17);dragon_stop_attack();};

// attack B: start - walk3  stop - walk7
void() hlorddragon_atk_b1=[$drgfix2a, hlorddragon_atk_b2 ] {hlorddragon_move(17);};
void() hlorddragon_atk_b2=[$drgfix2b, hlorddragon_atk_b3 ] {hlorddragon_move(17);hlorddragon_fireball();};
void() hlorddragon_atk_b3=[$drgfix2c, hlorddragon_walk7  ] {hlorddragon_move(17);dragon_stop_attack();};

// attack C: start - walk5  stop - walk9
void() hlorddragon_atk_c1=[$drgfix3a, hlorddragon_atk_c2 ] {hlorddragon_move(17);};
void() hlorddragon_atk_c2=[$drgfix3b, hlorddragon_atk_c3 ] {hlorddragon_move(17);hlorddragon_fireball();};
void() hlorddragon_atk_c3=[$drgfix3c, hlorddragon_walk9  ] {hlorddragon_move(17);dragon_stop_attack();};

// attack d: start - walk7  stop - walk11
// ================
void() hlorddragon_atk_d1=[$drgfix4a, hlorddragon_atk_d2 ] {hlorddragon_move(17);};
void() hlorddragon_atk_d2=[$drgfix4b, hlorddragon_atk_d3 ] {hlorddragon_move(17);hlorddragon_fireball();};
void() hlorddragon_atk_d3=[$drgfix4c, hlorddragon_walk11 ] {hlorddragon_move(17);dragon_stop_attack();};

// attack E: start - walk9  stop - walk13
// ================
void() hlorddragon_atk_e1=[$drgfix5a, hlorddragon_atk_e2 ] {hlorddragon_move(17);};
void() hlorddragon_atk_e2=[$drgfix5b, hlorddragon_atk_e3 ] {hlorddragon_move(17);hlorddragon_fireball();};
void() hlorddragon_atk_e3=[$drgfix5c, hlorddragon_walk13 ] {hlorddragon_move(17);dragon_stop_attack();};

// attack F: start - walk11  stop - walk3
// ================
void() hlorddragon_atk_f1=[$drgfix6a, hlorddragon_atk_f2 ] {hlorddragon_move(17);};
void() hlorddragon_atk_f2=[$drgfix6b, hlorddragon_atk_f3 ] {hlorddragon_move(17);hlorddragon_fireball();};
void() hlorddragon_atk_f3=[$drgfix6c, hlorddragon_atk_f4 ] {hlorddragon_move(17);};
void() hlorddragon_atk_f4=[$drgfix6c, hlorddragon_walk3  ] {hlorddragon_move(17);dragon_stop_attack();};

void() hlorddragon_walk1 =[ $drgfly01, hlorddragon_walk2 ] {
    if (self.dragonAttacking) dragon_stop_attack();          
    self.th_missile=dragon_atk_a1;
    self.hlorddragonPainSequence=1;
    hlorddragon_move(17);
    if (random() < 0.2) sound (self, CHAN_VOICE, "rogue/dragon/active.wav", 0.6, ATTN_IDLE);
};
void() hlorddragon_walk2 =[ $drgfly02, hlorddragon_walk3 ] {self.th_missile=SUB_Null; dragon_move(17);};
void() hlorddragon_walk3 =[ $drgfly03, hlorddragon_walk4 ] { 
    self.th_missile=hlorddragon_atk_b1; hlorddragon_move(17);
    self.hlorddragonPainSequence=2;
};
void() hlorddragon_walk4 =[ $drgfly04, hlorddragon_walk5 ] {self.th_missile=SUB_Null; hlorddragon_move(17);};
void() hlorddragon_walk5 =[ $drgfly05, hlorddragon_walk6 ] { 
    self.th_missile=dragon_atk_c1; hlorddragon_move(17);
    self.hlorddragonPainSequence=3;
};
void() hlorddragon_walk6 =[ $drgfly06, hlorddragon_walk7 ] {self.th_missile=SUB_Null; hlorddragon_move(17);};
void() hlorddragon_walk7 =[ $drgfly07, hlorddragon_walk8 ] {
    self.th_missile=dragon_atk_d1; hlorddragon_move(17);
    self.hlorddragonPainSequence=4;
};
void() hlorddragon_walk8 =[ $drgfly08, hlorddragon_walk9 ] {self.th_missile=SUB_Null; hlorddragon_move(17);};
void() hlorddragon_walk9 =[ $drgfly09, hlorddragon_walk10 ] {
    if (self.waterlevel <= 1) // Not while in water.
        sound (self, CHAN_BODY, "drake/dragon/fly1.wav", 1, ATTN_NORM);
    else if ((self.liquidbase == CONTENT_WATER) || (self.liquidbase == CONTENT_SLIME))
        sound (self, CHAN_BODY, "drake/dragon/flywater.wav", 1, ATTN_NORM);
    self.th_missile=dragon_atk_e1; dragon_move(17);
    self.dragonPainSequence=5;
};
void() hlorddragon_walk10 =[ $drgfly10, hlorddragon_walk11 ] {self.th_missile=SUB_Null; hlorddragon_move(17);};
void() hlorddragon_walk11 =[ $drgfly11, hlorddragon_walk12 ] {
    self.th_missile=hlorddragon_atk_f1; hlorddragon_move(17);
    self.hlorddragonPainSequence=6;
};
void() hlorddragon_walk12 =[ $drgfly12, hlorddragon_walk13 ]
    {self.th_missile=SUB_Null; hlorddragon_move(17);};
void() hlorddragon_walk13 =[ $drgfly13, hlorddragon_walk1 ]
    {self.th_missile=SUB_Null; hlorddragon_move(17); self.hlorddragonPainSequence=1;};

// ===========================================
// dragon_fireball
// ===========================================
void() hlorddragon_fireball = {
    local   float   fireCount;
    local   vector  org, dir;
    local   float   distortion;
    local   float   fireType;
    local   float   sped;       // For the modified attacks.
    
    sound (self, CHAN_VOICE, "rogue/dragon/attack.wav", 1, ATTN_NORM);

    makevectors (self.angles);
    org = self.origin + v_forward*96 + v_up*16;

    if (self.classname == "monster_dark_lord") {
        if (random() < skill * 0.5) self.shots_max = !self.shots_max;
    }

    if (random() > 0.66) {
		// Plasma
        fireType = FALSE;
        fireCount = 1;
        if (self.classname != "monster_dark_lord")  // PM:  Two is excessive for the dark lord.
			if (skill > 1) fireCount = 2;
        self.shots_max = 0;     // No more attacks -- too cheap!
    } else {
        fireType = TRUE; // Fireballs
        fireCount = random() * skill;   // easy 0, med 0-1, hard 0-2, nm 0-3
        fireCount = rint ( fireCount ) + 1; // easy 1, med 1-2, hard 1-3, nm 1-4
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
    while (fireCount > 0) {
        // PM:  Don't bother with shot leading or invisibility mis-aim.
        //  This is a brutal flak/shotgun style attack.
        distortion = (random() - 0.5) * 0.25;
        if (self.classname == "monster_dark_lord") {
            if (fireCount == 1) distortion = 0;

            if (self.shots_max)
                dir = self.enemy.origin;
            else
                dir = Aim_Lead (org, self.enemy.origin, 1000, self.enemy);
            dir = normalize (dir - org);
        } else {
            dir = normalize (self.enemy.origin - org); // Normal DoE dragon.
		}
        makevectors (dir);
        dir = dir + v_right * distortion;

        sped = random() * 300 + 900;    // For the fireballs.
        if (fireType) {
			sound (self, CHAN_WEAPON, "drake/dragon/fire.wav", 1, ATTN_NORM);
            Meteor_Launch (self, org, dir, sped, 90);
        } else {
			sound (self, CHAN_WEAPON, "rogue/plasma/fire.wav", 1, ATTN_NORM);
			launch_projectile(org, dir, CT_PROJ_PLASMA, sped);
        }
        fireCount = fireCount - 1;
    }
};

// melee attacks
void() hlorddragon_tail = {
    local float dist;
    local vector dir;
    
    if (!self.enemy) return;
    if (!CanDamage (self.enemy, self)) return;

    hlorddragon_move(10);
    dir = self.enemy.origin - self.origin;
    dist = vlen (dir);
    if (dist < 250)
    {   // PM:  Added onground flag removal so monsters get thrown too.
        T_Damage (self.enemy, self, self, 30, DAMARMOR);
        sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);
        if (self.enemy.mass && (self.enemy.mass <= MASS_SUPER)) {
            dir = normalize (dir);
            self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
            self.enemy.velocity = dir * 500;
            self.enemy.velocity_z = 350;
        }
    }
    dragon_stop_attack();
};

void() hlorddragon_melee1  =[$drgslh01, hlorddragon_melee2 ] {hlorddragon_move(12);};
void() hlorddragon_melee2  =[$drgslh02, hlorddragon_melee3 ] {hlorddragon_move(12);};
void() hlorddragon_melee3  =[$drgslh03, hlorddragon_melee4 ] {hlorddragon_move(12);};
void() hlorddragon_melee4  =[$drgslh04, hlorddragon_melee5 ] {hlorddragon_move(12);};
void() hlorddragon_melee5  =[$drgslh05, hlorddragon_melee6 ] {hlorddragon_move(12);};
void() hlorddragon_melee6  =[$drgslh06, hlorddragon_melee7 ] {hlorddragon_move(12);};
void() hlorddragon_melee7  =[$drgslh07, hlorddragon_melee8 ] {hlorddragon_move(12);};
void() hlorddragon_melee8  =[$drgslh08, hlorddragon_melee9 ] {hlorddragon_move(12);};
void() hlorddragon_melee9  =[$drgslh09, hlorddragon_melee10] {hlorddragon_move(12);};
void() hlorddragon_melee10 =[$drgslh10, hlorddragon_melee11] {hlorddragon_tail();};
void() hlorddragon_melee11 =[$drgslh11, hlorddragon_melee12] {hlorddragon_move(10);};
void() hlorddragon_melee12 =[$drgslh12, hlorddragon_melee13] {hlorddragon_move(10);};
void() hlorddragon_melee13 =[$drgslh13, hlorddragon_walk1  ] {hlorddragon_move(10);};

// ===================================
// pain
// ===================================
void() hlorddragon_painA1 =[ $drgpan1a, hlorddragon_painA2 ] {hlorddragon_move(12);};
void() hlorddragon_painA2 =[ $drgpan1b, hlorddragon_painA3 ] {hlorddragon_move(12);};
void() hlorddragon_painA3 =[ $drgpan1c, hlorddragon_walk5  ] {hlorddragon_move(12);};

void() hlorddragon_painB1 =[ $drgpan2a, hlorddragon_painB2 ] {hlorddragon_move(12);};
void() hlorddragon_painB2 =[ $drgpan2b, hlorddragon_painB3 ] {hlorddragon_move(12);};
void() hlorddragon_painB3 =[ $drgpan2c, hlorddragon_walk7  ] {hlorddragon_move(12);};

void() hlorddragon_painC1 =[ $drgpan3a, hlorddragon_painC2 ] {hlorddragon_move(12);};
void() hlorddragon_painC2 =[ $drgpan3b, hlorddragon_painC3 ] {hlorddragon_move(12);};
void() hlorddragon_painC3 =[ $drgpan3c, hlorddragon_walk9  ] {hlorddragon_move(12);};

void() hlorddragon_painD1 =[ $drgpan4a, hlorddragon_painD2 ] {hlorddragon_move(12);};
void() hlorddragon_painD2 =[ $drgpan4b, hlorddragon_painD3 ] {hlorddragon_move(12);};
void() hlorddragon_painD3 =[ $drgpan4c, hlorddragon_walk11 ] {hlorddragon_move(12);};

void() hlorddragon_painE1 =[ $drgpan5a, hlorddragon_painE2 ] {hlorddragon_move(12);};
void() hlorddragon_painE2 =[ $drgpan5b, hlorddragon_painE3 ] {hlorddragon_move(12);};
void() hlorddragon_painE3 =[ $drgpan5c, hlorddragon_walk13 ] {hlorddragon_move(12);};

void() hlorddragon_painF1 =[ $drgpan6a, hlorddragon_painF2 ] {hlorddragon_move(12);};
void() hlorddragon_painF2 =[ $drgpan6b, hlorddragon_painF3 ] {hlorddragon_move(12);};
void() hlorddragon_painF3 =[ $drgpan6c, hlorddragon_walk2  ] {hlorddragon_move(12);};

void(entity inflictor, entity attacker, float damage) hlorddragon_pain = {
    if (self.pain_finished > time)
        return;
    if (skill >= 3)
        return;     // PM:  No pain in Nightmare.
    if (self.dragonAttacking)
        return;     // PM:  Don't flinch while attacking.

    if (random() < 0.25) {
        dragon_stop_attack();
        sound (self, CHAN_VOICE, "rogue/dragon/pain.wav", 1, ATTN_NORM);
        self.pain_finished = time + 2;
        if (self.hlorddragonPainSequence == 1)
            self.think = hlorddragon_painA1;
        else if (self.hlorddragonPainSequence == 2)
            self.think = hlorddragon_painF1;
        else if (self.hlorddragonPainSequence == 3)
            self.think = hlorddragon_painE1;
        else if (self.hlorddragonPainSequence == 4)
            self.think = hlorddragon_painD1;
        else if (self.hlorddragonPainSequence == 5)
            self.think = hlorddragon_painC1;
        else if (self.hlorddragonPainSequence == 6)
            self.think = hlorddragon_painB1;
    }
};

void() hlorddragon_boom = {
    self.velocity = self.hlorddragonLastVelocity;
    ThrowGib(1,15);
    ThrowGib(2,15);
    ThrowGib(3,15);
    self.target = "dragondoor";
    SUB_UseTargets();            
    remove(self);
};

void() hlorddragon_nuke = {
    local entity swap;

	// Lavasplash particles form a box with a size of 270x270x64. 135 * 1.4142 = 190.9188.  So use 160 damage for explosion "radius" of 200.
    T_RadiusDamage (self, self, 160, self, DAMAGEALL); // Damage first, then effects. 
    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
    Tent_Point (TE_LAVASPLASH, self.origin - '0 0 32');
    swap = self;
    self = spawn();
    setorigin (self, swap.origin + '0 0 24');
    WarpExplosion(); // The big fireball at the center.
    self = swap;
};

void() hlorddragon_parts = {
	monster_ThrowGib();
    sound (self, CHAN_BODY, "player/teledth1.wav", 1, ATTN_NONE);
};

void() hlorddragon_explode =  {
    if (self.deadflag > DEAD_DYING) return;  // Already exploded.
        
    if (vlen(self.velocity) < 100 || self.flags & FL_INWATER) {
        self.touch = SUB_Null;
		self.deadflag = self.deadflag & DEAD_DYING;
        hlorddragon_parts ();
        hlorddragon_nuke (); // Explode for massive damage!
		Quake_Spawn(self,800,0,self.origin,FALSE,1,VEC_QUAKE);
        self.think = hlorddragon_boom; // We can't remove dragon now, because this may be called during a touch function, ... 
        self.nextthink = time + 0.100; // ...in which case the C code is looping through area links.  Delay removal for at least a frame.
    } else {
        makevectors (self.angles);
        self.velocity = self.velocity - 40 * v_up;
        self.hlorddragonLastVelocity = self.velocity;
    }
};

void() hlorddragon_squish = {
    if (other.solid == SOLID_BSP) {
        self.velocity = '0 0 0';
        hlorddragon_explode ();
        return;
    }

    if (other.takedamage)   // PM:  Squish anything, not players only.
        T_Damage (other, self, self, 200, DAMARMOR);
};

void() hlorddragon_death1  =[ $drgdth01, hlorddragon_death2  ] {
    self.use      = SUB_Null;
    makevectors (self.angles);
    self.velocity = 300 * v_forward - 40 * v_up;
    self.flags    = self.flags - (self.flags & FL_ONGROUND);
    setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX); // PM: Use the bigger hull2 size instead of hull.
    self.touch    = hlorddragon_squish;
    sound (self, CHAN_VOICE, "rogue/dragon/death.wav", 1, ATTN_NONE);
    self.dragonAttacking = FALSE;
};
void() hlorddragon_death2  =[ $drgdth02, hlorddragon_death3  ] {hlorddragon_explode();};
void() hlorddragon_death3  =[ $drgdth03, hlorddragon_death4  ] {hlorddragon_explode();};
void() hlorddragon_death4  =[ $drgdth04, hlorddragon_death5  ] {hlorddragon_explode();};
void() hlorddragon_death5  =[ $drgdth05, hlorddragon_death6  ] {hlorddragon_explode();};
void() hlorddragon_death6  =[ $drgdth06, hlorddragon_death7  ] {hlorddragon_explode();};
void() hlorddragon_death7  =[ $drgdth07, hlorddragon_death8  ] {hlorddragon_explode();};
void() hlorddragon_death8  =[ $drgdth08, hlorddragon_death9  ] {hlorddragon_explode();};
void() hlorddragon_death9  =[ $drgdth09, hlorddragon_death10 ] {hlorddragon_explode();};
void() hlorddragon_death10 =[ $drgdth10, hlorddragon_death11 ] {hlorddragon_explode();};
void() hlorddragon_death11 =[ $drgdth11, hlorddragon_death12 ] {hlorddragon_explode();};
void() hlorddragon_death12 =[ $drgdth12, hlorddragon_death13 ] {hlorddragon_explode();};
void() hlorddragon_death13 =[ $drgdth13, hlorddragon_death14 ] {hlorddragon_explode();};
void() hlorddragon_death14 =[ $drgdth14, hlorddragon_death15 ] {hlorddragon_explode();};
void() hlorddragon_death15 =[ $drgdth15, hlorddragon_death16 ] {hlorddragon_explode();};
void() hlorddragon_death16 =[ $drgdth16, hlorddragon_death17 ] {hlorddragon_explode();};
void() hlorddragon_death17 =[ $drgdth17, hlorddragon_death18 ] {hlorddragon_explode();};
void() hlorddragon_death18 =[ $drgdth18, hlorddragon_death19 ] {hlorddragon_explode();};
void() hlorddragon_death19 =[ $drgdth19, hlorddragon_death20 ] {hlorddragon_explode();};
void() hlorddragon_death20 =[ $drgdth20, hlorddragon_death21 ] {hlorddragon_explode();};
void() hlorddragon_death21 =[ $drgdth21, SUB_Null       ] {
    hlorddragon_parts (); // PM: Added explosion and other gibs.
    hlorddragon_nuke ();
	Quake_Spawn(self,600,0,self.origin,FALSE,1,VEC_QUAKE);
    ThrowGib(1,13);
    ThrowGib(2,13);
    ThrowGib(3,13);
    self.target = "dragondoor";
    SUB_UseTargets();
    remove(self);
};

// Morphs the dark lord into the beast.  See 'hknight.qc' for dark lord.
void() darklord_thebeast = {
    hlorddragon_nuke ();     // Spawn a big explosion.

    self.flags = (self.flags | FL_FLY) - (self.flags & FL_GODMODE);
    self.solid = SOLID_SLIDEBOX;
	self.classtype = CT_MONWYRM;
    // HACK:  For dark lord in unf3.
    if (self.target  != "path_corner")
    if (self.target2 == "path_corner") {
        local   string  swap;

        swap = self.target;
        self.target = self.target2;
        self.target2 = swap;
        if (self.target == "path_corner") {
			// Follow a path.
            self.movetarget = find(world, targetname, self.target);
            self.ryuflags = self.ryuflags | RYU_PATH;
        }
        // ELSE... dragon chases the player.
    }

    // Make sure classname stays at "monster_dark_lord".
    self.classname = "monster_dark_lord";
    self.skin = 1;      // Evil red eye black dragon.
    SUB_AttackFinished (2);     // Give player time, unless it's Nightmare+!
    self.dragonAttacking = FALSE;
    self.health = self.max_health - 1000;
	self.gib1mdl = "progs/drake/drggib01.mdl";
	self.gib2mdl = "progs/drake/drggib02.mdl";
	self.gib3mdl = "progs/drake/drggib03.mdl";
	setmodel (self, "progs/drake/dragon.mdl");
	setsize (self, '-96 -96 -24', '96 96 96');
    self.mindex2    = self.modelindex;      // Remember new modelindex.
    self.dest1  = '-96 -96 -24';
    self.dest2  = '96 96 96';
    self.spawnskin  = self.skin;
    self.th_stand   = hlorddragon_walk1;
    self.th_walk    = hlorddragon_walk1;
    self.th_run     = hlorddragon_walk1;
    self.th_melee   = SUB_Null;  // Knights melee, dragon doesn't.
    self.th_missile = SUB_Null;     // Constantly changes while walking.
    self.th_pain    = hlorddragon_pain;
    self.th_die     = hlorddragon_death1;
    self.sight_sound = "rogue/dragon/see.wav";
	self.hello_sound = string_null; // no hello
    self.hlorddragonPainSequence=1;
    self.yaw_speed = 10;    // Hardwire this now!
    self.mass = 0;          // Now it's a huge massive dragon!
    self.bloodtype = BLOOD_RED;     // It's flesh and blood now.
    self.ryuflags = self.ryuflags | RYU_NO_WATER;
	self.resist_poison = self.resist_acid = 1;
    hlorddragon_walk1 ();
};