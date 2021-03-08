/*======================================================================
	T_EELZap
	Ignores entities outside of the water and other eels
	inflictor -(self) = projectile
	attacker - (self.owner) = monster/player OR (self) = direct attack
	ignore   - (other) = Original target OR (world) = no exceptions
======================================================================*/
void(entity inflictor, entity attacker, float damage, entity ignore, float checkclass) T_EELZap = {
	local float points;
	local entity head;
	local vector org, imporg;

	// Cannot hurt the world or enemy targets (fake flying markers)
	if (attacker.noradiusdmg) return;
	if (attacker.classtype == CT_WORLD) return;
	if (attacker.classtype == CT_ENEMYTARGET) return;

	// check if inflictor is a bmodel (different origin location)
	if (inflictor.bsporigin) imporg = bmodel_origin(inflictor);
	else imporg = inflictor.origin;
		
	head = findradius(imporg, damage+40);
	while (head) {
		if (head != ignore) {
			// This is used mostly for wraiths so when they die they don't
			// kill each other, can't get the code logic to work so its
			// setup as a dead exception path
			if (checkclass == IGNORECLASS && head.classtype == ignore.classtype) { }
			else {
				// Check for any breakable which is prone to explosive damage
				if (ai_foundbreakable(attacker, head,TRUE) && head.brktrigmissile !=0) {
					trigger_ent(head, attacker);
				}
				else {
					// Can be damaged and NOT immune to radius (splash) damage
					if (head.takedamage > 0 && head.noradiusdmg == 0) {
						org = head.origin + (head.mins + head.maxs)*0.5;
						points = 0.5*vlen (imporg - org);
						if (points < 0) points = 0;
						points = damage - points;
						if (head == attacker) points = points * 0.5;
						if (points > 0 && head.health > 0) {
							// Need CanDamage to check for anything blocking LoS
							// It will do several traces (source->target) to check
							// for any blocking entities (lifts, doors, walls etc)
							if (CanDamage (head, inflictor)) {
								if (head.resist_rockets > 0) 
									points = points * head.resist_rockets;
								if ((head.classtype != CT_MONEEL) && (head.flags & FL_INWATER)) {
									T_Damage (head, inflictor, attacker, points, DAMARMOR);
								}
							}
						}
					}
				}
			}
		}
		head = head.chain;
	}
};

// From Quoth
void() ai_shotcheck = { if (visible(self.enemy)) self.oldenemyorigin = self.enemy.origin; };