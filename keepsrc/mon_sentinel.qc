//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Quake 1.5 by BloodShot
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
// Function count: 43
//
// Implements: Sentinel
//
// Description:
// A tentacly creature with a mechanical device that allows it to float. 
// Serves as an airborne turret.
//=============================================================================

void() sentinel_check_height = { // [FUNCTION]
	//if (self.origin_z > self.enemy.origin_z) {
		// if above the enemy
	//	if ((self.origin_z - self.enemy.origin_z) > 16) ai_down(4);
	//} else {
	//	if ((self.enemy.origin_z - self.origin_z) > 16) ai_up(4);
	//}
};

void() SentinelFire = { // [FUNCTION]
	local vector vec, org;

	sentinel_check_height();
	if (self.attack_finished < time) {
		if (self.enemy == world || !enemy_vis) return;
		if (self.spawnflags & 4) {
			sound(self,CHAN_WEAPON,"quoth/sentinel/nail.wav",1,ATTN_NORM);
		} else {
			sound(self,CHAN_WEAPON,"quoth/sentinel/laser.wav",1,ATTN_NORM);
		}
		self.attack_finished = time + self.wait;
		makevectors(self.angles);
		org = self.origin + attack_vector(self.attack_offset);
		vec = normalize(self.enemy.origin - self.origin);
	
		if (self.spawnflags & 4) {
			launch_projectile(org,vec,NO_SPIN,CT_PROJ_SNG,SPEED_TRAPSPIKE);
		} else {
			launch_projectile(org,vec,NO_SPIN,CT_PROJ_LASER,SPEED_LASER);
		}
	}
};

void() sentinel_writhe1 = [0, sentinel_writhe2 ] { monster_idle_sound(); ai_stand(); };
void() sentinel_writhe2 = [1, sentinel_writhe3 ] { ai_stand(); };
void() sentinel_writhe3 = [2, sentinel_writhe4 ] { ai_stand(); };
void() sentinel_writhe4 = [3, sentinel_writhe5 ] { ai_stand(); };
void() sentinel_writhe5 = [4, sentinel_writhe6 ] { ai_stand(); };
void() sentinel_writhe6 = [5, sentinel_writhe7 ] { ai_stand(); };
void() sentinel_writhe7 = [6, sentinel_writhe8 ] { ai_stand(); };
void() sentinel_writhe8 = [7, sentinel_writhe9 ] { ai_stand(); };
void() sentinel_writhe9 = [8, sentinel_writhe10 ] { ai_stand(); };
void() sentinel_writhe10 = [9, sentinel_writhe1 ] { ai_stand(); };

void() sentinel_run1 = [0, sentinel_run2 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run2 = [1, sentinel_run3 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run3 = [2, sentinel_run4 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run4 = [3, sentinel_run5 ] { SentinelFire();monster_idle_sound(); ai_runwalkfly(8,ai_run); };
void() sentinel_run5 = [4, sentinel_run6 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run6 = [5, sentinel_run7 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run7 = [6, sentinel_run8 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run8 = [7, sentinel_run9 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run9 = [8, sentinel_run10 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };
void() sentinel_run10 = [9, sentinel_run1 ] { SentinelFire(); ai_runwalkfly(8,ai_run); };

void() sentinel_attack1 = [9, sentinel_run1 ] { SentinelFire(); };
//void() sentinel_attack2 = [1, sentinel_attack3 ] { SentinelFire(); };
//void() sentinel_attack3 = [2, sentinel_attack4 ] { SentinelFire(); };
//void() sentinel_attack4 = [3, sentinel_attack5 ] { SentinelFire(); };
//void() sentinel_attack5 = [4, sentinel_attack6 ] { SentinelFire(); };
//void() sentinel_attack6 = [5, sentinel_attack7 ] { SentinelFire(); };
//void() sentinel_attack7 = [6, sentinel_attack8 ] { SentinelFire(); };
//void() sentinel_attack8 = [7, sentinel_attack9 ] { SentinelFire(); };
//void() sentinel_attack9 = [8, sentinel_attack10 ] { SentinelFire(); };
//void() sentinel_attack10 = [9, sentinel_run1 ] { SentinelFire(); };

void() sentinel_pain1 = [10, sentinel_pain2] {};
void() sentinel_pain2 = [10, sentinel_pain3] {};
void() sentinel_pain3 = [10, sentinel_pain4] {};
void() sentinel_pain4 = [10, sentinel_pain5] {};
void() sentinel_pain5 = [10, sentinel_pain6] {};
void() sentinel_pain6 = [15, sentinel_writhe1] {};

void(entity inflictor, entity attacker, float damage) sentinel_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		sentinel_pain1();
		self.pain_finished = time + 2;
	}
};

void(entity own, float fr, float idle, float t) sentinel_death_fx = {
	local entity puff;
	local vector vrand;

	puff = spawn();
	puff.owner = own;
	puff.solid = SOLID_NOT;
	puff.touch = SUB_Null;
	puff.movetype = MOVETYPE_NONE;
	puff.velocity = '0 0 0';
	puff.frame = fr;
	puff.idleweaponframe = idle;
	vrand_x = (crandom()*16);
	vrand_y = (crandom()*16);
	vrand_z = (crandom()*16);
	puff.origin = own.origin + vrand;
	puff.mdl = "progs/quoth/s_vp_pll.spr";
	setmodel(puff,"progs/quoth/s_vp_pll.spr");
	puff.think = BDW_SpriteGenericPlayOnce;
	puff.nextthink = time + t;
};

void() sentinel_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	sound(self,CHAN_VOICE, "ad171/seeker/explode_major.wav",1,ATTN_NORM);
	self.solid = SOLID_NOT;
	SpawnProjectileSmoke(self.origin, 150, 50, 150);
	SpawnProjectileSmoke(self.origin, 150, 50, 150);
	sentinel_death_fx(self,21,34,0.05);
	sentinel_death_fx(self,35,51,0.15);
	ThrowGib(11,1);
	ThrowGib(12,2);
	entity_remove(self,0.1);
};

void() monster_sentinel_precache = {
	precache_model("progs/quoth/sentinel.mdl");
	precache_model("progs/ad171/proj_laz.mdl");
	precache_model("progs/quoth/gib.mdl");
	precache_model("progs/quoth/wreckage.mdl");
	precache_model("progs/quoth/s_vp_pll.spr");
	precache_sound("ad171/seeker/explode_major.wav");
	precache_sound(SOUND_LASER_FIRE);
	precache_sound(SOUND_LASER_HIT);
	precache_sound("quoth/sentinel/laser.wav");
	precache_sound("quoth/sentinel/nail.wav");
	precache_sound("quoth/sentinel/widle1.wav");
	precache_sound("quoth/sentinel/wpain.wav");
	precache_sound("quoth/sentinel/wsight.wav");
};

void() monster_sentinel = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
		
	self.mdl = "progs/quoth/sentinel.mdl";
	self.gib1mdl = "progs/quoth/gib.mdl";
	self.gib2mdl = "progs/quoth/wreckage.mdl";
	self.sight_sound = "quoth/sentinel/wsight.wav";
	self.idle_sound = "quoth/sentinel/widle1.wav";
	self.pain_sound = "quoth/sentinel/wpain.wav";
	self.pain_flinch = 75;
	self.gibhealth = MON_NEVERGIB;
	self.attack_offset = '0 0 16';
	if (self.wait <= 0) self.wait = 0.2;
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
	if (self.health < 1) self.health = 150;
	if (self.spawnflags & 4) self.skin = 1;
	if (self.deathstring == "") self.deathstring = " was scorched by a Sentinel\n";
	self.th_run = sentinel_run1;
	self.th_walk = sentinel_writhe1;
	self.th_checkattack = WizardCheckAttack;
	self.th_stand = sentinel_writhe1;
	self.th_missile = sentinel_attack1;
	self.th_pain = sentinel_pain;
	self.th_die = sentinel_die;
	self.height = -16;
    self.hittype    = HIT_METAL;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.gibtype = GIBTYPE_METAL;
	self.classtype = CT_MONSENTINEL;
	self.classgroup = CG_ROBOT;			// One big happy robot family!
	self.classmove = MON_MOVEFLY;
	monster_start();
};