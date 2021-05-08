
float LADDER_DISABLED = 1.000;

void () ladder_touch = {

   if ( (other.movetype == MOVETYPE_NOCLIP) ) {

      return ;

   }
   if ( (other.health < FALSE) ) {

      return ;

   }
   if (!(other) ) {

      self.think = SUB_Null;
      self.nextthink = (time + 0.200);
      return ;

   }
   if (!(self.ladder_active) ) {

      return ;

   }
   other.waterlevel = FL_SWIM;
   other.watertype = CONTENT_LADDER;
   other.previous_content = CONTENT_LADDER;
   self.think = ladder_touch;
   self.nextthink = (time + 0.200);

};
void () ladder_use = {

   if (!(self.ladder_active) ) {

      self.ladder_active = TRUE;

   } else {

      self.ladder_active = FALSE;

   }

};
void () func_ladder = {

   self.angles = VEC_ORIGIN;
   self.solid = SOLID_TRIGGER;
   setmodel (self,self.model);
   self.movetype = MOVETYPE_NONE;
   self.model = "";
   self.touch = ladder_touch;
   self.use = SUB_Null;
   self.ladder_active = TRUE;

};
void () func_ladder_toggle = {

   func_ladder ();
   self.use = ladder_use;
   if ( (self.spawnflags & LADDER_DISABLED) ) {

      self.ladder_active = FALSE;

   }

};
