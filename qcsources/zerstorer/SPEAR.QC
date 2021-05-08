void() SpearRemove;

void() SpearHitMonster =
{
	if (self.enemy.health <= 0)
	{
		SpearRemove();
		return;
	}
	self.velocity = self.mangle;
	self.enemy.flags = self.enemy.flags - FL_ONGROUND;
	self.enemy.velocity = self.mangle;
	self.enemy.frame = self.frame;
	setorigin(self, (self.enemy.origin - self.oldorigin));
	
	self.nextthink = time + 0.01;
};

/* --------------------------- */
/* |  Called from client.qc  | */
/* |  self == player	     | */
/* |  self.aiment == spear   | */
/* --------------------------- */
void() SpearHitPlayer =
{
	if (self.health <= 0)
	{
		self = self.aiment;
		SpearRemove();
		return;
	}
	self.velocity = self.aiment.mangle;
	self.aiment.velocity = self.aiment.mangle;
	if(self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() SpearRemove =
{
	if (self.enemy.flags & FL_MONSTER)
	if (self.enemy.health > 0)
	{
		self.enemy.movetype = self.cnt;
		self.enemy.enemy = self.aiment;
		self.enemy.think = self.think1;
		self.enemy.th_pain();
		self.enemy.nextthink = time + 0.1;
	}
	if(self.enemy)
		self.enemy.impaled = 0;

	setsize(self, '0 0 0', '0 0 0');
	self.movetype = MOVETYPE_TOSS;
	self.think = SUB_Remove;
	self.nextthink = time + 1;
};

void() ImpaledTouch =
{
	if(self.velocity == '0 0 0')
		return;
	dprint("ImpaledTouch\n");
	if(other.health)
		return;
	if(other.movetype == MOVETYPE_PUSH)
	if(vlen(other.velocity) > 0)
	{
		self.mangle = other.velocity;
		self.velocity = other.velocity;
		self.enemy.velocity = other.velocity;
		self.think = SpearRemove;
		self.nextthink = time + 3;
		return;
	}
	dprint("Setting velocities to 0\n");

	setorigin(self, (self.enemy.origin - self.oldorigin));
	//setorigin(self, self.enemy.origin);

	self.velocity = '0 0 0';
	self.mangle = '0 0 0';
	self.enemy.velocity = '0 0 0';
	self.enemy.solid = SOLID_BBOX;

	self.solid = SOLID_NOT;
	self.think = SpearRemove;
	self.nextthink = time + 3;
};

void() SpearTouch =
{
	if (other == self.owner)
		return;		// don't impale owner
	if (self.velocity == '0 0 0')
		return;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.solid == SOLID_BSP && other.health > 0)
	{
		dprint("Spear hit SOLID_BSP with health!\n");
		if(other.health)
			T_Damage (other, self, self.owner, 15);	
		self.velocity = '0 0 0';
		self.think = SpearRemove;
		self.nextthink = time + 2;
		return;
	}
	if (other.health)
	{
		dprint(other.classname);dprint(" was speared!\n");	
		T_Damage (other, self, self.owner, 25);
		particle (self.origin,(self.owner.origin - self.origin),73,30);
		//makevectors(self.velocity);
		//traceline(self.origin, (v_forward*16), TRUE, world);
		if (other.health < 10) // || trace_fraction < 1)
		{
			self.movetype = MOVETYPE_TOSS;
			self.nextthink = time + 1;
			self.think = SUB_Remove;
			return;
		}
		other.impaled = 1;
		self.origin_x = other.origin_x;
		self.origin_y = other.origin_y;
		if(self.origin_z > other.origin_z + 32)
			self.origin_z = other.origin_z + 32;
		if(self.origin_z < other.origin_z - 32)
			self.origin_z = other.origin_z - 32;
		setorigin(self, self.origin);
		self.oldorigin = other.origin - self.origin;
		if (self.velocity_z < 2)
		 //if (self.velocity_z > -5)
		 {
			self.velocity_z = 2;
			dprint(vtos(self.velocity));dprint(" = adjusted spear velocity\n");
			self.mangle_z = 2;
		 }
		//self.solid = SOLID_NOT;
		if (other.classname == "player")
		{
			dprint("Spear hit player\n");
			other.aiment = self;
			setorigin(other, other.origin + '0 0 2');
			if(other.flags & FL_ONGROUND)
				other.flags = other.flags - FL_ONGROUND;
			other.velocity = self.velocity;

			self.enemy = other;
			setsize(self, '-2 -2 -2', '2 2 2');	//Big clip
			self.touch = ImpaledTouch;		//new touch function
			self.frame = other.frame;
			//remove(self);
			return;
		}
		self.enemy = other;
		self.think1 = other.think;
		other.think = SUB_Null;
		self.aiment = other.enemy;
		other.enemy = world;
		self.frame = other.frame;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_FLY;
		setorigin(other, other.origin + '0 0 3');
		//setsize(self, '0 0 0', '0 0 0');	//monster clipping
		self.touch = ImpaledTouch;		//new touch function
		other.flags = other.flags - FL_ONGROUND;
		self.cnt = other.movetype;
		other.velocity = self.mangle;
		self.velocity = self.mangle;
		self.think = SpearHitMonster;
		self.nextthink = time + 0.01;
		return;
	}

	dprint("Spear hit wall!\n");
	self.velocity = '0 0 0';
	self.nextthink = time + 5;
	self.think = SpearRemove;
};


void () W_FireSpear =
{
      sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	
      newmis = spawn();
      newmis.movetype = MOVETYPE_FLYMISSILE;
      newmis.solid = SOLID_BBOX;
      newmis.owner = self; 
      newmis.classname = "spear";

      makevectors (self.v_angle);
	newmis.velocity = aim(self, 800);
      newmis.velocity = newmis.velocity * 800;
	newmis.mangle = newmis.velocity;	//backup for copying
	newmis.angles = vectoangles(newmis.velocity);

      newmis.touch = SpearTouch;

	setmodel (newmis,"progs/spear.mdl");
      setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
      setsize(newmis, '0 0 0' , '0 0 0');

	//self.think = SUB_Remove;
	//self.nextthink = time + 7;
};
