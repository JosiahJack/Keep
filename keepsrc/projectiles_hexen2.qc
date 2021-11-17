//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Hexen 2
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 7
//
// Implements: Hexen 2 Projectile Effects
//
// Description:
// Has the blade and spell attacks for Fallen Angel.
//=============================================================================

void() FlareGlitter;

void() faBladeTouch =  { // [FUNCTION]
	local float damg = 0.00000;

   if (other == self.owner)  return;
   if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

   damg = random(8.00000,16.00000);
   if ( other.health ) T_Damage ( other, self, self.owner, damg, DAMARMOR);
   sound ( self, CHAN_WEAPON, "hexen2/weapons/expsmall.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   //CreateGreenSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 4.00000));
   remove(self);
};

void() frame_BLADE = [0, frame_BLADE] {}; // [FUNCTION]

void(vector offset,float set_speed,vector dest_offset) do_faBlade =  { // [FUNCTION]
	local entity missile;
	local vector vec;

	missile = spawn ( );
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.flags = FL_FLY;
	missile.health = 10.00000;
	//missile.effects = EF_DIMLIGHT;
	//missile.drawflags = MLS_ABSLIGHT;
	//missile.abslight = 0.50000;
	setmodel ( missile, "progs/hexen2/fablade.mdl");
	setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
	makevectors ( self.angles);
	setorigin ( missile, (self.origin + self.attack_offset));
	vec = (((self.enemy.origin - missile.origin) + self.enemy.attack_offset) + dest_offset);
	vec = normalize ( vec);
	missile.velocity = (vec * set_speed);
	missile.angles = vectoangles ( missile.velocity);
	missile.touch = faBladeTouch;
};

void() faSpellTouch = { // [FUNCTION]
	local float damg;

	if (other == self.owner) return;
	if ((pointcontents(self.origin) == CONTENT_SKY)) { remove(self); return; }

	damg = random(12,22);
	if ( other.health ) T_Damage ( other, self, self.owner, damg, DAMARMOR);
	T_RadiusDamage ( self, self.owner, damg, other, DAMAGEALL);
	sound ( self, CHAN_WEAPON, "hexen2/weapons/explode.wav", 1.00000, ATTN_NORM);
	self.origin = self.origin - (8 * normalize(self.velocity));
	FlareGlitter();
	remove(self);
};

// Hexen 2 general sequence animator
float AdvanceFrame(float min, float max) = { // [FUNCTION]
	if (self.frame < min) { self.frame = min; return self.frame; }
	if (self.frame > max) { self.frame = max; return self.frame; }
	if (self.frame < max) { // != max
		self.frame = self.frame + 1;
		if (self.frame > max) self.frame = min;
		return self.frame;
	}
	return self.frame;
};

void() faspell_frames = { // [FUNCTION]
	local float old_angle, old_count;
	local vector new_posA, new_posB, posA, posB;

	self.think = faspell_frames;
	self.nextthink = time + HX_FRAME_TIME;
	AdvanceFrame(0,8);
	AdvanceFrame(0,8); // YES, Hexen2 did this twice... and so shall we! - Qmaster
	old_angle = self.spell_angle;
	old_count = self.count;
	self.spell_angle += random(32,42);
	if (self.spell_angle >= 360) self.spell_angle -= 360.00000;
	if (self.count < 6) self.count += 0.60000;
	makevectors ( self.angles);
	posA = ((v_right * sin(self.spell_angle)) * self.count);
	posB = ((v_right * sin(old_angle)) * old_count);
	new_posA = (posA - posB);
	posA = ((v_up * cos(self.spell_angle)) * self.count);
	posB = ((v_up * cos(old_angle)) * old_count);
	new_posB = (posA - posB);
	new_posA += new_posB;
	walkmove(self.angles_y, vlen(new_posA - new_posB));
	if (self.lifetime < time) remove(self);
};

void(vector offset,float set_speed) do_faSpell = { // [FUNCTION]
	local entity missile;
	local vector vec;

	missile = spawn();
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
	vec = normalize(vec);
	missile.velocity = vec * set_speed;
	missile.angles = vectoangles(missile.velocity);
	missile.spell_angle = random(360);
	missile.count = 1;
	missile.touch = faSpellTouch;
	missile.think = faspell_frames;
	missile.lifetime = time + 3;
	missile.nextthink = time + HX_FRAME_TIME;
};