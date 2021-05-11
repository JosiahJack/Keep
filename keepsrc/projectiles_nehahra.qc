void() nehahra_wreckbsp;

vector() nehahra_lead = {
	local float num;
	local vector megadeth, vec;
	local entity mark;

	if (!self.enemy) return VEC_ORIGIN;

	mark = find(world, classname, "nehahra_head");
	num = 1;
	megadeth = self.enemy.origin - mark.origin;
	num = vlen(megadeth);
	num = num * 0.001;
	vec = self.enemy.velocity;
	vec_z = vec_z * 0.25;
	vec = self.enemy.origin + (vec * num);
	vec = normalize(vec - mark.origin);
	return vec;
};

void() WeldExplode1 = [0, WeldExplode2] {};
void() WeldExplode2 = [3, WeldExplode3] {};
void() WeldExplode3 = [4, SUB_Remove] {};

void(entity targ, float playdmg, float mondmg) ApplyFireDmg;

void() WeldTouch = {
	local float r, d, db;
	local entity e;

	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }
	if (self.waterlevel > 1) { remove(self); return; }
	if (self.enemy.classname == "the_mister") { remove(self); return; }
	if (self.enemy.items & IT_SUIT) { remove(self); return; }
	if (self.enemy.event == "nehahra_frame" || self.enemy.classname == "monster_nehahra") { remove(self); return; }

	if (other.takedamage) spawn_touchblood(self, other, 9);
	e = findradius(self.origin, WELD_DAMAGE_RADIUS);
	while (e) {
		if (e.takedamage) {
			if (e.takedamage != DAMAGE_AIM) {
				T_Damage(e, self, self.owner, 10, DAMARMOR);
			} else {
				r = random();
				db = 10 + (0.5 - r) * 6;
				d = vlen(e.origin + '0 0 16' - self.origin);
				if (d < WELD_DAMAGE_RADIUS - 4 * db) {
					d = db;
				} else {
					if (d < WELD_DAMAGE_RADIUS)
						d = (WELD_DAMAGE_RADIUS - d) * 0.25;
					else
						d = 0;
				}
				if (d) {
					
					if (r > 0.85) {
						if (d > 5) {
							if ((e.flags & FL_CLIENT) || (e.flags & FL_MONSTER))
								ApplyFireDmg(e, d, d);
							else
								if (ai_foundbreakable(self, e, FALSE)) T_Damage(e, self, self.owner, d, DAMARMOR);
						}
					}
				}
			}
		}
		e = e.chain;
	}
	self.origin = self.origin - 4 * normalize(self.velocity);
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	self.think = SUB_Remove;
	self.nextthink = time + 4;
	setmodel(self, "progs/s_explod.spr");
	setorigin(self, self.origin);
	sound(self, CHAN_BODY, "boss3/hit.wav", 1, ATTN_NORM);
	WeldExplode1();
};

void(vector org, vector dir) WeldFire = {
	local entity weld, head;

	weld = spawn();
	if (self.classname == "monster_nehahra") { // could be max mister
		head = find(world, classname, "nehahra_head");
		if (head == world) {
			weld.owner = self;
		} else {
			weld.owner = head;
		}
	} else {
		weld.owner = self;
	}
	weld.movetype = MOVETYPE_FLYMISSILE;
	weld.solid = SOLID_BBOX;
	weld.event = "mthret";
	weld.touch = WeldTouch;
	if (self.classname == "monster_nehahra") {
		if (((self.enemy.bloodtype > 0) || (!(self.enemy.flags & FL_MONSTER)) && !(self.enemy.flags & FL_CLIENT))) { // could be max mister
			weld.touch = nehahra_wreckbsp;
		}
	}
	weld.classname = "weld_blob";
	weld.think = SUB_Remove;
	weld.nextthink = time + 6;
	weld.velocity = dir * 1000;
	weld.angles = vectoangles(weld.velocity);
	weld.angles_x = weld.angles_x + 90;
	if (time >= weld.owner.attack_finished) {
		weld.effects = weld.effects | EF_DIMLIGHT;
		weld.owner.attack_finished = time + 0.2;
	}
	setmodel(weld, "progs/flame2.mdl");
	setsize(weld, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(weld, org - '0 0 6' + dir * FL_CLIENT);
	sound(weld.owner, CHAN_WEAPON, "weapons/spike2.wav", 0.6, ATTN_NORM);
	sound(weld, CHAN_BODY, "hknight/idle.wav", 1, ATTN_NORM);
};

void() nehahra_spitfire = {
	local vector spot, org, vec;

	makevectors(self.angles);
	spot = self.origin + '0 0 235';
	org = spot + v_forward * 10;
	if (random() < 0.6) {
		vec = nehahra_lead();
	} else {
		vec = self.enemy.origin - spot;
	}
	vec = normalize(vec);
	WeldFire(org, vec);
};

void(float offset) max_shootfire = {
	local vector org, vec, spot;

	makevectors(self.angles);
	spot = self.origin + '0 0 20';
	org = spot + v_forward * 10;
	if (random() < 0.8)
		vec = mindcrime_lead(1000);
	else
		vec = self.enemy.origin - spot;
	vec = normalize(vec);
	WeldFire(org, vec);
};