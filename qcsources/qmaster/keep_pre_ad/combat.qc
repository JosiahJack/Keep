float IsExplosionDamage /* = 0.000 */;

void () T_MissileTouch;
void () info_player_start;
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
   if ( (self.flags & FL_MONSTER) ) {

      killed_monsters = (killed_monsters + TRUE);
      WriteByte (MSG_ALL,SVC_KILLEDMONSTER);

   }
   if ( (((attacker.classname == "buzzsaw") || (attacker.classname == "Vengeance")) || (attacker.classname == "pendulum")) ) {

      self.health = -99.000;

   }
   self.gravity = TRUE;
   ClientObituary (self,attacker);
   self.takedamage = DAMAGE_NO;
   self.touch = SUB_Null;
   monster_death_use ();
   self.th_die ();
   self = oself;

};

float (entity targ, entity inflictor, entity attacker, float damage) shield_hit;
float empathyused;

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage = {

   local vector dir;
   local entity oldself;
   local float save;
   local float take;

   if ( !targ.takedamage ) {

      return ;

   }
   if ( (discharged && targ.wetsuit_finished) ) {

      return ;

   }
   if ( (targ.classname == "trigger_explosion") ) {

      if ( (IsExplosionDamage != TRUE) ) {

         return ;

      }

   }
   IsExplosionDamage = FALSE;
   if ( (targ.items2 & IT2_SHIELD) ) {

      damage = shield_hit (targ,inflictor,attacker,damage);
      if ( (damage == FALSE) ) {

         return ;

      }

   }
   if ( (((targ.items2 & HIP_IT2_EMPATHY_SHIELDS) && !(inflictor.items2 & HIP_IT2_EMPATHY_SHIELDS)) && (targ != attacker)) ) {

      empathyused = TRUE;
      damage = (damage / FL_SWIM);
      T_Damage (attacker,targ,targ,damage);
      empathyused = FALSE;

   }
   damage_attacker = attacker;
   if ( (attacker.super_damage_finished > time) ) {

      damage = (damage * MOVETYPE_STEP);

   }
   if ( deathmatch ) {

      damage = RuneApplyBlack (damage,attacker);

   }
   if ( TeamArmorDam (targ,inflictor,attacker,damage) ) {

      save = ceil ((targ.armortype * damage));

   } else {

      save = FALSE;

   }
   if ( (save >= targ.armorvalue) ) {

      save = targ.armorvalue;
      targ.armortype = FALSE;
      targ.items2 = (targ.items2 - (targ.items2 & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3)));

   }
   targ.armorvalue = (targ.armorvalue - save);
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
   if ( (targ.items2 & HIP_IT2_EMPATHY_SHIELDS) ) {

      if ( (self.empathy_sound < time) ) {

         sound (targ,CHAN_ITEM,"hipitems/empathy2.wav",TRUE,ATTN_NORM);
         self.empathy_sound = (time + 0.500);

      }

   }
   if ( !TeamHealthDam (targ,inflictor,attacker,damage) ) {

      return ;

   }
   if ( deathmatch ) {

      take = RuneApplyEarth (take,targ);

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

         if ( ((self.classname != attacker.classname) || (self.classname == "monster_army") || (self.classname == "monster_armagon")) ) {

            if ( (self.classname != "monster_dragon") ) {

               if ( (self.enemy.classname == "player") ) {

                  self.oldenemy = self.enemy;

               }
               self.enemy = attacker;
               FoundTarget ();
            }

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

void (entity inflictor, entity attacker, float damage) T_EELZap = {

   local float points;
   local entity head;
   local vector org;

   head = findradius (inflictor.origin,(damage + CTF_FLAG_RETURN_TIME));
   while ( head ) {

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

               if ( ((head.classname != "monster_eel") && (head.flags & FL_INWATER)) ) {

                  T_Damage (head,inflictor,attacker,points);

               }

            }

         }

      }
      head = head.chain;

   }

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

void(entity inflictor, entity attacker, float damage, entity ignore) T_WeakRadiusDamage = 
{
	local float points;
	local entity head;
	local vector org;
	local vector dir;
	head = findradius(inflictor.origin, damage + 40);
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs) * 0.5;
				points = 0.5 * vlen(inflictor.origin - org);
				if (points < MSG_BROADCAST)
				{
					points = MSG_BROADCAST;
				}
				points = damage - points;
				if (head == attacker)
				{
					points = points * 0.5;
				}
				if (points > MSG_BROADCAST)
				{
					points = points * 0.4 + AS_LOITER;
					if (CanDamage(head, inflictor))
					{
						if (!(head.cross_finished >= time))
						{
							if (head.classname == "monster_shambler")
							{
								T_Damage(head, inflictor, attacker, points * 0.5);
							}
							else
							{
								T_Damage(head, inflictor, attacker, points);
							}
						}
						if (head.cross_finished >= time && head.classname == "player")
						{
							if (self.cross_sound < time)
							{
								sound(self, CHAN_ITEM, "items2/crosuse.wav", REVERSE, ATTN_NORM);
								self.cross_sound = time + 0.5;
							}
							dir = head.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
							dir = normalize(dir);
							head.velocity = head.velocity + dir * points * EF_DIMLIGHT;
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
