void  ()setstaff_decide_attack;
void  ()setstaff_idle;

void  ()DrawLinks =  {
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
   org = self.origin;
   dir = normalize ( (self.view_ofs - org));
   org += (dir * 15.00000);
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_STREAM_CHAIN);
   WriteEntity ( MSG_BROADCAST, self);
   WriteByte ( MSG_BROADCAST, (1.00000 + STREAM_ATTACHED));
   WriteByte ( MSG_BROADCAST, 1.00000);
   WriteCoord ( MSG_BROADCAST, org_x);
   WriteCoord ( MSG_BROADCAST, org_y);
   WriteCoord ( MSG_BROADCAST, org_z);
   WriteCoord ( MSG_BROADCAST, self.view_ofs_x);
   WriteCoord ( MSG_BROADCAST, self.view_ofs_y);
   WriteCoord ( MSG_BROADCAST, self.view_ofs_z);
};


void  ()DeactivateGhook =  {
   self.aflag = FALSE;
   CreateRedFlash ( self.origin);
   sound ( self, CHAN_BODY, "items/itmspawn.wav", 1.00000, ATTN_NORM);
   remove ( self);
};


void  ()PullBack =  {
   if ( (self.enemy != world) ) {

      self.enemy.flags2 ^= FL_CHAINED;
      if ( (self.enemy.flags2 & FL_ALIVE) ) {

         dprintf ( "Restoring old movetype: %s\n", self.enemy.oldmovetype);
         self.enemy.movetype = self.enemy.oldmovetype;
      } else {

         dprint ( "Setting movetype to bounce\n");
         self.enemy.movetype = MOVETYPE_BOUNCE;

      }
      self.enemy = world;
   } else {

      dprint ( "No enemy\n");

   }
   self.movetype = MOVETYPE_NOCLIP;
   self.solid = SOLID_NOT;
   self.velocity = (normalize ( (self.view_ofs - self.origin)) * 350.00000);
   self.flags ^= FL_ONGROUND;
   DrawLinks ( );
   if ( ((vlen ( (self.origin - self.view_ofs)) < 48.00000) || (self.lifetime < time)) ) {

      self.think = DeactivateGhook;
   } else {

      self.think = PullBack;

   }
   AdvanceThinkTime(self,0.05000);
};


void  ()Yank =  {
local float dist = 0.00000;
local vector dir = '0.00000 0.00000 0.00000';
   if ( (((!self.enemy.health || !(self.enemy.flags2 & FL_ALIVE)) || !(self.enemy.flags2 & FL_CHAINED)) || (self.attack_finished < time)) ) {

      self.lifetime = (time + 2.00000);
      self.think = PullBack;
      AdvanceThinkTime(self,0.00000);
      return ;

   }
   setorigin ( self, ((self.enemy.origin + self.enemy.mins) + (self.enemy.size * 0.50000)));
   self.velocity = '0.00000 0.00000 0.00000';
   if ( (self.enemy.v_angle != self.o_angle) ) {

      self.enemy.v_angle = self.o_angle;

   }
   if ( ((random() < 0.20000) && (random() < 0.20000)) ) {

      SpawnPuff ( self.origin, self.velocity, 10.00000, self.enemy);
      if ( (random() < 0.10000) ) {

         sound ( self.enemy, CHAN_BODY, "assassin/chntear.wav", 1.00000, ATTN_NORM);

      }

   }
   if ( ((self.enemy.health <= (self.health / 200.00000)) && self.frags) ) {

      T_Damage ( self.enemy, self, self.owner, 5000.00000);
      self.lifetime = (time + 2.00000);
      self.think = PullBack;
      AdvanceThinkTime(self,0.00000);
      return ;
   } else {

      T_Damage ( self.enemy, self, self.owner, (self.health / 200.00000));

   }
   DrawLinks ( );
   if ( (self.enemy.classname != "player") ) {

      if ( (self.enemy.nextthink < (time + 0.15000)) ) {

         AdvanceThinkTime(self.enemy,0.15000);

      }
      if ( (self.enemy.attack_finished < (time + 0.15000)) ) {

         self.enemy.attack_finished = (time + 0.15000);

      }
      if ( (self.enemy.pausetime < (time + 0.15000)) ) {

         self.enemy.pausetime = (time + 0.15000);

      }

   }
   if ( (self.wait <= time) ) {

      dir = normalize ( (self.view_ofs - self.origin));
      self.angles = vectoangles ( ('0.00000 0.00000 0.00000' - dir));
      dist = vlen ( (self.origin - self.view_ofs));
      if ( (dist <= 100.00000) ) {

         dir = (dir * dist);

      }
      if ( (dist > 100.00000) ) {

         dir = (dir * 300.00000);

      }
      if ( (self.enemy.flags & FL_ONGROUND) ) {

         self.enemy.flags ^= FL_ONGROUND;
         dir += '0.00000 0.00000 200.00000';

      }
      if ( (self.enemy.flags & FL_CLIENT) ) {

         self.enemy.adjust_velocity = ((self.enemy.velocity + dir) * 0.50000);
      } else {

         self.enemy.velocity = ((self.enemy.velocity + dir) * 0.50000);

      }
   } else {

      self.enemy.velocity = '0.00000 0.00000 0.00000';

   }
   if ( (((!self.enemy.health || !(self.enemy.flags2 & FL_ALIVE)) || !(self.enemy.flags2 & FL_CHAINED)) || (self.attack_finished < time)) ) {

      self.lifetime = (time + 2.00000);
      self.think = PullBack;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.think = Yank;
      AdvanceThinkTime(self,0.05000);

   }
};


void  (entity bound)Grab =  {
   sound ( self, CHAN_AUTO, "assassin/chn2flsh.wav", 1.00000, ATTN_NORM);
   self.wait = (time + 0.30000);
   SpawnPuff ( self.origin, self.velocity, 10.00000, bound);
   self.velocity = '0.00000 0.00000 0.00000';
   self.avelocity = '0.00000 0.00000 0.00000';
   self.movedir = normalize ( (self.origin - self.view_ofs));
   setorigin ( self, (((bound.absmin + bound.absmax) * 0.50000) + (self.movedir * -10.00000)));
   self.movedir = normalize ( (self.origin - self.view_ofs));
   self.enemy = bound;
   if ( !(bound.flags2 & FL_CHAINED) ) {

      if ( (other.flags & FL_CLIENT) ) {

         if ( (bound.rings & RING_FLIGHT) ) {

            bound.oldmovetype = MOVETYPE_FLY;
         } else {

            bound.oldmovetype = MOVETYPE_WALK;

         }
      } else {

         bound.oldmovetype = bound.movetype;

      }
      bound.movetype = MOVETYPE_FLY;

   }
   bound.flags2 |= FL_CHAINED;
   self.o_angle = bound.v_angle;
   self.health = bound.health;
   self.attack_finished = (time + 10.00000);
   self.think = Yank;
   AdvanceThinkTime(self,0.00000);
   T_Damage ( bound, self, self.owner, 3.00000);
};


void  ()HookHit =  {
   if ( ((other == self.owner) || (other.classname == self.classname)) ) {

      return ;

   }
   self.touch = SUB_Null;
   if ( ((other.takedamage && (other.flags2 & FL_ALIVE)) && (other.health < 1000.00000)) ) {

      Grab ( other);
   } else {

      DarkExplosion ( );

   }
};


void  ()HookHome =  {
local vector destiny = '0.00000 0.00000 0.00000';
   if ( (self.enemy != world) ) {

      destiny = self.enemy.origin;
      destiny_z = ((self.enemy.absmax_z + self.enemy.absmin_z) * 0.50000);
      self.velocity = (normalize ( (destiny - self.origin)) * 350.00000);
      self.angles = vectoangles ( self.velocity);

   }
   if ( (self.pain_finished < time) ) {

      sound ( self, CHAN_BODY, "assassin/chain.wav", 1.00000, ATTN_NORM);
      self.pain_finished = (time + 0.50000);

   }
   DrawLinks ( );
   if ( (((self.lifetime < time) && !self.frags) || (!self.enemy.health && (self.enemy != world))) ) {

      self.lifetime = (time + 2.00000);
      self.think = PullBack;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.think = HookHome;
      AdvanceThinkTime(self,0.05000);

   }
};


void  (vector startpos,vector endpos,entity loser,entity winner,float gibhook)Hook =  {
local entity ghook;
   ghook = spawn ( );
   sound ( self, CHAN_AUTO, "misc/whoosh.wav", 1.00000, ATTN_NORM);
   ghook.movetype = MOVETYPE_FLYMISSILE;
   ghook.solid = SOLID_PHASE;
   ghook.touch = HookHit;
   ghook.classname = "hook";
   ghook.speed = 8.00000;
   ghook.owner = winner;
   ghook.enemy = loser;
   ghook.aflag = TRUE;
   ghook.view_ofs = startpos;
   ghook.frags = TRUE;
   ghook.lifetime = (time + 3.00000);
   ghook.dmg = 10.00000;
   ghook.scale = 2.00000;
   ghook.movedir = normalize ( (endpos - startpos));
   ghook.velocity = (ghook.movedir * 500.00000);
   ghook.angles = vectoangles ( ghook.velocity);
   setmodel ( ghook, "models/scrbpbdy.mdl");
   setsize ( ghook, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( ghook, (startpos + (ghook.movedir * 6.00000)));
   ghook.think = HookHome;
   AdvanceThinkTime(ghook,0.00000);
};


void  (vector org,float mode)DoHook =  {
local vector dir = '0.00000 0.00000 0.00000';
   dir = org;
   if ( (mode & 1.00000) ) {

      dir += (v_right * random(300.00000));
   } else {

      dir -= (v_right * random(300.00000));

   }
   if ( (mode & 2.00000) ) {

      dir_z += random(300.00000,1000.00000);
   } else {

      dir_z += random(100.00000);

   }
   traceline ( self.enemy.origin, dir, TRUE, self);
   Hook ( trace_endpos, org, self.enemy, self.owner, TRUE);
};


void  ()ChainsOfLove =  {
local vector org = '0.00000 0.00000 0.00000';
   self.enemy.velocity = '0.00000 0.00000 0.00000';
   self.enemy.oldmovetype = self.enemy.movetype;
   self.enemy.movetype = MOVETYPE_NONE;
   makevectors ( self.enemy.angles);
   org = self.enemy.origin;
   org_z += (0.50000 * self.enemy.maxs_z);
   DoHook ( org, 0.00000);
   DoHook ( org, 1.00000);
   DoHook ( org, 2.00000);
   DoHook ( org, 3.00000);
   remove ( self.movechain);
   remove ( self);
};


void  ()scarab_die =  {
   if ( self.lockentity.takedamage ) {

      self.dmg = 75.00000;

   }
	if ( (self.movechain == world) ) {

		 return;

   }
   remove ( self.movechain);
   MultiExplode ( );
};


void  ()LatchOn =  {
   if ( (((((other.takedamage && other.movetype) && other.health) && (other.solid != SOLID_BSP)) && (other.flags2 & FL_ALIVE)) && !(other.artifact_active & ART_INVINCIBILITY)) ) {

      if ( ((other.health > 150.00000) || ((other.flags & FL_MONSTER) && (other.monsterclass >= CLASS_BOSS))) ) {

         self.lockentity = other;
         scarab_die ( );
      } else {

         self.touch = SUB_Null;
         self.velocity = '0.00000 0.00000 0.00000';
         self.enemy = other;
         ChainsOfLove ( );

      }
   } else {

      scarab_die ( );

   }
};


void  ()scarab_think =  {
   self.frame += 1.00000;
   if ( (self.frame > 15.00000) ) {

      self.frame = 8.00000;

   }
   self.movechain.frame = self.frame;
   if ( (self.pain_finished <= time) ) {

      HomeThink ( );
      self.angles = vectoangles ( self.velocity);
      self.pain_finished = (time + 0.10000);
      sound ( self, CHAN_BODY, "assassin/scrbfly.wav", 1.00000, ATTN_NORM);

   }
   particle4 ( self.origin, 7.00000, random(250.00000,254.00000), PARTICLETYPE_EXPLODE2, random(3.00000,7.00000));
   if ( (self.lifetime < time) ) {

      self.think = scarab_die;

   }
   AdvanceThinkTime(self,0.05000);
};


void  ()TheOldBallAndChain =  {
local entity wings;
   sound ( self, CHAN_WEAPON, "assassin/scarab.wav", 1.00000, ATTN_NORM);
   self.attack_finished = (time + 0.50000);
   makevectors ( self.v_angle);
   self.punchangle_x = -6.00000;
   self.effects |= EF_MUZZLEFLASH;
   newmis = spawn ( );
   newmis.owner = self;
   newmis.classname = "chainball";
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.drawflags = MLS_ABSLIGHT;
   newmis.th_die = scarab_die;
   newmis.frags = TRUE;
   newmis.dmg = 150.00000;
   newmis.abslight = 0.50000;
   newmis.scale = 2.50000;
   newmis.touch = LatchOn;
   newmis.velocity = (normalize ( v_forward) * 800.00000);
   newmis.o_angle = (normalize ( v_forward) * 800.00000);
   newmis.speed = 800.00000;
   newmis.veer = 50.00000;
   newmis.hoverz = TRUE;
   newmis.turn_time = 2.00000;
   newmis.lifetime = (time + 5.00000);
   newmis.pain_finished = (time + 0.20000);
   newmis.think = scarab_think;
   AdvanceThinkTime(newmis,0.00000);
   setmodel ( newmis, "models/scrbpbdy.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, ((self.origin + self.proj_ofs) + (v_forward * 12.00000)));
   wings = spawn ( );
   setmodel ( wings, "models/scrbpwng.mdl");
   setsize ( wings, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( wings, ((newmis.origin + '0.00000 0.00000 5.00000') - (v_forward * 3.00000)));
   newmis.movechain = wings;
   wings.scale = 2.50000;
   wings.drawflags |= (MLS_ABSLIGHT | DRF_TRANSLUCENT);
   wings.abslight = 0.50000;
   wings.flags |= FL_MOVECHAIN_ANGLE;
};


void  ()pincer_touch =  {
   if ( (((other == world) || (other.solid == SOLID_BSP)) || (other.mass > 300.00000)) ) {

      DarkExplosion ( );
   } else {

      if ( (other != self.enemy) ) {

         if ( other.takedamage ) {

            self.enemy = other;
            makevectors ( self.velocity);
            T_Damage ( other, self, self.owner, self.dmg);
            if ( (self.dmg < 10.00000) ) {

               T_Damage ( other, self, self.owner, 10.00000);
               DarkExplosion ( );
            } else {

               SpawnPuff ( self.origin, self.velocity, 10.00000, other);
               SpawnPuff ( (self.origin + (v_forward * 36.00000)), self.velocity, 10.00000, other);
               if ( (other.thingtype == THINGTYPE_FLESH) ) {

                  sound ( self, CHAN_VOICE, "assassin/core.wav", 1.00000, ATTN_NORM);
                  MeatChunks ( (self.origin + (v_forward * 36.00000)), (((self.velocity * 0.20000) + (v_right * random(-30.00000,150.00000))) + (v_up * random(-30.00000,150.00000))), 5.00000);

               }
               if ( (other.classname == "player") ) {

                  T_Damage ( other, self, self.owner, ((self.dmg + (self.frags * 10.00000)) / 3.00000));
               } else {

                  T_Damage ( other, self, self.owner, (self.dmg + (self.frags * 10.00000)));

               }
               self.frags += 1.00000;
               self.dmg -= 10.00000;

            }

         }

      }

   }
};


void  ()pincer_think =  {
   if ( (self.frame < 7.00000) ) {

      self.frame += 1.00000;

   }
   if ( (self.pain_finished <= time) ) {

      self.pain_finished = (time + 1.00000);
      sound ( self, CHAN_BODY, "assassin/spin.wav", 1.00000, ATTN_NORM);

   }
   if ( ((self.lifetime < time) || (self.flags & FL_ONGROUND)) ) {

      DarkExplosion ( );
   } else {

      if ( (self.velocity != (self.movedir * self.speed)) ) {

         self.velocity = (self.movedir * self.speed);

      }
      self.think = pincer_think;
      AdvanceThinkTime(self,0.10000);

   }
};


void  (float power_value)Drilla =  {
   sound ( self, CHAN_WEAPON, "assassin/pincer.wav", 1.00000, ATTN_NORM);
   makevectors ( self.v_angle);
   self.punchangle_x = (power_value * -1.00000);
   self.effects |= EF_MUZZLEFLASH;
   newmis = spawn ( );
   newmis.enemy = self;
   newmis.owner = self;
   newmis.classname = "pincer";
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_PHASE;
   newmis.thingtype = 1.00000;
   newmis.touch = pincer_touch;
   newmis.dmg = (power_value * 17.00000);
   if ( (newmis.dmg < 33.00000) ) {

      newmis.dmg = 33.00000;

   }
   newmis.th_die = DarkExplosion;
   newmis.drawflags = MLS_ABSLIGHT;
   newmis.abslight = 0.50000;
   newmis.scale = 2.00000;
   newmis.speed = (750.00000 + (30.00000 * power_value));
   newmis.movedir = v_forward;
   newmis.velocity = (newmis.movedir * newmis.speed);
   newmis.angles = vectoangles ( newmis.velocity);
   setmodel ( newmis, "models/scrbstp1.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, ((self.origin + self.proj_ofs) + (v_forward * 8.00000)));
   self.attack_finished = (time + (power_value / 10.00000));
   newmis.lifetime = (time + 7.00000);
   newmis.think = pincer_think;
   AdvanceThinkTime(newmis,0.00000);
};


void  ()setstaff_powerfire =  {
   self.wfs = advanceweaponframe ( 25.00000, 31.00000);
   self.th_weapon = setstaff_powerfire;
   if ( (self.weaponframe == 26.00000) ) {

      TheOldBallAndChain ( );
      self.greenmana -= 30.00000;
      self.bluemana -= 30.00000;

   }
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      setstaff_idle ( );

   }
};


void  ()setstaff_settle =  {
   self.wfs = advanceweaponframe ( 15.00000, 23.00000);
   self.th_weapon = setstaff_settle;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      setstaff_idle ( );

   }
};


void  ()setstaff_readyfire =  {
   if ( (self.weaponframe > 14.00000) ) {

      self.weaponframe = 0.00000;

   }
   if ( (self.weaponframe == 0.00000) ) {

      sound ( self, CHAN_WEAPON, "assassin/build.wav", 1.00000, ATTN_NORM);

   }
   if ( ((self.weaponframe >= 0.00000) && (self.weaponframe < 14.00000)) ) {

      self.weaponframe_cnt += 1.00000;
      if ( (self.weaponframe_cnt > 3.00000) ) {

         self.wfs = advanceweaponframe ( 0.00000, 14.00000);
         self.weaponframe_cnt = 0.00000;
      } else {

         if ( (self.weaponframe_cnt == 1.00000) ) {

            if ( (self.greenmana >= 1.00000) ) {

               self.greenmana -= 1.00000;

            }
            if ( (self.bluemana >= 1.00000) ) {

               self.bluemana -= 1.00000;

            }

         }

      }
      if ( (self.weaponframe == 14.00000) ) {

         self.weaponframe_cnt = 0.00000;

      }
   } else {

      if ( (self.weaponframe_cnt < time) ) {

         sound ( self, CHAN_WEAPON, "misc/pulse.wav", 1.00000, ATTN_NORM);
         self.weaponframe_cnt = (time + 1.70000);
         if ( (self.greenmana >= 10.00000) ) {

            self.greenmana -= 10.00000;
         } else {

            self.button0 = FALSE;

         }
         if ( (self.bluemana >= 10.00000) ) {

            self.bluemana -= 10.00000;
         } else {

            self.button0 = FALSE;

         }

      }

   }
   self.th_weapon = setstaff_readyfire;
   if ( ((!self.button0 || (self.greenmana <= 0.00000)) || (self.bluemana <= 0.00000)) ) {

      self.weaponframe_cnt = 0.00000;
      Drilla ( (14.00000 - (14.00000 - self.weaponframe)));
      setstaff_settle ( );

   }
};


void  ()ass_setstaff_fire =  {
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      self.th_weapon = setstaff_powerfire;
   } else {

      self.th_weapon = setstaff_readyfire;

   }
   AdvanceThinkTime(self,0.00000);
   self.nextthink = time;
};


void  ()setstaff_idle =  {
   self.weaponframe = 24.00000;
   self.th_weapon = setstaff_idle;
};


void  ()setstaff_select =  {
   self.wfs = advanceweaponframe ( 43.00000, 32.00000);
   self.weaponmodel = "models/scarabst.mdl";
   self.th_weapon = setstaff_select;
   self.last_attack = time;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      self.attack_finished = (time - 1.00000);
      setstaff_idle ( );

   }
};


void  ()setstaff_deselect =  {
   self.wfs = advanceweaponframe ( 32.00000, 43.00000);
   self.th_weapon = setstaff_deselect;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};


void  ()setstaff_decide_attack =  {
   self.attack_finished = (time + 0.50000);
};

