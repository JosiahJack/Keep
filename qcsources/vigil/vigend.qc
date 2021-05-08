void() spawnmartin = 
{
	local entity m;
	local vector o;
	o = '-1532 64 -1116';
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, o_x);
	WriteCoord(MSG_BROADCAST, o_y);
	WriteCoord(MSG_BROADCAST, o_z);
	sound(m, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
	m = spawn();
	setmodel(m, "progs/player.mdl");
	setorigin(m, '-1532 64 -1124');
	m.angles = '0 330 0';
	m.frame = 14;
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, "You are united once again\n and ready to gib all that stands\nin your way.");
	self.nextthink = time + FL_SWIM;
	remove(self);
};

void() vigtrig = 
{
	local entity n;
	local entity pos;
	local entity pl;
	local entity deadguy;
	local entity timer;
	intermission_exittime = time + 10000000;
	intermission_running = 1;
	pos = find(world, classname, "info_intermission");
	if (!pos)
	{
		error("no info_intermission");
	}
	pl = find(world, classname, "player");
	while (pl != world)
	{
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
	setorigin(n, '-1532 0 -1124');
	n.angles = '0 10 0';
	n.frame = 13;
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, "Congratulations soldier. You have\nsingle-handedly kicked the asses of the\nenemies that killed your best friend.\nWright Bagwell salutes you.  Oh yeah,\nI guess I promised to bring him back to\nlife...");
	timer = spawn();
	timer.nextthink = time + SVC_FOUNDSECRET;
	timer.think = spawnmartin;
};

void() trigger_vigend = 
{
	self.use = vigtrig;
};

