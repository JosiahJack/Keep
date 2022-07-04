
void() bobbingwater_think = {
   local vector ang;

   self.count = (self.count + (self.speed * (time - self.ltime)));
   if ( (self.count > 360.000) ) self.count = (self.count - 360.000);
   ang_x = self.count;
   ang_y = FALSE;
   ang_z = FALSE;
   makevectors(ang);
   self.origin_z = (v_forward_z * self.cnt);
   setorigin (self,self.origin);
   self.ltime = time;
   self.nextthink = (time + 0.020);
};

void() func_bobbingwater = {
   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_STEP;
   self.solid = SOLID_NOT;
   setmodel (self,self.model);
   self.think = bobbingwater_think;
   self.count = FALSE;
   self.cnt = (self.size_z / FL_SWIM);
   if (self.speed <= 0) self.speed = 4;
   self.speed = (360.000 / self.speed);
   self.nextthink = (time + 0.020);
   self.ltime = time;
};
