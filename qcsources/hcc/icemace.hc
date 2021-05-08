
void  ()IceCubeThink =  {
   if ( ((self.freeze_time < time) && (skill < 3.00000)) ) {

      self.th_die ( );
      return ;

   }
   if ( (self.colormap > 144.00000) ) {

      self.colormap -= 1.00000;
      self.abslight -= 0.05000;
   } else {

      self.colormap = 0.00000;
      self.abslight = 0.50000;
      self.skin = GLOBAL_SKIN_ICE;

   }
   if ( ((random() < 0.20000) && (random() < 0.20000)) ) {

      sound ( self, CHAN_AUTO, "misc/drip.wav", 1.00000, ATTN_NORM);

   }
   self.think = IceCubeThink;
   AdvanceThinkTime(self,0.10000);
};


void  (entity loser,entity forwhom)SnowJob =  {
   if ( (loser.solid == SOLID_BSP) ) {

      return ;

   }
   if ( coop ) {

      if ( ((loser.classname == "player") && (forwhom.classname == "player")) ) {

         return ;

      }

   }
   if ( teamplay ) {

      if ( (loser.team == forwhom.team) ) {

         return ;

      }

   }
   if ( ((loser.flags & FL_MONSTER) && (loser.monsterclass >= CLASS_BOSS)) ) {

      T_Damage ( loser, self, forwhom, 10.00000);
      return ;

   }
   sound ( loser, CHAN_BODY, "crusader/frozen.wav", 1.00000, ATTN_NORM);
   loser.frozen = 50.00000;
   loser.oldskin = loser.skin;
   if ( (loser.classname != "player") ) {

      loser.colormap = 159.00000;
      loser.thingtype = THINGTYPE_ICE;
      loser.freeze_time = (time + 5.00000);
      if ( (loser.scale == 0.00000) ) {

         loser.scale = 1.00000;

      }
      loser.lifetime = loser.scale;
      loser.o_angle = loser.mins;
      loser.v_angle = loser.maxs;
      loser.enemy = forwhom;
      loser.oldthink = loser.think;
      loser.think = IceCubeThink;
      AdvanceThinkTime(loser,0.00000);
      loser.touch = SUB_Null;
      loser.th_pain = SUB_Null;
      loser.wait = (time + 3.00000);
      if ( ((loser.angles_x == 0.00000) && (loser.angles_z == 0.00000)) ) {

         loser.drawflags |= SCALE_ORIGIN_BOTTOM;

      }
      loser.oldmovetype = loser.movetype;
      loser.movetype = MOVETYPE_TOSS;
      loser.health = 1.00000;
      loser.deathtype = "ice melt";
      loser.th_die = shatter;
      AwardExperience ( self.enemy, self, self.experience_value);
      self.experience_value = 0.00000;
      SUB_UseTargets ( );
   } else {

      loser.artifact_active |= ARTFLAG_FROZEN;
      loser.colormap = 159.00000;
      loser.thingtype = THINGTYPE_ICE;
      loser.o_angle = loser.v_angle;
      loser.pausetime = (time + 10.00000);
      loser.attack_finished = (time + 10.00000);
      loser.health = 1.00000;
      AdvanceThinkTime(loser,10.00000);

   }
   loser.flags ^= FL_FLY;
   loser.flags ^= FL_SWIM;
   if ( (loser.flags & FL_ONGROUND) ) {

      loser.last_onground = time;

   }
   loser.flags ^= FL_ONGROUND;
   loser.oldtouch = loser.touch;
   loser.touch = obj_push;
   loser.drawflags |= (DRF_TRANSLUCENT | MLS_ABSLIGHT);
   loser.abslight = 1.00000;
};


void  ()FreezeDie =  {
   particleexplosion ( self.origin, 14.00000, 10.00000, 10.00000);
   particle2 ( self.origin, '-10.00000 -10.00000 -10.00000', '10.00000 10.00000 10.00000', 145.00000, 14.00000, 5.00000);
   if ( (self.movechain != world) ) {

      remove ( self.movechain);

   }
   remove ( self);
};


void  ()remove_artflag =  {
   if ( (self.enemy.frozen <= 0.00000) ) {

      self.enemy.artifact_active ^= self.artifact_active;

   }
   remove ( self);
};


void  ()FreezeTouch =  {
   if ( (other == self.owner) ) {

      return ;

   }
   starteffect ( CE_ICE_HIT, (self.origin - (self.movedir * 8.00000)));
   if ( (((other.takedamage && other.health) && (other.frozen <= 0.00000)) && (other.thingtype == THINGTYPE_FLESH)) ) {

      sound ( self, CHAN_BODY, "crusader/icehit.wav", 1.00000, ATTN_NORM);
      if ( (other.frozen <= 0.00000) ) {

         if ( (other.freeze_time <= time) ) {

            other.frozen = 0.00000;

         }
         other.freeze_time = (time + 2.50000);
         other.frozen -= 1.00000;
         if ( (other.classname == "player") ) {

            other.artifact_active |= ARTFLAG_FROZEN;
            newmis = spawn ( );
            newmis.enemy = other;
            newmis.artifact_active = ARTFLAG_FROZEN;
            newmis.think = remove_artflag;
            AdvanceThinkTime(newmis,0.10000);

         }

      }
      if ( (other.flags & FL_COLDHEAL) ) {

         T_Damage ( other, self, self.owner, 3.00000);
      } else {

         if ( ((((((other.health <= 10.00000) || (((other.classname == "player") && (other.frozen <= -5.00000)) && (other.health < 200.00000))) && (other.solid != SOLID_BSP)) && !(other.artifact_active & ART_INVINCIBILITY)) && (other.thingtype == THINGTYPE_FLESH)) && (other.health < 100.00000)) ) {

            SnowJob ( other, self.owner);
         } else {

            T_Damage ( other, self, self.owner, 10.00000);

         }

      }
      self.think = FreezeDie;
      AdvanceThinkTime(self,0.00000);
   } else {

      if ( (other.frozen <= 0.00000) ) {

         sound ( self, CHAN_BODY, "crusader/icewall.wav", 1.00000, ATTN_NORM);
         T_RadiusDamage ( self, self.owner, 30.00000, self.owner);
         self.touch = SUB_Null;
         shatter ( );
      } else {

         sound ( self, CHAN_BODY, "misc/tink.wav", 1.00000, ATTN_NORM);

      }

   }
};


void  ()FireFreeze =  {
local entity corona;
   self.bluemana -= 1.00000;
   self.attack_finished = (time + 0.05000);
   self.punchangle_x = -1.00000;
   makevectors ( self.v_angle);
   sound ( self, CHAN_WEAPON, "crusader/icefire.wav", 1.00000, ATTN_NORM);
   newmis = spawn ( );
   newmis.owner = self;
   newmis.movetype = MOVETYPE_BOUNCEMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.th_die = shatter;
   newmis.deathtype = "ice shatter";
   newmis.touch = FreezeTouch;
   newmis.classname = "snowball";
   newmis.speed = 1200.00000;
   newmis.movedir = normalize ( v_forward);
   newmis.velocity = (newmis.movedir * newmis.speed);
   newmis.angles = vectoangles ( newmis.velocity);
   newmis.avelocity = random('-600.00000 -600.00000 -600.00000','600.00000 600.00000 600.00000');
   setmodel ( newmis, "models/iceshot1.mdl");
   newmis.drawflags = MLS_ABSLIGHT;
   newmis.abslight = 0.50000;
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, ((self.origin + self.proj_ofs) + (v_forward * 8.00000)));
   corona = spawn ( );
   newmis.movechain = corona;
   corona.movetype = MOVETYPE_NOCLIP;
   corona.avelocity = random('-600.00000 -600.00000 -600.00000','600.00000 600.00000 600.00000');
   corona.drawflags = (DRF_TRANSLUCENT | MLS_ABSLIGHT);
   corona.abslight = 0.50000;
   corona.scale = 2.00000;
   setmodel ( corona, "models/iceshot2.mdl");
   setsize ( corona, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( corona, newmis.origin);
};


void  ()shard_hit =  {
   if ( (other.classname == "blizzard shard") ) {

      return ;

   }
   if ( ((other.takedamage && other.health) && (other != self.owner)) ) {

      T_Damage ( other, self, self.owner, (50.00000 * self.scale));

   }
   sound ( self, CHAN_AUTO, "crusader/icewall.wav", 0.10000, ATTN_NORM);
   particleexplosion ( self.origin, 14.00000, 20.00000, 5.00000);
   remove ( self);
};


void  ()FireShard =  {
local vector org = '0.00000 0.00000 0.00000';
local vector dir = '0.00000 0.00000 0.00000';
   newmis = spawn ( );
   newmis.movetype = MOVETYPE_BOUNCE;
   newmis.solid = SOLID_TRIGGER;
   newmis.owner = self.owner;
   dir_x = random(50.00000,100.00000);
   dir_y = random(50.00000,100.00000);
   dir_z = random(-250.00000,-180.00000);
   org_x = random(-84.00000,-8.00000);
   org_y = random(-84.00000,-8.00000);
   if ( (org_x < 64.00000) ) {

      org_z = (64.00000 + org_x);
   } else {

      if ( (org_y < 64.00000) ) {

         org_z = (64.00000 + org_y);

      }

   }
   org_x += self.origin_x;
   org_y += self.origin_y;
   org_z += (self.origin_z + 64.00000);
   traceline ( self.origin, org, TRUE, self);
   org = trace_endpos;
   newmis.velocity = dir;
   newmis.angles = (vectoangles ( newmis.velocity) + '90.00000 0.00000 0.00000');
   newmis.scale = random(0.05000,0.55000);
   newmis.skin = 0.00000;
   newmis.frame = 0.00000;
   newmis.touch = shard_hit;
   setmodel ( newmis, "models/shard.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, org);
};


void  ()blizzard_think =  {
local entity loser;
local vector dir = '0.00000 0.00000 0.00000';
local vector top = '0.00000 0.00000 0.00000';
local vector bottom = '0.00000 0.00000 0.00000';
local vector beam_angle = '0.00000 0.00000 0.00000';
local float beam_count = 0.00000;
   if ( ((self.lifetime < time) || (self.blizzcount < (self.owner.blizzcount - 1.00000))) ) {

      remove ( self);
      return ;

   }
   self.color = random(15.00000);
   self.color = ((rint ( self.color) + (9.00000 * 16.00000)) + 256.00000);
   dir_x = random(-100.00000,100.00000);
   dir_y = random(-100.00000,100.00000);
   top = '0.00000 0.00000 128.00000';
   top_y = (self.level + 1.00000);
   top_x = (self.level + 1.00000);
   rain_go ( (self.origin - top), (self.origin + top), (top * 2.00000), dir, self.color, 77.00000);
   if ( (self.t_width < time) ) {

      sound ( self, CHAN_WEAPON, "crusader/blizzard.wav", 1.00000, ATTN_NORM);
      self.t_width = (time + 0.70000);

   }
   if ( (self.level < 128.00000) ) {

      self.level += 8.00000;

   }
   makevectors ( self.angles);
   beam_count = 6.00000;
   while ( beam_count ) {

      beam_angle = self.angles;
      beam_angle_y = (self.angles_y + (60.00000 * (6.00000 - beam_count)));
      makevectors ( beam_angle);
      traceline ( self.origin, (self.origin + (v_forward * self.level)), TRUE, self);
      dir = (trace_endpos - (v_forward * 8.00000));
      traceline ( dir, (dir + '0.00000 0.00000 128.00000'), TRUE, self);
      top = trace_endpos;
      traceline ( dir, (dir - '0.00000 0.00000 128.00000'), TRUE, self);
      bottom = trace_endpos;
      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte ( MSG_BROADCAST, TE_STREAM_ICECHUNKS);
      WriteEntity ( MSG_BROADCAST, self);
      WriteByte ( MSG_BROADCAST, (beam_count + STREAM_ATTACHED));
      WriteByte ( MSG_BROADCAST, 2.00000);
      WriteCoord ( MSG_BROADCAST, top_x);
      WriteCoord ( MSG_BROADCAST, top_y);
      WriteCoord ( MSG_BROADCAST, top_z);
      WriteCoord ( MSG_BROADCAST, bottom_x);
      WriteCoord ( MSG_BROADCAST, bottom_y);
      WriteCoord ( MSG_BROADCAST, bottom_z);
      beam_count -= 1.00000;
      traceline ( top, bottom, FALSE, self.owner);
      if ( ((trace_ent.takedamage && (trace_ent.frozen <= 0.00000)) && (trace_ent.solid != SOLID_BSP)) ) {

         trace_ent.frozen -= 1.00000;
         if ( (((((trace_ent.frozen < -5.00000) || (trace_ent.health <= 10.00000)) && !(trace_ent.artifact_active & ART_INVINCIBILITY)) && (trace_ent.thingtype == THINGTYPE_FLESH)) && (trace_ent.health < 100.00000)) ) {

            SnowJob ( trace_ent, self.owner);
         } else {

            T_Damage ( trace_ent, self, self.owner, 10.00000);

         }

      }

   }
   if ( (random() < 0.30000) ) {

      self.velocity = random('-200.00000 -200.00000 0.00000','200.00000 200.00000 0.00000');

   }
   self.avelocity_y = 500.00000;
   self.flags ^= FL_ONGROUND;
   loser = findradius ( self.origin, self.level);
   while ( loser ) {

      if ( ((((loser.takedamage && loser.health) && (loser.frozen <= 0.00000)) && (loser != self.owner)) && (loser.solid != SOLID_BSP)) ) {

         if ( (loser.flags & FL_COLDHEAL) ) {

            T_Damage ( loser, self, self.owner, 1.00000);
         } else {

            if ( (random() < 0.10000) ) {

               loser.frozen -= 1.00000;

            }
            if ( ((((((loser.frozen < -5.00000) || (loser.health < 15.00000)) && (loser.classname != "mjolnir")) && !(loser.artifact_active & ART_INVINCIBILITY)) && (loser.thingtype == THINGTYPE_FLESH)) && (loser.health < 100.00000)) ) {

               SnowJob ( loser, self.owner);
            } else {

               T_Damage ( loser, self, self.owner, 5.00000);

            }

         }

      }
      loser = loser.chain;

   }
   AdvanceThinkTime(self,0.10000);
};


void  ()make_blizzard =  {
local entity found;
   if ( ((((other.frozen <= 0.00000) && !(other.artifact_active & ART_INVINCIBILITY)) && (other.thingtype == THINGTYPE_FLESH)) && (other.health < 100.00000)) ) {

      SnowJob ( other, self.owner);

   }
   found = findradius ( self.origin, 256.00000);
   while ( found ) {

      if ( ((found.flags & FL_CLIENT) && (found != self.owner)) ) {

         found.artifact_active |= ARTFLAG_DIVINE_INTERVENTION;
         found.divine_time = (time + HX_FRAME_TIME);

      }
      found = found.chain;

   }
   self.touch = SUB_Null;
   self.velocity = random('-200.00000 -200.00000 0.00000','200.00000 200.00000 0.00000');
   self.movetype = MOVETYPE_FLY;
   self.solid = SOLID_NOT;
   self.classname = "blizzard";
   self.angles_y = other.angles_y;
   self.avelocity_y = 500.00000;
   self.lifetime = (time + 10.00000);
   self.think = blizzard_think;
   AdvanceThinkTime(self,0.00000);
   setmodel ( self, "models/null.spr");
   setsize ( self, '-32.00000 -32.00000 -32.00000', '32.00000 32.00000 32.00000');
   self.hull = HULL_GOLEM;
   if ( other.takedamage ) {

      setorigin ( self, ((other.absmax + other.absmin) * 0.50000));

   }
};


void  ()sparkle =  {
   particle2 ( self.origin, '-3.00000 -3.00000 -3.00000', '3.00000 3.00000 3.00000', (144.00000 + random(15.00000)), 2.00000, 20.00000);
   particle2 ( self.origin, '-1.00000 -1.00000 -1.00000', '1.00000 1.00000 1.00000', (24.00000 + random(7.00000)), 3.00000, 10.00000);
   self.think = sparkle;
   AdvanceThinkTime(self,0.01000);
};


void  ()FireBlizzard =  {
   self.attack_finished = (time + 1.00000);
   self.bluemana -= 10.00000;
   sound ( self, CHAN_WEAPON, "crusader/blizfire.wav", 1.00000, ATTN_NORM);
   newmis = spawn ( );
   newmis.owner = self;
   self.blizzcount += 1.00000;
   newmis.blizzcount = self.blizzcount;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.touch = make_blizzard;
   newmis.velocity = (normalize ( v_forward) * 1000.00000);
   newmis.effects = EF_MUZZLEFLASH;
   newmis.think = sparkle;
   AdvanceThinkTime(newmis,0.00000);
   setmodel ( newmis, "models/null.spr");
   newmis.effects |= EF_NODRAW;
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, ((self.origin + self.proj_ofs) + (v_forward * 16.00000)));
};

void  ()Cru_Ice_Fire;

void  ()icestaff_idle =  {
   self.th_weapon = icestaff_idle;
   self.wfs = advanceweaponframe ( 15.00000, 30.00000);
};


void  ()icestaff_select =  {
   self.th_weapon = icestaff_select;
   self.wfs = advanceweaponframe ( 40.00000, 49.00000);
   self.weaponmodel = "models/icestaff.mdl";
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      self.attack_finished = (time - 1.00000);
      icestaff_idle ( );

   }
};


void  ()icestaff_deselect =  {
   self.wfs = advanceweaponframe ( 49.00000, 40.00000);
   self.th_weapon = icestaff_deselect;
   if ( (self.wfs == WF_LAST_FRAME) ) {

      W_SetCurrentAmmo ( );

   }
};

void  ()icestaff_shard;

void  ()icestaff_blizzard =  {
   self.th_weapon = icestaff_blizzard;
   self.wfs = advanceweaponframe ( 31.00000, 39.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      icestaff_idle ( );
   } else {

      if ( (self.weaponframe == 31.00000) ) {

         if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

            FireBlizzard ( );
         } else {

            icestaff_shard ( );

         }

      }

   }
};


void  ()icestaff_f1 =  {
   self.th_weapon = icestaff_f1;
   self.wfs = advanceweaponframe ( 0.00000, 2.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      if ( !self.button0 ) {

         icestaff_idle ( );
      } else {

         icestaff_shard ( );

      }
   } else {

      if ( ((self.attack_finished <= time) && (self.weaponframe == 0.00000)) ) {

         if ( ((self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 10.00000)) ) {

            icestaff_blizzard ( );
         } else {

            if ( (!(self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 1.00000)) ) {

               FireFreeze ( );
            } else {

               icestaff_idle ( );

            }

         }

      }

   }
};


void  ()icestaff_f2 =  {
   self.th_weapon = icestaff_f2;
   self.wfs = advanceweaponframe ( 3.00000, 5.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      if ( !self.button0 ) {

         icestaff_idle ( );
      } else {

         icestaff_shard ( );

      }
   } else {

      if ( ((self.attack_finished <= time) && (self.weaponframe == 3.00000)) ) {

         if ( ((self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 10.00000)) ) {

            icestaff_blizzard ( );
         } else {

            if ( (!(self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 1.00000)) ) {

               FireFreeze ( );
            } else {

               icestaff_idle ( );

            }

         }

      }

   }
};


void  ()icestaff_f3 =  {
   self.th_weapon = icestaff_f3;
   self.wfs = advanceweaponframe ( 6.00000, 8.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      if ( !self.button0 ) {

         icestaff_idle ( );
      } else {

         icestaff_shard ( );

      }
   } else {

      if ( ((self.attack_finished <= time) && (self.weaponframe == 6.00000)) ) {

         if ( ((self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 10.00000)) ) {

            icestaff_blizzard ( );
         } else {

            if ( (!(self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 1.00000)) ) {

               FireFreeze ( );
            } else {

               icestaff_idle ( );

            }

         }

      }

   }
};


void  ()icestaff_f4 =  {
   self.th_weapon = icestaff_f4;
   self.wfs = advanceweaponframe ( 9.00000, 11.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      if ( !self.button0 ) {

         icestaff_idle ( );
      } else {

         icestaff_shard ( );

      }
   } else {

      if ( ((self.attack_finished <= time) && (self.weaponframe == 9.00000)) ) {

         if ( ((self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 10.00000)) ) {

            icestaff_blizzard ( );
         } else {

            if ( (!(self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 1.00000)) ) {

               FireFreeze ( );
            } else {

               icestaff_idle ( );

            }

         }

      }

   }
};


void  ()icestaff_f5 =  {
   self.th_weapon = icestaff_f5;
   self.wfs = advanceweaponframe ( 12.00000, 14.00000);
   if ( (self.wfs == WF_CYCLE_WRAPPED) ) {

      if ( !self.button0 ) {

         icestaff_idle ( );
      } else {

         icestaff_shard ( );

      }
   } else {

      if ( ((self.attack_finished <= time) && (self.weaponframe == 12.00000)) ) {

         if ( ((self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 10.00000)) ) {

            icestaff_blizzard ( );
         } else {

            if ( (!(self.artifact_active & ART_TOMEOFPOWER) && (self.bluemana >= 1.00000)) ) {

               FireFreeze ( );
            } else {

               icestaff_idle ( );

            }

         }

      }

   }
};


void  ()icestaff_shard =  {
local float r = 0.00000;
   r = (rint ( random(4.00000)) + 1.00000);
   if ( (r == 1.00000) ) {

      icestaff_f1 ( );
   } else {

      if ( (r == 2.00000) ) {

         icestaff_f2 ( );
      } else {

         if ( (r == 3.00000) ) {

            icestaff_f3 ( );
         } else {

            if ( (r == 4.00000) ) {

               icestaff_f4 ( );
            } else {

               icestaff_f5 ( );

            }

         }

      }

   }
};


void  ()Cru_Ice_Fire =  {
   if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

      icestaff_blizzard ( );
   } else {

      icestaff_shard ( );

   }
};

