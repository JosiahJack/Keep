//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Qmaster
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
// Entity count: 0
// Function count: 1
//
// Implements: Precaches
//
// Description:
// This is called by worldspawn and precaches anything needed for the mod
// regardless of what entities are placed in the map.  This assumes that cheats
// may be used to give any item, weapon, etc. and precaches all related items.
//=============================================================================

void() precache_poisongibs;
float(string mname) monster_checkminion; // Used later by all monsters.  Must be last after all monsters.
void(string mname) precache_monster; // Used later by all monsters.  Must be last after all monsters.
void(string monstername, vector minion_org, entity minion_targ) SpawnMinion;
float(vector spot) SpawnMinionInRadius;

void() PreCache_Flame = {
	precache_model (MODEL_PROJ_FLAMETINY);		// 16 (wide) x  48 (high)
	precache_model (MODEL_PROJ_FLAMESML);		// 24 (wide) x  64 (high)
	precache_model (MODEL_PROJ_FLAMEMED);		// 32 (wide) x  96 (high)
	//precache_model (MODEL_PROJ_FLAMEVLRG);		// 48 (wide) x 128 (high)
	precache_sound("ambience/flames1.wav");
	precache_sound("ambience/flames2.wav");
	precache_sound("ambience/flames3.wav");
	precache_sound("ambience/flames4.wav");
};

void() PreCache_BlueFlame = {
	precache_model (MODEL_PROJ_BFLAMETINY);		// 16 (wide) x  48 (high)
	precache_model (MODEL_PROJ_BFLAMESML);		// 24 (wide) x  64 (high)
	precache_model (MODEL_PROJ_BFLAMEMED);		// 32 (wide) x  96 (high)
	//precache_model (MODEL_PROJ_BFLAMEVLRG);		// 48 (wide) x 128 (high)
	precache_sound("ambience/flames1.wav");
	precache_sound("ambience/flames2.wav");
	precache_sound("ambience/flames3.wav");
	precache_sound("ambience/flames4.wav");
};

void() PreCache_GreenFlame = {
	precache_model (MODEL_PROJ_GRFLAMETINY);		// 16 (wide) x  48 (high)
	precache_model (MODEL_PROJ_GRFLAMESML);		// 24 (wide) x  64 (high)
	precache_model (MODEL_PROJ_GRFLAMEMED);		// 32 (wide) x  96 (high)
	//precache_model (MODEL_PROJ_GRFLAMEVLRG);		// 48 (wide) x 128 (high)
	precache_sound("ambience/flames1.wav");
	precache_sound("ambience/flames2.wav");
	precache_sound("ambience/flames3.wav");
	precache_sound("ambience/flames4.wav");
};

void() PrecacheAll = { // [FUNCTION]
	precache_aoa();
	precache_poisongibs();
	precache_model("progs/backpack.mdl");
	precache_model("progs/qmaster/coinitem.mdl");
	precache_model("progs/null.mdl");
	precache_model("progs/spark.spr");
	precache_model("progs/drake/flame2.mdl");
	precache_model("progs/drake/flame2a.mdl");   // Flames
	precache_model("progs/custents/beamhit.spr");
	precache_model("progs/custents/dring.spr");
	precache_model("progs/k_spike.mdl");
	precache_model("progs/drake/s_explod.spr");
	precache_model("progs/quoth/smlexp.spr");
	precache_model("progs/quoth/medexp.spr");	// For dragon fire
	precache_model("progs/hipnotic/lasrspik.mdl");
	precache_model("progs/ne_ruins/proxbomb.mdl");
	precache_model("progs/its/v_crossbow1.mdl");
	precache_model("progs/its/v_crossbow2.mdl");
	precache_model("progs/drake/v_xbow.mdl");
	precache_model("progs/drake/arrow.mdl");
	precache_model("progs/hipnotic/v_prox.mdl");
	precache_model("progs/v_plasma2.mdl");
	precache_model("progs/v_lava.mdl");
	precache_model("progs/v_lava2.mdl");
	precache_model("progs/v_multi.mdl");
	precache_model("progs/v_multi2.mdl");
	precache_model("progs/drake/v_mirv.mdl");
	precache_model("progs/hipnotic/v_laserg.mdl");
	precache_model("progs/madfox/thr0wham.mdl");
	precache_model("progs/violentrumble/v_hammer.mdl"); //mjolnir
	precache_model("progs/violentrumble/v_hammerpw.mdl"); //mjolnir
	precache_model("progs/hipnotic/playham.mdl"); // player with the hammer
	precache_model("progs/drake/v_wand.mdl");
	precache_model("progs/drake/throwham.mdl");
	precache_model("progs/drake/s_wave.spr");
	precache_model("progs/drake/rocket1.mdl");
	precache_model("progs/ad171/proj_bolt1.mdl");
	precache_model("progs/ad171/proj_bolt2.mdl");
	precache_model("progs/lspike.mdl");
	precache_model("progs/madfox/s_bfg.spr");
	precache_model("progs/rogue/mervup.mdl");
	precache_model("progs/rockup_d.mdl");
	precache_model("progs/rockup.mdl");
	precache_model("progs/plasma.mdl");
	precache_model("progs/h_shal.mdl");
	precache_model("progs/drake/ice_cube.mdl");
	precache_model("progs/drake/iceball.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_model("progs/drake/gr_gib.mdl");
	precache_model("progs/drake/pur_gib.mdl");
	precache_model("progs/drake/s_spark.spr");
	precache_model("progs/drake/acidbal1.mdl");
	precache_model("progs/drake/s_fancy.spr");
    precache_model("progs/beam.mdl");      // Used by TE_BEAM.
    precache_model("progs/drake/hook.mdl");
    precache_model("progs/null.spr");      // Used by TE_BEAM.
    precache_model("progs/drake/v_grpple.mdl");
    precache_model("progs/drake/v_light2.mdl");
	precache_model("progs/drake/v_laserb.mdl");
	precache_model("progs/hipnotic/v_laserg.mdl");
    precache_model("progs/drake/v_saw.mdl");
    precache_model("progs/q15/v_saw.mdl");
	precache_model("progs/drake/playham0.mdl");
	precache_model("progs/drake/playsaw.mdl");
	precache_model("progs/custents/beam.mdl"); // phase beam
	precache_model("progs/ad171/proj_laz.mdl");
	precache_model("progs/ad171/proj_gaplasmagrn.mdl");
	precache_model("progs/ad171/proj_lightning2.mdl");
	precache_model("progs/ad171/proj_grenadegrn.mdl");
	precache_model("progs/ad171/proj_swampling.mdl");
	precache_model("progs/s_light4.spr");
	precache_model("progs/drake/arrow.mdl");
	precache_model("progs/ad181/proj_minoblood.mdl");
	precache_model("progs/ad171/proj_lazgrn.mdl");
	precache_model("progs/q15/player_legs1_suit.mdl");
	precache_model("progs/q15/player_legs1.mdl");
	precache_model("progs/q15/player_legs2.mdl");
	precache_model("progs/aoa/v_flak.mdl");
	precache_model("progs/aoa/v_gungnir.mdl");
	precache_model("progs/redfield/v_light.mdl");
	precache_model("progs/aoa/v_mace.mdl");
	precache_model("progs/aoa/v_rapier.mdl");
	precache_model("progs/aoa/v_sanguinators.mdl");
	precache_model("progs/aoa/v_scimitar.mdl");
	precache_model("progs/aoa/v_voidstaff.mdl");
	precache_model("progs/ad171/misc_spark.mdl");
	precache_model("progs/rrp/spark.mdl");
	precache_model("progs/drake/blood.mdl"); 		// BLOOD_RED
	precache_model("progs/drake/blood_gr.mdl"); 	// BLOOD_GREEN
	precache_model("progs/drake/gr_gib.mdl"); 		// BLOOD_GREEN
	precache_model("progs/drake/pur_gib.mdl"); 	// BLOOD_PURPLE
	precache_model("progs/drake/ember.mdl"); 		// BLOOD_FIRE
	precache_model("progs/qrally/sumabase.mdl");
	precache_model("progs/qrally/sumanail.mdl");
	precache_model("progs/qrally/sumarock.mdl");
	precache_model(MODEL_HEAL5);
	precache_model(MODEL_HEAL15);
	precache_model(MODEL_HEAL25);
	precache_model(MODEL_HEAL25B);
	precache_model(MODEL_HEAL100);
	precache_model(MODEL_HEAL15B);
	precache_model(MODEL_HEAL100B);
	precache_model("progs/rogue/sphere.mdl");
	precache_model("progs/hipnotic/s_bullet.spr");
	precache_model(MODEL_PROJ_HKN);
	precache_model("progs/q15/zom_gib.mdl");
	precache_model("progs/drake/dragon.mdl");
	precache_sound("hipnotic/items/empathy2.wav");	// Empathy shield sound
	precache_sound("hipnotic/items/wetsuit.wav");		// Wetsuit noise
	precache_sound("rogue/shield/hit.wav");		// Power Shield hit
	precache_sound("rogue/shield/fadeout.wav");		// Power Shield fadeout
	precache_sound("rogue/belt/use.wav");		// Antigrav ping
	precache_sound("rogue/belt/fadeout.wav");		// Antigrav fadeout
	precache_sound("ad171/weapons/crossbow_fire.wav");
	precache_sound("qmaster/player/jump.wav");
	precache_sound("hipnotic/weapons/laserric.wav");
	precache_sound("hipnotic/weapons/laserg.wav");
	precache_sound("hipnotic/weapons/mjolslap.wav");
	precache_sound("hipnotic/weapons/mjolhit.wav");
	precache_sound("hipnotic/weapons/mjoltink.wav");
	precache_sound("hipnotic/weapons/proxwarn.wav");
	precache_sound("hipnotic/weapons/proxbomb.wav");
	precache_sound("hipnotic/misc/quake.wav");
	precache_sound("hipnotic/misc/quakeend.wav");
	precache_sound(SOUND_LASER_HIT);
	precache_sound("rogue/weapons/snail.wav");
	precache_sound("rogue/plasma/explode.wav");
	precache_sound("rogue/plasma/fire.wav");
	precache_sound("rogue/plasma/flight.wav");
	precache_sound("quoth/items2/trinend.wav");
	precache_sound("quoth/items2/crosend.wav");
	precache_sound("quoth/items2/crosuse.wav");
	precache_sound("items/inv3.wav");
	precache_sound("items/inv2.wav");
	precache_sound("items/suit2.wav");
	precache_sound("drake/weapons/nova.wav");
	precache_sound("drake/weapons/zap1.wav");
    precache_sound("drake/weapons/zap2.wav");
    precache_sound("drake/weapons/mirv2.wav");
    precache_sound("drake/items/tomepow.wav");
    precache_sound("drake/items/tomepow2.wav");
    precache_sound("hknight/attack1.wav");
	precache_sound(SOUND_ARTINV1);
	precache_sound(SOUND_ARTQUAD1);
	precache_sound(SOUND_ARTPENT1);
	precache_sound(SOUND_ARTSUIT1);
	precache_sound(SOUND_ARTSHARP1);
	precache_sound(SOUND_ARTNAILP1);
	precache_sound(SOUND_ARTLSHIELD1);
	precache_sound(SOUND_ARTBLASTBELT1);
	precache_sound(SOUND_ARTJUMPBOOTS1);
	precache_sound("hipnotic/items/wetsuit.wav");
	precache_sound("ad171/items/wetsuit3out.wav");
	precache_sound("hipnotic/items/wetoff.wav");
	precache_sound("items/damage2.wav");
	precache_sound("ad171/items/sharp2.wav");
	precache_sound("items/protect2.wav");
	precache_sound("ad171/items/nailp2.wav");
	precache_sound("ad171/items/sharp3.wav");
	precache_sound("ad171/nour/idle1.wav");
	precache_sound("drake/weapons/shatter.wav");
	precache_sound("zerstorer/cube/bc_gulp.wav");
	precache_sound("zerstorer/cube/bc_attck.wav");
	precache_sound("zerstorer/gibfnt/gf_plop.wav");
	precache_sound("player/udeath.wav");
	precache_sound("boss1/out1.wav");
	precache_sound("zerstorer/trog/bigboom.wav");
	precache_sound("zerstorer/weapons/sawguts.wav");
	precache_sound("drake/items/money.wav");
	precache_sound("ambience/thunder1.wav");
	precache_sound("zerstorer/ambience/thunder2.wav");
	precache_sound("drake/weapons/axhit.wav");
	precache_sound("nehahra/player/flight.wav");
	precache_sound("zerstorer/ambience/wingend.wav");
    precache_sound("shambler/smack.wav");
    precache_sound("drake/weapons/chain1.wav");
    precache_sound("drake/items/reflect3.wav");
    precache_sound("zombie/z_hit.wav");
	precache_sound("zerstorer/weapons/stunfire.wav");
	precache_sound("zerstorer/weapons/sawidle.wav");
    precache_sound("zerstorer/weapons/sawatck.wav");
    precache_sound("zerstorer/weapons/sawridle.wav");
    precache_sound("drake/weapons/clang.wav");
	precache_sound("drake/weapons/axhitwal.wav");
	precache_sound("ad171/weapons/bolt_hit1.wav");
	precache_sound("ad171/weapons/bolt_hit4.wav");
	precache_sound("enforcer/enfire.wav");
	precache_sound("xmas/raindeer/hit.wav");
	precache_sound("doom/bfg.wav");
	precache_sound("zerstorer/ambience/thunder2.wav");
	precache_sound("custents/weapons/lncharow.wav");
	precache_sound("drake/weapons/mirv1.wav");
    precache_sound("knight/sword1.wav");
	precache_sound("kinn/shuffler/expsmall.wav");
	precache_sound("ad171/weapons/sword1a.wav");
	precache_sound("ad171/weapons/sword1b.wav");
	precache_sound("ad171/weapons/sword2a.wav");
	precache_sound("ad171/weapons/sword2b.wav");
	precache_sound("weapons/axe_flesh.wav");
	precache_sound("ad181/items/blastbelt2.wav");
	precache_sound("ad181/items/lavashield2.wav");
	precache_sound("ad171/items/sharp2.wav");
	precache_sound("ad181/items/jumpboots3a.wav");
	precache_sound("ad181/items/jumpboots3b.wav");
	precache_sound("ad181/items/jumpboots3c.wav");
	precache_sound("drake/misc/dsslop.wav");
	precache_sound("rrp/misc/spark.wav");
	precache_sound("drake/weapons/icewall.wav");
	precache_sound("drake/necro/att_a.wav");
	precache_sound("drake/necro/att_a2.wav");
	precache_sound("drake/weapons/xbowdraw.wav");
	precache_sound("drake/weapons/freeze.wav");
	precache_sound("drake/weapons/icehit.wav");
	precache_sound("drake/weapons/shatter.wav");
	precache_sound("qrally/start.wav");
	precache_sound("qrally/ray/engstart.wav");
	precache_sound("qrally/start2.wav");
	precache_sound("quoth/items/click.wav");
	precache_sound("rogue/sphere/sphere.wav");
	precache_sound("redfield/misc/catsmeow.wav");
	precache_sound("ad171/weapons/bolt_hit2.wav");
	precache_sound("ad171/weapons/bolt_hit3.wav");
	precache_sound("drake/bane/thunder.wav");
	precache_sound("tronyn/lightning_component_electrified.wav");
	precache_sound("tronyn/lightning_rod_electrified.wav");
	precache_sound("tronyn/lightning_strike.wav"); // For kill ray cheat.
	precache_sound("tronyn/lightning_blast.wav"); // For gib ray cheat.
	precache_sound("rogue/belt/pickup.wav"); // For Thor's Blessing activation.
	if (ext_dppart) {
		particleeffectnum("TE_POISONBIG");
		particleeffectnum("voreball_explosion");
	}
};