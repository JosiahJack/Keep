/*
==============================================================================

BLOB

==============================================================================
*/

$cd id1/models/tarbaby
$origin 0 0 24
$base base		

$skin skin

$frame walk1 walk2 walk3 walk4  walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame run1 run2 run3 run4 run5 run6  run7 run8 run9 run10 run11 run12 run13
$frame run14 run15 run16 run17 run18 run19 run20 run21 run22 run23
$frame run24 run25

$frame jump1 jump2 jump3 jump4 jump5 jump6

$frame fly1 fly2 fly3 fly4

$frame exp

void()	tbaby_stand1	=[	$walk1,		tbaby_stand1	] {ai_stand();};

void()	tbaby_hang1		=[	$walk1,		tbaby_hang1	] {ai_stand();};

void()	tbaby_walk1	=[	$walk1,		tbaby_walk2	] {ai_turn();};
void()	tbaby_walk2	=[	$walk2,		tbaby_walk3	] {ai_turn();};
void()	tbaby_walk3	=[	$walk3,		tbaby_walk4	] {ai_turn();};
void()	tbaby_walk4	=[	$walk4,		tbaby_walk5	] {ai_turn();};
void()	tbaby_walk5	=[	$walk5,		tbaby_walk6	] {ai_turn();};
void()	tbaby_walk6	=[	$walk6,		tbaby_walk7	] {ai_turn();};
void()	tbaby_walk7	=[	$walk7,		tbaby_walk8	] {ai_turn();};
void()	tbaby_walk8	=[	$walk8,		tbaby_walk9	] {ai_turn();};
void()	tbaby_walk9	=[	$walk9,		tbaby_walk10	] {ai_turn();};
void()	tbaby_walk10	=[	$walk10,		tbaby_walk11	] {ai_turn();};
void()	tbaby_walk11	=[	$walk11,		tbaby_walk12	] {ai_walk(2);};
void()	tbaby_walk12	=[	$walk12,		tbaby_walk13	] {ai_walk(2);};
void()	tbaby_walk13	=[	$walk13,		tbaby_walk14	] {ai_walk(2);};
void()	tbaby_walk14	=[	$walk14,		tbaby_walk15	] {ai_walk(2);};
void()	tbaby_walk15	=[	$walk15,		tbaby_walk16	] {ai_walk(2);};
void()	tbaby_walk16	=[	$walk16,		tbaby_walk17	] {ai_walk(2);};
void()	tbaby_walk17	=[	$walk17,		tbaby_walk18	] {ai_walk(2);};
void()	tbaby_walk18	=[	$walk18,		tbaby_walk19	] {ai_walk(2);};
void()	tbaby_walk19	=[	$walk19,		tbaby_walk20	] {ai_walk(2);};
void()	tbaby_walk20	=[	$walk20,		tbaby_walk21	] {ai_walk(2);};
void()	tbaby_walk21	=[	$walk21,		tbaby_walk22	] {ai_walk(2);};
void()	tbaby_walk22	=[	$walk22,		tbaby_walk23	] {ai_walk(2);};
void()	tbaby_walk23	=[	$walk23,		tbaby_walk24	] {ai_walk(2);};
void()	tbaby_walk24	=[	$walk24,		tbaby_walk25	] {ai_walk(2);};
void()	tbaby_walk25	=[	$walk25,		tbaby_walk1	] {ai_walk(2);};

void()	tbaby_run1	=[	$run1,		tbaby_run2	] {ai_face();};
void()	tbaby_run2	=[	$run2,		tbaby_run3	] {ai_face();};
void()	tbaby_run3	=[	$run3,		tbaby_run4	] {ai_face();};
void()	tbaby_run4	=[	$run4,		tbaby_run5	] {ai_face();};
void()	tbaby_run5	=[	$run5,		tbaby_run6	] {ai_face();};
void()	tbaby_run6	=[	$run6,		tbaby_run7	] {ai_face();};
void()	tbaby_run7	=[	$run7,		tbaby_run8	] {ai_face();};
void()	tbaby_run8	=[	$run8,		tbaby_run9	] {ai_face();};
void()	tbaby_run9	=[	$run9,		tbaby_run10	] {ai_face();};
void()	tbaby_run10	=[	$run10,		tbaby_run11	] {ai_face();};
void()	tbaby_run11	=[	$run11,		tbaby_run12	] {ai_run(2);};
void()	tbaby_run12	=[	$run12,		tbaby_run13	] {ai_run(2);};
void()	tbaby_run13	=[	$run13,		tbaby_run14	] {ai_run(2);};
void()	tbaby_run14	=[	$run14,		tbaby_run15	] {ai_run(2);};
void()	tbaby_run15	=[	$run15,		tbaby_run16	] {ai_run(2);};
void()	tbaby_run16	=[	$run16,		tbaby_run17	] {ai_run(2);};
void()	tbaby_run17	=[	$run17,		tbaby_run18	] {ai_run(2);};
void()	tbaby_run18	=[	$run18,		tbaby_run19	] {ai_run(2);};
void()	tbaby_run19	=[	$run19,		tbaby_run20	] {ai_run(2);};
void()	tbaby_run20	=[	$run20,		tbaby_run21	] {ai_run(2);};
void()	tbaby_run21	=[	$run21,		tbaby_run22	] {ai_run(2);};
void()	tbaby_run22	=[	$run22,		tbaby_run23	] {ai_run(2);};
void()	tbaby_run23	=[	$run23,		tbaby_run24	] {ai_run(2);};
void()	tbaby_run24	=[	$run24,		tbaby_run25	] {ai_run(2);};
void()	tbaby_run25	=[	$run25,		tbaby_run1	] {ai_run(2);};


//============================================================================


void()	tbaby_jump1;

void()	Tar_JumpTouch =
{
	local	float	ldmg;

	if (other.takedamage && other.classname != self.classname)
	{
		if ( vlen(self.velocity) > 400 )
		{
			var float autocvar_tarbaby_size_influenced_attack = 0; 			// set cvar 'tarbaby_size_influenced_attack' default to 0
			if (autocvar_tarbaby_size_influenced_attack == 1)			// if 'tarbaby_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
				ldmg = (autocvar_tarbaby_jump * self.scale) + 10*random();	// default 10
			else
				ldmg = autocvar_tarbaby_jump + 10*random();		// default 10
			T_Damage (other, self, self, ldmg);	
			sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM);
		}
	}
	else
		sound (self, CHAN_WEAPON, "blob/land1.wav", 1, ATTN_NORM);


	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = tbaby_run1;
	self.movetype = MOVETYPE_STEP;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		if (self.origin == self.old_origin)
		{
			self.touch = SUB_Null;
			self.flags = self.flags & FL_ONGROUND;
			makevectors (self.angles);
			self.velocity = (v_forward * (random() - 0.5) * 500) + '0 0 200';
			self.think = tbaby_jump1;
			self.nextthink = time + 0.2;
		}
		self.old_origin = self.origin;
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = tbaby_jump1;
	self.nextthink = time + 0.1;
};

void()	tbaby_jump5;

void()	tbaby_fly1		=[	$fly1,	tbaby_fly2	] {};
void()	tbaby_fly2		=[	$fly2,	tbaby_fly3	] {};
void()	tbaby_fly3		=[	$fly3,	tbaby_fly4	] {};
void()	tbaby_fly4		=[	$fly4,	tbaby_fly1	] {
self.cnt = self.cnt + 1;
if (self.cnt == 4)
{
//dprint ("spawn hop\n");
tbaby_jump5 ();
}
};

void()	tbaby_jump1		=[	$jump1,	tbaby_jump2		] {ai_face();self.colormod = '1 1 1.3';};
void()	tbaby_jump2		=[	$jump2,	tbaby_jump3		] {ai_face();self.colormod = '1 1 1.6';};
void()	tbaby_jump3		=[	$jump3,	tbaby_jump4		] {ai_face();self.colormod = '1 1 1.9';};
void()	tbaby_jump4		=[	$jump4,	tbaby_jump5		] {ai_face();self.colormod = '1 1 2.1';};
void()	tbaby_jump5		=[	$jump5,	tbaby_jump6		]
{	
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Tar_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random()*150;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.cnt = 0;
};
void()	tbaby_jump6	=[	$jump6,tbaby_fly1	] {self.colormod = '1 1 2.5';};



//=============================================================================

void()	tbaby_die1	=[	$exp,		tbaby_die2	] {
gibbed_monsters = gibbed_monsters + 1;
self.takedamage = DAMAGE_NO;
};
void()	tbaby_die2	=[	$exp,		tbaby_run1	] 
{
	if ((!cvar("chase_active")) && (self.enemy.classname == "player") && (autocvar_HUD_blood_splatter))	// we are in 1st person mode
	{
		if (vlen (self.enemy.origin - self.origin) < autocvar_HUD_blood_splatter)
			blood_HUD_splat = 1;
	}
	var float autocvar_tarbaby_size_influenced_attack = 0; 			// set cvar 'tarbaby_size_influenced_attack' default to 0
	if (autocvar_tarbaby_size_influenced_attack == 1)			// if 'tarbaby_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		T_RadiusDamage (self, self, autocvar_tarbaby_explode * self.scale, world);	// default 120
	else
		T_RadiusDamage (self, self, autocvar_tarbaby_explode, world);		// default 120

	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion ();
};

//=============================================================================


/*QUAKED monster_tarbaby (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_tarbaby =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/tarbaby.mdl");

	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_tarbabymultiskin = 0;     	// set cvar 'tarbabymultiskin' default to 0
	local float zufall;
	if (autocvar_tarbabymultiskin == 1)		// if 'tarbabymultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/tarbaby.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
	}
	else if (autocvar_tarbabymultiskin == 2)	// if 'tarbabymultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/tarbaby1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/tarbaby.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/tarbaby1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_tarbabymultiskin == 3)	// if 'tarbabymultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/tarbaby1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/tarbaby.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/tarbaby.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/tarbaby1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_tarbabymultiskin == 4)	// if 'tarbabymultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/tarbaby1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/tarbaby.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/tarbaby.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/tarbaby1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/tarbaby1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/tarbaby.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_tarbaby_size = 3;     	// set cvar 'tarbaby_size' default to 3
	local float zuffa;
	if (autocvar_tarbaby_size == 1)		// if 'tarbaby_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_tarbaby_size == 2)		// if 'tarbaby_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 40' - '0 0 5');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_tarbaby_size == 3)		// if 'tarbaby_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 7', '16 16 40' - '0 0 7');
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 40' - '0 0 5');
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_tarbaby_size == 4)		// if 'tarbaby_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			setsize (self, '-16 -16 -24' - '0 0 9', '16 16 40' - '0 0 9');
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 7', '16 16 40' - '0 0 7');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 40' - '0 0 5');
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_tarbaby_size > 4)		// if 'tarbaby_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_tarbaby_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_tarbaby_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_tarbaby_size * 0.25;
		setsize (self, '-16 -16 -24' - self.sizefactor, '16 16 40' - self.sizefactor);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 40');
	}

var float autocvar_tarbaby_size_influenced_health = 0; 		  			// set cvar 'tarbaby_size_influenced_health' default to 0
	if (autocvar_tarbaby_size_influenced_health == 1)				// if 'tarbaby_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_tarbaby_health + ((self.scale - 1) * 100);	// default: 80
	else
		self.health = autocvar_tarbaby_health;			// default 80
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_tarbaby_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
	{												// limit values to avoid extreme colors
		self.colormod_x = random ();
		if (self.colormod_x < 0.5)
			self.colormod_x = self.colormod_x + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_x < 0.75)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_x < 0.65)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_x < 0.55)
				self.colormod_x = self.colormod_x + 0.25;
		}
		self.colormod_y = random ();
		if (self.colormod_y < 0.5)
			self.colormod_y = self.colormod_y + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_y < 0.75)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_y < 0.65)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_y < 0.55)
				self.colormod_y = self.colormod_y + 0.25;
		}
		self.colormod_z = random ();
		if (self.colormod_z < 0.5)
			self.colormod_z = self.colormod_z + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_z < 0.75)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_z < 0.65)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_z < 0.55)
				self.colormod_z = self.colormod_z + 0.25;
		}
	}

	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1; 
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;
	
	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_spider_replace_tarbaby)		// if tarbaby shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_tarbaby * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 3;
				self.health = autocvar_tarbaby_health;		// default 80
				self.scale = 1;
				setsize (self, '-16 -16 -24', '16 16 40');
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_tarbaby)		// if tarbaby shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_tarbaby * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_tarbaby_health;		// default 80
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_tarbaby)		// if tarbaby shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_tarbaby * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_tarbaby_health;		// default 80
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

	walkmonster_start ();

do_the_cloning();

if (autocvar_reiver_supports_tarbaby)		// if reiver shall be spawned in ADDITION to an existing tarbaby. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_tarbaby * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_tarbaby)		// if afrit shall be spawned in ADDITION to an existing tarbaby. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_tarbaby * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_tarbabymass = 2500;
MonsterPhysics (self, autocvar_tarbabymass);	
};

