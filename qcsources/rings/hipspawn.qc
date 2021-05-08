
.entity spawnfunction;

void () spawn_use = {

   local entity tempent;
   local entity powerup;
   local vector org;

   powerup = self.spawnfunction;
   makevectors (powerup.angles);
   org = (self.origin + (FL_MONSTER * v_forward));
   spawn_tfog (org);
   setorigin (powerup,self.origin);
   tempent = self;
   self = powerup;
   StartItemFloating ();

};
void () func_spawn = {

   local entity tempself;

   tempself = self;
   if ( !self.spawnfunction ) {

      objerror("Spawn without function");

   }
   self = tempself;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   self.modelindex = FALSE;
   self.model = "";
   setmodel (self,self.model);
   self.use = spawn_use;

};