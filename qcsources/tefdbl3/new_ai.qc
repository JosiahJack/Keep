void(entity destEnt, float radius, vector offset) ai_orbit = 
{
	local vector dir;
	local float dist;
	if (self.orbitPosition > MOVETYPE_WALK)
	{
		self.orbitPosition = 0;
	}
	else
	{
		if (self.orbitPosition < 0)
		{
			self.orbitPosition = 0;
		}
	}
	traceline(self.origin, destEnt.origin + offset, 1, world);
	if (trace_fraction < 1)
	{
		setorigin(self, destEnt.origin + offset);
		self.orbitPosition = self.orbitPosition + 1;
		return;
	}
	if (self.orbitPosition == 0)
	{
		dir = destEnt.origin + offset - self.origin;
		dir_x = dir_x + radius;
	}
	else
	{
		if (self.orbitPosition == 1)
		{
			dir = destEnt.origin + offset - self.origin;
			dir_y = dir_y + radius;
		}
		else
		{
			if (self.orbitPosition == FL_SWIM)
			{
				dir = destEnt.origin + offset - self.origin;
				dir_x = dir_x - radius;
			}
			else
			{
				dir = destEnt.origin + offset - self.origin;
				dir_y = dir_y - radius;
			}
		}
	}
	dist = vlen(dir);
	if (dist < FL_CLIENT)
	{
		self.orbitPosition = self.orbitPosition + 1;
	}
	else
	{
		if (dist < 50)
		{
			self.velocity = normalize(dir);
			self.velocity = self.velocity * MIN_CHARMER_DISTANCE;
		}
		else
		{
			self.velocity = normalize(dir);
			self.velocity = self.velocity * 500;
		}
	}
};

void(entity destEnt, float trackSpeed) ai_track = 
{
	local vector dir;
	dir = destEnt.origin + destEnt.view_ofs;
	dir = normalize(dir - self.origin);
	self.velocity = dir * trackSpeed;
};

void(string gibname, float dm) AccelerateGib = 
{
	local entity new;
	local float offset1;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, '-8 -8 -8', '8 8 8');
	new.velocity = -1.25 * self.velocity;
	makevectors(new.velocity);
	offset1 = random() * 300 - MIN_CHARMER_DISTANCE;
	new.velocity = new.velocity + v_right * offset1;
	offset1 = random() * 300 - MIN_CHARMER_DISTANCE;
	new.velocity = new.velocity + v_up * offset1;
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
	new.frame = 0;
	new.flags = 0;
};

void(float gibCount) ViolentDeath = 
{
	while (gibCount > 0)
	{
		AccelerateGib("progs/gib1.mdl", CONTENT_SLIME * gibCount);
		AccelerateGib("progs/gib2.mdl", CONTENT_SKY * gibCount);
		AccelerateGib("progs/gib3.mdl", -8 * gibCount);
		gibCount = gibCount - MOVETYPE_WALK;
	}
};

entity(string gibname) StartGib = 
{
	local entity new;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + MOVETYPE_BOUNCE + random() * MOVETYPE_BOUNCE;
	new.frame = 0;
	new.flags = 0;
	return new;
};

