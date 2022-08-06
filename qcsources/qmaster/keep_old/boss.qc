
void (vector p) boss_missile;

void () boss_face = {

   if ( ((self.enemy.health <= FALSE) || (random () < 0.020)) ) {

      self.enemy = find (self.enemy,classname,"player");
      if ( !self.enemy ) {

         self.enemy = find (self.enemy,classname,"player");

      }

   }
   ai_face ();

};

void () boss_rise1 = [ 0.000, boss_rise2 ] {

   sound (self,CHAN_WEAPON,"boss1/out1.wav",TRUE,ATTN_NORM);

};

void () boss_rise2 = [ 1.000, boss_rise3 ] {

   sound (self,CHAN_VOICE,"boss1/sight1.wav",TRUE,ATTN_NORM);

};

void () boss_rise3 = [ 2.000, boss_rise4 ] {


};

void () boss_rise4 = [ 3.000, boss_rise5 ] {


};

void () boss_rise5 = [ 4.000, boss_rise6 ] {


};

void () boss_rise6 = [ 5.000, boss_rise7 ] {


};

void () boss_rise7 = [ 6.000, boss_rise8 ] {


};

void () boss_rise8 = [ 7.000, boss_rise9 ] {


};

void () boss_rise9 = [ 8.000, boss_rise10 ] {


};

void () boss_rise10 = [ 9.000, boss_rise11 ] {


};

void () boss_rise11 = [ 10.000, boss_rise12 ] {


};

void () boss_rise12 = [ 11.000, boss_rise13 ] {


};

void () boss_rise13 = [ 12.000, boss_rise14 ] {


};

void () boss_rise14 = [ 13.000, boss_rise15 ] {


};

void () boss_rise15 = [ 14.000, boss_rise16 ] {


};

void () boss_rise16 = [ 15.000, boss_rise17 ] {


};

void () boss_rise17 = [ 16.000, boss_missile1 ] {


};

void () boss_missile1;

void () boss_idle1 = [ 17.000, boss_idle2 ] {


};

void () boss_idle2 = [ 18.000, boss_idle3 ] {

   boss_face ();

};

void () boss_idle3 = [ 19.000, boss_idle4 ] {

   boss_face ();

};

void () boss_idle4 = [ 20.000, boss_idle5 ] {

   boss_face ();

};

void () boss_idle5 = [ 21.000, boss_idle6 ] {

   boss_face ();

};

void () boss_idle6 = [ 22.000, boss_idle7 ] {

   boss_face ();

};

void () boss_idle7 = [ 23.000, boss_idle8 ] {

   boss_face ();

};

void () boss_idle8 = [ 24.000, boss_idle9 ] {

   boss_face ();

};

void () boss_idle9 = [ 25.000, boss_idle10 ] {

   boss_face ();

};

void () boss_idle10 = [ 26.000, boss_idle11 ] {

   boss_face ();

};

void () boss_idle11 = [ 27.000, boss_idle12 ] {

   boss_face ();

};

void () boss_idle12 = [ 28.000, boss_idle13 ] {

   boss_face ();

};

void () boss_idle13 = [ 29.000, boss_idle14 ] {

   boss_face ();

};

void () boss_idle14 = [ 30.000, boss_idle15 ] {

   boss_face ();

};

void () boss_idle15 = [ 31.000, boss_idle16 ] {

   boss_face ();

};

void () boss_idle16 = [ 32.000, boss_idle17 ] {

   boss_face ();

};

void () boss_idle17 = [ 33.000, boss_idle18 ] {

   boss_face ();

};

void () boss_idle18 = [ 34.000, boss_idle19 ] {

   boss_face ();

};

void () boss_idle19 = [ 35.000, boss_idle20 ] {

   boss_face ();

};

void () boss_idle20 = [ 36.000, boss_idle21 ] {

   boss_face ();

};

void () boss_idle21 = [ 37.000, boss_idle22 ] {

   boss_face ();

};

void () boss_idle22 = [ 38.000, boss_idle23 ] {

   boss_face ();

};

void () boss_idle23 = [ 39.000, boss_idle24 ] {

   boss_face ();

};

void () boss_idle24 = [ 40.000, boss_idle25 ] {

   boss_face ();

};

void () boss_idle25 = [ 41.000, boss_idle26 ] {

   boss_face ();

};

void () boss_idle26 = [ 42.000, boss_idle27 ] {

   boss_face ();

};

void () boss_idle27 = [ 43.000, boss_idle28 ] {

   boss_face ();

};

void () boss_idle28 = [ 44.000, boss_idle29 ] {

   boss_face ();

};

void () boss_idle29 = [ 45.000, boss_idle30 ] {

   boss_face ();

};

void () boss_idle30 = [ 46.000, boss_idle31 ] {

   boss_face ();

};

void () boss_idle31 = [ 47.000, boss_idle1 ] {

   boss_face ();

};

void () boss_missile1 = [ 57.000, boss_missile2 ] {

   boss_face ();

};

void () boss_missile2 = [ 58.000, boss_missile3 ] {

   boss_face ();

};

void () boss_missile3 = [ 59.000, boss_missile4 ] {

   boss_face ();

};

void () boss_missile4 = [ 60.000, boss_missile5 ] {

   boss_face ();

};

void () boss_missile5 = [ 61.000, boss_missile6 ] {

   boss_face ();

};

void () boss_missile6 = [ 62.000, boss_missile7 ] {

   boss_face ();

};

void () boss_missile7 = [ 63.000, boss_missile8 ] {

   boss_face ();

};

void () boss_missile8 = [ 64.000, boss_missile9 ] {

   boss_face ();

};

void () boss_missile9 = [ 65.000, boss_missile10 ] {

   boss_missile ('100.000 100.000 200.000');

};

void () boss_missile10 = [ 66.000, boss_missile11 ] {

   boss_face ();

};

void () boss_missile11 = [ 67.000, boss_missile12 ] {

   boss_face ();

};

void () boss_missile12 = [ 68.000, boss_missile13 ] {

   boss_face ();

};

void () boss_missile13 = [ 69.000, boss_missile14 ] {

   boss_face ();

};

void () boss_missile14 = [ 70.000, boss_missile15 ] {

   boss_face ();

};

void () boss_missile15 = [ 71.000, boss_missile16 ] {

   boss_face ();

};

void () boss_missile16 = [ 72.000, boss_missile17 ] {

   boss_face ();

};

void () boss_missile17 = [ 73.000, boss_missile18 ] {

   boss_face ();

};

void () boss_missile18 = [ 74.000, boss_missile19 ] {

   boss_face ();

};

void () boss_missile19 = [ 75.000, boss_missile20 ] {

   boss_face ();

};

void () boss_missile20 = [ 76.000, boss_missile21 ] {

   boss_missile ('100.000 -100.000 200.000');

};

void () boss_missile21 = [ 77.000, boss_missile22 ] {

   boss_face ();

};

void () boss_missile22 = [ 78.000, boss_missile23 ] {

   boss_face ();

};

void () boss_missile23 = [ 79.000, boss_missile1 ] {

   boss_face ();

};

void () boss_shocka1 = [ 80.000, boss_shocka2 ] {


};

void () boss_shocka2 = [ 81.000, boss_shocka3 ] {


};

void () boss_shocka3 = [ 82.000, boss_shocka4 ] {


};

void () boss_shocka4 = [ 83.000, boss_shocka5 ] {


};

void () boss_shocka5 = [ 84.000, boss_shocka6 ] {


};

void () boss_shocka6 = [ 85.000, boss_shocka7 ] {


};

void () boss_shocka7 = [ 86.000, boss_shocka8 ] {


};

void () boss_shocka8 = [ 87.000, boss_shocka9 ] {


};

void () boss_shocka9 = [ 88.000, boss_shocka10 ] {


};

void () boss_shocka10 = [ 89.000, boss_missile1 ] {


};

void () boss_shockb1 = [ 90.000, boss_shockb2 ] {


};

void () boss_shockb2 = [ 91.000, boss_shockb3 ] {


};

void () boss_shockb3 = [ 92.000, boss_shockb4 ] {


};

void () boss_shockb4 = [ 93.000, boss_shockb5 ] {


};

void () boss_shockb5 = [ 94.000, boss_shockb6 ] {


};

void () boss_shockb6 = [ 95.000, boss_shockb7 ] {


};

void () boss_shockb7 = [ 90.000, boss_shockb8 ] {


};

void () boss_shockb8 = [ 91.000, boss_shockb9 ] {


};

void () boss_shockb9 = [ 92.000, boss_shockb10 ] {


};

void () boss_shockb10 = [ 93.000, boss_missile1 ] {


};

void () boss_shockc1 = [ 96.000, boss_shockc2 ] {


};

void () boss_shockc2 = [ 97.000, boss_shockc3 ] {


};

void () boss_shockc3 = [ 98.000, boss_shockc4 ] {


};

void () boss_shockc4 = [ 99.000, boss_shockc5 ] {


};

void () boss_shockc5 = [ 100.000, boss_shockc6 ] {


};

void () boss_shockc6 = [ 101.000, boss_shockc7 ] {


};

void () boss_shockc7 = [ 102.000, boss_shockc8 ] {


};

void () boss_shockc8 = [ 103.000, boss_shockc9 ] {


};

void () boss_shockc9 = [ 104.000, boss_shockc10 ] {


};

void () boss_shockc10 = [ 105.000, boss_death1 ] {


};

void () boss_death1 = [ 48.000, boss_death2 ] {

   sound (self,CHAN_VOICE,"boss1/death.wav",TRUE,ATTN_NORM);

};

void () boss_death2 = [ 49.000, boss_death3 ] {


};

void () boss_death3 = [ 50.000, boss_death4 ] {


};

void () boss_death4 = [ 51.000, boss_death5 ] {


};

void () boss_death5 = [ 52.000, boss_death6 ] {


};

void () boss_death6 = [ 53.000, boss_death7 ] {


};

void () boss_death7 = [ 54.000, boss_death8 ] {


};

void () boss_death8 = [ 55.000, boss_death9 ] {


};

void () boss_death9 = [ 56.000, boss_death10 ] {

   sound (self,CHAN_BODY,"boss1/out1.wav",TRUE,ATTN_NORM);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LAVASPLASH);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);

};

void () boss_death10 = [ 56.000, boss_death10 ] {

   killed_monsters = (killed_monsters + TRUE);
   WriteByte (MSG_ALL,SVC_KILLEDMONSTER);
   SUB_UseTargets ();
   remove (self);

};

void (vector p) boss_missile = {

   local vector offang;
   local vector org;
   local vector vec;
   local vector d;
   local float t;

   offang = vectoangles ((self.enemy.origin - self.origin));
   makevectors (offang);
   org = (((self.origin + (p_x * v_forward)) + (p_y * v_right)) + (p_z * '0.000 0.000 1.000'));
   if ( (skill > TRUE) ) {

      t = (vlen ((self.enemy.origin - org)) / 300.000);
      vec = self.enemy.velocity;
      vec_z = FALSE;
      d = (self.enemy.origin + (t * vec));

   } else {

      d = self.enemy.origin;

   }
   vec = normalize ((d - org));
   launch_spike (org,vec);
   setmodel (newmis,"progs/lavaball.mdl");
   newmis.avelocity = '200.000 100.000 300.000';
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   newmis.velocity = (vec * 300.000);
   newmis.touch = T_MissileTouch;
   sound (self,CHAN_WEAPON,"boss1/throw.wav",TRUE,ATTN_NORM);
   if ( (self.enemy.health <= FALSE) ) {

      boss_idle1 ();

   }

};

void () boss_awake = {

   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.takedamage = DAMAGE_NO;
   setmodel (self,"progs/boss.mdl");
   setsize (self,'-128.000 -128.000 -24.000','128.000 128.000 256.000');
   if ( (skill == FALSE) ) {

      self.health = TRUE;

   } else {

      self.health = MOVETYPE_WALK;

   }
   self.enemy = activator;
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LAVASPLASH);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   self.yaw_speed = 20.000;
   boss_rise1 ();

};


void () monster_boss = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/boss.mdl");
   precache_model ("progs/lavaball.mdl");
   precache_sound ("weapons/rocket1i.wav");
   precache_sound ("boss1/out1.wav");
   precache_sound ("boss1/sight1.wav");
   precache_sound ("misc/power.wav");
   precache_sound ("boss1/throw.wav");
   precache_sound ("boss1/pain.wav");
   precache_sound ("boss1/death.wav");
   total_monsters = (total_monsters + TRUE);
   self.use = boss_awake;

};

entity le1;
entity le2;
float lightning_end /* = 0.000 */;

void () lightning_fire = {

   local vector p1;
   local vector p2;

   if ( (time >= lightning_end) ) {

      self = le1;
      door_go_down ();
      self = le2;
      door_go_down ();
      return ;

   }
   p1 = ((le1.mins + le1.maxs) * 0.500);
   p1_z = (le1.absmin_z - FL_INWATER);
   p2 = ((le2.mins + le2.maxs) * 0.500);
   p2_z = (le2.absmin_z - FL_INWATER);
   p2 = (p2 - (normalize ((p2 - p1)) * 100.000));
   self.nextthink = (time + 0.100);
   self.think = lightning_fire;
   WriteByte (MSG_ALL,SVC_TEMPENTITY);
   WriteByte (MSG_ALL,TE_LIGHTNING3);
   WriteEntity (MSG_ALL,world);
   WriteCoord (MSG_ALL,p1_x);
   WriteCoord (MSG_ALL,p1_y);
   WriteCoord (MSG_ALL,p1_z);
   WriteCoord (MSG_ALL,p2_x);
   WriteCoord (MSG_ALL,p2_y);
   WriteCoord (MSG_ALL,p2_z);

};

void () lightning_use = {

   if ( (lightning_end >= (time + TRUE)) ) {

      return ;

   }
   le1 = find (world,target,"lightning");
   le2 = find (le1,target,"lightning");
   if ( (!le1 || !le2) ) {

      dprint ("missing lightning targets\n");
      return ;

   }
   if ( ((((le1.state != STATE_TOP) && (le1.state != STATE_BOTTOM)) || ((le2.state != STATE_TOP) && (le2.state != STATE_BOTTOM))) || (le1.state != le2.state)) ) {

      return ;

   }
   le1.nextthink = CONTENT_EMPTY;
   le2.nextthink = CONTENT_EMPTY;
   lightning_end = (time + TRUE);
   sound (self,CHAN_VOICE,"misc/power.wav",TRUE,ATTN_NORM);
   lightning_fire ();
   self = find (world,classname,"monster_boss");
   if ( !self ) {

      return ;

   }
   self.enemy = activator;
   if ( ((le1.state == STATE_TOP) && (self.health > FALSE)) ) {

      sound (self,CHAN_VOICE,"boss1/pain.wav",TRUE,ATTN_NORM);
      self.health = (self.health - TRUE);
      if ( (self.health >= FL_SWIM) ) {

         boss_shocka1 ();

      } else {

         if ( (self.health == TRUE) ) {

            boss_shockb1 ();

         } else {

            if ( (self.health == FALSE) ) {

               boss_shockc1 ();

            }

         }

      }

   }

};

void () event_lightning = {

   self.use = lightning_use;

};
