/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base        
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8
$frame decap9 decap10 decap11 decap12 decap13 decap14

$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6 decapb7 decapb8
$frame decapb9 decapb10 decapb11

// Modified Mega Enforcer only scenes.
$frame attackp1 attackp2 attackp3 attackp4 attackp5 attackp6 attackp7

$frame fieldon1 fieldon2 fieldon3 fieldon4 fieldon5 fieldon6 fieldon7
//- - - - - - - - - - - - - - - - - - -


// Moved Laser code
//----------------
void(float ox) enforcer_fire_II =
{
    local   vector  p1, p2, err;
    local   entity  targ;

    if (cranked)
        targ = self.enemy;
    else
        targ = world;
    err_x = ox;  err_y = 0;  err_z = 1;
    makevectors (self.angles);
//    if ((self.war & WARx_USES_SHELLS) || (self.war == WAR_RAILGUN))
    if (self.war & WARx_USES_SHELLS)
    {
    // fire somewhat behind the player, so a dodging player is harder to hit
    // PM:  Enforcers track a bit better than grunts.
        p1 = self.origin;
        p2 = self.enemy.origin - self.enemy.velocity*0.1;
    }
    else
    {
        p2 = (v_forward*12) + (v_right*8.5) + (v_up*16);
        p1 = self.origin + p2;
        if (self.war & WARx_USES_ROCKETS)
            p2 = self.enemy.origin;
        else
            p2 = self.enemy.origin + p2;
        if (self.classname == "monster_ultra")
            if (!(self.war & WARx_AI_RAPID_FIRE))
                targ = self.enemy;
    }
    M_Attack (self.war, p1, p2, targ, err, TRUE);
};

void() enforcer_fire = {enforcer_fire_II (0);};
//----------------
void() enf_idle_sfx =
{
// PM:  This is not the way I want to do this, but it is the easiest.
    if (self.classname == "monster_rebel")
        return;     // No sound.

// PM:  Proceed as usual.
    if (self.classname == "monster_gunner")
        sound (self, CHAN_VOICE, "gunner/idle.wav", 1, ATTN_IDLE);
    else if (self.classname == "monster_me")
        sound (self, CHAN_VOICE, "me/meidle.wav", 1, ATTN_IDLE);
/* DISABLED -- Sounds unavailable atm.
    else if (self.classname == "monster_commando")
    {   local   float   r;

        r = random();

        if (r < 0.33)
            sound (self, CHAN_VOICE, "commando/idle1.wav", 1, ATTN_IDLE);
        else if (r < 0.66)
            sound (self, CHAN_VOICE, "commando/idle2.wav", 1, ATTN_IDLE);
        else
            sound (self, CHAN_VOICE, "commando/idle3.wav", 1, ATTN_IDLE);
    }
*/
    else
        sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
};
//----------------

//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() enf_stand1  =[ $stand1, enf_stand2 ] {ai_stand();};
void() enf_stand2  =[ $stand2, enf_stand3 ] {ai_stand();};
void() enf_stand3  =[ $stand3, enf_stand4 ] {ai_stand();};
void() enf_stand4  =[ $stand4, enf_stand5 ] {ai_stand();};
void() enf_stand5  =[ $stand5, enf_stand6 ] {ai_stand();};
void() enf_stand6  =[ $stand6, enf_stand7 ] {ai_stand();};
void() enf_stand7  =[ $stand7, enf_stand1 ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() enf_walk1  =[ $walk1,  enf_walk2  ] {
if (random() < 0.2)
    enf_idle_sfx ();
M_Step();ai_walk(2);};
void() enf_walk2  =[ $walk2,  enf_walk3  ] {ai_walk(4);};
void() enf_walk3  =[ $walk3,  enf_walk4  ] {ai_walk(4);};
void() enf_walk4  =[ $walk4,  enf_walk5  ] {ai_walk(3);};
void() enf_walk5  =[ $walk5,  enf_walk6  ] {ai_walk(1);};
void() enf_walk6  =[ $walk6,  enf_walk7  ] {ai_walk(2);};
void() enf_walk7  =[ $walk7,  enf_walk8  ] {ai_walk(2);};
void() enf_walk8  =[ $walk8,  enf_walk9  ] {ai_walk(1);};
void() enf_walk9  =[ $walk9,  enf_walk10 ] {M_Step();ai_walk(2);};
void() enf_walk10 =[ $walk10, enf_walk11 ] {ai_walk(4);};
void() enf_walk11 =[ $walk11, enf_walk12 ] {ai_walk(4);};
void() enf_walk12 =[ $walk12, enf_walk13 ] {ai_walk(1);};
void() enf_walk13 =[ $walk13, enf_walk14 ] {ai_walk(2);};
void() enf_walk14 =[ $walk14, enf_walk15 ] {ai_walk(3);};
void() enf_walk15 =[ $walk15, enf_walk16 ] {ai_walk(4);};
void() enf_walk16 =[ $walk16, enf_walk1  ] {ai_walk(2);};

// RUN - - - - - - - - - - - - - - - - -
void() enf_run1 =[ $run1, enf_run2 ] {
if (random() < 0.2)
    enf_idle_sfx ();
ai_run(18);};
void() enf_run2 =[ $run2, enf_run3 ] {ai_run(14);};
void() enf_run3 =[ $run3, enf_run4 ] {M_Step();ai_run(7);};
void() enf_run4 =[ $run4, enf_run5 ] {ai_run(12);};
void() enf_run5 =[ $run5, enf_run6 ] {ai_run(14);};
void() enf_run6 =[ $run6, enf_run7 ] {ai_run(14);};
void() enf_run7 =[ $run7, enf_run8 ] {M_Step();ai_run(7);};
void() enf_run8 =[ $run8, enf_run1 ] {ai_run(11);};

// ATTACK - - - - - - - - - - - - - - -
void() enf_atkx;
void() enf_atk13;

// Standard attack.
void() enf_atk1  =[ $attack1,  enf_atk2  ] {ai_face();};
void() enf_atk2  =[ $attack2,  enf_atk3  ] {ai_face();};
void() enf_atk3  =[ $attack3,  enf_atk4  ] {ai_face();};
void() enf_atk4  =[ $attack4,  enf_atk5  ] {ai_face();};
void() enf_atk5  =[ $attack5,  enf_atkx  ] {ai_face();};
void() enf_atk6  =[ $attack6,  enf_atk7  ] {enforcer_fire();};
void() enf_atk7  =[ $attack7,  enf_atk8  ] {ai_face();};
void() enf_atk8  =[ $attack8,  enf_atk9  ] {ai_face();
    if (self.war != WAR_BLASTER)    // Only blasters shoot twice.
        if (self.war != WAR_PLASMA_GUN)     // Update:  Plasma too.
            self.think = enf_atk13;
};
void() enf_atk9  =[ $attack5,  enf_atk10 ] {ai_face();};
void() enf_atk10 =[ $attack6,  enf_atk11 ] {enforcer_fire();};
void() enf_atk11 =[ $attack7,  enf_atk12 ] {ai_face();};
void() enf_atk12 =[ $attack8,  enf_atk13 ] {ai_face();};
void() enf_atk13 =[ $attack9,  enf_atk14 ] {ai_face();};
void() enf_atk14 =[ $attack10, enf_run1  ] {ai_face(); SUB_CheckRefire (enf_atk1);};

// Rapid-fire attack
void() enf_ratk1 =[ $attack6,  enf_ratk2  ] {ai_face(); enforcer_fire_II(10);};
void() enf_ratk2 =[ $attack10, enf_ratk3  ] {ai_face(); enforcer_fire_II(5);};
void() enf_ratk3 =[ $attack6,  enf_ratk4  ] {ai_face(); enforcer_fire_II(0);};
void() enf_ratk4 =[ $attack10, enf_ratk5  ] {ai_face(); enforcer_fire_II(-5);};
void() enf_ratk5 =[ $attack6,  enf_ratk6  ] {ai_face(); enforcer_fire_II(-10);};
void() enf_ratk6 =[ $attack10, enf_atk14  ] {ai_face(); enforcer_fire_II(-15);};

// Thunderbolt attack
void() enf_latk1 =[ $attack5,  enf_latk2  ] {ai_face(); enforcer_fire();};
void() enf_latk2 =[ $attack10, enf_latk3  ] {ai_face(); enforcer_fire();};
void() enf_latk3 =[ $attack5,  enf_latk4  ] {ai_face(); enforcer_fire();};
void() enf_latk4 =[ $attack10, enf_atk14  ] {ai_face(); enforcer_fire();};

// Chain Lightning attack
void() enf_clatk =[ $attack5,  enf_atk14  ] {ai_face(); enforcer_fire();};

void() enf_atkx =
{
    if ((!self.war && (self.ammo_shells < 1)) || self.punked)
        enf_run1();     // Abort attack!
    else if (self.war & (WAR_THUNDERBOLT|WAR_CHAIN_LIGHTNING))
        {enf_latk1(); M_Lstart();}
    else if (self.war & WARx_AI_RAPID_FIRE)
        enf_ratk1();
    else
        enf_atk6();
};
void() enf_attack =
{
    M_SelectGun();
    if (self.war)
    {
// DISABLED -- No sounds yet.
//        if (self.classname == "monster_commando")
//            if ((self.war == WAR_SIDEWINDER) || (self.war == WAR_CRUISE_MISSILE))
//                sound (self, CHAN_VOICE, "commando/target.wav", 1, ATTN_NORM);
        enf_atk1();
    }
};

// PAIN - - - - - - - - - - - - - - - -
void() enf_paina1  =[ $paina1,  enf_paina2  ] {};
void() enf_paina2  =[ $paina2,  enf_paina3  ] {};
void() enf_paina3  =[ $paina3,  enf_paina4  ] {};
void() enf_paina4  =[ $paina4,  enf_run1    ] {};

void() enf_painb1  =[ $painb1,  enf_painb2  ] {};
void() enf_painb2  =[ $painb2,  enf_painb3  ] {};
void() enf_painb3  =[ $painb3,  enf_painb4  ] {};
void() enf_painb4  =[ $painb4,  enf_run1    ] {};

void() enf_painc1  =[ $painc1,  enf_painc2  ] {};
void() enf_painc2  =[ $painc2,  enf_painc3  ] {};
void() enf_painc3  =[ $painc3,  enf_painc4  ] {};
void() enf_painc4  =[ $painc4,  enf_painc5  ] {};
void() enf_painc5  =[ $painc5,  enf_painc6  ] {};
void() enf_painc6  =[ $painc6,  enf_painc7  ] {};
void() enf_painc7  =[ $painc7,  enf_painc8  ] {};
void() enf_painc8  =[ $painc8,  enf_run1    ] {};

void() enf_paind1  =[ $paind1,  enf_paind2  ] {};
void() enf_paind2  =[ $paind2,  enf_paind3  ] {};
void() enf_paind3  =[ $paind3,  enf_paind4  ] {};
void() enf_paind4  =[ $paind4,  enf_paind5  ] {ai_forward(2);};
void() enf_paind5  =[ $paind5,  enf_paind6  ] {ai_forward(1);};
void() enf_paind6  =[ $paind6,  enf_paind7  ] {};
void() enf_paind7  =[ $paind7,  enf_paind8  ] {};
void() enf_paind8  =[ $paind8,  enf_paind9  ] {};
void() enf_paind9  =[ $paind9,  enf_paind10 ] {};
void() enf_paind10 =[ $paind10, enf_paind11 ] {};
void() enf_paind11 =[ $paind11, enf_paind12 ] {ai_forward(1);};
void() enf_paind12 =[ $paind12, enf_paind13 ] {ai_forward(1);};
void() enf_paind13 =[ $paind13, enf_paind14 ] {ai_forward(1);};
void() enf_paind14 =[ $paind14, enf_paind15 ] {};
void() enf_paind15 =[ $paind15, enf_paind16 ] {};
void() enf_paind16 =[ $paind16, enf_paind17 ] {ai_back(1);};
void() enf_paind17 =[ $paind17, enf_paind18 ] {ai_back(1);};
void() enf_paind18 =[ $paind18, enf_paind19 ] {};
void() enf_paind19 =[ $paind19, enf_run1    ] {};

void(entity attacker, float damage) enf_pain =
{
    if (self.pain_finished > time)
        return;

    local   float   r;
    r = random ();
    if (skill >= 3)
        r = r * 0.4;
    
    if (r < 0.5)
        sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);

    if (SUB_IgnorePain ())
    {
        self.pain_finished = time + 0.5;
        return;         // No pain anims in Nightmare.
    }

    if (r < 0.2)
    {
        self.pain_finished = time + 1;
        enf_paina1 ();
    }
    else if (r < 0.4)
    {
        self.pain_finished = time + 1;
        enf_painb1 ();
    }
    else if (r < 0.7)
    {
        self.pain_finished = time + 1;
        enf_painc1 ();
    }
    else
    {
        self.pain_finished = time + 2;
        enf_paind1 ();
    }
    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

//============================================================================


// DEATH - - - - - - - - - - - - - - - -
void() enf_decap1   =[ $decap1,   enf_decap2   ] {blood_spray('-18 1 20', 1);};
void() enf_decap2   =[ $decap2,   enf_decap3   ] {blood_spray('-18 1 16', 2);};
void() enf_decap3   =[ $decap3,   enf_decap4   ] {blood_spray('-17 2 11', 1);monster_drop();};
void() enf_decap4   =[ $decap4,   enf_decap5   ] {ai_forward(14);};
void() enf_decap5   =[ $decap5,   enf_decap6   ] {ai_forward(2);};
void() enf_decap6   =[ $decap6,   enf_decap7   ] {};
void() enf_decap7   =[ $decap7,   enf_decap8   ] {blood_spray('-8 0 15', -1);};
void() enf_decap8   =[ $decap8,   enf_decap9   ] {};
void() enf_decap9   =[ $decap9,   enf_decap10  ] {ai_forward(3);};
void() enf_decap10  =[ $decap10,  enf_decap11  ] {ai_forward(5);};
void() enf_decap11  =[ $decap11,  enf_decap12  ] {ai_forward(5);};
void() enf_decap12  =[ $decap12,  enf_decap13  ] {ai_forward(5);};
void() enf_decap13  =[ $decap13,  enf_decap14  ] {};
void() enf_decap14  =[ $decap14,  decap_end    ] {};

void() enf_decapb1  =[ $decapb1,  enf_decapb2  ] {blood_spray('-11 0 31', 1);};
void() enf_decapb2  =[ $decapb2,  enf_decapb3  ] {blood_spray('-16 0 29', 2);};
void() enf_decapb3  =[ $decapb3,  enf_decapb4  ] {monster_drop(); blood_spray('-21 0 23', 1);};
void() enf_decapb4  =[ $decapb4,  enf_decapb5  ] {blood_spray('-25 0 12', 1);};
void() enf_decapb5  =[ $decapb5,  enf_decapb6  ] {};
void() enf_decapb6  =[ $decapb6,  enf_decapb7  ] {};
void() enf_decapb7  =[ $decapb7,  enf_decapb8  ] {};
void() enf_decapb8  =[ $decapb8,  enf_decapb9  ] {};
void() enf_decapb9  =[ $decapb9,  enf_decapb10 ] {};
void() enf_decapb10 =[ $decapb10, enf_decapb11 ] {};
void() enf_decapb11 =[ $decapb11, decap_end    ] {};

void() enf_die1   =[ $death1,   enf_die2    ] {};
void() enf_die2   =[ $death2,   enf_die3    ] {};
void() enf_die3   =[ $death3,   enf_die4    ] {monster_drop();};
void() enf_die4   =[ $death4,   enf_die5    ] {ai_forward(14);};
void() enf_die5   =[ $death5,   enf_die6    ] {ai_forward(2);};
void() enf_die6   =[ $death6,   enf_die7    ] {};
void() enf_die7   =[ $death7,   enf_die8    ] {};
void() enf_die8   =[ $death8,   enf_die9    ] {};
void() enf_die9   =[ $death9,   enf_die10   ] {ai_forward(3);};
void() enf_die10  =[ $death10,  enf_die11   ] {ai_forward(5);};
void() enf_die11  =[ $death11,  enf_die12   ] {ai_forward(5);};
void() enf_die12  =[ $death12,  enf_die13   ] {ai_forward(5);};
void() enf_die13  =[ $death13,  enf_die14   ] {};
void() enf_die14  =[ $death14,  monster_end ] {};

void() enf_fdie1  =[ $fdeath1,  enf_fdie2   ] {};
void() enf_fdie2  =[ $fdeath2,  enf_fdie3   ] {};
void() enf_fdie3  =[ $fdeath3,  enf_fdie4   ] {monster_drop();};
void() enf_fdie4  =[ $fdeath4,  enf_fdie5   ] {};
void() enf_fdie5  =[ $fdeath5,  enf_fdie6   ] {};
void() enf_fdie6  =[ $fdeath6,  enf_fdie7   ] {};
void() enf_fdie7  =[ $fdeath7,  enf_fdie8   ] {};
void() enf_fdie8  =[ $fdeath8,  enf_fdie9   ] {};
void() enf_fdie9  =[ $fdeath9,  enf_fdie10  ] {};
void() enf_fdie10 =[ $fdeath10, enf_fdie11  ] {};
void() enf_fdie11 =[ $fdeath11, monster_end ] {};


float(float dm) enf_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_mega.mdl", dm);
        return TRUE;
    }
    return FALSE;
};
void() enf_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        if (random() < 0.5)
            monster_decap ('-18 1 20', enf_decap1);
        else
            monster_decap ('-11 0 31', enf_decapb1);
        return;
    }
// check for gib
    if (enf_gib (self.health))
        return;

// regular death
// FIXME:  Ultra here?
/* DISABLED -- No ultra enfs yet.
    if (self.classname == "monster_ultra")
    {
        local   float   r;

        r = random();
        if (r < 0.333)
            sound (self, CHAN_VOICE, "ue/ue_die1.wav", 1, ATTN_NORM);
        else if (r < 0.666)
            sound (self, CHAN_VOICE, "ue/ue_die2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "ue/ue_die3.wav", 1, ATTN_NORM);
    }
    else
*/
        sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
    if (random() > 0.5)
        enf_die1 ();
    else
        enf_fdie1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() enf_revive1  =[ $death13,  enf_revive2  ] {};
void() enf_revive2  =[ $death12,  enf_revive3  ] {};
void() enf_revive3  =[ $death11,  enf_revive4  ] {};
void() enf_revive4  =[ $death10,  enf_revive5  ] {};
void() enf_revive5  =[ $death9,   enf_revive6  ] {};
void() enf_revive6  =[ $death8,   enf_revive7  ] {};
void() enf_revive7  =[ $death7,   enf_revive8  ] {};
void() enf_revive8  =[ $death6,   enf_revive9  ] {};
void() enf_revive9  =[ $death5,   enf_revive10 ] {};
void() enf_revive10 =[ $death4,   enf_revive11 ] {};
void() enf_revive11 =[ $death3,   enf_revive12 ] {};
void() enf_revive12 =[ $death2,   enf_revive13 ] {};
void() enf_revive13 =[ $death1,   enf_run1     ] {};

void() enf_reviveb1  =[ $fdeath10,  enf_reviveb2  ] {};
void() enf_reviveb2  =[ $fdeath9,   enf_reviveb3  ] {};
void() enf_reviveb3  =[ $fdeath8,   enf_reviveb4  ] {};
void() enf_reviveb4  =[ $fdeath7,   enf_reviveb5  ] {};
void() enf_reviveb5  =[ $fdeath6,   enf_reviveb6  ] {};
void() enf_reviveb6  =[ $fdeath5,   enf_reviveb7  ] {};
void() enf_reviveb7  =[ $fdeath4,   enf_reviveb8  ] {};
void() enf_reviveb8  =[ $fdeath3,   enf_reviveb9  ] {};
void() enf_reviveb9  =[ $fdeath2,   enf_reviveb10 ] {};
void() enf_reviveb10 =[ $fdeath1,   enf_run1      ] {};

void() enf_revive =
{
    if ( self.frame == $fdeath11 )
        enf_reviveb1 ();
    else //if ( self.frame == $death14 )
        enf_revive1 ();
};


// OTHER - - - - - - - - - - - - - - - -
void(float hello) enf_sight =
{
    if (hello)      // Was sight3, replaced with idle.
        sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_NORM);
    else
    {
        local   float   rsnd;
        rsnd = rint(random() * 3);            
        if (rsnd == 1)          // "Stop!"
            sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
        else if (rsnd == 2)     // "Freeze!"
            sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM);
        else if (rsnd == 0)     // "You there!"
            sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
        else                    // "Halt!"
            sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM);
    }
};

void() enf_cache =
{
    precache_model ("progs/enforcer.mdl");
    precache_model ("progs/h_mega.mdl");
    precache_model ("progs/laser.mdl");

    precache_sound ("enforcer/death1.wav");
//    precache_sound ("enforcer/enfire.wav");
    precache_sound ("enforcer/enfstop.wav");
    precache_sound ("enforcer/idle1.wav");
    precache_sound ("enforcer/pain1.wav");
    precache_sound ("enforcer/pain2.wav");
    precache_sound ("enforcer/sight1.wav");
    precache_sound ("enforcer/sight2.wav");
    precache_sound ("enforcer/sight3.wav");
    precache_sound ("enforcer/sight4.wav");
    precache_sound ("hipweap/laserg.wav");      // Replaces enfire.wav.
};

//============
// Update 6/7/2011:  Skins.
//float   SKIN_ENFORCER       = 0;
float   SKIN_ENF_RED        = 1;
float   SKIN_ENF_CYBORG     = 2;
float   SKIN_ENF_DOOMED     = 3;
float   SKIN_ENF_DEFENDER   = 4;

// Prototypes for medieval replacements.
void() monster_archer;
void() monster_archer_lord;
void() monster_rebel;

float() medieval_enforcer =
{
    if (medieval)
    {
        self.skin = 0;  // None of the medieval enemies have lots of skins.
        if (soul_evil)
            {self.classname = "monster_archer";  monster_archer ();}
        else
            {self.classname = "monster_rebel";  monster_rebel ();}
        return TRUE;
    }
    return FALSE;
};

//============
// --> QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_enforcer =
{
// Tronyn:  Goblins
    if (medieval_enforcer ())
        return;
//- - - - - - - - -
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        enf_cache ();
    }
    
    monster_form ("progs/enforcer.mdl", '-16 -16 -24', '16 16 40', 80, -35);
    self.mdl_head   = "progs/h_mega.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = enf_stand1;
    self.th_walk    = enf_walk1;
    self.th_run     = enf_run1;
    self.th_missile = enf_attack;   //enf_atk1
    self.th_pain    = enf_pain;
    self.th_die     = enf_die;
    //- - - - - - - -
    self.th_sight   = enf_sight;
    self.th_gib     = enf_gib;
    self.th_revive  = enf_revive;
    self.th_spawn   = monster_enforcer;

    self.family     = FAM_ARMY;
// DISABLED -- OUM stuff.
//    if (oum && (self.spawnflags & 2))
//    {
//        self.health = self.max_health = 160;
//        self.skin = 1;
//        monster_guns (WAR_ROCKET_LAUNCHER, 0, 0, 0, 0);
//    }
//    else
        monster_guns (WAR_BLASTER, 0, 0, 0, 0);
    if (soul_evil)
        monster_purse (2, 0.5, 0);

    monster_start ();
};


//============================================================================
//  DEFENDER  (Recreation of one of Quoth's enforcer variants.)
//============================================================================

void() def_attack =
{
    M_SelectGun();
//- - - - - - - - -
// Defender:  Use grenades if possible.
    if (self.arsenal & WAR_GRENADE_LAUNCHER)
    if (self.ammo_rockets)
    if (self.enemy.absmin_z < self.absmax_z)
    if (!InMeleeRange (200))
        self.war = WAR_GRENADE_LAUNCHER;
//- - - - - - - - -
    if (self.war)
        enf_atk1();
};

void() monster_defender =
{
// Tronyn:  Goblins
    if (medieval_enforcer ())
        return;
//- - - - - - - - -
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        enf_cache ();
    }
    
    monster_form ("progs/enforcer.mdl", '-16 -16 -24', '16 16 40', 120, -35);
    self.mdl_head   = "progs/h_mega.mdl";
    self.mass       = MASS_MEDIUM;
    self.skin       = SKIN_ENF_DEFENDER;

    self.th_stand   = enf_stand1;
    self.th_walk    = enf_walk1;
    self.th_run     = enf_run1;
    self.th_missile = def_attack;
    self.th_pain    = enf_pain;
    self.th_die     = enf_die;
    //- - - - - - - -
    self.th_sight   = enf_sight;
    self.th_gib     = enf_gib;
    self.th_revive  = enf_revive;
    self.th_spawn   = monster_defender;

    self.family     = FAM_ARMY;
    self.attack_state = AS_FLANKING;
    monster_guns (WAR_SUPER_SHOTGUN | WAR_GRENADE_LAUNCHER, 0, 0, 0, 0);

    monster_start ();
};


//============================================================================
//  ELIMINATOR (Recreation of one of Quoth's enforcer variants.)
//============================================================================

void() commando_win =
{
    if (random() < 0.5)
        sound (self, CHAN_VOICE, "commando/hesdown.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "commando/hostile.wav", 1, ATTN_NORM);
    monster_sow();
};

void(float hello) commando_sight =
{
    if (hello)      // Was sight3, replaced with idle.
        sound (self, CHAN_VOICE, "commando/acknow.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "commando/sight.wav", 1, ATTN_NORM);
};

// FIXME:  Convert eliminator to a commando.
/*
void() commando_cache =
{
    precache_model ("progs/enforcer.mdl");
    precache_model ("progs/h_mega.mdl");
    precache_model ("progs/plasma1.mdl");   // FIXME:  New plasma model?

    precache_sound ("commando/acknow.wav");
    precache_sound ("commando/hesdown.wav");
    precache_sound ("commando/hostile.wav");
    precache_sound ("commando/idle1.wav");
    precache_sound ("commando/idle2.wav");
    precache_sound ("commando/idle3.wav");
    precache_sound ("commando/sight.wav");
    precache_sound ("commando/target.wav");
    precache_sound ("weapons/plasma1.wav");
};
*/

void() monster_commando =
{
// Tronyn:  Goblins
    if (medieval_enforcer ())
        return;
//- - - - - - - - -
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        enf_cache ();
    }
    
    monster_form ("progs/enforcer.mdl", '-16 -16 -24', '16 16 40', 160, -35);
    self.mdl_head   = "progs/h_mega.mdl";
    self.mass       = MASS_MEDIUM;
    self.skin       = SKIN_ENF_CYBORG;

    self.th_stand   = enf_stand1;
    self.th_walk    = enf_walk1;
    self.th_run     = enf_run1;
    self.th_missile = enf_attack;
    self.th_pain    = enf_pain;
    self.th_die     = enf_die;
    //- - - - - - - -
    self.th_sight   = enf_sight;    //commando_sight;
    self.th_gib     = enf_gib;
    self.th_revive  = enf_revive;
    self.th_spawn   = monster_commando;
// DISABLED:  No sound yet.
//    self.th_win     = commando_win;

    self.family     = FAM_ARMY;
    self.attack_state = AS_FLANKING;
    monster_guns (WAR_PLASMA_GUN, 0, 0, 0, 0);

    monster_start ();
};


//============================================================================
//  CHAINGUNNER  (Chaingun Enforcer variant, based on Doom2 chaingunner.)
//============================================================================

// ATTACK - - - - - - - - - - - - - - -
void() gunner_chaingun =
{
    local   vector  p1, p2;

    if (M_Punked ())
        return;     // Weapon lost.
    makevectors (self.angles);
    p1 = self.origin + (v_forward*12) + (v_right*8.5) + (v_up*16);
    p2 = Midpoint (self.enemy);
    M_FireChaingun (p1, p2, self.enemy, '0 0 0');
};

void(float ox) gunner_fire_II =
{
    local   vector  p1, p2, err;

    err_x = ox;  err_y = 0;  err_z = 1;
    makevectors (self.angles);
//    if ((self.war & WARx_USES_SHELLS) || (self.war == WAR_RAILGUN))
    if (self.war & WARx_USES_SHELLS)
    {
    // fire somewhat behind the player, so a dodging player is harder to hit
    // but not as far as grunts.
        p1 = self.origin;
        p2 = self.enemy.origin - self.enemy.velocity*0.1;
    }
    else
    {
        p2 = (v_forward*12) + (v_right*8.5) + (v_up*16);
        p1 = self.origin + p2;
        p2 = Aimpoint (self.enemy);
    }
    if (self.classname == "monster_me")
    {
        M_Attack (self.war, p1, p2, self.enemy, err, 2);
        if (self.war == WAR_BLASTER)
        {   // Laser spread.  Fire two more shots to the side.
            local   vector  dir, vx, vy, p3, p4;
            local   float   dist;

            dist = vlen(p2 - p1);
            dir = Vangles (p2 - p1);
            makevectors (dir);
            dir = CoSine (7.5);     // Was 10.
            vx = v_forward*dir_x + v_right*dir_y;
            vy = v_forward*dir_x - v_right*dir_y;
            p3 = p1 + vx*dist;
            p4 = p1 + vy*dist;

            M_Attack (self.war, p1, p3, self.enemy, err, 2);
            M_Attack (self.war, p1, p4, self.enemy, err, 2);
        }
    }
    else
        M_Attack (self.war, p1, p2, self.enemy, err, TRUE);
};
void() gunner_fire = {gunner_fire_II (0);};

void() gunner_atkx;

// Standard
void() gunner_atk1  =[ $attack1,  gunner_atk2  ] {ai_face();};
void() gunner_atk2  =[ $attack2,  gunner_atk3  ] {ai_face();};
void() gunner_atk3  =[ $attack3,  gunner_atkx  ] {ai_face();};
void() gunner_atk4  =[ $attack6,  gunner_atk5  ] {gunner_fire();};
void() gunner_atk5  =[ $attack7,  gunner_atk6  ] {ai_face();
    if (self.war == WAR_BLASTER)
        gunner_fire();
};
void() gunner_atk6  =[ $attack10, enf_run1  ] {ai_face(); SUB_CheckRefire (gunner_atk1);};

// Rapid-Fire
void() gunner_ratk1 =[ $attack6,  gunner_ratk2 ] {ai_face(); gunner_fire_II(10);};
void() gunner_ratk2 =[ $attack10, gunner_ratk3 ] {ai_face(); gunner_fire_II(5);};
void() gunner_ratk3 =[ $attack6,  gunner_ratk4 ] {ai_face(); gunner_fire_II(0);};
void() gunner_ratk4 =[ $attack10, gunner_ratk5 ] {ai_face(); gunner_fire_II(-5);};
void() gunner_ratk5 =[ $attack6,  gunner_ratk6 ] {ai_face(); gunner_fire_II(-10);};
void() gunner_ratk6 =[ $attack10, gunner_atk6  ] {ai_face(); gunner_fire_II(-15);};

// Thunderbolt
void() gunner_latk1 =[ $attack5,  gunner_latk2 ] {ai_face(); gunner_fire();};
void() gunner_latk2 =[ $attack10, gunner_latk3 ] {ai_face(); gunner_fire();};
void() gunner_latk3 =[ $attack5,  gunner_latk4 ] {ai_face(); gunner_fire();};
void() gunner_latk4 =[ $attack10, gunner_atk6  ] {ai_face(); gunner_fire();};

// Chain Lightning
void() gunner_clatk =[ $attack5,  gunner_atk6  ] {ai_face(); gunner_fire();};

// Chaingun, Doom2 style
void() gunner_gun1  =[ $attack6,  gunner_gun2  ] {ai_face(); gunner_chaingun();};
void() gunner_gun2  =[ $attack4,  gunner_gun1  ] {ai_face(); gunner_chaingun(); M_Break(enf_run1);};

void() gunner_atkx =
{
    if ((!self.war && (self.ammo_shells < 1)) || self.punked)
        enf_run1();     // Abort attack!
    else if (self.war & WAR_THUNDERBOLT)
        {gunner_latk1(); M_Lstart();}
    else if (self.war & WAR_CHAIN_LIGHTNING)
        {gunner_clatk(); M_Lstart();}
    else if (self.war & WARx_AI_RAPID_FIRE)
    {
        if (self.war == WAR_NAILGUN)
            gunner_gun1();
        else
            gunner_ratk1();
    }
    else
        gunner_atk4();
};
void() gunner_attack = {M_SelectGun();  if (self.war) gunner_atk1();};

// PAIN - - - - - - - - - - - - - - - -
void(entity attacker, float damage)  gunner_pain =
{
    if (self.pain_finished > time)
        return;

    local   float   r;
    
    if (random() < 0.5)
        sound (self, CHAN_VOICE, "gunner/pain1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "gunner/pain2.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;

    // Gunners shrug off pain more easily than standard enforcers.
    if (random()*30 > damage)
        return;     // didn't flinch
    if (SUB_IgnorePain ())
        return;     // No pain anims in Nightmare.

    r = random ();
    if (skill >= 3)
        r = r * 0.6;
    if (r < 0.3)        // Was 0.2.
        enf_paina1 ();
    else if (r < 0.6)   // Was 0.4.
        enf_painb1 ();
    else if (r < 0.8)   // Was 0.7.
        enf_painc1 ();
    else
        {self.pain_finished = time + 2;  enf_paind1 ();}

    attacker = attacker;    // Appease FrikQcc...
};

// DEATH - - - - - - - - - - - - - - - -
void() gunner_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        if (random() < 0.5)
            monster_decap ('-18 1 20', enf_decap1);
        else
            monster_decap ('-11 0 31', enf_decapb1);
        return;
    }
// check for gib
    if (enf_gib (self.health))
        return;

// regular death
    if (random() > 0.5)
    {   sound (self, CHAN_VOICE, "gunner/death1.wav", 1, ATTN_NORM);
        enf_die1 ();
    }
    else
    {   sound (self, CHAN_VOICE, "gunner/death2.wav", 1, ATTN_NORM);
        enf_fdie1 ();
    }
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) gunner_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "gunner/idle.wav", 1, ATTN_IDLE);
    else
        sound (self, CHAN_VOICE, "gunner/sight.wav", 1, ATTN_NORM);
};

void() gunner_cache =
{
    precache_model ("progs/enforcer.mdl");
    precache_model ("progs/h_mega.mdl");

    precache_sound ("gunner/death1.wav");
    precache_sound ("gunner/death2.wav");
    precache_sound ("gunner/idle.wav");
    precache_sound ("gunner/pain1.wav");
    precache_sound ("gunner/pain2.wav");
    precache_sound ("gunner/sight.wav");
    precache_sound ("weapons/dsshotgn.wav");    // Doom shotgun sound.
};

//============
// --> QUAKED monster_gunner (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_gunner =
{
// Tronyn:  Goblins
    if (medieval_enforcer ())
        return;
//- - - - - - - - -
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        gunner_cache ();
    }
    
// PM:  Chaingunners had 70 health in Doom2.
    monster_form ("progs/enforcer.mdl", '-16 -16 -24', '16 16 40', 70, -35);
    self.mdl_head   = "progs/h_mega.mdl";
    self.mass       = MASS_MEDIUM;
    self.skin       = SKIN_ENF_DOOMED;

    self.th_stand   = enf_stand1;
    self.th_walk    = enf_walk1;
    self.th_run     = enf_run1;
    self.th_missile = gunner_attack;   //gunner_atk1
    self.th_pain    = gunner_pain;
    self.th_die     = gunner_die;
    //- - - - - - - -
    self.th_sight   = gunner_sight;
    self.th_gib     = enf_gib;
    self.th_revive  = enf_revive;
    self.th_spawn   = monster_gunner;

    self.family     = FAM_ARMY;
    self.ryuflags   = RYU_INSANE;   // Humans shot each other in Doom.
    monster_guns (WAR_NAILGUN, 0, 0, 0, 0);
    if (soul_evil)
        monster_purse (2, 0.5, 0);

    monster_start ();
};


//============================================================================
//  MEGA ENFORCER  (Zerstorer's variant.)
//============================================================================

// Shield Toggle
void() menf_son =
{
    self.xfl = self.xfl | XFL_SHIELDS;
    self.takedamage = DAMAGE_NO;    // Shield ON!
    sound (self, CHAN_AUTO, "me/me_son.wav", 1, ATTN_NORM);
};

void() menf_soff =
{
    self.xfl = self.xfl - (self.xfl & XFL_SHIELDS);
    self.takedamage = DAMAGE_AIM;   // Shield OFF!
    sound (self, CHAN_AUTO, "me/me_soff.wav", 1, ATTN_NORM);
};

// STAND - - - - - - - - - - - - - - - -
void() menf_stand1  =[ $fieldon7,  menf_stand2  ] {ai_stand();};
void() menf_stand2  =[ $fieldon6,  menf_stand3  ] {ai_stand();};
void() menf_stand3  =[ $fieldon5,  enf_stand1   ] {menf_soff(); ai_stand();};

void() menf_stand =
{
    if (self.takedamage)
        enf_stand1 ();
    else
        menf_stand1 ();     // PM:  Turn off shields.
};

// WALK - - - - - - - - - - - - - - - -
void() menf_walk1  =[ $fieldon1,  menf_walk2  ] {};
void() menf_walk2  =[ $fieldon2,  menf_walk3  ] {};
void() menf_walk3  =[ $fieldon3,  menf_walk4  ] {};
void() menf_walk4  =[ $fieldon4,  menf_walk5  ] {};
void() menf_walk5  =[ $fieldon5,  menf_walk6  ] {menf_son();};
void() menf_walk6  =[ $fieldon6,  menf_walk7  ] {};
void() menf_walk7  =[ $fieldon7,  enf_walk1   ] {};

void() menf_walk =
{
    if (self.takedamage)
        menf_walk1 ();  // PM:  Turn on shields first.
    else
        enf_walk1 ();
};

// RUN - - - - - - - - - - - - - - - - -
void() menf_run1   =[ $fieldon1,  menf_run2  ] {};
void() menf_run2   =[ $fieldon2,  menf_run3  ] {};
void() menf_run3   =[ $fieldon3,  menf_run4  ] {};
void() menf_run4   =[ $fieldon4,  menf_run5  ] {};
void() menf_run5   =[ $fieldon5,  menf_run6  ] {menf_son();};
void() menf_run6   =[ $fieldon6,  menf_run7  ] {};
void() menf_run7   =[ $fieldon7,  enf_run1   ] {};

void() menf_run =
{
    if (self.takedamage)
        menf_run1 ();   // PM:  Turn on shields first.
    else
        enf_run1 ();
};

// ATTACK - - - - - - - - - - - - - - -
void() menf_atkx;

/*
void(float ox) gunner_fire_II =
{
    local   vector  p1, p2, err;

    err_x = ox;  err_y = 0;  err_z = 1;
    makevectors (self.angles);
    if (!self.war || (self.war & WARx_USES_SHELLS))
    {
    // fire somewhat behind the player, so a dodging player is harder to hit
    // but not as far as grunts.
        p1 = self.origin;
        p2 = self.enemy.origin - self.enemy.velocity*0.1;
    }
    else
    {
        p2 = (v_forward*12) + (v_right*8.5) + (v_up*16);
        p1 = self.origin + p2;
        p2 = Aimpoint (self.enemy);
    }
    if (self.classname == "monster_me")
        M_Attack (self.war, p1, p2, self.enemy, err, 2);
    else
        M_Attack (self.war, p1, p2, self.enemy, err, TRUE);
};
*/
// PM:  Tweaked anim, and removed 30% chance of aborting.
void() menf_atk1  =[ $attack1,  menf_atk2  ] {ai_face();};
void() menf_atk2  =[ $attack2,  menf_atk3  ] {ai_face();};
void() menf_atk3  =[ $attack3,  menf_atk4  ] {ai_face(); menf_soff();};
void() menf_atk4  =[ $attack4,  menf_atk5  ] {ai_face();};
void() menf_atk5  =[ $attack5,  menf_atkx  ] {ai_face();};
void() menf_atk6  =[ $attack6,  menf_atk7  ] {gunner_fire();};
void() menf_atk7  =[ $attack7,  menf_atk8  ] {ai_face();
//    if (cranked)
//        if (self.war == WAR_BLASTER)
//            gunner_fire ();
};
void() menf_atk8  =[ $attack8,  menf_atk9  ] {ai_face();
//    if (cranked)
//        if (self.war == WAR_BLASTER)
//            gunner_fire ();
};
void() menf_atk9  =[ $attack9,  menf_atk10 ] {ai_face();};
void() menf_atk10 =[ $attack10, menf_run   ] {ai_face(); menf_son(); SUB_CheckRefire (menf_atk1);};

// Chain Lightning
void() menf_clatk =[ $attack5,  menf_atk10  ] {ai_face(); gunner_fire();};

// Thunderbolt
void() menf_latk1 =[ $attack5,  menf_latk2  ] {ai_face(); gunner_fire();};
void() menf_latk2 =[ $attack4,  menf_latk3  ] {ai_face(); gunner_fire();};
void() menf_latk3 =[ $attack5,  menf_latk4  ] {ai_face(); gunner_fire();};
void() menf_latk4 =[ $attack4,  menf_atk10  ] {ai_face(); gunner_fire();};

// Rapid-Fire
void() menf_ratk1 =[ $attack6,  menf_ratk2  ] {ai_face(); gunner_fire_II(10);};
void() menf_ratk2 =[ $attack4,  menf_ratk3  ] {ai_face(); gunner_fire_II(5);};
void() menf_ratk3 =[ $attack6,  menf_ratk4  ] {ai_face(); gunner_fire_II(0);};
void() menf_ratk4 =[ $attack4,  menf_ratk5  ] {ai_face(); gunner_fire_II(-5);};
void() menf_ratk5 =[ $attack6,  menf_ratk6  ] {ai_face(); gunner_fire_II(-10);};
void() menf_ratk6 =[ $attack4,  menf_atk10  ] {ai_face(); gunner_fire_II(-15);};

// Chaingun
//void() menf_gun1  =[ $attack6,  menf_gun2   ] {ai_face(); gunner_chaingun();};
//void() menf_gun2  =[ $attack4,  menf_gun3   ] {ai_face(); gunner_chaingun();};
//void() menf_gun3  =[ $attack6,  menf_gun4   ] {ai_face(); gunner_chaingun();};
//void() menf_gun4  =[ $attack4,  menf_gun5   ] {ai_face(); gunner_chaingun();};
//void() menf_gun5  =[ $attack6,  menf_atk10  ] {ai_face(); gunner_chaingun();};

// Shoulder Mounted Gun (For sidewinder missiles only.)
void() menf_satck1 =[ $attackp1,  menf_satck2 ] {ai_face();};
void() menf_satck2 =[ $attackp2,  menf_satck3 ] {ai_face();};
void() menf_satck3 =[ $attackp3,  menf_satck4 ] {ai_face(); menf_soff();};
void() menf_satck4 =[ $attackp4,  menf_satck5 ] {ai_face();};
void() menf_satck5 =[ $attackp5,  menf_satck6 ] {ai_face(); M_MeSidewinder ('0 6 28');};
void() menf_satck6 =[ $attackp6,  menf_satck7 ] {ai_face();};
void() menf_satck7 =[ $attackp7,  menf_run    ] {ai_face(); menf_son();};

void() menf_atkx =
{
    if ((!self.war && (self.ammo_shells < 1)) || self.punked)
        menf_run();     // Abort attack!
    else if (self.war & WAR_THUNDERBOLT)
        {menf_latk1(); M_Lstart();}
    else if (self.war & WAR_CHAIN_LIGHTNING)
        {menf_clatk(); M_Lstart();}
//    else if (self.war == WAR_NAILGUN)
//        menf_gun1();
    else if (self.war & WARx_AI_RAPID_FIRE)
        menf_ratk1();
    else
        menf_atk6();
};

void() megaenforcer_fire =
{
    M_SelectGun ();
    if (!self.war)
        return;

    if (self.arsenal & WAR_SIDEWINDER)
    {
        local   float   edist;

        edist = vlen(self.enemy.origin - self.origin);
        if (edist >= 200)
        {
            local   float   p;

//            if (zerstorer)      //|| (edist >= 500))
//                p = 0.65;       // A bit much at near range.
//            else
                p = 0.5;
            if (random() < p || edist > 700)
                self.war = WAR_SIDEWINDER;
        }
    }
    if (self.war == WAR_SIDEWINDER)
        menf_satck1 ();
    else
        menf_atk1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() menf_paina1  =[ $paina1,  menf_paina2  ] {};
void() menf_paina2  =[ $paina2,  menf_paina3  ] {};
void() menf_paina3  =[ $paina3,  menf_paina4  ] {};
void() menf_paina4  =[ $paina4,  menf_run     ] {menf_son();};

void() menf_painb1  =[ $painb1,  menf_painb2  ] {};
void() menf_painb2  =[ $painb2,  menf_painb3  ] {};
void() menf_painb3  =[ $painb3,  menf_painb4  ] {};
void() menf_painb4  =[ $painb4,  menf_painb5  ] {};
void() menf_painb5  =[ $painb5,  menf_run     ] {menf_son();};

void() menf_painc1  =[ $painc1,  menf_painc2  ] {};
void() menf_painc2  =[ $painc2,  menf_painc3  ] {};
void() menf_painc3  =[ $painc3,  menf_painc4  ] {};
void() menf_painc4  =[ $painc4,  menf_painc5  ] {};
void() menf_painc5  =[ $painc5,  menf_painc6  ] {};
void() menf_painc6  =[ $painc6,  menf_painc7  ] {};
void() menf_painc7  =[ $painc7,  menf_painc8  ] {};
void() menf_painc8  =[ $painc8,  menf_run     ] {menf_son();};

void() menf_paind1  =[ $paind1,  menf_paind2  ] {};
void() menf_paind2  =[ $paind2,  menf_paind3  ] {};
void() menf_paind3  =[ $paind3,  menf_paind4  ] {};
void() menf_paind4  =[ $paind4,  menf_paind5  ] {ai_forward(2);};
void() menf_paind5  =[ $paind5,  menf_paind6  ] {ai_forward(1);};
void() menf_paind6  =[ $paind6,  menf_paind7  ] {};
void() menf_paind7  =[ $paind7,  menf_paind8  ] {};
void() menf_paind8  =[ $paind8,  menf_paind9  ] {};
void() menf_paind9  =[ $paind9,  menf_paind10 ] {};
void() menf_paind10 =[ $paind10, menf_paind11 ] {};
void() menf_paind11 =[ $paind11, menf_paind12 ] {ai_forward(1);};
void() menf_paind12 =[ $paind12, menf_paind13 ] {ai_forward(1);};
void() menf_paind13 =[ $paind13, menf_paind14 ] {ai_forward(1);};
void() menf_paind14 =[ $paind14, menf_paind15 ] {};
void() menf_paind15 =[ $paind15, menf_paind16 ] {};
void() menf_paind16 =[ $paind16, menf_paind17 ] {ai_back(1);};
void() menf_paind17 =[ $paind17, menf_paind18 ] {ai_back(1);};
void() menf_paind18 =[ $paind18, menf_paind19 ] {};
void() menf_paind19 =[ $paind19, menf_run     ] {menf_son();};

void(entity attacker, float damage) menf_pain =
{
    if (self.pain_finished > time)
        return;

    local   float   r;

    r = random ();
    if (r < 0.3)
        sound (self, CHAN_VOICE, "me/mepain1.wav", 1, ATTN_NORM);
    else if (r < 0.6)
        sound (self, CHAN_VOICE, "me/mepain2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "me/mepain3.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;

    if (self.health > self.max_health * 0.8)    // Was 120.
        return;         // Can't flinch if current health is over 80%.
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    r = random ();
    if (skill >= 3)
        r = r * 0.4;
    if (r < 0.2)
        menf_paina1 ();
    else if (r < 0.4)
        menf_painb1 ();
    else if (r < 0.6)
        menf_painc1 ();
    else if (r < 0.85 && self.health < 75)  // 50% of 150.
        {self.pain_finished = time + 2; menf_paind1 ();}
    // It is possible to not flinch.

    attacker = attacker;  damage = damage;  // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
float(float dm) menf_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowHead ("progs/h_me.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() menf_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        if (random() < 0.5)
            monster_decap ('-18 1 20', enf_decap1);
        else
            monster_decap ('-11 0 31', enf_decapb1);
        return;
    }
// check for gib
    if (menf_gib (self.health))
        return;

// regular death
    if (random() > 0.5)
    {   sound (self, CHAN_VOICE, "me/medeath2.wav", 1, ATTN_NORM);
        enf_die1 ();
    }
    else
    {   sound (self, CHAN_VOICE, "me/medeath1.wav", 1, ATTN_NORM);
        enf_fdie1 ();
    }
};

// REVIVE - - - - - - - - - - - - - - -
void() menf_revive1  =[ $death13,  menf_revive2  ] {};
void() menf_revive2  =[ $death12,  menf_revive3  ] {};
void() menf_revive3  =[ $death11,  menf_revive4  ] {};
void() menf_revive4  =[ $death10,  menf_revive5  ] {};
void() menf_revive5  =[ $death9,   menf_revive6  ] {};
void() menf_revive6  =[ $death8,   menf_revive7  ] {};
void() menf_revive7  =[ $death7,   menf_revive8  ] {};
void() menf_revive8  =[ $death6,   menf_revive9  ] {};
void() menf_revive9  =[ $death5,   menf_revive10 ] {};
void() menf_revive10 =[ $death4,   menf_revive11 ] {};
void() menf_revive11 =[ $death3,   menf_revive12 ] {};
void() menf_revive12 =[ $death2,   menf_revive13 ] {};
void() menf_revive13 =[ $death1,   menf_run      ] {};

void() menf_reviveb1  =[ $fdeath10,  menf_reviveb2  ] {};
void() menf_reviveb2  =[ $fdeath9,   menf_reviveb3  ] {};
void() menf_reviveb3  =[ $fdeath8,   menf_reviveb4  ] {};
void() menf_reviveb4  =[ $fdeath7,   menf_reviveb5  ] {};
void() menf_reviveb5  =[ $fdeath6,   menf_reviveb6  ] {};
void() menf_reviveb6  =[ $fdeath5,   menf_reviveb7  ] {};
void() menf_reviveb7  =[ $fdeath4,   menf_reviveb8  ] {};
void() menf_reviveb8  =[ $fdeath3,   menf_reviveb9  ] {};
void() menf_reviveb9  =[ $fdeath2,   menf_reviveb10 ] {};
void() menf_reviveb10 =[ $fdeath1,   menf_run       ] {};

void() menf_revive =
{
    if ( self.frame == $fdeath11 )
        menf_reviveb1 ();
    else //if ( self.frame == $death14 )
        menf_revive1 ();
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) menf_sight =
{
    if (hello)
    {
// Update 1/4/10:  Removed shields sound because client may mistake for enemy.
//        if (self.takedamage)    // "Shields!" -- they are off.
//            sound (self, CHAN_VOICE, "me/mesight1.wav", 1, ATTN_NORM);
//        else
        if (!self.takedamage)
            sound (self, CHAN_VOICE, "me/idle.wav", 1, ATTN_NORM);
    }
    else
    {
        local   float   rsnd;
        rsnd = rint(random() * 2);
        if ((rsnd == 1) && self.takedamage)     // "Shields!"
            sound (self, CHAN_VOICE, "me/mesight1.wav", 1, ATTN_NORM);
        else if (rsnd == 2)     // Growling
            sound (self, CHAN_VOICE, "me/mesight2.wav", 1, ATTN_NORM);
        else                    // "Die!"
            sound (self, CHAN_VOICE, "me/mesight3.wav", 1, ATTN_NORM);
    }
};

void() megaenforcer_cache =
{
    precache_model ("progs/enforce2.mdl");
    precache_model ("progs/h_me.mdl");
    precache_model ("progs/needle.mdl");    // Custom laser-like needle.
    precache_model ("progs/memissil.mdl");

    precache_sound ("enforcer/enfstop.wav");
    precache_sound ("me/medeath1.wav");
    precache_sound ("me/medeath2.wav");
    precache_sound ("me/meidle.wav");
    precache_sound ("me/mepain1.wav");
    precache_sound ("me/mepain2.wav");
    precache_sound ("me/mepain3.wav");
    precache_sound ("me/mesight1.wav");
    precache_sound ("me/mesight2.wav");
    precache_sound ("me/mesight3.wav");
    precache_sound ("me/me_fire1.wav");
    precache_sound ("me/me_fire2.wav");
    precache_sound ("me/me_son.wav");
    precache_sound ("me/me_soff.wav");
};

//============
// --> QUAKED monster_me (1 0 0) (-16 -16 -24) (16 16 40) Ambush
// PM:  I like these guys better than Quoth's eliminator.
//============
void() monster_me =
{
// Tronyn:  Goblins
    if (medieval)
    {
        self.classname = "monster_archer_lord";
        monster_archer_lord ();
        return;
    }
//- - - - - - - - -

    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        megaenforcer_cache ();
    }

    monster_form ("progs/enforce2.mdl", '-16 -16 -24', '16 16 40', 150, -35);
    self.mdl_head = "progs/h_me.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = menf_stand;
    self.th_walk    = menf_walk;
    self.th_run     = menf_run;
    self.th_pain    = menf_pain;
    self.th_die     = menf_die;
    self.th_missile = megaenforcer_fire;
    //- - - - - - - -
    self.th_sight   = menf_sight;
    self.th_gib     = menf_gib;
    self.th_revive  = menf_revive;
    self.th_spawn   = monster_me;

// Note:  Mega enforcer dropped 5 cells in Zerstorer.
// In Drake, give him a weapon that uses cells.
    monster_guns (WAR_BLASTER | WAR_SIDEWINDER, 0, 0, 0, 0);    //monster_guns (WAR_BLASTER, 0, 0, 1, 0);
    if (soul_evil)
        monster_purse (2, 0.5, 0);
    self.attack_state = AS_FLANKING;

    monster_start ();
// PM:  takedamage not set here anymore.
};
// PM:  Convert the boring eliminator to the fun mega enforcer.
// Besides, if I used eliminators, I need to add the overpowered plasma gun.
// FIXME:  Convert to the upcoming "monster_commando".
void() monster_eliminator = {self.classname = "monster_me";  monster_me();};


//============================================================================
//  ULTRA ENFORCER (Travail's red enforcer)
//============================================================================

/* DISABLED -- All of it!
void() uenf_attack =
{
    M_SelectGun();
//- - - - - - - - -
// Defender:  Use grenades if possible.
    if (self.arsenal & (WAR_ROCKET_LAUNCHER | WAR_SIDEWINDER))
    if (self.ammo_rockets)
    {
        local   float   dist;

        dist = vlen (self.enemy.origin - self.origin);
        if (random() < (dist / 768) - 0.15)
        if (self.arsenal & WAR_ROCKET_LAUNCHER)
            self.war = WAR_ROCKET_LAUNCHER;
        else if (self.arsenal & WAR_SIDEWINDER)
            self.war = WAR_SIDEWINDER;
    }
// FIXME:  At low, at ground behind target.
//- - - - - - - - -
    if (self.war)
        enf_atk1();
};

void(entity attacker, float damage) uenf_pain =
{
    if (self.pain_finished > time)
        return;
    if (random() > 0.3)
        return;     // Didn't flinch.

    local   float   r;

    r = random ();
    if (r < 0.3)
        sound (self, CHAN_VOICE, "ue/ue_pain1.wav", 1, ATTN_NORM);
    else if (r < 0.6)
        sound (self, CHAN_VOICE, "ue/ue_pain2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "ue/ue_pain3.wav", 1, ATTN_NORM);

    if (SUB_IgnorePain ())
    {
        self.pain_finished = time + 0.5;
        return;         // No pain anims in Nightmare.
    }

    r = random ();
    if (skill >= 3)
        r = r * 0.7;
    self.pain_finished = time + 1;
    if (r < 0.3)
        enf_paina1 ();
    else if (r < 0.7)
        enf_painb1 ();
    else
        enf_painc1 ();
    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

void(float hello) uenf_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_NORM);
    else
    {
        local   float   rsnd;
        rsnd = rint(random() * 5);            
        if (rsnd == 1)
            sound (self, CHAN_VOICE, "ue/ue_site1.wav", 1, ATTN_NORM);
        else if (rsnd == 2)
            sound (self, CHAN_VOICE, "ue/ue_site2.wav", 1, ATTN_NORM);
        else if (rsnd == 0)
            sound (self, CHAN_VOICE, "ue/ue_site3.wav", 1, ATTN_NORM);
        else if (rsnd == 3)
            sound (self, CHAN_VOICE, "ue/ue_site4.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "ue/ue_site5.wav", 1, ATTN_NORM);
    }
};

void() uenf_cache =
{
    precache_model ("progs/enforcer.mdl");
    precache_model ("progs/h_mega.mdl");

    precache_sound ("enforcer/idle1.wav");
    precache_sound ("ue/ue_die1.wav");
    precache_sound ("ue/ue_die2.wav");
    precache_sound ("ue/ue_die3.wav");
    precache_sound ("ue/ue_pain1.wav");
    precache_sound ("ue/ue_pain2.wav");
    precache_sound ("ue/ue_pain3.wav");
    precache_sound ("ue/ue_site1.wav");
    precache_sound ("ue/ue_site2.wav");
    precache_sound ("ue/ue_site3.wav");
    precache_sound ("ue/ue_site4.wav");
    precache_sound ("ue/ue_site5.wav");
};

//============
// --> QUAKED monster_ultra (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_ultra =
{
// Tronyn:  Goblins
//    if (medieval_enforcer ())
//        return;
//- - - - - - - - -
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        uenf_cache ();
    }

    local   vector  ultra;

    ultra = ARMOR_STATS_ULTRA;
    ultra_z = ultra_z + SUIT_ULTRA;

    self.skin = SKIN_ENF_RED;   // FIXME:  Temporary skin.
    monster_form ("progs/enforcer.mdl", '-16 -16 -24', '16 16 40', 400, -35);
    self.mdl_head   = "progs/h_mega.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = enf_stand1;
    self.th_walk    = enf_walk1;
    self.th_run     = enf_run1;
    self.th_missile = uenf_attack;
    self.th_pain    = uenf_pain;
    self.th_die     = enf_die;
    //- - - - - - - -
    self.th_sight   = uenf_sight;
    self.th_gib     = enf_gib;
    self.th_revive  = enf_revive;
    self.th_spawn   = monster_ultra;

    Armor_Set (self, ultra);
    self.items = self.items - (self.items & ITx_ALL_ARMOR);

    self.family     = FAM_ARMY;
    monster_guns (WAR_ROCKET_LAUNCHER | WAR_LASER_CANNON, 0, 0, 0, 0);
//    if (soul_evil)
//        monster_purse (2, 0.5, 0);

    monster_start ();
};
*/


//============================================================================
//  CROSSBOW REBEL  (Medieval Enforcer armed with a repeating crossbow.)
//============================================================================

void() rebel_fire =
{
    local   entity  targ;
    local   vector  org, dir;

    if (self.shots_left > 0)
        self.shots_left = self.shots_left - 1;

    if (cranked)
        targ = self.enemy;
    else
        targ = world;

    makevectors (self.angles);
    dir = (v_forward*12) + (v_right*8.5) + (v_up*16);
    org = self.origin + dir;
    dir = self.enemy.origin + dir;
//    if (ARROW_FLY)
        dir = Maim_Line (org, dir, AKARROW_SPEED_FLY, targ, '0 0 0');
//    else
//        dir = Maim_Toss (org, dir, AKARROW_SPEED_TOSS, 200, targ, '0 0 0');

    sound (self, CHAN_WEAPON, "archer/arrowr.wav", 1, ATTN_NORM);
    AkArrow_Launch (org, dir, 0);
};

// ATTACK - - - - - - - - - - - - - - -
//void() rebel_atk1  =[ $attack1,  rebel_atk2  ] {ai_face(); self.shots_left = random() * 4 & 3;};
void() rebel_atk1  =[ $attack1,  rebel_atk2  ] {ai_face(); self.shots_left = 2;};
void() rebel_atk2  =[ $attack2,  rebel_atk3  ] {ai_face();};
void() rebel_atk3  =[ $attack3,  rebel_atk4  ] {ai_face();};
void() rebel_atk4  =[ $attack4,  rebel_atk6  ] {ai_face();};
//void() rebel_atk5  =[ $attack5,  rebel_atk6  ] {ai_face();};
void() rebel_atk6  =[ $attack6,  rebel_atk7  ] {rebel_fire();};
void() rebel_atk7  =[ $attack7,  rebel_atk8  ] {ai_face();};
void() rebel_atk8  =[ $attack8,  rebel_atk13 ] {ai_face();};
//void() rebel_atk9  =[ $attack5,  rebel_atk10 ] {ai_face();};
//void() rebel_atk10 =[ $attack6,  rebel_atk11 ] {rebel_fire();};
//void() rebel_atk11 =[ $attack7,  rebel_atk12 ] {ai_face();};
//void() rebel_atk12 =[ $attack8,  rebel_atk13 ] {ai_face();};
void() rebel_atk13 =[ $attack9,  rebel_atk14 ] {ai_face();};
void() rebel_atk14 =[ $attack10, enf_run1    ] {ai_face();
    if (self.shots_left > 0)
        self.think = rebel_atk6;
    else
        SUB_CheckRefire (rebel_atk1);
};

// PAIN - - - - - - - - - - - - - - - -
void(entity attacker, float damage) rebel_pain =
{
    if (self.pain_finished > time)
        return;

    local   float   r;
    r = random ();
    if (skill >= 3)
        r = r * 0.4;
    
    if (r < 0.5)
        sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
//    if (r < 0.333)
//        sound (self, CHAN_VOICE, "me/mepain1.wav", 1, ATTN_NORM);
//    else if (r < 0.666)
//        sound (self, CHAN_VOICE, "me/mepain2.wav", 1, ATTN_NORM);
//    else
//        sound (self, CHAN_VOICE, "me/mepain3.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;

    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    if (r < 0.2)
        enf_paina1 ();
    else if (r < 0.4)
        enf_painb1 ();
    else if (r < 0.6)   //(r < 0.7)
        enf_painc1 ();
    else if (r < 0.85 && (self.health < self.max_health / 2))
    {
        self.pain_finished = time + 2;
        enf_paind1 ();
    }
    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
float(float dm) rebel_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_rebel.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() rebel_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        if (random() < 0.5)
            monster_decap ('-18 1 20', enf_decap1);
        else
            monster_decap ('-11 0 31', enf_decapb1);
        return;
    }
// check for gib
    if (rebel_gib (self.health))
        return;

// regular death
    sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
    if (random() > 0.5)
    {   //sound (self, CHAN_VOICE, "me/medeath2.wav", 1, ATTN_NORM);
        enf_die1 ();
    }
    else
    {   //sound (self, CHAN_VOICE, "me/medeath1.wav", 1, ATTN_NORM);
        enf_fdie1 ();
    }
};


// OTHER - - - - - - - - - - - - - - - -
/* DISABLED -- Enforcer sounds used instead.
void(float hello) rebel_sight =
{
    if (!hello)
    {
        if (random() < 0.5)
            sound (self, CHAN_VOICE, "me/mesight2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "me/mesight3.wav", 1, ATTN_NORM);
    }
};
*/

void() rebel_cache =
{
    precache_model ("progs/arrow.mdl");
    precache_model ("progs/rebel.mdl");
    precache_model ("progs/h_rebel.mdl");

    precache_sound ("archer/arrow1.wav");
    precache_sound ("archer/arrow2.wav");
    precache_sound ("archer/arrow3.wav");
    precache_sound ("archer/arrowbrk.wav");
    precache_sound ("archer/arrowr.wav");

    precache_sound ("enforcer/death1.wav");
//    precache_sound ("enforcer/idle1.wav");
    precache_sound ("enforcer/pain1.wav");
    precache_sound ("enforcer/pain2.wav");
    precache_sound ("enforcer/sight1.wav");
    precache_sound ("enforcer/sight2.wav");
    precache_sound ("enforcer/sight3.wav");
    precache_sound ("enforcer/sight4.wav");
};

//============
// --> QUAKED monster_rebel (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_rebel =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        rebel_cache ();
    }

//    self.skin = 0;      // Because my rebel hack auto-sets skin to 1.
    monster_form ("progs/rebel.mdl", '-16 -16 -24', '16 16 40', 80, -40);
    self.mdl_head   = "progs/h_rebel.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = enf_stand1;
    self.th_walk    = enf_walk1;
    self.th_run     = enf_run1;
    self.th_missile = rebel_atk1;
    self.th_pain    = rebel_pain;
    self.th_die     = rebel_die;
    //- - - - - - - -
    self.th_sight   = enf_sight;    //rebel_sight;
    self.th_gib     = rebel_gib;
    self.th_check   = SoldierCheckAttack;   // For Rebel AI.
    self.th_revive  = enf_revive;
    self.th_spawn   = monster_rebel;

// SoE:  Modified stats for nsoe2 rebel fighters.
    if (!self.skin && (self.spawnflags & SPAWN_WHITE))
    {
        if (self.health < 200)
            {self.health = self.max_health = 200;}
        self.ryuflags = RYU_ALERT | RYU_REBEL;
    }
//- - - - - - - - -
    if (soul_evil)
    {
        monster_guns (0, 0, 20, 0, 0);
        monster_purse (2, 0.5, 0);
    }

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
