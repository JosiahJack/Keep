
void  ()main =  {
   precache_file ( "gfx.wad");
   precache_file ( "default.cfg");
   precache_file ( "demo1.dem");
   precache_file ( "demo2.dem");
   precache_file ( "demo3.dem");
   Precache_lmp ( );
   precache_sound ( "raven/menu1.wav");
   precache_sound ( "raven/menu2.wav");
   precache_sound ( "raven/menu3.wav");
   precache_sound ( "misc/barmovup.wav");
   precache_sound ( "misc/barmovdn.wav");
   precache_sound ( "misc/invmove.wav");
   precache_sound ( "misc/invuse.wav");
   precache_sound ( "ambience/water1.wav");
   precache_sound ( "ambience/wind2.wav");
   precache_file ( "maps/demo1.bsp");
   precache_file ( "maps/demo2.bsp");
   precache_file ( "maps/ravdm1.bsp");
   precache_file ( "midi/casa1.mid");
   precache_file ( "midi/casa2.mid");
   precache_file ( "midi/egyp3.mid");
   precache_file2 ( "gfx/pop.lmp");
   precache_file2 ( "maps/demo3.bsp");
   precache_file2 ( "maps/castle4.bsp");
   precache_file2 ( "maps/castle5.bsp");
   precache_file2 ( "maps/cath.bsp");
   precache_file2 ( "maps/egypt1.bsp");
   precache_file2 ( "maps/egypt2.bsp");
   precache_file2 ( "maps/egypt3.bsp");
   precache_file2 ( "maps/egypt4.bsp");
   precache_file2 ( "maps/egypt5.bsp");
   precache_file2 ( "maps/egypt6.bsp");
   precache_file2 ( "maps/egypt7.bsp");
   precache_file2 ( "maps/meso1.bsp");
   precache_file2 ( "maps/meso2.bsp");
   precache_file2 ( "maps/meso3.bsp");
   precache_file2 ( "maps/meso4.bsp");
   precache_file2 ( "maps/meso5.bsp");
   precache_file2 ( "maps/meso6.bsp");
   precache_file2 ( "maps/meso8.bsp");
   precache_file2 ( "maps/meso9.bsp");
   precache_file2 ( "maps/rider1a.bsp");
   precache_file2 ( "maps/rider2c.bsp");
   precache_file2 ( "maps/eidolon.bsp");
   precache_file2 ( "maps/romeric1.bsp");
   precache_file2 ( "maps/romeric2.bsp");
   precache_file2 ( "maps/romeric3.bsp");
   precache_file2 ( "maps/romeric4.bsp");
   precache_file2 ( "maps/romeric5.bsp");
   precache_file2 ( "maps/romeric6.bsp");
   precache_file2 ( "maps/romeric7.bsp");
   precache_file2 ( "maps/tower.bsp");
   precache_file2 ( "maps/village1.bsp");
   precache_file2 ( "maps/village2.bsp");
   precache_file2 ( "maps/village3.bsp");
   precache_file2 ( "maps/village4.bsp");
   precache_file2 ( "maps/village5.bsp");
   precache_file2 ( "maps/ravdm2.bsp");
   precache_file2 ( "maps/ravdm3.bsp");
   precache_file2 ( "maps/ravdm4.bsp");
   precache_file2 ( "maps/ravdm5.bsp");
   precache_file2 ( "midi/casa1.mid");
   precache_file2 ( "midi/casa2.mid");
   precache_file2 ( "midi/casa3.mid");
   precache_file2 ( "midi/casa4.mid");
   precache_file2 ( "midi/casb1.mid");
   precache_file2 ( "midi/casb2.mid");
   precache_file2 ( "midi/casb3.mid");
   precache_file2 ( "midi/egyp1.mid");
   precache_file2 ( "midi/egyp2.mid");
   precache_file2 ( "midi/egyp3.mid");
   precache_file2 ( "midi/meso1.mid");
   precache_file2 ( "midi/meso2.mid");
   precache_file2 ( "midi/meso3.mid");
   precache_file2 ( "midi/roma1.mid");
   precache_file2 ( "midi/roma2.mid");
   precache_file2 ( "midi/roma3.mid");
};

entity lastspawn;

void  ()worldspawn =  {
   lastspawn = world;
   if ( ((((((self.model == "maps/eidolon.bsp") || (self.model == "maps/rider1a.bsp")) || (self.model == "maps/meso9.bsp")) || (self.model == "maps/rider2c.bsp")) || (self.model == "maps/romeric6.bsp")) || (self.model == "maps/mgtowers.bsp")) ) {

      cvar_set ( "sv_sound_distance", "0");
   } else {

      cvar_set ( "sv_sound_distance", "800");

   }
   if ( (self.model == "maps/mgtowers.bsp") ) {

      cvar_set ( "sv_gravity", "100");
      cvar_set ( "r_ambient", "36");
   } else {

      cvar_set ( "sv_gravity", "800");

   }
   W_Precache ( );
   Precache_wav ( );
   Precache_Id_mdl ( );
   Precache_mdl ( );
   precache_model ( "models/schunk1.mdl");
   precache_model ( "models/schunk2.mdl");
   precache_model ( "models/schunk3.mdl");
   precache_model ( "models/schunk4.mdl");
   Precache_spr ( );
   lightstyle ( 0.00000, "m");
   lightstyle ( 1.00000, "mmnmmommommnonmmonqnmmo");
   lightstyle ( 2.00000, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
   lightstyle ( 3.00000, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
   lightstyle ( 4.00000, "zzzzzzzzzzzz");
   lightstyle ( 5.00000, "jklmnopqrstuvwxyzyxwvutsrqponmlkj");
   lightstyle ( EF_TORCHLIGHT, "knmonqnmolm");
   lightstyle ( 7.00000, "mmmaaaabcdefgmmmmaaaammmaamm");
   lightstyle ( 8.00000, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
   lightstyle ( 9.00000, "aaaaaaaazzzzzzzz");
   lightstyle ( 10.00000, "mmamammmmammamamaaamammma");
   lightstyle ( 11.00000, "abcdefghijklmnopqrrqponmlkjihgfedcba");
   lightstyle ( 25.00000, "z");
   lightstyle ( 26.00000, "2jklmnooppqqrrrrqqppoonmlkj");
   lightstyle ( 27.00000, "wvtwyzxvtxwyzwv");
   lightstyle ( 28.00000, "jilghmnohjljhfpjnjgpohkjhioomh");
   lightstyle ( 29.00000, "2jklmnooppqqrrrrqqppoonmlkj");
   lightstyle ( 63.00000, "a");
   StringsInit ( );
};


void  ()StartFrame =  {
   teamplay = cvar ( "teamplay");
   skill = cvar ( "skill");
   framecount = (framecount + 1.00000);
};

