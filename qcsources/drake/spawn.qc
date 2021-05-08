// spawn.qc.

// PM:  Prototypes and globals moved elsewhere.  Take a guess where!
// Update 1/23/10: 'SUB_CopyEntity' moved to its own file.
//==========================================================================


//=====================================================================
//
// Spawning Functions (Hipnotic)
//
//=====================================================================

//================
//
// spawn_use
//
//================
void() spawn_use =
{
    local   entity  spawnentity;
    local   float   clone, fx;

    fx = !self.spawnsilent;
    if (horn_charmer)
        clone = TRUE;
    else
        clone = self.spawnmulti;
    if (clone)
    {
    // spawn the new entity
        spawnentity = spawn();
    // copy the master mold
        SUB_CopyEntity (self.spawnmaster, spawnentity);
    // PM:  Check if the spawn entity is a monster.
    // Since the spawnentity does not have the fl_monster flag yet,
    // we need another way to find out if it is a monster.  Since all
    // proper monsters use 'monster_start_go' when spawning, check for that.
    // Note:  because many monsters may be produced, treat it as spawned
    // so that it uses quicker removal among other things.
        spawnentity.spawned = TRUE;
        if (spawnentity.spawnthink == monster_start_go)  //spawnentity.flags & FL_MONSTER)
        {
// DISABLED -- sf64 check obsolete?
//            spawnentity.spawnflags = self.spawnflags - (self.spawnflags & SPAWNx_DELAY);
            if (horn_charmer)
            {   // Horn conjures up the good guys.
                spawnentity.spawnflags = spawnentity.spawnflags | SPAWN_WHITE;
                // PM:  Removed horn_active's EF_DIMLIGHT.
            }
// SoE:  Hellgate hack.
            else if (world.model == "maps/nsoe2.bsp")
            {   // Remove targetname so imps don't vanish on boss kill.
                spawnentity.targetname = world.null_string;
                spawnentity.enemy = activator;
                MakeExplosion (self.origin);
            }
//- - - - - - - - -
        }
    }
    else
    {
        if (!self.spawnmaster)
            return;     // Already used the spawner.
    // PM:  Used up the spawn.  Tough luck if linked by a horn.
        self.targetname = world.null_string;
        self.use        = SUB_Null;
    // transform spawner into the real deal (monster, item, whatever).
    // Monster already counted so no need to add one to the counter.
        spawnentity = self.spawnmaster;
        spawnentity.spawned = FALSE;
    // PM:  We can't just remove (self) here, because SUB_UseTargets begins
    // its search for the next target to use at this current entity self,
    // and removing self now (is unsafe because it) may break the chain.
        self.spawnmaster = world;       // Clear the spawner.
        self.nextthink  = time + 0.1;
        self.think      = SUB_Remove;   // Used up and no longer needed.
    }
// restore the model
    spawnentity.model = spawnentity.spawnmodel;
//restore solid flag
    spawnentity.solid = spawnentity.spawnsolidtype;
//restore thinking function
    spawnentity.think = spawnentity.spawnthink;
    spawnentity.nextthink = 0.01;    // PM:  Think ASAP.
//restore appearance
    setmodel (spawnentity, spawnentity.model);
    setorigin (spawnentity, spawnentity.origin);
    spawnentity.mins = spawnentity.spawnmins;
    spawnentity.maxs = spawnentity.spawnmaxs;
    setsize (spawnentity, spawnentity.mins, spawnentity.maxs);
// spawn the teleport effect
    if (fx)
        spawn_tfog (spawnentity.origin);
// any other things that need doing.
    if (horn_charmer)
    {   // Replaced Hip's charmed with my monster summon code.
        spawnentity.master = horn_charmer;
        spawnentity.spawnflags = spawnentity.spawnflags | SPAWN_WHITE;
    }
    // PM:  Do this so the monster code knows what to do when the time comes.
    spawnentity.xsf = spawnentity.xsf | XSF_FUNC_SPAWN;
// call spawnentity think function (PM:  Not now.)
};

//================
//
// func_spawn
//
//================
// --> QUAKED func_spawn (0 .5 .8) (-32 -32 -24) (32 32 64) big/ambush megahealth
// This will spawn a thing upon being used. The thing that
// is spawned depends upon the value of "spawnfunction".
// "spawnclassname" should contain the same value as "spawnfunction".
// If "spawnfunction" is unspecified a random monster is chosen.
// The angles, target and all flags are passed on
// Think of it like setting up a normal entity.
// "spawnsilent" set this to 1 if you want a silent spawn.
// "spawnmulti" set this to 1 if you want this spawn to be reoccuring.
//================
void() func_spawn =
{
    local   entity  swap;
    local   entity  monster;
    local   float   tempdeathmatch;
    local   float   temptotal_monsters;
    local   float   fix;

    if (!self.spawnfunction)
    {   // Randomly choose a monster.
        // PM:  I bet they select mtype now to thwart save scumming.
        tempdeathmatch = random();
        if (tempdeathmatch < 0.5)
        {   self.spawnfunction = monster_dog;
            self.spawnclassname = "monster_dog";
        }
        else if (tempdeathmatch < 0.8)
        {   self.spawnfunction = monster_ogre;
            self.spawnclassname = "monster_ogre";
        }
        else if (tempdeathmatch < 0.92)
        {   self.spawnfunction = monster_demon1;
            self.spawnclassname = "monster_demon1";
        }
        else if (tempdeathmatch < 0.97)
        {   self.spawnfunction = monster_zombie;
            self.spawnclassname = "monster_zombie";
        }
        else
        {   self.spawnfunction = monster_shambler;
            self.spawnclassname = "monster_shambler";
        }
    }

// 8/14/2010:  If a dmsp_boss, enable spawnmulti to avoid bumping the counter.
    if (dmsp)
    {
        if (self.targetname == "DMSP_boss")
            self.targetname = "dmsp_boss";  // Convert to work with newer code.
        if (self.targetname == "dmsp_boss")
        {   boss_count = boss_count + 1;
            self.spawnmulti = 1;    // For old SoE arena maps.
        }
    }

// save off deathmatch and zero it out  (PM: So that monsters are made.)
// SoE:  noenemies controls monster spawning.
    swap = self;
    tempdeathmatch = noenemies;
    noenemies = 0;

//- - - - - - - - -
// spawn the new entity
    self = spawn();
// copy over everything
    SUB_CopyEntity (swap, self);
    // Update 4/13/09:  Clear spawn* so monster may use them to drop items.
    self.spawnclassname = world.null_string;
    self.spawnfunction  = world.spawnfunction;

// save off monster count so it doesn't get f'ed up
    temptotal_monsters = total_monsters;
    if (swap.spawnclassname == world.null_string)
        objerror ("No spawnclassname defined");
    self.classname = swap.spawnclassname;   // Was 'self.spawnclassname;'
    self.spawned = FALSE;   // PM:  So precaching isn't skipped.
// call the named spawn function
    swap.spawnfunction ();  // Was 'self.spawnfunction ();'
    noenemies = tempdeathmatch;     // PM:  We can do this now.
// If spawner is multi-use, undo any counter change.
// Counter will update as the monsters spawn.
    if (swap.spawnmulti)    // make sure monster count is correct
    {
        total_monsters      = temptotal_monsters;
        // The xfl flag will be restored when an evil copy spawns later.
        // This is here so good clones do not count toward kills.
        self.xfl = self.xfl - (self.xfl & XFL_ADD_TO_KILL);
    }
    else
    {   // See if we can convert func_spawn into a Zer style sf64 entity.
        if ((self.think == monster_start_go) || (self.think == PlaceItem))
        {   // Convert func_spawn to spawn64 entity.
            self.solid = SOLID_NOT;     // Don't trigger stuff.
            if (self.think == monster_start_go)
            {
                if (tempdeathmatch)
                {   // Remove monster as per deathmatch, except dmsp boss.
                    fix = 1;
                    if (dmsp)
                        if (self.targetname == "DMSP_boss")
                            fix = 0;
                    if (fix)
                    {
                        total_monsters = temptotal_monsters;
                        Remove_Ent (self);
                        self = swap;
                        Remove_Ent (self);
                        return;
                    }
                }

                // self.solid change moved up.
                if (!(self.flags & FL_FLY))
                {   // Monsters who don't fly will fall while waiting to think.
                    // Add the fly flag to prevent falling before think time.
                    self.flags      = self.flags | FL_FLY;
                    self.xsf        = self.xsf | XSF_NO_FALL;
                }
                // Update:  Mark as target for horn.
                self.xf2        = self.xf2 | XF2_HORN;
            }
            if (self.spawnsilent)
                self.spawnflags = self.spawnflags | SPAWN_SILENT;
            else
                self.spawnflags = self.spawnflags | SPAWN_NORMAL;
            // Remove func_spawn to save entities.
            self = swap;
            Remove_Ent (self);
            return;
        }
    }
    self.spawnmodel     = self.model;
    self.spawnmins      = self.mins;
    self.spawnmaxs      = self.maxs;
    setmodel (self, "");
    self.model = "";
    setsize (self, self.spawnmins, self.spawnmaxs);
//save off solid flag
    self.spawnsolidtype = self.solid;
    self.solid          = SOLID_NOT;
//save off think func and get rid of his thinking
    self.spawnthink     = self.think;
    self.think          = SUB_Null;     // Do nothing until summoned.
    self.nextthink      = -1;
    monster = self;
//- - - - - - - - -
    self = swap;

    self.solid = SOLID_NOT;
    self.movetype = MOVETYPE_NONE;
    self.modelindex = 0;
    self.model = "";
    setmodel (self, self.model);  // set size and link into world
    self.use = spawn_use;
    self.spawnmaster = monster;
};

//================
//
// func_spawn_small
//
//================
// --> QUAKED func_spawn_small (0 .5 .8) (-16 -16 -24) (16 16 40) big/ambush megahealth
// This will spawn a thing upon being used. The thing that
// is spawned depends upon the value of "spawnfunction".
// "spawnclassname" should contain the same value as "spawnfunction".
// If "spawnfunction" is unspecified a random monster is chosen.
// The angles, target and all flags are passed on
// Think of it like setting up a normal entity.
// "spawnsilent" set this to 1 if you want a silent spawn.
// "spawnmulti" set this to 1 if you want this spawn to be reoccuring.
//================
void() func_spawn_small = {self.classname = "func_spawn"; func_spawn();};


//==========================================================================
//
// Horn of Conjuring
//
//==========================================================================
void() horn_touch =
{
    if (other.classname != "player")
        return;

    sprint (other, "You got the Horn of Conjuring\n");
    sound (other, CHAN_VOICE, self.noise, 1, ATTN_NONE);
    stuffcmd (other, "bf\n");

    horn_charmer = other;   //horn_active = 1;

    activator = other;
    SUB_UseTargets();                // fire all targets / killtargets

    horn_charmer = world;   //horn_active = 0;

    ClearItem (60);
};

/*QUAKED item_hornofconjuring (0 .5 .8) (-16 -16 0) (16 16 32)
Horn of Conjuring.
You must make func_spawn entities connected to this entity
to spawn the charmed creature.
*/
void() item_hornofconjuring =
{
    horn_charmer = world;   // Just to be sure.

    self.touch = horn_touch;

    precache_model ("progs/horn.mdl");
    precache_sound ("hipitems/horn.wav");
    setmodel (self, "progs/horn.mdl");
    self.noise = "hipitems/horn.wav";
    setsize (self, '-16 -16 0', '16 16 32');
    StartItem ();
};


//==========================================================================
