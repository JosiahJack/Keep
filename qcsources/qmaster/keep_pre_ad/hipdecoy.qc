
void () decoy_stand1 = [ 17.000, decoy_stand1 ] {

   ChangeYaw ();
   if ( (self.walkframe >= MOVETYPE_FLY) ) {

      self.walkframe = FALSE;

   }
   self.frame = (STAT_TOTALMONSTERS + self.walkframe);
   self.walkframe = (self.walkframe + TRUE);
   if ( (time > self.pausetime) ) {

      self.th_walk ();

   }

};

void () decoy_walk1 = [ 6.000, decoy_walk1 ] {

   local float r;

   movetogoal (STAT_TOTALMONSTERS);
   self.weaponframe = FALSE;
   if ( (self.walkframe == MOVETYPE_TOSS) ) {

      self.walkframe = FALSE;

   }
   if ( ((self.walkframe == FL_SWIM) || (self.walkframe == MOVETYPE_FLY)) ) {

      r = random ();
      if ( (r < 0.140) ) {

         sound (self,CHAN_VOICE,"misc/foot1.wav",0.500,ATTN_NORM);

      } else {

         if ( (r < 0.290) ) {

            sound (self,CHAN_VOICE,"misc/foot2.wav",0.500,ATTN_NORM);

         } else {

            if ( (r < 0.430) ) {

               sound (self,CHAN_VOICE,"misc/foot3.wav",0.500,ATTN_NORM);

            } else {

               if ( (r < 0.580) ) {

                  sound (self,CHAN_VOICE,"misc/foot4.wav",0.500,ATTN_NORM);

               } else {

                  if ( (r < 0.720) ) {

                     sound (self,CHAN_VOICE,"misc/foot5.wav",0.500,ATTN_NORM);

                  } else {

                     if ( (r < 0.860) ) {

                        sound (self,CHAN_VOICE,"misc/foot6.wav",0.500,ATTN_NORM);

                     } else {

                        sound (self,CHAN_VOICE,"misc/foot7.wav",0.500,ATTN_NORM);

                     }

                  }

               }

            }

         }

      }

   }
   self.frame = (self.frame + self.walkframe);
   self.walkframe = (self.walkframe + TRUE);

};

void (entity decoy) setup_decoy = {

   local entity pl;

   decoy.classname = "monster_decoy";
   setmodel (decoy,"progs/player.mdl");
   setsize (decoy,VEC_HULL_MIN,VEC_HULL_MAX);
   decoy.view_ofs = '0.000 0.000 22.000';
   decoy.solid = SOLID_SLIDEBOX;
   decoy.movetype = MOVETYPE_STEP;
   decoy.health = 3000000.000;
   decoy.th_stand = decoy_stand1;
   decoy.th_walk = decoy_walk1;
   decoy.th_run = decoy_walk1;
   decoy.th_missile = decoy_stand1;
   decoy.th_pain = decoy_stand1;
   decoy.th_die = decoy_stand1;
   pl = find (world,classname,"player");
   decoy.colormap = pl.colormap;

};

void () monster_decoy = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   setup_decoy (self);
   walkmonster_start ();
   total_monsters = (total_monsters - TRUE);

};

void (string targ, vector orig) become_decoy = {

   local entity decoy;
   local entity temp;

   hipdecoy = spawn ();
   decoy = spawn ();
   temp = self;
   self = decoy;
   setup_decoy (decoy);
   setorigin (decoy,orig);
   decoy.origin = orig;
   decoy.target = targ;
   decoy.takedamage = DAMAGE_AIM;
   decoy.ideal_yaw = (decoy.angles * '0.000 1.000 0.000');
   if ( !decoy.yaw_speed ) {

      decoy.yaw_speed = 20.000;

   }
   decoy.use = monster_use;
   decoy.flags = (decoy.flags | FL_MONSTER);
   if ( decoy.target ) {

      decoy.movetarget = find (world,targetname,decoy.target);
      decoy.goalentity = find (world,targetname,decoy.target);
      decoy.ideal_yaw = vectoyaw ((decoy.goalentity.origin - decoy.origin));
      if ( !decoy.movetarget ) {

         dprint ("Monster can't find target at ");
         dprint (vtos (decoy.origin));
         dprint ("\n");

      }
      if ( (decoy.movetarget.classname == "path_corner") ) {

         decoy.th_walk ();

      } else {

         decoy.pausetime = 100000000.000;

      }
      decoy.th_stand ();

   } else {

      decoy.pausetime = 100000000.000;
      decoy.th_stand ();

   }
   decoy.nextthink = (decoy.nextthink + (random () * 0.500));
   self = temp;

};
