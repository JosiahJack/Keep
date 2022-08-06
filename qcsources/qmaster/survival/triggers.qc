entity stemp;
entity otemp;
entity s;
entity old;

void () trigger_reactivate = {

   self.solid = SOLID_TRIGGER;

};
float SPAWNFLAG_NOMESSAGE    = 1.000;
float SPAWNFLAG_NOTOUCH    = 1.000;

void () multi_wait = {

   if ( self.max_health ) {

      self.health = self.max_health;
      self.takedamage = DAMAGE_YES;
      self.solid = SOLID_BBOX;

   }

};

void () multi_trigger = {

   if ( (self.nextthink > time) ) {

      return ;

   }
   if ( (self.classname == "trigger_secret") ) {

      if ( (self.enemy.classname != "player") ) {

         return ;

      }
      found_secrets = (found_secrets + TRUE);
      WriteByte (MSG_ALL,SVC_FOUNDSECRET);

   }
   if ( self.noise ) {

      sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);

   }
   self.takedamage = DAMAGE_NO;
   activator = self.enemy;
   SUB_UseTargets ();
   if ( (self.wait > FALSE) ) {

      self.think = multi_wait;
      self.nextthink = (time + self.wait);

   } else {

      self.touch = SUB_Null;
      self.nextthink = (time + 0.100);
      self.think = SUB_Remove;

   }

};

void () multi_killed = {

   self.enemy = damage_attacker;
   multi_trigger ();

};

void () multi_use = {

   self.enemy = activator;
   multi_trigger ();

};

void () multi_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (self.movedir != VEC_ORIGIN) ) {

      makevectors (other.angles);
      if ( ((v_forward * self.movedir) < FALSE) ) {

         return ;

      }

   }
   self.enemy = other;
   multi_trigger ();

};

void () trigger_multiple = {

   if ( (self.sounds == TRUE) ) {

      precache_sound ("misc/secret.wav");
      self.noise = "misc/secret.wav";

   } else {

      if ( (self.sounds == FL_SWIM) ) {

         precache_sound ("misc/talk.wav");
         self.noise = "misc/talk.wav";

      } else {

         if ( (self.sounds == MOVETYPE_WALK) ) {

            precache_sound ("misc/trigger1.wav");
            self.noise = "misc/trigger1.wav";

         }

      }

   }
   if ( !self.wait ) {

      self.wait = 0.200;

   }
   self.use = multi_use;
   InitTrigger ();
   if ( self.health ) {

      if ( (self.spawnflags & SPAWNFLAG_NOTOUCH) ) {

         objerror ("health and notouch don't make sense\n");

      }
      self.max_health = self.health;
      self.th_die = multi_killed;
      self.takedamage = DAMAGE_YES;
      self.solid = SOLID_BBOX;
      setorigin (self,self.origin);

   } else {

      if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) ) {

         self.touch = multi_touch;

      }

   }

};

void () trigger_once = {

   self.wait = CONTENT_EMPTY;
   trigger_multiple ();

};

void () trigger_relay = {

   self.use = SUB_UseTargets;

};

void () trigger_secret = {

   total_secrets = (total_secrets + TRUE);
   self.wait = CONTENT_EMPTY;
   if ( !self.message ) {

      self.message = "You found a secret area!";

   }
   if ( !self.sounds ) {

      self.sounds = TRUE;

   }
   if ( (self.sounds == TRUE) ) {

      precache_sound ("misc/secret.wav");
      self.noise = "misc/secret.wav";

   } else {

      if ( (self.sounds == FL_SWIM) ) {

         precache_sound ("misc/talk.wav");
         self.noise = "misc/talk.wav";

      }

   }
   trigger_multiple ();

};

void () counter_use = {

   local string junk;

   self.count = (self.count - TRUE);
   if ( (self.count < FALSE) ) {

      return ;

   }
   if ( (self.count != FALSE) ) {

      if ( ((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == FALSE)) ) {

         if ( (self.count >= MOVETYPE_STEP) ) {

            centerprint (activator,"There are more to go...");

         } else {

            if ( (self.count == MOVETYPE_WALK) ) {

               centerprint (activator,"Only 3 more to go...");

            } else {

               if ( (self.count == FL_SWIM) ) {

                  centerprint (activator,"Only 2 more to go...");

               } else {

                  centerprint (activator,"Only 1 more to go...");

               }

            }

         }

      }
      return ;

   }
   if ( ((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == FALSE)) ) {

      centerprint (activator,"Sequence completed!");

   }
   self.enemy = activator;
   multi_trigger ();

};

void () trigger_counter = {

   self.wait = CONTENT_EMPTY;
   if ( !self.count ) {

      self.count = FL_SWIM;

   }
   self.use = counter_use;

};
float PLAYER_ONLY    = 1.000;
float SILENT    = 2.000;

void () play_teleport = {

   local float v;
   local string tmpstr;

   v = (random () * MOVETYPE_FLY);
   if ( (v < TRUE) ) {

      tmpstr = "misc/r_tele1.wav";

   } else {

      if ( (v < FL_SWIM) ) {

         tmpstr = "misc/r_tele2.wav";

      } else {

         if ( (v < MOVETYPE_WALK) ) {

            tmpstr = "misc/r_tele3.wav";

         } else {

            if ( (v < MOVETYPE_STEP) ) {

               tmpstr = "misc/r_tele4.wav";

            } else {

               tmpstr = "misc/r_tele5.wav";

            }

         }

      }

   }
   sound (self,CHAN_VOICE,tmpstr,TRUE,ATTN_NORM);
   remove (self);

};

void (vector org) spawn_tfog = {

   s = spawn ();
   s.origin = org;
   s.nextthink = (time + 0.200);
   s.think = play_teleport;
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_TELEPORT);
   WriteCoord (MSG_BROADCAST,org_x);
   WriteCoord (MSG_BROADCAST,org_y);
   WriteCoord (MSG_BROADCAST,org_z);

};

void () tdeath_touch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.classname == "player") ) {

      if ( (other.invincible_finished > time) ) {

         self.classname = "teledeath2";

      }
      if ( (self.owner.classname != "player") ) {

         T_Damage (self.owner,self,self,50000.000);
         return ;

      }

   }
   if ( other.health ) {

      T_Damage (other,self,self,50000.000);

   }

};

void (vector org, entity death_owner) spawn_tdeath = {

   local entity death;

   death = spawn ();
   death.classname = "teledeath";
   death.movetype = MOVETYPE_NONE;
   death.solid = SOLID_TRIGGER;
   death.angles = VEC_ORIGIN;
   setsize (death,(death_owner.mins - '1.000 1.000 1.000'),(death_owner.maxs + '1.000 1.000 1.000'));
   setorigin (death,org);
   death.touch = tdeath_touch;
   death.nextthink = (time + 0.200);
   death.think = SUB_Remove;
   death.owner = death_owner;
   force_retouch = FL_SWIM;

};

void () teleport_touch = {

   local entity t;
   local vector org;

   if ( self.targetname ) {

      if ( (self.nextthink < time) ) {

         return ;

      }

   }
   if ( (self.spawnflags & PLAYER_ONLY) ) {

      if ( (other.classname != "player") ) {

         return ;

      }

   }
   if ( ((other.health <= FALSE) || (other.solid != SOLID_SLIDEBOX)) ) {

      return ;

   }
   SUB_UseTargets ();
   spawn_tfog (other.origin);
   t = find (world,targetname,self.target);
   if ( !t ) {

      objerror ("couldn't find target");

   }
   makevectors (t.mangle);
   org = (t.origin + (FL_MONSTER * v_forward));
   spawn_tfog (org);
   spawn_tdeath (t.origin,other);
   if ( !other.health ) {

      other.origin = t.origin;
      other.velocity = ((v_forward * other.velocity_x) + (v_forward * other.velocity_y));
      return ;

   }
   setorigin (other,t.origin);
   other.angles = t.mangle;
   if ( (other.classname == "player") ) {

      other.fixangle = TRUE;
      other.teleport_time = (time + 0.700);
      if ( (other.flags & FL_ONGROUND) ) {

         other.flags = (other.flags - FL_ONGROUND);

      }
      other.velocity = (v_forward * 300.000);

   }
   other.flags = (other.flags - (other.flags & FL_ONGROUND));

};

void () info_teleport_destination = {

   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.model = "";
   self.origin = (self.origin + '0.000 0.000 27.000');
   if ( !self.targetname ) {

      objerror ("no targetname");

   }

};

void () teleport_use = {

   self.nextthink = (time + 0.200);
   force_retouch = FL_SWIM;
   self.think = SUB_Null;

};

void () trigger_teleport = {

   local vector o;

   InitTrigger ();
   self.touch = teleport_touch;
   if ( !self.target ) {

      objerror ("no target");

   }
   self.use = teleport_use;
   if ( !(self.spawnflags & SILENT) ) {

      precache_sound ("ambience/hum1.wav");
      o = ((self.mins + self.maxs) * 0.500);
      ambientsound (o,"ambience/hum1.wav",0.500,ATTN_STATIC);

   }

};

void () trigger_skill_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   cvar_set ("skill",self.message);

};

void () trigger_setskill = {

   InitTrigger ();
   self.touch = trigger_skill_touch;

};

void () trigger_onlyregistered_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (self.attack_finished > time) ) {

      return ;

   }
   self.attack_finished = (time + FL_SWIM);
   if ( cvar ("registered") ) {

      self.message = "";
      SUB_UseTargets ();
      remove (self);

   } else {

      if ( (self.message != "") ) {

         centerprint (other,self.message);
         sound (other,CHAN_BODY,"misc/talk.wav",TRUE,ATTN_NORM);

      }

   }

};

void () trigger_onlyregistered = {

   precache_sound ("misc/talk.wav");
   InitTrigger ();
   self.touch = trigger_onlyregistered_touch;

};

void () hurt_on = {

   self.solid = SOLID_TRIGGER;
   self.nextthink = CONTENT_EMPTY;

};

void () hurt_touch = {

   local string str1;
   local float tempheal;

   if ( coop ) {

      if ( (other.flags & FL_MONSTER) ) {

         return ;

      }

   }
   if ( other.takedamage ) {

      self.solid = SOLID_NOT;
      if ( (self.dmg < FALSE) ) {

         if ( (other.health > 99.000) ) {

            sprint (other,"The Aura detects sufficient health\n");
            self.think = hurt_on;
            self.nextthink = (time + TRUE);
            return ;

         } else {

            if ( (other.health < 75) ) {

               tempheal = (self.dmg * CONTENT_EMPTY);
               other.health = (other.health + tempheal);
               sprint (other,"You are healed ");
               str1 = ftos (tempheal);
               sprint (other,str1);
               sprint (other," by the Aura of Restoration\n");
               sound (other,CHAN_ITEM,"items/r_item1.wav",TRUE,ATTN_NORM);
               stuffcmd (other,"bf\n");

            } else {

               tempheal = (100.000 - other.health);
               other.health = (other.health + tempheal);
               sprint (other,"You are healed fully by the Aura of Restoration\n");
               sound (other,CHAN_ITEM,"items/r_item1.wav",TRUE,ATTN_NORM);
               stuffcmd (other,"bf\n");

            }

         }

      } else {

         T_Damage (other,self,self,self.dmg);

      }
      self.think = hurt_on;
      self.nextthink = (time + TRUE);

   }
   return ;

};

void () trigger_hurt = {

   InitTrigger ();
   precache_sound ("items/r_item1.wav");
   self.touch = hurt_touch;
   if ( !self.dmg ) {

      self.dmg = MOVETYPE_FLY;

   }

};
float PUSH_ONCE    = 1.000;

void () trigger_push_touch = {

   if ( (other.classname == "grenade") ) {

      other.velocity = ((self.speed * self.movedir) * MOVETYPE_BOUNCE);

   } else {

      if ( (other.health > FALSE) ) {

         other.velocity = ((self.speed * self.movedir) * MOVETYPE_BOUNCE);
         if ( (other.classname == "player") ) {

            if ( (other.fly_sound < time) ) {

               other.fly_sound = (time + 1.500);
               sound (other,CHAN_AUTO,"ambience/windfly.wav",TRUE,ATTN_NORM);

            }

         }

      }

   }
   if ( (self.spawnflags & PUSH_ONCE) ) {

      remove (self);

   }

};

void () trigger_push = {

   InitTrigger ();
   precache_sound ("ambience/windfly.wav");
   self.touch = trigger_push_touch;
   if ( !self.speed ) {

      self.speed = 1000.000;

   }

};

void () trigger_monsterjump_touch = {

   if ( ((other.flags & ((FL_MONSTER | FL_FLY) | FL_SWIM)) != FL_MONSTER) ) {

      return ;

   }
   other.velocity_x = (self.movedir_x * self.speed);
   other.velocity_y = (self.movedir_y * self.speed);
   if ( !(other.flags & FL_ONGROUND) ) {

      return ;

   }
   other.flags = (other.flags - FL_ONGROUND);
   other.velocity_z = self.height;

};

void () trigger_monsterjump = {

   if ( !self.speed ) {

      self.speed = 200.000;

   }
   if ( !self.height ) {

      self.height = 200.000;

   }
   if ( (self.angles == VEC_ORIGIN) ) {

      self.angles = '0.000 360.000 0.000';

   }
   InitTrigger ();
   self.touch = trigger_monsterjump_touch;

};

void () trigger_monsteronly_touch = {

   if ( ((other.flags & FL_MONSTER) != FL_MONSTER) ) {

      return ;

   }
   self.enemy = activator;
   multi_trigger ();

};

void () trigger_monsteronly = {

   InitTrigger ();
   self.touch = trigger_monsteronly_touch;

};
