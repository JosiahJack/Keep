/*
==============================================================================

OLD ONE

==============================================================================
*/
$cd id1/models/old_one
$origin 0 0 24
$base base
$skin skin
$scale 1

$frame old1 old2 old3 old4 old5 old6 old7 old8 old9 
$frame old10 old11 old12 old13 old14 old15 old16 old17 old18 old19 
$frame old20 old21 old22 old23 old24 old25 old26 old27 old28 old29 
$frame old30 old31 old32 old33 old34 old35 old36 old37 old38 old39 
$frame old40 old41 old42 old43 old44 old45 old46 

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
$frame shake9 shake10 shake11 shake12 dupe12 shake13 shake14
$frame shake15 shake16 shake17 shake18 shake19 shake20

//============================================================================
// PM:  Model has 201 frames and 9 skins.
// Shub has three stages, and each stage uses 67 frames and 3 skins each.
float   SHUB_FRAMES = 67;

void() finale_arcanum;
void() finale_1;
void() finale_2;
void() finale_3;

// PM:  Removed 'shub' global entity.
//- - - - - - - - -

//==========================================================================
//  Shub Plasma

void() ShubSpike_Explosion =
{
    Rocket_Explosion2 (self.origin, 247, 5);
    BecomeFancy (X56_PLASMA_RED, 6);
};

void() ShubSpike_Think =
{
    if (self.delay <= time)
        {remove (self); return;}

    self.speed   = vlen (self.velocity);
    self.movedir = self.dest = normalize (self.velocity);
    Meteor_Trail (225, 1, FALSE);

    self.nextthink = time + 0.05;

    Ghost_Touch ();     // PM:  Shub's plasma can blast ghosts.
};

void(vector start, vector dir) ShubSpike_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "arrow";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = random() * 200 + 800;     //1000;
    newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dest         = dir;      // for 'spawn_touchblood'.
    if (cranked)
        newmis.dmg          = 90;
    else
        newmis.dmg          = 60;       // Was 60 -- too much.
    newmis.cnt          = 233;
    newmis.style        = DF_SAFE | DF_ROCKET;
//    newmis.effects      = newmis.effects | EF_DIMLIGHT;
    newmis.skin         = 1;
    newmis.oldorigin    = start;
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 5;         // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = ShubSpike_Think;
    newmis.think1       = ShubSpike_Explosion;

    setall (newmis, "progs/plasma1.mdl", '0 0 0', '0 0 0', start);
};

//==========================================================================
//  Attacks

// Launches blood star in a random direction.
void() Shub_Spam =
{
    local   vector  dir, org;

    if (self.waitmin > time)
        return;
    self.waitmin = time + 0.5;

    org = self.origin + '0 0 40';

    dir_x = random() * 120 - 90;
    dir_y = random() * 360;
    dir_z = 0;
    makevectors (dir);
    dir = v_forward;

    if (self.enemy)
        if (random() < 0.1)
            dir = Aim_Line (org, self.enemy.origin, 1000, self.enemy);

    BloodStar_Launch (org, dir);
};

//- - - - - - - - -
void() Shub_Quake_Think =
{
    if (!IsDead (self.owner))
    {
        local   entity  swap;

        swap = self;
        self = self.owner;
        Quake_Level (5, self.origin, 3);
        self = swap;
    }
    remove (self);
};

void() Shub_Quake =
{
    sound (self, 6, "misc/tesla.wav", 1, ATTN_NONE);

    newmis = spawn();
    newmis.owner    = self;
    newmis.solid    = SOLID_NOT;
    newmis.movetype = MOVETYPE_NONE;
    newmis.nextthink= time + 2;
    newmis.think    = Shub_Quake_Think;
    setorigin (newmis, self.origin);
};

//- - - - - - - - -
// Sprays a volley of crimson energy shots at a target.
void() Shub_Fire =
{
    local   vector  org1, org2, dir, err, base1, base2;
//    local   float   loop, sped, hits;
    local   float   loop, hits;

    sound (self, CHAN_WEAPON, "weapons/mirv1.wav", 1, ATTN_NORM);

    if (self.height < 2)
        hits = 4;
    else
        hits = 3;   // Don't shoot so much with starball spam.

// Shub will shoot red stuff from two points, at directions away from
// the origin.  In other words, the basic fire pattern is a V.
//    err = '6 4.5 0';     // arctan(err) = '0.105 0.0787 0'.
//    err = '10 7.5 0';
    err = '5 7.5 0';
    makevectors (self.angles);
    base1 = self.origin + v_forward*104 + v_up*64;
    base2 = v_right*24;
    org1 = base1 + base2;
    org2 = base1 - base2;
// FIXME:  If hard, lead like Chthon.  (Maybe?)
    base1 = Midpoint (self.enemy);
    base2 = normalize (base1 - org2);
    base2 = Maim_Scatter (base2, '-5 0 1');
    base1 = normalize (base1 - org1);
    base1 = Maim_Scatter (base1, '5 0 1');
    loop = hits;
    while (loop > 0)
    {
        loop = loop - 1;
        dir = Maim_Scatter (base1, err);
        ShubSpike_Launch (org1, dir);
    }
    loop = hits;
    while (loop > 0)
    {
        loop = loop - 1;
        dir = Maim_Scatter (base2, err);
        ShubSpike_Launch (org2, dir);
    }
};


//==========================================================================
//  Behavior

// Selects a new target if facing toward it and not its current target.
float() FaceTheNewGuy =
{
    local   entity  targ;
    local   vector  spot1, spot2;
    local   float   yaw, diff;

    spot1 = self.origin + self.view_ofs;
    targ = findradius (spot1, 2000);
    while (targ)
    {
        if (targ.flags & FLx_CREATURE)
        if (targ.health > 0)
        if (targ.solid >= SOLID_TRIGGER)
        if (!targ.invisible_finished)
        if (!(targ.flags & FL_NOTARGET))
        if (!Ally_Check (targ, self))
        {
            spot2 = targ.origin + targ.view_ofs;
            traceline (spot1, spot2, TRUE, self);   // see through other monsters
            if (trace_fraction == 1)
            {   // Target is visible.
                yaw = vectoyaw (spot2 - spot1);
                diff= anglemod(self.angles_y - yaw);
                if ((diff <= 45) || (diff >= 315))
                {   // Facing ideal yaw toward new target.
                    if (!Align_Match (self.enemy, self))
                        self.oldenemy = self.enemy;
                    self.enemy = targ;
                    self.ideal_yaw = yaw;
                    enemy_vis = TRUE;
                    return TRUE;
                }
            }
        }
        targ = targ.chain;
    }
    return FALSE;
};

// Update shield model.
void() old_shield =
{
    if (!self.trigger_field)
    {   // No shields yet?  Create the shield entity.
        self.trigger_field = spawn();
        self.trigger_field.solid = SOLID_NOT;
        self.trigger_field.movetype = MOVETYPE_NONE;
        self.trigger_field.alpha = 0.5;
        setform (self.trigger_field, "progs/shubdome.mdl", '0 0 0', '0 0 0');
    }
    // Make sure the shield sticks around Shub's center.
    setorigin (self.trigger_field, self.origin);

// If you want the shield to damage things, write the code here.
};

// Shield toggles.
void() old_shield_on =
{
    self.xfl = self.xfl | XFL_SHIELDS;
    self.takedamage = DAMAGE_NO;
    old_shield ();
};
void() old_shield_off =
{
    self.xfl = self.xfl - (self.xfl & XFL_SHIELDS);
    self.takedamage = DAMAGE_AIM;
    if (self.trigger_field)
        {remove (self.trigger_field);  self.trigger_field = world;}
};

// Attack behavior -- Face the enemy and fire.
void() old_fight =
{
// Check if we have a target.  If not, find one!
    if (self.enemy.health <= 0)
    {
        self.enemy = self.oldenemy;
        self.oldenemy = world;
        if (self.enemy.health <= 0)
        {
            self.enemy = world;
            FindTarget ();
        }
    }

// Face and attack target.
    if (self.enemy.health > 0)
    {
        ai_face ();

        if (self.attack_finished < time)
        if (modulo(self.skin, 3) == 2)  // Attack only when glow is brightest.
        {
            local   entity  targ;
            local   float   fight, see;

            enemy_vis = visible(self.enemy);

            fight = see = FALSE;
            if (FacingIdeal ())
                see = TRUE;
            if (!see || !enemy_vis)
                if (FaceTheNewGuy ())   // Updates self.enemy and vis if TRUE.
                    see = TRUE;

            targ = self.enemy;
            if (see)
            {
            // Check for melee first.
                self.goalentity = targ;   // So we can use QC_CloseEnough.
                if (enemy_vis)
                if (!targ.deadflag)   // T_Kill only works if DEAD_NO.
                if (targ.th_gib)      // Make sure enemy can be munched.
                if (QC_CloseEnough (32))
                if (fabs(targ.origin_z - self.origin_z) < 40)
                {   // Absorb and grind target.
                    // "Do not pass GO!  Do not collect $200." -- Monopoly.
                    sound (self, CHAN_ITEM, "cube/bc_gulp.wav", 1, ATTN_NORM);
                    T_Kill (targ, self, self, -99, self.classname);
                    fight = TRUE;
                }
                self.goalentity = world;

            // If melee failed, check for shard attack next.
                if (!fight)
                {
                    if (enemy_vis || !self.height)
                        {fight = TRUE;  Shub_Fire ();}
                }
            }
        // If Shub did not attack yet, check for earthquake.
        // FIXME:  Won't work on flyers.  Find another attack against them.
            if (!fight && self.height)      // Must be at least stage 2.
            {
                if (self.waitmax < time)
                    {fight = TRUE;  Shub_Quake ();}
            }

            if (fight)
            {   // Shub has attacked.
                self.attack_finished = time + 5 - skill;
                self.waitmax = time + 8;
                // Change targets.
                if (FindTarget ())
                {   // Aim at the next target.
                    if (!Align_Match (self.enemy, self))
                        self.oldenemy = targ;   // Remember who Shub just attacked.
                }
            }
        }

    // If in final stage (i.e., badly hurt), passively spawn missiles.
        if (self.height == 2)
            Shub_Spam ();
    }
};

// Cycle through its skins to light up its innards.
void() old_pulse =
{
    self.skin = self.height * 3;
    if (self.height == 2)
        self.volume = (self.volume + 1) & 3;
    else if (self.height == 1)
        self.volume = (self.volume + 1) & 7;
    else
        self.volume = (self.volume + 1) & 15;
    if (self.volume & 252 == 0)
    {
        if (self.volume & 1)
            self.skin = self.height * 3 + 1;
        else if (self.volume & 2)
            self.skin = self.height * 3 + 2;
    }
};


//============================================================================

// IDLE - - - - - - - - - - - - - - - -
void() old_idle1   =[ $old1,  old_idle1  ]
{
// Animate monster.
    self.walkframe = self.walkframe + 1;
    if ((self.walkframe < 0) || (self.walkframe >= 46))
    {
        self.walkframe = 0;
        sound (self, CHAN_VOICE, "boss2/sight.wav", 1, ATTN_NORM);
    }
    self.frame = $old1 + self.walkframe + (self.height * SHUB_FRAMES);

// Check for Arcanum bbeg.
    old_pulse();
    if (self.spawnflags & 2)
    {
        // Only the variant gets the shield check.
        if (self.xfl & XFL_SHIELDS)     // Borrowing from mega enforcers...
        {   self.takedamage = DAMAGE_NO;
            old_shield ();
        }
        old_fight();     // Rotate toward and attack enemy.
    }
};

// Note:  This requires spawnflags & 2 to be called as well.
void() old_start =
{
    self.th_stand   =
    self.th_walk    =
    self.th_run     = old_idle1;
    if (self.spawnflags & 4)
        old_shield_on ();
    old_idle1 ();
};

// PAIN - - - - - - - - - - - - - - - -
// Explosion fx for ruptured tentacles.
void(vector spot) old_pop =
{
    Rocket_Explosion2 (spot, 64, 16);
    MakeFancy (spot, X56_SPLASH_RED, 3);
};

void() old_pop2 =
{
    local   entity  swap;
    local   vector  org, spot, vx, vy, vz;

// Without tentacles, top is at about 160 and flat.
    setsize (self, '-128 -128 -24', '128 128 160');
    if (!self.deadflag)
        self.touch = monster_touch; // Top without tentacles is big and flat.

    self.height = 2;
    self.skin   = modulo(self.skin, 3) + 6;
    self.pain_finished = 0;

    makevectors (self.angles);
    vx = v_forward;  vy = v_right;  vz = v_up;
    org = self.origin;

// Spawn dummy entity to serve as a source of gibs.
    swap = self;
    self = spawn();

    spot = org + (vx*48) + (vy*114) + (vz*188);
    old_pop (spot);
    self.origin = spot;
    ThrowGib ("progs/gib1.mdl", -99);
    ThrowGib ("progs/gib2.mdl", -99);
    ThrowGib ("progs/gib3.mdl", -99);

    spot = org + (vx*12) - (vy*112) + (vz*188);
    old_pop (spot);
    self.origin = spot;
    ThrowGib ("progs/gib1.mdl", -99);
    ThrowGib ("progs/gib2.mdl", -99);
    ThrowGib ("progs/gib3.mdl", -99);

    spot = org - (vx*116) + (vz*188);
    old_pop (spot);
    self.origin = spot;
    ThrowGib ("progs/gib1.mdl", -99);
    ThrowGib ("progs/gib2.mdl", -99);
    ThrowGib ("progs/gib3.mdl", -99);

    remove (self);
    self = swap;
};

void() old_pop1 =
{
    local   vector  org, spot, vx, vy, vz;

    self.height = 1;
    self.skin   = modulo(self.skin, 3) + 3;
    self.pain_finished = 0;

    makevectors (self.angles);
    vx = v_forward;  vy = v_right;  vz = v_up;
    org = self.origin;

    spot = org + (vx*32) + (vy*96) + (vz*400);
    old_pop (spot);
    spot = org + (vx*26) - (vy*96) + (vz*400);
    old_pop (spot);
    spot = org - (vx*128) + (vz*384);
    old_pop (spot);
};

void() old_flinch =
{
    self.frame = self.height * SHUB_FRAMES + self.frame;
    self.volume = self.volume & 3;
    old_pulse ();
};
void() old_pain1  =[ $shake1,  old_pain2  ] {old_flinch();};
void() old_pain2  =[ $shake2,  old_pain3  ] {old_flinch();};
void() old_pain3  =[ $shake3,  old_pain4  ] {old_flinch();};
void() old_pain4  =[ $shake4,  old_pain5  ] {old_flinch();};
void() old_pain5  =[ $shake5,  old_pain6  ] {old_flinch();};
void() old_pain6  =[ $shake6,  old_pain7  ] {old_flinch();};
void() old_pain7  =[ $shake7,  old_pain8  ] {old_flinch();};
void() old_pain8  =[ $shake8,  old_pain9  ] {old_flinch();};
void() old_pain9  =[ $shake9,  old_pain10 ] {old_flinch();};
void() old_pain10 =[ $shake10, old_pain11 ] {old_flinch();};
void() old_pain11 =[ $shake11, old_pain12 ] {old_flinch();};
void() old_pain12 =[ $shake12, old_pain13 ] {old_flinch();};
void() old_pain13 =[ $shake13, old_pain14 ] {old_flinch();};
void() old_pain14 =[ $shake14, old_pain15 ] {old_flinch();};
void() old_pain15 =[ $shake15, old_idle1  ] {old_flinch();};

void(entity attacker, float damage) old_pain =
{
// Since shub does not use normal target swapping when hurt,
// get mad at attacker if shub has no current target.
    if (!self.enemy)
        if (attacker.health > 0)
            if (attacker.flags & FLx_CREATURE)
                if (!Ally_Check (attacker, self))
                    self.enemy = attacker;

// Check for tranformations.
    damage = self.height;   // Not using 'damage' for anything else.
    if (self.height < 2)
    {
        if (self.height < 1)
        {
            if (self.health <= self.max_health * 3 / 4)
                old_pop1 ();     // Tips blown off.
        }
        if (self.health <= self.max_health / 2)
            old_pop2 ();     // Tentacles completely blown away.
    }

// Standard pain stuff.
    if (damage == self.height)
    {
        if (self.pain_finished > time)
            return;
    }
    else
    {   // Shub lost some parts, so raise shields back up.
        if (self.spawnflags & 4)
            old_shield_on ();
    }

    self.waitmax = 0;

    self.pain_finished = time + 10;
    self.walkframe = -1;
    sound (self, CHAN_VOICE, "boss2/pain.wav", 1, ATTN_NORM);
    old_pain1 ();
};

// DEATH - - - - - - - - - - - - - - - -
void() old_dying =
{
// Cast some beams of light.
    local   float   beams;

    beams = ((random() * 4) & 3) + 3;
    death_beams (beams);

// Animate model.
    self.frame = self.height * SHUB_FRAMES + self.frame;
    self.volume = self.volume & 1;
    old_pulse ();
};

void() old_thrash1  =[ $shake1,  old_thrash2  ] {
    Quake_Level (0, self.origin, 2);
    Tent_Point (TE_LAVASPLASH, self.origin - '0 0 32');
    lightstyle (0, "m"); old_dying();
};
void() old_thrash2  =[ $shake2,  old_thrash3  ] {lightstyle (0, "k"); old_dying();};
void() old_thrash3  =[ $shake3,  old_thrash4  ] {lightstyle (0, "k"); old_dying();};
void() old_thrash4  =[ $shake4,  old_thrash5  ] {lightstyle (0, "i"); old_dying();};
void() old_thrash5  =[ $shake5,  old_thrash6  ] {lightstyle (0, "g"); old_dying();};
void() old_thrash6  =[ $shake6,  old_thrash7  ] {lightstyle (0, "e"); old_dying();};
void() old_thrash7  =[ $shake7,  old_thrash8  ] {lightstyle (0, "c"); old_dying();};
void() old_thrash8  =[ $shake8,  old_thrash9  ] {lightstyle (0, "a"); old_dying();};
void() old_thrash9  =[ $shake9,  old_thrash10 ] {lightstyle (0, "c"); old_dying();};
void() old_thrash10 =[ $shake10, old_thrash11 ] {lightstyle (0, "e"); old_dying();};
void() old_thrash11 =[ $shake11, old_thrash12 ] {lightstyle (0, "g"); old_dying();};
void() old_thrash12 =[ $shake12, old_thrash13 ] {lightstyle (0, "i"); old_dying();};
void() old_thrash13 =[ $shake13, old_thrash14 ] {lightstyle (0, "k"); old_dying();};
void() old_thrash14 =[ $shake14, old_thrash15 ] {lightstyle (0, "m"); old_dying();};
void() old_thrash15 =[ $shake15, old_thrash16 ] {lightstyle (0, "m"); old_dying();
self.cnt = self.cnt + 1;
if (self.cnt < 3)
    self.think = old_thrash1;
};
void() old_thrash16 =[ $shake16, old_thrash17 ] {lightstyle (0, "g"); old_dying();};
void() old_thrash17 =[ $shake17, old_thrash18 ] {lightstyle (0, "c"); old_dying();};
void() old_thrash18 =[ $shake18, old_thrash19 ] {lightstyle (0, "b"); old_dying();};
void() old_thrash19 =[ $shake19, old_thrash20 ] {lightstyle (0, "a"); old_dying();};
void() old_thrash20 =[ $shake20, old_thrash21 ] {lightstyle (0, "a"); old_dying();};
void() old_thrash21 =[ $shake20, SUB_Null     ]
{
    // throw tons of meat chunks
    local   entity  pl;
    local   string  gibname;
    local   vector  oldo;
    local   float   loop, r, noarc;

    if (self.th_die == finale_arcanum)
        noarc = FALSE;
    else
        noarc = TRUE;

    oldo = self.origin;
    sound (self, CHAN_VOICE, "boss2/pop2.wav", 1, ATTN_NONE);
    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
    Tent_Point (TE_LAVASPLASH, oldo - '0 0 32');

// throw tons of meat chunks
    loop = 20;      // Old code threw 50 gibs -- way too much.
    while (loop > 0)
    {
        r = random();
        if (r < 0.3)                
            gibname = "progs/gib1.mdl";
        else if (r < 0.6)
            gibname = "progs/gib2.mdl";
        else
            gibname = "progs/gib3.mdl";
        ThrowIt (gibname, -99, GIB_EAT|GIB_BODY_FULL);
        loop = loop - 1;
    }

    // Shake things up... harmlessly.
    Quake_Level (0, oldo, 3);
    // Players will get screen flash.
    pl = find (world, classname, "player");
    while (pl)
    {
        // Set dmg.xxx to simulate a nuclear flash.
        if (!intermission_running)
        {
            pl.dmg_inflictor = self;
            pl.dmg_save = 255;      // Screen flash plus view snap.
        }
        Safe_stuffcmd (pl, "bf\n");     // More flash.
        pl = find (pl, classname, "player");
    }

    self.deadflag = DEAD_DEAD;  // Ding Dong the witch is dead!
    Pets_Free (self);

    if (intermission_running && (self.spawnflags & 2 == 0) && noarc)
    {   // Classic finale.
        // start the end text
        WriteByte (MSG_ALL, SVC_FINALE);
        WriteString (MSG_ALL, "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salutes you.");

    // use colormap.  (Works only in WinQuake and some ports like DarkPlaces.)
        if (coop || deathmatch)
            r = 0;
        else
            r = 1;
    
    // put a player model down
        pl = spawn();
        setmodel (pl, "progs/player.mdl");
        oldo = oldo - '32 264 0';
        setorigin (pl, oldo);
        pl.angles   = '0 290 0';
        pl.frame    = 12;   // Formerly 1.  This change gives the actor a gun.
        pl.colormap = r;

    // remove Shubby.
        SUB_Remove ();
    }
    else
    {   // Game on!  Remove Shubby in a ball of fire.
        WarpExplosion ();
    }

// Restore lighting to normal.
    lightstyle (0, "m");    
};

// Death function for Arcanum bbeg.
void() old_die =
{
    old_shield_off ();
    StopSound (self, 6);    // Shut down tesla sfx.
    sound (self, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
    self.cnt = 2;
    old_thrash1 ();

    if (self.height < 2)
    {   // Rupture all surviving tentacles.
        if (self.height < 1)
            old_pop1 ();
        old_pop2 ();
    }
};

//============================================================================

// Modified finale1 for Arcanum.
void() finale_arcanum =
{
    local   entity  pos;
    local   entity  timer;

// DISABLED -- Don't go to start.bsp.
//    pos = find (world, classname, "trigger_changelevel");
//    if (pos)
//        nextmap = pos.map;
//    else
        nextmap = "arcstart";
    gameover = TRUE;    // PM:  Do this so 'StartFrame' doesn't check rules.

    intermission_exittime = time + 5;
    intermission_running = 1;

    // find the intermission spot
    pos = find (world, classname, "info_intermission");
    if (!pos)
        error ("no info_intermission");

    MoveToIntermission (pos);

    WriteByte (MSG_ALL, SVC_INTERMISSION);

    // make fake versions of all players as standins, and move the real
    // players to the intermission spot
    
    // wait for 1 second
    timer = spawn();
    timer.nextthink = time + 1;
    timer.think     = finale_3;
    timer.owner     = self;
};

// 'self' = shub.
void() finale_1 =
{
    local   entity  pos, pl;
    local   entity  timer;

    intermission_exittime = time + 10000000;    // never allow exit
    intermission_running = 1;

    // find the intermission spot
    pos = find (world, classname, "info_intermission");
    if (!pos)
        error ("no info_intermission");
    pl = find (world, classname, "misc_teleporttrain");
    // Update 4/1/09:  If train isn't found, who cares?
    if (pl)     //error ("no teleporttrain");
        remove (pl);

    WriteByte (MSG_ALL, SVC_FINALE);
    WriteString (MSG_ALL, "");

    MoveToIntermission (pos);
    
    // make fake versions of all players as standins, and move the real
    // players to the intermission spot
    
    // wait for 1 second
    timer = spawn();
    timer.nextthink = time + 1;
    timer.think     = finale_2;
    timer.owner     = self;
};

// 'self' = timer entity from finale_1.
void() finale_2 =
{
    // start a teleport splash inside shub
    Tent_Point (TE_TELEPORT, self.owner.origin - '0 100 0');

    sound (self.owner, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
    
    self.nextthink = time + 2;
    self.think = finale_3;
};

// 'self' = timer entity from finale_1.
void() finale_3 =
{
    // start shub thrashing wildly
    if (self.owner)
    {
        self.owner.think = old_thrash1;
        sound (self.owner, CHAN_VOICE, "boss2/death.wav", 1, ATTN_NORM);
    }
    remove (self);
};


//============================================================================


// OTHER - - - - - - - - - - - - - - - -
void() oldone_cache =
{
    precache_gluttony ();

    precache_model ("progs/nehjet.mdl");    // Death beam fx.
    precache_model ("progs/oldone.mdl");

    precache_sound ("boss1/out1.wav");      // For lavasplash fx.
    precache_sound ("boss2/death.wav");
    precache_sound ("boss2/idle.wav");
    precache_sound ("boss2/sight.wav");
    precache_sound ("boss2/pop2.wav");
};

void() oldone_cache2 =
{
    precache_gluttony ();

    precache_model ("progs/needle.mdl");
    precache_model ("progs/plasma1.mdl");   // Rename to pl_star or plastar.
    precache_model ("progs/shubdome.mdl");  // Shields
    precache_model ("progs/shubstar.mdl");  // FIXME:  Rename to dethstar.

    precache_sound ("boss2/pain.wav");      // PM:  Custom
    precache_sound ("misc/tesla.wav");      // Powerup sound for earthquake.
    precache_sound ("weapons/mirv1.wav");   // For spore attack.
};

//============
// --> QUAKED monster_oldone (1 0 0) (-128 -128 -24) (128 128 256) x Mortal Shields
//============
void() monster_oldone =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self);  return;}
        oldone_cache ();
        if (self.spawnflags & 2)
        {   // FIXME:  Spawn shamblers and shal-rath too.
            // She is the hell-mother after all.
            // Update 6/5/2011:  Deferred indefinitely.
            oldone_cache2 ();
        }
    }

//- - - - - - - - -
    if (self.spawnflags & 2)
    {   // Nasty mortal mode.
        local   float   hp;

    // Health:  3000 in Easy, 4000 in Normal, 5000 in Hard, 6000 in Nightmare.
        hp = cvar("skill");
        hp = floor(hp);
        hp = hp * 1000 + 3000;
        monster_form ("progs/oldone.mdl", '-128 -128 -24', '128 128 256', hp, 0);
        self.mass       = 0;    // You can't move this.

        self.th_stand   =
        self.th_walk    =
        self.th_run     = old_start;
        self.th_pain    = old_pain;
        self.th_die     = old_die;
        //- - - - - - - -
        self.th_revive  = monster_oldone;
    
        self.height     = 0;    // As a multi-stage boss, start at stage one.
        self.waitmax    = 0;
        self.walkframe  = -1;   // So animation code starts at $old1.
        self.yaw_speed  = 5;    // Turn slowly due to its massive bulk.

        // Use the path flag so Shub bypasses the enemy check in T_Damage.
        // Shub is immobile so other path related code does not apply to it.
        self.ryuflags   = RYU_ALERT | RYU_PATH;
        self.xfl        = XFL_BOSS;
        monster_start ();
        return;
    }
//- - - - - - - - -

    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_STEP;
    
// Different length and width -- designed exclusively for end.bsp no doubt.
    setform (self, "progs/oldone.mdl", '-160 -128 -24', '160 128 256');

    self.flags      = self.flags | FL_GODMODE;      // Invincible.
    self.bloodtype  = BLOOD_RED;
    self.health     = 40000;    // kill by telefrag
    self.think      = old_idle1;
    self.nextthink  = time + 0.1;    
    self.takedamage = DAMAGE_YES;
    // FIXME:  Level check is an ugly hack.
    if (world.model == "maps/arcanum5.bsp")
        self.th_die     = finale_arcanum;
    else
        self.th_die     = finale_1;
    self.xfl        = XFL_BOSS;     // So crossbow cannot instakill Shubby.
    self.height     = 0;            // Don't use extra scenes in modified mdl.
    
    total_monsters = total_monsters + 1;
};


//===========================/  END OF FILE  /===========================//
