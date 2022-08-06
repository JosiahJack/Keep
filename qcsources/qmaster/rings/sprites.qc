
void () env_sprite = {

   if ( self.model ) {

      precache_model (self.model);
      setmodel (self,self.model);
      makestatic (self);

   } else {

      objerror ("Sprite without a model");
      return ;

   }

};
void () drip_spawn = {

   local entity edrop;

   edrop = spawn ();
   setmodel (edrop,self.model);
   setorigin (edrop,self.origin);
   edrop.movetype = MOVETYPE_NOCLIP;
   edrop.solid = SOLID_NOT;
   edrop.velocity = self.s_speed;
   edrop.classname = "drop";
   edrop.frame = FALSE;
   setsize (edrop,'-1.000 -1.000 -1.000','1.000 1.000 1.000');
   edrop.think = SUB_Remove;
   edrop.nextthink = (time + (self.delay * FL_SWIM));
   self.think = drip_spawn;
   self.nextthink = (time + self.delay);

};
void () env_drip = {

   if ( (self.model) ) {

      precache_model(self.model);

   } else {
      
      precache_model("progs/drip1.mdl");
      self.model = "progs/drip1.mdl";

   }
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   self.netname = "env_drip";
   if (!(self.delay) ) {

      self.delay = 10.000;

   }
   if (!(self.s_speed) ) {

      self.s_speed = '0.000 0.000 -100.000';

   }
   self.think = drip_spawn;
   self.nextthink = (time + self.delay);

};