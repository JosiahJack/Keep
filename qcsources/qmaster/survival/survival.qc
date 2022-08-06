
void () sign_think = {

   remove (self);

};

void (entity e, float points) survival_spawn_sign = {

   local entity sprite1;

   sprite1 = spawn();
   setorigin (sprite1,(e.origin + '0.000 0.000 32.000'));
   sprite1.solid = SOLID_NOT;
   sprite1.movetype = MOVETYPE_NONE;
   sprite1.model = "";
   if ( (points == 25.000) ) {

      sprite1.model = "progs/25pts.spr";

   }
   if ( (points == 50.000) ) {

      sprite1.model = "progs/50pts.spr";

   }
   if ( (points == 100.000) ) {

      sprite1.model = "progs/100pts.spr";

   }
   if ( (points == 125.000) ) {

      sprite1.model = "progs/125pts.spr";

   }
   if ( (points == 150.000) ) {

      sprite1.model = "progs/150pts.spr";

   }
   if ( (points == 200.000) ) {

      sprite1.model = "progs/200pts.spr";

   }
   if ( (points == 250.000) ) {

      sprite1.model = "progs/250pts.spr";

   }
   if ( (points == 300.000) ) {

      sprite1.model = "progs/300pts.spr";

   }
   if ( (points == 350.000) ) {

      sprite1.model = "progs/350pts.spr";

   }
   if ( (points == 400.000) ) {

      sprite1.model = "progs/400pts.spr";

   }
   if ( (points == 500.000) ) {

      sprite1.model = "progs/500pts.spr";

   }
   if ( (points == 600.000) ) {

      sprite1.model = "progs/600pts.spr";

   }
   if ( (points == 700.000) ) {

      sprite1.model = "progs/700pts.spr";

   }
   setmodel (sprite1,sprite1.model);
   sprite1.think = sign_think;
   sprite1.nextthink = (time + 4.000);

};

void () survival_bodykill = {

   if ( (self.classname != "player") ) {

      remove (self);

   }

};

void () survival_wave10 = {

   activator = other;
   SUB_UseTargets ();
   self.think = SUB_Null;
   self.nextthink = (time + 0.100);

};

void () survival_wave9 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target10) ) {

      self.target = self.target10;
      self.think = survival_wave10;
      self.nextthink = (time + 150.000);

   }

};

void () survival_wave8 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target9) ) {

      self.target = self.target9;
      self.think = survival_wave9;
      self.nextthink = (time + 120.000);

   }

};

void () survival_wave7 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target8) ) {

      self.target = self.target8;
      self.think = survival_wave8;
      self.nextthink = (time + 120.000);

   }

};

void () survival_wave6 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target7) ) {

      self.target = self.target7;
      self.think = survival_wave7;
      self.nextthink = (time + 120.000);

   }

};

void () survival_wave5 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target6) ) {

      self.target = self.target6;
      self.think = survival_wave6;
      self.nextthink = (time + 60.000);

   }

};

void () survival_wave4 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target5) ) {

      self.target = self.target5;
      self.think = survival_wave5;
      self.nextthink = (time + 60.000);

   }

};

void () survival_wave3 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target4) ) {

      self.target = self.target4;
      self.think = survival_wave4;
      self.nextthink = (time + 45.000);

   }

};

void () survival_wave2 = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target3) ) {

      self.target = self.target3;
      self.think = survival_wave3;
      self.nextthink = (time + 30.000);

   }

};

void () survival_wave = {

   activator = other;
   SUB_UseTargets ();
   if ( (self.target2) ) {

      self.target = self.target2;
      self.think = survival_wave2;
      self.nextthink = (time + 30.000);

   }

};

void () control_use = {

   self.think = survival_wave;
   self.nextthink = (time + 15.000);

};

void () func_survival_control = {

   if (!(self.target) ) {

      objerror ("ERROR! No target for wave controller!\n");

   }
   self.solid = SOLID_NOT;
   self.model = "";
   setmodel (self,self.model);
   self.movetype = MOVETYPE_NONE;
   if (!(self.targetname) ) {

      self.think = survival_wave;
      self.nextthink = (time + 15.000);

   } else {

      self.think = SUB_Null;
      self.nextthink = (time + 0.100);
      self.use = control_use;

   }

};