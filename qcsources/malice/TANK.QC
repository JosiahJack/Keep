void () boss_die;
void (float forward,float back,float right,float left,string name) blastsmoke;

void () gunnablow =
{
	sound (self, CHAN_AUTO, "weapons/r_exp3.wav", 1.00, ATTN_NONE);
	MorterExplode ();
};


void () short_circuit =
{
	setmodel (self, "maps/tank5.bsp");
	setsize (self, '-45 -45 -24', '45 45 20');
	self.velocity_z = 600;
	self.avelocity = '200 100 0';
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = gunnablow;
	sound (self, CHAN_AUTO, "weapons/r_exp3.wav", 1.00, ATTN_NONE);
};


void () checkface =
{
	self.enemy = checkclient ();
	if (((self.atomic_intensity == -66) && (random () < 0.03)))
		short_circuit ();
	self.nextthink = (time + 0.01);
};

void () tank_path = [ 0, tank_path1 ]
{
	self.nextthink = (time + 0.01);
};

void () tank_path1 = [ 0, tank_path ]
{
	self.nextthink = (time + 0.01);
};


void () monster_tank =
{
	if (deathmatch)
		remove (self);
	precache_model ("maps/tank4.bsp");
	precache_model ("maps/tank5.bsp");
	self.classname = "tanker_primer";
	setmodel (self, "maps/tank4.bsp");
	setsize (self, '-45 -45 -24', '45 45 20');
	self.think = checkface;
	self.nextthink = (time + 0.01);
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_STEP;
};


void () monster_tank2 =
{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("maps/tank3.bsp");
	self.classname = "tanker_primer2";
	setmodel (self, "maps/tank3.bsp");
	setsize (self, VEC_HULL_MIN, '16 16 40');
	self.th_stand = tank_path;
	self.th_walk = tank_path;
	self.th_run = tank_path;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_STEP;
	walkmonster_start ();
};


void () kamikaze =
{
	local vector kamicaze;
	local vector atat;

	kamicaze = normalize (((self.enemy.origin + (self.enemy.velocity * 0.5)) - self.origin));
	self.velocity = kamicaze;
	self.velocity = (self.velocity * 800);
	self.nextthink = (time + 0.01);
	self.touch = MorterTouch;
	atat = (self.enemy.origin - self.origin);
	self.angles = vectoangles (atat);
	if ((random () < 0.2))
	{
		blastsmoke (150, 0, 0, 0, "progs/s_smoke.spr");
		blastsmoke (0, 150, 0, 0, "progs/s_smoke.spr");
		blastsmoke (0, 0, 150, 0, "progs/s_smoke.spr");
		blastsmoke (0, 0, 0, 150, "progs/s_smoke.spr");
		sound (self, CHAN_AUTO, "bossman/jets.wav", 1.00, ATTN_NORM);
	}
	if ((random () < 0.05))
		sound (self, CHAN_AUTO, "bossman/death2.wav", 1.00, ATTN_NONE);
};


void () boss_die2 =
{
	
	local entity tan;
	local entity tan2;

	sound (self, CHAN_AUTO, "bossman/death.wav", 1.00, ATTN_NONE);
	self.think = boss_die;
	self.nextthink = (time + 0.01);
	tan = find (world, classname, "tanker_primer");
	tan2 = find (world, classname, "tanker_primer2");
	tan.atomic_intensity = -66;
	killed_monsters = (killed_monsters + 1);
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
};


void () boss_die =
{
	self.velocity_z = 260;
	self.atomic_intensity = (self.atomic_intensity + 1);
	if ((random () < 0.3))
	{
		blastsmoke (150, 0, 0, 0, "progs/s_smoke.spr");
		blastsmoke (0, 150, 0, 0, "progs/s_smoke.spr");
		blastsmoke (0, 0, 150, 0, "progs/s_smoke.spr");
		blastsmoke (0, 0, 0, 150, "progs/s_smoke.spr");
	}
	if ((self.atomic_intensity > 35))
		self.think = kamikaze;
	self.nextthink = (time + 0.01);
};


void () boss_pain =
{
	local float x;

	x = random ();
	if ((x < 0.25))
		sound (self, CHAN_AUTO, "bossman/pain1.wav", 1.00, ATTN_NONE);
	else
	{
		if ((x < 0.5))
			sound (self, CHAN_AUTO, "bossman/pain2.wav", 1.00, ATTN_NONE);
		else
		{
			if ((x < 0.75))
				sound (self, CHAN_AUTO, "bossman/pain3.wav", 1.00, ATTN_NONE);
			else
				sound (self, CHAN_AUTO, "bossman/pain4.wav", 1.00, ATTN_NORM);
		}
	}
};


void () Coverfire =
{
	local vector firepath;
	local vector runaway;
	local entity missile;

	sound (self, CHAN_AUTO, "weapons/hellfire.wav", 1.00, ATTN_NORM);
	runaway = (self.enemy.velocity - '0 0 30');
	firepath = normalize (((self.enemy.origin + runaway) - self.origin));
	makevectors (self.angles);
	missile = spawn ();
	missile.owner = self;
	missile.classname = "stinger";
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.velocity = firepath;
	missile.velocity = (missile.velocity * 600);
	missile.angles = vectoangles (missile.velocity);
	missile.touch = T_MissileTouch;
	setmodel (missile, "progs/rocket.mdl");
	setsize (missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (missile, ((self.origin + (v_forward * 20)) + '0 0 10'));
};

void () boss_brain;

void () rocket_back =
{
	local vector atat;

	
	local entity tan;
	local float dist;
	local float dist2;

	self.enemy = checkclient ();
	atat = (self.enemy.origin - self.origin);
	self.angles = vectoangles (atat);
	self.velocity_z = -260;
	tan = find (world, classname, "tanker_primer");
	self.origin_x = tan.origin_x;
	self.origin_y = tan.origin_y;
	self.atomic_intensity = (self.atomic_intensity - 1);
	dist = vlen ((self.origin - tan.origin));
	dist2 = fabs (dist);
	if ((dist2 < 100))
	{
		sound (self, CHAN_AUTO, "doors/drclos4.wav", 1.00, ATTN_NORM);
		self.think = boss_brain;
		self.atomic_intensity = 0.05;
	}
	self.nextthink = (time + 0.01);
};


void () rocket_away =
{
	local vector atat;
	local entity tan;

	self.enemy = checkclient ();
	atat = (self.enemy.origin - self.origin);
	self.angles = vectoangles (atat);
	self.velocity_z = 260;
	tan = find (world, classname, "tanker_primer");
	self.origin_x = tan.origin_x;
	self.origin_y = tan.origin_y;
	self.atomic_intensity = (self.atomic_intensity + 1);
	if ((self.atomic_intensity > 40))
		self.think = rocket_back;
	self.nextthink = (time + 0.01);
	if ((random () < 0.06))
		Coverfire ();
	if ((random () < 0.2))
	{
		blastsmoke (300, 0, 0, 0, "progs/s_expshl.spr");
		blastsmoke (0, 300, 0, 0, "progs/s_expshl.spr");
		blastsmoke (0, 0, 300, 0, "progs/s_expshl.spr");
		blastsmoke (0, 0, 0, 300, "progs/s_expshl.spr");
		sound (self, CHAN_AUTO, "bossman/jets.wav", 1.00, ATTN_NORM);
	}
};


void () FireBossGun =
{
	local vector firepath;
	local entity pulse;

	sound (self, CHAN_AUTO, "misc/discharg.wav", 1.00, ATTN_NONE);
	firepath = normalize ((self.enemy.origin - self.origin));
	pulse = spawn ();
	pulse.owner = self;
	pulse.classname = "AtomSmasher";
	pulse.movetype = MOVETYPE_FLYMISSILE;
	pulse.solid = SOLID_BBOX;
	makevectors (self.angles);
	pulse.velocity = firepath;
	pulse.velocity = (pulse.velocity * 600);
	pulse.velocity_z = 0;
	pulse.angles = vectoangles (pulse.velocity);
	pulse.avelocity = '0 0 250';
	pulse.touch = AtomSmash;
	pulse.effects = EF_DIMLIGHT;
	pulse.nextthink = time;
	pulse.think = ionstorm;
	setmodel (pulse, "progs/null.spr");
	setsize (pulse, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (pulse, ((self.origin + (v_forward * 100)) - '0 0 60'));
};


void () boss_brain =
{
	local entity tan;

	
	local entity tan2;

	
	local vector atat;

	
	local float len;

	self.enemy = checkclient ();
	tan = find (world, classname, "tanker_primer");
	setorigin (self, (tan.origin + '0 0 65'));
	if ((self.punish_eject == 0))
	{
		tan2 = find (world, classname, "tanker_primer2");
		if ((tan2.velocity == VEC_ORIGIN))
		{
			sound (self, CHAN_AUTO, "bossman/sight.wav", 1.00, ATTN_NONE);
			self.punish_eject = TRUE;
		}
	}
	atat = (self.enemy.origin - self.origin);
	self.angles = vectoangles (atat);
	if (((random () < 0.01) && visible (self.enemy)))
	{
		self.atomic_intensity = (0.025 + (random () * 0.025));
		FireBossGun ();
	}
	len = vlen ((self.enemy.origin - self.origin));
	if ((len < 600))
		self.think = rocket_away;
	self.nextthink = (time + 0.01);
};


void () monster_bossman =
{
	if (deathmatch)
		remove (self);
	precache_sound ("bossman/sight.wav");
	precache_sound ("bossman/death.wav");
	precache_sound ("bossman/pain1.wav");
	precache_sound ("bossman/pain2.wav");
	precache_sound ("bossman/pain3.wav");
	precache_sound ("bossman/pain4.wav");
	precache_sound ("bossman/jets.wav");
	precache_sound ("doors/drclos4.wav");
	precache_sound ("bossman/death2.wav");
	precache_sound ("misc/thud.wav");
	precache_sound ("misc/ion.wav");
	precache_sound ("misc/intense.wav");
	precache_sound ("misc/discharg.wav");
	precache_model ("progs/bossman.mdl");
	self.solid = SOLID_BBOX;
	setmodel (self, "progs/bossman.mdl");
	setsize (self, '-20 -20 0', '20 20 40');
	self.origin_z = (self.origin_z + 100);
	self.health = 500;
	dealwithskill ();
	self.th_die = boss_die2;
	self.th_pain = boss_pain;
	self.think = boss_brain;
	self.nextthink = (time + 0.01);
	self.movetype = MOVETYPE_FLY;
	self.takedamage = DAMAGE_AIM;
};


void (float forward,float back,float right,float left,string name) blastsmoke =
{
	local entity smok;
	local vector direct;

	smok = spawn ();
	smok.owner = self;
	smok.movetype = MOVETYPE_NOCLIP;
	smok.solid = SOLID_NOT;
	makevectors (self.angles);
	direct = normalize (((((v_forward * forward) - (v_forward * back)) + (v_right * right)) - (v_right * left)));
	smok.velocity = direct;
	smok.velocity = (smok.velocity * -300);
	setmodel (smok, name);
	setsize (smok, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (smok, (self.origin + '0 0 -40'));
	smok.nextthink = time;
	smok.think = shell1;
};

