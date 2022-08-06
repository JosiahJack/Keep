
void () push_use = {

   local vector delta;
   local float x;
   local float y;

   makevectors (other.angles);
   x = fabs (other.velocity_x);
   y = fabs (other.velocity_y);
   dprint (ftos (x));
   dprint (", ");
   dprint (ftos (y));
   if ( (x > y) ) {

      dprint (" x move\n\n\n\n");
      if ( (other.velocity_x > FALSE) ) {

         walkmove (FALSE,(FL_INWATER * frametime));

      } else {

         walkmove (180.000,(FL_INWATER * frametime));

      }

   } else {

      dprint (" y move\n\n\n\n");
      if ( (other.velocity_y > FALSE) ) {

         walkmove (90.000,(FL_INWATER * frametime));

      } else {

         walkmove (270.000,(FL_INWATER * frametime));

      }

   }
   delta = (self.origin - self.oldorigin);
   setorigin (self.owner,(self.owner.oldorigin + delta));

};

void () func_pushable = {

   local entity new;
   local vector newsize;

   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.classname = "pushablewall";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setmodel (self,self.model);
   setorigin (self,self.origin);
   setsize (self,self.mins,self.maxs);
   self.oldorigin = self.origin;
   new = spawn ();
   new.owner = self;
   new.mangle = self.mangle;
   new.angles = self.angles;
   new.classname = "pushablewallproxy";
   new.solid = SOLID_BBOX;
   new.movetype = MOVETYPE_STEP;
   new.origin = (((self.mins + self.maxs) * 0.500) + '0.000 0.000 1.000');
   newsize = ((self.maxs - self.mins) * 0.500);
   new.mins = ('-1.000 -1.000 0.000' - newsize);
   new.maxs = ('1.000 1.000 -2.000' + newsize);
   setsize (new,new.mins,new.maxs);
   setorigin (new,new.origin);
   new.oldorigin = new.origin;
   new.touch = push_use;

};
