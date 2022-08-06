float SPAWN_CRUCIFIED    = 1.000;
float SPAWN_LYING    = 2.000;
float SPAWN_AMBUSH    = 4.000;
float SPAWN_SNEAKY    = 8.000;
.float inpain;

void () zombie_escape1;

void () zombie_stand1 = [ 0.000, zombie_stand2 ] {

   ai_stand ();

};

void () zombie_stand2 = [ 1.000, zombie_stand3 ] {

   ai_stand ();

};

void () zombie_stand3 = [ 2.000, zombie_stand4 ] {

   ai_stand ();

};

void () zombie_stand4 = [ 3.000, zombie_stand5 ] {

   ai_stand ();

};

void () zombie_stand5 = [ 4.000, zombie_stand6 ] {

   ai_stand ();

};

void () zombie_stand6 = [ 5.000, zombie_stand7 ] {

   ai_stand ();

};

void () zombie_stand7 = [ 6.000, zombie_stand8 ] {

   ai_stand ();

};

void () zombie_stand8 = [ 7.000, zombie_stand9 ] {

   ai_stand ();

};

void () zombie_stand9 = [ 8.000, zombie_stand10 ] {

   ai_stand ();

};

void () zombie_stand10 = [ 9.000, zombie_stand11 ] {

   ai_stand ();

};

void () zombie_stand11 = [ 10.000, zombie_stand12 ] {

   ai_stand ();

};

void () zombie_stand12 = [ 11.000, zombie_stand13 ] {

   ai_stand ();

};

void () zombie_stand13 = [ 12.000, zombie_stand14 ] {

   ai_stand ();

};

void () zombie_stand14 = [ 13.000, zombie_stand15 ] {

   ai_stand ();

};

void () zombie_stand15 = [ 14.000, zombie_stand1 ] {

   ai_stand ();

};

void () zombie_lurk = {

   if ( (self.spawnflags & SPAWN_SNEAKY) ) {

      if ( !self.pain_finished ) {

         if ( FindTarget () ) {

            return ;

         }

      } else {

         if ( (self.pain_finished < time) ) {

            self.think = zombie_escape1;
            self.nextthink = (time + 0.100);
            return ;

         }

      }

   }
   self.nextthink = ((time + 0.100) + (random () * 0.100));

};

void () zombie_cruc1 = [ 192.000, zombie_cruc2 ] {

   zombie_lurk ();
   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"zombie/idle_w2.wav",TRUE,ATTN_STATIC);

   }

};

void () zombie_cruc2 = [ 193.000, zombie_cruc3 ] {

   zombie_lurk ();

};

void () zombie_cruc3 = [ 194.000, zombie_cruc4 ] {

   zombie_lurk ();

};

void () zombie_cruc4 = [ 195.000, zombie_cruc5 ] {

   zombie_lurk ();

};

void () zombie_cruc5 = [ 196.000, zombie_cruc6 ] {

   zombie_lurk ();

};

void () zombie_cruc6 = [ 197.000, zombie_cruc1 ] {

   zombie_lurk ();

};

void () zombie_walk1 = [ 15.000, zombie_walk2 ] {

   ai_walk (FALSE);

};

void () zombie_walk2 = [ 16.000, zombie_walk3 ] {

   ai_walk (FL_SWIM);

};

void () zombie_walk3 = [ 17.000, zombie_walk4 ] {

   ai_walk (MOVETYPE_WALK);

};

void () zombie_walk4 = [ 18.000, zombie_walk5 ] {

   ai_walk (FL_SWIM);

};

void () zombie_walk5 = [ 19.000, zombie_walk6 ] {

   ai_walk (TRUE);

};

void () zombie_walk6 = [ 20.000, zombie_walk7 ] {

   ai_walk (FALSE);

};

void () zombie_walk7 = [ 21.000, zombie_walk8 ] {

   ai_walk (FALSE);

};

void () zombie_walk8 = [ 22.000, zombie_walk9 ] {

   ai_walk (FALSE);

};

void () zombie_walk9 = [ 23.000, zombie_walk10 ] {

   ai_walk (FALSE);

};

void () zombie_walk10 = [ 24.000, zombie_walk11 ] {

   ai_walk (FALSE);

};

void () zombie_walk11 = [ 25.000, zombie_walk12 ] {

   ai_walk (FL_SWIM);

};

void () zombie_walk12 = [ 26.000, zombie_walk13 ] {

   ai_walk (FL_SWIM);

};

void () zombie_walk13 = [ 27.000, zombie_walk14 ] {

   ai_walk (TRUE);

};

void () zombie_walk14 = [ 28.000, zombie_walk15 ] {

   ai_walk (FALSE);

};

void () zombie_walk15 = [ 29.000, zombie_walk16 ] {

   ai_walk (FALSE);

};

void () zombie_walk16 = [ 30.000, zombie_walk17 ] {

   ai_walk (FALSE);

};

void () zombie_walk17 = [ 31.000, zombie_walk18 ] {

   ai_walk (FALSE);

};

void () zombie_walk18 = [ 32.000, zombie_walk19 ] {

   ai_walk (FALSE);

};

void () zombie_walk19 = [ 33.000, zombie_walk1 ] {

   ai_walk (FALSE);
   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"zombie/z_idle.wav",TRUE,ATTN_IDLE);

   }

};

void () zombie_run1 = [ 34.000, zombie_run2 ] {

   ai_run (TRUE);
   self.inpain = FALSE;

};

void () zombie_run2 = [ 35.000, zombie_run3 ] {

   ai_run (TRUE);

};

void () zombie_run3 = [ 36.000, zombie_run4 ] {

   ai_run (FALSE);

};

void () zombie_run4 = [ 37.000, zombie_run5 ] {

   ai_run (TRUE);

};

void () zombie_run5 = [ 38.000, zombie_run6 ] {

   ai_run (FL_SWIM);

};

void () zombie_run6 = [ 39.000, zombie_run7 ] {

   ai_run (MOVETYPE_WALK);

};

void () zombie_run7 = [ 40.000, zombie_run8 ] {

   ai_run (MOVETYPE_STEP);

};

void () zombie_run8 = [ 41.000, zombie_run9 ] {

   ai_run (MOVETYPE_STEP);

};

void () zombie_run9 = [ 42.000, zombie_run10 ] {

   ai_run (FL_SWIM);

};

void () zombie_run10 = [ 43.000, zombie_run11 ] {

   ai_run (FALSE);

};

void () zombie_run11 = [ 44.000, zombie_run12 ] {

   ai_run (FALSE);

};

void () zombie_run12 = [ 45.000, zombie_run13 ] {

   ai_run (FALSE);

};

void () zombie_run13 = [ 46.000, zombie_run14 ] {

   ai_run (FL_SWIM);

};

void () zombie_run14 = [ 47.000, zombie_run15 ] {

   ai_run (MOVETYPE_STEP);

};

void () zombie_run15 = [ 48.000, zombie_run16 ] {

   ai_run (MOVETYPE_TOSS);

};

void () zombie_run16 = [ 49.000, zombie_run17 ] {

   ai_run (MOVETYPE_PUSH);

};

void () zombie_run17 = [ 50.000, zombie_run18 ] {

   ai_run (MOVETYPE_WALK);

};

void () zombie_run18 = [ 51.000, zombie_run1 ] {

   ai_run (FL_CLIENT);
   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"zombie/z_idle.wav",TRUE,ATTN_IDLE);

   }
   if ( (random () > 0.800) ) {

      sound (self,CHAN_VOICE,"zombie/z_idle1.wav",TRUE,ATTN_IDLE);

   }

};

void () ZombieGrenadeTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( other.takedamage ) {

      T_Damage (other,self,self.owner,MOVETYPE_BOUNCE);
      sound (self,CHAN_WEAPON,"zombie/z_hit.wav",TRUE,ATTN_NORM);
      remove (self);
      return ;

   }
   sound (self,CHAN_WEAPON,"zombie/z_miss.wav",TRUE,ATTN_NORM);
   self.velocity = VEC_ORIGIN;
   self.avelocity = VEC_ORIGIN;
   self.touch = SUB_Remove;

};

void (vector st) ZombieFireGrenade = {

   local entity missile;
   local vector org;

   sound (self,CHAN_WEAPON,"zombie/z_shot1.wav",TRUE,ATTN_NORM);
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   org = (((self.origin + (st_x * v_forward)) + (st_y * v_right)) + ((st_z - 24.000) * v_up));
   makevectors (self.angles);
   missile.velocity = normalize ((self.enemy.origin - org));
   missile.velocity = (missile.velocity * 600.000);
   missile.velocity_z = 200.000;
   missile.avelocity = '3000.000 1000.000 2000.000';
   missile.touch = ZombieGrenadeTouch;
   missile.nextthink = (time + 2.500);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/zom_gib.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,org);

};

void () zombie_atta1 = [ 52.000, zombie_atta2 ] {

   ai_face ();

};

void () zombie_atta2 = [ 53.000, zombie_atta3 ] {

   ai_face ();

};

void () zombie_atta3 = [ 54.000, zombie_atta4 ] {

   ai_face ();

};

void () zombie_atta4 = [ 55.000, zombie_atta5 ] {

   ai_face ();

};

void () zombie_atta5 = [ 56.000, zombie_atta6 ] {

   ai_face ();

};

void () zombie_atta6 = [ 57.000, zombie_atta7 ] {

   ai_face ();

};

void () zombie_atta7 = [ 58.000, zombie_atta8 ] {

   ai_face ();

};

void () zombie_atta8 = [ 59.000, zombie_atta9 ] {

   ai_face ();

};

void () zombie_atta9 = [ 60.000, zombie_atta10 ] {

   ai_face ();

};

void () zombie_atta10 = [ 61.000, zombie_atta11 ] {

   ai_face ();

};

void () zombie_atta11 = [ 62.000, zombie_atta12 ] {

   ai_face ();

};

void () zombie_atta12 = [ 63.000, zombie_atta13 ] {

   ai_face ();

};

void () zombie_atta13 = [ 64.000, zombie_run1 ] {

   ai_face ();
   ZombieFireGrenade ('-10.000 -22.000 30.000');

};

void () zombie_attb1 = [ 65.000, zombie_attb2 ] {

   ai_face ();

};

void () zombie_attb2 = [ 66.000, zombie_attb3 ] {

   ai_face ();

};

void () zombie_attb3 = [ 67.000, zombie_attb4 ] {

   ai_face ();

};

void () zombie_attb4 = [ 68.000, zombie_attb5 ] {

   ai_face ();

};

void () zombie_attb5 = [ 69.000, zombie_attb6 ] {

   ai_face ();

};

void () zombie_attb6 = [ 70.000, zombie_attb7 ] {

   ai_face ();

};

void () zombie_attb7 = [ 71.000, zombie_attb8 ] {

   ai_face ();

};

void () zombie_attb8 = [ 72.000, zombie_attb9 ] {

   ai_face ();

};

void () zombie_attb9 = [ 73.000, zombie_attb10 ] {

   ai_face ();

};

void () zombie_attb10 = [ 74.000, zombie_attb11 ] {

   ai_face ();

};

void () zombie_attb11 = [ 75.000, zombie_attb12 ] {

   ai_face ();

};

void () zombie_attb12 = [ 76.000, zombie_attb13 ] {

   ai_face ();

};

void () zombie_attb13 = [ 77.000, zombie_attb14 ] {

   ai_face ();

};

void () zombie_attb14 = [ 77.000, zombie_run1 ] {

   ai_face ();
   ZombieFireGrenade ('-10.000 -24.000 29.000');

};

void () zombie_attc1 = [ 79.000, zombie_attc2 ] {

   ai_face ();

};

void () zombie_attc2 = [ 80.000, zombie_attc3 ] {

   ai_face ();

};

void () zombie_attc3 = [ 81.000, zombie_attc4 ] {

   ai_face ();

};

void () zombie_attc4 = [ 82.000, zombie_attc5 ] {

   ai_face ();

};

void () zombie_attc5 = [ 83.000, zombie_attc6 ] {

   ai_face ();

};

void () zombie_attc6 = [ 84.000, zombie_attc7 ] {

   ai_face ();

};

void () zombie_attc7 = [ 85.000, zombie_attc8 ] {

   ai_face ();

};

void () zombie_attc8 = [ 86.000, zombie_attc9 ] {

   ai_face ();

};

void () zombie_attc9 = [ 87.000, zombie_attc10 ] {

   ai_face ();

};

void () zombie_attc10 = [ 88.000, zombie_attc11 ] {

   ai_face ();

};

void () zombie_attc11 = [ 89.000, zombie_attc12 ] {

   ai_face ();

};

void () zombie_attc12 = [ 90.000, zombie_run1 ] {

   ai_face ();
   ZombieFireGrenade ('-12.000 -19.000 29.000');

};

void () zombie_missile = {

   local float r;

   droptofloor ();
   r = random ();
   if ( (r < 0.300) ) {

      zombie_atta1 ();

   } else {

      if ( (r < 0.600) ) {

         zombie_attb1 ();

      } else {

         zombie_attc1 ();

      }

   }

};

void () zombie_paina1 = [ 91.000, zombie_paina2 ] {

   sound (self,CHAN_VOICE,"zombie/z_pain.wav",TRUE,ATTN_NORM);

};

void () zombie_paina2 = [ 92.000, zombie_paina3 ] {

   ai_painforward (MOVETYPE_WALK);

};

void () zombie_paina3 = [ 93.000, zombie_paina4 ] {

   ai_painforward (TRUE);

};

void () zombie_paina4 = [ 94.000, zombie_paina5 ] {

   ai_pain (TRUE);

};

void () zombie_paina5 = [ 95.000, zombie_paina6 ] {

   ai_pain (MOVETYPE_WALK);

};

void () zombie_paina6 = [ 96.000, zombie_paina7 ] {

   ai_pain (TRUE);

};

void () zombie_paina7 = [ 97.000, zombie_paina8 ] {


};

void () zombie_paina8 = [ 98.000, zombie_paina9 ] {


};

void () zombie_paina9 = [ 99.000, zombie_paina10 ] {


};

void () zombie_paina10 = [ 100.000, zombie_paina11 ] {


};

void () zombie_paina11 = [ 101.000, zombie_paina12 ] {


};

void () zombie_paina12 = [ 102.000, zombie_run1 ] {


};

void () zombie_painb1 = [ 103.000, zombie_painb2 ] {

   sound (self,CHAN_VOICE,"zombie/z_pain1.wav",TRUE,ATTN_NORM);

};

void () zombie_painb2 = [ 104.000, zombie_painb3 ] {

   ai_pain (FL_SWIM);

};

void () zombie_painb3 = [ 105.000, zombie_painb4 ] {

   ai_pain (FL_CLIENT);

};

void () zombie_painb4 = [ 106.000, zombie_painb5 ] {

   ai_pain (MOVETYPE_TOSS);

};

void () zombie_painb5 = [ 107.000, zombie_painb6 ] {

   ai_pain (FL_SWIM);

};

void () zombie_painb6 = [ 108.000, zombie_painb7 ] {


};

void () zombie_painb7 = [ 109.000, zombie_painb8 ] {


};

void () zombie_painb8 = [ 110.000, zombie_painb9 ] {


};

void () zombie_painb9 = [ 111.000, zombie_painb10 ] {

   sound (self,CHAN_BODY,"zombie/z_fall.wav",TRUE,ATTN_NORM);

};

void () zombie_painb10 = [ 112.000, zombie_painb11 ] {


};

void () zombie_painb11 = [ 113.000, zombie_painb12 ] {


};

void () zombie_painb12 = [ 114.000, zombie_painb13 ] {


};

void () zombie_painb13 = [ 115.000, zombie_painb14 ] {


};

void () zombie_painb14 = [ 116.000, zombie_painb15 ] {


};

void () zombie_painb15 = [ 117.000, zombie_painb16 ] {


};

void () zombie_painb16 = [ 118.000, zombie_painb17 ] {


};

void () zombie_painb17 = [ 119.000, zombie_painb18 ] {


};

void () zombie_painb18 = [ 120.000, zombie_painb19 ] {


};

void () zombie_painb19 = [ 121.000, zombie_painb20 ] {


};

void () zombie_painb20 = [ 122.000, zombie_painb21 ] {


};

void () zombie_painb21 = [ 123.000, zombie_painb22 ] {


};

void () zombie_painb22 = [ 124.000, zombie_painb23 ] {


};

void () zombie_painb23 = [ 125.000, zombie_painb24 ] {


};

void () zombie_painb24 = [ 126.000, zombie_painb25 ] {


};

void () zombie_painb25 = [ 127.000, zombie_painb26 ] {

   ai_painforward (TRUE);

};

void () zombie_painb26 = [ 128.000, zombie_painb27 ] {


};

void () zombie_painb27 = [ 129.000, zombie_painb28 ] {


};

void () zombie_painb28 = [ 130.000, zombie_run1 ] {


};

void () zombie_painc1 = [ 131.000, zombie_painc2 ] {

   sound (self,CHAN_VOICE,"zombie/z_pain1.wav",TRUE,ATTN_NORM);

};

void () zombie_painc2 = [ 132.000, zombie_painc3 ] {


};

void () zombie_painc3 = [ 133.000, zombie_painc4 ] {

   ai_pain (MOVETYPE_WALK);

};

void () zombie_painc4 = [ 134.000, zombie_painc5 ] {

   ai_pain (TRUE);

};

void () zombie_painc5 = [ 135.000, zombie_painc6 ] {


};

void () zombie_painc6 = [ 136.000, zombie_painc7 ] {


};

void () zombie_painc7 = [ 137.000, zombie_painc8 ] {


};

void () zombie_painc8 = [ 138.000, zombie_painc9 ] {


};

void () zombie_painc9 = [ 139.000, zombie_painc10 ] {


};

void () zombie_painc10 = [ 140.000, zombie_painc11 ] {


};

void () zombie_painc11 = [ 141.000, zombie_painc12 ] {

   ai_painforward (TRUE);

};

void () zombie_painc12 = [ 142.000, zombie_painc13 ] {

   ai_painforward (TRUE);

};

void () zombie_painc13 = [ 143.000, zombie_painc14 ] {


};

void () zombie_painc14 = [ 144.000, zombie_painc15 ] {


};

void () zombie_painc15 = [ 145.000, zombie_painc16 ] {


};

void () zombie_painc16 = [ 146.000, zombie_painc17 ] {


};

void () zombie_painc17 = [ 147.000, zombie_painc18 ] {


};

void () zombie_painc18 = [ 148.000, zombie_run1 ] {


};

void () zombie_paind1 = [ 149.000, zombie_paind2 ] {

   sound (self,CHAN_VOICE,"zombie/z_pain.wav",TRUE,ATTN_NORM);
   droptofloor ();

};

void () zombie_paind2 = [ 150.000, zombie_paind3 ] {


};

void () zombie_paind3 = [ 151.000, zombie_paind4 ] {


};

void () zombie_paind4 = [ 152.000, zombie_paind5 ] {


};

void () zombie_paind5 = [ 153.000, zombie_paind6 ] {


};

void () zombie_paind6 = [ 154.000, zombie_paind7 ] {


};

void () zombie_paind7 = [ 155.000, zombie_paind8 ] {


};

void () zombie_paind8 = [ 156.000, zombie_paind9 ] {


};

void () zombie_paind9 = [ 157.000, zombie_paind10 ] {

   ai_pain (TRUE);

};

void () zombie_paind10 = [ 158.000, zombie_paind11 ] {


};

void () zombie_paind11 = [ 159.000, zombie_paind12 ] {


};

void () zombie_paind12 = [ 160.000, zombie_paind13 ] {


};

void () zombie_paind13 = [ 161.000, zombie_run1 ] {


};

void () zombie_paine1 = [ 162.000, zombie_paine2 ] {

   sound (self,CHAN_VOICE,"zombie/z_pain.wav",TRUE,ATTN_NORM);
   self.health = 60.000;

};

void () zombie_paine2 = [ 163.000, zombie_paine3 ] {

   ai_pain (FL_CLIENT);

};

void () zombie_paine3 = [ 164.000, zombie_paine4 ] {

   ai_pain (MOVETYPE_FLY);

};

void () zombie_paine4 = [ 165.000, zombie_paine5 ] {

   ai_pain (MOVETYPE_WALK);

};

void () zombie_paine5 = [ 166.000, zombie_paine6 ] {

   ai_pain (TRUE);

};

void () zombie_paine6 = [ 167.000, zombie_paine7 ] {

   ai_pain (FL_SWIM);

};

void () zombie_paine7 = [ 168.000, zombie_paine8 ] {

   ai_pain (TRUE);

};

void () zombie_paine8 = [ 169.000, zombie_paine9 ] {

   ai_pain (TRUE);

};

void () zombie_paine9 = [ 170.000, zombie_paine10 ] {

   ai_pain (FL_SWIM);

};

void () zombie_paine10 = [ 171.000, zombie_paine11 ] {

   sound (self,CHAN_BODY,"zombie/z_fall.wav",TRUE,ATTN_NORM);
   self.solid = SOLID_NOT;

};

void () zombie_paine11 = [ 172.000, zombie_paine12 ] {

   droptofloor ();
   self.nextthink = (self.nextthink + MOVETYPE_FLY);
   self.health = 60.000;

};

void () zombie_paine12 = [ 173.000, zombie_paine13 ] {

   droptofloor ();
   self.health = 60.000;
   sound (self,CHAN_VOICE,"zombie/z_idle.wav",TRUE,ATTN_IDLE);
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   self.solid = SOLID_SLIDEBOX;
   if ( !walkmove (FALSE,FALSE) ) {

      self.think = zombie_paine11;
      self.solid = SOLID_NOT;
      return ;

   }

};

void () zombie_paine13 = [ 174.000, zombie_paine14 ] {


};

void () zombie_paine14 = [ 175.000, zombie_paine15 ] {


};

void () zombie_paine15 = [ 176.000, zombie_paine16 ] {


};

void () zombie_paine16 = [ 177.000, zombie_paine17 ] {


};

void () zombie_paine17 = [ 178.000, zombie_paine18 ] {


};

void () zombie_paine18 = [ 179.000, zombie_paine19 ] {


};

void () zombie_paine19 = [ 180.000, zombie_paine20 ] {


};

void () zombie_paine20 = [ 181.000, zombie_paine21 ] {


};

void () zombie_paine21 = [ 182.000, zombie_paine22 ] {


};

void () zombie_paine22 = [ 183.000, zombie_paine23 ] {


};

void () zombie_paine23 = [ 184.000, zombie_paine24 ] {


};

void () zombie_paine24 = [ 185.000, zombie_paine25 ] {


};

void () zombie_paine25 = [ 186.000, zombie_paine26 ] {

   ai_painforward (MOVETYPE_FLY);

};

void () zombie_paine26 = [ 187.000, zombie_paine27 ] {

   ai_painforward (MOVETYPE_WALK);

};

void () zombie_paine27 = [ 188.000, zombie_paine28 ] {

   ai_painforward (TRUE);

};

void () zombie_paine28 = [ 189.000, zombie_paine29 ] {

   ai_pain (TRUE);

};

void () zombie_paine29 = [ 190.000, zombie_paine30 ] {


};

void () zombie_paine30 = [ 191.000, zombie_run1 ] {


};

void () zombie_die = {

   sound (self,CHAN_VOICE,"zombie/z_gib.wav",TRUE,ATTN_NORM);
   ThrowHead ("progs/h_zombie.mdl",self.health);
   ThrowGib ("progs/gib1.mdl",self.health, GIB_FLESH);
   ThrowGib ("progs/gib2.mdl",self.health, GIB_FLESH);
   ThrowGib ("progs/gib3.mdl",self.health, GIB_FLESH);

};

void (entity attacker, float take) zombie_pain = {

   local float r;

   self.health = 60.000;
   if ( (take < MOVETYPE_FLYMISSILE) ) {

      return ;

   }
   if ( (self.inpain == FL_SWIM) ) {

      return ;

   }
   if ( (take >= 25.000) ) {

      self.inpain = FL_SWIM;
      zombie_paine1 ();
      return ;

   }
   if ( self.inpain ) {

      self.pain_finished = (time + MOVETYPE_WALK);
      return ;

   }
   if ( (self.pain_finished > time) ) {

      self.inpain = FL_SWIM;
      zombie_paine1 ();
      return ;

   }
   self.inpain = TRUE;
   r = random ();
   if ( (r < 0.250) ) {

      zombie_paina1 ();

   } else {

      if ( (r < 0.500) ) {

         zombie_painb1 ();

      } else {

         if ( (r < 0.750) ) {

            zombie_painc1 ();

         } else {

            zombie_paind1 ();

         }

      }

   }

};

void () zombie_sleep = [ 172.000, zombie_sleep ] {

   ai_stand ();

};

void () zombie_wake = {

   self.th_stand = zombie_stand1;
   self.th_walk = zombie_walk1;
   self.th_pain = zombie_pain;
   self.th_run = zombie_run1;
   self.th_missile = zombie_missile;
   zombie_paine12 ();

};

void () zombie_escape1 = [ 192.000, zombie_escape2 ] {

   self.nextthink = (time + 0.200);

};

void () zombie_escape2 = [ 193.000, zombie_escape3 ] {

   self.nextthink = (time + 0.200);

};

void () zombie_escape3 = [ 194.000, zombie_escape4 ] {

   self.nextthink = (time + 0.200);

};

void () zombie_escape4 = [ 195.000, zombie_escape5 ] {

   self.nextthink = (time + 0.200);

};

void () zombie_escape5 = [ 196.000, zombie_escape6 ] {

   self.nextthink = (time + 0.150);

};

void () zombie_escape6 = [ 197.000, zombie_escape7 ] {

   self.nextthink = (time + 0.150);

};

void () zombie_escape7 = [ 198.000, zombie_escape8 ] {

   self.nextthink = (time + 0.150);

};

void () zombie_escape8 = [ 199.000, zombie_escape9 ] {

   self.nextthink = (time + 0.150);

};

void () zombie_escape9 = [ 200.000, zombie_escape10 ] {

   self.nextthink = (time + 0.150);

};

void () zombie_escape10 = [ 201.000, zombie_escape11 ] {

   self.nextthink = (time + 0.150);

};

void () zombie_escape11 = [ 202.000, zombie_escape12 ] {

   self.nextthink = (time + 0.100);

};

void () zombie_escape12 = [ 203.000, zombie_escape13 ] {

   self.nextthink = (time + 0.100);

};

void () zombie_escape13 = [ 204.000, zombie_escape14 ] {

   self.nextthink = (time + 0.100);

};

void () zombie_escape14 = [ 205.000, zombie_escape15 ] {

   makevectors (self.angles);
   setorigin (self,(self.origin + (v_forward * FL_CLIENT)));
   self.nextthink = (time + 0.150);

};

void () zombie_escape15 = [ 206.000, zombie_escape16 ] {

   makevectors (self.angles);
   setorigin (self,(self.origin + (v_forward * FL_CLIENT)));
   self.nextthink = (time + 0.150);

};

void () zombie_escape16 = [ 207.000, zombie_run1 ] {

   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.takedamage = DAMAGE_AIM;
   self.th_stand = zombie_stand1;
   self.th_walk = zombie_walk1;
   self.th_pain = zombie_pain;
   self.th_run = zombie_run1;
   self.th_missile = zombie_missile;
   self.health = 60.000;
   sound (self,CHAN_VOICE,"zombie/z_idle.wav",TRUE,ATTN_IDLE);
   droptofloor ();

};

void () zombie_escape = {

   if ( !self.pain_finished ) {

      self.pain_finished = (time + self.delay);

   }
   self.think = zombie_cruc1;
   self.nextthink = (time + 0.100);

};

void () monster_zombie = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/zombie.mdl");
   precache_model ("progs/h_zombie.mdl");
   precache_model ("progs/zom_gib.mdl");
   precache_sound ("zombie/z_idle.wav");
   precache_sound ("zombie/z_idle1.wav");
   precache_sound ("zombie/z_shot1.wav");
   precache_sound ("zombie/z_gib.wav");
   precache_sound ("zombie/z_pain.wav");
   precache_sound ("zombie/z_pain1.wav");
   precache_sound ("zombie/z_fall.wav");
   precache_sound ("zombie/z_miss.wav");
   precache_sound ("zombie/z_hit.wav");
   precache_sound ("zombie/idle_w2.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/zombie.mdl");
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   self.health = 60.000;
   self.th_stand = zombie_stand1;
   self.th_walk = zombie_walk1;
   self.th_run = zombie_run1;
   self.th_pain = zombie_pain;
   self.th_die = zombie_die;
   self.th_missile = zombie_missile;
   if ( (self.spawnflags & SPAWN_CRUCIFIED) ) {

      self.movetype = MOVETYPE_NONE;
      zombie_cruc1 ();

   } else {

      if ( (self.spawnflags & SPAWN_LYING) ) {

         self.solid = SOLID_NOT;
         self.th_stand = zombie_sleep;
         self.th_run = zombie_wake;
         self.th_walk = zombie_wake;
         self.th_pain = zombie_wake;
         self.th_missile = zombie_wake;
         setsize (self,VEC_HULL_MIN,'16.000 16.000 -16.000');
         if ( (self.spawnflags & SPAWN_AMBUSH) ) {

            self.spawnflags = SPAWN_LYING;

         }
         walkmonster_start ();

      } else {

         if ( (self.spawnflags & SPAWN_SNEAKY) ) {

            self.movetype = MOVETYPE_NONE;
            self.solid = SOLID_NOT;
            self.th_stand = zombie_cruc1;
            self.th_run = zombie_escape;
            self.th_walk = zombie_escape;
            self.th_pain = zombie_escape;
            self.th_missile = zombie_escape;
            if ( !self.delay ) {

               self.delay = MOVETYPE_WALK;

            }
            self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
            if ( !self.yaw_speed ) {

               self.yaw_speed = 20.000;

            }
            self.view_ofs = '0.000 0.000 25.000';
            self.flags = (self.flags | FL_MONSTER);
            self.th_stand ();
            self.nextthink = (self.nextthink + (random () * 0.500));
            total_monsters = (total_monsters + TRUE);

         } else {

            if ( (self.spawnflags & SPAWN_AMBUSH) ) {

               self.spawnflags = SPAWN_LYING;

            }
            walkmonster_start ();

         }

      }

   }

};
