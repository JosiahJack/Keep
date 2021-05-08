/*
This source code was not part of the original Malice code.
*/

.float it_flashlight_on;
.entity it_flashlight_entity;

void () FlashlightAim =
	{
	local vector direction;
	local vector src;
	local entity pl;
	local float temp;

	pl = self.owner;
	makevectors (pl.v_angle);
	src = pl.origin + (v_forward * 10.00);
	src_z = pl.absmin_z + (pl.size_z * 0.70);
	direction = aim (pl, 100000.00);
	traceline (src, src + (direction * 2048.00), FALSE, pl);
	src = (0.10 * src) + (0.90 * trace_endpos);
	setorigin (self, src);
	self.nextthink = time + 0.05;
	};

void () FlashlightToggle =
	{
	local entity oldself;

	if (self.it_flashlight_on)
		{
		if (self.it_flashlight_entity)
			remove (self.it_flashlight_entity);
		self.it_flashlight_entity = world;
		self.it_flashlight_on = FALSE;
		}
	else
		{
		self.it_flashlight_on = TRUE;
		oldself = self;
		self.it_flashlight_entity = spawn ();
		self = self.it_flashlight_entity;
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_NOT;
		setmodel (self, "progs/null.spr");
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.effects = EF_DIMLIGHT;
		self.owner = oldself;
		self.nextthink = time + 1.00;
		self.think = FlashlightAim;
		FlashlightAim ();
		self = oldself;
		}
	};