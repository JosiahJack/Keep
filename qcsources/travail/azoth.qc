/*
step lengths per frame


Same for s_walk
16
16
16
10
17
11
20
26
14
16
10
14


s_swipe
frame 1
20
frame 10
20
frame 11
10

fire
frame 7
10
frame 13
4
frame 14
6

hammer
frame 4
5
frame 5
15
frame 6
35
frame 7
10
frame 8
5
frame 9
5
frame 10
10

leap (must remember to delete frame 7 from the gmax version-now done)
frame 2
5
frame 3
5
frame 4
5
frame 5
launch into air
frame 6
lands on ground
frame 7
20
frame 8
10

throw
frame 2
-3
frame 3
-2
frame 4
-2
frame 5
-3
frame 6
-3
frame 11
23
frame 12
37
frame 13
29
frame 14
21
frame 15
20
frame 16
6
frame 17
5


diea
20
5
10
25
20
15
10
15
20
15
15
20

play diea1 before dieb in the sequence

*/


$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12

$frame s_walk1 s_walk2 s_walk3 s_walk4 s_walk5 s_walk6 s_walk7
$frame s_walk8 s_walk9 s_walk10 s_walk11 s_walk12

$frame s_swipe1 s_swipe2 s_swipe3 s_swipe4 s_swipe5 s_swipe6 s_swipe7
$frame s_swipe8 s_swipe9 s_swipe10 s_swipe11 s_swipe12 s_swipe13 s_swipe14 s_swipe15 s_swipe16 s_swipe17

$frame fire1 fire2 fire3 fire4 fire5 fire6 fire7
$frame fire8 fire9 fire10 fire11 fire12 fire13 fire14


$frame hammer1 hammer2 hammer3 hammer4 hammer5 hammer6 hammer7 hammer8 hammer9 hammer10

$frame leap1 leap2 leap3 leap4 leap5 leap6
$frame leap7 leap8 leap9 leap10 leap11 leap12
$frame leap13


$frame throw1 throw2 throw3 throw4 throw5 throw6 throw7 throw8 throw9 throw10
$frame throw11 throw12 throw13 throw14 throw15 throw16 throw17 throw18



$frame diea1 diea2 diea3 diea4 diea5 diea6 diea7
$frame diea8 diea9 diea10 diea11 diea12

$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6 dieb7

$frame diec1 diec2 diec3 diec4

$frame died1 died2 died3 died4 died5 died6

$frame diee1 diee2 diee3 diee4 diee5

$frame dief1 dief2 dief3 dief4 dief5 dief6 dief7 dief8 dief9 dief10
$frame dief11 dief12 dief13 dief14 dief15 dief16 dief17 dief18 dief19 dief20
$frame dief21 dief22 dief23 dief24 dief25 dief26

$frame sh_stand1 sh_stand2 sh_stand3 sh_stand4 sh_stand5 sh_stand6 sh_stand7 sh_stand8 sh_stand9 sh_stand10

void() azoth_stand1	=[	$stand1,	azoth_stand2	] {ai_stand();};
void() azoth_stand2	=[	$stand2,	azoth_stand3	] {ai_stand();};
void() azoth_stand3	=[	$stand3,	azoth_stand4	] {ai_stand();};
void() azoth_stand4	=[	$stand4,	azoth_stand5	] {ai_stand();};
void() azoth_stand5	=[	$stand5,	azoth_stand6	] {ai_stand();};
void() azoth_stand6	=[	$stand6,	azoth_stand7	] {ai_stand();};
void() azoth_stand7	=[	$stand7,	azoth_stand8	] {ai_stand();};
void() azoth_stand8	=[	$stand8,	azoth_stand9	] {ai_stand();};
void() azoth_stand9	=[	$stand9,	azoth_stand10	] {ai_stand();};
void() azoth_stand10	=[	$stand10,	azoth_stand11	] {ai_stand();};
void() azoth_stand11	=[	$stand11,	azoth_stand1	] {ai_stand();};

void() azoth_walk1	=[	$walk1,		azoth_walk2	] {ai_walk(16);};
void() azoth_walk2	=[	$walk2,		azoth_walk3	] {ai_walk(16);};
void() azoth_walk3	=[	$walk3,		azoth_walk4	] {ai_walk(16);};
void() azoth_walk4	=[	$walk4,		azoth_walk5	] {ai_walk(10);};
void() azoth_walk5	=[	$walk5,		azoth_walk6	] {ai_walk(17);};
void() azoth_walk6	=[	$walk6,		azoth_walk7	] {ai_walk(11);};
void() azoth_walk7	=[	$walk7,		azoth_walk8	] {ai_walk(20);};
void() azoth_walk8	=[	$walk8,		azoth_walk9	] {ai_walk(26);};
void() azoth_walk9	=[	$walk9,		azoth_walk10	] {ai_walk(14);};
void() azoth_walk10	=[	$walk10,	azoth_walk11	] {ai_walk(16);};
void() azoth_walk11	=[	$walk11,	azoth_walk12	] {ai_walk(10);};
void() azoth_walk12	=[	$walk12,	azoth_walk1	] {ai_walk(14);};


void() azoth_out1	=[	$walk1,		azoth_out2	] {	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(16);};
void() azoth_out2	=[	$walk2,		azoth_out3	] {	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(16);};
void() azoth_out3	=[	$walk3,		azoth_out4	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(16);};
void() azoth_out4	=[	$walk4,		azoth_out5	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(10);};
void() azoth_out5	=[	$walk5,		azoth_out6	] {	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(17);};
void() azoth_out6	=[	$walk6,		azoth_stand1	] {/*	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(11);};
void() azoth_out7	=[	$walk7,		azoth_out8	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(20);};
void() azoth_out8	=[	$walk8,		azoth_out9	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(26);};
void() azoth_out9	=[	$walk9,		azoth_out10	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(14);};
void() azoth_out10	=[	$walk10,	azoth_out11	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(16);};
void() azoth_out11	=[	$walk11,	azoth_out12	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
movetogoal(10);};
void() azoth_out12	=[	$walk12,	azoth_stand1	] {
*/	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();
self.th_stand = azoth_stand1;};

void() azoth_run1	=[	$walk1,		azoth_run2	] {ai_run(16);};
void() azoth_run2	=[	$walk2,		azoth_run3	] {ai_run(16);};
void() azoth_run3	=[	$walk3,		azoth_run4	] {ai_run(16);};
void() azoth_run4	=[	$walk4,		azoth_run5	] {ai_run(10);};
void() azoth_run5	=[	$walk5,		azoth_run6	] {ai_run(17);};
void() azoth_run6	=[	$walk6,		azoth_run7	] {ai_run(11);};
void() azoth_run7	=[	$walk7,		azoth_run8	] {ai_run(20);};
void() azoth_run8	=[	$walk8,		azoth_run9	] {ai_run(26);};
void() azoth_run9	=[	$walk9,		azoth_run10	] {ai_run(14);};
void() azoth_run10	=[	$walk10,	azoth_run11	] {ai_run(16);};
void() azoth_run11	=[	$walk11,	azoth_run12	] {ai_run(10);};
void() azoth_run12	=[	$walk12,	azoth_run1	] {ai_run(14);};

//first check if angry enough to charge
//don't use run here, ai_face the player, and walkmove in the direction of the gate.
//If small angle_delta go to standing frame instead?
//Check if near enough to stop walking.
//If player is visible and nearby, build up rage.
//remember the sound cues
void() azoth_s_charge1;
void() azoth_swipe1;
void() azoth_s_run1;

float() check_chargerange =
{
local float h;
h =  self.enemy.absmin_z - self.absmin_z;
if(vlen(self.enemy.origin - self.pos2) < 700 && fabs(h) < 48)
	{
	if(self.bubble_count > 20)
		return TRUE;
	else
		self.bubble_count = self.bubble_count + 2;
	}
return FALSE;
}
void() azoth_s_stand_think=
{

if(check_chargerange())
	{
	azoth_s_charge1();
	return;
	}
self.takedamage = DAMAGE_NO;ai_face();

if(self.bubble_count < 0)
	self.bubble_count = 2;
walkmove(0,0);//try and fix Azoth hovering);
};
void() azoth_s_stand1	=[	$sh_stand1,		azoth_s_stand2	] {azoth_s_stand_think();
if(random() < 0.3 && self.waitmin < time)
	{
	sound (self, CHAN_VOICE, "azoth/pain.wav", 1, 4);
	self.waitmin = time + 7;
	}
}
void() azoth_s_stand2	=[	$sh_stand2,		azoth_s_stand3	] {azoth_s_stand_think();}
void() azoth_s_stand3	=[	$sh_stand3,		azoth_s_stand4	] {azoth_s_stand_think();}
void() azoth_s_stand4	=[	$sh_stand4,		azoth_s_stand5	] {azoth_s_stand_think();}
void() azoth_s_stand5	=[	$sh_stand5,		azoth_s_stand6	] {azoth_s_stand_think();}
void() azoth_s_stand6	=[	$sh_stand6,		azoth_s_stand7	] {azoth_s_stand_think();}
void() azoth_s_stand7	=[	$sh_stand7,		azoth_s_stand8	] {azoth_s_stand_think();}
void() azoth_s_stand8	=[	$sh_stand8,		azoth_s_stand9	] {azoth_s_stand_think();}
void() azoth_s_stand9	=[	$sh_stand9,		azoth_s_stand10	] {azoth_s_stand_think();}
void() azoth_s_stand10	=[	$sh_stand10,		azoth_s_stand1	] {azoth_s_stand_think();}





void(float dist) shield_run =
{
local float facing;
if (!IsAlive(self.enemy))
		self.th_stand();


if(check_chargerange())
	{
	azoth_s_charge1();

	return;
	}
if(vlen(self.origin - self.pos2) < 280)
	{
	azoth_s_stand1();
	return;
	}
facing = vectoyaw(self.pos2 - self.origin);
walkmove(facing,dist);
ai_face();
if(self.bubble_count < 0)
	self.bubble_count = 2;
}


//cut frames 4,6,10,12 to make charge.
void() azoth_s_run1	=[	$s_walk1,		azoth_s_run2	] {shield_run(16);	self.takedamage = DAMAGE_NO;
};
void() azoth_s_run2	=[	$s_walk2,		azoth_s_run3	] {shield_run(16);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run3	=[	$s_walk3,		azoth_s_run4	] {shield_run(16);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run4	=[	$s_walk4,		azoth_s_run5	] {shield_run(10);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run5	=[	$s_walk5,		azoth_s_run6	] {shield_run(17);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run6	=[	$s_walk6,		azoth_s_run7	] {shield_run(11);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run7	=[	$s_walk7,		azoth_s_run8	] {shield_run(20);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run8	=[	$s_walk8,		azoth_s_run9	] {shield_run(26);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run9	=[	$s_walk9,		azoth_s_run10	] {shield_run(14);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run10	=[	$s_walk10,	azoth_s_run11	] {shield_run(16);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run11	=[	$s_walk11,	azoth_s_run12	] {shield_run(10);	self.takedamage = DAMAGE_NO;};
void() azoth_s_run12	=[	$s_walk12,	azoth_s_run1	] {shield_run(14);	self.takedamage = DAMAGE_NO;};


void(float dist) shield_charge =
{
local float facing, unstuck;
facing = vectoyaw(self.enemy.origin - self.origin);
unstuck = walkmove(facing,dist);
if(vlen(self.enemy.origin - self.origin) < 91)	// 91 ~ 64 * (root 2)
						// essentially means always the case if the player is touching
	{
	azoth_swipe1();
	return;
	}

if(!unstuck || vlen(self.enemy.origin - self.pos2) > 800)
	{
	self.bubble_count = self.bubble_count - 20;
	self.think = azoth_s_run1;//stop the charge if you hit something or player is too far out
	}


ai_face();
self.bubble_count = self.bubble_count - 1;

}



void() azoth_s_charge1	=[	$s_walk1,		azoth_s_charge2	] {

shield_charge(30);
	self.takedamage = DAMAGE_NO;
};
void() azoth_die;
void() azoth_s_charge2	=[	$s_walk2,		azoth_s_charge3	] {shield_charge(24);	self.takedamage = DAMAGE_NO;sound (self, CHAN_VOICE, "azoth/awake.wav", 1, ATTN_NORM);};
void() azoth_s_charge3	=[	$s_walk3,		azoth_s_charge4	] {shield_charge(24);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge4	=[	$s_walk5,		azoth_s_charge6	] {shield_charge(10);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge6	=[	$s_walk7,		azoth_s_charge8	] {shield_charge(45);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge8	=[	$s_walk8,		azoth_s_charge9	] {shield_charge(39);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge9	=[	$s_walk9,		azoth_s_charge10] {shield_charge(21);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge10	=[	$s_walk11,		azoth_s_charge11	] {shield_charge(39);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge11	=[	$s_walk1,		azoth_s_charge12	] {shield_charge(45);	self.takedamage = DAMAGE_NO;};
void() azoth_s_charge12	=[	$s_walk2,		azoth_s_charge3	] {shield_charge(24);	self.takedamage = DAMAGE_NO;};

void() azoth_swipe1	=[	$s_swipe1,	azoth_swipe2	] {ai_charge(20);};
void() azoth_swipe2	=[	$s_swipe2,	azoth_swipe3	] {ai_face();};
void() azoth_swipe3	=[	$s_swipe3,	azoth_swipe4	] {ai_face();	self.takedamage = DAMAGE_AIM;
local vector	delta;

	if (!self.enemy)
		return;
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100 && self.th_die == azoth_die)
		self.think = azoth_fire1;
};
void() azoth_swipe4	=[	$s_swipe4,	azoth_swipe5	] {ai_face();};
void() azoth_swipe5	=[	$s_swipe5,	azoth_swipe6	] {ai_face();};
void() azoth_swipe6	=[	$s_swipe6,	azoth_swipe7	] {ai_face();};
void() azoth_swipe7	=[	$s_swipe7,	azoth_swipe8	] {ai_face();};
void() azoth_swipe8	=[	$s_swipe8,	azoth_swipe9	] {ai_face();};
void() azoth_swipe9	=[	$s_swipe9,	azoth_swipe10	] {ai_face();};
void() azoth_swipe10	=[	$s_swipe10,	azoth_swipe11	] {ai_charge(20);
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
//FIXME: Need a sound here
//	sound (self, CHAN_VOICE, "azoth/thud.wav", 1, ATTN_NORM);
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 180)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ldmg = 13 + random() * 13;
	T_Damage (self.enemy, self, self, ldmg);
};
void() azoth_swipe11	=[	$s_swipe11,	azoth_swipe12	] {ai_charge(10);local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
//FIXME: Need a sound here
//	sound (self, CHAN_VOICE, "azoth/thud.wav", 1, ATTN_NORM);
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 180)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ldmg = 13 + random() * 13;
	T_Damage (self.enemy, self, self, ldmg);
};
void() azoth_swipe12	=[	$s_swipe12,	azoth_swipe13	] {ai_face();};
void() azoth_swipe13	=[	$s_swipe13,	azoth_swipe14	] {ai_face();};
void() azoth_swipe14	=[	$s_swipe14,	azoth_swipe15	] {ai_face();};
void() azoth_swipe15	=[	$s_swipe15,	azoth_swipe16	] {ai_face();};
void() azoth_swipe16	=[	$s_swipe16,	azoth_swipe17	] {ai_face();	self.takedamage = DAMAGE_NO;};
void() azoth_swipe17	=[	$s_swipe17,	azoth_s_run1	] {ai_face();if(!(self.flags & FL_ONGROUND))
	self.think = azoth_land2;
};

void() azoth_deflect1	=[	$s_swipe15,	azoth_deflect2	] {ai_charge(16 + 10);};
void() azoth_deflect2	=[	$s_swipe16,	azoth_deflect3	] {ai_charge(16 + 10);	self.takedamage = DAMAGE_NO;};
void() azoth_deflect3	=[	$s_swipe17,	azoth_deflect4	] {ai_charge(16 + 10);};
void() azoth_deflect4	=[	$s_walk8,	azoth_deflect5	] {ai_charge(26 + 10);	self.takedamage = DAMAGE_NO;};
void() azoth_deflect5	=[	$s_walk9,	azoth_deflect6	] {ai_charge(14 + 10);	self.takedamage = DAMAGE_NO;};
void() azoth_deflect6	=[	$s_walk10,	azoth_deflect7	] {ai_charge(16 + 10);	self.takedamage = DAMAGE_NO;};
void() azoth_deflect7	=[	$s_walk11,	azoth_deflect8	] {ai_charge(10 + 10);	self.takedamage = DAMAGE_NO;};
void() azoth_deflect8	=[	$s_walk12,	azoth_deflect9	] {ai_charge(14 + 10);	self.takedamage = DAMAGE_NO;};
void() azoth_deflect9	=[	$s_swipe1,	azoth_deflect10	] {ai_charge(20 + 10);};
void() azoth_deflect10	=[	$s_swipe2,	azoth_deflect11	] {ai_charge(16 + 10);	self.takedamage = DAMAGE_AIM;};
void() azoth_deflect11	=[	$s_swipe3,	azoth_run1	] {ai_charge(10 + 10);};



void() azoth_hammer1	=[	$hammer1,	azoth_hammer2	] {ai_face();};
void() azoth_hammer2	=[	$hammer2,	azoth_hammer3	] {ai_face();};
void() azoth_hammer3	=[	$hammer3,	azoth_hammer4	] {ai_face();};
void() azoth_hammer4	=[	$hammer4,	azoth_hammer5	] {ai_charge(5);};
void() azoth_hammer5	=[	$hammer5,	azoth_hammer6	] {ai_charge(15);};
void() azoth_hammer6	=[	$hammer6,	azoth_hammer7	] {ai_charge(35);
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	sound (self, CHAN_VOICE, "azoth/thud.wav", 1, ATTN_NORM);
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 150)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ldmg = 30 + random() * 40;
	T_Damage (self.enemy, self, self, ldmg);
};
void() azoth_hammer7	=[	$hammer7,	azoth_hammer8	] {ai_charge(10);};
void() azoth_hammer8	=[	$hammer8,	azoth_hammer9	] {ai_charge(5);};
void() azoth_hammer9	=[	$hammer9,	azoth_hammer10	] {ai_charge(5);};
void() azoth_hammer10	=[	$hammer10,	azoth_run1	] {ai_charge(10);if(!(self.flags & FL_ONGROUND))
	self.think = azoth_land2;};


void() flame_burn =
{

	self.velocity = '0 0 100';
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	s_explode1();
}

void() flame_move =
{

local vector o,v;
o = self.origin - '0 0 7';
v = self.pos1;
traceline(o - v * 0.5,o + v, FALSE, self);

o = (trace_plane_normal * (v * trace_plane_normal) -  v);



//if(o == '0 0 0')
//	{
//	flame_burn();
//	return;
//	}
//else
//	{
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity = o * -650 + '0 0 1';
	self.pos1 = normalize(self.velocity);
	self.nextthink = time + 0.5;
	self.think = flame_burn;
//	}

	// thanks to the wonders of mathematics this sends the flame parallel to the ground
	// in the direction of it's original component perpendicular to the plane



}

void() flame_touch =
{
if(other.solid != SOLID_BSP)
	{

	if(other.takedamage)
		T_Damage (other, self, self.owner, 16);
	flame_burn();
	return;
	}
self.nextthink = time + 0.05;
self.think = flame_move;
self.frame = 2;
}
void() flame_2 =
{self.frame = 2;self.nextthink = time + 1.8;self.think = flame_burn ;}

void() flame_1 =
{self.frame = 1;self.nextthink = time + 0.1;self.think = flame_2;}

void(vector org, vector dir) launch_flame =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = flame_touch;
	newmis.classname = "flame";
	newmis.think = flame_1;
	newmis.nextthink = time + 0.1;
	setmodel (newmis, "progs/s_flame.spr");
	setsize (newmis, '0 0 -7', '0 0 16');
	setorigin (newmis, org);

	newmis.velocity = dir * 950;
	newmis.pos1 = dir;
};

void(vector head) breathe_fire =
{
makevectors(self.angles + head);
launch_flame(self.origin + '0 0 100' + v_forward * 34, v_forward * (4 / 5) - '0 0 3'* (1 / 5));
}


void() azoth_fire1	=[	$fire1,	azoth_fire2	] {ai_face();};
void() azoth_fire2	=[	$fire2,	azoth_fire3	] {ai_face();};
void() azoth_fire3	=[	$fire3,	azoth_fire4	] {ai_face();};
void() azoth_fire4	=[	$fire4,	azoth_fire5	] {
	sound (self, CHAN_VOICE, "azoth/fire.wav", 1, ATTN_NORM);
	self.pos1 = self.enemy.origin + self.enemy.velocity * 0.7;
	self.ideal_yaw = vectoyaw(self.pos1 - self.origin);
	ChangeYaw ();};
void() azoth_fire5	=[	$fire5,	azoth_fire6	] {
	self.ideal_yaw = vectoyaw(self.pos1 - self.origin);
	ChangeYaw ();};
void() azoth_fire6	=[	$fire6,	azoth_fire6b	] {breathe_fire('0 -20 0');self.nextthink = time + 0.05;};
void() azoth_fire6b	=[	$fire6,	azoth_fire7	] {breathe_fire('0 -18 0');self.nextthink = time + 0.05;};
void() azoth_fire7	=[	$fire7,	azoth_fire7b	] {ai_forward (10);breathe_fire('0 -15 0');self.nextthink = time + 0.05;};
void() azoth_fire7b	=[	$fire7,	azoth_fire8	] {breathe_fire('0 -11 0');self.nextthink = time + 0.05;};
void() azoth_fire8	=[	$fire8,	azoth_fire8b	] {breathe_fire('0 -8 0');self.nextthink = time + 0.05;};
void() azoth_fire8b	=[	$fire8,	azoth_fire9	] {breathe_fire('0 -4 0');self.nextthink = time + 0.05;};
void() azoth_fire9	=[	$fire9,	azoth_fire9b	] {breathe_fire('0 0 0');self.nextthink = time + 0.05;};
void() azoth_fire9b	=[	$fire9,	azoth_fire10	] {breathe_fire('0 3 0');self.nextthink = time + 0.05;};
void() azoth_fire10	=[	$fire10,	azoth_fire10b	] {breathe_fire('0 7 0');self.nextthink = time + 0.05;};
void() azoth_fire10b	=[	$fire10,	azoth_fire11	] {breathe_fire('0 11 0');self.nextthink = time + 0.05;};
void() azoth_fire11	=[	$fire11,	azoth_fire12	] {breathe_fire('0 15 0');};
void() azoth_fire12	=[	$fire12,	azoth_fire13	] {ai_face();};
void() azoth_fire13	=[	$fire13,	azoth_fire14	] {ai_charge(4);};
void() azoth_fire14	=[	$fire14,	azoth_run1	] {ai_charge(6);
if(!(self.flags & FL_ONGROUND))
	self.think = azoth_land2;
else if(self.th_die == azoth_die)
	self.think = azoth_swipe15;
};

void() skullearlymissiletouch =
{
//For the first 0.2 seconds missiles don't collide wth world
	if (other == self.owner || other == world)
		return;		// don't explode on owner

	T_RadiusDamage (self, self.owner, 50, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	if(self.goalentity)
	{
		remove(self.goalentity);
		self.goalentity = world;
	}
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();

};

void() skullmissiletouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	T_RadiusDamage (self, self.owner, 50, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	if(self.goalentity)
	{
		remove(self.goalentity);
		self.goalentity = world;
	}
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();

};
void() skull_makesolid
{
self.touch = skullmissiletouch;
force_retouch = 2;
}

void() azoth_throw_direct =
{

	local	entity 	missile;
	local	vector	dir;
	local float r;
	makevectors(self.angles);
	r = vlen(self.origin - self.enemy.origin);
if(self.enemy.origin_z > self.origin_z + 20)
	dir = normalize((self.enemy.origin + '0 0 15') - self.origin - '0 0 160' - v_forward * 14 - v_right * 30 + (self.enemy.velocity - '0 0 1' * self.enemy.velocity_z) * (r / 800));
else
	dir = normalize((self.enemy.origin - '0 0 15') - self.origin - '0 0 160' - v_forward * 14 - v_right * 30 + (self.enemy.velocity - '0 0 1' * self.enemy.velocity_z) * (r / 800));

//	dprint("thrown\n");
	sound (self, CHAN_WEAPON, "azoth/thwack.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.nextthink = time + 0.2;
	missile.think = skull_makesolid;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/skull.mdl");

	setsize (missile, '-0 -0 -0', '0 0 0');

	missile.origin = self.origin + '0 0 160' + v_forward * 14 + v_right * 30;//v_right * 65 is more true to the model but keeps snagging
	missile.velocity = dir * 800;
	missile.avelocity = '300 300 300';
	missile.touch = skullearlymissiletouch;

	self.angles_y = vectoyaw(dir);
}

void() skull_retarget
{
if (other != self.goalentity)
	return;
other.enemy = self.enemy;
other.goalentity = world;
self.nextthink = time + 0.1;
self.think = SUB_Remove;
other.solid = SOLID_BBOX;
setsize (other, '-4 -4 -4', '4 4 4');
}

void() skullhome =
{
	local vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if ( (!IsAlive(self.enemy) )&& (self.enemy.classname != "homingpoint"))
	{
		if(self.goalentity)
		{
			remove(self.goalentity);
			self.goalentity = world;
		}
		remove(self);
		return;
	}
	dir = normalize(vtemp - self.origin);
	if (skill == 3)
		self.velocity = self.velocity * 0.4 + dir * 300;
	else
		self.velocity = self.velocity * 0.5 + dir * 225;
	self.nextthink = time + 0.2;
	self.think = skullhome;
};

void() skullhomemakesolid
{

	self.solid = SOLID_BBOX;
	setsize (self, '-4 -4 -4', '4 4 4');
	self.nextthink = time + 0.2;
	self.think = skullhome;
	force_retouch = 2;
}

void() azoth_throw_indirect =
{
//throws the missile at a trigger half way around the circle between the player and azoth
//on the outside of tower. Hitting this trigger will change the target back to the player
	local	entity 	missile, trigger;
	local	vector	pos;
	local float m,p,d;
	if(self.th_die != azoth_phase7)
	{
	m = vectoyaw(self.origin - tower);
	p = vectoyaw(self.enemy.origin - tower);
	d = m - p;
	while(d < -180)
		{d = d + 360;}

	while(d > 180)
		{d = d - 360;}
	pos_y = m - (d * 0.5);
	makevectors(pos);
	}
	trigger = spawn();

	missile = spawn();

	trigger.solid = SOLID_TRIGGER;
	trigger.classname = "homingpoint";
	setsize (trigger, '-16 -16 -16', '16 16 16');
//	setmodel(trigger, "progs/player.mdl");//debug only

	if(self.th_die == azoth_phase7)
		{
		pos = (self.enemy.origin * 4 + self.origin) * 0.2;
		pos_z = 600;
		setorigin (trigger, pos);
		}
	else
		setorigin (trigger, v_forward * 1000 + tower + '0 0 1' * (self.enemy.origin_z + self.origin_z) * 0.5 + '0 0 24');


	trigger.touch = skull_retarget;
	trigger.enemy = self.enemy;
	trigger.goalentity = missile;
	missile.goalentity = trigger;
	trigger.health = 20;
	makevectors(self.angles);

//	dprint("thrown indirect\n");

	sound (self, CHAN_WEAPON, "azoth/thwack.wav", 1, ATTN_NORM);

	missile.owner = self;

	missile.solid = SOLID_NOT;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/skull.mdl");

	setsize (missile, '-4 -4 -4', '4 4 4');

	missile.origin = self.origin + '0 0 160' + v_forward * 14 + v_right * 30;//v_right * 65 is more true to the model but keeps snagging
	if(self.th_die == azoth_phase7)
		missile.velocity = v_up * 600;
	else
		missile.velocity = v_forward * 800;
	missile.avelocity = '300 300 300';
	missile.nextthink = time + 0.3;
	missile.enemy = trigger;
	missile.think = skullhomemakesolid;
	missile.touch = skullmissiletouch;
	missile.classname = "skull";
}


void() azoth_throwindirect7;
void() azoth_throw1	=[	$throw1,	azoth_throw2	] {ai_face();};
void() azoth_throw2	=[	$throw2,	azoth_throw3	] {ai_back(3);};
void() azoth_throw3	=[	$throw3,	azoth_throw4	] {ai_back(2);};
void() azoth_throw4	=[	$throw4,	azoth_throw5	] {ai_back(2);};
void() azoth_throw5	=[	$throw5,	azoth_throw6	] {ai_back(3);};
void() azoth_throw6	=[	$throw6,	azoth_throw7	] {ai_back(3);};
void() azoth_throw7	=[	$throw7,	azoth_throw8	] {
	if (!AzothCheckMissile())
		azoth_throwindirect7();
ai_face();};
void() azoth_throw8	=[	$throw8,	azoth_throw9	] {ai_face();};
void() azoth_throw9	=[	$throw9,	azoth_throw10	] {ai_face();};
void() azoth_throw10	=[	$throw10,	azoth_throw11	] {ai_face(); azoth_throw_direct();};
void() azoth_throw11	=[	$throw11,	azoth_throw12	] {ai_forward (23);};
void() azoth_throw12	=[	$throw12,	azoth_throw13	] {ai_forward (37);};
void() azoth_throw13	=[	$throw13,	azoth_throw14	] {ai_forward (29);};
void() azoth_throw14	=[	$throw14,	azoth_throw15	] {ai_charge (21);};
void() azoth_throw15	=[	$throw15,	azoth_throw16	] {ai_charge (20);};
void() azoth_throw16	=[	$throw16,	azoth_throw17	] {ai_charge (6);};
void() azoth_throw17	=[	$throw17,	azoth_run1	] {ai_charge (5);
if(!(self.flags & FL_ONGROUND))
	self.think = azoth_land2;};

void() azoth_throwindirect7	=[	$throw7,	azoth_throwindirect8	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();};
void() azoth_throwindirect8	=[	$throw8,	azoth_throwindirect9	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();};
void() azoth_throwindirect9	=[	$throw9,	azoth_throwindirect10	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw ();};
void() azoth_throwindirect10	=[	$throw10,	azoth_throw11	] {
	self.ideal_yaw = vectoyaw(tower - self.origin) + 180;
	ChangeYaw (); azoth_throw_indirect();};


void(float cel) azoth_fly =
//flys azoth towards self.pos1
{
local vector d;
local float r;


if(self.attack_finished < time)
	{
	// been flying for a while now, probably stuck or made it but don't realise, drop down and abort
	 azoth_land1();
	return;
	}

self.flags = self.flags - (self.flags & FL_ONGROUND);

makevectors(self.angles);
d = self.pos1 - self.origin;
r = vlen(d);
if(r < 40)
	{
	if(azoth_new_flightpoint() == TRUE)
		return;//might have a new function
	}
self.velocity = 2.1 * (cel / r) * d;
	self.ideal_yaw = vectoyaw(self.pos1 - self.origin);
	ChangeYaw ();
//add jitter
self.velocity_x = self.velocity_x + random() * 30 - 15;
self.velocity_y = self.velocity_y + random() * 30 - 15;
}

void() azoth_fly1	=[	$diee1,		azoth_fly2	] {azoth_fly(150);
sound (self, CHAN_VOICE, "azoth/flap.wav", 1, ATTN_NONE);};
void() azoth_fly2	=[	$diee2,		azoth_fly3	] {azoth_fly(150);};
void() azoth_fly3	=[	$diee3,		azoth_fly4	] {azoth_fly(200);};
void() azoth_fly4	=[	$diee4,		azoth_fly5	] {azoth_fly(130);};
void() azoth_fly5	=[	$diee5,		azoth_fly6	] {azoth_fly(130);};
void() azoth_fly6	=[	$diee4,		azoth_fly7	] {azoth_fly(130);};
void() azoth_fly7	=[	$diee3,		azoth_fly8	] {azoth_fly(100);};
void() azoth_fly8	=[	$diee2,		azoth_fly1	] {azoth_fly(100);};

void() azoth_fly_touch =
{
if (other.classname != "player")
	return;

//player is probably trying to block our landing spot
//for now going to fly over him
//possibly a more aggressive tactic would be better here so it's not a viable tactic

self.velocity_z = 500;
}
void() azoth_leap1	=[	$leap1,		azoth_leap2	] {};
void() azoth_leap2	=[	$leap2,		azoth_leap3	] {};
void() azoth_leap3	=[	$leap3,		azoth_leap4	] {};
void() azoth_leap4	=[	$leap4,		azoth_leap5	] {};
void() azoth_leap5	=[	$leap5,		azoth_fly1	] {
self.lip = 0;
self.movetype = MOVETYPE_FLY;
self.flags = self.flags - (self.flags & FL_ONGROUND);
self.height = 170;
azoth_fly(250);
self.touch = azoth_fly_touch;
};


void() azoth_free = //function to bounce Azoth if he's stuck in a gap and not moving
{
local vector d;
d = normalize(self.origin - tower - self.origin_z * '0 0 1');
self.velocity_x = -300 * d_y;

self.velocity_y = 300 * d_x;
self.velocity_z = 175;
}

void() azoth_land3;
void() azoth_land1	=[	$leap6,		azoth_land2	] {self.movetype = MOVETYPE_STEP;self.velocity = self.velocity * 0.1;
self.touch = SUB_Null;};

void() azoth_land2	=[	$leap7,		azoth_land2	] {
if(self.flags & FL_ONGROUND)
	azoth_land3();
if(self.velocity == '0 0 0')
	{
	azoth_free();
	}
AzothCheckAttack();
}
void() azoth_land3	=[	$leap8,		azoth_land4	] {};
void() azoth_land4	=[	$leap9,		azoth_land5	] {};
void() azoth_land5	=[	$leap10,	azoth_land6	] {};
void() azoth_land6	=[	$leap11,	azoth_land7	] {};
void() azoth_land7	=[	$leap12,	azoth_land8	] {};
void() azoth_land8	=[	$leap13,	azoth_land9	] {};
void() azoth_land9 = {
self.attack_finished = time - 0.2;
self.th_run();
};

void() azoth_dive3;

void() azoth_divecollide =
{
if (other == self.enemy)
	azoth_dive3();
};

void() azoth_dive1	=[	$leap6,		azoth_dive2	] {self.movetype = MOVETYPE_STEP;self.velocity = self.velocity * 0.1;
self.touch = azoth_divecollide;self.nextthink = time + 0.4;};
void() azoth_dive2      =[	$leap6,		azoth_dive2b	] {self.velocity = '0 0 -800';}
void() azoth_dive2b	=[	$leap7,		azoth_dive2b	] {
if(self.flags & FL_ONGROUND)
	azoth_dive3();
if(self.velocity == '0 0 0')
	{
	azoth_free();
	}
AzothCheckAttack();
};

void() azoth_dive3	=[	$leap8,		azoth_land4	]

{
local entity e;
e = nextent(world);
while(e.classname == "player")
	{
	if(vlen(self.origin - '0 0 24' - e.origin) < 170)
		{
		T_Damage (e, self, self, 27);//add jumps?
		}
	e = nextent(e);//assumes the client entities are always at the start of the list, no engine changes this AFAIK
	}

e = spawn();
e.origin = self.origin - '0 0 18';
setmodel(e, "progs/shockwav.mdl");
e.think = s_explode2;
e.nextthink = time + 0.05;

sound (self, CHAN_VOICE, "azoth/crunch.wav", 1, ATTN_NORM);
self.touch = SUB_Null;

};


void() rift_open_start;
void(vector dir) rift_lightning =
{
local vector org;
makevectors(self.angles_y * '0 1 0');
org = self.origin + dir_x * v_forward - dir_y * v_right + dir_z * '0 0 1';

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, rift.origin_x);
	WriteCoord (MSG_BROADCAST, rift.origin_y);
	WriteCoord (MSG_BROADCAST, rift.origin_z);

};

void() azoth_diec1	=[	$diec1,		azoth_diec2	] {rift_lightning('-9 5 150');};
void() azoth_diec2	=[	$diec2,		azoth_diec3	] {rift_lightning('-16 18 152');};
void() azoth_diec3	=[	$diec3,		azoth_diec4	] {rift_lightning('-12 12 154');
self = rift;
rift_open_start();
};
void() azoth_diec4	=[	$diec4,		azoth_diec5	] {rift_lightning('-5 -4 150');};
void() azoth_diec5	=[	$diec3,		azoth_diec6	] {rift_lightning('-9 5 150');};
void() azoth_diec6	=[	$diec2,		azoth_diec7	] {};
void() azoth_diec7	=[	$diec1,		azoth_died1	] {};


void(float cel) azoth_fly_death =
{
local vector d;
local float r;
makevectors(self.angles);
d = rift.origin - self.origin - self.height * '0 0 1' + (26 * v_forward) + (15 * v_right);//rift centre - self centre - height offset + model offset
r = vlen(d);
if(r < 10)
	self.lip = 1;
self.velocity = 1.6 * (cel / (r + 1)) * d;
}

void() rift_hold;
void() azoth_died1	=[	$died1,		azoth_died2	] {};
void() azoth_died2	=[	$died2,		azoth_died3	] {};
void() azoth_died3	=[	$died3,		azoth_died4	] {};
void() azoth_died4	=[	$died4,		azoth_died5	] {};
void() azoth_died5	=[	$died5,		azoth_died6	] {};
void() azoth_died6	=[	$died6,		azoth_diee1	] {
self.lip = 0;
self.movetype = MOVETYPE_NOCLIP;
self.height = 170;
azoth_fly_death(200);

};




void() azoth_dief1;
void() azoth_diee1	=[	$diee1,		azoth_diee2	] {sound (self, CHAN_VOICE, "azoth/flap.wav", 1, ATTN_NONE);azoth_fly_death(100);};
void() azoth_diee2	=[	$diee2,		azoth_diee3	] {azoth_fly_death(100);};
void() azoth_diee3	=[	$diee3,		azoth_diee4	] {azoth_fly_death(150);};
void() azoth_diee4	=[	$diee4,		azoth_diee5	] {azoth_fly_death(90);};
void() azoth_diee5	=[	$diee5,		azoth_diee6	] {
if(self.lip)
	azoth_dief1();
else
	azoth_fly_death(80);
};
void() azoth_diee6	=[	$diee4,		azoth_diee7	] {azoth_fly_death(90);};
void() azoth_diee7	=[	$diee3,		azoth_diee8	] {azoth_fly_death(70);};
void() azoth_diee8	=[	$diee2,		azoth_diee1	] {azoth_fly_death(70);};



void() leg1	=[	1,		leg2	] {};
void() leg2	=[	2,		leg3	] {};
void() leg3	=[	3,		leg4	] {};
void() leg4	=[	4,		leg5	] {};
void() leg5	=[	5,		leg6	] {};
void() leg6	=[	6,		leg7	] {};
void() leg7	=[	7,		leg8	] {};
void() leg8	=[	8,		leg9	] {
sound (self, CHAN_VOICE, "demon/dland2.wav", 1, ATTN_NONE);};
void() leg9	=[	8,		leg10	] {};
void() leg10	=[	8,		leg10	]
{
	if (corpse_removal)
		Become_Corpse ();
};

void() leg_touch =
{
self.touch = SUB_Null;
self.velocity = self.velocity * 0.2;
sound (self, CHAN_VOICE, "demon/dland2.wav", 1, ATTN_NONE);
leg1();
}
void() rift_close;
void() azoth_dief1	=[	$dief1,		azoth_dief2	] {
rift.think = rift_hold;azoth_fly_death(20);self.height = 170;rift.frame = 39;};
void() azoth_dief2	=[	$dief2,		azoth_dief3	] {azoth_fly_death(20);self.height = 170;rift.frame = 38;sound (self, CHAN_VOICE, "azoth/pain.wav", 1, ATTN_NONE);};
void() azoth_dief3	=[	$dief3,		azoth_dief4	] {azoth_fly_death(20);self.height = 170;rift.frame = 37;};
void() azoth_dief4	=[	$dief4,		azoth_dief5	] {azoth_fly_death(20);self.height = 170;rift.frame = 36;};
void() azoth_dief5	=[	$dief5,		azoth_dief6	] {azoth_fly_death(20);self.height = 170;rift.frame = 35;};
void() azoth_dief6	=[	$dief6,		azoth_dief7	] {azoth_fly_death(20);self.height = 165;rift.frame = 34;};
void() azoth_dief7	=[	$dief7,		azoth_dief8	] {azoth_fly_death(20);self.height = 165;rift.frame = 34;};
void() azoth_dief8	=[	$dief8,		azoth_dief9	] {azoth_fly_death(20);self.height = 165;rift.frame = 33;};
void() azoth_dief9	=[	$dief9,		azoth_dief10	] {azoth_fly_death(20);self.height = 160;rift.frame = 34;};
void() azoth_dief10	=[	$dief10,	azoth_dief11	] {azoth_fly_death(20);self.height = 160;rift.frame = 35;};
void() azoth_dief11	=[	$dief11,	azoth_dief12	] {azoth_fly_death(20);self.height = 155;rift.frame = 36;};
void() azoth_dief12	=[	$dief12,	azoth_dief13	] {azoth_fly_death(20);self.height = 155;rift.frame = 37;};
void() azoth_dief13	=[	$dief13,	azoth_dief14	] {azoth_fly_death(20);self.height = 155;rift.frame = 38;};
void() azoth_dief14	=[	$dief14,	azoth_dief15	] {azoth_fly_death(20);self.height = 145;rift.frame = 39;};
void() azoth_dief15	=[	$dief15,	azoth_dief16	] {azoth_fly_death(70);self.height = 140;rift.frame = 40;};
void() azoth_dief16	=[	$dief16,	azoth_dief17	] {azoth_fly_death(70);self.height = 130;rift.frame = 40;};
void() azoth_dief17	=[	$dief17,	azoth_dief18	] {azoth_fly_death(70);self.height = 120;rift.frame = 40;};
void() azoth_dief18	=[	$dief18,	azoth_dief19	] {azoth_fly_death(70);self.height = 110;rift.frame = 40;};
void() azoth_dief19	=[	$dief19,	azoth_dief20	] {azoth_fly_death(50);self.height = 100;rift.frame = 40;};
void() azoth_dief20	=[	$dief20,	azoth_dief21	] {azoth_fly_death(20);self.height = 100;rift.frame = 39;sound (self, CHAN_VOICE, "azoth/awake.wav", 1, ATTN_NORM);};
void() azoth_dief21	=[	$dief21,	azoth_dief22	] {azoth_fly_death(20);self.height = 100;rift.frame = 38;};
void() azoth_dief22	=[	$dief22,	azoth_dief23	] {azoth_fly_death(20);self.height = 100;rift.frame = 37;};
void() azoth_dief23	=[	$dief23,	azoth_dief24	] {azoth_fly_death(20);self.height = 100;rift.frame = 37;};
void() azoth_dief24	=[	$dief24,	azoth_dief25	] {azoth_fly_death(20);self.height = 100;rift.frame = 34;rift.think = rift_close;};
void() azoth_dief25	=[	$dief25,	azoth_dief26	] {azoth_fly_death(20);self.height = 100;};
void() azoth_dief26	=[	$dief25,	azoth_dief25	] {
local entity gib;
gib = spawn();
gib.origin = rift.origin;

if (coop == 2)
	gib.origin = self.origin;

gib.movetype = MOVETYPE_BOUNCE;
setmodel (gib, "progs/azothgib.mdl");
setsize (gib, '0 0 -108', '0 0 0');
gib.velocity = '0 0 -20';
gib.solid = SOLID_TRIGGER;
gib.touch = leg_touch;
gib.angles = self.angles;
sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);

	ThrowGib ("progs/gib1.mdl", -10);
	ThrowGib ("progs/gib2.mdl", -10);
	ThrowGib ("progs/gib3.mdl", -10);
	ThrowGib ("progs/gib1.mdl", -10);
	ThrowGib ("progs/gib2.mdl", -10);
SUB_UseTargets();
killed_monster ();
remove(self);
};

void() dummy_test =
{

local entity dummy, oself;
local vector d;
local float r;
self.velocity = '0 0 0'; //reset the toss from being killed, so that azoth doesn't fly out of the arena after this test

dummy = self.trigger_field;
d = self.origin - dummy.origin;
dummy.angles = vectoangles(d);
oself = self;
self = dummy;
r = vlen(d);


if(!( walkmove(self.angles_y, r) ))
	{
	while(walkmove(self.angles_y, 10)){}//get fairly close
	self = oself;
	setorigin(self, dummy.origin);	//this can possibly be extended to some less obvious jump, spawning a waypoint here etc
					//even just smoothly noclipping the monster to this point
//	dprint("dummy failed to walkmove to azoth\n");
	}
else
	{
	self = oself;
	remove(dummy);
	self.trigger_field = world;
//	dprint("dummy managed to walkmove to azoth\n");
	}
}


void() azoth_dieb1;
void() trigger_stairpoint =
{
if (other.movetarget == self)
	{
	if(other.classname == "monster_azoth")
		{
		other.goalentity = self.enemy;

		other.movetarget = self.enemy;
			remove(self);
		return;
		}


	}
};
void() stairpoint_think2 =
{

self.solid = SOLID_TRIGGER;
setsize (self, '-16 -16 -32', '16 16 32');
force_retouch = 2;
}
void() stairpoint_think =
{


while(walkmove(75, 10)){}//walk it up the stairs


self.nextthink = time + 0.1;
self.think = stairpoint_think2;
}


void() SpawnStairWaypoint =
{

local entity waypoint,oself;
if(self.goalentity.classname == "stairpoint")
	return;
waypoint = spawn();
setorigin(waypoint, self.origin + '0 128 32');
waypoint.solid = SOLID_SLIDEBOX;
waypoint.classname = "stairpoint";

waypoint.movetype = MOVETYPE_STEP;
//setmodel(waypoint, "progs/s_explod.spr");
setsize (waypoint, '-16 -16 -32', '16 16 32');
oself = self;
self = waypoint;
droptofloor();

self = oself;


waypoint.touch = trigger_stairpoint;
waypoint.nextthink = time + 0.1;
waypoint.think = stairpoint_think;
waypoint.enemy = self.movetarget;
self.goalentity = waypoint;
self.movetarget = waypoint;

}

void() azoth_die1	=[	$diea1,		azoth_die2	] {

	movetogoal(20);

	sound (self, CHAN_VOICE, "azoth/pain.wav", 1, ATTN_NORM);
};
void() azoth_die2	=[	$diea2,		azoth_die3	] {
	movetogoal(5);
if(self.trigger_field)
	dummy_test();
};
void() azoth_die3	=[	$diea3,		azoth_die4	] {
if(self.origin_z < 216)
	SpawnStairWaypoint();

movetogoal(10);
if(self.trigger_field)
	dummy_test();};
void() azoth_die4	=[	$diea4,		azoth_die5	] {
if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

	movetogoal(25);
if(self.trigger_field)
	dummy_test();};
void() azoth_die5	=[	$diea5,		azoth_die6	] {
if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();
movetogoal(20);
if(self.trigger_field)
	dummy_test();};
void() azoth_die6	=[	$diea6,		azoth_die7	] {
if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

movetogoal(15);
if(self.trigger_field)
	dummy_test();};
void() azoth_die7	=[	$diea7,		azoth_die8	] {
if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();
movetogoal(10);};
void() azoth_die8	=[	$diea8,		azoth_die9	] {

if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

movetogoal(15);};
void() azoth_die9	=[	$diea9,		azoth_die10	] {

if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

	movetogoal(20);};
void() azoth_die10	=[	$diea10,	azoth_die11	] {

if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();


	movetogoal(15);};
void() azoth_die11	=[	$diea11,	azoth_die12	] {

if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

	movetogoal(15);
//compromise with one frame either side of a perfectly smooth transition
if(self.lip)
	{
	self.lip = 0;
	self.think = azoth_dieb1;
	}
};
void() azoth_die12	=[	$diea12,	azoth_die13	] {
if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

	movetogoal(20);
if(self.lip)
	{
	self.lip = 0;
	self.think = azoth_dieb1;
	}
};
void() azoth_die13	=[	$diea1,		azoth_die2	] {

if(self.origin_z < 216)//on the stairs
	SpawnStairWaypoint();

	movetogoal(20);
//compromise with one frame either side of a perfectly smooth transition
if(self.lip)
	{
	self.lip = 0;
	self.think = azoth_dieb1;
	}
};


void() azoth_dieb1	=[	$diea1,		azoth_dieb2	] {movetogoal(20);};
void() azoth_dieb2	=[	$dieb1,		azoth_dieb3	] {};
void() azoth_dieb3	=[	$dieb2,		azoth_dieb4	] {};
void() azoth_dieb4	=[	$dieb3,		azoth_dieb5	] {};
void() azoth_dieb5	=[	$dieb4,		azoth_dieb6	] {};
void() azoth_dieb6	=[	$dieb5,		azoth_dieb7	] {};
void() azoth_dieb7	=[	$dieb6,		azoth_dieb8	] {};
void() azoth_dieb8	=[	$dieb7,		azoth_diec1	] {};

void() trigger_dieb =
{
if (other.movetarget == self)
	{
	if(other.classname == "monster_azoth")
		other.lip = 1;

	}
};

void() azoth_die =
{

self.target = self.deathtype;//set the target back up
local entity waypoint, dummy, oself;
local vector d;
traceline(rift.origin, rift.origin - '0 0 1024', 1, rift);
waypoint = spawn();
setorigin(waypoint, trace_endpos + '0 0 16');

waypoint.solid = SOLID_TRIGGER;
waypoint.touch = trigger_dieb;
setsize (waypoint, '-16 -16 -8', '16 16 8');

azoth_die1();
self.movetarget = waypoint;
self.goalentity = waypoint;
self.enemy = world;

//crude hack to get azoth into a position where can walk to the waypoint
//may want to smooth this out a little later

dummy = spawn();
dummy.owner = self;

self.trigger_field = dummy;
dummy.solid = SOLID_SLIDEBOX;
dummy.movetype = MOVETYPE_STEP;

//setmodel(dummy, "progs/s_explod.spr");

setsize (dummy, '-32 -32 -24', '32 32 160');
setorigin(dummy, waypoint.origin + '0 0 128');//ensure the rift is above reasonably flat, open ground so this isn't stuck
oself = self;self = dummy;
droptofloor();
self = oself;
//dummy.velocity = '0 0 -4000';
//need to wait for droptofloor to happen, so we try out the dummy next frame;
};

//external files modified:
//combat.qc - killed - 	exception to bumping monster count for Azoth since death is just the beginning
//			more precisely we abuse the 'death' function to change combat modes
//			Also there's an added line to call the reaction animation if the player is killed
//			Azoth walks forward and faces out from the tower

//ai.qc	- CheckAnyAttack - add Azoth's own check, depends on current strategy, CheckAttack isn't enough
//	- SightSound - added Azoth's sound
//fight.qc - added AzothCheckAttack function, and many other functions that it calls for decision making
//client.qc - Added obituary message in ClientObituary, added end text in IntermissionExit
//weapons.qc - Altered rocket touch so it bounces off Azoth like a grenade when he's shielding
//world.qc - Added lightstyle(12, "m"); to the defined light styles
//zombie.qc - Added spawnflag 8 code to zombie_paine12 which gibs zombies if they are stuck and have this spawnflag


void() azoth_phase2;
void() azoth_phase1 =
{

	sound (self, CHAN_VOICE, "azoth/pain.wav", 1, ATTN_NORM);
	self.health = 1500  + (skill * 300);
	self.th_run = azoth_run1;
	self.th_die = azoth_phase2;
	self.th_melee = azoth_hammer1;
	self.th_missile = azoth_fire1;
//	self.th_missile = azoth_throw1;
	self.state = TARGET_TOWER;
	self.takedamage = DAMAGE_AIM;
	SUB_AttackFinished(1); // stop a immediate missile attack on change
	azoth_run1();
}

void() azoth_phase2b =
{

	self.solid = SOLID_SLIDEBOX;
	setmodel (self, "progs/azoth.mdl");

	setsize (self, '-32 -32 -24', '32 32 160');
 	setorigin(self, self.origin);
	self.movetype = MOVETYPE_STEP;
	self.velocity = '0 0 0';
	self.health = 500 + (skill * 250); //bit less interesting to fight, so low health
	self.th_run = azoth_s_run1;
	self.th_die = azoth_phase5;
	self.th_melee = azoth_swipe1;
	self.pos2 = gate;
	self.th_missile = SUB_Null;
//	dprint("phase 2b called\n");
	self.takedamage = DAMAGE_AIM;
	self.attack_finished = time + 1;	// stop a immediate missile attack on change
/*if(self.flags & FL_ONGROUND)
	azoth_swipe15();	//this frame just begins the covering up after the swipe
else				//so it's a smoother transition
*/
	azoth_land1();

}
void() azoth_phase2 =
{
	local vector spot,vout,vperp;
if(vlen(self.origin - gate) > 700)
	{

	sound (self, CHAN_VOICE, "azoth/pain.wav", 1, ATTN_NORM);
	if(towerquadrant(self) == 2 && self.origin_z > 700)
		self.pos1 = '1600 -1728 1800';
	else if(towerquadrant(self) == 4)
		self.pos1 =   gate + '0 0 1' * self.origin_z;
	else
		{
		vout = normalize(self.origin - tower - ('0 0 1' * self.origin_z));
		vperp = '-1 0 0' * vout_y + '1 0 0' * vout_x;

		spot = 800 * vout + 100 * vperp;
		spot_z = 700;
		self.pos1 = tower + spot;
/*		local entity debug;
		debug = spawn();
		setmodel (debug, "progs/player.mdl");
		setorigin(debug, self.pos1);*/
		}



	azoth_leap1();
	self.attack_finished = time + 15;//time to finish the flight

	self.state = TARGET_GATE;
	self.solid = SOLID_NOT;
	return;
	}
else
	{
	azoth_phase2b();
	azoth_swipe15();
	}
}


void() azoth_tele1	=[	$stand1,	azoth_tele2	] {};
void() azoth_tele2	=[	$stand2,	azoth_tele3	] {};
void() azoth_tele3	=[	$stand3,	azoth_tele4	] {};
void() azoth_tele4	=[	$stand4,	azoth_tele5	] {};
void() azoth_tele5	=[	$stand5,	azoth_tele6	] {};
void() azoth_tele6	=[	$stand6,	azoth_tele7	] {};
void() azoth_tele7	=[	$stand7,	azoth_tele8	] {};
void() azoth_tele8	=[	$stand8,	azoth_tele9	] {};
void() azoth_tele9	=[	$stand9,	azoth_tele10	] {};
void() azoth_tele10	=[	$stand10,	azoth_tele11	] {};
void() azoth_tele11	=[	$stand11,	azoth_tele1	] {

if(self.rad_time < time)
{
	spawn_tfog(self.origin);
	sound (self, CHAN_VOICE, "misc/r_tele5.wav", 1, 4);
	 remove(self);
}

};


void() azoth_flee2
{
self.th_run = SUB_Null;
azoth_tele1();
SUB_UseTargets();
self.rad_time = time + 2;
}

void() azoth_flee =
{
self.th_run = azoth_flee2;
self.th_melee = SUB_Null;
self.th_die = SUB_Null;
self.th_missile = SUB_Null;
self.target = self.deathtype;//set the target back up

	sound (self, CHAN_VOICE, "azoth/pain.wav", 1, ATTN_NONE);

self.state = TARGET_EXIT;
//self.pos1 = '2779 -3371 80';
self.pos1 = self.origin + '0 0 80';
//self.attack_finished = time + 100;
self.attack_finished = time + 5;

//azoth_leap1();
self.movetype = MOVETYPE_NOCLIP;

self.solid = SOLID_NOT;
setmodel (self, "progs/azoth.mdl");
setsize(self,'0 0 -24', '0 0 0');

azoth_fly1();
self.flags = self.flags - (self.flags & FL_ONGROUND);
self.velocity = '0 0 200';
};
void() azoth_phase5 =
{
	local float q;
//	dprint("phase 5\n");
	self.health = 1700 + (skill * 300);
	self.th_run = azoth_run1;
	self.th_die = azoth_phase1;
	self.th_melee = azoth_swipe1;
	self.th_die = azoth_flee;
	self.th_missile = SUB_Null;
	self.takedamage = DAMAGE_AIM;
	q = towerquadrant(self);
	Azoth_flytosecond();
//	self.pos1 = azoth_phase5_location(self.origin_z, q);
	self.pos1 = '2290 -1940 920';
//	azoth_leap1();
	self.state = TARGET_TOWER;
};
void() azoth_phase4 =
{
//	dprint("phase 4\n");
	self.health = 1700 + (skill * 300);
	self.th_run = azoth_run1;
	self.th_die = azoth_phase1;
	self.th_melee = azoth_hammer1;
	self.th_die = azoth_phase5;
	self.th_missile = azoth_throw1;
	self.takedamage = DAMAGE_AIM;
};



void() azoth_phase7b =
{

	self.solid = SOLID_SLIDEBOX;
	setmodel (self, "progs/azoth.mdl");

	setsize (self, '-32 -32 -24', '32 32 160');
	self.movetype = MOVETYPE_STEP;
	self.velocity = '0 0 0';
	self.health = 500 + (skill * 250);  //bit less interesting to fight, so low health
//	self.th_run = azoth_s_run1;
	self.th_run = azoth_swipe15;
	self.th_die = azoth_die;
	self.th_melee = azoth_swipe1;

	self.th_missile = SUB_Null;
	traceline(rift.origin, rift.origin - '0 0 2048', TRUE, self);
	self.pos2 = trace_endpos;
	self.takedamage = DAMAGE_AIM;
	SUB_AttackFinished(1);	// stop a immediate missile attack on change
/*if(self.flags & FL_ONGROUND)
	azoth_swipe15();	//this frame just begins the covering up after the swipe
else*/				//so it's a smoother transition
	azoth_land1();

}

void() azoth_phase7 =
{

//dprint("phase 7\n");
if(vlen(self.origin - rift.origin + '0 0 500') > 200)
	{

	sound (self, CHAN_VOICE, "azoth/pain.wav", 1, ATTN_NORM);

	azoth_leap1();
	self.attack_finished = time + 10;//time to finish the flight

	self.state = TARGET_RIFT;
	azoth_new_flightpoint();
//	self.solid = SOLID_NOT;
	return;
	}
else
	{
	azoth_phase7b();
	azoth_swipe15();
	}
}


void() monster_azoth_restart_go =

{
	self.classname = "monster_azoth";
	if (deathmatch)
	{
		remove(self);
		return;
	}


	lightstyle(12, "m");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/azoth.mdl");

	setsize (self, '-32 -32 -24', '32 32 160');
	self.health = 1700 + (skill * 300);

	self.th_stand = azoth_stand1;
	self.th_walk = azoth_walk1;
	self.th_run = azoth_run1;
	self.th_die = azoth_phase7;
	self.th_melee = azoth_hammer1;
	self.th_missile = azoth_throw1;
	self.yaw_speed = 45;
	self.deathtype = self.target;
	self.target = string_null;//smuggle the target until it's needed - so it's not triggered on first 'death';
	walkmonster_start_go();
	self.nextthink = time + 0.1;
	self.enemy = activator;
	self.think = FoundTarget;

}

void() monster_azoth_restart =
{
	precache_model ("progs/azoth.mdl");
 	precache_model ("progs/azothgib.mdl");
 	precache_model ("progs/shockwav.mdl");
 	precache_model ("progs/s_flame.spr");
	precache_sound ("azoth/thud.wav");
	precache_sound ("azoth/flap.wav");
	precache_sound ("azoth/fire.wav");
	precache_sound ("azoth/pain.wav");
	precache_sound ("azoth/awake.wav");
	precache_sound ("demon/dland2.wav");
	precache_sound ("azoth/portal.wav");
	precache_sound ("azoth/crunch.wav");
	precache_model ("progs/skull.mdl");
	precache_sound ("azoth/thwack.wav");
self.use = monster_azoth_restart_go;
	total_monsters = total_monsters + 1;
}

void() monster_azoth =

{
	self.classname = "monster_azoth";
	if (deathmatch)
	{
		remove(self);
		return;
	}


	lightstyle(12, "m");

	precache_model ("progs/azoth.mdl");
 	precache_model ("progs/azothgib.mdl");
 	precache_model ("progs/shockwav.mdl");
 	precache_model ("progs/s_flame.spr");
	precache_sound ("azoth/thud.wav");
	precache_sound ("azoth/flap.wav");
	precache_sound ("azoth/fire.wav");
	precache_sound ("azoth/pain.wav");
	precache_sound ("azoth/awake.wav");
	precache_sound ("azoth/portal.wav");
	precache_sound ("demon/dland2.wav");
	precache_sound ("azoth/crunch.wav");
	precache_model ("progs/skull.mdl");
	precache_sound ("azoth/thwack.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/azoth.mdl");

	setsize (self, '-32 -32 -24', '32 32 160');
	self.health = 1700 + (skill * 300);

//	self.target = "Gate_1";//FIXME: hack just to test atm, remove me
	self.deathtype = self.target;
	self.target = string_null;//smuggle the target until it's needed - so it's not triggered on first 'death';
	self.th_stand = azoth_stand1;
	self.th_walk = azoth_walk1;
	self.th_run = azoth_run1;
	self.th_die = azoth_phase2;
	self.th_melee = azoth_hammer1;
	self.th_missile = azoth_throw1;
	self.yaw_speed = 45;
	walkmonster_start();
}
/*
void() monster_azoth_death =

{
	self.classname = "monster_azoth";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/azoth.mdl");
 	precache_model ("progs/azothgib.mdl");
 	precache_model ("progs/shockwav.mdl");
 	precache_model ("progs/s_flame.spr");
	precache_sound ("azoth/thud.wav");
	precache_sound ("azoth/flap.wav");
	precache_sound ("azoth/pain.wav");
	precache_sound ("azoth/awake.wav");
	precache_sound ("azoth/fire.wav");
	precache_sound ("azoth/portal.wav");
	precache_sound ("demon/dland2.wav");
	precache_sound ("azoth/thwack.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/azoth.mdl");

	setsize (self, '-48 -48 -24', '48 48 160');
	self.health = 90;

	self.th_stand = azoth_stand1;
	self.th_walk = azoth_walk1;
	self.th_run = azoth_run1;
	self.th_die = azoth_die;
	self.th_melee = azoth_hammer1;
	self.th_missile = azoth_throw1;
	self.yaw_speed = 45;
	self.lip = 0;
	walkmonster_start();

}
*/

void(entity sky) spawn_blacksky =
{
setmodel(sky,sky.model);
//dprint("found a func_blacksky\n");

//maybe makestatic too?
}
void() nightfall2 = [0, nightfall3]{lightstyle(0, "k");};
void() nightfall3 = [0, nightfall4]{lightstyle(0, "j");};
void() nightfall4 = [0, nightfall5]{lightstyle(0, "i");};
void() nightfall5 = [0, nightfall6]{lightstyle(0, "h");};
void() nightfall6 = [0, SUB_Null]{lightstyle(0, "g");};


void() event_nightfall =
{
local entity sky;

//dim all standard lights
//artificial lights (ie lights that aren't supposed to be cast by daylight)
//should be given a lightstyle of 12
	lightstyle(0, "l");

sky = find(world, classname, "func_blacksky");
while(sky)
	{
	spawn_blacksky(sky);
	sky = find(sky, classname, "func_blacksky");
	}
self.nextthink = time + 0.1;
self.think = nightfall2;

}
void() func_blacksky =
{};

void() sky_open =
{

local entity sky;
sky = spawn();
setmodel(sky,"progs/sky.mdl");
setorigin(sky, self.origin);
self.enemy = sky;
}

void() rift_hold =
{
local float r;
self.nextthink = time + 0.1;
r = random();
if(r < 0.35)
	{
	self.effects = EF_MUZZLEFLASH;
	lightstyle(0, "k");
	}
else
	lightstyle(0, "g");
self.think = rift_hold;
self.skin = 1 - self.skin;

}
void() rift_close =
{
local float r;
lightstyle(0, "e");
if(self.frame > 0)
	{
	self.frame = self.frame - 1;
	self.nextthink = time + 0.05;
	}
else
	{
	SUB_UseTargets();
	remove(self);
	return;
	}
r = random();
if(r < 0.35)
	self.effects = EF_MUZZLEFLASH;



if(self.frame == 20)
	remove(self.enemy);

self.think = rift_close;
self.skin = 1 - self.skin;
}

void() rift_open =
{
local float r;
if(self.frame < 40)
	{
	self.frame = self.frame + 1;
	self.nextthink = time + 0.05;
	}
else
	self.nextthink = time + 0.1;

r = random();
if(r < 0.35)
	{
	self.effects = EF_MUZZLEFLASH;
	lightstyle(0, "k");
	}
else
	lightstyle(0, "g");
if(self.frame == 20)
	{
	sky_open();
//	sound (self, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NONE);
	}
self.think = rift_open;
self.skin = 1 - self.skin;
}

void() rift_open_start =
{
setmodel(self,"progs/rift.mdl");
self.avelocity = '0 500 0';
self.movetype = MOVETYPE_NOCLIP;
self.frame = 0;
self.nextthink = time + 0.05;
self.think = rift_open;
sound (self, CHAN_VOICE, "azoth/portal.wav", 1, ATTN_NONE);
}


void() info_rift =
{
precache_model("progs/rift.mdl");
precache_model("progs/sky.mdl");
self.use = rift_open_start;
if(!rift)
	rift = self;
}

void() misc_mapmodel =
{
if(!self.model)
	{
	dprint("misc_mapmodel has no model key set\n");
	remove(self);
	return;
	}
precache_model(self.model);
setmodel(self, self.model);

if(self.spawnflags & 1)
	makestatic(self);
}
