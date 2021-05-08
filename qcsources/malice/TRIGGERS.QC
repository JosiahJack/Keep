entity stemp;
entity otemp;
entity s;
entity old;

void () trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

float SPAWNFLAG_NOMESSAGE    = 1;
float SPAWNFLAG_NOTOUCH    = 1;

void () multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


void () multi_trigger =
{
	if ((self.nextthink > time))
		return;
	if ((self.classname == "trigger_secret"))
	{
		if (((self.enemy.classname != "player") && (self.enemy.classname != "cbot")))
			return;
		found_secrets = (found_secrets + 1);
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);
	}
	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1.00, ATTN_NORM);
	self.takedamage = DAMAGE_NO;
	activator = self.enemy;
	SUB_UseTargets ();
	if ((self.wait > 0.00))
	{
		self.think = multi_wait;
		self.nextthink = (time + self.wait);
	}
	else
	{
		self.touch = SUB_Null;
		self.nextthink = (time + 0.1);
		self.think = SUB_Remove;
	}
};


void () multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger ();
};


void () multi_use =
{
	self.enemy = activator;
	multi_trigger ();
};


void () multi_touch =
{
	if (((other.classname != "player") && (other.classname != "cbot")))
		return;
	if ((self.movedir != VEC_ORIGIN))
	{
		makevectors (other.angles);
		if (((v_forward * self.movedir) < 0))
			return;
	}
	self.enemy = other;
	multi_trigger ();
};


void () trigger_multiple =
{
	if ((self.sounds == 1))
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else
	{
		if ((self.sounds == 2))
		{
			precache_sound ("misc/talk.wav");
			self.noise = "misc/talk.wav";
		}
		else
		{
			if ((self.sounds == 3))
			{
				precache_sound ("misc/trigger1.wav");
				self.noise = "misc/trigger1.wav";
			}
		}
	}
	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;
	InitTrigger ();
	if (self.health)
	{
		if ((self.spawnflags & SPAWNFLAG_NOTOUCH))
			objerror ("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);
	}
	else
	{
		if (!(self.spawnflags & SPAWNFLAG_NOTOUCH))
			self.touch = multi_touch;
	}
};


void () trigger_once =
{
	self.wait = -1.00;
	trigger_multiple ();
};


void () trigger_relay =
{
	self.use = SUB_UseTargets;
};


void () trigger_secret =
{
	total_secrets = (total_secrets + 1);
	self.wait = -1.00;
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = 1;
	if ((self.sounds == 1))
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else
	{
		if ((self.sounds == 2))
		{
			precache_sound ("misc/talk.wav");
			self.noise = "misc/talk.wav";
		}
	}
	trigger_multiple ();
};


void () counter_use =
{
	local string junk;

	self.count = (self.count - 1);
	if ((self.count < 0))
		return;
	if ((self.count != 0))
	{
		if (((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == FALSE)))
		{
			if ((self.count >= DOOR_DONT_LINK))
				centerprint (activator, "There are more to go...");
			else
			{
				if ((self.count == 3))
					centerprint (activator, "Only 3 more to go...");
				else
				{
					if ((self.count == 2))
						centerprint (activator, "Only 2 more to go...");
					else
						centerprint (activator, "Only 1 more to go...");
				}
			}
		}
		return;
	}
	if (((activator.classname == "player") && ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == FALSE)))
		centerprint (activator, "Sequence completed!");
	self.enemy = activator;
	multi_trigger ();
};


void () trigger_counter =
{
	self.wait = -1.00;
	if (!self.count)
		self.count = 2;
	self.use = counter_use;
};

float PLAYER_ONLY    = 1;
float SILENT    = 2;

void () play_teleport =
{
	sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1.00, ATTN_NORM);
	remove (self);
};


void (vector org) spawn_tfog =
{
	s = spawn ();
	s.origin = org;
	s.nextthink = (time + 0.2);
	s.think = play_teleport;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void (vector org) spawn_tsmallfog =
{
	s = spawn ();
	s.origin = org;
	s.nextthink = (time + 0.2);
	s.think = play_teleport;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void () tdeath_touch =
{
	if ((other == self.owner))
		return;
	if (((other.classname == "player") || (other.classname == "cbot")))
	{
		if (((self.owner.classname != "player") && (self.owner.classname != "cbot")))
		{
			T_Damage (self.owner, self, self, 50000);
			return;
		}
	}
	if (other.health)
		T_Damage (other, self, self, 50000);
};


void (vector org,entity death_owner) spawn_tdeath =
{
	local entity death;

	death = spawn ();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = VEC_ORIGIN;
	setsize (death, (death_owner.mins - '1 1 1'), (death_owner.maxs + '1 1 1'));
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = (time + 0.2);
	death.think = SUB_Remove;
	death.owner = death_owner;
	force_retouch = 2;
};


void () teleport_touch =
{
	local entity t;
	local vector org;

	if ((other.teleport_time > time))
		return;
	if (self.targetname)
	{
		if ((self.nextthink < time))
			return;
	}
	if ((((self.spawnflags & PLAYER_ONLY) && (other.classname != "player")) && (other.classname != "cbot")))
		return;
	if ((other.classname == "trigger_teleport"))
		return;
	if (((other.health <= 0) && (other.movetype != MOVETYPE_FLYMISSILE)))
		return;
	SUB_UseTargets ();
	if ((other.classname == "player"))
		spawn_tfog (other.origin);
	else
		spawn_tsmallfog (other.origin);
	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
	makevectors (t.mangle);
	org = t.origin + (32 * v_forward);
	spawn_tfog (org);
	spawn_tdeath (t.origin, other);
	setorigin (other, t.origin);
	other.angles = t.mangle;
	other.fixangle = 1;
	other.teleport_time = (time + 0.7);
	other.flags = (other.flags - (other.flags & FL_ONGROUND));
	if (!other.health)
		other.velocity = (vlen (other.velocity) * v_forward);
	else
		other.velocity = (v_forward * 300);
};


void () info_teleport_destination =
{
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.model = "";
	self.origin = (self.origin + '0 0 27');
	if (!self.targetname)
		objerror ("no targetname");
};


void () teleport_use =
{
	self.nextthink = (time + 0.2);
	force_retouch = 2;
	self.think = SUB_Null;
};


void () trigger_teleport =
{
	local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	self.flags = (self.flags | FL_ITEM);
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;
	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = ((self.mins + self.maxs) * 0.5);
		ambientsound (o, "ambience/hum1.wav", 0.5, ATTN_STATIC);
	}
};


void () trigger_skill_touch =
{
	if (((other.classname != "player") && (other.classname != "cbot")))
		return;
	cvar_set ("skill", self.message);
};


void () trigger_setskill =
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
};


void () trigger_onlyregistered_touch =
{
	local float x;

	if (((other.classname != "player") && (other.classname != "cbot")))
		return;
	if ((self.attack_finished > time))
		return;
	self.attack_finished = (time + 2.00);
	if (cvar ("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (((self.message != "") && (other.classname != "cbot")))
		{
			centerprint (other, self.message);
			x = random ();
			if ((x < 0.33))
				sound (other, CHAN_BODY, "misc/talk1.wav", 1.00, ATTN_NORM);
			else
			{
				if ((x < 0.66))
					sound (other, CHAN_BODY, "misc/talk2.wav", 1.00, ATTN_NORM);
				else
					sound (other, CHAN_BODY, "misc/talk3.wav", 1.00, ATTN_NORM);
			}
		}
	}
};


void () trigger_onlyregistered =
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};


void () hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1.00;
};


void () hurt_touch =
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = (time + 1.00);
	}
	return;
};


void () trigger_hurt =
{
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

float PUSH_ONCE    = 1;

void () trigger_push_touch =
{
	if ((other.classname == "grenade"))
		other.velocity = ((self.speed * self.movedir) * 10);
	else
	{
		if ((other.health > 0))
		{
			other.velocity = ((self.speed * self.movedir) * 10);
			if (((other.classname == "player") || (other.classname == "cbot")))
			{
				if ((other.fly_sound < time))
				{
					other.fly_sound = (time + 1.5);
					sound (other, CHAN_AUTO, "ambience/windfly.wav", 1.00, ATTN_NORM);
				}
			}
		}
	}
	if ((self.spawnflags & PUSH_ONCE))
		remove (self);
};


void () trigger_push =
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};


void () trigger_monsterjump_touch =
{
	if (((other.flags & ((FL_MONSTER | FL_FLY) | FL_SWIM)) != FL_MONSTER))
		return;
	other.velocity_x = (self.movedir_x * self.speed);
	other.velocity_y = (self.movedir_y * self.speed);
	if (!(other.flags & FL_ONGROUND))
		return;
	other.flags = (other.flags - FL_ONGROUND);
	other.velocity_z = self.height;
};


void () trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if ((self.angles == VEC_ORIGIN))
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

