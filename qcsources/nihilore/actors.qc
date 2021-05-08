void() actor_values_setup = 
{
	local float s_f1;
	local float s_f2;
	local float s_f3;
	local float s_f4;
	local float s_f5;
	local string s_s1;
	local float w_f1;
	local float w_f2;
	local float w_f3;
	local float w_f4;
	local float w_f5;
	local float w_f6;
	local string w_s1;
	local float r_f1;
	local float r_f2;
	local float r_f3;
	local float r_f4;
	local float r_f5;
	local float r_f6;
	local string r_s1;
	local float aa_f1;
	local float aa_f2;
	local float aa_f3;
	local float aa_f4;
	local float aa_f5;
	local string aa_s1;
	local string aa_s2;
	local float ab_f1;
	local float ab_f2;
	local float ab_f3;
	local float ab_f4;
	local float ab_f5;
	local string ab_s1;
	local string ab_s2;
	local float d_f1;
	local float d_f2;
	local float d_f3;
	local float d_f4;
	local float d_f5;
	local float d_f6;
	local string d_s1;
	local string d_s2;
	local float f1;
	local string s1;
	if (self.impulse == MSG_BROADCAST)
	{
		s1 = "progs/player.mdl";
		f1 = SVC_INTERMISSION;
		s_f1 = STAT_TOTALMONSTERS;
		s_f2 = SVC_SETVIEWPORT;
		s_f3 = 0.1;
		s_s1 = "misc/null.wav";
		s_f4 = CONTENT_EMPTY;
		s_f5 = MSG_BROADCAST;
		w_f1 = TE_LIGHTNING2;
		w_f2 = TE_LIGHTNING2;
		w_f3 = 0.1;
		w_s1 = "misc/null.wav";
		w_f4 = CONTENT_EMPTY;
		w_f5 = MSG_BROADCAST;
		w_f6 = 160;
		r_f1 = TE_LIGHTNING2;
		r_f2 = TE_LIGHTNING2;
		r_f3 = 0.1;
		r_s1 = "misc/null.wav";
		r_f4 = CONTENT_EMPTY;
		r_f5 = MSG_BROADCAST;
		r_f6 = 320;
		aa_f1 = 113;
		aa_f2 = TE_LIGHTNING2;
		aa_f3 = 0.1;
		aa_s1 = "weapons/guncock.wav";
		aa_f4 = SPAWN_SLEEPING;
		aa_f5 = 114;
		ab_f1 = 35;
		ab_f2 = TE_LIGHTNING2;
		ab_f3 = 0.1;
		ab_s1 = "player/pain4.wav";
		ab_f4 = MSG_BROADCAST;
		ab_f5 = 35;
		d_f1 = 50;
		d_f2 = STAT_TOTALSECRETS;
		d_f3 = 0.1;
		d_s1 = "player/death5.wav";
		d_f6 = 50;
	}
	else
	{
		if (self.impulse == SPAWN_CRUCIFIED)
		{
			s1 = "progs/player.mdl";
			f1 = APOCCAM_IMPULSE;
			s_f1 = STAT_TOTALMONSTERS;
			s_f2 = SVC_SETVIEWPORT;
			s_f3 = 0.1;
			s_s1 = "misc/null.wav";
			s_f4 = CONTENT_EMPTY;
			s_f5 = MSG_BROADCAST;
			w_f1 = TE_LIGHTNING2;
			w_f2 = TE_LIGHTNING2;
			w_f3 = 0.1;
			w_s1 = "misc/null.wav";
			w_f4 = CONTENT_EMPTY;
			w_f5 = MSG_BROADCAST;
			w_f6 = 160;
			r_f1 = TE_LIGHTNING2;
			r_f2 = TE_LIGHTNING2;
			r_f3 = 0.1;
			r_s1 = "misc/null.wav";
			r_f4 = CONTENT_EMPTY;
			r_f5 = MSG_BROADCAST;
			r_f6 = 320;
			aa_f1 = 107;
			aa_f2 = TE_LIGHTNING2;
			aa_f3 = 0.1;
			aa_s1 = "weapons/sgun1.wav";
			aa_f4 = SPAWN_SLEEPING;
			aa_f5 = 108;
			ab_f1 = 35;
			ab_f2 = TE_LIGHTNING2;
			ab_f3 = 0.1;
			ab_s1 = "player/pain4.wav";
			ab_f4 = MSG_BROADCAST;
			ab_f5 = 35;
			d_f1 = 61;
			d_f2 = TE_LIGHTNING3;
			d_f3 = 0.1;
			d_s1 = "player/death5.wav";
			d_f6 = 61;
		}
		else
		{
			if (self.impulse == SPAWN_SLEEPING)
			{
				s1 = "progs/player.mdl";
				f1 = APOCCAM_IMPULSE;
				s_f1 = 17;
				s_f2 = STAT_TOTALMONSTERS;
				s_f3 = 0.1;
				s_s1 = "misc/null.wav";
				s_f4 = CONTENT_EMPTY;
				s_f5 = MSG_BROADCAST;
				w_f1 = MSG_BROADCAST;
				w_f2 = TE_LIGHTNING2;
				w_f3 = 0.1;
				w_s1 = "misc/null.wav";
				w_f4 = CONTENT_EMPTY;
				w_f5 = MSG_BROADCAST;
				w_f6 = 160;
				r_f1 = MSG_BROADCAST;
				r_f2 = TE_LIGHTNING2;
				r_f3 = 0.1;
				r_s1 = "misc/null.wav";
				r_f4 = CONTENT_EMPTY;
				r_f5 = MSG_BROADCAST;
				r_f6 = 320;
				aa_f1 = 137;
				aa_f2 = TE_WIZSPIKE;
				aa_f3 = 0.1;
				aa_s1 = "weapons/ax1.wav";
				aa_f4 = MSG_BROADCAST;
				aa_f5 = 137;
				ab_f1 = 29;
				ab_f2 = TE_LIGHTNING2;
				ab_f3 = 0.1;
				ab_s1 = "player/pain4.wav";
				ab_f4 = MSG_BROADCAST;
				ab_f5 = 29;
				d_f1 = 41;
				d_f2 = TE_LIGHTNING3;
				d_f3 = 0.1;
				d_s1 = "player/death5.wav";
				d_f6 = 41;
			}
			else
			{
				if (self.impulse == SVC_UPDATESTAT)
				{
					s1 = "progs/soldier.mdl";
					f1 = 20;
					s_f1 = MSG_BROADCAST;
					s_f2 = SECRET_NO_SHOOT;
					s_f3 = 0.1;
					s_s1 = "soldier/idle.wav";
					s_f4 = SPAWN_CRUCIFIED;
					s_f5 = 0.2;
					w_f1 = 90;
					w_f2 = 24;
					w_f3 = 0.1;
					w_s1 = "soldier/idle.wav";
					w_f4 = SPAWN_CRUCIFIED;
					w_f5 = 0.2;
					w_f6 = SVC_FOUNDSECRET;
					r_f1 = 73;
					r_f2 = SECRET_NO_SHOOT;
					r_f3 = 0.1;
					r_s1 = "soldier/idle.wav";
					r_f4 = SPAWN_CRUCIFIED;
					r_f5 = 0.2;
					r_f6 = 100;
					aa_f1 = 81;
					aa_f2 = TE_LIGHTNING3;
					aa_f3 = 0.1;
					aa_s1 = "soldier/sattck1.wav";
					aa_f4 = SPAWN_SLEEPING;
					aa_f5 = 85;
					ab_f1 = 46;
					ab_f2 = 14;
					ab_f3 = 0.1;
					ab_s1 = "soldier/pain1.wav";
					ab_f4 = MSG_BROADCAST;
					ab_f5 = 46;
					d_f1 = SECRET_NO_SHOOT;
					d_f2 = SVC_SETVIEWANGLES;
					d_f3 = 0.1;
					d_s1 = "soldier/death1.wav";
					d_f6 = SECRET_NO_SHOOT;
				}
				else
				{
					if (self.impulse == SPAWN_DEAD)
					{
						s1 = "progs/enforcer.mdl";
						f1 = 20;
						s_f1 = MSG_BROADCAST;
						s_f2 = TE_WIZSPIKE;
						s_f3 = 0.1;
						s_s1 = "enforcer/idle1.wav";
						s_f4 = SPAWN_CRUCIFIED;
						s_f5 = 0.2;
						w_f1 = TE_WIZSPIKE;
						w_f2 = SECRET_YES_SHOOT;
						w_f3 = 0.1;
						w_s1 = "enforcer/idle1.wav";
						w_f4 = SPAWN_CRUCIFIED;
						w_f5 = 0.2;
						w_f6 = SVC_FOUNDSECRET;
						r_f1 = SVC_TEMPENTITY;
						r_f2 = SECRET_NO_SHOOT;
						r_f3 = 0.1;
						r_s1 = "enforcer/idle1.wav";
						r_f4 = SPAWN_CRUCIFIED;
						r_f5 = 0.2;
						r_f6 = 100;
						aa_f1 = SVC_FINALE;
						aa_f2 = SVC_SETVIEWANGLES;
						aa_f3 = 0.1;
						aa_s1 = "enforcer/enfire.wav";
						aa_f4 = SPAWN_SLEEPING;
						aa_f5 = 36;
						ab_f1 = 83;
						ab_f2 = 19;
						ab_f3 = 0.1;
						ab_s1 = "enforcer/pain2.wav";
						ab_f4 = MSG_BROADCAST;
						ab_f5 = 83;
						d_f1 = 41;
						d_f2 = 14;
						d_f3 = 0.1;
						d_s1 = "enforcer/death1.wav";
						d_f6 = 41;
					}
				}
			}
		}
	}
	if (self.impulse >= MSG_BROADCAST)
	{
		if (!(self.model))
		{
			self.model = s1;
		}
		if (!(self.yaw_speed))
		{
			self.yaw_speed = f1;
		}
		if (!(self.weaponframe))
		{
			self.weaponframe = s_f1;
		}
		if (!(self.weapon))
		{
			self.weapon = s_f2;
		}
		if (!(self.pausetime))
		{
			self.pausetime = s_f3;
		}
		if (!(self.noise))
		{
			self.noise = s_s1;
		}
		if (!(self.sounds))
		{
			self.sounds = s_f4;
		}
		if (!(self.items))
		{
			self.items = s_f5;
		}
		if (!(self.walkframe))
		{
			self.walkframe = w_f1;
		}
		if (!(self.lip))
		{
			self.lip = w_f2;
		}
		if (!(self.lefty))
		{
			self.lefty = w_f3;
		}
		if (!(self.noise1))
		{
			self.noise1 = w_s1;
		}
		if (!(self.count))
		{
			self.count = w_f4;
		}
		if (!(self.cnt))
		{
			self.cnt = w_f5;
		}
		if (!(self.speed))
		{
			self.speed = w_f6;
		}
		if (!(self.ammo_cells))
		{
			self.ammo_cells = r_f1;
		}
		if (!(self.ammo_shells))
		{
			self.ammo_shells = r_f2;
		}
		if (!(self.currentammo))
		{
			self.currentammo = r_f3;
		}
		if (!(self.noise2))
		{
			self.noise2 = r_s1;
		}
		if (!(self.ammo_nails))
		{
			self.ammo_nails = r_f4;
		}
		if (!(self.ammo_rockets))
		{
			self.ammo_rockets = r_f5;
		}
		if (!(self.height))
		{
			self.height = r_f6;
		}
		if (!(self.fly_sound))
		{
			self.fly_sound = aa_f1;
		}
		if (!(self.style))
		{
			self.style = aa_f2;
		}
		if (!(self.search_time))
		{
			self.search_time = aa_f3;
		}
		if (!(self.noise3))
		{
			self.noise3 = aa_s1;
		}
		if (!(self.spawnclassname))
		{
			self.spawnclassname = aa_s2;
		}
		if (!(self.attack_finished))
		{
			self.attack_finished = aa_f4;
		}
		if (!(self.t_length))
		{
			self.t_length = aa_f5;
		}
		if (!(self.invisible_sound))
		{
			self.invisible_sound = ab_f1;
		}
		if (!(self.invisible_time))
		{
			self.invisible_time = ab_f2;
		}
		if (!(self.rad_time))
		{
			self.rad_time = ab_f3;
		}
		if (!(self.noise4))
		{
			self.noise4 = ab_s1;
		}
		if (!(self.spawnmodel))
		{
			self.spawnmodel = ab_s2;
		}
		if (!(self.pain_finished))
		{
			self.pain_finished = ab_f4;
		}
		if (!(self.t_width))
		{
			self.t_width = ab_f5;
		}
		if (!(self.invincible_sound))
		{
			self.invincible_sound = d_f1;
		}
		if (!(self.invincible_time))
		{
			self.invincible_time = d_f2;
		}
		if (!(self.radsuit_finished))
		{
			self.radsuit_finished = d_f3;
		}
		if (!(self.mdl))
		{
			self.mdl = d_s1;
		}
		if (!(self.super_time))
		{
			self.super_time = d_f4;
		}
		if (!(self.event))
		{
			self.event = d_s2;
		}
		if (!(self.super_sound))
		{
			self.super_sound = d_f5;
		}
		if (!(self.invincible_finished))
		{
			self.invincible_finished = d_f6;
		}
	}
};

void() actor_path_values_setup = 
{
	self.impulse = self.goalentity.impulse;
	self.model = self.goalentity.model;
	self.yaw_speed = self.goalentity.yaw_speed;
	self.weaponframe = self.goalentity.weaponframe;
	self.weapon = self.goalentity.weapon;
	self.pausetime = self.goalentity.pausetime;
	self.noise = self.goalentity.noise;
	self.sounds = self.goalentity.sounds;
	self.items = self.goalentity.items;
	self.walkframe = self.goalentity.walkframe;
	self.lip = self.goalentity.lip;
	self.lefty = self.goalentity.lefty;
	self.noise1 = self.goalentity.noise1;
	self.count = self.goalentity.count;
	self.cnt = self.goalentity.cnt;
	self.speed = self.goalentity.speed;
	self.ammo_cells = self.goalentity.ammo_cells;
	self.ammo_shells = self.goalentity.ammo_shells;
	self.currentammo = self.goalentity.currentammo;
	self.noise2 = self.goalentity.noise2;
	self.ammo_nails = self.goalentity.ammo_nails;
	self.ammo_rockets = self.goalentity.ammo_rockets;
	self.height = self.goalentity.height;
	self.fly_sound = self.goalentity.fly_sound;
	self.style = self.goalentity.style;
	self.search_time = self.goalentity.search_time;
	self.noise3 = self.goalentity.noise3;
	self.spawnclassname = self.goalentity.spawnclassname;
	self.attack_finished = self.goalentity.attack_finished;
	self.t_length = self.goalentity.t_length;
	self.invisible_sound = self.goalentity.invisible_sound;
	self.invisible_time = self.goalentity.invisible_time;
	self.rad_time = self.goalentity.rad_time;
	self.noise4 = self.goalentity.noise4;
	self.spawnmodel = self.goalentity.spawnmodel;
	self.pain_finished = self.goalentity.pain_finished;
	self.t_width = self.goalentity.t_width;
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
	if (self.spawnflags & AP_SETMODEL)
	{
		precache_model(self.model);
	}
	if (self.spawnflags & AP_SETVARS)
	{
		actor_values_setup();
		precache_sound(self.noise);
		precache_sound(self.noise1);
		precache_sound(self.noise2);
		precache_sound(self.noise3);
		precache_sound(self.noise4);
		precache_sound(self.mdl);
		precache_model(self.model);
	}
};

void() actor_stationary_think = 
{
	if (self.volume)
	{
		if (self.attack_state == ACTORST_STAND)
		{
			self.frame = self.weaponframe - SPAWN_CRUCIFIED;
		}
		else
		{
			if (self.attack_state == ACTORST_ACT1)
			{
				self.frame = self.fly_sound - SPAWN_CRUCIFIED;
			}
			else
			{
				if (self.attack_state == ACTORST_ACT2)
				{
					self.frame = self.invisible_sound - SPAWN_CRUCIFIED;
				}
				else
				{
					self.frame = self.invincible_sound - SPAWN_CRUCIFIED;
				}
			}
		}
		self.volume = 0;
	}
	if (self.attack_state == ACTORST_STAND)
	{
		self.frame = self.frame + SPAWN_CRUCIFIED;
		if (self.frame == self.weaponframe + self.weapon)
		{
			self.frame = self.weaponframe;
		}
		if (self.noise)
		{
			if (self.frame == self.weaponframe)
			{
				if (self.endtime < time && random() < self.items)
				{
					sound(self, CHAN_VOICE, self.noise, SPAWN_CRUCIFIED, ATTN_NORM);
					self.endtime = time + self.sounds;
				}
			}
		}
		self.nextthink = time + self.pausetime;
	}
	else
	{
		if (self.attack_state == ACTORST_ACT1)
		{
			self.frame = self.frame + SPAWN_CRUCIFIED;
			if (self.frame == self.fly_sound + self.style - SPAWN_CRUCIFIED)
			{
				self.attack_state = ACTORST_STAND;
				self.volume = 1;
			}
			else
			{
				if (self.frame == self.fly_sound)
				{
					self.target = self.spawnclassname;
					SUB_UseTargets();
				}
			}
			if (self.frame == self.t_length)
			{
				self.effects = self.attack_finished;
				if (self.noise3)
				{
					sound(self, CHAN_VOICE, self.noise3, SPAWN_CRUCIFIED, ATTN_NORM);
				}
			}
			self.nextthink = time + self.search_time;
		}
		else
		{
			if (self.attack_state == ACTORST_ACT2)
			{
				self.frame = self.frame + SPAWN_CRUCIFIED;
				if (self.frame == self.invisible_sound + self.invisible_time - SPAWN_CRUCIFIED)
				{
					self.attack_state = ACTORST_STAND;
					self.volume = 1;
				}
				else
				{
					if (self.frame == self.invisible_sound)
					{
						self.target = self.spawnmodel;
						SUB_UseTargets();
					}
				}
				if (self.frame == self.t_width)
				{
					self.effects = self.pain_finished;
					if (self.noise4)
					{
						sound(self, CHAN_VOICE, self.noise4, SPAWN_CRUCIFIED, ATTN_NORM);
					}
				}
				self.nextthink = time + self.rad_time;
			}
			else
			{
				self.frame = self.frame + SPAWN_CRUCIFIED;
				if (self.frame == self.invincible_sound + self.invincible_time - SPAWN_CRUCIFIED)
				{
					self.think = SUB_Null;
				}
				else
				{
					if (self.frame == self.invincible_sound)
					{
						self.use = SUB_Null;
					}
				}
				if (self.frame == self.invincible_finished)
				{
					self.effects = self.super_sound;
					if (self.mdl)
					{
						sound(self, CHAN_VOICE, self.mdl, SPAWN_CRUCIFIED, ATTN_NORM);
					}
				}
				self.nextthink = time + self.radsuit_finished;
			}
		}
	}
};

void() actor_stationary_use = 
{
	if (lastnameused == self.targetname)
	{
		self.attack_state = ACTORST_ACT1;
		self.volume = 1;
	}
	else
	{
		if (lastnameused == self.targetname2)
		{
			self.attack_state = ACTORST_ACT2;
			self.volume = 1;
		}
		else
		{
			if (lastnameused == self.targetname3)
			{
				self.attack_state = ACTORST_DIE;
				self.volume = 1;
			}
		}
	}
	actor_stationary_think();
};

void() actor_stationary = 
{
	actor_values_setup();
	precache_sound(self.noise);
	precache_sound(self.noise3);
	precache_sound(self.noise4);
	precache_sound(self.mdl);
	precache_model(self.model);
	self.classname = "actor";
	setmodel(self, self.model);
	self.frame = self.weaponframe;
	self.attack_state = ACTORST_STAND;
	self.use = actor_stationary_use;
	self.think = actor_stationary_think;
	self.nextthink = time + self.pausetime;
};

void(float setflag) ActorSetFlag = 
{
	if (setflag >= ACTORMST_NOMOVE)
	{
		self.attack_state = self.attack_state - (self.attack_state & (ACTORMST_NOMOVE | ACTORMST_MOVE | ACTORMST_WAIT));
	}
	else
	{
		self.attack_state = self.attack_state - (self.attack_state & (ACTORST_STAND | ACTORST_WALK | ACTORST_RUN | ACTORST_ACT1 | ACTORST_ACT2 | ACTORST_DIE));
		self.volume = 1;
	}
	self.attack_state = self.attack_state + setflag;
};

void() actor_movable_think = 
{
	local float movespeed;
	local float move;
	local float turntime;
	local float angdiff;
	if (self.attack_state & ACTORMST_NOMOVE)
	{
		if (self.velocity)
		{
			self.velocity = VEC_ORIGIN;
			if (self.attack_state & ACTORST_WALK || (self.attack_state & ACTORST_RUN))
			{
				ActorSetFlag(ACTORST_STAND);
			}
			self.waitmax = CONTENT_EMPTY;
		}
	}
	else
	{
		if (self.attack_state & ACTORMST_WAIT)
		{
			if (self.waitmax < time)
			{
				ActorSetFlag(ACTORMST_MOVE);
				self.waitmax = time + 0.05;
				if (self.attack_state & ACTORST_STAND)
				{
					ActorSetFlag(self.rotate_type);
				}
			}
			else
			{
				if (self.velocity)
				{
					self.velocity = VEC_ORIGIN;
					if (self.attack_state & ACTORST_WALK || (self.attack_state & ACTORST_RUN))
					{
						ActorSetFlag(ACTORST_STAND);
					}
				}
			}
		}
		else
		{
			if (self.rotate_type == ACTORST_WALK)
			{
				movespeed = self.speed;
			}
			else
			{
				movespeed = self.height;
			}
			if (self.waitmax < time)
			{
				if (vlen(self.goalentity.origin - self.origin) / movespeed > 0.2 && self.goalentity.duration == MSG_BROADCAST)
				{
					self.velocity = normalize(self.goalentity.origin - self.origin) * movespeed;
					self.waitmax = time + vlen(self.goalentity.origin - self.origin) / movespeed;
					if (!(self.spawnflags & ACTOR_DONTFACE) && !(self.goalentity.spawnflags & AP_NOFACE))
					{
						self.movedir = vectoangles(self.velocity);
					}
					if (self.spawnflags & ACTOR_FLYFACE)
					{
						if (self.goalentity.spawnflags & AP_SETANGLE)
						{
							self.movedir = self.goalentity.angles;
						}
						turntime = vlen(self.goalentity.origin - self.origin) / movespeed * SVC_SETVIEWANGLES;
						self.angles_y = anglemod(self.angles_y);
						move = self.movedir_y - self.angles_y;
						if (self.movedir_y > self.angles_y)
						{
							if (move > 180)
							{
								move = move - 360;
							}
						}
						else
						{
							if (move < -180)
							{
								move = move + 360;
							}
						}
						self.yaw_speed = move / turntime;
						self.angles_y = anglemod(self.angles_y);
						move = self.movedir_y - self.angles_y;
						self.huntingcharmer = move / turntime;
						self.angles_y = anglemod(self.angles_y);
						move = self.movedir_y - self.angles_y;
						self.heal_timer = move / turntime;
					}
				}
				else
				{
					setorigin(self, self.goalentity.origin);
					self.velocity = VEC_ORIGIN;
					if (self.goalentity.spawnflags & AP_SETANGLE)
					{
						self.movedir = self.goalentity.angles;
					}
					if (self.goalentity.spawnflags & AP_SETVARS)
					{
						actor_path_values_setup();
						setmodel(self, self.model);
					}
					if (self.goalentity.spawnflags & AP_SETMODEL)
					{
						self.model = self.goalentity.model;
						setmodel(self, self.model);
					}
					if (self.goalentity.event)
					{
						self.target = self.goalentity.event;
						SUB_UseTargets();
					}
					if (self.goalentity.spawnflags & AP_WALK)
					{
						self.rotate_type = ACTORST_WALK;
						if (self.attack_state & ACTORST_RUN)
						{
							ActorSetFlag(self.rotate_type);
						}
						movespeed = self.speed;
					}
					else
					{
						if (self.goalentity.spawnflags & AP_RUN)
						{
							self.rotate_type = ACTORST_RUN;
							if (self.attack_state & ACTORST_WALK)
							{
								ActorSetFlag(self.rotate_type);
							}
							movespeed = self.height;
						}
					}
					if (self.goalentity.wait)
					{
						if (self.goalentity.wait == CONTENT_EMPTY)
						{
							ActorSetFlag(ACTORMST_NOMOVE);
							self.waitmax = CONTENT_EMPTY;
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
					if (self.goalentity == world)
					{
						self.goalentity = self.lastvictim;
						ActorSetFlag(ACTORMST_NOMOVE);
						self.waitmax = CONTENT_EMPTY;
						ActorSetFlag(ACTORST_STAND);
					}
					if (self.lastvictim.spawnflags & AP_ACT1)
					{
						ActorSetFlag(ACTORST_ACT1);
						if (self.spawnflags & ACTOR_ACTPAUSE)
						{
							if (!(self.attack_state & ACTORMST_WAIT))
							{
								ActorSetFlag(ACTORMST_WAIT);
								self.waitmax = time + self.style * self.search_time;
							}
							else
							{
								if (self.waitmax < time + self.style * self.search_time)
								{
									self.waitmax = time + self.style * self.search_time;
								}
							}
						}
						else
						{
							if (self.spawnflags & ACTOR_MOVEBREAK)
							{
								ActorSetFlag(ACTORMST_NOMOVE);
								self.waitmax = CONTENT_EMPTY;
							}
						}
					}
					else
					{
						if (self.lastvictim.spawnflags & AP_ACT2)
						{
							ActorSetFlag(ACTORST_ACT2);
							if (self.spawnflags & ACTOR_ACTPAUSE)
							{
								if (!(self.attack_state & ACTORMST_WAIT))
								{
									ActorSetFlag(ACTORMST_WAIT);
									self.waitmax = time + self.invisible_time * self.rad_time;
								}
								else
								{
									if (self.waitmax < time + self.invisible_time * self.rad_time)
									{
										self.waitmax = time + self.invisible_time * self.rad_time;
									}
								}
							}
							else
							{
								if (self.spawnflags & ACTOR_MOVEBREAK)
								{
									ActorSetFlag(ACTORMST_NOMOVE);
									self.waitmax = CONTENT_EMPTY;
								}
							}
						}
						else
						{
							if (self.lastvictim.spawnflags & AP_DIE)
							{
								ActorSetFlag(ACTORST_DIE);
								if (self.spawnflags & ACTOR_ACTPAUSE || (self.spawnflags & ACTOR_MOVEBREAK))
								{
									ActorSetFlag(ACTORMST_NOMOVE);
								}
							}
						}
					}
					if (self.attack_state & ACTORMST_MOVE)
					{
						if (self.goalentity.duration)
						{
							if (self.goalentity.duration < 0.1)
							{
								setorigin(self, self.goalentity.origin);
								self.waitmax = time + 0.05;
							}
							else
							{
								self.waitmax = time + self.goalentity.duration;
								self.velocity = self.goalentity.origin - self.origin;
								self.velocity = self.velocity * (SPAWN_CRUCIFIED / self.goalentity.duration);
							}
						}
						else
						{
							self.velocity = normalize(self.goalentity.origin - self.origin) * movespeed;
							self.waitmax = time + vlen(self.goalentity.origin - self.origin) / movespeed - 0.1;
						}
						if (self.attack_state & ACTORMST_MOVE)
						{
							if (!(self.spawnflags & ACTOR_DONTFACE) && !(self.goalentity.spawnflags & AP_NOFACE))
							{
								self.movedir = vectoangles(self.velocity);
							}
							if (self.spawnflags & ACTOR_FLYFACE)
							{
								if (self.goalentity.spawnflags & AP_SETANGLE)
								{
									self.movedir = self.goalentity.angles;
								}
								turntime = vlen(self.goalentity.origin - self.origin) / movespeed * SVC_SETVIEWANGLES;
								self.angles_y = anglemod(self.angles_y);
								move = self.movedir_y - self.angles_y;
								if (self.movedir_y > self.angles_y)
								{
									if (move > 180)
									{
										move = move - 360;
									}
								}
								else
								{
									if (move < -180)
									{
										move = move + 360;
									}
								}
								self.yaw_speed = move / turntime;
								self.angles_y = anglemod(self.angles_y);
								move = self.movedir_y - self.angles_y;
								self.huntingcharmer = move / turntime;
								self.angles_y = anglemod(self.angles_y);
								move = self.movedir_y - self.angles_y;
								self.heal_timer = move / turntime;
							}
						}
					}
				}
			}
		}
	}
	if (self.angles != self.movedir)
	{
		if (self.spawnflags & ACTOR_FLYFACE)
		{
			angdiff = fabs(self.angles_x - self.movedir_x);
			if (angdiff < fabs(self.huntingcharmer))
			{
				self.angles_x = self.movedir_x;
			}
			else
			{
				self.angles_x = anglemod(self.angles_x + self.huntingcharmer);
			}
			angdiff = fabs(self.angles_y - self.movedir_y);
			if (angdiff < fabs(self.yaw_speed))
			{
				self.angles_y = self.movedir_y;
			}
			else
			{
				self.angles_y = anglemod(self.angles_y + self.yaw_speed);
			}
			angdiff = fabs(self.angles_z - self.movedir_z);
			if (angdiff < fabs(self.huntingcharmer))
			{
				self.angles_z = self.movedir_z;
			}
			else
			{
				self.angles_z = anglemod(self.angles_z + self.heal_timer);
			}
		}
		else
		{
			if (self.angles_y != self.movedir_y)
			{
				self.angles_y = anglemod(self.angles_y);
				move = self.movedir_y - self.angles_y;
				if (self.movedir_y > self.angles_y)
				{
					if (move > 180)
					{
						move = move - 360;
					}
				}
				else
				{
					if (move < -180)
					{
						move = move + 360;
					}
				}
				if (move > MSG_BROADCAST)
				{
					if (move > self.yaw_speed)
					{
						move = self.yaw_speed;
					}
				}
				else
				{
					if (move < MSG_BROADCAST - self.yaw_speed)
					{
						move = MSG_BROADCAST - self.yaw_speed;
					}
				}
				self.angles_y = anglemod(self.angles_y + move);
			}
		}
	}
	if (self.volume)
	{
		if (self.attack_state & ACTORST_STAND)
		{
			if (self.frame < self.weaponframe || self.frame >= self.weaponframe + self.weapon)
			{
				self.frame = self.weaponframe - SPAWN_CRUCIFIED;
			}
		}
		else
		{
			if (self.attack_state & ACTORST_ACT1)
			{
				if (self.frame < self.fly_sound || self.frame >= self.fly_sound + self.style)
				{
					self.frame = self.fly_sound - SPAWN_CRUCIFIED;
				}
			}
			else
			{
				if (self.attack_state & ACTORST_ACT2)
				{
					if (self.frame < self.invisible_sound || self.frame >= self.invisible_sound + self.invisible_time)
					{
						self.frame = self.invisible_sound - SPAWN_CRUCIFIED;
					}
				}
				else
				{
					if (self.attack_state & ACTORST_WALK)
					{
						if (self.frame < self.walkframe || self.frame >= self.walkframe + self.lip)
						{
							self.frame = self.walkframe - SPAWN_CRUCIFIED;
						}
					}
					else
					{
						if (self.attack_state & ACTORST_RUN)
						{
							if (self.frame < self.ammo_cells || self.frame >= self.ammo_cells + self.ammo_shells)
							{
								self.frame = self.ammo_cells - SPAWN_CRUCIFIED;
							}
						}
						else
						{
							self.frame = self.invincible_sound - SPAWN_CRUCIFIED;
						}
					}
				}
			}
		}
		self.volume = 0;
	}
	if (self.attack_state & ACTORST_STAND)
	{
		self.frame = self.frame + SPAWN_CRUCIFIED;
		if (self.frame >= self.weaponframe + self.weapon)
		{
			self.frame = self.weaponframe;
		}
		if (self.noise)
		{
			if (self.frame == self.weaponframe)
			{
				if (self.endtime < time && random() < self.items)
				{
					sound(self, CHAN_VOICE, self.noise, SPAWN_CRUCIFIED, ATTN_NORM);
					self.endtime = time + self.sounds;
				}
			}
		}
		if (self.attack_state & ACTORMST_MOVE)
		{
			ActorSetFlag(self.rotate_type);
		}
		self.waitmin = time + self.pausetime;
	}
	else
	{
		if (self.attack_state & ACTORST_ACT1)
		{
			self.frame = self.frame + SPAWN_CRUCIFIED;
			if (self.frame >= self.fly_sound + self.style - SPAWN_CRUCIFIED)
			{
				if (self.attack_state & ACTORMST_MOVE)
				{
					ActorSetFlag(self.rotate_type);
				}
				else
				{
					ActorSetFlag(ACTORST_STAND);
				}
			}
			if (self.frame == self.fly_sound)
			{
				self.target = self.spawnclassname;
				SUB_UseTargets();
			}
			if (self.frame == self.t_length)
			{
				self.effects = self.attack_finished;
				if (self.noise3)
				{
					sound(self, CHAN_VOICE, self.noise3, SPAWN_CRUCIFIED, ATTN_NORM);
				}
			}
			self.waitmin = time + self.pausetime;
		}
		else
		{
			if (self.attack_state & ACTORST_ACT2)
			{
				self.frame = self.frame + SPAWN_CRUCIFIED;
				if (self.frame >= self.invisible_sound + self.invisible_time - SPAWN_CRUCIFIED)
				{
					if (self.attack_state & ACTORMST_MOVE)
					{
						ActorSetFlag(self.rotate_type);
					}
					else
					{
						ActorSetFlag(ACTORST_STAND);
					}
				}
				if (self.frame == self.invisible_sound)
				{
					self.target = self.spawnmodel;
					SUB_UseTargets();
				}
				if (self.frame == self.t_width)
				{
					self.effects = self.pain_finished;
					if (self.noise4)
					{
						sound(self, CHAN_VOICE, self.noise4, SPAWN_CRUCIFIED, ATTN_NORM);
					}
				}
				self.waitmin = time + self.rad_time;
			}
			else
			{
				if (self.attack_state & ACTORST_WALK)
				{
					self.frame = self.frame + SPAWN_CRUCIFIED;
					if (self.frame >= self.walkframe + self.lip)
					{
						self.frame = self.walkframe;
					}
					if (self.noise1)
					{
						if (self.frame == self.walkframe)
						{
							if (self.endtime < time && random() < self.cnt)
							{
								sound(self, CHAN_VOICE, self.noise1, SPAWN_CRUCIFIED, ATTN_NORM);
								self.endtime = time + self.count;
							}
						}
					}
					if (!(self.attack_state & ACTORMST_MOVE))
					{
						ActorSetFlag(ACTORST_STAND);
					}
					self.waitmin = time + self.lefty;
				}
				else
				{
					if (self.attack_state & ACTORST_RUN)
					{
						self.frame = self.frame + SPAWN_CRUCIFIED;
						if (self.frame >= self.ammo_cells + self.ammo_shells)
						{
							self.frame = self.ammo_cells;
						}
						if (self.noise2)
						{
							if (self.frame == self.ammo_cells)
							{
								if (self.endtime < time && random() < self.ammo_rockets)
								{
									sound(self, CHAN_VOICE, self.noise2, SPAWN_CRUCIFIED, ATTN_NORM);
									self.endtime = time + self.ammo_nails;
								}
							}
						}
						if (!(self.attack_state & ACTORMST_MOVE))
						{
							ActorSetFlag(ACTORST_STAND);
						}
						self.waitmin = time + self.currentammo;
					}
					else
					{
						if (self.waitmin < time)
						{
							self.frame = self.frame + SPAWN_CRUCIFIED;
							self.waitmin = time + self.radsuit_finished;
						}
						if (self.frame == self.invincible_sound + self.invincible_time - SPAWN_CRUCIFIED)
						{
							self.velocity = VEC_ORIGIN;
							self.think = SUB_Null;
						}
						else
						{
							if (self.frame == self.invincible_sound)
							{
								self.use = SUB_Null;
							}
						}
						if (self.frame == self.invincible_finished)
						{
							self.effects = self.super_sound;
							if (self.mdl)
							{
								sound(self, CHAN_VOICE, self.mdl, SPAWN_CRUCIFIED, ATTN_NORM);
							}
						}
					}
				}
			}
		}
	}
	if (self.waitmax > time)
	{
		if (self.waitmax < self.waitmin)
		{
			self.nextthink = self.waitmax;
		}
		else
		{
			self.nextthink = self.waitmin;
		}
	}
	else
	{
		self.nextthink = self.waitmin;
	}
};

void() actor_movable_use = 
{
	if (lastnameused == self.targetname)
	{
		ActorSetFlag(ACTORST_ACT1);
		if (self.spawnflags & ACTOR_ACTPAUSE)
		{
			if (!(self.attack_state & ACTORMST_WAIT))
			{
				ActorSetFlag(ACTORMST_WAIT);
				self.waitmax = time + self.style * self.search_time;
			}
			else
			{
				if (self.waitmax < time + self.style * self.search_time)
				{
					self.waitmax = time + self.style * self.search_time;
				}
			}
		}
		else
		{
			if (self.spawnflags & ACTOR_MOVEBREAK)
			{
				ActorSetFlag(ACTORMST_NOMOVE);
				self.waitmax = CONTENT_EMPTY;
			}
		}
	}
	else
	{
		if (lastnameused == self.targetname2)
		{
			ActorSetFlag(ACTORST_ACT2);
			if (self.spawnflags & ACTOR_ACTPAUSE)
			{
				if (!(self.attack_state & ACTORMST_WAIT))
				{
					ActorSetFlag(ACTORMST_WAIT);
					self.waitmax = time + self.invisible_time * self.rad_time;
				}
				else
				{
					if (self.waitmax < time + self.invisible_time * self.rad_time)
					{
						self.waitmax = time + self.invisible_time * self.rad_time;
					}
				}
			}
			else
			{
				if (self.spawnflags & ACTOR_MOVEBREAK)
				{
					ActorSetFlag(ACTORMST_NOMOVE);
					self.waitmax = CONTENT_EMPTY;
				}
			}
		}
		else
		{
			if (lastnameused == self.targetname3)
			{
				ActorSetFlag(ACTORST_DIE);
				if (self.spawnflags & ACTOR_ACTPAUSE || (self.spawnflags & ACTOR_MOVEBREAK))
				{
					ActorSetFlag(ACTORMST_NOMOVE);
				}
			}
			else
			{
				if (lastnameused == self.targetname4 && self.goalentity != self.lastvictim)
				{
					ActorSetFlag(ACTORMST_MOVE);
				}
			}
		}
	}
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
	precache_sound(self.noise);
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	precache_sound(self.noise4);
	precache_sound(self.mdl);
	precache_model(self.model);
	self.classname = "actor";
	setmodel(self, self.model);
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_NOT;
	if (self.spawnflags & ACTOR_RUN)
	{
		self.rotate_type = ACTORST_RUN;
	}
	else
	{
		self.rotate_type = ACTORST_WALK;
	}
	if (self.spawnflags & ACTOR_STARTON)
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

