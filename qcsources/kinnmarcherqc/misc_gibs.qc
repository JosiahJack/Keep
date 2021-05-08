/*
=================

GIBS

(used to be in player.qc)

=================
*/

vector(float dm) VelocityForDamage =
{
	local vector v;

//MED 01/17/97
// ben - 17/04/03 - this ain't all that good...
   	if (vlen(damage_inflictor.velocity)>0)
      	{
		v = 0.2 * damage_inflictor.velocity;
		v = v + (25 * normalize(self.origin-damage_inflictor.origin));
		v_z = 100 + 100 * random();
		v_x = v_x + (50 * crandom());
		v_y = v_y + (50 * crandom());
      	}
   	else
      	{
		v_x = 100 * crandom();
		v_y = 100 * crandom();
		v_z = 200 + 100 * random();
      	}
   	if (dm > -50)
   	{
	//    dprint ("level 1\n");
      	v = v * 0.7;
   	}
   	else if (dm > -200)
   	{
	//    dprint ("level 3\n");
      	v = v * 2;
   	}
   	else
      	v = v * 10;
   	return v;
};


void() BDW_BodyDropSound =
{
	if (!gameflags1 & GF1_IMPACTS)
		return;

	local float r;
	r = random();
	
	if (r < 0.33)
		sound(self, CHAN_BODY, "misc/boddrop1.wav", 0.7, ATTN_NORM);
	else if (r < 0.66)
		sound(self, CHAN_BODY, "misc/boddrop2.wav", 0.7, ATTN_NORM);
	else
		sound(self, CHAN_BODY, "misc/boddrop3.wav", 0.7, ATTN_NORM);		
};

//BDW 13/07/01
void() BDW_GibSound =
{
	if (!gameflags1 & GF1_ALT_GIBS)
	{
		if (self.axhitme == 2)
			sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NORM);	//bdw hack to play different gib sound if sicklegibbed
		else	
			sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
			
		return;
	}

	local float rnd;
	local string str;

	rnd = random() * 5;

	if (rnd < 1)
		str = "gibs/gib1.wav";
	else if (rnd < 2)
		str = "gibs/gib2.wav";
	else if (rnd < 3)
		str = "gibs/gib3.wav";
	else if (rnd < 4)
		str = "gibs/gib4.wav";
	else
		str = "gibs/gib5.wav";

	sound(self, CHAN_VOICE, str, 1, ATTN_NORM);
};

//BDW 28/08/00
void() BDW_GibTouch =
{
	local string str;
	local float rnd, vol, chan;

	if (other.solid == SOLID_TRIGGER)
		return;

// occasionally gibs get stuck in solid geometry, and start blowing raspberries...
	if (pointcontents(self.origin) == CONTENT_SOLID)
	{
		//dprint("in solid\n");
		return;
	}		

// stop gibs from making noises when on platforms...
	//if (!(other == world))
	//	return;

	if (self.worldtype == GIB_METAL)
	{
		
		rnd = random()*2;
		//if (rnd < 1)
		//	str = "debris/metal1.wav";
		if (rnd < 1)
			str = "debris/metal2.wav";
		else
			str = "debris/metal3.wav";

		chan = CHAN_AUTO;
		vol = 0.5;
	}
	else
	{
		rnd = random()*5;
		if (rnd < 1)
			str = "gibs/gibhit1.wav";
		else if (rnd < 2)
			str = "gibs/gibhit2.wav";
		else if (rnd < 3)
			str = "gibs/gibhit3.wav";
		else if (rnd < 4)
			str = "gibs/gibhit4.wav";
		else
			str = "gibs/gibhit5.wav";

		chan = CHAN_BODY;
		vol = 1;
	}

	sound(self, chan, str, vol, ATTN_STATIC);

// CHAN_BODY so as not to interfere with normal gib noise (heads only)...
	//sound(self, CHAN_BODY, sname, vol, ATTN_NORM);

	if (self.velocity == '0 0 0')
	{
		if (other.solid == SOLID_SLIDEBOX)		// don't let gib come to rest on a monster
		{
			self.velocity_x = 100 * crandom();
			self.velocity_y = 100 * crandom();
			self.velocity_z = 200 + 100 * random();
		}
		else	
			self.touch = SUB_Null;
	}
};

void(string gibname, float dm, float gib_type) ThrowGib =
{
	local	entity new;
	local vector org;
	
	//bdw - lovely hack to make sickle gibs always low velocity, not matter how much damage was applied
	if (self.axhitme == 2)	//took a sickle hit
		dm = 0;

// BDW - spawn gib somewher inside bbox...
// TODO: look at chaos gib code
	org_x = self.absmin_x + random()*(self.maxs_x - self.mins_x);
	org_y = self.absmin_y + random()*(self.maxs_y - self.mins_y);	
	org_z = self.absmin_z + random()*(self.maxs_z - self.mins_z);
	//org = self.origin;

	new = spawn();
	new.classname = "gib";
	//new.origin = self.origin;	
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	
//BDW 28/08/00 - change to solid to hear sounds if in alt gibmode, or metal gibs
	if ((gib_type == GIB_METAL) || (gameflags1 & GF1_ALT_GIBS))
	{
		new.solid = SOLID_BBOX;		
		new.touch = BDW_GibTouch;	//a touch function to make sound on impact...
	}
	else
	{
		new.solid = SOLID_NOT;

	}	

	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 5 + random()*5;	// ben - shortened this
	new.frame = 0;
	new.flags = FL_NOSELECT;	//ent selector ignore

	new.worldtype = gib_type;	// ben - flesh, metal etc.

	setmodel(new, gibname);
	setsize(new, '0 0 0', '0 0 0');
	setorigin(new, org);
};

//MED
/*
void() HeadThink =
{
   	self.nextthink = -1;
   	if (world.worldtype != 2)
      {
      	if (random() < 0.1)
         		sound (self, 6, "misc/flys.wav", 0.7, ATTN_STATIC);
      }
};
*/

void(string gibname, float dm) ThrowHead =
{
	self.frame = 0;
   	//self.nextthink = time + 1.5;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
// BDW 28/08/00 - splat noise for monsters...
// change this so that clients also make splat
	if (self.flags & FL_MONSTER)
	{
		self.flags = self.flags - FL_MONSTER;	//bdw - don't confuse with a corpse
		
		if (gameflags1 & GF1_ALT_GIBS)
		{
			self.solid = SOLID_BBOX;		
			self.touch = BDW_GibTouch;	//a touch function to make sound on impact...			
		}
		else
		{
			self.solid = SOLID_NOT;		
		}		
		
		self.think = SUB_Remove;
		self.nextthink = time + 5 + random()*5;			
	}
	else
	{
		self.solid = SOLID_NOT;
		self.nextthink = -1;
	}
	
	//bdw - lovely hack to make sickle gibs always low velocity, not matter how much damage was applied
	if (self.axhitme == 2)	//took a sickle hit
		dm = 0;
	
	self.velocity = VelocityForDamage (dm);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
//MED
   	//self.gorging = TRUE;
   	//self.think = HeadThink;
	
	setmodel(self, gibname);
	setsize(self, '0 0 0', '0 0 0');
	setorigin(self, self.origin + self.view_ofs);

	self.view_ofs = '0 0 8';
};

/*
===================

MONSTER GIB

===================
*/

//fish, spiders...
void(string headgib) MonsterGibTiny =
{
	//BDW_GibSound();
	
	sound(self, CHAN_VOICE, "player/tornoff2.wav", 1, ATTN_NORM);
	
	ThrowGib("progs/newgib4.mdl", self.health, GIB_FLESH);
	ThrowGib("progs/gib3.mdl", self.health, GIB_FLESH);			
	
	ThrowHead(headgib, self.health);
};

//knights, grunts etc.
void(string headgib) MonsterGibSmall =
{
	BDW_GibSound();
	
	if (gameflags1 & GF1_ALT_GIBS)
	{
		ThrowGib("progs/newgib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib2.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib3.mdl", self.health, GIB_FLESH);	
	}
	else
	{
		ThrowGib("progs/gib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib3.mdl", self.health, GIB_FLESH);	
	}		
	
	ThrowHead(headgib, self.health);
};

// most normal sized monsters
void(string headgib) MonsterGibMedium =
{
	BDW_GibSound();
	
	if (gameflags1 & GF1_ALT_GIBS)
	{
		ThrowGib("progs/newgib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib2.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib3.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib4.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib4.mdl", self.health, GIB_FLESH);
	}
	else
	{
		ThrowGib("progs/gib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib2.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib3.mdl", self.health, GIB_FLESH);		
	}	
	
	ThrowHead(headgib, self.health);
};

// large monsters - shamblers, gaurochs
void(string headgib) MonsterGibLarge =
{
	BDW_GibSound();
	
	if (gameflags1 & GF1_ALT_GIBS)
	{
		ThrowGib("progs/newgib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib2.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib3.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib3.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib4.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib4.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/newgib4.mdl", self.health, GIB_FLESH);
	}
	else
	{
		ThrowGib("progs/gib1.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib2.mdl", self.health, GIB_FLESH);
		ThrowGib("progs/gib3.mdl", self.health, GIB_FLESH);	
		ThrowGib("progs/gib3.mdl", self.health, GIB_FLESH);
	}
	
	ThrowHead(headgib, self.health);
};




