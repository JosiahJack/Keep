//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Kinn
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
// Function count: 9
//
// Implements: Utility functions to play and/or remove a sprite
//
// Description:
// Simple utility functions from Kinn's Marcher Fortress and/or Bastion maps.
//=============================================================================

void() BDW_SpriteGenericLoop;
void() BDW_SpriteGenericPlayOnce;
float(vector vmin, vector vmax, vector spot) BoxInWall;

// Loops a sprite animation.  self.idleweaponframe represents the total number of frames in the animation. Frames are numbered 
// starting from 0, so the last frame in the animation is actually (self.idleweaponframe - 1). Useful for missiles.
void() BDW_SpriteGenericLoop = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > (self.idleweaponframe - 1))
		self.frame = 0;

	self.think = BDW_SpriteGenericLoop;
	self.nextthink = time + 0.05;
};

// Similar to the above, but removes sprite at end of animation. Useful for explosions.
void() BDW_SpriteGenericPlayOnce = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > (self.idleweaponframe - 1)) { entity_remove(self, 0.1); return; }
		
	self.think = BDW_SpriteGenericPlayOnce;
	self.nextthink = time + 0.05;
};

void() BDW_BodyDropSound = { sound(self,CHAN_BODY,"demon/dland2.wav", 0.7,ATTN_NORM); }; // [FUNCTION]

float() BDW_Check_idMapName = { // [FUNCTION]
	//if (world.model == "maps/start.bsp") return TRUE; Och laddie, can't do that!  Every mod under the sun has a map named start!
	if (world.model == "maps/e1m1.bsp") return TRUE;
	if (world.model == "maps/e1m2.bsp") return TRUE;
	if (world.model == "maps/e1m3.bsp") return TRUE;	
	if (world.model == "maps/e1m4.bsp") return TRUE;
	if (world.model == "maps/e1m5.bsp") return TRUE;
	if (world.model == "maps/e1m6.bsp") return TRUE;	
	if (world.model == "maps/e1m7.bsp") return TRUE;	
	if (world.model == "maps/e1m8.bsp") return TRUE;
	if (world.model == "maps/e2m1.bsp") return TRUE;
	if (world.model == "maps/e2m2.bsp") return TRUE;
	if (world.model == "maps/e2m3.bsp") return TRUE;	
	if (world.model == "maps/e2m4.bsp") return TRUE;
	if (world.model == "maps/e2m5.bsp") return TRUE;
	if (world.model == "maps/e2m6.bsp") return TRUE;	
	if (world.model == "maps/e2m7.bsp") return TRUE;	
	if (world.model == "maps/e3m1.bsp") return TRUE;
	if (world.model == "maps/e3m2.bsp") return TRUE;
	if (world.model == "maps/e3m3.bsp") return TRUE;	
	if (world.model == "maps/e3m4.bsp") return TRUE;
	if (world.model == "maps/e3m5.bsp") return TRUE;
	if (world.model == "maps/e3m6.bsp") return TRUE;	
	if (world.model == "maps/e3m7.bsp") return TRUE;	
	if (world.model == "maps/e4m1.bsp") return TRUE;
	if (world.model == "maps/e4m2.bsp") return TRUE;
	if (world.model == "maps/e4m3.bsp") return TRUE;	
	if (world.model == "maps/e4m4.bsp") return TRUE;
	if (world.model == "maps/e4m5.bsp") return TRUE;
	if (world.model == "maps/e4m6.bsp") return TRUE;	
	if (world.model == "maps/e4m7.bsp") return TRUE;	
	if (world.model == "maps/e4m8.bsp") return TRUE;
	//if (world.model == "maps/end.bsp") return TRUE; // Probably shouldn't do this one either.
	return FALSE;
};

// BDW_TouchRemove 07/12/2004
// This allows you to remove all entities directly
// inside touch functions. SOLID_TRIGGER and SOLID_BSP
// entities are added to trigger and clipping lists -
// if you just remove these entities directly in a 
// touch function, you can mess things up.
void(entity e) BDW_TouchRemove = { // [FUNCTION]
	e.solid = SOLID_NOT;
	setorigin(e, e.origin);
	remove(e);
};

// SUB_BBoxTraceCheck
// This checks for obstacles such as solid entities or walls inside
// the bbox and along its borders.  If an obstacle is met, FALSE is
// returned.
// bdw - this is a variant of the bbox function to be found in chaos test qc
// i have replaced the "head" entity with world, and the box entity with generic coordinates
// I mixed the two for maximum compatibility.  -Qmaster
float(entity head, vector box_mins, vector box_maxs, vector spot) SUB_BBoxTraceCheck = { // [FUNCTION]
	local vector p1, p2;

	// Check for obstacles inside the bbox.
	// Order:  1)--- to +++    2)+-- to -++    3)++- to --+    4)-+- to +-+
	p1 = spot + box_mins;
	p2 = spot + box_maxs;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = spot_x + box_maxs_x;
	p2_x = spot_x + box_mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_y = spot_y + box_maxs_y;
	p2_y = spot_y + box_mins_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = spot_x + box_mins_x;
	p2_x = spot_x + box_maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	// Check for obstacles along the bbox boundaries.
	// Order:  1)+++ to ++-    2)+-+ to +--    3)--+ to ---    4)-++ to -+-
	//         5)--- to +--    6)+-- to ++-    7)++- to -+-    8)-+- to ---
	//         9)+++ to -++   10)-++ to --+   11)--+ to -+-   12)-+- to +++
	p1 = p2 = spot + box_maxs;
	p2_z = spot_z + box_mins_z;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = p2_x = spot_x + box_mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_y = p2_y = spot_y + box_mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1_x = p2_x = spot_x + box_maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2 = spot + box_mins;
	p2_x = spot_x + box_maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + box_maxs_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_x = spot_x + box_mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + box_mins_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2 = spot + box_maxs;
	p2_x = spot_x + box_mins_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + box_mins_y;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_x = spot_x + box_maxs_x;
	traceline (p1, p2, FALSE, head);
	if (trace_fraction < 1)  return FALSE;

	p1 = p2;
	p2_y = spot_y + box_maxs_y;
	traceline (p1, p2, FALSE, head);
	return (trace_fraction == 1);
};

// SUB_BBoxInOccupied
// This checks if the spot is empty or occupied by a solid.
// bdw - variant - see above. this a very rigorous way of checking whether
// a given bbox is in an occupied space - use it for shuffler spawning, hell
// knight teleporting etc.
float(entity head, vector box_mins, vector box_maxs, vector spot) SUB_BBoxInOccupied = { // [FUNCTION]
    if (BoxInWall(box_mins,box_maxs,spot)) return TRUE; // If a wall or other solid is in the way, the monster can't respawn here.
	return !SUB_BBoxTraceCheck(head,box_mins,box_maxs,spot); // Check if other obstacles such as entities are occupying the space.
};