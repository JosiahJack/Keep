/*
==============================================================================

ARMAGON

==============================================================================
*/


$cd hipwork\models\armagon
$origin 0 0 24
$base bodybase.asc
$skin armab

$frame lwalk1.asc lwalk2.asc lwalk3.asc lwalk4.asc lwalk5.asc lwalk6.asc lwalk7.asc
$frame lwalk8.asc lwalk9.asc lwalk10.asc lwalk11.asc lwalk12.asc 

$frame lw0fir1.asc lw0fir2.asc lw0fir3.asc lw0fir4.asc lw0fir5.asc lw0fir6.asc
$frame lw0fir7.asc lw0fir8.asc lw0fir9.asc lw0fir10.asc lw0fir11.asc lw0fir12.asc
$frame lw0fir13.asc

$frame lw1fir1.asc lw1fir2.asc lw1fir3.asc lw1fir4.asc lw1fir5.asc lw1fir6.asc
$frame lw1fir7.asc lw1fir8.asc lw1fir9.asc lw1fir10.asc lw1fir11.asc lw1fir12.asc 
$frame lw1fir13.asc lw1fir14.asc lw1fir15.asc

$frame lw2fir1.asc lw2fir2.asc lw2fir3.asc lw2fir4.asc lw2fir5.asc lw2fir6.asc
$frame lw2fir7.asc lw2fir8.asc lw2fir9.asc lw2fir10.asc lw2fir11.asc lw2fir12.asc 

$frame lsfire1.asc lsfire2.asc lsfire3.asc lsfire4.asc lsfire5.asc lsfire6.asc
$frame lsfire7.asc lsfire8.asc lsfire9.asc lsfire10.asc lsfire11.asc lsfire12.asc 

$frame lstand1.asc lstand2.asc lstand3.asc lstand4.asc lstand5.asc lstand6.asc
$frame lstand7.asc lstand8.asc lstand9.asc lstand10.asc lstand11.asc lstand12.asc
$frame lstand13.asc lstand14.asc lstand15.asc lstand16.asc lstand17.asc
$frame lstand18.asc lstand19.asc lstand20.asc

$frame tranl1.asc tranl2.asc

$frame ldie1.asc ldie2.asc ldie3.asc ldie4.asc ldie5.asc ldie6.asc
$frame ldie7.asc ldie8.asc ldie9.asc ldie10.asc ldie11.asc ldie12.asc

//============================================================================

float ATTN_ARMAGON = 0.5;
float SERVO_VOLUME = 0.5;

float()  ArmagonCheckAttack =
{
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   ang;
    local   float   delta;
    local   float   dist;

    self.lefty = 0;

    targ = self.enemy;

// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    traceline (spot1, spot2, FALSE, self);

    if (trace_ent != targ)      // Removed !self.charmed.
        return FALSE;     // don't have a clear shot
    if (trace_inopen && trace_inwater)
        return FALSE;            // sight line crossed contents
    if (time < self.attack_finished)
        return FALSE;

    ang = self.angles_y + self.fixangle;
    delta = self.ideal_yaw - ang;
    dist = vlen(spot2-spot1);
    // PM:  Removed (self.enemy.classname != "player") check.
    if ((fabs(delta) > 10 && (dist > 200)))
        return FALSE;
    if (dist < 400)
    {   // melee attack
        self.th_melee ();
        return TRUE;
    }
// missile attack
    self.lefty = 1;
//    self.th_missile ();
//    SUB_AttackFinished (1.5*random());
    return FALSE;
};

void(float ofs, float turn) armagon_launch =
{
    local   vector  src, vec, targ;
    local   vector  ang;
    local   float   dist;

    ang = self.angles;
    ang_y = ang_y + self.fixangle;
    if (turn==1)
        ang_y = ang_y + 165;
    else if (turn==2)
        ang_y = ang_y - 165;
    makevectors(ang);
    src = self.origin + '0 0 66' + v_right*ofs + v_forward*84;
    targ = self.enemy.origin + self.enemy.view_ofs;
    if (skill != 0)
        vec = Maim_Line (src, targ, 1000, self.enemy, '0 0 0');
    else
        vec = Maim_Line (src, targ, 1000, world, '0 0 0');
    dist = vec*v_forward;
    if (dist < self.worldtype)
        vec = v_forward;

    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.volume)
        HIP_LaunchLaser (src, vec, 0);
    else
    {   sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
        Rocket_Launch (src, vec);
    }
};

void(float angdelta, float delta) armagon_turn =
{
    if (fabs(angdelta) < 10)
        self.fixangle = delta;
    else
    {
        if (angdelta > 5)
            self.fixangle = self.fixangle + 9;
        else if (angdelta < -5)
            self.fixangle = self.fixangle - 9;
        else
            self.fixangle = delta;
    }
};

//----------
// FIXME:  ???
//----------
void() armagon_body_think =
{
    local   float   delta;
    local   float   angdelta;

    ai_synch ();
//dprint(self.classname); dprint(" / "); dprint (self.trigger_field.classname); dprint("\n");
//    setorigin (self.trigger_field, self.origin);
    self.trigger_field.angles   = self.angles;
    self.trigger_field.frame    = self.frame;
    self.trigger_field.angles_y = self.trigger_field.angles_y + self.fixangle;
    if (self.enemy)
    {
        enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
        self.ideal_yaw = enemy_yaw;
        delta = self.ideal_yaw - self.angles_y;
    }
    else
    {
        ChangeYaw ();
        delta = 0;
    }
    self.cnt = 0;
    if (delta > 180) delta = delta - 360;
    if (delta < -180) delta = delta + 360;
    if (fabs(delta) > 90)
        {delta = 0; self.cnt = 1;}
    angdelta = delta-self.fixangle;
    armagon_turn(angdelta,delta);
//    self.nextthink = time + 0.1;
};

void() armagon_sfx_idle =
{
    if (time > self.waitmin)
    {
        local   float   r;

        self.waitmin = time + 3;
        if (random() < 0.5)
        {
            r = random();
            if (r < 0.25)
                sound (self, CHAN_VOICE, "armagon/idle1.wav", 1, ATTN_ARMAGON);
            else if (r < 0.5)
                sound (self, CHAN_VOICE, "armagon/idle2.wav", 1, ATTN_ARMAGON);
            else if (r < 0.75)
                sound (self, CHAN_VOICE, "armagon/idle3.wav", 1, ATTN_ARMAGON);
            else
                sound (self, CHAN_VOICE, "armagon/idle4.wav", 1, ATTN_ARMAGON);
        }
    }
};

void() armagon_think =
{
    armagon_body_think ();
    if (self.health < 0)
        return;
    armagon_sfx_idle ();
};

void() armagon_walkthink =
{
// PM:  Check for Duel Monsters stuff.
    if (self.master)
    {
        if (!self.ryuflags & RYU_PATROL)
            {self.th_run(); return;}

        if (!MatchingIdeal ())
            ChangeYaw ();
        else if (!walkmove (self.angles_y, 14))
            self.ideal_yaw = anglemod (self.angles_y + 180);
    }
//- - - - - - - - -
    else
        movetogoal (14);    // Normal move.

    armagon_body_think ();
    if (self.health < 0)
        return;
    armagon_sfx_idle ();

    if (self.alignment == GOOD)
    {   // If NPC, use normal targeting code.
        FindTarget ();
    }
    else
    {   // Armagon's original target finding code below.
        local   entity  client;

        client = checkclient ();
        if (client)     // current check entity must be in PVS
            if (client != self.master)  // don't attack its master.
                if (visible (client))
                    {self.enemy = client;  FoundTarget();}  // Got one!
    }
};

void(float righty) armagon_over_think =
{
    local   float   delta;
    local   float   angdelta;

    ChangeYaw ();
    walkmove (self.angles_y, 14);
    ai_synch ();
//dprint(self.classname); dprint(" / "); dprint (self.trigger_field.classname); dprint("\n");
//    setorigin (self.trigger_field, self.origin);
    self.trigger_field.angles = self.angles;
    self.trigger_field.frame = self.frame;
    self.trigger_field.angles_y = self.trigger_field.angles_y + self.fixangle;
    if (self.count == 0)
    {
        enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
        self.ideal_yaw = enemy_yaw;
        if (righty)
            delta = self.ideal_yaw - self.angles_y + 165;
        else
            delta = self.ideal_yaw - self.angles_y - 165;
        if (delta > 180) delta = delta - 360;
        if (delta < -180) delta = delta + 360;
        angdelta = delta-self.fixangle;
    }
    else if (self.count == 1)
    {
        if (righty)
            armagon_launch (-40, 2);
        else
            armagon_launch (40, 1);
        return;
    }
    else
    {
        delta = 0;
        angdelta = delta-self.fixangle;
    }
    armagon_turn (angdelta, delta);
//    self.nextthink = time + 0.1;
};
void() armagon_overleft_think = {armagon_over_think (0);};
void() armagon_overright_think = {armagon_over_think (1);};


//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() armagon_stand_act = {armagon_think(); self.nextthink = time + 0.2;};
void() armagon_stand1  =[ $lstand1.asc,  armagon_stand2  ] {ai_stand(); armagon_stand_act();};
void() armagon_stand2  =[ $lstand2.asc,  armagon_stand3  ] {armagon_stand_act();};
void() armagon_stand3  =[ $lstand3.asc,  armagon_stand4  ] {armagon_stand_act();};
void() armagon_stand4  =[ $lstand4.asc,  armagon_stand5  ] {armagon_stand_act();};
void() armagon_stand5  =[ $lstand5.asc,  armagon_stand6  ] {armagon_stand_act();};
void() armagon_stand6  =[ $lstand6.asc,  armagon_stand7  ] {armagon_stand_act();};
void() armagon_stand7  =[ $lstand7.asc,  armagon_stand8  ] {armagon_stand_act();};
void() armagon_stand8  =[ $lstand8.asc,  armagon_stand9  ] {armagon_stand_act();};
void() armagon_stand9  =[ $lstand9.asc,  armagon_stand10 ] {armagon_stand_act();};
void() armagon_stand10 =[ $lstand10.asc, armagon_stand11 ] {ai_stand(); armagon_stand_act();};
void() armagon_stand11 =[ $lstand11.asc, armagon_stand12 ] {armagon_stand_act();};
void() armagon_stand12 =[ $lstand12.asc, armagon_stand13 ] {armagon_stand_act();};
void() armagon_stand13 =[ $lstand13.asc, armagon_stand14 ] {armagon_stand_act();};
void() armagon_stand14 =[ $lstand14.asc, armagon_stand15 ] {armagon_stand_act();};
void() armagon_stand15 =[ $lstand15.asc, armagon_stand16 ] {armagon_stand_act();};
void() armagon_stand16 =[ $lstand16.asc, armagon_stand17 ] {armagon_stand_act();};
void() armagon_stand17 =[ $lstand17.asc, armagon_stand18 ] {armagon_stand_act();};
void() armagon_stand18 =[ $lstand18.asc, armagon_stand19 ] {armagon_stand_act();};
void() armagon_stand19 =[ $lstand19.asc, armagon_stand20 ] {armagon_stand_act();};
void() armagon_stand20 =[ $lstand20.asc, armagon_stand1  ] {ai_stand(); armagon_stand_act();};

// WALK - - - - - - - - - - - - - - - -
void() armagon_sfx_servo = {sound (self, 7, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);};
void() armagon_sfx_foot = {sound (self, 6, "armagon/footfall.wav", 1, ATTN_ARMAGON);};
void() armagon_walk1  =[ $lwalk1.asc,  armagon_walk2  ] {armagon_walkthink();};
void() armagon_walk2  =[ $lwalk2.asc,  armagon_walk3  ] {armagon_walkthink();};
void() armagon_walk3  =[ $lwalk3.asc,  armagon_walk4  ] {armagon_sfx_servo(); armagon_walkthink();};
void() armagon_walk4  =[ $lwalk4.asc,  armagon_walk5  ] {armagon_walkthink();};
void() armagon_walk5  =[ $lwalk5.asc,  armagon_walk6  ] {armagon_sfx_foot(); armagon_walkthink();};
void() armagon_walk6  =[ $lwalk6.asc,  armagon_walk7  ] {armagon_walkthink();};
void() armagon_walk7  =[ $lwalk7.asc,  armagon_walk8  ] {armagon_walkthink();};
void() armagon_walk8  =[ $lwalk8.asc,  armagon_walk9  ] {armagon_walkthink();};
void() armagon_walk9  =[ $lwalk9.asc,  armagon_walk10 ] {armagon_sfx_servo(); armagon_walkthink();};
void() armagon_walk10 =[ $lwalk10.asc, armagon_walk11 ] {armagon_walkthink();};
void() armagon_walk11 =[ $lwalk11.asc, armagon_walk12 ] {armagon_sfx_foot(); armagon_walkthink();};
void() armagon_walk12 =[ $lwalk12.asc, armagon_walk1  ] {armagon_walkthink();};

// RUN - - - - - - - - - - - - - - - - -
void() armagon_overleft1;
void() armagon_overright1;

void() armagon_run_act =
{
    ChangeYaw();
    ai_run(14);
    armagon_think();
};
void() armagon_run1  =[ $lwalk1.asc,  armagon_run2  ] {armagon_run_act();};
void() armagon_run2  =[ $lwalk2.asc,  armagon_run3  ] {armagon_run_act();};
void() armagon_run3  =[ $lwalk3.asc,  armagon_run4  ] {armagon_sfx_servo(); armagon_run_act();};
void() armagon_run4  =[ $lwalk4.asc,  armagon_run5  ] {armagon_run_act();};
void() armagon_run5  =[ $lwalk5.asc,  armagon_run6  ] {armagon_sfx_foot(); armagon_run_act();};
void() armagon_run6  =[ $lwalk6.asc,  armagon_run7  ] {armagon_run_act();};
void() armagon_run7  =[ $lwalk7.asc,  armagon_run8  ] {armagon_run_act();};
void() armagon_run8  =[ $lwalk8.asc,  armagon_run9  ] {armagon_run_act();};
void() armagon_run9  =[ $lwalk9.asc,  armagon_run10 ] {armagon_sfx_servo(); armagon_run_act();};
void() armagon_run10 =[ $lwalk10.asc, armagon_run11 ] {armagon_run_act();};
void() armagon_run11 =[ $lwalk11.asc, armagon_run12 ] {armagon_sfx_foot(); armagon_run_act();};
void() armagon_run12 =[ $lwalk12.asc, armagon_run1  ]
{
    armagon_run_act();

    if ((self.cnt == 1) && (time > self.attack_finished))
    {
        local   float   delta;
        delta = self.ideal_yaw - self.angles_y;
        if (delta > 180) delta = delta - 360;
        if (delta < -180) delta = delta + 360;
        if (delta>0)
            self.think = armagon_overleft1;
        else
            self.think = armagon_overright1;
        return;
    }
    if (self.lefty == 1)
    {
        self.lefty = 0;
        if (self.enemy)
            self.think = self.th_missile;
    }
};

// ATTACK - - - - - - - - - - - - - - -
void() armagon_stand_attack;

void() armagon_watk_act =
{
    ChangeYaw();
    walkmove (self.angles_y, 14);
    armagon_think();
};
void() armagon_watk1  =[ $lw0fir1.asc,  armagon_watk2  ] {armagon_watk_act();};
void() armagon_watk2  =[ $lw0fir2.asc,  armagon_watk3  ] {armagon_sfx_servo(); armagon_watk_act();};
void() armagon_watk3  =[ $lw0fir3.asc,  armagon_watk4  ] {ChangeYaw();walkmove (self.angles_y, 14);armagon_think();};
void() armagon_watk4  =[ $lw0fir4.asc,  armagon_watk5  ] {armagon_sfx_foot(); armagon_watk_act();};
void() armagon_watk5  =[ $lw0fir5.asc,  armagon_watk6  ] {armagon_watk_act();};
void() armagon_watk6  =[ $lw0fir6.asc,  armagon_watk7  ] {self.volume = random() < 0.5; armagon_watk_act(); armagon_launch(40,0);};
void() armagon_watk7  =[ $lw0fir7.asc,  armagon_watk8  ] {armagon_watk_act();};
void() armagon_watk8  =[ $lw0fir8.asc,  armagon_watk9  ] {armagon_sfx_servo(); armagon_watk_act();};
void() armagon_watk9  =[ $lw0fir9.asc,  armagon_watk10 ] {armagon_watk_act();};
void() armagon_watk10 =[ $lw0fir10.asc, armagon_watk11 ] {armagon_sfx_foot(); armagon_watk_act();};
void() armagon_watk11 =[ $lw0fir11.asc, armagon_watk12 ] {armagon_watk_act(); armagon_launch(-40,0);};
void() armagon_watk12 =[ $lw0fir12.asc, armagon_run1   ] {armagon_watk_act(); SUB_AttackFinished (1.0);};

void() armagon_overleft1   =[ $lw1fir1.asc,  armagon_overleft2   ] {self.count=0;armagon_overleft_think();};
void() armagon_overleft2   =[ $lw1fir2.asc,  armagon_overleft3   ] {armagon_overleft_think();};
void() armagon_overleft3   =[ $lw1fir3.asc,  armagon_overleft4   ] {armagon_sfx_servo();armagon_overleft_think();};
void() armagon_overleft4   =[ $lw1fir4.asc,  armagon_overleft5   ] {armagon_overleft_think();};
void() armagon_overleft5   =[ $lw1fir5.asc,  armagon_overleft6   ] {armagon_sfx_foot();armagon_overleft_think();};
void() armagon_overleft6   =[ $lw1fir6.asc,  armagon_overleft7   ] {armagon_overleft_think();};
void() armagon_overleft7   =[ $lw1fir7.asc,  armagon_overleft8   ] {armagon_overleft_think();};
void() armagon_overleft8   =[ $lw1fir8.asc,  armagon_overleft9   ] {armagon_sfx_servo();armagon_overleft_think();};
void() armagon_overleft9   =[ $lw1fir9.asc,  armagon_overleft10  ] {armagon_overleft_think();};
void() armagon_overleft10  =[ $lw1fir10.asc, armagon_overleft11  ] {armagon_sfx_foot();armagon_overleft_think();};
void() armagon_overleft11  =[ $lw1fir11.asc, armagon_overleft12  ] {self.count=1;armagon_overleft_think();};
void() armagon_overleft12  =[ $lw1fir12.asc, armagon_overleft13  ] {self.count=2;armagon_overleft_think();};
void() armagon_overleft13  =[ $lw1fir13.asc, armagon_overleft14  ] {armagon_overleft_think();};
void() armagon_overleft14  =[ $lw1fir14.asc, armagon_overleft15  ] {armagon_overleft_think();};
void() armagon_overleft15  =[ $lw1fir15.asc, armagon_run1        ] {armagon_overleft_think();SUB_AttackFinished (1.0);};

void() armagon_overright1  =[ $lw2fir1.asc,  armagon_overright2  ] {self.count=0;armagon_overright_think();};
void() armagon_overright2  =[ $lw2fir2.asc,  armagon_overright3  ] {armagon_overright_think();};
void() armagon_overright3  =[ $lw2fir3.asc,  armagon_overright4  ] {armagon_sfx_servo();armagon_overright_think();};
void() armagon_overright4  =[ $lw2fir4.asc,  armagon_overright5  ] {armagon_overright_think();};
void() armagon_overright5  =[ $lw2fir5.asc,  armagon_overright6  ] {armagon_sfx_foot();self.count=1;armagon_overright_think();};
void() armagon_overright6  =[ $lw2fir6.asc,  armagon_overright7  ] {self.count=2;armagon_overright_think();};
void() armagon_overright7  =[ $lw2fir7.asc,  armagon_overright8  ] {armagon_overright_think();};
void() armagon_overright8  =[ $lw2fir8.asc,  armagon_overright9  ] {armagon_sfx_servo();armagon_overright_think();};
void() armagon_overright9  =[ $lw2fir9.asc,  armagon_overright10 ] {armagon_overright_think();};
void() armagon_overright10 =[ $lw2fir10.asc, armagon_overright11 ] {armagon_sfx_foot();armagon_overright_think();};
void() armagon_overright11 =[ $lw2fir11.asc, armagon_overright12 ] {armagon_overright_think();};
void() armagon_overright12 =[ $lw2fir12.asc, armagon_run1        ] {armagon_overright_think();SUB_AttackFinished (1.0);};

void() armagon_plant1 =[ $lstand1.asc, armagon_plant1 ] {armagon_stand_attack(); armagon_think();};

void() armagon_stop1  =[ $tranl1.asc, armagon_stop2   ] {armagon_think();};
void() armagon_stop2  =[ $tranl2.asc, armagon_plant1  ] {sound (self, 6, "armagon/footfall.wav", 1, ATTN_ARMAGON); armagon_think();};


void() armagon_satk1  =[ $lsfire1.asc,  armagon_satk2  ] {armagon_think();};
void() armagon_satk2  =[ $lsfire2.asc,  armagon_satk3  ] {armagon_think();};
void() armagon_satk3  =[ $lsfire3.asc,  armagon_satk4  ] {armagon_think();};
void() armagon_satk4  =[ $lsfire4.asc,  armagon_satk5  ] {armagon_think();};
void() armagon_satk5  =[ $lsfire5.asc,  armagon_satk6  ] {armagon_think();};
void() armagon_satk6  =[ $lsfire6.asc,  armagon_satk7  ] {armagon_sfx_foot(); armagon_think();};
void() armagon_satk7  =[ $lsfire7.asc,  armagon_satk8  ] {armagon_think();};
void() armagon_satk8  =[ $lsfire8.asc,  armagon_satk9  ] {//armagon_think();
self.volume = random() < 0.5;
if (self.volume)    // PM:  Replaced 'currentammo' with 'shots_left'.
    self.shots_left = 5;   // Laser
else
    self.shots_left = 3;   // Rockets
armagon_think();
};
void() armagon_satk9  =[ $lsfire9.asc,  armagon_satk10 ] {armagon_think(); armagon_launch(40,0); armagon_launch(-40,0);};
void() armagon_satk10 =[ $lsfire10.asc, armagon_satk11 ] {//armagon_think();
self.shots_left = self.shots_left - 1;
if (self.shots_left >= 1)
    self.think = armagon_satk9;
armagon_think();
};
void() armagon_satk11 =[ $lsfire11.asc, armagon_satk12 ] {armagon_think();};
void() armagon_satk12 =[ $lsfire12.asc, armagon_plant1 ] {armagon_think(); SUB_AttackFinished (0.3);};

void() armagon_repulse_attack =
{
    armagon_think();
    if (self.state == 0)
    {
        SUB_AttackFinished (0.5);
        sound (self, CHAN_BODY, "armagon/repel.wav", 1, ATTN_NORM);
        self.state = 1;
        return;
    }
    else if (self.state == 1)
    {
        local   entity  head;
        local   vector  dir;

        // look in our immediate vicinity
        head = findradius(self.origin, 300);
        while(head)
        {
            if(!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
            {
                if (visible(head) && (head.health > 0))
                {
                    dir = head.origin - (self.origin - '0 0 24');
                    dir = normalize(dir);
                    head.velocity = head.velocity + dir*1500;
                }
            }
            head = head.chain;
        }
        T_RadiusDamage (self, self, 60, self);
        self.state = 0;
        SUB_AttackFinished (0.1);
    }
//    self.nextthink = time + 0.1;
};

void() armagon_stand_attack =
{
    local   vector  spot1, spot2;

// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = self.enemy.origin + self.enemy.view_ofs;

    traceline (spot1, spot2, FALSE, self);

    if (trace_ent != self.enemy)
        {armagon_run1(); return;}
    if (trace_inopen && trace_inwater)
        {armagon_run1(); return;}

    if (time < self.attack_finished)
        return;

    if (vlen(spot2-spot1) < 200)
        if (self.enemy.classname == "player")
            {armagon_repulse_attack(); return;}

    self.state = 0;

    if (vlen(spot2-spot1) > 450)
        {armagon_run1(); return;}

    armagon_satk1();

    if (self.cnt == 1)
        {armagon_run1(); return;}
};

// PAIN - - - - - - - - - - - - - - - -
// No pain frames, just check for grunts.
void(entity attacker, float damage) armagon_pain =
{
// Removed 'dying' check.

    if (damage < 25)
        return;
    if (self.pain_finished > time)
        return;
    self.pain_finished = time + 2;

    sound (self, CHAN_VOICE, "armagon/pain.wav", 1, ATTN_NORM);
    attacker = attacker;    // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() armagon_body_explode2 =
{
    sound (self , CHAN_AUTO, "misc/longexpl.wav", 1, ATTN_ARMAGON);
    self.think = armagon_body_explode2;
    ThrowArmaGib ("progs/gib1.mdl", -200);
    ThrowArmaGib ("progs/gib2.mdl", -200);
    ThrowArmaGib ("progs/gib3.mdl", -200);
    ThrowArmaGib ("progs/gib1.mdl", -200);
    ThrowArmaGib ("progs/gib2.mdl", -200);
    ThrowArmaGib ("progs/gib3.mdl", -200);
    ThrowArmaGib ("progs/gib1.mdl", -200);
    ThrowArmaGib ("progs/gib2.mdl", -200);
    ThrowArmaGib ("progs/gib3.mdl", -200);
    self.movetype = MOVETYPE_NONE;
    setmodel (self, "progs/s_explod.spr");
    self.solid = SOLID_NOT;
    self.nextthink = time + 0.1;
    s_explode1 ();
};

void() armagon_body_explode1 =
{
    self.think = armagon_body_explode1;
    self.nextthink = time + 0.1;
    if (self.cnt == 0)
    {
        self.count = 0;
    }
    if (self.cnt < 25)
    {
        if (self.cnt > self.count)
        {
            ThrowArmaGib ("progs/gib1.mdl", -100);
            ThrowArmaGib ("progs/gib2.mdl", -100);
            ThrowArmaGib ("progs/gib3.mdl", -100);
            self.count = self.cnt + 1;
        }
        self.cnt = self.cnt + 1;
    }
    else
    {
        self.cnt = 0;
        self.think = armagon_body_explode2;
    }
};

void() armagon_die1  =[ $tranl1.asc, armagon_die2  ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die2  =[ $tranl2.asc, armagon_die3  ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die3  =[ $ldie1.asc,  armagon_die4  ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die4  =[ $ldie2.asc,  armagon_die5  ]
{
    armagon_think();
    multi_explosion( self.origin + '0 0 48', 48, 10, 6, 0.3, 0.3);
    sound (self, CHAN_AUTO, "armagon/death.wav", 1, ATTN_NONE);
    self.nextthink = time + 0.2;
};
void() armagon_die5  =[ $ldie3.asc,  armagon_die6  ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die6  =[ $ldie4.asc,  armagon_die7  ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die7  =[ $ldie5.asc,  armagon_die8  ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die8  =[ $ldie6.asc,  armagon_die9  ] {armagon_think();self.nextthink = time + 2;};   // 2 full seconds.
void() armagon_die9  =[ $ldie7.asc,  armagon_die10 ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die10 =[ $ldie8.asc,  armagon_die11 ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die11 =[ $ldie9.asc,  armagon_die12 ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die12 =[ $ldie10.asc, armagon_die13 ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die13 =[ $ldie11.asc, armagon_die14 ] {armagon_think();self.nextthink = time + 0.2;};
void() armagon_die14 =[ $ldie12.asc, monster_end   ]
{
    local   entity  body;

    armagon_think ();
    multi_explosion (self.origin + '0 0 80', 20, 10, 3, 0.1, 0.5);

// legs
//    self.nextthink  = -1;
    self.movetype   = MOVETYPE_NONE;
    self.takedamage = DAMAGE_NO;
    self.solid      = SOLID_NOT;
    setsize (self, '-32 -32 -24', '32 32 32');
    self.flags      = 0;
    self.gorging    = TRUE;
    self.wait       = time + 5;

// body
    body = self.trigger_field;
    body.nextthink  = -1;
//    body.movetype   = MOVETYPE_NONE;
    body.takedamage = DAMAGE_NO;
    body.solid      = SOLID_NOT;
//    setsize (body, '-32 -32 30', '32 32 64');
    body.think      = armagon_body_explode1;
    body.nextthink  = time + 0.1;
    body.gorging    = TRUE;
};

// PM:  Special void kill in Drake.
void() armagon_void =
{
// Remove the upper body.
    if (self.trigger_field)
        {remove (self.trigger_field);  self.trigger_field = world;}
// Now for the legs.
    monster_void ();
    sound (self, CHAN_AUTO, "armagon/death.wav", 1, ATTN_NONE);
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) armagon_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "armagon/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "armagon/sight.wav", 1, 0.1);
};

void() armagon_cache =
{
    precache_model ("progs/laser.mdl");     // Formerly 'lasrspik.mdl'.
    precache_sound ("hipweap/laserric.wav");
    precache_sound ("hipweap/laserg.wav");
    precache_sound ("misc/shortexp.wav");
    precache_sound ("misc/longexpl.wav");

    precache_model ("progs/armabody.mdl");
    precache_model ("progs/armalegs.mdl");

    precache_sound ("armagon/footfall.wav");
    precache_sound ("armagon/servo.wav");
    precache_sound ("armagon/death.wav");
    precache_sound ("armagon/pain.wav");
    precache_sound ("armagon/repel.wav");
    precache_sound ("armagon/idle.wav");    // PM:  Used as greeting.
    precache_sound ("armagon/sight.wav");
    precache_sound ("armagon/idle1.wav");
    precache_sound ("armagon/idle2.wav");
    precache_sound ("armagon/idle3.wav");
    precache_sound ("armagon/idle4.wav");
};

//============
// --> QUAKED monster_armagon (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//============
void() monster_armagon =
{
    local   entity  body;
    local   float   sk;

    if (!self.spawned)
    {
        if (noenemies)
            {remove(self); return;}
        armagon_cache();
    }

    self.lefty = 0;

    sk = cvar("skill");
    sk = floor(sk);     // PM:  New -- ignore decimals.

// PM:  'self' is the legs, 'body' is head, torso, and arms.
    body = spawn();
    body.origin = self.origin;
    body.origin = body.origin - '0 0 64';

    self.solid = SOLID_SLIDEBOX;
    self.fixangle = 0;
    self.movetype = MOVETYPE_STEP;
    body.solid = SOLID_NOT;
    body.movetype = MOVETYPE_STEP;
    self.trigger_field = body;
    body.trigger_field = self;
//- - - - - - - - -
// Set important custom Drake stuff here.
    body.spawned = self.spawned;    // Affects time when gibs disappear.
    // PM:  Since 'monster_form' isn't called, set move thinking here.
    self.th_move = walkmove;
    self.th_goal = movetogoal;
//- - - - - - - - -

    setmodel (body, "progs/armabody.mdl");
    setmodel (self, "progs/armalegs.mdl");
    body.mindex2 = body.modelindex;

    setsize (self, '-48 -48 -24', '48 48 84');
    setorigin (self, self.origin);
    setorigin (body, body.origin);
    if (sk==0)
        {self.yaw_speed = 5; SUB_FullHealth (2000); self.worldtype = 0.9;}
    else if (sk==1)
        {self.yaw_speed = 9; SUB_FullHealth (2500); self.worldtype = 0.85;}
    else
        {self.yaw_speed = 12; SUB_FullHealth (3500); self.worldtype = 0.75;}

    self.state      = 0;    // Attack state.
    self.waitmin    = 0;    // Idle sfx timer.

    self.th_stand   = armagon_stand1;
    self.th_walk    = armagon_walk1;
    self.th_run     = armagon_run1;
    self.th_missile = armagon_watk1;
    self.th_melee   = armagon_stop1;
    self.th_pain    = armagon_pain;
    self.th_die     = armagon_die1;
    //- - - - - - - -
    self.th_sight   = armagon_sight;
    self.th_check   = ArmagonCheckAttack;
    self.th_void    = armagon_void;
    self.th_spawn   = monster_armagon;

    self.xfl        = XFL_NO_BURN | XFL_BOSS;   // Model is too big to burn.

    monster_start();
};


//===========================/  END OF FILE  /===========================//
