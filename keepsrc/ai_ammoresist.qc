//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: My own, Arms of Asgard (AoA) and Arcane Dimensions (AD)
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
// Entity count: 0 - Utility functions only.
// Function count: 6
//
// Implements: Ammo Resistance System
//
// Description:
// Handles changing damage value and creating effects to indicate
// inneffectiveness of certain weapons against certain monsters.
//=============================================================================

float(entity targ, float resist_type, float damage) Resist_Damage = {
	local float ret_damage;

	ret_damage = damage; // Added just in case we passed a bad value, we will get same damage instead of 0
	if (resist_type == AM_SHELLS) ret_damage = damage * (1 - targ.resist_shells);
	else if (resist_type == AM_NAILS) ret_damage = damage * (1 - targ.resist_nails);
	else if (resist_type == AM_ROCKETS) ret_damage = damage * (1 - targ.resist_rockets);
	else if (resist_type == AM_CELLS) ret_damage = damage * (1 - targ.resist_cells);
	else if (resist_type == AM_LAVANAILS) ret_damage = damage * (1 - targ.resist_lava_nails);
	else if (resist_type == AM_MULTI_ROCKETS) ret_damage = damage * (1 - targ.resist_multi_rockets);
	else if (resist_type == AM_PLASMA) ret_damage = damage * (1 - targ.resist_plasma);
	else if (resist_type == AM_BOLTS) ret_damage = damage * (1 - targ.resist_bolts);
	else if (resist_type == AM_POISON) ret_damage = damage * (1 - targ.resist_poison);
	else if (resist_type == AM_BLOODCRYSTALS) ret_damage = damage * (1 - targ.resist_bloodcrystals);
	else if (resist_type == AM_VOIDSHARDS) ret_damage = damage * (1 - targ.resist_voidshards);
	else if (resist_type == AM_ELEMENTAL) ret_damage = damage * (1 - targ.resist_elemental);
	else if (resist_type == AM_ACID) ret_damage = damage * (1 - targ.resist_acid);
	else if (resist_type == AM_FIRE) ret_damage = damage * (1 - targ.resist_fire);
	else if (resist_type == AM_COLD) ret_damage = damage * (1 - targ.resist_cold);
	return ret_damage;
};

float RESIST_MIN = 0.00;
float RESIST_MAX = 1.00;

// Double check that all ammo resistance are within range of 0 to 1
void(entity targ) Resist_CheckRange = {
	targ.resist_shells = SUB_ClampFloat(targ.resist_shells,RESIST_MIN,RESIST_MAX);
	targ.resist_nails = SUB_ClampFloat(targ.resist_nails,RESIST_MIN,RESIST_MAX);
	targ.resist_rockets = SUB_ClampFloat(targ.resist_rockets,RESIST_MIN,RESIST_MAX);
	targ.resist_cells = SUB_ClampFloat(targ.resist_cells,RESIST_MIN,RESIST_MAX);
	targ.resist_lava_nails = SUB_ClampFloat(targ.resist_lava_nails,RESIST_MIN,RESIST_MAX);
	targ.resist_multi_rockets = SUB_ClampFloat(targ.resist_multi_rockets,RESIST_MIN,RESIST_MAX);
	targ.resist_plasma = SUB_ClampFloat(targ.resist_plasma,RESIST_MIN,RESIST_MAX);
	targ.resist_bolts = SUB_ClampFloat(targ.resist_bolts,RESIST_MIN,RESIST_MAX);
	targ.resist_poison = SUB_ClampFloat(targ.resist_poison,RESIST_MIN,RESIST_MAX);
	targ.resist_bloodcrystals = SUB_ClampFloat(targ.resist_bloodcrystals,RESIST_MIN,RESIST_MAX);
	targ.resist_voidshards = SUB_ClampFloat(targ.resist_voidshards,RESIST_MIN,RESIST_MAX);
	targ.resist_elemental = SUB_ClampFloat(targ.resist_elemental,RESIST_MIN,RESIST_MAX);
	targ.resist_acid = SUB_ClampFloat(targ.resist_acid,RESIST_MIN,RESIST_MAX);
	targ.resist_fire = SUB_ClampFloat(targ.resist_fire,RESIST_MIN,RESIST_MAX);
	targ.resist_cold = SUB_ClampFloat(targ.resist_cold,RESIST_MIN,RESIST_MAX);
};

// Store the ammo resistance for switching later
void(entity targ) Resist_Save = {
	targ.save_shells 		= targ.resist_shells;
	targ.save_nails 		= targ.resist_nails;
	targ.save_rockets 		= targ.resist_rockets;
	targ.save_cells 		= targ.resist_cells;
	targ.save_lava_nails 	= targ.resist_lava_nails;
	targ.save_multi_rockets = targ.resist_multi_rockets;
	targ.save_plasma 		= targ.resist_plasma;
	targ.save_bolts 		= targ.resist_bolts;
	targ.save_poison 		= targ.resist_poison;
	targ.save_bloodcrystals = targ.resist_bloodcrystals;
	targ.save_voidshards 	= targ.resist_voidshards;
	targ.save_elemental 	= targ.resist_elemental;
};

// Switch resistance from FULL to monster default.  This works with Resist_Save system.
void(entity targ, float artype) Resist_ChangeType = {
	if (!targ) return;

	if (artype > 0) {
		// Complete resistance to everything
		targ.resist_shells = 1;
		targ.resist_nails = 1;
		targ.resist_rockets = 1;
		targ.resist_cells = 1;
		targ.resist_lava_nails = 1;
		targ.resist_multi_rockets = 1;
		targ.resist_plasma = 1;
		targ.resist_bolts = 1;
		targ.resist_poison = 1;
		targ.resist_bloodcrystals = 1;
		targ.resist_voidshards = 1;
		targ.resist_elemental = 1;
		targ.pain_finished = LARGE_TIMER;
	} else if (artype < 0) {
		// No resistance to anything!
		targ.resist_shells = 0;
		targ.resist_nails = 0;
		targ.resist_rockets = 0;
		targ.resist_cells = 0;
		targ.resist_lava_nails = 0;
		targ.resist_multi_rockets = 0;
		targ.resist_plasma = 0;
		targ.resist_bolts = 0;
		targ.resist_poison = 0;
		targ.resist_bloodcrystals = 0;
		targ.resist_voidshards = 0;
		targ.resist_elemental = 0;
	} else {
		// Default ammo resist, rocket/cell immunnity
		targ.resist_shells = targ.save_shells;
		targ.resist_nails = targ.save_nails;
		targ.resist_rockets = targ.save_rockets;
		targ.resist_cells = targ.save_cells;
		targ.resist_lava_nails = targ.save_lava_nails;
		targ.resist_multi_rockets = targ.save_multi_rockets;
		targ.resist_plasma = targ.save_plasma;
		targ.resist_bolts = targ.save_bolts;
		targ.resist_poison = targ.save_poison;
		targ.resist_bloodcrystals = targ.save_bloodcrystals;
		targ.resist_voidshards = targ.save_voidshards;
		targ.resist_elemental = targ.save_elemental;
		targ.pain_finished = time + 1;
	}
};

void(entity targ, string hitsound) Resist_Sound = {
	if (hitsound != "") {
		if (hitsound == SOUND_AXE_STONE) {
			sound (targ, CHAN_WEAPON, hitsound, 1, ATTN_NORM);
		} else {
			if (targ.health > 0 && targ.pain_finished < time) {
				targ.pain_finished = time + 0.3 + random();
				if (hitsound != targ.pain_sound) {
					if (targ.pain_sound != "") sound (targ, CHAN_VOICE, targ.pain_sound, 1, ATTN_NORM);
					else sound (targ, CHAN_VOICE, hitsound, 1, ATTN_NORM);
				} else {
					sound (targ, CHAN_VOICE, hitsound, 1, ATTN_NORM);
				}
			}
		}
	}
};

void(entity targ, vector org, vector vel, float damage, float type, string hitsound, string burstsound) Resist_Effects = {
	if (type == AM_NONE) {
		Resist_Sound(targ,hitsound); // Always play stone smack sound
		if (random() < 0.5) Tent_Point(TE_SPIKE,org); // Particle impact
		else Tent_Point(TE_GUNSHOT,org); 
	}

	if (type == AM_SHELLS) {
		if (targ.resist_shells < 1){
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			SpawnBlood(targ, org, vel*0.2, rint(damage*targ.resist_shells),0); // Drastically reduced blood particles
		}
		if (random() < 0.3) {
			if (random() < 0.5) Tent_Point(TE_SPIKE,org);
			else Tent_Point(TE_GUNSHOT,org);

			SpawnProjectileSmoke(org, 200, 50, 150);
		}
	}

	if (type == AM_NAILS) {
		if (targ.resist_nails < 1) Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
		if (random() < 0.5) Tent_Point(TE_SPIKE,org);
		else Tent_Point(TE_GUNSHOT,org);

		if (random() < 0.5) SpawnProjectileSmoke(org, 200, 50, 150);
	}

	if (type == AM_ROCKETS) {
		if (targ.resist_rockets < 1) {
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			SpawnProjectileMeat(targ, org, 200, 50, 150);
			SpawnProjectileMeat(targ, org, 300, 50, 150);
		}
		SpawnExplosion(EXPLODE_BURST_SMOKE,org,burstsound);
		SpawnProjectileSmoke(org, 200, 50, 150);
		SpawnProjectileSmoke(org, 200, 50, 250);
		SpawnProjectileSmoke(org, 300, 50, 150);
	}

	if (type == AM_CELLS || type == AM_COLD) {
		if (targ.resist_cells < 1) {
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			if (random() < 0.4) SpawnProjectileMeat(targ, org, 200, 50, 150); // Same for meat as pain sound
		}
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		if (burstsound == SOUND_PLASMA_HIT) {
			// Cell projectiles such as AD plasmagun, lasers, etc.
			SpawnExplosion(EXPLODE_BURST_SMOKE, org, burstsound);
			SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
			SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
		} else {
			// Lightning beam resistance
			if (self.lightning_timer < time) { // Don't spawn smoke constantly (let the sprite finish)
				self.lightning_timer = time + 0.3;
				SpawnExplosion(EXPLODE_BURST_SMOKE, org, "");
			}
		}
	}

	if (type == AM_LAVANAILS || type == AM_FIRE) {
		if (targ.resist_lava_nails < 1) Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
		if (random() < 0.5) Tent_Point(TE_SPIKE,org);
		else Tent_Point(TE_GUNSHOT,org);

		if (random() < 0.7) SpawnProjectileSmoke(org, 200, 50, 150);
		if (random() < 0.5) SpawnProjectileSmoke(org, 200, 50, 250);
	}

	if (type == AM_MULTI_ROCKETS) {
		if (targ.resist_multi_rockets < 1) {
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			SpawnProjectileMeat(targ, org, 200, 50, 150);
			SpawnProjectileMeat(targ, org, 300, 50, 150);
		}
		SpawnExplosion(EXPLODE_BURST_SMOKE,org,burstsound);
		SpawnProjectileSmoke(org, 200, 50, 150);
		SpawnProjectileSmoke(org, 200, 50, 250);
		SpawnProjectileSmoke(org, 300, 50, 150);
	}

	if (type == AM_PLASMA) {
		if (targ.resist_cells < 1) {
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			if (random() < 0.4) SpawnProjectileMeat(targ, org, 200, 50, 150); // Same for meat as pain sound
		}
		SpawnExplosion(EXPLODE_BURST_SMOKE, org, burstsound);
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
		SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
	}

	if (type == AM_BOLTS) {
		if (targ.resist_bolts < 1) {
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			SpawnProjectileMeat(targ, org, 200, 50, 150);
			SpawnProjectileMeat(targ, org, 300, 50, 150);
		}
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
		SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
	}

	if (type == AM_POISON || type == AM_ACID) {
		if (targ.resist_poison < 1) {
			Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
			SpawnProjectileMeat(targ, org, 200, 50, 150);
			SpawnProjectileMeat(targ, org, 300, 50, 150);
		}
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
		SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
	}

	if (type == AM_BLOODCRYSTALS) {
		if (targ.resist_bloodcrystals < 1) Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
		SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
	}

	if (type == AM_VOIDSHARDS) {
		if (targ.resist_voidshards < 1) Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
		SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
	}

	if (type == AM_ELEMENTAL) {
		if (targ.resist_elemental < 1) Resist_Sound(targ,hitsound); // Only play pain sound if we can still get hurt slightly
		SpawnProjectileSmoke(org, 200, 50, 150); // Spawn a random smoke particle and chance of blood
		SpawnProjectileSmoke(org, 200, 50, 250); // Extra smoke puffs
		SpawnProjectileSmoke(org, 300, 50, 150); // Extra smoke puffs
	}
};