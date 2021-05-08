//==========================================================================
// Constants

// PM:  Health, armor, and keyops moved to defs.

// Item spawnflags
//  16 = floating item (disabled)
//  32 = delay spawn, silent
//  64 = delay spawn, foggy
// 128 = always respawn
//==========================================================================


//==========================================================================
//
//  UNIVERSAL
//
//==========================================================================
void() SUB_regen =
{
    self.model = self.mdl;        // restore original model
    self.solid = SOLID_TRIGGER;   // allow it to be touched again
    setorigin (self, self.origin);
    if (!(self.xsf & XSF_SPAWNSILENT))
    {
        local   vector  org;

        org = Midpoint (self);
        spawn_tfog (org);   // Appear with a flash, bang, and smoke.
    }
    else
        sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);    // play respawn sound

    if (self.th_win)
        self.th_win ();
};

// PM:  Doubles ammo yields in Hell difficulty, just like in Doom.
void() hell_bonus_ammo =
{
    if (skill >= 4)
    {   // More ammo in Hell.
        self.ammo_shells    = ceil(self.ammo_shells * 2);
        self.ammo_nails     = ceil(self.ammo_nails * 2);
        self.ammo_rockets   = ceil(self.ammo_rockets * 2);
        self.ammo_cells     = ceil(self.ammo_cells * 2);
// DISABLED -- Treat crossbow like an artifact, so no extra ammo.
//        self.ammo_super     = ceil(self.ammo_super * 2);
    }
};

//============
// RevealItem
//
// PM:  Reveal items previously hidden by sf64.
//============
void() RevealItem =
{
    self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNx_DELAY);
    self.use        = SUB_Null;
    SUB_regen ();
};

//============
// PlaceItem
//
// plants the object on the floor
//============
void() PlaceItem =
{
    self.mdl        = self.model;       // so it can be restored on respawn
    self.flags      = FL_ITEM;          // make extra wide
    self.solid      = SOLID_TRIGGER;
//    if (self.spawnflags & 16)
//    {   // Item floats in mid-air.
//        self.movetype   = MOVETYPE_FLY;
//        self.velocity   = '0 0 0';
//        if (pointcontents (self.origin) == CONTENT_SOLID)
//        if (pointcontents (self.absmin) == CONTENT_SOLID)
//        if (pointcontents (self.absmax) == CONTENT_SOLID)
//        {
//            print_self (self.classname, " in wall at: ");
//            remove (self);
//            return;
//        }
//    }
//    else
    {
        self.movetype   = MOVETYPE_TOSS;
        self.velocity   = '0 0 0';
        self.origin_z   = self.origin_z + 6;    // +6 to overcome sloping ground?
        if (!droptofloor ())
        {
            // PM:  Allow this even if created by func_spawn.
            print_self (self.classname, " fell out of level at ");
//            dprint (self.classname);    // Used to be "Bonus item".
//            dprint (" fell out of level at ");
//            dprint (vtos(self.origin));
//            dprint ("\n");
            remove (self);
            return;
        }
    }
// Check for sf64 goodness.
    if (self.spawnflags & SPAWNx_DELAY)
    {   // Hide the item until triggered.
        self.model = world.null_string;     //string_null;
        self.solid = SOLID_NOT;
        self.use   = RevealItem;
        return;
    }
// If the item has other code to run (e.g., morphing), do it.
    if (self.th_win)
        self.th_win ();
};

//============
// StartItem
//
// Sets the clipping size and plants the object on the floor
//============
void() StartItem =
{
    hell_bonus_ammo ();
    if (self.xsf & XSF_CHEST_HACK)
    {   // Spawned by chest.
        self.xsf        = XSF_SPAWNSILENT;
        self.spawned    = TRUE;

        self.mdl        = self.model;       // so it can be restored on respawn
        self.flags      = FL_ITEM;          // make extra wide
        self.solid      = SOLID_TRIGGER;
        self.movetype   = MOVETYPE_TOSS;
        self.velocity   = '0 0 0';
        self.velocity_z = cvar("sv_gravity") / 5;
        if (self.th_win)
            self.th_win ();
        return;
    }

// Normal code.
    self.nextthink  = time + 0.2;   // items start after other solids
    self.think      = PlaceItem;
// Extra stuff.
// Note:  Unlike monsters, do NOT call PlaceItem if func_spawn'ed.
// That's because PlaceItem (usually) does not change thinking, which
// means PlaceItem will be called again if func_spawn'ed.
    if (self.spawned)
        self.nextthink  = 0.01;     // Start ASAP if created during mid-game.
    if (!(self.spawnflags & SPAWN_NORMAL))
        self.xsf        = self.xsf | XSF_SPAWNSILENT;
};

//============
// ClearItem
//
// remove item in single player, or setup for respawning in deathmatch
//============
void(float secs) ClearItem =
{
    local   float   keep;

    keep = FALSE;
    if (!self.spawned)
        if (secs)
        {
            if (deathmatch)
                if (!(deathmatch & DM_OLD_SCHOOL))
                    keep = TRUE;
            if (self.spawnflags & SPAWN_RESPAWN)
                keep = TRUE;
// DISABLED -- Possible limited respawn.
//            if (self.count)
//            {
//                if (self.count == -1)
//                    keep = TRUE;    // Infinite respawn.
//                else if (self.count > 0)
//                    {keep = TRUE;  self.count = self.count - 1;}
//            }
        }

    if (keep)
    {
// FIXME:  Is this confirmed and debugged?
//        dprint ("respawn\n");
        self.solid      = SOLID_NOT;
        self.model      = world.null_string;    //string_null;
        self.nextthink  = time + secs;
        self.think      = SUB_regen;
        return;
    }
//    dprint ("void\n");
    Remove_Ent (self);      // PM:  Sever links then remove self.
};


//===========================================================================
//  Dynamic Item Spawning

//- - - - - - - - -
// Update 4/13/09:  Dynamic item drops.
void(void() func) Item_Cache =
{
    if (func)
    {   // Spawn an item to precache files, then delete it.
        local   entity  swap;
    
        swap = self;
        self = spawn();
        // We need to copy spawnflags for things like health boxes.
        self.spawnflags = swap.spawnflags & 15;
        self.spawned = FALSE;
        func ();
        remove (self);
        self = swap;
    }
};

// sf = spawnflags to use, eclass = item classname, func = item function.
void(float sf, string eclass, void() func) Item_Drop =
{
    if (func)
    {
        local   entity  swap;
        local   vector  org;

        org = self.origin;  org_z = org_z + 24 + self.mins_z;

        swap = self;

        self = spawn();
        setorigin (self, org);
        self.classname  = eclass;
        self.spawned    = TRUE;
        self.xsf        = XSF_CHEST_HACK;
        self.spawnflags = sf & 31;      // Don't use sf32+.
        func ();
    
        self = swap;
    }
};

// Causes monster to drop its special item.
// Called when monster is gibbed or when it drops its pack and money.
void() monster_item_drop =
{
    if (!self.spawned)
    {   // Only those monsters who spawned in the beginning can drop items,
        // because it is the only time we can precache the item for certain.
        if (self.spawnfunction)     // Most monstters don't carry an item.
            Item_Drop (0, self.spawnclassname, self.spawnfunction);

        // Clear fields so monster cannot drop the item again later.
        // Backpack and money may be kept, but special item could be
        // any item -- powerup, key, whatever.  Items such as keys
        // should not be dropped each time this is called.
        self.spawnclassname = world.null_string;
        self.spawnfunction = world.null_func;
    }
};
//- - - - - - - - -


//=========================================================================
//
//  HEALTH BOX
//
//=========================================================================

// T_Heal moved to combat.qc.

void() item_megahealth_rot =
{
    if (self.owner.health > self.owner.max_health)
        if (self.cnt > 0)
    {
        self.owner.health = self.owner.health - 1;
        if (self.owner.health < self.owner.max_health)
            self.owner.health = self.owner.max_health;
        self.owner.hit_points = self.owner.health;
        self.cnt = self.cnt - 1;
        self.nextthink = time + 1;
        return;
    }
    self.cnt = 0;
    ClearItem (20);
};

void() health_touch =
{
    local   float   megas;

    megas = (self.healtype == 1);
    if (other.xfl & XFL_ITEMS)
    {
        local   float   heal, cure;

        heal = T_Heal (other, self.healamount, self.healtype);

        cure = 0;
//        if (self.healamount >= CURE_HEALTH)
//            if (IsPoisoned (other))
//                {cure = 1; Poison_Null (other);}

        // If both hungry and use items, eat it only if it can't use item.
        if (!(other.xfl & XFL_HUNGRY))  // If hungry, eat the item if unused.
        {
            if (!heal)
                if (!cure)
                    return;
        }

        if (other.flags & FL_CLIENT)
        {
            local   string  s;

            if (heal)
            {
                sprint(other, "You receive ");
                s = ftos(heal);
                sprint(other, s);
                sprint(other, " health\n");
                if (cure)
                    sprint(other, "and a cure for your illness\n");
            }
            else if (cure)
                sprint(other, "You receive a cure for your illness\n");
        }    

    // health touch sound
        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);

        Safe_stuffcmd (other, "bf\n");
    }
    else if (other.xfl & XFL_HUNGRY)
    {   // Monster will eat the item!
        if (other.deadflag || (other.health <= 0))
            return;

        // Pick up health and save it.
        other.healamount = other.healamount + self.healamount;
        if (other.healamount > MAX_EXTRA_LIFE)
            other.healamount = MAX_EXTRA_LIFE;
        if (self.healamount >= CURE_HEALTH)
            other.healtype = other.healtype + 1;

        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
        megas = 0;      // Megahealth becomes normal this time.
    }
    else
        return;     // Not allowed to pickup item.
    
    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

    if (megas)
    {
        self.solid = SOLID_NOT;
        self.model = world.null_string;     //string_null;

        // PM:  Removed superhealth flag to 'other'.
        self.nextthink = time + 5;
        self.think = item_megahealth_rot;
        self.owner = other;
        self.cnt = self.healamount;     // Max seconds to rot health.
    }
    else
        ClearItem (20);
};

//============
// --> QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
// Health box. Normally gives 25 points.
// Rotten box heals 15 points,
// megahealth will add 100 health, then 
// rot you down to your maximum health limit, 
// one point per second.
//============
void() item_health =
{
    local   string  text;

    self.touch = health_touch;

    if (self.spawnflags & 1)    // H_ROTTEN
    {
        if (soul_evil)
            text = "maps/b_wbh10.bsp";
        else
            text = "maps/b_bh10.bsp";
        if (!self.spawned)
        {
            precache_model (text);
            precache_sound ("items/r_item1.wav");
        }
        self.noise = "items/r_item1.wav";
        self.healamount = 15;
        self.healtype = 0;
    }
    else if (self.spawnflags & 2)   // H_MEGA
    {
        text = "maps/b_bh100.bsp";
        if (!self.spawned)
        {
            precache_model (text);
            precache_sound ("items/r_item2.wav");
        }
        self.noise = "items/r_item2.wav";
        self.healamount = 100;
        self.healtype = 1;
    }
    else
    {
        if (soul_evil)
        {
            text = "maps/b_wbh25.bsp";
//- - - - - - - - -
// SoE:  Invoke disgusting hack to move items down so they are not stuck in
//  mid-air if playing in the DarkPlaces engine.  Part of what makes this
//  hack gross is the global counter is also used by the hell knights too,
//  so the list includes hell knights and health.
            if (world.model == "maps/nsoe1.bsp")
            {
                AddOne ();
                if ((gloat >= 4) && (gloat <= 6))
                    self.origin_z   = self.origin_z - 24;
                else if ((gloat >= 10) && (gloat <= 11))
                    self.origin_z   = self.origin_z - 24;
                else if (gloat == 13)
                    {remove (self);  return;}
            }
//- - - - - - - - -
        }
        else
            text = "maps/b_bh25.bsp";
        if (!self.spawned)
        {
            precache_model (text);
            precache_sound("items/r_item1.wav");
        }
        self.noise = "items/r_item1.wav";   // Was 'items/health1.wav'.
        self.healamount = 25;
        self.healtype = 0;
    }
    setmodel (self, text);
// SoE:  Fix bsp item placement.
    if (bsp_shift || (self.xsf & XSF_CHEST_HACK))
        self.origin = self.origin + '-16 -16 0';
//- - - - - - - - -
    setsize (self, '0 0 0', '32 32 56');
    StartItem ();
};


//==========================================================================
//
//  ARMOR
//
//==========================================================================

void() armor_touch =
{
    if (other.health <= 0)
        return;

    if (other.xfl & XFL_ITEMS)
    {
        if (!Armor_Add (other, self.armor_stats))
        {
// PM:  In arcanum2, player must touch some armor to proceed.
            if (!self.cnt)
            {
                self.cnt = 1;
                if (world.model == "maps/arcanum2.bsp")
                    {activator = other;  SUB_UseTargets();}
            }
//- - - - - - - - -
            return;
        }
    }
    else if (other.xfl & XFL_HUNGRY)
    {   // Keep only the best.
        if (other.armor_stats_x*other.armor_stats_y <
        self.armor_stats_x*self.armor_stats_y)
            other.armor_stats = self.armor_stats;
    }
    else
        return;

    if (other.flags & FL_CLIENT)
    {   // "You got armor\n"
        sprint (other, "You got ");
        sprint (other, self.netname);
        sprint (other, "\n");
    }
// armor touch sound
    sound (other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");
    
    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

    ClearItem (20);
};


//============
// --> QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
// --> QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
// --> QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
//============
void(float bit) armor_start =
{
    local   float   exotic;

    exotic = bit & SUITx_ALL;
    self.cnt = 0;   // For arcanum2 hack.
    self.touch = armor_touch;
    if (!self.spawned)
    {
        precache_model ("progs/armor.mdl");
        precache_sound ("items/armor1.wav");
    }
    setmodel (self, "progs/armor.mdl");
    if (exotic)
    {
        local   float   nflag;

        nflag = 0;
        if (exotic == SUIT_COURAGE)
        {   // As per Zerstorer, change to Courage Armor.
            if (!self.spawned)
                precache_model ("progs/courage.mdl");
            setmodel (self, "progs/courage.mdl");
            self.skin           = 0;
            self.armor_stats    = ARMOR_STATS_COURAGE;
            self.netname        = "Courage armor";
        }
        else if (exotic == SUIT_DRAGON)     // Was (self.spawnflags & 1)
        {
            if (!self.spawned)      // Enable dragon morph.
                precache_dragonscale ();

            self.armor_stats    = ARMOR_STATS_RED;
            self.skin           = 3;
            self.netname        = "Dragonscale armor";
        }
        else if (exotic == SUIT_ONYX)
        {
            self.armor_stats    = ARMOR_STATS_ONYX;
            self.skin           = 4;
            self.netname        = "Onyx armor";
        }
        else if (exotic == SUIT_ONYX_POWER)
        {
            self.armor_stats    = ARMOR_STATS_ONYX;
            self.skin           = 5;
            self.netname        = "Power armor";
        }
        else if (exotic == SUIT_BERSERKER)
        {
            self.armor_stats    = ARMOR_STATS_DEMON;
            self.skin           = 6;
            self.netname        = "Demonhide armor";
        }
        else if (exotic == SUIT_SPIRIT)
        {   // 0.7 is ideal transparency if skin was more traditional,
            // With its weird, ugly skin, use 0.5 or even 0.3.
            self.alpha          = 0.5;
            self.armor_stats    = ARMOR_STATS_SPIRIT;
            self.skin           = 7;
            self.netname        = "Spirit shroud";
        }
        else if (exotic == SUIT_CHAOS)
        {   // Could call it "Enigma" like the Diablo II armor.
            self.armor_stats    = ARMOR_STATS_CHAOS;
            self.skin           = 8;
            self.netname        = "Chaos armor";
        }
        else if (exotic == SUIT_NINJA)
        {
            self.armor_stats    = ARMOR_STATS_GREEN;
            self.skin           = 9;
            self.netname        = "Jump armor";
        }
        else    // Note:  Ultra armor is unavailable to PCs.
            exotic = 0;     // Invalid exotic.  Default to standard armor.

        self.armor_stats_z  = self.armor_stats_z | exotic;
        if (nflag)
            serverflags = serverflags | nflag;
    }
    if (!exotic)
    {
        if (bit & IT_ARMOR3)
        {
            self.armor_stats = ARMOR_STATS_RED;
            self.skin        = 2;
            self.netname     = "Red armor";
        }
        else if (bit & IT_ARMOR2)
        {
            self.skin        = 1;
            self.armor_stats = ARMOR_STATS_YELLOW;
            self.netname     = "Yellow armor";
        }
        else //if (bit & IT_ARMOR1)
        {
    //- - - - - - - - -
    // SoE:  DarkPlaces fix -- Shunt downward so armor isn't stuck in ceiling.
            if (world.model == "maps/nsoe1.bsp")
                self.origin_z    = self.origin_z - 24;
    //- - - - - - - - -
            self.skin        = 0;
            self.armor_stats = ARMOR_STATS_GREEN;
            self.netname     = "Green armor";
        }
    }
    setsize (self, '-16 -16 0', '16 16 56');
    StartItem ();
};
void() item_armor1 = //{armor_start (IT_ARMOR1);};
{
// SoE:  Replace green armor with red or dragonscale armor.
    if (world.model == "maps/nsoe2.bsp")
        if (self.origin_z >= 128)
        {
            self.spawnflags = 65;
            self.targetname = "plat";
            self.classname = "item_armor_dragon";
            armor_start (SUIT_DRAGON);
            return;
        }
    armor_start (IT_ARMOR1);
//- - - - - - - - -
};
void() item_armor2 = {armor_start (IT_ARMOR2);};
void() item_armorInv =
{
// Check for legacy stuff.
    if (soul_evil && (self.spawnflags & 1))
        armor_start (SUIT_DRAGON);
    else if (self.dmg == 1)
        armor_start (SUIT_COURAGE);     // Zerstorer.
    else
        armor_start (IT_ARMOR3);
};
// Zerstorer's Courage Armor.
void() item_armor4 = {armor_start (SUIT_COURAGE);};

//============
// --> QUAKED item_armor_exotic (0 .5 .8) (-16 -16 0) (16 16 32)
// Custom Exotic Armor.
//
// spawnflags
// 1 = Courage armor (reflects missiles, frontal protection only.  Zerstorer)
// 2 = Dragonscale (red armor that morphs player into dragon.  Soul of Evil)
// 3 = Onyx armor (indestructible, 50% protection.  Inspired by DoomRL.)
// 4 = Power armor (as Onyx, plus power shield like in Quake2)
// 5 = Demonhide (cursed, increases damage taken, but regenerates hp)
// 6 = Spirit shroud (stealth, absorbs up to 25 damage, self-repairs)
// 7 = Chaos armor (variable protection, can teleport as Chaos device from Heretic)
// 8 = Jump armor (green armor with high jump and half health regeneration)
//============
void() item_armor_exotic =
{
    local   float   exotic;

    exotic = self.spawnflags & SUITx_ALL;
    if (!exotic)
        exotic = IT_ARMOR3;
    armor_start (exotic);
};


//==========================================================================
//
//  KEYS
//
//==========================================================================

// This respawns the keys taken by someone.
void() key_recover =
{
    if (self.keyop1)
    {
        if (!self.keyop1.solid)
        {
            self.keyop1.nextthink = 0.01;
            self.keyop1.think = SUB_regen;
        }
        self.keyop1.enemy = world;
        self.keyop1 = world;
        self.items = self.items - (self.items & IT_KEY1);
    }
    if (self.keyop2)
    {
        if (!self.keyop2.solid)
        {
            self.keyop2.nextthink = 0.01;
            self.keyop2.think = SUB_regen;
        }
        self.keyop2.enemy = world;
        self.keyop2 = world;
        self.items = self.items - (self.items & IT_KEY2);
    }
};

// Keys respawn if the carrier drops out of the game unexpectantly.
void() key_think =
{
    self.nextthink = time + 0.1;

    if (self.enemy)
    {
        if (self.items & IT_KEY1)
        {
            if (self.enemy.keyop1 == self)
                if (!self.enemy.deadflag)   // Here for disconnected players.
                    return;
            self.enemy.keyop1 = world;
            self.enemy.items = self.enemy.items - (self.enemy.items & IT_KEY1);
        }
        else if (self.items & IT_KEY2)
        {
            if (self.enemy.keyop2 == self)
                if (!self.enemy.deadflag)   // Here for disconnected players.
                    return;
            self.enemy.keyop2 = world;
            self.enemy.items = self.enemy.items - (self.enemy.items & IT_KEY2);
        }
    }
// Restore the key.
    self.nextthink = 0;
    self.enemy = world;
    if (!self.solid)
        SUB_regen ();
};

void() key_touch =
{
    if (other.health <= 0)
        return;
    if (other.items & self.items)
        return;     // Can carry only one instance of the key at a time.
                    // Just like the old Stern game Tutenkhamon.

    // Hungry alone won't let creature take this item.
    if (!(other.xfl & XFL_ITEMS))
        return;

    if (other.flags & FL_CLIENT)
    {
        sprint (other, "You got the ");
        sprint (other, self.netname);
        sprint (other,"\n");
    }
    sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

    other.items = other.items | self.items;

// DISABLED -- In Drake, keys always disappear when taken, unlike in standard.
//    if (!coop)
    {
        // Set keyops to restore the keys if 'other' dies later.
        if (self.items & IT_KEY1)
            other.keyop1 = self;
        else if (self.items & IT_KEY2)
            other.keyop2 = self;

        // Hide the keys.
        self.solid = SOLID_NOT;
        self.model = world.null_string;     //string_null;
        self.enemy = other;     // Remember who took the key.
    }

    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

// PM:  We cannot remove the entity now because it will respawn if the
// key carrier dies before using the key.

// Update 11/15/09:  Make sure whoever took the key stays in the game.
// If not, respawn.
    self.nextthink = time + 0.1;
    self.think = key_think;
};


//============
// --> QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
// SILVER key
// --> QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
// GOLD key
// In order for keys to work
// you MUST set your maps
// worldtype to one of the
// following:
// 0: medieval
// 1: metal
// 2: base
// (PM's note:  worldtype will default to 0 if none of the above.)
//============
void(float keyitem) item_key =
{
    local   string  km, ks;

    if (world.worldtype == 2)
    {
        km = "progs/key_b.mdl";
        ks = "misc/basekey.wav";
        if (keyitem & IT_KEY1)
            {self.skin = 0; self.netname = "silver keycard";}
        else //if (keyitem & IT_KEY2)
            {self.skin = 1; self.netname = "gold keycard";}
    }
    else if (world.worldtype == 1)
    {
        km = "progs/key_m.mdl";
        ks = "misc/runekey.wav";
        if (keyitem & IT_KEY1)
            {self.skin = 0; self.netname = "silver runekey";}
        else //if (keyitem & IT_KEY2)
            {self.skin = 1; self.netname = "gold runekey";}
    }
    else //if (world.worldtype == 0)
    {
        km = "progs/key_w.mdl";
        ks = "misc/medkey.wav";
        if (keyitem & IT_KEY1)
            {self.skin = 0; self.netname = "silver key";}
        else //if (keyitem & IT_KEY2)
            {self.skin = 1; self.netname = "gold key";}
    }

    if (!self.spawned)
    {
        precache_model (km);
        precache_sound (ks);
    }
    setmodel (self, km);
    self.noise = ks;

    self.enemy = world;
    self.touch = key_touch;
    self.items = keyitem;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};
void() item_key1 = {item_key (IT_KEY1);};
void() item_key2 = //{item_key (IT_KEY2);};
{
// SoE:  Hack to change targetname to activate something.
    if (world.model == "maps/nsoe1.bsp")
        self.target = "critter2";
    item_key (IT_KEY2);
};


//===========================================================================
//  END OF LEVEL RUNES
//===========================================================================

//void() weapon_chainsaw;     // For OUM.

void() sigil_touch =
{
    if (other.health <= 0)
        return;

    // Hungry alone won't let creature take this item.
    if (!(other.xfl & XFL_ITEMS))
    {   // Allow player actors take runes in a cutscene.
        if (!cutscene || self.worldtype)
            return;
        if (other.classname != "actor")
            return;
    }

    if (self.worldtype)
    {   // Soul of Evil MacGuffin.
        Safe_centerprint (other, "You got the seal of Bane!");
        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
        Safe_stuffcmd (other, "bf\n");
        if (other.master)
        {
            Safe_centerprint (other.master, "One of your minions got Bane's seal!");
            Safe_stuffcmd (other.master, "bf\n");
        }
    // Powerup all players for the final fight with Bane.
    // * Increase all players' maximum health by 50.
    // * Turn off corpse removal so Bane can revive his minions.
        {
            local   entity  pl;

            pl = find (world, classname, "player");
            while (pl)
            {
                pl.max_health = pl.max_health + 50;
                if (pl.health < pl.max_health)
                    pl.hit_points = pl.health = pl.max_health;
                pl = find (pl, classname, "player");
            }
            corpse_removal = FALSE;
        }
    }
    else
    {   // Normal Quake runes.
        Safe_centerprint (other, "You got the rune!");
        sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
        Safe_stuffcmd (other, "bf\n");
        if (other.master)
        {   // Duel Monsters -- notify master!
            Safe_centerprint (other.master, "One of your minions got the rune!");
            Safe_stuffcmd (other.master, "bf\n");
        }
    }

    self.solid = SOLID_NOT;
    self.model = world.null_string;     //string_null;
    serverflags = serverflags | (self.spawnflags & 15);
    HUD_ServerRunes ();         // Update items2 field for all players.
    self.classname = "";        // so rune doors won't find it
    
    activator = other;
//- - - - - - - - -
// Update 8/22/10:  If rune has a map, and no exit is found, leave the map.
    if (self.map)
    {
        if (!find (world, classname, "trigger_changelevel"))
        {
            self.spawnflags = self.spawnflags - (self.spawnflags & 15);
            changelevel_activate ();    // Calls SUB_UseTargets.
            return;
        }
    }
//- - - - - - - - -
    SUB_UseTargets ();          // fire all targets / killtargets

// PM:  Don't need the rune now.
    Remove_Ent (self);      // Use instead of 'remove(self)'.
};

//============
// --> QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
// End of level sigil, pick up to end episode and return to jrstart.
//============
void() item_sigil =
{
    local   string  text;
//    local   float   rune;

// FIXME:  If Tronyn has more than four episodes for merger, add more runes.
// Note:  No spawnflags was "weapon_chainsaw" in OUM.
// Note#2:  Latest merger has episodes within episodes, so runes may not
// be useful for it.
    if (!(self.spawnflags & 15))
    {
//        if (oum)
//            {self.classname = "weapon_chainsaw"; weapon_chainsaw(); return;}
//        else
            objerror ("no spawnflags");
    }

    if (self.spawnflags & 8)
        text = "progs/end4.mdl";
    else if (self.spawnflags & 4)
        text = "progs/end3.mdl";
    else if (self.spawnflags & 2)
        text = "progs/end2.mdl";
    else //if (self.spawnflags & 1)
        text = "progs/end1.mdl";
//- - - - - - - - -
/* DISABLED -- For merger only, which will be worked on in due time.
    // Code for Tronyn's merger.  Combine spawnflags for higher runes.
    // Spawnflags higher than sf8 are reserved for other things.
    rune = 0;
    if (self.spawnflags & 8)
        rune = rune + 4;
    if (self.spawnflags & 4)
        rune = rune + 3;
    if (self.spawnflags & 2)
        rune = rune + 2;
    if (self.spawnflags & 1)
        rune = rune + 1;

    if (rune >= 4)
        text = "progs/end4.mdl";
    else if (rune == 3)
        text = "progs/end3.mdl";
    else if (rune == 2)
        text = "progs/end2.mdl";
    else
        text = "progs/end1.mdl";
*/
//- - - - - - - - -

    if (!self.spawned)
    {
        precache_model (text);
        precache_sound ("misc/runekey.wav");
    }
    setmodel (self, text);
    self.noise = "misc/runekey.wav";

    self.worldtype = 0;
    self.touch = sigil_touch;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_sigil_bane (0 .5 .8) (-16 -16 -24) (16 16 32)
// Unique item for nsoe5.  Pick up to activate final fight with Bane.
//============
void() item_sigil_bane =
{
    if (!self.spawned)
    {
        precache_model ("progs/end_bane.mdl");
        precache_sound ("misc/runekey.wav");
    }
    setmodel (self, "progs/end_bane.mdl");
    self.noise = "misc/runekey.wav";

    self.worldtype = 1;
    self.touch = sigil_touch;
    // Remove first four spawnflags so sigil_touch doesn't add serverflags.
    self.spawnflags = self.spawnflags - (self.spawnflags & 15);
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};


//===========================================================================
//
//  POWERUP ARTIFACTS
//
//===========================================================================

// PM:  Drake and Tronyn's projects feature many artifacts.  Below is a
// list of the artifacts included.  Few of which are in other files.
// -- Classic Powerups --
// * Biosuit
// * Quad Damage
// * Pentagram of Protection (invulnerability)
// * Ring of Shadows (invisibility)
// -- Mission Powerups --
// * Empathy Shields (thorns)
// -- Custom Powerups ---
// * Amulet of Reflection
// * Berserker Helm
// * Boots of Levitation
// * Cross of Deflection
// * Twin Shot (was Equalizer in Soul of Evil)
// * Heart of Darkness (max life up)
// * Monster Dolls
// * Rejuvenator
// * Shotgun Optimizer
// * Super Pack
// * Tome of Power
// ----------------------
// Called to remove or reset an artifact item.
void() Powerup_Clear =
{
// Invulnerability, invisibility, and reflection take five minutes to respawn.
// Reflection is almost as good as invulnerability against firearms.
// Everything else takes one minute, summoning delays notwithstanding.
    if ( (self.items & (IT_PROTECT | IT_INVISO)) || self.mirror_finished )
        ClearItem (300);
    else
        ClearItem (60);
};

// Thinking for monster-summoning artifacts.
void() Powerup_Summon =
{
    if (!IsDead (self.owner))
    {
        if (!cutscene)      // Don't summon monsters around the camera.
        {
            local   float   loop;

            loop = self.dmg;
            while (loop > 0)
            {
                if (SpawnMonster_Circle (self.owner, self.worldtype))
                    self.dmg = self.dmg - 1;    // Successfully spawned one.
                loop = loop - 1;
            }
        }
        if (self.dmg > 0)
        {   // Couldn't summon everything now -- try again later.
            self.nextthink = time + 1;
            return;
        }
    }
    Powerup_Clear ();
};

void(entity ent) Powerup_Start =
{
//    sound (ent, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    ent.items = ent.items | self.items;
    ent.items2 = ent.items2 | self.items2;
// PM:  Don't let runes overwrite the expansion icons.
    if (ent.items2 & IT2_WETSUIT)
        ent.items2 = (ent.items2 - (ent.items2 & IT2x_RUNES12)) | IT2_WETSUIT;
    if (ent.items2 & IT2_SHIELDS)
        ent.items2 = (ent.items2 - (ent.items2 & IT2x_RUNES34)) | IT2_SHIELDS;

// Standard Quake powerups.  'self' is the item to be taken.
// Set '***_time' to zero, so the three second warning gets played.
// Then set '***_finished' to time + 30 or whatever to activate powerup.
    if (self.invisible_finished)
    {   ent.invisible_time        = 0;
        ent.invisible_finished    = time + self.invisible_finished;
    }
    if (self.invincible_finished)
    {   ent.invincible_time       = 0;
        ent.invincible_finished   = time + self.invincible_finished;
    }
    if (self.radsuit_finished)
    {   ent.rad_time              = 0;
        ent.radsuit_finished      = time + self.radsuit_finished;
    }
    if (self.super_damage_finished)
    {   ent.super_time            = 0;
        ent.super_damage_finished = time + self.super_damage_finished;
    }
// Hipnotic
    if (self.thorns_finished)
    {   ent.thorns_time           = 0;
        ent.thorns_finished       = time + self.thorns_finished;
    }
// Quoth
    if (self.cross_finished)
    {   ent.cross_time            = 0;
        ent.cross_finished        = time + self.cross_finished;
    }
// Custom
    if (self.wing_finished)
    {   ent.wing_time             = 0;
        ent.wing_finished         = time + self.wing_finished;
    }
    if (self.mirror_finished)
    {   ent.mirror_time           = 0;
        ent.mirror_finished       = time + self.mirror_finished;
    }
    if (self.tome_finished)
    {   ent.tome_time             = 0;
        ent.tome_finished         = time + self.tome_finished;
    }
    if (self.perms & POW_PACK)      // Check superpack before equalizer.
    {   // Bulk pack -- increase ammo capacity and give some ammo.
        // Add flag first, then give ammo.
        ent.perms = ent.perms | POW_PACK;

        ent.ammo_shells    = ent.ammo_shells + LARGE_SHELLS;
        ent.ammo_nails     = ent.ammo_nails + LARGE_NAILS;
        ent.ammo_rockets   = ent.ammo_rockets + LARGE_ROCKETS;
        ent.ammo_cells     = ent.ammo_cells + LARGE_CELLS;
        bind_ammo (ent);
    }
    if (self.perms & POW_SHOTTYMAN)
    {   // Optimizer -- Max shells and upgrade shotguns.
        ent.perms = ent.perms | POW_SHOTTYMAN;
        if (ent.perms & POW_PACK)
            ent.ammo_shells = AMAX2_SHELLS;
        else
            ent.ammo_shells = AMAX_SHELLS;
    }
    if (self.perms & POW_DOUBLE)
    {   // Equalizer -- Max nails and upgrade nailguns.
        ent.perms = ent.perms | POW_DOUBLE;
        // Note:  Max nails because item no longer works on shotguns/shells.
        if (ent.perms & POW_PACK)
            ent.ammo_nails  = AMAX2_NAILS;
        else
            ent.ammo_nails  = AMAX_NAILS;
    }
    if (self.perms & POW_VAMPIRE)
    {   // Berserker -- Full heal and upgrade melee.
        ent.perms = ent.perms | POW_VAMPIRE;
        T_Heal (ent, ent.max_health, 0);
    }
    if (self.items2 & (IT2_REGEN | IT2_REGEN2))
    {   // Regeneration.
        if (ent.flags & FL_CLIENT)
            Regen_ClientReset (ent);
        else    // FIXME:  Watch out for possible abuse!
        {
            if (self.items2 & IT2_REGEN)
                Regen_Add (ent, REGEN_RATE1);   // Set/combine regen rate.
            if (self.items2 & IT2_REGEN2)
                Regen_TwoAdd (ent, 0, REGEN_RATE1);
        }
    }
    if (self.max_health > 0)    // Heart of Darkness.
    {
        local   float   hp;

        hp = floor (ent.max_health + self.max_health);
        if (hp > 250)
            hp = 250;
        if (ent.max_health < hp)
            ent.max_health = hp;
        T_Heal (ent, ent.max_health, FALSE);
    }
};

void() powerup_touch =
{
    if (other.health <= 0)
        return;

    if (!(other.xfl & XFL_ITEMS))
        return;

//- - - - - - - - -
    if (self.lefty)
    {   // Powerup remains after pickup.
        if (self.perms & other.perms)
            return;     // Already have it, so leave it!
    }
//- - - - - - - - -

    if (other.flags & FL_CLIENT)
    {
        sprint (other, "You got the ");
        sprint (other, self.netname);
        sprint (other, "\n");
    }
    sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    Safe_stuffcmd (other, "bf\n");

//----- do the apropriate action -----
// 1) Power up the guy who touched the item.
    Powerup_Start (other);
// 2) Power up the guy's immediate master.
    if (other.master)
        if (!IsDead (other.master))
        {
            if (other.master.flags & FL_CLIENT)
            {
                if (other.netname)
                    sprint (other.master, other.netname);
                else
                    sprint (other.master, "A minion");
                sprint (other.master, " gives you the ");
                sprint (other.master, self.netname);
                sprint (other.master,"\n");
            }
            sound (other.master, CHAN_VOICE, self.noise, 1, ATTN_NORM);
            Safe_stuffcmd (other.master, "bf\n");
            Powerup_Start (other.master);
        }
//------------------------------------

    activator = other;
    SUB_UseTargets ();      // fire all targets / killtargets

//- - - - - - - - -
    if (self.lefty)
        return;
//- - - - - - - - -
    // Taking a cue from the megahealth code...
    if (self.worldtype)
    {   // Summoning a monster...
        self.dmg = self.cnt;
        self.solid = SOLID_NOT;
        self.model = world.null_string;     //string_null;
        if (other.master)
            self.owner = other.master;
        else
            self.owner = other;
        self.think = Powerup_Summon;
        self.think ();
        return;
    }
//- - - - - - - - -
    Powerup_Clear ();
};

//============
// --> QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
// Player is invulnerable for 30 seconds
//============
void() item_artifact_invulnerability =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_PROTECT_END;
        precache_model ("progs/invulner.mdl");
        precache_sound ("items/protect.wav");
        precache_sound ("items/protect2.wav");
        precache_sound ("items/protect3.wav");
    }
    self.noise      = "items/protect.wav";
    setmodel (self, "progs/invulner.mdl");
    self.netname    = "Pentagram of Protection";
    self.items      = IT_PROTECT;
    self.invincible_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
// Player takes no damage from water or slime for 30 seconds
//============
void() item_artifact_envirosuit =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_SUIT_END;     //| PCH_SCUBA_USE;
        precache_model ("progs/suit.mdl");
        precache_sound ("items/suit.wav");
        precache_sound ("items/suit2.wav");
    }
    self.noise = "items/suit.wav";
    setmodel (self, "progs/suit.mdl");
    self.netname = "Biosuit";
    self.items = IT_SUIT;
    self.radsuit_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
// Player is invisible for 30 seconds
//============
void() item_artifact_invisibility =
{
//// Zerstorer support.
//    if (zerstorer)
//        if (self.dmg == 1)
//        {
//            self.classname = "item_artifact_wings";
//            item_artifact_wings ();
//            return;
//        }
////- - - - - - - - - -
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_INVISO_USE;
        precache_model ("progs/invisibl.mdl");
        precache_sound ("items/inv1.wav");
        precache_sound ("items/inv2.wav");
        precache_sound ("items/inv3.wav");
    }
    self.noise = "items/inv1.wav";
    setmodel (self, "progs/invisibl.mdl");
    self.netname = "Ring of Shadows";
    self.items = IT_INVISO;
    self.invisible_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
// The next attack from the player will do 4x damage
//============
void() item_artifact_super_damage =
{
//// Zerstorer support.
//    if (zerstorer)
//        if (self.dmg == 1)
//        {
//            self.classname = "item_bloodcube";  // Will be changed later.
//            item_bloodcube ();
//            return;
//        }
////- - - - - - - - - -
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_QUAD_END;
        precache_model ("progs/quaddama.mdl");
        precache_sound ("items/damage.wav");
        precache_sound ("items/damage2.wav");
        precache_sound ("items/damage3.wav");
    }
    self.noise = "items/damage.wav";
    setmodel (self, "progs/quaddama.mdl");
    self.netname = "Quad Damage";
    self.items = IT_QUAD;
    self.super_damage_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
// Player takes no damage from electrical attacks and swims faster for
// 30 seconds
//============
void() item_artifact_wetsuit =
{
// SoE:  Merged with biosuit.
    self.classname = "item_artifact_envirosuit";
    item_artifact_envirosuit ();
};

//============
// --> QUAKED item_artifact_empathy_shields (0 .5 .8) (-16 -16 0) (16 16 32)
// Empathy Shield.
//============
// PM:  Similar to Diablo II's Thorns plus Shaftstop rolled into one.
void() item_artifact_empathy_shields =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_SUIT_END;
        precache_model ("progs/empathy.mdl");
        precache_sound ("hipitems/empathy.wav");
        precache_sound ("hipitems/empathy2.wav");
        precache_sound ("items/suit2.wav");
    }
    self.noise = "hipitems/empathy.wav";
    setmodel (self, "progs/empathy.mdl");
    self.netname = "Empathy Shields";
    self.items = 0;
    self.thorns_finished = 30;
    setsize (self, '-16 -16 0', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_levitation (0 .5 .8) (-16 -16 -24) (16 16 32)
// Gives the player limited flying ability
//============
void() item_artifact_levitation =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_WING_END | PCH_WING_USE;
        precache_model ("progs/levitate.mdl");
        precache_sound ("ambience/wingget.wav");
        precache_sound ("ambience/wingend.wav");
        precache_sound ("items/levitate.wav");
    }
    setmodel (self, "progs/levitate.mdl");
    self.netname = "Boots of Levitation";
    self.wing_finished = 45;    // As DoE's antigrav belt.
    self.noise = "ambience/wingget.wav";
    self.items = 0;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};
// Original classname in Zerstorer.
// Note:  Replaced Zerstorer's Dark-Angel Wings with Boots of Levitation.
void() item_wings =
    {self.classname = "item_artifact_levitation";  item_artifact_levitation();};

//============
// --> QUAKED item_artifact_reflection (0 .5 .8) (-16 -16 -24) (16 16 32)
// Force field repels missiles away from player for 30 seconds
//============
void() item_artifact_reflection =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_MIRROR_END | PCH_MIRROR_USE;
        precache_model ("progs/reflect.mdl");
        precache_sound ("items/reflect.wav");
        precache_sound ("items/reflect2.wav");      //"items/protect2.wav"
        precache_sound ("items/reflect3.wav");
    }
    self.noise = "items/reflect.wav";
    setmodel (self, "progs/reflect.mdl");
    self.netname = "Amulet of Reflection";
    self.items = 0;
    self.mirror_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_tomeofpower (0 .5 .8) (-16 -16 -24) (16 16 32)
// Modify and strengthen weapon effects for 30 seconds
// Just like in Hereric/Hexen
//============
void() item_artifact_tomeofpower =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_QUAD_END;     //| PCH_TOME_END;
        precache_model ("progs/tome_pow.mdl");
        precache_sound ("items/damage2.wav");   //"items/tomepow2.wav";
        precache_sound ("items/tomepow.wav");
    }
    self.noise = "items/tomepow.wav";
    setmodel (self, "progs/tome_pow.mdl");
    self.netname = "Tome of Power";
    self.items = 0;
    self.items2 = IT2_WETSUIT;
    self.tome_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};
// Convert Quoth's Trinity item into the Tome of Power!
void() item_artifact_trinity =
    {self.classname = "item_artifact_tomeofpower";  item_artifact_tomeofpower();};

//============
// --> QUAKED item_artifact_cross (0 .5 .8) (-16 -16 -24) (16 16 32)
// Cross of Deflection
//
// Grants immunity to splash damage and protection from the elements.
// All other damage reduced by half.
//============
void() item_artifact_cross =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        powcache = powcache | PCH_CROSS_END | PCH_CROSS_USE;
        precache_model ("progs/cross.mdl");
        precache_sound ("items/crosend.wav");
        precache_sound ("items/crostake.wav");
        precache_sound ("items/crosuse.wav");
    }
    self.noise = "items/crostake.wav";
    setmodel (self, "progs/cross.mdl");
    self.netname = "Cross of Deflection";
    self.items = 0;
    self.items2 = IT2_SHIELDS;
    self.cross_finished = 30;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_regeneration (0 .5 .8) (-16 -16 -24) (16 16 32)
// Raises health to maximum, then activates regeneration.
// Player can regenerate health at a rate of 50 per minute.
// Lasts until death or end of level.
//============
void() item_artifact_regeneration =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        if (self.spawnflags & 1)
            precache_model ("progs/regen2.mdl");
        else
            precache_model ("progs/regen.mdl");
        precache_sound ("items/regen.wav");
    }
    self.noise = "items/regen.wav";
    if (self.spawnflags & 1)
    {
        setmodel (self, "progs/regen2.mdl");
        self.netname = "Lesser rejuvenator";
        self.items2 = IT2_REGEN;    // FIXME:  Use IT2_REGEN2 when rules are set.
    }
    else
    {
        setmodel (self, "progs/regen.mdl");
        self.netname = "Rejuvenator";
        self.items2 = IT2_REGEN;
    }
    self.items = 0;
    if (self.skin == 1)
        weapon_leave ();        // Treat this item like a weapon.
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_equalizer (0 .5 .8) (-16 -16 -24) (16 16 32)
// Nailguns fire two nails at the price
// of one -- permanently.
//
// Also fills nails to the maximum.
//============
void() item_artifact_equalizer =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        precache_model ("progs/gemini.mdl");
        precache_sound ("items/equalize.wav");
    }
    self.noise = "items/equalize.wav";
    setmodel (self, "progs/gemini.mdl");
    self.netname = "Twin Shot";     //"Equalizer";
    self.items = 0;
    self.perms = POW_DOUBLE;
    weapon_leave ();        // Treat this item like a weapon.
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

// Scrapped new 'item_artifact_medal'.  Item would have allowed the axe
// to chop up zombies and let player throw Mjolnir.  Just cut the middleman
// and let the player do that without an upgrade item.  Tronyn doesn't
// need it, and it won't do me any good if I do not make maps of my own.

//============
// --> QUAKED item_artifact_optimizer (0 .5 .8) (-16 -16 -24) (16 16 32)
// Shotguns fire faster -- permanently.
//
// Also fills shells to the maximum.
//============
void() item_artifact_optimizer =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        precache_model ("progs/shotty.mdl");
        precache_sound ("items/optimize.wav");
    }
    self.noise = "items/optimize.wav";
    setmodel (self, "progs/shotty.mdl");
    self.netname = "Shotgun optimizer";
    self.items = 0;
    self.perms = POW_SHOTTYMAN;
    weapon_leave ();        // Treat this item like a weapon.
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_optimizer (0 .5 .8) (-16 -16 -24) (16 16 32)
// Buffs melee damage and gives
// life leech -- permanently.
//
// Also fills shells to the maximum.
//============
void() item_artifact_berserker =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        precache_model ("progs/zerkhelm.mdl");
        precache_sound ("items/zerkhelm.wav");
    }
    self.noise = "items/zerkhelm.wav";
    setmodel (self, "progs/zerkhelm.mdl");
    self.netname = "Berserker Helm";
    self.items = 0;
    self.perms = POW_VAMPIRE;
    weapon_leave ();        // Treat this item like a weapon.
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_vitality (0 .5 .8) (-16 -16 -24) (16 16 32)
// Increases maximum health and health by 25.
// Maximum health boost lasts until end of level.
// FIXME:  Make heart like Zelda's Heart Containers (i.e., permanent).
//============
void() item_artifact_vitality =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        precache_model ("progs/life_up.mdl");
        precache_sound ("items/life_up.wav");
    }
    self.noise = "items/life_up.wav";
    setmodel (self, "progs/life_up.mdl");
    self.netname = "Heart of Darkness";
    self.items = 0;
    self.max_health = 25;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_super_pack (0 .5 .8) (-16 -16 -24) (16 16 32)
// Increases ammo capacity.  Works like backpack from Doom.
//============
void() item_artifact_super_pack =
{
    self.touch = powerup_touch;

    if (!self.spawned)
    {
        precache_model ("progs/uberpack.mdl");
        precache_sound ("weapons/pkup.wav");
    }
    self.noise = "weapons/pkup.wav";
    setmodel (self, "progs/uberpack.mdl");
    self.netname = "Super Pack";
    self.items = 0;
    self.perms = POW_PACK;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};

//============
// --> QUAKED item_artifact_monster (0 .5 .8) (-16 -16 -24) (16 16 32)
// Summons a tame monster.
//============
void() item_artifact_monster =
{
// FIXME:  Use string to float conversion.
    if (!self.mdl)
        self.mdl = "progs/doll03.mdl";
    if (!self.noise)
        self.noise = "items/shambler.wav";
    if (!self.netname)
        self.netname = "Monster Doll";
    if (!self.worldtype)
        self.worldtype = ID_SHAMBLER_WHITE; // Default to shambler
    if (!self.cnt)
        self.cnt = 1;

    self.touch = powerup_touch;

    if (!self.spawned)
    {
        precache_model (self.mdl);
        precache_sound (self.noise);
// FIXME:  ???
//        cache_monster (self.worldtype);
    }
    setmodel (self, self.mdl);
    self.items = 0;
    setsize (self, '-16 -16 -24', '16 16 32');
    StartItem ();
};
//void() item_artifact_summon =
//    {self.classname = "item_artifact_monster";  item_artifact_monster();};

//============
// --> QUAKED item_artifact_shambler (0 .5 .8) (-16 -16 -24) (16 16 32)
// Gives the player a pet shambler.
//============
void() item_artifact_shambler =
{
    self.mdl = "progs/doll03.mdl";
    self.noise = "items/shambler.wav";
    self.netname = "Shambler Doll";
    self.worldtype = ID_SHAMBLER_WHITE;
//    self.cnt = 1;
    item_artifact_monster ();
};

//- - - - - - - - -
// This changes the item's skin.  Repeat every two seconds.
void() draco_shift =
{
    self.skin = (self.skin + 1) & 3;
    self.worldtype = ID_DRAGON_RED + self.skin;
    self.nextthink = time + 2;
};

// Sets up item thinking for 'draco_shift'.  Do NOT change skins here.
void() draco_check = {self.nextthink = time + 2; self.think = draco_shift;};
//- - - - - - - - -

//============
// --> QUAKED item_artifact_dragon (0 .5 .8) (-16 -16 -24) (16 16 32) Cycle
// Gives the player a pet dragon.  Replaces old Draco bot item.
// Cycle:  Item type changes every 2 seconds.
//============
void() item_artifact_dragon =
{
    self.mdl = "progs/draco.mdl";
    self.noise = "weapons/pkup2.wav";
    self.netname = "Dragon Doll";
    self.skin = self.skin & 7;
    if (self.skin > 4)
        self.skin = 0;
    self.worldtype = ID_DRAGON_RED + self.skin;
    if (self.spawnflags & 1)
        self.th_win = draco_check;
//    self.cnt = 1;
    item_artifact_monster ();
};
void() item_draco =
    {self.classname = "item_artifact_dragon"; item_artifact_dragon();};
void() item_dragon =
    {self.classname = "item_artifact_dragon"; item_artifact_dragon();};


//===========================/  END OF FILE  /===========================//
