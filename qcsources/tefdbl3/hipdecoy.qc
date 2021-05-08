void() decoy_stand1 = [17, decoy_stand1]
{
	ChangeYaw();
	if (self.walkframe >= MOVETYPE_FLY)
	{
		self.walkframe = 0;
	}
	self.frame = TE_EXPLOSION2 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	if (time > self.pausetime)
	{
		self.th_walk();
	}
};

void() decoy_walk1 = [6, decoy_walk1]
{
	local float r;
	movetogoal(TE_EXPLOSION2);
	self.weaponframe = 0;
	if (self.walkframe == MOVETYPE_TOSS)
	{
		self.walkframe = 0;
	}
	if (self.walkframe == FL_SWIM || self.walkframe == MOVETYPE_FLY)
	{
		r = random();
		if (r < 0.14)
		{
			sound(self, CHAN_VOICE, "misc/foot1.wav", 0.5, ATTN_NORM);
		}
		else
		{
			if (r < 0.290000)
			{
				sound(self, CHAN_VOICE, "misc/foot2.wav", 0.5, ATTN_NORM);
			}
			else
			{
				if (r < 0.43)
				{
					sound(self, CHAN_VOICE, "misc/foot3.wav", 0.5, ATTN_NORM);
				}
				else
				{
					if (r < 0.580000)
					{
						sound(self, CHAN_VOICE, "misc/foot4.wav", 0.5, ATTN_NORM);
					}
					else
					{
						if (r < 0.72)
						{
							sound(self, CHAN_VOICE, "misc/foot5.wav", 0.5, ATTN_NORM);
						}
						else
						{
							if (r < 0.86)
							{
								sound(self, CHAN_VOICE, "misc/foot6.wav", 0.5, ATTN_NORM);
							}
							else
							{
								sound(self, CHAN_VOICE, "misc/foot7.wav", 0.5, ATTN_NORM);
							}
						}
					}
				}
			}
		}
	}
	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void(entity decoy) setup_decoy = 
{
	local entity pl;
	decoy.classname = "monster_decoy";
	setmodel(decoy, "progs/player.mdl");
	setsize(decoy, VEC_HULL_MIN, VEC_HULL_MAX);
	decoy.view_ofs = '0 0 22';
	decoy.solid = SOLID_SLIDEBOX;
	decoy.movetype = MOVETYPE_STEP;
	decoy.health = 3000000;
	decoy.th_stand = decoy_stand1;
	decoy.th_walk = decoy_walk1;
	decoy.th_run = decoy_walk1;
	decoy.th_missile = decoy_stand1;
	decoy.th_pain = decoy_stand1;
	decoy.th_die = decoy_stand1;
	pl = find(world, classname, "player");
	decoy.colormap = pl.colormap;
};

void() monster_decoy = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	setup_decoy(self);
	walkmonster_start();
	total_monsters = total_monsters - 1;
};

void(string targ, vector orig) become_decoy = 
{
	local entity pl;
	local entity decoy;
	local entity temp;
	decoy = hipdecoy = spawn();
	temp = self;
	self = decoy;
	setup_decoy(decoy);
	setorigin(decoy, orig);
	decoy.origin = orig;
	decoy.target = targ;
	decoy.takedamage = DAMAGE_AIM;
	decoy.ideal_yaw = decoy.angles * '0 1 0';
	if (!(decoy.yaw_speed))
	{
		decoy.yaw_speed = 20;
	}
	decoy.use = monster_use;
	decoy.flags = decoy.flags | FL_MONSTER;
	if (decoy.target)
	{
		decoy.goalentity = decoy.movetarget = find(world, targetname, decoy.target);
		decoy.ideal_yaw = vectoyaw(decoy.goalentity.origin - decoy.origin);
		if (!(decoy.movetarget))
		{
			dprint("Monster can't find target at ");
			dprint(vtos(decoy.origin));
			dprint("\n");
		}
		if (decoy.movetarget.classname == "path_corner")
		{
			decoy.th_walk();
		}
		else
		{
			decoy.pausetime = 100000000;
		}
		decoy.th_stand();
	}
	else
	{
		decoy.pausetime = 100000000;
		decoy.th_stand();
	}
	decoy.nextthink = decoy.nextthink + random() * 0.5;
	self = temp;
};

