//==========================================================================
//  Regeneration

// Notes:
//  Regeneration encourages wounded players to camp in a safe place until
//  fully healed.  Rates much slower than 1 hp/sec cause too much waiting
//  to heal.
//
//  CTF elder rune regenerates 5 hp per second, which is too fast for
//  non-deathmatch games.
//
//  Also, in Dpmod, the player regenerates 10 hp/sec in deathmatch or
//  4 hp/sec otherwise.  However, regeneration is suspended for one second
//  when damage is taken.

//  Update 5/12/2010:  Changed regeneration rates from float to vector.
//   The change was done to support variable rates based on health.
//  Update 8/4/2010:  Changed again to two rates.  One to half, another
//   to full.  Uses two floats instead of a vector.

//------------------------------------------------------------------------//
//  Returns current rate of a given entity.  The rate may vary by health.
//  .healrate -- x=to 100%, y=to 50%, z=to 25% (max health).
//  All three rates are cumulative, and this function combines
//  the rates if necessary.
//------------------------------------------------------------------------//
float(entity ent) Regen_Rate =
{
    local   float   rate;

    if (ent.healrate > 0)
        rate = ent.healrate;
    else
        rate = 0;
    if (ent.health < ent.max_health / 2)
    {
        if (ent.healrate2 > 0)
        {
            if (rate > 0)
                rate = rate * ent.healrate2 / (rate + ent.healrate2);
            else
                rate = ent.healrate2;
        }
    }
    if (rate <= 0)
        return 0;
    if (rate < 0.0001)
        return 0.0001;     // Fastest rate allowed is 10K hp per second.
    return rate;
};

//------------------------------------------------------------------------//
//  This heals a damaged entity capable of regeneration up to maximum
//  health.
//
//  Without delays, health change is one point at a time, and only the
//  rate is variable.
//------------------------------------------------------------------------//
void(entity ent) Regen_Check =
{
    if (ent.health <= 0)
        return;     // Dead.

// Health
    local   float   hrate;

    hrate = Regen_Rate (ent);
    if (hrate)
    {   // Able to regenerate.
        local   float   diff, mx, hi;

        hi = ent.max_health;
        if (ent.healrate <= 0)
            hi = ceil(hi / 2);  // Assume half health max.

        // 8/14/10:  Armor curse suppresses regeneration.
        if ((ent.health < hi) && (ent.curse_type != CURSE_ARMOR))
        {   // Does not have max hp -- regenerate until fully healed.
            if (ent.healtime <= time)
            {
            // Add health to entity.  Entity can heal again later.
            // Compensate for possible discrepancy between the timestamps.
            // If the check was delayed longer than the heal rate, entity may
            // gain multiple hit points.  Also, if the check was delayed, the
            // next check will be sped up until the rate is back in order.
                diff = time - ent.healtime;
                mx = floor(diff/hrate);
                diff = diff - (hrate * mx);

                ent.health = ent.health + mx + 1;
                if (ent.health > hi)
                    ent.health = hi;
                ent.hit_points = ent.health;
                hrate = Regen_Rate (ent);   // Update rate.
                ent.healtime = time + hrate - diff;
            }
        }
        else
        {   // At max hp -- reset regeneration timer.
            // Note:  Could be longer than hrate for delay after damage.
            ent.healtime = time + hrate;
        }
    }

// Regenerating armor
    if (ent.armortype == 1)
    {   // All regenerating armors have 100% damage absorption.
        hrate = Armor_Exotic (ent);
        if (hrate == SUIT_SPIRIT)
        {
            hrate = 1;
            if ((ent.armorvalue < ARMOR_STATS_SPIRIT_y) && !ent.invisible_finished)
            {   // Able to regenerate.
                if (ent.repairtime < time)
                {
                    ent.armorvalue = ent.armorvalue + 1;
                    ent.repairtime = time + hrate;
                }
            }
            else if (ent.armorvalue > ARMOR_STATS_SPIRIT_y)
            {   // Rot excess armor away.
                if (ent.repairtime < time)
                {
                    ent.armorvalue = ent.armorvalue - 1;
                    ent.repairtime = time + hrate;
                }
            }
            else
                ent.repairtime = time + hrate;
        }
        else if (hrate == SUIT_ULTRA)
        {   // Ultra enforcers' particle shield armor.
            if (ent.veil_time < time)
            if (!IsOut (ent))
            {   // Draw the particles.
                // Designed for slow moving humans such as the enforcer.
                local   vector  ang, spot;
                local   float   loop, den, rgb;

                ang = '0 0 0';
                ang_x = time * 140;
                den = floor(ent.armorvalue * 3.75 / ARMOR_STATS_ULTRA_y);   //av/8
                rgb = den * 2 + 227;
                if (den)
                {
                    loop = 5;
                    while (loop > 0)
                    {
                        loop = loop - 1;
                        makevectors (ang);
                        spot = (v_forward * 20) + (v_up * 4) + ent.origin;
                        particle (spot, v_forward*2, rgb, den);
                        ang_y = ang_y + 72;     //360 * loop / 5;
                    }
                }
                ent.veil_time = time + 0.1;
            }
            // Regenerate.
            if (ent.armorvalue < ARMOR_STATS_ULTRA_y)
            {
                if (ent.repairtime < time)
                {
                    ent.armorvalue = ent.armorvalue + 1 + skill;
                    if (ent.armorvalue > ARMOR_STATS_ULTRA_y)
                        ent.armorvalue = ARMOR_STATS_ULTRA_y;
                    ent.repairtime = time + 0.1;
                }
            }
            else
                ent.repairtime = time + 0.5;
        }
    }
};

//------------------------------------------------------------------------//
//  This sets an entity's rates of regeneration.
//------------------------------------------------------------------------//
void(entity ent, float hrate1, float hrate2) Regen_TwoSet =
{
    if (hrate1 < 0)
        hrate1 = 0;
    if (hrate2 < 0)
        hrate2 = 0;

    ent.healrate = hrate1;
    ent.healrate2 = hrate2;

    if (hrate1 || hrate2)
        ent.healtime = time + Regen_Rate (ent);
    else
        ent.healtime = 0;
};

// The old function before two-tier update.
void(entity ent, float rate) Regen_Set =
    {Regen_TwoSet (ent, rate, 0);};

//------------------------------------------------------------------------//
//  This combines rates of regeneration into one.
//  The closer to zero the rate is, the greater the effect on the outcome.
//  Positive rate quickens regeneration, negative rate slows it down.
//------------------------------------------------------------------------//
float(float base, float add) Regen_AddRates =
{
    if (add)
    {
        if (add > 0)   // Quicken if TRUE.
            base = base * add / (base + add);
        else
        {   // Slower rate.
            add = 0 - add;
            base = base * (add + 1) / add;
        }
    }
    return base;
};

void(entity ent, float hrate1, float hrate2) Regen_TwoAdd =
{
    hrate1 = Regen_AddRates (ent.healrate, hrate1);
    hrate2 = Regen_AddRates (ent.healrate2, hrate2);
    Regen_TwoSet (ent, hrate1, hrate2);
};

void(entity ent, float rate) Regen_Add =
    {Regen_TwoAdd (ent, rate, rate);};

// Sets regeneration rate based on items.  Overrides previous rate.
// Should be used only by clients.
void(entity ent) Regen_ClientReset =
{
    local   float   hrate1, hrate2, xarm;

    if (!(ent.flags & FL_CLIENT))
        return;

    xarm = Armor_Exotic (ent);

    hrate1 = hrate2 = 0;
// Permanent regeneration items.
// FIXME:  Finalize the rates.
    if (ent.items2 & IT2_REGEN)
        hrate1 = 1;
    if (ent.items2 & IT2_REGEN2)
        hrate1 = hrate1 + 2;

    if (xarm == SUIT_BERSERKER)
        hrate1 = hrate1 + 2;
    else if (xarm == SUIT_NINJA)
        hrate2 = hrate2 + 1;

// FIXME:  Add possible CTF-style regeneration rune here.
//    if (ent.tech == TECH_REGEN)
//        {hrate1 = hrate1 + 5;}
// Combine all into a single rate.
    if (hrate1)
        hrate1 = 1 / hrate1;
    if (hrate2)
        hrate2 = 1 / hrate2;
    Regen_TwoSet (ent, hrate1, hrate2);
};


//===========================/  END OF FILE  /===========================//
