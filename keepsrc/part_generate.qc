//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Entity count: 0
// Function count: 23
//
// Implements: Particle System Emitters and Generators
//
// Description:
// Helper functions for emitting particles using the particle system.
//
// killtarget can easily destroy connections between entities
// Some particle emitter types rely on the source entity connection
// Quake maintains all entities in one list with a number as reference
// If an entity is deleted the entity number can be given to any new
// entity spawned. This is not a reference to the original entity but
// it is just a location in a list. 
// To get around this problem any entity that spawns a particle
// emitter will generate a unique number which the emitter will
// keep track of and compare to make sure the connection is valid.
//
// PRIMARY SPRITE/MODE PARTICLE EMITTER FUNCTION
// - Designed for Fitz type engines (retro pixel goodness)
//
// DPP particle functions
// - float(string effectname) particleeffectnum
// - void(entity ent,float effectnum,vector start,vector end) trailparticles
// - void(float effectnum,vector org, vector vel,float howmany) pointparticles
//
// DP volume particle system parameters
// vector mins     : minimum corner of the cube
// vector maxs     : maximum corner of the cube
// vector velocity : velocity of particles
// short count     : number of particles
// byte color      : 8bit palette color
//=============================================================================

void() emit_particle;

float() emit_checksource = { // [FUNCTION]
	if (self.entno_unique != self.pemit_source.entno_unique) self.part_style = PARTICLE_STYLE_EMPTY; // If the connection is broken, destroy particle emitter
	if (self.part_style == PARTICLE_STYLE_EMPTY || ((self.part_style != PARTICLE_STYLE_RESPAWN) && (self.pemit_source.estate & ESTATE_BLOCK))) self.state = STATE_OFF; // Exception - respawning particle are never blocked!
	if (self.state == STATE_OFF) { self.estate = ESTATE_OFF; return TRUE; } // Final check to see if emitter is active or not?
	return FALSE;
};

// Generate particles (DP Engine).  DP particles are designed to go at origin, not origin+offset
void() emitdpp_particle = { // [FUNCTION]
	if (emit_checksource()) return; // Check source entity and style type are valid

	// Double check DP particles active? (quickload issues).  If not active, revert back to Fitz/particle system.
	if (!ext_dppart) {
		self.think = emit_particle;
		self.nextthink = time + random();
		extend_particlechain(); // Check if particle banks need extending
		return;
	}
	
	// Easier solution for finding particle direction (velocity): subtract target from source and normalize (range 0-1).  Previous version was using vectoangles (was broken).
	if (self.pemit_target) self.dpp_vel = normalize(self.pemit_target.origin - self.pemit_source.origin);

	// Check for volume particle spawning
	if (!CheckZeroVector(self.part_vol)) {
		if (self.pemit_source.bsporigin) self.pos1 = self.pemit_source.origin + bmodel_origin(self.pemit_source); // Check if owner is a Bmodel? (different origin location)
		else self.pos1 = self.pemit_source.origin;

		self.pos1_x = self.pos1_x + ( (random()*(self.part_vol_x*2)) - self.part_vol_x);
		self.pos1_y = self.pos1_y + ( (random()*(self.part_vol_y*2)) - self.part_vol_y);
		self.pos1_z = self.pos1_z + ( (random()*(self.part_vol_z*2)) - self.part_vol_z);
	} else self.pos1 = self.pemit_source.origin;
	
	self.pos1 = self.pos1 + self.pemit_source.part_ofs; // Make sure any offset is added to source origin
	pointparticles(particleeffectnum(self.dpp_name), self.pos1, self.dpp_vel, 1);
	self.think = emitdpp_particle;
	self.nextthink = time + self.dpp_wait + (random() * self.dpp_rnd);
};

// Custom setup for Floor Circle particle emitter
void() emitdpp_fcircle = { // [FUNCTION]
	local float loop_cnt;
	local vector circle_vec, circle_org;

	if (emit_checksource()) return; // Check source entity and style type are valid
	if (!ext_dppart) { self.think = emit_particle; self.nextthink = time + random(); return; } // If not DP, revert back to Fitz/particle system

	loop_cnt = 4;
	while(loop_cnt > 0) {
		loop_cnt = loop_cnt - 1;
		circle_vec = '0 0 0';
		circle_vec_y = circle_vec_y + rint(random()*360);
		makevectors(circle_vec);
		circle_org = self.pemit_source.origin + v_forward * self.part_vol_x;
		pointparticles(particleeffectnum(self.dpp_name), circle_org, self.dpp_vel, 1); // Generate particles (DP Engine) around circumference
	}

	// Draw bright pulse ring texture over the floor pattern.  Only draw this if the circle is the original shape.
	if (self.part_vol_x == 56) pointparticles(particleeffectnum(DPP_FCIRCLE_RING), self.pemit_source.origin, '0 0 0', 1);
	self.think = emitdpp_fcircle;
	self.nextthink = time + self.dpp_wait + (random() * self.dpp_rnd);
};

// Particle weather system

// splash animation (runs at 20fps)
void() pe_splash1 = [0, pe_splash2] {self.nextthink = time+0.05;}; // [FUNCTION]
void() pe_splash2 = [1, pe_splash3] {self.nextthink = time+0.05;}; // [FUNCTION]
void() pe_splash3 = [2, pe_splash4] {self.nextthink = time+0.05;}; // [FUNCTION]
void() pe_splash4 = [3, pe_splash5] {self.nextthink = time+0.05;}; // [FUNCTION]
void() pe_splash5 = [4, pe_splash6] {self.nextthink = time+0.05;}; // [FUNCTION]
void() pe_splash6 = [5, finish_particle] {self.nextthink = time+0.05;}; // [FUNCTION]

void() emitepp_weather = { // [FUNCTION]
	// Check for variable wind direction
	if (self.attack_speed < time && self.speed > 0) {
		self.attack_speed = time + self.speed + (random()*self.speed);
		self.pos3_x = crandom() * self.pos2_x;
		self.pos3_y = crandom() * self.pos2_y;
	}

	self.t_width = self.pos1_x + random()*self.pos1_z; // Work out random colour range
	self.t_length = self.count * 0.75 + ((random() * 0.5) * self.count); // Vary the count by +/- 25% of total
	self.pos3_z = self.pos2_z * 0.75 + ((random() * 0.5) * self.pos2_z); // Vary the wind speed by +/- 25% of total
	
	// Double check if engine weather systems are enabled
	if (query_weathersystem() == FALSE) {
		self.think = emitepp_weather; 
		self.nextthink = time + 2; // Wait for any change, slow timer
	} else {
		if (self.spawnflags & PARTICLE_WEATHER_SNOW) te_particlesnow(self.bbmins, self.bbmaxs, self.pos3, self.t_length, self.t_width);
		else te_particlerain(self.bbmins, self.bbmaxs, self.pos3, self.t_length, self.t_width);
		self.think = emitepp_weather;
		self.nextthink = time + 0.1;
	}
};

void() emit_weather_think = { // [FUNCTION]
	if (self.origin_z < (self.pos2_z-4)) {
		self.movetype = MOVETYPE_NONE;
		setorigin(self, self.pos2 + '0 0 12');
		setmodel(self, self.headmdl);
		self.velocity = '0 0 0';
		pe_splash1();
	} else {
		self.think = emit_weather_think;
		self.nextthink = time + 0.1;
	}
};

void() emit_weather = { // [FUNCTION]
	if (emit_checksource()) return; // Check source entity and style type are valid
	if (!ext_dppart) return;

	self.think = emit_weather; // Setup next particle (loop)
	if (!self.enemy) self.enemy = find(world, classname, "player"); // Make sure player distance check is available
	if (!(self.enemy.flags & FL_CLIENT)) { self.nextthink = time + 0.1; return; }

	// Is the particle emitter close to the player?
	if (range_distance(self.enemy, TRUE) < self.wakeup_dist) {		
		self.nextthink = time + self.spawn_base + (random()*self.spawn_rand); // Normal think timer, player within range

		// Is there anymore particles left to spawn? 
		if (self.pemit_tcount < self.part_limit) {
			part = fetch_particle();
			// Only preceed if a particle has been returned
			if (part.classtype == CT_PARTICLE) {
				part.owner = self;
				self.pemit_tcount = self.pemit_tcount + 1;
				part.movetype = self.part_movetype;
				setmodel(part, self.spr_name1);
				part.headmdl = self.spr_name2;
				setsize(part, VEC_ORIGIN, VEC_ORIGIN);
				part.velocity_x = self.part_velrand_x * random();
				part.velocity_y = self.part_velrand_y * random();
				part.velocity_z = self.part_velrand_z * random();
				part.velocity = part.velocity + self.part_vel;
				part.velocity_z = -part.velocity_z;
				part.pos1_x = self.pos1_x * random(); // Pick a random point across the top of volume
				part.pos1_y = self.pos1_y * random();
				part.pos1_z = 0;
				part.pos1 = part.pos1 + self.pos2;
				setorigin(part, part.pos1);
				traceline (part.pos1, part.pos1 + '0 0 -4096', TRUE, self); // trace down to find travel distance
				part.pos2 = trace_endpos;

				if (trace_inwater) self.height = 8; // Find out if any liquid in the way
				else self.count = 0;

				// Binary divide the distance to find water surface
				while (self.height > 0) {
					if (fabs(part.pos2_z-part.pos1_z) < 8) self.height = 0; // Break out early from loop if <8 from water surface
					part.pos3 = part.pos1; // Calculate midway point between origin and endtrace
					part.pos3_z = part.pos1_z + ((part.pos2_z - part.pos1_z)*0.5);
					traceline (part.pos1, part.pos3, TRUE, self); // Test which half has water and shift top/bottom positions
					if (trace_inwater) part.pos2 = part.pos3;
					else part.pos1 = part.pos3;
					
					self.height = self.height - 1; // Only loop a limited amount of times
				}
				part.think = emit_weather_think; // Check travel distance
				part.nextthink = time + 0.1;
				
			}
		}
	} else self.nextthink = time + self.wakeup_timer + (random()*self.spawn_rand); // If no player within range of the emitter, slower think timer
};

void() emit_particle = { // [FUNCTION]
	local float randno;
	local vector angle_vec;

	if (emit_checksource()) return; // Check source entity and style type are valid

	self.think = emit_particle; // Setup next particle (loop)
	if (!self.enemy) self.enemy = find(world, classname, "player"); // make sure player distance check is available
	if (!(self.enemy.flags & FL_CLIENT)) { self.nextthink = time + 0.1; return; }
	if (range_distance(self.enemy, TRUE) >= self.wakeup_dist) { self.nextthink = time + self.wakeup_timer + (random()*self.spawn_rand); return; } // If no player within range of the emitter, slower think timer.
	
	self.nextthink = time + self.spawn_base + (random()*self.spawn_rand); // Normal think timer, player within range
	if (self.pemit_tcount >= self.part_limit) return; // No more particles left to spawn.
	
	part = fetch_particle();
	if (part.classtype != CT_PARTICLE) return; // Out of particles.

	part.owner = self;
	self.pemit_tcount = self.pemit_tcount + 1;
	part.movetype = self.part_movetype;		// 6=Gravity, 8=Noclip, 10=Bounce
	randno = random(); // Select particle type
	
	// Setup SPRITE particle (string and frame no)
	if (randno < 0.3) setmodel(part, self.spr_name1);
	else if (randno < 0.6) setmodel(part, self.spr_name2);
	else setmodel(part, self.spr_name3);

	// Sprite Frame style (1=LIGHT, 2=DARK, 3=ALL)
	if (self.spr_frame == 1) part.frame = rint(random()*1.4);
	else if (self.spr_frame == 2) part.frame = rint(random()*2);
	else part.frame = rint(random()*3.4);
	
	setsize(part, VEC_ORIGIN, VEC_ORIGIN); // Zero size and world interaction.

	// STARTING POINT (Particle origin - uses MANGLE key)
	// 0 = Randomly picked from a volume (X/Y/Z) - DEFAULT
	// 1 = Circular motion (radius/segment controlled)
	// 2 = Randomly pick a point on the circle circumference
	// 3 = Spiral in/out from circle circumference
	// 5 = Explosion from central point
	if (self.part_veltype == PARTICLE_ORIGIN_CIRCLE) {
		// Circular motion around emitter (self)
		angle_vec = '0 0 0';
		angle_vec_y = angle_vec_y + self.circular_angle;
		makevectors(angle_vec);
		part.origin = self.origin + v_forward * self.part_vol_x;
		setorigin (part, part.origin + self.part_ofs);
		self.circular_angle = anglemod(self.circular_angle + self.part_vol_y);
	} else if (self.part_veltype == PARTICLE_ORIGIN_RANDCIRCLE) {
		// Random circumference point around emitter (self)
		angle_vec = '0 0 0';
		angle_vec_y = angle_vec_y + rint(random()*360);
		makevectors(angle_vec);
		part.origin = self.origin + v_forward * self.part_vol_x;
		setorigin (part, part.origin + self.part_ofs);
	} else if (self.part_veltype == PARTICLE_ORIGIN_SPIRAL) {
		// Spiral in/out around circumference point (self)
		angle_vec = '0 0 0';
		angle_vec_y = angle_vec_y + self.circular_angle;
		makevectors(angle_vec);
		if (self.lefty == 0) self.lefty = 1;
		self.part_vol_z = self.part_vol_z + self.lefty;
		if (self.part_vol_z == 0) self.lefty = 1; 
		if (self.part_vol_z == self.part_vol_x) self.lefty = -1;
		part.origin = self.origin + v_forward * self.part_vol_z;
		setorigin (part, part.origin + self.part_ofs);
		self.circular_angle = anglemod(self.circular_angle + self.part_vol_y);
	} else if (self.part_veltype == PARTICLE_ORIGIN_CENTER) {
		// Explosion from central point (self)
		part.origin = self.pemit_source.origin + self.part_ofs; // Always calculate from the center of original object
		setorigin (part, part.origin);
	} else {
		// Random volume point around particle (part)
		if (self.pemit_source.bsporigin) { // Check if owner is a Bmodel? (different origin location)
			part.pos1 = self.pemit_source.origin + bmodel_origin(self.pemit_source);
			part.origin = part.pos1;
			
			// Double check the bmodel volume has been setup correctly (not zero). Particle emitters can be started before bmodel has initialized.
			if (CheckZeroVector(self.part_vol)) self.part_vol = self.pemit_source.size * 0.5;
		} else part.origin = self.pemit_source.origin + self.part_ofs;

		part.origin_x = part.origin_x + ( (random()*(self.part_vol_x*2)) - self.part_vol_x);
		part.origin_y = part.origin_y + ( (random()*(self.part_vol_y*2)) - self.part_vol_y);
		part.origin_z = part.origin_z + ( (random()*(self.part_vol_z*2)) - self.part_vol_z);
		setorigin (part, part.origin);
	}
	
	// VELOCITY (Particle speed/direction - uses ANGLES key)
	// Initially setup linear velocity
	// if PART_VELRAND defined create extra wobble/randomness
	// if oldenemy (noise4) specified go towards specific target entity
	if (self.pemit_target) {
		// Check if finish target is a Bmodel? (different origin location)
		if (self.pemit_target.bsporigin) {
			part.pos2 = self.pemit_target.origin + bmodel_origin(self.pemit_target);
			angle_vec = part.pos2 - part.origin;
		} else angle_vec = self.pemit_target.origin - part.origin;		// Target -> Self

		angle_vec = normalize(angle_vec);									// vector unit scale
		part.velocity = angle_vec * ( (random()*self.part_vel_x) + self.part_vel_x);

		// Add extra wobble if part_velrand defined
		if (self.part_velrand_x > 0 || self.part_velrand_y > 0 || self.part_velrand_z > 0) {
			part.velocity_x = part.velocity_x + (random()*(self.part_velrand_x*2)) - self.part_velrand_x;
			part.velocity_y = part.velocity_y + (random()*(self.part_velrand_y*2)) - self.part_velrand_y;
			part.velocity_z = part.velocity_z + (random()*(self.part_velrand_z*2)) - self.part_velrand_z;
		}
	} else if (self.part_veltype == PARTICLE_ORIGIN_CENTER) {
		// Explosion from central point (self)
		part.velocity = '0 0 0';
		part.velocity_x = self.part_vel_x - (random()*(self.part_vel_x*2));
		part.velocity_y = self.part_vel_y - (random()*(self.part_vel_y*2));
		part.velocity_z = self.part_vel_z - (random()*(self.part_vel_z*2));
		part.velocity = part.velocity + self.part_velbase; // Setup BASE + CRANDOM (+/-) velocity
	} else {					
		// Setup BASE + RANDOM (+) velocity
		part.velocity = '0 0 0';
		part.velocity_x = random(self.part_vel_x) + self.part_vel_x;
		part.velocity_y = random(self.part_vel_y) + self.part_vel_y;
		part.velocity_z = random(self.part_vel_z) + self.part_vel_z;
		part.velocity = part.velocity + self.part_velbase;

		// Add extra wobble if part_velrand defined
		if (self.part_velrand_x > 0 || self.part_velrand_y > 0 || self.part_velrand_z > 0) {
			part.velocity_x = part.velocity_x + (random()*(self.part_velrand_x*2)) - self.part_velrand_x;
			part.velocity_y = part.velocity_y + (random()*(self.part_velrand_y*2)) - self.part_velrand_y;
			part.velocity_z = part.velocity_z + (random()*(self.part_velrand_z*2)) - self.part_velrand_z;
		}
	}				

	// ROTATION (Y axis only - uses PART_VELROT key)
	if (self.part_velrot) { // Random Y axis rotation.
		part.angles = self.enemy.angles; // Rotate the same way first
		part.avelocity = '0 0 0';
		part.avelocity_y = self.part_velrot + (random()*self.part_velrot);
	}

	part.nextthink = time + random() + self.part_life; // Setup time of death!  Call it.
	part.think = finish_particle;
};

// Pick a particle sprite based on type.
void(entity part_ent, float part_style) particle_style = { // [FUNCTION]
	local float ring_rand;
	
	ring_rand = random();
	if (ring_rand < 0.4) {
		if (part_style & PARTICLE_BURST_YELLOW) setmodel (part_ent, PART_DOTSML_GOLD);
		else if (part_style & PARTICLE_BURST_GREEN) setmodel (part_ent, PART_DOTSML_LGREEN);
		else if (part_style & PARTICLE_BURST_RED) setmodel (part_ent, PART_DOTSML_GREY);
		else if (part_style & PARTICLE_BURST_BLUE) setmodel (part_ent, PART_DOTSML_BLUE);
		else if (part_style & PARTICLE_BURST_DBLUE) setmodel (part_ent, PART_DOTSML_DBLUE);
		else if (part_style & PARTICLE_BURST_PURPLE) setmodel (part_ent, PART_DOTSML_PURP);
		else if (part_style & PARTICLE_BURST_FIRE) setmodel (part_ent, PART_TORCH1);
		else setmodel (part_ent, PART_DOTSML_WHITE);
	} else if (ring_rand < 0.8) {
		if (part_style & PARTICLE_BURST_YELLOW) setmodel (part_ent, PART_DOTSML_YELLOW);
		else if (part_style & PARTICLE_BURST_GREEN) setmodel (part_ent, PART_DOTSML_GREEN);
		else if (part_style & PARTICLE_BURST_RED) setmodel (part_ent, PART_DOTSML_RED);
		else if (part_style & PARTICLE_BURST_BLUE) setmodel (part_ent, PART_DOTSML_GREY);
		else if (part_style & PARTICLE_BURST_DBLUE) setmodel (part_ent, PART_DOTSML_DBLUE);
		else if (part_style & PARTICLE_BURST_PURPLE) setmodel (part_ent, PART_DOTSML_GREY);
		else if (part_style & PARTICLE_BURST_FIRE) setmodel (part_ent, PART_DOTSML_GOLD);
		else setmodel (part_ent, PART_DOTSML_GREY);
	} else {
		if (part_style & PARTICLE_BURST_YELLOW) setmodel (part_ent, PART_DOTMED_YELLOW);
		else if (part_style & PARTICLE_BURST_GREEN) setmodel (part_ent, PART_DOTMED_GREEN);
		else if (part_style & PARTICLE_BURST_RED) setmodel (part_ent, PART_DOTMED_RED);
		else if (part_style & PARTICLE_BURST_BLUE) setmodel (part_ent, PART_DOTMED_BLUE);
		else if (part_style & PARTICLE_BURST_DBLUE) setmodel (part_ent, PART_DOTMED_DBLUE);
		else if (part_style & PARTICLE_BURST_PURPLE) setmodel (part_ent, PART_DOTMED_PURP);
		else if (part_style & PARTICLE_BURST_FIRE) setmodel (part_ent, PART_DOTMED_GREY);
		else setmodel (part_ent, PART_DOTMED_GREY);
	}
	part.frame = rint(random()*3); // Random frame (sprite)
};

// Particle ring explosion (used for respawn function)
// ring_org		: center of particle ring
// ring_dir		: direction for particles to move
// ring_rdir	: random wobble for particle direction
// ring_rad		: starting point offset (grow/shrink ring size)
// ring_qty		: circle division (how many points around circumference)
// ring_time	: lifespan of particle (time + random()*time)
// ring_style	: particle ring colour (1=yellow, 2=green, 3=red, 4=white)
void(vector ring_org, vector ring_dir, vector ring_rdir, float ring_rad, float ring_qty, float ring_time, float ring_style) particle_ring = { // [FUNCTION]
	local vector circle_vec, circle_org;
	local float ring_loop, ring_angle;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?

	// Setup DP particle style based on supplied style
	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
		if (ring_style & PARTICLE_BURST_YELLOW) dpp_string = DPP_RINGPARTY;
		else if (ring_style & PARTICLE_BURST_GREEN) dpp_string = DPP_RINGPARTG;
		else if (ring_style & PARTICLE_BURST_RED) dpp_string = DPP_RINGPARTR;
		else if (ring_style & PARTICLE_BURST_BLUE) dpp_string = DPP_RINGPARTB;
		else if (ring_style & PARTICLE_BURST_DBLUE) dpp_string = DPP_RINGPARTDB;
		else if (ring_style & PARTICLE_BURST_PURPLE) dpp_string = DPP_RINGPARTP;
		else dpp_string = DPP_RINGPARTW;
	} else {
		if ((part_total+ring_qty) >= part_max - 1) return; // Are there any free particles? Check for maximim amount of particles available
	}

	ring_loop = 0;
	ring_angle = 360 / ring_qty;
	while (ring_loop < ring_qty) {
		// Is the DP particle system active?
		if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
			// Work out point on circle circumference using the v_forward vector with incremental angles	
			circle_vec = '0 0 0';
			circle_vec_y = circle_vec_y + (ring_angle * ring_loop);
			makevectors(circle_vec);
			circle_org = ring_org + (v_forward * ring_rad);
			pointparticles(particleeffectnum(dpp_string), circle_org, '0 0 0', 1); // Generate particles (DP Engine)
		} else {
			part = fetch_particle();
			// Only preceed if a particle has been returned
			if (part.classtype == CT_PARTICLE) {
				part.owner = self;
				part.movetype = MOVETYPE_NOCLIP;
				particle_style(part, ring_style); // Setup correct particle type (sprite/model) based on ring colour
		
				// Work out point on circle circumference using the v_forward vector with incremental angles	
				circle_vec = '0 0 0';
				circle_vec_y = circle_vec_y + (ring_angle * ring_loop);
				makevectors(circle_vec);
				part.origin = ring_org + (v_forward * ring_rad);
				setorigin (part, part.origin);	
				setsize(part, VEC_ORIGIN, VEC_ORIGIN); // Zero size and world interaction
				
				// Setup particle velocity with random element
				part.velocity_x = ring_dir_x + ( (random()*(ring_rdir_x*2)) - ring_rdir_x);
				part.velocity_y = ring_dir_y + ( (random()*(ring_rdir_y*2)) - ring_rdir_y);
				part.velocity_z = ring_dir_z + (random()*ring_rdir_z);
				part.nextthink = time + (random()*ring_time) + ring_time; // Setup time of death!
				part.think = finish_particle;
			}
		}
		ring_loop = ring_loop + 1; // Keep on loopin!
	}
};

void(entity part_ent, vector part_org, float expl_style) explosion_style = { // [FUNCTION]
	local vector org_volume, expl_vel;
	
	if (expl_style & PARTICLE_BURST_SHOCKWAVE) {
		// Ogre hammer is a flat floor explosion with particles bouncing
		org_volume = '0 0 0';
		org_volume_x = crandom()*16;
		org_volume_y = crandom()*16;
		part_ent.origin = part_org + org_volume;
		setorigin (part_ent, part_ent.origin);

		// Random chance of dead particles that are stationary on the ground
		if (random() < 0.3) {
			part_ent.velocity = '0 0 0';
			if (random() < 0.5) setmodel (part_ent, PART_DOTSML_GREY);
			else setmodel (part_ent, PART_DOTMED_GREY);
			part_ent.frame = rint(random()*3);
		} else {
			// Particles that explode up and out
			expl_vel_x = crandom() * 75;
			expl_vel_y = crandom() * 75;
			expl_vel_z = 150 + random() * 150;
			part_ent.velocity = expl_vel;
			part_ent.avelocity = vecrand(100,200,FALSE);
			part_ent.movetype = MOVETYPE_TOSS;
			part_ent.gravity = 0.75;
			part_ent.flags = 0;
		}
	} else if (expl_style & PARTICLE_BURST_SKULLUP) {
		// Skull wizard teleporting = particle burst upwards
		part_ent.origin_x = part_org_x + crandom()*8;
		part_ent.origin_y = part_org_y + crandom()*8;
		// If skull wizard dead, spawn particles from robes on floor
		// Otherwise the particles are being used for a teleport
		if (self.health < 0) part_ent.origin_z = part_org_z - MON_VIEWOFS;
		else part_ent.origin_z = part_org_z - crandom()*MON_VIEWOFS;
		setorigin (part_ent, part_ent.origin);
		part_ent.velocity_x = crandom()*8;
		part_ent.velocity_y = crandom()*8;
		part_ent.velocity_z = random()*25;
		part_ent.avelocity = vecrand(100,200,FALSE);
		part_ent.movetype = MOVETYPE_FLY;
		part_ent.flags = 0;
	} else if (expl_style & PARTICLE_BURST_LOSTUP) {
		// Lost souls fire particles upwards
		part_ent.origin_x = part_org_x + crandom()*4;
		part_ent.origin_y = part_org_y + crandom()*4;
		part_ent.origin_z = part_org_z;
		setorigin (part_ent, part_ent.origin);
		part_ent.velocity_x = crandom()*4;
		part_ent.velocity_y = crandom()*4;
		part_ent.velocity_z = random()*10;
		part_ent.avelocity = vecrand(100,200,FALSE);
		part_ent.movetype = MOVETYPE_FLY;
		part_ent.flags = 0;
	} else if (expl_style & PARTICLE_BURST_MINOTAUR) {
		// Minotaur finished plasma attack
		part_ent.origin_x = part_org_x + crandom()*8;
		part_ent.origin_y = part_org_y + crandom()*8;
		part_ent.origin_z = part_org_z - crandom()*MON_VIEWOFS;
		setorigin (part_ent, part_ent.origin);
		part_ent.velocity_x = crandom()*8;
		part_ent.velocity_y = crandom()*8;
		part_ent.velocity_z = random()*35;
		part_ent.avelocity = vecrand(100,200,FALSE);
		part_ent.movetype = MOVETYPE_FLY;
		part_ent.flags = 0;
	} else if (expl_style & PARTICLE_BURST_UPWARD) {
		// Generic particle burst drifting upward
		part_ent.origin_x = part_org_x + crandom()*24;
		part_ent.origin_y = part_org_y + crandom()*24;
		part_ent.origin_z = part_org_z + random()*64;
		setorigin (part_ent, part_ent.origin);
		part_ent.velocity_x = crandom()*16;
		part_ent.velocity_y = crandom()*16;
		part_ent.velocity_z = 8+random()*16;
		part_ent.movetype = MOVETYPE_FLY;
		part_ent.flags = 0;
	} else {
		// default = explode outwards in all directions
		part_ent.origin = part_org;
		setorigin (part_ent, part_ent.origin);
		part_ent.velocity = vecrand(0,16,TRUE);
		part_ent.avelocity = vecrand(100,200,FALSE);
		part_ent.movetype = MOVETYPE_FLY;
		part_ent.flags = 0;
	}
};	

 // Particle Implode
 // e_org		: center of particle implode
 // e_qty		: quantity of particle burst
 // e_speed	: Particle speed towards center
 // e_dist		: circumference of implosion circle
 // p_style	: sprite style (check function particle_style above)
void(vector e_org, float e_qty, float e_speed, float e_dist, float p_style) particle_implode = { // [FUNCTION]
	local float e_loop, e_len, e_traveltime;
	local vector e_dir, e_vdestdelta, e_finaldest;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?
	if ( (part_total+e_qty) >= part_max - 1) return; // Are there any free particles?  Check for maximim amount of particles available.

	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
		// Setup DP particle style based on supplied style
		if (p_style & PARTICLE_BURST_YELLOW) dpp_string = DPP_BURSTPARTY;
		else if (p_style & PARTICLE_BURST_GREEN) dpp_string = DPP_BURSTPARTG;
		else if (p_style & PARTICLE_BURST_RED) dpp_string = DPP_BURSTPARTR;
		else if (p_style & PARTICLE_BURST_BLUE) dpp_string = DPP_BURSTPARTB;
		else if (p_style & PARTICLE_BURST_DBLUE) dpp_string = DPP_BURSTPARTDB;
		else if (p_style & PARTICLE_BURST_PURPLE) dpp_string = DPP_BURSTPARTP;
		else dpp_string = DPP_BURSTPARTW;
	}

	e_loop = 0;
	while (e_loop < e_qty) {
		e_loop = e_loop + 1;	// Keep on loopin!
		part = fetch_particle();
		if (part.classtype != CT_PARTICLE) continue; // Only preceed if a particle has been returned
		
		part.owner = self;
		particle_style(part, p_style);
		e_dir = normalize(vecrand(0,50,TRUE)); // Work out random direction from origin center
		e_finaldest = e_org + e_dir * (e_dist + random()*50);
		e_vdestdelta = e_org - e_finaldest;
		e_len = vlen(e_vdestdelta);
		e_traveltime = e_len / (e_speed + random()*50); // Calculate distance and time travelled
		setorigin(part, e_finaldest); // Move to outer edge of implosion circle
		setsize (part, VEC_ORIGIN, VEC_ORIGIN);
		part.movetype = MOVETYPE_NOCLIP;
		part.velocity = e_vdestdelta * (1/e_traveltime); // Setup inward velocity and time to kill
		part.nextthink = time + e_traveltime;
		part.think = finish_particle;
	}
};

// Particle explosion
// e_org		: center of particle explosion
// e_qty		: quantity of particle burst
// e_time		: lifespan of particle (time + random()*time)
// p_style	: sprite style (check function particle_style above)
// e_style	: explosion style (pre-defined in part_manage.qc)
void(vector e_org, float e_qty, float e_time, float p_style, float e_style) particle_explode = { // [FUNCTION]
	local float e_loop;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?

	e_qty = rint(e_qty); // Can only have integer particle quantity
	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
		// DP hammer impact, 1=regular 2=shockwave
		if (e_style & PARTICLE_BURST_SHOCKWAVE) {
			if (e_style & 1) pointparticles(particleeffectnum(DPP_BURSTSHOCKWAVE1), e_org, '0 0 0', 1);
			else pointparticles(particleeffectnum(DPP_BURSTSHOCKWAVE1), e_org, '0 0 0', 1);
		} else {
			// Setup DP particle style based on supplied style
			if (p_style & PARTICLE_BURST_YELLOW) dpp_string = DPP_BURSTPARTY;
			else if (p_style & PARTICLE_BURST_GREEN) dpp_string = DPP_BURSTPARTG;
			else if (p_style & PARTICLE_BURST_RED) dpp_string = DPP_BURSTPARTR;
			else if (p_style & PARTICLE_BURST_BLUE) dpp_string = DPP_BURSTPARTB;
			else if (p_style & PARTICLE_BURST_DBLUE) dpp_string = DPP_BURSTPARTDB;
			else if (p_style & PARTICLE_BURST_PURPLE) dpp_string = DPP_BURSTPARTP;
			else dpp_string = DPP_BURSTPARTW;
			pointparticles(particleeffectnum(dpp_string), e_org, '0 0 0', e_qty);
		}
	} else {
		if ( (part_total+e_qty) >= part_max - 1) return; // Are there any free particles?  Check for maximim amount of particles available.
		
		e_loop = 0;
		while (e_loop < e_qty) {
			e_loop = e_loop + 1;	// Keep on loopin!
			part = fetch_particle();
			if (part.classtype != CT_PARTICLE) continue; // Only preceed if a particle has been returned
			
			part.owner = self;
			particle_style(part, p_style);
			explosion_style(part, e_org, e_style);
			setsize (part, VEC_ORIGIN, VEC_ORIGIN); // Zero size and world interaction	
			part.nextthink = ((time + (random() * e_time)) + e_time);
			part.think = finish_particle;
		}
	}
};

// Particle DP/QSS/FTE smoke
// e_org		: Starting point for DP smoke
// e_dest		: Velocity direction for smoke
// e_qty		: quantity of smoke particles
// e_volume	: size of cube to spawn smoke inside for origin and direction
// e_speedqty : Random smoke velocity speed multiplier
// e_colour   : Colour (Grey, Yellow, White, Toxic, Green, Purple, Red, Fire)
void(vector e_org, vector e_dest, float e_qty, float e_volume, float e_speedqty, float e_colour) particle_DPsmoke = { // [FUNCTION]
	local float e_speed;
	local vector e_vel, rnd_vec;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?

	e_qty = rint(e_qty); // Can only have integer particle quantity
	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
		if (e_colour == 1) dpp_string = DPP_VELSMOKEGREY2;
		else if (e_colour == 2) dpp_string = DPP_VELSMOKEWHITE;
		else if (e_colour == 3) dpp_string = DPP_VELSMOKETOXIC;
		else if (e_colour == 4) dpp_string = DPP_VELSMOKEGREEN;
		else if (e_colour == 5) dpp_string = DPP_VELSMOKEPURPLE;
		else if (e_colour == 6) dpp_string = DPP_VELSMOKERED;
		else if (e_colour == 7) dpp_string = DPP_VELSMOKEFIRE;
		else dpp_string = DPP_VELSMOKEGREY1;
		
		rnd_vec = vecrand(0, e_volume, TRUE); // Create some random volume displacement at origin/destination
		e_org = e_org + rnd_vec; // Make sure volume is consistent with org+dest
		e_dest = e_dest + rnd_vec;
		e_speed = random() * e_speedqty; // Random speed multiplier
		e_vel = ((e_dest - e_org) * 0.015625) * e_speed; // DP emiiter is setup with 64 velocity multiplier
		pointparticles(particleeffectnum(dpp_string), e_org, e_vel, e_qty);
	}
};

// Particle stream
// e_org		: Starting point for particle stream
// e_dest		: Finishing point for particle stream
// e_qty		: quantity of particle burst
// e_time		: lifespan of particle (time + random()*time)
// e_volume	: size of cube to spawn sprites inside for origin and direction
// e_speedqty : Random particle velocity speed multiplier
// p_style	: sprite style (check function particle_style above)
void(vector e_org, vector e_dest, float e_qty, float e_time, float e_volume, float e_speedqty, float p_style) particle_stream = { // [FUNCTION]
	local float e_loop, e_speed;
	local vector e_vel, rnd_vec;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?

	e_qty = rint(e_qty); // Can only have integer particle quantity
	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
		// Setup DP particle style based on supplied style
		if (p_style & PARTICLE_BURST_YELLOW) dpp_string = DPP_BURSTPARTY;
		else if (p_style & PARTICLE_BURST_GREEN) dpp_string = DPP_BURSTPARTG;
		else if (p_style & PARTICLE_BURST_RED) dpp_string = DPP_BURSTPARTR;
		else if (p_style & PARTICLE_BURST_BLUE) dpp_string = DPP_BURSTPARTB;
		else if (p_style & PARTICLE_BURST_DBLUE) dpp_string = DPP_BURSTPARTDB;
		else if (p_style & PARTICLE_BURST_PURPLE) dpp_string = DPP_BURSTPARTP;
		else dpp_string = DPP_BURSTPARTW;
		
		rnd_vec = vecrand(0, e_volume, TRUE); // Create some random volume displacement at origin/destination
		e_org = e_org + rnd_vec;
		e_dest = e_dest + rnd_vec;
		e_speed = random() * e_speedqty;
		e_vel = normalize(e_dest - e_org) * e_speed;
		// Normalized velocity needs large extra boast! 
		pointparticles(particleeffectnum(dpp_string), e_org, e_vel*64, e_qty);
	} else {
		if ( (part_total+e_qty) >= part_max - 1) return; // Are there any free particles?  Check for maximim amount of particles available.
		
		e_loop = 0;
		while (e_loop < e_qty) {
			e_loop = e_loop + 1;	// Keep on loopin!
			// Create some random volume displacement at origin/destination
			rnd_vec = vecrand(0, e_volume, TRUE);
			e_speed = random() * e_speedqty;
			part = fetch_particle();
			if (part.classtype != CT_PARTICLE) continue; // Only preceed if a particle has been returned
			
			part.owner = self;
			particle_style(part, p_style); // Pick sprite sizes
			part.origin = e_org + rnd_vec; // Setup origin + direction
			setorigin (part, part.origin);
			part.velocity = ((e_dest + rnd_vec) - e_org) * e_speed;
			part.avelocity = vecrand(100,200,FALSE);
			part.movetype = MOVETYPE_FLY;
			part.flags = 0;
			setsize (part, VEC_ORIGIN, VEC_ORIGIN); // Zero size and world interaction	
			part.nextthink = ((time + (random() * e_time)) + e_time);
			part.think = finish_particle;
		}
	}
};

// Slowly rising cloud of particle dots
void(vector debuff_center, float debuff_volsize, float debuff_qty, float debuff_style) particle_debuff = { // [FUNCTION]
	local float debuff_loop, debuff_time;
	local vector debuff_org, debuff_vol;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?

	
	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) { // [FUNCTION]
		// Setup DP particle style based on supplied style
		if (debuff_style & PARTICLE_BURST_YELLOW) dpp_string = DPP_RINGPARTY;
		else if (debuff_style & PARTICLE_BURST_GREEN) dpp_string = DPP_RINGPARTG;
		else if (debuff_style & PARTICLE_BURST_RED) dpp_string = DPP_RINGPARTR;
		else if (debuff_style & PARTICLE_BURST_BLUE) dpp_string = DPP_RINGPARTB;
		else if (debuff_style & PARTICLE_BURST_DBLUE) dpp_string = DPP_RINGPARTDB;
		else if (debuff_style & PARTICLE_BURST_PURPLE) dpp_string = DPP_RINGPARTP;
		else dpp_string = DPP_RINGPARTW;
	} else {
		if ( (part_total+debuff_qty) >= part_max - 1) return; // Are there any free particles?  Check for maximim amount of particles available.
	}

	debuff_loop = 0;
	debuff_time = 2;
	while (debuff_loop < debuff_qty) {
		debuff_vol = vecrand(0,debuff_volsize,TRUE);
		debuff_org = debuff_center + debuff_vol;

		// Is the DP particle system active?
		if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) pointparticles(particleeffectnum(dpp_string), debuff_org, '0 0 0', 1);
		else {
			part = fetch_particle();
			if (part.classtype != CT_PARTICLE) continue; // Only preceed if a particle has been returned
			
			part.owner = self;
			part.movetype = MOVETYPE_NOCLIP;
			particle_style(part, debuff_style); // Setup correct particle type (sprite/model) based on ring colour
			setorigin (part, debuff_org);
			setsize (part, VEC_ORIGIN, VEC_ORIGIN); // Zero size and world interaction
			part.velocity = vecrand(0,2,TRUE); // Setup particle velocity with random element
			part.velocity_z = 8 + random()*24;
			part.nextthink = time + (random()*debuff_time) + debuff_time; // Setup time of death!
			part.think = finish_particle;
		}
		debuff_loop = debuff_loop + 1; // Keep on loopin!
	}
};

// Falling particle dust/dots
void(vector dust_center, float dust_qty, float dust_volsize, float dust_style) particle_dust = { // [FUNCTION]
	local float dust_loop, dust_time;
	local vector dust_org, dust_vol;
	local string dpp_string;

	if (query_configflag(SVR_PARTICLES) != SVR_PARTICLES) return; // Have particles been enabled via serverflags?

	// Setup DP particle style based on supplied style
	if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) {
		if (dust_style & PARTICLE_BURST_YELLOW) dpp_string = DPP_RINGPARTY;
		else if (dust_style & PARTICLE_BURST_GREEN) dpp_string = DPP_RINGPARTG;
		else if (dust_style & PARTICLE_BURST_RED) dpp_string = DPP_RINGPARTR;
		else if (dust_style & PARTICLE_BURST_BLUE) dpp_string = DPP_RINGPARTB;
		else if (dust_style & PARTICLE_BURST_DBLUE) dpp_string = DPP_RINGPARTDB;
		else if (dust_style & PARTICLE_BURST_PURPLE) dpp_string = DPP_RINGPARTP;
		else dpp_string = DPP_RINGPARTW;
	} else {
		if ( (part_total+dust_qty) >= part_max - 1) return; // Are there any free particles?  Check for maximim amount of particles available.
	}

	dust_loop = 0;
	dust_time = 1;
	while (dust_loop < dust_qty) {
		dust_vol = vecrand(0,dust_volsize,TRUE);
		dust_org = dust_center + dust_vol;

		// Is the DP particle system active?
		if (ext_dppart && query_configflag(SVR_SPRPARTON) == FALSE && world.sprite_particles == FALSE) pointparticles(particleeffectnum(dpp_string), dust_org, '0 0 0', 1);
		else {
			part = fetch_particle();
			if (part.classtype != CT_PARTICLE)  continue; // Only preceed if a particle has been returned
			
			part.owner = self;
			part.movetype = MOVETYPE_NOCLIP;
			part.solid = SOLID_NOT;
			particle_style(part, dust_style); // Setup correct particle type (sprite/model) based on ring colour
			setorigin (part, dust_org);		
			setsize (part, VEC_ORIGIN, VEC_ORIGIN); // Zero size and world interaction	
			part.velocity = vecrand(0,35,TRUE); // Setup particle velocity with random element
			part.velocity_z = -100 - random()*100;
			part.avelocity = '300 300 300';
			part.nextthink = time + (random()*dust_time) + dust_time; // Setup time of death!
			part.think = finish_particle;
		}
		dust_loop = dust_loop + 1; // Keep on loopin!
	}
};