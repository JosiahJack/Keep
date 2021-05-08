void() ambient_general = 
{
	precache_sound(self.noise);
	if (!(self.speed))
	{
		self.speed = ATTN_STATIC;
	}
	if (!(self.volume))
	{
		self.volume = 0.5;
	}
	ambientsound(self.origin, self.noise, self.volume, self.speed);
};

void() bgm_loop = 
{
	if (self.ammo_shells == MSG_BROADCAST)
	{
		self.ammo_cells = 0;
		sound(self, self.impulse, self.noise3, self.volume, self.speed);
		if (self.target)
		{
			self.think = SUB_UseTargets;
			self.nextthink = time + self.button0;
		}
		else
		{
			self.nextthink = MSG_BROADCAST;
		}
		return;
	}
	else
	{
		if (self.ammo_shells > MSG_BROADCAST)
		{
			self.ammo_shells = self.ammo_shells - PUSH_ONCE;
		}
	}
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.speed);
	self.nextthink = time + self.button2;
};

void() bgm_use = 
{
	if (self.ammo_cells)
	{
		self.ammo_cells = 0;
		if (self.noise3 == "none")
		{
			self.think = SUB_Null;
		}
		else
		{
			if (self.noise3 != "misc/null.wav")
			{
				sound(self, self.impulse, self.noise3, self.volume, self.speed);
				if (self.target)
				{
					self.think = SUB_UseTargets;
					self.nextthink = time + self.button0;
				}
				else
				{
					self.nextthink = MSG_BROADCAST;
				}
			}
			else
			{
				sound(self, self.impulse, "misc/null.wav", self.volume, self.speed);
				if (self.target)
				{
					SUB_UseTargets();
				}
				self.nextthink = MSG_BROADCAST;
			}
		}
	}
	else
	{
		self.ammo_cells = 1;
		if (self.noise1 != "misc/null.wav")
		{
			sound(self, self.impulse, self.noise1, self.volume, self.speed);
			self.nextthink = time + self.button1;
		}
		else
		{
			sound(self, self.impulse, self.noise2, self.volume, self.speed);
			self.nextthink = time + self.button2;
		}
		if (self.button2 > MSG_BROADCAST)
		{
			self.think = bgm_loop;
		}
		else
		{
			self.think = SUB_Null;
		}
		if (self.waitmax)
		{
			self.ammo_shells = self.waitmax;
		}
		else
		{
			self.ammo_shells = CONTENT_EMPTY;
		}
	}
};

void() ambient_bgm = 
{
	if (self.noise1)
	{
		precache_sound(self.noise1);
	}
	else
	{
		self.noise1 = "misc/null.wav";
	}
	if (self.noise2)
	{
		precache_sound(self.noise2);
	}
	else
	{
		objerror("no looping wav file.\n");
	}
	if (self.noise3)
	{
		precache_sound(self.noise3);
	}
	else
	{
		self.noise3 = "misc/null.wav";
	}
	precache_sound("misc/null.wav");
	if (!(self.impulse))
	{
		self.impulse = CHAN_VOICE;
	}
	else
	{
		if (self.impulse == CONTENT_EMPTY)
		{
			self.impulse = CHAN_AUTO;
		}
	}
	self.ammo_cells = 0;
	if (self.waitmax)
	{
		self.ammo_shells = self.waitmax;
	}
	else
	{
		self.ammo_shells = CONTENT_EMPTY;
	}
	if (!(self.speed))
	{
		self.speed = ATTN_NONE;
	}
	if (!(self.volume))
	{
		self.volume = PUSH_ONCE;
	}
	if (!(self.targetname) || (self.spawnflags & BGM_START_ON))
	{
		self.think = bgm_use;
		self.nextthink = time + 1.5;
	}
	self.use = bgm_use;
};

void() pe_self_setup = 
{
	local entity tmpent;
	tmpent = find(world, targetname, self.target);
	if (!tmpent)
	{
		objerror("path entity without target");
	}
	self.goalentity = tmpent;
	self.think = SUB_Null;
};

void() path_entity_setup = 
{
	self.nextthink = time + 0.2;
	self.think = pe_self_setup;
};

void() generate_train_clones = 
{
	local entity currclone;
	local entity currpath;
	local entity tmpself;
	tmpself = self;
	currpath = self.goalentity;
	self.count = self.count + PUSH_ONCE;
	while (self.count > MSG_BROADCAST)
	{
		currpath = currpath.goalentity;
		if (!currpath)
		{
			objerror("not enouth path entities for clones");
		}
		if (currpath == self.goalentity)
		{
			self.count = MSG_BROADCAST;
			return;
		}
		currclone = spawn();
		SUB_CopyEntity(self, currclone);
		currclone.count = MSG_BROADCAST;
		currclone.goalentity = currpath;
		currclone.target = currpath.targetname;
		self = currclone;
		if (self.classname == "smtrain")
		{
			self.oldenemy = self.goalentity;
			if (self.noise1)
			{
				sound(self, CHAN_VOICE, self.noise1, PUSH_ONCE, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_VOICE, "misc/null.wav", PUSH_ONCE, ATTN_NORM);
			}
			if (self.classname == "func_move_light")
			{
				setorigin(self, self.goalentity.origin);
			}
			else
			{
				setorigin(self, self.goalentity.origin - self.mins);
			}
			if (!(self.targetname))
			{
				self.goalentity = self.goalentity.goalentity;
				if (self.duration)
				{
					SUB_CalcTimedMove(self.goalentity.origin - self.mins, self.duration, smtrain_next);
				}
				else
				{
					SUB_CalcMove(self.goalentity.origin - self.mins, self.speed, smtrain_next);
				}
			}
		}
		else
		{
			self.target = self.goalentity.target;
			setorigin(self, self.goalentity.origin - self.mins);
		}
		self = tmpself;
		self.count = self.count - PUSH_ONCE;
	}
};

void() smtrain_next = 
{
	local string temp;
	if (self.goalentity.wait)
	{
		if (self.goalentity.wait != self.wait)
		{
			self.wait = self.goalentity.wait;
			if (self.wait == CONTENT_EMPTY)
			{
				self.think = func_smtrain_setup;
				if (self.noise)
				{
					sound(self, CHAN_VOICE, self.noise, PUSH_ONCE, ATTN_NORM);
				}
				else
				{
					sound(self, CHAN_VOICE, "misc/null.wav", PUSH_ONCE, ATTN_NORM);
				}
				return;
			}
		}
		else
		{
			self.wait = MSG_BROADCAST;
		}
	}
	else
	{
		self.wait = MSG_BROADCAST;
	}
	if (self.wait)
	{
		if (self.noise)
		{
			sound(self, CHAN_VOICE, self.noise, PUSH_ONCE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "misc/null.wav", PUSH_ONCE, ATTN_NORM);
		}
		self.nextthink = self.ltime + self.wait;
		return;
	}
	if (self.goalentity.event)
	{
		temp = self.target;
		self.target = self.goalentity.event;
		self.message = self.goalentity.message;
		SUB_UseTargets();
		self.target = temp;
		self.message = string_null;
	}
	if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
	{
		self.goalentity = self.goalentity.goalentity;
		setorigin(self, self.goalentity.origin - self.mins);
		self.nextthink = self.ltime + 0.05;
	}
	else
	{
		if (self.goalentity.duration > MSG_BROADCAST)
		{
			self.duration = self.goalentity.duration;
		}
		else
		{
			if (self.goalentity.speed > MSG_BROADCAST)
			{
				self.duration = MSG_BROADCAST;
				self.speed = self.goalentity.speed;
			}
		}
		self.goalentity = self.goalentity.goalentity;
		if (self.duration)
		{
			SUB_CalcTimedMove(self.goalentity.origin - self.mins, self.duration, smtrain_next);
		}
		else
		{
			SUB_CalcMove(self.goalentity.origin - self.mins, self.speed, smtrain_next);
		}
	}
};

void() func_smtrain_setup = 
{
	local entity firsttarg;
	local entity targ;
	firsttarg = find(world, targetname, self.target);
	self.classname = "smtrain";
	self.wait = MSG_BROADCAST;
	self.goalentity = firsttarg;
	self.oldenemy = firsttarg;
	if (self.count > MSG_BROADCAST)
	{
		self.nextthink = self.ltime + 0.4;
		generate_train_clones();
		return;
	}
	if (self.noise1)
	{
		sound(self, CHAN_VOICE, self.noise1, PUSH_ONCE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "misc/null.wav", PUSH_ONCE, ATTN_NORM);
	}
	setorigin(self, firsttarg.origin - self.mins);
	if (!(self.targetname))
	{
		self.goalentity = self.goalentity.goalentity;
		if (self.duration)
		{
			SUB_CalcTimedMove(self.goalentity.origin - self.mins, self.duration, smtrain_next);
		}
		else
		{
			SUB_CalcMove(self.goalentity.origin - self.mins, self.speed, smtrain_next);
		}
	}
};

void() train_bbox_touch = 
{
	if (other.flags & FL_CLIENT || (other.flags & FL_MONSTER))
	{
		if (other.absmin_z < self.absmax_z)
		{
			other.velocity = other.velocity + self.velocity * SILENT;
		}
	}
};

void() sync_smtrain_next = 
{
	local entity currtrain;
	local entity tmpent;
	if (self.goalentity.wait)
	{
		if (self.goalentity.wait != self.wait)
		{
			self.wait = self.goalentity.wait;
			if (self.wait == CONTENT_EMPTY)
			{
				syncer_stop();
				return;
			}
		}
		else
		{
			self.wait = MSG_BROADCAST;
		}
	}
	else
	{
		self.wait = MSG_BROADCAST;
	}
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		return;
	}
	self.goalentity = self.goalentity.goalentity;
	if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
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
		if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
		{
			setorigin(self, self.goalentity.origin - self.mins);
			self.goalentity = self.goalentity.goalentity;
		}
		SUB_CalcTimedMove(self.goalentity.origin - self.mins, tmpent.duration, SUB_Null);
		currtrain = currtrain.aiment;
	} while (currtrain != tmpent.aiment);
	self = tmpent;
};

void() sync_blocked = 
{
	local entity currtrain;
	if (!(self.owner.spawnflags & SYNCER_BLOCKABLE))
	{
		other.velocity = other.velocity + self.velocity * 2.5;
		return;
	}
	if (self.owner.spawnflags & SYNCER_SYNC_BLOCK)
	{
		if (time < self.owner.attack_finished)
		{
			return;
		}
		self.owner.attack_finished = time + self.owner.delay;
		if (self.owner.dmg)
		{
			T_Damage(other, self.owner, self.owner, self.owner.dmg);
		}
		self.owner.velocity = VEC_ORIGIN;
		self.owner.think = sync_smtrain_next;
		self.owner.nextthink = time + self.owner.delay;
		currtrain = self.aiment;
		do
		{
			currtrain.velocity = VEC_ORIGIN;
			currtrain.think = SUB_Null;
			currtrain = currtrain.aiment;
		} while (currtrain != self.aiment);
	}
	else
	{
		self.attack_finished = time + self.owner.delay;
		if (time < self.attack_finished)
		{
			return;
		}
		self.attack_finished = time + self.owner.delay;
		T_Damage(other, self.owner, self.owner, self.owner.dmg);
	}
};

void() syncer_start = 
{
	local entity currtrain;
	local entity tmpent;
	currtrain = self.aiment;
	tmpent = self;
	do
	{
		self = currtrain;
		if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
		{
			setorigin(self, self.goalentity.origin - self.mins);
			self.goalentity = self.goalentity.goalentity;
		}
		SUB_CalcTimedMove(self.goalentity.origin - self.mins, tmpent.duration, SUB_Null);
		currtrain = currtrain.aiment;
	} while (currtrain != tmpent.aiment);
	self = tmpent;
	if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
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
	local entity currtrain;
	local entity tmpent;
	if (self.spawnflags & SYNCER_RETRACTABLE)
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
		} while (currtrain != tmpent.aiment);
		self = tmpent;
	}
	else
	{
		currtrain = self.aiment;
		tmpent = self;
		do
		{
			self = currtrain;
			self.velocity = VEC_ORIGIN;
			self.think = SUB_Null;
			currtrain = currtrain.aiment;
		} while (currtrain != tmpent.aiment);
		self = tmpent;
		self.velocity = VEC_ORIGIN;
		self.think = SUB_Null;
		self.think1 = SUB_Null;
	}
	self.use = syncer_start;
};

void() syncer_first_think = 
{
	local entity currtrain;
	local entity tmptrain;
	local float clonedelay;
	currtrain = find(world, targetname, self.path);
	setorigin(self, currtrain.origin);
	self.goalentity = currtrain;
	self.oldenemy = self.goalentity;
	clonedelay = MSG_BROADCAST;
	currtrain = find(world, targetname, self.target);
	if (!currtrain)
	{
		objerror("No targets found.");
	}
	self.aiment = currtrain;
	while (currtrain)
	{
		if (currtrain.owner != self)
		{
			currtrain.owner = self;
			currtrain.duration = self.duration;
			currtrain.wait = MSG_BROADCAST;
			currtrain.dmg = self.dmg;
			currtrain.noise = self.noise;
			currtrain.noise1 = self.noise1;
			currtrain.use = SUB_Null;
			currtrain.deathtype = self.deathtype;
			tmptrain = find(world, targetname, currtrain.target);
			currtrain.goalentity = tmptrain;
			currtrain.oldenemy = currtrain.goalentity;
			if (self.spawnflags & SYNCER_START_TOGETHER)
			{
				setorigin(currtrain, self.origin - currtrain.mins);
			}
			else
			{
				setorigin(currtrain, currtrain.goalentity.origin - currtrain.mins);
			}
			currtrain.classname = "smtrain";
			if (currtrain.count > MSG_BROADCAST)
			{
				if (currtrain.count * 0.020000 > clonedelay)
				{
					clonedelay = currtrain.count * 0.020000;
				}
				tmptrain = self;
				self = currtrain;
				generate_train_clones();
				self = tmptrain;
			}
		}
		currtrain = find(currtrain, targetname, self.target);
	}
	currtrain = self.aiment;
	while (currtrain)
	{
		tmptrain = find(currtrain, targetname, self.target);
		if (!tmptrain)
		{
			currtrain.aiment = self.aiment;
		}
		else
		{
			currtrain.aiment = tmptrain;
		}
		currtrain = tmptrain;
	}
	if (self.targetname != "" && !(self.spawnflags & SYNCER_START_ON))
	{
		self.think = syncer_stop;
	}
	else
	{
		self.think = syncer_start;
	}
	self.nextthink = time + 0.2 + clonedelay;
};

void() func_train_syncer = 
{
	if (!(self.target))
	{
		objerror("Needs to target a set of smooth trains.");
	}
	if (!(self.duration))
	{
		objerror("Travel duration must be used to keep trains in sync.");
	}
	precache_sound("misc/null.wav");
	if (self.spawnflags & SYNCER_BLOCKABLE && self.delay == MSG_BROADCAST)
	{
		self.delay = 0.5;
	}
	self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_NOT;
	self.classname = "syncer";
	self.think = syncer_first_think;
	self.nextthink = time + 0.4;
};

void() change_path_use = 
{
	local entity currpath;
	currpath = world;
	currpath = find(currpath, targetname, self.target);
	while (currpath)
	{
		currpath.target = self.path;
		currpath.goalentity = self.goalentity;
		currpath = find(currpath, targetname, self.target);
	}
};

void() trigger_change_path = 
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	if (!(self.target))
	{
		objerror("path changer without target");
	}
	if (!(self.path))
	{
		objerror("path changer without path destination");
	}
	self.goalentity = find(world, targetname, self.path);
	self.use = change_path_use;
};

void(vector tdest, float ttime, <function> func) SUB_CalcTimedMove = 
{
	local vector vdestdelta;
	local float len;
	local float travelspeed;
	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;
	if (tdest == self.origin)
	{
		self.velocity = VEC_ORIGIN;
		if (self.classname != "train")
		{
			func();
		}
		else
		{
			self.nextthink = self.ltime + 0.1;
		}
		return;
	}
	vdestdelta = tdest - self.origin;
	self.nextthink = self.ltime + ttime;
	self.velocity = vdestdelta * (PUSH_ONCE / ttime);
};

void() path_light = 
{
	if (!(self.model))
	{
		self.model = "progs/s_null.spr";
	}
	precache_model(self.model);
	path_entity_setup();
};

void() move_light_use = 
{
	if (self.think != func_light_find)
	{
		return;
	}
	light_next();
};

void() light_wait = 
{
	if (self.wait)
	{
		self.nextthink = time + self.wait;
		if (self.wait == CONTENT_EMPTY)
		{
			self.think = func_light_find;
		}
		if (self.noise)
		{
			sound(self, CHAN_VOICE, self.noise, PUSH_ONCE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "misc/null.wav", PUSH_ONCE, ATTN_NORM);
		}
	}
	else
	{
		self.nextthink = time + 0.1;
	}
	self.think = light_next;
};

void() light_next = 
{
	local entity targ;
	local entity flasher;
	local string temp;
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	if (!(self.target))
	{
		objerror("light_next: no next target");
	}
	if (self.noise1)
	{
		sound(self, CHAN_VOICE, self.noise1, PUSH_ONCE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "misc/null.wav", PUSH_ONCE, ATTN_NORM);
	}
	self.wait = targ.wait;
	if (self.goalentity.event)
	{
		temp = self.target;
		self.target = self.goalentity.event;
		self.message = self.goalentity.message;
		SUB_UseTargets();
		self.target = temp;
		self.message = string_null;
	}
	if (self.goalentity.spawnflags)
	{
		if (self.goalentity.spawnflags & LP_OFF)
		{
			self.effects = MSG_BROADCAST;
			if (self.spawnmaster)
			{
				remove(self.spawnmaster);
				self.spawnmaster = world;
			}
		}
		if (self.goalentity.spawnflags & LP_DIM)
		{
			if (self.effects & EF_BRIGHTFIELD)
			{
				self.effects = EF_DIMLIGHT + EF_BRIGHTFIELD;
			}
			else
			{
				self.effects = EF_DIMLIGHT;
			}
			if (self.spawnmaster)
			{
				remove(self.spawnmaster);
				self.spawnmaster = world;
			}
		}
		else
		{
			if (self.goalentity.spawnflags & LP_BRIGHT)
			{
				if (self.effects & EF_BRIGHTFIELD)
				{
					self.effects = EF_BRIGHTLIGHT + EF_BRIGHTFIELD;
				}
				else
				{
					self.effects = EF_BRIGHTLIGHT;
				}
				if (self.spawnmaster)
				{
					remove(self.spawnmaster);
					self.spawnmaster = world;
				}
			}
			else
			{
				if (self.goalentity.spawnflags & LP_FLASH)
				{
					if (self.effects & EF_BRIGHTFIELD)
					{
						self.effects = EF_BRIGHTFIELD;
					}
					else
					{
						self.effects = MSG_BROADCAST;
					}
					if (!(self.spawnmaster))
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
			}
		}
		if (self.goalentity.spawnflags & LP_FIELD)
		{
			if (self.effects & EF_BRIGHTLIGHT)
			{
				self.effects = EF_BRIGHTLIGHT + EF_BRIGHTFIELD;
			}
			else
			{
				if (self.effects & EF_DIMLIGHT)
				{
					self.effects = EF_DIMLIGHT + EF_BRIGHTFIELD;
				}
				else
				{
					self.effects = EF_BRIGHTFIELD;
				}
			}
		}
		if (self.goalentity.spawnflags & LP_SET_MODEL)
		{
			setmodel(self, self.goalentity.model);
		}
	}
	if (self.goalentity.duration < MSG_BROADCAST || self.goalentity.speed < MSG_BROADCAST)
	{
		setorigin(self, targ.origin);
		self.nextthink = time + 0.010000;
	}
	else
	{
		if (self.goalentity.duration > MSG_BROADCAST)
		{
			self.duration = self.goalentity.duration;
		}
		else
		{
			if (self.goalentity.speed > MSG_BROADCAST)
			{
				self.duration = MSG_BROADCAST;
				self.speed = self.goalentity.speed;
			}
		}
		self.ltime = time;
		if (self.duration)
		{
			SUB_CalcTimedMove(targ.origin, self.duration, light_wait);
		}
		else
		{
			SUB_CalcMove(targ.origin, self.speed, light_wait);
		}
	}
	self.goalentity = targ;
};

void() func_light_find = 
{
	local entity targ;
	targ = find(world, targetname, self.target);
	self.goalentity = targ;
	self.target = targ.target;
	setorigin(self, targ.origin);
	if (!(self.targetname))
	{
		self.nextthink = time + 0.1;
		self.think = light_next;
	}
	if (self.count > MSG_BROADCAST)
	{
		generate_train_clones();
	}
};

void() light_flash = 
{
	setorigin(self, self.owner.origin);
	self.effects = EF_MUZZLEFLASH;
	self.nextthink = time + self.delay;
};

void() func_move_light = 
{
	local entity flasher;
	if (!(self.spawnflags & LIGHT_START_OFF))
	{
		if (self.spawnflags & LIGHT_BRIGHT)
		{
			self.effects = EF_BRIGHTLIGHT;
		}
		else
		{
			if (self.spawnflags & LIGHT_FLASH)
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
			{
				self.effects = EF_DIMLIGHT;
			}
		}
		if (self.spawnflags & LIGHT_FIELD)
		{
			self.effects = self.effects & EF_BRIGHTFIELD;
		}
	}
	if (!(self.speed))
	{
		self.speed = 100;
	}
	if (!(self.target))
	{
		objerror("func_move_light without a target");
	}
	if (self.delay <= MSG_BROADCAST)
	{
		self.delay = 0.2;
	}
	if (!(self.noise))
	{
		self.noise = "misc/null.wav";
	}
	if (!(self.noise1))
	{
		self.noise1 = "misc/null.wav";
	}
	precache_sound("misc/null.wav");
	precache_sound(self.noise);
	precache_sound(self.noise1);
	if (!(self.model))
	{
		self.model = "progs/s_null.spr";
	}
	precache_model(self.model);
	setmodel(self, self.model);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	self.use = move_light_use;
	self.think = func_light_find;
	self.nextthink = time + 0.2;
};

void() heal_touch = 
{
	if (self.spawnflags & HEAL_PLAYER_ONLY && other.classname != "player")
	{
		return;
	}
	if (self.spawnflags & HEAL_MONSTER_ONLY && !(other.flags & FL_MONSTER))
	{
		return;
	}
	if (other.classname != "player" && !(other.flags & FL_MONSTER))
	{
		return;
	}
	if (other.heal_timer > time)
	{
		return;
	}
	if (other.takedamage && other.health < self.health)
	{
		sound(self, CHAN_VOICE, "misc/heal.wav", PUSH_ONCE, ATTN_NORM);
		if (other.health + self.dmg > self.health)
		{
			if (self.spawnflags & HEAL_OBEY_MAX)
			{
				T_Heal(other, self.health - other.health, MSG_BROADCAST);
			}
			else
			{
				T_Heal(other, self.health - other.health, PUSH_ONCE);
			}
		}
		else
		{
			if (self.spawnflags & HEAL_OBEY_MAX)
			{
				T_Heal(other, self.dmg, MSG_BROADCAST);
			}
			else
			{
				T_Heal(other, self.dmg, PUSH_ONCE);
			}
		}
		other.heal_timer = time + self.wait;
	}
};

void() heal_toggle = 
{
	if (self.touch == SUB_Null)
	{
		self.touch = heal_touch;
	}
	else
	{
		self.touch = SUB_Null;
	}
};

void() trigger_heal = 
{
	precache_sound("misc/heal.wav");
	InitTrigger();
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = PUSH_ONCE;
	}
	if (self.dmg == MSG_BROADCAST)
	{
		self.dmg = PUSH_ONCE;
	}
	if (self.health == MSG_BROADCAST)
	{
		self.health = 100;
	}
	else
	{
		if (self.health > 250)
		{
			self.health = 250;
		}
	}
	if (self.targetname)
	{
		self.use = heal_toggle;
		if (self.spawnflags & HEAL_START_ON)
		{
			self.touch = heal_touch;
		}
		else
		{
			self.touch = SUB_Null;
		}
	}
	else
	{
		self.touch = heal_touch;
	}
};

