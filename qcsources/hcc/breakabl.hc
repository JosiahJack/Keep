float BREAK_KILLALL   =  1.00000;
float BREAK_HIERARCH   =  2.00000;
float BREAK_NOLINK   =  4.00000;
float BREAK_CHECKNAME   =  8.00000;
float BREAK_ORDERED   =  16.00000;
float BREAK_TRANSLUCENT   =  32.00000;
float BREAK_INVINCIBLE   =  64.00000;
float BREAK_INVISIBLE   =  128.00000;
float  (entity e1,entity e2)EntitiesTouching;
float breakhealth [21]   = { 0.00000,
    75.00000,    50.00000,    100.00000,    30.00000,
    999.00000,    25.00000,    35.00000,    35.00000,
    75.00000,    35.00000,    35.00000,    75.00000,
    65.00000,    90.00000,    60.00000,    10.00000,
    25.00000,    50.00000,    25.00000,    25.00000};

void  ()linkBreakables =  {
local entity t;
local entity starte;
local vector cmins = '0.00000 0.00000 0.00000';
local vector cmaxs = '0.00000 0.00000 0.00000';
   if ( self.enemy ) {

      return ;

   }
   if ( (self.spawnflags & BREAK_NOLINK) ) {

      self.enemy = self;
      self.owner = self;
      return ;

   }
   cmins = self.mins;
   cmaxs = self.maxs;
   starte = self;
   t = self;
   do {

      self.owner = starte;
      if ( self.health ) {

         starte.health = self.health;

      }
      if ( self.targetname ) {

         starte.targetname = self.targetname;

      }
      t = find ( t, classname, self.classname);
      if ( !t ) {

         self.enemy = starte;
         self = self.owner;
         if ( self.health ) {

            return ;

         }
         if ( self.targetname ) {

            return ;

         }
         if ( self.items ) {

            return ;

         }
         return ;

      }
      if ( (EntitiesTouching ( self, t) && (((self.spawnflags & BREAK_CHECKNAME) && (self.netname == t.netname)) || !(self.spawnflags & BREAK_CHECKNAME))) ) {

         if ( t.enemy ) {

            return ;

         }
         self.enemy = t;
         self = t;
         if ( (t.mins_x < cmins_x) ) {

            cmins_x = t.mins_x;

         }
         if ( (t.mins_y < cmins_y) ) {

            cmins_y = t.mins_y;

         }
         if ( (t.mins_z < cmins_z) ) {

            cmins_z = t.mins_z;

         }
         if ( (t.maxs_x > cmaxs_x) ) {

            cmaxs_x = t.maxs_x;

         }
         if ( (t.maxs_y > cmaxs_y) ) {

            cmaxs_y = t.maxs_y;

         }
         if ( (t.maxs_z > cmaxs_z) ) {

            cmaxs_z = t.maxs_z;

         }

      }
   } while ( 1.00000 );
};


void  ()brush_use_hierarchy =  {
local entity starte;
local entity oself;
local float headNum = 0.00000;
   starte = self;
   oself = self;
   headNum = self.frags;
   do {

      if ( (self.frags >= headNum) ) {

         self.th_die ( );

      }
      self = self.enemy;
   } while ( (((self != starte) && (self != world)) && (self.frags != self.cnt)) );
};


void  ()brush_use_ordered =  {
local entity starte;
local entity oself;
   oself = self;
   starte = self;
   self.health = self.max_health;
   if ( (self.frags == self.cnt) ) {

      self.th_die ( );
   } else {

      do {

         self = self.enemy;
      } while ( (((self != oself) && (self != world)) && (self.frags != self.cnt)) );

   }
   if ( (((self.frags == self.cnt) && (self != world)) && (self != oself)) ) {

      self.th_die ( );

   }
   do {

      oself.cnt += 1.00000;
      oself = oself.enemy;
   } while ( ((oself != starte) && (oself != world)) );
};


void  ()brush_use =  {
local entity starte;
   starte = self;
   activator = other;
   if ( (starte.spawnflags & BREAK_KILLALL) ) {

      do {

         other = self.enemy;
         self.th_die ( );
         self = other;
      } while ( ((self != starte) && (self != world)) );
   } else {

      self.th_die ( );

   }
};


void  ()brush_no_link_use =  {
   SUB_UseTargets ( );
   self.th_die ( );
};


void  ()breakable_brush =  {
   self.max_health = self.health;
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin ( self, self.origin);
   setmodel ( self, self.model);
   if ( (self.spawnflags & BREAK_ORDERED) ) {

      self.th_die = brush_use_ordered;
      self.cnt = 1.00000;
   } else {

      if ( (self.spawnflags & BREAK_HIERARCH) ) {

         self.th_die = brush_use_hierarchy;
      } else {

         self.th_die = brush_use;

      }

   }
   if ( (self.spawnflags & BREAK_TRANSLUCENT) ) {

      self.drawflags |= DRF_TRANSLUCENT;

   }
   if ( !self.thingtype ) {

      self.thingtype = THINGTYPE_GLASS;

   }
   if ( !self.health ) {

      self.health = (breakhealth->self.thingtype);

   }
   self.max_health = self.health;
   if ( self.flags ) {

      self.frags = self.flags;

   }
   if ( self.abslight ) {

      self.drawflags |= MLS_ABSLIGHT;

   }
   if ( (self.spawnflags & BREAK_INVINCIBLE) ) {

      self.takedamage = DAMAGE_NO;
   } else {

      self.takedamage = DAMAGE_YES;

   }
   if ( (self.spawnflags & BREAK_INVISIBLE) ) {

      self.effects |= EF_NODRAW;
      self.th_die = SUB_Remove;
   } else {

      self.th_die = chunk_death;

   }
   if ( (self.spawnflags & BREAK_NOLINK) ) {

      self.use = self.th_die;
   } else {

      self.use = brush_use;
      self.think = linkBreakables;
      self.nextthink = (self.ltime + 0.10000);

   }
   self.ltime = time;
};

