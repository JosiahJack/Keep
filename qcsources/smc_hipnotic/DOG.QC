/*
==============================================================================

DOG

ADDED by Seven:
An extended new dog monster model can be used (adjustable via cvar 'dog_extended_newmodel'). The extended new dog model uses additonal animations "howl" and "bark".  They do NOT affect the gameplay.
Sets the chance of spawning extended dog model (0= never.  100= always). Choose any value you want between 0 and 100
Examples:
"0" = disabled (dont use extended new dog model)
"50" = Use original and extended new dog equally (50% / 50%).  You play against both dog types in-game.
"100" = Only use the extended new dog model 

==============================================================================
*/
$cd id1/models/dog
$origin 0 0 24
$base base
$skin skin

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

// only for extended dog model:
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10
$frame idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 idle20
$frame idle21 idle22 idle23 idle24 idle25 idle26 idle27 idle28 idle29 idle30
$frame idle31 idle32 idle33 idle34 idle35 idle36 idle37 idle38 idle39 idle40

$frame howl1 howl2 howl3 howl4 howl5 howl6 howl7 howl8 howl9 howl10
$frame howl11 howl12 howl13 howl14 howl15 howl16 howl17 howl18 howl19 howl20
$frame howl21 howl22 howl23 howl24 howl25 howl26 howl27 howl28 howl29 howl30
$frame howl31 howl32 howl33 howl34 howl35 howl36 howl37 howl38 howl39 howl40
$frame howl41 howl42

$frame bark1 bark2 bark3 bark4 bark5 bark6 bark7 bark8 bark9 bark10
$frame bark11


void() dog_leap1;
void() dog_run1;

/*
================
dog_bite

================
*/
void() dog_bite =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

    var float autocvar_dog_size_influenced_attack = 0; 	  					// set cvar 'dog_size_influenced_attack' default to 0
	if (autocvar_dog_size_influenced_attack == 1)						// if 'dog_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_dog_bite * self.scale;	// default 8
	else
		ldmg = (random() + random() + random()) * autocvar_dog_bite;			// default 8
	T_Damage (self.enemy, self, self, ldmg);
};

void()	Dog_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 300 )
		{
			var float autocvar_dog_size_influenced_attack = 0; 	  		// set cvar 'dog_size_influenced_attack' default to 0
			if (autocvar_dog_size_influenced_attack == 1)				// if 'dog_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
				ldmg = (autocvar_dog_jump * self.scale) + 10*random();		// default 10
			else
				ldmg = autocvar_dog_jump + 10*random();				// default 10
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = dog_leap1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = dog_run1;
	self.nextthink = time + 0.1;
};


void(float loudness) dog_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound(self, CHAN_AUTO, "walk/dog1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.66)
		sound(self, CHAN_AUTO, "walk/dog2.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/dog3.wav", loudness, ATTN_IDLE);
	}
};


// only for extended dog model:
void() dog_howl_newmodel1	=[	$howl1,		dog_howl_newmodel2	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_howl_newmodel2	=[	$howl2,		dog_howl_newmodel3	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_howl_newmodel3	=[	$howl3,		dog_howl_newmodel4	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_howl_newmodel4	=[	$howl4,		dog_howl_newmodel5	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_howl_newmodel5	=[	$howl5,		dog_howl_newmodel6	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_howl_newmodel6	=[	$howl6,		dog_howl_newmodel7	] {ai_stand(); sound(self, CHAN_VOICE, "dog/howl.wav", 1, ATTN_IDLE);};
void() dog_howl_newmodel7	=[	$howl7,		dog_howl_newmodel8	] {ai_stand();};
void() dog_howl_newmodel8	=[	$howl8,		dog_howl_newmodel9	] {ai_stand();};
void() dog_howl_newmodel9	=[	$howl9,		dog_howl_newmodel10	] {ai_stand();};
void() dog_howl_newmodel10	=[	$howl10,	dog_howl_newmodel11	] {ai_stand();};
void() dog_howl_newmodel11	=[	$howl11,	dog_howl_newmodel12	] {ai_stand();};
void() dog_howl_newmodel12	=[	$howl12,	dog_howl_newmodel13	] {ai_stand();};
void() dog_howl_newmodel13	=[	$howl13,	dog_howl_newmodel14	] {ai_stand();};
void() dog_howl_newmodel14	=[	$howl14,	dog_howl_newmodel15	] {ai_stand();};
void() dog_howl_newmodel15	=[	$howl15,	dog_howl_newmodel16	] {ai_stand();};
void() dog_howl_newmodel16	=[	$howl16,	dog_howl_newmodel17	] {ai_stand();};
void() dog_howl_newmodel17	=[	$howl17,	dog_howl_newmodel18	] {ai_stand();};
void() dog_howl_newmodel18	=[	$howl18,	dog_howl_newmodel19	] {ai_stand();};
void() dog_howl_newmodel19	=[	$howl19,	dog_howl_newmodel20	] {ai_stand();};
void() dog_howl_newmodel20	=[	$howl20,	dog_howl_newmodel21	] {ai_stand();};
void() dog_howl_newmodel21	=[	$howl21,	dog_howl_newmodel22	] {ai_stand();};
void() dog_howl_newmodel22	=[	$howl22,	dog_howl_newmodel23	] {ai_stand();};
void() dog_howl_newmodel23	=[	$howl23,	dog_howl_newmodel24	] {ai_stand();};
void() dog_howl_newmodel24	=[	$howl24,	dog_howl_newmodel25	] {ai_stand();};
void() dog_howl_newmodel25	=[	$howl25,	dog_howl_newmodel26	] {ai_stand();};
void() dog_howl_newmodel26	=[	$howl26,	dog_howl_newmodel27	] {ai_stand();};
void() dog_howl_newmodel27	=[	$howl27,	dog_howl_newmodel28	] {ai_stand();};
void() dog_howl_newmodel28	=[	$howl28,	dog_howl_newmodel29	] {ai_stand();};
void() dog_howl_newmodel29	=[	$howl28,	dog_howl_newmodel30	] {ai_stand();};
void() dog_howl_newmodel30	=[	$howl30,	dog_howl_newmodel31	] {ai_stand();};
void() dog_howl_newmodel31	=[	$howl31,	dog_howl_newmodel32	] {ai_stand();};
void() dog_howl_newmodel32	=[	$howl32,	dog_howl_newmodel33	] {ai_stand();};
void() dog_howl_newmodel33	=[	$howl33,	dog_howl_newmodel34	] {ai_stand();};
void() dog_howl_newmodel34	=[	$howl34,	dog_howl_newmodel35	] {ai_stand();};
void() dog_howl_newmodel35	=[	$howl35,	dog_howl_newmodel36	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel36	=[	$howl36,	dog_howl_newmodel37	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel37	=[	$howl37,	dog_howl_newmodel38	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel38	=[	$howl38,	dog_howl_newmodel39	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel39	=[	$howl39,	dog_howl_newmodel40	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel40	=[	$howl40,	dog_howl_newmodel41	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel41	=[	$howl41,	dog_howl_newmodel42	] {ai_stand();self.nextthink = time + 0.05;};
void() dog_howl_newmodel42	=[	$howl42,	dog_stand_newmodel40	] {ai_stand();self.nextthink = time + 0.05;};

void() dog_howl_newmodel1a	=[	$howl1,		dog_howl_newmodel2a	] {ai_walk(0);self.nextthink = time + 0.06;};
void() dog_howl_newmodel2a	=[	$howl2,		dog_howl_newmodel3a	] {ai_walk(0);self.nextthink = time + 0.06;};
void() dog_howl_newmodel3a	=[	$howl3,		dog_howl_newmodel4a	] {ai_walk(0);self.nextthink = time + 0.06;};
void() dog_howl_newmodel4a	=[	$howl4,		dog_howl_newmodel5a	] {ai_walk(0);self.nextthink = time + 0.06;};
void() dog_howl_newmodel5a	=[	$howl5,		dog_howl_newmodel6a	] {ai_walk(0);self.nextthink = time + 0.06;};
void() dog_howl_newmodel6a	=[	$howl6,		dog_howl_newmodel7a	] {ai_walk(0); sound(self, CHAN_VOICE, "dog/howl.wav", 1, ATTN_IDLE);};
void() dog_howl_newmodel7a	=[	$howl7,		dog_howl_newmodel8a	] {ai_walk(0);};
void() dog_howl_newmodel8a	=[	$howl8,		dog_howl_newmodel9a	] {ai_walk(0);};
void() dog_howl_newmodel9a	=[	$howl9,		dog_howl_newmodel10a	] {ai_walk(0);};
void() dog_howl_newmodel10a	=[	$howl10,	dog_howl_newmodel11a	] {ai_walk(0);};
void() dog_howl_newmodel11a	=[	$howl11,	dog_howl_newmodel12a	] {ai_walk(0);};
void() dog_howl_newmodel12a	=[	$howl12,	dog_howl_newmodel13a	] {ai_walk(0);};
void() dog_howl_newmodel13a	=[	$howl13,	dog_howl_newmodel14a	] {ai_walk(0);};
void() dog_howl_newmodel14a	=[	$howl14,	dog_howl_newmodel15a	] {ai_walk(0);};
void() dog_howl_newmodel15a	=[	$howl15,	dog_howl_newmodel16a	] {ai_walk(0);};
void() dog_howl_newmodel16a	=[	$howl16,	dog_howl_newmodel17a	] {ai_walk(0);};
void() dog_howl_newmodel17a	=[	$howl17,	dog_howl_newmodel18a	] {ai_walk(0);};
void() dog_howl_newmodel18a	=[	$howl18,	dog_howl_newmodel19a	] {ai_walk(0);};
void() dog_howl_newmodel19a	=[	$howl19,	dog_howl_newmodel20a	] {ai_walk(0);};
void() dog_howl_newmodel20a	=[	$howl20,	dog_howl_newmodel21a	] {ai_walk(0);};
void() dog_howl_newmodel21a	=[	$howl21,	dog_howl_newmodel22a	] {ai_walk(0);};
void() dog_howl_newmodel22a	=[	$howl22,	dog_howl_newmodel23a	] {ai_walk(0);};
void() dog_howl_newmodel23a	=[	$howl23,	dog_howl_newmodel24a	] {ai_walk(0);};
void() dog_howl_newmodel24a	=[	$howl24,	dog_howl_newmodel25a	] {ai_walk(0);};
void() dog_howl_newmodel25a	=[	$howl25,	dog_howl_newmodel26a	] {ai_walk(0);};
void() dog_howl_newmodel26a	=[	$howl26,	dog_howl_newmodel27a	] {ai_walk(0);};
void() dog_howl_newmodel27a	=[	$howl27,	dog_howl_newmodel28a	] {ai_walk(0);};
void() dog_howl_newmodel28a	=[	$howl28,	dog_howl_newmodel29a	] {ai_walk(0);};
void() dog_howl_newmodel29a	=[	$howl28,	dog_howl_newmodel30a	] {ai_walk(0);};
void() dog_howl_newmodel30a	=[	$howl30,	dog_howl_newmodel31a	] {ai_walk(0);};
void() dog_howl_newmodel31a	=[	$howl31,	dog_howl_newmodel32a	] {ai_walk(0);};
void() dog_howl_newmodel32a	=[	$howl32,	dog_howl_newmodel33a	] {ai_walk(0);};
void() dog_howl_newmodel33a	=[	$howl33,	dog_howl_newmodel34a	] {ai_walk(0);};
void() dog_howl_newmodel34a	=[	$howl34,	dog_howl_newmodel35a	] {ai_walk(0);};
void() dog_howl_newmodel35a	=[	$howl35,	dog_howl_newmodel36a	] {ai_walk(0);self.nextthink = time + 0.05;};
void() dog_howl_newmodel36a	=[	$howl36,	dog_howl_newmodel37a	] {ai_walk(0);self.nextthink = time + 0.05;};
void() dog_howl_newmodel37a	=[	$howl37,	dog_howl_newmodel38a	] {ai_walk(0);self.nextthink = time + 0.05;};
void() dog_howl_newmodel38a	=[	$howl38,	dog_howl_newmodel39a	] {ai_walk(0);self.nextthink = time + 0.05;};
void() dog_howl_newmodel39a	=[	$howl39,	dog_howl_newmodel40a	] {ai_walk(0);self.nextthink = time + 0.05;};
void() dog_howl_newmodel40a	=[	$howl40,	dog_walk7		] {ai_walk(0);self.nextthink = time + 0.05;};

void() dog_bark_newmodel1	=[	$bark1,		dog_bark_newmodel2	] {ai_stand();};
void() dog_bark_newmodel2	=[	$bark2,		dog_bark_newmodel3	] {ai_stand();};
void() dog_bark_newmodel3	=[	$bark3,		dog_bark_newmodel4	] {ai_stand(); sound(self, CHAN_AUTO, "dog/bark.wav", 1, ATTN_IDLE);};
void() dog_bark_newmodel4	=[	$bark4,		dog_bark_newmodel5	] {ai_stand();};
void() dog_bark_newmodel5	=[	$bark5,		dog_bark_newmodel6	] {ai_stand();};
void() dog_bark_newmodel6	=[	$bark6,		dog_bark_newmodel7	] {ai_stand();};
void() dog_bark_newmodel7	=[	$bark7,		dog_bark_newmodel8	] {ai_stand(); sound(self, CHAN_AUTO, "dog/bark.wav", 1, ATTN_IDLE);};
void() dog_bark_newmodel8	=[	$bark8,		dog_bark_newmodel9	] {ai_stand();};
void() dog_bark_newmodel9	=[	$bark9,		dog_bark_newmodel10	] {ai_stand();};
void() dog_bark_newmodel10	=[	$bark10,	dog_bark_newmodel11	] {ai_stand();};
void() dog_bark_newmodel11	=[	$bark11,	dog_stand_newmodel40	] {ai_stand();};

void() dog_bark_newmodel1a	=[	$bark1,		dog_bark_newmodel2a	] {ai_walk(0);};
void() dog_bark_newmodel2a	=[	$bark2,		dog_bark_newmodel3a	] {ai_walk(0);};
void() dog_bark_newmodel3a	=[	$bark3,		dog_bark_newmodel4a	] {ai_walk(0); sound(self, CHAN_AUTO, "dog/bark.wav", 1, ATTN_IDLE);};
void() dog_bark_newmodel4a	=[	$bark4,		dog_bark_newmodel5a	] {ai_walk(0);};
void() dog_bark_newmodel5a	=[	$bark5,		dog_bark_newmodel6a	] {ai_walk(0);};
void() dog_bark_newmodel6a	=[	$bark6,		dog_bark_newmodel7a	] {ai_walk(0);};
void() dog_bark_newmodel7a	=[	$bark7,		dog_bark_newmodel8a	] {ai_walk(0); sound(self, CHAN_AUTO, "dog/bark.wav", 1, ATTN_IDLE);};
void() dog_bark_newmodel8a	=[	$bark8,		dog_bark_newmodel9a	] {ai_walk(0);};
void() dog_bark_newmodel9a	=[	$bark9,		dog_bark_newmodel10a	] {ai_walk(0);};
void() dog_bark_newmodel10a	=[	$bark10,	dog_bark_newmodel11a	] {ai_walk(0);};
void() dog_bark_newmodel11a	=[	$bark11,	dog_walk7		] {ai_walk(0);};

void() dog_stand_newmodel1	=[	$idle1,		dog_stand_newmodel2	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel2	=[	$idle2,		dog_stand_newmodel3	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel3	=[	$idle3,		dog_stand_newmodel4	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel4	=[	$idle4,		dog_stand_newmodel5	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel5	=[	$idle5,		dog_stand_newmodel6	] {ai_stand();self.nextthink = time + 0.06; 
if (random() <= 0.27)		// 27% chance that dog growls
	{
	if (random() <= 0.5)
		sound(self, CHAN_VOICE, "dog/growla.wav", 1, ATTN_IDLE);
	else
		sound(self, CHAN_VOICE, "dog/growlb.wav", 1, ATTN_IDLE);
	}
};
void() dog_stand_newmodel6	=[	$idle6,		dog_stand_newmodel7	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel7	=[	$idle7,		dog_stand_newmodel8	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel8	=[	$idle8,		dog_stand_newmodel9	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel9	=[	$idle9,		dog_stand_newmodel10	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel10	=[	$idle10,	dog_stand_newmodel11	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel11	=[	$idle11,	dog_stand_newmodel12	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel12	=[	$idle12,	dog_stand_newmodel13	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel13	=[	$idle13,	dog_stand_newmodel14	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel14	=[	$idle14,	dog_stand_newmodel15	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel15	=[	$idle15,	dog_stand_newmodel16	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel16	=[	$idle16,	dog_stand_newmodel17	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel17	=[	$idle17,	dog_stand_newmodel18	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel18	=[	$idle18,	dog_stand_newmodel19	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel19	=[	$idle19,	dog_stand_newmodel20	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel20	=[	$idle20,	dog_stand_newmodel21	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel21	=[	$idle21,	dog_stand_newmodel22	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel22	=[	$idle22,	dog_stand_newmodel23	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel23	=[	$idle23,	dog_stand_newmodel24	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel24	=[	$idle24,	dog_stand_newmodel25	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel25	=[	$idle25,	dog_stand_newmodel26	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel26	=[	$idle26,	dog_stand_newmodel27	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel27	=[	$idle27,	dog_stand_newmodel28	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel28	=[	$idle28,	dog_stand_newmodel29	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel29	=[	$idle29,	dog_stand_newmodel30	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel30	=[	$idle30,	dog_stand_newmodel31	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel31	=[	$idle31,	dog_stand_newmodel32	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel32	=[	$idle32,	dog_stand_newmodel33	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel33	=[	$idle33,	dog_stand_newmodel34	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel34	=[	$idle34,	dog_stand_newmodel35	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel35	=[	$idle35,	dog_stand_newmodel36	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel36	=[	$idle36,	dog_stand_newmodel37	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel37	=[	$idle37,	dog_stand_newmodel38	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel38	=[	$idle38,	dog_stand_newmodel39	] {ai_stand();self.nextthink = time + 0.06;};
void() dog_stand_newmodel39	=[	$idle39,	dog_stand_newmodel40	] {ai_stand();self.nextthink = time + 0.06;
if (random() <= 0.17)		// 17% chance that dog goes into howl or bark animation
	{
	if (random() <= 0.666)
		dog_bark_newmodel1(); 
	else
		dog_howl_newmodel1(); 
	}
};
void() dog_stand_newmodel40	=[	$idle40,	dog_stand_newmodel1	] {ai_stand();self.nextthink = time + 0.06;};


void() dog_stand1	=[	$stand1,	dog_stand2	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand2	=[	$stand2,	dog_stand3	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand3	=[	$stand3,	dog_stand4	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand4	=[	$stand4,	dog_stand5	] {ai_stand();self.nextthink = time + 0.15;
if (random() <= 0.2)		// 20% chance that dog growls
	{
	if (random() <= 0.5)
		sound(self, CHAN_VOICE, "dog/growla.wav", 1, ATTN_IDLE);
	else
		sound(self, CHAN_VOICE, "dog/growlb.wav", 1, ATTN_IDLE);
	}
};
void() dog_stand5	=[	$stand5,	dog_stand6	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand6	=[	$stand6,	dog_stand7	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand7	=[	$stand7,	dog_stand8	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand8	=[	$stand8,	dog_stand9	] {ai_stand();self.nextthink = time + 0.15;};
void() dog_stand9	=[	$stand9,	dog_stand1	] {ai_stand();self.nextthink = time + 0.15;};

void() dog_walk1	=[	$walk1 ,	dog_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_walk(8);
dog_footsteps (0.5);};
void() dog_walk2	=[	$walk2 ,	dog_walk3	] {ai_walk(8);};
void() dog_walk3	=[	$walk3 ,	dog_walk4	] {ai_walk(8);dog_footsteps (0.5);
if (self.monstermodel == 2)  
	{
	if (random() <= 0.11)		// 11% chance that dog goes into howl or bark animation
		{
		if (random() <= 0.666)
			dog_bark_newmodel1a(); 
		else
			dog_howl_newmodel1a(); 
		}
	}
};
void() dog_walk4	=[	$walk4 ,	dog_walk5	] {ai_walk(8);};
void() dog_walk5	=[	$walk5 ,	dog_walk6	] {ai_walk(8);dog_footsteps (0.5);};
void() dog_walk6	=[	$walk6 ,	dog_walk7	] {ai_walk(8);};
void() dog_walk7	=[	$walk7 ,	dog_walk8	] {ai_walk(8);dog_footsteps (0.5);};
void() dog_walk8	=[	$walk8 ,	dog_walk1	] {ai_walk(8);};

void() dog_run1		=[	$run1  ,	dog_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_run(16);};
void() dog_run2		=[	$run2  ,	dog_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(32);dog_footsteps (0.8);};
void() dog_run3		=[	$run3  ,	dog_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(32);};
void() dog_run4		=[	$run4  ,	dog_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);};
void() dog_run5		=[	$run5  ,	dog_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(64);dog_footsteps (0.9);};
void() dog_run6		=[	$run6  ,	dog_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(32);};
void() dog_run7		=[	$run7  ,	dog_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void() dog_run8		=[	$run8  ,	dog_run9	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(32);dog_footsteps (0.7);};
void() dog_run9		=[	$run9  ,	dog_run10	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(32);};
void() dog_run10	=[	$run10  ,	dog_run11	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);};
void() dog_run11	=[	$run11  ,	dog_run12	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(64);dog_footsteps (0.8);};
void() dog_run12	=[	$run12  ,	dog_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(32);};

void() dog_atta1	=[	$attack1,	dog_atta2	] {ai_charge(10);};
void() dog_atta2	=[	$attack2,	dog_atta3	] {ai_charge(10);};
void() dog_atta3	=[	$attack3,	dog_atta4	] {ai_charge(10);};
void() dog_atta4	=[	$attack4,	dog_atta5	] {
sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);
dog_bite();};
void() dog_atta5	=[	$attack5,	dog_atta6	] {ai_charge(10);};
void() dog_atta6	=[	$attack6,	dog_atta7	] {ai_charge(10);};
void() dog_atta7	=[	$attack7,	dog_atta8	] {ai_charge(10);dog_footsteps (0.6);};
void() dog_atta8	=[	$attack8,	dog_run1	] {ai_charge(10);};

void() dog_leap1	=[	$leap1,		dog_leap2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() dog_leap2	=[	$leap2,		dog_leap3	]
{
	self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001); ai_face();
	
	self.touch = Dog_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() dog_leap3	=[	$leap3,		dog_leap4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void() dog_leap4	=[	$leap4,		dog_leap5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void() dog_leap5	=[	$leap5,		dog_leap6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void() dog_leap6	=[	$leap6,		dog_leap7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void() dog_leap7	=[	$leap7,		dog_leap8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void() dog_leap8	=[	$leap8,		dog_leap9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dog_footsteps (1);};
void() dog_leap9	=[	$leap9,		dog_leap9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};

void() dog_pain1	=[	$pain1 ,	dog_pain2	] {};
void() dog_pain2	=[	$pain2 ,	dog_pain3	] {};
void() dog_pain3	=[	$pain3 ,	dog_pain4	] {};
void() dog_pain4	=[	$pain4 ,	dog_pain5	] {};
void() dog_pain5	=[	$pain5 ,	dog_pain6	] {};
void() dog_pain6	=[	$pain6 ,	dog_run1	] {dog_footsteps (0.6);};

void() dog_painb1	=[	$painb1 ,	dog_painb2	] {};
void() dog_painb2	=[	$painb2 ,	dog_painb3	] {};
void() dog_painb3	=[	$painb3 ,	dog_painb4	] {ai_pain(4);};
void() dog_painb4	=[	$painb4 ,	dog_painb5	] {ai_pain(12);};
void() dog_painb5	=[	$painb5 ,	dog_painb6	] {ai_pain(12);};
void() dog_painb6	=[	$painb6 ,	dog_painb7	] {ai_pain(2);};
void() dog_painb7	=[	$painb7 ,	dog_painb8	] {};
void() dog_painb8	=[	$painb8 ,	dog_painb9	] {ai_pain(4);};
void() dog_painb9	=[	$painb9 ,	dog_painb10	] {};
void() dog_painb10	=[	$painb10 ,	dog_painb11	] {ai_pain(10);};
void() dog_painb11	=[	$painb11 ,	dog_painb12	] {};
void() dog_painb12	=[	$painb12 ,	dog_painb13	] {};
void() dog_painb13	=[	$painb13 ,	dog_painb14	] {dog_footsteps (0.6);};
void() dog_painb14	=[	$painb14 ,	dog_painb15	] {};
void() dog_painb15	=[	$painb15 ,	dog_painb16	] {};
void() dog_painb16	=[	$painb16 ,	dog_run1	] {};

void() dog_pain =
{
	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_dog * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}

	if (random() > 0.5)
		dog_pain1 ();
	else
		dog_painb1 ();
};

void() dog_dieburn1	=[	$death1,	dog_dieburn2	] {self.burnz_origin = 10;
burn_toggle_allround();
};
void() dog_dieburn2	=[	$death2,	dog_dieburn3	] {self.burnz_origin = 8;
};
void() dog_dieburn3	=[	$death3,	dog_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() dog_dieburn4	=[	$death4,	dog_dieburn5	] {self.burnz_origin = 3;
};
void() dog_dieburn5	=[	$death5,	dog_dieburn6	] {self.burnz_origin = 0;
};
void() dog_dieburn6	=[	$death6,	dog_dieburn7	] {self.burnz_origin = -2;
};
void() dog_dieburn7	=[	$death7,	dog_dieburn8	] {self.burnz_origin = -4;
};
void() dog_dieburn8	=[	$death8,	dog_dieburn9	] {self.burnz_origin = -6;
};
void() dog_dieburn9	=[	$death9,	dog_dieburn9	] {self.burnz_origin = -9;
};


var float autocvar_dog = 3;     		// set cvar 'dog' default to 3
var float autocvar_dogcorpsehealth = 60;	// set cvar 'dogcorpsehealth' default to 60
var float autocvar_dogcorpseburnable = 0;	// set cvar 'dogcorpseburnable' default to 0

void() dog_die1		=[	$death1,	dog_die2	] {};
void() dog_die2		=[	$death2,	dog_die3	] {};
void() dog_die3		=[	$death3,	dog_die4	] {};
void() dog_die4		=[	$death4,	dog_die5	] {};
void() dog_die5		=[	$death5,	dog_die6	] {};
void() dog_die6		=[	$death6,	dog_die7	] {};
void() dog_die7		=[	$death7,	dog_die8	] {};
void() dog_die8		=[	$death8,	dog_die9	] {};
void() dog_die9		=[	$death9,	dog_die9	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 20;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_dogcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'dogcorpsehealth' has been set to  default = 60  in code above already
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_dogcorpsehealth, "progs/h_dog.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_dogcorpsehealth, "progs/h_dog1.mdl");
	if (self.monstermodel == 2)  
		CopyMonsterToBodyQue(autocvar_dogcorpsehealth, "progs/h_dog_extended.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'dog' has been declared in code above already
	var float autocvar_dograndomness = 25;     	// set cvar 'dograndomness' default to 25%
	autocvar_dograndomness = autocvar_dograndomness * 0.01;
	if (autocvar_dog == 1)			// if 'dog' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
			ghost_die (); 
		}
	else if (autocvar_dog == 2)		// if 'dog' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/dog.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/dog1.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 2)  
				soul ("progs/dog_extended.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_dog == 3)		// if 'dog' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
			vengeance_dog ("progs/dog.mdl", $death9); 
		}
	else if (autocvar_dog == 5)		// if 'dog' is set via autoexec.cfg to '5' start randomly one of these Death animations:
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/dog.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/dog1.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 2)  
					soul ("progs/dog_extended.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_dog ("progs/dog.mdl", $death9);
			}
		}
	else				// if 'dog' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{	
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.monstermodel == 0)  
			soul ("progs/dog.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/dog1.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 2)  
			soul ("progs/dog_extended.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_dog ("progs/dog.mdl", $death9);
	}
};


void() dog_dieb1		=[	$deathb1,	dog_dieb2	] {};
void() dog_dieb2		=[	$deathb2,	dog_dieb3	] {};
void() dog_dieb3		=[	$deathb3,	dog_dieb4	] {};
void() dog_dieb4		=[	$deathb4,	dog_dieb5	] {};
void() dog_dieb5		=[	$deathb5,	dog_dieb6	] {};
void() dog_dieb6		=[	$deathb6,	dog_dieb7	] {};
void() dog_dieb7		=[	$deathb7,	dog_dieb8	] {};
void() dog_dieb8		=[	$deathb8,	dog_dieb9	] {};
void() dog_dieb9		=[	$deathb9,	dog_dieb9	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 20;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_dogcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'dogcorpsehealth' has been set to  default = 60  in code above already
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_dogcorpsehealth, "progs/h_dog.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_dogcorpsehealth, "progs/h_dog1.mdl");
	if (self.monstermodel == 2)  
		CopyMonsterToBodyQue(autocvar_dogcorpsehealth, "progs/h_dog_extended.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'dog' has been declared in code above already
	var float autocvar_dograndomness = 25;     	// set cvar 'dograndomness' default to 25%
	autocvar_dograndomness = autocvar_dograndomness * 0.01;
	if (autocvar_dog == 1)			// if 'dog' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
			ghost_die (); 
		}
	else if (autocvar_dog == 2)		// if 'dog' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/dog.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/dog1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 2)  
				soul ("progs/dog_extended.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_dog == 3)		// if 'dog' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
			vengeance_dog ("progs/dog.mdl", $deathb9); 
		}
	else if (autocvar_dog == 5)		// if 'dog' is set via autoexec.cfg to '5' start randomly one of these Death animations:
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/dog.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/dog1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 2)  
					soul ("progs/dog_extended.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_dog ("progs/dog.mdl", $deathb9);
			}
		}
	else				// if 'dog' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)		// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{		
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.monstermodel == 0)  
			soul ("progs/dog.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/dog1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 2)  
			soul ("progs/dog_extended.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_dog ("progs/dog.mdl", $deathb9);
	}
};


void(float maxgibs, float gibscounter) producegibs_dog =	 // creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);   	
	}
gibscounter = gibscounter + 1;
producegibs_dog (maxgibs, gibscounter);
};


void()	dog_lightning_death	=[	$attack7,	dog_lightning_death1	] {
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	dog_lightning_death1	=[	$attack7,	dog_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_dog.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_dog1.mdl");
if (self.monstermodel == 2)  
	CopyMonsterToBodyQue(1, "progs/h_dog_extended.mdl");
};


void() dog_die;
void() dog_inflamed13;

void() dog_inflamed1	=[	$run1,	dog_inflamed2	] {ai_run_inflamed(16); self.nextthink = time + 0.09;
if (random() < 0.75)
	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);
};
void() dog_inflamed2	=[	$run2,	dog_inflamed3	] {ai_run_inflamed(32);dog_footsteps (0.8); self.nextthink = time + 0.09;};
void() dog_inflamed3	=[	$run3,	dog_inflamed4	] {ai_run_inflamed(32); self.nextthink = time + 0.09;};
void() dog_inflamed4	=[	$run4,	dog_inflamed5	] {ai_run_inflamed(20); self.nextthink = time + 0.09;};
void() dog_inflamed5	=[	$run5,	dog_inflamed6	] {ai_run_inflamed(64);dog_footsteps (0.9); self.nextthink = time + 0.09;};
void() dog_inflamed6	=[	$run6,	dog_inflamed7	] {ai_run_inflamed(32); self.nextthink = time + 0.09;};
void() dog_inflamed7	=[	$run7,	dog_inflamed8	] {ai_run_inflamed(16); self.nextthink = time + 0.09;
if (random() < 0.5)
	dog_inflamed13 ();	// start pain anim
};
void() dog_inflamed8	=[	$run8,	dog_inflamed9	] {ai_run_inflamed(32);dog_footsteps (0.7); self.nextthink = time + 0.09;};
void() dog_inflamed9	=[	$run9,	dog_inflamed10	] {ai_run_inflamed(32); self.nextthink = time + 0.09;};
void() dog_inflamed10	=[	$run10,	dog_inflamed11	] {ai_run_inflamed(20); self.nextthink = time + 0.09;};
void() dog_inflamed11	=[	$run11,	dog_inflamed12	] {ai_run_inflamed(64);dog_footsteps (0.8); self.nextthink = time + 0.09;};
void() dog_inflamed12	=[	$run12,	dog_inflamed1	] {ai_run_inflamed(32); self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	dog_die ();
	return;
}
};

void() dog_inflamed13	=[	$pain1,	dog_inflamed14	] { self.nextthink = time + 0.09;};
void() dog_inflamed14	=[	$pain2,	dog_inflamed15	] { self.nextthink = time + 0.09;};
void() dog_inflamed15	=[	$pain3,	dog_inflamed16	] { self.nextthink = time + 0.09;
if (random() < 0.8)
	sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);
};
void() dog_inflamed16	=[	$pain4,	dog_inflamed17	] { self.nextthink = time + 0.09;};
void() dog_inflamed17	=[	$pain5,	dog_inflamed18	] { self.nextthink = time + 0.09;};
void() dog_inflamed18	=[	$pain6,	dog_inflamed8	] { dog_footsteps (0.6); self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	dog_die ();
	return;
}
};



void() dog_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			dog_lightning_death();
			return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -35)
	{
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_dog * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_dog.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_dog1.mdl", self.health);
				else if (self.monstermodel == 2)  
					ThrowHead ("progs/h_dog_extended.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_dog.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_dog1.mdl", self.health);
				else if (self.monstermodel == 2)  
					ThrowHead ("progs/h_dog_extended.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_dog (maxgibs, gibscounter);
				return;
				}
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0)		// enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER) || (self.enemy.weapon == IT_PROXIMITY_GUN)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER))	// when enemy was killed with explosives, set it on fire
			{
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				dog_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);
			self.solid = SOLID_NOT;
			if (random() > 0.5)
				dog_die1 ();
			else
				dog_dieb1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'dog' has been declared in code above already
var float autocvar_dograndomness = 25;     	// set cvar 'dograndomness' default to 25%
autocvar_dograndomness = autocvar_dograndomness * 0.01;
if (autocvar_dog == 4)		// if 'dog' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		dog_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_dog == 6)		// if 'dog' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{			// chance for effects (approx.): 25% / 25% / 25% / 25%	
	randomness = random();
	if (randomness <= autocvar_dograndomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			dog_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'dog' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_dog * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	if (random() > 0.5)
		dog_die1 ();
	else
		dog_dieb1 ();
};



//============================================================================

/*
==============
CheckDogMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDogMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDogJump

==============
*/
float()	CheckDogJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 80)
		return FALSE;
		
	if (d > 150)
		return FALSE;
		
	return TRUE;
};

float()	DogCheckAttack =
{
// if close enough for slashing, go for it
	if (CheckDogMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDogJump ())
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

var float autocvar_dog_extended_newmodel = 30;		// set cvar 'dog_extended_newmodel' default to 30%   (see detailed description at the beginning of this file)

/*QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_dog =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog.mdl");

	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");
	precache_sound ("dog/bark.wav");
	precache_sound ("dog/howl.wav");
	precache_sound ("dog/growla.wav");
	precache_sound ("dog/growlb.wav");
	precache_sound ("walk/dog1.wav");
	precache_sound ("walk/dog2.wav");
	precache_sound ("walk/dog3.wav");


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	local float zufall;

var float autocvar_dogmultiskin = 0;     	// set cvar 'dogmultiskin' default to 0
	if (autocvar_dogmultiskin == 1)		// if 'dogmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/dog.mdl");
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
	else if (autocvar_dogmultiskin == 2)	// if 'dogmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/dog1.mdl");
		precache_model ("progs/h_dog1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/dog.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/dog1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_dogmultiskin == 3)	// if 'dogmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/dog1.mdl");
		precache_model ("progs/h_dog1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/dog.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/dog.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/dog1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_dogmultiskin == 4)	// if 'dogmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/dog1.mdl");
		precache_model ("progs/h_dog1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/dog.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/dog.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/dog1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/dog1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/dog.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

if (autocvar_dog_extended_newmodel)	// transform model to extended new dog model
	{
	local float new_dog;
	new_dog = autocvar_dog_extended_newmodel * 0.01;
	if (random() < new_dog)		// transform model to extended new dog model
		{
		precache_model ("progs/dog_extended.mdl");
		precache_model ("progs/h_dog_extended.mdl");
		setmodel (self, "progs/dog_extended.mdl");
		zufall = random();
		if (zufall > 0.5)
			{
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 2;
			}
		else
			{
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 2;
			}
		}
	}

var float autocvar_dog_size = 2;     		// set cvar 'dog_size' default to 2
	local float zuffa;
	if (autocvar_dog_size == 1)		// if 'dog_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			setsize (self, '-32 -32 -24' - '0 0 3', '32 32 40' - '0 0 3');
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			setsize (self, '-32 -32 -24' - '0 0 1', '32 32 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-32 -32 -24', '32 32 40');
		}
	}
	else if (autocvar_dog_size == 2)		// if 'dog_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			setsize (self, '-32 -32 -24' - '0 0 5', '32 32 40' - '0 0 5');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			setsize (self, '-32 -32 -24' - '0 0 3', '32 32 40' - '0 0 3');
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.07;
			setsize (self, '-32 -32 -24' - '0 0 1', '32 32 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-32 -32 -24', '32 32 40');
		}
	}
	else if (autocvar_dog_size == 3)		// if 'dog_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			setsize (self, '-32 -32 -24' - '0 0 7', '32 32 40' - '0 0 7');
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			setsize (self, '-32 -32 -24' - '0 0 5', '32 32 40' - '0 0 5');
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			setsize (self, '-32 -32 -24' - '0 0 3', '32 32 40' - '0 0 3');
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			setsize (self, '-32 -32 -24' - '0 0 1', '32 32 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-32 -32 -24', '32 32 40');
		}
	}
	else if (autocvar_dog_size == 4)		// if 'dog_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			setsize (self, '-32 -32 -24' - '0 0 9', '32 32 40' - '0 0 9');
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			setsize (self, '-32 -32 -24' - '0 0 7', '32 32 40' - '0 0 7');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			setsize (self, '-32 -32 -24' - '0 0 5', '32 32 40' - '0 0 5');
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			setsize (self, '-32 -32 -24' - '0 0 3', '32 32 40' - '0 0 3');
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			setsize (self, '-32 -32 -24' - '0 0 1', '32 32 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-32 -32 -24', '32 32 40');
		}
	}
	else if (autocvar_dog_size > 4)		// if 'dog_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_dog_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_dog_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_dog_size * 0.25;
		setsize (self, '-32 -32 -24' - self.sizefactor, '32 32 40' - self.sizefactor);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-32 -32 -24', '32 32 40');
	}

var float autocvar_dog_size_influenced_health = 0; 		  		// set cvar 'dog_size_influenced_health' default to 0
	if (autocvar_dog_size_influenced_health == 1)				// if 'dog_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_dog_health + ((self.scale - 1) * 100);	// default: 25
	else
		self.health = autocvar_dog_health;				// default 25
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_dog_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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
	
	
	if (self.monstermodel == 2)
		self.th_stand = dog_stand_newmodel1;
	else
		self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;

	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_spider_replace_dog)	// if dog shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_dog * 0.01;
		if (random () <= replacer)
			{
			self.skin = 7;
			self.health = autocvar_dog_health;		// default 25
			self.scale = 1;
			setsize (self, '-32 -32 -24', '32 32 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_spider_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_dog)		// if dog shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_dog * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_dog_health;		// default 25
			self.scale = 1;
			setsize (self, '-32 -32 -24', '32 32 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

	walkmonster_start();

do_the_cloning();

if (autocvar_afrit_supports_dog)		// if afrit shall be spawned in ADDITION to an existing dog. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_dog * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_dogmass = 1000;
MonsterPhysics (self, autocvar_dogmass);
};


///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////  below code added by Seven  //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/*
==============================================================================

Creates "Vengeance of the deceased" effect.    

Modelname and Modelframe is taken from call after regular death animations:    
void(string modelname, float modelframe) vengeance;
Example: 
vengeance ("progs/soldier.mdl", $death10);

This function must be declared at the end of defs.qc:
void(string modelname, float modelframe) vengeance_dog; 

==============================================================================
*/


void() vengeance_dog_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_dog_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

      local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

            T_Damage (self.enemy, self, self, ldmg);      	// analog to meele attack dog/fiend
//          T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;   // um nicht endlos damage zu kriegen !

		self.think = vengeance_dog_end1; 
		self.nextthink = time + 0.1;  
};


										//  from here on: run sequence. 

void() vengeance_dog_run1 =[	$run1,	vengeance_dog_run2 ]   {
	ai_face();
 	movetogoal (24);  	// orig (16)
self.touch = vengeance_dog_touch;  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog_run2 =[	$run2,	vengeance_dog_run3 ]   {
	ai_face();
 	movetogoal (40); 		// orig (32)
self.touch = vengeance_dog_touch;  
	self.alpha = 0.34;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog_run3 =[	$run3,	vengeance_dog_jump1 ]    {
	ai_face();
 	movetogoal (40); 		// orig (32)
self.touch = vengeance_dog_touch;  
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


										//  from here on: attack/jump sequenz. 

void() vengeance_dog_jump1 =[	$leap1,	vengeance_dog_jump2 ]    {
	ai_face();
	movetogoal (24); 		// orig (0)
self.touch = vengeance_dog_touch;  
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog_jump2 =[	$leap2,	vengeance_dog_jump3 ]    {
	ai_face();
 	movetogoal (32); 		// orig (0)
self.touch = vengeance_dog_touch;  
sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog_jump3 =[	$leap3,	vengeance_dog_jump4 ]    {
	ai_face();
 	movetogoal (32); 
self.touch = vengeance_dog_touch;  
	self.alpha = 0.12;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog_jump4 =[	$leap4,	vengeance_dog_end1 ]    {
	ai_face();
self.touch = vengeance_dog_touch;  
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 210 + '0 0 70';
	self.alpha = 0.07;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


									//  from here on: ressurection sequence 1. 

void() vengeance_dog11 =[	$death8,	vengeance_dog12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog12 =[	$death7,	vengeance_dog13 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog13 =[	$death6,	vengeance_dog14 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog14 =[	$death5,	vengeance_dog15 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog15 =[	$death4,	vengeance_dog16 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog16 =[	$death3,	vengeance_dog17 	]  {
sound (self, CHAN_WEAPON, "dog/dsight.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog17 =[	$death2,	vengeance_dog18 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog18 =[	$death1,	vengeance_dog_run1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


									//  from here on: ressurection sequence 2. 

void() vengeance_dog21 =[	$deathb8,	vengeance_dog22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog22 =[	$deathb7,	vengeance_dog23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog23 =[	$deathb6,	vengeance_dog24 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog24 =[	$deathb5,	vengeance_dog25 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog25 =[	$deathb4,	vengeance_dog26 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog26 =[	$deathb3,	vengeance_dog27 	]  {
sound (self, CHAN_WEAPON, "dog/dsight.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog27 =[	$deathb2,	vengeance_dog28 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dog28 =[	$deathb1,	vengeance_dog_run1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_dog_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death9)
			self.think = vengeance_dog11;
		else
			self.think = vengeance_dog21;
};
void()	vengeance_dog_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_dog_bright05;
};
void()	vengeance_dog_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_dog_bright04;
};
void()	vengeance_dog_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_dog_bright03;
}; 
void()	vengeance_dog_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_dog_bright02;
};
void()	vengeance_dog_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_dog_bright01;
};



void(string modelname, float modelframe) vengeance_dog =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
      
	if (self.monstermodel == 0)  
		setmodel (self, "progs/dog.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/dog1.mdl"); 
	else if (self.monstermodel == 2)  
		setmodel (self, "progs/dog_extended.mdl"); 

	setsize (self, '-32 -32 -24', '32 32 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  // if value is NOT "0", player get hurt from this effect (see func "vengeance_dog_touch")!

	vengeance_dog_bright00 ();			  // starts the animation
};

