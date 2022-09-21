//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Rogue
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
//
// Implements: Mitosis Spawn
//
// Description:
// A green gelatinous blob that splits into two.  Otherwise just like a normal
// spawn and explodes on death.
//=============================================================================

void() monster_tarbaby;

void(entity inflictor, entity attacker, float damage) tbaby_mitosis = { // [FUNCTION]
	if ( random() < 0.35 ) {
		newmis = spawn();
		newmis.classname = self.classname;
		newmis.skin = self.skin;
		SUB_ThinkImmediate(newmis,monster_tarbaby);
        sound(newmis,CHAN_VOICE,"rogue/blob/mytosis.wav",1,ATTN_NORM);
	}
};

void(float strong) monster_tarbaby_mitosis_setup = { // [FUNCTION]
	if (strong) {
		if (self.health < 1) self.health = 100;
		if (self.skin <= 0) self.skin = self.exactskin = 2;
	} else {
		if (self.health < 1) self.health = 60;
		if (self.skin <= 0) self.skin = self.exactskin = 24;
	}
	if (self.deathstring == "") self.deathstring = " was slimed by a Mitosis Spawn\n";
	if (self.minion_name == "") {
		self.minion_name = "monster_tarbaby";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }
	self.th_pain = tbaby_mitosis;
};

void() monster_tarbaby_mitosis = { // [ENTITY]
	if (random() < 0.5) monster_tarbaby_mitosis_setup(TRUE);
	else monster_tarbaby_mitosis_setup(FALSE);
	monster_tarbaby();
};