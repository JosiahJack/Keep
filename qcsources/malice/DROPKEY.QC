
void () key_active =
{
	self.solid = SOLID_TRIGGER;
};


void (float type) drop_key =
{
	local entity key;
	local float x;

	key = spawn ();
	key.owner = self;
	key.movetype = MOVETYPE_BOUNCE;
	key.solid = SOLID_NOT;
	key.velocity_x = (random () * 200);
	key.velocity_y = (random () * 200);
	key.velocity_z = (200 + (random () * 100));
	key.noise = "misc/basekey.wav";
	key.touch = key_touch;
	setsize (key, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin (key, (self.origin + '0 0 10'));
	key.nextthink = (time + 0.5);
	key.think = key_active;
	if ((type == 1))
	{
		setmodel (key, "progs/b_s_key.mdl");
		key.items = IT_KEY1;
		key.netname = "access";
	}
	else
	{
		setmodel (key, "progs/b_g_key.mdl");
		key.items = IT_KEY2;
		key.netname = "access";
	}
};


void () sound_alarm =
{
	sound (self, CHAN_AUTO, "ambience/siren.wav", 1.00, ATTN_NORM);
};


void (vector where) make_bub =
{
	local entity bubble;

	bubble = spawn ();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, where);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity_z = (10 + (random () * 10));
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	setsize (bubble, '-8 -8 -8', '8 8 8');
	bubble.nextthink = time;
	bubble.think = bubble_bob;
};


void () player_touch =
{
	if ((other.classname == "player"))
	{
		other.velocity = (other.velocity + (self.velocity * 0.3));
		if ((self.burning == TRUE))
			CheckTouch ();
	}
};


void () rot8 =
{
	makevectors (self.owner.angles);
	if ((self.classname == "blindedbytheshinylights"))
		traceline (self.owner.origin, (self.owner.origin + (v_forward * 500)), 0.00, self);
	else
		traceline (self.owner.origin, (self.owner.origin + (v_forward * -500)), 0.00, self);
	setorigin (self, trace_endpos);
	self.nextthink = time;
	self.think = rot8;
};


void () beamshine =
{
	local entity beam;
	local entity beam2;

	beam = spawn ();
	beam.owner = self;
	beam.nextthink = time;
	beam.think = rot8;
	setmodel (beam, "progs/null.spr");
	setsize (beam, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (beam, self.origin);
	beam.movetype = MOVETYPE_NOCLIP;
	beam.solid = SOLID_NOT;
	beam.effects = (beam.effects | EF_DIMLIGHT);
	beam2 = spawn ();
	beam2.owner = self;
	beam2.nextthink = time;
	beam2.think = rot8;
	beam2.classname = "blindedbytheshinylights";
	setmodel (beam2, "progs/null.spr");
	setsize (beam2, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (beam2, self.origin);
	beam2.movetype = MOVETYPE_NOCLIP;
	beam2.solid = SOLID_NOT;
	beam2.effects = (beam2.effects | EF_DIMLIGHT);
};


void () init_siren =
{
	if ((other.classname != "player"))
		return;
	self.solid = SOLID_NOT;
	self.avelocity = '0 200 0';
	beamshine ();
	sound_alarm ();
	self.touch = SUB_Null;
};


void () siren =
{
	precache_model ("progs/siren.mdl");
	setmodel (self, "progs/siren.mdl");
	setsize (self, '-64 -64 -128', '64 64 32');
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_TRIGGER;
	self.touch = init_siren;
	self.classname = "siren";
};


void () plant_poo =
{
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	if ((self.frame > 8))
	{
		sound (self, CHAN_AUTO, "damage/plant.wav", 1.00, ATTN_NONE);
		self.think = SUB_Null;
		return;
	}
	self.frame = (self.frame + 1);
	self.nextthink = (time + 0.12);
	self.think = plant_poo;
	self.th_pain = SUB_Null;
};


void () the_plant =
{
	local float oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_sound ("damage/plant.wav");
	precache_model ("progs/plant.mdl");
	setmodel (self, "progs/plant.mdl");
	self.health = 5;
	self.th_die = plant_poo;
	self.takedamage = DAMAGE_YES;
	setsize (self, '-5 -5 -24', '5 5 25');
	self.origin_z = (self.origin_z + 2);
	oldz = self.origin_z;
	droptofloor (0, 0);
	if (((oldz - self.origin_z) > 250))
	{
		dprint ("item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
	}
};


void () Fly_Fuck =
{
	self.think = Fly_Fuck;
	if ((self.dualfire == 0))
	{
		self.nextthink = (time + 0.15);
		self.warp_factor = self.skin;
		self.skin = 3;
	}
	else
	{
		if ((self.dualfire == 1))
		{
			self.skin = self.warp_factor;
			self.nextthink = (time + 0.3);
		}
		else
		{
			if ((self.dualfire == 2))
			{
				self.skin = 3;
				self.nextthink = (time + 0.3);
			}
			else
			{
				if ((self.dualfire == 3))
				{
					self.model = string_null;
					self.nextthink = (time + 0.15);
				}
				else
				{
					if ((self.dualfire == 4))
					{
						self.nextthink = (time + 0.3);
						setmodel (self, "progs/vasquez.mdl");
						self.skin = 3;
					}
					else
					{
						WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte (MSG_BROADCAST, TE_TELEPORT);
						WriteCoord (MSG_BROADCAST, self.origin_x);
						WriteCoord (MSG_BROADCAST, self.origin_y);
						WriteCoord (MSG_BROADCAST, (self.origin_z - 50));
						self.think = SUB_Null;
						cbot_mort ();
					}
				}
			}
		}
	}
	self.dualfire = (self.dualfire + 1);
};


void () trig_think =
{
	if ((self.count > 2))
	{
		self.think = SUB_Null;
		remove (self);
	}
	else
	{
		CBot_Create (world);
		self.count = (self.count + 1);
	}
	self.nextthink = (time + 3.00);
};


void () release_deathsquad =
{
	local entity trig;

	trig = spawn ();
	trig.movetype = MOVETYPE_NONE;
	trig.solid = SOLID_NOT;
	trig.nextthink = time;
	trig.think = trig_think;
	self.count = 0;
	setmodel (trig, "progs/null.spr");
	trig.model = string_null;
	setsize (trig, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (trig, self.origin);
};


void () tbone_touch =
{
	if ((other.classname == "player"))
	{
		release_deathsquad ();
		remove (self);
	}
};


void () trigger_deathsquad =
{
	precache_model ("progs/null.spr");
	setmodel (self, "progs/null.spr");
	setsize (self, '-25 -25 -25', '25 25 25');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.touch = tbone_touch;
	self.classname = "trigger_deathsquad";
};

