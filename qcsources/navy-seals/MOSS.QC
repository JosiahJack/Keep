void () moss_precache =
 {
  precache_sound2 ("weapons/cock1.wav");
  precache_sound2 ("weapons/cock2.wav");
  precache_sound2 ("weapons/shotfire.wav");
  precache_model2 ("progs/v_moss.mdl");
  precache_model2 ("progs/sshell.mdl");
 };

void (vector position, vector direction) Shoot_Blood = {

   local entity blood;

   blood = spawn ();
   blood.owner = self;
   blood.movetype = MOVETYPE_FLYMISSILE;
   blood.solid = SOLID_NOT;
   makevectors (self.angles);
   blood.velocity = direction;
   blood.nextthink = (time + 0.250);
   blood.think = SUB_Remove;
   blood.touch = SUB_Remove;
   setmodel (blood,"progs/blood.mdl");
   setsize (blood,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (blood,position);

};

float(entity hit, float damage) MossbergAddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;                     
            return multi_damage;
};

void (float damage, vector dir) MossbergTraceAttack = {

   local vector vel;
   local vector org;
   local vector meatdir;
   local float rand;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   meatdir_x = ((random () * 300.000) + dir_x);
   meatdir_y = ((random () * 300.000) + dir_y);
   meatdir_z = ((random () * 300.000) + dir_z);
   makevectors(self.v_angle);
   if ( trace_ent.takedamage ) {
      
      if (rand < 0.5)
       {
        Shoot_Blood (org,meatdir);
       }
      rand=MossbergAddMultiDamage (trace_ent,damage);

      if (trace_ent.movetype != MOVETYPE_PUSH)
       {    
      if ( (rand >= 24) && (rand < 42) && (rand < trace_ent.health) && (self.flycheck == 1) 
            && (self.targetflyonce1 == 0) )
       {
         self.targetflyonce1 = 1;      
         trace_ent.flags = trace_ent.flags - FL_ONGROUND;
         trace_ent.velocity = (v_forward * 140.000);
         trace_ent.velocity_z = (trace_ent.velocity_z + ((random () + 0.500) * 80.000));
       }

      if ( (rand >= 24) && (rand < 42) && (rand >= trace_ent.health) && (self.flycheck == 1) )
       {
         trace_ent.movetype = MOVETYPE_BOUNCE;
         trace_ent.flags = trace_ent.flags - FL_ONGROUND;
         trace_ent.velocity = (v_forward * 220.000);
         trace_ent.velocity_z = (trace_ent.velocity_z + ((random () + 0.500) * 200.000));
       }         

      if ( (rand >= 42) && (rand < 60) && (rand < trace_ent.health) && (self.flycheck == 1) 
            && (self.targetflyonce2 == 0) )
       {
         self.targetflyonce2 = 1;      
         trace_ent.flags = trace_ent.flags - FL_ONGROUND;
         trace_ent.velocity = (v_forward * 180.000);
         trace_ent.velocity_z = (trace_ent.velocity_z + ((random () + 0.500) * 120.000));
       }

      if ( (rand >= 42) && (rand < 60) && (rand >= trace_ent.health) && (self.flycheck == 1) )
       {
         trace_ent.movetype = MOVETYPE_BOUNCE;
         trace_ent.flags = trace_ent.flags - FL_ONGROUND;
         trace_ent.velocity = (v_forward * 240.000);
         trace_ent.velocity_z = (trace_ent.velocity_z + ((random () + 0.500) * 220.000));
       }        
 
      if ( (rand >= 66)  && (rand < trace_ent.health) && (self.flycheck == 1) 
            && (self.targetflyonce3 == 0) )
       {
         self.targetflyonce3 = 1;      
         trace_ent.flags = trace_ent.flags - FL_ONGROUND;
         trace_ent.velocity = (v_forward * 220.000);
         trace_ent.velocity_z = (trace_ent.velocity_z + ((random () + 0.500) * 160.000));
       }

      if ( (rand >= 66)  && (rand >= trace_ent.health) && (self.flycheck == 1) )
       {
         trace_ent.movetype = MOVETYPE_BOUNCE;
         trace_ent.flags = trace_ent.flags - FL_ONGROUND;
         trace_ent.velocity = (v_forward * 280.000);
         trace_ent.velocity_z = (trace_ent.velocity_z + ((random () + 0.500) * 230.000));
       }         

      }

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);
      rand = random ();
      if (rand < 0.2) 
       {
        particle (org,'1.000 2.000 2.000',192.000,TE_WIZSPIKE);
       }
      if ((rand < 0.4) && (rand > 0.2))
       {
        particle (org,'2.000 3.000 4.000',192.000,TE_WIZSPIKE);
       }
      if ((rand < 0.6) && (rand > 0.4))
       {
        particle (org,'5.000 7.000 8.000',192.000,TE_WIZSPIKE);
       }
      if ((rand < 0.8) && (rand > 0.6))
       {
        particle (org,'3.000 2.000 7.000',192.000,TE_WIZSPIKE);
       }
      else
       {
        particle (org,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
       }

   }

};

void(float shotcount, vector dir, vector spread) FireMossberg =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);
      self.targetflyonce1 = 0;
      self.targetflyonce2 = 0;
      self.targetflyonce3 = 0;
      self.flycheck = 0;

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;
      ClearMultiDamage ();
	while (shotcount > 0)
	{
            if (shotcount == 1)
             {
              self.flycheck = 1;
             }
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048 - (v_right * 100) + (v_up * 50), FALSE, self);
		particle(src + (v_forward * 100) - (v_right * 10),src + direction * 2048,192,random() * 10);
		if (trace_fraction != 1.0)
			MossbergTraceAttack (8, direction);

		shotcount = shotcount - 1;
	}
      ApplyMultiDamage ();

};

void() W_FireMossberg =
{
	local vector dir;
	self.punchangle_x = -2;
        if (self.use_clip_as_ammo)
          self.currentammo = self.mossclip = self.mossclip - 1;
        else
          self.mossclip = self.mossclip - 1;
        dir = aim (self, 100000);
        FireMossberg (12, dir, '0.08 0.06 0.0');
};
