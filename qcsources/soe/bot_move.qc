
/***********************************************
*                                              *
*            FrikBot Movement AI               *
*       "The not so great movement AI"         *
*                                              *
***********************************************/

float(vector sdir) frik_KeysForDir =
{

	local vector keydir;
	local float outkeys, tang;
	outkeys = 0;
	keydir = vectoangles(sdir);
	if (sdir_x || sdir_y)
	{
		// Everything is tested against 60 degrees,
		// this allows the bot to overlap the keys
		// 30 degrees on each diagonal  45 degrees 
		// might look more realistic
 
		tang = angcomp(keydir_y, self.v_angle_y);
		if (fabs(tang) <= 60)
			outkeys = outkeys + KEY_MOVEFORWARD;
		tang = angcomp(keydir_y, self.v_angle_y - 90);
		if (fabs(tang) <= 60)
			outkeys = outkeys + KEY_MOVERIGHT;
		tang = angcomp(keydir_y, self.v_angle_y + 90);
		if (fabs(tang) <= 60)
			outkeys = outkeys + KEY_MOVELEFT;
		tang = angcomp(keydir_y, self.v_angle_y - 180);
		if (fabs(tang) <= 60)
			outkeys = outkeys + KEY_MOVEBACK;
	}
	if (sdir_z > 0.7)
		outkeys = outkeys + KEY_MOVEUP;
	else if (sdir_z < 0.7)
		outkeys = outkeys + KEY_MOVEDOWN;
	return outkeys;

};
.float obs_time;
.vector obs_dir;

void(vector whichway) frik_obstructed =
{
	local vector disway, org;
	local float dist;
	if (self.obs_time > time)
		return;
	whichway = normalize(whichway);
	disway_x = whichway_y * -1;
	disway_y = whichway_x;
	if (self.goalentity != world)
	{
		org = self.goalentity.origin;
                if (self.goalentity.origin == '0 0 0')
			org = (self.goalentity.absmin + self.goalentity.absmax) * 0.5;
		dist = vlen(org - (self.origin + disway * 10));
                if (vlen(org - (self.origin + disway * -10)) < dist)
			disway = disway * -1;
	} else if (self.wallhug == -90)
		disway = disway * -1;
	self.obs_dir = disway;
	self.obs_time = time + 0.3;

	if (random() <= 0.05)
		if (self.wallhug == 90)
			self.wallhug = -90;
		else self.wallhug = 90;
	return;
};
void() frik_obstacles =
{
	if (!(self.flags & FL_ONGROUND))
		return;
	local vector start, stop, ang;
	local float test, conts, dist, hgt;
	// Check to see if I can jump over something in my way
	ang = normalize(self.velocity);
	ang_z = 0;
	start = self.origin + ang * 32; // ahem
	start_z = self.origin_z + self.maxs_z;
	stop = start;
	stop_z = self.origin_z + self.mins_z;
	traceline(start, stop - '0 0 256', TRUE, self);
	if (trace_allsolid || trace_startsolid)
		return;
	hgt = trace_endpos_z - stop_z;

	if ((hgt > 18) && (hgt <= 40))
	{
		self.button2 = TRUE;
		return;
	}
	else if (hgt <= -64) // this might be a gap
	{
		conts = pointcontents(trace_endpos);
		start = stop - '0 0 8';
		stop = start + ang *  256;
		traceline(start, stop, TRUE, self);
		test = vlen(trace_endpos - start);
		if (test <= 20)
			return; // it's a walkable gap, do nothing
		ang_x = self.velocity_y * -1;
		ang_y = self.velocity_x;
		ang = normalize(ang);
		traceline(start - (ang * 10), start + (ang * 10), TRUE, self);
		if ((trace_fraction != 1) || trace_startsolid)
			return; // gap is only 20 wide, walkable	
		ang = self.velocity;
		ang_z = 0;
                dist = ((540 / sv_gravity) * vlen(ang)) + 32;
		if (test > dist) // I can't make it
		{
			if (conts < -3) // bad stuff down dare
			{
				self.obs_time = 0;
				frik_obstructed(ang);
				return;
			}
			else
				return; // safe to fall
				// maybe blind leap, but too annoying
		} else {
			ang = normalize(ang);
			traceline(self.origin, self.origin + (ang * (test + 20)), TRUE, self);
			if (trace_fraction != 1)
			{
				if (conts < -3) // bad stuff down dare
				{
					self.obs_time = 0;
					frik_obstructed(ang);
					return;
				}
				else
					return; // safe to fall
			}
		}
		self.button2 = TRUE; // go for it, dude!
	} else if (pointcontents(trace_endpos) < -3)
	{
		self.obs_time = 0;
		frik_obstructed(ang);
		return;
	}
};

void() frik_movetogoal =
{
	if (self.goalentity == world)
		return;
	local vector way, start, stop, ang;
	way = self.goalentity.origin;
	if (way == '0 0 0')
		way = (self.goalentity.absmin + self.goalentity.absmax) * 0.5;
	if (vlen(way - self.origin) < 48)
		return;
	way = normalize(way - self.origin);
	self.keys = self.keys - (self.keys & 63) + frik_KeysForDir(way);
	frik_obstacles();
	if (time < self.obs_time)
		self.keys = self.keys - (self.keys & 63) + frik_KeysForDir(self.obs_dir);

};
float(vector weird) frik_walkmove =
{
 // okay so it's not walkmove
 // sue me
 	self.keys = self.keys - (self.keys & 63) + frik_KeysForDir(weird);
	frik_obstacles();
	
	if (time < self.obs_time)
	{
		self.keys = self.keys - (self.keys & 63) + frik_KeysForDir(self.obs_dir);
		return FALSE;
	} else
		return TRUE;
};

