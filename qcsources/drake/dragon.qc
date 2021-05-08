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
void() dragon_fireball;
void() dragon_melee1;

//////////////////////////////////////
// FIXME:  Use standard vars.
.float  dragonAttacking;
.float  dragonPainSequence;
.vector dragonLastVelocity;
//////////////////////////////////////

// ===================================
// dragon_stop_attack 
// ===================================
void() dragon_stop_attack =
{
    if (self.dragonAttacking == FALSE)
        return;

//    skill ramp?
    self.attack_finished = time + (random() * 2 ) + 4;
    self.attack_finished = self.attack_finished - skill;
    // PM:  Encore check for dark lord.
    if (self.shots_max)
        self.attack_finished = 0;
    
    self.dragonAttacking = FALSE;
// DISABLED -- Don't waste time doing this just for a debug message.
//    if (self.movetarget)
//    {
//        traceline (self.origin, self.movetarget.origin, TRUE, world);
//        if (trace_fraction == 1)
//            return;
//        else
//            bprint ("Error: Dragon cannot get to next target!\n");
//    }
};

// ===================================
// dragon_check_attack 
// ===================================
void() dragon_check_attack =
{
    local   vector  vec;
    local   float   dot;

    if (self.dragonAttacking == TRUE)
        return;
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
    else
    {
        makevectors (self.angles);
        vec = normalize (self.enemy.origin - self.origin);
        dot = vec * v_forward;
        if (dot > 0.3)
        {
            traceline (self.origin, self.enemy.origin, TRUE, world);
            if (trace_fraction == 1)
            {
                dot = vlen ( self.enemy.origin - self.origin );
                // dot was 350, but that was too much.
                if ((dot < 250) && !self.cnt)
                {
                    if (random() < 0.5)
                        self.cnt = 1;   // Use missile attack next time.
                    self.dragonAttacking = TRUE;
                    self.think = dragon_melee1;
                    return;
                }
                else
                {
                    self.cnt = 0;
                    self.dragonAttacking = TRUE;
                    self.think = self.th_missile;
                }
            }
//            else
//                bprint ("can't see player!\n");
        }
    }
};

// ===================================
// dragon_untilt (Added by PM)
// ===================================
void() dragon_untilt =
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
void(float dist) dragon_move =
{
    local   vector  moveDir;
    local   vector  moveAngles;
    local   float   leftTurn, rightTurn, turnOffset;
    local   entity  oldEnemy;
    local   entity  targ;       // Goal the dragon should aim/move toward.
    local   float   onpath;     // TRUE if flying toward path_corner.

    if (self.health < 1)
        return;     // PM:  Removed the remove statement.
    
    if (self.dragonAttacking == FALSE)
        dragon_check_attack();
    
    oldEnemy = self.enemy;

// Set the goal the dragon should seek this frame.
    onpath = (self.movetarget.classname == "path_corner");
    if ( onpath && (self.ryuflags & RYU_PATH) )
        targ = self.movetarget;
    else if (self.enemy)
    {
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

    if (self.dragonAttacking == FALSE)
    {
        if (targ)
        {   // Seeking a path_corner, enemy, or master...
            if (!onpath)
            {   // Dragon is seeking a target, not following a path.
                // Don't bother with fancy tilt code -- just untilt it.
                dragon_untilt ();

                // Aim high above the target's head.
                temp_goal.origin = targ.origin;
                temp_goal.origin_z = temp_goal.origin_z + targ.maxs_z;
                setorigin (temp_goal, temp_goal.origin);

                self.enemy = temp_goal;
                if (!oldEnemy)
                {   // Following a master, not an enemy.
                    if (Wyrm_WalkMove (self.angles_y, dist))
                    {   // Direct movement successful, so stop here.
                        ai_face ();
                        self.enemy = oldEnemy;
                        return;
                    }
                }
                moveDir = self.origin;
                QC_MoveToGoal (dist);
                if (moveDir == self.origin)
                {
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
        }
        else
        {   // No path or target, so fly forward.
            makevectors (self.angles);
            moveDir = v_forward;
            moveAngles = self.angles;
        }
        self.enemy = targ;
    }
    else
    {   // Turn toward the enemy during an attack.
        moveDir = self.enemy.origin;
        if (targ)
            if (!onpath)    // If moving toward enemy, fly above its head.
                moveDir_z = moveDir_z + self.enemy.maxs_z + 40;
        moveDir = moveDir - self.origin;
        moveAngles = vectoangles (moveDir);
    }
    
    turnOffset = self.angles_y - moveAngles_y;
    if (turnOffset != 0)
    {
        turnOffset = 180 - self.angles_y;
        leftTurn = anglemod (moveAngles_y + turnOffset) - 180;
        rightTurn = 180 - anglemod (moveAngles_y + turnOffset);
        
        if (leftTurn < 0)
            leftTurn = 360;
        else if (rightTurn < 0)
            rightTurn = 360;
    
    // PM:  yaw_speed already set at spawn time.
        if (rightTurn < 180)
        {
            if (self.yaw_speed < rightTurn)
                self.angles_y = self.angles_y - self.yaw_speed;
            else
                self.angles_y = moveAngles_y;
    
            if (rightTurn > 5)
            {
                self.angles_z = self.angles_z + 5;
                if (self.angles_z > 30)
                    self.angles_z = 30;
            }
            turnOffset = rightTurn;
        }
        else 
        {
            if (self.yaw_speed < rightTurn)
                self.angles_y = self.angles_y + self.yaw_speed;
            else
                self.angles_y = moveAngles_y;

            if (leftTurn > 5)
            {
                self.angles_z = self.angles_z - 5;
                if (self.angles_z < -30)
                    self.angles_z = -30;
            }
            turnOffset = leftTurn;
        }
    }
    else
        dragon_untilt ();

// PM:  Don't use setorigin because of clipping problems.
    if (moveDir_z > 5)
        ai_up (5);     //setorigin (self, self.origin + '0 0 5');
    else if (moveDir_z < -5) 
        ai_up (-5);    //setorigin (self, self.origin - '0 0 5');

    moveAngles = self.origin;
    Wyrm_WalkMove (self.angles_y, dist);
    if (moveAngles == self.origin)
    {
//        bprint ("Cannot move smoothly. movetogoal..\n");
        QC_MoveToGoal (dist);
    }
    self.enemy = oldEnemy;
};

// ===================================
// movement
// ===================================

// attack A: start - walk1  stop - walk 5
// ================
void() dragon_atk_a1=[$drgfix1a, dragon_atk_a2 ] {dragon_move(17);};
void() dragon_atk_a2=[$drgfix1b, dragon_atk_a3 ] {dragon_move(17);dragon_fireball();};
void() dragon_atk_a3=[$drgfix1c, dragon_walk5  ] {dragon_move(17);dragon_stop_attack();};

// attack B: start - walk3  stop - walk7
// ================
void() dragon_atk_b1=[$drgfix2a, dragon_atk_b2 ] {dragon_move(17);};
void() dragon_atk_b2=[$drgfix2b, dragon_atk_b3 ] {dragon_move(17);dragon_fireball();};
void() dragon_atk_b3=[$drgfix2c, dragon_walk7  ] {dragon_move(17);dragon_stop_attack();};

// attack C: start - walk5  stop - walk9
// ================
void() dragon_atk_c1=[$drgfix3a, dragon_atk_c2 ] {dragon_move(17);};
void() dragon_atk_c2=[$drgfix3b, dragon_atk_c3 ] {dragon_move(17);dragon_fireball();};
void() dragon_atk_c3=[$drgfix3c, dragon_walk9  ] {dragon_move(17);dragon_stop_attack();};

// attack d: start - walk7  stop - walk11
// ================
void() dragon_atk_d1=[$drgfix4a, dragon_atk_d2 ] {dragon_move(17);};
void() dragon_atk_d2=[$drgfix4b, dragon_atk_d3 ] {dragon_move(17);dragon_fireball();};
void() dragon_atk_d3=[$drgfix4c, dragon_walk11 ] {dragon_move(17);dragon_stop_attack();};

// attack E: start - walk9  stop - walk13
// ================
void() dragon_atk_e1=[$drgfix5a, dragon_atk_e2 ] {dragon_move(17);};
void() dragon_atk_e2=[$drgfix5b, dragon_atk_e3 ] {dragon_move(17);dragon_fireball();};
void() dragon_atk_e3=[$drgfix5c, dragon_walk13 ] {dragon_move(17);dragon_stop_attack();};

// attack F: start - walk11  stop - walk3
// ================
void() dragon_atk_f1=[$drgfix6a, dragon_atk_f2 ] {dragon_move(17);};
void() dragon_atk_f2=[$drgfix6b, dragon_atk_f3 ] {dragon_move(17);dragon_fireball();};
void() dragon_atk_f3=[$drgfix6c, dragon_atk_f4 ] {dragon_move(17);};
void() dragon_atk_f4=[$drgfix6c, dragon_walk3  ] {dragon_move(17);dragon_stop_attack();};

// ===================================
// dragon walk frames
// ===================================
void() dragon_walk1 =[ $drgfly01, dragon_walk2 ] 
{
    if (self.dragonAttacking)
        dragon_stop_attack();
            
    self.th_missile=dragon_atk_a1;
    self.dragonPainSequence=1;
    dragon_move(17);
    if (random() < 0.2)
        sound (self, CHAN_VOICE, "dragon/active.wav", 0.6, ATTN_IDLE);
};
void() dragon_walk2 =[ $drgfly02, dragon_walk3 ]
    {self.th_missile=SUB_Null; dragon_move(17);};
void() dragon_walk3 =[ $drgfly03, dragon_walk4 ]
{ 
    self.th_missile=dragon_atk_b1; dragon_move(17);
    self.dragonPainSequence=2;
};
void() dragon_walk4 =[ $drgfly04, dragon_walk5 ]
    {self.th_missile=SUB_Null; dragon_move(17);};
void() dragon_walk5 =[ $drgfly05, dragon_walk6 ]
{ 
    self.th_missile=dragon_atk_c1; dragon_move(17);
    self.dragonPainSequence=3;
};
void() dragon_walk6 =[ $drgfly06, dragon_walk7 ]
    {self.th_missile=SUB_Null; dragon_move(17);};
void() dragon_walk7 =[ $drgfly07, dragon_walk8 ]
{
    self.th_missile=dragon_atk_d1; dragon_move(17);
    self.dragonPainSequence=4;
};
void() dragon_walk8 =[ $drgfly08, dragon_walk9 ]
    {self.th_missile=SUB_Null; dragon_move(17);};
void() dragon_walk9 =[ $drgfly09, dragon_walk10 ]
{
    if (self.h2olevel <= 1)     // Not while in the water.
        sound (self, CHAN_BODY, "dragon/fly1.wav", 1, ATTN_NORM);
    else if ((self.h2otype == CONTENT_WATER) || (self.h2otype == CONTENT_SLIME))
        sound (self, CHAN_BODY, "dragon/flywater.wav", 1, ATTN_NORM);
    self.th_missile=dragon_atk_e1; dragon_move(17);
    self.dragonPainSequence=5;
};
void() dragon_walk10 =[ $drgfly10, dragon_walk11 ]
    {self.th_missile=SUB_Null; dragon_move(17);};
void() dragon_walk11 =[ $drgfly11, dragon_walk12 ]
{
    self.th_missile=dragon_atk_f1; dragon_move(17);
    self.dragonPainSequence=6;
};
void() dragon_walk12 =[ $drgfly12, dragon_walk13 ]
    {self.th_missile=SUB_Null; dragon_move(17);};
void() dragon_walk13 =[ $drgfly13, dragon_walk1 ]
    {self.th_missile=SUB_Null; dragon_move(17); self.dragonPainSequence=1;};

// ===================================
// attack
// ===================================

/* DISABLED -- Use 'fire.qc' functions instead.
void() FireballTouch =
{
// FIXME:  Pass the buck to T_MissileTouch
//    if (self.owner.classname == "monster_dragon")
        T_RadiusDamage (self, self.owner, 90, self.owner);
//    else
//        T_RadiusDamage (self, self.owner, 30, world);
    
//    sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
//    Tent_Explosion2 (self.origin, 228, 5);  // 247...
    Tent_Explosion2 (self.origin, 224, 16);
//    Tent_Explosion2 (self.origin, 230, 8);
//    Tent_Explosion2 (self.origin, 232, 8);

//    remove(self);
    BecomeExplosion();
};

void(vector org, vector dir) launch_fireball =
{
    local entity    fireball;
    local float        fireSpeed;
    
    self.effects = self.effects | EF_MUZZLEFLASH;
    fireball = spawn();
    fireball.owner = self;
    fireball.movetype = MOVETYPE_FLYMISSILE;
    fireball.solid = SOLID_BBOX;
    fireball.classname = "fireball";
    setmodel (fireball, "progs/fireball.mdl");
    setorigin (fireball, org);
    setsize (fireball, '0 0 0', '0 0 0');        

    fireSpeed = random() * 300 + 900;
    fireball.velocity = dir * fireSpeed;
    fireball.avelocity = '0 0 300';
    fireball.angles = vectoangles(fireball.velocity);
    fireball.enemy = self.enemy;
    
    fireball.touch = FireballTouch;
    fireball.nextthink = time + 6;
    fireball.think = SUB_Remove;
};
*/

// ===========================================
// dragon_fireball
// ===========================================
void() dragon_fireball =
{
    local   float   fireCount;
    local   vector  org, dir;
    local   float   distortion;
    local   float   fireType;
    local   float   sped;       // For the modified attacks.
    
    sound (self, CHAN_VOICE, "dragon/attack1.wav", 1, ATTN_NORM);

    makevectors (self.angles);
//    org = self.origin + v_forward*112 + v_up*32;
    org = self.origin + v_forward*96 + v_up*16;

//---------
// FIXME: Dark lord test.
    if (self.classname == "monster_dark_lord")
    {
        if (random() < skill * 0.5)
            self.shots_max = !self.shots_max;
    }
//---------
    if (random() > 0.66)
    {   // Plasma
        fireType = FALSE;
        fireCount = 1;
        if (self.classname != "monster_dark_lord")  // PM:  Two is excessive for the dark lord.
        if (skill > 1)
            fireCount = 2;
        self.shots_max = 0;     // No more attacks -- too cheap!
    }
    else
    {   // Fireballs
        fireType = TRUE;
        fireCount = random() * skill;   // easy 0, med 0-1, hard 0-2, nm 0-3
        fireCount = rint ( fireCount ) + 1;
    // easy 1, med 1-2, hard 1-3, nm 1-4
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
    while (fireCount > 0)
    {
        // PM:  Don't bother with shot leading or invisibility mis-aim.
        //  This is a brutal flak/shotgun style attack.
        distortion = (random() - 0.5) * 0.25;
        if (self.classname == "monster_dark_lord")
        {
            if (fireCount == 1)
                distortion = 0;

            if (self.shots_max)
                dir = self.enemy.origin;
            else
                dir = Aim_Lead (org, self.enemy.origin, 1000, self.enemy);
            dir = normalize (dir - org);
        }
        else    // Normal DoE dragon.
            dir = normalize (self.enemy.origin - org);
        makevectors (dir);
        dir = dir + v_right * distortion;

        sped = random() * 300 + 900;    // For the fireballs.
        if (fireType)
        {   sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
            Meteor_Launch (self, org, dir, sped, 90);
//            launch_fireball(org, dir);
        }
        else
        {   sound (self, CHAN_WEAPON, "plasma/fire.wav", 1, ATTN_NORM);
            Plasma_Launch (org, dir, sped, 100, TRUE);
//            launch_plasma(org, dir);
        }

        fireCount = fireCount - 1;
    }

};

// ===================================
// melee attacks
// ===================================
void() dragon_tail =
{
    local float dist;
    local vector dir;
    
    if (!self.enemy)
        return;
    if (!CanDamage (self.enemy, self))
        return;

    dragon_move(10);

    dir = self.enemy.origin - self.origin;
    dist = vlen (dir);
    if (dist < 250)
    {   // PM:  Added onground flag removal so monsters get thrown too.
        T_Damage (self.enemy, self, self, 30);
        sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);
        if (self.enemy.mass && (self.enemy.mass <= MASS_SUPER))
        {
            dir = normalize (dir);
            self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
            self.enemy.velocity = dir * 500;
            self.enemy.velocity_z = 350;
        }
    }
    dragon_stop_attack();
};

void() dragon_melee1  =[$drgslh01, dragon_melee2 ] {dragon_move(12);};
void() dragon_melee2  =[$drgslh02, dragon_melee3 ] {dragon_move(12);};
void() dragon_melee3  =[$drgslh03, dragon_melee4 ] {dragon_move(12);};
void() dragon_melee4  =[$drgslh04, dragon_melee5 ] {dragon_move(12);};
void() dragon_melee5  =[$drgslh05, dragon_melee6 ] {dragon_move(12);};
void() dragon_melee6  =[$drgslh06, dragon_melee7 ] {dragon_move(12);};
void() dragon_melee7  =[$drgslh07, dragon_melee8 ] {dragon_move(12);};
void() dragon_melee8  =[$drgslh08, dragon_melee9 ] {dragon_move(12);};
void() dragon_melee9  =[$drgslh09, dragon_melee10] {dragon_move(12);};
void() dragon_melee10 =[$drgslh10, dragon_melee11] {dragon_tail();};
void() dragon_melee11 =[$drgslh11, dragon_melee12] {dragon_move(10);};
void() dragon_melee12 =[$drgslh12, dragon_melee13] {dragon_move(10);};
void() dragon_melee13 =[$drgslh13, dragon_walk1  ] {dragon_move(10);};

// ===================================
// pain
// ===================================
void() dragon_painA1 =[ $drgpan1a, dragon_painA2 ] {dragon_move(12);};
void() dragon_painA2 =[ $drgpan1b, dragon_painA3 ] {dragon_move(12);};
void() dragon_painA3 =[ $drgpan1c, dragon_walk5  ] {dragon_move(12);};

void() dragon_painB1 =[ $drgpan2a, dragon_painB2 ] {dragon_move(12);};
void() dragon_painB2 =[ $drgpan2b, dragon_painB3 ] {dragon_move(12);};
void() dragon_painB3 =[ $drgpan2c, dragon_walk7  ] {dragon_move(12);};

void() dragon_painC1 =[ $drgpan3a, dragon_painC2 ] {dragon_move(12);};
void() dragon_painC2 =[ $drgpan3b, dragon_painC3 ] {dragon_move(12);};
void() dragon_painC3 =[ $drgpan3c, dragon_walk9  ] {dragon_move(12);};

void() dragon_painD1 =[ $drgpan4a, dragon_painD2 ] {dragon_move(12);};
void() dragon_painD2 =[ $drgpan4b, dragon_painD3 ] {dragon_move(12);};
void() dragon_painD3 =[ $drgpan4c, dragon_walk11 ] {dragon_move(12);};

void() dragon_painE1 =[ $drgpan5a, dragon_painE2 ] {dragon_move(12);};
void() dragon_painE2 =[ $drgpan5b, dragon_painE3 ] {dragon_move(12);};
void() dragon_painE3 =[ $drgpan5c, dragon_walk13 ] {dragon_move(12);};

void() dragon_painF1 =[ $drgpan6a, dragon_painF2 ] {dragon_move(12);};
void() dragon_painF2 =[ $drgpan6b, dragon_painF3 ] {dragon_move(12);};
void() dragon_painF3 =[ $drgpan6c, dragon_walk2  ] {dragon_move(12);};

void() DoE_dragon_pain =
{
    if (self.pain_finished > time)
        return;
    if (skill >= 3)
        return;     // PM:  No pain in Nightmare.
    if (self.dragonAttacking)
        return;     // PM:  Don't flinch while attacking.

    if (random() < 0.25)
    {
        dragon_stop_attack();

        sound (self, CHAN_VOICE, "dragon/pain.wav", 1, ATTN_NORM);
        self.pain_finished = time + 2;

        if (self.dragonPainSequence == 1)
            self.think = dragon_painA1;
        else if (self.dragonPainSequence == 2)
            self.think = dragon_painF1;
        else if (self.dragonPainSequence == 3)
            self.think = dragon_painE1;
        else if (self.dragonPainSequence == 4)
            self.think = dragon_painD1;
        else if (self.dragonPainSequence == 5)
            self.think = dragon_painC1;
        else if (self.dragonPainSequence == 6)
            self.think = dragon_painB1;
    }
};

// ===================================
// death
// ===================================
void(string gibname) Accelerate_Gib =
{
    local   vector  vel, spin;

    vel = self.velocity * -1.25;
    makevectors (vel);
    vel = vel + v_right * (random() * 300 - 150);
    vel = vel + v_up * (random() * 300 - 150);

    spin_x = random() * 600;
    spin_y = random() * 600;
    spin_z = random() * 600;

    Gib_Spawn (self.origin, gibname, vel, spin, 0, 0, TRUE, self.spawned);
};

void(float loop) ViolentDeath =
{
    while (loop > 0)
    {
        Accelerate_Gib ("progs/gib1.mdl");
        Accelerate_Gib ("progs/gib2.mdl");
        Accelerate_Gib ("progs/gib3.mdl");
        loop = loop - 3;
    }
};
void() dragon_boom =
{
    self.velocity = self.dragonLastVelocity;
    ViolentDeath(15);
    self.target = "dragondoor";
    SUB_UseTargets();            
    remove(self);
};

void() dragon_nuke =
{
// Lavasplash particles form a box with a size of 270x270x64.
// 135 * 1.4142 = 190.9188.  So use 160 damage for explosion radius of 200.
// Damage first, then effects.
    local   entity  swap;

    T_NewRadiusDamage (self, self, 160, self, DF_ROCKET, "death");
    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
    Tent_Point (TE_LAVASPLASH, self.origin - '0 0 32');

// The big fireball at the center.
    swap = self;
    self = spawn();
    setorigin (self, swap.origin + '0 0 24');
    WarpExplosion ();
    self = swap;
};

void() dragon_parts =
{
    ThrowIt ("progs/drggib01.mdl", -100, GIBx_GIB|GIB_SKIN_MATCH);
    ThrowIt ("progs/drggib02.mdl", -100, GIBx_GIB|GIB_SKIN_MATCH);
    ThrowIt ("progs/drggib03.mdl", -100, GIBx_GIB|GIB_SKIN_MATCH);
    // Was "player/tornoff2.wav".
    sound (self, CHAN_BODY, "player/teledth1.wav", 1, ATTN_NONE);
};

void() dragon_explode = 
{
    if (self.deadflag > DEAD_DYING)
        return;     // Already exploded.
        
    if (vlen(self.velocity) < 100 || self.flags & FL_INWATER)
    {
        self.touch = SUB_Null;
        monster_dead (FALSE);   // It's dead for sure.

        dragon_parts ();
//- - - - - - - - -
        // Explode for massive damage!
        dragon_nuke ();
        Quake_Self (800, 0, self.origin, 0, 1);     // Distance was 600.
//- - - - - - - - -
        // We can't remove dragon now, because this may be called during a
        // touch function, in which case the C code is looping through area
        // links.  Delay removal for a frame.
        self.think = dragon_boom;
        self.nextthink = time + sys_ticrate;
    }
    else
    {
        makevectors (self.angles);
        self.velocity = self.velocity - 40 * v_up;
        self.dragonLastVelocity = self.velocity;
    }
};

void() dragon_squish =
{
    if (other.solid == SOLID_BSP)
    {
        self.velocity = '0 0 0';
        dragon_explode ();
        return;
    }

    if (other.takedamage)   // PM:  Squish anything, not players only.
        T_NewDamage (other, self, self, 200, 0, "dead");
};

void() dragon_death1  =[ $drgdth01, dragon_death2  ]
{
// PM:  deadflag should be set by modified Killed.
//    self.deadflag = DEAD_DYING;
    self.use      = SUB_Null;
    makevectors (self.angles);
    self.velocity = 300 * v_forward - 40 * v_up;
    self.flags    = self.flags - (self.flags & FL_ONGROUND);
    // PM:  Use the bigger hull2 size instead of hull.
    setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
    self.touch    = dragon_squish;

    sound (self, CHAN_VOICE, "dragon/death.wav", 1, ATTN_NONE);
    self.dragonAttacking = FALSE;
};
void() dragon_death2  =[ $drgdth02, dragon_death3  ] {dragon_explode();};
void() dragon_death3  =[ $drgdth03, dragon_death4  ] {dragon_explode();};
void() dragon_death4  =[ $drgdth04, dragon_death5  ] {dragon_explode();};
void() dragon_death5  =[ $drgdth05, dragon_death6  ] {dragon_explode();};
void() dragon_death6  =[ $drgdth06, dragon_death7  ] {dragon_explode();};
void() dragon_death7  =[ $drgdth07, dragon_death8  ] {dragon_explode();};
void() dragon_death8  =[ $drgdth08, dragon_death9  ] {dragon_explode();};
void() dragon_death9  =[ $drgdth09, dragon_death10 ] {dragon_explode();};
void() dragon_death10 =[ $drgdth10, dragon_death11 ] {dragon_explode();};
void() dragon_death11 =[ $drgdth11, dragon_death12 ] {dragon_explode();};
void() dragon_death12 =[ $drgdth12, dragon_death13 ] {dragon_explode();};
void() dragon_death13 =[ $drgdth13, dragon_death14 ] {dragon_explode();};
void() dragon_death14 =[ $drgdth14, dragon_death15 ] {dragon_explode();};
void() dragon_death15 =[ $drgdth15, dragon_death16 ] {dragon_explode();};
void() dragon_death16 =[ $drgdth16, dragon_death17 ] {dragon_explode();};
void() dragon_death17 =[ $drgdth17, dragon_death18 ] {dragon_explode();};
void() dragon_death18 =[ $drgdth18, dragon_death19 ] {dragon_explode();};
void() dragon_death19 =[ $drgdth19, dragon_death20 ] {dragon_explode();};
void() dragon_death20 =[ $drgdth20, dragon_death21 ] {dragon_explode();};
void() dragon_death21 =[ $drgdth21, SUB_Null       ]
{
// PM:  Added explosion and other gibs.
    dragon_parts ();
    dragon_nuke ();
    Quake_Self (600, 0, self.origin, 0, 1);

//    ViolentDeath(39);   // Disintegrate into numerous gibs.
    ViolentDeath(15);
    self.target = "dragondoor";
    SUB_UseTargets();            
    remove(self);
};

///////////////////////////////
void(float hello) dragon_doe_sight =
{
    if (!hello)
        sound (self, CHAN_VOICE, "dragon/see.wav", 1, ATTN_NORM);
};
void() dragon_doe_cache =
{
    precache_model ("progs/dragon.mdl");
//    precache_model ("progs/fireball.mdl");
    precache_model ("progs/drggib01.mdl");
    precache_model ("progs/drggib02.mdl");
    precache_model ("progs/drggib03.mdl");
    precache_model ("progs/plasma.mdl");
    
    precache_sound ("dragon/see.wav");
    precache_sound ("dragon/active.wav");
    precache_sound ("dragon/attack1.wav");
    precache_sound ("dragon/fly1.wav");
    precache_sound ("dragon/flywater.wav");
    precache_sound ("dragon/pain.wav");
    precache_sound ("dragon/death.wav");
    precache_sound ("shambler/smack.wav");
};
/*QUAKED monster_dragon (1 0 0) (-96 -96 -24) (96 96 96) Ambush Pacifist Hunter
//
// Spawnflags:
// Ambush:  Monster wakes up only when it sees a target.
// Pacifist:  Monster wakes up only when hurt.
// Hunter:  Monster will leave its path to seek a target.
*/
// FIXME:  Add spawnflag that lets dragon to fly off the beaten path.
void() monster_dragon_doe =
{
    self.classname = "monster_dragon";  // Original classname.
    self.height = -1;   // For obituary.
    if (!self.spawned)
    {
        if (deathmatch)
            {remove (self); return;}
        dragon_doe_cache ();
    }

    self.dragonAttacking = FALSE;

    if (!self.health)   // PM:  Let mapmaker override default health.
        self.health = 3000 + (1000 * cvar("skill"));
    monster_form ("progs/dragon.mdl", '-96 -96 -24', '96 96 96', self.health, 0);
    
    self.th_stand   = dragon_walk1;
    self.th_walk    = dragon_walk1;
    self.th_run     = dragon_walk1;
    self.th_missile = SUB_Null;     // Constantly changes while walking.
    self.th_pain    = DoE_dragon_pain;
    self.th_die     = dragon_death1;

    self.th_sight   = dragon_doe_sight;
    self.th_move    = Wyrm_WalkMove;
    self.th_goal    = QC_MoveToGoal;

    self.dragonPainSequence=1;
    self.yaw_speed = 10;    // Hardwire this now!
    self.ryuflags = RYU_NO_WATER;
    if (self.spawnflags & 2)    // Pacifist check.
        self.style = self.style | STYLE_CALM;
    if (!(self.spawnflags & 4))    // Hunter check.
        if (self.target)    // Path requires a target.
            self.ryuflags = self.ryuflags | RYU_PATH;

    flymonster_start ();
};

// Morphs the dark lord into the beast.  See 'hknight.qc' for dark lord.
void() darklord_thebeast =
{
    dragon_nuke ();     // Spawn a big explosion.

    self.flags = (self.flags | FL_FLY) - (self.flags & FL_GODMODE);
    self.solid = SOLID_SLIDEBOX;

    // HACK:  For dark lord in unf3.
    if (self.target  != "path_corner")
    if (self.target2 == "path_corner")
    {
        local   string  swap;

        swap = self.target;
        self.target = self.target2;
        self.target2 = swap;
        if (self.target == "path_corner")
        {   // Follow a path.
            self.movetarget = find(world, targetname, self.target);
            self.ryuflags = self.ryuflags | RYU_PATH;
        }
        // ELSE... dragon chases the player.
    }

    // Make sure classname stays at "monster_dark_lord".
    self.classname = "monster_dark_lord";
    self.skin = 1;      // Evil red eye black dragon.

    // Reset attack related stuff.
    self.attack_finished = 0;
    SUB_AttackFinished (2);     // Give player time, unless it's Nightmare+!

    self.dragonAttacking = FALSE;

    self.health = self.max_health - 1000;

    setform (self, "progs/dragon.mdl", '-96 -96 -24', '96 96 96');
    self.mindex2    = self.modelindex;      // Remember new modelindex.
    self.dest1  = '-96 -96 -24';
    self.dest2  = '96 96 96';
    self.spawnskin  = self.skin;
    
    self.th_stand   = dragon_walk1;
    self.th_walk    = dragon_walk1;
    self.th_run     = dragon_walk1;
    self.th_melee   = world.null_func;  // Knights melee, dragon doesn't.
    self.th_missile = SUB_Null;     // Constantly changes while walking.
    self.th_pain    = DoE_dragon_pain;
    self.th_die     = dragon_death1;

    self.th_sight   = dragon_doe_sight;
    self.th_move    = Wyrm_WalkMove;
    self.th_goal    = QC_MoveToGoal;

    self.dragonPainSequence=1;
    self.yaw_speed = 10;    // Hardwire this now!
    self.mass = 0;          // Now it's a huge massive dragon!
    self.bloodtype = BLOOD_RED;     // It's flesh and blood now.
    self.ryuflags = self.ryuflags | RYU_NO_WATER;
    self.xfl      = self.xfl | XFL_IMMUNITY;

    dragon_walk1 ();
};


// =================================================
// dragon corners
// =================================================

//============
// QUAKED dragon_corner (0.5 0.3 0) (-16 -16 -16) (16 16 16)
//
// Only for use with monster_dragon. Use only as transitions 
// between rooms.
//
// PM:  Now it converts into a standard path_corner.
//============
void() dragon_corner = {self.classname = "path_corner"; movetarget_f();};


//===========================/  END OF FILE  /===========================//
