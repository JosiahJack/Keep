
void () finale_1;

void () finale_2;

void () finale_3;

void () finale_4;
entity shub;

void () old_idle1 = [ 0.000, old_idle2 ] {


};

void () old_idle2 = [ 1.000, old_idle3 ] {


};

void () old_idle3 = [ 2.000, old_idle4 ] {


};

void () old_idle4 = [ 3.000, old_idle5 ] {


};

void () old_idle5 = [ 4.000, old_idle6 ] {


};

void () old_idle6 = [ 5.000, old_idle7 ] {


};

void () old_idle7 = [ 6.000, old_idle8 ] {


};

void () old_idle8 = [ 7.000, old_idle9 ] {


};

void () old_idle9 = [ 8.000, old_idle10 ] {


};

void () old_idle10 = [ 9.000, old_idle11 ] {


};

void () old_idle11 = [ 10.000, old_idle12 ] {


};

void () old_idle12 = [ 11.000, old_idle13 ] {


};

void () old_idle13 = [ 12.000, old_idle14 ] {


};

void () old_idle14 = [ 13.000, old_idle15 ] {


};

void () old_idle15 = [ 14.000, old_idle16 ] {


};

void () old_idle16 = [ 15.000, old_idle17 ] {


};

void () old_idle17 = [ 16.000, old_idle18 ] {


};

void () old_idle18 = [ 17.000, old_idle19 ] {


};

void () old_idle19 = [ 18.000, old_idle20 ] {


};

void () old_idle20 = [ 19.000, old_idle21 ] {


};

void () old_idle21 = [ 20.000, old_idle22 ] {


};

void () old_idle22 = [ 21.000, old_idle23 ] {


};

void () old_idle23 = [ 22.000, old_idle24 ] {


};

void () old_idle24 = [ 23.000, old_idle25 ] {


};

void () old_idle25 = [ 24.000, old_idle26 ] {


};

void () old_idle26 = [ 25.000, old_idle27 ] {


};

void () old_idle27 = [ 26.000, old_idle28 ] {


};

void () old_idle28 = [ 27.000, old_idle29 ] {


};

void () old_idle29 = [ 28.000, old_idle30 ] {


};

void () old_idle30 = [ 29.000, old_idle31 ] {


};

void () old_idle31 = [ 30.000, old_idle32 ] {


};

void () old_idle32 = [ 31.000, old_idle33 ] {


};

void () old_idle33 = [ 32.000, old_idle34 ] {


};

void () old_idle34 = [ 33.000, old_idle35 ] {


};

void () old_idle35 = [ 34.000, old_idle36 ] {


};

void () old_idle36 = [ 35.000, old_idle37 ] {


};

void () old_idle37 = [ 36.000, old_idle38 ] {


};

void () old_idle38 = [ 37.000, old_idle39 ] {


};

void () old_idle39 = [ 38.000, old_idle40 ] {


};

void () old_idle40 = [ 39.000, old_idle41 ] {


};

void () old_idle41 = [ 40.000, old_idle42 ] {


};

void () old_idle42 = [ 41.000, old_idle43 ] {


};

void () old_idle43 = [ 42.000, old_idle44 ] {


};

void () old_idle44 = [ 43.000, old_idle45 ] {


};

void () old_idle45 = [ 44.000, old_idle46 ] {


};

void () old_idle46 = [ 45.000, old_idle1 ] {


};

void () old_thrash1 = [ 46.000, old_thrash2 ] {

   lightstyle (FALSE,"m");

};

void () old_thrash2 = [ 47.000, old_thrash3 ] {

   lightstyle (FALSE,"k");

};

void () old_thrash3 = [ 48.000, old_thrash4 ] {

   lightstyle (FALSE,"k");

};

void () old_thrash4 = [ 49.000, old_thrash5 ] {

   lightstyle (FALSE,"i");

};

void () old_thrash5 = [ 50.000, old_thrash6 ] {

   lightstyle (FALSE,"g");

};

void () old_thrash6 = [ 51.000, old_thrash7 ] {

   lightstyle (FALSE,"e");

};

void () old_thrash7 = [ 52.000, old_thrash8 ] {

   lightstyle (FALSE,"c");

};

void () old_thrash8 = [ 53.000, old_thrash9 ] {

   lightstyle (FALSE,"a");

};

void () old_thrash9 = [ 54.000, old_thrash10 ] {

   lightstyle (FALSE,"c");

};

void () old_thrash10 = [ 55.000, old_thrash11 ] {

   lightstyle (FALSE,"e");

};

void () old_thrash11 = [ 56.000, old_thrash12 ] {

   lightstyle (FALSE,"g");

};

void () old_thrash12 = [ 57.000, old_thrash13 ] {

   lightstyle (FALSE,"i");

};

void () old_thrash13 = [ 59.000, old_thrash14 ] {

   lightstyle (FALSE,"k");

};

void () old_thrash14 = [ 60.000, old_thrash15 ] {

   lightstyle (FALSE,"m");

};

void () old_thrash15 = [ 61.000, old_thrash16 ] {

   lightstyle (FALSE,"m");
   self.cnt = (self.cnt + TRUE);
   if ( (self.cnt != MOVETYPE_WALK) ) {

      self.think = old_thrash1;

   }

};

void () old_thrash16 = [ 62.000, old_thrash17 ] {

   lightstyle (FALSE,"g");

};

void () old_thrash17 = [ 63.000, old_thrash18 ] {

   lightstyle (FALSE,"c");

};

void () old_thrash18 = [ 64.000, old_thrash19 ] {

   lightstyle (FALSE,"b");

};

void () old_thrash19 = [ 65.000, old_thrash20 ] {

   lightstyle (FALSE,"a");

};

void () old_thrash20 = [ 66.000, old_thrash20 ] {

   finale_4 ();

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
   if ( !pl ) {

      error ("no teleporttrain");

   }
   remove (pl);
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

   local vector o;

   o = (shub.origin - '0.000 100.000 0.000');
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_TELEPORT);
   WriteCoord (MSG_BROADCAST,o_x);
   WriteCoord (MSG_BROADCAST,o_y);
   WriteCoord (MSG_BROADCAST,o_z);
   sound (shub,CHAN_VOICE,"misc/r_tele1.wav",TRUE,ATTN_NORM);
   self.nextthink = (time + FL_SWIM);
   self.think = finale_3;

};

void () finale_3 = {

   shub.think = old_thrash1;
   sound (shub,CHAN_VOICE,"boss2/death.wav",TRUE,ATTN_NORM);
   lightstyle (FALSE,"abcdefghijklmlkjihgfedcb");

};

void () finale_4 = {

   local vector oldo;
   local float x;
   local float y;
   local float z;
   local float r;
   local entity n;

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

               ThrowGib ("progs/gib1.mdl",-999.000);

            } else {

               if ( (r < 0.600) ) {

                  ThrowGib ("progs/gib2.mdl",-999.000);

               } else {

                  ThrowGib ("progs/gib3.mdl",-999.000);

               }

            }
            y = (y + FL_MONSTER);

         }
         x = (x + FL_MONSTER);

      }
      z = (z + 96.000);

   }
   WriteByte (MSG_ALL,SVC_FINALE);
   WriteString (MSG_ALL,"Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id S...");
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

void () nopain = {

   self.health = 40000.000;

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
   self.health = 40000.000;
   self.think = old_idle1;
   self.nextthink = (time + 0.100);
   self.takedamage = DAMAGE_YES;
   self.th_pain = nopain;
   self.th_die = finale_1;
   shub = self;
   total_monsters = (total_monsters + TRUE);

};
