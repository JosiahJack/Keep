
void() InitBodyQue;
//JIM
void() InitBulletHoles;


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

//MED
//Added Hipnotic Pack
/*
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
	precache_file2 ("gfx/pop.lmp");

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
*/
   precache_file ("maps/start.bsp");

   precache_file ("maps/hip1m1.bsp");
   precache_file ("maps/hip1m2.bsp");
   precache_file ("maps/hip1m3.bsp");
   precache_file ("maps/hip1m4.bsp");
   precache_file ("maps/hip1m5.bsp");
   precache_file ("maps/hip2m1.bsp");
   precache_file ("maps/hip2m2.bsp");
   precache_file ("maps/hip2m3.bsp");
   precache_file ("maps/hip2m4.bsp");
   precache_file ("maps/hip2m5.bsp");
   precache_file ("maps/hip2m6.bsp");
   precache_file ("maps/hip3m1.bsp");
   precache_file ("maps/hip3m2.bsp");
   precache_file ("maps/hip3m3.bsp");
   precache_file ("maps/hip3m4.bsp");
   precache_file ("maps/hipdm1.bsp");
   precache_file ("maps/hipend.bsp");
   precache_file ("maps/zoo.bsp");
   precache_file ("maps/mark.bsp");
};


entity	lastspawn;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================

void() worldspawn =
{
   lastspawn = world;
	InitBodyQue ();

//JIM
   InitBulletHoles();

if (autocvar_chasecam_death_view)	// necessary for loading a saved game !
	{
	cvar_set ("chase_active", "0");
	cvar_set ("chase_back", "48");
	cvar_set ("chase_up", "24");
	cvar_set ("chase_overhead", "0");
	}

// custom map attributes
	if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");

// the area based ambient sounds MUST be the first precache_sounds

// player precaches
	W_Precache ();			// get weapon precaches

// sounds used from C physics code
	precache_sound ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash
	precache_sound ("zombie/z_hit.wav");            // used for gibbable corpse sound

// setup precaches allways needed

	precache_model ("progs/null.spr"); 	// null entity for flashlight
	precache_sound ("player/click.wav");	// sound for flashlight

	if (autocvar_backpack == 2)
	{
		precache_model ("progs/backpack_soldier.mdl");		// ammo custom pick up
		precache_model ("progs/backpack_enforcer.mdl");		// ammo custom pick up
		precache_model ("progs/backpack_ogre.mdl");		// ammo custom pick up
		precache_sound ("ambience/backpack_soldier.wav");	// ammo custom pick up
		precache_sound ("ambience/backpack_enforcer.wav");	// ammo custom pick up
		precache_sound ("ambience/backpack_ogre.wav");		// ammo custom pick up
		precache_sound ("ambience/backpack_enforcer_ambience.wav");	// enforcer custom cell ambience sound while flying in air
	}
	precache_model ("progs/corpse_pent.mdl");
	precache_sound ("zombie/corpse_lit.wav");
	precache_sound ("zombie/corpse_fire.wav");
	precache_sound ("player/inflame.wav");

	if ((autocvar_gruntcasing) || (autocvar_shellcasing))
	{
		precache_model ("progs/casing.mdl");
		precache_sound ("weapons/casings1.wav");
		precache_sound ("weapons/casings2.wav");
		precache_sound ("weapons/casings3.wav");
	}
	precache_sound ("weapons/weapon1.wav");
	precache_sound ("weapons/weapon2.wav");
	precache_sound ("weapons/weapon3.wav");
	precache_sound ("weapons/weapon4.wav");
	precache_sound ("weapons/weapon5.wav");
	precache_sound ("weapons/weapon6.wav");
	precache_sound ("weapons/weapon6_prox.wav");
	precache_sound ("weapons/weapon7.wav");
	precache_sound ("weapons/weapon8.wav");
	precache_sound ("weapons/weapon9_laser.wav");
	precache_sound ("weapons/weapon10_mjolnir.wav");
	precache_sound ("ambience/coaled_monster_explode.wav");
	precache_sound ("misc/null.wav");

	precache_sound ("kickgib/gib_miss.wav");        // used for kickgib sound
	precache_sound ("kickgib/gib_hit.wav");         // used for kickgib sound
	precache_sound ("player/gibexplode.wav");  
	precache_sound ("kickgib/kick_debris1.wav");    // used for kick debris sound
	precache_sound ("kickgib/kick_debris2.wav");    // used for kick debris sound
	precache_sound ("kickgib/kick_debris3.wav");    // used for kick debris sound
	precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");		// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	if ((world.model != "maps/start.bsp") && ((autocvar_spider_replace_demon)||(autocvar_spider_replace_dog)||(autocvar_spider_replace_enforcer)||(autocvar_spider_replace_hknight)||(autocvar_spider_replace_knight)||(autocvar_spider_replace_ogre)||(autocvar_spider_replace_shalrath)||(autocvar_spider_replace_shambler)||(autocvar_spider_replace_soldier)||(autocvar_spider_replace_tarbaby)||(autocvar_spider_replace_zombie)||(autocvar_spider_replace_gremlin)||(autocvar_spider_replace_scourge)))
	{
		precache_model ("progs/spider.mdl");
		precache_model ("progs/h_spider.mdl");
		precache_model ("progs/gib_spider1.mdl");
		precache_model ("progs/gib_spider2.mdl");
		precache_model ("progs/gib_spider3.mdl");
		precache_model ("progs/spider_shambler.mdl");
		precache_model ("progs/h_spider_shambler.mdl");
		precache_model ("progs/gib_spider1_shambler.mdl");
		precache_model ("progs/gib_spider2_shambler.mdl");
		precache_model ("progs/gib_spider3_shambler.mdl");
		precache_model ("progs/web.mdl");
		precache_sound ("spider/spider_walk1.wav");
		precache_sound ("spider/spider_walk2.wav");
		precache_sound ("spider/spider_sight.wav");
		precache_sound ("spider/spider_idle.wav");
		precache_sound ("spider/spider_bite.wav");
		precache_sound ("spider/spider_headbang.wav");
		precache_sound ("spider/spider_legattack.wav");
		precache_sound ("spider/spider_jump.wav");
		precache_sound ("spider/spider_spit.wav");
		precache_sound ("spider/spider_impact.wav");
		precache_sound ("spider/spider_pain.wav");
		precache_sound ("spider/spider_death.wav");
	}

	if ((world.model != "maps/start.bsp") && ((autocvar_warlord_replace_hknight)||(autocvar_warlord_replace_ogre)))
	{
		precache_model ("progs/warlord.mdl");	
		precache_model ("progs/h_warlord.mdl");
		precache_model ("progs/k_spike2.mdl");
		precache_model ("progs/h_grenade2.mdl");	
		precache_model ("progs/h_grenade1.mdl");	
		precache_model ("progs/face.mdl");

		precache_sound ("warlord/attack1.wav");	
		precache_sound ("warlord/attack2.wav");	
		precache_sound ("warlord/attack3.wav");	
		precache_sound ("warlord/death1.wav");
		precache_sound ("warlord/pain1.wav");
		precache_sound ("warlord/pain2.wav");
		precache_sound ("warlord/sight1.wav");
		precache_sound ("warlord/slash1.wav");
		precache_sound ("warlord/idle.wav");
		precache_sound ("warlord/growl.wav");
		precache_sound ("warlord/ram.wav");
		precache_sound ("warlord/throw.wav");
		precache_sound ("warlord/fall.wav");
		precache_sound ("warlord/homing.wav");
		precache_sound ("warlord/homing_shot.wav");
		precache_sound ("warlord/homing_pain.wav");
		precache_sound ("warlord/homing_touch.wav");
		precache_sound ("walk/hknight1.wav");
		precache_sound ("walk/hknight2.wav");
		precache_sound ("walk/hknight3.wav");

		precache_sound ("knight/sword1.wav");
		precache_sound ("knight/sword2.wav");
	}

	precache_model ("progs/ghost.mdl");
	precache_sound ("ghost/ghost.wav");

	if (world.model != "maps/start.bsp")
	{
		precache_model ("progs/afrit.mdl");
		precache_model ("progs/h_afrit.mdl");
		precache_model ("progs/gib_afrit.mdl");
		precache_model ("progs/k_spike.mdl");
		precache_sound ("afrit/attack.wav");
		precache_sound ("afrit/awake.wav");
		precache_sound ("afrit/death.wav");
		precache_sound ("afrit/body_explode.wav");
		precache_sound ("afrit/idle.wav");
		precache_sound ("afrit/pain1.wav");
		precache_sound ("afrit/pain2.wav");
		precache_sound ("afrit/sight.wav");
		precache_sound ("afrit/wingsflap.wav");
		precache_sound ("afrit/fireballtouch.wav");

		precache_model ("progs/skull.mdl");
		precache_sound ("vengeance/shalthrow.wav");  
		precache_sound ("vengeance/shamawake.wav"); 
		precache_sound ("vengeance/shamattck1.wav");  
		precache_sound ("vengeance/hknightmag.wav");
		precache_sound ("hknight/attack1.wav");

		precache_model ("progs/wings.mdl");
		precache_sound ("soul/liftup.wav");
		precache_sound ("soul/flash.wav");
		precache_sound ("soul/wingsflap.wav");
		precache_sound ("soul/wingshot.wav");
		precache_sound ("soul/awake.wav");
	
		precache_model ("progs/hydra.mdl");
		precache_model ("progs/w_spike.mdl");
		precache_sound ("hydra/hydra_death.wav");
		precache_sound ("hydra/spit_impact_player.wav");
		precache_sound ("hydra/hydra_pain.wav");
		precache_sound ("hydra/hydra_spit.wav");
		precache_sound ("hydra/hydra_idle.wav");
		precache_sound ("hydra/hydra_idle2.wav");
		precache_sound ("hydra/hydra_tent.wav");
	}

	if (autocvar_evil_faces == 2)
	{
		precache_model ("progs/face.mdl");
		precache_sound ("face/face_pain.wav");
		precache_sound ("face/face.wav");
		precache_sound ("face/face_touch.wav");
	}
	
	if (autocvar_player_legs_visibility)
	{
		precache_model ("progs/player_legs1.mdl");
		precache_model ("progs/player_legs2.mdl");
		precache_model ("progs/player_legs_ham1.mdl");
		precache_model ("progs/player_legs_ham2.mdl");
	}

	precache_sound ("ambience/rumblefade.wav");
	precache_sound ("misc/talk.wav");		// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start
	precache_sound ("items/damage3.wav");

	precache_sound ("misc/power.wav");		//lightning for boss

	var float autocvar_powerupcountdown = 0;	// starts a powerup countdown when enabled
	if ( autocvar_powerupcountdown == 1 )
		powerup_countdown = 1;

	var float autocvar_invisibleweapons = 1;	// makes view_weapons visible when enabled during ring of invisibility phase (with only 30% opaqueness)  
	if ( autocvar_invisibleweapons != 0 )
		invisweapon = 1;

//	var float autocvar_psycho = 0;	 		// visual screen effect when picking up quad and/or pent   0= disabled  1= enable when picking up quad   2= enable when picking up pent   3= enable when picking up quad OR pent
	if ( autocvar_psycho == 1 )			// only works in Windows XP ?!
		quadpsycho = 1;
	if ( autocvar_psycho == 2 )
		pentpsycho = 1;
	if ( autocvar_psycho == 3 )
	{
		quadpsycho = 1;
		pentpsycho = 1;
	}

	var float autocvar_welcome = 1;			// Displays a welcome text when starting Quake  
	if ( autocvar_welcome != 0 )
		welcomenote = 1;

// player gib sounds
	precache_sound ("player/gib.wav");		// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

// rain sounds
	precache_sound ("ambience/thunderrain.wav");   	//  added for thunderrain sound
	precache_sound ("ambience/rain.wav");    	//  added for rain sound

// ax sounds
	precache_sound ("weapons/ax1.wav");		// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

// new axe sounds
	precache_sound ("player/axeflesh1.wav");	// ax hit monster
	precache_sound ("player/axeflesh2.wav");	// ax hit monster
	precache_sound ("player/axeflesh3.wav");	// ax hit monster
// heartbeat sound for gibs
	precache_sound("ambience/gibheartbeat.wav");	// precache gib heartbeat sound

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");		// swimming
	precache_sound ("misc/water2.wav");		// swimming

	precache_sound ("walk/generic1.wav");      
	precache_sound ("walk/generic2.wav");      
	precache_sound ("walk/generic3.wav");      
	precache_sound ("walk/generic4.wav");
	precache_sound ("walk/generic5.wav");
	precache_sound ("walk/metal1.wav");      
	precache_sound ("walk/metal2.wav");      
	precache_sound ("walk/metal3.wav");      
	precache_sound ("walk/metal4.wav"); 
	precache_sound ("walk/waterwade1.wav");      
	precache_sound ("walk/waterwade2.wav");      

//MED 10/21/96 added flies sound
   precache_sound ("misc/flys.wav");
//MED 01/13/97 added explosion sounds
   precache_sound ("misc/shortexp.wav");
   precache_sound ("misc/longexpl.wav");
   precache_sound ("misc/foot1.wav");
   precache_sound ("misc/foot2.wav");
   precache_sound ("misc/foot3.wav");
   precache_sound ("misc/foot4.wav");
   precache_sound ("misc/foot5.wav");
   precache_sound ("misc/foot6.wav");
   precache_sound ("misc/foot7.wav");

   precache_model ("progs/player.mdl");
	if (autocvar_3rd_person_visible_weapons)
	{	
		precache_model ("progs/player_shot.mdl");
		precache_model ("progs/player_shot2.mdl");
		precache_model ("progs/player_nail.mdl");
		precache_model ("progs/player_nail2.mdl");		
		precache_model ("progs/player_rock.mdl");		
		precache_model ("progs/player_rock2.mdl");		
		precache_model ("progs/player_light.mdl");		
		precache_model ("progs/player_multi.mdl");		
	}
	precache_model ("progs/eyes.mdl");
	precache_model ("progs/h_player.mdl");
	precache_model ("y");
//MED 12/03/96 added player with hammer
   precache_model ("progs/playham.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");
	precache_model ("progs/gibby.mdl");
	precache_model ("progs/gibheart.mdl");
	
	if (autocvar_debris)
	{
		precache_model ("progs/debris1.mdl");
		precache_model ("progs/debris2.mdl");
		precache_model ("progs/debris3.mdl");
		precache_model ("progs/debris4.mdl");
		precache_model ("progs/debris5.mdl");
		precache_model ("progs/debris6.mdl");
		precache_model ("progs/debris7.mdl");
		precache_model ("progs/debris8.mdl");
		precache_model ("progs/debris9.mdl");
		precache_model ("progs/debris10.mdl");
	}
	precache_model ("progs/s_bubble.spr");		// drowning bubbles
	precache_model ("progs/s_explod.spr");		// sprite explosion

	precache_model ("progs/v_axe.mdl");
	if (autocvar_zombieaxeanimation == 1)		// Axe is animated when aiming at new zombies
	{
		precache_model ("progs/v_axe_zombie01.mdl");	// for zombie animated axe
		precache_model ("progs/v_axe_zombie00.mdl");	// for zombie animated axe
	}
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");
//MED 10/31/96 added precache for hip view models
   precache_model ("progs/v_laserg.mdl");
   precache_model ("progs/v_hammer.mdl");
   precache_model ("progs/v_prox.mdl");
   precache_model ("progs/proxbomb.mdl");

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");	// for testing
//MED 10/18/96 added precache for laser cannon
   precache_model ("progs/lasrspik.mdl");

	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/v_light.mdl");


//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	lightstyle(0, "m");

	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");

	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");

	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");

	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");

	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");

	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");

	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");

	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");

	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");

	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");

	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");

//JIM
	StopEarthQuake();
//MED
   if (cvar("crosshair") == 2)
      footsteps = 1;
   else
      footsteps = 0;
   };

void() StartFrame =
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;

Gyro_Run();
};

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

void() bodyque =
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};

void() InitBodyQue =
{
local entity e, prev;
local float numBodies, num;
numBodies = 200; // how many corpses to allow in the world at once

num = 0;
prev = world;
bodyque_head = world;
while(num < numBodies)
{
// Spawn another body
e = spawn();
e.classname = "bodyque";

//	Gyro_Object_Activate(e, 1500);     // WORKS as well

// If this is the first, set the bodyque_head pointer (start of the list)
if(bodyque_head == world)
bodyque_head = e;
// Link up to previous item to form the linked list
if(prev != world)
e.owner = prev;
// Point prev to the new item
prev = e;

// Track how many we've made so we don't have an infinite loop
num = num + 1;
}

// Now that all corpse entities are created, turn the linked list into a linked loop
bodyque_head.owner = prev;
}; 


void() baked_explode =
{
if ((self.netname == "progs/h_spider.mdl") || (self.netname == "progs/h_dog.mdl") || (self.netname == "progs/h_dog1.mdl") || (self.netname == "progs/h_dog_extended.mdl") || (self.netname == "progs/h_grem.mdl") || (self.netname == "progs/h_grem1.mdl"))
	pointparticles(particleeffectnum("baked_explode_small"), self.origin, '0 0 0', 1);
else if ((self.netname == "progs/h_shams.mdl") || (self.netname == "progs/h_shams1.mdl") || (self.netname == "progs/h_spider_shambler.mdl"))
	pointparticles(particleeffectnum("baked_explode_shambler"), self.origin, '0 0 0', 1);
else if ((self.netname == "progs/h_demon.mdl") || (self.netname == "progs/h_demon1.mdl") || (self.netname == "progs/h_hellkn.mdl") || (self.netname == "progs/h_hellkn1.mdl") || (self.netname == "progs/h_ogre.mdl") || (self.netname == "progs/h_ogre1.mdl") || (self.netname == "progs/h_shal.mdl") || (self.netname == "progs/h_shal1.mdl"))
	pointparticles(particleeffectnum("baked_explode_large"), self.origin, '0 0 0', 1);
else
	pointparticles(particleeffectnum("baked_explode"), self.origin, '0 0 0', 1);
sound (self, CHAN_AUTO, "ambience/coaled_monster_explode.wav", 1, ATTN_NORM);

if ((self.netname == "progs/h_guard.mdl") || (self.netname == "progs/h_guard1.mdl"))
	{
	self.ammo_shells = autocvar_backpack_soldier_shells;	// default 5
	self.backpack_thrower = 1;
	DropBackpack();
	}
if ((self.netname == "progs/h_ogre.mdl") || (self.netname == "progs/h_ogre1.mdl"))
	{
	self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
	self.backpack_thrower = 3;
	DropBackpack();
	}
if ((self.netname == "progs/h_mega.mdl") || (self.netname == "progs/h_mega1.mdl"))
	{
	self.ammo_cells = autocvar_backpack_enforcer_cells;	// default 5
	self.backpack_thrower = 2;
	DropBackpack();
	}
remove(self);
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere

void(entity ent, float hp, string headmdl) CopyToBodyQue = 
{
bodyque_head.i_am_a_corpse = 1;
bodyque_head.baked = self.baked;
bodyque_head.skin = self.skin;			// to set the correct skin on corpse (was necessary due to multiskin-support)
bodyque_head.colormod = self.colormod;		// to keep the visual settings from living monster on dead monster (when killed in lava/slime)
bodyque_head.traileffectnum  = self.traileffectnum;
bodyque_head.burnable_corpse = self.burnable_corpse;
bodyque_head.original_frame = self.frame;	// needed for ragdoll
bodyque_head.enemy = self.enemy; 
bodyque_head.scale = self.scale; 		// needed for  random monster size  feature
if (random() < 0.5)
	bodyque_head.spin_direction = 0;	// corpse will spin counter-clockwise when shot
else
	bodyque_head.spin_direction = 1;	// corpse will spin clockwise when shot

bodyque_head.angles = ent.angles;
bodyque_head.model = ent.model;
bodyque_head.modelindex = ent.modelindex;
bodyque_head.frame = ent.frame;
bodyque_head.colormap = ent.colormap;
// bodyque_head.movetype = ent.movetype;
bodyque_head.velocity = ent.velocity;
bodyque_head.flags = 0;
setorigin (bodyque_head, ent.origin);

// Gibbable Corpses: make bodyqueue damagable

// enforce a minimum size for the corpse, so there's something to shoot
local vector minsiz, maxsiz;
minsiz = ent.mins;
maxsiz = ent.maxs;
if (bodyque_head.baked != 1)	// only baked monster will stand tall/straight, regular killed monsters are lying on the floor !
	{			// so we ignore the bbox -z reduction for baked monsters
	minsiz_z = ent.mins_z;
	maxsiz_z = ent.mins_z + 17;  // set this to how tall you want the corpse hitbox (was +15 in smc V3.1)
	}
setsize (bodyque_head, minsiz, maxsiz); 

//// GYRO code below
Gyro_Object_ClearPhysics(self);
Gyro_Object_ClearPhysics(bodyque_head);
	var float autocvar_gyroset = 2;		// set cvar 'gyroset' default to 2
	if (autocvar_gyroset > 0)		// if 'gyroset' is set to '0', Gyro is not enabled
		{
		var float autocvar_corpsemass = 2700;
		Gyro_Object_Activate (bodyque_head, autocvar_corpsemass);
		}

bodyque_head.health = hp;
if(hp == 0) 	// If HP is set via cvar 'corpsehealth' to "0", corpses are not gibbable
	{
	bodyque_head.takedamage = DAMAGE_NO;
	bodyque_head.solid = SOLID_NOT;
	}
else
	{
	bodyque_head.takedamage = DAMAGE_AIM;
	bodyque_head.solid = SOLID_SLIDEBOX;
	}
if (bodyque_head.baked == 1)
	{
	bodyque_head.th_die = baked_explode;
	bodyque_head.nextthink = time + autocvar_coaled_monster_lifetime;
	bodyque_head.think = baked_explode;
	}
else
	bodyque_head.th_die = corpse_die;
bodyque_head.th_pain = corpse_pain;
bodyque_head.semisolid = "y";
bodyque_head.movetype = MOVETYPE_TOSS;
bodyque_head.netname = headmdl;
bodyque_head = bodyque_head.owner;
}; 


void(float hp, string headmdl) CopyMonsterToBodyQue = 
{
CopyToBodyQue(self, hp, headmdl); 
self.model = ""; // hide real monster
self.think = SUB_Null; // don't repeat the last death frame for eternity (monsters)
};


void(float maxgibs, float gibscounter) producegibs_corpse =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	if (self.netname == "progs/h_spider.mdl")
		{		
		ThrowGibSpider ("progs/gib_spider1.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider2.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider3.mdl", self.health, self.skin);   	
		}
	else if (self.netname == "progs/h_spider_shambler.mdl")
		{
		ThrowGibSpider ("progs/gib_spider1_shambler.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider2_shambler.mdl", self.health, self.skin);
		ThrowGibSpider ("progs/gib_spider3_shambler.mdl", self.health, self.skin);   	
		}
	else
		{		
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);   	
		}
	}

gibscounter = gibscounter + 1;
producegibs_corpse (maxgibs, gibscounter);
};


void(string gibname, float dm) removehead =
{
	self.nextthink = time + 0.001;
	self.think = SUB_Remove;	
};


void() pentagram_touch;

void() pentagram_touch_delay =
{
	self.touch = pentagram_touch;
	self.nextthink = time + 20;	// remove after 20 seconds
	self.think = SUB_Remove;
};

void() pentagram_touch =
{
	if (other.classname != "player")
		return;
	self.touch = SUB_Null;   	// to avoid overflow
	if (autocvar_corpseburnpentagram_health)
	{
		self.healamount_old = self.healamount;		// detect the current health amount (to be able to do calculations later on)
		local	string	s;
		if (T_Heal(other, self, 0))
		{
			sound (self, CHAN_VOICE, "zombie/penttouch.wav", 1, ATTN_NORM);
			te_customflash (self.origin + '0 0 25', 666, 0.7, '1 0 0');
			if (autocvar_lossless_health_pickup)
			{
				sprint (other, "You received ");	// rewritten notification message code, to exactly calculate how many health points the player really received, and
				if (!self.crate_is_empty)		// if the pent is not completely used up, tell him.
					s = ftos(self.healamount_old - self.healamount);
				else
					s = ftos(self.healamount_old);
				sprint (other, s);
				sprint (other, " health");
				if (!self.crate_is_empty)
				{
					sprint (other, ". Max health reached. ");
					s = ftos(self.healamount);
					sprint (other, s);
					sprint (other, " health remaining.");
				}
				sprint (other, "\n");
			}
			else
			{
				sprint(other, "You receive ");
				s = ftos(self.healamount);
				sprint(other, s);
				sprint(other, " health\n");
			}	
		}
		else
		{
			sprint (other, "You already have max. health.\n");
		}
		
		if (autocvar_lossless_health_pickup)
		{
			if (self.crate_is_empty == 1)			// player used up complete health amount
			{	
				self.nextthink = time + 0.01;
				self.think = SUB_Remove;	
			}
			else		// health amount is not yet emtpy, so leave model in game until it is fully used up.
			{
				self.touch = SUB_Null;		//  to avoid overflows
				self.nextthink = time + 1.5;	//  delay next pickup of this pent, in case player stands inside it and gets injured
				self.think = pentagram_touch_delay;
			}
		}
		else
		{
			sound (self, CHAN_VOICE, "zombie/penttouch.wav", 1, ATTN_NORM);
			te_customflash (self.origin + '0 0 25', 666, 0.7, '1 0 0');
			self.nextthink = time + 0.01;
			self.think = SUB_Remove;	
		}
	}
	else
	{
		sound (self, CHAN_VOICE, "zombie/penttouch.wav", 1, ATTN_NORM);
		te_customflash (self.origin + '0 0 25', 666, 0.7, '1 0 0');
		self.nextthink = time + 0.01;
		self.think = SUB_Remove;	
	}
};

void () control_position_pentagram =
{
	self.origin = self.origin - '0 0 0.06';	// necessary to compensate the z-velocity upwards (which is again necessary to make the model able to "move")
	self.pent_counter = self.pent_counter + 1;
	if (self.pent_counter >= 16)		// if pentagram is not touched, remove it after approx. 20 seconds
		remove (self);
	self.nextthink = time + 1.3;
	self.think = control_position_pentagram; 
};

void() spawn_corpse_pentagram =
{
	local entity pentagram;
	pentagram = spawn ();
	pentagram.movetype = MOVETYPE_FLY;
	pentagram.solid = SOLID_TRIGGER;
	pentagram.velocity = '0 0 0.05';
	pentagram.avelocity = '0 40 0';
	pentagram.scale = 0.75;
	pentagram.touch = pentagram_touch;
	setmodel (pentagram, "progs/corpse_pent.mdl");
	setsize (pentagram, '-10 -10 -18', '10 10 40');		
	setorigin (pentagram, self.origin - '0 0 37');
	precache_sound ("zombie/penttouch.wav");
	pentagram.traileffectnum = particleeffectnum("corpse_pentagram");	
	pentagram.healamount = autocvar_corpseburnpentagram_health;	// default is 5
	pentagram.initial_amount = self.healamount;
	pentagram.nextthink = time + 0.1;
	pentagram.think = control_position_pentagram;	

	sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
	self.nextthink = time + 0.01;
	self.think = SUB_Remove;	
};


void() corpse_fade =		// this code makes the corpse fade away while burning !  (Independent to burntime !  That was a hard nutshell...)
{
local float countdown;
self.magiccounter = self.magiccounter - 1;
countdown = 1/(autocvar_corpseburntime * 12);

if (self.magiccounter >= 0)
	{
	self.alpha = self.alpha - countdown; 
	self.think = corpse_fade;
	self.nextthink = time + 0.1;
	}
else
	{
	if (autocvar_corpseburnpentagram == 1)		// only spawn pentagram, when cvar is 1
		{
		self.think = spawn_corpse_pentagram;
		self.nextthink = time;
		}
	else
		{
		sound (self, CHAN_WEAPON, "misc/null.wav", 1, ATTN_NORM);
		self.think = SUB_Remove;	
		self.nextthink = time;
		}
	}
};


void() corpse_die =
{
local float maxgibs, gibscounter;
local vector check;
self.gorging = FALSE;
sound (self, CHAN_VOICE, "zombie/z_hit.wav", 1, ATTN_NORM);
self.semisolid = "n";      // needed to make the head-gib kickable

var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1

if (self.netname == "newzombie")   		//  check if call comes from newzombie
{
	self.netname = "progs/h_zombie_new.mdl";
	check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';

	if ((autocvar_zombienewmodelburnable == 1)&&(pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME))	// corpses are burnable if cvar is set accordingly and corpse is NOT in water/slime
		{
		if (autocvar_corpseburntime)		// to prevent mini-flames when cvar == 0
			self.traileffectnum = particleeffectnum("corpse_burn");
		self.colormod = '0.40 0.25 0.25';	// skins gets darker (looks burned)
		sound (self, CHAN_VOICE, "zombie/corpse_lit.wav", 1, ATTN_NORM);	 	// play ignition sound
		sound (self, CHAN_WEAPON, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	// play fire loop sound
		self.alpha = 1;
		self.magiccounter = autocvar_corpseburntime * 10;
		self.think = corpse_fade;
		self.nextthink = time;
		return;
		}
	else
		{
		if (autocvar_slowmotion >= 2)	// start slowmotion when gibbing corpses
			{
			if (random () <= (autocvar_slowmotion_randomness_corpse * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		self.scale = 1.4;
		if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
			{
			ThrowHead (self.netname, self.health); 
			ThrowGib ("progs/gib1.mdl", self.health);
			ThrowGib ("progs/gib2.mdl", self.health);
			ThrowGib ("progs/gib3.mdl", self.health);
			if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
				pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
			return;
			}
		else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
			{						// --> produce more gibs
			ThrowHead (self.netname, self.health); 
			if (autocvar_bloodextension == 1)		// if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
				pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
			maxgibs = autocvar_gibsmultiplier;
			gibscounter = 0;
			producegibs_corpse (maxgibs, gibscounter);
			return;
			}
		}
}
	
else if (self.netname == "newzombieheadless")   	//  check if call comes from headless newzombie
{
	self.netname = "progs/h_zombie_new.mdl";
	check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';

	if ((autocvar_zombienewmodelburnable == 1)&&(pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME))		// corpses are burnable if cvar is set accordingly and corpse is NOT in water/slime
		{
		if (autocvar_corpseburntime)		// to prevent mini-flames when cvar == 0
			self.traileffectnum = particleeffectnum("corpse_burn");
		self.colormod = '0.40 0.25 0.25';	// skins gets darker (looks burned)
		sound (self, CHAN_VOICE, "zombie/corpse_lit.wav", 1, ATTN_NORM);
		sound (self, CHAN_WEAPON, "zombie/corpse_fire.wav", 1, ATTN_NORM);
		self.alpha = 1;
		self.magiccounter = autocvar_corpseburntime * 10;
		self.think = corpse_fade;
		self.nextthink = time;
		return;
		}
	else
		{
		if (autocvar_slowmotion >= 2)	// start slowmotion when gibbing corpses
			{
			if (random () <= (autocvar_slowmotion_randomness_corpse * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
			{
			removehead(self.netname, self.health);
			ThrowGib ("progs/gib1.mdl", self.health);
			ThrowGib ("progs/gib2.mdl", self.health);
			ThrowGib ("progs/gib3.mdl", self.health);
			if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
				pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
			return;
			}
		else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
			{						// --> produce more gibs
			removehead(self.netname, self.health);
			if (autocvar_bloodextension == 1)		// if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
				pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
			maxgibs = autocvar_gibsmultiplier;
			gibscounter = 0;
			producegibs_corpse (maxgibs, gibscounter);
			return;
			}
		}
}

check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
if ((self.burnable_corpse == 1)&&(pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME))		// corpses are burnable if cvar is set accordingly and corpse is NOT in water/slime
	{
	if (autocvar_corpseburntime)		// to prevent mini-flames when cvar == 0
		self.traileffectnum = particleeffectnum("corpse_burn");
	self.colormod = '0.40 0.25 0.25';	// skins gets darker (looks burned)
	sound (self, CHAN_VOICE, "zombie/corpse_lit.wav", 1, ATTN_NORM);	 	// play ignition sound
	sound (self, CHAN_WEAPON, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	// play fire loop sound
	self.alpha = 1;
	self.magiccounter = autocvar_corpseburntime * 10;
	self.think = corpse_fade;
	self.nextthink = time;
	return;
	}
else
	{
	if (autocvar_slowmotion >= 2)	// start slowmotion when gibbing corpses
		{
		if (random () <= (autocvar_slowmotion_randomness_corpse * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
		{
		ThrowHead (self.netname, self.health); 
		if (self.netname == "progs/h_spider.mdl")
			{		
			ThrowGibSpider ("progs/gib_spider1.mdl", self.health, self.skin);
			ThrowGibSpider ("progs/gib_spider2.mdl", self.health, self.skin);
			ThrowGibSpider ("progs/gib_spider3.mdl", self.health, self.skin);   	
			}
		else if (self.netname == "progs/h_spider_shambler.mdl")
			{
			ThrowGibSpider ("progs/gib_spider1_shambler.mdl", self.health, self.skin);
			ThrowGibSpider ("progs/gib_spider2_shambler.mdl", self.health, self.skin);
			ThrowGibSpider ("progs/gib_spider3_shambler.mdl", self.health, self.skin);   	
			}
		else
			{
			ThrowGib ("progs/gib1.mdl", self.health);
			ThrowGib ("progs/gib2.mdl", self.health);
			ThrowGib ("progs/gib3.mdl", self.health);
			if (autocvar_heartgib == 2)		// if 'heartgib' is set via autoexec.cfg to '2', spawn a 'NOT-Beating' heartgib
				ThrowGib ("progs/gibheart.mdl", self.health);
			else if (autocvar_heartgib == 3)	// if 'heartgib' is set via autoexec.cfg to '3', spawn a 'Beating' heartgib
				ThrowHeart ("progs/gibheart.mdl", self.health);
			}
		if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
			pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
		return;
		}
	else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
		{						// --> produce more gibs
		ThrowHead (self.netname, self.health); 
		if (autocvar_bloodextension == 1)		// if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
			pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
		if ((self.netname != "progs/h_spider.mdl") && (self.netname != "progs/h_spider_shambler.mdl"))
			{		
			if (autocvar_heartgib == 2)		// if 'heartgib' is set via autoexec.cfg to '2', spawn a 'NOT-Beating' heartgib
				ThrowGib ("progs/gibheart.mdl", self.health);
			else if (autocvar_heartgib == 3)	// if 'heartgib' is set via autoexec.cfg to '3', spawn a 'Beating' heartgib
				ThrowHeart ("progs/gibheart.mdl", self.health);
			}
		maxgibs = autocvar_gibsmultiplier;
		gibscounter = 0;
		producegibs_corpse (maxgibs, gibscounter);
		return;
		}
	}
self.takedamage = DAMAGE_NO;
self.th_die = SUB_Null;
};


void() corpse_pain =
{
local float zuf;
	var float autocvar_corpsekillexplosives = 0;		// set cvar 'corpsekillexplosives' default to 0
	if (autocvar_corpsekillexplosives == 1)
		self.health = 60;		// make corpses only killable/gibbable with explosives (SSG cannot make 60 damage in one hit)
						// also quad damage powered weapons can kill corpses of course (because they do more than 60 damage in one hit)
	if (autocvar_bloodextension == 1)	// if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_corpse"), self.origin, '0 0 0', 1);

if ((autocvar_ragdoll == 1) && (self.netname != "progs/h_afrit.mdl"))	// use subtle ragdoll effect (only 1 frame) 
{				// make the body change his frame slightly ( = dummy/pseudo ragdoll for noobs)
	if (self.frame == self.original_frame)
		self.frame = self.original_frame - 1;
	else if (self.frame == (self.original_frame - 1))
		self.frame = self.original_frame;
	else if (self.frame == (self.original_frame - 2))	// can happen due to twitching effect
		self.frame = self.original_frame - 1;
}
else if ((autocvar_ragdoll == 2) && (self.netname != "progs/h_afrit.mdl"))	// use more intense ragdoll effect (up to 2 frames)
{				// make the body change his frame slightly ( = dummy/pseudo ragdoll for noobs)
	if (self.frame == self.original_frame)
		{
		zuf = random();
		if (zuf > 0.7)
			self.frame = self.original_frame - 1;
		else
			self.frame = self.original_frame - 2;
		}
	else if (self.frame == (self.original_frame - 1))
		{
		zuf = random();
		if (zuf > 0.5)
			self.frame = self.original_frame;
		else
			self.frame = self.original_frame - 2;
		}
	else if (self.frame == (self.original_frame - 2))
		{
		zuf = random();
		if (zuf > 0.3)
			self.frame = self.original_frame;
		else
			self.frame = self.original_frame - 1;
		}
}
else if ((autocvar_ragdoll == 3) && (self.netname != "progs/h_afrit.mdl"))	// use very intense ragdoll effect (up to 3 frames)
{				// make the body change his frame slightly ( = dummy/pseudo ragdoll for noobs)
	if (self.frame == self.original_frame)
		{
		zuf = random();
		if (zuf > 0.8)
			self.frame = self.original_frame - 1;
		else if (zuf > 0.6)
			self.frame = self.original_frame - 2;
		else 
			self.frame = self.original_frame - 3;
		}
	else if (self.frame == (self.original_frame - 1))
		{
		zuf = random();
		if (zuf > 0.8)
			self.frame = self.original_frame;
		else if (zuf > 0.6)
			self.frame = self.original_frame - 2;
		else
			self.frame = self.original_frame - 3;
		}
	else if (self.frame == (self.original_frame - 2))
		{
		zuf = random();
		if (zuf < 0.6)
			self.frame = self.original_frame;
		else if (zuf < 0.8)
			self.frame = self.original_frame - 1;
		else 
			self.frame = self.original_frame - 3;
		}
	else if (self.frame == (self.original_frame - 3))
		{
		zuf = random();
		if (zuf < 0.6)
			self.frame = self.original_frame;
		else if (zuf < 0.8)
			self.frame = self.original_frame - 1;
		else 
			self.frame = self.original_frame - 2;
		}
}

	if (autocvar_twitching_corpses)	
		self.twitch_finished = time + 2 + random();	// after shooting at corpses, be sure that there is a minimum time before corpse moves again by "Twitching Corpses" feature.

	self.just_been_shot = time + 0.2;			// resets the corpse into last frame again after 0.2 seconds to improve visual
};


void() SemisolidPreThink =
{
local entity e;
e = find (world, semisolid, "y");
while(e)
{
//bprint("Making object non-solid: ");
//bprint(e.classname);
//bprint("\n");
e.oldSolid = e.solid;
e.solid = SOLID_NOT;
e = find (e, semisolid, "y");
}
};

void() SemisolidPostThink =
{
// Semisolid: Make all semisolid objects (such as corpses) solid again, now that the player's move code is done.
local entity e;
e = find (world, semisolid, "y");
while(e)
{
if(e.oldSolid != -1)
e.solid = e.oldSolid;
e.oldSolid = -1;
if (e.spin_direction == 1)
	e.avelocity = '0 -77 0';	// spins the corpse when it gets shoot (Gyro) and is in air clockwise
else
	e.avelocity = '0 77 0';		// spins the corpse when it gets shoot (Gyro) and is in air counter-clockwise

	local vector check;
	check = (e.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';

var float autocvar_monsterlavaslime = 1;     	// set cvar 'monsterlavaslime' default to 1
	if (autocvar_monsterlavaslime >= 1)		// if 'monsterlavaslime' is '1' or higher 
	{
	if (pointcontents(check) == CONTENT_LAVA)		  // checks for lava
   		{
      		e.traileffectnum = particleeffectnum("monsterburn");	// adds particle effect to monsters when in lava (customize the effect in your effectinfo.txt)
			e.colormod = '0.4 0.1 0.1';					// change the color of the monster to  burned  dark red
	      }
   	if (pointcontents(check) == CONTENT_SLIME)		// checks for slime
   		{
      		e.traileffectnum = particleeffectnum("monsteracid");	//  adds particle effect to monsters when in slime (customize the effect in your effectinfo.txt)
			e.colormod = '0.3 1.6 0.3';					// change the color of the monster to  slimy/etchy  green
      	}
   	if ((pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA))	// needed to STOP the particle effect when monster moves (is kicked/shot) out of slime or lava !!
   		{
      		e.traileffectnum = particleeffectnum("monsternull");	//  REMOVES the particle effect from monsters (it is a null effect in your effectinfo.txt)
     		}
	}

var float autocvar_corpseflies = 1;     	// set cvar 'corpseflies' default to 1
	if (autocvar_corpseflies == 1)	// if 'corpseflies' is '1' 
		{
   		if ((pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA) && (pointcontents(check) != CONTENT_WATER))	// check if monster is out of slime or lava or water
	      	e.traileffectnum = particleeffectnum("monsterfliesblack");		//  adds BLACK flies to corpses (customize the effect in your effectinfo.txt)
		}
	if (autocvar_corpseflies == 2)	// if 'corpseflies' is '2' 
		{
   		if ((pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA) && (pointcontents(check) != CONTENT_WATER))	// check if monster is out of slime or lava or water
	      	e.traileffectnum = particleeffectnum("monsterfliesbrown");		//  adds BROWN flies to corpses (customize the effect in your effectinfo.txt)
		}

if (e.just_been_shot < time)		// if the corpse has just been shot (when ragdoll feature is enabled) reset it to last frame after 0.2 seconds.
	{
	e.frame = e.original_frame;
	e.just_been_shot = time + 9999;
	}
	

if (autocvar_twitching_corpses == 1)	// use subtle twitching (only 1 frame) 
{
if (e.twitch_finished < time)
	{
	if (e.twitch_back)
		{
		e.frame = e.original_frame;
		e.twitch_finished = time + autocvar_twitching_corpses_interval + random() + random() + random() + random();	// be sure that there is a minimum time between twitches
		e.twitch_back = 0;
		}
	else if (e.frame == e.original_frame)
		{
		e.frame = e.original_frame - 1;
		e.twitch_back = 1;
		e.twitch_finished = time + 0.2 + (random()*0.2);	// be sure that there is a minimum time between frames
		}
	}
}
else if (autocvar_twitching_corpses == 2)	// use more intense twitching (up to 2 frames) 
{
local float zuf;
if (e.twitch_finished < time)
	{
	if (e.twitch_back)
		{
		e.frame = e.original_frame;
		e.twitch_finished = time + autocvar_twitching_corpses_interval + random() + random() + random() + random();	// be sure that there is a minimum time between twitches
		e.twitch_back = 0;
		}
	else if (e.frame == e.original_frame)
		{
		zuf = random();
		if (zuf > 0.3)
			{
			e.frame = e.original_frame - 1;
			e.twitch_back = 1;
			e.twitch_finished = time + 0.2 + (random()*0.2);	// be sure that there is a minimum time between frames
			}
		else
			{
			e.frame = e.original_frame - 2;
			e.twitch_back = 2;
			e.twitch_finished = time + 0.2 + (random()*0.1);	// be sure that there is a minimum time between frames
			}
		}
	}
}

e = find (e, semisolid, "y");
}
}; 

