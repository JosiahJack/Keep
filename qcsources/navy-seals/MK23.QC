void () GrenadeExplode;
void () M16GrenadeExplode;

void () mk23_precache =
 {
   precache_model2 ("progs/v_mk23.mdl");
   precache_sound2 ("weapons/mk23in.wav");
   precache_sound2 ("weapons/mk23fire.wav");
   precache_sound2 ("weapons/mk23ric.wav");
   precache_sound2 ("weapons/mk23ric2.wav");
   precache_sound2 ("weapons/mk23gib.wav");
   precache_sound2 ("weapons/mk23sld.wav");
 };

void (float damage, vector dir) MK23_TraceAttack = {

   local vector vel;
   local vector org;
   local vector meatdir;
   local float particle_color;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      if ( ( (trace_ent.absmax_z - trace_endpos_z) <= 18) &&
           ( (trace_ent.absmax_z - trace_endpos_z) > 12 ) ) 
       {
        damage = rint(damage * 1.5);
        trace_ent.headshot = 1;
       }
      else if ( (trace_ent.absmax_z - trace_endpos_z) <= 12 )
       {
        damage = rint(damage * 2.5);
        trace_ent.headshot = 1;
       }
      else if ( ( (trace_ent.absmax_z - trace_endpos_z) > 18) &&
         ( (trace_ent.absmax_z - trace_endpos_z) < 35) && 
           ( (trace_ent.classname == "guard") || (trace_ent.classname == "pdude") ) )
       {
        trace_ent.headshot = 0;
        damage = rint(damage * 0.15);
       }
      else
       {
        trace_ent.headshot = -1;
       }

      particle_color = random ();
      meatdir_x = ((random () * 300.000) );
      meatdir_y = ((random () * 300.000) );
      meatdir_z = ((random () * 300.000) );
      makevectors (self.v_angle);
//      trace_ent.flags = (trace_ent.flags - FL_ONGROUND);    

          if ( (particle_color < 0.8) && (damage >= 12) ) {
            Shoot_Blood (org,meatdir);
            SpawnBlood (org,(vel * 0.200),(damage * 100.000)); }

          if (damage >= 20)
            {
             Shoot_Blood (org + '10 10 0',v_forward * 2000);
             Shoot_Blood (org,v_forward * 2000);
             sound(trace_ent, CHAN_AUTO,"weapons/mk23gib.wav",1,ATTN_NORM);
            }


         if ((damage <= 20) && (damage > 0))
          {

              if ( (trace_ent.health <= damage) && (trace_ent.movetype != MOVETYPE_PUSH) &&
                   (trace_ent.duck != 1) && (trace_ent.classname != "misc_explobox") ) 
               {
                trace_ent.flags = trace_ent.flags - FL_ONGROUND;
                trace_ent.velocity = (v_forward * 140.000);
                trace_ent.velocity_z = 200 + (random() * 100);
               }
          }
         if (damage > 20)
          {
           if ( (trace_ent.health <= damage) && (trace_ent.movetype != MOVETYPE_PUSH) &&
                (trace_ent.duck != 1) ) 
            {
             trace_ent.flags = trace_ent.flags - FL_ONGROUND;
             trace_ent.velocity = (v_forward * 200.000);
             trace_ent.velocity_z = 200 + (random() * 100);
            }

          }

       AddMultiDamage (trace_ent,damage);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);
      particle (org,'3.000 2.000 7.000',192.000,TE_WIZSPIKE);
      particle (org,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
      particle (org,'9.000 8.000 4.000',192.000,TE_WIZSPIKE);
      particle (org,'17.000 8.000 10.000',192.000,TE_WIZSPIKE);
      particle_color = random();
      if (particle_color <= 0.2) 
       {
         sound(self,CHAN_AUTO,"weapons/mk23ric.wav",TRUE,ATTN_NORM);
       }
      if ( (particle_color <= 0.4) && (particle_color > 0.2) )
       {   
         sound(self,CHAN_AUTO,"weapons/mk23ric2.wav",TRUE,ATTN_NORM);
       }   
   }

};

void () W_FireMK23 = {

   local vector dir;
   local vector src;
   local float r;
   local float temp;

   sound (self,CHAN_WEAPON,"weapons/mk23fire.wav",TRUE,ATTN_NORM);
   if (self.use_clip_as_ammo)
     self.currentammo = self.mk23clip = self.mk23clip - 1;
   else
     self.mk23clip = self.mk23clip - 1;
   makevectors (self.angles);
   dir = aim (self,1000.000);
   makevectors (self.v_angle);
   src = (self.origin + (v_forward * TE_LAVASPLASH));
   src_z = (self.absmin_z + (self.size_z * 0.800));
   src_y = (self.absmin_y + (self.size_y * 0.400));
   ClearMultiDamage ();
   r = random ();
   if ( (time - self.lastshot) > 0.2) 
    {
     traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * (50.000))) - 
     (v_right * (300.000 ))),FALSE,self);
    }
   if ( (time - self.lastshot) <= 0.3)
    {
     traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * (50.000 + (r * 70)))) - 
     (v_right * (250.000 + (r * 70)))),FALSE,self);
    }

   temp = vlen(trace_endpos - self.origin);
   if (temp < 250)
    {
     MK23_TraceAttack(50.000,dir);
    }
   if ((temp < 350) && (temp >= 250))
    {
     MK23_TraceAttack (35.000,dir);
    }
   if ((temp < 450) && (temp >= 350))
    {
     MK23_TraceAttack (25,dir);
    }
   if ((temp < 550) && (temp >= 450))
    {
     MK23_TraceAttack (20,dir);
    }
   if ((temp < 650) && (temp >= 550))
    {
     MK23_TraceAttack (15,dir);
    }
   if (temp >= 650)
    {
     MK23_TraceAttack (10,dir);
    }
   ApplyMultiDamage ();
   self.lastshot = time;
   eject_shell ((((self.origin + (v_forward * 14.000)) - (v_right * 9.00)) + (v_up *       14.000)),dir);

};


