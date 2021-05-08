/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

float SVC_SETVIEWPORT   = 5;
float SVC_SETVIEWANGLES = 10;
float CHSCAM_ON         = 4194304;

void () Keep_cam_chasing_owner;

void () Start_chase_cam =
{
	local entity chase_cam;

	chase_cam = spawn ();
	chase_cam.owner = self;
	chase_cam.owner.speed = chase_cam.owner.speed | CHSCAM_ON;
	chase_cam.solid = SOLID_NOT;
	chase_cam.movetype = MOVETYPE_FLYMISSILE;
	chase_cam.flags = chase_cam.flags | FL_FLY;
	chase_cam.flags = chase_cam.flags | FL_MONSTER;
	chase_cam.angles = self.angles;
	setmodel (chase_cam, "progs/null.spr");
	setsize (chase_cam, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (chase_cam, self.origin + '0 0 32');
	chase_cam.classname = "chase_cam";
	chase_cam.nextthink = time;
	chase_cam.think = Keep_cam_chasing_owner;
	chase_cam.angles_z = 0;
	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity (MSG_ONE, chase_cam);
	WriteByte (MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle (MSG_ONE, chase_cam.angles_x);
	WriteAngle (MSG_ONE, chase_cam.angles_y);
	WriteAngle (MSG_ONE, chase_cam.angles_z);
	W_SetCurrentAmmo ();
};


void () Remove_chase_cam =
{
	local entity e;

	if (self.owner.speed & CHSCAM_ON)
		self.owner.speed = self.owner.speed - CHSCAM_ON;
	msg_entity = self.owner;
	WriteByte (MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity (MSG_ONE, self.owner);
	e = self;
	self = self.owner;
	W_SetCurrentAmmo ();
	self = e;
	remove (self);
};


void () Keep_cam_chasing_owner =
{
	local vector spot2;
	local vector dir;
	local float dist;

	self.nextthink = time + 0.1;
	if (!(self.owner.speed & CHSCAM_ON))
	{
		Remove_chase_cam ();
		return;
	}
	makevectors (self.owner.v_angle);
	if (self.owner.cam_pos == 1)
		spot2 = self.owner.origin - (v_forward * 40) + (v_right * 12) + '0 0 14';
	else if (self.owner.cam_pos == 2)
		spot2 = self.owner.origin - (v_forward * 82) + '0 0 18';
	else
		spot2 = self.owner.origin - (v_forward * 100) + '0 0 -10';
	traceline (self.owner.origin, spot2, TRUE, self.owner);
	spot2 = trace_endpos + (v_forward * 2);
	traceline (spot2, spot2 + '0 0 24', TRUE, self.owner);
	if (trace_fraction < 1)
		spot2 = trace_endpos - '0 0 24';
	traceline (self.origin, spot2, TRUE, self.owner);
	if (trace_fraction == 1)
	{
		dir = normalize (spot2 - self.origin);
		dist = vlen (spot2 - self.origin);
		self.velocity = (dir * dist * 3);
		if (!infront (self.owner))
			self.velocity = self.velocity * 2;
	}
	else
		setorigin (self, spot2);
};


void () Toggle_chase_cam =
{
	if (self.speed & CHSCAM_ON)
	{
		if (self.cam_pos == 1)
			self.cam_pos = 2;
		else if (self.cam_pos == 2)
			self.cam_pos = 3;
		else
		{
			self.cam_pos = 1;
			self.speed = self.speed - CHSCAM_ON;
			if (self.tools == self.tools | UT_MINISUB)
				self.weaponmodel = "progs/subpit.mdl";
		}
	}
	else
	{
		self.cam_pos = 1;
		Start_chase_cam ();
	}
};

