
void  ()sound_maker_run =  {
   sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
};


void  ()sound_maker_wait =  {
   self.think = sound_maker_run;
   AdvanceThinkTime(self,self.delay);
};


void  ()sound_maker =  {
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "misc/bellring.wav");
      self.noise1 = "misc/bellring.wav";
   } else {

      if ( (self.soundtype == 2.00000) ) {

         precache_sound2 ( "misc/organ.wav");
         self.noise1 = "misc/organ.wav";
      } else {

         if ( (self.soundtype == 3.00000) ) {

            precache_sound ( "misc/tomb.wav");
            self.noise1 = "misc/tomb.wav";

         }

      }

   }
   if ( self.delay ) {

      self.use = sound_maker_wait;
   } else {

      self.use = sound_maker_run;

   }
};


void  ()sound_again =  {
local float chance = 0.00000;
   if ( (self.soundtype == 13.00000) ) {

      chance = random();
      if ( (chance < 0.33000) ) {

         sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
      } else {

         if ( (chance < 0.66000) ) {

            sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, self.noise3, 1.00000, ATTN_NORM);

         }

      }
   } else {

      if ( (((self.soundtype == 11.00000) || (self.soundtype == 12.00000)) || (self.soundtype == 14.00000)) ) {

         if ( (random() < 0.50000) ) {

            sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_VOICE, self.noise2, 1.00000, ATTN_NORM);

         }
      } else {

         sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);

      }

   }
   self.think = sound_again;
   self.nextthink = (time + random(5.00000,30.00000));
};


void  ()sound_ambient =  {
   if ( (self.soundtype == 1.00000) ) {

      precache_sound ( "ambience/windmill.wav");
      self.noise1 = "ambience/windmill.wav";
   } else {

      if ( (self.soundtype == 2.00000) ) {

         precache_sound ( "ambience/drip1.wav");
         self.noise1 = "ambience/drip1.wav";
         self.think = sound_again;
         AdvanceThinkTime(self,random(5.00000,30.00000));
      } else {

         if ( (self.soundtype == 3.00000) ) {

            precache_sound ( "ambience/drip2.wav");
            self.noise1 = "ambience/drip2.wav";
            self.think = sound_again;
            AdvanceThinkTime(self,random(5.00000,30.00000));
         } else {

            if ( (self.soundtype == 4.00000) ) {

               precache_sound ( "ambience/wind.wav");
               self.noise1 = "ambience/wind.wav";
            } else {

               if ( (self.soundtype == 5.00000) ) {

                  precache_sound ( "ambience/night.wav");
                  self.noise1 = "ambience/night.wav";
                  self.think = sound_again;
                  AdvanceThinkTime(self,random(5.00000,30.00000));
               } else {

                  if ( (self.soundtype == 6.00000) ) {

                     precache_sound ( "ambience/birds.wav");
                     self.noise1 = "ambience/birds.wav";
                     self.think = sound_again;
                     AdvanceThinkTime(self,random(15.00000,60.00000));
                  } else {

                     if ( (self.soundtype == 7.00000) ) {

                        precache_sound ( "ambience/raven.wav");
                        self.noise1 = "ambience/raven.wav";
                        self.think = sound_again;
                        AdvanceThinkTime(self,random(15.00000,60.00000));
                     } else {

                        if ( (self.soundtype == 8.00000) ) {

                           precache_sound ( "ambience/rockfall.wav");
                           self.noise1 = "ambience/rockfall.wav";
                           self.think = sound_again;
                           AdvanceThinkTime(self,random(15.00000,60.00000));
                        } else {

                           if ( (self.soundtype == 9.00000) ) {

                              precache_sound ( "ambience/lava.wav");
                              self.noise1 = "ambience/lava.wav";
                           } else {

                              if ( (self.soundtype == 10.00000) ) {

                                 precache_sound ( "ambience/water.wav");
                                 self.noise1 = "ambience/water.wav";
                              } else {

                                 if ( (self.soundtype == 11.00000) ) {

                                    precache_sound ( "ambience/metal.wav");
                                    self.noise1 = "ambience/metal.wav";
                                    precache_sound ( "ambience/metal2.wav");
                                    self.noise2 = "ambience/metal2.wav";
                                    AdvanceThinkTime(self,random(5.00000,30.00000));
                                 } else {

                                    if ( (self.soundtype == 12.00000) ) {

                                       precache_sound ( "ambience/pounding.wav");
                                       self.noise1 = "ambience/pounding.wav";
                                       precache_sound ( "ambience/poundin2.wav");
                                       self.noise2 = "ambience/poundin2.wav";
                                       AdvanceThinkTime(self,random(5.00000,30.00000));
                                    } else {

                                       if ( (self.soundtype == 13.00000) ) {

                                          precache_sound ( "ambience/moan1.wav");
                                          self.noise1 = "ambience/moan1.wav";
                                          precache_sound ( "ambience/moan2.wav");
                                          self.noise2 = "ambience/moan2.wav";
                                          precache_sound ( "ambience/moan3.wav");
                                          self.noise3 = "ambience/moan3.wav";
                                          AdvanceThinkTime(self,random(5.00000,30.00000));
                                       } else {

                                          if ( (self.soundtype == 14.00000) ) {

                                             precache_sound ( "ambience/creak.wav");
                                             self.noise1 = "ambience/creak.wav";
                                             precache_sound ( "ambience/creak2.wav");
                                             self.noise2 = "ambience/creak2.wav";
                                             AdvanceThinkTime(self,random(5.00000,30.00000));
                                          } else {

                                             if ( (self.soundtype == 15.00000) ) {

                                                precache_sound ( "ambience/rattle.wav");
                                                self.noise1 = "ambience/rattle.wav";
                                                AdvanceThinkTime(self,random(5.00000,30.00000));

                                             }

                                          }

                                       }

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( !self.think ) {

      ambientsound ( self.origin, self.noise1, 1.00000, ATTN_STATIC);
   } else {

      sound ( self, CHAN_VOICE, self.noise1, 1.00000, ATTN_NORM);

   }
};

