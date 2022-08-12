.entity hook;
.float on_hook;
.float hook_out;
float () crandom;

void (vector org, vector vel, float damage) SpawnBlood;

void (entity h, entity player) GrappleTrail = {

   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_BEAM);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,player.origin_x);
   WriteCoord (MSG_BROADCAST,player.origin_y);
   WriteCoord (MSG_BROADCAST,(player.origin_z + FL_INWATER));
   WriteCoord (MSG_BROADCAST,h.origin_x);
   WriteCoord (MSG_BROADCAST,h.origin_y);
   WriteCoord (MSG_BROADCAST,h.origin_z);

};

void () GrappleReset = {

   self.owner.on_hook = FALSE;
   self.owner.hook_out = FALSE;
   self.owner.weaponframe = FALSE;
   self.owner.attack_finished = (time + 0.250);
   remove (self);

};

void () GrappleTrack = {

   local vector spray;

   if ( ((self.enemy.classname == "player") && (self.enemy.health <= FALSE)) ) {

      self.owner.on_hook = FALSE;

   }
   if ( (!self.owner.on_hook || (self.owner.health <= FALSE)) ) {

      GrappleReset ();
      return ;

   }
   if ( (self.enemy.classname == "player") ) {

      if ( (self.enemy.teleport_time > time) ) {

         GrappleReset ();
         return ;

      }
      setorigin (self,self.enemy.origin);
      sound (self,CHAN_WEAPON,"pendulum/hit.wav",TRUE,ATTN_NORM);
      T_Damage (self.enemy,self,self.owner,TRUE);
      makevectors (self.v_angle);
      spray_x = (100.000 * crandom ());
      spray_y = (100.000 * crandom ());
      spray_z = ((100.000 * crandom ()) + 50.000);
      SpawnBlood (self.origin,spray,20.000);

   }
   if ( (self.enemy.solid == SOLID_SLIDEBOX) ) {

      self.velocity = VEC_ORIGIN;
      setorigin (self,((self.enemy.origin + self.enemy.mins) + (self.enemy.size * 0.500)));

   } else {

      self.velocity = self.enemy.velocity;

   }
   self.nextthink = (time + 0.100);

};

void () GrappleAnchor = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      GrappleReset ();
      return ;

   }
   if ( (other.classname == "player") ) {

      if ( (other.steam == self.owner.steam) ) {

         GrappleReset ();
         return ;

      }
      sound (self,CHAN_WEAPON,"player/axhit1.wav",TRUE,ATTN_NORM);
      T_Damage (other,self,self.owner,MOVETYPE_BOUNCE);

   } else {

      sound (self,CHAN_WEAPON,"player/axhit2.wav",TRUE,ATTN_NORM);
      if ( other.takedamage ) {

         T_Damage (other,self,self.owner,TRUE);

      }
      self.velocity = VEC_ORIGIN;
      self.avelocity = VEC_ORIGIN;

   }
   self.frame = FL_SWIM;
   sound (self.owner,CHAN_WEAPON,"weapons/tink1.wav",TRUE,ATTN_NORM);
   if ( !self.owner.button0 ) {

      GrappleReset ();
      return ;

   }
   self.owner.on_hook = TRUE;
   if ( (self.owner.flags & FL_ONGROUND) ) {

      self.owner.flags = (self.owner.flags - FL_ONGROUND);

   }
   self.owner.lefty = TRUE;
   self.enemy = other;
   self.think = GrappleTrack;
   self.nextthink = time;
   self.solid = SOLID_NOT;
   self.touch = SUB_Null;

};

void () W_FireGrapple = {

   if ( self.hook_out ) {

      return ;

   }
   self.punchangle_x = CONTENT_SOLID;
   sound (self,CHAN_WEAPON,"weapons/chain1.wav",TRUE,ATTN_NORM);
   newmis = spawn ();
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.owner = self;
   self.hook = newmis;
   newmis.classname = "hook";
   makevectors (self.v_angle);
   newmis.velocity = (v_forward * 800.000);
   newmis.angles = vectoangles (v_forward);
   newmis.touch = GrappleAnchor;
   newmis.think = GrappleReset;
   newmis.nextthink = (time + FL_SWIM);
   newmis.frame = TRUE;
   setmodel (newmis,"progs/hook.mdl");
   setorigin (newmis,((self.origin + (v_forward * FL_INWATER)) + '0.000 0.000 16.000'));
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   self.hook_out = TRUE;

};

void () GrappleService = {

   local vector dist;
   local vector vel;
   local float v;

   if ( !self.on_hook ) {

      if ( (vlen ((self.hook.origin - self.origin)) > 50.000) ) {

         GrappleTrail (self.hook,self);

      }
      return ;

   }
   if ( ((!self.button0 && (self.weapon == IT_GRAPPLE)) || (self.teleport_time > time)) ) {

      self = self.hook;
      GrappleReset ();
      return ;

   }
   makevectors (self.angles);
   dist = (self.hook.origin - self.origin);
   vel = (self.hook.origin - ((self.origin + ((v_up * FL_INWATER) * !self.button2)) + (v_forward * FL_INWATER)));
   v = vlen (vel);
   if ( (v <= 100.000) ) {

      vel = ((normalize (vel) * v) * MOVETYPE_BOUNCE);

   } else {

      vel = (normalize (vel) * 1000.000);

   }
   self.velocity = vel;
   if ( (vlen (dist) <= 50.000) ) {

      if ( self.lefty ) {

         self.lefty = FALSE;

      }

   } else {

      GrappleTrail (self.hook,self);

   }

};
