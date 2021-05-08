void () hgren_precache =
 {
   precache_model2("progs/v_gren.mdl");
   precache_sound2("weapons/gpull.wav");
   precache_sound2("doors/airdoor2.wav");
 };

void() HandGrenadeTouch =
{
      local float rand;
     
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
//		M16GrenadeExplode();
            self.velocity = self.velocity * 0.3;
		return;
	}
      
      rand = random();
      if (rand < 0.333)
       { 
    	  sound (self, CHAN_WEAPON, "weapons/gbounce1.wav", 1, ATTN_NORM);	// bounce sound
       }
      if ( (rand < 0.666) && (rand >= 0.333) )
       {
        sound (self, CHAN_WEAPON, "weapons/gbounce2.wav", 1, ATTN_NORM);
       }
      if (rand >= 0.666) 
       {
        sound (self, CHAN_WEAPON, "weapons/gbounce3.wav", 1, ATTN_NORM);
       }
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void() FlashExplode =
{
	T_RadiusDamage (self, self.owner, 20, other);
	T_FlashDamage (self, self.owner,1000, self);

        sound (self, CHAN_WEAPON, "doors/airdoor2.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
	

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};


void() W_FireHandGrenade =
{
	local	entity missile, mpuff;
	
	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*(20 * self.grenadetime) + v_up * 200 +                         crandom()*v_right*10 + crandom()*v_up*30;
	else
	{
		missile.velocity = aim(self, 10000);
            missile.velocity = missile.velocity * (20 * self.grenadetime) +
            '0 0 -300';
		missile.velocity_z = 30;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = HandGrenadeTouch;

// set missile duration
// NAVY SEALs sQuad bots addition
	//missile.nextthink = time + 3;
	//missile.think = M16GrenadeExplode;
	//if (self.grenadetype == 0) missile.think = M16GrenadeExplode;
        //else if (self.grenadetype == 1) missile.think = FlashExplode;
  missile.search_time = time + 3.0;
  missile.nextthink   = time + 0.1;
  missile.grenadetype = self.grenadetype;
  missile.think       = W_PredictMissileDestination;
// end - NAVY SEALs sQuad bots addition
        self.hgrenadefired = TRUE;
        setmodel (missile, "progs/m16gren.mdl");
	setsize (missile, '0 0 0', '1 1 1');
	setorigin (missile, self.origin + (v_forward * 40.000) - (v_right * 11.000) + (v_up *    11.000));

};


