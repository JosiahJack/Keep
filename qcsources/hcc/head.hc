void  (string gibname,float dm)ThrowGib;
vector  (float dm)VelocityForDamage;
void  ()CorpseThink;

void  ()HeadThink =  {
   if ( (((self.lifetime < time) && !deathmatch) || (self.watertype == CONTENT_LAVA)) ) {

      self.th_die ( );
   } else {

      self.think = HeadThink;
      AdvanceThinkTime(self,0.50000);

   }
};


void  (float dm)ThrowSolidHead =  {
   setmodel ( self, self.headmodel);
   if ( ((((self.headmodel == "") || (self.headmodel == "models/flesh1.mdl")) || (self.headmodel == "models/flesh2.mdl")) || (self.headmodel == "models/flesh3.mdl")) ) {

      remove ( self);
      return ;

   }
   self.headmodel = "";
   self.frame = 0.00000;
   self.movetype = MOVETYPE_STEP;
   self.takedamage = DAMAGE_YES;
   self.solid = SOLID_PHASE;
   setsize ( self, '-3.00000 -3.00000 -3.00000', '3.00000 3.00000 3.00000');
   self.hull = HULL_POINT;
   if ( (dm != -666.00000) ) {

      if ( (dm < 40.00000) ) {

         dm = 40.00000;

      }
      self.velocity = VelocityForDamage ( dm);

   }
   setorigin ( self, (self.origin + '0.00000 0.00000 20.00000'));
   self.flags ^= FL_ONGROUND;
   self.health = 5.00000;
   self.th_die = chunk_death;
   self.flags ^= FL_MONSTER;
   self.angles = RandomVector ( '300.00000 300.00000 300.00000');
   self.classname = "head";
   self.controller = self;
   self.onfire = FALSE;
   self.lifetime = (time + random(10.00000,20.00000));
   if ( ((!deathmatch && !coop) && !teamplay) ) {

      self.think = CorpseThink;
      AdvanceThinkTime(self,0.50000);
   } else {

      self.think = SUB_Null;
      self.nextthink = -1.00000;

   }
};

