float impactVelocity /* = 0.000 */;
float PEND_X    = 1.000;
float PEND_Y    = 2.000;
float PEND_SILENT    = 4.000;
float PEND_TRG    = 8.000;

void () pend_swing1 = [ 0.000, pend_swing2 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -176.000 48.000','8.000 -120.000 128.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-176.000 -8.000 48.000','-120.000 8.000 128.000');

      }

   }
   self.nextthink = (time + 0.170);
   impactVelocity = TRUE;

};

void () pend_swing2 = [ 1.000, pend_swing3 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -172.000 12.000','8.000 -112.000 88.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-172.000 -8.000 12.000','-112.000 8.000 88.000');

      }

   }
   self.nextthink = (time + 0.150);

};

void () pend_swing3 = [ 2.000, pend_swing4 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -160.000 -22.000','8.000 -96.000 50.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-160.000 -8.000 -22.000','-96.000 8.000 50.000');

      }

   }
   self.nextthink = (time + 0.130);

};

void () pend_swing4 = [ 3.000, pend_swing5 ] {

   if ( !(self.spawnflags & PEND_SILENT) ) {

     sound (self,CHAN_AUTO,"pendulum/swing.wav",0.500,ATTN_NORM);

   }
   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -138.000 -51.000','8.000 -70.000 17.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-138.000 -8.000 -51.000','-70.000 8.000 17.000');

      }

   }
   self.nextthink = (time + 0.110);

};

void () pend_swing5 = [ 4.000, pend_swing6 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -110.000 -72.000','8.000 -38.000 -8.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-110.000 -8.000 -72.000','-38.000 8.000 -8.000');

      }

   }
   self.nextthink = (time + 0.090);

};

void () pend_swing6 = [ 5.000, pend_swing7 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -76.000 -83.000','8.000 0.000 -23.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-76.000 -8.000 -83.000','0.000 8.000 -23.000');

      }

   }
   self.nextthink = (time + 0.070);

};

void () pend_swing7 = [ 6.000, pend_swing8 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -40.000 -88.000','8.000 40.000 -32.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-40.000 -8.000 -88.000','40.000 8.000 -32.000');

      }

   }
   self.nextthink = (time + 0.050);

};

void () pend_swing8 = [ 7.000, pend_swing9 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 0.000 -83.000','8.000 76.000 -23.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'0.000 -8.000 -83.000','76.000 8.000 -23.000');

      }

   }
   self.nextthink = (time + 0.070);

};

void () pend_swing9 = [ 8.000, pend_swing10 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 38.000 -72.000','8.000 100.000 -8.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'38.000 -8.000 -72.000','100.000 8.000 -8.000');

      }

   }
   self.nextthink = (time + 0.090);

};

void () pend_swing10 = [ 9.000, pend_swing11 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 70.000 -51.000','8.000 138.000 17.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'70.000 -8.000 -51.000','138.000 8.000 17.000');

      }

   }
   self.nextthink = (time + 0.110);

};

void () pend_swing11 = [ 10.000, pend_swing12 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 96.000 -22.000','8.000 160.000 50.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'96.000 -8.000 -22.000','160.000 8.000 50.000');

      }

   }
   self.nextthink = (time + 0.130);

};

void () pend_swing12 = [ 11.000, pend_swing13 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 112.000 12.000','8.000 172.000 88.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'112.000 -8.000 12.000','172.000 8.000 88.000');

      }

   }
   self.nextthink = (time + 0.150);

};

void () pend_swing13 = [ 12.000, pend_swing14 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 120.000 48.000','8.000 176.000 128.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'120.000 -8.000 48.000','176.000 8.000 128.000');

      }

   }
   self.nextthink = (time + 0.170);

};

void () pend_swing14 = [ 12.000, pend_swing15 ] {

   self.nextthink = (time + 0.170);

};

void () pend_swing15 = [ 11.000, pend_swing16 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 112.000 12.000','8.000 172.000 88.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'112.000 -8.000 12.000','172.000 8.000 88.000');

      }

   }
   self.nextthink = (time + 0.150);
   impactVelocity = CONTENT_EMPTY;

};

void () pend_swing16 = [ 10.000, pend_swing17 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 96.000 -22.000','8.000 160.000 50.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'96.000 -8.000 -22.000','160.000 8.000 50.000');

      }

   }
   self.nextthink = (time + 0.130);

};

void () pend_swing17 = [ 9.000, pend_swing18 ] {

   if ( !(self.spawnflags & PEND_SILENT) ) {

     sound (self,CHAN_AUTO,"pendulum/swing.wav",0.500,ATTN_NORM);

   }
   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 70.000 -51.000','8.000 138.000 17.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'70.000 -8.000 -51.000','138.000 8.000 17.000');

      }

   }
   self.nextthink = (time + 0.110);

};

void () pend_swing18 = [ 8.000, pend_swing19 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 38.000 -72.000','8.000 100.000 -8.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'38.000 -8.000 -72.000','100.000 8.000 -8.000');

      }

   }
   self.nextthink = (time + 0.090);

};

void () pend_swing19 = [ 7.000, pend_swing20 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 0.000 -83.000','8.000 76.000 -23.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'0.000 -8.000 -83.000','76.000 8.000 -23.000');

      }

   }
   self.nextthink = (time + 0.070);

};

void () pend_swing20 = [ 6.000, pend_swing21 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -40.000 -88.000','8.000 40.000 -32.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-40.000 -8.000 -88.000','40.000 8.000 -32.000');

      }

   }
   self.nextthink = (time + 0.050);

};

void () pend_swing21 = [ 5.000, pend_swing22 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -76.000 -83.000','8.000 0.000 -23.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-76.000 -8.000 -83.000','0.000 8.000 -23.000');

      }

   }
   self.nextthink = (time + 0.070);

};

void () pend_swing22 = [ 4.000, pend_swing23 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -110.000 -72.000','8.000 -28.000 -8.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-110.000 -8.000 -72.000','-28.000 8.000 -8.000');

      }

   }
   self.nextthink = (time + 0.090);

};

void () pend_swing23 = [ 3.000, pend_swing24 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -172.000 -51.000','8.000 -70.000 17.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-172.000 -8.000 -51.000','-70.000 8.000 17.000');

      }

   }
   self.nextthink = (time + 0.110);

};

void () pend_swing24 = [ 2.000, pend_swing25 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -160.000 -22.000','8.000 -96.000 50.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-160.000 -8.000 -22.000','-96.000 8.000 50.000');

      }

   }
   self.nextthink = (time + 0.130);

};

void () pend_swing25 = [ 1.000, pend_swing26 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -172.000 12.000','8.000 -112.000 88.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-172.000 -8.000 12.000','-112.000 8.000 88.000');

      }

   }
   self.nextthink = (time + 0.150);

};

void () pend_swing26 = [ 0.000, pend_swing1 ] {

   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -176.000 48.000','8.000 -120.000 128.000');

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-176.000 -8.000 48.000','-120.000 8.000 128.000');

      }

   }
   self.nextthink = (time + 0.170);

};

void () pend_touch = {

   if ( ((other.health < TRUE) || (other.takedamage == DAMAGE_NO)) ) {

      return ;

   }
   if ( (self.attack_finished < time) ) {

      sound (self,CHAN_VOICE,"pendulum/hit.wav",TRUE,ATTN_NORM);
      T_Damage (other,self,self,self.currentammo);
      self.attack_finished = (time + TRUE);

   }
   if ( (self.spawnflags & PEND_Y) ) {

      other.velocity_y = (impactVelocity * -250.000);

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         other.velocity_x = (impactVelocity * 250.000);

      }

   }
   other.velocity_z = 200.000;
   SpawnMeatSpray (other.origin,other.velocity);

};

void () pend_use = {

   self.nextthink = (time + self.delay);
   self.think = pend_swing1;

};

void () pendulum = {

   precache_model ("progs/pendulum.mdl");
   precache_sound ("pendulum/swing.wav");
   precache_sound ("pendulum/hit.wav");
   setmodel (self,"progs/pendulum.mdl");
   if ( !self.spawnflags ) {

      self.spawnflags = (self.spawnflags + PEND_Y);

   }
   if ( (self.spawnflags & PEND_Y) ) {

      setsize (self,'-8.000 -24.000 -100.000','8.000 24.000 100.000');
      self.angles = VEC_ORIGIN;
      self.v_angle = VEC_ORIGIN;

   } else {

      if ( (self.spawnflags & PEND_X) ) {

         setsize (self,'-24.000 -8.000 -100.000','24.000 8.000 100.000');
         self.angles = '0.000 270.000 0.000';
         self.v_angle = '0.000 270.000 0.000';

      } else {

         error ("ERROR: Unimplemented Pendulum Type (pendulum.qc)");

      }

   }
   if ( !self.currentammo ) {

      self.currentammo = MOVETYPE_FLY;

   }
   if ( !self.delay ) {

      self.delay = TRUE;

   }
   impactVelocity = FALSE;
   self.solid = SOLID_TRIGGER;
   self.takedamage = DAMAGE_NO;
   self.touch = pend_touch;
   if ( (self.spawnflags & PEND_TRG) ) {

      self.use = pend_use;
      if ( (self.spawnflags & PEND_Y) ) {

         setsize (self,'-8.000 -176.000 48.000','8.000 -120.000 128.000');
  
      } else {

         if ( (self.spawnflags & PEND_X) ) {

            setsize (self,'-176.000 -8.000 48.000','-120.000 8.000 128.000');

         }

      }

   } else {

      self.nextthink = (time + self.delay);
      self.think = pend_swing1;

   }

};
