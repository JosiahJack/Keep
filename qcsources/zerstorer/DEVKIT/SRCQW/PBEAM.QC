$cd /raid/quake/id1/models/stunner
$origin 0 0 24
$base base
$skin skin

void() PlasmaExplode =
{
local vector	pgo;

	//T_RadiusDamage (self, self.owner, 60, world);
	//sound (self, CHAN_VOICE, "weapons/pc_exp.wav", 1, ATTN_NORM);

/* Not in QW you don't!! 
	//custom explode particle effect
	makevectors(self.velocity);
	pgo = v_up*100;
	particle(self.origin, pgo, 47, 40);
	particle(self.origin, -1 *pgo, 47, 40);
	pgo = v_right*100;
	particle(self.origin, pgo, 47, 40);
	particle(self.origin, -1 *pgo, 47, 40);
	pgo = v_forward*100;
	particle(self.origin, pgo, 47, 40);
	particle(self.origin, -1 *pgo, 47, 40);
	pgo = pgo + v_up*100;
	particle(self.origin, pgo, 223, 40);
	particle(self.origin, -1 *pgo, 223, 40);
	pgo = pgo - v_forward*200;
	particle(self.origin, pgo, 223, 40);
	particle(self.origin, -1 *pgo, 223, 40);
	pgo = pgo - v_up*200;
	particle(self.origin, pgo, 223, 40);
	particle(self.origin, -1 *pgo, 223, 40);
	pgo = v_forward*100 + v_right*100;
	particle(self.origin, pgo, 223, 40);
	particle(self.origin, -1 *pgo, 223, 40);
	pgo = pgo - v_right*200;
	particle(self.origin, pgo, 223, 40);
	particle(self.origin, -1 *pgo, 223, 40);
*/

	WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
	WriteByte (MSG_MULTICAST, TE_EXPLOSION);
	WriteCoord (MSG_MULTICAST, self.origin_x);
	WriteCoord (MSG_MULTICAST, self.origin_y);
	WriteCoord (MSG_MULTICAST, self.origin_z);
	multicast (self.origin, MULTICAST_PHS);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");

//DHM - fix for trigger_gravity movement
	self.movetype = MOVETYPE_FLYMISSILE;

	self.solid = SOLID_NOT;
	//s_explode1 ();
	self.think = SUB_Remove;
	self.nextthink = time + 0.05;
};

void() T_SREThink =
{
	if (self.flags & FL_ONGROUND)
      	self.flags = self.flags - FL_ONGROUND;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.velocity = normalize(self.velocity) * self.speed;
	self.angles = vectoangles(self.velocity);
	self.count = self.count + 1;
};

void() T_PbeamTouch =
{
	local float	damg, courage = 0;
	local vector oldvel, spot1, spot2;
	local entity temp;

	//if (other == self.owner)
		//return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.health && other.takedamage)
	{
	   if(other.items2 & IT2_ARMOR4)
	   {
		temp = self;
		self = other;
		if (infront(temp))
			courage = 1;
		self = temp;
	   }
	   if (!(courage))
	   {
		other.deathtype = "srebomb";
		T_Damage (other, self, self.owner, 50);
		T_RadiusDamage (self, self.owner, 65, other, "srebomb");
		self.owner.lip = 0;
		self.owner.attack_finished = time + 0.6;
		PlasmaExplode ();
		remove(self);
		return;
	   }
	}
	else if (self.count == 2)
	{
	   T_RadiusDamage (self, self.owner, 70, world, "srebomb");
	   self.owner.lip = 0;
	   self.owner.attack_finished = time + 0.6;
 	   PlasmaExplode ();
	   remove(self);
	   return;
	}

      self.speed = vlen(self.velocity) * 0.75;
      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;
	self.movetype = MOVETYPE_BOUNCE;

	sound (self, CHAN_WEAPON, "hknight/hit.wav", 1, ATTN_NORM);

	self.think = T_SREThink;
	self.nextthink = time + 0.01;
};

void() F_Detonate =
{
local entity temp;

	temp = self;
	self = temp.movetarget;

	T_RadiusDamage (self, self.owner, 120, world, "srebomb");

	PlasmaExplode ();
	remove(self);

	self = temp;

	self.lip = 0;
};

void() W_FireStunner =
{
	local float pspeed;
	local	entity missile, mpuff;
	local vector back;
	
	if (self.currentammo < 1)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/stunfire.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

//dhm - if shot in the air - do Newton's 3rd law.
	if (!(self.flags & FL_ONGROUND))
		self.velocity = self.velocity - (v_forward * 40);

	self.currentammo = self.ammo_rockets = self.ammo_rockets -  1;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";

	missile.waitmax = self.waitmax;
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.speed = 1000;
	missile.oldorigin = missile.velocity;
	missile.angles = vectoangles(missile.velocity);
	missile.frame = 0;
	
	missile.touch = T_PbeamTouch;
	missile.count = 0;	//bounce counter

	setmodel (missile, "progs/stunner.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

	self.movetarget = missile;
};
