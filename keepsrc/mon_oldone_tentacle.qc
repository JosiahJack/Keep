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
// Function count: 61
//
// Implements:  Oldone Tentacle
//
// Description:
// Shub-Niggurath can be more than what she seems, reaching her tentacles forth
// into all sorts of places.  When a tentacle dies, it retracts into the
// ground.
//=============================================================================

$cd id1/models/oldone
$origin 0 0 24
$base base
$skin skin
$frame idle1 idle2 idle3 idle4 idle5 idle6 
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8 attack9 attack10 attack11 attack12 attack13
$frame attack14 attack15 attack16 attack17 attack18 attack19 attack20 attack21
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12 death13
$frame death14 death15 death16 death17


void() oldone_atta1;

void() oldone_stand1	= [	$idle1, 	oldone_stand2	] { ai_stand(); };
void() oldone_stand2	= [	$idle2, 	oldone_stand3	] { ai_stand(); };
void() oldone_stand3	= [	$idle3, 	oldone_stand4	] { ai_stand(); };
void() oldone_stand4	= [	$idle4, 	oldone_stand5	] { ai_stand(); };
void() oldone_stand5	= [	$idle5, 	oldone_stand6	] { ai_stand(); };
void() oldone_stand6	= [	$idle6, 	oldone_stand1	] { ai_stand(); };

void() oldone_aim1	= [	$idle1, 	oldone_aim2	] { if (random() < 0.4) oldone_atta1(); };
void() oldone_aim2	= [	$idle2, 	oldone_aim3	] {};
void() oldone_aim3	= [	$idle3, 	oldone_aim4	] {};
void() oldone_aim4	= [	$idle4, 	oldone_aim5	] {};
void() oldone_aim5	= [	$idle5, 	oldone_aim6	] {};
void() oldone_aim6	= [	$idle6, 	oldone_aim1	] {};

void() groundSmash = {
	local entity shake;
	
	shake = spawn();
	setorigin(shake, self.origin + '0 0 15');
	shake.think = screenshake;
	shake.attack_finished = time + .3;
	shake.nextthink = time + 0.2;
	sound(self, CHAN_AUTO, "shambler/fall.wav", 1, ATTN_NORM);
	T_RadiusDamage (self, self.owner, 50, self.owner, DAMAGEALL);
	remove(self);
	//if (ext_dppart) pointparticles(particleeffectnum("rocket_explo_classic"), shake.origin, '0 0 0', 1);
};

void(vector org, vector vec) oldone_attack = {
	vec = normalize(vec);
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	setorigin (newmis, org);
	newmis.velocity = vec * 3600;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.velocity_z = 0;
	newmis.nextthink = time + .05;
	newmis.think = groundSmash;
	newmis.touch = groundSmash;
};

void() oldone_atta1	= [	$attack1,	oldone_atta2	] { ai_face(); };
void() oldone_atta2	= [	$attack2,	oldone_atta3	] { ai_face(); };
void() oldone_atta3	= [	$attack3,	oldone_atta4	] { ai_face(); };
void() oldone_atta4	= [	$attack4,	oldone_atta5	] { ai_face(); };
void() oldone_atta5	= [	$attack5,	oldone_atta6	] { ai_face(); };
void() oldone_atta6	= [	$attack6,	oldone_atta7	] { ai_face(); };
void() oldone_atta7	= [	$attack7,	oldone_atta8	] { ai_face(); };
void() oldone_atta8	= [	$attack8,	oldone_atta9	] { ai_face(); };
void() oldone_atta9	= [	$attack9,	oldone_atta10	] { ai_face(); };
void() oldone_atta10	= [	$attack10,	oldone_atta11	] { ai_face(); };
void() oldone_atta11	= [	$attack11,	oldone_atta12	] { ai_face(); };
void() oldone_atta12	= [	$attack12,	oldone_atta13	] { ai_face(); };
void() oldone_atta13	= [	$attack13,	oldone_atta14	] { ai_face(); };
void() oldone_atta14	= [	$attack14,	oldone_atta15	] { ai_face(); };
void() oldone_atta15	= [	$attack15,	oldone_atta16	] { self.solid = SOLID_NOT;};
void() oldone_atta16	= [	$attack16,	oldone_atta17	] { oldone_attack(self.origin, self.enemy.origin - self.origin); };
void() oldone_atta17	= [	$attack17,	oldone_atta18	] {};
void() oldone_atta18	= [	$attack18,	oldone_atta19	] { ai_face(); };
void() oldone_atta19	= [	$attack19,	oldone_atta20	] { ai_face(); };
void() oldone_atta20	= [	$attack20,	oldone_atta21	] { ai_face();self.solid = SOLID_BBOX;};
void() oldone_atta21	= [	$attack21,	oldone_aim1	] { ai_face(); };

void() oldone_die1		= [	$death1,	oldone_die2	] {};
void() oldone_die2		= [	$death2,	oldone_die3	] { monster_check_gib(); };
void() oldone_die3		= [	$death3,	oldone_die4	] { monster_check_gib(); };
void() oldone_die4		= [	$death4,	oldone_die5	] { self.solid = SOLID_NOT;};
void() oldone_die5		= [	$death5,	oldone_die6	] {};
void() oldone_die6		= [	$death6,	oldone_die7	] {};
void() oldone_die7		= [	$death7,	oldone_die8	] {};
void() oldone_die8		= [	$death8,	oldone_die9	] {};
void() oldone_die9		= [	$death9,	oldone_die10	] {};
void() oldone_die10		= [	$death10,	oldone_die11	] {};
void() oldone_die11		= [	$death11,	oldone_die12	] {};
void() oldone_die12		= [	$death12,	oldone_die13	] {};
void() oldone_die13		= [	$death13,	oldone_die14	] {};
void() oldone_die14		= [	$death14,	oldone_die15	] {};
void() oldone_die15		= [	$death15,	oldone_die16	] {};
void() oldone_die16		= [	$death16,	oldone_die17	] { monster_death_postcheck(); };
void() oldone_die17		= [	$death17,	oldone_die17	] { monster_deadbody_check(); };

void(entity inflictor, entity attacker, float damage) oldone_pain = { sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM); };

void() oldone_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// regular death
	if (!self.gibbed) {
		sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
		oldone_die1();
	}
};

// Returns TRUE if a melee attack would hit right now
float()	CheckoldoneMelee = {
	if (enemy_range == RANGE_MELEE) {	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

void() oldone_rise1		= [	$death17,	oldone_rise2	] { self.solid = SOLID_BBOX;};
void() oldone_rise2		= [	$death16,	oldone_rise3	] {};
void() oldone_rise3		= [	$death15,	oldone_rise4	] {};
void() oldone_rise4		= [	$death14,	oldone_rise5	] {};
void() oldone_rise5		= [	$death13,	oldone_rise6	] {};
void() oldone_rise6		= [	$death12,	oldone_aim1	] {	oldone_stand1(); };

void() monster_oldone_tentacle_precache = {
	precache_model ("progs/q15/oldone_tent.mdl");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");
	precache_sound ("shambler/fall.wav");
};

void() monster_oldone_tentacle = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/q15/oldone_tent.mdl";
	self.pain_sound = "boss1/pain.wav";
	self.death_sound = "boss1/death.wav";
	self.health = 135;
	self.scale = 0.5;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	if (self.health < 1) self.health = 135;
	self.max_health = self.health;
	self.takedamage = DAMAGE_AIM;
	self.no_liquiddmg = TRUE;		// no slime/lava damage
	self.gibhealth = -135;
	self.gibbed = FALSE;
	self.pain_flinch = 80;
	self.th_walk = oldone_stand1;
	self.th_run = oldone_aim1;
	self.th_pain = oldone_pain;
	self.th_die = oldone_die;
	self.th_melee = oldone_atta1;
	if (self.deathstring == "")  self.deathstring = " became one with Shub-Niggurath\n";
	self.classtype = CT_MONXXSHUB;
	self.classgroup = CG_BOSS;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_stand = oldone_stand1;
	self.th_missile = SUB_Null;
	monster_start();
	if (!self.targetname) {
		self.th_stand();
	} else {
		self.solid = SOLID_NOT;
		self.frame = $death17;
		self.use = oldone_rise1;
	}	
};