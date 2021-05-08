
void () monster_use = {

   if ( self.enemy ) {

      return ;

   }
   if ( (self.health <= FALSE) ) {

      return ;

   }
   if ( (activator.items & IT_INVISIBILITY) ) {

      return ;

   }
   if ( (activator.flags & FL_NOTARGET) ) {

      return ;

   }
   if ( (activator.classname != "player") ) {

      return ;

   }
   self.enemy = activator;
   self.nextthink = (time + 0.100);
   self.think = FoundTarget;

};

void () monster_death_use = {

   local entity ent;
   local entity otemp;
   local entity stemp;

   if ( (self.flags & FL_FLY) ) {

      self.flags = (self.flags - FL_FLY);

   }
   if ( (self.flags & FL_SWIM) ) {

      self.flags = (self.flags - FL_SWIM);

   }
   if ( !self.target ) {

      return ;

   }
   activator = self.enemy;
   SUB_UseTargets ();

};

void () walkmonster_start_go = {

   local string stemp;
   local entity etemp;

   self.origin_z = (self.origin_z + TRUE);
   droptofloor ();
   if ( !walkmove (FALSE,FALSE) ) {

      dprint ("walkmonster in wall at: ");
      dprint (vtos (self.origin));
      dprint ("\n");

   }
   self.takedamage = DAMAGE_AIM;
   self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
   if ( !self.yaw_speed ) {

      self.yaw_speed = 20.000;

   }
   self.view_ofs = '0.000 0.000 25.000';
   self.use = monster_use;
   self.flags = (self.flags | FL_MONSTER);
   if ( self.target ) {

      self.movetarget = find (world,targetname,self.target);
      self.goalentity = find (world,targetname,self.target);
      self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
      if ( !self.movetarget ) {

         dprint ("Monster can't find target at ");
         dprint (vtos (self.origin));
         dprint ("\n");

      }
      if ( (self.movetarget.classname == "path_corner") ) {

         self.th_walk ();

      } else {

         self.pausetime = 100000000.000;

      }
      self.th_stand ();

   } else {

      self.pausetime = 100000000.000;
      self.th_stand ();

   }
   self.nextthink = (self.nextthink + (random () * 0.500));

};

void () walkmonster_start = {

   self.nextthink = (self.nextthink + (random () * 0.500));
   self.flags = (self.flags | FL_MONSTER);
   self.think = walkmonster_start_go;
   total_monsters = (total_monsters + TRUE);

};

void () flymonster_start_go = {

   self.takedamage = DAMAGE_AIM;
   self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
   if ( !self.yaw_speed ) {

      self.yaw_speed = MOVETYPE_BOUNCE;

   }
   self.view_ofs = '0.000 0.000 25.000';
   self.use = monster_use;
   self.flags = (self.flags | FL_FLY);
   self.flags = (self.flags | FL_MONSTER);
   if ( !walkmove (FALSE,FALSE) ) {

      dprint ("flymonster in wall at: ");
      dprint (vtos (self.origin));
      dprint ("\n");

   }
   if ( self.target ) {

      self.movetarget = find (world,targetname,self.target);
      self.goalentity = find (world,targetname,self.target);
      if ( !self.movetarget ) {

         dprint ("Monster can't find target at ");
         dprint (vtos (self.origin));
         dprint ("\n");

      }
      if ( (self.movetarget.classname == "path_corner") ) {

         self.th_walk ();

      } else {

         self.pausetime = 100000000.000;

      }
      self.th_stand ();

   } else {

      self.pausetime = 100000000.000;
      self.th_stand ();

   }

};

void () flymonster_start = {

   self.nextthink = (self.nextthink + (random () * 0.500));
   self.flags = (self.flags | FL_MONSTER);
   self.think = flymonster_start_go;
   total_monsters = (total_monsters + TRUE);

};

void () swimmonster_start_go = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   self.takedamage = DAMAGE_AIM;
   self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
   if ( !self.yaw_speed ) {

      self.yaw_speed = MOVETYPE_BOUNCE;

   }
   self.view_ofs = '0.000 0.000 10.000';
   self.use = monster_use;
   self.flags = (self.flags | FL_SWIM);
   self.flags = (self.flags | FL_MONSTER);
   if ( self.target ) {

      self.movetarget = find (world,targetname,self.target);
      self.goalentity = find (world,targetname,self.target);
      if ( !self.movetarget ) {

         dprint ("Monster can't find target at ");
         dprint (vtos (self.origin));
         dprint ("\n");

      }
      self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
      self.th_walk ();

   } else {

      self.pausetime = 100000000.000;
      self.th_stand ();

   }
   self.nextthink = (self.nextthink + (random () * 0.500));

};

void () swimmonster_start = {

   self.flags = (self.flags | FL_MONSTER);
   self.nextthink = (self.nextthink + (random () * 0.500));
   self.think = swimmonster_start_go;
   total_monsters = (total_monsters + TRUE);

};
