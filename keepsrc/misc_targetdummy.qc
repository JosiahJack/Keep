//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Entity count: 2
// Function count: 6
//
// Implements: Target Practice Dummy For Testing Weapon Damage
//
// Description:
// A non-combatant enemy that takes damage.  Only used for weapons testing.
//=============================================================================

float MISC_TARGKNIGHT = 1;
float MISC_TARGWIZARD = 2;
float MISC_TARGOGRE = 4;
float MISC_TARGHELLKNIGHT = 8;
float MISC_TARGZOMBIE = 16;
float MISC_TARGDEMON = 32;
float MISC_TARGSHALRATH = 64;
float MISC_TARGSHAMBLER = 128;

void(float tvalue, string tdstr) misc_targetdummy_trigger = { // [FUNCTION]
	local entity tdfind, tself, tother;
	if (tdstr == "") return;
	
	self.targetnumber = tvalue;
	tdfind = find(world, targetname, tdstr);
	if (tdfind.classtype == CT_TARGETNUMBER) {
		tself = self; tother = other;
		self = tdfind; other = tself;
		self.use();
		self = tself; other = tother;
	}
};

void() misc_targetdummy_stand = { // [FUNCTION]
	self.frame = self.frame + 1; // Cycle around standing animation
	if (self.frame == self.pos1_y) self.frame = self.pos1_x;
	self.nextthink = time + 0.1;
	
	// Check for any accumulating damage totals
	if (self.attack_finished < time) {
		dprint("Wpn (");
		if (self.weapon & IT_SHOTGUN) dprint("Shotgun");
		else if (self.weapon & IT_SUPER_SHOTGUN && self.moditems & IT_UPGRADE_SSG) dprint("Shotgun Upgrade");
		else if (self.weapon & IT_SUPER_SHOTGUN) dprint("Super Shotgun");
		else if (self.weapon & IT_NAILGUN) dprint("Nail Gun");
		else if (self.weapon & IT_SUPER_NAILGUN) dprint("Super Nail Gun");
		else if (self.weapon & IT_GRENADE_LAUNCHER) dprint("Grenade Launcher");
		else if (self.weapon & IT_ROCKET_LAUNCHER) dprint("Rocket Launcher");
		else if (self.weapon & IT_LIGHTNING && self.moditems & IT_UPGRADE_LG) dprint("Lightning Upgrade");
		else if (self.weapon & IT_LIGHTNING) dprint("Lightning Gun");
		else dprint("Unknown");
		dprint(") Dist ("); lftos(self, self.enemydist, 3, 2, BUFFER_DPRINT);
		dprint(") Dmg ("); dprint(ftos(self.dmg)); 
		dprint(") % (");
		if (self.weapon & IT_SHOTGUN || self.weapon & IT_SUPER_SHOTGUN) {
			if (self.weapon & IT_SHOTGUN) self.cnt = self.dmg / 28;
			else if (self.moditems & IT_UPGRADE_SSG) self.cnt = self.dmg / 84;
			else self.cnt = self.dmg / 56;
			self.cnt = self.cnt * 100;
		} else self.cnt = 100;
		lftos(self, self.cnt, 3, 2, BUFFER_DPRINT);
		dprint(")\n");
		misc_targetdummy_trigger(self.weapon, self.noise1);
		misc_targetdummy_trigger(self.enemydist, self.noise2);
		misc_targetdummy_trigger(self.dmg, self.noise3);
		misc_targetdummy_trigger(self.cnt, self.noise4);
		self.health = self.max_health; // Reset health, damage timer and total
		self.attack_finished = LARGE_TIMER;
		self.dmg = 0;
	}
};

void(entity inflictor, entity attacker, float damage) misc_targetdummy_pain = { // [FUNCTION]
	local entity marker;

	self.pain_finished = 0; // want all damage to go through pain function, reset timer
	if (self.pain_check < time) { // Play a pain sound every second
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		self.pain_check = time + 1;
	}
	
	// If the attacker is a player, record details
	if (attacker.flags & FL_CLIENT) {
		self.weapon = attacker.weapon;
		self.items = attacker.items;
		self.moditems = attacker.moditems;
		self.enemydist = range_distance(attacker, TRUE);
	} else self.weapon = self.enemydist = 0;

	// The damage value is different depending on projectile type
	if (inflictor.classgroup == CG_PROJSHELLS) self.dmg = damage;
	else self.dmg = self.dmg + damage;
	
	self.attack_finished = time + 0.5; // reset timer for accumulating damage over time
	
	// Spawn a marker to show impact location. Will remove self after certain amount of time.
	marker = spawn();
	if (!marker) return;

	marker.classtype = CT_DEVMARKER;
	marker.movetype = MOVETYPE_NONE;
	marker.solid = SOLID_NOT;
	setmodel(marker, MODEL_IMPACT);
	marker.skin = rint(random()*7); // Randomize between 8 yellow skins
	setorigin(marker, inflictor.origin); // Take projectile impact location
	setsize (marker, VEC_ORIGIN, VEC_ORIGIN);
	marker.think = SUB_Remove;
	marker.nextthink = time + self.wait;
};

// QUAKED misc_targetdummy (0 .5 .5) (-32 -32 -24) (32 32 64) KNIGHT WIZARD OGRE HELL_KNIGHT ZOMBIE DEMON SHALRATH SHAMBLER
// ------- KEYS --------
// noise1 : Targetnumber tracking weapon used
// noise2 : Targetnumber tracking enemy distance
// noise3 : Targetnumber tracking damage
// noise4 : Targetnumber tracking % efficency
// wait   : Impact marker removal time (def=2)
// -------- SPAWNFLAGS --------
// KNIGHT      : Knight model
// WIZARD      : Wizard model
// OGRE        : Ogre model
// HELL_KNIGHT : Hell Knight model
// ZOMBIE      : Zombie model
// DEMON       : Demon model
// SHALRATH    : Shalrath model
// SHAMBLER    : Shambler model
// ------- NOTES --------
// Target practice dummy
void() misc_targetdummy = { // [ENTITY]
	if (self.spawnflags & MISC_TARGKNIGHT) {
		self.mdl = "progs/ad181/mon_knight.mdl";
		self.headmdl = "progs/ad171/targd_short.mdl";
		self.pain_sound = "knight/khurt.wav";
		self.t_width = FALSE;
		self.bboxtype = BBOX_SHORT;
		self.pos1 = '0 9 0';	// stand1-9
	} else if (self.spawnflags & MISC_TARGWIZARD) {
		self.mdl = "progs/ad171/mon_wizard.mdl";
		self.headmdl = "progs/ad171/targd_tall.mdl";
		self.pain_sound = "wizard/wpain.wav";
		self.t_width = FALSE;
		self.bboxtype = BBOX_TALL;
		self.pos1 = '0 8 0';	// hover1-8
	} else if (self.spawnflags & MISC_TARGOGRE) {
		self.mdl = "progs/ogre.mdl";
		self.headmdl = "progs/ad171/targd_wide.mdl";
		self.pain_sound = "ogre/ogpain1.wav";
		self.t_width = TRUE;
		self.bboxtype = BBOX_WIDE;
		self.pos1 = '0 9 0';	// stand1-9
	} else if (self.spawnflags & MISC_TARGHELLKNIGHT) {
		self.mdl = "progs/qmaster/mon_hknight.mdl";
		self.headmdl = "progs/ad171/targd_tall.mdl";
		self.pain_sound = "hknight/pain1.wav";
		self.t_width = FALSE;
		self.bboxtype = BBOX_TALL;
		self.pos1 = '0 9 0';	// stand1-9
	} else if (self.spawnflags & MISC_TARGZOMBIE) {
		self.mdl = "progs/ad171/mon_zombie.mdl";
		self.headmdl = "progs/ad171/targd_short.mdl";
		self.pain_sound = "zombie/z_pain.wav";
		self.t_width = FALSE;
		self.bboxtype = BBOX_SHORT;
		self.pos1 = '0 15 0';	// stand 1-15
	} else if (self.spawnflags & MISC_TARGDEMON) {
		self.mdl = "progs/demon.mdl";
		self.headmdl = "progs/ad171/targd_wide.mdl";
		self.pain_sound = "demon/dpain1.wav";
		self.t_width = TRUE;
		self.bboxtype = BBOX_WIDE;
		self.pos1 = '0 13 0';	// stand 1-13
	} else if (self.spawnflags & MISC_TARGSHALRATH) {
		self.mdl = "progs/ad171/mon_shalrath.mdl";
		self.headmdl = "progs/ad171/targd_wide.mdl";
		self.pain_sound = "shalrath/pain.wav";
		self.t_width = TRUE;
		self.bboxtype = BBOX_WIDE;
		self.pos1 = '0 1 0';	// stand 1
	} else if (self.spawnflags & MISC_TARGSHAMBLER) {
		self.mdl = "progs/shambler.mdl";
		self.headmdl = "progs/ad171/targd_massive.mdl";
		self.pain_sound = "shambler/shurt2.wav";
		self.t_width = FALSE;
		self.bboxtype = BBOX_MASSIVE;
		self.pos1 = '0 17 0';	// stand1-17
		self.resist_rockets = 0.5;
	} else { remove(self); return; }
	
	precache_model (self.mdl);
	precache_model (self.headmdl);
	precache_sound(self.pain_sound);
	precache_model (MODEL_IMPACT);			// Impact model marker
	self.classtype = CT_TARGETDUMMY;
	self.classgroup = CG_MONSTERS;
	self.health = self.max_health = 100000;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	self.movespeed = 0;					// Never move monster
	if (self.wait < 1) self.wait = 2;	// impact marker removal time
	self.pain_finished = 0;				// Always reset this
	self.pain_flinch = 1;				// Always pass flinch test
	self.dmg = 0;						// Accumulated damage per frame
	self.attack_finished = LARGE_TIMER;	// Reset timer for checks
	self.view_ofs = '0 0 24';			// Default monster offset
	self.takedamage = DAMAGE_AIM;		// Always take damage
	monster_bbox();						// Setup bounding box
	setmodel(self, self.mdl);			// Display model
	setsize (self, self.bbmins, self.bbmaxs);	// Update bbox
	
	// Spawn projectile bounding box visual marker
	self.attachment = spawn();
	self.attachment.solid = SOLID_NOT;
	self.attachment.movetype = MOVETYPE_NONE;
	setmodel(self.attachment, self.headmdl);
	setorigin(self.attachment, self.origin-self.view_ofs);
	self.attachment.alpha = 0.3;

	// Spawn Hull2 bounding box visual marker
	if (self.t_width) {
		self.noise = "progs/ad171/targd_hull2.mdl";
		precache_model(self.noise);
		self.attachment2 = spawn();
		self.attachment2.solid = SOLID_NOT;
		self.attachment2.movetype = MOVETYPE_NONE;
		setmodel(self.attachment2, self.noise);
		setorigin(self.attachment2, self.origin-self.view_ofs);
		self.attachment2.alpha = 0.15;
	}
	
	// Intercept all AI states
	self.th_pain = misc_targetdummy_pain;
	self.th_stand = misc_targetdummy_stand;
	self.th_walk = misc_targetdummy_stand;
	self.th_run = misc_targetdummy_stand;
	self.th_melee = misc_targetdummy_stand;

	self.think = self.th_stand; // Stand around and wait for the pain!
	self.nextthink = time + 0.5 + random();
};

void() misc_targetnumber_dispno = { // [FUNCTION]
	local float str_counter, str_pow, str_result, str_low;
	
	str_counter = self.pos1_x;		// Upper number length
	str_pow = mathlib_powbit(self.pos1_x,10);// Setup initial base 10 power for checking
	self.count = fabs(self.count); // Get rid of negative state
	if (self.count > str_pow) self.count = mathlib_truncate(self.count, self.pos1_x, self.pos1_y); // If number larger than fixed length? - truncate number
	
	// Loop through lower part of number
	while(str_counter > 0) {
		str_pow = str_pow / 10; // Move down one pow digit
		str_result = mathlib_divisible(self.count, str_pow); // Divide number by pow to get divider
		if (str_result > 9) str_result = 9; // Result must be 0-9 digits
		if (str_result < 1) str_result = 0;
		if (str_counter == 4) self.tno8.skin = str_result;
		else if (str_counter == 3) self.tno7.skin = str_result;
		else if (str_counter == 2) self.tno6.skin = str_result;
		else if (str_counter == 1) self.tno5.skin = str_result;

		self.count = self.count - (str_result * str_pow); // remove top part of number, decrease str length counter
		str_counter = str_counter - 1;
	}
	
	// Shift the lower part of the number upwards
	str_low = str_counter = self.pos1_y;
	str_pow = mathlib_powbit(self.pos1_y,10);
	while (str_low > 0) {
		self.count = self.count * 10;
		str_low = str_low - 1;
	}
	
	// Loop through lower part of number
	while(str_counter > 0) {
		str_pow = str_pow / 10; // Move down one pow digit
		str_result = mathlib_divisible(self.count, str_pow); // Divide number by pow to get divider
		if (str_result > 9) str_result = 9; // Result must be 0-9 digits
		if (str_result < 1) str_result = 0;
		if (str_counter == 3) self.tno3.skin = str_result;
		else if (str_counter == 2) self.tno2.skin = str_result;
		else if (str_counter == 1) self.tno1.skin = str_result;
		
		self.count = self.count - (str_result * str_pow); // remove top part of number, decrease str length counter
		str_counter = str_counter - 1;
	}
};

void() misc_targetnumber_use = { // [FUNCTION]
	self.count = fabs(other.targetnumber); // No negative numbers
	misc_targetnumber_dispno();
};

entity(float offset, float startno) misc_targetnumber_spawn = { // [FUNCTION]
	local entity tnoent;
	tnoent = spawn();
	tnoent.classtype = CT_TARGETNUMBER;
	tnoent.solid = SOLID_NOT;
	tnoent.movetype = MOVETYPE_NONE;
	makevectors(self.angles);
	setmodel(tnoent, self.mdl);
	setorigin(tnoent, self.origin + (v_right * (self.waitmin * offset)) );
	setsize(tnoent, VEC_ORIGIN, VEC_ORIGIN);
	tnoent.skin = startno;
	tnoent.angles = self.angles;
	return tnoent;
};

// QUAKED misc_targetnumber (.5 .5 0) (-4 -4 -8) (4 4 8) x
// ------- KEYS --------
// targetname : required for numbers to updated
// mdl        : Numbers 0-9,dot,blank (def=progs/ad171/misc_digit.mdl)
// waitmin    : Spacing of the model numbers (def=8)
// cnt        : Initial display value on spawn (must be >0)
// pos1       : X= top digit quantity, Y=Lower digit quantity
// -------- SPAWNFLAGS --------
// ------- NOTES --------
// target number to display ingame
void() misc_targetnumber = { // [ENTITY]
	if (self.mdl == "") self.mdl = "progs/ad171/misc_digit.mdl";
	precache_model (self.mdl);
	self.classtype = CT_TARGETNUMBER;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (self.waitmin <= 0) self.waitmin = 8;
	if (self.cnt > 0) self.count = self.cnt;
	
	// Double check digit quantities are within range
	if (self.pos1_x > 4 || self.pos1_y > 3) {
		dprint("\b[MISCNUM]\b pos1 limited to '4 3 0'\n");
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
	}
	
	// Setup lower part of number (1-3 decimal places, 4=dot always)
	if (self.pos1_y > 0) {
		if (self.pos1_y == 1) self.tno1 = misc_targetnumber_spawn(0, 0);
		else if (self.pos1_y == 2) {
			self.tno1 = misc_targetnumber_spawn(0, 0);
			self.tno2 = misc_targetnumber_spawn(1, 0);
		} else {
			self.pos1_y = 3;
			self.tno1 = misc_targetnumber_spawn(0, 0);
			self.tno2 = misc_targetnumber_spawn(1, 0);
			self.tno3 = misc_targetnumber_spawn(2, 0);
		}
		// Decimal place is always tno4
		self.tno4 = misc_targetnumber_spawn(self.pos1_y, 10);
		self.pos1_z = self.pos1_y +1;
	} else self.pos1_z = 0;
	
	// Setup upper part of number (1-4 digits only, min 1 digit)
	if (self.pos1_x < 1) self.pos1_x = 1;
	if (self.pos1_x == 1) self.tno5 = misc_targetnumber_spawn(self.pos1_z, 0);
	else if (self.pos1_x == 2) {
		self.tno5 = misc_targetnumber_spawn(self.pos1_z, 0);
		self.tno6 = misc_targetnumber_spawn(self.pos1_z+1, 0);
	} else if (self.pos1_x == 3) {
		self.tno5 = misc_targetnumber_spawn(self.pos1_z, 0);
		self.tno6 = misc_targetnumber_spawn(self.pos1_z+1, 0);
		self.tno7 = misc_targetnumber_spawn(self.pos1_z+2, 0);
	} else {
		self.pos1_x = 4;
		self.tno5 = misc_targetnumber_spawn(self.pos1_z, 0);
		self.tno6 = misc_targetnumber_spawn(self.pos1_z+1, 0);
		self.tno7 = misc_targetnumber_spawn(self.pos1_z+2, 0);
		self.tno8 = misc_targetnumber_spawn(self.pos1_z+3, 0);
	}
	
	if (self.targetname != "") self.use = misc_targetnumber_use; // Setup trigger function for number update
	if (self.cnt > 0) misc_targetnumber_dispno(); // Update initial value (no external source)
};