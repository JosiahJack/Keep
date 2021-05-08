//==========================================================================
//  Decapitation

// Toss brain matter all over the place.  Used in head explosion deaths.
void() ThrowBrains =
{
    local   float   mx;
    local   vector  org, vel;
    local   string  text;

    org = self.origin;
    mx = floor(self.bloodtype / 16) * 16 + 1;
    particle (org, '0 0 1', mx, 127);
    particle (org, '0 0 1', mx + 8, 127);
    mx = 2;     // Was 3.
    while (mx > 0)
    {
        vel_x = 150 * crandom();
        vel_y = 150 * crandom();
        vel_z = -100 + 100 * random();   // MeatSpray adds 250-300.
        SpawnMeatSpray (org, vel, self.bloodtype);
        mx = mx - 1;
    }
    if (self.bloodtype == BLOOD_RED)
        text = "progs/zom_gib.mdl";
    else if ((self.bloodtype == BLOOD_GREEN) && (bloodbank & BB_GREEN))
        text = "progs/gr_gib.mdl";
    else if ((self.bloodtype == BLOOD_PURPLE) && (bloodbank & BB_PURPLE))
        text = "progs/pur_gib.mdl";
    else if ((self.bloodtype == BLOOD_FIRE) && (bloodbank & BB_FIRE))
        text = "progs/ember.mdl";
    else
        text = "progs/null_256.spr";
    self.skin = 0;
    ThrowIt (text, 0, GIB_DMV|GIB_HEAD);    // Was 'ThrowHead (text, 0);'
};

// Like monster_end, called when headless bodydouble finishes its death scene.
void() decap_end =
{
    self.deadflag   = DEAD_DEAD;    // As if it were alive to begin with.
    // Give the body the same delay as standard gibs before vanishing.
    if (self.spawned)
        self.nextthink  = time + 2 + random()*2;
    else //if (corpse_removal)
        self.nextthink  = time + 10 + random()*10;
    // Remove body as if a monster, instead of as a simple gib.
    self.think      = monster_remove;
};

// The real gib function for headless body double.
void(string g1, string g2, string g3) decap_explode =
{
//    if (self.model == "progs/zombie.mdl")
//        sound (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM);
//    else
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    ThrowGib (g1, self.health);
    ThrowGib (g2, self.health);
    ThrowGib (g3, self.health);

    Burn_Null (self);
    self.solid      = SOLID_NOT;
    self.modelindex = 0;
    self.nextthink  = 0.01;
    self.think      = SUB_Remove;
};

// 'Death' function for headless body double.
void() decap_gib =
{
    decap_explode ("progs/gib1.mdl", "progs/gib2.mdl", "progs/gib3.mdl");
};

// Generic body double spawner for decapitated monsters.
void(vector ofs, void() decap) monster_decap =
{
    local   float   brains;
    local   string  sfx;

    if (self.deathtype == "decap_pop")
        brains = TRUE;
    else
        brains = FALSE;
    if (self.deathtype == "decap_rip")
        sfx = "player/teledth1.wav";    // Head was ripped, instead of sliced, off.
    else
        sfx = "misc/dsslop.wav";
// Play the appropriate rip-off sounds.
    sound (self, CHAN_VOICE, sfx, 1, ATTN_NORM);

// Create a headless body double.
    newmis = spawn();
    setall (newmis, self.model, self.mins, self.maxs,  self.origin);

    newmis.skin       = self.skin;
    newmis.velocity   = self.velocity;
    newmis.movetype   = MOVETYPE_STEP;
    newmis.solid      = SOLID_SLIDEBOX;

    newmis.angles     = self.angles;
    newmis.takedamage = DAMAGE_AIM;
    newmis.bloodtype  = self.bloodtype;   //BLOOD_RED;
    newmis.xfl        = XFL_ZOMBIE;
    newmis.xsf        = XSF_BODY_DOUBLE;

    newmis.deadflag   = DEAD_NO;    // So decap can gib when killed.
    newmis.max_health = 0 - self.gib_health;
    newmis.health     = self.health - self.gib_health;
    if (newmis.health < 1)
        newmis.health     = 1;
//    newmis.health     = newmis.max_health   = 0 - self.gib_health;
//    if (gibfunc)
//        newmis.th_die     = gibfunc;
//    else
        newmis.th_die     = decap_gib;

    // SoE:  Copy loot to body.
    newmis.enemy      = self.enemy;         // Needed for drop bonus check.
    newmis.deathtype  = self.deathtype;     // Needed for drop bonus check.
    newmis.purse      = self.purse;
    Pack_Copy (self, newmis);
// Don't copy special drop because the severed head will drop the item.
//    newmis.spawnclassname   = self.spawnclassname;
//    newmis.spawnfunction    = self.spawnfunction;

    newmis.owner      = self;     // So head gib can pass through the body.
    newmis.spawned    = self.spawned;   // Affects when body disappears.
    SUB_Think (newmis, decap);

// Off with his head!
// NOTE:  Using setorigin on existing entities during touch code is a
// bad idea because it breaks links in the C code.  Therefore, set origin
// directly here and let other builtin functions deal with origin updating.
// For now, no touch function causes decapitation, but that can change later.
    makevectors (self.angles);
    ofs = (v_forward * ofs_x) + (v_right * ofs_y) + (v_up * ofs_z);
    self.origin = self.origin + ofs;
    if (brains)     // "Your Head A Splode"
        ThrowBrains ();
    else
        ThrowHead (self.mdl_head, self.health);
};

// PM:  Death by vorpal decapitation uses special decap code.
float() Decapitated =
{
    if (self.deathtype == "decap_cut")
        return TRUE;
    if (self.deathtype == "decap_pop")
        return TRUE;
    if (self.deathtype == "decap_rip")
        return TRUE;
    return FALSE;
};


//==========================================================================
//  Death Throes

//void(void() thinkst) death_explode
//{
//// Lavasplash particles form a box with a size of 270x270x64.
//// 135 * 1.4142 = 190.9188.  So use 160 damage for explosion radius of 200.
//    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
//    T_RadiusDamage (self, self, 160, self);
//    Tent_Point (TE_LAVASPLASH, self.origin - '0 0 32');
//    thinkst ();
//};

void() death_puff =
{
    local   vector  spot;
    local   entity  puff;

    spot_x = random();
    spot_y = random();
    spot_z = random() * 0.5;
    spot = Anypoint (self, spot);

    puff = spawn();
    setorigin (puff, spot);
    puff.effects = EF_MUZZLEFLASH;
    sound (puff, CHAN_AUTO, "hknight/hit.wav", 1, ATTN_NORM);
    SUB_Think (puff, BecomeExplosion);  // FIXME:  Invisible in Qrack.
};

//- - - - - - - - -

// Based on Nehahra's dying effects.
// Currently, multiple beams flash in a psychadelic light show.
// FIXME:  Create and use effects more like Taito's Darius Gaiden boss kills.
//  i.e., static cones of light erupting one at a time until the big kaboom.
void() death_beam =
{
    local   vector  spot;

    spot_x = crandom() * 20;
    spot_y = crandom() * 20;
//    spot_z = crandom() * 20 + 100;
//    spot = spot + self.origin;
    spot_z = crandom() * 20;
    spot = Aimpoint(self) + spot;

    newmis = spawn();
    newmis.alpha    = 0.1;      // As per Nehahra.
    newmis.solid    = SOLID_NOT;
    newmis.movetype = MOVETYPE_NONE;
    newmis.angles_x = random() * 360;
    newmis.angles_y = random() * 360;
    newmis.angles_z = random() * 360;
// In Nehahra, beams always shed light.  The entity who is dying should
// spawn a muzzleflash, but since Fitz 0.85 (with default settings) suspends
// interpolation when an entity flashes, let the beams shed light.
// Unlike Nehahra, allow light only randomly to produce a strobe effect.
    if (random() < 0.1)
        newmis.effects  = EF_DIMLIGHT;
    newmis.think    = SUB_Remove;
    newmis.nextthink= time + 0.1;

    setall (newmis, "progs/nehjet.mdl", '0 0 0', '0 0 0', spot);
};

// Spawns beams of light centered in an entity.
// Used by huge monsters who are in the middle of a dying scene meltdown.
// Use a do loop to insure at least one beam is spawned.
void(float loop) death_beams =
    {do {death_beam(); loop = loop - 1;} while (loop > 0);};


//===========================/  END OF FILE  /===========================//
