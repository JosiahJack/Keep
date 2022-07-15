//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 12
// Function count: 7
//
// Implements: Worldspawn and Main qc entry and StartFrame
//
// Description:
// Worldspawn is the entity for the world and displays the level geometry. Many
// level-specific settings are assigned to worldspawn that affect the rest of
// the level's entities.
//
// Main is the starting point for the qc code.
//
// StartFrame is called at the beginning of every frame before looping through
// all the entities' thinks and touches.
//=============================================================================

entity lastspawn; // client.qc (SelectSpawnPoint)
entity bodyque_head; // Keeps track of dead player models

void() versus_setup;
entity() ammohealthsum;
void() InitBodyQue;
void() InitBulletHoles;
void() light_style_boundary;
void() light_style_setuparray;
void() pendulum_setuparray;
void() mapvar_setuparray;
void() player_fallspeed_reset;
void() player_fallspeed_setup;
void() Client_SyncEvilmode;
void() InitMusic;

void() main = { // [FUNCTION]
	precache_file("progs.dat"); // these are just commands to the prog compiler to copy these files
	precache_file("gfx.wad");
	precache_file("quake.rc");
	precache_file("default.cfg");
	precache_file("end1.bin");
	precache_file2("end2.bin");
	precache_file("demo1.dem");
	precache_file("demo2.dem");
	precache_file("demo3.dem");
	precache_file("gfx/palette.lmp"); // these are all of the lumps from the cached.ls files
	precache_file("gfx/colormap.lmp");
	precache_file2("gfx/pop.lmp");
	precache_file("gfx/complete.lmp");
	precache_file("gfx/inter.lmp");
	precache_file("gfx/ranking.lmp");
	precache_file("gfx/vidmodes.lmp");
	precache_file("gfx/finale.lmp");
	precache_file("gfx/conback.lmp");
	precache_file("gfx/qplaque.lmp");
	precache_file("gfx/menudot1.lmp");
	precache_file("gfx/menudot2.lmp");
	precache_file("gfx/menudot3.lmp");
	precache_file("gfx/menudot4.lmp");
	precache_file("gfx/menudot5.lmp");
	precache_file("gfx/menudot6.lmp");
	precache_file("gfx/menuplyr.lmp");
	precache_file("gfx/bigbox.lmp");
	precache_file("gfx/dim_modm.lmp");
	precache_file("gfx/dim_drct.lmp");
	precache_file("gfx/dim_ipx.lmp");
	precache_file("gfx/dim_tcp.lmp");
	precache_file("gfx/dim_mult.lmp");
	precache_file("gfx/mainmenu.lmp");
	precache_file("gfx/box_tl.lmp");
	precache_file("gfx/box_tm.lmp");
	precache_file("gfx/box_tr.lmp");
	precache_file("gfx/box_ml.lmp");
	precache_file("gfx/box_mm.lmp");
	precache_file("gfx/box_mm2.lmp");
	precache_file("gfx/box_mr.lmp");
	precache_file("gfx/box_bl.lmp");
	precache_file("gfx/box_bm.lmp");
	precache_file("gfx/box_br.lmp");
	precache_file("gfx/sp_menu.lmp");
	precache_file("gfx/ttl_sgl.lmp");
	precache_file("gfx/ttl_main.lmp");
	precache_file("gfx/ttl_cstm.lmp");
	precache_file("gfx/mp_menu.lmp");
	precache_file("gfx/netmen1.lmp");
	precache_file("gfx/netmen2.lmp");
	precache_file("gfx/netmen3.lmp");
	precache_file("gfx/netmen4.lmp");
	precache_file("gfx/netmen5.lmp");
	precache_file("gfx/sell.lmp");
	precache_file("gfx/help0.lmp");
	precache_file("gfx/help1.lmp");
	precache_file("gfx/help2.lmp");
	precache_file("gfx/help3.lmp");
	precache_file("gfx/help4.lmp");
	precache_file("gfx/help5.lmp");
	precache_file("gfx/pause.lmp");
	precache_file("gfx/loading.lmp");
	precache_file("gfx/p_option.lmp");
	precache_file("gfx/p_load.lmp");
	precache_file("gfx/p_save.lmp");
	precache_file("gfx/p_multi.lmp");
	precache_sound("misc/menu1.wav"); // sounds loaded by C code
	precache_sound("misc/menu2.wav");
	precache_sound("misc/menu3.wav");
	precache_sound("ambience/water1.wav");
	precache_sound("ambience/wind2.wav");
	precache_file("maps/start.bsp"); // shareware
	precache_file("maps/e1m1.bsp");
	precache_file("maps/e1m2.bsp");
	precache_file("maps/e1m3.bsp");
	precache_file("maps/e1m4.bsp");
	precache_file("maps/e1m5.bsp");
	precache_file("maps/e1m6.bsp");
	precache_file("maps/e1m7.bsp");
	precache_file("maps/e1m8.bsp");
	precache_file2("gfx/pop.lmp"); // Registered.  Full version of Quake is required to play this mod.  Note that we only need files with these names to exist...latteedah, nothing to think about here.
	precache_file2("maps/e2m1.bsp");
	precache_file2("maps/e2m2.bsp");
	precache_file2("maps/e2m3.bsp");
	precache_file2("maps/e2m4.bsp");
	precache_file2("maps/e2m5.bsp");
	precache_file2("maps/e2m6.bsp");
	precache_file2("maps/e2m7.bsp");
	precache_file2("maps/e3m1.bsp");
	precache_file2("maps/e3m2.bsp");
	precache_file2("maps/e3m3.bsp");
	precache_file2("maps/e3m4.bsp");
	precache_file2("maps/e3m5.bsp");
	precache_file2("maps/e3m6.bsp");
	precache_file2("maps/e3m7.bsp");
	precache_file2("maps/e4m1.bsp");
	precache_file2("maps/e4m2.bsp");
	precache_file2("maps/e4m3.bsp");
	precache_file2("maps/e4m4.bsp");
	precache_file2("maps/e4m5.bsp");
	precache_file2("maps/e4m6.bsp");
	precache_file2("maps/e4m7.bsp");
	precache_file2("maps/e4m8.bsp");
	precache_file2("maps/end.bsp");
	precache_file2("maps/dm1.bsp");
	precache_file2("maps/dm2.bsp");
	precache_file2("maps/dm3.bsp");
	precache_file2("maps/dm4.bsp");
	precache_file2("maps/dm5.bsp");
	precache_file2("maps/dm6.bsp");
};

// QUAKED worldspawn (0 0 0) ? x
// Unique entity in every map (read only in QC)
// -------- KEYS --------
// worldtype   : World type 0 = medieval, 1 = metal, 2 = base
// wad         : list of Wad Files used by compiler (; for separation)
// sounds      : CD Music track to play (4-11, 12+ custom tracks)
// message     : Title of map
// light       : Ambient light level (eg 5) 
// sky         : 6 sided cube for sky brushes (night_)
// _range      : Scales brightness range of all lights (useful for dirt)
// _dist       : Scales the fade distance of all lights by a factor of n
// _anglescale : Scaling factor for how much influence the angle of incidence
// _gamma      : Adjust brightness of final lightmap
// _sunlight          : Brightness of SUN (eg 100)
// _sunlight_color    : Red/Green/Blue (0.78 0.86 1.00)
// _sunlight_mangle   : Angle of sunlight (eg 0 -90 0)
// _sun_mangle        : Duplicate version of sunlight_mangle
// _sunlight_penumbra : Penumbra width, in degrees, of sunlight
// _sunlight_dirt     : 1 = enables dirt mapping on sun
// _sunlight2       : Second SUN (eg 100) // Ambient bounce light (multiple suns in a dome)
// _sunlight2_color : Red/Green/Blue (0.78 0.86 1.00)
// _sunlight2_dirt  : 1 = enables dirt mapping on sun 2
// _sunlight3       : Third SUN! (ask MFX)
// _dirt          : 1 = enables dirtmapping (ambient occlusion) on all lights
// _dirtmode      : Choose between ordered (def=0) and randomized (1)
// _dirtscale     : Scale factor used in dirt calculations, def=1
// _dirtgain      : Exponent used in dirt calculation, def=1
// _dirtdepth     : Maximum depth of occlusion checking, def=128
// _minlight_dirt : 1 enables dirtmapping (ambient occlusion) on minlight
// compilerstyle_start : starting point for target lights (set by compiler)
// gravity        : gravity of map (default = 800)
// fog            : console command (Den/R/G/B - '0.05 0.3 0.3 0.3')
// fog_density    : Trigger fog starting density (default = 0.1)
// fog_colour     : Trigger fog starting colour (default = 0.1 0.1 0.1)
// fog_dpextra    : extra DP fog parameters, default - '1 0 8192 1024 32'
// skyfog_density : Trigger skyfog starting density (default = 0.5)
// water_alpha    : Water Alpha, default - 1.00
// particlemax    : Amount of ACTIVE particles per map
// playerweather  : Name of weather effect active above player
// passive_state     : All monsters are setup in a passive state 1=ON
// no_item_offset    : All ammo/heal items use central point rotation
// no_item_rotate    : Not used anymore (keep for legacy reasons)
// no_zaware         : Switch OFF zaware monster attacks
// no_sgprojectile   : Switches OFF ALL shotgun projectiles
// no_sgcasing       : Switches OFF ALL shotgun casings
// no_liquiddmg      : Switch OFF liquid (slime/lava) monster damage
// no_trackondeath   : Homing missiles stop tracking when monster dead (1=active)
// hazard_dmg        : Hazard damage override for map (water=2/slime=4/lava=10)
// knight_defskin    : Default skin (0-3) type for new knight model
// bodyflrcheck      : All monster dead body check floor for gravity
// bodyfadeaway      : All monster dead bodies fade away
// sprite_particles  : Switch all custom particles to sprites (builtin excluded)
// no_bigprojectiles : Switches OFF large player projectiles size
// no_surfacecheck   : Stops surface checks for sky brushes (Very large maps only)
// mapvar_update     : Update map variables (Range X->Y=Z)
// ckeyhint          : Arcane key Inventory message 1=SUPPRESS (no msg to player)
// jump_height     : Player jump height (def=270) initial boast from standing still
// fall_speedlow   : Fall speed for any checks (def=-300) must be negative no.
// fall_speedhigh  : Fall speed for damage checks (def=-650) must be negative no.
// fall_speeddebug : Display players fall velocity to console (1=ON, -1=OFF)
// fall_dmg        : Fall damage for player (def=5, -1=no dmg/sound)
// fall_dmgwater   : Fall damage into water (>0 for dmg/sound, -1=no dmg/sound)
// upgrade_axe     : Upgrade Axe -1=remove on spawn, 1=enable
// upgrade_ghook   : Upgrade Grapple Hook -1=remove on spawn, 1=enable
// upgrade_ssg     : Upgrade Super Shotgun -1=remove on spawn, 1=enable
// upgrade_lg      : Upgrade Lightning Gun -1=remove on spawn, 1=enable
// give_weapons    : Bit flag for which weapons to give to the player
// take_weapons    : 1=SG, 2=SSG, 4=NG, 8=SNG, 16=GL, 32=RL, 64=LG (excludes Axe)
// max_health      : Update player health if below this value
// reset_health    : Reset player health to this value (1-100)
// player_health   : Max/Mega/Skill (1=Easy,2=Normal,4=Hard,8=NM,15=All)
// bleeding_dmg    : Percentage reduction / HoT Qty / Initial pause
// currentammo     : =1 reset inventory, =0 minimum values
// ammo_shells     : Setup starting shell quanity (reset/minimum)
// ammo_nails      : Setup starting nails quanity (reset/minimum)
// ammo_rockets    : Setup starting rockets quanity (reset/minimum)
// ammo_cells      : Setup starting cells quanity (reset/minimum)
// armortype       : Armour type to start with 1=Green, 2=Yellow, 3=Red
// armorvalue      : Quantity of armour to reset player (100/150/200)
// plasmagun_dmg   : Plasma gun damage override (def=45 0 20)
// gh_hookstyle    : Swing=0 / linear=1 movement of hook/client
// gh_debugmove    : Show debug entities for grapple movement (-1=def qty)
// gh_funchookonly : Only works with func grapple hook points
// gh_hookearly    : Chain pulling start before hook attached
// gh_maxdist      : Maximum distance grapple hook can travel
// gh_hookspeed    : Forward momentum of hook (rocket spd+)
// gh_pullspeed    : Forward momentum on chain (pulling forward)
// gh_mindist      : Minimum distance to slowdown velocity
// gh_minbeam      : Minimum distance to stop drawing beam
// gh_dmg          : Damage to Player/Monsters/World (def=4 8 8)
// gh_linechain    : Linear movement while on the chain
// gh_jumpchain    : Jump movement to jumping off the chain
// gh_boostchain   : Boost movement during swing/pull chain
// gh_movemonster  : Monster movement when impacted by chain
void() worldspawn = { // [ENTITY]...well it IS.
	dprint ("\b[WORLDSPAWN]\b function started ...\n");
	lastspawn = world;
	InitBodyQue();
	if (world.hipnoticoptions & HIPNOTIC_BULLETHOLES) InitBulletHoles();
	InitTempGoal();
	InitMoveBox(); // Create dummy entity used for checking movement for extra large monsters
    InitLightning();
	developer = cvar("developer");
	self.classtype = CT_WORLD;
	if (self.angles_y != 0) self.angles = '0 0 0'; // ID map E3M3 has worldspawn angles set, WUT!?!
	Client_SyncEvilmode(); // Engine resets skill 0-3, change it back

	// These sounds MUST be the first precache_sounds
	precache_sound("weapons/r_exp3.wav");		// Hardcoded Explosion (null)
	precache_sound("weapons/rocket1i.wav");	// spike gun
	precache_sound("weapons/sgun1.wav");		// Rocket launcher!?!
	precache_sound("weapons/guncock.wav");		// Original SG
	precache_sound("ad171/weapons/sg2.wav");	// New SG (with shell casing)
	precache_sound("weapons/ric1.wav");		// ricochet (used in c code)
	precache_sound("weapons/ric2.wav");		// ricochet (used in c code)
	precache_sound("weapons/ric3.wav");		// ricochet (used in c code)
	precache_sound("weapons/spike2.wav");		// super spikes
	precache_sound("weapons/tink1.wav");		// spikes tink (used in c code)
	precache_sound("weapons/grenade.wav");		// grenade launcher
	precache_sound("ad171/weapons/gl_loadshort.wav");// MONSTER grenade launcher
	precache_sound("weapons/bounce.wav");		// grenade bounce
	precache_sound("weapons/shotgn2.wav");		// Original SSG
	precache_sound("ad171/weapons/ssg2.wav");		// Projectile shells or Shotgun upgrade
	precache_sound(SOUND_PLASMA_FIRE);			// Player PG (eliminator)
	precache_sound(SOUND_PLASMA_HIT);			// New fire/impact sounds
	precache_sound(SOUND_MISFIRE);		// Weapon jams/noammo/broken
	precache_sound(SOUND_REXP3);				// Original explosion
	precache_sound(SOUND_RESIST_ROCKET);		// Resist Rockets
	
	// Sounds used from C physics code, must be present!
	precache_sound("demon/dland2.wav");		// landing thud
	precache_sound("misc/h2ohit1.wav");		// landing splash

	// Always precaches player sounds
	precache_sound(SOUND_RESPAWN);				// item respawn sound
	precache_sound("player/plyrjmp8.wav");		// player jump
	precache_sound("player/land.wav");			// player landing
	precache_sound("player/land2.wav");		// player hurt landing
	precache_sound("player/drown1.wav");		// drowning pain
	precache_sound("player/drown2.wav");		// drowning pain
	precache_sound("player/gasp1.wav");		// gasping for air
	precache_sound("player/gasp2.wav");		// taking breath
	precache_sound("player/h2odeath.wav");		// drowning death
	precache_sound(SOUND_EMPTY);				// Empty sound
	precache_sound("misc/talk.wav");				// talk message/trigger
	precache_sound("player/teledth1.wav");		// telefrag
	precache_sound("misc/r_tele1.wav");		// teleport sounds
	precache_sound("misc/r_tele2.wav");
	precache_sound("misc/r_tele3.wav");
	precache_sound("misc/r_tele4.wav");
	precache_sound("misc/r_tele5.wav");
	precache_sound("weapons/lock4.wav");		// ammo pick up
	precache_sound("weapons/pkup.wav");		// weapon up
	precache_sound("items/armor1.wav");		// armor up
	precache_sound("weapons/lhit.wav");		// lightning
	precache_sound("weapons/lstart.wav");		// lightning start
	precache_sound("ad171/weapons/shellc.wav");		// Shotgun shell falling to floor
	precache_sound(SOUND_ARTQUAD3);			// Quad firing
	precache_sound(SOUND_ARTNAILP3);			// Nail Piercer firing
	precache_sound(SOUND_ARTPENT3);			// God mode on, taking damage
	precache_sound(SOUND_ARTBLASTBELT3);		// Blast belt active
	precache_sound(SOUND_ARTLSHIELD3);			// Lava shield active
	precache_sound(SOUND_ARTSUIT3);		// Blast belt active
	precache_sound("misc/power.wav");			//lightning for boss, vanilla id1 sound
	precache_sound("player/gib.wav");			// Used for players only
	precache_sound(GIB_SOUND_UDEATH);			// Used for monsters and players (sounds player)
	precache_sound("player/tornoff2.wav");		// Exit sound for client disconnect
	precache_sound("player/pain1.wav");
	precache_sound("player/pain2.wav");
	precache_sound("player/pain3.wav");
	precache_sound("player/pain4.wav");
	precache_sound("player/pain5.wav");
	precache_sound("player/pain6.wav");
	precache_sound("player/death1.wav");
	precache_sound("player/death2.wav");
	precache_sound("player/death3.wav");
	precache_sound("player/death4.wav");
	precache_sound("player/death5.wav");
	precache_sound(SOUND_AXE_SWIPE1);			// Axe swipe 1
	precache_sound(SOUND_AXE_SWIPE2);			// Axe swipe 2
	precache_sound(SOUND_AXE_PLAYER);			// axe hit player
	precache_sound(SOUND_AXE_STONE);			// stone impact
	precache_sound(SOUND_AXE_WOOD);				// wood impact
	precache_sound(SOUND_AXE_GLASS);			// glass impact
	precache_sound(SOUND_AXE_METAL);			// metal impact
	precache_sound(SOUND_AXE_CERAMIC);			// Ceramic impact
	precache_sound(GIB_SOUND_HEAVY);			// fleshy
	precache_sound(GIB_SOUND_HEAVY2);			// harder flesh!
	precache_sound("player/h2ojump.wav");		// player jumping into water
	precache_sound("player/slimbrn2.wav");		// player enter slime
	precache_sound("player/inh2o.wav");		// player enter water
	precache_sound("player/inlava.wav");		// player enter lava
	precache_sound("misc/outwater.wav");		// leaving water sound
	precache_sound("player/lburn1.wav");		// lava burn
	precache_sound("player/lburn2.wav");		// lava burn
	precache_sound("misc/water1.wav");			// swimming
	precache_sound("misc/water2.wav");			// swimming
	precache_sound(SOUND_HEARTBEAT);			// Heartbeat (fast 1s)
	precache_model(MODEL_PLAYER);
	precache_model(MODEL_PLAYER_EYES);
	precache_model(MODEL_PLAYER_HEAD);
	precache_model("progs/q15/player_legs1.mdl");
	precache_model("progs/q15/player_legs1_suit.mdl");
	precache_model("progs/q15/player_legs2.mdl");
	precache_model(SBUBBLE_DROWN);			// player drowning bubbles
	precache_model(SEXP_SMALL);			// Fire explosion (ID)
	precache_model(SEXP_MED);				// Fire explosion (Quoth)
	precache_model(SEXP_BIG);				// Fire explosion (Quoth)
	precache_model(SEXP_PLASMA_SMALL);		// Plasma explosion (Marcher)
	precache_model(SEXP_PLASMA_BIG);		// Plasma explosion (Marcher)
	precache_model(SEXP_POISON_SMALL);		// Poison explosion (Marcher)
	precache_model(SEXP_POISON_MED);		// Poison explosion (Quoth)
	precache_model(SEXP_ELECTRIC);			// Impact explosion (Quoth)
	precache_model(SBURST_SMOKE);			// Small puff of smoke (Rubicon2)
	precache_model(MODEL_PROJ_SMOKE);		// Empty model + smoke trail
	precache_model(MODEL_PROJ_FLESH);		// SpawnMeatSpray - projectiles.qc
	precache_model(MODEL_PROJ_FLESHP);		// Poisonous version of meat
	precache_model("progs/rrp/g_axe.mdl");
	precache_model("progs/ad171/g_shadaxeplain.mdl");
	precache_model("progs/v_axe.mdl");
	precache_model("progs/airfist/v_airgun.mdl");
	precache_model("progs/ad171/v_shadaxe0.mdl");
	precache_model(MODEL_VWEAP_UPAXE);		// Upgrade - Shadow
	precache_model(MODEL_VWEAP_SG);
	precache_model(MODEL_VWEAP_SSG);
	precache_model(MODEL_VWEAP_UPSSG);		// Upgrade - Widowmaker
	precache_model(MODEL_VWEAP_NG);
	precache_model(MODEL_VWEAP_SNG);
	precache_model(MODEL_VWEAP_GL);
	precache_model(MODEL_VWEAP_RL);
	precache_model(MODEL_VWEAP_LG);
	precache_model(MODEL_VWEAP_UPLG);		// Upgrade - Plasma Gun
	precache_model("progs/drake/memissil.mdl"); // Sidewinder missle
	precache_model("progs/bolt.mdl");		// for lightning gun
	precache_model("progs/bolt2.mdl");		// for lightning gun
	precache_model("progs/bolt3.mdl");		// for boss shock
	precache_model(MODEL_PROJ_PGPLASMA);	// Plasma bolt for PG
	precache_model(MODEL_PROJ_SHELLC);		// Launch_ShellCasing - projectiles.qc
	precache_model(MODEL_PROJ_DIAM2);		// Projectile bullets
	precache_model(MODEL_PROJ_NG);
	precache_model(MODEL_PROJ_SNG);
	precache_model(MODEL_PROJ_GRENADE);
	precache_model(MODEL_PROJ_ROCKET);
	precache_model(MODEL_BACKPACK);		// DropBackpack - items.qc
	precache_model(MODEL_BROKEN);			// Broken model error
	precache_model(MODEL_EMPTY);			// Used for info_intermission cameras
	precache_model(MODEL_CORNER1);			// Dev spawn angle marker
	precache_model("progs/airfist/s_ablast.spr");
	precache_bloodgibs();
	precache_sound(GIB1_SOUND);			// Monster Gib 1
	precache_sound(GIB3_SOUND);			// Monster Gib 3
	precache_sound(GIB5_SOUND);			// Monster Gib 5
	precache_sound(GIBHIT1_SOUND);			// Gib Impact sound 1
	precache_sound(GIBHIT2_SOUND);			// Gib Impact sound 2
	precache_sound(GIBHIT3_SOUND);			// Gib Impact sound 3
	precache_sound(GIBHIT4_SOUND);			// Gib Impact sound 4
	precache_sound(GIBHIT5_SOUND);			// Gib Impact sound 5
	precache_sound(GIBHIT1_STONESOUND);	// long roll
	precache_sound(GIBHIT3_STONESOUND);	// quick roll
	precache_sound(GIBHIT5_STONESOUND);	// slow roll
	precache_sound(GIBHIT1_METALSOUND);	// small clink
	precache_sound(GIBHIT3_METALSOUND);	// large clank
	precache_sound(GIBHIT5_METALSOUND);	// gigantic clonk
	precache_sound(GIB_SOUND_HEAVY);		// Large gib
	precache_sound(GIB_SOUND_METALA);		// Sword impact
	precache_sound(GIB_SOUND_METALB);		// Sword impact
	precache_sound(GIB_SOUND_CHAIN);		// Chain impact
	precache_sound(GIB_SOUND_WOOD);		// Wooden impact
	precache_sound(GIB_SOUND_ACID);		// Acid burning
	precache_sound(GIB_SOUND_SDEATH);		// Stone death
	precache_sound(SOUND_FS_SLOW1); // Footstep sounds (slow, light, medium, heavy, large & giant)
	precache_sound(SOUND_FS_SLOW2);
	precache_sound(SOUND_FS_SLOW3);
	precache_sound(SOUND_FS_SLOW4);
	precache_sound(SOUND_FS_SLOW5);
	precache_sound(SOUND_FS_DRAG1);
	precache_sound(SOUND_FS_DRAG2);
	precache_sound(SOUND_FS_DRAG3);
	precache_sound(SOUND_FS_DRAG4);
	precache_sound(SOUND_FS_DRAG5);
	precache_sound(SOUND_FS_LIGHT1);
	precache_sound(SOUND_FS_LIGHT2);
	precache_sound(SOUND_FS_LIGHT3);
	precache_sound(SOUND_FS_LIGHT4);
	precache_sound(SOUND_FS_LIGHT5);
	precache_sound(SOUND_FS_MEDIUM1);
	precache_sound(SOUND_FS_MEDIUM2);
	precache_sound(SOUND_FS_MEDIUM3);
	precache_sound(SOUND_FS_MEDIUM4);
	precache_sound(SOUND_FS_MEDIUM5);
	precache_sound(SOUND_FS_HEAVY1);
	precache_sound(SOUND_FS_HEAVY2);
	precache_sound(SOUND_FS_HEAVY3);
	precache_sound(SOUND_FS_HEAVY4);
	precache_sound(SOUND_FS_HEAVY5);
	precache_sound(SOUND_FS_LARGE1);
	precache_sound(SOUND_FS_LARGE2);
	precache_sound(SOUND_FS_LARGE3);
	precache_sound(SOUND_FS_LARGE4);
	precache_sound(SOUND_FS_LARGE5);
	precache_sound(SOUND_FS_GIANT1);
	precache_sound(SOUND_FS_GIANT2);
	precache_sound(SOUND_FS_GIANT3);
	precache_sound(SOUND_FS_GIANT4);
	precache_sound(SOUND_FS_GIANT5);
	precache_sound("weapons/agfire.wav"); // Airfist fire
	precache_sound("weapons/agfail.wav"); // Airfist fail fire
	precache_sound("weapons/agwater.wav"); // Airfist underwater shot
	precache_sound("weapons/agwfail.wav"); // Airfist fail underwater shot
	PrecacheAll(); // :D Qmaster is so evil sometimes.  OK OK, it's not really ALL per se.  Just a whole lot.
	engine = ENG_FITZ;						// Default engine type (no extensions)
	ext_active = cvar("pr_checkextension");	// Check for engine type and extensions (different features)
	if (ext_active) {
		engine = ENG_DPEXT; // This could be DP, QSS, DQ, RMQ, Qbism etc
		ext_rerelease = checkextension ("QUAKE_EX");
		ext_dppart = checkextension("DP_SV_POINTPARTICLES"); // Check for DP/FTE point particle extensions
		ext_ftepart = checkextension("FTE_SV_POINTPARTICLES");
		ext_dpfog = checkextension("DP_GFX_FOG"); // DP extra fog params
		ext_dpsurf = checkextension("DP_QC_GETSURFACE"); // surface content
		ext_dprain = checkextension("DP_TE_PARTICLERAIN"); // particle rain/snow system
		ext_dpsnow = checkextension("DP_TE_PARTICLESNOW"); // QSS supports weather extensions in v7+
		if (ext_dprain || ext_dpsnow) weathersys = TRUE; // If weather extensions active, assume default = ON
		ext_dprot = checkextension("DP_SV_ROTATINGBMODEL"); // Engine support for proper rotating/colliding bmodels
		ext_fteskin = checkextension("FTE_ENT_SKIN_CONTENTS"); // Check for FTE skin/ladder system
		ext_frikfile = checkextension("FRIK_FILE"); // Frik file system, advanced strings and C code sprintf
		ext_ftestrings = checkextension("FTE_STRINGS");
		ext_sprintf = checkextension("DP_QC_SPRINTF");

		if (!checkbuiltin(particleeffectnum)) ext_dppart = ext_ftepart = FALSE;
		
		if (ext_dppart || ext_ftepart) {
			particleeffectnum("TE_EXPLOSION");
			particleeffectnum(DPP_TRLASER);
			particleeffectnum(DPP_TEPLASMABIG);
			particleeffectnum(DPP_TRPOISON);
			particleeffectnum(DPP_TEBSMOKE);
			particleeffectnum(DPP_TRPLASMA);
			particleeffectnum(DPP_TRBLOOD);
			particleeffectnum("DPP_ITSPYROFLAME1");
			particleeffectnum("DPP_ITSPYROFLAME2");
			particleeffectnum("DPP_ITSPYROFLAME3");
		}

		// There is no way to detect CSQC, no checkextension exists!  If DP detects the CSQC functions it will just use them.
		// QSS/FTE has a console variable to toggle CSQC on/off, but requires the map to be reloaded for changes to take affect.
		autocvar(cl_nocsqc, "1"); // Setup a temp variable if none is found (def=0 CSQC is on)
		if (cvar("scratch1") < 0) cvar_set("cl_nocsqc", "1"); // Read scratch1 in quake.rc (-1=off, 0=on, 1+=diff layouts)
		if (!cvar("cl_nocsqc")) {//ext_ftepart) {
			// Setup variables for CSQC HUD (cannot directly query variables)
			// FTE/QSS use clientstat, DP use addstat (same function)
			// The addstat is defined in dpextensions.qc
			// Example: void(float index, float type, ...) addstat = #232;
			if (checkbuiltin(checkbuiltin)) {
				if (checkbuiltin(addstat)) {
					addstat(CLIENT_MODITEMS, EV_FLOAT, moditems);
					addstat(CLIENT_ITEMS2, EV_FLOAT, items2);
					addstat(CLIENT_PERMS, EV_FLOAT, perms);
					addstat(CLIENT_CKEYNAME1, EV_STRING, ckeyname1);
					addstat(CLIENT_CKEYNAME2, EV_STRING, ckeyname2);
					addstat(CLIENT_CKEYNAME3, EV_STRING, ckeyname3);
					addstat(CLIENT_CKEYNAME4, EV_STRING, ckeyname4);
					addstat(CLIENT_CKEYSKIN1, EV_FLOAT, ckeyskin1);
					addstat(CLIENT_CKEYSKIN2, EV_FLOAT, ckeyskin2);
					addstat(CLIENT_CKEYSKIN3, EV_FLOAT, ckeyskin3);
					addstat(CLIENT_CKEYSKIN4, EV_FLOAT, ckeyskin4);
					addstat(CLIENT_AMMOPOISON, EV_FLOAT, ammo_poison);
					addstat(CLIENT_USINGHACKBANK, EV_FLOAT, selfweaponismoditems);
					addstat(CLIENT_RUNEFLAG, EV_FLOAT, serverflagstemp);
				} else if (checkbuiltin(clientstat)) {
					clientstat(CLIENT_MODITEMS, EV_FLOAT, moditems);
					clientstat(CLIENT_ITEMS2, EV_FLOAT, items2);
					clientstat(CLIENT_PERMS, EV_FLOAT, perms);
					clientstat(CLIENT_CKEYNAME1, EV_STRING, ckeyname1);
					clientstat(CLIENT_CKEYNAME2, EV_STRING, ckeyname2);
					clientstat(CLIENT_CKEYNAME3, EV_STRING, ckeyname3);
					clientstat(CLIENT_CKEYNAME4, EV_STRING, ckeyname4);
					clientstat(CLIENT_CKEYSKIN1, EV_FLOAT, ckeyskin1);
					clientstat(CLIENT_CKEYSKIN2, EV_FLOAT, ckeyskin2);
					clientstat(CLIENT_CKEYSKIN3, EV_FLOAT, ckeyskin3);
					clientstat(CLIENT_CKEYSKIN4, EV_FLOAT, ckeyskin4);
					clientstat(CLIENT_AMMOPOISON, EV_FLOAT, ammo_poison);
					clientstat(CLIENT_USINGHACKBANK, EV_FLOAT, selfweaponismoditems);
					clientstat(CLIENT_RUNEFLAG, EV_FLOAT, serverflagstemp);
				}
				if (checkbuiltin(globalstat)) {
					globalstat(CLIENT_DENIZENS, EV_FLOAT, "total_denizens");
					globalstat(CLIENT_DENIZENSKILLED, EV_FLOAT, "killed_denizens");
				}
			}
		}
	}
	dprint("\b[ENGINE]\b ");
	if (engine == ENG_FITZ) dprint("Fitz Compatible (old, weak). NOT RECOMMENDED!\n");
	else if (engine == ENG_DPEXT) dprint("Advanced Engine\n"); // FTE, no longer lame old broken Darkplaces aka DP, aka flatwater.
	else dprint("Unknown\n");

	if (self.no_surfacecheck == TRUE) ext_dpsurf = 0; // Large maps cannot use this function, check for disable
	if (self.water_alpha) { // Check for any custom water alpha defined on the worldspawn
		liquid_alpha = self.water_alpha;
		cvar_set ("r_wateralpha", ftos(liquid_alpha)); // This is not very precise because FTOS is only ONE decimal place :(
	} // Once the client has started, the water alpha is fine tuned using the long version of ftos.
	autoaim_cvar = 1; // Default is auto aim OFF
	playerprojsize = world.no_bigprojectiles; // Check for any override on player projectiles
	if (!self.useold_axe) {
		g_axemodel = "progs/rrp/g_axe.mdl";
		v_axemodel = "progs/v_axe.mdl";
	} else {
		g_axemodel = "progs/ad171/g_shadaxeplain.mdl";
		v_axemodel = "progs/ad171/v_shadaxe0.mdl";
	}
	if (self.useold_chainsaw) {
		g_chainsawmodel = "progs/drake/g_saw.mdl"; // Drake/Zerstorer version
		v_chainsawmodel = "progs/drake/v_saw.mdl";
	} else {
		g_chainsawmodel = "progs/q15/g_saw.mdl"; // Quake 1.5 improved version
		v_chainsawmodel = "progs/q15/v_saw.mdl";
	}
	if (self.no_trackondeath == TRUE) map_notrackondeath = TRUE; // Check for changes to monster homing missiles on death behaviour.
	else map_notrackondeath = FALSE;
	
	// Check for hazard damage override (water=2/sline=4/lava=10)
	if (self.hazard_dmg_x <= 0) map_hazarddmg_x = WATER_DAMAGE;
	else map_hazarddmg_x = self.hazard_dmg_x;
	if (self.hazard_dmg_y <= 0) map_hazarddmg_y = SLIME_DAMAGE;
	else map_hazarddmg_y = self.hazard_dmg_y;
	if (self.hazard_dmg_z <= 0) map_hazarddmg_z = LAVA_DAMAGE;
	else map_hazarddmg_z = self.hazard_dmg_z;

	// Check for any custom gravity settings or ziggy secret map
	if (!self.gravity) map_gravity = DEF_GRAVITY;
	else map_gravity = self.gravity;
	if (self.model == "maps/e1m8.bsp") map_gravity = 100;	// Ziggy secret map
	cvar_set ("sv_gravity", ftos(map_gravity));
	
	// Check for any custom player jump height settings
	// All value checks done in separate function (triggers.qc)
	player_fallspeed_reset();
	player_fallspeed_setup();

	// Check for Plasma gun damage override (Direct, Random, Splash)
	if (!VectorIsAllZeros(world.plasmagun_dmg)) map_plasmagundmg = world.plasmagun_dmg;
	else map_plasmagundmg = DAMAGE_PGPLAYER;

	// Check for Bleeding damage override (Percentage, HoT, Pause)
	if (!VectorIsAllZeros(world.bleeding_dmg)) map_bleedingdmg = world.bleeding_dmg;
	else map_bleedingdmg = DAMAGE_BLEEDING;

	// Make sure all parameters are within certain ranges
	// Perc = 0.05-0.75, HoT = 1-10, Pause = 0.1-10
	if (map_bleedingdmg_x <= 0.05) map_bleedingdmg_x = 0.05;
	else if (map_bleedingdmg_x >= 0.75) map_bleedingdmg_x = 0.75;
	if (map_bleedingdmg_y <= 1) map_bleedingdmg_y = 1;
	else if (map_bleedingdmg_y >= 10) map_bleedingdmg_y = 10;
	if (map_bleedingdmg_z <= 0.1) map_bleedingdmg_z = 0.1;
	else if (map_bleedingdmg_z >= 10) map_bleedingdmg_z = 10;

	// Check for global body floor check and fading timer
	if (self.bodyflrcheck == 1) map_bodyflrcheck = TRUE;
	else map_bodyflrcheck = FALSE;
	if (self.bodyfadeaway > 0) map_bodyfadeaway = self.bodyfadeaway;
	else map_bodyfadeaway = FALSE;

	// Check for all monsters being setup in a passive state
	// Useful for explore jam events where minimal combat required
	if (self.passive_state == 1) map_passivestate = TRUE;
	else map_passivestate = FALSE;

	configflag = cvar("temp1"); // The values of configflag is never saved, its always generated!  Merge any changes from worldspawn into console variable
	sycn_worldspawn();
	temp1flag = configflag;
	dprint("\b[WORLD]\b TEMP1 + Worldspawn ("); 
	dprint(ftos(temp1flag)); dprint(")\n");

	// Setup Particle System
	if (query_configflag(SVR_PARTICLES) == SVR_PARTICLES) {
		if (self.particlemax > PARTICLE_MAXENTS) part_max = self.particlemax;
		else part_max = PARTICLE_MAXENTS;

		// DP/FTE setup requires less entities for sprite particles
		if (engine == ENG_DPEXT && query_configflag(SVR_SPRPARTON) == FALSE && self.sprite_particles == FALSE) part_multiplier = 0.5;
		else part_multiplier = 1;
		
		part_max = part_max * part_multiplier;
		dprint("\b[WORLD]\b Max particles (");
		dprint(ftos(part_max)); dprint(")\n");
		setup_particlechain();		// Setup intial particle chain
	}

	// Check if FTE/QSS (FTE_SV_POINTPARTICLES) particles are active
	// This has got to happen after 'sycn_worldspawn' function
	// Allow for 'saved1' variable in quake.rc to be read
	if (ext_ftepart == TRUE) {
		// Switch to vanilla particle effects (no smoke, sparks etc).  Don't bother with sprite settings for DP, the default is worse!
		if (query_configflag(SVR_SPRPARTON) == SVR_SPRPARTON) {
			particleeffectnum("effectvanilla.txt"); // Load particle effects (mostly empty defs)
			ext_dppart = ext_ftepart = FALSE; // Make sure all extra particle effects are off
			weathersys = FALSE;
		} else {
			ext_dppart = ext_ftepart = TRUE; // Set both active, used through out code

			// Check for FTE/QS-S point particle extensions.  Engine wants config files in different locations.
			if (checkextension("FTE_PART_NAMESPACE_EFFECTINFO")) {
				particleeffectnum("effectinfo.txt"); // Load particle effects file (DP default=mod root)
				particleeffectnum("fte_weather.cfg"); // Load up default weather effects
			}
		}
	}

	hipearthquake = earthquake_active = FALSE; // Start with earthquakes inactive.
	cheatflags = 0; // Zero out dev cheats to none.

	// Setup target light starting point.  Got to do this early before any light entities
	light_style_setuparray(); dprint("\b[WORLD]\b Setup Light style array\n");
	pendulum_setuparray(); dprint("\b[WORLD]\b Setup Pendulum vector array\n");
	mapvar_setuparray(); dprint("\b[WORLD]\b Setup Map Var bitflag array\n");	
	switch_shadow_setuparray(); dprint("\b[WORLD]\b Setup Shadow lightstyle array\n");	
	if (self.devdata & DEV_AMMO_N_HEALTH) self.deventity = ammohealthsum();
	if (coop > 2) versus_setup();
	else dprint("\b[VERSUS]\b Versus is currently deactivated.\n         Intended to be played on specific maps with coop 3\n");
	Gyro_InitialiseVariables(); // Setup the physics system.
	if (query_configflag(SVR_DRAKEMUSIC) == SVR_DRAKEMUSIC) InitMusic(); // Setup Drake secondary music system that plays music from two speaker entities in the map corners.
	else dprint("\b[WORLD]\b Drake music system inactive\n");
	// Kitchen sink?
};

void() StartFrame = { // [FUNCTION]
	teamplay = cvar("teamplay");
	developer = cvar("developer");
	skill = cvar("skill");
	coop = cvar("coop");
	framecount = framecount + 1;
	LightZero_Go(); // Flashes lightstyle of whole level to simulate lightning for Drake effects.
	Gyro_Run(); // Process the physics.
};
 
void() bodyque= {}; // [ENTITY] Just here so spawn functions don't complain after the world creates bodyques

void() InitBodyQue = { // [FUNCTION], New Code from Inside3d forums (old system was terrible).  Oh hey, now called InsideQc.  Interesting.
	local entity e, prev;
	local float numBodies, num;
	
	num = 0;
	numBodies = 10; // how many player corpses to allow in the world at once
	prev = world;
	bodyque_head = world;
	while(num < numBodies) {
		e = spawn(); // Spawn another body			
		e.classname = "bodyque";
		if (bodyque_head == world) bodyque_head = e; // If this is the first, set the bodyque_head pointer (start of the list)
		if (prev != world) e.owner = prev; // Link up to previous item to form the linked list
		prev = e; // Point prev to the new item			
		num = num + 1;
	}
	bodyque_head.owner = prev; // Turn the linked list into a linked loop
};

// Make a body que entry for the given ent so the ent can be respawned elsewhere.
void(entity ent) CopyToBodyQue = { // [FUNCTION]
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin(bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};

// Stuff removed
void() item_weapon = { remove(self); }; // [ENTITY]
void() misc_noisemaker = { remove(self); }; // [ENTITY]
void() noclass = { remove(self); }; // [ENTITY]
void() test_fodder = { if (developer < 1) remove(self); }; // [ENTITY]
void() test_goaway = { remove(self); }; // [ENTITY]
void() test_spawn = { if (developer < 1)  remove(self); }; // [ENTITY]
void() test_teleport = { if (developer < 1)  remove(self); }; // [ENTITY]
void() testplayerstart = { if (developer < 1)  remove(self); }; // [ENTITY]
void() viewthing = { if (developer < 1) remove(self); }; // [ENTITY]

void() trigger_onlyregistered_touch = { // [FUNCTION]
	if ( !(other.flags & FL_CLIENT) ) return;
	if (self.attack_finished > time) return;

	self.attack_finished = time + 2;
	if (cvar("registered")) {
		self.message = "";
		SUB_UseTargets();
		remove (self);
	} else {
		if (self.message != "") {
			centerprint (other, self.message);
			sound(other,CHAN_BODY,"misc/talk.wav",1,ATTN_NORM);
		}
	}
};

// Checks for registered version of game, no one uses this anymore
void() trigger_onlyregistered = { // [ENTITY]
	InitTrigger();
	self.touch = trigger_onlyregistered_touch;
};

void() amsumthink = { // [FUNCTION]
	float dmg = 0;
	vector plasmad = DAMAGE_PGPLAYER;

	dprint("\b[DEV]\b Developer Level Data:\n");
	dprint("World Ammo Sum:: Shells: ");
	dprint(ftos(self.ammo_shells));
	dprint(", Nails: ");
	dprint(ftos(self.ammo_nails));
	dprint(", Rockets: ");
	dprint(ftos(self.ammo_rockets));
	dprint(", Cells: ");
	dprint(ftos(self.ammo_cells));
	dprint("\n");
	dprint("Lava Nails: ");
	dprint(ftos(self.ammo_lava_nails));
	dprint(", Multi-Rockets: ");
	dprint(ftos(self.ammo_multi_rockets));
	dprint(", Plasma: ");
	dprint(ftos(self.ammo_plasma));
	dprint(", Bolts: ");
	dprint(ftos(self.ammo_bolts));
	dprint(", Poison: ");
	dprint(ftos(self.ammo_poison));
	dprint("\n");
	dprint(", Blood Crystals: ");
	dprint(ftos(self.ammo_bloodcrystals));
	dprint(", Void Shards: ");
	dprint(ftos(self.ammo_voidshards));
	dprint(", Elemental Mana: ");
	dprint(ftos(self.ammo_elemental));
	dprint("\n");
	dmg = dmg + (self.ammo_shells * DAMAGE_SHELL);
	dmg = dmg + (self.ammo_nails * DAMAGE_NGSPIKE);
	dmg = dmg + (self.ammo_lava_nails * DAMAGE_LAVANGSPIKE);
	dmg = dmg + (self.ammo_rockets * DAMAGE_PLAYGRENADE);
	dmg = dmg + (self.ammo_multi_rockets * DAMAGE_PLAYGRENADE);
	dmg = dmg + (self.ammo_cells * DAMAGE_LGPLAYER);
	dmg = dmg + (self.ammo_plasma * plasmad.x);
	dmg = dmg + (self.ammo_bolts * DAMAGE_BOLTPLAYER);
	dmg = dmg + (self.ammo_poison * DAMAGE_BOLTPLAYERP);
	dmg = dmg + (self.ammo_bloodcrystals * DAMAGE_BOLTPLAYERP);
	dmg = dmg + (self.ammo_voidshards * DAMAGE_BOLTPLAYERP);
	dmg = dmg + (self.ammo_elemental * DAMAGE_BOLTPLAYERP);
	dprint("Estimated Player Damage Points:: ");
	dprint(ftos(dmg));
	dprint("\n");
	dprint("World Enemy Health Sum:: ");
	dprint(ftos(self.enemyhealth));
	dprint("\n");
	dprint("World Items Health Sum:: ");
	dprint(ftos(self.health));
	dprint("\n");
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

entity () ammohealthsum { // [FUNCTION]
	entity e;
	e = spawn();
	e.classname = "info_devdata";
	e.think = amsumthink;
	e.nextthink = time + 5; // give plenty of time to add all the sums up after everything spawned in.
	return e;
};