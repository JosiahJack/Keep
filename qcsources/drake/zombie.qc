/*
==============================================================================

ZOMBIE

==============================================================================
*/
$cd id1/models/zombie

$origin    0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

// Extended scene
$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9 decap10
$frame decap11

//float    SPAWN_CRUCIFIED    = 1;
//- - - - - - - - - - - - - -
// Hipnotic
//float    SPAWN_LAYINGDOWN   = 4;

// Note:  Other mods use spawnflags differently.
// Rogue has 1=Cruc, 2=Lying, 4=Ambush, 8=Sneaky
// Zerstorer has 1=Cruc, 2=Lying, 4=Lying/Triggered, 8=Dead Cruc.
//- - - - - - - - - - - - - -

//=============================================================================

// PM:  Moved .float inpain to 'entity.qc'.

// STAND - - - - - - - - - - - - - - - -
void() zombie_stand1  =[ $stand1,   zombie_stand2  ] {ai_stand();};
void() zombie_stand2  =[ $stand2,   zombie_stand3  ] {ai_stand();};
void() zombie_stand3  =[ $stand3,   zombie_stand4  ] {ai_stand();};
void() zombie_stand4  =[ $stand4,   zombie_stand5  ] {ai_stand();};
void() zombie_stand5  =[ $stand5,   zombie_stand6  ] {ai_stand();};
void() zombie_stand6  =[ $stand6,   zombie_stand7  ] {ai_stand();};
void() zombie_stand7  =[ $stand7,   zombie_stand8  ] {ai_stand();};
void() zombie_stand8  =[ $stand8,   zombie_stand9  ] {ai_stand();};
void() zombie_stand9  =[ $stand9,   zombie_stand10 ] {ai_stand();};
void() zombie_stand10 =[ $stand10,  zombie_stand11 ] {ai_stand();};
void() zombie_stand11 =[ $stand11,  zombie_stand12 ] {ai_stand();};
void() zombie_stand12 =[ $stand12,  zombie_stand13 ] {ai_stand();};
void() zombie_stand13 =[ $stand13,  zombie_stand14 ] {ai_stand();};
void() zombie_stand14 =[ $stand14,  zombie_stand15 ] {ai_stand();};
void() zombie_stand15 =[ $stand15,  zombie_stand1  ] {ai_stand();};

void() zombie_cruc1   =[ $cruc_1,   zombie_cruc2   ] {
if (random() < 0.1)
    sound (self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC);};
void() zombie_cruc2   =[ $cruc_2,   zombie_cruc3   ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc3   =[ $cruc_3,   zombie_cruc4   ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc4   =[ $cruc_4,   zombie_cruc5   ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc5   =[ $cruc_5,   zombie_cruc6   ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc6   =[ $cruc_6,   zombie_cruc1   ] {self.nextthink = time + 0.1 + random()*0.1;};

// WALK - - - - - - - - - - - - - - - -
// As ai_walk, except mummies move at double speed.
void(float d) zai_walk =
{
    if (self.classname == "monster_mummy")
        d = d * 2;
    ai_walk (d);
};
void() zombie_walk1   =[ $walk1,    zombie_walk2   ] {ai_walk(0);};
void() zombie_walk2   =[ $walk2,    zombie_walk3   ] {zai_walk(2);};
void() zombie_walk3   =[ $walk3,    zombie_walk4   ] {zai_walk(3);};
void() zombie_walk4   =[ $walk4,    zombie_walk5   ] {zai_walk(2);};
void() zombie_walk5   =[ $walk5,    zombie_walk6   ] {zai_walk(1);};
void() zombie_walk6   =[ $walk6,    zombie_walk7   ] {ai_walk(0);};
void() zombie_walk7   =[ $walk7,    zombie_walk8   ] {ai_walk(0);};
void() zombie_walk8   =[ $walk8,    zombie_walk9   ] {ai_walk(0);};
void() zombie_walk9   =[ $walk9,    zombie_walk10  ] {ai_walk(0);};
void() zombie_walk10  =[ $walk10,   zombie_walk11  ] {ai_walk(0);};
void() zombie_walk11  =[ $walk11,   zombie_walk12  ] {zai_walk(2);};
void() zombie_walk12  =[ $walk12,   zombie_walk13  ] {zai_walk(2);};
void() zombie_walk13  =[ $walk13,   zombie_walk14  ] {zai_walk(1);};
void() zombie_walk14  =[ $walk14,   zombie_walk15  ] {ai_walk(0);};
void() zombie_walk15  =[ $walk15,   zombie_walk16  ] {ai_walk(0);};
void() zombie_walk16  =[ $walk16,   zombie_walk17  ] {ai_walk(0);};
void() zombie_walk17  =[ $walk17,   zombie_walk18  ] {ai_walk(0);};
void() zombie_walk18  =[ $walk18,   zombie_walk19  ] {ai_walk(0);};
void() zombie_walk19  =[ $walk19,   zombie_walk1   ] {ai_walk(0);
if (random() < 0.2)
    sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);};

// RUN - - - - - - - - - - - - - - - - -
// As ai_run, except mummies move at double speed.
void(float d) zai_run =
{
    if (self.classname == "monster_mummy")
        d = d * 2;
    ai_run (d);
};
void() zombie_run1    =[ $run1,     zombie_run2    ] {zai_run(1);self.inpain = 0;};
void() zombie_run2    =[ $run2,     zombie_run3    ] {zai_run(1);};
void() zombie_run3    =[ $run3,     zombie_run4    ] {ai_run(0);};
void() zombie_run4    =[ $run4,     zombie_run5    ] {zai_run(1);};
void() zombie_run5    =[ $run5,     zombie_run6    ] {zai_run(2);};
void() zombie_run6    =[ $run6,     zombie_run7    ] {zai_run(3);};
void() zombie_run7    =[ $run7,     zombie_run8    ] {zai_run(4);};
void() zombie_run8    =[ $run8,     zombie_run9    ] {zai_run(4);};
void() zombie_run9    =[ $run9,     zombie_run10   ] {zai_run(2);};
void() zombie_run10   =[ $run10,    zombie_run11   ] {ai_run(0);};
void() zombie_run11   =[ $run11,    zombie_run12   ] {ai_run(0);};
void() zombie_run12   =[ $run12,    zombie_run13   ] {ai_run(0);};
void() zombie_run13   =[ $run13,    zombie_run14   ] {zai_run(2);};
void() zombie_run14   =[ $run14,    zombie_run15   ] {zai_run(4);};
void() zombie_run15   =[ $run15,    zombie_run16   ] {zai_run(6);};
void() zombie_run16   =[ $run16,    zombie_run17   ] {zai_run(7);};
void() zombie_run17   =[ $run17,    zombie_run18   ] {zai_run(3);};
void() zombie_run18   =[ $run18,    zombie_run1    ] {zai_run(8);
if (random() < 0.2)
    sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
if (random() > 0.8)
    sound (self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE);
};
// PM:  It is possible for 'th_run()' to be called while the zombie is down.
// That would cause the zombie to become a ghost, if not for the fix below.
void() zombie_paine12;
void() zombie_run =
{
    if (!self.solid)
    {
        if (self.inpain)
            { zombie_paine12(); return; }   // Down on ground, try to get up.
        // else:  Ghost bug if not inpain.  That shouldn't happen.
    }
    self.burn_ofs = '0 0 16';
    zombie_run1 ();     // Do normal run routine.
};

//===========================================================================
//
// ATTACKS
//
//===========================================================================

// Missile code moved to another file.

void() zombie_atta1   =[ $atta1,    zombie_atta2   ] {ai_face();};
void() zombie_atta2   =[ $atta2,    zombie_atta3   ] {ai_face();};
void() zombie_atta3   =[ $atta3,    zombie_atta4   ] {ai_face();};
void() zombie_atta4   =[ $atta4,    zombie_atta5   ] {ai_face();};
void() zombie_atta5   =[ $atta5,    zombie_atta6   ] {ai_face();};
void() zombie_atta6   =[ $atta6,    zombie_atta7   ] {ai_face();};
void() zombie_atta7   =[ $atta7,    zombie_atta8   ] {ai_face();};
void() zombie_atta8   =[ $atta8,    zombie_atta9   ] {ai_face();};
void() zombie_atta9   =[ $atta9,    zombie_atta10  ] {ai_face();};
void() zombie_atta10  =[ $atta10,   zombie_atta11  ] {ai_face();};
void() zombie_atta11  =[ $atta11,   zombie_atta12  ] {ai_face();};
void() zombie_atta12  =[ $atta12,   zombie_atta13  ] {ai_face();};
void() zombie_atta13  =[ $atta13,   zombie_run1    ] {ai_face(); M_FireMeat('4.4 10.5 30');};

void() zombie_attb1   =[ $attb1,    zombie_attb2   ] {ai_face();};
void() zombie_attb2   =[ $attb2,    zombie_attb3   ] {ai_face();};
void() zombie_attb3   =[ $attb3,    zombie_attb4   ] {ai_face();};
void() zombie_attb4   =[ $attb4,    zombie_attb5   ] {ai_face();};
void() zombie_attb5   =[ $attb5,    zombie_attb6   ] {ai_face();};
void() zombie_attb6   =[ $attb6,    zombie_attb7   ] {ai_face();};
void() zombie_attb7   =[ $attb7,    zombie_attb8   ] {ai_face();};
void() zombie_attb8   =[ $attb8,    zombie_attb9   ] {ai_face();};
void() zombie_attb9   =[ $attb9,    zombie_attb10  ] {ai_face();};
void() zombie_attb10  =[ $attb10,   zombie_attb11  ] {ai_face();};
void() zombie_attb11  =[ $attb11,   zombie_attb12  ] {ai_face();};
void() zombie_attb12  =[ $attb12,   zombie_attb13  ] {ai_face();};
void() zombie_attb13  =[ $attb13,   zombie_attb14  ] {ai_face();};
void() zombie_attb14  =[ $attb13,   zombie_run1    ] {ai_face(); M_FireMeat('3.2 -4.8 25.4');};

void() zombie_attc1   =[ $attc1,    zombie_attc2   ] {ai_face();};
void() zombie_attc2   =[ $attc2,    zombie_attc3   ] {ai_face();};
void() zombie_attc3   =[ $attc3,    zombie_attc4   ] {ai_face();};
void() zombie_attc4   =[ $attc4,    zombie_attc5   ] {ai_face();};
void() zombie_attc5   =[ $attc5,    zombie_attc6   ] {ai_face();};
void() zombie_attc6   =[ $attc6,    zombie_attc7   ] {ai_face();};
void() zombie_attc7   =[ $attc7,    zombie_attc8   ] {ai_face();};
void() zombie_attc8   =[ $attc8,    zombie_attc9   ] {ai_face();};
void() zombie_attc9   =[ $attc9,    zombie_attc10  ] {ai_face();};
void() zombie_attc10  =[ $attc10,   zombie_attc11  ] {ai_face();};
void() zombie_attc11  =[ $attc11,   zombie_attc12  ] {ai_face();};
void() zombie_attc12  =[ $attc12,   zombie_run1    ] {ai_face(); M_FireMeat('17.5 13 20.2');};

void() zombie_missile =
{
    local   float   r;

    r = random();
    if (r < 0.3)
        zombie_atta1 ();
    else if (r < 0.6)
        zombie_attb1 ();
    else
        zombie_attc1 ();
};


//===========================================================================
//
// PAIN
//
//===========================================================================

void() zombie_paina1  =[ $paina1,   zombie_paina2   ] {sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() zombie_paina2  =[ $paina2,   zombie_paina3   ] {self.burn_ofs = '-4 0 12'; ai_forward(3);};
void() zombie_paina3  =[ $paina3,   zombie_paina4   ] {ai_forward(1);};
void() zombie_paina4  =[ $paina4,   zombie_paina5   ] {self.burn_ofs = '-4 0 14'; ai_back(1);};
void() zombie_paina5  =[ $paina5,   zombie_paina6   ] {self.burn_ofs = '-4 0 16'; ai_back(3);};
void() zombie_paina6  =[ $paina6,   zombie_paina7   ] {self.burn_ofs = '-2 0 16'; ai_back(1);};
void() zombie_paina7  =[ $paina7,   zombie_paina8   ] {self.burn_ofs = '0 0 16';};
void() zombie_paina8  =[ $paina8,   zombie_paina9   ] {};
void() zombie_paina9  =[ $paina9,   zombie_paina10  ] {};
void() zombie_paina10 =[ $paina10,  zombie_paina11  ] {};
void() zombie_paina11 =[ $paina11,  zombie_paina12  ] {};
void() zombie_paina12 =[ $paina12,  zombie_run1     ] {};

void() zombie_painb1  =[ $painb1,   zombie_painb2   ] {sound (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() zombie_painb2  =[ $painb2,   zombie_painb3   ] {self.burn_ofs = '0 0 12';ai_back(2);};
void() zombie_painb3  =[ $painb3,   zombie_painb4   ] {self.burn_ofs = '0 0 6';ai_back(8);};
void() zombie_painb4  =[ $painb4,   zombie_painb5   ] {self.burn_ofs = '0 0 0.1';ai_back(6);};
void() zombie_painb5  =[ $painb5,   zombie_painb6   ] {self.burn_ofs = '0 0 -6';ai_back(2);};
void() zombie_painb6  =[ $painb6,   zombie_painb7   ] {self.burn_ofs = '0 0 -8';};
void() zombie_painb7  =[ $painb7,   zombie_painb8   ] {};
void() zombie_painb8  =[ $painb8,   zombie_painb9   ] {};
void() zombie_painb9  =[ $painb9,   zombie_painb10  ] {sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);};
void() zombie_painb10 =[ $painb10,  zombie_painb11  ] {};
void() zombie_painb11 =[ $painb11,  zombie_painb12  ] {};
void() zombie_painb12 =[ $painb12,  zombie_painb13  ] {};
void() zombie_painb13 =[ $painb13,  zombie_painb14  ] {};
void() zombie_painb14 =[ $painb14,  zombie_painb15  ] {};
void() zombie_painb15 =[ $painb15,  zombie_painb16  ] {};
void() zombie_painb16 =[ $painb16,  zombie_painb17  ] {};
void() zombie_painb17 =[ $painb17,  zombie_painb18  ] {self.burn_ofs = '0 0 -6';};
void() zombie_painb18 =[ $painb18,  zombie_painb19  ] {self.burn_ofs = '0 0 -4';};
void() zombie_painb19 =[ $painb19,  zombie_painb20  ] {self.burn_ofs = '0 0 -2';};
void() zombie_painb20 =[ $painb20,  zombie_painb21  ] {self.burn_ofs = '0 0 0.1';};
void() zombie_painb21 =[ $painb21,  zombie_painb22  ] {self.burn_ofs = '0 0 2';};
void() zombie_painb22 =[ $painb22,  zombie_painb23  ] {self.burn_ofs = '0 0 4';};
void() zombie_painb23 =[ $painb23,  zombie_painb24  ] {self.burn_ofs = '0 0 6';};
void() zombie_painb24 =[ $painb24,  zombie_painb25  ] {self.burn_ofs = '0 0 8';};
void() zombie_painb25 =[ $painb25,  zombie_painb26  ] {self.burn_ofs = '0 0 10';ai_forward(1);};
void() zombie_painb26 =[ $painb26,  zombie_painb27  ] {self.burn_ofs = '0 0 12';};
void() zombie_painb27 =[ $painb27,  zombie_painb28  ] {self.burn_ofs = '0 0 14';};
void() zombie_painb28 =[ $painb28,  zombie_run1     ] {self.burn_ofs = '0 0 16';};

void() zombie_painc1  =[ $painc1,   zombie_painc2   ] {sound (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() zombie_painc2  =[ $painc2,   zombie_painc3   ] {self.burn_ofs = '0 0 12';};
void() zombie_painc3  =[ $painc3,   zombie_painc4   ] {self.burn_ofs = '0 0 6'; ai_back(3);};
void() zombie_painc4  =[ $painc4,   zombie_painc5   ] {self.burn_ofs = '0 0 2'; ai_back(1);};
void() zombie_painc5  =[ $painc5,   zombie_painc6   ] {};
void() zombie_painc6  =[ $painc6,   zombie_painc7   ] {};
void() zombie_painc7  =[ $painc7,   zombie_painc8   ] {};
void() zombie_painc8  =[ $painc8,   zombie_painc9   ] {};
void() zombie_painc9  =[ $painc9,   zombie_painc10  ] {};
void() zombie_painc10 =[ $painc10,  zombie_painc11  ] {};
void() zombie_painc11 =[ $painc11,  zombie_painc12  ] {self.burn_ofs = '0 0 6'; ai_forward(1);};
void() zombie_painc12 =[ $painc12,  zombie_painc13  ] {self.burn_ofs = '0 0 12'; ai_forward(1);};
void() zombie_painc13 =[ $painc13,  zombie_painc14  ] {self.burn_ofs = '0 0 14';};
void() zombie_painc14 =[ $painc14,  zombie_painc15  ] {self.burn_ofs = '0 0 15';};
void() zombie_painc15 =[ $painc15,  zombie_painc16  ] {self.burn_ofs = '0 0 16';};
void() zombie_painc16 =[ $painc16,  zombie_painc17  ] {};
void() zombie_painc17 =[ $painc17,  zombie_painc18  ] {};
void() zombie_painc18 =[ $painc18,  zombie_run1     ] {};

void() zombie_paind1  =[ $paind1,   zombie_paind2   ] {sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() zombie_paind2  =[ $paind2,   zombie_paind3   ] {};
void() zombie_paind3  =[ $paind3,   zombie_paind4   ] {};
void() zombie_paind4  =[ $paind4,   zombie_paind5   ] {};
void() zombie_paind5  =[ $paind5,   zombie_paind6   ] {};
void() zombie_paind6  =[ $paind6,   zombie_paind7   ] {};
void() zombie_paind7  =[ $paind7,   zombie_paind8   ] {};
void() zombie_paind8  =[ $paind8,   zombie_paind9   ] {};
void() zombie_paind9  =[ $paind9,   zombie_paind10  ] {ai_back(1);};
void() zombie_paind10 =[ $paind10,  zombie_paind11  ] {};
void() zombie_paind11 =[ $paind11,  zombie_paind12  ] {};
void() zombie_paind12 =[ $paind12,  zombie_paind13  ] {};
void() zombie_paind13 =[ $paind13,  zombie_run1     ] {};

void() zombie_paine1  =[ $paine1,   zombie_paine2   ] {self.burn_ofs = '0 0 14'; sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() zombie_paine2  =[ $paine2,   zombie_paine3   ] {self.burn_ofs = '0 0 12'; ai_back(8);};
void() zombie_paine3  =[ $paine3,   zombie_paine4   ] {self.burn_ofs = '0 0 10'; ai_back(5);};
void() zombie_paine4  =[ $paine4,   zombie_paine5   ] {self.burn_ofs = '0 0 8'; ai_back(3);};
void() zombie_paine5  =[ $paine5,   zombie_paine6   ] {self.burn_ofs = '0 0 6'; ai_back(1);};
void() zombie_paine6  =[ $paine6,   zombie_paine7   ] {self.burn_ofs = '0 0 4'; ai_back(2);};
void() zombie_paine7  =[ $paine7,   zombie_paine8   ] {self.burn_ofs = '0 0 1'; ai_back(1);};
void() zombie_paine8  =[ $paine8,   zombie_paine9   ] {self.burn_ofs = '0 0 -2'; ai_back(1);};
void() zombie_paine9  =[ $paine9,   zombie_paine10  ] {self.burn_ofs = '0 0 -4'; ai_back(2);};
void() zombie_paine10 =[ $paine10,  zombie_paine11  ] {self.burn_ofs = '0 0 -6'; sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM); self.solid = SOLID_NOT;};
void() zombie_paine11 =[ $paine11,  zombie_paine12  ] {self.burn_ofs = '0 0 -8'; self.nextthink = self.nextthink + 5;};
void() zombie_paine12 =[ $paine12,  zombie_paine13  ] {self.burn_ofs = '0 0 -8';
// see if ok to stand up
    sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
    self.solid = SOLID_SLIDEBOX;
// FIXME:  Setsize in case zombie was crushed by door or plat.
    if (!walkmove (0, 0))
    {
        self.think = zombie_paine11;
        self.solid = SOLID_NOT;
        return;
    }
};
void() zombie_paine13 =[ $paine13,  zombie_paine14  ] {};
void() zombie_paine14 =[ $paine14,  zombie_paine15  ] {};
void() zombie_paine15 =[ $paine15,  zombie_paine16  ] {};
void() zombie_paine16 =[ $paine16,  zombie_paine17  ] {};
void() zombie_paine17 =[ $paine17,  zombie_paine18  ] {};
void() zombie_paine18 =[ $paine18,  zombie_paine19  ] {self.burn_ofs = '0 0 -6';};
void() zombie_paine19 =[ $paine19,  zombie_paine20  ] {self.burn_ofs = '0 0 -4';};
void() zombie_paine20 =[ $paine20,  zombie_paine21  ] {self.burn_ofs = '0 0 -2';};
void() zombie_paine21 =[ $paine21,  zombie_paine22  ] {};
void() zombie_paine22 =[ $paine22,  zombie_paine23  ] {self.burn_ofs = '0 0 0.1';};
void() zombie_paine23 =[ $paine23,  zombie_paine24  ] {self.burn_ofs = '0 0 2';};
void() zombie_paine24 =[ $paine24,  zombie_paine25  ] {self.burn_ofs = '0 0 4';};
void() zombie_paine25 =[ $paine25,  zombie_paine26  ] {self.burn_ofs = '0 0 6';ai_forward(5);};
void() zombie_paine26 =[ $paine26,  zombie_paine27  ] {self.burn_ofs = '0 0 8';ai_forward(3);};
void() zombie_paine27 =[ $paine27,  zombie_paine28  ] {self.burn_ofs = '0 0 10';ai_forward(1);};
void() zombie_paine28 =[ $paine28,  zombie_paine29  ] {self.burn_ofs = '0 0 12';ai_back(1);};
void() zombie_paine29 =[ $paine29,  zombie_paine30  ] {self.burn_ofs = '0 0 14';};
void() zombie_paine30 =[ $paine30,  zombie_run1     ] {self.burn_ofs = '0 0 16';};

//=================
// zombie_pain
//
// Zombies can only be killed (gibbed) by doing 60 hit points of damage
// in a single frame (rockets, grenades, quad shotgun, quad nailgun).
//
// A hit of 25 points or more (super shotgun, quad nailgun) will always put
// it down to the ground.
//
// A hit of from 10 to 40 points in one frame will cause it to go down if it
// has been twice in two seconds, otherwise it goes into one of the four
// fast pain frames.
//
// A hit of less than 10 points of damage (winged by a shotgun) will be
// ignored.
//
// PM's Note:  Nightmare hack is gone.  Pain in Nightmare is handled on a
// case-by-case basis.  For the zombie, damage less than 25 will be ignored.
//
// FIXME:  If non-standard health, use the following:
//  > 40% health == knockdown
// >= 15% health == fast pain
//  < 15% health == ignore
//=================
void(entity attacker, float take) zombie_pain =
{
    if (take < 9)
        return;                // totally ignore

    if (self.inpain == 2)
        return;            // down on ground, so don't reset any counters

// go down immediately if a big enough hit
    if (take >= 25)
    {
        self.inpain = 2;
        zombie_paine1 ();
        return;
    }
    
// In Nightmare, totally ignore anything that can't drop zombie in one hit.
    if (skill >= 3)
        return;

    if (self.inpain)
    {
// if hit again in next gre seconds while not in pain frames, definately drop
        self.pain_finished = time + 3;
        return;            // currently going through an animation, don't change
    }
    
    if (self.pain_finished > time)
    {
// hit again, so drop down
        self.inpain = 2;
        zombie_paine1 ();
        return;
    }

// go into one of the fast pain animations    
    local   float   r;

    self.burn_ofs = '0 0 16';    // FIXME:  Do I really want this here?
    self.inpain = 1;

    r = random();
    if (r < 0.25)
        zombie_paina1 ();
    else if (r < 0.5)
        zombie_painb1 ();
    else if (r < 0.75)
        zombie_painc1 ();
    else
        zombie_paind1 ();
    attacker = attacker;    // FrikQcc warning squelch!
};

// Pain function for 'monster_mummy' from DoE.
void() mummy_pain =
{
    local   float   r;

    if (self.pain_finished > time)
        return;
    if (skill >= 3)
        return;

    r = random();
    if (r > 0.24)
        return;

    self.pain_finished = time + 2.5;

    if (r < 0.06)
        zombie_paina1 ();
    else if (r < 0.12)
        zombie_painb1 ();
    else if (r < 0.18)
        zombie_painc1 ();
    else
        zombie_paind1 ();
};


//===========================================================================
//
// DEATH
//
//===========================================================================

// PM:  Burning death.
void() zombie_burn1   =[ $paind1,  zombie_burn2   ] {sound (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() zombie_burn2   =[ $paind2,  zombie_burn3   ] {};
void() zombie_burn3   =[ $paind3,  zombie_burn4   ] {};
void() zombie_burn4   =[ $paind4,  zombie_burn5   ] {};
void() zombie_burn5   =[ $paind5,  zombie_burn6   ] {};
void() zombie_burn6   =[ $paind6,  zombie_burn7   ] {};
void() zombie_burn7   =[ $paind7,  zombie_burn8   ] {};
void() zombie_burn8   =[ $paind8,  zombie_burn9   ] {};
void() zombie_burn9   =[ $paind9,  zombie_burn10  ] {ai_back(1);};
void() zombie_burn10  =[ $paind10, zombie_burn11  ] {};
void() zombie_burn11  =[ $paind11, zombie_burn12  ] {};
void() zombie_burn12  =[ $paind12, zombie_burn13  ] {};
void() zombie_burn13  =[ $paind13, zombie_burnout ] {};

void() zombie_burnb1  =[ $run1,    zombie_burnb2  ] {sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);ai_charge(1);};
void() zombie_burnb2  =[ $run2,    zombie_burnb3  ] {ai_charge(1);};
void() zombie_burnb3  =[ $run3,    zombie_burnb4  ] {ai_face();};
void() zombie_burnb4  =[ $run4,    zombie_burnb5  ] {ai_charge(1);};
void() zombie_burnb5  =[ $run5,    zombie_burnb6  ] {ai_charge(2);};
void() zombie_burnb6  =[ $run6,    zombie_burnb7  ] {ai_charge(3);};
void() zombie_burnb7  =[ $run7,    zombie_burnb8  ] {ai_charge(4);};
void() zombie_burnb8  =[ $run8,    zombie_burnb9  ] {ai_charge(4);};
void() zombie_burnb9  =[ $run9,    zombie_burnb10 ] {ai_charge(2);};
void() zombie_burnb10 =[ $run10,   zombie_burnb11 ] {ai_face();};
void() zombie_burnb11 =[ $run11,   zombie_burnb12 ] {ai_face();};
void() zombie_burnb12 =[ $run12,   zombie_burnb13 ] {ai_face();};
void() zombie_burnb13 =[ $run13,   zombie_burnb14 ] {ai_charge(2);};
void() zombie_burnb14 =[ $run14,   zombie_burnb15 ] {ai_charge(4);};
void() zombie_burnb15 =[ $run15,   zombie_burnb16 ] {ai_charge(6);};
void() zombie_burnb16 =[ $run16,   zombie_burnb17 ] {ai_charge(7);};
void() zombie_burnb17 =[ $run17,   zombie_burnb18 ] {ai_charge(3);};
void() zombie_burnb18 =[ $run18,   zombie_burnout ] {ai_charge(8);};

// PM:  Burning death for crucified zombies.
void() zombie_crburn1 =[ $cruc_1,  zombie_crburn2 ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_crburn2 =[ $cruc_2,  zombie_crburn3 ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_crburn3 =[ $cruc_3,  zombie_crburn4 ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_crburn4 =[ $cruc_4,  zombie_crburn5 ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_crburn5 =[ $cruc_5,  zombie_crburn6 ] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_crburn6 =[ $cruc_6,  zombie_crburn1 ]
{
    if (self.cnt <= 0)
        {self.think = zombie_burnout;  return;}
    self.cnt = self.cnt - 1;
    self.nextthink = time + 0.1 + random()*0.1;
};

// Update 3/31/09:  Decapitation.  Assume Romero (not Russo) zombies.
// Since zombies are cadavers with clotted blood, don't spray blood.
void() zombie_decap1  =[ $decap1,  zombie_decap2  ] {};
void() zombie_decap2  =[ $decap2,  zombie_decap3  ] {ai_back(8);};
void() zombie_decap3  =[ $decap3,  zombie_decap4  ] {ai_back(5);};
void() zombie_decap4  =[ $decap4,  zombie_decap5  ] {ai_back(3);};
void() zombie_decap5  =[ $decap5,  zombie_decap6  ] {ai_back(1);};
void() zombie_decap6  =[ $decap6,  zombie_decap7  ] {ai_back(2);};
void() zombie_decap7  =[ $decap7,  zombie_decap8  ] {ai_back(1);};
void() zombie_decap8  =[ $decap8,  zombie_decap9  ] {ai_back(1);};
void() zombie_decap9  =[ $decap9,  zombie_decap10 ] {ai_back(2);};
void() zombie_decap10 =[ $decap10, zombie_decap11 ] {sound (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM); self.solid = SOLID_NOT;};
void() zombie_decap11 =[ $decap11, decap_end      ] {};

// Update 6/14/09:  Removed no gib death scene.  Replaced by decapitation.
void() zombie_decap =
{
    monster_decap ('0 0 22', zombie_decap1);
    sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NORM);
};

// gib_health isn't used in this function, but is in others.
float(float dm) zombie_gib =
{
    if (self.inpain)
    {   // Don't auto-gib if undergoing a special death.
        if (fabs(dm) < self.max_health)
        {   // Don't gib if the damage isn't enough to kill it in one hit.
            self.health = 0;
            return FALSE;
        }
        dm = dm + self.max_health;  // Emulate proper damage for gib velocity.
    }
    self.deadflag = DEAD_DEAD;  // fire.qc: So crucified stops burning.
// Standard gibbing procedure.
    sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
    ThrowGib ("progs/gib1.mdl", dm);
    ThrowGib ("progs/gib2.mdl", dm);
    ThrowGib ("progs/gib3.mdl", dm);
    ThrowHead ("progs/h_zombie.mdl", dm);   // Sets deadflag to DEAD_DEAD.
    return TRUE;
};

void() zombie_burnout = {self.inpain = 0; zombie_gib (0);};
//------------------------------------------------------------------------//

// Death for crucified zombies.
void() zombie_crdie =
{
// Entities with MOVETYPE_NONE do not have their deadflag set
// by 'Killed', so do that here.
    if (self.deadflag)
        return;     // Already killed.
    self.deadflag = DEAD_DYING;
//- - - - - - -
// PM:  Uncomment if you want target firing for killing crucified.
//    activator = damage_attacker;
//    SUB_UseTargets ();
//- - - - - - -

    if (Shattered ())
        return;
// Check for flaming death.
    if (self.health >= self.gib_health)
    {
        if (self.deathtype == "fire")   // No need to check for lava too.
        {
            self.cnt = 2;   // For anim loop.
            self.inpain = 1;
            self.health = 0;
            self.burn_ofs = '2 0 12';
            Burn_Killer ();
            sound (self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC);
            zombie_crburn1 ();
            return;
        }
    }

// Normal gib-tastic death.
    self.inpain = 0;
    zombie_gib (self.health);
};

float() zombie_death_by_fire =
{
    if ((self.deathtype == "fire") || (self.deathtype == "lava"))
    {
        if (self.solid == SOLID_NOT)
        if (self.inpain == 2)
        {
            // Lying on the ground.  Just let it stay there.
            self.burn_ofs = '0 0 -8';   // 2 0 -8
            Burn_Killer ();
            self.nextthink = time + 1 + random() * 2;   // 1-3 secs.
            self.think = zombie_burnout;
            return TRUE;
        }

        self.inpain = 1;
        self.health = 0;

        self.burn_ofs = '0 0 16';   // 2 0 8
        Burn_Killer ();
        if (random() < 0.5)
            zombie_burn1 ();
        else
            zombie_burnb1 ();
        return TRUE;
    }
    return FALSE;
};

// Death for normal zombies.
void() zombie_die =
{
    if (Shattered ())
        return;
//----------------
// DISABLED -- Holy weapons were scrapped.
//    if (Dispelled ())
//    {   // Explode when slain by a holy weapon.
//        Rocket_Explosion2 (self.origin, 64, 16);    // Assumes red blood.
//        if (self.health > -50)
//            self.health = -50;
//        self.inpain = 0;
//        zombie_gib (self.health);
//        return;
//    }
//----------------
    if (Decapitated ())
    {
        zombie_decap ();
        return;
    }
// PM:  Check for death by special means.
    if (self.health >= self.gib_health)
    {
        if (zombie_death_by_fire ())
            return;
        if (self.deathtype == "impulse")
        {   // Decapitate zombies if killed by the genocide impulse.
            if (self.solid != SOLID_NOT)
            {
                zombie_decap ();
                return;
            }
        }
        // Proceed to normal death below.
    }
// PM:  Normal death.
    self.inpain = 0;
    zombie_gib (self.health);
};

//- - - - - - - - -
// DoE Mummy kill funcs.
float(float dm) mummy_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_zombie.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

// Death for mummies.
void() mummy_die =
{
    if (Shattered ())
        return;
    if (!Decapitated ())
    {
        if (mummy_gib (self.health))
            return;     // Gibbed!
        if (zombie_death_by_fire ())
            return;     // Burn now, then gib.
    }
// Knock off the head!
    zombie_decap ();
};


//===========================================================================
//
// CUSTOM ADDITIONS
//
//===========================================================================

// Hipnotic Additions - - - -
// Modified for Drake.
void() zombie_wake  =
{
    self.th_stand   = zombie_stand1;
    self.th_walk    = zombie_walk1;
    self.th_run     = zombie_run;
    if (self.classname == "monster_mummy")
        self.th_pain    = mummy_pain;
    else
        self.th_pain    = zombie_pain;
    zombie_paine12 ();      // Wake up if possible.
};

void() zombie_lay   =[ $paine11, zombie_lay ]
{
// Hipnotic's version of sleeping zombies.
// Update 6/4/09:  If targeted, wake up only when triggered.
    if (FindTarget ())
        zombie_wake ();
};

void() zombie_sleep_use =
{
    self.th_stand   =
    self.th_walk    =
    self.think      = zombie_lay;
    self.nextthink  = time + 0.1;
    self.use        = monster_use;
    monster_use ();
};
void() zombie_sleep =[ $paine11, SUB_Null   ] {self.use = zombie_sleep_use;};
//- - - - - - - - - - - - - -

void(float hello) zombie_sight =
{
// Limited vocabulary here.
    sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);
    hello = hello;      // FrikQcc warning squelch!
};

void() zombie_cache =
{
    precache_model ("progs/zombie.mdl");
    precache_model ("progs/h_zombie.mdl");
    precache_model ("progs/zom_gib.mdl");

    precache_sound ("zombie/z_idle.wav");
    precache_sound ("zombie/z_idle1.wav");
    precache_sound ("zombie/z_shot1.wav");
    precache_sound ("zombie/z_gib.wav");
    precache_sound ("zombie/z_pain.wav");
    precache_sound ("zombie/z_pain1.wav");
    precache_sound ("zombie/z_fall.wav");
    precache_sound ("zombie/z_miss.wav");
    precache_sound ("zombie/z_hit.wav");
    precache_sound ("zombie/idle_w2.wav");
};

// Reduced fat for nsoe2.
void() zombie_cruc_cache =
{
    precache_model ("progs/zombie.mdl");
    precache_model ("progs/h_zombie.mdl");

    precache_sound ("zombie/z_gib.wav");
    precache_sound ("zombie/idle_w2.wav");
};

void() zombie_sleep_func =
{
    self.burn_ofs   = '0 0 -8';
    self.inpain     = 2;
    self.solid      = SOLID_NOT;
    self.th_stand   = self.th_walk  = zombie_lay;
    self.th_run     = self.th_pain  = zombie_wake;
    // Update 6/4/09:  If targeted, wake up only when used.
    if (self.targetname)
        if (self.spawnflags & SPAWNx_DELAY == 0)
            self.th_stand   = self.th_walk  = zombie_sleep;
};

void() zombie_form =
{
    monster_form ("progs/zombie.mdl", '-16 -16 -24', '16 16 40', 60, -35);
    self.mdl_head   = "progs/h_zombie.mdl";
};

void() zombie_stats =
{
    zombie_form ();
    self.inpain     = 0;
    self.mass       = MASS_LIGHT;

    self.th_stand   = zombie_stand1;
    self.th_walk    = zombie_walk1;
    self.th_run     = zombie_run;       // PM:  Changed.
    self.th_missile = zombie_missile;
    self.th_pain    = zombie_pain;
    self.th_die     = zombie_die;
    //- - - - - - - -
    self.th_sight   = zombie_sight;
    self.th_gib     = zombie_gib;

    Regen_Set (self, 0.5);      // Let zombie recover from scar damage.
                                //  60 health in 30 seconds.
    self.bloodtype  = BLOOD_RED;    // Here in case of crucified.
    self.family     = FAM_UNDEAD;
    // Ignore non-scar damage unless 1-hit kill.
    self.xfl        = XFL_ZOMBIE;
};

// When respawning zombies, call this to avoid spawnflag mess!
void() monster_zombie_respawn =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self);  return;}
        zombie_cache ();
    }

    zombie_stats ();
    self.th_spawn   = monster_zombie_respawn;

    monster_start ();
};

//============
// QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified Ambush Laying Dead_Cruc
//
// If crucified, stick the bounding box 12 pixels back into a wall to look
// right.
//============
void() monster_zombie =
{
//- - - - - - - - -
// PM:  Let's fix the crucified mess here and now so spawnflag 2 may be
// used by other monsters without forcing them into ambush mode.
    local   float   crucified, limp, sleep;

//    if (world.model == "maps/zerend.bsp")   // Zerstorer
//        crucified = self.spawnflags & 9;
//    else
        crucified = self.spawnflags & 1;    // Disabled sf8 for now.
    limp = self.spawnflags & 8;
    sleep = self.spawnflags & 4;
    self.spawnflags = self.spawnflags - crucified;
    if (self.spawnflags & 2)
    {   // Zombie sf2 is ambush, which is sf1 for other monsters.
        self.spawnflags = (self.spawnflags - 2) | 1;
// DISABLED -- No sleeping if standard.
//        if (self.targetname)
//            sleep = TRUE;
    }
//- - - - - - - - -
    if (!self.spawned)
    {
        if (noenemies)
        {   // Leave crucified zombies in -- they add to ambience.
            // Remove all others.
            if (crucified)
            {
                precache_model ("progs/zombie.mdl");
                zombie_form ();
                self.frame = $cruc_1;
                makestatic (self);
            }
            else
                remove (self);
            return;
        }
        if (crucified)
            zombie_cruc_cache ();
        else
            zombie_cache ();
    }
    else
    {   // Created via summoning.  Remove crucified and other problem sf.
        crucified = 0;
    }

    zombie_stats ();

    if (self.spawnflags & SPAWNx_DELAY)
    {   // sf64 takes priority over crucified or other spawnflags that
        // lock the zombie down.  Therefore, remove lockdown flags.
        crucified = 0;
    }

    if (crucified)
    {
        self.th_stand   = self.th_walk  = self.th_run   = zombie_cruc1;
        self.th_pain    = SUB_Null;
        self.th_die     = zombie_crdie;
        self.takedamage = DAMAGE_YES;
        self.movetype   = MOVETYPE_NONE;
        if (limp)
        {   self.th_stand   = self.th_walk  = self.th_run   = SUB_Null;
            self.frame      = $cruc_1;
        }
        else
            zombie_cruc1 ();
        return;
    }
    // Hipnotic additions, modified.
    if (sleep)
    {
        zombie_sleep_func ();
        // Update 10/11/09:  Permanent sleeping zombie
        if (limp)
        {   // It's just decor.
            self.th_stand   = self.th_walk  = self.th_run   = SUB_Null;
            self.th_pain    = SUB_Null;
            self.takedamage = DAMAGE_YES;
            self.movetype   = MOVETYPE_STEP;
            self.frame      = $paine11;
//            droptofloor ();
            return;
        }
    }
    self.th_spawn   = monster_zombie_respawn;

    monster_start ();
};

//============
// --> QUAKED monster_mummy (1 0 0) (-16 -16 -24) (16 16 32) Ambush Lying Stronger
//============
void() monster_mummy =
{
    local   float   hp;

    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        zombie_cache ();
    }

    self.skin = 1;
    if (self.spawnflags & 4)
        hp = 1000;
    else
        hp = 500;
    monster_form ("progs/zombie.mdl", VEC_HULL_MIN, VEC_HULL_MAX, hp, -35);
    self.mdl_head   = "progs/h_zombie.mdl";
    self.mass       = MASS_LIGHT;

    self.th_stand   = zombie_stand1;
    self.th_walk    = zombie_walk1;
    self.th_run     = zombie_run;       // PM:  Changed.
    self.th_missile = zombie_missile;
    self.th_pain    = mummy_pain;
    self.th_die     = mummy_die;
    //- - - - - - - -
    self.th_sight   = zombie_sight;
    self.th_gib     = zombie_gib;
    self.th_spawn   = monster_mummy;

    if (!respawning)
        if (self.spawnflags & 2)
            zombie_sleep_func ();

    self.bloodtype  = BLOOD_RED;    // Here in case of crucified.
    self.family     = FAM_UNDEAD;

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
