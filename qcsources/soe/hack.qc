//==========================================================================
//  hack.qc -- by Patrick Martin                Last updated:  3-26-2001
//--------------------------------------------------------------------------
//  This file contains code that adds dragons (familiar items and/or
//  enemy monsters) into existing Quake levels.
//==========================================================================

//-------------------//
//  NEW GLOBAL VARS  //
//-------------------//
float   hackcount;

//--------------//
//  PROTOTYPES  //
//--------------//
void(float type) PM_PrecacheDragon;
void() PM_PrepareDragon;
void() multi_use;
void() multi_touch;
void() counter_use;


//==========================================================================
//  Level Hacks

//----------------------------------------------------/ New Code /--------//
//  This creates a count/multi trigger for the Dragons hack of various
//  levels.
//------------------------------------------------------------------------//
void() trigger_hack =
{
    // noise should be set at trig ent.

    local   vector  spot1;
    local   vector  spot2;

    spot1 = self.mins;
    spot2 = self.maxs;

    self.wait = -1;
    if (self.count > 0)
    {
        self.use = counter_use;
        self.touch = SUB_Null;
    }
    else
    {
        self.use = multi_use;

        // inittrig sub
        self.solid = SOLID_TRIGGER;
        setmodel (self, "");
        self.movetype = MOVETYPE_NONE;
        self.modelindex = 0;
        self.model = "";

        setsize (self, spot1, spot2);
        if (self.spawnflags & 1)
            self.touch = SUB_Null;
        else
            self.touch = multi_touch;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This adds dragons to all the maps that have invoked the hack.
//------------------------------------------------------------------------//
void() PM_DragonHack =
{
    local   entity  e;

    if (world.model == "maps/e1m1.bsp")
    {
        if (!deathmatch)
            return;

        // On player start.
        e = spawn();
        setorigin (e, '480 -352 88');
        e.angles_y   = 90;
        e.skin       = SKIN_BLUE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e1m2.bsp")
    {
        // On a crate near start.
        e = spawn();
        setorigin (e, '1280 1376 264');
        e.angles_y  = 90;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // Near exit.
        e = spawn();
        setorigin (e, '-504 -504 480');
        e.angles_y   = 0;
        e.skin       = SKIN_BLUE;
        e.think      = draco_define;
        e.spawnflags = DRACO_CYCLE;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e1m3.bsp")
	{
        // In zombie pit.
        e = spawn();
        setorigin (e, '520 -888 -320');
        e.angles_y  = 180;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // In the big shaft before exit.
        e = spawn();
        setorigin (e, '1360 432 -128');
        e.angles_y   = 270;
        e.skin       = SKIN_BLUE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e1m4.bsp")
    {
        // Underwater; within the four pillars.
        e = spawn();
        setorigin (e, '704 1360 696');
        e.skin      = SKIN_BLUE;
        e.angles_y  = 270;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e1m5.bsp")
    {
        // Near start, next to a large box of shells.
        e = spawn();
        setorigin (e, '-1048 528 112');
        e.angles_y  = 0;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e1m6.bsp")
    {
        // Near yellow armor and button.
        e = spawn();
        setorigin (e, '-384 1280 24');
        e.angles_y  = 0;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e1m8.bsp")
    {
        // Bottom floor on a spotlight, near start.
        e = spawn();
        setorigin (e, '136 552 -712');
        e.angles_y  = 0;
        e.skin      = SKIN_GOLD;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m1.bsp")
    {
        if (!deathmatch)
            return;

        // On player start.
        e = spawn();
        setorigin (e, '544 -808 72');
        e.angles_y   = 90;
        e.skin       = SKIN_WHITE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m2.bsp")
	{
        // Near start.
        e = spawn();
        setorigin (e, '-280 -1720 248');
        e.angles_y  = 270;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // 4-way intersection, near gold door.
        e = spawn();
        setorigin (e, '160 896 88');
        e.angles_y   = 0;
        e.skin       = SKIN_WHITE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m3.bsp")
    {
        // Underwater near start.
        e = spawn();
        setorigin (e, '192 -536 -280');
        e.angles_y  = 90;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // In Well of Wishes.
        e = spawn();
        setorigin (e, '864 1056 -344');
        e.angles_y   = 135;
        e.skin       = SKIN_BLUE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m4.bsp")
    {
        // In underwater pit secret.
        e = spawn();
        setorigin (e, '1840 1088 -168');
        e.angles_y  = 270;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // In a secret with megahealth.
        e = spawn();
        setorigin (e, '1912 1336 -104');
        e.angles_y  = 180;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m5.bsp")
    {
        // Near start.
        e = spawn();
        if (deathmatch)
        {
            // At end of a platform.
            setorigin (e, '-128 896 -40');
            e.angles_y  = 0;
        }
        else
        {
            // Above rocket launcher.
            setorigin (e, '0 -440 -16');
            e.angles_y  = 270;
        }
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // By gold door.
        e = spawn();
        setorigin (e, '-512 2800 -112');
        e.angles_y  = 0;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m6.bsp")
    {
        // Central chamber.
        e = spawn();
        setorigin (e, '608 496 -504');
        e.angles_y  = 270;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e2m7.bsp")
    {
        // Near start.
        e = spawn();
        if (deathmatch)
        {
            // In front of barred gate.
            setorigin (e, '1136 -1064 -72');
            e.angles_y  = 90;
        }
        else
        {
            // On middle of bridge.
            setorigin (e, '1136 -864 -64');
            e.angles_y  = 270;
        }
        e.skin      = SKIN_GOLD;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon does not appear in DM.
        if (deathmatch)
            return;

        // In the TC/TW sig room.
        e = spawn();
        setorigin (e, '-260 804 -208');
        e.angles_y  = 0;
        e.skin      = SKIN_GOLD;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e3m1.bsp")
    {
        if (!deathmatch)
            return;

        // On player start.
        e = spawn();
        setorigin (e, '616 352 72');
        e.angles_y   = 90;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e3m2.bsp")
    {
        // Near start, next to silver key trap door.
        e = spawn();
        setorigin (e, '192 400 24');
        e.angles_y  = 90;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // In fiend lair, near silver key.
        e = spawn();
        setorigin (e, '32 -960 -232');
        e.angles_y   = 45;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e3m3.bsp")
    {
        // Behind stairs near start.
        e = spawn();
        setorigin (e, '576 -832 24');
        e.angles_y  = 90;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e3m4.bsp")
    {
        // Near start.
        e = spawn();
        setorigin (e, '856 -464 -232');
        e.angles_y  = 180;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // In a secret over a lava grate.
        e = spawn();
        setorigin (e, '-800 -736 -208');
        e.angles_y  = 315;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e3m5.bsp")
    {
        // In front of a deep pit with sky above.
        e = spawn();
        setorigin (e, '1712 -2280 216');
        e.angles_y  = 0;
        e.skin      = SKIN_WHITE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // In a water pit.
        e = spawn();
        setorigin (e, '0 -2280 296');
        e.angles_y   = 180;
        e.skin       = SKIN_WHITE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e3m6.bsp")
    {
        // At start, on the bridge.
        e = spawn();
        setorigin (e, '-1088 -560 8');
        e.angles_y  = 90;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // If DM, don't add the dragon boss.
        if (deathmatch)
            return;

        // Make the red dragon a boss!  Must be killed to open exit.
        e = spawn();
        setorigin (e, '288 -2536 536');
        e.angles_y      = 270;
        e.skin          = SKIN_RED;
        e.height        = SIZE_LARGE;
        e.speed         = 24;
        e.state         = IQ_HIGH;
        e.style         = 1;            // sf64 -- make splash.
        e.wait          = 2;            // Regenerates 2 hp/sec.
        e.spawnflags    = SPAWN_HIDDEN;
        e.target        = "t168";       // open gate on death
        e.targetname    = "tdragon";
        e.classname     = "monster_dragon";
        e.think         = PM_PrepareDragon;
        e.nextthink     = time + 0.1;

        // Find rune, and change its target to activate the dragon.
        e = find (world, classname, "item_sigil");
        e.target = "tdragon";

        // Find set of bars linked to rune, and give it a message.
        e = find (world, targetname, "t168");
        e.message = "You must slay the evil dragon!";

        return;
    }
    if (world.model == "maps/e3m7.bsp")
    {
        // At start.
        e = spawn();
        setorigin (e, '-1200 -96 -504');
        e.angles_y  = 270;
        e.skin      = SKIN_GOLD;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m1.bsp")
    {
        if (!deathmatch)
            return;

        // Underwater near gold door.
        e = spawn();
        setorigin (e, '1312 1328 -128');
        e.angles_y   = 0;
        e.skin       = SKIN_GOLD;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m2.bsp")
    {
        // At start, between crates.
        e = spawn();
        setorigin (e, '-136 312 1192');
        e.angles_y  = 0;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // Near a lift to invulnerability, under a bright flame.
        e = spawn();
        setorigin (e, '-576 -864 376');
        e.angles_y   = 135;
        e.skin       = SKIN_BLUE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m3.bsp")
    {
        // In graveyard, near grenade launcher.
        e = spawn();
        setorigin (e, '2152 -424 -104');
        e.angles_y  = 180;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m4.bsp")
    {
        // Above red armor secret.
        e = spawn();
        setorigin (e, '-112 760 136');
        e.angles_y  = 270;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m5.bsp")
    {
        // Near ring.
        e = spawn();
        setorigin (e, '1248 648 120');
        e.angles_y  = 270;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Near shifting teleporter.
        e = spawn();
        setorigin (e, '-1680 -2560 -264');
        e.angles_y  = 0;
        e.skin      = SKIN_RED;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m6.bsp")
    {
        // In spawn pit with the four buttons.
        e = spawn();
        setorigin (e, '-768 -1504 -104');
        e.angles_y  = 90;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m7.bsp")
	{
        // Fix teleport destinations so zombies don't freeze in ceiling.
        local   float   i;
        local   vector  spot;

        i = 1;
        e = find (world, classname, "info_teleport_destination");
        while (e)
        {
            // The 5th, 6th, and 7th ents need fixing.
            if (i >= 5)
                if (i <= 7)
                {
                    spot = e.origin;
                    spot_z = 160;       // Originally 163.
                    setorigin (e, spot);
                }

            i = i + 1;
            e = find (e, classname, "info_teleport_destination");
        }

        // Now add the dragon items.

        // At an intersection, near spike trap and items.
        e = spawn();
        setorigin (e, '-224 1120 -80');
        e.angles_y  = 0;
        e.skin      = SKIN_BLUE;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Second dragon appears only in multiplayer.
        if (!deathmatch)
            return;

        // Underwater in zombie pit.
        e = spawn();
        setorigin (e, '320 0 -168');
        e.angles_y   = 270;
        e.skin       = SKIN_WHITE;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/e4m8.bsp")
	{
        // Near start at the center of a spotlight.
        e = spawn();
        setorigin (e, '-448 320 -104');
        e.angles_y  = 90;
        e.skin      = SKIN_GOLD;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Don't add the extra dragons in DM.
        if (deathmatch)
            return;

        // Behind secret gold door.  Nailgun occupies this in DM.
        e = spawn();
        setorigin (e, '352 1188 24');
        e.angles_y  = 270;
        e.skin      = SKIN_GOLD;
        e.think     = draco_define;
        e.nextthink = time + 0.1;

        // Hidden enemy dragon.  Guards silver key.
        e = spawn();
        setorigin (e, '1472 -1728 216');
        e.angles_y      = 45;
        e.skin          = SKIN_RED;
        e.height        = SIZE_LARGE;
        e.speed         = 24;
        e.state         = IQ_HIGH;
        e.style         = 3;            // sf64 -- make splash & get mad.
        e.wait          = 2;            // Regenerates 2 hp/sec.
        e.spawnflags    = SPAWN_HIDDEN;
        e.target        = "tdragon1";   // Target new count trigger.
        e.targetname    = "t267";       // Triggered with shambler.
        e.classname     = "monster_dragon";
        e.think         = PM_PrepareDragon;
        e.nextthink     = time + 0.1;

        // Find the shambler near silver key, and target counter.
        e = find (world, target, "t249");
        e.target = "tdragon1";

        // New count trigger, linked to shambler and red dragon.
        e = spawn();
        setorigin (e, VEC_ORIGIN);
        setsize (e, VEC_ORIGIN, VEC_ORIGIN);
        e.spawnflags    = 1;    // No touch and no message.
        e.count         = 2;    // Shambler plus 2nd red dragon.
        e.target        = "t249";
        e.targetname    = "tdragon1";
        e.think         = trigger_hack;
        e.nextthink     = time + 0.1;
        return;
    }
    if (world.model == "maps/end.bsp")
	{
        // Near first teleport exit.
        e = spawn();
        setorigin (e, '-608 680 40');
        e.angles_y   = 0;
        e.skin       = SKIN_RED;
        e.spawnflags = (DRACO_BIG | DRACO_CYCLE);
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/dm1.bsp")
    {
        // Bottom floor, below a hole.
        e = spawn();
        setorigin (e, '152 1152 -120');
        e.angles_y   = 0;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/dm2.bsp")
    {
        // Play standard e*m2 music.
        WriteByte (MSG_ALL, SVC_CDTRACK);
        WriteByte (MSG_ALL, 8);
        WriteByte (MSG_ALL, 3);

        // In a pool of water.
        e = spawn();
        setorigin (e, '2336 -416 8');
        e.angles_y   = 0;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/dm3.bsp")
    {
        // Below skylight.
        e = spawn();
        setorigin (e, '1152 504 56');
        e.angles_y   = 0;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/dm4.bsp")
    {
        // Bottom floor, across from rocket launcher.
        e = spawn();
        setorigin (e, '-208 64 -296');
        e.angles_y   = 0;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/dm5.bsp")
    {
        // Near yellow armor.
        e = spawn();
        setorigin (e, '512 -312 120');
        e.angles_y   = 270;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
    if (world.model == "maps/dm6.bsp")
    {
        // Below secret hatch, near thunderbolt.
        e = spawn();
        setorigin (e, '840 -1080 -280');
        e.angles_y   = 180;
        e.skin       = SKIN_RED;
        e.spawnflags = DRACO_CYCLE;
        e.think      = draco_define;
        e.nextthink  = time + 0.1;
        return;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This precaches the extra files used by the entities added
//  via the dragon hack.
//------------------------------------------------------------------------//
void() PM_PrecacheHack =
{
    // Used by the dragon familiar powerup.
    // NOTE:  Commented out because this is done at "weapons.qc".
    // PM_PrecacheDraco();

    // Precache large red dragon at the following maps.
    if (world.model == "maps/e3m6.bsp")
        PM_PrecacheDragon (SKIN_RED);
    else if (world.model == "maps/e4m8.bsp")
        PM_PrecacheDragon (SKIN_RED);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon hack should be invoked for the
//  current level.
//------------------------------------------------------------------------//
float() PM_InvokeHack =
{
    if (hackcount)
        return FALSE;   // Hack already invoked.

    // Do this only once per level.
    hackcount = 1;

    // The following maps have dragons...
    if (world.model == "maps/e1m1.bsp")  return TRUE;
    if (world.model == "maps/e1m2.bsp")  return TRUE;
    if (world.model == "maps/e1m3.bsp")  return TRUE;
    if (world.model == "maps/e1m4.bsp")  return TRUE;
    if (world.model == "maps/e1m5.bsp")  return TRUE;
    if (world.model == "maps/e1m6.bsp")  return TRUE;
    if (world.model == "maps/e1m8.bsp")  return TRUE;
    if (world.model == "maps/e2m1.bsp")  return TRUE;
    if (world.model == "maps/e2m2.bsp")  return TRUE;
    if (world.model == "maps/e2m3.bsp")  return TRUE;
    if (world.model == "maps/e2m4.bsp")  return TRUE;
    if (world.model == "maps/e2m5.bsp")  return TRUE;
    if (world.model == "maps/e2m6.bsp")  return TRUE;
    if (world.model == "maps/e2m7.bsp")  return TRUE;
    if (world.model == "maps/e3m1.bsp")  return TRUE;
    if (world.model == "maps/e3m2.bsp")  return TRUE;
    if (world.model == "maps/e3m3.bsp")  return TRUE;
    if (world.model == "maps/e3m4.bsp")  return TRUE;
    if (world.model == "maps/e3m5.bsp")  return TRUE;
    if (world.model == "maps/e3m6.bsp")  return TRUE;
    if (world.model == "maps/e3m7.bsp")  return TRUE;
    if (world.model == "maps/e4m1.bsp")  return TRUE;
    if (world.model == "maps/e4m2.bsp")  return TRUE;
    if (world.model == "maps/e4m3.bsp")  return TRUE;
    if (world.model == "maps/e4m4.bsp")  return TRUE;
    if (world.model == "maps/e4m5.bsp")  return TRUE;
    if (world.model == "maps/e4m6.bsp")  return TRUE;
    if (world.model == "maps/e4m7.bsp")  return TRUE;
    if (world.model == "maps/e4m8.bsp")  return TRUE;
    if (world.model == "maps/end.bsp")   return TRUE;
    if (world.model == "maps/dm1.bsp")   return TRUE;
    if (world.model == "maps/dm2.bsp")   return TRUE;
    if (world.model == "maps/dm3.bsp")   return TRUE;
    if (world.model == "maps/dm4.bsp")   return TRUE;
    if (world.model == "maps/dm5.bsp")   return TRUE;
    if (world.model == "maps/dm6.bsp")   return TRUE;

    // Don't add anything to the level.
    return FALSE;
};


//===========================/  END OF FILE  /===========================//
