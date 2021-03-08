void () shambler_walking_quake = { 
	local entity enFind;
	enFind = findradius(self.origin, 444);
			
	while(enFind) { 
		if(enFind.flags & FL_ONGROUND) { 
			if (enFind.flags & FL_CLIENT) {
				if (cvar("sv_gravity") > 600 && enFind.gravity) {
					enFind.velocity_x = enFind.velocity_x + (crandom() * 30);  
					enFind.velocity_y = enFind.velocity_y + (crandom() * 30); 
					enFind.velocity_z = enFind.velocity_z + (crandom() * 75); 
				} 
			   	enFind.punchangle = enFind.punchangle + (randomvec() * 0.6);  // Apply Punchangle
			}
		}
		enFind = enFind.chain;
	}
};

void() screenshake = {
	local entity plyr;
	local float	d;

	if (self.attack_finished < time) return; // Is the shaking over?
	
	plyr = findradius(self.origin, 1300); // Create a list of entities to check for players
	while(plyr) {
		if (plyr.flags & FL_CLIENT) { // Only shake players (clients)
			// Scale effect by distance
			d = vlen(self.origin - plyr.origin);
			d = (1300 - d)/180;
			
			if (d > 0) {
				// shake up the view
				plyr.punchangle_x = -1 * (random(-1,1) + (0.025*2*d));
				plyr.punchangle_y = -1 * (random(-1,1) + (0.025*2*d));
				plyr.punchangle_z = -1 * (random(-2,2) + (0.025*2*d));	
			}
		}
		// Find next entity in chain
		plyr = plyr.chain;
	}
	
	// keep shaking!  shake a little faster!  shake a little slower!  good thing we got our shaking clothes
	self.nextthink = time + 0.1;
	self.think = screenshake;
};

// idea taken from kleshik
void (float fPunchStrength, float fRadius) Monster_Animation_EarthQuake = { 
	local entity enFind;

	if(self.flags & FL_ONGROUND) { 
		enFind = findradius(self.origin, fRadius);	
		while(enFind) { 
			if(enFind.flags & FL_ONGROUND && enFind != self) { 
				if (enFind.flags & FL_MONSTER || enFind.flags & FL_CLIENT) {
					enFind.velocity_x = enFind.velocity_x + (crandom() * fPunchStrength * 5);  
					enFind.velocity_y = enFind.velocity_y + (crandom() * fPunchStrength * 5); 
					enFind.velocity_z = enFind.velocity_z + (fPunchStrength * 10) + (crandom() * 40);  
				}
				if (enFind.flags & FL_CLIENT) enFind.punchangle = enFind.punchangle + (randomvec() * (0.7 * fPunchStrength));  // Apply Punchangle
			}
			enFind = enFind.chain;
		}
	}
};