//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Rubicon
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
// Entity count: 2
// Function count: 54
//
// Implements: Brush-Based Turret Trap
//
// Description:
// Stationary turrets that can spin in place to target the player with limited
// up/down angle tracking.
//=============================================================================

void() turret_ret1;
void() turret_still;
void() turret_active;
void(entity inflictor, entity attacker, float take)	turret_pain;
void() turret_die;
void() turret_fire1;
void() turret_use;

void() turret_shoot = { // [FUNCTION]
	local vector ang;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_VOICE, "enforcer/enfire.wav",1,ATTN_NORM);
	ang = vectoangles(self.enemy.origin - self.origin); //calculate pitch based on the enemy's position, but clamp it to a narrow range
	if (ang_x > 180) ang_x = ang_x - 360;	
	if (ang_x > TURRET_MAX_PITCH) ang_x = TURRET_MAX_PITCH;
	if (ang_x < TURRET_MIN_PITCH) ang_x = TURRET_MIN_PITCH;
	self.angles_x = 0 - ang_x; //invert it because for some reason +pitch is downwards for makevectors() but upwards for vectoangles()	
	makevectors(self.angles);
	launch_projectile(self.origin + ('0 0 1' * self.angles_x),v_forward,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
};

void() turret_helper_think = { // [FUNCTION]
	self.nextthink = time + 0.2;
	if (self.owner.state != TURRET_STATE_ACTIVE) return;
	if (!FindTarget()) return; // Find enemy.

	self.yaw_speed = (50 + skill * 20) * 0.2;
	ai_face();
	turret_shoot(); //shoot if enemy is in sight (even if facing wrong way)
};

void() turret_hit_bottom = { sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM); self.state = TURRET_STATE_INACTIVE; }; // [FUNCTION]

void() turret_go_down = { sound(self,CHAN_VOICE, self.noise2,1,ATTN_NORM); self.state = TURRET_STATE_DEACTIVATING; SUB_CalcMove (self.pos1, self.speed, turret_hit_bottom); }; // [FUNCTION]

void() turret_hit_top = { sound(self,CHAN_VOICE, self.noise1,1,ATTN_NORM); self.state = TURRET_STATE_ACTIVE; }; // [FUNCTION]

void() turret_go_up = { // [FUNCTION]
	sound(self,CHAN_VOICE, self.noise2,1,ATTN_NORM);
	self.state = TURRET_STATE_ACTIVATING;
	SUB_CalcMove (self.pos2, self.speed, turret_hit_top);
};

void() turret_func_use = { // [FUNCTION]
	if (self.state == TURRET_STATE_INACTIVE || self.state == TURRET_STATE_DEACTIVATING) {
		self.frame = 0;
		turret_go_up();
		self.enemy = activator;
	} else if (self.state == TURRET_STATE_ACTIVATING || self.state == TURRET_STATE_ACTIVE) {
		self.frame = 1;
		
		//if deactivated after being previously active, use movedir2 to determine position
		self.pos1 = self.origin + self.movedir2;
		turret_go_down();
	}
};

// QUAKED func_turret (0 .5 .8) ? START_OFF
// A rotating laser shooter that aims at the player in any horizontal direction. Has a capped rotation speed based on skill setting. When triggered, toggles between active and inactive states
// START_OFF spawns in the inactive state
// place in the level in the active/attacking position for proper lighting.
// "movedir" 	the offset from active position to the initial START_OFF position 
// "movedir2"  the offset from the active position to the deactivated position (after being previously active)
// "height" 	the position that laser originates, measured up from the very bottom of the model
// "angle"		determines the initial turret direction (horizontal directions only)
// "speed"		speed when moving to a new position
// "sounds"	sounds to use when moving to a new position
// 0)	no sound
// 1)	stone
// 2)	base
// 3)	stone chain
// 4)	screechy metal
void() func_turret = { // [ENTITY]
	local entity helper;
	local vector org;

	if (self.sounds == 0) self.noise1 = self.noise2 = SOUND_EMPTY;
	if (self.sounds == 1) {
		precache_sound("doors/drclos4.wav");
		precache_sound("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	} else if (self.sounds == 2) {
		precache_sound("doors/hydro1.wav");
		precache_sound("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	} else if (self.sounds == 3) {
		precache_sound("doors/stndr1.wav");
		precache_sound("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	} else if (self.sounds == 4) {
		precache_sound("doors/ddoor1.wav");
		precache_sound("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}
	precache_model ("progs/laser.mdl");
	precache_sound(SOUND_LASER_FIRE);
	precache_sound(SOUND_LASER_HIT);
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.bsporigin = TRUE;
	setorigin(self, self.origin);	
	setmodel(self, self.model);
	self.use = turret_func_use;
	if (!self.speed) self.speed = 100;
	self.pos1 = self.origin + self.movedir; //inactive position
	self.pos2 = self.origin; //active position
	
	//spawn a second entity to handle alpha changes, since MOVETYPE_PUSH doesn't support think functions
	helper = spawn();
	helper.owner = self;
	helper.nextthink = 0.1;
	helper.think = turret_helper_think;
	helper.classname = "turret";
	helper.angles = self.angles;
	org_x = (self.absmin_x + self.absmax_x) / 2;
	org_y = (self.absmin_y + self.absmax_y) / 2;
	org_z = self.absmin_z + self.height;
	setorigin(helper, org);
	self.angles = '0 0 0'; // Set actual angles to 0 now that helper has its angles

	//move to initial position
	if (self.spawnflags & TUR_STARTOFF) {
		self.state = TURRET_STATE_INACTIVE;
		setorigin(self, self.pos1);
		self.frame = 1;
	} else {
		self.state = TURRET_STATE_ACTIVE;
		setorigin(self, self.pos2);
		self.frame = 0;
	}

	// Testing using stuff from trap_turret to get this to work right
	if (self.health < 1) self.health = 100;
	self.max_health = self.health;
	if (self.rotate_type < 0 || self.rotate_type > 90) self.rotate_type = 0;
	self.currentammo = TRUE;

	if (self.spawnflags & TUR_RETRACT) {
		self.th_stand = turret_ret1;
		self.th_walk = turret_ret1;
	} else {
		self.th_stand = turret_still;
		self.th_walk = turret_still;
	}
	self.th_run = turret_active;
	self.th_pain = turret_pain;
	self.th_die = turret_die;
	self.th_missile = turret_fire1;
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	self.yaw_speed = 30;
	self.view_ofs = '0 0 -0.1';
	self.use = turret_use;
	self.flags = self.flags | FL_FLY;
	self.pausetime = 99999999;
	self.nextthink = self.nextthink + random()*0.5;
	self.think = self.th_stand;
};