void () UpdateCharmerGoal = {
   local entity targ;
   local vector d;

   d = normalize ((self.origin - self.charmer.origin));
   if ( (self.huntingcharmer == TRUE) ) {
      targ = spawn ();
      self.trigger_field = targ;
      setorigin (targ,self.charmer.origin);
      self.huntingcharmer = FL_SWIM;
      self.goalentity = targ;
   }
   if ( (self.huntingcharmer == FL_SWIM) ) {
      targ = self.trigger_field;
      traceline (self.origin,self.charmer.origin,TRUE,self);
      if ( (trace_fraction == TRUE) ) setorigin (targ,self.charmer.origin);
   } else {
      targ = self.trigger_field;
      setorigin (targ,(self.charmer.origin + (d * 300)));
   }
};

void () HuntCharmer = {
   self.huntingcharmer = TRUE;
   UpdateCharmerGoal ();
   if (self.th_walk) self.think = self.th_walk;
	else self.think = SUB_Null;
   self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
   self.nextthink = (time + 0.100);
};

void () FleeCharmer = {
   self.huntingcharmer = TRUE;
   UpdateCharmerGoal ();
   self.huntingcharmer = MOVETYPE_WALK;
   if (self.th_walk) self.think = self.th_walk;
	else self.think = SUB_Null;
   self.nextthink = (time + 0.100);
};

void () StopHuntingCharmer = {
   self.goalentity = world;
   if ( (self.huntingcharmer > TRUE) ) remove (self.trigger_field);
   self.huntingcharmer = FALSE;
   if (self.th_stand) self.think = self.th_stand;
	else self.think = SUB_Null;
   self.nextthink = (time + 0.100);
};