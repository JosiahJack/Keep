
void  ()monster_use =  {
   if ( self.enemy ) {

      return ;

   }
   if ( (self.health <= 0.00000) ) {

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
   if ( (((self.classname == "monster_mezzoman") && !visible ( activator)) && !self.monster_awake) ) {

      self.enemy = activator;
      mezzo_choose_roll ( activator);
      return ;
   } else {

      self.enemy = activator;
      AdvanceThinkTime(self,0.10000);
      self.think = FoundTarget;

   }
};


void  ()monster_death_use =  {
   self.flags ^= FL_FLY;
   self.flags ^= FL_SWIM;
   if ( !self.target ) {

      return ;

   }
   activator = self.enemy;
   SUB_UseTargets ( );
};


void  ()walkmonster_start_go =  {
   if ( !self.touch ) {

      self.touch = obj_push;

   }
   if ( !(self.spawnflags & NO_DROP) ) {

      self.origin_z = (self.origin_z + 1.00000);
      droptofloor ( );
      if ( !walkmove ( 0.00000, 0.00000, FALSE) ) {

         if ( (self.flags2 & FL_SUMMONED) ) {

            remove ( self);
         } else {

            dprint ( "walkmonster in wall at: ");
            dprint ( vtos ( self.origin));
            dprint ( "\n");

         }

      }
      if ( ((self.model == "model/spider.mdl") || (self.model == "model/scorpion.mdl")) ) {

         pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

      }

   }
   if ( !self.ideal_yaw ) {

      self.ideal_yaw = (self.angles * '0.00000 1.00000 0.00000');

   }
   if ( !self.yaw_speed ) {

      self.yaw_speed = 20.00000;

   }
   if ( (self.view_ofs == '0.00000 0.00000 0.00000') ) {

      self.view_ofs = '0.00000 0.00000 25.00000';

   }
   if ( (self.proj_ofs == '0.00000 0.00000 0.00000') ) {

      self.proj_ofs = '0.00000 0.00000 25.00000';

   }
   if ( !self.use ) {

      self.use = monster_use;

   }
   if ( !(self.flags & FL_MONSTER) ) {

      self.flags |= FL_MONSTER;

   }
   if ( ((self.flags & FL_MONSTER) && (self.classname == "player_sheep")) ) {

      self.flags ^= FL_MONSTER;

   }
   if ( self.target ) {

      self.pathentity = find ( world, targetname, self.target);
      self.goalentity = find ( world, targetname, self.target);
      self.ideal_yaw = vectoyaw ( (self.goalentity.origin - self.origin));
      if ( !self.pathentity ) {

         dprint ( "Monster can't find target at ");
         dprint ( vtos ( self.origin));
         dprint ( "\n");

      }
      if ( (self.pathentity.classname == "path_corner") ) {

         self.th_walk ( );
      } else {

         self.pausetime = 100000000.00000;
         self.th_stand ( );

      }
   } else {

      self.pausetime = 100000000.00000;
      self.th_stand ( );

   }
   self.nextthink += random(0.50000);
};


void  ()walkmonster_start =  {
   self.takedamage = DAMAGE_YES;
   self.flags2 |= FL_ALIVE;
   if ( (self.scale <= 0.00000) ) {

      self.scale = 1.00000;

   }
   self.nextthink += random(0.50000);
   self.think = walkmonster_start_go;
   total_monsters = (total_monsters + 1.00000);
};

