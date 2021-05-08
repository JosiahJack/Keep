// Give 'ent' effects of quad damage without warning message and sound.
void(entity ent, float end) Psuedo_Quad =
{
    local   float   warn, reset;

    if (end <= 0)
        return;

    reset = 1;
    if (ent.super_damage_finished)
    {   // Already had quad, so stack the times.
        warn = (ent.super_damage_finished - time);
        if (warn < 0)
            warn = 0;
        end = end + warn;
        if (!ent.super_time)
            reset = 0;
    }

    // Activate quad damage.  Set super_time to squelch 3 sec. warning.
    ent.items = ent.items | IT_QUAD;
    if (reset)
    {
        warn = end - 3;
        while (warn < 1)
            warn = warn + 1;
        ent.super_time = time + warn;
    }
    ent.super_damage_finished = time + end;
};

// Give 'ent' effects of invisibility without warning message and sound.
void(entity ent, float end) Psuedo_Ring =
{
    local   float   warn, reset;

    if (end <= 0)
        return;

    reset = 1;
    if (ent.invisible_finished)
    {   // Already had ring of shadows, so stack the times.
        warn = (ent.invisible_finished - time);
        if (warn < 0)
            warn = 0;
        end = end + warn;
        if (!ent.invisible_time)
            reset = 0;
    }

    // Activate invisibility.  Set invisible_time to squelch 3 sec. warning.
    ent.items = ent.items | IT_INVISO;
    if (reset)
    {
        warn = end - 3;
        while (warn < 1)
            warn = warn + 1;
        ent.invisible_time = time + warn;
    }
    ent.invisible_finished = time + end;
};

// Give 'ent' effects of invulnerability without warning message and sound.
void(entity ent, float end) Psuedo_666 =
{
    local   float   warn, reset;

    if (end <= 0)
        return;

    reset = 1;
    if (ent.invincible_finished)
    {   // Already had ring of shadows, so stack the times.
        warn = (ent.invincible_finished - time);
        if (warn < 0)
            warn = 0;
        end = end + warn;
        if (!ent.invincible_time)
            reset = 0;
    }

    // Activate invisibility.  Set invincible_time to squelch 3 sec. warning.
    ent.items = ent.items | IT_PROTECT;
    if (reset)
    {
        warn = end - 3;
        while (warn < 1)
            warn = warn + 1;
        ent.invincible_time = time + warn;
    }
    ent.invincible_finished = time + end;
};


// Ewww, GROSS!!!
// Ulch! You feel sick.
// Blech! Rotten stuff.
// Ack! Tastes foul.
// What a relief!
// Ah, refreshing...
// Wow! Tastes great!
// Woah! Far out!

// Old potion effects used in nsoe2.zip (Soul of Evil).
/* DISABLED -- Old SoE potion code.
void() potion_soe =
{
// Outcomes:  Tainted = 1-in-8, Enchanted = 1-in-8, Normal = 3-in-4.
    if (self.cnt & 6)
    {   // Cures poison or heals minor damage.
        if (IsPoisoned (other))
        {
            Safe_sprint (other, "What a relief!\n");
            Poison_Null (other);
        }
        else
        {
            Safe_sprint (other, "Ah, refreshing...\n");
            T_Heal (other, 5, FALSE);
        }
    }
    else if (self.cnt & 1)
    {   // Player gets health boost and 10 sec. quad damage.
        Safe_sprint (other, "Wow! Tastes great!\n");
        Poison_Null (other);
        T_Heal (other, 20, FALSE);  // Heal 25 hp total, allowing a little
        T_Heal (other, 5, TRUE);    // to bypass normal max.
        Psuedo_Quad (other, 10);
    }
    else
    {   // Tainted!
        Safe_sprint (other, "Ack! Tastes foul.\n");
// Disabled damage due to save scumming issues.
//        T_NewDamage (other, other, self, 5, DF_NO_ARMOR|DF_NO_KNOCK, "drank the Kool-Aid");
    }
};
*/

