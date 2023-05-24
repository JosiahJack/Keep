void() fangel_block1;
void() fangel_flyframes_check;
void() fangel_hand1;
void() fangel_fly1;

float() fangel_check_incoming =  { // [FUNCTION]
	local entity item;
	local vector vec, realvec;
	local float dot;

   if ((range(self.enemy) <= RANGE_MELEE))  return(FALSE);

   if ( (infront(self.enemy) && ((self.enemy.attack_finished + 0.75000) > time)) ) {
      self.camera_time = 0.00000;
      self.think = fangel_block1;
      return(TRUE);
   }
   if ( (random() > ((0.40000 + (skill / 10.00000)) + (self.skin / 10.00000))) ) return (FALSE);

   item = findradius (self.origin, 384.00000);
   while ( item ) {
      if (item.owner.classname == "player" && IsMissile(item)) {
         vec = normalize ( ((self.origin - item.origin) + self.view_ofs));
         realvec = normalize ( item.velocity);
         dot = (vec * realvec);
         if ( (dot >= 0.40000) ) {
            self.camera_time = 0.00000;
            self.think = fangel_block1;
            return (TRUE);
         }
      }
      item = item.chain;
   }
   return (FALSE);
};

float FANGEL_STAGE_WAIT   =  0.00000;
float FANGEL_STAGE_FLY   =  1.00000;
float FANGEL_STAGE_FLOAT   =  2.00000;
float FANGEL_STAGE_SIDESTEP   =  3.00000;

void  ()fangel_check_wing =  { // [FUNCTION]
	local float chance, visib;

	visib = visible (self.enemy);
	if ( ((self.monster_stage == FANGEL_STAGE_FLY) && (random() < 0.50000))) visib = FALSE;
	if (visib) {
		enemy_range = range (self.enemy);
			if (time > self.attack_finished) {
				if (enemy_range != RANGE_FAR) {
					chance = 0.5;
					if (enemy_range == RANGE_NEAR) {
						chance = 0.20000;
					} else if (enemy_range == RANGE_MID) {
						if (self.th_melee)
							chance = 0.05000;
						else
							chance = 0.10000;
					}

					if (random() < chance) {
						if (random() < 0.5)
							self.th_melee();
						else
							self.th_missile();
						SUB_AttackFinished ( random(8.00000,0.00000));
						return;
					}
				}
			}
   } else {
      fangel_check_incoming();
   }
};

void() fangel_find_spot =  { // [FUNCTION]
	local float crj, radius, dist, oldz;
	local vector vec,newpos;

	crj = 0;
	while (crj < 50) {
		radius = 100 + (random() * 100);
		vec_x = random() * 360;
		vec_y = random() * 360;
		vec_z = 0;
		vec = normalize ( vec);
		vec = (self.enemy.origin + (vec * radius));
		vec_z = ((vec_z + 20 + (random() * 20)) + self.enemy.view_ofs_z);
		oldz = self.origin_z;
		self.origin_z = self.origin_z + vec_z;
		newpos = self.origin + vec;
		trace_fraction = Wyrm_WalkMove(vectoyaw(newpos - self.origin), dist); // Perform walkmove of testbox.
		self.origin_z = oldz;
		if (trace_fraction == 1) {
			dist = (self.origin_z - vec_z);
			if (dist < -20) self.ring_regen_time = (random() * 2);
			else if (dist > 20) self.ring_regen_time = -2 + (random() * 2);
			else self.ring_regen_time = -2 + (random() * 4);

			self.ring_flight_time = (time + (HX_FRAME_TIME * (15 + (random() * 10))));
			return;
		}
		crj += 1;
	}
	self.monster_stage = FANGEL_STAGE_FLOAT;
	self.monster_duration = 20 + (random() * 10);
};


void() fangel_init =  { // [FUNCTION]
	self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
	self.think = self.th_stand;
	self.nextthink = time + 0.1 + (random() * 0.5);
	self.count = 0.00000;
	self.monster_stage = FANGEL_STAGE_FLY;
	self.monster_duration = 0.00000;
	self.goalentity = self.enemy;
	self.monster_awake = TRUE;
	if (self.classname == "monster_fallen_angel_lord") {
		self.effects = EF_DIMLIGHT;
		//self.drawflags |= MLS_POWERMODE;
	}

	fangel_find_spot ();
};

void() fangel_wait =  { // [FUNCTION]
	self.nextthink = time + 0.15;
	self.th_stand = fangel_flyframes_check;
   if (FindTarget()) {
      fangel_init();
   } else {
      if ( (((random() * 100.00000) < 5.00000) && (self.t_width < time)) ) {
         self.t_width = (time + 7.00000);
         if (self.classname == "monster_fallen_angel_lord") {
            sound(self,CHAN_AUTO,"hexen2/fangel/ambi2.wav", (0.5 + (random() * 0.5)),ATTN_NORM);
         } else {
            sound(self,CHAN_AUTO,"hexen2/fangel/ambi1.wav", (0.5 + (random() * 0.5)),ATTN_NORM);
         }
      }
   }
};

void() fangel_sidestep =  { // [FUNCTION]
	local float retval, dist, chance;

   self.monster_duration -= 1.00000;
   dist = 1 + (random() * 3);
   retval = walkmove((self.angles_y + 90.00000), dist);
   if ( !retval ) {
      self.monster_stage = FANGEL_STAGE_FLY;
      fangel_find_spot ();
      self.think = fangel_flyframes_check;
      self.nextthink = time;
      return ;
   }
   dist = (self.origin_z - self.enemy.origin_z);
   if ( (dist < -20.00000) ) {
      self.ring_regen_time = random() * 2;
      self.ring_flight_time = (time + (HX_FRAME_TIME * (15 + (random() * 10))));
   } else {
      if ( (dist > 20.00000) ) {
         self.ring_regen_time = random() * -2;
         self.ring_flight_time = (time + (HX_FRAME_TIME * (15 + (random() * 10))));
      }
   }
   if ( (self.monster_duration <= 0.00000) ) {
      chance = random();
      if ( (chance < 0.33000) ) {
         self.monster_stage = FANGEL_STAGE_FLOAT;
         self.monster_duration = 10 + (random() * 20);
      } else {
         if ( (chance < 0.66000) ) {
            self.think = fangel_hand1;
         } else {
            self.think = fangel_fly1;
         }
      }
   }
};


void(float thrust) fangel_fly =  { // [FUNCTION]
	local float dist;

	self.ideal_yaw = vectoyaw ( (self.enemy.origin - self.origin));
	ChangeYaw();
	dist = (2 + (thrust * 4));
	if (vlen(self.origin - self.enemy.origin) < 20) {
		if (random() < 0.1) fangel_find_spot();
		else {
			self.monster_stage = FANGEL_STAGE_FLOAT;
			self.monster_duration = 10 + (random() * 20);
		}
		return;
	}

	if (!walkmove(self.angles_y,dist)) { fangel_find_spot(); return; }

	dist = (self.origin_z - self.enemy.origin_z);
	if ( (dist < -20.00000) ) {
		self.ring_regen_time = 2 + (random() * 2);
		self.ring_flight_time = (time + (HX_FRAME_TIME * (15 + (random() * 10))));
	} else {
			if ( (dist > 20.00000) ) {
				self.ring_regen_time = -2 + (random() * -2);
				self.ring_flight_time = (time + (HX_FRAME_TIME * (15 + (random() * 10))));
			}
	}

	if ( (self.ring_flight_time > time) ) walkmove(self.angles_y, self.ring_regen_time);
};

void() fangel_float =  { // [FUNCTION]
   self.monster_duration = (self.monster_duration - 1.00000);
   ai_face ();
   enemy_range = range (self.enemy);
   if ( ((enemy_range <= RANGE_NEAR) && (random() < 0.25000)) ) {
      self.monster_duration = 0.00000;
   } else {
      if (enemy_range <= RANGE_MELEE && random() < 0.90000) self.monster_duration = 0;
   }
   if ( (self.monster_duration <= 0.00000) ) {
      self.monster_stage = FANGEL_STAGE_FLY;
      fangel_find_spot ();
   }
};

float(float maxdist) check_z_move =  { // [FUNCTION]
	local float goaldist;
	local entity targ;

   if (self.enemy && visible(self.enemy)) targ = self.enemy;
   else {
      if (self.goalentity) targ = self.goalentity;
      else return FALSE;
   }

   if (targ.origin_z != self.absmin_z) {
      goaldist = (((targ.absmin_z + targ.absmax_z) * 0.5) - ((self.absmax_z + self.absmin_z) * 0.5));
      maxdist = fabs(maxdist);
      if (fabs(goaldist) > maxdist) {
         if (goaldist > 0) {
            goaldist = maxdist;
         } else {
            goaldist = maxdist * -1;
         }
      }
      if (!walkmove(self.angles_y, goaldist)) return FALSE;
   }
   return TRUE;
};

void(float thrust) fangel_move = { // [FUNCTION]
	check_z_move((thrust/2));
	if (self.monster_stage == FANGEL_STAGE_WAIT) { fangel_wait(); return; }
	if (self.monster_stage == FANGEL_STAGE_FLY) { fangel_fly(thrust); return; }
	if (self.monster_stage == FANGEL_STAGE_SIDESTEP) { fangel_sidestep(); return; } 
	if (self.monster_stage == FANGEL_STAGE_FLOAT) { fangel_float(); return; }
};

void() fangel_hand_fire = { // [FUNCTION]
   ai_face();
   sound(self,CHAN_WEAPON,"hexen2/fangel/hand.wav", 1.00000,ATTN_NORM);
   do_faSpell('10 -4 8',400);
   do_faSpell('10 -4 8',300);
};


void() fangel_wing_fire =  { // [FUNCTION]
   ai_face();
   sound(self,CHAN_WEAPON,"hexen2/fangel/wing.wav", 1.00000,ATTN_NORM);
   makevectors(self.angles);
   do_faBlade ( '8.00000 6.00000 4.00000', 360.00000, (v_right * 2.00000));
   do_faBlade ( '-8.00000 6.00000 4.00000', 360.00000, (v_right * -2.00000));

};

void() fangel_blockthink = { // [FUNCTION]
   ai_face();
   if (!VectorIsAllZeros(self.velocity)) self.velocity = self.velocity * 0.7; // Woah nelly, slow er on down there
   check_z_move(3);
   if (self.camera_time) self.camera_time -= 1; // hang on until 
   else {
      if (infront(self.enemy) && ((self.enemy.attack_finished + 0.75000) > time)) self.camera_time += 1;
   }
};

void() fangel_block1 = [0, fangel_block2] { fangel_blockthink(); };
void() fangel_block2 = [1, fangel_block3] { fangel_blockthink(); };
void() fangel_block3 = [2, fangel_block4] { fangel_blockthink(); };
void() fangel_block4 = [3, fangel_block5] { fangel_blockthink(); };
void() fangel_block5 = [4, fangel_block6] { fangel_blockthink(); };
void() fangel_block6 = [5, fangel_block7] { fangel_blockthink(); };
void() fangel_block7 = [6, fangel_block8] {
	fangel_blockthink();
	self.takedamage = DAMAGE_NO;
	self.resist_shells = self.resist_nails = 1;
	self.resist_rockets = self.resist_cells = 1;
	self.reflectlightning = TRUE;	// Reflect lightning strikes
	self.reflectplasma = TRUE;		// Reflect plasma projectiles
	self.reflectnails = TRUE;		// Reflect nail projectiles
	self.reflectaxe = TRUE;			// Prevent axe damage
};
void() fangel_block8 = [7, fangel_block9] { fangel_blockthink(); };
void() fangel_block9 = [8, fangel_block10] { fangel_blockthink(); };
void() fangel_block10 = [9, fangel_block11] { fangel_blockthink(); };
void() fangel_block11 = [10, fangel_block12] { fangel_blockthink(); };
void() fangel_block12 = [11, fangel_block13] { fangel_blockthink(); };
void() fangel_block13 = [12, fangel_block14] { fangel_blockthink(); };
void() fangel_block14 = [13, fangel_block15] { fangel_blockthink(); };
void() fangel_block15 = [14, fangel_block16] { fangel_blockthink(); };
void() fangel_block16 = [15, fangel_block17] { fangel_blockthink(); };
void() fangel_block17 = [16, fangel_block18] { fangel_blockthink(); };
void() fangel_block18 = [17, fangel_block19] { fangel_blockthink(); };
void() fangel_block19 = [18, fangel_block20] { fangel_blockthink(); };
void() fangel_block20 = [19, fangel_block21] { fangel_blockthink(); };
void() fangel_block21 = [20, fangel_flyframes_check] {
	local float chance;

	self.takedamage = DAMAGE_YES; // Let's get hurt again
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;
	self.reflectlightning = FALSE;	// Reflect lightning strikes
	self.reflectplasma = FALSE;		// Reflect plasma projectiles
	self.reflectnails = FALSE;		// Reflect nail projectiles
	self.reflectaxe = FALSE;			// Prevent axe damage
	chance = random();
	if (chance < 0.10000) self.think = fangel_flyframes_check;
	else if (chance < 0.60000) self.think = fangel_hand1;
	else self.think = fangel_fly1;
};

void() fangel_death6;

void() fangel_death_effects = { // [FUNCTION]
	traceline (self.origin, (self.origin - '0 0 250'), FALSE, self);
	if (vlen(self.origin - trace_endpos) < 128) particle(trace_endpos, '0 0 25', 225, 80); 
	//if ( ((self.frame == 27.00000) && !(self.flags & FL_ONGROUND)) ) {
		//self.think = fangel_death6;
		//self.velocity_z = -20.00000;
		//if ( (self.ring_water_time < time) && self.frame == 26) {
		//	self.frame = 27.00000;
		//}
	//}
};

void() fangel_death1 = [21, fangel_death2] { fangel_death_effects(); };
void() fangel_death2 = [22, fangel_death3] { fangel_death_effects();monster_check_gib(); };
void() fangel_death3 = [23, fangel_death4] { fangel_death_effects();monster_check_gib(); };
void() fangel_death4 = [24, fangel_death5] { fangel_death_effects(); };
void() fangel_death5 = [25, fangel_death6] { fangel_death_effects(); };
void() fangel_death6 = [26, fangel_death7] { fangel_death_effects(); self.ring_water_time = (time + 0.25000); };
void() fangel_death7 = [27, fangel_death8] { fangel_death_effects(); };
void() fangel_death8 = [28, fangel_death9] { fangel_death_effects(); };
void() fangel_death9 = [29, fangel_death10] { fangel_death_effects(); };
void() fangel_death10 = [30, fangel_death11] { fangel_death_effects(); };
void() fangel_death11 = [31, fangel_death12] { fangel_death_effects(); };
void() fangel_death12 = [32, fangel_death13] { fangel_death_effects(); };
void() fangel_death13 = [33, fangel_death14] { fangel_death_effects(); };
void() fangel_death14 = [34, fangel_death15] { fangel_death_effects(); };
void() fangel_death15 = [35, fangel_death16] { fangel_death_effects(); };
void() fangel_death16 = [36, fangel_death17] { fangel_death_effects(); };
void() fangel_death17 = [37, fangel_death18] { fangel_death_effects(); };
void() fangel_death18 = [38, fangel_death19] { fangel_death_effects(); };
void() fangel_death19 = [39, fangel_death20] { fangel_death_effects(); };
void() fangel_death20 = [40, fangel_death21] { fangel_death_effects(); };
void() fangel_death21 = [41, fangel_death22] { fangel_death_effects(); self.movetype = MOVETYPE_STEP; };
void() fangel_death22 = [42, fangel_death23] { fangel_death_effects(); };
void() fangel_death23 = [43, fangel_death24] { fangel_death_effects(); };
void() fangel_death24 = [44, fangel_death25] { fangel_death_effects(); };
void() fangel_death25 = [45, fangel_death26] { fangel_death_effects(); };
void() fangel_death26 = [46, fangel_death27] { fangel_death_effects(); };
void() fangel_death27 = [47, fangel_death28] { fangel_death_effects(); };
void() fangel_death28 = [48, fangel_death29] { fangel_death_effects(); };
void() fangel_death29 = [49, fangel_death30] { fangel_death_effects(); };
void() fangel_death30 = [50, fangel_death31] {
	fangel_death_effects();
	self.solid = SOLID_NOT;
	if ( (self.classname == "monster_fallen_angel") ) {
		sound(self,CHAN_WEAPON,"hexen2/fangel/death.wav", 1.00000,ATTN_NORM);
	} else {
		sound(self,CHAN_WEAPON,"hexen2/fangel/death2.wav", 1.00000,ATTN_NORM);
	}
};
void() fangel_death31 = [51, fangel_death32] { fangel_death_effects(); };
void() fangel_death32 = [52, fangel_death33] { fangel_death_effects(); };
void() fangel_death33 = [53, fangel_death34] { fangel_death_effects(); };
void() fangel_death34 = [54, fangel_death35] { fangel_death_effects(); };
void() fangel_death35 = [55, fangel_death36] { fangel_death_effects(); };
void() fangel_death36 = [56, fangel_death37] { fangel_death_effects(); };
void() fangel_death37 = [57, fangel_death38] { fangel_death_effects(); };
void() fangel_death38 = [58, fangel_death39] { fangel_death_effects(); };
void() fangel_death39 = [59, fangel_death40] { fangel_death_effects(); monster_death_postcheck(); };
void() fangel_death40 = [60, fangel_death40] { monster_deadbody_check(); };

void() fangel_death = { // [FUNCTION]
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	self.th_run = SUB_Null;
	self.idle_sound = SOUND_EMPTY;
	if (!self.gibbed) fangel_death1(); // regular death
};

void() fangel_flyforward1 = [113, fangel_flyforward2] { fangel_move(3 * 0);monster_idle_sound(); };
void() fangel_flyforward2 = [114, fangel_flyforward3] { fangel_move(3 * 0.1); };
void() fangel_flyforward3 = [115, fangel_flyforward4] { fangel_move(3 * 0.2); };
void() fangel_flyforward4 = [116, fangel_flyforward5] { fangel_move(3 * 0.3); };
void() fangel_flyforward5 = [117, fangel_flyforward6] { fangel_move(3 * 0.4); };
void() fangel_flyforward6 = [118, fangel_flyforward7] { fangel_move(3 * 0.5); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyforward7 = [119, fangel_flyforward8] { fangel_move(3 * 0.6); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyforward8 = [120, fangel_flyforward9] { fangel_move(3 * 0.7); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyforward9 = [121, fangel_flyforward10] { fangel_move(3 * 0.8); };
void() fangel_flyforward10 = [122, fangel_flyforward11] { fangel_move(3 * 0.9); };
void() fangel_flyforward11 = [123, fangel_flyforward12] { fangel_move(3 * 1); };
void() fangel_flyforward12 = [124, fangel_flyforward13] { fangel_move(3 * 0.9); };
void() fangel_flyforward13 = [125, fangel_flyforward14] { fangel_move(3 * 0.8); };
void() fangel_flyforward14 = [126, fangel_flyforward15] { fangel_move(3 * 0.7); };
void() fangel_flyforward15 = [127, fangel_flyforward16] { fangel_move(3 * 0.6); };
void() fangel_flyforward16 = [128, fangel_flyforward17] { fangel_move(3 * 0.5); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyforward17 = [129, fangel_flyforward18] { fangel_move(3 * 0.4); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyforward18 = [130, fangel_flyforward19] { fangel_move(3 * 0.3); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyforward19 = [131, fangel_flyforward20] { fangel_move(3 * 0.2); };
void() fangel_flyforward20 = [132, fangel_flyframes_check] { fangel_move(3 * 0.1); };

void() fangel_flyother1 = [61, fangel_flyother2] { fangel_move(3 * 0);monster_idle_sound(); };
void() fangel_flyother2 = [62, fangel_flyother3] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother3 = [63, fangel_flyother4] { fangel_move(3 * 0.2);monster_idle_sound(); };
void() fangel_flyother4 = [64, fangel_flyother5] { fangel_move(3 * 0.3);monster_idle_sound(); };
void() fangel_flyother5 = [65, fangel_flyother6] { fangel_move(3 * 0.4);monster_idle_sound(); };
void() fangel_flyother6 = [66, fangel_flyother7] { fangel_move(3 * 0.5);monster_idle_sound(); };
void() fangel_flyother7 = [67, fangel_flyother8] { fangel_move(3 * 0.6);monster_idle_sound(); };
void() fangel_flyother8 = [68, fangel_flyother9] { fangel_move(3 * 0.7);monster_idle_sound(); };
void() fangel_flyother9 = [69, fangel_flyother10] { fangel_move(3 * 0.8);monster_idle_sound(); };
void() fangel_flyother10 = [70, fangel_flyother11] { fangel_move(3 * 0.9);monster_idle_sound(); };
void() fangel_flyother11 = [71, fangel_flyother12] { fangel_move(3 * 1); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyother12 = [72, fangel_flyother13] { fangel_move(3 * 0.9); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyother13 = [73, fangel_flyother14] { fangel_move(3 * 0.8); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyother14 = [74, fangel_flyother15] { fangel_move(3 * 0.7);monster_idle_sound(); };
void() fangel_flyother15 = [75, fangel_flyother16] { fangel_move(3 * 0.6);monster_idle_sound(); };
void() fangel_flyother16 = [76, fangel_flyother17] { fangel_move(3 * 0.5);monster_idle_sound(); };
void() fangel_flyother17 = [77, fangel_flyother18] { fangel_move(3 * 0.4);monster_idle_sound(); };
void() fangel_flyother18 = [78, fangel_flyother19] { fangel_move(3 * 0.3);monster_idle_sound(); };
void() fangel_flyother19 = [79, fangel_flyother20] { fangel_move(3 * 0.2);monster_idle_sound(); };
void() fangel_flyother20 = [80, fangel_flyother21] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother21 = [81, fangel_flyother22] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother22 = [82, fangel_flyother23] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother23 = [83, fangel_flyother24] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother24 = [84, fangel_flyother25] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother25 = [85, fangel_flyother26] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother26 = [86, fangel_flyother27] { fangel_move(3 * 0.1); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyother27 = [87, fangel_flyother28] { fangel_move(3 * 0.1); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyother28 = [88, fangel_flyother29] { fangel_move(3 * 0.1); self.splash_time = self.frame; fangel_check_wing(); };
void() fangel_flyother29 = [89, fangel_flyother30] { fangel_move(3 * 0.1);monster_idle_sound(); };
void() fangel_flyother30 = [90, fangel_flyframes_check] { fangel_move(3 * 0.1);monster_idle_sound(); };

void() fangel_flyframes_check = { // [FUNCTION]
	fangel_check_incoming();
	if (self.enemy) self.idle_sound = "hexen2/fangel/fly.wav";
	else {
		if (self.classname == "monster_fallen_angel") self.idle_sound = "hexen2/fangel/ambi1.wav";
		else self.idle_sound = "hexen2/fangel/ambi2.wav";
	}

	if (self.monster_stage == FANGEL_STAGE_FLY) fangel_flyforward1();
	else fangel_flyother1();
};

void() fangel_hand1 = [91, fangel_hand2] { fangel_check_incoming(); ai_face(); };
void() fangel_hand2 = [92, fangel_hand3] { fangel_check_incoming(); ai_face(); };
void() fangel_hand3 = [93, fangel_hand4] { fangel_check_incoming(); ai_face(); };
void() fangel_hand4 = [94, fangel_hand5] { fangel_check_incoming(); ai_face(); };
void() fangel_hand5 = [95, fangel_hand6] { fangel_check_incoming(); ai_face(); };
void() fangel_hand6 = [96, fangel_hand7] { fangel_check_incoming(); ai_face(); };
void() fangel_hand7 = [97, fangel_hand8] { fangel_check_incoming(); ai_face(); };
void() fangel_hand8 = [98, fangel_hand9] { fangel_check_incoming(); ai_face(); };
void() fangel_hand9 = [99, fangel_hand10] { fangel_check_incoming(); ai_face(); };
void() fangel_hand10 = [100, fangel_hand11] { fangel_check_incoming(); ai_face(); };
void() fangel_hand11 = [101, fangel_hand12] { fangel_check_incoming(); ai_face(); };
void() fangel_hand12 = [102, fangel_hand13] { fangel_check_incoming(); fangel_hand_fire(); };
void() fangel_hand13 = [103, fangel_hand14] { fangel_check_incoming(); ai_face(); };
void() fangel_hand14 = [104, fangel_hand15] { fangel_check_incoming(); ai_face(); };
void() fangel_hand15 = [105, fangel_hand16] { fangel_check_incoming(); ai_face(); };
void() fangel_hand16 = [106, fangel_hand17] { fangel_check_incoming(); ai_face(); };
void() fangel_hand17 = [107, fangel_hand18] { fangel_check_incoming(); ai_face(); };
void() fangel_hand18 = [108, fangel_hand19] { fangel_check_incoming(); ai_face(); };
void() fangel_hand19 = [109, fangel_hand20] { fangel_check_incoming(); ai_face(); };
void() fangel_hand20 = [110, fangel_hand21] { fangel_check_incoming(); ai_face(); };
void() fangel_hand21 = [111, fangel_hand22] { fangel_check_incoming(); ai_face(); };
void() fangel_hand22 = [112, fangel_flyframes_check] {
	fangel_check_incoming();
	ai_face();
	if ((random() < 0.25000)) {
		self.monster_stage = FANGEL_STAGE_SIDESTEP;
		self.monster_duration = 20 + (random() * 20);
		fangel_find_spot();
	}
	self.frame = self.splash_time;
};

void() fangel_paincheck = { // [FUNCTION]
	local float chance;

	fangel_check_incoming();
	chance = random();
	if (chance < 0.33) self.think = fangel_flyframes_check;
	else if (chance < 0.66) self.think = fangel_hand1;
	else self.think = fangel_fly1;

	self.frame = self.splash_time;
};

void() fangel_painframes1 = [133, fangel_painframes2] { fangel_paincheck();sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM); };
void() fangel_painframes2 = [134, fangel_painframes3] { fangel_paincheck(); };
void() fangel_painframes3 = [135, fangel_painframes4] { fangel_paincheck(); };
void() fangel_painframes4 = [136, fangel_painframes5] { fangel_paincheck(); };
void() fangel_painframes5 = [137, fangel_painframes6] { fangel_paincheck(); };
void() fangel_painframes6 = [138, fangel_painframes7] { fangel_paincheck(); };
void() fangel_painframes7 = [139, fangel_painframes8] { fangel_paincheck(); };
void() fangel_painframes8 = [140, fangel_painframes9] { fangel_paincheck(); };
void() fangel_painframes9 = [141, fangel_painframes10] { fangel_paincheck(); };
void() fangel_painframes10 = [142, fangel_painframes11] { fangel_paincheck(); };
void() fangel_painframes11 = [143, fangel_painframes12] { fangel_paincheck(); };
void() fangel_painframes12 = [144, fangel_painframes1] { fangel_fly1(); };

void() fangel_fly1 = [185, fangel_fly2] { ai_face(); };
void() fangel_fly2 = [186, fangel_fly3] { ai_face(); };
void() fangel_fly3 = [187, fangel_fly4] { ai_face(); };
void() fangel_fly4 = [188, fangel_fly5] { ai_face(); };
void() fangel_fly5 = [189, fangel_fly6] { ai_face(); };
void() fangel_fly6 = [190, fangel_fly7] { ai_face(); };
void() fangel_fly7 = [191, fangel_fly8] { ai_face(); };
void() fangel_fly8 = [192, fangel_fly9] { ai_face(); };
void() fangel_fly9 = [193, fangel_fly10] { ai_face(); };
void() fangel_fly10 = [194, fangel_fly11] { ai_face(); };
void() fangel_fly11 = [195, fangel_fly12] { ai_face(); };
void() fangel_fly12 = [196, fangel_fly13] { ai_face(); };
void() fangel_fly13 = [197, fangel_fly14] { ai_face(); };
void() fangel_fly14 = [198, fangel_fly15] { ai_face(); };
void() fangel_fly15 = [199, fangel_fly16] { ai_face(); };
void() fangel_fly16 = [200, fangel_fly17] { ai_face(); };
void() fangel_fly17 = [201, fangel_fly18] { ai_face(); };
void() fangel_fly18 = [202, fangel_fly19] { ai_face(); };
void() fangel_fly19 = [203, fangel_fly20] { ai_face(); };
void() fangel_fly20 = [204, fangel_fly21] {
	ai_face();
	if (self.classname == "monster_fallen_angel") fangel_wing_fire();
	else {
		sound(self,CHAN_WEAPON,"weapons/lstart.wav",1,ATTN_NORM);
		gaunt_lightning(0);
	}
};
void() fangel_fly21 = [205, fangel_fly22] {
	ai_face();
	if (self.classname == "monster_fallen_angel") fangel_wing_fire();
	else gaunt_lightning(1);
};
void() fangel_fly22 = [206, fangel_fly23] { ai_face();
	ai_face();
	if (self.classname == "monster_fallen_angel") fangel_wing_fire();
	else gaunt_lightning(0);
};
void() fangel_fly23 = [207, fangel_fly24] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(1); }};
void() fangel_fly24 = [208, fangel_fly25] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(0); }};
void() fangel_fly25 = [209, fangel_fly26] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(1); }};
void() fangel_fly26 = [210, fangel_fly27] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(0); }};
void() fangel_fly27 = [211, fangel_fly28] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(1); }};
void() fangel_fly28 = [212, fangel_fly29] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(0); }};
void() fangel_fly29 = [213, fangel_fly30] { ai_face(); if (self.classname == "monster_fallen_angel_lord") { gaunt_lightning(1); }};
void() fangel_fly30 = [214, fangel_flyframes_check] {
	ai_face();
	if ( (random() < 0.25000) ) {
		self.monster_stage = FANGEL_STAGE_SIDESTEP;
		self.monster_duration = 20 + (random() * 20);
		fangel_find_spot();
	}
	self.frame = self.splash_time;
};


void(entity inflictor, entity attacker, float damage) fangel_pain =  { // [FUNCTION]
   if ( ((random(self.health) > damage) || (self.pain_finished > time))) return;

   self.pain_finished = ((time + 1.00000) + self.skin);
   if ( (self.health < 50.00000) ) {
		if (!(self.classname == "monster_fallen_angel_lord")) self.alpha = 1;
		self.effects = 0;
      //self.drawflags ^= (DRF_TRANSLUCENT | MLS_POWERMODE);
   }
   if ( (((self.frame >= 71.00000) && (self.frame <= 73.00000)) || ((self.frame >= 86.00000) && (self.frame <= 88.00000))) ) {
      if ( (self.classname == "monster_fallen_angel") ) {
         sound(self,CHAN_WEAPON,"hexen2/fangel/pain.wav", 1.00000,ATTN_NORM);
      } else {
         sound(self,CHAN_WEAPON,"hexen2/fangel/pain2.wav", 1.00000,ATTN_NORM);
      }
      self.splash_time = self.frame;
      fangel_painframes1();
   }
};

void() fangel_attack = { // [FUNCTION]
	if (random() < 0.5)	fangel_hand1();
	else				fangel_fly1();
};

void() monster_fallen_angel_precache = {
	precache_model("progs/hexen2/fangel.mdl");
	precache_model("progs/hexen2/faspell.mdl");
	precache_model("progs/hexen2/fablade.mdl");
	precache_model("progs/hexen2/h_fangel.mdl");
	precache_sound("hexen2/fangel/fly.wav");
	precache_sound("hexen2/fangel/deflect.wav");
	precache_sound("hexen2/fangel/hand.wav");
	precache_sound("hexen2/fangel/wing.wav");
	precache_sound("hexen2/weapons/expsmall.wav");
	precache_sound("hexen2/weapons/explode.wav");
	precache_sound("hexen2/fangel/ambi1.wav");
	precache_sound("hexen2/fangel/ambi2.wav");
	precache_sound("hexen2/fangel/death.wav");
	precache_sound("hexen2/fangel/pain.wav");
	precache_sound("hexen2/fangel/death2.wav");
	precache_sound("hexen2/fangel/pain2.wav");
};

void() monster_fallen_angel =  {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.monster_stage = FANGEL_STAGE_WAIT;
	self.mdl = "progs/hexen2/fangel.mdl";
	self.headmdl = "progs/hexen2/h_fangel.mdl";		// Large head
	self.pain_sound = "hexen2/fangel/pain.wav";
	self.gibhealth = -40;
	if ((self.classname == "monster_fallen_angel") ) {
		self.idle_sound = "hexen2/fangel/ambi1.wav";
		if (self.health < 1) self.health = 300; // was 250 in Hexen2
		if (!self.classtype) self.classtype = CT_MONFANGEL;
		if (self.deathstring == "")  self.deathstring = " was felled by the Fallen Angel\n";
   } else {
		self.idle_sound = "hexen2/fangel/ambi2.wav";
		self.skin = 1;
		if (self.health < 1) self.health = 500;
		if (!self.classtype) self.classtype = CT_MONFANGELLORD;
		if (self.deathstring == "")  self.deathstring = " was decimated by a Fallen Angel Lord!\n";
		self.alpha = 0.5;
		self.pain_sound = "hexen2/fangel/pain2.wav";
	}

	self.solid = SOLID_NOT;					// No interaction with world
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	self.attack_offset = '0 0 8';		// Acid spit start location
	self.th_stand = fangel_wait;
	self.th_walk = fangel_flyframes_check;
	self.th_run = fangel_flyframes_check;
	self.th_pain = fangel_pain;
	self.th_die = fangel_death;
	self.th_missile = fangel_attack;
	self.th_melee = fangel_fly1;
	self.ideal_yaw = (self.angles * '0.00000 1.00000 0.00000');
	self.yaw_speed = 15;
	self.view_ofs = '0.00000 0.00000 -5.00000';
	if (!self.classgroup) self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	monster_start();
};

void() monster_fallen_angel_lord = { monster_fallen_angel(); };