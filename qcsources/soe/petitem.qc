//==========================================================================
//  petitem.qc -- by Patrick Martin             Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that adds a new powerup item that gives
//  the player a pet dragon that fights for its master.
//==========================================================================

// Prototypes in items.qc.
void() SUB_regen;


//==========================================================================
//  Pet Creation

//----------------------------------------------------/ New Code /--------//
//  This defines all of the pet dragon's attributes then sends it off.
//  The pet dragon is constructed and appears facing the player.
//------------------------------------------------------------------------//
void(vector org) PM_PetGo =
{
//----------------------//
//  Go to spawn point.  //
//----------------------//
    setorigin (self, org);

    // Make the dragon face its master.
    self.angles_x   = 0;
    self.angles_y   = vectoyaw(self.master.origin - self.origin);
    self.angles_z   = 0;
    self.fixangle   = TRUE;

    // The dragon shall appear now.
    spawn_tfog (self.origin);

//----------------------//
//  Define the dragon.  //
//----------------------//
    // SIZE
    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_SLIDEBOX;

    self.height     = SIZE_SMALL;
    setmodel (self, "progs/dragon2.mdl");
    setsize (self, VEC_RYU2_MIN, VEC_RYU2_MAX);

    // HEALTH / IQ
    PM_SetRegeneration (self, 1);   // Regenerate 1 hp/sec.
    self.max_health = 100;
    self.state      = IQ_HIGH;
    self.health     = self.max_health;
    if (self == self.master.draco)
    {
        // Draco is smarter and tougher than the rest.
        local   float   level;

        level = PM_TruePetLevel (self);
        PM_SetRegeneration (self, level);

        self.state      = IQ_GENIUS;
        PM_DragonAddArmor (self, 0);
    }

    // ITEMS (invulnerability/quad)
    self.items = 0;
    self.invincible_finished = 0;
    self.invincible_time = 0;
    self.super_damage_finished = 0;
    self.super_time = 0;

    // SPAWNFLAGS
    self.spawnflags = 0;    // Pet dragons have no spawnflags.

    // SPEED
    self.speed      = 32;   // This is about as fast as the player.

    // TURNING SPEED
    self.yaw_speed  = 20;   // Same as walkmonster default.

    // PAIN THRESHOLD
    PM_InitThreshold (self, 3);     // Time dragon ignores other attackers.

    // ACTIONS
    self.th_stand   = pet_hoverstart;
    self.th_walk    = pet_walkstart;
    self.th_run     = pet_run1;
    self.th_melee   = pet_strike;
    self.th_missile = pet_missile1;
    self.th_pain    = pet_pain;
    self.th_die     = pet_die;

    self.classname  = "monster_dragon";

//--------------//
//  Dragon Go!  //
//--------------//
    self.touch      = PM_PetTouch;
    self.axhitme    = 0;
    self.dodge_back = 0;
    self.slide_away = 0;
    self.slide_rand = 0;
    self.stalled    = 0;
    self.takedamage = DAMAGE_AIM;
    self.ideal_yaw  = self.angles * '0 1 0';
    self.view_ofs   = '0 0 10';
    self.petofs     = OFFSET_LEVEL;
    self.flags      = self.flags | FL_FLY | FL_MONSTER;

    PM_NegateWaterFear ();      // Will be updated by AI functions later.

    self.enemy = self.oldenemy = world;

    if (self == self.master.draco)
    {
        self.master.petflags = self.master.petflags | PET_READY;
        if (self.master.petflags & PET_STAY)
            self.th_stand();
        else
            self.th_walk();
    }
    else
        self.th_walk();
};

//----------------------------------------------------/ New Code /--------//
//  This tries to create the pet dragon.
//------------------------------------------------------------------------//
void() PM_CreatePet =
{
    // If master is dead, simply remove the dragon.
    if (self.master.health <= 0)
    {
        self.master.draco = world;
        remove (self);
        return;
    }

    local   vector  spot;

    // Set the size of the pet dragon, then check if it can appear.
    setsize (self, VEC_RYU2_MIN, VEC_RYU2_MAX);
    spot = PM_PetSpot5 (self);
    if (spot == self.master.origin)
    {
        // No valid spawn point was found.  Try again one second later.
        self.nextthink   = time + 1;
        self.think       = PM_CreatePet;
        return;
    }

    // Construct the dragon.
    PM_PetGo (spot);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the given the dragon's skin/type is valid.
//  If it is, return it.  If not, choose one that is and return it.
//------------------------------------------------------------------------//
float(float type) PM_CheckPetType =
{
    // If type is not given, default to red dragon.
    if (!type)
        return SKIN_RED;

    // Drop any fractions.
    type = floor(type);

    // Unknown types default to the red dragon.
    if (type > 3)
        return SKIN_RED;
    if (type < 0)
        return SKIN_RED;

    // Type given is valid.
    return type;
};

//----------------------------------------------------/ New Code /--------//
//  This sets the pet dragon's skin and flags it.
//------------------------------------------------------------------------//
void(entity client, entity pet, float type) PM_SetPetSkin =
{
    pet.skin = PM_CheckPetType (type);
    if (pet == client.draco)
    {
        client.petflags = client.petflags - (client.petflags & PET_SKIN);
        client.petflags = client.petflags | pet.skin;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the limit of minor familiars is reached.
//------------------------------------------------------------------------//
float(entity client) PM_MaxPets =
{
    // Only one dragon (as Draco) per player in netgames.
    if (coop)
        return TRUE;
    if (deathmatch)
        return TRUE;

    // Check if max familiars has been reached.
    if (ryucount >= MAX_FAMILIARS)
        return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This creates a brand new small dragon for a player.
//------------------------------------------------------------------------//
float(entity client, float prime, float type) PM_SpawnPet =
{
    // Check if we are allowed to add another dragon in the level.
    if (prime)
    {
        // Both checks should pass.  If not, there is a bug somewhere.
        if (client.draco)
        {
            sprint (client, "WARNING:  Already have Draco.\n");
            return FALSE;
        }
        if (!(client.petflags & PET_ALIVE))
        {
            sprint (client, "WARNING:  Level not set.\n");
            return FALSE;
        }
    }
    else
    {
        // Check if we can add more minor familiars.
        if (PM_MaxPets (client))
            return FALSE;
    }

    // Begin creation process.
    local   entity  pet;
    local   vector  org;

    pet = spawn();
    setmodel (pet, "");
    setsize (pet, VEC_RYU2_MIN, VEC_RYU2_MAX);        
    setorigin (pet, '0 0 0');
    pet.takedamage  = DAMAGE_NO;
    pet.movetype    = MOVETYPE_NONE;
    pet.touch       = SUB_Null;
    pet.solid       = SOLID_NOT;

    pet.master      = client;

    if (prime)
        client.draco    = pet;
    else
        ryucount = ryucount + 1;

    PM_SetPetSkin (client, pet, type);

    pet.nextthink   = 0.1;      // ASAP
    pet.think       = PM_CreatePet;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This heals dragon back up to full strength and changes its type.
//------------------------------------------------------------------------//
void(entity client, float type) PM_RechargeDraco =
{
    if (client.draco)
    {
        // Heal and change types.
        client.draco.health = client.draco.max_health;
        PM_DragonAddArmor (client.draco, 0);
        PM_SetPetSkin (client, client.draco, type);
        PM_KillFire (client.draco);
    }
    else
    {
        // Draco does not exist yet so create him.
        PM_SpawnPet (client, TRUE, type);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This increases the power (or experience) level of Draco.
//------------------------------------------------------------------------//
void(entity client, float power) PM_LevelUpDraco =
{
    local   float   level;
    local   float   maxed;
    local   float   no_msg;

    level = ((client.petflags & PET_ALIVE) / PET_LEVEL1);
    maxed = PET_LEVELMAX / PET_LEVEL1;
    no_msg = FALSE;

    if (level >= maxed)
        return;         // Already maxed out.

    if (level < 1)
        no_msg = TRUE;  // Draco's first appearance.

    level = level + power;
    if (level > maxed)
        level = maxed;

    client.petflags = client.petflags - (client.petflags & PET_ALIVE);
    client.petflags = client.petflags | (level * PET_LEVEL1);

    // Reset regeneration rate.
    if (client.draco)
        PM_SetRegeneration (client.draco, level);

    if (no_msg)
        return;     // Don't display level up message.

    // Display Draco's level.
    local   string  text;

    text = ftos(level);
    sprint (client, "Draco is now at level ");
    sprint (client, text);
    sprint (client, "\n");
};

//----------------------------------------------------/ New Code /--------//
//  This powers up a dragon familiar.  Currently, the player can have
//  only one permanent familiar, Draco.
//------------------------------------------------------------------------//
void(entity client, float type, float power) PM_PowerupDraco =
{
    if ((client.petflags & PET_ALIVE) >= PET_LEVELMAX)
    {
        // Already maxed out -- just heal Draco only.
        sprint (client, "Draco feels refreshed\n");
        PM_RechargeDraco (client, type);
        return;
    }

    if (!(client.petflags & PET_ALIVE))
        sprint (client, "Draco befriends you\n");   // 1st appearance.

    PM_LevelUpDraco (client, power);
    PM_RechargeDraco (client, type);
};


//==========================================================================
//  Dragon Powerup Teleport

//----------------------------------------------------/ New Code /--------//
//  This teleports a single dragon to near its master.  If the dragon
//  cannot do that, it vanishes then reappear when possible.
//------------------------------------------------------------------------//
void(entity pet) PM_PowWarpGo =
{
    // Don't warp if not ready.
    if (PM_PetHiding (pet))
        return;

    // Try to teleport for real.
    if (PM_PetComeHere (pet, FALSE))
        return;

    // Can't teleport near master now?  Disappear then try again later.
    PM_PetDisappear (pet, 1);
};

//----------------------------------------------------/ New Code /--------//
//  This teleports all a player's dragons to him.  This mass teleport
//  does not weaken any of the dragons and should be called only when
//  the player touches a dragon item.  Also, Draco is teleported first
//  then any extra dragons.
//
//  Why teleport existing dragons to players when a dragon item was
//  touched?  Reasons:  The dragon item was likely placed strategically
//  by the level designer, and the player would need the dragons there
//  now.  Also, new dragons are spawned near a player.
//------------------------------------------------------------------------//
void(entity client) PM_PowWarpAll =
{
    // Teleport Draco first.
    if (client.draco)
        PM_PowWarpGo (client.draco);

    // Teleport all minor familiars.
    local   entity  head;

    head = nextent(world);
    while (head)
    {
        if (head != client.draco)
            if (head.master == client)
                PM_PowWarpGo (head);
        head = nextent(head);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon should be teleported to its master upon
//  item pickup.
//------------------------------------------------------------------------//
float(entity pet) PM_PowWarpCheck =
{
    // Teleport if too far away from master.
    if (vlen(pet.origin - pet.master.origin) > 500)
        return TRUE;

    // Teleport if separated from master by an obstacle.
    if (PM_PetSpotBlocked (pet, pet.origin))
        return TRUE;

    // Teleporting will make the dragon loyal again.
    if (PM_PetGoneBad (pet))
        return TRUE;

    // No need to teleport.
    return FALSE;
};


//==========================================================================
//  Dragon Item Definition

//----------------------------------------------------/ New Code /--------//
//  This precaches all the .mdls and .wavs used by the pet dragon.
//------------------------------------------------------------------------//
void() PM_PrecacheDraco =
{
    precache_model2 ("progs/draco.mdl");    // Dragon item
    precache_model2 ("progs/dragon2.mdl");  // Small dragon model
    precache_model2 ("progs/flame2.mdl");   // Flames
    precache_model2 ("progs/ice.mdl");      // Ice shards
    precache_model2 ("progs/lwing.mdl");    // Gib (left wing)
    precache_model2 ("progs/rwing.mdl");    // Gib (right wing)
    precache_model2 ("progs/tail.mdl");     // Gib (tail)

	precache_model2 ("progs/horn.mdl"); // for item - SoE
	precache_sound2 ("hipitems/horn.wav");

    precache_sound2 ("demon/dhit2.wav");
    precache_sound2 ("dragon/death2.wav");
    precache_sound2 ("dragon/eat.wav");
    precache_sound2 ("dragon/eathead.wav");
    precache_sound2 ("dragon/fire.wav");
    precache_sound2 ("dragon/firehit.wav");
    precache_sound2 ("dragon/ice.wav");
    precache_sound2 ("dragon/icehit.wav");
    precache_sound2 ("dragon/idle2.wav");
    precache_sound2 ("dragon/fly.wav");
    precache_sound2 ("dragon/pain2.wav");
    precache_sound2 ("dragon/sight2.wav");
    precache_sound2 ("dragon/thunder.wav");
    precache_sound  ("hknight/hit.wav");        // used by c code
};

//----------------------------------------------------/ New Code /--------//
//  This changes the skin on the dragon item.
//------------------------------------------------------------------------//
void() draco_change =
{
    local   float   type;

    // Advance to the next type.
    type = self.skin + 1;

    // If next type is gold, check if it is allowed.
    if (type == SKIN_GOLD)
        if (!self.aflag)
            type = type + 1;    // Not allowed, pass.

    // If new type does not exist, start over with the red dragon.
    if (type > 3)
        type = 0;

    // Change skin.  Do it again soon.
    self.skin = type;
    self.nextthink = time + CYCLE_TIME;
};

//----------------------------------------------------/ New Code /--------//
//  This respawns the dragon item.
//------------------------------------------------------------------------//
void() draco_regen =
{
    // Do standard item respawn code.
    SUB_regen ();

    // Extra stuff.
    if (self.style)
        spawn_tfog (self.origin);

    if (self.spawnflags & DRACO_CYCLE)
    {
        // Advance to the next type.
        self.think = draco_change;
        draco_change ();
    }
};

//----------------------------------------------------/ New Code /--------//
//  This is called when a player touches the dragon powerup.
//
//  If the player does not have any pets, the powerup will create
//  one small dragon that will fight for the player.
//
//  If the player already owns a dragon, the powerup will heal the dragon
//  back to full health, change the dragon's skin to match the item's
//  skin (if necessary), and increase its level by one.
//------------------------------------------------------------------------//
void() draco_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

//    sprint (other, "You got a dragon\n");
    if (deathmatch || (self.spawnflags & DRACO_RESPAWN))
    {
        self.mdl       = self.model;
        self.nextthink = time + 60;
        self.think     = draco_regen;
	}	
	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;

    // do the apropriate action

    // Check to teleport Draco to its master.  Do this before powerup.
    if (other.draco)
        if (PM_PowWarpCheck (other.draco))
            PM_PowWarpGo (other.draco);

    // Powerup Draco.  Big items give greater boosts, much like ammo.
    if (self.spawnflags & DRACO_BIG)
        PM_PowerupDraco (other, self.skin, 2);
    else
        PM_PowerupDraco (other, self.skin, 1);

    activator = other;
    SUB_UseTargets();       // fire all targets / killtargets
};

//----------------------------------------------------/ New Code /--------//
//  This places the dragon item on the level.
//------------------------------------------------------------------------//
void() PM_PlaceDraco =
{
    // Similar to 'PlaceItem'.
	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;	
	self.velocity = '0 0 0';

    // Hidden dragons don't use 'droptofloor' because entities like
    // players or monsters may cross its space as it appears.
    if (!(self.spawnflags & SPAWN_HIDDEN))
    {
        self.origin_z = self.origin_z + 6;
        if (!droptofloor())
        {
            dprint ("Bonus item fell out of level at ");
            dprint (vtos(self.origin));
            dprint ("\n");
            remove(self);
            return;
        }
    }

    if (self.spawnflags & DRACO_CYCLE)
    {
        self.nextthink = time + CYCLE_TIME;
        self.think = draco_change;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This prepares the dragon item to be placed on the level.
//------------------------------------------------------------------------//
void() PM_StartDraco =
{
    if (self.spawnflags & SPAWN_HIDDEN)
    {
        // Just used, so do this immediately.
        PM_PlaceDraco ();
        return;
    }

    // Similar to 'StartItem'.
    self.nextthink = time + 0.2;    // items start after other solids
    self.think = PM_PlaceDraco;
};

//----------------------------------------------------/ New Code /--------//
//  This defines the dragon powerup.
//------------------------------------------------------------------------//
void() draco_spawn =
{
    self.touch = draco_touch;

//    self.noise = "dragon/sight2.wav";
//    setmodel (self, "progs/draco.mdl");
    self.noise = "hipitems/horn.wav";
    setmodel (self, "progs/horn.mdl");
    self.netname = "Dragon";

    // This verifys the skin assigned to the dragon item.
    if (!self.skin)
        self.skin = SKIN_RED;
    self.skin = floor(self.skin);

    if (self.skin < 0)
        self.skin = 0;
    else if (self.skin > 3)
        self.skin = 0;

    // This is for dragon items with cycling types.
    if (self.skin == SKIN_GOLD)
        self.aflag = TRUE;      // All types.
    else
        self.aflag = FALSE;     // Red, white, and blue only.

    // Check for big powerup.
//    if (self.spawnflags & DRACO_BIG)
//    {
//        self.frame = 1;
//        setsize (self, '-32 -32 -24', '32 32 40');
//    }
//    else
    {
        self.frame = 0;
        setsize (self, '-16 -16 -24', '16 16 32');
    }

    PM_StartDraco ();
};

//----------------------------------------------------/ New Code /--------//
//  This reveals a previously hidden dragon item.
//------------------------------------------------------------------------//
void() draco_start =
{
    self.use = SUB_Null;
    spawn_tfog (self.origin);
    draco_spawn ();
};

//----------------------------------------------------/ New Code /--------//
//  This starts the dragon powerup.
//------------------------------------------------------------------------//
void() draco_define =
{
    if (self.spawnflags & SPAWN_HIDDEN)
    {
        // FIXME:  If item is in the wall or sky, remove it.
        self.use = draco_start;
        return;
    }
    draco_spawn ();
};

//----------------------------------------------------/ New Code /--------//
//  This spawns the dragon powerup.
//------------------------------------------------------------------------//
/*QUAKED item_dragon (0 .5 .8) (-16 -16 -24) (16 16 32) Big Cycle
Player gets a dragon familiar.  Dragon fights for player.
*/
void() item_dragon =
{
	if (notHere()) // SoE
	{
		remove(self);
		return;
	}
    PM_PrecacheDraco ();
    draco_define ();
};


//==========================================================================
//  Pet Management

//----------------------------------------------------/ New Code /--------//
//  This checks if player has Draco.
//------------------------------------------------------------------------//
float(entity client) PM_HasPermanentDragon =
{
    if (client.petflags & PET_ALIVE)
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This returns the dragon's true level of power.  The Shiva flag,
//  which makes the dragon stronger than max level, is ignored.
//------------------------------------------------------------------------//
float(entity pet) PM_TruePetLevel =
{
    if (pet == pet.master.draco)
        return ((pet.master.petflags & PET_ALIVE) / PET_LEVEL1);

    return 2; //SoE: used to be 1.
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon has the Shiva (cheat) flag.
//------------------------------------------------------------------------//
float(entity pet) PM_ImmortalDragon =
{
    if (pet == pet.master.draco)
        return (pet.master.petflags & PET_SHIVA);

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the carry over of the dragon should be delayed.
//------------------------------------------------------------------------//
float(entity client) PM_DelayCarry =
{
    // Don't appear during a cutscene.
    if (PM_InCutscene (client))
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This spawns a new pet dragon with the same powers as the one from the
//  last level.  In effect, it follows its master from level to level.
//------------------------------------------------------------------------//
void() PM_RespawnPet =
{
    if (!self.owner.draco)
    {
        if (self.owner.petflags & PET_ALIVE)
        {
            if (!PM_Intermission ())
            {
                if (PM_DelayCarry (self.owner))
                {
                    self.nextthink = time + 1;
                    return;
                }

                local   float   type;

                type = self.owner.petflags & PET_SKIN;
                PM_SpawnPet (self.owner, TRUE, type);
            }
        }
        else
        {
            PM_ClearDracoFlags (self.owner);
        }
    }

    remove (self);
};

//----------------------------------------------------/ New Code /--------//
//  This creates a entity that will spawn a pet dragon soon.
//  This is used to transport pet dragons from level to level.
//------------------------------------------------------------------------//
void() PM_CarryPetDragon =
{
    local   entity  ent;

    ent = spawn();
    setmodel (ent, "");
    setsize (ent, '0 0 0', '0 0 0');        
    setorigin (ent, self.origin);

    ent.movetype  = MOVETYPE_NONE;
    ent.solid     = SOLID_NOT;
    ent.velocity  = '0 0 0';
    ent.touch     = SUB_Null;
    ent.owner     = self;
    ent.nextthink = time + 0.5 + random();
    ent.think     = PM_RespawnPet;
};


//==========================================================================
//  Pet Exodus

//----------------------------------------------------/ New Code /--------//
//  This makes a single dragon familiar 'exit' the level.
//------------------------------------------------------------------------//
void(entity pet) PM_PetExit =
{
    if (pet.master.classname != "player")
        return;

    // Make a teleport splash if not already hiding.
    if (pet == pet.master.draco)
    {
        // Draco.
        if (pet.master.petflags & PET_READY)
        {
            pet.master.petflags = pet.master.petflags - PET_READY;
            spawn_tfog (pet.origin);
        }
    }
    else
    {
        // No-name minor dragon.
        if (!PM_PetHiding (pet))
            spawn_tfog (pet.origin);
    }

    PM_KillFire (pet);
    pet.movetype   = MOVETYPE_NONE;
    pet.takedamage = DAMAGE_NO;
    pet.solid      = SOLID_NOT;
    pet.touch      = SUB_Null;
    pet.think      = SUB_Null;
    pet.nextthink  = -1;
    setmodel (pet, "");
    setorigin (pet, pet.master.origin);
};

//----------------------------------------------------/ New Code /--------//
//  This makes all dragons familiars 'exit' the level.
//------------------------------------------------------------------------//
void() PM_ExitAllPets =
{
    local   entity  head;

    head = nextent(world);
    while (head)
    {
        if (head.master.classname == "player")
            PM_PetExit (head);
        head = nextent (head);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This automatically promotes a minor dragon to permanent status
//  for all players with minor dragons, but not Draco.  This should
//  be called only before a level change.
//------------------------------------------------------------------------//
void() PM_AutoPromote =
{
    local   entity  head;

    head = nextent(world);
    while (head)
    {
        if (head.master.classname == "player")
            if (!(head.master.petflags & PET_ALIVE))
                if (head.classname == "monster_dragon")
                {
                    ryucount = ryucount - 1;
                    head.master.petflags    = head.master.petflags -
                        (head.master.petflags & PET_SKIN);
                    head.master.petflags    = head.master.petflags |
                        head.skin | PET_LEVEL1;
                    head.master.draco       = head;
                    head.master.draco.state = IQ_GENIUS;
                }

        head = nextent(head);
    }
};


//==========================================================================
//  Pet Items

//----------------------------------------------------/ New Code /--------//
//  Gives dragon quad damage if present on level.
//------------------------------------------------------------------------//
void (entity client) PM_PetQuad =
{
    if (client.petflags & PET_ALIVE)
        if (client.petflags & PET_READY)
            if (client.draco)
            {
                if (!client.draco.super_damage_finished)
                    PM_DracoTalk (client.draco, "Quad damage.  Woohoo!");

                client.draco.items = client.draco.items | IT_QUAD;
                client.draco.super_damage_finished = time + 30;
                client.draco.super_time = 1;
                client.draco.effects = client.draco.effects | EF_DIMLIGHT;
            }
};

//----------------------------------------------------/ New Code /--------//
//  Gives dragon invulnerability if present on level.
//------------------------------------------------------------------------//
void (entity client) PM_PetPent =
{
    if (client.petflags & PET_ALIVE)
        if (client.petflags & PET_READY)
            if (client.draco)
            {
                if (!client.draco.invincible_finished)
                    PM_DracoTalk (client.draco, "I am invincible!");

                client.draco.items = client.draco.items | IT_INVULNERABILITY;
                client.draco.invincible_finished = time + 30;
                client.draco.invincible_time = 1;
                client.draco.effects = client.draco.effects | EF_DIMLIGHT;
            }
};


//===========================/  END OF FILE  /===========================//
