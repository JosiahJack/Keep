void() alt_zombie_stand1 = [172, alt_zombie_stand2]
{
	self.solid = SOLID_NOT;
	ai_stand();
};

void() alt_zombie_stand2 = [172, alt_zombie_stand1]
{
	ai_stand();
};

void() zombie_stand1 = [0, zombie_stand2]
{
	if (self.owner != world)
	{
		if (self.owner.health <= MSG_BROADCAST)
		{
			self.ammo_shells = self.ammo_shells + SVC_SETVIEWANGLES;
			if (self.ammo_shells > 50)
			{
				sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
				ThrowHead("progs/h_axzomb.mdl", self.health);
				ThrowGib("progs/gib1.mdl", self.health);
				ThrowGib("progs/gib2.mdl", self.health);
				ThrowGib("progs/gib3.mdl", self.health);
				return;
			}
			else
			{
				T_KillDamage(self, world, world);
				self.owner = world;
				return;
			}
		}
		else
		{
			if (!corpse_status(self.owner.enemy) && self.owner.enemy.classname != "monster_zombie" && self.owner.enemy.classname != "monster_axzombie" && self.owner.enemy != world)
			{
				if (self.enemy != self.owner.enemy)
				{
					self.enemy = self.owner.enemy;
					HuntTarget();
				}
			}
			else
			{
				if (corpse_status(self.owner.enemy) && self.enemy == self.owner.enemy)
				{
					self.enemy = world;
				}
			}
		}
	}
	self.health = self.max_health;
	ai_stand();
};

void() zombie_stand2 = [1, zombie_stand3]
{
	ai_stand();
};

void() zombie_stand3 = [2, zombie_stand4]
{
	ai_stand();
};

void() zombie_stand4 = [3, zombie_stand5]
{
	ai_stand();
};

void() zombie_stand5 = [4, zombie_stand6]
{
	ai_stand();
};

void() zombie_stand6 = [5, zombie_stand7]
{
	ai_stand();
};

void() zombie_stand7 = [6, zombie_stand8]
{
	ai_stand();
};

void() zombie_stand8 = [7, zombie_stand9]
{
	ai_stand();
};

void() zombie_stand9 = [8, zombie_stand10]
{
	ai_stand();
};

void() zombie_stand10 = [9, zombie_stand11]
{
	ai_stand();
};

void() zombie_stand11 = [10, zombie_stand12]
{
	ai_stand();
};

void() zombie_stand12 = [11, zombie_stand13]
{
	ai_stand();
};

void() zombie_stand13 = [12, zombie_stand14]
{
	ai_stand();
};

void() zombie_stand14 = [13, zombie_stand15]
{
	ai_stand();
};

void() zombie_stand15 = [14, zombie_stand1]
{
	ai_stand();
};

void() zombie_cruc1 = [192, zombie_cruc2]
{
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "zombie/idle_w2.wav", SPAWN_CRUCIFIED, ATTN_STATIC);
	}
};

void() zombie_cruc2 = [193, zombie_cruc3]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() zombie_cruc3 = [194, zombie_cruc4]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() zombie_cruc4 = [195, zombie_cruc5]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() zombie_cruc5 = [196, zombie_cruc6]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() zombie_cruc6 = [197, zombie_cruc1]
{
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() zombie_walk1 = [15, zombie_walk2]
{
	if (self.owner != world)
	{
		if (self.owner.health <= MSG_BROADCAST)
		{
			self.ammo_shells = self.ammo_shells + SVC_SETVIEWANGLES;
			if (self.ammo_shells > 100)
			{
				sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
				ThrowHead("progs/h_axzomb.mdl", self.health);
				ThrowGib("progs/gib1.mdl", self.health);
				ThrowGib("progs/gib2.mdl", self.health);
				ThrowGib("progs/gib3.mdl", self.health);
				return;
			}
			else
			{
				T_KillDamage(self, world, world);
				return;
			}
		}
		else
		{
			if (!corpse_status(self.owner.enemy) && self.owner.enemy.classname != "monster_zombie" && self.owner.enemy.classname != "monster_axzombie" && self.owner.enemy != world)
			{
				if (self.enemy != self.owner.enemy)
				{
					self.enemy = self.owner.enemy;
					FoundTarget();
				}
			}
			else
			{
				if (!corpse_status(self.owner.enemy) && self.enemy == self.owner.enemy)
				{
					self.enemy = world;
					zombie_stand1();
					return;
				}
			}
		}
	}
	self.solid = SOLID_SLIDEBOX;
	self.health = self.max_health;
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk2 = [16, zombie_walk3]
{
	ai_walk(SPAWN_SLEEPING);
};

void() zombie_walk3 = [17, zombie_walk4]
{
	ai_walk(SVC_UPDATESTAT);
};

void() zombie_walk4 = [18, zombie_walk5]
{
	ai_walk(SPAWN_SLEEPING);
};

void() zombie_walk5 = [19, zombie_walk6]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() zombie_walk6 = [20, zombie_walk7]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk7 = [21, zombie_walk8]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk8 = [22, zombie_walk9]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk9 = [23, zombie_walk10]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk10 = [24, zombie_walk11]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk11 = [25, zombie_walk12]
{
	ai_walk(SPAWN_SLEEPING);
};

void() zombie_walk12 = [26, zombie_walk13]
{
	ai_walk(SPAWN_SLEEPING);
};

void() zombie_walk13 = [27, zombie_walk14]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() zombie_walk14 = [28, zombie_walk15]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk15 = [29, zombie_walk16]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk16 = [30, zombie_walk17]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk17 = [31, zombie_walk18]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk18 = [32, zombie_walk19]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walk19 = [33, zombie_walk1]
{
	ai_walk(MSG_BROADCAST);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
};

void() zombie_run1 = [34, zombie_run2]
{
	if (self.owner != world)
	{
		if (self.owner.health <= MSG_BROADCAST)
		{
			self.ammo_shells = self.ammo_shells + SVC_SETVIEWANGLES;
			if (self.ammo_shells > 100)
			{
				sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
				ThrowHead("progs/h_axzomb.mdl", self.health);
				ThrowGib("progs/gib1.mdl", self.health);
				ThrowGib("progs/gib2.mdl", self.health);
				ThrowGib("progs/gib3.mdl", self.health);
				return;
			}
			else
			{
				T_KillDamage(self, world, world);
				return;
			}
		}
		else
		{
			if (!corpse_status(self.owner.enemy) && self.owner.enemy.classname != "monster_zombie" && self.owner.enemy.classname != "monster_axzombie" && self.owner.enemy != world)
			{
				if (self.enemy != self.owner.enemy)
				{
					self.enemy = self.owner.enemy;
					FoundTarget();
				}
			}
			else
			{
				if (corpse_status(self.owner.enemy) && self.enemy == self.owner.enemy)
				{
					self.enemy = self.owner.oldenemy;
					FoundTarget();
				}
			}
		}
	}
	if (self.spawnflags & SPAWN_SLEEPING)
	{
		if (self.classname == "monster_zombie")
		{
			setmodel(self, "progs/zombie.mdl");
		}
		else
		{
			setmodel(self, "progs/axzombie.mdl");
		}
		setsize(self, VEC_HULL_MIN, '16 16 40');
		self.solid = SOLID_SLIDEBOX;
	}
	ai_run(SPAWN_CRUCIFIED);
	self.inpain = MSG_BROADCAST;
};

void() zombie_run2 = [35, zombie_run3]
{
	ai_run(SPAWN_CRUCIFIED);
};

void() zombie_run3 = [36, zombie_run4]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_run4 = [37, zombie_run5]
{
	ai_run(SPAWN_CRUCIFIED);
};

void() zombie_run5 = [38, zombie_run6]
{
	ai_run(SPAWN_SLEEPING);
};

void() zombie_run6 = [39, zombie_run7]
{
	ai_run(SVC_UPDATESTAT);
};

void() zombie_run7 = [40, zombie_run8]
{
	ai_run(SPAWN_DEAD);
};

void() zombie_run8 = [41, zombie_run9]
{
	ai_run(SPAWN_DEAD);
};

void() zombie_run9 = [42, zombie_run10]
{
	ai_run(SPAWN_SLEEPING);
};

void() zombie_run10 = [43, zombie_run11]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_run11 = [44, zombie_run12]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_run12 = [45, zombie_run13]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_run13 = [46, zombie_run14]
{
	ai_run(SPAWN_SLEEPING);
};

void() zombie_run14 = [47, zombie_run15]
{
	ai_run(SPAWN_DEAD);
};

void() zombie_run15 = [48, zombie_run16]
{
	ai_run(TE_LIGHTNING2);
};

void() zombie_run16 = [49, zombie_run17]
{
	ai_run(TE_WIZSPIKE);
};

void() zombie_run17 = [50, zombie_run18]
{
	ai_run(SVC_UPDATESTAT);
};

void() zombie_run18 = [51, zombie_run1]
{
	ai_run(SECRET_NO_SHOOT);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	if (random() > 0.8)
	{
		sound(self, CHAN_VOICE, "zombie/z_idle1.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
};

void() ZombieGrenadeTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, SVC_SETVIEWANGLES);
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "zombie/z_miss.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.velocity = VEC_ORIGIN;
	self.avelocity = VEC_ORIGIN;
	self.touch = SUB_Remove;
};

void(vector st) ZombieFireGrenade = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	sound(self, CHAN_WEAPON, "zombie/z_shot1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	org = self.origin + st_x * v_forward + st_y * v_right + (st_z - 24) * v_up;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - org);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	missile.avelocity = '3000 1000 2000';
	missile.touch = ZombieGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() zombie_atta1 = [52, zombie_atta2]
{
	ai_face();
};

void() zombie_atta2 = [53, zombie_atta3]
{
	ai_face();
};

void() zombie_atta3 = [54, zombie_atta4]
{
	ai_face();
};

void() zombie_atta4 = [55, zombie_atta5]
{
	ai_face();
};

void() zombie_atta5 = [56, zombie_atta6]
{
	ai_face();
};

void() zombie_atta6 = [57, zombie_atta7]
{
	ai_face();
};

void() zombie_atta7 = [58, zombie_atta8]
{
	ai_face();
};

void() zombie_atta8 = [59, zombie_atta9]
{
	ai_face();
};

void() zombie_atta9 = [60, zombie_atta10]
{
	ai_face();
};

void() zombie_atta10 = [61, zombie_atta11]
{
	ai_face();
};

void() zombie_atta11 = [62, zombie_atta12]
{
	ai_face();
};

void() zombie_atta12 = [63, zombie_atta13]
{
	ai_face();
};

void() zombie_atta13 = [64, zombie_run1]
{
	ai_face();
	ZombieFireGrenade('-10 -22 30');
};

void() zombie_attb1 = [65, zombie_attb2]
{
	ai_face();
};

void() zombie_attb2 = [66, zombie_attb3]
{
	ai_face();
};

void() zombie_attb3 = [67, zombie_attb4]
{
	ai_face();
};

void() zombie_attb4 = [68, zombie_attb5]
{
	ai_face();
};

void() zombie_attb5 = [69, zombie_attb6]
{
	ai_face();
};

void() zombie_attb6 = [70, zombie_attb7]
{
	ai_face();
};

void() zombie_attb7 = [71, zombie_attb8]
{
	ai_face();
};

void() zombie_attb8 = [72, zombie_attb9]
{
	ai_face();
};

void() zombie_attb9 = [73, zombie_attb10]
{
	ai_face();
};

void() zombie_attb10 = [74, zombie_attb11]
{
	ai_face();
};

void() zombie_attb11 = [75, zombie_attb12]
{
	ai_face();
};

void() zombie_attb12 = [76, zombie_attb13]
{
	ai_face();
};

void() zombie_attb13 = [77, zombie_attb14]
{
	ai_face();
};

void() zombie_attb14 = [77, zombie_run1]
{
	ai_face();
	ZombieFireGrenade('-10 -24 29');
};

void() zombie_attc1 = [79, zombie_attc2]
{
	ai_face();
};

void() zombie_attc2 = [80, zombie_attc3]
{
	ai_face();
};

void() zombie_attc3 = [81, zombie_attc4]
{
	ai_face();
};

void() zombie_attc4 = [82, zombie_attc5]
{
	ai_face();
};

void() zombie_attc5 = [83, zombie_attc6]
{
	ai_face();
};

void() zombie_attc6 = [84, zombie_attc7]
{
	ai_face();
};

void() zombie_attc7 = [85, zombie_attc8]
{
	ai_face();
};

void() zombie_attc8 = [86, zombie_attc9]
{
	ai_face();
};

void() zombie_attc9 = [87, zombie_attc10]
{
	ai_face();
};

void() zombie_attc10 = [88, zombie_attc11]
{
	ai_face();
};

void() zombie_attc11 = [89, zombie_attc12]
{
	ai_face();
};

void() zombie_attc12 = [90, zombie_run1]
{
	ai_face();
	ZombieFireGrenade('-12 -19 29');
};

void() zombie_missile = 
{
	local float r;
	r = random();
	if (r < 0.3)
	{
		zombie_atta1();
	}
	else
	{
		if (r < 0.6)
		{
			zombie_attb1();
		}
		else
		{
			zombie_attc1();
		}
	}
};

void() zombie_paina1 = [91, zombie_paina2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_paina2 = [92, zombie_paina3]
{
	ai_painforward(SVC_UPDATESTAT);
};

void() zombie_paina3 = [93, zombie_paina4]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_paina4 = [94, zombie_paina5]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paina5 = [95, zombie_paina6]
{
	ai_pain(SVC_UPDATESTAT);
};

void() zombie_paina6 = [96, zombie_paina7]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paina7 = [97, zombie_paina8]
{
};

void() zombie_paina8 = [98, zombie_paina9]
{
};

void() zombie_paina9 = [99, zombie_paina10]
{
};

void() zombie_paina10 = [100, zombie_paina11]
{
};

void() zombie_paina11 = [101, zombie_paina12]
{
};

void() zombie_paina12 = [102, zombie_run1]
{
};

void() zombie_painb1 = [103, zombie_painb2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painb2 = [104, zombie_painb3]
{
	ai_pain(SPAWN_SLEEPING);
};

void() zombie_painb3 = [105, zombie_painb4]
{
	ai_pain(SECRET_NO_SHOOT);
};

void() zombie_painb4 = [106, zombie_painb5]
{
	ai_pain(TE_LIGHTNING2);
};

void() zombie_painb5 = [107, zombie_painb6]
{
	ai_pain(SPAWN_SLEEPING);
};

void() zombie_painb6 = [108, zombie_painb7]
{
};

void() zombie_painb7 = [109, zombie_painb8]
{
};

void() zombie_painb8 = [110, zombie_painb9]
{
};

void() zombie_painb9 = [111, zombie_painb10]
{
	sound(self, CHAN_BODY, "zombie/z_fall.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painb10 = [112, zombie_painb11]
{
};

void() zombie_painb11 = [113, zombie_painb12]
{
};

void() zombie_painb12 = [114, zombie_painb13]
{
};

void() zombie_painb13 = [115, zombie_painb14]
{
};

void() zombie_painb14 = [116, zombie_painb15]
{
};

void() zombie_painb15 = [117, zombie_painb16]
{
};

void() zombie_painb16 = [118, zombie_painb17]
{
};

void() zombie_painb17 = [119, zombie_painb18]
{
};

void() zombie_painb18 = [120, zombie_painb19]
{
};

void() zombie_painb19 = [121, zombie_painb20]
{
};

void() zombie_painb20 = [122, zombie_painb21]
{
};

void() zombie_painb21 = [123, zombie_painb22]
{
};

void() zombie_painb22 = [124, zombie_painb23]
{
};

void() zombie_painb23 = [125, zombie_painb24]
{
};

void() zombie_painb24 = [126, zombie_painb25]
{
};

void() zombie_painb25 = [127, zombie_painb26]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painb26 = [128, zombie_painb27]
{
};

void() zombie_painb27 = [129, zombie_painb28]
{
};

void() zombie_painb28 = [130, zombie_run1]
{
};

void() zombie_painc1 = [131, zombie_painc2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painc2 = [132, zombie_painc3]
{
};

void() zombie_painc3 = [133, zombie_painc4]
{
	ai_pain(SVC_UPDATESTAT);
};

void() zombie_painc4 = [134, zombie_painc5]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painc5 = [135, zombie_painc6]
{
	if (self.owner)
	{
		self.ammo_shells = self.ammo_shells + SPAWN_SLEEPING;
		if (self.ammo_shells > 100)
		{
			sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
			ThrowHead("progs/h_axzomb.mdl", self.health);
			ThrowGib("progs/gib1.mdl", self.health);
			ThrowGib("progs/gib2.mdl", self.health);
			ThrowGib("progs/gib3.mdl", self.health);
			return;
		}
	}
};

void() zombie_painc6 = [136, zombie_painc7]
{
	self.nextthink = self.nextthink + SVC_SETVIEWPORT;
	self.health = self.max_health;
};

void() zombie_painc7 = [137, zombie_painc8]
{
	self.health = self.max_health;
	sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	if (!walkmove(MSG_BROADCAST, MSG_BROADCAST))
	{
		self.think = zombie_painc6;
		return;
	}
};

void() zombie_painc8 = [138, zombie_painc9]
{
	if (self.classname == "monster_axzombie")
	{
		if (self.enemy.flags & FL_CLIENT)
		{
			sound(self.enemy, CHAN_VOICE, "zombie/trick.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		}
	}
};

void() zombie_painc8b = [138, zombie_painc9b]
{
};

void() zombie_painc9b = [139, zombie_painc10]
{
	sound(self, CHAN_VOICE, "zombie/raised.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painc9 = [139, zombie_painc10]
{
};

void() zombie_painc10 = [140, zombie_painc11]
{
};

void() zombie_painc11 = [141, zombie_painc12]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painc12 = [142, zombie_painc13]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painc13 = [143, zombie_painc14]
{
};

void() zombie_painc14 = [144, zombie_painc15]
{
};

void() zombie_painc15 = [145, zombie_painc16]
{
};

void() zombie_painc16 = [146, zombie_painc17]
{
};

void() zombie_painc17 = [147, zombie_painc18]
{
};

void() zombie_painc18 = [148, zombie_run1]
{
};

void() zombie_paind1 = [149, zombie_paind2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_paind2 = [150, zombie_paind3]
{
};

void() zombie_paind3 = [151, zombie_paind4]
{
};

void() zombie_paind4 = [152, zombie_paind5]
{
};

void() zombie_paind5 = [153, zombie_paind6]
{
};

void() zombie_paind6 = [154, zombie_paind7]
{
};

void() zombie_paind7 = [155, zombie_paind8]
{
};

void() zombie_paind8 = [156, zombie_paind9]
{
};

void() zombie_paind9 = [157, zombie_paind10]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paind10 = [158, zombie_paind11]
{
};

void() zombie_paind11 = [159, zombie_paind12]
{
};

void() zombie_paind12 = [160, zombie_paind13]
{
};

void() zombie_paind13 = [161, zombie_run1]
{
};

void() zombie_paine1 = [162, zombie_paine2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.health = self.max_health;
};

void() zombie_paine2 = [163, zombie_paine3]
{
	ai_pain(SECRET_NO_SHOOT);
};

void() zombie_paine3 = [164, zombie_paine4]
{
	ai_pain(SVC_SETVIEWPORT);
};

void() zombie_paine4 = [165, zombie_paine5]
{
	ai_pain(SVC_UPDATESTAT);
};

void() zombie_paine5 = [166, zombie_paine6]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paine6 = [167, zombie_paine7]
{
	ai_pain(SPAWN_SLEEPING);
};

void() zombie_paine7 = [168, zombie_paine8]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paine8 = [169, zombie_paine9]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paine9 = [170, zombie_paine10]
{
	ai_pain(SPAWN_SLEEPING);
};

void() zombie_paine10 = [171, zombie_paine11]
{
	sound(self, CHAN_BODY, "zombie/z_fall.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	if (self.owner)
	{
		self.ammo_shells = self.ammo_shells + SPAWN_SLEEPING;
		if (self.ammo_shells > 100)
		{
			sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
			ThrowHead("progs/h_axzomb.mdl", self.health);
			ThrowGib("progs/gib1.mdl", self.health);
			ThrowGib("progs/gib2.mdl", self.health);
			ThrowGib("progs/gib3.mdl", self.health);
			return;
		}
	}
};

void() zombie_paine11 = [172, zombie_paine12]
{
	self.nextthink = self.nextthink + SVC_SETVIEWPORT;
	self.health = self.max_health;
};

void() zombie_paine12 = [173, zombie_paine13]
{
	self.health = self.max_health;
	sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	if (!walkmove(MSG_BROADCAST, MSG_BROADCAST))
	{
		self.think = zombie_paine11;
		return;
	}
};

void() zombie_paine13 = [174, zombie_paine14]
{
	if (self.classname == "monster_axzombie")
	{
		if (self.enemy.flags & FL_CLIENT)
		{
			sound(self.enemy, CHAN_VOICE, "zombie/trick.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		}
	}
};

void() zombie_paine14 = [175, zombie_paine15]
{
};

void() zombie_paine14b = [175, zombie_paine15b]
{
};

void() zombie_paine15b = [176, zombie_paine16]
{
	sound(self, CHAN_VOICE, "zombie/raised.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_paine15 = [176, zombie_paine16]
{
};

void() zombie_paine16 = [177, zombie_paine17]
{
};

void() zombie_paine17 = [178, zombie_paine18]
{
};

void() zombie_paine18 = [179, zombie_paine19]
{
};

void() zombie_paine19 = [180, zombie_paine20]
{
};

void() zombie_paine20 = [181, zombie_paine21]
{
};

void() zombie_paine21 = [182, zombie_paine22]
{
};

void() zombie_paine22 = [183, zombie_paine23]
{
};

void() zombie_paine23 = [184, zombie_paine24]
{
};

void() zombie_paine24 = [185, zombie_paine25]
{
};

void() zombie_paine25 = [186, zombie_paine26]
{
	ai_painforward(SVC_SETVIEWPORT);
};

void() zombie_paine26 = [187, zombie_paine27]
{
	ai_painforward(SVC_UPDATESTAT);
};

void() zombie_paine27 = [188, zombie_paine28]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_paine28 = [189, zombie_paine29]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paine29 = [190, zombie_paine30]
{
};

void() zombie_paine30 = [191, zombie_run1]
{
};

void() zombie_diea1 = [131, zombie_diea2]
{
	self.solid = SOLID_NOT;
};

void() zombie_diea2 = [132, zombie_diea3]
{
};

void() zombie_diea3 = [133, zombie_diea4]
{
};

void() zombie_diea4 = [134, zombie_diea5]
{
};

void() zombie_diea5 = [135, zombie_diea6]
{
};

void() zombie_diea6 = [136, zombie_diea7]
{
};

void() zombie_diea7 = [137, zombie_diea7]
{
};

void() zombie_dieb1 = [162, zombie_dieb2]
{
	self.solid = SOLID_NOT;
};

void() zombie_dieb2 = [163, zombie_dieb3]
{
};

void() zombie_dieb3 = [164, zombie_dieb4]
{
};

void() zombie_dieb4 = [165, zombie_dieb5]
{
};

void() zombie_dieb5 = [166, zombie_dieb6]
{
};

void() zombie_dieb6 = [167, zombie_dieb7]
{
};

void() zombie_dieb7 = [168, zombie_dieb8]
{
};

void() zombie_dieb8 = [169, zombie_dieb9]
{
};

void() zombie_dieb9 = [170, zombie_dieb10]
{
};

void() zombie_dieb10 = [171, zombie_dieb11]
{
};

void() zombie_dieb11 = [172, zombie_dieb12]
{
	sound(self, CHAN_VOICE, "zombie/z_fall.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_dieb12 = [173, zombie_dieb12]
{
};

void() zombie_die = 
{
	self.owner = world;
	if (self.owner.classname == "monster_zombie_master" && random() < 0.25)
	{
		self.axhitme = SPAWN_SLEEPING;
	}
	if (self.health < -30 || self.axhitme == SPAWN_SLEEPING)
	{
		sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		if (self.classname == "monster_zombie")
		{
			ThrowHead("progs/h_zombie.mdl", self.health);
		}
		else
		{
			ThrowHead("progs/h_axzomb.mdl", self.health);
		}
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	if (random() < 0.5)
	{
		zombie_diea1();
	}
	else
	{
		zombie_dieb1();
	}
};

void(entity attacker, float take) axzombie_pain = 
{
	local float r;
	self.health = self.max_health;
	if (take < 15)
	{
		return;
	}
	if (self.inpain == SPAWN_SLEEPING)
	{
		return;
	}
	if (take >= 50)
	{
		self.inpain = SPAWN_SLEEPING;
		if (random() < 0.6)
		{
			zombie_paine1();
		}
		else
		{
			zombie_painc1();
		}
		return;
	}
	if (self.inpain)
	{
		self.pain_finished = time + SVC_UPDATESTAT;
		return;
	}
	if (self.pain_finished > time)
	{
		self.inpain = SPAWN_SLEEPING;
		if (random() < 0.5)
		{
			zombie_paine1();
		}
		else
		{
			zombie_painc1();
		}
		return;
	}
	self.inpain = SPAWN_CRUCIFIED;
	r = random();
	if (r < 0.33)
	{
		zombie_paina1();
	}
	else
	{
		if (r < 0.66)
		{
			zombie_painb1();
		}
		else
		{
			zombie_paind1();
		}
	}
};

void(entity attacker, float take) zombie_pain = 
{
	local float r;
	self.health = self.max_health;
	if (take < TE_LIGHTNING3)
	{
		return;
	}
	if (self.inpain == SPAWN_SLEEPING)
	{
		return;
	}
	if (take >= 25)
	{
		self.inpain = SPAWN_SLEEPING;
		zombie_paine1();
		return;
	}
	if (self.inpain)
	{
		self.pain_finished = time + SVC_UPDATESTAT;
		return;
	}
	if (self.pain_finished > time)
	{
		self.inpain = SPAWN_SLEEPING;
		zombie_paine1();
		return;
	}
	self.inpain = SPAWN_CRUCIFIED;
	r = random();
	if (r < 0.25)
	{
		zombie_paina1();
	}
	else
	{
		if (r < 0.5)
		{
			zombie_painb1();
		}
		else
		{
			if (r < 0.75)
			{
				zombie_painc1();
			}
			else
			{
				zombie_paind1();
			}
		}
	}
};

void() zombie_decide = 
{
	if (self.health == self.max_health + SPAWN_CRUCIFIED)
	{
		zombie_paine12();
	}
	else
	{
		zombie_run1();
	}
};

void() zombie_start = 
{
	if (self.spawnflags & SPAWN_SLEEPING)
	{
		alt_zombie_stand1();
	}
	else
	{
		zombie_stand1();
	}
};

void() zombie_use = 
{
	if (!(self.spawnflags & SPAWN_SLEEPING))
	{
		self.spawnflags = SPAWN_SLEEPING;
	}
	if (self.classname == "monster_zombie")
	{
		setmodel(self, "progs/zombie.mdl");
	}
	else
	{
		setmodel(self, "progs/axzombie.mdl");
	}
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.solid = SOLID_SLIDEBOX;
	self.health = self.max_health + SPAWN_CRUCIFIED;
	self.th_stand = alt_zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_paine12;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_missile = zombie_missile;
	self.th_melee = SUB_Null;
	self.use = SUB_Null;
	walkmonster_start();
};

void() monster_zombie = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/zombie.mdl");
	precache_model("progs/h_zombie.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");
	precache_sound("zombie/raised.wav");
	if (self.spawnflags & SPAWN_DEAD)
	{
		self.solid = SOLID_NOT;
	}
	else
	{
		self.solid = SOLID_SLIDEBOX;
	}
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/zombie.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.max_health = 60;
	self.health = self.max_health + SPAWN_CRUCIFIED;
	if (self.spawnflags & SPAWN_DEAD)
	{
		self.use = zombie_use;
	}
	else
	{
		self.th_stand = zombie_start;
		self.th_walk = zombie_walk1;
		self.th_run = zombie_decide;
		self.th_pain = zombie_pain;
		self.th_die = zombie_die;
		self.th_missile = zombie_missile;
		self.th_melee = SUB_Null;
	}
	if (!(self.owner))
	{
		self.owner = world;
	}
	if (self.spawnflags & SPAWN_DEAD)
	{
		zombie_paine12();
		self.think = SUB_Null;
	}
	else
	{
		if (self.spawnflags & SPAWN_CRUCIFIED)
		{
			self.movetype = MOVETYPE_NONE;
			zombie_cruc1();
		}
		else
		{
			if (!(self.gravity))
			{
				self.gravity = SPAWN_CRUCIFIED;
			}
			else
			{
				self.gravity = (self.gravity - SPAWN_CRUCIFIED) / 100;
			}
			walkmonster_start();
		}
	}
};

void() monster_axzombie = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/axzombie.mdl");
	precache_model("progs/h_axzomb.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");
	precache_sound("zombie/raised.wav");
	precache_sound("zombie/trick.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/axzombie.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.max_health = 400;
	self.health = self.max_health + SPAWN_CRUCIFIED;
	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_pain = axzombie_pain;
	self.th_die = zombie_die;
	self.th_missile = zombie_missile;
	self.th_melee = SUB_Null;
	self.owner = world;
	if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		self.movetype = MOVETYPE_NONE;
		zombie_cruc1();
	}
	else
	{
		if (!(self.gravity))
		{
			self.gravity = SPAWN_CRUCIFIED;
		}
		else
		{
			self.gravity = (self.gravity - SPAWN_CRUCIFIED) / 100;
		}
		walkmonster_start();
	}
};

