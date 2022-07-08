//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Vigil by Wright Bagwell (MrBunyan on IRC, Paul_Bunyan on Quake)
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
// Function count: 2
//
// Implements: Vigil Mappack Features
//
// Description:
// A dead player corpse, an intermission actor, and trigger_vigend which is the
// main item of interest here since it lets you do a custom congratulations
// screen for map end.
// 
// Vigil prevented cheating yourself quad, but not much else.  I already have
// func_rubble elsewhere which was also added in Vigil.  The thunder triggers
// are done elsewhere too.
//
// Not inculded but noting this here:
// This was in weapons.qc under impulse stuff:
// if (self.impulse == MOVETYPE_FLYMISSILE) centerprint(self, "This is no place
//  for cheating");
// ...
// if (self.impulse == 255) centerprint(self, "This is no place for cheating");
//=============================================================================

void() misc_deadplayer = { // [ENTITY]
	precache_model(MODEL_PLAYER);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self,MODEL_PLAYER);
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!self.frame) self.frame = 93;
	if (CheckZeroVector(self.pos1)) self.angles = '0 90 180';
};

void() spawnmartin = { // [FUNCTION]
	local entity m;

	spawn_tfog(self.pos1);
	m = spawn();
	setmodel(m, "progs/player.mdl");
	setorigin(m, self.pos1);
	m.angles = self.pos2;
	m.frame = self.cnt;
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL,self.message);
	self.nextthink = time + FL_SWIM;
	remove(self);
};

void() vigtrig = { // [FUNCTION]
	local entity n, pos, pl, timer;

	intermission_exittime = time + 10000000;
	intermission_running = 1;
	pos = find(world, classname, "info_intermission");
	pl = find(world, classname, "player");
	while (pl != world) {
		pl.view_ofs = VEC_ORIGIN;
		pl.angles = other.v_angle = pos.mangle;
		pl.fixangle = 1;
		pl.map = self.map;
		pl.nextthink = time + 0.5;
		pl.takedamage = DAMAGE_NO;
		pl.solid = SOLID_NOT;
		pl.movetype = MOVETYPE_NONE;
		pl.modelindex = 0;
		setorigin(pl,pos.origin);
		pl = find(pl,classname,"player");
	}
	n = spawn();
	setmodel(n,"progs/player.mdl");
	setorigin(n,self.mangle);
	n.angles = '0 10 0';
	n.frame = 13;
	WriteByte(MSG_ALL,SVC_FINALE);
	WriteString(MSG_ALL,self.message);
	timer = spawn();
	timer.nextthink = time + self.delay;
	timer.think = spawnmartin;
	timer.cnt = self.cnt;
	timer.pos2 = self.pos2;
	if (CheckZeroVector(self.pos1)) timer.pos1 = '-1532 64 -1124';
	timer.message = self.message2;
	if (HasTargets(self)) SUB_UseTargets();
};

void() trigger_vigend = { // [ENTITY]
	precache_model("progs/player.mdl");
	if (CheckZeroVector(self.mangle)) self.mangle = '-1532 0 -1124';
	if (!self.message) self.message = "Congratulations soldier. You have\nsingle-handedly kicked the asses of the\nenemies that killed your best friend.\nWright Bagwell salutes you.  Oh yeah,\nI guess I promised to bring him back to\nlife...";
	if (!self.message2) self.message2 = "You are united once again\n and ready to gib all that stands\nin your way.";
	self.use = vigtrig;
	if (!self.delay) self.delay = 28;
	if (!self.cnt) self.cnt = 14;
	if (CheckZeroVector(self.pos2)) self.pos2 = '0 330 0';
};