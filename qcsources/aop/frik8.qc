void() stop_alarm = 
{
	if (random() < 0.5)
	{
		sound(self, CHAN_BODY, "enviro/security/onalarm3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_BODY, "enviro/security/onalarm4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
	}
	self.think = SUB_Null;
};

void() play_alarm2 = 
{
	self.use = stop_alarm;
	sound(self, CHAN_BODY, "enviro/security/onalarm2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
	self.think = play_alarm2;
	self.nextthink = time + DOOR_DONT_LINK;
};

void() play_alarm = 
{
	sound(self, CHAN_BODY, "enviro/security/onalarm1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
	self.think = play_alarm2;
	self.nextthink = time + SPAWNFLAG_LASER;
};

void() sound_alarm = 
{
	precache_sound2("enviro/security/onalarm1.wav");
	precache_sound2("enviro/security/onalarm2.wav");
	precache_sound2("enviro/security/onalarm3.wav");
	precache_sound2("enviro/security/onalarm4.wav");
	self.use = play_alarm;
};

