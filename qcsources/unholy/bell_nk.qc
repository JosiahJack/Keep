$frame ring0  ring1  ring2  ring3  ring4  ring5  ring6  ring7  ring8  ring9
$frame ring10 ring11 ring12 ring13 ring14 ring15 ring16 ring17 ring18 ring19
$frame ring20 ring21 ring22 ring23 ring24 ring25 ring26 ring27 ring28 ring29 ring30

void() bell_bigring0 =[$ring0,bell_bigring1  ] { self.nextthink = time + 0.15; };
void() bell_bigring1 =[$ring1,bell_bigring2  ] {};
void() bell_bigring2 =[$ring2,bell_bigring3  ] { sound (self, CHAN_VOICE, "misc/bellring.wav", 1, ATTN_NONE); };
void() bell_bigring3 =[$ring3,bell_bigring4  ] {};
void() bell_bigring4 =[$ring4,bell_bigring5  ] {};
void() bell_bigring5 =[$ring5,bell_bigring6  ] {};
void() bell_bigring6 =[$ring6,bell_bigring7  ] {};
void() bell_bigring7 =[$ring7,bell_bigring8  ] { sound (self, CHAN_VOICE, "misc/bellring.wav", 1, ATTN_NONE); SUB_UseTargets(); };
void() bell_bigring8 =[$ring8,bell_bigring9  ] {};
void() bell_bigring9 =[$ring9,bell_bigring10 ] {};
void() bell_bigring10=[$ring10,bell_bigring11] {};
void() bell_bigring11=[$ring11,bell_bigring12] {};
void() bell_bigring12=[$ring12,bell_bigring13] {};
void() bell_bigring13=[$ring13,bell_bigring14] {};
void() bell_bigring14=[$ring14,bell_bigring15] {};
void() bell_bigring15=[$ring15,bell_bigring16] {};
void() bell_bigring16=[$ring16,bell_bigring17] {};
void() bell_bigring17=[$ring17,bell_bigring18] {};
void() bell_bigring18=[$ring18,bell_bigring19] {};
void() bell_bigring19=[$ring19,bell_bigring20] {};
void() bell_bigring20=[$ring20,bell_bigring21] {};
void() bell_bigring21=[$ring21,bell_bigring22] {};
void() bell_bigring22=[$ring22,bell_bigring23] {};
void() bell_bigring23=[$ring23,bell_bigring24] {};
void() bell_bigring24=[$ring24,bell_bigring25] {};
void() bell_bigring25=[$ring25,bell_bigring26] {};
void() bell_bigring26=[$ring26,bell_bigring27] {};
void() bell_bigring27=[$ring27,bell_bigring28] {};
void() bell_bigring28=[$ring28,bell_bigring29] {};
void() bell_bigring29=[$ring29,bell_bigring30] {};
void() bell_bigring30=[$ring30,bell_bigring0]
{
		self.frame = 0;
		self.nextthink = time - 1;
		self.think = SUB_Null;
};

void bell_ring (void)
{
	self.health = self.max_health;
	if (self.frame != 0) return;
	bell_bigring0();
}

/*QUAKED obj_bell (0.3 0.1 0.6) (-100 -100 -210) (100 100 8)
A big bell that rings when hit. 
-------------------------FIELDS-------------------------
health = 250
--------------------------------------------------------
*/
void obj_bell (void)
{
	precache_sound("misc/bellring.wav");
	precache_model("progs/bellring.mdl");

	setmodel(self, "progs/bellring.mdl");
	setsize (self, '-100 -100 -205', '100 100 8');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = TRUE;
	self.max_health = self.health = 250;
	self.th_pain = bell_ring;
	self.use = bell_ring;
}
