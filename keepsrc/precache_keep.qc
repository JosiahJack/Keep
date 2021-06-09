void() precache_poisongibs;

void() PrecacheAll = {
	precache_sound ("hipnotic/items/empathy2.wav");	// Empathy shield sound
	precache_sound ("hipnotic/items/wetsuit.wav");		// Wetsuit noise
	precache_sound ("rogue/shield/hit.wav");		// Power Shield hit
	precache_sound ("rogue/shield/fadeout.wav");		// Power Shield fadeout
	precache_sound ("rogue/belt/use.wav");		// Antigrav ping
	precache_sound ("rogue/belt/fadeout.wav");		// Antigrav fadeout
	precache_sound ("quoth/pyro/fstop.wav");		// For dragon fire
	precache_sound ("quoth/pyro/flame.wav");		// For dragon fire
	precache_sound ("ad171/weapons/crossbow_fire.wav");
	precache_sound ("qmaster/player/jump.wav");
	precache_sound ("qmaster/player/jumpland.wav");
	precache_sound ("hipnotic/weapons/laserric.wav");
	precache_sound ("hipnotic/weapons/laserg.wav");
	precache_sound ("hipnotic/weapons/mjolslap.wav");
	precache_sound ("hipnotic/weapons/mjolhit.wav");
	precache_sound ("hipnotic/weapons/mjoltink.wav");
	precache_sound ("hipnotic/weapons/proxwarn.wav");
	precache_sound ("hipnotic/weapons/proxbomb.wav");
	precache_sound ("ad171/weapons/crossbow_rdy.wav");
	precache_sound(SOUND_LASER_HIT);
	precache_sound ("ad171/spider/hiss2.wav");
	precache_sound ("rogue/weapons/snail.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound ("rogue/plasma/explode.wav");
	precache_sound ("rogue/plasma/fire.wav");
	precache_sound ("rogue/plasma/flight.wav");
	precache_sound ("quoth/items2/trinend.wav");
	precache_sound ("quoth/items2/crosend.wav");
	precache_sound ("quoth/items2/crosuse.wav");
	precache_sound ("items/inv3.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/suit2.wav");
	precache_sound ("nehahra/wraith/soul.wav");
	precache_sound ("drake/shade/taunt.wav");
	precache_sound ("nehahra/wraith/rych1.wav");
	precache_sound ("nehahra/wraith/select.wav");
	precache_sound ("nehahra/wraith/return.wav");
	//precache_sound ("items/suit3.wav");
	precache_sound (SOUND_ARTINV1);
	precache_sound (SOUND_ARTQUAD1);
	precache_sound (SOUND_ARTPENT1);
	precache_sound ("zerstorer/me/me_soff.wav");
	precache_sound ("zerstorer/me/me_son.wav");
	precache_sound ("hipnotic/items/wetsuit.wav");
	precache_sound ("ad171/items/wetsuit3out.wav");
	precache_sound ("hipnotic/items/wetoff.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("ad171/items/sharp2.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("ad171/items/nailp2.wav");
	precache_sound ("ad171/items/sharp3.wav");
	precache_sound ("ad171/nour/idle1.wav");
	precache_sound ("drake/weapons/shatter.wav");
	precache_sound ("zerstorer/cube/bc_gulp.wav");
	precache_sound ("zerstorer/cube/bc_attck.wav");
	precache_sound ("zerstorer/gibfnt/gf_plop.wav");
	precache_sound ("player/udeath.wav");
	precache_sound ("boss1/out1.wav");
	precache_sound ("zerstorer/trog/bigboom.wav");
	precache_sound ("zerstorer/weapons/sawguts.wav");
	precache_sound ("drake/items/money.wav");
	precache_sound ("ambience/thunder1.wav");
	precache_sound ("zerstorer/ambience/thunder2.wav");
	precache_sound ("drake/weapons/axhit.wav");
	precache_sound ("nehahra/player/flight.wav");
	precache_sound ("zerstorer/ambience/wingend.wav");
    precache_sound ("shambler/smack.wav");
    precache_sound ("drake/weapons/chain1.wav");
    precache_sound ("drake/items/reflect3.wav");
    precache_sound ("zombie/z_hit.wav");
	precache_sound ("zerstorer/weapons/stunfire.wav");
	precache_sound ("zerstorer/weapons/sawidle.wav");
    precache_sound ("zerstorer/weapons/sawatck.wav");
    precache_sound ("zerstorer/weapons/sawridle.wav");
    precache_sound ("drake/weapons/clang.wav");
	precache_sound ("drake/weapons/axhitwal.wav");
	precache_sound ("ad171/weapons/bolt_hit1.wav");
	precache_sound ("ad171/weapons/bolt_hit4.wav");
	precache_sound ("enforcer/enfire.wav");
	precache_sound ("xmas/raindeer/hit.wav");
	precache_sound ("doom/bfg.wav");
	precache_sound ("zerstorer/ambience/thunder2.wav");
	precache_sound ("custents/weapons/lncharow.wav");
	precache_sound ("drake/weapons/mirv1.wav");
    precache_sound ("knight/sword1.wav");

	// New sword sweep/slash sounds
	precache_sound ("ad171/weapons/sword1a.wav");
	precache_sound ("ad171/weapons/sword1b.wav");
	precache_sound ("ad171/weapons/sword2a.wav");
	precache_sound ("ad171/weapons/sword2b.wav");

	precache_sound ("weapons/axe_flesh.wav");
	precache_sound ("ad181/items/blastbelt2.wav");
	precache_sound ("ad181/items/lavashield2.wav");
	precache_sound ("ad171/items/sharp2.wav");
	precache_sound ("ad181/items/jumpboots3a.wav");
	precache_sound ("ad181/items/jumpboots3b.wav");
	precache_sound ("ad181/items/jumpboots3c.wav");
	precache_sound ("drake/misc/dsslop.wav");
	precache_model ("progs/nehahra/soul.mdl");
	precache_model ("progs/null.mdl");
	precache_model ("progs/drake/null_256.spr");
	precache_model ("progs/custents/beamhit.spr");
	precache_model ("progs/custents/dring.spr");
	precache_model ("progs/k_spike.mdl");
	precache_model ("progs/drake/s_explod.spr");
	precache_model ("progs/quoth/smlexp.spr");
	precache_model ("progs/quoth/medexp.spr");	// For dragon fire
	precache_model ("progs/hipnotic/lasrspik.mdl");
	precache_model ("progs/hipnotic/proxbomb.mdl");
	precache_model ("progs/g_crossbow.mdl");
	precache_model ("progs/its/v_crossbow1.mdl");
	precache_model ("progs/its/v_crossbow2.mdl");
	precache_model ("progs/hipnotic/v_prox.mdl");
	precache_model ("progs/v_plasma2.mdl");
	precache_model ("progs/v_lava.mdl");
	precache_model ("progs/v_lava2.mdl");
	precache_model ("progs/v_multi.mdl");
	precache_model ("progs/v_multi2.mdl");
	precache_model ("progs/hipnotic/v_laserg.mdl");
	precache_model ("progs/hipnotic/v_hammer.mdl"); //mjolnir
	precache_model ("progs/hipnotic/playham.mdl"); // player with the hammer
	precache_model ("progs/quoth/v_ham.mdl"); //warhammer from quoth
	precache_model ("progs/drake/v_wand.mdl");
	precache_model ("progs/ad171/proj_bolt1.mdl");
	precache_model ("progs/ad171/proj_bolt2.mdl");
	precache_model ("progs/lspike.mdl");
	precache_model ("progs/madfox/s_bfg.spr");
	precache_model ("progs/rogue/mervup.mdl");
	precache_model ("progs/rockup_d.mdl");
	precache_model ("progs/rockup.mdl");
	precache_model ("progs/plasma.mdl");
	precache_model ("progs/h_shal.mdl");
	precache_model ("progs/drake/ice_cube.mdl");
	precache_model ("progs/drake/iceball.mdl");
	precache_model ("progs/zom_gib.mdl");
	precache_model ("progs/drake/gr_gib.mdl");
	precache_model ("progs/drake/pur_gib.mdl");
	precache_model ("progs/drake/ember.mdl");
	precache_model ("progs/drake/s_spark.spr");
	precache_model ("progs/drake/acidbal1.mdl");
	precache_model ("progs/drake/s_fancy.spr");
    precache_model ("progs/beam.mdl");      // Used by TE_BEAM.
    precache_model ("progs/drake/hook.mdl");
    precache_model ("progs/null.spr");      // Used by TE_BEAM.
    precache_model ("progs/drake/v_grpple.mdl");
    precache_model ("progs/drake/v_light2.mdl");
	precache_model ("progs/drake/v_laserb.mdl");
	precache_model ("progs/hipnotic/v_laserg.mdl");
    precache_model ("progs/drake/v_saw.mdl");
	precache_model ("progs/drake/playham0.mdl");
	precache_model ("progs/drake/playsaw.mdl");
	precache_model ("progs/custents/beam.mdl"); // phase beam
	precache_model ("progs/ad171/proj_laz.mdl");
	precache_model ("progs/ad171/proj_gaplasmagrn.mdl");
	precache_model ("progs/ad171/proj_lightning2.mdl");
	precache_model ("progs/ad171/proj_grenadegrn.mdl");
	precache_model ("progs/ad171/proj_swampling.mdl");
	precache_model ("progs/s_light4.spr");
	precache_model ("progs/drake/arrow.mdl");
	precache_model ("progs/ad181/proj_minoblood.mdl");
	precache_model ("progs/ad171/proj_lazgrn.mdl");
	precache_model ("progs/q15/player_legs1_suit.mdl");
	precache_model ("progs/q15/player_legs1.mdl");
	precache_model ("progs/q15/player_legs2.mdl");
	precache_model ("progs/aoa/v_flak.mdl");
	precache_model ("progs/aoa/v_gungnir.mdl");
	precache_model ("progs/aoa/v_ice.mdl");
	precache_model ("progs/aoa/v_mace.mdl");
	precache_model ("progs/aoa/v_rapier.mdl");
	precache_model ("progs/aoa/v_sanguinators.mdl");
	precache_model ("progs/aoa/v_scimitar.mdl");
	precache_model ("progs/aoa/v_voidstaff.mdl");
	precache_aoa();
	precache_poisongibs();
	// Drake blood
	precache_model ("progs/drake/blood.mdl"); 		// BLOOD_RED
	precache_model ("progs/drake/blood_gr.mdl"); 	// BLOOD_GREEN
	precache_model ("progs/drake/gr_gib.mdl"); 		// BLOOD_GREEN
	precache_model ("progs/drake/pur_gib.mdl"); 	// BLOOD_PURPLE
	precache_model ("progs/drake/ember.mdl"); 		// BLOOD_FIRE

	// Quake Rally Cars
	precache_model("progs/qrally/sumabase.mdl");
};