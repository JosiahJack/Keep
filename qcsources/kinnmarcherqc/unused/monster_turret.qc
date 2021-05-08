

void() turret_calculate_pitch =
{
	//local string st;

	local vector ang;

	ang = vectoangles(self.enemy.origin - self.origin);

	self.idealpitch = ang_x;

	//st = ftos(self.idealpitch);
	//dprint("ideal pitch is ");
	//dprint(st);
	//dprint("\n");

	bdw_change_pitch();
};	

void() turret_active = [1, turret_active]
{
	ai_face();
	turret_calculate_pitch();
	self.owner.angles_y = self.angles_y;

	CheckAttack();
};

void() turret_stand = [1, turret_stand]
{
	self.angles_y = self.angles_y + 5;
	if (self.angles_y < 360)
		self.angles_y = self.angles_y - 360;

	self.owner.angles_y = self.angles_y;

	if (self.pain_finished < time)
	{
		//sound (self, CHAN_BODY, "turret/active.wav", 1,  ATTN_IDLE);
		self.pain_finished = time + 0.8;
	}

	ai_stand();
};

void(float ox) turret_shot =
{
	local float shotcount = 4;
	local float shotdamage = 3;
	local vector spread = '0.04 0.04 0';
	local vector src, direction;

	makevectors(self.angles);

	src = self.origin + (v_right*16*ox);

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = v_forward + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		direction_z = direction_z * -1;	// hack

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (shotdamage, direction, DMG_MISC, FALSE);
         	
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage (DMG_MISC);
};

void() turret_fire1 = [2, turret_fire2]
{
	ai_face();	
	turret_calculate_pitch();
	self.owner.angles_y = self.angles_y;	

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, 1, "turret/fire1.wav", 1,  ATTN_NORM);
	turret_shot(-1);
};
void() turret_fire2 = [5, turret_fire1]
{
	ai_face();
	turret_calculate_pitch();
	self.owner.angles_y = self.angles_y;

	if (!infront(self.enemy))
	{
		self.think = turret_active;
		return;
	}

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, 1, "turret/fire1.wav", 1,  ATTN_NORM);
	turret_shot(1);
};	

void() turret_die = 
{
	remove(self.owner);

	T_RadiusDamage (self, self, 120, world, DMG_EXPLODE);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() turret_deploy =
{
	local vector neworg;

	self.think = turret_deploy;

	neworg = self.origin - '0 0 2';

	if (neworg_z < self.oldorigin_z - 64)
	{
		neworg_z = self.oldorigin_z - 64;
		self.think = turret_active;
		self.th_run = turret_active;
	}

	if (self.pain_finished < time)
	{
		sound (self, CHAN_BODY, "turret/search.wav", 1,  ATTN_IDLE);
		self.pain_finished = time + 10;
	}

	setorigin(self, neworg);
	setorigin(self.owner, self.origin);
	self.nextthink = time + 0.1;
};	

void() turret_retract =
{};

void() turret_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	//if (activator.classname != "player")
	//	return;

	self.enemy = activator;

	turret_deploy();
};


void() monster_turret_heavy =
{
	local entity base;

	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/tur_big.mdl");
	precache_model ("progs/tur_base.mdl");

	precache_sound ("turret/active.wav");
	precache_sound ("turret/fire1.wav");
	precache_sound ("turret/search.wav");	// deploy sound


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;

	self.classname = "monster_turret_heavy";		// for testing purposes
	self.origin_z = self.origin_z + 64;			// for testing purposes

	self.health = 120;	// subject to change
	self.yaw_speed = 5;
	self.view_ofs = '0 0 0';
	self.angles_x = 90;	// starts folded up

	self.takedamage = DAMAGE_AIM;
	
	setmodel (self, "progs/tur_big.mdl");
	setsize (self, '-32 -32 -8', '32 32 32');
	setorigin (self, self.origin + '0 0 12');		// this snuggles it nicely to the top of a 64 high recess

	self.oldorigin = self.origin;		// remember where it started

	base = spawn();

	base.solid = SOLID_NOT;
	base.movetype = MOVETYPE_NONE;
	base.angles_y = self.angles_y;
	base.classname = "turret_base";

	setmodel (base, "progs/tur_base.mdl");
	setsize (base, '0 0 0', '0 0 0');
	setorigin (base, self.origin);

	self.owner = base;

	self.pausetime = 99999999;
	self.flags = self.flags | FL_MONSTER;

	self.th_stand = turret_stand;
	self.th_walk = turret_stand;
	self.th_run = turret_deploy;
	self.th_missile = turret_fire1;
	self.th_die = turret_die;

	self.use = turret_use;

	self.think = turret_stand;
	self.nextthink = time + 0.1 + random()*0.5;
};





	


	

	