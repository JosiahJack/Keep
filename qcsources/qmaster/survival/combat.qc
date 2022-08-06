
void () T_MissileTouch;
void () info_player_start;
void (entity e, float points) survival_spawn_sign;
void () survival_bodykill;
void () respawn;

void (entity targ, entity attacker) ClientObituary;

void () monster_death_use;
float (entity targ, entity inflictor) CanDamage = {

   if ( (targ.movetype == MOVETYPE_PUSH) ) {

      traceline (inflictor.origin,(0.500 * (targ.absmin + targ.absmax)),TRUE,self);
      if ( (trace_fraction == TRUE) ) {

         return ( TRUE );

      }
      if ( (trace_ent == targ) ) {

         return ( TRUE );

      }
      return ( FALSE );

   }
   traceline (inflictor.origin,targ.origin,TRUE,self);
   if ( (trace_fraction == TRUE) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '15.000 15.000 0.000'),TRUE,self);
   if ( (trace_fraction == TRUE) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '-15.000 -15.000 0.000'),TRUE,self);
   if ( (trace_fraction == TRUE) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '-15.000 15.000 0.000'),TRUE,self);
   if ( (trace_fraction == TRUE) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '15.000 -15.000 0.000'),TRUE,self);
   if ( (trace_fraction == TRUE) ) {

      return ( TRUE );

   }
   return ( FALSE );

};

void (entity targ, entity attacker) Killed = {

   local entity oself;
   local string atck_points;

   oself = self;
   self = targ;
   if ( (self.health < -99.000) ) {

      self.health = -99.000;

   }
   if ( ((self.movetype == MOVETYPE_PUSH) || (self.movetype == MOVETYPE_NONE)) ) {

      self.th_die ();
      self = oself;
      return ;

   }
   self.enemy = attacker;
   self.th_die ();
   if ( (self.flags & FL_MONSTER) ) {

      killed_monsters = (killed_monsters + TRUE);
      WriteByte (MSG_ALL,SVC_KILLEDMONSTER);
      if ( coop ) {

         if ( (attacker.classname == "player") ) {

            survival_spawn_sign (self, self.pts);
            attacker.pts = (attacker.pts + self.pts);
            attacker.frags = (attacker.frags + TRUE);
            sprint (attacker,attacker.netname);
            sprint (attacker," scores ");
            atck_points = ftos (self.pts);
            sprint (attacker,atck_points);
            sprint (attacker," points!\n");
            sprint (attacker,"Current Player Score is: ");
            atck_points = ftos (attacker.pts);
            sprint (attacker,atck_points);
            sprint (attacker," points, with ");
            atck_points = ftos (attacker.frags);
            sprint (attacker,atck_points);
            sprint (attacker," kills\n");

         }

      }

   }
   ClientObituary (self,attacker);
   self.takedamage = DAMAGE_NO;
   self.touch = SUB_Null;
   monster_death_use ();
   self = oself;

};

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage = {

   local vector dir;
   local entity oldself;
   local float save;
   local float take;
   local entity stemp;

   if ( !targ.takedamage ) {

      return ;

   }
   if ( coop ) {

      if ( ((targ.netname == "rebecca") || (targ.netname == "Rebecca") || (targ.netname == "becca") || (targ.netname == "Becca")) ) {

         damage = (damage * 0.500);

      }

   }
   damage_attacker = attacker;
   if ( (attacker.super_damage_finished > time) ) {

      damage = (damage * MOVETYPE_STEP);

   }
   if (!(coop) ) {

      save = ceil ((targ.armortype * damage));
      if ( (save >= targ.armorvalue) ) {

         save = targ.armorvalue;
         targ.armortype = FALSE;
         targ.items = (targ.items - (targ.items & ((IT_ARMOR1 | IT_ARMOR2) | IT_ARMOR3)));

      }
      targ.armorvalue = (targ.armorvalue - save);

   } else {

      save = FALSE;

   }
   take = ceil ((damage - save));
   if ( (targ.flags & FL_CLIENT) ) {

      targ.dmg_take = (targ.dmg_take + take);
      targ.dmg_save = (targ.dmg_save + save);
      targ.dmg_inflictor = inflictor;

   }
   if ( ((inflictor != world) && (targ.movetype == MOVETYPE_WALK)) ) {

      dir = (targ.origin - ((inflictor.absmin + inflictor.absmax) * 0.500));
      dir = normalize (dir);
      targ.velocity = (targ.velocity + ((dir * damage) * FL_CLIENT));

   }
   if ( (targ.flags & FL_GODMODE) ) {

      return ;

   }
   if ( (targ.invincible_finished >= time) ) {

      if ( (self.invincible_sound < time) ) {

         sound (targ,CHAN_ITEM,"items/protect3.wav",TRUE,ATTN_NORM);
         self.invincible_sound = (time + FL_SWIM);

      }
      return ;

   }
   if ( (((teamplay == TRUE) && (targ.team > FALSE)) && (targ.team == attacker.team)) ) {

      return ;

   }
   targ.health = (targ.health - take);
   if ( (targ.health <= FALSE) ) {

      Killed (targ,attacker);
      return ;

   }
   oldself = self;
   self = targ;
   if ( ((self.flags & FL_MONSTER) && (attacker != world)) ) {

      if ( ((self != attacker) && (attacker != self.enemy)) ) {

         if ( ((self.classname != attacker.classname) || (self.classname == "monster_army")) ) {

            if ( (self.enemy.classname == "player") ) {

               self.oldenemy = self.enemy;

            }
            self.enemy = attacker;
            FoundTarget ();

         }

      }

   }
   if ( self.th_pain ) {

      self.th_pain (attacker,take);
      if ( (skill == MOVETYPE_WALK) ) {

         self.pain_finished = (time + MOVETYPE_FLY);

      }

   }
   self = oldself;

};

void (entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = {

   local float points;
   local entity head;
   local vector org;

   head = findradius (inflictor.origin,(damage + 40.000));
   while ( head ) {

      if ( (head != ignore) ) {

         if ( head.takedamage ) {

            org = (head.origin + ((head.mins + head.maxs) * 0.500));
            points = (0.500 * vlen ((inflictor.origin - org)));
            if ( (points < FALSE) ) {

               points = FALSE;

            }
            points = (damage - points);
            if ( (head == attacker) ) {

               points = (points * 0.500);

            }
            if ( (points > FALSE) ) {

               if ( CanDamage (head,inflictor) ) {

                  if ( (head.classname == "monster_shambler") ) {

                     T_Damage (head,inflictor,attacker,(points * 0.500));

                  } else {

                     T_Damage (head,inflictor,attacker,points);

                  }

               }

            }

         }

      }
      head = head.chain;

   }

};

void (entity attacker, float damage) T_BeamDamage = {

   local float points;
   local entity head;

   head = findradius (attacker.origin,(damage + 40.000));
   while ( head ) {

      if ( head.takedamage ) {

         points = (0.500 * vlen ((attacker.origin - head.origin)));
         if ( (points < FALSE) ) {

            points = FALSE;

         }
         points = (damage - points);
         if ( (head == attacker) ) {

            points = (points * 0.500);

         }
         if ( (points > FALSE) ) {

            if ( CanDamage (head,attacker) ) {

               if ( (head.classname == "monster_shambler") ) {

                  T_Damage (head,attacker,attacker,(points * 0.500));

               } else {

                  T_Damage (head,attacker,attacker,points);

               }

            }

         }

      }
      head = head.chain;

   }

};
