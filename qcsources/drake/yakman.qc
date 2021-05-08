/*
==============================================================================

YAKMAN
(Also known as Shuffler or Gauroch in Kinn's Bastion and Marcher.)

==============================================================================
*/

$cd id1/models/yakman
$origin 0 0 24
$base base        
$skin skin

$frame bwalk1 bwalk2 bwalk3 bwalk4 bwalk5 bwalk6 bwalk7 bwalk8 bwalk9
$frame bwalk10 bwalk11 bwalk12 bwalk13 bwalk14 bwalk15 bwalk16 bwalk17
$frame bwalk18 bwalk19 bwalk20 bwalk21 bwalk22 bwalk23 bwalk24

$frame charge1 charge2 charge3 charge4 charge5 charge6 charge7 charge8
$frame charge9 charge10 charge11 charge12

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17
$frame death18 death19 death20 death21 death22 death23 death24 death25

$frame gorech1 gorech2 gorech3 gorech4 gorech5 gorech6 gorech7 gorech8
$frame gorech9 gorech10 gorech11 gorech12

$frame howl1 howl2 howl3 howl4 howl5 howl6 howl7 howl8 howl9 howl10
$frame howl11 howl12 howl13 howl14 howl15 howl16 howl17 howl18 howl19
$frame howl20 howl21 howl22 howl23 howl24 howl25 howl26 howl27 howl28
$frame howl29 howl30 howl31 howl32 howl33 howl34 howl35 howl36

$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10
$frame jump11 jump12 jump13 jump14 jump15 jump16 jump17 jump18 jump19
$frame jump20 jump21 jump22 jump23 jump24

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8 shake9
$frame shake10 shake11 shake12 shake13 shake14 shake15 shake16 shake17
$frame shake18 shake19 shake20

$frame shard1 shard2 shard3 shard4 shard5 shard6 shard7 shard8 shard9
$frame shard10 shard11 shard12 shard13 shard14 shard15 shard16 shard17
$frame shard18 shard19 shard20 shard21 shard22 shard23 shard24 shard25
$frame shard26 shard27 shard28 shard29 shard30 shard31 shard32

$frame slidel1 slidel2 slidel3 slidel4 slidel5

$frame slider1 slider2 slider3 slider4 slider5

$frame wait1 wait2 wait3 wait4 wait5 wait6 wait7 wait8 wait9 wait10
$frame wait11 wait12 wait13 wait14 wait15 wait16 wait17 wait18 wait19
$frame wait20 wait21 wait22 wait23 wait24

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24

// DISABLED -- Adding decapitation scene exceeds 256 frames unless some
// of the above scenes are removed.  Thus, they are in a separate model.
//$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9
//$frame decap10 decap11 decap12 decap13 decap14 decap15 decap16 decap17
//$frame decap18 decap19 decap20 decap21 decap22 decap23 decap24 decap25

// Note:  Sliding speeds:  ? 4 8 8 4.

//=============================================================================

void() yak_stomp =
{   // Running.
    if (self.flags & FL_ONGROUND)
        sound (self, CHAN_FOOT, "yakman/step2.wav", 1, ATTN_NORM);
};

void() yak_footstep =
{   // Walking.
    if (self.flags & FL_ONGROUND)
        sound (self, CHAN_FOOT, "yakman/step1.wav", 1, ATTN_NORM);
};

void() yak_idle =
{
    sound (self, CHAN_VOICE, "yakman/breathe1.wav", 1, ATTN_IDLE);
};

// WIN - - - - - - - - - - - - - - - - -
void() yakman_summon =
{
    if (self.enemy)         // Must be attacking someone.
    {
        local   vector  spot;
        local   float   ang;
        local   entity  who;

    // Set ideal_yaw so we can use FacingIdeal, then set it back.
        ang = self.ideal_yaw;
        self.ideal_yaw = vectoyaw (self.enemy.origin - self.origin);
        if (!FacingIdeal ())
            self.ideal_yaw = self.angles_y;
//- - - - - - - - -
        spot = '0 0 0';
        spot_y = ((anglemod (self.ideal_yaw + 45) / 90) & 3) * 90;
//- - - - - - - - -
        self.ideal_yaw = ang;

    //dprint(ftos(self.angles_y)); dprint("/"); dprint(ftos(spot_y)); dprint("\n");

    // NOTE:  If desired monster is too big, it won't spawn -- too bad.
    // This means no dragons or other fatso critters allowed.
        makevectors (spot);
        if ( self.frame == $howl23 )
            spot = (v_forward*34) - (v_right*68);   // 3rd, left.
        else if ( self.frame == $howl21 )
            spot = (v_forward*34) + (v_right*68);   // 2nd, right.
        else
            spot = v_forward * 68;      // 1st, mid.
        spot = self.origin + spot + '0 0 39';
        who = summon_data (self.summontarget);
        if (who)
            summon_func (self, who, spot, FALSE, EntryPoint_One);
        else if ( self.frame == $howl19 )
        {   // Summon weaker version of itself.
            self.spawnflags = self.spawnflags - 2;
            replicate (spot, FALSE, EntryPoint_One);
            self.spawnflags = self.spawnflags + 2;
        }
    }
};

void() yakman_howl1  =[ $howl1,  yakman_howl2  ] {sound (self, CHAN_VOICE, "yakman/big3.wav", 1, ATTN_NORM);};
void() yakman_howl2  =[ $howl3,  yakman_howl3  ] {};
void() yakman_howl3  =[ $howl5,  yakman_howl4  ] {};
void() yakman_howl4  =[ $howl7,  yakman_howl5  ] {};
void() yakman_howl5  =[ $howl9,  yakman_howl6  ] {};
void() yakman_howl6  =[ $howl11, yakman_howl7  ] {};
void() yakman_howl7  =[ $howl13, yakman_howl8  ] {};
void() yakman_howl8  =[ $howl15, yakman_howl9  ] {};
void() yakman_howl9  =[ $howl17, yakman_howl10 ] {};
void() yakman_howl10 =[ $howl19, yakman_howl11 ] {yakman_summon();};
void() yakman_howl11 =[ $howl21, yakman_howl12 ] {yakman_summon();};
void() yakman_howl12 =[ $howl23, yakman_howl13 ] {yakman_summon();};
void() yakman_howl13 =[ $howl25, yakman_howl14 ] {};
void() yakman_howl14 =[ $howl27, yakman_howl15 ] {};
void() yakman_howl15 =[ $howl29, yakman_howl16 ] {};
void() yakman_howl16 =[ $howl31, yakman_howl17 ] {};
void() yakman_howl17 =[ $howl33, yakman_howl18 ] {};
void() yakman_howl18 =[ $howl35, monster_sow   ] {
    if (self.enemy)
        self.think = self.th_run;
};

// STAND - - - - - - - - - - - - - - - -
void() yakman_stand3 =
{
    if (self.walkframe == 24)   // Will cycle back to $walk1.
        if (random() < 0.2)
            sound (self, CHAN_VOICE, "yakman/breathe3.wav", 1, ATTN_IDLE);
    WalkFrame_Add ( $wait1, 1, 23 );
    ai_stand();
};
void() yakman_stand2 =[ $wait1,  yakman_stand2  ] {yakman_stand3();};
void() yakman_stand1 =
{
    if (( self.frame < $wait1 ) || ( self.frame > $wait24 ))
        self.walkframe = 0;
    yakman_stand2 ();
};

// WALK/RUN - - - - - - - - - - - - - -
// Walking animation.  Used by walking and running.
// 6 6 6 5 4 5 4 3 3 4 5 6 6 6 6 5 4 4 4 3 2 4 5 7
//  12 9 9 6 9 12 12 9 8 5 9 13
void(float mad) yakman_anim =
{
    local   float   move;

    if (self.walkframe == 24)
        if (random() < 0.2)
            sound (self, CHAN_VOICE, "yakman/breathe1.wav", 1, ATTN_IDLE);
    WalkFrame_Add ( $walk1, 2, 22 );

    if (( self.frame == $walk1 ) || ( self.frame == $walk3 ) ||
    ( self.frame == $walk13 ) || ( self.frame == $walk15 ))
        move = 12;
    else if (( self.frame == $walk7 ) || ( self.frame == $walk19 ))
    {
        move = 5;   //6;
        yak_footstep ();
    }
    else if (( self.frame == $walk9 ) || ( self.frame == $walk21 ))
        move = 4;   //6;
    else    // walk5,11,17,23
        move = 9;   //8;

    if (mad)
        ai_run (move);
    else
        ai_walk (move);
};

void() yakman_reset =
{
    if (( self.frame < $walk1 ) || ( self.frame > $walk24 ))
        self.walkframe = 0;
};

void() yakman_walk2 =[ $walk1,  yakman_walk2 ] {yakman_anim(FALSE);};
void() yakman_walk1 = {yakman_reset(); yakman_walk2();};

void() yakman_run2  =[ $walk1,  yakman_run2  ] {yakman_anim(TRUE);};
void() yakman_run1  = {yakman_reset(); yakman_run2();};

void() yakman_jump1   =[ $jump7,    yakman_jump2  ] {};
void() yakman_jump2   =[ $jump9,    yakman_jump3  ] {};
void() yakman_jump3   =[ $jump11,   yakman_jump4  ] {};
void() yakman_jump4   =[ $jump13,   yakman_jump5  ] {};
void() yakman_jump5   =[ $jump15,   yakman_jump6  ] {};
void() yakman_jump6   =[ $jump17,   yakman_jump7  ] {};
void() yakman_jump7   =[ $jump19,   yakman_jump8  ] {};
void() yakman_jump8   =[ $jump21,   yakman_jump9  ] {};
void() yakman_jump9   =[ $jump23,   yakman_run1   ] {};

// ATTACK - - - - - - - - - - - - - - -
void() yakman_stop1   =[ $gorech1,  yakman_stop2  ] {safe_goal(40);};
void() yakman_stop2   =[ $gorech3,  yakman_stop3  ] {safe_goal(30);};
void() yakman_stop3   =[ $gorech5,  yakman_stop4  ] {safe_goal(40); yak_stomp();};
void() yakman_stop4   =[ $gorech7,  yakman_stop5  ] {safe_goal(40);};
void() yakman_stop5   =[ $gorech9,  yakman_stop6  ] {safe_goal(30);};
void() yakman_stop6   =[ $gorech11, yakman_run1   ] {
    self.waitmax = time + 5;    // Don't charge again for 5 sec.
    safe_goal (40);
    yak_stomp ();
};

// Note:  'd' must be higher than 32 to hit a client.
void(float d) yak_run =
{
    local   entity  targ;
    local   vector  dir, org, vel;
    local   float   damage;

    targ = self.enemy;

    if (targ)
    if (!IsGhost (targ))    // Update 8/25/10:  Can't slam ghosts!
    if (QC_CloseEnough (d))
    {
        if (infront (targ))
        if (CanDamage (targ, self))
        {   // We can ram the target!
            d = d / 2;
            if (!QC_CloseEnough (d))
            {   // Move the yakman a bit closer for appearance sake.
                safe_move (self.angles_y, d);
                ai_face ();
            }

            makevectors (self.angles);
            dir = v_forward;

            sound (self, CHAN_WEAPON, "yakman/crash.wav", 1, ATTN_NORM);
            if (targ.mass && (targ.mass <= MASS_SUPER))
            {   // Send the victim flying back.
                vel = dir * 400;
                if (targ.flags & FL_ONGROUND)
                {   // Knock the target up off the ground a bit.
                    targ.flags = targ.flags - FL_ONGROUND;
                    vel_z = 200;
                }
                targ.velocity = targ.velocity + vel;
            }
            damage = SUB_MeleeDamage (20);
            T_NewDamage (targ, self, self, damage, DF_NONE, "charge");
        // Fling some gore.
            org = self.origin + v_forward*16;
            dir = v_forward*100 + v_right*(random() * 200);
            SpawnMeatSpray (org, dir, targ.bloodtype);
            dir = v_forward*100 + (random() * -200) * v_right;
            SpawnMeatSpray (org, dir, targ.bloodtype);
        // Get out of the charge anim.
            if (self.health > 0)    // Confirm gauroch is alive after impact.
            {
                if ( self.frame == $charge1 )
                    self.think = yakman_stop2;
                else if ( self.frame == $charge3 )
                    self.think = yakman_stop3;
                else if ( self.frame == $charge5 )
                    self.think = yakman_stop4;
                else if ( self.frame == $charge7 )
                    self.think = yakman_stop5;
                else if ( self.frame == $charge9 )
                    self.think = yakman_stop6;
                else
                    self.think = yakman_stop1;
            }
            return;
        }
    // Not facing the target?
        ai_face ();
        return;
    }
// Run toward the target.
    if (safe_move (self.angles_y, d))
        ai_face ();
    else
        safe_goal (d / 2);      // Bump around obstacles.
};

void() yakman_charge1   =[ $charge1,  yakman_charge2  ] {yak_run(40);};
void() yakman_charge2   =[ $charge3,  yakman_charge3  ] {yak_run(30);};
void() yakman_charge3   =[ $charge5,  yakman_charge4  ] {yak_run(40); yak_stomp();};
void() yakman_charge4   =[ $charge7,  yakman_charge5  ] {yak_run(40);};
void() yakman_charge5   =[ $charge9,  yakman_charge6  ] {yak_run(30);};
void() yakman_charge6   =[ $charge11, yakman_charge1  ] {yak_run(40); yak_stomp();
    if (time > self.waitmax)
    {
        self.waitmax = time + 5;    // Don't charge again for 5 sec.
        self.think = self.th_run;
    }
};

// walk5->bwalk7...bwalk17->walk19
// walk17->bwalk19...bwalk5->walk7
// 12 12 9 5 4 9
void(float side) yakman_slam =
{
    local   float   ldmg;
    local   vector  org, vel;

    self.encore = 1;    // Flagged so he may attempt missile interrupt later.
    sound (self, CHAN_WEAPON, "baron/woosh.wav", 1, ATTN_NORM);

    if (!self.enemy)
        return;
    if (!CanDamage (self.enemy, self))
        return;

    if (!InMeleeRange (100))
        return;
    if (IsGhost (self.enemy))
        return;     // Not allowed to hit wraith.

    ldmg = SUB_MeleeDamage (20);
    T_NewDamage (self.enemy, self, self, ldmg, DF_NONE, "melee");
    sound (self, CHAN_WEAPON, "yakman/slam.wav", 1, ATTN_NORM);     // Overrides woosh.

    makevectors (self.angles);

// Toss the enemy around.
    if (self.enemy.mass && (self.enemy.mass <= MASS_SUPER))
    {   // Respect my custom mass rules.
        self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
        self.enemy.velocity = (v_forward * 50) + (v_right*(100*side)) + '0 0 300';
        if (self.enemy.mass == MASS_SUPER)
            self.enemy.velocity = self.enemy.velocity * 0.5;
    }

// Spawn some chunks from the impact.
    org = self.origin + v_forward*16 + '0 0 12';// + v_up*37;
    vel = v_right * side * (random() * 200);
    SpawnMeatSpray (org, vel, self.enemy.bloodtype);
// DISABLED -- Stock Quake monsters spawn only one.
//    vel = v_right * side * (random() * 200);
//    SpawnMeatSpray (org, vel, self.enemy.bloodtype);
};

void() yakman_left1   =[ $bwalk19, yakman_left2   ] {ai_charge(5); yak_footstep();};
void() yakman_left2   =[ $bwalk21, yakman_left3   ] {ai_charge(4);};
void() yakman_left3   =[ $bwalk23, yakman_left4   ] {ai_charge(9);};
void() yakman_left4   =[ $bwalk1,  yakman_left5   ] {ai_charge(12); yakman_slam(-1);};
void() yakman_left5   =[ $bwalk3,  yakman_left6   ] {ai_charge(12);};
void() yakman_left6   =[ $bwalk5,  yakman_left7   ] {ai_charge(9);
    if (cranked)
    {   // Double backhand check.
        if (!self.cnt)
            {self.think = yakman_run2; self.walkframe = 6;}
        self.cnt = !self.cnt;
    }
};
void() yakman_left7   =[ $bwalk7,  yakman_run2    ] {ai_charge(5); yak_footstep(); self.walkframe = 8;};

void() yakman_right1  =[ $bwalk7,  yakman_right2  ] {ai_charge(5); yak_footstep();};
void() yakman_right2  =[ $bwalk9,  yakman_right3  ] {ai_charge(4);};
void() yakman_right3  =[ $bwalk11, yakman_right4  ] {ai_charge(9);};
void() yakman_right4  =[ $bwalk13, yakman_right5  ] {ai_charge(12); yakman_slam(1);};
void() yakman_right5  =[ $bwalk15, yakman_right6  ] {ai_charge(12);};
void() yakman_right6  =[ $bwalk17, yakman_right7  ] {ai_charge(9);
    if (cranked)
    {   // Double backhand check.
        if (!self.cnt)
            {self.think = yakman_run2; self.walkframe = 18;}
        self.cnt = !self.cnt;
    }
};
void() yakman_right7  =[ $bwalk19, yakman_run2    ] {ai_charge(5); yak_footstep(); self.walkframe = 20;};

void() yakman_melee =
{
    if ( self.frame == $walk7 )
        yakman_right1 ();
    else if ( self.frame == $walk19 )
        yakman_left1 ();
    else if (self.encore && (random() < 0.1))
        self.th_missile ();
    else
        ai_charge (9);
};

void(vector left, vector right) yak_magic =
{
    local   entity  targ;
    local   vector  dir, spot;
    local   float   sped, frac;

    targ = self.enemy;
    frac = Frac_ShotDown ();
    sped = 1000;
    spot = self.enemy.origin + self.enemy.view_ofs;     //Midpoint (self.enemy);
    makevectors (self.angles);
    left = self.origin + (v_forward*left_x) + (v_right*left_y) + (v_up*left_z);
    right = self.origin + (v_forward*right_x) + (v_right*right_y) + (v_up*right_z);
    dir = Maim_LineEx (left, spot, sped, targ, '5 5 0', frac);
    YakStar_Launch (left, dir, 1000);
    dir = Maim_LineEx (left, spot, sped, targ, '5 5 0', frac);
    YakStar_Launch (right, dir, 1000);
};

void(vector left, vector right) yak_glitter =
{
    local   vector  up;

    up = '0 0 2';
    makevectors (self.angles);
    left = self.origin + (v_forward*left_x) + (v_right*left_y) + (v_up*left_z);
    right = self.origin + (v_forward*right_x) + (v_right*right_y) + (v_up*right_z);
    if (self.skin == 2)
    {
        particle (left, up, 233, 10);
        particle (right, up, 233, 10);
    }
    else if (self.skin == 1)
    {
        particle (left, up, 105, 10);
        particle (right, up, 105, 10);
    }
    else
    {
        particle (left, up, 41, 5);
        particle (right, up, 41, 5);
        particle (left, up, 209, 5);
        particle (right, up, 209, 5);
    }
};

void() yakman_shard1  =[ $shard1,  yakman_shard2  ] {ai_face();};
void() yakman_shard2  =[ $shard3,  yakman_shard3  ] {ai_face();};
void() yakman_shard3  =[ $shard5,  yakman_shard4  ] {ai_face();};
void() yakman_shard4  =[ $shard7,  yakman_shard5  ] {ai_face(); yak_glitter('6 -20 88', '-14 50 53');};
void() yakman_shard5  =[ $shard9,  yakman_shard6  ] {ai_face(); yak_glitter('-6 -41 78', '-18 48 70');};
void() yakman_shard6  =[ $shard11, yakman_shard7  ] {ai_face(); yak_glitter('8 -38 64', '-20 41 77');};
void() yakman_shard7  =[ $shard13, yakman_shard8  ] {ai_face(); yak_glitter('26 -22 52', '18 33 70');};
void() yakman_shard8  =[ $shard15, yakman_shard9  ] {ai_face(); yak_glitter('38 -9 48', '36 9 42');};
void() yakman_shard9  =[ $shard17, yakman_shard10 ] {ai_face();
    self.shots_max = self.shots_left = 3;
    sound (self, CHAN_WEAPON, "yakman/firefblt.wav", 1, ATTN_NORM);
    yak_magic('26 -5 50', '26 8 42');
};
void() yakman_shard10 =[ $shard19, yakman_shard11 ] {ai_face(); yak_magic('14 -1 54', '15 11 45');};
void() yakman_shard11 =[ $shard21, yakman_shard12 ] {ai_face(); yak_magic('26 -5 54', '26 10 45');};
void() yakman_shard12 =[ $shard23, yakman_shard13 ] {ai_face();
    if (cranked)
        {yak_magic('38 -9 48', '36 9 42');}
};
void() yakman_shard13 =[ $shard25, yakman_shard14 ] {ai_face();};
void() yakman_shard14 =[ $shard27, yakman_shard15 ] {ai_face();};
void() yakman_shard15 =[ $shard29, yakman_shard16 ] {ai_face();};
void() yakman_shard16 =[ $shard31, yakman_run1    ] {ai_face();};

void() yakman_missile =
{
    self.encore = 0;    // Take our shot.

// Check for charge.
    if (time > self.waitmax)
    if (fabs(self.enemy.origin_z - self.origin_z) < 48)
    if (vlen(self.enemy.origin - self.origin) > 120)    //< 512)
    if (random() < 0.7)
    {
        self.waitmax = time + 10;   // Maximum time for charging.
        yakman_charge1 ();
        return;
    }

// Check for summoning.
    if (self.xfl & XFL_BOSS)
        if (random() < (5 - self.pets) * 0.1)
            {yakman_howl1();  return;}

// Fling some magic.
    yakman_shard1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() yakman_pain1   =[ $pain2,   yakman_pain2   ] {};
void() yakman_pain2   =[ $pain4,   yakman_pain3   ] {};
void() yakman_pain3   =[ $pain6,   yakman_pain4   ] {};
void() yakman_pain4   =[ $pain8,   yakman_run1    ] {};

void() yakman_shake1  =[ $shake2,  yakman_shake2  ] {};
void() yakman_shake2  =[ $shake4,  yakman_shake3  ] {};
void() yakman_shake3  =[ $shake6,  yakman_shake4  ] {};
void() yakman_shake4  =[ $shake8,  yakman_shake5  ] {};
void() yakman_shake5  =[ $shake10, yakman_shake6  ] {};
void() yakman_shake6  =[ $shake12, yakman_shake7  ] {};
void() yakman_shake7  =[ $shake14, yakman_shake8  ] {};
void() yakman_shake8  =[ $shake16, yakman_shake9  ] {};
void() yakman_shake9  =[ $shake18, yakman_shake10 ] {};
void() yakman_shake10 =[ $shake20, yakman_run1    ] {};

void(entity attacker, float damage) yakman_pain =
{
// don't make multiple pain sounds right after each other
    if (self.pain_finished > time)
        return;

// FIXME:  Use shambler or Hexen2's yakman damage check?
    if (random() * self.health > damage)
        return;     // Hexen2's way of checking noflinch for this guy.
//    if (random()*400 > damage)      // Same as shambler.
//        return;     // didn't flinch

    self.pain_finished = time + 2;  //T+1
    if (SUB_IgnorePain ())
    {   // Play pain sound only, no animation.
        sound (self, CHAN_VOICE, "yakman/pain.wav", 1, ATTN_NORM);
        return;
    }

// Gauroch will reel in pain.
    self.walkframe = 0;
    if (random() < 0.5)
    {   sound (self, CHAN_VOICE, "yakman/pain.wav", 1, ATTN_NORM);
        yakman_pain1 ();
    }
    else
    {   sound (self, CHAN_VOICE, "yakman/big1.wav", 1, ATTN_NORM);
        yakman_shake1 ();
    }

    attacker = attacker;    // Appease compiler.
};


// DEATH - - - - - - - - - - - - - - - -
// Headless model is not the same as yakman.mdl.
void() yakman_decap1  =[ 0,  yakman_decap3  ] {blood_spray('-18 0 66', 1);};
void() yakman_decap2  =[ 2,  yakman_decap3  ] {ai_forward(2); blood_spray('-14 1 64', 1);};
void() yakman_decap3  =[ 4,  yakman_decap4  ] {ai_forward(4); blood_spray('-7 2 62', 2); monster_drop();};
void() yakman_decap4  =[ 6,  yakman_decap5  ] {ai_forward(8); blood_spray('-1 3 59', 1);};
void() yakman_decap5  =[ 8,  yakman_decap6  ] {ai_forward(10); blood_spray('1 4 55', -1);};
void() yakman_decap6  =[ 10, yakman_decap7  ] {ai_forward(12);}; //blood_spray('0 4 49', -1);};
void() yakman_decap7  =[ 12, yakman_decap8  ] {ai_forward(11);};
void() yakman_decap8  =[ 14, yakman_decap9  ] {monster_drop(); ai_forward(10);};
void() yakman_decap9  =[ 16, yakman_decap10 ] {};
void() yakman_decap10 =[ 18, yakman_decap11 ] {};
void() yakman_decap11 =[ 20, yakman_decap12 ] {};
void() yakman_decap12 =[ 22, yakman_decap13 ] {};
void() yakman_decap13 =[ 24, decap_end      ] {};

void() yakman_die1  =[ $death1,   yakman_die2   ] {};
void() yakman_die2  =[ $death3,   yakman_die3   ] {ai_forward(2);};
void() yakman_die3  =[ $death5,   yakman_die4   ] {ai_forward(4);};
void() yakman_die4  =[ $death7,   yakman_die5   ] {ai_forward(8);};
void() yakman_die5  =[ $death9,   yakman_die6   ] {ai_forward(10);};
void() yakman_die6  =[ $death11,  yakman_die7   ] {ai_forward(12);};
void() yakman_die7  =[ $death13,  yakman_die8   ] {ai_forward(11);};
void() yakman_die8  =[ $death15,  yakman_die9   ] {monster_drop(); ai_forward(10);};
void() yakman_die9  =[ $death17,  yakman_die10  ] {};
void() yakman_die10 =[ $death19,  yakman_die11  ] {};
void() yakman_die11 =[ $death21,  yakman_die12  ] {};
void() yakman_die12 =[ $death23,  yakman_die13  ] {};
void() yakman_die13 =[ $death25,  monster_end   ] {};

float(float dm) yakman_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_yak.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() yakman_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        self.model = "progs/yakman2.mdl";   // For the headless body newmis.
        monster_decap ('-18 0 66', yakman_decap1);
        return;
    }

// check for gib
    if (yakman_gib (self.health))
        return;

    sound (self, CHAN_VOICE, "yakman/death.wav", 1, ATTN_NORM);
    yakman_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() yakman_revive1  =[ $death23,  yakman_revive2  ] {};
void() yakman_revive2  =[ $death21,  yakman_revive3  ] {};
void() yakman_revive3  =[ $death19,  yakman_revive4  ] {};
void() yakman_revive4  =[ $death17,  yakman_revive5  ] {};
void() yakman_revive5  =[ $death15,  yakman_revive6  ] {};
void() yakman_revive6  =[ $death13,  yakman_revive7  ] {};
void() yakman_revive7  =[ $death11,  yakman_revive8  ] {};
void() yakman_revive8  =[ $death9,   yakman_revive9  ] {};
void() yakman_revive9  =[ $death7,   yakman_revive10 ] {};
void() yakman_revive10 =[ $death5,   yakman_revive11 ] {};
void() yakman_revive11 =[ $death3,   yakman_revive12 ] {};
void() yakman_revive12 =[ $death1,   yakman_revive13 ] {};
void() yakman_revive13 =[ $howl11,   yakman_revive14 ] {};
void() yakman_revive14 =[ $howl9,    yakman_revive15 ] {};
void() yakman_revive15 =[ $howl7,    yakman_revive16 ] {};
void() yakman_revive16 =[ $howl5,    yakman_revive17 ] {};
void() yakman_revive17 =[ $howl3,    yakman_revive18 ] {};
void() yakman_revive18 =[ $howl1,    yakman_run1     ] {};

//============================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) yakman_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "yakman/breathe1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "yakman/big3.wav", 1, ATTN_NORM);
};

void() yakman_cache =
{
    precache_model ("progs/yakman.mdl");
    precache_model ("progs/yakman2.mdl");   // Decapitated model.
    precache_model ("progs/h_yak.mdl");
    precache_model ("progs/s_kinn.spr");    // Kinn's starburst sprites.

    precache_sound ("baron/woosh.wav");
    precache_sound ("yakman/big1.wav");
    precache_sound ("yakman/big3.wav");
    precache_sound ("yakman/breathe1.wav");
    precache_sound ("yakman/breathe3.wav");
    precache_sound ("yakman/crash.wav");
    precache_sound ("yakman/death.wav");
    precache_sound ("yakman/expsmall.wav");
    precache_sound ("yakman/firefblt.wav");
    precache_sound ("yakman/pain.wav");
    precache_sound ("yakman/slam.wav");
    precache_sound ("yakman/step1.wav");
    precache_sound ("yakman/step2.wav");
};

//============
// --> QUAKED monster_yakman (1 0 0) (-32 -32 -24) (32 32 64) Ambush Boss
//============
void() monster_yakman =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        yakman_cache ();
    }

// Use Kinn's version as a base.
    local   float   hp;

    if (self.spawnflags & 2)
        {hp = 1800;  self.xfl = XFL_BOSS;}
    else
        hp = 1200;
    monster_form ("progs/yakman.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, hp, -80);
    self.mdl_head   = "progs/h_yak.mdl";
    self.mass       = MASS_HEAVY;

    self.th_stand   = yakman_stand1;
    self.th_walk    = yakman_walk1;
    self.th_run     = yakman_run1;
    self.th_melee   = yakman_melee;
    self.th_missile = yakman_missile;
    self.th_pain    = yakman_pain;
    self.th_die     = yakman_die;
    //- - - - - - - -
    self.th_jump    = yakman_jump1;
    self.th_sight   = yakman_sight;
    self.th_gib     = yakman_gib;
    self.th_revive  = yakman_revive1;
    self.th_spawn   = monster_yakman;
    self.th_win     = yakman_howl1;

    self.waitmax    = 0;    // Charge attack timer.

    monster_start ();
};

// Convert Hexen2's yakman to Kinn's shuffler.
void() monster_shuffler =
    {self.classname = "monster_yakman";  monster_yakman();};


//===========================/  END OF FILE  /===========================//
