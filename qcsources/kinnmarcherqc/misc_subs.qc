// ben - was in weapons.qc
float() crandom =
{
	return 2*(random() - 0.5);
};


void() SUB_Null = {};

void() SUB_Remove = {remove(self);};


/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
//vector() SetMovedir =		//bdw 05/11/04 - changed to void()
void() SetMovedir =
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

//a bit hacky, but this can come in useful...
void() BDW_NullExtraTargets =
{
	self.target1 = "";
	self.target2 = "";
	self.target3 = "";
	self.target4 = "";
	self.target5 = "";
	self.triggerfunction = SUB_Null;
	self.triggerconsole = "";
	//todo: should message and killtarget also be nulled?
};

void(string extratarget, float extradelay) BDW_UseExtraTargets = 
{
	local entity t, stemp, otemp, act;

	if (extradelay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + extradelay;
		t.think = DelayThink;
		t.enemy = activator;
		t.target = extratarget;
		return;
	}

	if (extratarget)
	{
		act = activator;
		t = find (world, targetname, extratarget);

		while (t)
		{			
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

			t = find (t, targetname, extratarget);
		} 
	}

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
	
//bdw - this is new stuff...you can specify up to five extra targets (with corresponding delays)
//works just like normal target/delay but without all the fancy gizmos (no message, killtarget, triggerfunction etc.)
//basically, this just reduces the need for trigger_relays, and saves you a few edicts in the process.

	if (self.target1 != "")
		BDW_UseExtraTargets(self.target1, self.delay1);
	if (self.target2 != "")
		BDW_UseExtraTargets(self.target2, self.delay2);
	if (self.target3 != "")
		BDW_UseExtraTargets(self.target3, self.delay3);
	if (self.target4 != "")
		BDW_UseExtraTargets(self.target4, self.delay4);
	if (self.target5 != "")
		BDW_UseExtraTargets(self.target5, self.delay5);

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
	//bdw - new stuff...
		t.triggerconsole = self.triggerconsole;
		t.triggerfunction = self.triggerfunction;

		return;
	}

//bdw - new, powerful stuff - use wisely...
	if (self.triggerfunction)	//will execute a qc function (careful - very powerful!)
	{
		otemp = other;
		other = activator;	//used if you want to call touch functions
		self.triggerfunction();
		other = otemp;
	}

	if (self.triggerconsole != "")
	{
		if (activator.flags & FL_CLIENT)	//will trigger a command as if it had been typed on the activator's console
		{
			stuffcmd(activator, self.triggerconsole);
			stuffcmd(activator, "\n");
		}			
	}
//bdw end	
	if ( (activator.classname == "player") && (self.message != "") )
	{
		centerprint(activator, self.message);
		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}
//bdw - killtarget bit rewritten - this way it doesn't quit the function...
	if (self.killtarget != "")
	{
		t = find(world, targetname, self.killtarget);

		while(t)
		{
			//remove(t);
			BDW_TouchRemove(t);	//bdw - a safer way of doing it
			t = find(t, targetname, self.killtarget);
		}
	}
//bdw - target firing bit rewritten - this way it doesn't quit the function...
	if (self.target != "")
	{
		act = activator;
		t = find (world, targetname, self.target);

		while (t)
		{			
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

			t = find (t, targetname, self.target);
		} 
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
