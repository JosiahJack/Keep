
void() xpackEnding;

void() time_chunk = { // [FUNCTION]
   local entity timeChunk;

   timeChunk = spawn();
   setmodel(timeChunk,"progs/rogue/timegib.mdl");
   timeChunk.solid = SOLID_NOT;
   timeChunk.movetype = MOVETYPE_TOSS;
   makevectors(self.owner.angles);
   setorigin(timeChunk,((self.owner.origin + (v_forward * 84.000)) - (v_up * 136.000)));
   timeChunk.velocity = (v_up * -50.000);
   timeChunk.avelocity = '300.000 300.000 300.000';
   timeChunk.angles = self.owner.angles;
   R_Exp3(timeChunk.origin);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,timeChunk.origin_x);
   WriteCoord (MSG_BROADCAST,timeChunk.origin_y);
   WriteCoord (MSG_BROADCAST,timeChunk.origin_z);
   self.owner.frame = TRUE;
   timeChunk.think = SUB_Remove;
   timeChunk.nextthink = (time + MOVETYPE_FLY);
};

void() time_stop_shake = { // [FUNCTION]
   SUB_UseTargets();
   remove(self);
};

void() time_boom = { // [FUNCTION]
   local entity stopShakeEnt;

   SUB_UseTargets();
   if ( ((self.owner.health < 1250.000) && (self.owner.frame > FALSE)) ) {
      if ( (self.owner.skin < FL_SWIM) ) {
         self.owner.frame = FL_SWIM;
         self.owner.skin = FL_SWIM;
      }
   } else {
      if ( (self.owner.health < 1500.000) ) {
         if ( (self.owner.frame == FALSE) ) {
            time_chunk();
            self.owner.frame = TRUE;
            self.owner.skin = TRUE;
         }
      }
   }

	R_Exp3(self.origin);
   if ( (random () < 0.500) ) {
      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_EXPLOSION);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);
   } else {
      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_EXPLOSION2);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);
      WriteByte (MSG_BROADCAST,244.000);
      WriteByte (MSG_BROADCAST,MOVETYPE_WALK);
   }

   BecomeExplosion();
   stopShakeEnt = spawn();
   stopShakeEnt.target = self.target;
   stopShakeEnt.think = time_stop_shake;
   stopShakeEnt.nextthink = (time + 0.7);
};

void() time_fall = { // [FUNCTION]
   if ( !self.pain_finished ) {
      if ( (self.origin_z < -20.000) ) {
         WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST,TE_LAVASPLASH);
         WriteCoord (MSG_BROADCAST,self.origin_x);
         WriteCoord (MSG_BROADCAST,self.origin_y);
         WriteCoord (MSG_BROADCAST,(self.origin_z - 80));
         self.pain_finished = TRUE;
      } else {
         if ( (random () < 0.3) ) {
            WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
            WriteByte (MSG_BROADCAST,TE_EXPLOSION);
            WriteCoord (MSG_BROADCAST,self.origin_x);
            WriteCoord (MSG_BROADCAST,self.origin_y);
            WriteCoord (MSG_BROADCAST,self.origin_z);
         }
      }
   }
   self.velocity_z = (self.velocity_z - MOVETYPE_FLY);
   self.nextthink = (time + 0.1);
   self.think = time_fall;
};

void() time_crash = { // [FUNCTION]
   self.takedamage = DAMAGE_NO;
   self.movetype = MOVETYPE_FLY;
   self.solid = SOLID_NOT;
   self.velocity = '0 0 -50';
   self.avelocity = '15 0 5';
   setsize (self,VEC_ORIGIN,VEC_ORIGIN);
   self.think = time_fall;
   self.nextthink = (time + 0.1);
   self.target = "timeramp";
   SUB_UseTargets();
};

void(entity inflictor, entity attacker, float take) time_crash_pain = { time_crash(); }; // [FUNCTION], Compiler redirect.

void(entity inflictor, entity attacker, float take) time_pain = { // [FUNCTION]
   local entity painEnt;
   local float painRnd;

   if ((self.health > 1100) && (self.pain_finished > time)) return;

   painRnd = random();
   if ( (painRnd < 0.4) ) {
      self.pain_finished = (time + 2);
      painRnd = random();
      makevectors(self.angles);
      painEnt = spawn();
      if ( (painRnd < 0.330) ) {
         painEnt.origin = ((self.origin + (v_forward * 80.000)) - (v_up * 64));
      } else if ( (painRnd < 0.660) ) {
         painEnt.origin = ((self.origin + (v_right * 80.000)) - (v_up * 24.000));
      } else {
         painEnt.origin = (((self.origin + (v_forward * 64)) - (v_up * 48.000)) - (v_right * 48.000));
      }
      painEnt.target = self.target;
      painEnt.owner = self;
      painEnt.think = time_boom;
      painEnt.nextthink = ((time + 0.200) + (random () * 0.300));
   }

   if ( (self.health < 1000) ) {
      self.pain_finished = FALSE;
      self.th_pain = SUB_Null_pain;
      self.th_die = SUB_Null;
		SUB_UseTargets();
		if (self.spawnflags & 1) { // Don't end the level.
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
		} else {
			xpackEnding();
		}
   }
};

void() time_die = { time_pain(world, world, 0); }; // [FUNCTION]

void() item_time_machine = {
   precache_model ("progs/rogue/timemach.mdl");
   precache_model ("progs/rogue/timegib.mdl");
   setmodel(self,"progs/rogue/timemach.mdl");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   self.health = 1600.000;
   self.takedamage = DAMAGE_YES;
   self.view_ofs = '0.000 0.000 25.000';
   self.movetype = MOVETYPE_FLY;
   setsize (self,'-64.000 -64.000 -144.000','64.000 64.000 0.000');
   self.avelocity = '0.000 60.000 0.000';
   self.flags = (self.flags | FL_MONSTER);
   self.th_stand = SUB_Null;
   self.th_walk = SUB_Null;
   self.th_run = SUB_Null;
   self.th_die = time_die;
   self.th_missile = SUB_Null;
   self.th_pain = time_pain;
   theMachine = self;
};

void() item_time_core = {
   precache_model ("progs/rogue/timecore.mdl");
   setmodel(self,"progs/rogue/timecore.mdl");
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_FLY;
   self.avelocity = '60 60 60';
};