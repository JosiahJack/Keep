.float motd_time;
.float motd_count;

void () MOTD = {

   local string tp;

   if ( (self.motd_count < MOVETYPE_FLY) ) {

      if ( ((teamplay > MOVETYPE_WALK) && (teamplay < MOVETYPE_PUSH)) ) {

         tp = ftos (teamplay);
         stuffcmd (self,"teamplay ");
         stuffcmd (self,tp);
         stuffcmd (self,"\n");

      }
      self.motd_time = (time + TRUE);
      self.motd_count = (self.motd_count + TRUE);
      if ( (teamplay == TEAM_DMATCH_TAG) ) {

         centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nDeathmatch Tag!\n");

      } else {

         if ( (teamplay == TEAM_CTF) ) {

            if ( (self.steam == TEAM1) ) {

               centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n\nYou are ред team!\n");

            } else {

               centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n\nYou are блуе team!\n");

            }

         } else {

            if ( (teamplay == TEAM_CTF_ONEFLAG) ) {

               if ( (self.steam == TEAM1) ) {

                  centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(One Flag Mode)\n\nYou are ред team!\n");

               } else {

                  centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(One Flag Mode)\n\nYou are блуе team!\n");

               }

            } else {

               if ( (teamplay == TEAM_CTF_ALT) ) {

                  if ( (self.steam == TEAM1) ) {

                     centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(Three Team Mode)\n\nYou are ред team!\n");

                  } else {

                     if ( (self.steam == TEAM2) ) {

                        centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(Three Team Mode)\n\nYou are блуе team!\n");

                     } else {

                        centerprint (self,"Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(Three Team Mode)\n\nYou are греы team!\n");

                     }

                  }

               }

            }

         }

      }
      return ;

   }
   self.motd_time = FALSE;

};

void () CheckMOTD = {

   if ( self.motd_time ) {

      if ( (self.motd_time < time) ) {

         MOTD ();

      }

   }

};

void () SetMOTD = {

   self.motd_time = (time + MOVETYPE_WALK);
   if ( (teamplay == MOVETYPE_WALK) ) {

      self.motd_count = FL_SWIM;

   } else {

      self.motd_count = FALSE;

   }

};
