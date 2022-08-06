
void () Laser_Touch = {

   local vector org;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   sound (self,CHAN_WEAPON,"enforcer/enfstop.wav",TRUE,ATTN_STATIC);
   org = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   if ( other.health ) {

      SpawnBlood (org,(self.velocity * 0.200),15.000);
      T_Damage (other,self,self.owner,15.000);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }
   remove (self);

};

void (vector org, vector vec) LaunchLaser = {

   if ( (self.classname == "monster_enforcer") ) {

      sound (self,CHAN_WEAPON,"enforcer/enfire.wav",TRUE,ATTN_NORM);

   }
   vec = normalize (vec);
   newmis = spawn ();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLY;
   newmis.solid = SOLID_BBOX;
   newmis.effects = EF_DIMLIGHT;
   setmodel (newmis,"progs/laser.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.velocity = (vec * 600.000);
   newmis.angles = vectoangles (newmis.velocity);
   newmis.nextthink = (time + MOVETYPE_FLY);
   newmis.think = SUB_Remove;
   newmis.touch = Laser_Touch;

};

void () enforcer_fire = {

   local vector org;

   self.effects = (self.effects | EF_MUZZLEFLASH);
   makevectors (self.angles);
   org = (((self.origin + (v_forward * SVC_INTERMISSION)) + (v_right * 8.500)) + '0.000 0.000 16.000');
   LaunchLaser (org,(self.enemy.origin - self.origin));

};

void () enf_stand1 = [ 0.000, enf_stand2 ] {

   ai_stand ();

};

void () enf_stand2 = [ 1.000, enf_stand3 ] {

   ai_stand ();

};

void () enf_stand3 = [ 2.000, enf_stand4 ] {

   ai_stand ();

};

void () enf_stand4 = [ 3.000, enf_stand5 ] {

   ai_stand ();

};

void () enf_stand5 = [ 4.000, enf_stand6 ] {

   ai_stand ();

};

void () enf_stand6 = [ 5.000, enf_stand7 ] {

   ai_stand ();

};

void () enf_stand7 = [ 6.000, enf_stand1 ] {

   ai_stand ();

};

void () enf_walk1 = [ 7.000, enf_walk2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"enforcer/idle1.wav",TRUE,ATTN_IDLE);

   }
   ai_walk (FL_SWIM);

};

void () enf_walk2 = [ 8.000, enf_walk3 ] {

   ai_walk (MOVETYPE_STEP);

};

void () enf_walk3 = [ 9.000, enf_walk4 ] {

   ai_walk (MOVETYPE_STEP);

};

void () enf_walk4 = [ 10.000, enf_walk5 ] {

   ai_walk (MOVETYPE_WALK);

};

void () enf_walk5 = [ 11.000, enf_walk6 ] {

   ai_walk (TRUE);

};

void () enf_walk6 = [ 12.000, enf_walk7 ] {

   ai_walk (FL_SWIM);

};

void () enf_walk7 = [ 13.000, enf_walk8 ] {

   ai_walk (FL_SWIM);

};

void () enf_walk8 = [ 14.000, enf_walk9 ] {

   ai_walk (TRUE);

};

void () enf_walk9 = [ 15.000, enf_walk10 ] {

   ai_walk (FL_SWIM);

};

void () enf_walk10 = [ 16.000, enf_walk11 ] {

   ai_walk (MOVETYPE_STEP);

};

void () enf_walk11 = [ 17.000, enf_walk12 ] {

   ai_walk (MOVETYPE_STEP);

};

void () enf_walk12 = [ 18.000, enf_walk13 ] {

   ai_walk (TRUE);

};

void () enf_walk13 = [ 19.000, enf_walk14 ] {

   ai_walk (FL_SWIM);

};

void () enf_walk14 = [ 20.000, enf_walk15 ] {

   ai_walk (MOVETYPE_WALK);

};

void () enf_walk15 = [ 21.000, enf_walk16 ] {

   ai_walk (MOVETYPE_STEP);

};

void () enf_walk16 = [ 22.000, enf_walk1 ] {

   ai_walk (FL_SWIM);

};

void () enf_run1 = [ 23.000, enf_run2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"enforcer/idle1.wav",TRUE,ATTN_IDLE);

   }
   ai_run (18.000);

};

void () enf_run2 = [ 24.000, enf_run3 ] {

   ai_run (14.000);

};

void () enf_run3 = [ 25.000, enf_run4 ] {

   ai_run (MOVETYPE_PUSH);

};

void () enf_run4 = [ 26.000, enf_run5 ] {

   ai_run (12.000);

};

void () enf_run5 = [ 27.000, enf_run6 ] {

   ai_run (14.000);

};

void () enf_run6 = [ 28.000, enf_run7 ] {

   ai_run (14.000);

};

void () enf_run7 = [ 29.000, enf_run8 ] {

   ai_run (MOVETYPE_PUSH);

};

void () enf_run8 = [ 30.000, enf_run1 ] {

   ai_run (MOVETYPE_BOUNCEMISSILE);

};

void () enf_atk1 = [ 31.000, enf_atk2 ] {

   ai_face ();

};

void () enf_atk2 = [ 32.000, enf_atk3 ] {

   ai_face ();

};

void () enf_atk3 = [ 33.000, enf_atk4 ] {

   ai_face ();

};

void () enf_atk4 = [ 34.000, enf_atk5 ] {

   ai_face ();

};

void () enf_atk5 = [ 35.000, enf_atk6 ] {

   ai_face ();

};

void () enf_atk6 = [ 36.000, enf_atk7 ] {

   enforcer_fire ();

};

void () enf_atk7 = [ 37.000, enf_atk8 ] {

   ai_face ();

};

void () enf_atk8 = [ 38.000, enf_atk9 ] {

   ai_face ();

};

void () enf_atk9 = [ 35.000, enf_atk10 ] {

   ai_face ();

};

void () enf_atk10 = [ 36.000, enf_atk11 ] {

   enforcer_fire ();

};

void () enf_atk11 = [ 37.000, enf_atk12 ] {

   ai_face ();

};

void () enf_atk12 = [ 38.000, enf_atk13 ] {

   ai_face ();

};

void () enf_atk13 = [ 39.000, enf_atk14 ] {

   ai_face ();

};

void () enf_atk14 = [ 40.000, enf_run1 ] {

   ai_face ();
   SUB_CheckRefire (enf_atk1);

};

void () enf_paina1 = [ 66.000, enf_paina2 ] {


};

void () enf_paina2 = [ 67.000, enf_paina3 ] {


};

void () enf_paina3 = [ 68.000, enf_paina4 ] {


};

void () enf_paina4 = [ 69.000, enf_run1 ] {


};

void () enf_painb1 = [ 70.000, enf_painb2 ] {


};

void () enf_painb2 = [ 71.000, enf_painb3 ] {


};

void () enf_painb3 = [ 72.000, enf_painb4 ] {


};

void () enf_painb4 = [ 73.000, enf_painb5 ] {


};

void () enf_painb5 = [ 74.000, enf_run1 ] {


};

void () enf_painc1 = [ 75.000, enf_painc2 ] {


};

void () enf_painc2 = [ 76.000, enf_painc3 ] {


};

void () enf_painc3 = [ 77.000, enf_painc4 ] {


};

void () enf_painc4 = [ 78.000, enf_painc5 ] {


};

void () enf_painc5 = [ 79.000, enf_painc6 ] {


};

void () enf_painc6 = [ 80.000, enf_painc7 ] {


};

void () enf_painc7 = [ 81.000, enf_painc8 ] {


};

void () enf_painc8 = [ 82.000, enf_run1 ] {


};

void () enf_paind1 = [ 83.000, enf_paind2 ] {


};

void () enf_paind2 = [ 84.000, enf_paind3 ] {


};

void () enf_paind3 = [ 85.000, enf_paind4 ] {


};

void () enf_paind4 = [ 86.000, enf_paind5 ] {

   ai_painforward (FL_SWIM);

};

void () enf_paind5 = [ 87.000, enf_paind6 ] {

   ai_painforward (TRUE);

};

void () enf_paind6 = [ 88.000, enf_paind7 ] {


};

void () enf_paind7 = [ 89.000, enf_paind8 ] {


};

void () enf_paind8 = [ 90.000, enf_paind9 ] {


};

void () enf_paind9 = [ 91.000, enf_paind10 ] {


};

void () enf_paind10 = [ 92.000, enf_paind11 ] {


};

void () enf_paind11 = [ 93.000, enf_paind12 ] {

   ai_painforward (TRUE);

};

void () enf_paind12 = [ 94.000, enf_paind13 ] {

   ai_painforward (TRUE);

};

void () enf_paind13 = [ 95.000, enf_paind14 ] {

   ai_painforward (TRUE);

};

void () enf_paind14 = [ 96.000, enf_paind15 ] {


};

void () enf_paind15 = [ 97.000, enf_paind16 ] {


};

void () enf_paind16 = [ 98.000, enf_paind17 ] {

   ai_pain (TRUE);

};

void () enf_paind17 = [ 99.000, enf_paind18 ] {

   ai_pain (TRUE);

};

void () enf_paind18 = [ 100.000, enf_paind19 ] {


};

void () enf_paind19 = [ 101.000, enf_run1 ] {


};

void (entity attacker, float damage) enf_pain = {

   local float r;

   r = random ();
   if ( (self.pain_finished > time) ) {

      return ;

   }
   if ( (r < 0.500) ) {

      sound (self,CHAN_VOICE,"enforcer/pain1.wav",TRUE,ATTN_NORM);

   } else {

      sound (self,CHAN_VOICE,"enforcer/pain2.wav",TRUE,ATTN_NORM);

   }
   if ( (r < 0.200) ) {

      self.pain_finished = (time + TRUE);
      enf_paina1 ();

   } else {

      if ( (r < 0.400) ) {

         self.pain_finished = (time + TRUE);
         enf_painb1 ();

      } else {

         if ( (r < 0.700) ) {

            self.pain_finished = (time + TRUE);
            enf_painc1 ();

         } else {

            self.pain_finished = (time + FL_SWIM);
            enf_paind1 ();

         }

      }

   }

};

void () enf_die1 = [ 41.000, enf_die2 ] {


};

void () enf_die2 = [ 42.000, enf_die3 ] {


};

void () enf_die3 = [ 43.000, enf_die4 ] {

   self.solid = SOLID_NOT;
   self.ammo_cells1 = MOVETYPE_FLY;
   DropBackpack ();

};

void () enf_die4 = [ 44.000, enf_die5 ] {

   ai_forward (14.000);

};

void () enf_die5 = [ 45.000, enf_die6 ] {

   ai_forward (FL_SWIM);

};

void () enf_die6 = [ 46.000, enf_die7 ] {


};

void () enf_die7 = [ 47.000, enf_die8 ] {


};

void () enf_die8 = [ 48.000, enf_die9 ] {


};

void () enf_die9 = [ 49.000, enf_die10 ] {

   ai_forward (MOVETYPE_WALK);

};

void () enf_die10 = [ 50.000, enf_die11 ] {

   ai_forward (MOVETYPE_FLY);

};

void () enf_die11 = [ 51.000, enf_die12 ] {

   ai_forward (MOVETYPE_FLY);

};

void () enf_die12 = [ 52.000, enf_die13 ] {

   ai_forward (MOVETYPE_FLY);

};

void () enf_die13 = [ 53.000, enf_die14 ] {


};

void () enf_die14 = [ 54.000, enf_die14 ] {

   if (bodyfade) {

      self.think = body_kill;
      self.nextthink = (time + 60.000);

   }

};

void () enf_fdie1 = [ 55.000, enf_fdie2 ] {


};

void () enf_fdie2 = [ 56.000, enf_fdie3 ] {


};

void () enf_fdie3 = [ 57.000, enf_fdie4 ] {

   self.solid = SOLID_NOT;
   self.ammo_cells1 = MOVETYPE_FLY;
   DropBackpack ();

};

void () enf_fdie4 = [ 58.000, enf_fdie5 ] {


};

void () enf_fdie5 = [ 59.000, enf_fdie6 ] {


};

void () enf_fdie6 = [ 60.000, enf_fdie7 ] {


};

void () enf_fdie7 = [ 61.000, enf_fdie8 ] {


};

void () enf_fdie8 = [ 62.000, enf_fdie9 ] {


};

void () enf_fdie9 = [ 63.000, enf_fdie10 ] {


};

void () enf_fdie10 = [ 64.000, enf_fdie11 ] {


};

void () enf_fdie11 = [ 65.000, enf_fdie11 ] {

   if (bodyfade) {

      self.think = body_kill;
      self.nextthink = (time + 60.000);

   }

};

void () enf_die = {

   if ( (self.health < -35.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_mega.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health, GIB_FLESH);
      ThrowGib ("progs/gib2.mdl",self.health, GIB_FLESH);
      ThrowGib ("progs/gib3.mdl",self.health, GIB_FLESH);
      return ;

   }
   sound (self,CHAN_VOICE,"enforcer/death1.wav",TRUE,ATTN_NORM);
   if ( (random () > 0.500) ) {

      enf_die1 ();

   } else {

      enf_fdie1 ();

   }

};

void () monster_enforcer = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/enforcer.mdl");
   precache_model2 ("progs/h_mega.mdl");
   precache_model2 ("progs/laser.mdl");
   precache_sound2 ("enforcer/death1.wav");
   precache_sound2 ("enforcer/enfire.wav");
   precache_sound2 ("enforcer/enfstop.wav");
   precache_sound2 ("enforcer/idle1.wav");
   precache_sound2 ("enforcer/pain1.wav");
   precache_sound2 ("enforcer/pain2.wav");
   precache_sound2 ("enforcer/sight1.wav");
   precache_sound2 ("enforcer/sight2.wav");
   precache_sound2 ("enforcer/sight3.wav");
   precache_sound2 ("enforcer/sight4.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/enforcer.mdl");
   setsize (self,VEC_HULL_MIN,'16.000 16.000 40.000');
   self.health = 80.000;
   self.th_stand = enf_stand1;
   self.th_walk = enf_walk1;
   self.th_run = enf_run1;
   self.th_pain = enf_pain;
   self.th_die = enf_die;
   self.th_missile = enf_atk1;
   walkmonster_start ();

};
