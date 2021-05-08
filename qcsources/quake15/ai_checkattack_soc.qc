/*======================================================================
 DFuryCheckAttack
======================================================================*/
void() DFuryCheckAttack =
{
	// Does the monster have a clear shot to the player?
	// sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
		
	//----------------------------------------------------------------------
	// Melee attack
	// enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	//----------------------------------------------------------------------
	if (ai_checkmelee(MONAI_MELEEFRONT)) {
		self.attack_state = AS_MELEE;
		self.th_melee (); 
		return;
	}
	//----------------------------------------------------------------------
	// If setup to be a turret, check range attack only
	//----------------------------------------------------------------------
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		// If the sightline between self and player blocked by anything, keep moving
		if (!visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) return;
		self.attack_state = AS_MISSILE;
		return;
	}
	//----------------------------------------------------------------------
	// is the enemy close enough for a double sword slice attack?
	//----------------------------------------------------------------------
	if (self.enemydist < MONAI_JUMPFURYNEAR) {
		self.attack_state = AS_MELEE;
		self.th_slide (); 
		return;
	}
	//----------------------------------------------------------------------
	// Mid Range attack (JUMP)
	//----------------------------------------------------------------------
	// Jumped recently, facing right direction and not blocked?
	if ( self.jump_flag < time && infront(self.enemy) && !visblocked(self.enemy) ) {
		// Check for enemy above? (z axis)
		if (self.enemy.origin_z <= self.origin_z) {
			// Is the fury knight within the right range?
			if (self.enemydist > MONAI_JUMPFURYNEAR &&
				self.enemydist < MONAI_JUMPFURYFAR) {
				// Block any range attacks for a while
				SUB_AttackFinished (random());
				self.jumptouch = world;		// Reset last object touched
				self.count = 0;				// Number of times jumped
				if (random() < 0.65) self.th_jump ();
				else self.th_charge ();
				return;
			}
		}
	}
	//----------------------------------------------------------------------
	// Range attack
	// The attack chance percentages are constant across skill levels
	//----------------------------------------------------------------------
	if (time < self.attack_finished) return;
	// If the sightline between self and player blocked by anything, keep moving
	if (!visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) return;
	
	if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
	else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.4;	// range < 500 map units
	else if (enemy_range == RANGE_MID) self.attack_chance = 0.05;	// range < 1000 map units
	else self.attack_chance = 0;
	if (random () < self.attack_chance) self.attack_state = AS_MISSILE;
};