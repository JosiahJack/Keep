
void () bubble_bob;

void () player_stand1 = [ 17.000, player_stand1 ] {

   self.weaponframe = FALSE;
   if ( (self.velocity_x || self.velocity_y) ) {

      self.walkframe = FALSE;
      player_run ();
      return ;

   }
   if ( (self.weapon == IT_AXE) ) {

      if ( (self.walkframe >= STAT_TOTALMONSTERS) ) {

         self.walkframe = FALSE;

      }
      self.frame = (17.000 + self.walkframe);

   } else {

      if ( (self.weapon == IT_MJOLNIR) ) {

         if ( (self.walkframe >= STAT_TOTALMONSTERS) ) {

            self.walkframe = FALSE;

         }
         self.frame = (MOVETYPE_TOSS + self.walkframe);

      } else {

         if ( (self.walkframe >= MOVETYPE_FLY) ) {

            self.walkframe = FALSE;

         }
         self.frame = (STAT_TOTALMONSTERS + self.walkframe);

      }

   }
   self.walkframe = (self.walkframe + TRUE);

};

void () player_run = [ 6.000, player_run ] {

   /* Warning: No local name with offset 6628 */
   /* Warning: No local name with offset 6629 */
   /* Warning: No local name with offset 6630 */
   /* Warning: No local name with offset 6631 */
   /* Warning: No local name with offset 6632 */
   /* Warning: No local name with offset 6633 */
   /* Warning: No local name with offset 6634 */
   /* Warning: No local name with offset 6635 */
   /* Warning: No local name with offset 6636 */
   /* Warning: No local name with offset 6637 */
   /* Warning: No local name with offset 6638 */
   /* Warning: No local name with offset 6639 */
   /* Warning: No local name with offset 6640 */
   /* Warning: No local name with offset 6641 */
   /* Warning: No local name with offset 6642 */
   /* Warning: No local name with offset 6643 */
   /* Warning: No local name with offset 6644 */
   /* Warning: No local name with offset 6645 */
   /* Warning: No local name with offset 6646 */
   /* Warning: No local name with offset 6647 */
   /* Warning: No local name with offset 6648 */
   /* Warning: No local name with offset 6649 */
   /* Warning: No local name with offset 6650 */
   /* Warning: No local name with offset 6651 */
   /* Warning: No local name with offset 6652 */
   /* Warning: No local name with offset 6653 */
   /* Warning: No local name with offset 6654 */
   /* Warning: No local name with offset 6655 */
   /* Warning: No local name with offset 6656 */
   /* Warning: No local name with offset 6657 */
   /* Warning: No local name with offset 6658 */
   /* Warning: No local name with offset 6659 */
   /* Warning: No local name with offset 6660 */
   /* Warning: No local name with offset 6661 */
   /* Warning: No local name with offset 6662 */
   /* Warning: No local name with offset 6663 */
   /* Warning: No local name with offset 6664 */
   /* Warning: No local name with offset 6665 */
   /* Warning: No local name with offset 6666 */
   /* Warning: No local name with offset 6667 */
   /* Warning: No local name with offset 6668 */
   /* Warning: No local name with offset 6669 */
   /* Warning: No local name with offset 6670 */
   /* Warning: No local name with offset 6671 */
   /* Warning: No local name with offset 6672 */
   /* Warning: No local name with offset 6673 */
   /* Warning: No local name with offset 6674 */
   /* Warning: No local name with offset 6675 */
   /* Warning: No local name with offset 6676 */
   /* Warning: No local name with offset 6677 */
   /* Warning: No local name with offset 6678 */
   /* Warning: No local name with offset 6679 */
   local float r;

   self.weaponframe = FALSE;
   if ( (!self.velocity_x && !self.velocity_y) ) {

      self.walkframe = FALSE;
      player_stand1 ();
      return ;

   }
   if ( (self.weapon == IT_AXE) ) {

      if ( (self.walkframe == MOVETYPE_TOSS) ) {

         self.walkframe = FALSE;

      }
      self.frame = (FALSE + self.walkframe);

   } else {

      if ( (self.weapon == IT_MJOLNIR) ) {

         if ( (self.walkframe == MOVETYPE_TOSS) ) {

            self.walkframe = FALSE;

         }
         self.frame = self.walkframe;

      } else {

         if ( (self.walkframe == MOVETYPE_TOSS) ) {

            self.walkframe = FALSE;

         }
         self.frame = (self.frame + self.walkframe);

      }

   }
   if ( (footsteps == TRUE) ) {

      self.spawnsilent = (self.spawnsilent + vlen ((self.origin - self.old_velocity)));
      self.old_velocity = self.origin;
      if ( (self.flags & FL_ONGROUND) ) {

         if ( (self.spawnsilent > 95.000) ) {

            if ( (self.spawnsilent > 190.000) ) {

               self.spawnsilent = FALSE;

            } else {

               self.spawnsilent = (0.500 * (self.spawnsilent - 95.000));

            }
            r = random ();
            if ( (r < 0.140) ) {

               sound (self,CHAN_VOICE,"misc/foot1.wav",0.500,ATTN_NORM);

            } else {

               if ( (r < 0.290) ) {

                  sound (self,CHAN_VOICE,"misc/foot2.wav",0.500,ATTN_NORM);

               } else {

                  if ( (r < 0.430) ) {

                     sound (self,CHAN_VOICE,"misc/foot3.wav",0.500,ATTN_NORM);

                  } else {

                     if ( (r < 0.580) ) {

                        sound (self,CHAN_VOICE,"misc/foot4.wav",0.500,ATTN_NORM);

                     } else {

                        if ( (r < 0.720) ) {

                           sound (self,CHAN_VOICE,"misc/foot5.wav",0.500,ATTN_NORM);

                        } else {

                           if ( (r < 0.860) ) {

                              sound (self,CHAN_VOICE,"misc/foot6.wav",0.500,ATTN_NORM);

                           } else {

                              sound (self,CHAN_VOICE,"misc/foot7.wav",0.500,ATTN_NORM);

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   self.walkframe = (self.walkframe + TRUE);

};

void () player_shot1 = [ 113.000, player_shot2 ] {

   self.weaponframe = TRUE;
   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () player_shot2 = [ 114.000, player_shot3 ] {

   self.weaponframe = FL_SWIM;

};

void () player_shot3 = [ 115.000, player_shot4 ] {

   self.weaponframe = MOVETYPE_WALK;

};

void () player_shot4 = [ 116.000, player_shot5 ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_shot5 = [ 117.000, player_shot6 ] {

   self.weaponframe = MOVETYPE_FLY;

};

void () player_shot6 = [ 118.000, player_run ] {

   self.weaponframe = MOVETYPE_TOSS;

};

void () player_axe1 = [ 119.000, player_axe2 ] {

   self.weaponframe = TRUE;

};

void () player_axe2 = [ 120.000, player_axe3 ] {

   self.weaponframe = FL_SWIM;

};

void () player_axe3 = [ 121.000, player_axe4 ] {

   self.weaponframe = MOVETYPE_WALK;
   W_FireAxe ();

};

void () player_axe4 = [ 122.000, player_run ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_axeb1 = [ 125.000, player_axeb2 ] {

   self.weaponframe = MOVETYPE_FLY;

};

void () player_axeb2 = [ 126.000, player_axeb3 ] {

   self.weaponframe = MOVETYPE_TOSS;

};

void () player_axeb3 = [ 127.000, player_axeb4 ] {

   self.weaponframe = MOVETYPE_PUSH;
   W_FireAxe ();

};

void () player_axeb4 = [ 128.000, player_run ] {

   self.weaponframe = FL_CLIENT;

};

void () player_axec1 = [ 131.000, player_axec2 ] {

   self.weaponframe = TRUE;

};

void () player_axec2 = [ 132.000, player_axec3 ] {

   self.weaponframe = FL_SWIM;

};

void () player_axec3 = [ 133.000, player_axec4 ] {

   self.weaponframe = MOVETYPE_WALK;
   W_FireAxe ();

};

void () player_axec4 = [ 134.000, player_run ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_axed1 = [ 137.000, player_axed2 ] {

   self.weaponframe = MOVETYPE_FLY;

};

void () player_axed2 = [ 138.000, player_axed3 ] {

   self.weaponframe = MOVETYPE_TOSS;

};

void () player_axed3 = [ 139.000, player_axed4 ] {

   self.weaponframe = MOVETYPE_PUSH;
   W_FireAxe ();

};

void () player_axed4 = [ 140.000, player_run ] {

   self.weaponframe = FL_CLIENT;

};

void () player_nail1 = [ 103.000, player_nail2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + TRUE);
   if ( (self.weaponframe == MOVETYPE_FLYMISSILE) ) {

      self.weaponframe = TRUE;

   }
   SuperDamageSound ();
   W_FireSpikes (MOVETYPE_STEP);
   self.attack_finished = (time + 0.200);

};

void () player_nail2 = [ 104.000, player_nail1 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + TRUE);
   if ( (self.weaponframe == MOVETYPE_FLYMISSILE) ) {

      self.weaponframe = TRUE;

   }
   SuperDamageSound ();
   W_FireSpikes (CONTENT_SLIME);
   self.attack_finished = (time + 0.200);

};

void () player_light1 = [ 105.000, player_light2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + TRUE);
   if ( (self.weaponframe == MOVETYPE_FLY) ) {

      self.weaponframe = TRUE;

   }
   SuperDamageSound ();
   W_FireLightning ();
   self.attack_finished = (time + 0.200);

};

void () player_light2 = [ 106.000, player_light1 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + TRUE);
   if ( (self.weaponframe == MOVETYPE_FLY) ) {

      self.weaponframe = TRUE;

   }
   SuperDamageSound ();
   W_FireLightning ();
   self.attack_finished = (time + 0.200);

};

void () player_hammer1 = [ 32.000, player_hammer2 ] {

   self.weaponframe = TRUE;

};

void () player_hammer2 = [ 33.000, player_hammer3 ] {

   self.weaponframe = FL_SWIM;

};

void () player_hammer3 = [ 34.000, player_hammer4 ] {

   self.weaponframe = MOVETYPE_WALK;

};

void () player_hammer4 = [ 35.000, player_hammer5 ] {

   self.weaponframe = MOVETYPE_STEP;
   HIP_FireMjolnir ();

};

void () player_hammer5 = [ 36.000, player_hammer6 ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_hammer6 = [ 37.000, player_run ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_mjolnir1 = [ 38.000, player_mjolnir2 ] {

   self.weaponframe = TRUE;

};

void () player_mjolnir2 = [ 39.000, player_mjolnir3 ] {

   self.weaponframe = FL_SWIM;

};

void () player_mjolnir3 = [ 40.000, player_mjolnir4 ] {

   self.weaponframe = MOVETYPE_WALK;

};

void () player_mjolnir4 = [ 41.000, player_mjolnir5 ] {

   self.weaponframe = MOVETYPE_STEP;
   HIP_FireMjolnir ();

};

void () player_mjolnir5 = [ 42.000, player_mjolnir6 ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_mjolnir6 = [ 43.000, player_run ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_laser1 = [ 103.000, player_laser3 ] {

   self.attack_finished = (time + 0.100);
   self.weaponframe = TRUE;
   self.nextthink = (time + 0.100);
   HIP_FireLaser (FALSE);

};

void () player_laser3;

void () player_laser2 = [ 104.000, player_laser3 ] {

   self.attack_finished = (time + 0.100);
   self.weaponframe = FL_SWIM;
   self.nextthink = (time + 0.100);

};

void () player_laser3 = [ 104.000, player_laser1 ] {

   self.attack_finished = (time + 0.100);
   self.weaponframe = MOVETYPE_STEP;
   self.nextthink = (time + 0.100);
   HIP_FireLaser (TRUE);

};

void () player_laser4 = [ 103.000, player_laser1 ] {

   self.attack_finished = (time + 0.100);
   self.weaponframe = MOVETYPE_FLY;
   self.nextthink = (time + 0.100);

};

void () player_rocket1 = [ 107.000, player_rocket2 ] {

   self.weaponframe = TRUE;
   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () player_rocket2 = [ 108.000, player_rocket3 ] {

   self.weaponframe = FL_SWIM;

};

void () player_rocket3 = [ 109.000, player_rocket4 ] {

   self.weaponframe = MOVETYPE_WALK;

};

void () player_rocket4 = [ 110.000, player_rocket5 ] {

   self.weaponframe = MOVETYPE_STEP;

};

void () player_rocket5 = [ 111.000, player_rocket6 ] {

   self.weaponframe = MOVETYPE_FLY;

};

void () player_rocket6 = [ 112.000, player_run ] {

   self.weaponframe = MOVETYPE_TOSS;

};

void () PainSound = {

   local float rs;

   if ( (self.health < FALSE) ) {

      return ;

   }
   if ( (damage_attacker.classname == "teledeath") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",TRUE,ATTN_NONE);
      return ;

   }
   if ( ((self.watertype == CONTENT_WATER) && (self.waterlevel == MOVETYPE_WALK)) ) {

      DeathBubbles (TRUE);
      if ( (random () > 0.500) ) {

         sound (self,CHAN_VOICE,"player/drown1.wav",TRUE,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/drown2.wav",TRUE,ATTN_NORM);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_SLIME) ) {

      if ( (random () > 0.500) ) {

         sound (self,CHAN_VOICE,"player/lburn1.wav",TRUE,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/lburn2.wav",TRUE,ATTN_NORM);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_LAVA) ) {

      if ( (random () > 0.500) ) {

         sound (self,CHAN_VOICE,"player/lburn1.wav",TRUE,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/lburn2.wav",TRUE,ATTN_NORM);

      }
      return ;

   }
   if ( (self.pain_finished > time) ) {

      self.axhitme = FALSE;
      return ;

   }
   self.pain_finished = (time + 0.500);
   if ( (self.axhitme == TRUE) ) {

      self.axhitme = FALSE;
      sound (self,CHAN_VOICE,"player/axhit1.wav",TRUE,ATTN_NORM);
      return ;

   }
   rs = rint (((random () * MOVETYPE_FLY) + TRUE));
   self.noise = "";
   if ( (rs == TRUE) ) {

      self.noise = "player/pain1.wav";

   } else {

      if ( (rs == FL_SWIM) ) {

         self.noise = "player/pain2.wav";

      } else {

         if ( (rs == MOVETYPE_WALK) ) {

            self.noise = "player/pain3.wav";

         } else {

            if ( (rs == MOVETYPE_STEP) ) {

               self.noise = "player/pain4.wav";

            } else {

               if ( (rs == MOVETYPE_FLY) ) {

                  self.noise = "player/pain5.wav";

               } else {

                  self.noise = "player/pain6.wav";

               }

            }

         }

      }

   }
   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NORM);
   return ;

};

void () player_pain1 = [ 35.000, player_pain2 ] {

   PainSound ();
   self.weaponframe = FALSE;

};

void () player_pain2 = [ 36.000, player_pain3 ] {


};

void () player_pain3 = [ 37.000, player_pain4 ] {


};

void () player_pain4 = [ 38.000, player_pain5 ] {


};

void () player_pain5 = [ 39.000, player_pain6 ] {


};

void () player_pain6 = [ 40.000, player_run ] {


};

void () player_axpain1 = [ 29.000, player_axpain2 ] {

   PainSound ();
   self.weaponframe = FALSE;

};

void () player_axpain2 = [ 30.000, player_axpain3 ] {


};

void () player_axpain3 = [ 31.000, player_axpain4 ] {


};

void () player_axpain4 = [ 32.000, player_axpain5 ] {


};

void () player_axpain5 = [ 33.000, player_axpain6 ] {


};

void () player_axpain6 = [ 34.000, player_run ] {


};

void () player_hampain1 = [ 18.000, player_hampain2 ] {

   PainSound ();
   self.weaponframe = FALSE;

};

void () player_hampain2 = [ 19.000, player_hampain3 ] {


};

void () player_hampain3 = [ 20.000, player_hampain4 ] {


};

void () player_hampain4 = [ 21.000, player_hampain5 ] {


};

void () player_hampain5 = [ 22.000, player_hampain6 ] {


};

void () player_hampain6 = [ 23.000, player_run ] {


};

void () player_pain = {

   if ( self.weaponframe ) {

      return ;

   }
   if ( (self.invisible_finished > time) ) {

      return ;

   }
   if ( (self.weapon == IT_AXE) ) {

      player_axpain1 ();

   } else {

      if ( (self.weapon == IT_MJOLNIR) ) {

         player_hampain1 ();

      } else {

         player_pain1 ();

      }

   }

};

void () player_diea1;

void () player_dieb1;

void () player_diec1;

void () player_died1;

void () player_diee1;

void () player_die_ax1;

void () player_die_ham1;

void () DeathBubblesSpawn = {

   local entity bubble;

   if ( (self.owner.waterlevel != MOVETYPE_WALK) ) {

      return ;

   }
   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,(self.owner.origin + '0.000 0.000 24.000'));
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = '0.000 0.000 15.000';
   bubble.nextthink = (time + 0.500);
   bubble.think = bubble_bob;
   bubble.classname = "bubble";
   bubble.frame = FALSE;
   bubble.cnt = FALSE;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.nextthink = (time + 0.100);
   self.think = DeathBubblesSpawn;
   self.air_finished = (self.air_finished + TRUE);
   if ( (self.air_finished >= self.bubble_count) ) {

      remove (self);

   }

};

void (float num_bubbles) DeathBubbles = {

   local entity bubble_spawner;

   bubble_spawner = spawn ();
   setorigin (bubble_spawner,self.origin);
   bubble_spawner.movetype = MOVETYPE_NONE;
   bubble_spawner.solid = SOLID_NOT;
   bubble_spawner.nextthink = (time + 0.100);
   bubble_spawner.think = DeathBubblesSpawn;
   bubble_spawner.air_finished = FALSE;
   bubble_spawner.owner = self;
   bubble_spawner.bubble_count = num_bubbles;
   return ;

};

void () DeathSound = {

   local float rs;

   if ( (self.waterlevel == MOVETYPE_WALK) ) {

      DeathBubbles (20.000);
      sound (self,CHAN_VOICE,"player/h2odeath.wav",TRUE,ATTN_NONE);
      return ;

   }
   rs = rint (((random () * MOVETYPE_STEP) + TRUE));
   if ( (rs == TRUE) ) {

      self.noise = "player/death1.wav";

   }
   if ( (rs == FL_SWIM) ) {

      self.noise = "player/death2.wav";

   }
   if ( (rs == MOVETYPE_WALK) ) {

      self.noise = "player/death3.wav";

   }
   if ( (rs == MOVETYPE_STEP) ) {

      self.noise = "player/death4.wav";

   }
   if ( (rs == MOVETYPE_FLY) ) {

      self.noise = "player/death5.wav";

   }
   sound (self,CHAN_VOICE,self.noise,TRUE,ATTN_NONE);
   return ;

};

void () PlayerDead = {

   self.nextthink = CONTENT_EMPTY;
   self.deadflag = DEAD_DEAD;

};
vector (float dm) VelocityForDamage = {

   local vector v;

   if ( (vlen (damage_inflictor.velocity) > FALSE) ) {

      v = (0.200 * damage_inflictor.velocity);
      v = (v + (25.000 * normalize ((self.origin - damage_inflictor.origin))));
      v_z = (100.000 + (100.000 * random ()));
      v_x = (v_x + (50.000 * crandom ()));
      v_y = (v_y + (50.000 * crandom ()));

   } else {

      v_x = (100.000 * crandom ());
      v_y = (100.000 * crandom ());
      v_z = (MAX_CHARMER_DISTANCE + (100.000 * random ()));

   }
   if ( (dm > -50.000) ) {

      v = (v * 0.700);

   } else {

      if ( (dm > -200.000) ) {

         v = (v * FL_SWIM);

      } else {

         v = (v * MOVETYPE_BOUNCE);

      }

   }
   return ( v );

};

void (string gibname, float dm) ThrowGib = {

   local entity new;

   new = spawn ();
   new.origin = self.origin;
   setmodel (new,gibname);
   setsize (new,VEC_ORIGIN,VEC_ORIGIN);
   new.velocity = VelocityForDamage (dm);
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_NOT;
   new.avelocity_x = (random () * 600.000);
   new.avelocity_y = (random () * 600.000);
   new.avelocity_z = (random () * 600.000);
   new.think = SUB_Remove;
   new.ltime = time;
   new.nextthink = ((time + MOVETYPE_BOUNCE) + (random () * MOVETYPE_BOUNCE));
   new.frame = FALSE;
   new.flags = FALSE;

};

void () HeadThink = {

   self.nextthink = CONTENT_EMPTY;
   if ( (world.worldtype != FL_SWIM) ) {

      if ( (random () < 0.100) ) {

         sound (self,MOVETYPE_TOSS,"misc/flys.wav",0.700,ATTN_STATIC);

      }

   }

};

void (string gibname, float dm) ThrowHead = {

   setmodel (self,gibname);
   self.frame = FALSE;
   self.nextthink = (time + 1.500);
   self.movetype = MOVETYPE_BOUNCE;
   self.takedamage = DAMAGE_NO;
   self.solid = SOLID_NOT;
   self.view_ofs = '0.000 0.000 8.000';
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   self.velocity = VelocityForDamage (dm);
   self.origin_z = (self.origin_z - 24.000);
   self.flags = (self.flags - (self.flags & FL_ONGROUND));
   self.avelocity = (crandom () * '0.000 600.000 0.000');
   self.gorging = TRUE;
   self.think = HeadThink;

};

void () GibPlayer = {

   ThrowHead ("progs/h_player.mdl",self.health);
   ThrowGib ("progs/gib1.mdl",self.health);
   ThrowGib ("progs/gib2.mdl",self.health);
   ThrowGib ("progs/gib3.mdl",self.health);
   self.deadflag = DEAD_DEAD;
   if ( (damage_attacker.classname == "teledeath") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",TRUE,ATTN_NONE);
      return ;

   }
   if ( (damage_attacker.classname == "teledeath2") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",TRUE,ATTN_NONE);
      return ;

   }
   if ( (random () < 0.500) ) {

      sound (self,CHAN_VOICE,"player/gib.wav",TRUE,ATTN_NONE);

   } else {

      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NONE);

   }

};

void () PlayerDie = {

   local float i;

   self.items = (self.items - (self.items & IT_INVISIBILITY));
   self.invisible_finished = FALSE;
   self.invincible_finished = FALSE;
   self.super_damage_finished = FALSE;
   self.radsuit_finished = FALSE;
   self.wetsuit_finished = FALSE;
   self.modelindex = modelindex_player;
   self.empathy_finished = FALSE;
   self.items2 = (self.items2 - (self.items2 & HIP_IT_EMPATHY_SHIELDS));
   if ( (deathmatch || coop) ) {

      DropBackpack ();

   }
   self.weaponmodel = "";
   self.view_ofs = '0.000 0.000 -8.000';
   self.deadflag = DEAD_DYING;
   self.solid = SOLID_NOT;
   self.flags = (self.flags - (self.flags & FL_ONGROUND));
   self.movetype = MOVETYPE_TOSS;
   if ( (self.velocity_z < MOVETYPE_BOUNCE) ) {

      self.velocity_z = (self.velocity_z + (random () * 300.000));

   }
   if ( (self.health < -40.000) ) {

      GibPlayer ();
      return ;

   }
   DeathSound ();
   self.angles_x = FALSE;
   self.angles_z = FALSE;
   if ( (self.weapon == IT_AXE) ) {

      player_die_ax1 ();
      return ;

   } else {

      if ( (self.weapon == IT_MJOLNIR) ) {

         self.modelindex = modelindex_hammer;
         player_die_ham1 ();
         return ;

      }

   }
   i = cvar ("temp1");
   if ( !i ) {

      i = (TRUE + floor ((random () * MOVETYPE_TOSS)));

   }
   if ( (i == TRUE) ) {

      player_diea1 ();

   } else {

      if ( (i == FL_SWIM) ) {

         player_dieb1 ();

      } else {

         if ( (i == MOVETYPE_WALK) ) {

            player_diec1 ();

         } else {

            if ( (i == MOVETYPE_STEP) ) {

               player_died1 ();

            } else {

               player_diee1 ();

            }

         }

      }

   }

};

void () set_suicide_frame = {

   if ( (self.model != "progs/player.mdl") ) {

      return ;

   }
   self.frame = 60.000;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_TOSS;
   self.deadflag = DEAD_DEAD;
   self.nextthink = CONTENT_EMPTY;

};

void () player_diea1 = [ 50.000, player_diea2 ] {


};

void () player_diea2 = [ 51.000, player_diea3 ] {


};

void () player_diea3 = [ 52.000, player_diea4 ] {


};

void () player_diea4 = [ 53.000, player_diea5 ] {


};

void () player_diea5 = [ 54.000, player_diea6 ] {


};

void () player_diea6 = [ 55.000, player_diea7 ] {


};

void () player_diea7 = [ 56.000, player_diea8 ] {


};

void () player_diea8 = [ 57.000, player_diea9 ] {


};

void () player_diea9 = [ 58.000, player_diea10 ] {


};

void () player_diea10 = [ 59.000, player_diea11 ] {


};

void () player_diea11 = [ 60.000, player_diea11 ] {

   PlayerDead ();

};

void () player_dieb1 = [ 61.000, player_dieb2 ] {


};

void () player_dieb2 = [ 62.000, player_dieb3 ] {


};

void () player_dieb3 = [ 63.000, player_dieb4 ] {


};

void () player_dieb4 = [ 64.000, player_dieb5 ] {


};

void () player_dieb5 = [ 65.000, player_dieb6 ] {


};

void () player_dieb6 = [ 66.000, player_dieb7 ] {


};

void () player_dieb7 = [ 67.000, player_dieb8 ] {


};

void () player_dieb8 = [ 68.000, player_dieb9 ] {


};

void () player_dieb9 = [ 69.000, player_dieb9 ] {

   PlayerDead ();

};

void () player_diec1 = [ 70.000, player_diec2 ] {


};

void () player_diec2 = [ 71.000, player_diec3 ] {


};

void () player_diec3 = [ 72.000, player_diec4 ] {


};

void () player_diec4 = [ 73.000, player_diec5 ] {


};

void () player_diec5 = [ 74.000, player_diec6 ] {


};

void () player_diec6 = [ 75.000, player_diec7 ] {


};

void () player_diec7 = [ 76.000, player_diec8 ] {


};

void () player_diec8 = [ 77.000, player_diec9 ] {


};

void () player_diec9 = [ 78.000, player_diec10 ] {


};

void () player_diec10 = [ 79.000, player_diec11 ] {


};

void () player_diec11 = [ 80.000, player_diec12 ] {


};

void () player_diec12 = [ 81.000, player_diec13 ] {


};

void () player_diec13 = [ 82.000, player_diec14 ] {


};

void () player_diec14 = [ 83.000, player_diec15 ] {


};

void () player_diec15 = [ 84.000, player_diec15 ] {

   PlayerDead ();

};

void () player_died1 = [ 85.000, player_died2 ] {


};

void () player_died2 = [ 86.000, player_died3 ] {


};

void () player_died3 = [ 87.000, player_died4 ] {


};

void () player_died4 = [ 88.000, player_died5 ] {


};

void () player_died5 = [ 89.000, player_died6 ] {


};

void () player_died6 = [ 90.000, player_died7 ] {


};

void () player_died7 = [ 91.000, player_died8 ] {


};

void () player_died8 = [ 92.000, player_died9 ] {


};

void () player_died9 = [ 93.000, player_died9 ] {

   PlayerDead ();

};

void () player_diee1 = [ 94.000, player_diee2 ] {


};

void () player_diee2 = [ 95.000, player_diee3 ] {


};

void () player_diee3 = [ 96.000, player_diee4 ] {


};

void () player_diee4 = [ 97.000, player_diee5 ] {


};

void () player_diee5 = [ 98.000, player_diee6 ] {


};

void () player_diee6 = [ 99.000, player_diee7 ] {


};

void () player_diee7 = [ 100.000, player_diee8 ] {


};

void () player_diee8 = [ 101.000, player_diee9 ] {


};

void () player_diee9 = [ 102.000, player_diee9 ] {

   PlayerDead ();

};

void () player_die_ax1 = [ 41.000, player_die_ax2 ] {


};

void () player_die_ax2 = [ 42.000, player_die_ax3 ] {


};

void () player_die_ax3 = [ 43.000, player_die_ax4 ] {


};

void () player_die_ax4 = [ 44.000, player_die_ax5 ] {


};

void () player_die_ax5 = [ 45.000, player_die_ax6 ] {


};

void () player_die_ax6 = [ 46.000, player_die_ax7 ] {


};

void () player_die_ax7 = [ 47.000, player_die_ax8 ] {


};

void () player_die_ax8 = [ 48.000, player_die_ax9 ] {


};

void () player_die_ax9 = [ 49.000, player_die_ax9 ] {

   PlayerDead ();

};

void () player_die_ham1 = [ 24.000, player_die_ham2 ] {


};

void () player_die_ham2 = [ 25.000, player_die_ham3 ] {


};

void () player_die_ham3 = [ 26.000, player_die_ham4 ] {


};

void () player_die_ham4 = [ 27.000, player_die_ham5 ] {


};

void () player_die_ham5 = [ 28.000, player_die_ham6 ] {


};

void () player_die_ham6 = [ 29.000, player_die_ham7 ] {


};

void () player_die_ham7 = [ 30.000, player_die_ham8 ] {


};

void () player_die_ham8 = [ 31.000, player_die_ham8 ] {

   PlayerDead ();

};
