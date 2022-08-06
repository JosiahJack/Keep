float NumGremlins /* = 0.000 */;
float NumSpawnGremlins /* = 0.000 */;
entity () GremlinFindVictim;
float () GremlinFindTarget;
float () GremlinAttemptWeaponSteal = {

   local vector delta;
   local entity tempself;
   local float best;
   local entity victim;
   local float amount;

   if ( self.stoleweapon ) {

      dprint ("gremlin trying to steal a weapon again\n");
      return ( FALSE );

   }
   if ( !(self.enemy.flags & FL_CLIENT) ) {

      return ( FALSE );

   }
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 100.000) ) {

      return ( FALSE );

   }
   if ( (random () < 0.500) ) {

      return ( FALSE );

   }
   victim = self.enemy;
   best = victim.weapon;
   if ( (((best == IT_AXE) || (best == IT_SHOTGUN)) || (best == IT_MJOLNIR)) ) {

      return ( FALSE );

   }
   victim.items = (victim.items - (victim.items & best));
   self.items = (self.items | best);
   self.weapon = best;
   self.items = (self.items - (self.items & (((IT_SHELLS | IT_NAILS) | IT_ROCKETS) | IT_CELLS)));
   if ( (best == IT_SUPER_SHOTGUN) ) {

      amount = victim.ammo_shells;
      if ( (amount > 20.000) ) {

         amount = 20.000;

      }
      victim.ammo_shells = (victim.ammo_shells - amount);
      self.ammo_shells = (self.ammo_shells + amount);
      self.items = (self.items | IT_SHELLS);
      self.currentammo = self.ammo_shells;
      sprint (victim,"Gremlin stole your Super Shotgun\n");

   } else {

      if ( (best == IT_NAILGUN) ) {

         amount = victim.ammo_nails;
         if ( (amount > 40.000) ) {

            amount = 40.000;

         }
         victim.ammo_nails = (victim.ammo_nails - amount);
         self.ammo_nails = (self.ammo_nails + amount);
         self.items = (self.items | IT_NAILS);
         self.currentammo = self.ammo_nails;
         sprint (victim,"Gremlin stole your Nailgun\n");

      } else {

         if ( (best == IT_SUPER_NAILGUN) ) {

            amount = victim.ammo_nails;
            if ( (amount > 40.000) ) {

               amount = 40.000;

            }
            victim.ammo_nails = (victim.ammo_nails - amount);
            self.ammo_nails = (self.ammo_nails + amount);
            self.items = (self.items | IT_NAILS);
            self.currentammo = self.ammo_nails;
            sprint (victim,"Gremlin stole your Super Nailgun\n");

         } else {

            if ( (best == IT_GRENADE_LAUNCHER) ) {

               amount = victim.ammo_rockets;
               if ( (amount > MOVETYPE_FLY) ) {

                  amount = MOVETYPE_FLY;

               }
               victim.ammo_rockets = (victim.ammo_rockets - amount);
               self.ammo_rockets = (self.ammo_rockets + amount);
               self.items = (self.items | IT_ROCKETS);
               self.currentammo = self.ammo_rockets;
               sprint (victim,"Gremlin stole your Grenade Launcher\n");

            } else {

               if ( (best == IT_ROCKET_LAUNCHER) ) {

                  amount = victim.ammo_rockets;
                  if ( (amount > MOVETYPE_FLY) ) {

                     amount = MOVETYPE_FLY;

                  }
                  victim.ammo_rockets = (victim.ammo_rockets - amount);
                  self.ammo_rockets = (self.ammo_rockets + amount);
                  self.items = (self.items | IT_ROCKETS);
                  self.currentammo = self.ammo_rockets;
                  sprint (victim,"Gremlin stole your Rocket Launcher\n");

               } else {

                  if ( (best == IT_LIGHTNING) ) {

                     amount = victim.ammo_cells;
                     if ( (amount > 40.000) ) {

                        amount = 40.000;

                     }
                     victim.ammo_cells = (victim.ammo_cells - amount);
                     self.ammo_cells = (self.ammo_cells + amount);
                     self.items = (self.items | IT_CELLS);
                     self.currentammo = self.ammo_cells;
                     sprint (victim,"Gremlin stole your Lightning Gun\n");

                  } else {

                     if ( (best == IT_LASER_CANNON) ) {

                        amount = victim.ammo_cells;
                        if ( (amount > 40.000) ) {

                           amount = 40.000;

                        }
                        victim.ammo_cells = (victim.ammo_cells - amount);
                        self.ammo_cells = (self.ammo_cells + amount);
                        self.items = (self.items | IT_CELLS);
                        self.currentammo = self.ammo_cells;
                        sprint (victim,"Gremlin stole your Laser Cannon\n");

                     } else {

                        if ( (best == IT_PROXIMITY_GUN) ) {

                           amount = victim.ammo_rockets;
                           if ( (amount > MOVETYPE_FLY) ) {

                              amount = MOVETYPE_FLY;

                           }
                           victim.ammo_rockets = (victim.ammo_rockets - amount);
                           self.ammo_rockets = (self.ammo_rockets + amount);
                           self.items = (self.items | IT_ROCKETS);
                           self.currentammo = self.ammo_rockets;
                           sprint (victim,"Gremlin stole your Proximity Gun\n");

                        }

                     }

                  }

               }

            }

         }

      }

   }
   tempself = self;
   self = victim;
   self.weapon = W_BestWeapon ();
   W_SetCurrentAmmo ();
   self = tempself;
   self.stoleweapon = TRUE;
   self.attack_finished = time;
   if ( (random () > 0.650) ) {

      self.lastvictim = victim;

   } else {

      self.lastvictim = self;

   }
   victim = GremlinFindVictim ();
   if ( (victim != world) ) {

      self.enemy = victim;
      FoundTarget ();
      self.attack_finished = time;
      self.search_time = (time + TRUE);

   }
   return ( TRUE );

};
float () GremlinFindTarget = {

   local entity head;
   local entity gorge;
   local float dist;
   local float result;

   if ( ((self.stoleweapon == FALSE) && (time > self.wait)) ) {

      self.wait = (time + TRUE);
      dist = 2000.000;
      gorge = world;
      head = nextent (world);
      while ( (head != world) ) {

         if ( ((head.health < TRUE) && (head.flags & (FL_MONSTER | FL_CLIENT))) ) {

            result = fabs ((head.origin_z - self.origin_z));
            if ( (((visible (head) && (result < 80.000)) && (head.gorging == FALSE)) && (visible_distance < dist)) ) {

               dist = visible_distance;
               gorge = head;

            }

         }
         head = nextent (head);

      }
      if ( ((gorge != world) && (dist < (700.000 * random ()))) ) {

         self.oldenemy = self.enemy;
         self.gorging = TRUE;
         self.enemy = gorge;
         self.search_time = (time + MOVETYPE_STEP);
         FoundTarget ();
         return ( TRUE );

      }

   } else {

      if ( self.stoleweapon ) {

         head = GremlinFindVictim ();
         if ( (head != world) ) {

            self.enemy = head;
            FoundTarget ();
            self.attack_finished = time;
            self.search_time = (time + FL_SWIM);
            return ( TRUE );

         }

      }

   }
   result = FindTarget ();
   self.search_time = (time + FL_SWIM);
   return ( result );

};

void (float dist) gremlin_walk = {

   movedist = dist;
   if ( GremlinFindTarget () ) {

      return ;

   }
   movetogoal (dist);

};

void () gremlin_stand = {

   if ( FindTarget () ) {

      return ;

   }
   if ( (time > self.pausetime) ) {

      self.th_walk ();
      return ;

   }

};
float () GremlinCheckNoAmmo;

void () gremlin_glook1;

void (float dist) gremlin_run = {

   local float r;
   local vector d;
   local vector ang;
   local float done;
   local vector end;
   local float c;

   if ( (self.watertype == CONTENT_LAVA) ) {

      T_Damage (self,world,world,2000.000);

   }
   movedist = dist;
   if ( self.stoleweapon ) {

      self.frame = ((self.frame + 164.000) - 29.000);

   }
   if ( self.gorging ) {

      traceline (self.origin,self.enemy.origin,TRUE,self);
      if ( (trace_fraction != TRUE) ) {

         self.gorging = FALSE;
         return ;

      }
      if ( !visible (self.enemy) ) {

         self.gorging = FALSE;
         return ;

      }
      r = vlen ((self.enemy.origin - self.origin));
      if ( (r < 130.000) ) {

         ai_face ();
         if ( (r < 45.000) ) {

            self.th_melee ();
            self.attack_state = AS_STRAIGHT;
            return ;

         } else {

            if ( (walkmove (self.angles_y,dist) == FALSE) ) {

               self.gorging = FALSE;
               return ;

            }

         }
         return ;

      }
      movetogoal (dist);

   } else {

      if ( (random () > 0.970) ) {

         if ( GremlinFindTarget () ) {

            return ;

         }

      }
      if ( self.stoleweapon ) {

         if ( ((self.enemy.health < FALSE) && (self.enemy.classname == "player")) ) {

            gremlin_glook1 ();
            return ;

         }
         if ( !GremlinCheckNoAmmo () ) {

            if ( (self.t_length == TRUE) ) {

               remove (self.trigger_field);
               self.goalentity = self.enemy;
               self.t_length = FALSE;

            }
            return ;

         }
         r = vlen ((self.enemy.origin - self.origin));
         d = normalize ((self.origin - self.enemy.origin));
         if ( (self.t_length == FALSE) ) {

            if ( (r < MIN_CHARMER_DISTANCE) ) {

               self.trigger_field = spawn ();
               setsize (self.trigger_field,'-1.000 -1.000 -1.000','1.000 1.000 1.000');
               self.t_length = TRUE;

            }

         }
         if ( (self.t_length == TRUE) ) {

            if ( (r > 250.000) ) {

               remove (self.trigger_field);
               self.goalentity = self.enemy;
               self.t_length = FALSE;

            } else {

               if ( (r < 160.000) ) {

                  ang = vectoangles (d);
                  done = FALSE;
                  c = FALSE;
                  while ( (done == FALSE) ) {

                     makevectors (ang);
                     end = (self.enemy.origin + (v_forward * 350.000));
                     traceline (self.enemy.origin,end,FALSE,self);
                     if ( (trace_fraction == TRUE) ) {

                        traceline (self.origin,end,FALSE,self);
                        if ( (trace_fraction == TRUE) ) {

                           done = TRUE;

                        }

                     }
                     ang_y = anglemod ((ang_y + 36.000));
                     c = (c + TRUE);
                     if ( (c == MOVETYPE_BOUNCE) ) {

                        done = TRUE;

                     }

                  }
                  setorigin (self.trigger_field,end);

               }
               self.goalentity = self.trigger_field;
               self.ideal_yaw = vectoyaw (normalize ((self.goalentity.origin - self.origin)));
               ChangeYaw ();
               movetogoal (dist);
               self.nextthink = (time + 0.100);
               return ;

            }

         }

      }
      ai_run (dist);
      self.nextthink = (time + 0.100);

   }

};

void () Gremlin_JumpTouch;

void () Gremlin_FlipTouch;

void (float side) Gremlin_Melee;

void (float side) Gremlin_Gorge;

void () gremlin_stand1 = [ 0.000, gremlin_stand2 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand2 = [ 1.000, gremlin_stand3 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand3 = [ 2.000, gremlin_stand4 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand4 = [ 3.000, gremlin_stand5 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand5 = [ 4.000, gremlin_stand6 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand6 = [ 5.000, gremlin_stand7 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand7 = [ 6.000, gremlin_stand8 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand8 = [ 7.000, gremlin_stand9 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand9 = [ 8.000, gremlin_stand10 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand10 = [ 9.000, gremlin_stand11 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand11 = [ 10.000, gremlin_stand12 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand12 = [ 11.000, gremlin_stand13 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand13 = [ 12.000, gremlin_stand14 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand14 = [ 13.000, gremlin_stand15 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand15 = [ 14.000, gremlin_stand16 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand16 = [ 15.000, gremlin_stand17 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_stand17 = [ 16.000, gremlin_stand1 ] {

   gremlin_stand ();
   self.nextthink = (time + 0.200);

};

void () gremlin_walk1 = [ 17.000, gremlin_walk2 ] {

   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"grem/idle.wav",TRUE,ATTN_IDLE);

   }
   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk2 = [ 18.000, gremlin_walk3 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk3 = [ 19.000, gremlin_walk4 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk4 = [ 20.000, gremlin_walk5 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk5 = [ 21.000, gremlin_walk6 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk6 = [ 22.000, gremlin_walk7 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk7 = [ 23.000, gremlin_walk8 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk8 = [ 24.000, gremlin_walk9 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk9 = [ 25.000, gremlin_walk10 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk10 = [ 26.000, gremlin_walk11 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk11 = [ 27.000, gremlin_walk12 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_walk12 = [ 28.000, gremlin_walk1 ] {

   gremlin_walk (FL_CLIENT);

};

void () gremlin_run1 = [ 29.000, gremlin_run2 ] {

   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"grem/idle.wav",TRUE,ATTN_IDLE);

   }
   gremlin_run (FALSE);

};

void () gremlin_run2 = [ 30.000, gremlin_run3 ] {

   gremlin_run (FL_CLIENT);

};

void () gremlin_run3 = [ 31.000, gremlin_run4 ] {

   gremlin_run (STAT_TOTALMONSTERS);

};

void () gremlin_run4 = [ 32.000, gremlin_run5 ] {

   gremlin_run (FL_INWATER);

};

void () gremlin_run5 = [ 33.000, gremlin_run6 ] {

   gremlin_run (FL_INWATER);

};

void () gremlin_run6 = [ 34.000, gremlin_run7 ] {

   gremlin_run (STAT_TOTALMONSTERS);

};

void () gremlin_run7 = [ 35.000, gremlin_run8 ] {

   gremlin_run (FL_CLIENT);

};

void () gremlin_run8 = [ 36.000, gremlin_run9 ] {

   gremlin_run (FALSE);

};

void () gremlin_run9 = [ 37.000, gremlin_run10 ] {

   gremlin_run (FL_CLIENT);

};

void () gremlin_run10 = [ 38.000, gremlin_run11 ] {

   gremlin_run (STAT_TOTALMONSTERS);

};

void () gremlin_run11 = [ 39.000, gremlin_run12 ] {

   gremlin_run (FL_INWATER);

};

void () gremlin_run12 = [ 40.000, gremlin_run1 ] {

   gremlin_run (FL_INWATER);

};

void () gremlin_run13 = [ 41.000, gremlin_run14 ] {

   gremlin_run (STAT_TOTALMONSTERS);

};

void () gremlin_run14 = [ 42.000, gremlin_run15 ] {

   gremlin_run (FL_CLIENT);

};

void () gremlin_run15 = [ 43.000, gremlin_run1 ] {

   gremlin_run (FALSE);

};

void () gremlin_jump1 = [ 44.000, gremlin_jump2 ] {

   ai_face ();

};

void () gremlin_jump2 = [ 45.000, gremlin_jump3 ] {

   ai_face ();

};

void () gremlin_jump3 = [ 46.000, gremlin_jump4 ] {

   ai_face ();

};

void () gremlin_jump4 = [ 47.000, gremlin_jump5 ] {

   ai_face ();

};

void () gremlin_jump5 = [ 48.000, gremlin_jump6 ] {

   ai_face ();
   if ( (self.flags & FL_ONGROUND) ) {

      self.touch = Gremlin_JumpTouch;
      makevectors (self.angles);
      self.origin_z = (self.origin_z + TRUE);
      self.velocity = ((v_forward * 300.000) + '0.000 0.000 300.000');
      self.flags = (self.flags - FL_ONGROUND);

   } else {

      gremlin_run1 ();

   }

};

void () gremlin_jump6 = [ 49.000, gremlin_jump7 ] {


};

void () gremlin_jump7 = [ 50.000, gremlin_jump8 ] {


};

void () gremlin_jump8 = [ 51.000, gremlin_jump9 ] {


};

void () gremlin_jump9 = [ 52.000, gremlin_jump10 ] {


};

void () gremlin_jump10 = [ 53.000, gremlin_jump11 ] {


};

void () gremlin_jump11 = [ 54.000, gremlin_jump1 ] {

   self.nextthink = (time + MOVETYPE_WALK);

};

void () gremlin_jump12 = [ 55.000, gremlin_jump13 ] {


};

void () gremlin_jump13 = [ 56.000, gremlin_jump14 ] {


};

void () gremlin_jump14 = [ 57.000, gremlin_jump15 ] {


};

void () gremlin_jump15 = [ 58.000, gremlin_jump16 ] {


};

void () gremlin_jump16 = [ 59.000, gremlin_run1 ] {


};

void () gremlin_shot1 = [ 135.000, gremlin_shot2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () gremlin_shot2 = [ 136.000, gremlin_shot3 ] {


};

void () gremlin_shot3 = [ 137.000, gremlin_shot4 ] {


};

void () gremlin_shot4 = [ 138.000, gremlin_shot5 ] {


};

void () gremlin_shot5 = [ 139.000, gremlin_shot6 ] {


};

void () gremlin_shot6 = [ 140.000, gremlin_run1 ] {


};

void (float ox) Gremlin_FireNailGun;

void () gremlin_nail1 = [ 135.000, gremlin_nail2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireNailGun (MOVETYPE_STEP);

};

void () gremlin_nail2 = [ 135.000, gremlin_nail3 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireNailGun (MOVETYPE_STEP);

};

void () gremlin_nail3 = [ 135.000, gremlin_nail4 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireNailGun (MOVETYPE_STEP);

};

void () gremlin_nail4 = [ 135.000, gremlin_nail5 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireNailGun (MOVETYPE_STEP);

};

void () gremlin_nail5 = [ 135.000, gremlin_nail6 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireNailGun (MOVETYPE_STEP);

};

void () gremlin_nail6 = [ 135.000, gremlin_nail7 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireNailGun (MOVETYPE_STEP);

};

void () gremlin_nail7 = [ 135.000, gremlin_run1 ] {


};

void (float ox) Gremlin_FireLaserGun;

void () gremlin_laser1 = [ 135.000, gremlin_laser2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireLaserGun (MOVETYPE_STEP);

};

void () gremlin_laser2 = [ 135.000, gremlin_laser3 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireLaserGun (MOVETYPE_STEP);

};

void () gremlin_laser3 = [ 135.000, gremlin_laser4 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireLaserGun (MOVETYPE_STEP);

};

void () gremlin_laser4 = [ 135.000, gremlin_laser5 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireLaserGun (MOVETYPE_STEP);

};

void () gremlin_laser5 = [ 135.000, gremlin_laser6 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireLaserGun (MOVETYPE_STEP);

};

void () gremlin_laser6 = [ 135.000, gremlin_laser7 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   Gremlin_FireLaserGun (MOVETYPE_STEP);

};

void () gremlin_laser7 = [ 135.000, gremlin_run1 ] {


};

void () Gremlin_FireLightningGun;

void () gremlin_light1 = [ 135.000, gremlin_light2 ] {

   Gremlin_FireLightningGun ();

};

void () gremlin_light2 = [ 135.000, gremlin_light3 ] {

   Gremlin_FireLightningGun ();

};

void () gremlin_light3 = [ 135.000, gremlin_light4 ] {

   Gremlin_FireLightningGun ();

};

void () gremlin_light4 = [ 135.000, gremlin_light5 ] {

   Gremlin_FireLightningGun ();

};

void () gremlin_light5 = [ 135.000, gremlin_run1 ] {


};

void () gremlin_rocket1 = [ 135.000, gremlin_rocket2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () gremlin_rocket2 = [ 136.000, gremlin_rocket3 ] {


};

void () gremlin_rocket3 = [ 137.000, gremlin_rocket4 ] {


};

void () gremlin_rocket4 = [ 138.000, gremlin_rocket5 ] {


};

void () gremlin_rocket5 = [ 139.000, gremlin_rocket6 ] {


};

void () gremlin_rocket6 = [ 140.000, gremlin_run1 ] {


};

void () gremlin_lunge1 = [ 124.000, gremlin_lunge2 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge2 = [ 125.000, gremlin_lunge3 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge3 = [ 126.000, gremlin_lunge4 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge4 = [ 127.000, gremlin_lunge5 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge5 = [ 128.000, gremlin_lunge6 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge6 = [ 129.000, gremlin_lunge7 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge7 = [ 130.000, gremlin_lunge8 ] {

   ai_charge (15.000);

};

void () gremlin_lunge8 = [ 131.000, gremlin_lunge9 ] {

   ai_charge (FALSE);
   Gremlin_Melee (FALSE);

};

void () gremlin_lunge9 = [ 132.000, gremlin_lunge10 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge10 = [ 133.000, gremlin_lunge11 ] {

   ai_charge (FALSE);

};

void () gremlin_lunge11 = [ 134.000, gremlin_run1 ] {

   ai_charge (FALSE);

};

void () gremlin_claw1 = [ 60.000, gremlin_claw2 ] {

   ai_charge (FALSE);

};

void () gremlin_claw2 = [ 61.000, gremlin_claw3 ] {

   ai_charge (FALSE);

};

void () gremlin_claw3 = [ 62.000, gremlin_claw4 ] {

   ai_charge (FALSE);

};

void () gremlin_claw4 = [ 63.000, gremlin_claw5 ] {

   ai_charge (FALSE);

};

void () gremlin_claw5 = [ 64.000, gremlin_claw6 ] {

   ai_charge (FALSE);

};

void () gremlin_claw6 = [ 65.000, gremlin_claw7 ] {

   ai_charge (FALSE);
   Gremlin_Melee (MAX_CHARMER_DISTANCE);

};

void () gremlin_claw7 = [ 66.000, gremlin_claw8 ] {

   ai_charge (15.000);

};

void () gremlin_claw8 = [ 67.000, gremlin_claw9 ] {

   ai_charge (FALSE);

};

void () gremlin_claw9 = [ 68.000, gremlin_claw10 ] {

   ai_charge (FALSE);

};

void () gremlin_claw10 = [ 69.000, gremlin_claw11 ] {

   ai_charge (FALSE);

};

void () gremlin_claw11 = [ 70.000, gremlin_run1 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge1 = [ 71.000, gremlin_gorge2 ] {

   ai_charge (TRUE);

};

void () gremlin_gorge2 = [ 72.000, gremlin_gorge3 ] {

   ai_charge (TRUE);

};

void () gremlin_gorge3 = [ 73.000, gremlin_gorge4 ] {

   ai_charge (FL_SWIM);

};

void () gremlin_gorge4 = [ 74.000, gremlin_gorge5 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge5 = [ 75.000, gremlin_gorge6 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge6 = [ 76.000, gremlin_gorge7 ] {

   ai_charge (FALSE);
   Gremlin_Gorge (MAX_CHARMER_DISTANCE);

};

void () gremlin_gorge7 = [ 77.000, gremlin_gorge8 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge8 = [ 78.000, gremlin_gorge9 ] {

   ai_charge (FALSE);
   Gremlin_Gorge (-200.000);

};

void () gremlin_gorge9 = [ 79.000, gremlin_gorge10 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge10 = [ 80.000, gremlin_gorge11 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge11 = [ 81.000, gremlin_gorge12 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge12 = [ 82.000, gremlin_gorge13 ] {

   ai_charge (FALSE);

};

void () gremlin_gorge13 = [ 83.000, gremlin_gorge1 ] {

   ai_charge (FALSE);

};

void () gremlin_look1 = [ 90.000, gremlin_look2 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look2 = [ 91.000, gremlin_look3 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look3 = [ 92.000, gremlin_look4 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look4 = [ 93.000, gremlin_look5 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look5 = [ 94.000, gremlin_look6 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look6 = [ 95.000, gremlin_look7 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look7 = [ 96.000, gremlin_look8 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look8 = [ 97.000, gremlin_look9 ] {

   self.nextthink = (time + 0.200);

};

void () gremlin_look9 = [ 98.000, gremlin_run1 ] {

   if ( (self.oldenemy.health > FALSE) ) {

      self.enemy = self.oldenemy;
      HuntTarget ();

   } else {

      if ( self.movetarget ) {

         self.th_walk ();

      } else {

         self.th_stand ();

      }

   }

};

void () GremlinDropBackpack;

void () gremlin_glook1 = [ 141.000, gremlin_glook2 ] {


};

void () gremlin_glook2 = [ 142.000, gremlin_glook3 ] {


};

void () gremlin_glook3 = [ 143.000, gremlin_glook4 ] {


};

void () gremlin_glook4 = [ 144.000, gremlin_glook5 ] {


};

void () gremlin_glook5 = [ 145.000, gremlin_glook6 ] {


};

void () gremlin_glook6 = [ 146.000, gremlin_glook7 ] {


};

void () gremlin_glook7 = [ 147.000, gremlin_glook8 ] {


};

void () gremlin_glook8 = [ 148.000, gremlin_glook9 ] {


};

void () gremlin_glook9 = [ 149.000, gremlin_glook10 ] {


};

void () gremlin_glook10 = [ 150.000, gremlin_glook11 ] {


};

void () gremlin_glook11 = [ 151.000, gremlin_glook12 ] {


};

void () gremlin_glook12 = [ 152.000, gremlin_glook13 ] {


};

void () gremlin_glook13 = [ 153.000, gremlin_glook14 ] {


};

void () gremlin_glook14 = [ 154.000, gremlin_glook15 ] {


};

void () gremlin_glook15 = [ 155.000, gremlin_glook16 ] {


};

void () gremlin_glook16 = [ 156.000, gremlin_glook17 ] {


};

void () gremlin_glook17 = [ 157.000, gremlin_glook18 ] {


};

void () gremlin_glook18 = [ 158.000, gremlin_glook19 ] {


};

void () gremlin_glook19 = [ 159.000, gremlin_glook20 ] {


};

void () gremlin_glook20 = [ 160.000, gremlin_glook20 ] {

   GremlinDropBackpack ();
   self.stoleweapon = FALSE;
   if ( (self.oldenemy.health > FALSE) ) {

      self.enemy = self.oldenemy;
      HuntTarget ();

   } else {

      if ( self.movetarget ) {

         self.th_walk ();

      } else {

         self.th_stand ();

      }

   }

};

void () gremlin_pain1 = [ 100.000, gremlin_pain2 ] {

   ai_back (MOVETYPE_STEP);

};

void () gremlin_pain2 = [ 101.000, gremlin_pain3 ] {

   ai_back (MOVETYPE_STEP);

};

void () gremlin_pain3 = [ 102.000, gremlin_pain4 ] {

   ai_back (FL_SWIM);

};

void () gremlin_pain4 = [ 103.000, gremlin_run1 ] {


};

void () gremlin_gunpain1 = [ 161.000, gremlin_gunpain2 ] {

   ai_back (MOVETYPE_STEP);

};

void () gremlin_gunpain2 = [ 162.000, gremlin_gunpain3 ] {

   ai_back (FL_SWIM);

};

void () gremlin_gunpain3 = [ 163.000, gremlin_run1 ] {


};

void (entity attacker, float damage) gremlin_pain = {

   local float r;

   if ( (random () < 0.800) ) {

      self.gorging = FALSE;
      self.enemy = attacker;
      FoundTarget ();

   }
   if ( (self.touch == Gremlin_JumpTouch) ) {

      return ;

   }
   if ( (self.pain_finished > time) ) {

      return ;

   }
   self.pain_finished = (time + TRUE);
   r = random ();
   if ( (r < 0.330) ) {

      sound (self,CHAN_VOICE,"grem/pain1.wav",TRUE,ATTN_NORM);

   } else {

      if ( (r < 0.660) ) {

         sound (self,CHAN_VOICE,"grem/pain2.wav",TRUE,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"grem/pain3.wav",TRUE,ATTN_NORM);

      }

   }
   if ( self.stoleweapon ) {

      gremlin_gunpain1 ();

   } else {

      gremlin_pain1 ();

   }

};

void () gremlin_spawn1 = [ 84.000, gremlin_spawn2 ] {

   self.nextthink = (time + 0.300);
   self.th_pain = SUB_Null;

};

void () gremlin_spawn2 = [ 85.000, gremlin_spawn3 ] {

   self.nextthink = (time + 0.300);

};

void () gremlin_spawn3 = [ 86.000, gremlin_spawn4 ] {

   self.nextthink = (time + 0.300);

};

void () gremlin_spawn4 = [ 87.000, gremlin_spawn5 ] {

   self.nextthink = (time + 0.300);

};

void () gremlin_spawn5 = [ 88.000, gremlin_spawn6 ] {

   self.nextthink = (time + 0.300);

};

void () gremlin_spawn6 = [ 89.000, gremlin_run1 ] {

   self.th_pain = gremlin_pain;

};

void () gremlin_die1 = [ 104.000, gremlin_die2 ] {

   sound (self,CHAN_VOICE,"grem/death.wav",TRUE,ATTN_NORM);

};

void () gremlin_die2 = [ 105.000, gremlin_die3 ] {

   ai_forward (FL_SWIM);

};

void () gremlin_die3 = [ 106.000, gremlin_die4 ] {

   ai_forward (TRUE);

};

void () gremlin_die4 = [ 107.000, gremlin_die5 ] {

   ai_forward (FL_SWIM);

};

void () gremlin_die5 = [ 108.000, gremlin_die6 ] {

   ai_forward (TRUE);

};

void () gremlin_die6 = [ 109.000, gremlin_die7 ] {

   self.solid = SOLID_NOT;

};

void () gremlin_die7 = [ 110.000, gremlin_die8 ] {

   ai_forward (FL_SWIM);

};

void () gremlin_die8 = [ 111.000, gremlin_die9 ] {

   ai_forward (TRUE);

};

void () gremlin_die9 = [ 112.000, gremlin_die10 ] {

   ai_forward (FL_SWIM);

};

void () gremlin_die10 = [ 113.000, gremlin_die11 ] {

   ai_forward (TRUE);

};

void () gremlin_die11 = [ 114.000, gremlin_die12 ] {

   ai_forward (FL_SWIM);

};

void () gremlin_die12 = [ 115.000, gremlin_die12 ] {

   self.think = body_kill;
   self.nextthink = (time + 60.000);

};

void () gremlin_gib = {

   sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
   ThrowHead ("progs/h_grem.mdl",-35.000);
   ThrowGib ("progs/gib1.mdl",-35.000);
   ThrowGib ("progs/gib1.mdl",-35.000);
   ThrowGib ("progs/gib1.mdl",-35.000);

};

void () gremlin_flip1 = [ 116.000, gremlin_flip2 ] {

   ai_face ();
   makevectors (self.angles);
   self.origin_z = (self.origin_z + TRUE);
   self.velocity = ('0.000 0.000 350.000' - (v_forward * MAX_CHARMER_DISTANCE));
   if ( (self.flags & FL_ONGROUND) ) {

      self.flags = (self.flags - FL_ONGROUND);

   }
   sound (self,CHAN_VOICE,"grem/death.wav",TRUE,ATTN_NORM);

};

void () gremlin_flip2 = [ 117.000, gremlin_flip3 ] {

   ai_face ();

};

void () gremlin_flip3 = [ 118.000, gremlin_flip4 ] {


};

void () gremlin_flip4 = [ 119.000, gremlin_flip5 ] {


};

void () gremlin_flip5 = [ 120.000, gremlin_flip6 ] {


};

void () gremlin_flip6 = [ 121.000, gremlin_flip7 ] {

   self.touch = Gremlin_FlipTouch;

};

void () gremlin_flip7 = [ 122.000, gremlin_gib ] {

   self.nextthink = (time + MOVETYPE_WALK);

};

void () gremlin_flip8 = [ 123.000, gremlin_flip8 ] {

   self.solid = SOLID_NOT;
   self.think = body_kill;
   self.nextthink = (time + 60.000);

};

void () GremlinDropBackpack = {

   local entity item;

   item = spawn ();
   item.origin = (self.origin - '0.000 0.000 24.000');
   self.items = (self.items - (self.items & (((IT_SHELLS | IT_NAILS) | IT_ROCKETS) | IT_CELLS)));
   item.items = self.items;
   if ( (item.items & IT_AXE) ) {

      item.netname = "Axe";

   } else {

      if ( (item.items & IT_SHOTGUN) ) {

         item.netname = "Shotgun";

      } else {

         if ( (item.items & IT_SUPER_SHOTGUN) ) {

            item.netname = "Double-barrelled Shotgun";

         } else {

            if ( (item.items & IT_NAILGUN) ) {

               item.netname = "Nailgun";

            } else {

               if ( (item.items & IT_SUPER_NAILGUN) ) {

                  item.netname = "Super Nailgun";

               } else {

                  if ( (item.items & IT_GRENADE_LAUNCHER) ) {

                     item.netname = "Grenade Launcher";

                  } else {

                     if ( (item.items & IT_ROCKET_LAUNCHER) ) {

                        item.netname = "Rocket Launcher";

                     } else {

                        if ( (item.items & IT_LIGHTNING) ) {

                           item.netname = "Thunderbolt";

                        } else {

                           if ( (item.items & IT_LASER_CANNON) ) {

                              item.netname = "Laser Cannon";

                           } else {

                              if ( (item.items & IT_PROXIMITY_GUN) ) {

                                 item.netname = "Proximity Gun";

                              } else {

                                 if ( (item.items & IT_MJOLNIR) ) {

                                    item.netname = "Mjolnir";

                                 } else {

                                    item.netname = "";

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   item.ammo_shells = self.ammo_shells;
   item.ammo_nails = self.ammo_nails;
   item.ammo_rockets = self.ammo_rockets;
   item.ammo_cells = self.ammo_cells;
   if ( (item.ammo_shells < FALSE) ) {

      item.ammo_shells = FALSE;

   }
   if ( (item.ammo_nails < FALSE) ) {

      item.ammo_nails = FALSE;

   }
   if ( (item.ammo_rockets < FALSE) ) {

      item.ammo_rockets = FALSE;

   }
   if ( (item.ammo_cells < FALSE) ) {

      item.ammo_cells = FALSE;

   }
   item.velocity_z = 300.000;
   item.velocity_x = (-100.000 + (random () * MAX_CHARMER_DISTANCE));
   item.velocity_y = (-100.000 + (random () * MAX_CHARMER_DISTANCE));
   item.flags = FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_TOSS;
   setmodel (item,"progs/backpack.mdl");
   setsize (item,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   item.touch = BackpackTouch;
   item.nextthink = (time + TOOCLOSE_CHARMER_DISTANCE);
   item.think = SUB_Remove;

};

void () gremlin_die = {

   local vector vec;
   local float dot;

   if ( (self.items & (((((((IT_SUPER_SHOTGUN | IT_NAILGUN) | IT_SUPER_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_ROCKET_LAUNCHER) | IT_LIGHTNING) | IT_LASER_CANNON) | IT_PROXIMITY_GUN)) ) {

      GremlinDropBackpack ();
      self.stoleweapon = FALSE;

   }
   makevectors (self.angles);
   vec = normalize ((damage_attacker.origin - self.origin));
   dot = (vec * v_forward);
   if ( (self.health < -35.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_grem.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      return ;

   } else {

      if ( (((dot > 0.700) && (random () < 0.500)) && (self.flags & FL_ONGROUND)) ) {

         gremlin_flip1 ();
         return ;

      }

   }
   gremlin_die1 ();

};
float () GremlinWeaponAttack;

void () Gremlin_MeleeAttack = {

   local float num;

   if ( self.gorging ) {

      gremlin_gorge1 ();

   } else {

      if ( (self.stoleweapon == TRUE) ) {

         objerror ("gremlin meleeing with stolen weapon");

      } else {

         if ( ((self.enemy.flags & FL_CLIENT) && (random () < 0.400)) ) {

            if ( GremlinAttemptWeaponSteal () ) {

               return ;

            }

         }

      }
      num = random ();
      if ( (num < 0.300) ) {

         gremlin_claw1 ();

      } else {

         if ( (num < 0.600) ) {

            gremlin_lunge1 ();

         } else {

            gremlin_claw1 ();

         }

      }

   }

};
float () GremlinCheckNoAmmo = {

   if ( (self.currentammo > FALSE) ) {

      return ( TRUE );

   } else {

      self.stoleweapon = FALSE;
      return ( FALSE );

   }

};
entity () GremlinFindVictim = {

   local entity head;
   local entity selected;
   local float dist;
   local float head_dist;

   self.search_time = (time + TRUE);
   selected = world;
   dist = 1000.000;
   head = findradius (self.origin,1000.000);
   while ( head ) {

      if ( (!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT))) ) {

         visible (head);
         if ( ((visible (head) && (head.health > FALSE)) && (head != self)) ) {

            head_dist = vlen ((head.origin - self.origin));
            if ( (head == self.lastvictim) ) {

               head_dist = (head_dist * FL_SWIM);

            }
            if ( (head.flags & FL_CLIENT) ) {

               head_dist = (head_dist / 1.500);

            }
            if ( (head.classname == self.classname) ) {

               head_dist = (head_dist * 1.500);

            }
            if ( (head_dist < dist) ) {

               selected = head;
               dist = head_dist;

            }

         }

      }
      head = head.chain;

   }
   self.lastvictim = selected;
   return ( selected );

};

void () Gremlin_FireRocket = {

   local entity missile;
   local vector dir;

   self.ammo_rockets = (self.ammo_rockets - TRUE);
   self.currentammo = (self.ammo_rockets - TRUE);
   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"weapons/sgun1.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "missile";
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   missile.velocity = normalize (dir);
   missile.velocity = (missile.velocity * 1000.000);
   missile.angles = vectoangles (missile.velocity);
   missile.touch = T_MissileTouch;
   missile.nextthink = (time + MOVETYPE_FLY);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/missile.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));

};

void (float ox) Gremlin_FireNailGun = {

   local vector dir;

   self.ammo_nails = (self.ammo_nails - TRUE);
   self.currentammo = (self.ammo_nails - TRUE);
   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",TRUE,ATTN_NORM);
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   dir = normalize (dir);
   launch_spike ((self.origin + '0.000 0.000 16.000'),dir);

};

void (float ox) Gremlin_FireLaserGun = {

   local vector dir;

   self.ammo_cells = (self.ammo_cells - TRUE);
   self.currentammo = (self.ammo_cells - TRUE);
   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",TRUE,ATTN_NORM);
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   dir = normalize (dir);
   HIP_LaunchLaser ((self.origin + '0.000 0.000 16.000'),dir,FALSE);

};

void () Gremlin_FireShotGun = {

   local vector dir;

   self.ammo_shells = (self.ammo_shells - TRUE);
   self.currentammo = (self.ammo_shells - TRUE);
   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"weapons/guncock.wav",TRUE,ATTN_NORM);
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   dir = normalize (dir);
   self.v_angle = vectoangles (dir);
   FireBullets (MOVETYPE_TOSS,dir,'0.040 0.040 0.000');

};

void () Gremlin_FireSuperShotGun = {

   local vector dir;

   self.ammo_shells = (self.ammo_shells - FL_SWIM);
   self.currentammo = (self.ammo_shells - FL_SWIM);
   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"weapons/shotgn2.wav",TRUE,ATTN_NORM);
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.300) * v_right)) + ((crandom () * 0.300) * v_up));
   dir = normalize (dir);
   self.v_angle = vectoangles (dir);
   FireBullets (14.000,dir,'0.140 0.080 0.000');

};

void () Gremlin_FireLightningGun = {

   local vector org;
   local vector dir;
   local float cells;

   if ( (self.watertype <= CONTENT_WATER) ) {

      cells = self.ammo_cells;
      self.ammo_cells = FALSE;
      discharged = TRUE;
      T_RadiusDamage (self,self,(35.000 * cells),world);
      discharged = FALSE;
      return ;

   }
   self.effects = (self.effects | EF_MUZZLEFLASH);
   ai_face ();
   self.ammo_cells = (self.ammo_cells - FL_SWIM);
   self.currentammo = (self.ammo_cells - FL_SWIM);
   org = (self.origin + '0.000 0.000 16.000');
   dir = ((self.enemy.origin + '0.000 0.000 16.000') - org);
   dir = normalize (dir);
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   dir = normalize (dir);
   traceline (org,(self.origin + (dir * 600.000)),TRUE,self);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,org_x);
   WriteCoord (MSG_BROADCAST,org_y);
   WriteCoord (MSG_BROADCAST,org_z);
   WriteCoord (MSG_BROADCAST,trace_endpos_x);
   WriteCoord (MSG_BROADCAST,trace_endpos_y);
   WriteCoord (MSG_BROADCAST,trace_endpos_z);
   LightningDamage (org,(trace_endpos + (dir * MOVETYPE_STEP)),self,SVC_INTERMISSION);

};

/* No proximity grenade launcher
void () GremlinFireProximityGrenade = {

   local entity missile;
   local vector dir;

   NumProximityGrenades = (NumProximityGrenades + TRUE);
   self.ammo_rockets = (self.ammo_rockets - TRUE);
   self.currentammo = (self.ammo_rockets - TRUE);
   sound (self,CHAN_WEAPON,"weapons/grenade.wav",TRUE,ATTN_NORM);
   missile = spawn ();
   missile.owner = self;
   missile.lastvictim = self;
   missile.movetype = MOVETYPE_TOSS;
   missile.solid = SOLID_BBOX;
   missile.classname = "proximity_grenade";
   missile.takedamage = DAMAGE_NO;
   missile.health = MOVETYPE_FLY;
   missile.state = FALSE;
   dir = normalize ((self.enemy.origin - self.origin));
   self.v_angle = vectoangles (dir);
   makevectors (self.v_angle);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   dir = normalize (dir);
   missile.velocity = (dir * 600.000);
   missile.velocity_z = MAX_CHARMER_DISTANCE;
   missile.avelocity = '100.000 600.000 100.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = ProximityGrenadeTouch;
   missile.nextthink = (time + FL_SWIM);
   missile.delay = ((time + 15.000) + (MOVETYPE_BOUNCE * random ()));
   missile.think = ProximityBomb;
   missile.th_die = ProximityGrenadeExplode;
   setmodel (missile,"progs/proxbomb.mdl");
   setorigin (missile,self.origin);
   setsize (missile,'-1.000 -1.000 -1.000','1.000 1.000 1.000');

};
*/
float () GremlinWeaponAttack = {

   if ( !GremlinCheckNoAmmo () ) {

      return ( FALSE );

   }
   self.show_hostile = (time + TRUE);
   if ( (self.weapon == IT_SHOTGUN) ) {

      gremlin_shot1 ();
      Gremlin_FireShotGun ();
      SUB_AttackFinished (TRUE);

   } else {

      if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

         gremlin_shot1 ();
         Gremlin_FireSuperShotGun ();
         SUB_AttackFinished (TRUE);

      } else {

         if ( (self.weapon == IT_NAILGUN) ) {

            gremlin_nail3 ();
            SUB_AttackFinished (TRUE);

         } else {

            if ( (self.weapon == IT_SUPER_NAILGUN) ) {

               gremlin_nail3 ();
               SUB_AttackFinished (TRUE);

            } else {

               if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                  gremlin_rocket1 ();
                  OgreFireGrenade ();
                  self.ammo_rockets = (self.ammo_rockets - TRUE);
                  self.currentammo = (self.ammo_rockets - TRUE);
                  SUB_AttackFinished (TRUE);

               } else {

                  if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                     gremlin_rocket1 ();
                     Gremlin_FireRocket ();
                     SUB_AttackFinished (TRUE);

                  } else {

                     if ( (self.weapon == IT_LIGHTNING) ) {

                        gremlin_light1 ();
                        SUB_AttackFinished (TRUE);
                        sound (self,CHAN_AUTO,"weapons/lstart.wav",TRUE,ATTN_NORM);

                     } else {

                        if ( (self.weapon == IT_LASER_CANNON) ) {

                           gremlin_laser3 ();
                           SUB_AttackFinished (TRUE);

                        } else {

                           if ( (self.weapon == IT_PROXIMITY_GUN) ) {

                              gremlin_rocket1 ();
                              /*GremlinFireProximityGrenade ();*/
                              SUB_AttackFinished (TRUE);

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   return ( TRUE );

};

void () Gremlin_MissileAttack = {

   if ( self.stoleweapon ) {

      if ( GremlinWeaponAttack () ) {

         return ;

      } else {

         if ( ((random () < 0.100) && (self.flags & FL_ONGROUND)) ) {

            gremlin_jump1 ();
            return ;

         }

      }

   }
   if ( (self.flags & FL_ONGROUND) ) {

      gremlin_jump1 ();

   }

};

void () monster_gremlin = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   NumGremlins = (NumGremlins + TRUE);
   precache_model ("progs/grem.mdl");
   precache_model ("progs/h_grem.mdl");
   precache_sound ("grem/death.wav");
   precache_sound ("grem/attack.wav");
   precache_sound ("demon/djump.wav");
   precache_sound ("demon/dhit2.wav");
   precache_sound ("grem/pain1.wav");
   precache_sound ("grem/pain2.wav");
   precache_sound ("grem/pain3.wav");
   precache_sound ("grem/idle.wav");
   precache_sound ("grem/sight1.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/grem.mdl");
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   self.health = 100.000;
   self.max_health = 101.000;
   self.yaw_speed = 40.000;
   self.th_stand = gremlin_stand1;
   self.th_walk = gremlin_walk1;
   self.th_run = gremlin_run1;
   self.th_die = gremlin_die;
   self.th_melee = Gremlin_MeleeAttack;
   self.th_missile = Gremlin_MissileAttack;
   self.th_pain = gremlin_pain;
   walkmonster_start ();

};
float () GremlinCheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   targ = self.enemy;
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   spot1 = self.origin;
   spot2 = targ.origin;
   if ( ((vlen ((spot2 - spot1)) <= 90.000) && (self.stoleweapon == FALSE)) ) {

      self.attack_state = AS_MELEE;
      return ( TRUE );

   }
   chance = (0.030 + self.stoleweapon);
   if ( (random () < chance) ) {

      self.attack_state = AS_MISSILE;
      return ( TRUE );

   }
   return ( FALSE );

};

void (float side) Gremlin_Melee = {

   local float ldmg;
   local vector delta;

   ai_face ();
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 100.000) ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   sound (self,CHAN_WEAPON,"grem/attack.wav",TRUE,ATTN_NORM);
   ldmg = (MOVETYPE_BOUNCE + (MOVETYPE_FLY * random ()));
   T_Damage (self.enemy,self,self,ldmg);
   makevectors (self.angles);
   SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),(side * v_right));

};

void (float dm) Gremlin_ThrowHead = {

   local string gibname;

   if ( (self.classname == "monster_ogre") ) {

      gibname = "progs/h_ogre.mdl";

   } else {

      if ( (self.classname == "monster_knight") ) {

         gibname = "progs/h_knight.mdl";

      } else {

         if ( (self.classname == "monster_shambler") ) {

            gibname = "progs/h_shams.mdl";

         } else {

            if ( (self.classname == "monster_demon1") ) {

               gibname = "progs/h_demon.mdl";

            } else {

               if ( (self.classname == "monster_wizard") ) {

                  gibname = "progs/h_wizard.mdl";

               } else {

                  if ( (self.classname == "monster_zombie") ) {

                     gibname = "progs/h_zombie.mdl";

                  } else {

                     if ( (self.classname == "monster_dog") ) {

                        gibname = "progs/h_dog.mdl";

                     } else {

                        if ( (self.classname == "monster_hell_knight") ) {

                           gibname = "progs/h_hellkn.mdl";

                        } else {

                           if ( (self.classname == "monster_enforcer") ) {

                              gibname = "progs/h_mega.mdl";

                           } else {

                              if ( (self.classname == "monster_army") ) {

                                 gibname = "progs/h_guard.mdl";

                              } else {

                                 if ( (self.classname == "monster_shalrath") ) {

                                    gibname = "progs/h_shal.mdl";

                                 } else {

                                    if ( (self.classname == "monster_gremlin") ) {

                                       gibname = "progs/h_grem.mdl";

                                    } else {

                                       if ( (self.classname == "monster_scourge") ) {

                                          gibname = "progs/h_scourg.mdl";

                                       } else {

                                          if ( (self.classname == "monster_fish") ) {

                                             gibname = "progs/gib1.mdl";

                                          } else {

                                             gibname = "progs/h_player.mdl";

                                          }

                                       }

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   ThrowHead (gibname,dm);

};

void (entity targ, entity inflictor, entity attacker, float damage) Gremlin_Damage = {

   if ( (targ.flags & FL_GODMODE) ) {

      return ;

   }
   if ( (targ.invincible_finished >= time) ) {

      if ( (self.invincible_sound < time) ) {

         sound (targ,CHAN_ITEM,"items/protect3.wav",TRUE,ATTN_NORM);
         self.invincible_sound = (time + FL_SWIM);

      }
      return ;

   }
   if ( (((teamplay == TRUE) && (targ.team > FALSE)) && (targ.team == attacker.team)) ) {

      return ;

   }
   targ.health = (targ.health - damage);

};

void () Gremlin_Split = {

   local entity grem;
   local entity temp;
   local entity head;
   local float done;
   local vector ang;
   local float c;
   local vector pos;
   local float proceed;

   if ( (NumSpawnGremlins >= (NumGremlins * FL_SWIM)) ) {

      return ;

   }
   done = FALSE;
   c = FALSE;
   ang = self.angles;
   while ( (done == FALSE) ) {

      makevectors (ang);
      pos = (self.origin + (80.000 * v_forward));
      head = findradius (pos,35.000);
      proceed = TRUE;
      while ( head ) {

         if ( ((head.health > FALSE) && (head.flags & (FL_MONSTER | FL_CLIENT))) ) {

            proceed = FALSE;

         }
         head = head.chain;

      }
      traceline (self.origin,pos,FALSE,self);
      if ( ((trace_fraction == TRUE) && (proceed == TRUE)) ) {

         traceline (self.origin,(pos - '40.000 40.000 0.000'),FALSE,self);
         if ( (trace_fraction == TRUE) ) {

            traceline (self.origin,(pos + '40.000 40.000 0.000'),FALSE,self);
            if ( (trace_fraction == TRUE) ) {

               traceline (self.origin,(pos + '0.000 0.000 64.000'),FALSE,self);
               if ( (trace_fraction == TRUE) ) {

                  traceline (self.origin,(pos - '0.000 0.000 64.000'),FALSE,self);
                  if ( (trace_fraction != TRUE) ) {

                     done = TRUE;

                  }

               }

            }

         }

      }
      if ( (done == FALSE) ) {

         ang_y = (ang_y + 36.000);
         c = (c + TRUE);
         if ( (c == MOVETYPE_BOUNCE) ) {

            return ;

         }

      }

   }
   NumSpawnGremlins = (NumSpawnGremlins + TRUE);
   grem = spawn ();
   SUB_CopyEntity (self,grem);
   grem.solid = SOLID_SLIDEBOX;
   grem.movetype = MOVETYPE_STEP;
   setmodel (grem,"progs/grem.mdl");
   setsize (grem,VEC_HULL_MIN,VEC_HULL_MAX);
   if ( (self.health < 100.000) ) {

      self.health = 100.000;

   }
   grem.health = (self.health / FL_SWIM);
   self.health = (self.health / FL_SWIM);
   grem.stoleweapon = FALSE;
   grem.items = FALSE;
   total_monsters = (total_monsters + TRUE);
   WriteByte (MSG_BROADCAST,SVC_UPDATESTAT);
   WriteByte (MSG_BROADCAST,STAT_TOTALMONSTERS);
   WriteLong (MSG_BROADCAST,total_monsters);
   setorigin (grem,pos);
   temp = self;
   self = grem;
   gremlin_spawn1 ();
   self.enemy = world;
   self.gorging = FALSE;
   self = temp;

};

void (float side) Gremlin_Gorge = {

   local float ldmg;
   local vector delta;
   local entity temp;

   delta = (self.enemy.origin - self.origin);
   sound (self,CHAN_WEAPON,"demon/dhit2.wav",TRUE,ATTN_NORM);
   ldmg = (MOVETYPE_PUSH + (MOVETYPE_FLY * random ()));
   Gremlin_Damage (self.enemy,self,self,ldmg);
   makevectors (self.angles);
   SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),(side * v_right));
   if ( (self.enemy.health < -200.000) ) {

      if ( (self.enemy.gorging == FALSE) ) {

         self.enemy.gorging = TRUE;
         sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
         temp = self;
         self = self.enemy;
         Gremlin_ThrowHead (-15.000);
         self = temp;
         ldmg = (MIN_CHARMER_DISTANCE + (100.000 * random ()));
         T_Heal (self,ldmg,FALSE);
         Gremlin_Split ();

      }
      self.enemy = world;
      self.gorging = FALSE;
      gremlin_look1 ();

   }

};

void () Gremlin_JumpTouch = {

   if ( (self.health <= FALSE) ) {

      return ;

   }
   if ( !checkbottom (self) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.touch = SUB_Null;
         self.think = gremlin_jump1;
         self.nextthink = (time + 0.100);

      }
      return ;

   }
   self.touch = SUB_Null;
   self.think = gremlin_jump12;
   self.nextthink = (time + 0.100);

};

void () Gremlin_FlipTouch = {

   if ( !checkbottom (self) ) {

      if ( (self.flags & FL_ONGROUND) ) {

         self.touch = SUB_Null;
         self.think = gremlin_flip1;
         self.nextthink = (time + 0.100);

      }
      return ;

   }
   self.touch = SUB_Null;
   self.think = gremlin_flip8;
   self.nextthink = (time + 0.100);

};
