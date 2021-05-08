/*======================================================================
 MISC ENTITIES
======================================================================*/
float MISC_STARTOFF = 1;		// Start OFF (use DELAY instead!)

//======================================================================
/*QUAKED misc_smoke (.5 .5 .75) (-8 -8 -8) (8 8 192) x NODPMDL NODPFX x x x STARTOFF x
Smoke model (+DP only smoke effect)
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
target     : targeting entity used for custom direction
angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
exactskin  : 0=Gunsmoke, 1=Soot, 2=Steam, 3=Toxin, 4=Plague, 5=Incense, 6=Lithium, 7=Flames
alpha      : alpha value for model (def=0.65)
wait       : time between generation of smoke particles (def=0.1, min=0.01)
delay      : random amount of time delay ( time = wait + delay x random() )
height     : Percentage of velocity distance travelled (def=1, range=0-1+)
-------- SPAWNFLAGS --------
NODPMDL    : Do not draw smoke model in DP engine
NODPFX     : Do not draw DP smoke particle effect
STARTOFF   : Always Starts off and waits for trigger
-------- NOTES --------
Smoke model, +DP only smoke effect (wait/delay/height DP only)
angles = 'pitch roll yaw' up/down, angle, tilt left/right 
up/left = negative value, down/right = positive value

======================================================================*/
void() misc_smoke_model = 
{
	self.count = self.count + 1;
	if (self.count > 59) self.count = 0;
	self.frame = self.count;
	self.think = misc_smoke_model;
	self.nextthink = time + 0.1;
};

void() misc_smoke_on =
{
	self.estate = ESTATE_ON;

	// Switch on particle emitter if was setup
	if (self.part_emitter) misc_particle_on(self.part_emitter);

	if (self.partname)
		self.traileffectnum = particleeffectnum(self.partname);
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.skin = self.exactskin;
		self.count = rint(random()*59);
		misc_smoke_model();
	}
};

//----------------------------------------------------------------------
void() misc_smoke_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") self.model = "";
};

//----------------------------------------------------------------------
void() misc_smoke_setup =
{
	// If target is setup, calculate new facing angle
	if (self.target != "") {
		if (!self.movetarget)
			self.movetarget = find(world, targetname, self.target);
		
		if (self.movetarget) {
			// Check for a Bmodel object (special origin)
			if (self.movetarget.bsporigin) self.dest1 = bmodel_origin(self.movetarget);
			else self.dest1 = self.movetarget.origin;
			// Calculate facing angle towards target
			self.movedir = normalize(self.dest1 - self.origin);
			self.angles = vectoangles(self.movedir);
			self.angles_y = self.angles_y + 180;
			// Update velocity direction for DP effect
			if (self.part_emitter) self.part_emitter.dpp_vel = self.movedir*self.height;
		}
	}

	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_smoke_on;
	self.estate_off = misc_smoke_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

//----------------------------------------------------------------------
void() misc_smoke =
{
	self.mdl = "progs/misc_smoke.mdl";
	precache_model (self.mdl);

	self.classtype = CT_MISCSMOKE;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (!self.exactskin) self.exactskin = 0;	// Default = 0
	if (self.wait < 0.1) self.wait = 0.1;
	if (self.delay <= 0) self.delay = 0.1;
	if (self.height <= 0) self.height = 0.5 + random()*0.5;
	// If DP engine active remove particle shadow
	if (engine == ENG_DPEXT) {
		// Originally had ef_additive but produced sorting errors
		self.effects = self.effects + EF_NOSHADOW;
	}
	else {
		// Setup alpha for non DP engines
		if (!self.alpha) self.alpha = 0.5+random()*0.25;
	}

	// Calculate smoke particle movedir from angles
	makevectors(self.angles);
	self.movedir = v_up;
	
	// Setup some random Y axis rotation if nothing set
	if (CheckZeroVector(self.angles)) self.angles_y = rint(random()*360);

	// DP particle effects active?
	if (ext_dppart) {
		// Remove the model if spawnflag set
		if (self.spawnflags & MISC_SMOKENODPMDL) self.mdl = "";
		
		// Spawn particle emitter if particles active and not blocked
		if (query_configflag(SVR_PARTICLES) && !(self.spawnflags & MISC_SMOKENODPFX) ) {
			self.part_active = PARTICLE_STYLE_SMOKE;
			if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) 
				self.part_emitter = spawn_pemitter(self, self, self.part_active, PARTICLE_START_OFF);
			else self.part_emitter = spawn_pemitter(self, self, self.part_active, PARTICLE_START_ON);
		}
	}
	
	// Setup target and delay starting model animation
	self.nextthink = time + 0.1 + (rint(random()*10) * 0.1);
	self.think = misc_smoke_setup;
};

/*======================================================================
 spark effect (based on code from Rubicon2 by JohnFitz)
 - Modified to have on/off/toggle state via triggers
 - extended parameters for angle/speed/custom sounds

/*QUAKED misc_spark (.5 .75 .5) (-8 -8 -8) (8 8 8) x BLUE PALE RED x x STARTOFF x
Produces a burst of sparks at random intervals
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
target : If target is a light, will be switched on/off in sync
wait   : time delay between bursts Def=2, spark once=-1
cnt    : number of sparks in burst (0.5 + random() x 0.5) Def=16
angle  : direction of sparks to follow, use "360" for 0
fixangle: 1 = Random Y axis direction of sparks
speed  : velocity speed of sparks (def=40)
height : random velocity modifier (def=+/-20)
sounds : 1=sparks, 4=silent, 5=custom
noise  : custom sound for sparks
-------- SPAWNFLAGS --------
BLUE   : sparks are blue in colour (def=yellow)
PALE   : sparks are pale yellow in colour (def=yellow)
RED    : sparks are red in colour (def=yellow)
STARTOFF : Always Starts off and waits for trigger
-------- NOTES --------
Produces a burst of sparks at random intervals
If targeting a light, it must start switched off (lights spawnflag=1)

======================================================================*/

void()	misc_sparks_fade1 = [0, misc_sparks_fade2] {self.alpha = 0.8; self.nextthink = time + 0.05;};
void()	misc_sparks_fade2 = [0, misc_sparks_fade3] {self.alpha = 0.6; self.nextthink = time + 0.05;};
void()	misc_sparks_fade3 = [0, misc_sparks_fade4] {self.alpha = 0.4; self.nextthink = time + 0.05;};
void()	misc_sparks_fade4 = [0, SUB_Remove] {self.alpha = 0.2; self.nextthink = time + 0.05;};

//----------------------------------------------------------------------
void() misc_spark_spawn;
void() misc_spark_switchoff = 
{
	// Always switch off trigger (lights)
	SUB_UseTargets();

	// Is the entity OFF or BLOCKED?
	if (self.estate & ESTATE_BLOCK) return;
	// Only spark once (wait for trigger)
	if (self.wait > 0) {
		self.think = misc_spark_spawn;
		self.nextthink = time + self.wait + (random()*self.wait);
	}
}

//----------------------------------------------------------------------
void() misc_spark_spawn =
{
	local float loopvar;
	local entity spark;

	// Is the entity OFF or BLOCKED?
	if (self.estate & ESTATE_BLOCK) return;

	// Check for random rotation, most be set for whole batch
	// otherwise the sparks will all go in different directions
	if (self.fixangle > 0) {
		self.angles = '0 0 0';
		self.angles_y = rint(random()*360);
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	// Work out how many sparks to spawn
	loopvar = (0.5 + random()*0.5)*self.cnt;
	while (loopvar > 0) {
		spark = spawn();
		spark.classtype = CT_TEMPSPARK;
		spark.classgroup = CG_TEMPENT;
		spark.owner = self;
		spark.movetype = MOVETYPE_BOUNCE;
		spark.solid = SOLID_TRIGGER;
		setmodel (spark, self.mdl);
		setorigin (spark, self.origin);
		setsize (spark, VEC_ORIGIN, VEC_ORIGIN);
		spark.gravity = 0.3;
		spark.velocity = vecrand(0,self.height,TRUE);
		spark.velocity = spark.velocity + (self.movedir * self.speed);
		spark.avelocity = '300 300 300';
		spark.nextthink = time + 0.5 + 1.5*random();
		spark.think = misc_sparks_fade1;
		
		// If DP engine active remove particle shadow
		if (engine == ENG_DPEXT) spark.effects = spark.effects + EF_NOSHADOW;

		// Some brightness variety
		if (random() < 0.33) spark.skin = 0;
		else if (random() < 0.5) spark.skin = 1;
		else spark.skin = 2;

		// Alternative colours (blue, pale yellow & red)
		if (self.spawnflags & MISC_SPARKBLUE) spark.skin = spark.skin + 3;
		else if (self.spawnflags & MISC_SPARKPALE) spark.skin = spark.skin + 6;
		else if (self.spawnflags & MISC_SPARKRED) spark.skin = spark.skin + 9;
			
		loopvar = loopvar - 1;
	}
	// Play any spark sound and switch ON any target lights
	if (self.noise != "") sound (self, CHAN_VOICE, self.noise, 1, ATTN_STATIC);
	
	// Is there any target(s) to switch on
	if (self.target) {
		SUB_UseTargets();
		// Setup timer to switch off
		self.nextthink = time + 0.1 + random() * 0.2;
		self.think = misc_spark_switchoff;
	}
	else {
		// Only spark once (wait for trigger)
		if (self.wait > 0) {
			self.nextthink = time + 0.2 + self.wait + (random()*self.wait);
			self.think = misc_spark_spawn;
		}
	}
};

//----------------------------------------------------------------------
void() misc_spark_on =
{
	self.estate = ESTATE_ON;
	self.nextthink = time + 0.1 + random();
	self.think = misc_spark_spawn;
};

//----------------------------------------------------------------------
void() misc_spark =
{
	self.mdl = "progs/misc_spark.mdl";
	precache_model (self.mdl);
	if (self.sounds == 1) self.noise = "misc/spark.wav";
	if (self.noise != "") precache_sound (self.noise);
	
	self.classtype = CT_MISCSPARK;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (!self.wait) self.wait = 2;		// -1 = spark once and turn off
	if (!self.cnt) self.cnt = 16;
	if (!self.speed) self.speed = 40;
	if (!self.height) self.height = 20;
	self.estate = ESTATE_OFF;

	// Always convert 0 angle to 360 for setmovedir function
	if (CheckZeroVector(self.angles)) self.angles = '0 360 0';
	self.mangle = self.angles;
	SetMovedir();

	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_spark_on;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

/*======================================================================
Screen Shake (based on code from RRP by ijed/supa)
 - Modified to have on/off/toggle state
 - added extra sound options

/*QUAKED misc_shake (.5 .5 .9) (-16 -16 -8) (16 16 8) x VIEWONLY x x x x x x
Shake players view and/or velocity around center of entity
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
count  : radius of shake (def = 200)
wait   : duration of shake (def = 2s)
dmg    : strength at center (def = 200)
sounds : 1=loud rumble (no default)
noise1 : noise to play when starting to shake
noise2 : noise to play when stopping
-------- SPAWNFLAGS --------
VIEWONLY : Shakes the view, but player movement is not affected
-------- NOTES --------
Shake players view and/or velocity around center of entity.
Always starts off, requires triggers to activate

======================================================================*/
void() misc_shake_think =
{
	local entity plyr;
	local float	d;

	// Is the shaking over?
	if (self.attack_finished < time || self.estate & ESTATE_BLOCK) {
		if (self.noise2) sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
		// Check state before changing it, entity may be disabled
		if (self.estate == ESTATE_ON) self.estate = ESTATE_OFF;
		return;
	}
	
	// Create a list of entities to check for players
	plyr = findradius(self.origin, self.count);
	while(plyr) {
		// Only shake players (clients)
		if (plyr.flags & FL_CLIENT) {	
			// Scale effect by distance
			d = vlen(self.origin - plyr.origin);
			d = (self.count - d)/self.count;
			
			if (d > 0) {
				// shake up the view
				plyr.punchangle_x = -1 * (random() + (0.025*self.dmg*d));
				plyr.punchangle_y = -1 * (random() + (0.025*self.dmg*d));
				plyr.punchangle_z = -1 * (random() + (0.025*self.dmg*d));
				
				// push the player around
				if (plyr.flags & FL_ONGROUND && !(self.spawnflags & MISC_SHAKEVIEWONLY)) {
					d = self.dmg*d;
					plyr.velocity_x = plyr.velocity_x + (random()*d*2 - d);
					plyr.velocity_y = plyr.velocity_y + (random()*d*2 - d);
					plyr.velocity_z = plyr.velocity_z + (random()*d);
				}	
			}
		}
		// Find next entity in chain
		plyr = plyr.chain;
	}
	
	// keep shaking!
	self.nextthink = time + 0.1;
	self.think = misc_shake_think;
};

//----------------------------------------------------------------------
void() misc_shake_on = 
{
	self.estate = ESTATE_ON;

	// Play earthquake LOOP sound
	if (self.noise1) sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.attack_finished = time + self.wait;

	// keep checking for players to shake!
	self.nextthink = time + 0.1;
	self.think = misc_shake_think;
};

//----------------------------------------------------------------------
void() misc_shake =
{	
	if (self.sounds == 1) {
		self.noise1 = "misc/rumbleloop.wav";
		self.noise2 = "misc/rumbleoff.wav";
	}
	else {
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
		if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
	}
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	
	self.classtype = CT_MISCSHAKE;
	self.classgroup = CG_MISCENT;
	if (!self.dmg) self.dmg = 120;
	if (self.count <= 0) self.count = 200;
	if (self.wait <= 0) self.wait = 2;
	self.attack_finished = 0;

	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_shake_on;
	self.estate = ESTATE_OFF;
};

/*======================================================================
QUAKED misc_model (1 .5 .25) (-16 -16 -16) (16 16 16) x COLLISION x x x x STARTOFF x
MDL files that can be setup with specific frame/skin and animate groups
-------- KEYS --------
mdl : specify model to load, full path (progs/misc_candle1.mdl)
targetname : toggle state (use trigger ent for exact state)
angle  : facing angle (-1 = random position)
angles : 'pitch roll yaw' up/down, angle, tilt left/right 
ideal_yaw : = 1 Setup model with random Y axis rotation
pos1 : used for selection of frame(s) has several setups
  X=0, Y=0, Z=exact frame number
  X->Y, Z=0 Randomly pick a frame from the X,Y range
  X->Y, Z=-1 Animate between the X,Y range, can forward or backward setup
pos2 : used for the selection of skin(s) has several setups
  X=0, Y=0, Z=exact skin number
  X->Y, Z=0 Randomly pick a skin from the X,Y range
-------- SPAWNFLAGS --------
COLLISION : model bbox collision enabled
STARTOFF : Always Starts off and waits for trigger
-------- NOTES --------
MDL files that can be setup with specific frame/skin and animate groups

======================================================================*/
void() misc_model_loop =
{
	if (self.estate & ESTATE_BLOCK) return;
	
	self.height = self.height + self.lip;
	if (self.lip > 0 && self.height > self.pos1_y) self.height = self.pos1_x;
	else if (self.lip < 0 && self.height < self.pos1_y) self.height = self.pos1_x;
	
	self.frame = self.height;
	self.think = misc_model_loop;
	self.nextthink = time + self.speed;
};

//----------------------------------------------------------------------
void() misc_model_on =
{
	self.estate = ESTATE_ON;

	// Restore model/size and check if collision needed
	if (self.spawnflags & MISC_COLLISION) self.solid = SOLID_BBOX;
	setmodel (self, self.mdl);
	setsize (self, self.mins , self.maxs);
	setorigin(self, self.oldorigin + self.view_ofs);

	// Setup skin number (range or exact)	
	self.skin = self.pos2_z;

	if (self.partname)
		self.traileffectnum = particleeffectnum(self.partname);
	// Check for manual animation loops	
	if (self.pos1_z == -1) {
		self.height = self.pos1_x;
		if (self.pos1_x < self.pos1_y) self.lip = 1;
		else self.lip = -1;
		// Manually animate model
		misc_model_loop();
	}
	// Exact frame number
	else self.frame = self.pos1_z;
};

//----------------------------------------------------------------------
void() misc_model_off =
{
	// Turn off model/world interaction
	self.estate = ESTATE_OFF;
	self.model = string_null;
	self.solid = SOLID_NOT;
};



//----------------------------------------------------------------------
void() misc_model =
{
	// Is the model defined using the noise key?
	if (!self.mdl) {
		dprint("\b[MISCMDL]\b Missing model to load\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		remove(self);
		return;
	}

	precache_model (self.mdl);
	self.classtype = CT_MISCMODEL;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.oldorigin = self.origin;		// Store for later
		
	// Setting the angle key in the editor to UP/DOWN = random rotation	
	if (self.angles_y < 0) self.angles_y = rint(random()*360);
	self.mangle = self.angles;			// Save for later
	if (!self.speed) self.speed = 0.1;	// Manual animation tick speed
		
	// Has a frame range been defined?
	if (self.pos1_x != self.pos1_y) {
		// Make sure the range is the right way around
		// X has to be the lowest number of the two (X/Y)
		if (self.pos1_x > self.pos1_y) {
			self.frame_box = self.pos1_x;
			self.pos1_x = self.pos1_y;
			self.pos1_y = self.frame_box;
		}
		// Randomly pick frame number from a range? 
		// Work out random different and add to X base
		if (self.pos1_z == 0) {
			// Double check lower limit is not negative
			if (self.pos1_x < 0) self.pos1_x = 0;
			// Work out random range first and then add to base
			self.frame_box = fabs(self.pos1_y - self.pos1_x);
			self.pos1_z = self.pos1_x + rint(random()*self.frame_box);
			// Double check the frame is within the specified range
			if (self.pos1_z < self.pos1_x) self.pos1_z = self.pos1_x;
			if (self.pos1_z > self.pos1_y) self.pos1_z = self.pos1_y;
		}
		// Manual frame animation required
		else self.pos1_z = -1;
	}
	else {
		// If no exact frame bas specified, reset frame to default = 0
		if (self.pos1_z < 1) self.pos1 = '0 0 0';
	}
		
	// Has a skin range been defined?
	if (self.pos2_x != self.pos2_y) {
		self.pos2_z = rint( random() * fabs(self.pos2_y - self.pos2_x) );
	}
	else {
		// If no exact frame bas specified, reset frame to default = 0
		if (self.pos2_z < 1) self.pos2 = '0 0 0';
	}

	// Setup random rotation
	if (self.ideal_yaw > 0 && query_configflag(SVR_ITEMROTATE) == FALSE ) 
		self.angles_y = rint(random()*359);
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_model_on;
	self.estate_off = misc_model_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

//----------------------------------------------------------------------
// Allows GTK editors to work with Q1 assets easier
void() misc_gtkmodel = { misc_model(); };

//======================================================================
// All dead bodies use the same on/off states
//======================================================================
void() misc_deadbody_on =
{
	if (self.gibbed == TRUE) return;

	self.estate = ESTATE_ON;			// Show entity
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	setmodel(self,self.mdl);			// Show model
	setsize (self, self.bbmins, self.bbmaxs);
	self.bodyonflr = MON_ONFLR;			// Let Shadow Axe interact
};

//----------------------------------------------------------------------
void() misc_deadbody_off =
{
	if (self.gibbed == TRUE) return;

	self.estate = ESTATE_OFF;		// Hide entity
	self.solid = SOLID_NOT;			// No world interaction
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	setmodel(self,"");				// Show model
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.bodyonflr = "";			// No Shadows Axe interaction
};

//----------------------------------------------------------------------
void() misc_deadbody_setup =
{
	self.classtype = CT_MISCMODEL;
	self.classgroup = CG_MISCENT;
	self.oldorigin = self.origin;		// Store for later

	self.takedamage = DAMAGE_NO;		// No projectile interaction
	self.deadflag = DEAD_DEAD;			// Body is really dead!
	self.health = self.max_health = -1;
	self.blockudeath = TRUE;			// Body is dead, no human death noise
	self.gibbed = FALSE;				// Still in one piece!
	
	// Check for random rotation
	if (self.angles_y < 0) self.angles_y = rint(random()*360);
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_deadbody_on;
	self.estate_off = misc_deadbody_off;
	if (self.spawnflags & ENT_STARTOFF) entity_state_off();
	else entity_state_on();
};

/*=============================================================================
 FX drips (based on code from RRP by ijed)
 - Rewritten to not keep spawning endless entities
 - Modified to have on/off/toggle state

/*QUAKED misc_drip (0 .5 .8) (-8 -8 -8) (8 8 8) x SILENT x x BLOOD SLIME STARTOFF x
Falling water drip with splash and sound
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
wait       : random time between drips (=random() + self.wait)
-------- SPAWNFLAGS --------
BLOOD    : Blood red drips
SLIME    : Slime green drips
SILENT   : Don't make any drip sound (good for multiple drips)
STARTOFF : Always Starts off and waits for trigger
-------- NOTES --------
Falling water drip with splash and sound

=============================================================================*/
void() misc_drip_spawn;
void() misc_drip_reset =
{
	self.touch = SUB_Null;
	self.frame = self.flags = 0;
	setmodel (self, "");
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	self.velocity = self.avelocity = '0 0 0';
	self.nextthink = time + random() + self.wait;
	self.think = misc_drip_spawn;
};

//----------------------------------------------------------------------
// splash animation (runs at 20fps)
void() s_splash1 = [0, s_splash2] {self.nextthink = time+0.05;};
void() s_splash2 = [1, s_splash3] {self.nextthink = time+0.05;};
void() s_splash3 = [2, s_splash4] {self.nextthink = time+0.05;};
void() s_splash4 = [3, s_splash5] {self.nextthink = time+0.05;};
void() s_splash5 = [4, s_splash6] {self.nextthink = time+0.05;};
void() s_splash6 = [5, misc_drip_reset] {self.nextthink = time+0.05;};

//----------------------------------------------------------------------
void() misc_drip_touch =
{
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	// If water below, shift origin to water surface
	if (self.cnt) self.origin = self.pos1;
	setorigin(self, self.origin + '0 0 12');
	
	// play a random drip sound
	if (!(self.spawnflags & MISC_DRIPSILENT)) {
		self.lip = random() * 3;
		if (self.lip < 1) sound (self, CHAN_AUTO, self.noise1, 1, ATTN_STATIC);
		else if (self.lip < 2) sound (self, CHAN_AUTO, self.noise2, 1, ATTN_STATIC);
		else sound (self, CHAN_AUTO, self.noise3, 1, ATTN_STATIC);
	}	
	
	// small particle effect when hitting something
	particle (self.origin+'0 0 1', '0 0 0.5', self.aflag+random()*4, 5+random()*5);
	// Switch to splash sprite and animate for 5 frames
	setmodel (self, self.headmdl);
	s_splash1();
};

//----------------------------------------------------------------------
// Keep checking while falling for liquid impact
//----------------------------------------------------------------------
void() misc_drip_water =
{
	if (self.attack_finished < time) misc_drip_reset();
	// Extremely simplified water surface check (pre-calculated)
	if (self.origin_z < self.pos1_z) misc_drip_touch();
	self.nextthink = time + 0.1;
};

//----------------------------------------------------------------------
// Setup new drip and wait for touch/death/water
//----------------------------------------------------------------------
void() misc_drip_spawn =
{
	// Is the entity OFF or BLOCKED?
	if (self.estate & ESTATE_BLOCK) return;

	// Move drip to start position and setup sprite	
	self.effects = EF_LOWPRECISION;
	setorigin (self, self.oldorigin);
	setmodel (self, self.mdl);
	self.solid = SOLID_TRIGGER;
	if (self.cnt) self.movetype = MOVETYPE_NOCLIP;
	else self.movetype = MOVETYPE_FLY;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	if (self.netname == "gibsplat")
	{
		self.velocity = 0;
		self.frame = 1;
		self.movetype = MOVETYPE_TOSS;
		self.gravity = .8;
		self.colormod = '.3 0 0';
		if (BLD >= MAX_DRIPS)
		{
			BLD--;
			remove(self);
		}
	}
	else
		self.velocity_z = -500;
	if (self.spawnflags & MISC_RAIN)
		self.velocity = '-70 -40 -500';
	//self.velocity_z = -map_gravity;

	// Drip only lasts 3s, don't want to travel forever
	self.think = misc_drip_reset;
	self.nextthink = time + 3;
	self.touch = misc_drip_touch;
	

	// Is there any water underneath drip?
	if (self.cnt) {
		self.attack_finished = self.nextthink;
		self.nextthink = time + 0.1;
		self.think = misc_drip_water;
	}
};

//----------------------------------------------------------------------
void() misc_drip_on =
{
	self.estate = ESTATE_ON;
	self.nextthink = time + random() + self.wait;
	self.think = misc_drip_spawn;
};

//----------------------------------------------------------------------
void() misc_drip =
{	
	// Pick type of drip sprite based on spawnflags
	if (self.spawnflags & MISC_DRIPBLOOD) {
		self.mdl = SBLOOD_DRIP;
		self.headmdl = SBLOOD_SPLASH;
		self.aflag = 64;
	}
	else if (self.spawnflags & MISC_DRIPSLIME) {
		self.mdl = SSLIME_DRIP;
		self.headmdl = SSLIME_SPLASH;
		self.aflag = 48;
	}
	else {
		self.mdl = SWATER_DRIP;
		self.headmdl = SWATER_SPLASH;
		self.aflag = 0;
	}
	// Default cache - water
	
	self.noise1 = "misc/drip1.wav";
	self.noise2 = "misc/drip2.wav";
	self.noise3 = "misc/drip3.wav";
	
	if (self.netname == "gibsplat")
	{
		self.noise1 = "gib/gibhit4.wav";
		self.noise2 = "gib/gibhit4.wav";
		self.noise3 = "gib/gibhit4.wav";
		self.mdl = "progs/s_dripsplred.spr";
		sendParticle("hldecal", self.origin - '0 0 10', '0 0 -100', 2);
	}
	
	precache_model (self.mdl);
	precache_model (self.headmdl);
	
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);

	// default frequency to 3 seconds
	if (self.wait <= 0) self.wait = 3;
	
	if (self.spawnflags & MISC_RAIN)
	{
		self.gravity = 0;
		if (coop || deathmatch)
			remove(self);
	}

	self.classtype = CT_MISCDRIP;
	self.classgroup = CG_MISCENT;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);

	// Check point content for wierd setups (inside liquids/solids)
	self.height = pointcontents(self.origin);
	if (self.height < CONTENT_SOLID) {
		dprint ("\b[MISCDRIP]\b Spawned inside liquid!\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	// If flush against a ceiling, move slightly down
	else if (self.height == CONTENT_SOLID) {
		self.origin_z = self.origin_z - 2;
	}
	
	// Setup drip particle in the correct start location
	self.oldorigin = self.origin;
	setorigin(self, self.origin);

	// Find out bottom (world) position first
	self.pos1 = self.origin;
	traceline (self.pos1, self.pos1 + '0 0 -4096', TRUE, self);
	self.pos2 = trace_endpos;

	// Only do loop test if water exists below
	self.count = 8;
	if (trace_inwater) self.cnt = TRUE;
	else self.count = 0;

	// Binary divide the distance to find water surface
	while (self.count > 0) {
		// Break out early from loop if <8 from water surface
		if (fabs(self.pos2_z-self.pos1_z) < 8) self.count = 0;
		// Calculate midway point between origin and endtrace
		self.pos3 = self.pos1;
		self.pos3_z = self.pos1_z + ((self.pos2_z - self.pos1_z)*0.5);

		// Test which half has water and shift top/bottom positions
		traceline (self.pos1, self.pos3, TRUE, self);
		if (trace_inwater) self.pos2 = self.pos3;
		else self.pos1 = self.pos3;
		// Only loop a limited amount of times
		self.count = self.count - 1;
	}
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_drip_on;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// Re-direct to correct entity name
void() fx_drip = { misc_drip(); };



