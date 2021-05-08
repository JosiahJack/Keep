
void () dancer_lights =
{
	if ((self.skin != 0))
		self.skin = 0;
	else
	{
		self.warp_factor = (self.warp_factor + 1);
		if ((self.warp_factor > 4))
			self.warp_factor = 1;
		self.skin = self.warp_factor;
	}
};

void () f_dancer1 = [ 0, f_dancer2 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer2 = [ 1, f_dancer3 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer3 = [ 2, f_dancer4 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer4 = [ 3, f_dancer5 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer5 = [ 4, f_dancer6 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer6 = [ 5, f_dancer7 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer7 = [ 6, f_dancer8 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer8 = [ 7, f_dancer9 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer9 = [ 8, f_dancer10 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer10 = [ 9, f_dancer11 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer11 = [ 10, f_dancer12 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer12 = [ 11, f_dancer13 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer13 = [ 12, f_dancer14 ]
{
	self.nextthink = (time + 0.05);
	dancer_lights ();
};

void () f_dancer14 = [ 13, f_dancer15 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer15 = [ 14, f_dancer16 ]
{
	self.nextthink = (time + 0.05);
};

void () f_dancer16 = [ 15, f_dancer1 ]
{
	self.nextthink = (time + 0.05);
	self.angles_y = (self.angles_y + 30);
	dancer_lights ();
};


void () become_merc =
{
	sound (self, CHAN_BODY, "mercbabe/scream.wav", 1.00, ATTN_NORM);
	if (deathmatch)
	{
		remove (self);
		return;
	}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/mercbabe.mdl");
	setsize (self, VEC_HULL_MIN, '16 16 40');
	self.health = 100;
	dealwithskill ();
	self.skin = 0;
	self.th_stand = merc_stand;
	self.th_walk = merc_walk1;
	self.th_run = merc_run1;
	self.th_missile = merc_shoot;
	self.th_pain = merc_pain;
	self.th_die = merc_die;
	self.th_melee = merc_mel1;
	walkmonster_start ();
};


void () dancer =
{
	precache_model ("progs/dancer.mdl");
	precache_model ("progs/mercbabe.mdl");
	precache_model ("progs/h_merc.mdl");
	precache_sound ("mercbabe/death1.wav");
	precache_sound ("mercbabe/idle.wav");
	precache_sound ("mercbabe/pain1.wav");
	precache_sound ("mercbabe/pain2.wav");
	precache_sound ("mercbabe/pain3.wav");
	precache_sound ("weapons/shot1.wav");
	precache_sound ("mercbabe/sight1.wav");
	precache_sound ("mercbabe/scream.wav");
	setmodel (self, "progs/dancer.mdl");
	self.classname = "dancer";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BBOX;
	self.takedamage = DAMAGE_YES;
	if (deathmatch)
		self.health = 99999;
	else
		self.health = 1;
	self.th_die = become_merc;
	setsize (self, VEC_HULL2_MIN, '32 32 40');
	droptofloor (0, 0);
	f_dancer1 ();
};

