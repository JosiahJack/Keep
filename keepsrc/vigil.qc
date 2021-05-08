// Stuff from Vigil by Wright Bagwell (MrBunyan on IRC, Paul_Bunyan on Quake)

void() misc_deadplayer = {
	precache_model("progs/player.mdl");
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/player.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!self.frame) self.frame = 93;
	if (CheckZeroVector(self.pos1)) self.angles = '0 90 180';
};

void() spawnmartin = {
	local entity m;

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, self.pos1_x);
	WriteCoord(MSG_BROADCAST, self.pos1_y);
	WriteCoord(MSG_BROADCAST, self.pos1_z);
	sound(self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
	m = spawn();
	setmodel(m, "progs/player.mdl");
	setorigin(m, self.pos1);
	m.angles = self.pos2;
	m.frame = self.cnt;
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL,self.message);
	// WriteString(MSG_ALL, "You are united once again\n and ready to gib all that stands\nin your way.");
	self.nextthink = time + FL_SWIM;
	remove(self);
};

void() vigtrig = {
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
		setorigin(pl, pos.origin);
		pl = find(pl, classname, "player");
	}
	n = spawn();
	setmodel(n, "progs/player.mdl");
	setorigin(n, self.mangle);
	n.angles = '0 10 0';
	n.frame = 13;
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, self.message);
	//WriteString(MSG_ALL, "Congratulations soldier. You have\nsingle-handedly kicked the asses of the\nenemies that killed your best friend.\nWright Bagwell salutes you.  Oh yeah,\nI guess I promised to bring him back to\nlife...");
	timer = spawn();
	timer.nextthink = time + self.delay;
	timer.think = spawnmartin;
	timer.cnt = self.cnt;
	timer.pos2 = self.pos2;
	if (CheckZeroVector(self.pos1)) timer.pos1 = '-1532 64 -1124';
	timer.message = self.message2;
	if (self.target) SUB_UseTargets();
};

void() trigger_vigend = {
	precache_model("progs/player.mdl");
	if (CheckZeroVector(self.mangle)) self.mangle = '-1532 0 -1124';
	if (!self.message) self.message = "Congratulations soldier. You have\nsingle-handedly kicked the asses of the\nenemies that killed your best friend.\nWright Bagwell salutes you.  Oh yeah,\nI guess I promised to bring him back to\nlife...";
	if (!self.message2) self.message2 = "You are united once again\n and ready to gib all that stands\nin your way.";
	self.use = vigtrig;
	if (!self.delay) self.delay = 28;
	if (!self.cnt) self.cnt = 14;
	if (CheckZeroVector(self.pos2)) self.pos2 = '0 330 0';
};

// NOTEs:
// Vigil prevented cheating yourself quad, but not much else.
// I already have func_rubble elsewhere.  The thunder triggers are done elsewhere too.
// This was in weapons.qc under impulse stuff:
	// if (self.impulse == MOVETYPE_FLYMISSILE)
	// {
		// centerprint(self, "This is no place for cheating");
	// }
//...
	// if (self.impulse == 255)
	// {
		// centerprint(self, "This is no place for cheating");
	// }