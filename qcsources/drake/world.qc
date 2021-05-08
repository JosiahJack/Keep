//==========================================================================
//  BODY QUE
//==========================================================================
entity      bodyque_head;

// Makes a circular linked link of four body entities.
void() InitBodyQue =
{
// Linked list example from Quake Wiki, modified.
    local   entity  e;
    local   float   loop;   // Extra bodies after the first.

// Create the first bodyque.
    e = spawn();
    e.classname = "bodyque";
    bodyque_head = e;

// Create more bodyques.  Total = loop + 1.  Id's original total is four.
    loop = 3;
    while (loop > 0)
    {
        e.owner = spawn();
        e.owner.classname = "bodyque";
        e = e.owner;
        loop = loop - 1;
    }

// Link the last bodyque to the first.  Now we have a circular linked list.
    e.owner = bodyque_head;
};

// Make a body que entry for the given ent so the ent can be respawned
// elsewhere (without the corpse disappearing).
void(entity ent) CopyToBodyQue =
{
    bodyque_head.angles     = ent.angles;
    bodyque_head.model      = ent.model;
    bodyque_head.modelindex = ent.modelindex;
    bodyque_head.frame      = ent.frame;
    bodyque_head.colormap   = ent.colormap;
    if (ent.movetype == MOVETYPE_WALK)
        bodyque_head.movetype   = MOVETYPE_TOSS;
    else
        bodyque_head.movetype   = ent.movetype;
    bodyque_head.velocity   = ent.velocity;
    bodyque_head.flags      = 0;
    setorigin (bodyque_head, ent.origin);
    setsize (bodyque_head, ent.mins, ent.maxs);
    bodyque_head = bodyque_head.owner;
};


//==========================================================================
//  TEMP GOAL (Custom addition)
//
//  'walkmove' and 'movetogoal' always causes a flying monster to drift
//  vertically toward edict.enemy by 8 per call.  In addition, if the
//  drift fails, the whole move aborts and no horizontal move is done.
//
//  Therefore, create a dummy entity that can be swapped in temporarily
//  as the enemy.
//==========================================================================
entity  temp_goal;

// Used to control movement of flying/swimming entities.
void() InitTempGoal =
{
    temp_goal = spawn();
    temp_goal.classname = "goal";
};


//==========================================================================
//  MOVE BOX (Custom addition)
//
//  Quake checks movement with only one of three hull sizes:
//  point-size, human-size, and shambler-size.  Anything bigger than
//  shambler-size will clip walls because it is bigger than the bbox
//  used by the Quake engine for movement.
//
//  Therefore, create a dummy entity that can test movement multiple
//  times on behalf of the monster to be moved.  The move box is
//  placed at the corners of the monster, and if all move checks are
//  good, the monster will be allowed to move.
//==========================================================================
entity  move_box;

// Used by big entities to prevent clipping of walls.
void() InitMoveBox =
{
    move_box = spawn();
    setsize (move_box, VEC_HULL2_MIN, VEC_HULL2_MAX);
    move_box.solid      = SOLID_NOT;
    move_box.movetype   = MOVETYPE_STEP;
    move_box.classname  = "move_box";
};

// Update move box so its ready for movement
void() UpdateMovebox =
{
    if (!move_box)
        InitMoveBox ();

    setorigin (move_box, self.origin);
    setsize (move_box, self.mins, self.maxs);
    move_box.solid      = SOLID_NOT;
    move_box.movetype   = self.movetype;
    move_box.flags      = self.flags & FLx_NOT_FALLING;
    move_box.angles     = self.angles;
    move_box.ideal_yaw  = self.ideal_yaw;
    move_box.enemy      = self.enemy;   // For walkmove's up/down motion.
    move_box.goalentity = self.goalentity;
    move_box.owner      = self;         // So box can pass through owner.
// Splash sound control.  Synchronize builtin water values with the dragon's.
// Otherwise, any time the dragon is underwater, Quake will think the
// hull box enters water when it moves, resulting in repeating splash
// sounds each frame.
    move_box.waterlevel = self.waterlevel;
    move_box.watertype  = self.watertype;
};


//==========================================================================
//  LIGHTNING (Custom addition)
//
//  This is an edict set aside for the sole purpose of referencing
//  reflected lightning bolts.
//==========================================================================
entity  lightning;

// Used by lightning code to draw reflected lightning bolts.
void() InitLightning =
{
    lightning = spawn();
    setsize (move_box, VEC_ORIGIN, VEC_ORIGIN);
    move_box.solid      = SOLID_NOT;
    move_box.movetype   = MOVETYPE_NONE;
    move_box.classname  = "lightning";
};


//==========================================================================
//  MUSIC (Custom addition)
//
//  Two edicts set aside to play music.
//
//  For music to play from both speakers, we need two edicts, with each
//  at the opposite points of the map, diametrically opposed.
//
//  Note:  Two speaker entities are not enough to guarantee stereo sound,
//  Four speakers in each corner of the xy-plane are required.
//
//  Tying up four entities permanently for stereo sound is a bit much.
//  Two entities it is!
//
//  FIXME:  In DarkPlaces, remove stereo2 because ATTN_NONE is in stereo.
//==========================================================================
entity  stereo1, stereo2;

void() SpawnStereo =
{
// One placed at the low end.
    if (!stereo1)
    {
        stereo1 = spawn();
        stereo1.movetype  = MOVETYPE_NONE;
        stereo1.solid     = SOLID_NOT;
        stereo1.classname = "stereo1";
        stereo1.noise     = world.null_string;
        stereo1.lefty     = 0;
        setorigin (stereo1, '-4000 -4000 -4000');
    }
// Other placed at the high end.
    if (!stereo2)
    {
        stereo2 = spawn();
        stereo2.movetype  = MOVETYPE_NONE;
        stereo2.solid     = SOLID_NOT;
        stereo2.classname = "stereo2";
        setorigin (stereo2, '4000 4000 4000');
    }
};

// Function for non-looped music.
void() ReplayMusic = {PlayMusic (self.noise, self.wait);};

// Note:  The sound played should be looped.
// 'dur' - Looped sounds should use 0.  Unlooped sounds should use non-zero.
void(string text, float dur) PlayMusic =
{
    if (IsEmptyString (text))
        return;     // No music to play.

// Channel:  Use channel 7 instead of the random CHAN_AUTO.
// Volume:  Always use max volume.  Client has a volume knob on hardware.
// Attenuation:  Distance is not a factor, so use ATTN_NONE.
    SpawnStereo ();     // Create stereo entities if necessary.
    if (text == "misc/null.wav")
    {
        stereo1.lefty = 1;
        dur = 0;    // In case of idiot code.
    }
    else
    {
        if (!stereo1.lefty)
            if (stereo1.noise == text)
                return;     // Already playing the same music.

    // Set the music.
        stereo1.noise = text;
        stereo1.wait = dur;
        if (cvar("temp1") & GM_MUSIC_OFF)   //(serverflags & SVFL_MUSIC_OFF)
            return;     // Turned off.
        stereo1.lefty = 0;
    }
    sound (stereo1, 7, text, 1, ATTN_NONE);
    sound (stereo2, 7, text, 1, ATTN_NONE);

    if (dur)
    {
        stereo1.nextthink = time + dur;
        stereo1.think     = ReplayMusic;
    }
    else
    {   // Assumed looped.
        stereo1.nextthink = 0;
        stereo1.think     = world.null_func;
    }
};

void() Start_Think =
{
    if (self.cnt)
    {
        self.nextthink = time + 0.1;
        self.think = Start_Think;

    // At the start of a level, we cannot play music as soon as a client
    // is detected.  We must delay the music a frame so the client can
    // hear the music.
        if (find (world, classname, "player"))
        {
            self.cnt = 0;
            if (deathmatch || coop)     // Give more time for all to spawn.
                self.nextthink = time + 3;
        }
        return;
    }
// Client was detected earlier.
    PlayMusic (self.noise, self.wait);
};

// This should only be called by worldspawn.
void() InitMusic =
{
    local   string  music1, music2, music3;
    local   float   abort;

    stereo1 = stereo2 = world;

    abort = TRUE;
    if (world.noise)
        music1 = world.noise;
    else
        music1 = world.noise1;
    if (soul_evil)      // Update 5/5/10:  Not in medieval mode too.
        music2 = "music/pkdream.wav";
    else
        music2 = world.noise2;
    music3 = world.noise3;

    if (!IsEmptyString (music1))
        {abort = FALSE;  precache_sound (music1);}
    if (!IsEmptyString (music2))
        {abort = FALSE;  precache_sound (music2);}
    if (!IsEmptyString (music3))
        {abort = FALSE;  precache_sound (music3);}

    if (abort)
        return;     // No music to play.

    SpawnStereo ();
// Hack:  SoE music doesn't loop.
// halo     = 1:17:998 (78)
// shadows  = 0:49:920 (50)
// soultrap = 1:18:713 (79)
    // Replay music roughly 70 sec. after end.
    if ((music1 == "music/halo.wav") || (music1 == "music/soultrap.wav"))
        stereo1.wait = 150;
    else if (music1 == "music/shadows.wav")
        stereo1.wait = 120;

    stereo1.cnt       = 1;
    stereo1.lefty     = 1;
    stereo1.noise     =
    stereo1.noise1    = music1;   // Start music.
    stereo1.noise2    = music2;   // End of level music.
    stereo1.noise3    = music3;   // End of episode music.
    stereo1.nextthink = time + 0.2;     // Wait until other stuff spawns.
    stereo1.think     = Start_Think;
};

// Toggles music on and off.  It is not really a cheat, but since music
// only works in single-player, might as well lump it with the rest of the
// single-player exclusive features.
void() Toggle_Music =
{
    local   float   gm;
    local   string  text;

    gm = cvar("temp1");
    if (gm & GM_MUSIC_OFF)
    {   text = ftos(gm - GM_MUSIC_OFF);
        cvar_set ("temp1", text);
        if (stereo1)
            if (stereo1.noise)
                PlayMusic (stereo1.noise, stereo1.wait);
        sprint (self, "music ON\n");
    }
    else
    {   text = ftos(gm | GM_MUSIC_OFF);     //serverflags = serverflags | SVFL_MUSIC_OFF;
        cvar_set ("temp1", text);
        PlayMusic ("misc/null.wav", 0);
        sprint (self, "music OFF\n");
    }

// Old Code - - - -
//    if (serverflags & SVFL_MUSIC_OFF)
//    {   serverflags = serverflags - SVFL_MUSIC_OFF;
//        if (stereo1)
//            if (stereo1.noise)
//                PlayMusic (stereo1.noise, stereo1.wait);
//        sprint (self, "music ON\n");
//    }
//    else
//    {   serverflags = serverflags | SVFL_MUSIC_OFF;
//        PlayMusic ("misc/null.wav", 0);
//        sprint (self, "music OFF\n");
//    }
//- - - - - - - - -
};

void() IntermissionMusic =
{
    if (dmsp == TRUE)   // In some game modes, play the cool guitar music from PainKeep.
        PlayMusic ("music/pkdream.wav", 0);
    else if (stereo1)
    {
        if (intermission_running >= 2)
            PlayMusic (stereo1.noise3, 0);
        else
            PlayMusic (stereo1.noise2, 0);
    }
};


//==========================================================================
//
//  WORLDSPAWN
//
//==========================================================================

// Prototypes used by worldspawn.
void() cache_all_monsters;  // For possible summoning cheat.
void() maphack;             // SoE:  Adds entities to specific maps.

// This sets the level's default guns and ammo during worldspawn.
void() set_arsenal =
{
    //- - - - - - - - - -
    // Set allowed weapons.  Do BEFORE precaching model and sound files.
    // Must also do before setting map's default weapons for new players.
    //
    // Why not legalize all weapons?  Because normal Quake engines have
    // a limit of 256 models and 256 sounds, and exceeding those limits
    // during a level load will cause the level load to fail and the
    // client will be dumped to the console.
    //
    // Even in engines with expanded limits, too many sounds can mute some
    // ambient sounds, at least in AguirRe Quake, so it is best to stay
    // within the 256 limit.
    //- - - - - - - - - -
    if (soul_evil)
        legalized = legalized | WARx_QUAKE_WEAPONS | WARx_LASERS | WAR_CHAIN_LIGHTNING | WAR_CRUISE_MISSILE | WAR_MJOLNIR;
    else
        legalized = legalized | WARx_ALL_WEAPONS;
//        legalized = legalized | WARx_QUAKE_WEAPONS;

// Initialize level weapons.  Must do after legalization.
    if (self.drama1)    // DRAke Monster Arsenal, release 1.
        map_guns = self.drama1;
    else
    {   // Convert item fields for arsenal.
        map_guns = 0;
        if (self.items & ITx_ALL_WEAPONS)
        {   // Convert weapon data for Drake.
            if (self.items &    1)  map_guns = map_guns | WAR_SHOTGUN;
            if (self.items &    2)  map_guns = map_guns | WAR_SUPER_SHOTGUN;
            if (self.items &    4)  map_guns = map_guns | WAR_NAILGUN;
            if (self.items &    8)  map_guns = map_guns | WAR_SUPER_NAILGUN;
            if (self.items &   16)  map_guns = map_guns | WAR_GRENADE_LAUNCHER;
            if (self.items &   32)  map_guns = map_guns | WAR_ROCKET_LAUNCHER;
            if (self.items &   64)  map_guns = map_guns | WAR_THUNDERBOLT;
            if (self.items & 4096)  map_guns = map_guns | WAR_AXE;
        }
    }

// Zero out other map item defaults.
// Note:  Check the parms setup in client.qc.
    map_armor = map_ammo1 = map_ammo2 = 0;
// Update:  Added naked check.
    if (self.items == -1)
    {
        map_guns = 0;
        return;
    }

// Always give the basics.
    map_guns = (map_guns | WAR_AXE | WAR_SHOTGUN) & legalized;

// Check armor.  Can give basic armor only -- no exotics.
    if (self.items & ITx_ALL_ARMOR)
    {
        if (self.items & IT_ARMOR3)
        {   // 100 * 256 = 25600
            map_armor = IT_ARMOR3;
            map_ammo1 = ARMOR_STATS_RED_y | (ARMOR_STATS_RED_x * 25600);
        }
        else if (self.items & IT_ARMOR2)
        {
            map_armor = IT_ARMOR2;
            map_ammo1 = ARMOR_STATS_YELLOW_y | (ARMOR_STATS_YELLOW_x * 25600);
        }
        else if (self.items & IT_ARMOR1)
        {
            map_armor = IT_ARMOR1;
            map_ammo1 = ARMOR_STATS_GREEN_y | (ARMOR_STATS_GREEN_x * 25600);
        }
    }

// Now the ammo.
// Update 6/10/2011:  A munchkin can play start map in classic mode,
// then change to Drake mode next level for a profit of ten shells.
// Thus, just let the player start with 25 shells.
    if (map_guns & WARx_USES_SHELLS)
        map_ammo1 = map_ammo1 | (SHELLS_START * 65536);
    if (map_guns & WARx_USES_NAILS)
        map_ammo2 = map_ammo2 | 30;
    if (map_guns & WARx_USES_ROCKETS)
        map_ammo2 = map_ammo2 | (5 * 256);
    if (map_guns & WARx_USES_CELLS)
        map_ammo2 = map_ammo2 | (30 * 65536);

// Find the best weapon as the default weapon of choice.
// Remember, we will have ammo to use them.
    local   float   w;

    map_woc = 0;
    w = 1;      // Start at the worst.
    while (w)
    {
        if (w & map_guns)
            map_woc = w;

        if (w >= 8388608)
            return;     // Done checking last weapon.
        w = w * 2;  // Shift to the next weapon bit.
    }
};

// This sets the level's gravity during worldspawn.
void() set_gravity =
{
    local   string  text;

    if (self.gravity)
    {   // Level has custom gravity.
        self.gravity = floor (self.gravity);
        if (self.gravity < 0)
            self.gravity = 0;     // Reverse gravity is unplayable.
    }

    if (self.gravity)
        text = ftos(self.gravity);
    else
    {
        text = "800";
        if (self.model == "maps/e1m8.bsp")
            if (self.message == "Ziggurat Vertigo")   // Confirm id's e1m8.
                text = "100";
    }

    cvar_set ("sv_gravity", text);
};

//===============================
// PM:  Mjolnir uses standard player model instead of playham.mdl.
// I did this for three reasons.  One, it is one less model to precache.
// Two, guns do not get the visible weapons treatment, so why should
// melee weapons of similar shape get special treatment.  Three, some
// custom engines support an enhanced version of the standard player model.
// 'playham.mdl' is NOT standard!
//
// Note:  'playham.mdl' is used in Tronyn's mods, but not in Drake.

// This sets the modelindecies used by the player.
// Called by worldspawn once per level, instead of after each client spawn.
void() PlayerIndex =
{
// We cannot set model of the world to any of the player models,
// so create a dummy to use for setmodel, then remove it when finished.
    local   entity  e;

    e = spawn();

//- - - - - - - - -
// PM:  I chose to use a null sprite instead of the eyes for two reasons.
// 1) Monsters can be invisible, and eyes are not always appropriate.
// 2) Sometimes, eyes are easier to spot in the dark.  Varies with engine.
//
// I guess visible eyes were used because a completely invisible person
// should be blind due to light unable to hit the retina.  This is
// handwaved away.  After all, a wizard did it.  See above for reasons.
//
// I could have both eyes and null sprite, but some maps precache
// a high number of models, and I do not want to break standard limit
// by precaching unnecessary models just for better eye candy.
//- - - - - - - - -
    setmodel (e, "progs/null_256.spr");     // was 'progs/eyes.mdl'
    mindex_inviso = e.modelindex;

    setmodel (e, "progs/player.mdl");
    mindex_player = e.modelindex;

// 'gamemode' is set before PlayerIndex is called.
    if (gamemode & GM_PLAYER)
    {   // Enable extra player models.
        // NOTE:  Assumes this is done during worldspawn.
        precache_model ("progs/playham.mdl");
        precache_model ("progs/playham0.mdl");
        precache_model ("progs/playsaw.mdl");

        setmodel (e, "progs/playham.mdl");
        mindex_hammer = e.modelindex;
    
        setmodel (e, "progs/playham0.mdl");
        mindex_hamout = e.modelindex;
    
        setmodel (e, "progs/playsaw.mdl");
        mindex_saw = e.modelindex;
    }
    else
    {   // Use original player.mdl only.
        mindex_hammer = mindex_hamout = mindex_saw = 0;
    }

    //- - - - - - - - -
    // Dragonscale is a special case.  We precache it only if we need it
    // in the levels it is featured in.  This means the morphing power
    // may not work in levels that don't have dragonscale.  That's okay.
    // Well, not really, but something needs to give to avoid excessive
    // precaching.  I cannot simply rip out dragonscale due to legacy issues,
    // but I can squelch it when it isn't needed.  Besides, this item is
    // used only in Soul of Evil.
    //- - - - - - - - -
    if (soul_evil || (gamemode & GM_DRAGONSCALE))
        precache_dragonscale ();
    else    // Don't use dragonscale unless an item is found later.
        mindex_dragon = 0;

    remove (e);
};

//=======================
// --> QUAKED worldspawn (0 0 0) ?
// Only used for the world entity.
// Set message to the level name.
// Set sounds to the cd track to play.
//
// World Types:
// 0: medieval
// 1: metal
// 2: base
//=======================
entity      lastspawn;

void() worldspawn =
{
    framecount = 0;
    lastspawn = world;  // Must start somewhere when selecting a spawn point.
// Set aside some edict slots for permanent entities.
    BotInit ();         // FrikBot
    InitBodyQue ();
    InitTempGoal ();
    InitMoveBox ();
    InitLightning ();
    // Moved InitMusic below gamemode settings.
// Initialize alignment hitlists and names.
    blacky = whitey = world;    // Start at the world.
    EVIL = "evil";
    GOOD = "good";

    // PM:  Forget Hip's bulletholes -- they look out of place in dark levels
    // like those in the Zerstorer level pack.  Also, some custom engines
    // have enhanced graphics that automatically handle this sort of stuff
    // engine side.

// Update 5/5/2010:  Moved custom map attribute check below.

//- - - - - - - - -
    albatross =
    bsp_shift =
    medieval =
    soul_evil = FALSE;

    if ((self.model == "maps/start.bsp") || (self.tronyn & DJG_STRIP))
        albatross = TRUE;
    if (self.tronyn & DJG_BSP_SHIFT)
        bsp_shift = TRUE;

    if (self.tronyn & DJG_SOUL_EVIL)
        medieval = soul_evil = TRUE;    // SoE is medieval fantasy.
    else if (self.tronyn & DJG_MEDIEVAL)
        medieval = TRUE;
//- - - - - - - - -

// Update 10/29/10:  Set gamemode and derivatives here.
    gamemode    = cvar("temp1");    //cvar("saved1");

    footsteps = (gamemode & GM_FOOTSTEPS);
    q1shot = (gamemode & GM_PURIST);    // Do before calling 'set_arsenal'.
    if (gamemode & GM_SOUL_EVIL)
        soul_evil = medieval = TRUE;
    else if (gamemode & GM_MEDIEVAL)
        medieval = TRUE;
// FIXME:  Temporary test modes.
    if (gamemode & GM_BSP_TEST)
        bsp_shift = TRUE;
//- - - - - - - - -

//- - - - - - - - -
// Update 10/30/09:  Indian Summer hack.
    if ((self.model == "maps/nsoe1.bsp") || (self.model == "maps/nsoe2.bsp")
    || (self.model == "maps/nsoe3.bsp") || (self.model == "maps/nsoe4.bsp")
    || (self.model == "maps/nsoe5.bsp") || (self.model == "maps/nsoe6.bsp"))
    {
        medieval = soul_evil = TRUE;
        if ((self.model == "maps/nsoe2.bsp"))
            albatross = TRUE;
        if ((self.model == "maps/nsoe3.bsp") || (self.model == "maps/nsoe4.bsp")
        || (self.model == "maps/nsoe5.bsp") || (self.model == "maps/nsoe6.bsp"))
            albatross = bsp_shift = TRUE;
    }

// custom map attributes
    set_arsenal ();
    set_gravity ();

// Zer level hack - -
//    if (zerstorer)
//    {   if (self.model == "maps/zer1m2.bsp")
//            {cvar_set ("r_drawviewmodel", "0"); cvar_set ("viewsize", "120");}
//        else
//            cvar_set ("r_drawviewmodel", "1");
//    }
//- - - - - - - - - -

// Initialize globals dependant on cvar values during worldspawn.
    skill       = cvar("skill");    // Integer from 0 to 3.
//    sv_gravity  = cvar("sv_gravity");
//    sv_maxspeed = cvar("sv_maxspeed");
    sys_ticrate = cvar("sys_ticrate");  // FIXME:  Do this at StartFrame?
    teamplay    = cvar("teamplay");
    //- - - - - - - - -
    // Notes on Hell skill.
    // Use 'serverflags' to persist within a game, even if reloaded later.
    // Use cvar 'temp1' to persist until the server shuts down Quake.
    //- - - - - - - - -
    if (gamemode & GM_HELL)
        serverflags = serverflags | SVFL_HELL;
    // ...and other globals dependant on the above defined globals.
    if (serverflags & SVFL_HELL)
    {   // Activate Hell difficulty!
        cranked = doomed = TRUE;
        skill = 4;
        cvar_set ("skill", "4");
    }
    else
    {
        cranked = gamemode & GM_CRANKED;    // Check:  Was gamemode set above?
        doomed  = gamemode & GM_RESPAWN;
    }
//- - - - - - - - - - - - - - -

// Now that gamemode is set, initialize music.
    InitMusic ();

// Initialize other globals.
    cutscene = 0;   // No cutscene is active during worldspawn.
    gloat = 0;      // Reset global attack counter.
    pco = pointcontents(VEC_ORIGIN);
    reload_count = 0;   // Number of save-and-reloads in a level.
    ghosttouch = FALSE; // Don't use ghosttouch unless a ghost spawns.

// setup necessary precaches
    // First, zero out globals that are set by precache/spawn functions.
    powcache = 0;
    cash_drop = FALSE;
    // Now precache files for real.
    world_cache_sounds ();
    world_cache_models ();
// FIXME:  (Todo) Limit money by monster.
    if (soul_evil)
        precache_money ();    // Must be called before monsters can drop cash.
// FIXME:  ???
    // Test modes.
    if (gamemode & GM_SUMMON_ALL)
    {
        cache_all_monsters ();  // Monster summoning.
        ghosttouch = TRUE;  // Ghosts can be spawned dynamically.
    }
//- - - - - - - - -
    // For temp1, use 1 instead of GM_DMSP for SoE legacy reasons.
    if ( (cvar("temp1") & 1) || (world.tronyn & DJG_ARENA) )
    {
        dmsp = noenemies = 1;
        doomed = FALSE;     // No respawning allowed.
    }
    else
    {
        dmsp = noenemies = 0;
        if (deathmatch)
            noenemies = 1;
    }
    if (deathmatch & DM_MONSTERS)
        noenemies = 0;

    // More precaches.
    if (dmsp)
    {
        DMSP_precaches ();
        // We can't use worldspawn or starts as a countdown entity because
        // the latter removes itself when finished.  So we need to spawn an
        // entity for the countdown.
        newmis = spawn();
        newmis.cnt = 10;
        SUB_Think (newmis, DMSP_countdown);
    }

    if (gamemode & GM_AGGRO)    // Was (cvar("nomonsters") & 1)
        angry_monsters = TRUE;
    if (gamemode & GM_DECAY)    // Was (cvar("nomonsters") & 2)
        corpse_removal = TRUE;

    maphack ();     // Call after setting gamemode.
//- - - - - - - - -

// other important stuff
    lightstyle_setup ();

    PlayerIndex ();     // Must precache files before calling this.
};


//==========================================================================
//
//  GAME RULES
//
//==========================================================================

//============
// Go to the next level for deathmatch.
// Only called if a time or frag limit has expired.
//============
void() NextLevel =
{
    if (gameover)       // Make sure this is called only once per level.
        return;         // Rules can be checked multiple times per frame.

    local   entity  newlevel;

    if (mapname == "start")
    {
        if (!cvar("registered"))
            {mapname = "e1m1";}
        else if (!(serverflags & 1))
            {mapname = "e1m1";  serverflags = serverflags | 1;}
        else if (!(serverflags & 2))
            {mapname = "e2m1";  serverflags = serverflags | 2;}
        else if (!(serverflags & 4))
            {mapname = "e3m1";  serverflags = serverflags | 4;}
        else if (!(serverflags & 8))
            {mapname = "e4m1";  serverflags = serverflags - 7;}

        newlevel = spawn();
        newlevel.map = mapname;
    }
    else
    {
        // find a trigger changelevel
        newlevel = find(world, classname, "trigger_changelevel");

        // go back to start if no trigger_changelevel
        if (!newlevel)
        {
        // SoE:  In case we need to spawn a trigger like in dmsp maps.
            if (IsEmptyString (mapname))
                mapname = "start";
            newlevel = spawn();
            newlevel.map = "start";
//- - - - - - - - -
//            mapname = "start";
//            newlevel = spawn();
//            newlevel.map = mapname;
        }
    }

    nextmap = newlevel.map;
    gameover = TRUE;
    
    newlevel.think     = execute_changelevel;
    newlevel.nextthink = time + 0.1;
};

float   timelimit;
float   fraglimit;

// Below is a stripped down version of CheckRules.
// Called once per frame instead of once per client per frame.
void() DeathmatchRules =
{
// Assume 'gameover' was checked for elsewhere (in StartFrame).

// Check timelimit.
    timelimit = cvar("timelimit") * 60;

    if (deathmatch)
        if (!dmsp)      // SoE:  Not in dmsp.
            if (timelimit <= 0)
                timelimit = 600;    // Default:  10 minutes.

    if (timelimit)
        if (time >= timelimit)
        {   NextLevel (); return;   }

// Set fraglimit.  (Check fraglimit in 'PlayerPreThink'.)
    fraglimit = cvar("fraglimit");

// Fraglimit check code commented out.
//    local   float   f;
//
//    f = fraglimit;
//    fraglimit = cvar("fraglimit");
//    if (fraglimit)
//        if (f != fraglimit)
//    {
//        local   entity  e;
//        e = find (world, classname, "player");
//        while (e)
//        {
//            if (e.frags >= fraglimit)
//            {   NextLevel (); return;   }
//            e = find (e, classname, "player");
//        }
//    }
};

// Called by 'PlayerPreThink'.
float() WinFraglimit =
{
    // 'gameover' will be checked elsewhere.

    // 'self' = the client from whom this function was called.
    if (fraglimit)
    {
        if (gameover)
            return TRUE;    // So players don't die from drowning or lava.
        if (self.frags >= fraglimit)
        {   NextLevel (); return TRUE;  }
    }
    return FALSE;   // Fraglimit not reached -- continue the game.
};

//==========================================================================
//
//  PHYSICS
//
//==========================================================================

//============
// This searches all the entities for monsters to do pre-thinking stuff.
// After this, the C code will loop through all entities again to do
// physics and think code.  I am not happy with the double loop, but
// this is the only way to do this with QuakeC alone.
// (I don't want to mess with the source itself to create a new engine,
// especially with multiple recognized custom engines such as FitzQuake,
// Darkplaces, and Bengt's numerous ports.)
//
// 4/27/2009:  With the way things are going, I might need to build a
// custom engine of my own to add things I really want, such as custom
// status bar and particle effects, for Drake and Tronyn's merger.
//============
void() WorldScan =
{
    local   entity  e;

// Apply environmental effects to all NPCs and items.
// Think of it as the monsters' version of PlayerPreThink.
    e = nextent (world);
    while (e)
    {
        if (e.flags & FL_MONSTER)
        {
            if (e.modelindex)   // If zero, treat as non-existant.
            {
                if (!(e.xfl & XFL_NO_SCAN))
                {
                    WaterSwim (e);
// FIXME:  FitzQuake crashes if too much code is called.
// Rip commented code and its references in other files out!
                    Burn_Check (e);
//                    Poison_Check (e);
                    Divine_Check (e);   // Divine attack!
                    Regen_Check (e);    // Check *after* harmful effects.
                    CheckArtifacts (e);
                // If inside a solid wall, kill it!  Do this last!
                    if (e.h2otype == CONTENT_SOLID)
                    if (e.movetype != MOVETYPE_NOCLIP)
                    if (pointcontents (e.origin) == CONTENT_SOLID)
                    if (pointcontents (e.absmin) == CONTENT_SOLID)
                    if (pointcontents (e.absmax) == CONTENT_SOLID)
                        T_Kill (e, world, world, -999, "noclip");
                }
            }
        }
        else
            Burn_Check (e);     // For barrels and shootable brushes.

        e = nextent(e);
    }
};

//============
// One of the 'Big 10' must-have functions.  Called when the world thinks,
// before physics code and even before 'PlayerPreThink'.
//============
void() StartFrame =
{
// Standard Quake never uses 'framecount'.
// In Drake, we borrow it to perform various tasks once per anim frame.
    if (framecount <= time)
    {
    //- - - - - - - - -
    // All global strings are no longer null after reloading a savegame.
        if (reloaded)
        {   // Someone reloaded a save game.  A savescummer?
            // Replay music, and reset counters.
//            dprint ("quickload detected.\n");
            if (stereo1)
                {stereo1.lefty = 1;  PlayMusic (stereo1.noise, stereo1.wait);}
            reloaded = world.null_string;
            reload_count = reload_count + 1;
        }
    //- - - - - - - - -
        Align_Next ();      // Advance the hitlists.
        WorldScan ();
        LightZero_Go ();
        framecount = time + 0.1;    // Standard animation is 10 FPS.
    }

    BotFrame ();    // FrikBot

    if (gameover)   // Someone else quit the game already
        return;     // No use checking other rules now.

    DMSP_monsterspawner ();

// Must check for players because server will crash if it tries to change
// the level while no clients are connected to the server.
    if (find (world, classname, "player"))
        DeathmatchRules ();     // Check rules only if we've clients to serve.
};


//===========================/  END OF FILE  /===========================//
