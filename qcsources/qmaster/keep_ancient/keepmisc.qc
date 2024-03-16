void () light_candle = {

   precache_model ("progs/candle.mdl");
   setmodel (self,"progs/candle.mdl");
   makestatic (self);

};

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

void () body_kill = {

   if ( (self.classname != "player") ) {

      remove (self);

   }

};

