// Add this in client.qc inside PlayerPreThink
/* Not this
	if (!( deathmatch || coop )) { // adds player´s legs to 1st person view  (meant for Single player only !)
		if (self.visible_legs_helper == 0) {
			self.visible_legs_helper = 1;
			player_legs (self);
		}
	}
*/ // Not this, end addition for PlayerPreThink

.float visible_legs_helper;

void() player_legs_animation = {
	makevectors (self.owner.angles);
	// only spawn player legs when looking downwards and is alive
	if ((self.owner.angles_x <= -9) && (self.owner.health > 0)) {
		// self.origin = self.owner.origin + v_up * 7 + v_forward * -20;		// for approx. FOV > 110
		// self.origin = self.owner.origin + v_up * 7 + v_forward * -15;		// for approx. FOV between 100 and 110
		self.origin = self.owner.origin + v_up * 7 + v_forward * -10;		// for approx. FOV < 100
		self.angles = self.owner.angles;
		self.angles_x = 15;		// legs must not change x-angles together with player´s view
		setmodel(self, "progs/player_legs.mdl");			
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	} else {
		setmodel(self, ""); // hide, nobody is looking or we are dead
	}

	self.solid = SOLID_NOT;
	self.frame = self.owner.frame; // the actual animation part
	self.think = player_legs_animation;
	self.nextthink = time;
};

void(entity e) player_legs = {
	local entity shaderrr;

	shaderrr = spawn();
	shaderrr.skin = 0;	
	shaderrr.owner = e;
	shaderrr.think = player_legs_animation;
	shaderrr.colormap = e.colormap;
	shaderrr.nextthink = time;
};