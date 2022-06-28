//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Entity count: 6
// Function count: 11
//
// Implements: Traps
//
// Description:
// Traps such as shooters that shoot various things such as spikes, rockets,
// arrows, gas, fire, etc.
//=============================================================================

float TRAP_SNGSPIKE = 1;		// Large SNG spikes (high damage)
float TRAP_LASER = 2;			// Enforcer style lasers
float TRAP_WIZSPIKE = 4;		// Wizard Acid spit spike
float TRAP_HELLSPIKE = 8;		// Hell Knight Fire spikes 
float TRAP_LARGEGRENADE = 1;	// Player grenades (high damage)
float TRAP_LAVAROCKET = 1;		// Slow moving Cthton lava ball
float TRAP_FIREROCKET = 2;		// Fast moving Gargoyle fireball
float TRAP_JIMROCKET = 4;		// Low damage player rocket
float TRAP_LIGHTLARGE = 1;		// Cthton Lightning effect
float TRAP_LIGHTDUST = 8;		// Dust/Smoke effects at impact
float TRAP_LIGHTPART = 16;		// Particle effects at impact
float TRAP_CROSSBOLTS = 8192;	// Fire crossbow bolt
float TRAP_POISONBOLTS = 16384;	// Fire poison crossbow bolts
float TRAP_DARTS = 32768;		// Fire arrows/darts
float TRAP_GASSTEAM = 1;		// Gas particle types (default)
float TRAP_GASFIRE = 2;
float TRAP_GASPOISON = 4;
float TRAP_GASSILENT = 16;		// No particle sound effects
float TRAP_TOGGLE = 32;			// Toggle function with triggered
float TRAP_TRACKING = 128;		// Keep updating the target position

void() trap_tracking = { // [FUNCTION]
	if (self.target == "") return;

	if (!self.movetarget) self.movetarget = find(world, targetname, self.target);
	if (self.movetarget) {
		// Check for a Bmodel object (special origin)
		if (self.movetarget.bsporigin) self.dest1 = bmodel_origin(self.movetarget);
		else self.dest1 = self.movetarget.origin;
		// Calculate facing angle towards target
		self.movedir = normalize(self.dest1 - self.origin);
	}
};

void() trap_shooter_fire = { // [FUNCTION]
	local vector lightn_start, lightn_finish;
	
	if (self.estate & ESTATE_BLOCK) self.state = STATE_OFF; // Check if disabled/off first
	if (self.state == STATE_OFF) return;
	if (self.spawnflags & TRAP_TRACKING) TargetMovedir(self, TRUE); // Check for any target entity tracking changes

	if (self.classtype == CT_LIGHTSHOOTER) {
		// Time for a new LG hit sound?
		if (self.t_width < time) {
			// Lower volume and attenuation just in case of several together
			sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM);
			self.t_width = time + 0.6;
		}
	} else if (self.noise != "") sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Fire projectile sound

	// Determine type of projectile shooter
	if (self.classtype == CT_SPIKESHOOTER) {
		launch_projectile (self.origin, self.movedir, self.cnt ,self.speed);
	} else if (self.classtype == CT_GRENADESHOOTER) {
		self.finaldest = self.movedir * self.speed;
		self.finaldest_z = ELEV_ZAXIS;
		self.finalangle = vecrand(100,200,FALSE);
		Launch_Grenade(self.origin, self.finaldest, self.finalangle, self.cnt);
	} else if (self.classtype == CT_ROCKETSHOOTER) {
		if (self.spawnflags == TRAP_LAVAROCKET) self.finalangle = vecrand(100,200,FALSE);
		else self.finalangle = '0 0 0';

		Launch_Missile (self.origin, self.movedir, self.finalangle, self.cnt, self.speed);
	} else if (self.classtype == CT_LIGHTSHOOTER) {
		if (CheckZeroVector(self.dest1)) return; // Double check a destination origin exists
		
		self.effects = self.effects | EF_MUZZLEFLASH;
		
		// setup any random X/Y/Z start/end point wobble
		lightn_start = lightn_finish = '0 0 0';
		if (CheckZeroVector(self.pos1) == FALSE) {
			lightn_start_x = self.pos1_x * crandom();
			lightn_start_y = self.pos1_y * crandom();
			lightn_start_z = self.pos1_z * crandom();
		}

		lightn_start = lightn_start + self.origin;
		if (CheckZeroVector(self.pos2) == FALSE) {
			lightn_finish_x = self.pos2_x * crandom();
			lightn_finish_y = self.pos2_y * crandom();
			lightn_finish_z = self.pos2_z * crandom();
		}

		lightn_finish = lightn_finish + self.dest1;
		traceline(lightn_start, lightn_finish, TRUE, self); // trace a line from trap in direction or an exact end point

		// Check for particle effects at impact.  Designed to spray dust back towards source origin.
		if (self.spawnflags & TRAP_LIGHTDUST && random() < 0.7) {
			// Classic temporary entity
			newmis = spawn();
			newmis.classgroup = CG_TEMPENT;
			newmis.movetype = MOVETYPE_TOSS;
			newmis.solid = SOLID_NOT;
			setmodel(newmis, MODEL_PROJ_SMOKE);
			setorigin(newmis, trace_endpos);
			setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
			
			// Work out vector between source and target
			self.pos3 = normalize(lightn_finish - lightn_start);
			// Convert vector to angle so v_forward/v_right correct
			self.pos3 = vectoangles(self.pos3);
			makevectors(self.pos3);
			
			// Randomize the X/Y and push the vector back to source
			newmis.velocity = (crandom()*v_right)*150 + v_forward*(150+random()*300);

			// Temporary ents, quickly remove afterward
			newmis.nextthink = time + 1 + random()*3;
			newmis.think = SUB_Remove;
		}
		if (self.spawnflags & TRAP_LIGHTPART) particle_explode(trace_endpos, 5+random()*5, 1, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
		
		// Generate the lightning effect
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, self.lip);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, lightn_start_x);
		WriteCoord (MSG_BROADCAST, lightn_start_y);
		WriteCoord (MSG_BROADCAST, lightn_start_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
		LightningDamage(lightn_start, trace_endpos, self, self.dmg);	 // Check for things to damage in between the two points	
	}

	// Check for temporary continuous mode
	if (self.waitmin > 0 && time < self.pausetime) {
		self.think = trap_shooter_fire;
		self.nextthink = time + self.waitmin2;
	} else {
		if (self.spawnflags & TRAP_TOGGLE) { // Continuous mode?
			self.think = trap_shooter_fire;
			self.nextthink = time + self.wait + random()*self.delay;
		} else self.state = STATE_OFF; // Fire once and switch off
	}
};

void() trap_shooter_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check if disabled/off first
	if (check_nightmare() == TRUE) return; // Check for firing conditions (nightmare, coop)
	if (check_coop() == TRUE) return;

	// Toggle shooter on/off
	if (self.state == STATE_OFF) {
		self.state = STATE_ON;
		if (self.waitmin > 0) self.pausetime = time + self.waitmin;
		if (!self.waitmin2) self.waitmin2 = 0.1;
	}
	else self.state = STATE_OFF;
	
	trap_shooter_fire();
};

void() trap_shooter_reset = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
};

// QUAKED trap_spikeshooter (0 0.5 0.8) (-8 -8 -8) (8 8 8) SNG LASER WIZARD HELLK x TOGGLE x TRACK
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target : targeting entity used for custom direction
// angle  : direction for projectile to follow, use "360" for angle 0
// wait   : time between projectiles (def=0s)
// delay  : random time between projectile (def=0s)
// count  : = 1 Continuous mode (toggle/trigger to switch off)
// speed  : Change projectile speed (def/sng=500, laser=600, wiz=500, hell=300)
// -------- SPAWNFLAGS --------
// SNG    : shoots large spike (SNG damage)
// LASER  : shoots laser (Enforcer damage)
// WIZARD : shoots acid spike (Wizard damage)
// HELLK  : shoots fire spike (Hell Knight damage)
// TOGGLE : Trigger will toggle the shooter on/off instead
// TRACK  : Will update target entity origin before firing
// -------- NOTES --------
// When triggered, fires a SPIKE in the direction determined by angle.  Use TOGGLE spawnflag and trigger to enable continuous mode.
void() trap_spikeshooter = { // [ENTITY]
	if (self.spawnflags & TRAP_SNGSPIKE) {
		self.mdl = MODEL_PROJ_SNG;
		self.noise = "weapons/spike2.wav";
		self.cnt = CT_PROJ_SNG;
		if (!self.speed) self.speed = SPEED_TRAPSPIKE;
	} else if (self.spawnflags & TRAP_LASER) {
		self.mdl = MODEL_PROJ_LASER;
		self.noise = SOUND_LASER_FIRE;
		self.cnt = CT_PROJ_LASER;
		if (!self.speed) self.speed = SPEED_LASER;
		// Used for impact sound of laser
		precache_sound (SOUND_LASER_HIT);
	} else if (self.spawnflags & TRAP_WIZSPIKE) {
		self.mdl = MODEL_PROJ_WIZ;
		self.noise = "weapons/spike2.wav";
		self.volume = 0.5;
		self.cnt = CT_PROJ_WIZ;
		if (!self.speed) self.speed = SPEED_WIZSPIKE;
	} else if (self.spawnflags & TRAP_CROSSBOLTS) {
		self.mdl = MODEL_PROJ_WIZ;
		self.noise = "ad171/weapons/crossbow_fire.wav";
		self.volume = 0.5;
		self.cnt = CT_PROJ_BOLT1;
		if (!self.speed) self.speed = SPEED_DCROSS + (skill * SPEED_BOLTSKILL);
	} else if (self.spawnflags & TRAP_POISONBOLTS) {
		self.mdl = MODEL_PROJ_WIZ;
		self.noise = "ad171/weapons/crossbow_fire.wav";
		self.volume = 0.5;
		self.cnt = CT_PROJ_BOLT2;
		if (!self.speed) self.speed = SPEED_DCROSS + (skill * SPEED_BOLTSKILL);
	} else if (self.spawnflags & TRAP_DARTS) {
		self.mdl = MODEL_PROJ_WIZ;
		self.noise = "custents/weapons/lncharow.wav";
		self.volume = 0.5;
		self.cnt = CT_PROJ_DARTARROW;
		if (!self.speed) self.speed = SPEED_DCROSS + (skill * SPEED_BOLTSKILL);
	} else if (self.spawnflags & TRAP_HELLSPIKE) {
		self.mdl = MODEL_PROJ_HKN;
		self.noise = "weapons/spike2.wav";
		self.volume = 0.5;
		self.cnt = CT_PROJ_HKN;
		if (!self.speed) self.speed = SPEED_HKSPIKE;
	} else {
		self.mdl = MODEL_PROJ_NG;
		self.noise = "weapons/spike2.wav";
		self.cnt = CT_PROJ_NG;
		if (!self.speed) self.speed = SPEED_TRAPSPIKE;
	}
	precache_model (self.mdl);
	precache_sound (self.noise);

	self.classtype = CT_SPIKESHOOTER;
	if (self.wait <= 0) self.wait = 1;
	if (self.delay < 0) self.delay = 0;
	if (!self.volume) self.volume = 1;
	self.mangle = self.angles;
	SetMovedir ();

	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_use = trap_shooter_use;
	self.estate_reset = trap_shooter_reset;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;

	// If target is setup, calculate new facing angle
	if (self.target != "") {
		self.angletarget = self.target;
		self.nextthink = time + 1 + random();
		self.think = TargetMovedirReturn;
	}
};

// QUAKED trap_grenadeshooter (0 0.5 0.8) (-8 -8 -8) (8 8 8) LARGE x x x x TOGGLE x TRACK Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target : targeting entity used for custom direction
// angle  : direction for projectile to follow, use "360" for angle 0
// wait   : time between projectiles (def=0s)
// delay  : random time between projectile (def=0s)
// speed  : Change projectile speed (def=500, large=600)
// -------- SPAWNFLAGS --------
// LARGE  : shoots high damage grenade (Player damage, def=ogre)
// TOGGLE : Trigger will toggle the shooter on/off instead
// TRACK  : Will update target entity origin before firing
// -------- NOTES --------
// When triggered, fires a GRENADE in the direction determined by angle
// Use TOGGLE spawnflag and trigger to enable continuous mode
void() trap_grenadeshooter = { // [ENTITY]
	self.mdl = MODEL_PROJ_GRENADE;
	precache_model (self.mdl);
	self.noise = "weapons/grenade.wav";
	precache_sound (self.noise);
	if (self.spawnflags & TRAP_LARGEGRENADE) {
		self.cnt = CT_PROJ_GL;
		if(!self.speed) self.speed = SPEED_PLAYGRENADE;
	} else {
		self.cnt = CT_PROJ_GLMON;
		if(!self.speed) self.speed = SPEED_PLAYGRENADE;
	}

	self.classtype = CT_GRENADESHOOTER;
	if (self.wait <= 0) self.wait = 1;
	if (self.delay < 0) self.delay = 0;
	if (!self.volume) self.volume = 1;
	self.mangle = self.angles;
	SetMovedir ();
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trap_shooter_use;
	self.estate_reset = trap_shooter_reset;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
	if (self.target != "") { // If target is setup, calculate new facing angle
		self.angletarget = self.target;
		self.nextthink = time + 1 + random();
		self.think = TargetMovedirReturn;
	}
};

// QUAKED trap_rocketshooter (0 0.5 0.8) (-8 -8 -8) (8 8 8) LAVA FIRE JIM x x TOGGLE x TRACK Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target : targeting entity used for custom direction
// angle  : direction for projectile to follow, use "360" for angle 0
// wait   : time between projectiles (def=0s)
// delay  : random time between projectile (def=0s)
// speed  : Change projectile speed (def=1000, lava=300, fire=500)
// -------- SPAWNFLAGS --------
// LAVABALL : shoots Chthon lava ball (Player damage)
// FIREBALL : shoots Gargoyle fire ball (low damage)
// JIM FLYER: shoots Jim rocket (low damage)
// TOGGLE : Trigger will toggle the shooter on/off instead
// TRACK  : Will update target entity origin before firing
// -------- NOTES --------
// When triggered, fires a ROCKET in the direction determined by angle
// Use TOGGLE spawnflag and trigger to enable continuous mode
void() trap_rocketshooter = { // [ENTITY]
	if (self.spawnflags & TRAP_LAVAROCKET) {
		self.mdl = MODEL_PROJ_LAVA;
		precache_model (self.mdl);
		self.noise = "boss1/throw.wav";
		precache_sound (self.noise);
		self.cnt = CT_PROJ_LAVA;
		if (!self.speed) self.speed = SPEED_LAVABALL;
	} else if (self.spawnflags & TRAP_FIREROCKET) {
		self.mdl = MODEL_PROJ_GARGOYLE;
		precache_model (self.mdl);
		self.noise = "ad171/gargoyle/attack1.wav";
		precache_sound (self.noise);
		self.cnt = CT_PROJ_GARG;
		if (!self.speed) self.speed = SPEED_GARGMISSILE;
	} else if (self.spawnflags & TRAP_JIMROCKET) {
		self.mdl = MODEL_PROJ_ROCKET;
		precache_model (self.mdl);
		self.noise = "weapons/sgun1.wav";
		precache_sound (self.noise);
		precache_sound ("quoth/dguard/hit.wav");
		self.cnt = CT_PROJ_JIM2;
		if (!self.speed) self.speed = SPEED_RLPLAYER;
	} else {
		self.mdl = MODEL_PROJ_ROCKET;
		precache_model (self.mdl);
		self.noise = "weapons/sgun1.wav";
		precache_sound (self.noise);
		self.cnt = CT_PROJ_ROCKET;
		if (!self.speed) self.speed = SPEED_RLPLAYER;
	}

	self.classtype = CT_ROCKETSHOOTER;
	if (self.wait <= 0) self.wait = 1;
	if (self.delay < 0) self.delay = 0;
	if (!self.volume) self.volume = 1;
	self.mangle = self.angles;
	SetMovedir ();
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trap_shooter_use;
	self.estate_reset = trap_shooter_reset;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
	if (self.target != "") { // If target is setup, calculate new facing angle
		self.angletarget = self.target;
		self.nextthink = time + 1 + random();
		self.think = TargetMovedirReturn;
	}
};

// QUAKED trap_lightningshooter (0 0.5 0.8) (-8 -8 -8) (8 8 8) LARGE x x DUST PART TOGGLE x TRACK
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target   : targeting entity used for destination (required)
// wait     : time between projectiles (def=1s)
// delay    : random time between projectile (def=0s)
// volume   : Lightning hit sound volume (def=0.75)
// dmg      : Damage from lightning strike (def=15, large=30)
// pos1     : Random XYZ wobble to source position
// pos2     : Random XYZ wobble to target position
// -------- SPAWNFLAGS --------
// LARGE   : Cthton Boss Lightning
// DUST    : Produce dust/smoke at point of impact
// PARTICLE: Produce particles at point of impact
// TOGGLE  : Trigger will toggle the shooter on/off instead
// TRACK   : Will update target entity origin before firing
// -------- NOTES --------
// When triggered, fires a LIGHTNING at the target entity (can be blocked).  Use TOGGLE spawnflag and trigger to enable continuous mode.
void() trap_lightningshooter = { // [ENTITY]
	if (self.noise == "") self.noise = "weapons/lhit.wav";
	precache_sound (self.noise);
	self.classtype = CT_LIGHTSHOOTER;
	if (self.wait <= 0) self.wait = 1;
	if (self.delay < 0) self.delay = 0;
	if (!self.volume) self.volume = 0.75;
	self.t_width = 0;		// Light sound timer

	// Sort out lightning damage
	if (self.dmg < 1) {
		self.dmg = 15;
		if (self.spawnflags & TRAP_LIGHTLARGE) self.dmg = 30; // Double for large lightning
	}

	if (self.spawnflags & TRAP_LIGHTLARGE) self.lip = TE_LIGHTNING3; // Work out which lightning bolt to use
	else self.lip = TE_LIGHTNING2;

	if (SUB_HideIfNoTarget()) return; // Must have target for destination of lightning
	
	
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trap_shooter_use;
	self.estate_reset = trap_shooter_reset;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
	self.angletarget = self.target; // Find target once everything has spawned
	self.nextthink = time + 1 + random();
	self.think = TargetMovedirReturn;
};

void() trap_gasshooter_touch = { // [FUNCTION]
	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return;
	if (other.health < 1) return;
	if (other.takedamage == DAMAGE_NO) return;
	if (self.attack_finished > time) return;
	if (other.classtype == self.owner.classtype) return;

	self.attack_finished = time + 1;
	if (other.flags & FL_CLIENT) { // Check contact is a player?
		// Check for debuff particle type first
		if (self.owner.spawnflags & TRAP_GASFIRE) ApplyFireDmg(other, self.owner.dmg, self.owner.dmg);
		else if (self.owner.spawnflags & TRAP_GASPOISON) PoisonDeBuff(other);
		else T_Damage (other, self, self, self.owner.dmg, NOARMOR);
	} else if (other.flags & FL_MONSTER) T_Damage (other, self, self, DAMAGE_MONFLAME, NOARMOR); // Monsters have special damage to kill them quicker
	else T_Damage (other, self, self, self.owner.dmg, NOARMOR);
	self.velocity = '0 0 0';
};


void() trap_gasshooter_think = { // [FUNCTION]
	self.cnt = self.cnt + 1;
	if (self.cnt > 6) { remove(self); return; }

	self.frame = self.cnt;
	self.nextthink = time + 0.1 + random() * 0.05;
};

void() trap_gasshooter_spawn = { // [FUNCTION]
	local entity partemit;
	
	if (self.estate & ESTATE_BLOCK) self.state = STATE_OFF; // Check if disabled/off first
	if (self.state == STATE_OFF) return;
	
	if (self.spawnflags & TRAP_TRACKING) TargetMovedir(self, FALSE); // Check for any target entity tracking changes
	partemit = spawn();
	partemit.classtype = CT_TEMPSTREAM;
	partemit.classgroup = CG_PROJALL;
	partemit.owner = self;
	partemit.frame = partemit.cnt = 0;
	partemit.movetype = MOVETYPE_FLY;	// Fly, no gravity, but contact
	partemit.solid = SOLID_TRIGGER;		// collision, touch required
	setmodel (partemit, self.mdl);
	setorigin (partemit, self.origin);
	setsize (partemit, VEC_ORIGIN, VEC_ORIGIN);
	partemit.oldorigin = vecrand(0,20,TRUE);
	partemit.velocity = (self.movedir * self.speed) + partemit.oldorigin;
	partemit.angles_z = random() * 360;
	if (engine == ENG_DPEXT) partemit.effects = partemit.effects + EF_NOSHADOW; // If DP engine active remove particle shadow
	partemit.nextthink = time + 0.1 + random() * 0.05;
	partemit.think = trap_gasshooter_think;
	partemit.touch = trap_gasshooter_touch;
	if (self.spawnflags & TRAP_TOGGLE || self.waitmin2 > time) { // Continuous mode or auto switch off mode still on?
		self.think = trap_gasshooter_spawn;
		self.nextthink = time + self.wait;
	} else { // Time to switch off
		self.state = STATE_OFF;
		sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	}
};

void() trap_gasshooter_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	if (self.state == STATE_ON) sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM); // If gas shooter currently on, play switch off sound
	else StopSound(self,CHAN_VOICE);

	self.state = STATE_OFF;
};

void() trap_gasshooter_reset = { // [FUNCTION]
	self.estate = ESTATE_ON;
	StopSound(self,CHAN_VOICE); // clear any sounds playing
	self.state = STATE_OFF;
};

void() trap_gasshooter_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.state = STATE_ON;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.waitmin2 = time + self.waitmin;
	trap_gasshooter_spawn();
};

// Toggle shooter on/off
void() trap_gasshooter_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check if disabled/off first
	if (check_nightmare() == TRUE) return; // Check for firing conditions (nightmare, coop)
	if (check_coop() == TRUE) return;

	if (self.state == STATE_ON) {
		self.state = STATE_OFF;
		sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	} else trap_gasshooter_on();
};

// QUAKED trap_gasshooter (0 .5 .8) (-8 -8 -8) (8 8 8) STEAM FIRE POISON x SILENT TOGGLE x TRACK
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target : targeting entity used for custom direction
// angle  : direction for stream to follow, use "360" for angle 0
// wait   : time between particles (def=0.05s)
// speed  : velocity speed (def=200)
// waitmin: auto switch off timer (def=0.5s)
// dmg    : damage from contact with particles (def=1)
// -------- SPAWNFLAGS --------
// STEAM  : White hot clouds of steam (default)
// FIRE   : Will add burning debuff to player
// POISON : Will add poison debuff to player
// SILENT : No on/off sound, its silent!
// TOGGLE : Trigger will toggle the shooter on/off instead
// TRACK  : Will update target entity origin before firing
// -------- NOTES --------
// When triggered, fires a gas particle in the direction determined by angle
// Use TOGGLE spawnflag and trigger to enable continuous mode
void() trap_gasshooter = { // [ENTITY]
	if (self.spawnflags & TRAP_GASFIRE) {
		self.mdl = SBURST_FLAME;
		self.noise1 = "ad171/traps/flame_loop.wav";
		self.noise2 = "ad171/traps/flame_off.wav";
	} else if (self.spawnflags & TRAP_GASPOISON) {
		self.mdl = SBURST_POISON;
		self.noise1 = "ad171/traps/steam_loop.wav";
		self.noise2 = "ad171/traps/steam_off.wav";
	} else {
		self.spawnflags = self.spawnflags | TRAP_GASSTEAM; // Steam particles is the default
		self.mdl = SBURST_STEAM;
		self.noise1 = "ad171/traps/steam_loop.wav";
		self.noise2 = "ad171/traps/steam_off.wav";
	}

	if (self.spawnflags & TRAP_GASSILENT) {
		self.noise1 = SOUND_EMPTY;
		self.noise2 = SOUND_EMPTY;
	}
	precache_model (self.mdl);
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	self.classtype = CT_GASSHOOTER;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (!self.dmg) self.dmg = 1;
	if (self.speed < 1) self.speed = 200;
	if (self.wait <0.05) self.wait = 0.05;
	if (self.waitmin <=0) self.waitmin = 0.5;
	if (self.spawnflags & TRAP_TOGGLE) self.waitmin = LARGE_TIMER; 	// Does not auto switch off anymore
	if (self.angles_y == 0) self.angles_y = 360; // setup any angle direction
	self.mangle = self.angles;
	SetMovedir();
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trap_gasshooter_use;
	self.estate_reset = trap_gasshooter_reset;
	self.estate_off = trap_gasshooter_off;
	self.estate_on = trap_gasshooter_on;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
	if (self.target != "") { // If target is setup, calculate new facing angle
		self.angletarget = self.target;
		self.nextthink = time + 1 + random();
		self.think = TargetMovedirReturn;
	}
};

void() trap_proxmine = { // [ENTITY]
	self.mdl = "progs/ne_ruins/proxbomb.mdl";
	setmodel(self,self.mdl);
	self.bbmins = '-4.000 -4.000 -4.000';
	self.bbmaxs = '4.000 4.000 4.000';
	self.takedamage = DAMAGE_YES;
	self.health = 5;
	self.solid = SOLID_BBOX;
	setsize(self,self.bbmins,self.bbmaxs);
	self.touch = ProximityGrenadeTouch;
	if (!(self.spawnflags & TRAP_PROXSTATIC)) self.movetype = MOVETYPE_TOSS;
	self.classtype = CT_PROXMINE;
	self.th_die = ProximityGrenadeExplode;
	self.think = ProximityBomb;
	if (InSky(self.origin)) {
		dprint(self.classname);
		dprint(" has bad placement, starting in sky at ");
		dprint(vtos(self.origin));
		dprint(", removed!\n");
		self.think = SUB_Remove;
	} else if (InSolid(self.origin)) {
		if (!SUB_NudgeSelfPlacement(5)) {
			self.think = SUB_Remove;
		}
	}
	self.nextthink = time + 1 + (random() * 2);
};