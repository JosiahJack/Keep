//===========================================================================
//  PLAYER
//===========================================================================
$cd id1/models/player_4
$origin 0 -6 24
$base base        
$skin skin

// Running
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

// Standing
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12

// Pain
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6

// Death
$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

// Attacks
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6
//===========================================================================
// - playsaw.mdl - (Zerstorer)
// run      0 -  5
// stand    6 - 10
// pain    11 - 16
// death   17 - 25
// attk    26 - 27

// - playham.mdl -
// run      0 -  5
// stand    6 - 17
// pain    18 - 23
// death   24 - 31
// attk    32 - 37
// attkc   38 - 43
//===========================================================================

// Prototypes in proto.qc.

// Footstep effects.  Called within player_run.
void() player_step =
{
// If moving slower, slow animation down for fewer steps.
    if (footsteps)
        if (vlen (self.velocity) <= 220)    // Max walkspeed is about 200.
            self.nextthink = self.nextthink + 0.05; // Slower anim for less steps.

    if (self.flags & FL_ONGROUND)
        if (self.movetype == MOVETYPE_WALK)
            if ((self.walkframe == 1) || (self.walkframe == 4))
                Sfx_Footstep ();
};

void() player_run =[ 0, player_run ]
{
//- - - - - - - - -
    if (self.form_active)
    {
//        if (self.form_active == FORM_SCORPIO)
//            scorpio_run ();
//        else
            baha_run ();
        return;
    }
//- - - - - - - - -

// Check weaponframe.
    if (self.war == WAR_BURIZA)
    {   // Crossbow has different weaponframe rules.
        if (self.weaponframe)
        {
            if (self.weaponframe >= 19)
            {
                self.weaponframe = 0;
                self.attack_finished = 0;
            }
            else
            {
                if ((self.weaponframe >= 9) && (self.ammo_super < 1))
                {   // Out of ammo, so drop the weapon and swap for another.
                    // Drop 'n swap code is done elsewhere, but setting
                    // attack_finished to zero lets said code work asap.
                    self.weaponframe = 0;
                    self.attack_finished = 0;
                }
                else
                {   // Load the next shot.
                    if (self.weaponframe == 10)
                        if (!intermission_running)
                            sound (self, CHAN_WEAPON, "weapons/xbowdraw.wav", 1, ATTN_IDLE);
//                    if (self.tech == TECH_HASTE)
//                    {
//                        if (self.weaponframe == 11)
//                            if (!intermission_running)
//                                sound (self, CHAN_WEAPON, "weapons/xbowdraw.wav", 1, ATTN_IDLE);
//                        self.weaponframe = self.weaponframe + 2;
//                    }
//                    else
                        self.weaponframe = self.weaponframe + 1;
                    self.attack_finished = time + 0.2;
                }
            }
        }
    }
    else    // Make sure weaponframe is zero.
    {
        self.weaponframe = 0;
        if (self.war == WAR_GRAPPLE)
        {   // Possible except for grapple, due to one hook at a time rule.
            if (self.hook)
                if (self.hook.count)
                    self.weaponframe = 1;   // Hook is still out.
        }
    }
// Animate the player model.
// Check for chainsaw first because it needs a different player model.
    if (self.war == WAR_CHAINSAW)
    {
        // In Zerstorer, when the fifth idle frame was reached, the frame
        // looped back to the first and the saw idle sound was played.
        // In Drake, the frames are grouped, so play sound periodically.
        if (self.saw_time <= time)
            if (self.view_ofs != '0 0 0')
            {   // Volume used to be 1, but Tronyn et.al. wanted it quieter.
                // Pity, it was fun loud.
                sound (self, CHAN_AUTO, "weapons/sawridle.wav", 0.5, ATTN_NORM);
                self.saw_time = time + 0.5;
            }

        if (mindex_saw)
        {   // Animate player model.
            if (self.velocity_x || self.velocity_y)
            {
                if (self.walkframe >= 6)
                    self.walkframe = 0;
                self.frame = self.walkframe;
                player_step ();     // Footsteps.
            }
            else
            {
                if (self.walkframe >= 5)
                    self.walkframe = 0;
                self.frame = 6 + self.walkframe;
            }
            self.walkframe = self.walkframe + 1;
            return;
        }
        // ELSE... using standard player.mdl instead.
    }
// All other weapons use the standard player model.
// FIXME:  Should reset walkframe to zero if changing from stand to run.
    if (self.velocity_x || self.velocity_y)
    {   // Running.
        if (self.war & WARx_AXE_FRAMES)
        {
            if (self.walkframe >= 6)
                self.walkframe = 0;
            if (mindex_hammer && self.war == WAR_MJOLNIR)
                self.frame = self.walkframe;
            else
                self.frame = $axrun1 + self.walkframe;
        }
        else
        {
            if (self.walkframe >= 6)
                self.walkframe = 0;
            self.frame = $rockrun1 + self.walkframe;
        }
        player_step ();     // Footsteps.
    }
    else
    {   // Standing.
        // Doesn't matter which standing frame the player begins at.
        // They all look alike.
        if (self.war & WARx_AXE_FRAMES)
        {
            if (self.walkframe >= 12)
                self.walkframe = 0;
            if (mindex_hammer && self.war == WAR_MJOLNIR)
                self.frame = 6 + self.walkframe;
            else
                self.frame = $axstnd1 + self.walkframe;
        }
        else
        {
            if (self.walkframe >= 5)
                self.walkframe = 0;
            self.frame = $stand1 + self.walkframe;
        }
    }
    self.walkframe = self.walkframe + 1;
};


//==========================================================================
//  ATTACKS
//==========================================================================

// Moved from weapons.qc
void() SuperDamageSound =
{
    if (self.super_damage_finished)     //if (self.items & IT_QUAD)
        if (self.super_sound < time)
        {
            self.super_sound = time + 1;
            sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
        }
};

// XBOW - - - - - -
void() player_xbow1   =[$light1,   player_xbow2  ] {self.weaponframe=1;
    if (self.tome_finished)
        sound (self, CHAN_WEAPON, "necro/att_a2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_WEAPON, "necro/att_a.wav", 1, ATTN_NORM);
};
void() player_xbow2   =[$light2,   player_xbow3  ] {self.weaponframe=2; W_FireCrossbow ();};
void() player_xbow3   =[$light2,   player_run    ] {self.weaponframe=3;};

// SHAFT - - - - - -
void() player_tbolt =
{
    self.effects = self.effects | EF_MUZZLEFLASH;

    if (!self.button0 || intermission_running)
        {player_run ();  return;}
    self.weaponframe = self.weaponframe + 1;
    if (self.war == WAR_CHAIN_LIGHTNING)
    {   if (self.weaponframe == 17)
            self.weaponframe = 1;
    }
    else
    {   if (self.weaponframe == 5)
            self.weaponframe = 1;
    }
    SuperDamageSound ();
    if (self.war == WAR_CHAIN_LIGHTNING)
    {
        if (self.tome_finished)
        {
            {player_run ();  return;}   // Start new animation.
// Test stuff disabled.  Should be removed.
//            W_FireDeathRay ();
//            if ( self.frame == $light1 )
//            {   // BFG 10K mode.
//                W_FirePlasma ();
//                self.attack_finished = time + 0.3;
//                return;
//            }
        }
        else
            W_FireThunderbolt (TRUE);
    }
    else
    {   // Thunderbolt
        W_FireThunderbolt (self.tome_finished);
    }
    self.attack_finished = time + 0.2;
};
void() player_light1   =[$light1, player_light2  ] {player_tbolt();};
void() player_light2   =[$light2, player_light3  ] {
    if (!self.tome_finished || (self.war != WAR_CHAIN_LIGHTNING))
        self.think = player_light1;     // Do before damage.
    player_tbolt();
};
void() player_light3   =[$light2, player_light1  ] {player_tbolt();};

// Animation for Chain Lightning when firing the ToP induced death ray.
void() cl_anim =
{
    self.weaponframe = self.weaponframe + 1;
    if (self.weaponframe >= 17)
        self.weaponframe = 1;
};
void() player_snake1   =[$light1, player_snake2  ] {cl_anim(); self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_snake2   =[$light1, player_snake3  ] {cl_anim();};
void() player_snake3   =[$light2, player_snake4  ] {cl_anim();};
void() player_snake4   =[$light2, player_snake5  ] {cl_anim();};
void() player_snake5   =[$light2, player_run     ] {cl_anim();};

// ROCKETS - - - - -
void() player_rocket1   =[$rockatt1, player_rocket2  ] {self.weaponframe=1;
    self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_rocket2   =[$rockatt2, player_rocket3  ] {self.weaponframe=2;};
void() player_rocket3   =[$rockatt3, player_rocket4  ] {self.weaponframe=3;};
void() player_rocket4   =[$rockatt4, player_rocket5  ] {self.weaponframe=4;};
void() player_rocket5   =[$rockatt5, player_rocket6  ] {self.weaponframe=5;};
void() player_rocket6   =[$rockatt6, player_run      ] {self.weaponframe=6;};

// Same as player_rock* except weaponframe stays at 0.
// This is because the stinger viewmodel only has one frame.
// Update 9/5/09:  Spawn another entity for muzzleflash to bypass Qrack flash.
void() player_bfg1 =[ $rockatt1, player_bfg2  ] {SUB_Flash ();};
void() player_bfg2 =[ $rockatt2, player_bfg3  ] {};
void() player_bfg3 =[ $rockatt3, player_bfg4  ] {};
void() player_bfg4 =[ $rockatt4, player_bfg5  ] {};
void() player_bfg5 =[ $rockatt5, player_bfg6  ] {};
void() player_bfg6 =[ $rockatt6, player_run   ] {};

// NAILGUN - - - - -
void(float ox) player_nailgun =
{
    if ((self.war == WAR_NAILGUN) && (self.perms & POW_DOUBLE)
    && (!self.tome_finished))
    {
        if ( intermission_running || (!self.button0 && (ox > 0)) )
            {player_run (); return;}
    }
    else
    {
        if (intermission_running || !self.button0)
            {player_run (); return;}
    }
    self.weaponframe = self.weaponframe + 1;
    if (self.weaponframe == 9)
        self.weaponframe = 1;
    SuperDamageSound();
    self.attack_finished = time + 0.2;  // Moved above to allow change later.
    W_FireSpikes (ox);
};
void() player_nail1 =[ $nailatt1, player_nail2 ] {player_nailgun(2);};
void() player_nail2 =[ $nailatt2, player_nail1 ] {player_nailgun(-2);};

// LASER - - - - - -
// Sets up timings for blaster and auto shotgun.
void() player_startblast =
    {self.baha_time = time;  self.nextthink = time + 4/30;};

void(float fr) player_blaster =
{
    local   float   am;

    am = self.baha_time + 4/30;
    if (am < self.nextthink)    // Firing rate can't be faster than T+0.1.
        am = self.nextthink;
    self.nextthink = self.baha_time = am;

    self.weaponframe = fr;
    self.attack_finished = time + 0.2;
    HIP_FireLaser(2);
};
void() player_blast1  =[ $nailatt1, player_blast2  ] {player_startblast(); player_blaster(1);};
void() player_blast2  =[ $nailatt2, player_blast3  ] {player_blaster(2);};  // NOTE: Use '0' instead if using old color-swapped shotgun.
void() player_blast3  =[ $nailatt1, player_blast2  ] {player_blaster(1);};

// Laser Cannon.
void() player_laser1 =[ $nailatt1, player_laser2 ] {self.attack_finished = time + 0.1;self.weaponframe=4;HIP_FireLaser(1);};
void() player_laser2 =[ $nailatt2, player_laser1 ] {self.attack_finished = time + 0.1;self.weaponframe=1;HIP_FireLaser(0);};

//void() player_laser1 =[ $nailatt1, player_laser3 ] {self.attack_finished = time + 0.1;self.weaponframe=1;HIP_FireLaser(0);};
//void() player_laser2 =[ $nailatt2, player_laser3 ] {self.attack_finished = time + 0.1;self.weaponframe=2;};
//void() player_laser3 =[ $nailatt2, player_laser1 ] {self.attack_finished = time + 0.1;self.weaponframe=4;HIP_FireLaser(1);};
//void() player_laser4 =[ $nailatt1, player_laser1 ] {self.attack_finished = time + 0.1;self.weaponframe=5;};

// PLASMA - - - - -
void(float fr) player_plasma =
{
//    if (self.tech == TECH_HASTE)
//        self.nextthink = time + 0.05;

    if (intermission_running || !self.button0)
        {player_run (); return;}

    if (fr)
    {
        self.weaponframe = 1;
        self.effects = self.effects | EF_MUZZLEFLASH;
        W_FirePlasma (self.tome_finished);
    }
    else
    {
        self.weaponframe = 2;
        if (self.tome_finished)
        {
            self.nextthink = time + 0.3;
            self.attack_finished = self.nextthink + 0.1;
            return;
        }
    }
    self.attack_finished = time + 0.2;
};
void() player_plasma1  =[ $light1, player_plasma2  ] {player_plasma(1);};
void() player_plasma2  =[ $light2, player_plasma1  ] {player_plasma(0);};

// SHOTGUN - - - - -
// Similar to player_shot* except some frames are delayed.
void() player_sshot1 =[$shotatt1, player_sshot2 ] {self.weaponframe=1;
    self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_sshot2 =[$shotatt2, player_sshot3 ] {self.weaponframe=2;};
void() player_sshot3 =[$shotatt3, player_sshot4 ] {self.weaponframe=3;self.nextthink = time + 0.2;};
void() player_sshot4 =[$shotatt4, player_sshot5 ] {self.weaponframe=4;self.nextthink = time + 0.2;};
void() player_sshot5 =[$shotatt5, player_sshot6 ] {self.weaponframe=5;self.nextthink = time + 0.2;};
void() player_sshot6 =[$shotatt6, player_run    ] {self.weaponframe=6;self.nextthink = time + 0.2;};

// Standard shotguns.
void() player_shot1 =[$shotatt1, player_shot2 ] {self.weaponframe=1;
    self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_shot2 =[$shotatt2, player_shot3 ] {self.weaponframe=2;};
void() player_shot3 =[$shotatt3, player_shot4 ] {self.weaponframe=3;};
void() player_shot4 =[$shotatt4, player_shot5 ] {self.weaponframe=4;};
void() player_shot5 =[$shotatt5, player_shot6 ] {self.weaponframe=5;};
void() player_shot6 =[$shotatt6, player_run   ] {self.weaponframe=6;};

// MAGIC - - - - - -
void() player_wand1 =[$nailatt1, player_wand2 ] {self.weaponframe=1;
    self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_wand2 =[$nailatt2, player_wand3 ] {self.weaponframe=2;};
void() player_wand3 =[$nailatt2, player_wand4 ] {self.weaponframe=3;};
void() player_wand4 =[$nailatt2, player_wand5 ] {self.weaponframe=4;};
void() player_wand5 =[$nailatt2, player_run   ] {if (!self.button0) player_run();};

// AXE - - - - - - -
void() player_axe1  =[ $axatt1,  player_axe2  ] {self.weaponframe=1;};
void() player_axe2  =[ $axatt2,  player_axe3  ] {self.weaponframe=2;};
void() player_axe3  =[ $axatt3,  player_axe4  ] {self.weaponframe=3;W_FireAxe();};
void() player_axe4  =[ $axatt4,  player_run   ] {self.weaponframe=4;};

void() player_axeb1 =[ $axattb1, player_axeb2 ] {self.weaponframe=5;};
void() player_axeb2 =[ $axattb2, player_axeb3 ] {self.weaponframe=6;};
void() player_axeb3 =[ $axattb3, player_axeb4 ] {self.weaponframe=7;W_FireAxe();};
void() player_axeb4 =[ $axattb4, player_run   ] {self.weaponframe=8;};

void() player_axec1 =[ $axattc1, player_axec2 ] {self.weaponframe=1;};
void() player_axec2 =[ $axattc2, player_axec3 ] {self.weaponframe=2;};
void() player_axec3 =[ $axattc3, player_axec4 ] {self.weaponframe=3;W_FireAxe();};
void() player_axec4 =[ $axattc4, player_run   ] {self.weaponframe=4;};

void() player_axed1 =[ $axattd1, player_axed2 ] {self.weaponframe=5;};
void() player_axed2 =[ $axattd2, player_axed3 ] {self.weaponframe=6;};
void() player_axed3 =[ $axattd3, player_axed4 ] {self.weaponframe=7;W_FireAxe();};
void() player_axed4 =[ $axattd4, player_run   ] {self.weaponframe=8;};

// Throwing axe anim.
//void() player_taxe1 =[ $axatt1,  player_taxe2 ] {self.weaponframe=1;};
//void() player_taxe2 =[ $axatt2,  player_taxe3 ] {self.weaponframe=2;};
//void() player_taxe3 =[ $axatt3,  player_taxe4 ] {self.weaponframe=3;
//    if (self.tome_finished)
//        W_FireThrowAxe();
//    else
//        player_axe3 ();     // No mojo to throw axe?  Goto normal axe swing.
//};
//void() player_taxe4 =[ $axatt4,  player_taxe5 ] {self.weaponmodel = "";};
//void() player_taxe5 =[ $axatt5,  player_taxe6 ] {};
//void() player_taxe6 =[ $axatt6,  player_taxe7 ] {};
//void() player_taxe7 =
//{
//    self.weaponframe=0;     // Allow pain anims again.
//    // If player has another axe ready to hold, then set weaponmodel back.
//    self.weaponmodel = "progs/v_axe.mdl";
//    player_run();
//};

void() player_axe =
{
    // If player has axe ready, then set weaponmodel just in case it's blank.
    // PM:  Ugly fix, but is there any other way that's better?
//    self.weaponmodel = "progs/v_axe.mdl";
//    if (self.tome_finished)
//    {   // Player has the mojo to throw the axe.
//        // Check if close enough to hit without throwing axe.
//        local   vector  spot;
//
//        spot = self.origin + '0 0 16';
//        makevectors (self.v_angle);
//        traceline (spot, spot + v_forward*64, FALSE, self);
//        if (trace_fraction == 1.0)
//        {   // Melee attack will miss, so throw the axe.
//            // Note:  Don't remove ammo here because axe is still in hand.
//            player_taxe1 ();
//            self.attack_finished = time + 0.7;
//            return;
//        }
//    }

    local   float   side;

    side = (random() < 0.5);
    if (( self.frame < $axatt1 ) || ( self.frame > $axattd4 ))
    {   // First swing.
        local   float   r;

        self.encore = 0;
        r = (random() < 0.5);
        sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
        if (side)
        {   // Cross slash
            if (r)
                player_axeb1 ();
            else
                player_axed1 ();
        }
        else
        {   // Overhead slash
            if (r)
                player_axe1 ();
            else
                player_axec1 ();
        }
    }
    else
    {   // Combination attack.
        self.encore = 1;
        if (self.axhitme < time)
            sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
        if ( self.frame <= $axatt6 )
            player_axeb1 ();
        else if ( self.frame <= $axattb6 )
        {   if (side)
                player_axed1 ();
            else
                player_axe1 ();
        }
        else
        {   if (side)
                player_axeb1 ();
            else
                player_axec1 ();
        }
    }
    self.attack_finished = time + 0.3;
};

// MJOLNIR - - - - -
void(float fr, float wf) playham_frame =
{
    if ( ((self.war == WAR_CHAINSAW) && mindex_saw) || mindex_hammer )
        self.frame = fr;

    if (wf)
        self.weaponframe=wf;
    else
    {
        if (self.attack_finished <= time + 0.1)
            self.weaponframe=0;
        else
            self.weaponframe=4;
    }
};

// DISABLED -- Subsumed by playham func above.
//void() hammer_frame =
//{
//    if (self.attack_finished <= time + 0.1)
//        self.weaponframe=0;
//    else
//        self.weaponframe=4;
//};

void() player_hammer4t =[ $axatt4,  player_hammer5  ] {playham_frame(35,4);};
void() player_mjolnir4t=[ $axattc4, player_mjolnir5 ] {playham_frame(41,4);};

// Frames $axatt1-6.
void() player_hammer1  =[ $axatt1,  player_hammer2  ] {playham_frame(32,1);};
void() player_hammer2  =[ $axatt2,  player_hammer3  ] {playham_frame(33,2);};
void() player_hammer3  =[ $axatt3,  player_hammer4  ] {playham_frame(34,3);
    if (HIP_ThrowMjolnir())
        self.think = player_hammer4t;
};
void() player_hammer4  =[ $axatt4,  player_hammer5  ] {playham_frame(35,4);HIP_FireMjolnir();};
void() player_hammer5  =[ $axatt5,  player_hammer6  ] {playham_frame(36,4);};
void() player_hammer6  =[ $axatt6,  player_run      ] {playham_frame(37,0);};

// Frames $axattc1-6.
void() player_mjolnir1 =[ $axattc1, player_mjolnir2 ] {playham_frame(38,1);};
void() player_mjolnir2 =[ $axattc2, player_mjolnir3 ] {playham_frame(39,2);};
void() player_mjolnir3 =[ $axattc3, player_mjolnir4 ] {playham_frame(40,3);
    if (HIP_ThrowMjolnir())
        self.think = player_mjolnir4t;
};
void() player_mjolnir4 =[ $axattc4, player_mjolnir5 ] {playham_frame(41,4);HIP_FireMjolnir();};
void() player_mjolnir5 =[ $axattc5, player_mjolnir6 ] {playham_frame(42,4);};
void() player_mjolnir6 =[ $axattc6, player_run      ] {playham_frame(43,0);};

// Notes:
//  HIP_ThrowMjolnir returns TRUE if the hammer hits something or gets thrown.
//  HIP_FireMjolnir attempts to slam the ground.

// CHAINSAW - - - - -
void() player_saw1 =[ $light1, player_saw2 ] {playham_frame(26,1); W_FireSaw();};
void() player_saw2 =[ $light2, player_saw3 ] {playham_frame(27,2);
    if (!self.button0)
        {player_run ();return;}
};
void() player_saw3 =[ $light1, player_saw4 ] {playham_frame(26,3); W_FireSaw();};
void() player_saw4 =[ $light2, player_saw5 ] {playham_frame(27,4);
    if (!self.button0)
        {player_run ();return;}
};
void() player_saw5 =[ $light1, player_saw6 ] {playham_frame(26,5); W_FireSaw();};
void() player_saw6 =[ $light2, player_run  ] {playham_frame(27,6);};

// GRAPPLE - - - - -
void() player_grapple4;
void() player_grapple5;

// PM:  Changed axe frames to gun frames.
void() player_grapple1 =[ $shotatt2, player_grapple2 ] {self.weaponframe=1; W_FireGrapple();};
void() player_grapple2 =[ $rockatt5, player_grapple3 ] {self.weaponframe=2;};
void() player_grapple3 =[ $rockatt6, player_grapple3 ] {self.weaponframe=2;
    if (!self.hook || self.hook.count)
        {player_grapple5();  return;}   // Done.
    if (vlen(self.hook.origin - self.origin) >= HOOK_NEAR)
        if (self.hook.state)    //on_hook)
            if (Grapple_Pull_Me ())
                {player_grapple4();  return;}   // Time to fly.
};
void() player_grapple4 =[ $deathc4, player_grapple4 ] {self.weaponframe=2;
    if (!self.hook || self.hook.count)
        {player_grapple5();  return;}   // Done.
    if ( (vlen(self.hook.origin - self.origin) < HOOK_NEAR)
    || !self.hook.state)    //on_hook)
        {player_grapple3();  return;}
    if (!Grapple_Pull_Me ())    // Did target gain weight all of a sudden?
        {player_grapple3();  return;}
};
void() player_grapple5 =[ $rockatt6, player_run   ] {self.weaponframe=1;};


//==========================================================================
//  PAIN
//==========================================================================
float() PainSound =
{
// Update 5/08/2009:  Axhitme removed completely.
//    local   float   axed;

    // Deal with the axe field here and now.
//    axed = self.axhitme;
//    self.axhitme = 0;

    // Note:  Cross gives immunity to environmental damage, so don't let
    // a protected player yell if he gets hit while swimming in hot sauce.
    if (!self.cross_finished)
    {
        if (self.h2otype == CONTENT_LAVA || self.h2otype == CONTENT_SLIME)
        {
            if (random() > 0.5)
                sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
            else
                sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
            return TRUE;
        }
        if (self.h2olevel == 3)
            if (self.h2otype == CONTENT_WATER)
            {   // Underwater
                DeathBubbles (1);
                if (random() > 0.5)
                    sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
                else
                    sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
                return TRUE;
            }
    }

    if (self.pain_finished > time)
        return FALSE;
    self.pain_finished = time + 0.5;

// don't make multiple pain sounds right after each other

    local   float   rs;

    rs = rint((random() * 5) + 1);

    self.noise = "";
    if (IsBurning (self))
    {
        if (rs <= 3)
            self.noise = "player/lburn1.wav";
        else
            self.noise = "player/lburn2.wav";
        self.pain_finished = time + 1;
    }
// DISABLED -- Nothing uses axhit1 anymore so remove the sound to save a slot.
//    else if (axed)
//        self.noise = "player/axhit1.wav";   // hit by axe.
    else if (rs == 1)
        self.noise = "player/pain1.wav";
    else if (rs == 2)
        self.noise = "player/pain2.wav";
    else if (rs == 3)
        self.noise = "player/pain3.wav";
    else if (rs == 4)
        self.noise = "player/pain4.wav";
    else if (rs == 5)
        self.noise = "player/pain5.wav";
    else
        self.noise = "player/pain6.wav";

    sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    return TRUE;
};

void() player_pain1 =[ $pain1, player_pain2 ] {};
void() player_pain2 =[ $pain2, player_pain3 ] {};
void() player_pain3 =[ $pain3, player_pain4 ] {};
void() player_pain4 =[ $pain4, player_pain5 ] {};
void() player_pain5 =[ $pain5, player_pain6 ] {};
void() player_pain6 =[ $pain6, player_run   ] {};

void() player_axpain1 =[ $axpain1, player_axpain2 ] {};
void() player_axpain2 =[ $axpain2, player_axpain3 ] {};
void() player_axpain3 =[ $axpain3, player_axpain4 ] {};
void() player_axpain4 =[ $axpain4, player_axpain5 ] {};
void() player_axpain5 =[ $axpain5, player_axpain6 ] {};
void() player_axpain6 =[ $axpain6, player_run     ] {};

void() player_sawpain1 =[ 11, player_sawpain2 ] {};
void() player_sawpain2 =[ 12, player_sawpain3 ] {};
void() player_sawpain3 =[ 13, player_sawpain4 ] {};
void() player_sawpain4 =[ 14, player_sawpain5 ] {};
void() player_sawpain5 =[ 15, player_sawpain6 ] {};
void() player_sawpain6 =[ 16, player_run      ] {};

void() player_hampain1 =[ 18, player_hampain2 ] {};
void() player_hampain2 =[ 19, player_hampain3 ] {};
void() player_hampain3 =[ 20, player_hampain4 ] {};
void() player_hampain4 =[ 21, player_hampain5 ] {};
void() player_hampain5 =[ 22, player_hampain6 ] {};
void() player_hampain6 =[ 23, player_run      ] {};

void(entity attacker, float damage) player_pain =
{
//- - - - - - - - -
    if (self.form_active)
    {   // Pain in monster form done elsewhere.
//        if (self.form_active == FORM_SCORPIO)
//            scorpio_pain ();
//        else
            baha_pain ();
        return;
    }
//- - - - - - - - -
    if (self.war == WAR_GRAPPLE)
    {   // No pain while the hook is out.
        if (self.hook)
            return;
    }
    else if (self.weaponframe)
        return;     // No pain sound if attacking.
// Removed invisibility nopain.
// Custom null model/sprite has 256 frames, which is plenty.

    if (PainSound ())
    {
        self.weaponframe = 0;
        if (self.war & WARx_AXE_FRAMES)
        {
            if (mindex_hammer && self.war == WAR_MJOLNIR)
                player_hampain1 ();
            else
                player_axpain1 ();
        }
        else if (mindex_saw && self.war == WAR_CHAINSAW)
            player_sawpain1 ();
        else
            player_pain1 ();
    }

    attacker = attacker;    // Satisfying FrikQcc compiler.
};


//==========================================================================
//  DEATH
//==========================================================================
void() PlayerDead_II =
{
    self.nextthink  = -1;
    self.think      = SUB_Null;
    self.deadflag   = DEAD_DEAD;    // Allow respawn
    Pets_Free (self);

// Time for Bishop to rub it in.
    if (dmsp)
    {
        local   float   r;
        local   string  sfx;

        r = random() * 4;
        if (r < 1)
            sfx = "bishop/journey.wav"; // "Your journey has come to an end."
        else if (r < 2)
            sfx = "bishop/rip.wav";     // "Rest in peace."
        else if (r < 3)
            sfx = "bishop/rot.wav";     // "Rot in Hell."
        else
            sfx = "bishop/skull.wav";   // "Another skull for my collection."
        sound (self, CHAN_AUTO, sfx, 1, ATTN_NONE);
    }
};
void() PlayerDead =
{
    self.nextthink  = self.pain_finished;
    self.think      = PlayerDead_II;
};

void() player_diea1  =[ $deatha1,  player_diea2  ] {};
void() player_diea2  =[ $deatha2,  player_diea3  ] {};
void() player_diea3  =[ $deatha3,  player_diea4  ] {};
void() player_diea4  =[ $deatha4,  player_diea5  ] {};
void() player_diea5  =[ $deatha5,  player_diea6  ] {};
void() player_diea6  =[ $deatha6,  player_diea7  ] {};
void() player_diea7  =[ $deatha7,  player_diea8  ] {};
void() player_diea8  =[ $deatha8,  player_diea9  ] {};
void() player_diea9  =[ $deatha9,  player_diea10 ] {};
void() player_diea10 =[ $deatha10, player_diea11 ] {};
void() player_diea11 =[ $deatha11, PlayerDead    ] {};

void() player_dieb1  =[ $deathb1,  player_dieb2  ] {};
void() player_dieb2  =[ $deathb2,  player_dieb3  ] {};
void() player_dieb3  =[ $deathb3,  player_dieb4  ] {};
void() player_dieb4  =[ $deathb4,  player_dieb5  ] {};
void() player_dieb5  =[ $deathb5,  player_dieb6  ] {};
void() player_dieb6  =[ $deathb6,  player_dieb7  ] {};
void() player_dieb7  =[ $deathb7,  player_dieb8  ] {};
void() player_dieb8  =[ $deathb8,  player_dieb9  ] {};
void() player_dieb9  =[ $deathb9,  PlayerDead    ] {};

void() player_diec1  =[ $deathc1,  player_diec2  ] {};
void() player_diec2  =[ $deathc2,  player_diec3  ] {};
void() player_diec3  =[ $deathc3,  player_diec4  ] {};
void() player_diec4  =[ $deathc4,  player_diec5  ] {};
void() player_diec5  =[ $deathc5,  player_diec6  ] {};
void() player_diec6  =[ $deathc6,  player_diec7  ] {};
void() player_diec7  =[ $deathc7,  player_diec8  ] {};
void() player_diec8  =[ $deathc8,  player_diec9  ] {};
void() player_diec9  =[ $deathc9,  player_diec10 ] {};
void() player_diec10 =[ $deathc10, player_diec11 ] {};
void() player_diec11 =[ $deathc11, player_diec12 ] {};
void() player_diec12 =[ $deathc12, player_diec13 ] {};
void() player_diec13 =[ $deathc13, player_diec14 ] {};
void() player_diec14 =[ $deathc14, player_diec15 ] {};
void() player_diec15 =[ $deathc15, PlayerDead    ] {};

void() player_died1  =[ $deathd1,  player_died2  ] {};
void() player_died2  =[ $deathd2,  player_died3  ] {};
void() player_died3  =[ $deathd3,  player_died4  ] {};
void() player_died4  =[ $deathd4,  player_died5  ] {};
void() player_died5  =[ $deathd5,  player_died6  ] {};
void() player_died6  =[ $deathd6,  player_died7  ] {};
void() player_died7  =[ $deathd7,  player_died8  ] {};
void() player_died8  =[ $deathd8,  player_died9  ] {};
void() player_died9  =[ $deathd9,  PlayerDead    ] {};

void() player_diee1  =[ $deathe1,  player_diee2  ] {};
void() player_diee2  =[ $deathe2,  player_diee3  ] {};
void() player_diee3  =[ $deathe3,  player_diee4  ] {};
void() player_diee4  =[ $deathe4,  player_diee5  ] {};
void() player_diee5  =[ $deathe5,  player_diee6  ] {};
void() player_diee6  =[ $deathe6,  player_diee7  ] {};
void() player_diee7  =[ $deathe7,  player_diee8  ] {};
void() player_diee8  =[ $deathe8,  player_diee9  ] {};
void() player_diee9  =[ $deathe9,  PlayerDead    ] {};

void() player_die_ax1  =[ $axdeth1,  player_die_ax2  ] {};
void() player_die_ax2  =[ $axdeth2,  player_die_ax3  ] {};
void() player_die_ax3  =[ $axdeth3,  player_die_ax4  ] {};
void() player_die_ax4  =[ $axdeth4,  player_die_ax5  ] {};
void() player_die_ax5  =[ $axdeth5,  player_die_ax6  ] {};
void() player_die_ax6  =[ $axdeth6,  player_die_ax7  ] {};
void() player_die_ax7  =[ $axdeth7,  player_die_ax8  ] {};
void() player_die_ax8  =[ $axdeth8,  player_die_ax9  ] {};
void() player_die_ax9  =[ $axdeth9,  PlayerDead      ] {};

void() player_die_saw1  =[ 17,  player_die_saw2  ] {};
void() player_die_saw2  =[ 18,  player_die_saw3  ] {};
void() player_die_saw3  =[ 19,  player_die_saw4  ] {};
void() player_die_saw4  =[ 20,  player_die_saw5  ] {};
void() player_die_saw5  =[ 21,  player_die_saw6  ] {};
void() player_die_saw6  =[ 22,  player_die_saw7  ] {};
void() player_die_saw7  =[ 23,  player_die_saw8  ] {};
void() player_die_saw8  =[ 24,  player_die_saw9  ] {};
void() player_die_saw9  =[ 25,  PlayerDead       ] {};

void() player_die_ham1  =[ 24,  player_die_ham2  ] {};
void() player_die_ham2  =[ 25,  player_die_ham3  ] {};
void() player_die_ham3  =[ 26,  player_die_ham4  ] {};
void() player_die_ham4  =[ 27,  player_die_ham5  ] {};
void() player_die_ham5  =[ 28,  player_die_ham6  ] {};
void() player_die_ham6  =[ 29,  player_die_ham7  ] {};
void() player_die_ham7  =[ 30,  player_die_ham8  ] {};
void() player_die_ham8  =[ 31,  PlayerDead       ] {};

void() DeathSound =
{
    // water death sounds
    if (self.h2olevel == 3)
    {
        if (self.h2otype == CONTENT_WATER || self.h2otype == CONTENT_SLIME)
            DeathBubbles (20);
        sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
        return;
    }
    if (self.deathtype == "falling")
    {
        sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NONE);
        return;
    }

// Update:  I (PM) dislike 'death5.wav', and since some of Tronyn's levels
// precache too many sounds, I shall remove the offending sound to save
// yet another slot for the sound precache index.
    local   float   r;

    r = ((random() * 4) & 3) + 1;
//    r = random() * 4 + 1;
//    r = rint(r);

    if (r == 1)
        self.noise = "player/death1.wav";
    else if (r == 2)
        self.noise = "player/death2.wav";
    else if (r == 3)
        self.noise = "player/death3.wav";
    else //if (r == 4)
        self.noise = "player/death4.wav";
//    else //if (r == 5)
//        self.noise = "player/death5.wav";

    sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
//    return;
};

float(float dm) player_gib =
{
    if (self.health < self.gib_health)
    {
        if (self.modelindex == mindex_dragon)
        {
            ThrowGib ("progs/drp_lw.mdl", dm);
            ThrowGib ("progs/drp_rw.mdl", dm);
            ThrowGib ("progs/drp_tail.mdl", dm);
            ThrowGib ("progs/gib3.mdl", dm);
            ThrowHead ("progs/drp_head.mdl", dm);

            sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
        }
        else
        {
            ThrowGib ("progs/gib1.mdl", dm);
            ThrowGib ("progs/gib2.mdl", dm);
            ThrowGib ("progs/gib3.mdl", dm);
//            if (self.modelindex == mindex_scorpio)
//            {
//                ThrowHead ("progs/h_scourg.mdl", dm);
//                sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
//            }
//            else
            {
                ThrowHead ("progs/h_player.mdl", dm);
    
                if ((damage_attacker.classname == "teledeath") || (self.deathtype == "falling"))
                    sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
                else if (random() < 0.5)
                    sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
                else
                    sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
            }
        }

        PlayerDead ();
        return TRUE;
    }
    return FALSE;
};

void() player_death_stats =
{
    self.weaponmodel    = "";
    self.view_ofs       = '0 0 -8';
    self.deadflag       = DEAD_DYING;
    self.solid          = SOLID_NOT;
    self.flags          = self.flags - (self.flags & FL_ONGROUND);
    self.movetype       = MOVETYPE_TOSS;
    if (self.velocity_z < 10)
        self.velocity_z = self.velocity_z + random()*300;

    self.waterlevel     = self.h2olevel;    // If flying, player can splash
    self.watertype      = self.h2otype;     // on land, so fix it.

// Use pain_finished to delay the time the player is allowed to respawn.
    if (deathmatch)
        self.pain_finished  = time + 3;
    else
        self.pain_finished  = time + 1.5;
};

void() player_die =
{
// DISABLED:  Powerup removal done in 'monster_death_use' (monsters.qc).
//    SUB_RemovePowerups ();    // This removes invisibility and sets mindex.

    if (self.form_active)
    {
//        if (self.form_active == FORM_SCORPIO)
//            self.modelindex = mindex_scorpio;
//        else
            self.modelindex = mindex_dragon;
    }
    else if (mindex_hammer && self.war == WAR_MJOLNIR)
    {
        if (self.hammer_finished)
            self.modelindex = mindex_hamout;
        else
            self.modelindex = mindex_hammer;
    }
    else if (mindex_saw && self.war == WAR_CHAINSAW)
        self.modelindex = mindex_saw;
    else
        self.modelindex = mindex_player;

    if (coop || deathmatch)
        DropBackpack ();

    player_death_stats ();

//- - - - - - - - -
// Arcanum:  Buriza effects.
    if (Shattered ())
        {PlayerDead ();  return;}
//- - - - - - - - -
// Note:  Decapitation does not look good unless engine supports
// npc colormaps.  Since most gl-based engines do not, don't check
// for decapitation and go straight to gibbing or normal death.
    if (player_gib (self.health))
        return;

// Since dead players lose all items, including invisibility and
// dragonscale, check the modelindex instead of the item for dragon form.
    if (self.modelindex == mindex_dragon)
        {baha_die();  return;}
//    if (self.modelindex == mindex_scorpio)
//        {scorpio_die();  return;}

    DeathSound ();
    
    self.angles_x = 0;
    self.angles_z = 0;

    local   float   r;

    r = random() * 5;   // Original had 6, which gave 5th anim double chance.
    r = ceil (r);

    if (self.war & WARx_AXE_FRAMES)
    {
        if (!mindex_hammer || (self.modelindex == mindex_player))
            player_die_ax1();
        else
            player_die_ham1();
    }
    else if (mindex_saw && self.war == WAR_CHAINSAW)
        player_die_saw1();
    else if (r == 1)
        player_diea1();
    else if (r == 2)
        player_dieb1();
    else if (r == 3)
        player_diec1();
    else if (r == 4)
        player_died1();
    else
        player_diee1();
};

//- - - - - - - - -
// Those killed by void have properties changed so that one becomes
// invisible and untouchable.  Called by creatures' th_void function.
void() KilledByVoid =
{
    // 'self' is the entity killed by void.
    self.modelindex     = mindex_inviso;
    self.solid          = SOLID_NOT;
    self.flags          = self.flags - (self.flags & FL_ONGROUND);
    self.movetype       = MOVETYPE_TOSS;
    self.takedamage     = DAMAGE_NO;
    self.th_gib         = world.null_func;
    self.gorging        = TRUE;
};

// Called when killed by 'trigger_void'.
void() player_void =
{
    KilledByVoid ();
    player_death_stats ();

// Note:  Since model is invisible, angles do not matter.
    sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
    PlayerDead ();
};
//- - - - - - - - -

void() set_suicide_frame =
{
// Below is the code from old 'set_suicide_frame'.
    if (self.model != "progs/player.mdl")
        return;    // already gibbed
    self.frame = $deatha11;
    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_TOSS;
    self.deadflag = DEAD_DEAD;
    self.nextthink = -1;
};


//===========================/  END OF FILE  /===========================//
