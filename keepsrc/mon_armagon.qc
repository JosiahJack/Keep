//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake by Patrick Martin, Hexen2
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 1
// Function count: 167
//
// Implements: Armagon
//
// Description:
// Armagon is a half-biological, half-machine creature whom you face in the
// last level. Better get yourself a lot of ammo.
//
// Structurally, he resembles a huge robot war machine, armed with rapid-fire
// missile launchers. Don't get too close because he'll switch to lasers for a
// little precision target practice on you.
//
// Get even closer and he'll use a repulsor shockwave to knock you back.
//=============================================================================

void() T_ArmaMissileTouch = {
	local float damg;

	if (other == self.owner) return;
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

	damg = (50.000 + (random () * 20.000));
	if (other.health) T_Damage(other,self,self.owner,damg,DAMARMOR);
	T_RadiusDamage(self,self.owner,40.000,other,DAMAGEALL);
	self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);
	BecomeExplosion();
};

void(float ofs, float turn) armagon_launch_missile = {
   local vector src;
   local vector vec;
   local vector targ;
   local vector ang;
   local entity missile;
   local float dist;

   ang = self.angles;
   ang_y = (ang_y + self.fixangle);
   if ( (turn == TRUE) ) {
      ang_y = (ang_y + 165.000);
   } else {
      if ( (turn == FL_SWIM) )
         ang_y = (ang_y - 165.000);
   }
   makevectors(ang);
   src = (((self.origin + '0.000 0.000 66.000') + (v_right * ofs)) + (v_forward * 84.000));
   targ = (self.enemy.origin + self.enemy.view_ofs);
   if ( (skill != FALSE) ) {
      dist = vlen ((targ - src));
      targ = (targ + (self.enemy.velocity * (dist / 1000.000)));
   }
   vec = (targ - src);
   vec = normalize (vec);
   dist = (vec * v_forward);
   if ( (dist < self.worldtype) )
      vec = v_forward;

   self.effects = (self.effects | EF_MUZZLEFLASH);
   sound(self,CHAN_WEAPON,"weapons/sgun1.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn();
   missile.owner = self;
	missile.classgroup = CG_PROJALL;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "missile";
   missile.velocity = (vec * 1000.000);
   missile.angles = vectoangles (vec);
   missile.touch = T_ArmaMissileTouch;
   missile.nextthink = (time + MOVETYPE_FLY);
   missile.think = SUB_Remove;
   setmodel(missile,"progs/missile.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin(missile,src);
};

void(float ofs) armagon_launch_laser = {
   local vector src;
   local vector vec;
   local vector targ;
   local float dist;
   local vector ang;

   ang = self.angles;
   ang_y = (ang_y + self.fixangle);
   makevectors(ang);
   src = (((self.origin + '0.000 0.000 66.000') + (v_right * ofs)) + (v_forward * 84.000));
   targ = (self.enemy.origin + self.enemy.view_ofs);
   if ( (skill != FALSE) ) {
      dist = vlen ((targ - src));
      targ = (targ + (self.enemy.velocity * (dist / 1000.000)));
   }
   vec = (targ - src);
   vec = normalize (vec);
   dist = (vec * v_forward);
   if ( (dist < self.worldtype) )
      vec = v_forward;

   self.effects = (self.effects | EF_MUZZLEFLASH);
   HIP_LaunchLaser (src,vec,FALSE);
};

void(float angdelta, float delta) armagon_turn = {
   if ( (fabs (angdelta) < MOVETYPE_BOUNCE) ) {
      self.fixangle = delta;
   } else {
      if ( (angdelta > MOVETYPE_FLY) ) {
         self.fixangle = (self.fixangle + MOVETYPE_FLYMISSILE);
      } else {
         if ( (angdelta < CONTENT_LAVA) ) {
            self.fixangle = (self.fixangle - MOVETYPE_FLYMISSILE);
         } else {
            self.fixangle = delta;
         }
      }
   }
};

void() armagon_overleft1;
void() armagon_overright1;

float(float delta) armagon_yaw_delta = {
	if (delta >  180) delta = (delta - 360.000);
	if (delta < -180) delta = (delta + 360.000);
	return delta;
};

void() armagon_think = {
   local float delta, angdelta, r;

   setorigin(self.trigger_field,self.origin);
   self.trigger_field.angles = self.angles;
   self.trigger_field.frame = self.frame;
   self.trigger_field.angles_y = (self.trigger_field.angles_y + self.fixangle);
   ai_setidealyaw();
   self.cnt = FALSE;
   delta = armagon_yaw_delta(self.ideal_yaw - self.angles_y);
   if (fabs(delta) > 90) {
      delta = 0;
      self.cnt = TRUE;
   }
   angdelta = (delta - self.fixangle);
   armagon_turn (angdelta,delta);
   if (self.health < 1) return;

   monster_idle_sound();
};

void() armagon_walkthink = {
   local float delta, angdelta;
   local entity client;
   local float r;

   setorigin(self.trigger_field,self.origin);
   self.trigger_field.angles = self.angles;
   self.trigger_field.frame = self.frame;
   self.trigger_field.angles_y = (self.trigger_field.angles_y + self.fixangle);
   ChangeYaw();
   delta = FALSE;
   self.cnt = FALSE;
   if (delta > 180) delta = delta - 360;
   if (delta < -180) delta = delta + 360;
   if ( (fabs (delta) > 90) ) {
      delta = FALSE;
      self.cnt = TRUE;
   }
   angdelta = (delta - self.fixangle);
   armagon_turn(angdelta,delta);
   if (self.health < 1) return;

   monster_idle_sound();
   FindTarget();
};

void() armagon_overleft_think = {
   local float delta, angdelta;

   ChangeYaw();
   walkmove(self.angles_y,14.000);
   setorigin(self.trigger_field,self.origin);
   self.trigger_field.angles = self.angles;
   self.trigger_field.frame = self.frame;
   self.trigger_field.angles_y = (self.trigger_field.angles_y + self.fixangle);
   if (self.count == 0) {
      enemy_yaw = vectoyaw ((self.enemy.origin - self.origin));
      self.ideal_yaw = enemy_yaw;
	  delta = armagon_yaw_delta((self.ideal_yaw - self.angles_y) - 165.000);
      angdelta = (delta - self.fixangle);
   } else {
      if ( (self.count == TRUE) ) {
         armagon_launch_missile (40.000,TRUE);
         return ;
      } else {
         delta = FALSE;
         angdelta = (delta - self.fixangle);
      }
   }
   armagon_turn (angdelta,delta);
};

void() armagon_overright_think = {
   local float delta;
   local float angdelta;

   ChangeYaw();
   walkmove (self.angles_y,14.000);
   setorigin(self.trigger_field,self.origin);
   self.trigger_field.angles = self.angles;
   self.trigger_field.frame = self.frame;
   self.trigger_field.angles_y = (self.trigger_field.angles_y + self.fixangle);
   if ( (self.count == FALSE) ) {
      enemy_yaw = vectoyaw ((self.enemy.origin - self.origin));
      self.ideal_yaw = enemy_yaw;
      delta = armagon_yaw_delta((self.ideal_yaw - self.angles_y) + 165.000);
      angdelta = (delta - self.fixangle);
   } else {
      if (self.count == TRUE) {
         armagon_launch_missile(-40.000,FL_SWIM);
         return;
      } else {
         delta = 0;
         angdelta = (delta - self.fixangle);
      }
   }
   armagon_turn(angdelta,delta);
};

void() armagon_stand_attack;

void() armagon_stand1 = [ 64.000, armagon_stand2 ] { ai_stand(); armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand2 = [ 65.000, armagon_stand3 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand3 = [ 66.000, armagon_stand4 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand4 = [ 67.000, armagon_stand5 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand5 = [ 68.000, armagon_stand6 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand6 = [ 69.000, armagon_stand7 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand7 = [ 70.000, armagon_stand8 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand8 = [ 71.000, armagon_stand9 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand9 = [ 72.000, armagon_stand10 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand10 = [ 73.000, armagon_stand11 ] { ai_stand(); armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand11 = [ 74.000, armagon_stand12 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand12 = [ 75.000, armagon_stand13 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand13 = [ 76.000, armagon_stand14 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand14 = [ 77.000, armagon_stand15 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand15 = [ 78.000, armagon_stand16 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand16 = [ 79.000, armagon_stand17 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand17 = [ 80.000, armagon_stand18 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand18 = [ 81.000, armagon_stand19 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand19 = [ 82.000, armagon_stand20 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_stand20 = [ 83.000, armagon_stand1 ] { ai_stand(); armagon_think(); self.nextthink = (time + 0.200); };

void() armagon_walk1 = [ 0.000, armagon_walk2 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk2 = [ 1.000, armagon_walk3 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk3 = [ 2.000, armagon_walk4 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk4 = [ 3.000, armagon_walk5 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk5 = [ 4.000, armagon_walk6 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk6 = [ 5.000, armagon_walk7 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk7 = [ 6.000, armagon_walk8 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk8 = [ 7.000, armagon_walk9 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk9 = [ 8.000, armagon_walk10 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk10 = [ 9.000, armagon_walk11 ] { movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk11 = [ 10.000, armagon_walk12 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); movetogoal(14.000); armagon_walkthink(); };
void() armagon_walk12 = [ 11.000, armagon_walk1 ] { movetogoal(14.000); armagon_walkthink(); };

void() armagon_run1 = [ 0.000, armagon_run2 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run2 = [ 1.000, armagon_run3 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run3 = [ 2.000, armagon_run4 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run4 = [ 3.000, armagon_run5 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run5 = [ 4.000, armagon_run6 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run6 = [ 5.000, armagon_run7 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run7 = [ 6.000, armagon_run8 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run8 = [ 7.000, armagon_run9 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run9 = [ 8.000, armagon_run10 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run10 = [ 9.000, armagon_run11 ] { ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run11 = [ 10.000, armagon_run12 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); ChangeYaw(); ai_run(14.000); armagon_think(); };
void() armagon_run12 = [ 11.000, armagon_run1 ] {
   local float delta;

   ChangeYaw();
   ai_run(14.000);
   armagon_think();
   if ( ((self.cnt == TRUE) && (time > self.attack_finished)) ) {
      delta = armagon_yaw_delta(self.ideal_yaw - self.angles_y);
      if ( (delta > FALSE) ) {
         self.think = armagon_overleft1;
      } else {
         self.think = armagon_overright1;
      }
      return;
   }
   if ( (self.lefty == TRUE) ) {
      self.lefty = FALSE;
      self.think = self.th_missile;
   }
};

void() armagon_watk1 = [ 12.000, armagon_watk2 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk2 = [ 13.000, armagon_watk3 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk3 = [ 14.000, armagon_watk4 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk4 = [ 15.000, armagon_watk5 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk5 = [ 16.000, armagon_watk6 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk6 = [ 17.000, armagon_watk7 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); armagon_launch_missile (40.000,FALSE); };
void() armagon_watk7 = [ 18.000, armagon_watk8 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk8 = [ 19.000, armagon_watk9 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk9 = [ 20.000, armagon_watk10 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk10 = [ 21.000, armagon_watk11 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_watk11 = [ 22.000, armagon_watk13 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); armagon_launch_missile (-40.000,FALSE); };

void() armagon_watk13 = [ 23.000, armagon_run1 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); SUB_AttackFinished (TRUE); };

void() armagon_wlaseratk1 = [ 12.000, armagon_wlaseratk2 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk2 = [ 13.000, armagon_wlaseratk3 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk3 = [ 14.000, armagon_wlaseratk4 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk4 = [ 15.000, armagon_wlaseratk5 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk5 = [ 16.000, armagon_wlaseratk6 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk6 = [ 17.000, armagon_wlaseratk7 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); armagon_launch_laser (40.000); };
void() armagon_wlaseratk7 = [ 18.000, armagon_wlaseratk8 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk8 = [ 19.000, armagon_wlaseratk9 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk9 = [ 20.000, armagon_wlaseratk10 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk10 = [ 21.000, armagon_wlaseratk11 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); };
void() armagon_wlaseratk11 = [ 22.000, armagon_wlaseratk13 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); armagon_launch_laser (-40.000); };
void() armagon_wlaseratk13 = [ 23.000, armagon_run1 ] { ChangeYaw(); walkmove (self.angles_y,14.000); armagon_think(); SUB_AttackFinished (TRUE); };

void() armagon_overleft1 = [ 25.000, armagon_overleft2 ] { self.count = FALSE; armagon_overleft_think(); };
void() armagon_overleft2 = [ 26.000, armagon_overleft3 ] { armagon_overleft_think(); };
void() armagon_overleft3 = [ 27.000, armagon_overleft4 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); armagon_overleft_think(); };
void() armagon_overleft4 = [ 28.000, armagon_overleft5 ] { armagon_overleft_think(); };
void() armagon_overleft5 = [ 29.000, armagon_overleft6 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); armagon_overleft_think(); };
void() armagon_overleft6 = [ 30.000, armagon_overleft7 ] { armagon_overleft_think(); };
void() armagon_overleft7 = [ 31.000, armagon_overleft8 ] { armagon_overleft_think(); };
void() armagon_overleft8 = [ 32.000, armagon_overleft9 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); armagon_overleft_think(); };
void() armagon_overleft9 = [ 33.000, armagon_overleft10 ] { armagon_overleft_think(); };
void() armagon_overleft10 = [ 34.000, armagon_overleft11 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); armagon_overleft_think(); };
void() armagon_overleft11 = [ 35.000, armagon_overleft12 ] { self.count = TRUE; armagon_overleft_think(); };
void() armagon_overleft12 = [ 36.000, armagon_overleft13 ] { self.count = FL_SWIM; armagon_overleft_think(); };
void() armagon_overleft13 = [ 37.000, armagon_overleft14 ] { armagon_overleft_think(); };
void() armagon_overleft14 = [ 38.000, armagon_overleft15 ] { armagon_overleft_think(); };
void() armagon_overleft15 = [ 39.000, armagon_run1 ] { armagon_overleft_think(); SUB_AttackFinished (TRUE); };

void() armagon_overright1 = [ 40.000, armagon_overright2 ] { self.count = FALSE; armagon_overright_think(); };
void() armagon_overright2 = [ 41.000, armagon_overright3 ] { armagon_overright_think(); };
void() armagon_overright3 = [ 42.000, armagon_overright4 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); armagon_overright_think(); };
void() armagon_overright4 = [ 43.000, armagon_overright5 ] { armagon_overright_think(); };
void() armagon_overright5 = [ 44.000, armagon_overright6 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); self.count = TRUE; armagon_overright_think(); };
void() armagon_overright6 = [ 45.000, armagon_overright7 ] { self.count = FL_SWIM; armagon_overright_think(); };
void() armagon_overright7 = [ 46.000, armagon_overright8 ] { armagon_overright_think(); };
void() armagon_overright8 = [ 47.000, armagon_overright9 ] { sound(self,MOVETYPE_PUSH,"hipnotic/armagon/servo.wav",SERVO_VOLUME,ATTN_ARMAGON); armagon_overright_think(); };
void() armagon_overright9 = [ 48.000, armagon_overright10 ] { armagon_overright_think(); };
void() armagon_overright10 = [ 49.000, armagon_overright11 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); armagon_overright_think(); };
void() armagon_overright11 = [ 50.000, armagon_overright12 ] { armagon_overright_think(); };
void() armagon_overright12 = [ 51.000, armagon_run1 ] { armagon_overright_think(); SUB_AttackFinished (TRUE); };

void() armagon_plant1 = [ 64.000, armagon_plant1 ] { armagon_stand_attack(); armagon_think(); };

void() armagon_stop1 = [ 84.000, armagon_stop2 ] { armagon_think(); };
void() armagon_stop2 = [ 85.000, armagon_plant1 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); armagon_think(); };

void() armagon_satk1 = [ 52.000, armagon_satk2 ] { armagon_think(); };
void() armagon_satk2 = [ 53.000, armagon_satk3 ] { armagon_think(); };
void() armagon_satk3 = [ 54.000, armagon_satk4 ] { armagon_think(); };
void() armagon_satk4 = [ 55.000, armagon_satk5 ] { armagon_think(); };
void() armagon_satk5 = [ 56.000, armagon_satk6 ] { armagon_think(); };
void() armagon_satk6 = [ 57.000, armagon_satk7 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); armagon_think(); };
void() armagon_satk7 = [ 58.000, armagon_satk8 ] { armagon_think(); };
void() armagon_satk8 = [ 59.000, armagon_satk9 ] { armagon_think(); };
void() armagon_satk9 = [ 60.000, armagon_satk10 ] { armagon_think(); armagon_launch_missile (40.000,FALSE); armagon_launch_missile (-40.000,FALSE); };
void() armagon_satk10 = [ 61.000, armagon_satk11 ] { armagon_think(); };
void() armagon_satk11 = [ 60.000, armagon_satk12 ] { armagon_think(); armagon_launch_missile (40.000,FALSE); armagon_launch_missile (-40.000,FALSE); };
void() armagon_satk12 = [ 61.000, armagon_satk13 ] { armagon_think(); };
void() armagon_satk13 = [ 60.000, armagon_satk14 ] { armagon_think(); armagon_launch_missile (40.000,FALSE); armagon_launch_missile (-40.000,FALSE); };
void() armagon_satk14 = [ 61.000, armagon_satk15 ] { armagon_think(); };
void() armagon_satk15 = [ 62.000, armagon_satk16 ] { armagon_think(); };
void() armagon_satk16 = [ 63.000, armagon_plant1 ] { armagon_think(); SUB_AttackFinished (0.300); };

void() armagon_slaser1 = [ 52.000, armagon_slaser2 ] { armagon_think(); };
void() armagon_slaser2 = [ 53.000, armagon_slaser3 ] { armagon_think(); };
void() armagon_slaser3 = [ 54.000, armagon_slaser4 ] { armagon_think(); };
void() armagon_slaser4 = [ 55.000, armagon_slaser5 ] { armagon_think(); };
void() armagon_slaser5 = [ 56.000, armagon_slaser6 ] { armagon_think(); };
void() armagon_slaser6 = [ 57.000, armagon_slaser7 ] { sound(self,MOVETYPE_TOSS,"hipnotic/armagon/footfall.wav",TRUE,ATTN_ARMAGON); armagon_think(); };
void() armagon_slaser7 = [ 58.000, armagon_slaser8 ] { armagon_think(); };
void() armagon_slaser8 = [ 59.000, armagon_slaser9 ] { armagon_think(); };
void() armagon_slaser9 = [ 60.000, armagon_slaser10 ] { armagon_think(); armagon_launch_laser (40.000); armagon_launch_laser (-40.000); };
void() armagon_slaser10 = [ 61.000, armagon_slaser11 ] { armagon_think(); };
void() armagon_slaser11 = [ 60.000, armagon_slaser12 ] { armagon_think(); armagon_launch_laser (40.000); armagon_launch_laser (-40.000); };
void() armagon_slaser12 = [ 61.000, armagon_slaser13 ] { armagon_think(); };
void() armagon_slaser13 = [ 60.000, armagon_slaser14 ] { armagon_think(); armagon_launch_laser (40.000); armagon_launch_laser (-40.000); };
void() armagon_slaser14 = [ 61.000, armagon_slaser15 ] { armagon_think(); };
void() armagon_slaser15 = [ 60.000, armagon_slaser16 ] { armagon_think(); armagon_launch_laser (40.000); armagon_launch_laser (-40.000); };
void() armagon_slaser16 = [ 61.000, armagon_slaser17 ] { armagon_think(); };
void() armagon_slaser17 = [ 60.000, armagon_slaser18 ] { armagon_think(); armagon_launch_laser (40.000); armagon_launch_laser (-40.000); };
void() armagon_slaser18 = [ 61.000, armagon_slaser19 ] { armagon_think(); };
void() armagon_slaser19 = [ 62.000, armagon_slaser20 ] { armagon_think(); };
void() armagon_slaser20 = [ 63.000, armagon_plant1 ] { armagon_think(); SUB_AttackFinished (0.300); };

void() armagon_body_explode1;

void() armagon_die1 = [ 84.000, armagon_die2 ] { armagon_think(); DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die2 = [ 85.000, armagon_die3 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_die3 = [ 86.000, armagon_die4 ] { armagon_think();DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die4 = [ 87.000, armagon_die5 ] { armagon_think(); multi_explosion ((self.origin + '0.000 0.000 48.000'),48.000,10,6,0.300,0.300); sound(self,CHAN_AUTO,"hipnotic/armagon/death.wav",TRUE,ATTN_NONE); self.nextthink = (time + 0.200); };
void() armagon_die5 = [ 88.000, armagon_die6 ] { armagon_think();DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die6 = [ 89.000, armagon_die7 ] { armagon_think();DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die7 = [ 90.000, armagon_die8 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_die8 = [ 91.000, armagon_die9 ] { armagon_think();DropCoin(1); self.nextthink = (time + FL_SWIM); };
void() armagon_die9 = [ 92.000, armagon_die10 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_die10 = [ 93.000, armagon_die11 ] { armagon_think();DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die11 = [ 94.000, armagon_die12 ] { armagon_think(); self.nextthink = (time + 0.200); };
void() armagon_die12 = [ 95.000, armagon_die13 ] { armagon_think();DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die13 = [ 96.000, armagon_die14 ] { armagon_think();DropCoin(1); DropCoin(1); DropCoin(1); self.nextthink = (time + 0.200); };
void() armagon_die14 = [ 97.000, armagon_die14 ] {
	armagon_think();
	multi_explosion ((self.origin + '0.000 0.000 80.000'),20.000,MOVETYPE_BOUNCE,MOVETYPE_WALK,0.100,0.500);
	self.nextthink = CONTENT_EMPTY;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.gibbed = TRUE;
	self.solid = SOLID_NOT;
	setsize (self,VEC_HULL2_MIN,'32.000 32.000 32.000');
	self.flags = FALSE;
	self.gorging = TRUE;
	self.wait = (time + MOVETYPE_FLY);
	self.trigger_field.nextthink = CONTENT_EMPTY;
	self.movetype = MOVETYPE_NONE;
	self.trigger_field.takedamage = DAMAGE_NO;
	self.trigger_field.gibbed = TRUE;
	self.trigger_field.solid = SOLID_NOT;
	self.trigger_field.think = armagon_body_explode1;
	self.trigger_field.nextthink = (time + 0.100);
	self.trigger_field.gorging = TRUE;
	DropCoin(1);
};

void() armagon_body_explode2 = { // [FUNCTION]
   sound(self,CHAN_AUTO,"drake/misc/longexpl.wav",TRUE,ATTN_ARMAGON);
   self.think = armagon_body_explode2;
   self.movetype = MOVETYPE_NONE;
   setmodel(self,"progs/drake/s_explod.spr");
   self.solid = SOLID_NOT;
   self.nextthink = (time + 0.100);
   s_explode1();
};

void() armagon_body_explode1 = { // [FUNCTION]
   self.think = armagon_body_explode1;
   self.nextthink = (time + 0.100);
   if ( (self.cnt == FALSE) )
      self.count = FALSE;

   if ( (self.cnt < 25.000) ) {
      if ( (self.cnt > self.count) ) {
         ThrowGib(1,1);
         self.count = (self.cnt + TRUE);
      }
      self.cnt = (self.cnt + TRUE);
   } else {
      self.cnt = FALSE;
      self.think = armagon_body_explode2;
   }
};

void(entity inflictor, entity attacker, float damage) armagon_pain = {
   if ( (self.health <= FALSE) ) return ;
   if ( (damage < 25.000) ) return ;
   if ( (self.pain_finished > time) ) return ;

   self.pain_finished = (time + FL_SWIM);
   sound(self,CHAN_VOICE,"hipnotic/armagon/pain.wav",TRUE,ATTN_NORM);
};

void() armagon_missile_attack = { // [FUNCTION]
   if ( (random () < 0.500) ) armagon_watk1();
   else armagon_wlaseratk1();
};

void() armagon_repulse_attack = { // [FUNCTION]
   local entity head;
   local vector dir;

   armagon_think();
   if ( (self.state == FALSE) ) {
      SUB_AttackFinished (0.500);
      sound(self,CHAN_BODY,"hipnotic/armagon/repel.wav",TRUE,ATTN_NORM);
      self.state = TRUE;
      return ;
   } else {
      if ( (self.state == TRUE) ) {
         head = findradius (self.origin,300.000);
         while (head) {
            if (head.flags & FL_CLIENT) {
               if (head.health > 0) {
                  if (!Invisible(head)) { // This checks states only.
                     if (visible(head)) { // This does traceline checks.
                        dir = (head.origin - (self.origin - '0.000 0.000 24.000'));
                        dir = normalize (dir);
                        head.velocity = (head.velocity + (dir * 1500));
                     }
                  }
               }
            }
            head = head.chain;
         }
         T_RadiusDamage(self,self,60.000,self,DAMAGEALL);
         self.state = FALSE;
         SUB_AttackFinished (0.100);
      }
   }
};

void() armagon_stand_attack = { // [FUNCTION]
   local vector spot1;
   local vector spot2;

   spot1 = (self.origin + self.view_ofs);
   spot2 = (self.enemy.origin + self.enemy.view_ofs);
   traceline(spot1,spot2,FALSE,self);
   if ( (trace_ent != self.enemy) ) { armagon_run1(); return; }
   if ( (trace_inopen && trace_inwater) ) { armagon_run1(); return; }
   if ( (time < self.attack_finished) ) return ;
   if ( ((vlen ((spot2 - spot1)) < 200) && (self.enemy.classname == "player")) ) { armagon_repulse_attack(); return; }
   self.state = FALSE;
   if ( (vlen ((spot2 - spot1)) > 450.000) ) { armagon_run1(); return; }
   if ( (random () < 0.500) )
      armagon_satk1();
   else
      armagon_slaser1();
   if ( (self.cnt == TRUE) ) { armagon_run1(); return; }
};

void() monster_armagon_precache = { // [FUNCTION]
   precache_model ("progs/hipnotic/armabody.mdl");
   precache_model ("progs/hipnotic/armalegs.mdl");
   precache_model ("progs/missile.mdl");
   precache_sound("hipnotic/armagon/footfall.wav");
   precache_sound("hipnotic/armagon/servo.wav");
   precache_sound("hipnotic/armagon/death.wav");
   precache_sound("hipnotic/armagon/pain.wav");
   precache_sound("hipnotic/armagon/repel.wav");
   precache_sound("hipnotic/armagon/sight.wav");
   precache_sound("hipnotic/armagon/idle1.wav");
   precache_sound("hipnotic/armagon/idle2.wav");
   precache_sound("hipnotic/armagon/idle3.wav");
   precache_sound("hipnotic/armagon/idle4.wav");
   precache_sound("enforcer/enfstop.wav");
   precache_sound("hipnotic/weapons/laserg.wav");
   precache_sound("hipnotic/weapons/laserric.wav");
   precache_sound("drake/misc/longexpl.wav");
   precache_sound("drake/misc/shortexp.wav");
};

void() monster_armagon = {
	local entity body;

	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.lefty = FALSE;
	body = spawn();
	body.origin = self.origin;
	body.origin = (body.origin - '0.000 0.000 64.000');
	self.solid = SOLID_SLIDEBOX;
	self.fixangle = FALSE;
	self.movetype = MOVETYPE_STEP;
	body.solid = SOLID_NOT;
	body.movetype = MOVETYPE_STEP;
	self.trigger_field = body;
	body.trigger_field = self;
	setmodel(body,"progs/hipnotic/armabody.mdl");
	self.mdl = "progs/hipnotic/armalegs.mdl";
	setmodel(self,self.mdl);
	setsize(self,'-48.000 -48.000 -24.000','48.000 48.000 84.000');
	self.bboxtype = BBOX_ARMAGON;
	setorigin(self,self.origin);
	setorigin(body,body.origin);
	self.yaw_speed = 9;
	if (self.health < 1) self.health = 3000.000;
	self.worldtype = 0.850;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to 0 to be consistent.
	self.resist_cells = 0.5;
	self.resist_plasma = 0.5;
	self.gibhealth = -1000000;
	self.gibbed = FALSE;
	self.gibondeath = FALSE; // Special death, that in fact does gib him in the end.
	self.state = FALSE;
	self.super_time = FALSE;
	self.endtime = FALSE;
	self.th_stand = armagon_stand1;
	self.th_walk = armagon_walk1;
	self.th_run = armagon_run1;
	self.th_die = armagon_die1;
	self.th_missile = armagon_missile_attack;
	self.th_melee = armagon_stop1;
	self.th_pain = armagon_pain;
   self.classtype = CT_MONARMAGON;
	self.classmove = MON_MOVEWALK;
	if (self.deathstring == "") self.deathstring = " was outgunned by Armagon\n";
	monster_start();
};