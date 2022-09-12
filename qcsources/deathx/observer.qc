void(entity player) ObserverInfo = 
{
};

void(entity player) ObserverInit = 
{
};

void(entity player) ObserverHelp = 
{
};

void(entity player, entity door) ObserverTeleportThroughDoor = 
{
	local entity d;
	local entity d_master;
	local vector dmin;
	local vector dmax;
	local float is_x;
	local float is_y;
	local float is_z;
	local float set;
	local vector dir;
	local vector or;
	local vector IMMEDIATE;
	local vector v;
	d_master = d = door.owner;
	if (d_master)
	{
		dmin = d_master.absmin;
		dmax = d_master.absmax;
	}
	else
	{
		dmax = '0 0 0';
		dmin = '0 0 0';
	}
	if (dmin != dmax)
	{
		if (d_master.state != STATE_BOTTOM)
		{
			return;
			do
			{
			}
			if (d.absmin_x < dmin_x)
			{
				dmin_x = d.absmin_x;
			}
			if (d.absmax_x > dmax_x)
			{
				dmax_x = d.absmax_x;
			}
			if (d.absmin_y < dmin_y)
			{
				dmin_y = d.absmin_y;
			}
			if (d.absmax_y > dmax_y)
			{
				dmax_y = d.absmax_y;
			}
			if (d.absmin_z < dmin_z)
			{
				dmin_z = d.absmin_z;
			}
			if (d.absmax_z > dmax_z)
			{
				dmax_z = d.absmax_z;
			}
			d = d.enemy;
		} while (d != d_master && d != world);
	}
	else
	{
		return;
	}
	is_z = 0;
	is_y = 0;
	is_x = 0;
	set = 0;
	or = player.origin;
	if (dmin_x + 15 < player.absmin_x && player.absmax_x < dmax_x - 15)
	{
		is_x = 1;
	}
	if (dmin_y + 15 < player.absmin_y && player.absmax_y < dmax_y - 15)
	{
		is_y = 1;
	}
	if (dmin_z + 15 < player.absmin_z && player.absmax_z < dmax_z - 15)
	{
		is_z = 1;
	}
	if (is_x && is_y)
	{
		if (or_z < dmin_z)
		{
			dir = '0 0 1';
			or_z = dmax_z + 25;
		}
		else
		{
			if (or_z > dmax_z)
			{
				dir = '0 0 -1';
				or_z = dmin_z - 25;
			}
		}
		set = 1;
	}
	else
	{
		if (is_x && is_z)
		{
			if (or_y < dmin_y)
			{
				dir = '0 1 0';
				or_y = dmax_y + 25;
			}
			else
			{
				if (or_y > dmax_y)
				{
					dir = '0 -1 0';
					or_y = dmin_y - 25;
				}
			}
			set = 1;
		}
		else
		{
			if (is_y && is_z)
			{
				if (or_x < dmin_x)
				{
					dir = '1 0 0';
					or_x = dmax_x + 25;
				}
				else
				{
					if (or_x > dmax_x)
					{
						dir = '-1 0 0';
						or_x = dmin_x - 25;
					}
				}
				set = 1;
			}
		}
	}
	if (set)
	{
		v = normalize(player.velocity);
		if (dir * v < 0.5)
		{
			return;
		}
		player.origin = or;
		setorigin(player, player.origin);
	}
};

void(entity player, entity tele) ObserverTeleportThroughTeleporter = 
{
	local entity targ;
	local vector v1;
	local vector v2;
	v1 = (tele.absmax + tele.absmin) * 0.5 - player.origin;
	normalize(v1);
	v2 = player.velocity;
	normalize(v2);
	if (v1 * v2 <= 0.1)
	{
		return;
	}
	targ = find(world, targetname, tele.target);
	if (!targ)
	{
		dprint("ObserverTeleportThroughTeleporter: couldn't find teleporter target\n");
		return;
	}
	makevectors(targ.mangle);
	setorigin(player, targ.origin);
	player.angles = targ.mangle;
	player.fixangle = 1;
	player.teleport_time = time + 0.7;
	player.velocity = v_forward * 300;
};

void() ObserverThink = 
{
	local float invcos;
	local float nv;
	local float nvp;
	local float nvpmax;
	local float nvs;
	local float nsp;
	local float sp;
	local float svz;
	local vector f;
	local vector vp;
	local vector vs;
	local entity e;
	local float cont;
	if (self.movetype != MOVETYPE_FLY)
	{
		self.observer_status = self.observer_status | OBSERVER_BECOME_OBSERVER;
	}
	svz = self.velocity_z;
	self.velocity_z = 0;
	f_x = v_forward_x;
	f_y = v_forward_y;
	f_z = 0;
	invcos = vlen(f);
	if (invcos)
	{
		invcos = 1 / invcos;
	}
	else
	{
		invcos = 0;
	}
	f = f * invcos;
	sp = f * self.velocity;
	vp = sp * f;
	nvp = vlen(vp);
	if (sp < 0)
	{
		nvp = nvp * -1;
	}
	vs = self.velocity - vp;
	vp = v_forward * (nvp * invcos);
	vp_z = vp_z + svz;
	nvp = vlen(vp);
	nvpmax = 320 - 100 * (v_forward * '0 0 1');
	if (nvp > nvpmax)
	{
		vp = vp * (nvpmax / nvp);
	}
	self.velocity = vp + vs;
	e = findradius(self.origin, 75);
	if (e)
	{
		cont = 1;
	}
	else
	{
		cont = 0;
	}
	while (cont)
	{
		if (e.classname == "door")
		{
			ObserverTeleportThroughDoor(self, e);
			cont = 0;
		}
		if (e.classname == "trigger_teleport")
		{
			ObserverTeleportThroughTeleporter(self, e);
			cont = 0;
		}
		e = e.chain;
		if (!e)
		{
			cont = 0;
		}
	}
	self.weaponmodel = "";
	self.weaponframe = 0;
	if (self.observer_status & OBSERVER_BECOME_OBSERVER)
	{
		self.movetype = MOVETYPE_WALK;
		self.observer_pos_num = 0;
		self.observer_status = self.observer_status - OBSERVER_BECOME_OBSERVER;
		self.observer_pos_num = 1 + random() * 4;
		ObserverBecomeObserver(self);
		ObserverSetPlayerPos(self);
		centerprint(self, "Observer Mode Enabled\n");
	}
	if (self.observer_status & OBSERVER_NEXTVIEW)
	{
		self.observer_pos_num = self.observer_pos_num + 1;
		ObserverSetPlayerPos(self);
		self.observer_status = self.observer_status - OBSERVER_NEXTVIEW;
		return;
	}
	if (self.observer_status & OBSERVER_PREVVIEW)
	{
		self.observer_pos_num = self.observer_pos_num - 1;
		ObserverSetPlayerPos(self);
		self.observer_status = self.observer_status - OBSERVER_PREVVIEW;
		return;
	}
	if (self.button0)
	{
		self.observer_status = self.observer_status | OBSERVER_BUTTON0;
		self.button0 = 0;
		respawn();
	}
	if (self.button1)
	{
		self.observer_status = self.observer_status | OBSERVER_BUTTON1;
	}
	if (self.button2)
	{
		self.observer_status = self.observer_status | OBSERVER_BUTTON2;
	}
	if (self.button0 || self.button1 || self.button2)
	{
		return;
	}
	if (self.observer_status & (OBSERVER_BUTTON2 | OBSERVER_BUTTON1))
	{
		if (!(self.button0) && !(self.button1) && !(self.button2))
		{
			self.observer_status = OBSERVER_NEXTVIEW;
			return;
		}
	}
};

void() ObserverDeathThink = 
{
	if (self.button1)
	{
		self.observer_status = self.observer_status | OBSERVER_BUTTON1;
		return 1;
	}
	if (self.button2)
	{
		self.observer_status = self.observer_status | OBSERVER_BUTTON2;
		return 1;
	}
	return 0;
};

void(entity player) ObserverBecomeObserver = 
{
	player.armorvalue = 0;
	player.items = 0;
	player.health = 998;
	player.ammo_shells = 0;
	player.ammo_nails = 0;
	player.ammo_rockets = 0;
	player.ammo_cells = 0;
	player.weapon = 0;
	player.currentammo = 1;
	player.takedamage = DAMAGE_NO;
	player.solid = SOLID_NOT;
	player.movetype = MOVETYPE_FLY;
	player.deadflag = DEAD_NO;
	setmodel(player, string_null);
};

entity(entity player) ObserverFindPos = 
{
	local entity spot;
	local float pos_num_startsearch;
	if (player.observer_pos_num <= 0)
	{
		player.observer_pos_num = 1;
	}
	else
	{
		if (player.observer_pos_num >= 21)
		{
			player.observer_pos_num = 1;
		}
	}
	pos_num_startsearch = player.observer_pos_num;
	if (player.observer_pos_num <= 5)
	{
		spot = find(world, classname, "info_intermission");
		if (player.observer_pos_num >= 2 && !!spot)
		{
			spot = find(spot, classname, "info_intermission");
		}
		if (player.observer_pos_num >= 3 && !!spot)
		{
			spot = find(spot, classname, "info_intermission");
		}
		if (player.observer_pos_num >= 4 && !!spot)
		{
			spot = find(spot, classname, "info_intermission");
		}
		if (!spot)
		{
			player.observer_pos_num = 5;
		}
	}
	if (player.observer_pos_num >= 5)
	{
		spot = find(world, classname, "info_player_deathmatch");
		if (player.observer_pos_num >= 6 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 7 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 8 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 9 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 10 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 11 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 12 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 13 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 14 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 15 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 16 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 17 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 18 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 19 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (player.observer_pos_num >= 20 && !!spot)
		{
			spot = find(spot, classname, "info_player_deathmatch");
		}
		if (!spot)
		{
			player.observer_pos_num = 21;
		}
	}
	if (player.observer_pos_num >= 21)
	{
		spot = find(world, classname, "info_player_start");
		player.observer_pos_num = 21;
	}
	if (!spot && pos_num_startsearch != 1)
	{
		player.observer_pos_num = player.observer_pos_num + 1;
		spot = ObserverFindPos(player);
	}
	if (!spot)
	{
		error("ObserverFindPos: could not find start pos");
	}
	return spot;
};

void(entity player) ObserverSetPlayerPos = 
{
	local entity pos;
	local vector posoffset;
	pos = ObserverFindPos(player);
	player.angles = player.v_angle = pos.mangle;
	player.fixangle = 1;
	player.view_ofs = '0 0 12';
	player.velocity = '0 0 0';
	makevectors(self.angles);
	setsize(player, '-12 -12 -12', '12 12 12');
	if (player.observer_pos_num <= 4)
	{
		setorigin(player, pos.origin + '0 0 -60');
	}
	else
	{
		setorigin(player, pos.origin);
	}
	player.flags = player.flags | FL_ONGROUND;
};

