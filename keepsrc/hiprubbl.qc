//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic) by Ritual Entertainment
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
// Entity count: 4
// Function count: 3
//
// Implements: Rubble
//
// Description:
// Small chunks of rock that hurt you when they hit you.
//=============================================================================

void() hipRubbleTouch = { // [FUNCTION]
	if (self.ltime < self.pausetime) return;

	if (other.takedamage) {
		T_Damage(other,self,self.owner,MOVETYPE_BOUNCE,DAMARMOR);
		sound(self,CHAN_WEAPON,"zombie/z_hit.wav",TRUE,ATTN_NORM);
		self.pausetime = (self.ltime + 0.100);
	}
};

void(string rubblename) hipThrowRubble = { // [FUNCTION]
	newmis = spawn();
	newmis.classtype = CT_TEMPPHYS;
	newmis.origin = self.origin;
	setmodel(newmis,rubblename);
	setsize(newmis,VEC_ORIGIN,VEC_ORIGIN);
	setorigin(newmis,newmis.origin);
	newmis.velocity_x = ((self.mangle_x) + 70.000 * crandom ());
	newmis.velocity_y = ((self.mangle_y) + 70.000 * crandom ());
	newmis.velocity_z = ((self.mangle_z) + 140.000 + (70.000 * random ()));
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.avelocity_x = (random () * 600.000);
	newmis.avelocity_y = (random () * 600.000);
	newmis.avelocity_z = (random () * 600.000);
	newmis.think = SUB_Remove;
	newmis.touch = hipRubbleTouch;
	newmis.ltime = time;
	newmis.nextthink = ((time + 13.000) + (random () * MOVETYPE_BOUNCE));
	self.pausetime = time;
	newmis.frame = FALSE;
	newmis.flags = FALSE;
};

void() hip_rubble_use = { // [FUNCTION]
	local float which, index;

	index = FALSE;
	while (index < self.count) {
	which = self.cnt;
		if (!self.cnt) which = floor(3 * random ());
		if (which == 1) hipThrowRubble ("progs/hipnotic/rubble1.mdl");
		if (which == 2) hipThrowRubble ("progs/hipnotic/rubble3.mdl");
		if (which == 3) hipThrowRubble ("progs/hipnotic/rubble2.mdl");
		index = (index + TRUE);
	}
};

void() func_rubble = { // [ENTITY]
	precache_model ("progs/hipnotic/rubble1.mdl");
	precache_model ("progs/hipnotic/rubble2.mdl");
	precache_model ("progs/hipnotic/rubble3.mdl");
	precache_sound("zombie/z_hit.wav");
	if (self.classname == "func_rubble") self.classname = "rubble";
	self.cnt = FALSE;
	if (!self.count) self.count = 1;
	self.use = hip_rubble_use;
};

void() func_rubble1 = { // [ENTITY]
	self.classname = "rubble1";
	self.cnt = 1;
	func_rubble();
};

void() func_rubble2 = { // [ENTITY]
	self.classname = "rubble2";
	self.cnt = 2;
	func_rubble();
};

void() func_rubble3 = { // [ENTITY]
	self.classname = "rubble3";
	self.cnt = 3;
	func_rubble();
};