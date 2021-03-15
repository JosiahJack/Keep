// Ogle frames
// ---------------------
// 0-6 ogle_relax_to_standa
// 7-12 ogle_relax_to_standb
// 13-21 ogle_stand
// 22-26 ogle_whippedtowork
// 		27-32 ogle_celebrate
// 		33-42 ogle_celebratejump
// 43-48 ogle_whippainshort
// 49-60 ogle_positionchisel
// 		61-63 ogle_celebrateraisehead (reverse for lowering)
// 		63-68 ogle_celebratewiggle
// 		69-76 ogle_walkcelebratea
// 77-84 ogle_walk
// 		85-92 ogle_walkcelebrateb
// 		93-100 ogle_walkcelebratec
// 		101-108 ogle_walkcelebrated
// 109-117 ogle_hammera tink sound on frame 109
// 118-132 ogle_hammerb tink sound on frames 123 and 132
// 133-144 ogle_wipebrow sound on frame 135?
// 145-148 ogle_paina
// 149-155 ogle_hammerlowa sound on frame 149
// 156-162 ogle_hammerlowb sound on frame 156
// 163-172 ogle_wipebrowlow sound on frame 165
// 173-180 ogle_pushcart
// 181-188 ogle_leaning
// 189-195 ogle_painb (cowering)
// 196 ogle_leaning_pain
// 197-202 ogle_leaning_idle
// 203-210-203 ogle_leaning_wipebrow needs rubber banded from 203 to 203, 210 center sound at 1st 207
// 211-216 ogle_idle_to_lean
// 217-224 ogle_walk
// 225-232 ogle_chargea swoosh sound on frame 230 sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM); 
// 233-240+233 ogle_chargeb swoosh sound on frame 239, pickflesh sound on frame 233 if hittype is flesh
// 241-254 ogle_die

// Various states to check what pain to play, etc.
float OGLE_STANDING = 1;
float OGLE_LEANING = 2;
float OGLE_MINING = 3;
float OGLE_PUSHING = 4;
float OGLE_CELEBRATORY = 5;

// Spawnflag option
float OGLE_FLESHMINING = 4;

void() ogle_mining_sound = {
	local float r;
	r = random();
	if (OGLE_FLESHMINING) {
		if (r < 0.5) {
			sound (self, CHAN_IDLE, "ogle/pickflesh.wav", 1, ATTN_NORM);
			return;
		} else {
			sound (self, CHAN_IDLE, "ogle/hammerflesh.wav", 1, ATTN_NORM);
			return;
		}
	}

	if (r < 0.17) {
		sound (self, CHAN_IDLE, "ogle/hammer1.wav", 1, ATTN_NORM);
	} else if (r < 0.33) {
		sound (self, CHAN_IDLE, "ogle/hammer2.wav", 1, ATTN_NORM);
	} else if (r < 0.5) {
		sound (self, CHAN_IDLE, "ogle/pick1.wav", 1, ATTN_NORM);
	} else if (r < 0.67) {
		sound (self, CHAN_IDLE, "ogle/pick2.wav", 1, ATTN_NORM);
	} else if (r < 0.83) {
		sound (self, CHAN_IDLE, "ogle/spike1.wav", 1, ATTN_NORM);
	} else {
		sound (self, CHAN_IDLE, "ogle/spike2.wav", 1, ATTN_NORM);
	}
};

void() ogle_relax_to_standa1	= [0, ogle_relax_to_standa2	] {};
void() ogle_relax_to_standa2	= [1, ogle_relax_to_standa3	] {};
void() ogle_relax_to_standa3	= [2, ogle_relax_to_standa4	] {};
void() ogle_relax_to_standa4	= [3, ogle_relax_to_standa5	] {};
void() ogle_relax_to_standa5	= [4, ogle_relax_to_standa6	] {self.state = OGLE_STANDING;};
void() ogle_relax_to_standa6	= [5, ogle_relax_to_standa7	] {};
void() ogle_relax_to_standa7	= [6, ogle_stand1			] {};

void() ogle_relax_to_standb1	= [7, ogle_relax_to_standb2	] {};
void() ogle_relax_to_standb2	= [8, ogle_relax_to_standb3	] {};
void() ogle_relax_to_standb3	= [9, ogle_relax_to_standb4	] {};
void() ogle_relax_to_standb4	= [10,ogle_relax_to_standb5] {self.state = OGLE_STANDING;};
void() ogle_relax_to_standb5	= [11,ogle_relax_to_standb6] {};
void() ogle_relax_to_standb6	= [12,ogle_stand1			] {};

void() ogle_stand1	= [13, ogle_stand2	] {self.state = OGLE_STANDING;};
void() ogle_stand2	= [14, ogle_stand3	] {};
void() ogle_stand3	= [15, ogle_stand4	] {};
void() ogle_stand4	= [16, ogle_stand5	] {};
void() ogle_stand5	= [17, ogle_stand6	] {};
void() ogle_stand6	= [18, ogle_stand7	] {};
void() ogle_stand7	= [19, ogle_stand8	] {};
void() ogle_stand8	= [20, ogle_stand9	] {};
void() ogle_stand9	= [21, ogle_stand1	] {};

void() ogle_whippedtowork1	= [22, ogle_whippedtowork2	] {};
void() ogle_whippedtowork2	= [23, ogle_whippedtowork3	] {};
void() ogle_whippedtowork3	= [24, ogle_whippedtowork4	] {};
void() ogle_whippedtowork4	= [25, ogle_whippedtowork5	] {};
void() ogle_whippedtowork5	= [26, ogle_hammera1	] {
	local float r;

	// Back to work you slacker!
	r = random();
	if (r < 0.25) {
		ogle_hammerb1();
	} else if (r < 0.50) {
		ogle_hammerlowa1();
	} else if (r < 0.75) {
		ogle_hammerlowb1();
	} // else just stick with hammera1 from the []s above
};

void() ogle_whippainshort1	= [43, ogle_whippainshort2	] {};
void() ogle_whippainshort2	= [44, ogle_whippainshort3	] {};
void() ogle_whippainshort3	= [45, ogle_whippainshort4	] {};
void() ogle_whippainshort4	= [46, ogle_whippainshort5	] {};
void() ogle_whippainshort5	= [47, ogle_whippainshort6	] {};
void() ogle_whippainshort6	= [48, ogle_positionchisel1	] {
	local float r;

	// Back to work you slacker!
	r = random();
	if (r < 0.25) {
		ogle_hammerb1();
	} else if (r < 0.50) {
		ogle_hammerlowa1();
	} else if (r < 0.75) {
		ogle_hammerlowb1();
	} // else just stick with positionchisel1 from the []s above
};

void() ogle_positionchisel1	= [49, ogle_positionchisel2	] {};
void() ogle_positionchisel2	= [50, ogle_positionchisel3	] {};
void() ogle_positionchisel4	= [51, ogle_positionchisel4	] {};
void() ogle_positionchisel5	= [52, ogle_positionchisel5	] {};
void() ogle_positionchisel6	= [53, ogle_positionchisel6	] {};
void() ogle_positionchisel7	= [54, ogle_positionchisel7	] {};
void() ogle_positionchisel8	= [55, ogle_positionchisel8	] {};
void() ogle_positionchisel9	= [56, ogle_positionchisel9	] {};
void() ogle_positionchisel10= [57, ogle_positionchisel10] {};
void() ogle_positionchisel11= [58, ogle_positionchisel11] {};
void() ogle_positionchisel12= [59, ogle_positionchisel12] {};
void() ogle_positionchisel13= [60, ogle_hammera1	] {};

void() ogle_mine = {
	local float r;
	r = random();
	if (r < 0.17) {
		ogle_hammera1();
	} else if (r < 0.33) {
		ogle_hammerb1();
	} else if (r < 0.5) {
		ogle_hammerlowa1();
	} else if (r < 0.67) {
		ogle_hammerlowb1();
	} else if (r < 0.83) {
		ogle_leaning1();
	} else {
		ogle_stand1();
	}
};

void(entity inflictor, entity attacker, float damage) ogle_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		self.lip = random ();
		if (self.lip < 0.5) sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.pain_sound2, 1, ATTN_NORM);

		if (self.state == OGLE_LEANING) {
			ogle_leaning_pain1();
		} else if (self.state == OGLE_MINING) {
			ogle_whippainshort1();
		} else if (self.state == OGLE_STANDING) {
			ogle_whippedtowork1();
		} else {
			if (random() < 0.5) {
				ogle_paina();
			} else {
				ogle_painb();
			}
		}
	}
};

void() monster_ogle =  {
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	self.mdl = "progs/heretic2/mon_ogle.mdl";
	precache_model (self.mdl);
	precache_sound ("ogle/cheer1.wav");
	precache_sound ("ogle/cheer2.wav");
	precache_sound ("ogle/cheer3.wav");
	precache_sound ("ogle/hammer1.wav");
	precache_sound ("ogle/hammer2.wav");
	precache_sound ("ogle/pick1.wav");
	precache_sound ("ogle/pick2.wav");
	precache_sound ("ogle/pickflesh.wav");
	precache_sound ("ogle/spike1.wav");
	precache_sound ("ogle/spike2.wav");

	self.sight_sound = "ogle/enrage1.wav";
	self.sight_sound2 = "ogle/enrage2.wav";
	precache_sound (self.sight_sound);
	precache_sound (self.sight_sound2);
	self.sight_count = 2;

	self.death_sound = "ogle/death.wav";
	precache_sound (self.death_sound);

	self.pain_sound = "ogle/moan1.wav";
	self.pain_sound2 = "ogle/moan2.wav";

	precache_sound ("knight/sword1.wav");

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_FISH;
	if (self.health < 1) self.health = 200; // Fairly stout, can resist one rocket blast from a careless player
	self.gibhealth = -10; 				// Highly likely to gib
	self.gibbed = FALSE;
	self.pain_flinch = 20;				// Likely always flinch
	self.th_pain = ogle_pain;
	// self.touch = obj_push;
	self.yaw_speed = 2.00000;
	self.th_die = ogle_die;
	self.th_melee = ogle_charge; // Will bite when provoked.  He was provokin' me Atticus!
	self.th_stand = ogle_mine;
	self.th_walk = ogle_walk; // sleep walking?
	self.th_run = ogle_flee;
	if (self.spawnflag & 4) self.lip = TRUE; else self.lip = FALSE;

	if (self.deathstring == "")  self.deathstring = " joined the flock\n";

	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

	self.passive_state = 1;

	self.classtype = CT_MONSHEEP;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEWALK;
	monster_start();
};