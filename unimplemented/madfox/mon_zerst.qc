// The Zerstörer!!

void() Z_idle = {
	self.frame = self.frame + 1;
	self.cnt = self.cnt + 1;

	if (self.frame >= 20)
		self.frame = 0;
	if (self.cnt > 40)
		self.cnt = 0;

	if (self.cnt < 20)
		setorigin(self, self.origin + '0 0 1');
	else
		setorigin(self, self.origin - '0 0 1');

	self.think = Z_idle;
	self.nextthink = time + 0.1;
};


void() zer_awake = {
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLY;
	setsize (self, '-16 -16 -24', '16 16 54');
	setorigin(self, self.origin);
	setmodel (self, "progs/madfox/mon_zerstorer.mdl");
	self.think = Z_idle;
	self.nextthink = time + 0.1;

	sound (self, CHAN_AUTO, "boss1/out1.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, (self.origin_z - 8));	
};

/*QUAKED monster_zer (1 0 0) (-128 -128 -24) (128 128 256)
*/
void() monster_zer = {
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	precache_model ("progs/madfox/mon_zerstorer.mdl");
	precache_sound ("boss1/out1.wav");

	if (self.deathstring == "") self.deathstring = " was destroyed by the Zerstörer\n";

	// Check passive system for exceptions
	setup_passivestatev(self);

	self.use = zer_awake;
};
void() monster_zerstorer = {self.classname = "monster_zer"; monster_zer(); };

//=========================================================================
/* Finale explosive stuff */

void() do_lavasplash = {
	if (self.pain_finished < time) {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		SUB_UseTargets ();
		self.pain_finished = time + self.wait; // prevent spamming splash effects
	}
};

// keeping for legacy compat
void() func_lavasplash = {
	self.use = do_lavasplash;
	if (self.wait <= 0) self.wait = 1.00; 
	self.pain_finished = time + self.wait;
};

void() func_explode = {
	if (self.netname == "") self.netname = "monster_zer"; // Protect the zerstorer from explosion effects
	func_exploder();
};