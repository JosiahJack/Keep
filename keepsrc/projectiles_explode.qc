//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, though primarily Arcane Dimensions (AD)
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
// Entity count: 
// Function count: 
//
// Implements: Projectile System for Players and Monsters
//
// Description:
// Generic functions for projectile explosions and effects.
//=============================================================================

void() Touch_ShellCasing;
void() MultiGrenadeTouch;
void() MultiGrenadeExplode;
void() SuperGrenade_Think;
void() SuperRocket_Think;
void(vector org, vector vec, float light) HIP_LaunchLaser;
void() spark_spawn;
void() Mirv_Payload;
void() Mirv_Reset;
void(vector startpos, float radius, float life) SpawnOrbLightning;
void(float offsetAngle) MiniGrenadeLaunch;
void(entity inflictor, float damage) Hammer_Block;
void() Ember_Think;
void() Smokey_Think;
void(entity fire, float chance) FloorFire_SpawnCheck;
void(float ents) Ember_Shower;
void() FlareGlitter_Think;
void() Flare_Activate;
void(vector minion_org, entity minion_targ) minion_spider;
void(vector minion_org, entity minion_targ) minion_scorpion;
void(vector minion_org, entity minion_targ) minion_voreling;
void() IceMine_Explode;

// Classic ID rocket/grenade explosion
void() s_explode1 = [0,	s_explode2] {}; // [FUNCTION]
void() s_explode2 = [1,	s_explode3] {}; // [FUNCTION]
void() s_explode3 = [2,	s_explode4] {}; // [FUNCTION]
void() s_explode4 = [3,	s_explode5] {}; // [FUNCTION]
void() s_explode5 = [4,	s_explode6] {}; // [FUNCTION]
void() s_explode6 = [5,	SUB_Remove] {}; // [FUNCTION]

void() s_explode_think = { // [FUNCTION]
    if (self.frame >= self.cnt) { SUB_Remove();  return;}

    self.frame = self.frame + 1;
    self.nextthink = time + self.wait;
    if (self.frame == self.cnt) self.think = SUB_Remove;
};

// General purpose animated spite function.  Types: Small, medium, big, plasma, puffpuff!
void() SpawnExplosion_think = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > self.count) SUB_Remove();
	else self.nextthink = time + self.speed;
};

void(float sprite_type, vector org, string expl_sound) SpawnExplosion = { // [FUNCTION]
	local string spr_name;
	local float spr_count, spr_speed;
	
	spr_count = -1;
	if (sprite_type == EXPLODE_SMALL) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEEXPLODE), org, '0 0 0', 1);
		spr_name = SEXP_SMALL;
		spr_count = 5;
		spr_speed = 0.1;
	} else if (sprite_type == EXPLODE_MED) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEEXPLODE), org, '0 0 0', 1);
		spr_name = SEXP_MED;
		spr_count = 13;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEEXPLODE), org, '0 0 0', 1);
		spr_name = SEXP_BIG;
		spr_count = 16;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_PLASMA_SMALL) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		spr_name = SEXP_PLASMA_SMALL;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_PLASMA_MED || sprite_type == EXPLODE_PLASMA_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMABIG), org, '0 0 0', 1);
		spr_name = SEXP_PLASMA_BIG;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_POISON_SMALL) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPOISON), org, '0 0 0', 1);
		spr_name = SEXP_POISON_SMALL;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_POISON_MED || sprite_type == EXPLODE_POISON_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPOISONMED), org, '0 0 0', 1);
		spr_name = SEXP_POISON_MED;
		spr_count = 12;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_ELECT_SMALL || sprite_type == EXPLODE_ELECT_MED || sprite_type == EXPLODE_ELECT_BIG) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		spr_name = SEXP_ELECTRIC;
		spr_count = 4;
		spr_speed = 0.1;
	} else if (sprite_type == EXPLODE_ICE_BIG) {
		// This must be pre-cached by entity using it (monster_icegolem)!  This is not cached in worldspawn as its rarely used.
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		spr_name = SEXP_ICE_BIG;
		spr_count = 9;
		spr_speed = 0.1;
	} else if (sprite_type == EXPLODE_BURST_SMOKE) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBSMOKE), org, '0 0 0', 1);
		spr_name = SBURST_SMOKE;
		spr_count = 6;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_BURST_FLAME) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBFLAME), org, '0 0 0', 1);
		spr_name = SBURST_FLAME;
		spr_count = 6;
		spr_speed = 0.05;
	} else if (sprite_type == EXPLODE_BURST_POISON) {
		if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBPOISON), org, '0 0 0', 1);
		spr_name = SBURST_POISON;
		spr_count = 6;
		spr_speed = 0.05;
	} else return; // NO EXPLOSION, let's get outta here!

	// Always spawn a temporary entity.  Need one for sprite and/or explosion sound
	newmis = spawn();
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	setorigin(newmis, org);

	// Any sprite requirements? (Fitz engine)
	if (spr_count > 0) {
		setmodel(newmis, spr_name);	// Setup sprite
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.alpha = 0.85;		// Slightly transparent
		newmis.effects = 32;		// Additive blending
		newmis.count = spr_count;	// Total frames
		newmis.speed = spr_speed;	// Frame speed
		newmis.think = SpawnExplosion_think;
		newmis.nextthink = time + newmis.speed;
	} else {
		// No sprite required but need entity for sound to play
		// Allow for sound to finish and just remove
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.think = SUB_Remove;
		newmis.nextthink = time + 4;
	}

	// Play any explosion sounds on temporary entity
	if (self.owner.classtype == CT_MONEEL) expl_sound = "ad171/eel/impact1.wav";
	if (expl_sound != "") sound(newmis, CHAN_WEAPON, expl_sound, 1, ATTN_NORM);
};

// Use SpawnExplosion where possible as it copes with DP effects better.
void() BecomeExplosion = { // [FUNCTION]
	self.touch = SUB_Null;
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, "");
	SpawnExplosion(EXPLODE_SMALL, self.origin, "");
	self.nextthink = time + 0.6;
	self.think = SUB_Remove;
};

void(vector spot) Tent_Explosion = { // [FUNCTION]
    Tent_Point(TE_EXPLOSION,spot);
};

void(vector spot, float rgb, float add) Tent_Explosion2 = { // [FUNCTION]
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, 12);      // TE_EXPLOSION2
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
    if (rgb > 256) rgb = 256;
    if (add > 256) add = 256;
    if (add >= rgb) rgb = add;
    if (rgb > 0) WriteByte (MSG_BROADCAST, rgb); // First index to use on the palette.
    if (add > 0) WriteByte (MSG_BROADCAST, add); // Range is from rgb to rgb+add-1.
};

void(vector spot) R_Exp3 = { // [FUNCTION]
    local entity e;

    e = spawn();
    setorigin(e, spot);
    sound(e,CHAN_AUTO, "weapons/r_exp3.wav", 1, ATTN_NORM);
	entity_remove(e,3); // Kind of the point to delay removal before playing the sound
};

void(vector spot) R_ExpSmall = { // [FUNCTION]
    local   entity  e;

    e = spawn();
    setorigin(e, spot);
    sound(e, CHAN_AUTO, "kinn/shuffler/expsmall.wav", 1, ATTN_NORM);
	entity_remove(e,3); // Kind of the point to delay removal before playing the sound
};

void(vector spot, float rgb, float add) Rocket_Explosion2 = { R_Exp3 (spot); Tent_Explosion2 (spot, rgb, add); }; // [FUNCTION]

void(vector spot) Rocket_TarExplosion = { // [FUNCTION]
    R_Exp3 (spot);
	Tent_Point(TE_TAREXPLOSION,spot);
};

void() Old_Explosion1 = { R_Exp3(self.origin); Tent_Explosion(self.origin); BecomeExplosion(); }; // [FUNCTION]

//  Common Explosions
//float   CX_ORANGE   = 0;
//float   CX_RED      = 1;
//float   CX_YELLOW   = 2;
//float   CX_BLUE     = 3;
//float   CX_PURPLE   = 4;
void(vector spot, float r) Colored_Explosion = { // [FUNCTION]
    local float base, add;

    if (r == 3) { base = 244; add = 3; }
    else if (r == 2) { base = 240; add = 4; }
    else if (r == 1) { base = 247; add = 5; }
    else {
        r = random() * 3;
        if (r < 1) { base = 224; add = 16; }
        else if (r < 2) { base = 230; add = 8; }
        else { base = 232; add = 8; }
    }
    Rocket_Explosion2 (spot, base, add);
};

void(float base, float add, string text) BecomeAnyExplosionSetup = { // [FUNCTION]
	if (!add) add = 6; // Assume standard duration of six frames.
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel(self, text);
    self.solid      = SOLID_NOT;
    self.frame      = base;
    self.cnt        = base + add - 1;
	self.nextthink  = time + self.wait;
    self.think      = s_explode_think;
};

// As 'BecomeAnyExplosion', with adjustable frames per second.  Used by some custom explosions.
void(float base, float add, float fps, string text) BecomeFpsExplosion = { // [FUNCTION]
    if (!fps) fps = 10;
    self.wait = 1 / fps;
	BecomeAnyExplosionSetup(base,add,text);
};

void(float base, float add, string text) BecomeAnyExplosion = { BecomeFpsExplosion(base,add,10,text); }; // [FUNCTION]

void(vector spot, float base, float add, string text) MakeAnyExplosion = { // [FUNCTION]
    local entity swap;

    swap = self;
    self = spawn();
    setsize (self, '0 0 0', '0 0 0');        
    setorigin(self, spot);
    BecomeAnyExplosion (base, add, text);
    self = swap;
};

void(float base, float add) BecomeFancy = { BecomeAnyExplosion (base, add, "progs/drake/s_fancy.spr"); }; // [FUNCTION]

void(vector spot, float base, float add) MakeFancy = { MakeAnyExplosion (spot, base, add, "progs/drake/s_fancy.spr"); }; // [FUNCTION]

//  Ice Explosions.  frames 0-2 = iceballs, frames 3-7 = explosion of shards.
void() BecomeIcyExp = { // [FUNCTION]
    self.skin = 0;
    BecomeAnyExplosion (3, 5, "progs/drake/iceball.mdl");
    self.alpha = ALPHA_ICE;
};

void(vector spot) MakeIcyExp = { // [FUNCTION]
    local entity iced;

    iced = spawn();
    iced.movetype   = MOVETYPE_NONE;
    iced.velocity   = '0 0 0';
    iced.touch      = SUB_Null;
    iced.solid      = SOLID_NOT;
    iced.alpha      = ALPHA_ICE;
    iced.frame      = 3;
    iced.cnt        = iced.frame + 4;    // 5 - 1
    iced.wait       = 0.1;
    iced.nextthink  = time + 0.1;
    iced.think      = s_explode_think;
    setall(iced, "progs/drake/iceball.mdl", '0 0 0', '0 0 0', spot);
};

// Modified Custents explosion, fast version; slow version was <7, 8, 10, 12, 14, 16, 18, 19, 20>.
void() s_explodeb1  = [  7,  s_explodeb2 ] {}; // [FUNCTION]
void() s_explodeb2  = [ 10,  s_explodeb3 ] {}; // [FUNCTION]
void() s_explodeb3  = [ 13,  s_explodeb4 ] {}; // [FUNCTION]
void() s_explodeb4  = [ 16,  s_explodeb5 ] {}; // [FUNCTION]
void() s_explodeb5  = [ 19,  s_explodeb6 ] {}; // [FUNCTION]
void() s_explodeb6  = [ 20,  SUB_Remove  ] {}; // [FUNCTION]

void() s_fiery1 = [  1, s_fiery2 ] {}; // [FUNCTION]
void() s_fiery2 = [  3, s_fiery3 ] {}; // [FUNCTION]
void() s_fiery3 = [  5, s_fiery4 ] {}; // [FUNCTION]
void() s_fiery4 = [  7, s_fiery5 ] {}; // [FUNCTION]
void() s_fiery5 = [  9, s_fiery6 ] {}; // [FUNCTION]
void() s_fiery6 = [ 11, s_fiery7 ] {}; // [FUNCTION]
void() s_fiery7 = [ 13, s_fiery8 ] {}; // [FUNCTION]
void() s_fiery8 = [ 15, SUB_Remove] {}; // [FUNCTION]

void(string fx, void() thinkst) Explosion_Start = { // [FUNCTION]
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel(self, fx);
    self.solid      = SOLID_NOT;
    thinkst();
};

void() BecomeTheBigFire = { // [FUNCTION]
    if (deathmatch || coop)	Explosion_Start ("progs/quoth/bigexp.spr", s_fiery1);
    else					BecomeFpsExplosion (0, 17, 20, "progs/quoth/bigexp.spr");
};

void() BecomeExplosion2 = { // [FUNCTION]
    if (deathmatch || coop)	Explosion_Start ("progs/drake/s_explod.spr", s_explodeb1);
    else					BecomeFpsExplosion (6, 16, 25, "progs/drake/s_explod.spr");
};

// Like BecomeExplosion, but for Nemesants.  Some drake bosses use this for their post-mortem explosions.
void() WarpExplosion = { // [FUNCTION]
    sound(self, CHAN_AUTO, "zerstorer/trog/bigboom.wav", 1, ATTN_NORM);
    Tent_Point (TE_EXPLOSION, self.origin);
    FlameWave();       // PM:  New shockwave effect at ground zero.
    BecomeTheBigFire();    // Replaced old fireball mdl with big sprite.
};

// BDW_TracerEffect
// This approximates a tracer effect for missiles and such. the only way to
// produce a particle effect in quakec is to call the particle() function,
// which is quite limited; particle origins are randomised (in the game, this
// appears to be roughly 16 units in each direction) so there is a limit as to
// how accurately you can specify a particles origin.  Also, colour is slightly
// randomised, but this generally works in your favour.  Called each frame,
// what this function does is work out how far the missile has travelled since
// it last spawned particles, it then spawns a certain number every 16 units to
// fill the gap.
void() BDW_TracerEffect = {	// [FUNCTION]
	local vector dir, porg;
	local float len, pcol;

	dir = self.origin - self.oldorigin;
	len = vlen(dir);
	if (len < 16) return; // Not enough distance travelled to spawn particle,
                          // so keep oldorigin and return.

	if (self.color_x <= 0) pcol = 232;	//lava red
	else pcol = self.color_x;

	dir = normalize(dir);
	while (len > 0) {
		porg = self.oldorigin + dir*len;
		particle(porg, VEC_ORIGIN, pcol, 4);
		len = len - 16;
	}
	self.oldorigin = self.origin;
};

void() Particle_Bullet = { // [FUNCTION]
	if (self.waitmin > time) return; // Is the touch function blocked?
	if (self.delay < time) { entity_remove(self, 1); return; }

	if (random() < 0.5) {
		self.oldorigin = crandom() * '1 1 1';
		if (random() < 0.8) self.lip = rint(random()*4);
		else self.lip = 112 + rint(random()*4);
		particle (self.origin, self.oldorigin, self.lip, 1 + rint(random()*2));
	}
	self.think = Particle_Bullet;
	self.nextthink = time + self.speed;
};

// PLASMA PROJECTILES 
// * requires special blue/white particle trail
// * Has radius and impact touch damage
// * used by Eliminator (enforcer), Soldier and Minotaur
void() Particle_Plasma = { // [FUNCTION]
	if (self.waitmin > time) return; // projectile has touched something
	if (self.attack_finished < time) { entity_remove(self, 0.1); return;} // Projectile has run out of time
	
	// Generate sprite particles? DP not active?
	if (random() < 0.5 && !ext_dppart) {
		self.oldorigin = crandom() * '1 1 1';
		self.lip = 40 + rint(random()*8);
		particle(self.origin, self.oldorigin, self.lip, 4 + rint(random()*4));
		self.lip = 198 + rint(random()*4);
		particle(self.origin, self.oldorigin, self.lip, 2 + rint(random()*2));
	}

	// The Player plasma projectile grows over frames
	if (self.owner.flags & FL_CLIENT) {
		if (self.attack_finished < time) {
			self.frame = self.frame + 1;
			if (self.frame < 6) self.attack_finished = time + 0.1;
			else self.frame = 6;
		}
	}

	// Keep looping
	self.think = Particle_Plasma;
	self.nextthink = time + self.speed;	
};

void() Puff_Missile = { SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, ""); entity_remove(self, 0.1); }; // [FUNCTION], Removes a missile in a light puff of smoke.

void() Explode_Grenade = { // [FUNCTION]
	if (self.state == STATE_DISABLED) return; // Block touch functions

	self.touch = SUB_Null;
	self.state = STATE_DISABLED;
	
	// Customize damage based on projectile type
	if (self.classtype == CT_PROJ_GLMON) self.dmg = DAMAGE_MONGRENADE;
	else if (self.classtype == CT_PROJ_MEGG) self.dmg = 0;
	else if (self.classtype == CT_PROJ_NOUR2) {
		self.dmg = DAMAGE_MONGRENADE;
		// Don't spawn gib models at impact (could be solid)
		self.oldorigin = self.origin;
		self.origin = self.origin - 8*normalize(self.velocity);
		// Special gib model, frame and movement pattern
		self.gib1mdl = MODEL_PROJ_NOUR2S;
		self.gib1sound = GIB_IMPACT_ACID;
		self.max_health = MON_GIBFOUNTAIN;
		self.gib1frame = 9;
		self.gibtype = GIBTYPE_POISON;
		self.gibpartstyle = PARTICLE_BURST_YELLOW; // Setup particles from gib on floor
		self.gib1dmg = rint( 2 + (random() * skill) ); // Setup damage and impact explosion
		self.gib1exp = EXPLODE_BURST_POISON;
		ThrowGib(11, rint( 1 + random() * (1 + skill) )); // Throw gib quantity based on skill level
		self.origin = self.oldorigin; // Restore origin for rest of grenade impact
		self.noise = "ad171/nour/explode2.wav";
	} else if (!self.dmg) self.dmg = DAMAGE_PLAYGRENADE;
 
	if (self.dmg > 0) T_RadiusDamage (self, self.owner, self.dmg, world, DAMAGEALL);

	// BLAST BELT:  Resistance = 100% for splashdamage, 50% for direct.
	if (self.activate.flags & FL_CLIENT && self.activate.takedamage == DAMAGE_AIM
		&& self.activate.moditems & IT_ARTBLASTBELT ) {
		PlayBlastBeltSound(other); // Play impact sound
		if (self.dmg > 0 && self.activate.health > 0)  T_Damage (self.activate, self, self.owner, self.dmg*ART_BLASTBELT_DD, DAMARMOR); // Any direct damage is reduced
	}

	if (self.activate.resist_rockets > 0) {
		Resist_Effects(self.activate,self.origin,VEC_ORIGIN,0,AM_ROCKETS,self.activate.pain_sound,SOUND_RESIST_ROCKET); // Show Rocket resistance with puffs of smoke
	} else {
		if (self.poisonous == TRUE) { self.height = EXPLODE_POISON_MED; PoisonDeBuff(other); } // Check for poison debuff (using poisonous flag).  Use new poison explosion.
		if (self.think1) self.think1(); 
		else if (self.height < EXPLODE_PLASMA_SMALL) {
            Tent_Explosion(self.origin); // Default ID particle explosion for fire explosions
			SpawnExplosion(self.height, self.origin, SOUND_REXP3); // Play original explosion sound
		}	
	}
	if (!self.think1) entity_remove(self, 1); // Hide grenade, no longer needed unless using special custom explosion
};

// Re-direct all the map hacks to the new function
void() maphack_grenade = { // [FUNCTION]
	self.classtype = CT_PROJ_GLMON;
	self.classgroup = CG_PROJGRENADES;
	if (!self.height) self.height = EXPLODE_SMALL;
	Explode_Grenade();
};

// These are the usual suspects for map hacks
void() OgreGrenadeExplode = { maphack_grenade(); }; // [FUNCTION]

void() GrenadeExplode = { maphack_grenade(); }; // [FUNCTION]

void() MonsterGrenadeSound = { sound(self, CHAN_WEAPON, "ad171/weapons/gl_loadshort.wav", 0.1+random()*0.5, ATTN_LOW); }; // [FUNCTION], play generic load grenade sound.

float() MonsterGrenadeSpeed = { return SPEED_MONGRENADE + (skill * SPEED_MONGLSKILL); }; // [FUNCTION], return generic attack speed.

void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage = { // [FUNCTION]
   local entity e1, e2;
   local vector f;

   f = (p2 - p1);
   normalize (f);
   f_x = (FALSE - f_y);
   f_y = f_x;
   f_z = FALSE;
   f = (f * FL_INWATER);
   e2 = world;
   e1 = world;
   traceline(p1,p2,FALSE,self);
   if (trace_ent.takedamage && !trace_ent.wetsuit_finished) {
      particle (trace_endpos,'0 0 100',225,(damage * MOVETYPE_STEP));
      T_Damage(trace_ent,from,from,damage,DAMARMOR);
      if (self.flags & FL_CLIENT && other.flags & FL_CLIENT) trace_ent.velocity_z = (trace_ent.velocity_z + 400.000);
   }
   e1 = trace_ent;
   traceline((p1 + f),(p2 + f),FALSE,self);
   if (((trace_ent != e1 && trace_ent.takedamage) && !trace_ent.wetsuit_finished)) {
      particle(trace_endpos,'0 0 100',225,(damage * MOVETYPE_STEP));
      T_Damage(trace_ent,from,from,damage, DAMARMOR);
   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ((trace_ent != e1 && (trace_ent != e2)) && trace_ent.takedamage && !trace_ent.wetsuit_finished) {
      particle(trace_endpos,'0 0 100',225,(damage * MOVETYPE_STEP));
      T_Damage(trace_ent,from,from,damage, DAMARMOR);
   }
};

void() ProximityExplode = { // [FUNCTION]
    if (self.target != "") {
        activator = self.lastvictim;
        SUB_UseTargets();
    }
    self.owner = world;
    T_RadiusDamage(self,self,95.000,world,DAMAGEALL);
    WriteByte(MSG_BROADCAST,SVC_TEMPENTITY);
    WriteByte(MSG_BROADCAST,TE_EXPLOSION);
    WriteCoord(MSG_BROADCAST,self.origin_x);
    WriteCoord(MSG_BROADCAST,self.origin_y);
    WriteCoord(MSG_BROADCAST,self.origin_z);
    BecomeExplosion();
};

// Alternate explosion function for warheads.
void() SmallExplosion = { // [FUNCTION]
    Rocket_Explosion2(self.origin, 96, 16);
    BecomeExplosion();
};

// This causes to split into multiple small rockets, releasing its payload.
void() Mirv_Split = { // [FUNCTION]
    Mirv_Reset();
    sound(self, CHAN_WEAPON, "drake/weapons/mirv2.wav", 1, ATTN_NORM);
    self.effects = self.effects | EF_MUZZLEFLASH;
    Mirv_Payload();
    BecomeExplosion();
};

// Lets 'self' use a linked MIRV by releasing its payload.
void(float immediate) Mirv_Use = { // [FUNCTION]
    if (self.mirv1) SUB_ThinkImmediate(self.mirv1, Mirv_Split);
};

void() lightning_orb_death = { // [FUNCTION]
	local entity light;

	light = spawn();
	light.origin = self.origin;
	light.model = "progs/drake/s_fancy.spr";
	setmodel(light,light.model);
	setsize(light,VEC_ORIGIN,VEC_ORIGIN);
	light.solid = SOLID_NOT;
	light.spritestarted = FALSE;
	light.pos1 = '5 1 0'; //start frame, alpha, null
	light.idleweaponframe = 9; // endframe
	light.think = env_sprite_loop;
	light.spawnflags = light.spawnflags | SPRITE_PLAYONCE; // So it only plays sprite once.
	light.impulse = 0.05; // Fast think for sprite animation.
	light.use = SUB_Remove;
	light.nextthink = self.nextthink = time + 0.1;
	sound(light,CHAN_AUTO,"doom/bfg.wav",TRUE,ATTN_NORM); // death burst
	T_RadiusDamage(self, self.owner, 40,world,DAMAGEALL); // minor damage from exploding
	SpawnOrbLightning(self.origin,250,0.4);
	self.think = SUB_Remove;
};

void() MiniGrenadeExplode = { // [FUNCTION]
	if ( (self.owner.classname == "player") ) T_RadiusDamage (self,self.owner,90.000,world,DAMAGEALL);
	else T_RadiusDamage (self,self.owner,60.000,world,DAMAGEALL);

	WriteByte(MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST,self.origin_x);
	WriteCoord(MSG_BROADCAST,self.origin_y);
	WriteCoord(MSG_BROADCAST,self.origin_z);
	BecomeExplosion();
};

void() MultiGrenadeExplode = { // [FUNCTION]
	MiniGrenadeLaunch(FALSE);
	if (self.lefty) newmis.nextthink = time + 0.15;
	MiniGrenadeLaunch(72.000);
	if (self.lefty) newmis.nextthink = time + 0.15;
	MiniGrenadeLaunch(144.000);
	if (self.lefty) newmis.nextthink = time + 0.15;
	MiniGrenadeLaunch(216.000);
	if (self.lefty) newmis.nextthink = time + 0.15;
	MiniGrenadeLaunch(288.000);
	if (self.lefty) newmis.nextthink = time + 0.15;

    if (self.tome_finished || self.owner.tome_finished) {
        MiniGrenadeLaunch(36.000);
        if (self.lefty) newmis.nextthink = time + 0.15;
        MiniGrenadeLaunch(98.000);
        if (self.lefty) newmis.nextthink = time + 0.15;
        MiniGrenadeLaunch(252.000);
        if (self.lefty) newmis.nextthink = time + 0.15;
    }
	remove(self);
};

void() MultiRocketExplode = { // [FUNCTION]
   local float damg;

   if (self.owner.classtype == CT_MONGREMLIN) damg = 30 + random()*10;
   else damg = (60.000 + (random () * 15));

   if (other.health) T_Damage(other,self,self.owner,damg,DAMARMOR);
   T_RadiusDamage(self,self.owner,75.000,other,DAMAGEALL);
   self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion();
};

void(float burstcharge) beam_water_burst = { // [FUNCTION]
	local entity current;
	local float totaldmg;
	local vector destvec;

	current = world;

	sound(self, CHAN_WEAPON, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
	do {
		current = nextent(current);
		if (current.takedamage) {
			destvec = current.origin;
			traceline(self.origin, destvec, TRUE, self);
			if (trace_fraction == 1 && current.waterlevel > 0) {
				totaldmg = vlen(self.origin - destvec) * 0.3;
				totaldmg = burstcharge * burstcharge / totaldmg;
				// check to see if the thing gets killed
				if (current.health <= totaldmg) {
					T_Damage (current, self, self, 99999,DAMARMOR);
					if (other.health <= 0) {
						MakeBeamRing(other.origin);
                        Tent_Point(TE_TAREXPLOSION,other.origin);
					}
				} else T_Damage (current, self, self, totaldmg,DAMARMOR);
			}
		}
	} while(current);
};

void() WeldExplode1 = [0, WeldExplode2] {}; // [FUNCTION]
void() WeldExplode2 = [3, WeldExplode3] {}; // [FUNCTION]
void() WeldExplode3 = [4, SUB_Remove] {}; // [FUNCTION]

// Magic arrow explosion code.
void() AkArrow_Explode = { // [FUNCTION]
    self.count = self.count & 3;
    sound(self, CHAN_AUTO, "hexen2/weapons/explode.wav", 1, ATTN_NORM);
    Colored_Explosion (self.origin, self.count);
    BecomeFancy (X80_SPARK_ORANGE + (self.count * 6), 6);
};

void() RyuPlasma_Explode = { // [FUNCTION]
    local float dmg1, dmg2;

    if (!self.dmg) self.dmg = 100;
    if (!self.distance) self.distance = 320;
    if (!self.count) self.count = 5;

    if (self.enemy) {
        dmg1 = (0.8 + random()*0.2) * self.dmg;
        dmg2 = self.dmg * 0.5; // PM:  Add discharge damage to impact damage, then ignore other in the discharge call.
		self.classgroup = CG_PROJROCKETS; // Saves a hit in the discharge for someone else.
        T_Damage(self.enemy,self,self.owner,dmg1,DAMARMOR);
		self.classgroup = CG_PROJPLASMAROGUE;
		T_Damage(self.enemy,self,self.owner,dmg2,DAMARMOR);
    }
    T_RadiusDamage(self,self.owner,self.dmg*0.7,self.enemy,DAMAGEALL); // Don't do radius damage to the other, because all the damage was done in the impact.
    sound(self, CHAN_AUTO, "rogue/plasma/explode.wav", 1, ATTN_NORM);
    setorigin(self, self.origin - 8*normalize(self.velocity)); // PM:  Do it right.
    Tent_Explosion2 (self.origin, 244, 3);
    RyuPlasma_Discharge();
    BecomeAnyExplosion (138, 6, "progs/drake/s_fancy.spr");
};

// Iceballs used by white wyrm.
// Iceball explosion effects, called by Touch_Missile.
void() Iceball_Explode = { // [FUNCTION]
    sound(self, CHAN_AUTO,"drake/weapons/shatter.wav",1,ATTN_NORM);
    Tent_Explosion2(self.origin,32,16);
    ShockWave(self.origin,RING_ICE,3,"progs/drake/s_wave.spr",FALSE);
    BecomeIcyExp();
};

void() mine1 = [ 1, mine2    ] {}; // [FUNCTION]
void() mine2 = [ 2, mine3    ] { // [FUNCTION]
    local float pc;

    pc = pointcontents(self.origin);
    if (pc == CONTENT_LAVA) { IceMine_Explode(); return;}

    if (self.delay > time) self.think = mine2;
    if (self.flags & FL_ONGROUND) return;     // Attached to the ground.

	// Float check.  Ice is less dense than water.
    if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME)) {
		// Float to the surface;
        self.movetype = MOVETYPE_FLY;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
        self.velocity_z = self.velocity_z + 48;
        if (self.velocity_z > 48) self.velocity_z = 48;
    } else self.movetype = MOVETYPE_TOSS;
};
void() mine3 = [ 3, SUB_Null ] { IceMine_Explode(); }; // [FUNCTION]

void() IceMine_Explode = { // [FUNCTION]
    if (self.trigger_field) { remove (self.trigger_field);  self.trigger_field = world;}
    self.touch = SUB_Null;      // Stack overflow prevention.
	T_RadiusDamage (self, self, self.dmg, world, DAMAGEALL); // Explosive damage and sound+fx
	particle_explode(self.origin, 50+random()*50, 1, self.part_style, PARTICLE_BURST_CENTER); // Particle explosion drifting upward
	particle (self.origin, '0 0 0', 0, 255); // Special type (hard-coded) of particle explosion that only works if particle count=255 :)
	self.origin = self.origin + '0 0 32';
	SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, self.noise);
	entity_hide(self);
};

// Treat destroyed mines as barrels.
void() IceMine_Die = { // [FUNCTION]
    if (self.trigger_field) { remove (self.trigger_field);  self.trigger_field = world;}
    self.th_die= SUB_Null;      // Don't 'die' again if damaged more.
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.solid = SOLID_NOT;
    self.nextthink = 0.01;
    self.think = IceMine_Explode;
};

// Was named 'Knightball_Explode'.
void() Orange_Explosion = { // [FUNCTION]
    local float r;

	T_RadiusDamage(self, self, self.dmg, world, DAMAGEALL); // Explosive damage and sound+fx
	particle_explode(self.origin, 50+random()*50, 1, self.part_style, PARTICLE_BURST_UPWARD); // Particle explosion drifting upward
	particle (self.origin, '0 0 0', 0, 255); // Special type (hard-coded) of particle explosion that only works if particle count=255 :)
    r = random() * 3;
    if (r < 1)
        Rocket_Explosion2 (self.origin, 224, 16);
    else if (r < 2)
        Rocket_Explosion2 (self.origin, 230, 8);
    else
        Rocket_Explosion2 (self.origin, 232, 8);

    BecomeExplosion();
};

// Custom particle explosion for plasma shots.
// Warning:  Calls particle function more times than healthy.  44 particle() calls!
void(vector spot, vector x1, vector x2) Particle_Explosion = { // [FUNCTION]
	local float sped, rgb, den;

	// Vertices of a rhombic triacontahedron (d30).
	sped = x1_x;
	rgb = x1_y;
	den = x1_z;
    particle (spot, '0 0 1' * sped, rgb, den);
    particle (spot, '.5076 .3688 .7787' * sped, rgb, den);
    particle (spot, '-.1939 .5967 .7787' * sped, rgb, den);
    particle (spot, '-.6274 0 .7787' * sped, rgb, den);
    particle (spot, '-.1939 -.5967 .7787' * sped, rgb, den);
    particle (spot, '.5076 -.3688 .7787' * sped, rgb, den);
    particle (spot, '.7905 .5743 .2128' * sped, rgb, den);
    particle (spot, '-.3019 .9293 .2128' * sped, rgb, den);
    particle (spot, '-.9771 0 .2128' * sped, rgb, den);
    particle (spot, '-.3019 -.9293 .2128' * sped, rgb, den);
    particle (spot, '.7905 -.5743 .2128' * sped, rgb, den);
    particle (spot, '.7236 .5257 -.4473' * sped, rgb, den);
    particle (spot, '-.2763 .8507 -.4473' * sped, rgb, den);
    particle (spot, '-.8944 0 -.4473' * sped, rgb, den);
    particle (spot, '-.2763 -.8507 -.4473' * sped, rgb, den);
    particle (spot, '.7236 -.5257 -.4473' * sped, rgb, den);
    particle (spot, '.8944 0 .4473' * sped, rgb, den);
    particle (spot, '.2763 .8507 .4473' * sped, rgb, den);
    particle (spot, '-.7236 .5257 .4473' * sped, rgb, den);
    particle (spot, '-.7236 -.5257 .4473' * sped, rgb, den);
    particle (spot, '.2763 -.8507 .4473' * sped, rgb, den);
    particle (spot, '.9771 0 -.2128' * sped, rgb, den);
    particle (spot, '.3019 .9293 -.2128' * sped, rgb, den);
    particle (spot, '-.7905 .5743 -.2128' * sped, rgb, den);
    particle (spot, '-.7905 -.5743 -.2128' * sped, rgb, den);
    particle (spot, '.3019 -.9293 -.2128' * sped, rgb, den);
    particle (spot, '.6274 0 -.7787' * sped, rgb, den);
    particle (spot, '.1939 .5967 -.7787' * sped, rgb, den);
    particle (spot, '-.5076 .3688 -.7787' * sped, rgb, den);
    particle (spot, '-.5076 -.3688 -.7787' * sped, rgb, den);
    particle (spot, '.1939 -.5967 -.7787' * sped, rgb, den);
    particle (spot, '0 0 -1' * sped, rgb, den);

	// Vertices of an icosahedron (d20).
	sped = x2_x;
	rgb = x2_y;
	den = x2_z;
	// Golden ratio = (1 + sqrt(5)) / 2.  (1:1.618)
    particle (spot, '0 .5257 .8507' * sped, rgb, den);
    particle (spot, '0 -.5257 .8507' * sped, rgb, den);
    particle (spot, '0 -.5257 -.8507' * sped, rgb, den);
    particle (spot, '0 .5257 -.8507' * sped, rgb, den);
    particle (spot, '.5257 .8507 0' * sped, rgb, den);
    particle (spot, '-.5257 .8507 0' * sped, rgb, den);
    particle (spot, '-.5257 -.8507 0' * sped, rgb, den);
    particle (spot, '.5257 -.8507 0' * sped, rgb, den);
    particle (spot, '.8507 0 .5257' * sped, rgb, den);
    particle (spot, '.8507 0 -.5257' * sped, rgb, den);
    particle (spot, '-.8507 0 -.5257' * sped, rgb, den);
    particle (spot, '-.8507 0 .5257' * sped, rgb, den);
};

// Spawns particles within an ent.  Bounds are the entity's hull boundaries.
void(entity ent, float color1, float color2) Particle_Cube = { // [FUNCTION]
    local vector spot;
    local float loop;

    loop = 11;
    while (loop > 0) {
        loop = loop - 1;
        spot_x = random();  spot_y = random();  spot_z = loop / 10;
        spot = Anypoint (ent, spot);
        if (random() < 0.25) particle (spot, '0 0 0', color2, 5);
        else particle (spot, '0 0 0', color1, 5);
    }
};

void() Plasma_Fx = { // [FUNCTION]
    if (random() < 0.5) sound(self, CHAN_AUTO, "drake/weapons/zap1.wav", 1, ATTN_NORM);
    else sound(self, CHAN_AUTO, "drake/weapons/zap2.wav", 1, ATTN_NORM);

	self.effects = EF_MUZZLEFLASH;
	Particle_Explosion (self.origin, '6 9 2', '10 41 3');
    BecomeFancy (X32_PLASMA_BLUE, 6);
};

// Remove a thrown hammer.
// *** Always call this to remove a hammer! ***
void() Thor_Remove = { // [FUNCTION]
    local entity thor;

    thor = self.master;
    if (thor) {
        thor.hammer_finished = 0;
        if (thor.items2 & IT2_MJOLNIR) { // Confirm ownership of hammer.
            sound(thor, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
            if (thor.flags & FL_CLIENT) { // So far, only clients use ammo.
                if (self.ammo_cells) thor.ammo_cells = thor.ammo_cells + self.ammo_cells; // Recover all unused cells.

				// if (thor.war & WARx_USES_CELLS) SUB_ThinkImmediate (thor, War_UpdateCurrentAmmo);
				W_SetCurrentAmmo (thor);
				if (!thor.selfweaponismoditems && thor.weapon == IT2_MJOLNIR) { // Hammer selected, so restore weapon model and ammo.
					if (thor.attack_finished < time + 0.2) thor.attack_finished = time + 0.2; // Delay next attack a bit so player doesn't throw immediately.
					if (cutscene) thor = find (world, classname, "dummy"); // If TRUE, update dummy, not camera.
					if (thor.tome_finished) thor.weaponmodel = "progs/violentrumble/v_hammerpw.mdl";
                    else thor.weaponmodel = "progs/violentrumble/v_hammer.mdl";
				}
            }
        }
    }
    remove (self);
};

// Removes hammer by teleporting back to master.  Any cells the hammer had are lost.
void() Thor_Poof = { // [FUNCTION]
    self.ammo_cells = 0;
    spawn_tfog (self.origin);
    Thor_Remove();
};

void(float lo, float hi) Thor_Slam = { // [FUNCTION]
    local entity base, lite;
    local float loop;
    local vector ang, spot; // PM: New.

    spot = trace_endpos;
	ang = vectoangles (trace_plane_normal);
    ang_x = anglemod (ang_x - 90);
    ang_y = self.angles_y;

	// spawn lightning base
    base = spawn();
    base.origin    = trace_endpos;
    base.flags     = 0;
    base.owner     = self;
    base.struck_by_mjolnir = 1;
    base.think     = SUB_Remove;
    base.nextthink = time + 1;
    sound(base, CHAN_AUTO, "hipnotic/weapons/mjolslap.wav", 1, ATTN_NORM);
    sound(base, CHAN_WEAPON, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
    if (self.flags & FL_CLIENT)
        makevectors(self.v_angle);
    else
        makevectors(self.angles);

    base.movedir = v_forward;
    loop = 4;
    while (loop > 0) { // spawn actual lightning
        lite = spawn();
        lite.delay     = time + 0.8;
        lite.state     = 0;
        lite.owner     = self;      // Was base.
        lite.distance  = 350;
        lite.v_angle   = ang;       // Was '0 0 0';
        lite.origin    = base.origin;
        lite.style = TRUE; // nofriendlyfire
        lite.distance = 320; // radius
        lite.count = 2; // maxhits
        lite.think     = Thor_Pulse;
        lite.nextthink = time;
        lite.ryuflags  = RYU_ALERT; // PM:  Allow sight across contents.
        lite.waitmin   = lo;    //30; PM:  Damage set here.
        lite.waitmax   = hi;    //80;

		// Yes, I know it may be faster to define these once at the
		// lightning base than multiple times, once on each bolt.
		// However, I wanted to eliminate any reference to the
		// lightning base when the bolts think.  Now, the base is
		// just there as a sound source.
        lite.dest      = base.origin;
        lite.movedir   = base.movedir;
        loop = loop - 1;
    }

    ShockWave(base.origin + '0 0 4', RING_BLUE, 6, "progs/drake/s_wave.spr",FALSE);
    Hammer_Block(lite, 100); // Added on 12/23/09.
};

void(entity who, vector spot) StaticFx = { // [FUNCTION]
    local float zap;

    zap = random() * 2; // For sounds.  Was 3.
    who.effects = who.effects | EF_MUZZLEFLASH;
    if (zap < 1) sound(who, CHAN_AUTO, "drake/weapons/zap1.wav", 1, ATTN_NORM);
    else sound(who, CHAN_AUTO, "drake/weapons/zap2.wav", 1, ATTN_NORM);

    MakeFancy (spot, X32_STAR_BLUE, 5);
};

// Reduce current health of enemies around the inflictor by 25%.  Assumes self to be the attacker and ignore entity.
void(entity inflictor, float radius) StaticField = { // [FUNCTION]
    local entity head;
    local vector p1, p2;

	// Damage flags:
	// Lightning - Static Field was a lightning skill in Diablo 2.
	// Percent   - Remove health by % instead of flat number, like in Diablo 2.
	// Note, no armor is a possibility -- could go either way.
    p1 = inflictor.origin;
    head = findradius(p1, radius);
    while (head) {
        if (head != self)
        if (head.takedamage)
        if (head.flags & FLx_CREATURE)  // Don't zap objects.
        if (head.health > 0)
        if (head.solid > SOLID_NOT)     // So DarkPlaces won't gib the fallen.
        if (Align_Opposing(head, self)) { // Zap only enemies.
            if (CanDamage (head, inflictor)) {
                p2 = Midpoint (head);
                p2 = p2 - 8*normalize(p2 - p1);
                StaticFx (head, p2);
                T_Damage(head, inflictor, self, 25, NOARMOR);
            }
        }
        head = head.chain;
    }
};

// Flame animation on modified 'flame2.mdl'.
void() m_ember1 = [ 3, m_ember2   ] { Ember_Think(); }; // [FUNCTION]
void() m_ember2 = [ 4, m_ember3   ] { Ember_Think(); }; // [FUNCTION]
void() m_ember3 = [ 5, m_ember4   ] { Ember_Think(); }; // [FUNCTION]
void() m_ember4 = [ 6, m_ember5   ] { Ember_Think(); }; // [FUNCTION]
void() m_ember5 = [ 7, m_ember6   ] { Ember_Think(); }; // [FUNCTION]
void() m_ember6 = [ 8, m_ember6 ]   { // [FUNCTION]
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

// This makes flaming embers rise from the burning victim 'ent'.
void(entity ent) MakeFlame = { // [FUNCTION]
    local entity fire;       // The new fire that will be created.
    local vector spot;       // The spot where the new fire will appear.
    local float r;

    spot   = ent.size * 0.5;
    spot_x = spot_x * (random() - 0.5);
    spot_y = spot_y * (random() - 0.5);
    spot_z = spot_z * (random() - 0.5);
    spot   = spot + Midpoint (ent);
    fire = spawn();
    fire.frame      = 28;
    fire.solid      = SOLID_NOT;
    fire.takedamage = DAMAGE_NO;
    fire.movetype   = MOVETYPE_FLY;
    fire.velocity   = '0 0 100';
    fire.owner      = ent;
    setall(fire, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', spot);
    r = random() * 3;
    if (r > 2) SUB_ThinkImmediate(fire, m_ember3); // Animate the flame.
    else if (r > 1) SUB_ThinkImmediate(fire, m_ember2);
    else SUB_ThinkImmediate(fire, m_ember1);
};

// Thinking for the delayed damage entity spawned by BecomeBigBang.
void() DelayedFireDamage_Think = { // [FUNCTION]
    T_RadiusDamage(self, self.owner, self.dmg, world, DAMAGEALL);
    self.count = self.count - 1;
    if (self.count > 0) self.nextthink = time + 0.2;
    else remove(self);
};

// Spawn a separate entity for delayed damage so that I don't need to clog the generic explosion code or write yet another special explosion scene.
void(entity attacker, vector spot, float damage) DelayedFireDamage_Spawn = { // [FUNCTION]
    local float attn;

    if (!damage) damage = 60; // High enough damage near big fireball sprite.
    attn = damage / 100;
    if (attn > 0.5) attn = 0.5;
    newmis          = spawn();
	newmis.classgroup = CG_PROJFIRE;
    newmis.owner    = attacker;
    newmis.classname= "fire";
    newmis.movetype = MOVETYPE_NONE;
    newmis.velocity = '0 0 0';
    newmis.touch    = SUB_Null;
    newmis.solid    = SOLID_NOT;
    newmis.count    = 3;
    newmis.dmg      = damage;
    newmis.distance = 100; // radius
    newmis.volume   = attn;
    newmis.nextthink= time + 0.1;
    newmis.think    = DelayedFireDamage_Think;
    setall(newmis, "", '0 0 0', '0 0 0', spot);
};

void() BecomeBigBangExplosion = { // [FUNCTION]
    if (coop || deathmatch) Ember_Shower (5);   // Make fewer embers in netgames.
    else Ember_Shower (10); // Make a small flame cloud to make explosion look bigger.

	R_Exp3(self.origin);
	Tent_Explosion(self.origin);
    FlameWave();
    BecomeTheBigFire();    // Was BecomeExplosion.
};

// This creates a bigger fiery explosion like the one in the game Blood.
void() BecomeBigBang = { // [FUNCTION]
    DelayedFireDamage_Spawn(self.master,self.origin,self.dmg / 3); // Delayed damage effects.
    Quake_Spawn(self.master,self.dmg + 60,5,self.origin,FALSE,0.8,VEC_QUAKE); // Note:  A 0.8 sec quake pings for damage three times.
    BecomeBigBangExplosion(); // The rest of the explosion effect.
};

// Spawns a huge fiery explosion at a point.  'dmg1' = Explosion damage.  'dmg2' = Secondary fire damage.  Pings multiple times.  Assumes attacker to be self.
void() BaronFireworks = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup = CG_PROJFIRE;
    newmis.owner = self;
    newmis.movetype = MOVETYPE_NONE;
    newmis.solid = SOLID_NOT;
    newmis.classname = "fire";
    setorigin(newmis, self.dest);
    T_RadiusDamage(newmis,self,90,world,DAMAGEALL);
    sound(newmis,CHAN_AUTO,"zerstorer/trog/bigboom.wav",1,ATTN_NORM);
    DelayedFireDamage_Spawn(self,self.dest,60);
    Quake_Spawn(self,150,5,newmis.origin,TRUE,0.8,VEC_QUAKE);
    SUB_ThinkImmediate(newmis,BecomeBigBangExplosion);
};

// Throws a shower of embers from 'self'.
void(float ents) Ember_Shower = { // [FUNCTION]
    local entity fire;
    local vector dir;
    local float loop;

    loop = ents * 6;
    while (loop > 0) {
        dir_x = (random() - 0.5) * 180;
        dir_y = random() * 360;
        dir_z = 0;
        makevectors(dir);
        dir = v_forward; // Get initial direction.
        traceline (self.origin, self.origin + dir*64, FALSE, other);
        if (trace_fraction == 1) { // Ember will not impact the wall immediately.
            fire = spawn();
            fire.frame      = 3;
            fire.think      = m_ember1;
            fire.solid      = SOLID_BBOX;
            fire.movetype   = MOVETYPE_TOSS;
            fire.owner      = other;
            fire.velocity   = dir * (200 + random() * 800);
            fire.angles     = vectoangles(dir) + '90 0 0';
            fire.delay      = time + 0.5 + random();    // Time when it fades.
            fire.touch      = SUB_Remove;
            fire.nextthink  = time + 0.1;
            setall(fire, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', self.origin);
            ents = ents - 1;
            if (ents <= 0) return;
        }
        loop = loop - 1;
    }
};

// This creates an entity that produces smoke and a few embers around a given target 'ent'.  Used on targets that die from burning.
void(entity ent) Smokey = { // [FUNCTION]
    newmis = spawn();
    newmis.solid      = SOLID_NOT;
    newmis.takedamage = DAMAGE_NO;
    newmis.enemy      = ent;
    newmis.wait       = time + 1 + random() * 2;
    newmis.nextthink  = 0.01;
    newmis.think      = Smokey_Think;
    setall(newmis, "", '0 0 0', '0 0 0', VEC_ORIGIN);
};

//  This creates steam that has the same velocity of the fireball that spawned it.
void(entity fire) Fireball_Steam = { // [FUNCTION]
    local float sped;
    local vector vel;

    sped = vlen (fire.velocity) * 0.01;
    vel = normalize (fire.velocity) * sped;
    sound(fire, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM);
    particle (fire.origin, vel, 1, 50);
};

//  This fizzles then removes the meteor.
void(entity fire) Meteor_Fizzle = { // [FUNCTION]
    local float pc;

    pc = pointcontents (fire.origin);
    if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME)) Fireball_Steam (fire);
    remove (fire);
};

//  The fireball explodes then creates a small cloud of fire.
void() Meteor_Explode = { // [FUNCTION]
    local float damage;

	self.classgroup = CG_PROJFIRE; // So anything in radius is set on fire.
    T_RadiusDamage(self, self.master, self.dmg, self.enemy, DAMAGEALL); // Do splash damage first then explode.
	self.classgroup = CG_PROJROCKETS; // So that subsequent damage is halved for shamblers if direct hit.
    self.origin = self.origin - 8*normalize(self.velocity);
    if (self.enemy.takedamage) { // Someone took a direct hit.
        Burn_Add(other, self.master, self.dmg); // Always ignite if burn is enabled.
        damage = SUB_RandomDamage (self.dmg);
        T_Damage(self.enemy, self, self.master, damage, DAMARMOR);
    } else FloorFire_SpawnCheck (self, 1);

    // Make a fiery explosion.
    if (self.dmg >= 80) {
        R_Exp3(self.origin);
		Tent_Explosion(self.origin);
    } else Rocket_Explosion2(self.origin, 96, 16);
    BecomeExplosion2();
};

void() frame_BLADE = [0, frame_BLADE] {}; // [FUNCTION]

// Flares are spawned from explosions caused by the zapper when fired at maximum power.
void() FlareGlitter = { // [FUNCTION]
    local   vector  ang;

    ang_x = random() * 90;      // Aim downward.
    if (self.flags & FL_ONGROUND) ang_x = 0 - ang_x;
    ang_y = random() * 360;
    ang_z = 0;
    makevectors(ang);
    newmis = spawn();
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_NOT;        // Was SOLID_TRIGGER;
    newmis.velocity     = v_forward * 150;
    newmis.gravity      = 0.5;      // Don't fall as quickly.
    newmis.classname    = "glitter";
    newmis.frame        = 70;
    if (self.flags & FL_ONGROUND) newmis.nextthink = time + 0.1;
    else newmis.nextthink = time + 0.2;
    newmis.think = FlareGlitter_Think;
    setall(newmis, "progs/drake/s_spark.spr", VEC_ORIGIN, VEC_ORIGIN, self.origin);
};

// Spawns an invisible spark generator.  Because we want the explosion
// sprite visible without extra stuff in the way, the generator isn't
// active until a few frames later, when the explosion is almost over.
void(vector start) Flare_Spawn = { // [FUNCTION]
    newmis = spawn(); 
    newmis.owner = world; // Effect is harmless, so owner can be anyone.
    newmis.movetype     = MOVETYPE_FLY;
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "flare";
    newmis.nextthink    = time + 0.4; // set newmis duration
    newmis.think        = Flare_Activate;
    setall(newmis,"progs/null.spr",VEC_ORIGIN,VEC_ORIGIN,start); //was null_256.spr
};

// Final function to decrease counters and remove entity
void(entity targ) HazardProjectile_Finished = {
	// Does the source exist?
	if (targ.proj_source != world) {
		// Update counters on source entity
		if (targ.proj_source.proj_count > 0) targ.proj_source.proj_count = targ.proj_source.proj_count - 1;
	}
	targ.proj_source = world; // Only do this once

	// Puff of smoke
	if (targ.part_exitpuff) SpawnExplosion(EXPLODE_BURST_SMOKE, targ.origin+targ.view_ofs, "");
	
	// Stop any ambient sounds
	if (targ.part_exitsound) {
		StopSound(targ,CHAN_WEAPON);
		StopSound(targ,CHAN_VOICE);
		StopSound(targ,CHAN_ITEM);
		StopSound(targ,CHAN_BODY);
	}

	// Fade entity?
	if (targ.part_exitfade) {
		entity_stop(targ); // Stop world interaction
		targ.nextthink = time + 0.02;
		targ.think = model_fade;
	} else entity_remove(targ, 0.1); // Remove entity
};

void() HazardProjectile_Exit = { HazardProjectile_Finished(self); };

// Remove egg and throw gibs up as minion grows
void() Explode_Egg = {
	setmodel(self, "");
	if (self.classgroup == CT_MONWRAITH) self.gib1mdl = MODEL_PROJ_WSHELL; 
	else if (self.classgroup == CT_MONSHAL) self.gib1mdl = MODEL_PROJ_SSHELL; 
	self.gib1frame = 9;
	self.max_health = MON_GIBFOUNTAIN;
	ThrowGib(11,rint(2+random()*4));
	self.think = SUB_Remove; // Safely remove egg
	self.nextthink = time + 0.1;
};

// Once the egg has landed via Grenade Touch function.  The minion is spawned and the egg is set to explode
void() Hatch_Egg = {
	if (self.state == STATE_DISABLED) return; // Block this functions
	if (self.touchedvoid) return; // Has the egg been marked for removal?

	if (!self.gibbed) {
		self.gibbed = TRUE; // only set once, float reuse! nothing to do with gibbing
		self.attack_finished = time + 6; // It's possible for the egg to get stuck, setup death timer
	}
	if (self.attack_finished < time) {
		self.state = STATE_DISABLED;
		self.think = Explode_Egg; // Egg has been stuck for too long, destroy it
		self.nextthink = time + 0.1;
		return;
	}
	// Turn off touch function and any movement
	self.touch = SUB_Null;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.velocity = '0 0 0';
	
	// Check if the egg can hatch? turn on collision, setup new bounds and extend upwards for testing
	setsize (self, VEC_HULLT_MIN, VEC_HULLT_MAX);
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_TOSS;
	self.oldorigin = self.origin;
	self.origin_z = self.origin_z + 8;
	droptofloor();
	
	if (!walkmove(0,0) || pointcontents(self.origin) == CONTENT_SOLID) { // Can the egg hatch yet? Solid content?
		self.origin = self.oldorigin;
		self.think = Hatch_Egg;
		self.nextthink = time + 1 + random();
		self.solid = SOLID_NOT;		// turn off again
		return;
	}
	self.state = STATE_DISABLED; // Setup egg ready for minion
	traceline (self.origin+'0 0 128', self.origin-'0 0 256', TRUE, world);
	self.oldorigin = trace_endpos + '0 0 32'; // Setup spawn location for minion
	// Spawn minion inside of egg model.  self.owner is re-assigned to minion to avoid shell gibs interacting
	if (self.owner.classtype == CT_MONWRAITH) {
		if (self.owner.spawnflags & MON_WRAITH_SCORPIONS) minion_scorpion(self.oldorigin, self.enemy);
		else minion_spider(self.oldorigin, self.enemy);
	} else if (self.owner.classtype == CT_MONSHAL || self.owner.classtype == CT_MONSHALBOSS) {
		if (self.owner.classtype == CT_MONSHALBOSS) {
			sound(self, CHAN_WEAPON, "ad171/wraith/attack3.wav", 1, ATTN_NORM);
			minion_voreling(self.oldorigin+'0 0 4', self.enemy);
		} else {
			minion_voreling(self.oldorigin, self.enemy);
		}
	}
	self.think = Explode_Egg; 
	self.nextthink = time + 0.4; // Skip a couple of frames
};

// The Airfist fire blast sprite animation code.
void() run_ablast1   = [0, run_ablast2  ] {};
void() run_ablast2   = [1, run_ablast3  ] {};
void() run_ablast3   = [2, run_ablast4  ] {};
void() run_ablast4   = [3, run_ablast5  ] {};
void() run_ablast5   = [4, run_ablast5  ] { remove(self); };

// Airfist fire blast sprite animation under water (slowed down).
void() run_ablastWater1   = [0, run_ablastWater2  ] {};
void() run_ablastWater2   = [0, run_ablastWater3  ] {};
void() run_ablastWater3   = [1, run_ablastWater4  ] {};
void() run_ablastWater4   = [1, run_ablastWater5  ] {};
void() run_ablastWater5   = [2, run_ablastWater6  ] {};
void() run_ablastWater6   = [2, run_ablastWater7  ] {};
void() run_ablastWater7   = [3, run_ablastWater8  ] {};
void() run_ablastWater8   = [3, run_ablastWater9  ] {};
void() run_ablastWater9   = [4, run_ablastWater10 ] {};
void() run_ablastWater10  = [4, run_ablastWater1  ] { remove(self); };

// Create a Airfist blast sprite
void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite = {
	local entity sprite, oldself;

	sprite = spawn(); // Create the blast sprite and sets the variables.
	sprite.solid = SOLID_NOT;
	if (oldself.waterlevel > 2) { // below the water, play under water animation
		sprite.movetype = MOVETYPE_NOCLIP;
	} else { // above water, play normal animation
		sprite.movetype = MOVETYPE_BOUNCE;
	}
	setmodel(sprite, "progs/airfist/s_ablast.spr");
	sprite.velocity = (v_forward * random() * adjustForward) + (v_right * random() * adjustRight) + (v_up * random() * adjustUp); // Set the velocity based on the parameters passed. [MWH:01/12/97] Reduced left/right/up/down variablilty
	sprite.velocity = sprite.velocity * spriteSpeed; // Set speed

	if (nearAWall)	setorigin(sprite, self.origin + self.view_ofs + (v_right * positionRight)); // If near a wall, blast in face.  [MWH:01/12/97] raised origin a bit
	else			setorigin(sprite, self.origin + self.view_ofs + (v_forward * 30) + (v_right * positionRight)); // Not near a wall, so set start position in front of the player.  [MWH:01/12/97] raised origin a bit

	setsize(sprite, '-8 -8 -8', '8 8 8');
	oldself = self;
	self = sprite; // play sprite animation.
	if (oldself.waterlevel > 2) { // below the water, play under water animation
		run_ablastWater1();
	} else { // above water, play normal animation
		run_ablast1();
	}
	self = oldself;
};

void() death_puff = { // [FUNCTION]
    local vector spot;
    local entity puff;

    spot_x = random();
    spot_y = random();
    spot_z = random() * 0.5;
    spot = Anypoint(self,spot);
    puff = spawn();
    setorigin(puff, spot);
    puff.effects = EF_MUZZLEFLASH;
    sound(puff,CHAN_AUTO,"hknight/hit.wav",1,ATTN_NORM);
    SUB_ThinkImmediate(puff,BecomeExplosion);
};

void(vector spot, float base, float add, string text, float toponly) ShockWave = { // [FUNCTION]
    local entity wav1, wav2, ts;
    local vector ang;

	// NOTE:  Don't use world in the 4th (ignore) parm or else the traceline
	// will pass through any non-world bsp entites, such as shootable
	// trap doors.  Use self instead, which should be an inflictor entity.
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction >= 1.0) return; // Too far from ground.
    if (!toponly && (trace_plane_normal * '0 0 1') < 0.5) return; // Ground slopes too much.  Was 0.7071.

    spot = trace_endpos + trace_plane_normal * 2;
    ang = vectoangles(trace_plane_normal);
    ang_y = anglemod(ang_y + 180);
    wav1 = spawn(); // Top side.
    wav1.angles = ang;
    setorigin(wav1, spot);
	
	if (!toponly) { // Bottom side.
		ang_x = anglemod(ang_x + 180);
		wav2 = spawn();
		wav2.angles = ang;
		setorigin(wav2, spot);
	}
	
    ts = self; // Thinking
    self = wav1;
    BecomeAnyExplosion (base, add, text);
	if (!toponly) { self = wav2; BecomeAnyExplosion (base, add, text); }
    self = ts;
};

// Used by exploding barrels and MIRVs.  Yes, add 7 instead of 8.
void() FlameWave = { ShockWave(self.origin,RING_FIRE,7,"progs/drake/s_wave.spr",FALSE); }; // [FUNCTION]