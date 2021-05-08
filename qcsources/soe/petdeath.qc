//==========================================================================
//  petdeath.qc -- by Patrick Martin            Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that destroys a player's dragon familiar.
//==========================================================================


//==========================================================================
//  Pet Destruction

void() pet_die1;
void() pet_dieb1;

//----------------------------------------------------/ New Code /--------//
//  This gets rid of all flags except the following:
//  'skin'    - For dragon powerup cheat.
//  'control' - So player will auto-switch weapons when attack is used.
//------------------------------------------------------------------------//
void(entity client) PM_ClearDracoFlags =
{
    client.petflags = client.petflags & (PET_SKIN | PET_CONTROL);
};

//----------------------------------------------------/ New Code /--------//
//  A pet dragon disintegrates into a bloody mess.
//------------------------------------------------------------------------//
void(entity pet) PM_PetDisintegrate =
{
    sound (pet, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
    PM_ThrowAnyHead (pet, "progs/tail.mdl", pet.health, pet.skin, SIZE_SMALL);
    PM_ThrowAnyGib (pet, "progs/lwing.mdl", pet.health, pet.skin, SIZE_SMALL);
    PM_ThrowAnyGib (pet, "progs/rwing.mdl", pet.health, pet.skin, SIZE_SMALL);
    PM_ThrowAnyGib (pet, "progs/zom_gib.mdl", pet.health, 0, 0);
    PM_ThrowAnyGib (pet, "progs/zom_gib.mdl", pet.health, 0, 0);

    // Make the head disappear soon.
    pet.nextthink   = time + 10 + random()*10;
    pet.think       = SUB_Remove;
};

//----------------------------------------------------/ New Code /--------//
//  A pet dragon simply falls dead.
//------------------------------------------------------------------------//
void(entity pet) PM_PetFallDead =
{
    pet.velocity_x = -200 + 400*random();
    pet.velocity_y = -200 + 400*random();
    pet.velocity_z =  100 + 100*random();
    pet.flags = pet.flags - (pet.flags & FL_ONGROUND);
    sound (pet, CHAN_VOICE, "dragon/death2.wav", 1, ATTN_NORM);
    pet.nextthink = 0.1;
    if (random() < 0.5)
    {
        pet.velocity_z =  200 + 100*random();
        pet.think = pet_die1;
    }
    else
        pet.think = pet_dieb1;
};

//----------------------------------------------------/ New Code /--------//
//  This severs the link from a dying pet to its master.
//------------------------------------------------------------------------//
void(entity pet) PM_PetSeverLink =
{
    if (pet == pet.master.draco)
    {
        PM_DracoTalk (pet, "...");
        pet.master.draco = world;
        PM_ClearDracoFlags (pet.master);
    }
    else
    {
        ryucount = ryucount - 1;
    }

    pet.master = world;
};

//----------------------------------------------------/ New Code /--------//
//  This destroys the dragon familiar.
//------------------------------------------------------------------------//
void(entity pet) PM_DestroyPet =
{
    // If the dragon had extra goal entities, remove them!
    PM_RemoveWaterGoal (pet);
    PM_RemoveNode (pet);

    // Remove any items and glowing effects.
    pet.items = 0;
    pet.invincible_finished = 0;
    pet.invincible_time = 0;
    pet.super_damage_finished = 0;
    pet.super_time = 0;
    pet.effects = pet.effects - (pet.effects & EF_DIMLIGHT);

    // Sever link from master then die.
    PM_PetSeverLink (pet);

    // If non-solid. just disappear.
    if (PM_PetHiding (pet))
    {
        pet.nextthink = 0.1;
        pet.think = SUB_Remove;
        return;
    }

    // Just die normally.
    if (pet.health < -40)
        PM_PetDisintegrate (pet);
    else
        PM_PetFallDead (pet);
};

//----------------------------------------------------/ New Code /--------//
//  This kills a player's pet dragon immediately regardless of health
//  or protection.
//------------------------------------------------------------------------//
void(entity pet, float explode) PM_InstantKillPet =
{
    // Check if pet is alive.  Killed pets do not have masters.
    if (!pet.master)
        return;

    // Kill dragon outright!
    if (explode)
        pet.health      = -99;
    else
        pet.health      = 0;
    pet.takedamage  = DAMAGE_NO;
    pet.touch       = SUB_Null;

    if (pet.flags & FL_FLY)
        pet.flags = pet.flags - FL_FLY;
    if (pet.flags & FL_SWIM)
        pet.flags = pet.flags - FL_SWIM;

    PM_DestroyPet (pet);
};

//----------------------------------------------------/ New Code /--------//
//  This kills a player's pet dragon named Draco.
//------------------------------------------------------------------------//
void(entity client, float explode) PM_KillDraco =
{
    if (client.petflags & PET_ALIVE)
    {
        if (!client.draco)
        {
            PM_ClearDracoFlags (client);
            return;
        }

        PM_InstantKillPet (client.draco, explode);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This kills all of the player's minor familiars.  Draco is ignored.
//------------------------------------------------------------------------//
void(entity client, float explode) PM_KillAllMinors =
{
    local   entity  head;

    head = nextent(world);
    while (head)
    {
        if (head != client.draco)
            if (head.master == client)
                PM_InstantKillPet (head, explode);

        head = nextent(head);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This kills Draco and any other familiar the player has.
//------------------------------------------------------------------------//
void(entity client, float explode) PM_KillAllPets =
{
    PM_KillDraco (client, explode);
    PM_KillAllMinors (client, explode);
};


//===========================/  END OF FILE  /===========================//
