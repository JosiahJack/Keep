//==========================================================================
//  summon.qc -- by Patrick Martin
//--------------------------------------------------------------------------
//  This file contains code that creates monsters out of thin air.
//
//  Because this file calls many monster entity functions, place this file
//  at the end, after all other monster files, so we don't need to define
//  pages worth of function prototypes.
//
//  FIXME:  Summon and teleportation code needs an overhaul.
//  FIXME:  This is for debugging only.
//==========================================================================


//==========================================================================

// FIXME:  ???
// As 'func_spawn' but designed for summoning and dmsp.
void() func_summon =
{
    self.spawnsilent = 0;   // We always want some effects for summoning.
    self.spawnmulti = 1;    // We want to summon as many as needed.
    self.classname = "func_spawn";
    func_spawn();
};

// FIXME:  Move this to func.qc or the file that has summon stuff.
// Also, rename to something less confusing.
void(vector spot, float r, string s, void() func) info_summon =
{
    local   entity  e;

    e = spawn();
    setorigin (e, spot);
    e.volume = r;
    e.spawnclassname = s;
    e.spawnfunction = func;
    e.targetname = "cubed";
    SUB_Think (e, func_summon);
};

// Finds the first multispawn func_spawn with a targetname matching 'text'.
// NOTE:  Use for func_spawns that spawn monsters only.
// Used by dmsp code.
entity(string text) summon_first =
{
    local   entity  targ;

    targ = find (world, targetname, text);
    while (targ)
    {
        if (targ.classname == "func_spawn")
            if (targ.spawnfunction)
                if (targ.spawnmaster)
                    return targ;
        targ = find (targ, targetname, text);
    }
    return world;
};

// Finds the next multispawn func_spawn with a matching targetname.
// NOTE:  Use for func_spawns that spawn monsters only.
// Used by dmsp code.
entity(entity who) summon_next =
{
    local   entity  targ;

    targ = find (who, targetname, who.targetname);
    while (targ != who)
    {
        if (targ.classname == "func_spawn")
            if (targ.spawnfunction)
                if (targ.spawnmaster)
                    return targ;
        targ = find (targ, targetname, who.targetname);
        if (!targ)
            targ = find (world, targetname, who.targetname);
    }
    return world;
};

// Return a 'func_spawn' to copy data from.  Used by summon_func and friends.
// Also used by doomcube code.
entity(string text) summon_data =
{
    local   entity  first, prev, targ;
    local   float   loop, r;

    first = prev = world;
    loop = 0;
    targ = find (world, targetname, text);
    while (targ)
    {
        if (targ.classname == "func_spawn")
            if (targ.spawnfunction)
                if (targ.spawnmaster)
                {
                    targ.chain2 = world;
                    if (prev)
                        prev.chain2 = targ;
                    else
                        first = targ;
                    prev = targ;

                    if (targ.volume < 1)
                        targ.volume = 1;
                    loop = loop + targ.volume;
                }
        targ = find (targ, targetname, self.summontarget);
    }

    if (!loop)
        return world;

    targ = world;
    do {r = random();} while (r == 1);      // f(r) == (0 <= r < 1).
    loop = r * loop;        //- targ.volume;
    do
    {
        if (targ)
            targ = targ.chain2;
        else
            targ = first;
        if (!targ)
            return world;
        loop = loop - targ.volume;
    } while (loop > 0);
    return targ;
};

//----------------------

// Part 2 of summon_func and other similar functions.
float(entity swap, entity parent, vector spot, float los, float() google)
    summon_func2 =
{
    local   entity  beacon;
    local   float   boss;

    if (google == EntryPoint_BossCube)
        boss = TRUE;
    else
        boss = FALSE;
    if (!los || boss)
        beacon = world;
    else
    {
        beacon = parent;    // New monster must be visible to parent.
        if (los == 2)
            if (parent.enemy)
                beacon = parent.enemy;
    }

    // Was in spawn test func
    self.master     = parent;   // Needed as beacon to test spawn points.
    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_NOT;
//dprint(vtos(self.spawnmins));dprint(vtos(self.spawnmaxs));dprint("\n");
    setsize (self, self.spawnmins, self.spawnmaxs);

    if (!EntryPoint_Spawn (self, beacon, spot, google))
    {   // Failed -- No spawn point available this time.
        remove (self);
        self = swap;
        return FALSE;
    }
// Found a viable spawn point, so finish spawning the monster.
    self.spawnflags = self.spawnflags & 15;
    if (parent.alignment == GOOD)
        self.spawnflags = self.spawnflags | SPAWN_WHITE;
    self.spawned    = TRUE;
    self.classname  = self.spawnclassname;
// Face master, and fix the angles so monster stands upright.
    self.angles_x   = 0;
    self.angles_y   = vectoyaw(parent.origin - self.origin);
    self.angles_z   = 0;
    if (boss)
    {   // Assume cube spawner.
        local   entity  pl;

        pl = checkclient ();
        self.angles_y   = swap.ideal_yaw;
        if (pl)
        if (visible (pl))
        if (!pl.invisible_finished)
        if (!(pl.flags & FL_NOTARGET))
        {
            self.angles_y   = vectoyaw(pl.origin - self.origin);
            self.enemy      = pl;
        }
    }
    else
    {
        if (parent.enemy)   // Face enemy instead if applicable.
            if (visible (parent.enemy))
                self.angles_y   = vectoyaw(parent.enemy.origin - self.origin);
    }
    self.fixangle   = TRUE;
// The monster shall appear now.
    self.spawnfunction ();
// Create teleport effects after monstats because of possible
// ceiling clingers like spiders.
//    if (poof && (poof != SUB_Null))
//        poof ();
    if ((self.classname == "monster_wrath") && (parent.classname == "monster_dark_lord"))
    {   // FIXME:  Use more generic check.
        sound (self, CHAN_VOICE, "skullwiz/gate.wav", 1, ATTN_NORM);
        self.enemy      = parent.enemy;
        wrath_grow1 ();     // In modified 'wrath.qc'.
    }
    else
        summon_tfog (self);
    if (boss)
    {   // Again, assume cube spawner.
        self.xsf = self.xsf | XSF_CUBE_SPAWN;   // Telefrag any non-boss.
        spawn_tdeath (self.origin, self);
        self.xsf = self.xsf - (self.xsf & XSF_CUBE_SPAWN);
    }

//dprint(parent.classname); dprint("... ");
//dprint(ftos(parent.pets)); dprint("... ");
// Pet counter, used to enforce limits... used by nightshade.
    if (parent.health > 0)
    {
//dprint("slave\n");
        self.xfl = self.xfl | XFL_PET;
        parent.pets = parent.pets + 1;
    }
    else
    {
//dprint("free\n");
        self.master = self.enemy = world;
    }

// Successfully spawned a new creature.
    newmis = self;
    self = swap;
    return TRUE;
};

// Note:  We pass a func_spawn 'mold' here instead of calling it here
// in case we want a monster to summon the same mold during an animation.
// For example, the gauroch's howling scene.
float(entity parent, entity mold, vector spot, float los, float() google)
    summon_func =
{
    local   entity  swap, targ;

// Make sure the mold is valid.
    targ = mold.spawnmaster;
    if (!targ)
        return FALSE;   // This isn't a proper func_spawn with spawnmulti.

// Got one, proceed.
    swap = self;
    self = spawn();

    SUB_CopyEntity (mold, self);

    self.flags = targ.flags & (FL_SWIM | FL_FLY);
    self.spawnmins = targ.dest1;   //spawnmins;
    self.spawnmaxs = targ.dest2;   //spawnmaxs;

    return  summon_func2 (swap, parent, spot, los, google);
};

// Used by monsters to summon clones of themselves.  Used by gauroch.
float(vector spot, float los, float() google)  replicate =
{
    local   entity  parent;

    if ((self.health <= 0) || !(self.flags & FL_MONSTER))
        return FALSE;       // Must be a live monster.
    if (!self.spawnfunction)
        if (!self.th_spawn)
            return FALSE;

// Got one, proceed.
    parent = self;
    self = spawn();

    SUB_CopyEntity (parent, self);

// FIXME:  Add another flag to prevent children from replicating.
    self.health = ceil(parent.max_health / 2);
    self.target = self.target2 = self.targetname = world.null_string;
    self.enemy = world;
    self.frame = 0;
    self.model = "";
    self.flags = parent.flags & (FL_SWIM | FL_FLY);
    self.spawnflags = self.spawnflags & 31;
    self.spawnclassname = parent.classname;
    self.spawnfunction = parent.th_spawn;
    self.spawnmins = parent.dest1;   //spawnmins;
    self.spawnmaxs = parent.dest2;   //spawnmaxs;
    self.nextthink = 0;
    self.think = SUB_Null;

    return  summon_func2 (parent, parent, spot, los, google);
};


//==========================================================================
//  Precaches

// Precache all files used by monsters.
void() cache_all_monsters =
{
// Player
    ranger_cache();
// Shareware
    ogre_cache(); demon1_cache(); sham_cache(); knight_cache();
    army_cache(); wiz_cache(); dog_cache(); zombie_cache();
// Registered
    tbaby_cache(); hknight_cache(); fish_cache(); shal_cache();
    enf_cache();
// Armagon
    scourge_cache(); gremlin_cache();
    armagon_cache();
// DoE
    dragon_doe_cache();
    eel_cache();
    morph_cache();
//    sword_cache();
    wrath_cache(); super_wrath_cache();
// Hexen2
    archer_grunt_cache(); archer_lord_cache();
    imp_cache(); imp_lord_cache();
    spider_cache();
    necro_boss_cache();
    skullwiz_grunt_cache(); skullwiz_lord_cache(); skullwiz_boss_cache();
    yakman_cache();
// Quoth2
//    drole_cache();
//    gug_cache();
// Doom
    cyber_cache();
//    vile_cache ();
// Custom (One monster per line so that commenting out/disabling is easier.)
    axeman_cache();
    bane_cache();       // BBEG
    baron_cache(); baron_boss_cache();
//    commando_cache();
    dragon_cache(); wyrm_cache();
//    drone_cache();
//    eyes_cache();
    goblin_cache(); bandit_cache();
    gunner_cache();
    hkboss_cache();
    hklord_cache();
    dark_lord_cache();
    kolem_cache ();
    oldone_cache(); oldone_cache2();
    megaenforcer_cache ();
    nemes_cache ();
    ranger_cache();
    rebel_cache();
    shadow_cache();
    shamvile_cache();
//    snake_cache();
//    turret_cache();  turret_gun_cache();  turret_rocket_cache();
//    uenf_cache();       // FIXME:  ???
    vom_cache();
//    willy_cache();
    wraith_cache(); wraith_lord_cache();    // Model is modified wrath.
};


//==========================================================================
//  Monster Creation

// FIXME:  Several monster files have variants of CreateMonster.
//  Go forth into those files someday and reduce redundancy.

//------------------------------------------------------------------------//
//  This attempts to dynamicly spawn a new monster into the level.
//  TRUE = success, FALSE = failure.
//
//  parent   : Who controls the new monster.
//  spot     : New monster's spawn point.
//  mtype    : .classname
//  vflags   : x=.spawnflags, y=.flags, z=.skin or .worldtype
//  hullmin  : .mins
//  hullmax  : .maxs
//  monstats : New monster's spawn function.
//  google   : Point search function used to find a test point.
//
//  NOTE:  Names in both 'mtype' and 'monstats' must match!
//------------------------------------------------------------------------//
float(entity parent, vector spot, string mtype, vector vflags,
    vector hullmin, vector hullmax, void() monstats, float() google)
    CreateMonster =
{
//    local   entity  parent;
    local   entity  swap;
    local   float   los;

    if (google == EntryPoint_One)
        los = 0;
    else if (self.classname == "monster_baron")
        los = 2;
    else
        los = 1;

    swap = self;

    self = spawn();
//    self.classname  = mtype;
    self.spawnflags = vflags_x;
    self.flags      = vflags_y;
    if (mtype == "monster_dragon")
        self.worldtype  = vflags_z;     // HACK:  Dragon size
    else if (mtype == "monster_baron")
        self.level      = vflags_z;     // HACK:  Boss type.
    else    // Several SoE monsters have alternate skins.
        self.skin       = vflags_z;
    self.spawnmins  = hullmin;
    self.spawnmaxs  = hullmax;
    self.spawnclassname = mtype;
    self.spawnfunction  = monstats;

    return  summon_func2 (swap, parent, spot, los, google);
};

//------------------------------------------------------------------------//
// FIXME:  Isolate in a debug file only.
//  This calls 'CreateMonster' via ID# (impulse).
//
//  It is simpler to type A(e,v,f) than B(e,v,s,v,v,v,void) elsewhere.
//------------------------------------------------------------------------//
float(entity parent, vector spot, float mtype, float() google) SpawnMonster =
{
    local   vector  land, air, sea;     // x=spawnflags, y=flags, z=SPECIAL.

    land = air = sea = '0 0 0';
    air_y = air_y | FL_FLY;
    sea_y = sea_y | FL_SWIM;

// A
    if (mtype == ID_ARCHER_BANDIT)
        return CreateMonster (parent, spot, "monster_bandit", land, '-16 -16 -24', '16 16 40', monster_bandit, google);
    if (mtype == ID_ARCHER_REBEL)
        return CreateMonster (parent, spot, "monster_rebel", land, '-16 -16 -24', '16 16 40', monster_rebel, google);
    if (mtype == ID_ARCHER_GOBLIN)
        return CreateMonster (parent, spot, "monster_goblin", land, '-16 -16 -24', '16 16 40', monster_goblin, google);
    if (mtype == ID_ARCHER_ORC)
        return CreateMonster (parent, spot, "monster_archer", land, '-16 -16 -24', '16 16 40', monster_archer, google);
    if (mtype == ID_ARCHER_LORD)
        return CreateMonster (parent, spot, "monster_archer_lord", land, '-16 -16 -24', '16 16 40', monster_archer_lord, google);
//    if (mtype == ID_ARCHVILE)
//        return CreateMonster (parent, spot, "monster_archvile", land, '-16 -16 -24', '16 16 40', monster_archvile, google);
    if (mtype == ID_ARMY_AXE)
        return CreateMonster (parent, spot, "monster_army_axe", land, '-16 -16 -24', '16 16 40', monster_army_axe, google);
    if (mtype == ID_ARMY_COMMANDO)
        return CreateMonster (parent, spot, "monster_commando", land, '-16 -16 -24', '16 16 40', monster_commando, google);
    if (mtype == ID_ARMY_DEFENDER)
        return CreateMonster (parent, spot, "monster_defender", land, '-16 -16 -24', '16 16 40', monster_defender, google);
    if (mtype == ID_ARMY_ENFORCER)
        return CreateMonster (parent, spot, "monster_enforcer", land, '-16 -16 -24', '16 16 40', monster_enforcer, google);
    if (mtype == ID_ARMY_GRUNT)
        return CreateMonster (parent, spot, "monster_army", land, '-16 -16 -24', '16 16 40', monster_army, google);
    if (mtype == ID_ARMY_GUNNER)
        return CreateMonster (parent, spot, "monster_gunner", land, '-16 -16 -24', '16 16 40', monster_gunner, google);
    if (mtype == ID_ARMY_ME)
        return CreateMonster (parent, spot, "monster_me", land, '-16 -16 -24', '16 16 40', monster_me, google);
    if (mtype == ID_ARMY_ROCKET)
        return CreateMonster (parent, spot, "monster_army_rocket", land, '-16 -16 -24', '16 16 40', monster_army_rocket, google);
    if (mtype == ID_ARMY_CYBORG)
        return CreateMonster (parent, spot, "monster_army_cyborg", land, '-16 -16 -24', '16 16 40', monster_army_cyborg, google);
    if (mtype == ID_ARMY_SOLDIER)
        return CreateMonster (parent, spot, "monster_soldier", land, '-16 -16 -24', '16 16 40', monster_soldier, google);
//    if (mtype == ID_ARMY_ULTRA)
//        return CreateMonster (parent, spot, "monster_ultra", land, '-16 -16 -24', '16 16 40', monster_ultra, google);
    if (mtype == ID_AXE_KNIGHT)
        return CreateMonster (parent, spot, "monster_axeman", land, '-16 -16 -24', '16 16 40', monster_axeman, google);
    if (mtype == ID_AXE_THUG)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_axeman", land, '-16 -16 -24', '16 16 40', monster_axeman, google);
    }
// B
// C
    if (mtype == ID_CYBERDEMON)
        return CreateMonster (parent, spot, "monster_cyberdemon", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_cyberdemon, google);
// D
    if ((mtype >= ID_DEMON_CLASSIC) && (mtype <= ID_DEMON_WILD))
    {
        if (mtype == ID_DEMON_SHADOW)
            land_z = 1;
        else if (mtype == ID_DEMON_WILD)
            land_z = 2;
        return CreateMonster (parent, spot, "monster_demon1", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_demon1, google);
    }
    if (mtype == ID_DOG_HELL)
    {   land_z = 2;
        return CreateMonster (parent, spot, "monster_dog", land, '-32 -32 -24', '32 32 40', monster_dog, google);
    }
    if (mtype == ID_DOG_WILD)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_dog", land, '-32 -32 -24', '32 32 40', monster_dog, google);
    }
    if (mtype == ID_DOG_CLASSIC)
        return CreateMonster (parent, spot, "monster_dog", land, '-32 -32 -24', '32 32 40', monster_dog, google);
    if ((mtype >= ID_DRAGON_RED) && (mtype <= ID_DRAGON_WYRM_WHITE))
    {
        air_z = mtype;      // For 'monster_dragon_summon' to sort out.
        // Use land vector for mins, and sea vector for maxs.
        if (mtype >= ID_DRAGON_WYRM_RED)
            {land = '-112 -112 -24'; sea = '112 112 112';}
        else
            {land = '-56 -56 -24'; sea = '56 56 56';}
        return CreateMonster (parent, spot, "monster_dragon", air, land, sea, monster_dragon_summon, google);
    }
    if (mtype == ID_MP2_DRAGON)
        return CreateMonster (parent, spot, "monster_dragon_doe", air, '-96 -96 -24', '96 96 96', monster_dragon_doe, google);
//    if (mtype == ID_DROLE)
//        return CreateMonster (parent, spot, "monster_drole", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_drole, google);
//    if (mtype == ID_DRONE)
//        return CreateMonster (parent, spot, "monster_drone", air, '-16 -16 -24', '16 16 32', monster_drone, google);
// E
    if (mtype == ID_EBON_ACOLYTE)
        return CreateMonster (parent, spot, "monster_acolyte", land, '-16 -16 -24', '16 16 40', monster_acolyte, google);
    if (mtype == ID_EBON_SORCERER)
        return CreateMonster (parent, spot, "monster_sorceror", land, '-16 -16 -24', '16 16 40', monster_sorceror, google);
    if (mtype == ID_EBON_WARLOCK)
        return CreateMonster (parent, spot, "monster_warlock", land, '-16 -16 -24', '16 16 40', monster_warlock, google);
    if (mtype == ID_EBON_NECROMANCER)
        return CreateMonster (parent, spot, "monster_necromancer", land, '-16 -16 -24', '16 16 40', monster_necromancer, google);
//    if (mtype == ID_EYES)
//        return CreateMonster (parent, spot, "monster_eyes", air, VEC_HULL_MIN, VEC_HULL_MAX, monster_eyes, google);
// F
    if (mtype == ID_FISH)
        return CreateMonster (parent, spot, "monster_fish", sea, '-16 -16 -24', '16 16 24', monster_fish, google);
// G
    if (mtype == ID_GOLEM_KNIGHT)
        return CreateMonster (parent, spot, "monster_golem", land, '-16 -16 -24', '16 16 40', monster_golem, google);
//    if (mtype == ID_GUG)
//        return CreateMonster (parent, spot, "monster_gug", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_gug, google);
// H
// I
    if ((mtype >= ID_IMP_KINN) && (mtype <= ID_IMP_BLUE))
    {
        if (mtype == ID_IMP_BLACK)
            air_z = 1;
        else if (mtype == ID_IMP_RED)
            air_z = 2;
        else if (mtype == ID_IMP_BLUE)
            air_z = 3;
        return CreateMonster (parent, spot, "monster_imp", air, '-16 -16 -24', '16 16 32', monster_imp, google);
    }
    if ((mtype >= ID_IMP_LORD) && (mtype <= ID_IMP_LORD_ICE))
    {
        if (mtype == ID_IMP_LORD_ICE)
            air_z = 1;
        return CreateMonster (parent, spot, "monster_imp_lord", air, VEC_HULL_MIN, VEC_HULL_MAX, monster_imp_lord, google);
    }
// J
// K
    if (mtype == ID_KNIGHT_BANE)
        return CreateMonster (parent, spot, "monster_bane", land, '-16 -16 -24', '16 16 40', monster_bane, google);
    if (mtype == ID_KNIGHT_BARON)
        return CreateMonster (parent, spot, "monster_baron", land, '-16 -16 -24', '16 16 40', monster_baron, google);
    if ((mtype >= ID_BARON_WATER) && (mtype <= ID_BARON_AIR))
    {
        if (mtype == ID_BARON_FIRE)
            land_z = 1;
        else if (mtype == ID_BARON_EARTH)
            land_z = 2;
        else if (mtype == ID_BARON_AIR)
            land_z = 3;
        else
            land_z = 4;
        return CreateMonster (parent, spot, "monster_baron", land, '-16 -16 -24', '16 16 40', monster_baron, google);
    }
    if (mtype == ID_KNIGHT_GRUNT1)
        return CreateMonster (parent, spot, "monster_knight", land, '-16 -16 -24', '16 16 40', monster_knight, google);
    if (mtype == ID_KNIGHT_GRUNT2)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_knight", land, '-16 -16 -24', '16 16 40', monster_knight, google);
    }
    if (mtype == ID_KNIGHT_HELL)
        return CreateMonster (parent, spot, "monster_hell_knight", land, '-16 -16 -24', '16 16 40', monster_hell_knight, google);
    if (mtype == ID_KNIGHT_HELL_LORD)
        return CreateMonster (parent, spot, "monster_hell_lord", land, '-16 -16 -24', '16 16 40', monster_hell_lord, google);
    if (mtype == ID_KNIGHT_HELL_BOSS)
        return CreateMonster (parent, spot, "monster_hkboss", land, '-16 -16 -24', '16 16 40', monster_hkboss, google);
    if (mtype == ID_KNIGHT_DARK_LORD)
        return CreateMonster (parent, spot, "monster_dark_lord", land, '-16 -16 -24', '16 16 40', monster_dark_lord, google);
    if (mtype == ID_KNIGHT_DARK_LORD2)
    {   land_x = 6;
        return CreateMonster (parent, spot, "monster_dark_lord", land, '-16 -16 -24', '16 16 40', monster_dark_lord, google);
    }
// L
// M
    if (mtype == ID_MP1_ARMAGON)
        return CreateMonster (parent, spot, "monster_armagon", land, '-48 -48 -24', '48 48 84', monster_armagon, google);
    if (mtype == ID_MP1_GREMLIN)
        return CreateMonster (parent, spot, "monster_gremlin", land, VEC_HULL_MIN, VEC_HULL_MAX, monster_gremlin, google);
    if (mtype == ID_MP1_SCORPION)
        return CreateMonster (parent, spot, "monster_scourge", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_scourge, google);
    if (mtype == ID_MP2_EEL)
        return CreateMonster (parent, spot, "monster_eel", sea, VEC_HULL_MIN, VEC_HULL_MAX, monster_eel, google);
    if (mtype == ID_MP2_GUARDIAN)
        return CreateMonster (parent, spot, "monster_morph", land, '-16 -16 -24', '16 16 40', monster_morph, google);
    if (mtype == ID_MP2_WRATH)
        return CreateMonster (parent, spot, "monster_wrath", air, VEC_HULL_MIN, VEC_HULL_MAX, monster_wrath, google);
    if (mtype == ID_MP2_WRATH_LORD)
        return CreateMonster (parent, spot, "monster_super_wrath", air, VEC_HULL_MIN, VEC_HULL_MAX, monster_super_wrath, google);
// N
    if (mtype == ID_NEMESANT)
        return CreateMonster (parent, spot, "monster_troglodyte", air, '-16 -16 -24', '16 16 40', monster_troglodyte, google);
    if (mtype == ID_NEMESANT_LORD)
        return CreateMonster (parent, spot, "monster_trogboss", air, '-16 -16 -24', '16 16 40', monster_trogboss, google);
    if (mtype == ID_NIGHTSHADE)
        return CreateMonster (parent, spot, "monster_nightshade", air, '-64 -64 -24', '64 64 64', monster_nightshade, google);
// O
    if (mtype == ID_OGRE)
        return CreateMonster (parent, spot, "monster_ogre", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_ogre, google);
    if (mtype == ID_OGRE_FLAK)
        return CreateMonster (parent, spot, "monster_ogre_flak", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_ogre_flak, google);
    if (mtype == ID_OLDONE)
    {   land_x = 2;     // Arcanum bbeg mode.
        return CreateMonster (parent, spot, "monster_oldone", land, '-128 -128 -24', '128 128 256', monster_oldone, google);
    }
// P
    if (mtype == ID_PLAYER)
        return CreateMonster (parent, spot, "monster_ranger", land, '-16 -16 -24', '16 16 40', monster_ranger, google);
// Q
// R
// S
    if (mtype == ID_SHALRATH_DARK)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_shalrath", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_shalrath, google);
    }
    if (mtype == ID_SHALRATH_CLASSIC)
        return CreateMonster (parent, spot, "monster_shalrath", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_shalrath, google);
    if (mtype == ID_SHAMBLER_WHITE)
        return CreateMonster (parent, spot, "monster_shambler", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_shambler, google);
    if (mtype == ID_SHAMBLER_BLACK)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_shambler", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_shambler, google);
    }
    if (mtype == ID_SHAMVILE)
        return CreateMonster (parent, spot, "monster_shamvile", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_shamvile, google);
    if (mtype == ID_SKULL_WIZARD)
        return CreateMonster (parent, spot, "monster_skull_wizard", land, '-16 -16 -24', '16 16 40', monster_skull_wizard, google);
    if (mtype == ID_SKULL_LORD)
        return CreateMonster (parent, spot, "monster_skull_wizard_lord", land, '-16 -16 -24', '16 16 40', monster_skull_wizard_lord, google);
    if (mtype == ID_SKULL_BOSS)
        return CreateMonster (parent, spot, "monster_skull_wizard_boss", land, '-16 -16 -24', '16 16 40', monster_skull_wizard_boss, google);
//    if (mtype == ID_SNAKEMAN)
//        return CreateMonster (parent, spot, "monster_snakeman", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_snakeman, google);
    if (mtype == ID_SPIDER)
        return CreateMonster (parent, spot, "monster_spider", land, VEC_SPIDER_MIN, VEC_SPIDER_MAX2, monster_spider, google);
    if (mtype == ID_SPIDER2)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_spider", land, VEC_SPIDER_MIN, VEC_SPIDER_MAX2, monster_spider, google);
    }
    if (mtype == ID_SPIDER3)
    {   land_z = 2;
        return CreateMonster (parent, spot, "monster_spider", land, VEC_SPIDER_MIN, VEC_SPIDER_MAX2, monster_spider, google);
    }
// T
    if (mtype == ID_TARBABY_BLUE)
        return CreateMonster (parent, spot, "monster_tarbaby", land, '-16 -16 -24', '16 16 40', monster_tarbaby, google);
    if (mtype == ID_TARBABY_GREEN)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_tarbaby", land, '-16 -16 -24', '16 16 40', monster_tarbaby, google);
    }
    if (mtype == ID_TARBABY_RED)
    {   land_z = 2;
        return CreateMonster (parent, spot, "monster_tarbaby", land, '-16 -16 -24', '16 16 40', monster_tarbaby, google);
    }
/*
    if (mtype == ID_TURRET_LASER)
        return CreateMonster (parent, spot, "monster_turret", land, '-16 -16 -20', '16 16 16', monster_turret_laser, google);
    if (mtype == ID_TURRET_GUN)
        return CreateMonster (parent, spot, "monster_turret", land, '-16 -16 -20', '16 16 16', monster_turret_gun, google);
    if (mtype == ID_TURRET_ROCKET)
        return CreateMonster (parent, spot, "monster_turret", land, '-16 -16 -20', '16 16 16', monster_turret_rocket, google);
*/
// U
// V
    if (mtype == ID_VOMITUS)
        return CreateMonster (parent, spot, "monster_vomitus", land, '-32 -32 -24', '32 32 24', monster_vomitus, google);
    if (mtype == ID_VOMITUS_MEAT)
        return CreateMonster (parent, spot, "monster_meatwad", land, '-32 -32 -24', '32 32 24', monster_meatwad, google);
// W
//    if (mtype == ID_WILLY)
//        return CreateMonster (parent, spot, "monster_willy", land, '-32 -32 -24', '32 32 24', monster_willy, google);
    if (mtype == ID_WIZARD_DRAKE)
    {   air_z = 1;
        return CreateMonster (parent, spot, "monster_wizard", air, '-16 -16 -24', '16 16 40', monster_wizard, google);
    }
    if (mtype == ID_WIZARD_SCRAG)
        return CreateMonster (parent, spot, "monster_wizard", air, '-16 -16 -24', '16 16 40', monster_wizard, google);
    if (mtype == ID_WRAITH)
        return CreateMonster (parent, spot, "monster_wraith", air, '-16 -16 -24', '16 16 40', monster_wraith, google);
    if (mtype == ID_WRAITH_LORD)
        return CreateMonster (parent, spot, "monster_wraith_lord", air, '-16 -16 -24', '16 16 40', monster_wraith_lord, google);
// X
// Y
    if (mtype == ID_YAKMAN_WHITE)
        return CreateMonster (parent, spot, "monster_yakman", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_yakman, google);
    if (mtype == ID_YAKMAN_BROWN)
    {   land_z = 1;
        return CreateMonster (parent, spot, "monster_yakman", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_yakman, google);
    }
    if (mtype == ID_YAKMAN_BLACK)
    {   land_z = 2;
        return CreateMonster (parent, spot, "monster_yakman", land, VEC_HULL2_MIN, VEC_HULL2_MAX, monster_yakman, google);
    }
// Z
    if (mtype == ID_ZOMBIE)
        return CreateMonster (parent, spot, "monster_zombie", land, '-16 -16 -24', '16 16 40', monster_zombie, google);
    if (mtype == ID_ZOMBIE_MUMMY)
        return CreateMonster (parent, spot, "monster_mummy", land, VEC_HULL_MIN, VEC_HULL_MAX, monster_mummy, google);

// Not available?
    return FALSE;
};

// Attempts to summon a monster near an enemy.  Usable only by monsters,
// since players do not use the enemy fields except for death effects.
float(entity parent, float mtype) SpawnMonster_Attack =
{
    local   vector  spot;

    spot = parent.origin;
    if (parent.flags & FL_MONSTER)
        if (parent.enemy)
            spot = parent.enemy.origin;
    return SpawnMonster (parent, spot, mtype, EntryPoint_WizRandom);
};

//float(entity parent, float mtype) SpawnMonster_Fan =
//    {return SpawnMonster (parent, parent.origin, mtype, EntryPoint_Fan);};

float(entity parent, float mtype) SpawnMonster_Circle =
    {return SpawnMonster (parent, parent.origin, mtype, EntryPoint_Circle);};

float(entity parent, vector spot, float mtype) SpawnMonster_Point =
    {return SpawnMonster (parent, spot, mtype, EntryPoint_One);};

// Spawns 'loop' amount of 'mtype' monsters.  Assumes 'self' to be parent.
void(float mtype, float loop) SpawnMonster_Horde =
{
    local   vector  v1, v2, v3;

    makevectors (self.angles);
    v1 = self.origin + (v_forward*34) + (v_right*80) + (v_up*39);
    v2 = self.origin + (v_forward*34) - (v_right*80) + (v_up*39);
    if (loop == 1)
        if (random() < 0.5)
            {v3 = v1;  v1 = v2;  v2 = v3;}
    v3 = self.origin + (v_forward*34) + (v_up*119);  // 39+80=119.

    if (SpawnMonster_Point (self, v1, mtype))
    {   loop = loop - 1;
        if (loop < 1)
            return;
    }
    if (SpawnMonster_Point (self, v2, mtype))
    {   loop = loop - 1;
        if (loop < 1)
            return;
    }
    if (SpawnMonster_Point (self, v3, mtype))
    {   loop = loop - 1;
        if (loop < 1)
            return;
    }
    while (loop > 0)
    {
        loop = loop - 1;
        SpawnMonster (self, self.origin, mtype, EntryPoint_Fan);
    }
};


//==========================================================================
//  Impulses

// Summons a monster.
void() Cheat_Monster =
{
    if (gamemode & GM_SUMMON_ALL)
    {
        local   float   mtype;
    
        mtype = cvar("saved1");
        if (mtype)
            SpawnMonster_Circle (self, mtype);
        else
            sprint (self, "Set 'saved1' to any positive integer, then try again.\n");
    }
    else if (cvar("temp1") & GM_SUMMON_ALL)
    {
        sprint (self, "Restart level first.\n");
    }
    else
    {
        local   string  text;

        text = ftos(GM_SUMMON_ALL);
        sprint (self, "To enable summoning, set 'temp1' to ");  //saved1
        sprint (self, text);
        sprint (self, ", then restart level.\n");
    }
};


//===========================/  END OF FILE  /===========================//
