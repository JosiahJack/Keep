
void  ()faSpellTouch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   damg = random(12.00000,22.00000);
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   T_RadiusDamage ( self, self.owner, damg, other);
   sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   CreateRedSpark ( self.origin);
   remove ( self);
};


void  ()faspell_frames =  {
local float old_angle = 0.00000;
local float old_count = 0.00000;
local vector new_posA = '0.00000 0.00000 0.00000';
local vector new_posB = '0.00000 0.00000 0.00000';
local vector posA = '0.00000 0.00000 0.00000';
local vector posB = '0.00000 0.00000 0.00000';
   self.think = faspell_frames;
   AdvanceThinkTime(self,HX_FRAME_TIME);
   AdvanceFrame ( 0.00000, 8.00000);
   AdvanceFrame ( 0.00000, 8.00000);
   old_angle = self.spell_angle;
   old_count = self.count;
   self.spell_angle += random(32.00000,42.00000);
   if ( (self.spell_angle >= 360.00000) ) {

      self.spell_angle -= 360.00000;

   }
   if ( (self.count < 6.00000) ) {

      self.count += 0.60000;

   }
   makevectors ( self.angles);
   posA = ((v_right * sin ( self.spell_angle)) * self.count);
   posB = ((v_right * sin ( old_angle)) * old_count);
   new_posA = (posA - posB);
   posA = ((v_up * cos ( self.spell_angle)) * self.count);
   posB = ((v_up * cos ( old_angle)) * old_count);
   new_posB = (posA - posB);
   new_posA += new_posB;
   movestep ( new_posA_x, new_posA_y, new_posA_z, FALSE);
   if ( (self.lifetime < time) ) {

      remove ( self);

   }
};


void  (vector offset,float set_speed)do_faSpell =  {
local entity missile;
local vector vec = '0.00000 0.00000 0.00000';
   self.last_attack = time;
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.flags = FL_FLY;
   missile.health = 10.00000;
   missile.drawflags = MLS_FIREFLICKER;
   setmodel ( missile, "models/faspell.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   makevectors ( self.angles);
   setorigin ( missile, (self.origin + v_factor ( offset)));
   vec = ((self.enemy.origin - missile.origin) + self.enemy.proj_ofs);
   vec = normalize ( vec);
   missile.velocity = (vec * set_speed);
   missile.angles = vectoangles ( missile.velocity);
   missile.spell_angle = random(360.00000);
   missile.count = 1.00000;
   missile.touch = faSpellTouch;
   missile.think = faspell_frames;
   missile.lifetime = (time + 3.00000);
   AdvanceThinkTime(missile,HX_FRAME_TIME);
};

