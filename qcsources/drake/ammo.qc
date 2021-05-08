//==========================================================================
//
//  AMMO
//
//==========================================================================

//- - - - - - - - -
float(float am) ShellGame =
{
    if (!q1shot)
    {   // Modified shotguns cause almost double (+83 to 93%) damage per shot,
        // so reduce shells given to 62.5%, rounded down.  (e.g., 40 -> 25.)
        // Remember, misses are to be expected.
        if (am)
        {   am = floor(am * 5 / 8);
            if (am < 1)
                return 1;
        }
    }
    return am;
};

void(entity ent, float am) Update_Cells =
{
//    if (!ent)
//        return;

// Set ammo.
    if (am < 0)
        am = 0;     // No negative cells!
    ent.ammo_cells = am;
    if (ent.flags & FL_CLIENT)
        if (ent.items & IT_CELLS)
            ent.currentammo = am;
// Check for power armor.
    if (ent.perms & POW_POWER_ARMOR)
        if (Armor_Exotic(ent) == SUIT_ONYX_POWER)
        {
            ent.armorvalue = am;
            if (am < 1)
                PowerArmor_Switch (ent, FALSE);     // No power!
        }
};
//- - - - - - - - -

void(entity e) bind_ammo =
{
    local   float   bulk;

//    if (!e)
//        return;     // Don't allow crash by setting world fields.
    bulk = e.perms & POW_PACK;

// Shells
    if (e.ammo_shells > AMAX_SHELLS)
    {   if (bulk)
        {   if (e.ammo_shells > AMAX2_SHELLS)
                e.ammo_shells = AMAX2_SHELLS;
        }
        else
            e.ammo_shells = AMAX_SHELLS;
    }
    else if (e.ammo_shells < 0)
        e.ammo_shells = 0;
// Nails
    if (e.ammo_nails > AMAX_NAILS)
    {   if (bulk)
        {   if (e.ammo_nails > AMAX2_NAILS)
                e.ammo_nails = AMAX2_NAILS;
        }
        else
            e.ammo_nails = AMAX_NAILS;
    }
    else if (e.ammo_nails < 0)
        e.ammo_nails = 0;
// Rockets
    if (e.ammo_rockets > AMAX_ROCKETS)
    {   if (bulk)
        {   if (e.ammo_rockets > AMAX2_ROCKETS)
                e.ammo_rockets = AMAX2_ROCKETS;
        }
        else
            e.ammo_rockets = AMAX_ROCKETS;
    }
    else if (e.ammo_rockets < 0)
        e.ammo_rockets = 0;
// Cells
    if (e.ammo_cells > AMAX_CELLS)
    {   if (bulk)
        {   if (e.ammo_cells > AMAX2_CELLS)
                e.ammo_cells = AMAX2_CELLS;
        }
        else
            e.ammo_cells = AMAX_CELLS;
    }
    else if (e.ammo_cells < 0)
        e.ammo_cells = 0;
// Super Shots
    if (e.ammo_super > AMAX_SUPER)
        e.ammo_super = AMAX_SUPER;
    else if (e.ammo_super < 0)
        e.ammo_super = 0;
};

void() bound_other_ammo = {bind_ammo (other);};

float(entity from, entity to) ammo_taken =
{
// NOTE:  In theory, multiple ammo types can be taken from a single item.
    local   float   taken;
    local   float   bulk, hi;

    if (!to)
        return FALSE;   // Don't allow crash by setting world fields.

    taken = FALSE;
    bulk = to.perms & POW_PACK;

// shotgun
    if (from.ammo_shells > 0)
    {   if (bulk)
            hi = AMAX2_SHELLS;
        else
            hi = AMAX_SHELLS;
        if (to.ammo_shells < hi)
        {   taken = TRUE;
            to.ammo_shells = to.ammo_shells + from.ammo_shells;
        }
    }
// spikes
    if (from.ammo_nails > 0)
    {   if (bulk)
            hi = AMAX2_NAILS;
        else
            hi = AMAX_NAILS;
        if (to.ammo_nails < hi)
        {   taken = TRUE;
            to.ammo_nails = to.ammo_nails + from.ammo_nails;
        }
    }
// rockets
    if (from.ammo_rockets > 0)
    {   if (bulk)
            hi = AMAX2_ROCKETS;
        else
            hi = AMAX_ROCKETS;
        if (to.ammo_rockets < hi)
        {   taken = TRUE;
            to.ammo_rockets = to.ammo_rockets + from.ammo_rockets;
        }
    }
// cells
    if (from.ammo_cells > 0)
    {   if (bulk)
            hi = AMAX2_CELLS;
        else
            hi = AMAX_CELLS;
        if (to.ammo_cells < hi)
        {   taken = TRUE;
            to.ammo_cells = to.ammo_cells + from.ammo_cells;
        }
    }
// super shots
    if (from.ammo_super > 0)
    {   if (to.ammo_super < AMAX_SUPER)
        {   taken = TRUE;
            to.ammo_super = to.ammo_super + from.ammo_super;
        }
    }

    if (taken)
        bind_ammo (to);
    return taken;
};

void() ammo_touch =
{
    if (other.health <= 0)
        return;

    local   entity  stemp;
    local   float   best;
    local   float   held;

    if (!(other.xfl & (XFL_ITEMS | XFL_HUNGRY)))
        return;

    if (other.flags & FL_CLIENT)
    {
    // if the player was using his best weapon, change up to the new one if better
        stemp = self;
        self = other;
        held = self.war;
        best = War_BestWeapon ();

        if (!ammo_taken (stemp, self))
            {self = stemp; return;}

        sprint (self, "You got ");
        sprint (self, stemp.netname);
        sprint (self, "\n");
    // ammo touch sound
        sound (self, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
        stuffcmd (self, "bf\n");

        if (self.war == best)
            self.war = War_BestWeapon ();
        if (self.war == held)
            War_UpdateCurrentAmmo ();   // Same weapon, just update the hud.
        else
            War_SetCurrentAmmo ();      // Weapon change.
        self = stemp;
    }
    else if (ammo_taken (self, other))
    {   // Monster just took the ammo.
        sound (self, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
    }

    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

    ClearItem (30);
};

void() ammo_start =
{
    if (!self.spawned)
    {
        precache_model (self.mdl);
        precache_sound ("weapons/lock4.wav");
    }
    setmodel (self, self.mdl);
    self.touch = ammo_touch;
// SoE:  Fix bsp item placement.
    if (bsp_shift || (self.xsf & XSF_CHEST_HACK))
        self.origin = self.origin + '-16 -16 0';
//- - - - - - - - -
    setsize (self, '0 0 0', '32 32 56');
    StartItem ();
};

float WEAPON_BIG2 = 1;
// SoE Indian Summer:  Defined for messy nsoe map hacks.
void() item_cells;
void() weapon_blaster;
//- - - - - - - - -

//============
// --> QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
//============
void() item_shells =
{
    if (self.spawnflags & WEAPON_BIG2)
        {self.mdl = "maps/b_shell1.bsp"; self.ammo_shells = ShellGame(LARGE_SHELLS);}
    else
        {self.mdl = "maps/b_shell0.bsp"; self.ammo_shells = ShellGame(SMALL_SHELLS);}
    self.netname = "shells";
    ammo_start ();
};
//============
// --> QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
//============
void() item_spikes =
{
    if (self.spawnflags & WEAPON_BIG2)
    {
//- - - - - - - - -
// SoE:  Change all of the nails behind city walls to cells for blaster.
        if (self.origin_y < -1424)
            if (world.model == "maps/nsoe2.bsp")
            {
                self.classname = "item_cells";
                item_cells ();
                return;
            }
//- - - - - - - - -
        {self.mdl = "maps/b_nail1.bsp"; self.ammo_nails = LARGE_NAILS;}
    }
    else
    {
//- - - - - - - - -
// SoE:  DarkPlaces fix -- Shunt downward so ammo isn't stuck in ceiling.
        if (world.model == "maps/nsoe1.bsp")
            self.origin_z    = self.origin_z - 24;
//- - - - - - - - -
        {self.mdl = "maps/b_nail0.bsp"; self.ammo_nails = SMALL_NAILS;}
    }
    self.netname = "nails";
    ammo_start ();
};
//============
// --> QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
//============
void() item_rockets =
{
    if (self.spawnflags & WEAPON_BIG2)
        {self.mdl = "maps/b_rock1.bsp"; self.ammo_rockets = LARGE_ROCKETS;}
    else
        {self.mdl = "maps/b_rock0.bsp"; self.ammo_rockets = SMALL_ROCKETS;}
    self.netname = "rockets";
    ammo_start ();
};
//============
// --> QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
//============
void() item_cells =
{
    if (self.spawnflags & WEAPON_BIG2)
        {self.mdl = "maps/b_batt1.bsp"; self.ammo_cells = LARGE_CELLS;}
    else
        {self.mdl = "maps/b_batt0.bsp"; self.ammo_cells = SMALL_CELLS;}
    self.netname = "a power cell";
    ammo_start ();
};
//============
// --> QUAKED item_bolts (0 .5 .8) (0 0 0) (32 32 32) big
//============
void() item_bolts =
{
    self.mdl = "progs/am_super.mdl";
    if (self.spawnflags & WEAPON_BIG2)
        {self.frame = 1; self.ammo_super = LARGE_SUPER; self.netname = "ice bolts";}
    else
        {self.frame = 0; self.ammo_super = SMALL_SUPER; self.netname = "an ice bolt";}
    ammo_start ();
};


//============
// --> QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
// DO NOT USE THIS!!!! IT WILL BE REMOVED!
//
// PM:  Rewritten to use 'item_*' ammo boxes.
//      Some levels such as dm5.bsp use this function.
//      This is here for legacy support only.  Do NOT use for Drake maps!
//============
void() item_weapon =
{
//-------------------------------
// Spawnflags for 'item_weapon'.
//-------------------------------
//float WEAPON_SHOTGUN = 1;
//float WEAPON_ROCKET = 2;
//float WEAPON_SPIKES = 4;
//float WEAPON_BIG = 8;
//-------------------------------
    local   float   osf;    // Short for original spawnflags.

    osf = self.spawnflags;

    // Change spawnflags for use with the other ammo items.
    if (self.spawnflags & 8)
        self.spawnflags = WEAPON_BIG2;
    else
        self.spawnflags = 0;

    if (osf & 1)
        {self.classname = "item_shells"; item_shells (); return;}
    if (osf & 2)
        {self.classname = "item_rockets"; item_rockets (); return;}
    if (osf & 4)
        {self.classname = "item_spikes"; item_spikes (); return;}

    dprint ("Undefined ammo at: ");
    dprint (vtos(self.origin));
    dprint ("\n");
    remove (self);
};


//==========================================================================
//
//  WEAPONS
//
//==========================================================================

// PM:  This returns the name of a given weapon.
string(float gun) weapon_name =
{
    local   string  text;

    text = "Gun";       // Unidentified weapons have no name.
// Use tree structure to lower checks needed for worst-case scenario.
    if (gun & WARx_USES_CELLS)
    {
        if (gun == WAR_CHAIN_LIGHTNING)
            text = "Chain Thunderbolt";
        else if (gun == WAR_THUNDERBOLT)
            text = "Thunderbolt";
        else if (gun == WAR_PLASMA_GUN)
            text = "Plasma Gun";
        else if (gun == WAR_LASER_CANNON)
            text = "Hyperblaster";
        else if (gun == WAR_BLASTER)
            text = "Blaster";
        else if (gun == WAR_MJOLNIR)
            text = "Mjolnir";
    }
    else if (gun & WARx_USES_ROCKETS)
    {
        if (gun == WAR_CRUISE_MISSILE)
            text = "MIRV Launcher";
        else if (gun == WAR_ROCKET_LAUNCHER)
            text = "Rocket Launcher";
        else if (gun == WAR_SIDEWINDER)
            text = "Sidewinder";
        else if (gun == WAR_GRENADE_LAUNCHER)
            text = "Grenade Launcher";
    }
    else if (gun & WARx_USES_NAILS)
    {
        if (gun == WAR_SUPER_NAILGUN)
            text = "Super Nailgun";
        else if (gun == WAR_NAILGUN)
            text = "Nailgun";
    }
    else if (gun & WARx_USES_SHELLS)
    {
        if (gun == WAR_SUPER_SHOTGUN)
        {   if (q1shot)
                text = "Double-barrelled Shotgun";
            else
                text = "Double Shotgun";
        }
        else if (gun == WAR_SHOTGUN)
            text = "Shotgun";
    }
    else    // The weapons below either use custom ammo or don't use ammo.
    {
        if (gun == WAR_AXE)
//        {   if (soul_evil)
//                text = "Vorpal Sword";
//            else
                text = "Axe";
//        }
        else if (gun == WAR_CHAINSAW)
            text = "Chainsaw";
        else if (gun == WAR_ZAPPER)
            text = "Ruby Wand";     // Use "Flash Gun" if not a wand.
        else if (gun == WAR_GRAPPLE)
            text = "Grappler";
        else if (gun == WAR_BURIZA)
            text = "Buriza-Do Kyanon";
    }

    return text;
};

//=============
// Deathmatch_Weapon
//
// Deathmatch weapon change rules for picking up a weapon
//=============
void(float old, float new) Deathmatch_Weapon =
{
// change self.weapon if desired  (PM:  High bit weapons are better.)
    if (new > old)
        War_Add (self, new);
};

//============
// PM:  This lets the player automatically swap to the new weapon if needed.
//============
void(float old, float new) weapon_change =
{
// If we have a new weapon, make sure it is safe to use.  We don't want the
// player to swap to a lightning-based weapon while underwater because he
// may accidentally kill himself.  For all we know, he may be busy fighting,
// blunder into a backpack with such a weapon, then blow himself up
// without any chance to react.
    if (new)
        if ((self.h2olevel <= 1) || !(new & WARx_DISCHARGE))
    {
        local   float   ow;

        ow = self.war;
        if (deathmatch)
            Deathmatch_Weapon (old, new);
        else
            War_Add (self, new);

        if (ow != self.war)
            {War_SetCurrentAmmo ();  return;}
    }
    War_UpdateCurrentAmmo ();   // Just in case player got some ammo too.
};

//============
// This lets 'other' attempt to take a weapon touched.  If successful.
// this returns the weapon's item bit.  'who' is used by minions to check
// if their master has the weapon.
//============
float(entity who, float leave) weapon_taken =
{
    local   float   new;

    new = 0;
    if (leave)
        if (who.arsenal & self.war)
            return 0;

    new = self.war;

    other.ammo_shells   = other.ammo_shells + self.ammo_shells;
    other.ammo_nails    = other.ammo_nails + self.ammo_nails;
    other.ammo_rockets  = other.ammo_rockets + self.ammo_rockets;
    other.ammo_cells    = other.ammo_cells + self.ammo_cells;
    other.ammo_super    = other.ammo_super + self.ammo_super;
    bound_other_ammo ();

    return new;
};

//=============
// weapon_touch
//=============
void() weapon_touch =
{
    if (other.health <= 0)
        return;

    local    float    best, new, old;
    local    entity   stemp;
    local    float    leave;

    if ( !(other.xfl & (XFL_ITEMS | XFL_HUNGRY)) )
        return;

    if ((self.war & legalized) == 0)
    {   // This shouldn't happen, but if it does, remove the weapon in style.
        // The weapon disappears in a puff of smoke.
        local   vector  spot;

        spot    = self.origin;
        spot_z  = self.origin_z + self.mins_z + 24;
        spawn_tfog (spot);
        remove (self);
        return;
    }

    leave = self.lefty;     // Set at spawn time.

    if (other.flags & FL_CLIENT)
    {
    // if the player was using his best weapon, change up to the new one if better        
        stemp = self;
        self = other;
        best = War_BestWeapon();
        self = stemp;

        new = weapon_taken (other, leave);
        if (!new)
            return;

        sprint (other, "You got the ");
        sprint (other, self.netname);
        sprint (other, "\n");
    // weapon touch sound
        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
        stuffcmd (other, "bf\n");

    // change to the weapon
        old = other.war;
        other.arsenal = other.arsenal | new;
        War_UpdateItems (other);
    
        stemp = self;
        self = other;
        weapon_change (old, new);
        self = stemp;
    }
    else
    {
        if (leave)
        {   // If merely hungry, don't take weapons it cannot remove.
            if (self.xfl & (XFL_ITEMS | XFL_HUNGRY) == XFL_HUNGRY)
                return;
        }

        new = weapon_taken (other, leave);
        if (!new)
            return;

    // change to the weapon
        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
        other.arsenal = other.arsenal | new;
        other.war = new;
    }

// At this point, 'other' grabbed this weapon.
// PM:  Unlike standard progs, use targets even if weapon is to stay.

    activator = other;
    SUB_UseTargets ();          // fire all targets / killtargets

    if (!leave)
    {
        if (self.war == WAR_BURIZA)
            best = 60;      // Don't respawn as quickly as other weapons.
        else
            best = 30;
        ClearItem (best);
    }
};

// TRUE = Weapons stay after pickup.
void() weapon_leave =
{
    if (self.spawned)
        self.lefty = FALSE;     // Always take dropped weapons, like in Q2.
    else if (self.war == WAR_BURIZA)
        self.lefty = FALSE;     // Always take these regardless of game mode.
    else
        self.lefty = ((deathmatch & DM_OLD_SCHOOL) || coop);
};

// Common setup code called by all weapons.
void() weapon_start =
{
// DISABLED -- Debug check to confirm weapons while loading maps.
//dprint ("> > "); dprint(self.classname); dprint("\n");

// Proceed
    weapon_leave ();    // Do now so Quake doesn't need to check per touch.
    self.netname = weapon_name (self.war);
    if (self.war == WAR_CHAINSAW)
        self.noise = "weapons/sawidle.wav";
    else
        self.noise = "weapons/pkup.wav";
    if (!self.spawned)
    {
        precache_model (self.mdl);
        precache_sound (self.noise);    //"weapons/pkup.wav"
    }
    setmodel (self, self.mdl);
//    self.noise = "weapons/pkup.wav";
    self.touch = weapon_touch;
    setsize (self, '-16 -16 0', '16 16 56');
    StartItem ();
};

//-----/ Standard Quake Weapons /-----//

// In standard Quake, axe and shotgun are always in inventory and never found
// laying around.  However, Drake supports the possibility of unarmed players
// who may need to pick up these basic weapons.
//============
// --> QUAKED weapon_axe (0 .5 .8) (-16 -16 0) (16 16 32)
// --> QUAKED weapon_sword (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_axe =
{
    self.mdl = "progs/g_axe.mdl";
    self.war = WAR_AXE;
    weapon_start ();
};
void() weapon_sword = {self.classname = "weapon_axe"; weapon_axe();};
//============
// --> QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_shotgun =
{
    self.mdl = "progs/g_gun.mdl";
    self.ammo_shells = 5;
    self.war = WAR_SHOTGUN;
    weapon_start ();
};

// Now for the standards.
//============
// --> QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_supershotgun =
{
    self.mdl = "progs/g_shot.mdl";
    self.ammo_shells = 5;
    self.war = WAR_SUPER_SHOTGUN;
    weapon_start ();
};
//============
// --> QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_nailgun =
{
//- - - - - - - - -
// SoE:  Change wimpy nailgun behind city walls to a laser blaster.
    if (self.origin_y < -1424)
        if (world.model == "maps/nsoe2.bsp")
            {self.classname = "weapon_blaster"; weapon_blaster(); return;}
//- - - - - - - - -
// DISABLED -- Maybe in Drake, but not in SoE!
//    if (deathmatch)
//    {   // Normal nailgun is too weak for DM, so upgrade it!
//        self.classname = "weapon_supernailgun";
//        weapon_supernailgun();
//        return;
//    }
    self.mdl = "progs/g_nail.mdl";
    self.ammo_nails = 30;
    self.war = WAR_NAILGUN;
    weapon_start ();
};
//============
// --> QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_supernailgun =
{
    self.mdl = "progs/g_nail2.mdl";
    self.ammo_nails = 30;
    self.war = WAR_SUPER_NAILGUN;
    weapon_start ();
};
//============
// --> QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_grenadelauncher =
{
    self.mdl = "progs/g_rock.mdl";
    self.ammo_rockets = 5;
    self.war = WAR_GRENADE_LAUNCHER;
    weapon_start ();
};
//============
// --> QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_rocketlauncher =
{
    self.mdl = "progs/g_rock2.mdl";
    self.ammo_rockets = 5;
    self.war = WAR_ROCKET_LAUNCHER;
    weapon_start ();
};
//============
// --> QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_lightning =
{
    self.mdl = "progs/g_light.mdl";
    self.ammo_cells = 30;
    self.war = WAR_THUNDERBOLT;
    weapon_start ();
};

//-----/ Hipnotic Weapons /-----//

//============
// --> QUAKED weapon_mjolnir (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_mjolnir =
{
    self.mdl = "progs/g_hammer.mdl";
    self.ammo_cells = 60;
    self.war = WAR_MJOLNIR;
    weapon_start ();
};
//============
// --> QUAKED weapon_laser_gun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_laser_gun =
{
    self.mdl = "progs/g_laserg.mdl";
    self.ammo_cells = 60;
    self.war = WAR_LASER_CANNON;
    weapon_start ();
};
//void() weapon_laser_cannon = {weapon_laser_gun ();};
//============
// --> QUAKED weapon_proximity_gun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
// FIXME:  ???
void() weapon_sidewinder;
void() weapon_proximity_gun =
{
    self.classname = "weapon_sidewinder";
    weapon_sidewinder ();
};

//-----/ Rogue Weapons /-----//

//============
// --> QUAKED weapon_grapple (0 .5 .8) (-16 -16 0) (16 16 32) Rusty
//============
void() weapon_grapple =
{
    self.mdl = "progs/g_grpple.mdl";
    self.war = WAR_GRAPPLE;
    weapon_start ();
};

//-----/ Custom Weapons /-----//
// Some are from other mods such as Zerst”rer, but a few are Drake exclusive.

//- - - - - - - - -
//============
// --> QUAKED weapon_chainsaw (0 .5 .8) (-16 -16 0) (16 16 32)
// From Zerstorer
//============
void() weapon_chainsaw =
{
    self.mdl = "progs/g_saw.mdl";
    self.war = WAR_CHAINSAW;
    weapon_start ();
};
//- - - - - - - - -
//============
// --> QUAKED weapon_zapper (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_zapper =
{
    self.mdl = "progs/g_wand.mdl";
    self.war = WAR_ZAPPER;
    weapon_start ();
};
// Used in roman.
void() weapon_wand = {self.classname = "weapon_zapper";  weapon_zapper();};
//============
// --> QUAKED weapon_blaster (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_blaster =
{
// TODO:  New gun model.  Low priority.
    self.mdl = "progs/g_gun.mdl";
    self.skin = 1;      // Yellow-ish.
    self.ammo_cells = 30;
    self.war = WAR_BLASTER;
    weapon_start ();
};
//void() weapon_laser = {self.classname = "weapon_blaster"; weapon_blaster();};
//============
// --> QUAKED weapon_chainlightning (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_chainlightning =
{
    self.mdl = "progs/g_light2.mdl";
    self.ammo_cells = 30;
    self.war = WAR_CHAIN_LIGHTNING;
    weapon_start ();
};
//============
// --> QUAKED weapon_plasmagun (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_plasma_gun =
{
    self.mdl = "progs/g_gun.mdl";
    self.skin = 2;      // Blue-ish.
    self.ammo_cells = 30;
    self.war = WAR_PLASMA_GUN;
    weapon_start ();
};
// Quoth entity
void() weapon_plasmagun =
    {self.classname = "weapon_plasma_gun"; weapon_plasma_gun();};
// FIXME:  Hack for drysorrow.  Remove!
void() weapon_secret = {weapon_plasmagun();};
//============
// --> QUAKED weapon_sidewinder (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_sidewinder =
{
    self.mdl = "progs/g_rocks.mdl";
    self.ammo_rockets = 5;
    self.war = WAR_SIDEWINDER;
    weapon_start ();
};
//============
// --> QUAKED weapon_stinger (0 .5 .8) (-16 -16 0) (16 16 32)
// --> QUAKED weapon_mirv (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void() weapon_stinger =
{
    self.mdl = "progs/g_mirv.mdl";
    self.ammo_rockets = 5;
    self.war = WAR_CRUISE_MISSILE;
    weapon_start ();
};
// PM:  Alternate name for the stinger rocket launcher.
void() weapon_mirv = {self.classname = "weapon_stinger";  weapon_stinger();};
// PM:  Convert Zerstorer's weaksauce SRE to something more worthy.
void() weapon_stunner = {self.classname = "weapon_stinger";  weapon_stinger();};
//============
// --> QUAKED weapon_crossbow (0 .5 .8) (-16 -16 0) (16 16 32)
// Instakill weapon.
//============
void() weapon_crossbow =
{
    self.mdl = "progs/g_xbow.mdl";
    self.ammo_super = 5;
    self.war = WAR_BURIZA;
    weapon_start ();
};


//==========================================================================
//
//  BACKPACKS
//
//==========================================================================

//- - - - - - - - -
// This finds the worst new weapon available in an arsenal.
// Why take the worst instead of the best?  Traditional game design.
// The same reason you need several powerup items to get max firepower
// in shooter games (shmups) such as Raiden, Dragon Spirit, etc.
//- - - - - - - - -
float() arsenal_pick =
{
    local   float   guns, w;

    guns = self.arsenal & legalized;

    w = 1;      // Start at the worst.
    while (w)
    {
        if (w & guns)
        {
            if (!(w & other.arsenal))
                return w;
        }

        if (w >= 8388608)
            return 0;       // No weapon found.
        w = w * 2;      // Shift to the next weapon bit.
    }
    return 0;   // Safeguard in case the loop breaks.
};

//- - - - - - - - -
// PM:  This lets 'other' take and use the contents of the pack.
//      If 'all' is TRUE, everything is taken.  If 'all' is FALSE, only
//      stuff needed is taken from the pack.  Excess is left in the pack.
//      Called when a player takes items from a backpack.
//- - - - - - - - -
float(float all) Pack_TakeItems =
{
// PM:  Check if contents should really be consumed when taken.
    local   float   eat;
    eat = TRUE;
    if (self.lefty)
        eat = FALSE;    // Source is a backpack that may respawn.

// PM:  Merge new weapon with the old.
    local   float   new;
    new = arsenal_pick ();
    if (new)
    {
        if (other.arsenal & new)
            new = 0;
    }
    if (eat)
        self.arsenal = self.war = 0;  // Always remove the weapon.

// PM:  Add armor...
    local   float   take_armor;
    take_armor = 0;
    if (self.armor_stats_y)
    {
        take_armor = Armor_Add (other, self.armor_stats);
        if (all)
            take_armor = 1;     // If take all, always remove armor.
        if (take_armor)
            if (eat)
                self.armor_stats = '0 0 0';
    }

// PM:  Antidote...
// Check antidote before health because using all health uses antidote too.
    local   float   take_cure;
    take_cure = 0;
    if (self.healtype > 0)
    {
//        if (IsPoisoned (other))
//        {
//            take_cure = 1;
//            Poison_Null (other);
//            if (eat)
//                self.healtype = self.healtype - 1;
//        }
        if (all)
            if (eat)
                self.healtype = 0;
    }

// PM:  Add health...
    local   float   take_hp;
    take_hp = 0;
    // Normal health
    if (self.healamount > 0)
    {
        if (all)
        {
            take_hp = self.healamount;
            T_Heal (other, take_hp, FALSE);
            if (eat)
                self.healamount = 0;
        }
        else if (other.health < other.max_health)
        {
            take_hp = other.health + self.healamount;
            if (take_hp > other.max_health)
                take_hp = self.healamount - (take_hp - other.max_health);
            else
                take_hp = self.healamount;
            if (take_hp)
            {
                T_Heal (other, take_hp, FALSE);
                if (eat)
                    self.healamount = self.healamount - take_hp;
            }
        }
        // Using all health uses up antidote too.
        if (self.healamount <= 0)
            self.healtype = 0;
    }

// Update 2/18/10:  Expanded capacity.
    local   float   bulk, hi;
    bulk = other.perms & POW_PACK;

// PM:  Get shells.
    local   float   take_shells;
    take_shells = 0;
    if (self.ammo_shells)
    {
        if (bulk)
            hi = AMAX2_SHELLS;
        else
            hi = AMAX_SHELLS;

        if (all)
        {
            take_shells = self.ammo_shells;
            other.ammo_shells = other.ammo_shells + take_shells;
            if (other.ammo_shells > hi)
                other.ammo_shells = hi;
            if (eat)
                self.ammo_shells = 0;
        }
        else if (other.ammo_shells < hi)
        {
            if (other.ammo_shells + self.ammo_shells > hi)
                take_shells = hi - other.ammo_shells;
            else
                take_shells = self.ammo_shells;
            other.ammo_shells = other.ammo_shells + take_shells;
            if (eat)
                self.ammo_shells = self.ammo_shells - take_shells;
        }
    }

// PM:  Get nails.
    local   float   take_nails;
    take_nails = 0;
    if (self.ammo_nails)
    {
        if (bulk)
            hi = AMAX2_NAILS;
        else
            hi = AMAX_NAILS;

        if (all)
        {
            take_nails = self.ammo_nails;
            other.ammo_nails = other.ammo_nails + take_nails;
            if (other.ammo_nails > hi)
                other.ammo_nails = hi;
            if (eat)
                self.ammo_nails = 0;
        }
        else if (other.ammo_nails < hi)
        {
            if (other.ammo_nails + self.ammo_nails > hi)
                take_nails = hi - other.ammo_nails;
            else
                take_nails = self.ammo_nails;
            other.ammo_nails = other.ammo_nails + take_nails;
            if (eat)
                self.ammo_nails = self.ammo_nails - take_nails;
        }
    }

// PM:  Get rockets.
    local   float   take_rockets;
    take_rockets = 0;
    if (self.ammo_rockets)
    {
        if (bulk)
            hi = AMAX2_ROCKETS;
        else
            hi = AMAX_ROCKETS;

        if (all)
        {
            take_rockets = self.ammo_rockets;
            other.ammo_rockets = other.ammo_rockets + take_rockets;
            if (other.ammo_rockets > hi)
                other.ammo_rockets = hi;
            if (eat)
                self.ammo_rockets = 0;
        }
        else if (other.ammo_rockets < hi)
        {
            if (other.ammo_rockets + self.ammo_rockets > hi)
                take_rockets = hi - other.ammo_rockets;
            else
                take_rockets = self.ammo_rockets;
            other.ammo_rockets = other.ammo_rockets + take_rockets;
            if (eat)
                self.ammo_rockets = self.ammo_rockets - take_rockets;
        }
    }

// PM:  Get cells.
    local   float   take_cells;
    take_cells = 0;
    if (self.ammo_cells)
    {
        if (bulk)
            hi = AMAX2_CELLS;
        else
            hi = AMAX_CELLS;

        if (all)
        {
            take_cells = self.ammo_cells;
            other.ammo_cells = other.ammo_cells + take_cells;
            if (other.ammo_cells > hi)
                other.ammo_cells = hi;
            if (eat)
                self.ammo_cells = 0;
        }
        else if (other.ammo_cells < hi)
        {
            if (other.ammo_cells + self.ammo_cells > hi)
                take_cells = hi - other.ammo_cells;
            else
                take_cells = self.ammo_cells;
            other.ammo_cells = other.ammo_cells + take_cells;
            if (eat)
                self.ammo_cells = self.ammo_cells - take_cells;
        }
    }

// PM:  Get Buriza super shots.
    local   float   take_bolts;
    take_bolts = 0;
    if (self.ammo_super)
    {
        hi = AMAX_SUPER;

        if (all)
        {
            take_bolts = self.ammo_super;
            other.ammo_super = other.ammo_super + take_bolts;
            if (other.ammo_super > hi)
                other.ammo_super = hi;
            if (eat)
                self.ammo_super = 0;
        }
        else if (other.ammo_super < hi)
        {
            if (other.ammo_super + self.ammo_super > hi)
                take_bolts = hi - other.ammo_super;
            else
                take_bolts = self.ammo_super;
            other.ammo_super = other.ammo_super + take_bolts;
            if (eat)
                self.ammo_super = self.ammo_super - take_bolts;
        }
    }

// PM:  Results.
    local   float   acount;

    // Make a special check for empty packs.
    if (!new)
    {
        acount = take_armor + take_hp + take_cure + take_shells +
            take_nails + take_rockets + take_cells + take_bolts;
        if (!acount)
        {
            // This next check is so that a message will be printed if the
            // the player grabs an empty backpack, but not if said player
            // bumps into his pet Draco if he is empty-handed.
            // Note:  Draco bot ripped out for good -- it's obsolete.
            if (self.flags & FL_ITEM)
            {
                Safe_sprint (other, "You get nothing!\n");
                sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
                Safe_stuffcmd (other, "bf\n");
            }
            return 0;   // Nothing.
        }
    }

    if (other.flags & FL_CLIENT)
    {
        local   string  s;

        acount = 0;
        sprint (other, "You get ");
        if (new)
        {
            acount = 1;
            s = weapon_name (new);
            sprint (other, "the ");
            sprint (other, s);
        }
        if (take_armor)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            sprint (other, "armor");
        }
        if (take_hp)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            s = ftos(take_hp);
            sprint (other, s);
            sprint (other, " health");
        }
        if (take_cure)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            sprint (other, "antidote");
        }
        if (take_shells)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            s = ftos(take_shells);
            sprint (other, s);
            if (take_shells == 1)
                sprint (other, " shell");
            else
                sprint (other, " shells");
        }
        if (take_nails)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            s = ftos(take_nails);
            sprint (other, s);
            if (take_nails == 1)
                sprint (other, " nail");
            else
                sprint (other, " nails");
        }
        if (take_rockets)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            s = ftos(take_rockets);
            sprint (other, s);
            if (take_rockets == 1)
                sprint (other, " rocket");
            else
                sprint (other, " rockets");
        }
        if (take_cells)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            s = ftos(take_cells);
            sprint (other, s);
            if (take_cells == 1)
                sprint (other, " cell");
            else
                sprint (other, " cells");
        }
        if (take_bolts)
        {
            if (acount)
                sprint(other, ", ");
            acount = 1;
            s = ftos(take_bolts);
            sprint (other, s);
            if (take_bolts == 1)
                sprint (other, " bolt");
            else
                sprint (other, " bolts");
        }
        sprint (other, "\n");
    }

// backpack touch sound
    if (new == WAR_CHAINSAW)
        sound (other, CHAN_IDLE, "weapons/sawidle.wav", 1, ATTN_NORM);
    else
        sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

    other.arsenal = other.arsenal | new;

    return new;
};

//===========================================================================

// Used by decapitation code to give headless "body double" the loot.
void(entity from, entity to) Pack_Copy =
{
    to.arsenal      = from.arsenal;
    to.war          = from.war;
    to.healamount   = from.healamount;
    to.healtype     = from.healtype;
    to.armor_stats  = from.armor_stats;
    to.ammo_shells  = from.ammo_shells;
    to.ammo_nails   = from.ammo_nails;
    to.ammo_rockets = from.ammo_rockets;
    to.ammo_cells   = from.ammo_cells;
    to.ammo_super   = from.ammo_super;
};

float(entity who) Pack_Empty =
{
    if (who.arsenal)        return FALSE;
    if (who.war)            return FALSE;   // FIXME:  Redundant?
    if (who.healamount)     return FALSE;
    if (who.healtype)       return FALSE;
    if (who.armor_stats_y)  return FALSE;
    if (who.ammo_shells)    return FALSE;
    if (who.ammo_nails)     return FALSE;
    if (who.ammo_rockets)   return FALSE;
    if (who.ammo_cells)     return FALSE;
    if (who.ammo_super)     return FALSE;
    return TRUE;
};

//===========================================================================

void() BackpackGone =
{
    if (self.lefty)
    {   // This is an ammo item placed on the map.
        ClearItem (30);     // Same as weapons.
        return;
    }
    remove (self);      // Dropped -- standard procedure.
};

void() BackpackTouch =
{
    if (other.health <= 0)
        return;

    if ( !(other.xfl & (XFL_ITEMS | XFL_HUNGRY)) )
        return;

    local   float   old, new;

// Check if player picked it up.
    if (other.flags & FL_CLIENT)
    {
        old = other.war;
        new = Pack_TakeItems (TRUE);
        if (!new)
            new = old;      // FIXME:  Sloppy hack to update ammo count.

        // remove the backpack, change self to the player
        BackpackGone ();
        self = other;

        // change to the weapon
        weapon_change (old, new);
    }
    else
    {
        other.war = Pack_TakeItems (TRUE);

        BackpackGone ();
        self = other;
    }
};

void() DropBackpack =
{
    if (Pack_Empty (self))
        return;     // nothing in it

    local   entity  item;
    local   vector  org;

// PM:  Changed since a few custom creatures have origin at the feet.
    if (self.flags & FLx_CREATURE)
        {org = self.origin;  org_z = org_z + self.mins_z;}
    else    // In case of mapper exploiting hacks...
        org = self.origin - '0 0 24';

    item = spawn();

// For 'deus ex machina' reasons, put the whole arsenal in.
// Exception:  Players drop only the weapon held at the time of death.
    if (self.classname == "player")
        item.arsenal        = self.war;
    else
        item.arsenal        = (self.arsenal | self.war) & legalized;
    item.war            = 0;

// Add health and armor.
    item.armor_stats    = self.armor_stats;
    item.armor_stats_z  = self.armor_stats_z | (self.perms & POWx_ARMOR);
    item.healamount     = self.healamount;
    item.healtype       = self.healtype;

// Jam all of the ammo in the pack.
    item.ammo_shells    = self.ammo_shells;
    item.ammo_nails     = self.ammo_nails;
    item.ammo_rockets   = self.ammo_rockets;
    item.ammo_cells     = self.ammo_cells;
    item.ammo_super     = self.ammo_super;
//    bind_ammo (item);   // Make sure item doesn't have negative ammo.

    item.velocity_x = -100 + (random() * 200);
    item.velocity_y = -100 + (random() * 200);
    item.velocity_z = 300;

    item.lefty  = FALSE;
    item.xf2    = XF2_QUAKE;

    item.flags      = FL_ITEM;
    item.solid      = SOLID_TRIGGER;
    item.movetype   = MOVETYPE_TOSS;
    item.touch      = BackpackTouch;
    
    item.nextthink  = time + 120;       // Remove after 2 minutes.
    item.think      = SUB_Remove;

    setall (item, "progs/backpack.mdl", '-16 -16 0', '16 16 56', org);
};

//============
// --> QUAKED item_backpack (0 .5 .8) (-16 -16 0) (16 16 56) big weapon
// Pack of assorted ammo.
//============
void() item_backpack =
{
// PM:  Backpack in Doom games give one of each small box of ammo,
// plus double normal max capacity.

// If pack has no ammo, give one box of each type like in Doom.
    if (self.ammo_shells < 1)
    if (self.ammo_nails < 1)
    if (self.ammo_rockets < 1)
    if (self.ammo_cells < 1)
    if (self.ammo_super < 1)
    {
        if (self.spawnflags & WEAPON_BIG2)
        {
            self.ammo_shells    = ShellGame (LARGE_SHELLS);
            self.ammo_nails     = LARGE_NAILS;
            self.ammo_rockets   = LARGE_ROCKETS;
            self.ammo_cells     = LARGE_CELLS;
        }
        else
        {
            self.ammo_shells    = ShellGame (SMALL_SHELLS);
            self.ammo_nails     = SMALL_NAILS;
            self.ammo_rockets   = SMALL_ROCKETS;
            self.ammo_cells     = SMALL_CELLS;
        }
        self.ammo_super     = 0;    // No free instakill bolts for you.
    }
    bind_ammo (self);

    if (self.spawnflags & 2)    // Axe and normal guns only.
        self.arsenal = legalized - (legalized & (WAR_CHAINSAW | WAR_MJOLNIR | WAR_BURIZA));
    else
        self.arsenal = 0;   //(WAR_AXE | WAR_SHOTGUN) & legalized;
    self.war = 0;

    self.lefty = TRUE;
    self.touch = BackpackTouch;
    setmodel (self, "progs/backpack.mdl");
    setsize (self, '-16 -16 0', '16 16 56');
    StartItem ();
};


//===========================/  END OF FILE  /===========================//
