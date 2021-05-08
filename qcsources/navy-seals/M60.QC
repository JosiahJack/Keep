void () m60_precache =
 { // BUG in NS2.0
   precache_model2 ("progs/g_m60.mdl");
   precache_model2 ("progs/v_m60.mdl");
   precache_sound2 ("weapons/m60fire.wav");
   precache_sound2 ("weapons/chain.wav");
   precache_sound2 ("weapons/m60in.wav");
 };

void (float damage, vector dir) M60_TraceAttack = {

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
        damage = rint(damage * 1.4);
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
      if (random() < 0.5) 
       meatdir_y = (-1) * meatdir_y;

      meatdir_z = ((random () * 300.000) + dir_z);
      makevectors (self.v_angle);
          if ( (particle_color <= 0.800) ) 
           {
            sound(trace_ent,CHAN_BODY,"weapons/mk23gib.wav",1,ATTN_NORM);
            Shoot_Blood (org,meatdir);
           }

         if ( (trace_ent.health <= damage) && (trace_ent.movetype != MOVETYPE_PUSH) && 
              (trace_ent.duck != 1) && (trace_ent.classname != "misc_explobox") )
         {
            trace_ent.flags = trace_ent.flags - FL_ONGROUND;
            trace_ent.velocity = (v_forward * 200.000);
            trace_ent.velocity_z = 230 + (random() * 100);
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

void () W_FireM60 = {

   local vector dir;
   local vector src;
   local float r;

   if (self.m60clip <= 0)
   {
      self.m60clip = 0;
      sound (self, CHAN_WEAPON, "weapons/mp5click.wav", 1, ATTN_NORM);
      return;
   }

   r = random ();
   sound (self,CHAN_WEAPON,"weapons/m60fire.wav",TRUE,ATTN_NORM);
   if (self.use_clip_as_ammo)
     self.currentammo = self.m60clip = self.m60clip - 1;
   else
     self.m60clip = self.m60clip - 1;
   makevectors (self.angles);
   self.punchangle_x = random() * -1;
   dir = aim (self,1000.000);
   makevectors (self.v_angle);
   src = (self.origin + (v_forward * TE_LAVASPLASH));
   src_z = (self.absmin_z + (self.size_z * 0.800));
   src_y = (self.absmin_y + (self.size_y * 0.400));
   ClearMultiDamage ();
   traceline (src,( ( ( src + (v_forward * IT_CELLS) ) - (v_up * (130.000 + (r * 52.000))) -
     (v_right * (40 + (r * 88)) ) ) ),FALSE,self);

   M60_TraceAttack (20.000,dir);
   ApplyMultiDamage ();
   eject_shell ((((self.origin + (v_forward * 14.000)) - (v_right * 8.000)) +
   (v_up * 13.000)),dir);

};

