
void() bubble_bob;

/*
==============================================================================

PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base		
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6


/*
==============================================================================
PLAYER
==============================================================================
*/

void(entity e, float waterwalk) walksound ={
	local float surfnum, r;
	local string s;

	makevectors(e.v_angle);


	surfnum = getsurfacenearpoint(world, e.origin - '0 0 24');
	if (vlen(self.velocity) < 100)
		return;

	if (surfnum >= 0)
	{
		s = getsurfacetexture(world, surfnum);
		if (waterwalk == 0)
		{
			if (s == "wizmet1_2")
			{
				r = rint(random() * 3);			
				if (r == 0)
					sound (e, CHAN_AUTO, "walk/metal1.wav", autocvar_playerfootsteps, ATTN_NORM);
				else if (r == 1)
					sound (e, CHAN_AUTO, "walk/metal2.wav", autocvar_playerfootsteps, ATTN_NORM);
				else if (r == 2)
					sound (e, CHAN_AUTO, "walk/metal3.wav", autocvar_playerfootsteps, ATTN_NORM);
				else
					sound (e, CHAN_AUTO, "walk/metal4.wav", autocvar_playerfootsteps, ATTN_NORM);
			}
			else
			{
				r = rint(random() * 4);			
				if (r == 0)
					sound (e, CHAN_AUTO, "walk/generic1.wav", autocvar_playerfootsteps, ATTN_NORM);
				else if (r == 1)
					sound (e, CHAN_AUTO, "walk/generic2.wav", autocvar_playerfootsteps, ATTN_NORM);
				else if (r == 2)
					sound (e, CHAN_AUTO, "walk/generic3.wav", autocvar_playerfootsteps, ATTN_NORM);
				else if (r == 3)
					sound (e, CHAN_AUTO, "walk/generic4.wav", autocvar_playerfootsteps, ATTN_NORM);
				else
					sound (e, CHAN_AUTO, "walk/generic5.wav", autocvar_playerfootsteps, ATTN_NORM);
			}
		}
		else
		{
			if (random() < 0.65)
				sound (e, CHAN_AUTO, "walk/waterwade1.wav", 0.7, ATTN_NORM);
			else
				sound (e, CHAN_AUTO, "walk/waterwade2.wav", 0.7, ATTN_NORM);
		}
	}
};

void() player_run;

void()	player_stand1 =[	$axstnd1,	player_stand1	]
{
	if (autocvar_mage_weapon) 
	{
		if (self.weapon != IT_LIGHTNING)
			self.weaponframe=0;
	}
	else
		self.weaponframe=0;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		player_run();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe >= 12)
			self.walkframe = 0;
		self.frame = $axstnd1 + self.walkframe;
	}
	else
	{
		if (self.walkframe >= 5)
			self.walkframe = 0;
		self.frame = $stand1 + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;	
};

void()	player_run =[	$rockrun1,	player_run	]
{
	self.meleeing = 0;
	if ((self.waterlevel == 0) && (autocvar_playerfootsteps))
	{
		if (checkbottom(self) == TRUE)
		{
			if (self.walkframe == 1 || self.walkframe == 4 )
				walksound (self, 0);
		}
	}
	else if ((self.waterlevel == 1 || self.waterlevel == 2) && (autocvar_waterwalk_and_swim_sound))
	{
		if (self.walkframe == 1)
		{
			if (autocvar_waterwalk_and_swim_sound >= 2)	// if 'waterwalk_and_swim_sound' is set to "2", also play watersound when swimming
				walksound (self, 1);
			else						// if 'waterwalk_and_swim_sound' is set to '1' do NOT play watersound when swimming
			{
				if (checkbottom(self) == TRUE)
					walksound (self, 1);
			}
		}
	}

	if (autocvar_mage_weapon) 
	{
		if (self.weapon != IT_LIGHTNING)
			self.weaponframe=0;
	}
	else
		self.weaponframe=0;
	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe=0;
		player_stand1();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = $axrun1 + self.walkframe;
	}
	else
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = self.frame + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;
};


void()	player_shot1 =	[$shotatt1, player_shot2	] {self.weaponframe=1;
self.effects = self.effects | EF_MUZZLEFLASH;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 0))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shot2 =	[$shotatt2, player_shot3	] {self.weaponframe=2;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shot3 =	[$shotatt3, player_shot4	] {self.weaponframe=3;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 2))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shot4 =	[$shotatt4, player_shot5	] {self.weaponframe=4;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 3))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shot5 =	[$shotatt5, player_shot6	] {self.weaponframe=5;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 4))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shot6 =	[$shotatt6, player_run	] {self.weaponframe=6;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 5))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};

void()	player_axe1 =	[$axatt1, player_axe2	] {self.weaponframe=1;};
void()	player_axe2 =	[$axatt2, player_axe3	] {self.weaponframe=2;};
void()	player_axe3 =	[$axatt3, player_axe4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axe4 =	[$axatt4, player_run	] {self.weaponframe=4;};

void()	player_axeb1 =	[$axattb1, player_axeb2	] {self.weaponframe=5;};
void()	player_axeb2 =	[$axattb2, player_axeb3	] {self.weaponframe=6;};
void()	player_axeb3 =	[$axattb3, player_axeb4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axeb4 =	[$axattb4, player_run	] {self.weaponframe=8;};

void()	player_axec1 =	[$axattc1, player_axec2	] {self.weaponframe=1;};
void()	player_axec2 =	[$axattc2, player_axec3	] {self.weaponframe=2;};
void()	player_axec3 =	[$axattc3, player_axec4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axec4 =	[$axattc4, player_run	] {self.weaponframe=4;};

void()	player_axed1 =	[$axattd1, player_axed2	] {self.weaponframe=5;};
void()	player_axed2 =	[$axattd2, player_axed3	] {self.weaponframe=6;};
void()	player_axed3 =	[$axattd3, player_axed4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axed4 =	[$axattd4, player_run	] {self.weaponframe=8;};

void()   melee_axe1 =   [$axatt1, melee_axe2] {self.weaponframe=1;};			// instant melee axe attack
void()   melee_axe2 =   [$axatt2, melee_axe3] {self.weaponframe=2;};
void()   melee_axe3 =   [$axatt3, melee_axe4] {self.weaponframe=3; W_FireAxe();};
void()   melee_axe4 =   [$axatt4, melee_axe5] {self.weaponframe=4;};
void()   melee_axe5 =   [$axatt5, player_run] {self.weaponframe=4; self.meleeing=0; W_SetCurrentAmmo();};

void()   melee_axe6 =   [$axattb1, melee_axe7] {self.weaponframe=5;};			// instant melee axe attack
void()   melee_axe7 =   [$axattb2, melee_axe8] {self.weaponframe=6;};
void()   melee_axe8 =   [$axattb3, melee_axe9] {self.weaponframe=7; W_FireAxe();};
void()   melee_axe9 =   [$axattb4, melee_axe10] {self.weaponframe=7;};
void()   melee_axe10 =   [$axattb5, player_run] {self.weaponframe=7; self.meleeing=0; W_SetCurrentAmmo();};


//============================================================================

void() player_nail1   =[$nailatt1, player_nail2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	if (cvar("chase_active"))
		W_FireSpikes (2);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to a FIXED right position
			W_FireSpikes (10);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			W_FireSpikes (autocvar_weapon_position_adjustable_projectile_nail1a_offset);
		else
			W_FireSpikes (3);
	}
	self.attack_finished = time + 0.2;
};
void() player_nail2   =[$nailatt2, player_nail1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	if (cvar("chase_active"))
		W_FireSpikes (-4);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to a FIXED right position
			W_FireSpikes (6);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			W_FireSpikes (autocvar_weapon_position_adjustable_projectile_nail1b_offset);
		else
			W_FireSpikes (-3);
	}
	self.attack_finished = time + 0.2;
};

//============================================================================

void() player_light1   =[$light1, player_light2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};
void() player_light2   =[$light2, player_light1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

//============================================================================

void() player_mage1   =[$light1, player_mage2  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = 18;
	self.animate_mage_weapon_helper = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

void() player_mage2   =[$light2, player_mage1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = 19;
	self.animate_mage_weapon_helper = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

//============================================================================


void() player_rocket1   =[$rockatt1, player_rocket2  ] {self.weaponframe=1;
self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_rocket2   =[$rockatt2, player_rocket3  ] {self.weaponframe=2;};
void() player_rocket3   =[$rockatt3, player_rocket4  ] {self.weaponframe=3;};
void() player_rocket4   =[$rockatt4, player_rocket5  ] {self.weaponframe=4;};
void() player_rocket5   =[$rockatt5, player_rocket6  ] {self.weaponframe=5;};
void() player_rocket6   =[$rockatt6, player_run  ] {self.weaponframe=6;};
void(float num_bubbles) DeathBubbles;

void() PainSound =
{
local float		rs;

	if (self.health < 0)
		return;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		DeathBubbles(1);
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}

// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
// FIX ME	put in some steam here
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.5;

// don't make multiple pain sounds right after each other

// ax pain sound
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
		return;
	}
	

	rs = rint((random() * 5) + 1);

	self.noise = "";
	if (rs == 1)
		self.noise = "player/pain1.wav";
	else if (rs == 2)
		self.noise = "player/pain2.wav";
	else if (rs == 3)
		self.noise = "player/pain3.wav";
	else if (rs == 4)
		self.noise = "player/pain4.wav";
	else if (rs == 5)
		self.noise = "player/pain5.wav";
	else
		self.noise = "player/pain6.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void()	player_pain1 =	[	$pain1,	player_pain2	] {PainSound();self.weaponframe=0;};
void()	player_pain2 =	[	$pain2,	player_pain3	] {};
void()	player_pain3 =	[	$pain3,	player_pain4	] {};
void()	player_pain4 =	[	$pain4,	player_pain5	] {};
void()	player_pain5 =	[	$pain5,	player_pain6	] {};
void()	player_pain6 =	[	$pain6,	player_run	] {};

void()	player_axpain1 =	[	$axpain1,	player_axpain2	] {PainSound();self.weaponframe=0;};
void()	player_axpain2 =	[	$axpain2,	player_axpain3	] {};
void()	player_axpain3 =	[	$axpain3,	player_axpain4	] {};
void()	player_axpain4 =	[	$axpain4,	player_axpain5	] {};
void()	player_axpain5 =	[	$axpain5,	player_axpain6	] {};
void()	player_axpain6 =	[	$axpain6,	player_run	] {};

void() player_pain =
{
	if (self.weaponframe)
		return;

	if (self.invisible_finished > time)
		return;		// eyes don't have pain frames

	if (self.weapon == IT_AXE)
		player_axpain1 ();
	else
		player_pain1 ();
};

void() player_diea1;
void() player_dieb1;
void() player_diec1;
void() player_died1;
void() player_diee1;
void() player_die_ax1;

void() DeathBubblesSpawn =
{
local entity	bubble;
	if (self.owner.waterlevel != 3)
		return;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.1;
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(float num_bubbles) DeathBubbles =
{
local entity	bubble_spawner;
	
	bubble_spawner = spawn();
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};


void() DeathSound =
{
local float		rs;

	// water death sounds
	if (self.waterlevel == 3)
	{
		DeathBubbles(20);
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
		return;
	}
	
	rs = rint ((random() * 4) + 1);
	if (rs == 1)
		self.noise = "player/death1.wav";
	if (rs == 2)
		self.noise = "player/death2.wav";
	if (rs == 3)
		self.noise = "player/death3.wav";
	if (rs == 4)
		self.noise = "player/death4.wav";
	if (rs == 5)
		self.noise = "player/death5.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};


void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
};

vector(float dm) VelocityForDamage =
{
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();

	if (dm > -50)
	{
//		dprint ("level 1\n");
		v = v * 0.7;
	}
	else if (dm > -200)
	{
//		dprint ("level 3\n");
		v = v * 2;
	}
	else
		v = v * 10;

	return v;
};



void() gibsfade_noblood = 
{
if (self.alpha && self.scale <= 0.01)
	{
	remove (self);
   	return;
	}
else
   	self.alpha = self.alpha - 0.06;
   	self.scale = self.scale - 0.04;

self.nextthink = time + 0.06;	
self.think = gibsfade_noblood;
};


void() gibsfade_blood = 
{
local vector v;   
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

if (self.alpha && self.scale <= 0.5)
	{
	sound (self, CHAN_VOICE, "player/gibexplode.wav", 0.9, ATTN_NORM);
	te_blood (v,'0 70 60', 7);
	te_blood (v,'70 0 60', 7);
	te_blood (v,'-70 0 60', 7);
	te_blood (v,'0 -70 60', 7);
	remove (self);
   	return;
	}
else
   	self.alpha = self.alpha - 0.06;
   	self.scale = self.scale - 0.04;

self.nextthink = time + 0.06;	
self.think = gibsfade_blood;
};

vector(vector m1, vector m2) randompos;

void(string gibname, float dm) ThrowGib =
{
	local	entity new;
	local	float gibsfadetime;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-position´s randomness
	new.origin = org;
	setmodel (new, gibname);
	setsize (new, '-16 -16 0', '16 16 48');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.cansplash = TRUE;			   // create a splash when fall into liquid

	if ((autocvar_kickgibs == 1) && (!autocvar_eatablegibs))
		{
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch;      // Call kick_touch when touched
		}
	else if (autocvar_eatablegibs)	 	// "autocvar_eatablegibs" always overrides "autocvar_kickgibs" !!!
		{
		if ((autocvar_eatablegibs == 3) || (gibname == "progs/gibheart.mdl"))	// only eat regular gibs when cvar is set to 3 (except when function is called from gibbing corpses code (heart gib))
			{
			new.solid = SOLID_TRIGGER;   		// Set it up for a trigger event
			new.touch = eat_regular_gib_touch;      // Call eat_regular_gib_touch when touched
			if (gibname == "progs/gibheart.mdl")
				new.healamount = autocvar_eatable_heart_gib_healamount;	  // default is 5
			else
				new.healamount = autocvar_eatable_regular_gib_healamount; // default is 2
			}
		else 				// --> all gibs cannot be kicked or eat
			{					 
			new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
			new.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
			}
		}
	else 							// --> all gibs cannot be kicked or eat
		{					 
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
		}
	if ( gibname != "progs/gibheart.mdl")	// "gibheart" model must not be spinned around all axis !
		{
		var float autocvar_gibspinstyle = 1;		// set cvar 'gibspinstyle' default to 1
		if (autocvar_gibspinstyle == 1)
			new.avelocity = crandom() * '0 600 0';	 // make gibs behave like head-gibs (only spin around yaw)
		else 						
			{ 					 // make gibs spin around all 3 axis independently (more like original Quake behaviour)
			new.avelocity_x = crandom()*600;
			new.avelocity_y = crandom()*600;
			new.avelocity_z = crandom()*600;
			}
		}
	else 
		new.avelocity = crandom() * '0 600 0';	 // makes "gibheart" model  behave like head-gibs (only spin around yaw)
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		{					 // --> gibs will NEVER disappear !!!
	 	new.nextthink = -1;
		}
	else 							// if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{						// --> gibs fade out
		new.alpha = 1;
		new.scale = 1;
		gibsfadetime = autocvar_gibsduration;
			if (autocvar_gibsexplode == 0)	// if 'gibsduration' is set via autoexec.cfg to '0'
				{
				new.think = gibsfade_noblood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
			else					// if 'gibsexplode' is set via autoexec.cfg to any other value than '1'
				{
				precache_sound ("player/gibexplode.wav");  
				new.think = gibsfade_blood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
		}
	new.frame = 0;
	new.flags = 0;
	
GibPhysics(new);
};


void(string gibname, float dm, float skincolor) ThrowGibSpider =
{
	local	entity new;
	local	float gibsfadetime;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-position´s randomness
	new.origin = org;
	setmodel (new, gibname);
	setsize (new, '-16 -16 0', '16 16 48');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.skin = skincolor;
	new.cansplash = TRUE;			   // create a splash when fall into liquid


	if ((autocvar_kickgibs == 1) && (!autocvar_eatablegibs))
		{
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch;      // Call kick_touch when touched
		}
	else if (autocvar_eatablegibs)	 	// "autocvar_eatablegibs" always overrides "autocvar_kickgibs" !!!
		{
		if (autocvar_eatablegibs == 3)	// only eat regular gibs when cvar is set to 2
			{
			new.solid = SOLID_TRIGGER;   		// Set it up for a trigger event
			new.touch = eat_regular_gib_touch;      // Call eat_regular_gib_touch when touched
			new.healamount = autocvar_eatable_regular_gib_healamount;	// default is 2
			}
		else 				// --> all gibs cannot be kicked or eat
			{					 
			new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
			new.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
			}
		}
	else 							// --> all gibs cannot be kicked or eat
		{					 
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
		}

	new.avelocity = crandom() * '0 600 0';	 // makes "gibheart" model  behave like head-gibs (only spin around yaw)
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		{					 // --> gibs will NEVER disappear !!!
	 	new.nextthink = -1;
		}
	else 							// if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{						// --> gibs fade out
		new.alpha = 1;
		new.scale = 1;
		gibsfadetime = autocvar_gibsduration;
			if (autocvar_gibsexplode == 0)	// if 'gibsduration' is set via autoexec.cfg to '0'
				{
				new.think = gibsfade_noblood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
			else					// if 'gibsexplode' is set via autoexec.cfg to any other value than '1'
				{
				precache_sound ("player/gibexplode.wav");  
				new.think = gibsfade_blood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
		}
	new.frame = 0;
	new.flags = 0;
	
GibPhysics(new);
};


void () gib_heart_movement;
.float heartcounter;

void() gib_heart_stop_beating =
{
	local	float gibsfadetime;



	if ((autocvar_kickgibs == 1) && (!autocvar_eatablegibs))
		{
		self.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		self.touch = kick_touch_heart1_nobeating;      // Call kick_touch_heart1_nobeating when touched
		}
	else if (autocvar_eatablegibs)	 	  // "autocvar_eatablegibs" always overrides "autocvar_kickgibs" !!!
		{
		if (autocvar_eatablegibs)	
			{
			self.solid = SOLID_TRIGGER;   		// Set it up for a trigger event
			self.touch = eat_heart_gib_touch_nobeating;      		// Call eat_heart_gib_touch_nobeating when touched
			self.healamount = autocvar_eatable_heart_gib_healamount;	// default is 7
			}
		else 					// --> all gibs cannot be kicked or eat
			{					 
			self.solid = SOLID_TRIGGER;   	 	      // Set it up for a trigger event
			self.touch = kick_touch_heart2_nobeating;     // Call kick_touch_heart2_nobeating only when heart-gib interacts with liquids
			}
		}
	else 							// --> all gibs cannot be kicked or eat
		{					 
		self.solid = SOLID_TRIGGER;   	 	      // Set it up for a trigger event
		self.touch = kick_touch_heart2_nobeating;     // Call kick_touch_heart2_nobeating only when heart-gib interacts with liquids
		}

	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		{				 // --> gibs will NEVER disappear !!!
	 	self.nextthink = -1;
		}
	else 							// if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{						// --> gibs fade out
		gibsfadetime = autocvar_gibsduration;
			if (autocvar_gibsexplode == 0)		// if 'gibsduration' is set via autoexec.cfg to '0'
				{
				self.think = gibsfade_noblood;
				self.ltime = time;
				self.nextthink = time + gibsfadetime;
				}
			else					// if 'gibsexplode' is set via autoexec.cfg to any other value than '1'
				{
				precache_sound ("player/gibexplode.wav");  
				self.think = gibsfade_blood;
				self.ltime = time;
				self.nextthink = time + gibsfadetime;
				}
		}
};


void() gib_heart_movement2 = 		// scale the heart smaller
{
local float deadheart;
deadheart = autocvar_heartgiblifetime * 3;	// cvar 'heartgiblifetime' to adjust how long the heart beats  ;-)   default is 7 seconds.  Factor to convert from seconds for the function is approx. '3'
if (self.heartcounter >= deadheart)	
	{
	self.scale = 1; 
	self.traileffectnum = particleeffectnum("gib_heart_nobeating");
	precache_sound ("player/gibexplode.wav");  
	self.think = gib_heart_stop_beating;
	self.nextthink = time;
	return;
	}
if (self.scale > 0.92)
	{
	self.nextthink = time + 0.014;
	self.scale = self.scale - 0.007;    //frametime * 0.5; 
	self.think = gib_heart_movement2; 
	}
else
	{
	sound (self, CHAN_VOICE, "ambience/gibheartbeat.wav", 0.8, 3);	
	self.nextthink = time; //0.01;
	self.think = gib_heart_movement; 
	self.heartcounter = self.heartcounter + 1;
	}
};

void() gib_heart_movement =		// scale the heart bigger
{
if (self.scale < 1.08)
	{
	self.nextthink = time + 0.014;
	self.scale = self.scale + 0.007;   //frametime * 0.5; 	
	self.think = gib_heart_movement; 
	}
else
	{
	self.nextthink = time; //0.001;
	self.think = gib_heart_movement2; 
	self.heartcounter = self.heartcounter + 1;
	}
};


void(string gibname, float dm) ThrowHeart =
{
	local	entity new;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-position´s randomness
	new.origin = org;
	setmodel (new, gibname);
	setsize (new, '-16 -16 0', '16 16 48');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;

	if ((autocvar_kickgibs == 1) && (!autocvar_eatablegibs))
		{
		new.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		new.touch = kick_touch_heart1;      // Call kick_touch_heart1 when touched
		}
	else if (autocvar_eatablegibs)	 	// "autocvar_eatablegibs" always overrides "autocvar_kickgibs" !!!
		{
		if (autocvar_eatablegibs)	
			{
			new.solid = SOLID_TRIGGER;   		// Set it up for a trigger event
			new.touch = eat_heart_gib_touch;      	// Call eat_heart_gib_touch when touched
			new.healamount = autocvar_eatable_heart_gib_healamount;	// default is 5
			}
		}
	else 							// --> all gibs cannot be kicked or eat
		{					 
		new.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		new.touch = kick_touch_heart2;     // Call kick_touch_heart2 only when heart-gib interacts with liquids
		}

	new.avelocity = crandom() * '0 600 0';	 // make gibs behave like head-gibs (only spin around yaw)
	new.traileffectnum = particleeffectnum("gib_heart");
	new.scale = 1;
	new.alpha = 1;
	new.heartcounter = 0;
	new.nextthink = time + 0.1;  
	new.think = gib_heart_movement;
	new.frame = 0;
	new.flags = 0;
	
GibPhysics(new);
};


void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.cansplash = TRUE;		// create a splash when fall into liquid
	self.frame = 0;
	self.scale = 1;		// I had to decide whether gibs match the .scale value of killed monster or not. I chose not, as head gibs are always bigger than the "living" size head.
	if (autocvar_head_gibs_always_face_player)
	{
		self.nextthink = time + 2;
		self.think = head_gib_faceplayer;
	}
	else
		self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;


	if ((autocvar_kickgibs == 1) && (!autocvar_eatablegibs))
		{
		self.solid = SOLID_TRIGGER;    // Set it up for a trigger event
		self.touch = kick_touch2;     // Call kick_touch2 when touched
		}
	else if (autocvar_eatablegibs)	 	// "autocvar_eatablegibs" always overrides "autocvar_kickgibs" !!!
		{
		if (autocvar_eatablegibs >= 2)	// only eat head gibs when cvar is set to 2 or higher
			{
			self.solid = SOLID_TRIGGER;   		// Set it up for a trigger event
			self.touch = eat_head_gib_touch;      	// Call eat_head_gib_touch when touched
			self.healamount = autocvar_eatable_head_gib_healamount;	// default is 4
			}
		else 				// --> all gibs cannot be kicked or eat
			{					 
			self.solid = SOLID_TRIGGER;   // Set it up for a trigger event
			self.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
			}
		}
	else 							// --> all gibs cannot be kicked or eat
		{					 
		self.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		self.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
		}

	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
	
Gyro_Object_ClearPhysics(self);
GibPhysics(self);
};


void(vector org, vector vel, string debrisname) Throwdebris =
{
	local	entity debris;

	debris = spawn();
debris.cansplash = TRUE;					// so that debris will create a splash when fall into liquid
	setorigin(debris, org);
	setmodel (debris, debrisname);
	setsize (debris, '-16 -16 0', '16 16 48');
debris.traileffectnum = particleeffectnum("debris");	//  adds particle effect to debris (customize the effect in your effectinfo.txt)
	debris.velocity = vel + randomvec() * 25;  
	debris.movetype = MOVETYPE_BOUNCE;

	var float autocvar_kickdebris = 1;         // set cvar 'kickdebris' default to 1
	if (autocvar_kickdebris == 1)			 // if 'kickdebris' is set to '1'
		{
		debris.solid = SOLID_TRIGGER;   	// Set it up for a trigger event
		debris.touch = kick_touch4;      	// Call kick_touch4 when touched
		}
	else 							// if 'kickdebris' is set to any other value
		{						// --> all debris cannot be kicked
		debris.solid = SOLID_NOT;
		}

	debris.avelocity = crandom() * '0 600 0';	 // make debris only spin around yaw
	debris.alpha = 1;
	debris.scale = 1;
	self.nextthink = -1;
	debris.frame = 0;
	debris.flags = 0;
	
Gyro_Object_Activate(debris, 977);
};


void(vector org, vector vel, string gibname, float skintype) ThrowAfritGibs =
{
	local	entity afritgib;
	local	float gibsfadetime;

	afritgib = spawn();
	afritgib.cansplash = TRUE;					// so that afritgib will create a splash when fall into liquids
	setorigin(afritgib, org);
	setmodel (afritgib, gibname);
	setsize (afritgib, '0 0 0', '0 0 0');				//  temporary remove bbox to not hang in walls
	if (skintype)
		{
		afritgib.traileffectnum = particleeffectnum("Afrit_gib_grey");	//  adds particle effect to afritgib (customize the effect in your effectinfo.txt)
		afritgib.skin_type = 1;
		}
	else
		{
		afritgib.traileffectnum = particleeffectnum("Afrit_gib_red");	//  adds particle effect to afritgib (customize the effect in your effectinfo.txt)
		afritgib.skin_type = 0;
		}
	afritgib.velocity = vel + randomvec() * 25;  
	afritgib.velocity_z = afritgib.velocity_z + 100;
	afritgib.movetype = MOVETYPE_BOUNCE;

	local float zufall;
	zufall = random();		// randomize gib sizes
	    if (zufall > 0.8)  
	    	afritgib.scale = 0.8;
	    else if (zufall > 0.6)  
	    	afritgib.scale = 0.65;
	    else if (zufall > 0.4)  
	    	afritgib.scale = 0.5;
	    else if (zufall > 0.2) 
	    	afritgib.scale = 0.35;
	    else 
	    	afritgib.scale = 0.2;

	afritgib.alpha = 1;

	var float autocvar_kick_afrit_gibs = 0;        	// set cvar 'kick_afrit_gibs' default to 0
	if (autocvar_kick_afrit_gibs)		 	// if 'kick_afrit_gibs' is set via autoexec.cfg to any other value
		{
		afritgib.solid = SOLID_TRIGGER;		// Set it up for a trigger event
		afritgib.touch = kick_touch5temp;	// Call kick_touch5temp when touched
		}
	else 						// if 'kick_afrit_gibs' is 0
		{					// --> all gibs cannot be kicked
		afritgib.solid = SOLID_TRIGGER;    	// Set it up for a trigger event
		afritgib.touch = kick_touch6temp;	// Call kick_touch6temp only when gib interacts with liquids
		}

	afritgib.avelocity_x = crandom()*600;
	afritgib.avelocity_y = crandom()*600;
	afritgib.avelocity_z = crandom()*600;
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		   // if 'gibsduration' is set via autoexec.cfg to '0'
		{				   // --> gibs will NEVER disappear !!!
	 	afritgib.nextthink = -1;
		}
	else 					  // if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{				  // --> gibs fade out
		gibsfadetime = autocvar_gibsduration;
		afritgib.think = gibsfade_noblood;
		afritgib.ltime = time;
		afritgib.nextthink = time + gibsfadetime + random()*10;
		}

	afritgib.frame = 0;
	afritgib.flags = afritgib.flags - (afritgib.flags & FL_ONGROUND);
	
GibPhysics(afritgib);
};


void() GibPlayer =
{
	if (autocvar_player_model == 1)
		ThrowHead ("progs/h_player1.mdl", self.health);
	else if (autocvar_player_model == 2)
		ThrowHead ("progs/h_player2.mdl", self.health);
	else if (autocvar_player_model == 3)
		ThrowHead ("progs/h_player3.mdl", self.health);
	else if (autocvar_player_model == 4)
		ThrowHead ("progs/h_player4.mdl", self.health);
	else 
		ThrowHead ("progs/h_player.mdl", self.health);

	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
		ThrowHeart ("progs/gibheart.mdl", self.health);
	if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
		
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
};

void() PlayerDie =
{
	local	float	i;

if ((autocvar_chasecam_death_view) && (!cvar("chase_active")))
	{
	cvar_set ("chase_active", "1");
	cvar_set ("chase_back", "55");
	cvar_set ("chase_up", "70");
	cvar_set ("chase_overhead", "1");
	}

	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.modelindex = modelindex_player;	// don't use eyes

	if (deathmatch || coop)
		DropBackpack();
	
	self.weaponmodel="";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;

	if (self.health < -40)
	{
		GibPlayer ();
		return;
	}

	DeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
	if (self.weapon == IT_AXE)
	{
		player_die_ax1 ();
		return;
	}
	
	i = cvar("temp1");
	if (!i)
		i = 1 + floor(random()*6);
	
	if (i == 1)
		player_diea1();
	else if (i == 2)
		player_dieb1();
	else if (i == 3)
		player_diec1();
	else if (i == 4)
		player_died1();
	else
		player_diee1();

};

void() set_suicide_frame =
{	// used by klill command and diconnect command
	if ((self.model != "progs/player.mdl")||(self.model != "progs/player1.mdl")||(self.model != "progs/player2.mdl")||(self.model != "progs/player3.mdl")||(self.model != "progs/player4.mdl")||(self.model != "progs/player_shot.mdl")||(self.model != "progs/player_shot2.mdl")||(self.model != "progs/player_nail.mdl")||(self.model != "progs/player_nail2.mdl")||(self.model != "progs/player_rock.mdl")||(self.model != "progs/player_rock2.mdl")||(self.model != "progs/player_light.mdl"))
		return;	// allready gibbed
	self.frame = $deatha11;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};


void()	player_diea1	=	[	$deatha1,	player_diea2	] {};
void()	player_diea2	=	[	$deatha2,	player_diea3	] {};
void()	player_diea3	=	[	$deatha3,	player_diea4	] {};
void()	player_diea4	=	[	$deatha4,	player_diea5	] {};
void()	player_diea5	=	[	$deatha5,	player_diea6	] {};
void()	player_diea6	=	[	$deatha6,	player_diea7	] {};
void()	player_diea7	=	[	$deatha7,	player_diea8	] {};
void()	player_diea8	=	[	$deatha8,	player_diea9	] {};
void()	player_diea9	=	[	$deatha9,	player_diea10	] {};
void()	player_diea10	=	[	$deatha10,	player_diea11	] {};
void()	player_diea11	=	[	$deatha11,	player_diea11 ] {PlayerDead();};

void()	player_dieb1	=	[	$deathb1,	player_dieb2	] {};
void()	player_dieb2	=	[	$deathb2,	player_dieb3	] {};
void()	player_dieb3	=	[	$deathb3,	player_dieb4	] {};
void()	player_dieb4	=	[	$deathb4,	player_dieb5	] {};
void()	player_dieb5	=	[	$deathb5,	player_dieb6	] {};
void()	player_dieb6	=	[	$deathb6,	player_dieb7	] {};
void()	player_dieb7	=	[	$deathb7,	player_dieb8	] {};
void()	player_dieb8	=	[	$deathb8,	player_dieb9	] {};
void()	player_dieb9	=	[	$deathb9,	player_dieb9	] {PlayerDead();};

void()	player_diec1	=	[	$deathc1,	player_diec2	] {};
void()	player_diec2	=	[	$deathc2,	player_diec3	] {};
void()	player_diec3	=	[	$deathc3,	player_diec4	] {};
void()	player_diec4	=	[	$deathc4,	player_diec5	] {};
void()	player_diec5	=	[	$deathc5,	player_diec6	] {};
void()	player_diec6	=	[	$deathc6,	player_diec7	] {};
void()	player_diec7	=	[	$deathc7,	player_diec8	] {};
void()	player_diec8	=	[	$deathc8,	player_diec9	] {};
void()	player_diec9	=	[	$deathc9,	player_diec10	] {};
void()	player_diec10	=	[	$deathc10,	player_diec11	] {};
void()	player_diec11	=	[	$deathc11,	player_diec12	] {};
void()	player_diec12	=	[	$deathc12,	player_diec13	] {};
void()	player_diec13	=	[	$deathc13,	player_diec14	] {};
void()	player_diec14	=	[	$deathc14,	player_diec15	] {};
void()	player_diec15	=	[	$deathc15,	player_diec15 ] {PlayerDead();};

void()	player_died1	=	[	$deathd1,	player_died2	] {};
void()	player_died2	=	[	$deathd2,	player_died3	] {};
void()	player_died3	=	[	$deathd3,	player_died4	] {};
void()	player_died4	=	[	$deathd4,	player_died5	] {};
void()	player_died5	=	[	$deathd5,	player_died6	] {};
void()	player_died6	=	[	$deathd6,	player_died7	] {};
void()	player_died7	=	[	$deathd7,	player_died8	] {};
void()	player_died8	=	[	$deathd8,	player_died9	] {};
void()	player_died9	=	[	$deathd9,	player_died9	] {PlayerDead();};

void()	player_diee1	=	[	$deathe1,	player_diee2	] {};
void()	player_diee2	=	[	$deathe2,	player_diee3	] {};
void()	player_diee3	=	[	$deathe3,	player_diee4	] {};
void()	player_diee4	=	[	$deathe4,	player_diee5	] {};
void()	player_diee5	=	[	$deathe5,	player_diee6	] {};
void()	player_diee6	=	[	$deathe6,	player_diee7	] {};
void()	player_diee7	=	[	$deathe7,	player_diee8	] {};
void()	player_diee8	=	[	$deathe8,	player_diee9	] {};
void()	player_diee9	=	[	$deathe9,	player_diee9	] {PlayerDead();};

void()	player_die_ax1	=	[	$axdeth1,	player_die_ax2	] {};
void()	player_die_ax2	=	[	$axdeth2,	player_die_ax3	] {};
void()	player_die_ax3	=	[	$axdeth3,	player_die_ax4	] {};
void()	player_die_ax4	=	[	$axdeth4,	player_die_ax5	] {};
void()	player_die_ax5	=	[	$axdeth5,	player_die_ax6	] {};
void()	player_die_ax6	=	[	$axdeth6,	player_die_ax7	] {};
void()	player_die_ax7	=	[	$axdeth7,	player_die_ax8	] {};
void()	player_die_ax8	=	[	$axdeth8,	player_die_ax9	] {};
void()	player_die_ax9	=	[	$axdeth9,	player_die_ax9	] {PlayerDead();};
