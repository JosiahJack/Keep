float WHITE_PUFF   =  0.00000;
float RED_PUFF   =  1.00000;
float GREEN_PUFF   =  2.00000;
float GREY_PUFF   =  3.00000;

void  (vector org,vector vel,float framelength)CreateWhiteSmoke =  {
   starteffect ( CE_WHITE_SMOKE, org, vel, framelength);
};


void  (vector org,vector vel,float framelength)CreateRedSmoke =  {
   starteffect ( CE_RED_SMOKE, org, vel, framelength);
};


void  (vector org,vector vel,float framelength)CreateGreySmoke =  {
   starteffect ( CE_GREY_SMOKE, org, vel, framelength);
};


void  (vector org,vector vel,float framelength)CreateGreenSmoke =  {
   starteffect ( CE_GREEN_SMOKE, org, vel, framelength);
};


void  (vector org,vector vel,float framelength)CreateRedCloud =  {
   starteffect ( CE_REDCLOUD, org, vel, framelength);
};


void  (vector spot)CreateLittleWhiteFlash =  {
   starteffect ( CE_SM_WHITE_FLASH, spot);
};


void  (vector spot)CreateLittleBlueFlash =  {
   starteffect ( CE_SM_BLUE_FLASH, spot);
};


void  (vector spot)CreateBlueFlash =  {
   starteffect ( CE_BLUE_FLASH, spot);
};


void  (vector spot)CreateWhiteFlash =  {
   starteffect ( CE_WHITE_FLASH, spot);
};


void  (vector spot)CreateYRFlash =  {
   starteffect ( CE_YELLOWRED_FLASH, spot);
};


void  (vector spot)CreateBlueExplosion =  {
   starteffect ( CE_BLUE_EXPLOSION, spot);
};


void  (vector spot)CreateExplosion29 =  {
   starteffect ( CE_BG_CIRCLE_EXP, spot);
};


void  (vector spot)CreateFireCircle =  {
   starteffect ( CE_SM_CIRCLE_EXP, spot);
};


void  (vector spot)CreateRedSpark =  {
   starteffect ( CE_REDSPARK, spot);
};


void  (vector spot)CreateGreenSpark =  {
   starteffect ( CE_GREENSPARK, spot);
};


void  (vector spot)CreateBSpark =  {
   starteffect ( CE_BLUESPARK, spot);
};


void  (vector spot)CreateSpark =  {
   starteffect ( CE_YELLOWSPARK, spot);
};


void  ()splash_run =  {
local float result = 0.00000;
   result = AdvanceFrame ( 0.00000, 5.00000);
   self.nextthink = (time + HX_FRAME_TIME);
   self.think = splash_run;
   if ( (result == AF_END) ) {

      self.nextthink = (time + HX_FRAME_TIME);
      self.think = SUB_Remove;

   }
};


void  (vector spot)CreateWaterSplash =  {
local entity newent;
   newent = spawn ( );
   setmodel ( newent, "models/wsplash.spr");
   setorigin ( newent, spot);
   newent.movetype = MOVETYPE_NOCLIP;
   newent.solid = SOLID_NOT;
   newent.velocity = '0.00000 0.00000 0.00000';
   newent.nextthink = (time + 0.05000);
   newent.think = splash_run;
};


void  (vector org,vector vel,float damage,entity victim)SpawnPuff =  {
local float part_color = 0.00000;
local float rad = 0.00000;
   if ( (((victim.thingtype == THINGTYPE_FLESH) && (victim.classname != "mummy")) && (victim.netname != "spider")) ) {

      part_color = ((256.00000 + (8.00000 * 16.00000)) + random(9.00000));
   } else {

      if ( ((victim.thingtype == THINGTYPE_GREYSTONE) || (victim.thingtype == THINGTYPE_BROWNSTONE)) ) {

         part_color = ((256.00000 + 20.00000) + random(8.00000));
      } else {

         if ( (victim.thingtype == THINGTYPE_METAL) ) {

            part_color = (256.00000 + (8.00000 * 15.00000));
         } else {

            if ( (victim.thingtype == THINGTYPE_WOOD) ) {

               part_color = ((256.00000 + (5.00000 * 16.00000)) + random(8.00000));
            } else {

               if ( (victim.thingtype == THINGTYPE_ICE) ) {

                  part_color = (406.00000 + random(8.00000));
               } else {

                  if ( (victim.netname == "spider") ) {

                     part_color = ((256.00000 + 183.00000) + random(8.00000));
                  } else {

                     part_color = ((256.00000 + (3.00000 * 16.00000)) + 4.00000);

                  }

               }

            }

         }

      }

   }
   rad = vlen ( vel);
   if ( !rad ) {

      rad = random(10.00000,20.00000);

   }
   particle4 ( org, rad, part_color, PARTICLETYPE_FASTGRAV, (2.00000 * damage));
};


void  (vector spot)CreateRedFlash =  {
   starteffect ( CE_RED_FLASH, spot);
};

void  ()DeathBubblesSpawn;

void  ()flash_remove =  {
   remove ( self);
};


void  (float dir,float top)CreateTeleportPuff =  {
local vector holdvelocity = '0.00000 0.00000 0.00000';
local vector holdangle = '0.00000 0.00000 0.00000';
local vector holdorigin = '0.00000 0.00000 0.00000';
   if ( top ) {

      holdorigin = ((self.origin + '0.00000 0.00000 64.00000') + (v_forward * 24.00000));
   } else {

      holdorigin = ((self.origin + '0.00000 0.00000 12.00000') + (v_forward * 24.00000));

   }
   holdangle_x = 0.00000;
   holdangle_y = dir;
   holdangle_z = 0.00000;
   makevectors ( holdangle);
   holdvelocity = normalize ( v_forward);
   holdvelocity = (holdvelocity * 25.00000);
   if ( (random() < 0.50000) ) {

      starteffect ( CE_TELESMK1, holdorigin, holdvelocity, (HX_FRAME_TIME * 3.00000));
   } else {

      starteffect ( CE_TELESMK2, holdorigin, holdvelocity, (HX_FRAME_TIME * 3.00000));

   }
};


void  (float top)TeleportTop =  {
local float i = 0.00000;
local float dir = 0.00000;
   i = 8.00000;
   dir = random(0.00000,45.00000);
   while ( (i > 0.00000) ) {

      CreateTeleportPuff ( dir, top);
      dir += 45.00000;
      i -= 1.00000;

   }
};


void  ()TeleportShrink =  {
   self.nextthink = (time + HX_FRAME_TIME);
   self.think = TeleportShrink;
   self.scale -= 0.10000;
   self.avelocity_y -= 100.00000;
   if ( (self.scale < 0.11000) ) {

      particle4 ( (self.origin + '0.00000 0.00000 40.00000'), random(20.00000,30.00000), 20.00000, PARTICLETYPE_FASTGRAV, random(20.00000,30.00000));
      particle4 ( (self.origin + '0.00000 0.00000 40.00000'), random(20.00000,30.00000), 250.00000, PARTICLETYPE_FASTGRAV, random(20.00000,30.00000));
      remove ( self);

   }
};


void  (entity center)GenerateTeleportSound =  {
local string telesnd;
local float r = 0.00000;
   r = (rint ( random(4.00000)) + 1.00000);
   if ( (r == 1.00000) ) {

      telesnd = "misc/teleprt1.wav";
   } else {

      if ( (r == 2.00000) ) {

         telesnd = "misc/teleprt2.wav";
      } else {

         if ( (r == 3.00000) ) {

            telesnd = "misc/teleprt3.wav";
         } else {

            if ( (r == 4.00000) ) {

               telesnd = "misc/teleprt4.wav";
            } else {

               telesnd = "misc/teleprt5.wav";

            }

         }

      }

   }
   sound ( center, CHAN_AUTO, telesnd, 1.00000, ATTN_NORM);
};


void  (vector spot1,float teleskin)GenerateTeleportEffect =  {
local entity newent;
local entity holdent;
   if ( (self.attack_finished > time) ) {

      return ;

   }
   newent = spawn_temp ( );
   CreateEntityNew ( newent, ENT_TELEPORT, "models/teleport.mdl", chunk_death);
   setorigin ( newent, spot1);
   newent.drawflags |= (SCALE_TYPE_XYONLY | DRF_TRANSLUCENT);
   newent.movetype = MOVETYPE_FLYMISSILE;
   newent.avelocity_y = 2000.00000;
   newent.scale = 1.00000;
   newent.skin = teleskin;
   GenerateTeleportSound ( newent);
   holdent = self;
   self = newent;
   TeleportTop ( 0.00000);
   TeleportTop ( 1.00000);
   self = holdent;
   newent.nextthink = (time + 0.25000);
   newent.think = TeleportShrink;
};


void  ()smoke_generator_use =  {
   self.use = smoke_generator_use;
   self.nextthink = (time + HX_FRAME_TIME);
   if ( !self.wait ) {

      self.wait = 2.00000;

   }
   self.owner = other;
   if ( self.lifespan ) {

      self.lifetime = (time + self.lifespan);

   }
};


void  ()smoke_generator_run =  {
   if ( (self.thingtype == WHITE_PUFF) ) {

      CreateWhiteSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));
   } else {

      if ( (self.thingtype == RED_PUFF) ) {

         CreateRedSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));
      } else {

         if ( (self.thingtype == GREEN_PUFF) ) {

            CreateRedSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));
         } else {

            if ( (self.thingtype == GREY_PUFF) ) {

               CreateGreySmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 3.00000));

            }

         }

      }

   }
   self.nextthink = (time + random(self.wait));
   self.think = smoke_generator_run;
   if ( (self.lifespan && (self.lifetime < time)) ) {

      remove ( self);

   }
};


void  ()fx_smoke_generator =  {
   setmodel ( self, "models/null.spr");
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.th_die = SUB_Remove;
   if ( !self.targetname ) {

      self.nextthink = (time + HX_FRAME_TIME);

   }
   self.use = smoke_generator_use;
   if ( !self.wait ) {

      self.wait = 2.00000;

   }
   self.think = smoke_generator_run;
};


void  (vector org)fx_flash =  {
local entity newent;
   newent = spawn ( );
   setmodel ( newent, "models/s_bubble.spr");
   setorigin ( newent, (org + '0.00000 0.00000 24.00000'));
   newent.movetype = MOVETYPE_NOCLIP;
   newent.solid = SOLID_NOT;
   newent.velocity = '0.00000 0.00000 0.00000';
   newent.nextthink = (time + 0.50000);
   newent.think = flash_remove;
   newent.classname = "bubble";
   newent.effects = EF_BRIGHTLIGHT;
   setsize ( newent, '-8.00000 -8.00000 -8.00000', '8.00000 8.00000 8.00000');
};


void  ()explosion_done =  {
   self.effects = EF_DIMLIGHT;
};


void  ()explosion_use =  {
   sound ( self, CHAN_BODY, self.noise1, 1.00000, ATTN_NORM);
   particleexplosion ( self.origin, self.color, self.exploderadius, self.counter);
};

