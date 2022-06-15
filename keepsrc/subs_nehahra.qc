//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by Qmaster
//
// Attributions: Nehahra
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
// Function count: 4
//
// Implements: Nehahra aim leading and other subroutine functions
//
// Description:
// Simple utility functions to aid in monsters tracking player movement.
// Different than drake's maim features as the behavior is different.
//=============================================================================

vector() nehahra_lead = { // [FUNCTION]
	local float num;
	local vector megadeth, vec;
	local entity mark;

	if (!self.enemy) return VEC_ORIGIN;

	mark = find(world, classname, "nehahra_head");
	num = 1;
	megadeth = self.enemy.origin - mark.origin;
	num = vlen(megadeth);
	num = num * 0.001;
	vec = self.enemy.velocity;
	vec_z = vec_z * 0.25;
	vec = self.enemy.origin + (vec * num);
	vec = normalize(vec - mark.origin);
	return vec;
};

vector(float t) mindcrime_lead = { // [FUNCTION]
	local float num;
	local vector dir, megadeth, vec;

	if (t < 1000) {
		num = 1000 - t;
		t = 1000 + num;
	} else {
		num = t - 1000;
		t = 1000 - num;
	}
	t = t * 0.000001;
	megadeth = self.enemy.origin - self.origin;
	num = vlen(megadeth);
	num = num * t;
	vec = self.enemy.velocity;
	vec_z = vec_z * 0.25;
	dir = self.enemy.origin + (vec * num);
	dir = normalize(dir - self.origin);
	return dir;
};

float IsOnTopOf(entity top, entity bottom) = { // [FUNCTION]
	if (top.absmin_z < bottom.absmax_z - 3) return FALSE;
	if (top.absmin_z > bottom.absmax_z + 2) return FALSE;
	if (top.absmin_y > bottom.absmax_y) return FALSE;
	if (top.absmax_y < bottom.absmin_y) return FALSE;
	if (top.absmin_x > bottom.absmax_x) return FALSE;
	if (top.absmax_x < bottom.absmin_x) return FALSE;
	return TRUE;
}

void() player_push = { // [FUNCTION]
	local vector spot;
	local float meas, chck;

	if (other.classname != "player") return;
	if (!(other.flags & FL_CLIENT)) return;
	if (IsOnTopOf(other, self)) return;

  	if (self.pain_finished < time) {
		self.pain_finished = time + 0.4;
		if (self.event == "stone") sound(self, 7, "nehahra/wall/statslid.wav", 1, ATTN_NORM);
		else sound(self, 7, "nehahra/wall/barslide.wav", 1, ATTN_NORM);
    }
	if (walkmove(other.angles_y, 2) == FALSE) {
		meas = other.origin_z + 3;
		chck = meas - self.origin_z;
		if (self.origin_z < meas) {
			if (chck < 10) self.origin_z = self.origin_z + 1;
			self.velocity_x = other.velocity_x + 4 * random();
			self.velocity_y = other.velocity_y + 4 * random();
			if (self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
		}
	}
}