// give.qc -- Imported from OUM then modified for Drake and derivatives.

float(entity who) give_ammo =
{
    local   float   taken;
    local   float   bulk, hi;

    taken = FALSE;
    bulk = who.perms & POW_PACK;
// Shells
    if (self.ammo_shells >= 1)
    if (who.ammo_shells >= 1)
    {   if (bulk)
            hi = AMAX2_SHELLS;
        else
            hi = AMAX_SHELLS;
        if (who.ammo_shells < hi)
        {
            if (self.spawnflags & 2)
                who.ammo_shells = who.ammo_shells + ShellGame (LARGE_SHELLS);
            else
                who.ammo_shells = who.ammo_shells + ShellGame (SMALL_SHELLS);
            self.ammo_shells = self.ammo_shells - 1;
            taken = TRUE;
        }
    }
// Nails
    if (self.ammo_nails >= 1)
    if (who.ammo_nails >= 1)
    {   if (bulk)
            hi = AMAX2_NAILS;
        else
            hi = AMAX_NAILS;
        if (who.ammo_nails < hi)
        {
            if (self.spawnflags & 2)
                who.ammo_nails = who.ammo_nails + LARGE_NAILS;
            else
                who.ammo_nails = who.ammo_nails + SMALL_NAILS;
            self.ammo_nails = self.ammo_nails - 1;
            taken = TRUE;
        }
    }
// Rockets
    if (self.ammo_rockets >= 1)
    if (who.ammo_rockets >= 1)
    {   if (bulk)
            hi = AMAX2_ROCKETS;
        else
            hi = AMAX_ROCKETS;
        if (who.ammo_rockets < hi)
        {
            if (self.spawnflags & 2)
                who.ammo_rockets = who.ammo_rockets + LARGE_ROCKETS;
            else
                who.ammo_rockets = who.ammo_rockets + SMALL_ROCKETS;
            self.ammo_rockets = self.ammo_rockets - 1;
            taken = TRUE;
        }
    }
// Cells
    if (self.ammo_cells >= 1)
    if (who.ammo_cells >= 1)
    {   if (bulk)
            hi = AMAX2_CELLS;
        else
            hi = AMAX_CELLS;
        if (who.ammo_cells < hi)
        {
            if (self.spawnflags & 2)
                who.ammo_cells = who.ammo_cells + LARGE_CELLS;
            else
                who.ammo_cells = who.ammo_cells + SMALL_CELLS;
            self.ammo_cells = self.ammo_cells - 1;
            taken = TRUE;
        }
    }
// PM:  Sorry, no custom ammo allowed.

// We're done.
    if (taken)
    {   // Got some ammo!
        bind_ammo (who);
        SUB_Think (who, War_UpdateCurrentAmmo);
    }
    return taken;
};

float(entity who) give_health =
{
    local   float   healed;

    if (self.dmg < 1)
        return FALSE;   // Empty.

    healed = FALSE;
    if (T_Heal (who, self.healamount, FALSE))
        healed = TRUE;
//    if (IsPoisoned (who))
//        {Poison_Null (who);  healed = TRUE;}

// Healed -- use a charge.
    if (healed)
        self.dmg = self.dmg - 1;
    return healed;
};

float(entity who) give_patch =
{
    if (Armor_NoPatch (who))
        return 0;   // N/A.
    if ((who.items & IT_ARMOR3) || (Armor_Exotic(who) == SUIT_COURAGE))
        return 5;
    if (who.items & IT_ARMOR2)
        return 10;
    return 15;
};

float(entity who) give_armor =
{
    local   float   hp;

    if (self.armorvalue < 1)
        return FALSE;     // Empty.
    if (!who.armortype)
        return FALSE;     // No armor.

    hp = give_patch (who);
    if (!T_Repair (who, hp, FALSE))
        return FALSE;

// Use a charge.
    self.armorvalue = self.armorvalue - 1;
    return TRUE;
};

void(entity who) give_all =
{
    if (self.spawnflags & 2)
    {
        self.ammo_shells  = self.ammo_shells * ShellGame (LARGE_SHELLS);
        self.ammo_nails   = self.ammo_nails * LARGE_NAILS;
        self.ammo_rockets = self.ammo_rockets * LARGE_ROCKETS;
        self.ammo_cells   = self.ammo_cells * LARGE_CELLS;
        self.dmg = self.dmg * 25;
    }
    else
    {
        self.ammo_shells  = self.ammo_shells * ShellGame (SMALL_SHELLS);
        self.ammo_nails   = self.ammo_nails * SMALL_NAILS;
        self.ammo_rockets = self.ammo_rockets * SMALL_ROCKETS;
        self.ammo_cells   = self.ammo_cells * SMALL_CELLS;
        self.dmg = self.dmg * 15;
    }
    self.armorvalue = self.armorvalue * give_patch (who);

// Give ammo.
    who.ammo_shells = who.ammo_shells + self.ammo_shells;
    who.ammo_nails = who.ammo_nails + self.ammo_nails;
    who.ammo_rockets = who.ammo_rockets + self.ammo_rockets;
    who.ammo_cells = who.ammo_cells + self.ammo_cells;
    bind_ammo (who);
    SUB_Think (who, War_UpdateCurrentAmmo);
// Give health.
    T_Heal (who, self.dmg, FALSE);
//    Poison_Null (who);      // And antidote.
// Give armor.
    if (self.armorvalue)
        T_Repair (who, self.armorvalue, FALSE);

// Give all in one charge.
    self.wait = -1;     // Once only!
    if (self.message)
        Safe_centerprint (who, self.message);
};


float(entity who) give_go =
{
    if (who.health <= 0)
        return FALSE;   // Dead
    if (who.classname != "player")
        return FALSE;   // Not a PC.
    if (self.attack_finished > time)
        return FALSE;   // Wait your turn!

// Fill 'er up!
    if (self.cnt == 1)
    {   if (!give_ammo (who))
            return FALSE;
    }
    else if (self.cnt == 2)
    {   if (!give_health (who))
            return FALSE;
    }
    else if (self.cnt == 3)
    {   if (!give_armor (who))
            return FALSE;
    }
    else if (self.cnt == 4)
    {   if (self.wait == -1)
            return FALSE;   // Empty.
        give_all (who);
    }
    else
        return FALSE;   // Wrong type.

// Thank you for shopping!
    sound (self, CHAN_VOICE, self.noise, 0.75, ATTN_NORM);
    return TRUE;
};

void() give_use =
{
    give_go (activator);
    // PM:  We are already in a SUB_UseTargets loop, so don't start another.
};

void() give_touch =
{
    if (!give_go (other))
        return;     // Didn't get the goodies.

    self.attack_finished = time + self.wait;

    activator = other;
    SUB_UseTargets ();      // fire all targets / killtargets
    // Use targets once only.
    self.target = self.target2 = self.killtarget = world.null_string;
};



// sf2 = big
// "ammo_shells" = ammo.
// "dmg" = health
// "armorvalue" = armor.
void() trigger_give =
{
// OUM disabled the triggers in deathmatch.  Not in Drake.

// First, convert fields used by OUM to those used by Drake.
    if (!self.cnt)
        objerror ("give: no cnt value!\n");
    if ((self.cnt < 1) && (self.cnt > 4))
        objerror ("give: cnt must be between 1 and 4!\n");
    if (!self.wait)
        self.wait = 1;
//    if (!self.sounds)
//        self.sounds = 0;

//self.cnt = 4;
    if (self.cnt == 4)
        self.noise = "misc/secret.wav";     // OUM's custom wav.
    else if (self.sounds == 1)
        self.noise = "buttons/switch02.wav";
    else if (self.cnt == 1)
        self.noise = "weapons/lock4.wav";
    else if (self.cnt == 3)
        self.noise = "items/armor1.wav";
    else //if (self.cnt == 2)
        self.noise = "items/r_item1.wav"; // Drake doesn't use health1.wav.
    precache_sound (self.noise);

    self.aflag = 0;
    if (self.cnt == 1)
    {   // Ammo
        if (!self.ammo_shells)
        if (!self.ammo_nails)
        if (!self.ammo_rockets)
        if (!self.ammo_cells)
            objerror ("give: cnt1 but no ammo_* parms\n");
    }
    else if (self.cnt == 2)
    {   // Health
        if (!self.dmg)
            objerror ("give: cnt2 but no dmg parms\n");
    }
    else if (self.cnt == 3)
    {   // Health
        if (!self.armorvalue)
            objerror ("give: cnt3 but no armorvalue parms\n");
    }
    else
    {   // All -- Secret
        if (!self.ammo_shells)
        if (!self.ammo_nails)
        if (!self.ammo_rockets)
        if (!self.ammo_cells)
        if (!self.dmg)
        if (!self.armorvalue)
            objerror ("give: cnt4 with no parms\n");

        if (!self.message)
            self.message = "You found a supply dump!";
    }
    if (self.targetname)
        self.use = give_use;
    else
        self.touch = give_touch;

    if (self.spawnflags & 2)
    {
        self.ammo_shells = self.ammo_shells * 2;
        self.ammo_nails = self.ammo_nails * 2;
        self.ammo_rockets = self.ammo_rockets * 2;
        self.ammo_cells = self.ammo_cells * 2;
        self.dmg = ceil(self.dmg * 5 / 3);
    }
//        self.healamount = 25;
//    else
        self.healamount = 15;

    InitTrigger ();
};


//===========================/  END OF FILE  /===========================//
