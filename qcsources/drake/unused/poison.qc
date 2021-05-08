//==========================================================================
//  Poison

// Code for poison that functions like that in Coven of Ebony,
// except no dummy entity is made to control the poison.

float(entity ent) IsPoisoned = {return (ent.poison_rate > 0);};

// This removes all poison from an entity.
void(entity ent) Poison_Null = {ent.poison_rate = ent.poison_finished = 0;};

// This checks if an entity takes damage from poison.
// Note:  It doesn't matter who delivered the poison, so attacker is world.
void(entity ent) Poison_Check =
{
    if (ent.poison_rate > 0)
        if (ent.poison_finished <= time)
    {
        if (IsDead (ent) || (ent.xfl & XFL_IMMUNITY))
            {Poison_Null (ent); return;}    // No effect on dead/immune people.
//        else
        {
            local   string  obit;
            local   float   r;

            obit = "died of the Black Plague";
            r = DF_TIMED|DF_NO_ARMOR|DF_NO_KNOCK;   // dflags
            T_NewDamage (ent, ent, world, 1, r, obit);
            ent.poison_finished = time + 10 - ent.poison_rate;
        }
    }
};

// This poisons the victim.
void(entity victim, float dose) Poison_Add =
{
// Check for immunity.
    if (ImmuneToDamage (victim))
        return;
    if (victim.health <= 0)
        return;     // Already dead.
    if (victim.xfl & (XFL_IMMUNITY | XFL_BOSS))
        return;     // Immune.
    if (victim.family & FAMx_NONLIVING)
        return;     // Poison doesn't work on undead or constructs.

// Check the doseage.
    if (dose < 1)
    {   // Not enough to poison reliably.
        if (random() >= dose)
            return;     // Miss.
        dose = 1;   // Lucky hit.
    }
    else
        dose = floor(dose);     // No fractions allowed.

// Blight the target.
    local   float   r, t;

    r = victim.poison_rate;
    victim.poison_rate = victim.poison_rate + dose;
    if (victim.poison_rate > 9)
        victim.poison_rate = 9;
    t = time + 10 - victim.poison_rate;

    if (!r)
    {   // Alert the victim of his ailment.
        Safe_sprint (victim, "You feel sick\n");    //"You have been poisoned\n"
        victim.poison_finished = t;
    }
    else if (t < victim.poison_finished)
        victim.poison_finished = t;
};


//===========================/  END OF FILE  /===========================//
