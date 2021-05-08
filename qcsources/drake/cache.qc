//==========================================================================
//
//  FILE PRECACHING
//
//==========================================================================
void() main =
{
    dprint ("main function\n");
    
// these are just commands the the prog compiler to copy these files

    precache_file ("progs.dat");
    precache_file ("gfx.wad");
    precache_file ("quake.rc");
    precache_file ("default.cfg");

    precache_file ("end1.bin");
    precache_file2 ("end2.bin");

    precache_file ("demo1.dem");
    precache_file ("demo2.dem");
    precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
    precache_file ("gfx/palette.lmp");
    precache_file ("gfx/colormap.lmp");

    precache_file2 ("gfx/pop.lmp");

    precache_file ("gfx/complete.lmp");
    precache_file ("gfx/inter.lmp");

    precache_file ("gfx/ranking.lmp");
    precache_file ("gfx/vidmodes.lmp");
    precache_file ("gfx/finale.lmp");
    precache_file ("gfx/conback.lmp");
    precache_file ("gfx/qplaque.lmp");

    precache_file ("gfx/menudot1.lmp");
    precache_file ("gfx/menudot2.lmp");
    precache_file ("gfx/menudot3.lmp");
    precache_file ("gfx/menudot4.lmp");
    precache_file ("gfx/menudot5.lmp");
    precache_file ("gfx/menudot6.lmp");

    precache_file ("gfx/menuplyr.lmp");
    precache_file ("gfx/bigbox.lmp");
    precache_file ("gfx/dim_modm.lmp");
    precache_file ("gfx/dim_drct.lmp");
    precache_file ("gfx/dim_ipx.lmp");
    precache_file ("gfx/dim_tcp.lmp");
    precache_file ("gfx/dim_mult.lmp");
    precache_file ("gfx/mainmenu.lmp");
    
    precache_file ("gfx/box_tl.lmp");
    precache_file ("gfx/box_tm.lmp");
    precache_file ("gfx/box_tr.lmp");
    
    precache_file ("gfx/box_ml.lmp");
    precache_file ("gfx/box_mm.lmp");
    precache_file ("gfx/box_mm2.lmp");
    precache_file ("gfx/box_mr.lmp");
    
    precache_file ("gfx/box_bl.lmp");
    precache_file ("gfx/box_bm.lmp");
    precache_file ("gfx/box_br.lmp");
    
    precache_file ("gfx/sp_menu.lmp");
    precache_file ("gfx/ttl_sgl.lmp");
    precache_file ("gfx/ttl_main.lmp");
    precache_file ("gfx/ttl_cstm.lmp");
    
    precache_file ("gfx/mp_menu.lmp");
    
    precache_file ("gfx/netmen1.lmp");
    precache_file ("gfx/netmen2.lmp");
    precache_file ("gfx/netmen3.lmp");
    precache_file ("gfx/netmen4.lmp");
    precache_file ("gfx/netmen5.lmp");
    
    precache_file ("gfx/sell.lmp");
    
    precache_file ("gfx/help0.lmp");
    precache_file ("gfx/help1.lmp");
    precache_file ("gfx/help2.lmp");
    precache_file ("gfx/help3.lmp");
    precache_file ("gfx/help4.lmp");
    precache_file ("gfx/help5.lmp");

    precache_file ("gfx/pause.lmp");
    precache_file ("gfx/loading.lmp");

    precache_file ("gfx/p_option.lmp");
    precache_file ("gfx/p_load.lmp");
    precache_file ("gfx/p_save.lmp");
    precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
    precache_sound ("misc/menu1.wav");
    precache_sound ("misc/menu2.wav");
    precache_sound ("misc/menu3.wav");

    precache_sound ("ambience/water1.wav");
    precache_sound ("ambience/wind2.wav");

// shareware
    precache_file ("maps/start.bsp");

    precache_file ("maps/e1m1.bsp");
    precache_file ("maps/e1m2.bsp");
    precache_file ("maps/e1m3.bsp");
    precache_file ("maps/e1m4.bsp");
    precache_file ("maps/e1m5.bsp");
    precache_file ("maps/e1m6.bsp");
    precache_file ("maps/e1m7.bsp");
    precache_file ("maps/e1m8.bsp");

// registered
    precache_file2 ("gfx/pop.lmp");     // Is this "proof" of registration?

    precache_file2 ("maps/e2m1.bsp");
    precache_file2 ("maps/e2m2.bsp");
    precache_file2 ("maps/e2m3.bsp");
    precache_file2 ("maps/e2m4.bsp");
    precache_file2 ("maps/e2m5.bsp");
    precache_file2 ("maps/e2m6.bsp");
    precache_file2 ("maps/e2m7.bsp");

    precache_file2 ("maps/e3m1.bsp");
    precache_file2 ("maps/e3m2.bsp");
    precache_file2 ("maps/e3m3.bsp");
    precache_file2 ("maps/e3m4.bsp");
    precache_file2 ("maps/e3m5.bsp");
    precache_file2 ("maps/e3m6.bsp");
    precache_file2 ("maps/e3m7.bsp");

    precache_file2 ("maps/e4m1.bsp");
    precache_file2 ("maps/e4m2.bsp");
    precache_file2 ("maps/e4m3.bsp");
    precache_file2 ("maps/e4m4.bsp");
    precache_file2 ("maps/e4m5.bsp");
    precache_file2 ("maps/e4m6.bsp");
    precache_file2 ("maps/e4m7.bsp");
    precache_file2 ("maps/e4m8.bsp");

    precache_file2 ("maps/end.bsp");

    precache_file2 ("maps/dm1.bsp");
    precache_file2 ("maps/dm2.bsp");
    precache_file2 ("maps/dm3.bsp");
    precache_file2 ("maps/dm4.bsp");
    precache_file2 ("maps/dm5.bsp");
    precache_file2 ("maps/dm6.bsp");

// FIXME:  Put custom maps here.
};

//============
// world_cache_sounds
//============
void() world_cache_sounds =
{
//========== WEAPONS ==========
// Axe
    // Note:  Axe hit sounds precached below with other player sounds.
    precache_sound ("weapons/ax1.wav");     // ax swoosh
    precache_sound ("weapons/axhit.wav");
    precache_sound ("weapons/axhitwal.wav");
//    precache_sound ("weapons/block1.wav");
//    precache_sound ("weapons/block2.wav");
    precache_sound ("weapons/clang.wav");     // nSoE knight/clang.wav
    precache_sound ("weapons/sword2.wav");
    precache_sound ("weapons/sword3.wav");
//    if (soul_evil)
//        precache_sound ("weapons/unsheath.wav");    // audible sharpness
//    precache_sound ("zombie/z_hit.wav");    // throw ax hit
// Shotguns
    precache_sound ("weapons/guncock.wav"); // shotgun
    precache_sound ("weapons/shotgn2.wav"); // super shotgun
    precache_sound ("weapons/ssg.wav");     // modified super shotgun
// Nailguns
    precache_sound ("weapons/rocket1i.wav");// nailgun
    precache_sound ("weapons/spike2.wav");  // super nailgun
    precache_sound ("weapons/ric1.wav");    // ricochet (used in c code)
    precache_sound ("weapons/ric2.wav");    // ricochet (used in c code)
    precache_sound ("weapons/ric3.wav");    // ricochet (used in c code)
    precache_sound ("weapons/tink1.wav");   // spikes tink (used in c code)
// Rockets
    precache_sound ("weapons/grenade.wav"); // grenade launcher
    precache_sound ("weapons/bounce.wav");  // grenade bounce
    precache_sound ("weapons/sgun1.wav");   // rocket launcher
    // Update 5/13/2009:  r_exp3.wav is new null sound, so use replacement.
    precache_sound ("weapons/r_exp3.wav");  // explosion (used in c code)
    precache_sound ("weapons/r_exp3a.wav"); // explosion replacement
// Thunderbolt
    precache_sound ("plasma/explode.wav");  // discharge sound
    precache_sound ("weapons/lhit.wav");    // lightning
    precache_sound ("weapons/lstart.wav");  // thunder from Thunderbolt
// Backpacks
    precache_sound ("weapons/lock4.wav");   // ammo/backpack pickup
//    precache_sound ("weapons/pkup.wav");    // weapon pickup
// Custom weapons
    if (legalized & WARx_LASERS)
    {
    // Blasters (Enforcers carry them, and are common in base levels.)
        precache_sound ("enforcer/enfstop.wav");
        precache_sound ("hipweap/laserg.wav");      // "enforcer/enfire.wav"
        precache_sound ("hipweap/laserric.wav");
    }
    if (legalized & WAR_CHAINSAW)
    {
    // Chainsaw (Ogres carry them, and they are ubiquitous.)
        precache_sound ("weapons/sawatck.wav");
        precache_sound ("weapons/sawguts.wav");
        precache_sound ("weapons/sawidle.wav");     // pack/weapon pickup
        precache_sound ("weapons/sawridle.wav");
    }
    if (legalized & WAR_GRAPPLE)
    {
        precache_sound ("shambler/smack.wav");
        precache_sound ("weapons/sawguts.wav");
        precache_sound ("weapons/chain1.wav");
    }
    if (legalized & WAR_MJOLNIR)
    {
    // Mjolnir
        precache_sound ("bane/thunder.wav");    // Lightning Storm
        precache_sound ("hipweap/mjolhit.wav");
        precache_sound ("hipweap/mjolslap.wav");
        precache_sound ("hipweap/mjoltink.wav");
        precache_sound ("knight/sword1.wav");
        precache_sound ("weapons/nova.wav");    // Shockwave
//        precache_sound ("weapons/zap1.wav");    // Static Field
//        precache_sound ("weapons/zap2.wav");    // Static Field
        precache_sound ("zombie/z_hit.wav");
    }
    if (legalized & WAR_SIDEWINDER)
    {
    // Sidewinder Missile Launcher
        precache_sound ("weapons/stunfire.wav");
    }

    if (legalized & WAR_CRUISE_MISSILE)
    {
    // MIRV Launcher
        precache_sound ("hknight/hit.wav");     // For areablaster mode.
        precache_sound ("weapons/mirv1.wav");   // Launch
        precache_sound ("weapons/mirv2.wav");   // Split
    }
    if (legalized & WAR_PLASMA_GUN)
    {
    // Plasma Gun -- modified Quoth style.
        precache_sound ("weapons/plasma1.wav");     // Normal
        precache_sound ("weapons/plasma2.wav");     // Powered-up
//        precache_sound ("weapons/zap1.wav");
//        precache_sound ("weapons/zap2.wav");
    }
    if (legalized & WAR_ZAPPER)
    {
        precache_sound ("enforcer/enfstop.wav");
        precache_sound ("hknight/attack1.wav");
    }
    if (legalized & WAR_BURIZA)
    {
        precache_sound ("necro/att_a.wav");     // Normal
        precache_sound ("necro/att_a2.wav");    // Powered-up
        precache_sound ("weapons/icewall.wav");
        precache_sound ("weapons/xbowdraw.wav");
    }

//========== MISCELLANEOUS ==========
// Sounds used from C physics code.
    precache_sound ("demon/dland2.wav");        // landing thud
    precache_sound ("misc/h2ohit1.wav");        // landing splash
    precache_sound ("misc/talk.wav");           // Used by 'say'.
// Teleport sounds.  (Also used when summoning monsters.)
    precache_sound ("misc/r_tele1.wav");
    precache_sound ("misc/r_tele2.wav");
    precache_sound ("misc/r_tele3.wav");
    precache_sound ("misc/r_tele4.wav");
    precache_sound ("misc/r_tele5.wav");
// Item sounds always needed.  (Players or monsters)
    precache_sound ("items/damage3.wav");       // quad cheat
    precache_sound ("items/itembk2.wav");       // item respawn sound
    precache_sound ("items/protect3.wav");      // free invulnerability (DM)
// Null sound.  Needed in weapons code and elsewhere.
    precache_sound ("misc/null.wav");
// Slop (old Doom gib) sound.  Used by decapitation and monster revival.
    precache_sound ("misc/dsslop.wav");
// Earthquakes (Used by many custom features.)
    precache_sound ("misc/quake.wav");
    precache_sound ("misc/quakeend.wav");
// Ice
    precache_sound ("weapons/shatter.wav");     // icy death
// Power armor (Zap sounds used by weapons too.)
    precache_sound ("me/me_soff.wav");
    precache_sound ("me/me_son.wav");
    precache_sound ("weapons/zap1.wav");
    precache_sound ("weapons/zap2.wav");

//========== PLAYER ==========
// Pain
//    precache_sound ("player/axhit1.wav");   // ax hit meat
    precache_sound ("player/axhit2.wav");   // ax hit world
    precache_sound ("player/drown1.wav");   // drowning pain
    precache_sound ("player/drown2.wav");   // drowning pain
    precache_sound ("player/lburn1.wav");   // lava burn
    precache_sound ("player/lburn2.wav");   // lava burn
    precache_sound ("player/pain1.wav");
    precache_sound ("player/pain2.wav");
    precache_sound ("player/pain3.wav");
    precache_sound ("player/pain4.wav");
    precache_sound ("player/pain5.wav");
    precache_sound ("player/pain6.wav");
// Die
    precache_sound ("player/h2odeath.wav");     // drowning death
    precache_sound ("player/death1.wav");
    precache_sound ("player/death2.wav");
    precache_sound ("player/death3.wav");
    precache_sound ("player/death4.wav");
//    precache_sound ("player/death5.wav");
// Gib
    precache_sound ("player/gib.wav");          // player gib sound
    precache_sound ("player/teledth1.wav");     // telefrag
    precache_sound ("player/tornoff2.wav");     // gib sound (logoff)
    precache_sound ("player/udeath.wav");       // player gib sound
// Jumping and Swimming
    precache_sound ("misc/outwater.wav");       // leaving water sound
    precache_sound ("misc/water1.wav");         // swimming
    precache_sound ("misc/water2.wav");         // swimming
    precache_sound ("player/plyrjmp8.wav");     // player jump
    precache_sound ("player/land.wav");         // player landing
    precache_sound ("player/land2.wav");        // player hurt landing
    precache_sound ("player/h2ojump.wav");      // player jumping into water
    precache_sound ("player/slimbrn2.wav");     // player enter slime
    precache_sound ("player/inh2o.wav");        // player enter water
    precache_sound ("player/inlava.wav");       // player enter lava
    precache_sound ("player/gasp1.wav");        // gasping for air
    precache_sound ("player/gasp2.wav");        // taking breath
// Footsteps
    // NOTE:  Don't precache more than a few because some maps are starved
    // for sound slots already.
    // Update 6/4/2011:  No footsteps unless enabled.
    if (footsteps)
    {
        precache_sound ("player/boot2.wav");
        precache_sound ("player/boot3.wav");
    }
};

//============
// world_cache_models
//============
void() world_cache_models =
{
//========== WEAPONS ==========
// C code
    precache_model ("progs/bolt.mdl");      // for shambler
    precache_model ("progs/bolt2.mdl");     // for lightning gun
    // Removed "progs/bolt3.mdl" -- precache in 'monster_boss'.
// Weapons and their missiles (originally View models)
//    if (soul_evil)
//        precache_model ("progs/v_sword.mdl");
//    else
        precache_model ("progs/v_axe.mdl");
    precache_model ("progs/v_shot.mdl");
    precache_model ("progs/v_shot2.mdl");
    precache_model ("progs/v_nail.mdl");
    precache_model ("progs/v_nail2.mdl");
    precache_model ("progs/spike.mdl");     // Merged spike and s_spike.
    precache_model ("progs/v_rock.mdl");
    precache_model ("progs/grenade.mdl");
    precache_model ("progs/v_rock2.mdl");
    precache_model ("progs/missile.mdl");
    precache_model ("progs/v_light.mdl");
// Flames
    precache_model ("progs/flame2.mdl");
    precache_model ("progs/flame2a.mdl");   // For Qrack.
// Sprites/Missiles
    precache_model ("progs/s_explod.spr");  // sprite explosion (modified)
    precache_model ("progs/s_expbig.spr");  // Modified bigexp from Quoth.
    precache_model ("progs/s_fancy.spr");   // Fancy explosion pack.
    precache_model ("progs/s_wave.spr");    // shockwave sprite pack.
    //- - - - - - - - -
// Custom weapons
    if (legalized & WARx_LASERS)
    {
    // Lasers
        precache_model ("progs/laser.mdl");
    //    precache_model ("progs/needle.mdl");    // Alternate laser model
        precache_model ("progs/v_laserb.mdl");  // Single Blaster
        precache_model ("progs/v_laserg.mdl");  // Laser Cannon
    }
    if (legalized & WAR_CHAINSAW)
    {
    // Chainsaw
        precache_model ("progs/v_saw.mdl");
    }
    if (legalized & WAR_GRAPPLE)
    {
        precache_model ("progs/beam.mdl");      // Used by TE_BEAM.
        precache_model ("progs/drake/hook.mdl");
        precache_model ("progs/v_grpple.mdl");
    }
    if (legalized & WAR_MJOLNIR)
    {
    // Mjolnir
        precache_model ("progs/v_hammer.mdl");
        precache_model ("progs/throwham.mdl");  // SoE: Thrown Mjolnir.
    }
    if (legalized & WAR_SIDEWINDER)
    {
    // Sidewinder Missile Launcher
        precache_model ("progs/memissil.mdl");
        precache_model ("progs/v_rocks.mdl");
    }

    if (legalized & WAR_CRUISE_MISSILE)
    {
    // MIRV Launcher
        precache_model ("progs/v_mirv.mdl");
        precache_model ("progs/rocket1.mdl");
        precache_model ("progs/memissil.mdl");
        precache_model ("progs/k_ball.mdl");    // For areablaster mode.
//        precache_model ("progs/flame2.mdl");    // Pretty explosion effects.
    }
    if (legalized & WAR_CHAIN_LIGHTNING)
    {
    // Chain Lightning
        precache_model ("progs/v_light2.mdl");
    }
    if (legalized & WAR_PLASMA_GUN)
    {
    // Plasma Gun -- modified Quoth style.
        precache_model ("progs/plasma.mdl");
        precache_model ("progs/plasma1.mdl");
        precache_model ("progs/v_plasma.mdl");
    }
    if (legalized & WAR_ZAPPER)
    {
        precache_model ("progs/k_spike.mdl");   // For ToP shots.
        precache_model ("progs/v_wand.mdl");    // FIXME:  v_zapper.
        precache_model ("progs/s_spark.spr");   // FIXME:  Flare gun addition.
    }
    if (legalized & WAR_BURIZA)
    {
        precache_model ("progs/arrow.mdl");
        precache_model ("progs/v_xbow.mdl");
    }

//========== PLAYER ==========
    precache_model ("progs/player.mdl");
    precache_model ("progs/null_256.spr");  // Invisible -- was 'eyes.mdl'
    precache_model ("progs/h_player.mdl");

// Items
    precache_model ("progs/backpack.mdl");
    precache_model ("progs/s_bubble.spr");  // drowning bubbles

//========== BLOOD ==========
// Standard red meat
    precache_model ("progs/blood.mdl");     // For decapitation effects.
    precache_model ("progs/gib1.mdl");
    precache_model ("progs/gib2.mdl");
    precache_model ("progs/gib3.mdl");
    precache_model ("progs/zom_gib.mdl");
// Ice
    precache_model ("progs/ice_cube.mdl");
    precache_model ("progs/iceball.mdl");   // Icy ball/explosion.
};

void() precache_gluttony =
{
// Gluttony
    precache_sound ("cube/bc_attck.wav");
    precache_sound ("cube/bc_gulp.wav");

    powcache = powcache | PCH_EAT_GIB;
};

// Dragonscale uses a lot of slots, so precache only if the item is found
// or if test mode is on.
void() precache_dragonscale =
{
    precache_sound ("dragon/death1.wav");
    precache_sound ("dragon/fire.wav");
    precache_sound ("dragon/firehit.wav");
    precache_sound ("dragon/fly.wav");
    precache_sound ("dragon/flywater.wav");
    precache_sound ("dragon/idle2.wav");
    precache_sound ("dragon/pain2.wav");

    precache_model ("progs/drp_head.mdl");
    precache_model ("progs/drp_lw.mdl");
    precache_model ("progs/drp_rw.mdl");
    precache_model ("progs/drp_tail.mdl");
    precache_model ("progs/dragonpl.mdl");

    precache_gluttony ();

// Enable dragonscale.
    if (!mindex_dragon)
    {
        local   entity  e;
    
        e = spawn();
        setmodel (e, "progs/dragonpl.mdl");
        mindex_dragon = e.modelindex;
        remove (e);
    }
};

// PM:  Should be called during level load if monsters drop money.
// FIXME:  Split coins and gems.
void() precache_money =
{
    precache_model ("progs/coin.mdl");
    precache_model ("progs/gem1.mdl");
    precache_model ("progs/gem2.mdl");
    precache_model ("progs/gem3.mdl");

    precache_sound ("items/money.wav");

    cash_drop = TRUE;
};

// DISABLED -- Unnecessary at the moment.
// Precaches the lavasplash sound.  Used as teleport fog for huge monsters,
// namely Shub Niggurath and the Qtest dragon at full size.
//void() precache_boss_fog =
//{
//    precache_sound ("boss1/out1.wav");      // For giant monsters like Shub.
//
//    powcache = powcache | PCH_BOSS_FOG;
//};


//===========================/  END OF FILE  /===========================//
