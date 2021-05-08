void() DLaser_Touch = 
{
	local vector org;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - FL_CLIENT * normalize(self.velocity);
	if (other.health)
	{
		SpawnBlood(org, self.velocity * 0.2, 15);
		T_Damage(other, self, self.owner, MOVETYPE_BOUNCE);
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
	}
	remove(self);
};

void(vector org, vector vec) LaunchDLaser = 
{
	if (self.classname == "monster_drone")
	{
		sound(self, CHAN_WEAPON, "drone/enfire.wav", 1, ATTN_NORM);
	}
	vec = normalize(vec);
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	setmodel(newmis, "progs/laser.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + MOVETYPE_FLY;
	newmis.think = SUB_Remove;
	newmis.touch = DLaser_Touch;
};

void(float offset) drone_fire = 
{
	local vector org;
	local float ouch;
	local float ouch1;
	ouch = MOVETYPE_STEP - skill;
	ouch1 = MOVETYPE_STEP * random();
	if (self.ammo_shells < ouch && ouch1 < ouch && self.health < MAX_NAILS)
	{
		sound(self, CHAN_VOICE, "drone/drngasp.wav", 0.6, ATTN_NORM);
		self.ammo_shells = self.ammo_shells + 1;
		return;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * SVC_INTERMISSION + '-5 15 0';
	LaunchDLaser(org, self.enemy.origin + v_right * offset - self.origin);
	SUB_AttackFinished(MOVETYPE_STEP);
};

void() drn_stand1 = [18, drn_stand2]
{
	ai_stand();
};

void() drn_stand2 = [19, drn_stand3]
{
	ai_stand();
};

void() drn_stand3 = [20, drn_stand4]
{
	ai_stand();
};

void() drn_stand4 = [21, drn_stand5]
{
	ai_stand();
	if (self.spawnflags & 1)
	{
		drn_stand5();
	}
	if (crandom() > 0.5)
	{
		sound(self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_NORM);
	}
};

void() drn_stand5 = [22, drn_stand6]
{
	ai_stand();
};

void() drn_stand6 = [23, drn_stand7]
{
	ai_stand();
};

void() drn_stand7 = [24, drn_stand8]
{
	ai_stand();
};

void() drn_stand8 = [25, drn_stand9]
{
	ai_stand();
};

void() drn_stand9 = [26, drn_stand10]
{
	ai_stand();
};

void() drn_stand10 = [18, drn_stand1]
{
	ai_stand();
	if (self.spawnflags & 1)
	{
		drn_stand1();
	}
	if (crandom() > 0.5)
	{
		if (crandom() > 0.5)
		{
			sound(self, CHAN_VOICE, "drone/drnidle2.wav", 0.6, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_NORM);
		}
	}
};

void() drn_walk1 = [18, drn_walk2]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk2 = [19, drn_walk3]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk3 = [20, drn_walk4]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk4 = [21, drn_walk5]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk5 = [22, drn_walk6]
{
	ai_walk(FL_CLIENT);
	if (self.spawnflags & 1)
	{
		drn_walk6();
	}
	if (crandom() > 0.5)
	{
		sound(self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_NORM);
	}
};

void() drn_walk6 = [23, drn_walk7]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk7 = [24, drn_walk8]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk8 = [25, drn_walk9]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk9 = [26, drn_walk10]
{
	ai_walk(FL_CLIENT);
};

void() drn_walk10 = [18, drn_walk1]
{
	ai_walk(FL_CLIENT);
	if (self.spawnflags & 1)
	{
		drn_walk1();
	}
	if (crandom() > 0.5)
	{
		if (crandom() > 0.5)
		{
			sound(self, CHAN_VOICE, "drone/drnidle2.wav", 0.6, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "drone/drnidle.wav", 0.6, ATTN_NORM);
		}
	}
};

void() drn_runa1 = [18, drn_runa2]
{
	ai_run(13);
};

void() drn_runa2 = [19, drn_runa3]
{
	ai_run(13);
};

void() drn_runa3 = [20, drn_runa4]
{
	ai_run(13);
};

void() drn_runa4 = [21, drn_runa5]
{
	ai_run(13);
};

void() drn_runa5 = [22, drn_runa6]
{
	ai_run(13);
	if (crandom() > 0.5)
	{
		if (self.health < MAX_NAILS)
		{
			sound(self, CHAN_VOICE, "drone/drngasp.wav", 0.6, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
		}
	}
};

void() drn_runa6 = [23, drn_runa7]
{
	ai_run(13);
};

void() drn_runa7 = [24, drn_runa8]
{
	ai_run(13);
};

void() drn_runa8 = [25, drn_runa9]
{
	ai_run(13);
};

void() drn_runa9 = [26, drn_runa10]
{
	ai_run(13);
};

void() drn_runa10 = [18, drn_run]
{
	ai_run(13);
	if (crandom() > 0.5)
	{
		if (self.health < MAX_SHELLS)
		{
			sound(self, CHAN_VOICE, "drone/drngasp2.wav", 0.6, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
		}
	}
};

void() drn_runb1 = [18, drn_runb2]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb2 = [19, drn_runb3]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb3 = [20, drn_runb4]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb4 = [21, drn_runb5]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb5 = [22, drn_runb6]
{
	ai_run(13);
	ai_run_slide();
	if (crandom() > 0.5)
	{
		sound(self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
	}
};

void() drn_runb6 = [23, drn_runb7]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb7 = [24, drn_runb8]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb8 = [25, drn_runb9]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb9 = [26, drn_runb10]
{
	ai_run(13);
	ai_run_slide();
};

void() drn_runb10 = [18, drn_run]
{
	ai_run(13);
	ai_run_slide();
	if (crandom() > 0.5)
	{
		sound(self, CHAN_VOICE, "drone/drnhunt.wav", 1, ATTN_NORM);
	}
};

void() drn_run = 
{
	local float r;
	r = random();
	if (r < 0.5)
	{
		drn_runa1();
	}
	else
	{
		drn_runb1();
	}
};

void() drn_atta1 = [12, drn_atta2]
{
	ai_face();
	drone_fire(125);
};

void() drn_atta2 = [13, drn_atta3]
{
	ai_face();
	drone_fire(75);
};

void() drn_atta3 = [14, drn_atta4]
{
	ai_face();
	drone_fire(25);
};

void() drn_atta4 = [15, drn_atta5]
{
	ai_face();
	drone_fire(0);
};

void() drn_atta5 = [16, drn_atta6]
{
	ai_face();
	drone_fire(-25);
};

void() drn_atta6 = [17, drn_atta7]
{
	ai_face();
	drone_fire(-75);
};

void() drn_atta7 = [1, drn_atta8]
{
	ai_face();
	drone_fire(-125);
	self.ammo_shells = 0;
};

void() drn_atta8 = [2, drn_atta9]
{
	ai_face();
};

void() drn_atta9 = [3, drn_atta10]
{
	ai_face();
};

void() drn_atta10 = [4, drn_atta11]
{
	ai_face();
};

void() drn_atta11 = [5, drn_atta12]
{
	ai_face();
};

void() drn_atta12 = [6, drn_atta13]
{
	ai_face();
};

void() drn_atta13 = [7, drn_atta14]
{
	ai_face();
};

void() drn_atta14 = [8, drn_atta15]
{
	ai_face();
};

void() drn_atta15 = [9, drn_atta16]
{
	ai_face();
};

void() drn_atta16 = [10, drn_atta17]
{
	ai_face();
};

void() drn_atta17 = [10, drn_atta18]
{
	ai_face();
};

void() drn_atta18 = [10, drn_run]
{
	ai_face();
};

void() drn_paina1 = [28, drn_paina2]
{
};

void() drn_paina2 = [29, drn_paina3]
{
};

void() drn_paina3 = [30, drn_paina4]
{
};

void() drn_paina4 = [31, drn_paina5]
{
};

void() drn_paina5 = [31, drn_run]
{
};

void() drn_painb1 = [33, drn_painb2]
{
};

void() drn_painb2 = [34, drn_painb3]
{
};

void() drn_painb3 = [35, drn_painb4]
{
};

void() drn_painb4 = [36, drn_painb5]
{
};

void() drn_painb5 = [36, drn_run]
{
};

void() drn_pain = 
{
	if (random() > 0.75)
	{
		sound(self, CHAN_VOICE, "drone/drnpain2.wav", 1, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "drone/drnpain.wav", 1, ATTN_NORM);
	}
	ThrowGib("progs/spike.mdl", -10, self.dest);
	if (random() > 0.5)
	{
		drn_paina1();
	}
	else
	{
		drn_painb1();
	}
};

void() drn_die1 = [32, drn_die2]
{
	self.takedamage = DAMAGE_NO;
	sound(self, CHAN_VOICE, "drone/drndeth.wav", 1, ATTN_NORM);
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = MAX_SHELLS + MAX_SHELLS * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() drn_die2 = [28, drn_die3]
{
};

void() drn_die3 = [29, drn_die4]
{
};

void() drn_die4 = [30, drn_die5]
{
};

void() drn_die5 = [31, drn_die6]
{
};

void() drn_die6 = [32, drn_die7]
{
};

void() drn_die7 = [0, drn_die7]
{
	ThrowGib("progs/drngib1.mdl", -65, self.dest);
	ThrowGib("progs/drngib2.mdl", -65, self.dest);
	ThrowGib("progs/drngib3.mdl", -65, self.dest);
	self.nextthink = time + 2.5;
	T_RadiusDamage(self, self, 80, world);
	self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() DroneTouch = 
{
	if (other.takedamage)
	{
		drn_die7();
	}
};

void() monster_drone = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/drone1.mdl");
	precache_model("progs/drngib1.mdl");
	precache_model("progs/drngib2.mdl");
	precache_model("progs/drngib3.mdl");
	precache_model("progs/laser.mdl");
	precache_sound2("drone/drnidle2.wav");
	precache_sound2("drone/drnidle.wav");
	precache_sound2("drone/drnwake.wav");
	precache_sound2("drone/drnhunt.wav");
	precache_sound2("drone/enfire.wav");
	precache_sound2("drone/drnpain.wav");
	precache_sound2("drone/drnpain2.wav");
	precache_sound2("drone/drngasp.wav");
	precache_sound2("drone/drngasp2.wav");
	precache_sound2("drone/drndeth.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_model("progs/spike.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/drone1.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = MAX_SHELLS;
	self.touch = DroneTouch;
	self.effects = EF_DIMLIGHT;
	self.th_stand = drn_stand1;
	self.th_walk = drn_walk1;
	self.th_run = drn_run;
	self.th_missile = drn_atta1;
	self.th_pain = drn_pain;
	self.th_die = drn_die1;
	self.ammo_shells = 0;
	flymonster_start();
};

