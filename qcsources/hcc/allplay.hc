void  ()bubble_bob;

void  ()PlayerSpeed_Calc =  {
   if ( (self.playerclass == CLASS_PALADIN) ) {

      self.hasted = 1.00000;
   } else {

      if ( (self.playerclass == CLASS_ASSASSIN) ) {

         self.hasted = 0.97000;
      } else {

         if ( (self.playerclass == CLASS_CRUSADER) ) {

            self.hasted = 0.95000;
         } else {

            if ( (self.playerclass == CLASS_NECROMANCER) ) {

               self.hasted = 0.93000;

            }

         }

      }

   }
   if ( (self.artifact_active & ART_HASTE) ) {

      self.hasted *= 2.75000;

   }
   if ( (self.hull == HULL_CROUCH) ) {

      self.hasted *= 0.60000;

   }
};


vector  (float dm)VelocityForDamage =  {
local vector v = '0.00000 0.00000 0.00000';
   v = random('-100.00000 -100.00000 200.00000','100.00000 100.00000 300.00000');
   if ( (dm > -50.00000) ) {

      v = (v * 0.70000);
   } else {

      if ( (dm > -200.00000) ) {

         v = (v * 2.00000);
      } else {

         v = (v * 10.00000);

      }

   }
   return ( v );
};


void  ()ReadySolid =  {
   if ( !self.headmodel ) {

      self.headmodel = "models/flesh1.mdl";

   }
   MakeSolidCorpse ( );
};


void  ()StandardPain =  {
   if ( (self.playerclass == CLASS_ASSASSIN) ) {

      if ( (random() > 0.50000) ) {

         sound ( self, CHAN_VOICE, "player/asspain1.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "player/asspain2.wav", 1.00000, ATTN_NORM);

      }
   } else {

      if ( (random() > 0.50000) ) {

         sound ( self, CHAN_VOICE, "player/palpain1.wav", 1.00000, ATTN_NORM);
      } else {

         sound ( self, CHAN_VOICE, "player/palpain2.wav", 1.00000, ATTN_NORM);

      }

   }
};


void  ()PainSound =  {
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   if ( ((((self.deathtype == "teledeath") || (self.deathtype == "teledeath2")) || (self.deathtype == "teledeath3")) || (self.deathtype == "teledeath4")) ) {

      sound ( self, CHAN_VOICE, "player/telefrag.wav", 1.00000, ATTN_NONE);
      return ;

   }
   if ( (self.pain_finished > time) ) {

      return ;

   }
   self.pain_finished = (time + 0.50000);
   if ( (self.model == "models/sheep.mdl") ) {

      sheep_sound ( 1.00000);
   } else {

      if ( ((self.watertype == CONTENT_WATER) && (self.waterlevel == 3.00000)) ) {

         if ( (self.playerclass == CLASS_ASSASSIN) ) {

            sound ( self, CHAN_VOICE, "player/assdrown.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "player/paldrown.wav", 1.00000, ATTN_NORM);

         }
      } else {

         StandardPain ( );

      }

   }
};


void  ()player_pain =  {
   if ( (self.attack_finished > time) ) {

      return ;

   }
   PainSound ( );
   self.weaponframe = 0.00000;
   if ( (self.hull == HULL_PLAYER) ) {

      self.act_state = ACT_PAIN;
   } else {

      self.act_state = ACT_CROUCH_MOVE;

   }
};


void  ()DeathBubblesSpawn =  {
local entity bubble;
local vector offset = '0.00000 0.00000 0.00000';
   offset_x = random(18.00000,-18.00000);
   offset_y = random(18.00000,-18.00000);
   if ( (pointcontents ( (self.owner.origin + self.owner.view_ofs)) != CONTENT_WATER) ) {

      remove ( self);
      return ;

   }
   bubble = spawn_temp ( );
   setmodel ( bubble, "models/s_bubble.spr");
   setorigin ( bubble, ((self.owner.origin + self.owner.view_ofs) + offset));
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = '0.00000 0.00000 17.00000';
   AdvanceThinkTime(bubble,0.50000);
   bubble.think = bubble_bob;
   bubble.classname = "bubble";
   bubble.frame = 0.00000;
   bubble.cnt = 0.00000;
   bubble.abslight = 0.50000;
   bubble.drawflags |= (DRF_TRANSLUCENT | MLS_ABSLIGHT);
   setsize ( bubble, '-8.00000 -8.00000 -8.00000', '8.00000 8.00000 8.00000');
   AdvanceThinkTime(self,0.10000);
   self.think = DeathBubblesSpawn;
   self.air_finished = (self.air_finished + 1.00000);
   if ( (self.air_finished >= self.bubble_count) ) {

      remove ( self);

   }
};


void  (float num_bubbles)DeathBubbles =  {
local entity bubble_spawner;
local entity bubble_owner;
   if ( (self.classname == "contents damager") ) {

      bubble_owner = self.enemy;
   } else {

      bubble_owner = self;

   }
   bubble_spawner = spawn ( );
   setorigin ( bubble_spawner, (bubble_owner.origin + bubble_owner.view_ofs));
   bubble_spawner.movetype = MOVETYPE_NONE;
   bubble_spawner.solid = SOLID_NOT;
   bubble_spawner.owner = bubble_owner;
   AdvanceThinkTime(bubble_spawner,0.10000);
   bubble_spawner.think = DeathBubblesSpawn;
   bubble_spawner.air_finished = 0.00000;
   bubble_spawner.bubble_count = num_bubbles;
   return ;
};


void  ()DeathSound =  {
   if ( (self.waterlevel == 3.00000) ) {

      DeathBubbles ( 20.00000);
      if ( (self.playerclass == CLASS_ASSASSIN) ) {

         sound ( self, CHAN_VOICE, "player/assdieh2.wav", 1.00000, ATTN_NONE);
      } else {

         sound ( self, CHAN_VOICE, "player/paldieh2.wav", 1.00000, ATTN_NONE);

      }
      return ;
   } else {

      if ( (self.playerclass == CLASS_ASSASSIN) ) {

         if ( (random() > 0.50000) ) {

            sound ( self, CHAN_VOICE, "player/assdie1.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "player/assdie2.wav", 1.00000, ATTN_NORM);

         }
      } else {

         if ( (random() > 0.50000) ) {

            sound ( self, CHAN_VOICE, "player/paldie1.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, "player/paldie2.wav", 1.00000, ATTN_NORM);

         }

      }

   }
   return ;
};


void  ()PlayerDead =  {
   self.nextthink = -1.00000;
   self.deadflag = DEAD_DEAD;
   if ( (self.model != self.headmodel) ) {

      self.angles_z = 0.00000;
      self.angles_x = 0.00000;
      pitch_roll_for_slope ( '0.00000 0.00000 0.00000');

   }
};


void  (string gibname,float dm)ThrowGib =  {
local entity new;
   new = spawn_temp ( );
   new.origin = ((self.absmin + self.absmax) * 0.50000);
   setmodel ( new, gibname);
   setsize ( new, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   new.velocity = VelocityForDamage ( dm);
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_NOT;
   new.avelocity_x = random(600.00000);
   new.avelocity_y = random(600.00000);
   new.avelocity_z = random(600.00000);
   new.think = SUB_Remove;
   new.ltime = time;
   AdvanceThinkTime(new,random(20.00000,10.00000));
   new.scale = random(0.50000,0.90000);
   new.frame = 0.00000;
   new.flags = 0.00000;
};


void  (string gibname,float dm)ThrowHead =  {
local vector org = '0.00000 0.00000 0.00000';
   if ( (self.decap == 2.00000) ) {

      if ( (self.movedir == '0.00000 0.00000 0.00000') ) {

         self.movedir = normalize ( (((self.origin + self.view_ofs) - self.enemy.origin) + self.enemy.proj_ofs));
         self.movedir_z = 0.00000;

      }
      traceline ( (self.origin + self.view_ofs), ((self.origin + self.view_ofs) + (self.movedir * 100.00000)), FALSE, self);
      if ( ((trace_fraction < 1.00000) && !(trace_ent.flags2 & FL_ALIVE)) ) {

         self.wallspot = trace_endpos;
         ZeBrains ( trace_endpos, trace_plane_normal, random(1.30000,2.00000), rint ( random(1.00000)), random(360.00000));
      } else {

         self.wallspot = '0.00000 0.00000 0.00000';

      }

   }
   setmodel ( self, gibname);
   self.frame = 0.00000;
   self.takedamage = DAMAGE_NO;
   if ( (self.classname != "player") ) {

      self.solid = SOLID_BBOX;

   }
   self.movetype = MOVETYPE_BOUNCE;
   self.mass = 1.00000;
   self.view_ofs = '0.00000 0.00000 8.00000';
   self.proj_ofs = '0.00000 0.00000 2.00000';
   self.hull = HULL_POINT;
   org = self.origin;
   org_z = (self.absmax_z - 4.00000);
   setsize ( self, '-4.00000 -4.00000 -4.00000', '4.00000 4.00000 4.00000');
   setorigin ( self, org);
   self.flags ^= FL_ONGROUND;
   self.avelocity = random('0.00000 -600.00000 0.00000','0.00000 600.00000 0.00000');
   if ( (self.decap == 2.00000) ) {

      self.velocity = (VelocityForDamage ( dm) + '0.00000 0.00000 50.00000');
   } else {

      self.velocity = (VelocityForDamage ( dm) + '0.00000 0.00000 200.00000');

   }
   if ( ((self.decap == 2.00000) || ((self.decap == 1.00000) && (vlen ( self.velocity) > 300.00000))) ) {

      if ( (self.wallspot == '0.00000 0.00000 0.00000') ) {

         self.wallspot = org;

      }
      self.pausetime = (time + 5.00000);

   }
   self.think = PlayerDead;
   AdvanceThinkTime(self,1.00000);
};


void  ()PlayerUnCrouching =  {
   tracearea ( self.origin, (self.origin + '0.00000 0.00000 28.00000'), '-16.00000 -16.00000 0.00000', '16.00000 16.00000 28.00000', FALSE, self);
   if ( (trace_fraction < 1.00000) ) {

      centerprint ( self, STR_NOROOM);
      self.crouch_stuck = 1.00000;
      return ;

   }
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
   self.hull = HULL_PLAYER;
   if ( (self.viewentity.classname == "chasecam") ) {

      self.view_ofs = '0.00000 0.00000 0.00000';

   }
   PlayerSpeed_Calc ( );
   self.crouch_time = time;
   if ( (self.velocity_x || self.velocity_y) ) {

      self.act_state = ACT_RUN;
   } else {

      self.act_state = ACT_STAND;

   }
};


void  ()PlayerCrouching =  {
   if ( (self.health <= 0.00000) ) {

      return ;

   }
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 28.00000');
   self.hull = HULL_CROUCH;
   if ( (self.viewentity.classname == "chasecam") ) {

      self.view_ofs = '0.00000 0.00000 0.00000';

   }
   self.absorb_time = (time + 0.30000);
   PlayerSpeed_Calc ( );
   self.crouch_time = time;
   self.crouch_stuck = 0.00000;
   self.act_state = ACT_CROUCH_MOVE;
};


void  ()PlayerCrouch =  {
   if ( (self.hull == HULL_PLAYER) ) {

      PlayerCrouching ( );
   } else {

      if ( (self.hull == HULL_CROUCH) ) {

         PlayerUnCrouching ( );

      }

   }
};


void  ()GibPlayer =  {
   ThrowHead ( self.headmodel, self.health);
   ThrowGib ( "models/flesh1.mdl", self.health);
   ThrowGib ( "models/flesh2.mdl", self.health);
   ThrowGib ( "models/flesh3.mdl", self.health);
   ThrowGib ( "models/flesh1.mdl", self.health);
   ThrowGib ( "models/flesh2.mdl", self.health);
   ThrowGib ( "models/flesh3.mdl", self.health);
   self.deadflag = DEAD_DEAD;
   if ( ((((self.deathtype == "teledeath") || (self.deathtype == "teledeath2")) || (self.deathtype == "teledeath3")) || (self.deathtype == "teledeath4")) ) {

      sound ( self, CHAN_VOICE, "player/telefrag.wav", 1.00000, ATTN_NONE);
      return ;

   }
   if ( (self.health < -80.00000) ) {

      sound ( self, CHAN_VOICE, "player/megagib.wav", 1.00000, ATTN_NONE);
   } else {

      if ( (random() < 0.50000) ) {

         sound ( self, CHAN_VOICE, "player/gib1.wav", 1.00000, ATTN_NONE);
      } else {

         sound ( self, CHAN_VOICE, "player/gib2.wav", 1.00000, ATTN_NONE);

      }

   }
};


void  ()DecapPlayer =  {
local entity headless;
   headless = spawn ( );
   headless.classname = "headless";
   headless.decap = TRUE;
   headless.movetype = MOVETYPE_STEP;
   headless.solid = SOLID_PHASE;
   headless.frame = 50.00000;
   headless.skin = self.skin;
   headless.thingtype = self.thingtype;
   headless.angles_y = self.angles_y;
   setmodel ( headless, self.model);
   setsize ( headless, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 36.00000');
   setorigin ( headless, self.origin);
   headless.playerclass = self.playerclass;
   headless.think = self.th_goredeath;
   AdvanceThinkTime(headless,0.00000);
   self.health = (self.health * 4.00000);
   if ( (self.health > -30.00000) ) {

      self.health = -30.00000;

   }
   if ( (self.decap == 2.00000) ) {

      ThrowHead ( "models/flesh1.mdl", self.health);
      SpawnPuff ( (self.origin + self.view_ofs), '0.00000 0.00000 0.00000', fabs ( self.health), self);
   } else {

      ThrowHead ( self.headmodel, self.health);

   }
   ThrowGib ( "models/flesh1.mdl", self.health);
   ThrowGib ( "models/flesh2.mdl", self.health);
   ThrowGib ( "models/flesh3.mdl", self.health);
   self.deadflag = DEAD_DEAD;
   if ( (random() < 0.50000) ) {

      sound ( self, CHAN_VOICE, "player/decap.wav", 1.00000, ATTN_NORM);
   } else {

      if ( (random() < 0.50000) ) {

         sound ( self, CHAN_VOICE, "player/gib1.wav", 1.00000, ATTN_NONE);
      } else {

         sound ( self, CHAN_VOICE, "player/gib2.wav", 1.00000, ATTN_NONE);

      }

   }
};


void  ()PlayerDie =  {
   if ( (self.viewentity != self) ) {

      if ( (self.viewentity.classname == "chasecam") ) {

         remove ( self.viewentity);

      }
      self.viewentity = self;
      CameraViewPort ( self, self);
      CameraViewAngles ( self, self);

   }
   msg_entity = self;
   WriteByte ( MSG_ONE, SVC_CLEAR_VIEW_FLAGS);
   WriteByte ( MSG_ONE, 255.00000);
   self.colormap = 0.00000;
   self.effects = 0.00000;
   self.invisible_time = 0.00000;
   self.artifact_active = 0.00000;
   self.artifact_low = 0.00000;
   if ( (deathmatch || coop) ) {

      DropBackpack ( );

   }
   if ( (self.model == "models/sheep.mdl") ) {

      self.headmodel = "";

   }
   self.weaponmodel = "";
   self.deadflag = DEAD_DYING;
   self.solid = SOLID_NOT;
   self.flags ^= FL_ONGROUND;
   self.movetype = MOVETYPE_TOSS;
   self.pausetime = time;
   self.teleport_time = time;
   self.attack_finished = time;
   self.effects = FALSE;
   self.drawflags = FALSE;
   if ( (self.velocity_z < 10.00000) ) {

      self.velocity_z += random(300.00000);

   }
   self.artifact_active = 0.00000;
   self.rings_active = 0.00000;
   if ( ((((self.deathtype == "teledeath") || (self.deathtype == "teledeath2")) || (self.deathtype == "teledeath3")) || (self.deathtype == "teledeath4")) ) {

      self.decap = 0.00000;
      self.health = -99.00000;

   }
   if ( ((self.deathtype == "ice shatter") || (self.deathtype == "stone crumble")) ) {

      shatter ( );
      ThrowHead ( self.headmodel, self.health);
      if ( (self.health < -99.00000) ) {

         self.health = -99.00000;

      }
      return ;
   } else {

      if ( self.decap ) {

         DecapPlayer ( );
         if ( (self.health < -99.00000) ) {

            self.health = -99.00000;

         }
         return ;
      } else {

         if ( ((self.health < -40.00000) || (self.model == "models/sheep.mdl")) ) {

            GibPlayer ( );
            if ( (self.health < -99.00000) ) {

               self.health = -99.00000;

            }
            return ;

         }

      }

   }
   DeathSound ( );
   self.angles_x = 0.00000;
   self.angles_z = 0.00000;
   if ( (self.bloodloss == 666.00000) ) {

      DecapPlayer ( );
   } else {

      self.act_state = ACT_DEAD;
      player_frames ( );

   }
   if ( (self.health < -99.00000) ) {

      self.health = -99.00000;

   }
};


void  ()set_suicide_frame =  {
   if ( (self.model != self.init_model) ) {

      return ;

   }
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_TOSS;
   self.deadflag = DEAD_DEAD;
   self.nextthink = -1.00000;
};


void  ()Head =  {
   ThrowSolidHead ( 0.00000);
};


void  ()Corpse =  {
   MakeSolidCorpse ( );
};


void  ()SolidPlayer =  {
local entity corpse;
   corpse = spawn ( );
   if ( ((self.angles_x > 15.00000) || (self.angles_x < -15.00000)) ) {

      self.angles_x = 0.00000;

   }
   if ( ((self.angles_z > 15.00000) || (self.angles_z < -15.00000)) ) {

      self.angles_z = 0.00000;

   }
   corpse.angles = self.angles;
   corpse.model = self.model;
   corpse.frame = self.frame;
   corpse.colormap = self.colormap;
   corpse.movetype = self.movetype;
   corpse.velocity = self.velocity;
   corpse.flags = 0.00000;
   corpse.effects = 0.00000;
   corpse.skin = self.skin;
   corpse.controller = self;
   corpse.thingtype = self.thingtype;
   setorigin ( corpse, self.origin);
   if ( (self.model == self.headmodel) ) {

      self.classname = "head";
      corpse.think = Head;
   } else {

      self.classname = "corpse";
      corpse.think = Corpse;

   }
   AdvanceThinkTime(corpse,0.00000);
};


void  ()player_behead =  {
   self.frame = (self.level + self.cnt);
   makevectors ( self.angles);
   if ( !self.cnt ) {

      MeatChunks ( (self.origin + '0.00000 0.00000 50.00000'), (v_up * 200.00000), 3.00000);
   } else {

      if ( (self.cnt == 1.00000) ) {

         SpawnPuff ( (self.origin + (v_forward * 8.00000)), '0.00000 0.00000 48.00000', 30.00000, self);
         sound ( self, CHAN_AUTO, "misc/decomp.wav", 1.00000, ATTN_NORM);
      } else {

         if ( (self.cnt == 3.00000) ) {

            SpawnPuff ( (self.origin + (v_forward * 16.00000)), ('0.00000 0.00000 36.00000' + (v_forward * 16.00000)), 20.00000, self);
            sound ( self, CHAN_AUTO, "misc/decomp.wav", 1.00000, ATTN_NORM);
         } else {

            if ( (self.cnt == 5.00000) ) {

               SpawnPuff ( (self.origin + (v_forward * 28.00000)), ('0.00000 0.00000 20.00000' + (v_forward * 32.00000)), 15.00000, self);
               sound ( self, CHAN_AUTO, "misc/decomp.wav", 0.80000, ATTN_NORM);
            } else {

               if ( (self.cnt == 8.00000) ) {

                  SpawnPuff ( (self.origin + (v_forward * 40.00000)), ('0.00000 0.00000 10.00000' + (v_forward * 40.00000)), 10.00000, self);
                  sound ( self, CHAN_AUTO, "misc/decomp.wav", 0.60000, ATTN_NORM);

               }

            }

         }

      }

   }
   if ( (self.frame == self.dmg) ) {

      SpawnPuff ( (self.origin + (v_forward * 56.00000)), ('0.00000 0.00000 -5.00000' + (v_forward * 40.00000)), 5.00000, self);
      sound ( self, CHAN_AUTO, "misc/decomp.wav", 0.40000, ATTN_NORM);
      ReadySolid ( );
   } else {

      self.think = player_behead;
      AdvanceThinkTime(self,0.10000);

   }
   self.cnt += 1.00000;
};

