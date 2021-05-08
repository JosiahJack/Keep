/*
External player view cam
*/

void() Cam_toggle =
{
	// turn cam off
	if(self.cament)
	{
		msg_entity = self;
		WriteByte (MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity (MSG_ONE, self);
		remove(self.cament);
		self.cament = world;
		stuffcmd(self, "cl_bob 0.02\n");
		W_SetCurrentAmmo();
	}
	else // turn cam on
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
		WriteByte (MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity (MSG_ONE, self.cament);
		stuffcmd(self, "cl_bob 0\n");
	}
};

void() Cam_position =
{
	local vector viewvec, viewpos;
	local vector camvec, org, idealorg, tmpvec;
	local entity ignor;

	makevectors(self.v_angle);
	viewvec = v_forward;

	// using a servomech, so use it as the view starting point
	if(self.rcam.classname == "mech_cockpit")
	{
		org = self.rcam.spawnmaster.origin + '0 0 48';
		ignor = self.rcam.spawnmaster;
	}
	else
	{
		org = self.origin + self.view_ofs + '0 0 8';
		ignor = self;
	}

	// find view focus
	traceline(org, org + viewvec*2048, FALSE, ignor);
	if(trace_fraction != 1)
	{
		viewpos = trace_endpos + '0 0 32';
	}
	else
	{
		traceline(org, org + viewvec*512, FALSE, ignor);
		viewpos = trace_endpos + '0 0 32';
	}

	// find the ideal place to put the cam
	camvec = org - v_forward*self.camofs_y + v_up*self.camofs_z;
	tmpvec = normalize(org - camvec);
	traceline(org, camvec, TRUE, ignor);
	if(trace_fraction != 1)
		idealorg = trace_endpos + tmpvec*8; // stay 8 units away from walls
	else
		idealorg = trace_endpos;

	// adjust the cam's position so that viewpos is in view
	do
	{
		traceline(idealorg, viewpos, TRUE, ignor);
		if(trace_fraction != 1)
		{
			idealorg = idealorg + tmpvec;
		}

		if(self.rcam.classname == "mech_cockpit")
		{
			if(vlen(idealorg - org) < 64)
				trace_fraction = 1; // so it doesn't try to move too close
		}
		else if(vlen(idealorg - org) < 32)
			trace_fraction = 1; // so it doesn't try to move too close
	} while(trace_fraction != 1);

	setorigin(self.cament, idealorg - self.view_ofs);

	if(self.weaponmodel)
		self.weaponmodel = "";
};
