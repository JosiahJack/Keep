void() main = 
{
};

void() worldspawn = 
{
	if (cvar("pr_checkextension"))
	{
		if (checkextension("DP_SND_OGGVORBIS"))
		{
			darkplaces = 1;
			ext_snd_oggvorbis = 1;
		}
	}
	lightstyle(STATE_TOP, "m");
	lightstyle(IT_RELIC1, "mmnmmommommnonmmonqnmmo");
	lightstyle(IT_RELIC2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(AS_MELEE, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle(IT_RELIC3, "mamamamamama");
	lightstyle(TE_LIGHTNING1, "jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle(TE_LIGHTNING2, "nmonqnmomnmomomno");
	lightstyle(TE_WIZSPIKE, "mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle(IT_RELIC4, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle(TE_LIGHTNING3, "aaaaaaaazzzzzzzz");
	lightstyle(TE_LAVASPLASH, "mmamammmmammamamaaamammma");
	lightstyle(TE_TELEPORT, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle(63, "a");
	precache_model("progs/player.mdl");
	precache_sound("demon/dland2.wav");
	precache_model("progs/null.spr");
	if (world.model != "maps/intro.bsp" && world.model != "maps/start.bsp" && world.model != "maps/menu.bsp")
	{
		precache_model("progs/firecolm.mdl");
		precache_model("progs/plyr.mdl");
		precache_model("progs/armor.mdl");
		precache_model("progs/icef.mdl");
		precache_model("progs/grounded.mdl");
		precache_model("progs/iced.mdl");
		precache_model("progs/beam1.mdl");
		precache_model("progs/jatkspc.mdl");
		precache_model("progs/beam2.mdl");
		precache_model("progs/fball.mdl");
		precache_model("progs/scrflash.mdl");
		precache_model("progs/twister.mdl");
		precache_model("progs/swordfx.mdl");
		precache_model("progs/divs_hit.mdl");
		precache_model("progs/shdowleg.mdl");
		precache_model("progs/gib1.mdl");
		precache_model("progs/gib2.mdl");
		precache_model("progs/gib3.mdl");
		precache_model("progs/explode1.mdl");
		precache_model("progs/gold.mdl");
		precache_model("progs/speed.spr");
		precache_model("progs/levelup.spr");
		precache_model("progs/armorup.spr");
		precache_model("progs/blood.spr");
		precache_model("progs/blood2.spr");
		precache_model("progs/shadow.spr");
		precache_model("progs/efxflash.spr");
		precache_model("progs/s_bluep.spr");
		precache_model("progs/s_redp.spr");
		precache_model("progs/dust.spr");
		precache_model("progs/lball.spr");
		precache_model("progs/hit.spr");
		precache_model("progs/hit2.spr");
		precache_model("progs/star.spr");
		precache_model("progs/jhit.spr");
		precache_model("progs/block.spr");
		precache_model("progs/spells.spr");
		precache_model("progs/lsprite.spr");
		precache_model("progs/fire.spr");
		precache_model("progs/lightnin.spr");
		precache_model("progs/chargice.spr");
		precache_model("progs/chrgebm.spr");
		precache_model("progs/cursor2.spr");
		precache_sound("weapons/lstart.wav");
		precache_sound("weapons/lhit.wav");
		precache_sound("player/owhit.wav");
		precache_sound("player/invun.wav");
		precache_sound("player/firec.wav");
		precache_sound("player/hugekick.wav");
		precache_sound("player/ledge.wav");
		precache_sound("player/grab.wav");
		precache_sound("player/djump.wav");
		precache_sound("player/climb.wav");
		precache_sound("player/run.wav");
		precache_sound("player/wrun1.wav");
		precache_sound("player/wrun2.wav");
		precache_sound("player/swrdwall.wav");
		precache_sound("player/shwing.wav");
		precache_sound("player/skid.wav");
		precache_sound("player/mmenu1.wav");
		precache_sound("player/mmenu2.wav");
		precache_sound("player/jmpflor.wav");
		precache_sound("player/swrdspin.wav");
		precache_sound("player/fast.wav");
		precache_sound("player/sword.wav");
		precache_sound("player/sword2.wav");
		precache_sound("player/sword3.wav");
		precache_sound("player/spinatk.wav");
		precache_sound("player/swordhit.wav");
		precache_sound("player/kickhit.wav");
		precache_sound("player/hit.wav");
		precache_sound("player/bighit.wav");
		precache_sound("player/wallgrab.wav");
		precache_sound("player/pain1.wav");
		precache_sound("player/pain2.wav");
		precache_sound("player/pain3.wav");
		precache_sound("player/pain4.wav");
		precache_sound("player/death.wav");
		precache_sound("player/jmphit.wav");
		precache_sound("player/yell1.wav");
		precache_sound("player/yell2.wav");
		precache_sound("player/yell3.wav");
		precache_sound("player/yell4.wav");
		precache_sound("player/bigcut.wav");
		precache_sound("player/motion1.wav");
		precache_sound("player/motion2.wav");
		precache_sound("player/jump.wav");
		precache_sound("player/block.wav");
		precache_sound("player/breath.wav");
		precache_sound("spells/fbeam.wav");
		precache_sound("spells/fball.wav");
		precache_sound("spells/fhit.wav");
		precache_sound("spells/freeze.wav");
		precache_sound("spells/shatter.wav");
		precache_sound("spells/flnch.wav");
		precache_sound("spells/lightn.wav");
		precache_sound("spells/charge.wav");
		precache_sound("spells/iceyair.wav");
		precache_sound("spells/twister.wav");
		precache_sound("weapons/lhit.wav");
		precache_sound("misc/pickup.wav");
		precache_sound("misc/shard.wav");
		precache_sound("misc/fireout.wav");
		precache_sound("misc/levelup.wav");
		precache_sound("misc/levelup2.wav");
		precache_sound("misc/land.wav");
		precache_sound("misc/hitgrond.wav");
		precache_sound("misc/h2ohit1.wav");
		precache_sound("misc/guts.wav");
		precache_sound("misc/blood.wav");
		precache_sound("misc/gold.wav");
	}
	if (world.model == "maps/start.bsp")
	{
		if (ext_snd_oggvorbis)
		{
			precache_sound("music/track2.ogg");
		}
		else
		{
			precache_sound("music/track2.wav");
		}
		precache_model("progs/title.spr");
		precache_model("progs/title2.spr");
		precache_sound("misc/title.wav");
		precache_sound("misc/title2.wav");
	}
	difficulty = cvar("skill");
	deathmatch = cvar("deathmatch");
	coop = cvar("coop");
};

float(float f) fixbyte = 
{
	f = rint(f);
	if (f > 255)
	{
		f = 255;
	}
	else
	{
		if (f < STATE_TOP)
		{
			f = STATE_TOP;
		}
	}
	return f & 255;
};

float(float s1, float s2, float s3) encode = 
{
	return fixbyte(s1) * 65536 + fixbyte(s2) * FL_ITEM + fixbyte(s3);
};

float(float parm, float which) decode = 
{
	if (which == IT_RELIC1)
	{
		return parm / 65536 & 255;
	}
	else
	{
		if (which == IT_RELIC2)
		{
			return parm / FL_ITEM & 255;
		}
		else
		{
			return parm & 255;
		}
	}
};

void() SetNewParms = 
{
	parm1 = encode(75, STATE_TOP, IT_RELIC1);
	if (parm2 == STATE_TOP || world.model == "maps/start.bsp")
	{
		parm2 = encode(AS_MELEE, STATE_TOP, STATE_TOP);
	}
	parm3 = STATE_TOP;
	parm4 = encode(STATE_TOP, STATE_TOP, IT_RELIC1);
	parm5 = STATE_TOP;
};

void() SetChangeParms = 
{
	parm1 = encode(self.health, self.ammo_shells, self.level);
	parm2 = encode(self.armorvalue, self.skin, self.armorshard);
	parm3 = self.score;
	parm4 = encode(self.currentspell, relics, STATE_TOP);
	parm5 = self.gold;
};

void() DecodeLevelParms = 
{
	if (parm1 == STATE_TOP || world.model == "maps/start.bsp")
	{
		SetNewParms();
	}
	self.health = decode(parm1, IT_RELIC1);
	self.ammo_shells = decode(parm1, IT_RELIC2);
	self.level = decode(parm1, AS_MELEE);
	self.max_health = 70 + TE_LAVASPLASH * (self.owner.level / IT_RELIC2);
	self.max_mana = 47 + TE_LAVASPLASH * (self.owner.level / AS_MELEE);
	self.armorvalue = decode(parm2, IT_RELIC1);
	self.skin = decode(parm2, IT_RELIC2);
	self.armorshard = decode(parm2, AS_MELEE);
	self.score = parm3;
	self.currentspell = decode(parm4, IT_RELIC1);
	relics = decode(parm4, IT_RELIC2);
	self.gold = parm5;
};

void() timer_levelchange = 
{
	local entity y;
	y = find(world, classname, "misc_title2");
	while (y.mode == 0)
	{
		if (self.cnt == STATE_TOP)
		{
			changelevel("intro\n");
			return;
		}
		else
		{
			changelevel("start\n");
			return;
		}
		y = find(y, classname, "misc_title2");
	}
};

void() StartFrame = 
{
	local entity h;
	if (world.model == "maps/start.bsp")
	{
		if (framecount == IT_RELIC3)
		{
			h = spawn();
			setmodel(h, string_null);
			h.cnt = STATE_TOP;
			h.think = timer_levelchange;
			h.nextthink = time + SVC_SIGNONNUM;
		}
	}
	if (world.model == "maps/intro.bsp")
	{
		if (framecount == IT_RELIC3)
		{
			h = spawn();
			setmodel(h, string_null);
			h.classname = "timer";
			h.cnt = IT_RELIC1;
			h.think = timer_levelchange;
			h.nextthink = time + 45;
		}
	}
	frameskip_delay = STATE_TOP;
	developer = cvar("developer");
	framecount = framecount + IT_RELIC1;
};

void() MakeSolidList = 
{
	local entity y;
	y = find(world, netname, "solid");
	while (y)
	{
		if (y.solid != SOLID_SLIDEBOX && y.classname != "breakable" && y.health > STATE_TOP)
		{
			y.solid = SOLID_SLIDEBOX;
			setorigin(y, y.origin);
		}
		y = find(y, netname, "solid");
	}
	y = find(world, netname, "solid");
};

void() UnmakeSolidList = 
{
	local entity y;
	y = find(world, netname, "solid");
	while (y)
	{
		if (y.classname != "breakable")
		{
			y.solid = SOLID_TRIGGER;
			setorigin(y, y.origin);
		}
		y = find(y, netname, "solid");
	}
	y = find(world, netname, "solid");
};

float(float bmin, float bvalue, float bmax) bound = 
{
	if (bvalue < bmin)
	{
		return bmin;
	}
	else
	{
		if (bvalue > bmax)
		{
			return bmax;
		}
	}
	return bvalue;
};

entity(vector org, float rad) searchradius = 
{
	local entity y;
	local entity head;
	local entity ent;
	local vector v;
	head = world;
	y = find(world, netname, "solid");
	while (y)
	{
		v_x = bound(y.absmin_x, org_x, y.absmax_x);
		v_y = bound(y.absmin_y, org_y, y.absmax_y);
		v_z = bound(y.absmin_z, org_z, y.absmax_z);
		if (vlen(v - org) < rad)
		{
			if (head)
			{
				ent.chain = y;
			}
			else
			{
				head = y;
			}
			ent = y;
		}
		y = find(y, netname, "solid");
	}
	if (head)
	{
		ent.chain = world;
	}
	return head;
};

void(float n) frameskip = 
{
	if (frameskip_ent != self)
	{
		frameskip_delay = STATE_TOP;
		frameskip_ent = self;
	}
	if (frametime > n + frameskip_delay)
	{
		frameskip_delay = frameskip_delay + n;
		self.think();
	}
	else
	{
		self.nextthink = time + n;
	}
};

float(entity targ) visible = 
{
	traceline(self.origin, targ.origin, 1, self);
	if (trace_fraction == IT_RELIC1 || (targ.solid == SOLID_BSP && targ.takedamage != DAMAGE_NO))
	{
		return 1;
	}
	else
	{
		return 0;
	}
};

