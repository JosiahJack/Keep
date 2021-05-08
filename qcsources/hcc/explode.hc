void  ()CB_BoltStick;
void  (string type)FireMeteor;

void  ()BlowUp =  {
   if ( ((self.dmg < 2.50000) && (self.scale >= 0.10000)) ) {

      self.v_angle = RandomVector ( '180.00000 180.00000 180.00000');
      self.scale = self.dmg;
      T_RadiusDamage ( self, self.owner, (self.dmg * 100.00000), world);
      self.dmg += 0.10000;
      if ( self.enemy ) {

         setorigin ( self, (self.enemy.origin + self.view_ofs));

      }
      self.think = BlowUp;
      AdvanceThinkTime(self,0.02500);
   } else {

      self.think = SUB_Remove;
      AdvanceThinkTime(self,0.00000);

   }
};


void  ()SprayFire =  {
local entity fireballblast;
   sound ( self, CHAN_AUTO, "weapons/fbfire.wav", 1.00000, ATTN_NORM);
   fireballblast = spawn ( );
   fireballblast.enemy = self.enemy;
   fireballblast.movetype = MOVETYPE_NOCLIP;
   fireballblast.owner = self.owner;
   fireballblast.classname = "fireballblast";
   fireballblast.solid = SOLID_NOT;
   fireballblast.drawflags |= ((MLS_ABSLIGHT | SCALE_TYPE_UNIFORM) | SCALE_ORIGIN_CENTER);
   fireballblast.abslight = 0.50000;
   fireballblast.scale = 0.10000;
   setmodel ( fireballblast, "models/blast.mdl");
   setsize ( fireballblast, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( fireballblast, self.origin);
   fireballblast.dmg = 0.10000;
   fireballblast.avelocity = '50.00000 50.00000 50.00000';
   fireballblast.think = BlowUp;
   AdvanceThinkTime(fireballblast,0.00000);
   remove ( self);
};


void  ()SmallExplosion =  {
   sound ( self, CHAN_AUTO, "weapons/explode.wav", 0.50000, ATTN_NORM);
   BecomeExplosion ( CE_SM_EXPLOSION);
};


void  ()DarkExplosion =  {
local entity ignore;
   if ( (self.classname == "timebomb") ) {

      sound ( self, CHAN_AUTO, "weapons/explode.wav", 1.00000, ATTN_NORM);
      ignore = self.enemy;
   } else {

      if ( (self.classname == "pincer") ) {

         sound ( self, CHAN_BODY, "weapons/explode.wav", 1.00000, ATTN_NORM);
         ignore = self.owner;
      } else {

         if ( (self.controller.classname == "multigrenade") ) {

            sound ( self.controller, CHAN_BODY, "weapons/explode.wav", 1.00000, ATTN_NORM);
         } else {

            sound ( self, CHAN_AUTO, "weapons/explode.wav", 1.00000, ATTN_NORM);

         }
         ignore = world;

      }

   }
   T_RadiusDamage ( self, self.owner, self.dmg, ignore);
   if ( ((self.classname == "minigrenade") && (random() < 0.50000)) ) {

      BecomeExplosion ( FALSE);
   } else {

      if ( (self.classname == "flaming arrow") ) {

         starteffect ( CE_XBOW_EXPLOSION, self.origin);
         remove ( self);
      } else {

         starteffect ( CE_NEW_EXPLOSION, self.origin);
         remove ( self);

      }

   }
};


void  ()MultiExplode =  {
local float nummeteorites = 0.00000;
   if ( (self.classname == "stickmine") ) {

      SprayFire ( );
      return ;

   }
   T_RadiusDamage ( self, self.owner, self.dmg, world);
   if ( (self.classname == "meteor") ) {

      nummeteorites = random(3.00000,10.00000);
      while ( (nummeteorites > 0.00000) ) {

         FireMeteor ( "minimeteor");
         nummeteorites = (nummeteorites - 1.00000);

      }

   }
   if ( (self.flags2 & FL_SMALL) ) {

      SmallExplosion ( );
   } else {

      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte ( MSG_BROADCAST, TE_EXPLOSION);
      WriteCoord ( MSG_BROADCAST, self.origin_x);
      WriteCoord ( MSG_BROADCAST, self.origin_y);
      WriteCoord ( MSG_BROADCAST, self.origin_z);
      BecomeExplosion ( FALSE);

   }
};

void  ()SuperGrenadeExplode;

void  ()GrenadeTouch2 =  {
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (((other.owner == self.owner) && (other.classname == self.classname)) && (self.classname == "minigrenade")) ) {

      return ;

   }
   if ( (other.takedamage == DAMAGE_YES) ) {

      T_Damage ( other, self, self.owner, self.dmg);
      self.dmg /= 2.00000;
      if ( (self.classname == "multigrenade") ) {

         self.think = SuperGrenadeExplode;
      } else {

         if ( ((self.classname == "minigrenade") || (self.classname == "flaming arrow")) ) {

            self.think = DarkExplosion;
         } else {

            self.think = MultiExplode;

         }

      }
      AdvanceThinkTime(self,0.00000);
   } else {

      sound ( self, CHAN_WEAPON, "assassin/gbounce.wav", 1.00000, ATTN_NORM);
      if ( (self.velocity == '0.00000 0.00000 0.00000') ) {

         self.avelocity = '0.00000 0.00000 0.00000';

      }

   }
};


void  ()StickMineTouch =  {
local vector stickdir = '0.00000 0.00000 0.00000';
   if ( (other == self.owner) ) {

      return ;

   }
   self.skin = 1.00000;
   self.touch = SUB_Null;
   if ( other.takedamage ) {

      sound ( self, CHAN_WEAPON, "weapons/met2flsh.wav", 1.00000, ATTN_NORM);
      T_Damage ( other, self, self.owner, 3.00000);
      if ( (other.solid != SOLID_BSP) ) {

         stickdir = (other.origin + (normalize ( (self.origin - other.origin)) * 12.00000));
         if ( (other.classname == "player") ) {

            stickdir_z = ((other.origin_z + other.proj_ofs_z) + 1.00000);
         } else {

            if ( (other.classname == "monster_spider") ) {

               stickdir_z = ((self.origin_z + ((other.origin_z + (other.size_z * 0.20000)) * 3.00000)) * 0.25000);
            } else {

               stickdir_z = ((self.origin_z + ((other.origin_z + (other.size_z * 0.60000)) * 3.00000)) * 0.25000);

            }

         }
         setorigin ( self, stickdir);
         SpawnPuff ( (self.origin + (v_forward * 8.00000)), ('0.00000 0.00000 0.00000' - (v_forward * 24.00000)), 10.00000, other);

      }
   } else {

      setorigin ( self, (self.origin + (normalize ( self.velocity) * -3.00000)));
      sound ( self, CHAN_WEAPON, "weapons/met2stn.wav", 1.00000, ATTN_NORM);
      SpawnPuff ( (self.origin + (v_forward * 8.00000)), ('0.00000 0.00000 0.00000' - (v_forward * 24.00000)), 10.00000, world);

   }
   self.velocity = '0.00000 0.00000 0.00000';
   self.movetype = MOVETYPE_NOCLIP;
   self.solid = SOLID_NOT;
   self.touch = SUB_Null;
   self.wait = (time + 1.00000);
   self.health = other.health;
   if ( other.takedamage ) {

      self.enemy = other;
      self.view_ofs = (self.origin - other.origin);
      self.o_angle = (self.angles - self.enemy.angles);
      self.think = CB_BoltStick;
      AdvanceThinkTime(self,0.00000);
   } else {

      self.enemy = world;
      self.movetype = MOVETYPE_NONE;
      self.think = MultiExplode;
      AdvanceThinkTime(self,0.50000);

   }
};


void  ()Use_Fireball =  {
local entity missile;
   self.attack_finished = (time + 1.00000);
   makevectors ( self.v_angle);
   missile = spawn ( );
   missile.owner = self;
   missile.classname = "stickmine";
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.touch = StickMineTouch;
   missile.dmg = 50.00000;
   missile.velocity = ((normalize ( v_forward) * 700.00000) + (v_up * 200.00000));
   missile.avelocity = RandomVector ( '300.00000 300.00000 300.00000');
   missile.lifetime = (time + 60.00000);
   setmodel ( missile, "models/glyphwir.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( missile, ((self.origin + self.proj_ofs) + (v_forward * 16.00000)));
   missile.think = MultiExplode;
   AdvanceThinkTime(missile,10.00000);
};

