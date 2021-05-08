
void  ()flashspin =  {
   if ( (self.lifetime < time) ) {

      remove ( self);
   } else {

      self.scale += 0.05000;
      AdvanceThinkTime(self,0.07500);

   }
};


void  (vector org)MakeFlash =  {
   newmis = spawn_temp ( );
   newmis.movetype = MOVETYPE_NOCLIP;
   newmis.angles = vectoangles ( v_forward);
   newmis.avelocity_z = random(200.00000,700.00000);
   newmis.scale = 0.10000;
   newmis.drawflags |= (MLS_ABSLIGHT | SCALE_ORIGIN_CENTER);
   newmis.abslight = 0.50000;
   newmis.lifetime = (time + 0.30000);
   newmis.think = flashspin;
   AdvanceThinkTime(newmis,0.00000);
   setmodel ( newmis, "models/arrowhit.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, org);
};


void  ()FallAndRemove =  {
   traceline ( self.origin, (self.origin - '0.00000 0.00000 24.00000'), TRUE, self);
   if ( ((pointcontents ( self.origin) == CONTENT_SOLID) || (trace_fraction < 1.00000)) ) {

      remove ( self);

   }
   self.movetype = MOVETYPE_BOUNCE;
   self.velocity_z = random(-60.00000,-150.00000);
   self.avelocity = RandomVector ( '50.00000 50.00000 50.00000');
   self.think = SUB_Remove;
   AdvanceThinkTime(self,self.wait);
};


void  ()CB_BoltStick =  {
   if ( (self.wait <= time) ) {

      if ( (self.classname == "bolt") ) {

         self.wait = 2.00000;
         self.think = FallAndRemove;
      } else {

         if ( (self.classname == "stickmine") ) {

            self.think = MultiExplode;
         } else {

            self.think = DarkExplosion;

         }

      }
   } else {

      if ( ((self.enemy.health <= 0.00000) && self.health) ) {

         self.health = 0.00000;
         if ( (self.classname == "bolt") ) {

            self.wait = random(1.00000,3.00000);
            self.think = FallAndRemove;
         } else {

            self.movetype = MOVETYPE_BOUNCE;
            self.velocity_z = random(-100.00000,100.00000);
            self.avelocity = RandomVector ( '50.00000 50.00000 50.00000');

         }
      } else {

         if ( (self.movetype != MOVETYPE_BOUNCE) ) {

            setorigin ( self, (self.enemy.origin + self.view_ofs));
            self.angles = (self.o_angle + self.enemy.angles);
            self.think = CB_BoltStick;

         }

      }

   }
   AdvanceThinkTime(self,0.00000);
};


void  ()CB_BoltHit =  {
local vector stickdir = '0.00000 0.00000 0.00000';
local vector stickspot = '0.00000 0.00000 0.00000';
local vector center = '0.00000 0.00000 0.00000';
local float rad = 0.00000;
local float stick = 0.00000;
   if ( ((other == self.owner) || ((other.owner == self.owner) && (other.classname == self.classname))) ) {

      return ;

   }
   v_forward = normalize ( self.velocity);
   sound ( self, CHAN_BODY, "misc/null.wav", 1.00000, ATTN_NORM);
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.takedamage = DAMAGE_NO;
   self.velocity = '0.00000 0.00000 0.00000';
   self.movetype = MOVETYPE_NOCLIP;
   self.solid = SOLID_NOT;
   self.touch = SUB_Null;
   self.health = other.health;
   if ( (other.thingtype == THINGTYPE_FLESH) ) {

      sound ( self, CHAN_WEAPON, "assassin/arr2flsh.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (other.thingtype == THINGTYPE_WOOD) ) {

         sound ( self, CHAN_WEAPON, "assassin/arr2wood.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_WEAPON, "weapons/met2stn.wav", 1.00000, ATTN_NORM);

      }

   }
   MakeFlash ( (self.origin - (v_forward * 8.00000)));
   if ( other.takedamage ) {

      if ( (self.classname == "bolt") ) {

         T_Damage ( other, self, self.owner, 10.00000);
      } else {

         T_Damage ( other, self, self.owner, 3.00000);

      }
      SpawnPuff ( (self.origin + (v_forward * 8.00000)), ('0.00000 0.00000 0.00000' - (v_forward * 24.00000)), 10.00000, other);
      if ( (other.solid != SOLID_BSP) ) {

         if ( (other.classname == "player") ) {

            stickdir_z = ((other.origin_z + other.proj_ofs_z) + 1.00000);
            stickdir = (other.origin + (normalize ( (self.origin - other.origin)) * 12.00000));
            stick = TRUE;
            setorigin ( self, stickdir);
         } else {

            rad = ((other.maxs_x + other.maxs_z) * 0.50000);
            center = ((other.absmax + other.absmin) * 0.50000);
            stickspot = (self.origin + ((v_forward * other.maxs_x) * 2.00000));
            if ( (vlen ( (center - stickspot)) < (rad * 0.50000)) ) {

               stick = TRUE;
               setorigin ( self, stickspot);
            } else {

               stick = FALSE;

            }

         }
         self.wait = (time + random(0.10000,2.00000));

      }
   } else {

      CreateWhiteSmoke ( (self.origin - (v_forward * 8.00000)), '0.00000 0.00000 8.00000', HX_FRAME_TIME);
      SpawnPuff ( (self.origin + (v_forward * 8.00000)), ('0.00000 0.00000 0.00000' - (v_forward * 24.00000)), 10.00000, world);
      if ( (self.classname == "bolt") ) {

         if ( (random() < 0.70000) ) {

            chunk_death ( );
         } else {

            if ( (random() < 0.50000) ) {

               self.movetype = MOVETYPE_BOUNCE;
               self.avelocity_x = random(-360.00000,360.00000);
               self.avelocity_y = random(-360.00000,360.00000);
               self.avelocity_z = random(-360.00000,360.00000);
               self.touch = SUB_Null;
               self.think = SUB_Remove;
               AdvanceThinkTime(self,random(0.50000,1.50000));
               return ;

            }

         }
      } else {

         stick = TRUE;

      }
      self.wait = (time + random(1.00000,3.00000));

   }
   if ( other.movetype ) {

      if ( stick ) {

         self.enemy = other;
         self.view_ofs = (self.origin - other.origin);
         self.o_angle = (self.angles - self.enemy.angles);
         if ( other.health ) {

            self.health = other.health;
         } else {

            self.health = FALSE;

         }
         self.think = CB_BoltStick;
         AdvanceThinkTime(self,0.00000);
      } else {

         if ( (self.classname == "bolt") ) {

            remove ( self);
         } else {

            DarkExplosion ( );

         }

      }
   } else {

      self.movetype = MOVETYPE_NONE;
      if ( (self.classname == "bolt") ) {

         self.think = SUB_Remove;
      } else {

         self.think = DarkExplosion;

      }
      AdvanceThinkTime(self,2.00000);

   }
};


void  ()ArrowFlyThink =  {
   if ( ((self.lifetime < time) && (self.mins == '0.00000 0.00000 0.00000')) ) {

      self.takedamage = DAMAGE_YES;

   }
   if ( (self.model == "models/flaming.mdl") ) {

      self.frame += 1.00000;
      if ( (self.frame > 9.00000) ) {

         self.frame = 0.00000;

      }

   }
   self.angles = vectoangles ( self.velocity);
   self.think = ArrowFlyThink;
   AdvanceThinkTime(self,0.05000);
};


void  ()ArrowSound =  {
   self.think = ArrowFlyThink;
   AdvanceThinkTime(self,0.00000);
};


void  ()FlamingArrowThink =  {
local float waterornot = 0.00000;
   waterornot = pointcontents ( self.origin);
   if ( ((waterornot == CONTENT_WATER) || (waterornot == CONTENT_SLIME)) ) {

      sound ( self, CHAN_WEAPON, "misc/fout.wav", 1.00000, ATTN_NORM);
      DeathBubbles ( 1.00000);
      setmodel ( self, "models/NFarrow.mdl");

   }
   ArrowSound ( );
};


void  ()ArrowThink =  {
local vector dir = '0.00000 0.00000 0.00000';
   dir = normalize ( self.velocity);
   traceline ( self.origin, (self.origin + (dir * 1000.00000)), FALSE, self);
   if ( !trace_ent.takedamage ) {

      HomeThink ( );

   }
   self.angles = vectoangles ( self.velocity);
   if ( (self.classname == "bolt") ) {

      self.think = ArrowSound;
   } else {

      self.think = FlamingArrowThink;

   }
   AdvanceThinkTime(self,0.00000);
};


void  (float offset,float powered_up)FireCB_Bolt =  {
local entity missile;
   makevectors ( self.v_angle);
   missile = spawn ( );
   missile.owner = self;
   missile.solid = SOLID_BBOX;
   missile.hull = HULL_POINT;
   missile.health = 3.00000;
   if ( powered_up ) {

      missile.frags = TRUE;
      missile.thingtype = THINGTYPE_METAL;
      missile.movetype = MOVETYPE_FLYMISSILE;
      missile.classname = "flaming arrow";
      setmodel ( missile, "models/flaming.mdl");
      missile.dmg = 40.00000;
      missile.drawflags |= MLS_FIREFLICKER;
      missile.th_die = MultiExplode;
   } else {

      missile.thingtype = THINGTYPE_WOOD;
      missile.movetype = MOVETYPE_FLYMISSILE;
      missile.classname = "bolt";
      setmodel ( missile, "models/arrow.mdl");
      missile.th_die = chunk_death;

   }
   missile.touch = CB_BoltHit;
   missile.speed = random(700.00000,1200.00000);
   missile.velocity = ((normalize ( v_forward) * missile.speed) + (v_right * offset));
   missile.o_angle = ((normalize ( v_forward) * missile.speed) + (v_right * offset));
   missile.angles = vectoangles ( missile.velocity);
   missile.ideal_yaw = TRUE;
   missile.turn_time = 0.00000;
   missile.veer = 0.00000;
   missile.think = ArrowThink;
   AdvanceThinkTime(missile,0.00000);
   missile.lifetime = (time + 0.20000);
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, ((self.origin + self.proj_ofs) + (v_forward * 8.00000)));
};

void  ()crossbow_fire;

void  ()crossbow_idle =  {
   self.th_weapon = crossbow_idle;
   self.weaponframe = 33.00000;
};


void  ()crossbow_fire =  {
   self.wfs = advanceweaponframe ( 15.00000, 32.00000);
   self.th_weapon = crossbow_fire;
   if ( (self.weaponframe == 16.00000) ) {

      if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

         sound ( self, CHAN_WEAPON, "assassin/firefblt.wav", 1.00000, ATTN_NORM);
         FireCB_Bolt ( 0.00000, TRUE);
         FireCB_Bolt ( -100.00000, TRUE);
         FireCB_Bolt ( 100.00000, TRUE);
         FireCB_Bolt ( -200.00000, TRUE);
         FireCB_Bolt ( 200.00000, TRUE);
         self.attack_finished = (time + 0.30000);
         self.bluemana -= 10.00000;
      } else {

         sound ( self, CHAN_WEAPON, "assassin/firebolt.wav", 1.00000, ATTN_NORM);
         FireCB_Bolt ( 0.00000, FALSE);
         FireCB_Bolt ( -100.00000, FALSE);
         FireCB_Bolt ( 100.00000, FALSE);
         self.attack_finished = (time + 0.50000);
         self.bluemana -= 3.00000;

      }
   } else {

      if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

         crossbow_idle ( );

      }

   }
};


void  ()crossbow_select =  {
   self.wfs = advanceweaponframe ( 14.00000, 0.00000);
   self.weaponmodel = "models/crossbow.mdl";
   self.th_weapon = crossbow_select;
   if ( (self.weaponframe == 0.00000) ) {

      self.attack_finished = (time - 1.00000);
      crossbow_idle ( );

   }
};


void  ()crossbow_deselect =  {
   self.wfs = advanceweaponframe ( 0.00000, 14.00000);
   self.th_weapon = crossbow_deselect;
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      W_SetCurrentAmmo ( );

   }
};

