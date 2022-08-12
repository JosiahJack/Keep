entity shub;
void () shub_death;
void (string gibName) ol_toss;
void () finale_1;
void () finale_2;
void () old_idle1 =  [ 0.000, old_idle2 ]   {};
void () old_idle2 =  [ 1.000, old_idle3 ]   {};
void () old_idle3 =  [ 2.000, old_idle4 ]   {};
void () old_idle4 =  [ 3.000, old_idle5 ]   {};
void () old_idle5 =  [ 4.000, old_idle6 ]   {};
void () old_idle6 =  [ 5.000, old_idle7 ]   {};
void () old_idle7 =  [ 6.000, old_idle8 ]   {};
void () old_idle8 =  [ 7.000, old_idle9 ]   {};
void () old_idle9 =  [ 8.000, old_idle10 ]  {};
void () old_idle10 = [ 9.000, old_idle11 ]  {};
void () old_idle11 = [ 10.000, old_idle12 ] {};
void () old_idle12 = [ 11.000, old_idle13 ] {};
void () old_idle13 = [ 12.000, old_idle14 ] {};
void () old_idle14 = [ 13.000, old_idle15 ] {};
void () old_idle15 = [ 14.000, old_idle16 ] {};
void () old_idle16 = [ 15.000, old_idle17 ] {};
void () old_idle17 = [ 16.000, old_idle18 ] {};
void () old_idle18 = [ 17.000, old_idle19 ] {};
void () old_idle19 = [ 18.000, old_idle20 ] {};
void () old_idle20 = [ 19.000, old_idle21 ] {};
void () old_idle21 = [ 20.000, old_idle22 ] {};
void () old_idle22 = [ 21.000, old_idle23 ] {};
void () old_idle23 = [ 22.000, old_idle24 ] {};
void () old_idle24 = [ 23.000, old_idle25 ] {};
void () old_idle25 = [ 24.000, old_idle26 ] {};
void () old_idle26 = [ 25.000, old_idle27 ] {};
void () old_idle27 = [ 26.000, old_idle28 ] {};
void () old_idle28 = [ 27.000, old_idle29 ] {};
void () old_idle29 = [ 28.000, old_idle30 ] {};
void () old_idle30 = [ 29.000, old_idle31 ] {};
void () old_idle31 = [ 30.000, old_idle32 ] {};
void () old_idle32 = [ 31.000, old_idle33 ] {};
void () old_idle33 = [ 32.000, old_idle34 ] {};
void () old_idle34 = [ 33.000, old_idle35 ] {};
void () old_idle35 = [ 34.000, old_idle36 ] {};
void () old_idle36 = [ 35.000, old_idle37 ] {};
void () old_idle37 = [ 36.000, old_idle38 ] {};
void () old_idle38 = [ 37.000, old_idle39 ] {};
void () old_idle39 = [ 38.000, old_idle40 ] {};
void () old_idle40 = [ 39.000, old_idle41 ] {};
void () old_idle41 = [ 40.000, old_idle42 ] {};
void () old_idle42 = [ 41.000, old_idle43 ] {};
void () old_idle43 = [ 42.000, old_idle44 ] {};
void () old_idle44 = [ 43.000, old_idle45 ] {};
void () old_idle45 = [ 44.000, old_idle46 ] {};
void () old_idle46 = [ 45.000, old_idle1 ]  {};
void () old_thrash1 =  [ 46.000, old_thrash2 ]  {};
void () old_thrash2 =  [ 47.000, old_thrash3 ]  {};
void () old_thrash3 =  [ 48.000, old_thrash4 ]  {};
void () old_thrash4 =  [ 49.000, old_thrash5 ]  {};
void () old_thrash5 =  [ 50.000, old_thrash6 ]  {};
void () old_thrash6 =  [ 51.000, old_thrash7 ]  {};
void () old_thrash7 =  [ 52.000, old_thrash8 ]  {};
void () old_thrash8 =  [ 53.000, old_thrash9 ]  {};
void () old_thrash9 =  [ 54.000, old_thrash10 ] {};
void () old_thrash10 = [ 55.000, old_thrash11 ] {};
void () old_thrash11 = [ 56.000, old_thrash12 ] {};
void () old_thrash12 = [ 57.000, old_thrash13 ] {};
void () old_thrash13 = [ 59.000, old_thrash14 ] {};
void () old_thrash14 = [ 60.000, old_thrash15 ] {};
void () old_thrash15 = [ 61.000, old_thrash16 ] {};
void () old_thrash16 = [ 62.000, old_thrash17 ] {};
void () old_thrash17 = [ 63.000, old_thrash18 ] {};
void () old_thrash18 = [ 64.000, old_thrash19 ] {};
void () old_thrash19 = [ 65.000, old_thrash20 ] {};
void () old_thrash20 = [ 66.000, old_idle1 ] {};

void () shub_death = {

   local vector oldo;
   local float x;
   local float y;
   local float z;
   local float r;

   sound (self,CHAN_VOICE,"boss2/pop2.wav",TRUE,ATTN_NORM);
   oldo = self.origin;
   z = FL_INWATER;
   while ( (z <= 144.000) ) {

      x = -64.000;
      while ( (x <= FL_GODMODE) ) {

         y = -64.000;
         while ( (y <= FL_GODMODE) ) {

            self.origin_x = (oldo_x + x);
            self.origin_y = (oldo_y + y);
            self.origin_z = (oldo_z + z);
            r = random ();
            if ( (r < 0.300) ) {

               ThrowGib ("progs/gib1.mdl",-999.000, GIB_FLESH);

            } else {

               if ( (r < 0.600) ) {

                  ThrowGib ("progs/gib2.mdl",-999.000, GIB_FLESH);

               } else {

                  ThrowGib ("progs/gib3.mdl",-999.000, GIB_FLESH);

               }

            }
            y = (y + FL_MONSTER);

         }
         x = (x + FL_MONSTER);

      }
      z = (z + 96.000);

   }
   self.think = SUB_Remove;
   self.nextthink = (time + 0.100);

};

void () env_finale = {

   if (!self.targetname) {

      error ("no targetname for env_finale");

   }
   self.use = finale_1;

};

void () finale_1 = {

   local entity pos;
   local entity pl;
   local entity timer;

   intermission_exittime = (time + 10000000.000);
   intermission_running = TRUE;
   pos = find (world,classname,"info_intermission");
   if ( !pos ) {

      error ("no info_intermission");

   }
   pl = find (world,classname,"misc_teleporttrain");
   if ( pl ) {

      remove (pl);

   }
   WriteByte (MSG_ALL,SVC_FINALE);
   WriteString (MSG_ALL,"");
   pl = find (world,classname,"player");
   while ( (pl != world) ) {

      pl.view_ofs = VEC_ORIGIN;
      other.v_angle = pos.mangle;
      pl.angles = pos.mangle;
      pl.fixangle = TRUE;
      pl.map = self.map;
      pl.nextthink = (time + 0.500);
      pl.takedamage = DAMAGE_NO;
      pl.solid = SOLID_NOT;
      pl.movetype = MOVETYPE_NONE;
      pl.modelindex = FALSE;
      setorigin (pl,pos.origin);
      pl = find (pl,classname,"player");

   }
   timer = spawn ();
   timer.nextthink = (time + TRUE);
   timer.think = finale_2;

};

void () finale_2 = {

   local vector oldo;
   local entity n;

   WriteByte (MSG_ALL,SVC_FINALE);
   WriteString (MSG_ALL,"Congratulations and well done! You have\nbeaten the real Shub-Niggurath, and most\nof her hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than all\nthe powers of Quake. You are the master now.\nSeriously, for real now.\nShe's dead Jim.\nNo really, not kidding.\nNow it's time you go show the rest of them\nwho is the new master.");
   n = spawn ();
   setmodel (n,"progs/player.mdl");
   oldo = (oldo - '32.000 264.000 0.000');
   setorigin (n,oldo);
   n.angles = '0.000 290.000 0.000';
   n.frame = TRUE;
   remove (self);
   WriteByte (MSG_ALL,SVC_CDTRACK);
   WriteByte (MSG_ALL,MOVETYPE_WALK);
   WriteByte (MSG_ALL,MOVETYPE_WALK);
   lightstyle (FALSE,"m");

};

void (entity attacker, float damage) oldpain = {

   local float counter;

   counter = 18;

   if ( (world.model == "maps/end.bsp") ) {

      self.health = 40000.000; //behave properly on original ID end map
      return;

   }

   if ( (self.pain_finished > time) ) {

      return ;

   }
   self.pain_finished = (time + 1.500);
   sound (self,CHAN_VOICE,"boss/pain.wav",TRUE,ATTN_NORM);
   old_thrash1();
   while ( (counter > FALSE) ) {

      ol_toss ("progs/gib1.mdl");
      ol_toss ("progs/gib1.mdl");
      ol_toss ("progs/gib1.mdl");
      counter = (counter - TRUE);

   }

};

void () monster_oldone = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/oldone.mdl");
   precache_sound2 ("boss2/death.wav");
   precache_sound2 ("boss2/idle.wav");
   precache_sound2 ("boss2/sight.wav");
   precache_sound2 ("boss2/pop2.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   setmodel (self,"progs/oldone.mdl");
   setsize (self,'-160.000 -128.000 -24.000','160.000 128.000 256.000');
   self.health = 400.000;
   self.think = old_idle1;
   self.nextthink = (time + 0.100);
   self.takedamage = DAMAGE_YES;
   self.th_pain = oldpain;
   self.th_stand = old_idle1;
   self.th_run = old_idle1;
   self.th_walk = old_idle1;
   self.th_die = shub_death;
   shub = self;
   total_monsters = (total_monsters + TRUE);

};
