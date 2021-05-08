//----------------------------------------------------------------------
// Pre-defined bounding boxes for monsters
// Use 'bboxtype' to specify one of these
//----------------------------------------------------------------------
float BBOX_TINY = 1;		// -16 -16 -24, 16 16 16
float BBOX_SHORT = 4;		// -16 -16 -24, 16 16 32
float BBOX_TALL = 5;		// -16 -16 -24, 16 16 40
float BBOX_WIDE = 7;		// -24 -24 -24, 24 24 40
float BBOX_GIANT = 8;		// -24 -24 -24, 24 24 64
float BBOX_MASSIVE = 10;	// -32 -32 -24, 32 32 64
float BBOX_GOLEM = 15;		// -24 -24 -24, 24 24 72
float BBOX_DOG = 20;		// -20 -20 -24, 20 20 16
float BBOX_FISH = 25;		// -16 -16 -24, 16 16 24
float BBOX_FISHS = 26;		// -12 -12 -16, 12 12 16
float BBOX_EEL = 27;		// -16 -16 -16, 16 16 16
float BBOX_HYDRA = 30;		// -20 -20 -16, 20 20 16
float BBOX_CUSTOM = 99;		// Custom size set already


void(entity attacker, float damage) monster_pain_check =
{
	self.pain_check = 0;	// Reset pain check
	
	// already dying, don't go into pain frame
	if (self.health < 1) self.pain_check = 0;
	// The new axe forces monsters into long pain animations (if they exist)
	//else if (attacker.moditems & IT_UPGRADE_AXE && self.axhitme && self.pain_longanim) self.pain_check = 2;
	// always go into pain frame if it has been a while (first hit = pain)
	//else if (time - self.pain_finstate > PAIN_ALWAY) self.pain_check = 1;
	// Dangerous liquids should kill the monster and keeping them in
	// constant pain animations which makes them look better than doing nothing!
	else if (self.watertype == CONTENT_SLIME || self.watertype == CONTENT_LAVA) self.pain_check = 1;
	// If being attacked by a world object (shooter, electricity, bmodel) in pain
	else if (attacker == world) self.pain_check = 1;
	// Random chance to flinch and not ignore the pain (play sound only)
	else if (random()* self.pain_flinch > damage ) self.pain_check = 3;
	// DEFAULT  : pain animation + sound (last condition)
	else self.pain_check = 1;
};



void() monster_idle_sound =
{
	// No monsters, dead and timer not reset?
	if ( !(self.flags & FL_MONSTER) ) return;
	if (self.health < 1) return;
	if (self.idletimer > time) return;
	if (self.spawnflags & MON_SPAWN_NOIDLE) return;

	self.idletimer = time + 5 + (random() * 3);
	if (!self.idlemoreoften && random() > MON_IDLE_SOUND) return;
		
	// Is the monster active in combat (special idle sound)
	if (self.enemy && self.idle_soundcom != "") {
		if (self.idle_soundcom2 != "") {
			if (random() < 0.5) sound (self, CHAN_VOICE, self.idle_soundcom, 1, ATTN_NORM);
			else sound (self, CHAN_VOICE, self.idle_soundcom2, 1, ATTN_NORM);
		}
		else sound (self, CHAN_VOICE, self.idle_soundcom, 1, ATTN_NORM);
	}
	else {
		// setup each monster with unique idle sounds (easier and quicker)
		if (self.idle_sound2 != "") {
			if (random() < 0.5) sound (self, CHAN_VOICE, self.idle_sound, 1, ATTN_NORM);
			else sound (self, CHAN_VOICE, self.idle_sound2, 1, ATTN_NORM);
		}
		else sound (self, CHAN_VOICE, self.idle_sound, 1, ATTN_NORM);
	}
};

/*======================================================================
 FoundHuntTarget
 - This is a combination of FoundTarget and HuntTarget
 - Does not do any sight sound, needs to be done outside this func
 - Does not pause or wait for any monster, straight to combat
 - Has no end funtion state, can decide this afterwards
======================================================================*/
void(float wakeupothers) FoundHuntTarget =
{
	if (self.health < 1) return;	// Dead monsters don't hunt!
	if (!self.enemy) return;

	if (self.enemy.flags & FL_CLIENT && wakeupothers == TRUE) {
		sight_entity = self;			// Highlight an angry monster for others
		sight_entity_time = time;		// reset wakeup timer
	}
	
	self.show_hostile = time + 1;		// wake up other monsters
	self.oldorigin = self.origin;		// Save origin
	self.goalentity = self.enemy;		// Focus on enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	SUB_AttackFinished (1);				// wait a while before first attack
};

//----------------------------------------------------------------------
// Detects enemytarget and returns the real ENEMY entity
// Returns the correct entity, useful for function tests
entity() SUB_entEnemyTarget =
{
	if (!self.enemy) return world;
	if (self.enemy.classtype == CT_ENEMYTARGET) return self.enemy.enemy;
	else return self.enemy;
};

//----------------------------------------------------------------------
// Detects enemytarget and returns real ENEMY origin
// Returns the correct entity origin, useful for function tests
vector() SUB_orgEnemyTarget =
{
	if (!self.enemy) return VEC_ORIGIN;
	if (self.enemy.classtype == CT_ENEMYTARGET) return self.enemy.enemy.origin;
	else return self.enemy.origin;
};

float(float attackdist) ai_checkmelee =
{
	local vector	spot1, spot2;
	local float 	delta, zdiff;

	// Calculate distance and z axis difference seperate
	spot1 = SUB_orgEnemyTarget();
	spot2 = self.origin;
	zdiff = fabs(spot1_z - spot2_z);
	spot1_z = spot2_z = 0;				// Flatten Z axis before vector length
	delta = vlen(spot1 - spot2);		// Calculate vector distance

	// Is the enemy too far away and the zaxis is wrong (too low/high)
	if (delta < attackdist && zdiff < MONAI_MELEEZAXIS) return TRUE;
	else return FALSE;
};
