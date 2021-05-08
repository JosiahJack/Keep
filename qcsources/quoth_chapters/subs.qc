

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

//necros: added Custents multi target/targetname/killtarget triggering.

/* ### (added targets, killtargets, and targetnames)
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
or killtarget2, so some events can remove other triggers.

Search for (string)targetname, targetname2, targetname3, and targetname 4
in all entities that match (string)self.target, self.target2, self.target3,
or self.target4 and use their .use function.
==============================
*/
void(string matchstring, .string matchfield) SUB_UseSpecificTarget =
{
	local entity t, stemp, otemp, act;

	act = activator;
	t = find (world, matchfield, matchstring);
	while ( t != world )
	{
		stemp = self;
		otemp = other;
		self = t;
		other = stemp;
		if (self.use != SUB_Null)
		{
			if (self.use)
			{
				lastnameused = matchstring;
				self.use ();
			}
		}
		self = stemp;
		other = otemp;
		activator = act;
		t = find (t, matchfield, matchstring);
	}
};

void() SUB_UseTargets =
{
//	local entity t, stemp, otemp, act;
	local entity t;

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
		t.killtarget2 = self.killtarget2;
		t.target = self.target;
		t.target2 = self.target2;
		t.target3 = self.target3;
		t.target4 = self.target4;
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
// fire targets
//

// target 1
	if (self.target)
	{
		SUB_UseSpecificTarget(self.target, targetname);
		SUB_UseSpecificTarget(self.target, targetname2);
		SUB_UseSpecificTarget(self.target, targetname3);
		SUB_UseSpecificTarget(self.target, targetname4);
	}

// target 2
	if (self.target2)
	{
		SUB_UseSpecificTarget(self.target2, targetname);
		SUB_UseSpecificTarget(self.target2, targetname2);
		SUB_UseSpecificTarget(self.target2, targetname3);
		SUB_UseSpecificTarget(self.target2, targetname4);
	}

// target 3
	if (self.target3)
	{
		SUB_UseSpecificTarget(self.target3, targetname);
		SUB_UseSpecificTarget(self.target3, targetname2);
		SUB_UseSpecificTarget(self.target3, targetname3);
		SUB_UseSpecificTarget(self.target3, targetname4);
	}

// target 4
	if (self.target4)
	{
		SUB_UseSpecificTarget(self.target4, targetname);
		SUB_UseSpecificTarget(self.target4, targetname2);
		SUB_UseSpecificTarget(self.target4, targetname3);
		SUB_UseSpecificTarget(self.target4, targetname4);
	}



//moved killtarget code beneath target code so that triggers that killtarget themselves can fire off their targets before they are removed.

//
// kill the killtarget entities
//
	if (self.killtarget)
	{
		t = find(world, targetname, self.killtarget);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname, self.killtarget);
		}
		t = find(world, targetname2, self.killtarget);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname2, self.killtarget);
		}
		t = find(world, targetname3, self.killtarget);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname3, self.killtarget);
		}
		t = find(world, targetname4, self.killtarget);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname4, self.killtarget);
		}
	}

//
// kill the killtaget2 entities
//
	if (self.killtarget2)
	{
		t = find(world, targetname, self.killtarget2);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname, self.killtarget2);
		}
		t = find(world, targetname2, self.killtarget2);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname2, self.killtarget2);
		}
		t = find(world, targetname3, self.killtarget2);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname3, self.killtarget2);
		}
		t = find(world, targetname4, self.killtarget2);
		while(t != world)
		{
			remove(t);
			t = find(t, targetname4, self.killtarget2);
		}
	}






};

void(string matchstring) SUB_UseName =
{
	SUB_UseSpecificTarget(matchstring, targetname);
	SUB_UseSpecificTarget(matchstring, targetname2);
	SUB_UseSpecificTarget(matchstring, targetname3);
	SUB_UseSpecificTarget(matchstring, targetname4);
};
// ### end of Custents triggering code

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


//=========================
//
// SUB_CopyEntity
//
//=========================

void (entity srcent, entity destent) SUB_CopyEntity =
{
	destent.modelindex=srcent.modelindex;
	destent.absmin=srcent.absmin;
	destent.absmax=srcent.absmax;
	destent.ltime=srcent.ltime;
	destent.movetype=srcent.movetype;
	destent.solid=srcent.solid;
	destent.origin=srcent.origin;
	destent.oldorigin=srcent.oldorigin;
	destent.velocity=srcent.velocity;
	destent.angles=srcent.angles;
	destent.avelocity=srcent.avelocity;
	destent.punchangle=srcent.punchangle;
	destent.classname=srcent.classname;
	destent.model=srcent.model;
	destent.frame=srcent.frame;
	destent.skin=srcent.skin;
	destent.effects=srcent.effects;
	destent.mins=srcent.mins;
	destent.maxs=srcent.maxs;
	destent.size=srcent.size;
	destent.touch=srcent.touch;
	destent.use=srcent.use;
	destent.think=srcent.think;
	destent.blocked=srcent.blocked;
	destent.nextthink=srcent.nextthink;
	destent.groundentity=srcent.groundentity;
	destent.health=srcent.health;
	destent.frags=srcent.frags;
	destent.weapon=srcent.weapon;
	destent.weaponmodel=srcent.weaponmodel;
	destent.weaponframe=srcent.weaponframe;
	destent.currentammo=srcent.currentammo;
	destent.ammo_shells=srcent.ammo_shells;
	destent.ammo_nails=srcent.ammo_nails;
	destent.ammo_rockets=srcent.ammo_rockets;
	destent.ammo_cells=srcent.ammo_cells;
	destent.items=srcent.items;
	destent.takedamage=srcent.takedamage;
	destent.chain=srcent.chain;
	destent.deadflag=srcent.deadflag;
	destent.view_ofs=srcent.view_ofs;
	destent.button0=srcent.button0;
	destent.button1=srcent.button1;
	destent.button2=srcent.button2;
	destent.impulse=srcent.impulse;
	destent.fixangle=srcent.fixangle;
	destent.v_angle=srcent.v_angle;
	destent.idealpitch=srcent.idealpitch;
	destent.netname=srcent.netname;
	destent.enemy=srcent.enemy;
	destent.flags=srcent.flags;
	destent.colormap=srcent.colormap;
	destent.team=srcent.team;
	destent.max_health=srcent.max_health;
	destent.teleport_time=srcent.teleport_time;
	destent.armortype=srcent.armortype;
	destent.armorvalue=srcent.armorvalue;
	destent.waterlevel=srcent.waterlevel;
	destent.watertype=srcent.watertype;
	destent.ideal_yaw=srcent.ideal_yaw;
	destent.yaw_speed=srcent.yaw_speed;
	destent.aiment=srcent.aiment;
	destent.goalentity=srcent.goalentity;
	destent.spawnflags=srcent.spawnflags;
	destent.target=srcent.target;
	destent.targetname=srcent.targetname;
	destent.dmg_take=srcent.dmg_take;
	destent.dmg_save=srcent.dmg_save;
	destent.dmg_inflictor=srcent.dmg_inflictor;
	destent.owner=srcent.owner;
	destent.movedir=srcent.movedir;
	destent.message=srcent.message;
	destent.sounds=srcent.sounds;
	destent.noise=srcent.noise;
	destent.noise1=srcent.noise1;
	destent.noise2=srcent.noise2;
	destent.noise3=srcent.noise3;
	destent.wad=srcent.wad;
	destent.map=srcent.map;
	destent.worldtype=srcent.worldtype;
	destent.killtarget=srcent.killtarget;
	destent.light_lev=srcent.light_lev;
	destent.style=srcent.style;
	destent.th_stand=srcent.th_stand;
	destent.th_walk=srcent.th_walk;
	destent.th_run=srcent.th_run;
	destent.th_missile=srcent.th_missile;
	destent.th_melee=srcent.th_melee;
	destent.th_pain=srcent.th_pain;
	destent.th_die=srcent.th_die;
	//destent.th_turn=srcent.th_turn;
	destent.oldenemy=srcent.oldenemy;
	destent.speed=srcent.speed;
	destent.lefty=srcent.lefty;
	destent.search_time=srcent.search_time;
	destent.attack_state=srcent.attack_state;
	destent.walkframe=srcent.walkframe;
	destent.attack_finished=srcent.attack_finished;
	destent.pain_finished=srcent.pain_finished;
	destent.invincible_finished=srcent.invincible_finished;
	destent.invisible_finished=srcent.invisible_finished;
	destent.super_damage_finished=srcent.super_damage_finished;
	destent.radsuit_finished=srcent.radsuit_finished;
	destent.invincible_time=srcent.invincible_time;
	destent.invincible_sound=srcent.invincible_sound;
	destent.invisible_time=srcent.invisible_time;
	destent.invisible_sound=srcent.invisible_sound;
	destent.super_time=srcent.super_time;
	destent.super_sound=srcent.super_sound;
	destent.rad_time=srcent.rad_time;
	destent.fly_sound=srcent.fly_sound;
	destent.axhitme=srcent.axhitme;
	destent.show_hostile=srcent.show_hostile;
	destent.jump_flag=srcent.jump_flag;
	destent.swim_flag=srcent.swim_flag;
	destent.air_finished=srcent.air_finished;
	destent.bubble_count=srcent.bubble_count;
	destent.deathtype=srcent.deathtype;
	destent.mdl=srcent.mdl;
	destent.mangle=srcent.mangle;
	destent.oldorigin=srcent.oldorigin;
	destent.t_length=srcent.t_length;
	destent.t_width=srcent.t_width;
	destent.dest=srcent.dest;
	destent.dest1=srcent.dest1;
	destent.dest2=srcent.dest2;
	destent.wait=srcent.wait;
	destent.delay=srcent.delay;
	destent.trigger_field=srcent.trigger_field;
	destent.noise4=srcent.noise4;
	destent.pausetime=srcent.pausetime;
	destent.movetarget=srcent.movetarget;
	destent.aflag=srcent.aflag;
	destent.dmg=srcent.dmg;
	destent.cnt=srcent.cnt;
	destent.think1=srcent.think1;
	destent.finaldest=srcent.finaldest;
	destent.finalangle=srcent.finalangle;
	destent.count=srcent.count;
	destent.lip=srcent.lip;
	destent.state=srcent.state;
	destent.pos1=srcent.pos1;
	destent.pos2=srcent.pos2;
	destent.height=srcent.height;
	destent.waitmin=srcent.waitmin;
	destent.waitmax=srcent.waitmax;
	destent.distance=srcent.distance;
	destent.volume=srcent.volume;
	destent.spawnfunction=srcent.spawnfunction;
	destent.spawnthink=srcent.spawnthink;
	destent.spawnmodel=srcent.spawnmodel;
	destent.spawnsolidtype=srcent.spawnsolidtype;
	destent.spawnmins=srcent.spawnmins;
	destent.spawnmaxs=srcent.spawnmaxs;
	destent.spawnclassname=srcent.spawnclassname;
};




// This SUB calculates the speed depending on the time instead of the
// time depending on the speed like SUB_CalcMove does.
void(vector tdest, float ttime, void() func) SUB_CalcTimedMove=
{
	local vector vdestdelta;
	local float len, travelspeed;

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		
		if(self.classname != "train")
			func();
		else
			self.nextthink = self.ltime + 0.1;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + ttime;

// scale the vdestdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/ttime);	// qcc won't take vec/float
};