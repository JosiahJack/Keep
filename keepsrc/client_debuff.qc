//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: My own and Arcane Dimensions (AD)
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
// Function count: 13
//
// Implements: Player Buff System
//
// Description:
// Functions for applying, removing, and updating effects for various buffs
// such as burning and poison.  Also used to apply shrine aura effects.
//=============================================================================

.float		cshift_func;		// 1=Screen flash, 3=artifacts, 5=debuff
.float		cshift_upd;			// Screen updates (v_cshift) are active
.float		cshift_time;		// Timer (0.1s tick) for screen updates
.vector		cshift_col;			// RGB / XYZ values for screen colour
.float		cshift_den;			// Screen colour density
.float		cshift_step;		// Quantity to reduce density by per tick
.float		debuff_sound;		// Heartbeat sound when tick happens
.float		debuff_qty;			// Quantity to do something with (temp)
.float		bleeding;			// Bleeding debuff status
.float		bleeding_time;		// Timer (1s tick) for screen/sound update
.float		bleeding_qty;		// Total amount of health stored (HoT)
.float		rotting;			// Rotting debuff status (DoT)
.float		rotting_time;		// Timer (1s tick) for health update
.float		regen_time; 
.float		burning;			// Burning debuff status
.float		burning_time;		// Timer (1s tick) for screen/sound update
.float		burning_qty;		// Total amount of damage stored (DoT)
.float		poisoned;			// Poison debuff status
.float		poisoned_time;		// Timer (1s tick) for screen/sound update
.float		poisoned_qty;		// Total amount of damage stored (DoT)

// Wraith Health drain
vector DEBUFF_BLEED_COL = '50 35 0';		// Dark Orange
float DEBUFF_BLEED_DEN = 80;
float DEBUFF_BLEED_STEP = 10;

// Bleed debuff
vector DEBUFF_START_BLEED_COL = '200 0 0';	// Strong red
float DEBUFF_START_BLEED_DEN = 160;
float DEBUFF_START_BLEED_STEP = 7;
float DEBUFF_BLEED_MIN = 5;				// Minimum health to apply debuff
float DEBUFF_BLEED_DMG = 10;			// Immunity with pent/envsuit

// Pyro flame burn
vector DEBUFF_BURN_COL = '200 100 0';	// Orange
float DEBUFF_BURN_DEN = 120;
float DEBUFF_BURN_STEP = 10;
float DEBUFF_BURN_DMG = 1;				// Damage Over Time
float DEBUFF_BURN_MAX = 10;				// Max amount of burning multiplier

// Mummy poisoned gibs
vector DEBUFF_POISON_COL = '0 200 0';	// Strong Green
float DEBUFF_POISON_DEN = 80;
float DEBUFF_POISON_STEP = 7;
float DEBUFF_POISON_DMG = 1;			// Damage Over Time
float DEBUFF_POISON_DMGMON = 15;		// Damage Over Time For Monsters, higher to be more effective

void(entity targ) ResetAuraEffects;

void(entity targ) ResetCShift = { Safe_stuffcmd(targ, "v_cshift 0 0 0 0\n"); };

// Various debuff reset functions, used all over the place
void(entity targ) ResetDebuffScreen = {
	if (targ.flags & FL_CLIENT) {
		targ.cshift_upd = FALSE;
		targ.cshift_time = LARGE_TIMER;
		Safe_stuffcmd(targ, "v_cshift 0 0 0 0\n");
		targ.cshift_col = '0 0 0';
		targ.cshift_den = 0;
	}
};

void(entity targ) ResetDebuffBurning = { targ.burning = targ.burning_qty = 0; };

void(entity targ) ResetDebuffRotting = {
	targ.rotting = 0; 
	// Force reset health and remove MH inventory item
	if (targ.health > targ.max_health) targ.health = targ.max_health;
	targ.items2 = targ.items2 - (targ.items2 & IT2_SUPERHEALTH);
};

void(entity targ) ResetDebuffPoisoned = { targ.poisoned = targ.poisoned_qty = 0; };

void(entity targ) ResetDebuffBleeding = { targ.bleeding = targ.bleeding_qty = 0; };

void(entity targ) ResetDebuffSystem = {
	// This only works for player clients
	if (!(targ.flags & FLx_CREATURE)) return;
	
	ResetDebuffScreen(targ);
	ResetDebuffBurning(targ);
	ResetDebuffPoisoned(targ);
	ResetDebuffBleeding(targ);
};

// Core debuff function, run every frame from client.qc
void() ClientDeBuff = {
	local vector spot;
	local entity flashlightSpot;

	// Check is self is a NOT player (client) FIRST!
	// Bug fix from ericw on func msgboard
	// #655 posted by ericw on 2018/04/10 09:53:36
	if (!(self.flags & FL_CLIENT)) return;

	if (self.aura_type >= 0) {
		if (self.aura_finished < time) ResetAuraEffects(self); // Reset aura
	}

	// If player is dead or intermission running, turn everything off
	// Cinematic camera system exception is later on in code
	if (intermission_running > 0 || self.health < 1) {
		ResetDebuffSystem(self);
		return;
	}

	if (self.flashlight) {
		if (!self.attachment3) {
			flashlightSpot = spawn();
			flashlightSpot.effects = EF_BRIGHTLIGHT;
			setsize(flashlightSpot,VEC_ORIGIN,VEC_ORIGIN);
			self.attachment3 = flashlightSpot;
		}
		makevectors(self.v_angle);
		spot = self.origin+self.view_ofs;
		traceline(spot,spot + v_forward * 1024,FALSE,self);
		setorigin(self.attachment3,trace_endpos);
	} else {
		if (self.attachment3) {
			self.attachment3.effects = 0;
			self.attachment3.think = SUB_Remove;
			self.attachment3.nextthink = time + 0.1;
			self.attachment3 = world;
		}
	}

	// Check for burning debuff (DoT)
	if (self.burning) {
		if (self.aura_finished > time && self.aura_type == 1) self.burning_qty = 0;

		// Is it time for a debuff update
		if (self.burning_time < time) {
			if (self.burning_qty > 0) {
				// Reset burning tick timer
				self.burning_time = time + 1;
				
				// Give priority to bleeding(heal) and poisoned
				if (!self.bleeding && !self.poisoned) {
					if (self.debuff_sound < time) self.debuff_sound = time + 1;
					self.cshift_upd = TRUE;		// Update screen colour
					self.cshift_time = -1;		// Update striaght away
					self.cshift_col = DEBUFF_BURN_COL;
					self.cshift_den = DEBUFF_BURN_DEN;
					self.cshift_step = DEBUFF_BURN_STEP;
				}
				
				// Setup default burning damage
				self.debuff_qty = DEBUFF_BURN_DMG;
				// Check burning does not exceed stored damage
				if (self.burning_qty < self.debuff_qty) self.debuff_qty = self.burning_qty;
				// Subtract burning damage from counters
				self.burning_qty = self.burning_qty - self.debuff_qty;
				
				if (self.resist_fire > 0) self.burning_qty = self.burning_qty * (1-self.resist_fire);
				// Use global damage function (has death checks)
				T_Damage (self, world, world, self.debuff_qty, NOARMOR);
			}
		}
		// Check if player is in water up to waist?
		// 0 = not in, 1 = feet, 2 = waist, 3 = eyes
		if (self.waterlevel >= 2 || self.burning_qty < 1) {
			ResetDebuffBurning(self);
		}
	}
	
	// Check for poisoned debuff (DoT)
	if (self.poisoned) {
		if (self.aura_finished > time && self.aura_type == 0) self.poisoned_qty = 0;

		// Is it time for a debuff update
		if (self.poisoned_time < time) {
			if (self.poisoned_qty > 0) {
				self.poisoned_time = time + 1; // Reset poisoned tick timer

				// Give priority to bleeding(heal)
				if (!self.bleeding) {
					if (self.debuff_sound < time) self.debuff_sound = time + 1;
					self.cshift_upd = TRUE;		// Update screen colour
					self.cshift_time = -1;		// Update striaght away
					self.cshift_col = DEBUFF_POISON_COL;
					self.cshift_den = DEBUFF_POISON_DEN;
					self.cshift_step = DEBUFF_POISON_STEP;
				}

				self.debuff_qty = DEBUFF_POISON_DMG; // Setup default poison damage
				if (self.poisoned_qty < self.debuff_qty) self.debuff_qty = self.poisoned_qty; // Check poison does not exceed damage left
				self.poisoned_qty = self.poisoned_qty - self.debuff_qty; // Subtract poison damage from counters
				T_Damage (self, world, world, self.debuff_qty, NOARMOR); // Use global damage function (has death checks)
			}
		}
		// Check if poison has finished?
		if (self.poisoned_qty < 1) ResetDebuffPoisoned(self);
	}

	// Check for bleeding debuff (HoT)
	if (self.bleeding) {
		if (self.aura_finished > time && self.aura_type == 4) self.bleeding_qty = 0;

		// Is it time for a debuff update
		if (self.bleeding_time < time) {
			if (self.bleeding_qty > 0) {
				// Reset bleeding(healing) tick timer
				self.bleeding_time = time + 1;
				if (self.debuff_sound < time) self.debuff_sound = time + 1;
				self.cshift_upd = TRUE;		// Update screen colour
				self.cshift_time = -1;		// Update striaght away
				self.cshift_col = DEBUFF_BLEED_COL;
				self.cshift_den = DEBUFF_BLEED_DEN;
				self.cshift_step = DEBUFF_BLEED_STEP;

				// Setup default healing
				// Check healing does not exceed current reserve
				if (self.bleeding_qty < map_bleedingdmg_y) self.debuff_qty = self.bleeding_qty;
				else self.debuff_qty = map_bleedingdmg_y;
				// Subtract bleeding heals from counter
				self.bleeding_qty = self.bleeding_qty - self.debuff_qty;
				
				// Directly add health back to player
				self.health = self.health + self.debuff_qty;
				if (self.health > self.max_health) self.health = self.max_health;
			}
		}
		// Check if player is over max health or run out of healing
		if (self.health >= self.max_health || self.bleeding_qty < 1) {
			ResetDebuffBleeding(self);
		}
	}

	// Check for rotting debuff (DoT)
	if (self.rotting) {
		if (self.aura_finished < time && self.aura_type != 4) {
			// Is it time for a debuff update
			if (self.rotting_time < time) {
				if (self.health > self.max_health) {
					// Reset rotting tick timer
					self.rotting_time = time + 1;

					if (self.curse_finished > time && self.curse_type == CURSE_WEAKEN) {
						self.health = self.health - self.rotting_qty - self.curse_ping;
					} else {
						// Directly subject health from player
						self.health = self.health - self.rotting_qty;
					}
				}
			}
			// Reset (if over max) HP and remove inventory item
			if (self.health <= self.max_health) ResetDebuffRotting(self);
		} else {
			ResetDebuffRotting(self);
		}
	}

	// Check for regeneration powerups (HoT).  Berserker and amulet of regeneration do not stack, only 1 healing amount
	if (self.perms & POW_REGEN || self.perms & POW_ARMORBERSERKER || self.perms & POW_REGENLESSER) {
		ResetDebuffRotting(self);

		// Is it time for a debuff update
		if (self.regen_time < time) {
			if (self.health < self.max_health) {
				if (self.perms & POW_REGENLESSER && !(self.perms & POW_REGEN) || (self.perms & POW_ARMORBERSERKER))
					self.regen_time = time + 3;
				else
					self.regen_time = time + 1;

				if (self.rotting_qty < 1) self.rotting_qty = 1; // Guarantee at least 1 health increase
				self.health = self.health + self.rotting_qty;
				if (self.health > self.max_health) self.health = self.max_health;
			}
		}
	}

	if (self.perms & POW_ARMORSPIRIT && (self.items2 & IT2_ARMOR1 || self.items2 & IT2_ARMOR2 || self.items2 & IT2_ARMOR3)) {
		if (self.repairtime < time) {
			self.repairtime = time + 1;
			if (self.armorvalue < 100) T_Repair(self,1,FALSE); // recharge armor
		}
	}

	// Holy Freeze
    if (self.slow_finished) {
        self.velocity = self.velocity * 0.8; // Less damping for players
        if (self.slow_ping < time)
            if (self.invisible_finished < time && !(self.flags & FL_NOTARGET)) Particle_Cube (self, 1, 41); // Gray and blue for slow mist.
        if (self.slow_finished < time) { // just stopped
            self.slow_finished = self.slow_time = self.slow_ping = 0;
        }
    }
	
	// Don't need sound or visual updates for cinematic stuff
	if (cinematic_running || cutscene) return;
	
	// Check for any debuff screen updates?
	if (self.cshift_upd) {
		// Play different debuff sounds (pressure is on!)
		if (self.debuff_sound > time) {
			self.debuff_sound = -1;		// Reset

			// Sound exception for god/pentagram mode
			if (self.flags & FL_GODMODE || self.invincible_finished >= time) {
				PlayPentagramSound(self);
			}
			else {
				// Play heartbeat only for bleeding/healing
				if (self.bleeding) 
					sound (self, CHAN_VOICE, SOUND_HEARTBEAT, 1, ATTN_IDLE);
				// Re-use player pain sounds
				else if (self.poisoned) {
					if (random() < 0.5) sound (self, CHAN_VOICE, "player/pain2.wav", 1, ATTN_IDLE);
					else sound (self, CHAN_VOICE, "player/pain3.wav", 1, ATTN_IDLE);
				}
				// Play on the same channel as player pain
				else if (self.burning) {
					if (random() < 0.5) sound (self, CHAN_VOICE, "player/pain1.wav", 1, ATTN_IDLE);
					else sound (self, CHAN_VOICE, "player/pain4.wav", 1, ATTN_IDLE);
				}
			}
		}
		// Check for screen update? 0.1s tick interval
		if (self.cshift_time < time) {
			// Generate some particles based on debuff
			// Priority is bleeding > poisoned > burning
			if (self.bleeding) particle_debuff(self.origin, 16, rint(1+random()*4), PARTICLE_BURST_RED);
			else if (self.poisoned) particle_debuff(self.origin, 16, rint(1+random()*4), PARTICLE_BURST_GREEN);
			else if (self.burning) particle_debuff(self.origin, 16, rint(1+random()*4), PARTICLE_BURST_YELLOW);

			// Count down density and check for reset condition
			self.cshift_den = self.cshift_den - self.cshift_step;
			if (self.cshift_den < 1) ResetDebuffScreen(self);
			else {
				// Update screen using stuffcmds!
				self.cshift_time = time + 0.1;

				// Don't update the screen if an artifact is active
				// The engine will be updating at the same time
				if ((self.items & ALL_ITEMSARTIFACTS == 0) && (self.items2 & ALL_ITEMS2ARTIFACTS == 0) && (self.moditems & ALL_MODITEMSARTIFACTS == 0)) {
					Safe_stuffcmd(self, "v_cshift ");
					Safe_stuffcmd(self, ftos(rint(self.cshift_col_x)));
					Safe_stuffcmd(self, " ");
					Safe_stuffcmd(self, ftos(rint(self.cshift_col_y)));
					Safe_stuffcmd(self, " ");
					Safe_stuffcmd(self, ftos(rint(self.cshift_col_z)));
					Safe_stuffcmd(self, " ");
					Safe_stuffcmd(self, ftos(rint(self.cshift_den)));
					Safe_stuffcmd(self, "\n");
				}
			}
		}
	}
	// Reset cshift if nothing is active (engine does not reset).  This is to catch new games or quickload resets
	else if (self.cshift_time < time) ResetDebuffScreen(self);
};

void(entity targ) BleedDeBuff = {
	local float pain_type;
	
	if (!(targ.flags & FL_CLIENT)) return; // Sanity check!
	if (targ.health <= DEBUFF_BLEED_MIN) return; // Check for bleeding and minimum amount of health for debuff
	if (targ.bleeding == TRUE) { T_Damage (targ, self, self, DEBUFF_BLEED_MIN, DAMARMOR); return; } // Do minimum damage, checked min does not kill before
	if (targ.items & (IT_INVULNERABILITY | IT_SUIT) || targ.flags & FL_GODMODE) { T_Damage (targ, self, self, DEBUFF_BLEED_DMG, DAMARMOR); return; } // Immune to debuff if using Pent of Protection or BioSuit

	targ.bleeding = TRUE; // Starting bleeding!
	targ.bleeding_time = time + map_bleedingdmg_z; // Pause before bleeding Healing starts (def=1s)

	// Pick a random player sound
	pain_type = rint(random() * 3);
	if (pain_type < 1) sound (targ, CHAN_VOICE, "player/pain4.wav", 1, ATTN_NORM);
	else if (pain_type < 2) sound (targ, CHAN_VOICE, "player/pain5.wav", 1, ATTN_NORM);
	else sound (targ, CHAN_VOICE, "player/pain6.wav", 1, ATTN_NORM);

	// Work out maximum bleed HP (remove MH excess)
	targ.bleeding_qty = targ.health;
	if (targ.bleeding_qty > targ.max_health) targ.bleeding_qty = targ.max_health;
	// Reduce HP down to % (def=0.25) and restore the rest later on
	targ.health = rint(targ.bleeding_qty * map_bleedingdmg_x);
	targ.bleeding_qty = targ.bleeding_qty - targ.health;
	targ.cshift_upd = TRUE;		// Update screen colour
	targ.cshift_time = -1;		// Update striaght away
	targ.cshift_col = DEBUFF_START_BLEED_COL;
	targ.cshift_den = DEBUFF_START_BLEED_DEN;
	targ.cshift_step = DEBUFF_START_BLEED_STEP;
};

void(entity targ, float rotoverride) RotDeBuff = {
	if (targ.flags & FL_CLIENT == FALSE) return; // Only need to check for player/client

	targ.rotting = TRUE; // Extra Health is added via item pickup
	
	// Check for a rotting override value
	if (rotoverride <= 1) targ.rotting_qty = 1;
	else targ.rotting_qty = rotoverride;
	
	targ.items2 = targ.items2 | IT2_SUPERHEALTH; // Always give inventory item
	targ.rotting_time = time + 5; // 5s second pause to start of HP rot
};

void(entity targ) BurnDeBuff = {
	local float debuffqty;
	
	// Do not stack burning time beyond a certain limit
	// Cannot be burning if knee deep in water
	// Immune to debuff if using Pent of Protection or BioSuit
	if (targ.burning_qty > DEBUFF_BURN_MAX) return;
	if (targ.flags & FLx_CREATURE == FALSE) return; // Affects players and monsters
	if (targ.waterlevel >= 3) return;
	if (targ.items & (IT_INVULNERABILITY | IT_SUIT)) return;
	
	// if debuff not active, starting burning!
	if (!targ.burning) {
		targ.burning = TRUE;
		targ.burning_time = -1;
	}
		
	// work out time remaining on debuff
	debuffqty = rint(5*skill + 3 + 2*random());
	targ.burning_qty = targ.burning_qty + debuffqty;
	if (targ.burning_qty > DEBUFF_BURN_MAX) targ.burning_qty = DEBUFF_BURN_MAX;

	if (targ.flags & FL_CLIENT) {
		targ.cshift_upd = TRUE;		// Update screen colour
		targ.cshift_time = -1;		// Update striaght away
		targ.cshift_col = DEBUFF_BURN_COL;
		targ.cshift_den = DEBUFF_BURN_DEN;
		targ.cshift_step = DEBUFF_BURN_STEP;
	}
};

void(entity targ) PoisonDeBuff = {
	local float debuffqty;
	
	// Immune to debuff if using Pent of Protection or BioSuit
	if (targ.flags & FLx_CREATURE == FALSE) return; // Affects players and monsters 
	if (targ.items & (IT_INVULNERABILITY | IT_SUIT)) return;
	if (targ.poisoned) return;	// Only poison once
	
	// work out time remaining on debuff
	// poison time Easy=3+2 Normal=4+2, Hard=5+2, NM=6+2, Evil=7+2
	debuffqty = floor(skill + 3 + 2*random());
	// Air tanks help reduce poison debuff duration
	if (targ.moditems & IT_ARTWETSUIT) debuffqty = floor(debuffqty * 0.5);

	// Is there any poison debuff time left?
	if (debuffqty > 0) {
		targ.poisoned = TRUE;
		targ.poisoned_time = -1;
		targ.poisoned_qty = debuffqty;
		if (targ.flags & FL_CLIENT) {
			targ.cshift_upd = TRUE;		// Update screen colour
			targ.cshift_time = -1;		// Update striaght away
			targ.cshift_col = DEBUFF_POISON_COL;
			targ.cshift_den = DEBUFF_POISON_DEN;
			targ.cshift_step = DEBUFF_POISON_STEP;
		}
	}
};

// Used by Pyro and Wraith; consistent damage from both monsters
void(entity targ, float playdmg, float mondmg) ApplyFireDmg = {
	local float reduction, firedamage;

	if (targ.flags & FL_CLIENT) {
		// Can't burn players with lava shield or thermal protection suit
		if (targ.moditems & IT_ARTLAVASHIELD || targ.therm_finished > 0) return;
	}

	// Bio suit reduction - easy=80%, normal=70%, hard=60%, nm=50%
	reduction = 0.2 + skill * 0.1;

	// Damage is different for monsters/players
	if (targ.flags & FL_MONSTER) firedamage = mondmg;
	else if (targ.items & IT_SUIT) firedamage = rint(playdmg * reduction);
	else firedamage = playdmg;

	if (targ.resist_fire > 0) firedamage = firedamage * (1-targ.resist_fire);

	T_Damage (targ, self, self.owner, firedamage, NOARMOR); // Final damage (no armour save, fire burns through)
	if (targ.resist_fire < 1) BurnDeBuff(targ);
};