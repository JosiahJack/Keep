//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Function count: 22
//
// Implements: Powerup Reset System for the Player
//
// Description:
// Handles resetting various powerups when they need to fade off.
//=============================================================================

float PWR_FADING = 3;
void() SecretHunt;

void(entity targ, float powtimer) ResetPowerInvRing = { // [FUNCTION]
	if (powtimer == 0) {
		targ.items = targ.items - (targ.items & IT_INVISIBILITY);
		targ.invisible_finished = targ.invisible_time = 0;
		targ.modelindex = modelindex_player; // Reset player model
		targ.frame = 0;
	} else if (targ.items & IT_INVISIBILITY) {
		if (targ.invisible_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.invisible_finished = time + powtimer;
			targ.invisible_time = 1; // Enable fading message
		}
	}
};

void(entity targ, float powtimer) ResetPowerEnvSuit = { // [FUNCTION]
	if (powtimer == 0) {
		targ.items = targ.items - (targ.items & IT_SUIT);
		targ.radsuit_finished = targ.rad_time = 0;
	} else if (targ.items & IT_SUIT) {
		if (targ.radsuit_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.radsuit_finished = time + powtimer;
			targ.rad_time = 1; // Enable fading message
		}
	}
};

void(entity targ) ResetPowerThermSuit = { targ.therm_finished = targ.therm_time = 0; }; // [FUNCTION]

void(entity targ, float powtimer) ResetPowerPent = { // [FUNCTION]
	if (powtimer == 0) {
		targ.items = targ.items - (targ.items & IT_INVULNERABILITY);
		targ.invincible_finished = targ.invincible_time = 0;
	} else if (targ.items & IT_INVULNERABILITY) {
		if (targ.invincible_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.invincible_finished = time + powtimer;
			targ.invincible_time = 1; // Enable fading message
		}
	}
};

void(entity targ, float powtimer) ResetPowerQuad = { // [FUNCTION]
	if (powtimer == 0) targ.super_damage_finished = targ.super_time = 0;
	else if (targ.items & IT_QUAD) {
		if (targ.super_damage_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.super_damage_finished = time + powtimer;
			targ.super_time = 1; // Enable fading message
		}
	}
};

void(entity targ) ResetPowerShroom = { // [FUNCTION]
	dprint("Shroom reset\n");
	targ.shroom_finished = 0;
	setsize(targ,VEC_HULL_MIN,VEC_HULL_MAX);
	sound(targ,CHAN_VOICE,"qmaster/items/smb_bowserfalls.wav",1,ATTN_NORM);
	targ.velocity = '0 0 1'; // FULL STOP! (almost) Hope you weren't in the air
	targ.flags = targ.flags - FL_ONGROUND;
	targ.effects = targ.effects - EF_BRIGHTLIGHT;
	targ.legsattachment.scale = 1;
	targ.scale = 1;
	targ.view_ofs = '0 0 22';
};

// Quad screen effect is shared by several items
void(entity targ) ResetPowerQuadItem = { targ.items = targ.items - (targ.items & IT_QUAD); }; // [FUNCTION]

void(entity targ, float powtimer) ResetPowerSharp = { // [FUNCTION]
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTSHARP);
		targ.sharpshoot_finished = targ.sharpshoot_time = 0;
	} else if (targ.moditems & IT_ARTSHARP) {
		if (targ.sharpshoot_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.sharpshoot_finished = time + powtimer;
			targ.sharpshoot_time = 1; // Enable fading message
		}
	}
};

void(entity targ, float powtimer) ResetPowerPiercer = { // [FUNCTION]
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTPIERCE);
		targ.nailpiercer_finished = targ.nailpiercer_time = 0;
	} else if (targ.moditems & IT_ARTPIERCE) {
		if (targ.nailpiercer_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.nailpiercer_finished = time + powtimer;
			targ.nailpiercer_time = 1; // Enable fading message
		}
	}
};

void(entity targ) ResetPowerLevitation = { // [FUNCTION]
	targ.wing_finished = 0;
	targ.wing_time = 0;
	targ.gravity = fabs(targ.gravity);
};

void(entity targ, float powtimer) ResetPowerLavaShield = { // [FUNCTION]
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTLAVASHIELD);
		targ.lavashield_finished = targ.lavashield_time = 0;
	} else if (targ.moditems & IT_ARTLAVASHIELD) {
		if (targ.lavashield_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.lavashield_finished = time + powtimer;
			targ.lavashield_time = 1; // Enable fading message
		}
	}
};

void(entity targ, float powtimer) ResetPowerAirTank = { // [FUNCTION]
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTWETSUIT);
		targ.wetsuit_finished = targ.wetsuit_time = 0;
	} else if (targ.moditems & IT_ARTWETSUIT) {
		if (targ.wetsuit_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.wetsuit_finished = time + powtimer;
			targ.wetsuit_time = 1; // Enable fading message
		}
	}
};

void(entity targ, float powtimer) ResetPowerBlastbelt = { // [FUNCTION]
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTBLASTBELT);
		targ.blastbelt_finished = targ.blastbelt_time = 0;
	} else if (targ.moditems & IT_ARTBLASTBELT) {
		if (targ.blastbelt_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.blastbelt_finished = time + powtimer;
			targ.blastbelt_time = 1; // Enable fading message
		}
	}
};

void(entity targ, float powtimer) ResetPowerJumpBoots = { // [FUNCTION]
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTJUMPBOOTS);
		targ.jumpboots_finished = targ.jumpboots_time = 0;
	} else if (targ.moditems & IT_ARTJUMPBOOTS) {
		if (targ.jumpboots_finished > (time + powtimer) ) { // Stop powerup constantly being reset once below timer
			targ.jumpboots_finished = time + powtimer;
			targ.jumpboots_time = 1; // Enable fading message
		}
	}
};

void(entity targ) ResetPowerWetSuit = { // [FUNCTION]
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTWETSUIT);
	targ.wetsuit_finished = targ.wetsuit_time = 0;
};

void(entity targ, float powtimer, float novania) ResetPowerSystem = { // [FUNCTION]
	if (!(targ.flags & FL_CLIENT)) return; // This only works for player clients because of sounds.

	targ.effects = 0;
	ResetPowerInvRing(targ, powtimer);
	ResetPowerEnvSuit(targ, powtimer);
	ResetPowerThermSuit(targ);
	ResetPowerPent(targ, powtimer);
	ResetPowerQuad(targ, powtimer);
	if (targ.shroom_finished > 0) ResetPowerShroom(targ);
	ResetPowerSharp(targ, powtimer);
	ResetPowerPiercer(targ, powtimer);
	ResetPowerLevitation(targ);
	ResetPowerWetSuit(targ);
	// Don't reset Vania items
	if (novania) {
		ResetPowerLavaShield(targ, powtimer);
		ResetPowerAirTank(targ, powtimer);
		ResetPowerBlastbelt(targ, powtimer);
		ResetPowerJumpBoots(targ, powtimer);
	}
};

void(entity targ) PlayLavaShieldSound = { // [FUNCTION]
	if (!(targ.flags & FL_CLIENT)) return; // Only works for the player because of sounds.
	
	targ.air_finished = time + WATER_AIR; // Can still drown from liquid damage!?!
	
	if (targ.lavashield_sound < time) { // Time for another sound reminder?
		if (targ.lavashield_volume > 0) {
			targ.volume = (0.5 + random() * 0.5) * targ.lavashield_volume;
			if (targ.volume > 1) targ.volume = 1; // Make sure volume is within range (will get errors)
			sound (targ, CHAN_ITEM, SOUND_ARTLSHIELD3, targ.volume, ATTN_NORM);
		}
		targ.lavashield_sound = time + 2;
	}
};

void(entity targ) PlayBlastBeltSound = { // [FUNCTION]
	if (!(targ.flags & FL_CLIENT)) return; // Only works for the player because of sounds.

	if (targ.blastbelt_sound < time) { // Time for another sound reminder?
		if (targ.blastbelt_volume > 0) {
			targ.volume = (0.5 + random() * 0.5) * targ.blastbelt_volume;
			if (targ.volume > 1) targ.volume = 1; // Make sure volume is within range (will get errors)
			sound (targ, CHAN_ITEM, SOUND_ARTBLASTBELT3, targ.volume, ATTN_NORM);
		}
		targ.blastbelt_sound = time + 2;
	}
};

void(entity targ) PlayPentagramSound = { // [FUNCTION]
	if (!(targ.flags & FL_CLIENT)) return; // Only works for the player because of sounds.
	
	if (targ.invincible_sound < time) { // Time for another sound reminder?
		sound (targ, CHAN_ITEM, SOUND_ARTPENT3, 1, ATTN_NORM);
		targ.invincible_sound = time + 2;
	}
};

// Returns the ammo charge level.  Called by the equivalent of CheckPowerups.
// Charging notes, for normal mode flare gun:
// * Charging can be done only while holding the weapon.
// * The time to charge a super shot is double the time needed for
//  a full spray of mini-shots.  For example, if it takes one second
//  to charge a spray of three shots, it takes one more second for the
//  super shot.
float(entity ent) Zapper_Level = { // [FUNCTION]
    local float tnt;

    if (ent.attack_finished > time) return 0; // Can't shoot yet.

    if (ent.tome_finished) {
		ent.zapper_time = 0; // In case tome wears off before discharge.
        return WAND_FULL + 2;
    }
    if (time < ent.zapper_time) return 0; // Don't let rollover mess up counters.

	// 0-1 = 1, 1-2 = 2, 2-3 = 3, 3-5 = 4.
    tnt = ceil((time - ent.zapper_time) / WAND_DELAY);
    if (tnt >= (WAND_FULL * 2 - 1)) return WAND_FULL + 1; // e.g., best 3 out of 5.
    if (tnt > WAND_FULL) return WAND_FULL;
    return tnt; 
};

void() ClientPowerups = { // [FUNCTION]
	if (frame_pause()) return; // Exceptions: Dead, intermission or cinematic cameras
	if (self.health < 1) return;

	if ((self.items3 & IT3_SECRETHUNTER)) SecretHunt();

	// Invisibility (Gold Ring) - Flash screen 3s before running out
	if (self.invisible_finished > 0) {
		if (self.invisible_sound < time) { // sound and screen flash when items starts to run out
			sound (self, CHAN_AUTO, SOUND_ARTINV3, 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}

		if (self.invisible_finished < time + PWR_FADING) {
			if (self.invisible_time == 1) {
				sprint(self, "Ring of Shadows magic is fading\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTINV2, 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time) {
				self.invisible_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.invisible_finished < time) ResetPowerInvRing(self,0);
		else {
			self.modelindex = modelindex_eyes; // keep using the eyes
			self.frame = 0;
		}
	} else {
		if (self.in_a_vehicle) self.modelindex = modelindex_null;
		else {
			if (self.weapon == IT2_MJOLNIR && !self.selfweaponismoditems) {
				if (self.hammer_finished) self.modelindex = modelindex_hamout; // Hammer has been thrown out.
				else self.modelindex = modelindex_hammer; // We are holding the hammer.
			} else if (self.weapon == IT_AXE && self.perms & IT_CHAINSAW && !self.selfweaponismoditems) self.modelindex = modelindex_saw;
			else if (self.weaponmodel == "") self.modelindex = modelindex_hamout;
			else self.modelindex = modelindex_player;
		}
	}

	// Environmental Protection Suit.  Flash screen 3s before running out.  Give player standard 12s of air after suit finishes.
	if (self.radsuit_finished > 0) {
		self.air_finished = time + WATER_AIR;		// don't drown
		if (self.radsuit_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.rad_time == 1) {
				sprint(self, "Air supply in Biosuit expiring\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSUIT2, 1, ATTN_NORM);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time) {
				self.rad_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.radsuit_finished < time) ResetPowerEnvSuit(self,0); // Update inventory, refresh air and timers.
	}

	// Thermal Protection Suit.  Flash screen 3s before running out.  Give player standard 12s of air after suit finishes.
	if (self.therm_finished > 0) {
		self.air_finished = time + WATER_AIR;		// don't drown
		if (self.therm_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.therm_time == 1) {
				sprint(self, "Thermal protection suit is expiring\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSUIT2, 1, ATTN_NORM);
				self.therm_time = time + 1;
			}

			if (self.therm_time < time) {
				self.therm_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.therm_finished < time) ResetPowerThermSuit(self); // Update inventory and timers
	}
	
	// Lava Shield (Aegis of Chthon).  Flash screen 3s before running out.
	if (self.lavashield_finished > 0) {
	// sound and screen flash when items starts to run out
		if (self.lavashield_finished < time + 3) {
			if (self.lavashield_time == 1) {
				sprint(self, "Aegis is falling apart!\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTLSHIELD2, 1, ATTN_NORM);
				self.lavashield_time = time + 1;
			}

			if (self.lavashield_time < time) {
				self.lavashield_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		if (self.lavashield_finished < time) ResetPowerLavaShield(self,0); // Update inventory and timers
	}

	// Wet Suit.  Flash screen 3s before running out.  Give player 12s of air after suit finishes.
	if (self.wetsuit_finished > 0) {
		self.air_finished = time + WATER_AIR;		// don't drown

		// Produce particle bubbles.
		if (self.waterlevel == 3) {
			if (self.wetsuit_bubbles < time) {
				self.wetsuit_bubbles = time + 0.5 + random();
				particle_debuff(self.origin, 16, rint(10+random()*40), PARTICLE_BURST_BLUE);
			}
		}
		
		// Check to see if the water level has changed.
		if (self.wetsuit_level != self.waterlevel) {
			if (self.wetsuit_level > 2 && self.waterlevel < 3) self.wetsuit_sound = 0; // Is the player coming out of the water? 
			else if (self.wetsuit_level < 3 && self.waterlevel > 2) self.wetsuit_sound = 0; // Is the player going into the water? (above head)
			self.wetsuit_level = self.waterlevel;
		}		

		if (self.wetsuit_sound < time) { // Play active sound based on water level.
			if (self.waterlevel == 3) {
				// Under water sound with bubbbles
				self.volume = 0.5 + random() * 0.5;
				sound (self, CHAN_ITEM, SOUND_ARTWETS3, self.volume, ATTN_IDLE);
				self.wetsuit_sound = time + 4;
			} else {
				// Different sound when not in the water (faster)
				self.volume = 0.4 + random() * 0.4;
				sound (self, CHAN_ITEM, SOUND_ARTWETS3B, self.volume, ATTN_IDLE);
				self.wetsuit_sound = time + 3 + random();
			}
		}
		
		if (self.wetsuit_finished < time + 3) { // sound and screen flash when items starts to run out
			self.wetsuit_sound = time + 4;	// Stop breathing sound
			if (self.wetsuit_time == 1) {
				sprint(self, "Air supply in Wet suit expiring\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTWETS2, 1, ATTN_NORM);
				self.wetsuit_time = time + 1;
			}

			if (self.wetsuit_time < time) {
				self.wetsuit_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.wetsuit_finished < time) ResetPowerWetSuit(self); // Update inventory and timers.
	}

	// Invincibility (Pentagram).  Flash screen 3s before running out
	if (self.invincible_finished > 0) {
		if (self.invincible_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.invincible_time == 1) {
				sprint(self, "Protection is almost burned out\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTPENT2, 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time) {
				self.invincible_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		if (self.invincible_finished < time) ResetPowerPent(self,0); // Update inventory and timers.
	}

	// Super Damage (Quad).  Flash screen 3s before running out.
	if (self.super_damage_finished > 0) {
		if (self.super_damage_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.super_time == 1) {
				sprint(self, "Quad Damage is wearing off\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTQUAD2, 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			if (self.super_time < time) {
				self.super_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.super_damage_finished < time) ResetPowerQuad(self,0); // Update inventory and timers
	}	

	// Blast Belt.  Splash Damage Immunity.   Flash screen 3s before running out.
	if (self.blastbelt_finished > 0) {
		if (self.blastbelt_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.blastbelt_time == 1) {
				sprint(self, "Blast belt is failing\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTBLASTBELT2, 1, ATTN_NORM);
				self.blastbelt_time = time + 1;
			}

			if (self.blastbelt_time < time) {
				self.blastbelt_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		
		if (self.blastbelt_finished < time) ResetPowerBlastbelt(self,0); // Update inventory and timers
	}

	// Jump Boots - Vertical Height Exploration
	if (self.jumpboots_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.jumpboots_finished < time + 3) {
			if (self.jumpboots_time == 1) {
				sprint(self, "Jump Boots are wearing off\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTJUMPBOOTS2, 1, ATTN_NORM);
				self.jumpboots_time = time + 1;
			}

			if (self.jumpboots_time < time) {
				self.jumpboots_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		
		if (self.jumpboots_finished < time) ResetPowerJumpBoots(self,0); // Update inventory and timers
	}

	// SharpShooter.  Flash screen 3s before running out.
	if (self.sharpshoot_finished > 0) {
		if (self.sharpshoot_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.sharpshoot_time == 1) {
				sprint(self, "Sharpshooter has almost gone\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSHARP2, 1, ATTN_NORM);
				self.sharpshoot_time = time + 1;
			}
			if (self.sharpshoot_time < time) {
				self.sharpshoot_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		if (self.sharpshoot_finished < time) ResetPowerSharp(self,0); // Update inventory and timers
	}

	// Nail Piercer.  Flash screen 3s before running out.
	if (self.nailpiercer_finished > 0) {
		if (self.nailpiercer_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.nailpiercer_time == 1) {
				sprint(self, "Nail Piercer is wearing off\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTNAILP2, 1, ATTN_NORM);
				self.nailpiercer_time = time + 1;
			}

			if (self.nailpiercer_time < time) {
				self.nailpiercer_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.nailpiercer_finished < time) ResetPowerPiercer(self,0); // Update inventory and timers
	}

	// Boots of Levitation.  Flash screen 3s before running out.
	if (self.wing_finished > 0) {
		if (self.wing_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.wing_time == 1) {
				sprint(self, "Boots of Levitation are fading\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "zerstorer/ambience/wingend.wav", 1, ATTN_NORM);
				self.wing_time = time + 1;
			}

			if (self.wing_time < time) {
				self.wing_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.wing_finished < time) ResetPowerLevitation(self); // Update inventory and timers
	}	

	if (self.tome_finished > 0) {
		if (self.tome_finished < time + 3) { // sound and screen flash when items starts to run out
			if (self.tome_time == 1) {
				sprint(self, "Tome of Power is wearing off\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "drake/items/tomepow2.wav", 1, ATTN_NORM);
				self.tome_time = time + 1;
			}
 
			if (self.tome_time < time) {
				self.tome_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		if (self.tome_finished < time) self.tome_finished = 0; // Update inventory and timers
	}

	if (self.shroom_finished < time && self.shroom_finished > 0) ResetPowerShroom(self);

	// Only remove the quad effect (status bar update) if all extra mod artifacts have expired as well.
	if (self.super_damage_finished == 0 && self.sharpshoot_finished == 0 && self.nailpiercer_finished == 0) ResetPowerQuadItem(self);

	// This check for setting the client effect needs to be separate because its setup by several different artifacts!
	if (self.super_damage_finished > 0 || self.invincible_finished > 0 ||
		self.sharpshoot_finished > 0 || self.nailpiercer_finished > 0) {
		self.effects = self.effects | EF_DIMLIGHT;
	} else self.effects = self.effects - (self.effects & EF_DIMLIGHT);

	if (self.items2 & IT2_CROSS && self.weapon == IT2_CROSS && !self.selfweaponismoditems) self.currentammo = Zapper_Level(self);
};

// If a thrown hammer was removed without resetting the hammer time,
// the player cannot use the hammer again, until time is set back to zero.
// This function is a fail-safe that will return the hammer back to the
// player in case a hammer gets lost. PM:  Only players should use this.
void() CheckMjolnir = { // [FUNCTION]
    if (self.hammer_finished && self.hammer_finished < time) {
		self.hammer_finished = 0;
		W_SetCurrentAmmo(self);
    }
};

void() SecretHunt = {
	local entity head;
	local float dist, pingt, lerp;

	if (self.secrethunt_finished >= time) return;

	head = find(world,classname,"trigger_secret");
	dist = fabs(vlen(self.origin - head.oldorigin));
	pingt = 2;
	while (head) {
		if (head.count > 0) {
			dist = vlen(head.oldorigin - self.origin);
			if (dist <= 384) {
				lerp = dist / 384;
				pingt = SUB_ClampFloat(lerp * 4,0.6,4);
				self.secrethunt_finished = time + pingt;
				sound(self,CHAN_AUTO,"redfield/misc/catsmeow.wav",
					  SUB_ClampFloat(1 - lerp,0.3,1),ATTN_NORM); // PING!
				return;
			}
		}
		head = find(head,classname,"trigger_secret");
	}
	self.secrethunt_finished = time + pingt;
};