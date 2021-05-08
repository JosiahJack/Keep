
void  ()CheckAbilities =  {
local float trans_limit = 0.00000;
   if ( (self.model == "models/assassin.mdl") ) {

      if ( (self.level < 3.00000) ) {

         return ;

      }
      trans_limit = (10.00000 - self.level);
      if ( (trans_limit < 1.00000) ) {

         trans_limit = 1.00000;

      }
      if ( (((self.velocity == '0.00000 0.00000 0.00000') && (self.last_attack < (time - 2.00000))) && (self.light_level < 100.00000)) ) {

         if ( (self.still_time == -1.00000) ) {

            self.still_time = ((time + 10.00000) - self.level);

         }
         if ( (self.still_time < time) ) {

            msg_entity = self;
            WriteByte ( MSG_ONE, SVC_SET_VIEW_FLAGS);
            WriteByte ( MSG_ONE, DRF_TRANSLUCENT);
            if ( !self.abslight ) {

               self.abslight = (self.light_level / 102.00000);
            } else {

               if ( (self.abslight > (0.00500 * (8.00000 - trans_limit))) ) {

                  self.abslight -= (0.00500 * (8.00000 - trans_limit));

               }

            }
            self.drawflags |= (DRF_TRANSLUCENT | MLS_ABSLIGHT);

         }
      } else {

         if ( ((self.drawflags & DRF_TRANSLUCENT) | MLS_ABSLIGHT) ) {

            self.still_time = -1.00000;
            if ( (self.abslight < 1.00000) ) {

               self.abslight += (0.01000 * trans_limit);
            } else {

               self.drawflags ^= (MLS_ABSLIGHT | DRF_TRANSLUCENT);
               self.abslight = 0.00000;
               msg_entity = self;
               WriteByte ( MSG_ONE, SVC_CLEAR_VIEW_FLAGS);
               WriteByte ( MSG_ONE, DRF_TRANSLUCENT);

            }

         }

      }

   }
};

