void() spider_stand1 = [0, spider_stand1]
{
	ai_stand();
};

void() spider_wake1 = [0, spider_wake2]
{
	sound(self, CHAN_AUTO, "monsters/spider/sactiv.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_stand();
};

void() spider_wake2 = [1, spider_wake3]
{
	ai_stand();
};

void() spider_wake3 = [2, spider_wake4]
{
	ai_stand();
};

void() spider_wake4 = [3, spider_wake5]
{
	ai_stand();
};

void() spider_wake5 = [4, spider_wake6]
{
	ai_stand();
};

void() spider_wake6 = [5, spider_wake7]
{
	ai_stand();
};

void() spider_wake7 = [6, spider_wake8]
{
	ai_stand();
};

void() spider_wake8 = [7, spider_wake9]
{
	ai_stand();
};

void() spider_wake9 = [8, spider_wake10]
{
	ai_stand();
};

void() spider_wake10 = [9, spider_run1]
{
	ai_stand();
	HuntTarget();
};

void() spider_walk1 = [10, spider_walk2]
{
	sound(self, CHAN_BODY, "monsters/spider/swalk.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_walk(TE_LIGHTNING3);
};

void() spider_walk2 = [11, spider_walk3]
{
	ai_walk(TE_LIGHTNING2);
};

void() spider_walk3 = [12, spider_walk4]
{
	ai_walk(TE_LIGHTNING3);
};

void() spider_walk4 = [13, spider_walk5]
{
	ai_walk(12);
};

void() spider_walk5 = [14, spider_walk6]
{
	sound(self, CHAN_BODY, "monsters/spider/swalk.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_walk(TE_LIGHTNING3);
};

void() spider_walk6 = [15, spider_walk7]
{
	ai_walk(TE_LIGHTNING3);
};

void() spider_walk7 = [16, spider_walk8]
{
	ai_walk(TE_LIGHTNING3);
};

void() spider_walk8 = [17, spider_walk1]
{
	ai_walk(12);
};

void() spider_run1 = [10, spider_run2]
{
	sound(self, CHAN_BODY, "monsters/spider/swalk.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_run(SECRET_YES_SHOOT);
};

void() spider_run2 = [11, spider_run3]
{
	ai_run(20);
};

void() spider_run3 = [12, spider_run4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() spider_run4 = [13, spider_run5]
{
	sound(self, CHAN_BODY, "monsters/spider/swalk.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_run(18);
};

void() spider_run5 = [14, spider_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() spider_run6 = [15, spider_run7]
{
	ai_run(20);
};

void() spider_run7 = [16, spider_run8]
{
	sound(self, CHAN_ITEM, "monsters/spider/sactiv.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_run(14);
};

void() spider_run8 = [17, spider_run1]
{
	ai_run(15);
};

void() spider_die2 = 
{
	T_RadiusDamage(self, self, 80, self.other2);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowHead("progs/spidgib.mdl", self.health - 40 - random() * 40);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() spider_die = 
{
	self.think = spider_die2;
	self.nextthink = time;
	self.other2 = other;
};

void() spider_blowup = 
{
	T_Damage(self, self, self, self.health);
};

void() spider_melee = 
{
	sound(self, CHAN_ITEM, "monsters/spider/sactiv.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.nextthink = time + 0.5;
	self.think = spider_blowup;
};

void() monster_spider = 
{
	local float r;
	r = random();
	if (deathmatch)
	{
		remove(self);
		return;
	}
	if (self.classname == "monster_spider")
	{
		self.mdl = "progs/spid.mdl";
	}
	precache_model(self.mdl);
	precache_model("progs/spidgib.mdl");
	precache_model("progs/spid.mdl");
	precache_sound("monsters/spider/sactiv.wav");
	precache_sound("monsters/spider/swalk.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, self.mdl);
	setsize(self, '-10 -16 -1', '8 16 24');
	self.health = 50;
	self.th_stand = spider_stand1;
	self.th_walk = spider_walk1;
	self.th_run = spider_run1;
	self.th_melee = spider_melee;
	self.th_die = spider_die;
	walkmonster_start();
};

