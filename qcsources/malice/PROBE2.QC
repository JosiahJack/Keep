/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void (entity place) BlowProbe =
{
	local entity probe;

	probe = spawn ();
	probe.movetype = MOVETYPE_TOSS;
	probe.solid = SOLID_NOT;
	setmodel (probe, "progs/probe.mdl");
	probe.angles = place.angles;
	setsize (probe, '-10 -10 -10', '10 10 10');
	setorigin (probe, place.origin);
	probe.frame = 1;
	probe.nextthink = (time + 20);
	probe.think = SUB_Remove;
	probe.avelocity = '800 0 -800';
};


void (entity striker,float heebie) return2sender =
{
	local entity temp;

	BlowProbe (striker);
	setmodel (striker, "progs/player.mdl");
	setsize (striker, VEC_HULL_MIN, VEC_HULL_MAX);
	if (!(self.speed & CHSCAM_ON))
		striker.weaponmodel = striker.weapon2;
	stuffcmd (striker, "cl_bob 0.01\n");
	if (striker.burning == TRUE)
		stuffcmd (striker, "v_cshift 250 50 0 100\n");
	else
		stuffcmd (striker, "v_cshift 0\n");
	striker.probe_active = FALSE;
	striker.movetype = MOVETYPE_WALK;
	striker.flags = (striker.flags - (striker.flags & FL_NOTARGET));
	stuffcmd (striker, "fov 90\n");
	stuffcmd (striker, "clear\n");
	active_probes = (active_probes - 1);
	sound (striker, CHAN_VOICE, "misc/glass1.wav", 1.00, ATTN_NORM);
	temp = world;
	while (temp.holo_owner != striker)
	{
		temp = find (temp, classname, "hologram");
		setorigin (striker, temp.origin);
	}
	remove (temp);
	makevectors (striker.angles);
	striker.angles = striker.old_angles;
	striker.angles_x = 0;
	striker.angles_z = 0;
	striker.fixangle = TRUE;
	if (heebie > 0)
		T_Damage (striker, striker, striker, heebie);
};


float () CheckSpot =
{
	local entity spot;

	spot = spawn ();
	spot.movetype = MOVETYPE_NONE;
	spot.solid = SOLID_NOT;
	setmodel (spot, "progs/spike.mdl");
	spot.model = string_null;
	setsize (spot, VEC_ORIGIN, VEC_ORIGIN);
	makevectors (self.v_angle);
	setorigin (spot, (self.origin + (v_forward * 100)));
	if (pointcontents(spot.origin) == CONTENT_SOLID)
		return (TRUE);
	else
		return (FALSE);
};


void () probe_physics =
{
	if (self.button0 == 1)
	{
		makevectors (self.v_angle);
		self.velocity = aim (self, 1.00);
		self.velocity = (self.velocity * CHT_HOVERSPEED);
		self.movetype = MOVETYPE_TOSS;	// ACC, fixes a bug in modern ports (QuakeSpasm & DarkPlaces)
		if (self.button2 == 1)
			self.velocity_z = 275;
	}
	else
	{
		if (self.button2 == 1)
			self.velocity_z = 275;
		else
		{
			makevectors (self.v_angle);
			self.velocity = aim (self, 1.00);
			self.velocity = (self.velocity * 1.00);
			self.movetype = MOVETYPE_FLY;	// ACC, fixes a bug in modern ports (QuakeSpasm & DarkPlaces)
		}
	}
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (self.probe_sound < time)
	{
		if (random () < 0.5)
			sound (self, CHAN_VOICE, "utils/receive.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "utils/send.wav", 1.00, ATTN_NORM);
		self.probe_sound = time + (random () * 5.00);
	}
};


void () holo_die =
{
	self.holo_owner.angles = self.holo_owner.old_angles;
	return2sender (self.holo_owner, self.health);
};


void () HoloThink =
{
	if (self.frame == 16)
		self.frame = 13;
	else
		self.frame = self.frame + 1;
	self.nextthink = time + 0.12;
};


void () LaunchProbe =
{
	if (self.probe_active == TRUE)
	{
		return2sender (self, 0);
		self.probe_active = FALSE;
		self.angles = self.old_angles;
		return;
	}
	if (CheckSpot ())
	{
		sprint (self, "Bad launch trajectory\n");
		return;
	}
	if ((self.flags != (self.flags | FL_ONGROUND)) || (self.flags == (self.flags | FL_INWATER)))
	{
		sprint (self, "Unstable launch platform\n");
		return;
	}
	self.weapon2 = self.weaponmodel;
	self.weaponmodel = "";
	stuffcmd (self, "cl_bob 0\n");
	stuffcmd (self, "v_cshift 200 0 0 100\n");
	active_probes = (active_probes + 1);
	makevectors (self.v_angle);
	self.angles_z = 0;
	self.v_angle_z = 0;
	self.fixangle = TRUE;
	self.super_time = 0.00;
	makevectors (self.angles);
	self.probe_active = TRUE;
	self.old_position = self.origin;
	self.old_angles = self.angles;
	self.movetype = MOVETYPE_FLY;
	self.flags = (self.flags | FL_NOTARGET);
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.origin = (self.origin + (v_forward * 40));
	self.probe_sound = time;
	stuffcmd (self, "fov 120\n");
	hologram = spawn ();
	hologram.holo_owner = self;
	hologram.movetype = MOVETYPE_STEP;
	hologram.classname = "hologram";
	hologram.solid = SOLID_BBOX;
	hologram.angles = self.old_angles;
	hologram.colormap = self.colormap;
	hologram.nextthink = (time + 0.12);
	hologram.think = HoloThink;
	hologram.takedamage = DAMAGE_AIM;
	hologram.health = 0;
	hologram.th_pain = SUB_Null;
	hologram.th_die = holo_die;
	setmodel (hologram, self.model);
	setsize (hologram, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin (hologram, self.old_position);
	hologram.frame = 13;
	setmodel (self, "progs/probe.mdl");
};

