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

void() ogle_hammerb1;
void() ogle_hammerlowa1;
void() ogle_hammerlowb1;
void() ogle_leaning1;
void() ogle_leaning_pain1;
void() ogle_paina1;
void() ogle_painb1;
void() ogle_mine;

void() ogle_mining_sound = {
	local float r;
	r = random();
	if (self.spawnflags & OGLE_FLESHMINING) {
		if (r < 0.5) {
			sound (self, CHAN_VOICE, "ogle/pickflesh.wav", 1, ATTN_NORM);
			return;
		} else {
			sound (self, CHAN_VOICE, "ogle/hammerflesh.wav", 1, ATTN_NORM);
			return;
		}
	}

	if (r < 0.17) {
		sound (self, CHAN_VOICE, "ogle/hammer1.wav", 1, ATTN_NORM);
	} else if (r < 0.33) {
		sound (self, CHAN_VOICE, "ogle/hammer2.wav", 1, ATTN_NORM);
	} else if (r < 0.5) {
		sound (self, CHAN_VOICE, "ogle/pick1.wav", 1, ATTN_NORM);
	} else if (r < 0.67) {
		sound (self, CHAN_VOICE, "ogle/pick2.wav", 1, ATTN_NORM);
	} else if (r < 0.83) {
		sound (self, CHAN_VOICE, "ogle/spike1.wav", 1, ATTN_NORM);
	} else {
		sound (self, CHAN_VOICE, "ogle/spike2.wav", 1, ATTN_NORM);
	}
};

void() ogle_cheer_sound = {
	local float r;
	r = random();

	if (r < 0.33) {
		sound (self, CHAN_VOICE, "ogle/cheer1.wav", 1, ATTN_NORM);
	} else if (r < 0.66) {
		sound (self, CHAN_VOICE, "ogle/cheer2.wav", 1, ATTN_NORM);
	} else {
		sound (self, CHAN_VOICE, "ogle/cheer3.wav", 1, ATTN_NORM);
	}
};

// Lots of frames for this lil guy, starting at 0...
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

void() ogle_stand_to_work1;

void() ogle_stand1	= [13, ogle_stand2	] {self.state = OGLE_STANDING;ai_stand();};
void() ogle_stand2	= [14, ogle_stand3	] {ai_stand();};
void() ogle_stand3	= [15, ogle_stand4	] {ai_stand();};
void() ogle_stand4	= [16, ogle_stand5	] {ai_stand();};
void() ogle_stand5	= [17, ogle_stand6	] {ai_stand();};
void() ogle_stand6	= [18, ogle_stand7	] {ai_stand();};
void() ogle_stand7	= [19, ogle_stand8	] {ai_stand();};
void() ogle_stand8	= [20, ogle_stand9	] {ai_stand();};
void() ogle_stand9	= [21, ogle_stand1	] {ai_stand(); if (random() < 0.05) ogle_stand_to_work1();};

void() ogle_hammera1;

void() ogle_stand_to_work1	= [12, ogle_stand_to_work2	] {};
void() ogle_stand_to_work2	= [11, ogle_stand_to_work3	] {};
void() ogle_stand_to_work3	= [10, ogle_stand_to_work4	] {};
void() ogle_stand_to_work4	= [9,ogle_stand_to_work5] {self.state = OGLE_STANDING;};
void() ogle_stand_to_work5	= [8,ogle_stand_to_work6] {};
void() ogle_stand_to_work6	= [7,ogle_hammerlowa1			] {if (random() < 0.05) ogle_hammera1();};

void() ogle_whippedtowork1	= [22, ogle_whippedtowork2	] {self.state = OGLE_MINING;};
void() ogle_whippedtowork2	= [23, ogle_whippedtowork3	] {};
void() ogle_whippedtowork3	= [24, ogle_whippedtowork4	] {};
void() ogle_whippedtowork4	= [25, ogle_whippedtowork5	] {};
void() ogle_whippedtowork5	= [26, ogle_hammera1	] {if (random() < 0.25) ogle_mine();};

//ogle_celebrate frames 27-32
// not used atm -Qmaster

//ogle_celebratejump frames 33-42
// not used atm -Qmaster

// ... moving on to frame 43 then

void() ogle_whippainshort1	= [43, ogle_whippainshort2	] {self.state = OGLE_MINING;};
void() ogle_whippainshort2	= [44, ogle_whippainshort3	] {};
void() ogle_whippainshort3	= [45, ogle_whippainshort4	] {};
void() ogle_whippainshort4	= [46, ogle_whippainshort5	] {};
void() ogle_whippainshort5	= [47, ogle_whippainshort6	] {};
void() ogle_whippainshort6	= [48, ogle_positionchisel1	] {if (random() < 0.25) ogle_mine();};

void() ogle_positionchisel1	= [49, ogle_positionchisel2	] {ai_stand();self.state = OGLE_MINING;};
void() ogle_positionchisel2	= [50, ogle_positionchisel3	] {ai_stand();};
void() ogle_positionchisel3	= [51, ogle_positionchisel4	] {ai_stand();};
void() ogle_positionchisel4	= [52, ogle_positionchisel5	] {ai_stand();};
void() ogle_positionchisel5	= [53, ogle_positionchisel6	] {ai_stand();};
void() ogle_positionchisel6	= [54, ogle_positionchisel7	] {ai_stand();};
void() ogle_positionchisel7	= [55, ogle_positionchisel8	] {ai_stand();};
void() ogle_positionchisel8	= [56, ogle_positionchisel9	] {ai_stand();};
void() ogle_positionchisel9 = [57, ogle_positionchisel10] {ai_stand();};
void() ogle_positionchisel10 = [58, ogle_positionchisel11] {ai_stand();};
void() ogle_positionchisel11 = [59, ogle_positionchisel12] {ai_stand();};
void() ogle_positionchisel12 = [60, ogle_hammera4	] {ai_stand();}; // transition into a whack


//ogle_celebrateraisehead frames 61-63
// not used atm -Qmaster

//ogle_celebratewiggle frames 63-68
// not used atm -Qmaster

//ogle_walkcelebratea frames 69-76
// not used atm -Qmaster

// ... moving on to frame 77 then

void() ogle_run1 = [77, ogle_run2	] {ai_run(8); self.state = FALSE;};
void() ogle_run2 = [78, ogle_run3	] {ai_run(10);};
void() ogle_run3 = [79, ogle_run4	] {ai_run(14);};
void() ogle_run4 = [80, ogle_run5	] {ai_run(12);};
void() ogle_run5 = [81, ogle_run6	] {ai_run(10);};
void() ogle_run6 = [82, ogle_run7	] {ai_run(14);};
void() ogle_run7 = [83, ogle_run8	] {ai_run(12);};
void() ogle_run8 = [84, ogle_run1	] {ai_run(8);};

//ogle_walkcelebrateb frames 85-92
// not used atm -Qmaster

//ogle_walkcelebratec frames 93-100
// not used atm -Qmaster

//ogle_walkcelebratec frames 101-108
// not used atm -Qmaster

// Garsh these guys like to celebrate when monster_overlord's are killed, gloat much?

// ... moving on to frame 109 then

void() ogle_idle_to_lean1;

void() ogle_hammera1 = [109, ogle_hammera2	] {ai_stand();self.state = OGLE_MINING;ogle_mining_sound();};
void() ogle_hammera2 = [110, ogle_hammera3	] {ai_stand();if (random() < 0.05) ogle_idle_to_lean1();};
void() ogle_hammera3 = [111, ogle_hammera4	] {ai_stand();};
void() ogle_hammera4 = [112, ogle_hammera5	] {if (random() < 0.1) ogle_positionchisel1();};
void() ogle_hammera5 = [113, ogle_hammera6	] {ai_stand();};
void() ogle_hammera6 = [114, ogle_hammera7	] {ai_stand();};
void() ogle_hammera7 = [115, ogle_hammera8	] {ai_stand();};
void() ogle_hammera8 = [116, ogle_hammera9	] {ai_stand();};
void() ogle_hammera9 = [117, ogle_hammera1	] {ai_stand();};

void() ogle_wipebrow1;

void() ogle_hammerb1 = [118, ogle_hammerb2	] {ai_stand();self.state = OGLE_MINING;};
void() ogle_hammerb2 = [119, ogle_hammerb3	] {ai_stand();};
void() ogle_hammerb3 = [120, ogle_hammerb4	] {ai_stand();};
void() ogle_hammerb4 = [121, ogle_hammerb5	] {ai_stand();};
void() ogle_hammerb5 = [122, ogle_hammerb6	] {ai_stand();};
void() ogle_hammerb6 = [123, ogle_hammerb7	] {ai_stand();ogle_mining_sound();};
void() ogle_hammerb7 = [124, ogle_hammerb8	] {ai_stand();};
void() ogle_hammerb8 = [125, ogle_hammerb9	] {ai_stand();};
void() ogle_hammerb9 = [126, ogle_hammerb10	] {ai_stand();};
void() ogle_hammerb10= [127, ogle_hammerb11	] {ai_stand();};
void() ogle_hammerb11= [128, ogle_hammerb12	] {ai_stand();};
void() ogle_hammerb12= [129, ogle_hammerb13	] {ai_stand();};
void() ogle_hammerb13= [130, ogle_hammerb14	] {ai_stand();};
void() ogle_hammerb14= [131, ogle_hammerb15	] {ai_stand();};
void() ogle_hammerb15= [132, ogle_wipebrow1	] {ai_stand();ogle_mining_sound(); if (random() < 0.8) ogle_hammerb1();};

void() ogle_wipebrow1 = [133, ogle_wipebrow2	] {ai_stand();};
void() ogle_wipebrow2 = [134, ogle_wipebrow3	] {ai_stand();self.state = OGLE_STANDING;};
void() ogle_wipebrow3 = [135, ogle_wipebrow4	] {ai_stand();sound (self, CHAN_VOICE, "ogle/wipebrow.wav", 1, ATTN_NORM);};
void() ogle_wipebrow4 = [136, ogle_wipebrow5	] {ai_stand();};
void() ogle_wipebrow5 = [137, ogle_wipebrow6	] {ai_stand();};
void() ogle_wipebrow6 = [138, ogle_wipebrow7	] {ai_stand();};
void() ogle_wipebrow7 = [139, ogle_wipebrow8	] {ai_stand();};
void() ogle_wipebrow8 = [140, ogle_wipebrow9	] {ai_stand();};
void() ogle_wipebrow9 = [141, ogle_wipebrow10	] {ai_stand();};
void() ogle_wipebrow10 = [142, ogle_wipebrow11	] {ai_stand();};
void() ogle_wipebrow11 = [143, ogle_wipebrow12	] {ai_stand();};
void() ogle_wipebrow12 = [144, 	ogle_hammerb3] {ai_stand();};

void() ogle_paina1 = [145, 	ogle_paina2] {};
void() ogle_paina2 = [146, 	ogle_paina3] {};
void() ogle_paina3 = [147, 	ogle_paina4] {};
void() ogle_paina4 = [148, 	ogle_run1] {
	if (self.state == OGLE_PUSHING){
		if (random() < 0.8 && (self.health > (self.max_health/2))) ogle_pushcart1(); // Good chance they'll keep pushing the cart if they are healthy
	}
};

void() ogle_hammerlowb1;
void() ogle_wipebrowlow1;

void() ogle_hammerlowa1 = [149, ogle_hammerlowa2	] {ai_stand();self.state = OGLE_MINING;ogle_mining_sound();};
void() ogle_hammerlowa2 = [150, ogle_hammerlowa3	] {ai_stand();};
void() ogle_hammerlowa3 = [151, ogle_hammerlowa4	] {ai_stand();if (random() < 0.05) ogle_wipebrowlow1();};
void() ogle_hammerlowa4 = [152, ogle_hammerlowa5	] {ai_stand();};
void() ogle_hammerlowa5 = [153, ogle_hammerlowa6	] {ai_stand();};
void() ogle_hammerlowa6 = [154, ogle_hammerlowa7	] {ai_stand();};
void() ogle_hammerlowa7 = [155, ogle_hammerlowb1	] {ai_stand();if (random() < 0.2) ogle_mine();};

void() ogle_hammerlowb1 = [156, ogle_hammerlowb2	] {ai_stand();self.state = OGLE_MINING;ogle_mining_sound();};
void() ogle_hammerlowb2 = [157, ogle_hammerlowb3	] {ai_stand();if (random() < 0.05) ogle_wipebrowlow1();};
void() ogle_hammerlowb3 = [158, ogle_hammerlowb4	] {ai_stand();};
void() ogle_hammerlowb4 = [159, ogle_hammerlowb5	] {ai_stand();};
void() ogle_hammerlowb5 = [160, ogle_hammerlowb6	] {ai_stand();};
void() ogle_hammerlowb6 = [161, ogle_hammerlowb7	] {ai_stand();};
void() ogle_hammerlowb7 = [162, ogle_hammerlowa1	] {ai_stand();if (random() < 0.2) ogle_mine();};

void() ogle_wipebrowlow1 = [163, ogle_wipebrowlow2	] {ai_stand();self.state = OGLE_STANDING;};
void() ogle_wipebrowlow2 = [164, ogle_wipebrowlow3	] {ai_stand();};
void() ogle_wipebrowlow3 = [165, ogle_wipebrowlow4	] {ai_stand();ogle_mining_sound();};
void() ogle_wipebrowlow4 = [166, ogle_wipebrowlow5	] {ai_stand();};
void() ogle_wipebrowlow5 = [167, ogle_wipebrowlow6	] {ai_stand();};
void() ogle_wipebrowlow6 = [168, ogle_wipebrowlow7	] {ai_stand();};
void() ogle_wipebrowlow7 = [169, ogle_wipebrowlow8	] {ai_stand();};
void() ogle_wipebrowlow8 = [170, ogle_wipebrowlow9	] {ai_stand();};
void() ogle_wipebrowlow9 = [171, ogle_wipebrowlow10	] {ai_stand();self.state = OGLE_MINING;};
void() ogle_wipebrowlow10= [172, ogle_hammerlowa1	] {ai_stand();if (random() < 0.2) ogle_mine(); };

void() ogle_walk1;

void() ogle_pushcart1 = [173, ogle_pushcart2	] {ai_walk(4); monster_footstep(FALSE);self.state = OGLE_PUSHING;if (!self.attachment) ogle_walk1();};
void() ogle_pushcart2 = [174, ogle_pushcart3	] {ai_walk(4);if (!self.attachment) ogle_walk1();};
void() ogle_pushcart3 = [175, ogle_pushcart4	] {ai_walk(4);if (!self.attachment) ogle_walk1();};
void() ogle_pushcart4 = [176, ogle_pushcart5	] {ai_walk(4);if (!self.attachment) ogle_walk1();};
void() ogle_pushcart5 = [177, ogle_pushcart6	] {ai_walk(4);if (!self.attachment) ogle_walk1();};
void() ogle_pushcart6 = [178, ogle_pushcart7	] {ai_walk(4);monster_footstep(FALSE); if (!self.attachment) ogle_walk1();};
void() ogle_pushcart7 = [179, ogle_pushcart8	] {ai_walk(4);if (!self.attachment) ogle_walk1();};
void() ogle_pushcart8 = [180, ogle_pushcart1	] {ai_walk(4);if (!self.attachment) ogle_walk1();};

void() ogle_leaning1 = [181, ogle_leaning2] {ai_stand();self.state = OGLE_LEANING;};
void() ogle_leaning2 = [182, ogle_leaning3] {ai_stand();};
void() ogle_leaning3 = [183, ogle_leaning4] {ai_stand();};
void() ogle_leaning4 = [184, ogle_leaning5] {ai_stand();};
void() ogle_leaning5 = [185, ogle_leaning6] {ai_stand();};
void() ogle_leaning6 = [186, ogle_leaning7] {ai_stand();};
void() ogle_leaning7 = [187, ogle_leaning8] {ai_stand();};
void() ogle_leaning8 = [188, ogle_leaning1] {ai_stand();};

void() ogle_painb1 = [189, ogle_painb2] {};
void() ogle_painb2 = [190, ogle_painb3] {};
void() ogle_painb3 = [191, ogle_painb4] {};
void() ogle_painb4 = [192, ogle_painb5] {};
void() ogle_painb5 = [193, ogle_painb6] {};
void() ogle_painb6 = [194, ogle_painb7] {};
void() ogle_painb7 = [195, ogle_run1] {};

void() ogle_leaning_pain1 = [196, ogle_run1] {};

void() ogle_leaning_wipebrow1;

void() ogle_leaning_idle1 = [197, ogle_leaning_idle2] {};
void() ogle_leaning_idle2 = [198, ogle_leaning_idle3] {};
void() ogle_leaning_idle3 = [199, ogle_leaning_idle4] {};
void() ogle_leaning_idle4 = [200, ogle_leaning_idle5] {};
void() ogle_leaning_idle5 = [201, ogle_leaning_idle6] {};
void() ogle_leaning_idle6 = [202, ogle_leaning_idle1] {
	local float rand;

	rand = random();
	if (rand > 0.8) ogle_leaning_wipebrow1();

	if (rand < 0.1) ogle_relax_to_standa1();
	else if (rand < 0.05) ogle_relax_to_standb1();
};

void() ogle_leaning_wipebrow1 = [203, ogle_leaning_wipebrow2] {};
void() ogle_leaning_wipebrow2 = [204, ogle_leaning_wipebrow3] {};
void() ogle_leaning_wipebrow3 = [205, ogle_leaning_wipebrow4] {};
void() ogle_leaning_wipebrow4 = [206, ogle_leaning_wipebrow5] {};
void() ogle_leaning_wipebrow5 = [207, ogle_leaning_wipebrow6] {sound (self, CHAN_VOICE, "ogle/wipebrow.wav", 1, ATTN_NORM);};
void() ogle_leaning_wipebrow6 = [208, ogle_leaning_wipebrow7] {};
void() ogle_leaning_wipebrow7 = [209, ogle_leaning_wipebrow8] {};
void() ogle_leaning_wipebrow8 = [210, ogle_leaning_wipebrow9] {};
void() ogle_leaning_wipebrow9 = [209, ogle_leaning_wipebrow10] {};
void() ogle_leaning_wipebrow10 = [208, ogle_leaning_wipebrow11] {};
void() ogle_leaning_wipebrow11 = [207, ogle_leaning_wipebrow12] {};
void() ogle_leaning_wipebrow12 = [206, ogle_leaning_wipebrow13] {};
void() ogle_leaning_wipebrow13 = [205, ogle_leaning_wipebrow14] {};
void() ogle_leaning_wipebrow14 = [204, ogle_leaning_wipebrow15] {};
void() ogle_leaning_wipebrow15 = [203, ogle_leaning_idle1] {};

void() ogle_idle_to_lean1 = [211, ogle_idle_to_lean2] {};
void() ogle_idle_to_lean2 = [212, ogle_idle_to_lean3] {};
void() ogle_idle_to_lean3 = [213, ogle_idle_to_lean4] {};
void() ogle_idle_to_lean4 = [214, ogle_idle_to_lean5] {};
void() ogle_idle_to_lean5 = [215, ogle_idle_to_lean6] {};
void() ogle_idle_to_lean6 = [216, ogle_leaning_idle1] {};

void() ogle_mine = {
	local float r;
	local vector spot1, spot2;

	r = random();
	if (self.attachment) {
		ogle_pushcart1();
		return;
	}

	makevectors(self.angles);
	spot1 = self.origin;
	spot2 = spot1 + (v_forward * 48); // Trace directly infront of entity using angles
	traceline(spot1, spot2, TRUE, self);
	if (trace_fraction != 1) {
		if (r < 0.25) {
			ogle_hammera1();
		} else if (r < 0.5) {
			ogle_hammerb1();
		} else if (r < 0.75) {
			ogle_hammerlowa1();
		} else {
			ogle_hammerlowb1();
		}
	} else {
		if (r < 0.5) {
			ogle_leaning1();
		} else {
			ogle_stand1();
		}
	}
};

void(entity inflictor, entity attacker, float damage) ogle_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		if (random () < 0.5) sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, self.pain_sound2, 1, ATTN_NORM);

		if (self.state == OGLE_LEANING) {
			ogle_leaning_pain1();
		} else if (self.state == OGLE_MINING) {
			ogle_whippainshort1();
		} else if (self.state == OGLE_STANDING) {
			ogle_whippedtowork1();
		} else {
			if (self.state == OGLE_PUSHING) {
				self.state = FALSE;
				take_monster_object(self); // drop our stuff
			}
			if (random() < 0.5) {
				ogle_paina1();
			} else {
				ogle_painb1();
			}
		}
	}
};

void() ogle_walk1 = [217, ogle_walk2	] {ai_walk(4); monster_footstep(FALSE); self.state = FALSE; if (self.attachment) ogle_pushcart1();};
void() ogle_walk2 = [218, ogle_walk3	] {ai_walk(2); if (self.attachment) ogle_pushcart1();};
void() ogle_walk3 = [219, ogle_walk4	] {ai_walk(2); if (self.attachment) ogle_pushcart1();};
void() ogle_walk4 = [220, ogle_walk5	] {ai_walk(2); if (self.attachment) ogle_pushcart1();};
void() ogle_walk5 = [221, ogle_walk6	] {ai_walk(2); monster_footstep(FALSE); if (self.attachment) ogle_pushcart1();};
void() ogle_walk6 = [222, ogle_walk7	] {ai_walk(4); if (self.attachment) ogle_pushcart1();};
void() ogle_walk7 = [223, ogle_walk8	] {ai_walk(2); if (self.attachment) ogle_pushcart1();};
void() ogle_walk8 = [224, ogle_walk1	] {ai_walk(2); if (self.attachment) ogle_pushcart1();};

void() ogle_chargea1 = [224, ogle_chargea2	] {ai_charge(12);};
void() ogle_chargea2 = [225, ogle_chargea3	] {ai_charge(10);};
void() ogle_chargea3 = [226, ogle_chargea4	] {ai_charge(10);};
void() ogle_chargea4 = [227, ogle_chargea5	] {ai_charge(10);};
void() ogle_chargea5 = [228, ogle_chargea6	] {ai_charge(10);};
void() ogle_chargea6 = [229, ogle_chargea7	] {ai_charge(12);};
void() ogle_chargea7 = [230, ogle_chargea8	] {ai_charge(12);sound (self, CHAN_VOICE, "knight/sword1.wav", 1, ATTN_NORM);};
void() ogle_chargea8 = [231, ogle_chargea9	] {ai_charge(18);ai_melee();};
void() ogle_chargea9 = [232, ogle_run1	] {ai_charge(14);ai_melee(); if (self.enemy.health < 1) ogle_cheer_sound();};

void() ogle_chargeb1 = [233, ogle_chargeb2	] {ai_charge(12);};
void() ogle_chargeb2 = [234, ogle_chargeb3	] {ai_charge(10);};
void() ogle_chargeb3 = [235, ogle_chargeb4	] {ai_charge(10);};
void() ogle_chargeb4 = [236, ogle_chargeb5	] {ai_charge(10);};
void() ogle_chargeb5 = [237, ogle_chargeb6	] {ai_charge(10);};
void() ogle_chargeb6 = [238, ogle_chargeb7	] {ai_charge(12);};
void() ogle_chargeb7 = [239, ogle_chargeb8	] {ai_charge(12);sound (self, CHAN_VOICE, "knight/sword1.wav", 1, ATTN_NORM);};
void() ogle_chargeb8 = [240, ogle_chargeb9	] {ai_charge(18);ai_melee();};
void() ogle_chargeb9 = [233, ogle_run1	] {ai_charge(14);ai_melee(); if (self.enemy.health < 1) ogle_cheer_sound();};

void() ogle_charge = {
	if (random() < 0.5) ogle_chargea1();
	else ogle_chargeb1();
};

void() ogle_death1 = [241, ogle_death2	] {};
void() ogle_death2 = [242, ogle_death3	] {monster_check_gib();};
void() ogle_death3 = [243, ogle_death4	] {monster_check_gib();self.solid = SOLID_NOT;};
void() ogle_death4 = [244, ogle_death5	] {};
void() ogle_death5 = [245, ogle_death6	] {};
void() ogle_death6 = [246, ogle_death7	] {};
void() ogle_death7 = [247, ogle_death8	] {};
void() ogle_death8 = [248, ogle_death9	] {};
void() ogle_death9 = [249, ogle_death10	] {};
void() ogle_death10 = [250, ogle_death11	] {};
void() ogle_death11 = [251, ogle_death12	] {};
void() ogle_death12 = [252, ogle_death13	] {};
void() ogle_death13 = [253, ogle_death14	] {monster_death_postcheck();};
void() ogle_death14 = [254, ogle_death14	] {monster_deadbody_check();};

void() ogle_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	if (!self.gibbed) { 
		sound (self, CHAN_VOICE, self.death_sound, 1, ATTN_NORM);
		ogle_death1 ();
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

	precache_sound ("ogle/wipebrow.wav");

	self.sight_sound = "ogle/enrage1.wav";
	self.sight_sound2 = "ogle/enrage2.wav";
	precache_sound (self.sight_sound);
	precache_sound (self.sight_sound2);

	self.death_sound = "ogle/death.wav";
	precache_sound (self.death_sound);

	self.pain_sound = "ogle/oglemoan1.wav";
	self.pain_sound2 = "ogle/oglemoan2.wav";
	precache_sound (self.pain_sound);
	precache_sound (self.pain_sound2);

	self.meleehitsound = "ogle/pickflesh.wav";

	precache_sound ("knight/sword1.wav");

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_FISH;
	if (self.health < 1) self.health = 200; // Fairly stout, can resist one rocket blast from a careless player
	self.gibhealth = -40;
	self.gibbed = FALSE;
	self.pain_flinch = 5;				// Likely always flinch
	self.th_pain = ogle_pain;
	self.yaw_speed = 20.00000;
	self.th_die = ogle_die;
	self.th_melee = ogle_charge; // Will bite when provoked.  He was provokin' me Atticus!
	self.th_stand = ogle_mine;
	self.th_walk = ogle_walk1; // sleepnir walking?
	self.th_run = ogle_run1;
	self.steptype = FS_TYPELIGHT;
	if (self.deathstring == "")  self.deathstring = " was mined by an Ogle\n";

	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

	// Standard DENIZEN AI
	if (!self.alignment) self.alignment = NEUTRAL;
	if (!self.passive_state) self.passive_state = 1;
	if (!self.temperament) self.temperament = TEMPRA_PASSIVE;
	if (!self.vulnerability) self.vulnerability = VULN_RESISTANT;

	self.classtype = CT_MONOGLE;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEWALK;
	monster_start();
};