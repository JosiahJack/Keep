//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Implements: Monster Debuff System for applying monster affects over time.
//
// Description:
// This applies the various affects that occur over time to monsters such as
// burning and poison.
//
// This was also a handy place to locate liquid checks for drowning.
//=============================================================================

// Core debuff function, run from ai_run, ai_stand, and ai_walk
void() MonsterDeBuff = { // [FUNCTION]
	if (!(self.flags & FL_MONSTER)) return;

	if (self.health < 1 && (self.burning || self.poisoned || self.bleeding || self.rotting)) { ResetDebuffSystem(self); return; }

	if (self.aura_type >= 0 && self.aura_finished < time) ResetAuraEffects(self); // Reset aura.  We don't really do anything with this, but maybe someday
	monster_liquid_check();
    Divine_Check(); // Divine attack!

	// Check for burning debuff (DoT)
	if (self.burning) {
		if (self.resist_fire >= 1) self.burning_qty = 0;

		// Is it time for a debuff update
		if (self.burning_time < time) {
			if (self.burning_qty > 0) {
				self.burning_time = time + 1; // Reset burning tick timer
				
				// Give priority to bleeding(heal) and poisoned
				if (!self.bleeding && !self.poisoned) {
					if (self.debuff_sound < time) self.debuff_sound = time + 1;
				}
				self.debuff_qty = DEBUFF_BURN_DMG; // Setup default burning damage
				if (self.burning_qty < self.debuff_qty) self.debuff_qty = self.burning_qty; // Check burning does not exceed stored damage
				self.burning_qty = self.burning_qty - self.debuff_qty; // Subtract burning damage from counters
				T_Damage(self, world, world, self.debuff_qty*(1-self.resist_fire), NOARMOR); // Use global damage function (has death checks)
			}
		}
		if (self.waterlevel >= 2 || self.burning_qty < 1) ResetDebuffBurning(self); // 0 = not in, 1 = feet, 2 = waist, 3 = eyes
	}

	// Check for poisoned debuff (DoT)
	if (self.poisoned) {
		if (self.poisoned_time < time) { // Is it time for a debuff update
			if (self.poisoned_qty > 0) {
				self.poisoned_time = time + 1; // Reset poisoned tick timer
				if (!self.bleeding && self.debuff_sound < time) self.debuff_sound = time + 1; // Give priority to bleeding(heal)
				self.debuff_qty = DEBUFF_POISON_DMG; // Setup default poison damage
				if (self.poisoned_qty < self.debuff_qty) self.debuff_qty = self.poisoned_qty; // Check poison does not exceed damage left
				self.poisoned_qty = self.poisoned_qty - self.debuff_qty; // Subtract poison damage from counters
				T_Damage(self, world, world, self.debuff_qty, DAMARMOR); // Use global damage function (has death checks)
			}
		}
		if (self.poisoned_qty < 1) ResetDebuffPoisoned(self); // Check if poison has finished?
	}

	// Check for bleeding debuff (HoT)
	if (self.bleeding) {
		if (self.bleeding_time < time) { // Is it time for a debuff update
			if (self.bleeding_qty > 0) {
				self.bleeding_time = time + 1; // Reset bleeding(healing) tick timer
				if (self.debuff_sound < time) self.debuff_sound = time + 1;
				if (self.bleeding_qty < map_bleedingdmg_y) self.debuff_qty = self.bleeding_qty; // Setup default healing.  Check healing does not exceed current reserve
				else self.debuff_qty = map_bleedingdmg_y; // Subtract bleeding heals from counter
				
				self.bleeding_qty = self.bleeding_qty - self.debuff_qty;
				self.health = self.health + self.debuff_qty; // Directly add health back
				if (self.health > self.max_health) self.health = self.max_health;
			}
		}
		if (self.health >= self.max_health || self.bleeding_qty < 1) ResetDebuffBleeding(self); // Check if over max health or run out of healing
	}

	// Check for rotting debuff (DoT)
	if (self.rotting) {
		if (self.rotting_time < time) { // Is it time for a debuff update
			if (self.health > self.max_health) {
				self.rotting_time = time + 1; // Reset rotting tick timer
				self.health = self.health - self.rotting_qty; // Directly subtract health from
			}
		}
		if (self.health <= self.max_health) ResetDebuffRotting(self); // Reset (if over max) HP and remove inventory item
	}

	// Check for regeneration powerups (HoT).  Berserker and amulet of regeneration do not stack, only 1 healing amount
	if (self.perms & POW_REGEN || self.perms & POW_ARMORBERSERKER || self.perms & POW_REGENLESSER) {
		// Is it time for a debuff update
		if (self.regen_time < time) {
			if (self.health < self.max_health) {
				// Reset rotting tick timer
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

	if (self.perms & POW_ARMORSPIRIT) {
		if (self.repairtime < time) {
			self.repairtime = time + 1;
			if (self.armorvalue < 100) T_Repair(self,1,TRUE); // recharge armor
		}
	}

	// Holy Freeze
    if (self.slow_finished) {
        self.velocity = self.velocity * 0.6;
        if (self.slow_ping < time && self.invisible_finished < time && !(self.flags & FL_NOTARGET)) Particle_Cube (self, 1, 41); // Gray and blue for slow mist.
        if (self.slow_finished < time) self.slow_finished = self.slow_time = self.slow_ping = 0; // Just stopped.
    }
};