
void () buzzsaw_stand1 = [ 0.000, buzzsaw_stand1 ] {

   if ( (self.pain_finished < time) ) {

      sound (self,CHAN_VOICE,"buzz/buzz1.wav",0.200,ATTN_NORM);
      self.pain_finished = (time + TRUE);

   }
   self.angles_x = (self.angles_x - 60.000);
   self.avelocity_x = 60.000;

};

void () buzzsaw_fly = {

   local vector dir;

   if ( (self.pain_finished < time) ) {

      sound (self,CHAN_VOICE,"buzz/buzz1.wav",0.200,ATTN_NORM);
      self.pain_finished = (time + TRUE);

   }
   dir = (self.goalentity.origin - self.origin);
   dir = normalize (dir);
   dir = (dir * self.speed);
   setorigin (self,(self.origin + dir));
   self.angles_x = (self.angles_x - 60.000);
   self.avelocity_x = 60.000;

};

void () buzzsaw_fly1 = [ 1.000, buzzsaw_fly1 ] {

   buzzsaw_fly ();

};

void () buzzsaw_touch = {

   local vector sprayDir;

   if ( ((other.classname == "player") || (other.flags & FL_MONSTER)) ) {

      if ( (self.attack_finished < time) ) {

         sound (self,CHAN_WEAPON,"buzz/buzz.wav",TRUE,ATTN_NORM);
         self.attack_finished = (time + FL_SWIM);

      }
      T_Damage (other,self,self,self.currentammo);
      sprayDir = normalize ((self.goalentity.origin - self.origin));
      sprayDir = (sprayDir * 200.000);
      SpawnMeatSpray (self.origin,sprayDir);
      other.velocity = sprayDir;
      other.velocity_z = 200.000;

   }

};

void () buzzsaw_touch_off = {

   local vector sprayDir;

   if ( ((other.classname == "player") || (other.flags & FL_MONSTER)) ) {

      T_Damage (other,self,self,(self.currentammo*0.5));
      sprayDir = normalize ((self.goalentity.origin - self.origin));
      sprayDir = (sprayDir * 100.000);
      other.velocity = sprayDir;
      other.velocity_z = 100.000;

   }

};

void () buzzsaw_use = {

   self.touch = buzzsaw_touch;
   if ( self.target ) {

      self.movetarget = find (world,targetname,self.target);
      self.goalentity = self.movetarget;
      self.th_stand = buzzsaw_fly1;
      self.th_walk = buzzsaw_fly1;
      self.th_run = buzzsaw_fly1;
      self.think = buzzsaw_fly1;
      self.nextthink = (time + 0.100);

   } else {

      self.nextthink = (time + 0.100);
      self.think = buzzsaw_stand1;

   }
   self.use = SUB_Null;

};

void () buzzsaw = {

   precache_model ("progs/buzzsaw.mdl");
   precache_sound ("buzz/buzz.wav");
   precache_sound ("buzz/buzz1.wav");
   setmodel (self,"progs/buzzsaw.mdl");
   self.takedamage = DAMAGE_NO;
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_FLY;
   if ( ((self.angles_y == FALSE) || (self.angles_y == 180.000)) ) {

      setsize (self,'-18.000 0.000 -18.000','18.000 0.000 18.000');

   } else {

      if ( ((self.angles_y == 90.000) || (self.angles_y == 270.000)) ) {

         setsize (self,'0.000 -18.000 -18.000','0.000 18.000 18.000');

      } else {

         if ( (self.spawnflags & TRUE) ) {

            setsize (self,'-18.000 -18.000 -18.000','18.000 18.000 18.000');

         } else {

            if ( ((self.angles_z == 90.000) || (self.angles_z == 270.000)) ) {

               setsize (self,'-18.000 -18.000 0.000','18.000 18.000 0.000');

            } else {

            objerror ("Buzzsaw: Not at 90 degree angle!");

            }

         }

      }

   }
   setorigin (self,self.origin);
   if ( !self.speed ) {

      self.speed = MOVETYPE_BOUNCE;

   }
   if ( !self.currentammo ) {

      self.currentammo = MOVETYPE_BOUNCE;

   }
   self.pain_finished = (time + (random () * FL_SWIM));
   if ( !self.targetname ) {

      self.think = buzzsaw_use;
      self.nextthink = (time + 0.200);

   } else {

      self.touch = buzzsaw_touch_off;
      self.use = buzzsaw_use;

   }

};
