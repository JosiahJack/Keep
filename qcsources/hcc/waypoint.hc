
void  ()RemoveWaypoint =  {
   if ( self.lockentity ) {

      self.lockentity.goalentity = self.controller.enemy;
      if ( (self.lockentity.classname == "monster_hydra") ) {

         self.lockentity.search_time = (time + 5.00000);

      }

   }
   remove ( self);
};


void  ()ResetWaypoints =  {
   self.controller.goalentity = self.controller.enemy;
   if ( (self.controller.classname == "monster_hydra") ) {

      self.controller.search_time = (time + 5.00000);

   }
   remove ( self);
};


void  ()TransferWaypoint =  {
   if ( (self.goalentity.classname == "waypoint") ) {

      self.controller.goalentity = self.goalentity;
   } else {

      if ( (self.controller.classname == "monster_hydra") ) {

         self.controller.search_time = (time + 5.00000);

      }
      self.controller.goalentity = self.enemy;

   }
   remove ( self);
};


void  ()WaypointTouch =  {
   if ( (other != self.controller) ) {

      return ;

   }
   if ( (self.controller.mintel >= self.point_seq) ) {

      TransferWaypoint ( );
   } else {

      ResetWaypoints ( );

   }
};


void  ()SetNextWaypoint =  {
local entity waypoint;
   if ( (visible ( self.enemy) && (self.classname == "waypoint")) ) {

      self.wallspot = ((self.enemy.absmin + self.enemy.absmax) * 0.50000);
   } else {

      if ( ((self.lastwaypointspot != self.wallspot) && (((self.classname != "waypoint") && (self.mintel > 0.00000)) || ((self.classname == "waypoint") && (self.point_seq < self.controller.mintel)))) ) {

         self.lastwaypointspot = self.wallspot;
         waypoint = spawn ( );
         waypoint.lockentity = self;
         waypoint.classname = "waypoint";
         waypoint.point_seq = (self.point_seq + 1.00000);
         waypoint.movetype = MOVETYPE_NONE;
         waypoint.touch = TransferWaypoint;
         waypoint.view_ofs = self.view_ofs;
         setmodel ( waypoint, "models/null.spr");
         waypoint.effects = EF_NODRAW;
         setsize ( waypoint, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
         setorigin ( waypoint, self.wallspot);
         if ( ((self.search_time > time) && ((self.model == "models/imp.mdl") || (self.model == "models/hydra.mdl"))) ) {

            self.trigger_field = waypoint;
         } else {

            self.goalentity = waypoint;

         }
         if ( (self.classname == "waypoint") ) {

            waypoint.controller = self.controller;
            waypoint.speed = self.speed;
            self.enemy = self.controller.enemy;
         } else {

            waypoint.controller = self;
            if ( (self.movetype == MOVETYPE_FLY) ) {

               waypoint.speed = 6.00000;
            } else {

               waypoint.speed = self.size_x;

            }

         }
         waypoint.enemy = self.enemy;
         waypoint.wallspot = ((waypoint.enemy.absmin + waypoint.enemy.absmax) * 0.50000);
         waypoint.think = SetNextWaypoint;
         AdvanceThinkTime(waypoint,0.00000);
         waypoint.lifetime = (time + 30.00000);

      }

   }
   if ( (self.classname == "waypoint") ) {

      if ( (((self.controller.enemy != self.enemy) || !(self.enemy.flags2 & FL_ALIVE)) || !(self.controller.flags2 & FL_ALIVE)) ) {

         ResetWaypoints ( );

      }
      if ( visible2ent ( self.controller.enemy, self.controller) ) {

         ResetWaypoints ( );

      }
      if ( ((self.lockentity.goalentity != self) && (self.lockentity.trigger_field != self)) ) {

         remove ( self);
      } else {

         if ( visible2ent ( self.goalentity, self.controller) ) {

            if ( (self.controller.mintel >= self.point_seq) ) {

               TransferWaypoint ( );
            } else {

               ResetWaypoints ( );

            }
         } else {

            if ( (((random() < 0.20000) && (vhlen ( (self.origin - self.controller.origin)) < self.speed)) && visible2ent ( self, self.controller)) ) {

               TransferWaypoint ( );

            }

         }

      }
      self.think = SetNextWaypoint;
      if ( (self.lifetime < time) ) {

         self.think = RemoveWaypoint;
         AdvanceThinkTime(self,30.00000);
      } else {

         AdvanceThinkTime(self,0.20000);

      }

   }
};

