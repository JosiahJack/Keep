//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Operation Urth Majik (OUM)
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
// Function count: 11
//
// Implements: Turret
//
// Description:
// A stationary gun turret that fires either lasers or perforator nails.  This
// is essentially like a trap_spikeshooter but it can track and aim at you.
//=============================================================================

void() tur_aim;
void() tur_run;

void() checkground = { // [FUNCTION]
	if (!(self.flags & FL_ONGROUND))
		return;

	if (self.groundentity.solid != SOLID_BSP) {
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		return;
	}
};

float() turfindtarget = { // [FUNCTION]
	local entity e;
	local float r;
	local float mr;
	self.oldenemy = self.enemy;
	if (self.enemy) {
		mr = vlen(self.enemy.origin - self.origin);
	} else {
		mr = 1000;
	}
	e = find(world, classname, "player");
	while (e) {
		if (e.health > 0) {
			if (e.team != self.team || teamplay == 0 && visible(e)) {
				r = vlen(e.origin - self.origin);
				if (r < mr) {
					mr = r;
					self.enemy = e;
				}
			}
		}
		e = find(e, classname, "player");
	}
	if (self.enemy != self.oldenemy) return 1;

	return 0;
};

void() tur_stand = { // [FUNCTION]
	checkground();
	if (!(self.flags & FL_ONGROUND)) T_Damage(self, world, world, 1000,DAMARMOR);
		
	if (self.state == 1) {
		if (!turfindtarget()) {
			self.enemy = world;
			tur_aim();
		} else {
			self.think = tur_run;
			self.nextthink = time + 0.1;
			return;
		}
	}
	self.think = tur_stand;
	self.nextthink = time + 0.1;
};
 
void() tur_walk = { // [FUNCTION]
	self.think = tur_stand;
	self.nextthink = time + 0.1;
};

void() tur_run = { // [FUNCTION]
	checkground();
	if (!(self.flags & FL_ONGROUND)) T_Damage(self, world, world, 1000,DAMARMOR);
	if (!visible(self.enemy)) self.enemy = world;
	if (self.enemy.health < 1) self.enemy = world;

	turfindtarget();
	if (!(self.enemy)) {
		self.think = self.th_stand;
		self.nextthink = time + 0.1;
		return;
	}
	tur_aim();
	self.think = tur_run;
	self.nextthink = time + 0.1;
};

void() tur_death = { // [FUNCTION]
	Tent_Explosion(self.origin);
	self.trigger_field.think = SUB_Remove;
	self.trigger_field.nextthink = time + 0.1;
	entity_remove(self,0.1);
};

void() tur_die = { // [FUNCTION]
	monster_death_precheck(); // Pre-check routine to tidy up extra entities.
	self.solid = SOLID_NOT;
	tur_death();
};

void() tur_aim = { // [FUNCTION]
	local vector dir;
	local vector vtemp;
	local vector org;
	local float dist;
	
	if (self.enemy == world) {
		org = self.origin + self.movedir;
	} else {
		org = self.enemy.origin + (self.enemy.mins + self.enemy.maxs) * 0.5;
		vtemp = org + self.enemy.velocity * self.speed;
		dist = vlen(vtemp - self.origin);
		dist = dist / 600;
		self.speed = dist;
		org = org + self.enemy.velocity * dist;
	}
	dir = vectoangles(org - self.origin);
	vtemp = VEC_ORIGIN;
	vtemp_y = dir_y - self.angles_y;
	vtemp_x = dir_x - self.trigger_field.angles_x;
	dir = VEC_ORIGIN;
	if (vtemp_x < 0) vtemp_x = vtemp_x + 360;
	if (vtemp_x > 180) vtemp_x = vtemp_x - 360;
	if (vtemp_y < 0) vtemp_y = vtemp_y + 360;
	if (vtemp_y > 180) vtemp_y = vtemp_y - 360;

	dir = vtemp;
	if (dir_x < -10) dir_x = -10;
	if (dir_x > MOVETYPE_BOUNCE) dir_x = MOVETYPE_BOUNCE;
	if (dir_y < -10) dir_y = -10;
	if (dir_y > MOVETYPE_BOUNCE) dir_y = MOVETYPE_BOUNCE;

	self.trigger_field.angles_x = anglemod(self.trigger_field.angles_x + dir_x);
	self.angles_y = anglemod(self.angles_y + dir_y);
	self.trigger_field.angles_y = self.angles_y;
	if (self.enemy) {
		dir = self.trigger_field.angles;
		dir_x = 0 - dir_x;
		makevectors(dir);
		dir = normalize(org - self.origin);
		if (dir * v_forward > 0.970000) {
			if (time > self.attack_finished) {
				traceline(self.origin, org, 1, world);
				if (trace_fraction == 1 && dist <= FL_SWIM) self.th_missile();
			}
		}
	}
};

void() tur_launch = { // [FUNCTION]
	local vector v1;
	if (!(self.ammo_cells)) return;

	self.ammo_cells = self.ammo_cells - 1;
	v1 = self.trigger_field.angles;
	v1_x = 0 - v1_x;
	makevectors(v1);
	v1 = v_forward;
	if (self.spawnflags & 2) {
		sound(self,CHAN_WEAPON,"drake/drone/enfire.wav",1,ATTN_NORM);
		if (self.ammo_cells & 1) {
			launch_projectile(self.origin + v_right*14,v1,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
		} else {
			launch_projectile(self.origin - v_right*14,v1,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
		}
		self.attack_finished = time + 0.2;
	} else {
		sound(self,CHAN_VOICE, "weapons/spike2.wav",1,ATTN_NORM);
		if (self.ammo_cells & 1) {
			launch_projectile(self.origin + v_right*14,v1,NO_SPIN,CT_PROJ_SNG,SPEED_TRAPSPIKE);
		} else {
			launch_projectile(self.origin - v_right*14,v1,NO_SPIN,CT_PROJ_SNG,SPEED_TRAPSPIKE);
		}
		self.attack_finished = time + 0.2;
	}
};

void() tur_use =  { // [FUNCTION]
	if (self.state == 0) {
		self.state = 1;
	} else {
		self.state = 0;
	}
	self.think = tur_stand;
	self.nextthink = time + 0.1;
};

void() monster_tur_precache = { // [FUNCTION]
	precache_model("progs/oum/aagba.mdl");
	precache_model("progs/oum/aagtb.mdl");
	precache_model("progs/laser.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("drake/drone/enfire.wav");
	precache_sound(SOUND_LASER_HIT);
	precache_sound("weapons/spike2.wav");
	precache_sound("drake/tur_arm.wav");
};

// montur is a monster...lame puns are great! haha!
void() monster_tur = {
	local entity trigent;
	local vector v1;

	if (!deathmatch) AddToTotals(self);	
	if (self.deathstring == "") self.deathstring = " was blasted by a Turret\n";\
	self.mdl = "progs/oum/aagba.mdl";
	self.gib1mdl = "progs/gib1.mdl";
	self.gib2mdl = "progs/gib2.mdl";
	self.gib3mdl = "progs/gib3.mdl";
	self.oldorigin = self.origin;
	if (!(self.health)) self.health = 200;
	self.gibhealth = -90;
	self.max_health = self.health;
	v1 = self.angles_y * '0 1 0' + '-20 0 0';
	makevectors(v1);
	self.movedir = v_forward;
	if (!(self.ammo_cells)) self.ammo_cells = 5000;
	self.aflag = self.ammo_cells;
	if (!(self.wait)) self.wait = SVC_INTERMISSION;
	if (!(self.state)) self.state = 1;
	if (self.targetname) self.use = tur_use;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_TOSS;
	self.health = self.max_health;
	setmodel(self, "progs/oum/aagba.mdl");
	setsize(self, '-16 -16 -20', '16 16 16');
	self.th_stand = tur_stand;
	self.th_walk = tur_walk;
	self.th_run = tur_run;
	self.th_die = tur_die;
	self.th_missile = tur_launch;
	setorigin(self, self.oldorigin);
	droptofloor();
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.view_ofs = '0 0 1';
	self.flags = self.flags | FL_MONSTER;
	trigent = spawn();
	trigent.owner = self;
	self.hittype    = HIT_METAL;
	trigent.takedamage = DAMAGE_NO;
	setmodel(trigent, "progs/oum/aagtb.mdl");
	self.trigger_field = trigent;
	trigent.angles = self.angles;
	setorigin(trigent, self.origin);
	self.ammo_cells = self.aflag;
	self.th_stand();
	monster_start();
};