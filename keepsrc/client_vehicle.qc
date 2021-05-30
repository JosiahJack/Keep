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

// Update the legs
void() player_vehicle_animation = {
	if ((cvar("chase_active")) && self.owner.in_a_vehicle) { // if switched into 3rd person mode while driving
		makevectors (self.owner.angles);
		self.angles = self.owner.angles;
		self.angles_x = 15;		// legs must not change x-angles together with player´s view
		if (!self.owner.vehicle_model) self.owner.vehicle_model = "progs/qrally/sumabase.mdl";
		setmodel(self,self.owner.vehicle_model);
		self.skin = self.owner.vehicle_skindex;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.scale = 2;
		self.solid = SOLID_NOT;
		self.frame = 0; // the actual animation part
	} else {
		setmodel(self,"");
	}
	setorigin (self,self.owner.origin);
	self.think = player_vehicle_animation;
	self.nextthink = time;
};

// Create the legs.  Done only once at level start.
entity(entity e) player_vehicle = {
	local entity shaderrr;

	shaderrr = spawn();
	shaderrr.skin = 0;	
	shaderrr.owner = e;
	shaderrr.think = player_vehicle_animation;
	shaderrr.colormap = e.colormap;
	shaderrr.nextthink = time;
	return shaderrr;
};