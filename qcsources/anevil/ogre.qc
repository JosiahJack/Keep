void() OgreGrenadeExplode = 
{
	local float ddmg;
	ddmg = 25 + skill * IQ_ULTIMATE;
	T_RadiusDamage(self, self.owner, ddmg, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", MEDIEVAL, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() OgreGrenadeTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		OgreGrenadeExplode();
		return;
	}
	sound(self, CHAN_VOICE, "weapons/bounce.wav", MEDIEVAL, ATTN_NORM);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
};

void() OgreFireGrenade = 
{
	local entity missile;
	local entity mpuff;
	local float dist;
	local float fly;
	local float airtime;
	local vector move;
	local vector spot;
	local vector org;
	self.th_stand = ogre_stand1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", MEDIEVAL, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	makevectors(self.angles);
	org = self.origin + v_forward * DOOR_TOGGLE + v_right * CONTENT_SKY + '0 0 16';
	dist = vlen(self.enemy.origin - self.origin);
	airtime = dist / 600;
	move = self.enemy.velocity;
	move_z = MSG_BROADCAST;
	spot = self.enemy.origin + airtime * move;
	if (vlen(spot - org) < dist)
	{
		spot = self.enemy.origin + airtime * move * 0.7;
	}
	else
	{
		if (vlen(spot - org) > dist)
		{
			spot = self.enemy.origin + airtime * move * 1.2;
		}
	}
	if (skill > MEDIEVAL)
	{
		missile.velocity = normalize(spot - org);
	}
	else
	{
		missile.velocity = normalize(self.enemy.origin - org);
	}
	missile.velocity = missile.velocity * 600;
	dist = vlen(spot - org);
	fly = PM_GrenadeFly(dist);
	missile.velocity_z = missile.velocity_z + fly;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = OgreGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = OgreGrenadeExplode;
	setmodel(missile, "progs/grenade.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() OgreFireNails = 
{
	local vector dir;
	self.th_stand = ogre_stand1;
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", MEDIEVAL, ATTN_NORM);
	self.attack_finished = time;
	old = self.enemy;
	dir = old.origin - old.velocity * 0.2;
	dir = normalize(dir - self.origin);
	launch_spike(self.origin + '0 0 16', dir);
	if (skill > MEDIEVAL)
	{
		launch_spike(self.origin + '0 0 16', dir);
	}
};

void(float side) chainsaw = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ai_charge(SVC_SETVIEWANGLES);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	PM_GibZombie(WEAPON_ROCKET);
	random();
	ldmg = (random() + random() + random()) * SECRET_1ST_DOWN;
	T_Damage(self.enemy, self, self, ldmg);
	if (side)
	{
		makevectors(self.angles);
		if (side == MEDIEVAL)
		{
			SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		}
		else
		{
			SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, side * v_right);
		}
	}
};

void() ogre_stand1 = [0, ogre_stand2]
{
	ai_stand();
};

void() ogre_stand2 = [1, ogre_stand3]
{
	ai_stand();
};

void() ogre_stand3 = [2, ogre_stand4]
{
	ai_stand();
};

void() ogre_stand4 = [3, ogre_stand5]
{
	ai_stand();
};

void() ogre_stand5 = [4, ogre_stand6]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle.wav", MEDIEVAL, ATTN_IDLE);
	}
	ai_stand();
};

void() ogre_stand6 = [5, ogre_stand7]
{
	ai_stand();
};

void() ogre_stand7 = [6, ogre_stand8]
{
	ai_stand();
};

void() ogre_stand8 = [7, ogre_stand9]
{
	ai_stand();
};

void() ogre_stand9 = [8, ogre_stand1]
{
	ai_stand();
};

void() ogre_saw1 = [33, ogre_saw2]
{
	sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", MEDIEVAL, ATTN_NORM);
	ai_stand();
};

void() ogre_saw2 = [34, ogre_saw3]
{
	ai_stand();
};

void() ogre_saw3 = [35, ogre_saw4]
{
	ai_stand();
};

void() ogre_saw4 = [36, ogre_saw5]
{
	ai_stand();
};

void() ogre_saw5 = [37, ogre_saw6]
{
	ai_stand();
};

void() ogre_saw6 = [38, ogre_saw7]
{
	ai_stand();
};

void() ogre_saw7 = [39, ogre_saw8]
{
	ai_stand();
};

void() ogre_saw8 = [40, ogre_saw9]
{
	ai_stand();
};

void() ogre_saw9 = [41, ogre_saw10]
{
	ai_stand();
};

void() ogre_saw10 = [42, ogre_saw11]
{
	ai_stand();
};

void() ogre_saw11 = [43, ogre_saw12]
{
	ai_stand();
};

void() ogre_saw12 = [44, ogre_saw13]
{
	ai_stand();
};

void() ogre_saw13 = [45, ogre_saw14]
{
	ai_stand();
};

void() ogre_saw14 = [46, ogre_saw15]
{
	ai_stand();
};

void() ogre_saw15 = [0, ogre_saw16]
{
	ai_stand();
};

void() ogre_saw16 = [1, ogre_saw17]
{
	ai_stand();
};

void() ogre_saw17 = [2, ogre_saw18]
{
	ai_stand();
	self.nextthink = self.nextthink + random();
};

void() ogre_saw18 = [3, ogre_saw1]
{
	ai_stand();
};

void() ogre_cut1 = [47, ogre_cut2]
{
	sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", MEDIEVAL, ATTN_NORM);
	ai_stand();
};

void() ogre_cut2 = [48, ogre_cut3]
{
	ai_stand();
};

void() ogre_cut3 = [49, ogre_cut4]
{
	ai_stand();
};

void() ogre_cut4 = [50, ogre_cut5]
{
	ai_stand();
};

void() ogre_cut5 = [51, ogre_cut6]
{
	ai_stand();
};

void() ogre_cut6 = [52, ogre_cut7]
{
	ai_stand();
};

void() ogre_cut7 = [53, ogre_cut8]
{
	ai_stand();
};

void() ogre_cut8 = [54, ogre_cut9]
{
	ai_stand();
};

void() ogre_cut9 = [55, ogre_cut10]
{
	ai_stand();
};

void() ogre_cut10 = [56, ogre_cut11]
{
	ai_stand();
};

void() ogre_cut11 = [57, ogre_cut12]
{
	ai_stand();
};

void() ogre_cut12 = [58, ogre_cut13]
{
	ai_stand();
};

void() ogre_cut13 = [59, ogre_cut14]
{
	ai_stand();
};

void() ogre_cut14 = [60, ogre_cut15]
{
	ai_stand();
};

void() ogre_cut15 = [0, ogre_cut16]
{
	ai_stand();
};

void() ogre_cut16 = [1, ogre_cut17]
{
	ai_stand();
	self.nextthink = self.nextthink + random();
};

void() ogre_cut17 = [2, ogre_cut1]
{
	ai_stand();
};

void() ogre_walk1 = [9, ogre_walk2]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk2 = [10, ogre_walk3]
{
	ai_walk(SPAWN_ROUNDS);
};

void() ogre_walk3 = [11, ogre_walk4]
{
	ai_walk(SPAWN_ROUNDS);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle.wav", MEDIEVAL, ATTN_IDLE);
	}
};

void() ogre_walk4 = [12, ogre_walk5]
{
	ai_walk(SPAWN_ROUNDS);
};

void() ogre_walk5 = [13, ogre_walk6]
{
	ai_walk(SPAWN_ROUNDS);
};

void() ogre_walk6 = [14, ogre_walk7]
{
	ai_walk(IQ_ULTIMATE);
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "ogre/ogdrag.wav", MEDIEVAL, ATTN_IDLE);
	}
};

void() ogre_walk7 = [15, ogre_walk8]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk8 = [16, ogre_walk9]
{
	ai_walk(SPAWN_ROUNDS);
};

void() ogre_walk9 = [17, ogre_walk10]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk10 = [18, ogre_walk11]
{
	ai_walk(MEDIEVAL);
};

void() ogre_walk11 = [19, ogre_walk12]
{
	ai_walk(SPAWN_ROUNDS);
};

void() ogre_pull1 = [136, ogre_pull2]
{
};

void() ogre_pull2 = [137, ogre_pull3]
{
};

void() ogre_pull3 = [138, ogre_pull4]
{
};

void() ogre_pull4 = [139, ogre_pull5]
{
};

void() ogre_pull5 = [140, ogre_pull6]
{
	sound(self, CHAN_VOICE, "weapons/chainog.wav", MEDIEVAL, ATTN_IDLE);
};

void() ogre_pull6 = [141, ogre_pull7]
{
};

void() ogre_pull7 = [142, ogre_pull8]
{
};

void() ogre_pull8 = [143, ogre_pull9]
{
};

void() ogre_pull9 = [144, ogre_pull10]
{
};

void() ogre_pull10 = [145, ogre_pull11]
{
};

void() ogre_pull11 = [146, ogre_pull12]
{
};

void() ogre_pull12 = [145, ogre_pull13]
{
};

void() ogre_pull13 = [144, ogre_pull14]
{
};

void() ogre_pull14 = [143, ogre_pull15]
{
};

void() ogre_pull15 = [141, ogre_pull16]
{
};

void() ogre_pull16 = [139, ogre_walk13]
{
};

void() ogre_walk12 = [20, ogre_check]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk13 = [21, ogre_walk14]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk14 = [22, ogre_walk15]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk15 = [23, ogre_walk16]
{
	ai_walk(IQ_HIGH);
};

void() ogre_walk16 = [24, ogre_walk1]
{
	ai_walk(SPAWN_SAW);
};

void() ogre_check = 
{
	ai_walk(IQ_HIGH);
	if (random() < 0.25)
	{
		ogre_pull1();
	}
	else
	{
		ogre_walk13();
	}
};

void() ogre_run1 = [25, ogre_run2]
{
	ai_run(TE_LIGHTNING3);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "ogre/ogidle2.wav", MEDIEVAL, ATTN_IDLE);
	}
};

void() ogre_run2 = [26, ogre_run3]
{
	ai_run(STAT_TOTALMONSTERS);
};

void() ogre_run3 = [27, ogre_run4]
{
	ai_run(SPAWN_CUT);
};

void() ogre_run4 = [28, ogre_run5]
{
	ai_run(22);
};

void() ogre_run5 = [29, ogre_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() ogre_run6 = [30, ogre_run7]
{
	ai_run(SPAWN_SAW);
};

void() ogre_run7 = [31, ogre_run8]
{
	ai_run(13);
};

void() ogre_run8 = [32, ogre_run1]
{
	ai_run(24);
};

void() ogre_swing1 = [33, ogre_swing2]
{
	ai_charge(STAT_TOTALSECRETS);
	sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", MEDIEVAL, ATTN_NORM);
};

void() ogre_swing2 = [34, ogre_swing3]
{
	ai_charge(MEDIEVAL);
};

void() ogre_swing3 = [35, ogre_swing4]
{
	ai_charge(SPAWN_SAW);
};

void() ogre_swing4 = [36, ogre_swing5]
{
	ai_charge(13);
};

void() ogre_swing5 = [37, ogre_swing6]
{
	ai_charge(TE_LIGHTNING3);
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing6 = [38, ogre_swing7]
{
	chainsaw(MAX_CHARMER_DISTANCE);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing7 = [39, ogre_swing8]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing8 = [40, ogre_swing9]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing9 = [41, ogre_swing10]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing10 = [42, ogre_swing11]
{
	chainsaw(-200);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing11 = [43, ogre_swing12]
{
	chainsaw(MSG_BROADCAST);
	self.angles_y = self.angles_y + random() * 25;
};

void() ogre_swing12 = [44, ogre_swing13]
{
	ai_charge(IQ_HIGH);
};

void() ogre_swing13 = [45, ogre_swing14]
{
	ai_charge(SPAWN_CUT);
};

void() ogre_swing14 = [46, ogre_run1]
{
	ai_charge(TE_LIGHTNING3);
};

void() ogre_smash1 = [47, ogre_smash2]
{
	ai_charge(TE_LIGHTNING2);
	sound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", MEDIEVAL, ATTN_NORM);
};

void() ogre_smash2 = [48, ogre_smash3]
{
	ai_charge(MSG_BROADCAST);
};

void() ogre_smash3 = [49, ogre_smash4]
{
	ai_charge(MSG_BROADCAST);
};

void() ogre_smash4 = [50, ogre_smash5]
{
	ai_charge(MEDIEVAL);
};

void() ogre_smash5 = [51, ogre_smash6]
{
	ai_charge(SPAWN_SAW);
};

void() ogre_smash6 = [52, ogre_smash7]
{
	ai_charge(SPAWN_SAW);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash7 = [53, ogre_smash8]
{
	ai_charge(SPAWN_SAW);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash8 = [54, ogre_smash9]
{
	ai_charge(SVC_SETVIEWANGLES);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash9 = [55, ogre_smash10]
{
	ai_charge(13);
	chainsaw(MSG_BROADCAST);
};

void() ogre_smash10 = [56, ogre_smash11]
{
	chainsaw(MEDIEVAL);
};

void() ogre_smash11 = [57, ogre_smash12]
{
	ai_charge(SPAWN_ROUNDS);
	chainsaw(MSG_BROADCAST);
	self.nextthink = self.nextthink + random() * 0.2;
};

void() ogre_smash12 = [58, ogre_smash13]
{
	ai_charge();
};

void() ogre_smash13 = [59, ogre_smash14]
{
	ai_charge(SPAWN_SAW);
};

void() ogre_smash14 = [60, ogre_run1]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() ogre_gren1 = [61, ogre_gren2]
{
	ai_face();
};

void() ogre_gren2 = [62, ogre_gren3]
{
	ai_face();
};

void() ogre_gren3 = [62, ogre_gren4]
{
	ai_face();
};

void() ogre_gren4 = [63, ogre_gren5]
{
	ai_face();
	OgreFireGrenade();
};

void() ogre_gren5 = [64, ogre_gren6]
{
	ai_face();
};

void() ogre_gren6 = [65, ogre_gren7]
{
	ai_face();
};

void() ogre_gren7 = [66, ogre_run1]
{
	ai_face();
};

void() ogre_nail1 = [61, ogre_nail2]
{
	ai_face();
};

void() ogre_nail2 = [62, ogre_nail3]
{
	ai_face();
};

void() ogre_nail3 = [62, ogre_nail4]
{
	ai_face();
};

void() ogre_nail4 = [63, ogre_nail5]
{
	ai_face();
	OgreFireNails();
};

void() ogre_nail5 = [62, ogre_nail6]
{
	ai_face();
};

void() ogre_nail6 = [63, ogre_nail7]
{
	ai_face();
	OgreFireNails();
};

void() ogre_nail7 = [62, ogre_nail8]
{
	ai_face();
};

void() ogre_nail8 = [63, ogre_nail9]
{
	ai_face();
	OgreFireNails();
};

void() ogre_nail9 = [62, ogre_nail10]
{
	ai_face();
};

void() ogre_nail10 = [63, ogre_nail11]
{
	ai_face();
	OgreFireNails();
};

void() ogre_nail11 = [64, ogre_nail12]
{
	ai_face();
};

void() ogre_nail12 = [65, ogre_nail13]
{
	ai_face();
};

void() ogre_nail13 = [66, ogre_run1]
{
	ai_face();
};

void() ogre_pain1 = [67, ogre_pain2]
{
};

void() ogre_pain2 = [68, ogre_pain3]
{
};

void() ogre_pain3 = [69, ogre_pain4]
{
};

void() ogre_pain4 = [70, ogre_pain5]
{
};

void() ogre_pain5 = [71, ogre_run1]
{
};

void() ogre_painb1 = [72, ogre_painb2]
{
};

void() ogre_painb2 = [73, ogre_painb3]
{
};

void() ogre_painb3 = [74, ogre_run1]
{
};

void() ogre_painc1 = [75, ogre_painc2]
{
};

void() ogre_painc2 = [76, ogre_painc3]
{
};

void() ogre_painc3 = [77, ogre_painc4]
{
};

void() ogre_painc4 = [78, ogre_painc5]
{
};

void() ogre_painc5 = [79, ogre_painc6]
{
};

void() ogre_painc6 = [80, ogre_run1]
{
};

void() ogre_paind1 = [81, ogre_paind2]
{
};

void() ogre_paind2 = [82, ogre_paind3]
{
	ai_pain(SVC_SETVIEWANGLES);
};

void() ogre_paind3 = [83, ogre_paind4]
{
	ai_pain(TE_LIGHTNING3);
};

void() ogre_paind4 = [84, ogre_paind5]
{
	ai_pain(SPAWN_SAW);
};

void() ogre_paind5 = [85, ogre_paind6]
{
};

void() ogre_paind6 = [86, ogre_paind7]
{
};

void() ogre_paind7 = [87, ogre_paind8]
{
};

void() ogre_paind8 = [88, ogre_paind9]
{
};

void() ogre_paind9 = [89, ogre_paind10]
{
};

void() ogre_paind10 = [90, ogre_paind11]
{
};

void() ogre_paind11 = [91, ogre_paind12]
{
};

void() ogre_paind12 = [92, ogre_paind13]
{
};

void() ogre_paind13 = [93, ogre_paind14]
{
};

void() ogre_paind14 = [94, ogre_paind15]
{
};

void() ogre_paind15 = [95, ogre_paind16]
{
};

void() ogre_paind16 = [96, ogre_run1]
{
};

void() ogre_paine1 = [97, ogre_paine2]
{
};

void() ogre_paine2 = [98, ogre_paine3]
{
	ai_pain(SVC_SETVIEWANGLES);
};

void() ogre_paine3 = [99, ogre_paine4]
{
	ai_pain(TE_LIGHTNING3);
};

void() ogre_paine4 = [100, ogre_paine5]
{
	ai_pain(SPAWN_SAW);
};

void() ogre_paine5 = [101, ogre_paine6]
{
};

void() ogre_paine6 = [102, ogre_paine7]
{
};

void() ogre_paine7 = [103, ogre_paine8]
{
};

void() ogre_paine8 = [104, ogre_paine9]
{
};

void() ogre_paine9 = [105, ogre_paine10]
{
};

void() ogre_paine10 = [106, ogre_paine11]
{
};

void() ogre_paine11 = [107, ogre_paine12]
{
};

void() ogre_paine12 = [108, ogre_paine13]
{
};

void() ogre_paine13 = [109, ogre_paine14]
{
};

void() ogre_paine14 = [110, ogre_paine15]
{
};

void() ogre_paine15 = [111, ogre_run1]
{
};

void(entity attacker, float damage) ogre_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "ogre/ogpain1.wav", SPAWN_FLOATING, ATTN_NORM);
	r = random();
	if (r < 0.25)
	{
		ogre_pain1();
		self.pain_finished = time + SPAWN_FLOATING;
	}
	else
	{
		if (r < 0.5)
		{
			ogre_painb1();
			self.pain_finished = time + SPAWN_FLOATING;
		}
		else
		{
			if (r < 0.75)
			{
				ogre_painc1();
				self.pain_finished = time + SPAWN_FLOATING;
			}
			else
			{
				if (r < 0.88)
				{
					ogre_paind1();
					self.pain_finished = time + SPAWN_ROUNDS;
				}
				else
				{
					ogre_paine1();
					self.pain_finished = time + SPAWN_ROUNDS;
				}
			}
		}
	}
};

void() ogre_die1 = [112, ogre_die2]
{
};

void() ogre_die2 = [113, ogre_die3]
{
};

void() ogre_die3 = [114, ogre_die4]
{
	self.solid = SOLID_NOT;
	DropBackpack();
};

void() ogre_die4 = [115, ogre_die5]
{
};

void() ogre_die5 = [116, ogre_die6]
{
};

void() ogre_die6 = [117, ogre_die7]
{
};

void() ogre_die7 = [118, ogre_die8]
{
};

void() ogre_die8 = [119, ogre_die9]
{
};

void() ogre_die9 = [120, ogre_die10]
{
};

void() ogre_die10 = [121, ogre_die11]
{
};

void() ogre_die11 = [122, ogre_die12]
{
};

void() ogre_die12 = [123, ogre_die13]
{
};

void() ogre_die13 = [124, ogre_die14]
{
};

void() ogre_die14 = [125, ogre_die14]
{
};

void() ogre_bdie1 = [126, ogre_bdie2]
{
};

void() ogre_bdie2 = [127, ogre_bdie3]
{
	ai_forward(IQ_ULTIMATE);
};

void() ogre_bdie3 = [128, ogre_bdie4]
{
	self.solid = SOLID_NOT;
	DropBackpack();
};

void() ogre_bdie4 = [129, ogre_bdie5]
{
	ai_forward(SPAWN_FLOATING);
};

void() ogre_bdie5 = [130, ogre_bdie6]
{
	ai_forward(IQ_HIGH);
};

void() ogre_bdie6 = [131, ogre_bdie7]
{
	ai_forward(TE_WIZSPIKE);
};

void() ogre_bdie7 = [132, ogre_bdie8]
{
	ai_forward(25);
};

void() ogre_bdie8 = [133, ogre_bdie9]
{
};

void() ogre_bdie9 = [134, ogre_bdie10]
{
};

void() ogre_bdie10 = [135, ogre_bdie10]
{
};

void() ogre_die = 
{
	if (self.health < -80)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_FLOATING, ATTN_NORM);
		ThrowHead("progs/h_ogre.mdl", self.health, self.skin);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		self.health = self.health * 2.5;
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "ogre/ogdth.wav", SPAWN_FLOATING, ATTN_NORM);
	if (random() < 0.5)
	{
		ogre_die1();
	}
	else
	{
		ogre_bdie1();
	}
};

void() ogre_melee = 
{
	self.th_stand = ogre_stand1;
	if (random() > 0.5 || self.enemy.classname == "monster_zombie")
	{
		ogre_smash1();
	}
	else
	{
		ogre_swing1();
	}
};

void() monster_ogre = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/ogre.mdl");
	precache_model("progs/h_ogre.mdl");
	precache_model("progs/grenade.mdl");
	precache_sound("ogre/ogdrag.wav");
	precache_sound("ogre/ogdth.wav");
	precache_sound("ogre/ogidle.wav");
	precache_sound("ogre/ogidle2.wav");
	precache_sound("ogre/ogpain1.wav");
	precache_sound("ogre/ogsawatk.wav");
	precache_sound("ogre/ogwake.wav");
	precache_sound("weapons/chainog.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/ogre.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!(self.health))
	{
		self.health = MAX_CHARMER_DISTANCE;
	}
	if (self.spawnflags & SPAWN_SAW)
	{
		self.th_stand = ogre_saw1;
	}
	else
	{
		if (self.spawnflags & SPAWN_CUT)
		{
			self.th_stand = ogre_cut1;
		}
		else
		{
			self.th_stand = ogre_stand1;
		}
	}
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_gren1;
	self.th_pain = ogre_pain;
	if (self.spawnflags & SPAWN_ROUNDS)
	{
		self.ammo_rockets = SVC_SETVIEWANGLES;
	}
	else
	{
		self.ammo_rockets = SPAWN_ROUNDS;
	}
	walkmonster_start();
};

void() monster_ogremarksman = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/ogre.mdl");
	precache_model("progs/h_ogre.mdl");
	precache_sound("ogre/ogdrag.wav");
	precache_sound("ogre/ogdth.wav");
	precache_sound("ogre/ogidle.wav");
	precache_sound("ogre/ogidle2.wav");
	precache_sound("ogre/ogpain1.wav");
	precache_sound("ogre/ogsawatk.wav");
	precache_sound("ogre/ogwake.wav");
	precache_sound("weapons/chainog.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/ogre.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!(self.health))
	{
		self.health = MAX_CHARMER_DISTANCE;
	}
	if (self.spawnflags & SPAWN_SAW)
	{
		self.th_stand = ogre_saw1;
	}
	else
	{
		if (self.spawnflags & SPAWN_CUT)
		{
			self.th_stand = ogre_cut1;
		}
		else
		{
			self.th_stand = ogre_stand1;
		}
	}
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;
	if (self.spawnflags & SPAWN_ROUNDS)
	{
		self.ammo_nails = 100;
	}
	else
	{
		self.ammo_nails = 40;
	}
	walkmonster_start();
};

void() monster_ogre_marksman = 
{
	monster_ogremarksman();
};

