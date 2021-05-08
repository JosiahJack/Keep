//==========================================================================
//  hack.qc
//--------------------------------------------------------------------------
//  Used by Drake and derivatives to insert entities into various maps,
//  namely those in Tronyn's projects.
//==========================================================================

//==========================================================================
//  Merger Hacks

// Called from within 'Arcanum1_Hack' below.
void(vector spot) Arcanum1_Gibs =
{
    self = spawn();
    setorigin (self, spot);
    self.classname = "misc_gibft";
    self.targetname = "exitbars";
    self.speed = 400;
    misc_gibft();
};

// FIXME:  Get Tronyn to fix the map before final release!
void() Arcanum1_Hack =
{
    local   entity  e;
    
    e = self;
    
    self = spawn();
    setorigin (self, '-1024 -3968 928');
    self.mangle = '2048 3544 96';
    self.count = 400;   //Was 300;
    self.spawnflags = 1;
    self.classname = "func_rain_point";
    func_rain_point();
    
//    self.dest1 = '-36 -1884 -160';
//    self.dest2 = '246 -1828 0';
    self = spawn();
    setorigin (self, '-36 -1884 -160');
    self.mangle = '270 56 160';
    self.target = "zap";
    self.classname = "trigger_once_point";
    trigger_once_point();
    
    self = spawn();
    setorigin (self, '-36 -1884 -160');
    self.targetname = "zap";
    self.message = "Use hand-to-hand combat\nto slay the living dead.";
    self.classname = "trigger_smite";
    trigger_smite();
    
    Arcanum1_Gibs ('272 -256 -344');    // z was -384.
    Arcanum1_Gibs ('240 -256 -344');
    Arcanum1_Gibs ('256 -272 -344');
    
    self = e;
};

//- - - - - - - - -
// For unforgiven2.
void(vector spot, vector bbox, float den) Add_Snow =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, spot);
    ent.mangle = bbox;
    ent.count = den;
    ent.classname = "func_snow_point";
    SUB_Think (ent, func_snow_point);
};


//==========================================================================
//  Nsoe1 Critter Hack

// nsoe1 hack:  Non-evil critter.
// Originally a gremlin, but none of the walkmonsters can climb the stairs
// toward the exit, so now it is a ghost awakened from its slumber.
void()  Nsoe1_Critter =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, '288 -400 144');
    ent.angles = '0 90 0';
    ent.targetname = "critter2";
    ent.spawnflags = SPAWN_WHITE | 64;
    ent.xf2 = XF2_CLONE;
    ent.netname = "the Ghost of Mazarbul";
    ent.message = "Evil has defiled my chambers!\nI shall aid thee, Baneslayer.";
    ent.classname = "monster_wraith";
    SUB_Think (ent, monster_wraith);

// Update:  While we're at it, add intermission points.
    ent = spawn();
    setorigin (ent, '464 492 64');
    ent.mangle = '10 205 0';
    ent.classname = "info_intermission";

    ent = spawn();
    setorigin (ent, '-544 -416 -64');
    ent.mangle = '-5 45 0';
    ent.classname = "info_intermission";
};


//==========================================================================
//  Nsoe2 Boss/Hellgate Hack

void() hellgate_end =
{
    local   entity  e;

    e = find (world, classname, "misc_glitter");
    if (e)
        e.count = 244;  // Change to clear blue.
    Mass_Centerprint ("The dragon has been slain!\n\nThe rebels reclaim their city.");
    sound (self, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NONE);

    self.use        = SUB_Null;
    self.targetname = world.null_string;
    self.nextthink  = time + 0.1;
    self.think      = SUB_Remove;
};

void() hellgate_spawn =
{
    local   entity  e;
    local   float   hits;

    hits = 0;
    e = find (world, classname, "monster_imp");
    while (e)
    {
        if (e.spawned)
            if (!e.master)      // Ignore those summoned by player.
                hits = hits + 1;
        e = find (e, classname, "monster_imp");
    }
    if (hits > self.count)
    {   // Too many spawned on the map.  Try again later.
        self.nextthink = time + 3;
        return;
    }

    activator = self.enemy = NextPlayer(self.enemy);
    if (activator.flags & FL_NOTARGET)
        activator = world;
    SUB_UseTargets ();
    self.nextthink = time + 20;     // Four imps, one per five seconds.
};

void() hellgate_idle =[ 0, hellgate_idle ]
{
    local   float   alert;

    if (cutscene)
    {
        if (!self.lefty)    // If TRUE, save time until cutscene ends.
            {self.lefty = 1;  self.wait = self.wait - time;}
        return;     // Because cam is high in the sky.
    }
    if (self.lefty)
    {   // Was in a cutscene, so restore timers.
        self.lefty = 0;
        self.wait = self.wait + time;
        self.height = self.wait - 120;
    }

    alert = 0;
    if (self.wait < time)
    {   Mass_Centerprint ("You had better hurry!");
        alert = 1;      // Time's up, get the player moving.
    }
    if (self.enemy.origin_z >= 152)     // Was 128.
        if (self.enemy.flags & FL_ONGROUND)
        {   Mass_Centerprint ("Enemy reinforcements arrive.");
            alert = 1;      // Player made it to the roof top.
        }
    if (self.owner.health > 0)
        if (self.owner.health <= self.owner.max_health / 2)
        {
            sound (self.owner, CHAN_VOICE, "dragon/idle1.wav", 1, 0.5);
            Mass_Centerprint ("The dragon summons help!");
            alert = 1;      // Boss is really mad now, so summon help.
        }

    if (alert)
    {   // Operation Imp Storm GO!
        sound (self, CHAN_AUTO, "misc/bell.wav", 1, 0.2);
//        if (self.owner.spawnflags & 64)     // Should be FALSE now.
//            if (self.owner.use)
//                SUB_Think (self.owner, self.owner.use);   // Wake the dragon!
        self.think = hellgate_spawn;
        hellgate_spawn();
        return;
    }
    if (self.height < time)
    {   // Warn player of impeding doom.
        local   entity  pl;

        pl = find (world, classname, "player");
        while (pl)
        {   // Taking a hint from Nethack's Wizard of Yendor code...
            sprint (pl, "You feel vaguely nervous.\n");
            pl = find (pl, classname, "player");
        }
        self.height = self.height + 60;   // Another warning after a minute.
    }
    self.enemy = NextPlayer(self.enemy);
};

// Ring bell then set up hellgate for imp storm.
void() hellgate_use =
{
//    local   entity  e;
//    e = find (world, classname, "misc_glitter");
//    if (e)  e.count = 145;  // Change from blue to purple.

    sound (self, CHAN_AUTO, "misc/bell.wav", 1, 0.2);

    self.lefty      = 0;            // Not in cutscene yet.
    self.wait       = time + 180;   // Three minutes before imps come anyway.
    self.height     = self.wait - 120;  // Warning after one minute.
    self.use        = SUB_Null;
    self.enemy      = NextPlayer(world);
    self.nextthink  = time + 0.1;
    self.think      = hellgate_idle;
};

// Ring bell then disappear.
void() hellgate_easy =
{
    sound (self, CHAN_AUTO, "misc/bell.wav", 1, 0.2);
    // Can't remove now because we are in usetargets loop.
    self.targetname = "";
    self.use        = SUB_Null;
    self.nextthink  = time + 0.1;
    self.think      = SUB_Remove;
};

void() Nsoe2_Hellgate =
{
    if (deathmatch || dmsp)
        return;

    local   entity  ryu;
    local   entity  ent;
    local   float   sklv;

    sklv = cvar("skill");
    sklv = floor(sklv);

// Dragon and its path corners.
// Update:  New path for dragon with alternate wyrm ai.
    ent = spawn();
    setorigin (ent, '-1440 96 588');
    ent.classname = "path_corner";
    ent.targetname = "boss_path1";
    ent.target = "boss_path2";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-1440 800 588');
    ent.classname = "path_corner";
    ent.targetname = "boss_path2";
    ent.target = "boss_path3";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-504 800 588');
    ent.classname = "path_corner";
    ent.targetname = "boss_path3";
    ent.target = "boss_path4";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-504 -960 588');
    ent.classname = "path_corner";
    ent.targetname = "boss_path4";
    ent.target = "boss_path5";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '544 -960 588');    // FIXME:  z = 460 from here?
    ent.classname = "path_corner";
    ent.targetname = "boss_path5";
    ent.target = "boss_path6";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '544 -416 588');
    ent.classname = "path_corner";
    ent.targetname = "boss_path6";
    ent.target = "boss_path7";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-928 -416 588');
    ent.classname = "path_corner";
    ent.targetname = "boss_path7";
    ent.target = "boss_path1";
    SUB_Think (ent, path_corner);


    ent = spawn();
    setorigin (ent, '-1440 -760 588');
    ent.angles = '0 90 0';
    ent.spawnflags = 64;
    ent.targetname = "plat";
//    ent.targetname = "boss";    // Was "plat".
    ent.target = "boss_path1";
    ent.target2 = "boss_end";
    ent.killtarget = "hellgate";
    ent.style = 1;
    ent.classname = "monster_dragon_wyrm";
    SUB_Think (ent, monster_dragon_wyrm);   // Full-sized dragon, at last!
    ryu = ent;

    ent = spawn();
    setorigin (ent, '-1440 -760 512');
    ent.use = hellgate_end;
    ent.targetname = "boss_end";

// Hellgate:  Imp spawner.
// FIXME:  Add proper horde spawner to reduce edicts needed.
    precache_sound ("misc/bell.wav");

    ent = spawn();
    setorigin (ent, '-1440 -760 512');
    ent.owner = ryu;        // All your bases are belong to dragon.
    ent.targetname = "plat";
    if (sklv < 1)
    {   // On Easy, just ring the bell then disappear when used.
        ent.use = hellgate_easy;
        return;
    }
    ent.target = "hellgate";
    ent.use = hellgate_use;
    ent.wait = 20;
    // Imps spawn four at a time.  Don't spawn more if enough have spawned.
    ent.count = sklv * 4 - 2;   // Norm=2, Hard=6, NM=10.

    // Note:  Spawn points are above the braziers.
    ent = spawn();
    setorigin (ent, '-1360 -664 512');
    ent.angles = '0 45 0';
    ent.spawnmulti = ent.spawnsilent = 1;
    ent.spawnclassname = "monster_imp";
    ent.spawnfunction = monster_imp;
    ent.targetname = "hellgate";
    ent.target = "imp_path1";       // Just move off the brazier when idle.
    ent.classname = "func_spawn";
    SUB_Think (ent, func_spawn);

    ent = spawn();
    setorigin (ent, '-1520 -664 512');
    ent.angles = '0 135 0';
    ent.spawnmulti = ent.spawnsilent = 1;
    ent.spawnclassname = "monster_imp";
    ent.spawnfunction = monster_imp;
    ent.targetname = "hellgate";
    ent.target = "imp_path2";       // Just move off the brazier when idle.
    ent.classname = "func_spawn";
    SUB_Think (ent, func_spawn);

    ent = spawn();
    setorigin (ent, '-1520 -856 512');
    ent.angles = '0 225 0';
    ent.spawnmulti = ent.spawnsilent = 1;
    ent.spawnclassname = "monster_imp";
    ent.spawnfunction = monster_imp;
    ent.targetname = "hellgate";
    ent.target = "imp_path3";       // Just move off the brazier when idle.
    ent.classname = "func_spawn";
    SUB_Think (ent, func_spawn);

    ent = spawn();
    setorigin (ent, '-1360 -856 512');
    ent.angles = '0 315 0';
    ent.spawnmulti = ent.spawnsilent = 1;
    ent.spawnclassname = "monster_imp";
    ent.spawnfunction = monster_imp;
    ent.targetname = "hellgate";
    ent.target = "imp_path4";       // Just move off the brazier when idle.
    ent.classname = "func_spawn";
    SUB_Think (ent, func_spawn);

// Path corners for spawned imps.
    ent = spawn();
    setorigin (ent, '-1120 -340 512');
    ent.classname = "path_corner";
    ent.targetname = "imp_path1";
    ent.target = "imp_path2";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-1760 -340 512');
    ent.classname = "path_corner";
    ent.targetname = "imp_path2";
    ent.target = "imp_path3";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-1760 -1168 512');
    ent.classname = "path_corner";
    ent.targetname = "imp_path3";
    ent.target = "imp_path4";
    SUB_Think (ent, path_corner);

    ent = spawn();
    setorigin (ent, '-1120 -1168 512');
    ent.classname = "path_corner";
    ent.targetname = "imp_path4";
    ent.target = "imp_path1";
    SUB_Think (ent, path_corner);
};


//==========================================================================
//  Nsoe2 Cutscene Hack

void() cam_use_hack =
{
    local   entity  oo;

    oo = other;
    other = activator;
    camera_touch ();
    other = oo;
};

// Cutscene hack to show player where the stairs are.
// Spawn the entities needed to setup the cutscene.
void() Nsoe2_Cutscene =
{
    if (deathmatch || coop || dmsp)
        return;     // No cutscenes allowed in these modes.

    local   entity  ent;
    local   vector  p1, p2;

//    ent = spawn();
//    setsize (ent, '288 -2048 -272', '580 -1660 768');
//    ent.solid = SOLID_BBOX;

    p1 = '1246 -432 256';
    p2 = '1194 -432 228';   // Was '1100 -432 320'

    ent = spawn();
    setorigin (ent, p1);
    ent.targetname = "plat";
    ent.target = "camera1";
    ent.script = "1";
    ent.script_delay = 1;
    ent.focal_point = "zer_fp1";
    ent.cnt = 0;
    ent.nextthink = 10000000;
    ent.use = cam_use_hack;

    ent = spawn();
    setorigin (ent, p2);
    ent.message = "Stairs above the\nsilver door have risen.";
    ent.next_script = "2";
    ent.script_num = "1";
    ent.script_delay = 3;   // Three seconds.
    ent.targetname = "zer_fp1";
    ent.classname = "info_script";
    SUB_Think (ent, info_script);

    ent = spawn();
    setorigin (ent, p2);
    ent.message = "Beware the dragon!";
    ent.next_script = "0";
    ent.script_num = "2";
    ent.script_delay = 2;   // Two seconds.
    ent.classname = "info_script";
    SUB_Think (ent, info_script);

    ent = spawn();
    setorigin (ent, p1);
    ent.mangle = '30 180 0';    // Vision style.
    ent.targetname = "camera1";
    ent.classname = "info_movie_camera";
    SUB_Think (ent, info_movie_camera);
};

// nsoe2 hack:  Rebel fighters!
void(vector spot, float yaw, string eclass, void() efunc, string tname,
    string text)  Add_Rebel =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, spot);
    ent.angles = '0 0 0';
    ent.angles_y = yaw;

    if (eclass == "monster_thug")
    {   ent.ryuflags = ent.ryuflags | RYU_REBEL;
        ent.health = 300;   // Give old health back to thug rebels.
    }
    ent.spawnflags = SPAWN_WHITE;
    ent.message = text;
    if (!IsEmptyString(tname))
    {
        ent.targetname = tname;
        if (tname == "gl1")
            ent.spawnflags = ent.spawnflags | 64;
        else
            ent.spawnflags = ent.spawnflags | 32;
    }

    ent.classname = eclass;
    SUB_Think (ent, efunc);
};


//==========================================================================
//  Miscellaneous

void(vector spot, float yaw, string tname, string emdl, string esfx,
    string ename, float etype, float mx)  Add_Summon =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, spot);
    ent.angles = '0 0 0';
    ent.angles_y = yaw;
    ent.spawnflags = 0;
    if (world.model == "maps/nsoe2.bsp")
        ent.target = "horn";
    if (!IsEmptyString(tname))
    {
        ent.targetname = tname;
        ent.spawnflags = ent.spawnflags | 64;
    }
    ent.mdl = emdl;
    ent.noise = esfx;
    ent.netname = ename;
    ent.worldtype = etype;
    ent.cnt = mx;
    ent.classname = "item_artifact_monster";
    SUB_Think (ent, item_artifact_monster);
};

void(vector spot, float yaw, string t1, string t2, string t3,
    string t4, string t5, string t6)  Add_BookEx =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, spot);
    ent.angles = '0 0 0';
    ent.angles_y = yaw;
    ent.spawnflags = 0;
    ent.page1 = t1;
    if (!IsEmptyString (t2))
    {
        ent.page2 = t2;
        if (!IsEmptyString (t3))
        {   ent.page3 = t3;
            if (!IsEmptyString (t4))
            {   ent.page4 = t4;
                if (!IsEmptyString (t5))
                {   ent.page5 = t5;
                    if (!IsEmptyString (t6))
                        ent.page6 = t6;
                }
            }
        }
    }
    ent.classname = "item_book";
    SUB_Think (ent, item_book);
};
void(vector spot, float yaw, string text)  Add_Book =
    {Add_BookEx (spot, yaw, text, "", "", "", "", "");};

void() Add_LogOfEkard =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, '-1104 768 -208');
    ent.angles = '0 270 0';
    ent.spawnflags = 0;
//    ent.page4 = "Äáù ¶°º Weapons of otherworldly origin\narrived mysteriously in the tower. One\nof them came with a strange tome, which\nI ordered to be placed in the dungeon.";
    ent.page1 = "The Log of Lord Ekard\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©";
    ent.page2 = "Äáù µ°º The Sha'Vile summoned by our\nShal-Rath allies has been a real pain\nin the ass! Every week, I lose one or\nmore of my men to that vile fiend.";
    ent.page3 = "However, it is a great executioner,\nand the terror it creates helps keep\nthe locals and some of the more seedy\nsoldiers among our ranks in line.";
    ent.page4 = "Äáù ¶·º I had the dubious pleasure of\nassigning Acnirt for guard duty in the\ndungeon. That shifty slacker always\nhad a weakness for gambling.";
    ent.page5 = "I don't care what the wager was or who\nelse was involved, but I need men in\nthat hellhole and Acnirt is as good as\nany. It will do him good, if he lives.";
    ent.page6 = "Äáù ¶¸º This wretched rebellion began\never since the people began shouting\nthe name of their legendary hero whom\nthey call the 'Baneslayer'.";
    ent.page7 = "For the past few days, the rebel scum\nhave attacked our army. All prisoners\nwe take and send to the dungeon for\nexecution speak of Baneslayer's return.";
    ent.page8 = "Äáù ¶¹º We must find and destroy this\n'Baneslayer' before the rebellion gets\nout of control. Perhaps we should send\nfor the dragon to burn the city.";

    ent.classname = "item_book";
    SUB_Think (ent, item_book);
};

void() Add_Reflector =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, '1232 -2144 -424');
    ent.angles = '0 180 0';
    ent.spawnflags = 0;
// Hard to see, so highlight with a force field.
    ent.effects = EF_BRIGHTFIELD;

    ent.classname = "item_artifact_reflection";
    SUB_Think (ent, item_artifact_reflection);
};

void(vector spot, float yaw, float sf, string tname,
    string eclass, void() efunc) Add_EntEx =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, spot);
    ent.angles = '0 0 0';
    ent.angles_y = yaw;
    ent.spawnflags = sf;
    if (!IsEmptyString (tname))
    {
        ent.targetname = tname;
        ent.spawnflags = ent.spawnflags | 64;
        // If imp/golem statue, undo sf64.
        if (sf & SPAWN_STATUE)
        {
            if ((efunc == monster_imp) || (efunc == monster_golem))
                ent.spawnflags = ent.spawnflags - 64;
//            if (efunc == monster_imp_ice)
//                ent.spawnflags = ent.spawnflags - 64;
        }
    }
    ent.classname = eclass;
    SUB_Think (ent, efunc);
};

void(vector spot, float yaw, string eclass, void() efunc) Add_DmspBoss =
{
    if (dmsp)
    {
        local   entity  ent;

        ent = spawn();
        setorigin (ent, spot);
        ent.angles = '0 0 0';
        ent.angles_y = yaw;
        ent.spawnclassname = eclass;
        ent.spawnfunction = efunc;
        ent.targetname = "DMSP_boss";
        ent.classname = "func_spawn";
        SUB_Think (ent, func_spawn);
    }
};

void(vector spot, float yaw, float sf, string tname, float sklv) Add_Imp =
{
    if (cvar("skill") < sklv)
        tname = world.null_string;
    Add_EntEx (spot, yaw, sf | SPAWN_STATUE, tname, "monster_imp", monster_imp);
};
void(vector spot, float yaw, float sf, string tname, float sklv) Add_Statue =
{
    if (cvar("skill") < sklv)
        tname = world.null_string;
    Add_EntEx (spot, yaw, sf | SPAWN_STATUE, tname, "monster_golem", monster_golem);
};

void(vector spot, float yaw, string eclass, void() efunc) Add_Ent =
    {Add_EntEx (spot, yaw, 0, world.null_string, eclass, efunc);};

void(vector spot, float yaw) Add_DmStart =
    {Add_Ent (spot, yaw, "info_player_deathmatch", info_player_deathmatch);};

//void(vector spot, float yaw, string eclass, void() efunc) Add_Chest =
//{
//    local   entity  ent;
//
//    ent = spawn();
//    setorigin (ent, spot);
//    ent.angles = '0 0 0';
//    ent.angles_y = yaw;
//    ent.spawnclassname = eclass;
//    ent.spawnfunction = efunc;
//    ent.classname = "misc_chest";
//    SUB_Think (ent, misc_chest);
//};

void() item_potion_soe =
{
    self.healamount = 5;
    self.skin = 1;
    item_potion ();
};


//==========================================================================

void() maphack =
{
    local   float   sklv;

    sklv = cvar("skill");
// SOUL OF EVIL: INDIAN SUMMER
    if (world.model == "maps/nsoe1.bsp")
    {
        Add_DmStart ('-672 512 152', 270);
        Add_DmStart ('-672 224 344', 270);
        Add_DmStart ('-96 992 -40', 270);
        Add_DmStart ('432 32 -40', 180);
        Add_DmStart ('576 -352 56', 90);
        Add_DmStart ('704 -128 216', 180);
        Add_DmStart ('-736 -224 -104', 45);
        Add_DmStart ('-736 928 24', 315);
        if (coop)
        {   // No coop spots -- add them!
            Add_Ent ('-32 96 -104', 270, "info_player_coop", info_player_coop);
            Add_Ent ('-160 96 -104', 270, "info_player_coop", info_player_coop);
            Add_Ent ('-32 32 -104', 270, "info_player_coop", info_player_coop);
            Add_Ent ('-160 32 -104', 270, "info_player_coop", info_player_coop);
        }
// DISABLED -- Book is obsolete.
//        Add_BookEx ('-736 928 24', 315,         //(Press / to turn page.)
//            "The Book of Swords\nWritten by grandmaster Elffiwz.\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©",
//            "Chapter 1: The Art of Fencing\n\nMaster swordsmen are known to redirect\nmissile fire with a well-timed swing.",
//            "Chapter 2: Legendary Swords\n\nMany swords of legendary power were\nforged since the dawn of time.",
//            "One such weapon is the Vorpal Blade.\nIts unmatched sharpness allows it to\nsever heads cleanly from the body or to\ncleave the bodies of the walking dead.",
//            "", "");
        Add_Book ('-96 928 120', 270, "These chambers were built by the once\ngreat mage Mazarbul. Legend has it\nhis ghost still haunts his chambers,\npunishing the unworthy and the wicked.");
        Add_BookEx ('18 -146 152', 0,
            "The Book of Artifacts, Vol. 2\nWritten by archmage Mazarbul.\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©",
            "Chapter 1: Twin shot\n\nTwin shot allows the wielder to use\none spike to fire two.",
            "Chapter 2: Boots of Levitation\n\nInstead of jumping, the wearer may defy\ngravity by force of will... for a time.",
            "Chapter 3: Amulet of Reflection\n\nThis talisman repels incoming missile\nfire, but not hand-to-hand combat.",
            "Chapter 4: Rejuvenator\n\nThis triangular rune accelerates\none's natural healing.",
            "Chapter 5: Heart of Darkness\n\nShaped as a heart, this rune augments\nmaximum health. At first by 125%.");
        Add_Book ('-672 224 344', 270, "Years ago, a stranger from beyond\nsaved our land from the wicked Bane\nand the vile Shal-Rath Cult.\nWe call our savior the 'Baneslayer'.");
        Add_Ent ('160 -224 -72', 0, "misc_wanted", misc_wanted);
        Add_Ent ('320 832 56', 0, "misc_wanted", misc_wanted);      //'-768 928 56', 180
        Add_Ent ('-640 960 216', 90, "misc_wanted", misc_wanted);
        Add_Ent ('832 -64 24', 90, "misc_wanted", misc_wanted);
        Add_Ent ('704 -192 248', 270, "misc_wanted", misc_wanted);

        Add_Ent ('-96 -672 216', 0, "info_teleport_nsoe1", teleport_setup);
        if ((sklv <= 1) || deathmatch)
        {
            Add_Ent ('-672 -160 -104', 270, "item_artifact_super_damage", item_artifact_super_damage);
            if (deathmatch)
            {
                Add_Ent ('-640 928 184', 270, "weapon_proximity_gun", weapon_proximity_gun);
                Add_Ent ('-96 416 344', 270, "weapon_grenadelauncher", weapon_grenadelauncher);
            }
            else if (!sklv)
            {
                Add_Ent ('-640 928 184', 270, "item_artifact_regeneration", item_artifact_regeneration);
                Add_Ent ('832 -128 -8', 270, "item_artifact_invulnerability", item_artifact_invulnerability);
            }
        }
        if (sklv >= 1)
        {   // x-648-696, y224.
            Add_Ent ('-624 32 -104', 270, "monster_army", monster_army);
            Add_Ent ('-672 32 -104', 270, "monster_army", monster_army);
            Add_Ent ('-720 32 -104', 270, "monster_army", monster_army);
            if (sklv >= 2)
                Add_Ent ('-530 942 24', 270, "monster_axeman", monster_axeman);
        }
    // If wand didn't push monsters, it would be a fine substitute.
        Add_Ent ('80 -240 152', 90, "item_artifact_equalizer", item_artifact_equalizer);
        Add_Ent ('528 208 -104', 0, "item_cells", item_cells);
        Add_Ent ('600 208 -104', 0, "item_cells", item_cells);
        Add_Ent ('688 176 216', 0, "item_health", item_health);   // Gold key
        Add_Ent ('-544 608 24', 0, "item_treasure_coin", item_treasure_coin);
        Add_Ent ('-544 672 24', 0, "item_treasure_coin", item_treasure_coin);
        Add_Ent ('-736 928 184', 270, "misc_chest", misc_chest);
        Add_Ent ('576 224 -104', 270, "weapon_blaster", weapon_blaster);
        Nsoe1_Critter ();
        return;
    }
    if (world.model == "maps/nsoe2.bsp")
    {   // There are MANY additions.
        temp_goal.message = "You hear whispers of a\n\"resistance movement\".";
    // Spawnpoints!
        // Nsoe2 has one dm spot.  Add 15 more.
        Add_DmStart ('-1600 0 -248', 0);
        Add_DmStart ('-1600 -512 -248', 0);
        Add_DmStart ('-1104 -888 -248', 0);
        Add_DmStart ('-1040 192 -72', 0);
        Add_DmStart ('-498 -704 -72', 90);  //'-504 -704 -72'
        Add_DmStart ('-408 -888 -72', 0);
        Add_DmStart ('-400 592 -248', 0);
        Add_DmStart ('-368 -112 -72', 270);
        Add_DmStart ('-336 -528 -248', 180);
        Add_DmStart ('-160 -416 -72', 0);
        Add_DmStart ('64 -96 -72', 90);
        Add_DmStart ('64 -496 -248', 90);
        Add_DmStart ('528 -16 -72', 90);
        Add_DmStart ('624 -128 -72', 270);
        Add_DmStart ('880 -688 -248', 180);
    // Dmsp boss.
        Add_DmspBoss ('-1440 -760 588', 0, "monster_dragon", monster_dragon);   //z=(472, 704)
    // Functions.
        Nsoe2_Hellgate ();      // Dragon and imp spawner.
        Nsoe2_Cutscene ();
    // Barrier to prevent entry into bugged section of map.
        Add_Ent ('312 -1692 -248', 90, "misc_tree", misc_tree);
        Add_Ent ('368 -1692 -248', 0, "misc_tree", misc_tree);
        Add_Ent ('424 -1692 -248', 180, "misc_tree", misc_tree);
        Add_Ent ('480 -1692 -248', 180, "misc_tree", misc_tree);
        Add_Ent ('536 -1692 -248', 270, "misc_tree", misc_tree);
    // Books in likely order of them read.
        Add_Ent ('64 -544 -216', 270, "misc_wanted", misc_wanted);
        Add_Ent ('64 -832 -216', 90, "misc_wanted", misc_wanted);
        // Removed wanted at '-1664 0 -216', 180, because it's too bright.
        Add_Book ('-488 -368 -208', 270, "The ogres took the best loot and hid\nthem in a secret vault. One of them\ncarries the sacred rune of power.\nCurse those filthy greedy bastards!");
        Add_Book ('-1660 -468 -56', 0, "On the roof of this clock tower is\na magical gate where beings can\ntransport into or out of this city.");
// DISABLED -- Book is obsolete.
//        Add_BookEx ('-498 -704 -72', 90,
//            "Mjolnir\nHammer of Thor\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©",
//            "Verse 1: Way of God\n\nOnly with precise timing can one\ncontrol the divine power of Mjolnir.",
//            "Verse 2: Wrath of God\n\nThose who wield Mjolnir in battle\nmay summon storms to smite evil.",
//            "Verse 3: Will of God\n\nHeaven and earth will tremble when\nMjolnir slams the ground precisely.",
//            "Verse 4: Hand of God\n\nBeings of legendary power can throw\nthe mighty hammer at their foes.",
//            "Whether by skill or divine will,\nMjolnir always hits its mark, and\nstrikes with such force that it often\nslays its target and those nearby.");
        Add_Book ('848 232 -208', 270, "Soul of Evil: Twilight Autumn\nA Fantasy Role-Playing Game\n\nPlay as a knight, archer, or mage!");
        Add_BookEx ('-480 -1040 -248', 270,
            "Acnirt's Log\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©",
            "Äáù ¶·º I lost a bet today and must\npay up 30 qubits and spend a week of\nguard duty with that black... thing in\nthe dungeon. I heard all of the...",
            "horror stories. The beast from Hell,\ncalled the Sha'Vile, loves to mutilate\nanyone it can get its vile claws on.\nI am not looking forward to this.",
            "Äáù ¶¸º The baron brought in several\nrebel prisoners. What the beast did to\nthem was too gruesome to behold -\nIt played catch with the prisoners...",
            "by casting balls of hellfire at them!\nTwo of our guards got in the way and\nwere burnt beyond recognition. Their\nhorrid screams only amused the beast.",
            "Äáù ¶¹º That black devil ate one of\nour guards and mutilated two more!\nI'll be damned if I stay here for\nguard duty another day!");
// DISABLED -- Ekard's log is now 8 pages, and called specially.
//        Add_BookEx ('-1104 768 -208', 270,
//            "The Log of Lord Ekard\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©",
//            "Äáù µ°º The Sha'Vile summoned by our\nShal-Rath allies has been a real pain\nin the ass! Every week, I lose one or\nmore of my men to that vile fiend.",
//            "However, it is a great executioner,\nand the terror it creates helps keep\nthe locals and some of the more seedy\nsoldiers among our ranks in line.",
//            "Äáù ¶¸º This wretched rebellion began\never since the people began shouting\nthe name of their legendary hero whom\nthey call the 'Baneslayer'.",
//            "For the past few days, the rebel scum\nhave attacked our army. All prisoners\nwe take and send to the dungeon for\nexecution speak of Baneslayer's return.",
//            "Äáù ¶¹º We must find and destroy this\n'Baneslayer' before the rebellion gets\nout of control. Perhaps we should send\nfor the dragon to burn the city.");
        Add_LogOfEkard ();
        Add_BookEx ('1158 -810 -248', 225,      //1160 -808 -248 '488 -1480 -248', 90,
            "Earth Force Heavy Weapons Manual\nThe MIRV Launcher\n\n¨Ðòåóó ¯ ôï ôõòî ðáçå®©",
            "This big gun launches MIRVs that carry\na payload of five homing rockets.\n\nA MIRV requires 5 rockets to assemble.",
            "Step 1: Press and hold trigger.\n\nThis launches the MIRV.",
            "Step 2: Point launcher at targets.\n\nThis guides the MIRV where to go. It\nalso selects targets for the payload.",
            "Step 3: Release trigger.\n\nThis releases payload warheads,\nwhich will seek their assigned targets.",
            "Guaranteed results, courtesy of Earth\nForce government at taxpayers' expense.\n\nNOW GO AND BLOW SOMETHING UP ALREADY!");

        if (sklv < 2)
            Add_Ent ('64 -1200 -248', 180, "item_artifact_empathy_shields", item_artifact_empathy_shields);
        // The gory horror show courtesy of the Sha'Vile.
        Add_Ent ('488 -1200 -248', 180, "misc_meat", misc_meat);
        Add_Ent ('392 -1264 -184', 180, "misc_meat", misc_meat);
        Add_Ent ('520 -1328 -184', 180, "misc_meat", misc_meat);
        // Crucified zombies behind the Sha'Vile.
        Add_EntEx ('408 -1500 -176', 90, 1, world.null_string, "monster_zombie", monster_zombie);
        Add_EntEx ('568 -1500 -176', 90, 1, world.null_string, "monster_zombie", monster_zombie);

        if (sklv >= 1)
        {
            Add_EntEx ('-1792 -192 -248', 0, 1, world.null_string, "monster_baron", monster_baron); //'-1824 -192 -248'
            Add_EntEx ('-1136 80 -248', 270, 65, "gold", "monster_baron", monster_baron);
            if (sklv >= 2)
                Add_EntEx ('-1016 24 -248', 225, 65, "gold", "monster_archer_lord", monster_archer_lord);
        }
        else
            Add_EntEx ('-1136 80 -248', 270, 65, "gold", "monster_archer_lord", monster_archer_lord);

        if (sklv >= 1)
        {
            Add_EntEx ('-1616 480 152', 315, 64, "plat", "monster_ogre_flak", monster_ogre_flak);
            Add_EntEx ('64 -96 -72', 270, 64, "plat", "monster_ogre_flak", monster_ogre_flak);
            Add_EntEx ('772 48 -72', 180, 64, "plat", "monster_ogre_flak", monster_ogre_flak);
        }
        if (sklv >= 2)
            Add_EntEx ('814 -894 152', 90, 64, "plat", "monster_ogre_flak", monster_ogre_flak);

        if (sklv >= 1)
        {
//            Add_EntEx ('-192 616 152', 270, 65, "plat", "monster_wizard", monster_wizard);
            Add_EntEx ('64 616 152', 270, 65, "plat", "monster_wizard", monster_wizard);
            Add_EntEx ('320 616 152', 270, 65, "plat", "monster_wizard", monster_wizard);
            Add_EntEx ('576 616 152', 270, 65, "plat", "monster_wizard", monster_wizard);
        }
        if (sklv >= 2)
        {   // Update:  Removed the two in the tower.
            // Outside front gate.
            Add_EntEx ('-64 488 24', 270, 65, "plat", "monster_wizard", monster_wizard);
            Add_EntEx ('192 488 24', 270, 65, "plat", "monster_wizard", monster_wizard);
            Add_EntEx ('448 488 24', 270, 65, "plat", "monster_wizard", monster_wizard);
        }
        // By stairs to roof.
        Add_EntEx ('1256 -896 56', 90, 65, "plat", "monster_wizard", monster_wizard);
        if (sklv >= 1)
            Add_EntEx ('1256 -896 194', 90, 65, "plat", "monster_wizard", monster_wizard);
        if (sklv >= 2)
            Add_EntEx ('1256 -896 322', 90, 65, "plat", "monster_wizard", monster_wizard);

        Add_Imp ('-1600 -324 184', 90, 0, "plat", 1);
        Add_Imp ('-1280 -324 184', 90, 0, "plat", 1);
        Add_Imp ('-1136 132 56', 270, 0, "plat", 1);
        Add_Imp ('-504 -68 280', 90, 0, "plat", 2);
        Add_Imp ('-484 -902 120', 0, 1, "plat", 2);
        Add_Imp ('-484 -1018 120', 0, 1, "plat", 2);
        Add_Imp ('-308 -352 280', 0, 1, "plat", 2);
        Add_Imp ('-308 -480 280', 0, 1, "plat", 2);
        Add_Imp ('64 -612 104', 90, 1, "plat", 0);
        Add_Imp ('64 -764 104', 270, 0, "plat", 0);
        Add_Imp ('336 -220 152', 270, 1, "plat", 1);
        Add_Imp ('336 92 152', 90, 0, "plat", 2);
        Add_Imp ('396 -688 104', 0, 0, "plat", 0);

        if ((sklv < 2) || deathmatch)
        {
            Add_Ent ('-564 764 -224', 0, "item_artifact_equalizer", item_artifact_equalizer);
            Add_Ent ('426 -64 -248', 0, "item_artifact_vitality", item_artifact_vitality);
        }
        else
            Add_Ent ('426 -64 -248', 0, "item_artifact_equalizer", item_artifact_equalizer);
        Add_EntEx ('-1104 800 312', 270, 192, "plat", "item_artifact_levitation", item_artifact_levitation);
// Update 12/24/09:  Hammer book obsolete with interface change.
// Just replace with tomeofpower.  More power and probably okay.
        Add_Ent ('-498 -704 -72', 90, "item_artifact_tomeofpower", item_artifact_tomeofpower);
        Add_Ent ('1480 1250 -248', 0, "item_armor1", item_armor1);      //'1592 1088 -248', 270
        Add_EntEx ('-324 -600 -248', 0, 64, "plat", "item_armor2", item_armor2);
// Update 12/24/09:  Keep hammer over crossbow.
// Reason:  Probably to prevent statue shattering and easy sub-boss kills.
        Add_EntEx ('768 -608 -40', 0, 1, world.null_string, "weapon_mjolnir", weapon_mjolnir);
//        Add_EntEx ('768 -608 -40', 0, 1, world.null_string, "weapon_crossbow", weapon_crossbow);
        Add_EntEx ('688 -864 152', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-340 -796 -248', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-380 -796 -248', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-420 -796 -248', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-400 -704 280', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-656 -704 280', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-960 -1232 408', 0, 64, "plat", "item_health", item_health);
        Add_EntEx ('-1840 -16 408', 0, 64, "plat", "item_health", item_health);
        Add_Ent ('-1552 -836 -216', 90, "item_potion", item_potion_soe); //'-1552 -840 -216'
        Add_Ent ('-324 -116 -216', 270, "item_potion", item_potion_soe); //'-320 -112 -216'
        Add_EntEx ('-1680 -484 184', 0, 65, "plat", "item_rockets", item_rockets);
        Add_EntEx ('-1680 -1044 184', 0, 65, "plat", "item_rockets", item_rockets);
        Add_EntEx ('-1232 -1044 184', 0, 65, "plat", "item_rockets", item_rockets);
        Add_EntEx ('-300 -540 -72', 0, 64, "plat", "item_rockets", item_rockets);
        Add_EntEx ('-684 -396 -248', 0, 65, "plat", "item_spikes", item_spikes);
        Add_EntEx ('-756 -688 -248', 0, 65, "plat", "item_spikes", item_spikes);
        Add_EntEx ('-756 -396 -248', 0, 65, "plat", "item_spikes", item_spikes);
        Add_EntEx ('-368 -112 -72', 270, 2, "", "item_treasure_gem", item_treasure_gem);
        Add_Ent ('1072 -792 -248', 270, "misc_chest", misc_chest);  //'1072 -800 -248'
        Add_Ent ('1176 -896 -248', 180, "misc_chest", misc_chest);  //'1168 -896 -248'
        Add_Ent ('-1194 -760 -56', 180, "misc_chest", misc_chest);  //'-1202 -760 -56'
//        Add_Chest ('-1194 -760 -56', 180, "item_artifact_tomeofpower", item_artifact_tomeofpower);
        Add_Ent ('352 -776 -248', 90, "misc_chest", misc_chest);    //'352 -768 -248'180
        Add_Ent ('352 -600 -248', 270, "misc_chest", misc_chest);   //'352 -592 -248'180
        Add_Ent ('488 -1480 -248', 90, "misc_chest", misc_chest);   //'488 -1472 -248'
        Add_Ent ('-1184 -528 -248', 0, "misc_explobox", misc_explobox);
        Add_Ent ('168 808 -184', 0, "weapon_nailgun", weapon_nailgun);
        Add_EntEx ('-1216 -468 184', 0, 64, "plat", "weapon_stinger", weapon_stinger);    // Was chainlightning.

        Add_Summon ('-504 -416 280', 0, "plat", "progs/horn.mdl", "hipitems/horn.wav", "Horn of Conjuring", ID_IMP_BLACK, 3);

        // Add rebel fighters to help the player.
// "Hail, Baneslayer!\n\nBane's army has returned.\nPlease save our city!"
// "Èáéì¬ Âáîåóìáùåò¡\n\nÂáîåàó áòíù èáó òåôõòîåä®\nÐìåáóå óáöå ïõò ãéôù¡"
        Add_Rebel ('1160 1194 -248', 0, "monster_thug", monster_thug, "",
            "Hail, Baneslayer!\n\nBane's army has returned.\nPlease save our city!");
        Add_Rebel ('1160 1132 -248', 0, "monster_bandit", monster_bandit, "",
            "Hail, Baneslayer!\n\nBane's army has returned.\nPlease save our city!");
// "Sssshhhh!\nBane's soldiers... are close."
// "Óóóóèèèè¡\nÂáîåàó óïìäéåòó®®® áòå ãìïóå®"
        Add_Rebel ('1100 -1148 -248', 0, "monster_bandit", monster_bandit, "",
            "Sssshhhh!\nBane's soldiers... are close.");    //'1096 -1144 -248'
        Add_Rebel ('1396 -1200 -248', 180, "monster_bandit", monster_bandit, "",
            "Sssshhhh!\nBane's soldiers... are close.");
// "Psst! Over here!"
// "Ðóóô¡ Ïöåò èåòå¡"
        Add_Rebel ('-1576 -1672 -248', 90, "monster_bandit", monster_bandit, "",
            "Psst! Over here!");
        Add_Rebel ('-1226 -1770 -248', 90, "monster_bandit", monster_bandit, "",
            "Psst! Over here!");
        // sf64 Rebels
// "We shall aid thee, Baneslayer."
// "×å óèáìì áéä ôèåå¬ Âáîåóìáùåò®"
        Add_Rebel ('984 -716 -248', 135, "monster_thug", monster_thug, "gl1",
            "We shall aid thee, Baneslayer.");
        Add_Rebel ('984 -568 -248', 180, "monster_bandit", monster_bandit, "gl1",
            "We shall aid thee, Baneslayer.");
        Add_Rebel ('984 -616 -248', 180, "monster_bandit", monster_bandit, "gl1",
            "We shall aid thee, Baneslayer.");
// "Our spies report\n'Enemy reinforcements will\narrive soon!'"
// "Ïõò óðéåó òåðïòô\n¢Åîåíù òåéîæïòãåíåîôó ÷éìì\náòòéöå óïïî¡¢"
        Add_Rebel ('-672 -864 -248', 180, "monster_bandit", monster_bandit, "gold",
            "Our spies report\n'Enemy reinforcements will\narrive soon!'");
        Add_Rebel ('-672 -912 -248', 180, "monster_bandit", monster_bandit, "gold",
            "Our spies report\n'Enemy reinforcements will\narrive soon!'");
// "The time has come to\noverthrow Bane's army and\nreclaim our city!"
// "Ôèå ôéíå èáó ãïíå ôï\nïöåòôèòï÷ Âáîåàó áòíù áîä\nòåãìáéí ïõò ãéôù¡"
        Add_Rebel ('-944 -1032 -248', 90, "monster_bandit", monster_bandit, "plat",
            "The time has come to\noverthrow Bane's army and\nreclaim our city!");
        Add_Rebel ('-678 -528 -248', 180, "monster_bandit", monster_bandit, "plat",
            "The time has come to\noverthrow Bane's army and\nreclaim our city!");
        Add_Rebel ('-736 -888 -248', 135, "monster_bandit", monster_bandit, "plat",
            "The time has come to\noverthrow Bane's army and\nreclaim our city!");
        Add_Rebel ('-1440 -432 -248', 90, "monster_bandit", monster_bandit, "plat",
            "The time has come to\noverthrow Bane's army and\nreclaim our city!");
// "Help us, Baneslayer!\n\nYou must slay the dragon\nlest the imps overrun the city!"
// "Èåìð õó¬ Âáîåóìáùåò¡\n\nÙïõ íõóô óìáù ôèå äòáçïî\nìåóô éôó éíðó ïöåòòõî ôèå ãéôù¡"
// "Baneslayer!\n\nWe can defeat Bane's army here\nif you slay the dragon."
// "Âáîåóìáùåò¡\n\n×å ãáî äåæåáô Âáîåàó áòíù èåòå\néæ ùïõ óìáù ôèå äòáçïî®"
        Add_Rebel ('-648 -704 -72', 90, "monster_bandit", monster_bandit, "plat",
            "We can defeat Bane's army here\nif you slay the dragon.");
        Add_Rebel ('-368 -704 -72', 90, "monster_bandit", monster_bandit, "plat",
            "We can defeat Bane's army here\nif you slay the dragon.");
        return;
    }
    if (world.model == "maps/nsoe3.bsp")
    {
        if ((sklv <= 1) || deathmatch)
            Add_Ent ('-2304 256 -2912', 0, "item_artifact_empathy_shields", item_artifact_empathy_shields);
        return;
    }
    if (world.model == "maps/nsoe4.bsp")
    {
        world.tronyn = world.tronyn | DJG_VOID;
        temp_goal.message = "Ôéðº Use the axe to\ndestroy zombies.";
        precache_sound ("ambience/windfly.wav");    // Falling wind hack.
        return;
    }
    if (world.model == "maps/nsoe6.bsp")
    {
    // Since Tronyn can't change lights with ent-only compile, do the
    // change via QuakeC.  There's more than one way to skin a cat.
        Add_Ent ('1120 -730 -128', 0, "light_lantern", light_lantern);
        Add_Ent ('1200 -846 -128', 45, "light_lantern", light_lantern);
        Add_Ent ('1334 -872 -128', 125, "light_lantern", light_lantern);
        Add_Ent ('1446 -758 -128', 180, "light_lantern", light_lantern);
        Add_Ent ('1414 -626 -128', 230, "light_lantern", light_lantern);
        Add_Ent ('1300 -542 -128', 270, "light_lantern", light_lantern);
        Add_Ent ('1162 -602 -128', 340, "light_lantern", light_lantern);

        Add_Ent ('1120 -730 -308', 0, "light_lantern", light_lantern);
        Add_Ent ('1200 -846 -308', 45, "light_lantern", light_lantern);
        Add_Ent ('1334 -872 -308', 125, "light_lantern", light_lantern);
        Add_Ent ('1446 -758 -308', 180, "light_lantern", light_lantern);
        Add_Ent ('1414 -626 -308', 230, "light_lantern", light_lantern);
        Add_Ent ('1300 -542 -308', 270, "light_lantern", light_lantern);
        Add_Ent ('1162 -602 -308', 340, "light_lantern", light_lantern);
        return;
    }
// Update 11/15/09:  Merger levels.
// ARCANUM
    if (world.model == "maps/arcanum1.bsp")
    {
        Arcanum1_Hack ();
        return;
    }
    if (world.model == "maps/arcanum2.bsp")
    {
        world.tronyn = DJG_GROUND64 | DJG_NO_DROWN | DJG_VOID;
        return;
    }
// A ROMAN WILDERNESS OF PAIN
    if (world.model == "maps/roman1.bsp")
    {
        // After gold door.
        Add_Ent ('432 -560 -360', 0, "weapon_crossbow", weapon_crossbow);

        // Near the end, on top of megahealth.  (No good there.)
//        Add_Ent ('1056 -1856 -506', 0, "item_artifact_tomeofpower", item_artifact_tomeofpower);
    }
    if (world.model == "maps/roman3.bsp")
    {
//        dprint ("--> SUMMON TEST HACK!!! <--\n");

        info_summon ('-3500 -1000 456', 50, "monster_imp", monster_imp);
        info_summon ('-3400 -1000 456', 30, "monster_wizard", monster_wizard);
        info_summon ('-3300 -1000 456', 30, "monster_gremlin", monster_gremlin);
        info_summon ('-3200 -1000 456', 40, "monster_hell_hound", monster_hell_hound);
        info_summon ('-3100 -1000 456', 30, "monster_ogre", monster_ogre);
        info_summon ('-3000 -1000 456', 30, "monster_ogre_flak", monster_ogre_flak);
        info_summon ('-2900 -1000 456', 20, "monster_demon1", monster_demon1);
        info_summon ('-2800 -1000 456', 10, "monster_shalrath", monster_shalrath);
        info_summon ('-2700 -1000 456', 10, "monster_shambler", monster_shambler);
        info_summon ('-2600 -1000 456', 6, "monster_nemesant", monster_nemesant);

        return;
    }
};

/*
    if (world.model == "maps/zer1m3.bsp")
    {   // Add its custom lightstyles back!
        ent = spawn();
        ent.count = 15;
        ent.message = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaakaaf";
        SUB_Think (ent, info_lightstyle);

        ent = spawn();
        ent.count = 16;
        ent.message = "aaadaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaagaa";
        SUB_Think (ent, info_lightstyle);

        ent = spawn();
        ent.count = 17;
        ent.message = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaia";
        SUB_Think (ent, info_lightstyle);

        return;
    }
*/


//===========================/  END OF FILE  /===========================//
