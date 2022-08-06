float () ScourgeCheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   if ( (vlen ((spot1 - spot2)) <= 100.000) ) {

      if ( CanDamage (self.enemy,self) ) {

         self.attack_state = AS_MELEE;
         return ( TRUE );

      }

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( !enemy_vis ) {

      return ( FALSE );

   }
   chance = (spot2_z - spot1_z);
   if ( (chance > FL_GODMODE) ) {

      return ( FALSE );

   } else {

      if ( (chance < -200.000) ) {

         return ( FALSE );

      }

   }
   if ( (vlen ((spot1 - spot2)) > 1000.000) ) {

      return ( FALSE );

   }
   if ( (vlen ((spot1 - spot2)) < MIN_CHARMER_DISTANCE) ) {

      return ( FALSE );

   }
   traceline (spot1,spot2,FALSE,self);
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (trace_ent != targ) ) {

      return ( FALSE );

   }
   self.attack_state = AS_MISSILE;
   SUB_AttackFinished ((FL_SWIM + (FL_SWIM * random ())));
   return ( TRUE );

};

void (float ox) SCOURGE_FireSpikes = {

   local vector src;
   local vector vec;

   ai_face ();
   makevectors (self.angles);
   src = (((self.origin - '0.000 0.000 19.000') + (v_right * ox)) + (v_forward * 14.000));
   vec = ((self.enemy.origin + (MAX_CHARMER_DISTANCE * v_forward)) - src);
   vec = normalize (vec);
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",TRUE,ATTN_NORM);
   launch_spike (src,vec);
   self.attack_finished = (time + 0.200);

};

void () Attack_With_Tail = {

   local float ldmg;
   local vector delta;

   ai_face ();
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 100.000) ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   ldmg = (((random () + random ()) + random ()) * 40.000);
   T_Damage (self.enemy,self,self,ldmg);
   sound (self,CHAN_WEAPON,"shambler/smack.wav",TRUE,ATTN_NORM);
   SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),((crandom () * 50.000) * v_right));

};

void () ScourgeTriggerThink;

void () ScourgeTriggerTouch;

void () scourge_think = {

   local entity trig;

   if ( !self.state ) {

      trig = spawn ();
      trig.angles = VEC_ORIGIN;
      trig.solid = SOLID_TRIGGER;
      setsize (trig,'-64.000 -64.000 -24.000','64.000 64.000 64.000');
      trig.takedamage = DAMAGE_NO;
      trig.movetype = MOVETYPE_NONE;
      trig.modelindex = FALSE;
      trig.model = "";
      trig.lastvictim = self;
      trig.think = ScourgeTriggerThink;
      trig.touch = ScourgeTriggerTouch;
      trig.nextthink = ((time + 0.100) + random ());
      setorigin (trig,self.origin);
      self.lastvictim = trig;
      self.state = TRUE;

   }
   if ( ((self.spawnsilent == FALSE) && (self.spawnmulti == TRUE)) ) {

      sound (self,CHAN_BODY,"misc/null.wav",TRUE,ATTN_IDLE);

   } else {

      if ( ((self.spawnsilent == TRUE) && (self.spawnmulti == FALSE)) ) {

         sound (self,CHAN_BODY,"scourge/walk.wav",TRUE,ATTN_IDLE);

      }

   }
   self.spawnmulti = self.spawnsilent;

};

void (float dist) ai_right = {

   walkmove ((self.angles_y + 90.000),dist);

};

void (float dist) ai_left = {

   walkmove ((self.angles_y + 270.000),dist);

};

void () scourge_stand1 = [ 0.000, scourge_stand2 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand2 = [ 1.000, scourge_stand3 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand3 = [ 2.000, scourge_stand4 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand4 = [ 3.000, scourge_stand5 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand5 = [ 4.000, scourge_stand6 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand6 = [ 5.000, scourge_stand7 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand7 = [ 6.000, scourge_stand8 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand8 = [ 7.000, scourge_stand9 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand9 = [ 8.000, scourge_stand10 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand10 = [ 9.000, scourge_stand11 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand11 = [ 10.000, scourge_stand12 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand12 = [ 11.000, scourge_stand1 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_walk1 = [ 12.000, scourge_walk2 ] {

   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"scourge/idle.wav",TRUE,ATTN_IDLE);

   }
   self.spawnsilent = TRUE;
   scourge_think ();
   ai_walk (FL_CLIENT);

};

void () scourge_walk2 = [ 13.000, scourge_walk3 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk3 = [ 14.000, scourge_walk4 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk4 = [ 15.000, scourge_walk5 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk5 = [ 16.000, scourge_walk6 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk6 = [ 17.000, scourge_walk1 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_run1 = [ 12.000, scourge_run2 ] {

   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"scourge/idle.wav",TRUE,ATTN_IDLE);

   }
   self.spawnsilent = TRUE;
   scourge_think ();
   ai_run (18.000);

};

void () scourge_run2 = [ 13.000, scourge_run3 ] {

   scourge_think ();
   ai_run (14.000);

};

void () scourge_run3 = [ 14.000, scourge_run4 ] {

   ai_run (14.000);

};

void () scourge_run4 = [ 15.000, scourge_run5 ] {

   ai_run (14.000);

};

void () scourge_run5 = [ 16.000, scourge_run6 ] {

   ai_run (14.000);

};

void () scourge_run6 = [ 17.000, scourge_run1 ] {

   ai_run (14.000);

};

void () scourge_strafeleft1 = [ 12.000, scourge_strafeleft2 ] {

   self.spawnsilent = TRUE;
   scourge_think ();
   ai_left (20.000);

};

void () scourge_strafeleft2 = [ 13.000, scourge_strafeleft3 ] {

   ai_left (20.000);

};

void () scourge_strafeleft3 = [ 14.000, scourge_strafeleft4 ] {

   ai_left (20.000);

};

void () scourge_strafeleft4 = [ 15.000, scourge_strafeleft5 ] {

   ai_left (14.000);

};

void () scourge_strafeleft5 = [ 16.000, scourge_strafeleft6 ] {

   ai_left (14.000);

};

void () scourge_strafeleft6 = [ 17.000, scourge_run1 ] {

   ai_left (14.000);

};

void () scourge_straferight1 = [ 12.000, scourge_straferight2 ] {

   self.spawnsilent = TRUE;
   scourge_think ();
   ai_right (20.000);

};

void () scourge_straferight2 = [ 13.000, scourge_straferight3 ] {

   ai_right (20.000);

};

void () scourge_straferight3 = [ 14.000, scourge_straferight4 ] {

   ai_right (20.000);

};

void () scourge_straferight4 = [ 15.000, scourge_straferight5 ] {

   ai_right (14.000);

};

void () scourge_straferight5 = [ 16.000, scourge_straferight6 ] {

   ai_right (14.000);

};

void () scourge_straferight6 = [ 17.000, scourge_run1 ] {

   ai_right (14.000);

};

void () scourge_turn1 = [ 12.000, scourge_turn2 ] {

   self.spawnsilent = TRUE;
   scourge_think ();
   ai_turn_in_place ();

};

void () scourge_turn2 = [ 13.000, scourge_turn3 ] {

   ai_turn_in_place ();

};

void () scourge_turn3 = [ 14.000, scourge_turn4 ] {

   ai_turn_in_place ();

};

void () scourge_turn4 = [ 15.000, scourge_turn5 ] {

   ai_turn_in_place ();

};

void () scourge_turn5 = [ 16.000, scourge_turn6 ] {

   ai_turn_in_place ();

};

void () scourge_turn6 = [ 17.000, scourge_turn1 ] {

   ai_turn_in_place ();

};

void () scourge_atk1 = [ 18.000, scourge_atk2 ] {

   self.spawnsilent = FALSE;
   scourge_think ();
   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (40.000);

};

void () scourge_atk2 = [ 19.000, scourge_atk3 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-56.000);

};

void () scourge_atk3 = [ 18.000, scourge_atk4 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-40.000);

};

void () scourge_atk4 = [ 19.000, scourge_atk5 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (56.000);

};

void () scourge_atk5 = [ 18.000, scourge_atk6 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (40.000);

};

void () scourge_atk6 = [ 19.000, scourge_atk7 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-56.000);

};

void () scourge_atk7 = [ 18.000, scourge_atk8 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-40.000);

};

void () scourge_atk8 = [ 19.000, scourge_run1 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (56.000);
   SUB_AttackFinished ((MOVETYPE_STEP * random ()));

};

void () scourge_melee1 = [ 20.000, scourge_melee2 ] {

   self.spawnsilent = FALSE;
   scourge_think ();
   ai_charge (MOVETYPE_WALK);

};

void () scourge_melee2 = [ 21.000, scourge_melee3 ] {

   ai_charge (MOVETYPE_WALK);

};

void () scourge_melee3 = [ 22.000, scourge_melee4 ] {

   ai_charge (FL_SWIM);

};

void () scourge_melee4 = [ 23.000, scourge_melee5 ] {

   ai_charge (FL_SWIM);

};

void () scourge_melee5 = [ 24.000, scourge_melee6 ] {

   sound (self,CHAN_WEAPON,"scourge/tailswng.wav",TRUE,ATTN_NORM);
   ai_charge (MOVETYPE_WALK);

};

void () scourge_melee6 = [ 25.000, scourge_melee7 ] {

   ai_charge (TRUE);

};

void () scourge_melee7 = [ 26.000, scourge_melee8 ] {

   Attack_With_Tail ();

};

void () scourge_melee8 = [ 27.000, scourge_melee9 ] {

   ai_face ();

};

void () scourge_melee9 = [ 28.000, scourge_melee10 ] {

   ai_face ();

};

void () scourge_melee10 = [ 29.000, scourge_melee11 ] {

   ai_face ();

};

void () scourge_melee11 = [ 30.000, scourge_run1 ] {

   ai_face ();
   SUB_CheckRefire (scourge_melee1);

};

void () scourge_pain1 = [ 31.000, scourge_pain2 ] {

   self.spawnsilent = FALSE;
   scourge_think ();

};

void () scourge_pain2 = [ 32.000, scourge_pain3 ] {


};

void () scourge_pain3 = [ 33.000, scourge_pain4 ] {


};

void () scourge_pain4 = [ 34.000, scourge_pain5 ] {


};

void () scourge_pain5 = [ 35.000, scourge_run1 ] {


};

void (entity attacker, float damage) scourge_pain = {

   local float r;

   if ( ((random () * 50.000) > damage) ) {

      return ;

   }
   if ( (self.pain_finished > time) ) {

      return ;

   }
   r = random ();
   sound (self,CHAN_VOICE,"scourge/pain.wav",TRUE,ATTN_NORM);
   self.pain_finished = (time + FL_SWIM);
   scourge_pain1 ();

};

void () scourge_die1 = [ 36.000, scourge_die2 ] {

   self.spawnsilent = FALSE;
   scourge_think ();

};

void () scourge_die2 = [ 37.000, scourge_die3 ] {


};

void () scourge_die3 = [ 38.000, scourge_die4 ] {

   self.solid = SOLID_NOT;

};

void () scourge_die4 = [ 39.000, scourge_die5 ] {


};

void () scourge_die5 = [ 40.000, scourge_die5 ] {


};

void () scourge_die = {

   remove (self.lastvictim);
   self.spawnsilent = FALSE;
   scourge_think ();
   if ( (self.health < -35.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_scourg.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);
      return ;

   }
   sound (self,CHAN_VOICE,"scourge/pain2.wav",TRUE,ATTN_NORM);
   scourge_die1 ();

};

void () scourge_melee = {

   scourge_melee1 ();
   SUB_AttackFinished ((FL_SWIM * random ()));

};

void () ScourgeTriggerThink = {

   local entity targ;

   if ( (self.lastvictim.health <= FALSE) ) {

      remove (self);
      return ;

   }
   targ = self.lastvictim;
   makevectors (targ.angles);
   setorigin (self,(targ.origin + (v_forward * 300.000)));
   self.nextthink = (time + 0.100);

};

void () ScourgeTriggerTouch = {

   local entity targ;
   local entity tempent;
   local vector dir;

   if ( (other.flags & (FL_MONSTER | FL_CLIENT)) ) {

      return ;

   }
   if ( (other.movetype != MOVETYPE_FLYMISSILE) ) {

      return ;

   }
   targ = self.lastvictim;
   if ( (targ.health <= FALSE) ) {

      remove (self);
      return ;

   }
   dir = (targ.origin - other.origin);
   dir = normalize (dir);
   if ( ((dir * normalize (other.velocity)) < 0.800) ) {

      return ;

   }
   if ( (time > self.duration) ) {

      tempent = self;
      self = targ;
      if ( (random () < 0.500) ) {

         scourge_strafeleft1 ();

      } else {

         scourge_straferight1 ();

      }
      self.duration = (time + 1.500);

   }
   self = tempent;

};

void () monster_scourge = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/scor.mdl");
   precache_model2 ("progs/h_scourg.mdl");
   precache_model2 ("progs/laser.mdl");
   precache_model2 ("progs/s_light.mdl");
   precache_model2 ("progs/spike.mdl");
   precache_sound ("misc/null.wav");
   precache_sound ("scourge/idle.wav");
   precache_sound ("scourge/pain.wav");
   precache_sound ("scourge/pain2.wav");
   precache_sound ("scourge/sight.wav");
   precache_sound ("scourge/tailswng.wav");
   precache_sound ("scourge/walk.wav");
   precache_sound2 ("shambler/smack.wav");
   precache_sound2 ("weapons/rocket1i.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/scor.mdl");
   setsize (self,'-32.000 -32.000 -24.000','32.000 32.000 22.000');
   self.health = 300.000;
   self.th_stand = scourge_stand1;
   self.th_walk = scourge_walk1;
   self.th_run = scourge_run1;
   self.th_pain = scourge_pain;
   self.th_die = scourge_die;
   self.th_melee = scourge_melee;
   self.th_missile = scourge_atk1;
   self.yaw_speed = 60.000;
   self.attack_state = AS_DODGING;
   self.state = FALSE;
   walkmonster_start ();

};
