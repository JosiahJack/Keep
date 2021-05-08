/*###########################################################

Custents 6.0 by General WarT' (aka. Carl Glave)
This file and the acodmisc.qc file contains the bulk of the code
for the new functions and entities that are exclusive to Custents.
All new variable and constant definitions are in the custdefs.qc
file. Here's a completely list of these and all the other added
code files.
	- actors.qc			* contains all the code for the actor entities
	- apocmisc.qc		* contains all sorts of misc. stuff from Apocalypse
	- buzzsaw.qc		* Rogue buzzsaw trap
	- custdefs.qc		* the globals for the Custents code
	- custents.qc		* where the cool Custents features are held
	- elevatr.qc		* Rogue elevator
	- hipsubs.qc		* Hipnotic subroutines
	- hipcount.qc		* Hipnotic counter
	- hiptraps.qc		* Hipnotic hazards
	- hiprubbl.qc		* Hipnotic rubble stuff
	- hip_brk.qc		* Hipnotic breakable walls
	- hip_expl.qc		* Hipnotic explosions
	- hip_part.qc		* Hipnotic particle field
	- hip_push.qc		* Hipnotic pushable walls
	- hiprot.qc			* Hipnotic rotating code
	- hipclock.qc		* Hipnotic clock
	- hipmisc.qc		* Hipnotic sound stuff
	- hipspawn.qc		* Hipnotic dynamic spawning
	- hiptrig.qc		* Hipnotic triggers
	- hipquake.qc		* Hipnotic Earthquakes
	- hipwater.qc		* Hipnotic bobbing water
	- lightnin.qc		* Rogue relay lightning
	- missiles.qc		* contains custom code for handling projectiles
	- pendulum.qc		* Rogue pendulum
	- rogmisc.qc		* Rogue misc stuff
	- rogplats.qc		* Rogue new platforms
	- rogquake.qc		* Rogue earth quake
	- srvomech.qc		* controllable and monster servomechs
	- zmaster.qc		* Zombie Master: not Apoc related, but mine, and cool

Other Custents code that is in modified qc files are
set off by lines like this...
// ###
So just do a search for ### and you'll find it all.
These bits of extra code are in the following files.
The comments for each specify what the added code in
that file are for. This should make selective code
adding a bit easier for you.
	- progs.src		* Added lines to compile the new source files
	- ai.qc			* train path setup, monster sight sounds,
					  controllable servomech targeting
	- client.qc		* multiple starting points, changing gravity,
					  parm value packing, external camera,
					  remote cameras, controllable servomechs,
					  speed optimizations, earthquakes, special
					  death messages, added obituaries
	- combat.qc		* speed optimizations, zombie master, added
					  damage dealing functions
	- doors.qc		* added door spawnflag
	- enforcer.qc	* spawnblood fix
	- items.qc		* PPC weapon
	- misc.qc		* trap shooters
	- plats.qc		* trains
	- player.qc		* PPC weapon, zombie master
	- shambler.qc	* baby shambler
	- soldier.qc	* new soldier monsters
	- subs.qc		* multiple targets and targetnames
	- triggers.qc	* added trigger functionality
	- weapons.qc	* spawnblood fix, new rocket explosion, axzombies,
					  grenade duration for changing gravity, PPC weapon,
					  external camera, trigger_impulse, trigger_touch_impulse
	- world.qc		* speed optimizations, added precaches for Custents entities,
					  PPC weapon precaches
	- zombie.qc		* added zombie features, axzombie, zombie master
	
###########################################################*/

//##########################################
//#### Universal ambience function      ####
//##########################################
void() ambient_general = 
{
	precache_sound (self.noise);
	if(!self.speed)
		self.speed = ATTN_STATIC;
	if(!self.volume)
		self.volume = 0.5;
	ambientsound (self.origin, self.noise, self.volume, self.speed);
};

//##########################################
//#### Multipurpose sound playing entity ###
//##########################################
void() bgm_loop =
{
	if(self.ammo_shells == 0)
	{
		self.ammo_cells = FALSE;
		sound (self, self.impulse, self.noise3, self.volume, self.speed);
		if(self.target)
		{
			self.think = SUB_UseTargets;
			self.nextthink = time + self.button0;
		}
		else
			self.nextthink = 0;

		return;
	}
	else if(self.ammo_shells > 0)
		self.ammo_shells = self.ammo_shells - 1;

	sound (self, CHAN_VOICE, self.noise2, self.volume, self.speed);
	self.nextthink = time + self.button2;
};

void() bgm_use =
{
	if(self.ammo_cells)
	{
		self.ammo_cells = FALSE;
		if(self.noise3 == "none")
			self.think = SUB_Null;
		else if(self.noise3 != "misc/null.wav")
		{
			sound (self, self.impulse, self.noise3, self.volume, self.speed);
			if(self.target)
			{
				self.think = SUB_UseTargets;
				self.nextthink = time + self.button0;
			}
			else
				self.nextthink = 0;
		}
		else
		{
			sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
			if(self.target)
				SUB_UseTargets();
			self.nextthink = 0;
		}
	}
	else
	{
		self.ammo_cells = TRUE;
		if(self.noise1 != "misc/null.wav")
		{
			sound (self, self.impulse, self.noise1, self.volume, self.speed);
			self.nextthink = time + self.button1;
		}
		else
		{
			sound (self, self.impulse, self.noise2, self.volume, self.speed);
			self.nextthink = time + self.button2;
		}
		if(self.button2 > 0)
			self.think = bgm_loop;
		else
			self.think = SUB_Null;
		if(self.waitmax)
			self.ammo_shells = self.waitmax;
		else
			self.ammo_shells = -1;
	}
};

void() ambient_bgm =
{
	if(self.noise1)
		precache_sound (self.noise1);
	else
		self.noise1 = "misc/null.wav";

	if(self.noise2)
		precache_sound (self.noise2);
	else
		objerror ("no looping wav file.\n");

	if(self.noise3)
		precache_sound (self.noise3);
	else
		self.noise3 = "misc/null.wav";

	precache_sound ("misc/null.wav");

	if(!self.impulse)
		self.impulse = CHAN_VOICE;
	else if(self.impulse == -1)
		self.impulse = CHAN_AUTO;

	self.ammo_cells = FALSE;

	if(self.waitmax)
		self.ammo_shells = self.waitmax;
	else
		self.ammo_shells = -1;

	if(!self.speed)
		self.speed = ATTN_NONE;

	if(!self.volume)
		self.volume = 1;

	if(!self.targetname || (self.spawnflags & BGM_START_ON))
	{
		self.think = bgm_use;
		self.nextthink = time + 1.5;
	}

	self.use = bgm_use;
};

//##########################################
//#### Path entity self-setup functions ####
//##########################################

void() pe_self_setup=
{
	local entity tmpent;

	tmpent = find(world, targetname, self.target);
	if(!tmpent)
		objerror ("path entity without target");

	self.goalentity = tmpent;

	self.think = SUB_Null;
};

// This is the actual function called by all path entities at startup.
void() path_entity_setup=
{
	self.nextthink = time + 0.2;
	self.think = pe_self_setup;
};

//##########################################
//#### Train cloning functions          ####
//##########################################

void (entity srcent, entity destent) SUB_CopyEntity;
void(vector tdest, float ttime, void() func) SUB_CalcTimedMove;
void() smtrain_next;
void() func_smtrain_setup;
void() func_train_find;
void() generate_train_clones=
{
	local entity currclone, currpath, tmpself;

	tmpself = self;
	currpath = self.goalentity;

	self.count = self.count + 1; // to get the apropriate number of clones
	while(self.count > 0)
	{
		currpath = currpath.goalentity;
		if(!currpath)
			objerror ("not enouth path entities for clones");
		// filled a looped path, so more clone would be bad.
		if(currpath == self.goalentity)
		{
			self.count = 0;
			return;
		}

		currclone = spawn();
		SUB_CopyEntity(self, currclone);
		currclone.count = 0;
		currclone.goalentity = currpath;
		currclone.target = currpath.targetname;

		self = currclone;
		if(self.classname == "smtrain")
		{
			self.oldenemy = self.goalentity;

			if(self.noise1)
				sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);

			// added so that moving lights can self clone in their proper places
			if(self.classname == "func_move_light")
				setorigin (self, self.goalentity.origin);
			else
				setorigin (self, self.goalentity.origin - self.mins);
			if (!self.targetname)
			{	// not triggered, so start immediately
				self.goalentity = self.goalentity.goalentity;
				if(self.duration)
					SUB_CalcTimedMove(self.goalentity.origin - self.mins, self.duration, smtrain_next);
				else
					SUB_CalcMove (self.goalentity.origin - self.mins, self.speed, smtrain_next);
			}
		}
		else
		{
			self.target = self.goalentity.target;
			setorigin (self, self.goalentity.origin - self.mins);
		}
		self = tmpself;

		self.count = self.count - 1;
	}
};

//##########################################
//#### Smooth trains thinking functions ####
//##########################################

void() smtrain_next =
{
	local string temp;

	// check for wait times
	if(self.goalentity.wait)
	{
		if(self.goalentity.wait != self.wait)
		{
			self.wait = self.goalentity.wait;

			if(self.wait == -1)
			{
				self.think = func_smtrain_setup;
				if(self.noise)
					sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
				else
					sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
				return;
			}
		}
		else
			self.wait = 0;
	}
	else
		self.wait = 0;
	if(self.wait)
	{
		if(self.noise)
			sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
		self.nextthink = self.ltime + self.wait;
		return;
	}

	if (self.goalentity.event)
      {
	      // Trigger any events that should happen at the corner.
	      temp = self.target;
	      self.target = self.goalentity.event;
	      self.message = self.goalentity.message;
	      SUB_UseTargets();
	      self.target = temp;
	      self.message = string_null;
	}

	if(self.goalentity.duration < 0 || self.goalentity.speed < 0)
	{
		self.goalentity = self.goalentity.goalentity;
	      setorigin (self, self.goalentity.origin - self.mins );
		self.nextthink = self.ltime + 0.05;
	}
	else
	{
		if(self.goalentity.duration > 0)
			self.duration = self.goalentity.duration;
		else if (self.goalentity.speed > 0)
		{
			self.duration = 0;
			self.speed = self.goalentity.speed;
		}

		// look to the next path entity to go to
		self.goalentity = self.goalentity.goalentity;
		// if .duration is set, then use use a new sub to set the train's
		// speed to get there in .duration seconds by seting direction and speed.
		if(self.duration)
			SUB_CalcTimedMove(self.goalentity.origin - self.mins, self.duration, smtrain_next);
		else
			SUB_CalcMove (self.goalentity.origin - self.mins, self.speed, smtrain_next);
	}
};

void() func_smtrain_setup=
{
	local entity firsttarg, targ;

	// finds the entity that the smooth train targets at start.
	firsttarg = find (world, targetname, self.target);

	self.classname = "smtrain";

	self.wait = 0;
	self.goalentity = firsttarg;
	self.oldenemy = firsttarg;

	// make clones if specified.
	if(self.count > 0)
	{
		self.nextthink = self.ltime + 0.4;
		generate_train_clones();
		return;
	}

	if(self.noise1)
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);

	// this is the stuff that func_train_find did.
	setorigin (self, firsttarg.origin - self.mins);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.goalentity = self.goalentity.goalentity;
		if(self.duration)
			SUB_CalcTimedMove(self.goalentity.origin - self.mins, self.duration, smtrain_next);
		else
			SUB_CalcMove (self.goalentity.origin - self.mins, self.speed, smtrain_next);
	}
};

void() train_bbox_touch =
{
	if((other.flags & FL_CLIENT) || (other.flags & FL_MONSTER))
		if(other.absmin_z < self.absmax_z)
			other.velocity = other.velocity + (self.velocity * 2);
};

//##########################################
//#### Trains Syncronizer               ####
//##########################################
// This is the func_train_syncer entity. It is used to get a whole line
// of trains to do the same thing at the same time. They all start, stop
// and get blocked as one because this entity controlls them all and keeps
// them together.

void() syncer_stop;

void() sync_smtrain_next =
{
	local entity currtrain, tmpent;

	// check for wait times
	if(self.goalentity.wait)
	{
		if(self.goalentity.wait != self.wait)
		{
			self.wait = self.goalentity.wait;

			if(self.wait == -1)
			{
				syncer_stop();
				return;
			}
		}
		else
			self.wait = 0;
	}
	else
		self.wait = 0;
	if(self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		return;
	}

	// look to the next path entity to go to
	self.goalentity = self.goalentity.goalentity;
	if(self.goalentity.duration < 0 || self.goalentity.speed < 0)
	{
		setorigin(self, self.goalentity.origin - self.mins);
		self.goalentity = self.goalentity.goalentity;
	}
	SUB_CalcTimedMove(self.goalentity.origin, self.duration, sync_smtrain_next);
	self.nextthink = time + self.duration;

	currtrain = self.aiment;
	tmpent = self;
	do
	{
		self = currtrain;
		self.goalentity = self.goalentity.goalentity;
		if(self.goalentity.duration < 0 || self.goalentity.speed < 0)
		{
			setorigin(self, self.goalentity.origin - self.mins);
			self.goalentity = self.goalentity.goalentity;
		}
		SUB_CalcTimedMove(self.goalentity.origin - self.mins, tmpent.duration, SUB_Null);
		currtrain = currtrain.aiment;
	} while(currtrain != tmpent.aiment);
	self = tmpent;

};

void() sync_blocked =
{
	local entity currtrain;

	if(!(self.owner.spawnflags & SYNCER_BLOCKABLE))
	{
		other.velocity = other.velocity + (self.velocity * 2.5);
		return;
	}

	if(self.owner.spawnflags & SYNCER_SYNC_BLOCK)
	{
		if (time < self.owner.attack_finished)
			return;
		self.owner.attack_finished = time + self.owner.delay;
		if(self.owner.dmg)
			T_Damage (other, self.owner, self.owner, self.owner.dmg);
		self.owner.velocity = '0 0 0';
		self.owner.think = sync_smtrain_next;
		self.owner.nextthink = time + self.owner.delay;

		currtrain = self.aiment;
		do
		{
			currtrain.velocity = '0 0 0';
			currtrain.think = SUB_Null;
			currtrain = currtrain.aiment;
		} while(currtrain != self.aiment);
	}
	else
	{
		self.attack_finished = time + self.owner.delay;
		if (time < self.attack_finished)
			return;
		self.attack_finished = time + self.owner.delay;
		T_Damage (other, self.owner, self.owner, self.owner.dmg);
	}
};

void() syncer_start =
{
	local entity currtrain, tmpent;

	currtrain = self.aiment;
	tmpent = self;
	do
	{
		self = currtrain;
		if(self.goalentity.duration < 0 || self.goalentity.speed < 0)
		{
			setorigin(self, self.goalentity.origin - self.mins);
			self.goalentity = self.goalentity.goalentity;
		}
		SUB_CalcTimedMove(self.goalentity.origin - self.mins, tmpent.duration, SUB_Null);
		currtrain = currtrain.aiment;
	} while(currtrain != tmpent.aiment);
	self = tmpent;

	if(self.goalentity.duration < 0 || self.goalentity.speed < 0)
	{
		setorigin(self, self.goalentity.origin - self.mins);
		self.goalentity = self.goalentity.goalentity;
	}
	SUB_CalcTimedMove(self.goalentity.origin, self.duration, sync_smtrain_next);

	self.nextthink = time + self.duration;

	self.use = syncer_stop;
};

void() syncer_stop =
{
	local entity currtrain, tmpent;

	if(self.spawnflags & SYNCER_RETRACTABLE)
	{
		SUB_CalcTimedMove(self.oldenemy.origin, self.duration, SUB_Null);
		self.nextthink = time + self.duration;

		currtrain = self.aiment;
		tmpent = self;
		do
		{
			self = currtrain;
			SUB_CalcTimedMove(tmpent.oldenemy.origin - self.mins, tmpent.duration, SUB_Null);
			currtrain = currtrain.aiment;
		} while(currtrain != tmpent.aiment);
		self = tmpent;
	}
	else
	{
		currtrain = self.aiment;
		tmpent = self;
		do
		{
			self = currtrain;
			self.velocity = '0 0 0';
			self.think = SUB_Null;
			currtrain = currtrain.aiment;
		} while(currtrain != tmpent.aiment);
		self = tmpent;

		self.velocity = '0 0 0';
		self.think = SUB_Null;
		self.think1 = SUB_Null;
	}

	self.use = syncer_start;
};

void() syncer_first_think =
{
	local entity currtrain, tmptrain;
	local float clonedelay;

	currtrain = find(world, targetname, self.path);
	setorigin(self, currtrain.origin);
	self.goalentity = currtrain;
	self.oldenemy = self.goalentity;

	clonedelay = 0;

	// take control of and setup the trains
	currtrain = find(world, targetname, self.target);
	if(!currtrain)
		objerror ("No targets found.");
	self.aiment = currtrain;
	while(currtrain)
	{
		if(currtrain.owner != self)
		{
			currtrain.owner = self;
			currtrain.duration = self.duration;
			currtrain.wait = 0;
			currtrain.dmg = self.dmg;
			currtrain.noise = self.noise;
			currtrain.noise1 = self.noise1;
			currtrain.use = SUB_Null;
			currtrain.deathtype = self.deathtype;
			tmptrain = find(world, targetname, currtrain.target);
			currtrain.goalentity = tmptrain;
			currtrain.oldenemy = currtrain.goalentity;
			if(self.spawnflags & SYNCER_START_TOGETHER)
				setorigin(currtrain, self.origin - currtrain.mins);
			else
				setorigin(currtrain, currtrain.goalentity.origin - currtrain.mins);
			currtrain.classname = "smtrain";

			if(currtrain.count > 0)
			{
				if((currtrain.count*0.02) > clonedelay)
					clonedelay = currtrain.count*0.02;
				tmptrain = self;
				self = currtrain;
				generate_train_clones();
				self = tmptrain;
			}
		}

		currtrain = find(currtrain, targetname, self.target);
	}

	// link the controlled trains together
	currtrain = self.aiment;
	while(currtrain)
	{
		tmptrain = find(currtrain, targetname, self.target);
		if(!tmptrain)
			currtrain.aiment = self.aiment;
		else
			currtrain.aiment = tmptrain;

		currtrain = tmptrain;
	}

	if((self.targetname != "") && !(self.spawnflags & SYNCER_START_ON))
		self.think = syncer_stop;
	else
		self.think = syncer_start;
	self.nextthink = time + 0.2 + clonedelay;
};

void() func_train_syncer =
{
	if(!self.target)
		objerror ("Needs to target a set of smooth trains.");
	if(!self.duration)
		objerror ("Travel duration must be used to keep trains in sync.");

	precache_sound ("misc/null.wav");

	if((self.spawnflags & SYNCER_BLOCKABLE) && self.delay == 0)
		self.delay = 0.5;

	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_NOT;
	self.classname = "syncer";
	self.think = syncer_first_think;
	self.nextthink = time + 0.4; //allow the trains to spawn before setup
};

//##########################################
//#### Path Changer                     ####
//##########################################

void() change_path_use=
{
	local entity currpath;

	currpath = world;
	currpath = find(currpath, targetname, self.target);
	while(currpath)
	{
		currpath.target = self.path;
		currpath.goalentity = self.goalentity;

		currpath = find(currpath, targetname, self.target);
	}
};

void() trigger_change_path=
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;

	if(!self.target)
		objerror ("path changer without target");
	if(!self.path)
		objerror ("path changer without path destination");

	self.goalentity = find(world, targetname, self.path);

	self.use = change_path_use;
};

//##########################################
//#### SUBS                             ####
//##########################################

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


//##########################################
//#### MOVING LIGHT                     ####
//##########################################
void() light_next;
void() func_light_find;
void() light_flash;

void() path_light=
{
	if(!self.model)
		self.model = "progs/s_null.spr";
	precache_model (self.model);
	path_entity_setup();
};

void() move_light_use =
{
	if (self.think != func_light_find)
		return;		// already activated
	light_next();
};

void() light_wait =
{
	if (self.wait)
	{
		self.nextthink = time + self.wait;
		// allows lights to be retriggered after stopping
		if(self.wait == -1)
			self.think = func_light_find;
		if(self.noise)
			sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
	}
	else
		self.nextthink = time + 0.1;
	
	self.think = light_next;
};

void() light_next =
{
	local entity targ, flasher;
	local string temp;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
		objerror ("light_next: no next target");
	if(self.noise1)
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);

	self.wait = targ.wait;

	if (self.goalentity.event)
      {
	      // Trigger any events that should happen at the corner.
	      temp = self.target;
	      self.target = self.goalentity.event;
	      self.message = self.goalentity.message;
	      SUB_UseTargets();
	      self.target = temp;
	      self.message = string_null;
	}

	if(self.goalentity.spawnflags)
	{
		if(self.goalentity.spawnflags & LP_OFF)
		{
			self.effects = 0;
			if(self.spawnmaster)
			{
				remove(self.spawnmaster);
				self.spawnmaster = world;
			}
		}

		if(self.goalentity.spawnflags & LP_DIM)
		{
                  if(self.effects & EF_BRIGHTFIELD)
                        self.effects = EF_DIMLIGHT + EF_BRIGHTFIELD;
			else
				self.effects = EF_DIMLIGHT;
			if(self.spawnmaster)
			{
				remove(self.spawnmaster);
				self.spawnmaster = world;
			}
		}
		else if(self.goalentity.spawnflags & LP_BRIGHT)
		{
                  if(self.effects & EF_BRIGHTFIELD)
                        self.effects = EF_BRIGHTLIGHT + EF_BRIGHTFIELD;
			else
				self.effects = EF_BRIGHTLIGHT;
			if(self.spawnmaster)
			{
				remove(self.spawnmaster);
				self.spawnmaster = world;
			}
		}
		else if(self.goalentity.spawnflags & LP_FLASH)
		{
                  if(self.effects & EF_BRIGHTFIELD)
				self.effects = EF_BRIGHTFIELD;
			else
				self.effects = 0;

			if(!self.spawnmaster)
			{
				flasher = spawn();
				flasher.owner = self;
				flasher.delay = self.delay;
				flasher.think = light_flash;
				flasher.nextthink = time + flasher.delay;
				setmodel(flasher, "progs/s_null.spr");
				self.spawnmaster = flasher;
			}
		}

		if(self.goalentity.spawnflags & LP_FIELD)
		{
			if(self.effects & EF_BRIGHTLIGHT)
				self.effects = EF_BRIGHTLIGHT + EF_BRIGHTFIELD;
			else if(self.effects & EF_DIMLIGHT)
				self.effects = EF_DIMLIGHT + EF_BRIGHTFIELD;
			else
				self.effects = EF_BRIGHTFIELD;
		}

		if(self.goalentity.spawnflags & LP_SET_MODEL)
			setmodel (self, self.goalentity.model);
	}
	
	if(self.goalentity.duration < 0 || self.goalentity.speed < 0)
	{
	      setorigin (self, targ.origin);
		self.nextthink = time + 0.01;
	}
	else
	{
		if(self.goalentity.duration > 0)
			self.duration = self.goalentity.duration;
		else if (self.goalentity.speed > 0)
		{
			self.duration = 0;
			self.speed = self.goalentity.speed;
		}

		// if .duration is set, then use use a new sub to set the train's
		// speed to get there in .duration seconds by seting direction and speed.
		self.ltime = time;
		if(self.duration)
			SUB_CalcTimedMove(targ.origin, self.duration, light_wait);
		else
			SUB_CalcMove (targ.origin, self.speed, light_wait);
	}

	self.goalentity = targ;
};

void() func_light_find =

{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.goalentity = targ; // ###
	self.target = targ.target;
	setorigin (self, targ.origin);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = time + 0.1;
		self.think = light_next;
	}
	if(self.count > 0) // for cloning
		generate_train_clones();
};

void() light_flash=
{
	setorigin(self, self.owner.origin);
	self.effects = EF_MUZZLEFLASH;
	self.nextthink = time + self.delay;
};

void() func_move_light=
{
	local entity flasher;

//	precache_model ("progs/s_null.spr");

	if(!(self.spawnflags & LIGHT_START_OFF))
	{
		if(self.spawnflags & LIGHT_BRIGHT)
			self.effects = EF_BRIGHTLIGHT;
		else if(self.spawnflags & LIGHT_FLASH)
		{
			flasher = spawn();

			flasher.owner = self;
			flasher.delay = self.delay;
			flasher.think = light_flash;
			flasher.nextthink = time + flasher.delay;
			setmodel(flasher, "progs/s_null.spr");
			self.spawnmaster = flasher;
		}
		else
			self.effects = EF_DIMLIGHT;

		if(self.spawnflags & LIGHT_FIELD)
			self.effects = self.effects & EF_BRIGHTFIELD;
	}

	if(!self.speed)
		self.speed = 100;
	if(!self.target)
		objerror ("func_move_light without a target");
	if(self.delay <= 0)
		self.delay = 0.2;

	if(!self.noise)
		self.noise = ("misc/null.wav");
	if(!self.noise1)
		self.noise1 = ("misc/null.wav");
	precache_sound ("misc/null.wav");
	precache_sound (self.noise);
	precache_sound (self.noise1);

	if(!self.model)
		self.model = "progs/s_null.spr";
	precache_model (self.model);
	setmodel (self, self.model);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	self.use = move_light_use;

	self.think = func_light_find;
	self.nextthink = time + 0.2;
};



//##########################################
//#### HEAL TRIGGER                     ####
//##########################################
// Original entity submitted by Jan Martin Mathiassen, aka. TGR

void() heal_touch =
{
	if(self.spawnflags & HEAL_PLAYER_ONLY && other.classname != "player")
		return;
	if(self.spawnflags & HEAL_MONSTER_ONLY && !(other.flags & FL_MONSTER))
		return;
	if(other.classname != "player" && !(other.flags & FL_MONSTER))
		return;

	if(other.heal_timer > time)
		return;

	if ((other.takedamage) && (other.health < self.health))
	{
		sound (self, CHAN_VOICE, "misc/heal.wav", 1, ATTN_NORM);

		if ((other.health + self.dmg) > self.health)
		{
			if(self.spawnflags & HEAL_OBEY_MAX)
				T_Heal (other, (self.health - other.health), 0);
			else
				T_Heal (other, (self.health - other.health), 1);
		}
		else
		{
			if(self.spawnflags & HEAL_OBEY_MAX)
				T_Heal (other, self.dmg, 0);
			else
				T_Heal (other, self.dmg, 1);
		}

		other.heal_timer = time + self.wait;
	}
};

void() heal_toggle=
{
	if(self.touch == SUB_Null)
		self.touch = heal_touch;
	else
		self.touch = SUB_Null;
};

/*QUAKED trigger_heal (.5 .5 .5) ? HEAL_START_ON HEAL_PLAYER_ONLY HEAL_MONSTER_ONLY
Any object touching this will be healed
dmg -- the amount to heal each time (default 1)
wait -- the time between each healing (default 1)
health -- the upper limit for the healing (default 100, max 250)
*/
void() trigger_heal =
{
	precache_sound ("misc/heal.wav");

	InitTrigger ();

	if (self.wait == 0)
		self.wait = 1;
	if (self.dmg == 0)
		self.dmg = 1;
	if (self.health == 0)
		self.health = 100;
	else if (self.health > 250)
		self.health = 250;

	if(self.targetname)
	{
		self.use = heal_toggle;
		if(self.spawnflags & HEAL_START_ON)
			self.touch = heal_touch;
		else
			self.touch = SUB_Null;
	}
	else
		self.touch = heal_touch;
};
