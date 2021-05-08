void() Asha_PreCache = 
{
	precache_model("progs/v_asha.mdl");
	precache_sound2("misc/power.wav");
	precache_sound2("misc/tesla.wav");
};

void() TraceExplosion = 
{
	T_RadiusDamage(self, self.owner, 60, self.enemy);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.nextthink = time;
	self.think = BecomeExplosion;
};

void(float shotcount, vector dir, vector spread) TraceExploAttack = 
{
	local vector vel;
	local vector src;
	local vector bdest;
	local vector direction;
	local entity bomb;
	makevectors(self.v_angle);
	src = self.origin + v_forward * MOVETYPE_BOUNCE;
	src_z = self.absmin_z + self.size_z * 0.7;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, src_x);
	WriteCoord(MSG_BROADCAST, src_y);
	WriteCoord(MSG_BROADCAST, src_z);
	self.velocity = self.velocity - v_forward * 300;
	ClearMultiDamage();
	while (shotcount)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;
		traceline(src, src + direction * FL_WATERJUMP, 0, self);
		if (trace_fraction == 1)
		{
			return;
		}
		bdest = trace_endpos - dir * MOVETYPE_STEP;
		if (trace_ent.takedamage)
		{
			AddMultiDamage(trace_ent, 80);
		}
		bomb = spawn();
		setmodel(bomb, "");
		setorigin(bomb, bdest);
		bomb.owner = self;
		bomb.enemy = trace_ent;
		bomb.nextthink = time + 0.1;
		bomb.think = TraceExplosion;
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage();
};

void() W_FireAsha = 
{
	local vector dir;
	if (self.ashacharge > self.ammo_cells)
	{
		self.ashacharge = self.ammo_cells;
	}
	makevectors(self.v_angle);
	dir = v_forward;
	sound(self, CHAN_WEAPON, "misc/power.wav", 1, ATTN_NORM);
	if (!(self.ashamode))
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - self.ashacharge;
		self.punchangle_x = crandom() * (FL_SWIM * self.cnt);
		self.punchangle_y = crandom() * (FL_SWIM * self.cnt);
		self.punchangle_z = crandom() * (FL_SWIM * self.cnt);
		TraceExploAttack(self.ashacharge, dir, '0.160000 0.080000 0');
	}
	else
	{
		self.currentammo = self.ammo_cells = self.ammo_cells - 1;
		self.punchangle_x = crandom() * FL_SWIM;
		self.punchangle_y = crandom() * FL_SWIM;
		self.punchangle_z = crandom() * FL_SWIM;
		TraceExploAttack(1, dir, '0.120000 0.060000 0');
	}
	self.weaponframe = 0;
	self.cnt = 0;
};

void() weapon_antishambler = 
{
	precache_model("progs/g_asha.mdl");
	setmodel(self, "progs/g_asha.mdl");
	self.weapon = MOVETYPE_WALK;
	self.classname = "weapon_antishambler";
	self.netname = "Anti-Matter Cannon!";
	self.touch = weapon_touch;
	self.cnt = 0;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

