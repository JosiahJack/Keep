/*
==============================================================================

IMP

==============================================================================
*/

$cd id1/models/imp
$origin 0 0 24
$base base        
$skin skin

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14

$frame impfir1 impfir2 impfir3 impfir4 impfir5 impfir6 impfir7 impfir8
$frame impfir9 impfir10 impfir11 impfir12 impfir13 impfir14 impfir15
$frame impfir16 impfir17 impfir18 impfir19 impfir20 impfir21

$frame impfly1 impfly2 impfly3 impfly4 impfly5 impfly6 impfly7 impfly8
$frame impfly9 impfly10 impfly11 impfly12 impfly13 impfly14 impfly15
$frame impfly16 impfly17 impfly18 impfly19 impfly20

$frame impup1 impup2 impup3 impup4 impup5 impup6 impup7 impup8 impup9
$frame impup10 impup11 impup12 impup13 impup14 impup15 impup16 impup17
$frame impup18 impup19 impup20 impup21 impup22 impup23

$frame impwat1 impwat2 impwat3 impwat4 impwat5 impwat6 impwat7 impwat8
$frame impwat9 impwat10 impwat11 impwat12 impwat13 impwat14 impwat15
$frame impwat16 impwat17 impwat18 impwat19 impwat20 impwat21 impwat22
$frame impwat23 impwat24

$frame swoop1 swoop2 swoop3 swoop4 swoop5 swoop6 swoop7 swoop8 swoop9
$frame swoop10 swoop11 swoop12 swoop13 swoop14 swoop15 swoop16 swoop17
$frame swoop18 swoop19 swoop20

$frame swpcyc1 swpcyc2 swpcyc3 swpcyc4

$frame swpend1 swpend2 swpend3 swpend4 swpend5 swpend6 swpend7 swpend8
$frame swpend9 swpend10 swpend11 swpend12 swpend13 swpend14 swpend15

$frame swpout1 swpout2 swpout3 swpout4 swpout5 swpout6 swpout7 swpout8
$frame swpout9 swpout10 swpout11 swpout12 swpout13 swpout14 swpout15

// Extended scenes
$frame statue1

$frame statup1 statup2 statup3 statup4 statup5 statup6 statup7 statup8
$frame statup9

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9
$frame decap10 decap11 decap12 decap13 decap14

//=============================================================================

float() imp_lord = {return (self.classname == "monster_imp_lord");};

// Borrowed from Hexen2, checks if targ is within from's fov.
float(entity targ, entity from, float scope) in_fov =
{
    local   vector  spot1, spot2;
    local   float   dot;

    if (from.flags & FLx_CREATURE)
        spot1 = from.origin + from.view_ofs;
    else
        spot1 = Midpoint (from);
    spot2 = Aimpoint (targ);
    if (from.flags & FL_CLIENT)
        makevectors (from.v_angle);
    else
        makevectors (from.angles);
    dot = normalize(spot2 - spot1) * v_forward;
    dot = 180 - (dot * 180);
    return (dot <= scope);
};

//=============================================================================

float() ImpAttack;
void() imp_fire1;

//===================
// ImpCheckAttack
//===================
float() ImpCheckAttack =
{
    if (time < self.waitmin)
        return FALSE;   // Dodging something.
    if (!enemy_vis)
    {   // Could not see the target.
        self.attack_state = AS_STRAIGHT;
        return FALSE;
    }
    if (time < self.attack_finished)
        return FALSE;
    if (enemy_range != RANGE_MELEE)     // PM:  Let imps attack if close.
        if (!infront (self.enemy))
            return FALSE;   // Enemy must be infront.
    if (enemy_range == RANGE_FAR)
    {
        self.attack_state = AS_STRAIGHT;
        return FALSE;
    }

    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   chance;

    targ = self.enemy;
    
// see if any entities are in the way of the shot
//    makevectors (self.angles);
//    spot1 = self.origin + (v_forward*14) + (v_right*5) + (v_up * -4);
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    if (enemy_range == RANGE_MELEE)
        chance = FALSE;
    else
        chance = 2;     // Missile attacks are fat and wide.
    traceline (spot1, spot2, chance, self);

    chance = 1;     // PM:  Use as melee toggle before missile check.
    if (trace_ent != targ)
    {
        // Didn't hit the intended target.  Either something else blocked
        // the scan, or the scan was complete and could not hit the target.
        // Standard 1.06 progs would just return FALSE.
        if (trace_fraction < 1)
        {   // don't have a clear shot
            if (DontHurtMe (trace_ent))
            {   // In Hexen2, monsters will strafe to the side to
                // move around obstacles.
                self.attack_state = AS_SLIDING;
                return FALSE;   // Don't shoot whoever is in line of fire.
            }

            // Otherwise, whoever is in the way is a potential enemy and
            // hitting him instead of the intended target with missile
            // attacks is still useful.  Melee is still impossible though.
            chance = 0;
        }
        else
        {   // Target is non-solid.  It could be a wraith, downed zombie,
            // or something in spectator mode.

            // Unlike dragons, attack only if the target really is a ghost.
            if (targ.takedamage != DAMAGE_AIM)
                return FALSE;
            if (!IsGhost (targ))
                return FALSE;
// Commented out because those with no mindex should have DAMAGE_NO too.
//            if (!targ.modelindex)
//                return FALSE;
        }
    }

    // PM:  Added alert support so that some monsters can see and attack
    //      through water like players can.
    // FIXME:  Is the 'fish check' necessary here?
    if (trace_inopen)
        if (trace_inwater)
            if (!(self.ryuflags & RYU_ALERT))   // PM:  Alert support.
                return FALSE;            // sight line crossed contents

    if (enemy_range == RANGE_MELEE)
    {   // "melee" attack.  Imps' melee is a missile attack with melee option.
        if (chance)     // PM:  See above in the sight code.
        {
            imp_fire1 ();
            return TRUE;
        }
    }
    
// missile attack
    // Note:  This is for normal imps.  Imp lords should always pass the
    // attack chance, which turns them into trigger-happy monsters.
    // Note2:  Use imps' chance to attack from Hexen2.
    if (!imp_lord ())
    {
        chance = 0.5 - skill / 10;
        if (enemy_range == RANGE_LONG)  // PM:  New range between mid and far.
            chance = 1 - ((1 - chance) * 0.4);
        if (random() < chance)
            if (random() < chance)  // Check twice for 10 fps vs. Hexen2's 20 fps.
                return FALSE;
    }

    // Imp will do something evil...
    // self.attack_finished will be set at end of attack instead of here.
    return ImpAttack ();
};

//=============================================================================

void() imp_up1;
void() imp_down1;
void() imp_touch;

// Sets movetype to real flight and other stats needed for swooping.
void() imp_movefly =
{
    self.count      = 140;      // Flight speed.
    self.yaw_speed  = 30;
    self.velocity   = '0 0 0';
    self.movetype   = MOVETYPE_FLY;
    self.touch      = imp_touch;
    if (imp_lord ())
        sound (self, CHAN_VOICE, "imp/swoopbig.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "imp/swoop.wav", 1, ATTN_NORM);
};

// Sets imp movement to movetype_step and other stats.
void() imp_movestep =
{
    self.count      = 0;
    self.yaw_speed  = 15;
    self.velocity   = '0 0 0';
    self.movetype   = MOVETYPE_STEP;
    self.touch      = SUB_Null;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
};

// Make the imp ready for dodging.
void(float left, float motion) imp_set_dodge =
{
    self.lefty = left;
    self.attack_state = motion;
    if (motion == AS_VERTICAL)
    {
        if (self.movetype == MOVETYPE_FLY)
            imp_movestep ();    // Break out of swoop physics.

        self.waitmin = time + 1.5;
        if (left)
            imp_down1 ();
        else
            imp_up1 ();
    }
    else
        self.waitmin = time + 1;
};

float() imp_guard =
{
// Hexen2 used one second.  Too long for me, so use half that.
    if (self.enemy.attack_time + 0.5 < time)
        return FALSE;

    if (in_fov (self.enemy, self, 45))
    {
        local   vector  p1, p2, pd;
        local   float   dist, dot;

        p1 = self.enemy.origin + '0 0 16';   // player firing point - close enough.
        p2 = Midpoint (self);       // Imp's center.
    // PM:  The rest differs from Hexen2 to something I can understand
    // more easily.
        pd = normalize (p2 - p1);
        if (self.enemy.flags & FL_CLIENT)
        {
            makevectors (self.enemy.v_angle);
            pd = v_forward;
        }
        else if (self.pain_finished <= time)
            return FALSE;   // Don't dodge monsters unless hurt recently.

        makevectors (self.angles);
        dot = pd * v_right;
        if (dot > 0.1)
        {   // Go left.
            imp_set_dodge (1, AS_SLIDING);
            return TRUE;
        }
        if (dot < -0.1)
        {   // Go right.
            imp_set_dodge (0, AS_SLIDING);
            return TRUE;
        }
        if (imp_lord ())
            dist = 0.5;     // Don't let imp lords swoop so easily.
        else
            dist = 0.2;
        dot = pd * v_up;
        if (dot > dist)
        {   // Go down.
            imp_set_dodge (1, AS_VERTICAL);
            return TRUE;
        }
        // PM:  Changed to <= so imps can go up sometimes from centered aim.
        if (dot <= 0)   //(dot < 0)
        {   // Go up.
            imp_set_dodge (0, AS_VERTICAL);
            return TRUE;
        }
    }
    return FALSE;
};

void() imp_fly =
{
    if (self.waitmin)
    {   // DODGING
        if (self.waitmin <= time)
        {
            if (imp_guard ())
            {   // Resume evasion.
                if (self.attack_state == AS_VERTICAL)
                    return;     // Going up/down.
            }
            else
            {   // Stop strafing.
                self.waitmin = 0;
                self.attack_state = AS_STRAIGHT;
            }
        }
    }
    else
    {   // Normal
        if (imp_guard ())
        {   // Begin evasive manuvers.
            if (self.attack_state == AS_VERTICAL)
                return;     // Going up/down.
        }
    }
    ai_run (self.speed);
};

//=============================================================================

void() imp_sfx_fly =
{
    if (self.h2olevel <= 1)     // Not while in the water.
    {
        if (imp_lord ())
            sound (self, CHAN_BODY, "imp/flybig.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_BODY, "imp/fly.wav", 1, ATTN_NORM);
    }
    else if ((self.h2otype == CONTENT_WATER) || (self.h2otype == CONTENT_SLIME))
        sound (self, CHAN_BODY, "imp/flywater.wav", 1, ATTN_NORM);
};

//-.4, -.2, 0, 0, .2, .4, .4, .6, .6, .8,
//.6, .4, 0, 0, -.2, -.4, -.8, -.8, -.8, -.4
void() imp_speed =
{
    local   float   dist, add;

// Numbers are double of Hexen2's due to framerate difference.
    if (self.h2olevel >= 2)
        dist = 8;   // Reduced speed underwater.
    else
        dist = 16;
    if (fabs(self.angles_y - self.ideal_yaw) > 20)
        dist = dist / 1.5;

    if (( self.frame == $impfly1 ))
        add = -0.4;
    else if (( self.frame == $impfly5 ))
        add = 0.2;
    else if (( self.frame == $impfly7 ))
        add = 0.4;
    else if (( self.frame == $impfly9 ) || ( self.frame == $impfly11 ))
        add = 0.6;
    else if (( self.frame == $impfly15 ))
        add = -0.2;
    else if (( self.frame == $impfly17 ) || ( self.frame == $impfly19 ))
        add = -0.8;
    else
        add = 0;

    self.speed = dist + add*8;      // Hexen2's 4 times 2 for Quake.
//    self.level = add * 2;   // Times 2 for Quake.
};

//------------------------------------------------------------------------//
//  Fly animation forward.  Used for stand, walk, and run anims.
//
//  Stand = Monster hovers in place.
//  Walk  = Monster slowly glides along its path.
//  Run   = Monster flies quickly toward the enemy.
//------------------------------------------------------------------------//
void() imp_fly_anim =
{
    local   float   fadd;

    if (( self.frame < $impfly1 ) || ( self.walkframe >= 20 ))
        fadd = self.walkframe = 0;
    else
        fadd = self.walkframe;

    self.frame = $impfly1 + fadd;
    self.walkframe = self.walkframe + 2;
    imp_speed();

    if ( self.frame == $impfly1 )
        imp_sfx_fly ();
};

void() imp_stand =[ $impfly1, imp_stand  ] {imp_fly_anim(); ai_stand();};
void() imp_walk  =[ $impfly1, imp_walk   ] {imp_fly_anim(); ai_walk(self.speed);};
void() imp_run1  =[ $impfly1, imp_run1   ] {imp_fly_anim(); imp_fly();};
void() imp_run   =
{
    self.waitmin = 0;    // Stop dodging AI.
    self.attack_state = AS_STRAIGHT;
    imp_movestep();
    imp_run1();
};

// 25 27 29 31 33 35 25 15 5 -5
// Note:  Imp will be locked in a mini-swoop, so don't call ai_run until
// it is done.  Use 'ai_up(-dist)' to move.
void() imp_down1  =[ $swoop1,   imp_down2  ] {};    //ai_down(0);};
void() imp_down2  =[ $swoop3,   imp_down3  ] {ai_down(4);};
void() imp_down3  =[ $swoop5,   imp_down4  ] {ai_down(8);};
void() imp_down4  =[ $swoop7,   imp_down5  ] {ai_down(16);};
void() imp_down5  =[ $swoop9,   imp_down6  ] {ai_down(24);};
void() imp_down6  =[ $swoop11,  imp_down7  ] {ai_down(32);};
void() imp_down7  =[ $swoop13,  imp_down8  ] {ai_down(32);};
void() imp_down8  =[ $swoop15,  imp_down9  ] {ai_down(24);};
void() imp_down9  =[ $swoop17,  imp_down10 ] {ai_down(16);};
void() imp_down10 =[ $swoop19,  imp_down11 ] {ai_down(8);};
void() imp_down11 =[ $swpout3,  imp_down12 ] {};    //ai_run(0);};
void() imp_down12 =[ $swpout5,  imp_down13 ] {};    //ai_run(0);};
void() imp_down13 =[ $swpout7,  imp_down14 ] {};    //ai_run(0);};
void() imp_down14 =[ $swpout9,  imp_down15 ] {};    //ai_run(0);};
void() imp_down15 =[ $swpout11, imp_run    ] {};    //ai_run(0);};

// 30 30 31 31 32 32 33 20 10 0
void() imp_up1  =[ $impfly1,  imp_up2  ] {ai_run(8);};
void() imp_up2  =[ $impfly3,  imp_up3  ] {ai_run(16);};
void() imp_up3  =[ $impfly5,  imp_up4  ] {ai_run(24);};
void() imp_up4  =[ $impfly7,  imp_up5  ] {ai_run(32);};
void() imp_up5  =[ $impfly9,  imp_up6  ] {ai_run(32);};
void() imp_up6  =[ $impfly11, imp_up7  ] {ai_run(24);};
void() imp_up7  =[ $impfly13, imp_up8  ] {ai_run(16);};
// Note:  Hexen2 froze $impfly14 a few frames for longer ascent.
void() imp_up8  =[ $impfly14, imp_up9  ] {ai_run(12);};
void() imp_up9  =[ $impfly14, imp_up10 ] {ai_run(12);};
void() imp_up10 =[ $impfly15, imp_up11 ] {ai_run(8);};
void() imp_up11 =[ $impfly17, imp_up12 ] {ai_run(4);};
void() imp_up12 =[ $impfly19, imp_run  ] {ai_run(0);};

// ATTACK (Missile) - - - - - - - - - -
void() imp_attack =
{
    local   vector  org, dir;
    local   float   lord, reach;

    makevectors (self.angles);
    if (imp_lord ())
    {   lord = TRUE;  reach = 100;
        org = self.origin + (v_forward*28) + (v_right*10) + (v_up * 16);
    }
    else
    {   lord = FALSE;  reach = 60;
        org = self.origin + (v_forward*14) + (v_right*5) + (v_up * -4);
    }

// If close enough, give the enemy a good scratch.
    if (InMeleeRange (reach))   // 64 in Hexen2.
    if (CanDamage (self.enemy, self))
    {
        local   float   ldmg;

        sound (self, CHAN_WEAPON, "grem/attack.wav", 1, ATTN_NORM);

        if (lord)
            ldmg = 30 + 5*random();
        else
            ldmg = 10 + 5*random();     // Hexen2: 10 (40 for lords).
        dir = (ldmg * -10) * v_right - '0 0 50';

        T_NewDamage (self.enemy, self, self, ldmg, 0, "melee");
        SpawnMeatSpray (org, dir, self.enemy.bloodtype);
        return;
    }
// Can't use melee, so fling some junk instead.
// missiles: fireball is 12-22 or 80-120 in h2.
// ice is 5-10 or 33-77.
    local   vector  end;

    end = Aimpoint (self.enemy);
    dir = Maim_Line (org, end, 600, world, '0 0 0');
    if (self.ryuflags & RYU_ELEMENTS == RYU_USE_ICE)
    {   // ICE SHARDS
        local   vector  err, base;
        local   float   loop, sped;

        sound (self, CHAN_WEAPON, "imp/shard.wav", 1, ATTN_NORM);

        err = '6 4.5 0';
        if (lord)
            loop = (random() * 2) & 1 + 4;
        else
            loop = 3;
        base = Aimpoint (self.enemy);
        base = normalize (base - org);
        while (loop > 0)
        {
            sped = 430 + random()*180;
            if (lord)
                sped = sped * 2;
            loop = loop - 1;
            if (!loop)
                err = '0 0 0';  // Last shot in loop uses unaltered velocity.
            dir = Maim_Scatter (base, err);
            Ice_Launch (org, dir, sped);
            if (lord)
                newmis.dmg  = 18;
            newmis.delay = time + 5;
        }
    }
    else
    {   // FIREBALL
        self.effects = self.effects | EF_MUZZLEFLASH;
        if (lord)
        {
            sound (self, CHAN_WEAPON, "baron/fireball.wav", 1, ATTN_NORM);
            KnightBall_Launch (org, dir);
            newmis.dmg = 60;
            newmis.style = newmis.style | DF_SAFE;
        }
        else
        {
            sound (self, CHAN_WEAPON, "imp/fireball.wav", 1, ATTN_NORM);
            ImpBall_Launch (org, dir);
        }
    }
};

void() imp_fight =
{
    if (imp_guard ())
    {
        if (self.attack_state != AS_VERTICAL)
            imp_run1();
        return;
    }

    ai_face ();     // Stop to fire.
    if ( self.frame == $impfir17 )
        imp_attack();
};

// Note to self, tried glittering hands as used by the modified gauroch,
// but that doesn't look good on the imps.
void() imp_fire1  =[ $impfir1,  imp_fire2  ] {imp_fight();};
void() imp_fire2  =[ $impfir3,  imp_fire3  ] {imp_fight();};
void() imp_fire3  =[ $impfir5,  imp_fire4  ] {imp_fight();};
void() imp_fire4  =[ $impfir7,  imp_fire5  ] {imp_fight();};
void() imp_fire5  =[ $impfir9,  imp_fire6  ] {imp_fight();};
void() imp_fire6  =[ $impfir11, imp_fire7  ] {imp_fight();};
void() imp_fire7  =[ $impfir13, imp_fire8  ] {imp_fight();};
void() imp_fire8  =[ $impfir15, imp_fire9  ] {imp_fight();};
void() imp_fire9  =[ $impfir17, imp_fire10 ] {imp_fight();};
void() imp_fire10 =[ $impfir19, imp_fire11 ] {imp_fight();};
void() imp_fire11 =[ $impfir21, imp_run    ]
{
// Refire check as per Hexen2.
    if (self.enemy.health > 0)
        if (visible (self.enemy))
            if (random() < 0.2 + skill / 10)
                self.think = imp_fire1;
// Don't want Nightmare bypass so don't use SUB_AttackFinished here.
    self.attack_finished = time + 1;
    imp_fight();
};

// ATTACK (Swoop) - - - - - - - - - - -
// Called and used only by imp_tocuh.
void() imp_swpend =
{
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity_x = self.velocity_x / 1.2;
    self.velocity_y = self.velocity_y / 1.2;
    self.velocity_z = self.velocity_z + 30;     //Hexen2 used 15.
};

void() imp_swpend1  =[ $swpend1,  imp_swpend2  ] {imp_swpend();};
void() imp_swpend2  =[ $swpend3,  imp_swpend3  ] {imp_swpend();};
void() imp_swpend3  =[ $swpend5,  imp_swpend4  ] {imp_swpend();};
void() imp_swpend4  =[ $swpend7,  imp_swpend5  ] {imp_swpend();};
void() imp_swpend5  =[ $swpend9,  imp_swpend6  ] {imp_swpend();};
void() imp_swpend6  =[ $swpend11, imp_swpend7  ] {imp_swpend();};
void() imp_swpend7  =[ $swpend13, imp_swpend8  ] {imp_swpend();};
void() imp_swpend8  =[ $swpend15, imp_run      ] {imp_swpend(); SUB_AttackFinished(1); imp_movestep();};

void() imp_bounce1  =[ $swoop9,  imp_bounce2  ] {imp_swpend();};
void() imp_bounce2  =[ $swoop7,  imp_bounce3  ] {imp_swpend();};
void() imp_bounce3  =[ $swoop5,  imp_bounce4  ] {imp_swpend();};
void() imp_bounce4  =[ $swoop3,  imp_bounce5  ] {imp_swpend();};
void() imp_bounce5  =[ $swoop1,  imp_run      ] {imp_swpend(); SUB_AttackFinished(1); imp_movestep();};

void() imp_painc1;
void() imp_touch =
{
    self.touch = SUB_Null;
// PM:  Included more frames that imp can damage other with.
    if ( (( self.frame >= $swpcyc1 ) && ( self.frame <= $swpcyc4 )) ||
    (( self.frame >= $swoop10 ) && ( self.frame <= $swoop20 )) )
    {
        self.flags = self.flags - (self.flags & FL_ONGROUND);
        sound (self, CHAN_WEAPON, "weapons/axhit.wav", 1, ATTN_NORM);
        if ( self.frame <= $swoop15 )
            self.think = imp_bounce1;
        else
            self.think = imp_swpend2;   //swpend1;
        if (other.takedamage)
        {
            local   float   damage, dx;

            if (( self.frame >= $swpcyc1 ) && ( self.frame <= $swpcyc4 ))
                dx = self.count;
            else if (( self.frame >= $swoop16 ) && ( self.frame <= $swoop20 ))
                dx = ( self.frame - $swoop16 ) * 5;
            else
                dx = 0;
            damage = 10 + dx / 2;
            // Damage was x4/3, a bit much now.
            damage = damage * 1.2;     // Hexen2 pcs began with sub-100 hp.
            if (imp_lord ())
            {   // Hexen2 damage was 33+dx*5 -- way too much!
                damage = 30 + dx * 2;
            }
            T_NewDamage (other, self, self, damage, 0, "swoop");
        }
        else if ( self.frame > $swoop15 )
        {
//            Tent_Point (TE_GUNSHOT, self.origin);
            imp_movestep ();
            imp_painc1 ();
        }
    }
    else
    {
//- - - - - - - - -
// Extra recovery logic.
        if ( self.frame <= $swoop9 )
        {
            if ( self.frame <= $swoop3 )
                self.think = imp_bounce5;
            else if ( self.frame <= $swoop5 )
                self.think = imp_bounce4;
            else if ( self.frame <= $swoop7 )
                self.think = imp_bounce3;
            else
                self.think = imp_bounce2;
        }
//        else if ( self.frame <= $swoop15 )
//            self.think = imp_bounce1;
        else if ( self.frame >= $swpout9 )
            self.think = imp_run;
        else if ( self.frame >= $swpout5 )
            self.think = imp_swpend3;
        else
            self.think = imp_swpend2;   //swpend1;
//- - - - - - - - -
        if (vlen(self.velocity) > 300)
            sound (self, CHAN_WEAPON, "weapons/axhit.wav", 1, ATTN_NORM);
    }
};

void() imp_slow =
{
    if (self.velocity_x > 10)
        self.velocity_x = self.velocity_x / 2;
    else
        self.velocity_x = 0;
    if (self.velocity_y > 10)
        self.velocity_y = self.velocity_y / 2;
    else
        self.velocity_y = 0;
};
void() imp_abort1  =[ $swpout1,  imp_abort2  ] {imp_slow();};
void() imp_abort2  =[ $swpout3,  imp_abort3  ] {imp_slow();};
void() imp_abort3  =[ $swpout5,  imp_abort4  ] {imp_slow();};
void() imp_abort4  =[ $swpout7,  imp_abort5  ] {imp_slow();};
void() imp_abort5  =[ $swpout9,  imp_abort6  ] {imp_slow();};
void() imp_abort6  =[ $swpout11, imp_abort7  ] {imp_slow();};
void() imp_abort7  =[ $swpout13, imp_abort8  ] {imp_slow();};
void() imp_abort8  =[ $swpout15, imp_run     ] {imp_slow(); SUB_AttackFinished(1);};

// Charging.
void() imp_charge =
{
    if (self.enemy.attack_time + 0.5 > time)
    {
        if (in_fov (self.enemy, self, 45))
        {
            // PM:  Also added more checks.
            if (vlen(self.enemy.origin - self.origin) > 250)
//            if ( !((self.enemy.flags & FL_CLIENT) && (self.enemy.war & WARx_AXE_FRAMES)) )
            {
                self.velocity_z = self.velocity_z + 150;
                imp_abort1 ();
                return;
            }
            // ELSE... keep going for the hit!
        }
    }
    if (visible (self.enemy))
    if (infront (self.enemy))
    if (range (self.enemy) < RANGE_FAR)
    {
        local   vector  spot1, spot2, dir;

        spot1 = self.origin;    //Midpoint (self);
        spot2 = Aimpoint (self.enemy);
        dir = normalize (spot2 - spot1);
        self.velocity = dir * (self.count * 10 + 500);   //(self.count * 7 + 377);

        ai_face();
        // Should increment counter by 2 due to game framerate differences,
        // but the swoop wouldn't last long enough for long range attacking.
        // Thus, up counter by 1, not 2, to give roughly three second swoop.
        self.count = self.count + 1;
        if (self.flags & FL_ONGROUND || self.count > 30)
        {
            self.flags = self.flags - (self.flags & FL_ONGROUND);
            imp_abort1 ();
        }
        return;
    }
    imp_abort1 ();
};
void() imp_charge1 =[ $swpcyc1,  imp_charge2 ] {imp_charge();};
void() imp_charge2 =[ $swpcyc2,  imp_charge3 ] {imp_charge();};
void() imp_charge3 =[ $swpcyc3,  imp_charge4 ] {imp_charge();};
void() imp_charge4 =[ $swpcyc4,  imp_charge1 ] {imp_charge();};

// Dive-and-swoop.
void() imp_dive;
void() imp_swoop1  =[ $swoop1,  imp_swoop2  ] {imp_movefly(); imp_dive();};
void() imp_swoop2  =[ $swoop3,  imp_swoop3  ] {imp_dive();};
void() imp_swoop3  =[ $swoop5,  imp_swoop4  ] {imp_dive();};
void() imp_swoop4  =[ $swoop7,  imp_swoop5  ] {imp_dive();};
void() imp_swoop5  =[ $swoop9,  imp_swoop6  ] {imp_dive();};
void() imp_swoop6  =[ $swoop11, imp_swoop7  ] {imp_dive();};
void() imp_swoop7  =[ $swoop13, imp_swoop7  ] {imp_dive();};  // Loop
void() imp_swoop8  =[ $swoop15, imp_swoop9  ] {imp_dive();};
void() imp_swoop9  =[ $swoop17, imp_swoop10 ] {imp_dive();};
void() imp_swoop10 =[ $swoop19, imp_charge1 ] {imp_dive(); self.count = 0;};
void() imp_dive =
{
    ai_face();
    self.count = self.count * 1.3225;   // 1.15 * 1.15 = 1.3225.
    if ( self.frame >= $swoop12 )
    {
        local   vector  spot1, spot2, dir;

        spot1 = self.origin;
        spot1_z = self.absmin_z;
        spot2 = Aimpoint(self.enemy);
        dir = normalize(spot2 - spot1);
        self.velocity = dir * self.count;
        if ( self.frame <= $swoop13 )
            self.velocity_x = self.velocity_y = 0;
        if ( self.frame == $swoop13 )
            if (self.absmin_z - self.enemy.absmax_z > 50)
                self.frame = $swoop12;
    }
    if (( self.frame == $swoop12 ) || ( self.frame == $swoop13 ))
    {
        if ((self.flags & FL_ONGROUND) || (self.origin_z - self.enemy.origin_z < 60))
        {
            self.flags = self.flags - (self.flags & FL_ONGROUND);
            self.count = 280;
            self.think = imp_swoop8;
        }
        // PM:  Always send the imp down so it doesn't get stuck in loop.
        else if (self.velocity_z > -80)
            self.velocity_z = -80;      // Equivalent to 8 pixel shift.
    }
    // If last frame, set speed to 0.  (Done elsewhere.)
};

// Straight swoop.
void() imp_out =
{
    ai_face();
//    if ( !((self.enemy.flags & FL_CLIENT) && (self.enemy.war & WARx_AXE_FRAMES)) )
    if (imp_guard ())   // Abort if TRUE.
    {
        if (self.attack_state != AS_VERTICAL)
            imp_run ();
//        return;
    }
};
void() imp_swpout1  =[ $swpout15, imp_swpout2  ] {imp_movefly(); imp_out();};
void() imp_swpout2  =[ $swpout13, imp_swpout3  ] {imp_out();};
void() imp_swpout3  =[ $swpout11, imp_swpout4  ] {imp_out();};
void() imp_swpout4  =[ $swpout9,  imp_swpout5  ] {imp_out();};
void() imp_swpout5  =[ $swpout7,  imp_swpout6  ] {imp_out();};
void() imp_swpout6  =[ $swpout5,  imp_swpout7  ] {imp_out();};
void() imp_swpout7  =[ $swpout3,  imp_swpout8  ] {imp_out();};
void() imp_swpout8  =[ $swpout1,  imp_charge1  ] {self.count = 0; imp_out();};

// ATTACK - - - - - - - - - - - - - - -
void(vector p1, vector p2) fat_trace =
{
    traceline (p1, p2, FALSE, self);
    if (trace_fraction == 1.0)
    {
        local   vector  add;

        add = self.mins;
        add_z = 0;
        traceline (p1 + add, p2 + add, FALSE, self);
        if (trace_fraction == 1.0)
        {   add_x = self.maxs_x;
            traceline (p1 + add, p2 + add, FALSE, self);
            if (trace_fraction == 1.0)
            {   add_y = self.maxs_y;
                traceline (p1 + add, p2 + add, FALSE, self);
                if (trace_fraction == 1.0)
                {   add_x = self.mins_x;
                    traceline (p1 + add, p2 + add, FALSE, self);
                }
            }
        }
    }
};

// Select an attack for the imp to use.
float() ImpAttack =
{
    local   float   lo;
    local   float   nodrop, dx, dy;
    local   vector  spot1, spot2, spot3, down;

    if (imp_lord ())
        if (random() < 0.5)
            {imp_fire1 ();  return TRUE;}   // Lords shoot more and dive less.

    nodrop = FALSE;
    spot1 = Midpoint(self);     //self.origin + self.view_ofs;
    spot2 = self.enemy.origin + '0 0 16';   //self.enemy.view_ofs;
    spot3 = spot2;
    spot3_z = spot1_z;
    dx = vlen(spot3 - spot1);
    if (imp_lord ())
        dy = self.absmin_z - spot2_z;
    else
        dy = spot1_z - spot2_z;
    if (dy <= 36)
        if (random() < 0.3)
            nodrop = TRUE;
    if (imp_lord ())
        lo = 140;
    else
        lo = 100;
    if (dx > lo)
        if ((dy > 36) || nodrop)
        {
            down = '0 0 -1' * dy;
            fat_trace (spot1, spot1 + down);
            if ((trace_fraction == 1) || nodrop)
            {
                if (nodrop)
                    traceline (spot1, spot2, 2, self);
                else
                    traceline (spot1 + down, spot2, 2, self);
                if (trace_ent == self.enemy)
                {
                    if (nodrop)
                        imp_swpout1 ();     // Head straight.
                    else
                        imp_swoop1 ();      // Dive, then go.
                    return TRUE;
                }
            }
        }

    // Fire imps attack less -- try to get close.
    // Update:  Does not apply to lords.
    if (!imp_lord ())
    {
        if ((self.ryuflags & RYU_ELEMENTS) == RYU_USE_FIRE)
            if (random() < 0.5)
                return FALSE;
    }

    imp_fire1 ();
    return TRUE;
};

// PAIN - - - - - - - - - - - - - - - -
void() imp_pain1  =[ $death4,  imp_pain2   ] {};
void() imp_pain2  =[ $death3,  imp_pain3   ] {};
void() imp_pain3  =[ $death2,  imp_pain4   ] {};
void() imp_pain4  =[ $death1,  imp_run     ] {};

void() imp_painb1 =[ $impup17,  imp_painb2  ] {ai_back(4);};
void() imp_painb2 =[ $impup18,  imp_painb3  ] {ai_back(4);};
void() imp_painb3 =[ $impup19,  imp_painb4  ] {ai_back(3);};
void() imp_painb4 =[ $impup20,  imp_painb5  ] {ai_back(2);};
void() imp_painb5 =[ $impup21,  imp_painb6  ] {ai_back(1);};
void() imp_painb6 =[ $impup22,  imp_painb7  ] {};
void() imp_painb7 =[ $impup23,  imp_run     ] {};

void() imp_painc1  =[ $impup14,  imp_painc2  ] {ai_back(4);};
void() imp_painc2  =[ $impup13,  imp_painc3  ] {ai_back(4);};
void() imp_painc3  =[ $impup12,  imp_painc4  ] {ai_back(4);};
void() imp_painc4  =[ $impup11,  imp_painc5  ] {ai_back(4);};
void() imp_painc5  =[ $impup10,  imp_painc6  ] {ai_back(4);};
void() imp_painc6  =[ $impup9,   imp_painc7  ] {ai_back(4);};
void() imp_painc7  =[ $impup8,   imp_painc8  ] {ai_back(4);};
void() imp_painc8  =[ $impup7,   imp_painc9  ] {ai_back(4);};
void() imp_painc9  =[ $impup6,   imp_painc10 ] {ai_back(4);};
void() imp_painc10 =[ $impup7,   imp_painc11 ] {ai_back(4);};
void() imp_painc11 =[ $impup8,   imp_painc12 ] {ai_back(4);};
void() imp_painc12 =[ $impup9,   imp_painc13 ] {ai_back(4);};
void() imp_painc13 =[ $impup10,  imp_painc14 ] {ai_back(4);};
void() imp_painc14 =[ $impup11,  imp_painc15 ] {ai_back(4);};
void() imp_painc15 =[ $impup12,  imp_painc16 ] {ai_back(4);};
void() imp_painc16 =[ $impup13,  imp_painc17 ] {ai_back(4);};
void() imp_painc17 =[ $impup14,  imp_run     ] {ai_back(4);};

void(entity attacker, float damage) imp_pain =
{
    local   float   r;

// don't make multiple pain sounds right after each other
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;
    if (imp_lord ())
        sound (self, CHAN_VOICE, "imp/swoopbig.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "imp/swoop.wav", 1, ATTN_NORM);
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    imp_movestep();

    r = random();
    if (skill >= 3)
        r = r * 0.6;
    if (r < 0.2)
        imp_pain1 ();
    else if (r < 0.6)
    {
        self.pain_finished = time + 1.5;    //2;
        imp_painb1 ();
    }
    else
    {   // As per Hexen2.
        if (imp_lord ())
            sound (self, CHAN_VOICE, "imp/upbig.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "imp/up.wav", 1, ATTN_NORM);
        self.pain_finished = time + 3;
        imp_painc1 ();
    }

    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() imp_decap1  =[ $decap1,  imp_decap2    ] {blood_spray ('3 0 0', 1);};
void() imp_decap2  =[ $decap3,  imp_decap3    ] {blood_spray ('-2 0 3', 2);};
void() imp_decap3  =[ $decap5,  imp_decap4    ] {blood_spray ('-12 0 -3', 1); monster_drop(); self.attack_finished = time + 3;};
void() imp_decap4  =[ $decap7,  imp_decap5    ] {self.nextthink = time + 0.1 + random()*0.1;};
void() imp_decap5  =[ $decap9,  imp_decap6    ]
{   if (!(self.flags & FL_ONGROUND))
    if (self.attack_finished > time)
//    if (self.velocity_z < 0)
    {   // Still falling, so frame cycle.  Flutter more randomly.
        self.frame = $decap8;
        self.think = imp_decap4;
        self.nextthink = time + 0.1 + random()*0.1;
    }
};
void() imp_decap6  =[ $decap11, imp_decap7    ] {};
void() imp_decap7  =[ $decap13, imp_decap8    ] {};
void() imp_decap8  =[ $decap14, decap_end     ] {};

void() imp_die1  =[ $death1,  imp_die2    ] {};
void() imp_die2  =[ $death3,  imp_die3    ] {};
void() imp_die3  =[ $death5,  imp_die4    ] {monster_drop(); self.attack_finished = time + 3;};
void() imp_die4  =[ $death7,  imp_die5    ] {self.nextthink = time + 0.1 + random()*0.1;};
void() imp_die5  =[ $death9,  imp_die6    ]
{   if (!(self.flags & FL_ONGROUND))
        if (self.attack_finished > time)
        {   // Still falling, so frame cycle.  Flutter more randomly.
            self.frame = $death8;
            self.think = imp_die4;
            self.nextthink = time + 0.1 + random()*0.1;
        }
};
void() imp_die6  =[ $death11, imp_die7    ] {};
void() imp_die7  =[ $death13, imp_die8    ] {};
void() imp_die8  =[ $death14, monster_end ] {};

void() imp_body =
{
// No head?  Just use the first skin for the wing.
//    {decap_explode ("progs/imp_wing.mdl", "progs/gib1.mdl", "progs/zom_gib.mdl");};

    sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowIt ("progs/imp_wing.mdl", self.health, GIBx_GIB|GIB_SKIN_MATCH);
    ThrowGib ("progs/gib1.mdl", self.health);
    ThrowGib ("progs/zom_gib.mdl", self.health);

    Burn_Null (self);
    self.solid      = SOLID_NOT;
    self.modelindex = 0;
    self.nextthink  = 0.01;
    self.think      = SUB_Remove;
}

float(float dm) imp_gib =
{
    if (self.health < self.gib_health)
    {
        self.height = 0;    // Only one frame for wing gib.
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        if (imp_lord ())
        {
            ThrowIt ("progs/impwing2.mdl", dm, GIBx_GIB|GIB_SKIN_MATCH);
            ThrowGib ("progs/gib1.mdl", dm);
            ThrowGib ("progs/gib2.mdl", dm);
            ThrowHead ("progs/h_imp2.mdl", dm);
            return TRUE;
        }
        ThrowIt ("progs/imp_wing.mdl", dm, GIBx_GIB|GIB_SKIN_MATCH);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/zom_gib.mdl", dm);
        ThrowHead ("progs/h_imp.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() imp_die =
{
    local   float   flying;

    flying = (self.movetype == MOVETYPE_FLY);
    imp_movestep ();

    if (Shattered ())
        return;
    if (Decapitated ())
    {
        monster_decap ('3 0 0', imp_decap1);
        newmis.th_die = imp_body;
        return;
    }

// check for gib
    if (imp_gib (self.health))
        return;

    // Hexen2 gave imp movetype_bounce, but I'm not going to entertain that.
    makevectors (self.angles);
    if (flying)
        self.velocity_z = 0;
    else
        self.velocity = '0 0 200' * random();
    self.velocity = self.velocity + (v_forward * 80);

    if (imp_lord ())
        sound (self, CHAN_VOICE, "imp/diebig.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "imp/die.wav", 1, ATTN_NORM);
    imp_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() imp_revive1  =[ $death13,  imp_revive2  ] {self.flags = (self.flags - (self.flags & FL_ONGROUND)) | FL_FLY;};
void() imp_revive2  =[ $death11,  imp_revive3  ] {};
void() imp_revive3  =[ $death9,   imp_revive4  ] {};
void() imp_revive4  =[ $death7,   imp_revive5  ] {};
void() imp_revive5  =[ $death5,   imp_revive6  ] {};
void() imp_revive6  =[ $death3,   imp_revive7  ] {};
void() imp_revive7  =[ $death1,   imp_run      ] {};


//==========================================================================
//  Statues

//- - - - - - - - -
// 0, 0,0, 0,0, 0,0, 0,1, 2,2, 2,3, 3,3, 3,4, 4,5, 6,7, 5,2
//- - - - - - - - -
//void() imp_break1  =[ $statup1,  imp_break2  ] {self.nextthink = time + 0.1 + random()*0.1;};
//void() imp_break2  =[ $statup3,  imp_break3  ] {self.nextthink = time + 0.1 + random()*0.1;};
void() imp_break3  =[ $statup5,  imp_break4  ] {self.nextthink = time + 0.1 + random()*0.1;};
void() imp_break4  =[ $statup7,  imp_break5  ] {self.nextthink = time + 0.1 + random()*0.1;};
void() imp_break5  =[ $statup9,  imp_break6  ] {self.nextthink = time + 0.1 + random()*0.1;};
void() imp_break6  =[ $impup11,  imp_break7  ]
{   // Break its stone shell.
    self.mass       = MASS_LIGHT;
    self.skin       = self.count;
    self.count      = 0;
    self.takedamage = DAMAGE_AIM;
    self.flags      = self.flags | FL_FLY;
    ThrowRocks (3);
// Update:  Disabled forward movement so imp can stay for possible ambush.
//    ai_forward(4);
};
void() imp_break7  =[ $impup13, imp_break8  ] {};   //ai_forward(5);};
void() imp_break8  =[ $impup15, imp_break9  ] {};   //ai_forward(6);};
void() imp_break9  =[ $impup17, imp_break10 ] {};   //ai_forward(7);};
void() imp_break10 =[ $impup19, imp_break11 ] {};   //ai_forward(9);};
void() imp_break11 =[ $impup21, imp_break12 ] {};   //ai_forward(13);};
void() imp_break12 =[ $impup23, imp_run     ] {monster_start_think();};   //ai_forward(7); monster_start_think();};

void() imp_use =
{
    local   vector  up, spot;
    local   float   go;

    up = '0 0 64';
    go = FALSE;
// Check if someone is standing on the imp.  Delay activation if so.
    spot = self.origin - '0 0 24';
    fat_trace (spot, spot + up);
    if (trace_fraction == 1.0)
        go = TRUE;      // All clear!

    if (go)
    {   // Imp will burst out of its shell.
        self.touch = SUB_Null;      // Can't push it anymore.
        setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
        self.xsf = self.xsf | XSF_STATUE;   // So monstart doesn't set think.
        monster_start_go ();
//        monster_use ();     // Set enemy.
        imp_break3 ();
    }
    else
    {   // Try again later.
        self.nextthink  = time + 0.5;
        self.think      = imp_use;
    }
};

// Slides the imp statue along the ground when touched by other.
void() imp_push =
{
    if (other.flags & FLx_CREATURE)
    {   // Only let other creatures push chests.
        local   float   yaw;

        if (other.movetype == MOVETYPE_WALK)
            CheckOnTop ();
        if (self.absmax_z <= other.absmin_z + 2)
            return;     // Don't let players slide objects from above.

    // Push object.
        yaw = vectoyaw(other.velocity);
        if (walkmove (yaw, 32 * frametime))   // Harder to push than chests.
        {   // Moved object, now check for push sound.
            if (self.attack_finished <= time)
            {
                sound (self, CHAN_BODY, "misc/pushston.wav", 1, ATTN_IDLE);
                self.attack_finished = time + 0.5;
            }
        }
    }
};

void() imp_statue_start = {statue_start (imp_use);};


//============================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) imp_sight =
{
    if (!hello)
    {
        if (imp_lord ())
            sound (self, CHAN_VOICE, "imp/upbig.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "imp/up.wav", 1, ATTN_NORM);
    }
};

void() imp_cache =
{
    precache_model ("progs/imp.mdl");
    precache_model ("progs/h_imp.mdl");
    precache_model ("progs/ice.mdl");
    precache_model ("progs/imp_rock.mdl");
    precache_model ("progs/imp_wing.mdl");
    precache_model ("progs/k_ball.mdl");
//    precache_model ("progs/zom_gib.mdl");

    precache_sound ("dragon/icehit.wav");
    precache_sound ("grem/attack.wav");     // Replaces Hexen2 imp slash sfx.
    precache_sound ("imp/die.wav");
    precache_sound ("imp/fireball.wav");
    precache_sound ("imp/fly.wav");
    precache_sound ("imp/flywater.wav");
    precache_sound ("imp/shard.wav");
    precache_sound ("imp/swoop.wav");
    precache_sound ("imp/up.wav");
    precache_sound ("misc/pushston.wav");
    precache_sound ("misc/wallbrk.wav");
//    precache_sound ("weapons/axhit.wav");
    precache_model ("progs/s_wave2.spr");
};

void() imp_lord_cache =
{
    precache_model ("progs/imp_lord.mdl");
    precache_model ("progs/h_imp2.mdl");
    precache_model ("progs/ice.mdl");
    precache_model ("progs/imp_rock.mdl");
    precache_model ("progs/impwing2.mdl");
    precache_model ("progs/k_ball.mdl");
//    precache_model ("progs/zom_gib.mdl");
    precache_model ("progs/s_wave2.spr");

    precache_sound ("grem/attack.wav");     // Replaces Hexen2 imp slash sfx.
    precache_sound ("imp/diebig.wav");
    precache_sound ("imp/fireball.wav");
    precache_sound ("imp/flybig.wav");
    precache_sound ("imp/flywater.wav");
    precache_sound ("imp/shard.wav");
    precache_sound ("imp/swoopbig.wav");
    precache_sound ("imp/upbig.wav");
    precache_sound ("misc/pushston.wav");
    precache_sound ("misc/wallbrk.wav");
//    precache_sound ("weapons/axhit.wav");
};

//============
// --> QUAKED monster_imp (1 0 0) (-16 -16 -24) (16 16 32) Ambush Sit Statue x Statue
//
// Sitting is for rooftop placement.  Place bbox 14 or 15 pixels over edge.
// If 'statue' for rooftops, stick bbox 12 pixels over the edge.
//============
// FIXME:  Add sitting.
void() monster_imp =
{
    local   float   hp;     // Default health.
    local   float   lord;

    lord = imp_lord();

    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        if (lord)
            imp_lord_cache ();
        else
            imp_cache ();
    }

    hp = 75;
    // Borrow some code used by Dragons to set attack types.
    // Assumes no skin changing later on.
    if (self.skin & 1)
    {
        self.ryuflags = RYU_USE_ICE;
        if (self.skin == 3)
        {   hp = 100;
            self.resist_cold = 1.5;     // Heal from ice.
        }
        else
        {   self.skin = 1;
            self.resist_cold = 0.5;
        }
    }
    else
    {
        self.ryuflags = RYU_USE_FIRE;
        if (self.skin == 2)
        {   hp = 75;
            self.resist_fire = 1.5;     // Heal from fire.
        }
        else
        {   self.skin = 0;
            self.resist_fire = 0.5;
        }
    }
// Hexen2 imps:  Fire imps have 75 health, ice imps have 100 health.
// Imp lord has 600 health.  Doom imps have 60 health.  +100 for statues.
// Hexen2 imps gibbed at -30 health.
    if (lord)
    {   // Lords had 600 hp, but that is too much.
        monster_form ("progs/imp_lord.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 300, -60);
        self.mdl_head   = "progs/h_imp2.mdl";
//        self.mass       = MASS_LIGHT;
    }
    else
    {
        monster_form ("progs/imp.mdl", '-16 -16 -24', '16 16 32', hp, -35);
        self.mdl_head   = "progs/h_imp.mdl";
//        self.mass       = MASS_LIGHT;
    }

    // Hexen2 has swooping for missile and lobbing for melee.
    // Here, in Drake, use lobbing for missile only.  Actually, th_* attack
    // functions are not used by the imp and are here only as a formality.
    self.th_stand   = imp_stand;
    self.th_walk    = imp_walk;
    self.th_run     = imp_run;
    self.th_missile = imp_fire1;
    self.th_pain    = imp_pain;
    self.th_die     = imp_die;
    //- - - - - - - -
    self.th_sight   = imp_sight;
    self.th_check   = ImpCheckAttack;
    self.th_gib     = imp_gib;
    self.th_revive  = imp_revive1;
    self.th_spawn   = monster_imp;

    self.speed      = 16;
    self.yaw_speed  = 15;
    self.waitmin    = 0;

    self.family     = FAM_IMP;
    if (soul_evil)
    {
        if (lord)
            monster_purse (3, 0.5, 0.5);  // 50% for drop, equal chance of coin/gem.
        else
            monster_purse (1, 0.5, 0.5);  // 50% for drop, equal chance of coin/gem.
    }

    if (!respawning)
    if (self.spawnflags & SPAWN_STATUE)
    {   // Statue stuff.
        if (self.spawnflags & SPAWNx_DELAY)
        {   // Conflict, sf64 overrides statue.
            // FIXME:  Resolve conflict so that statue can delay spawn.
            self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_STATUE);
        }
        else
        {   // Turn imp into a statue.
            // Unlike Hexen2, statue imps are indestructible.
            // Note:  Don't let statues use sf64.
            self.count      = self.skin;
            self.flags      = self.flags - (self.flags & FL_FLY);
            self.skin       = 4;
            self.takedamage = DAMAGE_NO;
            self.touch      = imp_push;
            self.frame      = $statue1;
            if (lord)
                setsize (self, '-32 -32 -24', '32 32 16');
            else
                setsize (self, '-16 -16 -24', '16 16 4');
            self.nextthink  = time + 0.2;
            self.think      = imp_statue_start;
            return;
        }
    }
    self.mass       = MASS_LIGHT;
    flymonster_start ();
};

void() monster_imp_fire =
    {self.skin = 0;  self.classname = "monster_imp";  monster_imp();};

void() monster_imp_ice =
    {self.skin = 1;  self.classname = "monster_imp";  monster_imp();};

void() monster_imp_lord = {monster_imp ();};


//===========================/  END OF FILE  /===========================//
