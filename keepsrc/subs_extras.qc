//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: extras_r4, extras_r5 (as of 2019, still active then)
//				Written by Frank Condello <pox@planetquake.com>
//				Updated by khreathor to extras_r5 for Underwater Jam (2018)
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
// Implements: Subroutines for extras_r4 & extras_r5 mod
//
// Description:
// Various helper functions for liquid movers .
//=============================================================================

// Return a random number between min & max (or min if max is 0).  Replaced with AD's misc_model_RandomRange as it was identical but had better checks.
float(float minrange, float maxrange) SUB_RandomRange = {
	local float fullrange, retrange;
	
	// Obvious parameter errors
	if (minrange == maxrange) return minrange;
	if (maxrange < minrange) return maxrange;

	fullrange = maxrange - minrange; // Create range first and then add to minimum
	retrange = minrange + (random() * fullrange);
	retrange = rint(fabs(retrange)); // Make sure no fractions or negative numbers

	// Double check within the specified range
	if (retrange < minrange) retrange = minrange;
	else if (retrange > maxrange) retrange = maxrange;
	
	return retrange; // Thats all folks!
};

float lastframe;

// Modified SUB_CalcMove clone that work with non-push entities.  This is called from PostThink to advance all moving triggers each frame.
void() SUB_PushFrameMovers = {
	local entity ent;
	local vector org, out, up;
	
	if (lastframe == time) return; // Make sure this only happens once per frame (bots)

	lastframe = time;
	ent = find(world, fmover, "moving"); // Find the first ent
	while(ent) {	
		// Child move
		if (ent.owner) {
			// Ignore next frame (done moving)
			if (ent.owner.velocity == '0 0 0') {
				ent.fmover = "";
				ent.origin = ent.owner.origin;
				setorigin(ent, ent.origin);
			} else if ((ent.owner.attack_finished-(0.5-frametime)) > time ) {
				// Parent is Blocked
				ent.origin = ent.owner.origin;
				setorigin(ent, ent.origin);
			} else {
				// Lead parent a bit (seems to track better)
				ent.origin = ent.owner.origin + ent.owner.velocity*frametime;
				setorigin(ent, ent.origin);
			}
		} else if (ent.velocity == '0 0 0') {
			// Independant func_water or func_watertrain
			ent.fmover = "";// Ignore next frame (done moving)
		} else {
			// Add move for this frame
			ent.origin = ent.origin + ent.velocity*frametime;
			setorigin(ent, ent.origin);
		}
		ent = find(ent, fmover, "moving"); // Get the mext one
	}	

	// Handle monster attachments - Keep addition by Qmaster.
	ent = find(world, hasobject, "true"); // Find the first ent
	while(ent) {
		if (ent.flags & FL_MONSTER) {
			// Child move
			if (ent.entattachment) {
				makevectors(ent.angles);
				out = v_forward;
				out = normalize (out);
				up = VEC_ORIGIN;
				up_z = ent.attachment_offset_z;
				org = ((ent.origin + (((ent.bbmaxs_x * 2)+ent.attachment_offset_x) * out)) + up);
				setorigin(ent.entattachment,org); // Ok we got it.  It's out in front of monster still.
				ent.entattachment.angles = ent.angles;
			}
		}
		ent = find(ent, hasobject, "true"); // Get the mext one
	}	
};