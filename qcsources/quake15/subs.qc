

void() SUB_Null = {};

void() SUB_Remove = {remove(self);};


/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
vector() SetMovedir =
{
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	self.angles = '0 0 0';
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
// trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
local entity	stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
local vector	vdestdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// calculate length of vector
	len = vlen (vdestdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


/*
=============
SUB_CalcAngleMove

calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating 

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
local entity		stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
local vector	destdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");
		
// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	
// calculate length of vector
	len = vlen (destdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


//=============================================================================

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/
void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;

//
// check for a delay
//
	if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	
	
//
// print the message
//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint (activator, self.message);
		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

//
// kill the killtagets
//
	if (self.killtarget)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.killtarget);
			if (!t)
				return;
			remove (t);
		} while ( 1 );
	}
	
//
// fire targets
//
	if (self.target)
	{
		act = activator;
		t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t)
			{
				return;
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while ( 1 );
	}
	

};


/*

in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically

*/

void(float normal) SUB_AttackFinished =
{
	self.cnt = 0;		// refire count for nightmare
	if (skill != 3)
		self.attack_finished = time + normal;
};

float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire =
{
	if (skill != 3)
		return;
	if (self.cnt == 1)
		return;
	if (!visible (self.enemy))
		return;
	self.cnt = 1;
	self.think = thinkst;
};


//MY REMOVE


//----------------------------------------------------------------------
// Not used anywhere in QC
//----------------------------------------------------------------------
/*float() SUB_CountTargets =
{
	local entity t;
	local float i;
	
	i = 0;
	if (self.target != "") {
		t = world;
		do	{
			t = find(t, targetname, self.target);
			if (!t) break;
			i = i + 1;
		} while ( 1 );
	}
	return i;
};*/

/*======================================================================
 ChooseTurn 
 - can't find any reference to this in the QC
======================================================================*/
/*void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0) {
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else {
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};*/

/*======================================================================
 SPAWN_TFOG and SPAWN_TDEATH
 
 These functions were originally in triggers.qc, but are used all
 over the place by monsters, items and players. Subs seems a better
 home for these generic functions.

 ======================================================================*/

/*======================================================================
 skill_chanceattack
  Calculate chance to attack player based on skill level and distance
  The standard ID range formula
	(enemy_range == RANGE_MELEE) chance = 0.9
	(enemy_range == RANGE_NEAR) chance = 0.4
	(enemy_range == RANGE_MID) chance = 0.05
	else chance = 0;
	The problem with this formula is that the chance factor is not gradual
	and will spike in chance when close to range boundaries
	Also this formula has no skill modifiers leading to limited gameplay rules
  
======================================================================*/

/*======================================================================
 SUB_Tracking
 Progressively tracks the origin of enemies making attacks more accurate
  * Original code by Necros (http://shoresofnis.com/)
======================================================================*/
vector(vector iorg, vector org_offset, entity targ, float zspeed) SUB_Tracking =
{
	local	vector	vec, org;
	local	float	diff;

	// Allow for source origin to be fine tuned (directional)
	makevectors (self.angles);
	org = self.origin + org_offset_x * v_forward + org_offset_y * v_right + org_offset_z * v_up;

	diff = vlen(iorg - org) / zspeed;				// Workout difference
	vec = targ.velocity;
	if (targ.flags & FL_MONSTER) vec_z = 0;	// Flatten Z axis for monsters
	else vec_z = vec_z * 0.2;								// Aim for headshot with players

	iorg = targ.origin + diff * vec;				// Refine target origin
	return iorg;
};

/*======================================================================
 SUB_Elevation
  Calculates the Elevation for Z Aware monsters
  * Original code by Preach (https://tomeofpreach.wordpress.com/)
  * Added support for variable origin locations and proj speeds
  * Added support for distance scaling linked to skill levels
======================================================================*/

/*======================================================================
 SUB_Elevat (Alternative version, not used anymore, left for reference)
  Calculates the Elevation for Z Aware monsters
  * Original formula WIKI with QC help from ericw
======================================================================*/
/*float(vector source, vector targ, float zspeed) SUB_Elevat =
{
	local float g;				// Gravity
	local float targx, targy;	// Sub parts of distance
	local float v2, v4;			// speed*speed & speed*speed*speed*speed
	local vector dist;			// Distance to travel	
	local float ang, theta;
	
	g = map_gravity;			// default 800
	dist = targ - source;		// vector distance
	targy = dist_z;				// Up direction
	dist_z = 0;
	targx = vlen(dist);			// X,Y direction

	v2 = zspeed * zspeed;
	v4 = v2 * v2;
	
	// First part of equation
	ang = v4 - (g * ( (g * targx * targx) + (2 * targy * v2) ) );
	// Cap elevation angle at default value
	//if(ang < 0) return ELEV_DEFAULT;

	// Second section of equation
	theta = mathlib_atan2 ((v2 - mathlib_sqrt(ang)) / (g * targx),1);
	return theta;
}; */
