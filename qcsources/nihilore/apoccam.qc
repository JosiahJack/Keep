void() Cam_toggle = 
{
	if (self.cament)
	{
		msg_entity = self;
		WriteByte(MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity(MSG_ONE, self);
		remove(self.cament);
		self.cament = world;
		stuffcmd(self, "cl_bob 0.02\n");
		W_SetCurrentAmmo();
	}
	else
	{
		self.cament = spawn();
		self.cament.owner = self;
		self.cament.classname = "camera";
		self.cament.solid = SOLID_NOT;
		self.cament.movetype = MOVETYPE_NONE;
		self.cament.angles = self.angles;
		setmodel(self.cament, "progs/s_null.spr");
		setorigin(self.cament, self.origin);
		msg_entity = self;
		WriteByte(MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity(MSG_ONE, self.cament);
		stuffcmd(self, "cl_bob 0\n");
	}
};

void() Cam_position = 
{
	local vector viewvec;
	local vector viewpos;
	local vector camvec;
	local vector org;
	local vector idealorg;
	local vector tmpvec;
	local entity ignor;
	makevectors(self.v_angle);
	viewvec = v_forward;
	if (self.rcam.classname == "mech_cockpit")
	{
		org = self.rcam.spawnmaster.origin + '0 0 48';
		ignor = self.rcam.spawnmaster;
	}
	else
	{
		org = self.origin + self.view_ofs + '0 0 8';
		ignor = self;
	}
	traceline(org, org + viewvec * BIT_12, 0, ignor);
	if (trace_fraction != SPAWN_CRUCIFIED)
	{
		viewpos = trace_endpos + '0 0 32';
	}
	else
	{
		traceline(org, org + viewvec * BIT_10, 0, ignor);
		viewpos = trace_endpos + '0 0 32';
	}
	camvec = org - v_forward * self.camofs_y + v_up * self.camofs_z;
	tmpvec = normalize(org - camvec);
	traceline(org, camvec, 1, ignor);
	if (trace_fraction != SPAWN_CRUCIFIED)
	{
		idealorg = trace_endpos + tmpvec * SECRET_NO_SHOOT;
	}
	else
	{
		idealorg = trace_endpos;
		do
		{
		}
		traceline(idealorg, viewpos, 1, ignor);
		if (trace_fraction != SPAWN_CRUCIFIED)
		{
			idealorg = idealorg + tmpvec;
		}
		if (self.rcam.classname == "mech_cockpit")
		{
			if (vlen(idealorg - org) < DOOR_SMALL_TRIG)
			{
				trace_fraction = SPAWN_CRUCIFIED;
			}
		}
		else
		{
			if (vlen(idealorg - org) < DOOR_TOGGLE)
			{
				trace_fraction = SPAWN_CRUCIFIED;
			}
		}
	} while (trace_fraction != SPAWN_CRUCIFIED);
	setorigin(self.cament, idealorg - self.view_ofs);
	if (self.weaponmodel)
	{
		self.weaponmodel = "";
	}
};

