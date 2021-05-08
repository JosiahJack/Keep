/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

float modelindex_hover;
float modelindex_scuba;
float modelindex_bag;
void (entity head7) Enolagay;
void () AtomSmash;
void () ionstorm;

void (float limit) W_FireBigassGun =
{
	local entity pulse;
	local entity body;

	self.punchangle_x = -4;
	pulse = spawn ();
	pulse.owner = self;
	pulse.classname = "AtomSmasher";
	pulse.movetype = MOVETYPE_FLYMISSILE;
	pulse.solid = SOLID_BBOX;
	makevectors (self.v_angle);
	pulse.velocity = aim (self, 1000);
	pulse.velocity = pulse.velocity * 800;
	pulse.angles = vectoangles (pulse.velocity);
	pulse.avelocity = '0 0 250';
	pulse.touch = AtomSmash;
	pulse.effects = EF_DIMLIGHT;
	pulse.nextthink = time;
	pulse.think = ionstorm;
	setmodel (pulse, "progs/null.spr");
	setsize (pulse, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (pulse, self.origin + (v_forward * 22) + '0 0 18');
	sound (self, CHAN_WEAPON, "misc/discharg.wav", 1.00, ATTN_NORM);
	serverflags = serverflags / 2;
	if (!(serverflags & 15))
	{
		self.tools = self.tools - (self.tools & UT_BIGASSGUN);
		body = find (world, netname, "Atom Smasher");
		if ((body != world) && deathmatch)
		{
			body.think = SUB_regen;
			body.nextthink = time + 120;
		}
		W_SetCurrentAmmo ();
		if ((self.tools == (self.tools | UT_SCUBA)) && (self.flags & FL_INWATER))
			self.modelindex = modelindex_scuba;
		else
			self.modelindex = modelindex_player;
	}
	self.velocity = self.velocity - (aim (self, 1.00) * 1000);
};


void () ionstorm =
{
	makevectors (self.angles);
	particle (self.origin + (v_right * 50), v_right * -200, 228, 20);
	particle (self.origin + (v_right * -50), v_right * 200, 228, 20);
	particle (self.origin + (v_up * 50), v_up * -200, 228, 20);
	particle (self.origin + (v_up * -50), v_up * 200, 228, 20);
	self.nextthink = time;
};


void () blow_baby =
{
	if (self.frame == 23)
		remove (self);
	else
		self.frame = self.frame + 1;
	self.nextthink = time;
};


void (entity victim) BreakDown =
{
	
	local float intensity;

	sound (victim, CHAN_WEAPON, "misc/thud.wav", 1.00, ATTN_NORM);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, victim.origin_x);
	WriteCoord (MSG_BROADCAST, victim.origin_y);
	WriteCoord (MSG_BROADCAST, victim.origin_z - 50);
	intensity = (self.owner.atomic_intensity * 300);
	T_Damage (victim, self, self.owner, intensity);
};


void () AtomSmash =
{
	local entity victim;
	local vector attack_vec;

	if (pointcontents (self.origin) == CONTENT_SKY)
	{
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "misc/thud.wav", 1.00, ATTN_NORM);
	if (self.owner.classname == "player")
	{
		self.owner.warp_factor = 1;
		Enolagay (self.owner);
	}
	victim = findradius (self.origin, 800);
	while (victim)
	{
		if (victim.takedamage && (victim != self.owner))
		{
			traceline (self.origin, victim.origin, TRUE, self);
			if (trace_fraction == 1)
				BreakDown (victim);
			if (victim.classname == "player")
			{
				victim.warp_factor = 1;
				Enolagay (victim);
			}
		}
		victim = victim.chain;
	}
	if ((self.classname != "player"))
	{
		self.think = SUB_Remove;
		self.nextthink = time;
	}
};


void () OverLoad =
{
	local entity victim;
	local vector attack_vec;

	T_RadiusDamage (self, self, 2000, world);
	sound (self, CHAN_WEAPON, "misc/ion.wav", 1.00, ATTN_NORM);
	victim = findradius (self.origin, 800);
	while (victim)
	{
		if (victim.takedamage && (victim != self))
		{
			traceline (self.origin, victim.origin, TRUE, self);
			if (trace_fraction == 1)
				BreakDown (victim);
			if (victim.classname == "player")
			{
				victim.warp_factor = 1;
				Enolagay (victim);
			}
		}
		victim = victim.chain;
	}
};

