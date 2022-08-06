
void (vector org, vector dir) launch_lava_spike = {

   newmis = spawn ();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = vectoangles (dir);
   newmis.touch = lavaspike_touch;
   newmis.classname = "lava_spike";
   newmis.think = SUB_Remove;
   newmis.nextthink = (time + MOVETYPE_TOSS);
   setmodel (newmis,"progs/lspike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.velocity = (dir * 1000.000);

};

void () W_FireSuperLavaSpikes = {

   local vector dir;

   sound (self,CHAN_WEAPON,"weapons/spike2.wav",TRUE,ATTN_NORM);
   self.attack_finished = (time + 0.200);
   self.ammo_lava_nails = (self.ammo_lava_nails - FL_SWIM);
   self.currentammo = (self.ammo_lava_nails - FL_SWIM);
   UpdateAmmoCounts (self);
   dir = aim (self,1000.000);
   launch_lava_spike ((self.origin + '0.000 0.000 16.000'),dir);
   newmis.touch = superlavaspike_touch;
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   self.punchangle_x = CONTENT_SOLID;

};

void (float ox) W_FireLavaSpikes = {

   local vector dir;

   makevectors (self.v_angle);
   if ( ((self.ammo_lava_nails >= FL_SWIM) && (self.weapon == IT_LAVA_SUPER_NAILGUN)) ) {

      W_FireSuperLavaSpikes ();
      return ;

   }
   if ( (self.ammo_lava_nails < TRUE) ) {

      sprint (self,"Out of Lava Nails\n");
      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",TRUE,ATTN_NORM);
   self.attack_finished = (time + 0.200);
   self.ammo_lava_nails = (self.ammo_lava_nails - TRUE);
   self.currentammo = (self.ammo_lava_nails - TRUE);
   UpdateAmmoCounts (self);
   dir = aim (self,1000.000);
   launch_lava_spike (((self.origin + '0.000 0.000 16.000') + (v_right * ox)),dir);
   self.punchangle_x = CONTENT_SOLID;

};

void () lavaspike_touch = {

   local float old_armortype;
   local float old_armorvalue;
   local float old_armormask;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (MOVETYPE_FLYMISSILE);
      if ( (other.classname == "player") ) {

         old_armortype = other.armortype;
         old_armorvalue = other.armorvalue;
         old_armormask = (other.items2 & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3));
         other.armortype = FALSE;
         other.armorvalue = FALSE;
         T_Damage (other,self,self.owner,MOVETYPE_FLYMISSILE);
         other.armortype = old_armortype;
         other.armorvalue = old_armorvalue;
         other.items2 = (other.items2 | old_armormask);

      } else {

         if ( (other.classname != "monster_lava_man") ) {

            T_Damage (other,self,self.owner,CTF_CAPTURE_BONUS);

         }

      }

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      if ( (self.classname == "wizspike") ) {

         WriteByte (MSG_BROADCAST,TE_WIZSPIKE);

      } else {

         if ( (self.classname == "knightspike") ) {

            WriteByte (MSG_BROADCAST,TE_KNIGHTSPIKE);

         } else {

            WriteByte (MSG_BROADCAST,TE_SPIKE);

         }

      }
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   remove (self);

};

void () superlavaspike_touch = {

   local float old_armortype;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (18.000);
      if ( (other.classname == "player") ) {

         old_armortype = other.armortype;
         other.armortype = (other.armortype * 0.500);
         T_Damage (other,self,self.owner,18.000);
         if ( (other.armortype != FALSE) ) {

            other.armortype = old_armortype;

         }

      } else {

         if ( (other.classname != "monster_lava_man") ) {

            T_Damage (other,self,self.owner,SVC_INTERMISSION);

         }

      }

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   remove (self);

};
