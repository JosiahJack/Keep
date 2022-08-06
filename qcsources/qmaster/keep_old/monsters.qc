void() monster_use = 
{
	if (self.enemy)
	{
		return;
	}
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (activator.items & IT_INVISIBILITY)
	{
		return;
	}
	if (activator.flags & FL_NOTARGET)
	{
		return;
	}
	if (activator.classname != "player")
	{
		return;
	}
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

// monster_death_use taken from Kinn's The Marcher Fortress
void() monster_death_use =
{
	
   self.flags = self.flags | FL_NOSELECT;	//ent select ignore

   if (self.monsterflags & MF_SMOOTH_FLIGHT) {

      self.movetype = MOVETYPE_STEP;	//change it back so monster can fall

   }
   if (self.flags & FL_FLY) {

      self.flags = self.flags - FL_FLY;

   }
   if (self.flags & FL_SWIM) {

      self.flags = self.flags - FL_SWIM;

   }

   //activator = self.enemy;
   //bdw - new way of setting activator - if a player is involved anywhere, it's his fault...
   //this helps with centerprints that are triggered by monster deaths...

   if (self.enemy.classname == "player") {			//killed directly by player

      activator = self.enemy;

   } else {

      if (self.oldenemy.classname == "player") {		//death by monster infighting

         activator = self.oldenemy;			

      } else {

         if (self.enemy.enemy.classname == "player") {	//death by friendly fire

            activator = self.enemy.enemy;

         } else {

            if (self.enemy.oldenemy.classname == "player") {	//unaware of player, but killed by infighting

               activator = self.enemy.oldenemy;

            } else {

               activator = self.enemy;

            }

         }

      }

   }
   SUB_UseTargets ();

};

void () walkmonster_start_go = {

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

         if ( (self.movetarget.classname == "path_corner_run") ) {

            self.th_run ();

         } else {

            self.pausetime = 100000000.000;

         }

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

         if ( (self.movetarget.classname == "path_corner_run") ) {

            self.th_run ();

         } else {

            self.pausetime = 100000000.000;

         }

      }
      self.th_stand ();

   } else {

      self.pausetime = 100000000.000;
      self.th_stand ();

   }

};

void () flymonster_start = {

   self.nextthink = (self.nextthink + (random () * 0.500));
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

   self.nextthink = (self.nextthink + (random () * 0.500));
   self.think = swimmonster_start_go;
   total_monsters = (total_monsters + TRUE);

};
