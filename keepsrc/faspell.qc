void() 	FlareGlitter;

void() faSpellTouch = {
	local float damg;
	if (other == self.owner) return ;
	if ((pointcontents(self.origin) == CONTENT_SKY)) { remove(self); return; }

	damg = random(12.00000,22.00000);
	if ( other.health ) T_Damage ( other, self, self.owner, damg, DAMARMOR);
	T_RadiusDamage ( self, self.owner, damg, other, DAMAGEALL);
	sound ( self, CHAN_WEAPON, "hexen2/weapons/explode.wav", 1.00000, ATTN_NORM);
	self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
	FlareGlitter();
	remove ( self);
};

// Hexen 2 sequence animator
float AdvanceFrame(float min, float max) = {
	if (self.frame < min) {
		self.frame = min;
		return self.frame;
	}

	if (self.frame > max) {
		self.frame = max;
		return self.frame;
	}

	if (self.frame < max) {
		self.frame = self.frame + 1;
		if (self.frame > max) self.frame = min;
		return self.frame;
	}

	return self.frame;
};

void() faspell_frames = {
	local float old_angle, old_count;
	local vector new_posA, new_posB, posA, posB;

	self.think = faspell_frames;
	self.nextthink = time + HX_FRAME_TIME;
	AdvanceFrame(0.00000, 8.00000);
	AdvanceFrame(0.00000, 8.00000); // YES, Hexen2 did this twice and so shall we! - Qmaster
	old_angle = self.spell_angle;
	old_count = self.count;
	self.spell_angle += random(32.00000,42.00000);
	if ( (self.spell_angle >= 360.00000) ) self.spell_angle -= 360.00000;
	if ( (self.count < 6.00000) ) self.count += 0.60000;
	makevectors ( self.angles);
	posA = ((v_right * sin ( self.spell_angle)) * self.count);
	posB = ((v_right * sin ( old_angle)) * old_count);
	new_posA = (posA - posB);
	posA = ((v_up * cos ( self.spell_angle)) * self.count);
	posB = ((v_up * cos ( old_angle)) * old_count);
	new_posB = (posA - posB);
	new_posA += new_posB;
	walkmove(self.angles_y, vlen(new_posA - new_posB));
	if (self.lifetime < time) remove(self);
};

void(vector offset,float set_speed) do_faSpell = {
	local entity missile;
	local vector vec;

	missile = spawn ( );
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.flags = FL_FLY;
	missile.health = 10.00000;
	missile.effects = EF_DIMLIGHT;
	setmodel(missile, "progs/hexen2/faspell.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	makevectors(self.angles);
	setorigin(missile, (self.origin + self.attack_offset));
	vec = ((self.enemy.origin - missile.origin) + self.enemy.attack_offset);
	vec = normalize ( vec);
	missile.velocity = (vec * set_speed);
	missile.angles = vectoangles ( missile.velocity);
	missile.spell_angle = random(360.00000);
	missile.count = 1.00000;
	missile.touch = faSpellTouch;
	missile.think = faspell_frames;
	missile.lifetime = (time + 3.00000);
	missile.nextthink = time + HX_FRAME_TIME;
};