//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake and Soul of Evil by Patrick Martin
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
// Entity count: 1
// Function count: 83
//
// Implements: Boil
//
// Description:
// Bulbous blob of flesh that explodes when it is near something it hates.
// Can walk on two legs towards its enemy.  Sometimes found nailed and hanging
// about as an explosive trap.
//=============================================================================

// BOIL/BOMB model by Ijed, QC/Gameplay by Sock

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15 stand16
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame explode1 explode2 explode3 explode4 explode5 explode6
$frame explode7 explode8 explode9
$frame hobA1 hobA2 hobA3 hobA4 hobA5 hobA6 hobA7 hobA8 hobA9 hobA10
$frame hobB1 hobB2 hobB3 hobB4 hobB5 hobB6 hobB7 hobB8 hobB9 hobB10

void() boil_stand1 = [$stand1, boil_stand2 ] { monster_idle_sound(); ai_stand(); }
void() boil_stand2 = [$stand2, boil_stand3 ] { ai_stand(); };
void() boil_stand3 = [$stand3, boil_stand4 ] { ai_stand(); };
void() boil_stand4 = [$stand4, boil_stand5 ] { ai_stand(); };
void() boil_stand5 = [$stand5, boil_stand6 ] { ai_stand(); };
void() boil_stand6 = [$stand6, boil_stand7 ] { ai_stand(); };
void() boil_stand7 = [$stand7, boil_stand8 ] { ai_stand(); };
void() boil_stand8 = [$stand8, boil_stand9 ] { ai_stand(); };
void() boil_stand9 = [$stand9, boil_stand10 ] { ai_stand(); };
void() boil_stand10 = [$stand10, boil_stand11 ] { ai_stand(); };
void() boil_stand11 = [$stand11, boil_stand12 ] { ai_stand(); };
void() boil_stand12 = [$stand12, boil_stand13 ] { ai_stand(); };
void() boil_stand13 = [$stand13, boil_stand14 ] { ai_stand(); };
void() boil_stand14 = [$stand14, boil_stand15 ] { ai_stand(); };
void() boil_stand15 = [$stand15, boil_stand16 ] { ai_stand(); };
void() boil_stand16 = [$stand16, boil_stand1 ] { ai_stand(); };

void() boil_walk1 = [$walk1, boil_walk2 ] { monster_idle_sound(); ai_walk(0); };
void() boil_walk2 = [$walk2, boil_walk3 ] { monster_footstep(TRUE); ai_walk(3); };
void() boil_walk3 = [$walk3, boil_walk4 ] { ai_walk(4); };
void() boil_walk4 = [$walk4, boil_walk5 ] { ai_walk(3); };
void() boil_walk5 = [$walk5, boil_walk6 ] { ai_walk(3); };
void() boil_walk6 = [$walk6, boil_walk7 ] { ai_walk(2); };
void() boil_walk7 = [$walk7, boil_walk8 ] { ai_walk(1); };
void() boil_walk8 = [$walk8, boil_walk9 ] { ai_walk(2); };

void() boil_walk9 = [$walk9, boil_walk10 ] { ai_walk(0); };
void() boil_walk10 = [$walk10, boil_walk11 ] { monster_footstep(TRUE); ai_walk(3); };
void() boil_walk11 = [$walk11, boil_walk12 ] { ai_walk(1); };
void() boil_walk12 = [$walk12, boil_walk13 ] { ai_walk(2); };
void() boil_walk13 = [$walk13, boil_walk14 ] { ai_walk(3); };
void() boil_walk14 = [$walk14, boil_walk15 ] { ai_walk(3); };
void() boil_walk15 = [$walk15, boil_walk16 ] { ai_walk(2); };
void() boil_walk16 = [$walk16, boil_walk1 ] { ai_walk(2); };

void() boil_run1 = [$run1, boil_run2 ] { monster_footstep(TRUE); ai_run(4); };
void() boil_run2 = [$run2, boil_run3 ] { monster_idle_sound(); ai_run(16); };
void() boil_run3 = [$run3, boil_run4 ] { ai_run(8); };
void() boil_run4 = [$run4, boil_run5 ] { ai_run(4); };
void() boil_run5 = [$run5, boil_run6 ] { monster_footstep(TRUE); ai_run(4); };
void() boil_run6 = [$run6, boil_run7 ] { ai_run(16); };
void() boil_run7 = [$run7, boil_run8 ] { ai_run(8); };
void() boil_run8 = [$run8, boil_run1 ] { ai_run(4); };

// Running Boil Explosive Attack
void() boil_expl1 = [$explode1, boil_expl2 ] { ai_face();
	sound(self,CHAN_VOICE, "ad171/zombie/boil_windup.wav",1,ATTN_NORM); };
void() boil_expl2 = [$explode2, boil_expl3 ] { ai_face(); };
void() boil_expl3 = [$explode3, boil_expl4 ] { ai_face(); };
void() boil_expl4 = [$explode4, boil_expl5 ] { ai_face(); };
void() boil_expl5 = [$explode5, boil_expl6 ] { ai_face(); };
void() boil_expl6 = [$explode6, boil_expl7 ] { ai_face(); };
void() boil_expl7 = [$explode7, boil_expl8 ] { ai_face(); };
void() boil_expl8 = [$explode8, boil_expl9 ] { ai_face(); };
void() boil_expl9 = [$explode9, boil_expl9 ] {
	T_Damage(self,self,self,self.health+1,NOARMOR);
};

// Stationary Boil - Nailed to the floor or wall
void() boil_suicide = { // [FUNCTION]
	if (self.health < 1) return;
	self.use = SUB_Null;
	// Make sure current enemy is the cause of the damage
	T_Damage(self,self,self.enemy,self.health+1,NOARMOR);
};

void() boil_checktarget = { // [FUNCTION]
	local entity client;

	self.enemy = self.goalentity = world; // Should never have an active enemy
	
	// Get the obvious exception(s) done first
	if (self.health < 1) return;
	if (frame_pause()) return;

	client = checkclient(); // Find a client in current PVS
	if (!client) return FALSE; // Go through all the exception(s)
	if (!(client.flags & FL_CLIENT)) return;
	if (Invisible(client)) return;

	enemy_vis = visible(client); // Check if the player is trace visible?
	if (!enemy_vis) return;

	self.enemy = client; // Store client/player for later damage
	self.enemydist = range_distance(client, FALSE); // Is the player within range to blow up?
	if (self.enemydist < self.t_width) self.th_melee();
};

void() boil_squirtblood = { // [FUNCTION]
	if (self.waitmin < time) {
		self.waitmin = time + self.wait + random() * self.wait;
		sound(self,CHAN_WEAPON,"ad171/wraith/bounce.wav",1,ATTN_IDLE);
		
		SpawnProjectileMeat(self,self.origin,self.brkvelbase_x, self.brkvelbase_y, self.brkvelbase_z);
		// Randomly spawn an extra gib of flesh
		if (random() < 0.25) SpawnProjectileMeat(self,self.origin,self.brkvelbase_x, self.brkvelbase_y, self.brkvelbase_z);
	}
};

void() boil_hoba1 = [$hobA1, boil_hoba2 ] {
	self.nextthink = self.nextthink + random()*0.2;
	monster_idle_sound();boil_squirtblood();boil_checktarget();
};
void() boil_hoba2 = [$hobA2, boil_hoba3 ] { boil_checktarget(); };
void() boil_hoba3 = [$hobA3, boil_hoba4 ] { self.nextthink = self.nextthink + random()*0.2; boil_checktarget(); };
void() boil_hoba4 = [$hobA2, boil_hoba1 ] { boil_checktarget(); };

void() boil_HexpA1 = [$hobA2, boil_HexpA2 ] { sound(self,CHAN_VOICE, "ad171/zombie/boil_windup.wav",1,ATTN_NORM); };
void() boil_HexpA2 = [$hobA3, boil_HexpA3 ] {};
void() boil_HexpA3 = [$hobA4, boil_HexpA4 ] {};
void() boil_HexpA4 = [$hobA5, boil_HexpA5 ] {};
void() boil_HexpA5 = [$hobA6, boil_HexpA6 ] {};
void() boil_HexpA6 = [$hobA7, boil_HexpA7 ] {};
void() boil_HexpA7 = [$hobA8, boil_HexpA8 ] {};
void() boil_HexpA8 = [$hobA9, boil_HexpA9 ] {};
void() boil_HexpA9 = [$hobA10, boil_HexpA9 ] { boil_suicide(); };

void() boil_hobb1 = [$hobB1, boil_hobb2 ] { self.nextthink = self.nextthink + random()*0.2; monster_idle_sound();boil_squirtblood();boil_checktarget(); };
void() boil_hobb2 = [$hobB2, boil_hobb3 ] { boil_checktarget(); };
void() boil_hobb3 = [$hobB3, boil_hobb4 ] { self.nextthink = self.nextthink + random()*0.2; boil_checktarget(); };
void() boil_hobb4 = [$hobB2, boil_hobb1 ] { boil_checktarget(); };

void() boil_HexpB1 = [$hobB2, boil_HexpB2 ] { sound(self,CHAN_VOICE, "ad171/zombie/boil_windup.wav",1,ATTN_NORM); };
void() boil_HexpB2 = [$hobB3, boil_HexpB3 ] {};
void() boil_HexpB3 = [$hobB4, boil_HexpB4 ] {};
void() boil_HexpB4 = [$hobB5, boil_HexpB5 ] {};
void() boil_HexpB5 = [$hobB6, boil_HexpB6 ] {};
void() boil_HexpB6 = [$hobB7, boil_HexpB7 ] {};
void() boil_HexpB7 = [$hobB8, boil_HexpB8 ] {};
void() boil_HexpB8 = [$hobB9, boil_HexpB9 ] {};
void() boil_HexpB9 = [$hobB10, boil_HexpB9 ] { boil_suicide(); };

// NO PAIN
void(entity inflictor, entity attacker, float take) boil_pain = {
	SpawnProjectileSmoke(self.origin, self.brkvelbase_x, self.brkvelbase_y, self.brkvelbase_z); // Spawn some grey particles
	SpawnProjectileMeat(self,self.origin, self.brkvelbase_x, self.brkvelbase_y, self.brkvelbase_z); // and chunk of meat
	if (random() < 0.5) { 
		SpawnProjectileSmoke(self.origin, self.brkvelbase_x, self.brkvelbase_y, self.brkvelbase_z); // Random chance of more smokey meat
		SpawnProjectileMeat(self,self.origin, self.brkvelbase_x, self.brkvelbase_y, self.brkvelbase_z);
	}
	return; // No special animation
};

void() boil_explode = { // [FUNCTION]
	local entity head;
	local float cand;

	// Needs special version of radius damage function (T_RadiusDamage)
	// Boss monsters are always immune to this kind of damage
	// Needs to do infighting damage before T_Damage function
	// There is no rocket resistance to this kind damage!
	// Must pass on self.enemy so that any death triggers work properly

	self.enemytarget = findradius(self.origin, self.death_dmg+40);
	// Loop through chain list
	while(self.enemytarget) {
		cand = FALSE;
		// Ignore self and world and can never damage bosses
		if (self.enemytarget != world && self.enemytarget != self && self.enemytarget.bossflag == 0) {
			// Check for any breakables which are prone to explosive damage
			if (ai_foundbreakable(self.enemy, self.enemytarget,TRUE) && self.enemytarget.brktrigmissile != 0) {
				trigger_ent(self.enemytarget, self.enemy);
			} else {
				// Can be damaged and NOT immune to radius (splash) damage
				if (self.enemytarget.takedamage > 0 && self.enemytarget.noradiusdmg == 0) {
					if (CanDamage (self.enemytarget, self)) cand = TRUE; // Need CanDamage to check for anything blocking LoS

					// Make sure monsters take more damage
					if (self.enemytarget.flags & FL_MONSTER) {
						if (self.enemytarget.bodyonflr == MON_ONFLR) {
							if (cand && (self.enemytarget.health > FALSE)) monster_flrbody_gib(self.enemytarget, (self.death_dmg * self.infightextra));
						}
						self.dmg = self.death_dmg * self.infightextra;
					} else {
						// Use original radius formula for non monsters
						self.pos1 = self.enemytarget.origin + (self.enemytarget.mins + self.enemytarget.maxs)*0.5;
						self.dmg = 0.5*vlen (self.origin - self.pos1);
						if (self.dmg < 0) self.dmg = 0;
						self.dmg = self.death_dmg - self.dmg;
					}
					
					if (self.dmg > 0 && self.enemytarget.health > 0) {
						if (cand) {
							// Pass on self.enemy so death triggers fire correctly
							T_Damage(self.enemytarget, self, self.enemy, self.dmg, DAMARMOR);
							// make sure to check for poisonous and apply debuff
							if (self.dmg > 0 && self.poisonous == TRUE) PoisonDeBuff(self.enemytarget);
						}
					}
				}
			}
		}
		self.enemytarget = self.enemytarget.chain; // Move forward in chain to next entity
	}
	
	// Switch explosions effect based on poison flag
	if (self.poisonous) {
		Tent_Explosion2(self.origin,51,8);
	} else {
		Tent_Explosion(self.origin); // Show classic grenade explosion effect
	}
	// Can drop health packs! - randomizer
	if (self.healamount > 0) DropHealthpack();
};

void() boil_die = { // [FUNCTION]
	// Upward fountain of gibs
	self.max_health = MON_GIBFOUNTAIN;
	monster_death_precheck();
	// New gib + loud explosion sound
	sound(self,CHAN_AUTO,"ad171/zombie/boil_explode.wav",1,ATTN_NORM);
	// Delay the t_radius explosion for one frame
	// Just in case several are standing next to each other
	// otherwise there will be a runaway crash loop
	self.think = boil_explode;
	self.nextthink = time + 0.1;
};

void() monster_boil_precache = { // [FUNCTION]
	precache_model ("progs/ad171/mon_boil.mdl");
	precache_sound("ad171/zombie/boil_idle1.wav");
	precache_sound("ad171/zombie/boil_idle2.wav");
	precache_sound("ad171/zombie/boil_sight.wav");
	precache_sound("ad171/wraith/bounce.wav");
	precache_sound("ad171/zombie/boil_windup.wav");
	precache_sound("ad171/zombie/boil_explode.wav");
	precache_poisongibs();			// precache gibs
};

// QUAKED monster_boil (1 0 0) (-16 -16 -24) (16 16 32)
void() monster_boil = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/ad171/mon_boil.mdl";
	self.idle_sound = "ad171/zombie/boil_idle1.wav";
	self.idle_sound2 = "ad171/zombie/boil_idle2.wav";
	self.sight_sound = "ad171/zombie/boil_sight.wav";
	self.pain_sound = SOUND_EMPTY;
	if (self.poisonous) self.gibtype = GIBTYPE_POISON;	// Check for poisonous entity flag and give poisonous blood trails
	if (self.healamount > 0) world.deventity.health = world.deventity.health + self.healamount; // The randomizer drops health packs on death.
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	if (self.health < 1) self.health = 40;
	self.gibhealth = -60;				// Never used
	self.gibbed = FALSE;				// In one piece
	self.pain_flinch = 10;				// Has gib splash
	self.steptype = FS_TYPESLOW;		// Tiny feet
	self.gibondeath = TRUE;				// Always blow up!
	self.blockudeath = TRUE;			// No humanoid death sound
	if (self.death_dmg < 1) self.death_dmg = DAMAGE_BOIL;
	if (self.infightextra < 1) self.infightextra = 16;
	self.attack_instant = 1;			// Start moving right away
	self.deathstring = " was blown away by a Boil\n";
	if (self.wait < 1) self.wait = 4; // Setup timer for flesh gib squirting from body
	self.waitmin = time + self.wait + random() * self.wait;
	// Randomly pick one from the first four skins
	// 0=flesh, 1=brown, 2=green1, 3=green2, 4=flesh
	if (!self.exactskin) self.randomskin = 4;
	self.brkvelbase = '200 50 150';
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_checkattack = BoilCheckAttack;
	self.th_pain = boil_pain;
	self.th_die = boil_die; // All boils die the same way
	self.classtype = CT_MONBOIL;
	self.classgroup = CG_SPAWN;
	self.classmove = MON_MOVEWALK;

	// Setup random hobble animation
	if (self.spawnflags & ( MON_BOIL_HOBBLED | MON_BOIL_HANGING)) {
		// A = Crossed legs, B = Straight legs
		if (random() < 0.5) {		
			self.th_stand = self.th_walk = self.th_run = boil_hoba1;
			self.th_melee = boil_HexpA1;
		} else {
			self.th_stand = self.th_walk = self.th_run = boil_hobb1;
			self.th_melee = boil_HexpB1;
		}
		// No movement, turret mode
		self.movespeed = -1;
		// The stationary boil cannot start angry at anything
		self.spawnflags = self.spawnflags - (self.spawnflags & MON_SPAWN_ANGRY);
		self.angrytarget = "";
		// Instantly blow up when triggered
		self.think1 = boil_suicide;
		// Cannot have sight sound, its nailed to wall/floor!
		self.sight_sound = SOUND_EMPTY;
		// Allow for override on exploding trigger radius
		if (self.t_width < 1) self.t_width = MONAI_HOBBLEBOIL;
	}
	
	// Hobbled hanging upside down on wall?
	if (self.spawnflags & MON_BOIL_HANGING) {
		// Make sure angle is within range (0-360)
		if (self.angles_y < 0) self.angles_y = 360;
		// Calculate opposite facing direction
		self.movedir = '0 0 0';
		self.movedir_y = anglemod(self.angles_y + 180);
		// Calculate upward vector and rotate monster
		makevectors(self.angles);
		self.angles = self.movedir + vectoangles(v_up);
		// Pull monster away from wall
		self.origin = self.origin + v_forward*10;
		// Allow monster to float and no ground check
		self.classmove = MON_MOVEFLY;
		self.flags = self.flags | FL_FLY;
		// Setup squirt distance for blood
		self.brkvelbase = '100 50 150';
	} else if (self.spawnflags & MON_BOIL_HOBBLED) { // Hobbled legs with spikes (ground pose)
		// Check for random floor rotation and setup no movment
		if (self.angles_y < 0) self.angles_y = rint(random()*360);
		// Setup squirt distance for blood
		self.brkvelbase = '100 300 100';
	} else { // Default stand, walk & run
		if (self.t_width < 1) self.t_width = MONAI_MELEEBOIL;  // Allow for override on exploding trigger radius
		self.th_stand = boil_stand1;
		self.th_walk = boil_walk1;
		self.th_run = boil_run1;
		self.th_melee = boil_expl1;
	}
	
	// Delay spawn randomized boils a couple of frame to avoid telefrags issues of bad placement of HP packs
	if (self.randomized > 0) {
		self.nextthink = time + 0.1 + (random()*0.2);
		self.think = monster_start;
	} else monster_start();
};