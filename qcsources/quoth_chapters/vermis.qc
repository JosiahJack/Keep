

/*
==============================================================================

Vermis

==============================================================================
*/
$cd id1/models/vermis
$origin 0 0 24
$base base
$skin skin
$scale 1

$frame base0
$frame base

$frame wake1 wake2 wake3 wake4 wake5 wake6 wake7 wake8 wake9 
$frame wake10 wake11 wake12 wake13 wake14 wake15 wake16 wake17 wake18 wake19 
$frame wake20 wake21 wake22 wake23 wake24 wake25 wake26 wake27 wake28 wake29 
$frame wake30 wake31 wake32 wake33 wake34 wake35 wake36 wake37 wake38 wake39 
$frame wake40 wake41 wake42 wake43 wake44 wake45 wake46 wake47 wake48 wake49 
$frame wake50

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 
$frame idle10 idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 
$frame idle20 idle21 idle22 idle23 idle24 idle25 idle26 idle27 idle28 idle29 
$frame idle30 idle31 idle32 idle33 idle34 idle35 idle36 idle37 idle38 idle39 
$frame idle40

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 
$frame run10 run11 run12 run13 run14 run15 run16 run17 run18 run19 
$frame run20 run21 run22 run23 run24 run25 run26 run27 run28 run29 
$frame run30

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9 
$frame shoot10 shoot11 shoot12 shoot13 shoot14 shoot15 shoot16 shoot17 shoot18 shoot19 
$frame shoot20

$frame grab1 grab2 grab3 grab4 grab5 grab6 grab7 grab8 grab9 
$frame grab10 grab11 grab12 grab13 grab14 grab15 grab16 grab17 grab18 grab19 
$frame grab20

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 
$frame death10 death11 death12 death13 death14 death15 death16 death17 death18 death19 
$frame death20 death21 death22 death23 death24 death25 death26 death27 death28 death29 
$frame death30 death31 death32 death33 death34 death35 death36 death37 death38 death39 
$frame death40 death41 death42 death43 death44 death45 death46 death47 death48 death49 
$frame death50

$frame trans1 trans2 trans3 trans4 trans5

$frame grabmis1 grabmis2

//$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
//$frame shake9 shake10 shake11 shake12 shake12 shake13 shake14
//$frame shake15 shake16 shake17 shake18 shake19 shake20

//void() old_stand     =[      $old1,       old_stand    ] {};

void() vermis_touch =
{
	local	vector	dir;
	
	if (other.classname == "player")
	{
		//bprint ("touching vermis\n");
		//dir = other.origin - (self.absmin + self.absmax) * 0.5;
		//dir = normalize(dir);
		//if (other.flags & FL_ONGROUND)
		//	other.flags = other.flags - FL_ONGROUND;
		//other.velocity = other.velocity + '0 0 500';//dir*500;
		T_Damage (other, self, self, (3 + 2 * random()));
		self.touch = SUB_Null;
	}
};

void() vermis_wake_things =
{
	self.spawnmaxs_z = self.spawnmaxs_z + self.height;
	setsize (self, '-64 -64 -512', self.spawnmaxs);
	self.touch = vermis_touch;
};


void() vermis_coil1        =[      $wake1,  vermis_coil1       ] {self.height = 8;};

void() vermis_wake1        =[      $wake1,  vermis_wake2       ] {ai_vermis_face();self.spawnmaxs = '64 64 -64'; setsize (self, '-64 -64 -512', self.spawnmaxs);self.touch = vermis_touch;};
void() vermis_wake2        =[      $wake2,  vermis_wake3       ] {ai_vermis_face();vermis_wake_things();self.coiled = 0;};
void() vermis_wake3        =[      $wake3,  vermis_wake4       ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake4        =[      $wake4,  vermis_wake5       ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake5        =[      $wake5,  vermis_wake6       ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake6        =[      $wake6,  vermis_wake7       ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake7        =[      $wake7,  vermis_wake8       ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake8        =[      $wake8,  vermis_wake9       ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake9        =[      $wake9,  vermis_wake10      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake10       =[      $wake10, vermis_wake11      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake11       =[      $wake11, vermis_wake12      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake12       =[      $wake12, vermis_wake13      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake13       =[      $wake13, vermis_wake14      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake14       =[      $wake14, vermis_wake15      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake15       =[      $wake15, vermis_wake16      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake16       =[      $wake16, vermis_wake17      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake17       =[      $wake17, vermis_wake18      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake18       =[      $wake18, vermis_wake19      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake19       =[      $wake19, vermis_wake20      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake20       =[      $wake20, vermis_wake21      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake21       =[      $wake21, vermis_wake22      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake22       =[      $wake22, vermis_wake23      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake23       =[      $wake23, vermis_wake24      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake24       =[      $wake24, vermis_wake25      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake25       =[      $wake25, vermis_wake26      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake26       =[      $wake26, vermis_wake27      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake27       =[      $wake27, vermis_wake28      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake28       =[      $wake28, vermis_wake29      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake29       =[      $wake29, vermis_wake30      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake30       =[      $wake30, vermis_wake31      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake31       =[      $wake31, vermis_wake32      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake32       =[      $wake32, vermis_wake33      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake33       =[      $wake33, vermis_wake34      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake34       =[      $wake34, vermis_wake35      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake35       =[      $wake35, vermis_wake36      ] {ai_vermis_face();vermis_wake_things();};
void() vermis_wake36       =[      $wake36, vermis_wake37      ] {ai_vermis_face();};
void() vermis_wake37       =[      $wake37, vermis_wake38      ] {ai_vermis_face();};
void() vermis_wake38       =[      $wake38, vermis_wake39      ] {ai_vermis_face();};
void() vermis_wake39       =[      $wake39, vermis_wake40      ] {ai_vermis_face();};
void() vermis_wake40       =[      $wake40, vermis_wake41      ] {ai_vermis_face();};
void() vermis_wake41       =[      $wake41,  vermis_wake42     ] {ai_vermis_face();};
void() vermis_wake42       =[      $wake42,  vermis_wake43     ] {ai_vermis_face();};
void() vermis_wake43       =[      $wake43,  vermis_wake44     ] {ai_vermis_face();};
void() vermis_wake44       =[      $wake44,  vermis_wake45     ] {ai_vermis_face();};
void() vermis_wake45       =[      $wake45,  vermis_wake46     ] {ai_vermis_face();};
void() vermis_wake46       =[      $wake46,  vermis_wake47     ] {ai_vermis_face();};
void() vermis_wake47       =[      $wake47,  vermis_wake48     ] {ai_vermis_face();};
void() vermis_wake48       =[      $wake48,  vermis_wake49     ] {ai_vermis_face();};
void() vermis_wake49       =[      $wake49,  vermis_wake50     ] {self.th_stand = vermis_idle1;};
void() vermis_wake50       =[      $wake50, vermis_run1        ] {ai_vermis_face();self.touch = SUB_Null;};





void() vermis_trans1        =[      $trans1,  vermis_trans2       ] {ai_vermis_face();};
void() vermis_trans2        =[      $trans2,  vermis_trans3       ] {ai_vermis_face();};
void() vermis_trans3        =[      $trans3,  vermis_trans4       ] {ai_vermis_face();};
void() vermis_trans4        =[      $trans4,  vermis_trans5       ] {ai_vermis_face();};
void() vermis_trans5        =[      $trans5,  vermis_trans21      ] {ai_vermis_face();};
void() vermis_trans21       =[      $wake21,  vermis_trans22      ] {ai_vermis_face();};
void() vermis_trans22       =[      $wake22,  vermis_trans23      ] {ai_vermis_face();};
void() vermis_trans23       =[      $wake23,  vermis_trans24      ] {ai_vermis_face();};
void() vermis_trans24       =[      $wake24,  vermis_trans25      ] {ai_vermis_face();};
void() vermis_trans25       =[      $wake25,  vermis_trans26      ] {ai_vermis_face();};
void() vermis_trans26       =[      $wake26,  vermis_trans27      ] {ai_vermis_face();};
void() vermis_trans27       =[      $wake27,  vermis_trans28      ] {ai_vermis_face();};
void() vermis_trans28       =[      $wake28,  vermis_trans29      ] {ai_vermis_face();};
void() vermis_trans29       =[      $wake29,  vermis_trans30      ] {ai_vermis_face();};
void() vermis_trans30       =[      $wake30,  vermis_trans31      ] {ai_vermis_face();};
void() vermis_trans31       =[      $wake31,  vermis_trans32      ] {ai_vermis_face();};
void() vermis_trans32       =[      $wake32,  vermis_trans33      ] {ai_vermis_face();};
void() vermis_trans33       =[      $wake33,  vermis_trans34      ] {ai_vermis_face();};
void() vermis_trans34       =[      $wake34,  vermis_trans35      ] {ai_vermis_face();};
void() vermis_trans35       =[      $wake35,  vermis_trans36      ] {ai_vermis_face();};
void() vermis_trans36       =[      $wake36,  vermis_trans37      ] {ai_vermis_face();};
void() vermis_trans37       =[      $wake37,  vermis_trans38      ] {ai_vermis_face();};
void() vermis_trans38       =[      $wake38,  vermis_trans39      ] {ai_vermis_face();};
void() vermis_trans39       =[      $wake39,  vermis_trans40      ] {ai_vermis_face();};
void() vermis_trans40       =[      $wake40,  vermis_trans41      ] {ai_vermis_face();};
void() vermis_trans41       =[      $wake41,  vermis_trans42      ] {ai_vermis_face();};
void() vermis_trans42       =[      $wake42,  vermis_trans43      ] {ai_vermis_face();};
void() vermis_trans43       =[      $wake43,  vermis_trans44      ] {ai_vermis_face();};
void() vermis_trans44       =[      $wake44,  vermis_trans45      ] {ai_vermis_face();};
void() vermis_trans45       =[      $wake45,  vermis_trans46      ] {ai_vermis_face();};
void() vermis_trans46       =[      $wake46,  vermis_trans47      ] {ai_vermis_face();};
void() vermis_trans47       =[      $wake47,  vermis_trans48      ] {ai_vermis_face();};
void() vermis_trans48       =[      $wake48,  vermis_trans49      ] {ai_vermis_face();};
void() vermis_trans49       =[      $wake49,  vermis_trans50      ] {ai_vermis_face();self.th_stand = vermis_idle1;};
void() vermis_trans50       =[      $wake50,  vermis_run1         ] {ai_vermis_face();};



void() vermis_idle1        =[      $idle1,  vermis_idle2       ] {ai_vermis_stand();};
void() vermis_idle2        =[      $idle2,  vermis_idle3       ] {ai_vermis_stand();};
void() vermis_idle3        =[      $idle3,  vermis_idle4       ] {ai_vermis_stand();};
void() vermis_idle4        =[      $idle4,  vermis_idle5       ] {ai_vermis_stand();};
void() vermis_idle5        =[      $idle5,  vermis_idle6       ] {ai_vermis_stand();};
void() vermis_idle6        =[      $idle6,  vermis_idle7       ] {ai_vermis_stand();};
void() vermis_idle7        =[      $idle7,  vermis_idle8       ] {ai_vermis_stand();};
void() vermis_idle8        =[      $idle8,  vermis_idle9       ] {ai_vermis_stand();};
void() vermis_idle9        =[      $idle9,  vermis_idle10      ] {ai_vermis_stand();};
void() vermis_idle10       =[      $idle10, vermis_idle11      ] {ai_vermis_stand();};
void() vermis_idle11       =[      $idle11, vermis_idle12      ] {ai_vermis_stand();};
void() vermis_idle12       =[      $idle12, vermis_idle13      ] {ai_vermis_stand();};
void() vermis_idle13       =[      $idle13, vermis_idle14      ] {ai_vermis_stand();};
void() vermis_idle14       =[      $idle14, vermis_idle15      ] {ai_vermis_stand();};
void() vermis_idle15       =[      $idle15, vermis_idle16      ] {ai_vermis_stand();};
void() vermis_idle16       =[      $idle16, vermis_idle17      ] {ai_vermis_stand();};
void() vermis_idle17       =[      $idle17, vermis_idle18      ] {ai_vermis_stand();};
void() vermis_idle18       =[      $idle18, vermis_idle19      ] {ai_vermis_stand();};
void() vermis_idle19       =[      $idle19, vermis_idle20      ] {ai_vermis_stand();};
void() vermis_idle20       =[      $idle20, vermis_idle21      ] {ai_vermis_stand();};
void() vermis_idle21       =[      $idle19, vermis_idle22      ] {ai_vermis_stand();};
void() vermis_idle22       =[      $idle18, vermis_idle23      ] {ai_vermis_stand();};
void() vermis_idle23       =[      $idle17, vermis_idle24      ] {ai_vermis_stand();};
void() vermis_idle24       =[      $idle16, vermis_idle25      ] {ai_vermis_stand();};
void() vermis_idle25       =[      $idle15, vermis_idle26      ] {ai_vermis_stand();};
void() vermis_idle26       =[      $idle14, vermis_idle27      ] {ai_vermis_stand();};
void() vermis_idle27       =[      $idle13, vermis_idle28      ] {ai_vermis_stand();};
void() vermis_idle28       =[      $idle12, vermis_idle29      ] {ai_vermis_stand();};
void() vermis_idle29       =[      $idle11, vermis_idle30      ] {ai_vermis_stand();};
void() vermis_idle30       =[      $idle10, vermis_idle31      ] {ai_vermis_stand();};
void() vermis_idle31       =[      $idle9, vermis_idle32      ] {ai_vermis_stand();};
void() vermis_idle32       =[      $idle8, vermis_idle33      ] {ai_vermis_stand();};
void() vermis_idle33       =[      $idle7, vermis_idle34      ] {ai_vermis_stand();};
void() vermis_idle34       =[      $idle6, vermis_idle35      ] {ai_vermis_stand();};
void() vermis_idle35       =[      $idle5, vermis_idle36      ] {ai_vermis_stand();};
void() vermis_idle36       =[      $idle4, vermis_idle37      ] {ai_vermis_stand();};
void() vermis_idle37       =[      $idle3, vermis_idle38      ] {ai_vermis_stand();};
void() vermis_idle38       =[      $idle2, vermis_idle1       ] {ai_vermis_stand();};
//void() vermis_idle39       =[      $idle1, vermis_idle40      ] {ai_vermis_stand();};
//void() vermis_idle40       =[      $idle0, vermis_idle1       ] {ai_vermis_stand();};






void() vermis_run1        =[      $run1,  vermis_run2       ] {ai_vermis_run();};
void() vermis_run2        =[      $run2,  vermis_run3       ] {ai_vermis_run();};
void() vermis_run3        =[      $run3,  vermis_run4       ] {ai_vermis_run();};
void() vermis_run4        =[      $run4,  vermis_run5       ] {ai_vermis_run();};
void() vermis_run5        =[      $run5,  vermis_run6       ] {ai_vermis_run();};
void() vermis_run6        =[      $run6,  vermis_run7       ] {ai_vermis_run();};
void() vermis_run7        =[      $run7,  vermis_run8       ] {ai_vermis_run();};
void() vermis_run8        =[      $run8,  vermis_run9       ] {ai_vermis_run();};
void() vermis_run9        =[      $run9,  vermis_run10      ] {ai_vermis_run();};
void() vermis_run10       =[      $run10, vermis_run11      ] {ai_vermis_run();};
void() vermis_run11       =[      $run11, vermis_run12      ] {ai_vermis_run();};
void() vermis_run12       =[      $run12, vermis_run13      ] {ai_vermis_run();};
void() vermis_run13       =[      $run13, vermis_run14      ] {ai_vermis_run();};
void() vermis_run14       =[      $run14, vermis_run15      ] {ai_vermis_run();};
void() vermis_run15       =[      $run15, vermis_run16      ] {ai_vermis_run();};
void() vermis_run16       =[      $run16, vermis_run17      ] {ai_vermis_run();};
void() vermis_run17       =[      $run17, vermis_run18      ] {ai_vermis_run();};
void() vermis_run18       =[      $run18, vermis_run19      ] {ai_vermis_run();};
void() vermis_run19       =[      $run19, vermis_run20      ] {ai_vermis_run();};
void() vermis_run20       =[      $run20, vermis_run21      ] {ai_vermis_run();};
void() vermis_run21       =[      $run21, vermis_run22      ] {ai_vermis_run();};
void() vermis_run22       =[      $run22, vermis_run23      ] {ai_vermis_run();};
void() vermis_run23       =[      $run23, vermis_run24      ] {ai_vermis_run();};
void() vermis_run24       =[      $run24, vermis_run25      ] {ai_vermis_run();};
void() vermis_run25       =[      $run25, vermis_run26      ] {ai_vermis_run();};
void() vermis_run26       =[      $run26, vermis_run27      ] {ai_vermis_run();};
void() vermis_run27       =[      $run27, vermis_run28      ] {ai_vermis_run();};
void() vermis_run28       =[      $run28, vermis_run29      ] {ai_vermis_run();};
void() vermis_run29       =[      $run29, vermis_run30      ] {ai_vermis_run();};
void() vermis_run30       =[      $run30, vermis_run1       ] {ai_vermis_run();};


void() vermis_spore_explode =
{
	T_WeakRadiusDamage (self, self.owner, 55, other);
	if (other)
		T_Damage (other, self, self.owner, (24 + 2 * random()));
	sound (self, CHAN_VOICE, "vermis/pop.wav", 0.6, 1.5);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	//setmodel (self, "progs/s_explod.spr");
	//self.solid = SOLID_NOT;
	//s_explode1 ();
	SUB_Remove();
};

void() vermis_spore_touch =
{
	local	float	rndsnd;
	
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		vermis_spore_explode();
		return;
	}
	rndsnd = random();
	
	if (rndsnd < 0.33)
		sound (self, CHAN_VOICE, "vermis/splash1.wav", 1, 1.7);	// bounce sound
	else if (rndsnd < 0.66)
		sound (self, CHAN_VOICE, "vermis/splash2.wav", 1, 1.7);	// bounce sound
	else
		sound (self, CHAN_VOICE, "vermis/splash3.wav", 1, 1.7);	// bounce sound
	
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
	
	if (self.lip == 0)
	{
		self.ltime = time + 0.3 + 0.4 * random();
		self.movetype = MOVETYPE_BOUNCE;
	}
	self.lip = 1;
	
};


void() vermis_spore_think =
{
	if (self.ltime < time)
		vermis_spore_explode();

	self.nextthink = time + 0.1;
	self.think = vermis_spore_think;
};

void(float xoff, float yoff, float zoff) vermis_shoot =
{
	local	entity missile, mpuff;
	local	vector	org;
	local	float	t;
	local	vector	d, vec;
	local	float	dist;
	local	float	numspores;
	
	if (visible(self.enemy))
		dist = vlen(self.enemy.origin - self.origin);
	else
		dist = vlen(self.oldenemyorigin - self.origin);
	
	if (dist < 450)
		numspores = 5;
	else if (dist < 800)
		numspores = 8;
	else
		numspores = 13;
	
	if (numspores == 0)
		numspores = 1;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	while (numspores > 0)
	{

		missile = spawn ();
		missile.owner = self;
		missile.movetype = MOVETYPE_FLYMISSILE;
		missile.solid = SOLID_BBOX;
		
		// set missile speed	

		makevectors (self.angles);

	
		org = self.origin + v_right * xoff + v_forward * yoff + v_up * zoff;

		
		
		if (visible(self.enemy))
		{
			//missile.velocity = normalize(self.enemy.origin - org);
			
			//chthon leading code
			t = vlen(self.enemy.origin - org) / 1800;  //600.  higher numbers decrease accuracy.  600 was dead on accurate.
			vec = self.enemy.velocity;
			vec_z = 0;
			d = self.enemy.origin + t * vec;		
	
			vec = normalize (d - org);		
			missile.velocity = vec;
		
		}
		else
		{
			missile.velocity = normalize(self.oldenemyorigin - org);
		}
		missile.velocity = missile.velocity * 600 + ((400 * random() - 200) * v_right) + ((300 * random() - 150) * v_up);
		//missile.velocity_z = 80;
	
		missile.avelocity = '297 324 333';
	
		missile.angles = vectoangles(missile.velocity);
		
		missile.touch = vermis_spore_touch;
		
	// set missile duration
		missile.nextthink = time + 0.1;
		missile.think = vermis_spore_think;
		missile.ltime = time + 2;
	
		setmodel (missile, "progs/spore.mdl");
		setsize (missile, '0 0 0', '0 0 0');		
		setorigin (missile, org);
		numspores = numspores - 1;
	}
};


void() vermis_shoot1        =[      $shoot1,  vermis_shoot2       ] {ai_vermis_face();ai_shotcheck();sound (self, CHAN_WEAPON, "vermis/spore.wav", 1, 0.5);};
void() vermis_shoot2        =[      $shoot2,  vermis_shoot3       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot3        =[      $shoot3,  vermis_shoot4       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot4        =[      $shoot4,  vermis_shoot5       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot5        =[      $shoot5,  vermis_shoot6       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot6        =[      $shoot6,  vermis_shoot7       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot7        =[      $shoot7,  vermis_shoot8       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot8        =[      $shoot8,  vermis_shoot9       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot9        =[      $shoot9,  vermis_shoot10      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot10       =[      $shoot10, vermis_shoot11      ] {ai_vermis_face();ai_shotcheck(); vermis_shoot(0, 209, 73);};
void() vermis_shoot11       =[      $shoot11, vermis_shoot12      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot12       =[      $shoot12, vermis_shoot13      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot13       =[      $shoot13, vermis_shoot14      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot14       =[      $shoot14, vermis_shoot15      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot15       =[      $shoot15, vermis_shoot16      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot16       =[      $shoot16, vermis_shoot17      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot17       =[      $shoot17, vermis_shoot18      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot18       =[      $shoot18, vermis_shoot19      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot19       =[      $shoot19, vermis_shoot20      ] {ai_vermis_face();ai_shotcheck();};
void() vermis_shoot20       =[      $shoot20, vermis_run1         ] {ai_vermis_face();ai_shotcheck();};


void(float xoff, float yoff, float zoff) vermis_grab =
{
	local	vector	org;
	local	float	dist;

	if ((self.enemy.flags & FL_MONSTER) && !(self.enemy.flags & FL_CLIENT))
	{
		T_Damage (self.enemy, self, self.owner, (15 + 5 * random()));
		//return;
	}
	
	makevectors (self.angles);

	org = self.origin + v_right * xoff + v_forward * yoff + v_up * zoff;
	dist = vlen (self.enemy.origin - org);
	
	if (dist < 155)
	{
		self.enemy.vermis_grabbed = 1;
		//self.enemy.solid = SOLID_NOT;
		//self.enemy.movetype = MOVETYPE_TOSS; //was none
		sound (self, CHAN_VOICE, "vermis/grabbed.wav", 1, 0.5);
		T_Damage (self.enemy, self, self, (31 + 4 * random()));
		return;
	}
	
	sound (self, CHAN_VOICE, "vermis/grndhit.wav", 1, 0.5);
};

void(float xoff, float yoff, float zoff, float xoff2, float yoff2, float zoff2) vermis_move =
{
	local	vector	reqvel;
	local	vector	position1, position2;
	local	float	dist;
	local	vector	org;
	
	makevectors (self.angles);

	if (self.enemy.vermis_grabbed != 1)
		return;
	
	if (self.enemy.flags & FL_ONGROUND)
		self.enemy.flags = self.enemy.flags - FL_ONGROUND;
	
	if (xoff == 666)
	{
		xoff = self.enemy.origin_x;
		yoff = self.enemy.origin_y;
		zoff = self.enemy.origin_z;
	}

	position1_x = xoff;
	position1_y = yoff;
	position1_z = zoff;
	position2_x = xoff2;
	position2_y = yoff2;
	position2_z = zoff2;

	position1 = self.origin + v_right * xoff + v_forward * yoff + v_up * zoff;
	position2 = self.origin + v_right * xoff2 + v_forward * yoff2 + v_up * zoff2;
	
	setorigin(self.enemy, position1);
	self.enemy.oldorigin = self.origin;
	dist = vlen(position2 - position1);
	reqvel = normalize(position2 - position1) * dist * 10;
	
	self.enemy.velocity = reqvel;
	self.enemy.teleport_time = time + 0.2;
};


void() dummy_think =
{
	self.owner.vermis_grabbed = 0;
	self.owner.spawnmaster = world;
	self.owner.velocity = self.velocity;
	//self.owner.movetype = MOVETYPE_WALK;
	//self.owner.oldorigin = self.origin + '0 0 1';
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

void() vermis_launch =
{
	local	entity	dummy;
	
	if (self.enemy.vermis_grabbed != 1)
		return;
	
	//setorigin(self.enemy, self.origin);
	makevectors (self.angles);
	
	//if (!(self.enemy.flags & FL_MONSTER) && (self.enemy.flags & FL_CLIENT))
	//	self.enemy.movetype = MOVETYPE_WALK; //stop the player from moving.
	
	self.enemy.vermis_grabbed = 2;
	
	SUB_AttackFinished (1);
	
	if (self.enemy.health <= 0)
	{
		self.enemy.velocity = v_forward * 700 + v_up * 50;
	}
	else
	{
		dummy = spawn();
		setsize (dummy, '-16 -16 -24', '16 16 40'); // player sized bbox
		setorigin (dummy, self.enemy.origin);
		dummy.movetype = MOVETYPE_BOUNCE;
		dummy.velocity = v_forward * 700 + v_up * 50;
		dummy.nextthink = time + 1;
		dummy.think = dummy_think;
		dummy.owner = self.enemy;
		dummy.classname = "dummy";
		self.enemy.spawnmaster = dummy;
	}
	
	if (self.enemy.classname != "player")
	{
		self.enemy.velocity = v_forward * 700 + v_up * 50;
	}
	self.vermis_grabbed = time + 2; //don't let it do a grab while the player is still being thrown.
};

void() vermis_grabmis1        =[      $grabmis1,  vermis_grabmis2       ] {ai_vermis_face();};
void() vermis_grabmis2        =[      $grabmis1,  vermis_run1           ] {ai_vermis_face();SUB_AttackFinished (0.2);};

void() vermis_grab1        =[      $grab1,  vermis_grab2       ] {self.drop = self.yaw_speed; self.yaw_speed = 25;ai_vermis_face();ai_shotcheck();sound (self, CHAN_AUTO, "vermis/grab.wav", 1, 0.5);};
void() vermis_grab2        =[      $grab2,  vermis_grab3       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_grab3        =[      $grab3,  vermis_grab4       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_grab4        =[      $grab4,  vermis_grab5       ] {ai_vermis_face();ai_shotcheck();};
void() vermis_grab5        =[      $grab5,  vermis_grab6       ] {ai_vermis_face();ai_shotcheck();vermis_grab(14, 174, 24);vermis_move(666,0,0 , 14, 174, 24);};
void() vermis_grab6        =[      $grab6,  vermis_grab7       ] {vermis_move(19, 208, -7, 18, 203, -14);};
void() vermis_grab7        =[      $grab7,  vermis_grab8       ] {vermis_move(18, 203, -14, 16, 193, -5);};
void() vermis_grab8        =[      $grab8,  vermis_grab9       ] 
{
	vermis_move(16, 193, -5, 14, 182, 11);
	if (self.enemy.vermis_grabbed != 1)
		self.think = vermis_grabmis1;
};
void() vermis_grab9        =[      $grab9,  vermis_grab10      ] {vermis_move(14, 182, 11, 11, 172, 34);};
void() vermis_grab10       =[      $grab10, vermis_grab11      ] {vermis_move(11, 172, 34, 9, 166, 59);};
void() vermis_grab11       =[      $grab11, vermis_grab12      ] {vermis_move(9, 166, 59, 8, 164, 92);};
void() vermis_grab12       =[      $grab12, vermis_grab13      ] {vermis_move(8, 164, 92, 6, 156, 136);};
void() vermis_grab13       =[      $grab13, vermis_grab14      ] {vermis_move(6, 156, 136, 5, 133, 187);};
void() vermis_grab14       =[      $grab14, vermis_grab15      ] {vermis_move(5, 133, 187, 4, 89, 236);};
void() vermis_grab15       =[      $grab15, vermis_grab16      ] {vermis_move(4, 89, 236, 5, 23, 273);};
void() vermis_grab16       =[      $grab16, vermis_grab17      ] {vermis_move(5, 23, 273, 3, -38, 331);};
void() vermis_grab17       =[      $grab17, vermis_grab18      ] {vermis_move(3, -38, 331, 3, -38, 331);};
void() vermis_grab18       =[      $grab18, vermis_grab19      ] {vermis_launch();};
void() vermis_grab19       =[      $grab19, vermis_grab20      ] {};
void() vermis_grab20       =[      $grab20, vermis_run1         ] {};


void() vermis_melee =
{
	if (self.vermis_grabbed > time)
		return;
		
	//if (self.enemy.classname == "player")
		vermis_grab1();
};



void() vermis_pain =
{
	if (self.shield == 0 && self.coiled != 0)
	{
		self.shield = 1;
		vermis_wake1();
	}

	if (self.shield == 0 && self.coiled == 0)
	{
		self.shield = 1;
		vermis_trans1();
	}
	
	//no pain, but easy way to get the wake anims to play on getting awakened by pain.  whee!
	return;

};





void() vermis_death1        =[      $death1,  vermis_death2       ] {};
void() vermis_death2        =[      $death2,  vermis_death3       ] {};
void() vermis_death3        =[      $death3,  vermis_death4       ] {};
void() vermis_death4        =[      $death4,  vermis_death5       ] {};
void() vermis_death5        =[      $death5,  vermis_death6       ] {};
void() vermis_death6        =[      $death6,  vermis_death7       ] {};
void() vermis_death7        =[      $death7,  vermis_death8       ] {};
void() vermis_death8        =[      $death8,  vermis_death9       ] {};
void() vermis_death9        =[      $death9,  vermis_death10      ] {};
void() vermis_death10       =[      $death10, vermis_death11      ] {};
void() vermis_death11       =[      $death11, vermis_death12      ] {};
void() vermis_death12       =[      $death12, vermis_death13      ] {};
void() vermis_death13       =[      $death13, vermis_death14      ] {};
void() vermis_death14       =[      $death14, vermis_death15      ] {};
void() vermis_death15       =[      $death15, vermis_death16      ] {};
void() vermis_death16       =[      $death16, vermis_death17      ] {};
void() vermis_death17       =[      $death17, vermis_death18      ] {};
void() vermis_death18       =[      $death18, vermis_death19      ] {};
void() vermis_death19       =[      $death19, vermis_death20      ] {};
void() vermis_death20       =[      $death20, vermis_death21      ] {};
void() vermis_death21       =[      $death21, vermis_death22      ] {};
void() vermis_death22       =[      $death22, vermis_death23      ] {};
void() vermis_death23       =[      $death23, vermis_death24      ] {};
void() vermis_death24       =[      $death24, vermis_death25      ] {};
void() vermis_death25       =[      $death25, vermis_death26      ] {};
void() vermis_death26       =[      $death26, vermis_death27      ] {};
void() vermis_death27       =[      $death27, vermis_death28      ] {};
void() vermis_death28       =[      $death28, vermis_death29      ] {};
void() vermis_death29       =[      $death29, vermis_death30      ] {self.movetype = MOVETYPE_NOCLIP;};
void() vermis_death30       =[      $death30, vermis_death31      ] {};
void() vermis_death31       =[      $death31, vermis_death32      ] {};
void() vermis_death32       =[      $death32, vermis_death33      ] {};
void() vermis_death33       =[      $death33, vermis_death34      ] {};
void() vermis_death34       =[      $death34, vermis_death35      ] {self.velocity = '0 0 -10';};
void() vermis_death35       =[      $death35, vermis_death36      ] {self.velocity = '0 0 -20';};
void() vermis_death36       =[      $death36, vermis_death37      ] {self.velocity = '0 0 -40';};
void() vermis_death37       =[      $death37, vermis_death38      ] {self.velocity = '0 0 -80';};
void() vermis_death38       =[      $death38, vermis_death39      ] {self.velocity = '0 0 -160';};
void() vermis_death39       =[      $death39, vermis_death40      ] {self.velocity = '0 0 -320';};
void() vermis_death40       =[      $death40, vermis_death41      ] {self.velocity = '0 0 -400';};
void() vermis_death41       =[      $death41, vermis_death42      ] {self.velocity = '0 0 -450';};
void() vermis_death42       =[      $death42, vermis_death43      ] {};
void() vermis_death43       =[      $death43, vermis_death44      ] {};
void() vermis_death44       =[      $death44, vermis_death45      ] {};
void() vermis_death45       =[      $death45, vermis_death46      ] {};
void() vermis_death46       =[      $death46, vermis_death47      ] {};
void() vermis_death47       =[      $death47, vermis_death48      ] {};
void() vermis_death48       =[      $death48, vermis_death49      ] {};
void() vermis_death49       =[      $death49, vermis_death50      ] {};
void() vermis_death50       =[      $death50, vermis_death51      ] {};
void() vermis_death51       =[      $death49, vermis_death52      ] {};
void() vermis_death52       =[      $death48, vermis_death47      ] 
{
	if (self.inv == 1)
		self.think = SUB_Remove;
	self.inv = 1;
};






void() vermis_die =
{
	//self.enemy.movetype = MOVETYPE_WALK;
	sound (self, CHAN_WEAPON, "vermis/death.wav", 1, 0);
	self.solid = SOLID_NOT;
	
	if (self.enemy)
		self.enemy.vermis_grabbed = 0;
	
	vermis_death1();
	
	
};

//============================================================================


/*QUAKED monster_oldone (1 0 0) (-16 -16 -24) (16 16 32)
*/
void() monster_vermis =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/vermis.mdl");
	precache_model2 ("progs/spore.mdl");
	
	
	
	precache_sound ("vermis/grab.wav");
	precache_sound ("vermis/death.wav");
	
	precache_sound ("vermis/grabbed.wav");
	precache_sound ("vermis/grndhit.wav");
	
	precache_sound ("vermis/spore.wav");
	precache_sound ("vermis/pop.wav");
	
	precache_sound ("vermis/splash1.wav");
	precache_sound ("vermis/splash2.wav");
	precache_sound ("vermis/splash3.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;
	
	setmodel (self, "progs/vermis.mdl");
	

	self.health = 3000;
	
	if (self.coiled != 0)
	{
		precache_sound ("vermis/sight.wav");
		precache_sound ("vermis/sight2.wav");
		self.th_stand = vermis_coil1;
		setsize (self, '-64 -64 -512', '64 64 -64');
	}
	else
	{
		precache_sound ("vermis/sight2.wav");
		self.th_stand = vermis_idle1;
		setsize (self, '-64 -64 -512', '64 64 256');
	}
	
	self.th_run = vermis_run1;
	self.th_missile = vermis_shoot1;
	self.th_melee = vermis_melee;
	
	self.th_pain = vermis_pain;
	self.th_die = vermis_die;
	
	vermis_start();
	
};


//============================================================================

