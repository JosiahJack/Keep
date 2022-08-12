$cd id1/models/fish
$origin 0 0 24
$base base
$skin skin

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10 attack11 attack12 attack13
$frame attack14 attack15 attack16 attack17 attack18

$frame death1 death2 death3 death4 death5 death6 death7
$frame death8 death9 death10 death11 death12 death13 death14 death15
$frame death16 death17 death18 death19 death20 death21

$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8
$frame swim9 swim10 swim11 swim12 swim13 swim14 swim15 swim16 swim17
$frame swim18

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8
$frame pain9

void() swimmonster_start;

void() f_stand1  =[      $swim1, f_stand2 ] {ai_stand();};
void() f_stand2  =[      $swim2, f_stand3 ] {ai_stand();};
void() f_stand3  =[      $swim3, f_stand4 ] {ai_stand();};
void() f_stand4  =[      $swim4, f_stand5 ] {ai_stand();};
void() f_stand5  =[      $swim5, f_stand6 ] {ai_stand();};
void() f_stand6  =[      $swim6, f_stand7 ] {ai_stand();};
void() f_stand7  =[      $swim7, f_stand8 ] {ai_stand();};
void() f_stand8  =[      $swim8, f_stand9 ] {ai_stand();};
void() f_stand9  =[      $swim9, f_stand10  ] {ai_stand();};
void() f_stand10 =[      $swim10, f_stand11 ] {ai_stand();};
void() f_stand11 =[      $swim11, f_stand12 ] {ai_stand();};
void() f_stand12 =[      $swim12, f_stand13 ] {ai_stand();};
void() f_stand13 =[      $swim13, f_stand14 ] {ai_stand();};
void() f_stand14 =[      $swim14, f_stand15 ] {ai_stand();};
void() f_stand15 =[      $swim15, f_stand16 ] {ai_stand();};
void() f_stand16 =[      $swim16, f_stand17 ] {ai_stand();};
void() f_stand17 =[      $swim17, f_stand18 ] {ai_stand();};
void() f_stand18 =[      $swim18, f_stand1 ] {ai_stand();};

void() f_walk1  =[      $swim1, f_walk2 ] {ai_walk(8);};
void() f_walk2  =[      $swim2, f_walk3 ] {ai_walk(8);};
void() f_walk3  =[      $swim3, f_walk4 ] {ai_walk(8);};
void() f_walk4  =[      $swim4, f_walk5 ] {ai_walk(8);};
void() f_walk5  =[      $swim5, f_walk6 ] {ai_walk(8);};
void() f_walk6  =[      $swim6, f_walk7 ] {ai_walk(8);};
void() f_walk7  =[      $swim7, f_walk8 ] {ai_walk(8);};
void() f_walk8  =[      $swim8, f_walk9 ] {ai_walk(8);};
void() f_walk9  =[      $swim9, f_walk10  ] {ai_walk(8);};
void() f_walk10 =[      $swim10, f_walk11 ] {ai_walk(8);};
void() f_walk11 =[      $swim11, f_walk12 ] {ai_walk(8);};
void() f_walk12 =[      $swim12, f_walk13 ] {ai_walk(8);};
void() f_walk13 =[      $swim13, f_walk14 ] {ai_walk(8);};
void() f_walk14 =[      $swim14, f_walk15 ] {ai_walk(8);};
void() f_walk15 =[      $swim15, f_walk16 ] {ai_walk(8);};
void() f_walk16 =[      $swim16, f_walk17 ] {ai_walk(8);};
void() f_walk17 =[      $swim17, f_walk18 ] {ai_walk(8);};
void() f_walk18 =[      $swim18, f_walk1 ] {ai_walk(8);};

void() f_run1  =[      $swim1, f_run2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "fish/idle.wav", 1, ATTN_NORM);
};
void() f_run2  =[      $swim3, f_run3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run3  =[      $swim5, f_run4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run4  =[      $swim7, f_run5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run5  =[      $swim9, f_run6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run6  =[      $swim11, f_run7 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run7  =[      $swim13, f_run8 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run8  =[      $swim15, f_run9 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void() f_run9  =[      $swim17, f_run1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};

void() fish_melee =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

	sound (self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM);
	var float autocvar_fish_size_influenced_attack = 0; 				// set cvar 'fish_size_influenced_attack' default to 0
	if (autocvar_fish_size_influenced_attack == 1)					// if 'fish_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random()) * autocvar_fish_bite * self.scale;		// default 3
	else
		ldmg = (random() + random()) * autocvar_fish_bite;			// default 3
	T_Damage (self.enemy, self, self, ldmg);
};

void() f_attack1        =[      $attack1,       f_attack2 ] {ai_charge(10);};
void() f_attack2        =[      $attack2,       f_attack3 ] {ai_charge(10);};
void() f_attack3        =[      $attack3,       f_attack4 ] {fish_melee();};
void() f_attack4        =[      $attack4,       f_attack5 ] {ai_charge(10);};
void() f_attack5        =[      $attack5,       f_attack6 ] {ai_charge(10);};
void() f_attack6        =[      $attack6,       f_attack7 ] {ai_charge(10);};
void() f_attack7        =[      $attack7,       f_attack8 ] {ai_charge(10);};
void() f_attack8        =[      $attack8,       f_attack9 ] {ai_charge(10);};
void() f_attack9        =[      $attack9,       f_attack10] {fish_melee();};
void() f_attack10       =[      $attack10,      f_attack11] {ai_charge(10);};
void() f_attack11       =[      $attack11,      f_attack12] {ai_charge(10);};
void() f_attack12       =[      $attack12,      f_attack13] {ai_charge(10);};
void() f_attack13       =[      $attack13,      f_attack14] {ai_charge(10);};
void() f_attack14       =[      $attack14,      f_attack15] {ai_charge(10);};
void() f_attack15       =[      $attack15,      f_attack16] {fish_melee();};
void() f_attack16       =[      $attack16,      f_attack17] {ai_charge(10);};
void() f_attack17       =[      $attack17,      f_attack18] {ai_charge(10);};
void() f_attack18       =[      $attack18,      f_run1    ] {ai_charge(10);};

void() f_death1 =[      $death1,        f_death2        ] {
sound (self, CHAN_VOICE, "fish/death.wav", 1, ATTN_NORM);
};
void() f_death2 =[      $death2,        f_death3        ] {};
void() f_death3 =[      $death3,        f_death4        ] {};
void() f_death4 =[      $death4,        f_death5        ] {};
//MED 01/15/97 moved solid to here
void() f_death5 =[      $death5,        f_death6        ] {self.solid = SOLID_NOT;};
void() f_death6 =[      $death6,        f_death7        ] {};
void() f_death7 =[      $death7,        f_death8        ] {};
void() f_death8 =[      $death8,        f_death9        ] {};
void() f_death9 =[      $death9,        f_death10       ] {};
void() f_death10 =[      $death10,       f_death11       ] {};
void() f_death11 =[      $death11,       f_death12       ] {};
void() f_death12 =[      $death12,       f_death13       ] {};
void() f_death13 =[      $death13,       f_death14       ] {};
void() f_death14 =[      $death14,       f_death15       ] {};
void() f_death15 =[      $death15,       f_death16       ] {};
void() f_death16 =[      $death16,       f_death17       ] {};
void() f_death17 =[      $death17,       f_death18       ] {};
void() f_death18 =[      $death18,       f_death19       ] {};
void() f_death19 =[      $death19,       f_death20       ] {};
void() f_death20 =[      $death20,       f_death21       ] {};
//MED 01/15/97 removed solid from here
//void() f_death21 =[      $death21,       f_death21       ] {self.solid = SOLID_NOT;};
void() f_death21 =[      $death21,       f_death21       ] {};

//MED 01/15/97 added fish_die
void() fish_die =
{
// check for gib
   if (self.health < -20)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
      ThrowGib ("progs/gib1.mdl", self.health);
      ThrowGib ("progs/gib2.mdl", self.health);
      ThrowGib ("progs/gib3.mdl", self.health);
      self.think = SUB_Remove;
      self.nextthink= time + 0.1;
      return;
	}

// regular death
   f_death1 ();
};

void() f_pain1  =[      $pain1, f_pain2 ] {};
void() f_pain2  =[      $pain2, f_pain3 ] {ai_pain(6);};
void() f_pain3  =[      $pain3, f_pain4 ] {ai_pain(6);};
void() f_pain4  =[      $pain4, f_pain5 ] {ai_pain(6);};
void() f_pain5  =[      $pain5, f_pain6 ] {ai_pain(6);};
void() f_pain6  =[      $pain6, f_pain7 ] {ai_pain(6);};
void() f_pain7  =[      $pain7, f_pain8 ] {ai_pain(6);};
void() f_pain8  =[      $pain8, f_pain9 ] {ai_pain(6);};
void() f_pain9  =[      $pain9, f_run1 ] {ai_pain(6);};

void(entity attacker, float damage)	fish_pain =
{

// fish allways do pain frames
	f_pain1 ();
};



/*QUAKED monster_fish (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_fish =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/fish.mdl");

	precache_sound2 ("fish/death.wav");
	precache_sound2 ("fish/bite.wav");
	precache_sound2 ("fish/idle.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_fishmultiskin = 0;     	// set cvar 'fishmultiskin' default to 0
	local float zufall;
	if (autocvar_fishmultiskin == 1)		// if 'fishmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/fish.mdl");
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
	else if (autocvar_fishmultiskin == 2)	// if 'fishmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/fish1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/fish.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/fish1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_fishmultiskin == 3)	// if 'fishmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/fish1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/fish.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/fish.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/fish1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_fishmultiskin == 4)	// if 'fishmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/fish1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/fish.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/fish.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/fish1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/fish1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/fish.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_fish_size = 3;    	 	// set cvar 'fish_size' default to 3
	local float zuffa;
	if (autocvar_fish_size == 1)		// if 'fish_size' is set via autoexec.cfg to '1' give monster random size between 100% and 128% (14% steps due to small fish size)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			
		{			
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 24' - '0 0 3');
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 24' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 24');
		}
	}
	else if (autocvar_fish_size == 2)		// if 'fish_size' is set via autoexec.cfg to '2' give monster random size between 100% and 140% (14% steps due to small fish size)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)	
		{			
			self.scale = 1.42;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 24' - '0 0 5');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 24' - '0 0 3');
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 24' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 24');
		}
	}
	else if (autocvar_fish_size == 3)		// if 'fish_size' is set via autoexec.cfg to '3' give monster random size between 100% and 150% (14% steps due to small fish size)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)	
		{		
			self.scale = 1.56;
			setsize (self, '-16 -16 -24' - '0 0 7', '16 16 24' - '0 0 7');
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.42;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 24' - '0 0 5');
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 24' - '0 0 3');
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 24' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 24');
		}
	}
	else if (autocvar_fish_size == 4)		// if 'fish_size' is set via autoexec.cfg to '4' give monster random size between 100% and 170% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			
		{				
			self.scale = 1.70;
			setsize (self, '-16 -16 -24' - '0 0 9', '16 16 24' - '0 0 9');
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.56;
			setsize (self, '-16 -16 -24' - '0 0 7', '16 16 24' - '0 0 7');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.42;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 24' - '0 0 5');
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 24' - '0 0 3');
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 24' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 24');
		}
	}
	else if (autocvar_fish_size > 4)		// if 'fish_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_fish_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_fish_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_fish_size * 0.25;
		setsize (self, '-16 -16 -24' - self.sizefactor, '16 16 24' - self.sizefactor);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 24');
	}

var float autocvar_fish_size_influenced_health = 0; 		  		// set cvar 'fish_size_influenced_health' default to 0
	if (autocvar_fish_size_influenced_health == 1)				// if 'fish_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_fish_health + ((self.scale - 1) * 100);	// default: 25
	else
		self.health = autocvar_fish_health;				// default 25
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_fish_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
	{											// limit values to avoid extreme colors
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

	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
//MED 01/15/97 added fish death
//   self.th_die = f_death1;
   self.th_die = fish_die;
   self.th_pain = fish_pain;
	self.th_melee = f_attack1;
	
	self.alpha = autocvar_monstertransparency * 0.01;

var float autocvar_hydra_replace_fish = 30;		// set cvar 'hydra_replace_fish' default to 30  (= 30%).  Set the percentage of replacing the fish with a hydra (0= never.  100= always). Choose any value you want between 0 and 100
	if (autocvar_hydra_replace_fish)		// if fish shall be replaced by hydra. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_hydra_replace_fish * 0.01;
		if (random () <= replac)
			{
			var float autocvar_hydra_health = 75;		// set health value of the Hydras
			self.health = autocvar_hydra_health;		// default 75
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 24');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_hydra_start();
			return;
			}
		}

	swimmonster_start ();

do_the_cloning__fly_swim ();

var float autocvar_fishmass = 950;
MonsterPhysics (self, autocvar_fishmass);
};
