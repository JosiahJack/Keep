void () FuelTankExplode;
void () torcher_run01;
void () torcher_explode1;
void () torcher_run;
void () torcher_swing01;
void () torcher_walk01;
void () torcher_flame01;
void () torcher_flameb01;
void () torcher_pain01;
void () torcher_hurt01;
void () torcher_ouch01;
void () torcher_auw;
void () torcher_fly1;
void () torcher_splat01;
void () torcher_salto1;
void () torcher_salto2;
void () torcher_faceplant01;

void () Torcher_JumpTouch =
{
	local float ldmg;

	if (other.takedamage)
	{
		ldmg = (10 + (10 * random ()));
		T_Damage (other, self, self, ldmg);
	}
	self.touch = SUB_Null;
	self.think = torcher_splat01;
	self.nextthink = (time + 0.1);
	self.movetype = MOVETYPE_BOUNCE;
	self.velocity = VEC_ORIGIN;
};


void () Torcher_TurnTurnTurn =
{
	local float ldmg;

	if (other.takedamage)
	{
		FuelTankExplode ();
		ldmg = (10 + (10 * random ()));
		T_Damage (other, self, self, ldmg);
		self.think = torcher_faceplant01;
		self.nextthink = (time + 0.1);
		self.touch = SUB_Null;
	}
	else
	{
		if ((random () < 0.4))
		{
			FuelTankExplode ();
			self.flags = (self.flags - (self.flags & FL_ONGROUND));
			self.velocity_x = ((random () - 0.5) * 1000);
			self.velocity_y = ((random () - 0.5) * 1000);
			self.velocity_z = 400;
		}
		else
		{
			self.think = torcher_faceplant01;
			self.nextthink = (time + 0.1);
			self.touch = SUB_Null;
		}
	}
	self.angles = vectoangles (self.velocity);
	self.angles_x = 0;
	self.angles_z = 0;
	self.fixangle = TRUE;
};


void () Flame_Touch =
{
	local vector org;
	local float damg;

	if ((other == self.owner))
		return;
	if ((pointcontents (self.origin) == CONTENT_SKY))
	{
		remove (self);
		return;
	}
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1.00, ATTN_STATIC);
	org = (self.origin - (8 * normalize (self.velocity)));
	damg = 15;
	if (other.health)
	{
		if ((other.classname == "monster_torcher"))
			return;
		T_Damage (other, self, self.owner, damg);
		CheckTouch ();
	}
	else
		remove (self);
};


void (vector org,vector vec) LaunchFlame =
{
	vec = normalize (vec);
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;
	setmodel (newmis, "progs/nail2.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
	newmis.velocity = (vec * 800);
	newmis.angles = vectoangles (newmis.velocity);
	newmis.nextthink = (time + 0.3);
	newmis.think = SUB_Remove;
	newmis.touch = Flame_Touch;
};


void () torcher_fire =
{
	local vector org;

	self.effects = (self.effects | EF_MUZZLEFLASH);
	makevectors (self.angles);
	org = (((self.origin + (v_forward * 30)) + (v_right * 8.5)) + '0 0 16');
	LaunchFlame (org, (self.enemy.origin - self.origin));
};


void () FuelTankExplode =
{
	local vector dir;

	self.effects = (self.effects | EF_MUZZLEFLASH);
	sound (self, CHAN_VOICE, "weapons/fuelexp.wav", 1.00, ATTN_NORM);
	Fire_bomb (self.origin, dir);
	Fire_bomb (self.origin, dir);
	Fire_bomb (self.origin, dir);
	Fire_bomb (self.origin, dir);
	Fire_bomb (self.origin, dir);
};

void () torcher_stand01 = [ 76, torcher_stand02 ]
{
	if ((random () < 0.2))
	{
		if ((random () < 0.5))
			sound (self, CHAN_VOICE, "torcher/idle.wav", 1.00, ATTN_IDLE);
		else
			sound (self, CHAN_VOICE, "torcher/idle2.wav", 1.00, ATTN_IDLE);
	}
	ai_stand ();
};

void () torcher_stand02 = [ 77, torcher_stand03 ]
{
	ai_stand ();
};

void () torcher_stand03 = [ 78, torcher_stand04 ]
{
	ai_stand ();
};

void () torcher_stand04 = [ 79, torcher_stand05 ]
{
	ai_stand ();
};

void () torcher_stand05 = [ 80, torcher_stand06 ]
{
	ai_stand ();
};

void () torcher_stand06 = [ 81, torcher_stand07 ]
{
	ai_stand ();
};

void () torcher_stand07 = [ 82, torcher_stand08 ]
{
	ai_stand ();
};

void () torcher_stand08 = [ 83, torcher_stand09 ]
{
	ai_stand ();
};

void () torcher_stand09 = [ 84, torcher_stand10 ]
{
	ai_stand ();
};

void () torcher_stand10 = [ 85, torcher_stand11 ]
{
	ai_stand ();
};

void () torcher_stand11 = [ 86, torcher_stand12 ]
{
	ai_stand ();
};

void () torcher_stand12 = [ 87, torcher_stand13 ]
{
	ai_stand ();
};

void () torcher_stand13 = [ 88, torcher_stand14 ]
{
	ai_stand ();
};

void () torcher_stand14 = [ 89, torcher_stand15 ]
{
	ai_stand ();
};

void () torcher_stand15 = [ 90, torcher_stand16 ]
{
	ai_stand ();
};

void () torcher_stand16 = [ 91, torcher_stand01 ]
{
	ai_stand ();
};

void () torcher_run01 = [ 0, torcher_run02 ]
{
	if ((random () < 0.2))
		sound (self, CHAN_VOICE, "torcher/idle.wav", 1.00, ATTN_IDLE);
	ai_run (16);
};

void () torcher_run02 = [ 1, torcher_run03 ]
{
	ai_run (20);
};

void () torcher_run03 = [ 2, torcher_run04 ]
{
	ai_run (20);
};

void () torcher_run04 = [ 3, torcher_run05 ]
{
	ai_run (20);
};

void () torcher_run05 = [ 4, torcher_run06 ]
{
	ai_run (20);
};

void () torcher_run06 = [ 5, torcher_run07 ]
{
	ai_run (20);
};

void () torcher_run07 = [ 6, torcher_run08 ]
{
	ai_run (20);
};

void () torcher_run08 = [ 7, torcher_run ]
{
	ai_run (20);
};

void () torcher_runb01 = [ 8, torcher_runb02 ]
{
	if ((random () < 0.2))
		sound (self, CHAN_VOICE, "torcher/idle.wav", 1.00, ATTN_IDLE);
	ai_run (16);
};

void () torcher_runb02 = [ 9, torcher_runb03 ]
{
	ai_run (20);
};

void () torcher_runb03 = [ 10, torcher_runb04 ]
{
	ai_run (20);
};

void () torcher_runb04 = [ 11, torcher_runb05 ]
{
	ai_run (20);
};

void () torcher_runb05 = [ 12, torcher_runb06 ]
{
	ai_run (20);
};

void () torcher_runb06 = [ 13, torcher_runb07 ]
{
	ai_run (20);
};

void () torcher_runb07 = [ 14, torcher_runb08 ]
{
	ai_run (20);
};

void () torcher_runb08 = [ 15, torcher_run ]
{
	ai_run (20);
};


void () torcher_run =
{
	if ((random () < 0.3))
		torcher_run01 ();
	else
		torcher_runb01 ();
};


void () torcher_walk =
{
	if ((random () < 0.2))
		sound (self, CHAN_VOICE, "torcher/idle.wav", 1.00, ATTN_IDLE);
	if ((random () < 0.3))
		torcher_walk01 ();
	else
		torcher_swing01 ();
};

void () torcher_swing01 = [ 32, torcher_swing02 ]
{
	ai_walk (6);
};

void () torcher_swing02 = [ 33, torcher_swing03 ]
{
	ai_walk (6);
};

void () torcher_swing03 = [ 34, torcher_swing04 ]
{
	ai_walk (5);
};

void () torcher_swing04 = [ 35, torcher_swing05 ]
{
	ai_walk (3);
};

void () torcher_swing05 = [ 36, torcher_swing06 ]
{
	ai_walk (5);
};

void () torcher_swing06 = [ 37, torcher_swing07 ]
{
	ai_walk (4);
};

void () torcher_swing07 = [ 38, torcher_swing08 ]
{
	ai_walk (3);
};

void () torcher_swing08 = [ 39, torcher_swing09 ]
{
	ai_walk (4);
};

void () torcher_swing09 = [ 40, torcher_swing10 ]
{
	ai_walk (6);
};

void () torcher_swing10 = [ 41, torcher_swing11 ]
{
	ai_walk (6);
};

void () torcher_swing11 = [ 42, torcher_swing12 ]
{
	ai_walk (3);
};

void () torcher_swing12 = [ 43, torcher_swing13 ]
{
	ai_walk (4);
};

void () torcher_swing13 = [ 44, torcher_swing14 ]
{
	ai_walk (5);
};

void () torcher_swing14 = [ 45, torcher_swing15 ]
{
	ai_walk (6);
};

void () torcher_swing15 = [ 46, torcher_swing16 ]
{
	ai_walk (4);
};

void () torcher_swing16 = [ 47, torcher_walk ]
{
	ai_walk (4);
};

void () torcher_walk01 = [ 16, torcher_walk02 ]
{
	ai_walk (6);
};

void () torcher_walk02 = [ 17, torcher_walk03 ]
{
	ai_walk (6);
};

void () torcher_walk03 = [ 18, torcher_walk04 ]
{
	ai_walk (5);
};

void () torcher_walk04 = [ 19, torcher_walk05 ]
{
	ai_walk (3);
};

void () torcher_walk05 = [ 20, torcher_walk06 ]
{
	ai_walk (5);
};

void () torcher_walk06 = [ 21, torcher_walk07 ]
{
	ai_walk (4);
};

void () torcher_walk07 = [ 22, torcher_walk08 ]
{
	ai_walk (3);
};

void () torcher_walk08 = [ 23, torcher_walk09 ]
{
	ai_walk (4);
};

void () torcher_walk09 = [ 24, torcher_walk10 ]
{
	ai_walk (6);
};

void () torcher_walk10 = [ 25, torcher_walk11 ]
{
	ai_walk (6);
};

void () torcher_walk11 = [ 26, torcher_walk12 ]
{
	ai_walk (3);
};

void () torcher_walk12 = [ 27, torcher_walk13 ]
{
	ai_walk (4);
};

void () torcher_walk13 = [ 28, torcher_walk14 ]
{
	ai_walk (5);
};

void () torcher_walk14 = [ 29, torcher_walk15 ]
{
	ai_walk (6);
};

void () torcher_walk15 = [ 30, torcher_walk16 ]
{
	ai_walk (4);
};

void () torcher_walk16 = [ 31, torcher_walk ]
{
	ai_walk (4);
};


void () torcher_flame =
{
	if ((random () < 0.2))
		torcher_flame01 ();
	else
		torcher_runb01 ();
};

void () torcher_flame01 = [ 60, torcher_flame02 ]
{
	ai_walk (9);
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1.00, ATTN_NORM);
};

void () torcher_flame02 = [ 61, torcher_flame03 ]
{
	ai_walk (10);
};

void () torcher_flame03 = [ 62, torcher_flame04 ]
{
	ai_walk (10);
};

void () torcher_flame04 = [ 63, torcher_flame05 ]
{
	ai_walk (10);
};

void () torcher_flame05 = [ 64, torcher_flame06 ]
{
	ai_walk (10);
};

void () torcher_flame06 = [ 65, torcher_flame07 ]
{
	ai_walk (10);
};

void () torcher_flame07 = [ 66, torcher_flame08 ]
{
	ai_walk (10);
};

void () torcher_flame08 = [ 67, torcher_flame09 ]
{
	ai_walk (10);
};

void () torcher_flame09 = [ 68, torcher_flame27 ]
{
	ai_walk (10);
};

void () torcher_flame27 = [ 69, torcher_flame28 ]
{
	ai_walk (10);
	ai_face ();
};

void () torcher_flame28 = [ 70, torcher_flame29 ]
{
	ai_walk (10);
	torcher_fire ();
};

void () torcher_flame29 = [ 71, torcher_flame10 ]
{
	ai_walk (10);
};

void () torcher_flame10 = [ 72, torcher_flame11 ]
{
	ai_walk (10);
};

void () torcher_flame11 = [ 73, torcher_flame12 ]
{
	ai_walk (10);
};

void () torcher_flame12 = [ 74, torcher_flame13 ]
{
	ai_walk (10);
};

void () torcher_flame13 = [ 75, torcher_runb01 ]
{
	ai_walk (10);
};

void () torcher_flameb01 = [ 48, torcher_flameb02 ]
{
	ai_face ();
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1.00, ATTN_NORM);
};

void () torcher_flameb02 = [ 49, torcher_flameb03 ]
{
};

void () torcher_flameb03 = [ 50, torcher_flameb04 ]
{
};

void () torcher_flameb04 = [ 51, torcher_flameb05 ]
{
};

void () torcher_flameb05 = [ 52, torcher_flameb06 ]
{
};

void () torcher_flameb06 = [ 53, torcher_flameb07 ]
{
};

void () torcher_flameb07 = [ 54, torcher_flameb08 ]
{
	ai_face ();
};

void () torcher_flameb08 = [ 55, torcher_flameb09 ]
{
	torcher_fire ();
};

void () torcher_flameb09 = [ 56, torcher_flameb10 ]
{
};

void () torcher_flameb10 = [ 57, torcher_flameb11 ]
{
};

void () torcher_flameb11 = [ 58, torcher_flameb12 ]
{
};

void () torcher_flameb12 = [ 59, torcher_run01 ]
{
	ai_face ();
};


void (entity attacker,float damage) torcher_pain =
{
	local float r;

	blooddrops ();
	if ((self.pain_finished > time))
		return;
	r = random ();
	if ((random () < 0.5))
		sound (self, CHAN_VOICE, "torcher/pain.wav", 1.00, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "torcher/pain2.wav", 1.00, ATTN_NORM);
	self.pain_finished = (time + 3.00);
	if ((r < 0.3))
		torcher_pain01 ();
	else
	{
		if ((r < 0.5))
			torcher_hurt01 ();
		else
		{
			if ((r < 0.8))
				torcher_ouch01 ();
			else
				torcher_auw ();
		}
	}
};

void () torcher_pain01 = [ 92, torcher_pain02 ]
{
	ai_pain (1);
};

void () torcher_pain02 = [ 93, torcher_pain03 ]
{
	ai_pain (1);
};

void () torcher_pain03 = [ 94, torcher_pain04 ]
{
	ai_pain (1);
};

void () torcher_pain04 = [ 95, torcher_pain05 ]
{
	ai_pain (1);
};

void () torcher_pain05 = [ 96, torcher_pain06 ]
{
	ai_pain (1);
};

void () torcher_pain06 = [ 97, torcher_pain07 ]
{
	ai_pain (1);
};

void () torcher_pain07 = [ 98, torcher_pain08 ]
{
	ai_pain (1);
};

void () torcher_pain08 = [ 99, torcher_run01 ]
{
	ai_pain (1);
};

void () torcher_hurt01 = [ 100, torcher_hurt02 ]
{
	ai_pain (1);
};

void () torcher_hurt02 = [ 101, torcher_hurt03 ]
{
	ai_pain (1);
};

void () torcher_hurt03 = [ 102, torcher_hurt04 ]
{
	ai_pain (1);
};

void () torcher_hurt04 = [ 103, torcher_hurt05 ]
{
	ai_pain (1);
};

void () torcher_hurt05 = [ 104, torcher_hurt06 ]
{
	ai_pain (1);
};

void () torcher_hurt06 = [ 105, torcher_hurt07 ]
{
	ai_pain (1);
};

void () torcher_hurt07 = [ 106, torcher_hurt08 ]
{
	ai_pain (1);
};

void () torcher_hurt08 = [ 107, torcher_runb01 ]
{
	ai_pain (1);
};

void () torcher_ouch01 = [ 108, torcher_ouch02 ]
{
	ai_pain (1);
};

void () torcher_ouch02 = [ 109, torcher_ouch03 ]
{
	ai_pain (1);
};

void () torcher_ouch03 = [ 110, torcher_ouch04 ]
{
	ai_pain (1);
};

void () torcher_ouch04 = [ 111, torcher_ouch05 ]
{
	ai_pain (1);
};

void () torcher_ouch05 = [ 112, torcher_ouch06 ]
{
	ai_pain (1);
};

void () torcher_ouch06 = [ 113, torcher_ouch07 ]
{
	ai_pain (1);
};

void () torcher_ouch07 = [ 114, torcher_ouch08 ]
{
	ai_pain (1);
};

void () torcher_ouch08 = [ 115, torcher_run01 ]
{
	ai_pain (1);
};

void () torcher_auw = [ 108, torcher_auw21 ]
{
	ai_pain (1);
};

void () torcher_auw21 = [ 109, torcher_auw22 ]
{
	ai_pain (1);
};

void () torcher_auw22 = [ 110, torcher_auw01 ]
{
	ai_pain (1);
};

void () torcher_auw01 = [ 116, torcher_auw02 ]
{
	ai_pain (1);
};

void () torcher_auw02 = [ 117, torcher_auw03 ]
{
	ai_pain (1);
};

void () torcher_auw03 = [ 118, torcher_auw04 ]
{
	ai_pain (1);
	sound (self, CHAN_VOICE, "player/land2.wav", 1.00, ATTN_NORM);
};

void () torcher_auw04 = [ 119, torcher_auw05 ]
{
};

void () torcher_auw05 = [ 120, torcher_auw06 ]
{
};

void () torcher_auw06 = [ 121, torcher_auw07 ]
{
};

void () torcher_auw07 = [ 122, torcher_auw08 ]
{
};

void () torcher_auw08 = [ 123, torcher_auw09 ]
{
};

void () torcher_auw09 = [ 124, torcher_auw10 ]
{
};

void () torcher_auw10 = [ 125, torcher_auw11 ]
{
};

void () torcher_auw11 = [ 126, torcher_run01 ]
{
};

void () torcher_die01 = [ 127, torcher_die02 ]
{
	sound (self, CHAN_VOICE, "torcher/death.wav", 1.00, ATTN_NORM);
};

void () torcher_die02 = [ 128, torcher_die03 ]
{
};

void () torcher_die03 = [ 129, torcher_die04 ]
{
};

void () torcher_die04 = [ 130, torcher_die05 ]
{
	self.solid = SOLID_NOT;
	self.ammo_cells2 = 5;
	DropBackpack ();
};

void () torcher_die05 = [ 131, torcher_die06 ]
{
};

void () torcher_die06 = [ 132, torcher_die07 ]
{
};

void () torcher_die07 = [ 133, torcher_die08 ]
{
};

void () torcher_die08 = [ 134, torcher_die09 ]
{
};

void () torcher_die09 = [ 135, torcher_die10 ]
{
};

void () torcher_die10 = [ 136, torcher_die11 ]
{
};

void () torcher_die11 = [ 137, torcher_die12 ]
{
};

void () torcher_die12 = [ 138, torcher_die13 ]
{
};

void () torcher_die13 = [ 139, SUB_Null ]
{
};

void () torcher_dood01 = [ 140, torcher_dood02 ]
{
	sound (self, CHAN_VOICE, "torcher/death.wav", 1.00, ATTN_NORM);
};

void () torcher_dood02 = [ 141, torcher_dood03 ]
{
};

void () torcher_dood03 = [ 142, torcher_dood04 ]
{
};

void () torcher_dood04 = [ 143, torcher_dood05 ]
{
	self.solid = SOLID_NOT;
	self.ammo_cells2 = 5;
	DropBackpack ();
};

void () torcher_dood05 = [ 144, torcher_dood06 ]
{
};

void () torcher_dood06 = [ 145, torcher_dood07 ]
{
};

void () torcher_dood07 = [ 146, torcher_dood08 ]
{
};

void () torcher_dood08 = [ 147, torcher_dood09 ]
{
};

void () torcher_dood09 = [ 148, torcher_dood10 ]
{
};

void () torcher_dood10 = [ 149, SUB_Null ]
{
};

void () torcher_splat01 = [ 154, torcher_splat02 ]
{
	self.nextthink = (time + 0.2);
};

void () torcher_splat02 = [ 155, torcher_splat03 ]
{
};

void () torcher_splat03 = [ 156, torcher_splat04 ]
{
};

void () torcher_splat04 = [ 157, torcher_splat05 ]
{
	self.solid = SOLID_NOT;
};

void () torcher_splat05 = [ 158, torcher_splat06 ]
{
};

void () torcher_splat06 = [ 159, torcher_splat07 ]
{
};

void () torcher_splat07 = [ 160, torcher_splat08 ]
{
};

void () torcher_splat08 = [ 161, torcher_splat09 ]
{
};

void () torcher_splat09 = [ 162, SUB_Null ]
{
};

void () torcher_fly1 = [ 150, torcher_fly2 ]
{
	FuelTankExplode ();
	self.touch = Torcher_JumpTouch;
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	makevectors (self.angles);
	self.velocity = ((v_forward * 1200) + '0 0 200');
	self.movetype = MOVETYPE_FLY;
};

void () torcher_fly2 = [ 151, torcher_fly3 ]
{
};

void () torcher_fly3 = [ 152, torcher_fly4 ]
{
};

void () torcher_fly4 = [ 153, torcher_fly5 ]
{
};

void () torcher_fly5 = [ 150, torcher_fly6 ]
{
};

void () torcher_fly6 = [ 151, torcher_fly7 ]
{
};

void () torcher_fly7 = [ 152, torcher_fly8 ]
{
};

void () torcher_fly8 = [ 153, torcher_fly5 ]
{
};

void () torcher_faceplant01 = [ 167, torcher_faceplant02 ]
{
	self.nextthink = (time + 0.2);
};

void () torcher_faceplant02 = [ 168, torcher_faceplant03 ]
{
};

void () torcher_faceplant03 = [ 169, torcher_faceplant04 ]
{
};

void () torcher_faceplant04 = [ 170, torcher_faceplant05 ]
{
	self.solid = SOLID_NOT;
};

void () torcher_faceplant05 = [ 171, torcher_faceplant06 ]
{
};

void () torcher_faceplant06 = [ 172, torcher_faceplant07 ]
{
};

void () torcher_faceplant07 = [ 173, SUB_Null ]
{
};

void () torcher_salto1 = [ 163, torcher_salto2 ]
{
	FuelTankExplode ();
	self.touch = Torcher_TurnTurnTurn;
	makevectors (self.angles);
	self.movetype = MOVETYPE_BOUNCE;
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.velocity = ((v_forward * 600) + '0 0 400');
	self.warp_factor = (time + 5.00);
};

void () torcher_salto2 = [ 164, torcher_salto3 ]
{
};

void () torcher_salto3 = [ 165, torcher_salto4 ]
{
};

void () torcher_salto4 = [ 166, torcher_salto5 ]
{
};

void () torcher_salto5 = [ 163, torcher_salto6 ]
{
};

void () torcher_salto6 = [ 164, torcher_salto7 ]
{
};

void () torcher_salto7 = [ 165, torcher_salto8 ]
{
};

void () torcher_salto8 = [ 166, torcher_salto5 ]
{
	if ((time > self.warp_factor))
	{
		self.think = torcher_faceplant01;
		self.nextthink = (time + 0.1);
	}
};


void () torcher_death =
{
	local float r;

	r = random ();
	if ((self.health < -20))
		wallsplat ();
	if ((r < 0.2))
		torcher_dood01 ();
	else
	{
		if ((r < 0.4))
			torcher_die01 ();
		else
		{
			if ((r < 0.7))
				torcher_fly1 ();
			else
				torcher_salto1 ();
		}
	}
};

void () torcher_explode1 = [ 174, torcher_explode2 ]
{
	self.takedamage = DAMAGE_NO;
};

void () torcher_explode2 = [ 174, torcher_explode2 ]
{
	T_RadiusDamage (self, self, 120, world);
	self.origin = (self.origin - (8 * normalize (self.velocity)));
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecomeExplosion ();
};


void () monster_torcher =
{
	if (!deathmatch)
	{
		precache_sound ("torcher/idle.wav");
		precache_sound ("boss1/throw.wav");
		precache_sound ("torcher/pain.wav");
		precache_sound ("torcher/pain2.wav");
		precache_sound ("torcher/stop.wav");
		precache_sound ("weapons/fuelexp.wav");
		precache_sound ("torcher/idle2.wav");
		precache_sound ("torcher/death.wav");
		precache_model ("progs/torch2.mdl");
		precache_model ("progs/nail2.mdl");
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel (self, "progs/torch2.mdl");
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.health = 320;
		dealwithskill ();
		self.th_stand = torcher_stand01;
		self.th_walk = torcher_walk;
		self.th_run = torcher_run;
		self.th_die = torcher_death;
		self.th_pain = torcher_pain;
		self.th_melee = torcher_flameb01;
		self.th_missile = torcher_flame;
		walkmonster_start ();
	}
	else
		remove (self);
};

