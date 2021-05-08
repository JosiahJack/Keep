/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/*
	Written by Frank Condello <pox@planetquake.com>
	
	Misc functions/entities....
	
	func_ladder
	func_explobsp
	func_breakaway
	func_nodraw
	func_bspframe
	func_model
*/

//============================================================================

float LADDEROFS = 0.36;// touchy...

// This is tricky cause we can't just check key presses...
void() ladder_touch =
{
	local vector vel;
	float fvel, spd;
	
	if (other.classname != "player") return;
	
	// FIXME! - time out for teleporters?
	
	// Don't stick underwater, or in the middle of a waterjump
	if (other.waterlevel > 1 || other.fwatershifttime > time) return;
	if (other.flags & FL_WATERJUMP) return;
	
	// Don't re-grab right away if jumping
	if (other.ladderjump > time) return;
	
	// Check if the player can grab the ladder
	makevectors (other.angles);
	if (v_forward*self.movedir<-0.5)// a little more than 180¼ of freedom
		return;// not facing the right way
	
	// Avoid problems if the player is on the top edge (act like an 8 unit step)
	if (other.origin_z + other.mins_z + 8 >= self.absmax_z) {
		if (!(other.flags & FL_ONGROUND))
			other.flags = other.flags + FL_ONGROUND;
		return;
	}
	
	// Null out gravity in PreThink
	other.laddertime = other.zerogtime = time + 0.1;

/*	FIXME! - Physics on a moving ladder don't quite work
	// Factor in the parent train's movement
	if (self.owner) {
		
		// Stop all vertical movement
		other.velocity_z = self.owner.velocity_z;
		
		// Check if the player is moving sideways (don't go up/down)
		if (v_right*(other.velocity - self.owner.velocity) > 25) {
			other.velocity = self.owner.velocity;
			other.origin = other.origin + v_right*0.5;
			return;
		}
		else if (v_right*(other.velocity - self.owner.velocity) < -25) {
			other.velocity = self.owner.velocity;
			other.origin = other.origin - v_right*0.5;
			return;
		}
		
		// Get the player's forward speed	
		fvel = v_forward*(other.velocity - self.owner.velocity);
	
	} else {// Stationary		
*/	
		// Stop all vertical movement
		other.velocity_z = 0;
		
		// Check if the player is moving sideways (don't go up/down)
		/*if (fabs(v_right*other.velocity) > 25) {
			other.velocity = '0 0 0';
			return;
		}*/
		if (v_right*other.velocity > 25) {
			other.velocity = '0 0 0';
			other.origin = other.origin + v_right*0.5;// boost strafes
			return;
		}
		else if (v_right*other.velocity < -25) {
			other.velocity = '0 0 0';
			other.origin = other.origin - v_right*0.5;// boost strafes
			return;
		}
		
		// Get the player's forward speed	
		fvel = v_forward*other.velocity;
//	}
	
	vel = '0 0 0';// Our new velocity
	
	// Up (facing up/forward)
	if (other.v_angle_x <= 15 && fvel>0 ) {
		other.origin = other.origin - self.movedir*LADDEROFS;// Pull back to keep from hitting the backing wall
		vel_z = fabs(other.v_angle_x)*6;// go faster when facing forward	
		if (vel_z < 90) vel_z = 90;// minimum speed
	}
	// Up (facing down)
 	else if ( other.v_angle_x >= 15 && fvel<0 ) {
		other.origin = other.origin + self.movedir*LADDEROFS;// Pull in to keep from falling off
		vel_z = other.v_angle_x*4;
	}
	// Down (facing up/forward)
	else if (other.v_angle_x <= 15 && fvel<0 ) {	
		other.origin = other.origin + self.movedir*LADDEROFS;// Pull in to keep from falling off
		vel_z = fabs(other.v_angle_x)*-5;// go faster when facing forward	
		if (vel_z > -80) vel_z = -80;// minimum speed
	}
	// Down (facing down)
	else if ( other.v_angle_x >= 15 && fvel>0 ) {		
		other.origin = other.origin - self.movedir*LADDEROFS;// Pull back to keep from hitting the backing wall
		vel_z = other.v_angle_x*-4;
	}
	
	// Cap vertical moves to the server limits
	spd = cvar("cl_upspeed");
	if (vel_z > spd) vel_z = spd;
	else if (vel_z < -1*spd) vel_z = -1*spd;
	
	// Add the parent's velocity - FIXME! - Physics on a moving ladder don't quite work
	//if (self.owner) vel = vel + self.owner.velocity;
	
	// Set the player's new veloctity
	other.velocity = vel;
};

/*QUAKED func_ladder (0 .5 .8) ?
Creates an invisible trigger area that the player can "climb" vertically.

Dependant on additions in client.qc, and player.qc

The movement was initially intended to mimic ladders in RTCW, but there
are some differences due to QuakeC limitations, and personal preference
(jumping behaviour and speed can easily be changed).

"angle" The direction the player must be facing in order to climb
"targetname" use as a killtarget to delete the ladder
DISABLED: "target" Attach the ladder to a func_train_ext

------------------------------------------------------------------------------------
BUGS:
- up/down keys don't climb (only way is to use MOVETYPE_FLY, which means current touch code is useless)
- DISABLED: physics break when the player is trying to move in the same direction as a ladder's parent train

------------------------------------------------------------------------------------
USEAGE NOTES:

These work best when they are at least 8 units thick.

Make sure the angle is set correctly. All movement revolves around the ladder's
facing angle. (Remember: It's the angle the PLAYER must be facing to climb)

The top of the func_ladder brush should be flush with the top of the ledge (if the
ladder leads to a ledge). Ladders behave as if there's an 8 unit "step" at the top.

It's a good idea to back these up with a solid brush or a clipping brush.
Especially if using real geometry for the rungs. (i.e. to fill the gaps between the rungs)

If you need a "two-way" ladder (like a ladder hanging from a fire-escape) use a clip
brush in the middle, and two func_ladders on either end with opposite facing angles.

Avoid situations where more than one func_ladder can be touched at the same time.

*/
void() func_ladder =
{
	InitTrigger();
	self.touch = ladder_touch;

/*	FIXME! - Physics on a moving ladder don't quite work
	// Attach the ladder to it's parent
	if (self.target) {
		self.think = train_ext_linkchild;
		self.nextthink = time + 0.2;
	}
*/
};

//============================================================================

float HEAL = 1;
float BLEED = 2;

void() explobsp_explode =
{
	local	entity new, stemp;
	
	self.takedamage = DAMAGE_NO;
		
	activator = damage_attacker;
	self.delay = 0.01;// Don't fire targets right away, since they might be inside
	SUB_UseTargets ();
	
	// Make an explosion at the center
	new = spawn();
	new.origin = self.dest;
	new.movetype = MOVETYPE_NONE;
	new.solid = SOLID_NOT;
	setorigin(new, new.origin);
	new.classname = "explo_box";

	T_RadiusDamage (new, new, self.dmg, world);
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, new.origin_x);
	WriteCoord (MSG_BROADCAST, new.origin_y);
	WriteCoord (MSG_BROADCAST, new.origin_z);
	
	stemp = self;
	self = new;
	BecomeExplosion ();
	self = stemp;
	
	// Go into exploded frame, or disappear
	if (self.mdl)
		setmodel(self, self.mdl);
	else
		remove(self);
};

void(entity attacker, float damage) explobsp_hurt =
{
	if (self.spawnflags & HEAL) {
		self.health = self.max_health;
		return;
	}
};

/*QUAKED func_explobsp (0 .5 .8) ?
Basically just like misc_explobox, but uses whatever geometry ya like.
The explosion occurs at the exact center of the brushes, so keep that in mind.

"health" 		Maximum health
"dmg" 			Amount of damage caused by explosion
"target"		Activate this when exploding
"targetname" 	Can be targeted by a func_bspframe or for exploding remotely

"HEAL"			Only dies if one shot of damage is greater than health (heals small damage)

*/
void() func_explobsp =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	
	setmodel (self, self.model);
   	setsize( self, self.mins, self.maxs );
	
	precache_sound ("weapons/r_exp3.wav");
	
	if (!self.health) self.health = 20;
	if (!self.dmg) self.dmg = 160;
	
	// Center of the volume
	self.dest = (self.mins + self.maxs)*0.5;
	
	self.th_pain = explobsp_hurt;
	self.th_die = explobsp_explode;
	self.use = explobsp_explode;
	self.takedamage = DAMAGE_AIM;
	self.nobleed = TRUE;
};

//============================================================================

void() breakaway_break =
{	
	self.takedamage = DAMAGE_NO;
	
	if (self.noise1)
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);	
		
	activator = damage_attacker;
	self.delay = 0.01;// Don't fire targets right away, since they might be inside
	SUB_UseTargets ();
	
	// Go into exploded frame, or disappear
	if (self.mdl) {
		self.frame = 0;
		setmodel(self, self.mdl);
	} else
		remove(self);
};

void(entity attacker, float damage) breakaway_hurt =
{
	if (self.noise1)
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);	
	
	if (self.spawnflags & HEAL) {
		self.health = self.max_health;
		return;
	}
	
	if (!self.frame && self.health <= self.frags)
		self.frame = 1;
};


/*QUAKED func_breakaway (0 .5 .8) ? HEAL BLEED
This is a simple BSP model that goes away (or becomes it's alternate frame) when killed.
These can be used to mimic "gibbable" objects when combined with emitters, or on their
own for small breakable panels.

"health" 		Maximum health
"frags"			Use alt texture when "health" equals or is less than this
"noise"			noise to make when dying (breaking)
"noise1"		noise to make when taking damage
"target"		Activate this when dying (i.e. target an emitter to generate rubble)
"targetname" 	Can be targeted by a func_bspframe or for triggering remotely

"HEAL"			Only dies if one shot of damage is greater than health (heals small damage)
"BLEED"			Show blood effect instead of sparks when shot

*/
void() func_breakaway =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	
	setmodel (self, self.model);
   	setsize( self, self.mins, self.maxs );
	
	if (self.noise)	precache_sound (self.noise);
	if (self.noise1) precache_sound (self.noise1);
	if (!self.health) self.health = 20;
	
	self.max_health = self.health;
	
	if (!(self.spawnflags & BLEED))
		self.nobleed = TRUE;

	self.th_pain = breakaway_hurt;
	self.th_die = breakaway_break;
	self.use = breakaway_break;
	self.takedamage = DAMAGE_AIM;
};

//============================================================================

/*QUAKED func_nodraw (0 .5 .8) ? 1
Like func_wall, but is invisible by default, and has no think/use.

Spawnflags:

"1" Show brush geometry

*/
void() func_nodraw =
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	
	setmodel (self, self.model);

	if (!(self.spawnflags & 1))
		self.model = string_null;
};

//============================================================================

// Transfer mdl to owner
void() bspframe_init =
{
	local entity	targ;
	
	targ = find (world, targetname, self.target);
	
	if (targ.classname == "func_switch" ||
		targ.classname == "func_explobsp" ||
		targ.classname == "func_breakaway")
		targ.mdl = self.mdl;
	
	remove(self);
};

/*QUAKED func_bspframe (0 .5 .8) ?
A little hack to allow alternate bsp model "frames" for certain ents

"target"	The owner object

NOTE:

When used on solid objects (like func_explobsp) insure these won't stick into nearby
players/monsters
when the parent object switches frames. (i.e. make this object smaller
than the parent, or create
a clip area that encompases both object frames)

*/
void() func_bspframe =
{
	if (!self.target) objerror("func_bspframe without target");
	
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.mdl = self.model;

	self.modelindex = 0;
	self.model = "";
	
	self.nextthink = time+0.1;
	self.think = bspframe_init;
};

//============================================================================

/*QUAKED func_model (.5 .5 .5) (-8 -8 -8) (8 8 8) ? 1
Places a static model, or can optionally become a corpse (gibbable).
Corpses will drop to the floor, but static models just hang at the origin.
Static models don't collide (surround it with clip brushes, or func_nodraw
if this is a problem).

"mdl"		Path to the model
"frame"		Animation frame
"mangle"	X Y Z Orientation

Spawnflags:
"1"		Turn it into a corpse

NOTES:

Corpses have a height of 2 units, so don't expect to use a run frame and be able
to shoot anything but the feet.

Messing with any angle other than the Y (yaw) angle is usually asking for trouble
(unless ou know what you're doing).

*/
void() func_model =
{
	if (!self.mdl) objerror("func_model with no model");
	
	precache_model (self.mdl);
	self.model = self.mdl;
	setmodel (self, self.model);
	setorigin (self, self.origin);
	
	if (!self.mangle) self.mangle = '0 0 0';
	self.angles = self.mangle;
	
	if (self.spawnflags & 1)
		become_corpse();
	else
		makestatic (self);
};

//============================================================================

// Keep extra global precaches seperate for the sake of being neat (call from worldspawn)
void() extra_precache =
{
	// Step/Swim sounds
	precache_sound ("misc/uwater.wav");	
	precache_sound ("misc/inh2ob.wav");	
	precache_sound ("misc/owater2.wav");
	precache_sound ("misc/foot1.wav");
	precache_sound ("misc/foot2.wav");
	precache_sound ("misc/foot3.wav");
	precache_sound ("misc/foot4.wav");
	
	// Weapon FX
	precache_model ("progs/spark.spr");
	precache_model ("progs/shell.mdl");
	precache_sound ("weapons/tink2.wav");
	
	// Corpse
	precache_sound ("wizard/hit.wav");
};
