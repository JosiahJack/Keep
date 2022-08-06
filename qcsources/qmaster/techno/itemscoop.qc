void () item_health_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = health_touch;
   if ( (self.spawnflags & H_ROTTEN) ) {

      precache_model ("maps/b_bh10.bsp");
      precache_sound ("items/r_item1.wav");
      setmodel (self,"maps/b_bh10.bsp");
      self.noise = "items/r_item1.wav";
      self.healamount = 15.000;
      self.healtype = FALSE;

   } else {

      if ( (self.spawnflags & H_MEGA) ) {

         precache_model ("maps/b_bh100.bsp");
         precache_sound ("items/r_item2.wav");
         setmodel (self,"maps/b_bh100.bsp");
         self.noise = "items/r_item2.wav";
         self.healamount = 100.000;
         self.healtype = FL_SWIM;

      } else {

         precache_model ("maps/b_bh25.bsp");
         precache_sound ("items/health1.wav");
         setmodel (self,"maps/b_bh25.bsp");
         self.noise = "items/health1.wav";
         self.healamount = 25.000;
         self.healtype = TRUE;

      }

   }
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_armor1_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = FALSE;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_armor2_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = TRUE;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_armorInv_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = FL_SWIM;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_shells_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_shell1.bsp");
      setmodel (self,"maps/b_shell1.bsp");
      self.aflag = 40.000;

   } else {

      precache_model ("maps/b_shell0.bsp");
      setmodel (self,"maps/b_shell0.bsp");
      self.aflag = 20.000;

   }
   self.weapon = TRUE;
   self.netname = "shells";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_spikes_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_nail1.bsp");
      setmodel (self,"maps/b_nail1.bsp");
      self.aflag = 50.000;

   } else {

      precache_model ("maps/b_nail0.bsp");
      setmodel (self,"maps/b_nail0.bsp");
      self.aflag = 25.000;

   }
   self.weapon = FL_SWIM;
   self.netname = "nails";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_rockets_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_rock1.bsp");
      setmodel (self,"maps/b_rock1.bsp");
      self.aflag = MOVETYPE_BOUNCE;

   } else {

      precache_model ("maps/b_rock0.bsp");
      setmodel (self,"maps/b_rock0.bsp");
      self.aflag = MOVETYPE_FLY;

   }
   self.weapon = MOVETYPE_WALK;
   self.netname = "rockets";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_cells_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_batt1.bsp");
      setmodel (self,"maps/b_batt1.bsp");
      self.aflag = 12.000;

   } else {

      precache_model ("maps/b_batt0.bsp");
      setmodel (self,"maps/b_batt0.bsp");
      self.aflag = MOVETYPE_TOSS;

   }
   self.weapon = MOVETYPE_STEP;
   self.netname = "cells";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_artifact_invulnerability_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = powerup_touch;
   precache_model ("progs/invulner.mdl");
   precache_sound ("items/protect.wav");
   precache_sound ("items/protect2.wav");
   precache_sound ("items/protect3.wav");
   self.noise = "items/protect.wav";
   setmodel (self,"progs/invulner.mdl");
   self.netname = "Pentagram of Protection";
   self.items = IT_INVULNERABILITY;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_artifact_envirosuit_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = powerup_touch;
   precache_model ("progs/suit.mdl");
   precache_sound ("items/suit.wav");
   precache_sound ("items/suit2.wav");
   self.noise = "items/suit.wav";
   setmodel (self,"progs/suit.mdl");
   self.netname = "Biosuit";
   self.items = IT_SUIT;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_artifact_invisibility_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = powerup_touch;
   precache_model ("progs/invisibl.mdl");
   precache_sound ("items/inv1.wav");
   precache_sound ("items/inv2.wav");
   precache_sound ("items/inv3.wav");
   self.noise = "items/inv1.wav";
   setmodel (self,"progs/invisibl.mdl");
   self.netname = "Ring of Shadows";
   self.items = IT_INVISIBILITY;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_artifact_super_damage_coop = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if (!coop) {

      remove (self);
      return ;

   }
   self.touch = powerup_touch;
   precache_model ("progs/quaddama.mdl");
   precache_sound ("items/damage.wav");
   precache_sound ("items/damage2.wav");
   precache_sound ("items/damage3.wav");
   self.noise = "items/damage.wav";
   setmodel (self,"progs/quaddama.mdl");
   self.netname = "Quad Damage";
   self.items = IT_QUAD;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};