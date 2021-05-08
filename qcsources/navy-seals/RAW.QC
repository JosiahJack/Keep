void () raw_precache =
 {
   precache_model2("progs/v_m16raw.mdl");
   precache_model2("progs/raw.mdl");
 };

void() BecomeRawExplosion =
{
   

	self.movetype = MOVETYPE_NONE;
      self.angles = '0 0 0';
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/explode.mdl");
	self.solid = SOLID_NOT;


	m16_explode1 ();      
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RawRadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;
        local   float temp;
        local   float grange;

	head = findradius(inflictor.origin, damage+200);
	
	while (head)
	{
	//	if (head != ignore)
      //	{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.25*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")						
							T_Damage (head, inflictor, attacker, points*0.5);
						else {
							T_Damage (head, inflictor, attacker, points);
                                          head.flags = head.flags - FL_ONGROUND;  						     	temp = vlen(org - inflictor.origin);
                                          if ( ( temp < 60) && (temp >= 0) )
 							 {grange = 15;}
                                          if ( (temp < 120) && (temp >= 60) )
							 {grange = 9;}
                                          if ( (temp < 180) && (temp >= 120) )
							 {grange = 5;}
                                          if ( (temp < 240) && (temp >= 180) )
							 {grange = 3;}
                                          if (temp >= 240) 
							 {grange = 1.5;}
   						      head.velocity = (org - inflictor.origin) * grange;
							Shoot_Blood(org,head.velocity * 100);
                                          head.velocity_z = 150 + (grange * 20);           					
                                         }
					}
				}
			}
	//	}
		head = head.chain;
	}
};


void() RawExplode =
{
	T_RawRadiusDamage (self, self.owner, 100, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeM16Explosion ();
};

void() RawTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 200 + random()*20;
	
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	RawExplode();
		return;
};

/*
================
W_FireRaw
================
*/
void() W_FireRaw =
{
	local	entity missile, mpuff;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
      missile.classname = "raw";
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = RawTouch;	
// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/raw.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + (v_forward * 10.000) - (v_right * 21.000) + (v_up * 3.000));

};
