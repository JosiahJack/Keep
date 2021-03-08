void(float scratch_noise) ai_melee_carnivean = {
	local vector	delta;
	local float 	ldmg, richtung;

	if (!self.enemy) return;		// removed before stroke

	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100) return;
		
	ldmg = (random() + random() + random()) * 4;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
	
	makevectors (self.angles);
	particle (self.origin + v_forward*50 + v_up*2, '0 0 0', 73, 17);		// spawn a little blood

	if (scratch_noise) {
		sound (self, CHAN_AUTO, "demon/dhit2.wav", 0.5, ATTN_NORM);
		richtung = crandom () * 100;
		SpawnMeatSprayDrake(self.origin + v_forward * 30 + v_up*-5, v_right * richtung,BLOOD_RED);	// spawn a little gore
	}
};

void() ai_melee_torment = {
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 77) return;
		
	ldmg = (random() + random() + random()) * 4;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
};