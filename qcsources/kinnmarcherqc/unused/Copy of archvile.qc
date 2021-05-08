/*
========================
ARCHVILE FLAMES

.pain_finished	time when touchdamage activated again
.lastvictim		the archvile who spawned it (real owner)

========================
*/

void() archvile_flame_touch =
{
	if (time < self.pain_finished)
		return;

	if (!other.takedamage)
		return;

	if (other.classname == "monster_archvile")
		return;

	self.pain_finished = time + 0.1;

// FIXME: variable damage depending on frame
	T_Damage (other, self, self.lastvictim, 5, DMG_MONSTER);
};

void(vector org) archvile_flame =
{
	local entity flame, temp;

	flame = spawn();

	flame.solid = SOLID_TRIGGER;
	flame.touch = archvile_flame_touch;
	flame.movetype = MOVETYPE_NONE;

	flame.owner = self;	// not really used
	flame.lastvictim = self.lastvictim;		// real owner

	setmodel(flame, "sprites/archvile/firewal1.spr");
	setsize(flame, '-24 -24 -30', '24 24 40');
	//setorigin(flame, org + '0 0 50');
	setorigin(flame, org + '0 0 30');

	flame.idleweaponframe = 18;
	flame.think = BDW_SpriteGenericPlayOnce;
	flame.nextthink = time + 0.05;

	//temp = self;
	//self = flame;
	//droptofloor();
	//self = temp;
};

/*
=======================
ARCHVILE FLAME SPAWNERS

.oldorigin		position of last flame spawned
.pain_finished	time of next flame to be spawned

TODO: make flame spawner movetype none and just work out
a position for the next flame every 0.1 seconds - saves mucking about with
getting invivible missiles to travel through people

also, jitter the xy position a bit rather than travelling in a dead straight line
you can still have homing - in fact it should be easier to do.

=======================
*/

float() archvile_flame_spawn =
{
	local float d;

	traceline(self.origin, self.origin - '0 0 300', TRUE, self);

	if (trace_fraction == 1)
		return FALSE;	// too far down	

	if (trace_inwater)
		return FALSE;	// fire and water don't mix

	d = fabs(trace_endpos_z - self.oldorigin_z);
	if (d > 100)
		return FALSE;	// too big a height difference from the last one

	self.oldorigin = trace_endpos;
	archvile_flame(trace_endpos);
	
	return TRUE;
};
/*
void() archvile_flame_spawner_think =
{
	// homing stuff

	if (time > self.pain_finished)
	{
		if (!archvile_flame_spawn())
		{
			// fizzled out
			remove(self);
			return;
		}

		self.pain_finished = time + 0.1;
	}

};
*/

// non-homing test version
void() archvile_flame_spawner_think =
{
	if (!archvile_flame_spawn())
	{
		// fizzled out
		remove(self);
		return;
	}

	self.think = archvile_flame_spawner_think;
	self.nextthink = time + 0.1;
};

void() archvile_flame_spawner_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.solid == SOLID_SLIDEBOX)
	{
		self.owner = other;	// go through monsters/players?
		return;
	}

	remove(self);
};

void() archvile_launch_flame_spawner =
{
	local entity flamer;
	local vector org, dir;

	org = self.origin + self.view_ofs;
	dir = normalize(self.enemy.origin - self.origin);

	flamer = spawn();

	flamer.owner = self;
	flamer.lastvictim = self;	// owner for t_damage calls

	flamer.movetype = MOVETYPE_FLYMISSILE;
	flamer.solid = SOLID_BBOX;

	flamer.touch = archvile_flame_spawner_touch;
	flamer.think = archvile_flame_spawner_think;
	flamer.nextthink = time + 0.1;

	flamer.velocity = dir * 600;

	flamer.oldorigin = self.origin;
	flamer.oldorigin_z = self.absmin_z;

	setmodel (flamer, "sprites/misc/s_null.spr");
	setsize (flamer, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (flamer, org);
};






