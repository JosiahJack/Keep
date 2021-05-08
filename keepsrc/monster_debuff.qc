// Core debuff function, run from ai_run, ai_stand, and ai_walk
void() MonsterDeBuff = {
	if (!(self.flags & FL_MONSTER)) return;

	monster_liquid_check();

	// We don't really do anything with this, but maybe someday
	if (self.aura_type >= 0) {
		if (self.aura_finished < time) ResetAuraEffects(self); // Reset aura
	}

	if (self.health < 1) { ResetDebuffSystem(self); return; }

	// Check for burning debuff (DoT)
	if (self.burning) {
		if (self.resist_fire >= 1) self.burning_qty = 0;

		// Is it time for a debuff update
		if (self.burning_time < time) {
			if (self.burning_qty > 0) {
				// Reset burning tick timer
				self.burning_time = time + 1;
				
				// Give priority to bleeding(heal) and poisoned
				if (!self.bleeding && !self.poisoned) {
					if (self.debuff_sound < time) self.debuff_sound = time + 1;
				}
				
				// Setup default burning damage
				self.debuff_qty = DEBUFF_BURN_DMG;
				// Check burning does not exceed stored damage
				if (self.burning_qty < self.debuff_qty) self.debuff_qty = self.burning_qty;
				// Subtract burning damage from counters
				self.burning_qty = self.burning_qty - self.debuff_qty;
				
				// Use global damage function (has death checks)
				T_Damage (self, world, world, self.debuff_qty*(1-self.resist_fire), NOARMOR);
			}
		}

		// 0 = not in, 1 = feet, 2 = waist, 3 = eyes
		if (self.waterlevel >= 2 || self.burning_qty < 1) ResetDebuffBurning(self);
	}

	
	// Check for poisoned debuff (DoT)
	if (self.poisoned) {
		// Is it time for a debuff update
		if (self.poisoned_time < time) {
			if (self.poisoned_qty > 0) {
				// Reset poisoned tick timer
				self.poisoned_time = time + 1;

				// Give priority to bleeding(heal)
				if (!self.bleeding) {
					if (self.debuff_sound < time) self.debuff_sound = time + 1;
				}
				
				// Setup default poison damage
				self.debuff_qty = DEBUFF_POISON_DMG;
				// Check poison does not exceed damage left
				if (self.poisoned_qty < self.debuff_qty) self.debuff_qty = self.poisoned_qty;
				// Subtract poison damage from counters
				self.poisoned_qty = self.poisoned_qty - self.debuff_qty;
				
				// Use global damage function (has death checks)
				T_Damage (self, world, world, self.debuff_qty, DAMARMOR);
			}
		}
		// Check if poison has finished?
		if (self.poisoned_qty < 1) ResetDebuffPoisoned(self);
	}

	// Check for bleeding debuff (HoT)
	if (self.bleeding) {
		// Is it time for a debuff update
		if (self.bleeding_time < time) {
			if (self.bleeding_qty > 0) {
				// Reset bleeding(healing) tick timer
				self.bleeding_time = time + 1;
				if (self.debuff_sound < time) self.debuff_sound = time + 1;

				// Setup default healing
				// Check healing does not exceed current reserve
				if (self.bleeding_qty < map_bleedingdmg_y) self.debuff_qty = self.bleeding_qty;
				else self.debuff_qty = map_bleedingdmg_y;
				// Subtract bleeding heals from counter
				self.bleeding_qty = self.bleeding_qty - self.debuff_qty;
				
				// Directly add health back
				self.health = self.health + self.debuff_qty;
				if (self.health > self.max_health) self.health = self.max_health;
			}
		}
		// Check if over max health or run out of healing
		if (self.health >= self.max_health || self.bleeding_qty < 1) ResetDebuffBleeding(self);
	}

	// Check for rotting debuff (DoT)
	if (self.rotting) {
		// Is it time for a debuff update
		if (self.rotting_time < time) {
			if (self.health > self.max_health) {
				// Reset rotting tick timer
				self.rotting_time = time + 1;
				// Directly subtract health from
				self.health = self.health - self.rotting_qty;
			}
		}
		// Reset (if over max) HP and remove inventory item
		if (self.health <= self.max_health) ResetDebuffRotting(self);
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
};