
void  ()BoomCheck =  {
   if ( (self.goalentity.classname == "chain_head") ) {

      self.goalentity.view_ofs = self.origin;

   }
   if ( (self.bloodloss < 30.00000) ) {

      setmodel ( self, "models/sm_expld.spr");

   }
   if ( ((pointcontents ( self.origin) == CONTENT_SOLID) || (self.bloodloss <= 0.00000)) ) {

      if ( (self.goalentity.classname == "chain_head") ) {

         remove ( self.goalentity);

      }
      remove ( self);

   }
};


void  ()b_explode1 =  [  0.0, b_explode2] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode2 =  [  1.0, b_explode3] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode3 =  [  2.0, b_explode4] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode4 =  [  3.0, b_explode5] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode5 =  [  4.0, b_explode6] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode6 =  [  5.0, b_explode7] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode7 =  [  6.0, b_explode8] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode8 =  [  7.0, b_explode9] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode9 =  [  8.0, b_explode10] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode10 =  [  9.0, b_explode11] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode11 =  [ 10.0, b_explode12] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()b_explode12 =  [ 11.0, ShaBoom] {
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   BoomCheck ( );
};


void  ()ShaBoom =  {
   BoomCheck ( );
   T_RadiusDamage ( self, self.owner, self.bloodloss, world);
   self.bloodloss = (self.bloodloss - 1.00000);
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_EXPLOSION);
   WriteCoord ( MSG_BROADCAST, self.origin_x);
   WriteCoord ( MSG_BROADCAST, self.origin_y);
   WriteCoord ( MSG_BROADCAST, self.origin_z);
   b_explode1 ( );
};


void  ()FireExplosion =  {
local entity boommissile;
   boommissile = spawn ( );
   boommissile.owner = self.controller;
   boommissile.movetype = MOVETYPE_NOCLIP;
   boommissile.solid = SOLID_NOT;
   boommissile.velocity = (self.v_angle * 3.00000);
   boommissile.think = ShaBoom;
   boommissile.nextthink = time;
   boommissile.goalentity = self.goalentity;
   boommissile.bloodloss = 100.00000;
   boommissile.classname = "tripwire";
   setorigin ( boommissile, self.origin);
   setmodel ( boommissile, "models/bg_expld.spr");
   MultiExplode ( );
};


void  ()LaserTripped =  {
   self.takedamage = DAMAGE_NO;
   sound ( self, CHAN_AUTO, "misc/warning.wav", 1.00000, ATTN_NORM);
   self.effects = EF_BRIGHTLIGHT;
   self.think = FireExplosion;
   self.nextthink = (time + 0.10000);
};


void  ()LaserThink =  {
   if ( !self.aflag ) {

      sound ( self, CHAN_BODY, "doors/baddoor.wav", 1.00000, ATTN_NORM);
      self.controller = self.owner;
      self.owner = self;
      self.skin = 1.00000;
      self.aflag = TRUE;

   }
   traceline ( (self.origin + normalize ( (self.v_angle * 8.00000))), self.goalentity.origin, FALSE, self.goalentity);
   if ( (trace_fraction < 1.00000) ) {

      if ( (((trace_ent.velocity != '0.00000 0.00000 0.00000') || (trace_ent.health > 0.00000)) || trace_ent.takedamage) ) {

         self.think = LaserTripped;

      }
   } else {

      self.think = LaserThink;

   }
   self.nextthink = time;
   if ( ((self.lifetime < time) || (self.tripwire_cnt < (self.controller.tripwire_cnt - 3.00000))) ) {

      self.think = self.th_die;

   }
};


void  ()ChainDie =  {
   if ( self.owner ) {

      self.owner.think = MultiExplode;
      AdvanceThinkTime(self.owner,0.00000);

   }
   MultiExplode ( );
};


void  ()ChainTouch =  {
   if ( (other == self.owner) ) {

      return ;

   }
   self.touch = SUB_Null;
   if ( other.takedamage ) {

      self.owner.think = LaserTripped;
      self.owner.nextthink = time;
   } else {

      sound ( self, CHAN_BODY, "weapons/met2stn.wav", 1.00000, ATTN_NORM);
      self.movetype = MOVETYPE_NONE;
      self.velocity = '0.00000 0.00000 0.00000';
      self.health = 25.00000;
      self.takedamage = DAMAGE_YES;
      self.th_die = ChainDie;
      setsize ( self, '-3.00000 -3.00000 -6.00000', '3.00000 3.00000 6.00000');

   }
};


void  ()ChainThink =  {
   DrawLinks ( );
   traceline ( self.origin, self.view_ofs, FALSE, self);
   if ( (((vlen ( (self.origin - self.owner.origin)) > 640.00000) && (self.movetype == MOVETYPE_FLYMISSILE)) || (trace_fraction < 1.00000)) ) {

      self.owner.think = LaserTripped;
      self.owner.nextthink = time;
      remove ( self);

   }
   self.nextthink = (time + 0.05000);
};


void  ()FireChain =  {
local vector dir = '0.00000 0.00000 0.00000';
   sound ( self, CHAN_BODY, "assassin/chain.wav", 1.00000, ATTN_NORM);
   dir = normalize ( self.v_angle);
   newmis = spawn ( );
   newmis.classname = "chain_head";
   newmis.owner = self;
   self.goalentity = newmis;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.velocity = (dir * 750.00000);
   newmis.touch = ChainTouch;
   newmis.think = ChainThink;
   newmis.drawflags = MLS_POWERMODE;
   newmis.nextthink = time;
   newmis.view_ofs = self.origin;
   newmis.angles = vectoangles ( newmis.velocity);
   setmodel ( newmis, "models/twspike.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, (self.origin + (dir * 8.00000)));
};


void  ()TripArmed =  {
   FireChain ( );
   self.think = LaserThink;
   AdvanceThinkTime(self,0.00000);
   self.lifetime = (time + 60.00000);
};


void  ()TripTouch =  {
   if ( (((other.takedamage && other.health) && ((other.classname == "player") || other.movetype)) && (other != self.owner)) ) {

      MultiExplode ( );
   } else {

      sound ( self, CHAN_WEAPON, "buttons/switch04.wav", 1.00000, ATTN_NORM);
      self.v_angle = ('0.00000 0.00000 0.00000' - self.velocity);
      self.angles = vectoangles ( self.v_angle);
      self.movetype = MOVETYPE_NONE;
      self.velocity = '0.00000 0.00000 0.00000';
      self.avelocity = '0.00000 0.00000 0.00000';
      setsize ( self, '-3.00000 -3.00000 -6.00000', '3.00000 3.00000 6.00000');
      self.hull = HULL_POINT;
      self.touch = SUB_Null;
      self.think = TripArmed;
      AdvanceThinkTime(self,0.50000);

   }
};


void  ()TripDie =  {
   if ( (self.goalentity.classname == "chain_head") ) {

      remove ( self.goalentity);

   }
   MultiExplode ( );
};


void  ()Use_Tripwire =  {
local entity missile;
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.health = 25.00000;
   missile.takedamage = DAMAGE_YES;
   missile.th_die = TripDie;
   missile.classname = "tripwire";
   makevectors ( self.v_angle);
   missile.touch = TripTouch;
   missile.think = SUB_Null;
   missile.nextthink = -1.00000;
   self.tripwire_cnt += 1.00000;
   missile.tripwire_cnt = self.tripwire_cnt;
   missile.velocity = (normalize ( v_forward) * 500.00000);
   missile.angles = vectoangles ( ('0.00000 0.00000 0.00000' - missile.velocity));
   missile.avelocity_z = 300.00000;
   setmodel ( missile, "models/glyphwir.mdl");
   setorigin ( missile, ((self.origin + self.proj_ofs) + (v_forward * 4.00000)));
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
};

