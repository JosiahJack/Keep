//==========================================================================
//  regen.qc -- by Patrick Martin               Last updated:  2-2-2001
//--------------------------------------------------------------------------
//  This file contains code that lets an entity regain health over time.
//
//  NOTE:  The following Quake edict field is used:
//      volume  - +volume = ? hp/sec.; -volume = 1 hp/? secs.
//
//  (Used to use 'wait', before merging this with Zerstorer.)
//==========================================================================

.float  healtime;       // Time when damaged entity regains health.

//----------------------------------------------------/ New Code /--------//
//  This lets a damaged entity automatically recover health if it
//  can regenerate.  This function should be called on every frame.
//------------------------------------------------------------------------//
void() PM_Regenerate =
{
    local   float   newhealth;

    // Check if entity can regenerate.
    if (!self.volume)
        return;

    // Check if entity is in full health.
    if (self.health >= self.max_health)
    {
        // Reset the time.
        if (self.volume > 0)
            self.healtime = time + 1;
        else
            self.healtime = time - self.volume;
        return;
    }

    // Check if it is time to regenerate.
    if (self.healtime > time)
        return;

    // Check if entity is dead or alive.
    if (self.health <= 0)
        return;

    // Add health to entity.  Entity can heal again later.
    if (self.volume > 0)
    {
        // Positive value affects health gained per second.
        newhealth = self.health + self.volume;
        self.healtime = time + 1;
    }
    else
    {
        // Negative value affects when health is gained.
        newhealth = self.health + 1;
        self.healtime = time - self.volume;
    }

    // Make sure health cannot regenerate over the maximum.
    if (newhealth >= self.max_health)
        self.health = self.max_health;
    else
        self.health = newhealth;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity can regenerate.
//------------------------------------------------------------------------//
float(entity ent) PM_CanRegenerate =
{
    return ent.volume;
};

//----------------------------------------------------/ New Code /--------//
//  This sets an entity's rate of regeneration.
//------------------------------------------------------------------------//
float(entity ent, float amount) PM_SetRegeneration =
{
    ent.volume = amount;
};


//===========================/  END OF FILE  /===========================//
