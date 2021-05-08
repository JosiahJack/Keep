//==========================================================================
//  ryu.qc -- by Patrick Martin                 Last updated:  5-8-2001
//--------------------------------------------------------------------------
//  This file contains code for the dragons, both large and small.
//  The model used for the dragons is based from iD's Qtest dragon.
//  However, the model is modified from the original.  I added many
//  more frames (the Qtest dragon only had 18 frames), and the size
//  is reduced.  Large dragons are 40% of the original size and the
//  small dragons are only 16%.  Both models have the same frames.
//
//  Frames:
//     0 -  7  Hover scene
//     8 - 16  Attack scene (for melee or missile)
//    17 - 22  Pain scene #1
//    23 - 28  Pain scene #2
//    29 - 34  Pain scene #3
//    35 - 47  Death scene #1
//    48 - 53  Death scene #2
//
//  Skins:
//     0  Red (original skin from ID's Qtest)
//     1  White
//     2  Blue
//     3  Gold
//
//==========================================================================


/*
==============================================================================

DRAGON

==============================================================================
*/

$cd progs/dragon
$origin 0 0 24
$base base 
$skin skin


$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10
$frame die11 die12 die13

$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6


////////////////////////////////////////////////////////////////////////////
//  1.  Animation                                                         //
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Movement Scenes

//----------------------------------------------------/ New Code /--------//
//  Hover animation.  Dragon hovers in place.  If a water-fearing
//  dragon is underwater, it will rise out of the water then hover.
//------------------------------------------------------------------------//
void()  dragon_hover1   =[ $fly1,  dragon_hover2   ] {ryu_stand();};
void()  dragon_hover2   =[ $fly2,  dragon_hover3   ] {ryu_stand();};
void()  dragon_hover3   =[ $fly3,  dragon_hover4   ] {ryu_stand();};
void()  dragon_hover4   =[ $fly4,  dragon_hover5   ] {ryu_stand();};
void()  dragon_hover5   =[ $fly5,  dragon_hover6   ] {ryu_stand();};
void()  dragon_hover6   =[ $fly6,  dragon_hover7   ] {ryu_stand();};
void()  dragon_hover7   =[ $fly7,  dragon_hover8   ] {ryu_stand();};
void()  dragon_hover8   =[ $fly8,  dragon_hover9   ] {PM_RyuFlySound(); ryu_stand();};
void()  dragon_hover9   =[ $fly7,  dragon_hover10  ] {ryu_stand();};
void()  dragon_hover10  =[ $fly6,  dragon_hover11  ] {ryu_stand();};
void()  dragon_hover11  =[ $fly5,  dragon_hover12  ] {ryu_stand();};
void()  dragon_hover12  =[ $fly4,  dragon_hover13  ] {ryu_stand();};
void()  dragon_hover13  =[ $fly3,  dragon_hover14  ] {ryu_stand();};
void()  dragon_hover14  =[ $fly2,  dragon_hover1   ] {ryu_stand();};

//----------------------------------------------------/ New Code /--------//
//  Walk animation.  The dragon slowly glides along its path.
//  Water-fearing dragons will leave the water (if possible)
//  before following its path.
//------------------------------------------------------------------------//
void()  dragon_walk1    =[ $fly1,  dragon_walk2    ] {ryu_walk();};
void()  dragon_walk2    =[ $fly2,  dragon_walk3    ] {ryu_walk();};
void()  dragon_walk3    =[ $fly3,  dragon_walk4    ] {ryu_walk();};
void()  dragon_walk4    =[ $fly4,  dragon_walk5    ] {ryu_walk();};
void()  dragon_walk5    =[ $fly5,  dragon_walk6    ] {ryu_walk();};
void()  dragon_walk6    =[ $fly6,  dragon_walk7    ] {ryu_walk();};
void()  dragon_walk7    =[ $fly7,  dragon_walk8    ] {ryu_walk();};
void()  dragon_walk8    =[ $fly8,  dragon_walk9    ] {PM_RyuFlySound(); ryu_walk();};
void()  dragon_walk9    =[ $fly7,  dragon_walk10   ] {ryu_walk();};
void()  dragon_walk10   =[ $fly6,  dragon_walk11   ] {ryu_walk();};
void()  dragon_walk11   =[ $fly5,  dragon_walk12   ] {ryu_walk();};
void()  dragon_walk12   =[ $fly4,  dragon_walk13   ] {ryu_walk();};
void()  dragon_walk13   =[ $fly3,  dragon_walk14   ] {ryu_walk();};
void()  dragon_walk14   =[ $fly2,  dragon_walk1    ] {ryu_walk();};

//----------------------------------------------------/ New Code /--------//
//  Run animation.  The dragon flies quickly to find and close in
//  on its target.
//------------------------------------------------------------------------//
void()  dragon_run1     =[ $fly1,  dragon_run2   ] {ryu_run();};
void()  dragon_run2     =[ $fly2,  dragon_run3   ] {ryu_run();};
void()  dragon_run3     =[ $fly3,  dragon_run4   ] {ryu_run();};
void()  dragon_run4     =[ $fly4,  dragon_run5   ] {ryu_run();};
void()  dragon_run5     =[ $fly5,  dragon_run6   ] {ryu_run();};
void()  dragon_run6     =[ $fly6,  dragon_run7   ] {ryu_run();};
void()  dragon_run7     =[ $fly7,  dragon_run8   ] {ryu_run();};
void()  dragon_run8     =[ $fly8,  dragon_run9   ] {PM_RyuFlySound(); ryu_run();};
void()  dragon_run9     =[ $fly7,  dragon_run10  ] {ryu_run();};
void()  dragon_run10    =[ $fly6,  dragon_run11  ] {ryu_run();};
void()  dragon_run11    =[ $fly5,  dragon_run12  ] {ryu_run();};
void()  dragon_run12    =[ $fly4,  dragon_run13  ] {ryu_run();};
void()  dragon_run13    =[ $fly3,  dragon_run14  ] {ryu_run();};
void()  dragon_run14    =[ $fly2,  dragon_run1   ] {ryu_run();};


//==========================================================================
//  Attack Scenes

//------------------//
//  Melee attacks!  //
//------------------//

//----------------------------------------------------/ New Code /--------//
//  This selects the bite attack power based on the dragon's attributes.
//------------------------------------------------------------------------//
void(vector offset1, vector offset2) PM_BiteAttack =
{
    local   float   level;
    local   vector  damage;

    level = dragon_level ();
    damage = DMG_RYU_BITE * level;

    if (self.height == SIZE_SMALL)
        PM_DragonBite (offset2, REACH_SMALL, damage);
    else
        PM_DragonBite (offset1, REACH_LARGE, damage);
};

//----------------------------------------------------/ New Code /--------//
//  Melee animation.  The dragon makes two bite attacks.
//------------------------------------------------------------------------//
void()  dragon_bite1   =[ $attack1,  dragon_bite2   ] {ryu_melee();};
void()  dragon_bite2   =[ $attack2,  dragon_bite3   ] {ryu_melee();};
void()  dragon_bite3   =[ $attack3,  dragon_bite4   ] {ryu_melee();};
void()  dragon_bite4   =[ $attack4,  dragon_bite5   ] {ryu_melee();};
void()  dragon_bite5   =[ $attack5,  dragon_bite6   ] {ryu_melee();};
void()  dragon_bite6   =[ $attack6,  dragon_bite7   ] {ryu_melee();};
void()  dragon_bite7   =[ $attack7,  dragon_bite8   ] {ryu_melee();};
void()  dragon_bite8   =[ $attack8,  dragon_bite9   ] {ryu_melee();};
void()  dragon_bite9   =[ $attack9,  dragon_bite10  ]
{   PM_RyuFlySound();
    ryu_melee();
    PM_BiteAttack ('44 -3 -12', '17 -2 -4');
};
void()  dragon_bite10  =[ $attack8,  dragon_bite11  ] {ryu_melee();};
void()  dragon_bite11  =[ $attack7,  dragon_bite12  ] {ryu_melee();};
void()  dragon_bite12  =[ $attack6,  dragon_bite13  ] {ryu_melee();};
void()  dragon_bite13  =[ $attack5,  dragon_bite14  ] {ryu_melee();};
void()  dragon_bite14  =[ $attack4,  dragon_bite15  ] {ryu_melee();};
void()  dragon_bite15  =[ $attack3,  dragon_bite16  ] {ryu_melee();};
void()  dragon_bite16  =[ $attack2,  dragon_bite17  ]
{   ryu_melee();
    PM_BiteAttack ('46 0 -2', '18 0 -1');
};
void()  dragon_bite17  =[ $attack1,  dragon_run1    ]                 
{   ryu_melee();
    self.attack_state = AS_STRAIGHT;
};

//----------------------------------------------------/ New Code /--------//
//  Melee attack start.  About midway into the animation, the dragon
//  decides whether to bite or to shoot something.  This is used by
//  smart dragons to foil the 'in-and-out' strategy used by players.
//------------------------------------------------------------------------//
void() dragon_strike =
{
    if (self.state == IQ_LOW)
    {
        // Stupid dragons always bite.
        self.attack_state = AS_STRAIGHT;
        dragon_bite1();
        return;
    }

    local   float   chance;

    if (self.slide_away >= time)
    {
        // Try to evade, and always shoot if it can.
        self.attack_state = AS_SLIDING;
        if (random() < 0.5)
            self.lefty = 1;
        else
            self.lefty = 0;
        chance = 0;
    }
    else
    {
        // Try to close in.  High chance of bite.  Always bite zombies.
        self.attack_state = AS_STRAIGHT;
        if (self.enemy.classname == "monster_zombie")
            chance = 1;
        else
            chance = 0.8;

        // Special cases.
        if (self.state > IQ_NORMAL)
        {
            if (PM_KeepAway (self.enemy))
            {
                // Always shoot if trying to get away.
                chance = 0;
            }
            else if (self.skin == SKIN_GOLD)
            {
                // Gold dragon shots are stronger than bite unless
                // the enemy resists fire.
                if (!PM_FireResistant (self.enemy))
                    chance = 0.5;
            }
        }
    }

    // If dragon can't use a missile attack, then use only the bite.
    if (!self.th_missile)
    {
        dragon_bite1();
        return;
    }
    if (PM_DragonNoShot (self))
    {
        dragon_bite1();
        return;
    }

    // If path crosses contents, use only the bite unless dragon is blue
    // and intelligent enough.
    if ( (self.skin != SKIN_BLUE) || (self.state < IQ_HIGH) )
    {
        traceline(self.origin, self.enemy.origin, TRUE, self);
        if (trace_inopen)
            if (trace_inwater)
            {
                dragon_bite1();
                return;
            }
    }

    local   float   reach;

    if (self.height == SIZE_SMALL)
        reach = REACH_SMALL;
    else
        reach = REACH_LARGE;

    // If close enough, dragon may bite or shoot.
    if (vlen(self.enemy.origin - self.origin) <= reach)
        if (random() < chance)
        {
            dragon_bite1();
            return;
        }

    // Fire away instead.
    self.th_missile();
};

//--------------------//
//  Missile attacks!  //
//--------------------//

//----------------------------------------------------/ New Code /--------//
//  FIRE
//
//  Missile attack animation for the red dragon.  The red dragon
//  breathes fire that can ignite targets.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  dragon_fire6a  =[ $attack6,  dragon_fire7a  ] {ryu_missile();};
void()  dragon_fire7a  =[ $attack7,  dragon_fire8a  ] {ryu_missile();};
void()  dragon_fire8a  =[ $attack8,  dragon_fire9a  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonFire('16 -1 0', SHOT1_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire9a  =[ $attack9,  dragon_fire10a ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_DragonFire('16 -2 -3', SHOT1_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire10a =[ $attack8,  dragon_missile11 ]
{   ryu_missile();
    PM_DragonFire('16 -1 0', SHOT1_SPEED, DMG_RYU_FIRE, 1);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  dragon_fire6b  =[ $attack6,  dragon_fire7b   ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    if (self.height == SIZE_SMALL)
        PM_DragonFire('16 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
    else
        PM_DragonFire('42 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire7b  =[ $attack7,  dragon_fire8b  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonFire('16 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
    else
        PM_DragonFire('46 0 1', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire8b  =[ $attack8,  dragon_fire9b  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonFire('16 -1 0', SHOT2_SPEED, DMG_RYU_FIRE, 1);
    else
        PM_DragonFire('44 -2 -4', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire9b  =[ $attack9,  dragon_fire10b ]
{   PM_RyuFlySound();
    ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonFire('16 -2 -3', SHOT2_SPEED, DMG_RYU_FIRE, 1);
    else
        PM_DragonFire('44 -3 -12', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire10b =[ $attack8,  dragon_fire11b ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonFire('16 -1 0', SHOT2_SPEED, DMG_RYU_FIRE, 1);
    else
        PM_DragonFire('44 -2 -4', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  dragon_fire11b =[ $attack7,  dragon_missile12  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonFire('16 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
    else
        PM_DragonFire('46 0 1', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};

//-----------//
//  LEVEL 3  //
//-----------//
// No level 3 attacks here.

//-----------//
//  LEVEL 4  //
//-----------//
void()  dragon_fire6d  =[ $attack6,  dragon_fire7d  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonFire('42 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('42 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  dragon_fire7d  =[ $attack7,  dragon_fire8d  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('46 0 1', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('46 0 1', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  dragon_fire8d  =[ $attack8,  dragon_fire9d  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('44 -2 -4', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('44 -2 -4', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  dragon_fire9d  =[ $attack9,  dragon_fire10d ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('44 -3 -12', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('44 -3 -12', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  dragon_fire10d =[ $attack8,  dragon_fire11d ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('44 -2 -4', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('44 -2 -4', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  dragon_fire11d =[ $attack7,  dragon_missile12  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('46 0 1', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('46 0 1', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};


//----------------------------------------------------/ New Code /--------//
//  ICE
//
//  Missile attack animation for the white dragon.  The white dragon
//  shoots ice shards at the target.  Currently, ice shards do nothing
//  special.  Perhaps on a later version they can freeze ala Hexen.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  dragon_ice6a  =[ $attack6,  dragon_ice7a  ] {ryu_missile();};
void()  dragon_ice7a  =[ $attack7,  dragon_ice8a  ] {ryu_missile();};
void()  dragon_ice8a  =[ $attack8,  dragon_ice9a  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    PM_DragonIce('16 -1 0', SHOT1_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice9a  =[ $attack9,  dragon_ice10a ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_DragonIce('16 -2 -3', SHOT1_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice10a =[ $attack8,  dragon_missile11 ]
{   ryu_missile();
    PM_DragonIce('16 -1 0', SHOT1_SPEED, DMG_RYU_ICE, 1);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  dragon_ice6b  =[ $attack6,  dragon_ice7b  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    if (self.height == SIZE_SMALL)
        PM_DragonIce('16 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
    else
        PM_DragonIce('42 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice7b  =[ $attack7,  dragon_ice8b  ]
{
    ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonIce('16 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
    else
        PM_DragonIce('46 0 1', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice8b  =[ $attack8,  dragon_ice9b  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonIce('16 -1 0', SHOT2_SPEED, DMG_RYU_ICE, 1);
    else
        PM_DragonIce('44 -2 -4', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice9b  =[ $attack9,  dragon_ice10b ]
{   PM_RyuFlySound();
    ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonIce('16 -2 -3', SHOT2_SPEED, DMG_RYU_ICE, 1);
    else
        PM_DragonIce('44 -3 -12', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice10b =[ $attack8,  dragon_ice11b ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonIce('16 -1 0', SHOT2_SPEED, DMG_RYU_ICE, 1);
    else
        PM_DragonIce('44 -2 -4', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  dragon_ice11b =[ $attack7,  dragon_missile12  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonIce('16 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
    else
        PM_DragonIce('46 0 1', SHOT2_SPEED, DMG_RYU_ICE, 1);
};

//-----------//
//  LEVEL 3  //
//-----------//
// No level 3 attacks here.

//-----------//
//  LEVEL 4  //
//-----------//
void()  dragon_ice6d  =[ $attack6,  dragon_ice7d  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonIce('42 0 2', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('42 0 2', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  dragon_ice7d  =[ $attack7,  dragon_ice8d  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('46 0 1', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('46 0 1', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  dragon_ice8d  =[ $attack8,  dragon_ice9d  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('44 -2 -4', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('44 -2 -4', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  dragon_ice9d  =[ $attack9,  dragon_ice10d ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('44 -3 -12', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('44 -3 -12', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  dragon_ice10d =[ $attack8,  dragon_ice11d ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('44 -2 -4', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('44 -2 -4', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  dragon_ice11d =[ $attack7,  dragon_missile12  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('46 0 1', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('46 0 1', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};


//----------------------------------------------------/ New Code /--------//
//  LIGHTNING
//
//  Missile attack animation for the blue dragon.  The blue dragon
//  shoots lightning that can zap multiple targets.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  dragon_bolt6a  =[ $attack6,  dragon_bolt7a  ] {ryu_missile();};
void()  dragon_bolt7a  =[ $attack7,  dragon_bolt8a  ] {ryu_missile();};
void()  dragon_bolt8a  =[ $attack8,  dragon_bolt9a  ] {ryu_missile();};
void()  dragon_bolt9a  =[ $attack9,  dragon_missile10 ]
{   PM_RyuFlySound();
    ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (1);
    PM_DragonBolt('16 -2 -3', SHOT1_SPEED, DMG_RYU_BOLT);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  dragon_bolt6b  =[ $attack6,  dragon_bolt7b  ] {ryu_missile();};
void()  dragon_bolt7b  =[ $attack7,  dragon_bolt8b  ] {ryu_missile();};
void()  dragon_bolt8b  =[ $attack8,  dragon_bolt9b  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    if (self.height == SIZE_SMALL)
        PM_DragonBolt('16 -1 0', SHOT2_SPEED, DMG_RYU_BOLT);
    else
        PM_DragonBolt('44 -2 -4', SHOT2_SPEED, DMG_RYU_BOLT);
};

void()  dragon_bolt9b  =[ $attack9,  dragon_missile10 ]
{   PM_RyuFlySound();
    ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonBolt('16 -2 -3', SHOT2_SPEED, DMG_RYU_BOLT);
    else
        PM_DragonBolt('44 -3 -12', SHOT2_SPEED, DMG_RYU_BOLT);
};

//-----------//
//  LEVEL 3  //
//-----------//
// No level 3 attacks here.

//-----------//
//  LEVEL 4  //
//-----------//
void()  dragon_bolt6d  =[ $attack6,  dragon_bolt7d  ] {ryu_missile();};
void()  dragon_bolt7d  =[ $attack7,  dragon_bolt8d  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (4);
    PM_DragonBolt('46 0 1', SHOT4_SPEED, DMG_RYU_BOLT);
};
void()  dragon_bolt8d  =[ $attack8,  dragon_bolt9d  ]
{   ryu_missile();
    PM_DragonBolt('44 -2 -4', SHOT4_SPEED, DMG_RYU_BOLT);
};
void()  dragon_bolt9d  =[ $attack9,  dragon_bolt10d ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_DragonBolt('44 -3 -12', SHOT4_SPEED, DMG_RYU_BOLT);
};
void()  dragon_bolt10d =[ $attack8,  dragon_missile11 ]
{   ryu_missile();
    PM_DragonBolt('44 -2 -4', SHOT4_SPEED, DMG_RYU_BOLT);
};


//----------------------------------------------------/ New Code /--------//
//  NAPALM
//
//  Missile attack animation for the gold dragon.  The gold dragon
//  shoots a large fireball at the target.  Fireball explodes into
//  a small cloud of fire.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  dragon_blast6a  =[ $attack6,  dragon_blast7a  ] {ryu_missile();};
void()  dragon_blast7a  =[ $attack7,  dragon_blast8a  ] {ryu_missile();};
void()  dragon_blast8a  =[ $attack8,  dragon_blast9a  ] {ryu_missile();};
void()  dragon_blast9a  =[ $attack9,  dragon_missile10 ]
{   PM_RyuFlySound();
    ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 -2 -3', DMG_RYU_BLAST13, SHOT1_SPEED, DMG_RYU_FIRE);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  dragon_blast6b  =[ $attack6,  dragon_blast7b  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    if (self.height == SIZE_SMALL)
        PM_DragonBlast('16 0 2', DMG_RYU_BLAST13, SHOT2_SPEED, DMG_RYU_FIRE);
    else
        PM_DragonBlast('42 0 2', DMG_RYU_BLAST13, SHOT2_SPEED, DMG_RYU_FIRE);
};
void()  dragon_blast7b  =[ $attack7,  dragon_blast8b  ] {ryu_missile();};
void()  dragon_blast8b  =[ $attack8,  dragon_blast9b  ] {ryu_missile();};
void()  dragon_blast9b  =[ $attack9,  dragon_blast10b ]
{   PM_RyuFlySound();
    ryu_missile();
};
void()  dragon_blast10b =[ $attack8,  dragon_blast11b ] {ryu_missile();};
void()  dragon_blast11b =[ $attack7,  dragon_blast12b ] {ryu_missile();};
void()  dragon_blast12b =[ $attack6,  dragon_missile13  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    if (self.height == SIZE_SMALL)
        PM_DragonBlast('16 0 2', DMG_RYU_BLAST13, SHOT2_SPEED, DMG_RYU_FIRE);
    else
        PM_DragonBlast('42 0 2', DMG_RYU_BLAST13, SHOT2_SPEED, DMG_RYU_FIRE);
};

//-----------//
//  LEVEL 3  //
//-----------//
// No level 3 attacks here.

//-----------//
//  LEVEL 4  //
//-----------//
void()  dragon_blast6d  =[ $attack6,  dragon_blast7d  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast('42 0 2', DMG_RYU_BLAST4, SHOT4_SPEED, DMG_RYU_FIRE);
};
void()  dragon_blast7d  =[ $attack7,  dragon_blast8d  ] {ryu_missile();};
void()  dragon_blast8d  =[ $attack8,  dragon_blast9d  ] {ryu_missile();};
void()  dragon_blast9d  =[ $attack9,  dragon_blast10d ]
{   PM_RyuFlySound();
    ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast('44 -3 -12', DMG_RYU_BLAST4, SHOT4_SPEED, DMG_RYU_FIRE);
};
void()  dragon_blast10d =[ $attack8,  dragon_blast11d ] {ryu_missile();};
void()  dragon_blast11d =[ $attack7,  dragon_blast12d ] {ryu_missile();};
void()  dragon_blast12d =[ $attack6,  dragon_missile13  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast('42 0 2', DMG_RYU_BLAST4, SHOT4_SPEED, DMG_RYU_FIRE);
};


//----------------------------------------------------/ New Code /--------//
//  VENOM SPIT
//
//  Missile attack animation for the green dragon.  The green dragon
//  spits a stream of green blobs (scrag bullets) at the target.
//-------------------------------------------------------------------------//
void() PM_DragonSpitTouch =
{
    if (other.classname == "player")
    {
        // FIXME:  If dragon is cranked, infect victim with poison.
        other.deathtype = "acid";
        spike_touch ();
        if (other.health > 0)
            other.deathtype = string_null;
        return;
    }

    spike_touch ();
};

void() PM_DragonSpitStart =
{
    self.velocity   = self.velocity * self.height;
    self.nextthink  = self.pausetime;
    self.think      = SUB_Remove;
};

void(vector offset, float sped, float dec) PM_DragonSpit =
{
    local   vector  dir;    // Vector from 'start' to enemy origin.
    local   vector  start;  // Location of dragon's mouth.
    local   vector  end;    // Place where projectile will strike.

    makevectors(self.angles);

    start = self.origin + (v_forward * offset_x) +
        (v_right * offset_y) + (v_up * offset_z);
    end = PM_GetShotSpot ();
    end = PM_LeadShot (start, end, sped);
    end = PM_InterAim (end);

    dir = normalize (end - start);

    launch_spike (start, dir);
    newmis.height    = 1 / dec;
    newmis.velocity  = dir * sped * dec;
    newmis.owner     = self;
    newmis.classname = "wizspike";
    newmis.touch     = PM_DragonSpitTouch;
    newmis.pausetime = time + (8000 / sped);
    newmis.nextthink = time + 0.1;
    newmis.think     = PM_DragonSpitStart;
    setmodel (newmis, "progs/w_spike.mdl");
    setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);    
};

//-----------//
//  LEVEL 1  //
//-----------//
void()  dragon_spit6a  =[ $attack6,  dragon_spit7a  ] {ryu_missile();};
void()  dragon_spit7a  =[ $attack7,  dragon_spit8a  ] {ryu_missile();};
void()  dragon_spit8a  =[ $attack8,  dragon_spit9a  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/spit.wav", 1, ATTN_NORM);
    PM_DragonSpit('16 -1 0', SHOT1_SPEED, 1);
};
void()  dragon_spit9a  =[ $attack9,  dragon_spit10a ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_DragonSpit('16 -2 -3', SHOT1_SPEED, 1);
};
void()  dragon_spit10a =[ $attack8,  dragon_missile11 ]
{   ryu_missile();
    PM_DragonSpit('16 -1 0', SHOT1_SPEED, 1);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  dragon_spit6b  =[ $attack6,  dragon_spit7b  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/spit.wav", 1, ATTN_NORM);
    if (self.height == SIZE_SMALL)
        PM_DragonSpit('42 0 2', SHOT2_SPEED, 1);
    else
        PM_DragonSpit('42 0 2', SHOT2_SPEED, 1);
};
void()  dragon_spit7b  =[ $attack7,  dragon_spit8b  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonSpit('46 0 1', SHOT2_SPEED, 1);
    else
        PM_DragonSpit('46 0 1', SHOT2_SPEED, 1);
};
void()  dragon_spit8b  =[ $attack8,  dragon_spit9b  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonSpit('44 -2 -4', SHOT2_SPEED, 1);
    else
        PM_DragonSpit('44 -2 -4', SHOT2_SPEED, 1);
};
void()  dragon_spit9b  =[ $attack9,  dragon_spit10b ]
{   PM_RyuFlySound();
    ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonSpit('44 -3 -12', SHOT2_SPEED, 1);
    else
        PM_DragonSpit('44 -3 -12', SHOT2_SPEED, 1);
};
void()  dragon_spit10b =[ $attack8,  dragon_spit11b ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonSpit('44 -2 -4', SHOT2_SPEED, 1);
    else
        PM_DragonSpit('44 -2 -4', SHOT2_SPEED, 1);
};
void()  dragon_spit11b =[ $attack7,  dragon_missile12  ]
{   ryu_missile();
    if (self.height == SIZE_SMALL)
        PM_DragonSpit('46 0 1', SHOT2_SPEED, 1);
    else
        PM_DragonSpit('46 0 1', SHOT2_SPEED, 1);
};

//-----------//
//  LEVEL 4  //
//-----------//
void()  dragon_spit6d  =[ $attack6,  dragon_spit7d  ]
{   ryu_missile();
    sound (self, CHAN_WEAPON, "dragon/spit.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonSpit('42 0 2', SHOT4_SPEED, 1);
    PM_DragonSpit('42 0 2', SHOT4_SPEED, 0.5);
};
void()  dragon_spit7d  =[ $attack7,  dragon_spit8d  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonSpit('46 0 1', SHOT4_SPEED, 1);
    PM_DragonSpit('46 0 1', SHOT4_SPEED, 0.5);
};
void()  dragon_spit8d  =[ $attack8,  dragon_spit9d  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonSpit('44 -2 -4', SHOT4_SPEED, 1);
    PM_DragonSpit('44 -2 -4', SHOT4_SPEED, 0.5);
};
void()  dragon_spit9d  =[ $attack9,  dragon_spit10d ]
{   PM_RyuFlySound();
    ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonSpit('44 -3 -12', SHOT4_SPEED, 1);
    PM_DragonSpit('44 -3 -12', SHOT4_SPEED, 0.5);
};
void()  dragon_spit10d =[ $attack8,  dragon_spit11d ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonSpit('44 -2 -4', SHOT4_SPEED, 1);
    PM_DragonSpit('44 -2 -4', SHOT4_SPEED, 0.5);
};
void()  dragon_spit11d =[ $attack7,  dragon_missile12  ]
{   ryu_missile();
    PM_SetDragonAmmo (2);
    PM_DragonSpit('46 0 1', SHOT4_SPEED, 1);
    PM_DragonSpit('46 0 1', SHOT4_SPEED, 0.5);
};


//==========================================================================

//------------//
//  STANDARD  //
//------------//
void()  dragon_missile1   =[ $attack1,  dragon_missile2  ]
{   PM_StrafeOption ();
    ryu_missile();
};
void()  dragon_missile2   =[ $attack2,  dragon_missile3  ] {ryu_missile();};
void()  dragon_missile3   =[ $attack3,  dragon_missile4  ] {ryu_missile();};
void()  dragon_missile4   =[ $attack4,  dragon_missile5  ] {ryu_missile();};
void()  dragon_missile5   =[ $attack5,  dragon_missileselect]
{   ryu_missile();
    PM_SetDragonAim (FALSE);
    PM_SetDragonAmmo (0);
};
//-----------------------------------------------------------------------//
void()  dragon_missile6   =[ $attack6,  dragon_missile7  ] {ryu_missile();};
void()  dragon_missile7   =[ $attack7,  dragon_missile8  ] {ryu_missile();};
void()  dragon_missile8   =[ $attack8,  dragon_missile9  ] {ryu_missile();};
void()  dragon_missile9   =[ $attack9,  dragon_missile10 ]
{   PM_RyuFlySound();
    ryu_missile();
};
void()  dragon_missile10  =[ $attack8,  dragon_missile11 ] {ryu_missile();};
void()  dragon_missile11  =[ $attack7,  dragon_missile12 ] {ryu_missile();};
void()  dragon_missile12  =[ $attack6,  dragon_missile13 ] {ryu_missile();};
//-----------------------------------------------------------------------//
void()  dragon_missile13  =[ $attack5,  dragon_missile14 ] {ryu_missile();};
void()  dragon_missile14  =[ $attack4,  dragon_missile15 ] {ryu_missile();};
void()  dragon_missile15  =[ $attack3,  dragon_missile16 ] {ryu_missile();};
void()  dragon_missile16  =[ $attack2,  dragon_missile17 ] {ryu_missile();};
void()  dragon_missile17  =[ $attack1,  dragon_run1      ]
{   ryu_missile();
    //SUB_CheckRefire (dragon_missile1);
};
void()  dragon_missileselect =
{
    local   float   level;

    level = dragon_level ();

    if (self.skin == SKIN_GREEN)
    {
        if (level == 1)
            dragon_spit6a();
        else if (level == 2)
            dragon_spit6b();
        else
            dragon_spit6d();
        return;
    }

    if (level == 1)
    {
        if (self.skin == SKIN_GOLD)
            dragon_blast6a();
        else if (self.skin == SKIN_BLUE)
            dragon_bolt6a();
        else if (self.skin == SKIN_WHITE)
            dragon_ice6a();
        else
            dragon_fire6a();
        return;
    }
    else if (level == 2)
    {
        if (self.skin == SKIN_GOLD)
            dragon_blast6b();
        else if (self.skin == SKIN_GREEN)
            dragon_spit6b();
        else if (self.skin == SKIN_BLUE)
            dragon_bolt6b();
        else if (self.skin == SKIN_WHITE)
            dragon_ice6b();
        else
            dragon_fire6b();
        return;
    }
    else //if (level > 2)
    {
        if (self.skin == SKIN_GOLD)
            dragon_blast6d();
        else if (self.skin == SKIN_GREEN)
            dragon_spit6d();
        else if (self.skin == SKIN_BLUE)
            dragon_bolt6d();
        else if (self.skin == SKIN_WHITE)
            dragon_ice6d();
        else
            dragon_fire6d();
        return;
    }
};


//==========================================================================
//  Pain Scenes

//----------------------------------------------------/ New Code /--------//
//  Pain animation #1.  The dragon recoils in pain.
//------------------------------------------------------------------------//
void()  dragon_pain1    =[ $pain1,   dragon_pain2  ] {PM_Regenerate();};
void()  dragon_pain2    =[ $pain2,   dragon_pain3  ] {PM_Regenerate();};
void()  dragon_pain3    =[ $pain3,   dragon_pain4  ] {PM_Regenerate();};
void()  dragon_pain4    =[ $pain4,   dragon_pain5  ] {PM_Regenerate();};
void()  dragon_pain5    =[ $pain5,   dragon_pain6  ] {PM_Regenerate();};
void()  dragon_pain6    =[ $pain6,   dragon_run1   ] {PM_Regenerate();};

//----------------------------------------------------/ New Code /--------//
//  Pain animation #2.  The dragon turns its head.
//------------------------------------------------------------------------//
void()  dragon_painb1   =[ $painb1,  dragon_painb2 ] {PM_Regenerate();};
void()  dragon_painb2   =[ $painb2,  dragon_painb3 ] {PM_Regenerate();};
void()  dragon_painb3   =[ $painb3,  dragon_painb4 ] {PM_Regenerate();};
void()  dragon_painb4   =[ $painb4,  dragon_painb5 ] {PM_Regenerate();};
void()  dragon_painb5   =[ $painb5,  dragon_painb6 ] {PM_Regenerate();};
void()  dragon_painb6   =[ $painb6,  dragon_run1   ] {PM_Regenerate();};

//----------------------------------------------------/ New Code /--------//
//  Pain animation #3.  The dragon shakes violently.
//------------------------------------------------------------------------//
void()  dragon_painc1   =[ $painc1,  dragon_painc2 ] {PM_Regenerate();};
void()  dragon_painc2   =[ $painc2,  dragon_painc3 ] {PM_Regenerate();};
void()  dragon_painc3   =[ $painc3,  dragon_painc4 ] {PM_Regenerate();};
void()  dragon_painc4   =[ $painc4,  dragon_painc5 ] {PM_Regenerate();};
void()  dragon_painc5   =[ $painc5,  dragon_painc6 ] {PM_Regenerate();};
void()  dragon_painc6   =[ $painc6,  dragon_run1   ] {PM_Regenerate();};

//----------------------------------------------------/ New Code /--------//
//  This is called when a dragon gets injured.
//------------------------------------------------------------------------//
void(entity attacker, float damage) dragon_pain =
{
    self.slide_rand = time + DODGE_TIME;    // Can strafe randomly now.

    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;

    if (self.height == SIZE_SMALL)
    {
        sound (self, CHAN_VOICE, "dragon/pain2.wav", 1, ATTN_NORM);
        if ((random() * 50) > damage)
            return;         // didn't flinch
    }
    else
    {
        sound (self, CHAN_VOICE, "dragon/pain.wav", 1, ATTN_NORM);
        if ((random() * 200) > damage)
            return;         // didn't flinch
    }

    // Smarter dragons strafe soon after pain.
    if (self.state > IQ_NORMAL)
        self.slide_away = time + 2;
    self.attack_state = AS_STRAIGHT;
    self.attack_finished = 0;       // can attack anytime now!

    // Choose one of three pain scenes.
    local   float   r;

    r = random();
    if (r < 0.4)
        dragon_pain1();
    else if (r < 0.8)
        dragon_painb1();
    else
        dragon_painc1();
};


//==========================================================================
//  Death Scenes

//----------------------------------------------------/ New Code /--------//
//  Death animation #1.  The dragon pitches over and falls on its back.
//------------------------------------------------------------------------//
void()  dragon_die1     =[ $die1,   dragon_die2   ] {};
void()  dragon_die2     =[ $die2,   dragon_die3   ] {};
void()  dragon_die3     =[ $die3,   dragon_die4   ] {};
void()  dragon_die4     =[ $die4,   dragon_die5   ] {};
void()  dragon_die5     =[ $die5,   dragon_die6   ] {self.solid = SOLID_NOT;};
void()  dragon_die6     =[ $die6,   dragon_die7   ] {};
void()  dragon_die7     =[ $die7,   dragon_die8   ] {};
void()  dragon_die8     =[ $die8,   dragon_die9   ] {};
void()  dragon_die9     =[ $die9,   dragon_die10  ] {};
void()  dragon_die10    =[ $die10,  dragon_die11  ] {};
void()  dragon_die11    =[ $die11,  dragon_die12  ] {};
void()  dragon_die12    =[ $die12,  dragon_die13  ] {};
void()  dragon_die13    =[ $die13,  dragon_die13  ] {};

//----------------------------------------------------/ New Code /--------//
//  Death animation #2.  The dragon simply falls down.
//------------------------------------------------------------------------//
void()  dragon_dieb1    =[ $dieb1,  dragon_dieb2  ] {};
void()  dragon_dieb2    =[ $dieb2,  dragon_dieb3  ] {};
void()  dragon_dieb3    =[ $dieb3,  dragon_dieb4  ] {};
void()  dragon_dieb4    =[ $dieb4,  dragon_dieb5  ] {};
void()  dragon_dieb5    =[ $dieb5,  dragon_dieb6  ] {self.solid = SOLID_NOT;};
void()  dragon_dieb6    =[ $dieb6,  dragon_dieb6  ] {};

//----------------------------------------------------/ New Code /--------//
//  This is called when a small dragon dies.
//------------------------------------------------------------------------//
void() minor_die =
{
    // check for gib
    if (self.health < -40)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        PM_ThrowAnyHead (self, "progs/tail.mdl", self.health, self.skin, SIZE_SMALL);
        PM_ThrowAnyGib (self, "progs/lwing.mdl", self.health, self.skin, SIZE_SMALL);
        PM_ThrowAnyGib (self, "progs/rwing.mdl", self.health, self.skin, SIZE_SMALL);
        ThrowGib ("progs/zom_gib.mdl", self.health);
        ThrowGib ("progs/zom_gib.mdl", self.health);

		return;
	}

    // regular death
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z =  100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    sound (self, CHAN_VOICE, "dragon/death2.wav", 1, ATTN_NORM);
    if (random() < 0.5)
    {
        self.velocity_z =  200 + 100*random();
        dragon_die1();
    }
    else
        dragon_dieb1();
};

//----------------------------------------------------/ New Code /--------//
//  This is called when a dragon dies.
//------------------------------------------------------------------------//
void() dragon_die =
{
    // If the dragon has a 'watergoal', remove it!
    PM_RemoveWaterGoal (self);

    // Small dragons die differently.
    if (self.height == SIZE_SMALL)
    {
        minor_die();
        return;
    }

    // Check for gib.
    if (self.health < -95)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        PM_ThrowAnyHead (self, "progs/tail.mdl", self.health, self.skin, SIZE_LARGE);
        PM_ThrowAnyGib (self, "progs/lwing.mdl", self.health, self.skin, SIZE_LARGE);
        PM_ThrowAnyGib (self, "progs/rwing.mdl", self.health, self.skin, SIZE_LARGE);
        ThrowGib ("progs/gib3.mdl", self.health);
        ThrowGib ("progs/gib3.mdl", self.health);
        ThrowGib ("progs/gib3.mdl", self.health);

        return;
    }

    // Regular death.
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z =  100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    sound (self, CHAN_VOICE, "dragon/death.wav", 1, ATTN_NORM);
    if (random() < 0.5)
    {
        self.velocity_z =  250 + 100*random();      // 50 more than small.
        dragon_die1();
    }
    else
        dragon_dieb1();
};


////////////////////////////////////////////////////////////////////////////
//  2.  Dragon Entities                                                   //
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Dragon Constitution

//----------------------------------------------------/ New Code /--------//
//  This spawns a dead dragon.
//------------------------------------------------------------------------//
void() PM_SpawnDragonCorpse =
{
    self.solid      = SOLID_NOT;
    self.movetype   = MOVETYPE_STEP;
    self.takedamage = DAMAGE_NO;

    if (self.health & 1)
        self.frame = $die13;
    else
        self.frame = $dieb6;
    self.health     = 0;

    if (self.height == SIZE_SMALL)
    {
        setmodel (self, "progs/dragon2.mdl");
        setsize (self, VEC_RYU2_MIN, VEC_RYU2_MAX);
    }
    else
    {
        setmodel (self, "progs/dragon.mdl");
        setsize (self, VEC_RYU1_MIN, VEC_RYU1_MAX);
    }

    // Try to place corpse in the level.
    self.touch      = SUB_Null;
    self.origin_z   = self.origin_z + 1;    // raise off floor a bit
	if (!droptofloor())
    {
        dprint ("Corpse fell out of level at ");
        dprint (vtos(self.origin));
        dprint ("\n");
        remove (self);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This sets the dragon's model and bbox its size.  If no size was
//  given defaults to large.  This also sets the dragon's type.
//------------------------------------------------------------------------//
void() PM_SetDragonModel =
{
    if (self.height == SIZE_SMALL)
    {
        setmodel (self, "progs/dragon2.mdl");
        setsize (self, VEC_RYU2_MIN, VEC_RYU2_MAX);
        return;
    }

    // If the size value is not known, use large size.
    self.height = SIZE_LARGE;
    setmodel (self, "progs/dragon.mdl");
    setsize (self, VEC_RYU1_MIN, VEC_RYU1_MAX);
};

//----------------------------------------------------/ New Code /--------//
//  This sets the dragon's (lack of) fear of water.
//------------------------------------------------------------------------//
void(float type) PM_SetFear =
{
    // A stupid dragon does not know why it should be afraid of water.
    if (self.state == IQ_LOW)
    {
        self.aflag = FALSE;
        return;
    }

    // Red and blue dragons avoid water.  The rest will swim if needed.
    if (type == SKIN_RED)
        self.aflag = TRUE;
    else if (type == SKIN_BLUE)
        self.aflag = TRUE;
    else
        self.aflag = FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This makes the dragon solid and sets its size and type.
//------------------------------------------------------------------------//
void(float type) PM_MakeDragon =
{
    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_NONE;    // Don't move until fly is set.
    PM_SetDragonModel ();
    PM_SetFear (type);

    // Initialize timed values and other miscellaneous stuff.
    self.currentammo = 0;   // Used by most dragons.
    self.dodge_back  = 0;
    self.slide_away  = 0;
    self.slide_rand  = 0;
    self.stalled     = 0;
};


//==========================================================================
//  Dragon Attribute Verification

//----------------------------------------------------/ New Code /--------//
//  This checks the size of the dragon.  If the value was not given or
//  is invalid, then it is assumed to be large.
//------------------------------------------------------------------------//
void(float type) PM_VerifySize =
{
    // If no size was given, assume value is zero.
    if (!self.height)
        self.height = 0;

    // Force the size value to be an integer by chopping off decimals.
    self.height = floor(self.height);

    if (self.height == 1)
        self.height = SIZE_SMALL;
    else
        self.height = SIZE_LARGE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks the validity of the dragon's assigned intelligence.
//  If the value was not given or is invalid, then it is assigned
//  the default value given.
//------------------------------------------------------------------------//
void() PM_VerifyIQ =
{
    // If skilled, start with its toughest AI.
    if (self.spawnflags & SPAWN_SKILLED)
    {
        self.state = IQ_GENIUS;
        return;
    }

    local   float   default;

    default = IQ_HIGH;

    // If no IQ was assigned, change it to the default given.
    if (!self.state)
    {
        self.state = default;
        return;
    }

    // Force the IQ value to be an integer by chopping off decimals.
    self.state = floor(self.state);

    // If the IQ value is too low or high, change it to the default given.
    if (self.state < IQ_LOW)
        self.state = default;
    else if (self.state > IQ_GENIUS)
        self.state = default;
};

//----------------------------------------------------/ New Code /--------//
//  This checks the validity of the dragon's assigned health.  If the
//  value was not given or is too low, then it is assigned the default
//  value given.  If the value is too high, it is capped to a limit.
//
//  Once valid health is obtained, it becomes the dragon's maximum health.
//
//  Next, the dragon regeneration power is checked.  If none were given,
//  the dragon regenerates one hit point per second.  A dragon can
//  regenerate 'wait' hit point every second.  If 'wait' is negative,
//  regeneration is disabled.
//------------------------------------------------------------------------//
void() PM_VerifyHealth =
{
    local   float   default;

    // Set default health.  Large dragons normally have more health.
    if (self.height == SIZE_SMALL)
        default = 100;
    else
        default = 500;
    
    // If no health was given, set it to the default given.
    if (!self.health)
        self.health = default;

    // Force health to be an integer by chopping off decimals.
    self.health = floor(self.health);

    // If dragon has zero health or less, set it to the default given.
    if (self.health < 1)
        self.health = default;

    // If health is extremely high, cap it so that a telefrag can kill
    // even armored dragons.  (With armor, health is effectively double.)
    if (self.health > 10000)
        self.health = 10000;

    // The dragon's starting health is its maximum health.
    self.max_health = self.health;

    // Force the wait value to be an integer by chopping off decimals.
    // If regeneration wait time was not given, assume dragon cannot
    // regenerate.
    self.wait = floor(self.wait);
    if (!self.wait)
        self.wait = 0;
    else if (self.wait < 0)
        self.wait = 0;

    // Dragons always regenerate if skilled or on Nightmare.
    if ((self.spawnflags & SPAWN_SKILLED) || (cvar("skill") >= 3))
    {
        if (self.height == SIZE_SMALL)
            default = 1;
        else
            default = 2;

        if (self.wait < default)
            self.wait = default;
    }

    // Regeneration stuff is done in the 'regen.qc' module.
    PM_SetRegeneration (self, self.wait);

    // Set armor if flagged.
    if (self.spawnflags & SPAWN_ARMORED)
        PM_DragonAddArmor (self, 0);
};

//----------------------------------------------------/ New Code /--------//
//  This checks the validity of the dragon's assigned running speed.
//  If the value was not given, it defaults to 32.  The dragon will
//  never fly slower than its walking speed.
//------------------------------------------------------------------------//
void() PM_VerifySpeed =
{
    // Large dragons.
    if (!self.speed)
        self.speed = 32;

    self.speed = floor(self.speed);
    if (self.speed < DRAGON_MINSPEED)
    {
        // Running speed is at least as high as its walking speed.
        self.speed = DRAGON_MINSPEED;
        return;
    }

    if (self.speed > 32)
        self.speed = 32;    // Max speed allowed.  Used to be 48.
};

//----------------------------------------------------/ New Code /--------//
//  This checks the validity of the dragon's assigned turning speed.
//  If the value was not given, it defaults to 20 degrees.
//------------------------------------------------------------------------//
void() PM_VerifyYawSpeed =
{
    if (!self.yaw_speed)
        self.yaw_speed = 20;

    self.yaw_speed = floor(self.yaw_speed);
    if (self.speed < 1)
        self.yaw_speed = 20;
    else if (self.speed > 180)
        self.yaw_speed = 180;
};

//----------------------------------------------------/ New Code /--------//
//  This checks the skin value of the dragon is legal.
//------------------------------------------------------------------------//
float() PM_VerifyType =
{
    // If no skin was given, use the classic red dragon.
    if (!self.skin)
        self.skin = 0;

    // Force the skin value to be an integer by chopping off decimals.
    self.skin = floor(self.skin);

    // Special:  Check for green dragon.
    if (self.skin == SKIN_GREEN)
        return SKIN_GREEN;

    // Unknown types default to the red dragon.
    if (self.skin < 0)
        self.skin = SKIN_RED;
    else if (self.skin > 3)
        self.skin = SKIN_RED;

    return self.skin;
};


//==========================================================================
//  Dragon Definition

//----------------------------------------------------/ New Code /--------//
//  This activates a triggered dragon previously hidden in a level.
//------------------------------------------------------------------------//
void() dragon_start_go =
{
    flymonster_start_go ();
    if (self.style & 2)
        monster_use ();     // Use it again to make it mad.
};

//----------------------------------------------------/ New Code /--------//
//  This triggers a dragon previously hidden in a level.
//  Based on Zerstoter's spawnflag 64 monsters code.
// SoE: We use Hipnotic func_spawns instead.
//------------------------------------------------------------------------//
void() dragon_start =
{
//    sf64_telefx ();

    PM_MakeDragon (self.skin);

    // Activate the monster on the next frame.
    self.nextthink  = 0.1;
    self.think      = dragon_start_go;
};

//----------------------------------------------------/ New Code /--------//
//  This defines the basic properties of each dragon.
//  'iq' is dragon intelligence and 'hp' is dragon hit points (health).
//------------------------------------------------------------------------//
void() PM_VerifyDragon =
{
    PM_VerifySize ();
    PM_VerifyIQ ();
    PM_VerifyHealth ();
    PM_VerifySpeed ();
    PM_VerifyYawSpeed ();

    //  This sets the dragon's threshold.  Threshold allows the dragon to
    //  fight a given enemy without getting distracted by another attacker.
    //  Only smarter dragons have any threshold.
    if (self.state > IQ_NORMAL)
        PM_InitThreshold (self, 3);
    else
        PM_InitThreshold (self, 0);

    self.th_stand   = dragon_hover1;
    self.th_walk    = dragon_walk1;
    self.th_run     = dragon_run1;
    self.th_melee   = dragon_strike;
    self.th_missile = dragon_missile1;
    self.th_pain    = dragon_pain;
    self.th_die     = dragon_die;
};

//----------------------------------------------------/ New Code /--------//
//  This defines the dragon's attributes.
//------------------------------------------------------------------------//
void() PM_PrepareDragon =
{
    if (self.health < 0)
    {
        PM_SpawnDragonCorpse ();
        return;
    }

    // Now verify and initialize stats and functions.
    PM_VerifyDragon ();

    if (self.spawnflags & SPAWN_HIDDEN)
    {
        if (self.targetname)
        {
            // Hide until used.  Uses Zerstorer's sf64 monsters.
            self.use = dragon_start;
            if (PM_CountMonster (self))
                total_monsters = total_monsters + 1;
            return;
        }

        // If dragon cannot be triggered, don't hide.
        self.spawnflags = self.spawnflags - SPAWN_HIDDEN;
    }

    // Set size.
    PM_MakeDragon (self.skin);
    flymonster_start ();
};

//----------------------------------------------------/ New Code /--------//
//  This precaches models and sounds used by the dragons.
//------------------------------------------------------------------------//
void(float type) PM_PrecacheDragon =
{
    // Precache files common to all dragons.
    precache_model2 ("progs/dragon.mdl");    // Large dragon model
    precache_model2 ("progs/dragon2.mdl");   // Small dragon model
    precache_model2 ("progs/lwing.mdl");     // Gib (left wing)
    precache_model2 ("progs/rwing.mdl");     // Gib (right wing)
    precache_model2 ("progs/tail.mdl");      // Gib (tail)

    precache_sound2 ("demon/dhit2.wav");
    precache_sound2 ("dragon/death.wav");
    precache_sound2 ("dragon/death2.wav");
    precache_sound2 ("dragon/fly.wav");
    precache_sound2 ("dragon/pain.wav");
    precache_sound2 ("dragon/pain2.wav");
    precache_sound2 ("dragon/sight.wav");
    precache_sound2 ("dragon/sight2.wav");

    // Now precache files according to dragon type.
    if (type == SKIN_RED)
    {
        precache_model2 ("progs/flame2.mdl");

        precache_sound2 ("dragon/fire.wav");
        precache_sound2 ("dragon/firehit.wav");
        precache_sound  ("hknight/hit.wav");        // used by c code

        return;
    }
    if (type == SKIN_WHITE)
    {
        precache_model2 ("progs/ice.mdl");

        precache_sound2 ("dragon/ice.wav");
        precache_sound2 ("dragon/icehit.wav");

        return;
    }
    if (type == SKIN_BLUE)
    {
        precache_sound2 ("dragon/thunder.wav");

        return;
    }
    if (type == SKIN_GOLD)
    {
        precache_model2 ("progs/flame2.mdl");

        precache_sound2 ("dragon/fire.wav");
        precache_sound  ("hknight/hit.wav");        // used by c code

        return;
    }
    if (type == SKIN_GREEN)
    {
        precache_model2 ("progs/w_spike.mdl");

        precache_sound2 ("dragon/spit.wav");
        precache_sound  ("wizard/hit.wav");         // used by c code

        return;
    }
};

//----------------------------------------------------/ New Code /--------//
//  Set the attributes of the dragon and send it off.
//------------------------------------------------------------------------//
/*QUAKED monster_dragon (1 0 0) (-48 -48 -24) (48 48 48) Ambush Pacifist Cranked Armored Skilled x Hidden
*/
void() monster_dragon =
{
	local float i;
	i = cvar("temp1");

    if (notHere() || deathmatch || (i == 1 && self.targetname != "DMSP_boss"))
    {
        remove (self);
        return;
    }

    // Make sure the skin is legal.
    PM_VerifyType ();
    PM_PrecacheDragon (self.skin);
    PM_PrepareDragon ();
};


//==========================================================================
//  Alternate Entities -- Support for Dragons v3.0 or v3.1.

//------------------------------------------------------------------------//
/*QUAKED monster_reddragon (1 0 0) (-48 -48 -24) (48 48 48) Ambush Pacifist Cranked Armored Skilled x Hidden
*/
void() monster_reddragon =
{
    self.skin       = SKIN_RED;
    self.classname  = "monster_dragon";
    monster_dragon ();
};

//------------------------------------------------------------------------//
/*QUAKED monster_whitedragon (1 0 0) (-48 -48 -24) (48 48 48) Ambush Pacifist Cranked Armored Skilled x Hidden
*/
void() monster_whitedragon =
{
    self.skin       = SKIN_WHITE;
    self.classname  = "monster_dragon";
    monster_dragon ();
};

//------------------------------------------------------------------------//
/*QUAKED monster_bluedragon (1 0 0) (-48 -48 -24) (48 48 48) Ambush Pacifist Cranked Armored Skilled x Hidden
*/
void() monster_bluedragon =
{
    self.skin       = SKIN_BLUE;
    self.classname  = "monster_dragon";
    monster_dragon ();
};

//------------------------------------------------------------------------//
/*QUAKED monster_golddragon (1 0 0) (-48 -48 -24) (48 48 48) Ambush Pacifist Cranked Armored Skilled x Hidden
*/
void() monster_golddragon =
{
    self.skin       = SKIN_GOLD;
    self.classname  = "monster_dragon";
    monster_dragon ();
};

//------------------------------------------------------------------------//
/*QUAKED monster_greendragon (1 0 0) (-48 -48 -24) (48 48 48) Ambush Pacifist Cranked Armored Skilled x Hidden
*/
void() monster_greendragon =
{
    self.skin       = SKIN_GREEN;
    self.classname  = "monster_dragon";
    monster_dragon ();
};


//===========================/  END OF FILE  /===========================//
