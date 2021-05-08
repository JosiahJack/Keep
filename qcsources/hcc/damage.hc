void  ()T_MissileTouch;
void  ()info_player_start;
void  (entity ent)necromancer_sphere;
void  (entity ent)crusader_sphere;
void  ()monster_death_use;
void  ()player_pain;
void  ()PlayerDie;
void  ()MonsterDropStuff;
void  ()Use_TeleportCoin;
void  ()UseInvincibility;
void  ()Use_TomeofPower;
void  ()use_super_healthboost;
float ClassArmorProtection [16]   = { 0.05000,
    0.10000,    0.25000,    0.15000,    0.15000,
    0.05000,    0.10000,    0.25000,    0.25000,
    0.15000,    0.05000,    0.10000,    0.10000,
    0.15000,    0.25000,    0.05000};

float  (entity targ,entity inflictor)CanDamage =  {
local vector inflictor_org = '0.00000 0.00000 0.00000';
local vector targ_org = '0.00000 0.00000 0.00000';
local vector ofs = '0.00000 0.00000 0.00000';
local float targ_rad = 0.00000;
local float loop_cnt = 0.00000;
   if ( (inflictor.flags2 & FL_ALIVE) ) {

      inflictor_org = (inflictor.origin + inflictor.proj_ofs);
   } else {

      inflictor_org = ((inflictor.absmin + inflictor.absmax) * 0.50000);

   }
   targ_org = ((targ.absmin + targ.absmax) * 0.50000);
   targ_rad = 15.00000;
   if ( (targ.movetype == MOVETYPE_PUSH) ) {

      traceline ( inflictor_org, targ_org, TRUE, self);
      if ( (trace_fraction == 1.00000) ) {

         return ( TRUE );

      }
      if ( (trace_ent == targ) ) {

         return ( TRUE );

      }
      return ( FALSE );

   }
   ofs = '0.00000 0.00000 0.00000';
   loop_cnt = 5.00000;
   while ( loop_cnt ) {

      if ( (loop_cnt != 5.00000) ) {

         if ( (loop_cnt < 3.00000) ) {

            ofs_x = (targ_rad * -1.00000);
         } else {

            ofs_x = targ_rad;

         }
         if ( ((loop_cnt == 3.00000) || (loop_cnt == 2.00000)) ) {

            ofs_y = (targ_rad * -1.00000);
         } else {

            ofs_y = targ_rad;

         }

      }
      traceline ( inflictor_org, (targ_org + ofs), TRUE, self);
      if ( (trace_fraction == 1.00000) ) {

         return ( TRUE );

      }
      loop_cnt -= 1.00000;

   }
   return ( FALSE );
};


entity  ()FindExpLeader =  {
local entity lastent;
local entity leader;
local float top_exp = 0.00000;
   lastent = nextent ( world);
   num_players = 0.00000;
   while ( lastent ) {

      if ( (lastent.classname == "player") ) {

         num_players += 1.00000;
         if ( (lastent.experience > top_exp) ) {

            leader = lastent;
            top_exp = leader.experience;

         }

      }
      lastent = find ( lastent, classname, "player");

   }
   return ( leader );
};


float  ()Pal_DivineIntervention =  {
local float chance = 0.00000;
   if ( (self.level < 6.00000) ) {

      return ( FALSE );

   }
   chance = (self.level * 0.02000);
   if ( (chance > 0.20000) ) {

      chance = 0.20000;

   }
   if ( (chance < random()) ) {

      return ( FALSE );

   }
   centerprint ( self, "Your God has saved your mortal body!");
   self.health = self.max_health;
   self.cnt_teleport += 1.00000;
   Use_TeleportCoin ( );
   self.cnt_invincibility += 1.00000;
   UseInvincibility ( );
   self.invincible_time = (time + 5.00000);
   self.cnt_tome += 1.00000;
   Use_TomeofPower ( );
   self.artifact_active |= ARTFLAG_DIVINE_INTERVENTION;
   self.divine_time = (time + HX_FRAME_TIME);
   sound ( self, CHAN_BODY, "paladin/devine.wav", 1.00000, ATTN_NORM);
   return ( TRUE );
};


void  (entity targ,entity attacker,entity inflictor)Killed =  {
local entity oself;
local float exp_bonus = 0.00000;
local entity lastleader;
   oself = self;
   self = targ;
   if ( !(self.flags2 & FL_ALIVE) ) {

      if ( ((self.movetype == MOVETYPE_PUSH) || (self.movetype == MOVETYPE_NONE)) ) {

         if ( self.th_die ) {

            self.th_die ( );

         }
         self = oself;
         return ;

      }

   }
   self.flags2 ^= FL_ALIVE;
   self.th_pain = SUB_Null;
   self.touch = SUB_Null;
   if ( (attacker.classname == "player") ) {

      if ( ((attacker.playerclass == CLASS_NECROMANCER) && (attacker.level >= 3.00000)) ) {

         if ( ((targ.flags & FL_MONSTER) || (targ.flags & FL_CLIENT)) ) {

            necromancer_sphere ( attacker);

         }
      } else {

         if ( ((attacker.playerclass == CLASS_CRUSADER) && (attacker.level >= 3.00000)) ) {

            if ( ((targ.flags & FL_MONSTER) || (targ.flags & FL_CLIENT)) ) {

               crusader_sphere ( attacker);

            }

         }

      }

   }
   self.movedir = '0.00000 0.00000 0.00000';
   if ( (((((self.model != "models/sheep.mdl") && (self.deathtype != "teledeath")) && (self.deathtype != "teledeath2")) && (self.deathtype != "teledeath3")) && (self.deathtype != "teledeath4")) ) {

      if ( ((inflictor.classname == "ax_blade") || ((inflictor.classname == "player") && ((((attacker.playerclass == CLASS_ASSASSIN) && (attacker.weapon == IT_WEAPON1)) || ((attacker.playerclass == CLASS_PALADIN) && (attacker.weapon < IT_WEAPON4))) || ((attacker.playerclass == CLASS_NECROMANCER) && (attacker.weapon == IT_WEAPON1))))) ) {

         if ( ((random() < 0.30000) || (self.classname == "monster_medusa")) ) {

            self.decap = 2.00000;
         } else {

            self.decap = TRUE;

         }
      } else {

         if ( (((vlen ( ((inflictor.origin - self.origin) + self.view_ofs)) <= 17.00000) && (self.health >= -40.00000)) && (self.health < -10.00000)) ) {

            if ( (random() < 0.40000) ) {

               self.movedir = normalize ( ((self.origin + self.view_ofs) - inflictor.origin));
               self.decap = 2.00000;

            }

         }

      }

   }
   if ( ((self.skin == GLOBAL_SKIN_STONE) || (self.frozen > 0.00000)) ) {

      if ( (self.classname != "player") ) {

         self.th_die = shatter;

      }
      AdvanceThinkTime(self,0.00000);
      self.attack_finished = time;
      self.pausetime = time;
      self.teleport_time = time;
      if ( (self.frozen > 0.00000) ) {

         self.deathtype = "ice shatter";
      } else {

         if ( (self.skin == GLOBAL_SKIN_STONE) ) {

            self.deathtype = "stone crumble";

         }

      }

   }
   if ( (self.classname == "player") ) {

      ClientObituary ( self, attacker, inflictor);

   }
   if ( (attacker.deadflag < DEAD_DYING) ) {

      if ( ((attacker.model == "models/sheep.mdl") && (attacker.flags & FL_CLIENT)) ) {

         sound ( attacker, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NORM);
         centerprint ( attacker, "Sheep kill BONUS!!!\n");
         exp_bonus = 3000.00000;

      }
      if ( deathmatch ) {

         if ( (self.classname == "player") ) {

            self.experience_value = (((self.level * 800.00000) - 500.00000) * exp_mult);

         }
         if ( (attacker.flags & FL_CLIENT) ) {

            attacker.level_frags += self.level;
            lastleader = FindExpLeader ( );
            if ( ((lastleader == targ) && (attacker != targ)) ) {

               sound ( world, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NONE);
               bprint ( attacker.netname);
               bprint ( " took out the King of the Hill (");
               bprint ( targ.netname);
               bprint ( ")!!!\n");
               targ.experience_value += (500.00000 * (num_players - 2.00000));

            }
            if ( ((attacker.level < targ.level) || (attacker == targ)) ) {

               drop_level ( targ, 1.00000);

            }
            if ( (attacker != targ) ) {

               AwardExperience ( attacker, self, (self.experience_value + exp_bonus));

            }
            if ( (FindExpLeader ( ) != lastleader) ) {

               sound ( world, CHAN_BODY, "misc/comm.wav", 1.00000, ATTN_NONE);
               bprint ( attacker.netname);
               bprint ( " is the NEW King of the Hill!\n");

            }

         }
      } else {

         if ( (((self.classname == "player") && (attacker.classname == "player")) && ((coop || teamplay) && (attacker.team == self.team))) ) {

            drop_level ( attacker, 1.00000);
         } else {

            if ( ((attacker.flags & FL_CLIENT) && (attacker != self.controller)) ) {

               AwardExperience ( attacker, self, (self.experience_value + exp_bonus));

            }

         }

      }

   }
   self.enemy = attacker;
   if ( (self.flags & FL_MONSTER) ) {

      MonsterDropStuff ( );
      killed_monsters = (killed_monsters + 1.00000);
      WriteByte ( MSG_ALL, SVC_KILLEDMONSTER);
      monster_death_use ( );
      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');
   } else {

      if ( self.target ) {

         SUB_UseTargets ( );

      }

   }
   self.th_missile = SUB_Null;
   self.th_melee = SUB_Null;
   self.think = SUB_Null;
   self.oldthink = SUB_Null;
   self.th_pain = SUB_Null;
   self.th_run = SUB_Null;
   self.th_walk = SUB_Null;
   self.th_stand = SUB_Null;
   if ( (pointcontents ( (self.origin + self.view_ofs)) == CONTENT_WATER) ) {

      DeathBubbles ( 20.00000);

   }
   if ( (attacker.classname == "rider_death") ) {

      spawn_ghost ( attacker);

   }
   if ( (oself != targ) ) {

      if ( (self.classname == "player") ) {

         PlayerDie ( );
      } else {

         if ( self.th_die ) {

            self.th_die ( );

         }

      }
      self = oself;
   } else {

      if ( (self.classname == "player") ) {

         self.think = PlayerDie;
      } else {

         if ( self.th_die ) {

            self.think = self.th_die;

         }

      }
      AdvanceThinkTime(self,0.00000);

   }
   if ( (self.health < -99.00000) ) {

      self.health = -99.00000;

   }
};


void  (entity attacker)monster_pissed =  {
   if ( (self.enemy.classname == "player") ) {

      self.oldenemy = self.enemy;

   }
   self.enemy = attacker;
   self.goalentity = self.enemy;
   if ( self.th_walk ) {

      FoundTarget ( );

   }
};


float  (entity victim)armor_inv =  {
local float armor_cnt = 0.00000;
   armor_cnt = 0.00000;
   if ( victim.armor_amulet ) {

      armor_cnt += 1.00000;

   }
   if ( victim.armor_bracer ) {

      armor_cnt += 1.00000;

   }
   if ( victim.armor_breastplate ) {

      armor_cnt += 1.00000;

   }
   if ( victim.armor_helmet ) {

      armor_cnt += 1.00000;

   }
   return ( armor_cnt );
};


float  (entity targ,float damage)armor_calc =  {
local float total_armor_protection = 0.00000;
local float armor_cnt = 0.00000;
local float armor_damage = 0.00000;
local float perpiece = 0.00000;
local float curr_damage = 0.00000;
   total_armor_protection = 0.00000;
   if ( targ.armor_amulet ) {

      total_armor_protection += (ClassArmorProtection->(targ.playerclass - 1.00000));

   }
   if ( targ.armor_bracer ) {

      total_armor_protection += (ClassArmorProtection->((targ.playerclass - 1.00000) + 1.00000));

   }
   if ( targ.armor_breastplate ) {

      total_armor_protection += (ClassArmorProtection->((targ.playerclass - 1.00000) + 2.00000));

   }
   if ( targ.armor_helmet ) {

      total_armor_protection += (ClassArmorProtection->((targ.playerclass - 1.00000) + 3.00000));

   }
   total_armor_protection += (targ.level * 0.00100);
   armor_cnt = armor_inv ( targ);
   if ( armor_cnt ) {

      armor_damage = (total_armor_protection * damage);
      if ( (armor_damage > (((targ.armor_amulet + targ.armor_bracer) + targ.armor_breastplate) + targ.armor_helmet)) ) {

         targ.armor_amulet = 0.00000;
         targ.armor_bracer = 0.00000;
         targ.armor_breastplate = 0.00000;
         targ.armor_helmet = 0.00000;
      } else {

         curr_damage = armor_damage;
         armor_cnt = armor_inv ( targ);
         perpiece = (curr_damage / armor_cnt);
         if ( (targ.armor_amulet && curr_damage) ) {

            targ.armor_amulet -= perpiece;
            curr_damage -= perpiece;
            if ( (targ.armor_amulet < 0.00000) ) {

               curr_damage -= targ.armor_amulet;
               targ.armor_amulet = 0.00000;

            }
            if ( (targ.armor_amulet < 1.00000) ) {

               targ.armor_amulet = 0.00000;

            }

         }
         if ( (targ.armor_bracer && curr_damage) ) {

            targ.armor_bracer -= perpiece;
            curr_damage -= perpiece;
            if ( (targ.armor_bracer < 0.00000) ) {

               curr_damage -= targ.armor_bracer;
               targ.armor_bracer = 0.00000;

            }
            if ( (targ.armor_bracer < 1.00000) ) {

               targ.armor_bracer = 0.00000;

            }

         }
         if ( (targ.armor_breastplate && curr_damage) ) {

            targ.armor_breastplate -= perpiece;
            curr_damage -= perpiece;
            if ( (targ.armor_breastplate < 0.00000) ) {

               curr_damage -= targ.armor_breastplate;
               targ.armor_breastplate = 0.00000;

            }
            if ( (targ.armor_breastplate < 1.00000) ) {

               targ.armor_breastplate = 0.00000;

            }

         }
         if ( (targ.armor_helmet && curr_damage) ) {

            targ.armor_helmet -= perpiece;
            curr_damage -= perpiece;
            if ( (targ.armor_helmet < 0.00000) ) {

               curr_damage -= targ.armor_helmet;
               targ.armor_helmet = 0.00000;

            }
            if ( (targ.armor_helmet < 1.00000) ) {

               targ.armor_helmet = 0.00000;

            }

         }

      }
   } else {

      armor_damage = 0.00000;

   }
   return ( armor_damage );
};


void  (entity targ,entity inflictor,entity attacker,float damage)T_Damage =  {
local vector dir = '0.00000 0.00000 0.00000';
local entity oldself;
local float save = 0.00000;
local float total_damage = 0.00000;
local float armor_damage = 0.00000;
local entity holdent;
   if ( !targ.takedamage ) {

      return ;

   }
   if ( (targ.invincible_time > time) ) {

      sound ( targ, CHAN_ITEM, "misc/pulse.wav", 1.00000, ATTN_NORM);
      return ;

   }
   if ( (targ != attacker) ) {

      if ( ((((targ.deathtype != "teledeath") && (targ.deathtype != "teledeath2")) && (targ.deathtype != "teledeath3")) && (targ.deathtype != "teledeath4")) ) {

         if ( (((coop && teamplay) && (attacker.classname == "player")) && (targ.classname == "player")) ) {

            return ;

         }
         if ( teamplay ) {

            if ( ((attacker.classname == "player") && (targ.classname == "player")) ) {

               if ( (attacker.team == targ.team) ) {

                  return ;

               }

            }

         }

      }

   }
   if ( (targ.flags & FL_GODMODE) ) {

      return ;

   }
   if ( (targ.classname == "monster_mezzoman") ) {

      if ( (inflictor.flags2 & FL_NODAMAGE) ) {

         inflictor.flags2 ^= FL_NODAMAGE;
         if ( (random() < 0.30000) ) {

            CreateSpark ( inflictor.origin);

         }
         return ;

      }
      if ( (targ.movechain.classname == "mezzo reflect") ) {

         if ( infront_of_ent ( inflictor, targ) ) {

            sound ( targ, CHAN_AUTO, "mezzo/slam.wav", 1.00000, ATTN_NORM);
            makevectors ( targ.angles);
            if ( (random() < 0.10000) ) {

               CreateSpark ( ((targ.origin + targ.view_ofs) + (v_forward * 12.00000)));
            } else {

               if ( (random() < 0.70000) ) {

                  particle4 ( ((targ.origin + targ.view_ofs) + (v_forward * 12.00000)), random(5.00000,15.00000), (256.00000 + (8.00000 * 15.00000)), PARTICLETYPE_FASTGRAV, (2.00000 * damage));

               }

            }
            return ;

         }

      }

   }
   if ( (targ.health <= 0.00000) ) {

      targ.health = (targ.health - damage);
      return ;

   }
   damage_attacker = attacker;
   if ( attacker.super_damage ) {

      damage += (attacker.super_damage * damage);

   }
   if ( (targ.classname == "player") ) {

      armor_damage = armor_calc ( targ, damage);
      total_damage = (damage - armor_damage);
   } else {

      total_damage = damage;

   }
   if ( (targ.flags & FL_CLIENT) ) {

      targ.dmg_take = (targ.dmg_take + total_damage);
      targ.dmg_save = (targ.dmg_save + save);
      targ.dmg_inflictor = inflictor;

   }
   if ( ((inflictor != world) && (targ.movetype == MOVETYPE_WALK)) ) {

      dir = (targ.origin - ((inflictor.absmin + inflictor.absmax) * 0.50000));
      dir = normalize ( dir);
      targ.velocity = (targ.velocity + ((dir * damage) * 8.00000));

   }
   targ.health = (targ.health - total_damage);
   if ( ((targ.health >= 0.00000) && (targ.health < 1.00000)) ) {

      targ.health = -0.10000;

   }
   if ( (((targ.health <= 0.00000) && (targ.classname == "player")) && targ.cnt_sh_boost) ) {

      if ( (deathmatch || (skill == 0.00000)) ) {

         holdent = self;
         self = targ;
         use_super_healthboost ( );
         centerprint ( self, "Saved by the Mystic Urn!\n");
         sound ( self, CHAN_AUTO, "misc/comm.wav", 1.00000, ATTN_NORM);
         self.deathtype = "";
         self = holdent;
         return ;

      }

   }
   if ( (((targ.health <= 0.00000) && (targ.classname == "player")) && (targ.playerclass == CLASS_PALADIN)) ) {

      holdent = self;
      self = targ;
      if ( Pal_DivineIntervention ( ) ) {

         self.deathtype = "";
         self = holdent;
         return ;

      }
      self = holdent;

   }
   if ( (targ.health <= 0.00000) ) {

      if ( (attacker.controller.classname == "player") ) {

         inflictor = attacker;
         attacker = attacker.controller;

      }
      targ.th_pain = SUB_Null;
      Killed ( targ, attacker, inflictor);
      return ;

   }
   oldself = self;
   self = targ;
   if ( (self.classname == "barrel") ) {

      self.enemy = inflictor;
      self.count = damage;
   } else {

      if ( (self.classname == "catapult") ) {

         self.enemy = inflictor;
      } else {

         if ( (self.classname == "player") ) {

            self.enemy = attacker;

         }

      }

   }
   if ( (((((self.flags & FL_MONSTER) && (attacker != world)) && !(attacker.flags & FL_NOTARGET)) && (attacker != self.controller)) && ((attacker.controller != self.controller) || (attacker.controller == world))) ) {

      if ( (((self != attacker) && (attacker != self.enemy)) && (((self.enemy.classname != "player") || (attacker.classname == "player")) || (attacker.controller.classname == "player"))) ) {

         if ( ((self.classname != attacker.classname) || (random(100.00000) <= 5.00000)) ) {

            if ( (((self.model == "models/spider.mdl") || (self.model == "models/scorpion.mdl")) && (attacker.model == self.model)) ) {

               if ( (random() < 0.30000) ) {

                  monster_pissed ( attacker);

               }
            } else {

               monster_pissed ( attacker);

            }

         }

      }

   }
   if ( self.th_pain ) {

      if ( ((self.classname == "player") && (self.model != "models/sheep.mdl")) ) {

         player_pain ( );
      } else {

         self.th_pain ( attacker, total_damage);

      }
      if ( (skill == 3.00000) ) {

         self.pain_finished = (time + 5.00000);

      }

   }
   self = oldself;
};


void  (entity inflictor,entity attacker,float damage,entity ignore)T_RadiusDamage =  {
local float points = 0.00000;
local float inertia = 0.00000;
local float radius = 0.00000;
local entity head;
local vector inflictor_org = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
   inflictor_org = ((inflictor.absmin + inflictor.absmax) * 0.50000);
   if ( (inflictor.classname == "circfire") ) {

      radius = 150.00000;
   } else {

      radius = (damage + 40.00000);

   }
   head = findradius ( inflictor_org, radius);
   if ( (inflictor.classname == "fireballblast") ) {

      damage += (attacker.level * 33.00000);

   }
   while ( head ) {

      if ( ((head != ignore) && (head != inflictor)) ) {

         if ( head.takedamage ) {

            org = ((head.absmax + head.absmin) * 0.50000);
            points = (0.50000 * vlen ( (inflictor_org - org)));
            if ( (points < 0.00000) ) {

               points = 0.00000;

            }
            points = (damage - points);
            if ( (head == attacker) ) {

               if ( ((attacker.classname == "monster_eidolon") || (attacker.playerclass == CLASS_NECROMANCER)) ) {

                  points = 0.00000;
               } else {

                  if ( (inflictor.model == "models/assgren.mdl") ) {

                     points *= 0.25000;
                  } else {

                     points *= 0.50000;

                  }

               }

            }
            if ( ((head.flags & FL_MONSTER) && (self.flags2 & FL2_ADJUST_MON_DAM)) ) {

               points = 2.00000;

            }
            if ( (((head.owner == inflictor.owner) && (head.classname == inflictor.classname)) && ((head.classname == "stickmine") || (head.classname == "tripwire"))) ) {

               points = 0.00000;

            }
            if ( (((inflictor.classname == "snowball") || (inflictor.classname == "blizzard")) && (head.frozen > 0.00000)) ) {

               points = 0.00000;

            }
            if ( (points > 0.00000) ) {

               if ( CanDamage ( head, inflictor) ) {

                  if ( (other.movetype != MOVETYPE_PUSH) ) {

                     if ( (head.mass <= 10.00000) ) {

                        inertia = 1.00000;
                     } else {

                        if ( (head.mass <= 100.00000) ) {

                           inertia = (head.mass / 10.00000);
                        } else {

                           inertia = head.mass;

                        }

                     }
                     head.velocity = (head.velocity + (normalize ( (org - inflictor_org)) * ((points * 10.00000) / inertia)));
                     head.flags ^= FL_ONGROUND;

                  }
                  if ( (inflictor.classname == "fireballblast") ) {

                     if ( ((points > 10.00000) || (points < 5.00000)) ) {

                        points = random(5.00000,10.00000);

                     }
                     if ( (head.flags & FL_FIREHEAL) ) {

                        if ( ((head.health + points) <= head.max_health) ) {

                           head.health = (head.health + points);
                        } else {

                           head.health = head.max_health;

                        }
                     } else {

                        if ( !(head.flags & FL_FIRERESIST) ) {

                           if ( (head.health <= points) ) {

                              points = 1000.00000;

                           }
                           T_Damage ( head, inflictor, attacker, points);

                        }

                     }
                  } else {

                     T_Damage ( head, inflictor, attacker, points);

                  }

               }

            }

         }

      }
      head = head.chain;

   }
};


void  (entity inflictor,entity attacker,float dam,entity ignore)T_RadiusDamageWater =  {
local float points = 0.00000;
local entity head;
local vector org = '0.00000 0.00000 0.00000';
   head = findradius ( inflictor.origin, dam);
   while ( head ) {

      if ( (head != ignore) ) {

         if ( head.takedamage ) {

            if ( ((pointcontents ( head.origin) == CONTENT_WATER) || (pointcontents ( head.origin) == CONTENT_SLIME)) ) {

               if ( ((head.classname == "player") && (head != attacker)) ) {

                  head.enemy = attacker;

               }
               org = (head.origin + ((head.mins + head.maxs) * 0.50000));
               points = (0.25000 * vlen ( (inflictor.origin - org)));
               if ( (points <= 64.00000) ) {

                  points = 1.00000;

               }
               points = (dam / points);
               if ( (((points < 1.00000) || ((self.classname == "mjolnir") && (head == self.controller))) || (head.classname == "monster_hydra")) ) {

                  points = 0.00000;

               }
               if ( (points > 0.00000) ) {

                  head.deathtype = "zap";
                  spawnshockball ( ((head.absmax + head.absmin) * 0.50000));
                  T_Damage ( head, inflictor, attacker, points);

               }

            }

         }

      }
      head = head.chain;

   }
};

