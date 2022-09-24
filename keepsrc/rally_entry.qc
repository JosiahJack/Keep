//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Qmaster, inspired by Halo and using Quake Rally as a base.
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
// Entity count: 1
// Function count: 1
// Implements: Vehicle Entry and Exit
//
// Description:
// Vehicles that you can enter and use until they are destroyed, or jump to get
// out of are treated like items.
//=============================================================================

void() item_rallycar_touch = { // [FUNCTION]
	local float boundedChase;

	if (self.pain_finished > time) return;
	if (!(other.flags & FL_CLIENT)) return; // Only players can drive!
	if (other.in_a_vehicle) return; // Already in a car

	other.in_a_vehicle = TRUE; // Put them in the vehicle (handled in client_power.qc)
	other.vehicle_index = self.vehicle_index;
	other.vehicle_model = self.mdl;
	other.vehicle_skindex = self.vehicle_skindex;
	other.randomshells = self.ammo_shells + self.ammo_nails
                         + self.ammo_rockets + self.ammo_cells; // Give whatever ammo we have.
	other.turrethealth = other.health; // Save it.
	other.turrethealth2 = other.max_health;
	other.turrettimer = other.armorvalue;
	other.armorvalue = self.armorvalue;
	other.health = self.health;
	other.v_angle = self.angles;
	other.angles = self.angles;
	boundedChase = cvar("chase_back");
	if (boundedChase > 255) boundedChase = 255;
	else if (boundedChase < 0) boundedChase = 0;
	cvar_set("scratch2",ftos(encode(cvar("chase_active"),boundedChase,0)));
	localcmd("chase_active 1\n");
	localcmd("chase_back 128\n"); // evil!  It's okay.  It's okay, we saved it in scratch2
	if (self.vehicle_index == 3) sound(self,CHAN_AUTO,"qrally/ray/engstart.wav",1,ATTN_STATIC);
	else if (self.vehicle_index == 4) sound(self,CHAN_AUTO,"qrally/start2.wav",1,ATTN_STATIC);
	else sound(self,CHAN_AUTO,"qrally/start.wav",1,ATTN_STATIC);
	remove(self);
};

void() item_rallycar = { // [ENTITY]
	if (!self.mdl) self.mdl = "progs/qrally/sumanail.mdl"; // Default to the stock car
	if (self.mdl == "progs/qrally/sumanail.mdl") self.vehicle_index = 2;
	else if (self.mdl == "progs/qrally/zumanail.mdl") self.vehicle_index = 3;
	else if (self.mdl == "progs/qrally/mgnanail.mdl") self.vehicle_index = 4;
	else if (self.mdl == "progs/qrally/tritnail.mdl") self.vehicle_index = 5;
	else self.vehicle_index = 1;

	precache_model(self.mdl);
	precache_model("progs/qrally/sumabase.mdl");
	precache_model("progs/qrally/sumanail.mdl");
	precache_model("progs/qrally/sumarock.mdl");
	if (self.vehicle_index == 3) precache_sound("qrally/ray/engstart.wav");
	else if (self.vehicle_index == 4) precache_sound("qrally/start2.wav");
	else precache_sound("qrally/start.wav");

	precache_sound("qrally/meepmeep.wav");
	precache_sound("q15/weapons/rocket1i.wav");
    precache_sound("zerstorer/weapons/sawridle.wav"); // Engine idling.
	precache_model("progs/redfield/proj_nailcase.mdl");

	if (self.skin > 1) self.skin = 1; // cap it, models only have 2 skins
	self.vehicle_skindex = self.skin;
	self.solid = SOLID_TRIGGER;
	self.touch = item_rallycar_touch;
	self.scale = 2;
	if (self.armorvalue == 0) self.armorvalue = 100; // Vehicle gas
	if (self.health <= 0) self.health = 250; // Vehicle health
	if (self.ammo_nails <= 0) self.ammo_nails = 200; // Vehicle ammo
	setmodel(self,self.mdl);
	setsize(self,VEC_HULL2_MIN,VEC_HULL2_MAX);
	self.pain_finished = time + 1 + (random() * 5); // prevent touch for a bit
};