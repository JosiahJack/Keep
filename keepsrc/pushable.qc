//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Mod attributions: Arcane Dimensions (AD), derived from Hipnotic
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
// Entity count: 0 - Utility functions only.
// Function count: 6
//
// Implements: Pushables Brush Models (bmodels)
//
// Description:
// * Looked at the code from Hipnotic Interactive (hip_push.qc)
// - It uses a proxy entity for the player to interact with
// - Movement is done by constantly updating origin
// - Code seems really experimental and a horrible mess
//
// * Looked at the code from the Nehara mod (push.qc)
// - It uses the original bmodel entity with velocity instead
// - Has one push sound type and moves XY directions
//
// * AD solution is inspired by Nehara code 
// - It uses the original bmodel and velocity movement
// - Switches movetype/solid so players can stand on top
// - Fades the bmodel (via alpha) so it does not block view
// - Works with entity state system, reset very useful if stuck
// - Works really close with breakables (target2 triggers)
//=============================================================================

float PUSH_DAMAGE = 2;		// Can receive damage (from anything) 
float PUSH_NOFLRCHECK = 8;	// No floor below check for movement
float PUSH_FLOATING = 16;	// Start floating on spawn (like items)
float PUSH_NOMONSTER = 32;	// Cannot be damaged by monsters

// Pushable sound/impact types
float PTYPE_ROCK = 1;		// Default rock
float PTYPE_WOOD = 2;
float PTYPE_GLASS = 3;
float PTYPE_METAL = 4;
float PTYPE_BRICK = 5;
float PTYPE_CUSTOM = 10;	// Custom push sounds

// Three sounds to randomly pick from 0.5s each
string SOUND_PUSH_ROCK1 = "pushable/rock_m1.wav";
string SOUND_PUSH_ROCK2 = "pushable/rock_m2.wav";
string SOUND_PUSH_ROCK3 = "pushable/rock_m3.wav";
string SOUND_PUSH_WOOD1 = "pushable/wood_m1.wav";
string SOUND_PUSH_WOOD2 = "pushable/wood_m2.wav";
string SOUND_PUSH_WOOD3 = "pushable/wood_m3.wav";
string SOUND_PUSH_GLASS1 = "pushable/glass_m1.wav";
string SOUND_PUSH_GLASS2 = "pushable/glass_m2.wav";
string SOUND_PUSH_GLASS3 = "pushable/glass_m3.wav";
string SOUND_PUSH_METAL1 = "pushable/metal_m1.wav";
string SOUND_PUSH_METAL2 = "pushable/metal_m2.wav";
string SOUND_PUSH_METAL3 = "pushable/metal_m3.wav";
string SOUND_PUSH_BRICK1 = "pushable/brick_m1.wav";
string SOUND_PUSH_BRICK2 = "pushable/brick_m2.wav";
string SOUND_PUSH_BRICK3 = "pushable/brick_m3.wav";

// Which touch state (used for fading)
float STATE_PUSH = 1;
float STATE_SOLID = 2;

//======================================================================
/*QUAKED func_pushable (0 .5 .8) ? x DAMAGE x NOFLRCHECK FLOATING NOMONSTER STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
Moveable brushwork (pushable)
-------- KEYS --------
targetname : trigger entity (works with entity state system)
style      : sound move/impact types - 1=rock, 2=wood, 3=glass, 4=metal, 5=brick, 10=custom
noise1     : Custom move sound 1 (style=10)
noise2     : Custom move sound 2
noise3     : Custom move sound 3
bleedcolour: Impact particle colour (starting point on palette)
bloodtype: Impact particle colour (starting point on palette)
target     : target(s) to fire when pushable is dead (once only)
deathtarget: target(s) to fire when pushable is dead (once only)
target2    : points to a func_breakable_spawner to trigger on death
message    : Message to display when killed by player
message2   : Message to display when touched by player
wait       : Time for showing touch/death message (=-1 once, def=2)
health     : damage taken before death
death_dmg  : will explode on death (reqs health)
speed      : pushing speed (def = 1)
waitmin    : length of pushable sounds (def=0.5s)
waitmin2   : Alpha value to fade block down to when pushing
-------- SPAWNFLAGS --------
DAMAGE    : Pushable can be damaged or destroyed
NOFLRCHECK: No floor below check for extra velocity
FLOATING  : Pushable starts off floating (until touched)
NOMONSTER : Cannot be damaged by monsters
STARTOFF  : Starts off and waits for trigger
-------- NOTES --------
Moveable brushwork (pushable)
*/
//======================================================================

void() func_pushable_push = {
	self.movetype = MOVETYPE_STEP;	// Default monster move type
	self.solid = SOLID_SLIDEBOX;	// Discrete movement stepping
	self.state = STATE_PUSH;		// Can be moved by player
};

void() func_pushable_solid = {
	self.movetype = MOVETYPE_PUSH;	// Blocks projectiles
	self.solid = SOLID_BSP;			// Square bounding box
	self.state = STATE_SOLID;		// No world interaction
	self.inpain = FALSE;			// Reset touch flag
};

void() func_pushable_movement = {
	if (self.estate & ESTATE_BLOCK) return; // Block entity state exceptions
	if (self.oldorigin == self.origin && !self.inpain) return; // Block movement if nothing has changed

	self.oldorigin = self.origin;
	self.inpain = FALSE; // Reset touch function flag
	
	// Check for moving sound
	if (self.attack_finished < time && self.state == STATE_PUSH) {
		self.attack_finished = time + self.waitmin + (random()*self.waitmin); // Random start to setup blending and overlap
		self.lefty = self.meleeattack; // Make sure sound WAVs don't repeat in a row
		while (self.lefty == self.meleeattack) { 
			self.lefty = rint(random()*3);
		}
		// CHAN_AUTO to allow for sound blending
		self.meleeattack = self.lefty;
		if (self.meleeattack == 1) 
			sound (self, CHAN_AUTO, self.noise1, 1, ATTN_NORM);
		else if (self.meleeattack == 2) 
			sound (self, CHAN_AUTO, self.noise2, 1, ATTN_NORM);
		else sound (self, CHAN_AUTO, self.noise3, 1, ATTN_NORM);
	}	

	// Remove onground flag so bmodel can move
	self.flags = self.flags - (self.flags & FL_ONGROUND);

	// Transfer velocity from player to pushable
	// Read velocity from saved touch entity
	self.velocity_x = self.finaldest_x * self.speed;
	self.velocity_y = self.finaldest_y * self.speed;

	// Enable floor below check?
	if (!(self.spawnflags & PUSH_NOFLRCHECK)) {
		// Work out push direction
		makevectors(self.finalangle);
		self.movedir = normalize(v_forward);
		self.movedir_z = 0;
		
		// Work out true min/max for bmodel using origin (offset)
		self.bbmins = self.origin + self.mins;
		self.bbmaxs = self.origin + self.maxs;

		// Find the middle of the bottom edge
		self.move_state = self.bbmins;
		self.move_state_x = self.move_state_x + (self.size_x*0.5);
		self.move_state_y = self.move_state_y + (self.size_y*0.5);
		
		// Trace down and see if anything is underneath it
		traceline(self.move_state, self.move_state+'0 0 -1024', FALSE, self);
		// Work out length of traceline downward
		self.t_length = fabs(trace_endpos_z - self.move_state_z);
		
		// Is there space below middle point?
		if (self.t_length > 0) {
			// Keep velocity active while ground is missing
			self.velocity = self.velocity + (self.movedir*self.t_width);
			// Keep looping around until on ground
			self.think = func_pushable_movement;
			self.nextthink = time + 0.05;
		}
	}
};

void() func_pushable_touch = {
	// Block entity state exceptions
	if (self.estate & ESTATE_BLOCK) return;

	// Allow for pushables to stack
	if (other.classtype == CT_FUNCPUSHABLE && other.state == STATE_PUSH) { func_pushable_solid();  return; } // Switch to solid block
	
	// Only works for the player
	if ( !(other.flags & FL_CLIENT) ) return;

	// Touch function is active
	self.inpain = TRUE;

	// Keep updating touch condition for fade controller
	// Create an overlap for the touch to stop working
	self.pain_finished = time + 0.5;
	
	// Check for a touch message
	if (self.message2 != "" && self.idletimer < time) {
		if (self.wait > 0) self.idletimer = time + self.wait;
		centerprint(other, self.message2);
		if (self.wait < 0) self.message2 = "";
	}

	// Slow down the detection of the touching object
	//
	// This is not an ideal solution, its a horrible hack!
	// The touching entity should be consistent with its Z axis
	// origin if the entity is not moving up or down.
	// For some reason the Z axis is inconsistent +/- 18 units
	// Cannot slowdown the touch function because the movement
	// of the pushable stutters and looks terrible.
	// Touch functions cycle at really high frame rates so
	// its easier to slowdown the reading the entity instead!
	//
	if (self.oldenemy != other || self.meleetimer < time) {
		// Save player details for later
		self.oldenemy = other;
		self.dest1 = self.oldenemy.origin;
		self.dest2 = self.oldenemy.view_ofs;
		// Slowdown the reading of the touching entity
		self.meleetimer = time + 0.01;
	}
	
	self.finalangle = self.oldenemy.angles;
	self.finaldest = self.oldenemy.velocity;
	self.pos3 = self.dest1 - self.dest2; // Setup origin of player (at feet level)
	self.bbmins = self.origin + self.mins; // Work out true min/max for bmodel using origin (offset)
	self.bbmaxs = self.origin + self.maxs;

	// Check if player is above/below pushable
	if (self.pos3_z >= self.bbmaxs_z) {
		func_pushable_solid();		// Stop the bmodel interacting with player
	} else {
		func_pushable_push();		// bmodel can be moved (again)
		func_pushable_movement();	// Move the pushable block
	}
};

void(entity inflictor, entity attacker, float damage) func_pushable_pain = {
	local float loop_count;
	local vector vel;

	if (!(self.spawnflags & PUSH_DAMAGE)) {self.health = MEGADEATH; return;} // default = Pushables cannot die
	if (self.estate & ESTATE_BLOCK) return; // Block entity state exceptions

	// Something is trying to wear down the pushable with damage
	// work out facing angle and project particles upward
	makevectors(inflictor.angles);
	vel = -v_up*2;
	while(loop_count < 4) {
		particle (inflictor.origin, vel*0.1, self.bloodtype + rint(random()*7), damage);
		loop_count = loop_count + 1;
	}
};

void() func_pushable_death = {
	if (!(self.spawnflags & PUSH_DAMAGE)) {self.health = MEGADEATH; return;} // default = Pushables cannot die
	if (self.estate & ESTATE_BLOCK) return; // Block entity state exceptions

	self.oldorigin = bmodel_origin(self); // Work out current bmodel origin
	
	// Check for breakable spawners
	if (self.target2 != "") {
		self.enemy = find (world, targetname, self.target2);
		// Make sure its a breakable spawner ONLY!
		if (self.enemy.classtype == CT_FUNCBREAKSPN) {
			self.enemy.origin = self.oldorigin; // Copy over pushable bmodel origin and volume to breakable
			setorigin(self.enemy, self.enemy.origin);
			self.enemy.brkvol = self.size;
			trigger_ent(self.enemy, self.activate); // Use entity which killed pushable for breakable direction
		}
	}

	// Check for explosion sprite/particle effect
	if (self.death_dmg > 0) {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.oldorigin_x);
		WriteCoord (MSG_BROADCAST, self.oldorigin_y);
		WriteCoord (MSG_BROADCAST, self.oldorigin_z);
		SpawnExplosion(EXPLODE_SMALL, self.oldorigin, SOUND_REXP3);
		T_RadiusDamage (self, self, self.death_dmg, world, DAMAGEALL);
	}
	
	// Fire death targets (check DT first, because target can have uses)
	if (self.deathtarget != "") trigger_strs(self.deathtarget, self.activate);
	if (self.target != "") trigger_strs(self.target, self.activate);

	// Any final words ...
	if (self.activate.flags & FL_CLIENT && self.message != "") centerprint (self.activate, self.message);
	
	// Fire once condition?
	if (self.wait < 0) self.target = self.deathtarget = self.message = "";

	// Check for any pushable above? (fake physics)
	self.move_state = bmodel_origin(self);
	
	// Trace up and see if anything is above
	traceline(self.move_state, self.move_state + '0 0 1024', FALSE, self);

	// Check for a pushable entity above (but not touching)
	if (trace_ent != self && trace_ent.classtype == CT_FUNCPUSHABLE) trigger_ent(trace_ent, self);
	
	// Switch off entity instead of hide/remove so the pushable can be reset again
	self.estate_off();
};

// The pushable needs a controller to reach to the touch function
// and to reset the alpha fade if the pushable is not being touched
void() pushable_controller_think = {
	// Keep the controller alive
	self.think = pushable_controller_think;
	self.nextthink = time + 0.1;
	
	// Block entity state exceptions
	if (self.owner.estate & ESTATE_BLOCK) return;
	
	// Check if the player is touching the pushable?
	// If the player is standing on the block, no alpha
	if (self.owner.pain_finished > time && self.owner.state == STATE_PUSH) {
		// Is the alpha set the right amount?
		if (self.owner.alpha > self.owner.waitmin2) {
			self.owner.alpha = self.owner.alpha - 0.01;
			self.nextthink = time + FADEMODEL_TIME;
		}
	}
	else {
		if (self.owner.alpha < 1.00) {
			self.owner.alpha = self.owner.alpha + 0.01;
			self.nextthink = time + FADEMODEL_TIME;
		}
	}
};

void() func_pushable_controller_setup = {
	// Check if controller entity been setup
	if (!self.attachment) self.attachment = spawn();

	// Setup link back to pushable
	self.attachment.owner = self;
	self.attachment.classtype = CT_CONTROL;
	self.attachment.movetype = MOVETYPE_NONE;
	self.attachment.solid = SOLID_NOT;
	// Move to pushable bmodel origin location
	self.attachment.origin = bmodel_origin(self);
	setorigin(self.attachment, self.attachment.origin);
	setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
	
	// Start fade controller think loop
	self.attachment.think = pushable_controller_think;
	self.attachment.nextthink = time + 0.1;
};

void() func_pushable_use = {
	// Switch on pushable first
	if (self.estate == ESTATE_OFF) entity_state_on();
	else {
		// Let the pushable move around
		func_pushable_push();
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		// Push upward using size as force
		self.velocity_z = self.t_width;
	}
};

void() func_pushable_reset = {	
	// If the block starts off(disabled) then do nothing
	if (self.spawnflags & ENT_STARTOFF) return;

	// reset to original position
	setorigin(self, VEC_ORIGIN);
	// Make sure the bmodel drops down, no weird ofset
	self.velocity = self.avelocity = '0 0 0';
	self.estate_on();	
};

void() func_pushable_off = {
	// Do nothing if pushable is already off
	if (self.estate == ESTATE_OFF) return;
	
	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, "");
	// Switch off impact particles
	self.takedamage = DAMAGE_NO;
};

void() func_pushable_on = {
	// Do nothing if pushable is already on
	if (self.estate == ESTATE_ON) return;
	
	// No longer need this spawnflag, remove it
	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF);

	self.estate = ESTATE_ON;
	func_pushable_push();
	setmodel (self, self.mdl);
	
	// Setup touch fade controller
	if (!self.attachment) func_pushable_controller_setup();

	// Switch on impact particles
	self.takedamage = DAMAGE_AIM;
	// Reset health to spawn 
	self.health = self.max_health;

	if (!(self.spawnflags & PUSH_FLOATING)) {
		// Make sure it drops to ground on spawn
		self.origin_z = self.origin_z + 4;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	}
	else func_pushable_solid();
};

void() func_pushable = {
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	// make sure initial break sound is within range types (def=rock)
	if (self.style < PTYPE_ROCK || self.style > PTYPE_CUSTOM) self.style = PTYPE_ROCK;
		
	// Medium drag sound with light brown impact particles
	if (self.style == PTYPE_WOOD) {
		self.noise1 = SOUND_PUSH_WOOD1;
		self.noise2 = SOUND_PUSH_WOOD2;
		self.noise3 = SOUND_PUSH_WOOD3;
		if (self.bleedcolour <= 0) self.bleedcolour = self.bloodtype = 112;
		if (self.bloodtype <= 0) self.bleedcolour = self.bloodtype = 112;
	} else if (self.style == PTYPE_GLASS) {
		// Light drag sound with light yellow impact particles
		self.noise1 = SOUND_PUSH_GLASS1;
		self.noise2 = SOUND_PUSH_GLASS2;
		self.noise3 = SOUND_PUSH_GLASS3;
		if (self.bleedcolour <= 0) self.bleedcolour = self.bloodtype = 96;
		if (self.bloodtype <= 0) self.bleedcolour = self.bloodtype = 96;
	} else if (self.style == PTYPE_METAL) {
		// Medium drag sound with green/brown impact particles
		self.noise1 = SOUND_PUSH_METAL1;
		self.noise2 = SOUND_PUSH_METAL2;
		self.noise3 = SOUND_PUSH_METAL3;
		if (self.bleedcolour <= 0) self.bleedcolour = self.bloodtype = 80;
		if (self.bloodtype <= 0) self.bleedcolour = self.bloodtype = 80;
	} else if (self.style == PTYPE_BRICK) {
		// Light drag sound with brown impact particles
		self.noise1 = SOUND_PUSH_BRICK1;
		self.noise2 = SOUND_PUSH_BRICK2;
		self.noise3 = SOUND_PUSH_BRICK3;
		if (self.bleedcolour <= 0) self.bleedcolour = self.bloodtype = 80;
		if (self.bloodtype <= 0) self.bleedcolour = self.bloodtype = 80;
	} else if (self.style == PTYPE_CUSTOM) {
		// Custom sounds with white/grey impact particles
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
		if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
		if (self.noise3 == "") self.noise3 = SOUND_EMPTY;
		if (self.bleedcolour <= 0) self.bleedcolour = self.bloodtype = 1;
		if (self.bloodtype <= 0) self.bleedcolour = self.bloodtype = 1;
	} else {
		// *** DEFAULT ***
		// Heavy drag sound with brown impact particles
		self.noise1 = SOUND_PUSH_ROCK1;
		self.noise2 = SOUND_PUSH_ROCK2;
		self.noise3 = SOUND_PUSH_ROCK3;
		if (self.bleedcolour <= 0) self.bleedcolour = self.bloodtype = 80;
		if (self.bloodtype <= 0) self.bleedcolour = self.bloodtype = 80;
	}
	
	// Cache all sounds
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);
	self.classtype = CT_FUNCPUSHABLE;
	self.classgroup = CG_BREAKABLE;
	self.bsporigin = TRUE;
	self.mdl = self.model;
	self.mangle = self.angles; // Save starting position and reset angles
	self.angles = '0 0 0';
	if (!self.speed) self.speed = 1; // Default parameters and states
	if (!self.wait) self.wait = 2;
	if (!self.waitmin) self.waitmin = 0.5; // Length of dragging sounds
	self.waitmin = self.waitmin * 0.5; // Create halway point for random start
	self.state = STATE_PUSH; // Start with pushing state
	self.pain_finished = -1;
	if (!self.waitmin2) self.waitmin2 = 0.6; // Setup default alpha fade (lower) value
	self.alpha = 1;
	self.th_pain = func_pushable_pain;
	self.th_die = func_pushable_death;
	
	// The pushable needs to take damage for impact sounds
	// to work correctly. Check for health default first
	// Pain/death needs to reset health if indestructible
	if (self.health <= 0) {
		if (self.spawnflags & PUSH_DAMAGE) self.health = 1;
		else self.health = MEGADEATH;
	}
	self.max_health = self.health;
	func_pushable_solid(); // Setup the bmodel ready for interaction
	setmodel(self, self.mdl);
	setorigin(self, VEC_ORIGIN);
	setsize(self, self.mins, self.maxs);
	self.t_width = rint((self.size_x + self.size_y) * 0.5); // Work out average size of block
	
	// Check for spawning conditions (nightmare, coop)
	// Needs to exist after entity has been added to work for BSPorigin
	if (check_nightmare() == TRUE) return;
	if (check_coop() == TRUE) return;
	
	// Setup Entity State functionality
	self.use = entity_state_use;
	self.estate_use = func_pushable_use;
	self.estate_on = func_pushable_on;
	self.estate_off = func_pushable_off;
	self.estate_reset = func_pushable_reset;
	self.touch = func_pushable_touch;
	
	// Setup pushable in correct state
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};