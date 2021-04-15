float UNDERWATER    = 2.000;
float LIGHTNING_RANDOM    = 1.000;
float LIGHTNING_BOOM    = 2.000;

void () SpawnLightningThink = {
   if (time > self.delay) { remove (self); return ; }

   self.think = SpawnLightningThink;
   if (checkclient()) {
      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
      WriteEntity (MSG_BROADCAST,self);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);
      WriteCoord (MSG_BROADCAST,self.oldorigin_x);
      WriteCoord (MSG_BROADCAST,self.oldorigin_y);
      WriteCoord (MSG_BROADCAST,self.oldorigin_z);

   }
   LightningDamage (self.origin,self.oldorigin,self.lastvictim,self.dmg);
   self.nextthink = (time + 0.100);
};

void () trap_lightning_use = {
   local vector p1;
   local vector p2;
   local vector dir;
   local float dst;
   local float remainder;
   local entity temp;

   if ( (time >= self.pausetime) ) {
      if ( (self.spawnflags & LIGHTNING_BOOM) ) {
         sound (self,CHAN_AUTO,"weapons/lstart.wav",TRUE,ATTN_NORM);
      } else {
         sound (self,CHAN_AUTO,"weapons/lhit.wav",TRUE,ATTN_NORM);
      }
      if (self.classname == "trap_lightning_triggered") self.pausetime = (time + 0.100);
   }
   if ( self.target ) {
      p1 = self.origin;
      p2 = self.enemy.origin;
   } else {
      makevectors (self.angles);
      self.movedir = v_forward;
      traceline (self.origin,(self.origin + (self.movedir * 600.000)),TRUE,self);
      p1 = self.origin;
      p2 = trace_endpos;
   }
   dir = normalize ((p2 - p1));
   dst = vlen ((p2 - p1));
   dst = (dst / SVC_INTERMISSION);
   remainder = (dst - floor (dst));
   if ( (remainder > FALSE) ) {
      remainder = (remainder - TRUE);
      remainder = (remainder * 15.000);
      p1 = (p1 + (remainder * dir));
      p2 = (p2 - (remainder * dir));
   }
   if (self.duration > 0.100) {
      temp = self;
      self = spawn ();
      self.origin = p1;
      self.oldorigin = p2;
      self.lastvictim = temp;
      self.dmg = temp.dmg;
      self.delay = (time + temp.duration);
      SpawnLightningThink ();
      self = temp;
   } else {
      if (checkclient()) {
         WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
         WriteEntity (MSG_BROADCAST,self);
         WriteCoord (MSG_BROADCAST,p1_x);
         WriteCoord (MSG_BROADCAST,p1_y);
         WriteCoord (MSG_BROADCAST,p1_z);
         WriteCoord (MSG_BROADCAST,p2_x);
         WriteCoord (MSG_BROADCAST,p2_y);
         WriteCoord (MSG_BROADCAST,p2_z);
         LightningDamage (p1,p2,self,self.dmg);
      } else {
         LightningDamage (p1,p2,self,self.dmg);
      }
   }
};

void () lightning_think = {
   local float timedelay;

   if (self.state) trap_lightning_use();

   if ( (self.cnt == FALSE) ) {
      if ( (self.spawnflags & LIGHTNING_RANDOM) ) {
         timedelay = (self.wait * random ());
      } else {
         timedelay = self.wait;
      }
      self.cnt = TRUE;
      self.t_length = ((time + self.duration) - 0.100);
      self.pausetime = ((time + self.duration) - 0.100);
      if ( (self.pausetime < (time + 0.300)) ) {
         self.pausetime = (time + 0.300);
      }
      if (timedelay < self.duration) {
         timedelay = self.duration;
      }
      self.t_width = (time + timedelay);
   }
   if (time >= self.t_length) {
      self.cnt = FALSE;
      self.nextthink = self.t_width;
   } else {
      self.nextthink = (time + 0.200);
   }
};

void () lightning_firstthink = {
   local entity targ;

   if (self.target) {
      targ = find (world,targetname,self.target);
      self.dest = targ.origin;
      self.enemy = targ;
   }
   self.think = SUB_Null;
   self.nextthink = FALSE;
   if (self.classname != "trap_lightning_triggered") {
      self.nextthink = ((self.huntingcharmer + self.wait) + self.ltime);
      self.think = lightning_think;
   }
};

void () trap_lightning_triggered = {
   if (self.wait == FALSE) self.wait = TRUE;
   if (self.dmg == FALSE) self.dmg = 30;
   if (self.duration == FALSE) self.duration = 0.100;

   self.cnt = FALSE;
   self.use = trap_lightning_use;
   precache_sound ("weapons/lhit.wav");
   precache_sound ("weapons/lstart.wav");
   self.huntingcharmer = self.nextthink;
   self.think = lightning_firstthink;
   self.nextthink = (time + 0.250);
   if (!self.deathstring) self.deathstring = " was electrocuted";
};

void () trap_lightning = {
   trap_lightning_triggered ();
   self.state = TRUE;
};

void () trap_lightning_switched_use = {
   self.state = (TRUE - self.state);
   if (self.state == TRUE) self.nextthink = self.huntingcharmer;
};

void () trap_lightning_switched = {

   trap_lightning_triggered ();
   self.use = trap_lightning_switched_use;

};

void () trap_tesla_switched_use = { self.state = (TRUE - self.state); if ( (self.state == TRUE) ) self.nextthink = (time + 0.1); };

void () trap_tesla_scan = {
   local entity head, prev;

   self.tesla_numtargets = FALSE;
   head = findradius (self.origin,self.distance);
   while ( head ) {
      if ( (!(head.flags & FL_NOTARGET) && (head.flags & self.cnt)) ) {
         visible (head);
         if ( ((visible (head) && (head.health > FALSE)) && (head.struck_by_mjolnir == FALSE)) ) {
            if ( (self.tesla_numtargets == FALSE) ) {
               self.tesla_target = head;
            } else {
               prev.next_ent = head;
            }
            self.tesla_numtargets = (self.tesla_numtargets + TRUE);
            prev = head;
            if ( (self.tesla_numtargets == self.count) ) return ;
         }
      }
      head = head.chain;
   }
};

void () TeslaLightningThink = {
   self.owner.attack_state = FL_SWIM;
   if ( (time > self.delay) ) {
      self.enemy.struck_by_mjolnir = FALSE;
      remove (self);
      return ;
   }
   traceline (self.origin,self.enemy.origin,TRUE,self);
   vlen ((self.origin - self.enemy.origin));
   if ( (((trace_fraction != TRUE) || (self.enemy.health <= FALSE)) || (vlen ((self.origin - self.enemy.origin)) > (self.distance + MOVETYPE_BOUNCE))) ) {
      self.enemy.struck_by_mjolnir = FALSE;
      remove (self);
      return ;
   }
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   WriteCoord (MSG_BROADCAST,trace_endpos_x);
   WriteCoord (MSG_BROADCAST,trace_endpos_y);
   WriteCoord (MSG_BROADCAST,trace_endpos_z);
   LightningDamage (self.origin,trace_endpos,self.lastvictim,self.dmg);
   self.nextthink = (time + 0.100);
};

void (entity targ) SpawnTeslaLightning = {
   local entity lgt;

   lgt = spawn ();
   if ( (self.duration > FALSE) ) {
      lgt.delay = (time + self.duration);
   } else {
      lgt.delay = (time + 9999.000);
   }
   lgt.enemy = targ;
   targ.struck_by_mjolnir = TRUE;
   lgt.distance = self.distance;
   lgt.owner = self;
   lgt.lastvictim = self.lastvictim;
   lgt.dmg = self.dmg;
   lgt.origin = self.origin;
   lgt.think = TeslaLightningThink;
   lgt.nextthink = time;
   lgt.deathtype = self.deathtype;
};

void () trap_tesla_think = {
   if ( (self.state == 0) ) { self.nextthink = (time + 0.250); return; }
   if ( (self.attack_state == 0) ) {
      self.think = trap_tesla_think;
      trap_tesla_scan ();
      if ( (self.tesla_numtargets > FALSE) ) {
         if ( (self.wait > FALSE) ) sound (self,CHAN_AUTO,"misc/tesla.wav",TRUE,ATTN_NORM);
         self.attack_state = TRUE;
         self.nextthink = (time + self.wait);
         return ;
      }
      self.nextthink = (time + 0.250);
      if ((self.delay > FALSE) && (time > self.search_time) ) self.attack_state = MOVETYPE_WALK;
   } else {
      if ( (self.attack_state == TRUE) ) {
         trap_tesla_scan ();
         while ( (self.tesla_numtargets > FALSE) ) {
            sound (self,CHAN_AUTO,"hipweap/mjolhit.wav",TRUE,ATTN_NORM);
            SpawnTeslaLightning (self.tesla_target);
            self.tesla_target = self.tesla_target.next_ent;
            self.tesla_numtargets = (self.tesla_numtargets - TRUE);
         }
         self.attack_state = FL_SWIM;
         self.nextthink = (time + TRUE);
      } else {
         if ( (self.attack_state == FL_SWIM) ) {
            self.attack_state = MOVETYPE_WALK;
            self.nextthink = (time + 0.200);
         } else {
            if ( (self.attack_state == MOVETYPE_WALK) ) {
               self.attack_state = FALSE;
               self.nextthink = (time + 0.100);
               if ( (self.classname == "trap_gods_wrath") ) {
                  self.nextthink = CONTENT_EMPTY;
               }
            }
         }
      }
   }
};

void () trap_tesla_coil = {
   precache_sound ("misc/tesla.wav");
   precache_sound ("hipweap/mjolhit.wav");
   if ( (self.wait == FALSE) ) self.wait = FL_SWIM;
   if ( (self.dmg == FALSE) ) self.dmg = (FL_SWIM + (MOVETYPE_FLY * cvar ("skill")));
   if ( (self.duration == FALSE) ) self.duration = CONTENT_EMPTY;
   if ( (self.distance == FALSE) ) self.distance = 600.000;
   if ( (self.spawnflags & TRUE) ) { self.cnt = (FL_CLIENT | FL_MONSTER); } else { self.cnt = FL_CLIENT; }
   self.use = trap_tesla_switched_use;
   if ( (self.delay == FALSE) ) self.delay = CONTENT_EMPTY;
   self.nextthink = (time + random ());
   self.think = trap_tesla_think;
   self.lastvictim = world;
   self.tesla_numtargets = FALSE;
   self.attack_state = FALSE;
   self.deathtype = "is electrocuted";
};

void () trap_gods_wrath_use = {
   if ( (self.attack_state == FALSE) ) {
      self.search_time = (time + self.delay);
      self.lastvictim = activator;
      trap_tesla_think ();
   }
};

void () trap_gods_wrath = {
   if ( (self.delay == FALSE) ) self.delay = MOVETYPE_FLY;
   trap_tesla_coil ();
   self.wait = FALSE;
   self.state = TRUE;
   self.nextthink = CONTENT_EMPTY;
   self.deathtype = "suffers the wrath of God";
   self.use = trap_gods_wrath_use;
};

void () trap_gravity_touch = {
   if ( (self.attack_finished > time) ) return ;
   if ( other.takedamage ) { T_Damage (other,self,self,self.dmg,DAMARMOR); self.attack_finished = (time + 0.200); }
};

void () trap_gravity_think = {
   local vector vel;
   local vector dir;
   local vector delta;

   self.ltime = time;
   trap_tesla_scan ();
   while ( (self.tesla_numtargets > FALSE) ) {
      delta = (self.origin - self.tesla_target.origin);
      dir = normalize (delta);
      vel = (dir * self.speed);
      if ( ((self.tesla_target.wetsuit_finished > time) && (self.spawnflags & UNDERWATER)) ) vel = (vel * 0.600);
      self.tesla_target.velocity = (self.tesla_target.velocity + vel);
      self.tesla_target = self.tesla_target.next_ent;
      self.tesla_numtargets = (self.tesla_numtargets - TRUE);
   }
   self.nextthink = (time + 0.100);
};

void () trap_gravity_well = {
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_NONE;
   setsize (self,'-16.000 -16.000 -16.000','16.000 16.000 16.000');
   if ( (self.dmg == FALSE) ) self.dmg = 10000.000;
   if ( (self.speed == FALSE) ) self.speed = 210.000;
   if ( (self.distance == FALSE) ) self.distance = 600.000;
   if ( (self.spawnflags & TRUE) ) { self.cnt = (FL_CLIENT | FL_MONSTER); } else { self.cnt = FL_CLIENT; }
   self.attack_finished = FALSE;
   self.think = trap_gravity_think;
   self.touch = trap_gravity_touch;
   self.lastvictim = world;
   self.tesla_numtargets = FALSE;
   self.nextthink = (time + 0.100);
   self.ltime = time;
};