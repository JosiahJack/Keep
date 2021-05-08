//==========================================================================
//  pet.qc -- by Patrick Martin                 Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code for small dragons owned by a player.
//
//  The model used for the dragons is based from iD's Qtest dragon.
//  However, the model is modified from the original -- the dragons
//  are 16% of the original size and I added many more frames to the
//  model.  (The Qtest dragon only had 18 frames.)
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
//     0  Red (original skin from iD's Qtest)
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


//==========================================================================
//  Movement Scenes

//----------------------------------------------------/ New Code /--------//
//  Hover animation.  Dragon hovers in place.  If a water-fearing
//  dragon is underwater, it will rise out of the water then hover.
//------------------------------------------------------------------------//
void()  pet_hover1   =[ $fly1,  pet_hover2   ] {pet_stand();};
void()  pet_hover2   =[ $fly2,  pet_hover3   ] {pet_stand();};
void()  pet_hover3   =[ $fly3,  pet_hover4   ] {pet_stand();};
void()  pet_hover4   =[ $fly4,  pet_hover5   ] {pet_stand();};
void()  pet_hover5   =[ $fly5,  pet_hover6   ] {pet_stand();};
void()  pet_hover6   =[ $fly6,  pet_hover7   ] {pet_stand();};
void()  pet_hover7   =[ $fly7,  pet_hover8   ] {pet_stand();};
void()  pet_hover8   =[ $fly8,  pet_hover9   ] {PM_RyuFlySound(); pet_stand();};
void()  pet_hover9   =[ $fly7,  pet_hover10  ] {pet_stand();};
void()  pet_hover10  =[ $fly6,  pet_hover11  ] {pet_stand();};
void()  pet_hover11  =[ $fly5,  pet_hover12  ] {pet_stand();};
void()  pet_hover12  =[ $fly4,  pet_hover13  ] {pet_stand();};
void()  pet_hover13  =[ $fly3,  pet_hover14  ] {pet_stand();};
void()  pet_hover14  =[ $fly2,  pet_hover1   ] {pet_stand();};

void()  pet_hoverstart =
{
    self.stalled = time + 1;
    pet_hover1();
};

//----------------------------------------------------/ New Code /--------//
//  Walk animation.  The dragon slowly glides along its path.
//  Water-fearing dragons will leave the water (if possible)
//  before following its path.
//------------------------------------------------------------------------//
void()  pet_walk1    =[ $fly1,  pet_walk2    ] {pet_walk();};
void()  pet_walk2    =[ $fly2,  pet_walk3    ] {pet_walk();};
void()  pet_walk3    =[ $fly3,  pet_walk4    ] {pet_walk();};
void()  pet_walk4    =[ $fly4,  pet_walk5    ] {pet_walk();};
void()  pet_walk5    =[ $fly5,  pet_walk6    ] {pet_walk();};
void()  pet_walk6    =[ $fly6,  pet_walk7    ] {pet_walk();};
void()  pet_walk7    =[ $fly7,  pet_walk8    ] {pet_walk();};
void()  pet_walk8    =[ $fly8,  pet_walk9    ] {PM_RyuFlySound(); pet_walk();};
void()  pet_walk9    =[ $fly7,  pet_walk10   ] {pet_walk();};
void()  pet_walk10   =[ $fly6,  pet_walk11   ] {pet_walk();};
void()  pet_walk11   =[ $fly5,  pet_walk12   ] {pet_walk();};
void()  pet_walk12   =[ $fly4,  pet_walk13   ] {pet_walk();};
void()  pet_walk13   =[ $fly3,  pet_walk14   ] {pet_walk();};
void()  pet_walk14   =[ $fly2,  pet_walk1    ] {pet_walk();};

void()  pet_walkstart =
{
    self.stalled = time + 1;
    pet_walk1();
};

//----------------------------------------------------/ New Code /--------//
//  Run animation.  The dragon flies quickly to find and close in
//  on its target.
//------------------------------------------------------------------------//
void()  pet_run1     =[ $fly1,  pet_run2   ] {pet_run();};
void()  pet_run2     =[ $fly2,  pet_run3   ] {pet_run();};
void()  pet_run3     =[ $fly3,  pet_run4   ] {pet_run();};
void()  pet_run4     =[ $fly4,  pet_run5   ] {pet_run();};
void()  pet_run5     =[ $fly5,  pet_run6   ] {pet_run();};
void()  pet_run6     =[ $fly6,  pet_run7   ] {pet_run();};
void()  pet_run7     =[ $fly7,  pet_run8   ] {pet_run();};
void()  pet_run8     =[ $fly8,  pet_run9   ] {PM_RyuFlySound(); pet_run();};
void()  pet_run9     =[ $fly7,  pet_run10  ] {pet_run();};
void()  pet_run10    =[ $fly6,  pet_run11  ] {pet_run();};
void()  pet_run11    =[ $fly5,  pet_run12  ] {pet_run();};
void()  pet_run12    =[ $fly4,  pet_run13  ] {pet_run();};
void()  pet_run13    =[ $fly3,  pet_run14  ] {pet_run();};
void()  pet_run14    =[ $fly2,  pet_run1   ] {pet_run();};

//==========================================================================
//  Attack Scenes

void() SuperDamageSound;

//----------------------------------------------------/ New Code /--------//
//  Make wing-flapping noise if dragon does not have quad damage.
//------------------------------------------------------------------------//
void() PM_FlyVsQuad =
{
    if (self.super_sound < time)
        PM_RyuFlySound();
};

//------------------//
//  Melee attacks!  //
//------------------//

//----------------------------------------------------/ New Code /--------//
//  This selects the bite attack power based on the dragon's attributes.
//------------------------------------------------------------------------//
void(vector offset) PM_PetBiteAttack =
{
    local   float   level;
    local   vector  damage;

    level = pet_level ();
    damage = DMG_RYU_BITE * level;

    PM_DragonBite (offset, REACH_SMALL, damage);
};

//----------------------------------------------------/ New Code /--------//
//  Melee animation.  The dragon makes two bite attacks.
//------------------------------------------------------------------------//
void()  pet_bite1   =[ $attack1,  pet_bite2   ] {pet_melee();};
void()  pet_bite2   =[ $attack2,  pet_bite3   ] {pet_melee();};
void()  pet_bite3   =[ $attack3,  pet_bite4   ] {pet_melee();};
void()  pet_bite4   =[ $attack4,  pet_bite5   ] {pet_melee();};
void()  pet_bite5   =[ $attack5,  pet_bite6   ] {pet_melee();};
void()  pet_bite6   =[ $attack6,  pet_bite7   ] {pet_melee();};
void()  pet_bite7   =[ $attack7,  pet_bite8   ] {pet_melee();};
void()  pet_bite8   =[ $attack8,  pet_bite9   ] {pet_melee();};
void()  pet_bite9   =[ $attack9,  pet_bite10  ]
{   PM_FlyVsQuad();
    pet_melee();
    SuperDamageSound ();
    PM_PetBiteAttack ('17 -2 -4');
};
void()  pet_bite10  =[ $attack8,  pet_bite11  ] {pet_melee();};
void()  pet_bite11  =[ $attack7,  pet_bite12  ] {pet_melee();};
void()  pet_bite12  =[ $attack6,  pet_bite13  ] {pet_melee();};
void()  pet_bite13  =[ $attack5,  pet_bite14  ] {pet_melee();};
void()  pet_bite14  =[ $attack4,  pet_bite15  ] {pet_melee();};
void()  pet_bite15  =[ $attack3,  pet_bite16  ] {pet_melee();};
void()  pet_bite16  =[ $attack2,  pet_bite17  ]
{   pet_melee();
    SuperDamageSound ();
    PM_PetBiteAttack ('18 0 -1');
};
void()  pet_bite17  =[ $attack1,  pet_run1    ]
{   pet_melee();
    self.attack_state = AS_STRAIGHT;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon can bite its target.
//------------------------------------------------------------------------//
float(float chance) PM_PetCanBite =
{
    // If dragon has no missile attack, then it can use only the bite.
    if (!self.th_missile)
        return TRUE;

    // Don't shoot at target if a good guy is near it.
    if (PM_PetAllyInWay ())
        return TRUE;

    // If dragon is afraid of water, don't use breath attack.
    if (PM_Hydrophobic ())
        if (PM_EntInWater (self))
        {
            // FIXME:  Blue dragons could discharge in specific situations.
            return TRUE;
        }

    // If path crosses contents, use only the bite unless dragon is blue.
    if (self.skin != SKIN_BLUE)
    {
        traceline(self.origin, self.enemy.origin, TRUE, self);
        if (trace_inopen)
            if (trace_inwater)
                return TRUE;
    }

    // If close enough, the dragon may bite.
    if (vlen(self.enemy.origin - self.origin) <= REACH_SMALL)
        if (random() < chance)
            return TRUE;

    // Don't bite.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  Melee attack start.  About midway into the animation, the dragon
//  decides whether to bite or to shoot something.  This is used by
//  smart dragons to foil the 'in-and-out' strategy used by players.
//------------------------------------------------------------------------//
void() pet_strike =
{
    local   float   chance;

    if (self.slide_away >= time)
    {
        // Dragon wants to circle-strafe and shoot.
        self.attack_state = AS_SLIDING;
        if (random() < 0.5)
            self.lefty = 1;
        else
            self.lefty = 0;
        chance = 0;
    }
    else
    {
        // Try to close in.  If dragon wants to stay away from the enemy,
        // it will always shoot if possible.  Otherwise, it will likely
        // bite the target.
        self.attack_state = AS_STRAIGHT;
        if (self.enemy.classname == "monster_zombie")
            chance = 1;     // Always bite zombies.
        else
            chance = 0.8;

        // Check for special case.  Assumes familiar has high or greater iq.
        if (PM_KeepAway (self.enemy))
        {
            chance = 0;     // Always shoot if trying to get away.
        }
        else if (self.skin == SKIN_GOLD)
        {
            // Gold dragon shots are stronger than bite unless the
            // enemy resists fire.
            if (!PM_FireResistant (self.enemy))
                chance = 0.5;
        }
    }

    // If dragon can bite the target, do it!
    if (PM_PetCanBite (chance))
    {
        pet_bite1();
        return;
    }

    // Shoot at target.
    self.th_missile();
};


//--------------------//
//  Missile attacks!  //
//--------------------//

//----------------------------------------------------/ New Code /--------//
//  FIRE
//
//  Missile attack animation for the red dragon.  The red dragon
//  shoots fireballs that can ignite targets.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  pet_fire6a  =[ $attack6,  pet_fire7a  ] {pet_missile();};
void()  pet_fire7a  =[ $attack7,  pet_fire8a  ] {pet_missile();};
void()  pet_fire8a  =[ $attack8,  pet_fire9a  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonFire('16 -1 0', SHOT1_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire9a  =[ $attack9,  pet_fire10a ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonFire('16 -2 -3', SHOT1_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire10a =[ $attack8,  pet_missile11 ]
{   pet_missile();
    PM_DragonFire('16 -1 0', SHOT1_SPEED, DMG_RYU_FIRE, 1);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  pet_fire6b  =[ $attack6,  pet_fire7b  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonFire('16 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire7b  =[ $attack7,  pet_fire8b  ]
{   pet_missile();
    PM_DragonFire('16 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire8b  =[ $attack8,  pet_fire9b  ]
{   pet_missile();
    PM_DragonFire('16 -1 0', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire9b  =[ $attack9,  pet_fire10b ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonFire('16 -2 -3', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire10b =[ $attack8,  pet_fire11b ]
{   pet_missile();
    PM_DragonFire('16 -1 0', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};
void()  pet_fire11b =[ $attack7,  pet_missile12  ]
{   pet_missile();
    PM_DragonFire('16 0 2', SHOT2_SPEED, DMG_RYU_FIRE, 1);
};

//-----------//
//  LEVEL 3  //
//-----------//
void()  pet_fire6c  =[ $attack6,  pet_fire7c  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 0 2', SHOT3_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 0 2', SHOT3_SPEED, DMG_RYU_FIRE, (1/3));
};
void()  pet_fire7c  =[ $attack7,  pet_fire8c  ]
{   pet_missile();
    PM_SetDragonAmmo (1);
    PM_DragonFire('16 0 2', SHOT3_SPEED, DMG_RYU_FIRE, (2/3));
};
void()  pet_fire8c  =[ $attack8,  pet_fire9c  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 -1 0', SHOT3_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 -1 0', SHOT3_SPEED, DMG_RYU_FIRE, (1/3));
};
void()  pet_fire9c  =[ $attack9,  pet_fire10c ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_SetDragonAmmo (1);
    PM_DragonFire('16 -2 -3', SHOT3_SPEED, DMG_RYU_FIRE, (2/3));
};
void()  pet_fire10c =[ $attack8,  pet_fire11c ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 -1 0', SHOT3_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 -1 0', SHOT3_SPEED, DMG_RYU_FIRE, (1/3));
};
void()  pet_fire11c =[ $attack7,  pet_missile12  ]
{   pet_missile();
    PM_SetDragonAmmo (1);
    PM_DragonFire('16 0 2', SHOT3_SPEED, DMG_RYU_FIRE, (2/3));
};

//-----------//
//  LEVEL 4  //
//-----------//
void()  pet_fire6d  =[ $attack6,  pet_fire7d  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  pet_fire7d  =[ $attack7,  pet_fire8d  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  pet_fire8d  =[ $attack8,  pet_fire9d  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 -1 0', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 -1 0', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  pet_fire9d  =[ $attack9,  pet_fire10d ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 -2 -3', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 -2 -3', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  pet_fire10d =[ $attack8,  pet_fire11d ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 -1 0', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 -1 0', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};
void()  pet_fire11d =[ $attack7,  pet_missile12  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonFire('16 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 1);
    PM_DragonFire('16 0 2', SHOT4_SPEED, DMG_RYU_FIRE, 0.5);
};


//----------------------------------------------------/ New Code /--------//
//  ICE
//
//  Missile attack animation for the white dragon.  The white dragon
//  shoots ice shards at the target.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  pet_ice6a  =[ $attack6,  pet_ice7a  ] {pet_missile();};
void()  pet_ice7a  =[ $attack7,  pet_ice8a  ] {pet_missile();};
void()  pet_ice8a  =[ $attack8,  pet_ice9a  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    PM_DragonIce('16 -1 0', SHOT1_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice9a  =[ $attack9,  pet_ice10a ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonIce('16 -2 -3', SHOT1_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice10a =[ $attack8,  pet_missile11 ]
{   pet_missile();
    PM_DragonIce('16 -1 0', SHOT1_SPEED, DMG_RYU_ICE, 1);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  pet_ice6b  =[ $attack6,  pet_ice7b  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    PM_DragonIce('16 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice7b  =[ $attack7,  pet_ice8b  ]
{   pet_missile();
    PM_DragonIce('16 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice8b  =[ $attack8,  pet_ice9b  ]
{   pet_missile();
    PM_DragonIce('16 -1 0', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice9b  =[ $attack9,  pet_ice10b ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonIce('16 -2 -3', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice10b =[ $attack8,  pet_ice11b ]
{   pet_missile();
    PM_DragonIce('16 -1 0', SHOT2_SPEED, DMG_RYU_ICE, 1);
};
void()  pet_ice11b =[ $attack7,  pet_missile12  ]
{   pet_missile();
    PM_DragonIce('16 0 2', SHOT2_SPEED, DMG_RYU_ICE, 1);
};

//-----------//
//  LEVEL 3  //
//-----------//
void()  pet_ice6c  =[ $attack6,  pet_ice7c  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 0 2', SHOT3_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 0 2', SHOT3_SPEED, DMG_RYU_ICE, (1/3));
};
void()  pet_ice7c  =[ $attack7,  pet_ice8c  ]
{   pet_missile();
    PM_SetDragonAmmo (1);
    PM_DragonIce('16 0 2', SHOT3_SPEED, DMG_RYU_ICE, (2/3));
};
void()  pet_ice8c  =[ $attack8,  pet_ice9c  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 -1 0', SHOT3_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 -1 0', SHOT3_SPEED, DMG_RYU_ICE, (1/3));
};
void()  pet_ice9c  =[ $attack9,  pet_ice10c ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_SetDragonAmmo (1);
    PM_DragonIce('16 -2 -3', SHOT3_SPEED, DMG_RYU_ICE, (2/3));
};
void()  pet_ice10c =[ $attack8,  pet_ice11c ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 -1 0', SHOT3_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 -1 0', SHOT3_SPEED, DMG_RYU_ICE, (1/3));
};
void()  pet_ice11c =[ $attack7,  pet_missile12  ]
{   pet_missile();
    PM_SetDragonAmmo (1);
    PM_DragonIce('16 0 2', SHOT3_SPEED, DMG_RYU_ICE, (2/3));
};

//-----------//
//  LEVEL 4  //
//-----------//
void()  pet_ice6d  =[ $attack6,  pet_ice7d  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 0 2', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 0 2', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  pet_ice7d  =[ $attack7,  pet_ice8d  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 0 2', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 0 2', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  pet_ice8d  =[ $attack8,  pet_ice9d  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 -1 0', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 -1 0', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  pet_ice9d  =[ $attack9,  pet_ice10d ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 -2 -3', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 -2 -3', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  pet_ice10d =[ $attack8,  pet_ice11d ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 -1 0', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 -1 0', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};
void()  pet_ice11d =[ $attack7,  pet_missile12  ]
{   pet_missile();
    PM_SetDragonAmmo (2);
    PM_DragonIce('16 0 2', SHOT4_SPEED, DMG_RYU_ICE, 1);
    PM_DragonIce('16 0 2', SHOT4_SPEED, DMG_RYU_ICE, 0.5);
};


//----------------------------------------------------/ New Code /--------//
//  LIGHTNING
//
//  Missile attack animation for the blue dragon.  The blue dragon
//  shoots lightning that can zap multiple targets like a railgun.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  pet_bolt6a  =[ $attack6,  pet_bolt7a  ] {pet_missile();};
void()  pet_bolt7a  =[ $attack7,  pet_bolt8a  ] {pet_missile();};
void()  pet_bolt8a  =[ $attack8,  pet_bolt9a  ] {pet_missile();};
void()  pet_bolt9a  =[ $attack9,  pet_missile10 ]
{   PM_FlyVsQuad();
    pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (1);
    PM_DragonBolt('16 -2 -3', SHOT1_SPEED, DMG_RYU_BOLT);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  pet_bolt6b  =[ $attack6,  pet_bolt7b  ] {pet_missile();};
void()  pet_bolt7b  =[ $attack7,  pet_bolt8b  ] {pet_missile();};
void()  pet_bolt8b  =[ $attack8,  pet_bolt9b  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (2);
    PM_DragonBolt('16 -1 0', SHOT2_SPEED, DMG_RYU_BOLT);
};
void()  pet_bolt9b  =[ $attack9,  pet_missile10 ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonBolt('16 -2 -3', SHOT2_SPEED, DMG_RYU_BOLT);
};

//-----------//
//  LEVEL 3  //
//-----------//
void()  pet_bolt6c  =[ $attack6,  pet_bolt7c  ] {pet_missile();};
void()  pet_bolt7c  =[ $attack7,  pet_bolt8c  ] {pet_missile();};
void()  pet_bolt8c  =[ $attack8,  pet_bolt9c  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (3);
    PM_DragonBolt('16 -1 0', SHOT3_SPEED, DMG_RYU_BOLT);
};
void()  pet_bolt9c  =[ $attack9,  pet_bolt10c ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonBolt('16 -2 -3', SHOT3_SPEED, DMG_RYU_BOLT);
};
void()  pet_bolt10c =[ $attack8,  pet_missile11 ]
{   pet_missile();
    PM_DragonBolt('16 -1 0', SHOT3_SPEED, DMG_RYU_BOLT);
};

//-----------//
//  LEVEL 4  //
//-----------//
void()  pet_bolt6d  =[ $attack6,  pet_bolt7d  ] {pet_missile();};
void()  pet_bolt7d  =[ $attack7,  pet_bolt8d  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/thunder.wav", 1, ATTN_NORM);
    PM_SetDragonAmmo (4);
    PM_DragonBolt('16 0 2', SHOT4_SPEED, DMG_RYU_BOLT);
};
void()  pet_bolt8d  =[ $attack8,  pet_bolt9d  ]
{   pet_missile();
    PM_DragonBolt('16 -1 0', SHOT4_SPEED, DMG_RYU_BOLT);
};
void()  pet_bolt9d  =[ $attack9,  pet_bolt10d ]
{   PM_FlyVsQuad();
    pet_missile();
    PM_DragonBolt('16 -2 -3', SHOT4_SPEED, DMG_RYU_BOLT);
};
void()  pet_bolt10d =[ $attack8,  pet_missile11 ]
{   pet_missile();
    PM_DragonBolt('16 -1 0', SHOT4_SPEED, DMG_RYU_BOLT);
};


//----------------------------------------------------/ New Code /--------//
//  NAPALM
//
//  Missile attack animation for the gold dragon.  The gold dragon
//  shoots large fireball(s) at the target.  Fireball explodes into
//  a small cloud of fire.
//------------------------------------------------------------------------//

//-----------//
//  LEVEL 1  //
//-----------//
void()  pet_blast6a  =[ $attack6,  pet_blast7a  ] {pet_missile();};
void()  pet_blast7a  =[ $attack7,  pet_blast8a  ] {pet_missile();};
void()  pet_blast8a  =[ $attack8,  pet_blast9a  ] {pet_missile();};
void()  pet_blast9a  =[ $attack9,  pet_missile10 ]
{   PM_FlyVsQuad();
    pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 -2 -3', DMG_RYU_BLAST13, SHOT1_SPEED, DMG_RYU_FIRE);
};

//-----------//
//  LEVEL 2  //
//-----------//
void()  pet_blast6b  =[ $attack6,  pet_blast7b  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 0 0', DMG_RYU_BLAST13, SHOT2_SPEED, DMG_RYU_FIRE);
};
void()  pet_blast7b  =[ $attack7,  pet_blast8b  ] {pet_missile();};
void()  pet_blast8b  =[ $attack8,  pet_blast9b  ] {pet_missile();};
void()  pet_blast9b  =[ $attack9,  pet_blast10b ]
{   PM_FlyVsQuad();
    pet_missile();
};
void()  pet_blast10b =[ $attack8,  pet_blast11b ] {pet_missile();};
void()  pet_blast11b =[ $attack7,  pet_blast12b ] {pet_missile();};
void()  pet_blast12b =[ $attack6,  pet_missile13  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 0 0', DMG_RYU_BLAST13, SHOT2_SPEED, DMG_RYU_FIRE);
};

//-----------//
//  LEVEL 3  //
//-----------//
void()  pet_blast6c  =[ $attack6,  pet_blast7c  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 0 0', DMG_RYU_BLAST13, SHOT3_SPEED, DMG_RYU_FIRE);
};
void()  pet_blast7c  =[ $attack7,  pet_blast8c  ] {pet_missile();};
void()  pet_blast8c  =[ $attack8,  pet_blast9c  ] {pet_missile();};
void()  pet_blast9c  =[ $attack9,  pet_blast10c ]
{   PM_FlyVsQuad();
    pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 -2 -3', DMG_RYU_BLAST13, SHOT3_SPEED, DMG_RYU_FIRE);
};
void()  pet_blast10c =[ $attack8,  pet_blast11c ] {pet_missile();};
void()  pet_blast11c =[ $attack7,  pet_blast12c ] {pet_missile();};
void()  pet_blast12c =[ $attack6,  pet_missile13  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 0 0', DMG_RYU_BLAST13, SHOT3_SPEED, DMG_RYU_FIRE);
};

//-----------//
//  LEVEL 4  //
//-----------//
void()  pet_blast6d  =[ $attack6,  pet_blast7d  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 0 0', DMG_RYU_BLAST4, SHOT4_SPEED, DMG_RYU_FIRE);
};
void()  pet_blast7d  =[ $attack7,  pet_blast8d  ] {pet_missile();};
void()  pet_blast8d  =[ $attack8,  pet_blast9d  ] {pet_missile();};
void()  pet_blast9d  =[ $attack9,  pet_blast10d ]
{   PM_FlyVsQuad();
    pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 -2 -3', DMG_RYU_BLAST4, SHOT4_SPEED, DMG_RYU_FIRE);
};
void()  pet_blast10d =[ $attack8,  pet_blast11d ] {pet_missile();};
void()  pet_blast11d =[ $attack7,  pet_blast12d ] {pet_missile();};
void()  pet_blast12d =[ $attack6,  pet_missile13  ]
{   pet_missile();
    SuperDamageSound ();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    PM_DragonBlast ('16 0 0', DMG_RYU_BLAST4, SHOT4_SPEED, DMG_RYU_FIRE);
};


//==========================================================================

//------------//
//  STANDARD  //
//------------//
void()  pet_missile1   =[ $attack1,  pet_missile2  ]
{   PM_StrafeOption ();
    pet_missile();
};
void()  pet_missile2   =[ $attack2,  pet_missile3  ] {pet_missile();};
void()  pet_missile3   =[ $attack3,  pet_missile4  ] {pet_missile();};
void()  pet_missile4   =[ $attack4,  pet_missile5  ] {pet_missile();};
void()  pet_missile5   =[ $attack5,  pet_missileselect]
{   pet_missile();
    PM_SetDragonAim (TRUE);
    PM_SetDragonAmmo (0);
};
//-----------------------------------------------------------------------//
void()  pet_missile6   =[ $attack6,  pet_missile7  ] {pet_missile();};
void()  pet_missile7   =[ $attack7,  pet_missile8  ] {pet_missile();};
void()  pet_missile8   =[ $attack8,  pet_missile9  ] {pet_missile();};
void()  pet_missile9   =[ $attack9,  pet_missile10 ]
{   PM_RyuFlySound();
    pet_missile();
};
void()  pet_missile10  =[ $attack8,  pet_missile11 ] {pet_missile();};
void()  pet_missile11  =[ $attack7,  pet_missile12 ] {pet_missile();};
void()  pet_missile12  =[ $attack6,  pet_missile13 ] {pet_missile();};
//-----------------------------------------------------------------------//
void()  pet_missile13  =[ $attack5,  pet_missile14 ] {pet_missile();};
void()  pet_missile14  =[ $attack4,  pet_missile15 ] {pet_missile();};
void()  pet_missile15  =[ $attack3,  pet_missile16 ] {pet_missile();};
void()  pet_missile16  =[ $attack2,  pet_missile17 ] {pet_missile();};
void()  pet_missile17  =[ $attack1,  pet_run1      ] {pet_missile();};
void()  pet_missileselect =
{
    local   float   level;

    level = pet_level ();
    if (level == 1)
    {
        if (self.skin == SKIN_GOLD)
            pet_blast6a();
        else if (self.skin == SKIN_BLUE)
            pet_bolt6a();
        else if (self.skin == SKIN_WHITE)
            pet_ice6a();
        else
            pet_fire6a();
        return;
    }
    else if (level == 2)
    {
        if (self.skin == SKIN_GOLD)
            pet_blast6b();
        else if (self.skin == SKIN_BLUE)
            pet_bolt6b();
        else if (self.skin == SKIN_WHITE)
            pet_ice6b();
        else
            pet_fire6b();
        return;
    }
    else if (level == 3)
    {
        if (self.skin == SKIN_GOLD)
            pet_blast6c();
        else if (self.skin == SKIN_BLUE)
            pet_bolt6c();
        else if (self.skin == SKIN_WHITE)
            pet_ice6c();
        else
            pet_fire6c();
        return;
    }
    else //if (level == 4)
    {
        if (self.skin == SKIN_GOLD)
            pet_blast6d();
        else if (self.skin == SKIN_BLUE)
            pet_bolt6d();
        else if (self.skin == SKIN_WHITE)
            pet_ice6d();
        else
            pet_fire6d();
        return;
    }
};


//==========================================================================
//  Pain Scenes

//----------------------------------------------------/ New Code /--------//
//  Pain animation #1.  The dragon recoils in pain.
//------------------------------------------------------------------------//
void()  pet_pain1    =[ $pain1,   pet_pain2  ] {pet_status();};
void()  pet_pain2    =[ $pain2,   pet_pain3  ] {pet_status();};
void()  pet_pain3    =[ $pain3,   pet_pain4  ] {pet_status();};
void()  pet_pain4    =[ $pain4,   pet_pain5  ] {pet_status();};
void()  pet_pain5    =[ $pain5,   pet_pain6  ] {pet_status();};
void()  pet_pain6    =[ $pain6,   pet_run1   ] {pet_status();};

//----------------------------------------------------/ New Code /--------//
//  Pain animation #2.  The dragon turns its head.
//------------------------------------------------------------------------//
void()  pet_painb1   =[ $painb1,  pet_painb2 ] {pet_status();};
void()  pet_painb2   =[ $painb2,  pet_painb3 ] {pet_status();};
void()  pet_painb3   =[ $painb3,  pet_painb4 ] {pet_status();};
void()  pet_painb4   =[ $painb4,  pet_painb5 ] {pet_status();};
void()  pet_painb5   =[ $painb5,  pet_painb6 ] {pet_status();};
void()  pet_painb6   =[ $painb6,  pet_run1   ] {pet_status();};

//----------------------------------------------------/ New Code /--------//
//  Pain animation #3.  The dragon shakes violently.
//------------------------------------------------------------------------//
void()  pet_painc1   =[ $painc1,  pet_painc2 ] {pet_status();};
void()  pet_painc2   =[ $painc2,  pet_painc3 ] {pet_status();};
void()  pet_painc3   =[ $painc3,  pet_painc4 ] {pet_status();};
void()  pet_painc4   =[ $painc4,  pet_painc5 ] {pet_status();};
void()  pet_painc5   =[ $painc5,  pet_painc6 ] {pet_status();};
void()  pet_painc6   =[ $painc6,  pet_run1   ] {pet_status();};

//----------------------------------------------------/ New Code /--------//
//  This is called when a dragon familiar gets injured.
//------------------------------------------------------------------------//
void(entity attacker, float damage) pet_pain =
{
    if (PM_ImmortalDragon (self))
    {
        // Familiars marked with Shiva are immune to pain.
        self.health = self.max_health;
        if (self == self.master.draco)
            PM_DragonAddArmor (self, 0);
        return;
    }

    self.slide_rand = time + DODGE_TIME;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;

    sound (self, CHAN_VOICE, "dragon/pain2.wav", 1, ATTN_NORM);

    if ((random() * 50) > damage)
        return;         // didn't flinch

    // Dragon will reel in pain.
    self.slide_away = time + 2;         // Will strafe upon recovery/attack.
    self.attack_state = AS_STRAIGHT;    // Get out of other attack states.
    self.attack_finished = 0;           // Can attack anytime now!

    // Choose one of three pain scenes.
    local   float   r;

    r = random();
    if (r < 0.4)
        pet_pain1();
    else if (r < 0.8)
        pet_painb1();
    else
        pet_painc1();
};


//==========================================================================
//  Death Scenes

//----------------------------------------------------/ New Code /--------//
//  This makes the slain familiar disappear in a cloud of fog.
//------------------------------------------------------------------------//
void()  pet_vanish =
{
    spawn_tfog (self.origin);
    remove (self);
};

//----------------------------------------------------/ New Code /--------//
//  This makes the slain familiar disappear in 10-20 seconds.
//------------------------------------------------------------------------//
void()  pet_dead =
{
    self.nextthink  = time + 10 + random()*10;
    self.think      = pet_vanish;
};

//----------------------------------------------------/ New Code /--------//
//  Death animation #1.  The dragon pitches over and falls on its back.
//------------------------------------------------------------------------//
void()  pet_die1     =[ $die1,   pet_die2   ] {};
void()  pet_die2     =[ $die2,   pet_die3   ] {};
void()  pet_die3     =[ $die3,   pet_die4   ] {};
void()  pet_die4     =[ $die4,   pet_die5   ] {};
void()  pet_die5     =[ $die5,   pet_die6   ] {self.solid = SOLID_NOT;};
void()  pet_die6     =[ $die6,   pet_die7   ] {};
void()  pet_die7     =[ $die7,   pet_die8   ] {};
void()  pet_die8     =[ $die8,   pet_die9   ] {};
void()  pet_die9     =[ $die9,   pet_die10  ] {};
void()  pet_die10    =[ $die10,  pet_die11  ] {};
void()  pet_die11    =[ $die11,  pet_die12  ] {};
void()  pet_die12    =[ $die12,  pet_die13  ] {};
void()  pet_die13    =[ $die13,  pet_dead   ] {};

//----------------------------------------------------/ New Code /--------//
//  Death animation #2.  The dragon simply falls down.
//------------------------------------------------------------------------//
void()  pet_dieb1    =[ $dieb1,  pet_dieb2  ] {};
void()  pet_dieb2    =[ $dieb2,  pet_dieb3  ] {};
void()  pet_dieb3    =[ $dieb3,  pet_dieb4  ] {};
void()  pet_dieb4    =[ $dieb4,  pet_dieb5  ] {};
void()  pet_dieb5    =[ $dieb5,  pet_dieb6  ] {self.solid = SOLID_NOT;};
void()  pet_dieb6    =[ $dieb6,  pet_dead   ] {};

//----------------------------------------------------/ New Code /--------//
//  This is called when a dragon familiar dies.
//------------------------------------------------------------------------//
void() pet_die =
{
    PM_DestroyPet (self);
};


//===========================/  END OF FILE  /===========================//
