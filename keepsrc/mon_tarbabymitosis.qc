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
// Function count: 2
//
// Implements: Mitosis Spawn
//
// Description:
// A green gelatinous blob that splits into two.  Otherwise just like a normal
// spawn and explodes on death.
//=============================================================================

void() tbaby_checknew;

void(entity inflictor, entity attacker, float damage) tbaby_mitosis = { // [FUNCTION]
	local entity newSpawn;
	
	if ( random() < 0.35 ) {
		newSpawn = spawn();
		newSpawn.classname = self.classname;
		newSpawn.movetype = MOVETYPE_STEP;
		setsize (newSpawn, '-16 -16 -24', '16 16 40');
		newSpawn.health = 100;
		newSpawn.owner = self;
		self.th_pain = SUB_Null_pain;
		setmodel (newSpawn, self.owner.mdl);
		newSpawn.solid = SOLID_SLIDEBOX;
		newSpawn.skin = self.skin;
		setorigin (newSpawn, self.origin);              
		newSpawn.think = tbaby_checknew;
		newSpawn.nextthink = time + 0.5;
        sound (newSpawn, CHAN_VOICE, "rogue/blob/mytosis.wav", 1, ATTN_NORM);
	}
};

void() tbaby_checknew = { // [FUNCTION]
	if (!walkmove(0,0)) { remove(self); return; }
	
	self.enemy = self.enemy;
	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_jump = tbaby_jump1;
	self.th_jumpexit = tbaby_jump5;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;      
	self.th_pain = tbaby_pain;
	self.classtype = CT_MONSPAWN;
	self.classgroup = CG_SPAWN;
	self.classmove = MON_MOVEWALK;
	self.takedamage = DAMAGE_AIM;
	self.death_sound = "blob/death1.wav";
	self.idle_sound = "blob/sight1.wav";
	self.sight_sound = self.idle_sound;
	self.pain_sound = self.idle_sound;
	self.origin_z = self.origin_z + 1; // raise off floor a bit
	droptofloor();

	if (!walkmove(0,0)) { self.owner.th_pain = tbaby_mitosis; remove(self); return; }

	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed) self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;
	if (self.deathstring == "") self.deathstring = " was slimed by a Fresh Spawn\n";
	self.pausetime = 99999999;
	self.think = self.th_stand;
	self.nextthink = self.nextthink + random()*0.5;
	AddToTotals(self);
};

void() monster_tarbaby_mitosis = { // [ENTITY]
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/qmaster/mon_tarbaby.mdl";
	self.headmdl = "";
	self.idle_sound = "blob/sight1.wav";
	self.sight_sound = self.idle_sound;
	self.pain_sound = self.idle_sound;
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 100;
	if (self.skin < 0) self.skin = 1;
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	self.gibbed = FALSE;
	self.pain_flinch = 20;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.deathstring == "") self.deathstring = " was slimed by a Mitosis Spawn\n";
	if (self.minion_name == "") {
		self.minion_name = "monster_tarbaby";
        self.minion_spawn_time = self.minion_spawn_time | MONANIM_SPECIAL;
    }
	self.th_checkattack = SpawnCheckAttack;
	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_jump = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_pain = tbaby_mitosis;
	self.th_die = tbaby_die;
	self.classtype = CT_MONSPAWN;
	self.classgroup = CG_SPAWN;
	self.classmove = MON_MOVEWALK;
	monster_start();
};