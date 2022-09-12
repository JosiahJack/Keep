void(vector org, vector dir, float punch, vector spread) eject_shell = 
{
	local float flip;
	local vector transform;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	newmis.touch = shell_touch;
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 2;
	if (self.weapon == IT_SUPER_SHOTGUN || self.weapon == IT_SHOTGUN)
	{
		setmodel(newmis, "progs/shelcase.mdl");
		newmis.classname = "shotcasing";
	}
	else
	{
		if (self.weapon2 == WE_SNIPER_RIFLE)
		{
			setmodel(newmis, "progs/case.mdl");
			newmis.classname = "shellcasing";
		}
	}
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	flip = crandom();
	spread_x = spread_x * flip;
	flip = crandom();
	spread_y = spread_y * flip;
	flip = crandom();
	spread_z = spread_z * flip;
	transform_x = dir_y + spread_x;
	transform_y = 0 - dir_x + spread_y;
	transform_z = dir_z + spread_z;
	newmis.velocity = transform * punch;
	flip = random();
	if (flip < 0.25)
	{
		newmis.avelocity = '300 300 300';
	}
	else
	{
		if (flip < 0.5)
		{
			newmis.avelocity = '150 300 100';
		}
		else
		{
			if (flip < 0.75)
			{
				newmis.avelocity = '200 100 0';
			}
			else
			{
				newmis.avelocity = '400 200 100';
			}
		}
	}
};

void() shell_touch = 
{
	local float random_number;
	if (other.classname == "door")
	{
		return;
	}
	if (random() > 0.7)
	{
		if (self.classname == "shotcasing")
		{
			sound(self, CHAN_AUTO, "weapons/shellhit.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "weapons/casehit.wav", 1, ATTN_NORM);
		}
	}
	else
	{
		return;
	}
};

