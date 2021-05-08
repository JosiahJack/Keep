/*
	func_frame
	Written by Matt Houser   & modified by Darin McNeil (1/26/97)
	fisty@canweb.net
	Ripped off...err... inspired by Dimensionalitiy's func_frame
	18:48GMT-5:12/31/96
	Usage:
		Required:
	"classname" "func_frame"
	"targetname" "..."	- Name of group of frames, also targetname for toggling on and off
	"cnt" "#"			- Frame # (1 based)
	
		Optional: (only frame #1 is checked)
	"dmg" "#"		- Damage on touch (only when moving)
	"target" "..."	- Target to call on touch
	"spawnflags" "#"	- bit 1: Use on touch (frame will advance on touch, and
						"target" will be triggered)
					- bit 2: Stopped at start
					- bit 3: Back and forth rather than looping
	"wait" "#"	- Time delay between this frame and the next (default is 0.1,
					-1 should stop the animation)

	- Frames are played in order starting at 1 (duplicates may be missed)
	- On use, animation will start or stop
	- When stopped, no damage will be done

	TODO:
		- Incorporate sound somehow
		- Tidy up the back and forth code, Manero insisted on having it so I did it...
			blame him for it's untidyness
			
	BUGS:
		- Slight disfiguration on some walls while moving
		- Slightly larger delay when looping back to frame #1 (gone now, not sure why)
*/

float FF_USEONTOUCH = 1;
float FF_STOPPED = 2;
float FF_BACKANDFORTH = 4;

entity(float thisCount) func_frame_find_frame =
{
	local entity e;
	// find all the entities that have our targetname
	e = find(world, targetname, self.targetname);
	while (e != world)
	{
		// cycle thru until we found the right frame
		if (e.cnt == thisCount && e.classname == "func_frame")
			//we found it
			return e;
		e = find(e, classname, "func_frame");
	}
};

void() func_frame_change_frame =
{
	local entity e;
	local float thisCount;
	local string countStr;
	
	if (self.cnt != 1)
		return;
	
	// which way? forward of reverse?	
	if (self.spawnflags & FF_BACKANDFORTH)
	{
		if (self.state) // reverse
		{
			if (self.enemy.cnt == 1) // we've hit the start of our loop, reverse gear
			{
				thisCount = 2;
				self.state = 0; // forward now
			}
			else
				thisCount = self.enemy.cnt - 1;
		}
		else
			thisCount = self.enemy.cnt + 1;
	}
	else
		thisCount = self.enemy.cnt + 1;
	// find the next frame
	if (thisCount == 1)
		e = self.goalentity;
	else
		e = func_frame_find_frame(thisCount);
	if (e == world)
	{
		// end of loop
		if (self.spawnflags & FF_BACKANDFORTH)
		{
			self.state = 1;	// backwards now
			e = func_frame_find_frame(self.enemy.cnt - 1);
			if (e == world)
			{
				// double wammy
				self.state = 0;
				e = self.goalentity;
			}
		}
		else
			e = self.goalentity;
	}

	// set the frame for future use
	self.enemy = e;

	// set the model
	setmodel(self, e.model);
	if ( !(self.spawnflags & FF_USEONTOUCH) )
	{
		if (e.wait < 0)	// if we've hit a -1 wait, signal a stopped state
		{
// dhm - Make the frames stop, and make it not solid so that you
//      can used this for doors, etc.

			sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
			self.spawnflags = self.spawnflags | FF_STOPPED;
			//self.think = SUB_Null;
			self.solid = SOLID_NOT;
			return;
		}
		else if (self.spawnflags & 2)
			// otherwise just make sure our state is the moving state
			self.spawnflags = self.spawnflags - FF_STOPPED;
		self.nextthink = time + e.wait;
	}
};

void() func_frame_use =
{
	// only #1 should do any using
	if (self.cnt != 1)
		return;

	// we don't use if we use on touch
	if (self.spawnflags & FF_USEONTOUCH)
		return;
		
	// we use spawnflags & FF_STOPPED to tell if we're moving or not
	if (self.spawnflags & FF_STOPPED)
	{
		// get moving
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
		self.spawnflags = self.spawnflags - FF_STOPPED;
		func_frame_change_frame();
	}
	else
	{
		// stop
		self.nextthink = -1;
		self.spawnflags = self.spawnflags | FF_STOPPED;
	}
};

void() func_frame_touch =
{
	// only #1 should be touchable
	if (self.cnt != 1)
		return;
		
	// damage
	if (self.dmg && !(self.spawnflags & FF_STOPPED) )
		T_Damage(other, self, self, self.dmg);

	// change frame on touch only
	if (self.spawnflags & FF_USEONTOUCH)
	{
		func_frame_change_frame();
		// use any targets this may be dealing with
		activator = other;
		SUB_UseTargets();
	}
};

void() func_frame =
{
	// initial error checking
	if (!self.targetname)
	{
		// no targetname, no way to group
		objerror("func_frame without a targetname\n");
		remove(self);
	}
	if (!self.cnt)
	{
		// no cnt, no way to know which frame this is
		objerror("func_frame without a cnt\n");
		remove(self);
	}
	if (!self.wait)
		self.wait = 0.1;	// how long the current frame stays put

	if (self.cnt == 1)
	{
		self.solid = SOLID_BBOX;
		self.movetype = MOVETYPE_NONE;

		// 1 does all the work, 2 and so on are just additional frames
		setmodel(self, self.model);

		// duplicate ourself to save our model
		self.goalentity = spawn();
		self.goalentity.classname = "func_frame";
		self.goalentity.model = self.model;
		self.state = 0;
		self.goalentity.cnt = self.cnt;
		self.goalentity.wait = self.wait;
		self.use = func_frame_use;
		self.touch = func_frame_touch;
		
		self.enemy = self;	// enemy says which frame we're on
		if ( !(self.spawnflags & FF_USEONTOUCH) )
		{
			self.think = func_frame_change_frame;
			if ( !(self.spawnflags & FF_STOPPED) )
				self.nextthink = time + self.wait;
		}
	}
	
	//DHM: sounds from ACS func_train
	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}
	else if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound ("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound ("plats/train1.wav");
	}
//dhm - new sounds from 'func_door'
	else if (self.sounds == 2)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise = "doors/drclos4.wav";
		self.noise1 = "doors/doormv1.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise1 = "doors/hydro1.wav";
		self.noise = "doors/hydro2.wav";
	}
	else if (self.sounds == 4)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise1 = "doors/stndr1.wav";
		self.noise = "doors/stndr2.wav";
	}
	else if (self.sounds == 5)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise = "doors/ddoor2.wav";
		self.noise1 = "doors/ddoor1.wav";
	}
};

