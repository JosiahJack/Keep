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
// Function count: 2
//
// Implements: Nehahra aim leading subroutine functions
//
// Description:
// Simple utility functions to aid in monsters tracking player movement.
// Different than drake's maim features as the behavior is different.
//=============================================================================

vector() nehahra_lead = {
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

vector(float t) mindcrime_lead = {
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