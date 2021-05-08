void () cbt_stand1 = [ 0, cbt_stand1 ]
{
	cbot_ai_stand ();
};

void () cbt_jump1 = [ 58, cbt_jump2 ]
{
};

void () cbt_jump2 = [ 59, cbt_jump3 ]
{
};

void () cbt_jump3 = [ 60, cbt_jump4 ]
{
};

void () cbt_jump4 = [ 61, cbt_jump5 ]
{
};

void () cbt_jump5 = [ 62, cbt_jump6 ]
{
};

void () cbt_jump6 = [ 63, cbt_jump7 ]
{
};

void () cbt_jump7 = [ 64, cbt_jump8 ]
{
};

void () cbt_jump8 = [ 65, cbt_jump9 ]
{
};

void () cbt_jump9 = [ 66, cbt_jump10 ]
{
};

void () cbt_jump10 = [ 67, cbt_run1 ]
{
	cbot_ai_run (25);
};

void () Fly_Fuck;
void () attack_pattern;

void () Engage =
{
	local vector jump_vec;
	local float vel;

	vel = (280 + (random () * 25));
	makevectors (self.angles);
	if ((random () < 0.33))
	{
		self.velocity_x = ((v_forward_x * vel) * -1);
		self.velocity_y = ((v_forward_y * vel) * -1);
	}
	else
	{
		if ((random () < 0.66))
		{
			self.velocity_x = (((v_right_x * vel) / 2) + ((v_forward_x * vel) / 2));
			self.velocity_y = (((v_right_y * vel) / 2) + ((v_forward_y * vel) / 2));
		}
		else
		{
			self.velocity_x = (((v_right_x * vel) / -2) + ((v_forward_x * vel) / 2));
			self.velocity_y = (((v_right_y * vel) / -2) + ((v_forward_y * vel) / 2));
		}
	}
	if ((self.flags & FL_ONGROUND))
	{
		self.flags = (self.flags - FL_ONGROUND);
		self.velocity_z = vel;
		self.botmode = JUMP;
	}
	self.nextthink = (time + 0.3);
	sound (self, CHAN_BODY, "weapons/punish4.wav", 1.00, ATTN_NORM);
};


void () NarfSprite =
{
	local entity narf;

	narf = spawn ();
	narf.movetype = MOVETYPE_NONE;
	narf.solid = SOLID_NOT;
	narf.nextthink = time;
	narf.think = RailExplosion;
	setsize (narf, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (narf, (self.origin - '0 0 10'));
};

void () cbt_rocketjump1 = [ 58, cbt_rocketjump2 ]
{
};

void () cbt_rocketjump2 = [ 59, cbt_rocketjump3 ]
{
};

void () cbt_rocketjump3 = [ 60, cbt_rocketjump4 ]
{
};

void () cbt_rocketjump4 = [ 61, cbt_rocketjump5 ]
{
	Engage ();
	NarfSprite ();
};

void () cbt_rocketjump5 = [ 62, cbt_rocketjump6 ]
{
};

void () cbt_rocketjump6 = [ 63, cbt_rocketjump7 ]
{
};

void () cbt_rocketjump7 = [ 64, cbt_rocketjump8 ]
{
};

void () cbt_rocketjump8 = [ 65, cbt_rocketjump9 ]
{
};

void () cbt_rocketjump9 = [ 66, cbt_rocketjump10 ]
{
};

void () cbt_rocketjump10 = [ 67, cbt_dodge1 ]
{
	cbot_attack ();
};

void () cbt_dodge1;

void () attack_pattern =
{
	self.nextthink = (time + 0.05);
	if (cbot_incoming_missile ())
	{
		if ((random () < 0.3))
			cbot_slide (10);
		else
			cbt_rocketjump1 ();
	}
	if (((random () > 0.98) && (time > self.attack_finished)))
		cbot_fire_weapon ();
	else
	{
		if ((random () > 0.985))
			cbt_rocketjump1 ();
		else
		{
			if ((random () < 0.9999))
				cbot_slide (1);
			else
				cbot_retreat (1);
			cbot_track_target ();
			if ((!visible (self.enemy) || (self.enemy.health < 1)))
				cbot_attack ();
		}
	}
};

void () cbt_dodge1 = [ 0, cbt_dodge2 ]
{
	attack_pattern ();
};

void () cbt_dodge2 = [ 103, cbt_dodge3 ]
{
	attack_pattern ();
};

void () cbt_dodge3 = [ 1, cbt_dodge4 ]
{
	attack_pattern ();
};

void () cbt_dodge4 = [ 104, cbt_dodge5 ]
{
	attack_pattern ();
};

void () cbt_dodge5 = [ 2, cbt_dodge6 ]
{
	attack_pattern ();
};

void () cbt_dodge6 = [ 105, cbt_dodge7 ]
{
	attack_pattern ();
};

void () cbt_dodge7 = [ 3, cbt_dodge8 ]
{
	attack_pattern ();
};

void () cbt_dodge8 = [ 106, cbt_dodge9 ]
{
	attack_pattern ();
};

void () cbt_dodge9 = [ 4, cbt_dodge10 ]
{
	attack_pattern ();
};

void () cbt_dodge10 = [ 107, cbt_dodge11 ]
{
	attack_pattern ();
};

void () cbt_dodge11 = [ 5, cbt_dodge12 ]
{
	attack_pattern ();
};

void () cbt_dodge12 = [ 108, cbt_dodge13 ]
{
	attack_pattern ();
};

void () cbt_dodge13 = [ 6, cbt_dodge14 ]
{
	attack_pattern ();
};

void () cbt_dodge14 = [ 109, cbt_dodge15 ]
{
	attack_pattern ();
};

void () cbt_dodge15 = [ 7, cbt_dodge16 ]
{
	attack_pattern ();
};

void () cbt_dodge16 = [ 110, cbt_dodge1 ]
{
	cbot_attack ();
};

void () cbt_dodgeb1 = [ 8, cbt_dodgeb2 ]
{
	attack_pattern ();
};

void () cbt_dodgeb2 = [ 111, cbt_dodgeb3 ]
{
	attack_pattern ();
};

void () cbt_dodgeb3 = [ 9, cbt_dodgeb4 ]
{
	attack_pattern ();
};

void () cbt_dodgeb4 = [ 112, cbt_dodgeb5 ]
{
	attack_pattern ();
};

void () cbt_dodgeb5 = [ 10, cbt_dodgeb6 ]
{
	attack_pattern ();
};

void () cbt_dodgeb6 = [ 113, cbt_dodgeb7 ]
{
	attack_pattern ();
};

void () cbt_dodgeb7 = [ 11, cbt_dodgeb8 ]
{
	attack_pattern ();
};

void () cbt_dodgeb8 = [ 114, cbt_dodgeb9 ]
{
	attack_pattern ();
};

void () cbt_dodgeb9 = [ 12, cbt_dodgeb10 ]
{
	attack_pattern ();
};

void () cbt_dodgeb10 = [ 115, cbt_dodgeb11 ]
{
	attack_pattern ();
};

void () cbt_dodgeb11 = [ 13, cbt_dodgeb12 ]
{
	attack_pattern ();
};

void () cbt_dodgeb12 = [ 116, cbt_dodgeb13 ]
{
	attack_pattern ();
};

void () cbt_dodgeb13 = [ 14, cbt_dodgeb14 ]
{
	attack_pattern ();
};

void () cbt_dodgeb14 = [ 117, cbt_dodgeb15 ]
{
	attack_pattern ();
};

void () cbt_dodgeb15 = [ 15, cbt_dodgeb16 ]
{
	attack_pattern ();
};

void () cbt_dodgeb16 = [ 118, cbt_dodgeb1 ]
{
	cbot_attack ();
};

void () cbt_run1 = [ 0, cbt_run2 ]
{
	cbot_ai_run (40);
};

void () cbt_run2 = [ 1, cbt_run3 ]
{
	cbot_ai_run (30);
};

void () cbt_run3 = [ 2, cbt_run4 ]
{
	cbot_ai_run (15);
};

void () cbt_run4 = [ 3, cbt_run5 ]
{
	cbot_ai_run (25);
};

void () cbt_run5 = [ 4, cbt_run6 ]
{
	cbot_ai_run (30);
};

void () cbt_run6 = [ 5, cbt_run1 ]
{
	cbot_ai_run (30);
};

void () cbt_shot1 = [ 40, cbt_shot2 ]
{
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () cbt_shot2 = [ 41, cbt_shot3 ]
{
};

void () cbt_shot3 = [ 42, cbt_shot4 ]
{
};

void () cbt_shot4 = [ 43, cbt_shot5 ]
{
};

void () cbt_shot5 = [ 44, cbt_shot6 ]
{
};

void () cbt_shot6 = [ 45, cbt_shot7 ]
{
};

void () cbt_shot7 = [ 46, cbt_shot8 ]
{
};

void () cbt_shot8 = [ 47, cbt_shot9 ]
{
};

void () cbt_shot9 = [ 48, cbt_dodge1 ]
{
	if ((random () < 0.5))
		cbt_dodgeb1 ();
};

void () cbt_pain1 = [ 31, cbt_pain2 ]
{
};

void () cbt_pain2 = [ 32, cbt_pain3 ]
{
};

void () cbt_pain3 = [ 33, cbt_pain4 ]
{
};

void () cbt_pain4 = [ 34, cbt_pain5 ]
{
};

void () cbt_pain5 = [ 35, cbt_pain6 ]
{
};

void () cbt_pain6 = [ 36, cbt_pain7 ]
{
};

void () cbt_pain7 = [ 37, cbt_pain8 ]
{
};

void () cbt_pain8 = [ 38, cbt_pain9 ]
{
};

void () cbt_pain9 = [ 39, cbt_run1 ]
{
	cbot_attack ();
};


void (entity attacker,float damage) cbt_pain =
{
	local float r;

	if ((self.pain_finished > time))
		return;
	r = random(); // ACC, "r" wasn't being assigned anything, would always be 0.00
	if ((r < 0.5))
		sound (self, CHAN_VOICE, "vasquez/pain1.wav", 1.00, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "vasquez/pain2.wav", 1.00, ATTN_NORM);
	self.pain_finished = (time + 1.00);
	cbt_pain1 ();
};


void () cbot_resurrect =
{
	CBot_Create (self);
	self.frame = 0;
};


void () cbot_mort =
{
	self.model = string_null;
	self.think = cbot_resurrect;
	self.nextthink = ((time + 1.00) + (random () * 4));
	self.dualfire = 0;
};

void () cbt_die1;
void () cbt_dieb1;
void () cbt_diec1;
void () cbt_died1;

void () cbt_die =
{
	local float i;

	
	
	
	local float x;

	if ((random () < 0.33))
		sound (self, CHAN_VOICE, "vasquez/death1.wav", 1.00, ATTN_NORM);
	else
	{
		if ((random () < 0.66))
			sound (self, CHAN_VOICE, "vasquez/death2.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "vasquez/death3.wav", 1.00, ATTN_NORM);
	}
	x = random ();
	if ((x < 0.25))
		cbt_die1 ();
	else
	{
		if ((x < 0.5))
			cbt_dieb1 ();
		else
		{
			if ((x < 0.75))
				cbt_diec1 ();
			else
				cbt_died1 ();
		}
	}
};


void () precache_cbot_models =
{
	precache_model ("progs/vasquez.mdl");
	precache_sound ("vasquez/sight1.wav");
	precache_sound ("vasquez/pain1.wav");
	precache_sound ("vasquez/pain2.wav");
	precache_sound ("vasquez/death1.wav");
	precache_sound ("vasquez/death2.wav");
	precache_sound ("vasquez/death3.wav");
};

entity () spawn_cbot =
{
	local entity me;

	me = spawn ();
	me.classname = "cbot";
	setorigin (me, ((self.origin + (v_forward * 110)) + '0 0 30'));
	me.frags = 0;
	me.netname = choosename ();
	cbotnum = (cbotnum + 1);
	return (me);
};


void (entity me) CBot_Create =
{
	local entity spot;

	
	local float x;

	if (!me)
		me = spawn_cbot ();
	if ((me.netname == "One"))
		me.skin = 0;
	else
	{
		if ((me.netname == "Two"))
			me.skin = 1;
		else
		{
			if ((me.netname == "Three"))
				me.skin = 2;
			else
				return;
		}
	}
	setmodel (me, "progs/vasquez.mdl");
	setsize (me, VEC_HULL_MIN, '16 16 40');
	me.movetype = MOVETYPE_STEP;
	me.solid = SOLID_SLIDEBOX;
	me.health = 200;
	dealwithskill ();
	me.pausetime = 1.00;
	me.th_stand = cbt_stand1;
	me.th_run = cbt_run1;
	me.th_pain = cbt_pain;
	me.th_die = cbt_die;
	me.goalentity = world;
	me.oldgoalname = "none";
	me.yaw_speed = 45;
	me.goal_status = 0;
	me.pi1 = 0;
	me.pi2 = 0;
	me.pi3 = 0;
	me.pi4 = 0;
	me.pi5 = 0;
	me.pi6 = 0;
	me.pi7 = 0;
	me.pi8 = 0;
	me.pi9 = 0;
	me.botmode = ATTACK;
	me.enemy = world;
	me.camp_time = 0;
	me.watchdog_time = (time + 0.8);
	me.prioritise_time = (time + 5.00);
	me.other_item_time = (time + 1.00);
	me.takedamage = DAMAGE_AIM;
	me.spawnflags = PLAYER_ONLY;
	me.show_hostile = FALSE;
	me.max_health = 100;
	me.dmg = 2;
	me.air_finished = (time + 12.00);
	me.effects = 0;
	me.weapon = IT_UZI;
	me.items = IT_UZI;
	me.flags = FL_CLIENT;
	me.attack_finished = 0.00;
	x = random ();
	if ((x < 0.33))
	{
		me.ammo_shells2 = 10;
		me.ammo_nails2 = 0;
		me.ammo_rockets2 = 0;
		me.ammo_cells2 = 0;
		me.currentammo = 20;
	}
	else
	{
		if ((x < 0.66))
		{
			me.ammo_shells2 = 0;
			me.ammo_nails2 = 20;
			me.ammo_rockets2 = 0;
			me.ammo_cells2 = 0;
			me.currentammo = 20;
		}
		else
		{
			me.ammo_shells2 = 0;
			me.ammo_nails2 = 0;
			me.ammo_rockets2 = 5;
			me.ammo_cells2 = 0;
			me.currentammo = 20;
		}
	}
	me.deadflag = DEAD_NO;
	spot = SelectSpawnPoint ();
	me.origin = (spot.origin + '0 0 1');
	me.angles = spot.angles;
	me.fixangle = TRUE;
	sound (me, CHAN_VOICE, "misc/r_tele1.wav", 1.00, ATTN_NORM);
	spawn_tfog (me.origin);
	spawn_tdeath (me.origin, me);
	me.old_posn = me.origin;
	me.nextthink = (time + 0.1);
	me.think = cbt_jump1;
};

void () cbt_die1 = [ 49, cbt_die2 ]
{
	self.angles_x = 0;
};

void () cbt_die2 = [ 50, cbt_die3 ]
{
};

void () cbt_die3 = [ 51, cbt_die4 ]
{
	self.solid = SOLID_NOT;
	DropBackpack ();
};

void () cbt_die4 = [ 52, cbt_die5 ]
{
};

void () cbt_die5 = [ 53, cbt_die6 ]
{
};

void () cbt_die6 = [ 54, cbt_die7 ]
{
};

void () cbt_die7 = [ 55, cbt_die8 ]
{
};

void () cbt_die8 = [ 56, cbt_die9 ]
{
};

void () cbt_die9 = [ 57, SUB_Null ]
{
	Fly_Fuck ();
};

void () cbt_dieb1 = [ 68, cbt_dieb2 ]
{
	self.angles_x = 0;
};

void () cbt_dieb2 = [ 69, cbt_dieb3 ]
{
};

void () cbt_dieb3 = [ 71, cbt_dieb4 ]
{
	self.solid = SOLID_NOT;
	DropBackpack ();
};

void () cbt_dieb4 = [ 72, cbt_dieb5 ]
{
};

void () cbt_dieb5 = [ 73, cbt_dieb6 ]
{
};

void () cbt_dieb6 = [ 74, cbt_dieb7 ]
{
};

void () cbt_dieb7 = [ 75, cbt_dieb8 ]
{
};

void () cbt_dieb8 = [ 76, cbt_dieb9 ]
{
};

void () cbt_dieb9 = [ 77, cbt_dieb10 ]
{
};

void () cbt_dieb10 = [ 78, cbt_dieb11 ]
{
};

void () cbt_dieb11 = [ 79, SUB_Null ]
{
	Fly_Fuck ();
};

void () cbt_diec1 = [ 80, cbt_diec2 ]
{
	self.angles_x = 0;
};

void () cbt_diec2 = [ 81, cbt_diec3 ]
{
};

void () cbt_diec3 = [ 82, cbt_diec4 ]
{
	self.solid = SOLID_NOT;
	DropBackpack ();
};

void () cbt_diec4 = [ 83, cbt_diec5 ]
{
};

void () cbt_diec5 = [ 84, cbt_diec6 ]
{
};

void () cbt_diec6 = [ 85, cbt_diec7 ]
{
};

void () cbt_diec7 = [ 86, cbt_diec8 ]
{
};

void () cbt_diec8 = [ 87, cbt_diec9 ]
{
};

void () cbt_diec9 = [ 88, cbt_diec10 ]
{
};

void () cbt_diec10 = [ 89, cbt_diec11 ]
{
};

void () cbt_diec11 = [ 90, cbt_diec12 ]
{
};

void () cbt_diec12 = [ 91, SUB_Null ]
{
	Fly_Fuck ();
};

void () cbt_died1 = [ 92, cbt_died2 ]
{
	self.angles_x = 0;
};

void () cbt_died2 = [ 93, cbt_died3 ]
{
};

void () cbt_died3 = [ 94, cbt_died4 ]
{
	self.solid = SOLID_NOT;
	DropBackpack ();
};

void () cbt_died4 = [ 95, cbt_died5 ]
{
};

void () cbt_died5 = [ 96, cbt_died6 ]
{
};

void () cbt_died6 = [ 97, cbt_died7 ]
{
};

void () cbt_died7 = [ 98, cbt_died8 ]
{
};

void () cbt_died8 = [ 99, cbt_died9 ]
{
};

void () cbt_died9 = [ 100, cbt_died10 ]
{
};

void () cbt_died10 = [ 101, SUB_Null ]
{
	Fly_Fuck ();
};

