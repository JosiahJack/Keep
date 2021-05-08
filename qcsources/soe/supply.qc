//==========================================================================
//  supply.qc -- by Patrick Martin              Last updated:  3-24-2001
//--------------------------------------------------------------------------
//  This file contains code that adds triggers that give health and/or
//  items to players.
//
//  FIXME:  In Dragons v4.0, this file is used only for the Dragons
//    test map, and it is not needed for the Dragons patch itself.
//    If this file is added, 'PM_AllowResupply (self);' is needed
//    for the first line in the function 'respawn()' in 'client.qc',
//    so that the supply entities work properly in netgames.
//==========================================================================

//--------------------//
//  NEW EDICT FIELDS  //
//--------------------//
.float  supply_time;

//--------------//
//  PROTOTYPES  //
//--------------//
void() W_SetCurrentAmmo;


//==========================================================================
//  Trigger:  Supply

//----------------------------------------------------/ New Code /--------//
//  This allows a player to use a supply trigger.
//------------------------------------------------------------------------//
void(entity ent) PM_AllowResupply =
{
    ent.supply_time = 0;
};

//----------------------------------------------------/ New Code /--------//
//  This rots the megahealth given by a supply trigger.
//------------------------------------------------------------------------//
void() PM_HealthRotThink =
{
    local   entity  targ;

    targ = self.owner;

    if (targ.health > targ.max_health)
	{
        targ.health = targ.health - 1;
		self.nextthink = time + 1;
		return;
	}

    // Done rotting.
    targ.items = targ.items - (targ.items & IT_SUPERHEALTH);
    remove (self);
};

//----------------------------------------------------/ New Code /--------//
//  This creates a dummy entity that rots megahealth given by a
//  supply trigger.
//------------------------------------------------------------------------//
void(entity ent, entity base) PM_SpawnHealthRot =
{
    local   entity  rot;

    rot = spawn();
    setmodel (rot, "");
    setsize (rot, '0 0 0', '0 0 0');        
    setorigin (rot, base.origin);

    rot.movetype    = MOVETYPE_NONE;
    rot.solid       = SOLID_NOT;
    rot.velocity    = '0 0 0';
    rot.owner       = ent;
    rot.touch       = SUB_Null;
    rot.nextthink   = time + 5;
    rot.think       = PM_HealthRotThink;
};

//----------------------------------------------------/ New Code /--------//
//  This returns the new current weapon to be used by the player.
//------------------------------------------------------------------------//
float(entity ent, float wep) PM_SupplyChangeWeapon =
{
    // No flag, no weapon.
    if (!wep)
        return 0;

    // Check for weapons.
    if (ent.ammo_shells > 0)
    {
        if (wep == IT_SHOTGUN)
            if (ent.items & IT_SHOTGUN)
                return IT_SHOTGUN;

        if (wep == IT_SUPER_SHOTGUN)
            if (ent.items & IT_SUPER_SHOTGUN)
                return IT_SUPER_SHOTGUN;
    }
    if (ent.ammo_nails > 0)
    {
        if (wep == IT_NAILGUN)
            if (ent.items & IT_NAILGUN)
                return IT_NAILGUN;

        if (wep == IT_SUPER_NAILGUN)
            if (ent.items & IT_SUPER_NAILGUN)
                return IT_SUPER_NAILGUN;
    }
    if (ent.ammo_rockets > 0)
    {
        if (wep == IT_GRENADE_LAUNCHER)
            if (ent.items & IT_GRENADE_LAUNCHER)
                return IT_GRENADE_LAUNCHER;

        if (wep == IT_ROCKET_LAUNCHER)
            if (ent.items & IT_ROCKET_LAUNCHER)
                return IT_ROCKET_LAUNCHER;
    }
    if (ent.ammo_cells > 0)
    {
        if (wep == IT_LIGHTNING)
            if (ent.items & IT_LIGHTNING)
                return IT_LIGHTNING;
    }

    if (wep == IT_AXE)
        if (ent.items & IT_AXE)
            return IT_AXE;

    // No need to change weapons.
    return 0;
};

//----------------------------------------------------/ New Code /--------//
//  This restores life to a player and his familiar.
//------------------------------------------------------------------------//
void(entity ent) PM_SupplyHeal =
{
    if (ent.health <= 0)
        return;     // Dead -- don't heal!

    // (Napalm/Dragons):  Put out the fire.
    PM_KillFire (ent);

    // Max out health.
    if (ent.health < ent.max_health)
        ent.health = ent.max_health;

    // (Dragons):  Heal ent's permanent familiar too.
    if (ent.draco)
    {
        PM_KillFire (ent.draco);
        if (ent.draco.health < ent.draco.max_health)
            ent.draco.health = ent.draco.max_health;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This gives health and items to the player that touched the supply
//  trigger.
//------------------------------------------------------------------------//
void(entity ent, entity base) PM_GiveSupplies =
{
    // Restore health.
    PM_SupplyHeal (ent);

    // Give ammo.
    if (base.ammo_shells > 0)
        ent.ammo_shells = ent.ammo_shells + base.ammo_shells;
    if (base.ammo_nails > 0)
        ent.ammo_nails = ent.ammo_nails + base.ammo_nails;
    if (base.ammo_rockets > 0)
        ent.ammo_rockets = ent.ammo_rockets + base.ammo_rockets;
    if (base.ammo_cells > 0)
        ent.ammo_cells = ent.ammo_cells + base.ammo_cells;

    // Bind ammo to the max if player has too much.
    if (ent.ammo_shells > 100)
        ent.ammo_shells = 100;
    if (ent.ammo_nails > 200)
        ent.ammo_nails = 200;
    if (ent.ammo_rockets > 100)
        ent.ammo_rockets = 100;    
    if (ent.ammo_cells > 100)
        ent.ammo_cells = 100;  

    // Give weapons and keys.
    ent.items = ent.items | (base.items & (IT_AXE | IT_SHOTGUN |
        IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN |
        IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING |
        IT_KEY1 | IT_KEY2));

    // Give armor.
    if (base.items & IT_ARMOR3)
    {
        ent.items       = ent.items - (ent.items & (IT_ARMOR1 | IT_ARMOR2));
        ent.items       = ent.items | IT_ARMOR3;
        ent.armorvalue  = 200;
        ent.armortype   = 0.8;
    }
    else if (base.items & IT_ARMOR2)
    {
        // NOTE:  150 * 0.6 = 90.
        if ((ent.armorvalue * ent.armortype) < 90)
        {
            ent.items       = ent.items - (ent.items & (IT_ARMOR1 | IT_ARMOR3));
            ent.items       = ent.items | IT_ARMOR2;
            ent.armorvalue  = 150;
            ent.armortype   = 0.6;
        }
    }
    else if (base.items & IT_ARMOR1)
    {
        // NOTE:  100 * 0.3 = 30.
        if ((ent.armorvalue * ent.armortype) < 30)
        {
            ent.items       = ent.items - (ent.items & (IT_ARMOR2 | IT_ARMOR3));
            ent.items       = ent.items | IT_ARMOR1;
            ent.armorvalue  = 100;
            ent.armortype   = 0.3;
        }
    }

    // Give Megahealth
    if (base.items & IT_SUPERHEALTH)
    {
        local   float   maxlife;

        maxlife = ent.max_health + 150;

        if (ent.health < maxlife)
        {
            ent.health = ent.health + 100;
            if (ent.health > maxlife)
                ent.health = maxlife;

            ent.items = ent.items | IT_SUPERHEALTH;
            PM_SpawnHealthRot (ent, base);
        }
    }

    // Give Powerups.
    if (base.items & IT_INVISIBILITY)
    {
        ent.invisible_time = 1;
        ent.invisible_finished = time + 30;
        ent.items = ent.items | IT_INVISIBILITY;
    }
    if (base.items & IT_INVULNERABILITY)
    {
        ent.invincible_time = 1;
        ent.invincible_finished = time + 30;
        ent.items = ent.items | IT_INVULNERABILITY;
    }
    if (base.items & IT_SUIT)
    {
        ent.rad_time = 1;
        ent.radsuit_finished = time + 30;
        ent.items = ent.items | IT_SUIT;
    }
    if (base.items & IT_QUAD)
    {
        ent.super_time = 1;
        ent.super_damage_finished = time + 30;
        ent.items = ent.items | IT_QUAD;
    }

    // Change weapons if necessary.
    local   float   wep;
    local   entity  oldself;

    wep = PM_SupplyChangeWeapon (ent, base.weapon);
    oldself = self;
    self = ent;
    if (wep)
        self.weapon = wep;
    W_SetCurrentAmmo ();
    self = oldself;
};

//----------------------------------------------------/ New Code /--------//
//  This gives health and items to the player that activated the
//  supply trigger.
//------------------------------------------------------------------------//
void() supply_trigger =
{
    if (self.nextthink > time)
        return;     // Already triggered.

    // Check if player used a supply trigger recently.
    if (other.supply_time == -1)
        return;
    if (other.supply_time > time)
        return;

    // Give items to players...
    if (other.classname == "player")
        if (other.health > 0)
        {
            PM_GiveSupplies (other, self);
            stuffcmd (other, "bf\n");
            if (self.count)
            {
                // Don't let player recharge again for a while.
                if (self.count < 0)
                    other.supply_time = -1;     // Once only.
                else
                    other.supply_time = time + self.count;
            }
        }

    if (self.noise)
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	activator = self.enemy;
	
    SUB_UseTargets ();

	if (self.wait > 0)	
	{
        self.think      = SUB_Null;
        self.nextthink  = time + self.wait;
	}
	else
    {
        // We can't just remove (self) here, because this is a touch
        // function called while C code is looping through area links...
        self.touch      = SUB_Null;
        self.nextthink  = time + 0.1;
        self.think      = SUB_Remove;
	}
};

//----------------------------------------------------/ New Code /--------//
//  This tries to activate a supply trigger that was just touched.
//------------------------------------------------------------------------//
void() supply_touch =
{
    // Must be a player.
	if (other.classname != "player")
		return;

    // Must be alive.
    if (other.health <= 0)
        return;
	
    // If the trigger has an angles field, check player's facing direction.
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
            return;     // Not facing the right way.
	}
	
	self.enemy = other;
    supply_trigger ();
};

//----------------------------------------------------/ New Code /--------//
//  This precaches and sets the sounds used by the supply trigger
//  and by any items the supply trigger gives.
//------------------------------------------------------------------------//
void(entity ent) PM_SupplySounds =
{
    // Precache any sounds needed by items.
    if (ent.items & IT_INVISIBILITY)
    {
        precache_sound ("items/inv2.wav");
        precache_sound ("items/inv3.wav");
    }
    if (ent.items & IT_INVULNERABILITY)
    {
        precache_sound ("items/protect2.wav");
        precache_sound ("items/protect3.wav");
    }
    if (ent.items & IT_SUIT)
    {
        precache_sound ("items/suit2.wav");
    }
    if (ent.items & IT_QUAD)
    {
        precache_sound ("items/damage2.wav");
        precache_sound ("items/damage3.wav");
    }

    // Set message sound.
    if (ent.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
        ent.noise = "misc/secret.wav";
	}
    else if (ent.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
        ent.noise = "misc/talk.wav";
	}
    else if (ent.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
        ent.noise = "misc/trigger1.wav";
	}
    else if (ent.sounds == 4)
	{
        precache_sound ("items/protect2.wav");
        ent.noise = "items/protect2.wav";
	}
    else if (ent.sounds == 5)
	{
        precache_sound ("items/protect3.wav");
        ent.noise = "items/protect3.wav";
	}
    else if (ent.sounds == 6)
	{
        precache_sound ("weapons/lstart.wav");
        ent.noise = "weapons/lstart.wav";
	}
};

//----------------------------------------------------/ New Code /--------//
//  This creates the supply trigger.

/* QUAKED trigger_supply (.5 .5 .5) ?
Variable sized repeatable touch-only trigger that gives a player
health and items.
sounds
1)	secret
2)	beep beep
3)	large switch
4)  pentagram fade
5)  pentagram repel
6)  thunder
7)  NULL
set "message" to text string
*/
//------------------------------------------------------------------------//
void() trigger_supply =
{
    PM_SupplySounds (self);

	if (!self.wait)
		self.wait = 0.2;
    else if (self.wait < 0)
        self.wait = -1;

    if (self.count < 0)
        self.count = -1;

    self.takedamage = DAMAGE_NO;
    self.use = SUB_Null;

	InitTrigger ();

    self.touch = supply_touch;
};


//==========================================================================
//  Trigger:  Supply Change

//----------------------------------------------------/ New Code /--------//
//  This changes the items of an existing supply trigger.
//------------------------------------------------------------------------//
void() supply_change =
{
    local   entity  ent;

    // Change targeted supply triggers.
    ent = find (world, targetname, self.target);
    while (ent)
    {
        ent.ammo_shells     = self.ammo_shells;
        ent.ammo_nails      = self.ammo_nails;
        ent.ammo_rockets    = self.ammo_rockets;
        ent.ammo_cells      = self.ammo_cells;

        ent.items   = self.items;
        ent.weapon  = self.weapon;

        if (self.message)
            ent.message = self.message;
        if (self.noise)
            ent.noise   = self.noise;

        if (ent.nextthink > time)
            ent.nextthink = time;

        ent = find (ent, targetname, self.target);
    }

    // Let all players touch any supply trigger now.
    ent = find (world, classname, "player");
    while (ent)
    {
        PM_AllowResupply (ent);
        ent = find (ent, classname, "player");
    }
};

//----------------------------------------------------/ New Code /--------//
//  This creates the trigger that can change an existing supply trigger.

/*QUAKED trigger_removeflag (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by
other events.  This changes the items given by a supply trigger,
Players can then touch the altered supply trigger.
*/
//------------------------------------------------------------------------//
void() trigger_changesupply =
{
    if (!self.targetname)
    {
        dprint ("unreachable changesupply at: ");
        dprint (vtos (self.origin));
        dprint ("\n");
        remove (self);
        return;
    }
    if (!self.target)
    {
        dprint ("changesupply without target at: ");
        dprint (vtos (self.origin));
        dprint ("\n");
        remove (self);
        return;
    }

    PM_SupplySounds (self);

    InitTrigger ();
    self.takedamage = DAMAGE_NO;
    self.touch      = SUB_Null;
    self.use        = supply_change;
};


//==========================================================================
//  Trigger:  Heal All

//----------------------------------------------------/ New Code /--------//
//  This heals all players on the level back to full strength.
//------------------------------------------------------------------------//
void() healall_use =
{
    local   entity  ent;

    // Heal all players and their familiars.
    ent = find (world, classname, "player");
    while (ent)
    {
        if (ent.health >= 0)
        {
            PM_SupplyHeal (ent);
            stuffcmd (ent, "bf\n");
        }
        ent = find (ent, classname, "player");
    }
};

//----------------------------------------------------/ New Code /--------//
//  This creates the trigger that heals all players.

/*QUAKED trigger_healall (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by
other events.  This heals all players on the level back to full strength.
*/
//------------------------------------------------------------------------//
void() trigger_healall =
{
    if (!self.targetname)
    {
        dprint ("unreachable healall at: ");
        dprint (vtos (self.origin));
        dprint ("\n");
        remove (self);
        return;
    }

    InitTrigger ();
    self.takedamage = DAMAGE_NO;
    self.touch      = SUB_Null;
    self.use        = healall_use;
};


//===========================/  END OF FILE  /===========================//
