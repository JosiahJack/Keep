/*
=============================================================================

DRONE

=============================================================================
*/

$cd /raid/quake/id1/models/drone1
$origin 0 0 -24
$base base
$skin skin
$scale 1

$frame base1

$frame cam1 cam2 cam3 cam4 cam5 cam6 cam7 cam8 cam9 cam10 cam11 

$frame att1 att2 att3 att4 att5 att6

$frame idl1 idl2 idl3 idl4 idl5 idl6 idl7 idl8 idl9 idl10

$frame paa1 paa2 paa3 paa4 paa5

$frame pab1 pab2 pab3 pab4 pab5

//============================================================================

void(float offset) drone_fire =
{
// Weapon jam code similar to OUM drone.  Original patch didn't have this.
// Update:  In Drake, jam only if under half health.
    if (self.health < self.max_health / 2)
    {   // Weapon may jam if damaged.  OUM mod.
        local   float   jam;

        jam = 4 - skill;
        if (self.volume < jam)
            if (random()*4 < jam)
            {   // Weapon jammed!
                sound (self, CHAN_VOICE, "drone/drngasp.wav", 0.6, ATTN_NORM);
                self.volume = self.volume + 1;
                return;
            }
    }

// Weapon fire code.
    local   vector  org, dir;
    local   float   glow;

    // Don't give all shots light, just some of them.
    glow = 0;
    if (self.tracer_time < time)
    {   glow = LF_GLOW;
        self.tracer_time = time + 0.25;
    }

    self.effects = self.effects | EF_MUZZLEFLASH;
    makevectors (self.angles);
    
    // PM:  Make lasers come out of the gun.
    org = self.origin + (v_forward * -2) + (v_right * -2) + (v_up * -6);

    // PM:  Default to standard lasers.  (Original was too strong anyway.)
    // Original sound was "enforcer/enfire.wav".
    sound (self, CHAN_WEAPON, "drone/enfire.wav", 1, ATTN_NORM);
    dir = normalize(self.enemy.origin + v_right * offset - org);
    dir = Maim_Scatter (dir, '0 0 0');  // Drake:  Added for invisibility.
    Laser_Launch (org, dir, glow);      // Was 'LaunchLaser (org, dir);'
    SUB_AttackFinished (3);     // PM:  Was 4.
};


// STAND - - - - - - - - - - - - - - - -
void(float choice) drn_sfx_idle =
{
    if (self.spawnflags & 1)
        return;     // Don't beep while in ambush mode.
    if (random() < 0.25)
    {
        if (choice && (random() < 0.25))
            sound (self, CHAN_VOICE, "drone/drnidle2.wav", 0.6, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_NORM);
    }
};
void()  drn_stand1  =[  $idl1,  drn_stand2  ] {ai_stand();};
void()  drn_stand2  =[  $idl2,  drn_stand3  ] {self.effects = self.effects | EF_DIMLIGHT; ai_stand();};
void()  drn_stand3  =[  $idl3,  drn_stand4  ] {ai_stand();};
void()  drn_stand4  =[  $idl4,  drn_stand5  ] {ai_stand();};
void()  drn_stand5  =[  $idl5,  drn_stand6  ] {drn_sfx_idle(FALSE);ai_stand();};
void()  drn_stand6  =[  $idl6,  drn_stand7  ] {ai_stand();};
void()  drn_stand7  =[  $idl7,  drn_stand8  ] {ai_stand();};
void()  drn_stand8  =[  $idl8,  drn_stand9  ] {ai_stand();};
void()  drn_stand9  =[  $idl9,  drn_stand10 ] {ai_stand();};
void()  drn_stand10 =[  $idl1,  drn_stand1  ] {drn_sfx_idle(TRUE);ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void()  drn_walk1   =[  $idl1,  drn_walk2   ] {self.effects = self.effects | EF_DIMLIGHT; ai_walk(8);};
void()  drn_walk2   =[  $idl2,  drn_walk3   ] {ai_walk(8);};
void()  drn_walk3   =[  $idl3,  drn_walk4   ] {ai_walk(8);};
void()  drn_walk4   =[  $idl4,  drn_walk5   ] {ai_walk(8);};
void()  drn_walk5   =[  $idl5,  drn_walk6   ] {drn_sfx_idle(FALSE);ai_walk(8);};
void()  drn_walk6   =[  $idl6,  drn_walk7   ] {ai_walk(8);};
void()  drn_walk7   =[  $idl7,  drn_walk8   ] {ai_walk(8);};
void()  drn_walk8   =[  $idl8,  drn_walk9   ] {ai_walk(8);};
void()  drn_walk9   =[  $idl9,  drn_walk10  ] {ai_walk(8);};
void()  drn_walk10  =[  $idl1,  drn_walk1   ] {drn_sfx_idle(TRUE);ai_walk(8);};

// RUN - - - - - - - - - - - - - - - - -
void()  drn_sfx_run =
{
    if (random() < 0.25)
    {
        if (self.health < self.max_health / 2)
            sound (self, CHAN_VOICE, "drone/drngasp.wav", 0.6, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
    }
};
void()  drn_runa1   =[  $idl1,  drn_runa2   ] {ai_run(13);};
void()  drn_runa2   =[  $idl2,  drn_runa3   ] {ai_run(13);};
void()  drn_runa3   =[  $idl3,  drn_runa4   ] {ai_run(13);};
void()  drn_runa4   =[  $idl4,  drn_runa5   ] {ai_run(13);};
void()  drn_runa5   =[  $idl5,  drn_runa6   ] {drn_sfx_run();ai_run(13);};
void()  drn_runa6   =[  $idl6,  drn_runa7   ] {ai_run(13);};
void()  drn_runa7   =[  $idl7,  drn_runa8   ] {ai_run(13);};
void()  drn_runa8   =[  $idl8,  drn_runa9   ] {ai_run(13);};
void()  drn_runa9   =[  $idl9,  drn_runa10  ] {ai_run(13);};
void()  drn_runa10  =[  $idl1,  drn_run     ] {drn_sfx_run();ai_run(13);};

// Note:  Original patch had strafe after run.
void(float d) ai_drone_move = {ai_run_strafe(d); ai_run(d);};
void()  drn_runb1   =[  $idl1,  drn_runb2   ] {ai_drone_move(13);};
void()  drn_runb2   =[  $idl2,  drn_runb3   ] {ai_drone_move(13);};
void()  drn_runb3   =[  $idl3,  drn_runb4   ] {ai_drone_move(13);};
void()  drn_runb4   =[  $idl4,  drn_runb5   ] {ai_drone_move(13);};
void()  drn_runb5   =[  $idl5,  drn_runb6   ] {drn_sfx_run();ai_drone_move(13);};
void()  drn_runb6   =[  $idl6,  drn_runb7   ] {ai_drone_move(13);};
void()  drn_runb7   =[  $idl7,  drn_runb8   ] {ai_drone_move(13);};
void()  drn_runb8   =[  $idl8,  drn_runb9   ] {ai_drone_move(13);};
void()  drn_runb9   =[  $idl9,  drn_runb10  ] {ai_drone_move(13);};
void()  drn_runb10  =[  $idl1,  drn_run     ] {drn_sfx_run();ai_drone_move(13);};

void()  drn_run =
{
// In case light was shut off due to powerup code.
    self.effects = self.effects | EF_DIMLIGHT;
// PM:  If running after master when not in combat, don't strafe.
    if ((random() < 0.5) || (!self.enemy))
        drn_runa1 ();   // Straight in.
    else
        drn_runb1 ();   // Strafe.
};

// ATTACK - - - - - - - - - - - - - - -
void()  drn_atta1   =[  $att1,  drn_atta2   ] {ai_face();drone_fire(125);};
void()  drn_atta2   =[  $att2,  drn_atta3   ] {ai_face();drone_fire(75);};
void()  drn_atta3   =[  $att3,  drn_atta4   ] {ai_face();drone_fire(25);};
void()  drn_atta4   =[  $att4,  drn_atta5   ] {ai_face();drone_fire(0);};
void()  drn_atta5   =[  $att5,  drn_atta6   ] {ai_face();drone_fire(-25);};
void()  drn_atta6   =[  $att6,  drn_atta7   ] {ai_face();drone_fire(-75);};
void()  drn_atta7   =[  $cam1,  drn_atta8   ] {ai_face();drone_fire(-125);self.volume = 0;};
void()  drn_atta8   =[  $cam2,  drn_atta9   ] {ai_face();};
void()  drn_atta9   =[  $cam3,  drn_atta10  ] {ai_face();};
void()  drn_atta10  =[  $cam4,  drn_atta11  ] {ai_face();};
void()  drn_atta11  =[  $cam5,  drn_atta12  ] {ai_face();};
void()  drn_atta12  =[  $cam6,  drn_atta13  ] {ai_face();};
void()  drn_atta13  =[  $cam7,  drn_atta14  ] {ai_face();};
void()  drn_atta14  =[  $cam8,  drn_atta15  ] {ai_face();};
void()  drn_atta15  =[  $cam9,  drn_atta16  ] {ai_face();};
void()  drn_atta16  =[  $cam10, drn_atta17  ] {ai_face();};
void()  drn_atta17  =[  $cam10, drn_atta18  ] {ai_face();};
void()  drn_atta18  =[  $cam10, drn_run     ] {ai_face();};

// PAIN - - - - - - - - - - - - - - - -
void()  drn_paina1  =[  $paa1,  drn_paina2  ] {};
void()  drn_paina2  =[  $paa2,  drn_paina3  ] {};
void()  drn_paina3  =[  $paa3,  drn_paina4  ] {};
void()  drn_paina4  =[  $paa4,  drn_run     ] {self.nextthink = time + 0.2;};

void()  drn_painb1  =[  $pab1,  drn_painb2  ] {};
void()  drn_painb2  =[  $pab2,  drn_painb3  ] {};
void()  drn_painb3  =[  $pab3,  drn_painb4  ] {};
void()  drn_painb4  =[  $pab4,  drn_run     ] {self.nextthink = time + 0.2;};

void() drn_pain =
{
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 0.4;
    // Original sound was "items/itembk2.wav".
    if (random() < 0.75)
        sound (self, CHAN_VOICE, "drone/drnpain.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "drone/drnpain2.wav", 1, ATTN_NORM);

    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    self.state = !self.state;   // PM:  Shed spikes every other time.
    if (self.state)
        ThrowJunk ("progs/spike.mdl", -10);

    if (random() < 0.5)
        drn_paina1 ();
    else
        drn_painb1 ();
};

// DEATH - - - - - - - - - - - - - - - -
// Note:  In standard Quake, drone keeps on glowing.  In Drake, all lights
// turn off on death, so add some of the light back.
void()  drn_die1    =[  $paa5,  drn_die2    ]
{
    self.takedamage = DAMAGE_NO;
    // Original sound was "misc/basekey.wav".
    sound (self, CHAN_VOICE, "drone/drndeth.wav", 1, ATTN_NORM);
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z =  100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
};
void()  drn_die2    =[  $paa1,  drn_die3    ] {};
void()  drn_die3    =[  $paa2,  drn_die4    ] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()  drn_die4    =[  $paa3,  drn_die5    ] {};
void()  drn_die5    =[  $paa4,  drn_die6    ] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()  drn_die6    =[  $paa5,  drn_die7    ] {};
void()  drn_die7    =[  $base1, SUB_Null    ]
{
    self.deadflag = DEAD_DEAD;
    // Don't bother dropping stuff. //monster_drop ();
    Pets_Free (self);

    ThrowGib ("progs/spike.mdl", -100);
    ThrowGib ("progs/spike.mdl", -100);
    ThrowGib ("progs/spike.mdl", -100);
    ThrowGib ("progs/spike.mdl", -100);
    ThrowGib ("progs/drngib1.mdl", -65);
    ThrowGib ("progs/drngib2.mdl", -65);
    ThrowGib ("progs/drngib3.mdl", -65);

    T_RadiusDamage (self, self, 120, world);    // PM:  Damage was 130.

    // Null sound added for the OUM style sfx.
    StopSound (self, CHAN_VOICE);
    self.origin = self.origin - 8*normalize(self.velocity);
    Rocket_Explosion1 (self.origin);
    if (M_RespawnCheck ())
        {monster_disappear ();  MakeExplosion (self.origin);}
    else
        BecomeExplosion ();
};

// PM:  New death functions.
void() drn_die =
{
    if ((self.enemy == self) || (self.enemy.classname == "teledeath"))
    {
        // Explode immediately if self-destructed or telefragged.
        self.frame      = $base1;
        self.nextthink  = 0.01;
        self.think      = drn_die7;
        return;
    }

    drn_die1 ();
};


void()  DroneTouch =
{
// PM:  Don't blow up if its master touched it (and is friendly).
    if (other == self.master)
        if (other != self.enemy)
            if (other != self.oldenemy)
                return;

// NOTE:  When killed, touch is automatically set to 'SUB_Null'.
    if (other.takedamage)
    {
        // PM:  Make the drone self-destruct as a monster kill.
        self.touch = SUB_Null;
        T_Kill (self, self, self, -99, "");
    }
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) drn_sight =
{
// My first choice for friend sight sound was "misc/basekey.wav".
// Original hostile sight sound was "ambience/fl_hum1.wav".
    if (hello)
        sound (self, CHAN_VOICE, "drone/drnidle2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "drone/drnwake.wav", 1, ATTN_NORM);
};

void() drone_cache =
{
    precache_model ("progs/drone1.mdl");
    precache_model ("progs/drngib1.mdl");
    precache_model ("progs/drngib2.mdl");
    precache_model ("progs/drngib3.mdl");
    precache_model ("progs/laser.mdl");
    precache_model ("progs/spike.mdl");

    precache_sound ("drone/drndeth.wav");
    precache_sound ("drone/drngasp.wav");
    precache_sound ("drone/drngasp2.wav");
    precache_sound ("drone/drnhunt.wav");
    precache_sound ("drone/drnidle.wav");
    precache_sound ("drone/drnidle2.wav");
    precache_sound ("drone/drnpain.wav");
    precache_sound ("drone/drnpain2.wav");
    precache_sound ("drone/drnwake.wav");
    precache_sound ("drone/enfire.wav");
    precache_sound ("enforcer/enfstop.wav");
};

//============
// --> QUAKED monster_drone (1 0 0) (-16 -16 -24) (16 16 32) Ambush
//============
void() monster_drone =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        drone_cache ();
    }

    monster_form ("progs/drone1.mdl", '-16 -16 -24', '16 16 32', 100, 0);
    self.mass   = MASS_LIGHT;

    self.touch      = DroneTouch;
    self.th_stand   = drn_stand1;
    self.th_walk    = drn_walk1;
    self.th_run     = drn_run;
    self.th_missile = drn_atta1;
    self.th_pain    = drn_pain;
    self.th_die     = drn_die;      // PM:  Changed from 'drn_die1'.
    //- - - - - - - -
    self.th_sight   = drn_sight;
    self.th_spawn   = monster_drone;

// DISABLED -- DarkPlaces makes them glow even if modelindex == 0.
//    self.effects    = self.effects | EF_DIMLIGHT;
    self.volume     = 0;    // For weapon jam checks.

    self.burn_ofs   = '-4 0 16';
    self.bloodtype  = BLOOD_SPARKS;
    self.family     = FAM_DROID;
    self.threats    = THREAT_BADASS | THREAT_DEATH;
    self.hittype    = HIT_METAL;

    flymonster_start ();
};


//===========================/  END OF FILE  /===========================//
