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
// Entity count: 0
// Function count: 43
//
// Implements: Projectile System for Players and Monsters
//
// Description:
// Generic functions for spawning various projectiles that cause damage.
// * Bullets (PROJECTILE)
// * Plasma
// * Nails
// * Rockets
// * Grenades
//
// PLAYER Projectile Collision (movetypes)
// ----------------------------------------
// * ID software Quake originally had most player projectiles (rockets/nails)
//   use a large collision size (MOVETYPE_FLYMISSILE) and this especially
//   helped with flying enemies (scrags) that strafe around quickly.
//
// * AD changed all the player projectile collision boxes to a smaller
//   size (MOVETYPE_FLY) to add a greater challenge to combat and this
//   is noticeable when fighting flying monsters.
//   This change was linked to the setting of the sv_aim console command,
//   which has been changed from 0.93 to 1 in most modern quake clients.
//   The sv_aim command was used to help steer projectiles into monsters
//   to ultimately make the combat easier for keyboard only players.
//
// * Projectiles move in discreet steps on the server and with a small
//   movetype they can often skip through objects. This was probably the
//   reason ID software had large collision and changing them to small
//   only makes combat more difficult and less fun.
//
// * The projectile size is now linked to a worldspawn variables which
//   defaults to 0 and will keep the original ID software default while
//   giving map makers the choice to override this option.
//
// There is also an impulse command (105) to toggle this setting and
// its reported on the mod info table on the console (developer 1)
//
// The new worldspawn variable is - no_bigprojectiles
//
// This change will affect the following ammo type/weapons:
// shells(SG/SSG/WSG), nails(NG/SNG), rockets(RL) and cells(PG).
//
// * There is a big projectile collision for grenades but ID software
//   never used it. All grenades are setup with MOVETYPE_BOUNCE
//   which is always a small collision.
//
// BULLET PROJECTILES 
// * Projectile and hitscan system supported (though old is default - Qmaster)
// * Uses original damage accumulation system
//
// MISSILE PROJECTILES
// This missile touch function is designed for monsters NOT players
// * No DIRECT damage, just radius and a lot lower (40 vs 110)
// * Half damage to shamblers (inside T_RadiusDamage)
// * Will work with homing or direct missile attacks
// * checks for breakables that can be destroyed with explosives
// * uses default explosion function 
//
// * Half damage to shamblers (Touch_Missile and T_RadiusDamage)
// * checks for breakables that can be destroyed with explosives
// * All rockets have direct & radius damage (based on projectile type)
//
// GRENADES
// * Half damage to shamblers (Touch_Missile and T_RadiusDamage)
// * checks for breakables that can be destroyed with explosives
// * Grenade damage is based on dmg key (default = player)
//=============================================================================

void(vector org, vector dir, float proj_type, float proj_speed) launch_plasma;
void(vector org, vector dir, float proj_type, float proj_speed) launch_projectile;
entity(entity attacker, vector org, vector dir, float radius, float scope) SuperRocket_Target;
void() Touch_ShellCasing;
void() MultiGrenadeTouch;
void() MultiGrenadeExplode;
void() ProximityGrenadeTouch;
void() ProximityBomb;
void() ProximityGrenadeExplode;
void() SuperGrenade_Think;
void() SuperRocket_Think;
void (vector org, vector vec, float light) HIP_LaunchLaser;
void() spark_spawn;
void(float lo, float hi) Thor_Slam;
void () MultiGrenadeTouch;

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

void() Touch_Bullet = { // [FUNCTION]
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (self.waitmin > time) return;			// bullet touch has been disabled

	entity_remove(self, 1);						// Setup bullet for removal	

	if (other.takedamage) {
		// Hit monster/interactive object, impact blood
		// Due to how difficult projectile shotguns were to hit things, an extra +4 damage (dead center tracer) was added to help AD's particle shotguns.
		// In AD 1.7+ the bullet projectiles are now using wide impact against monsters which means more pellets will hit.  The extra is no longer required.
		if (self.classtype == CT_PROJ_TRACEPART) self.dmg = 0;
		else if (self.classtype == CT_PROJ_TRACE) self.dmg = 0;
		else self.dmg = DAMAGE_PSHELL; // Default shell pellet damage
		
		// Check for breakable/pushable no monster damage
		if (ai_immunebreakable(self.owner, other)) {
			self.dmg = 0;
			Tent_Point(TE_GUNSHOT,self.origin);
		} else if (other.resist_shells > 0) Resist_Effects(other,self.origin,self.velocity,self.dmg,AM_SHELLS,other.pain_sound,""); // Show bullet resistance as small blood+gunshot+smoke
		else {
			if (other.flags & FL_MONSTER) spawn_touchblood (self, other, self.dmg*2); // Hitting monsters does twice the amount of blood effects
			else spawn_touchblood (self, other, self.dmg);
		}
		
		if (self.dmg > 0) T_Damage (other, self, self.owner, self.dmg, DAMARMOR); // Don't bother with damage if there is none!
	} else {
		// Hit world/static object, impact particles.
		if (self.classtype == CT_PROJ_TRACE || self.classtype == CT_PROJ_MCOR2) { // NG tink sound or SG ricochet sound.
			self.lip = random();
			if (self.lip < 0.5) sound(self, CHAN_VOICE, "weapons/tink1.wav", random()*0.5, ATTN_LOW);
			else if (self.lip < 0.7) sound(self, CHAN_VOICE, "weapons/ric2.wav", random()*0.5, ATTN_LOW);
			else sound(self, CHAN_VOICE, "weapons/ric3.wav", random()*0.5, ATTN_LOW);
		} else {
			Tent_Point(TE_GUNSHOT,self.origin);
		}
	}
};

void(vector org, vector dir, float proj_type, float proj_speed) Launch_Bullet = { // [FUNCTION]
	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "proj_bullet";	// obj name, not really used anymore
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJSHELLS;	// Ammo type
	if (self.moditems & IT_UPGRADE_SSG || self.super_damage_finished > 0) newmis.weapon = TRUE; // Horrible hack! If the player has the TSG or quad, flag it for zombies
	
	// Switch model collision based on auto aim functionality.  
	if (self.flags & FL_CLIENT) {
		if (playerprojsize) newmis.movetype = MOVETYPE_FLY;	// Small collision
		else newmis.movetype = MOVETYPE_FLYMISSILE; // Large collision
	} else newmis.movetype = MOVETYPE_FLYMISSILE; 	// Default = large collision.  Monsters always use large collision otherwise infighting would be less.
	
	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_Bullet;					// touch function
	newmis.waitmin = 0;								// Touch function active

	// Particle tracer (true aim, no damage)
	if (proj_type == CT_PROJ_TRACE || proj_type == CT_PROJ_TRACEPART) {
		newmis.delay = time + LIFE_SHELLS;			// Maximum life time
		if (self.weapon & IT_SUPER_SHOTGUN) newmis.count = 1;
		else newmis.count = 1 + rint(random()*2);	// Default particles for SG
		newmis.speed = 0.02;						// Next function interval (very high tick)
		newmis.think = Particle_Bullet;				// Particle trail
		newmis.nextthink = time + newmis.speed;
	} else { // SG/SSG shells (scatter effect)
		newmis.think = SUB_Remove;
		newmis.nextthink = time + LIFE_SHELLS;	// Stop projectile going forever
	}

	newmis.mdl = MODEL_PROJ_DIAM2;
	setmodel(newmis, newmis.mdl);				// Diamond model
	newmis.frame = random()*15;					// Full range of sizes
	newmis.skin = 16 + random()*7;				// Bright colours
	newmis.velocity = dir * proj_speed;			// Constant speed multiplier
	newmis.angles = vectoangles(dir);			// Create direction angle
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	// Zero size
	setorigin (newmis, org);					// Move to starting position
	newmis.avelocity = vecrand(100,200,FALSE);
};

void(float bullet_count, vector bullet_spread, float bullet_type) Launch_Shells = { // [FUNCTION]
	local vector src_origin, bullet_dir, spread_dir;
	local float bullet_speed, var_speed;

	if (self.flags & FL_CLIENT) { // Is the player firing the shotgun?
		makevectors(self.v_angle);
		src_origin = self.origin + attack_vector('10 0 8'); // Infront of player model and down towards gun
		if (bullet_type == CT_PROJ_SG) bullet_speed = SPEED_PLAYERSG;
		else bullet_speed = SPEED_PLAYERSSG;
		
		if (autoaim_cvar < 1) bullet_dir = aim(self, SPEED_PLAYAIM); // Either straight line or auto aim assist using builtin.
		else bullet_dir = normalize(v_forward * bullet_speed);
	} else {
		makevectors(self.angles);
		src_origin = self.origin + attack_vector(self.attack_offset); // At the end of the new soldier gun model
		bullet_speed = SPEED_MONSG + (skill*SPEED_MONSGMULT);
		bullet_dir = self.enemy.origin - self.enemy.velocity*0.2; // fire somewhat behind the player, so a dodging player is harder to hit
		bullet_dir = normalize (bullet_dir - self.origin);
	}

	Launch_Bullet(src_origin, bullet_dir, CT_PROJ_TRACE, bullet_speed); // Setup particle emitter/tracer shot (true aim)
	while (bullet_count > 0) {
		var_speed = crandom()*10 + bullet_speed;		// Slight speed variance
		spread_dir = bullet_dir + (crandom()*bullet_spread_x) * v_right + (crandom()*bullet_spread_y) * v_up;
		Launch_Bullet(src_origin, spread_dir, bullet_type, var_speed);
		bullet_count = bullet_count - 1;
	}
};

// PLASMA PROJECTILES 
// * requires special blue/white particle trail
// * Has radius and impact touch damage
// * used by Eliminator (enforcer), Soldier and Minotaur
void() Particle_Plasma = { // [FUNCTION]
	if (self.waitmin > time) return; // projectile has touched something
	if (self.attack_finished < time) {entity_remove(self, 0.1); return;} // Projectile has run out of time
	
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

void() Touch_PlasmaProjectile = { // [FUNCTION]
	local vector org, vec, dir;
	local entity tself;

	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (self.touchedvoid) return;				// Marked for removal
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (self.waitmin > time) return;			// plasma touch has been disabled

	if (self.owner.flags & FL_CLIENT) self.pos1 = DAMAGE_PGPLAYER; // Default damage for plasma (override on worldspawn)
	else if (self.owner.classtype == CT_MONGREMLIN) self.pos1 = DAMAGE_PGGREMLIN;
	else if (self.classtype == CT_REFLECTLIGHT) self.pos1 = DAMAGE_PGREFLECT; // Default damage for all monsters
	else if (self.classtype == CT_REFLECTPLASMA) self.pos1 = DAMAGE_PGREFLECT;
	else if (self.classtype == CT_SUMMONLIGHT) self.pos1 = DAMAGE_PGSUMMON;
	else if (self.classtype == CT_MONMINOTAUR) self.pos1 = DAMAGE_PGMINOTAUR;
	else if (self.classtype == CT_MONGAUNT) self.pos1 = DAMAGE_PGGAUNT;
	else if (self.classtype == CT_MONTURRETB) self.pos1 = DAMAGE_PGTURRETB;
	else if (self.owner.classtype == CT_MONNOUR) self.pos1 = DAMAGE_PGNOUR;
	else if (self.classtype == CT_MONFLOYD) self.pos1 = DAMAGE_PGFLOYD;
	else if (self.classtype == CT_MONDEFLECTOR) self.pos1 = DAMAGE_PGDEFLECT;
	else self.pos1 = DAMAGE_PLASMA;

	if (ai_immunebreakable(self.owner, other)) self.pos1 = '0 0 0'; // Check for breakable/pushable immunity first
	self.dmg = self.pos1_x + random()*self.pos1_y;
	if (self.pos1_z > 0) T_RadiusDamage (self, self.owner, self.pos1_z, world, DAMAGEALL); // Plasma Splashdamage affects everything, check for 0 dmg first.  This can also apply a poisonous debuff from the attacker.
	if (other.takedamage) { // Hit monster/interactive object, impact blood
		if (ai_immunebreakable(self.owner, other)) { // Check for breakable/pushable no monster damage
			SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, SOUND_PLASMA_HIT); // Using a cut down version of ammo resistance
			SpawnProjectileSmoke(self.origin, 200, 50, 150);
			if (random() < 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 250);
			if (random() < 0.5) SpawnProjectileSmoke(self.origin, 300, 50, 150);
		} else if (other.resist_cells > 0) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_CELLS,other.pain_sound,SOUND_PLASMA_HIT);
		else if (other.resist_plasma > 0) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_PLASMA,other.pain_sound,SOUND_PLASMA_HIT);
		else {
			if (other.flags & FL_MONSTER) spawn_touchblood (self, other, self.dmg*2); // Hitting monsters does twice the amount of blood effects
			else spawn_touchblood (self, other, self.dmg);

			if (self.poisonous) self.lip = EXPLODE_POISON_SMALL; // Switch poisonous to poison sprite, but keep plasma explosion,oOtherwise this sounds confusing with a rocket explosion.
			else {
				if (random() < 0.3) self.lip = EXPLODE_PLASMA_SMALL; // Randomly pick between Quoth electric and AD blue explosions.
				else self.lip = EXPLODE_ELECT_SMALL;
			}
			SpawnExplosion(self.lip, self.origin, SOUND_PLASMA_HIT);
		}

		if (other.classgroup == CG_ZOMBIE && !(other.classname == "monster_mummy")) self.dmg = DAMAGE_ZOMBIECLASS; // Plasma hits always kill any zombie (1 hit)
		if (self.dmg > 0) T_Damage (other, self, self.owner, self.dmg, DAMARMOR); // Don't bother with damage if there is none!
	} else {
		// Hit world/static object, impact particles
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION2); // New special coloured particle explosion (rogue expansion)
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		WriteByte (MSG_BROADCAST, 35);
		WriteByte (MSG_BROADCAST, 8);
		if (self.poisonous) self.lip = EXPLODE_POISON_SMALL; // Poisonous sprite explosion instead
		else self.lip = EXPLODE_ELECT_SMALL; // Classic quoth electric impact explosion
		SpawnExplosion(self.lip, self.origin, SOUND_PLASMA_HIT);
	}

	// Check for any plasma reflection? (player only function)
	if (self.owner.flags & FL_CLIENT && other.reflectplasma) {
		org = self.origin;
		if (random() < 0.2 && self.owner) dir = normalize(self.owner.origin - org); // Random chance that plasma will reflect straight back
		else {
			vec = org + vecrand(0,1000,1); // Pick random location instead
			dir = normalize(vec - org);
		}
		tself = self;
		self = other; // Switch around self to make sure reflection happens once
		launch_plasma(org, dir, CT_REFLECTPLASMA, SPEED_REFLECTION);
		self = tself;
	}
	entity_remove(self, 1); // Remove plasma bolt
};

void(vector org, vector dir, float proj_type, float proj_speed) launch_plasma = { // [FUNCTION]
	newmis = spawn ();
	newmis.owner = self;
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJCELLS;	// Ammo type
	newmis.attack_speed = proj_speed;	// Save for later
	if (self.flags & FL_CLIENT) {
		if (playerprojsize == 0) newmis.movetype = MOVETYPE_FLYMISSILE;	// Large collision
		else newmis.movetype = MOVETYPE_FLY;		// Small collision
	} else {
		newmis.movetype = MOVETYPE_FLY; // Monster get the raw deal, small projectile collision
		if (proj_type != CT_MONGAUNT && proj_type != CT_MONMINOTAUR) newmis.effects = EF_DIMLIGHT; // Minotaur, Gaunt is rapid fire, don't need glow effect (slow down)
	}

	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_PlasmaProjectile;
	newmis.attack_finished = time + LIFE_PROJECTILE;
	newmis.poisonous = newmis.owner.poisonous;
	
	// Setup model and special parameters (zombie, boss)
	if (proj_type == CT_MONARMYPLASMA) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_PLASMAGRN);
		else setmodel (newmis, MODEL_PROJ_PLASMA);
	} else if (proj_type == CT_MONELIMATOR) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_PLASMAGRN);
		else setmodel (newmis, MODEL_PROJ_PLASMA);
	} else if (proj_type == CT_MONCENTURION) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_PLASMAGRN);
		else setmodel (newmis, MODEL_PROJ_PLASMA);
	} else if (proj_type == CT_MONGAUNT) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_GAPLASMAGRN);
		else setmodel (newmis, MODEL_PROJ_GAPLASMA);
	} else if (proj_type == CT_MONDEFLECTOR) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_PLASMAGRN);
		else setmodel (newmis, MODEL_PROJ_PLASMA);
	} else if (proj_type == CT_MONEEL) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_PLASMAGRN);
		else setmodel (newmis, MODEL_PROJ_PLASMA);
	} else if (proj_type == CT_MONSEEKER) setmodel (newmis, MODEL_PROJ_PLASMA);
	else if (proj_type == CT_MONMAMMOTH) setmodel (newmis, MODEL_PROJ_PLASMA);
	else if (proj_type == CT_MONTURRETB) setmodel (newmis, MODEL_PROJ_LASERBLUE);
	else if (proj_type == CT_MONFLOYD) setmodel (newmis, MODEL_PROJ_LASERBLUE);
	else if (proj_type == CT_MONMINOTAUR) setmodel (newmis, MODEL_PROJ_MPLASMA);
	else if (proj_type == CT_SUMMONLIGHT) setmodel (newmis, MODEL_PROJ_LIGHTNING2);
	else if (proj_type == CT_MONNOUR) setmodel (newmis, MODEL_PROJ_LIGHTNING2);
	else if (proj_type == CT_REFLECTLIGHT) setmodel (newmis, MODEL_PROJ_LIGHTNING2);
	else if (proj_type == CT_REFLECTPLASMA) {
		setmodel (newmis, MODEL_PROJ_PGPLASMA);
		newmis.avelocity = vecrand(0,300,TRUE);	// randomize avel
		newmis.angles_y = rint(random()*360);	// Random angle
		newmis.frame = 3;						// Medium size
	} else {
		setmodel (newmis, MODEL_PROJ_PGPLASMA);
		newmis.speed = 0.1;	// Update model frame every 0.1s
		newmis.avelocity = vecrand(0,300,TRUE);	// randomize avel
		newmis.angles_y = rint(random()*360);	// Random angle
		newmis.frame = 0;						// Start really small
	}

	// Is DP engine active for new particle trail?
	if (ext_dppart) {
		if (newmis.poisonous) newmis.traileffectnum = particleeffectnum(DPP_TRPOISON);
		else newmis.traileffectnum = particleeffectnum(DPP_TRPLASMA);
		newmis.effects = 0;	
	}
	newmis.count = 1 + rint(random()*2);	// Default particles
	newmis.speed = 0.02;					// Next function interval (very high tick)
	newmis.think = Particle_Plasma;			// Manually generate blue/white particle trail
	newmis.nextthink = time + newmis.speed;
	newmis.velocity = dir * proj_speed; // Standard projectile setup (origin, size and velocity)
	if (!(self.flags & FL_CLIENT)) newmis.angles = vectoangles(dir);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);
};

void() Think_Projectile = { // [FUNCTION]
	if (self.attack_lifetime < time) {entity_remove(self, 0.1); return;} // Original projectile lifetime timer

	self.flags = self.flags - (self.flags & FL_ONGROUND); // Make sure onground flag is never set
	self.velocity = self.finalangle * self.attack_speed; // Keep updating velocity/angle, to prevent from stopping
	self.angles = vectoangles(self.finalangle);
	if (self.tracer_time) BDW_TracerEffect();
	self.nextthink = time + 0.1;
	self.think = Think_Projectile;
};

void() Touch_Projectile = { // [FUNCTION]
	local vector org, dir, vec;
	local float proj_type, proj_speed, old_armortype, old_armorvalue, old_armormask, olddmg;
	local entity tself, newent, stemp;
	
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner) return;			// no touching self
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.touch = SUB_Null; // No more touch/world interaction
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	if (self.classtype == CT_PROJ_LASER) { //	Laser impact/stop sound (precached by owner)
		if (self.attack_ricochet > 0) sound (self, CHAN_WEAPON, SOUND_LASER_RIC, 1, ATTN_STATIC);
		else sound (self, CHAN_WEAPON, SOUND_LASER_HIT, 1, ATTN_STATIC);
	} else if (self.classtype == CT_PROJ_GROCK) { // Golem rock impact sound (precached by owner)
		self.lip = random();
		self.volume = 0.5 + random()*0.5;
		if (self.lip < 0.25) sound (self, CHAN_WEAPON, SOUND_IMP_ROCK1, self.volume, ATTN_BREAK);
		else if (self.lip < 0.5) sound (self, CHAN_WEAPON, SOUND_IMP_ROCK2, self.volume, ATTN_BREAK);
		else if (self.lip < 0.75) sound (self, CHAN_WEAPON, SOUND_IMP_ROCK3, self.volume, ATTN_BREAK);
		else sound (self, CHAN_WEAPON, SOUND_IMP_ROCK4, self.volume, ATTN_BREAK);
	}

	if (other.takedamage) { // Hit something that bleeds
		if (self.classtype == CT_PROJ_SNG) self.dmg = DAMAGE_SNGSPIKE; // SNG spikes are essentially double damage (cheap way of 2 x nails)
		else if (self.classtype == CT_PROJ_REFNG) self.dmg = DAMAGE_NGREFSPIKE; // Reflected nails (can only happen from the player)
		else if (self.classtype == CT_PROJ_REFLNG) self.dmg = DAMAGE_LNGREFSPIKE; // Reflected lava nails (can only happen from the player)
		else if (self.owner.classtype == CT_MONJIM) self.dmg = DAMAGE_BOBLASER + (random() * DAMAGE_BOBLASER); // Bob and enforcer lasers are different
		else if (self.classtype == CT_PROJ_LASER) self.dmg = DAMAGE_LASER;
		else if (self.classtype == CT_PROJ_RICLASER && self.dmg < DAMAGE_NGSPIKE) self.dmg = DAMAGE_NGSPIKE; // Minimum damage = spike after all the bouncing around
		else if (self.classtype == CT_PROJ_LAVANG) self.dmg = DAMAGE_LAVANGSPIKE;
		else if (self.classtype == CT_PROJ_LAVASNG) self.dmg = DAMAGE_LAVASNGSPIKE;
		else if (self.classtype == CT_PROJ_MCOR1) self.dmg = DAMAGE_MANTICORESPIKE + (random() * 5);
		else if (self.classtype == CT_PROJ_MCOR2) self.dmg = DAMAGE_MANTICORETHRON + random();
		else if (self.classtype == CT_PROJ_DARTARROW) self.dmg = DAMAGE_NGSPIKE;
		else if (self.classtype == CT_PROJ_BOLT1) { // Special damage and sound effects for crossbow knights
			if (random() < 0.3) sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit1.wav", 1, ATTN_NORM); // ting sound
			else sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit4.wav", 1, ATTN_NORM); // flesh wound
			if (other.classtype == self.owner.classtype) {
				self.dmg = DAMAGE_BOLT0; // Reduce damage if hit another dcrossbow knight.
			} else {
				if (self.owner.flags & FL_CLIENT) self.dmg = DAMAGE_BOLTPLAYER;
				else self.dmg = DAMAGE_BOLT1; // Set to standard monster damage.
			}
		} else if (self.classtype == CT_PROJ_BOLT2) {
			if (random() < 0.3) sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit1.wav", 1, ATTN_NORM); // ting sound
			else sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit4.wav", 1, ATTN_NORM); // flesh wound
			if (other.classtype == self.owner.classtype) {
				self.dmg = DAMAGE_BOLT0; // Reduce the damage if the bolt has hit another dcrossbow knight
			} else {
				if (self.owner.flags & FL_CLIENT) self.dmg = DAMAGE_BOLTPLAYERP;
				else self.dmg = DAMAGE_BOLT2; // Set to standard poisonous monster damage.
			}
		} else if (self.classtype == CT_PROJ_BLBOLT || self.classtype == CT_PROJ_BLBOLT2) self.dmg = DAMAGE_BOGLORD;
		else if (self.classtype == CT_PROJ_FLESH || self.classtype == CT_PROJ_FLESHP) {
			sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM); // Zombies have special impact sound
			self.dmg = DAMAGE_FLESH;
		} else if (self.classtype == CT_PROJ_SCORP) { // Scorpion spikes cannot hurt other spider types.  This is to prevent the minion scorpion killing other minions
			if (other.classgroup == self.owner.classgroup) self.dmg = 0;
			else self.dmg = DAMAGE_NGSPIKE;
		} else if (self.classtype == CT_PROJ_GROCK) { // Rock projectiles cannot hurt stone monsters!
			if (other.classgroup == self.owner.classgroup) self.dmg = 0;
			else self.dmg = DAMAGE_NGSPIKE;
		} else self.dmg = DAMAGE_NGSPIKE; // Default spike damage (nails)

		olddmg = self.dmg;
		if (ai_immunebreakable(self.owner, other)) { // Check for breakable/pushable monster immunity
			self.dmg = self.classgroup = 0; // Zero damage and make sure no resistance checks
			self.poisonous = FALSE; // Remove poisonous effect
			Tent_Point(TE_GUNSHOT,org);
			if (random() < 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 150); // Show ammo resistance effect
		}

		if (self.poisonous == TRUE) PoisonDeBuff(other); // Check for poison debuff (using poisonous flag)

		// Check for NG/SNG nail resistance
		if (self.classgroup == CG_PROJNAILS && other.resist_nails > 0) {
			Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_NAILS,other.pain_sound,"");
			self.projeffect = 0;
			// Check for any nail reflection?
			if (other.reflectnails && random() < other.resist_nails) {
				org = self.origin;
				// Random chance that nail will reflect straight back
				if (random() < 0.2 && self.owner) 
					dir = normalize(self.owner.origin - org);
				else {
					// Pick random location instead
					// Flatten the Z axis so the reflection looks less random
					vec = vecrand(0,100,1);
					vec_z = random()*25;
					vec = vec + org;
					dir = normalize(vec - org);
				}
				// Switch around self to make sure reflection happens once
				tself = self; self = other;
				launch_projectile(org, dir, CT_PROJ_REFNG, SPEED_REFLECTION);
				self = tself;
			}
		}

		// Ignore armor for lava nails
		if (self.classtype == CT_PROJ_LAVANG || self.classtype == CT_PROJ_LAVASNG) {
			old_armortype = other.armortype;
			old_armorvalue = other.armorvalue;
			old_armormask = (other.items2 & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3));
			other.armortype = FALSE;
			other.armorvalue = FALSE;
			// Add fun fire effects 5% of the time.
			if (random() < 0.05 && other.resist_fire < 1) {
				newent = spawn();
				setorigin(newent,self.origin);
				stemp = self;
				self = newent;
				Ember_Shower(2);
				self.think      = SUB_Remove;
				self.nextthink  = time + 0.1;
				self = stemp;
				Burn_Add(other,self.owner,self.dmg);
			} else Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_LAVANAILS,other.pain_sound,"");
			self.projeffect = 0;

			if (other.resist_fire > 0) self.dmg = self.dmg * (1 - other.resist_fire); // Change damage after applying burning for maximum burn life.

			// Check for any nail reflection?
			if (other.resist_fire >= 1 || ((random() < other.resist_lava_nails) || ((random() < other.resist_nails) && other.reflectnails))) {
				org = self.origin;
				if (random() < 0.2 && self.owner) dir = normalize(self.owner.origin - org); // Random chance that nail will reflect straight back.
				else { // Pick random location instead. 
					vec = vecrand(0,100,1);
					vec_z = random()*25; // Flatten the Z axis so the reflection looks less random.
					vec = vec + org;
					dir = normalize(vec - org);
				}
				tself = self;
				self = other; // Switch around self to make sure reflection happens once.
				launch_projectile(org, dir, CT_PROJ_REFLNG, SPEED_REFLECTION);
				self = tself;
			}
		}

		// Produce blood particles at impact and apply damage to target.
		if (self.dmg > 0) {
			spawn_touchblood(self, other, self.dmg);
			T_Damage(other, self, self.owner, self.dmg, DAMARMOR);
		} else {
			if (other.flags & FL_MONSTER && olddmg && self.owner && (other.enemy != self.owner)) {
				if (!Align_Match(other,self.owner) && (!other.enemy || other.switchtimer < time) && (self.owner.health > 0)) {
					other.enemy = self.owner;
					if (other.th_run) {
						other.think = other.th_run;
						other.nextthink = time + 0.1;
					}
				}
			}
		}

		// Restore armor after applying lavanail's pierce damage
		if (self.classtype == CT_PROJ_LAVANG || self.classtype == CT_PROJ_LAVASNG) { other.armortype = old_armortype; other.armorvalue = old_armorvalue; }

		// Nail Piercing affect, move nail through monster
		if (self.projeffect & IT_ARTPIERCE) {
			if (random() < 0.2) SpawnMeatSpray (self, other, crandom() * 100); // a small pile of gifs! (spog)
			self.movetype = MOVETYPE_FLY; // Setup projectile ready for monster tests
			self.solid = SOLID_BBOX;
			self.oldorigin = self.origin;
			self.count = 0;

			// Loop forward 8 times to find space on the other side of any other damageables.
			while (self.count < 8) {
				self.finaldest = self.oldorigin + (self.finalangle * 512); // Trace forward from current position
				traceline(self.oldorigin, self.finaldest,FALSE,self);
				if (trace_ent == other) self.oldorigin = self.oldorigin + self.finalangle*16; // Still inside bleeding object?
				else self.count = 8; // On the other side!
				self.count = self.count + 1;
			}

			// Is the other side free space to spawn?
			if (pointcontents(self.oldorigin) == CONTENT_EMPTY) {
				tself = self;
				org = self.oldorigin;
				dir = self.finalangle;
				proj_type = self.classtype;
				proj_speed = self.speed;
				self = self.owner; // Once a projectile hits an object it is impossible to reset its velocity/angles and carry on.  Use owner to make non-solid...
				launch_projectile(org, dir, proj_type, proj_speed); // ... and create a new projectile and delete the current one instead!
				self = tself;
			}
		}
	} else {
		// Rocochet feature for lasers (Laser Canon from hipnotic mod)
		if (self.attack_ricochet > 0) {
			self.attack_ricochet = self.attack_ricochet - 1;
			self.dmg = self.dmg * 0.9; // Gradually wear down the damage from ricohets
			self.pos1 = self.angles;
			self.pos1_x = -self.pos1_x;
			makevectors(self.pos1); // Use angles to create forward vector
			self.pos2 = self.origin - (v_forward * 16); // Need to intersect the surface to create the plane normal
			self.pos3 = self.origin + (v_forward * 16); // Start and finish points have to be either side of impact
			traceline (self.pos2, self.pos3, FALSE, self); // Ignore all monsters and trace backward from impact
			setorigin(self, trace_endpos); // Move entity to impact point so its not stuck

			// Show Laser impact on geo surface
			if (self.attack_ricochet == 0 || random() < 0.25) {
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
				WriteCoord (MSG_BROADCAST, self.origin_x);
				WriteCoord (MSG_BROADCAST, self.origin_y);
				WriteCoord (MSG_BROADCAST, self.origin_z);
			}
			
			// Create ricochet angle using trace_plane_normal, which is the normal of the surface hit.
			self.pos3 = normalize(self.finalangle);
			self.velocity = self.pos3 + ( 2 * trace_plane_normal );
			self.velocity = normalize(self.velocity);
			self.finalangle = self.velocity; // Save for think function
			self.velocity = self.finalangle * self.attack_speed;
			self.angles = vectoangles(self.finalangle); // make sure projectile facing correct direction
			self.flags = self.flags - (self.flags & FL_ONGROUND); // Make sure the projectile is still flying
			self.movetype = MOVETYPE_FLYMISSILE; // Reset movement functionality
			self.solid = SOLID_BBOX;
			self.touch = Touch_Projectile; // Make sure all touch/think is still working.
			self.nextthink = time + 0.1;
			self.think = Think_Projectile;
			return; // We bounced.
		}

		// Some projectiles need to be left lying around for a while
		if (self.bodyfadeaway) {
			if (self.classtype == CT_PROJ_FLESH || self.classtype == CT_PROJ_FLESHP) 
				sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);
			else if (self.classtype == CT_PROJ_SPID || self.classtype == CT_PROJ_WILLY || self.classtype == CT_PROJ_VORE || self.classtype == CT_PROJ_ELF)
				sound (self, CHAN_WEAPON, "ad171/wraith/bounce.wav", 1, ATTN_NORM);
			else if (self.classtype == CT_PROJ_BOLT1 || self.classtype == CT_PROJ_BOLT2 || self.classtype == CT_PROJ_DARTARROW) {
				if (random() < 0.5) sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit2.wav", 1, ATTN_NORM);
				else sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit3.wav", 1, ATTN_NORM);
			}
				
			self.velocity = self.avelocity = '0 0 0';
			self.nextthink = time + 2 + random(); // Soon make projectiles vanish.
			self.ltime = self.nextthink;
			self.think = model_fade;	
			return;
		} else { // Standard engine impact particles and sounds
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			if (self.classtype == CT_PROJ_SNG) WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
			else if (self.classtype == CT_PROJ_LASER) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else if (self.classtype == CT_PROJ_GROCK) WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			else if (self.classtype == CT_PROJ_WIZ) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_SPID) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_SWAMP) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_WILLY) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_VORE) WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
			else if (self.classtype == CT_PROJ_ELF) WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			else if (self.classtype == CT_PROJ_FURY2) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_NOUR1) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_BLBOLT) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_BLBOLT2) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else if (self.classtype == CT_PROJ_HKN || self.classtype == CT_PROJ_HKN_BLUE) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else if (self.classtype == CT_PROJ_HKN2) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else WriteByte (MSG_BROADCAST, TE_SPIKE);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}
	}
	entity_remove(self,3); // Hide projectile and wait for any sounds to finish playing
};

void(vector org, vector dir, float proj_type, float proj_speed) launch_projectile = { // [FUNCTION]
	newmis = spawn ();
	newmis.owner = self;
	newmis.classname = "proj_nail";		// obj name, not really used anymore
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJALL;	// Ammo type (default)
	if (newmis.classtype == CT_PROJ_NG || newmis.classtype == CT_PROJ_SNG || newmis.classtype == CT_PROJ_REFNG) newmis.classgroup = CG_PROJNAILS;
	if (newmis.classtype == CT_PROJ_MONNG || newmis.classtype == CT_PROJ_REFLNG || newmis.classtype == CT_PROJ_LAVASNG || newmis.classtype == CT_PROJ_LAVANG) newmis.classgroup = CG_PROJLAVANAILS;

	// Switch model collision based on auto aim functionality.  Monsters always use large collision (otherwise infighting would be less)
	if (self.flags & FL_CLIENT) {
		if (playerprojsize == 0) newmis.movetype = MOVETYPE_FLYMISSILE;	// Large collision
		else newmis.movetype = MOVETYPE_FLY;		// Small collision

		if (self.moditems & IT_ARTPIERCE && (newmis.classgroup == CG_PROJNAILS || newmis.classgroup == CG_PROJLAVANAILS)) newmis.projeffect = IT_ARTPIERCE; // Check if the player has the nail piercer effect active
	} else if (proj_type == CT_PROJ_LASER) {
		newmis.movetype = MOVETYPE_FLY; // lasers/plasma are small
		newmis.effects = EF_DIMLIGHT; // and glowing
	} else if (proj_type == CT_PROJ_BOLT1 || proj_type == CT_PROJ_BOLT2 || proj_type == CT_PROJ_DARTARROW) {
		newmis.movetype = MOVETYPE_FLY; // Crossbow bolts are small
		newmis.bodyfadeaway = TRUE; // and stick around
	} else newmis.movetype = MOVETYPE_FLYMISSILE; // Default = large collision

	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_Projectile;
	newmis.nextthink = time + LIFE_PROJECTILE;
	newmis.think = SUB_Remove;
	newmis.poisonous = newmis.owner.poisonous;
	if (proj_type == CT_PROJ_BOLT2) newmis.poisonous = 1;
	
	// Setup model
	if (proj_type == CT_PROJ_NG) setmodel (newmis, MODEL_PROJ_NG);
	else if (proj_type == CT_PROJ_SNG) setmodel (newmis, MODEL_PROJ_SNG);
	else if (proj_type == CT_PROJ_LAVANG || proj_type == CT_PROJ_LAVASNG) setmodel (newmis, "progs/lspike.mdl");
	else if (proj_type == CT_PROJ_REFNG) setmodel (newmis, "progs/lspike.mdl");
	else if (proj_type == CT_PROJ_MCOR1) {
		setmodel (newmis, "progs/madfox/proj_mcornflame.mdl");
		newmis.classgroup = CG_PROJLAVANAILS;
		newmis.attack_ricochet = 7; // Seriously!??
	} else if (proj_type == CT_PROJ_MCOR1) {
		setmodel (newmis, "progs/q15/s_spike.mdl"); // silver thorn
		newmis.classgroup = CG_PROJNAILS;
		newmis.projeffect = IT_ARTPIERCE; // Whoa hey, that's not fair!  Tough.  -Qmaster
		newmis.attack_ricochet = 5; // Bruh!!
	} else if (proj_type == CT_PROJ_REFLNG) setmodel (newmis, MODEL_PROJ_NG);
	else if (proj_type == CT_PROJ_SANTA) {
		setmodel (newmis, MODEL_PROJ_SNOWBALL); // Santa Snowball machine gun!
		newmis.classgroup = CG_PROJICE;
	} else if (proj_type == CT_PROJ_BOLT1) setmodel (newmis, MODEL_PROJ_BOLT1); // Crossbow Knight has poison/regular bolts
	else if (proj_type == CT_PROJ_BOLT2) setmodel (newmis, "progs/ad171/proj_bolt2.mdl");
	else if (proj_type == CT_PROJ_DARTARROW) setmodel (newmis, "progs/drake/arrow.mdl");
	else if (proj_type == CT_PROJ_HKN) setmodel (newmis, MODEL_PROJ_HKN);
	else if (proj_type == CT_PROJ_HKN_BLUE) setmodel (newmis, "progs/newhouse/vk_spike.mdl");
	else if (proj_type == CT_PROJ_HKN2) setmodel (newmis, "progs/q15/k_spike.mdl"); // Warlord spike (Quake 1.5)
	else if (proj_type == CT_PROJ_ENFHKN) setmodel (newmis, MODEL_PROJ_HKN);
	else if (proj_type == CT_PROJ_WIZ) setmodel (newmis, MODEL_PROJ_WIZ);
	else if (proj_type == CT_PROJ_MPOISON) setmodel (newmis, MODEL_PROJ_MPOISON);
	else if (proj_type == CT_PROJ_MBLOOD) setmodel (newmis, MODEL_PROJ_MBLOOD);
	else if (proj_type == CT_PROJ_WBONE) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_WPOISON); // Wraith fire bones (nails) can be poisonous as well
		else setmodel (newmis, MODEL_PROJ_WBONE);
	} else if (proj_type == CT_PROJ_WPOISON) setmodel (newmis, MODEL_PROJ_WPOISON);
	else if (proj_type == CT_PROJ_MONNG) setmodel (newmis, MODEL_PROJ_NGRED); // Monster Nails (MONNG) = Lava Nails
	else if (proj_type == CT_PROJ_SCORP) setmodel (newmis, MODEL_PROJ_SCORP);
	else if (proj_type == CT_PROJ_FURY2) setmodel (newmis, MODEL_PROJ_FURY2);
	else if (proj_type == CT_PROJ_NOUR1) setmodel (newmis, MODEL_PROJ_NOUR1);
	else if (proj_type == CT_PROJ_BLBOLT) { // Boglord / Fire Shambler nail/lightning attack
		if (self.spawnflags & MON_BOGL_STRONG) { 
			newmis.classtype = CT_PROJ_BLBOLT2;
			setmodel (newmis, MODEL_PROJ_BLORDBOLT2);
		} else setmodel (newmis, MODEL_PROJ_BLORDBOLT1);
	} else if (proj_type == CT_PROJ_WILLY) setmodel (newmis, "progs/w_spike.mdl");
	else if (proj_type == CT_PROJ_LASER || proj_type == CT_PROJ_RICLASER) {
		if (proj_type == CT_PROJ_RICLASER) { // Ricochet special setup
			newmis.attack_ricochet = 3; // Allow for projectile to ricochet up to 3 times
			newmis.dmg = DAMAGE_LASER; // Damage is reduced 10% every time it ricochet's.
			newmis.attack_lifetime = time + LIFE_PROJECTILE; // Shift projectile end of life to variable instead
			newmis.nextthink = time + 0.1;
			newmis.think = Think_Projectile; // Need special think function to reset velocity/angle
		}
		
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_LASERGRN); // Select model type based on poisonous key
		else setmodel (newmis, MODEL_PROJ_LASER);

		// If DP/FTE engine use new particle trail, glowing for Fitz engines
		if (ext_dppart) {
			if (newmis.poisonous) newmis.traileffectnum = particleeffectnum(DPP_TRPOISON);
			else newmis.traileffectnum = particleeffectnum(DPP_TRLASER);
			//newmis.effects = 0;	// Remove extra glow
		}
	} else if (proj_type == CT_PROJ_GROCK) {
		if (random() < 0.5) setmodel (newmis, MODEL_PROJ_GROCK1);
		else setmodel (newmis, MODEL_PROJ_GROCK2);
		newmis.frame = rint(random()*9);
		newmis.avelocity = vecrand(0,200,TRUE);
	}

	newmis.speed = proj_speed; // Standard projectile setup (origin, size and velocity)
	newmis.finalangle = dir;
	newmis.velocity = newmis.finalangle * newmis.speed;
	newmis.angles = vectoangles(newmis.finalangle);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);
};

void() Touch_HomingMissile = { // [FUNCTION]
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (self.touchedvoid) return;				// Marked for removal
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	// Check for breakable/pushable monster immunity
	if (ai_immunebreakable(self.oldenemy, other)) {
		SpawnExplosion(EXPLODE_BURST_SMOKE,self.origin,SOUND_RESIST_ROCKET); // Show ammo resistance on bmodel
		SpawnProjectileSmoke(self.origin, 200, 50, 150);
		SpawnProjectileSmoke(self.origin, 200, 50, 250);
		SpawnProjectileSmoke(self.origin, 300, 50, 150);
	} else {
		if (ai_foundbreakable(self.oldenemy, other, TRUE) && other.brktrigmissile != 0) {
			trigger_ent(other, self.oldenemy); // Found a breakable which is prone to explosive damage
		} else {
			
			if (other.classgroup == CG_ZOMBIE && !(other.classname == "monster_mummy")) T_Damage (other, world, world, DAMAGE_ZOMBIECLASS, NOARMOR); // Homing Missiles always kill any zombie class (except for tuff mummies!).
			else {
				self.pos1 = '0 0 0'; // Missile explosion x/y/z = base/rnd/splash
				if (self.classtype == CT_PROJ_SHUB1) self.pos1 = self.oldenemy.pos2;
				else if (self.classtype == CT_PROJ_SHAL) self.pos1 = DAMAGE_HMSHAL;
				else if (self.classtype == CT_PROJ_SERG) self.pos1 = DAMAGE_HMSERG;
				else self.pos1_z = DAMAGE_MONROCKET; // Default uses classic grenade/rocket damage

				self.dmg = self.pos1_x + (random() * self.pos1_y); // pre-calculate missile damage

				// BLAST BELT:  Resistance = 100% for splashdamage, 50% for direct.
				if (other.flags & FL_CLIENT && other.moditems & IT_ARTBLASTBELT) {
					PlayBlastBeltSound(other);	// Play impact sound
					if (other.health > 0) {
						if (self.dmg <= 0 && self.pos1_z > 0) T_Damage (other, self, self.oldenemy, self.pos1_z * ART_BLASTBELT_DD, DAMARMOR); // Need some damage otherwise projectile does nothing!
						else if (self.dmg > 0) T_Damage (other, self, self.oldenemy, self.dmg * ART_BLASTBELT_DD, DAMARMOR); // Any Direct damage is reduced
					}

					if (self.pos1_z > 0) T_RadiusDamage (self, self.oldenemy, self.pos1_z, self.oldenemy, IGNORECLASS);
				} else { // DEFAULT
					if (self.dmg > 0 && other.health > 0) T_Damage (other, self, self.oldenemy, self.dmg, DAMARMOR); // Only call T_ functions if there is damage to do!
					if (self.pos1_z > 0) T_RadiusDamage (self, self.oldenemy, self.pos1_z, self.oldenemy, IGNORECLASS); // Stop multiple enemies of the same type killing themselves!
					else {
						if (self.poisonous) PoisonDeBuff(other); // Check for poison debuff (using poisonous flag)
					}
				}
			}
		}

		if (other.resist_rockets > 0) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
		else {
			if (ext_dppart) { 
				if (self.poisonous == TRUE) self.dpp_name = DPP_TEPOISON; // Use special effect for e.g. voreball explosions in DP.
				pointparticles(particleeffectnum(self.dpp_name), self.origin, '0 0 0', 1); // DP effect name set before homing missile launched
				R_Exp3(self.origin); // Play standard explosion sound
			} else {
				if (self.poisonous) {
					WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte (MSG_BROADCAST, TE_EXPLOSION2); // New special coloured particle explosion (rogue expansion)
					WriteCoord (MSG_BROADCAST, self.origin_x);
					WriteCoord (MSG_BROADCAST, self.origin_y);
					WriteCoord (MSG_BROADCAST, self.origin_z);
					WriteByte (MSG_BROADCAST, 51);
					WriteByte (MSG_BROADCAST, 8);
					SpawnExplosion(EXPLODE_POISON_SMALL, self.origin, SOUND_REXP3); // Sprite explosion for Fitz engines
				} else {
					WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte (MSG_BROADCAST, TE_EXPLOSION); // Standard explosion
					WriteCoord (MSG_BROADCAST, self.origin_x);
					WriteCoord (MSG_BROADCAST, self.origin_y);
					WriteCoord (MSG_BROADCAST, self.origin_z);
					SpawnExplosion(EXPLODE_SMALL, self.origin, SOUND_REXP3); // Sprite explosion for Fitz engines
				}
			}
		}
	}
	entity_remove(self, 4); // Hide+Delete homing missile, no longer needed.  Wait for any sounds to finish playing
};

void() ShalMissileTouch = { Touch_HomingMissile(); }; // [FUNCTION], re-direct any map hacks to the new function replacement.

void() Steer_HomingMissile = { // [FUNCTION]
	if (self.enemy.health < 1) { remove(self); return; } // If tracking enemies dies or end level? remove homing missiles
	if (intermission_running > 0) { remove(self); return; }
	if (cinematic_running > 0) { remove(self); return; }

	if (self.waitmin < time) self.owner = self; // After 1s let homing missiles impact on ower
	if (self.owner.health < 1 && self.no_trackondeath == TRUE) self.no_trackondeath = NEGATIVE; // Stop missile tracking if owner is dead and mode is enabled

	if (self.no_trackondeath == NEGATIVE) return; // Has projectile tracking been disabled?
	
	self.finaldest = self.enemy.origin + self.v_angle; // Full YAW movement speed, no restriction
	self.attack_track = normalize(self.finaldest - self.origin);
	self.velocity = self.attack_track * self.attack_speed; // Update velocity and model facing angle
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.2; // Slow speed update so the missile can sorta steer around corners, sloppy slow updates also allows for a better game experience.
	self.think = Steer_HomingMissile;	
};

void(vector orgofs, vector targofs, float proj_type, float proj_speed) Launch_HomingMissile = { // [FUNCTION]
	local vector org, dir;
	local float dist, flytime;

	makevectors(self.angles);
	org = self.origin + attack_vector(orgofs);
	if (entity_pcontent(org)) return; // Check if there is space to spawn entity
	
	newmis = spawn ();
	newmis.owner = newmis.oldenemy = self; // Owner is always excluded from touch functions, save in oldenemy and after one second remove owner so we'll touch everything.
	newmis.classname = "proj_rocket";		// obj name, not really used anymore
	newmis.classtype = proj_type;			// Class type number, quick identity
	newmis.classgroup = CG_PROJROCKETS;		// Ammo type
	newmis.movetype = MOVETYPE_FLYMISSILE;	// Default = large collision
	newmis.enemy = self.enemy;				// Used for homing target
	newmis.v_angle = targofs;				// Store for later
	dir = normalize((self.enemy.origin + newmis.v_angle) - org); // Aim the missile slightly above enemy
	dist = vlen (self.enemy.origin - org);
	flytime = dist * 0.002;
	if (flytime < 0.1) flytime = 0.1;
	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_HomingMissile;
	newmis.nextthink = flytime + time;
	newmis.think = Steer_HomingMissile;
	newmis.attack_speed = proj_speed;
	if (self.no_trackondeath == NEGATIVE) newmis.no_trackondeath = FALSE; // Setup default homing missile mode.  Priority : ENTITY > IMPULSE > WORLDSPAWN
	else if (self.no_trackondeath == TRUE) newmis.no_trackondeath = TRUE;
	else if (map_notrackondeath == TRUE) newmis.no_trackondeath = TRUE;
	else newmis.no_trackondeath = FALSE;

	newmis.waitmin = time + 3; // Allow 3s for the homing missile to travel away
	newmis.poisonous = newmis.owner.poisonous;

	// Setup model for each missile type
	if (proj_type == CT_PROJ_SHAL) {
		setmodel(newmis, MODEL_PROJ_SHAL);
		newmis.dpp_name = DPP_TEVORESPIKE;
	} else if (proj_type == CT_PROJ_SERG) {
		setmodel(newmis, MODEL_PROJ_SERG);
		newmis.dpp_name = DPP_TEEXPLODE;
	} else if (proj_type == CT_PROJ_SHUB1) {
		setmodel(newmis, MODEL_PROJ_SHUB1);
		newmis.dpp_name = DPP_TEEXPLODE;
		makevectors(self.angles); // The angles key will reverse direction for up-side-down Shub.
		dir = v_up*0.5; // Push the homing missing up from center.
	}

	newmis.attack_track = dir; // Standard projectile setup (origin, size and velocity)
	newmis.velocity = newmis.attack_track * newmis.attack_speed;
	newmis.angles = vectoangles(self.velocity);
	newmis.avelocity = vecrand(100,200,FALSE);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);
};

void() Touch_Missile = { // [FUNCTION]
	local float lavadmg;

	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (self.oldenemy && other.classtype == self.oldenemy.classtype) return; // Stop packs of owners killing each other
	if (self.classtype == CT_PROJ_SKULLW && self.th_updmissile != SUB_Null) { self.th_updmissile(); return; } // Guardian skull wizards have special poison explosion

	if (ai_immunebreakable(self.owner, other)) { // Check for breakable/pushable monster immunity
		SpawnExplosion(EXPLODE_BURST_SMOKE,self.origin,SOUND_RESIST_ROCKET); // Show ammo resistance
		SpawnProjectileSmoke(self.origin, 200, 50, 150);
		if (random() < 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 250);
		if (random() < 0.5) SpawnProjectileSmoke(self.origin, 300, 50, 150);
	} else {
		if (ai_foundbreakable(self.owner, other, TRUE) && other.brktrigmissile != 0) {
			trigger_ent(other, self.owner); // Found a breakable which is prone to explosive damage
		} else {
			// Setup rocket damage (vector = base + random and splash)
			if (self.classtype == CT_PROJ_ROCKET) self.pos1 = DAMAGE_RLPLAYER;
			else if (self.classtype == CT_PROJ_ROCKETSUPER) self.pos1 = DAMAGE_RLPLAYER;
			else if (self.classtype == CT_PROJ_FURY1) self.pos1 = DAMAGE_RLFURY;
			else if (self.classtype == CT_PROJ_LAVA) { self.pos1 = DAMAGE_RLPLAYER; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_FIRETOP) { self.pos1 = DAMAGE_RLFIRETOP; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_CHTHON) { self.pos1 = self.owner.pos2; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_SKULLW) self.pos1 = DAMAGE_RLSKULLW;
			else if (self.classtype == CT_PROJ_GARG) { self.pos1 = DAMAGE_RLGARG; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_ARMY) self.pos1 = DAMAGE_RLARMY;
			else if (self.classtype == CT_PROJ_CYBER) self.pos1 = DAMAGE_RLCYBER;
			else if (self.classtype == CT_PROJ_JIM2) self.pos1 = DAMAGE_RLJIM2;
			else if (self.classtype == CT_PROJ_SEEKER) self.pos1 = DAMAGE_RLSEEKER;
			else if (self.classtype == CT_PROJ_DROLE) { self.pos1 = DAMAGE_RLDROLE; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_ICEG1) self.pos1 = DAMAGE_RLICEG;
			else if (self.classtype == CT_PROJ_BLORD2){ self.pos1 = DAMAGE_RLBLORD; lavadmg = TRUE; } // BOSS Custom for ad_sepulcher (Fire Shambler)
			else if (self.classtype == CT_PROJ_EIDO1) self.pos1 = DAMAGE_RLEIDO;
			else if (self.classtype == CT_PROJ_SMARTBALL) { self.pos1 = DAMAGE_SMARTBALL; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_FABLADE) self.pos1 = '8 8 0';
			else if (self.classtype == CT_PROJ_FASPELL) self.pos1 = '12 22 20';
			else if (self.classtype == CT_PROJ_BLORD) {
				self.pos1 = DAMAGE_RLBLORD;
				self.oldorigin = self.origin; // Don't spawn gib models at impact (could be solid)
				self.origin = self.origin - 8*normalize(self.velocity);
				self.gib1mdl = MODEL_PROJ_BLORD1S; // Special gib model, frame and movement pattern
				self.gib1frame = 9;
				ThrowGib(11, rint(0.5 + random()*3)); // Throw gib quantity based on skill level
				self.origin = self.oldorigin; // Restore origin for rest of rocket impact
				self.height = EXPLODE_POISON_MED; // Use new poison explosion
				if (other.classname == "player") PoisonDeBuff(other); // Poisonous projectiles
			}
			else if (self.classtype == CT_PROJ_SWEEP1) self.pos1 = DAMAGE_RLSWEEPER;
			else if (self.classtype == CT_PROJ_DPRINCE1) self.pos1 = DAMAGE_RLDPRINCE;
			else if (self.classtype == CT_PROJ_DEFLECT1) self.pos1 = DAMAGE_RLDEFLECT;
			else if (self.classtype == CT_PROJ_MAMMOTH) self.pos1 = DAMAGE_RLMAMMOTH;
			else if (self.classtype == CT_PROJ_JUDGER) self.pos1 = DAMAGE_RLJUDGE;
			else if (self.classtype == CT_PROJ_JUSTICER) self.pos1 = DAMAGE_RLJUDGE;
			else if (self.classtype == CT_PROJ_RAINDEER) self.pos1 = DAMAGE_RLRAINDEER;

			// Instant death explosion for zombies from rocket explosions!  It doesn't make sense that this wasn't originally a default for explosives. this will affect _zombie, _zombiek, monster types.
			if (other.classgroup == CG_ZOMBIE && !(other.classname == "monster_mummy")) {
				if (self.pos1_x < DAMAGE_RLKILLZOM) self.pos1_x = DAMAGE_RLKILLZOM; // Change direct damage direct to make sure it zombie gibs
			}
			self.dmg = self.pos1_x + (random() * self.pos1_y); // Pre-calculate rocket damage.

			// LAVA SHIELD.  Resistance = 50% fire/lava attacks.  Monsters - Boss, Chthon, Firetop, Drole, Quoth Deathguard and Gargoyle
			if (other.flags & FL_CLIENT && other.moditems & IT_ARTLAVASHIELD && lavadmg == TRUE) {
				if (other.moditems & IT_ARTLAVASHIELD) {
					PlayLavaShieldSound(other);
					self.dmg = floor(self.dmg * 0.5);
					if (self.dmg <= 0) self.dmg = 0;
				}

				if (other.resist_fire > 0) self.dmg = self.dmg * (1-other.resist_fire);
			}

			// BLAST BELT:  Resistance = 100% for splashdamage, 50% for direct.
			if (other.flags & FL_CLIENT && other.moditems & IT_ARTBLASTBELT) {
				PlayBlastBeltSound(other);	// Play impact sound
				if (other.health > 0) {
					if (self.dmg <= 0 && self.pos1_z > 0) T_Damage (other, self, self.owner, self.pos1_z*ART_BLASTBELT_DD, DAMARMOR); // Need some damage otherwise projectile does nothing!
					else if (self.dmg > 0) T_Damage (other, self, self.owner, self.dmg*ART_BLASTBELT_DD, DAMARMOR); // Any direct damage is reduced
				}
				if (self.pos1_z > 0) T_RadiusDamage (self, self.owner, self.pos1_z, other, DAMAGEALL);
			} else {
				if (self.dmg > 0 && other.health > 0) T_Damage (other, self, self.owner, self.dmg, DAMARMOR); // DEFAULT Only call T_ functions if there is damage to do!
				if (self.pos1_z > 0) T_RadiusDamage (self, self.owner, self.pos1_z, other, DAMAGEALL);
			}
		}
		
		if (other.resist_rockets > 0 || (other.resist_multi_rockets && self.classgroup == CG_PROJMULTIROCKETS)) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
		else {
			if (self.poisonous == TRUE) { self.height = EXPLODE_POISON_MED; PoisonDeBuff(other); } // Check for poison debuff (using poisonous flag).  Use new poison explosion.
			self.origin = self.origin - 8*normalize(self.velocity); // Move the explosion effect higher up from point of contact
			if (self.classtype == CT_PROJ_ROCKETSUPER || self.classtype == CT_PROJ_SIDEWINDER) self.height = EXPLODE_SMALL; // Because it's used for the think function to adjsut velocity over time.
			if (self.height < EXPLODE_PLASMA_SMALL) {
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_EXPLOSION); // Default ID particle explosion for fire explosions
				WriteCoord (MSG_BROADCAST, self.origin_x);
				WriteCoord (MSG_BROADCAST, self.origin_y);
				WriteCoord (MSG_BROADCAST, self.origin_z);
			}
			if (self.noise == "") self.noise = SOUND_REXP3; // Play original explosion sound or replacement
			SpawnExplosion(self.height, self.origin, self.noise);
		}
	}
	entity_remove(self, 1); // Hide+Delete rocket, no longer needed
};

void() Puff_Missile = { SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, ""); entity_remove(self, 0.1); }; // [FUNCTION], Removes a missile in a light puff of smoke.

void() T_MissileTouch = { Touch_Missile(); }; // [FUNCTION], re-direct any map hacks to the new function replacement.

void() Steer_LimitedMissile = { // [FUNCTION]
	local float veclen, vecdist;
	
	// No tracking during intermission / cinematic
	if (intermission_running > 0) { Puff_Missile(); return; }
	if (cinematic_running > 0) { Puff_Missile(); return; }
	// Remove projectile after a certain time limit
	if (self.attack_finished < time) {
		// Do nothing if controlled via custom particle trail
		if (self.part_qctrail == 0) Puff_Missile();
		return;
	}

	// play sound when starting the missile in flight
	if (self.attack_instant == TRUE && self.noise1 != "")
		sound (self, CHAN_WEAPON, self.noise1, 1, ATTN_NORM);
	// Only play first sound once
	self.attack_instant = FALSE;

	// Stop steering if attacker or enemy is dead
	if (self.owner.health < 1) self.attack_disabled = TRUE;
	else if (self.enemy.health < 1) self.attack_disabled = TRUE;
			
	// How often to steer projectile
	self.think = Steer_LimitedMissile;
	self.nextthink =  time + 0.2;

	// The amount of time to keep steering rocket
	// Time = 0.2 * ( 5 + skill * 5) 
	// EASY = 1s, NORMAL = 2s, HARD = 3s, NM = 4s
	self.count = self.count + 1;
	if ( self.count > (5 + (skill*5)) ) self.attack_disabled = TRUE;

	if (!self.attack_disabled) {
		// Steering rocket towards the enemy PART 1
		// First check - Is the rocket too close to the enemy?
		// Based on skill level change that distance to get closer
		// This can change if projectile is fast and tick rate slow
		// The distance check has to happen before sightline checks
		// otherwise the missile will do one last deadly adjustment!
		// Work out distance to enemy (target) origin
		veclen = vlen(self.enemy.origin - self.origin);
		// Skill distance: 160=Easy, 140=Normal, 120=Hard, 100=NM
		vecdist = SPEED_ROCSTEERDIS - (skill * SPEED_ROCSTEERDISSKILL);
		// Stop steering towards enemy if too close
		if (veclen < vecdist) self.attack_disabled = TRUE;
		else {
			// Steering rocket towards the enemy PART 2
			// Having the sight check on the rocket means it will turn corners
			// really fast and look/feel unfair (shalrath problems).
			// Part 1 - place a sight check from attacker to enemy
			// If the enemy has moved behind cover this will break LoS
			// and stop the rocket steering around corners
			// Part 2 - Restrict steering speed to stop sudden turns
			// Slowly build up to super accurate turning direction
			// All AI sight checks are designed for self as primary source
			// This 'Trace' does not involve self, reqs attacker -> enemy
			traceline(self.owner.origin + self.attack_offset, self.attack_origin, TRUE, self.owner);
			// Update tracking origin and direction
			if (trace_fraction == 1) {
				self.attack_origin = self.enemy.origin;
				self.attack_track = self.attack_origin - self.origin;
				// Accuracy starts low and increase over time
				if (self.attack_steering < 1) {
					self.attack_track = self.attack_track * self.attack_steering;
					self.attack_steering = self.attack_steering + SPEED_ROCSTEERINCACC;
				}
				// Normalize (ready for speed) after any steering adjustment
				self.attack_track = normalize(self.attack_track);
			}
			// Once sight line broken, no more steering
			else self.attack_disabled = TRUE;
		}
	}	

	// Make sure projectile velocity has an upper limit
	// Speed increase: 70=Easy, 80=Normal, 90=Hard, 100=NM
	if (self.attack_speed < self.attack_maxspeed) {
		self.attack_speed = self.attack_speed + SPEED_ROCSTEERINC + (skill * SPEED_ROCSTEERINCSKILL);
		if (self.attack_speed > self.attack_maxspeed) self.attack_speed = self.attack_maxspeed;
	}
		
	// Update direction, velocity and facing angle (facing velocity)
	self.velocity = self.attack_track * self.attack_speed;
	if (self.attack_angle) self.angles = vectoangles(self.velocity);
};

void(vector org, vector dir, vector avel, float proj_type, float proj_speed) Launch_Missile = { // [FUNCTION]
	if (entity_pcontent(org)) return; // Check if there is space to spawn entity
	
	newmis = spawn ();
	newmis.owner = self;
	newmis.classname = "proj_rocket";	// obj name, not really used anymore
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJROCKETS;	// Ammo type
	if (self.flags & FL_CLIENT) { // Player rockets need to take into account autoaim
		if (playerprojsize == 0) newmis.movetype = MOVETYPE_FLYMISSILE;	// Large collision
		else newmis.movetype = MOVETYPE_FLY;		// Small collision
	} else {
		newmis.movetype = MOVETYPE_FLY; // Default monster missile width is thin!
		if (self.classtype == CT_MONGARGOYLE) newmis.oldenemy = self; // Horrible exception for the missile touch function.  Gargoyle rockets need to pass through other gargoyles otherwise a pack of them would kill each other!
	}

	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_Missile;				// Default touch/impact
	newmis.height = EXPLODE_SMALL;				// Default impact sound
	newmis.attack_speed = newmis.attack_maxspeed = proj_speed;	// current/max speed
	newmis.poisonous = newmis.owner.poisonous;	// Take poison from owner (firing)
	newmis.attack_finished = time + LIFE_ROCKET;// Used later for steering
	newmis.nextthink = newmis.attack_finished;	// End of projectile life
	newmis.think = SUB_Remove;

	// Setup for each missile type
	if (proj_type == CT_PROJ_ROCKET) setmodel(newmis, MODEL_PROJ_ROCKET);
	else if (proj_type == CT_PROJ_ROCKETSUPER) {
		setmodel(newmis, MODEL_PROJ_ROCKET);
		newmis.th_updmissile = SuperRocket_Think;
		newmis.speed     = 500;
		newmis.velocity  = dir * newmis.speed;
		newmis.height    = 50; // speed increase facter per think (every 0.1s) up to 1500 max speed
		newmis.volume    = 0.7071; // Tracking fov (63.639 degrees)
		newmis.enemy     = SuperRocket_Target (newmis.owner, org, dir, 2000, newmis.volume);
		newmis.yaw_speed = 10;
		newmis.cnt       = 2;   // Increase yaw_speed by this after each think.
		newmis.state     = 0;   // Aim directly at enemy.  Use 1 to intercept.
		newmis.delay     = newmis.nextthink;
		newmis.nextthink = time + 0.2;
		newmis.think     = SuperRocket_Think;
	} else if (proj_type == CT_PROJ_GARG) {
		if (newmis.poisonous) setmodel(newmis, MODEL_PROJ_GARGOYLEGRN);
		else setmodel(newmis, MODEL_PROJ_GARGOYLE);
	} else if (proj_type == CT_PROJ_SKULLW) {
		if (newmis.poisonous) {
			setmodel (newmis, MODEL_PROJ_SWSKULLP);
			// Copy over poison explosive function just incase
			// Skull wizard dies before projectile hits something
			newmis.th_updmissile = self.th_updmissile;
		} else {
			// Classic skullwizard flaming skull projectile!
			setmodel(newmis, MODEL_PROJ_SWSKULL);
			newmis.th_updmissile = SUB_Null;
		}
	} else if (proj_type == CT_PROJ_FURY1) {
		if (newmis.poisonous) setmodel(newmis, MODEL_PROJ_SHALGRN);
		else setmodel(newmis, MODEL_PROJ_FURY1);
	} else if (proj_type == CT_PROJ_LAVA) setmodel (newmis, MODEL_PROJ_LAVA);
	else if (proj_type == CT_PROJ_FIRETOP) setmodel (newmis, MODEL_PROJ_LAVA);
	else if (proj_type == CT_PROJ_CHTHON) {
		if (self.spawnflags & MON_CHTHON_GREEN) setmodel (newmis, MODEL_PROJ_SLIME);
		else setmodel (newmis, MODEL_PROJ_LAVA);
	} else if (proj_type == CT_PROJ_JIM2) {
		setmodel(newmis, MODEL_PROJ_ROCKET);
		newmis.noise = "quoth/dguard/hit.wav";
	} else if (proj_type == CT_PROJ_SEEKER) {
		setmodel(newmis, MODEL_PROJ_ROCKET);
		newmis.noise = "quoth/dguard/hit.wav";
	} else if (proj_type == CT_PROJ_EIDO1) {
		setmodel(newmis, MODEL_PROJ_EIDO1);
		newmis.frame = 7;
		if (random() < 0.5) newmis.noise = "ad171/eidolon/rock_hit1.wav";
		else newmis.noise = "ad171/eidolon/rock_hit2.wav";
		if (random() < 0.5) newmis.height = EXPLODE_MED;
	} else if (proj_type == CT_PROJ_ARMY) {
		if (newmis.poisonous) setmodel(newmis, MODEL_PROJ_ROCKETGRN);
		else setmodel(newmis, MODEL_PROJ_ROCKET);
		newmis.noise = "quoth/dguard/hit.wav";
		newmis.nextthink = time + 0.1;
		newmis.think = self.th_updmissile;
		if (visible(self.enemy)) newmis.enemy = self.enemy; // If can see enemy, steer the rocket towards them
	} else if (proj_type == CT_PROJ_DEFLECT1) {
		if (newmis.poisonous) setmodel(newmis, MODEL_PROJ_ROCKETGRN);
		else setmodel(newmis, MODEL_PROJ_ROCKET);
		newmis.noise = "ad181/deflector/rocket_hit.wav";
		newmis.attack_speed = 200;
		newmis.attack_rage = TRUE;	// Steering missile
		newmis.attack_angle = TRUE;	// Rotate towards direction
	} else if (proj_type == CT_PROJ_CYBER) {
		setmodel(newmis, "progs/missile.mdl");
		newmis.noise = "quoth/dguard/hit.wav";
		newmis.nextthink = time + 0.1;
		newmis.think = self.th_updmissile;
		if (visible(self.enemy)) newmis.enemy = self.enemy; // If can see enemy, steer the rocket towards them
	} else if (proj_type == CT_PROJ_DROLE) {
		if (newmis.poisonous) setmodel (newmis, MODEL_PROJ_DROLEGRN);
		else setmodel (newmis, MODEL_PROJ_DROLE);
		newmis.noise = "quoth/drole/explode3.wav";
		newmis.nextthink = time + 0.025;
		newmis.think = self.th_updmissile;
	} else if (proj_type == CT_PROJ_ICEG1) {
		setmodel (newmis, MODEL_PROJ_GSHARD);
		newmis.classgroup = CG_PROJICE;
		newmis.noise = "ne_ruins/h2golem/frosthit.wav";
		newmis.height = EXPLODE_ICE_BIG;
		newmis.nextthink = time + 0.1;
		newmis.think = self.th_updmissile;
		newmis.pos1 = self.enemy.origin;
		newmis.attack_timer = 0;
	} else if (proj_type == CT_PROJ_BLORD) {
		// If the boglord dies before the impact of the 'rocket' then the self.owner field will be invalid.  Setup the 'correct' projectile type beforehand instead!
		if (self.spawnflags & MON_BOGL_STRONG) {
			newmis.classtype = CT_PROJ_BLORD2;
			setmodel (newmis, MODEL_PROJ_BLORD2B);
		} else setmodel (newmis, MODEL_PROJ_BLORD1B);
		newmis.frame = 7; // Large size
		newmis.noise = "quoth/drole/explode3.wav";
	} else if (proj_type == CT_PROJ_FABLADE) {
		setmodel (newmis, "progs/hexen2/fablade.mdl");
		newmis.noise = "hexen2/weapons/expsmall.wav";
	} else if (proj_type == CT_PROJ_FASPELL) {
		setmodel (newmis, "progs/hexen2/faspell.mdl");
		newmis.noise = "hexen2/weapons/explode.wav";
		newmis.nextthink = time + 3;
	} else if (proj_type == CT_PROJ_RAINDEER) {
		setmodel(newmis, MODEL_PROJ_RAIND);
		newmis.noise = "xmas/raindeer/hit.wav";
	} else if (proj_type == CT_PROJ_DPRINCE1) {
		setmodel(newmis, self.attack_proj1);
		newmis.part_qctrail = TRUE;	// Custom trails for Blue/Red rockets
		newmis.part_style = self.part_style;
		newmis.part_trstyle = self.part_trstyle;
		newmis.dpp_name = self.dpp_name;
		newmis.attack_speed = 100;
		newmis.attack_rage = TRUE;	// Steering missile
	} else if (proj_type == CT_PROJ_JUDGER) {
		setmodel(newmis, MODEL_PROJ_JUDGER);
		newmis.noise = "ad181/justice/flame_fire.wav";
		newmis.attack_speed = 100;
		newmis.attack_rage = TRUE;	// Steering missile
		newmis.attack_angle = TRUE;	// Rotate towards direction
		newmis.attack_offset = '0 0 32';	// Really tall
		newmis.attack_steering = 0.5;
	} else if (proj_type == CT_PROJ_JUSTICER) {
		setmodel(newmis, MODEL_PROJ_JUDGER);
	} else if (proj_type == CT_PROJ_MAMMOTH) {
		setmodel(newmis, MODEL_PROJ_ROCKET);
		newmis.noise = "mammoth/rocket_hit.wav";
		newmis.attack_speed = 200;
		newmis.attack_rage = TRUE;	// Steering missile
		newmis.attack_angle = TRUE;	// Rotate towards direction
	}

	if (newmis.attack_rage == TRUE) { // Limited missile steering.  Faster is harder to steer, but faster because rage! Argh!
		newmis.attack_track = dir; // Use firing entity for attack tracking setup
		if (newmis.attack_steering == 0) newmis.attack_steering = SPEED_ROCSTEERBASE;
		newmis.enemy = SUB_entEnemyTarget();
		newmis.attack_origin = newmis.enemy.origin;
		newmis.attack_disabled = FALSE;
		newmis.part_exitpuff = TRUE;
		if (newmis.part_qctrail == TRUE ) { // Is the plasma particle trail required?  Particle function runs faster than steering, store for later.
			newmis.part_secfunc = Steer_LimitedMissile;
			newmis.part_sectimer = time + 0.1;
		} else {
			newmis.think = Steer_LimitedMissile; // Default setup for steering rocket
			newmis.nextthink = time + 0.1;
		}
	}
	
	newmis.velocity = dir * newmis.attack_maxspeed; // Standard projectile setup (origin, size and velocity)
	newmis.avelocity = avel; 
	newmis.angles = vectoangles(newmis.velocity);
	newmis.oldorigin = newmis.origin = org;	// Save starting origin
	setorigin (newmis, newmis.origin);		// Move to start point
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);

	if (newmis.part_qctrail == TRUE ) { // Special particle trail
		if (ext_dppart && newmis.dpp_name != "") { // Is DP engine active for new particle trail?
			newmis.traileffectnum = particleeffectnum(newmis.dpp_name);
			newmis.effects = 0;
		}
		Default_ParticleTrail(newmis); // Setup particle defaults for hazard emitter
		newmis.think = Custom_ParticleTrail;	
		newmis.nextthink = time + 0.02;
	}
};

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
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_EXPLOSION); // Default ID particle explosion for fire explosions
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
			SpawnExplosion(self.height, self.origin, SOUND_REXP3); // Play original explosion sound
		}	
	}
	if (!self.think1) entity_remove(self, 1); // Hide grenade, no longer needed unless using special custom explosion
};

void() Touch_Grenade = { // [FUNCTION]
	if (self.touchedvoid) return;				// Marked for removal
	if (entity_pcontent(self.origin)) {remove(self); return;}
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.activate = other;		// Always keep track of what to damage
	if (self.classtype == CT_PROJ_MEGG && other.takedamage == DAMAGE_AIM) {
		// Let minion eggs re-bounce in opposite direction.  Don't want them to explode like grenades.
		if (CheckZeroVector(self.velocity) == FALSE) {
			self.angles = vectoangles(self.mangle);
			self.angles_y = anglemod(self.angles_y + 180);
			self.velocity = -self.mangle;	// Reverse direction
			self.mangle = self.velocity;	// Update new direction
			sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM);
			if ( vlen(self.velocity) > 100 ) self.nextthink = time + LIFE_EGG; // Reset egg timer if still bouncing a lot
		}
	} else {
		if (ai_foundbreakable(self.owner, self.activate, TRUE) && (self.owner.flags & FL_MONSTER)) { // Check before damage_aim because only player/monster have that setting
			trigger_ent(self.activate, self.owner); // Found a breakable which is prone to explosive damage
			Explode_Grenade(); // Any monster firing a grenade at a breakable will explode without bounce
		} else if (self.activate.takedamage == DAMAGE_AIM) { // Hit something that bleeds? (allows for grenade impact)
			Explode_Grenade(); 
		} else {
			sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM); // Bounce sound.  MOOM!
			if (CheckZeroVector(self.velocity)) self.avelocity = '0 0 0'; // Stop spinning.
		}
	}
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
void() GrenadeTouch = { maphack_grenade(); }; // [FUNCTION]

void(vector org, vector dir, vector avel, float proj_type) Launch_Grenade = { // [FUNCTION]
	local vector vec;

	if (entity_pcontent(org)) return; // Check if there is space to spawn entity
	
	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "proj_grenade";	// obj name, not really used anymore
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJGRENADES;	// Ammo type
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_Grenade;
	newmis.nextthink = time + LIFE_GRENADE;
	newmis.think = Explode_Grenade;
	newmis.th_die = Explode_Grenade;
	newmis.noise = "weapons/bounce.wav";
	newmis.bbmins = newmis.bbmaxs = VEC_ORIGIN;
	newmis.height = EXPLODE_SMALL;
	newmis.poisonous = newmis.owner.poisonous;
	newmis.mass = MASS_GRENADE;
	newmis.physicsflags = newmis.physicsflags | PHYS_GYRO_BOUYANT;

	// Setup model for each missile type
	if (proj_type == CT_PROJ_GL) setmodel(newmis, MODEL_PROJ_GRENADE); // proj_gl is used by the player (separate so easier to change)
	else if (proj_type == CT_PROJ_GLSUPER) {
		setmodel(newmis, MODEL_PROJ_GRENADE);
		newmis.master = self;
		newmis.movetype = MOVETYPE_TOSS;
		newmis.speed = 800; // Was 600, too slow.
		vec = '0 0 200';
		if (self.v_angle_x) {vec = vec + crandom()*v_right*10; vec = vec + crandom()*v_up*10;}
		newmis.velocity    = (dir * newmis.speed) + vec;
		newmis.angles      = vectoangles(newmis.velocity);
		newmis.dmg         = 160;
		newmis.enemy       = world;
		newmis.touch       = Explode_Grenade;
		newmis.delay       = time + 2.5;
		newmis.nextthink   = time + 0.1;
		newmis.think       = SuperGrenade_Think;
		newmis.think1      = BecomeBigBang;
	} else if (proj_type == CT_PROJ_GLMULTI) { 
		setmodel(newmis, "progs/rogue/mervup.mdl");
		newmis.touch = MultiGrenadeTouch;
		newmis.think = MultiGrenadeExplode;
		newmis.nextthink = time + 1;
		newmis.classname = "MultiGrenade";
	}
	else if (proj_type == CT_PROJ_GLMON) { 
		if (newmis.poisonous) setmodel(newmis, MODEL_PROJ_GRENADEGRN); // proj_glmon is used by any monster firing grenades
		else setmodel(newmis, MODEL_PROJ_GRENADE);
	} else if (proj_type == CT_PROJ_FLESH) {
		if (newmis.poisonous) setmodel(newmis, MODEL_PROJ_FLESHP);
		else setmodel (newmis, MODEL_PROJ_FLESH);
	} else if (proj_type == CT_PROJ_FLESHP) {
		setmodel(newmis, MODEL_PROJ_FLESHP);
		newmis.poisonous = TRUE;
		newmis.noise = "ad171/wraith/bounce.wav";
	} else if (proj_type == CT_PROJ_MEGG) {
		if (self.classtype == CT_MONWRAITH) {
			setmodel( newmis, MODEL_PROJ_WEGG);
			newmis.noise = "ad171/wraith/bounce.wav";
		} else if (self.classtype == CT_MONSHAL || self.classtype == CT_MONSHALBOSS) {
			setmodel( newmis, MODEL_PROJ_SEGG);
			newmis.noise = "ad171/wraith/bounce.wav";
		}
		newmis.classgroup = CG_MINIONEGG;		// Proper group type
		newmis.enemy = SUB_entEnemyTarget();	// Make sure got right enemy
		newmis.bbmins = VEC_HULLE_MIN;			// Small egg size
		newmis.bbmaxs = VEC_HULLE_MAX;
		newmis.frame = self.attachment.frame;	// Current ball size (frame)
		newmis.think = Hatch_Egg;				// Eventually hatch
		newmis.nextthink = time + LIFE_EGG;		// Short timer
	} else if (proj_type == CT_PROJ_SPID) {
		setmodel (newmis, MODEL_PROJ_SPID);
		newmis.frame = rint((random() * 9));
	} else if (proj_type == CT_PROJ_ELF) {
		setmodel (newmis, MODEL_PROJ_ELF);
		newmis.frame = rint((random() * 9));
		newmis.classgroup = CG_PROJICE;
	} else if (proj_type == CT_PROJ_SWAMP) {
		setmodel (newmis, MODEL_PROJ_SWAMP);
		newmis.frame = rint((random() * 9));
	} else if (proj_type == CT_PROJ_VORE) {
		setmodel (newmis, MODEL_PROJ_VORE);
		newmis.frame = rint((4 + random() * 4));
	} else if (proj_type == CT_PROJ_NOUR2) {
		setmodel (newmis, MODEL_PROJ_NOUR2B);
		newmis.skin = self.skin;
		newmis.frame = 7; // Large size
		newmis.noise = "ad171/wraith/bounce.wav";
	} else if (proj_type == CT_PROJ_CHTHON2) {
		setmodel (newmis, MODEL_PROJ_CHTHON1);
		newmis.skin = self.skin;
		newmis.frame = rint((random() * 9));
		newmis.noise = "ad171/wraith/bounce.wav";
		newmis.dmg = self.pos3_z;
	} else if (proj_type == CT_PROJ_SHUB2) {
		setmodel (newmis, MODEL_PROJ_SHUB2);
		newmis.frame = rint((random() * 9));
		newmis.noise = "ad171/wraith/bounce.wav";
		newmis.dmg = self.pos3_z;
	} else if (proj_type == CT_PROJ_SHELLC) {
		setmodel(newmis, MODEL_PROJ_SHELLC);
		newmis.touch = Touch_ShellCasing;
		newmis.think = model_fade;
		newmis.nextthink = time + random() + LIFE_SHELLS;
		newmis.ltime = newmis.nextthink;
	} else if (proj_type == CT_PROJ_NAILC) {
		setmodel(newmis, "progs/redfield/proj_nailcase.mdl");
		newmis.touch = Touch_ShellCasing;
		newmis.think = model_fade;
		newmis.nextthink = time + random() + LIFE_SHELLS;
		newmis.ltime = newmis.nextthink;
	} else if (proj_type == CT_PROJ_GLMONMULTI) {
		setmodel(newmis, MODEL_PROJ_GRENADEMULTI);
		newmis.touch = MultiGrenadeTouch;
		newmis.think = MultiGrenadeExplode;
		newmis.nextthink = time + 1;
		newmis.classname = "MultiGrenade";
	} else if (proj_type == CT_PROJ_GLMONPROX) {
		setmodel(newmis, "progs/hipnotic/proxbomb.mdl");
		newmis.touch = ProximityGrenadeTouch;
		newmis.think = ProximityBomb;
		newmis.delay = ((time + 15.000) + (MOVETYPE_BOUNCE * random ()));
		newmis.th_die = ProximityGrenadeExplode;
		newmis.nextthink = time + 1;
		newmis.bbmins = '-1.000 -1.000 -1.000';
		newmis.bbmaxs = '1.000 1.000 1.000';
		newmis.classname = "ProximityBomb";
	}
	
	// These projectile fly like grenades but are really spikes!
	if (proj_type == CT_PROJ_SPID || proj_type == CT_PROJ_VORE ||
		proj_type == CT_PROJ_SWAMP || proj_type == CT_PROJ_ELF ||
		proj_type == CT_PROJ_FLESH || proj_type == CT_PROJ_FLESHP) {
		newmis.touch = Touch_Projectile;
		newmis.nextthink = time + LIFE_PROJECTILE;
		newmis.think = SUB_Remove;
		newmis.bodyfadeaway = TRUE;
	}

	newmis.mangle = dir;	// Save for later
	newmis.velocity = newmis.mangle; // Standard projectile setup (origin, size and velocity)
	newmis.avelocity = avel;
	newmis.angles = vectoangles(newmis.velocity);
	setsize (newmis, newmis.bbmins, newmis.bbmaxs);
	setorigin (newmis, org);
	if (newmis.physicsflags) {
		Gyro_Object_Activate(newmis,MASS_GRENADE);
		if (newmis.physicsflags & PHYS_GYRO_BOUYANT) Gyro_Object_SetBouyancy(newmis,BOUY_GRENADE);
		if (newmis.physicsflags & PHYS_GYRO_TURBULENCE) Gyro_Object_SetTurbulence(newmis,TURB_GRENADE, 0.95);
		if (newmis.physicsflags & PHYS_GYRO_MOTIONRESIST) Gyro_Object_SetResistance(newmis,RESIST_GRENADE);
		if (newmis.physicsflags & PHYS_GYRO_AERODYNAMIC) Gyro_Object_SetResistance(newmis,AERO_GRENADE);
	}
};

void() MonsterGrenadeSound = { sound (self, CHAN_WEAPON, "ad171/weapons/gl_loadshort.wav", 0.1+random()*0.5, ATTN_LOW); }; // [FUNCTION], play generic load grenade sound.

float() MonsterGrenadeSpeed ={ return SPEED_MONGRENADE + (skill * SPEED_MONGLSKILL); }; // [FUNCTION], return generic attack speed.

// Fire grenade at enemy origin
void(vector grenade_org, vector grenade_enemyorg) MonsterFireGrenade = { // [FUNCTION]
	local vector ang, dir, avel;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	// Is Z aware disabled?
	if ( query_configflag(SVR_ZAWARE) || self.no_zaware ) {
		makevectors (self.angles);
		dir = normalize(grenade_enemyorg - grenade_org);
		// Default grenade speed (player = 600)
		dir = dir * SPEED_PLAYGRENADE;
		dir_z = ELEV_ZAXIS;
	} else {
		// Z Aware tracking is ENABLED (AI track player much better)
		// One final angle adjustment (based on actual projectile origin)
		self.attack_speed = MonsterGrenadeSpeed();
		self.attack_elev = SUB_Elevation(self.attack_elev, grenade_org, grenade_enemyorg, self.attack_speed);
		ang = vectoangles(grenade_enemyorg - grenade_org);
		ang_x = -self.attack_elev;
		makevectors (ang);
 		dir = v_forward * self.attack_speed;
	}

	avel = vecrand(100,200,FALSE);
	if (self.spawnflags & OGRE_MULTI || self.weapon == IT_MULTI_GRENADE) {
		Launch_Grenade(grenade_org, dir, avel, CT_PROJ_GLMONMULTI);
	} else {
		if (self.weapon == IT2_PROXIMITY_GUN) Launch_Grenade(grenade_org, dir, avel, CT_PROJ_GLMONPROX);
		else Launch_Grenade(grenade_org, dir, avel, CT_PROJ_GLMON);
	}
};

// Ejecting Shell Casing for Shotguns
void() Touch_ShellCasing = { // [FUNCTION]
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner || other == self.master) return;
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.touch = SUB_Null;
	if (random() < 0.5) sound(self, CHAN_VOICE, "ad171/weapons/shellc.wav", random()*0.25, ATTN_LOW);		
};

void(float shell_qty) Launch_ShellCasing = { // [FUNCTION]
	local vector org, dir, avel;
	
	if ( self.health < 1 ) return;
	if (query_configflag(SVR_SHOTGCASE)) return;

	if (self.flags & FL_CLIENT) makevectors (self.v_angle);
	else makevectors (self.angles);
	org = self.origin + v_up*10;
	while (shell_qty > 0) {
		dir = -v_right*75 + v_forward*(random()*50) + v_up*(100 + random()*100);
		avel = vecrand(0,300,TRUE);
		if (self.in_a_vehicle) Launch_Grenade(org, dir, avel, CT_PROJ_NAILC);
		else Launch_Grenade(org, dir, avel, CT_PROJ_SHELLC);
		shell_qty = shell_qty - 1;
	}
};

void () HIP_LaserTouch = { // [FUNCTION]
	local vector org, spot1, spot2, oldvel, dir, dir2;

	self.owner = world;
	self.cnt = (self.cnt + TRUE);
	if (pointcontents(self.origin) == CONTENT_SKY) { remove (self); return; }

	oldvel = normalize (self.old_velocity);
	spot1 = (self.origin - (16 * oldvel));
	spot2 = (self.origin + (16 * oldvel));
	traceline (spot1,spot2,FALSE,self);
	self.origin = trace_endpos;
	org = self.origin;
	if (self.master.tome_finished && self.tome_finished) {
		dir = (oldvel + (2 * trace_plane_normal));
		dir = normalize (dir);
		dir = (self.speed * dir);
		HIP_LaunchLaser (self.origin, dir * (crandom() * 20), TRUE);
		newmis.owner = other;
		newmis.master = self.master;
		newmis.tome_finished = FALSE; // Prevent infinite spawning loop
		HIP_LaunchLaser (self.origin, dir * (crandom() * 20), TRUE);
		newmis.owner = other;
		newmis.master = self.master;
		newmis.tome_finished = FALSE; // Prevent infinite spawning loop
	}

	if (other.health > 0 && other.takedamage) {
		if (self.lastvictim == other) self.dmg = (self.dmg / 2);
		spawn_touchblood (self, other, self.dmg);
		T_Damage (other,self,self.lastvictim,self.dmg,DAMARMOR);
	} else {
		if (self.cnt == 3 || random() < 0.15) Tent_Point(TE_GUNSHOT,org);
		else {
			// Ricochet up to 3 times
			if (!self.master.tome_finished) {
				self.dmg = (0.900 * self.dmg); // Reduce damage 10% each ricochet, we lose energy on impact, unless tome of power
				self.velocity = (oldvel + (2 * trace_plane_normal)); // Mirror direction along impact plane normal
				self.velocity = normalize (self.velocity);
				self.velocity = (self.speed * self.velocity);
				self.old_velocity = self.velocity;
				if (self.flags & FL_ONGROUND) self.flags = (self.flags - FL_ONGROUND);
			} else {
				BounceShot_Move();
				BounceShot_Seek(); // Redirect to an enemy.
			}
			sound (self,CHAN_WEAPON,"hipnotic/weapons/laserric.wav",TRUE,ATTN_STATIC);
			return;
		}
	}
	sound (self,CHAN_WEAPON,SOUND_LASER_HIT,TRUE,ATTN_STATIC);
	remove (self);
};

void () HIP_LaserThink = { // [FUNCTION]
	if (self.owner.tome_finished) { spark_spawn(); spark_spawn(); spark_spawn(); }
	if ( (time > self.attack_finished) ) { remove (self); return; }

	if ( (self.flags & FL_ONGROUND) ) self.flags = (self.flags - FL_ONGROUND); // Keep it bouncing.
	self.velocity = self.old_velocity;
	self.angles = vectoangles (self.velocity);
	self.nextthink = (time + 0.100);
};

void (vector org, vector vec, float light) HIP_LaunchLaser = { // [FUNCTION]
	if (self.perms | IT_BLASTER && self.weapon == IT_SHOTGUN) sound (self,CHAN_WEAPON,"enforcer/enfire.wav",TRUE,ATTN_NORM);
	else sound (self,CHAN_WEAPON,"hipnotic/weapons/laserg.wav",TRUE,ATTN_NORM);

	vec = normalize (vec);
	newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
	newmis.owner = newmis.master = self;
	if (newmis.master.tome_finished) newmis.tome_finished = TRUE;
	newmis.classname = "hiplaser";
	newmis.lastvictim = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	if (light || self.owner.tome_finished) newmis.effects = EF_DIMLIGHT;
	if (self.perms | IT_BLASTER && self.weapon == IT_SHOTGUN) setmodel (newmis,"progs/ad171/proj_laz.mdl");
	else setmodel (newmis,"progs/hipnotic/lasrspik.mdl");

	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
	setorigin (newmis,org);
	newmis.speed = 1000.000;
	newmis.dmg = 18.000;
	if (self.perms | IT_BLASTER && self.weapon == IT_SHOTGUN) newmis.dmg = 24; // slight boost for blaster to at least match AD shotgun boost
	if (self.owner.tome_finished) newmis.dmg = newmis.dmg * 2;
	newmis.velocity = (vec * newmis.speed);
	newmis.old_velocity = newmis.velocity;
	newmis.angles = vectoangles (newmis.velocity);
	newmis.avelocity = '0 0 400';
	newmis.nextthink = time;
	newmis.attack_finished = (time + MOVETYPE_FLY);
	newmis.think = HIP_LaserThink;
	newmis.touch = HIP_LaserTouch;
	newmis.count = FALSE;
};

void (vector p1, vector p2, entity from, float damage) HIP_HammerDamage = { // [FUNCTION]
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

void () HIP_LightningThink = { // [FUNCTION]
	local vector org, dst, vec, end;
	local entity head, selected;
	local float cur_dist, head_dist, dot, oldstate, dam;

	if (time > self.delay) {
		if (self.enemy) self.enemy.struck_by_mjolnir = FALSE;
		remove (self);
		return;
	}

	oldstate = self.state;

	// Multi-lightning effect of Mjolnir
	if (self.state == FALSE) {
		self.enemy = world;
		selected = world;
		cur_dist = self.distance;
		head = findradius (self.owner.origin,self.distance);
		while ( head ) {
			if ( (!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT))) ) {
				if ( ((visible (head) && (head != self.owner.owner) && (head != self.owner)) && (head.health > FALSE)) ) {
					head_dist = vlen ((head.origin - self.lastvictim.origin));
					if ( ((head_dist < cur_dist) && (head.struck_by_mjolnir == FALSE)) && !Ally_Check(head,self.owner) && !Ally_Check(head,self.owner.owner)) {
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}
		if ( (selected != world) ) {
			self.state = TRUE;
			self.enemy = selected;
			self.enemy.struck_by_mjolnir = TRUE;
		} else {
			makevectors (self.v_angle);
			org = self.owner.origin;
			end = (org + (v_forward * 200));
			end = (end + (((400.000 * random ()) - 200) * v_right));
			traceline (org,end,TRUE,self);
			Tent_Beam (TE_LIGHTNING2, self, org, trace_endpos);
			self.nextthink = (time + 0.100);
			return ;
		}
	}
   org = self.lastvictim.origin;
   dst = (self.enemy.absmin + (0.250 * (self.enemy.absmax - self.enemy.absmin)));
   dst = (dst + ((random () * 0.500) * (self.enemy.absmax - self.enemy.absmin)));
   traceline (org,dst,TRUE,self.owner.owner);
   if (trace_fraction != 1 || self.enemy.health <= 0) {
      self.enemy.struck_by_mjolnir = FALSE;
      self.state = 0;
      self.nextthink = time + 0.1;
      return;
   }
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,org_x);
   WriteCoord (MSG_BROADCAST,org_y);
   WriteCoord (MSG_BROADCAST,org_z);
   WriteCoord (MSG_BROADCAST,trace_endpos_x);
   WriteCoord (MSG_BROADCAST,trace_endpos_y);
   WriteCoord (MSG_BROADCAST,trace_endpos_z);
   vec = normalize ((self.enemy.origin - self.owner.origin));
   dot = (vec * self.owner.movedir);
   head = self;
   self = self.owner.owner;
   if (!oldstate) dam = 80;
   else dam = 30;

   if (dot > 0.3) HIP_HammerDamage (org,trace_endpos,self,dam);
   else HIP_HammerDamage (org,trace_endpos,self,(dam * 0.500));
 
   self = head;
   self.nextthink = (time + 0.200);
};

void (entity prev, entity own, float dst) HIP_SpawnMjolnirLightning = { // [FUNCTION]
   local entity light;

   light = spawn ();
   light.delay = (time + 0.800);
   light.state = FALSE;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = FALSE;
   light.v_angle_z = FALSE;
   light.origin = own.origin;
   light.think = HIP_LightningThink;
   light.nextthink = time;
};

void () HIP_SpawnMjolnirBase = { // [FUNCTION]
   local entity light;

	if (self.tome_finished) { Thor_Slam(30,80); return;}

   light = spawn ();
   light.origin = trace_endpos;
   light.flags = FALSE;
   light.owner = self;
   light.struck_by_mjolnir = TRUE;
   light.think = SUB_Remove;
   light.nextthink = (time + TRUE);
   sound (light,CHAN_AUTO,"hipnotic/weapons/mjolslap.wav",TRUE,ATTN_NORM);
   sound (light,CHAN_WEAPON,"hipnotic/weapons/mjolhit.wav",TRUE,ATTN_NORM);
   makevectors (self.v_angle);
   light.movedir = v_forward;
   HIP_SpawnMjolnirLightning (light,light,350.000);
   HIP_SpawnMjolnirLightning (light,light,350.000);
   HIP_SpawnMjolnirLightning (light,light,350.000);
   HIP_SpawnMjolnirLightning (light,light,350.000);
	ShockWave(trace_endpos + '0 0 4',RING_BLUE,6,"progs/drake/s_wave.spr",FALSE);
};

void () HIP_FireMjolnirLightning = { // [FUNCTION]
   local float cells;

   if ( (self.waterlevel > TRUE) ) {
      cells = self.ammo_cells;
      self.ammo_cells = FALSE;
      discharged = TRUE;
      T_RadiusDamage (self,self,(35.000 * cells),world, DAMAGEALL);
      discharged = FALSE;
      W_SetCurrentAmmo (self);
      return ;
   }
   self.ammo_cells = (self.ammo_cells - 15.000);
   self.currentammo = (self.currentammo - 15.000);
   HIP_SpawnMjolnirBase();
};

void () ProximityExplode = { // [FUNCTION]
   T_RadiusDamage (self,self.owner,95.000,world, DAMAGEALL);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();
};

void () ProximityGrenadeExplode = { // [FUNCTION]
   self.takedamage = DAMAGE_NO;
   NumProximityGrenades = (NumProximityGrenades - TRUE);
   self.deathtype = "exploding";
   self.nextthink = (time + 0.100);
   self.owner = self.lastvictim;
   self.think = ProximityExplode;
};

void () ProximityGrenadeTouch = { // [FUNCTION]
   if (other == self) return;
   if (other.classname == self.classname) return;

   self.movetype = MOVETYPE_TOSS;
   if (self.state) return;
   if (vlen(other.velocity) > 0) { ProximityGrenadeExplode (); self.think(); return; }
   if (other.takedamage == DAMAGE_AIM) { ProximityGrenadeExplode (); self.think(); return; }

   sound (self,CHAN_WEAPON,"weapons/bounce.wav",TRUE,ATTN_NORM);
   self.movetype = MOVETYPE_NONE;
   setsize (self,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.state = TRUE;
   self.spawnmaster = other;
};

void () ProximityBomb = { // [FUNCTION]
   local entity head;
   local float blowup;

   if ( (((time > self.delay) || (NumProximityGrenades > 64.000)) || (vlen (self.spawnmaster.velocity) > FALSE)) ) { ProximityGrenadeExplode (); self.think(); return; }

   self.owner = world;
   self.takedamage = DAMAGE_YES;
   head = findradius (self.origin,140.000);
   blowup = FALSE;
   while ( head ) {
      if ((head != self && head.health > FALSE) && (head.flags & FLx_CREATURE) && head.classname != self.classname) blowup = TRUE;
      if (head.classname == self.classname && head.state == FALSE) blowup = TRUE;
      traceline(self.origin,head.origin,TRUE,self);
      if (trace_fraction != TRUE) blowup = FALSE;
      if (blowup) {
         sound (self,CHAN_WEAPON,"hipnotic/weapons/proxwarn.wav",TRUE,ATTN_NORM);
         ProximityGrenadeExplode ();
         self.nextthink = (time + 0.500);
         return;
      }
      head = head.chain;
   }
   self.nextthink = (time + 0.250);
};