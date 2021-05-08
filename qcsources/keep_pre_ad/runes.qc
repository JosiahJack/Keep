.float rune;
.float runetime;
.float rune1_last_noise_time;
.float rune2_last_noise_time;
.float rune3_last_noise_time;
.float rune4_last_regen_time;
float runespawn /* = 0.000 */;
entity rune_spawn_spot;
float ITEM_RUNE1    = 1.000;
float ITEM_RUNE2    = 2.000;
float ITEM_RUNE3    = 4.000;
float ITEM_RUNE4    = 8.000;

void () RuneTouch = {

   if ( ((other.classname != "player") || (other.health <= FALSE)) ) {

      return ;

   }
   if ( other.rune ) {

      if ( (other.runetime < time) ) {

         centerprint (other,"You already have a rune\n");

      }
      other.runetime = (time + MOVETYPE_FLY);
      return ;

   }
   other.rune = (other.rune | self.rune);
   sound (other,CHAN_ITEM,"weapons/pkup.wav",TRUE,ATTN_NORM);
   if ( (self.rune & ITEM_RUNE1) ) {

      centerprint (other,"Earth Magic\n\nRESISTANCE");

   } else {

      if ( (self.rune & ITEM_RUNE2) ) {

         centerprint (other,"Black Magic\n\nSTRENGTH");

      } else {

         if ( (self.rune & ITEM_RUNE3) ) {

            centerprint (other,"Hell Magic\n\nHASTE");

         } else {

            if ( (self.rune & ITEM_RUNE4) ) {

               centerprint (other,"Edler Magic\n\nRegeneration");

            }

         }

      }

   }
   remove (self);

};
entity () RuneSpawnPoint = {

   while ( TRUE ) {

      rune_spawn_spot = find (rune_spawn_spot,classname,"info_player_deathmatch");
      if ( (rune_spawn_spot != world) ) {

         return ( rune_spawn_spot );

      }

   }

};

void () RuneRespawn = {

   local entity spot;

   spot = RuneSpawnPoint ();
   setorigin (self,spot.origin);
   self.velocity_z = 300.000;
   self.velocity_x = (-300.000 + (random () * 600.000));
   self.velocity_y = (-300.000 + (random () * 600.000));
   self.nextthink = (time + CTF_UPDATE_TIME);

};

void (float r, entity spot) SpawnRune = {

   local entity item;

   if ( (spot == world) ) {

      spot = RuneSpawnPoint ();

   }
   item = spawn ();
   setorigin (item,spot.origin);
   item.rune = r;
   item.velocity_z = 300.000;
   item.velocity_x = (-300.000 + (random () * 600.000));
   item.velocity_y = (-300.000 + (random () * 600.000));
   item.flags = FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_TOSS;
   if ( (r & ITEM_RUNE1) ) {

      setmodel (item,"progs/end1.mdl");

   } else {

      if ( (r & ITEM_RUNE2) ) {

         setmodel (item,"progs/end2.mdl");

      } else {

         if ( (r & ITEM_RUNE3) ) {

            setmodel (item,"progs/end3.mdl");

         } else {

            if ( (r & ITEM_RUNE4) ) {

               setmodel (item,"progs/end4.mdl");

            }

         }

      }

   }
   setsize (item,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   item.touch = RuneTouch;
   item.nextthink = (time + CTF_UPDATE_TIME);
   item.think = RuneRespawn;

};

void () DropRune = {

   if ( (self.rune & ITEM_RUNE1) ) {

      SpawnRune (ITEM_RUNE1,self);

   }
   if ( (self.rune & ITEM_RUNE2) ) {

      SpawnRune (ITEM_RUNE2,self);

   }
   if ( (self.rune & ITEM_RUNE3) ) {

      SpawnRune (ITEM_RUNE3,self);

   }
   if ( (self.rune & ITEM_RUNE4) ) {

      SpawnRune (ITEM_RUNE4,self);

   }
   self.rune = FALSE;

};

void () DoSpawnRunes = {

   remove (self);
   SpawnRune (ITEM_RUNE1,world);
   SpawnRune (ITEM_RUNE2,world);
   SpawnRune (ITEM_RUNE3,world);
   SpawnRune (ITEM_RUNE4,world);

};

void () SpawnRunes = {

   local entity spawner;

   if ( ((!deathmatch || !(cvar ("gamecfg") & GAMECFG_ENABLE_RUNES)) || runespawn) ) {

      return ;

   }
   runespawn = TRUE;
   spawner = spawn ();
   spawner.think = DoSpawnRunes;
   spawner.nextthink = (time + 0.100);

};
float (float damage, entity who) RuneApplyEarth = {

   if ( (who.rune & ITEM_RUNE1) ) {

      if ( (who.rune1_last_noise_time < time) ) {

         sound (who,CHAN_ITEM,"runes/end1.wav",TRUE,ATTN_NORM);
         who.rune1_last_noise_time = (time + TRUE);

      }
      return ( (damage / FL_SWIM) );

   }
   return ( damage );

};

void (entity who) RuneApplyBlackNoise = {

   if ( (who.rune & ITEM_RUNE2) ) {

      if ( (who.rune2_last_noise_time < time) ) {

         sound (who,CHAN_ITEM,"runes/end2.wav",TRUE,ATTN_NORM);
         who.rune2_last_noise_time = (time + TRUE);

      }

   }

};
float (float damage, entity who) RuneApplyBlack = {

   if ( (who.rune & ITEM_RUNE2) ) {

      return ( (damage * FL_SWIM) );

   }
   return ( damage );

};
float (float tvalue, entity who) RuneApplyHell = {

   if ( (who.rune & ITEM_RUNE3) ) {

      if ( (who.rune3_last_noise_time < time) ) {

         sound (who,CHAN_ITEM,"runes/end3.wav",TRUE,ATTN_NORM);
         who.rune3_last_noise_time = (time + TRUE);

      }
      return ( ((tvalue * FL_SWIM) / MOVETYPE_WALK) );

   }
   return ( tvalue );

};

void (entity who) RuneApplyElder = {

   if ( (who.rune & ITEM_RUNE4) ) {

      if ( ((who.rune4_last_regen_time < time) && (who.health < 100.000)) ) {

         sound (who,CHAN_ITEM,"runes/end4.wav",TRUE,ATTN_NORM);
         who.health = (who.health + MOVETYPE_FLY);
         if ( (who.health > 100.000) ) {

            who.health = 100.000;

         }
         who.rune4_last_regen_time = (time + TRUE);

      }

   }

};
float (entity who) RuneHasElder = {

   if ( (who.rune & ITEM_RUNE4) ) {

      return ( TRUE );

   }
   return ( FALSE );

};

void () RunePrecache = {

   if ( cvar ("deathmatch") ) {

      if ( (cvar ("gamecfg") & GAMECFG_ENABLE_RUNES) ) {

         precache_model ("progs/end1.mdl");
         precache_model ("progs/end2.mdl");
         precache_model ("progs/end3.mdl");
         precache_model ("progs/end4.mdl");
         precache_sound ("runes/end1.wav");
         precache_sound ("runes/end2.wav");
         precache_sound ("runes/end3.wav");
         precache_sound ("runes/end4.wav");

      }

   }

};
