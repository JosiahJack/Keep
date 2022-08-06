float modelindex_player /* = 0.000 */;
void () W_SetCurrentAmmo;

void () SUB_regen = {

   self.model = self.mdl;
   self.solid = SOLID_TRIGGER;
   sound (self,CHAN_VOICE,"items/itembk2.wav",TRUE,ATTN_NORM);
   setorigin (self,self.origin);

};

void () noclass = {

   dprint ("noclass spawned at");
   dprint (vtos (self.origin));
   dprint ("\n");
   remove (self);

};

void () PlaceItem = {

   local float oldz;

   self.mdl = self.model;
   self.flags = FL_ITEM;
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_TOSS;
   self.velocity = VEC_ORIGIN;
   self.origin_z = (self.origin_z + MOVETYPE_TOSS);
   oldz = self.origin_z;
   if ( !droptofloor () ) {

      dprint ("Bonus item fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);
      return ;

   }

};

void () StartItem = {

   self.nextthink = (time + 0.200);
   self.think = PlaceItem;

};
float (entity e, float healamount, float ignore) T_Heal = {

   if ( (e.health <= FALSE) ) {

      return ( FALSE );

   }
   if ( (!ignore && (e.health >= other.max_health)) ) {

      return ( FALSE );

   }
   healamount = ceil (healamount);
   e.health = (e.health + healamount);
   if ( (!ignore && (e.health >= other.max_health)) ) {

      e.health = other.max_health;

   }
   if ( (e.health > 250.000) ) {

      e.health = 250.000;

   }
   return ( TRUE );

};
float H_ROTTEN    = 1.000;
float H_MEGA    = 2.000;
.float healamount;
.float healtype;

void () health_touch;

void () item_megahealth_rot;

void () item_health = {

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

void () health_touch = {

   local string s;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (self.healtype == FL_SWIM) ) {

      if ( (other.health >= 250.000) ) {

         return ;

      }
      if ( !T_Heal (other,self.healamount,TRUE) ) {

         return ;

      }

   } else {

      if ( !T_Heal (other,self.healamount,FALSE) ) {

         return ;

      }

   }
   if (!(condebug) ) {

      sprint (other,"You receive ");
      s = ftos (self.healamount);
      sprint (other,s);
      sprint (other," health\n");

   }
   sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (self.healtype == FL_SWIM) ) {

      other.items2 = (other.items2 | IT2_SUPERHEALTH);
      self.nextthink = (time + MOVETYPE_FLY);
      self.think = item_megahealth_rot;
      self.owner = other;

   } else {

      if ( (deathmatch != FL_SWIM) ) {

         if ( deathmatch ) {

            self.nextthink = (time + 20.000);

         }
         self.think = SUB_regen;

      }

   }
   activator = other;
   SUB_UseTargets ();

};

void () item_megahealth_rot = {

   other = self.owner;
   if ( (other.health > other.max_health) ) {

      other.health = (other.health - TRUE);
      self.nextthink = (time + TRUE);
      return ;

   }
   other.items2 = (other.items2 - (other.items2 & IT2_SUPERHEALTH));
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + 20.000);
      self.think = SUB_regen;

   }

};

void () armor_touch = {

   local float type;
   local float value;
   local float bit;

   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (self.classname == "item_armor1") ) {

      type = 0.300;
      value = 100.000;
      bit = IT2_ARMOR1;

   }
   if ( (self.classname == "item_armor2") ) {

      type = 0.600;
      value = 150.000;
      bit = IT2_ARMOR2;

   }
   if ( (self.classname == "item_armorInv") ) {

      type = 0.800;
      value = 200.000;
      bit = IT2_ARMOR3;

   }
   if ( ((other.armortype * other.armorvalue) >= (type * value)) ) {

      return ;

   }
   other.armortype = type;
   other.armorvalue = value;
   other.items2 = ((other.items2 - (other.items2 & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3))) + bit);
   self.solid = SOLID_NOT;
   self.model = string_null;
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + 20.000);

   }
   self.think = SUB_regen;
   if (!(condebug) ) {

      sprint (other,"You got armor\n");

   }
   sound (other,CHAN_ITEM,"items/armor1.wav",TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   activator = other;
   SUB_UseTargets ();

};

void () item_armor1 = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = FALSE;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_armor2 = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = TRUE;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_armorInv = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = FL_SWIM;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () bound_other_ammo = {

   if ( (other.ammo_shells1 > 100.000) ) {

      other.ammo_shells1 = 100.000;

   }
   if ( (other.ammo_nails1 > 200.000) ) {

      other.ammo_nails1 = 200.000;

   }
   if ( (other.ammo_rockets1 > 100.000) ) {

      other.ammo_rockets1 = 100.000;

   }
   if ( (other.ammo_cells1 > 100.000) ) {

      other.ammo_cells1 = 100.000;

   }
   if ( (other.ammo_lava_nails > 200.000) ) {

      other.ammo_lava_nails = 200.000;

   }
   if ( (other.ammo_multi_rockets > 100.000) ) {

      other.ammo_multi_rockets = 100.000;

   }
   if ( (other.ammo_plasma > 100.000) ) {

      other.ammo_plasma = 100.000;

   }

};

float (float w) RankForWeapon = {

   if ( (w == IT_PLASMA_GUN) ) {

      return ( 1 );

   }
   if ( (w == IT_LIGHTNING) ) {

      return ( 2 );

   }
   if ( (w == IT_MULTI_ROCKET) ) {

      return ( 3 );

   }
   if ( (w == IT_ROCKET_LAUNCHER) ) {

      return ( 4 );

   }
   if ( (w == IT_LAVA_SUPER_NAILGUN) ) {

      return ( 5 );

   }
   if ( (w == IT_SUPER_NAILGUN) ) {

      return ( 6 );

   }
   if ( (w == IT_MULTI_GRENADE) ) {

      return ( 7 );

   }
   if ( (w == IT_GRENADE_LAUNCHER) ) {

      return ( 8 );

   }
   if ( (w == IT_LAVA_NAILGUN) ) {

      return ( 9 );

   }
   if ( (w == IT_SUPER_SHOTGUN) ) {

      return ( 10 );

   }
   if ( (w == IT_NAILGUN) ) {

      return ( 11 );

   }
   return ( 12 );

};

void (float old, float new) Deathmatch_Weapon = {

   local float or;
   local float nr;

   if ( ((self.weapon == IT_GRAPPLE) && self.button0) ) {

      return ;

   }
   or = RankForWeapon (self.weapon);
   nr = RankForWeapon (new);
   if ( (nr < or) ) {

      self.weapon = new;

   }

};

void (entity comboOwner) EnableComboWeapons = {

   if ( (comboOwner.classname != "player") ) {

      return ;

   }
   if ( !(comboOwner.items & IT_LAVA_NAILGUN) ) {

      if ( ((comboOwner.ammo_lava_nails > FALSE) && (comboOwner.items & IT_NAILGUN)) ) {

         if (!(condebug) ) {

            sprint (comboOwner,"Lava Enabled\n");

         }
         comboOwner.items = (comboOwner.items | IT_LAVA_NAILGUN);

      }

   }
   if ( !(comboOwner.items & IT_LAVA_SUPER_NAILGUN) ) {

      if ( ((comboOwner.ammo_lava_nails > FALSE) && (comboOwner.items & IT_SUPER_NAILGUN)) ) {

         if (!(condebug) ) {

            sprint (comboOwner,"Super Lava Enabled!\n");

         }
         comboOwner.items = (comboOwner.items | IT_LAVA_SUPER_NAILGUN);

      }

   }
   if ( !(comboOwner.items & IT_MULTI_GRENADE) ) {

      if ( ((comboOwner.ammo_multi_rockets > FALSE) && ((comboOwner.items & IT_GRENADE_LAUNCHER) || (comboOwner.items2 & IT2_PROXIMITY_GUN))) ) {

         if (!(condebug) ) {

            sprint (comboOwner,"Multi Grenades Enabled\n");

         }
         comboOwner.items = (comboOwner.items | IT_MULTI_GRENADE);

      }

   }
   if ( !(comboOwner.items & IT_MULTI_ROCKET) ) {

      if ( ((comboOwner.ammo_multi_rockets > FALSE) && (comboOwner.items & IT_ROCKET_LAUNCHER)) ) {

         if (!(condebug) ) {

            sprint (comboOwner,"Multi Rockets Enabled\n");

         }
         comboOwner.items = (comboOwner.items | IT_MULTI_ROCKET);

      }

   }
   if ( !(comboOwner.items & IT_PLASMA_GUN) ) {

      if ( ((comboOwner.ammo_plasma > FALSE) && (comboOwner.items & IT_LIGHTNING)) ) {

         if (!(condebug) ) {

            sprint (comboOwner,"Plasma Gun Enabled\n");

         }
         comboOwner.items = (comboOwner.items | IT_PLASMA_GUN);

      }

   }

};

void () weapon_touch = {

   local float best;
   local float new;
   local float old;
   local entity stemp;
   local float leave;

   if ( !(other.flags & FL_CLIENT) ) {

      return ;

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   if ( ((deathmatch == FL_SWIM) || coop) ) {

      leave = TRUE;

   } else {

      leave = FALSE;

   }
   if ( (self.classname == "weapon_nailgun") ) {

      if ( (leave && (other.items & IT_NAILGUN)) ) {

         return ;

      }
      new = IT_NAILGUN;
      if ( leave ) {

         other.ammo_lava_nails = (other.ammo_lava_nails + 20.000);

      }
      other.ammo_nails1 = (other.ammo_nails1 + SVC_INTERMISSION);

   }

   if ( (self.classname == "weapon_supernailgun") ) {

      if ( (leave && (other.items & IT_SUPER_NAILGUN)) ) {

         return ;

      }
      new = IT_SUPER_NAILGUN;
      if ( leave ) {

         other.ammo_lava_nails = (other.ammo_lava_nails + 20.000);

      }
      other.ammo_nails1 = (other.ammo_nails1 + SVC_INTERMISSION);

   }

   if ( (self.classname == "weapon_supershotgun") ) {

      if ( (leave && (other.items & IT_SUPER_SHOTGUN)) ) {

         return ;

      }
      new = IT_SUPER_SHOTGUN;
      other.ammo_shells1 = (other.ammo_shells1 + MOVETYPE_FLY);

   }

  if ( (self.classname == "weapon_rocketlauncher") ) {

     if ( (leave && (other.items & IT_ROCKET_LAUNCHER)) ) {

        return ;

     }
     new = IT_ROCKET_LAUNCHER;
     if ( leave ) {

        other.ammo_multi_rockets = (other.ammo_multi_rockets + MOVETYPE_WALK);

     }
     other.ammo_rockets1 = (other.ammo_rockets1 + MOVETYPE_FLY);

   }

   if ( (self.classname == "weapon_grenadelauncher") ) {

      if ( (leave && (other.items & IT_GRENADE_LAUNCHER)) ) {

         return ;

      }
      new = IT_GRENADE_LAUNCHER;
      if ( leave ) {

         other.ammo_multi_rockets = (other.ammo_multi_rockets + MOVETYPE_WALK);

      }
      other.ammo_rockets1 = (other.ammo_rockets1 + MOVETYPE_FLY);

   }

   if ( (self.classname == "weapon_lightning") ) {

      if ( (leave && (other.items & IT_LIGHTNING)) ) {

         return ;

      }
      new = IT_LIGHTNING;
      if ( leave ) {

         other.ammo_plasma = (other.ammo_plasma + MOVETYPE_FLY);

      }
      other.ammo_cells1 = (other.ammo_cells1 + CTF_CAPTURE_BONUS);

   }

   if ( (self.classname == "weapon_laser_gun") ) {

      if (leave && (other.items2 & IT2_LASER_CANNON)) {return;}
      new = IT2_LASER_CANNON;
      other.ammo_cells1 = (other.ammo_cells1 + SVC_INTERMISSION);

   }

   if ( (self.classname == "weapon_mjolnir") ) {

      if ( (leave && (other.items2 & IT2_MJOLNIR)) ) {return;}
      new = IT2_MJOLNIR;
      other.ammo_cells1 = (other.ammo_cells1 + SVC_INTERMISSION);

   }

   if ( (self.classname == "weapon_proximity_gun") ) {

      if ( (leave && (other.items2 & IT2_PROXIMITY_GUN)) ) {return;}
      new = IT2_PROXIMITY_GUN;
      other.ammo_rockets1 = (other.ammo_rockets1 + MOVETYPE_TOSS);

   }
   if (!(condebug) ) {

      sprint (other,"You got the ");
      sprint (other,self.netname);
      sprint (other,"\n");

   }
   sound (other,CHAN_ITEM,"weapons/pkup.wav",TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   bound_other_ammo ();
   old = other.items;
   if (self.classname == "weapon_laser_gun") {

      other.items2 = (other.items2 | IT2_LASER_CANNON);

   } else {

      if (self.classname == "weapon_mjolnir") {

         other.items2 = (other.items2 | IT2_MJOLNIR);

      } else {

         if (self.classname == "weapon_proximity_gun") {

	      other.items2 = (other.items2 | IT2_PROXIMITY_GUN);

         } else {

            other.items = (other.items | new);

         }

      }

   }
   EnableComboWeapons (other);
   if ( (new == IT_LIGHTNING) ) {

      if ( (other.ammo_plasma > FALSE) ) {

         new = IT_PLASMA_GUN;

      }

   } else {

      if ( (new == IT_ROCKET_LAUNCHER) ) {

         if ( (other.ammo_multi_rockets > FALSE) ) {

            new = IT_MULTI_ROCKET;

         }

      } else {

         if ( (new == IT_GRENADE_LAUNCHER) ) {

            if ( (other.ammo_multi_rockets > FALSE) ) {

               new = IT_MULTI_GRENADE;

            }

         } else {

            if ( (new == IT_SUPER_NAILGUN) ) {

               if ( (other.ammo_lava_nails > TRUE) ) {

                  new = IT_LAVA_SUPER_NAILGUN;

               }

            } else {

               if ( (new == IT_NAILGUN) ) {

                  if ( (other.ammo_lava_nails > FALSE) ) {

                     new = IT_LAVA_NAILGUN;

                  }

               }

            }

         }

      }

   }
   stemp = self;
   self = other;
   if ( !deathmatch ) {

      self.weapon = new;

   } else {

      Deathmatch_Weapon (old,new);

   }
   UpdateAmmoCounts (self);
   W_SetCurrentAmmo ();
   self = stemp;
   if ( leave ) {

      return ;

   }
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + SVC_INTERMISSION);

   }
   self.think = SUB_regen;
   activator = other;
   SUB_UseTargets ();

};

void () weapon_supershotgun = {

   precache_model ("progs/g_shot.mdl");
   setmodel (self,"progs/g_shot.mdl");
   self.weapon = IT_SUPER_SHOTGUN;
   self.netname = "Double-barrelled Shotgun";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_nailgun = {

   precache_model ("progs/g_nail.mdl");
   setmodel (self,"progs/g_nail.mdl");
   self.weapon = IT_NAILGUN;
   self.netname = "nailgun";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_supernailgun = {

   precache_model ("progs/g_nail2.mdl");
   setmodel (self,"progs/g_nail2.mdl");
   self.weapon = IT_SUPER_NAILGUN;
   self.netname = "Super Nailgun";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_grenadelauncher = {

   precache_model ("progs/g_rock.mdl");
   setmodel (self,"progs/g_rock.mdl");
   self.weapon = MOVETYPE_WALK;
   self.netname = "Grenade Launcher";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_rocketlauncher = {

   precache_model ("progs/g_rock2.mdl");
   setmodel (self,"progs/g_rock2.mdl");
   self.weapon = MOVETYPE_WALK;
   self.netname = "Rocket Launcher";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_lightning = {

   precache_model ("progs/g_light.mdl");
   setmodel (self,"progs/g_light.mdl");
   self.weapon = MOVETYPE_WALK;
   self.netname = "Thunderbolt";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () ammo_touch = {

   local entity stemp;
   local float best;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   if ( (self.weapon == TRUE) ) {

      if ( (other.ammo_shells1 >= 100.000) ) {

         return ;

      }
      other.ammo_shells1 = (other.ammo_shells1 + self.aflag);

   }
   if ( (self.weapon == FL_SWIM) ) {

      if ( (other.ammo_nails1 >= 200.000) ) {

         return ;

      }
      other.ammo_nails1 = (other.ammo_nails1 + self.aflag);

   }
   if ( (self.weapon == MOVETYPE_WALK) ) {

      if ( (other.ammo_rockets1 >= 100.000) ) {

         return ;

      }
      other.ammo_rockets1 = (other.ammo_rockets1 + self.aflag);

   }
   if ( (self.weapon == MOVETYPE_STEP) ) {

      if ( (other.ammo_cells1 >= 100.000) ) {

         return ;

      }
      other.ammo_cells1 = (other.ammo_cells1 + self.aflag);

   }
   if ( (self.weapon == MOVETYPE_FLY) ) {

      if ( (other.ammo_lava_nails >= 200.000) ) {

         return ;

      }
      other.ammo_lava_nails = (other.ammo_lava_nails + self.aflag);

   }
   if ( (self.weapon == MOVETYPE_TOSS) ) {

      if ( (other.ammo_multi_rockets >= 100.000) ) {

         return ;

      }
      other.ammo_multi_rockets = (other.ammo_multi_rockets + self.aflag);

   }
   if ( (self.weapon == MOVETYPE_PUSH) ) {

      if ( (other.ammo_plasma >= 100.000) ) {

         return ;

      }
      other.ammo_plasma = (other.ammo_plasma + self.aflag);

   }
   EnableComboWeapons (other);
   UpdateAmmoCounts (other);
   bound_other_ammo ();
   if (!(condebug) ) {

      sprint (other,"You got the ");
      sprint (other,self.netname);
      sprint (other,"\n");

   }
   sound (other,CHAN_ITEM,"weapons/lock4.wav",TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   if ( (other.weapon == best) ) {

      stemp = self;
      self = other;
      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      self = stemp;

   }
   stemp = self;
   self = other;
   W_SetCurrentAmmo ();
   self = stemp;
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + SVC_INTERMISSION);

   }
   self.think = SUB_regen;
   activator = other;
   SUB_UseTargets ();

};

float WEAPON_BIG2    = 1.000;

void () item_shells = {

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

void () item_spikes = {

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

void () item_lava_spikes = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_lnail1.bsp");
      setmodel (self,"maps/b_lnail1.bsp");
      self.aflag = 50.000;

   } else {

      precache_model ("maps/b_lnail0.bsp");
      setmodel (self,"maps/b_lnail0.bsp");
      self.aflag = 25.000;

   }
   self.weapon = MOVETYPE_FLY;
   self.netname = "lava nails";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_rockets = {

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

void () item_multi_rockets = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_mrock1.bsp");
      setmodel (self,"maps/b_mrock1.bsp");
      self.aflag = MOVETYPE_BOUNCE;

   } else {

      precache_model ("maps/b_mrock0.bsp");
      setmodel (self,"maps/b_mrock0.bsp");
      self.aflag = MOVETYPE_FLY;

   }
   self.weapon = MOVETYPE_TOSS;
   self.netname = "multi rockets";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_cells = {

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

void () item_plasma = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_plas1.bsp");
      setmodel (self,"maps/b_plas1.bsp");
      self.aflag = STAT_TOTALMONSTERS;

   } else {

      precache_model ("maps/b_plas0.bsp");
      setmodel (self,"maps/b_plas0.bsp");
      self.aflag = MOVETYPE_TOSS;

   }
   self.weapon = MOVETYPE_PUSH;
   self.netname = "plasma";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

float WEAPON_SHOTGUN    = 1.000;
float WEAPON_ROCKET    = 2.000;
float WEAPON_SPIKES    = 4.000;
float WEAPON_BIG    = 8.000;

void () item_weapon = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_SHOTGUN) ) {

      if ( (self.spawnflags & WEAPON_BIG) ) {

         precache_model ("maps/b_shell1.bsp");
         setmodel (self,"maps/b_shell1.bsp");
         self.aflag = CTF_FLAG_RETURN_TIME;

      } else {

         precache_model ("maps/b_shell0.bsp");
         setmodel (self,"maps/b_shell0.bsp");
         self.aflag = 20.000;

      }
      self.weapon = TRUE;
      self.netname = "shells";

   }
   if ( (self.spawnflags & WEAPON_SPIKES) ) {

      if ( (self.spawnflags & WEAPON_BIG) ) {

         precache_model ("maps/b_nail1.bsp");
         setmodel (self,"maps/b_nail1.bsp");
         self.aflag = CTF_FLAG_RETURN_TIME;

      } else {

         precache_model ("maps/b_nail0.bsp");
         setmodel (self,"maps/b_nail0.bsp");
         self.aflag = 20.000;

      }
      self.weapon = FL_SWIM;
      self.netname = "spikes";

   }
   if ( (self.spawnflags & WEAPON_ROCKET) ) {

      if ( (self.spawnflags & WEAPON_BIG) ) {

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

   }
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () key_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (other.items & self.items) || (other.items2 & self.items2) ) {

      return ;

   }
   if (!(condebug) ) {

      sprint (other,"You got ");
      sprint (other,self.netname);
      sprint (other,"\n");

   }
   sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   other.items = (other.items | self.items);
   other.items2 = (other.items2 | self.items2);
   if ( !coop ) {

      self.solid = SOLID_NOT;
      self.model = string_null;

   }
   activator = other;
   SUB_UseTargets ();

};

void () key_setsounds = {

   if ( (world.worldtype == FALSE) ) {

      precache_sound ("misc/medkey.wav");
      self.noise = "misc/medkey.wav";

   }
   if ( (world.worldtype == TRUE) ) {

      precache_sound ("misc/runekey.wav");
      self.noise = "misc/runekey.wav";

   }
   if ( (world.worldtype == FL_SWIM) ) {

      precache_sound2 ("misc/basekey.wav");
      self.noise = "misc/basekey.wav";

   }

};

void () item_key1 = {

   if ( (world.worldtype == FALSE) ) {

      precache_model ("progs/w_s_key.mdl");
      setmodel (self,"progs/w_s_key.mdl");
      self.netname = "the silver key";

   } else {

      if ( (world.worldtype == TRUE) ) {

         precache_model ("progs/m_s_key.mdl");
         setmodel (self,"progs/m_s_key.mdl");
         self.netname = "the silver runekey";

      } else {

         if ( (world.worldtype == FL_SWIM) ) {

            precache_model2 ("progs/b_s_key.mdl");
            setmodel (self,"progs/b_s_key.mdl");
            self.netname = "the silver keycard";

         }

      }

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items = IT_KEY1;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_key_skeleton = {

   if ( (world.worldtype == FALSE) ) {

      precache_model ("progs/w_sk_key.mdl");
      setmodel (self,"progs/w_sk_key.mdl");
      self.netname = "a skeleton key";

   } else {

         precache_model ("progs/w_sk_key.mdl");
         setmodel (self,"progs/w_sk_key.mdl");
         self.netname = "a key of some sort";

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items2 = IT2_KEY_SKELETON;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_key2 = {

   if ( (world.worldtype == FALSE) ) {

      precache_model ("progs/w_g_key.mdl");
      setmodel (self,"progs/w_g_key.mdl");
      self.netname = "a gold key";

   }
   if ( (world.worldtype == TRUE) ) {

      precache_model ("progs/m_g_key.mdl");
      setmodel (self,"progs/m_g_key.mdl");
      self.netname = "a gold runekey";

   }
   if ( (world.worldtype == FL_SWIM) ) {

      precache_model2 ("progs/b_g_key.mdl");
      setmodel (self,"progs/b_g_key.mdl");
      self.netname = "a gold keycard";

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items = IT_KEY2;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_key3 = {

   precache_model ("progs/b_r_key.mdl");
   setmodel (self,"progs/b_r_key.mdl");
   self.netname = "a red keycard";
   key_setsounds ();
   self.touch = key_touch;
   self.items2 = IT2_KEY3;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () sigil_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   centerprint (other,"You got the rune!");
   sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.solid = SOLID_NOT;
   self.model = string_null;
   serverflags = (serverflags | (self.spawnflags & 15.000));
   self.classname = "";
   activator = other;
   SUB_UseTargets ();

};

void () item_sigil = {

   if ( !self.spawnflags ) {

      objerror ("no spawnflags");

   }
   precache_sound ("misc/runekey.wav");
   self.noise = "misc/runekey.wav";
   if ( (self.spawnflags & TRUE) ) {

      precache_model ("progs/end1.mdl");
      setmodel (self,"progs/end1.mdl");

   }
   if ( (self.spawnflags & FL_SWIM) ) {

      precache_model2 ("progs/end2.mdl");
      setmodel (self,"progs/end2.mdl");

   }
   if ( (self.spawnflags & MOVETYPE_STEP) ) {

      precache_model2 ("progs/end3.mdl");
      setmodel (self,"progs/end3.mdl");

   }
   if ( (self.spawnflags & FL_CLIENT) ) {

      precache_model2 ("progs/end4.mdl");
      setmodel (self,"progs/end4.mdl");

   }
   self.touch = sigil_touch;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () random_regen;

void () powerup_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if (!(condebug) ) {

      sprint (other,"You got the ");
      sprint (other,self.netname);
      sprint (other,"\n");

   }
   if ( deathmatch ) {

      self.mdl = self.model;
      if ( (self.classname == "item_random_powerup") ) {

         self.nextthink = (time + SVC_INTERMISSION);
         self.think = random_regen;

      } else {

         if ( ((self.classname == "item_artifact_invulnerability") || (self.classname == "item_artifact_invisibility")) ) {

            self.nextthink = (time + (60.000 * MOVETYPE_FLY));

         } else {

            self.nextthink = (time + 60.000);

         }
         self.think = SUB_regen;

      }

   }
   sound (other,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.solid = SOLID_NOT;
   other.items = (other.items | self.items);
   self.model = string_null;
   if ( (self.netname == "Biosuit") ) {

      other.rad_time = TRUE;
      other.radsuit_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.netname == "Pentagram of Protection") ) {

      other.invincible_time = TRUE;
      other.invincible_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.netname == "Ring of Shadows") ) {

      other.invisible_time = TRUE;
      other.invisible_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.netname == "Quad Damage") ) {

      other.super_time = TRUE;
      other.super_damage_finished = (time + SVC_INTERMISSION);

   }
   activator = other;
   SUB_UseTargets ();

};

void () item_artifact_invulnerability = {

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

void () item_artifact_envirosuit = {

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

void () item_artifact_invisibility = {

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

void () item_artifact_super_damage = {

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

void () BackpackTouch = {

   local string s;
   local float best;
   local float old;
   local float new;
   local entity stemp;
   local float acount;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( ((other == self.owner) && ((self.nextthink - time) > 119.000)) ) {

      return ;

   }
   acount = FALSE;
   if (!(condebug) ) {

      sprint (other,"You get ");

   }
   if ( self.items ) {

      if ( ((other.items & self.items) == FALSE) ) {

         acount = TRUE;
         sprint (other,"the ");
         sprint (other,self.netname);

      }

   } else {

      if ( self.items2) {

         if ( ((other.items2 & self.items2) == FALSE) ) {

            acount = TRUE;
            sprint (other,"the ");
            sprint (other,self.netname);

         } 

      }

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   other.ammo_shells1 = (other.ammo_shells1 + self.ammo_shells1);
   other.ammo_nails1 = (other.ammo_nails1 + self.ammo_nails1);
   other.ammo_rockets1 = (other.ammo_rockets1 + self.ammo_rockets1);
   other.ammo_cells1 = (other.ammo_cells1 + self.ammo_cells1);
   other.ammo_lava_nails = (other.ammo_lava_nails + self.ammo_lava_nails);
   other.ammo_multi_rockets = (other.ammo_multi_rockets + self.ammo_multi_rockets);
   other.ammo_plasma = (other.ammo_plasma + self.ammo_plasma);
   if (self.items) {

     new = self.items;

   }
   if ( !new ) {

      new = other.weapon;
  
   }
   old = other.items;
   other.items = (other.items | new);
   if (self.items2) {

     new = self.items2;

   }
   other.items2 = (other.items2 | new);
   bound_other_ammo ();
   if ( self.ammo_shells1 ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {

         s = ftos (self.ammo_shells1);
         sprint (other,s);
         sprint (other," shells");

      }

   }
   if ( self.ammo_nails1 ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {
         s = ftos (self.ammo_nails1);
         sprint (other,s);
         sprint (other," nails");
      }

   }
   if ( self.ammo_rockets1 ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {

         s = ftos (self.ammo_rockets1);
         sprint (other,s);
         sprint (other," rockets");

      }

   }
   if ( self.ammo_cells1 ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {

         s = ftos (self.ammo_cells1);
         sprint (other,s);
         sprint (other," cells");

      }

   }
   if ( self.ammo_lava_nails ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {

         s = ftos (self.ammo_lava_nails);
         sprint (other,s);
         sprint (other," lava nails");

      }

   }
   if ( self.ammo_multi_rockets ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {

         s = ftos (self.ammo_multi_rockets);
         sprint (other,s);
         sprint (other," multi rockets");

      }

   }
   if ( self.ammo_plasma ) {

      if ( acount ) {

         if (!(condebug) ) {

            sprint (other,", ");

         }

      }
      acount = TRUE;
      if (!(condebug) ) {

         s = ftos (self.ammo_plasma);
         sprint (other,s);
         sprint (other," plasma balls");

      }

   }
   if (!(condebug) ) {

     sprint (other,"\n");

   }
   sound (other,CHAN_ITEM,"weapons/lock4.wav",TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   remove (self);
   self = other;
   EnableComboWeapons (self);
   if ( !deathmatch ) {

      self.weapon = new;

   } else {

      Deathmatch_Weapon (old,new);

   }
   UpdateAmmoCounts (self);
   W_SetCurrentAmmo ();

};

void () DropBackpack = {

   local entity item;

   if ( !(((((self.ammo_shells1 + self.ammo_nails1) + self.ammo_rockets1) + self.ammo_cells1) + self.ammo_lava_nails) + self.ammo_multi_rockets) ) {

      return ;

   }
   item = spawn ();
   item.origin = (self.origin - '0.000 0.000 24.000');
   item.items = self.weapon;
   if ( (item.items == IT_AXE) ) {

      item.netname = "Axe";

   } else {

      if ( (item.items == IT_SHOTGUN) ) {

         item.netname = "Shotgun";

      } else {

         if ( (item.items == IT_SUPER_SHOTGUN) ) {

            item.netname = "Double-barrelled Shotgun";

         } else {

            if ( (item.items == IT_NAILGUN) ) {

               item.netname = "Nailgun";

            } else {

               if ( (item.items == IT_SUPER_NAILGUN) ) {

                  item.netname = "Super Nailgun";

               } else {

                  if ( (item.items == IT_GRENADE_LAUNCHER) ) {

                     item.netname = "Grenade Launcher";

                  } else {

                     if ( (item.items == IT_ROCKET_LAUNCHER) ) {

                        item.netname = "Rocket Launcher";

                     } else {

                        if ( (item.items == IT_LIGHTNING) ) {

                           item.netname = "Thunderbolt";

                        } else {

                           if ( (item.items == IT_LAVA_NAILGUN) ) {

                              item.netname = "Lava Nail Gun";
                              item.items = IT_NAILGUN;

                           } else {

                              if ( (item.items == IT_LAVA_SUPER_NAILGUN) ) {

                                 item.netname = "Super Lava Nail Gun";
                                 item.items = IT_SUPER_NAILGUN;

                              } else {

                                 if ( (item.items == IT_MULTI_GRENADE) ) {

                                    item.netname = "Multi Grenade Launcher";
                                    item.items = IT_GRENADE_LAUNCHER;

                                 } else {

                                    if ( (item.items == IT_MULTI_ROCKET) ) {

                                       item.netname = "Multi Rocket Launcher";
                                       item.items = IT_ROCKET_LAUNCHER;

                                    } else {

                                       if ( (item.items == IT_PLASMA_GUN) ) {

                                          item.netname = "Plasma Gun";
                                          item.items = IT_LIGHTNING;

                                       } else {

                                          item.netname = "";

                                       }

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( (item.items2 == IT2_MJOLNIR) ) {

      item.netname = "Mjolnir's Hammer";

   }
   if ( (item.items2 == IT2_LASER_CANNON) ) {

      item.netname = "Laser Cannon";

   }
   if ( (item.items2 == IT2_PROXIMITY_GUN) ) {

      item.netname = "Proximity Gun";

   }
   item.ammo_shells1 = self.ammo_shells1;
   item.ammo_nails1 = self.ammo_nails1;
   item.ammo_rockets1 = self.ammo_rockets1;
   item.ammo_cells1 = self.ammo_cells1;
   item.ammo_lava_nails = self.ammo_lava_nails;
   item.ammo_multi_rockets = self.ammo_multi_rockets;
   item.ammo_plasma = self.ammo_plasma;
   item.velocity_z = 300.000;
   item.velocity_x = (-100.000 + (random () * 200.000));
   item.velocity_y = (-100.000 + (random () * 200.000));
   item.flags = FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_TOSS;
   setmodel (item,"progs/backpack.mdl");
   setsize (item,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   item.touch = BackpackTouch;
   item.nextthink = (time + CTF_UPDATE_TIME);
   item.think = SUB_Remove;
};
