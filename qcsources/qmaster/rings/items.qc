float UNDERWATER    = 2.000;
float IT2_ANTIGRAV    = 16.000;
float IT2_SHIELD    = 32.000;

void () AmmoCnts;
void () horn_teleport;
void () sphere_spawn;

void () item_recur_use = {

   self.recurring = FALSE;
   self.use = SUB_Null;
   self.nextthink = (time + 0.100);
   self.think = SUB_Remove;

};
void () quad_activate = {

   if  ( (self.speedstate == FALSE) ) {

      localcmd ("+speed\n");
      self.speedstate = TRUE;
      self.speedflag = TRUE;

   }
   if ( (self.speedflag == TRUE) ) {

      self.super_damage_finished = (time + 30.000);
      self.speedflag = FALSE;

   }

};
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
void () PlaceItemFloating = {

   self.mdl = self.model;
   self.flags = FL_ITEM;
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_NONE;
   self.velocity = VEC_ORIGIN;

};
void () StartItemFloating = {

   self.nextthink = (time + 0.200);
   self.think = PlaceItemFloating;

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

   local float difference;
   local float htemp;
   local string s;

   if ( (other.classname != "player") ) {

      return;

   }
   if ( (self.healtype == FL_SWIM) ) {

      if ( (other.health >= 250.000) ) {

         return;

      }
      self.healamount = ceil(self.healamount);
      other.health = (other.health + self.healamount);
      sprint (other,"You receive ");
      s = ftos (self.healamount);
      sprint (other,s);
      sprint (other," health\n");
      sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
      stuffcmd (other,"bf\n");
      self.model = string_null;
      self.solid = SOLID_NOT;
      other.items = (other.items | IT2_SUPERHEALTH);
      self.nextthink = (time + MOVETYPE_FLY);
      self.think = item_megahealth_rot;
      self.owner = other;

   } else {

      if ( (other.health >=100.000) ) {

         return;

      }
      difference = (100.000 - other.health);
      if ( (difference > self.healamount) ) {

         self.healamount = ceil(self.healamount);
         other.health = (other.health + self.healamount);
         sprint (other,"You receive ");
         s = ftos (self.healamount);
         sprint (other,s);
         sprint (other," health\n");
         sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
         stuffcmd (other,"bf\n");
         self.model = string_null;
         self.solid = SOLID_NOT;
         if ( (deathmatch != FL_SWIM) ) {

            if ( deathmatch ) {

               self.nextthink = (time + 20.000);

            }
            self.think = SUB_regen;

         }
         activator = other;
         SUB_UseTargets ();

      } else {
         
         htemp = self.healamount;
         self.healamount = difference;
         self.healamount = ceil(self.healamount);
         other.health = (other.health + self.healamount);
         sprint (other,"You receive ");
         s = ftos (self.healamount);
         sprint (other,s);
         sprint (other," health\n");
         sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
         stuffcmd (other,"bf\n");
         self.healamount = htemp;
         self.healamount = (self.healamount - difference);
         if (!(self.healamount) ) {
            self.model = string_null;
            self.solid = SOLID_NOT;
            if ( (deathmatch != FL_SWIM) ) {

               if ( deathmatch ) {

                  self.nextthink = (time + 20.000);

               }
               self.think = SUB_regen;

            }
            activator = other;
            SUB_UseTargets ();

         }

      }

   }

};
void () item_megahealth_rot = {

   other = self.owner;
   if ( (other.health > other.max_health) ) {

      other.health = (other.health - TRUE);
      self.nextthink = (time + TRUE);
      return ;

   }
   other.items = (other.items - (other.items & IT2_SUPERHEALTH));
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + 20.000);
      self.think = SUB_regen;

   }

};
void () battery_ammo_touch = {

   local entity stemp;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (other.flashlight_ammo >= 100.000) ) {

      return ;

   }
   other.flashlight_ammo = (other.flashlight_ammo + self.aflag);
   if ( (other.flashlight_state == TRUE) ) {

      other.currentammo = (other.currentammo + self.aflag);
      if ( (other.currentammo > 100) ) {

         other.currentammo = 100;

      }

   }
   if ( (other.flashlight_ammo > 100) ) {

      other.flashlight_ammo = 100;

   }
   sprint (other,"You got battery cells");
   sprint (other,"\n");
   sound (other,CHAN_ITEM,"weapons/lock4.wav",TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   other.ammo_cells = other.flashlight_ammo;
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + SVC_INTERMISSION);

   }
   self.think = SUB_regen;
   activator = other;
   SUB_UseTargets ();

};
void () item_cells = {

   self.touch = battery_ammo_touch;
   if ( (self.spawnflags & TRUE) ) {

      precache_model ("maps/b_batt1.bsp");
      setmodel (self,"maps/b_batt1.bsp");
      self.aflag = IT_CELLS2;

   } else {

      precache_model ("maps/b_batt0.bsp");
      setmodel (self,"maps/b_batt0.bsp");
      self.aflag = IT_CELLS1;

   }
   self.netname = "battery cells";
   setsize (self,VEC_ORIGIN,'32.000 32.000 48.000');
   StartItem ();

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
   other.items = ((other.items - (other.items & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3))) + bit);
   self.solid = SOLID_NOT;
   self.model = string_null;
   if ( (deathmatch == TRUE) ) {

      self.nextthink = (time + 20.000);

   }
   self.think = SUB_regen;
   sprint (other,"You got armor\n");
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
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_armor2 = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = TRUE;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_armorInv = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = FL_SWIM;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () key_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.health <= FALSE) ) {

      return ;

   }
   if ( (other.items & self.items) ) {

      return ;

   }
   sprint (other,"You got the ");
   sprint (other,self.netname);
   sprint (other,"\n");
   sound (other,CHAN_ITEM,self.noise,TRUE,ATTN_NORM);
   stuffcmd (other,"bf\n");
   other.items = (other.items | self.items);
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
      self.netname = "silver key";

   } else {

      if ( (world.worldtype == TRUE) ) {

         precache_model ("progs/m_s_key.mdl");
         setmodel (self,"progs/m_s_key.mdl");
         self.netname = "silver runekey";

      } else {

         if ( (world.worldtype == FL_SWIM) ) {

            precache_model2 ("progs/b_s_key.mdl");
            setmodel (self,"progs/b_s_key.mdl");
            self.netname = "silver keycard";

         }

      }

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items = IT_KEY1;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};
void () item_key2 = {

   if ( (world.worldtype == FALSE) ) {

      precache_model ("progs/w_g_key.mdl");
      setmodel (self,"progs/w_g_key.mdl");
      self.netname = "gold key";

   }
   if ( (world.worldtype == TRUE) ) {

      precache_model ("progs/m_g_key.mdl");
      setmodel (self,"progs/m_g_key.mdl");
      self.netname = "gold runekey";

   }
   if ( (world.worldtype == FL_SWIM) ) {

      precache_model2 ("progs/b_g_key.mdl");
      setmodel (self,"progs/b_g_key.mdl");
      self.netname = "gold keycard";

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items = IT_KEY2;
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
void () powerup_touch = {

   local entity stemp;
   local entity otemp;

   if ( (other.classname != "player") ) {

      return;

   }
   if ( (other.health <= FALSE) ) {

      return;

   }
   if ( (other.items & self.items) ) {

      return;

   }
   if ( (other.items2 & self.items2) ) {

      return;

   }
   if ( (self.classname == "item_artifact_super_damage") ) {

      sprint (other,"You got ");

   } else {

      if ( (self.classname == "item_artifact_empathy_shields") || (self.classname == "item_powerup_belt") || (self.classname == "item_powerup_shield") ) {

         sprint (other,"You got an ");

      } else {

         sprint (other,"You got a ");

      }

   }
   sprint (other,self.netname);
   sprint (other,"\n");
   if ( (self.classname == "item_sphere") ) {

      self.mdl = self.model;
      self.nextthink = (time + (30.000));
      self.think = SUB_regen;

   } else {

      if ( (self.recurring) ) {

         if ( (self.classname == "item_artifact_invulnerability") ) {

            self.mdl = self.model;
            self.nextthink = (time + 120.000);
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
   self.model = string_null;
   if ( (self.classname == "item_artifact_envirosuit") ) {

      other.rad_time = TRUE;
      other.radsuit_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.classname == "item_artifact_wetsuit") ) {

      other.wetsuit_time = TRUE;
      other.wetsuit_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.classname == "item_artifact_lavasuit") ) {

      other.therm_time = TRUE;
      other.therm_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.classname == "item_artifact_invulnerability") ) {

      other.invincible_time = TRUE;
      other.invincible_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.classname == "item_artifact_invisibility") ) {

      other.ammo_shells = (other.ammo_shells + TRUE);
      if ( (deathmatch) ) {

         other.frags = (other.frags + TRUE);

      }
      killed_monsters = (killed_monsters + TRUE);
      WriteByte (MSG_ALL,SVC_KILLEDMONSTER);
      if ( (killed_monsters >= total_monsters) ) {

         sound (self,CHAN_VOICE,"misc/flagcap.wav",TRUE,ATTN_NORM);
         self.target = "theexit";

      }
      stemp = self;
      self = other;
      AmmoCnts ();
      self = stemp;

   }
   if ( (self.classname == "item_artifact_super_damage") ) {

      other.super_time = TRUE;
      other.super_damage_finished = (time + SVC_INTERMISSION);
      otemp = self;
      self = other;
      quad_activate ();
      self = otemp;

   }
   if ( (self.classname == "item_powerup_shield") ) {

      other.shield_time = TRUE;
      other.shield_finished = (time + 30.000);

   }
   if ( (self.classname == "item_powerup_belt") ) {

      other.antigrav_time = TRUE;
      other.antigrav_finished = (time + 45.000);
      other.gravity = 0.250;

   }
   if ( (self.classname == "item_sphere") ) {

            other.orb_active = TRUE;
            sphere_spawn ();

   }
   if ( (self.classname == "item_artifact_empathy_shields") ) {

      other.empathy_time = TRUE;
      other.empathy_finished = (time + SVC_INTERMISSION);

   }
   activator = other;
   if (!(self.classname == "item_sphere") ) {

      SUB_UseTargets ();

   }

};
void () item_artifact_invulnerability = {

   self.touch = powerup_touch;
   precache_model ("progs/invulner.mdl");
   precache_sound ("items/protect.wav");
   precache_sound ("items/protect2.wav");
   precache_sound ("items/protect3.wav");
   self.noise = "items/protect.wav";
   setmodel (self,"progs/invulner.mdl");
   self.netname = "Star-Circle!";
   self.items = IT_INVULNERABILITY;
   if ( (self.spawnflags & RECURRING) ) {

      self.use = item_recur_use;
      self.recurring = TRUE;

   }
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

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
   if ( (self.spawnflags & RECURRING) ) {

      self.use = item_recur_use;
      self.recurring = TRUE;

   }
   setsize (self,'-16.000 -16.000 -8.000','16.000 16.000 64.000');
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_artifact_lavasuit = {

   self.touch = powerup_touch;
   precache_model ("progs/suit.mdl");
   precache_sound ("items/suit.wav");
   precache_sound ("items/suit2.wav");
   self.noise = "items/suit.wav";
   setmodel (self,"progs/suit.mdl");
   self.skin = TRUE;
   self.netname = "Thermal Protection Suit";
   self.items = IT_INVISIBILITY;
   if ( (self.spawnflags & RECURRING) ) {

      self.use = item_recur_use;
      self.recurring = TRUE;

   }
   setsize (self,'-16.000 -16.000 -8.000','16.000 16.000 64.000');
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_artifact_invisibility = {

   total_monsters = (total_monsters + TRUE);
   self.touch = powerup_touch;
   precache_model ("progs/invisibl.mdl");
   precache_sound ("misc/flagcap.wav");
   precache_sound ("items/inv1.wav");
   precache_sound ("items/inv2.wav");
   precache_sound ("items/inv3.wav");
   self.noise = "items/inv1.wav";
   setmodel (self,"progs/invisibl.mdl");
   self.netname = "gold Ring";
   setsize (self,'-2.000 -2.000 -24.000','2.000 2.000 32.000');
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_artifact_super_damage = {

   self.touch = powerup_touch;
   precache_model ("progs/quaddama.mdl");
   precache_sound ("items/damage.wav");
   precache_sound ("items/damage2.wav");
   precache_sound ("items/damage3.wav");
   self.noise = "items/damage.wav";
   setmodel (self,"progs/quaddama.mdl");
   self.netname = "Quad Speed";
   self.items = IT_QUAD;
   if ( (self.spawnflags & RECURRING) ) {

      self.use = item_recur_use;
      self.recurring = TRUE;

   }
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
float () rnd_backpack_ammo = {

   local float rnd;
   local float amnt;

   rnd = random ();
   if ( (rnd < 0.250) && (rnd > FALSE) ) {

      amnt = 60;

   } else {

      if ( (rnd < 0.500) && (rnd > 0.250) ) {

         amnt = 40;

      } else {

         if ( (rnd < 0.750) && (rnd > 0.500) ) {

            amnt = 30;

         } else {

            amnt = 20;

         }

      }

   }
   return (amnt);

};
void () item_backpack = {

   self.touch = battery_ammo_touch;
   precache_model ("progs/backpack.mdl");
   precache_sound ("weapons/lock4.wav");
   self.noise = "weapons/lock4.wav";
   setmodel (self,"progs/backpack.mdl");
   self.netname = "Backpack full of battery cells";
   if (!(self.aflag) ) {

      self.aflag = rnd_backpack_ammo ();

   }
   if ( (self.spawnflags & RECURRING) ) {

      self.use = item_recur_use;
      self.recurring = TRUE;

   }
   setsize (self,'-16.000 -16.000 -8.000','16.000 16.000 32.000');
   StartItem ();

};
void () item_artifact_wetsuit = {

   self.touch = powerup_touch;
   precache_model ("progs/wetsuit.mdl");
   precache_sound ("misc/wetsuit.wav");
   precache_sound ("misc/weton.wav");
   precache_sound ("items/suit2.wav");
   self.noise = "misc/weton.wav";
   setmodel (self,"progs/wetsuit.mdl");
   self.netname = "Wetsuit";
   self.items = HIP_IT_WETSUIT;
   if ( (self.spawnflags & RECURRING) ) {

      self.recurring = TRUE;

   }
   setsize (self,'-16.000 -16.000 -8.000','16.000 16.000 64.000');
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () horn_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   self.solid = SOLID_NOT;
   self.model = string_null;
   sprint (other,"You got the Horn of Conjuring\n");
   sound (other,CHAN_VOICE,self.noise,TRUE,ATTN_NONE);
   stuffcmd (other,"bf\n");
   activator = other;
   horn_teleport ();
   SUB_UseTargets ();

};
void () item_hornofconjuring = {

   self.touch = horn_touch;
   precache_model ("progs/horn.mdl");
   precache_sound ("hipitems/horn.wav");
   setmodel (self,"progs/horn.mdl");
   self.noise = "hipitems/horn.wav";
   setsize (self,'-16.000 -16.000 0.000',VEC_HULL_MAX);
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_artifact_empathy_shields = {

   self.touch = powerup_touch;
   precache_model ("progs/empathy.mdl");
   precache_sound ("hipitems/empathy.wav");
   precache_sound ("hipitems/empathy2.wav");
   precache_sound ("items/suit2.wav");
   setmodel (self,"progs/empathy.mdl");
   self.noise = "hipitems/empathy.wav";
   self.netname = "Empathy Shield";
   self.items = HIP_IT_EMPATHY_SHIELDS;
   if ( (self.spawnflags & RECURRING) ) {

      self.recurring = TRUE;

   }
   setsize (self,'-16.000 -16.000 0.000',VEC_HULL_MAX);
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_powerup_shield = {

   self.touch = powerup_touch;
   precache_model ("progs/shield.mdl");
   precache_model ("progs/p_shield.mdl");
   precache_sound ("shield/pickup.wav");
   precache_sound ("shield/hit.wav");
   precache_sound ("shield/fadeout.wav");
   self.noise = "shield/pickup.wav";
   setmodel (self,"progs/shield.mdl");
   self.netname = "Impact Shield";
   self.items = IT2_SHIELD;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_powerup_belt = {

   self.touch = powerup_touch;
   precache_model ("progs/beltup.mdl");
   precache_sound ("belt/pickup.wav");
   precache_sound ("belt/use.wav");
   precache_sound ("belt/fadeout.wav");
   self.noise = "belt/pickup.wav";
   setmodel (self,"progs/beltup.mdl");
   self.netname = "Anti-Grav Belt";
   self.items = IT2_ANTIGRAV;
   if ( (self.spawnflags & RECURRING) ) {

      self.use = item_recur_use;
      self.recurring = TRUE;

   }
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   if ( (self.spawnflags & FLOATING) ) {

      StartItemFloating ();

   } else {

      StartItem ();

   }

};
void () item_taunt = {

   if ( (self.model) ) {

      precache_model (self.model);
      setmodel(self,self.model);
      self.solid = SOLID_NOT;
      self.movetype = MOVETYPE_NONE;

   } else {

      objerror("No model for item_taunt");

   }

};
