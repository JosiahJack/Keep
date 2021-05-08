void  ()raven_flap_fast;
void  ()raven_glide;
void  ()raven_glide_right;
void  ()raven_glide_left;
void  ()raven_hop_wings_out;
void  ()raven_stand;
void  ()raven_slowdown;
void  ()raven_land;
void  ()raven_fold_wings;
void  ()raven_ruffle_end;
void  ()raven_peck_up1;
void  ()raven_peck_up_all;
void  ()raven_peck_up2;
void  ()raven_peck2;
void  ()raven_peck_down;
void  ()raven_peck_down1;
void  ()raven_peck_down2;

void  ()drop_feathers =  {
local vector ofs = '0.00000 0.00000 0.00000';
   newmis = spawn ( );
   newmis.movetype = MOVETYPE_FLY;
   newmis.avelocity_y = random(-200.00000,200.00000);
   newmis.angles_x = random(-90.00000,90.00000);
   newmis.velocity_z = random(-100.00000);
   ofs = RandomVector ( '32.00000 32.00000 32.00000');
   newmis.think = SUB_Remove;
   AdvanceThinkTime(newmis,3.00000);
   setmodel ( newmis, "models/fether.mdl");
   setorigin ( newmis, (self.origin + ofs));
};


void  ()raven_takeoff =  {
   AdvanceFrame( 108.00000, 112.00000);
   ai_walk ( ((3.00000 + self.frame) - 108.00000));
   if ( cycle_wrapped ) {

      self.flags |= FL_FLY;
      self.movetype = MOVETYPE_FLY;
      self.think = raven_flap_fast;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_flap_fast =  {
   AdvanceFrame( 47.00000, 51.00000);
   ai_walk ( (self.speed + ((self.frame - 47.00000) * 2.00000)));
   if ( (cycle_wrapped && (random() < 0.50000)) ) {

      self.think = raven_glide;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_flap_slow =  {
   AdvanceFrame( 96.00000, 104.00000);
   ai_walk ( ((self.speed + self.frame) - 96.00000));
};


void  ()raven_glide_think =  {
   ai_walk ( self.speed);
   if ( (self.goalentity.origin_z < self.origin_z) ) {

      traceline ( (self.origin + (v_forward * 48.00000)), ((self.origin + (v_forward * 48.00000)) - '0.00000 0.00000 100.00000'), FALSE, self);
      if ( (trace_fraction < 1.00000) ) {

         self.msg3 = "landing";
         self.think = raven_slowdown;
         AdvanceThinkTime(self,0.00000);
         return ;

      }

   }
   if ( (self.ideal_yaw > self.angles_y) ) {

      self.think = raven_glide_right;
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (self.ideal_yaw > self.angles_y) ) {

         self.think = raven_glide_left;
         AdvanceThinkTime(self,0.00000);
      } else {

         self.think = raven_glide;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()raven_glide =  {
   self.frame = 107.00000;
   if ( (self.angles_z > 0.00000) ) {

      self.angles_z -= 1.00000;
   } else {

      if ( (self.angles_z < 0.00000) ) {

         self.angles_z += 1.00000;

      }

   }
   raven_glide_think ( );
};


void  ()raven_glide_right =  {
   self.frame = 105.00000;
   if ( (self.angles_z > -15.00000) ) {

      self.angles_z -= 1.00000;

   }
   raven_glide_think ( );
};


void  ()raven_glide_left =  {
   self.frame = 106.00000;
   if ( (self.angles_z < 15.00000) ) {

      self.angles_z += 1.00000;

   }
   raven_glide_think ( );
};


void  ()raven_slowdown =  {
   AdvanceFrame( 75.00000, 79.00000);
   ai_walk ( self.speed);
   if ( (self.msg3 == "landing") ) {

      if ( (self.speed > 1.00000) ) {

         self.speed -= 0.10000;

      }

   }
   if ( (self.flags & FL_ONGROUND) ) {

      self.angles_z = 0.00000;
      self.msg3 = "";
      self.think = raven_land;
      AdvanceThinkTime(self,0.00000);

   }
   if ( (self.angles_z > 0.00000) ) {

      self.angles_z -= 1.00000;
   } else {

      if ( (self.angles_z < 0.00000) ) {

         self.angles_z += 1.00000;

      }

   }
};


void  ()raven_land =  {
   AdvanceFrame( 80.00000, 84.00000);
   ai_walk ( 1.00000);
   if ( cycle_wrapped ) {

      self.flags ^= FL_FLY;
      self.movetype = MOVETYPE_STEP;
      self.think = raven_hop_wings_out;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_hop_wings_out =  {
   AdvanceFrame( 52.00000, 59.00000);
   ai_walk ( 5.00000);
   if ( cycle_wrapped ) {

      if ( ((self.msg3 != "threatening") || (random() < 0.30000)) ) {

         self.think = raven_fold_wings;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()raven_fold_wings =  {
   AdvanceFrame( 60.00000, 74.00000);
   if ( cycle_wrapped ) {

      self.think = raven_stand;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_open_wings =  {
   AdvanceFrame( 74.00000, 60.00000);
   if ( cycle_wrapped ) {

      if ( (self.msg3 == "taking off") ) {

         self.think = raven_flap_fast;
      } else {

         if ( (self.msg3 == "threatening") ) {

            self.think = raven_hop_wings_out;

         }

      }
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (random() < 0.30000) ) {

         self.think = raven_fold_wings;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()raven_hop =  {
   AdvanceFrame( 37.00000, 44.00000);
   ai_walk ( 2.00000);
   if ( cycle_wrapped ) {

      self.think = raven_stand;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_shit =  {
   AdvanceFrame( 89.00000, 95.00000);
   if ( (self.frame == 94.00000) ) {

      AdvanceThinkTime(self,0.77000);
   } else {

      if ( cycle_wrapped ) {

         self.think = raven_stand;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()raven_ruffle_start =  {
   AdvanceFrame( 89.00000, 91.00000);
   if ( cycle_wrapped ) {

      self.think = raven_ruffle_end;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_ruffle_end =  {
   AdvanceFrame( 91.00000, 89.00000);
   if ( cycle_wrapped ) {

      self.think = raven_stand;
      AdvanceThinkTime(self,0.00000);

   }
};


void  (entity targ)raven_choose_look =  {
local vector vec = '0.00000 0.00000 0.00000';
   vec = normalize ( ((((targ.absmin + targ.absmax) * 0.50000) - self.origin) + self.view_ofs));
   makevectors ( self.angles);
};


void  ()raven_stand_think =  {
local float r = 0.00000;
   if ( !self.goalentity ) {

      self.goalentity = find ( world, classname, "obj_corpse1");

   }
   if ( (random() < 0.30000) ) {

      r = rint ( random(1.00000,10.00000));
      if ( (r == 1.00000) ) {

         self.think = raven_shit;
      } else {

         if ( (r == 2.00000) ) {

            self.think = raven_ruffle_start;
         } else {

            if ( (r == 3.00000) ) {

               self.msg3 = "threatening";
               self.think = raven_open_wings;
            } else {

               if ( (r == 4.00000) ) {

                  self.think = raven_ruffle_start;
               } else {

                  if ( (r == 5.00000) ) {

                     self.msg3 = "taking off";
                     self.think = raven_open_wings;
                  } else {

                     if ( (r == 6.00000) ) {

                        self.think = raven_peck_down;
                     } else {

                        self.think = raven_hop;

                     }

                  }

               }

            }

         }

      }
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (self.msg3 == "looking") ) {

         raven_choose_look ( world);
      } else {

         AdvanceThinkTime(self,0.05000);

      }

   }
};


void  ()raven_stand =  {
   self.frame = 88.00000;
   self.think = raven_stand_think;
   AdvanceThinkTime(self,0.00000);
};


void  ()raven_die =  {
   drop_feathers ( );
   if ( (self.health < -20.00000) ) {

      chunk_death ( );
   } else {

      self.frame = 45.00000;
      self.flags ^= FL_FLY;
      if ( (self.movetype != MOVETYPE_BOUNCE) ) {

         self.movetype = MOVETYPE_BOUNCE;

      }
      self.angles_z = 0.00000;
      self.avelocity_y = random(200.00000,400.00000);
      MakeSolidCorpse ( );

   }
};


void  ()raven_look_left_low =  {
   self.frame = 85.00000;
   self.th_stand ( );
};


void  ()raven_look_right_low =  {
   self.frame = 86.00000;
   self.th_stand ( );
};


void  ()raven_look_left_high =  {
   self.frame = 113.00000;
   self.th_stand ( );
};


void  ()raven_look_right_high =  {
   self.frame = 114.00000;
   self.th_stand ( );
};


void  ()raven_look_down =  {
   self.frame = 46.00000;
   self.th_stand ( );
};


void  ()peck_effect =  {
   makevectors ( self.angles);
   traceline ( self.origin, (self.origin + (v_forward * 16.00000)), FALSE, self);
   SpawnPuff ( trace_endpos, '0.00000 0.00000 20.00000', random(3.00000,10.00000), trace_ent);
};


void  ()raven_peck1 =  {
   AdvanceFrame( 7.00000, 19.00000);
   if ( (random() < 0.20000) ) {

      peck_effect ( );

   }
   if ( cycle_wrapped ) {

      if ( (random() < 0.20000) ) {

         self.think = raven_peck_up1;
         AdvanceThinkTime(self,0.00000);
      } else {

         if ( (random() < 0.50000) ) {

            self.think = raven_peck_up_all;
            AdvanceThinkTime(self,0.00000);

         }

      }
   } else {

      if ( (random() < 0.20000) ) {

         self.think = raven_peck2;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()raven_peck2 =  {
   AdvanceFrame( 24.00000, 33.00000);
   if ( (random() < 0.20000) ) {

      peck_effect ( );

   }
   if ( cycle_wrapped ) {

      if ( (random() < 0.20000) ) {

         self.think = raven_peck_up2;
         AdvanceThinkTime(self,0.00000);
      } else {

         if ( (random() < 0.50000) ) {

            self.think = raven_peck_up_all;
            AdvanceThinkTime(self,0.00000);

         }

      }
   } else {

      if ( (random() < 0.20000) ) {

         self.think = raven_peck1;
         AdvanceThinkTime(self,0.00000);

      }

   }
};


void  ()raven_peck_down =  {
   AdvanceFrame( 0.00000, 6.00000);
   if ( cycle_wrapped ) {

      self.think = raven_peck1;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_peck_up_all =  {
   AdvanceFrame( 6.00000, 0.00000);
   if ( cycle_wrapped ) {

      if ( (random() < 0.70000) ) {

         self.think = raven_stand;
      } else {

         self.think = raven_peck_down;

      }
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_peck_up1 =  {
   AdvanceFrame( 20.00000, 23.00000);
   if ( (self.frame == 23.00000) ) {

      self.think = raven_peck_down1;
      AdvanceThinkTime(self,random(0.30000,1.30000));

   }
};


void  ()raven_peck_up2 =  {
   AdvanceFrame( 34.00000, 36.00000);
   if ( (self.frame == 36.00000) ) {

      self.think = raven_peck_down2;
      AdvanceThinkTime(self,random(0.30000,1.30000));

   }
};


void  ()raven_peck_down1 =  {
   AdvanceFrame( 23.00000, 20.00000);
   if ( cycle_wrapped ) {

      if ( (random() < 0.50000) ) {

         self.think = raven_peck1;
      } else {

         self.think = raven_peck2;

      }
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()raven_peck_down2 =  {
   AdvanceFrame( 36.00000, 34.00000);
   if ( cycle_wrapped ) {

      if ( (random() < 0.50000) ) {

         self.think = raven_peck1;
      } else {

         self.think = raven_peck2;

      }
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()monster_raven =  {
   if ( !(self.flags2 & FL_SUMMONED) ) {

      precache_model2 ( "models/raven.mdl");
      precache_model2 ( "models/fether.mdl");
      precache_sound2 ( "raven/squawk.wav");

   }
   self.solid = SOLID_SLIDEBOX;
   self.takedamage = DAMAGE_YES;
   self.thingtype = THINGTYPE_FLESH;
   self.movetype = MOVETYPE_STEP;
   self.view_ofs = '0.00000 0.00000 17.00000';
   self.speed = 10.00000;
   self.yaw_speed = 10.00000;
   self.health = 10.00000;
   self.mass = 1.00000;
   self.mintel = 5.00000;
   self.th_stand = raven_stand;
   self.th_walk = raven_hop;
   self.th_run = raven_glide;
   self.th_melee = raven_peck_down;
   self.th_missile = raven_shit;
   self.th_jump = raven_takeoff;
   self.th_die = raven_die;
   setmodel ( self, "models/raven.mdl");
   setsize ( self, '-7.00000 -7.00000 0.00000', '7.00000 7.00000 20.00000');
   walkmonster_start ( );
};

