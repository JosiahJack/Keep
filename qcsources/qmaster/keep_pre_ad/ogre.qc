float OGRE_BOSS    = 2.000;
float OGRE_NORMAL    = 4.000;

void () OgreGrenadeExplode = {

   T_RadiusDamage (self,self.owner,CTF_FLAG_RETURN_TIME,world);
   sound (self,CHAN_VOICE,"weapons/r_exp3.wav",TRUE,ATTN_NORM);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   self.velocity = VEC_ORIGIN;
   self.touch = SUB_Null;
   setmodel (self,"progs/s_explod.spr");
   self.solid = SOLID_NOT;
   s_explode1 ();

};

void () OgreGrenadeTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.takedamage == DAMAGE_AIM) ) {

      OgreGrenadeExplode ();
      return ;

   }
   sound (self,CHAN_VOICE,"weapons/bounce.wav",TRUE,ATTN_NORM);
   if ( (self.velocity == VEC_ORIGIN) ) {

      self.avelocity = VEC_ORIGIN;

   }

};

void () MultiGrenadeTouch;

void () MultiGrenadeExplode;

void () OgreFireGrenade = {

   local entity missile;

   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"weapons/grenade.wav",TRUE,ATTN_NORM);
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "ogre_grenade";
   makevectors (self.angles);
   missile.velocity = normalize ((self.enemy.origin - self.origin));
   missile.velocity = (missile.velocity * 600.000);
   missile.velocity_z = 200.000;
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   if ( (self.spawnflags & OGRE_BOSS) ) {

      missile.touch = MultiGrenadeTouch;
      missile.nextthink = (time + 2.500);
      missile.think = MultiGrenadeExplode;
      setmodel (missile,"progs/mervup.mdl");
      setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
      setorigin (missile,self.origin);
      missile.classname = "MultiGrenade";

   } else {

      missile.touch = OgreGrenadeTouch;
      missile.nextthink = (time + 2.500);
      missile.think = OgreGrenadeExplode;
      setmodel (missile,"progs/grenade.mdl");
      setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
      setorigin (missile,self.origin);

   }

};

void (float side) chainsaw = {

   local vector delta;
   local float ldmg;

   if ( !self.enemy ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   ai_charge (MOVETYPE_BOUNCE);
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 100.000) ) {

      return ;

   }
   ldmg = (((random () + random ()) + random ()) * MOVETYPE_STEP);
   T_Damage (self.enemy,self,self,ldmg);
   if ( side ) {

      makevectors (self.angles);
      if ( (side == TRUE) ) {

         SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),((crandom () * 100.000) * v_right));

      } else {

         SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),(side * v_right));

      }

   }

};

void () ogre_stand1 = [ 0.000, ogre_stand2 ] {

   ai_stand ();

};

void () ogre_stand2 = [ 1.000, ogre_stand3 ] {

   ai_stand ();

};

void () ogre_stand3 = [ 2.000, ogre_stand4 ] {

   ai_stand ();

};

void () ogre_stand4 = [ 3.000, ogre_stand5 ] {

   ai_stand ();

};

void () ogre_stand5 = [ 4.000, ogre_stand6 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"ogre/ogidle.wav",TRUE,ATTN_IDLE);

   }
   ai_stand ();

};

void () ogre_stand6 = [ 5.000, ogre_stand7 ] {

   ai_stand ();

};

void () ogre_stand7 = [ 6.000, ogre_stand8 ] {

   ai_stand ();

};

void () ogre_stand8 = [ 7.000, ogre_stand9 ] {

   ai_stand ();

};

void () ogre_stand9 = [ 8.000, ogre_stand1 ] {

   ai_stand ();

};

void () ogre_walk1 = [ 9.000, ogre_walk2 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk2 = [ 10.000, ogre_walk3 ] {

   ai_walk (FL_SWIM);

};

void () ogre_walk3 = [ 11.000, ogre_walk4 ] {

   ai_walk (FL_SWIM);
   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"ogre/ogidle.wav",TRUE,ATTN_IDLE);

   }

};

void () ogre_walk4 = [ 12.000, ogre_walk5 ] {

   ai_walk (FL_SWIM);

};

void () ogre_walk5 = [ 13.000, ogre_walk6 ] {

   ai_walk (FL_SWIM);

};

void () ogre_walk6 = [ 14.000, ogre_walk7 ] {

   ai_walk (MOVETYPE_FLY);
   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"ogre/ogdrag.wav",TRUE,ATTN_IDLE);

   }

};

void () ogre_walk7 = [ 15.000, ogre_walk8 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk8 = [ 16.000, ogre_walk9 ] {

   ai_walk (FL_SWIM);

};

void () ogre_walk9 = [ 17.000, ogre_walk10 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk10 = [ 18.000, ogre_walk11 ] {

   ai_walk (TRUE);

};

void () ogre_walk11 = [ 19.000, ogre_walk12 ] {

   ai_walk (FL_SWIM);

};

void () ogre_walk12 = [ 20.000, ogre_walk13 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk13 = [ 21.000, ogre_walk14 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk14 = [ 22.000, ogre_walk15 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk15 = [ 23.000, ogre_walk16 ] {

   ai_walk (MOVETYPE_WALK);

};

void () ogre_walk16 = [ 24.000, ogre_walk1 ] {

   ai_walk (MOVETYPE_STEP);

};

void () ogre_run1 = [ 25.000, ogre_run2 ] {

   ai_run (MOVETYPE_FLYMISSILE);
   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"ogre/ogidle2.wav",TRUE,ATTN_IDLE);

   }

};

void () ogre_run2 = [ 26.000, ogre_run3 ] {

   ai_run (STAT_TOTALMONSTERS);

};

void () ogre_run3 = [ 27.000, ogre_run4 ] {

   ai_run (FL_CLIENT);

};

void () ogre_run4 = [ 28.000, ogre_run5 ] {

   ai_run (22.000);

};

void () ogre_run5 = [ 29.000, ogre_run6 ] {

   ai_run (FL_INWATER);

};

void () ogre_run6 = [ 30.000, ogre_run7 ] {

   ai_run (MOVETYPE_STEP);

};

void () ogre_run7 = [ 31.000, ogre_run8 ] {

   ai_run (TE_BEAM);

};

void () ogre_run8 = [ 32.000, ogre_run1 ] {

   ai_run (24.000);

};

void () ogre_swing1 = [ 33.000, ogre_swing2 ] {

   ai_charge (MOVETYPE_BOUNCEMISSILE);
   sound (self,CHAN_WEAPON,"ogre/ogsawatk.wav",TRUE,ATTN_NORM);

};

void () ogre_swing2 = [ 34.000, ogre_swing3 ] {

   ai_charge (TRUE);

};

void () ogre_swing3 = [ 35.000, ogre_swing4 ] {

   ai_charge (MOVETYPE_STEP);

};

void () ogre_swing4 = [ 36.000, ogre_swing5 ] {

   ai_charge (TE_BEAM);

};

void () ogre_swing5 = [ 37.000, ogre_swing6 ] {

   ai_charge (MOVETYPE_FLYMISSILE);
   chainsaw (FALSE);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing6 = [ 38.000, ogre_swing7 ] {

   chainsaw (200.000);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing7 = [ 39.000, ogre_swing8 ] {

   chainsaw (FALSE);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing8 = [ 40.000, ogre_swing9 ] {

   chainsaw (FALSE);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing9 = [ 41.000, ogre_swing10 ] {

   chainsaw (FALSE);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing10 = [ 42.000, ogre_swing11 ] {

   chainsaw (-200.000);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing11 = [ 43.000, ogre_swing12 ] {

   chainsaw (FALSE);
   self.angles_y = (self.angles_y + (random () * 25.000));

};

void () ogre_swing12 = [ 44.000, ogre_swing13 ] {

   ai_charge (MOVETYPE_WALK);

};

void () ogre_swing13 = [ 45.000, ogre_swing14 ] {

   ai_charge (FL_CLIENT);

};

void () ogre_swing14 = [ 46.000, ogre_run1 ] {

   ai_charge (MOVETYPE_FLYMISSILE);

};

void () ogre_smash1 = [ 47.000, ogre_smash2 ] {

   ai_charge (MOVETYPE_TOSS);
   sound (self,CHAN_WEAPON,"ogre/ogsawatk.wav",TRUE,ATTN_NORM);

};

void () ogre_smash2 = [ 48.000, ogre_smash3 ] {

   ai_charge (FALSE);

};

void () ogre_smash3 = [ 49.000, ogre_smash4 ] {

   ai_charge (FALSE);

};

void () ogre_smash4 = [ 50.000, ogre_smash5 ] {

   ai_charge (TRUE);

};

void () ogre_smash5 = [ 51.000, ogre_smash6 ] {

   ai_charge (MOVETYPE_STEP);

};

void () ogre_smash6 = [ 52.000, ogre_smash7 ] {

   ai_charge (MOVETYPE_STEP);
   chainsaw (FALSE);

};

void () ogre_smash7 = [ 53.000, ogre_smash8 ] {

   ai_charge (MOVETYPE_STEP);
   chainsaw (FALSE);

};

void () ogre_smash8 = [ 54.000, ogre_smash9 ] {

   ai_charge (MOVETYPE_BOUNCE);
   chainsaw (FALSE);

};

void () ogre_smash9 = [ 55.000, ogre_smash10 ] {

   ai_charge (TE_BEAM);
   chainsaw (FALSE);

};

void () ogre_smash10 = [ 56.000, ogre_smash11 ] {

   chainsaw (TRUE);

};

void () ogre_smash11 = [ 57.000, ogre_smash12 ] {

   ai_charge (FL_SWIM);
   chainsaw (FALSE);
   self.nextthink = (self.nextthink + (random () * 0.200));

};

void () ogre_smash12 = [ 58.000, ogre_smash13 ] {

   ai_charge (TRUE);

};

void () ogre_smash13 = [ 59.000, ogre_smash14 ] {

   ai_charge (MOVETYPE_STEP);

};

void () ogre_smash14 = [ 60.000, ogre_run1 ] {

   ai_charge (STAT_TOTALMONSTERS);

};

void () ogre_nail1 = [ 61.000, ogre_nail2 ] {

   ai_face ();

};

void () ogre_nail2 = [ 62.000, ogre_nail3 ] {

   ai_face ();

};

void () ogre_nail3 = [ 62.000, ogre_nail4 ] {

   ai_face ();

};

void () ogre_nail4 = [ 63.000, ogre_nail5 ] {

   ai_face ();
   OgreFireGrenade ();

};

void () ogre_nail5 = [ 64.000, ogre_nail6 ] {

   ai_face ();

};

void () ogre_nail6 = [ 65.000, ogre_nail7 ] {

   ai_face ();

};

void () ogre_nail7 = [ 66.000, ogre_run1 ] {

   ai_face ();

};

void () ogre_pain1 = [ 67.000, ogre_pain2 ] {


};

void () ogre_pain2 = [ 68.000, ogre_pain3 ] {


};

void () ogre_pain3 = [ 69.000, ogre_pain4 ] {


};

void () ogre_pain4 = [ 70.000, ogre_pain5 ] {


};

void () ogre_pain5 = [ 71.000, ogre_run1 ] {


};

void () ogre_painb1 = [ 72.000, ogre_painb2 ] {


};

void () ogre_painb2 = [ 73.000, ogre_painb3 ] {


};

void () ogre_painb3 = [ 74.000, ogre_run1 ] {


};

void () ogre_painc1 = [ 75.000, ogre_painc2 ] {


};

void () ogre_painc2 = [ 76.000, ogre_painc3 ] {


};

void () ogre_painc3 = [ 77.000, ogre_painc4 ] {


};

void () ogre_painc4 = [ 78.000, ogre_painc5 ] {


};

void () ogre_painc5 = [ 79.000, ogre_painc6 ] {


};

void () ogre_painc6 = [ 80.000, ogre_run1 ] {


};

void () ogre_paind1 = [ 81.000, ogre_paind2 ] {


};

void () ogre_paind2 = [ 82.000, ogre_paind3 ] {

   ai_pain (MOVETYPE_BOUNCE);

};

void () ogre_paind3 = [ 83.000, ogre_paind4 ] {

   ai_pain (MOVETYPE_FLYMISSILE);

};

void () ogre_paind4 = [ 84.000, ogre_paind5 ] {

   ai_pain (MOVETYPE_STEP);

};

void () ogre_paind5 = [ 85.000, ogre_paind6 ] {


};

void () ogre_paind6 = [ 86.000, ogre_paind7 ] {


};

void () ogre_paind7 = [ 87.000, ogre_paind8 ] {


};

void () ogre_paind8 = [ 88.000, ogre_paind9 ] {


};

void () ogre_paind9 = [ 89.000, ogre_paind10 ] {


};

void () ogre_paind10 = [ 90.000, ogre_paind11 ] {


};

void () ogre_paind11 = [ 91.000, ogre_paind12 ] {


};

void () ogre_paind12 = [ 92.000, ogre_paind13 ] {


};

void () ogre_paind13 = [ 93.000, ogre_paind14 ] {


};

void () ogre_paind14 = [ 94.000, ogre_paind15 ] {


};

void () ogre_paind15 = [ 95.000, ogre_paind16 ] {


};

void () ogre_paind16 = [ 96.000, ogre_run1 ] {


};

void () ogre_paine1 = [ 97.000, ogre_paine2 ] {


};

void () ogre_paine2 = [ 98.000, ogre_paine3 ] {

   ai_pain (MOVETYPE_BOUNCE);

};

void () ogre_paine3 = [ 99.000, ogre_paine4 ] {

   ai_pain (MOVETYPE_FLYMISSILE);

};

void () ogre_paine4 = [ 100.000, ogre_paine5 ] {

   ai_pain (MOVETYPE_STEP);

};

void () ogre_paine5 = [ 101.000, ogre_paine6 ] {


};

void () ogre_paine6 = [ 102.000, ogre_paine7 ] {


};

void () ogre_paine7 = [ 103.000, ogre_paine8 ] {


};

void () ogre_paine8 = [ 104.000, ogre_paine9 ] {


};

void () ogre_paine9 = [ 105.000, ogre_paine10 ] {


};

void () ogre_paine10 = [ 106.000, ogre_paine11 ] {


};

void () ogre_paine11 = [ 107.000, ogre_paine12 ] {


};

void () ogre_paine12 = [ 108.000, ogre_paine13 ] {


};

void () ogre_paine13 = [ 109.000, ogre_paine14 ] {


};

void () ogre_paine14 = [ 110.000, ogre_paine15 ] {


};

void () ogre_paine15 = [ 111.000, ogre_run1 ] {


};

void (entity attacker, float damage) ogre_pain = {

   local float r;

   if ( (self.pain_finished > time) ) {

      return ;

   }
   sound (self,CHAN_VOICE,"ogre/ogpain1.wav",TRUE,ATTN_NORM);
   r = random ();
   if ( (r < 0.250) ) {

      ogre_pain1 ();
      self.pain_finished = (time + TRUE);

   } else {

      if ( (r < 0.500) ) {

         ogre_painb1 ();
         self.pain_finished = (time + TRUE);

      } else {

         if ( (r < 0.750) ) {

            ogre_painc1 ();
            self.pain_finished = (time + TRUE);

         } else {

            if ( (r < 0.880) ) {

               ogre_paind1 ();
               self.pain_finished = (time + FL_SWIM);

            } else {

               ogre_paine1 ();
               self.pain_finished = (time + FL_SWIM);

            }

         }

      }

   }

};

void () ogre_die1 = [ 112.000, ogre_die2 ] {


};

void () ogre_die2 = [ 113.000, ogre_die3 ] {


};

void () ogre_die3 = [ 114.000, ogre_die4 ] {

   self.solid = SOLID_NOT;
   self.ammo_rockets1 = FL_SWIM;
   DropBackpack ();

};

void () ogre_die4 = [ 115.000, ogre_die5 ] {


};

void () ogre_die5 = [ 116.000, ogre_die6 ] {


};

void () ogre_die6 = [ 117.000, ogre_die7 ] {


};

void () ogre_die7 = [ 118.000, ogre_die8 ] {


};

void () ogre_die8 = [ 119.000, ogre_die9 ] {


};

void () ogre_die9 = [ 120.000, ogre_die10 ] {


};

void () ogre_die10 = [ 121.000, ogre_die11 ] {


};

void () ogre_die11 = [ 122.000, ogre_die12 ] {


};

void () ogre_die12 = [ 123.000, ogre_die13 ] {


};

void () ogre_die13 = [ 124.000, ogre_die14 ] {


};

void () ogre_die14 = [ 125.000, ogre_die14 ] {

   if (bodyfade) {

      self.think = body_kill;
      self.nextthink = (time + 60.000);

   }

};

void () ogre_bdie1 = [ 126.000, ogre_bdie2 ] {



};

void () ogre_bdie2 = [ 127.000, ogre_bdie3 ] {

   ai_forward (MOVETYPE_FLY);

};

void () ogre_bdie3 = [ 128.000, ogre_bdie4 ] {

   self.solid = SOLID_NOT;
   self.ammo_rockets1 = FL_SWIM;
   DropBackpack ();

};

void () ogre_bdie4 = [ 129.000, ogre_bdie5 ] {

   ai_forward (TRUE);

};

void () ogre_bdie5 = [ 130.000, ogre_bdie6 ] {

   ai_forward (MOVETYPE_WALK);

};

void () ogre_bdie6 = [ 131.000, ogre_bdie7 ] {

   ai_forward (MOVETYPE_PUSH);

};

void () ogre_bdie7 = [ 132.000, ogre_bdie8 ] {

   ai_forward (25.000);

};

void () ogre_bdie8 = [ 133.000, ogre_bdie9 ] {


};

void () ogre_bdie9 = [ 134.000, ogre_bdie10 ] {


};

void () ogre_bdie10 = [ 135.000, ogre_bdie10 ] {

   if (bodyfade) {

      self.think = body_kill;
      self.nextthink = (time + 60.000);

   }

};

void () ogre_die = {

   if ( (self.health < -80.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_ogre.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health, GIB_FLESH);
      ThrowGib ("progs/gib3.mdl",self.health, GIB_FLESH);
      ThrowGib ("progs/gib3.mdl",self.health, GIB_FLESH);
      return ;

   }
   sound (self,CHAN_VOICE,"ogre/ogdth.wav",TRUE,ATTN_NORM);
   if ( (random () < 0.500) ) {

      ogre_die1 ();

   } else {

      ogre_bdie1 ();

   }

};

void () ogre_melee = {

   if ( (random () > 0.500) ) {

      ogre_smash1 ();

   } else {

      ogre_swing1 ();

   }

};

void () monster_ogre = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/ogre.mdl");
   precache_model ("progs/h_ogre.mdl");
   precache_model ("progs/grenade.mdl");
   precache_sound ("ogre/ogdrag.wav");
   precache_sound ("ogre/ogdth.wav");
   precache_sound ("ogre/ogidle.wav");
   precache_sound ("ogre/ogidle2.wav");
   precache_sound ("ogre/ogpain1.wav");
   precache_sound ("ogre/ogsawatk.wav");
   precache_sound ("ogre/ogwake.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/ogre.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = 200.000;
   self.th_stand = ogre_stand1;
   self.th_walk = ogre_walk1;
   self.th_run = ogre_run1;
   self.th_die = ogre_die;
   self.th_melee = ogre_melee;
   self.th_missile = ogre_nail1;
   self.th_pain = ogre_pain;
   walkmonster_start ();

};

void () monster_ogre_multi = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/ogre.mdl");
   precache_model ("progs/h_ogre.mdl");
   precache_model ("progs/grenade.mdl");
   precache_sound ("ogre/ogdrag.wav");
   precache_sound ("ogre/ogdth.wav");
   precache_sound ("ogre/ogidle.wav");
   precache_sound ("ogre/ogidle2.wav");
   precache_sound ("ogre/ogpain1.wav");
   precache_sound ("ogre/ogsawatk.wav");
   precache_sound ("ogre/ogwake.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/ogre.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.spawnflags = (self.spawnflags | OGRE_BOSS);
   self.skin = TRUE;
   self.health = 200.000;
   self.th_stand = ogre_stand1;
   self.th_walk = ogre_walk1;
   self.th_run = ogre_run1;
   self.th_die = ogre_die;
   self.th_melee = ogre_melee;
   self.th_missile = ogre_nail1;
   self.th_pain = ogre_pain;
   walkmonster_start ();

};

void () monster_ogre_marksman = {

   monster_ogre ();

};