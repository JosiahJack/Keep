
void () random_pick_type = {

   local float randItem;

   randItem = random ();
   self.touch = powerup_touch;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   if ( (randItem < 0.200) ) {

      self.touch = newitems_touch;
      self.noise = "shield/pickup.wav";
      setmodel (self,"progs/shield.mdl");
      self.netname = "Power Shield";
      self.items = FALSE;
      self.items2 = IT2_SHIELD;

   } else {

      if ( (randItem < 0.400) ) {

         self.touch = newitems_touch;
         self.noise = "belt/pickup.wav";
         setmodel (self,"progs/beltup.mdl");
         self.netname = "Anti-Grav Belt";
         self.items = FALSE;
         self.items2 = IT2_ANTIGRAV;

      } else {

         if ( (randItem < 0.600) ) {

            self.noise = "items/protect.wav";
            setmodel (self,"progs/invulner.mdl");
            self.netname = "Pentagram of Protection";
            self.items = IT_INVULNERABILITY;
            self.items2 = FALSE;

         } else {

            if ( (randItem < 0.800) ) {

               self.noise = "items/inv1.wav";
               setmodel (self,"progs/invisibl.mdl");
               self.netname = "Ring of Shadows";
               self.items = IT_INVISIBILITY;
               self.items2 = FALSE;

            } else {

               self.noise = "items/damage.wav";
               setmodel (self,"progs/quaddama.mdl");
               self.netname = "Quad Damage";
               self.items = IT_QUAD;
               self.items2 = FALSE;

            }

         }

      }

   }

};

void () item_random_powerup = {

   if ( !deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/shield.mdl");
   precache_model ("progs/p_shield.mdl");
   precache_model ("progs/beltup.mdl");
   precache_model ("progs/invulner.mdl");
   precache_model ("progs/invisibl.mdl");
   precache_model ("progs/quaddama.mdl");
   precache_sound ("items/inv1.wav");
   precache_sound ("items/inv2.wav");
   precache_sound ("items/inv3.wav");
   precache_sound ("items/protect.wav");
   precache_sound ("items/protect2.wav");
   precache_sound ("items/protect3.wav");
   precache_sound ("items/damage.wav");
   precache_sound ("items/damage2.wav");
   precache_sound ("items/damage3.wav");
   precache_sound ("belt/pickup.wav");
   precache_sound ("belt/use.wav");
   precache_sound ("belt/fadeout.wav");
   precache_sound ("shield/pickup.wav");
   precache_sound ("shield/hit.wav");
   precache_sound ("shield/fadeout.wav");
   random_pick_type ();
   StartItem ();

};

void () random_regen = {

   random_pick_type ();
   SUB_regen ();

};
