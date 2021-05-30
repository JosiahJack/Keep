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
// Function count: 11
//
// Implements: Subroutines
//
// Description:
// Useful functions that simplify a lot of checks or provide global
// functionality.
//=============================================================================

float (entity o) IsProjectile = {
	return (o.classgroup == CG_PROJALL || o.classgroup == CG_PROJSHELLS
		 || o.classgroup == CG_PROJNAILS  || o.classgroup == CG_PROJLAVANAILS
		 || o.classgroup == CG_PROJROCKETS  || o.classgroup == CG_PROJGRENADES
		 || o.classgroup == CG_PROJCELLS  || o.classgroup == CG_PROJHAZARD
		 || o.classgroup == CG_MINIONEGG || o.classgroup == CG_PROJMULTIROCKETS
		 || o.classgroup == CG_PROJBOLTSPOISON || o.classgroup == CG_PROJBOLTS
		 || o.classgroup == CG_PROJBLOODCRYSTALS || o.classgroup == CG_PROJVOID
		 || o.classgroup == CG_PROJMAGIC || o.classgroup == CG_PROJICE);
};

float(entity o) AffectedByPhysics = {
	if (IsProjectile(o)) return TRUE;
	if (o.classtype == CT_FUNCBREAKOBJ) return TRUE;
	if (o.classtype == CT_TEMPGIB) return TRUE;
	if (o.classtype == CT_TEMPPHYS) return TRUE;
	if (o.classtype == CT_BUBBLE) return TRUE;
	if (o.classtype == CT_MISCDRIP) return TRUE;
	if (o.classtype == CT_TEMPSPARK) return TRUE;
	if (o.classtype == CT_PROJ_MEGG) return TRUE;
	return FALSE;
};

// From Quoth for calculating gib velocity for polyp
vector (float dm) VelocityForDamage = {
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();
	if (dm > -50) {
		v = v * 0.7;
	} else {
		if (dm > -200) {
			v = v * 2;
		} else {
			v = v * 10;
		}
	}
	return v;
};

float(vector spot) InAir = { return (pointcontents(spot) == CONTENT_EMPTY); };
float(vector spot) InSolid = { return (pointcontents(spot) == CONTENT_SOLID); };
float(vector spot) InWater = { return (pointcontents(spot) == CONTENT_WATER); };
float(vector spot) InSlime = { return (pointcontents(spot) == CONTENT_SLIME); };
float(vector spot) InLava = { return (pointcontents(spot) == CONTENT_LAVA); };
// InSky not made since AD's check_skycontent is more robust and uses different advanced engine features.
float(vector spot) InLiquid = {
	local float conts;

	conts = pointcontents(spot);
	return ((conts <= CONTENT_WATER) && (conts != CONTENT_SKY));
};

float(entity ent, vector p2, float dist, float nomonsters) pointvisible = {
    local vector p1;

    p1 = ent.origin;
    if (vlen (p2 - p1) > dist) return FALSE; // Exceeded maximum distance.
    traceline (p1, p2, nomonsters, self);
    if (trace_fraction < 1) return FALSE;    // Not in line-of-sight.
    return TRUE;
};

// Creates a new vector.  From copper, renamed for clarity and avoid case insensitive errors.
vector(float x, float y, float z) NewVector = {
	local vector swiz;

	swiz_x = x;
	swiz_y = y;
	swiz_z = z;
	return swiz;
};

// From copper, renamed for clarity
vector(vector a, vector b) vec_multiply_elementwise = {
	return NewVector(a_x * b_x, a_y * b_y, a_z * b_z);
};