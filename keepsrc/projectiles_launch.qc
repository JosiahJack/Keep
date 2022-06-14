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
// Function count: 81
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

entity(entity attacker, vector org, vector dir, float radius, float scope) SuperRocket_Target;
void() MultiGrenadeExplode;
void() ProximityBomb;
void() ProximityGrenadeExplode;
void() SuperGrenade_Think;
void() SuperRocket_Think;
void (vector org, vector vec, float light) HIP_LaunchLaser;
void() W_FireRocket;
void (vector pos) placebullethole;
void(float damage, vector dir, float addedtime) TraceExploAttack;
void() nehahra_wreckbsp;
void(float reload) W_Reload;
void() W_FireThor;
void() player_failedairgun1;
void(float num_bubbles) death_bubbles;
void() player_airgun1;

// OLD STYLE BULLET SYSTEM (HITSCAN)
void() ClearMultiDamage = { // [FUNCTION]
    multi_ent = world;
    multi_damage = 0;
};

void() ApplyMultiDamage = { // [FUNCTION]
    if (!multi_ent) return;
    T_Damage (multi_ent, self, self, multi_damage,DAMARMOR);
};

void(entity hit, float damage) AddMultiDamage = { // [FUNCTION]
    if (!hit) return;
    
    if (hit != multi_ent) {
        ApplyMultiDamage ();
        multi_damage = damage;
        multi_ent = hit;
    }  else {
        multi_damage = multi_damage + damage;
	}
};

void(vector org, float marker_time) MarkAttack = { // [FUNCTION]
	newmis = spawn();
	newmis.classtype = CT_DEVMARKER;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	setmodel(newmis, MODEL_BROKEN);
	newmis.skin = rint(random()*7);
	setorigin(newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.think = SUB_Remove;
	newmis.nextthink = time + marker_time;
};

void(float damage, vector dir) TraceAttack = { // [FUNCTION]
	local vector vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos - dir*4;
	if (!check_skycontent(org)) { // Check for sky content? skies don't impact or bleed
		if (trace_ent.takedamage) {
			if (trace_ent.resist_shells > 0) Resist_Effects(trace_ent,org,vel,damage,AM_SHELLS,trace_ent.pain_sound,""); // Show bullet resistance as small blood+gunshot+smoke
			else {
				if (trace_ent.flags & FL_MONSTER) SpawnBlood (trace_ent, org, vel*0.2, damage*2,0); // Hitting monsters does twice the amount of blood effects
				else SpawnBlood (trace_ent, org, vel*0.2, damage,0);
			}
			AddMultiDamage (trace_ent, damage); // Keep adding up the damage
			if (trace_ent.classtype == CT_TARGETDUMMY) MarkAttack(org, trace_ent.wait); // Check for target dummy (manually create marker)
		} else Tent_Point(TE_GUNSHOT,org); // Hit something that does not bleed (often world)
	}
};

void(float shotcount, vector spread) FireBullets = { // [FUNCTION]
	local vector direction, src, dir;
	local float addedtime, bullet;
	
	bullet = 0;
	makevectors(self.v_angle);
	if (self.flags & FL_CLIENT) {
		// Auto aim assist (builtin function 44)
		if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self, SPEED_PLAYAIM);
		// Straight line forward where crosshair is pointing
		else dir = normalize(v_forward * SPEED_PLAYAIM);
	} else {
		// A monster attacking a monster will not dodge
		if (self.enemy.flags & FL_MONSTER) dir = normalize(self.enemy.origin - self.origin);
		else {
			// fire somewhat behind the player
			// so a dodging player is harder to hit
			dir = self.enemy.origin - self.enemy.velocity*0.2;
			dir = normalize(dir - self.origin);
		}
	}

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0) {
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0) {
			if (self.tome_finished) {
				if (shotcount == 1) addedtime = 0;
				else addedtime = shotcount * 0.05;
				TraceExploAttack(EXSHELL_DAMAGE, direction, addedtime);
			} else {
				if (self.classtype == CT_MONENF_GUNNER) TraceAttack(9, direction); // More damage
				else TraceAttack(DAMAGE_SHELL, direction);

				if (!bullet && (trace_ent == world) && (world.hipnoticoptions & HIPNOTIC_BULLETHOLES)) { // Default is off.
					placebullethole(trace_endpos);
					bullet = TRUE;
				}
			}
		}
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
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

void() SetNewmisCommonPlasmaParameters = {
	newmis.classgroup = CG_PROJCELLS;
	newmis.touch = Touch_PlasmaProjectile;
	newmis.count = 1 + rint(random()*2);	// Default particles
	newmis.speed = 0.02;					// Next function interval (very high tick)
	newmis.think = Particle_Plasma;			// Manually generate blue/white particle trail
	if (newmis.poisonous) newmis.mdl = MODEL_PROJ_PLASMAGRN;
	else newmis.mdl = MODEL_PROJ_PLASMA;
};

vector ( vector org, vector targofs) SetNewmisCommonRocketParameters = {
	local float dist, flytime;
	local vector dir;
	
	newmis.v_angle = targofs;				// Store for later
	newmis.classgroup = CG_PROJROCKETS;
	newmis.touch = Touch_HomingMissile;
	dir = normalize((self.enemy.origin + newmis.v_angle) - org); // Aim the missile slightly above enemy
	dist = vlen (self.enemy.origin - org);
	flytime = dist * 0.002;
	if (flytime < 0.1) flytime = 0.1;
	newmis.nextthink = flytime + time;
	newmis.think = Steer_HomingMissile;
	if (self.no_trackondeath == NEGATIVE) newmis.no_trackondeath = FALSE; // Setup default homing missile mode.  Priority : ENTITY > IMPULSE > WORLDSPAWN
	else if (self.no_trackondeath == TRUE) newmis.no_trackondeath = TRUE;
	else if (map_notrackondeath == TRUE) newmis.no_trackondeath = TRUE;
	else newmis.no_trackondeath = FALSE;

	newmis.waitmin = time + 3; // Allow 3s for the homing missile to travel away
	newmis.attack_track = dir; // Standard projectile setup (origin, size and velocity)
	return dir;
};

void(vector org, vector dir, float proj_type, float proj_speed) launch_projectile = { // [FUNCTION]
	local vector vec;
	
	if (entity_pcontent(org)) return; // Check if there is space to spawn entity

	newmis = spawn ();
	newmis.owner = newmis.oldenemy = self;
	newmis.enemy = self.enemy;				// Used for homing target
	newmis.classname = "projectile";	// Name, not really used anymore
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJALL;	// Ammo type (default)
	newmis.bbmins = VEC_ORIGIN;
	newmis.bbmaxs = VEC_ORIGIN;
	newmis.speed = proj_speed; // Standard projectile setup (origin, size and velocity)
	newmis.attack_speed = proj_speed;	// Save for later
	if (newmis.classtype == CT_PROJ_NG || newmis.classtype == CT_PROJ_SNG
	    || newmis.classtype == CT_PROJ_REFNG) {
		newmis.classgroup = CG_PROJNAILS;
	}
	if (newmis.classtype == CT_PROJ_MONNG || newmis.classtype == CT_PROJ_REFLNG
	    || newmis.classtype == CT_PROJ_LAVASNG || newmis.classtype == CT_PROJ_LAVANG) {
		newmis.classgroup = CG_PROJLAVANAILS;
	}

	// Switch model collision based on auto aim functionality.  Monsters always use large collision (otherwise infighting would be less)
	if (self.flags & FL_CLIENT) {
		if (playerprojsize == 0) newmis.movetype = MOVETYPE_FLYMISSILE;	// Large collision
		else newmis.movetype = MOVETYPE_FLY;		// Small collision

		if ((self.moditems & IT_ARTPIERCE)
			&& (newmis.classgroup == CG_PROJNAILS || newmis.classgroup == CG_PROJLAVANAILS)) {
			newmis.projeffect = IT_ARTPIERCE; // Check if the player has the nail piercer effect active
			newmis.attack_ricochet = 7;
		}
	} else newmis.movetype = MOVETYPE_FLYMISSILE; // Default = large collision

	newmis.solid = SOLID_BBOX;
	newmis.touch = Touch_Projectile;
	newmis.nextthink = time + LIFE_PROJECTILE;
	newmis.think = SUB_Remove;
	newmis.poisonous = newmis.owner.poisonous;
	
	// Setup model
	if (proj_type == CT_PROJ_NG) newmis.mdl = MODEL_PROJ_NG;
	else if (proj_type == CT_PROJ_SNG) newmis.mdl = MODEL_PROJ_SNG;
	else if (proj_type == CT_PROJ_LAVANG || proj_type == CT_PROJ_LAVASNG) newmis.mdl = "progs/lspike.mdl";
	else if (proj_type == CT_PROJ_REFNG) newmis.mdl = "progs/lspike.mdl";
	else if (proj_type == CT_PROJ_MCOR1) {
		newmis.mdl = "progs/madfox/proj_mcornflame.mdl";
		newmis.classgroup = CG_PROJLAVANAILS;
		newmis.attack_ricochet = 7; // Seriously!??
	} else if (proj_type == CT_PROJ_MCOR1) {
		newmis.mdl = "progs/q15/s_spike.mdl"; // silver thorn
		newmis.classgroup = CG_PROJNAILS;
		newmis.projeffect = IT_ARTPIERCE; // Whoa hey, that's not fair!  Tough.  -Qmaster
		newmis.attack_ricochet = 5; // Bruh!!
	} else if (proj_type == CT_PROJ_REFLNG) newmis.mdl = MODEL_PROJ_NG;
	else if (proj_type == CT_PROJ_SANTA) {
		newmis.mdl = MODEL_PROJ_SNOWBALL; // Santa Snowball machine gun!
		newmis.classgroup = CG_PROJICE;
	} else if (proj_type == CT_PROJ_BOLT1) {
		newmis.mdl = MODEL_PROJ_BOLT1; // Crossbow Knight has poison/regular bolts
		newmis.movetype = MOVETYPE_FLY; // Crossbow bolts are small
		newmis.bodyfadeaway = TRUE; // and stick around
	} else if (proj_type == CT_PROJ_BOLT2) {
		newmis.mdl = "progs/ad171/proj_bolt2.mdl";
		newmis.poisonous = 1;
		newmis.movetype = MOVETYPE_FLY; // Crossbow bolts are small
		newmis.bodyfadeaway = TRUE; // and stick around
	} else if (proj_type == CT_PROJ_DARTARROW) {
		newmis.mdl = "progs/drake/arrow.mdl";
		newmis.movetype = MOVETYPE_FLY; // Crossbow bolts are small
		newmis.bodyfadeaway = TRUE; // and stick around
	} else if (proj_type == CT_PROJ_HKN) newmis.mdl = MODEL_PROJ_HKN;
	else if (proj_type == CT_PROJ_HKN_BLUE) newmis.mdl = "progs/newhouse/vk_spike.mdl";
	else if (proj_type == CT_PROJ_HKN2) newmis.mdl = "progs/q15/k_spike.mdl"; // Warlord spike (Quake 1.5)
	else if (proj_type == CT_PROJ_ENFHKN) newmis.mdl = MODEL_PROJ_HKN;
	else if (proj_type == CT_PROJ_WIZ) newmis.mdl = MODEL_PROJ_WIZ;
	else if (proj_type == CT_PROJ_MPOISON) newmis.mdl = MODEL_PROJ_MPOISON;
	else if (proj_type == CT_PROJ_MBLOOD) newmis.mdl = MODEL_PROJ_MBLOOD;
	else if (proj_type == CT_PROJ_WBONE) {
		if (newmis.poisonous) newmis.mdl = MODEL_PROJ_WPOISON; // Wraith fire bones (nails) can be poisonous as well
		else newmis.mdl = MODEL_PROJ_WBONE;
	} else if (proj_type == CT_PROJ_WPOISON) newmis.mdl = MODEL_PROJ_WPOISON;
	else if (proj_type == CT_PROJ_MONNG) newmis.mdl = MODEL_PROJ_NGRED; // Monster Nails (MONNG) = Lava Nails
	else if (proj_type == CT_PROJ_SCORP) newmis.mdl = MODEL_PROJ_SCORP;
	else if (proj_type == CT_PROJ_FURY2) newmis.mdl = MODEL_PROJ_FURY2;
	else if (proj_type == CT_PROJ_NOUR1) newmis.mdl = MODEL_PROJ_NOUR1;
	else if (proj_type == CT_PROJ_BLBOLT) { // Boglord / Fire Shambler nail/lightning attack
		if (self.spawnflags & MON_BOGL_STRONG) { 
			newmis.classtype = CT_PROJ_BLBOLT2;
			newmis.mdl = MODEL_PROJ_BLORDBOLT2;
		} else newmis.mdl = MODEL_PROJ_BLORDBOLT1;
	} else if (proj_type == CT_PROJ_WILLY) newmis.mdl = "progs/w_spike.mdl";
	else if (proj_type == CT_PROJ_LASER || proj_type == CT_PROJ_RICLASER) {
		newmis.movetype = MOVETYPE_FLY; // lasers/plasma are small
		newmis.effects = EF_DIMLIGHT; // and glowing
		if (proj_type == CT_PROJ_RICLASER) { // Ricochet special setup
			newmis.attack_ricochet = 3; // Allow for projectile to ricochet up to 3 times
			newmis.dmg = DAMAGE_LASER; // Damage is reduced 10% every time it ricochet's.
			newmis.attack_lifetime = time + LIFE_PROJECTILE; // Shift projectile end of life to variable instead
			newmis.nextthink = time + 0.1;
			newmis.think = Think_Projectile; // Need special think function to reset velocity/angle
		}
		
		if (newmis.poisonous) newmis.mdl = MODEL_PROJ_LASERGRN; // Select model type based on poisonous key
		else newmis.mdl = MODEL_PROJ_LASER;

		// If DP/FTE engine use new particle trail, glowing for Fitz engines
		if (ext_dppart) {
			if (newmis.poisonous) newmis.traileffectnum = particleeffectnum(DPP_TRPOISON);
			else newmis.traileffectnum = particleeffectnum(DPP_TRLASER);
		}
	} else if (proj_type == CT_PROJ_GROCK) {
		if (random() < 0.5) newmis.mdl = MODEL_PROJ_GROCK1;
		else newmis.mdl = MODEL_PROJ_GROCK2;
		newmis.frame = rint(random()*9);
		newmis.avelocity = vecrand(0,200,TRUE);
	} else if (proj_type == CT_MONARMYPLASMA) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONELIMATOR) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONCENTURION) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONGAUNT) {
		SetNewmisCommonPlasmaParameters();
		if (newmis.poisonous) newmis.mdl = MODEL_PROJ_GAPLASMAGRN;
		else newmis.mdl = MODEL_PROJ_GAPLASMA;
	} else if (proj_type == CT_MONDEFLECTOR) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONEEL) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONSEEKER) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONMAMMOTH) {
		SetNewmisCommonPlasmaParameters();
	} else if (proj_type == CT_MONTURRETB) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_LASERBLUE;
	} else if (proj_type == CT_MONFLOYD) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_LASERBLUE;
	} else if (proj_type == CT_MONMINOTAUR) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_MPLASMA;
	} else if (proj_type == CT_SUMMONLIGHT) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_LIGHTNING2;
	} else if (proj_type == CT_MONNOUR) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_LIGHTNING2;
	} else if (proj_type == CT_REFLECTLIGHT) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_LIGHTNING2;
		newmis.classgroup = CG_PROJCELLS;
	} else if (proj_type == CT_REFLECTPLASMA) {
		SetNewmisCommonPlasmaParameters();
		newmis.mdl = MODEL_PROJ_PGPLASMA;
		newmis.avelocity = vecrand(0,300,TRUE);	// randomize avel
		newmis.angles_y = rint(random()*360);	// Random angle
		newmis.frame = 3;						// Medium size
		newmis.classgroup = CG_PROJCELLS;
	} else if (proj_type == CT_PROJ_SHAL) {
		dir = SetNewmisCommonRocketParameters(org,dir);
		newmis.mdl = MODEL_PROJ_SHAL;
		newmis.dpp_name = DPP_TEVORESPIKE;
		newmis.avelocity = vecrand(100,200,FALSE);
	} else if (proj_type == CT_PROJ_SERG) {
		dir = SetNewmisCommonRocketParameters(org,dir);
		newmis.mdl = MODEL_PROJ_SERG;
		newmis.dpp_name = DPP_TEEXPLODE;
		newmis.avelocity = vecrand(100,200,FALSE);
	} else if (proj_type == CT_PROJ_SHUB1) {
		dir = SetNewmisCommonRocketParameters(org,dir);
		newmis.mdl = MODEL_PROJ_SHUB1;
		newmis.dpp_name = DPP_TEEXPLODE;
		newmis.avelocity = vecrand(100,200,FALSE);
		makevectors(self.angles); // The angles key will reverse direction for up-side-down Shub.
		dir = v_up*0.5; // Push the homing missing up from center.
	} else if (proj_type == CT_PROJ_GL) newmis.mdl = MODEL_PROJ_GRENADE; // proj_gl is used by the player (separate so easier to change)
	else if (proj_type == CT_PROJ_GLSUPER) {
		newmis.mdl = MODEL_PROJ_GRENADE;
		newmis.master = self;
		newmis.movetype = MOVETYPE_TOSS;
		newmis.speed = 800; // Was 600, too slow.
		vec = '0 0 200';
		if (self.v_angle_x) {
			vec = vec + crandom()*v_right*10;
			vec = vec + crandom()*v_up*10;
		}
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
		newmis.mdl = "progs/rogue/mervup.mdl";
		newmis.touch = MultiGrenadeTouch;
		newmis.think = MultiGrenadeExplode;
		newmis.lefty = FALSE;
		newmis.nextthink = time + 1;
		newmis.classname = "MultiGrenade";
	} else if (proj_type == CT_PROJ_GLMON) { 
		if (newmis.poisonous) newmis.mdl = MODEL_PROJ_GRENADEGRN; // proj_glmon is used by any monster firing grenades
		else newmis.mdl = MODEL_PROJ_GRENADE;
	} else if (proj_type == CT_PROJ_FLESH) {
		if (newmis.poisonous) newmis.mdl = MODEL_PROJ_FLESHP;
		else newmis.mdl = MODEL_PROJ_FLESH;
	} else if (proj_type == CT_PROJ_FLESHP) {
		newmis.mdl = MODEL_PROJ_FLESHP;
		newmis.poisonous = TRUE;
		newmis.noise = "ad171/wraith/bounce.wav";
	} else if (proj_type == CT_PROJ_MEGG) {
		if (self.classtype == CT_MONWRAITH) {
			newmis.mdl = MODEL_PROJ_WEGG;
			newmis.noise = "ad171/wraith/bounce.wav";
		} else if (self.classtype == CT_MONSHAL || self.classtype == CT_MONSHALBOSS) {
			newmis.mdl = MODEL_PROJ_SEGG;
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
		newmis.mdl = MODEL_PROJ_SPID;
		newmis.frame = rint((random() * 9));
	} else if (proj_type == CT_PROJ_ELF) {
		newmis.mdl = MODEL_PROJ_ELF;
		newmis.frame = rint((random() * 9));
		newmis.classgroup = CG_PROJICE;
	} else if (proj_type == CT_PROJ_SWAMP) {
		newmis.mdl = MODEL_PROJ_SWAMP;
		newmis.frame = rint((random() * 9));
	} else if (proj_type == CT_PROJ_VORE) {
		newmis.mdl = MODEL_PROJ_VORE;
		newmis.frame = rint((4 + random() * 4));
	} else if (proj_type == CT_PROJ_NOUR2) {
		newmis.mdl = MODEL_PROJ_NOUR2B;
		newmis.skin = self.skin;
		newmis.frame = 7; // Large size
		newmis.noise = "ad171/wraith/bounce.wav";
	} else if (proj_type == CT_PROJ_CHTHON2) {
		newmis.mdl = MODEL_PROJ_CHTHON1;
		newmis.skin = self.skin;
		newmis.frame = rint((random() * 9));
		newmis.noise = "ad171/wraith/bounce.wav";
		newmis.dmg = self.pos3_z;
	} else if (proj_type == CT_PROJ_SHUB2) {
		newmis.mdl = MODEL_PROJ_SHUB2;
		newmis.frame = rint((random() * 9));
		newmis.noise = "ad171/wraith/bounce.wav";
		newmis.dmg = self.pos3_z;
	} else if (proj_type == CT_PROJ_SHELLC) {
		newmis.mdl = MODEL_PROJ_SHELLC;
		newmis.touch = Touch_ShellCasing;
		newmis.think = model_fade;
		newmis.nextthink = time + random() + LIFE_SHELLS;
		newmis.ltime = newmis.nextthink;
	} else if (proj_type == CT_PROJ_NAILC) {
		newmis.mdl = "progs/redfield/proj_nailcase.mdl";
		newmis.touch = Touch_ShellCasing;
		newmis.think = model_fade;
		newmis.nextthink = time + random() + LIFE_SHELLS;
		newmis.ltime = newmis.nextthink;
	} else if (proj_type == CT_PROJ_GLMONMULTI) {
		newmis.mdl = MODEL_PROJ_GRENADEMULTI;
		newmis.touch = MultiGrenadeTouch;
		newmis.think = MultiGrenadeExplode;
		newmis.lefty = FALSE;
		newmis.nextthink = time + 1;
		newmis.classname = "MultiGrenade";
	} else if (proj_type == CT_PROJ_GLMONPROX) {
		newmis.mdl = "progs/hipnotic/proxbomb.mdl";
		newmis.touch = ProximityGrenadeTouch;
		newmis.think = ProximityBomb;
		newmis.delay = ((time + 15.000) + (MOVETYPE_BOUNCE * random ()));
		newmis.th_die = ProximityGrenadeExplode;
		newmis.nextthink = time + 1;
		newmis.bbmins = '-1.000 -1.000 -1.000';
		newmis.bbmaxs = '1.000 1.000 1.000';
		newmis.classname = "ProximityBomb";
	}

	if (newmis.think) newmis.nextthink = time + newmis.speed;
	newmis.finalangle = dir;
	newmis.velocity = newmis.finalangle * newmis.speed;
	if (!(self.flags & FL_CLIENT)) {
		newmis.angles = vectoangles(newmis.finalangle);
		if (proj_type == CT_PROJ_SHAL
		    || proj_type == CT_PROJ_SERG
			|| proj_type == CT_PROJ_SHUB1)
			newmis.angles = vectoangles(self.velocity);
	} else {
		newmis.angles = vectoangles(newmis.velocity);
	}
	setmodel(newmis,newmis.mdl);
	setsize(newmis,newmis.bbmins,newmis.bbmaxs);		
	setorigin(newmis,org);
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

void(vector org, vector dir, vector avel, float proj_type) Launch_Grenade = { // [FUNCTION]
local vector vec;

if (entity_pcontent(org)) return; // Check if there is space to spawn entity
	
	newmis = spawn();
	newmis.owner = self;
	newmis.alignment = self.alignment;
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
		newmis.lefty = FALSE;
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
		newmis.lefty = FALSE;
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
	if (proj_type == CT_PROJ_SPID || proj_type == CT_PROJ_VORE
	    || proj_type == CT_PROJ_SWAMP || proj_type == CT_PROJ_ELF
		|| proj_type == CT_PROJ_FLESH || proj_type == CT_PROJ_FLESHP) {
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

void (vector org, vector vec, float light) HIP_LaunchLaser = { // [FUNCTION]
	if (self.perms | IT_BLASTER && self.weapon == IT_SHOTGUN) sound (self,CHAN_WEAPON,"enforcer/enfire.wav",TRUE,ATTN_NORM);
	else sound (self,CHAN_WEAPON,"hipnotic/weapons/laserg.wav",TRUE,ATTN_NORM);

	vec = normalize (vec);
	newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
	newmis.owner = newmis.master = self;
	newmis.alignment = self.alignment;
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

// Spawns and launches a payload warhead.  'self' is its parent MIRV.
void(vector start, vector dir, float ang, entity targ1, entity targ2) Warhead_Launch = { // [FUNCTION]
    newmis = spawn();
    if (self.tome_finished) {
		setmodel(newmis,"progs/drake/k_ball.mdl");
		newmis.distance   = 0;    // Constant speed during flight.
        newmis.yaw_speed  = 40;   // Faster turn speed.
        newmis.touch      = AreaBlaster_Touch;
    } else {
		setmodel(newmis,"progs/drake/memissil.mdl");
		newmis.distance   = rint(self.speed * 0.05);  // Acceleration per frame.
		newmis.yaw_speed  = 30;   // Turning speed in degrees.  10 thinks/sec.
		newmis.touch      = T_MissileTouch;
	}
    setsize(newmis, '0 0 0', '0 0 0');
    setorigin(newmis, start);
    newmis.movetype   = MOVETYPE_FLYMISSILE;
    newmis.solid      = SOLID_BBOX;
    newmis.angles     = vectoangles(dir);
    newmis.t_length   = ang;  // Affects warhead's spiraling flight path.
    newmis.t_width    = 0;    // Ditto.
    newmis.speed      = self.speed;
    newmis.dmg        = 95; //self.cnt;
	newmis.pos1 		= '95 0 135';	// Base + Random, Splash
    newmis.delay      = time + 2 + random() * 0.5;    // Grenades are 2.5.
    newmis.style      = self.style;
    newmis.cnt        = AREABLASTER_DAMAGE;
    newmis.wait       = time + 0.2;   // AreaBlaster retouch time.
    newmis.velocity   = dir * self.speed;
    newmis.nextthink  = time + 0.3;   // Give time for payload to spread.
    newmis.think      = Warhead_Think;
	newmis.height = EXPLODE_SMALL;
    newmis.master     = self.master; // Use 'master' instead of 'owner' so warheads can strike attacker.
    newmis.owner      = world;
    newmis.enemy      = targ1;
    newmis.oldenemy   = targ2;
    newmis.classname  = "mirv";   // Use the same obits as its parent.
    newmis.movedir    = dir;
    newmis.think1     = SmallExplosion;
    newmis.tome_finished  = self.tome_finished;
};

// This launches all the warheads in a MIRV's payload.
void() Mirv_Payload = { // [FUNCTION]
    local entity first, head, t1, t2;
    local float loop, hi, theta, qcsin, qccos;
    local vector dir, trig, vx, vy, vz;

    dir = Vangles(self.movedir);
    makevectors(dir); // Get unit vectors along the three axes.
    vx = v_forward; vy = v_right; vz = v_up; // Necessary because CoSine() calls makevectors again and musses them up.
    hi = self.count; // Set loop counter equal to the number of warheads to spawn.
    if (hi < 2) hi = 2; // By definition, MIRVs carry at least two warheads.
    loop = hi;
    hi = 360 / hi;

	// Acquire a list of viable targets.
    if (self.state) head = Payload_Target ();
    else head = world;
    first = head;

    trig = CoSine(10);
    qccos = trig_x; // Approximate cos of 10deg
    qcsin = trig_y; // Approximate sin of 10deg

    if (self.tome_finished) loop = loop * 2;
	// Spawn each payload missile.
    while (loop) {
        if (head) {
			t1 = head;
            head = head.chain2;
            if (!head) head = first;
            t2 = head;
        } else t1 = t2 = world;

        theta = anglemod (loop * hi + 90);
		trig = CoSine(theta);
        dir = (vx*qccos) + ( ((vy*trig_x) + (vz*trig_y))*qcsin );
        Warhead_Launch(self.origin, dir, theta, t1, t2);
        loop = loop - 1;
    }
};

// This spawns and launches a MIRV.
void(vector start, vector dir) Mirv_Launch = { // [FUNCTION]
    newmis = spawn();
    setmodel (newmis, "progs/drake/rocket1.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
    newmis.movetype   = MOVETYPE_FLYMISSILE;
    newmis.solid      = SOLID_BBOX;
    newmis.angles     = vectoangles(dir);
	newmis.classgroup = CG_PROJROCKETS;
    newmis.speed      = 500;
    newmis.yaw_speed  = 40;       // Turning speed in degrees.  5 thinks/sec.
    newmis.delay      = time + 16;    // 500 * 16 = 8K range.  Was T+10.
    newmis.dmg        = 190;          // MIRV damage.  See below for details.
	newmis.pos1		= '190 0 230';
    newmis.count      = COST_MIRV;    // Number of warheads in payload.
    newmis.cnt        = 95;   // Warhead damage, same power as Hip proxy bomb.

	// damage | radius |  volume (4*pi*r*r*r/3)
	//--------+--------+------------
	//    95  |   135  | 10305994.7
	//   190  |   230  | 50965010.4
	//
	// MIRVs release five warheads.  If a MIRV explodes before releasing
	// its payload, make a single large blast with the combined blast volume
	// (not damage) from each warhead.
	//
	// Note that the sphere with 230 radius has roughly five times more volume
	// than the sphere with 135 radius.
	//
	// If you want to change warhead damage, make sure MIRV radius is
	// 1.71 (or cube root of 5) times warhead radius.
    newmis.velocity   = dir * newmis.speed;
    newmis.touch      = Mirv_Touch;
    newmis.nextthink  = time + 0.2;
    newmis.think      = Mirv_Think;
    newmis.master     = newmis.owner    = self;
    newmis.enemy      = world;
    newmis.classname  = "mirv";
    newmis.movedir    = dir;
    newmis.tome_finished  = self.tome_finished;
    newmis.search_time= time;
    newmis.state      = 1;    // Warhead auto-targeting: 0 = off, 1 = on.
    newmis.weapon        = self.weapon;
	newmis.selfweaponismoditems = self.selfweaponismoditems;
    newmis.think1     = BecomeBigBang;    // Use alternate explosion code.
    newmis.th_win     = Mirv_Split;
};

void(entity attacker, vector start, vector dir, float damage,entity targ1, entity targ2) DrunkRocket_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master       = newmis.owner      = attacker;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
    newmis.yaw_speed    = 40;   // Note:  Missiles think 5/sec, not 10/sec.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.movedir      = dir;
    newmis.velocity     = dir * 600;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = damage;
	newmis.classgroup = CG_PROJROCKETS;
    newmis.enemy        = targ1;
    newmis.oldenemy     = targ2;
    newmis.ideal_yaw    = newmis.angles_y;
    newmis.cnt          = 20;   // Random angle used for drunken flight.
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2 + random() * 0.5;    // Grenades are 2.5.
    newmis.nextthink    = time + 0.2;
    newmis.think        = DrunkRocket_Think;
    newmis.think1       = SmallExplosion;
    setall (newmis, "progs/drake/memissil.mdl", '0 0 0', '0 0 0', start);
};

// Splits the missile and launches all payload missiles.
void() Hydra_Split = { // [FUNCTION]
    local vector start, dir, vx, vy, trig;
    local entity t0, t1, t2;
    local float loop, cost;

    loop = self.count;
    cost = loop - 1;
    start = self.origin;
    dir = self.angles;  dir_x = 0 - dir_x;
    makevectors (dir);
    vx = v_forward;
    vy = v_right;
    t0 = t1 = SuperRocket_Target(self.master, start, v_forward, 2000, 0.3); // Search for targets infront of the parent missile.
    while (loop > 0) {
        t2 = t1.chain2;
        if (!t2) t2 = t0;
        loop = loop - 1;
        trig = CoSine((cost - loop * 2) * 10);     // 20 degrees of separation.
        dir = (vx*trig_x) + (vy*trig_y);
        DrunkRocket_Launch(self.master, start, dir, 90, t1, t2);
        t1 = t2;
    }
    remove(self);
};

void (vector org, vector dir) launch_lava_spike = { // [FUNCTION]
	newmis = spawn ();
	newmis.classgroup = CG_PROJNAILS;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles (dir);
	newmis.touch = lavaspike_touch;
	newmis.classtype = CT_PROJ_LAVASPIK;
	newmis.think = SUB_Remove;
	newmis.nextthink = (time + MOVETYPE_TOSS);
	setmodel (newmis,"progs/lspike.mdl");
	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
	setorigin (newmis,org);
	newmis.velocity = (dir * 1000.000);
};

void(float offsetAngle) MiniGrenadeLaunch = { // [FUNCTION]
	local float tempRand;

	newmis = spawn ();
	newmis.classgroup = CG_PROJGRENADES;
	newmis.owner = self.owner;
	newmis.alignment = self.alignment;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "MiniGrenade";
	newmis.v_angle = self.v_angle;
	newmis.v_angle_y = (newmis.v_angle_y + offsetAngle);
	makevectors (newmis.v_angle);
	newmis.velocity = ((v_forward * 100.000) + (v_up * 400));
	tempRand = ((crandom () * 60.000) - 30);
	newmis.velocity = (newmis.velocity + (tempRand * v_forward));
	tempRand = ((crandom () * 40) - 20.000);
	newmis.velocity = (newmis.velocity + (tempRand * v_right));
	tempRand = ((crandom () * 60.000) - 30);
	newmis.velocity = (newmis.velocity + (tempRand * v_up));
	newmis.avelocity = '300.000 300.000 300.000';
	newmis.angles = vectoangles (newmis.velocity);
	newmis.touch = MultiGrenadeTouch;
	setmodel (newmis,"progs/rogue/mervup.mdl");
	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
	setorigin (newmis,self.origin);
	newmis.nextthink = ((time + TRUE) + (crandom () * 0.500));
	newmis.think = MiniGrenadeExplode;
	newmis.th_die = MiniGrenadeExplode;
	Gyro_Object_Activate(newmis,MASS_MINIGRENADE);
	Gyro_Object_SetBouyancy(newmis,BOUY_MINIGRENADE);
	Gyro_Object_SetResistance(newmis,RESIST_MINIGRENADE); // Sluggish in liquids
};

void (float offset, float frameNum) MultiRocketLaunch = { // [FUNCTION]
   local vector aimangle;

   newmis = spawn ();
   newmis.owner = self;
   newmis.alignment = self.alignment;
   newmis.classgroup = CG_PROJROCKETS;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.classname = "MultiRocket";
   newmis.delay = (time + MOVETYPE_STEP);
   newmis.frame = frameNum;
   newmis.touch = MultiRocketTouch;
   if (deathmatch || coop) {
      setmodel(newmis,"progs/rockup_d.mdl");
   } else {
      setmodel(newmis,"progs/rockup.mdl");
   }
   setsize(newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin(newmis,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));
   if (deathmatch || coop) {
      aimangle = self.v_angle;
      aimangle_y = (aimangle_y + (offset * 0.660));
      makevectors(aimangle);
      newmis.velocity = aim(self,1000.000);
      newmis.velocity = (newmis.velocity * 1000.000);
      newmis.angles = vectoangles(newmis.velocity);
      newmis.think = MultiRocketExplode;
      newmis.nextthink = time + 4;
   } else {
      makevectors(self.v_angle);
      newmis.velocity = ((v_forward * 1000.000) - ((v_right * offset) * FL_CLIENT));
      newmis.angles = vectoangles(newmis.velocity);
      newmis.v_angle = self.v_angle;
      aimangle = (newmis.origin + newmis.velocity);
      traceline (newmis.origin,aimangle,FALSE,self);
      if (trace_fraction < TRUE) {
         if ((trace_ent.flags & FLx_CREATURE) && Align_Opposing(self,trace_ent)) {
            newmis.enemy = trace_ent;
            newmis.think = HomingMissileThink;
            return ;
         }
      }
      newmis.think = HomingMissileAcquire;
      newmis.nextthink = time + 0.1;
   }
};

// SpawnBFGBoom - Spawns an explosion sprite atorg.
void(vector org, vector dir, string emdl, float beginf, float endfrm,float anitm, float skn, vector vel) SpawnBFGBoom = { // [FUNCTION]
        newmis = spawn();
        newmis.solid = SOLID_NOT;
        newmis.movetype = MOVETYPE_FLY; // DRS: todo - change so it can move
        newmis.owner = world;
        newmis.angles = vectoangles(dir);
        newmis.velocity = vel;
        setmodel(newmis, emdl);
        setsize(newmis, '0 0 0', '0 0 0');
        setorigin(newmis, org);
        newmis.skin = skn;
        newmis.frame = beginf;
        newmis.pain_timeout = anitm;
        newmis.frame_override = endfrm;
        newmis.think = BFGBoomThink;
        newmis.nextthink = time + anitm;
};

void(vector org, vector dir) WeldFire = { // [FUNCTION]
	local entity weld, head;

	weld = spawn();
	if (self.classtype == CT_MONNEHAHRA) { // could be max mister
		head = find(world, classname, "nehahra_head");
		if (head == world) weld.owner = self;
		else weld.owner = head;
	} else weld.owner = self;
	weld.movetype = MOVETYPE_FLYMISSILE;
	weld.solid = SOLID_BBOX;
	weld.event = "mthret";
	weld.touch = WeldTouch;
	if (self.classtype == CT_MONNEHAHRA && (ai_foundbreakable(self, self.enemy, FALSE))) weld.touch = nehahra_wreckbsp; // could be max mister
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

void() nehahra_spitfire = { // [FUNCTION]
	local vector spot, org, vec;

	makevectors(self.angles);
	spot = self.origin + '0 0 235';
	org = spot + v_forward * 10;
	if (random() < 0.6) vec = nehahra_lead();
	else vec = self.enemy.origin - spot;

	vec = normalize(vec);
	WeldFire(org, vec);
};

void(float offset) max_shootfire = { // [FUNCTION]
	local vector org, vec, spot;

	makevectors(self.angles);
	spot = self.origin + '0 0 20';
	org = spot + v_forward * 10;
	if (random() < 0.8) vec = mindcrime_lead(1000);
	else vec = self.enemy.origin - spot;

	vec = normalize(vec);
	WeldFire(org, vec);
};

// ECHO SHOTS
// Used to create more shots between frames to give firing rates faster
// than 10 frames per second.  Only clients should use this because of
// intermission and fire button checks, which do not apply to monsters.
// Spawns a dummy entity that will fire a shot for its owner.
void(float pause, void() thinkst) Echo_Shot = { // [FUNCTION]
    newmis = spawn();
    newmis.owner         = self;
    newmis.nextthink     = time + pause;
    newmis.think         = Echo_Think;
    newmis.think1        = thinkst;
    newmis.tome_finished = self.tome_finished;
};

//  Archer Knight Arrows
// Update 11/24/09:  Constants moved to defs.
void(vector start, vector dir, float type) AkArrow_Launch = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup = CG_PROJALL;
    newmis.master = newmis.owner = self;
    newmis.movetype   = MOVETYPE_FLYMISSILE;
    newmis.solid      = SOLID_BBOX;
    newmis.classname  = "arrow";
    newmis.movedir    = dir;
	newmis.speed      = AKARROW_SPEED_FLY;
	newmis.velocity   = dir * newmis.speed;
    newmis.avelocity  = '0 0 0';
    newmis.avelocity_z = newmis.speed;     // Makes arrow model spiral.
    newmis.angles     = vectoangles(newmis.velocity);
    newmis.dest       = dir;      // for 'spawn_touchblood'.

	// Hexen2 Damage: green = 5-7, red = 8-12, gold = 13-17.  For Quake, do x*3 so that orange = 15-20, gold = 25-35, blue = 40-50.  Update/Drake:  Green = 9, Red = 18, Yellow/Orange = 30.
    if (type & 2) { // Energy arrow.
        type = newmis.count = 0; // Was LF_YELLOW.
        Laser_Color (newmis, type);
        newmis.worldtype    = TRUE; // Indicate super type
        newmis.dmg          = 30;
        newmis.think1       = AkArrow_Explode; // Arrows don't explode in Hexen2, but I am making them so in Drake. -PM
        newmis.cnt          = newmis.waitmax;
        newmis.effects      = newmis.effects | EF_DIMLIGHT;
        newmis.oldorigin    = start;
        newmis.skin         = ARROW_MAGIC + type;  // Yes, use + not |.
    } else {
        newmis.worldtype    = FALSE;
        newmis.cnt          = 0; // Normal wooden arrow.
        if (type & 4) newmis.dmg = 9; // Goblin arrow.
        else if (type & 1) newmis.dmg = 18; // Lord arrow.
        else newmis.dmg     = 15; // Orc arrow.
        newmis.skin         = type & 1;
    }
    newmis.enemy        = world;
    newmis.touch        = AkArrow_Magic_Touch;
    newmis.delay        = time + 5;         // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = AkArrow_Think;
    if (!newmis.cnt) newmis.touch = AkArrow_Wood_Touch; // ijed regular arrows now have a continual think to produce a subtle particle trail, not one of the more magical built in mdl variants
    if (self.classtype == CT_MONREBEL) newmis.frame = 1; // Crossbow bandit hack.
    setall(newmis,"progs/drake/arrow.mdl",'0 0 0','0 0 0',start);
};

void(vector start, vector dir, float sped, float damage) RyuPlasma_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup   = CG_PROJPLASMAROGUE;
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "plasma";
    newmis.movedir      = dir;
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = damage;
    newmis.distance     = damage + 220; // 320 when dmg == 100.  Mjolnir has a range of 350.
    newmis.enemy        = world;
    newmis.style        = FALSE; // TRUE is 'no friendly fire' discharge.
    newmis.touch        = RyuPlasma_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = RyuPlasma_Think;
    newmis.waitmin      = 2;
    newmis.waitmax      = 4;
    newmis.effects      = EF_DIMLIGHT;  // DoE used EF_BRIGHTLIGHT.
    setmodel (newmis, "progs/plasma.mdl");  // Big plasma balls from DoE.
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};

//  Acid Bomb -- Used by green dragon.
void(vector start, vector dir, float sped, float damage) Acidball_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = damage;
    newmis.dest         = dir;
    newmis.touch        = Acidball_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;
    setmodel (newmis, "progs/drake/acidbal1.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};

void(vector start, vector dir, float sped) Acid_Toss = { // [FUNCTION]
    launch_projectile(start, dir, CT_PROJ_WIZ, sped);
    newmis.movetype  = MOVETYPE_TOSS;
    newmis.speed     = sped;
    newmis.velocity  = (dir * sped) + '0 0 200';
    newmis.angles    = vectoangles (newmis.velocity);
    newmis.delay     = newmis.nextthink;
    newmis.nextthink = time + 0.1;
    newmis.think     = Acid_Think;
};

void(vector start, vector dir) Meat_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.velocity_z   = newmis.velocity_z + 200;  // Used to be 200 only.
    newmis.avelocity    = '3000 1000 2000';
    newmis.dmg          = 10;
    newmis.touch        = Meat_Touch;
    newmis.nextthink    = time + 2.5;
    newmis.think        = SUB_Remove;
    setall(newmis,"progs/zom_gib.mdl",'0 0 0','0 0 0',start);
};

void(vector start, vector dir, float sped) Ice_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master = newmis.owner = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
	newmis.classgroup   = CG_PROJICE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "ice";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 9;
    newmis.dest         = dir;
    newmis.oldorigin    = start;    // For proper particle trail drawing.
    newmis.alpha        = ALPHA_ICE;
    newmis.touch        = Ice_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = Ice_Think;
    setall(newmis,"progs/drake/ice.mdl",'0 0 0','0 0 0',start);
};

// Launch an explosive icy spikeball.
void(vector start, vector dir, float sped) Iceball_Launch = { // [FUNCTION]
    Ice_Launch (start, dir, sped);
    setmodel (newmis, "progs/drake/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    newmis.avelocity = '300 300 300';
    newmis.dmg      = 60;
    newmis.alpha    = ALPHA_ICEBALL;
    newmis.touch    = T_MissileTouch;
    newmis.think    = Iceball_Think;
    newmis.think1   = Iceball_Explode;
};

void(vector start, vector dir, float sped, float damage) Iceball_Toss = { // [FUNCTION]
    Ice_Launch (start, dir, sped);
    setmodel (newmis, "progs/drake/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    newmis.movetype = MOVETYPE_TOSS;
    newmis.avelocity = '300 300 300';
    newmis.dmg      = damage;
    newmis.alpha    = ALPHA_ICEBALL;
    newmis.touch    = T_MissileTouch;
    newmis.think    = Iceball_Think;
    newmis.think1   = Iceball_Explode;
};

//  Ice Mines
void(vector start) IceMine_Spawn = { // [FUNCTION]
    local entity swap;

	// Spawn the ice mine.
    newmis = spawn ();
    newmis.owner        = world;
    newmis.master       = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
	newmis.classgroup = CG_PROJICE;
    newmis.classname    = "ice";
    newmis.velocity     = '0 0 0'; // set missile speed
    newmis.avelocity    = '0 0 0';
    newmis.angles       = '0 0 0';
    newmis.dmg          = 90; // set missile damage
    newmis.health       = 25;   // Barrels use 20 hp.
    newmis.takedamage   = DAMAGE_YES;
    newmis.bloodtype    = CHUNKS_ICE;
    newmis.hittype      = HIT_STONE;
    newmis.th_die       = IceMine_Die;
    newmis.resist_cold  = 1;    // Immune to cold.
    newmis.resist_fire  = 0;   // Fire melts ice!
    newmis.touch        = IceMine_Touch;
    newmis.think1       = Iceball_Explode;
    newmis.frame        = 0;
    newmis.alpha        = ALPHA_ICEBALL;
    newmis.think        = mine1;
    newmis.nextthink    = time + 0.1; // set missile duration
    newmis.delay        = time + 30;
    setall (newmis, "progs/drake/iceball.mdl", VEC_ITEM_MIN, '16 16 16', start);
	swap = self;
	self = newmis;
	droptofloor();
	self = swap;

	// Spawn touch field.
	// With solid_bbox and movetype_toss, monsters can walk on the iceball
	// without exploding it, which is unfair.  Therefore, place a trigger
	// field over the iceball so anytime a monster tries to walk on the ice,
	// the iceball will explode as expected.
    swap = spawn();
    swap.master = swap.owner = newmis;
    swap.movetype   = MOVETYPE_NONE;
    swap.solid      = SOLID_TRIGGER;
    swap.nextthink  = time + 0.1;
    swap.think      = IceMineTrigger_Think;
    swap.touch      = IceMineTrigger_Touch;
    setall(swap, "",VEC_ITEM_MIN, VEC_HULL_MAX, start);
    newmis.trigger_field  = swap;      // Link touch field to the iceball.
    sound(newmis, CHAN_AUTO, "drake/weapons/freeze.wav", 1, ATTN_NORM);
    ShockWave (newmis.origin + '0 0 4', RING_ICE, 3, "progs/drake/s_wave.spr",FALSE); // Spawning effects.
};

//  Rain Storm -- Used by the elemental boss barons.  Various missile functions for the rainstorm.
void() RainStorm_Ice = { // [FUNCTION]
    Ice_Launch (trace_endpos, '0 0 -1', 1000); // Use flymissile instead of toss for the missile clip bonus.  Then set speed to a reasonably fast value to use for terminal velocity.
    newmis.master   = newmis.owner  = self.owner;
    newmis.delay    = time + 2.5;
    newmis.dmg      = self.dmg;
};

// Spawns a missile spawner that drops shots on a target from the ceiling.
void() RainStorm = { // [FUNCTION]
    if (super_active) return;

    super_active = 1; // This chews through a lot of edicts.
    newmis = spawn();
    setorigin (newmis, '0 0 0');
    newmis.owner    = self;
    newmis.enemy    = self.enemy;
    newmis.delay    = time + 5;
    newmis.think    = RainStorm_Think;
    newmis.think1   = RainStorm_Ice;
    newmis.dmg      = 18;
    newmis.wait     = 1 / 20;
    newmis.distance = 64;
    newmis.nextthink= 0.01;
};

// Update 4/2/10:  Adapted for player use.  Mega enforcer still uses this.
void(vector start, vector dir, entity targ) Sidewinder_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
    newmis.yaw_speed    = 30;   // For sidewinding code.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.velocity     = dir * (450 + (random() * 50));
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 90;
    newmis.oldenemy     =
    newmis.enemy        = targ;
    newmis.ideal_yaw    = newmis.angles_y;
    newmis.cnt          = 0;
    newmis.lefty        = 1;
	newmis.classtype 	= CT_PROJ_SIDEWINDER;
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5)); // Get the spot we want to hit if fired straight without a target.
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2.5;       // Total duration
    newmis.nextthink    = time + 0.2;       // Was T+0.25
    newmis.think        = Sidewinder_Think;
    newmis.think1       = Old_Explosion1;
    setall(newmis,"progs/drake/memissil.mdl",VEC_ORIGIN,VEC_ORIGIN,start);
};

// Launches a sidewinding poison shot.  Used by acolytes.
void(vector start, vector dir, float sped) NecroSnake_Launch = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup   = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "wizspike";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 9;
    newmis.enemy        = self.enemy;
    newmis.speed        = sped;
    newmis.yaw_speed    = 10;
    newmis.ideal_yaw    = self.angles_y;
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5)); // Get the spot we want to hit if fired straight without a target.
    newmis.touch        = NecroSnake_Touch;     //spike_touch;
    newmis.delay        = time + 5;     // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = Sidewinder_Think;
    setall(newmis, "progs/w_spike.mdl", '0 0 0', '0 0 0', start);
};

//  Explosive Runes -- Used by Ebon Sorcerer.  Deposits an explosive rune where the necro is standing.
void(vector org) NecroBomb = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLY;
    newmis.solid        = SOLID_TRIGGER;
    newmis.classname    = "necrobomb";
    newmis.velocity     = '0 0 0';
    newmis.angles       = '0 0 0';
    newmis.angles_y     = random() * 360;   //self.angles_y;
    newmis.dmg          = 70;
    newmis.touch        = Touch_Missile;
    newmis.wait         = time + 0.2;
    newmis.nextthink    = time + 1;     //(1 + random()) * 0.5
    newmis.think        = Touch_Missile;
    setall(newmis,"progs/drake/nec_rune.mdl",VEC_HULL_MIN,VEC_HULL_MAX,org);
};

//  Necrobolt -- Used by Ebon Warlock and Dark Lord
// Update:  Instead of splitting into multiple mini-spikes, the bolt now
// redirects like shal-rath homing bombs, except update frequency is longer (slower).
// It resembles more like the Amazon's Guided Arrows from Diablo 2.
// Launches a crimson energy seeker bolt.  Used by warlocks.
void(vector start, vector dir) NecroBolt_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "necrobolt";
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.avelocity    = '0 0 1200';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.yaw_speed    = 360;  // PM: Let dragons know this cannot be dodged.
    newmis.dmg          = 70;   // mathlib_max(50+d20) = 70.
    newmis.enemy        = self.enemy;
    newmis.touch        = NecroBolt_Touch;
    newmis.delay        = time + 0.8;   // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = NecroBolt_Think;
    setall(newmis,"progs/drake/r_bolt.mdl",'0 0 0','0 0 0',start);
};

// SoE:  Split off from boss_missile so Hell Lord can use as well.
void(vector p, float sped) boss_meteor = { // [FUNCTION]
    local vector org, vec, d, avel;

    vec = vectoangles (self.enemy.origin - self.origin);
    makevectors (vec);
    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	// SoE:  Monsters must have unbroken line to spawn point.  Do that to minimize chances of meteors appearing in the wall.
    if (self.flags & FL_MONSTER) { // If TRUE, self is probably a Hell Lord.
        traceline (self.origin, org, TRUE, self);
        if (trace_fraction < 1) {
            org = org - self.origin;
            sped = vlen(org) - 32;
            org = normalize(org);
            org = self.origin + org*sped;
        }
    }
		
    d = self.enemy.origin; // lead the player on hard mode
    if (skill >= 2) d = Aim_Lead (org, d, sped, self.enemy);
    vec = normalize (d - org);
	avel = vecrand(100,200,FALSE);
    Launch_Missile (org, vec, avel, CT_PROJ_LAVA, self.attack_speed); // Classic chthonic lavaball.
    sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
};

// MJOLNIR (Thor's hammer) Throwing Hammer
// This part of the Mjolnir code is custom, added for SoE's modified
// Mjolnir.  This lets the attacker throw the hammer.  The hammer will
// select an enemy, fly toward it, then return back to the attacker.
// In that respect, it is similar to the soulcube from Doom3.
// If the hammer hits a target, the hammer will discharge like
// the plasma balls from DoE.

// Checks if self has enough power to throw the hammer.
float() HasPowerToThrow = { // [FUNCTION]
    if (self.tome_finished) return TRUE;
    if (self.ammo_cells >= COST_MJOLNIR) return TRUE;
    return FALSE;
};

// This throws the mighty hammer.
void(vector start, vector dir, entity targ) Thor_Launch = { // [FUNCTION]
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "Mjolnir";    //"hammer";
    newmis.yaw_speed    = 40;
    newmis.speed        = THOR_SPEED;
    newmis.velocity     = dir * THOR_SPEED;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_x  = 0 - THOR_SPEED;
    newmis.movedir      = dir;
    newmis.dmg          = 100;
    newmis.ammo_cells   = COST_MJOLNIR;
    newmis.enemy        = targ;
    newmis.count        = 0;
    newmis.touch        = Thor_Touch;
    newmis.delay        = time + 1.5;   // 1,5 sec. gives about 900 range.
    newmis.nextthink    = time + 0.1;
    newmis.think        = Thor_Think;
	newmis.classgroup	= CG_WEAPON;
    newmis.frame		= 0;
    setmodel(newmis,"progs/drake/throwham.mdl");
    setsize(newmis, '0 0 0', '0 0 0');        
    setorigin(newmis, start);

    if (self.flags & FL_CLIENT) { // Update attacker.
        if (self.ammo_cells >= COST_MJOLNIR) {   
            self.ammo_cells = self.ammo_cells - COST_MJOLNIR; // Throw hammer at full power.
        } else { // No juice!
            newmis.ammo_cells   = 0;
            if (self.tome_finished) newmis.delay = time + 1;
            else newmis.delay = time + 0.5;
        }
        self.weaponmodel = "";
    }
    self.hammer_finished = time + 10;    // Automatically returns later.
};

// PM:  Custom shockwave attack for enhanced Mjolnir.
void() HIP_FireMjolnirShockwave = { // [FUNCTION]
    local entity wave;
    local vector spot;
    local float damage, fr, wc;

	if (GibFloorBody(trace_endpos, 200)) return;

    spot = trace_endpos;
    wave = spawn();
    setorigin (wave, spot);
    sound (wave, CHAN_AUTO, "hipnotic/weapons/mjolslap.wav", 1, ATTN_NORM);
    sound (wave, CHAN_WEAPON, "drake/weapons/nova.wav", 1, ATTN_NORM);
    wc = RING_BLUE;
    if (self.tome_finished) { 
        damage = 100; // More damage plus a tremor to shake things up.
		fr = 5;
		Quake_Spawn(self,150,3,spot,TRUE,0.5,VEC_QUAKE); // Update 9/10/10:  Reduced dist(200), damage(4) and time(1). Quake is for the player to feel powerful.
    } else {
		damage = 70;
		fr = 4;
	}
    ShockWave(spot + '0 0 4', wc, fr, "progs/drake/s_wave.spr",FALSE);
    T_RadiusDamage(wave, self, damage, self,DAMAGEALL);
    if (self.tome_finished) { // Spawn mini-slam effects with Tome of Power. Do after radius damage so dead things won't be targeted.
        if (pointcontents (spot) > CONTENT_WATER) BurstLit_Chain(wave,self,30,self,spot,'1 350 4',2); // No discharge for you!
        Divine_Wrath(1,1);
    }
    Hammer_Block(wave,damage); // PM: Added on 12/23/09. (Just in time for Christmas! -Qmaster)
    remove(wave);
};

// Checks if the super slam is safe to use.
float() Thor_Safe = { // [FUNCTION]
    if (deathmatch) return TRUE;    // Allow for possible net frag gain.
    if (self.cross_finished) return TRUE; // Immune to radius damage.
    if (self.radsuit_finished) return TRUE; // Inherited wetsuit powers...protected from lightning damage.
    if (self.waterlevel <= 1) return TRUE; // Not in the water.
    return ImmuneToDamage(self);
};

// Slammed the ground, so fire off some lightning.
void() HIP_SlamMjolnir = { // [FUNCTION]
	if (self.hammer_finished) return;

    if (self.ammo_cells >= COST_MJOLNIR)
    if (Thor_Safe()) { // Super slam.  Update 11/30/09:  Don't discharge if deadly.
		Quake_Spawn(self,800,10,trace_endpos,TRUE,2,VEC_QUAKE);
		if (GibFloorBody(trace_endpos,200)) return;

		HIP_FireMjolnirLightning(); dprint("Slam safe\n");
		if (self.tome_finished) Divine_Wrath(6, 2); // Do after Hip lightning.
		if (!lightzero_finished) sound(world,CHAN_AUTO,"drake/bane/thunder.wav",1,ATTN_NONE);
        if (self.tome_finished) StaticField(self,400); // Soften 'em up before delayed smashing. Was 500.
		W_Reload(1.5);
    } else HIP_FireMjolnirShockwave(); // Mini-slam.
};

float() Hip_ThrewMjolnir = { // [FUNCTION]
	if (self.hammer_finished) return TRUE;
	if ((world.hipnoticoptions & HIPNOTIC_OLDMJOLNIR) && !self.tome_finished) return FALSE;
	if (HasPowerToThrow()) {W_FireThor();  return TRUE;} // Throw if player has the juice.
    return FALSE;
};

// PM:  Called on third frame of attack, before the slam on the fourth.
float() HIP_ThrowMjolnir = { // [FUNCTION]
    local vector org, source;
    local float damage, stat;

	if ((world.hipnoticoptions & HIPNOTIC_OLDMJOLNIR) && !self.tome_finished) return FALSE;

    source = self.origin + '0 0 16';
    makevectors (self.v_angle);
    traceline(source,source + v_forward * 80,FALSE,self);
    org = trace_endpos - v_forward * 4;
    if (trace_ent.takedamage) {
        stat = 0;
		damage = 50;
		if ((trace_ent.classgroup == CG_ZOMBIE) && trace_ent.classname != "monster_mummy") damage = trace_ent.max_health * 2;
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		SpawnBlood(trace_ent,org,'0 0 50',damage,225);
		if (trace_ent.alignment == NEUTRAL && trace_ent.enemy == self) {
			trace_ent.enemy = trace_ent.oldenemy = world;
			return TRUE;
		}

		T_Damage(trace_ent, self, self, damage, DAMARMOR);
		if (random() < 0.2) stat = 1; // Multiple procs are checked independently of each other, and may activate simultaneously.
		if (self.tome_finished) {
			if (random() < 0.1) { // Thunderstorm proc.
				if (!Divine_Wrath(3,1)) stat = stat + 1; // 3 shots, 1 sec of darkness.
			} else Divine_Wrath(1,1);
		}

		if (stat) {
			stat = stat + 1;
			stat = stat * 100 + 100;
			StaticField(trace_ent,stat);
		}
        return TRUE;
    } else if (trace_fraction < 1.0) { // Hit wall
        if (other.solid == SOLID_BSP && trace_plane_normal * '0 0 1' > COS45) { HIP_SlamMjolnir(); return TRUE; } // Check for premature hit on the ground.

		if (GibFloorBody(trace_endpos,200)) {
			sound (self, CHAN_WEAPON, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
			return TRUE;
		}
        sound (self, CHAN_WEAPON, "hipnotic/weapons/mjoltink.wav", 1, ATTN_NORM);
        Tent_Point(TE_GUNSHOT, org);
        return TRUE;
    } else { // Whiff
		if (!(self.flags & FL_CLIENT)) { // Frikbot code!  Emulate a double-click, since required timing varies.
			if (random() < (skill * 0.1 + 0.7)) return FALSE; // Frikbot tries to throw hammer.  With lag, enforce a chance of failure.
		}
        self.attack_finished = self.attack_finished + 0.1;  // Update 12/11/09:  T+0.6+0.1=T+0.7.  Changed rate in impulse.qc.
        return Hip_ThrewMjolnir(); // Aww yeah!
    }
	return FALSE;
};

void(float damage, vector dir, float addedtime) TraceExploAttack = { // [FUNCTION]
    local vector org;
	local float ldmg;
    
    if (pointcontents(trace_endpos) == CONTENT_SKY) return;

    org = trace_endpos - dir*8;     // Yes, use 8 for sprite placement.
    if (trace_ent.takedamage) { // Adding explosive fuel to the fire...
        ldmg = SUB_RandomDamage (damage);
		AddMultiDamage (trace_ent, ldmg);
    }

    // Spawn an explosion entity to put on a linked list.
    newmis = spawn();
    newmis.owner     = self;
    newmis.enemy     = trace_ent;
    newmis.oldenemy  = shot_head;
    newmis.dmg       = damage;
    newmis.think    = TraceExploShell_Think;
	newmis.nextthink = time + 0.1 + addedtime;
    setmodel (newmis, "");
    setorigin (newmis, org);
    shot_head = newmis; // Don't use chain because findradius will overwrite that. Some engines, like DarkPlaces, pick up even SOLID_NOT.
};

// BURIZA-DO KYANON, Now called the Asgard Arbalest in Keep and Quake: Mjolnir.
// Buriza-Do Kyanon is an artifact crossbow based on the unique "ballista"
// from Diablo 2 Lord of Destruction.  The Buriza in Diablo 2 featured
// unusually high damage that was typed cold and physical, and shots that
// always pierced and froze most enemies on a hit.  Most enemies that died
// shattered into ice cubes.
// Here, the shots will always pierce, and they will one-hit kill most small
// targets struck.  This is also similar to the super shot powerup in
// the games Gauntlet 2 and Gauntlet Legends.
// Burizado kyanon is the transliteration from Japanese which translates to Blizzard Cannon.
void(vector start, vector dir) Buriza_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "Buriza";
    newmis.movedir      = dir;
    newmis.speed        = SPEED_BURIZA;
    newmis.dest         = newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_z  = newmis.speed;     // Makes arrow model spiral.
    newmis.angles       = vectoangles(newmis.velocity);
	newmis.classtype	= CT_FROSTSHARD; // To allow for freezing effect to work
	newmis.classgroup	= CG_PROJICE; // To allow for resist_cold to work
    newmis.cnt          = 41; // Blue particle color index
    newmis.oldorigin    = start;
    newmis.frame        = 1;
    newmis.skin         = ARROW_ICE;
    newmis.oldenemy     = newmis.enemy = world;
    newmis.fallen       = self;     // Second owner, used by reflection.
    newmis.touch        = Buriza_Touch;
    newmis.delay        = time + 10;    // Give it long range.
    newmis.nextthink    = 0.01;
    newmis.think        = Buriza_Think;
    setall (newmis, "progs/drake/arrow.mdl", '0 0 0', '0 0 0', start);
};

// Loop through all entities and damage everyone who has damage stacked
// against them (from the piercing shotgun effect).  Not as fast as
// MultiDamage*, but necessary when piercing shots are involved.
// Assumes inflictor and attacker are both self.
void() StackDamage_Clear = { // [FUNCTION]
    local   entity  head;
    head = nextent (world);
    while (head) {
        if (head.dmg_stack) {
			if (self.weapon == IT_LAVA_SUPER_NAILGUN || self.weapon == IT_LAVA_NAILGUN) {
				if (head.resist_fire > 0) head.dmg_stack = head.dmg_stack * (1 - head.resist_fire);
				else Burn_Add(head,self,head.dmg_stack); // Lavanails have a chance to set targets on fire!
			}
            T_Damage(head,self,self,head.dmg_stack,NOARMOR); // Armor piercing!
            head.dmg_stack = 0;
        }
        head = nextent (head);
    }
};

// Shoots a piercing hitscan bullet.
void(vector p1, vector p2, entity attacker, float damage, entity inflictor, float fx) Piercer_Trace = { // [FUNCTION]
    local entity ruler, ignore, targ, newent, stemp;
    local vector start, dir;
    local float dist, delta, hits;

    hits = 3;
    ruler = inflictor;
    dir = p2 - p1;
    delta = vlen(dir);  // Get total length in case of reflection.
    dir = normalize(dir);
    while (ruler) {
        ignore = inflictor = ruler;
        ruler = world;      // End loop unless set otherwise by reflection.
        start = p1;
        do {
            traceline (p1, p2, FALSE, ignore);
            p1 = trace_endpos;
            targ = trace_ent;
            if ((targ.solid != SOLID_BSP) && targ.takedamage) ignore = targ;
            else ignore = world;

            if (targ != inflictor) { // Dirty hack to prevent suicide.
                if (HasReflection (targ, p1, damage)) {
                    if (hits > 0) {
                        hits = hits - 1;
                        ruler = targ;
                        delta = delta - vlen(p1 - start);   // Get remaining dist.
                        dir = normalize(p1 - targ.origin);
                        p2 = p1 + dir*delta;
                    }
                    else trace_fraction = 1;     // We give up.
                    ignore = world;     // Stop the trace.
                    ReflectSound (targ);
                } else if (targ.takedamage) {
					// Note:  Because we may call the function we are in multiple times for a shotgun-like attack, don't apply damage now.  Just put the damage number in a stack, then apply it when we are ready.
					SpawnBlood(targ,trace_endpos,dir * damage,damage,0);
                    targ.dmg_stack = targ.dmg_stack + damage;
                }
            }
    
			// If current trace hits inflictor/attacker, next trace will miss all.
			// Move the new start point ahead slightly to prevent attacker from
			// hitting himself and preventing the bolt from piercing anymore.
			// (Note:  If attacker is inside the monster because of noclip,
			// he can still hit himself.)
            if (ignore) { // Always world if 'p2 == trace_endpos'.
                dist = vlen(p2 - p1);
                if (dist > 1) p1 = p1 + dir;
                else ignore = world; // Not enough distance left, so just stop.
            }
        }
        while(ignore);
    }

    if (trace_fraction < 1 && pointcontents(p1) != CONTENT_SKY) Tent_Point(fx, p1);    // fx should be TE_SPIKE or TE_SUPERSPIKE.

	if (attacker.weapon == IT_LAVA_SUPER_NAILGUN || attacker.weapon == IT_LAVA_NAILGUN) {
		newent = spawn();
		setorigin(newent,p1);
		stemp = self;
		self = newent;
		Ember_Shower(2);
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
		self = stemp;
	}
};

void(float ox) W_EchoSpike = { // [FUNCTION]
    local vector org, dir;
    local float cost;

    cost = 1;
    if (self.perms & POW_DOUBLE) {
        if (self.weapon == IT_NAILGUN) cost = 0;
        else if (!self.tome_finished || (ox < 0)) cost = 0; // Assume super nailgun.
    }
    if (self.ammo_nails < cost) return;

    makevectors (self.v_angle);
    if (self.weapon == IT_NAILGUN)
        sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    else    // Assume super nailgun.
        sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - cost;
    if (self.tome_finished) { // Tome of Power SPIKES which are hitscan
        if (self.weapon == IT_NAILGUN) {
            org = self.origin + '0 0 16' + v_right*(ox*3);
        } else {
            org = self.origin + '0 0 16' + v_right*(ox*2);
        }
        dir = aim (self, 100000);
        Piercer_Trace (org, org + dir*SPIKEY_RANGE, self, SPIKEY_DAMAGE, self, TE_GUNSHOT);
        StackDamage_Clear();
    } else {
        dir = aim (self, 1000);
        if (self.weapon == IT_NAILGUN) {
			ox = ox * 1.5;
			launch_projectile (self.origin + '0 0 16' + v_right*ox, dir, CT_PROJ_NG, SPEED_PLAYSPIKE);
        } else launch_projectile (self.origin + '0 0 16' + v_up*ox, dir, CT_PROJ_SNG, SPEED_PLAYSPIKE); // '8 10 12+ox'
        if (self.weapon == IT_SUPER_NAILGUN) newmis.classname = "spike2";    // For obituary.
    }
};
void() W_EchoSpike_Up = {W_EchoSpike(2);}; // [FUNCTION]
void() W_EchoSpike_Down = {W_EchoSpike(-2);}; // [FUNCTION]

void(float ox) W_EchoLavaSpike = { // [FUNCTION]
    local vector org, dir;
    local float cost;

    cost = 1;
    if (self.perms & POW_DOUBLE) {
        if (self.weapon == IT_LAVA_NAILGUN) cost = 0;
        else {   
            if (!self.tome_finished || (ox < 0)) cost = 0; // Assume super nailgun.
        }
    }
    if (self.ammo_nails < cost) return;

    makevectors (self.v_angle);
    if (self.weapon == IT_LAVA_NAILGUN) sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    else sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM); // Assume super nailgun.

    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - cost;
    if (self.tome_finished) {
        if (self.weapon == IT_LAVA_NAILGUN) org = self.origin + '0 0 16' + v_right*(ox*3);
        else org = self.origin + '0 0 16' + v_right*(ox*2);

        dir = aim (self, 100000);
        Piercer_Trace (org, org + dir*SPIKEY_RANGE, self, DAMAGE_LAVANGSPIKE, self, TE_GUNSHOT);
        StackDamage_Clear();
    } else {
        dir = aim (self, 1000);
        if (self.weapon == IT_LAVA_NAILGUN) {
			ox = ox * 1.5;
			launch_projectile (self.origin + '0 0 16' + v_right*ox, dir, CT_PROJ_LAVANG, SPEED_PLAYSPIKE);
        } else launch_projectile (self.origin + '0 0 16' + v_up*ox, dir, CT_PROJ_LAVASNG, SPEED_PLAYSPIKE); // '8 10 12+ox'
        if (self.weapon == IT_LAVA_SUPER_NAILGUN) newmis.classname = "spike2";    // For obituary.
    }
};
void() W_EchoLavaSpike_Up = {W_EchoLavaSpike(2);}; // [FUNCTION]
void() W_EchoLavaSpike_Down = {W_EchoLavaSpike(-2);}; // [FUNCTION]

// In 35 fps Doom, delays in the loop were 4/4/1.  The third frame was the same as first, but not fullbright, and did a vis check.
void(vector org, vector dir, entity targ, vector err) M_FireChaingun = { // [FUNCTION]
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "drake/weapons/dsshotgn.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 0, targ, err);
	FireBullets(1, '0.14 0.08 0'); // Chaingunners were lousy shots in Doom2, so use a wide spread.  Normal SSG spread should do nicely.  Also, Doom's damage is 1d3*5.  Yaw scatter should be crandom * 3.125.
    // Slow down thinking to give a rate-of-fire of Doom's chaingun zombie.
    self.b0_click = !self.b0_click;     // Use client-only field for this.
    if (self.b0_click) self.nextthink = time + 0.11428; // Was Doom_NextThink which does (time + fr/35) which in this case was 4/35
    else self.nextthink = time + 0.14286; // 5/35. Assumed 35 frames per second for Doom or Heretic game emulation.
    M_Reload(0.2);
};

// Fireball used by hell knight and baron.
void(vector start, vector dir) KnightBall_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master      = newmis.owner     = self;
    newmis.movetype    = MOVETYPE_FLYMISSILE;
    newmis.solid       = SOLID_BBOX;
    newmis.classname   = "fireball";
    newmis.speed       = 1000;
    newmis.velocity    = dir * 1000;
    newmis.angles      = vectoangles(newmis.velocity);
    newmis.avelocity   = '0 0 0';
    newmis.avelocity_z = random()*2000 - 1000;
    newmis.dmg         = 60;
	newmis.pos1		= '60 0 40'; // Base + Random, Splash
    newmis.enemy       = world;
    newmis.touch       = Touch_Missile;
    newmis.nextthink   = time + 5;
    newmis.think       = Orange_Explosion;
    newmis.frame       = 2;
    setall(newmis,"progs/drake/k_ball.mdl",'0 0 0','0 0 0',start);
};

void(vector st, float lo) M_FireKnight = { // [FUNCTION]
    local vector p1, p2, dir;

    makevectors(self.angles);
    p1 = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    p2 = Aimpoint (self.enemy);
    if (lo) p2_z = self.enemy.absmin_z + 1;
	dir = normalize(p2 - p1);
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound(self, CHAN_WEAPON, "drake/baron/fireball.wav", 1, ATTN_NORM);
    KnightBall_Launch (p1, dir);
};

//  This extinguishes the fire burning on a player (or other entity).  This function should be called whenever the fire burning on an entity must be removed immediately.
//  Examples who and when this should be called for:
//  * All players (and their minions) when the level ends.
//  * Anytime a player respawns after dying (from the 'kill' command).
//
//  Assumptions (i.e., leaps of faith):
//  * If ent == world, then ent.burner is always world (FALSE).
//  * If ent.burner is not the world, then ent.burner really is a flame.  If not, bad things will likely happen.
//
//  Update:  Since burning is back to the old Napalm style, always use this function to remove any flame pointed by ent.burner.
void(entity ent) Burn_Null = { // [FUNCTION]
	if (!ent) return;
	ResetDebuffBurning(ent);
    if (ent.burner) { // Note:  non-zero cnt means flame is underwater.
        if (ent.modelindex && !ent.burner.cnt) { // Transform flame into a small explosion.
            ent.burner.effects = EF_MUZZLEFLASH;    // No more dynamic light after the puff.
            SUB_ThinkImmediate (ent.burner, BecomeExplosion);
        } else remove(ent.burner); // Disappear right now.
        ent.burner = world;
    }
};

// Returns the point where a flame should burn, hopefully on its target.
vector(entity ent) Burn_Point = { // [FUNCTION]
	// Well this is kind of hacky, zombies had flames floating in air otherwise which looked dumb.
	if (ent.classtype == CT_MONZOMBIEK) {
		if (ent.frame == 102) return ent.origin + '0 0 -4'; // check paind
		else if (ent.frame == 103) return ent.origin + '0 0 -6';
		else if (ent.frame == 104) return ent.origin + '0 0 -8';
		else if (ent.frame == 105) return ent.origin + '0 0 -24';
		else if (ent.frame == 106) return ent.origin + '0 0 -24';
		else if (ent.frame == 107) return ent.origin + '0 0 -24';
		else if (ent.frame == 108) return ent.origin + '0 0 -24';
		else if (ent.frame == 109) return ent.origin + '0 0 -24';
		else if (ent.frame == 110) return ent.origin + '0 0 -24';
		else if (ent.frame == 111) return ent.origin + '0 0 -24';
		else if (ent.frame == 112) return ent.origin + '0 0 -23';
		else if (ent.frame == 113) return ent.origin + '0 0 -18';
		else if (ent.frame == 114) return ent.origin + '0 0 -12';
		else if (ent.frame == 115) return ent.origin + '0 0 -8';
		else if (ent.frame == 116) return ent.origin + '0 0 -4';
		else if (ent.frame == 117) return ent.origin + '0 0 -4';
		else if (ent.frame == 118) return ent.origin + '0 0 -4';
		else if (ent.frame == 119) return ent.origin + '0 0 -4';
		else if (ent.frame == 120) return ent.origin + '0 0 -4';
		else if (ent.frame == 125) return ent.origin + '0 0 -2';  // Now for paine
		else if (ent.frame == 126) return ent.origin + '0 0 -10';
		else if (ent.frame == 127) return ent.origin + '0 0 -24';
		else if (ent.frame == 128) return ent.origin + '0 0 -24';
		else if (ent.frame == 129) return ent.origin + '0 0 -24';
		else if (ent.frame == 130) return ent.origin + '0 0 -24';
		else if (ent.frame == 131) return ent.origin + '0 0 -24';
		else if (ent.frame == 132) return ent.origin + '0 0 -24';
		else if (ent.frame == 133) return ent.origin + '0 0 -24';
		else if (ent.frame == 134) return ent.origin + '0 0 -24';
		else if (ent.frame == 135) return ent.origin + '0 0 -24';
		else if (ent.frame == 136) return ent.origin + '0 0 -24';
		else if (ent.frame == 137) return ent.origin + '0 0 -24';
		else if (ent.frame == 138) return ent.origin + '0 0 -24';
		else if (ent.frame == 139) return ent.origin + '0 0 -24';
		else if (ent.frame == 140) return ent.origin + '0 0 -23';
		else if (ent.frame == 141) return ent.origin + '0 0 -18';
		else if (ent.frame == 142) return ent.origin + '0 0 -16';
		else if (ent.frame == 143) return ent.origin + '0 0 -12';
		else if (ent.frame == 144) return ent.origin + '0 0 -8';
		else if (ent.frame == 145) return ent.origin + '0 0 -2';
	}

	if (ent.classtype == CT_MONZOMBIE) {
		if (ent.frame == 102) return ent.origin + '0 0 -4'; // check painb
		else if (ent.frame == 103) return ent.origin + '0 0 -2';
		else if (ent.frame == 104) return ent.origin + '0 0 -8';
		else if (ent.frame == 105) return ent.origin + '0 0 -14';
		else if (ent.frame == 106) return ent.origin + '0 0 -18';
		else if (ent.frame == 107) return ent.origin + '0 0 -22';
		else if (ent.frame == 108) return ent.origin + '0 0 -24';
		else if (ent.frame == 109) return ent.origin + '0 0 -24';
		else if (ent.frame == 110) return ent.origin + '0 0 -24';
		else if (ent.frame == 111) return ent.origin + '0 0 -24';
		else if (ent.frame == 112) return ent.origin + '0 0 -24';
		else if (ent.frame == 113) return ent.origin + '0 0 -23';
		else if (ent.frame == 114) return ent.origin + '0 0 -21';
		else if (ent.frame == 115) return ent.origin + '0 0 -20';
		else if (ent.frame == 116) return ent.origin + '0 0 -20';
		else if (ent.frame == 117) return ent.origin + '0 0 -20';
		else if (ent.frame == 118) return ent.origin + '0 0 -18';
		else if (ent.frame == 119) return ent.origin + '0 0 -18';
		else if (ent.frame == 120) return ent.origin + '0 0 -18';
		else if (ent.frame == 121) return ent.origin + '0 0 -18';
		else if (ent.frame == 122) return ent.origin + '0 0 -16';
		else if (ent.frame == 123) return ent.origin + '0 0 -12';
		else if (ent.frame == 124) return ent.origin + '0 0 -8';
		else if (ent.frame == 125) return ent.origin + '0 0 -2';
		else if (ent.frame == 132) return ent.origin + '0 0 -2';
		else if (ent.frame == 133) return ent.origin + '0 0 -8';
		else if (ent.frame == 134) return ent.origin + '0 0 -14';
		else if (ent.frame == 135) return ent.origin + '0 0 -14';
		else if (ent.frame == 136) return ent.origin + '0 0 -14';
		else if (ent.frame == 137) return ent.origin + '0 0 -14';
		else if (ent.frame == 138) return ent.origin + '0 0 -14';
		else if (ent.frame == 139) return ent.origin + '0 0 -14';
		else if (ent.frame == 140) return ent.origin + '0 0 -14';
		else if (ent.frame == 141) return ent.origin + '0 0 -12';
		else if (ent.frame == 142) return ent.origin + '0 0 -6';
		else if (ent.frame == 143) return ent.origin + '0 0 -3';
		else if (ent.frame == 163) return ent.origin + '0 0 4'; // Now for paind
		else if (ent.frame == 164) return ent.origin + '0 0 2';
		else if (ent.frame == 167) return ent.origin + '0 0 -8';
		else if (ent.frame == 168) return ent.origin + '0 0 -16';
		else if (ent.frame == 169) return ent.origin + '0 0 -20';
		else if (ent.frame == 170) return ent.origin + '0 0 -22';
		else if (ent.frame == 171) return ent.origin + '0 0 -24';
		else if (ent.frame == 172) return ent.origin + '0 0 -24';
		else if (ent.frame == 173) return ent.origin + '0 0 -24';
		else if (ent.frame == 174) return ent.origin + '0 0 -23';
		else if (ent.frame == 175) return ent.origin + '0 0 -24';
		else if (ent.frame == 176) return ent.origin + '0 0 -24';
		else if (ent.frame == 177) return ent.origin + '0 0 -24';
		else if (ent.frame == 178) return ent.origin + '0 0 -23';
		else if (ent.frame == 179) return ent.origin + '0 0 -24';
		else if (ent.frame == 180) return ent.origin + '0 0 -23';
		else if (ent.frame == 181) return ent.origin + '0 0 -24';
		else if (ent.frame == 182) return ent.origin + '0 0 -23';
		else if (ent.frame == 183) return ent.origin + '0 0 -22';
		else if (ent.frame == 184) return ent.origin + '0 0 -21';
		else if (ent.frame == 185) return ent.origin + '0 0 -20';
		else if (ent.frame == 186) return ent.origin + '0 0 -18';
		else if (ent.frame == 187) return ent.origin + '0 0 -19';
		else if (ent.frame == 188) return ent.origin + '0 0 -14';
		else if (ent.frame == 189) return ent.origin + '0 0 -6';
		else if (ent.frame == 190) return ent.origin + '0 0 -4';
	}

    if (ent.view_ofs_z) {
        makevectors(ent.angles);
        if ((ent.burn_ofs_x) || (ent.burn_ofs_z)) return ent.origin + (v_forward*ent.burn_ofs_x) + (v_up*ent.burn_ofs_z);
        return ent.origin + (v_forward*4) + (v_up*16);
    }

    return Midpoint(ent);  // Some entities have origin at 0,0,0.
};

// IMPORTANT:  Burn immunity is NOT the same as fire immunity which is self.resist_fire >= 1 on its own.
float(entity ent) ImmuneToBurning = { // [FUNCTION]
    if (!ent.takedamage) return TRUE; // This includes head gibs and mega-enforcer shields.
    if (ent.resist_fire >= 1) return TRUE; // Immune to fire.
    if (ent.invincible_finished) return TRUE; // Items that prevent burning...
    if (ent.radsuit_finished) return TRUE; // Envirosuit
	if (ent.therm_finished) return TRUE; // Thermal protection suit
	if (ent.moditems & IT_ARTLAVASHIELD) return TRUE; // Lava Shield
    if (ent.cross_finished) return TRUE; // Update 1/6/10:  Cross of Protection
    if (ent.solid == SOLID_BSP) return TRUE; // Flames don't look good on brush entities.
    return FALSE; // BURN BABY BURN!
};

//  This sets the victim on fire by adding burn damage.
//  Update:  Flames do not stack, so if the victim is already burning,
//  keep the longer burning fire only.  I made the change so I can have
//  flames that can spread to others yet not sustain each other
//  indefinitely.  This style is similar to the Rabies skill in Diablo II.
void(entity victim, entity attacker, float burn) Burn_Add = { // [FUNCTION]
	local vector  spot;

	if (!victim) return;
    if (!victim.takedamage) return; // Check for fire immunity.
	if (victim.resist_fire >= 1) return;
	if (victim.health <= 0) return; // Dead!  Don't add more dynamic light to slow game.
	if (ImmuneToBurning(victim)) return; // Target can't ignite, so stop.  Assumes Napalm (one of my old QC mods) style burns.
    if (burn < 1) return; // No fuel.

	spot = Burn_Point(victim);
	if (InLiquid(spot)) return; // Flame will be out as soon as it spawns, so abort.

    if (victim.burner) {
        if (victim.burner.deadflag) return; // In death mode, so do nothing.
        if (burn < victim.burner.dmg) return; // New fire doesn't last as long, so ignore it.

        if (victim.burner.master != attacker) { // New attacker steals the old fire.
			SpawnExplosion(EXPLODE_SMALL,victim.burner.origin,"");
            victim.burner.master = attacker;
        }
        victim.burner.dmg = burn; // Replace existing with higher value.
		return;
    }

	// Victim is not on fire, so set him alight.
	if (victim.flags & FL_CLIENT) victim.pain_finished = 0; // Hack:  Reset pain for players so they can scream now.
	SpawnExplosion(EXPLODE_SMALL,spot,""); // Flare up with a bang.
	newmis = spawn(); // Spawn burner entity.
	newmis.solid        = SOLID_NOT;
	newmis.takedamage   = DAMAGE_NO;
	newmis.frame = newmis.walkframe = 6;
	newmis.pos2 = '6 16 0.1';
	newmis.effects      = EF_DIMLIGHT;
	newmis.master       = attacker;
	newmis.owner        = victim;
	newmis.classname    = "fire";
	newmis.delay        = time + 1;
	newmis.dmg          = burn; // Initial damage.
	newmis.nextthink    = 0.01;
	newmis.think        = Burn_Think;
	setall (newmis, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', spot);
	newmis.mdl          = newmis.model; // Differentiate between normal and death modes.  Only used by death mode code.
	newmis.deadflag     = 0;            // Use standard burn rules.
	victim.burner = newmis; // Link target to the fire.
};

// Spawns a small flame that burns on the ground, if there is ground. If no ground is found, no flame is spawned.  Mostly for show.  Can inflict minor damage to those standing near the flame.
void(entity attacker, entity victim, vector spot) FloorFire = { // [FUNCTION]
    local   entity  swap;

    swap = self;
    self = spawn();
    self.movetype   = MOVETYPE_TOSS;
    self.solid      = SOLID_NOT;
    self.owner      = victim;       // Use 'world' to hit anything.
    setall (self, "", '0 0 0', '0 0 0', spot);
    if (droptofloor ()) {
        self.classname  = "fire";
        self.angles     = '0 0 0';
        self.velocity   = '0 0 0';
        self.owner      = 
        self.master     = attacker;   // Remember who really owns the flame.
        self.delay      = random() * 3 + 2 + time;
        self.wait       =
        self.nextthink  = 0.01;
        self.think      = FloorFire_Think;
        setall (self, "progs/drake/flame2.mdl", '-4 -4 -12', '4 4 16', self.origin + '0 0 12');
    } else {
        remove (self);
    }
    self = swap;
};

// This checks if a flame should drop after a fireball impact.
float(entity fire, float chance) FloorFire_ZoneCheck = { // [FUNCTION]
	local entity ent;
	local vector spot;

    if (random() < chance) {
        if (InLiquid(fire.origin)) return FALSE;       // Don't drop underwater.

        // Drop flame if it is not inside or directly above the owner.
        ent = fire.owner;
        spot = fire.origin;

        // Fire is 4 wide, plus 16 for possible missile clip bouns.
        if (spot_x > (ent.absmax_x + 21))  return TRUE;
        if (spot_y > (ent.absmax_y + 21))  return TRUE;
        if (spot_x < (ent.absmin_x - 21))  return TRUE;
        if (spot_y < (ent.absmin_y - 21))  return TRUE;
        if (spot_z < (ent.absmin_z - 21))  return TRUE;
    }
    return FALSE;
};

// This checks if a fireball impacts the floor.
float() FloorFire_FloorCheck = { // [FUNCTION]
    local vector p1, p2, vel;
    local float dot;

    vel = normalize (self.velocity);
    p1 = self.origin;
    p2 = p1 + (vel * 64);
    traceline (p1, p2, TRUE, world);
    vel = trace_plane_normal;
    dot = vel * '0 0 1';
    return (dot > 0.7071);   // Pass only if slope is less than 45 degrees.
};

// Attempts to spawn a small flame on the ground.  Called by fireballs' touch functions.
void(entity fire, float chance) FloorFire_SpawnCheck = { // [FUNCTION]
    if (FloorFire_ZoneCheck(fire,chance)) {
        if (FloorFire_FloorCheck()) FloorFire(fire.master,fire,fire.origin);
	}
};

// Fireballs
// Fireballs are flames turned on their side.  In the official GLQuake, this results in a shadow cast somewhere in the air.
//
// One solution would be to add a fireball scene.  However, that causes
// animation problems for embers in source ports that support frame
// interpolation.  In addition, some of the source ports don't let
// flames cast shadows (which is good).  Hence, no fireball scene.
//
// Update:  Some ports automatically substitute 'flame2.mdl' with
// other non-model graphics (decals?), and the projectiles appear more
// like long flame trails, which look really bad.  Therefore, allow
// the option for alternate fireball models.  Such models do not look
// good in vanilla GLQuake or some other ports, but it's better than
// nothing.
// Create and launch a small fireball.
void(entity attacker, vector start, vector dir, float sped, float damage) Fireball_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.movetype   = MOVETYPE_FLYMISSILE;
	newmis.classgroup = CG_PROJALL;
    newmis.solid      = SOLID_BBOX;
	newmis.frame = newmis.walkframe = 0;
	newmis.pos2 = '0 5 0.1';
    newmis.angles     = vectoangles(dir) + '90 0 0';
    newmis.speed      = sped;
    newmis.velocity   = dir * sped;
    newmis.touch      = Fireball_Touch;
    newmis.nextthink  = 0.01;
    newmis.think      = Fireball_Think;
    newmis.master = newmis.owner = attacker;
    newmis.delay      = time + 5; // Was (8000 / sped), like in Quake2.
    newmis.wait       = 0;
    newmis.dmg        = damage;
    newmis.classname  = "fire";
    newmis.pos1       = '90 0 0';
    setall(newmis, "progs/drake/flame2.mdl", '0 0 0', '0 0 0', start);
};

// Super-sized Fireballs (a.k.a. Meteor).  This creates a large, highly explosive fireball.
void(entity attacker, vector start, vector dir, float sped, float damage) Meteor_Launch = { // [FUNCTION]
	Fireball_Launch(attacker,start,dir,sped,damage);
    newmis.touch      = Meteor_Touch; // Classgroup is overridden later to ensure stuff sets on fire.
    newmis.think      = Meteor_Think;
    newmis.enemy      = world;
    newmis.effects    = newmis.effects | EF_DIMLIGHT;
    newmis.oldorigin  = start;
};

// Assumes 'self' is the firewall spawner missile.
// 'hot' = Spawn fire if TRUE, or spawn steam if FALSE.
void(vector spot, float hot) Firelink_Spawn = { // [FUNCTION]
    local entity fire;

    fire = spawn();
	fire.classgroup = CG_PROJALL;
    fire.owner      = self.owner;
    fire.master     = self.master;
    fire.angles     = self.angles;
    fire.movetype   = MOVETYPE_FLYMISSILE;  // Use for the clip bonus.
    fire.solid      = SOLID_TRIGGER;
    fire.frame = fire.walkframe = 17;
	fire.pos2 = '17 27 0.05';
    fire.wait       = 0;    // Time to burn on touch.
    if (hot) {
        fire.volume     = 233;  // Particle color - embers.
        fire.cnt        = 1;    // Particle count.
        // 17/7 = 2.42857.  Hexen2 dmg was 3.
        fire.dmg        = ceil(self.dmg * 0.075);
        setmodel (fire, "progs/drake/flame2.mdl");
    } else { // It's in liquid so no flame model.
        fire.volume     = 1;    // Steam
        fire.cnt        = 5;
        fire.dmg        = 0;    // Hot spot, minor damage.
        fire.modelindex = 0;    // No model.
    }
    setsize(fire, '0 0 0', '0 0 0');        
    setorigin(fire, spot);
    fire.nextthink  = time + 0.05;
    fire.think      = Firelink_Think;
    fire.touch      = Firelink_Touch;
};

//  Firewalls
//  The firewall is divided into two major parts:  the spawner and the
//  flames.  The spawner is an invisible missile that spawns flames
//  on the ground below it.  The flames are stationary flame missiles
//  that burn whoever touches them.
//
//  Code derived (and modified) from mummy.hc in Hexen2.
//  In Hexen2, Each flame spawned has 17 frames and lasted about 0.85 sec.
//  With 17 frames, each wall had up to 17 edicts per firewall, and that
//  is way too much for comfort.  In Quake, each for firewall has about
//  seven flames -- a bit high, but hardly any worse than the hell knight
//  missile spray.  To compensate, the damage is higher than in Hexen2.
//
//  Functions:
//   Firelink_*** = Flames in the firewall.
//   Firewall_*** = Invisible fire spawning missile.
void(vector start, vector dir, entity targ, float silent) Firewall_Spawn = { // [FUNCTION]
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
	newmis.movetype     = MOVETYPE_FLYMISSILE; // Explode if head impacts, similar to Maulotaur version (Heretic's Cyberdemon counterpart).
	newmis.solid        = SOLID_BBOX; // Can't use solid_trigger because of touch link breakage on contact...at least if we don't jump through hoops to avoid breakage.
    newmis.classname    = "fire"; // Use this so zombies burn on death.
	newmis.classgroup   = CG_PROJFIRE;
    newmis.speed        = SPEED_FIREWALL;
    newmis.movedir      = dir;
    newmis.velocity     = dir * SPEED_FIREWALL;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 80; // Use 120 for Maulotaur strength.
    newmis.enemy        = targ;
    newmis.yaw_speed    = 5;    // Thinks 20/sec, effective yaw_speed of 10.
    newmis.delay        = time + 3;     // Hexen2 used 2.5, not enough here.
    newmis.nextthink    = time + 0.05;
    newmis.think        = Firewall_Think;
    if (newmis.solid) newmis.touch = Firewall_Touch; // Only for Firewall, not Lightwall.
    setall(newmis,"",'0 0 0','0 0 0',start);   // Missile is invisible.
    if (!silent) sound(newmis,CHAN_WEAPON,"drake/weapons/fwall.wav",1,ATTN_NORM);
};

void(float skillaim) FirewallSetup = { // [FUNCTION]
    local vector org, dir;

    self.effects = self.effects | EF_MUZZLEFLASH;
    org = self.origin + self.view_ofs;
    dir = self.enemy.origin + self.enemy.view_ofs;
	if (skillaim) {
		if (skill >= 2) dir = Maim_Line (org, dir, SPEED_FIREWALL, self.enemy, VEC_ORIGIN); // As with Chthon, lead on Hard and up.
		else dir = Maim_Line (org, dir, SPEED_FIREWALL, world, VEC_ORIGIN);
	} else dir = Maim_Line(org,dir,SPEED_FIREWALL,world,'0 0 0');

	self.pos1 = org;
	self.pos2 = dir;
};

// Launch a firewall.  Designed for use by hell lords.
void() M_Firewall = { // [FUNCTION]
	FirewallSetup(TRUE); // Use skill based lead-up aiming.
    Firewall_Spawn(self.pos1,self.pos2,world,FALSE);
	if (skill >= 3) newmis.enemy = self.enemy; // On Nightmare or higher, the firewall seeks the enemy.  This wasn't present in Drake. -Qmaster
};

//  Light Wall.  Shares some with firewall code.  This is invisible and shoots lightning as it moves.
void(vector start, vector dir, entity targ) Lightwall_Spawn = { // [FUNCTION]
	Firewall_Spawn(start,dir,targ,TRUE);
	newmis.classgroup   = CG_PROJCELLS;
    newmis.movetype     = MOVETYPE_NOCLIP; // Pass through all.
    newmis.solid        = SOLID_NOT;
    newmis.classname    = "lightning";
    newmis.dmg          = 15;
    newmis.delay        = time + 6;
    sound(newmis,CHAN_WEAPON,"weapons/lstart.wav",1,ATTN_NORM);
};

// Launch a lightning wall.  Designed for use by storm knights.
void() M_Lightwall = { // [FUNCTION]
	FirewallSetup(FALSE);
    Lightwall_Spawn(self.pos1,self.pos2,world);
    if (skill >= 1) newmis.enemy = self.enemy; // Hack (hknight):  On Normal or higher, the bolt seeks the enemy.
};

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

// Magic Missiles -- Used by the wand and monsters such as hell knights.
void(vector start, vector dir, float sped) Knightspike_Launch = { // [FUNCTION]
    newmis = spawn ();
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLYMISSILE;
    newmis.solid = SOLID_BBOX;
    newmis.angles = vectoangles(dir);
    newmis.classname = "spike";
    newmis.think = SUB_Remove;
    newmis.nextthink = time + 6;
    setorigin (newmis, start);
    newmis.velocity = dir * 1000;
    setmodel (newmis, "progs/k_spike.mdl");
    setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);       
    newmis.worldtype = TE_KNIGHTSPIKE;
    newmis.classname = "knightspike";
    newmis.speed     = sped;
    newmis.velocity  = dir * sped;
};

// Is there any space left to spawn a hazard projectile?  Return TRUE if counter is lower than limit
float(entity targ, float maxextra) HazardProjectile_CheckLimit = {
	// Can't do a limit check if no limit (proj_limit) is set!  This allows for an override to be defined on attacker
	if (targ.proj_limit <= 0) {
		// Use global particle max to create limit
		// This is a good idea on paper, but this is trashing fps
		//targ.proj_limit = (part_max / (1024*part_multiplier)) * PROJ_MAXLIMIT;
		// Max limit = better default, anything higher will trash memory
		targ.proj_limit = PROJ_MAXLIMIT;
		dprint("\b[HAZARD]\b Monster ("); dprint(targ.classname);
		dprint(") Setup Max ("); dprint(ftos(targ.proj_limit));
		dprint(")\n");
	}
	// Really low chance of DP effects (def=0.02, -1=disabled)
	if (targ.dpp_flame == 0) targ.dpp_flame = 0.02;
	
	// has the hazard damage projectile limit been reached?
	// 'maxextra' used to check for complete projectile attack quantity
	if (targ.proj_count < (targ.proj_limit - maxextra)) return TRUE;
	else return FALSE;
};

// Single function for any increase in the projectile counter.  Double check the source entity exists first
void(entity targ) HazardProjectile_AddCounter = {
	// Does the source exist?
	if (targ.proj_source != world) {
		// Update counters on source entity
		if (targ.proj_source.proj_count >= 0) {
			targ.proj_source.proj_count = targ.proj_source.proj_count + 1;
		}
	}
};

/*======================================================================
 FLAME WALL PROJECTILE ATTACK
 * Uses sprites for animation/flame effect
 * Has radius and impact touch damage
======================================================================*/
// Wall of flame, left > right
// Easy = 3(-1/1), Normal = 5(-2/2), Hard/NM = 7(-3/3)
float(vector waveqty) SpriteCount_Flame = {
	float wave_count;
	wave_count = waveqty_x + (skill * waveqty_y);
	if (wave_count > waveqty_z) wave_count = waveqty_z;
	return wave_count;
};

//----------------------------------------------------------------------
// target entity, origin, v_forward, colour, size, lifetime, speed
void(entity targ, vector org, vector dir, float proj_color, float proj_size, float proj_life, float proj_speed) Launch_Flame = {
	// Check if the hazard projectile limit exists and has been reached?
	if ( !(HazardProjectile_CheckLimit(targ,1)) ) return;
	
	newmis = spawn ();
	newmis.owner = targ;
	newmis.classname = "proj_flame";	// obj name, not really used anymore
	newmis.classtype = CT_PROJ_FLAME;	// Class type number, quick identity
	newmis.classgroup = CG_PROJHAZARD;	// Special Hazard Projectile Type

	newmis.attack_speed = proj_speed;		// Projectile Speed (velocity)
	newmis.view_ofs = '0 0 16';				// Offset for particle effects
	newmis.oldorigin = newmis.origin = org;	// Save starting origin
	setorigin (newmis, newmis.origin);		// Move to start point

	// Allow for stationary fire hazards to exist
	if (newmis.attack_speed <= 0) newmis.movetype = MOVETYPE_NONE;
	else newmis.movetype = MOVETYPE_BOUNCE;
	// Need trigger type for monster/player interaction
	newmis.solid = SOLID_TRIGGER;

	// Monsters do extra (quad) damage to other monsters
	if (targ.flags & FL_MONSTER && targ.enemy.flags & FL_MONSTER) {
		// Take value from source monster so it can be changed
		newmis.infightextra = targ.infightextra;
	}
	
	// Setup Touch function and lifetime timer
	newmis.touch = Touch_HazardProjectile;
	if (proj_life <= 0) 
		newmis.attack_finished = time + LIFE_FLAME + random() + random();
	else newmis.attack_finished = time + proj_life;
	// On death, show puff of smoke and clear sounds
	newmis.part_exitpuff = targ.part_exitpuff;
	newmis.part_exitsound = targ.part_exitsound;
	newmis.part_exitfade = targ.part_exitfade;

	// Update hazard projectile counters
	newmis.proj_source = targ;
	HazardProjectile_AddCounter(newmis);

	// Allow for random selection of sprite size
	if (proj_size <= 0) {
		newmis.lip = random();
		// 20% Medium, 30% Small, 50% Tiny
		if (newmis.lip < 0.2) proj_size = FLAME_MED;
		else if (newmis.lip < 0.5) proj_size = FLAME_SML;
		else proj_size = FLAME_TINY;
	}

	// Default = Tiny flame
	if (proj_size == FLAME_SML) {
		newmis.bbmins = '-6 -6 0'; newmis.bbmaxs = '6 6 24';
		if (proj_color == FLAME_BLUE) setmodel (newmis, MODEL_PROJ_BFLAMESML);
		else if (proj_color == FLAME_GREEN) setmodel (newmis, MODEL_PROJ_GRFLAMESML);
		else setmodel (newmis, MODEL_PROJ_FLAMESML);		// 24x64 BB=12x24
	} else if (proj_size == FLAME_MED) {
		newmis.bbmins = '-8 -8 0'; newmis.bbmaxs = '8 8 32';
		if (proj_color == FLAME_BLUE) setmodel (newmis, MODEL_PROJ_BFLAMEMED);
		else if (proj_color == FLAME_GREEN) setmodel (newmis, MODEL_PROJ_GRFLAMEMED);
		else setmodel (newmis, MODEL_PROJ_FLAMEMED);		// 32x96 BB=16x32
	}
	/* Maybe add it later
	else if (proj_size == FLAME_VLRG) {
		newmis.bbmins = '-12 -12 0'; newmis.bbmaxs = '12 12 48';
		if (proj_color == FLAME_BLUE) setmodel (newmis, MODEL_PROJ_BFLAMEVLRG);
		else if (proj_color == FLAME_GREEN) setmodel (newmis, MODEL_PROJ_GRFLAMEVLRG);
		else setmodel (newmis, MODEL_PROJ_FLAMEVLRG);	// 48x128 BB=24x48
	} */
	else {
		newmis.bbmins = '-4 -4 0'; newmis.bbmaxs = '4 4 16';
		if (proj_color == FLAME_BLUE) setmodel (newmis, MODEL_PROJ_BFLAMETINY);
		else if (proj_color == FLAME_GREEN) setmodel (newmis, MODEL_PROJ_GRFLAMETINY);
		else setmodel (newmis, MODEL_PROJ_FLAMETINY);	// 16x48 BB=8x16
	}
	
	// override sprite default bounding box
	setsize (newmis, newmis.bbmins, newmis.bbmaxs);
	// Setup starting (randomize) frame
	newmis.walkframe = rint(random() * FRAME_FLAME);
	if (newmis.walkframe >= FRAME_FLAME) newmis.walkframe = 0;
	newmis.frame = newmis.walkframe;
	newmis.velocity = dir; // Movement done in projectile tick function
	newmis.avelocity = '0 0 0';
	newmis.lip = random();
	if (newmis.lip < 0.25) newmis.noise = "ambience/flames1.wav";
	else if (newmis.lip < 0.5) newmis.noise = "ambience/flames2.wav";
	else if (newmis.lip < 0.75) newmis.noise = "ambience/flames3.wav";
	else newmis.noise = "ambience/flames4.wav";
	sound(newmis, CHAN_VOICE, newmis.noise, 0.3, ATTN_IDLE);
	newmis.volume = time + 1;
	if (proj_color == FLAME_BLUE) newmis.part_trstyle = PARTICLE_TRAIL_PLASMA; // Setup particle defaults for hazard emitter
	newmis.part_trstyle = PARTICLE_TRAIL_YELLOW;
	Default_ParticleTrail(newmis);
	// Manually animate the sprite flames
	newmis.nextthink = time + 0.1;
	newmis.think = Animate_HazardProjectile;
};

/*======================================================================
 FLAME TRAIL PROJECTILE ATTACK
 * Uses sprites for animation/flame effect
 * Has radius and impact touch damage
======================================================================*/
void(vector org, vector dir, float proj_color, string proj_sfx) Launch_Trail = {
	// Check if the hazard projectile limit exists and has been reached?
	if ( !(HazardProjectile_CheckLimit(self,1)) ) return;
	
	// Is the flame trail controller setup?
	if (!self.proj_trcont) self.proj_trcont = spawn ();
	// Is the flame trail currently active?
	if (self.proj_trcont.count > 0) return;
	
	self.proj_trcont.owner = self;
	self.proj_trcont.classname = "proj_trail";
	self.proj_trcont.classtype = CT_CONTROL;
	self.proj_trcont.classgroup = CG_PROJHAZARD;
	self.proj_trcont.solid = SOLID_NOT;
	self.proj_trcont.movetype = MOVETYPE_NONE;
	self.proj_trcont.origin = self.origin + '0 0 64';
	setorigin(self.proj_trcont, self.proj_trcont.origin);
	setsize(self.proj_trcont, VEC_ORIGIN, VEC_ORIGIN);
	self.proj_trcont.movedir = dir;
	
	// Quantity of sprites per line
	if (self.proj_trqty <= 0) self.proj_trqty = FLAME_TRCOUNT;
	// Always reset count to new value (loop variable)
	self.proj_trcont.count = self.proj_trqty;

	// Sprite flame colour (def=red)
	if (proj_color <= 0) self.proj_trcont.lip = FLAME_RED;
	else self.proj_trcont.lip = proj_color;
	// Setup explosion sprite to match projectile
	if (self.proj_trcont.lip == FLAME_BLUE)
		self.proj_trcont.attack_expflame = EXPLODE_PLASMA_BIG;
	else self.proj_trcont.attack_expflame = EXPLODE_BIG;
	// Final explosion sound FX
	if (proj_sfx == "") self.proj_trcont.noise = SOUND_REXP3;
	else self.proj_trcont.noise = proj_sfx;
	
	// Setup trail segment distance, random wobble and max step height
	if (self.proj_trdist <= 0) self.proj_trdist = FLAME_TRDIST;
	if (self.proj_trwobble <= 0) self.proj_trwobble = FLAME_TRWOBBLE;
	if (self.proj_trstep <= 0) self.proj_trstep = FLAME_TRSTEP;

	// Final explosive damage at end of line/trail (-1 = no damage)
	if (self.proj_trdmg == 0) self.proj_trdmg = FLAME_TREXPLODE;
	// Life time for flames to remain on floor (x + rnd + rnd)
	if (self.proj_trlife <= 0) self.proj_trlife = FLAME_TRLIFE;
	
	// Speed at which flame line is created (tick speed)
	// Skill based speed 0=0.10, 1=0.08, 2=0.06, 3=0.04
	if (self.proj_trspeed > 0.04) self.proj_trcont.speed = self.proj_trspeed;
	else self.proj_trcont.speed = 0.1 - (skill * FLAME_TRSPEED);
	// Always have lower limit for speed tick value
	if (self.proj_trcont.speed < 0.04) self.proj_trcont.speed = 0.04;
	
	// Setup STEP height as a vector
	self.proj_trcont.finaldest = '0 0 0'; 
	self.proj_trcont.finaldest_z = self.proj_trstep + 8;

	// Find out start position
	traceline(org, org - self.proj_trcont.finaldest, TRUE, self);
	self.proj_trcont.pos1 = trace_endpos;
	
	// Start with initial flame.  target, origin, v_forward, colour, size, lifetime, speed
	Launch_Flame (self, self.proj_trcont.pos1, '0 0 0', self.proj_trcont.lip, -1, -1, 0);
	self.proj_trcont.think = Fire_Trail; // Keep the conga line going ...
	self.proj_trcont.nextthink = time + self.proj_trcont.speed;
};

// Hazard projectiles are about denying movement space to players
// and creating a temporary hazard to naviagate around
//
// Players who jump a lot and have greater DM focused movement skills,
// will find hazard damage projectiles easier to deal with.
//
// Hazard projectiles often have particle emitters or effects
// which can quickly drag down engine FPS. All hazard projectiles
// need to maintain counters to help performance.
//
// Kill triggers can be dangerous on monsters that use hazard
// projectiles because the counters are not zero'd correctly
//
// Void triggers do cope with hazard projectile counters
// Uses models and particle/trails for effects.  Has radius and impact touch damage
void(vector org, vector dir, vector avel, float proj_type) Launch_Hazard = {
	// Check if the hazard projectile limit exists and has been reached?
	if ( !(HazardProjectile_CheckLimit(self,1)) ) return;
	
	newmis = spawn ();
	newmis.owner = self;
	newmis.classname = "proj_hazard";	// obj name, not really used anymore
	newmis.classtype = proj_type;		// Class type number, quick identity
	newmis.classgroup = CG_PROJHAZARD;	// Special Hazard Projectile Type
	newmis.movetype = MOVETYPE_BOUNCE;	// Bounce like a grenade, classic arc
	newmis.solid = SOLID_BBOX;			// trigger is limited, use bbox until touch
	newmis.bbmins = '-4 -4 0'; 			// Save for touch function
	newmis.bbmaxs = '4 4 0';
	newmis.touch = Touch_HazardProjectile; // Setup Touch function and lifetime timer
	newmis.attack_finished = time + LIFE_HAZARD + random() + random();
	newmis.proj_source = self; // Update hazard projectile counters
	HazardProjectile_AddCounter(newmis);

	// Monsters do extra (quad) damage to other monsters
	if (self.flags & FL_MONSTER && self.enemy.flags & FL_MONSTER) {
		// Take value from source monster so it can be changed
		newmis.infightextra = self.infightextra;
	}

	// Setup model for each missile type
	if (proj_type == CT_PROJ_DPRINCE2) {
		setmodel(newmis, self.attack_proj2);
		newmis.part_qctrail = TRUE;
		newmis.part_trstyle = self.part_trstyle;
		newmis.frame = rint((random() * 9));
		newmis.part_soundmiss = "ad171/wraith/bounce.wav";
	} else if (proj_type == CT_PROJ_SWEEPER2) {
		setmodel(newmis, self.attack_proj2);
		newmis.part_qctrail = TRUE;
		newmis.part_trstyle = self.part_trstyle;
		newmis.frame = rint((random() * 9));
		newmis.part_soundmiss = "ad171/wraith/bounce.wav";
	}
	
	// Standard projectile setup (origin, size and velocity)
	newmis.velocity = dir;
	newmis.avelocity = avel;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.oldorigin = newmis.origin = org;	// Save starting origin
	setorigin (newmis, newmis.origin);		// Move to start point
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);

	// Burning touch sound (precached in world.qc)
	newmis.part_soundtouch = GIB_SOUND_ACID;
	// Setup particle defaults for hazard emitter
	Default_ParticleTrail(newmis);
	newmis.think = Custom_ParticleTrail;	
	newmis.nextthink = time + 0.1;

	// Special particle trail
	if (newmis.part_qctrail == TRUE ) {
		// Is DP/FTE/QSS engine active for particle trail feature?
		if (ext_dppart && newmis.dpp_name != "") {
			newmis.traileffectnum = particleeffectnum(newmis.dpp_name);
			newmis.effects = 0;
		}
		// Particle trail needs quick update
		newmis.nextthink = time + 0.02;
	}
};

// Work out direction speed of egg and then launch it!
void(vector eggofs) Create_Egg = {
	local vector org, dir;
	local float egg_speed;
	if (self.health < 1) return;
	
	// Turn towards player and drop the egg!
	makevectors(self.angles);
	org = self.origin + attack_vector(eggofs);
	egg_speed = self.minion_throwspeed + (random() * self.minion_throwextra);
	dir = (v_forward * egg_speed) + (v_right * (crandom()*self.minion_throwside));
	Launch_Grenade(org,dir,'0 0 0',CT_PROJ_MEGG);
	SUB_AttackFinished (2 + random());
};

// Convert the movetype back to MOVETYPE_STEP cas we are finished with the velocity change (we should be anyway).
void() removeFlyMode = {
	self.owner.movetype = MOVETYPE_STEP;
	self.owner.AIRG_Flags = self.owner.AIRG_Flags - AIRG_STEPCONVERTEDTOFLY;
	remove(self); // don't need self anymore, remove self.
};

// Modification of infront() from ai.qc to be tighter
float (entity e) hornInfront = {
	local vector vec;
	local float dot;

	makevectors (self.v_angle);
	vec = normalize (e.origin - self.origin - self.view_ofs);
	dot = vec * v_forward;
	if (dot > 0.8) { return TRUE; }

	return FALSE;
};

// The main code for when the Airfist is fired.
void() launch_horn = {
	local entity e;
	local vector delta, dir;
	local float eSpeed, dist, percent, ldmg, nearAWall, inDamage, inRange, recoil;

	// Constants used in the control of how the Airfist works
	inDamage = 20; // Maximum damage that can be incurred by the Airfist.  The actual entity's damage is based on the distance from the center of the shot.
	inRange = 400; // Range of the Airfist blast.
	recoil = 300; // Recoil strength of the Airfist on the player that shot the weapon.
	if (self.tome_finished) {
		inDamage = inDamage * 2; // Double damage
		recoil = recoil * 2; // Double impact force for player
	}
	nearAWall = 0; // By default, assume not near a wall.

	if (!self.button0) { player_run (); return; } // Make such that all previous attack code completes.

	W_Reload(0.5); // How long the fire time is.

	// First attack in the shotTimeout period
	if(self.AIRG_FireCount == 0 || self.AIRG_Timeout < time) {
		self.AIRG_Timeout = time + 6; // Set timeoute length
		self.AIRG_FireCount = 1; // and the count
	} else if(self.AIRG_FireCount >= 5) { // Max Fire Rate reached, so this is a failed shot.
		if(self.waterlevel > 2) // Play failed AirFist sound
			sound (self, CHAN_AUTO, "weapons/agwfail.wav", 1, ATTN_NORM); // Below the water, play under water sound
		else
			sound (self, CHAN_AUTO, "weapons/agfail.wav", 1, ATTN_NORM); // Play above water sound

		player_failedairgun1(); // Play Failed AirFist animation
		return;					// and get out of here.
	} else {
		// Count number of shots.
		self.AIRG_FireCount = self.AIRG_FireCount + 1;
	}

	if(self.waterlevel > 2) { // if under water, change the variables
		inRange = inRange * 0.80; // reduced the range by %20
		inDamage = inDamage * 2; // double the damage possible
	}

	// Get all the entity's in the shot range
	makevectors(self.v_angle);
	e = findradius(self.origin, inRange);
	while (e) {
		if (e == self || e.solid == SOLID_BSP || e.movetype == MOVETYPE_NONE || (e.AIRG_Flags & AIRG_EXCLUDEENTITY)) {e = e.chain; continue; } // This is the exclusion code.  It excludes everything that is "Illegal" to move. eg. doors.

		if (visible(e) && (self.waterlevel > 2 || hornInfront(e)) && (AffectedByPhysics(e) || e.flags & FLx_CREATURE)) { // Affect monsters and projectiles
			// if flying creature and movetype is step then change to fly
			// NOTE: For some reason the normal quakeC, flying monsters has set a
			// movetype of MOVETYPE_STEP which means that changing the velocity
			// does not do anything.  Our workaround was to change the movetype
			// to MOVETYPE_FLY.  Flying monsters where then affected by
			// velocity.  In all our testing we found that this only affected the
			// entity's when they died.  When dead, they fall UP instead of down.
			// Other than this they did not seam to have any adverse affect.  If you
			// find that you have trouble with this code, let us know.
			if(e.flags & FL_FLY) {
				if(e.movetype == MOVETYPE_STEP) {
					e.movetype = MOVETYPE_FLY; // set so we can affect velocity

					// Create an entity to remove the MOVETYPE_FLY when we are done with it.
					// The only problem with using this method is that while the entity
					// is dead but the tracker has not converted it back to STEP, the
					// entity will fall up until changed.  For a generic method, we
					// at the Evolve team can live with that.
					e.AIRG_FlyTracker = spawn();
					e.AIRG_Flags = e.AIRG_Flags + AIRG_STEPCONVERTEDTOFLY;
					e.AIRG_FlyTracker.owner = e;
					e.AIRG_FlyTracker.nextthink = time + 2;
					e.AIRG_FlyTracker.think = removeFlyMode;
				} else if(e.AIRG_Flags & AIRG_STEPCONVERTEDTOFLY) {
					e.AIRG_FlyTracker.nextthink = time + 2; // We have already converted this one, just extend the time to convert
				}
			}

			// Calculate the distance from the entity.
			delta = e.origin - self.origin + self.view_ofs;
			dist = vlen(delta);
			percent = (inRange - dist) / inRange; // Convert distance to a percentage.
			if (e.flags & FL_ONGROUND) {
				setorigin(e, e.origin + '0 0 1'); // Raise the bugger a bit; if they're on the ground, we raise them up so that the velocity will take affect.

				// We biased the up direction when entity is on the ground.
				// Looks cooler and small entitys (heath, etc) go somewhere instead
				// of along the ground (because they're below the line of sight).
				e.flags = e.flags - FL_ONGROUND; // If on the ground, makem go up, up, and away
				if (delta_z < 0) delta_z = delta_z / -2;
				delta = delta * 0.7;
				if (delta_z < 100) delta_z = 100;
			}

			delta = normalize(delta);
			delta = delta * percent * 1000; // Calculate the velocity adjustment.  Maximum strength of the Airfist is 1000.  The strength of the affected entity's movement is based on the distance from the center of the shot.
			if(self.waterlevel > 2) { // if under water, change the blast amount
				if ((percent >= 0.50) && (e.classname == "player") && (self.radsuit_finished == 0)) self.air_finished = time - 1; // If within 1/2 radius of the blast and is a player and not wearing bio that's it, no more air for him, choke time!!!
				if (hornInfront(e)) { // infront of self
					delta = delta * 0.80; // reduce by %20
				} else { // All other entity's are hit by water movement.
					delta = delta * 0.50; // reduce by %50  
					percent = percent * 0.50; // reduce the damage possible as well
				}
			}

			if (IsMissile(e)) { // If its a missile, change the direction but keep the same speed.
				eSpeed = vlen(e.velocity);
				e.velocity = normalize(delta) * eSpeed;
			} else {
				e.velocity = e.velocity + delta; // Apply the velocity adjustment
				ldmg = percent * inDamage; // Calculate the damage amount

				// This section of code is to even of the "figure momentum add" in the
				// T_Damage function that recoils damaged entity's away from the attacker.
				// NOTE:  If that section of code in T_Damage changes, then this will have to change.
				if(e.movetype != MOVETYPE_WALK) { // to even out the T_Damage "figure momentum add"
				  dir = e.origin - (self.absmin + self.absmax) * 0.5;
				  dir = normalize(dir);
				  e.velocity = e.velocity + dir * ldmg * 8;
				}

				T_Damage(e, self, self, ldmg, NOARMOR); // Apply damage to the entity.
			}
		}
		e = e.chain;
	}
	if(self.waterlevel > 2) death_bubbles(3); // below the water, produce bubbles
	makevectors(self.v_angle);
	dir = self.origin + self.view_ofs;
	traceline (dir, dir + v_forward * 64, FALSE, self); // check if near a wall
	if (trace_fraction != 1.0 && !trace_ent.takedamage) nearAWall = 1;

	// Produce the AirFist fire blast sprites to the top left and right of the self's view.
	if(self.waterlevel > 2) { // under water, go slower (%50 slower)
		hornBlastSprite(nearAWall, 50, -50, 300, -20, 0.50);
		hornBlastSprite(nearAWall, 50, 50, 300, 20, 0.50);
		if (self.tome_finished) {
			hornBlastSprite(nearAWall, 48, -50, 305, -20, 0.6);
			hornBlastSprite(nearAWall, 48, 50, 305, 20, 0.6);
		}
	} else { // above water, normal speed
		hornBlastSprite(nearAWall, 50, -50, 300, -20, 1.0);
		hornBlastSprite(nearAWall, 50, 50, 300, 20, 1.0);
		if (self.tome_finished) {
			hornBlastSprite(nearAWall, 48, -50, 305, -20, 1.5);
			hornBlastSprite(nearAWall, 48, 50, 305, 20, 1.5);
		}
	}

	// Recoil code
	if (self.flags & FL_ONGROUND) { // Raise the bugger a bit; if self on the ground, raise me up so that the velocity will take affect.
		setorigin(self, self.origin + '0 0 1');
		self.flags = self.flags - FL_ONGROUND;
	}
	if(nearAWall) recoil = recoil + (recoil * (1.0 - trace_fraction) * 3); // hit wall, Bounce based on the distance from the wall
	self.velocity = self.velocity + v_forward * recoil * -1; // recoil self

	if(self.waterlevel > 2)	sound (self, CHAN_AUTO, "weapons/agwater.wav", 1, ATTN_NORM); // below the water, play under water sound
	else					sound (self, CHAN_AUTO, "weapons/agfire.wav", 1, ATTN_NORM); // play above water sound

	player_airgun1(); // AirFist gun frame animation
};