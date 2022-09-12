void() Plasma_PreCache = 
{
	precache_sound("weapons/dsfirxpl.wav");
	precache_sound("weapons/dsplasma.wav");
	precache_model("progs/pbullet.mdl");
	precache_model("progs/g_plasma.mdl");
	precache_model("progs/v_plasma.mdl");
	precache_model("progs/s_plasma.spr");
};

void() s_pexplode1 = [1, s_pexplode2]
{
	self.nextthink = time + 0.05;
};

void() s_pexplode2 = [2, s_pexplode3]
{
	self.nextthink = time + 0.05;
};

void() s_pexplode3 = [3, s_pexplode4]
{
	self.nextthink = time + 0.05;
};

void() s_pexplode4 = [4, s_pexplode5]
{
	self.nextthink = time + 0.05;
};

void() s_pexplode5 = [5, SUB_Remove]
{
	self.nextthink = time + 0.05;
};

void() PlasmaExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "progs/s_plasma.spr");
	self.solid = SOLID_NOT;
	s_pexplode1();
};

void() T_PlasmaTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = 17 + random() * 27;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	self.origin = self.origin - 8 * normalize(self.velocity);
	sound(self, CHAN_WEAPON, "weapons/dsfirxpl.wav", 1, ATTN_NORM);
	PlasmaExplosion();
};

void() W_FirePlasma = 
{
	local entity missile;
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/dsplasma.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -2;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1600;
	missile.avelocity = '300 300 0';
	missile.nextthink = time + 6;
	missile.touch = T_PlasmaTouch;
	missile.think = SUB_Remove;
	missile.effects = 8;
	setmodel(missile, "progs/s_plasma.spr");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8 + '0 0 10' + v_right * 10);
};

void() weapon_plasmagun = 
{
	precache_model("progs/g_plasma.mdl");
	setmodel(self, "progs/g_plasma.mdl");
	self.weapon = 3;
	self.netname = "Plasma Gun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

