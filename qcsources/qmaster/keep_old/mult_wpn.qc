
void () MiniGrenadeExplode = {

   if ( (self.owner.classname == "player") ) {

      T_RadiusDamage (self,self.owner,90.000,world);

   } else {

      T_RadiusDamage (self,self.owner,60.000,world);

   }
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION2);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   WriteByte (MSG_BROADCAST,230.000);
   WriteByte (MSG_BROADCAST,MOVETYPE_FLY);
   BecomeExplosion ();

};

void (float offsetAngle) MiniGrenadeLaunch = {

   local entity missile;
   local float tempRand;

   missile = spawn ();
   missile.owner = self.owner;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "MiniGrenade";
   missile.v_angle = self.v_angle;
   missile.v_angle_y = (missile.v_angle_y + offsetAngle);
   makevectors (missile.v_angle);
   missile.velocity = ((v_forward * 100.000) + (v_up * CTF_TARGET_PROTECT_RADIUS));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_forward));
   tempRand = ((crandom () * CTF_FLAG_RETURN_TIME) - 20.000);
   missile.velocity = (missile.velocity + (tempRand * v_right));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_up));
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = MultiGrenadeTouch;
   setmodel (missile,"progs/mervup.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);
   missile.nextthink = ((time + TRUE) + (crandom () * 0.500));
   missile.think = MiniGrenadeExplode;

};

void () MultiGrenadeExplode = {

   MiniGrenadeLaunch (FALSE);
   MiniGrenadeLaunch (72.000);
   MiniGrenadeLaunch (144.000);
   MiniGrenadeLaunch (216.000);
   MiniGrenadeLaunch (288.000);
   remove (self);

};

void () MultiGrenadeTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.takedamage == DAMAGE_AIM) ) {

      if ( (self.classname == "MiniGrenade") ) {

         MiniGrenadeExplode ();

      } else {

         if ( (self.owner.classname == "player") ) {

            GrenadeExplode ();

         } else {

            MiniGrenadeExplode ();

         }

      }
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/bounce.wav",TRUE,ATTN_NORM);
   if ( (self.velocity == VEC_ORIGIN) ) {

      self.avelocity = VEC_ORIGIN;

   }

};

void () W_FireMultiGrenade = {

   local entity missile;

   self.ammo_multi_rockets = (self.ammo_multi_rockets - TRUE);
   self.currentammo = (self.ammo_multi_rockets - TRUE);
   UpdateAmmoCounts (self);
   sound (self,CHAN_WEAPON,"weapons/grenade.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "MultiGrenade";
   makevectors (self.v_angle);
   if ( self.v_angle_x ) {

      missile.velocity = ((((v_forward * 600.000) + (v_up * 200.000)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));

   } else {

      missile.velocity = aim (self,10000.000);
      missile.velocity = (missile.velocity * 600.000);
      missile.velocity_z = 200.000;

   }
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = MultiGrenadeTouch;
   missile.nextthink = (time + TRUE);
   missile.think = MultiGrenadeExplode;
   setmodel (missile,"progs/mervup.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);

};

void () MultiRocketExplode = {

   local float damg;

   damg = (60.000 + (random () * CTF_CAPTURE_BONUS));
   if ( other.health ) {

      if ( (other.classname == "monster_shambler") ) {

         damg = (damg * 0.500);

      }
      if ( (other.classname == "monster_dragon") ) {

         damg = (damg * 0.500);

      }
      T_Damage (other,self,self.owner,damg);

   }
   T_RadiusDamage (self,self.owner,75.000,other);
   self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void () MultiRocketTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   MultiRocketExplode ();

};

void () HomingMissileThink = {

   local vector dir;

   if ( (self.enemy.health < TRUE) ) {

      remove (self);
      return ;

   }
   dir = normalize ((self.enemy.origin - self.origin));
   self.velocity = (dir * 1000.000);
   self.nextthink = (time + 0.100);
   self.think = HomingMissileThink;

};

void () HomingMissileAcquire = {

   local vector oldVelocity;
   local vector aimangle;

   if ( (self.delay < time) ) {

      MultiRocketExplode ();
      return ;

   }
   oldVelocity = self.velocity;
   makevectors (self.v_angle);
   self.velocity = aim (self,1000.000);
   self.velocity = (self.velocity * 1000.000);
   aimangle = (self.origin + self.velocity);
   traceline (self.origin,aimangle,FALSE,self);
   if ( (trace_fraction < TRUE) ) {

      if ( (trace_ent.flags & FL_MONSTER) ) {

         self.enemy = trace_ent;
         HomingMissileThink ();
         return ;

      }

   }
   self.velocity = oldVelocity;
   self.v_angle = vectoangles (self.velocity);
   self.angles = self.v_angle;
   self.think = HomingMissileAcquire;
   self.nextthink = (time + 0.200);

};

void (float offset, float frameNum) MultiRocketLaunch = {

   local entity missile;
   local vector aimangle;

   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "MultiRocket";
   missile.delay = (time + MOVETYPE_STEP);
   missile.frame = frameNum;
   missile.touch = MultiRocketTouch;
   if ( (deathmatch || coop) ) {

      setmodel (missile,"progs/rockup_d.mdl");

   } else {

      setmodel (missile,"progs/rockup.mdl");

   }
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));
   if ( (coop || deathmatch) ) {

      aimangle = self.v_angle;
      aimangle_y = (aimangle_y + (offset * 0.660));
      makevectors (aimangle);
      missile.velocity = aim (self,1000.000);
      missile.velocity = (missile.velocity * 1000.000);
      missile.angles = vectoangles (missile.velocity);
      missile.think = MultiRocketExplode;
      missile.nextthink = (time + MOVETYPE_STEP);

   } else {

      makevectors (self.v_angle);
      missile.velocity = ((v_forward * 1000.000) - ((v_right * offset) * FL_CLIENT));
      missile.angles = vectoangles (missile.velocity);
      missile.v_angle = self.v_angle;
      aimangle = (missile.origin + missile.velocity);
      traceline (missile.origin,aimangle,FALSE,self);
      if ( (trace_fraction < TRUE) ) {

         if ( (trace_ent.flags & FL_MONSTER) ) {

            missile.enemy = trace_ent;
            missile.think = HomingMissileThink;
            return ;

         }

      }
      missile.think = HomingMissileAcquire;
      missile.nextthink = (time + 0.100);

   }

};

void () W_FireMultiRocket = {

   self.ammo_multi_rockets = (self.ammo_multi_rockets - TRUE);
   self.currentammo = (self.ammo_multi_rockets - TRUE);
   UpdateAmmoCounts (self);
   sound (self,CHAN_WEAPON,"weapons/sgun1.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   MultiRocketLaunch (-10.000,FL_SWIM);
   MultiRocketLaunch (CONTENT_LAVA,MOVETYPE_WALK);
   MultiRocketLaunch (MOVETYPE_FLY,FALSE);
   MultiRocketLaunch (MOVETYPE_BOUNCE,TRUE);

};

void (vector p1, vector p2, entity from, float damage) PlasmaDamage = {

   local entity e1;
   local entity e2;
   local vector f;

   f = (p2 - p1);
   normalize (f);
   f_x = (FALSE - f_y);
   f_y = f_x;
   f_z = FALSE;
   f = (f * FL_INWATER);
   e2 = world;
   e1 = world;
   traceline (p1,p2,FALSE,self);
   if ( trace_ent.takedamage ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from.owner,damage);
      if ( (self.classname == "player") ) {

         if ( (other.classname == "player") ) {

            trace_ent.velocity_z = (trace_ent.velocity_z + CTF_TARGET_PROTECT_RADIUS);

         }

      }

   }
   e1 = trace_ent;
   traceline ((p1 + f),(p2 + f),FALSE,self);
   if ( ((trace_ent != e1) && trace_ent.takedamage) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from.owner,damage);

   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ( (((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from.owner,damage);

   }

};

void (entity current, float doDamage) PlasmaDischarge = {

   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,current);
   WriteCoord (MSG_BROADCAST,current.origin_x);
   WriteCoord (MSG_BROADCAST,current.origin_y);
   WriteCoord (MSG_BROADCAST,current.origin_z);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   sound (self,CHAN_VOICE,"weapons/lhit.wav",TRUE,ATTN_NORM);
   if ( (doDamage == TRUE) ) {

      PlasmaDamage (self.origin,current.origin,self,50.000);

   }

};

void () PlasmaGroundOut = {

   local entity current;
   local entity start;
   local float monstersHit;

   monstersHit = FALSE;
   current = findradius (self.origin,320.000);
   start = current;
   while ( (monstersHit < MOVETYPE_FLY) ) {

      if ( ((current.flags & FL_MONSTER) || (current.classname == "player")) ) {

         if ( (current != self.owner) ) {

            traceline (self.origin,current.origin,TRUE,world);
            if ( (trace_fraction == TRUE) ) {

               monstersHit = (monstersHit + TRUE);
               PlasmaDischarge (current,TRUE);

            }

         }

      }
      current = current.chain;
      if ( ((start == current) || !current) ) {

         return ;

      }

   }

};

void () PlasmaTouch = {

   local float damg;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   damg = (80.000 + (random () * 20.000));
   sound (self,CHAN_WEAPON,"plasma/explode.wav",TRUE,ATTN_NORM);
   if ( other.health ) {

      if ( (other.classname == "monster_shambler") ) {

         damg = (damg * 0.500);

      }
      T_Damage (other,self,self.owner,damg);

   }
   T_RadiusDamage (self,self.owner,70.000,other);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION2);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   WriteByte (MSG_BROADCAST,244.000);
   WriteByte (MSG_BROADCAST,MOVETYPE_WALK);
   PlasmaGroundOut ();
   remove (self);

};

//void () PlasmaLaunch = {
//
//   self.velocity = normalize (self.velocity);
//   self.velocity = (self.velocity * 1250.000);
//   self.nextthink = (time + MOVETYPE_FLY);
//   self.think = SUB_Remove;

//};

void () W_FirePlasma = {

   local entity missile;

   if ( (self.waterlevel > TRUE) ) {

      W_SetCurrentAmmo ();
      discharged = TRUE;
      T_RadiusDamage (self,self,(35.000 * self.ammo_plasma),world);
      discharged = FALSE;
      self.ammo_plasma = FALSE;
      return ;

   }
   self.ammo_plasma = (self.ammo_plasma - TRUE);
   self.currentammo = (self.currentammo - TRUE);
   UpdateAmmoCounts (self);
   sound (self,CHAN_WEAPON,"plasma/fire.wav",0.500,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "plasma";
   makevectors (self.v_angle);
   missile.velocity = aim (self,1250);
   missile.velocity = (missile.velocity * 1250);
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = PlasmaTouch;
   setmodel (missile,"progs/plasma.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));
   sound (missile,CHAN_WEAPON,"plasma/flight.wav",TRUE,ATTN_NORM);
   missile.think = PlasmaGroundOut;
   missile.nextthink = (time + MOVETYPE_FLY);

};
