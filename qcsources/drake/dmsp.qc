/*================================
DMSP code for Soul of Evil

DMSP in SoE is activated with setting bit 4 (value 16) in serverflags; this
is done with a trigger_changelevel with bit 4 set. See client.qc.

Original DMSP code by Aardappel (http://wouter.fov120.com)

What I, Fat Controller, have done here is put the DMSP code in its own little
file, as well as tweak the normal monster spawn functions to remove themselves
when serverflags has bit 4 set.
- - - - - - - - - -
Update (2008/05/03):  Modified for the unholy union between Drake and SoE.
Time for Patrick Martin (me) to wipe his filthy hands on this.

Update (2008/06/04):  dmsp is activated only by 'temp1 == 1' now.
==================================*/

// PM:  Generic monster spawn.
void(string mclass, void() mfunc) dmsp_monster =
{
// FIXME:  Should inherit more stuff?
    self.xsf        = XSF_DMSP;
    self.spawned    = TRUE;     // Bypass precache code.
    self.spawnflags = self.spawnflags & 15; // Only first four are allowed.
                                            // 16 = npc, 224 = spawning.
    self.classname  = mclass;
    mfunc ();
};

void() dmsp_army =
{
    if (soul_evil)
        dmsp_monster ("monster_goblin", monster_goblin);
    else if (medieval)
        dmsp_monster ("monster_bandit", monster_bandit);
    else
        dmsp_monster ("monster_army", monster_army);
};
void() dmsp_army2 =
{
    if (soul_evil)
        dmsp_monster ("monster_goblin", monster_goblin);
    else if (medieval)
        dmsp_monster ("monster_bandit", monster_bandit);
    else
        dmsp_monster ("monster_soldier", monster_soldier);
};
void() dmsp_army_axe =
{
    if (soul_evil || medieval)
        dmsp_monster ("monster_knight", monster_knight);
    else
        dmsp_monster ("monster_army_axe", monster_army_axe);
};
void() dmsp_axeman =
    {dmsp_monster ("monster_axeman", monster_axeman);};
void() dmsp_demon1 =
    {dmsp_monster ("monster_demon1", monster_demon1);};
void() dmsp_dog =
    {dmsp_monster ("monster_dog", monster_dog);};
void() dmsp_dog2 =
    {dmsp_monster ("monster_hell_hound", monster_hell_hound);};
void() dmsp_enforcer =
{
    if (soul_evil)
        dmsp_monster ("monster_archer", monster_archer);
    else if (medieval)
        dmsp_monster ("monster_rebel", monster_rebel);
    else
        dmsp_monster ("monster_enforcer", monster_enforcer);
};
void() dmsp_enforcer2 =
{
    if (soul_evil || medieval)
        dmsp_monster ("monster_acolyte", monster_acolyte);
    else if (totalmonsterspawn & 16)
        dmsp_monster ("monster_defender", monster_defender);
    else
        dmsp_monster ("monster_me", monster_me);
};
void() dmsp_hell_knight =
    {dmsp_monster ("monster_hell_knight", monster_hell_knight);};
void() dmsp_imp =
    {dmsp_monster ("monster_imp", monster_imp);};
void() dmsp_knight =
    {dmsp_monster ("monster_knight", monster_knight);};
void() dmsp_knight2 =
    {dmsp_monster ("monster_warrior", monster_warrior);};
void() dmsp_mage1 =
    {dmsp_monster ("monster_acolyte", monster_acolyte);};
void() dmsp_mage2 =
    {dmsp_monster ("monster_sorcerer", monster_sorcerer);};
void() dmsp_ogre =
    {dmsp_monster ("monster_ogre", monster_ogre);};
void() dmsp_ogre_flak =
    {dmsp_monster ("monster_ogre_flak", monster_ogre_flak);};
void() dmsp_thug =
    {dmsp_monster ("monster_thug", monster_thug);};
void() dmsp_wizard =
    {dmsp_monster ("monster_wizard", monster_wizard);};
void() dmsp_zombie =
    {dmsp_monster ("monster_zombie", monster_zombie);};

// This piece of code is referenced by world.qc. It preloads all the monster
// models and sounds to be used in the DMSP game mode.
//
void () DMSP_precaches ={
    if (!dmsp)
		return;

    totalmonsterspawn = 20*(cvar("skill")+2);
//    total_monsters = totalmonsterspawn + total_monsters;

// PM:  Don't see any problems with teamplay, so proceed.
//    if(cvar("teamplay") != 0)
//    {
//        totalmonsterspawn = 0;
//        bprint("deathmatch mode not supported!");
//    }
	lastmspawn = world;
    lasttime = 0;       // Update 8/20/10:  Set when timer ends.
    boss_count = 0;

// Update 12/23/2009:  Removed 'ra/*.wav' to save slots for other things.
    precache_sound ("misc/bell.wav");   // The new fight sound.

//FC: Your less than gracious host :P
	precache_sound ("bishop/journey.wav");
	precache_sound ("bishop/rip.wav");
	precache_sound ("bishop/rot.wav");
	precache_sound ("bishop/skull.wav");
    // FIXME:  Not all variant autoplay this.
    precache_sound ("music/pkdream.wav");    // Intermission music.

// PM:  Melee weapon pings like Aliens' motion detector in dmsp.
    precache_sound ("ambience/heart.wav");      // heartbeat for radar.

// FIXME:  Summon test.
// DISABLED -- for now.  need to get updated arcanum progs for 10/31.
//    if (world.model == "maps/unforgiven1.bsp")
//        return;

//aard: merged in from monsters we're using
// PM:  Use some of Drake's summoning code to tidy things up.
// Update 12/22/2009:  Use bowmen instead of gunmen in medieval mode.
    if (soul_evil)
    {
        goblin_cache ();
        archer_grunt_cache ();
    }
    else if (medieval)
    {
        bandit_cache();     // grunt
        rebel_cache();      // enforcer
    }
    else
    {
        army_cache ();
        enf_cache ();
        megaenforcer_cache ();
    }
    necro_cache();
    axeman_cache ();
    demon1_cache ();
    dog_cache ();
    knight_cache ();
    hknight_cache ();
    imp_cache ();
    ogre_cache ();
    wiz_cache ();
    zombie_cache ();
};

// PM:  Moved 'isSpawnPointEmpty' elsewhere.

void() DMSP_monsterspawner =
{
	local entity tself;
    local entity cl;
    local float n;
    local float fat, hi;    // PM: My additions.

    if (!dmsp)
        return;
    if (!lasttime)
        return;     // Disabled.

// PM:  Tidied up for readability (for me).
// Update 12/22/2009:  Changed spawn time from 2 (soe) back to 1 (dmsp2).
// FIXME:  Testing
    if ((time - lasttime > 1) && (totalmonsterspawn > 0))
    {   // PM:  Make one find call for the first player.
        cl = find(world, classname, "player");
        // 8/20/10:  Removed "The invasion has begun!" and nspawned.

		// FC: if the player is dead, stop the spawning
        if (!deathmatch && !coop)   // PM:  Don't stop in multiplayer.
            if (cl.deadflag)
                return;

        lasttime = time;    // Assumes time is non-zero.
		lastmspawn = find(lastmspawn, netname, "dmsp_spawn");
        if (lastmspawn==world)
            return;

//- - - - - - - - -
        // FC: need a check here to avoid spawns which're occupied.
        //  This loop will run at most once through all the spawns;
        //  if all are occupied then we use the one originally selected.
        //
		tself = lastmspawn;
		n = isSpawnPointEmpty(lastmspawn);
		while (n == 0) // also exits if we run out of spawns
		{
			lastmspawn = find(lastmspawn, netname, "dmsp_spawn");
			n = isSpawnPointEmpty(lastmspawn);
            // DISABLED -- done in function now.
            //if (lastmspawn == world)
            //    n = 0;
			if (lastmspawn == tself)
				n = 1;
		}
		// shouldn't need this check, but just in case...
        if (lastmspawn == world)
            return;
//- - - - - - - - -

		tself = self;
		self = spawn();

        if (dmsp_ent)   // FIXME:  ???
            SUB_CopyEntity (dmsp_ent, self);

// PM:  Pick a player and seek him out immediately.  Doing this will move
//  the monster off the spawnpoint, and reduce telefrags from later spawns.
        fight_me = NextPlayer (fight_me);
        if (!fight_me.invisible_finished)
            if (!(fight_me.flags & FL_NOTARGET))
                self.enemy = fight_me;
//- - - - - - - - -
// PM:  Do this before, not after, calling spawn function.
		totalmonsterspawn = totalmonsterspawn - 1;

        setorigin (self, lastmspawn.origin);
        self.angles   = lastmspawn.angles;
        if (totalmonsterspawn < boss_count)
        {   if (dmsp_ent.targetname == "dmsp_boss")
            {   setorigin (self, dmsp_ent.origin);
                self.angles = dmsp_ent.angles;
            }
        }
        self.fixangle = TRUE;       // turn this way immediately
		spawn_tfog (self.origin);	// FC: effects!
//- - - - - - - - -
        n = totalmonsterspawn & 7;
        hi = totalmonsterspawn & 8;
        fat = lastmspawn.cnt;
//- - - - - - - - -
        if (dmsp_ent)
        {   // Using func_spawn entities set by mapper.
            if (!fat)
            {
                if (dmsp_ent.spawnmaster.spawnmaxs_x > 16)
                {
//                    dprint("WARNING: ");
//                    dprint(dmsp_ent.spawnclassname);
//                    dprint(" is too fat!\n");
                    if (dmsp_ent.targetname != "dmsp_boss")
                    {   // Replace with a thinner monster.
                        cl = dmsp_ent;
                        dmsp_ent = summon_next(dmsp_ent);
                        while (cl != dmsp_ent)
                        {
                            if (dmsp_ent.spawnmaster.spawnmaxs_x > 16)
                                dmsp_ent = summon_next(dmsp_ent);
                            else
                            {
                                cl = dmsp_ent;
//                                dprint ("Replacement: ");
//                                dprint (dmsp_ent.spawnclassname);
//                                dprint ("\n");
                            }
                        }
                    }
                }
            }
            // Summon the monster.
            dmsp_monster (dmsp_ent.spawnclassname, dmsp_ent.spawnfunction);

            // Select the next monster.
            if (totalmonsterspawn > boss_count)
            {   // Cycle through the mooks.
                dmsp_ent = summon_next(dmsp_ent);
            }
        }
//- - - - - - - - -
// Update 12/22/2009:  Made more like dmsp2.  No monsters with over 300 hp.
        else
        {
            if(n==0)        // knight
            {   if (hi)
                    dmsp_knight2();
                else
                    dmsp_knight();
            }
            else if(n==1)   // ogre (knight)
            {   if (fat)
                {   if (hi)
                        dmsp_ogre_flak();
                    else
                        dmsp_ogre();
                }
                else
                {   if (hi)
                        dmsp_knight2();
                    else
                        dmsp_army_axe();
                }
            }
            else if(n==2)   // enforcer
            {   if (hi)
                    dmsp_enforcer2();
                else
                    dmsp_enforcer();
            }
            else if(n==3)   // dog (enforcer)
            {   if (fat)
                {   if (hi)
                    {   if (soul_evil || medieval)
                            dmsp_thug();
                        else
                            dmsp_dog2();
                    }
                    else
                        dmsp_dog();
                }
                else    // Was enforcer, use necro instead.
                {   if (hi)
                        dmsp_mage2();
                    else
                        dmsp_mage1();
                }
                // Note:  spiders would've been good, but I cached enough already.
            }
            else if(n==4)   // hell knight/fiend
            {   if (hi)
                {   if (fat)
                        dmsp_demon1();
                    else
                        dmsp_axeman();      // Was hell knight.
                }
                else
                    dmsp_hell_knight();
            }
            else if(n==5)   // wizard
            {   if (hi)
                    dmsp_imp();
                else
                    dmsp_wizard();
            }
            else if(n==6)   // zombie
            {
                dmsp_zombie();
            }
            else //if(n==7)
            {   if (hi)
                    dmsp_army2();
                else
                    dmsp_army();
            }
        }
// PM:  tdeath and monster count update done at monsters.qc.

// 8/14/10:  Removed old SoE boss check.  Done elsewhere now.
        self = tself;

		if (totalmonsterspawn < 1)
        {
            Mass_Centerprint ("The invasion has ended!");
            activator = find(world, classname, "player");
            FireTargets ("dmsp_event");
            lasttime = 0;   // Done spawning monsters.
        }
        else if (totalmonsterspawn <= boss_count)
        {   // Time to get the boss monsters.
            // This is here to support the dragon bosses in SoE arena maps.
            if (totalmonsterspawn == boss_count)
                dmsp_ent = summon_first ("dmsp_boss");
            else
            {   // More than one boss monster.
                dmsp_ent = summon_next (dmsp_ent);
                lasttime = 0.01;    // All bosses spawn near-simultaneously.
            }
        }
    }
};

// FC: Countdown timer to invasion start. Referenced from info_player_start.
// PM: Not anymore!  Referenced from worldspawn.
//
void() DMSP_countdown ={
    local   entity  sucker;

	if (self.cnt < 0)
    {
        if (!lasttime)
            lasttime = 0.01;    // If we didn't start fighting, do it!
        SUB_Remove ();
        return;
    }

    // PM:  Moved from bottom of function to here.
	self.nextthink = time + 1;
	self.think = DMSP_countdown;

    // PM:  Suspend countdown during a cutscene.
    if (cutscene)
        return;

// Proceed with countdown.
	sucker = find (world, classname, "player");
	if (sucker != world)
	{
        local   string  ticker;

		ticker = ftos(self.cnt);
		if (self.cnt > 0)
        {
            Mass_Centerprint (ticker);
            if (self.cnt <= 3)
                sound(sucker, CHAN_AUTO, "misc/talk.wav", 1, ATTN_NONE);
        }
		else if (self.cnt == 0)
		{
dmsp_ent = summon_first ("cubed");  // FIXME:  ???
            Mass_Centerprint ("FIGHT!");
            sound (sucker, CHAN_AUTO, "misc/bell.wav", 1, ATTN_NONE);
            lasttime = 0.01;
		}
	}
	self.cnt = self.cnt - 1;
};

/* FC: Here we do a little trickie where "fat monsters" are concerned.

	Since fiends and ogres have double-width bounding boxes (64 wide), we need spawnpoints that
	are at least 48 units away from any wall. We discern these by running a passel of
	traceline() calls to find out whether a spawn is "fat" or "thin". Ogres etc. will only
	be spawned in designated "fat" points!
*/
void() DMSP_checkSpawnSize ={
// Update 8/14/10:  Use dragon morph code to check size.  The spawnpoints
// are player-sized, so pretend they morph into a dragon, which checks size.
// Note:  This does not check for hull sizes fatter than a shambler.
// There should be no need since all super-fat monsters are too powerful.
    self.cnt = Box16To32 (self);    // Borrowing my dragon morph code...
//    if (self.cnt) dprint("fat\n"); else dprint("thin\n");
};

/********************
 *	info_dmsp_spawn
 *	This item indicates a monster only spawnpoint for Arena games.
 ********************/
void() info_dmsp_spawn ={
    if (dmsp)
	{
		self.netname = "dmsp_spawn";
//		dprint("dmsp_spawn created\n");
        info_player_deathmatch ();
	}
	else
        remove (self);
};


//==========================================================================
//  Additions

//============
// --> QUAKED info_dmsp_stats (.5 .5 .5) (-8 -8 -8) (8 8 8)
// Provides custom info for dmsp variants.
// Only one per map.  Any more will be ignored.
//
// "target" will use func_spawns...
// "spawnflags" variant.
//============
// 'target'  = Mooks to summon.
// 'target2' = Event to fire at the end.
// spawnflags
// 2 = s
//float   DMSP_ON         = 1;    // DMSP is active; use only if no other rules.
//float   DMSP_START      = 2;    // Player starts at sp/coop points.
//float   DMSP_NOCOUNT    = 4;    // 100% kills does not clear the map.
////float   DMSP_NOLIMIT    = 8;    // Infinite monster spawn until player dies.
//float   DMSP_NOMOCK     = 16;   // Prevents Bishop from mocking the player.
void() info_dmsp_stats =
{
    if (dmsp)
        dmsp = dmsp | (self.spawnflags & 254);
//    remove (self);
};


//==========================================================================
//  Unforgiven1 Statue Boss

void() statue_touch =
{
    if (other.classname == "player")
    {   // One time reference to Rapture.
        centerprint (other, "He looks familiar...");
        sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
        self.touch = barrel_touch;      // Walk on statue.
    }
    barrel_touch ();
};

// After two seconds, the earth baron sheds his stone skin.
void() statue_use1 =[ 0, statue_use2 ] {self.nextthink = time + 1;
    self.targetname = world.null_string;
    self.touch = self.use = SUB_Null;
    Quake_Self (0, 0, VEC_ORIGIN, DF_NONE, 3);
};
void() statue_use2 =[ 1, statue_use3 ] {self.nextthink = time + 0.5;};
void() statue_use3 =[ 2, statue_use4 ] {self.nextthink = time + 0.5;};
void() statue_use4 =[ 0, SUB_Null    ]
{   // The baron is ready for action.
    Mass_Centerprint ("Face the elemental baron!");
    statue_pieces (8, -50);

    self.enemy = fight_me;
    self.classname = "monster_baron";
    self.spawned = TRUE;    // Bypass precaching and thinking delays.
    monster_baron ();
    self.spawned = FALSE;
};

//============
// --> QUAKED dmsp_statue_baron (1 0 0) (-16 -16 -24) (16 16 40) Ambush x Nojump
//
// Boss of unforgiven1.  Spawns in dmsp mode only.
// Adds a statue that does nothing until the end of monster spawning in dmsp.
// At that point, the statue breaks and reveals an elemental baron.
//============
void() misc_statue_baron =
{
    if (!dmsp)
        {remove (self);  return;}

// Precache the files.
    precache_model ("progs/imp_rock.mdl");
    precache_model ("progs/st_gib3.mdl");
//    precache_sound ("misc/wallbrk.wav");

    baron_cache ();
    baron_boss_cache ();
    kolem_cache ();

// Reduce totatmonsters because the statue is a monster spawn at the end.
    totalmonsterspawn = totalmonsterspawn - 1;

// Set it up as an ordinary statue for now.
    self.mdl = "progs/st_baron.mdl";
    self.pos1 = '-16 -16 -24';
    self.pos2 = '16 16 40';
    self.touch  = statue_touch;     //barrel_touch;
    self.use = statue_use1;
    if (!self.level)
        self.level = 2;     // Earth baron.
    self.targetname = "dmsp_event";
    self.target = "rune";

    misc_decor ();
};


//===========================/  END OF FILE  /===========================//
