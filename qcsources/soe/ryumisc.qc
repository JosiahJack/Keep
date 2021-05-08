//==========================================================================
//  ryumisc.qc -- by Patrick Martin             Last updated:  5-8-2001
//--------------------------------------------------------------------------
//  This file contains a variety of code for the dragons that don't
//  belong in other dragon related .qc files.
//==========================================================================


//==========================================================================
//  Armor

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon's health is dangerously low.
//  Armor does not apply in this check.
//------------------------------------------------------------------------//
float(entity ent) PM_DragonLowHealth =
{
    if (ent.health <= 50)
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This calculates the max armor.
//------------------------------------------------------------------------//
float(entity ent) PM_DragonMaxArmor =
{
    return (ent.max_health);    // This yields 50% armor.
};

//----------------------------------------------------/ New Code /--------//
//  This gives dragon natural armor.
//------------------------------------------------------------------------//
float(entity ent, float points) PM_DragonAddArmor =
{
    local   float   max_armor;

    max_armor = PM_DragonMaxArmor (ent);
    ent.armortype = max_armor / (max_armor + ent.max_health);
    if (!points)
    {
        // Max out armor.
        ent.armorvalue = max_armor;
        return 0;
    }
    ent.armorvalue = ent.armorvalue + points;
    if (ent.armorvalue > max_armor)
    {
        points = ent.armorvalue - max_armor;
        ent.armorvalue = max_armor;
        return points;
    }
    return 0;
};


//==========================================================================
//  Sounds

//----------------------------------------------------/ New Code /--------//
//  Make wing-flapping noise unless dragon is underwater.
//------------------------------------------------------------------------//
void() PM_RyuFlySound =
{
    if (PM_EntInWater (self))
        return;

    // Large dragons are louder and can be heard from further away.
    // For small dragons, 0.7 is close to 0.7071 or (1 / sqrt(2)).
    if (self.height == SIZE_SMALL)
        sound (self, CHAN_BODY, "dragon/fly.wav", 0.7, ATTN_IDLE);
    else
        sound (self, CHAN_BODY, "dragon/fly.wav", 1, ATTN_NORM);
};


//==========================================================================
//  Obituaries

//----------------------------------------------------/ New Code /--------//
//  This displays an obituary when a player is killed by a dragon.
//------------------------------------------------------------------------//
void(entity targ, entity attacker, string mod) PM_DragonSlayer =
{
    local   string  verb;

    if (mod == "fire")
    {
        if (attacker.skin == SKIN_GOLD)
            verb = "cremated";
        else
            verb = "fried";
    }
    else if (mod == "ice")
        verb = "frostbitten";
    else if (mod == "lightning")
        verb = "electrocuted";
    else if (mod == "dragon")
        verb = "mangled";
    else if (mod == "acid")
        verb = "liquidated";
    else
        verb = "slain";

    bprint (" was ");
    bprint (verb);
    bprint (" by ");

    if (attacker.master.classname == "player")
    {
        if (attacker.master == targ)
        {
            // Killed by the target's own dragon.
            bprint ("his ");
        }
        else
        {
            // Killed by another player's dragon.
            bprint (attacker.master.netname);
            bprint ("'s ");
        }
    }
    else
    {
        bprint("a ");
    }

    if (attacker.skin == SKIN_RED)
        bprint ("Red Dragon\n");
    else if (attacker.skin == SKIN_WHITE)
        bprint ("White Dragon\n");
    else if (attacker.skin == SKIN_BLUE)
        bprint ("Blue Dragon\n");
    else if (attacker.skin == SKIN_GOLD)
        bprint ("Gold Dragon\n");
    else if (attacker.skin == SKIN_GREEN)
        bprint ("Green Dragon\n");
    else
        bprint ("Dragon\n");
};


//===========================/  END OF FILE  /===========================//
