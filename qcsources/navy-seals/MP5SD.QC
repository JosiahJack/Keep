void () M16GrenadeExplode;
void () GrenadeExplode;


void () mp5sd_precache =
 {
   precache_model2 ("progs/v_mp5sd.mdl");
   precache_sound2 ("weapons/mp5sd.wav");
 };

void (float damage, vector dir) MP5SD_TraceAttack = {

   local vector vel;
   local vector org;
   local vector meatdir;
   local float particle_color;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      if ( (trace_ent.absmax_z - trace_endpos_z) <= 14 ) 
       {
        damage = rint(damage * 1.6);
        trace_ent.headshot = 1;
       }
      else if ( ( (trace_ent.absmax_z - trace_endpos_z) > 14) &&
         ( (trace_ent.absmax_z - trace_endpos_z) < 35) )
       {
        trace_ent.headshot = 0;
        damage = rint(damage * 0.6);
       }   
      else
        trace_ent.headshot = -1;
   
      sound(trace_ent,CHAN_BODY,"weapons/mp5hit.wav",1,ATTN_NORM);
      particle_color = random ();
      meatdir_x = ((random () * 300.000) + dir_x);
      meatdir_y = ((random () * 300.000) + dir_y);
      meatdir_z = ((random () * 300.000) + dir_z);
      makevectors (self.v_angle);
//      trace_ent.flags = (trace_ent.flags - FL_ONGROUND);
          if ( damage > 20 ) 
           {
            Shoot_Blood (org,meatdir);
           }
          else
            SpawnBlood (org,(vel * 0.200),(damage * 60.000)); 

         if ( (trace_ent.health <= damage) && (trace_ent.movetype != MOVETYPE_PUSH) &&
              (trace_ent.duck != 1) )
         {
            trace_ent.flags = trace_ent.flags - FL_ONGROUND;
            trace_ent.velocity = (v_forward * 200.000);
            trace_ent.velocity_z = 200 + (random() * 100);
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
//      particle (org,'5.000 7.000 8.000',192.000,TE_WIZSPIKE);
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

void () W_FireMP5SD = {

   local vector dir;
   local vector src;
   local float r, temp;
   if (self.mp5clip <= 0)
   {
       self.mp5clip = 0;
       sound(self, CHAN_WEAPON, "weapons/mp5click.wav", 1, ATTN_NORM);
       return;
   }

   r = random ();
   sound (self,CHAN_WEAPON,"weapons/mp5sd.wav",TRUE,ATTN_NORM);
   if (self.use_clip_as_ammo)
     self.currentammo = self.mp5clip = self.mp5clip - 1; 
   else
     self.mp5clip = self.mp5clip - 1;
   makevectors (self.angles);
   self.punchangle_x = -2;
   dir = aim (self,1000.000);
   makevectors (self.v_angle);
   src = (self.origin + (v_forward * TE_LAVASPLASH));
   src_z = (self.absmin_z + (self.size_z * 0.800));
   src_y = (self.absmin_y + (self.size_y * 0.400));
   ClearMultiDamage ();
   if (self.semiauto == 0)
     {
      traceline (src, (src + (v_forward * IT_CELLS) ) - (v_up * 110) - (v_right * 55), 0, self);
     }
   else if (self.semiauto == 1)
     {
    traceline (src,( ( ( src + (v_forward * IT_CELLS) ) - (v_up * (94.000 + (r * 32.000))) -    
    (v_right * (39 + (r * 32) ) ) ) ),FALSE,self);
     }
   else if (self.semiauto == 2)
     {
    temp = self.muzzleclimb * 30;
    traceline (src,( ( ( src + (v_forward * IT_CELLS) ) - (v_up * (87.000 + (r * 46.000) - temp)) -    
    (v_right * (22 + (r * 46) ) ) ) ),FALSE,self);
     }

   

   if  (vlen(trace_endpos - self.origin) < 400)
     MP5SD_TraceAttack (18.000,dir);
   else
     MP5_TraceAttack (10,dir);

    ApplyMultiDamage ();
   eject_shell ((((self.origin + (v_forward * 18.000)) - (v_right * 8.000)) +
   (v_up * 12.000)),dir);

};

