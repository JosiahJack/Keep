/*
==============================================================================

BOSS-ONE

==============================================================================
*/
$cd id1/models/boss1
$origin 0 0 -15
$base base
$skin skin
$scale 5

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10


//- - - - - - - - - - - - - - - - - - -
float   SPAWN_MORTAL    = 2;    // Can be killed by normal damage.
float   SPAWN_MULTISHOT = 4;    // Emulate necros' multi-grenade boss.
float   SPAWN_LOBBER    = 8;    // Shots affected by gravity.

// IDLE - - - - - - - - - - - - - - - -
void() boss_face =
{
// go for another player if multi player
    if (self.enemy.health <= 0 || random() < 0.02)
    {
        if (self.enemy.classname == "player")
            self.enemy = NextPlayer (self.enemy);
        else    // Was attacking an NPC.
            self.enemy = RandomPlayer ();

        if (self.spawnflags & SPAWN_MORTAL)
        {   // If mortal, target NPCs occasionally.
            if (random() < 0.25)
                if (self.enemy != whitey)
                    if (CheckTarget (whitey))
                        self.enemy = whitey;
        }
        // ELSE... ignore npcs since they can't trigger event_lightning.
    }
    ai_face();
};

void() boss_missile1;

void() boss_rise1   =[ $rise1,  boss_rise2    ] {sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);};
void() boss_rise2   =[ $rise2,  boss_rise3    ] {sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM); self.walkframe = 2;};
void() boss_rise3   =[ $rise1,  boss_rise3    ]
{
    self.frame = $rise1 + self.walkframe;
    if ( self.frame >= $rise17 )
        self.think = boss_missile1;
    else
        self.walkframe = self.walkframe + 1;
};

//void() boss_idle1   =[ $walk1,  boss_idle2  ] {}; // Look for other players.
void() boss_idle  =[ $walk1,  boss_idle ]
{
    self.frame = $walk1 + self.walkframe;
    if ( self.frame >= $walk31 )
        self.walkframe = 0;
    else
        self.walkframe = self.walkframe + 1;

// Search for targets!
    self.enemy = checkclient ();
    if (!self.enemy)
        self.enemy = CheckTarget (whitey);
    if (self.enemy)
    {   // Got one!
//        sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
        boss_missile1 ();
    }
};

// ATTACK - - - - - - - - - - - - - - -
// SoE:  Check added so hell lords don't summon meteors at inappropriate times.
float(vector p) M_MeteorCheck =
{
    local   vector  org, spot, vec;

    spot = self.enemy.origin;
    vec = spot - self.origin;
    if (vlen(vec) < 200)
        return FALSE;   // Enemy too close to attacker.

    org = vectoangles (vec);
    makevectors (org);
    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';

    if (vlen(spot - org) < 200)
        return FALSE;   // Not enough time for target to react.

    traceline (self.origin, org, TRUE, self);
    if (trace_fraction < 1)
        return FALSE;   // Spawn point blocked.

    return TRUE;
};

// SoE:  Split off from boss_missile so Hell Lord can use as well.
void(vector p, float sped, float multishot, float toss) boss_meteor =
{
    local   vector  org, vec, d;
//    local   float   sped;

    vec = vectoangles (self.enemy.origin - self.origin);
    makevectors (vec);

    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
// SoE:  Monsters must have unbroken line to spawn point.
// Do that to minimize chances of meteors appearing in the wall.
    if (self.flags & FL_MONSTER)    // Chthon doesn't have this flag.
    {   // If TRUE, self is probably a Hell Lord.
        traceline (self.origin, org, TRUE, self);
        if (trace_fraction < 1)
        {
            org = org - self.origin;
            sped = vlen(org) - 32;
            org = normalize(org);
            org = self.origin + org*sped;
        }
    }
//- - - - - - - - -
//    sped = 300;
    
// lead the player on hard mode
    d = self.enemy.origin;
    if (self.spawnflags & SPAWN_LOBBER)
        d = d + self.enemy.view_ofs;
    if (skill >= 2)
        d = Aim_Lead (org, d, sped, self.enemy);
    vec = normalize (d - org);

    if (multishot)
        Firebomb_Launch (org, vec, sped, 30);
    else
    {   // Classic lavaball.
        Rocket_Launch (org, vec);
        setform (newmis, "progs/lavaball.mdl", VEC_ORIGIN, VEC_ORIGIN);
        newmis.avelocity = '200 100 300';
        newmis.velocity  = vec*sped;
        newmis.nextthink = time + 6;    // Same as spikes.
    }
// Update 8/28/10:  Toss missile for Chthon in unforgiven4.
    if (toss)
    {   // Override velocity for a parabolic flight path.
        // Chthon is the boss -- he can throw stuff as fast as he wants!
        toss = vlen(d - org);
        if (toss > sped * 5)  // Target too far away, speed up the shot!
            sped = toss / 5;
        toss = Aim_TossUp (org, d, sped);
        newmis.velocity = Aim_Toss (org, d, sped, toss, world);
        newmis.velocity = newmis.velocity * sped;
        newmis.velocity_z = newmis.velocity_z + toss;
        newmis.movetype = MOVETYPE_TOSS;
    }
//- - - - - - - - -

    sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
};

void(vector p) boss_missile =
{
    local   float   sped;

    if (self.spawnflags & SPAWN_MORTAL)     // If mortal, speed up shots.
        sped = 500;
    else
        sped = 300;
    boss_meteor (p, sped, self.spawnflags & SPAWN_MULTISHOT, self.spawnflags & SPAWN_LOBBER);

// check for dead enemy
    if (self.enemy.health <= 0)
        {self.enemy = world;  self.walkframe = 0;  boss_idle();}
};

void() boss_missile1  =[ $attack1,  boss_missile2  ] {boss_face();};
void() boss_missile2  =[ $attack2,  boss_missile3  ] {boss_face();};
void() boss_missile3  =[ $attack3,  boss_missile4  ] {boss_face();};
void() boss_missile4  =[ $attack4,  boss_missile5  ] {boss_face();};
void() boss_missile5  =[ $attack5,  boss_missile6  ] {boss_face();};
void() boss_missile6  =[ $attack6,  boss_missile7  ] {boss_face();};
void() boss_missile7  =[ $attack7,  boss_missile8  ] {boss_face();};
void() boss_missile8  =[ $attack8,  boss_missile9  ] {boss_face();};
void() boss_missile9  =[ $attack9,  boss_missile10 ] {boss_missile('100 100 200');};
void() boss_missile10 =[ $attack10, boss_missile11 ] {  //boss_face();};
    if (self.spawnflags & SPAWN_MULTISHOT)
        {ai_face(); boss_missile('100 100 200');}
    else
        boss_face();
};
void() boss_missile11 =[ $attack11, boss_missile12 ] {boss_face();};
void() boss_missile12 =[ $attack12, boss_missile13 ] {boss_face();};
void() boss_missile13 =[ $attack13, boss_missile14 ] {boss_face();};
void() boss_missile14 =[ $attack14, boss_missile15 ] {boss_face();};
void() boss_missile15 =[ $attack15, boss_missile16 ] {boss_face();};
void() boss_missile16 =[ $attack16, boss_missile17 ] {boss_face();};
void() boss_missile17 =[ $attack17, boss_missile18 ] {boss_face();};
void() boss_missile18 =[ $attack18, boss_missile19 ] {boss_face();};
void() boss_missile19 =[ $attack19, boss_missile20 ] {boss_face();};
void() boss_missile20 =[ $attack20, boss_missile21 ] {boss_missile('100 -100 200');};
void() boss_missile21 =[ $attack21, boss_missile22 ] {  //boss_face();};
    if (self.spawnflags & SPAWN_MULTISHOT)
        {ai_face(); boss_missile('100 -100 200');}
    else
        boss_face();
};
void() boss_missile22 =[ $attack22, boss_missile23 ] {boss_face();};
void() boss_missile23 =[ $attack23, boss_missile1  ] {boss_face();};

// PAIN - - - - - - - - - - - - - - - -
void() boss_shocka1  =[ $shocka1,  boss_shocka2  ] {};
void() boss_shocka2  =[ $shocka2,  boss_shocka3  ] {};
void() boss_shocka3  =[ $shocka3,  boss_shocka4  ] {};
void() boss_shocka4  =[ $shocka4,  boss_shocka5  ] {};
void() boss_shocka5  =[ $shocka5,  boss_shocka6  ] {};
void() boss_shocka6  =[ $shocka6,  boss_shocka7  ] {};
void() boss_shocka7  =[ $shocka1,  boss_shocka8  ] {};
void() boss_shocka8  =[ $shocka2,  boss_shocka9  ] {};
void() boss_shocka9  =[ $shocka3,  boss_shocka10 ] {};
void() boss_shocka10 =[ $shocka4,  boss_missile1 ] {};

void() boss_shockb1  =[ $shockb1,  boss_shockb2  ] {};
void() boss_shockb2  =[ $shockb2,  boss_shockb3  ] {};
void() boss_shockb3  =[ $shockb3,  boss_shockb4  ] {};
void() boss_shockb4  =[ $shockb4,  boss_shockb5  ] {};
void() boss_shockb5  =[ $shockb5,  boss_shockb6  ] {};
void() boss_shockb6  =[ $shockb6,  boss_shockb7  ] {};
void() boss_shockb7  =[ $shockb1,  boss_shockb8  ] {};
void() boss_shockb8  =[ $shockb2,  boss_shockb9  ] {};
void() boss_shockb9  =[ $shockb3,  boss_shockb10 ] {};
void() boss_shockb10 =[ $shockb4,  boss_missile1 ] {};

// PM:  Note, Chthon dies at the end of this pain anim.
// Don't change that because at least one custom map (by czg) uses an
// info_notnull hack to call them at the end of the level to kill Chthon.
void() boss_shockc1  =[ $shockc1,  boss_shockc2  ] {};
void() boss_shockc2  =[ $shockc2,  boss_shockc3  ] {};
void() boss_shockc3  =[ $shockc3,  boss_shockc4  ] {};
void() boss_shockc4  =[ $shockc4,  boss_shockc5  ] {};
void() boss_shockc5  =[ $shockc5,  boss_shockc6  ] {};
void() boss_shockc6  =[ $shockc6,  boss_shockc7  ] {};
void() boss_shockc7  =[ $shockc1,  boss_shockc8  ] {};
void() boss_shockc8  =[ $shockc2,  boss_shockc9  ] {};
void() boss_shockc9  =[ $shockc3,  boss_shockc10 ] {};
void() boss_shockc10 =[ $shockc4,  boss_death1   ] {};

// PM:  Custom pain scene for mortal Chthon based on $shockc frames.
void() boss_painc1  =[ $shockc5,  boss_painc2   ] {};
void() boss_painc2  =[ $shockc6,  boss_painc3   ] {};
void() boss_painc3  =[ $shockc1,  boss_painc4   ] {};
void() boss_painc4  =[ $shockc2,  boss_painc5   ] {};
void() boss_painc5  =[ $shockc3,  boss_painc6   ] {};
void() boss_painc6  =[ $shockc4,  boss_missile1 ] {};

// PM:  Pain function for mortal variant.
void(entity attacker, float damage) boss_pain =
{
    if (self.pain_finished > time)
        return;     // Don't make multiple pain sounds right after each other.

    //- - - - - - - - -
    // PM:  Since Chthon does not have FL_MONSTER, always make him mad
    //  at anyone who hurts him.  Chthon will pick targets randomly later.
    if (attacker.health > 0)    // Always FALSE if attacker==world.
        if (attacker != self)
            self.enemy = attacker;
    //- - - - - - - - -

    if (random()*100 > damage)
        return;     // didn't flinch

    if (random() < 0.5)
        sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);        
    else
        sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
    self.pain_finished = time + 5;      // Doesn't show pain often.

    if (skill >= 3)
        return;     // No pain anims in Nightmare.

    damage = random();
    if (damage < 0.333)
        boss_shocka5 ();
    else if (damage < 0.666)
        boss_shockb5 ();
    else
        boss_painc1 ();
};

// DEATH - - - - - - - - - - - - - - - -
void() boss_death1 = [$death1, boss_death2] {self.deadflag = DEAD_DYING; sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);};
void() boss_death2 = [$death2, boss_death3] {};
void() boss_death3 = [$death3, boss_death4] {};
void() boss_death4 = [$death4, boss_death5] {};
void() boss_death5 = [$death5, boss_death6] {};
void() boss_death6 = [$death6, boss_death7] {};
void() boss_death7 = [$death7, boss_death8] {};
void() boss_death8 = [$death8, boss_death9] {};
void() boss_death9 = [$death9, boss_death10]
{
    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
    Tent_Point (TE_LAVASPLASH, self.origin);
};
void() boss_death10 = [$death9, boss_death10]
{
    self.deadflag = DEAD_DEAD;
    killed_monsters = killed_monsters + 1;
    WriteByte (MSG_ALL, SVC_KILLEDMONSTER);    // FIXME: reliable broadcast
    SUB_UseTargets ();
    remove (self);
};

// PM:  Death function for mortal variant when killed by damage.
void() boss_die =
{
    local   float   loop;

// Note:  Chthon cannot be gibbed, shattered, or decapitated.

// Gib shower borrowed from Ace Dave's Chthon patch.
    loop = 2;   // Was 3.
    while (loop > 0)
    {
        ThrowGib ("progs/gib1.mdl", -100);
        ThrowGib ("progs/gib2.mdl", -100);
        ThrowGib ("progs/gib3.mdl", -100);
        loop = loop - 1;
    }
    boss_death1 ();
};


// OTHER - - - - - - - - - - - - - - - -
float   BOSS_DAMAGE     = 2000;   // Health lost when hit by event_lightning.
float   BOSS_HEALTH     = 5000;   // Must be greater than 2x and no higher
                                  //  than 3x boss_damage to emulate old hp.

void() boss_awake =
{
//- - - - - - - - -
    self.use        = SUB_Null;     // PM:  Now that he's up, don't use again.
    self.deadflag   = DEAD_NO;      // PM:  It's alive!
    self.view_ofs   = '0 0 160';
    self.bloodtype  = BLOOD_FIRE;
    self.resist_fire= 1;            // Immune!
    self.ryuflags   = RYU_ALERT;    // Don't let cross contents block vis.
//- - - - - - - - -
    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_STEP;
    if (self.spawnflags & SPAWN_MORTAL)
    {   // Custom mortal mode.
        self.th_pain    = boss_pain;
        self.th_die     = boss_die;

        self.takedamage = DAMAGE_AIM;
        self.alignment  = EVIL;     // So NPCs will attack on sight.
    }
    else
    {   // Classic invincible mode.
        self.takedamage = DAMAGE_YES;                   // Was DAMAGE_NO.
        self.flags      = self.flags | FL_GODMODE;      // Invincible.
    }
    // Give xfl_boss so crossbow doesn't change health.
    self.xfl        = self.xfl | XFL_FIREANGEL | XFL_BOSS;
    
    setform (self, "progs/boss.mdl", '-128 -128 -24', '128 128 256');
    self.mass       = 0;    // You can't move this.

    // Old way gave 1 hp on Easy, 3 hp on higher skills.
    if (!self.health)       // Adjustable hp only if mortal.
    {   // Default health.
        if (skill == 0)
            self.health = BOSS_DAMAGE;
        else
            self.health = BOSS_HEALTH;
    }
    SUB_FullHealth (self.health);
    // Chthon does not gib in Drake, so no need to set gib_health.

    self.enemy = activator;

    Tent_Point (TE_LAVASPLASH, self.origin);

    self.pain_finished = time + 1.5;    // PM:  Don't interrupt rising anim.
    self.yaw_speed = 20;
    boss_rise1 ();
};


//============
// --> QUAKED monster_boss (1 0 0) (-128 -128 -24) (128 128 256) x Mortal Multishot Lobber
//============
void() monster_boss =
{
// PM:  Don't bother with spawned or other summon related stuff.
    if (noenemies)
        {remove(self);  return;}

// PM:  Lightning precaches done at event_lightning instead of here.
    precache_blood (BLOOD_FIRE);

    precache_model ("progs/boss.mdl");
    precache_model ("progs/lavaball.mdl");

    precache_sound ("boss1/out1.wav");
    precache_sound ("boss1/sight1.wav");
    precache_sound ("boss1/throw.wav");
    precache_sound ("boss1/pain.wav");
    precache_sound ("boss1/death.wav");
    precache_sound ("boss1/explode.wav");   // For necros style firebombs.
    precache_sound ("boss1/explode2.wav");  // Ditto.
    precache_sound ("boss1/explode3.wav");  // Ditto.

    total_monsters = total_monsters + 1;

    self.use = boss_awake;
    self.takedamage = DAMAGE_NO;    // PM:  He's asleep right now.
    // PM:  Remove spawnflags that shouldn't apply to Chthon.
    self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNx_RESERVED);
};

//===========================================================================

entity  le1, le2;
float   lightning_end;

void() lightning_fire =
{
    local   vector  p1, p2;
    
    if (time >= lightning_end)
    {    // done here, put the terminals back up
        self = le1;
        door_go_down ();
        self = le2;
        door_go_down ();
        return;
    }
    
    p1 = (le1.mins + le1.maxs) * 0.5;
    p1_z = le1.absmin_z - 16;
    
    p2 = (le2.mins + le2.maxs) * 0.5;
    p2_z = le2.absmin_z - 16;
    
    // compensate for length of bolt
    p2 = p2 - normalize(p2-p1)*100;

    self.nextthink = time + 0.1;
    self.think = lightning_fire;

    Tent_Beam (TE_LIGHTNING3, world, p1, p2);
};

void() lightning_use =
{
    if (lightning_end >= time + 1)
        return;

    le1 = find( world, target, "lightning");
    le2 = find( le1, target, "lightning");
    if (!le1 || !le2)
    {
        dprint ("missing lightning targets\n");
        return;
    }
    
    if (
     (le1.state != STATE_TOP && le1.state != STATE_BOTTOM)
    || (le2.state != STATE_TOP && le2.state != STATE_BOTTOM)
    || (le1.state != le2.state) )
    {
//        dprint ("not aligned\n");
        return;
    }

// don't let the electrodes go back up until the bolt is done
    le1.nextthink = -1;
    le2.nextthink = -1;
    lightning_end = time + 1;

    sound (self, CHAN_VOICE, "misc/power.wav", 1, ATTN_NORM);
    lightning_fire ();        

// advance the boss pain if down
    self = find (world, classname, "monster_boss");
    if (!self)
        return;
    self.enemy = activator;
    // PM:  Make sure Chthon is awake.
    if (le1.state == STATE_TOP && self.takedamage && !self.deadflag)
    {
        sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);
        self.pain_finished = time + 5;  // Don't let other damage interrupt.
        self.health = self.health - BOSS_DAMAGE;    //1;
        if (self.health > BOSS_DAMAGE)  //>= 2)
            boss_shocka1();
        else if (self.health > 0)   //== 1)
            boss_shockb1();
        else //if (self.health == 0)
            boss_shockc1();
    }
};


//============
// --> QUAKED event_lightning (0 1 1) (-16 -16 -16) (16 16 16)
// Just for boss level.
//============
void() event_lightning =
{
    precache_model ("progs/bolt3.mdl");     // for boss shock
    precache_sound ("misc/power.wav");
    self.use = lightning_use;
};


//===========================/  END OF FILE  /===========================//
