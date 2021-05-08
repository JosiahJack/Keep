
void  ()pathcorner_touch =  {
local entity temp;
   if ( (other.pathentity != self) ) {

      return ;

   }
   if ( other.enemy ) {

      return ;

   }
   if ( ((self.wait == -2.00000) && (other.flags & FL_MONSTER)) ) {

      remove ( other);

   }
   temp = self;
   self = other;
   other = temp;
   self.pathentity = find ( world, targetname, other.target);
   self.goalentity = find ( world, targetname, other.target);
   self.ideal_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
   if ( !self.pathentity ) {

      self.pausetime = (time + 999999.00000);
      self.th_stand ( );
      return ;

   }
};

float SYNCH   =  1.00000;

void  ()path_corner =  {
   if ( !self.targetname ) {

      objerror ( "path_corner has no targetname");

   }
   if ( !self.mangle ) {

      self.mangle = self.angles;

   }
   self.solid = SOLID_TRIGGER;
   self.touch = pathcorner_touch;
   setsize ( self, '-8.00000 -8.00000 -8.00000', '8.00000 8.00000 8.00000');
};

