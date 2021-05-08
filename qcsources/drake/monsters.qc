// ALL MONSTERS SHOULD BE 1 0 0 IN COLOR

// name =[framenum,    nexttime, nextthink] {code}
// expands to:
// name ()
// {
//        self.frame=framenum;
//        self.nextthink = time + nexttime;
//        self.think = nextthink
//        <code>
// };


//================
// monster_use
//
// Using a monster makes it angry at the current activator
// PM:  ...or, if monster is a good guy, friendly to the current activator
//================
void() monster_use =
{
//- - - - -
    if (horn_charmer)   // Defined in 'spawn.qc'.
    if (!(self.spawnflags & SPAWN_WHITE))
    if (self.xf2 & XF2_HORN)
    {   // The horn tames otherwise hostile monsters.
        // Note:  Bad guys who take the horn get a hostile monster...
        // Note#2:  This is for monsters not spawned by func_spawn.
        if (self.oldenemy == horn_charmer)
            self.oldenemy = world;
        if (self.enemy == horn_charmer)
            self.enemy = self.oldenemy;
        self.spawnflags = self.spawnflags | SPAWN_WHITE;
        Align_Remove (self);
        Align_Add (self, TRUE);
        // PM:  Yes, it's cheesy, but I don't want players killing a pet
        // just to get 100% kills.  Plus, pets spawned dynamically via
        // other items (e.g., dolls) don't add to kills.
        // That said, if the new pet needs to die to trigger stuff, so be it.
        AddToKills ();      // In combat.qc.  Remove kill flag from pet.
    }
//- - - - -
    if (self.spawnflags & SPAWNx_DELAY)
    {   // This is a one-time event.
        self.spawnflags = self.spawnflags - (self.spawnflags & SPAWNx_DELAY);
        self.flags      = self.flags - (self.flags & FL_ONGROUND);

        if (self.modelindex || self.deadflag)
            return;     // Likely revealed by massacre cheat.

    // DarkPlaces mod used modelindex alone to restore the model, but it
    // doesn't restore the proper size should that be changed.  In theory,
    // size change shouldn't happen, but it can.  (Or perhaps the proper
    // size wasn't set to begin with.)  I don't know what exactly causes it.
    // Therefore, reset model and size to fix it.
        setmodel (self, self.mdl);
        setsize (self, self.dest1, self.dest2);
        ai_synch ();    // For multi-part monsters.
        self.nextthink  = time + 0.1;
        self.movetype   = self.xsf & XSF_MOVETYPE;  // Restore movetype.
        if (self.movetype == MOVETYPE_NOCLIP)
        {
            self.solid      = SOLID_TRIGGER;
            // Ghosts use phasing in ambush mode, so don't set damage.
            // Nightshades always phase regardless of ambush.
            if (!(self.spawnflags & 1))
                if (self.classname != "monster_nightshade")
                    self.takedamage = DAMAGE_AIM;
        }
        else
        {
            self.solid      = SOLID_SLIDEBOX;
            self.takedamage = DAMAGE_AIM;
        }
        if (self.takedamage == DAMAGE_AIM)
        {
            if (!(self.xsf & XSF_SPAWNSILENT))
            {   // Do teleport effects -- i.e., possible splash and telefrag.
                summon_tfog (self);
            }
            spawn_tdeath (self.origin, self);
        }
        // ELSE... it's a ghost phasing in.

        if (!(self.xsf & XSF_SPAWNAWARE))
            return;     // Not allowed to react to activator.
    }

    if (self.health <= 0)
        return;
// - - - - -
    // If targeted to another monster, attack it instead.
    // We don't care about its sight sound here so do it this frame.
//    if (zerstorer)
//      if (self.zerc == -1)
//        if (activator.classname == "player")
//          if (self.oldenemy)
//            if (self.oldenemy != self)
//              if (self.oldenemy != self.enemy)
//                if (self.oldenemy.health > 0)
//                {
//                    self.zerc = 0;  // One-time event.
//                    self.enemy = self.oldenemy;
//                    FoundTarget ();
//                    return;
//                }
// - - - - -
    if (self.enemy)
        return;
    if (activator.invisible_finished || (activator.items & IT_INVISO))
        return;     // PM:  Always even if monster can see the invisible.
    if (activator.flags & FL_NOTARGET)
        return;
    if (activator.xfl & XFL_NO_SCAN)
        return;     // Assume Zerstorer player standin.

// delay reaction so if the monster is teleported, its sound is still heard
    if (self.alignment == GOOD)
    {   // Good guys become a follower instead of an enemy of the activator.
        if (activator.classname != "player")
            return;     // Monsters follow only the PCs.
        if (self.master)
            return;
    // Turn off pacifist so it can attack enemies on sight.
    // Not how I want to do this, but it suffices for now.
        self.ryuflags   = self.ryuflags - (self.ryuflags & RYU_CALM);
        self.master     = activator;
        self.think      = FoundMaster;
    }
    else
    {   // Bad guys just get mad.
        if (Align_Match (self, activator))
            return;
        self.enemy      = activator;
        self.think      = FoundTarget;
    }
    self.nextthink  = time + 0.1;
};

//================
// monster_death_use
//
// When a monster dies, it fires all of its targets with the current
// enemy's big boss as activator.
//================
void() monster_death_use =
{
    if (self.xfl & XFL_PET)
    {   // Reduce counter so master can make more monsters.
        self.xfl = self.xfl - XFL_PET;
        if (self.master)
            self.master.pets = self.master.pets - 1;
    }
    if (!self.spawned)
        self.master = world;

// Remove monster from the hitlists.
    Align_Remove (self);

// Place stolen keys back to where they were found.
    key_recover ();

// Remove all powerups and their effects.
// Note:  Monsters who spawn with lights (e.g., drone) lose such effects.
    SUB_RemovePowerups ();

// fall to ground
    self.flags = self.flags - (self.flags & (FL_FLY | FL_SWIM));

// Activate targets if applicable.
// FIXME:  Check for killtarget?
    if (!self.target)
        if (!self.target2)
            return;

// PM:  If killed by a minion, make its master the activator.
// Why you ask?  So that any message triggered is sent to the master (player).
    activator = Patriarch (self.enemy);
    SUB_UseTargets ();
};


//- - - - - - - - -

//================
// monster_touch
//
// Lets player walk on top of a monster like on ground.
// Use on very short monsters like spiders or huge monsters with flat tops
// such as Arcanum's modified shub boss.
//================
void() monster_touch =
{
    if (other.flags & FLx_CREATURE)
    {
        if (other.movetype == MOVETYPE_WALK)
            CheckOnTop ();      // In 'chest.qc'.
    }
};


//============================================================================

//================
// monster_resurrect
//
// Monster attempts to resurrect itself.  Thinking set by 'monster_end'.
//================
void() monster_resurrect =
{
    if (intermission_running)
    {   // End of level.
        self.nextthink = -1;
        self.think = SUB_Null;
        return;
    }

    Doom_NextThink (32);

    if (prandom() > 4)
        return;     // Small chance, same as in Doom.
    monster_revive (self, self);
};

//================
// monster_null
//
// Neutralizes links on a monster before its removal.
//================
void() monster_null =
{
    Burn_Null (self);   // Remove any flames burning on self.
    // FIXME:  This next one shouldn't be called here.  (Check wrath*.qc)
    Pets_Free (self);   // In case of sudden removal, unlink all pets.

// Don't let other entities activate corpse as it decays.
//    self.solid      = SOLID_NOT;
    self.use        = self.touch    = SUB_Null;
    self.targetname = world.null_string;

// Eliminate any possibility of taking more damage.
    self.takedamage = DAMAGE_NO;    // So corpse cannot be gibbed.
    // Disable gibbing and resurrection functions.
    self.th_gib     =
    self.th_revive  =
    self.th_spawn   = world.null_func;

// Removal sets entity's origin at '0 0 0', and C physics code may play
// splashing sound in the process.  Preset entity's water stats at origin
// now it won't splash when (re)moved.
    if (pco <= CONTENT_WATER)
        {self.watertype = pco;  self.waterlevel = 1;}
    else
        {self.watertype = CONTENT_EMPTY;  self.waterlevel = pco;}
};

//================
// monster_fade
//
// Called per frame, causes the monster to fade out of existance.
// Works only in engines that support transparent entities.
// (e.g., DarkPlaces, TomazQuake, Acquire's glquake 1.32+)
//================
void() monster_fade =
{
    if (self.alpha > 0.05)
        {self.alpha = self.alpha - 0.05;  self.nextthink = time + 0.1;}
    else
        remove (self);
};

//================
// monster_erase
//
// Erases a monster instantly, if the corpse is hidden from all players.
//================
/* DISABLED -- This isn't used in Tronyn's limit breaking mods.
// FIXME:  Restore for Drake!!!
void() monster_erase =
{
    local   entity  pc;

    if (deathmatch || coop)
    {   // "Gotta catch 'em all!" -- Pokemon
        // This isn't as bad as it looks because players are found early in
        // the edict list, and if it misses every player, body is gone then.
        pc = find (world, classname, "player");
        while (pc)
        {
            if (visible (pc))
                {self.nextthink = time + 0.2;  return;}
            pc = find (pc, classname, "player");
        }
    }
    else
    {   // Faster check for single player.
        pc = checkclient ();
        if (pc)
            if (visible (pc))
                {self.nextthink = time + 0.2;  return;}
    }

    // Remove the body while player isn't looking.
    monster_null ();
    remove (self);
};
*/

//================
// monster_remove
//
// Removes a dead monster from the game, freeing the edict it used.
// Useful for speeding up gameplay.
//================
void() monster_remove =
{
//
// SoE:  Indian summer requires a custom engine, and all that I know of,
// except Acquire's version of software WinQuake, support alpha/transparency.
    // Fade into nothing.  Requires engine that supports transparent
    // entities, such as DarkPlaces, or else it vanishes without fading.
    monster_null ();
    if (!self.alpha)
        self.alpha = 1;
    self.nextthink = time + 0.1;
    self.think = monster_fade;
//
//- - - - - - - - -
// DISABLED - Code for standard Quake.
//    self.think = monster_erase;
//    monster_erase ();
};

//================
// monster_end
//
// Should be called when a monster finishes its death scene.
//================
void() monster_end =
{
    Pets_Free (self);
    self.deadflag   = DEAD_DEAD;

    if (self.spawned)
    {   self.nextthink  = time + 4 + random()*4;
        self.think      = monster_remove;
    }
    else if (M_RespawnCheck ())
        M_RespawnNextthink (0);
    else
    {
        if (corpse_removal)
        {   self.nextthink  = time + 20 + random()*10;
            self.think      = monster_remove;
        }
        else
        {   self.nextthink  = -1;
            self.think      = SUB_Null;
        }

        if (deathmatch & DM_REVIVE)
            if (self.th_revive)
            {   // Resurrection override.
                self.nextthink  = time + 12;
                self.think      = monster_resurrect;
            }
    }
};

// Called when monster dies by touching trigger_void.
void() monster_void =
{
    KilledByVoid ();

    self.nextthink      = time + 0.1;
    self.think          = monster_end;
};

// This makes the monster non-solid and drop any loot it has.
void() monster_drop =
{
    self.solid = SOLID_NOT;
    DropBackpack();
    DropMoney();
    monster_item_drop ();   // Update 9/4/09:  Check for special item drop.
};

//================
// monster_dead
//
// For monsters that remove themselves at the end of their death scenes,
// call this function before their removal.  Such monsters include the
// tarbaby and the wrath.
//================
void(float drop) monster_dead =
{
    Pets_Free (self);
    if (drop)
        monster_drop ();
    self.deadflag   = DEAD_DEAD;
};


//============================================================================

void() monster_items =
{
// Armor - - - - - -
    if (self.items & ITx_ALL_ARMOR)
    {
        local   vector  armor;

        if (self.items & IT_ARMOR3)
            armor = ARMOR_STATS_RED;
        else if (self.items & IT_ARMOR2)
            armor = ARMOR_STATS_YELLOW;
        else //if (self.items & IT_ARMOR1)
            armor = ARMOR_STATS_GREEN;

        if (armor_y)    // Has armor if TRUE.
            {self.armortype = armor_x; self.armorvalue = armor_y;}
    }

// Weapons - - - - -
    local   float   am;

    if (self.drama1)        // DRAke Monster Arsenal, release 1.
        am = self.drama1;
    else
    {   // Convert weapon and item fields for arsenal.
        am = 0;
        self.items = self.items | self.weapon;  // In case of weapon hack.
        if (self.items & ITx_ALL_WEAPONS)
        {   // Convert weapon data for Drake.
            if (self.items &    1)  am = am | WAR_SHOTGUN;
            if (self.items &    2)  am = am | WAR_SUPER_SHOTGUN;
            if (self.items &    4)  am = am | WAR_NAILGUN;
            if (self.items &    8)  am = am | WAR_SUPER_NAILGUN;
            if (self.items &   16)  am = am | WAR_GRENADE_LAUNCHER;
            if (self.items &   32)  am = am | WAR_ROCKET_LAUNCHER;
            if (self.items &   64)  am = am | WAR_THUNDERBOLT;
            if (self.items & 4096)  am = am | WAR_AXE;
//                   Total = 4223
            self.items = self.items - (self.items & ITx_ALL_WEAPONS);
        }
    }
    am = am & legalized;    // Extra weapons must be legal.
    if (am)   // Override default weaponry if TRUE.
        {self.arsenal = am;  self.war = 0;}

// Ammo - - - - - -
    // If carrying a weapon, make sure it has enough ammo.
    if (self.arsenal)   // Most don't carry weapons, so check to save time.
    {
        self.arsenal = self.arsenal & WARx_ALL_WEAPONS;
        if (self.arsenal & WARx_USES_SHELLS)
        {
            if ((self.arsenal & WARx_USES_SHELLS) != WAR_SHOTGUN)
                am = 10;    // Has an upgrade.
            else
                am = 5;
            if (self.xfl & XFL_USE_AMMO)
                am = am * 3;    // Triple default if limited ammo.
            am = ShellGame (am);
            if (self.ammo_shells < am)
                self.ammo_shells = am;
        }
        if (self.arsenal & WARx_USES_NAILS)
        {
            if (self.arsenal & WAR_SUPER_NAILGUN)
                am = 20;
            else
                am = 10;
            if (self.xfl & XFL_USE_AMMO)
                am = am * 3;
            if (self.ammo_nails < am)
                self.ammo_nails = am;
        }
        if (self.arsenal & WARx_USES_ROCKETS)
        {
            am = 1;
            if (self.xfl & XFL_USE_AMMO)
                am = am * 3;
            if (self.arsenal & WAR_CRUISE_MISSILE)
                if (am < COST_MIRV)
                    am = COST_MIRV;     // Enough ammo for one shot.
            if (self.ammo_rockets < am)
                self.ammo_rockets = am;
        }
        if (self.arsenal & WARx_USES_CELLS)
        {
            am = 10;
            if (self.xfl & XFL_USE_AMMO)
                am = am * 3;
            if (self.arsenal & WAR_MJOLNIR)
                if (am < COST_MJOLNIR)
                    am = COST_MJOLNIR;  // Enough ammo for one shot.
            if (self.ammo_cells < am)
                self.ammo_cells = am;
        }
//        if (self.arsenal & WAR_BURIZA)
//        {
//            am = 1;
//            if (self.xfl & XFL_USE_AMMO)
//                am = am * 3;
//            if (self.ammo_super < am)
//                self.ammo_super = am;
//        }
    }
    if (!respawning)
        hell_bonus_ammo ();
    bind_ammo (self);
};

// PM:  Set monster's default weaponry.
// Note:  Custom ammo for custom weapons are not supported here.
void(float guns, float s, float n, float r, float c) monster_guns =
{
// Accept given weapons even if illegal to PCs. (e.g., enforcers' blasters).
// Forbidden weapon precaching must be done by the monster.
    self.arsenal = self.arsenal | guns;
    if (!self.ammo_shells)    self.ammo_shells = ShellGame (s);
    if (!self.ammo_nails)     self.ammo_nails = n;
    if (!self.ammo_rockets)   self.ammo_rockets = r;
    if (!self.ammo_cells)     self.ammo_cells = c;
};

//- - - - - - - - -
// Set contents of monster's purse.
void(float loop, float drop_chance, float gem_chance) monster_purse =
{
    self.purse = '0 0 0';
    self.purse_z = parms_pack (loop, drop_chance * 100, gem_chance * 100);
    while (loop > 0)
    {
        if (random() < drop_chance)
        {
            if (random() < gem_chance)
                self.purse_y = self.purse_y + 1;    // Gem
            else
                self.purse_x = self.purse_x + 1;    // Coin
        }
        loop = loop - 1;
    }
};

// This should be called only when a monster is revived.
void() monster_purse_reset =
{
    local   float   loop, drop_chance, gem_chance;

    loop        = parms_unpack (self.purse_z, 1);
    drop_chance = parms_unpack (self.purse_z, 2) / 100;
    gem_chance  = parms_unpack (self.purse_z, 3) / 100;

    monster_purse (loop, drop_chance, gem_chance);
};
//- - - - - - - - -

void() monster_item_cache =
{
    if (self.spawnclassname)
        Item_Cache (self.spawnfunction);
};


//============================================================================

void(string s, vector v1, vector v2, float hp, float gib) monster_form =
{
    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_STEP;
    setmodel (self, s);
    setsize (self, v1, v2);
    SUB_FullHealth (hp);
    self.gib_health = gib;

// Needed for resurrection code.  Also useful for sf64.
// Update 9/1/09:  Also by respawn code.
// Update 8/11/10:  Changed dest* to spawnmins and spawnmaxs.
    self.dest1  = v1;
    self.dest2  = v2;
    self.spawnskin  = self.skin;

    self.th_move    = walkmove;
    self.th_goal    = movetogoal;
};

void(string s, vector v1, vector v2, float hp) ghost_form =
{
    self.solid      = SOLID_TRIGGER;
    self.movetype   = MOVETYPE_NOCLIP;
    setmodel (self, s);
    setsize (self, v1, v2);
    SUB_FullHealth (hp);
    // Wraiths do not gib.

    ghosttouch = TRUE;  // A ghost appeared, so use ghost touch code.

    self.th_move    = noclip_move;
    self.th_goal    = noclip_goal;
};

/// Updates monster count.
//void() update_monster =
//{
//    WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
//    WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
//    WriteLong (MSG_BROADCAST, total_monsters);
//};

// Monsters that count toward kills should call this as they spawn.
void() monster_total =
{
    self.xfl = self.xfl | XFL_ADD_TO_KILL;  // So Quake knows who to count.
    total_monsters  = total_monsters + 1;
};

// Update monster count by one.
void() monster_1up =
{
    self.xfl = self.xfl | XFL_ADD_TO_KILL;  // So Quake knows who to count.
    total_monsters  = total_monsters + 1;
    WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
    WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
    WriteLong (MSG_BROADCAST, total_monsters);
};

// Sets up distances for following a master.
void() monster_zones =
{
// Note, multiplier should be 1.4142, but I want the ranges to be neatly
// divisible by 5.
    self.zones_x = rint(80 + self.maxs_x * 1.25);   // Flee.
    self.zones_y = self.zones_x + 20;       // Summon range.
    self.zones_z = self.zones_x + 50;       // Stop range.
};

void() monster_start_think =
{
    if (self.target)
    {
        self.goalentity = self.movetarget = find(world, targetname, self.target);
        self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
        if (!self.movetarget)
        {
            if (!self.spawned)
            {   // Debug message only if during worldspawn.
                print_self ("", "Monster can't find target at ");
            }
        }
// Zerstorer -- If targeted to another monster, attack it when triggered.
        if (self.movetarget.flags & FL_MONSTER)
            {self.zerc = -1; self.oldenemy = self.movetarget;}
//- - - - - - -
// this used to be an objerror
        if (self.movetarget.classname == "path_corner")
            self.think = self.th_walk;
        else if (self.flags & FL_SWIM)
            self.think = self.th_walk;
        else
            self.think = self.th_stand;
    }
    else if (self.flags & FL_SWIM)
        self.think = self.th_walk;
    else
        self.think = self.th_stand;

// PM:  If mad at someone, start running.
    if (self.enemy)
    {
        if (self.enemy == self)
            self.enemy = world;
        else if (respawning)
            self.think = HuntTarget;    // Silent, don't alert other guys.
        else
            self.think = FoundTarget;
    }
};

//================
// monster_start_go
//
// This completes a spawned monster's stats, then activates it.
// (Or hides it if sf64 compliant.)
//================
void() monster_start_go =
{
// sf64 walkmonsters may be given the fly flag on to stop them from falling
// before they think.  If such is the case, remove flight now.
    if (self.xsf & XSF_NO_FALL)
        self.flags = self.flags - (self.flags & FL_FLY);

    monster_items ();   // Check for armor, weapons, and ammo.
    monster_zones ();   // Set important distances for summoning and minions.
//    more_air (self);    // Begin with some air so self doesn't drown now.

//- - - - - - - - -
    if (self.family & FAMx_NONLIVING == 0)
        self.soul = "yes";  // FIXME:  Remove after testing.
//- - - - - - - - -
// PM:  Drake feature in conflict with SoE map design.
// At least one of the SoE maps has water everywhere, and the monsters will
// happily walk under the surface.  Because I don't have the time now to
// make them smart and avoid water, just ignore drowning check so they don't
// die, just like standard Quake.
//
// Note:  They still take damage if they tread slime or lava, unless immune.
//
    if (soul_evil || (world.tronyn & DJG_NO_DROWN))
        self.xfl = self.xfl | XFL_NO_AIR;
//- - - - - - - - -
    self.takedamage = DAMAGE_AIM;
    self.flags      = self.flags | FL_MONSTER;
    self.ideal_yaw  = self.angles * '0 1 0';
    if (!self.yaw_speed)
        self.yaw_speed  = 20;
    self.view_ofs_x = self.view_ofs_y = 0;
    if (!self.view_ofs_z)
        self.view_ofs_z = 25;
    self.use        = monster_use;
    if (!self.th_void)
        self.th_void    = monster_void;     // For trigger_void kills.
    if (!self.bloodtype)
        self.bloodtype  = BLOOD_RED;
    self.mindex2    = self.modelindex;      // Remember original modelindex.
    self.zerc       = self.count;   // Zer -- monster vs. monster targeting.
    // Set alignment.
    Align_Add (self, self.spawnflags & SPAWN_WHITE);
    // Set AI flags common to all.
    if (cranked)
    {   // Alert gives faster reaction and no infighting.
        // Angry cancels the no infighting part.
        // Used by monsters who are normally not alert.
        if (!(self.ryuflags & RYU_ALERT))
            self.ryuflags = self.ryuflags | RYU_ALERT | RYU_ANGRY;
    }
    if (self.style & STYLE_CALM)
        self.ryuflags = self.ryuflags | RYU_CALM;
    // Set properties based on monster types.
    if (self.family)
    {
        if (self.family & FAMx_NONLIVING)
            self.xfl = self.xfl | XFL_NO_AIR | XFL_IMMUNITY;
        if (self.family & (FAM_DRAGON | FAM_SPIDER))
            self.xfl = self.xfl | XFL_IMMUNITY;
// Maybe for Drake, but not for SoE.
//        if (self.family & FAM_KNIGHT)
//            self.xfl = self.xfl | XFL_ARMORED;      // Immune to knightspikes.
    }
//- - - - - - - - -

//- - - - - - - - -
// Imp statues -- Just check for path_corners then get out.
    if (self.xsf & XSF_STATUE)
    {
        self.xsf = self.xsf - XSF_STATUE;
        self.takedamage = DAMAGE_NO;
        if (self.target)
        {
            self.goalentity = self.movetarget = find(world, targetname, self.target);
            self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
        }
        return;
    }
//- - - - - - - - -
// Check if the monster was placed in a viable spot.
    if (self.movetype != MOVETYPE_NOCLIP)   // Doesn't work for wraiths.
    {
        local   float   fail, walk;

        fail = FALSE;
        walk = !(self.flags & (FL_FLY | FL_SWIM));
        if ( walk && !(self.spawnflags & SPAWNx_DELAY) )
        {   // Walkmove works only for land-bound monsters.
            self.origin_z = self.origin_z + 1;    // raise off floor a bit
            droptofloor ();
            if (!walkmove(0,0))
                if (!self.spawned && !(self.xsf & XSF_FUNC_SPAWN))
                    fail = TRUE;
        }
        else
        {   // Check three points for flyers, swimmers, and sf64 shenanigans.
            if (walk)   // Raise walkers slightly to prevent false warnings.
                setorigin (self, self.origin + '0 0 1');
            if (!self.spawned && !(self.xsf & XSF_FUNC_SPAWN))
            {
                if (pointcontents(self.origin) == CONTENT_SOLID)
                    fail = TRUE;
                else if (pointcontents(self.absmin) == CONTENT_SOLID)
                    fail = TRUE;
                else if (pointcontents(self.absmax) == CONTENT_SOLID)
                    fail = TRUE;
            }
        }

        if (fail)
            print_self (self.classname, " in wall at: ");   // "You failed!"
    }
// Note:  Only clients use oldorigin in normal engines.
// Don't know if some custom engines use it for monsters too.
    self.oldorigin = self.origin;   // Remember location for respawning.
    self.mangle = self.angles;
// If activated by func_spawn, update counter if necessary then create a
// telefrag field to simulate teleportation effects.
// SoE:  Check for dmsp spawns first, then func_spawn if not a dmsp spawn.
    if (self.xsf & XSF_DMSP)
    {   // Monster already counted earlier.
        spawn_tdeath (self.origin, self);
    }
    else if (self.xsf & XSF_FUNC_SPAWN)
    {   // Activated by func_spawn.
        if (self.spawned)
        {   // func_spawn with spawnmulti = TRUE.  (SoE:  dmsp too!)
            if (self.alignment != GOOD)
                monster_1up ();
        }
        spawn_tdeath (self.origin, self);
    }
// Abort if monster died upon level placement
    if (self.health <= 0)
    {
        if (!self.spawned && !(self.xsf & XSF_FUNC_SPAWN))
        {   // Debug message only if during worldspawn.
            print_self ("", "Monster died at: ");
        }
        return;
    }

// Set thinking.
    monster_start_think ();
//- - - - - - - - -

// Spawnflag 64 code:  The stuff that makes teleporting obsolete.
    if (self.spawnflags & SPAWNx_DELAY)
    {
    // Remember model and size. - - - - - -
        self.mdl    = self.model;
        self.dest1  = self.mins;
        self.dest2  = self.maxs;
    //- - - - - - - - - - - - - - - - - - -
        self.xsf        = self.movetype;    // Safe to clear old flags.
        // Update 4/11/09:  Use Quoth spawnflags standards.
        if (self.spawnflags & SPAWN_SILENT)
            self.xsf        = self.xsf | XSF_SPAWNSILENT;
        if (self.spawnflags & SPAWN_AWARE)
            self.xsf        = self.xsf | XSF_SPAWNAWARE;
        if (!(world.tronyn & DJG_GROUND64))
            self.movetype   = MOVETYPE_NONE;    // Don't let the monster move.
        self.modelindex = 0;
        self.solid      = SOLID_NOT;
        self.takedamage = DAMAGE_NO;
        self.nextthink  = -1;
        ai_synch ();    // For multi-part monsters.
    }
    else
        self.think ();
};

void() monster_start =
{
    if (self.spawned)
    {   // Monster was spawned dynamically during play.
        if ((self.spawnflags & SPAWN_WHITE) == 0)   // Good guys don't count!
        {
//            if ((self.xsf & XSF_DMSP) && PRECOUNT)
//            {   // No need to add to total, just count toward it.
//                self.xfl = self.xfl | XFL_ADD_TO_KILL;
//            }
//            else
                monster_1up ();
        }
        monster_start_go ();    // It's safe for immediate activation.
    }
    else
    {   // Spawned during a level load.
//- - - - - - - - -
// FIXME:  Statue/zombie code for ...
        if (self.drama1)
            monster_items ();
    // Given a special item to carry?  Precache the item too.
    // FIXME:  Will this cause model mismatch bug on loaded game if entity
    // is removed mid-level?
        if (self.spawnfunction)
            Item_Cache (self.spawnfunction);
    // Add to the monster counter.
        if ((self.spawnflags & SPAWN_WHITE) == 0)   // Good guys don't count!
            monster_total ();

    // Spread think times so they don't all happen at same time
    // PM:  We can't think now because the monster's target entities
    // may not exist yet.
        self.nextthink  = 0.1 + random()*0.5;
        self.think      = monster_start_go;

// Arcanum2 hack. -
        if (self.spawnflags & 128)
            if (world.model == "maps/arcanum2.bsp")
                self.spawnflags = (self.spawnflags - 128) | 32;
//- - - - - - - - -
        if (self.spawnflags & SPAWNx_DELAY)
        {   // Make a sf64 monster non-solid now so it can't touch triggers.
            self.solid      = SOLID_NOT;
            if (!(self.flags & FL_FLY))
            {   // Monsters who don't fly will fall while waiting to think.
                // Add the fly flag to prevent falling before think time.
                self.flags      = self.flags | FL_FLY;
                self.xsf        = self.xsf | XSF_NO_FALL;
            }
        }
    }
};

//==========
// Classic '*monster_start' functions.
//==========
//void() walkmonster_start = {monster_start();};

void() flymonster_start =
{   if (!self.yaw_speed)
        self.yaw_speed = 10;
    self.flags = self.flags | FL_FLY;
    monster_start();
};

void() swimmonster_start =
{   if (!self.yaw_speed)
        self.yaw_speed = 10;
    if (!self.view_ofs_z)
        self.view_ofs = '0 0 10';
    self.xfl = self.xfl | XFL_NO_AIR;       // Water-breather.
    self.flags = self.flags | FL_SWIM;
    self.th_move = swim_move;
    self.th_goal = swim_goal;
    monster_start();
};


//==========================================================================
//  Statue Stuff

void(void() usest) statue_start =
{
    self.velocity   = '0 0 0';
    self.origin_z   = self.origin_z + 2;
    if (!droptofloor ())
    {
        print_self (self.classname, " fell out of level at ");
        remove (self);
        return;
    }
// For now, the statue can only wake up if targeted.  Hexen2 has other ways
// for waking up statues, but I don't have the time now to explore them.
    if (self.targetname)
    {
        self.use        = usest;
        if ((self.spawnflags & SPAWN_WHITE) == 0)
        {   // Increment monster counter.
            if (self.spawned)
                monster_1up ();
            else
                monster_total ();
        }
    }
};


//==========================================================================
//  Clones

void() clone_die =
{
// Copied from 'eyes.qc'...
    self.takedamage = DAMAGE_NO;    // PM:  Needed in Drake.
    self.modelindex = 0;
    self.solid      = SOLID_NOT;
    self.movetype   = MOVETYPE_NONE;
// Use ten seconds in case of clone spawned thunderstorm.
    self.nextthink  = time + 5;     // Delay removal so obituaries work.
    self.think      = SUB_Remove;
    Burn_Null (self);

// Poof!
    spawn_tfog (self.origin);
};

void() clone_spawn =
{
    local   entity  kage;       // Watching too much Naruto, eh?

    kage = spawn();
    SUB_CopyEntity (self, kage);
    setorigin (kage, self.origin);
    EntryPoint_Spawn (kage, self, self.origin, EntryPoint_Random);

    kage.targetname =
    kage.killtarget = kage.target = kage.target2 = world.null_string;
    kage.spawned    = TRUE;
    kage.th_die     = clone_die;
    kage.th_void    = clone_die;
    kage.th_gib     = world.null_func;
    kage.master     = self;
    // Clones automatically vanish when their master dies, so don't
    // count them.  One for all and all for one.
    kage.xfl        = kage.xfl - (kage.xfl & XFL_ADD_TO_KILL);
};


//===========================/  END OF FILE  /===========================//
