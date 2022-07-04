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
// Entity count: 5
// Function count: 34
//
// Implements: Artifacts and Powerups Item Pickups
//
// Description:
// The various powerups items that can be picked up and their helper functions.
//
// Also includes runes and other artifacts pickups that don't necessarily have
// any benefit to the player and serve as story or progression elements.
//=============================================================================

void() sphere_spawn;

void() artifact_touch = { // [FUNCTION]
	entity pl;
	float overrideSprint;

	overrideSprint = FALSE;
	if (self.classtype == CT_ARTSUIT) {
		other.rad_time = TRUE;
		if (self.cnt < 0) other.radsuit_finished = POWERUP_VANIA;
		else other.radsuit_finished = time + self.cnt;
		ResetDebuffBurning(other);
		ResetDebuffPoisoned(other);
	} else if (self.classtype == CT_ARTPENT) {
		other.invincible_time = TRUE;
		if (self.cnt < 0) other.invincible_finished = POWERUP_VANIA;
		else other.invincible_finished = time + self.cnt;
		ResetDebuffSystem(other);
	} else if (self.classtype == CT_ARTINVS) {
		other.invisible_time = TRUE;
		other.notrace = 1;
		if (self.cnt < 0) other.invisible_finished = POWERUP_VANIA;
		else other.invisible_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTQUAD) {
		other.super_time = TRUE;
		if (self.cnt < 0) other.super_damage_finished = POWERUP_VANIA;
		else other.super_damage_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTSHARP) {
		other.sharpshoot_time = TRUE;
		if (self.cnt < 0) other.sharpshoot_finished = POWERUP_VANIA;
		else other.sharpshoot_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTPIERCE) {
		other.nailpiercer_time = TRUE;
		if (self.cnt < 0) other.nailpiercer_finished = POWERUP_VANIA;
		else other.nailpiercer_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTPSHIELD) {
		other.shield_time = TRUE;
		if (self.cnt < 0) other.shield_finished = POWERUP_VANIA;
		else other.shield_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTGRAVBELT) {
		other.antigrav_time = TRUE;
		if (self.cnt < 0) other.antigrav_finished = POWERUP_VANIA;
		else other.antigrav_finished = time + self.cnt;
		other.gravity = 0.25; // This is where the magic happens! See client_power.qc for how it goes back to 1.
	} else if (self.classtype == CT_ARTLAVASHIELD) {
		other.lavashield_time = TRUE;
		// Volume range modifier (0-1)
		other.lavashield_volume = self.volume;
		if (self.cnt < 0) other.lavashield_finished = POWERUP_VANIA;
		else other.lavashield_finished = time + self.cnt;
		ResetDebuffBurning(other);
	} else if (self.classtype == CT_ARTWETSUIT) {
		other.wetsuit_time = TRUE;
		if (self.cnt < 0) other.wetsuit_finished = POWERUP_VANIA;
		else other.wetsuit_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTBLASTBELT) {
		other.blastbelt_time = TRUE;
		if (self.cnt < 0) other.blastbelt_finished = POWERUP_VANIA;
		else other.blastbelt_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTJUMPBOOTS) {
		other.jumpboots_time = 1;
		if (self.cnt < 0) other.jumpboots_finished = POWERUP_VANIA;
		else other.jumpboots_finished = time + self.cnt;
		other.jumpboots_airlvl = 0;
		// Check if jump max is endless, additive or exact
		if (self.count < 0) other.jumpboots_airmax = -1;
		else if (self.count > 0) other.jumpboots_airmax = self.count;
		else other.jumpboots_airmax = other.jumpboots_airmax + 1;
		// Make sure the max never goes too high
		if (other.jumpboots_airmax > ART_JUMPBOOTS_AIRMAX) other.jumpboots_airmax = ART_JUMPBOOTS_AIRMAX;
		if (self.height > 0) other.jumpboots_height = self.height;
		else other.jumpboots_height = ART_JUMPHEIGHT;
		if (self.distance > 0) other.jumpboots_forward = self.distance;
		else other.jumpboots_forward = 0;
	} else if (self.classtype == CT_ARTEMPATHY) {
		other.empathy_time = TRUE;
		if (self.cnt < 0) other.empathy_finished = POWERUP_VANIA;
		else other.empathy_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTSPHERE) {
		if (other.items2 & IT2_V_SPHERE) return; // Can only carry one, carries it indefinitely.

        sphere_spawn();
	} else if (self.classtype == CT_ARTTHERMSUIT) {
		other.therm_time = TRUE;
		if (self.cnt < 0) other.therm_finished = POWERUP_VANIA;
		else other.therm_finished = time + self.cnt;
		ResetDebuffBurning(other);
	} else if (self.classtype == CT_ARTTRINITY) {
		other.trinity_time = 1;
		other.trinity_start = 1;
		if (self.cnt < 0) other.trinity_finished = POWERUP_VANIA;
		else other.trinity_finished = time + self.cnt;
	} else if (self.classtype == CT_ARTCROSS) {
		other.cross_time = 1;
		other.cross_start = 1;
		if (self.cnt < 0) other.cross_finished = POWERUP_VANIA;
		else other.cross_finished = time + self.cnt;
		ResetDebuffSystem(other);
	} else if (self.classtype == CT_ARTHASTE) {
		other.perms = other.perms | POW_HASTE;
	} else if (self.classtype == CT_ARTBERSERK) {
		other.perms = other.perms | POW_VAMPIRE;
		if (other.health < 100) other.health = 100; // full heal
	} else if (self.classtype == CT_ARTEQUALIZER) {
		other.perms = other.perms | POW_DOUBLE;
		other.ammo_nails = AMMO_MAXNAILS; // max out nails ammo
		if (other.ammo_lava_nails < (AMMO_MAXLAVANAILS * 0.5)) other.ammo_lava_nails = AMMO_MAXLAVANAILS * 0.5; // fill lava nails up to half
		W_SetCurrentAmmo(other); // if changed current ammo, update it
	} else if (self.classtype == CT_ARTLEVITATION) {
		other.wing_time = 1;
		if (self.cnt < 0) other.wing_finished = POWERUP_VANIA;
		else other.wing_finished = time + 45;
	} else if (self.classtype == CT_ARTOPTIMIZER) {
		sprint(other, "You got the ");
		sprint(other, self.netname);
		sprint(other, "...\n");
		if (self.ammo_shells) {
			other.maxshells = other.maxshells + self.ammo_shells;
			other.ammo_shells = other.maxshells; // max out ammo
			sprint(other, "Max shells increased by ");
			sprint(other, ftos(self.ammo_shells));
			sprint(other, "!\n");
		}

		if (self.ammo_nails)  {
			other.maxnails = other.maxnails + self.ammo_nails;
			other.ammo_nails = other.maxnails; // max out ammo
			sprint(other, "Max nails increased by ");
			sprint(other, ftos(self.ammo_nails));
			sprint(other, "!\n");
		}

		if (self.ammo_rockets) {
			other.maxrockets = other.maxrockets + self.ammo_rockets;
			other.ammo_rockets = other.maxrockets; // max out ammo
			sprint(other, "Max rockets increased by ");
			sprint(other, ftos(self.ammo_rockets));
			sprint(other, "!\n");
		}

		if (self.ammo_cells) {
			other.maxcells = other.maxcells + self.ammo_cells;
			other.ammo_cells = other.maxcells; // max out ammo
			sprint(other, "Max cells increased by ");
			sprint(other, ftos(self.ammo_cells));
			sprint(other, "!\n");
		}

		if (self.ammo_lava_nails) {
			other.maxlavanails = other.maxlavanails + self.ammo_lava_nails;
			other.ammo_lava_nails = other.maxlavanails; // max out ammo
			sprint(other, "Max lava nails increased by ");
			sprint(other, ftos(self.ammo_lava_nails));
			sprint(other, "!\n");
		}

		if (self.ammo_multi_rockets) {
			other.maxmultirockets = other.maxmultirockets + self.ammo_multi_rockets;
			other.ammo_multi_rockets = other.maxmultirockets; // max out ammo
			sprint(other, "Max multi-rockets ammo increased by ");
			sprint(other, ftos(self.ammo_multi_rockets));
			sprint(other, "!\n");
		}

		if (self.ammo_plasma) {
			other.maxplasma = other.maxplasma + self.ammo_plasma;
			other.ammo_plasma = other.maxplasma; // max out ammo
			sprint(other, "Max poison ammo increased by ");
			sprint(other, ftos(self.ammo_plasma));
			sprint(other, "!\n");
		}

		if (self.ammo_poison) {
		other.maxpoison = other.maxpoison + self.ammo_poison;
		other.ammo_poison = other.maxpoison; // max out ammo
			sprint(other, "Max poison ammo increased by ");
			sprint(other, ftos(self.ammo_poison));
			sprint(other, "!\n");
		}

		if (self.ammo_bolts) {
		other.maxbolts = other.maxbolts + self.ammo_bolts;
		other.ammo_bolts = other.maxbolts; // max out ammo
			sprint(other, "Max bolts increased by ");
			sprint(other, ftos(self.ammo_bolts));
			sprint(other, "!\n");
		}

		if (self.ammo_bloodcrystals) {
			other.maxblood = other.maxblood + self.ammo_bloodcrystals;
			other.ammo_bloodcrystals = other.maxblood; // max out ammo
			sprint(other, "Max blood crystals increased by ");
			sprint(other, ftos(self.ammo_bloodcrystals));
			sprint(other, "!\n");
		}

		if (self.ammo_voidshards) {
			other.maxvoid = other.maxvoid + self.ammo_voidshards;
			other.ammo_voidshards = other.maxvoid; // max out ammo
			sprint(other, "Max void shards increased by ");
			sprint(other, ftos(self.ammo_voidshards));
			sprint(other, "!\n");
		}

		if (self.ammo_elemental) {
			other.maxmana = other.maxmana + self.ammo_elemental;
			other.ammo_elemental = other.maxmana; // max out ammo
			sprint(other, "Max elemental mana increased by ");
			sprint(other, ftos(self.ammo_elemental));
			sprint(other, "!\n");
		}

		overrideSprint = TRUE;
	} else if (self.classtype == CT_SIGILBANE) {
		// Give all players 250 health
		pl = find (world, classname, "player");
		while (pl) {
			pl.health = pl.max_health;
			pl = find (pl, classname, "player");
		}
	} else if (self.classtype == CT_ARTREGEN) {
		other.health = other.max_health;
	} else if (self.classtype == CT_ARTVITALITY) {
		other.max_health = other.max_health + self.max_health;
		other.health = other.max_health; 
	} else return;

	if (!overrideSprint) {
		sprint(other, "You got the ");
		sprint(other, self.netname);
	}
	sprint(other,"\n");
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM); // Pickup sound
	Safe_stuffcmd(other, "bf\n"); // Screen flash
	other.items = other.items | self.items; // Update player items
	other.items2 = other.items2 | self.items2;
	other.moditems = other.moditems | self.moditems;
	other.perms = other.perms | self.perms;
	activator = other;
	SUB_UseTargets();
	item_finished(); // hide item 
	if (!self.respawn_trig) start_item_respawn(); // check for respawn
};

void() artifact_setup = { // [FUNCTION]
	self.touch2 = artifact_touch;
	self.classgroup = CG_ARTIFACT;
	self.bbmins = VEC_HULL_MIN;
	self.bbmaxs = VEC_HULL_MAX;
	if (self.cnt < 0) self.cnt = POWERUP_VANIA; // Infinite time support.
	else if (self.cnt == 0) self.cnt = POWERUP_TIMER; //  Allow for custom artifact timer. Setup minimum/default timer

	// Setup artifact default respawn timers
	if (self.respawn_time == 0) {
		if (self.classtype == CT_ARTPENT || self.classtype == CT_ARTINVS || self.classtype == CT_ARTSHARP || self.classtype == CT_ARTPIERCE) self.respawn_time = RESPAWN_ARTIFACT2;
		else self.respawn_time = RESPAWN_ARTIFACT1;
	}

	item_start ();
};

/*QUAKED item_sigil (0 0.5 0.8) (-16 -16 -24) (16 16 32) Ep1 Ep2 Ep3 Ep4 RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
{ model(":progs/key_rune1.mdl"); }
End of episode sigil / rune
-------- KEYS --------
targetname   : toggle state (use trigger ent for exact state)
message       : centerprint message when item is picked up
respawn_time  : time to wait before respawning (1-x seconds, default varies)
respawn_count : Total amount of times to respawn (counts down to zero)
respawn_trig : = 1 Wait for trigger before respawning
-------- SPAWNFLAGS --------
EP1 : Episode 1 Rune
EP2 : Episode 2 Rune
EP3 : Episode 3 Rune
EP4 : Episode 4 Rune
RESPAWN  : Can respawn after being picked up
FLOAT    : No drop to floor test
STARTOFF : Starts off and waits for trigger
NOEFFECTS : No particle or effects active
-------- NOTES --------
End of episode sigil.  If the player is in possession of a sigil, then the next time 
the player changes levels, all func_episodegate entities for that episode will appear.  
This is used to block access to slipgates that lead to episodes that the player has 
already completed.  If the player is in possession of the item_sigil for all four 
episodes, then the func_bossgate entity will NOT appear.  This is used to grant 
access to the final boss once the player has completed all episodes.*/
void() sigil_touch = { // [FUNCTION]
	if (query_configflag(self.customkey)) return;
	
	centerprint3( other, "You got ", self.netname, "!");
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	Safe_stuffcmd (other, "bf\n");
	update_configflag(self.customkey, TRUE); // Add rune to server! not player
	if (other.flags & FL_CLIENT) other.serverflagstemp = other.serverflagstemp | self.customkey;
	if (ext_dppart) pointparticles(particleeffectnum(DPP_SIGILPICKUP), self.origin, '0 0 0', 1); // DP has special effect for sigil being picked up
	activator = other;
	SUB_UseTargets();
	if (self.progspawnlist) return; // Quick exit, no need for following stuff
	
	item_finished();
	if (!self.respawn_trig) start_item_respawn();	
};

void() item_sigil = { // [ENTITY]
	if (!self.spawnflags) self.spawnflags |= SVR_RUNE_KEY1;

	// Based on what spawn key is selected, update model/spawnflag
	// This will make sure only one rune is selected at once
	// Also allow for the spawnflags to have other parameters
	if (self.spawnflags & SVR_RUNE_KEY1) {
		item_setupmodel("progs/ad171/key_rune1.mdl",0);
		self.customkey = SVR_RUNE_KEY1;
	} else if (self.spawnflags & SVR_RUNE_KEY2) {
		item_setupmodel("progs/ad171/key_rune2.mdl",0);
		self.customkey = SVR_RUNE_KEY2;
	} else if (self.spawnflags & SVR_RUNE_KEY3) {
		item_setupmodel("progs/ad171/key_rune3.mdl",0);
		self.customkey = SVR_RUNE_KEY3;
	} else if (self.spawnflags & SVR_RUNE_KEY4) {
		item_setupmodel("progs/ad171/key_rune4.mdl",0);
		self.customkey = SVR_RUNE_KEY4;
	}
	item_setupnoise("misc/runekey.wav");
	self.touch2 = sigil_touch;
	self.classtype = CT_RUNEKEY;
	self.classgroup = CG_RUNE;
	if (self.netname == "") self.netname = "The Rune";
	self.part_active = PARTICLE_STYLE_SIGIL;
	self.bbmins = VEC_HULL_MIN;
	self.bbmaxs = VEC_HULL_MAX;
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_RUNE;
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	item_coopcheck();	
	item_start();
};

// Unique item for nsoe5.  Pick up to activate final fight with Bane.
void() item_sigil_bane = { // [ENTITY]
	item_setupmodel("progs/drake/end_bane.mdl",0);
	item_setupnoise("misc/runekey.wav");
    self.netname = "seal of Bane!";
	self.classtype = CT_SIGILBANE;
	self.part_active = PARTICLE_STYLE_SIGIL;
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

void() tomeofpower_touch = { // [FUNCTION]
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other,"\n");
	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	Safe_stuffcmd (other, "bf\n");
	other.tome_finished = time + self.cnt;
	activator = other;
	SUB_UseTargets();
	item_finished(); // This is a trigger once condition (regardless of coop)
};

void() item_artifact_tomeofpower = { // [ENTITY]
	item_setupmodel("progs/ad171/artifact_tome.mdl",0);
	item_setupnoise("drake/items/tomepow.wav");
	self.classtype = CT_ARTTOME;
	self.classgroup = CG_ARTIFACT;
	self.moditems = IT_ARTTOME;
	if (self.netname == "") self.netname = "Tome of Power";
	if (!self.cnt) self.cnt = 45;
	self.touch2 = tomeofpower_touch;
	self.bbmins = VEC_HULL_MIN;
	self.bbmaxs = VEC_HULL_MAX;
	self.part_active = PARTICLE_STYLE_TOMEOFP;
	item_start();
};

// QUAKED item_artifact_envirosuit (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_envsuit.mdl"); }
// Player takes no damage from water or slime for 30 seconds
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// exactskin    : 0=Original, 1=Green, 2=Brown, 3=Aqua, 4=Blue
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Player takes no damage from water or slime for 30 seconds
// Immume from Wraith Healing Debuff but take small damage instead
void() item_artifact_envirosuit = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_envsuit.mdl",0);
	item_setupnoise(SOUND_ARTSUIT1);
	self.noise1 = SOUND_ARTSUIT2;
	precache_sound (self.noise1);
	if (self.netname == "") self.netname = "Environment Suit";
	self.items = IT_SUIT;
	self.classtype = CT_ARTSUIT;
	self.part_active = PARTICLE_STYLE_SUIT;
	self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 28';
	artifact_setup();
};

// QUAKED item_artifact_wetsuit (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_wetsuit.mdl"); }
// Player takes no damage from water for 5 mins (300s)
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// exactskin    : 0=Original, 1=Green, 2=Brown, 3=Aqua, 4=Blue
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 300s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Player takes no damage from water for 5 mins (300s)
// Immume from Wraith Healing Debuff but take small damage instead
void() item_artifact_wetsuit = { // [ENTITY], cshifts 0,255,0,20
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_wetsuit.mdl",0);
	item_setupnoise(SOUND_ARTWETS1);
	self.noise1 = SOUND_ARTWETS2;
	self.noise2 = SOUND_ARTWETS3;
	self.noise3 = SOUND_ARTWETS3B;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);
	if (self.netname == "") self.netname = "Wet Suit";
	self.moditems = IT_ARTWETSUIT;
	self.classtype = CT_ARTWETSUIT;
	self.part_active = PARTICLE_STYLE_WETSUIT;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 28';
	if (self.cnt < 1) self.cnt = 300;
	if (self.exactskin < 1) self.exactskin = 4;
	artifact_setup();
};

void() item_artifact_airtank = { // [ENTITY]
	self.classname = "item_artifact_wetsuit";
	if (self.mdl == "") self.mdl = "progs/ad181/artifact_airtank.mdl";
	if (self.netname == "") self.netname = "Air Tank";
	if (self.noise == "") self.noise = SOUND_ARTAIRTANK1;
	if (self.cnt <= 0) self.cnt = POWERUP_VANIA; // Default = Infinite vania item
	item_artifact_wetsuit();
}

// QUAKED item_artifact_invulnerability (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_pent.mdl"); }
// Player is invulnerable for 30 seconds
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Player is invulnerable for 30 seconds
// Immume from Wraith Healing Debuff
void() item_artifact_invulnerability = { // [ENTITY], cshifts 255,255,0,30
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_pent.mdl",0);	// Originally - progs/invulner.mdl
	item_setupnoise(SOUND_ARTPENT1);
	self.noise1 = SOUND_ARTPENT2;
	self.noise2 = SOUND_ARTPENT3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	self.classtype = CT_ARTPENT;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// QUAKED item_artifact_invisibility (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_invis.mdl"); }
// Player is invisible for 30 seconds
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Player is invisible for 30 seconds
void() item_artifact_invisibility = { // [ENTITY], cshifts 100,100,100,100
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_invis.mdl",0); // Originally - progs/invisibl.mdl
	item_setupnoise(SOUND_ARTINV1);
	self.noise1 = SOUND_ARTINV2;
	self.noise2 = SOUND_ARTINV3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	self.classtype = CT_ARTINVS;
	self.part_active = PARTICLE_STYLE_SRING;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 6';
	artifact_setup();
};

// QUAKED item_artifact_super_damage (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_quad.mdl"); }
// The next attack from the player will do 4x damage
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// The next attack from the player will do 4x damage
void() item_artifact_super_damage = { // [ENTITY], cshifts 0,0,255,30
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_quad.mdl",0); // Originally - progs/quaddama.mdl
	item_setupnoise(SOUND_ARTQUAD1);
	self.noise1 = SOUND_ARTQUAD2;
	self.noise2 = SOUND_ARTQUAD3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Quad Damage";
	self.items = IT_QUAD;
	self.classtype = CT_ARTQUAD;
	self.part_active = PARTICLE_STYLE_QUAD;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// QUAKED item_artifact_sharp_shooter (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_sharp.mdl"); }
// Reduces the bullet spread of all Shotguns
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Reduces the bullet spread of all Shotguns
void() item_artifact_sharp_shooter = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_sharp.mdl",0);
	item_setupnoise(SOUND_ARTSHARP1);
	self.noise1 = SOUND_ARTSHARP2;
	self.noise2 = SOUND_ARTSHARP3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Sharp Shooter";
	self.items = IT_QUAD;
	self.moditems = IT_ARTSHARP;
	self.classtype = CT_ARTSHARP;
	self.part_active = PARTICLE_STYLE_SHARP;
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// QUAKED item_artifact_nail_piercer (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/artifact_piercer.mdl"); }
// All nail attacks will travel through monsters
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (=-1 instant)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// All nail attacks will travel through monsters
void() item_artifact_nail_piercer = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/ad171/artifact_piercer.mdl",0);
	item_setupnoise(SOUND_ARTNAILP1);
	self.noise1 = SOUND_ARTNAILP2;
	self.noise2 = SOUND_ARTNAILP3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Nail Piercer";
	self.items = IT_QUAD;
	self.moditems = IT_ARTPIERCE;
	self.classtype = CT_ARTPIERCE;
	self.part_active = PARTICLE_STYLE_PIERCE;
	self.respawn_style = PARTICLE_BURST_PURPLE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// QUAKED item_artifact_lavashield (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad181/artifact_lavashield.mdl"); }
// Player takes no HP/armour damage from lava for 30s
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (1-x seconds, default varies)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// noise        : Custom pickup sound for powerup
// volume       : Maximum range for volume (def=1, no sound=-1)
// cnt          : override duration of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS: No particle or effects active
// -------- NOTES --------
// Player takes no HP/armour damage from lava for 30s
void() item_artifact_lavashield = { // [ENTITY]
	if (artifact_checkrandomizer()) return; // Check for any random setups

	item_setupmodel("progs/ad181/artifact_lavashield.mdl",0);
	item_setupnoise(SOUND_ARTLSHIELD1);
	self.noise1 = SOUND_ARTLSHIELD2;
	self.noise2 = SOUND_ARTLSHIELD3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Aegis of Chthon";
	self.items = 0;
	self.moditems = IT_ARTLAVASHIELD;
	self.classtype = CT_ARTLAVASHIELD;
	self.part_active = PARTICLE_STYLE_LAVASHIELD;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	SUB_BoundVolume(1);
	artifact_setup();
};

// QUAKED item_artifact_blastbelt (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad181/artifact_blastbelt.mdl"); }
// Player is immune to Splash Damage for 30 seconds
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (1-x seconds, default varies)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// noise        : Custom pickup sound for powerup
// cnt          : Duration override of artifact (default = 30s)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Player is immune to Splash Damage for 30 seconds
void() item_artifact_blastbelt = { // [ENTITY]
	if (artifact_checkrandomizer()) return; // Check for any random setups

	item_setupmodel("progs/ad181/artifact_blastbelt.mdl",0);
	item_setupnoise(SOUND_ARTBLASTBELT1);
	self.noise1 = SOUND_ARTBLASTBELT2;
	self.noise2 = SOUND_ARTBLASTBELT3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Blast Belt";
	self.items = 0;
	self.moditems = IT_ARTBLASTBELT;
	self.classtype = CT_ARTBLASTBELT;
	self.part_active = PARTICLE_STYLE_BLASTBELT;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 8';
	artifact_setup();
};

// QUAKED item_artifact_jumpboots (0 0.5 0.8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad181/artifact_jumpboots.mdl"); }
// Player can do extra (1-4) jumps in mid air
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message      : centerprint message when item is picked up
// respawn_time : time to wait before respawning (1-x seconds, default varies)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// noise        : Custom pickup sound for powerup
// cnt          : Duration override of artifact (default = 999999s)
// count        : Power level override (0=def, 1-4=exact level, -1=endless)
// height       : 2nd+ player jump height upward (def=320)
// distance     : Minimum forward momentum (def=0, recommend=320)
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Player can do extra (1-4) jumps in mid air
void() item_artifact_jumpboots = { // [ENTITY]
	if (artifact_checkrandomizer()) return;
	
	item_setupmodel("progs/ad181/artifact_jumpboots.mdl",0);
	item_setupnoise(SOUND_ARTJUMPBOOTS1);
	self.noise1 = SOUND_ARTJUMPBOOTS2;
	self.noise2 = SOUND_ARTJUMPBOOTS3A;	// First jump
	self.noise3 = SOUND_ARTJUMPBOOTS3B; // Second+ jump; sounds 3a-3c are used in client.qc (lines 915+).
	self.noise4 = SOUND_ARTJUMPBOOTS3C; // No more jumps
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);
	precache_sound (self.noise4);
	self.moditems = IT_ARTJUMPBOOTS;
	self.classtype = CT_ARTJUMPBOOTS;
	self.part_active = PARTICLE_STYLE_JUMPBOOTS;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 10';
	if (self.cnt < 1) self.cnt = LARGE_TIMER;
	if (self.count < -1 || self.count > ART_JUMPBOOTS_AIRMAX) self.count = 0;
	
	// Setup more descriptive pickup names
	if (self.netname == "") {
	if (self.count == 1) self.netname = "Jump Boots Level 1";
	else if (self.count == 2) self.netname = "Jump Boots Level 2";
	else if (self.count == 3) self.netname = "Jump Boots Level 3";
	else if (self.count == 4) self.netname = "Jump Boots Level 4";
	else self.netname = "Jump Boots + 1";
	} else self.netname = "Jump Boots";
	
	artifact_setup();
};

void() item_jboots = { item_artifact_jumpboots(); }; // [ENTITY], Redirect original JCR maps' entities

void() item_powerup_shield = { // [ENTITY]
	if (artifact_checkrandomizer()) return; // Check for any random setups

	item_setupmodel("progs/rogue/shield.mdl",0);
	item_setupnoise("rogue/shield/pickup.wav");
	self.noise1 = "rogue/shield/hit.wav";
	self.noise2 = SOUND_ARTPSHIELD3;
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Power Shield";
	self.items = IT_QUAD;
	self.items2 = IT2_SHIELD;
	self.classtype = CT_ARTPSHIELD;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

void() item_powerup_belt = { // [ENTITY]
	if (artifact_checkrandomizer()) return; // Check for any random setups
	
	item_setupmodel("progs/ad172/artifact_blastbelt.mdl",0); // sock originally did an orange skin version of rogue/beltup.mdl.  Changed to new model.  Adding here to have 2nd skin as an option.
	item_setupnoise("rogue/belt/pickup.wav");
	self.noise1 = "rogue/belt/use.wav";
	self.noise2 = "rogue/belt/fadeout.wav";
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Anti-Grav Belt";
	self.items = IT_QUAD;
	self.classtype = CT_ARTGRAVBELT;
	self.part_active = PARTICLE_STYLE_QUAD;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	self.cnt = 45;
	artifact_setup();
};

void() item_artifact_empathy_shields = { // [ENTITY]
	if (artifact_checkrandomizer()) return; // Check for any random setups

	item_setupmodel("progs/hipnotic/empathy.mdl",0);
	item_setupnoise("hipnotic/items/empathy.wav");
	self.noise1 = "hipnotic/items/empathy2.wav";
	self.noise2 = "items/suit2.wav";
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Empathy Shield";
	self.items2 = HIP_IT2_EMPATHY_SHIELDS;
	self.classtype = CT_ARTEMPATHY;
	self.part_active = PARTICLE_STYLE_SRING;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 6';
	artifact_setup();
};

void() item_artifact_lavasuit = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/suit2.mdl",1);
	item_setupnoise("items/suit.wav");
	self.noise1 = "items/suit2.wav";
	precache_sound (self.noise1);
	if (self.netname == "") self.netname = "Thermal Protection Suit";
	self.classtype = CT_ARTTHERMSUIT;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 6';
	artifact_setup();
};

void() item_artifact_trinity = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/quoth/trinity.mdl",0);
	item_setupnoise("quoth/items2/trintake.wav");
	self.noise1 = "quoth/items2/trinuse.wav";
	self.noise2 = "quoth/items2/trinend.wav";
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Trinity";
	self.items = IT_QUAD;
	self.items2 = IT2_TRINITY;
	self.classtype = CT_ARTTRINITY;
	self.part_active = PARTICLE_STYLE_SRING;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 6';
	artifact_setup();
};

void() item_artifact_cross = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/quoth/cross.mdl",0);
	item_setupnoise("quoth/items2/crostake.wav");
	self.noise2 = "quoth/items2/crosend.wav";
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Cross of Deflection";
	self.items = IT_QUAD;
	self.classtype = CT_ARTCROSS;
	self.part_active = PARTICLE_STYLE_QUAD;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

void() item_artifact_haste = { // [ENTITY]
	if (artifact_checkrandomizer()) return; // Check for any random setups
	
	item_setupmodel("progs/drake/wings2.mdl",0);
	item_setupnoise("taov/player/fast.wav");
	self.noise2 = "taov/player/bighit.wav";
	precache_sound (self.noise2);
	if (self.netname == "") self.netname = "Haste";
	self.items = POW_HASTE;
	self.classtype = CT_ARTHASTE;
	self.part_active = PARTICLE_STYLE_QUAD;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

void() item_flashlight_touch = {
	if (!(other.flags & FL_CLIENT)) return;
	if (other.health < 1) return;

	self.solid = SOLID_NOT;
	self.model = string_null;
	sprint(other,"You got the ");
	sprint(other,self.netname);
	sprint(other,"\n");
	sound(other,CHAN_VOICE,self.noise,TRUE,ATTN_NONE);
	Safe_stuffcmd(other,"bf\n");
	other.items3 = other.items3 | IT3_FLASHLIGHT;
};

void() item_flashlight = {
	if (deathmatch) { remove(self); return; }

	item_setupmodel("progs/quoth/flashlight.mdl",0);
	item_setupnoise("quoth/items/click.wav");
	self.touch2 = item_flashlight_touch;
	if (self.netname == "") self.netname = "Flashlight";
	self.classtype = CT_ARTFLASHLIGHT;
	setsize(self,VEC_HULL_MIN,VEC_HULL_MAX);
	item_start();
};

void() item_secrethunter_touch = {
	if (!(other.flags & FL_CLIENT)) return;
	if (other.health < 1) return;

	self.solid = SOLID_NOT;
	self.model = string_null;
	sprint(other,"You got the ");
	sprint(other,self.netname);
	sprint(other,"\n");
	sound(other,CHAN_VOICE,self.noise,TRUE,ATTN_NONE);
	Safe_stuffcmd(other,"bf\n");
	other.items3 = other.items3 | IT3_SECRETHUNTER;
	other.secrethunt_finished = time + 2;
};

void() item_secrethunter = {
	if (deathmatch) { remove(self); return; }

	item_setupmodel("progs/redfield/cat.mdl",0);
	item_setupnoise("redfield/misc/catsmeow.wav");
	self.touch2 = item_secrethunter_touch;
	if (self.netname == "") self.netname = "Secret Hunter, Loki's Cat";
	self.classtype = CT_ARTSECRETHUNTER;
	if (self.part_active == TRUE) misc_particle_burst_setup(); // Check for a particle burst setup
	self.part_active = 0;	// Must clear this afterward
	self.bbmins = '-16 -16 -16';
	self.bbmaxs = VEC_HULL_MAX;
	item_start();
};

void() horn_touch = { // [FUNCTION]
	if (!(other.flags & FL_CLIENT)) return;
	if (other.health < 1) return;

	self.solid = SOLID_NOT;
	self.model = string_null;
	sprint(other,"You got the ");
	sprint(other,self.netname);
	sprint(other,"\n");
	sound(other,CHAN_VOICE,self.noise,TRUE,ATTN_NONE);
	Safe_stuffcmd(other,"bf\n");
	activator = other;
	other.horn_active = TRUE;
	SUB_UseTargets();
	other.horn_active = FALSE;
};

void() item_artifact_horn = { // [ENTITY]
	if (deathmatch) { remove(self); return; }

	item_setupmodel("progs/hipnotic/horn.mdl",0);
	item_setupnoise("hipnotic/items/horn.wav");
	self.touch2 = horn_touch;
	setmodel (self,self.mdl);
	if (self.netname == "") self.netname = "Horn of Conjuring";
	if (self.noise == "") self.noise = "hipnotic/items/horn.wav";
	self.classtype = CT_ARTHORN;
	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
	item_start ();
};

void() item_hornofconjuring = { self.classname = "item_artifact_horn"; item_artifact_horn(); }; // [ENTITY]
void() item_artifact_shambler = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/drake/doll03.mdl";
    if (self.netname == "") self.netname = "Shambler Doll";
    if (self.noise == "") self.noise = "drake/items/shambler.wav";
	self.classname = "item_artifact_horn";
	item_artifact_horn();
};

void() item_artifact_monster = { // [ENTITY]
    if (self.mdl == "") self.mdl = "progs/drake/doll03.mdl";
    if (self.netname == "") self.netname = "Monster Doll";
    if (self.noise == "") self.noise = "drake/items/shambler.wav";
	self.classname = "item_artifact_horn";
	item_artifact_horn();
};

void() item_artifact_berserker = { // [ENTITY]
	item_setupmodel("progs/drake/zerkhelm.mdl",0);
	item_setupnoise("drake/items/zerkhelm.wav");
    self.netname = "Berserker Helm";
	self.classtype = CT_ARTBERSERK;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// Nailguns fire two nails at the price of one -- permanently.  Also fills nails to the maximum.
void() item_artifact_equalizer = { // [ENTITY]
	item_setupmodel("progs/drake/gemini.mdl",0);
	item_setupnoise("rogue/runes/end2.wav");
    self.netname = "Twin Shot";
	self.classtype = CT_ARTEQUALIZER;
	self.part_active = PARTICLE_STYLE_SRING;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_nails = world.deventity.ammo_nails + AMMO_MAXNAILS;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// Gives the player flying ability.
void() item_artifact_levitation = { // [ENTITY]
	item_setupmodel("progs/drake/levitate.mdl",0);
	item_setupnoise("nehahra/player/flight.wav");
	self.noise1 = "zerstorer/ambience/wingget.wav";
	self.noise2 = "zerstorer/ambience/wingend.wav";
	precache_sound (self.noise1);
	precache_sound (self.noise2);
    self.netname = "Boots of Levitation";
	self.classtype = CT_ARTLEVITATION;
	self.part_active = PARTICLE_STYLE_TOMEOFP;
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.respawn_ofs = '0 0 16';
	artifact_setup();
};

// Original classname in Zerstorer.  Replaced Zerstorer's Dark-Angel Wings with Boots of Levitation.
void() item_wings = {self.classname = "item_artifact_levitation"; item_artifact_levitation(); }; // [ENTITY]

// Shotguns fire faster -- permanently.  Also fills shells to the maximum.
void() item_artifact_optimizer = { // [ENTITY]
	item_setupmodel("progs/drake/shotty.mdl",0);
	item_setupnoise("rogue/runes/end3.wav");
    self.netname = "Optimizer";
	self.perms = POW_SHOTTYMAN;
	self.classtype = CT_ARTOPTIMIZER;
	self.part_active = PARTICLE_STYLE_ARMOR;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
	if (world.devdata & DEV_AMMO_N_HEALTH) world.deventity.ammo_shells = world.deventity.ammo_shells + AMMO_MAXSHELLS;
	artifact_setup();
};

// Raises health to maximum, then activates regeneration.  Player can regenerate health at a rate of 50 per minute.  Lasts until death or end of level.
void() item_artifact_regeneration = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	if (self.spawnflags & 1) {
		item_setupmodel("progs/drake/regen2.mdl",self.skin);
		self.perms = POW_REGENLESSER;
		if (self.netname == "") self.netname = "Lesser Rejuvenator";
	} else {
		item_setupmodel("progs/drake/regen.mdl",self.skin);
		self.perms = POW_REGEN;
		if (self.netname == "") self.netname = "Rejuvenator";
	}
	item_setupnoise("drake/items/regen.wav");
	self.classtype = CT_ARTREGEN;
	if (self.skin == 1) {
		self.exactskin = self.skin;
		self.part_active = PARTICLE_STYLE_PENT;
		self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
		self.respawn_time = 30;
	} else {
		self.part_active = PARTICLE_STYLE_SUIT;
		self.respawn_style = PARTICLE_BURST_GREEN + PARTICLE_BURST_CENTER;
	}
	self.respawn_ofs = '0 0 16';
    artifact_setup();
};

// Increases maximum health and health by 25.  Maximum health boost lasts until end of level.
void() item_artifact_vitality = { // [ENTITY]
	if (artifact_checkrandomizer()) return;

	item_setupmodel("progs/drake/life_up.mdl",0);
	item_setupnoise("drake/items/life_up.wav");
	self.perms = POW_VITALITY;
	if (self.netname == "") self.netname = "Heart of Darkness";
    self.max_health = 25;
	self.classtype = CT_ARTVITALITY;
	self.part_active = PARTICLE_STYLE_PENT;
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 16';
    artifact_setup();
};

void() item_artifact_random = { // [ENTITY]
	local float rnd;

	rnd = random() * 100;
	if (rnd < 5)
		item_artifact_envirosuit();
	else if (rnd < 10)
		item_artifact_invisibility();
	else if (rnd < 15)
		item_artifact_invulnerability();
	else if (rnd < 20)
		item_artifact_cross();
	else if (rnd < 25)
		item_artifact_empathy_shields();
	else if (rnd < 30)
		item_artifact_nail_piercer();
	else if (rnd < 35)
		item_artifact_sharp_shooter();
	else if (rnd < 40)
		item_artifact_super_damage();
	else if (rnd < 45)
		item_artifact_trinity();
	else if (rnd < 50)
		item_artifact_wetsuit();
	else
		item_backpack();
};