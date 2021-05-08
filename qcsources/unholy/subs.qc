

void() SUB_Null = {};

void() SUB_Remove = {remove(self);};


/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
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
		t.noise = self.noise;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	//jbprint("Entering SUB_UseTargets for ",self.classname,".",self.targetname," targeting '",self.target,"'\n");
//
// print the message
//
	if ((activator.classname == "player" || activator.owner.classname == "player" || activator.classname == "func_puppet" || self.team==1) && self.message != "")
	{
		centerprint (player, self.message);
		if (!self.noise)
			sound (player, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
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
				//return;
				break; //Inky 20210110
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
			//jbprint("Looking for targetname '",self.target,"'\n");
			t = find (t, targetname, self.target);
			if (!t) return;
			//jbprint("found a matching ",t.classname,"\n");

			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
				{
					//jbprint("   About to call ",self.classname,".",self.targetname,".use()\n");
					self.use ();
				}
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

//========= Inky addins =========


/*
====================================================================
SUB_CalcMoveAndAngle()
MG!!!

Calculates self.velocity and self.nextthink to reach dest from
self.origin traveling at speed, does same with angle simultaneously.
====================================================================
*/

/*
 * SUB_CalcMoveAndAngleDone-Set angle and position in final states.
 */

void SUB_CalcMoveAndAngleDone(void)
{
//	dprint("Angle and move done\n");
	setorigin(self, self.finaldest);
	self.angles = self.finalangle;
	if(self.wait!=0||self.enemy.classname!="path_corner")
	{
		self.velocity = self.avelocity = '0 0 0';
		self.nextthink = -1;
	}
	else
		self.nextthink = time + 99999999;
	if (self.think1!=SUB_Null)
	{
//		dprint("Going to next func\n");
		self.think1();
	}
//	else
//		dprint("No next func\n");
}

void()SUB_CalcMoveOnlyDone;

void SUB_CalcAngleOnlyDone(void)
{
//	dprint("Angle done\n");
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.angletime = 0;
	if(self.movetime>0.01)//1/5th of a frame
	{
		self.think=SUB_CalcMoveOnlyDone;
		self.nextthink=self.ltime+self.movetime;//was 0.0000002384, and would not think
//		dprintf("Movetime*1000000000 - %s\n",self.movetime*1000000000);
//		dprintf("ETA - %s\n",(self.nextthink - self.ltime));
//		dprintf("Ltime - %s\n",self.ltime);
//		dprintf("Nextthink - %s\n",self.nextthink);
	}
	else
		SUB_CalcMoveAndAngleDone();
}

void SUB_CalcMoveOnlyDone(void)
{
//	dprint("Move done\n");
	setorigin(self, self.finaldest);
	if(self.wait!=0||self.enemy.classname!="path_corner")
		self.velocity = '0 0 0';
	self.movetime=0;
	if(self.angletime>0.01)//1/5th of a frame
	{
		self.think=SUB_CalcAngleOnlyDone;
		self.nextthink=self.ltime+self.angletime;
//		dprintf("ETA - %s\n",self.nextthink - self.ltime);
	}
	else
		SUB_CalcMoveAndAngleDone();
}

void SUB_CalcMoveAndAngle (float synchronize)
{
vector vdestdelta, destdelta;
float  len, alen;
//MOVE
	if(!self.speed)
		objerror("No speed is defined!");

	if(self.finaldest == self.origin)
	{
		self.velocity = '0 0 0';
		self.movetime = 0;
	}
	else
	{
		vdestdelta = self.finaldest - self.origin;	// set destdelta to the vector needed to move
		len = vlen(vdestdelta); 			// calculate length of vector
		self.movetime = len / self.speed;			// divide by speed to get time to reach dest

		if(self.movetime < 0.1)
		{
			self.velocity  = '0 0 0';
			self.movetime = 0.1;
		}
		// scale the destdelta vector by the time spent traveling to get velocity
		self.velocity = vdestdelta * (1/self.movetime);	// hcc won't take vec/float	
	}


//ANGLE

	if(self.angles==self.finalangle)
	{	
			self.avelocity = '0 0 0';
			self.angletime = 0;
	}
	else
	{
		destdelta = self.finalangle - self.angles;	// set destdelta to the vector needed to move
		alen = vlen(destdelta);					// calculate length of vector
		if(!synchronize)
		{
			if(!self.anglespeed)
				objerror("SUB_CalcAngleMove: No speed defined!");
		}
		else
			self.anglespeed=self.speed/len*alen;				//
		self.angletime = alen / self.anglespeed;				// divide by speed to get time to reach dest
// scale the destdelta vector by the time spent traveling to get velocity
		self.avelocity	= destdelta * (1 / self.angletime);
	}
//	if(synchronize&&self.angletime!=self.movetime)
//		dprint("Whoops!\n");


// set nextthink to trigger a think when dest is reached

	if(self.movetime<=0)
		self.movetime=self.angletime;
	if(self.angletime<=0)
		self.angletime=self.movetime;

	if(self.movetime>self.angletime)
	{
		self.movetime-=self.angletime;
		self.think = SUB_CalcAngleOnlyDone;
		self.nextthink=self.ltime+self.angletime;
//		dprintf("1: ETA - %s\n",self.nextthink - self.ltime);
	}
	else if(self.movetime<self.angletime)
	{
		self.angletime-=self.movetime;
		self.think = SUB_CalcMoveOnlyDone;
		self.nextthink=self.ltime+self.movetime;
//		dprintf("2: ETA - %s\n",self.nextthink - self.ltime);
	}
	else
	{
		self.think = SUB_CalcMoveAndAngleDone;
		self.nextthink=self.ltime+self.movetime;
//		dprintf("3: ETA - %s\n",self.nextthink - self.ltime);
	}
}

/*
 * SUB_CalcMoveAndAngleInit-Set movement values and call main function
 */
void(vector tdest, float tspeed, vector destangle, float aspeed,void() func,float synchronize) SUB_CalcMoveAndAngleInit =
{
	self.finaldest = tdest;
	self.speed = tspeed;
	self.finalangle = destangle;
	self.anglespeed = aspeed;
	self.think1 = func;
//	if(self.think1==SUB_Null)
//		dprint("No next func!\n");
	SUB_CalcMoveAndAngle(synchronize);
};