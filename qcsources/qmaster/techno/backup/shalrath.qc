
void () shalrath_pain;

void () ShalMissile;

void () shal_stand = [ 23.000, shal_stand ] {

   ai_stand ();

};

void () shal_walk1 = [ 24.000, shal_walk2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"shalrath/idle.wav",TRUE,ATTN_IDLE);

   }
   ai_walk (MOVETYPE_TOSS);

};

void () shal_walk2 = [ 25.000, shal_walk3 ] {

   ai_walk (MOVETYPE_STEP);

};

void () shal_walk3 = [ 26.000, shal_walk4 ] {

   ai_walk (FALSE);

};

void () shal_walk4 = [ 27.000, shal_walk5 ] {

   ai_walk (FALSE);

};

void () shal_walk5 = [ 28.000, shal_walk6 ] {

   ai_walk (FALSE);

};

void () shal_walk6 = [ 29.000, shal_walk7 ] {

   ai_walk (FALSE);

};

void () shal_walk7 = [ 30.000, shal_walk8 ] {

   ai_walk (MOVETYPE_FLY);

};

void () shal_walk8 = [ 31.000, shal_walk9 ] {

   ai_walk (MOVETYPE_TOSS);

};

void () shal_walk9 = [ 32.000, shal_walk10 ] {

   ai_walk (MOVETYPE_FLY);

};

void () shal_walk10 = [ 33.000, shal_walk11 ] {

   ai_walk (FALSE);

};

void () shal_walk11 = [ 34.000, shal_walk12 ] {

   ai_walk (MOVETYPE_STEP);

};

void () shal_walk12 = [ 23.000, shal_walk1 ] {

   ai_walk (MOVETYPE_FLY);

};

void () shal_run1 = [ 24.000, shal_run2 ] {

   if ( (random () < 0.200) ) {

      sound (self,CHAN_VOICE,"shalrath/idle.wav",TRUE,ATTN_IDLE);

   }
   ai_run (MOVETYPE_TOSS);

};

void () shal_run2 = [ 25.000, shal_run3 ] {

   ai_run (MOVETYPE_STEP);

};

void () shal_run3 = [ 26.000, shal_run4 ] {

   ai_run (FALSE);

};

void () shal_run4 = [ 27.000, shal_run5 ] {

   ai_run (FALSE);

};

void () shal_run5 = [ 28.000, shal_run6 ] {

   ai_run (FALSE);

};

void () shal_run6 = [ 29.000, shal_run7 ] {

   ai_run (FALSE);

};

void () shal_run7 = [ 30.000, shal_run8 ] {

   ai_run (MOVETYPE_FLY);

};

void () shal_run8 = [ 31.000, shal_run9 ] {

   ai_run (MOVETYPE_TOSS);

};

void () shal_run9 = [ 32.000, shal_run10 ] {

   ai_run (MOVETYPE_FLY);

};

void () shal_run10 = [ 33.000, shal_run11 ] {

   ai_run (FALSE);

};

void () shal_run11 = [ 34.000, shal_run12 ] {

   ai_run (MOVETYPE_STEP);

};

void () shal_run12 = [ 23.000, shal_run1 ] {

   ai_run (MOVETYPE_FLY);

};

void () shal_attack1 = [ 0.000, shal_attack2 ] {

   sound (self,CHAN_VOICE,"shalrath/attack.wav",TRUE,ATTN_NORM);
   ai_face ();

};

void () shal_attack2 = [ 1.000, shal_attack3 ] {

   ai_face ();

};

void () shal_attack3 = [ 2.000, shal_attack4 ] {

   ai_face ();

};

void () shal_attack4 = [ 3.000, shal_attack5 ] {

   ai_face ();

};

void () shal_attack5 = [ 4.000, shal_attack6 ] {

   ai_face ();

};

void () shal_attack6 = [ 5.000, shal_attack7 ] {

   ai_face ();

};

void () shal_attack7 = [ 6.000, shal_attack8 ] {

   ai_face ();

};

void () shal_attack8 = [ 7.000, shal_attack9 ] {

   ai_face ();

};

void () shal_attack9 = [ 8.000, shal_attack10 ] {

   ShalMissile ();

};

void () shal_attack10 = [ 9.000, shal_attack11 ] {

   ai_face ();

};

void () shal_attack11 = [ 10.000, shal_run1 ] {


};

void () shal_pain1 = [ 11.000, shal_pain2 ] {


};

void () shal_pain2 = [ 12.000, shal_pain3 ] {


};

void () shal_pain3 = [ 13.000, shal_pain4 ] {


};

void () shal_pain4 = [ 14.000, shal_pain5 ] {


};

void () shal_pain5 = [ 15.000, shal_run1 ] {


};

void () shal_death1 = [ 16.000, shal_death2 ] {


};

void () shal_death2 = [ 17.000, shal_death3 ] {


};

void () shal_death3 = [ 18.000, shal_death4 ] {


};

void () shal_death4 = [ 19.000, shal_death5 ] {


};

void () shal_death5 = [ 20.000, shal_death6 ] {


};

void () shal_death6 = [ 21.000, shal_death7 ] {


};

void () shal_death7 = [ 22.000, shal_death7 ] {

   self.think = body_kill;
   self.nextthink = (time + 60.000);

};

void () shalrath_pain = {

   if ( (self.pain_finished > time) ) {

      return ;

   }
   sound (self,CHAN_VOICE,"shalrath/pain.wav",TRUE,ATTN_NORM);
   shal_pain1 ();
   self.pain_finished = (time + MOVETYPE_WALK);

};

void () shalrath_die = {

   if ( (self.health < -90.000) ) {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
      ThrowHead ("progs/h_shal.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);
      return ;

   }
   sound (self,CHAN_VOICE,"shalrath/death.wav",TRUE,ATTN_NORM);
   shal_death1 ();
   self.solid = SOLID_NOT;

};

void () ShalMissileTouch;

void () ShalHome;

void () ShalMissile = {

   local entity missile;
   local vector dir;
   local float dist;
   local float flytime;

   dir = normalize (((self.enemy.origin + '0.000 0.000 10.000') - self.origin));
   dist = vlen ((self.enemy.origin - self.origin));
   flytime = (dist * 0.002);
   if ( (flytime < 0.100) ) {

      flytime = 0.100;

   }
   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound (self,CHAN_WEAPON,"shalrath/attack2.wav",TRUE,ATTN_NORM);
   missile = spawn ();
   missile.owner = self;
   missile.solid = SOLID_BBOX;
   missile.movetype = MOVETYPE_FLYMISSILE;
   setmodel (missile,"progs/v_spike.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   missile.origin = (self.origin + '0.000 0.000 10.000');
   missile.velocity = (dir * 400.000);
   missile.avelocity = '300.000 300.000 300.000';
   missile.nextthink = (flytime + time);
   missile.think = ShalHome;
   missile.enemy = self.enemy;
   missile.touch = ShalMissileTouch;

};

void () ShalHome = {

   local vector dir;
   local vector vtemp;

   vtemp = (self.enemy.origin + '0.000 0.000 10.000');
   if ( (self.enemy.health < TRUE) ) {

      remove (self);
      return ;

   }
   dir = normalize ((vtemp - self.origin));
   if ( (skill == MOVETYPE_WALK) ) {

      self.velocity = (dir * 350.000);

   } else {

      self.velocity = (dir * 250.000);

   }
   self.nextthink = (time + 0.200);
   self.think = ShalHome;

};

void () ShalMissileTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.classname == "monster_zombie") ) {

      T_Damage (other,self,self,110.000);

   }
   T_RadiusDamage (self,self.owner,40.000,world);
   sound (self,CHAN_WEAPON,"weapons/r_exp3.wav",TRUE,ATTN_NORM);
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

void () monster_shalrath = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/shalrath.mdl");
   precache_model2 ("progs/h_shal.mdl");
   precache_model2 ("progs/v_spike.mdl");
   precache_sound2 ("shalrath/attack.wav");
   precache_sound2 ("shalrath/attack2.wav");
   precache_sound2 ("shalrath/death.wav");
   precache_sound2 ("shalrath/idle.wav");
   precache_sound2 ("shalrath/pain.wav");
   precache_sound2 ("shalrath/sight.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/shalrath.mdl");
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = 400.000;
   self.th_stand = shal_stand;
   self.th_walk = shal_walk1;
   self.th_run = shal_run1;
   self.th_die = shalrath_die;
   self.th_pain = shalrath_pain;
   self.th_missile = shal_attack1;
   self.think = walkmonster_start;
   self.nextthink = ((time + 0.100) + (random () * 0.100));

};
