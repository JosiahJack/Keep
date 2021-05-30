//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Function count: 3
//
// Implements: Utility functions to play and/or remove a sprite
//
// Description:
// Simple utility functions from Kinn's Marcher Fortress and/or Bastion maps.
//=============================================================================

void() BDW_SpriteGenericLoop;
void() BDW_SpriteGenericPlayOnce;

// Loops a sprite animation.  self.idleweaponframe represents the total number of frames in the animation. Frames are numbered 
// starting from 0, so the last frame in the animation is actually (self.idleweaponframe - 1). Useful for missiles.
void() BDW_SpriteGenericLoop = {
	self.frame = self.frame + 1;
	if (self.frame > (self.idleweaponframe - 1))
		self.frame = 0;

	self.think = BDW_SpriteGenericLoop;
	self.nextthink = time + 0.05;
};

// Similar to the above, but removes sprite at end of animation. Useful for explosions.
void() BDW_SpriteGenericPlayOnce = {
	self.frame = self.frame + 1;
	if (self.frame > (self.idleweaponframe - 1)) { entity_remove(self, 0.1); return; }
		
	self.think = BDW_SpriteGenericPlayOnce;
	self.nextthink = time + 0.05;
};

void() BDW_BodyDropSound = { sound(self, CHAN_BODY, "demon/dland2.wav", 0.7, ATTN_NORM); };