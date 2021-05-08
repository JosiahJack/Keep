
void  ()SetModelAndThinks =  {
   self.touch = PlayerTouch;
   self.th_die = PlayerDie;
   self.th_goredeath = player_frames_behead;
   self.th_pain = player_pain;
   if ( (self.playerclass == CLASS_ASSASSIN) ) {

      self.mass = 6.00000;
      Ass_Change_Weapon ( );
      setmodel ( self, "models/assassin.mdl");
      self.headmodel = "models/h_ass.mdl";
      if ( (self.weapon == IT_WEAPON4) ) {

         self.th_weapon = setstaff_select;
      } else {

         if ( (self.weapon == IT_WEAPON2) ) {

            self.th_weapon = crossbow_select;
         } else {

            if ( (self.weapon == IT_WEAPON3) ) {

               self.th_weapon = grenade_select;
            } else {

               self.th_weapon = punchdagger_select;

            }

         }

      }
   } else {

      if ( (self.playerclass == CLASS_CRUSADER) ) {

         self.mass = 7.00000;
         setmodel ( self, "models/crusader.mdl");
         self.headmodel = "models/h_cru.mdl";
         Cru_Change_Weapon ( );
         if ( (self.weapon == IT_WEAPON4) ) {

            self.th_weapon = sunstaff_select;
         } else {

            if ( (self.weapon == IT_WEAPON3) ) {

               self.th_weapon = meteor_select;
            } else {

               if ( (self.weapon == IT_WEAPON2) ) {

                  self.th_weapon = icestaff_select;
               } else {

                  self.th_weapon = warhammer_select;

               }

            }

         }
      } else {

         if ( (self.playerclass == CLASS_PALADIN) ) {

            self.mass = 8.00000;
            Pal_Change_Weapon ( );
            setmodel ( self, "models/paladin.mdl");
            self.headmodel = "models/h_pal.mdl";
            if ( (self.weapon == IT_WEAPON4) ) {

               self.th_weapon = purifier_select;
            } else {

               if ( (self.weapon == IT_WEAPON3) ) {

                  self.th_weapon = axe_select;
               } else {

                  if ( (self.weapon == IT_WEAPON2) ) {

                     self.th_weapon = vorpal_select;
                  } else {

                     self.th_weapon = gauntlet_select;

                  }

               }

            }
         } else {

            if ( (self.playerclass == CLASS_NECROMANCER) ) {

               self.mass = 7.00000;
               setmodel ( self, "models/necro.mdl");
               self.headmodel = "models/h_nec.mdl";
               Nec_Change_Weapon ( );
               if ( (self.weapon == IT_WEAPON4) ) {

                  self.th_weapon = ravenstaff_select;
               } else {

                  if ( (self.weapon == IT_WEAPON1) ) {

                     self.th_weapon = sickle_select;
                  } else {

                     if ( (self.weapon == IT_WEAPON2) ) {

                        self.th_weapon = magicmis_select;
                     } else {

                        self.th_weapon = boneshard_select;

                     }

                  }

               }

            }

         }

      }

   }
   self.init_model = self.model;
   setsize ( self, '-16.00000 -16.00000 0.00000', '16.00000 16.00000 56.00000');
};

