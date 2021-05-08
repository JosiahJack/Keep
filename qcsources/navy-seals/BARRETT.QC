void () M16GrenadeExplode;
void () GrenadeExplode;

void () barrett_precache =
 {
   precache_model2 ("progs/v_barret.mdl");
   precache_sound2 ("weapons/barrett.wav");
 };

void(vector org, vector dir) Shoot_BARRETT =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_NOT;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = SUB_Remove;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 0.5;
	setmodel (newmis, "progs/psg1.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
      sound(self,CHAN_BODY,"weapons/mk23gib.wav",1,ATTN_NORM);
	setorigin (newmis, org + '0 0 10');

	newmis.velocity = dir;
};


void (float damage, vector dir) BARRETT_TraceAttack = {

   local vector vel;
   local vector org;
   local vector meatdir;
   local float particle_color;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      if ( (trace_ent.absmax_z - trace_endpos_z) <= 26 ) 
       {
        damage = damage * 2;
        trace_ent.headshot = 1;
       }
      else if ( ( (trace_ent.absmax_z - trace_endpos_z) > 26) &&
         ( (trace_ent.absmax_z - trace_endpos_z) < 35) )
       {
        trace_ent.headshot = 0;
        damage = rint(damage * 0.5);
       }
      else 
        trace_ent.headshot = -1;
      
      particle_color = random ();
      meatdir_x = ((random () * 300.000) + dir_x);
      meatdir_y = ((random () * 300.000) + dir_y);
      meatdir_z = ((random () * 300.000) + dir_z);
      makevectors (self.v_angle);
      Shoot_BARRETT (trace_ent.origin,v_forward*3000);
//      trace_ent.flags = (trace_ent.flags - FL_ONGROUND);
      if (trace_ent.flags < 0)
       { trace_ent.flags = trace_ent.flags + FL_ONGROUND; }
          if ( (particle_color <= 0.800) ) {

            Shoot_Blood (org,meatdir);
            meatdir_y = meatdir_y * (-1.3);
            meatdir_z = meatdir_z * (0.8);
            Shoot_Blood (org,meatdir);
            SpawnBlood (org,(vel * 0.200),(damage * 10.000));

         }
         if ( (trace_ent.health <= damage) && (trace_ent.movetype != MOVETYPE_PUSH) &&
              (trace_ent.duck != 1) )
         {
            trace_ent.flags = trace_ent.flags - FL_ONGROUND;
            trace_ent.velocity = (v_forward * 230.000);
            trace_ent.velocity_z = 270 + (random() * 80);
         }
      AddMultiDamage (trace_ent,damage);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);
      particle (org,'7.000 -2.000 8.000',192.000,TE_WIZSPIKE);
      particle (org,'3.000 -3.000 8.000',192.000,TE_WIZSPIKE);
      particle (org,'4.000 -7.000 8.000',192.000,TE_WIZSPIKE);
      particle (org,'3.000 2.000 7.000',192.000,TE_WIZSPIKE);
      particle (org,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
      particle (org,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
      particle_color = random ();
      if ( (particle_color <= 0.500) ) {

         sound (self,CHAN_AUTO,"weapons/mp5ric1.wav",TRUE,ATTN_NORM);

      }
      if ( ((particle_color <= 1.00) && (particle_color > 0.50)) ) {

         sound (self,CHAN_AUTO,"weapons/mp5ric2.wav",TRUE,ATTN_NORM);

      }

   }

};

void () W_FireBarrett = {

   local vector dir;
   local vector src;
   local float r;

   r = random ();
   sound (self,CHAN_WEAPON,"weapons/barrett.wav",TRUE,ATTN_NORM);
   if (self.use_clip_as_ammo)
     self.currentammo = self.psg1clip = self.psg1clip - 1;
   else
     self.psg1clip = self.psg1clip - 1;
   makevectors (self.angles);
   self.punchangle_x = random() * -2;
   dir = aim (self,1000.000);
   makevectors (self.v_angle);
   src = (self.origin + (v_forward * TE_LAVASPLASH));
   src_z = (self.absmin_z + (self.size_z * 0.800));
   src_y = (self.absmin_y + (self.size_y * 0.400));
   ClearMultiDamage ();
   if (self.zoomlevel != 0)
   {
     traceline (src,src + (v_forward * IT_CELLS),FALSE,self);
   }
   else
   {
     traceline (src,( ( ( src + (v_forward * IT_CELLS) ) - (v_up * 90.000) - (v_right * 120) ) ),FALSE,self);
   }
   if ( (vlen(trace_endpos - self.origin))  < 250)
    {
     BARRETT_TraceAttack(200.000,dir);
    }
   else
    {
     BARRETT_TraceAttack (120.000,dir);
    }
   ApplyMultiDamage ();

   eject_shell ((((self.origin + (v_forward * 14.000)) - (v_right * 9.000)) +
   (v_up * 15.000)),dir);

};

