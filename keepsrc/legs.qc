// Add this in client.qc inside PlayerPreThink
/* Not this
	if (!( deathmatch || coop )) { // adds player´s legs to 1st person view  (meant for Single player only !)
		if (self.visible_legs_helper == 0) {
			self.visible_legs_helper = 1;
			player_legs (self);
		}
	}
*/ // Not this, end addition for PlayerPreThink

/////// player legs visibility in 1st person view
var float autocvar_player_legs_visibility = 1;		// set cvar 'player_legs_visibility' default to 1.    0= disabled    1= player legs are visible in 1st person view when looking down (this setting is for FOV smaller than 100)   2= player legs are visible in 1st person view when looking down (this setting is for FOV between 100 and 110)    3= player legs are visible in 1st person view when looking down (this setting is for FOV higher than 110)
var float autocvar_player_legs_model = 2;		// set cvar 'player_legs_model' default to 2.     1= use original ID1 player legs when cvar 'player_legs_visibility' is enabled        2= use Ruohis player legs when cvar 'player_legs_visibility' is enabled    

.float visible_legs_helper;

void() player_legs_animation = {
	if ((cvar("chase_active")) || (self.owner.invisible_finished))	// if switched into 3rd person mode while playing
		self.alpha = -1;
	else
		self.alpha = 1;

	makevectors (self.owner.angles);
	// only spawn player legs when looking downwards and is alive
	if ((self.owner.angles_x <= -9) && (self.owner.health > 0) && (cvar("player_legs_visibility"))) {
		if (autocvar_player_legs_visibility == 3)
			self.origin = self.owner.origin + v_up * 7 + v_forward * -20;		// for approx. FOV > 110
		else if (autocvar_player_legs_visibility == 2)
			self.origin = self.owner.origin + v_up * 7 + v_forward * -15;		// for approx. FOV between 100 and 110
		else 
			self.origin = self.owner.origin + v_up * 7 + v_forward * -10;		// for approx. FOV < 100

		self.angles = self.owner.angles;
		self.angles_x = 15;		// legs must not change x-angles together with player´s view
		if (autocvar_player_legs_model == 1)
		{
			if (self.owner.items & IT_SUIT)
				setmodel (self, "progs/q15/player_legs1_suit.mdl");
			else
				setmodel(self, "progs/q15/player_legs1.mdl");			
		}
		else
			setmodel(self, "progs/q15/player_legs2.mdl");

		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	} else {
		setmodel(self, ""); // hide, nobody is looking or we are dead
	}
	self.solid = SOLID_NOT;
	self.frame = self.owner.frame; // the actual animation part
	self.think = player_legs_animation;
	self.nextthink = time;
};

entity(entity e) player_legs = {
	local entity shaderrr;

	shaderrr = spawn();
	shaderrr.skin = 0;	
	shaderrr.owner = e;
	shaderrr.think = player_legs_animation;
	shaderrr.colormap = e.colormap;
	shaderrr.nextthink = time;
	return shaderrr;
};