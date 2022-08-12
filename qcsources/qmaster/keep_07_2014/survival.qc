float (string n) PointsLookup = {

   if ( (n == "player") ) {return 400;}
   if ( (n == "monster_oldone") ) 	{return 1000;}
   if ( (n == "monster_boss") ) 	{return 800;}
   if ( (n == "monster_fish") ) 	{return 25;}
   if ( (n == "monster_army") ) 	{return 25;}
   if ( (n == "monster_zombie") ) 	{return 125;}
   if ( (n == "monster_dog") ) 		{return 25;}
   if ( (n == "monster_voreling") ) 	{return 25;}
   if ( (n == "monster_spider") ) 	{return 25;}
   if ( (n == "monster_wizard") ) 	{return 50;}
   if ( (n == "monster_tarbaby") ) 	{return 150;}
   if ( (n == "monster_slimespawn") ) 	{return 200;}
   if ( (n == "monster_enforcer") ) 	{return 50;}
   if ( (n == "monster_knight") ) 	{return 50;}
   if ( (n == "monster_eel") ) 		{return 25;}
   if ( (n == "imp") ) 			{return 50;}
   if ( (n == "monster_gaunt") ) 	{return 150;}
   if ( (n == "monster_gremlin") )	{return 150;}
   if ( (n == "stoneimp") ) 		{return 100;}
   if ( (n == "monster_wrath") ) 	{return 150;}
   if ( (n == "monster_sword") ) 	{return 150;}
   if ( (n == "monster_lava_man") ) 	{return 300;}
   if ( (n == "monster_shalrath") ) 	{return 350;}
   if ( (n == "monster_ogre") ) 	{return 200;}
   if ( (n == "monster_hell_knight") ) 	{return 250;}
   if ( (n == "monster_scourge") ) 	{return 200;}
   if ( (n == "monster_demon1") ) 	{return 300;}
   if ( (n == "monster_mummy") ) 	{return 400;}
   if ( (n == "monster_super_wrath") ) 	{return 500;}
   if ( (n == "monster_morph") ) 	{return 500;}
   if ( (n == "monster_shambler") ) 	{return 400;}
   if ( (n == "monster_spikemine") ) 	{return 100;}
   if ( (n == "monster_drole") ) 	{return 500;}
   if ( (n == "monster_shuffler_black")){return 550;}
   if ( (n == "monster_shuffler_white")){return 600;}
   if ( (n == "monster_gug") ) 		{return 700;}
   if ( (n == "monster_armagon") ) 	{return 800;}
   if ( (n == "monster_dragon") ) 	{return 1000;}
   return 0;

};

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
   survival = TRUE;
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