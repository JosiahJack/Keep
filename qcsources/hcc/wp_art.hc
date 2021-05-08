
void  ()wp_weapon2 =  {
   precache_model ( "models/w_l2_c1.mdl");
   precache_model2 ( "models/w_l2_c2.mdl");
   precache_model2 ( "models/w_l2_c3.mdl");
   precache_model ( "models/w_l2_c4.mdl");
   CreateEntityNew ( self, ENT_WEAPON2_ART, "models/w_l2_c1.mdl", SUB_Null);
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.hull = HULL_POINT;
   self.flags |= FL_CLASS_DEPENDENT;
   self.touch = weapon_touch;
   self.items = IT_WEAPON2;
   StartItem ( );
};


void  ()wp_weapon3 =  {
   precache_model ( "models/w_l3_c1.mdl");
   precache_model2 ( "models/w_l3_c2.mdl");
   precache_model2 ( "models/w_l3_c3.mdl");
   precache_model ( "models/w_l3_c4.mdl");
   CreateEntityNew ( self, ENT_WEAPON41_ART, "models/w_l3_c1.mdl", SUB_Null);
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.hull = HULL_POINT;
   self.flags |= FL_CLASS_DEPENDENT;
   self.touch = weapon_touch;
   self.items = IT_WEAPON3;
   StartItem ( );
};


void  ()wp_weapon4_head =  {
   precache_model ( "models/w_l41_c1.mdl");
   precache_model2 ( "models/w_l41_c2.mdl");
   precache_model2 ( "models/w_l41_c3.mdl");
   precache_model ( "models/w_l41_c4.mdl");
   CreateEntityNew ( self, ENT_WEAPON41_ART, "models/w_l41_c1.mdl", SUB_Null);
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.hull = HULL_POINT;
   self.flags |= FL_CLASS_DEPENDENT;
   self.touch = weapon_touch;
   self.items = IT_WEAPON4_1;
   StartItem ( );
};


void  ()wp_weapon4_staff =  {
   precache_model ( "models/w_l42_c1.mdl");
   precache_model2 ( "models/w_l42_c2.mdl");
   precache_model2 ( "models/w_l42_c3.mdl");
   precache_model ( "models/w_l42_c4.mdl");
   CreateEntityNew ( self, ENT_WEAPON42_ART, "models/w_l42_c1.mdl", SUB_Null);
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   self.hull = HULL_POINT;
   self.flags |= FL_CLASS_DEPENDENT;
   self.touch = weapon_touch;
   self.items = IT_WEAPON4_2;
   StartItem ( );
};

