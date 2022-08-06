
void () sphere_think = {

   if ( (self.shieldSoundTime < time) ) {

      sound (self,CHAN_VOICE,"sphere/sphere.wav",TRUE,ATTN_NORM);
      self.shieldSoundTime = (time + MOVETYPE_STEP);

   }
   if ( (self.delay < time) ) {

      if ( (self.owner.items & IT2_V_SPHERE) ) {

         self.owner.items = (self.owner.items - IT2_V_SPHERE);

      }
      sprint (self.owner,"Riddle Orb ended\n");
      self.nextthink = (time + MOVETYPE_BOUNCE);
      self.think = SUB_regen;
      return ;

   }
   if ( (self.owner.health < TRUE) ) {

      if ( (self.owner.items & IT2_V_SPHERE) ) {

         self.owner.items = (self.owner.items - IT2_V_SPHERE);

      }
      sprint (self.owner,"Riddle Orb dropped\n");
      self.nextthink = (time + MOVETYPE_BOUNCE);
      self.think = SUB_regen;
      return ;

   }
   centerprint (self.owner,self.message);
   self.think = sphere_think;
   self.nextthink = (time + FL_SWIM);

};
void () sphere_spawn = {

   self.owner = other;
   self.delay = (time + 15.000);
   self.think = sphere_think;
   self.nextthink = (time + 0.100);

};
void () item_sphere = {

   precache_model ("progs/sphere.mdl");
   precache_sound ("sphere/sphere.wav");
   self.noise = "sphere/sphere.wav";
   self.netname = " Riddle Orb";
   if (!(self.message) ) {

      self.message = "This Riddle Orb is empty";

   }
   self.items = IT2_V_SPHERE;
   self.touch = powerup_touch;
   setmodel (self,"progs/sphere.mdl");
   setsize (self,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.avelocity = '40.000 40.000 40.000';
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
