
void () m16_precache =
 {
   precache_model2("progs/v_m16.mdl");
   precache_model2("progs/explode.mdl");
   precache_model2("progs/m16gren.mdl");
   precache_sound2("weapons/m16fire.wav");
   precache_model2("progs/shrap.mdl");
   precache_sound2("weapons/m16gren.wav");
   precache_sound2("weapons/grenlaun.wav");
   precache_sound2("weapons/gbounce1.wav");
   precache_sound2("weapons/gbounce2.wav");
   precache_sound2("weapons/gbounce3.wav");
 };


/*
================
W_FireGrenade
================
*/

void()	m16_explode1	=	[0,		m16_explode2] {
            self.nextthink = time + 0.02;
            sound(self,CHAN_WEAPON,"weapons/m16gren.wav",TRUE,ATTN_NORM);};
void()	m16_explode2	=	[1,		m16_explode3] {self.nextthink = time + 0.02;};
void()	m16_explode3	=	[2,		m16_explode4] {self.nextthink = time + 0.02;};
void()	m16_explode4	=	[3,		m16_explode5] {self.nextthink = time + 0.02;};
void()	m16_explode5	=	[4,		m16_explode6] {self.nextthink = time + 0.02;};
void()	m16_explode6	=	[5,		m16_explode7] {self.nextthink = time + 0.02;};
void()	m16_explode7	=	[6,		m16_explode8] {self.nextthink = time + 0.02;};
void()	m16_explode8	=	[7,		m16_explode9] {self.nextthink = time + 0.02;};
void()	m16_explode9	=	[8,		m16_explode10] {self.nextthink = time + 0.03;};
void()	m16_explode10     =     [9,		m16_explode11] {self.nextthink = time + 0.03;};
void()	m16_explode11	=	[10,		m16_explode12] {self.nextthink = time + 0.03;};
void()	m16_explode12	=	[11,	      m16_explode13] {self.nextthink = time + 0.03;};
void()	m16_explode13	=	[12,		m16_explode14] {self.nextthink = time + 0.03;};
void()	m16_explode14	=	[13,		m16_explode15] {self.nextthink = time + 0.03;};
void()	m16_explode15	=	[14,		m16_explode16] {self.nextthink = time + 0.03;};
void()	m16_explode16	=	[15,		m16_explode17] {self.nextthink = time + 0.03;};
void()	m16_explode17	=	[16,		SUB_Remove] {self.nextthink = time + 0.03;};


void() shrapnel_touch =
{
local float rand;
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
            makevectors(self.v_angle);
            Shoot_Blood (other.origin,v_forward * 2000);
                T_Damage (other, self, self, 20);
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

	remove(self);

};


void(vector org, vector dir) shoot_shrapnel =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
        newmis.classname = "shrapnel";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 1.5;
	setmodel (newmis, "progs/shrap.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.velocity = dir * 3;
};


void() BecomeM16Explosion =
{

      local vector shrapdir;

	self.movetype = MOVETYPE_NONE;
      self.angles = '0 0 0';
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/explode.mdl");
	self.solid = SOLID_NOT;

      shrapdir_x = 0 - (random() * 200);
      shrapdir_y = 0 - (random() * 200);
      shrapdir_z = (random() * 200);
      shoot_shrapnel(self.origin , shrapdir);
      shrapdir_x = 0 - (random() * 200);
      shrapdir_y = 0 - (random() * 200);
      shrapdir_z = (random() * 200);
      shoot_shrapnel(self.origin , shrapdir);
      shrapdir_x = 0 - (random() * 200);
      shrapdir_y = 0 - (random() * 200);
      shrapdir_z = (random() * 200);
      shoot_shrapnel(self.origin , shrapdir);
      shrapdir_x = (random() * 200);
      shrapdir_y = (random() * 200);
      shrapdir_z = (random() * 200);
      shoot_shrapnel(self.origin , shrapdir);
      shrapdir_x = (random() * 200);
      shrapdir_y = (random() * 200);
      shrapdir_z = (random() * 200);
      shoot_shrapnel(self.origin , shrapdir);

	m16_explode1 ();
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_M16RadiusDamage =
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
                                          if (head.flags & FL_MONSTER || head.classname == "player" || head.classname == "bot")
                                          {
                                            head.flags = head.flags - FL_ONGROUND;                                                        temp = vlen(org - inflictor.origin);
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
			}
	//	}
		head = head.chain;
	}
};


void() M16GrenadeExplode =
{
	T_M16RadiusDamage (self, self.owner, 100, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeM16Explosion ();
};

void() M16GrenadeTouch =
{
      local float rand;

	if (other == self.owner)
		return;		// don't explode on owner



	if ( (other.takedamage == DAMAGE_AIM) || ( (time - self.lastshot) > 0.5) )
	{
		M16GrenadeExplode();
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


void() W_FireM16Grenade =
{
	local	entity missile, mpuff;
	
	sound (self, CHAN_WEAPON, "weapons/grenlaun.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

      
	missile = spawn ();
      missile.lastshot = time;
	missile.owner = self;     
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "m16grenade";

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*1200 + v_up * 200 + crandom()*v_right*10 +                     crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 1500 + '0 0 -300';
		missile.velocity_z = 30;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = M16GrenadeTouch;

// set missile duration
// NAVY SEALs sQuad bots addition
	//missile.nextthink = time + 3;
	//missile.think = M16GrenadeExplode;
  missile.search_time = time + 3.0;
  missile.nextthink   = time + 0.1;
  missile.grenadetype = 0;
  missile.think       = W_PredictMissileDestination;
// end - NAVY SEALs sQuad bots addition

	setmodel (missile, "progs/m16gren.mdl");
	setsize (missile, '0 0 0', '1 1 1');
	setorigin (missile, self.origin + (v_forward * 10.000) - (v_right * 21.000) + (v_up * 3.000));

};

void (float damage, vector dir) M16_TraceAttack = {

   local vector vel;
   local vector org;
   local vector meatdir;
   local float particle_color;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      if ( (trace_ent.absmax_z - trace_endpos_z) <= 12 ) 
       {
        damage = damage * 1.5;
        trace_ent.headshot = 1;
       }
      else if ( ( (trace_ent.absmax_z - trace_endpos_z) > 12) &&
         ( (trace_ent.absmax_z - trace_endpos_z) < 35) )
       {
        trace_ent.headshot = 0;
        damage = rint(damage * 0.75);
       }
      else
       {
        trace_ent.headshot = -1;
       }
      particle_color = random ();
      meatdir_x = ((random () * 300.000) + dir_x);
      meatdir_y = ((random () * 300.000) + dir_y);
      meatdir_z = ((random () * 300.000) + dir_z);
      makevectors (self.v_angle);
//      trace_ent.flags = (trace_ent.flags - FL_ONGROUND);
      if (trace_ent.flags < 0)
       { trace_ent.flags = trace_ent.flags + FL_ONGROUND; }
               if ( (particle_color <= 0.800) ) {

            Shoot_Blood (org,meatdir);

         }

         if ( (trace_ent.health <= damage) && (trace_ent.movetype != MOVETYPE_PUSH) &&
              (trace_ent.duck != 1) ) {
            trace_ent.flags = trace_ent.flags - FL_ONGROUND;
            trace_ent.movetype = MOVETYPE_BOUNCE; 
            trace_ent.velocity = (v_forward * 200.000);
            trace_ent.velocity_z = 220 + (random() * 100);
         }

      AddMultiDamage (trace_ent,damage);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);
//      particle (org,'1.000 2.000 2.000',192.000,TE_WIZSPIKE);
//      particle (org,'2.000 3.000 4.000',192.000,TE_WIZSPIKE);
      particle (org,'5.000 7.000 8.000',192.000,TE_WIZSPIKE);
      particle (org,'3.000 2.000 7.000',192.000,TE_WIZSPIKE);
      particle (org,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
      particle_color = random ();
      if ( (particle_color <= 0.250) ) {

         sound (self,CHAN_AUTO,"weapons/mp5ric1.wav",TRUE,ATTN_NORM);

      }
      if ( ((particle_color <= 0.500) && (particle_color > 0.250)) ) {

         sound (self,CHAN_AUTO,"weapons/mp5ric2.wav",TRUE,ATTN_NORM);

      }

   }

};

void () W_FireM16 = {

   local vector dir;
   local vector src;
   local float r;

   r = random ();
   sound (self,CHAN_WEAPON,"weapons/m16fire.wav",TRUE,ATTN_NORM);
   if (self.use_clip_as_ammo)
     self.currentammo = self.m16clip = self.m16clip - 1;
   else
     self.m16clip = self.m16clip - 1;
   makevectors (self.angles);
   dir = aim (self,1000.000);
   makevectors (self.v_angle);
   src = (self.origin + (v_forward * TE_LAVASPLASH));
   src_z = (self.absmin_z + (self.size_z * 0.800));
   src_y = (self.absmin_y + (self.size_y * 0.400));
   ClearMultiDamage ();
   traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 130.000)) - 
                 (v_right * 220.000)),FALSE,self);

/*
   if (trace_ent.classname == "m16grenade")
    {
     trace_ent.think = M16GrenadeExplode;
     trace_ent.nextthink = time + 0.10;
    }
   if (trace_ent.classname == "grenade")
    {
     trace_ent.think = GrenadeExplode;
     trace_ent.nextthink = time + 0.10;
    }

*/

   M16_TraceAttack (32.000,dir);
   ApplyMultiDamage ();
   eject_shell ((((self.origin + (v_forward * 12.000)) - (v_right * 8.000)) + 
   (v_up * 13.000)),dir);

};

