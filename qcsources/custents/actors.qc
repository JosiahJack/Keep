/*#################################################################
ACTORS - STATIONARY AND MOVEABLE
Developed for Quake:The Apocalypse
by General WarT' (aka Carl Glave)

This file contains the auto setup values sets for the actors that
are used by setting the actor's "impulse" value. A list of all the
different available sets is in the actors.txt file. If you add your
own sets, you should also add it to the list so that it will be
easier to find.

#################################################################*/

// selects auto set to use for entered impulse value
// and sets values not directly specified in the actor.
void() actor_values_setup =
{
	local float s_f1, s_f2, s_f3, s_f4, s_f5;
	local string s_s1;
	local float w_f1, w_f2, w_f3, w_f4, w_f5, w_f6;
	local string w_s1;
	local float r_f1, r_f2, r_f3, r_f4, r_f5, r_f6;
	local string r_s1;
	local float aa_f1, aa_f2, aa_f3, aa_f4, aa_f5;
	local string aa_s1, aa_s2;
	local float ab_f1, ab_f2, ab_f3, ab_f4, ab_f5;
	local string ab_s1, ab_s2;
	local float d_f1, d_f2, d_f3, d_f4, d_f5, d_f6;
	local string d_s1, d_s2;
	local float f1;
	local string s1;

// Preset actor configurations
	if(self.impulse == 0) // player with shotgun
	{
		s1 = "progs/player.mdl";		// model to use
		f1 = 30;					// turning speed

		// standing values
		s_f1 = 12;					// first frame
		s_f2 = 5;					// number of frames
		s_f3 = 0.1;					// frame time
		s_s1 = "misc/null.wav";			// sound file
		s_f4 = -1;					// min sound delay
		s_f5 = 0;					// % chance of playing the sound

		// walking values
		w_f1 = 6;					// first frame
		w_f2 = 6;					// number of frames
		w_f3 = 0.1;					// frame time
		w_s1 = "misc/null.wav";			// sound file
		w_f4 = -1;					// min sound delay
		w_f5 = 0;					// % chance of playing the sound
		w_f6 = 160;					// speed

		// running values
		r_f1 = 6;					// first frame
		r_f2 = 6;					// number of frames
		r_f3 = 0.1;					// frame time
		r_s1 = "misc/null.wav";			// sound file
		r_f4 = -1;					// min sound delay
		r_f5 = 0;					// % chance of playing the sound
		r_f6 = 320;					// speed

		// action one
		aa_f1 = 113;				// first frame
		aa_f2 = 6;					// number of frames
		aa_f3 = 0.1;				// frame time
		aa_s1 = "weapons/guncock.wav";	// sound file
		aa_f4 = 2;					// effects
		aa_f5 = 114;				// frame to do effects on

		// action two
		ab_f1 = 35;					// first frame
		ab_f2 = 6;					// number of frames
		ab_f3 = 0.1;				// frame time
		ab_s1 = "player/pain4.wav";		// sound file
		ab_f4 = 0;					// effects
		ab_f5 = 35;					// frame to do effects on

		// die
		d_f1 = 50;					// first frame
		d_f2 = 11;					// number of frames
		d_f3 = 0.1;					// frame time
		d_s1 = "player/death5.wav";		// sound file
		d_f6 = 50;					// frame to do effects on
	}
	else if(self.impulse == 1) // player with rocket launcher
	{
		s1 = "progs/player.mdl";		// model to use
		f1 = 40;					// turning speed

		// standing values
		s_f1 = 12;					// first frame
		s_f2 = 5;					// number of frames
		s_f3 = 0.1;					// frame time
		s_s1 = "misc/null.wav";			// sound file
		s_f4 = -1;					// min sound delay
		s_f5 = 0;					// % chance of playing the sound

		// walking values
		w_f1 = 6;					// first frame
		w_f2 = 6;					// number of frames
		w_f3 = 0.1;					// frame time
		w_s1 = "misc/null.wav";			// sound file
		w_f4 = -1;					// min sound delay
		w_f5 = 0;					// % chance of playing the sound
		w_f6 = 160;					// speed

		// running values
		r_f1 = 6;					// first frame
		r_f2 = 6;					// number of frames
		r_f3 = 0.1;					// frame time
		r_s1 = "misc/null.wav";			// sound file
		r_f4 = -1;					// min sound delay
		r_f5 = 0;					// % chance of playing the sound
		r_f6 = 320;					// speed

		// action one
		aa_f1 = 107;				// first frame
		aa_f2 = 6;					// number of frames
		aa_f3 = 0.1;				// frame time
		aa_s1 = "weapons/sgun1.wav";		// sound file
		aa_f4 = 2;					// effects
		aa_f5 = 108;				// frame to do effects on

		// action two
		ab_f1 = 35;					// first frame
		ab_f2 = 6;					// number of frames
		ab_f3 = 0.1;				// frame time
		ab_s1 = "player/pain4.wav";		// sound file
		ab_f4 = 0;					// effects
		ab_f5 = 35;					// frame to do effects on

		// die
		d_f1 = 61;					// first frame
		d_f2 = 9;					// number of frames
		d_f3 = 0.1;					// frame time
		d_s1 = "player/death5.wav";		// sound file
		d_f6 = 61;					// frame to do effects on
	}
	else if(self.impulse == 2) // player with ax
	{
		s1 = "progs/player.mdl";		// model to use
		f1 = 40;					// turning speed

		// standing values
		s_f1 = 17;					// first frame
		s_f2 = 12;					// number of frames
		s_f3 = 0.1;					// frame time
		s_s1 = "misc/null.wav";			// sound file
		s_f4 = -1;					// min sound delay
		s_f5 = 0;					// % chance of playing the sound

		// walking values
		w_f1 = 0;					// first frame
		w_f2 = 6;					// number of frames
		w_f3 = 0.1;					// frame time
		w_s1 = "misc/null.wav";			// sound file
		w_f4 = -1;					// min sound delay
		w_f5 = 0;					// % chance of playing the sound
		w_f6 = 160;					// speed

		// running values
		r_f1 = 0;					// first frame
		r_f2 = 6;					// number of frames
		r_f3 = 0.1;					// frame time
		r_s1 = "misc/null.wav";			// sound file
		r_f4 = -1;					// min sound delay
		r_f5 = 0;					// % chance of playing the sound
		r_f6 = 320;					// speed

		// action one
		aa_f1 = 137;				// first frame
		aa_f2 = 7;					// number of frames
		aa_f3 = 0.1;				// frame time
		aa_s1 = "weapons/ax1.wav";		// sound file
		aa_f4 = 0;					// effects
		aa_f5 = 137;				// frame to do effects on

		// action two
		ab_f1 = 29;					// first frame
		ab_f2 = 6;					// number of frames
		ab_f3 = 0.1;				// frame time
		ab_s1 = "player/pain4.wav";		// sound file
		ab_f4 = 0;					// effects
		ab_f5 = 29;					// frame to do effects on

		// die
		d_f1 = 41;					// first frame
		d_f2 = 9;					// number of frames
		d_f3 = 0.1;					// frame time
		d_s1 = "player/death5.wav";		// sound file
		d_f6 = 41;					// frame to do effects on
	}
	else if(self.impulse == 3) // soldier
	{
		s1 = "progs/soldier.mdl";		// model to use
		f1 = 20;					// turning speed

		// standing values
		s_f1 = 0;					// first frame
		s_f2 = 8;					// number of frames
		s_f3 = 0.1;					// frame time
		s_s1 = "soldier/idle.wav";		// sound file
		s_f4 = 1;					// min sound delay
		s_f5 = 0.2;					// % chance of playing the sound

		// walking values
		w_f1 = 90;					// first frame
		w_f2 = 24;					// number of frames
		w_f3 = 0.1;					// frame time
		w_s1 = "soldier/idle.wav";		// sound file
		w_f4 = 1;					// min sound delay
		w_f5 = 0.2;					// % chance of playing the sound
		w_f6 = 28;					// speed

		// running values
		r_f1 = 73;					// first frame
		r_f2 = 8;					// number of frames
		r_f3 = 0.1;					// frame time
		r_s1 = "soldier/idle.wav";		// sound file
		r_f4 = 1;					// min sound delay
		r_f5 = 0.2;					// % chance of playing the sound
		r_f6 = 100;					// speed

		// action one
		aa_f1 = 81;					// first frame
		aa_f2 = 9;					// number of frames
		aa_f3 = 0.1;				// frame time
		aa_s1 = "soldier/sattck1.wav";	// sound file
		aa_f4 = 2;					// effects
		aa_f5 = 85;					// frame to do effects on

		// action two
		ab_f1 = 46;					// first frame
		ab_f2 = 14;					// number of frames
		ab_f3 = 0.1;				// frame time
		ab_s1 = "soldier/pain1.wav";		// sound file
		ab_f4 = 0;					// effects
		ab_f5 = 46;					// frame to do effects on

		// die
		d_f1 = 8;					// first frame
		d_f2 = 10;					// number of frames
		d_f3 = 0.1;					// frame time
		d_s1 = "soldier/death1.wav";		// sound file
		d_f6 = 8;					// frame to do effects on
	}
	else if(self.impulse == 4) // enforcer
	{
		s1 = "progs/enforcer.mdl";		// model to use
		f1 = 20;					// turning speed

		// standing values
		s_f1 = 0;					// first frame
		s_f2 = 7;					// number of frames
		s_f3 = 0.1;					// frame time
		s_s1 = "enforcer/idle1.wav";		// sound file
		s_f4 = 1;					// min sound delay
		s_f5 = 0.2;					// % chance of playing the sound

		// walking values
		w_f1 = 7;					// first frame
		w_f2 = 16;					// number of frames
		w_f3 = 0.1;					// frame time
		w_s1 = "enforcer/idle1.wav";		// sound file
		w_f4 = 1;					// min sound delay
		w_f5 = 0.2;					// % chance of playing the sound
		w_f6 = 28;					// speed

		// running values
		r_f1 = 23;					// first frame
		r_f2 = 8;					// number of frames
		r_f3 = 0.1;					// frame time
		r_s1 = "enforcer/idle1.wav";		// sound file
		r_f4 = 1;					// min sound delay
		r_f5 = 0.2;					// % chance of playing the sound
		r_f6 = 100;					// speed

		// action one
		aa_f1 = 31;					// first frame
		aa_f2 = 10;					// number of frames
		aa_f3 = 0.1;				// frame time
		aa_s1 = "enforcer/enfire.wav";	// sound file
		aa_f4 = 2;					// effects
		aa_f5 = 36;					// frame to do effects on

		// action two
		ab_f1 = 83;					// first frame
		ab_f2 = 19;					// number of frames
		ab_f3 = 0.1;				// frame time
		ab_s1 = "enforcer/pain2.wav";		// sound file
		ab_f4 = 0;					// effects
		ab_f5 = 83;					// frame to do effects on

		// die
		d_f1 = 41;					// first frame
		d_f2 = 14;					// number of frames
		d_f3 = 0.1;					// frame time
		d_s1 = "enforcer/death1.wav";		// sound file
		d_f6 = 41;					// frame to do effects on
	}

	// assign non-specific set values using the chosen auto set
	if(self.impulse >= 0)
	{
		// general values
		if(!self.model)
			self.model = s1;
		if(!self.yaw_speed)
			self.yaw_speed = f1;

		// standing values
		if(!self.weaponframe)
			self.weaponframe = s_f1;
		if(!self.weapon)
			self.weapon = s_f2;
		if(!self.pausetime)
			self.pausetime = s_f3;
		if(!self.noise)
			self.noise = s_s1;
		if(!self.sounds)
			self.sounds = s_f4;
		if(!self.items)
			self.items = s_f5;

		// walking values
		if(!self.walkframe)
			self.walkframe = w_f1;
		if(!self.lip)
			self.lip = w_f2;
		if(!self.lefty)
			self.lefty = w_f3;
		if(!self.noise1)
			self.noise1 = w_s1;
		if(!self.count)
			self.count = w_f4;
		if(!self.cnt)
			self.cnt = w_f5;
		if(!self.speed)
			self.speed = w_f6;

		// running values
		if(!self.ammo_cells)
			self.ammo_cells = r_f1;
		if(!self.ammo_shells)
			self.ammo_shells = r_f2;
		if(!self.currentammo)
			self.currentammo = r_f3;
		if(!self.noise2)
			self.noise2 = r_s1;
		if(!self.ammo_nails)
			self.ammo_nails = r_f4;
		if(!self.ammo_rockets)
			self.ammo_rockets = r_f5;
		if(!self.height)
			self.height = r_f6;

		// action one values
		if(!self.fly_sound)
			self.fly_sound = aa_f1;
		if(!self.style)
			self.style = aa_f2;
		if(!self.search_time)
			self.search_time = aa_f3;
		if(!self.noise3)
			self.noise3 = aa_s1;
		if(!self.spawnclassname)
			self.spawnclassname = aa_s2;
		if(!self.attack_finished)
			self.attack_finished = aa_f4;
		if(!self.t_length)
			self.t_length = aa_f5;

		// action two values
		if(!self.invisible_sound)
			self.invisible_sound = ab_f1;
		if(!self.invisible_time)
			self.invisible_time = ab_f2;
		if(!self.rad_time)
			self.rad_time = ab_f3;
		if(!self.noise4)
			self.noise4 = ab_s1;
		if(!self.spawnmodel)
			self.spawnmodel = ab_s2;
		if(!self.pain_finished)
			self.pain_finished = ab_f4;
		if(!self.t_width)
			self.t_width = ab_f5;

		// die values
		if(!self.invincible_sound)
			self.invincible_sound = d_f1;
		if(!self.invincible_time)
			self.invincible_time = d_f2;
		if(!self.radsuit_finished)
			self.radsuit_finished = d_f3;
		if(!self.mdl)
			self.mdl = d_s1;
		if(!self.super_time)
			self.super_time = d_f4;
		if(!self.event)
			self.event = d_s2;
		if(!self.super_sound)
			self.super_sound = d_f5;
		if(!self.invincible_finished)
			self.invincible_finished = d_f6;
	}
};

void() actor_path_values_setup =
{
	// general values
	self.impulse = self.goalentity.impulse;
	self.model = self.goalentity.model;
	self.yaw_speed = self.goalentity.yaw_speed;

		// standing values
	self.weaponframe = self.goalentity.weaponframe;
	self.weapon = self.goalentity.weapon;
	self.pausetime = self.goalentity.pausetime;
	self.noise = self.goalentity.noise;
	self.sounds = self.goalentity.sounds;
	self.items = self.goalentity.items;

	// walking values
	self.walkframe = self.goalentity.walkframe;
	self.lip = self.goalentity.lip;
	self.lefty = self.goalentity.lefty;
	self.noise1 = self.goalentity.noise1;
	self.count = self.goalentity.count;
	self.cnt = self.goalentity.cnt;
	self.speed = self.goalentity.speed;

	// running values
	self.ammo_cells = self.goalentity.ammo_cells;
	self.ammo_shells = self.goalentity.ammo_shells;
	self.currentammo = self.goalentity.currentammo;
	self.noise2 = self.goalentity.noise2;
	self.ammo_nails = self.goalentity.ammo_nails;
	self.ammo_rockets = self.goalentity.ammo_rockets;
	self.height = self.goalentity.height;

	// action one values
	self.fly_sound = self.goalentity.fly_sound;
	self.style = self.goalentity.style;
	self.search_time = self.goalentity.search_time;
	self.noise3 = self.goalentity.noise3;
	self.spawnclassname = self.goalentity.spawnclassname;
	self.attack_finished = self.goalentity.attack_finished;
	self.t_length = self.goalentity.t_length;

	// action two values
	self.invisible_sound = self.goalentity.invisible_sound;
	self.invisible_time = self.goalentity.invisible_time;
	self.rad_time = self.goalentity.rad_time;
	self.noise4 = self.goalentity.noise4;
	self.spawnmodel = self.goalentity.spawnmodel;
	self.pain_finished = self.goalentity.pain_finished;
	self.t_width = self.goalentity.t_width;

	// die values
	self.invincible_sound = self.goalentity.invincible_sound;
	self.invincible_time = self.goalentity.invincible_time;
	self.radsuit_finished = self.goalentity.radsuit_finished;
	self.mdl = self.goalentity.mdl;
	self.super_time = self.goalentity.super_time;
	self.event = self.goalentity.event;
	self.super_sound = self.goalentity.super_sound;
	self.invincible_finished = self.goalentity.invincible_finished;
};


void() path_actor =
{
	if(self.spawnflags & AP_SETMODEL)
		precache_model (self.model);

	if(self.spawnflags & AP_SETVARS)
	{
		actor_values_setup();
		precache_sound (self.noise);
		precache_sound (self.noise1);
		precache_sound (self.noise2);
		precache_sound (self.noise3);
		precache_sound (self.noise4);
		precache_sound (self.mdl);
		precache_model (self.model);
	}
};

//##########################################
//#### Stationary Actor                  ###
//##########################################

void() actor_stationary_think =
{
	if(self.volume)
	{
		if(self.attack_state == ACTORST_STAND)
			self.frame = self.weaponframe - 1;
		else if(self.attack_state == ACTORST_ACT1)
			self.frame = self.fly_sound - 1;
		else if(self.attack_state == ACTORST_ACT2)
                  self.frame = self.invisible_sound - 1;
		else
                  self.frame = self.invincible_sound - 1;

		self.volume = FALSE;
	}

	if(self.attack_state == ACTORST_STAND)
	{
		self.frame = self.frame + 1;
		if(self.frame == self.weaponframe+self.weapon)
			self.frame = self.weaponframe;

            if(self.noise)
		{
                  if(self.frame == self.weaponframe)
                  {
                        if(self.endtime < time && random() < self.items)
                        {
                              sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
                              self.endtime = time + self.sounds;
                        }
                  }
		}

		self.nextthink = time + self.pausetime;
	}
	else if(self.attack_state == ACTORST_ACT1)
	{
		self.frame = self.frame + 1;
		if(self.frame == (self.fly_sound + self.style - 1))
		{
			self.attack_state = ACTORST_STAND;
			self.volume = TRUE;
		}
		else if(self.frame == self.fly_sound)
		{
			self.target = self.spawnclassname;
		      SUB_UseTargets();
		}
		if(self.frame == self.t_length)
		{
			self.effects = self.attack_finished;
			if(self.noise3)
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}
		self.nextthink = time + self.search_time;
	}
	else if(self.attack_state == ACTORST_ACT2)
	{
		self.frame = self.frame + 1;
		if(self.frame == (self.invisible_sound + self.invisible_time - 1))
		{
			self.attack_state = ACTORST_STAND;
			self.volume = TRUE;
		}
		else if(self.frame == self.invisible_sound)
		{
			self.target = self.spawnmodel;
		      SUB_UseTargets();
		}
		if(self.frame == self.t_width)
		{
			self.effects = self.pain_finished;
			if(self.noise4)
				sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);
		}
		self.nextthink = time + self.rad_time;
	}
	else
	{
		self.frame = self.frame + 1;
		if(self.frame == (self.invincible_sound + self.invincible_time - 1))
		{
			self.think = SUB_Null;
		}
		else if(self.frame == self.invincible_sound)
			self.use = SUB_Null;
		if(self.frame == self.invincible_finished)
		{
                  self.effects = self.super_sound;
			if(self.mdl)
				sound (self, CHAN_VOICE, self.mdl, 1, ATTN_NORM);
		}
		self.nextthink = time + self.radsuit_finished;
	}
};

void() actor_stationary_use =
{
// bprint("\nActor triggered by ");
// bprint(lastnameused);
	if(lastnameused == self.targetname)
	{
		self.attack_state = ACTORST_ACT1;
		self.volume = TRUE;
	}
	else if(lastnameused == self.targetname2)
	{
		self.attack_state = ACTORST_ACT2;
		self.volume = TRUE;
	}
	else if(lastnameused == self.targetname3)
	{
		self.attack_state = ACTORST_DIE;
		self.volume = TRUE;
	}
	actor_stationary_think();
};

void() actor_stationary =
{
	actor_values_setup();

	// prechache the needed files.
	precache_sound (self.noise);
	precache_sound (self.noise3);
	precache_sound (self.noise4);
	precache_sound (self.mdl);
	precache_model (self.model);

	self.classname = "actor";

	setmodel(self, self.model);

      self.frame = self.weaponframe;
	self.attack_state = ACTORST_STAND;

	self.use = actor_stationary_use;
	self.think = actor_stationary_think;
	self.nextthink = time + self.pausetime;
};

//##########################################
//#### Moveable Actor                    ###
//##########################################

void(float setflag) ActorSetFlag =
{
	if(setflag >= ACTORMST_NOMOVE)
	{
		self.attack_state = self.attack_state - (self.attack_state & 
			(ACTORMST_NOMOVE | ACTORMST_MOVE | ACTORMST_WAIT));
	}
	else
	{
		self.attack_state = self.attack_state - (self.attack_state &
			(ACTORST_STAND | ACTORST_WALK | ACTORST_RUN | ACTORST_ACT1 |
			ACTORST_ACT2 | ACTORST_DIE));
		self.volume = TRUE;
	}

	self.attack_state = self.attack_state + setflag;
};

void() actor_movable_think =
{
	if(self.attack_state & ACTORMST_NOMOVE)
	{
		if(self.velocity)
		{
			self.velocity = '0 0 0';
			if((self.attack_state & ACTORST_WALK) ||
				(self.attack_state & ACTORST_RUN))
				ActorSetFlag(ACTORST_STAND);
			self.waitmax = -1;
		}
	}
	else if(self.attack_state & ACTORMST_WAIT)
	{
		if(self.waitmax < time)
		{
			ActorSetFlag(ACTORMST_MOVE);
			self.waitmax = time + 0.05;
			if(self.attack_state & ACTORST_STAND)
				ActorSetFlag(self.rotate_type);
		}
		else if(self.velocity)
		{
			self.velocity = '0 0 0';
			if((self.attack_state & ACTORST_WALK) ||
				(self.attack_state & ACTORST_RUN))
				ActorSetFlag(ACTORST_STAND);
		}
	}
	else
	{
		local float movespeed;

		if(self.rotate_type == ACTORST_WALK)
			movespeed = self.speed;
		else
			movespeed = self.height;

		if(self.waitmax < time)
		{
			if((vlen(self.goalentity.origin - self.origin)/movespeed) > 0.2 &&
				self.goalentity.duration == 0)
			{
				self.velocity =  normalize(self.goalentity.origin - self.origin) * movespeed;
				self.waitmax = time + (vlen(self.goalentity.origin - self.origin) / movespeed);
				if(!(self.spawnflags & ACTOR_DONTFACE) &&
					!(self.goalentity.spawnflags & AP_NOFACE))
					self.movedir = vectoangles(self.velocity);
				if(self.spawnflags & ACTOR_FLYFACE) // set turning speeds
				{
					if(self.goalentity.spawnflags & AP_SETANGLE)
						self.movedir = self.goalentity.angles;

					local float move, turntime;
					
					// the time required to make the turn in 1/10ths of a second
					turntime = (vlen(self.goalentity.origin - self.origin) / movespeed) * 10;

					//set yaw speed
					self.angles_y = anglemod( self.angles_y );
					move = self.movedir_y - self.angles_y;
					if (self.movedir_y > self.angles_y)
					{
						if (move > 180)
							move = move - 360;
					}
					else
					{
						if (move < -180)
							move = move + 360;
					}
					self.yaw_speed = move / turntime;
					
					//set pitch speed
					self.angles_y = anglemod( self.angles_y );
					move = self.movedir_y - self.angles_y;
					self.huntingcharmer = move / turntime;

					//set roll speed
					self.angles_y = anglemod( self.angles_y );
					move = self.movedir_y - self.angles_y;
					self.heal_timer = move / turntime;
				}
			}
			else
			{
				setorigin(self, self.goalentity.origin);

				self.velocity = '0 0 0';

				if(self.goalentity.spawnflags & AP_SETANGLE)
					self.movedir = self.goalentity.angles;

				if(self.goalentity.spawnflags & AP_SETVARS)
				{
					actor_path_values_setup();
					setmodel(self, self.model);
				}

				if(self.goalentity.spawnflags & AP_SETMODEL)
				{
					self.model = self.goalentity.model;
					setmodel(self, self.model);
				}

				if(self.goalentity.event)
				{
					self.target = self.goalentity.event;
					SUB_UseTargets();
				}

				if(self.goalentity.spawnflags & AP_WALK)
				{
					self.rotate_type = ACTORST_WALK;
					if(self.attack_state & ACTORST_RUN)
						ActorSetFlag(self.rotate_type);
					movespeed = self.speed;
				}
				else if(self.goalentity.spawnflags & AP_RUN)
				{
					self.rotate_type = ACTORST_RUN;
					if(self.attack_state & ACTORST_WALK)
						ActorSetFlag(self.rotate_type);
					movespeed = self.height;
				}

				if(self.goalentity.wait)
				{
					if(self.goalentity.wait == -1)
					{
						ActorSetFlag(ACTORMST_NOMOVE);
						self.waitmax = -1;
					}
					else
					{
						self.waitmax = time + self.goalentity.wait;
						ActorSetFlag(ACTORMST_WAIT);
					}
					ActorSetFlag(ACTORST_STAND);
				}

				self.lastvictim = self.goalentity;
				self.goalentity = find(world, targetname, self.goalentity.target);
				if(self.goalentity == world)
				{
					self.goalentity = self.lastvictim;
					ActorSetFlag(ACTORMST_NOMOVE);
					self.waitmax = -1;
					ActorSetFlag(ACTORST_STAND);
				}

				if(self.lastvictim.spawnflags & AP_ACT1)
				{
					ActorSetFlag(ACTORST_ACT1);
					if(self.spawnflags & ACTOR_ACTPAUSE)
					{
						if(!(self.attack_state & ACTORMST_WAIT))
						{
							ActorSetFlag(ACTORMST_WAIT);
							self.waitmax = time + (self.style * self.search_time);
						}
						else if(self.waitmax < time + (self.style * self.search_time))
							self.waitmax = time + (self.style * self.search_time);
					}
					else if(self.spawnflags & ACTOR_MOVEBREAK)
					{
						ActorSetFlag(ACTORMST_NOMOVE);
						self.waitmax = -1;
					}
				}
				else if(self.lastvictim.spawnflags & AP_ACT2)
				{
					ActorSetFlag(ACTORST_ACT2);
					if(self.spawnflags & ACTOR_ACTPAUSE)
					{
						if(!(self.attack_state & ACTORMST_WAIT))
						{
							ActorSetFlag(ACTORMST_WAIT);
							self.waitmax = time + (self.invisible_time * self.rad_time);
						}
						else if(self.waitmax < time + (self.invisible_time * self.rad_time))
							self.waitmax = time + (self.invisible_time * self.rad_time);
					}
					else if(self.spawnflags & ACTOR_MOVEBREAK)
					{
						ActorSetFlag(ACTORMST_NOMOVE);
						self.waitmax = -1;
					}
				}
				else if(self.lastvictim.spawnflags & AP_DIE)
				{
					ActorSetFlag(ACTORST_DIE);
					if((self.spawnflags & ACTOR_ACTPAUSE) ||
						(self.spawnflags & ACTOR_MOVEBREAK))
						ActorSetFlag(ACTORMST_NOMOVE);
				}

				if(self.attack_state & ACTORMST_MOVE)
				{
					if(self.goalentity.duration)
					{
						if(self.goalentity.duration < 0.1)
						{
							setorigin(self, self.goalentity.origin);
							self.waitmax = time + 0.05;
						}
						else
						{
							self.waitmax = time + self.goalentity.duration;
							self.velocity = self.goalentity.origin - self.origin;
							self.velocity = self.velocity * (1/self.goalentity.duration);
						}
					}
					else
					{
						self.velocity =  normalize(self.goalentity.origin - self.origin) * movespeed;
						self.waitmax = time + (vlen(self.goalentity.origin - self.origin) / movespeed) - 0.1;
					}

					if(self.attack_state & ACTORMST_MOVE)
					{
						if(!(self.spawnflags & ACTOR_DONTFACE) &&
							!(self.goalentity.spawnflags & AP_NOFACE))
							self.movedir = vectoangles(self.velocity);
						if(self.spawnflags & ACTOR_FLYFACE) // set turning speeds
						{
							if(self.goalentity.spawnflags & AP_SETANGLE)
								self.movedir = self.goalentity.angles;

							local float move, turntime;
					
							// the time required to make the turn in 1/10ths of a second
							turntime = (vlen(self.goalentity.origin - self.origin) / movespeed) * 10;

							//set yaw speed
							self.angles_y = anglemod( self.angles_y );
							move = self.movedir_y - self.angles_y;
							if (self.movedir_y > self.angles_y)
							{
								if (move > 180)
									move = move - 360;
							}
							else
							{
								if (move < -180)
									move = move + 360;
							}
							self.yaw_speed = move / turntime;
					
							//set pitch speed
							self.angles_y = anglemod( self.angles_y );
							move = self.movedir_y - self.angles_y;
							self.huntingcharmer = move / turntime;

							//set roll speed
							self.angles_y = anglemod( self.angles_y );
							move = self.movedir_y - self.angles_y;
							self.heal_timer = move / turntime;
						}
					}
				}
			}
		}
	}

	if(self.angles != self.movedir)
	{
		if(self.spawnflags & ACTOR_FLYFACE)
		{
			local float angdiff;
			
			angdiff = fabs(self.angles_x - self.movedir_x);
			if(angdiff < fabs(self.huntingcharmer))
				self.angles_x = self.movedir_x;
			else
				self.angles_x = anglemod(self.angles_x + self.huntingcharmer);

			angdiff = fabs(self.angles_y - self.movedir_y);
			if(angdiff < fabs(self.yaw_speed))
				self.angles_y = self.movedir_y;
			else
				self.angles_y = anglemod(self.angles_y + self.yaw_speed);

			angdiff = fabs(self.angles_z - self.movedir_z);
			if(angdiff < fabs(self.huntingcharmer))
				self.angles_z = self.movedir_z;
			else
				self.angles_z = anglemod(self.angles_z + self.heal_timer);
		}
		else if(self.angles_y != self.movedir_y)
		{
			local float move;

			self.angles_y = anglemod( self.angles_y );

			move = self.movedir_y - self.angles_y;
			if (self.movedir_y > self.angles_y)
			{
				if (move > 180)
					move = move - 360;
			}
			else
			{
				if (move < -180)
					move = move + 360;
			}

			if (move > 0)
			{
				if (move > self.yaw_speed)
					move = self.yaw_speed;
			}
			else
			{
				if (move < 0-self.yaw_speed )
					move = 0-self.yaw_speed;
			}

			self.angles_y = anglemod (self.angles_y + move);
		}
	}

	if(self.volume)
	{
		if(self.attack_state & ACTORST_STAND)
		{
			if(self.frame < self.weaponframe ||
				self.frame >= (self.weaponframe + self.weapon))
				self.frame = self.weaponframe - 1;
		}
		else if(self.attack_state & ACTORST_ACT1)
		{
			if(self.frame < self.fly_sound ||
				self.frame >= (self.fly_sound + self.style))
				self.frame = self.fly_sound - 1;
		}
		else if(self.attack_state & ACTORST_ACT2)
		{
			if(self.frame < self.invisible_sound ||
				self.frame >= (self.invisible_sound + self.invisible_time))
	                  self.frame = self.invisible_sound - 1;
		}
		else if(self.attack_state & ACTORST_WALK)
		{
			if(self.frame < self.walkframe ||
				self.frame >= (self.walkframe + self.lip))
	                  self.frame = self.walkframe - 1;
		}
		else if(self.attack_state & ACTORST_RUN)
		{
			if(self.frame < self.ammo_cells ||
				self.frame >= (self.ammo_cells + self.ammo_shells))
	                  self.frame = self.ammo_cells - 1;
		}
		else
		{
                  self.frame = self.invincible_sound - 1;
		}

		self.volume = FALSE;
	}

	if(self.attack_state & ACTORST_STAND)
	{
		self.frame = self.frame + 1;

		if(self.frame >= self.weaponframe+self.weapon)
			self.frame = self.weaponframe;

            if(self.noise)
		{
                  if(self.frame == self.weaponframe)
                  {
                        if(self.endtime < time && random() < self.items)
                        {
                              sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
                              self.endtime = time + self.sounds;
                        }
                  }
		}

		if(self.attack_state & ACTORMST_MOVE)
			ActorSetFlag(self.rotate_type);

		self.waitmin = time + self.pausetime;
	}
	else if(self.attack_state & ACTORST_ACT1)
	{
		self.frame = self.frame + 1;

		if(self.frame >= (self.fly_sound + self.style - 1))
		{
			if(self.attack_state & ACTORMST_MOVE)
				ActorSetFlag(self.rotate_type);
			else
				ActorSetFlag(ACTORST_STAND);
		}

		if(self.frame == self.fly_sound)
		{
			self.target = self.spawnclassname;
		      SUB_UseTargets();
		}

		if(self.frame == self.t_length)
		{
			self.effects = self.attack_finished;
			if(self.noise3)
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
		}

		self.waitmin = time + self.pausetime;
	}
	else if(self.attack_state & ACTORST_ACT2)
	{
		self.frame = self.frame + 1;
		if(self.frame >= (self.invisible_sound + self.invisible_time - 1))
		{
			if(self.attack_state & ACTORMST_MOVE)
				ActorSetFlag(self.rotate_type);
			else
				ActorSetFlag(ACTORST_STAND);
		}

		if(self.frame == self.invisible_sound)
		{
			self.target = self.spawnmodel;
		      SUB_UseTargets();
		}

		if(self.frame == self.t_width)
		{
			self.effects = self.pain_finished;
			if(self.noise4)
				sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);
		}

		self.waitmin = time + self.rad_time;
	}
	else if(self.attack_state & ACTORST_WALK)
	{
		self.frame = self.frame + 1;

		if(self.frame >= self.walkframe + self.lip)
			self.frame = self.walkframe;

            if(self.noise1)
		{
                  if(self.frame == self.walkframe)
                  {
                        if(self.endtime < time && random() < self.cnt)
                        {
                              sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
                              self.endtime = time + self.count;
                        }
                  }
		}

		if(!(self.attack_state & ACTORMST_MOVE))
			ActorSetFlag(ACTORST_STAND);

		self.waitmin = time + self.lefty;
	}
	else if(self.attack_state & ACTORST_RUN)
	{
		self.frame = self.frame + 1;

		if(self.frame >= self.ammo_cells + self.ammo_shells)
			self.frame = self.ammo_cells;

            if(self.noise2)
		{
                  if(self.frame == self.ammo_cells)
                  {
                        if(self.endtime < time && random() < self.ammo_rockets)
                        {
                              sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
                              self.endtime = time + self.ammo_nails;
                        }
                  }
		}

		if(!(self.attack_state & ACTORMST_MOVE))
			ActorSetFlag(ACTORST_STAND);

		self.waitmin = time + self.currentammo;
	}
	else
	{
		if(self.waitmin < time)
		{
			self.frame = self.frame + 1;
			self.waitmin = time + self.radsuit_finished;
		}

		if(self.frame == (self.invincible_sound + self.invincible_time - 1))
		{
			self.velocity = '0 0 0';
			self.think = SUB_Null;
		}
		else if(self.frame == self.invincible_sound)
			self.use = SUB_Null;
		if(self.frame == self.invincible_finished)
		{
                  self.effects = self.super_sound;
			if(self.mdl)
				sound (self, CHAN_VOICE, self.mdl, 1, ATTN_NORM);
		}
	}

	if(self.waitmax > time)
	{
		if(self.waitmax < self.waitmin)
			self.nextthink = self.waitmax;
		else
			self.nextthink = self.waitmin;
	}
	else
		self.nextthink = self.waitmin;
};

void() actor_movable_use =
{
// bprint("\nActor triggered by ");
// bprint(lastnameused);
	if(lastnameused == self.targetname)
	{
		ActorSetFlag(ACTORST_ACT1);
		if(self.spawnflags & ACTOR_ACTPAUSE)
		{
			if(!(self.attack_state & ACTORMST_WAIT))
			{
				ActorSetFlag(ACTORMST_WAIT);
				self.waitmax = time + (self.style * self.search_time);
			}
			else if(self.waitmax < time + (self.style * self.search_time))
				self.waitmax = time + (self.style * self.search_time);
		}
		else if(self.spawnflags & ACTOR_MOVEBREAK)
		{
			ActorSetFlag(ACTORMST_NOMOVE);
			self.waitmax = -1;
		}
	}
	else if(lastnameused == self.targetname2)
	{
		ActorSetFlag(ACTORST_ACT2);
		if(self.spawnflags & ACTOR_ACTPAUSE)
		{
			if(!(self.attack_state & ACTORMST_WAIT))
			{
				ActorSetFlag(ACTORMST_WAIT);
				self.waitmax = time + (self.invisible_time * self.rad_time);
			}
			else if(self.waitmax < time + (self.invisible_time * self.rad_time))
				self.waitmax = time + (self.invisible_time * self.rad_time);
		}
		else if(self.spawnflags & ACTOR_MOVEBREAK)
		{
			ActorSetFlag(ACTORMST_NOMOVE);
			self.waitmax = -1;
		}
      }
	else if(lastnameused == self.targetname3)
	{
		ActorSetFlag(ACTORST_DIE);
		if((self.spawnflags & ACTOR_ACTPAUSE) ||
			(self.spawnflags & ACTOR_MOVEBREAK))
			ActorSetFlag(ACTORMST_NOMOVE);
	}
	else if(lastnameused == self.targetname4 &&
		self.goalentity != self.lastvictim)
		ActorSetFlag(ACTORMST_MOVE);

	actor_movable_think();
};

void() actor_movable_first_think =
{
	self.goalentity = find(world, targetname, self.path);

	self.use = actor_movable_use;
	self.think = actor_movable_think;

	actor_movable_think();
};

void() actor_moveable =
{
	actor_values_setup();

	// prechache the needed files.
	precache_sound (self.noise);
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);
	precache_sound (self.noise4);
	precache_sound (self.mdl);
	precache_model (self.model);

	self.classname = "actor";

	setmodel(self, self.model);
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_NOT;

	// setup initial behavior state
	if(self.spawnflags & ACTOR_RUN)
		self.rotate_type = ACTORST_RUN;
	else
		self.rotate_type = ACTORST_WALK;

	if(self.spawnflags & ACTOR_STARTON)
	{
		ActorSetFlag(ACTORMST_MOVE);
		ActorSetFlag(self.rotate_type);
	}
	else
	{
		ActorSetFlag(ACTORMST_NOMOVE);
		ActorSetFlag(ACTORST_STAND);
	}

	self.movedir = self.angles;

      self.think = actor_movable_first_think;
	self.nextthink = time + 0.2;
};
