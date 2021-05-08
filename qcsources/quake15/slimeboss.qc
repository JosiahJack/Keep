/*
==============================================================================

slimeboss-ONE

==============================================================================
*/
$cd id1/models/slimeboss1
$origin 0 0 -15
$base base
$skin skin
$scale 5

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10


void(vector p) slimeboss_missile;

void() slimeboss_face =
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

void() slimeboss_rise1	=[	$rise1, slimeboss_rise2 ] {
sound (self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);
};
void() slimeboss_rise2	=[	$rise2, slimeboss_rise3 ] {
sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
};
void() slimeboss_rise3	=[	$rise3, slimeboss_rise4 ] {};
void() slimeboss_rise4	=[	$rise4, slimeboss_rise5 ] {self.weapontimer = 0;};
void() slimeboss_rise5	=[	$rise5, slimeboss_rise6 ] {};
void() slimeboss_rise6	=[	$rise6, slimeboss_rise7 ] {};
void() slimeboss_rise7	=[	$rise7, slimeboss_rise8 ] {};
void() slimeboss_rise8	=[	$rise8, slimeboss_rise9 ] {};
void() slimeboss_rise9	=[	$rise9, slimeboss_rise10 ] {};
void() slimeboss_rise10	=[	$rise10, slimeboss_rise11 ] {};
void() slimeboss_rise11	=[	$rise11, slimeboss_rise12 ] {};
void() slimeboss_rise12	=[	$rise12, slimeboss_rise13 ] {};
void() slimeboss_rise13	=[	$rise13, slimeboss_rise14 ] {};
void() slimeboss_rise14	=[	$rise14, slimeboss_rise15 ] {};
void() slimeboss_rise15	=[	$rise15, slimeboss_rise16 ] {};
void() slimeboss_rise16	=[	$rise16, slimeboss_rise17 ] {};
void() slimeboss_rise17	=[	$rise17, slimeboss_missile1 ] {};

void() slimeboss_idle1	=[	$walk1, slimeboss_idle2 ]
{
// look for other players
};
void() slimeboss_idle2	=[	$walk2, slimeboss_idle3 ] {slimeboss_face();};
void() slimeboss_idle3	=[	$walk3, slimeboss_idle4 ] {slimeboss_face();};
void() slimeboss_idle4	=[	$walk4, slimeboss_idle5 ] {slimeboss_face();};
void() slimeboss_idle5	=[	$walk5, slimeboss_idle6 ] {slimeboss_face();};
void() slimeboss_idle6	=[	$walk6, slimeboss_idle7 ] {slimeboss_face();};
void() slimeboss_idle7	=[	$walk7, slimeboss_idle8 ] {slimeboss_face();};
void() slimeboss_idle8	=[	$walk8, slimeboss_idle9 ] {slimeboss_face();};
void() slimeboss_idle9	=[	$walk9, slimeboss_idle10 ] {slimeboss_face();};
void() slimeboss_idle10	=[	$walk10, slimeboss_idle11 ] {slimeboss_face();};
void() slimeboss_idle11	=[	$walk11, slimeboss_idle12 ] {slimeboss_face();};
void() slimeboss_idle12	=[	$walk12, slimeboss_idle13 ] {slimeboss_face();};
void() slimeboss_idle13	=[	$walk13, slimeboss_idle14 ] {slimeboss_face();};
void() slimeboss_idle14	=[	$walk14, slimeboss_idle15 ] {slimeboss_face();};
void() slimeboss_idle15	=[	$walk15, slimeboss_idle16 ] {slimeboss_face();};
void() slimeboss_idle16	=[	$walk16, slimeboss_idle17 ] {slimeboss_face(); if (coop) slimeboss_missile1();}; //to prevent loss of target bug in coop
void() slimeboss_idle17	=[	$walk17, slimeboss_idle18 ] {slimeboss_face();};
void() slimeboss_idle18	=[	$walk18, slimeboss_idle19 ] {slimeboss_face();};
void() slimeboss_idle19	=[	$walk19, slimeboss_idle20 ] {slimeboss_face();};
void() slimeboss_idle20	=[	$walk20, slimeboss_idle21 ] {slimeboss_face();};
void() slimeboss_idle21	=[	$walk21, slimeboss_idle22 ] {slimeboss_face();};
void() slimeboss_idle22	=[	$walk22, slimeboss_idle23 ] {slimeboss_face();};
void() slimeboss_idle23	=[	$walk23, slimeboss_idle24 ] {slimeboss_face();};
void() slimeboss_idle24	=[	$walk24, slimeboss_idle25 ] {slimeboss_face();};
void() slimeboss_idle25	=[	$walk25, slimeboss_idle26 ] {slimeboss_face();};
void() slimeboss_idle26	=[	$walk26, slimeboss_idle27 ] {slimeboss_face();};
void() slimeboss_idle27	=[	$walk27, slimeboss_idle28 ] {slimeboss_face();};
void() slimeboss_idle28	=[	$walk28, slimeboss_idle29 ] {slimeboss_face();};
void() slimeboss_idle29	=[	$walk29, slimeboss_idle30 ] {slimeboss_face();};
void() slimeboss_idle30	=[	$walk30, slimeboss_idle31 ] {slimeboss_face();};
void() slimeboss_idle31	=[	$walk31, slimeboss_idle1 ] {slimeboss_face();};

//void() slimeboss_trap_fin;

void() slimeboss_shake =
{
	local entity plyr;
	plyr = findradius(self.origin, 150);
	while(plyr)
	{
		// Only shake players (clients)
		if (plyr.flags & FL_CLIENT) {plyr.punchangle_x = -1 * (random() + (0.025*self.dmg*3));}
	}
}

//void() slimeboss_magic1;
//void() slimeboss_trap1;

void() slimeboss_balls;

void() slimeboss_missile1	=[	$attack1, slimeboss_missile2 ] {slimeboss_face();};
void() slimeboss_missile2	=[	$attack2, slimeboss_missile3 ] {slimeboss_face();};
void() slimeboss_missile3	=[	$attack3, slimeboss_missile4 ] {slimeboss_face();};
void() slimeboss_missile4	=[	$attack4, slimeboss_missile5 ] {slimeboss_face();};
void() slimeboss_missile5	=[	$attack5, slimeboss_missile6 ] {slimeboss_face();};
void() slimeboss_missile6	=[	$attack6, slimeboss_missile7 ] {slimeboss_face();};
void() slimeboss_missile7	=[	$attack7, slimeboss_missile8 ] {slimeboss_face();};
void() slimeboss_missile8	=[	$attack8, slimeboss_missile9 ] {slimeboss_face();};
void() slimeboss_missile9	=[	$attack9, slimeboss_missile10 ] {slimeboss_balls();};//slimeboss_missile('100 100 200');};
void() slimeboss_missile10	=[	$attack10, slimeboss_missile11 ] {slimeboss_face();};
void() slimeboss_missile11	=[	$attack11, slimeboss_missile12 ] {slimeboss_face();};
void() slimeboss_missile12	=[	$attack12, slimeboss_missile13 ] {slimeboss_face();};
void() slimeboss_missile13	=[	$attack13, slimeboss_missile14 ] {slimeboss_face();};
void() slimeboss_missile14	=[	$attack14, slimeboss_missile15 ] {slimeboss_face();};
void() slimeboss_missile15	=[	$attack15, slimeboss_missile16 ] {slimeboss_face();};
void() slimeboss_missile16	=[	$attack16, slimeboss_missile17 ] {slimeboss_face();};
void() slimeboss_missile17	=[	$attack17, slimeboss_missile18 ] {slimeboss_face();};
void() slimeboss_missile18	=[	$attack18, slimeboss_missile19 ] {slimeboss_face();};
void() slimeboss_missile19	=[	$attack19, slimeboss_missile20 ] {slimeboss_face();};
void() slimeboss_missile20	=[	$attack20, slimeboss_missile21 ] {slimeboss_balls();};//slimeboss_missile('100 -100 200');};
void() slimeboss_missile21	=[	$attack21, slimeboss_missile22 ] {slimeboss_face();};
void() slimeboss_missile22	=[	$attack22, slimeboss_missile23 ] {slimeboss_face();};
void() slimeboss_missile23	=[	$attack23, slimeboss_missile1 ] {slimeboss_face();};


void() slimeboss_shocka1 =[	$shocka1, slimeboss_shocka2 ] {};
void() slimeboss_shocka2 =[	$shocka2, slimeboss_shocka3 ] {};
void() slimeboss_shocka3 =[	$shocka3, slimeboss_shocka4 ] {};
void() slimeboss_shocka4 =[	$shocka4, slimeboss_missile1 ] {};

void() slimeboss_pain =
{
	if (random() < 0.2)
	{
		slimeboss_shocka1();
		sound (self, CHAN_VOICE, "boss1/pain.wav", 1, ATTN_NORM);

	}
};

void() slimeboss_shockb1 =[	$shockb1, slimeboss_shockb2 ] {};
void() slimeboss_shockb2 =[	$shockb2, slimeboss_shockb3 ] {};
void() slimeboss_shockb3 =[	$shockb3, slimeboss_shockb4 ] {};
void() slimeboss_shockb4 =[	$shockb4, slimeboss_shockb5 ] {};
void() slimeboss_shockb5 =[	$shockb5, slimeboss_shockb6 ] {};
void() slimeboss_shockb6 =[	$shockb6, slimeboss_shockb7 ] {};
void() slimeboss_shockb7 =[	$shockb1, slimeboss_shockb8 ] {};
void() slimeboss_shockb8 =[	$shockb2, slimeboss_shockb9 ] {};
void() slimeboss_shockb9 =[	$shockb3, slimeboss_shockb10 ] {};
void() slimeboss_shockb10 =[	$shockb4, slimeboss_missile1 ] {};

void() slimeboss_shockc1 =[	$shockc1, slimeboss_shockc2 ] {};
void() slimeboss_shockc2 =[	$shockc2, slimeboss_shockc3 ] {};
void() slimeboss_shockc3 =[	$shockc3, slimeboss_shockc4 ] {};
void() slimeboss_shockc4 =[	$shockc4, slimeboss_shockc5 ] {};
void() slimeboss_shockc5 =[	$shockc5, slimeboss_shockc6 ] {};
void() slimeboss_shockc6 =[	$shockc6, slimeboss_shockc7 ] {};
void() slimeboss_shockc7 =[	$shockc7, slimeboss_shockc8 ] {};
void() slimeboss_shockc8 =[	$shockc8, slimeboss_shockc9 ] {};
void() slimeboss_shockc9 =[	$shockc9, slimeboss_shockc10 ] {};
void() slimeboss_shockc10 =[	$shockc10, slimeboss_death1 ] {};

//NEW slimeboss ABILITIES


/*
void() slimeboss_magic1 = [$death1, slimeboss_magic2] {
sound (self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
};
void() slimeboss_magic2 = [$death2, slimeboss_magic3] {};
void() slimeboss_magic3 = [$death3, slimeboss_magic4] {};
void() slimeboss_magic4 = [$death2, slimeboss_magic5] {if (self.health < 3) slimeboss_flamewave();};
void() slimeboss_magic5 = [$death3, slimeboss_magic6] {slimeboss_flamewave();};
void() slimeboss_magic6 = [$death2, slimeboss_magic7] {if (self.health < 3) slimeboss_flamewave();};
void() slimeboss_magic7 = [$death1, slimeboss_missile1] {slimeboss_flamewave();};


*/



void() slimeboss_death1 = [$death1, slimeboss_death2] {
sound (self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
};
void() slimeboss_death2 = [$death2, slimeboss_death3] {};
void() slimeboss_death3 = [$death3, slimeboss_death4] {};
void() slimeboss_death4 = [$death4, slimeboss_death5] {};
void() slimeboss_death5 = [$death5, slimeboss_death6] {};
void() slimeboss_death6 = [$death6, slimeboss_death7] {};
void() slimeboss_death7 = [$death7, slimeboss_death8] {};
void() slimeboss_death8 = [$death8, slimeboss_death9] {};
void() slimeboss_death9 = [$death9, slimeboss_death10]
{
	sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	pointparticles(particleeffectnum("slimesplash"), self.origin, '0 0 0', 1);
	/*WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);*/
};

void() slimeboss_death10 = [$death9, slimeboss_death10]
{
	killed_monsters = killed_monsters + 1;
	WriteByte (MSG_ALL, SVC_KILLEDMONSTER);	// FIXME: reliable broadcast
	//SUB_UseTargets ();
	remove (self);
};

void() T_slimebossTouch =
{
	local float	damg;
	local vector detonate;		// for seperation of explosion effect

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
		{
			remove(self);
			return;
		}
	}


	damg = 10;	// default 100

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		//pointparticles(particleeffectnum("cthon_fireball"), detonate, '0 0 0', 1);
	}
	else
	{
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		//pointparticles(particleeffectnum("cthon_fireball"), detonate, '0 0 0', 1);
	}
}
else
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}
	detonate = self.origin;
	detonate = detonate - 8*normalize(self.velocity);
	//pointparticles(particleeffectnum("cthon_fireball"), detonate, '0 0 0', 1);
}	
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 50, other);

	sound (self, CHAN_WEAPON, "boss1/expslime.wav", 1, ATTN_NORM);
/*	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	//pointparticles(particleeffectnum("slimesplash_small"), detonate, '0 0 0', 1);
	sendParticle("slimesplash_small", detonate, '0 0 0', 1);
	BecomeExplosion ();
};


void() slimeboss_balls =
{
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local	entity missile;
	

	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NONE);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	
	setorigin (missile, self.origin);
	missile.origin = self.origin + '0 0 30';
	
// set missile speed	
	
	makevectors (self.angles);

	distancedelta = self.enemy.origin - self.origin; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	
	nozdistancedelta_z = 0;  //remove height 
	
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = missile.velocity * 700;   //give it more power 
	
    //  missile.velocity_z = missile.velocity_z + vlen(nozdistancedelta)*0.7;  //add extra height for extra distance	
	
	missile.velocity_z = missile.velocity_z + 100 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 
	
	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_slimebossTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = T_slimebossTouch;

	setmodel (missile, "progs/slimeball.mdl");
	missile.classname = "slimeball";
	setsize (missile, '0 0 0', '0 0 0');		
};
/*
void() slimeboss_balls =
{
	local	entity 	missile;
	local	vector	dir, follow;
	local	float	dist, flytime;

	follow = self.enemy.velocity*1.3;		// "guess" players future position to make it harder to dodge
	follow_z = 0;
	
	if (skill >= 2)
		dir = normalize((self.enemy.origin + '0 0 -200' + follow/2.5) - self.origin);
	else
		dir = normalize((self.enemy.origin + '0 0 -200') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "boss1/launch.wav", 1, ATTN_NONE);

	missile = spawn ();
	missile.owner = self;

	missile.classname = "slimeball";
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_TOSS;
	setmodel (missile, "progs/slimeball.mdl");
	//missile.skin = 1;

	setsize (missile, '0 0 0', '0 0 0');

	missile.origin = self.origin + '0 0 100';
	missile.velocity = dir * 1200;
	missile.velocity_z+= 100;
	missile.avelocity = '0 0 300';
	missile.nextthink = time + 12;
	missile.angles = vectoangles(missile.velocity);
	missile.think = T_slimebossTouch;
	//missile.enemy = self.enemy;
	missile.touch = T_slimebossTouch;
};
*/


void(vector p) slimeboss_missile =
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

	//launch_spike (org, vec); //ooppee - yes even Chthon's lavaball sticks in walls. Let's make him use the launch_enemy_spike :)
	launch_enemy_spike (org, vec); //ooppee there we go :D
	setmodel (newmis, "progs/lavaball.mdl");
	newmis.avelocity = '200 100 300';
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
//	newmis.touch = T_MissileTouch; // rocket explosion
	newmis.touch = T_MissileTouch_chton; // rocket explosion
	sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);

// check for dead enemy
	if (self.enemy.health <= 0)
		slimeboss_idle1 ();
};


void() slimeboss_awake =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_YES;
	
	setmodel (self, "progs/slimeboss.mdl");
	//self.colormod = '.6 1 .3';
	//self.skin = 1;
	
	self.th_die = slimeboss_death1;
	self.th_pain = slimeboss_pain;
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX + '0 0 15');

	self.alpha = autocvar_monstertransparency * 0.01;

	if (skill == 0)
		self.health = 500;
	else
		self.health = 650;

	self.enemy = activator;

	/*WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);*/
	pointparticles(particleeffectnum("slimesplash"), self.origin, '0 0 0', 1);

	self.yaw_speed = 20;
	slimeboss_rise1 ();
};


/*QUAKED monster_slimeboss (1 0 0) (-128 -128 -24) (128 128 256)
*/
void() monster_slimeboss =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/slimeboss.mdl");
	precache_model ("progs/slimeball.mdl");

	precache_sound ("weapons/rocket1i.wav");
	precache_sound ("boss1/out1.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound ("misc/power.wav");
	precache_sound ("boss1/throw.wav");
	precache_sound ("boss1/pain.wav");
	precache_sound ("boss1/death.wav");
	precache_sound ("boss1/fireball.wav");
	precache_sound ("boss1/launch.wav");
	precache_sound ("boss1/expslime.wav");
	precache_sound ("boss1/quake.wav");
	precache_sound ("boss1/exp2.wav");
	precache_sound ("boss1/atk2.wav");

	total_monsters = total_monsters + 1;

	self.use = slimeboss_awake;
	
	
};

//===========================================================================

