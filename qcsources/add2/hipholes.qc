void() wallsprite = 
{
	if (!(self.model))
	{
		self.model = "progs/s_blood1.spr";
	}
	precache_model(self.model);
	setmodel(self, self.model);
	if (self.angles == '0 -1 0')
	{
		self.angles = '-90 0 0';
	}
	else
	{
		if (self.angles == '0 -2 0')
		{
			self.angles = '90 0 0';
		}
	}
	makevectors(self.angles);
	setorigin(self, self.origin - v_forward * 0.2);
	makestatic(self);
};

void() InitBulletHoles = 
{
	precache_model("progs/s_bullet.spr");
	bulletholes = nullentity;
	lastbullet = nullentity;
	numbulletholes = MSG_BROADCAST;
};

void() remove_bullethole = 
{
	local entity ent;
	if (bulletholes == nullentity)
	{
		objerror("remove_bullethole: bulletholes == nullentity! ");
	}
	ent = bulletholes;
	if (ent.classname != "bullethole")
	{
		objerror("remove_bullethole: Tried to remove non-bullethole!");
	}
	bulletholes = bulletholes.lastvictim;
	remove(ent);
	if (lastbullet == ent)
	{
		lastbullet = nullentity;
	}
	numbulletholes = numbulletholes - STAYOPEN;
};

void(vector pos) placebullethole = 
{
	local entity new;
	local entity ent;
	local vector norm;
	new = spawn();
	new.owner = new;
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	new.classname = "bullethole";
	setmodel(new, "progs/s_bullet.spr");
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	norm = trace_plane_normal;
	norm_x = MSG_BROADCAST - norm_x;
	norm_y = MSG_BROADCAST - norm_y;
	new.angles = vectoangles(norm);
	makevectors(self.angles);
	setorigin(new, pos - v_forward * 0.2);
	new.think = remove_bullethole;
	new.nextthink = time + 300;
	numbulletholes = numbulletholes + STAYOPEN;
	if (numbulletholes > MIN_ANGLE_DELTA)
	{
		remove_bullethole();
	}
	if (lastbullet != nullentity)
	{
		lastbullet.lastvictim = new;
	}
	else
	{
		bulletholes = new;
	}
	new.lastvictim = nullentity;
	lastbullet = new;
};

