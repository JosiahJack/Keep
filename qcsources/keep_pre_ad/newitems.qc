void () sphere_spawn;

void (entity theEntity) UpdateAmmoCounts = {

   if ( (self.weapon >= IT_LAVA_NAILGUN) ) {

      theEntity.ammo_shells = theEntity.ammo_shells1;
      theEntity.ammo_nails = theEntity.ammo_lava_nails;
      theEntity.ammo_rockets = theEntity.ammo_multi_rockets;
      theEntity.ammo_cells = theEntity.ammo_plasma;

   } else {

      theEntity.ammo_shells = theEntity.ammo_shells1;
      theEntity.ammo_nails = theEntity.ammo_nails1;
      theEntity.ammo_rockets = theEntity.ammo_rockets1;
      theEntity.ammo_cells = theEntity.ammo_cells1;

   }

};

void () newitems_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (self.classname == "item_sphere") ) {

      if ( (other.items2 & IT2_V_SPHERE) ) {

         return ;

      }

   }
   sprint (other,"You got the ");
   sprint (other,self.netname);
   sprint (other,"\n");
   if ( deathmatch ) {

      if ( (self.classname == "item_random_powerup") ) {

         self.nextthink = (time + 60.000);
         self.think = random_regen;

      } else {

         if ( (self.classname == "item_sphere") ) {

            self.mdl = self.model;
            self.nextthink = (time + (60.000 * MOVETYPE_WALK));
            self.think = SUB_regen;

         } else {

            self.mdl = self.model;
            self.nextthink = (time + 60.000);
            self.think = SUB_regen;

         }

      }

   }
   sound (other,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.solid = SOLID_NOT;
   other.items = (other.items | self.items);
   other.items2 = (other.items2 | self.items2);
   self.model = string_null;
   if ( (self.netname == "Power Shield") ) {

      other.shield_time = TRUE;
      other.shield_finished = (time + SVC_INTERMISSION);

   } else {

      if ( (self.netname == "Anti-Grav Belt") ) {

         other.antigrav_time = TRUE;
         other.antigrav_finished = (time + 45.000);
         other.gravity = 0.250;

      } else {

         if ( (self.classname == "item_sphere") ) {

            other.items2 = (other.items2 | IT2_V_SPHERE);
            sphere_spawn ();

         }

      }

   }
   activator = other;
   SUB_UseTargets ();

};

void () item_powerup_shield = {

   self.touch = newitems_touch;
   precache_model ("progs/shield.mdl");
   precache_model ("progs/p_shield.mdl");
   precache_sound ("shield/pickup.wav");
   precache_sound ("shield/hit.wav");
   precache_sound ("shield/fadeout.wav");
   self.noise = "shield/pickup.wav";
   setmodel (self,"progs/shield.mdl");
   self.netname = "Power Shield";
   self.items2 = IT2_SHIELD;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_powerup_belt = {

   self.touch = newitems_touch;
   precache_model ("progs/beltup.mdl");
   precache_sound ("belt/pickup.wav");
   precache_sound ("belt/use.wav");
   precache_sound ("belt/fadeout.wav");
   self.noise = "belt/pickup.wav";
   setmodel (self,"progs/beltup.mdl");
   self.netname = "Anti-Grav Belt";
   self.items2 = IT2_ANTIGRAV;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};
