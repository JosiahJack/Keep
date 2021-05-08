
void  ()faBladeTouch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   damg = random(8.00000,16.00000);
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   sound ( self, CHAN_WEAPON, "weapons/expsmall.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   CreateGreenSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 4.00000));
   remove ( self);
};


void  ()frame_BLADE =  [  0.0, frame_BLADE] {
};


void  (vector offset,float set_speed,vector dest_offset)do_faBlade =  {
local entity missile;
local vector vec = '0.00000 0.00000 0.00000';
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.flags = FL_FLY;
   missile.health = 10.00000;
   missile.drawflags = MLS_ABSLIGHT;
   missile.abslight = 0.50000;
   setmodel ( missile, "models/fablade.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   makevectors ( self.angles);
   setorigin ( missile, (self.origin + v_factor ( offset)));
   vec = (((self.enemy.origin - missile.origin) + self.enemy.proj_ofs) + dest_offset);
   vec = normalize ( vec);
   missile.velocity = (vec * set_speed);
   missile.angles = vectoangles ( missile.velocity);
   missile.touch = faBladeTouch;
};

