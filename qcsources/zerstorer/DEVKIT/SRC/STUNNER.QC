$cd /raid/quake/id1/models/stunner
$origin 0 0 24
$base base
$skin skin

/*

ftp.killme.com
killme
xoj4bcq12

www.killme.com/cgi-bin/cgiwrap/killme/wwwboard.pl
bongo
thekook

Killme's phone number.  (Brandon)
<kandyman>	913-841-1693 home 
<kandyman>	(913)841-4294 battlezone (confirmed)
*/

void() StunAnimate  =[	0,	StunAnimate2	] {};
void() StunAnimate2 =[	1,	StunAnimate3	] {};
void() StunAnimate3 =[	2,	StunAnimate4	] {};
void() StunAnimate4 =[	3,	StunAnimate5	] {};
void() StunAnimate5 =[	4,	StunAnimate6	] {};
void() StunAnimate6 =[	5,	StunAnimate7	] {};
void() StunAnimate7 =[	6,	StunAnimate8	] {};
void() StunAnimate8 =[	7,	StunAnimate9	] {};
void() StunAnimate9 =[	8,	StunAnimate10	] {};
void() StunAnimate10 =[	9,	StunAnimate		] {};

void(entity inflictor, entity ignoreme, float damage) StunRadius =
{
	local	float 	points, S_Radius;
	local	entity	head;
	local	vector	org;

	S_Radius = 80;	// * The radius of the stun circle *

	head = findradius(inflictor.origin, S_Radius);
	while (head)
	{
		if (head != ignoreme)
		{
			if (head.takedamage)
			{
				if (head.flags & FL_MONSTER)
					head.nextthink = 0;
				else if (head.flags & FL_CLIENT)
				{
				 org = head.origin + (head.mins + head.maxs)*0.5;
				 points = (S_Radius - vlen (inflictor.origin - org)) / S_Radius;
				 if (points < 0)
					points = 0;
				 if (points > 1)
					points = 1;
				 points = damage * points;
				 dprint(ftos(points));dprint(" = secs stunned\n");
				 head.pausetime = head.stunned = time + points;
				}
				else
					dprint("non-living entity in stun-radius\n");
			}
		}
		head = head.chain;
	}
};

void(entity ignoreme) StunExplode =
{
	StunRadius(self, ignoreme, 5);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	remove(self);
};

void() T_StunThink =
{
local float delta;

	if (time > self.attack_finished)
      {
		//remove(self);
		StunExplode(world);
      	return;
 	}
	if (self.flags & FL_ONGROUND)
      	self.flags = self.flags - FL_ONGROUND;
	self.velocity = self.oldorigin;
	StunAnimate();
};

void() T_StunTouch =
{
local entity oldself;
local vector oldvel, org, spot1, spot2;

	if (other == self.owner)
	 if (self.count > time)
	 {
		//dprint(ftos(self.count));dprint(" = count\n");
		//dprint(ftos(time));dprint(" = time\n");
		return;		// don't explode on owner
	 }

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.health && other.takedamage)
	{
	 if (other.flags & FL_CLIENT)
	  if (other.items2 & IT2_ARMOR4) 
	  {
		dprint("Hit player with courage armor!\n");
		oldself = self;
		self = other;
		if (!(infront(oldself)))
		{
			dprint("stun player\n");
			self = oldself;
			other.pausetime = other.stunned = time + 5;
			StunExplode(other);
			return;
		}
		else
		{
			dprint("courage armor blocked stun\n");
			other.armorvalue = other.armorvalue - 10;
			if (other.armorvalue <= 0)
				other.items2 = other.items2 - (other.items2 & IT2_ARMOR4);
			StunExplode(other);
			return;
		}			
		self = oldself;
	  }
	  else {
	 	dprint("stun player\n");
		self = oldself;
		other.pausetime = other.stunned = time + 5;
		StunExplode(other);
		return;
	  }
	 if (other.flags & FL_MONSTER)
	 {
		dprint("Hit monster!\n");
		other.nextthink = time + 5;
		StunExplode(other);
		return;
	 }
	}
	//dprint("Hit inanimate object!\n");

	oldvel = normalize(self.oldorigin);
	spot1 = self.origin - (16*oldvel);
	spot2 = self.origin + (16*oldvel);
	traceline (spot1, spot2, FALSE, self);  // see through other monsters
	self.origin = trace_endpos;
	org = self.origin;
	//dprint(vtos(oldvel));dprint(" = oldvel\n");
	//dprint(vtos(trace_plane_normal));dprint(" = t_plane_normal\n");
      self.velocity = oldvel + (2 * trace_plane_normal);
	//dprint(vtos(self.velocity));dprint(" = new velocity vector\n");
      self.velocity = normalize(self.velocity);
	//dprint(vtos(self.velocity));dprint(" = new velocity normal\n");
      self.velocity = self.speed * self.velocity;
      self.oldorigin = self.velocity;
      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;

	sound (self, CHAN_WEAPON, "hknight/hit.wav", 1, ATTN_NORM);

	self.think = T_StunThink;
	self.nextthink = time + 0.01;
	//StunExplode(world);
};

void() W_FireStunner =
{
	local	entity missile, mpuff;
	local vector back;
	
	if (self.currentammo < 15)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		return;
	}

	self.currentammo = self.ammo_cells = self.ammo_cells - 15;
	
	sound (self, CHAN_WEAPON, "weapons/stunfire.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

//dhm - if shot in the air - do Newton's 2nd law.
	if (!(self.flags & FL_ONGROUND))
	{
		back = self.origin - (self.origin + v_forward*20);
		back = normalize(back);
		self.velocity = self.velocity + (back * 40);
	}

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "stun";
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 270);
	missile.velocity = missile.velocity * 270;
	missile.speed = 270;
	missile.oldorigin = missile.velocity;
	missile.angles = vectoangles(missile.velocity);
	//missile.avelocity = '20 40 80';
	missile.frame = 0;
	
	missile.touch = T_StunTouch;
	
// set missile duration
	missile.attack_finished = time + 5;
	missile.count = time + 0.5;
	missile.nextthink = time + 0.1;
	missile.think = StunAnimate;

	setmodel (missile, "progs/stunner.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

	if (self.currentammo < 15)
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
	}
};
