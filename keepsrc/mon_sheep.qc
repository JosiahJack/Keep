void sheep_tran_a1();
void sheep_tran_b1();
void sheep_graze_a1();
void sheep_graze_b1();
void sheep_gstep_a1 ();
void sheep_gstep_b1 ();
void sheep_wait1 ();
void (entity inflictor, entity attacker, float damage) sheep_pain;
void sheep_lookdown1();
void sheep_look1();
void sheep_lookup1();
void sheep_trot1();

void() sheep_sound =  {
	local float r, vol;

	if (self.idletimer > time) return;

	r = random();
	if (random() < 0.5) vol = (random() * 0.8) + 0.2;
	else vol = 1;

	if (r < 0.333) {
		sound (self, CHAN_VOICE, "sheep/sheep1.wav", vol, ATTN_NORM);
	} else {
		if (r < 0.666) sound (self, CHAN_VOICE, "sheep/sheep2.wav", vol, ATTN_NORM);
		else sound (self, CHAN_VOICE, "sheep/sheep3.wav", vol, ATTN_NORM);
	}
	self.idletimer = time + 5 + (random() * 3);
};

void() sheep_turn =  {
   if (random() < 0.5)	self.angles_y += ((random() * self.yaw_speed) + (self.yaw_speed / 2.00000));
   else					self.angles_y -= ((random() * self.yaw_speed) + (self.yaw_speed / 2.00000));
};

void  (float dist) ai_sheep_move =  {
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	ChangeYaw();
	movetogoal(dist);
};

void  ()sheep_think =  {
   if (!(self.spawnflags & 1) && ((self.think == sheep_trot1 || self.think == sheep_gstep_a1 || self.think == sheep_gstep_b1) && random() < 0.10000)) sheep_turn();
   if ((((random() < 0.10000) && (random() < 0.20000)) && (self.pain_finished < time))) {
      sheep_sound();
   }
};

void() sheep_tran_think = {
	if (self.goalentity) {
		ai_sheep_move (3);
	} else {
		if (!walkmove(self.angles_y, 3)) sheep_turn();
	}
	sheep_think();
};

// Calm back down from running (trotting)
void()	sheep_tran_a1	=[202,	sheep_tran_a2	] {sheep_tran_think();};
void()	sheep_tran_a2	=[203,	sheep_tran_a3	] {sheep_tran_think();};
void()	sheep_tran_a3	=[204,	sheep_tran_a4	] {sheep_tran_think();};
void()	sheep_tran_a4	=[205,	sheep_tran_a5	] {sheep_tran_think();};
void()	sheep_tran_a5	=[206,	sheep_tran_a6	] {sheep_tran_think();};
void()	sheep_tran_a6	=[207,	sheep_tran_a7	] {sheep_tran_think();};
void()	sheep_tran_a7	=[208,	sheep_tran_a8	] {sheep_tran_think();};
void()	sheep_tran_a8	=[209,	sheep_tran_a9	] {sheep_tran_think();};
void()	sheep_tran_a9	=[210,	sheep_tran_a10	] {sheep_tran_think();};
void()	sheep_tran_a10	=[211,	sheep_wait1		] {
	local float r;

	sheep_tran_think();
	r = random();
	if (r < 0.333) {
		sheep_wait1();
	} else {
		if (r < 0.666) {
			sheep_tran_b1();
		} else {
			sheep_lookdown1();
		}
	}
};

// YIKES! Get disturbed and start running (trotting)
void()	sheep_tran_b1	=[212,	sheep_tran_b2	] {sheep_tran_think();};
void()	sheep_tran_b2	=[213,	sheep_tran_b3	] {sheep_tran_think();};
void()	sheep_tran_b3	=[214,	sheep_tran_b4	] {sheep_tran_think();};
void()	sheep_tran_b4	=[215,	sheep_tran_b5	] {sheep_tran_think();};
void()	sheep_tran_b5	=[216,	sheep_tran_b6	] {sheep_tran_think();};
void()	sheep_tran_b6	=[217,	sheep_tran_b7	] {sheep_tran_think();};
void()	sheep_tran_b7	=[218,	sheep_tran_b8	] {sheep_tran_think();};
void()	sheep_tran_b8	=[219,	sheep_tran_b9	] {sheep_tran_think();};
void()	sheep_tran_b9	=[220,	sheep_tran_b10	] {sheep_tran_think();};
void()	sheep_tran_b10	=[221,	sheep_tran_b11	] {sheep_tran_think();};
void()	sheep_tran_b11	=[222,	sheep_tran_b12	] {sheep_tran_think();};
void()	sheep_tran_b12	=[223,	sheep_trot1		] {sheep_tran_think();};

void()	sheep_graze_a1	=[0,	sheep_graze_a2	] {sheep_think();};
void()	sheep_graze_a2	=[1,	sheep_graze_a3	] {sheep_think();};
void()	sheep_graze_a3	=[2,	sheep_graze_a4	] {sheep_think();};
void()	sheep_graze_a4	=[3,	sheep_graze_a5	] {sheep_think();};
void()	sheep_graze_a5	=[4,	sheep_graze_a6	] {sheep_think();};
void()	sheep_graze_a6	=[5,	sheep_graze_a7	] {sheep_think();};
void()	sheep_graze_a7	=[6,	sheep_graze_a8	] {sheep_think();};
void()	sheep_graze_a8	=[7,	sheep_graze_a9	] {sheep_think();};
void()	sheep_graze_a9	=[8,	sheep_graze_a10	] {
	sheep_think();
	if (random() < 0.5 && !(self.spawnflags & 1)) {
		sheep_gstep_b1(); // Let's move to fresh grass shall we
	}
};
void()	sheep_graze_a10	=[9,	sheep_graze_a11	] {sheep_think();};
void()	sheep_graze_a11	=[10,	sheep_graze_a12	] {sheep_think();};
void()	sheep_graze_a12	=[11,	sheep_graze_a13	] {sheep_think();};
void()	sheep_graze_a13	=[12,	sheep_graze_a14	] {sheep_think();};
void()	sheep_graze_a14	=[13,	sheep_graze_a15	] {sheep_think();};
void()	sheep_graze_a15	=[14,	sheep_graze_a16	] {sheep_think();};
void()	sheep_graze_a16	=[15,	sheep_graze_a17	] {sheep_think();};
void()	sheep_graze_a17	=[16,	sheep_graze_a18	] {sheep_think();};
void()	sheep_graze_a18	=[17,	sheep_graze_a19	] {sheep_think();};
void()	sheep_graze_a19	=[18,	sheep_graze_a20	] {sheep_think();};
void()	sheep_graze_a20	=[19,	sheep_graze_a21	] {sheep_think();};
void()	sheep_graze_a21	=[20,	sheep_graze_a22	] {sheep_think();};
void()	sheep_graze_a22	=[21,	sheep_graze_a23	] {sheep_think();};
void()	sheep_graze_a23	=[22,	sheep_graze_a24	] {sheep_think();};
void()	sheep_graze_a24	=[23,	sheep_graze_a25	] {sheep_think();};
void()	sheep_graze_a25	=[24,	sheep_graze_a26	] {sheep_think();};
void()	sheep_graze_a26	=[25,	sheep_graze_a27	] {sheep_think();};
void()	sheep_graze_a27	=[26,	sheep_graze_a28	] {sheep_think();};
void()	sheep_graze_a28	=[27,	sheep_graze_a29	] {sheep_think();};
void()	sheep_graze_a29	=[28,	sheep_graze_a30	] {sheep_think();};
void()	sheep_graze_a30	=[29,	sheep_graze_a31	] {sheep_think();};
void()	sheep_graze_a31	=[30,	sheep_graze_a32	] {sheep_think();};
void()	sheep_graze_a32	=[31,	sheep_graze_a33	] {sheep_think();};
void()	sheep_graze_a33	=[32,	sheep_graze_a34	] {sheep_think();};
void()	sheep_graze_a34	=[33,	sheep_graze_a35	] {sheep_think();};
void()	sheep_graze_a35	=[34,	sheep_graze_a36	] {sheep_think();};
void()	sheep_graze_a36	=[35,	sheep_graze_a37	] {sheep_think();};
void()	sheep_graze_a37	=[36,	sheep_graze_a38	] {sheep_think();};
void()	sheep_graze_a38 =[37,	sheep_graze_a39	] {sheep_think();};
void()	sheep_graze_a39	=[38,	sheep_graze_a40	] {sheep_think();};
void()	sheep_graze_a40	=[39,	sheep_graze_a1	] {
	sheep_think();
	if (random() < 0.5) {
		sheep_lookup1(); // Let's look for fresh grass here
	}
};

void()	sheep_graze_b1	=[40,	sheep_graze_b2	] {sheep_think();};
void()	sheep_graze_b2	=[41,	sheep_graze_b3	] {sheep_think();};
void()	sheep_graze_b3	=[42,	sheep_graze_b4	] {sheep_think();};
void()	sheep_graze_b4	=[43,	sheep_graze_b5	] {sheep_think();};
void()	sheep_graze_b5	=[44,	sheep_graze_b6	] {sheep_think();};
void()	sheep_graze_b6	=[45,	sheep_graze_b7	] {sheep_think();};
void()	sheep_graze_b7	=[46,	sheep_graze_b8	] {sheep_think();};
void()	sheep_graze_b8	=[47,	sheep_graze_b9	] {sheep_think();};
void()	sheep_graze_b9	=[48,	sheep_graze_b10	] {
	sheep_think();
	if (random() < 0.5 && !(self.spawnflags & 1)) {
		sheep_gstep_a1(); // Let's move to fresh grass shall we
	}
};
void()	sheep_graze_b10	=[49,	sheep_graze_b11	] {sheep_think();};
void()	sheep_graze_b11	=[50,	sheep_graze_b12	] {sheep_think();};
void()	sheep_graze_b12	=[51,	sheep_graze_b13	] {sheep_think();};
void()	sheep_graze_b13	=[52,	sheep_graze_b14	] {sheep_think();};
void()	sheep_graze_b14	=[53,	sheep_graze_b15	] {sheep_think();};
void()	sheep_graze_b15	=[54,	sheep_graze_b16	] {sheep_think();};
void()	sheep_graze_b16	=[55,	sheep_graze_b17	] {sheep_think();};
void()	sheep_graze_b17	=[56,	sheep_graze_b18	] {sheep_think();};
void()	sheep_graze_b18	=[57,	sheep_graze_b19	] {sheep_think();};
void()	sheep_graze_b19	=[58,	sheep_graze_b20	] {sheep_think();};
void()	sheep_graze_b20	=[59,	sheep_graze_b21	] {sheep_think();};
void()	sheep_graze_b21	=[60,	sheep_graze_b22	] {sheep_think();};
void()	sheep_graze_b22	=[61,	sheep_graze_b23	] {sheep_think();};
void()	sheep_graze_b23	=[62,	sheep_graze_b24	] {sheep_think();};
void()	sheep_graze_b24	=[63,	sheep_graze_b25	] {sheep_think();};
void()	sheep_graze_b25	=[64,	sheep_graze_b26	] {sheep_think();};
void()	sheep_graze_b26	=[65,	sheep_graze_b27	] {sheep_think();};
void()	sheep_graze_b27	=[66,	sheep_graze_b28	] {sheep_think();};
void()	sheep_graze_b28	=[67,	sheep_graze_b29	] {sheep_think();};
void()	sheep_graze_b29	=[68,	sheep_graze_b30	] {sheep_think();};
void()	sheep_graze_b30	=[69,	sheep_graze_b31	] {sheep_think();};
void()	sheep_graze_b31	=[70,	sheep_graze_b32	] {sheep_think();};
void()	sheep_graze_b32	=[71,	sheep_graze_b33	] {sheep_think();};
void()	sheep_graze_b33	=[72,	sheep_graze_b34	] {sheep_think();};
void()	sheep_graze_b34	=[73,	sheep_graze_b35	] {sheep_think();};
void()	sheep_graze_b35	=[74,	sheep_graze_b36	] {sheep_think();};
void()	sheep_graze_b36	=[75,	sheep_graze_b37	] {sheep_think();};
void()	sheep_graze_b37	=[76,	sheep_graze_b38	] {sheep_think();};
void()	sheep_graze_b38 =[77,	sheep_graze_b39	] {sheep_think();};
void()	sheep_graze_b39	=[78,	sheep_graze_b40	] {sheep_think();};
void()	sheep_graze_b40	=[79,	sheep_graze_b1	] {
	sheep_think();
	if (random() < 0.5) {
		sheep_lookup1(); // Let's look for fresh grass here
	}
};

void() sheep_gstep_think = {
	sheep_think();
	if (self.goalentity) {
		ai_sheep_move (0.3); // barely move slowly forward
	} else {
		if (!walkmove(self.angles_y, 0.3)) sheep_turn();
	}
};

void()	sheep_gstep_a1	=[80,	sheep_gstep_a2	] {sheep_gstep_think();};
void()	sheep_gstep_a2	=[81,	sheep_gstep_a3	] {sheep_gstep_think();};
void()	sheep_gstep_a3	=[82,	sheep_gstep_a4	] {sheep_gstep_think();};
void()	sheep_gstep_a4	=[83,	sheep_gstep_a5	] {sheep_gstep_think();};
void()	sheep_gstep_a5	=[84,	sheep_gstep_a6	] {sheep_gstep_think();};
void()	sheep_gstep_a6	=[85,	sheep_gstep_a7	] {sheep_gstep_think();};
void()	sheep_gstep_a7	=[86,	sheep_gstep_a8	] {sheep_gstep_think();};
void()	sheep_gstep_a8	=[87,	sheep_gstep_a9	] {sheep_gstep_think();};
void()	sheep_gstep_a9	=[88,	sheep_gstep_a10	] {sheep_gstep_think();};
void()	sheep_gstep_a10	=[89,	sheep_gstep_a11	] {sheep_gstep_think();};
void()	sheep_gstep_a11	=[90,	sheep_gstep_a12	] {sheep_gstep_think();};
void()	sheep_gstep_a12	=[91,	sheep_gstep_a13	] {sheep_gstep_think();};
void()	sheep_gstep_a13	=[92,	sheep_gstep_a14	] {sheep_gstep_think();};
void()	sheep_gstep_a14	=[93,	sheep_gstep_a15	] {sheep_gstep_think();};
void()	sheep_gstep_a15	=[94,	sheep_gstep_a16	] {sheep_gstep_think();};
void()	sheep_gstep_a16	=[95,	sheep_gstep_a17	] {sheep_gstep_think();};
void()	sheep_gstep_a17	=[96,	sheep_gstep_a18	] {sheep_gstep_think();};
void()	sheep_gstep_a18	=[97,	sheep_gstep_a19	] {sheep_gstep_think();};
void()	sheep_gstep_a19 =[98,	sheep_gstep_a20	] {sheep_gstep_think();};
void()	sheep_gstep_a20	=[99,	sheep_gstep_a21	] {sheep_gstep_think();};
void()	sheep_gstep_a21	=[100,	sheep_graze_a1	] {
	sheep_gstep_think();
	if (random() < 0.5) sheep_gstep_b1(); // Sometimes take another step
};

void()	sheep_gstep_b1	=[101,	sheep_gstep_b2	] {sheep_gstep_think();};
void()	sheep_gstep_b2	=[102,	sheep_gstep_b3	] {sheep_gstep_think();};
void()	sheep_gstep_b3	=[103,	sheep_gstep_b4	] {sheep_gstep_think();};
void()	sheep_gstep_b4	=[104,	sheep_gstep_b5	] {sheep_gstep_think();};
void()	sheep_gstep_b5	=[105,	sheep_gstep_b6	] {sheep_gstep_think();};
void()	sheep_gstep_b6	=[106,	sheep_gstep_b7	] {sheep_gstep_think();};
void()	sheep_gstep_b7	=[107,	sheep_gstep_b8	] {sheep_gstep_think();};
void()	sheep_gstep_b8	=[108,	sheep_gstep_b9	] {sheep_gstep_think();};
void()	sheep_gstep_b9	=[109,	sheep_gstep_b10	] {sheep_gstep_think();};
void()	sheep_gstep_b10	=[110,	sheep_gstep_b11	] {sheep_gstep_think();};
void()	sheep_gstep_b11	=[111,	sheep_gstep_b12	] {sheep_gstep_think();};
void()	sheep_gstep_b12	=[112,	sheep_gstep_b13	] {sheep_gstep_think();};
void()	sheep_gstep_b13	=[113,	sheep_gstep_b14	] {sheep_gstep_think();};
void()	sheep_gstep_b14	=[114,	sheep_gstep_b15	] {sheep_gstep_think();};
void()	sheep_gstep_b15	=[115,	sheep_gstep_b16	] {sheep_gstep_think();};
void()	sheep_gstep_b16	=[116,	sheep_gstep_b17	] {sheep_gstep_think();};
void()	sheep_gstep_b17	=[117,	sheep_gstep_b18	] {sheep_gstep_think();};
void()	sheep_gstep_b18	=[118,	sheep_gstep_b19	] {sheep_gstep_think();};
void()	sheep_gstep_b19 =[119,	sheep_gstep_b20	] {sheep_gstep_think();};
void()	sheep_gstep_b20	=[120,	sheep_gstep_b21	] {sheep_gstep_think();};
void()	sheep_gstep_b21	=[121,	sheep_graze_b1	] {
	sheep_gstep_think();
	if (random() < 0.5) sheep_gstep_a1(); // Sometimes take another step
};

void()	sheep_trot1		=[224,	sheep_trot2	] {sheep_tran_think();};
void()	sheep_trot2		=[225,	sheep_trot3	] {sheep_tran_think();};
void()	sheep_trot3		=[226,	sheep_trot4	] {sheep_tran_think();};
void()	sheep_trot4		=[227,	sheep_trot5	] {sheep_tran_think();};
void()	sheep_trot5		=[228,	sheep_trot6	] {sheep_tran_think();};
void()	sheep_trot6		=[229,	sheep_trot7	] {sheep_tran_think();};
void()	sheep_trot7		=[230,	sheep_trot8	] {sheep_tran_think();};
void()	sheep_trot8		=[231,	sheep_trot9	] {sheep_tran_think();};
void()	sheep_trot9		=[232,	sheep_trot10] {sheep_tran_think();};
void()	sheep_trot10	=[233,	sheep_tran_a1]{sheep_tran_think();};

void()	sheep_wait1		=[234,	sheep_wait2	] {ai_stand();sheep_think();};
void()	sheep_wait2		=[235,	sheep_wait3	] {ai_stand();sheep_think();};
void()	sheep_wait3		=[236,	sheep_wait4	] {ai_stand();sheep_think();};
void()	sheep_wait4		=[237,	sheep_wait5	] {ai_stand();sheep_think();};
void()	sheep_wait5		=[238,	sheep_wait6	] {ai_stand();sheep_think();};
void()	sheep_wait6		=[239,	sheep_wait7	] {ai_stand();sheep_think();};
void()	sheep_wait7		=[240,	sheep_wait8	] {ai_stand();sheep_think();};
void()	sheep_wait8		=[241,	sheep_wait9	] {ai_stand();sheep_think();};
void()	sheep_wait9		=[242,	sheep_wait10] {ai_stand();sheep_think();};
void()	sheep_wait10	=[243,	sheep_wait11] {ai_stand();sheep_think();};
void()	sheep_wait11	=[244,	sheep_wait12] {ai_stand();sheep_think();};
void()	sheep_wait12	=[245,	sheep_wait13] {ai_stand();sheep_think();};
void()	sheep_wait13	=[246,	sheep_wait14] {ai_stand();sheep_think();};
void()	sheep_wait14	=[247,	sheep_wait15] {ai_stand();sheep_think();};
void()	sheep_wait15	=[248,	sheep_wait16] {ai_stand();sheep_think();};
void()	sheep_wait16	=[249,	sheep_wait1	] {
	local float r;
	ai_stand();
	sheep_think();
	r = random();
	if (r < 0.333) {
		sheep_wait1();
	} else {
		if (r < 0.666 && !(self.spawnflags & 1)) {
			sheep_tran_b1();
		} else {
			sheep_lookdown1();
		}
	}
};

void()	sheep_pain1		=[194,	sheep_pain2	] {ai_pain(1);};
void()	sheep_pain2		=[195,	sheep_pain3	] {ai_pain(1);};
void()	sheep_pain3		=[196,	sheep_pain4	] {ai_pain(1);};
void()	sheep_pain4		=[197,	sheep_pain5	] {ai_pain(1);};
void()	sheep_pain5		=[198,	sheep_pain6	] {ai_pain(1);};
void()	sheep_pain6		=[199,	sheep_pain7	] {ai_pain(1);};
void()	sheep_pain7		=[200,	sheep_pain8	] {ai_pain(1);};
void()	sheep_pain8		=[201,	sheep_wait1	] {
	local float r;
	ai_pain(1);
	r = random();
	if (r < 0.333) {
		sheep_wait1();
	} else {
		if (r < 0.666 && !(self.spawnflags & 1)) {
			sheep_tran_b1();
		} else {
			sheep_lookdown1();
		}
	}
};

void(entity inflictor, entity attacker, float damage) sheep_pain =  {
	local float r, vol;

	if (self.pain_finished > time) return;

	// Duplicate of sheep_sound code here because we want to guarantee bleet on pain hit
	r = random();
	if (random() < 0.5) vol = (random() * 0.8) + 0.2;
	else vol = 1;

	if (r < 0.333) {
		sound (self, CHAN_VOICE, "sheep/sheep1.wav", vol, ATTN_NORM);
	} else {
		if (r < 0.666) sound (self, CHAN_VOICE, "sheep/sheep2.wav", vol, ATTN_NORM);
		else sound (self, CHAN_VOICE, "sheep/sheep3.wav", vol, ATTN_NORM);
	}
	self.pain_finished = time + 2;
	sheep_pain1();
};

void()	sheep_lookdown1		=[133,	sheep_lookdown2	] {sheep_think();};
void()	sheep_lookdown2		=[132,	sheep_lookdown3	] {sheep_think();};
void()	sheep_lookdown3		=[131,	sheep_lookdown4	] {sheep_think();};
void()	sheep_lookdown4		=[130,	sheep_lookdown5] {sheep_think();};
void()	sheep_lookdown5		=[129,	sheep_lookdown6] {sheep_think();};
void()	sheep_lookdown6		=[128,	sheep_lookdown7] {sheep_think();};
void()	sheep_lookdown7		=[127,	sheep_lookdown8] {sheep_think();};
void()	sheep_lookdown8		=[126,	sheep_lookdown9] {sheep_think();};
void()	sheep_lookdown9		=[125,	sheep_lookdown10] {sheep_think();};
void()	sheep_lookdown10	=[124,	sheep_lookdown11] {sheep_think();};
void()	sheep_lookdown11	=[123,	sheep_lookdown12] {sheep_think();};
void()	sheep_lookdown12	=[122,	sheep_graze_a1] {
	local float r;
	sheep_think();
	r = random();
	if (r < 0.25) {
		sheep_graze_a1();
	} else {
		if (r < 0.5) {
			sheep_graze_b1();
		} else {
			if (r < 0.75 && !(self.spawnflags & 1)) {
				sheep_gstep_b1();
			} else {
				sheep_lookup1();
			}
		}
	}
};

void()	sheep_lookup1	=[122,	sheep_lookup2] {sheep_think();};
void()	sheep_lookup2	=[123,	sheep_lookup3] {sheep_think();};
void()	sheep_lookup3	=[124,	sheep_lookup4] {sheep_think();};
void()	sheep_lookup4	=[125,	sheep_lookup5] {sheep_think();};
void()	sheep_lookup5	=[126,	sheep_lookup6] {sheep_think();};
void()	sheep_lookup6	=[127,	sheep_lookup7] {sheep_think();};
void()	sheep_lookup7	=[128,	sheep_lookup8] {sheep_think();};
void()	sheep_lookup8	=[129,	sheep_lookup9] {sheep_think();};
void()	sheep_lookup9	=[130,	sheep_lookup10] {sheep_think();};
void()	sheep_lookup10	=[131,	sheep_lookup11] {sheep_think();};
void()	sheep_lookup11	=[132,	sheep_lookup12] {sheep_think();};
void()	sheep_lookup12	=[133,	sheep_look1] {sheep_think();};

void()	sheep_look1		=[134,	sheep_look2] {sheep_think();};
void()	sheep_look2		=[135,	sheep_look3] {sheep_think();};
void()	sheep_look3		=[136,	sheep_look4] {sheep_think();};
void()	sheep_look4		=[137,	sheep_look5] {sheep_think();};
void()	sheep_look5		=[138,	sheep_look6] {sheep_think();};
void()	sheep_look6		=[139,	sheep_look7] {sheep_think();};
void()	sheep_look7		=[140,	sheep_look8] {sheep_think();};
void()	sheep_look8		=[141,	sheep_look9] {sheep_think();};
void()	sheep_look9		=[142,	sheep_look10] {sheep_think();};
void()	sheep_look10	=[143,	sheep_look11] {sheep_think();};
void()	sheep_look11	=[144,	sheep_look12] {sheep_think();};
void()	sheep_look12	=[145,	sheep_look13] {sheep_think();};
void()	sheep_look13	=[146,	sheep_look14] {sheep_think();};
void()	sheep_look14	=[147,	sheep_look15] {sheep_think();};
void()	sheep_look15	=[148,	sheep_look16] {sheep_think();};
void()	sheep_look16	=[149,	sheep_look17] {sheep_think();};
void()	sheep_look17	=[150,	sheep_look18] {sheep_think();};
void()	sheep_look18	=[151,	sheep_look19] {sheep_think();};
void()	sheep_look19	=[152,	sheep_look20] {sheep_think();};
void()	sheep_look20	=[153,	sheep_look21] {sheep_think();};
void()	sheep_look21	=[154,	sheep_look22] {sheep_think();};
void()	sheep_look22	=[155,	sheep_look23] {sheep_think();};
void()	sheep_look23	=[156,	sheep_look24] {sheep_think();};
void()	sheep_look24	=[157,	sheep_look25] {sheep_think();};
void()	sheep_look25	=[158,	sheep_look26] {sheep_think();};
void()	sheep_look26	=[159,	sheep_look27] {sheep_think();};
void()	sheep_look27	=[160,	sheep_look28] {sheep_think();};
void()	sheep_look28	=[161,	sheep_look29] {sheep_think();};
void()	sheep_look29	=[162,	sheep_look30] {sheep_think();};
void()	sheep_look30	=[163,	sheep_look31] {sheep_think();};
void()	sheep_look31	=[164,	sheep_look32] {sheep_think();};
void()	sheep_look32	=[165,	sheep_look33] {sheep_think();};
void()	sheep_look33	=[166,	sheep_look34] {sheep_think();};
void()	sheep_look34	=[167,	sheep_look35] {sheep_think();};
void()	sheep_look35	=[168,	sheep_look36] {sheep_think();};
void()	sheep_look36	=[169,	sheep_look37] {sheep_think();};
void()	sheep_look37	=[170,	sheep_look38] {sheep_think();};
void()	sheep_look38	=[171,	sheep_look39] {sheep_think();};
void()	sheep_look39	=[172,	sheep_look40] {sheep_think();};
void()	sheep_look40	=[173,	sheep_look41] {sheep_think();};
void()	sheep_look41	=[174,	sheep_look42] {sheep_think();};
void()	sheep_look42	=[175,	sheep_look43] {sheep_think();};
void()	sheep_look43	=[176,	sheep_look44] {sheep_think();};
void()	sheep_look44	=[177,	sheep_look45] {sheep_think();};
void()	sheep_look45	=[178,	sheep_look46] {sheep_think();};
void()	sheep_look46	=[179,	sheep_look47] {sheep_think();};
void()	sheep_look47	=[180,	sheep_look48] {sheep_think();};
void()	sheep_look48	=[181,	sheep_look49] {sheep_think();};
void()	sheep_look49	=[182,	sheep_look50] {sheep_think();};
void()	sheep_look50	=[183,	sheep_look51] {sheep_think();};
void()	sheep_look51	=[184,	sheep_look52] {sheep_think();};
void()	sheep_look52	=[185,	sheep_look53] {sheep_think();};
void()	sheep_look53	=[186,	sheep_look54] {sheep_think();};
void()	sheep_look54	=[187,	sheep_look55] {sheep_think();};
void()	sheep_look55	=[188,	sheep_look56] {sheep_think();};
void()	sheep_look56	=[189,	sheep_look57] {sheep_think();};
void()	sheep_look57	=[190,	sheep_look58] {sheep_think();};
void()	sheep_look58	=[191,	sheep_look59] {sheep_think();};
void()	sheep_look59	=[192,	sheep_look60] {sheep_think();};
void()	sheep_look60 	=[193,	sheep_wait1] {
	local float r;
	sheep_think();
	r = random();
	if (r < 0.333) {
		sheep_wait1();
	} else {
		if (r < 0.666 && !(self.spawnflags & 1)) {
			sheep_tran_b1();
		} else {
			sheep_lookdown1();
		}
	}
};

void() sheep_bite =  {
	makevectors ( self.angles);
	traceline ( (self.origin + self.view_ofs), ((self.origin + self.view_ofs) + (v_forward * 36.00000)), FALSE, self);
	if (trace_ent.takedamage) {
		sound ( self, CHAN_VOICE, "sheep/bite.wav", 1.00000, ATTN_NORM);
		SpawnMeatSpray(self,trace_ent,(crandom() * 100) + 100);
		T_Damage(trace_ent, self, self, 5, DAMARMOR);
		self.attack_finished = (time + 0.2 + (random() * 0.8));
	}
};

void() sheep_run_think = {
	if (self.enemy.classgroup == CG_HARMLESS || self.enemy.classtype == self.classtype && !visible(self.enemy)) {
		sheep_trot1();
	}

	if (random() < 0.1 && random() < 0.2) sheep_sound(); // extra bleet with a 0.02% chance

	ai_face();
	movetogoal(4);
	if (infront(self.enemy)) {
		if ((range(self.enemy) == RANGE_MELEE) && (self.attack_finished < time)) sheep_bite();
	}
}

void()	sheep_run1		=[224,	sheep_run2	] {sheep_run_think();};
void()	sheep_run2		=[225,	sheep_run3	] {sheep_run_think();};
void()	sheep_run3		=[226,	sheep_run4	] {sheep_run_think();};
void()	sheep_run4		=[227,	sheep_run5	] {sheep_run_think();};
void()	sheep_run5		=[228,	sheep_run6	] {sheep_run_think();};
void()	sheep_run6		=[229,	sheep_run7	] {sheep_run_think();};
void()	sheep_run7		=[230,	sheep_run8	] {sheep_run_think();};
void()	sheep_run8		=[231,	sheep_run9	] {sheep_run_think();};
void()	sheep_run9		=[232,	sheep_run10] {sheep_run_think();};
void()	sheep_run10		=[233,	sheep_run1]{sheep_run_think();};

void()	sheep_diea1		=[0,	sheep_diea2	] {
	self.reviveframestart = 23;
	self.reviveframeend = 0;
};
void()	sheep_diea2		=[1,	sheep_diea3	] {monster_check_gib();};
void()	sheep_diea3		=[2,	sheep_diea4	] {monster_check_gib();};
void()	sheep_diea4		=[3,	sheep_diea5	] {};
void()	sheep_diea5		=[4,	sheep_diea6	] {};
void()	sheep_diea6		=[5,	sheep_diea7	] {};
void()	sheep_diea7		=[6,	sheep_diea8	] {};
void()	sheep_diea8		=[7,	sheep_diea9	] {};
void()	sheep_diea9		=[8,	sheep_diea10	] {};
void()	sheep_diea10	=[9,	sheep_diea11	] {};
void()	sheep_diea11	=[10,	sheep_diea12	] {};
void()	sheep_diea12	=[11,	sheep_diea13	] {};
void()	sheep_diea13	=[12,	sheep_diea14	] {};
void()	sheep_diea14	=[13,	sheep_diea15	] {};
void()	sheep_diea15	=[14,	sheep_diea16	] {};
void()	sheep_diea16	=[15,	sheep_diea17	] {};
void()	sheep_diea17	=[16,	sheep_diea18	] {};
void()	sheep_diea18	=[17,	sheep_diea19	] {};
void()	sheep_diea19	=[18,	sheep_diea20	] {};
void()	sheep_diea20	=[19,	sheep_diea21	] {};
void()	sheep_diea21	=[20,	sheep_diea22	] {};
void()	sheep_diea22	=[21,	sheep_diea23	] {};
void()	sheep_diea23	=[22,	sheep_diea24	] {monster_death_postcheck();};
void()	sheep_diea24	=[23,	sheep_diea24	] {monster_deadbody_check();};

void()	sheep_dieb1		=[24,	sheep_dieb2	] {
	self.reviveframestart = 49;
	self.reviveframeend = 24;
};
void()	sheep_dieb2		=[25,	sheep_dieb3	] {monster_check_gib();};
void()	sheep_dieb3		=[26,	sheep_dieb4	] {monster_check_gib();};
void()	sheep_dieb4		=[27,	sheep_dieb5	] {};
void()	sheep_dieb5		=[28,	sheep_dieb6	] {};
void()	sheep_dieb6		=[29,	sheep_dieb7	] {};
void()	sheep_dieb7		=[30,	sheep_dieb8	] {};
void()	sheep_dieb8		=[31,	sheep_dieb9	] {};
void()	sheep_dieb9		=[32,	sheep_dieb10	] {};
void()	sheep_dieb10	=[33,	sheep_dieb11	] {};
void()	sheep_dieb11	=[34,	sheep_dieb12	] {};
void()	sheep_dieb12	=[35,	sheep_dieb13	] {};
void()	sheep_dieb13	=[36,	sheep_dieb14	] {};
void()	sheep_dieb14	=[37,	sheep_dieb15	] {};
void()	sheep_dieb15	=[38,	sheep_dieb16	] {};
void()	sheep_dieb16	=[39,	sheep_dieb17	] {};
void()	sheep_dieb17	=[40,	sheep_dieb18	] {};
void()	sheep_dieb18	=[41,	sheep_dieb19	] {};
void()	sheep_dieb19	=[42,	sheep_dieb20	] {};
void()	sheep_dieb20	=[43,	sheep_dieb21	] {};
void()	sheep_dieb21	=[44,	sheep_dieb22	] {};
void()	sheep_dieb22	=[45,	sheep_dieb23	] {};
void()	sheep_dieb23	=[46,	sheep_dieb24	] {};
void()	sheep_dieb24	=[47,	sheep_dieb25	] {};
void()	sheep_dieb25	=[48,	sheep_dieb26	] {monster_death_postcheck();};
void()	sheep_dieb26	=[49,	sheep_dieb26	] {monster_deadbody_check();};

void() sheep_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities

	// regular death
	if (!self.gibbed) {
		sound (self, CHAN_VOICE, "sheep/sheepfly.wav", 1, ATTN_NORM);
		self.mdl = "progs/hexen2/mon_sheep_extra.mdl";
		self.oldorigin = self.origin;
		setmodel(self,self.mdl); // Extra because we used more than 256 frames.
		setsize (self, self.bbmins, self.bbmaxs);
		setorigin(self, self.oldorigin); // Reset origin since engine might.

		if (random() > 0.5) sheep_diea1 ();
		else sheep_dieb1 ();
	}
};

void() monster_sheep_precache =  {
	precache_model ("progs/hexen2/mon_sheep.mdl");
	precache_model ("progs/hexen2/mon_sheep_extra.mdl");
	precache_sound ("sheep/sheep1.wav");
	precache_sound ("sheep/sheep2.wav");
	precache_sound ("sheep/sheep3.wav");
	precache_sound ("sheep/sheepfly.wav");
	precache_sound ("sheep/bite.wav");
};

void() monster_sheep =  {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/hexen2/mon_sheep.mdl";
	self.sight_sound = "sheep/sheep1.wav";
	self.death_sound = "sheep/sheepfly.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_DOG;
	if (self.health < 1) self.health = 150; // Fairly stout, can resist one rocket blast from a careless player
	self.gibhealth = -10; 				// Highly likely to gib
	self.gibbed = FALSE;
	self.pain_flinch = 20;				// Likely always flinch
	self.th_pain = sheep_pain;
	// self.touch = obj_push;
	self.yaw_speed = 15;
	self.th_die = sheep_die;
	self.th_melee = sheep_bite; // Will bite when provoked.  He was provokin' me Atticus!
	self.th_stand = sheep_wait1;
	self.th_walk = sheep_trot1; // sleep walking?
	self.th_run = sheep_run1;
	if (self.deathstring == "")  self.deathstring = " fed himself to a sheep\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	SetDefaultDenizenAttributes(self); // Standard DENIZEN AI
	self.classtype = CT_MONSHEEP;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEWALK;
	monster_start();
};