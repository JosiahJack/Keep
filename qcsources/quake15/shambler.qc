/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/shams
$origin 0 0 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame	run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6 axdeth7 axdeth8 axdeth9
$frame axdeth10 axdeth11 axdeth12 axdeth13 axdeth14 axdeth15 axdeth16 axdeth17
$frame axdeth18 axdeth19 axdeth20 axdeth21 axdeth22 axdeth23 axdeth24 axdeth25
$frame axdeth26 axdeth27 axdeth28 axdeth29 axdeth30 axdeth31 axdeth32 axdeth33
$frame axdeth34 axdeth35 axdeth36 axdeth37 axdeth38

void(float loudness, float side) shambler_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound7(self, CHAN_AUTO, "walk/shambler1.wav", loudness, ATTN_IDLE, SNDSPD);
	else if (select <= 0.66)
		sound7(self, CHAN_AUTO, "walk/shambler2.wav", loudness, ATTN_IDLE, SNDSPD);
	else 
		sound7(self, CHAN_AUTO, "walk/shambler3.wav", loudness, ATTN_IDLE, SNDSPD);

	if (side && (autocvar_shambler_walking_quake >= 2))
		{
		makevectors (self.angles);
		if (side == 1)		// left foot
			pointparticles(particleeffectnum("shambler_foot_dust"), self.origin + self.view_ofs + v_up * -40 + v_forward*7 + v_right*-22, '0 0 0', 1);
		else			// right foot
			pointparticles(particleeffectnum("shambler_foot_dust"), self.origin + self.view_ofs + v_up * -40 + v_forward*7 + v_right*22, '0 0 0', 1);
		}
		
	if ((loudness > 0.8) && ((autocvar_shambler_walking_quake == 1) || (autocvar_shambler_walking_quake == 3)))
		shambler_walking_quake ();
	}
};


void() sham_stand1	=[	$stand1,	sham_stand2	] {ai_stand();};
void() sham_stand2	=[	$stand2,	sham_stand3	] {ai_stand();};
void() sham_stand3	=[	$stand3,	sham_stand4	] {ai_stand();};
void() sham_stand4	=[	$stand4,	sham_stand5	] {ai_stand();};
void() sham_stand5	=[	$stand5,	sham_stand6	] {ai_stand();};
void() sham_stand6	=[	$stand6,	sham_stand7	] {ai_stand();};
void() sham_stand7	=[	$stand7,	sham_stand8	] {ai_stand();};
void() sham_stand8	=[	$stand8,	sham_stand9	] {ai_stand();};
void() sham_stand9	=[	$stand9,	sham_stand10] {ai_stand();};
void() sham_stand10	=[	$stand10,	sham_stand11] {ai_stand();};
void() sham_stand11	=[	$stand11,	sham_stand12] {ai_stand();};
void() sham_stand12	=[	$stand12,	sham_stand13] {ai_stand();};
void() sham_stand13	=[	$stand13,	sham_stand14] {ai_stand();};
void() sham_stand14	=[	$stand14,	sham_stand15] {ai_stand();};
void() sham_stand15	=[	$stand15,	sham_stand16] {ai_stand();};
void() sham_stand16	=[	$stand16,	sham_stand17] {ai_stand();};
void() sham_stand17	=[	$stand17,	sham_stand1	] {ai_stand();};

void() sham_walk1	=[      $walk1,        sham_walk2 ] {ai_walk(10); shambler_footsteps (0.9, 2);};
void() sham_walk2       =[      $walk2,        sham_walk3 ] {ai_walk(9);};
void() sham_walk3       =[      $walk3,        sham_walk4 ] {ai_walk(9);};
void() sham_walk4       =[      $walk4,        sham_walk5 ] {ai_walk(5);};
void() sham_walk5       =[      $walk5,        sham_walk6 ] {ai_walk(6);};
void() sham_walk6       =[      $walk6,        sham_walk7 ] {ai_walk(12);};
void() sham_walk7       =[      $walk7,        sham_walk8 ] {ai_walk(8); shambler_footsteps (0.9, 1);};
void() sham_walk8       =[      $walk8,        sham_walk9 ] {ai_walk(3);};
void() sham_walk9       =[      $walk9,        sham_walk10] {ai_walk(13);};
void() sham_walk10      =[      $walk10,       sham_walk11] {ai_walk(9);};
void() sham_walk11      =[      $walk11,       sham_walk12] {ai_walk(7);};
void() sham_walk12      =[      $walk12,       sham_walk1 ] {ai_walk(7);
if (random() > 0.8)
	sound7(self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE, SNDSPD);};

void() sham_run1       =[      $run1,        sham_run2      ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);};
void() sham_run2       =[      $run2,        sham_run3      ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(24); shambler_footsteps (1, 2);};
void() sham_run3       =[      $run3,        sham_run4      ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);};
void() sham_run4       =[      $run4,        sham_run5      ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);};
void() sham_run5       =[      $run5,        sham_run6      ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(24); shambler_footsteps (1, 1);};
void() sham_run6       =[      $run6,        sham_run1      ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);
if (random() > 0.8)
	sound7(self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE, SNDSPD);
};

void() sham_smash1     =[      $smash1,       sham_smash2    ] {
sound7(self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM, SNDSPD);
ai_charge(2);};
void() sham_smash2     =[      $smash2,       sham_smash3    ] {ai_charge(6);};
void() sham_smash3     =[      $smash3,       sham_smash4    ] {ai_charge(6);};
void() sham_smash4     =[      $smash4,       sham_smash5    ] {ai_charge(5);};
void() sham_smash5     =[      $smash5,       sham_smash6    ] {ai_charge(4); shambler_footsteps (0.75, 0);};
void() sham_smash6     =[      $smash6,       sham_smash7    ] {ai_charge(1);};
void() sham_smash7     =[      $smash7,       sham_smash8    ] {ai_charge(0);};
void() sham_smash8     =[      $smash8,       sham_smash9    ] {ai_charge(0);};
void() sham_smash9     =[      $smash9,       sham_smash10   ] {ai_charge(0);};
void() sham_smash10    =[      $smash10,      sham_smash11   ] {
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(0);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;

    var float autocvar_shambler_size_influenced_attack = 0; 	  		// set cvar 'shambler_size_influenced_attack' default to 0
	if (autocvar_shambler_size_influenced_attack == 1)			// if 'shambler_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_shambler_doubleclaws * self.scale;	// default 40
	else
		ldmg = (random() + random() + random()) * autocvar_shambler_doubleclaws;		// default 40
	T_Damage (self.enemy, self, self, ldmg);
	sound7(self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM, SNDSPD);

	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
};
void() sham_smash11    =[      $smash11,      sham_smash12   ] {ai_charge(5);};
void() sham_smash12    =[      $smash12,      sham_run1	   ] {ai_charge(4);};

void() sham_swingr1;

void(float side) ShamClaw =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

    var float autocvar_shambler_size_influenced_attack = 0; 	  		// set cvar 'shambler_size_influenced_attack' default to 0
	if (autocvar_shambler_size_influenced_attack == 1)			// if 'shambler_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_shambler_claws * self.scale;	// default 20
	else
		ldmg = (random() + random() + random()) * autocvar_shambler_claws;		// default 20
	T_Damage (self.enemy, self, self, ldmg);
	sound7(self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM, SNDSPD);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void() sham_swingl1	=[      $swingl1,      sham_swingl2   ] {
sound7(self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM, SNDSPD);
ai_charge(5);};
void() sham_swingl2 =[      $swingl2,      sham_swingl3   ] {ai_charge(3);};
void() sham_swingl3 =[      $swingl3,      sham_swingl4   ] {ai_charge(7);};
void() sham_swingl4 =[      $swingl4,      sham_swingl5   ] {ai_charge(3);};
void() sham_swingl5 =[      $swingl5,      sham_swingl6   ] {ai_charge(7);};
void() sham_swingl6 =[      $swingl6,      sham_swingl7   ] {ai_charge(9);};
void() sham_swingl7 =[      $swingl7,      sham_swingl8   ] {ai_charge(5); ShamClaw(250);};
void() sham_swingl8 =[      $swingl8,      sham_swingl9   ] {ai_charge(4); shambler_footsteps (0.7, 0);};
void() sham_swingl9 =[      $swingl9,      sham_run1  ] {
ai_charge(8);
if (random()<0.5)
	self.think = sham_swingr1;
};

void() sham_swingr1	=[      $swingr1,      sham_swingr2   ] {
sound7(self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM, SNDSPD);
ai_charge(1);};
void() sham_swingr2	=[      $swingr2,      sham_swingr3   ] {ai_charge(8);};
void() sham_swingr3 =[      $swingr3,      sham_swingr4   ] {ai_charge(14);};
void() sham_swingr4 =[      $swingr4,      sham_swingr5   ] {ai_charge(7);};
void() sham_swingr5 =[      $swingr5,      sham_swingr6   ] {ai_charge(3);};
void() sham_swingr6 =[      $swingr6,      sham_swingr7   ] {ai_charge(6);};
void() sham_swingr7 =[      $swingr7,      sham_swingr8   ] {ai_charge(6); ShamClaw(-250);};
void() sham_swingr8 =[      $swingr8,      sham_swingr9   ] {ai_charge(3);};
void() sham_swingr9 =[      $swingr9,      sham_run1  	  ] {ai_charge(1); shambler_footsteps (0.7, 0);
ai_charge(10);
if (random()<0.5)
	self.think = sham_swingl1;
};

void() sham_melee =
{
	local float chance;
	
	chance = random();
	if (chance > 0.6 || self.health == 600)
		sham_smash1 ();
	else if (chance > 0.3)
		sham_swingr1 ();
	else
		sham_swingl1 ();
};


//============================================================================


/*
=====================
FireShamblerLightning
=====================
*/

void() ShamblerLightning_Touch =
{
	if (other.health)
		pointparticles(particleeffectnum("shambler_beam_impact"), self.origin, '0 0 0', 1);
	else
		pointparticles(particleeffectnum("shambler_beam_impact1"), self.origin, '0 0 0', 1);
		
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.05;
	self.think = SUB_Remove;
};


void() FireShamblerLightning =		// single lighnting beam from belly !
{
	local entity missile;
	local vector org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "shamblerbeam";
	
	org = self.origin + v_right * 1 + v_up * 24 + v_forward * 15;

	makevectors (self.angles);
	missile.velocity = normalize ((self.enemy.origin + '0 0 10') - org);
	missile.velocity = missile.velocity * 9999999;

	missile.scale = 0.1;
	missile.alpha = -1;

	missile.touch = ShamblerLightning_Touch;
	
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/k_spike.mdl");
	setsize (missile, '0 0 0', '0 0 0');	

	missile.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile, org);
};


////////////////////////////////
//  double (hands) beam effect:
////////////////////////////////

void() sham_magic6;
void() sham_magic9;
void() sham_magic10;
void() sham_magic11;
void() sham_magic12;

void() FireShamblerLightning_right1 =
{
	local entity missile1;
	local vector org1;
	
	missile1 = spawn ();
	missile1.owner = self;
	missile1.movetype = MOVETYPE_FLYMISSILE;
	missile1.solid = SOLID_BBOX;
	missile1.classname = "shamblerbeam1";
		
	org1 = self.origin + v_right * 60 + v_up * 21 + v_forward * 15;

	makevectors (self.angles);
	missile1.velocity = normalize ((self.enemy.origin + '0 0 10') - org1);
	missile1.velocity = missile1.velocity * 9999999;

	missile1.scale = 0.1;
	missile1.alpha = -1;

	missile1.touch = ShamblerLightning_Touch;
	
	missile1.nextthink = time + 1;
	missile1.think = SUB_Remove;

	setmodel (missile1, "progs/k_spike.mdl");
	setsize (missile1, '0 0 0', '0 0 0');	

	missile1.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile1, org1);

	self.nextthink = time + 0.1;
	self.think = sham_magic6;
};


void() FireShamblerLightning_right2 =
{
	local entity missile1;
	local vector org1;
	
	missile1 = spawn ();
	missile1.owner = self;
	missile1.movetype = MOVETYPE_FLYMISSILE;
	missile1.solid = SOLID_BBOX;
	missile1.classname = "shamblerbeam1";
		
	org1 = self.origin + v_right * 60 + v_up * 21 + v_forward * 15;

	makevectors (self.angles);
	missile1.velocity = normalize ((self.enemy.origin + '0 0 10') - org1);
	missile1.velocity = missile1.velocity * 9999999;

	missile1.scale = 0.1;
	missile1.alpha = -1;

	missile1.touch = ShamblerLightning_Touch;
	
	missile1.nextthink = time + 1;
	missile1.think = SUB_Remove;

	setmodel (missile1, "progs/k_spike.mdl");
	setsize (missile1, '0 0 0', '0 0 0');	

	missile1.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile1, org1);

	self.nextthink = time + 0.1;
	self.think = sham_magic9;
};


void() FireShamblerLightning_right3 =
{
	local entity missile1;
	local vector org1;
	
	missile1 = spawn ();
	missile1.owner = self;
	missile1.movetype = MOVETYPE_FLYMISSILE;
	missile1.solid = SOLID_BBOX;
	missile1.classname = "shamblerbeam1";
		
	org1 = self.origin + v_right * 60 + v_up * 21 + v_forward * 15;

	makevectors (self.angles);
	missile1.velocity = normalize ((self.enemy.origin + '0 0 10') - org1);
	missile1.velocity = missile1.velocity * 9999999;

	missile1.scale = 0.1;
	missile1.alpha = -1;

	missile1.touch = ShamblerLightning_Touch;
	
	missile1.nextthink = time + 1;
	missile1.think = SUB_Remove;

	setmodel (missile1, "progs/k_spike.mdl");
	setsize (missile1, '0 0 0', '0 0 0');	

	missile1.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile1, org1);

	self.nextthink = time + 0.1;
	self.think = sham_magic10;
};


void() FireShamblerLightning_right4 =
{
	local entity missile1;
	local vector org1;
	
	missile1 = spawn ();
	missile1.owner = self;
	missile1.movetype = MOVETYPE_FLYMISSILE;
	missile1.solid = SOLID_BBOX;
	missile1.classname = "shamblerbeam1";
		
	org1 = self.origin + v_right * 60 + v_up * 21 + v_forward * 15;

	makevectors (self.angles);
	missile1.velocity = normalize ((self.enemy.origin + '0 0 10') - org1);
	missile1.velocity = missile1.velocity * 9999999;

	missile1.scale = 0.1;
	missile1.alpha = -1;

	missile1.touch = ShamblerLightning_Touch;
	
	missile1.nextthink = time + 1;
	missile1.think = SUB_Remove;

	setmodel (missile1, "progs/k_spike.mdl");
	setsize (missile1, '0 0 0', '0 0 0');	

	missile1.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile1, org1);

	self.nextthink = time + 0.1;
	self.think = sham_magic11;
};


void() FireShamblerLightning_right5 =
{
	local entity missile1;
	local vector org1;
	
	missile1 = spawn ();
	missile1.owner = self;
	missile1.movetype = MOVETYPE_FLYMISSILE;
	missile1.solid = SOLID_BBOX;
	missile1.classname = "shamblerbeam1";
		
	org1 = self.origin + v_right * 60 + v_up * 21 + v_forward * 15;

	makevectors (self.angles);
	missile1.velocity = normalize ((self.enemy.origin + '0 0 10') - org1);
	missile1.velocity = missile1.velocity * 9999999;

	missile1.scale = 0.1;
	missile1.alpha = -1;

	missile1.touch = ShamblerLightning_Touch;
	
	missile1.nextthink = time + 1;
	missile1.think = SUB_Remove;

	setmodel (missile1, "progs/k_spike.mdl");
	setsize (missile1, '0 0 0', '0 0 0');	

	missile1.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile1, org1);

	self.nextthink = time + 0.1;
	self.think = sham_magic12;
};


void(float nummer) FireShamblerLightning_left =
{
	local entity missile;
	local vector org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "shamblerbeam";
	
	org = self.origin + v_right * -47 + v_up * 17 + v_forward * 15;

	makevectors (self.angles);
	missile.velocity = normalize ((self.enemy.origin + '0 0 10') - org);
	missile.velocity = missile.velocity * 9999999;

	missile.scale = 0.1;
	missile.alpha = -1;

	missile.touch = ShamblerLightning_Touch;
	
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/k_spike.mdl");
	setsize (missile, '0 0 0', '0 0 0');	

	missile.traileffectnum = particleeffectnum("shambler_beam");
	
	setorigin (missile, org);

	self.nextthink = time + 0.001;

	if (nummer == 1)
		self.think = FireShamblerLightning_right1;
	else if (nummer == 2)
		self.think = FireShamblerLightning_right2;
	else if (nummer == 3)
		self.think = FireShamblerLightning_right3;
	else if (nummer == 4)
		self.think = FireShamblerLightning_right4;
	else if (nummer == 5)
		self.think = FireShamblerLightning_right5;
};


void(float hurt, float nummer) CastLightning =
{
	local	vector	org, dir;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

	org = self.origin + '0 0 40';

	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	traceline (org, self.origin + dir*600, TRUE, self);

	if (autocvar_shambler_lightning_beam == 1)
		FireShamblerLightning ();
	else if (autocvar_shambler_lightning_beam == 2)
		FireShamblerLightning_left (nummer);
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
		
	}
	
	if (hurt)
	{
		var float autocvar_shambler_size_influenced_attack = 0;   		// set cvar 'shambler_size_influenced_attack' default to 0
		if (autocvar_shambler_size_influenced_attack == 1)			// if 'shambler_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
			LightningDamage (org, trace_endpos, self, autocvar_shambler_lightning * self.scale);	// default 10
		else
			LightningDamage (org, trace_endpos, self, autocvar_shambler_lightning);		// default 10
	}
};

void() sham_magic1     =[      $magic1,       sham_magic2    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
	sound7(self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM, SNDSPD);
};
void() sham_magic2     =[      $magic2,       sham_magic3    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() sham_magic3     =[      $magic3,       sham_magic4    ] {ai_face();self.nextthink = self.nextthink + 0.2;
self.effects = self.effects | EF_MUZZLEFLASH;
ai_face();
// starting from here: New shambler magic attack effects
local entity ball;
local vector org;
ball = spawn();
setmodel (ball, "progs/plasma.mdl");
ball.solid = SOLID_BBOX;
ball.movetype = MOVETYPE_FLY;
setsize (ball, '0 0 0', '0 0 0');
makevectors (self.angles);

var float autocvar_shamblertype = 0;     	// set cvar 'shamblertype' default to 0
	if (autocvar_shamblertype == 1)		// if 'shamblertype' is set via autoexec.cfg to '1' use magic attack spawn position for Andrew Joll model
	{
		org = self.origin + v_up*78 + v_right*15 + v_forward*22;
		setorigin (ball, org);
		ball.scale = 1.6;
	}
	else if (autocvar_shamblertype == 2)	// if 'shamblertype' is set via autoexec.cfg to '2' use magic attack spawn position for FredrikH model
	{					
		org = self.origin + v_up*71 + v_right*5 + v_forward*15;
		setorigin (ball, org);
		ball.scale = 1.6;
	}
	else if (autocvar_shamblertype == 3)	// if 'shamblertype' is '3' use magic attack spawn position for ID1 OR Andrew Joll model
		{
			if (self.model == "progs/shambler.mdl")  // model is ID1 type
				{
					org = self.origin + v_up*78 + v_right*22 + v_forward*15;
					setorigin (ball, org);
					ball.scale = 1.9;
				}
			else if (self.model == "progs/shambler1.mdl")  // model is Andrew Joll type	
				{
					org = self.origin + v_up*78 + v_right*15 + v_forward*22;
					setorigin (ball, org);
					ball.scale = 1.6;
				}
		}
	else	// if 'shamblertype' is set to '0' or any other value, use magic attack spawn position for ID1 model
	{
		org = self.origin + v_up*78 + v_right*22 + v_forward*15;
		setorigin (ball, org);
		ball.scale = 1.9;
	}
	
ball.alpha = 0.5;
ball.avelocity = '700 600 900';
pointparticles(particleeffectnum("shambler_ball"), org, '0 0 0', 1);
ball.nextthink = time + 0.45;
ball.think = SUB_Remove;
};
void() sham_magic4     =[      $magic4,       sham_magic5    ]
{self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
//self.effects = self.effects | EF_MUZZLEFLASH;
//self.owner.frame = 1; 
shambler_footsteps (0.8, 0);
};
void() sham_magic5     =[      $magic5,       sham_magic6    ] 
{self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
//self.effects = self.effects | EF_MUZZLEFLASH;
//self.owner.frame = 2;
if (autocvar_shambler_lightning_beam)
	CastLightning(0,1);
};
void() sham_magic6     =[      $magic6,       sham_magic9    ]
{self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
//remove (self.owner);
CastLightning(1,2);
pointparticles(particleeffectnum("shambler_body"), self.origin + v_up*30, '0 0 0', 1);
sound7(self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM, SNDSPD);
};
void() sham_magic9     =[      $magic9,       sham_magic10   ]
{self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
CastLightning(1,3);
};
void() sham_magic10    =[      $magic10,      sham_magic11   ]
{self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
CastLightning(1,4);
};
void() sham_magic11    =[      $magic11,      sham_magic12   ]
{self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
if (skill == 3)
	CastLightning(1,5);
};
void() sham_magic12    =[      $magic12,      sham_run1	   ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};



void() sham_pain1       =[      $pain1, sham_pain2      ] {};
void() sham_pain2       =[      $pain2, sham_pain3      ] {};
void() sham_pain3       =[      $pain3, sham_pain4      ] {};
void() sham_pain4       =[      $pain4, sham_pain5      ] {};
void() sham_pain5       =[      $pain5, sham_pain6      ] {};
void() sham_pain6       =[      $pain6, sham_run1      ] {};

void(entity attacker, float damage)	sham_pain =
{
	sound7(self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM, SNDSPD);

	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (random()*400 > damage)
		return;		// didn't flinch

	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 2;

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_shambler * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	sham_pain1 ();
};

var float autocvar_shambler = 3;     		// set cvar 'shambler' default to 3
var float autocvar_shamblercorpsehealth = 60;	// set cvar 'shamblercorpsehealth' default to 60

//============================================================================


void() sham_dieburn1	=[	$death1,	sham_dieburn2	] {self.burnz_origin = 14;
burn_toggle_shambler();
};
void() sham_dieburn2	=[	$death2,	sham_dieburn3	] {self.burnz_origin = 12;
};
void() sham_dieburn3	=[	$death3,	sham_dieburn4	] {self.burnz_origin = 8;
self.solid = SOLID_NOT;
};
void() sham_dieburn4	=[	$death4,	sham_dieburn5	] {self.burnz_origin = 5;
};
void() sham_dieburn5	=[	$death5,	sham_dieburn6	] {self.burnz_origin = 1;
};
void() sham_dieburn6	=[	$death6,	sham_dieburn7	] {self.burnz_origin = -2;
};
void() sham_dieburn7	=[	$death7,	sham_dieburn8	] {self.burnz_origin = -4;
};
void() sham_dieburn8	=[	$death8,	sham_dieburn9	] {self.burnz_origin = -6;
};
void() sham_dieburn9	=[	$death9,	sham_dieburn10	] {self.burnz_origin = -6;
};
void() sham_dieburn10	=[	$death10,	sham_dieburn10	] {self.burnz_origin = -10;
};

//axe death

void() sham_axdeth1      =[      $axdeth1,       sham_axdeth2     ] {};
void() sham_axdeth2      =[      $axdeth2,       sham_axdeth3     ] {sound7(self, CHAN_VOICE, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);};
void() sham_axdeth3      =[      $axdeth3,       sham_axdeth4     ] {self.solid = SOLID_NOT; // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_blast"), self.origin, '0 0 0', 1);};
void() sham_axdeth4      =[      $axdeth4,       sham_axdeth5     ] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD); // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth5      =[      $axdeth5,       sham_axdeth6     ] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void() sham_axdeth6      =[      $axdeth6,       sham_axdeth7     ] { // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth7      =[      $axdeth7,       sham_axdeth8     ] { // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth8      =[      $axdeth8,       sham_axdeth9     ] { // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth9      =[      $axdeth9,       sham_axdeth10    ] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD); // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth10     =[      $axdeth10,       sham_axdeth11   ] {};
void() sham_axdeth11     =[      $axdeth11,       sham_axdeth12   ] {};
void() sham_axdeth12     =[      $axdeth12,       sham_axdeth13   ] {};
void() sham_axdeth13     =[      $axdeth13,       sham_axdeth14   ] {};
void() sham_axdeth14     =[      $axdeth14,       sham_axdeth15   ] {};
void() sham_axdeth15     =[      $axdeth15,       sham_axdeth16   ] {sound7(self, CHAN_VOICE, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void() sham_axdeth16     =[      $axdeth16,       sham_axdeth17   ] { // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth17     =[      $axdeth17,       sham_axdeth18   ] {};
void() sham_axdeth18     =[      $axdeth18,       sham_axdeth19   ] {};
void() sham_axdeth19     =[      $axdeth19,       sham_axdeth20   ] {};
void() sham_axdeth20     =[      $axdeth20,       sham_axdeth21   ] {};
void() sham_axdeth21     =[      $axdeth21,       sham_axdeth22   ] {};
void() sham_axdeth22     =[      $axdeth22,       sham_axdeth23   ] {};
void() sham_axdeth23     =[      $axdeth23,       sham_axdeth24   ] {};
void() sham_axdeth24     =[      $axdeth24,       sham_axdeth25   ] {};
void() sham_axdeth25     =[      $axdeth25,       sham_axdeth26   ] {};
void() sham_axdeth26     =[      $axdeth26,       sham_axdeth27   ] { // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void() sham_axdeth27     =[      $axdeth27,       sham_axdeth28   ] {pointparticles (particleeffectnum("shambler_falling_dust"), self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "demon/fall_backwards.wav", 1, ATTN_NORM, SNDSPD);};
void() sham_axdeth28     =[      $axdeth28,       sham_axdeth29   ] {};
void() sham_axdeth29     =[      $axdeth29,       sham_axdeth30   ] {};
void() sham_axdeth30     =[      $axdeth30,       sham_axdeth31   ] {};
void() sham_axdeth31     =[      $axdeth31,       sham_axdeth32   ] {};
void() sham_axdeth32     =[      $axdeth32,       sham_axdeth33   ] {};
void() sham_axdeth33     =[      $axdeth33,       sham_axdeth34   ] {};
void() sham_axdeth34     =[      $axdeth34,       sham_axdeth35   ] {};
void() sham_axdeth35     =[      $axdeth35,       sham_axdeth36   ] {};
void() sham_axdeth36     =[      $axdeth36,       sham_axdeth37   ] {};
void() sham_axdeth37     =[      $axdeth37,       sham_axdeth38   ] {pointparticles (particleeffectnum("shambler_falling_dust"), self.origin, '0 0 0', 1);
Monster_Animation_EarthQuake (20, 377);
sound7(self, CHAN_AUTO, "shambler/fall.wav", 1, ATTN_NORM, SNDSPD);};
void() sham_axdeth38     =[      $axdeth38,       sham_axdeth38   ] {
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_shamblercorpsehealth, "progs/h_shams.mdl");};
//Above is corpse gibbing code - FIND CORPSE



void() sham_death1      =[      $death1,       sham_death2     ] {};
void() sham_death2      =[      $death2,       sham_death3     ] {};
void() sham_death3      =[      $death3,       sham_death4     ] {self.solid = SOLID_NOT;};
void() sham_death4      =[      $death4,       sham_death5     ] {};
void() sham_death5      =[      $death5,       sham_death6     ] {};
void() sham_death6      =[      $death6,       sham_death7     ] {};
void() sham_death7      =[      $death7,       sham_death8     ] {};
void() sham_death8      =[      $death8,       sham_death9     ] {};
void() sham_death9      =[      $death9,       sham_death10    ] {};
void() sham_death10     =[      $death10,      sham_death11    ] {
pointparticles (particleeffectnum("shambler_falling_dust"), self.origin, '0 0 0', 1);
Monster_Animation_EarthQuake (20, 377);
sound7(self, CHAN_AUTO, "shambler/fall.wav", 1, ATTN_NORM, SNDSPD);
};
void() sham_death11     =[      $death11,      sham_death11    ] {
if (self.inflamed == 1)
{
	self.colormod = '0.25 0.17 0.17';	  // skins gets darker (looks burned)
	self.alpha = 1;
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_shamblercorpsehealth, "progs/h_shams.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_shamblercorpsehealth, "progs/h_shams1.mdl");
	return;
}
local float zufall, zet, randomness;
	zet = 33;					// z-position of the wings (in relation to soul). Dependent on corpse size.
// 	auto_cvar 'shamblercorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_shamblercorpsehealth, "progs/h_shams.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_shamblercorpsehealth, "progs/h_shams1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'shambler' has been declared in code above already
	var float autocvar_shamblerrandomness = 40;     	// set cvar 'shamblerrandomness' default to 40%
	autocvar_shamblerrandomness = autocvar_shamblerrandomness * 0.01;
	if (autocvar_shambler == 1)		// if 'shambler' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_shamblerrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_shambler == 2)	// if 'shambler' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_shamblerrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/shambler.mdl", $death11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/shambler1.mdl", $death11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_shambler == 3)	// if 'shambler' doesnt exist in autoexec.cfg, or if 'shambler' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_shamblerrandomness)	// checks if death animation shall be started
			vengeance_shambler ("progs/shambler.mdl", $death11);
		}
	else if (autocvar_shambler == 5)	// if 'shambler' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_shamblerrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/shambler.mdl", $death11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/shambler1.mdl", $death11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_shambler ("progs/shambler.mdl", $death11);
			}
		}
	else				// if 'shambler' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/shambler.mdl", $death11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/shambler1.mdl", $death11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_shambler ("progs/shambler.mdl", $death11);
	}
};


void(float maxgibs, float gibscounter) producegibs_shambler =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib_shfoot2.mdl", self.health);
	ThrowGib ("progs/gib_shclaw1.mdl", self.health);   
	ThrowGib ("progs/gib_shclaw2.mdl", self.health);
	ThrowGib ("progs/gib_shfoot1.mdl", self.health);	
	}
gibscounter = gibscounter + 1;
producegibs_shambler (maxgibs, gibscounter);
};

void()	shambler_lightning_death	=[	$pain4,	shambler_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	shambler_lightning_death1	=[	$pain4,	shambler_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_shams.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_shams1.mdl");
};


void() sham_die;
void() sham_inflamed7;

void() sham_inflamed1 =[$run1, sham_inflamed2] {ai_run_inflamed(20);
local float r;
r = random();
if (r < 0.4)
	sound7(self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM, SNDSPD);
else if (r < 0.82)
	sound7(self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM, SNDSPD);
};
void() sham_inflamed2 =[$run2, sham_inflamed3] {ai_run_inflamed(24); shambler_footsteps (1, 2);};
void() sham_inflamed3 =[$run3, sham_inflamed4] {ai_run_inflamed(20);};
void() sham_inflamed4 =[$run4, sham_inflamed5] {ai_run_inflamed(20);};
void() sham_inflamed5 =[$run5, sham_inflamed6] {ai_run_inflamed(24); shambler_footsteps (1, 1);};
void() sham_inflamed6 =[$run6, sham_inflamed1] {ai_run_inflamed(20);
if (self.inflametime < time)
{
	sham_die ();
	return;
}
if (random() < 0.4)
	sham_inflamed7 ();	// start pain anim
};

void() sham_inflamed7 =[$pain1, sham_inflamed8] {self.nextthink = time + 0.09;
local float r;
r = random();
if (r < 0.4)
	sound7(self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM, SNDSPD);
else if (r < 0.85)
	sound7(self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM, SNDSPD);
};
void() sham_inflamed8 =[$pain2, sham_inflamed9] {self.nextthink = time + 0.09;};
void() sham_inflamed9 =[$pain3, sham_inflamed10] {self.nextthink = time + 0.09;};
void() sham_inflamed10 =[$pain4, sham_inflamed11] {self.nextthink = time + 0.09;};
void() sham_inflamed11 =[$pain5, sham_inflamed12] {self.nextthink = time + 0.09;};
void() sham_inflamed12 =[$pain6, sham_inflamed1] {self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	sham_die ();
	return;
}
};



void() sham_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))		// when enemy was killed with lightning gun, go into baked mode
		{
			shambler_lightning_death();
			return;
		}
	}
	else if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
	{
		lg_death1();
		return;
	}
	
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -60)
	{
		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_shambler * 0.01))
				{
				the_matrix = 1;
				SNDSPD = 70;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		play_gibsound();
		
		//5 randomized blood droplets that drip if stuck to the ceiling
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
		//Comment below section to stop gibsmultiplier from overriding unique gib models
			/*if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_shams.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_shams1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}*/
			//else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				//{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_shams.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_shams1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				gibdeath_effects();
				producegibs_shambler (maxgibs, gibscounter);
				return;
				//}
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0)		// enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER) && (self.enemy.meleeing == 0))	// when enemy was killed with explosives, set it on fire
			{
				self.delete_painskin = 1;	// remove painskin
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				sham_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound7(self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM, SNDSPD);
			sham_death1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'shambler' has been declared in code above already
var float autocvar_shamblerrandomness = 40;     	// set cvar 'shamblerrandomness' default to 40%
autocvar_shamblerrandomness = autocvar_shamblerrandomness * 0.01;
if (autocvar_shambler == 4)		// if 'shambler' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_shamblerrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		sham_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_shambler == 6)		// if 'shambler' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_shamblerrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			sham_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'shambler' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_shambler * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound7(self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM, SNDSPD);
	sham_death1 ();
	//FATALITIES
	
	if (self.enemy.meleeing == 0) //check before all fatalities to make sure attack type is not a kick
	{
		
	/*	if (self.enemy.weapon == IT_SUPER_SHOTGUN)
		{
		if (random() <= 0.5)
			{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				//ThrowGib ("progs/w_enforcergun.mdl", self.health);
				/*if (self.model == "progs/soldier.mdl")
					{
					ThrowGib ("progs/h_guardbl.mdl", self.health);
					}
				else
					{
					ThrowGib ("progs/h_guard1bl.mdl", self.health);
					}
							
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/enforcerblast.mdl");
				enf_diessg1();
			}
		}*/
	/*	if (self.enemy.weapon == IT_NAILGUN)
		{
		if (random() <= 0.5)
			{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);
				//ThrowGib ("progs/w_enforcergun.mdl", self.health);
				//if (self.model == "progs/soldier.mdl")
				//	{
				//	ThrowGib ("progs/h_guardbl.mdl", self.health);
				//	}
				//else
				//	{
				//	ThrowGib ("progs/h_guard1bl.mdl", self.health);
				//	}
							
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/enforcernail.mdl");
				enf_dieng1();
			}
		}*/
		if (self.enemy.weapon == IT_AXE || self.enemy.weapon == IT_CHAINSAW)
			{
				//if (random() < 0.5)
				//{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_blast"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/shambleraxe.mdl");
						self.skin = 0;
						
					}
					else
					{
						setmodel (self, self.model = "progs/shambleraxe.mdl");
						self.skin = 1;
						
					}
					
					sham_axdeth1();
					ThrowGib ("progs/chop.mdl", self.health);
				//}
			}
		}
};



//============================================================================




/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_shambler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	precache_model ("progs/plasma.mdl");
	
	precachegibs_shamb();

	precache_sound("shambler/sattck1.wav");
	precache_sound("shambler/sboom.wav");
	precache_sound("shambler/sdeath.wav");
	precache_sound("shambler/shurt2.wav");
	precache_sound("shambler/sidle.wav");
	precache_sound("shambler/ssight.wav");
	precache_sound("shambler/melee1.wav");
	precache_sound("shambler/melee2.wav");
	precache_sound("shambler/smack.wav");
	precache_sound("shambler/fall.wav");
	precache_sound("walk/shambler1.wav");
	precache_sound("walk/shambler2.wav");
	precache_sound("walk/shambler3.wav");
	
	precache_sound("demon/fall_backwards.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_shamblermultiskin = 0;     	// set cvar 'shamblermultiskin' default to 0
	local float zufall;
	if (autocvar_shamblermultiskin == 1)		// if 'shamblermultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/shambler.mdl");
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
	else if (autocvar_shamblermultiskin == 2)	// if 'shamblermultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/shambler1.mdl");
		precache_model ("progs/h_shams1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/shambler.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/shambler1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_shamblermultiskin == 3)	// if 'shamblermultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/shambler1.mdl");
		precache_model ("progs/h_shams1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/shambler.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/shambler.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/shambler1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_shamblermultiskin == 4)	// if 'shamblermultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/shambler1.mdl");
		precache_model ("progs/h_shams1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/shambler.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/shambler.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/shambler1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/shambler1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/shambler.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_shambler_size = 1;     		// set cvar 'shambler_size' default to 1
	local float zuffa;
	if (autocvar_shambler_size == 1)		// if 'shambler_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shambler_size == 2)		// if 'shambler_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shambler_size == 3)		// if 'shambler_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			self.sizediff = '0 0 7';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			setsize (self, VEC_HULL2_MIN - '0 0 3', VEC_HULL2_MAX - '0 0 3');
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shambler_size > 3)		// if 'shambler_size' is set via autoexec.cfg to a value bigger than '3' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_shambler_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_shambler_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_shambler_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	}

var float autocvar_shambler_size_influenced_health = 0; 		// set cvar 'shambler_size_influenced_health' default to 0
	if (autocvar_shambler_size_influenced_health == 1)		// if 'shambler_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_shambler_health * self.scale;	// default 600
	else
		self.health = autocvar_shambler_health;			// default 600
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_shambler_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_die = sham_die;
	self.th_melee = sham_melee;
	self.th_missile = sham_magic1;
	self.th_pain = sham_pain;
	
	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_yakman_replace_shambler)		// if shambler shall be replaced by Yakman. Check the chance and do it !!)
		{	
		local float replacerr;		
		replacerr = autocvar_yakman_replace_shambler * 0.01;
		if (random () <= replacerr)
			{
			self.health = autocvar_shambler_health;		// default 600
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_yakman_start();
			return;
			}
		}

	if (autocvar_carnivean_replace_shambler)	// if shambler shall be replaced by Carnivean. Check the chance and do it !!)
		{	
		local float replacerrr;		
		replacerrr = autocvar_carnivean_replace_shambler * 0.01;
		if (random () <= replacerrr)
			{
			self.health = autocvar_shambler_health;		// default 600
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_carnivean_start();
			return;
			}
		}

	if (autocvar_spider_replace_shambler)		// if shambler shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_shambler * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				var float autocvar_spider_replace_shambler_large  = 1;     	// set cvar 'spider_replace_shambler_large' default to 1.  Choose spider size, that replaces the shambler.  0= regular spider size  1= large spider size
				if (autocvar_spider_replace_shambler_large)
					{
					self.scale = 1;
					setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
					self.nextthink = time + 0.3;	
					self.think = SUB_Remove;
					monster_spider_shambler_start();
					}
				else
					{
					self.skin = 1;
					self.health = autocvar_shambler_health;		// default 600
					self.scale = 1;
					setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
					self.nextthink = time + 0.3;	
					self.think = SUB_Remove;
					monster_spider_start();
					}
				return;
				}
			}
		}

	if (autocvar_reiver_replace_shambler)		// if shambler shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_shambler * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_shambler_health;		// default 600
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_shambler)		// if shambler shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_shambler * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_shambler_health;		// default 600
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

	if (autocvar_painskin_transparency)
	{
		entity pain_skin_entity;

		pain_skin_entity = spawn();
		pain_skin_entity.solid = SOLID_NOT;
		pain_skin_entity.movetype = MOVETYPE_NOCLIP;	
		pain_skin_entity.owner = self;
		setmodel (pain_skin_entity,self.model);
		setsize (pain_skin_entity, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);	
		setorigin (pain_skin_entity, '0 0 0');
		pain_skin_entity.skin = self.skin;
		pain_skin_entity.colormod_x = self.colormod_x;
		pain_skin_entity.colormod_y = self.colormod_y;
		pain_skin_entity.colormod_z = self.colormod_z;
		pain_skin_entity.monstermodel = self.monstermodel;
		pain_skin_entity.frame = self.frame;	
		pain_skin_entity.alpha = autocvar_painskin_transparency;
		pain_skin_entity.think = pain_skin_entity_think;
		pain_skin_entity.nextthink = time;

		setattachment(pain_skin_entity, self, "test");	
	}

	walkmonster_start();

do_the_cloning();

if (autocvar_reiver_supports_shambler)		// if reiver shall be spawned in ADDITION to an existing shambler. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_shambler * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_shambler)		// if afrit shall be spawned in ADDITION to an existing shambler. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_shambler * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_shamblermass = 3700;
MonsterPhysics (self, autocvar_shamblermass);	

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
void(string modelname, float modelframe) vengeance_shambler; 

==============================================================================
*/


void() vengeance_shambler_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_shambler_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg); 	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;				// um nicht endlos damage zu kriegen !

	self.think = vengeance_shambler_end1; 
	self.nextthink = time + 0.1;   
};


void() vengeance_shambler_skull =			//  calls skull in skull.qc   
{
	local	vector	offang, org;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;   
	org_z = org_z + 47;   		 // to adjust spawning coordinate of skull. Depending on the monster it spawnes.

	launch_vengeance_skull (org); 	
	newmis.classname = "skull";
	setmodel (newmis, "progs/skull.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	

	newmis.scale = 0.9;		//  set size of the skull here.  Depending on the monster it spawnes. 

	precache_sound("vengeance/skull.wav");
	precache_sound("vengeance/skulltouch.wav");  	 
};


										//  from here on: run sequence. 

void() vengeance_shambler_run1 =[	$run1,	vengeance_shambler_run2 ]   {
	ai_face();
 	movetogoal (21);  // orig(20)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_run2 =[	$run2,	vengeance_shambler_run3 ]   {
	ai_face();
 	movetogoal (25);  // orig(24)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.35;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_run3 =[	$run3,	vengeance_shambler_run4 ]    {
	ai_face();
 	movetogoal (21);  // orig(20)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_run4 =[	$run4,	vengeance_shambler_run5 ]    {
	ai_face();
 	movetogoal (21);   // orig(20)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_run5 =[	$run5,	vengeance_shambler_random ]    {
	ai_face();
 	movetogoal (25);  	// orig (24)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


								//  from here on: attack/jump sequenz. 

void() vengeance_shambler_smash1 =[ $smash1,	vengeance_shambler_smash2 ]    {
	ai_face();
 	movetogoal (4);  	//  orig (2)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash2 =[ $smash2,	vengeance_shambler_smash3 ]    {
	ai_face();
 	movetogoal (8);   //  orig (6)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.18;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash3 =[ $smash3,	vengeance_shambler_smash4 ]    {
	ai_face();
 	movetogoal (8); 	//  orig (6)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.16;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash4 =[ $smash4,	vengeance_shambler_smash5 ]    {
	ai_face();
 	movetogoal (7);  //  orig (5)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash5 =[ $smash5,	vengeance_shambler_smash6 ]    {
	ai_face();
 	movetogoal (6);  //  orig (4)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.12;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash6 =[ $smash6,	vengeance_shambler_smash7 ]    {
	ai_face();
 	movetogoal (3);  //  orig (1)
self.touch = vengeance_shambler_touch;
	self.alpha = 0.1;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash7 =[ $smash8,	vengeance_shambler_smash8 ]    {  		// left out $smash7
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_smash8 =[ $smash9,	vengeance_shambler_end1 ]    {
	ai_face();
self.touch = vengeance_shambler_touch;
	sound7(self, CHAN_VOICE, "shambler/melee2.wav", 1, 4);
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 200 + '0 0 10';
	self.alpha = 0.06;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


								//  from here on: magic attack sequenz. 

void() vengeance_shambler_skull1 =[ $magic1,	vengeance_shambler_skull2 ]    {
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_skull2 =[ $magic2,	vengeance_shambler_skull3 ]    {
sound7(self, CHAN_VOICE, "vengeance/shamattck1.wav", 1, 4);
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_skull3 =[ $magic3,	vengeance_shambler_skull4 ]    {
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = self.nextthink + 0.2; 	
local entity o;
self.effects = self.effects | EF_MUZZLEFLASH;
self.owner = spawn();
o = self.owner;
setmodel (o, "progs/s_light.mdl");	
setorigin (o, self.origin);
o.angles = self.angles;	
o.colormod = '8 0 0';		// added 
o.alpha = 0.4;			// added 
o.nextthink = time + 0.5;
o.think = SUB_Remove;
};
void() vengeance_shambler_skull4 =[ $magic4,	vengeance_shambler_skull5 ]    {
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
self.effects = self.effects | EF_MUZZLEFLASH;
self.owner.frame = 1;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_skull5 =[ $magic5,	vengeance_shambler_skull6 ]    {
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
self.effects = self.effects | EF_MUZZLEFLASH;
self.owner.frame = 2;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler_skull6 =[ $magic6,	vengeance_shambler_end1 ]    {
remove (self.owner);
	ai_face();
self.touch = vengeance_shambler_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_shambler_skull();
};



void()	vengeance_shambler_random 	= {		// random final animation selection
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.01;
		if (random() > 0.47)
			self.think = vengeance_shambler_smash1; 
		else
			self.think = vengeance_shambler_skull1;
};



										//  from here on: ressurection sequenz. 

void() vengeance_shambler1 =[	$death10,	vengeance_shambler2 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler2 =[	$death9,	vengeance_shambler3 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler3 =[	$death8,	vengeance_shambler4 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler4 =[	$death7,	vengeance_shambler5 	]  {
sound7(self, CHAN_WEAPON, "vengeance/shamawake.wav", 1, ATTN_NORM, SNDSPD);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler5 =[	$death6,	vengeance_shambler6 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler6 =[	$death5,	vengeance_shambler7 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler7 =[	$death4,	vengeance_shambler8 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler8 =[	$death3,	vengeance_shambler9 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler9 =[	$death2,	vengeance_shambler10 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shambler10 =[	$death1,	vengeance_shambler_run1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_shambler_bright05	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = vengeance_shambler1;
};
void()	vengeance_shambler_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_shambler_bright05;
};
void()	vengeance_shambler_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_shambler_bright04;
};
void()	vengeance_shambler_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_shambler_bright03;
}; 
void()	vengeance_shambler_bright01	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_shambler_bright02;
};
void()	vengeance_shambler_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_shambler_bright01;
};



void(string modelname, float modelframe) vengeance_shambler =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_sound("vengeance/shamawake.wav");  	// precached in worldspawn() due to savegame-bug
//	precache_sound("vengeance/shamattck1.wav");   	// precached in worldspawn() due to savegame-bug
//	precache_model ("progs/skull.mdl"); 		// precached in worldspawn() due to savegame-bug

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/shambler.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/shambler1.mdl"); 

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  // if value is NOT "0", player get hurt from this effect (see func "vengeance_shambler_touch")!

	vengeance_shambler_bright00 ();	 // starts the animation
};
 