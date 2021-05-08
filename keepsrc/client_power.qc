/*======================================================================
	CheckPowerups
	- Check for turning off powerups
======================================================================*/
float PWR_FADING = 3;
float (entity targ) Zapper_Level;

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerInvRing =
{
	if (powtimer == 0) {
		targ.items = targ.items - (targ.items & IT_INVISIBILITY);
		targ.invisible_finished = targ.invisible_time = 0;
		// Reset player model
		targ.modelindex = modelindex_player;
		targ.frame = 0;
	}
	else if (targ.items & IT_INVISIBILITY) {
		// Stop powerup constantly being reset once below timer
		if (targ.invisible_finished > (time + powtimer) ) {
			targ.invisible_finished = time + powtimer;
			// Enable fading message
			targ.invisible_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerEnvSuit =
{
	if (powtimer == 0) {
		targ.items = targ.items - (targ.items & IT_SUIT);
		targ.radsuit_finished = targ.rad_time = 0;
	}
	else if (targ.items & IT_SUIT) {
		// Stop powerup constantly being reset once below timer
		if (targ.radsuit_finished > (time + powtimer) ) {
			targ.radsuit_finished = time + powtimer;
			// Enable fading message
			targ.rad_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerThermSuit =
{
	//targ.items = targ.items - (targ.items & IT_SUIT);
	targ.therm_finished = targ.therm_time = 0;
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerPent =
{
	if (powtimer == 0) {
		targ.items = targ.items - (targ.items & IT_INVULNERABILITY);
		targ.invincible_finished = targ.invincible_time = 0;
	}
	else if (targ.items & IT_INVULNERABILITY) {
		// Stop powerup constantly being reset once below timer
		if (targ.invincible_finished > (time + powtimer) ) {
			targ.invincible_finished = time + powtimer;
			// Enable fading message
			targ.invincible_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerQuad =
{
	if (powtimer == 0) {
		targ.super_damage_finished = targ.super_time = 0;
	}
	else if (targ.items & IT_QUAD) {
		// Stop powerup constantly being reset once below timer
		if (targ.super_damage_finished > (time + powtimer) ) {
			targ.super_damage_finished = time + powtimer;
			// Enable fading message
			targ.super_time = 1;
		}
	}
};

void(entity targ) ResetPowerShroom = {
	dprint("Shroom reset\n");
	targ.shroom_finished = 0;
	setsize(targ,VEC_HULL_MIN,VEC_HULL_MAX);
	sound(targ,CHAN_VOICE,"items/smb_bowserfalls.wav",1,ATTN_NORM);
	targ.velocity = '0 0 1'; // FULL STOP! (almost) Hope you weren't in the air
	targ.flags = targ.flags - FL_ONGROUND;
	targ.effects = targ.effects - EF_BRIGHTLIGHT;
	targ.legsattachment.scale = 1;
	targ.scale = 1;
	targ.view_ofs = '0 0 22';
};

// Quad screen effect is shared by several items
void(entity targ) ResetPowerQuadItem = {
	targ.items = targ.items - (targ.items & IT_QUAD);
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerSharp =
{
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTSHARP);
		targ.sharpshoot_finished = targ.sharpshoot_time = 0;
	}
	else if (targ.moditems & IT_ARTSHARP) {
		// Stop powerup constantly being reset once below timer
		if (targ.sharpshoot_finished > (time + powtimer) ) {
			targ.sharpshoot_finished = time + powtimer;
			// Enable fading message
			targ.sharpshoot_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerPiercer =
{
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTPIERCE);
		targ.nailpiercer_finished = targ.nailpiercer_time = 0;
	}
	else if (targ.moditems & IT_ARTPIERCE) {
		// Stop powerup constantly being reset once below timer
		if (targ.nailpiercer_finished > (time + powtimer) ) {
			targ.nailpiercer_finished = time + powtimer;
			// Enable fading message
			targ.nailpiercer_time = 1;
		}
	}
};

void(entity targ) ResetPowerLevitation = {
	targ.wing_finished = 0;
	targ.wing_time = 0;
	targ.gravity = fabs(targ.gravity);
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerLavaShield =
{
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTLAVASHIELD);
		targ.lavashield_finished = targ.lavashield_time = 0;
	}
	else if (targ.moditems & IT_ARTLAVASHIELD) {
		// Stop powerup constantly being reset once below timer
		if (targ.lavashield_finished > (time + powtimer) ) {
			targ.lavashield_finished = time + powtimer;
			// Enable fading message
			targ.lavashield_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerAirTank =
{
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTWETSUIT);
		targ.wetsuit_finished = targ.wetsuit_time = 0;
	}
	else if (targ.moditems & IT_ARTWETSUIT) {
		// Stop powerup constantly being reset once below timer
		if (targ.wetsuit_finished > (time + powtimer) ) {
			targ.wetsuit_finished = time + powtimer;
			// Enable fading message
			targ.wetsuit_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerBlastbelt =
{
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTBLASTBELT);
		targ.blastbelt_finished = targ.blastbelt_time = 0;
	}
	else if (targ.moditems & IT_ARTBLASTBELT) {
		// Stop powerup constantly being reset once below timer
		if (targ.blastbelt_finished > (time + powtimer) ) {
			targ.blastbelt_finished = time + powtimer;
			// Enable fading message
			targ.blastbelt_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ, float powtimer) ResetPowerJumpBoots =
{
	if (powtimer == 0) {
		targ.moditems = targ.moditems - (targ.moditems & IT_ARTJUMPBOOTS);
		targ.jumpboots_finished = targ.jumpboots_time = 0;
	}
	else if (targ.moditems & IT_ARTJUMPBOOTS) {
		// Stop powerup constantly being reset once below timer
		if (targ.jumpboots_finished > (time + powtimer) ) {
			targ.jumpboots_finished = time + powtimer;
			// Enable fading message
			targ.jumpboots_time = 1;
		}
	}
};

//----------------------------------------------------------------------
void(entity targ) ResetPowerWetSuit =
{
	targ.moditems = targ.moditems - (targ.moditems & IT_ARTWETSUIT);
	targ.wetsuit_finished = targ.wetsuit_time = 0;
};

//----------------------------------------------------------------------
void(entity targ, float powtimer, float novania) ResetPowerSystem =
{
	// This only works for player clients
	if (!(targ.flags & FL_CLIENT)) return;

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

//----------------------------------------------------------------------
void(entity targ) PlayLavaShieldSound =
{
	// Only works for the player
	if (!(targ.flags & FL_CLIENT)) return;
	
	// Can still drown from liquid damage!?!
	targ.air_finished = time + WATER_AIR;
	// Time for another sound reminder?
	if (targ.lavashield_sound < time) {
		if (targ.lavashield_volume > 0) {
			targ.volume = (0.5 + random() * 0.5) * targ.lavashield_volume;
			// Make sure volume is within range (will get errors)
			if (targ.volume > 1) targ.volume = 1;
			sound (targ, CHAN_ITEM, SOUND_ARTLSHIELD3, targ.volume, ATTN_NORM);
		}
		targ.lavashield_sound = time + 2;
	}
};

//----------------------------------------------------------------------
void(entity targ) PlayBlastBeltSound =
{
	// Only works for the player
	if (!(targ.flags & FL_CLIENT)) return;
	
	// Time for another sound reminder?
	if (targ.blastbelt_sound < time) {
		if (targ.blastbelt_volume > 0) {
			targ.volume = (0.5 + random() * 0.5) * targ.blastbelt_volume;
			// Make sure volume is within range (will get errors)
			if (targ.volume > 1) targ.volume = 1;
			sound (targ, CHAN_ITEM, SOUND_ARTBLASTBELT3, targ.volume, ATTN_NORM);
		}
		targ.blastbelt_sound = time + 2;
	}
};

//----------------------------------------------------------------------
void(entity targ) PlayPentagramSound =
{
	// Only works for the player
	if (!(targ.flags & FL_CLIENT)) return;
	
	// Time for another sound reminder?
	if (targ.invincible_sound < time) {
		sound (targ, CHAN_ITEM, SOUND_ARTPENT3, 1, ATTN_NORM);
		targ.invincible_sound = time + 2;
	}
};

//============================================================================
void() ClientPowerups =
{
	// Exceptions: Dead, intermission or cinematic cameras
	if (intermission_running > 0) return;
	if (self.health < 1) return;
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

		if (self.invisible_finished < time + PWR_FADING) {
			if (self.invisible_time == 1) {
				sprint (self, "Ring of Shadows magic is fading\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTINV2, 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time) {
				self.invisible_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.invisible_finished < time) {
			ResetPowerInvRing(self,0);
		} else {
			// keep using the eyes
			self.modelindex = modelindex_eyes;
			self.frame = 0;
		}
	} else {
		if (mindex_hammer && self.weapon == IT2_MJOLNIR) {
            //if (self.hammer_finished)
            //    self.modelindex = mindex_hamout;
            //else
                self.modelindex = mindex_hammer;
        }
        else if (mindex_saw && self.weapon == IT_AXE && self.perms & IT_CHAINSAW)
            self.modelindex = mindex_saw;
        else
            self.modelindex = modelindex_player;
	}

	//----------------------------------------------------------------------
	// Env Suit	
	// - Flash screen 3s before running out
	// - Give player standard 12s of air after suit finishes
	//----------------------------------------------------------------------
	if (self.radsuit_finished > 0) {
		self.air_finished = time + WATER_AIR;		// don't drown


	// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3) {
			if (self.rad_time == 1) {
				sprint (self, "Air supply in Biosuit expiring\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSUIT2, 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			if (self.rad_time < time) {
				self.rad_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.radsuit_finished < time) ResetPowerEnvSuit(self,0);
	}
	//----------------------------------------------------------------------
	// Thermal Protection Suit	
	// - Flash screen 3s before running out
	// - Give player standard 12s of air after suit finishes
	//----------------------------------------------------------------------
	if (self.therm_finished > 0) {
		self.air_finished = time + WATER_AIR;		// don't drown

	// sound and screen flash when items starts to run out
		if (self.therm_finished < time + 3) {
			if (self.therm_time == 1) {
				sprint (self, "Thermal protection suit is expiring\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSUIT2, 1, ATTN_NORM);
				self.therm_time = time + 1;
			}
			if (self.therm_time < time) {
				self.therm_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.therm_finished < time) ResetPowerThermSuit(self);
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
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTLSHIELD2, 1, ATTN_NORM);
				self.lavashield_time = time + 1;
			}
			if (self.lavashield_time < time) {
				self.lavashield_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.lavashield_finished < time) ResetPowerLavaShield(self,0);
	}

	//----------------------------------------------------------------------
	// Wet Suit	
	// - Flash screen 3s before running out
	// - Give player 12s of air after suit finishes
	//----------------------------------------------------------------------
	if (self.wetsuit_finished > 0) {
		self.air_finished = time + WATER_AIR;		// don't drown

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
		if (self.wetsuit_sound < time) {
			if (self.waterlevel == 3) {
				// Under water sound with bubbbles
				self.volume = 0.5 + random() * 0.5;
				sound (self, CHAN_ITEM, SOUND_ARTWETS3, self.volume, ATTN_IDLE);
				self.wetsuit_sound = time + 4;
			}
			else {
				// Different sound when not in the water (faster)
				self.volume = 0.4 + random() * 0.4;
				sound (self, CHAN_ITEM, SOUND_ARTWETS3B, self.volume, ATTN_IDLE);
				self.wetsuit_sound = time + 3 + random();
			}
		}
		
		// sound and screen flash when items starts to run out
		if (self.wetsuit_finished < time + 3) {
			self.wetsuit_sound = time + 4;	// Stop breathing sound
			if (self.wetsuit_time == 1) {
				sprint (self, "Air supply in Wet suit expiring\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTWETS2, 1, ATTN_NORM);
				self.wetsuit_time = time + 1;
			}
			if (self.wetsuit_time < time) {
				self.wetsuit_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.wetsuit_finished < time) ResetPowerWetSuit(self);
	}


	
	//----------------------------------------------------------------------
	// Invincibility (Pentagram)
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.invincible_finished > 0) {
	// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3) {
			if (self.invincible_time == 1) {
				sprint (self, "Protection is almost burned out\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTPENT2, 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			if (self.invincible_time < time) {
				self.invincible_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.invincible_finished < time) ResetPowerPent(self,0);
	}

	//----------------------------------------------------------------------
	// Super Damage (Quad)
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.super_damage_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.super_damage_finished < time + 3) {
			if (self.super_time == 1) {
				sprint (self, "Quad Damage is wearing off\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTQUAD2, 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			if (self.super_time < time) {
				self.super_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.super_damage_finished < time) ResetPowerQuad(self,0);
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
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTBLASTBELT2, 1, ATTN_NORM);
				self.blastbelt_time = time + 1;
			}
			if (self.blastbelt_time < time) {
				self.blastbelt_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.blastbelt_finished < time) ResetPowerBlastbelt(self,0);
	}

	//----------------------------------------------------------------------
	// Jump Boots - Vertical Height Exploration
	//----------------------------------------------------------------------
	if (self.jumpboots_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.jumpboots_finished < time + 3) {
			if (self.jumpboots_time == 1) {
				sprint (self, "Jump Boots are wearing off\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTJUMPBOOTS2, 1, ATTN_NORM);
				self.jumpboots_time = time + 1;
			}	  
			if (self.jumpboots_time < time) {
				self.jumpboots_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.jumpboots_finished < time) ResetPowerJumpBoots(self,0);
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
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTSHARP2, 1, ATTN_NORM);
				self.sharpshoot_time = time + 1;
			}
			if (self.sharpshoot_time < time) {
				self.sharpshoot_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}	
		// Update inventory and timers
		if (self.sharpshoot_finished < time) ResetPowerSharp(self,0);
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
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, SOUND_ARTNAILP2, 1, ATTN_NORM);
				self.nailpiercer_time = time + 1;
			}	  
			if (self.nailpiercer_time < time) {
				self.nailpiercer_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.nailpiercer_finished < time) ResetPowerPiercer(self,0);
	}

	//----------------------------------------------------------------------
	// Boots of Levitation
	// - Flash screen 3s before running out
	//----------------------------------------------------------------------
	if (self.wing_finished > 0) {
		// sound and screen flash when items starts to run out
		if (self.wing_finished < time + 3) {
			if (self.wing_time == 1) {
				sprint (self, "Boots of Levitation are fading\n");
				Safe_stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "ambience/wingend.wav", 1, ATTN_NORM);
				self.wing_time = time + 1;
			}	  
			if (self.wing_time < time) {
				self.wing_time = time + 1;
				Safe_stuffcmd (self, "bf\n");
			}
		}
		// Update inventory and timers
		if (self.wing_finished < time) ResetPowerLevitation(self);
	}	

	if (self.tome_finished < time) {
		self.tome_finished = 0;
	}

	if (self.shroom_finished < time) {
		if (self.shroom_finished > 0) ResetPowerShroom(self);
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

	if (self.items2 & IT2_CROSS && self.weapon == IT2_CROSS) self.currentammo = Zapper_Level(self);
};

