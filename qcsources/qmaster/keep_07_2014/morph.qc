float MORPH_AZTEC    = 2.000;
float MORPH_EGYPT    = 4.000;
float MORPH_GREEK    = 8.000;

void () morph_teleport;

void () morph_stand1 = [ 0.000, morph_stand1 ] {

   ai_stand ();

};

void () morph_walk1 = [ 43.000, morph_walk2 ] {

   ai_walk (MOVETYPE_WALK);

};

void () morph_walk2 = [ 44.000, morph_walk3 ] {

   ai_walk (FL_SWIM);

};

void () morph_walk3 = [ 45.000, morph_walk4 ] {

   ai_walk (MOVETYPE_STEP);

};

void () morph_walk4 = [ 46.000, morph_walk5 ] {

   ai_walk (MOVETYPE_FLY);

};

void () morph_walk5 = [ 47.000, morph_walk6 ] {

   ai_walk (MOVETYPE_FLY);

};

void () morph_walk6 = [ 48.000, morph_walk7 ] {

   ai_walk (MOVETYPE_STEP);

};

void () morph_walk7 = [ 49.000, morph_walk8 ] {

   ai_walk (FL_SWIM);

};

void () morph_walk8 = [ 50.000, morph_walk9 ] {

   ai_walk (MOVETYPE_WALK);

};

void () morph_walk9 = [ 51.000, morph_walk10 ] {

   ai_walk (MOVETYPE_STEP);

};

void () morph_walk10 = [ 52.000, morph_walk11 ] {

   ai_walk (MOVETYPE_FLY);

};

void () morph_walk11 = [ 53.000, morph_walk12 ] {

   ai_walk (MOVETYPE_FLY);

};

void () morph_walk12 = [ 54.000, morph_walk13 ] {

   ai_walk (MOVETYPE_STEP);

};

void () morph_walk13 = [ 55.000, morph_walk1 ] {

   ai_walk (MOVETYPE_WALK);

};

void () morph_run1 = [ 32.000, morph_run2 ] {

   ai_run (MOVETYPE_PUSH);

};

void () morph_run2 = [ 33.000, morph_run3 ] {

   ai_run (MOVETYPE_BOUNCEMISSILE);

};

void () morph_run3 = [ 34.000, morph_run4 ] {

   ai_run (FL_INWATER);

};

void () morph_run4 = [ 35.000, morph_run5 ] {

   ai_run (FL_INWATER);

};

void () morph_run5 = [ 36.000, morph_run6 ] {

   ai_run (MOVETYPE_BOUNCEMISSILE);

};

void () morph_run6 = [ 37.000, morph_run7 ] {

   ai_run (MOVETYPE_PUSH);

};

void () morph_run7 = [ 38.000, morph_run8 ] {

   ai_run (MOVETYPE_BOUNCEMISSILE);

};

void () morph_run8 = [ 39.000, morph_run9 ] {

   ai_run (CTF_CAPTURE_BONUS);

};

void () morph_run9 = [ 40.000, morph_run10 ] {

   ai_run (19.000);

};

void () morph_run10 = [ 41.000, morph_run11 ] {

   ai_run (CTF_CAPTURE_BONUS);

};

void () morph_run11 = [ 42.000, morph_run1 ] {

   ai_run (MOVETYPE_BOUNCEMISSILE);

};

void () morph_stab2 = {

   local float dist;
   local float attackDamage;
   local vector org;
   local vector dir;

   if ( !self.enemy ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   ai_face ();
   dir = ((self.enemy.origin - self.origin) + self.enemy.view_ofs);
   dist = vlen (dir);
   dir = normalize (dir);
   makevectors (self.angles);
   if ( (dist <= 90.000) ) {

      sound (self,CHAN_WEAPON,"enforcer/enfstop.wav",TRUE,ATTN_STATIC);
      attackDamage = ((random () * MOVETYPE_BOUNCE) + 20.000);
      T_Damage (self.enemy,self,self,attackDamage);
      SpawnBlood (self.enemy.origin,(v_forward * 150.000),TEAM2);

   } else {

      self.effects = (self.effects | EF_MUZZLEFLASH);
      org = (((self.origin + (v_forward * 80.000)) + (v_right * MOVETYPE_STEP)) + '0.000 0.000 4.000');
      LaunchLaser (org,dir);
      if ( dist ) {

         LaunchLaser (org,(dir + (v_right * 0.040)));
         LaunchLaser (org,(dir - (v_right * 0.040)));

      } else {

         LaunchLaser (org,(dir + (v_right * 0.100)));
         LaunchLaser (org,(dir - (v_right * 0.100)));

      }

   }

};

void () morph_attack01 = [ 65.000, morph_attack02 ] {

   ai_face ();

};

void () morph_attack02 = [ 66.000, morph_attack03 ] {

   ai_face ();

};

void () morph_attack03 = [ 67.000, morph_attack04 ] {

   ai_face ();

};

void () morph_attack04 = [ 68.000, morph_attack05 ] {

   ai_face ();

};

void () morph_attack05 = [ 69.000, morph_attack06 ] {

   ai_face ();

};

void () morph_attack06 = [ 70.000, morph_attack07 ] {

   ai_face ();

};

void () morph_attack07 = [ 71.000, morph_attack08 ] {

   morph_stab2 ();

};

void () morph_attack08 = [ 72.000, morph_attack09 ] {

   ai_face ();

};

void () morph_attack09 = [ 73.000, morph_attack10 ] {

   ai_face ();

};

void () morph_attack10 = [ 74.000, morph_attack11 ] {

   ai_face ();

};

void () morph_attack11 = [ 75.000, morph_attack12 ] {

   ai_face ();

};

void () morph_attack12 = [ 65.000, morph_run1 ] {

   ai_face ();

};

void () morph_bigattack01 = [ 76.000, morph_bigattack02 ] {

   ai_face ();

};

void () morph_bigattack02 = [ 77.000, morph_bigattack03 ] {

   ai_face ();

};

void () morph_bigattack03 = [ 78.000, morph_bigattack04 ] {

   ai_face ();

};

void () morph_bigattack04 = [ 79.000, morph_bigattack05 ] {

   ai_face ();

};

void () morph_bigattack05 = [ 80.000, morph_bigattack06 ] {

   ai_face ();

};

void () morph_bigattack06 = [ 81.000, morph_bigattack07 ] {

   ai_face ();

};

void () morph_bigattack07 = [ 82.000, morph_bigattack08 ] {

   ai_face ();

};

void () morph_bigattack08 = [ 83.000, morph_bigattack09 ] {

   ai_face ();

};

void () morph_bigattack09 = [ 84.000, morph_bigattack10 ] {

   ai_face ();

};

void () morph_bigattack10 = [ 85.000, morph_bigattack11 ] {

   morph_stab2 ();

};

void () morph_bigattack11 = [ 86.000, morph_bigattack12 ] {

   ai_face ();

};

void () morph_bigattack12 = [ 87.000, morph_bigattack13 ] {

   ai_face ();

};

void () morph_bigattack13 = [ 88.000, morph_bigattack14 ] {

   ai_face ();

};

void () morph_bigattack14 = [ 89.000, morph_bigattack15 ] {

   ai_face ();

};

void () morph_bigattack15 = [ 90.000, morph_bigattack16 ] {

   ai_face ();

};

void () morph_bigattack16 = [ 91.000, morph_bigattack17 ] {

   ai_face ();

};

void () morph_bigattack17 = [ 76.000, morph_run1 ] {

   ai_face ();

};

void () morph_smack = {

   local vector delta;
   local float ldmg;

   if ( !self.enemy ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   ai_face ();
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 100.000) ) {

      return ;

   }
   ldmg = ((random () * MOVETYPE_BOUNCE) + MOVETYPE_BOUNCE);
   T_Damage (self.enemy,self,self,ldmg);
   makevectors (self.angles);
   self.enemy.velocity = ((v_forward * 100.000) + '0.000 0.000 100.000');

};

void () morph_knockback01 = [ 92.000, morph_knockback02 ] {

   ai_face ();

};

void () morph_knockback02 = [ 93.000, morph_knockback03 ] {

   ai_face ();

};

void () morph_knockback03 = [ 94.000, morph_knockback04 ] {

   ai_face ();

};

void () morph_knockback04 = [ 95.000, morph_knockback05 ] {

   ai_face ();

};

void () morph_knockback05 = [ 96.000, morph_knockback06 ] {

   ai_face ();

};

void () morph_knockback06 = [ 97.000, morph_knockback07 ] {

   ai_face ();

};

void () morph_knockback07 = [ 98.000, morph_knockback08 ] {

   ai_face ();

};

void () morph_knockback08 = [ 99.000, morph_knockback09 ] {

   ai_face ();

};

void () morph_knockback09 = [ 100.000, morph_knockback10 ] {

   morph_smack ();

};

void () morph_knockback10 = [ 101.000, morph_knockback11 ] {

   ai_face ();

};

void () morph_knockback11 = [ 102.000, morph_knockback12 ] {

   ai_face ();

};

void () morph_knockback12 = [ 103.000, morph_run1 ] {

   ai_face ();

};

void () morph_attack = {

   local float attackChoice;

   attackChoice = random ();
   if ( (attackChoice < 0.500) ) {

      morph_bigattack01 ();

   } else {

      if ( (attackChoice < 0.750) ) {

         morph_attack01 ();

      } else {

         morph_knockback01 ();

      }

   }

};

void () morph_fire = {

   local vector org;
   local vector dir;

   ai_face ();
   self.effects = (self.effects | EF_MUZZLEFLASH);
   makevectors (self.angles);
   org = (((self.origin + (v_forward * SVC_INTERMISSION)) + (v_right * 8.500)) + '0.000 0.000 16.000');
   dir = normalize ((self.enemy.origin - self.origin));
   LaunchLaser (org,dir);
   if ( (vlen ((self.enemy.origin - self.origin)) > CTF_TARGET_PROTECT_RADIUS) ) {

      LaunchLaser (org,(dir + (v_right * 0.040)));
      LaunchLaser (org,(dir - (v_right * 0.040)));

   } else {

      LaunchLaser (org,(dir + (v_right * 0.100)));
      LaunchLaser (org,(dir - (v_right * 0.100)));

   }

};

void () morph_fire1 = [ 56.000, morph_fire2 ] {

   ai_face ();

};

void () morph_fire2 = [ 57.000, morph_fire3 ] {

   ai_face ();

};

void () morph_fire3 = [ 58.000, morph_fire4 ] {

   ai_face ();

};

void () morph_fire4 = [ 59.000, morph_fire5 ] {

   morph_fire ();

};

void () morph_fire5 = [ 60.000, morph_fire6 ] {

   ai_face ();

};

void () morph_fire6 = [ 61.000, morph_fire7 ] {

   ai_face ();

};

void () morph_fire7 = [ 62.000, morph_fire8 ] {

   ai_face ();

};

void () morph_fire8 = [ 63.000, morph_fire9 ] {

   ai_face ();

};

void () morph_fire9 = [ 64.000, morph_run1 ] {

   ai_face ();

};

void () morph_painA1 = [ 104.000, morph_painA2 ] {


};

void () morph_painA2 = [ 105.000, morph_painA3 ] {


};

void () morph_painA3 = [ 106.000, morph_painA4 ] {


};

void () morph_painA4 = [ 107.000, morph_painA5 ] {


};

void () morph_painA5 = [ 108.000, morph_painA6 ] {


};

void () morph_painA6 = [ 109.000, morph_painA7 ] {


};

void () morph_painA7 = [ 110.000, morph_painA8 ] {


};

void () morph_painA8 = [ 111.000, morph_painA9 ] {


};

void () morph_painA9 = [ 112.000, morph_painA10 ] {


};

void () morph_painA10 = [ 113.000, morph_run1 ] {

   morph_teleport ();

};

void () morph_painB1 = [ 114.000, morph_painB2 ] {


};

void () morph_painB2 = [ 115.000, morph_painB3 ] {


};

void () morph_painB3 = [ 116.000, morph_painB4 ] {


};

void () morph_painB4 = [ 117.000, morph_painB5 ] {


};

void () morph_painB5 = [ 118.000, morph_painB6 ] {


};

void () morph_painB6 = [ 119.000, morph_painB7 ] {


};

void () morph_painB7 = [ 120.000, morph_run1 ] {

   morph_teleport ();

};

void (entity attacker, float damage) morph_pain = {

   local float painChoice;

   if ( (skill == MOVETYPE_WALK) ) {

      if ( (random () > 0.500) ) {

         morph_teleport ();

      }
      return ;

   }
   if ( (self.pain_finished > time) ) {

      return ;

   }
   if ( (random () > 0.250) ) {

      return ;

   }
   painChoice = random ();
   self.pain_finished = (time + FL_SWIM);
   sound (self,CHAN_VOICE,"guard/pain1.wav",TRUE,ATTN_NORM);
   if ( (painChoice > 0.600) ) {

      self.think = morph_painB1;

   } else {

      self.think = morph_painA1;

   }
   self.nextthink = (time + 0.100);

};

void () morph_die1 = [ 121.000, morph_die2 ] {


};

void () morph_die2 = [ 122.000, morph_die3 ] {


};

void () morph_die3 = [ 123.000, morph_die4 ] {


};

void () morph_die4 = [ 124.000, morph_die5 ] {


};

void () morph_die5 = [ 125.000, morph_die6 ] {


};

void () morph_die6 = [ 126.000, morph_die7 ] {


};

void () morph_die7 = [ 127.000, morph_die8 ] {


};

void () morph_die8 = [ 128.000, morph_die9 ] {


};

void () morph_die9 = [ 129.000, morph_die10 ] {

   self.skin = (self.skin + TRUE);

};

void () morph_die10 = [ 130.000, morph_die11 ] {


};

void () morph_die11 = [ 131.000, morph_die12 ] {


};

void () morph_die12 = [ 132.000, morph_die13 ] {


};

void () morph_die13 = [ 133.000, morph_die14 ] {


};

void () morph_die14 = [ 134.000, morph_die15 ] {


};

void () morph_die15 = [ 135.000, morph_die16 ] {


};

void () morph_die16 = [ 136.000, morph_die17 ] {


};

void () morph_die17 = [ 137.000, morph_die18 ] {


};

void () morph_die18 = [ 138.000, morph_die19 ] {


};

void () morph_die19 = [ 139.000, morph_die20 ] {


};

void () morph_die20 = [ 140.000, morph_die21 ] {


};

void () morph_die21 = [ 141.000, morph_die21 ] {

   remove (self);

};

void () morph_die = {

   sound (self,CHAN_VOICE,"guard/death.wav",TRUE,ATTN_NORM);
   self.solid = SOLID_NOT;
   self.think = morph_die1;
   self.nextthink = (time + 0.100);

};

void () morph_wake1 = [ 1.000, morph_wake2 ] {

   sound (self,CHAN_VOICE,"guard/see1.wav",TRUE,ATTN_NORM);
   if ( self.owner ) {

      total_monsters = (total_monsters + TRUE);
      self.owner.childrenSpawned = (self.owner.childrenSpawned + TRUE);
      WriteByte (MSG_BROADCAST,SVC_UPDATESTAT);
      WriteByte (MSG_BROADCAST,STAT_TOTALMONSTERS);
      WriteLong (MSG_BROADCAST,total_monsters);

   }

};

void () morph_wake2 = [ 2.000, morph_wake3 ] {


};

void () morph_wake3 = [ 3.000, morph_wake4 ] {


};

void () morph_wake4 = [ 4.000, morph_wake5 ] {


};

void () morph_wake5 = [ 5.000, morph_wake6 ] {


};

void () morph_wake6 = [ 6.000, morph_wake7 ] {


};

void () morph_wake7 = [ 7.000, morph_wake8 ] {


};

void () morph_wake8 = [ 8.000, morph_wake9 ] {


};

void () morph_wake9 = [ 9.000, morph_wake10 ] {


};

void () morph_wake10 = [ 10.000, morph_wake11 ] {


};

void () morph_wake11 = [ 11.000, morph_wake12 ] {


};

void () morph_wake12 = [ 12.000, morph_wake13 ] {


};

void () morph_wake13 = [ 13.000, morph_wake14 ] {


};

void () morph_wake14 = [ 14.000, morph_wake15 ] {


};

void () morph_wake15 = [ 15.000, morph_wake16 ] {

   self.skin = TRUE;

};

void () morph_wake16 = [ 16.000, morph_wake17 ] {


};

void () morph_wake17 = [ 17.000, morph_wake18 ] {


};

void () morph_wake18 = [ 18.000, morph_wake20 ] {


};

void () morph_wake20 = [ 20.000, morph_wake21 ] {


};

void () morph_wake21 = [ 21.000, morph_wake22 ] {


};

void () morph_wake22 = [ 22.000, morph_wake23 ] {


};

void () morph_wake23 = [ 23.000, morph_wake24 ] {


};

void () morph_wake24 = [ 24.000, morph_wake25 ] {


};

void () morph_wake25 = [ 25.000, morph_wake26 ] {


};

void () morph_wake26 = [ 26.000, morph_wake27 ] {


};

void () morph_wake27 = [ 27.000, morph_wake28 ] {


};

void () morph_wake28 = [ 28.000, morph_wake29 ] {


};

void () morph_wake29 = [ 29.000, morph_wake30 ] {


};

void () morph_wake30 = [ 30.000, morph_wake31 ] {


};

void () morph_wake31 = [ 31.000, morph_stand1 ] {

   self.solid = SOLID_SLIDEBOX;
   self.takedamage = DAMAGE_AIM;
   self.skin = (self.skin - TRUE);
   if ( self.owner ) {

      self.think = morph_run1;
      self.nextthink = (time + 0.100);

   }

};

void (entity theMorph) morph_setup = {

   theMorph.solid = SOLID_SLIDEBOX;
   theMorph.movetype = MOVETYPE_STEP;
   theMorph.takedamage = DAMAGE_NO;
   theMorph.flags = (theMorph.flags | FL_MONSTER);
   theMorph.ideal_yaw = (theMorph.angles * '0.000 1.000 0.000');
   if ( !theMorph.yaw_speed ) {

      theMorph.yaw_speed = 20.000;

   }
   theMorph.view_ofs = '0.000 0.000 25.000';
   theMorph.frame = TRUE;
   setmodel (theMorph,theMorph.model);
   setsize (theMorph,VEC_HULL_MIN,VEC_HULL_MAX);
   theMorph.th_stand = morph_stand1;
   theMorph.th_walk = morph_walk1;
   theMorph.th_run = morph_run1;
   theMorph.th_missile = morph_fire1;
   theMorph.th_melee = morph_attack;
   theMorph.th_pain = morph_pain;
   theMorph.th_die = morph_die;
   if ( theMorph.owner ) {

      theMorph.effects = FALSE;
      theMorph.health = 200.000;
      theMorph.spawnflags = theMorph.owner.spawnflags;

   } else {

      theMorph.effects = (theMorph.effects | EF_DIMLIGHT);
      theMorph.health = 2000.000;

   }
   theMorph.skin = FL_SWIM;

};

void () morph_wake = {

   if ( isSpawnPointEmpty (self) ) {

      morph_setup (self);
      self.think = morph_wake1;

   } else {

      self.think = morph_wake;

   }
   self.nextthink = (time + 0.100);

};

void () morph_use = {

   if ( self.delay ) {

      self.think = morph_wake;
      self.nextthink = (time + self.delay);

   } else {

      self.think = morph_wake;
      self.nextthink = (time + 0.100);

   }

};

void () morph_teleport = {

   local entity theDest;
   local entity theChild;

   if ( self.owner ) {

      return ;

   }
   if ( (self.childrenSpawned > (TRUE + skill)) ) {

      return ;

   }
   theDest = overlord_find_dest3 ();
   if ( (theDest == world) ) {

      return ;

   }
   theChild = spawn ();
   theChild.model = self.model;
   theChild.angles = theDest.mangle;
   theChild.owner = self;
   theChild.enemy = self.enemy;
   theChild.movetarget = self.movetarget;
   theChild.goalentity = self.goalentity;
   theChild.mangle = theDest.mangle;
   theChild.classname = "monster_morph";
   morph_setup (theChild);
   setorigin (theChild,theDest.origin);
   droptofloor ();
   theChild.think = morph_wake1;
   theChild.nextthink = (time + 0.300);

};

void () monster_morph = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   if ( (self.spawnflags & MORPH_AZTEC) ) {

      precache_model ("progs/morph_az.mdl");
      self.model = "progs/morph_az.mdl";

   } else {

      if ( (self.spawnflags & MORPH_EGYPT) ) {

         precache_model ("progs/morph_eg.mdl");
         self.model = "progs/morph_eg.mdl";

      } else {

         if ( (self.spawnflags & MORPH_GREEK) ) {

            precache_model ("progs/morph_gr.mdl");
            self.model = "progs/morph_gr.mdl";

         } else {

            objerror ("monster_morph: no skin selection!");

         }

      }

   }
   precache_model2 ("progs/laser.mdl");
   precache_sound2 ("enforcer/enfire.wav");
   precache_sound2 ("guard/death.wav");
   precache_sound2 ("guard/pain1.wav");
   precache_sound2 ("guard/see1.wav");
   total_monsters = (total_monsters + TRUE);
   if ( self.targetname ) {

      self.use = morph_use;

   } else {

      morph_wake ();

   }

};
