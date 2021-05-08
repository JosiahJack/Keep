/*======================================================================
	CheckPowerups
	- Check for turning off powerups
======================================================================*/
//----------------------------------------------------------------------
void(entity targ) ResetPowerEnvSuit =
{
	targ.items = targ.items - (targ.items & IT_SUIT);
	targ.radsuit_finished = targ.rad_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerPent =
{
	targ.items = targ.items - (targ.items & IT_INVULNERABILITY);
	targ.invincible_finished = targ.invincible_time = 0;
};

void(entity targ) ResetPowerInvRing =
{
	targ.items = targ.items - (self.items & IT_INVISIBILITY);
	targ.invisible_finished = targ.invisible_time = 0;
	targ.modelindex = modelindex_player;
	targ.frame = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerQuad = {
	targ.super_damage_finished = targ.super_time = 0;};
void(entity targ) ResetPowerQuadItem = {
	targ.items = targ.items - (targ.items & IT_QUAD);};

//----------------------------------------------------------------------
void(entity targ) ResetPowerSharp =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTSHARP);
	targ.sharpshoot_finished = targ.sharpshoot_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerPiercer =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTPIERCE);
	targ.nailpiercer_finished = targ.nailpiercer_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerLavaShield =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTLAVASHIELD);
	targ.lavashield_finished = targ.lavashield_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerWetSuit =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTWETSUIT);
	targ.wetsuit_finished = targ.wetsuit_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerBlastbelt =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTBLASTBELT);
	targ.blastbelt_finished = targ.blastbelt_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerJumpBoots =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTJUMPBOOTS);
	targ.jumpboots_finished = targ.jumpboots_time = 0;
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerSystem =
{
	// This only works for player clients
	if (!(targ.flags & FL_CLIENT)) return;
	
	targ.effects = 0;
	ResetPowerInvRing(targ);
	ResetPowerEnvSuit(targ);
	ResetPowerPent(targ);
	ResetPowerQuad(targ);
	ResetPowerQuadItem(targ);
	ResetPowerSharp(targ);
	ResetPowerPiercer(targ);
	ResetPowerLavaShield(targ);
	ResetPowerWetSuit(targ);
	ResetPowerBlastbelt(targ);
	ResetPowerJumpBoots(targ);
};

//============================================================================
void() ClientPowerups =
{
	// Exceptions: Dead, intermission or cinematic cameras
	if (self.health < 1) return;
	if (intermission_running > 0) return;
	if (cinematic_running > 0) return;

	//----------------------------------------------------------------------
	// Invisibility (Gold Ring)
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.invisible_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.invisible_sound < time) {
			sound (self, CHAN_AUTO, SOUND_ARTINV3, 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}

		if (self.invisible_finished < time + 3) {
			if (self.invisible_time == 1) {
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTINV2, 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time) {
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.invisible_finished < time) ResetPowerInvRing(self);
		else {
			// keep using the eyes
			self.modelindex = modelindex_eyes;
			self.frame = 0;
		}
	}

	//----------------------------------------------------------------------
	// Env Suit	
	// - Flash screen 3s before running out
	// - Give player 12s of air after suit finishes
	//----------------------------------------------------------------------
	if (self.radsuit_finished > 0) {
		self.air_finished = time + WATER_AIR;	// don't drown

	// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3) {
			if (self.rad_time == 1) {
				sprint (self, "Air supply in Biosuit expiring!\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSUIT2, 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			if (self.rad_time < time) {
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.radsuit_finished < time) ResetPowerEnvSuit(self);
	}
	
	//----------------------------------------------------------------------
	// Invincibility (Pentagram)
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.invincible_finished > 0) {
	// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3) {
			if (self.invincible_time == 1) {
				sprint (self, "Protection is almost burned out!\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTPENT2, 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			if (self.invincible_time < time) {
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.invincible_finished < time) ResetPowerPent(self);
	}

	//----------------------------------------------------------------------
	// Super Damage (Quad)
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.super_damage_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3) {
			if (self.super_time == 1) {
				sprint (self, "Quad Damage is wearing off!\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTQUAD2, 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			if (self.super_time < time) {
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.super_damage_finished < time) ResetPowerQuad(self);
	}	

	//----------------------------------------------------------------------
	// Lava Shield (Aegis of Chthon)
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.lavashield_finished > 0) {
	// sound and screen flash when items starts to run out
		if (self.lavashield_finished < time + 3) {
			if (self.lavashield_time == 1) {
				sprint (self, "Aegis is falling apart!\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTLSHIELD2, 1, ATTN_NORM);
				self.lavashield_time = time + 1;
			}
			if (self.lavashield_time < time) {
				self.lavashield_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.lavashield_finished < time) ResetPowerLavaShield(self);
	}

	//----------------------------------------------------------------------
	// Wet Suit	
	// - Flash screen 3s before running out
	// - Give player 12s of air after suit finishes
	//----------------------------------------------------------------------
	if (self.wetsuit_finished > 0) {
		self.air_finished = time + 12;		// don't drown

		// Produce particle bubbles
		if (self.waterlevel == 3) {
			if (self.wetsuit_bubbles < time) {
				self.wetsuit_bubbles = time + 0.5 + random();
				particle_debuff(self.origin, 16, rint(10+random()*40), PARTICLE_BURST_BLUE);
			}
		}
		
		// Check to see if the water level has changed
		if (self.wetsuit_level != self.waterlevel) {
			// Is the player coming out of the water?
			if (self.wetsuit_level > 2 && self.waterlevel < 3)
				self.wetsuit_sound = 0;
			// Is the player going into the water? (above head)
			else if (self.wetsuit_level < 3 && self.waterlevel > 2)
				self.wetsuit_sound = 0;
			self.wetsuit_level = self.waterlevel;
		}		
		
		// Play active sound based on water level
		// Check for silent sound option (1.7 Patch 2)
		if (self.wetsuit_sound < time && self.wetsuit_silent == FALSE) {
			if (self.waterlevel == 3) {
				// Under water sound with bubbbles
				if (self.wetsuit_volume > 0) {
					self.volume = (0.5 + random() * 0.5) * self.wetsuit_volume;
					// Make sure volume is within range (will get errors)
					if (self.volume > 1) self.volume = 1;
					// Play underwater sound (breathing + bubbles)
					sound (self, CHAN_ITEM, SOUND_ARTWETS3, self.volume, ATTN_IDLE);
				}
				self.wetsuit_sound = time + 4;
			}
			else {
				if (!self.wetsuit_outwater) {
					// Different sound when not in the water (faster)
					if (self.wetsuit_volume > 0) {
						self.volume = (0.3 + random() * 0.3) * self.wetsuit_volume;
						// Make sure volume is within range (will get errors)
						if (self.volume > 1) self.volume = 1;
						// Play out of water sound (heavy breathing)
						sound (self, CHAN_ITEM, SOUND_ARTWETS3B, self.volume, ATTN_IDLE);
					}
					self.wetsuit_sound = time + 3 + random();
				}
			}
		}
		
		// sound and screen flash when items starts to run out
		if (self.wetsuit_finished < time + 3) {
			self.wetsuit_sound = time + 4;	// Stop breathing sound
			self.wetsuit_silent = FALSE;	// Reset sound suppression
			if (self.wetsuit_time == 1) {
				sprint (self, "Air supply in Wet suit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTWETS2, 1, ATTN_NORM);
				self.wetsuit_time = time + 1;
			}
			if (self.wetsuit_time < time) {
				self.wetsuit_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.wetsuit_finished < time) ResetPowerWetSuit(self);
	}
	
	//----------------------------------------------------------------------
	// Blast Belt - Splash Damage Immunity
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.blastbelt_finished > 0) {
	// sound and screen flash when items starts to run out
		if (self.blastbelt_finished < time + 3) {
			if (self.blastbelt_time == 1) {
				sprint (self, "Blast belt is failing\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTBLASTBELT2, 1, ATTN_NORM);
				self.blastbelt_time = time + 1;
			}
			if (self.blastbelt_time < time) {
				self.blastbelt_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.blastbelt_finished < time) ResetPowerBlastbelt(self);
	}

	//----------------------------------------------------------------------
	// Jump Boots - Vertical Height Exploration
	//----------------------------------------------------------------------
	if (self.jumpboots_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.jumpboots_finished < time + 3) {
			if (self.jumpboots_time == 1) {
				sprint (self, "Jump Boots are wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTJUMPBOOTS2, 1, ATTN_NORM);
				self.jumpboots_time = time + 1;
			}	  
			if (self.jumpboots_time < time) {
				self.jumpboots_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.jumpboots_finished < time) ResetPowerJumpBoots(self);
	}
	
	//----------------------------------------------------------------------
	// SharpShooter
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.sharpshoot_finished > 0) {
	// sound and screen flash when items starts to run out
		if (self.sharpshoot_finished < time + 3) {
			if (self.sharpshoot_time == 1) {
				sprint (self, "Sharpshooter has almost gone\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSHARP2, 1, ATTN_NORM);
				self.sharpshoot_time = time + 1;
			}
			if (self.sharpshoot_time < time) {
				self.sharpshoot_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.sharpshoot_finished < time) ResetPowerSharp(self);
	}

	//----------------------------------------------------------------------
	// Nail Piercer
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.nailpiercer_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.nailpiercer_finished < time + 3) {
			if (self.nailpiercer_time == 1) {
				sprint (self, "Nail Piercer is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTNAILP2, 1, ATTN_NORM);
				self.nailpiercer_time = time + 1;
			}	  
			if (self.nailpiercer_time < time) {
				self.nailpiercer_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.nailpiercer_finished < time) ResetPowerPiercer(self);
	}	

	//------------------------------------------------------------------
	// Only remove the quad effect (status bar update)
	// if all extra mod artifacts have expired as well
	//------------------------------------------------------------------
	if (self.super_damage_finished == 0 && self.sharpshoot_finished == 0 
		&& self.nailpiercer_finished == 0)
		ResetPowerQuadItem(self);

	//------------------------------------------------------------------
	// This check for setting the client effect needs to be separate 
	// because its setup by several different artifacts!
	//------------------------------------------------------------------
	if (self.super_damage_finished > 0 || self.invincible_finished > 0 ||
		self.sharpshoot_finished > 0 || self.nailpiercer_finished > 0) {
		self.effects = self.effects | EF_DIMLIGHT;
	}
	else self.effects = self.effects - (self.effects & EF_DIMLIGHT);
};

