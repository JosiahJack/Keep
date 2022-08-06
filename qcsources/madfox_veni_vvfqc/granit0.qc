/*
=============================================================================

GRANITO

=============================================================================

New Quake1 monster, made by Madfox. Started on 29-07-07.
Purpose : make a Quake1 monster that compares the basic cube shape of Quark.
Model.mdl composed on a basic cube.dxf, adding the shambler and orgue parts.

changed files from the clean quake.qc:

ai.qc     -  line319 - 	else if (self.classname == "monster_granito")
		 sound (self, CHAN_VOICE, "granito/sight1.wav", 1, ATTN_NORM);
client.qc -  line1400 -	if (attacker.classname == "monster_granito")
		 bprint (" was smashed by el granito\n");
progs.scr -  line22 - granito.qc 

for excact placement take 0.25 off/grid towards outside standard 64x64x64cube
texturing skin0.bmp needs 125% normal quake.wad textures.

Changed the rise scene. as it tended to give the monster a wider swing than
pretended. Deleted the turn frames. 24-09-08. Madfox.

New setup, changed the animationframes into some more robuust monster then the 
cubical thing. Also hanged the death scene into a ruble explode. 
madfox05-05-09  deleted beat16/19 all death frames added run8


=============================================================================
*/

$cd /raid/quake/id1/models/granito
$scale 1
$origin 0 0 128
$base base
$skin base

$frame stand1

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10

$frame breez1 breez2 breez3 breez4 breez5 breez6 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb10 painb11 painb12

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9
$frame smash10 smash11 smash12

$frame beat1 beat2 beat3 beat4 beat5 beat6 beat7 beat8 beat9 beat10
$frame beat11 beat12 beat13 beat14 beat15 

$frame death1 

//==========================================================================

void(vector p) granito_missile;
void() Granito_MeleeAttack;
float() Granito_ChooseAttack;
void() granito_stand1;
void() granito_walk1;
void() granito_run1;
void() granito_die1;
void() granito_pain1;
void(entity attacker, float damage) granito_pain_decide;
void() granito_smash1;
void() granito_beat1; 

void() granito_face =
{
	
// go for another player if multi player
	if (self.enemy.health <= 0 || random() < 0.02)
	{
		self.enemy = find(self.enemy, classname, "player");
		if (!self.enemy)
			self.enemy = find(self.enemy, classname, "player");
	}
	ai_face();
};

void()      granito_stand1      =[    $stand1,    granito_rise1   ] {ai_face();};

void()      granito_rise1       =[    $rise1,     granito_rise2   ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "granito/idle1.wav", 1, ATTN_IDLE); 
    {
	ThrowGib ("progs/rock.mdl", self.health);
	return;
    }
};
void()      granito_rise2       =[    $rise2,     granito_rise3   ] {};
void()      granito_rise3       =[    $rise3,     granito_rise4   ] {
	ThrowGib ("progs/rock.mdl",self.health);
	return;
};
void()      granito_rise4       =[    $rise4,     granito_rise5   ] {};
void()      granito_rise5       =[    $rise5,     granito_rise6   ] {};
void()      granito_rise6       =[    $rise6,     granito_rise7   ] {
	ThrowGib ("progs/rock.mdl", self.health);
	return;
};
void()      granito_rise7       =[    $rise7,     granito_rise8   ] {};
void()      granito_rise8       =[    $rise8,     granito_rise9   ] {};
void()      granito_rise9       =[    $rise9,     granito_rise10  ] {};
void()      granito_rise10      =[    $rise10,    granito_breez1  ] {

       self.th_stand = granito_breez1;
       self.th_walk = granito_walk1;
       self.th_run = granito_run1;
       self.th_die = granito_die1; 
       self.th_melee = Granito_MeleeAttack;
       self.th_missile = Granito_ChooseAttack;
       self.th_pain = granito_pain_decide;
       self.health = 5000;

       walkmonster_start_go();
};

void()      granito_breez1      =[    $breez1,    granito_breez2   ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "granito/idle1.wav", 1, ATTN_IDLE); };
void()      granito_breez2      =[    $breez2,    granito_breez3   ] {};
void()      granito_breez3      =[    $breez3,    granito_breez4   ] {};
void()      granito_breez4      =[    $breez4,    granito_breez5   ] {};
void()      granito_breez5      =[    $breez5,    granito_breez6   ] {};
void()      granito_breez6      =[    $breez6,    granito_walk1    ] {};


void()      granito_walk1       =[    $walk1,     granito_walk2    ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "granito/idle1.wav", 1, ATTN_IDLE); ai_walk(8);};

void()      granito_walk2       =[    $walk2,     granito_walk3    ] {ai_walk(8);};
void()      granito_walk3       =[    $walk3,     granito_walk4    ] {ai_walk(6);};
void()      granito_walk4       =[    $walk4,     granito_walk5    ] {ai_walk(10);};
void()      granito_walk5       =[    $walk5,     granito_walk6    ] {ai_walk(8);};
void()      granito_walk6       =[    $walk6,     granito_walk7    ] {ai_walk(6);};
void()      granito_walk7       =[    $walk7,     granito_walk8    ] {ai_walk(8);};
void()      granito_walk8       =[    $walk8,     granito_walk9    ] {ai_walk(10);};
void()      granito_walk9       =[    $walk9,     granito_walk10   ] {ai_walk(6);};
void()      granito_walk10      =[    $walk10,    granito_walk11   ] {ai_walk(8);};
void()      granito_walk11      =[    $walk11,    granito_walk12   ] {ai_walk(6);};
void()      granito_walk12      =[    $walk12,    granito_walk13   ] {ai_walk(10);};
void()      granito_walk13      =[    $walk13,    granito_run1     ] {ai_walk(4);};

void()      granito_run1        =[    $run1,      granito_run2     ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "granito/idle1.wav", 1, ATTN_IDLE); ai_run(20);};
void()      granito_run2        =[    $run2,      granito_run3     ] {ai_run(15);};
void()      granito_run3        =[    $run3,      granito_run4     ] {ai_run(12);};
void()      granito_run4        =[    $run4,      granito_run5     ] {ai_run(15);};
void()      granito_run5        =[    $run5,      granito_run6     ] {ai_run(15);};
void()      granito_run6        =[    $run6,      granito_run7     ] {ai_run(12);};
void()      granito_run7        =[    $run7,      granito_run8     ] {ai_run(12);};
void()      granito_run8        =[    $run8,      granito_run1     ] {ai_run(8);};

void()      granito_pain1       =[    $pain1,     granito_pain2    ] {};
void()      granito_pain2       =[    $pain2,     granito_pain3    ] {};
void()      granito_pain3       =[    $pain3,     granito_pain4    ] {};
void()      granito_pain4       =[    $pain4,     granito_pain5    ] {};
void()      granito_pain5       =[    $pain5,     granito_pain6    ] {};
void()      granito_pain6       =[    $pain6,     granito_run1     ] {};

void()      granito_painb1      =[    $painb1,    granito_painb2   ] {ai_painforward(0);};
void()      granito_painb2      =[    $painb2,    granito_painb3   ] {ai_painforward(3);};
void()      granito_painb3      =[    $painb3,    granito_painb4   ] {ai_painforward(0);};
void()      granito_painb4      =[    $painb4,    granito_painb5   ] {ai_painforward(2);};
void()      granito_painb5      =[    $painb5,    granito_painb6   ] {ai_painforward(3);};
void()      granito_painb6      =[    $painb6,    granito_painb7   ] {ai_painforward(0);};
void()      granito_painb7      =[    $painb7,    granito_painb8   ] {ai_painforward(3);};
void()      granito_painb8      =[    $painb8,    granito_painb9   ] {ai_painforward(0);};
void()      granito_painb9      =[    $painb9,    granito_painb10  ] {ai_painforward(2);};
void()      granito_painb10     =[    $painb10,   granito_painb11  ] {ai_painforward(2);};
void()      granito_painb11     =[    $painb11,   granito_painb12  ] {ai_painforward(3);};
void()      granito_painb12     =[    $painb12,   granito_run1     ] {};

void(entity attacker, float damage)	granito_pain_decide =
{
      local float r;

	if (self.pain_finished > time)
		return;

	r = random();

      sound (self, CHAN_VOICE, "granito/dpain1.wav", 1, ATTN_NORM);
	if (r < 0.05)
      {
            granito_pain1 ();
            self.pain_finished = time + 5;
      }
	else 
      {
		granito_painb1 ();
		self.pain_finished = time + 5;
	}
 
};

void()     granito_smash1       =[    $smash1,     granito_smash2   ] {
ai_charge(4);};
void()     granito_smash2       =[    $smash2,     granito_smash3   ] {ai_charge(0);};
void()     granito_smash3       =[    $smash3,     granito_smash4   ] {ai_charge(2);};
void()     granito_smash4       =[    $smash4,     granito_smash5   ] {ai_charge(1);};
void()     granito_smash5       =[    $smash5,     granito_smash6   ] {granito_missile('0 80 36');};
void()     granito_smash6       =[    $smash6,     granito_smash7   ] {ai_charge(1);};
void()     granito_smash7       =[    $smash7,     granito_smash8   ] {ai_charge(6);};
void()     granito_smash8       =[    $smash8,     granito_smash9   ] {ai_charge(8);};
void()     granito_smash9       =[    $smash9,     granito_smash10  ] {ai_charge(2);};
void()     granito_smash10      =[    $smash10,    granito_smash11  ] {ai_charge(2);};
void()     granito_smash11      =[    $smash11,    granito_smash12  ] {ai_charge(5);};
void()     granito_smash12      =[    $smash12,    granito_run1     ] {ai_charge(4);};

void() HellNewLightning =
{
	local	vector	org, dir;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	ai_face ();

	org = self.origin + '0 0 -60';

	dir = self.enemy.origin + '0 0 -24' - org;
	dir = normalize (dir);

	traceline (org, self.origin + dir*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (org, trace_endpos, self, 10);
};

void()     granito_beat1        =[    $beat1,      granito_beat2    ] {ai_face();
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
};
void()     granito_beat2        =[    $beat2,      granito_beat3    ] {};
void()     granito_beat3        =[    $beat3,      granito_beat4    ] {};
void()     granito_beat4        =[    $beat4,      granito_beat5    ] {};
void()     granito_beat5        =[    $beat5,      granito_beat6    ] {};
void()     granito_beat6        =[    $beat6,      granito_beat7    ] {};
void()     granito_beat7        =[    $beat7,      granito_beat8    ] {};
void()     granito_beat8        =[    $beat8,      granito_beat9    ] {ai_face();self.nextthink = self.nextthink + 0.2;
local entity o;

self.effects = self.effects | EF_MUZZLEFLASH;
ai_face();
self.owner = spawn();
o = self.owner;
setmodel (o, "progs/s_light.mdl");
setorigin (o, self.origin);
o.angles = self.angles;
o.nextthink = time + 0.1;
o.think = SUB_Remove;
};
void()     granito_beat9       =[    $beat9,     granito_beat10   ] 
{
self.effects = self.effects | EF_MUZZLEFLASH;
self.owner.frame = 1;
};
void()     granito_beat10       =[    $beat10,     granito_beat11   ] 
{
self.effects = self.effects | EF_MUZZLEFLASH;
self.owner.frame = 2;
};
void()     granito_beat11       =[    $beat11,     granito_beat12   ] 
{
remove (self.owner);
HellNewLightning();
sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void()     granito_beat12       =[    $beat12,     granito_beat13   ] 
{HellNewLightning();};
void()     granito_beat13       =[    $beat13,     granito_beat14   ] 
{HellNewLightning();};
void()     granito_beat14       =[    $beat14,     granito_beat15   ] 
{
if (skill == 3)
	HellNewLightning();
};
void()     granito_beat15       =[    $beat15,     granito_run1     ] {};


void()	granito_die1	=[	$death1,		granito_die2	] {
self.takedamage = DAMAGE_NO;
if (random() < 0.2)
    sound (self, CHAN_VOICE, "granito/idle1.wav", 1, ATTN_IDLE); 
    {
	ThrowGib ("progs/rock.mdl", self.health);
	ThrowGib ("progs/rocks.mdl", self.health);
	ThrowGib ("progs/rock.mdl", self.health);
	ThrowGib ("progs/rocks.mdl", self.health);
	ThrowGib ("progs/rock.mdl", self.health);
	ThrowGib ("progs/rocks.mdl", self.health);
	ThrowGib ("progs/rock.mdl", self.health);
	ThrowGib ("progs/rocks.mdl", self.health);
	ThrowGib ("progs/rock.mdl", self.health);
	ThrowGib ("progs/rocks.mdl", self.health);
	ThrowGib ("progs/rock.mdl", self.health);
	ThrowGib ("progs/rocks.mdl", self.health);

	return;
    }

};
void()	granito_die2	=[	$death1,		granito_run1	] 
{

	T_RadiusDamage (self, self, 120, world);

	sound (self, CHAN_VOICE, "granito/ddeath.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
   

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	BecomeExplosion ();
};


void() Granito_MeleeAttack =
{
	granito_beat1 ();
};

void(vector p) granito_missile =
{
	local	vector	offang;
	local	vector	org, vec, d;
	local	float	t;

	offang = vectoangles (self.enemy.origin - self.origin);	
	makevectors (offang);

	org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	
// lead the player on hard mode
	if (skill > 1)
	{
		t = vlen(self.enemy.origin - org) / 300;
		vec = self.enemy.velocity;
		vec_z = 0;
		d = self.enemy.origin + t * vec;		
	}
	else
	{
		d = self.enemy.origin;
	}
	
	vec = normalize (d - org);

	launch_spike (org, vec);
	setmodel (newmis, "progs/lavaball.mdl");
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
	newmis.touch = T_MissileTouch; // rocket explosion
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0)
		granito_smash1 ();
};


void() monster_granito =
{
       if (deathmatch)
       {
               remove(self);
               return;
       }
       precache_model ("progs/granito.mdl");
       precache_model ("progs/lavaball.mdl");
       precache_model ("progs/s_light.mdl");
       precache_model ("progs/bolt.mdl");
       precache_model ("progs/rock.mdl");
       precache_model ("progs/rocks.mdl");

       precache_sound ("shambler/sattck1.wav");
       precache_sound ("shambler/sboom.wav");
       precache_sound ("granito/ddeath.wav");
       precache_sound ("granito/dpain1.wav");
       precache_sound ("granito/idle1.wav");
       precache_sound ("granito/sight1.wav");
       precache_sound ("boss1/throw.wav");
       
       self.solid = SOLID_SLIDEBOX;
       self.movetype = MOVETYPE_STEP;

       setmodel (self, "progs/granito.mdl");

       setsize (self, '-64 -64 -64', '64 64 128');
       self.use = granito_stand1;
       self.frame = $stand1;

};

/*
==============
CheckGranitoMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckGranitoMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
      granito_beat1();
	return FALSE;
};

float()      Granito_ChooseAttack =

{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	
	if (enemy_range == RANGE_MELEE)
      return FALSE;
	      {
            chance = random(); 
            if(chance < 0.3) 
            { 
            granito_smash1(); 
            return FALSE; 
            } 
            if(chance < 0.6) 
            { 
            granito_beat1(); 
            return FALSE; 
            } 

    }  
  
};
     