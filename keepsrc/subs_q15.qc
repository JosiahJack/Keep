//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by Qmaster
//
// Attributions: Drake by Patrick Martin but as used in Quake 1.5 by BloodShot
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
// Implements: Quake 1.5 subroutine functions and utilities
//
// Description:
// Simple utility functions for q15 features.
//=============================================================================

//  check.qc -- by Patrick Martin               Last updated:  9-8-1997
//  This file contains code that determines whether an entity or a location is inside the various contents found in Quake.
//  This checks for obstacles such as solid entities or walls inside the bbox and along its borders.  If an obstacle is met, FALSE is returned.
float(entity head, vector spot) PM_TraceCheck = {
	local   vector  p1, p2;

	// Check for obstacles inside the bbox.
	// Order:  1)--- to +++    2)+-- to -++    3)++- to --+    4)-+- to +-+
	p1 = spot + self.mins;
	p2 = spot + self.maxs;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = spot_x + self.maxs_x;
	p2_x = spot_x + self.mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_y = spot_y + self.maxs_y;
	p2_y = spot_y + self.mins_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = spot_x + self.mins_x;
	p2_x = spot_x + self.maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	// Check for obstacles along the bbox boundaries.
	// Order:  1)+++ to ++-    2)+-+ to +--    3)--+ to ---    4)-++ to -+-
	//         5)--- to +--    6)+-- to ++-    7)++- to -+-    8)-+- to ---
	//         9)+++ to -++   10)-++ to --+   11)--+ to -+-   12)-+- to +++
	p1 = p2 = spot + self.maxs;
	p2_z = spot_z + self.mins_z;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = p2_x = spot_x + self.mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_y = p2_y = spot_y + self.mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = p2_x = spot_x + self.maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2 = spot + self.mins;
	p2_x = spot_x + self.maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + self.maxs_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_x = spot_x + self.mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + self.mins_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2 = spot + self.maxs;
	p2_x = spot_x + self.mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + self.mins_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_x = spot_x + self.maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + self.maxs_y;
	traceline (p1, p2, FALSE, head);
	return (trace_fraction == 1);
};

//  This checks if a bbox is inside a wall or sky.  The bbox's origin and corners are checked.  If any one points is within a solid or sky, TRUE is returned.
float(entity head, vector spot) PM_InWall = {
	local   vector  p;

	// Check origin.
	p = spot;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	// Check bbox faces.
	// Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.maxs_x;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p = spot;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_y = spot_y + head.maxs_y;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p = spot;
	p_z = spot_z + head.mins_z;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_z = spot_z + head.maxs_z;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	// Check bbox corners.
	// Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.maxs_y;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.maxs_y;
	p_z = spot_z + head.mins_z;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
	return (pointcontents(p) == CONTENT_SKY);
};