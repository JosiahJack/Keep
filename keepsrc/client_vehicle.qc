//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Quake Rally
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
// Function count: 2
//
// Implements: Player vehicle model in 3rd person view
//
// Description:
// Shows your vehicle.  Changes model according to which vehicle we entered.
//=============================================================================

float VEHICLE_TURN_SPEED = 5; // Amount of degrees to rotate every 0.1s
float VEHICLE_GAS_TICK = 1;
float VEHICLE_GAS_TAKE = 1;

void(float ideal) vehicle_angle_lerp = { // [FUNCTION]
	local float amount;

	amount = ideal - self.angles_y;
	if (amount > 0) amount = VEHICLE_TURN_SPEED;
	else amount = -1 * VEHICLE_TURN_SPEED;

	self.angles_y = self.angles_y + amount;
	ChangeYaw();
};

// Update the vehicle
void() player_vehicle_animation = { // [FUNCTION]
	local float drain;

	if ((cvar("chase_active")) && self.owner.in_a_vehicle) { // if switched into 3rd person mode while driving
		//makevectors (self.owner.angles);
		//self.angles = self.owner.angles;
		vehicle_angle_lerp(self.owner.angles_y);

		if (self.owner.randomshells > 0 ) {
			if (!self.owner.vehicle_model
                || (self.owner.vehicle_model != "progs/qrally/sumanail.mdl")) {
				self.owner.vehicle_model = "progs/qrally/sumanail.mdl";
			}
		} else {
			if (self.owner.vehicle_model != "progs/qrally/sumabase.mdl") {
				self.owner.vehicle_model = "progs/qrally/sumabase.mdl";
			}
		}

		setmodel(self,self.owner.vehicle_model);
		self.skin = self.owner.vehicle_skindex;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.scale = 2;
		self.solid = SOLID_NOT;
		self.frame = 0; // the actual animation part
		if (self.pain_finished < time && self.owner.armorvalue > 0) {
			self.pain_finished = time + VEHICLE_GAS_TICK;
			drain = self.owner.armorvalue - VEHICLE_GAS_TAKE;
			if (drain < 1) self.owner.armorvalue = 0;
			else {
				if (self.owner.velocity_x > 20 || self.owner.velocity_z > 20) {
					self.owner.armorvalue = self.owner.armorvalue - VEHICLE_GAS_TAKE; // Will I ever see it at $1.99 USD/gal again??
				}
			}
		}
		if (self.owner.armorvalue == 0) TakeTargetOutOfVehicle(self.bmodel_act,TRUE,FALSE); // Jump, don't destroy car
	} else {
		setmodel(self,"");
	}
	if (!(cinematic_running || cutscene || intermission_running)) setorigin (self,self.owner.origin);
	else setorigin (self,self.oldorigin); // stay put
	self.oldorigin = self.origin;
	self.think = player_vehicle_animation;
	self.nextthink = time + 0.05;
};

// Create the blank vehicle holder entity.  Done only once at level start.
entity(entity e) player_vehicle = { // [FUNCTION]
	local entity shaderrr;

	shaderrr = spawn();
	shaderrr.skin = 0;	
	shaderrr.owner = e;
	shaderrr.think = player_vehicle_animation;
	shaderrr.colormap = e.colormap;
	shaderrr.nextthink = time;
	shaderrr.pain_finished = time + VEHICLE_GAS_TICK;
	return shaderrr;
};