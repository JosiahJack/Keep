/*
==============================================================================

ENFORCER

Bunch o changes made to this by Lunaran
June 2005
www.lunaran.com

Spawnflags 2 and 4 now create Mega and Ultra Enforcers
MegaEnforcers have zerstorer-enforcer particle blasts and ogre grenade launches
Ultra Enforcers have rocket launchers, hellknight plasma sprays, and
	buffered particle shields

These were made to lend some hell knight/ogre functionality to base maps that
	don't have knights and ogres (like for example maybe lunsp1)

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

float MEGA_ENF = 2;
float ULTRA_ENF = 4;
void() menf_ratk9;

//============================================================================
// SHIELD CRAP
// The shield is kept in self.armorvalue, and recharges quickly up to a
// strength of 30, quicker on higher difficulty levels.  It doesn't recharge
// while he's in pain frames or firing his weapon.
// It's denoted by a ring of particles around him that changes color and
// density based on strength.
//============================================================================

float(vector a, vector b) dot =
{
	local float doot;
	doot = a_x * b_x + a_y * b_y + a_z * b_z;
	return doot;
};

void() enforcer_shieldthink = {
	if (!IsAlive(self.owner))
	{
		remove(self);
		return;
	}
	local float strength, i;
	local vector offset, org;

	org = self.owner.origin;

	self.angles = '0 0 0';
//	self.origin = org;	// apparently I'm not supposed to do that
	setorigin(self, org);	//fixed by Preach : - p
				//it was kinda ok anyway as it's movetype_none
				//but darkplaces is fussy about this stuff
	strength = floor( self.owner.armorvalue / 8 );

	if (strength > 0) {
		for (i = 0; i < 5; i++) {
			self.angles_x = time * 140;
			self.angles_y = 360 * (i / 5);
			makevectors(self.angles);
			offset = v_forward * 20 + v_up * 3 + org;
//			particle (offset + '0 0 -24', '0 0 0', 227 + strength*2, strength);
			particle (offset, v_forward * 2, 227 + strength*2, strength);
//			particle (offset + '0 0 40', '0 0 0', 227 + strength*2, strength);
		}
	}
	self.nextthink = time + 0.1;
}

void() enforcer_spawnshieldfx = {
	local entity shieldfx;
	shieldfx = spawn();
//	bprint ("Shield spawnded!\n");
	shieldfx.owner = self;
	shieldfx.movetype = MOVETYPE_NONE;
	setorigin (shieldfx, self.origin);
	setsize( shieldfx, '0 0 0', '0 0 0');
	shieldfx.nextthink = time + 0.05;
	shieldfx.think = enforcer_shieldthink;
}

void() enforcer_updateshield = {
	if (self.spawnflags & ULTRA_ENF) {
		self.armorvalue = self.armorvalue + 2 + skill;
		if (self.armorvalue > 30)
			self.armorvalue = 30;
//		bprint (ftos(self.armorvalue));
//		bprint ("\n");
	}
}

//============================================================================
// WEAPONY GOODNESS
//============================================================================

void() Laser_Touch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}

	remove(self);
};

void() Laser2_Touch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 9);
		T_Damage (other, self, self.owner, 9);
	}
	remove(self);
};

void(vector org, vector vec) LaunchLaser =
{
	local	vector	d;
	local float		t;

	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
      	newmis.classname = "laser";
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};

void() enforcer_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	LaunchLaser(org, self.enemy.origin - self.origin);
};

// Yoinked from Zer

void() particlethink =
{
	if (self.wait < time)
	{
		remove(self);
		return;
	}
	particle (self.origin, self.oldorigin, 10, 4);
	particle (self.origin, self.oldorigin, 46, 6);
	self.nextthink = time + 0.05;
};

void() enforcer_fireparticlebeam =
{
local vector org,mep,nmep;
local	entity missile, mpuff;
local vector lead, spot;
local float go;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	sound (self, CHAN_WEAPON, "enforcer/me_fire1.wav", 1, ATTN_NORM);

	go = vlen(self.enemy.origin - org) / 400;
	mep = self.enemy.velocity;
	mep_z = 0;
	spot = self.enemy.origin + mep * go;

	traceline(org, spot, FALSE, world);
	if (trace_fraction < 0.8 || vlen(self.origin - self.enemy.origin) > 768) {
		// Not a clear lead shot, shoot at player
		spot = self.enemy.origin;
	}
	if ( dot( normalize( spot - org ), v_forward ) < 0.75 ) {
		// Too wacky an angle, just shoot at player
		spot = self.enemy.origin;
	}
	lead = normalize(spot - org);

	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_BBOX;
	missile.effects = EF_DIMLIGHT;

	setmodel (missile, "progs/laser2.mdl");
	setorigin (missile, org);
	setsize (missile, '0 0 0', '0 0 0');

	missile.velocity = lead * 500;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = Laser2_Touch;

	missile.wait = time + 5;
	missile.nextthink = time + 0.05;
	missile.think = particlethink;
};

void() enforcer_missiletouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner
	if (pointcontents(self.origin) == CONTENT_SKY)	{
		remove(self);
		return;
	}

	damg = 50 + random()*20;
	if (other.health)
	{
		if (other.classname == "monster_enforcer")
			damg = damg * 0.5;	// not so rough on compatriots
		T_Damage (other, self, self.owner, damg );
	}
	T_RadiusDamage (self, self.owner, damg, other);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() enforcer_firerocket =
{
	local vector org;
	local	entity missile, mpuff;
	local vector mep,nmep;
	local vector lead, spot;
	local float go;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	go = vlen(self.enemy.origin - org) / 500;
	mep = self.enemy.velocity;
	mep_z = 0;
	spot = self.enemy.origin + mep * go;

	traceline(org, spot, FALSE, world);
	if (trace_fraction < 0.8)
	{
		//dprint("Not a clear lead shot, shoot at player.\n");
		spot = self.enemy.origin;
	}

	lead = normalize(spot - org);
	traceline(org, spot, FALSE, world);
	if ( trace_fraction < 0.8 ) {
		// Something got in the way, skip it
		menf_ratk9();
		return;
	}

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*12 + '0 0 8');
	missile.velocity = lead * 400;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = enforcer_missiletouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
};

void(float offset) enforcer_fireknight =
{
	local	vector	offang;
	local	vector	org, vec;
	local vector mep,nmep;
	local vector lead, spot;
	local float go;

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 4;

	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 12;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;

	launch_spike (org, vec);
	newmis.classname = "knightspike";
	newmis.touch = Laser2_Touch;
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec*400;
	sound (self, CHAN_WEAPON, "enforcer/ue_fire1.wav", 1, ATTN_NORM);
};

//============================================================================

void()	enf_stand1	=[	$stand1,	enf_stand2	] {ai_stand();};
void()	enf_stand2	=[	$stand2,	enf_stand3	] {ai_stand();};
void()	enf_stand3	=[	$stand3,	enf_stand4	] {ai_stand();};
void()	enf_stand4	=[	$stand4,	enf_stand5	] {ai_stand();};
void()	enf_stand5	=[	$stand5,	enf_stand6	] {ai_stand();};
void()	enf_stand6	=[	$stand6,	enf_stand7	] {ai_stand();};
void()	enf_stand7	=[	$stand7,	enf_stand1	] {ai_stand();};

void()	enf_walk1	=[	$walk1 ,	enf_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_walk(2);};
void()	enf_walk2	=[	$walk2 ,	enf_walk3	] {ai_walk(4);};
void()	enf_walk3	=[	$walk3 ,	enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	$walk4 ,	enf_walk5	] {ai_walk(3);};
void()	enf_walk5	=[	$walk5 ,	enf_walk6	] {ai_walk(1);};
void()	enf_walk6	=[	$walk6 ,	enf_walk7	] {ai_walk(2);};
void()	enf_walk7	=[	$walk7 ,	enf_walk8	] {ai_walk(2);};
void()	enf_walk8	=[	$walk8 ,	enf_walk9	] {ai_walk(1);};
void()	enf_walk9	=[	$walk9 ,	enf_walk10	] {ai_walk(2);};
void()	enf_walk10	=[	$walk10,	enf_walk11	] {ai_walk(4);};
void()	enf_walk11	=[	$walk11,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	$walk12,	enf_walk13	] {ai_walk(1);};
void()	enf_walk13	=[	$walk13,	enf_walk14	] {ai_walk(2);};
void()	enf_walk14	=[	$walk14,	enf_walk15	] {ai_walk(3);};
void()	enf_walk15	=[	$walk15,	enf_walk16	] {ai_walk(4);};
void()	enf_walk16	=[	$walk16,	enf_walk1	] {ai_walk(2);};

void()	enf_run1	=[	$run1  ,	enf_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_run(18);};
void()	enf_run2	=[	$run2  ,	enf_run3	] {ai_run(14); enforcer_updateshield(); };
void()	enf_run3	=[	$run3  ,	enf_run4	] {ai_run(7); enforcer_updateshield(); };
void()	enf_run4	=[	$run4  ,	enf_run5	] {ai_run(12); enforcer_updateshield(); };
void()	enf_run5	=[	$run5  ,	enf_run6	] {ai_run(14); enforcer_updateshield(); };
void()	enf_run6	=[	$run6  ,	enf_run7	] {ai_run(14); enforcer_updateshield(); };
void()	enf_run7	=[	$run7  ,	enf_run8	] {ai_run(7); enforcer_updateshield(); };
void()	enf_run8	=[	$run8  ,	enf_run1	] {ai_run(11); enforcer_updateshield(); };

void()	enf_atk1	=[	$attack1,	enf_atk2	] {ai_face();};
void()	enf_atk2	=[	$attack2,	enf_atk3	] {ai_face();};
void()	enf_atk3	=[	$attack3,	enf_atk4	] {ai_face();};
void()	enf_atk4	=[	$attack4,	enf_atk5	] {ai_face();};
void()	enf_atk5	=[	$attack5,	enf_atk6	] {ai_face();};
void()	enf_atk6	=[	$attack6,	enf_atk7	] {enforcer_fire();};
void()	enf_atk7	=[	$attack7,	enf_atk8	] {ai_face();};
void()	enf_atk8	=[	$attack8,	enf_atk9	] {ai_face();};
void()	enf_atk9	=[	$attack5,	enf_atk10	] {ai_face();};
void()	enf_atk10	=[	$attack6,	enf_atk11	] {enforcer_fire();};
void()	enf_atk11	=[	$attack7,	enf_atk12	] {ai_face();};
void()	enf_atk12	=[	$attack8,	enf_atk13	] {ai_face();};
void()	enf_atk13	=[	$attack9,	enf_atk14	] {ai_face();};
void()	enf_atk14	=[	$attack10,	enf_run1	] {ai_face();
SUB_CheckRefire (enf_atk1);
};

void()	menf_atk1	=[	$attack1,	menf_atk2	] {ai_face(); };
void()	menf_atk2	=[	$attack2,	menf_atk3	] {ai_face(); };
void()	menf_atk3	=[	$attack3,	menf_atk4	] {ai_face(); };
void()	menf_atk4	=[	$attack4,	menf_atk5	] {ai_face(); };
void()	menf_atk5	=[	$attack5,	menf_atk6	] {ai_face(); };
void()	menf_atk6	=[	$attack6,	menf_atk7	] {ai_face(); enforcer_fireparticlebeam(); };
void()	menf_atk7	=[	$attack7,	menf_atk8	] {ai_face(); };
void()	menf_atk8	=[	$attack5,	menf_atk9	] {ai_face(); };
void()	menf_atk9	=[	$attack6,	menf_atk10	] {ai_face(); enforcer_fireparticlebeam(); };
void()	menf_atk10	=[	$attack7,	menf_atk11	] {ai_face();};
void()	menf_atk11	=[	$attack5,	menf_atk12	] {ai_face();};
void()	menf_atk12	=[	$attack6,	menf_atk13	] {enforcer_fireparticlebeam(); };
void()	menf_atk13	=[	$attack7,	menf_atk14	] {ai_face();};
void()	menf_atk14	=[	$attack8,	menf_atk15	] {ai_face(); };
void()	menf_atk15	=[	$attack9,	menf_atk16	] {ai_face(); };
void()	menf_atk16	=[	$attack10,	enf_run1	] {ai_face(); SUB_CheckRefire (menf_atk1);};

void()	menf_zatk1	=[	$attack1,	menf_zatk2	] {ai_face(); enforcer_updateshield(); };
void()	menf_zatk2	=[	$attack2,	menf_zatk3	] {ai_face(); enforcer_updateshield(); };
void()	menf_zatk3	=[	$attack3,	menf_zatk4	] {ai_face(); enforcer_updateshield(); };
void()	menf_zatk4	=[	$attack4,	menf_zatk5	] {ai_face(); enforcer_updateshield(); };
void()	menf_zatk5	=[	$attack5,	menf_zatk6	] {ai_face();};
void()	menf_zatk6	=[	$attack6,	menf_zatk7	] {enforcer_fireknight(-3); };
void()	menf_zatk7	=[	$attack7,	menf_zatk8	] {enforcer_fireknight(-2); };
void()	menf_zatk8	=[	$attack6,	menf_zatk9	] {enforcer_fireknight(-1); };
void()	menf_zatk9	=[	$attack5,	menf_zatk10	] {enforcer_fireknight(0); };
void()	menf_zatk10	=[	$attack6,	menf_zatk11	] {enforcer_fireknight(1); };
void()	menf_zatk11	=[	$attack7,	menf_zatk12	] {enforcer_fireknight(2); };
void()	menf_zatk12	=[	$attack6,	menf_zatk13	] {enforcer_fireknight(3); };
void()	menf_zatk13	=[	$attack8,	menf_zatk14	] {ai_face();};
void()	menf_zatk14	=[	$attack9,	menf_zatk15	] {ai_face(); enforcer_updateshield(); };
void()	menf_zatk15	=[	$attack10,	enf_run1	] {ai_face();  enforcer_updateshield(); SUB_CheckRefire (menf_zatk1);};

void()	menf_gatk1	=[	$attack1,	menf_gatk2	] {ai_face();};
void()	menf_gatk2	=[	$attack2,	menf_gatk3	] {ai_face();};
void()	menf_gatk3	=[	$attack3,	menf_gatk4	] {ai_face();};
void()	menf_gatk4	=[	$attack4,	menf_gatk5	] {ai_face();};
void()	menf_gatk5	=[	$attack5,	menf_gatk6	] {ai_face();};
void()	menf_gatk6	=[	$attack6,	menf_gatk7	] {ai_face(); OgreFireGrenade();};
void()	menf_gatk7	=[	$attack7,	menf_gatk8	] {ai_face();};
void()	menf_gatk8	=[	$attack8,	menf_gatk9	] {ai_face();};
void()	menf_gatk9	=[	$attack9,	menf_gatk10	] {ai_face();};
void()	menf_gatk10	=[	$attack10,	enf_run1	] {ai_face(); SUB_CheckRefire (menf_gatk1);};

void()	menf_ratk1	=[	$attack1,	menf_ratk2	] {ai_face(); enforcer_updateshield(); };
void()	menf_ratk2	=[	$attack2,	menf_ratk3	] {ai_face(); enforcer_updateshield(); };
void()	menf_ratk3	=[	$attack3,	menf_ratk4	] {ai_face(); enforcer_updateshield(); };
void()	menf_ratk4	=[	$attack4,	menf_ratk5	] {ai_face();};
void()	menf_ratk5	=[	$attack5,	menf_ratk6	] {ai_face();};
void()	menf_ratk6	=[	$attack6,	menf_ratk7	] {ai_face(); enforcer_firerocket();};
void()	menf_ratk7	=[	$attack7,	menf_ratk8	] {ai_face();};
void()	menf_ratk8	=[	$attack8,	menf_ratk9	] {ai_face();};
void()	menf_ratk9	=[	$attack9,	menf_ratk10	] {ai_face(); enforcer_updateshield(); };
void()	menf_ratk10	=[	$attack10,	enf_run1	] {ai_face();  enforcer_updateshield(); SUB_CheckRefire (menf_ratk1);};



void() enforcer_attack = {
local float edist;
edist = vlen(self.enemy.origin - self.origin);

	if (self.spawnflags & ULTRA_ENF) {
		if (random() < edist / 768 - 0.15)
			menf_ratk1();
		else
			menf_zatk1();
	} else if (self.spawnflags & MEGA_ENF) {
		if (edist < 768 && random() > 0.5)
			menf_gatk1();
		else
			menf_atk1();
	} else {
		enf_atk1();
	}
};


//============================================================================


void()	enf_paina1	=[	$paina1,	enf_paina2	] {};
void()	enf_paina2	=[	$paina2,	enf_paina3	] {};
void()	enf_paina3	=[	$paina3,	enf_paina4	] {};
void()	enf_paina4	=[	$paina4,	enf_run1	] { };

void()	enf_painb1	=[	$painb1,	enf_painb2	] {};
void()	enf_painb2	=[	$painb2,	enf_painb3	] {};
void()	enf_painb3	=[	$painb3,	enf_painb4	] {};
void()	enf_painb4	=[	$painb4,	enf_painb5	] {};
void()	enf_painb5	=[	$painb5,	enf_run1	] { enforcer_updateshield(); };

void()	enf_painc1	=[	$painc1,	enf_painc2	] {};
void()	enf_painc2	=[	$painc2,	enf_painc3	] {};
void()	enf_painc3	=[	$painc3,	enf_painc4	] {};
void()	enf_painc4	=[	$painc4,	enf_painc5	] {};
void()	enf_painc5	=[	$painc5,	enf_painc6	] { enforcer_updateshield(); };
void()	enf_painc6	=[	$painc6,	enf_painc7	] { enforcer_updateshield(); };
void()	enf_painc7	=[	$painc7,	enf_painc8	] { enforcer_updateshield(); };
void()	enf_painc8	=[	$painc8,	enf_run1	] { enforcer_updateshield(); };

void()	enf_paind1	=[	$paind1,	enf_paind2	] {};
void()	enf_paind2	=[	$paind2,	enf_paind3	] {};
void()	enf_paind3	=[	$paind3,	enf_paind4	] {};
void()	enf_paind4	=[	$paind4,	enf_paind5	] {ai_painforward(2);};
void()	enf_paind5	=[	$paind5,	enf_paind6	] {ai_painforward(1);};
void()	enf_paind6	=[	$paind6,	enf_paind7	] {};
void()	enf_paind7	=[	$paind7,	enf_paind8	] {};
void()	enf_paind8	=[	$paind8,	enf_paind9	] {};
void()	enf_paind9	=[	$paind9,	enf_paind10	] {};
void()	enf_paind10	=[	$paind10,	enf_paind11	] { enforcer_updateshield(); };
void()	enf_paind11	=[	$paind11,	enf_paind12	] {ai_painforward(1); enforcer_updateshield(); };
void()	enf_paind12	=[	$paind12,	enf_paind13	] {ai_painforward(1); enforcer_updateshield(); };
void()	enf_paind13	=[	$paind13,	enf_paind14	] {ai_painforward(1); enforcer_updateshield(); };
void()	enf_paind14	=[	$paind14,	enf_paind15	] { enforcer_updateshield(); };
void()	enf_paind15	=[	$paind15,	enf_paind16	] { enforcer_updateshield(); };
void()	enf_paind16	=[	$paind16,	enf_paind17	] {ai_pain(1); enforcer_updateshield(); };
void()	enf_paind17	=[	$paind17,	enf_paind18	] {ai_pain(1); enforcer_updateshield(); };
void()	enf_paind18	=[	$paind18,	enf_paind19	] { enforcer_updateshield(); };
void()	enf_paind19	=[	$paind19,	enf_run1	] { enforcer_updateshield(); };

void(entity attacker, float damage)	enf_pain = {
	local float r;

	r = random ();
	if (self.pain_finished > time)
		return;

	if (self.spawnflags & ULTRA_ENF) {
		if (random() > 0.3)
			return;
		else {
			if (r < 0.3)
				sound (self, CHAN_VOICE, "enforcer/ue_pain1.wav", 1, ATTN_NORM);
			else if (r < 0.6)
				sound (self, CHAN_VOICE, "enforcer/ue_pain2.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "enforcer/ue_pain3.wav", 1, ATTN_NORM);

			r = random ();
			if (r < 0.3) {
				self.pain_finished = time + 1;
				enf_paina1 ();
			} else if (r < 0.7) {
				self.pain_finished = time + 1;
				enf_painb1 ();
			} else {
				self.pain_finished = time + 1;
				enf_painc1 ();
			}
		}
	} else if (self.spawnflags & MEGA_ENF) {
		if (random() > 0.5)
			return;
		else {
			if (r < 0.5)
				sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
			if (r < 0.3) {
				self.pain_finished = time + 1;
				enf_paina1 ();
			}	else if (r < 0.6) {
				self.pain_finished = time + 1;
				enf_painb1 ();
			}	else if (r < 0.8) {
				self.pain_finished = time + 1;
				enf_painc1 ();
			}	else {
				self.pain_finished = time + 2;
				enf_paind1 ();
			}
		}
	} else {
		if (r < 0.5)
			sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
		if (r < 0.3) {
			self.pain_finished = time + 1;
			enf_paina1 ();
		}	else if (r < 0.6) {
			self.pain_finished = time + 1;
			enf_painb1 ();
		}	else if (r < 0.8) {
			self.pain_finished = time + 1;
			enf_painc1 ();
		}	else {
			self.pain_finished = time + 2;
			enf_paind1 ();
		}
	}
};

//============================================================================

void() DropAmmo {
	if (self.spawnflags & ULTRA_ENF) {
		self.ammo_cells = 5;
		self.ammo_rockets = 2;
	} else if (self.spawnflags & MEGA_ENF) {
		self.ammo_cells = 2;
		self.ammo_rockets = 1;
	} else {
		self.ammo_cells = 2;
	}
	DropBackpack();
}


void()	enf_die1	=[	$death1,	enf_die2	] {};
void()	enf_die2	=[	$death2,	enf_die3	] {};
void()	enf_die3	=[	$death3,	enf_die4	] {self.solid = SOLID_NOT; DropAmmo();};
void()	enf_die4	=[	$death4,	enf_die5	] {ai_forward(14);};
void()	enf_die5	=[	$death5,	enf_die6	] {ai_forward(2);};
void()	enf_die6	=[	$death6,	enf_die7	] {};
void()	enf_die7	=[	$death7,	enf_die8	] {};
void()	enf_die8	=[	$death8,	enf_die9	] {};
void()	enf_die9	=[	$death9,	enf_die10	] {ai_forward(3);};
void()	enf_die10	=[	$death10,	enf_die11	] {ai_forward(5);};
void()	enf_die11	=[	$death11,	enf_die12	] {ai_forward(5);};
void()	enf_die12	=[	$death12,	enf_die13	] {ai_forward(5);};
void()	enf_die13	=[	$death13,	enf_die14	] {Become_Corpse();};
void()	enf_die14	=[	$death14,	enf_die14	] {if (!checkclient()) remove(self);};	//Asaki

void()	enf_fdie1	=[	$fdeath1,	enf_fdie2	] {};
void()	enf_fdie2	=[	$fdeath2,	enf_fdie3	] {};
void()	enf_fdie3	=[	$fdeath3,	enf_fdie4	] {self.solid = SOLID_NOT; DropAmmo();};
void()	enf_fdie4	=[	$fdeath4,	enf_fdie5	] {};
void()	enf_fdie5	=[	$fdeath5,	enf_fdie6	] {};
void()	enf_fdie6	=[	$fdeath6,	enf_fdie7	] {};
void()	enf_fdie7	=[	$fdeath7,	enf_fdie8	] {};
void()	enf_fdie8	=[	$fdeath8,	enf_fdie9	] {};
void()	enf_fdie9	=[	$fdeath9,	enf_fdie10	] {};
void()	enf_fdie10	=[	$fdeath10,	enf_fdie11	] {Become_Corpse();};
void()	enf_fdie11	=[	$fdeath11,	enf_fdie11	] {if (!checkclient()) remove(self);};	//Asaki


void() enf_die =
{
	local float r;
// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_mega.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	if (self.spawnflags & ULTRA_ENF) {
		r = random();
		if (r < 0.333)
			sound (self, CHAN_VOICE, "enforcer/ue_die1.wav", 1, ATTN_NORM);
		else if (r < 0.66)
			sound (self, CHAN_VOICE, "enforcer/ue_die2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/ue_die3.wav", 1, ATTN_NORM);
	}
	else
		sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
	if (random() > 0.5)
		enf_die1 ();
	else
		enf_fdie1 ();
};


/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/
void() monster_enforcer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

    	if (coop == 2 && orig_random() < 0.6)
    	{
    		if (orig_random() < 0.2)
			self.spawnflags = self.spawnflags | ULTRA_ENF;
    		else
			self.spawnflags = self.spawnflags | MEGA_ENF;
	}

	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");
	precache_model2 ("progs/k_spike.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound2 ("items/protect3.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/enforcer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (self.spawnflags & ULTRA_ENF) {
		self.health = 400;
		self.skin = 2;
		enforcer_spawnshieldfx();
		precache_sound2 ("enforcer/ue_fire1.wav");
		precache_sound2 ("enforcer/ue_die1.wav");
		precache_sound2 ("enforcer/ue_die2.wav");
		precache_sound2 ("enforcer/ue_die3.wav");
		precache_sound2 ("enforcer/ue_site1.wav");
		precache_sound2 ("enforcer/ue_site2.wav");
		precache_sound2 ("enforcer/ue_site3.wav");
		precache_sound2 ("enforcer/ue_site4.wav");
		precache_sound2 ("enforcer/ue_site5.wav");
		precache_sound2 ("enforcer/ue_pain1.wav");
		precache_sound2 ("enforcer/ue_pain2.wav");
		precache_sound2 ("enforcer/ue_pain3.wav");
	} else if (self.spawnflags & MEGA_ENF) {
		self.health = 200;
		self.skin = 1;
		precache_sound2 ("enforcer/me_fire1.wav");
		precache_model2 ("progs/laser2.mdl");
	} else {
		self.health = 80;
		self.skin = 0;
	}

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enforcer_attack;

	walkmonster_start();
};
