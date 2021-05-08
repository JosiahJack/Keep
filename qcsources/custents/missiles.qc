/*
MISSILSE.QC
contains universal code used for launching and handlind projectiles.
*/

float() crandom;
void(vector org, vector vel, float damage, entity targ) SpawnBlood;
void() BecomeExplosion;

// touch functions that are down below.
void() M_Grenade_Explode;
void() M_Grenade_Touch;
void() M_Laser_Touch;
void() M_Missile_Touch;
void() M_Spike_Touch;
void() M_Arrow_Touch;

void() M_Arrow_Point;

entity(string mismodel, vector misorigin, vector misvelocity) launch_missile =
{
	local entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	setmodel (missile, mismodel);
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, misorigin);
	missile.velocity = misvelocity;
	missile.avelocity = '0 0 0';

	missile.angles = vectoangles(missile.velocity);

// sets other items according to the model
//eleminates the need for calling other setup functions all the time.
	if(mismodel == "progs/laser.mdl")
	{
		missile.classname = "laser";
		missile.movetype = MOVETYPE_FLY;
		missile.effects = EF_DIMLIGHT;
		missile.nextthink = time + 5;
		missile.attack_finished = missile.nextthink;
		missile.think = SUB_Remove;
		missile.touch = M_Laser_Touch;
		missile.ammo_shells = 15;
		missile.ammo_nails = 0;
	}
	else if(mismodel == "progs/grenade.mdl")
	{
		missile.classname = "grenade";
		missile.movetype = MOVETYPE_BOUNCE;
		missile.avelocity = '300 300 300';
		missile.think = M_Grenade_Explode;
		missile.touch = M_Grenade_Touch;
		missile.ammo_shells = 100;
		missile.ammo_nails = 0;
		missile.gravity = self.gravity;
		missile.nextthink = time + 2 + (1/missile.gravity);
		if(missile.nextthink < (time+1))
			missile.nextthink = time + 1;
		if(missile.nextthink > (time+15))
			missile.nextthink = time + 15;
		missile.attack_finished = missile.nextthink;
	}
	else if(mismodel == "progs/missile.mdl")
	{
		missile.classname = "missile";
		missile.movetype = MOVETYPE_FLY;
		missile.effects = EF_DIMLIGHT;
		missile.nextthink = time + 5;
		missile.attack_finished = missile.nextthink;
		missile.think = SUB_Remove;
		missile.touch = M_Missile_Touch;
		missile.ammo_shells = 100;
		missile.ammo_nails = 0;
	}
	else if(mismodel == "progs/lavaball.mdl")
	{
		missile.classname = "lavaball";
		missile.solid = SOLID_TRIGGER;
		missile.movetype = MOVETYPE_TOSS;
		missile.avelocity = '300 300 300';
		missile.think = M_Grenade_Explode;
		missile.touch = M_Grenade_Explode;
		missile.ammo_shells = 100;
		missile.ammo_nails = 0;
		missile.gravity = self.gravity;
		missile.effects = EF_DIMLIGHT;
		missile.nextthink = time + 2 + (1/missile.gravity);
		if(missile.nextthink < (time+1))
			missile.nextthink = time + 1;
		if(missile.nextthink > (time+15))
			missile.nextthink = time + 15;
		missile.attack_finished = missile.nextthink;
	}
	else if(mismodel == "progs/spike.mdl" || mismodel == "progs/s_spike.mdl")
	{
		missile.classname = "spike";
		missile.movetype = MOVETYPE_FLY;
		setsize (missile, '0 0 0', '0 0 0');
		missile.nextthink = time + 6;
		missile.attack_finished = missile.nextthink;
		missile.think = SUB_Remove;
		missile.touch = M_Spike_Touch;
		if(mismodel == "progs/s_spike.mdl")
			missile.ammo_shells = 18;
		else
			missile.ammo_shells = 9;
		missile.ammo_nails = 0;
	}
	else if(mismodel == "progs/k_spike.mdl" ||
		mismodel == "progs/w_spike.mdl")
	{
		if(mismodel == "progs/w_spike.mdl")
			missile.classname = "wizspike";
		else
			missile.classname = "knightspike";
		missile.movetype = MOVETYPE_FLY;
		setsize (missile, VEC_ORIGIN, VEC_ORIGIN);		
		missile.nextthink = time + 6;
		missile.attack_finished = missile.nextthink;
		missile.think = SUB_Remove;
		missile.touch = M_Spike_Touch;
		missile.ammo_shells = 9;
		missile.ammo_nails = 0;
	}
	else if(mismodel == "progs/arrow.mdl")
	{
		missile.classname = "arrow";
		missile.movetype = MOVETYPE_TOSS;
		setsize (missile, VEC_ORIGIN, VEC_ORIGIN);		
		missile.nextthink = time + 0.05;
		missile.attack_finished = time + 5;
		missile.gravity = self.gravity;
		missile.think = M_Arrow_Point;
		missile.touch = M_Arrow_Touch;
		missile.ammo_shells = 15;
		missile.ammo_nails = 5;
	}

	return missile;
};

//mostly used for monsters
void(entity missile, float basedamage, float randdamage) setdmg_missile =
{
	missile.ammo_shells = basedamage;
	missile.ammo_nails = randdamage;
};

// only needed for special occations.
void(entity missile, float misnextthink, void() misthink,
	void() mistouch, float basedamage, float randdamage) setup_missile =
{
	missile.nextthink = time + misnextthink;
	missile.think = misthink;
	missile.touch = mistouch;
	missile.ammo_shells = basedamage;
	missile.ammo_nails = randdamage;
};

void(entity missile, vector mistarget, float targeting) target_missile =
{
	local vector misvelocity;

	misvelocity = missile.velocity;

	// targeting = 1 sets a velocity twards mis_target
	// using the original x velocity for the speed.
	if(targeting == 1)
	{
		missile.velocity = normalize(mistarget - missile.origin);
		missile.velocity = missile.velocity * misvelocity_x;
	}
	// targeting = 2 is the dumb grenade targeting used by the ogres
	else if(targeting == 2)
	{
		missile.velocity = normalize(mistarget - self.origin);
		missile.velocity = missile.velocity * misvelocity_x;
		missile.velocity_z = misvelocity_z;
	}
	// targeting = 3 is for smart aiming grenades
	else if(targeting == 3)
	{
		missile.velocity = normalize((mistarget + '0 0 16') - missile.origin);
		missile.angles = vectoangles (missile.velocity);
		makevectors(missile.angles);
		missile.velocity = missile.velocity * misvelocity_x + v_up * misvelocity_z;
	}
	// targeting = 4 is used for reaiming a seeking missile
	else if(targeting == 4)
	{
		missile.velocity = normalize(mistarget - missile.origin);
		missile.velocity = missile.velocity * vlen(misvelocity);
	}
	// targeting = 5 is offset aiming like that used by the zombie master
	// uses old x vel. as speed, old y vel. as horizontal offset,
	// and old z vel. as vertical offset.
	else if(targeting == 5)
	{
		missile.velocity = mistarget - missile.origin;
		missile.angles = vectoangles(missile.velocity);
		makevectors(missile.angles);
		missile.velocity = mistarget + v_right*misvelocity_y + v_up*misvelocity_z;
		missile.velocity = normalize(missile.velocity - missile.origin);
		missile.velocity = missile.velocity * misvelocity_x;
	}

	missile.angles = vectoangles(missile.velocity);
};




//=============================================================================
//	Touch functions and other stuff
//=============================================================================

//=============================================================================
//Explosions

void() s2_explode1	=	[0,		s2_explode2]
{self.nextthink = 0.05;};
void() s2_explode2	=	[1,		s2_explode3]
{self.nextthink = 0.05;};
void() s2_explode3	=	[2,		s2_explode4]
{self.nextthink = 0.05;};
void() s2_explode4	=	[3,		s2_explode5]
{self.nextthink = 0.05;};
void() s2_explode5	=	[4,		s2_explode6]
{self.nextthink = 0.05;};
void() s2_explode6	=	[5,		s2_explode7]
{self.nextthink = 0.05;self.effects = 0;};
void() s2_explode7	=	[6,		s2_explode8]
{self.nextthink = 0.05;};
void() s2_explode8	=	[7,		s2_explode9]
{self.nextthink = 0.05;};
void() s2_explode9	=	[8,		s2_explode10]
{self.nextthink = 0.05;};
void() s2_explode10	=	[9,		s2_explode11]
{self.nextthink = 0.05;};
void() s2_explode11	=	[10,		s2_explode12]
{self.nextthink = 0.05;};
void() s2_explode12	=	[11,		s2_explode13]
{self.nextthink = 0.05;};
void() s2_explode13	=	[12,		s2_explode14]
{self.nextthink = 0.05;};
void() s2_explode14	=	[13,		s2_explode15]
{self.nextthink = 0.05;};
void() s2_explode15	=	[14,		s2_explode16]
{self.nextthink = 0.05;};
void() s2_explode16	=	[15,		s2_explode17]
{self.nextthink = 0.05;};
void() s2_explode17	=	[16,		SUB_Remove]
{self.nextthink = 0.05;};

void() s2dm_explode1	=	[1,		s2dm_explode2]{};
void() s2dm_explode2	=	[3,		s2dm_explode3]{};
void() s2dm_explode3	=	[5,		s2dm_explode4]{};
void() s2dm_explode4	=	[7,		s2dm_explode5]{};
void() s2dm_explode5	=	[9,		s2dm_explode6]{};
void() s2dm_explode6	=	[11,		s2dm_explode7]{};
void() s2dm_explode7	=	[13,		s2dm_explode8]{};
void() s2dm_explode8	=	[15,		SUB_Remove]{};

void() BecomeBigExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/expl.spr");
	self.solid = SOLID_NOT;
	if(deathmatch)
		s2dm_explode1();
	else
		s2_explode1();
};

//=============================================================================
//Grenades

void() M_Grenade_Explode =
{
	local float totaldmg;

	totaldmg = self.ammo_shells + random() * self.ammo_nails;

	T_RadiusDamage (self, self.owner, totaldmg, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() M_Grenade_Touch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		M_Grenade_Explode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

//=============================================================================
//Lasers

void() M_Laser_Touch =
{
	local float totaldmg;
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	totaldmg = self.ammo_shells + random() * self.ammo_nails;
	if((self.ammo_shells + self.ammo_nails) == 0)
		totaldmg = 15;
	
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		if((other.flags & FL_CLIENT) || (other.flags & FL_MONSTER))
			SpawnBlood (org, self.velocity*0.2, totaldmg, other);
		T_Damage (other, self, self.owner, totaldmg);
	}
	else
	{
		sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	
	remove(self);	
};

//=============================================================================
//Missiles

void() M_Missile_Touch =
{
	local float	totaldmg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	totaldmg = self.ammo_shells + random() * self.ammo_nails;
	
	if (other.health)
	{
		if(self.owner.classname == "monster_shalrath")
		{
			if (other.classname == "monster_zombie")
				T_Damage (other, self, self, 110);
			else if(other.classname == "monster_axzombie")
				T_Damage (other, self, self.owner, 200);
		}
		else if (other.classname == "monster_shambler")
			T_Damage (other, self, self.owner, totaldmg*0.5+10);
		else
			T_Damage (other, self, self.owner, totaldmg+20);
	}
	else if(self.classname == "pulse")
	{
		sound (self,CHAN_VOICE,"enforcer/enfstop.wav", 1,ATTN_STATIC);
		remove(self);
		return;
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	if(self.owner.classname == "monster_shalrath")
		T_RadiusDamage (self, self.owner, totaldmg, world);
	else
		T_RadiusDamage (self, self.owner, totaldmg, other);

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	BecomeBigExplosion ();
};

//=============================================================================
//Spikes

void() M_Spike_Touch =
{
	local float rand, totaldmg;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		totaldmg = self.ammo_shells + random() * self.ammo_nails;
		T_Damage (other, self, self.owner, totaldmg);
		spawn_touchblood (totaldmg, other);

		remove(self);
		return;
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	if(self.classname == "dspike" && random() < 0.33)
	{
		remove(self);
		return;
	}

	remove(self);
};

//=============================================================================
//Arrows

void() M_Arrow_Point =
{
	self.nextthink = time + 0.05;
	self.angles = vectoangles(self.velocity);
};

void() M_Arrow_Touch =
{
	local float rand, totaldmg;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		sound (other, CHAN_BODY, "weapons/arrowhit.wav", 1, ATTN_NORM);

		totaldmg = self.ammo_shells + random() * self.ammo_nails;
		if((other.flags & FL_CLIENT) || (other.flags & FL_MONSTER))
			spawn_touchblood (totaldmg, other);
		T_Damage (other, self, self.owner, totaldmg);

		remove(self);
		return;
	}

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_SPIKE);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.nextthink = time + 1 + random()*1;
	self.think = SUB_Remove;
};
