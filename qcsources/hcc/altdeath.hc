
void  ()ice_melt =  {
   self.scale -= 0.05000;
   if ( (self.scale <= 0.05000) ) {

      remove ( self);
   } else {

      self.think = ice_melt;

   }
   AdvanceThinkTime(self,0.05000);
};


void  ()ice_think =  {
   if ( (self.velocity == '0.00000 0.00000 0.00000') ) {

      self.touch = SUB_Null;
      self.think = ice_melt;
      AdvanceThinkTime(self,1.50000);
   } else {

      self.think = ice_think;
      AdvanceThinkTime(self,0.10000);

   }
};


void  ()ice_hit =  {
   if ( (random() < 0.20000) ) {

      particleexplosion ( self.origin, 14.00000, 20.00000, 5.00000);
      remove ( self);

   }
};


void  ()todust =  {
   particleexplosion ( self.origin, self.aflag, 20.00000, 5.00000);
   remove ( self);
};


void  ()pebble_hit =  {
   self.wait = (self.wait + 1.00000);
   sound ( self, CHAN_BODY, "misc/rubble.wav", 1.00000, ATTN_NORM);
   if ( ((self.wait >= 3.00000) || (random() < 0.10000)) ) {

      todust ( );
   } else {

      self.think = todust;
      AdvanceThinkTime(self,2.00000);

   }
};


void  (vector org,vector dir,vector spin,string type,vector ownersize)throw_shard =  {
local float chunk_size = 0.00000;
   newmis = spawn_temp ( );
   newmis.movetype = MOVETYPE_BOUNCE;
   newmis.solid = SOLID_TRIGGER;
   newmis.velocity = dir;
   newmis.avelocity = spin;
   chunk_size = (((ownersize_x + ownersize_y) + ownersize_z) / 3.00000);
   newmis.scale = ((random(0.50000) * chunk_size) / 24.00000);
   if ( !newmis.scale ) {

      newmis.scale = 0.30000;

   }
   newmis.classname = "type";
   setmodel ( newmis, "models/shard.mdl");
   if ( (type == "ice") ) {

      newmis.skin = 0.00000;
      newmis.frame = 0.00000;
      newmis.touch = ice_hit;
      newmis.think = ice_think;
      AdvanceThinkTime(newmis,1.00000);
      newmis.drawflags |= (DRF_TRANSLUCENT | MLS_ABSLIGHT);
      newmis.abslight = 0.75000;
   } else {

      if ( (type == "pebbles") ) {

         newmis.skin = 1.00000;
         newmis.frame = rint ( random(1.00000,2.00000));
         newmis.touch = pebble_hit;
         newmis.speed = 16.00000;
         newmis.aflag = 10.00000;

      }

   }
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, org);
};


void  ()shatter =  {
local vector dir = '0.00000 0.00000 0.00000';
local vector spin = '0.00000 0.00000 0.00000';
local vector org = '0.00000 0.00000 0.00000';
local float numshards = 0.00000;
local float maxshards = 0.00000;
local float rng = 0.00000;
local string type;
   if ( ((self.movechain != world) && !(self.movechain.flags & FL_CLIENT)) ) {

      remove ( self.movechain);

   }
   if ( (self.scale == 0.00000) ) {

      self.scale = 1.00000;

   }
   if ( (self.classname == "snowball") ) {

      maxshards = random(4.00000,2.00000);
   } else {

      maxshards = random(7.00000,10.00000);

   }
   org = ((self.absmin + self.absmax) * 0.50000);
   if ( ((self.deathtype == "ice shatter") || (self.deathtype == "ice melt")) ) {

      particleexplosion ( org, 14.00000, 25.00000, 50.00000);
      if ( (self.deathtype == "ice shatter") ) {

         rng = 600.00000;
      } else {

         rng = (self.size_x / 2.00000);

      }
      if ( (self.classname != "snowball") ) {

         sound ( self, CHAN_BODY, "misc/icestatx.wav", 1.00000, ATTN_NORM);

      }
      type = "ice";
   } else {

      if ( (self.deathtype == "stone crumble") ) {

         sound ( self, CHAN_BODY, "misc/sshatter.wav", 1.00000, ATTN_NORM);
         particleexplosion ( org, 10.00000, 60.00000, 50.00000);
         rng = 450.00000;
         type = "pebbles";

      }

   }
   while ( (numshards < maxshards) ) {

      dir_x = random((0.00000 - rng),rng);
      dir_y = random((0.00000 - rng),rng);
      dir_z = random((0.00000 - rng),rng);
      spin_x = random(300.00000,-300.00000);
      spin_y = random(300.00000,-300.00000);
      spin_z = random(300.00000,-300.00000);
      throw_shard ( org, dir, spin, type, self.size);
      numshards += 1.00000;

   }
   if ( ((self.movechain != world) && !(self.movechain.flags & FL_CLIENT)) ) {

      remove ( self.movechain);

   }
   if ( (self.classname != "player") ) {

      remove ( self);

   }
};

