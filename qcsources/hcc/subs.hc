void  ()SUB_CalcMoveDone;
void  ()SUB_CalcAngleMoveDone;
float SPAWNFLAG_ACTIVATED   =  8.00000;

void  ()SUB_Null =  {
};


void  ()SUB_Remove =  {
   remove ( self);
};


void  ()SetMovedir =  {
   if ( (self.angles == '0.00000 -1.00000 0.00000') ) {

      self.movedir = '0.00000 0.00000 1.00000';
   } else {

      if ( (self.angles == '0.00000 -2.00000 0.00000') ) {

         self.movedir = '0.00000 0.00000 -1.00000';
      } else {

         makevectors ( self.angles);
         self.movedir = v_forward;

      }

   }
   self.angles = '0.00000 0.00000 0.00000';
};


void  ()InitTrigger =  {
   if ( (self.angles != '0.00000 0.00000 0.00000') ) {

      SetMovedir ( );

   }
   setmodel ( self, self.model);
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_NONE;
   self.modelindex = 0.00000;
   self.model = "";
   if ( (self.spawnflags & SPAWNFLAG_ACTIVATED) ) {

      self.inactive = TRUE;

   }
};


void  (vector tdest,float tspeed,void() func)SUB_CalcMove =  {
local vector vdestdelta = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float traveltime = 0.00000;
   if ( !tspeed ) {

      objerror ( "No speed is defined!");

   }
   self.think1 = func;
   self.finaldest = tdest;
   self.think = SUB_CalcMoveDone;
   if ( (tdest == self.origin) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      self.nextthink = (self.ltime + 0.10000);
      return ;

   }
   vdestdelta = (tdest - self.origin);
   len = vlen ( vdestdelta);
   traveltime = (len / tspeed);
   if ( (traveltime < 0.10000) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      self.nextthink = (self.ltime + 0.10000);
      return ;

   }
   self.nextthink = (self.ltime + traveltime);
   self.velocity = (vdestdelta * (1.00000 / traveltime));
};


void  ()SUB_CalcMoveDone =  {
   setorigin ( self, self.finaldest);
   self.velocity = '0.00000 0.00000 0.00000';
   self.nextthink = -1.00000;
   if ( self.think1 ) {

      self.think1 ( );

   }
};


void  (vector destangle,float tspeed,void() func)SUB_CalcAngleMove =  {
local vector destdelta = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float traveltime = 0.00000;
   if ( !tspeed ) {

      objerror ( "SUB_CalcAngleMove: No speed defined!");

   }
   destdelta = (destangle - self.angles);
   len = vlen ( destdelta);
   traveltime = (len / tspeed);
   self.nextthink = (self.ltime + traveltime);
   self.avelocity = (destdelta * (1.00000 / traveltime));
   self.think1 = func;
   self.finalangle = destangle;
   self.think = SUB_CalcAngleMoveDone;
};


void  ()SUB_CalcAngleMoveDone =  {
   self.angles = self.finalangle;
   self.avelocity = '0.00000 0.00000 0.00000';
   self.nextthink = -1.00000;
   if ( self.think1 ) {

      self.think1 ( );

   }
};


void  ()SUB_CalcMoveAndAngleDone =  {
   setorigin ( self, self.finaldest);
   self.angles = self.finalangle;
   self.avelocity = '0.00000 0.00000 0.00000';
   self.velocity = '0.00000 0.00000 0.00000';
   self.nextthink = -1.00000;
   if ( self.think1 ) {

      self.think1 ( );

   }
};

void  ()SUB_CalcAngleOnlyDone;

void  ()SUB_CalcMoveOnlyDone =  {
   setorigin ( self, self.finaldest);
   self.velocity = '0.00000 0.00000 0.00000';
   self.movetime = 0.00000;
   if ( (self.angletime > 0.00000) ) {

      self.think = SUB_CalcAngleOnlyDone;
      self.nextthink = (self.ltime + self.angletime);
   } else {

      SUB_CalcMoveAndAngleDone ( );

   }
};


void  ()SUB_CalcAngleOnlyDone =  {
   self.angles = self.finalangle;
   self.avelocity = '0.00000 0.00000 0.00000';
   self.angletime = 0.00000;
   if ( (self.movetime > 0.00000) ) {

      self.think = SUB_CalcMoveOnlyDone;
      self.nextthink = (self.ltime + self.movetime);
   } else {

      SUB_CalcMoveAndAngleDone ( );

   }
};


void  (float synchronize)SUB_CalcMoveAndAngle =  {
local vector vdestdelta = '0.00000 0.00000 0.00000';
local vector destdelta = '0.00000 0.00000 0.00000';
local float len = 0.00000;
local float alen = 0.00000;
   if ( !self.speed ) {

      objerror ( "No speed is defined!");

   }
   if ( (self.finaldest == self.origin) ) {

      self.velocity = '0.00000 0.00000 0.00000';
      self.movetime = 0.00000;
   } else {

      vdestdelta = (self.finaldest - self.origin);
      len = vlen ( vdestdelta);
      self.movetime = (len / self.speed);
      if ( (self.movetime < 0.10000) ) {

         self.velocity = '0.00000 0.00000 0.00000';
         self.movetime = 0.10000;

      }
      self.velocity = (vdestdelta * (1.00000 / self.movetime));

   }
   if ( (self.angles == self.finalangle) ) {

      self.avelocity = '0.00000 0.00000 0.00000';
      self.angletime = 0.00000;
   } else {

      destdelta = (self.finalangle - self.angles);
      alen = vlen ( destdelta);
      if ( !synchronize ) {

         if ( !self.anglespeed ) {

            objerror ( "SUB_CalcAngleMove: No speed defined!");

         }
      } else {

         self.anglespeed = ((self.speed / len) * alen);

      }
      self.angletime = (alen / self.anglespeed);
      self.avelocity = (destdelta * (1.00000 / self.angletime));

   }
   if ( (self.movetime <= 0.00000) ) {

      self.movetime = self.angletime;

   }
   if ( (self.angletime <= 0.00000) ) {

      self.angletime = self.movetime;

   }
   if ( (self.movetime > self.angletime) ) {

      self.movetime -= self.angletime;
      self.think = SUB_CalcAngleOnlyDone;
      self.nextthink = (self.ltime + self.angletime);
   } else {

      if ( (self.movetime < self.angletime) ) {

         self.angletime -= self.movetime;
         self.think = SUB_CalcMoveOnlyDone;
         self.nextthink = (self.ltime + self.movetime);
      } else {

         self.think = SUB_CalcMoveAndAngleDone;
         self.nextthink = (self.ltime + self.movetime);

      }

   }
};


void  (vector tdest,float tspeed,vector destangle,float aspeed,void() func,float synchronize)SUB_CalcMoveAndAngleInit =  {
   self.finaldest = tdest;
   self.speed = tspeed;
   self.finalangle = destangle;
   self.anglespeed = aspeed;
   self.think1 = func;
   SUB_CalcMoveAndAngle ( synchronize);
};


void  ()DelayThink =  {
   activator = self.enemy;
   SUB_UseTargets ( );
   remove ( self);
};


void  ()SUB_UseTargets =  {
local entity t;
local entity stemp;
local entity otemp;
local entity act;
local string s;
   if ( self.delay ) {

      t = spawn ( );
      t.classname = "DelayedUse";
      AdvanceThinkTime(t,self.delay);
      t.think = DelayThink;
      t.enemy = activator;
      t.message = self.message;
      t.killtarget = self.killtarget;
      t.target = self.target;
      return ;

   }
   if ( ((activator.classname == "player") && (self.message != 0.00000)) ) {

      s = getstring ( self.message);
      centerprint ( activator, s);
      if ( !self.noise ) {

         sound ( activator, CHAN_VOICE, "misc/comm.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( self.killtarget ) {

      t = world;
      do {

         t = find ( t, targetname, self.killtarget);
         if ( (t != world) ) {

            remove ( t);

         }
      } while ( (t != world) );

   }
   self.style = 0.00000;
   if ( self.target ) {

      act = activator;
      t = world;
      do {

         t = find ( t, targetname, self.target);
         if ( !t ) {

            if ( ((self.nexttarget != "") && (self.target != self.nexttarget)) ) {

               self.target = self.nexttarget;

            }
            return ;

         }
         if ( ((t.style >= 32.00000) && (t.style != self.style)) ) {

            self.style = t.style;
            if ( (self.classname == "breakable_brush") ) {

               lightstylestatic ( self.style, 0.00000);
            } else {

               lightstyle_change ( t);

            }

         }
         stemp = self;
         otemp = other;
         self = t;
         other = stemp;
         if ( (other.classname == "trigger_activate") ) {

            if ( !self.inactive ) {

               self.inactive = TRUE;
            } else {

               self.inactive = FALSE;

            }
         } else {

            if ( (other.classname == "trigger_deactivate") ) {

               self.inactive = TRUE;
            } else {

               if ( ((other.classname == "trigger_combination_assign") && (self.classname == "trigger_counter")) ) {

                  self.mangle = other.mangle;
               } else {

                  if ( ((other.classname == "trigger_counter_reset") && (self.classname == "trigger_counter")) ) {

                     self.cnt = 1.00000;
                     self.count = self.frags;
                     self.items = 0.00000;
                  } else {

                     if ( ((self.use != SUB_Null) && !self.inactive) ) {

                        if ( self.use ) {

                           self.use ( );

                        }

                     }

                  }

               }

            }

         }
         self = stemp;
         other = otemp;
         activator = act;
      } while ( 1.00000 );

   }
};


void  (float normal)SUB_AttackFinished =  {
   self.cnt = 0.00000;
   if ( (skill != 3.00000) ) {

      self.attack_finished = (time + normal);

   }
};

