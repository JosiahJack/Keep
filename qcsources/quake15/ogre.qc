/*
==============================================================================

OGRE

==============================================================================
*/

$cd id1/models/ogre_c
$origin 0 0 24
$base base		
$skin base

$frame	stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7
$frame swing8 swing9 swing10 swing11 swing12 swing13 swing14

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12 smash13 smash14

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6

$frame pain1 pain2 pain3 pain4 pain5

$frame painb1 painb2 painb3

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13 paind14 paind15 paind16

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11 death12
$frame death13 death14

$frame bdeath1 bdeath2 bdeath3 bdeath4 bdeath5 bdeath6
$frame bdeath7 bdeath8 bdeath9 bdeath10

$frame pull1 pull2 pull3 pull4 pull5 pull6 pull7 pull8 pull9 pull10 pull11

$frame shdeath1 shdeath2 shdeath3 shdeath4 shdeath5 shdeath6 shdeath7 shdeath8 shdeath9
$frame shdeath10 shdeath11 shdeath12 shdeath13 shdeath14 shdeath15 shdeath16
$frame shdeath17 shdeath18 shdeath19 shdeath20 shdeath21 shdeath22

$frame naildth1 naildth2 naildth3 naildth4 naildth5 naildth6 naildth7 naildth8 naildth9
$frame naildth10 naildth11 naildth12 naildth13 naildth14 naildth15 naildth16
$frame naildth17 naildth18 naildth19 naildth20 naildth21 naildth22 naildth23 naildth24
$frame naildth25 naildth26 naildth27 naildth28 naildth29 naildth30 naildth31


//=============================================================================


void() OgreGrenadeExplode =
{
    var float autocvar_ogre_size_influenced_attack = 0; 	  		// set cvar 'ogre_size_influenced_attack' default to 0
	if (autocvar_ogre_size_influenced_attack == 1)				// if 'ogre_size_influenced_attack' is set via autoexec.cfg to '1' raise monsterճ attack values according to its size 
		T_RadiusDamage (self, self.owner, autocvar_ogre_grenade * self.owner.scale, world);	// default 40
	else
		T_RadiusDamage (self, self.owner, autocvar_ogre_grenade, world);	// default 40
		
		
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		sound7(self, CHAN_WEAPON, "weapons/xpld_wat.wav", 1, ATTN_NORM, SNDSPD);
	else
		sound7(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	var float autocvar_explosiondebris = 0;
	if ( autocvar_explosiondebris == 0 )
	{
		if (autocvar_effects_classic_explosion == 1)
			pointparticles(particleeffectnum("rocket_explo_classic"), self.origin, '0 0 0', 1);
		else
		{
			if (other.health)
				pointparticles(particleeffectnum("multigrenade_explosion_nodebris"), self.origin, '0 0 0', 1);
			else
				pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
		}
	}
	else
	{
		if (autocvar_effects_classic_explosion == 1)
			pointparticles(particleeffectnum("rocket_explo_classic"), self.origin, '0 0 0', 1);
		else
			pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
	}

	sparklers(2);
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	BecomeExplosion();
	//s_explode1 ();
};

void() OgreGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		OgreGrenadeExplode();
		return;
	}
	sound7(self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM, SNDSPD);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
OgreFireGrenade
================
*/
void() OgreFireGrenade =
{
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local	entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	sound7(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM, SNDSPD);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
		
// set missile speed	

	makevectors (self.angles);

	var float autocvar_ogreaim = 0;
	if ( autocvar_ogreaim == 0  || skill < 2)
	{
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	}
	else
	{
	distancedelta = self.enemy.origin - self.origin; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	
	nozdistancedelta_z = 0;  //remove height 
	
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = missile.velocity * 600;   //give it more power 
	
    //  missile.velocity_z = missile.velocity_z + vlen(nozdistancedelta)*0.7;  //add extra height for extra distance	
	
	missile.velocity_z = missile.velocity_z + 150 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 
	}
	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = OgreGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = OgreGrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
};


//=============================================================================

/*
================
chainsaw

FIXME
================
*/
void(float side) chainsaw =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	if (!CanDamage (self.enemy, self))
		return;

	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;

    var float autocvar_ogre_size_influenced_attack = 0; 	  		// set cvar 'ogre_size_influenced_attack' default to 0
	if (autocvar_ogre_size_influenced_attack == 1)				// if 'ogre_size_influenced_attack' is set via autoexec.cfg to '1' raise monsterճ attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_ogre_chainsaw * self.scale;	// default 4
	else
		ldmg = (random() + random() + random()) * autocvar_ogre_chainsaw;		// default 4
	T_Damage (self.enemy, self, self, ldmg);
	
	if (side)
	{
		makevectors (self.angles);
		if (side == 1)
			SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		else
			SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};


void(float loudness) ogre_footsteps =
{
if (autocvar_monsterfootsteps == 1 && (self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl"))	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.25)
		sound7(self, CHAN_AUTO, "walk/ogre1.wav", loudness, ATTN_IDLE, SNDSPD);
	else if (select <= 0.5)
		sound7(self, CHAN_AUTO, "walk/ogre2.wav", loudness, ATTN_IDLE, SNDSPD);
	else if (select <= 0.75)
		sound7(self, CHAN_AUTO, "walk/ogre3.wav", loudness, ATTN_IDLE, SNDSPD);
	else 
		sound7(self, CHAN_AUTO, "walk/ogre4.wav", loudness, ATTN_IDLE, SNDSPD);
	}
};


var float autocvar_ogrecheckchainsaw = 1;	// set cvar 'ogrecheckchainsaw' default to 1.  0= disabled  1= enabled: Ogres have a certain chance to play the unused chainsaw-pull-animation to check/start their chainsaw. 
						// This has NO affect to the gameplay ! The ogre keeps on using ai_stand() or ai_walk() and keeps therefore scanning for player/enemies.
// new animation sequence (during standing) 
void() ogre_pull1a       =[      $pull1,         ogre_pull2a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -15 + v_forward * -19, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 19 + v_up * -5 + v_forward * -16, '0 0 0', 1); 
}
};
void() ogre_pull2a       =[      $pull2,         ogre_pull3a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * -5 + v_forward * -11, '0 0 0', 1); 
}
};
void() ogre_pull3a       =[      $pull3,         ogre_pull4a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * 17, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * -5 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_pull4a       =[      $pull4,         ogre_pull5a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 14 + v_up * -4 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_pull5a       =[      $pull5,         ogre_pull6a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -2 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull6a       =[      $pull6,         ogre_pull7a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 8 + v_up * -3 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull7a       =[      $pull7,         ogre_pull8a      ] {ai_stand(); sound7(self, CHAN_WEAPON, "ogre/ogdrag.wav", 1, ATTN_NORM, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 16 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -3 + v_forward * 11, '0 0 0', 1); 
}
};
void() ogre_pull8a       =[      $pull8,         ogre_pull9a      ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * 3 + v_forward * 15, '0 0 0', 1); 
}
};
void() ogre_pull9a       =[      $pull9,         ogre_pull10a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 23 + v_up * 9 + v_forward * 16, '0 0 0', 1); 
}
};
void() ogre_pull10a      =[      $pull4,         ogre_pull11a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 14 + v_up * -4 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_pull11a      =[      $pull5,         ogre_pull12a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -2 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull12a      =[      $pull6,         ogre_pull13a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 8 + v_up * -3 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull13a      =[      $pull7,         ogre_pull14a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 16 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -3 + v_forward * 11, '0 0 0', 1); 
}
};
void() ogre_pull14a      =[      $pull8,         ogre_pull15a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * 3 + v_forward * 15, '0 0 0', 1); 
}
};
void() ogre_pull15a      =[      $pull9,         ogre_pull16a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 23 + v_up * 9 + v_forward * 16, '0 0 0', 1); 
}
};
void() ogre_pull16a      =[      $pull3,         ogre_pull17a     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * 17, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * -5 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_pull17a      =[      $pull2,         ogre_stand1     ] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * 1, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 33 + v_up * -10 + v_forward * 1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * -5 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -5 + v_forward * -11, '0 0 0', 1); 
}
};


// new animation sequence (during walking) 
void() ogre_pull1       =[      $pull1,         ogre_pull2      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -15 + v_forward * -19, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 19 + v_up * -5 + v_forward * -16, '0 0 0', 1); 
}
};
void() ogre_pull2       =[      $pull2,         ogre_pull3      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * -5 + v_forward * -11, '0 0 0', 1); 
}
};
void() ogre_pull3       =[      $pull3,         ogre_pull4      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * 17, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * -5 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_pull4       =[      $pull4,         ogre_pull5      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 14 + v_up * -4 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_pull5       =[      $pull5,         ogre_pull6      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -2 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull6       =[      $pull6,         ogre_pull7      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 8 + v_up * -3 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull7       =[      $pull7,         ogre_pull8      ] {ai_walk(0); sound7(self, CHAN_WEAPON, "ogre/ogdrag.wav", 1, ATTN_NORM, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 16 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -3 + v_forward * 11, '0 0 0', 1); 
}
};
void() ogre_pull8       =[      $pull8,         ogre_pull9      ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * 3 + v_forward * 15, '0 0 0', 1); 
}
};
void() ogre_pull9       =[      $pull9,         ogre_pull10     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 23 + v_up * 9 + v_forward * 16, '0 0 0', 1); 
}
};
void() ogre_pull10      =[      $pull4,         ogre_pull11     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 14 + v_up * -4 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_pull11      =[      $pull5,         ogre_pull12     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -2 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull12      =[      $pull6,         ogre_pull13     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 8 + v_up * -3 + v_forward * 8, '0 0 0', 1); 
}
};
void() ogre_pull13      =[      $pull7,         ogre_pull14     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 16 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -3 + v_forward * 11, '0 0 0', 1); 
}
};
void() ogre_pull14      =[      $pull8,         ogre_pull15     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * -15 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * 3 + v_forward * 15, '0 0 0', 1); 
}
};
void() ogre_pull15      =[      $pull9,         ogre_pull16     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * -10 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 23 + v_up * 9 + v_forward * 16, '0 0 0', 1); 
}
};
void() ogre_pull16      =[      $pull3,         ogre_pull17     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * 17, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * -5 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_pull17      =[      $pull2,         ogre_walk15     ] {ai_walk(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 33 + v_up * -10 + v_forward * 1, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 33 + v_up * -10 + v_forward * 1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * -5 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -5 + v_forward * -11, '0 0 0', 1); 
}
};



///////  stand
void() ogre_stand1	=[	$stand1,	ogre_stand2	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
}
};
void() ogre_stand2	=[	$stand2,	ogre_stand3	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -14, '0 0 0', 1); 
}
};
void() ogre_stand3	=[	$stand3,	ogre_stand4	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -13, '0 0 0', 1); 
}
};
void() ogre_stand4	=[	$stand4,	ogre_stand5	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -12, '0 0 0', 1); 
}
};
void() ogre_stand5	=[	$stand5,	ogre_stand6	] {
if (random() < 0.2)
	sound7(self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE, SNDSPD);
ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -13, '0 0 0', 1); 
}
};
void() ogre_stand6	=[	$stand6,	ogre_stand7	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -14, '0 0 0', 1); 
}
};
void() ogre_stand7	=[	$stand7,	ogre_stand8	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
}
};
void() ogre_stand8	=[	$stand8,	ogre_stand9	] {ai_stand();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -16, '0 0 0', 1); 
}
};
void() ogre_stand9	=[	$stand9,	ogre_stand1	] {ai_stand();
if (autocvar_ogrecheckchainsaw == 1)	
{
	if (random() <= 0.06)		// 6% chance that ogre checks/starts his chainsaw 
		ogre_pull1a();
}
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 26 + v_up * -10 + v_forward * -10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 18 + v_up * -3 + v_forward * -16, '0 0 0', 1); 
}
};


///////  walk
void() ogre_walk1	=[	$walk1,		ogre_walk2	] {ai_walk(3); ogre_footsteps (0.95);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk2	=[	$walk2,		ogre_walk3	] {ai_walk(2);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk3	=[	$walk3,		ogre_walk4	] {
ai_walk(2);
if (random() < 0.2)
	sound7(self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk4	=[	$walk4,		ogre_walk5	] {ai_walk(2);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk5	=[	$walk5,		ogre_walk6	] {ai_walk(2);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk6	=[	$walk6,		ogre_walk7	] {
ai_walk(5);
if (random() < 0.1)
	sound7(self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk7	=[	$walk7,		ogre_walk8	] {ai_walk(3);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk8	=[	$walk8,		ogre_walk9	] {ai_walk(2);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk9	=[	$walk9,		ogre_walk10	] {ai_walk(3); ogre_footsteps (0.95);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk10	=[	$walk10,	ogre_walk11	] {ai_walk(1);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk11	=[	$walk11,	ogre_walk12	] {ai_walk(2);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk12	=[	$walk12,	ogre_walk13	] {ai_walk(3);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk13	=[	$walk13,	ogre_walk14	] {ai_walk(3);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk14	=[	$walk14,	ogre_walk15	] {ai_walk(3);
if (autocvar_ogrecheckchainsaw == 1)	
	{
	if (random() <= 0.07)		// 7% chance that ogre checks his chainsaw during patrol
		ogre_pull1();
	}
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk15	=[	$walk15,	ogre_walk16	] {ai_walk(3);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_walk16	=[	$walk16,	ogre_walk1	] {ai_walk(4);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 22 + v_up * -10 + v_forward * -11, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 20 + v_up * -21 + v_forward * -40, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_walk"), self.origin + v_right * 15 + v_up * -3 + v_forward * -15, '0 0 0', 1); 
	pointparticles(particleeffectnum("ogre_chainsaw_walk_scratching"), self.origin + v_right * 13 + v_up * -21 + v_forward * -33, '0 0 0', 1); 
}
};



///////  run
void() ogre_run1	=[	$run1,		ogre_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(9);
if (random() < 0.2)
	sound7(self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * 38 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_run2	=[	$run2,		ogre_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12); ogre_footsteps (1);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * 38 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_run3	=[	$run3,		ogre_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 19 + v_up * 38 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_run4	=[	$run4,		ogre_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(22);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 36 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_run5	=[	$run5,		ogre_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
};
void() ogre_run6	=[	$run6,		ogre_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(4); ogre_footsteps (1);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 34 + v_forward * -4, '0 0 0', 1); 
}
};
void() ogre_run7	=[	$run7,		ogre_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(13);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 35 + v_forward * -8, '0 0 0', 1); 
}
};
void() ogre_run8	=[	$run8,		ogre_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(24);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 35 + v_forward * -12, '0 0 0', 1); 
}
};



///////  swing
void() ogre_swing1	=[	$swing1,		ogre_swing2	] {ai_charge(11);
sound7(self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -9 + v_forward * -19, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -7 + v_forward * -17, '0 0 0', 1); 
}
};
void() ogre_swing2	=[	$swing2,		ogre_swing3	] {ai_charge(1);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 15 + v_up * -9 + v_forward * -17, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 15 + v_up * -6 + v_forward * -16, '0 0 0', 1); 
}
};
void() ogre_swing3	=[	$swing3,		ogre_swing4	] {ai_charge(4);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * -8 + v_forward * -17, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * -7 + v_forward * -14, '0 0 0', 1); 
}
};
void() ogre_swing4	=[	$swing4,		ogre_swing5	] {ai_charge(13);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 30 + v_up * 1 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -1 + v_forward * 10, '0 0 0', 1); 
}
};
void() ogre_swing5	=[	$swing5,		ogre_swing6	] {ai_charge(9); chainsaw(0);self.angles_y = self.angles_y + random()*25; ogre_footsteps (0.75);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * 10 + v_forward * 27, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -1 + v_up * 9 + v_forward * 25, '0 0 0', 1); 
}
};
void() ogre_swing6	=[	$swing6,		ogre_swing7	] {chainsaw(200);self.angles_y = self.angles_y + random()* 25;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -33 + v_up * 12 + v_forward * 33, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -25 + v_up * 12 + v_forward * 27, '0 0 0', 1); 
}
};
void() ogre_swing7	=[	$swing7,		ogre_swing8	] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -37 + v_up * 12 + v_forward * 15, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -27 + v_up * 14 + v_forward * 10, '0 0 0', 1); 
}
};
void() ogre_swing8	=[	$swing8,		ogre_swing9	] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -30 + v_up * 12 + v_forward * 7, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -19 + v_up * 15 + v_forward * -7, '0 0 0', 1); 
}
};
void() ogre_swing9	=[	$swing9,		ogre_swing10 ] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -24 + v_up * 12 + v_forward * -7, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -14 + v_up * 15 + v_forward * -7, '0 0 0', 1); 
}
};
void() ogre_swing10	=[	$swing10,		ogre_swing11 ] {chainsaw(-200);self.angles_y = self.angles_y + random()* 25;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -17 + v_up * 12 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -18 + v_up * 15 + v_forward * -7, '0 0 0', 1); 
}
};
void() ogre_swing11	=[	$swing11,		ogre_swing12 ] {chainsaw(0);self.angles_y = self.angles_y + random()* 25;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -27 + v_up * 10 + v_forward * 7, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -20 + v_up * 14 + v_forward * 10, '0 0 0', 1); 
}
};
void() ogre_swing12	=[	$swing12,		ogre_swing13 ] {ai_charge(3);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -25 + v_up * 12 + v_forward * 30, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 2 + v_up * 15 + v_forward * 23, '0 0 0', 1); 
}
};
void() ogre_swing13	=[	$swing13,		ogre_swing14 ] {ai_charge(8);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -5 + v_up * 10 + v_forward * 22, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * -5 + v_up * 7 + v_forward * 15, '0 0 0', 1); 
}
};
void() ogre_swing14	=[	$swing14,		ogre_run1	] {ai_charge(9);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 37 + v_up * 4 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * 1 + v_forward * -5, '0 0 0', 1); 
}
};



////// smash
void() ogre_smash1	=[	$smash1,		ogre_smash2	] {ai_charge(6);
sound7(self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -9 + v_forward * -22, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -3 + v_forward * -22, '0 0 0', 1); 
}
};
void() ogre_smash2	=[	$smash2,		ogre_smash3	] {ai_charge(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 7 + v_up * -9 + v_forward * -27, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 7 + v_up * -3 + v_forward * -27, '0 0 0', 1); 
}
};
void() ogre_smash3	=[	$smash3,		ogre_smash4	] {ai_charge(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 7 + v_up * -4 + v_forward * -33, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * 1 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_smash4	=[	$smash4,		ogre_smash5	] {ai_charge(1);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 7 + v_up * 10 + v_forward * -33, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 12 + v_up * 12 + v_forward * -33, '0 0 0', 1); 
}
};
void() ogre_smash5	=[	$smash5,		ogre_smash6	] {ai_charge(4);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * 22 + v_forward * -30, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 15 + v_up * 24 + v_forward * -30, '0 0 0', 1); 
}
};
void() ogre_smash6	=[	$smash6,		ogre_smash7	] {ai_charge(4); chainsaw(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * 37 + v_forward * -22, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * 35 + v_forward * -22, '0 0 0', 1); 
}
};
void() ogre_smash7	=[	$smash7,		ogre_smash8	] {ai_charge(4); chainsaw(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * 53 + v_forward * -12, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 15 + v_up * 47 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_smash8	=[	$smash8,		ogre_smash9	] {ai_charge(10); chainsaw(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * 35 + v_forward * 12, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * 35 + v_forward * 7, '0 0 0', 1); 
}
};
void() ogre_smash9	=[	$smash9,		ogre_smash10 ] {ai_charge(13); chainsaw(0); ogre_footsteps (0.85);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * 10 + v_forward * 33, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 13 + v_up * 15 + v_forward * 30, '0 0 0', 1); 
}
};
void() ogre_smash10	=[	$smash10,		ogre_smash11 ] {chainsaw(1);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 10 + v_up * -5 + v_forward * 45, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 13 + v_up * -1 + v_forward * 38, '0 0 0', 1); 
}
};
void() ogre_smash11	=[	$smash11,		ogre_smash12 ] {ai_charge(2); chainsaw(0);
self.nextthink = self.nextthink + random()*0.2;	// slight variation
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 11 + v_up * -7 + v_forward * 45, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 17 + v_up * 4 + v_forward * 38, '0 0 0', 1); 
}
};
void() ogre_smash12	=[	$smash12,		ogre_smash13 ] {ai_charge(0);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * -5 + v_forward * 45, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * 10 + v_forward * 30, '0 0 0', 1); 
}
};
void() ogre_smash13	=[	$smash13,		ogre_smash14 ] {ai_charge(4);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 30 + v_up * 5 + v_forward * 25, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 30 + v_up * 20 + v_forward * 10, '0 0 0', 1); 
}
};
void() ogre_smash14	=[	$smash14,		ogre_run1	] {ai_charge(12);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 37 + v_up * 5 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * 33 + v_forward * 2, '0 0 0', 1); 
}
};



//////   shoot
void() ogre_nail1	=[	$shoot1,	ogre_nail2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 37 + v_forward * -4, '0 0 0', 1); 
}
};
void() ogre_nail2	=[	$shoot2,	ogre_nail3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * 37 + v_forward * -6, '0 0 0', 1); 
}
};
void() ogre_nail3	=[	$shoot2,	ogre_nail4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * 37 + v_forward * -6, '0 0 0', 1); 
}
};
void() ogre_nail4	=[	$shoot3,	ogre_nail5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();OgreFireGrenade();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * 37 + v_forward * -6, '0 0 0', 1); 
}
};
void() ogre_nail5	=[	$shoot4,	ogre_nail6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 25 + v_up * 37 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_nail6	=[	$shoot5,	ogre_nail7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 33 + v_forward * -5, '0 0 0', 1); 
}
};
void() ogre_nail7	=[	$shoot6,	ogre_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 27 + v_up * 20 + v_forward * -2, '0 0 0', 1); 
}
};

void() ogre_die;

void()	ogre_crawl1	=[	$run1,	ogre_crawl2	] {ai_walk(1);self.health = self.health - 0.5; if (self.health <= 0) ogre_die();
};
void()	ogre_crawl2	=[	$run2,	ogre_crawl3	] {ai_walk(1);};
void()	ogre_crawl3	=[	$run3,	ogre_crawl4	] {ai_walk(2);if (random() < 0.3) sound7(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM, SNDSPD);};
void()	ogre_crawl4	=[	$run4,	ogre_crawl5	] {ai_walk(2);};
void()	ogre_crawl5	=[	$run5,	ogre_crawl6	] {ai_walk(2);};
void()	ogre_crawl6	=[	$run6,	ogre_crawl7	] {ai_walk(1);};
void()	ogre_crawl7	=[	$run7,	ogre_crawl8	] {ai_walk(1);};
void()	ogre_crawl8	=[	$run8,	ogre_crawl1	] {ai_walk(1);};

/*void() ogre_crdie =
{
	if (self.enemy.weapon != IT_ROCKET_LAUNCHER && self.enemy.weapon != IT_GRENADE_LAUNCHER)
		setmodel(self, "progs/h_ogre.mdl");
	else
	{
		sound7(self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);
		ThrowHead("progs/gib_ogre_h.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowWeapon("progs/w_ogregl.mdl", self.health);
	}
}
*/

void()	ogre_pain1	=[	$pain1,		ogre_pain2	] {};
void()	ogre_pain2	=[	$pain2,		ogre_pain3	] {};
void()	ogre_pain3	=[	$pain3,		ogre_pain4	] {};
void()	ogre_pain4	=[	$pain4,		ogre_pain5	] {};
void()	ogre_pain5	=[	$pain5,		ogre_run1	] {};

void()	ogre_painb1	=[	$painb1,	ogre_painb2	] {};
void()	ogre_painb2	=[	$painb2,	ogre_painb3	] {};
void()	ogre_painb3	=[	$painb3,	ogre_run1	] {};

void()	ogre_painc1	=[	$painc1,	ogre_painc2	] {};
void()	ogre_painc2	=[	$painc2,	ogre_painc3	] {};
void()	ogre_painc3	=[	$painc3,	ogre_painc4	] { ogre_footsteps (0.7);};
void()	ogre_painc4	=[	$painc4,	ogre_painc5	] {};
void()	ogre_painc5	=[	$painc5,	ogre_painc6	] {};
void()	ogre_painc6	=[	$painc6,	ogre_run1	] {};

void()	ogre_paind1	=[	$paind1,	ogre_paind2	] {};
void()	ogre_paind2	=[	$paind2,	ogre_paind3	] {ai_pain(10);};
void()	ogre_paind3	=[	$paind3,	ogre_paind4	] {ai_pain(9);};
void()	ogre_paind4	=[	$paind4,	ogre_paind5	] {ai_pain(4);};
void()	ogre_paind5	=[	$paind5,	ogre_paind6	] {};
void()	ogre_paind6	=[	$paind6,	ogre_paind7	] {};
void()	ogre_paind7	=[	$paind7,	ogre_paind8	] {};
void()	ogre_paind8	=[	$paind8,	ogre_paind9	] {};
void()	ogre_paind9	=[	$paind9,	ogre_paind10	] {};
void()	ogre_paind10=[	$paind10,	ogre_paind11	] {};
void()	ogre_paind11=[	$paind11,	ogre_paind12	] {};
void()	ogre_paind12=[	$paind12,	ogre_paind13	] {};
void()	ogre_paind13=[	$paind13,	ogre_paind14	] {};
void()	ogre_paind14=[	$paind14,	ogre_paind15	] {};
void()	ogre_paind15=[	$paind15,	ogre_paind16	] {};
void()	ogre_paind16=[	$paind16,	ogre_run1	] {};

void()	ogre_paine1	=[	$paine1,	ogre_paine2	] {};
void()	ogre_paine2	=[	$paine2,	ogre_paine3	] {ai_pain(10);};
void()	ogre_paine3	=[	$paine3,	ogre_paine4	] {ai_pain(9);};
void()	ogre_paine4	=[	$paine4,	ogre_paine5	] {ai_pain(4);};
void()	ogre_paine5	=[	$paine5,	ogre_paine6	] {};
void()	ogre_paine6	=[	$paine6,	ogre_paine7	] {};
void()	ogre_paine7	=[	$paine7,	ogre_paine8	] {};
void()	ogre_paine8	=[	$paine8,	ogre_paine9	] {};
void()	ogre_paine9	=[	$paine9,	ogre_paine10	] {};
void()	ogre_paine10=[	$paine10,	ogre_paine11	] {};
void()	ogre_paine11=[	$paine11,	ogre_paine12	] {};
void()	ogre_paine12=[	$paine12,	ogre_paine13	] {};
void()	ogre_paine13=[	$paine13,	ogre_paine14	] {};
void()	ogre_paine14=[	$paine14,	ogre_paine15	] {};
void()	ogre_paine15=[	$paine15,	ogre_run1	] {};


void(entity attacker, float damage)	ogre_pain =
{
	local float	r;

// don't make multiple pain sounds right after each other
	if (attacker.meleeing == 0 && (attacker.weapon == IT_ROCKET_LAUNCHER || attacker.weapon == IT_GRENADE_LAUNCHER) && random(100) < 30)
	{
		setmodel (self, "progs/ogre_half.mdl");
		setsize (self, '-12 -12 -24', '12 12 -7');
		pointparticles(particleeffectnum("blood_saw"), self.origin, '0 0 0', 1); 
		//self.think = ogre_crawl1;
		//self.nextthink = time + 0.1;
		self.velocity = '0 0 15' + v_forward * 25;
		ThrowGib ("progs/gib_ogfoot1.mdl", self.health);
		ThrowGib ("progs/gib_ogfoot2.mdl", self.health);
		sound7(self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);
		if (random() < 0.3)
			saw_spawn();
		else
			ThrowWeapon ("progs/w_chainsaw.mdl", self.health);
			
		//blood trail by torso
		self.traileffectnum = particleeffectnum("med_bloodtrail_TR");
		
		self.th_stand = ogre_crawl1;
		self.th_run = SUB_Null;
		self.th_melee = SUB_Null;
		self.th_pain = SUB_Null;
		self.th_missile = SUB_Null;
		self.goalentity = world;
		self.health = 15;
		//self.th_die = ogre_crdie;
		self.th_stand();
		return;
	}
	if (self.pain_finished > time)
		return;

	if (self.health <= 120 && (self.enemy.weapon != IT_AXE || self.enemy.weapon != IT_ROCKET_LAUNCHER || self.enemy.weapon != IT_GRENADE_LAUNCHER) && (self.enemy.meleeing == 0))
	{
		if (self.skin == 1)
		{
			setmodel(self, "progs/ogre_pain.mdl");
			self.skin = 1;
		}
		else
			setmodel(self, "progs/ogre_pain.mdl");
		setsize (self, VEC_HULL2_MIN + '10 10 0', VEC_HULL2_MAX - '10 10 23');
	}

		
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_ogre * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	sound7(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM, SNDSPD);		

	r = random();
	
	if (r < 0.25)
	{
		ogre_pain1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.5)
	{
		ogre_painb1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.75)
	{
		ogre_painc1 ();
		self.pain_finished = time + 1;
	}
	else if (r < 0.88)
	{
		ogre_paind1 ();
		self.pain_finished = time + 2;
	}
	else
	{
		ogre_paine1 ();
		self.pain_finished = time + 2;
	}
};


void() ogre_dieburn1	=[	$death1,	ogre_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() ogre_dieburn2	=[	$death2,	ogre_dieburn3	] {self.burnz_origin = 11;
};
void() ogre_dieburn3	=[	$death3,	ogre_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2	
self.backpack_thrower = 3; DropBackpack();
};
void() ogre_dieburn4	=[	$death4,	ogre_dieburn5	] {self.burnz_origin = 3;
};
void() ogre_dieburn5	=[	$death5,	ogre_dieburn6	] {self.burnz_origin = 0;
};
void() ogre_dieburn6	=[	$death6,	ogre_dieburn7	] {self.burnz_origin = -2;
};
void() ogre_dieburn7	=[	$death7,	ogre_dieburn8	] {self.burnz_origin = -4;
};
void() ogre_dieburn8	=[	$death8,	ogre_dieburn9	] {self.burnz_origin = -6;
};
void() ogre_dieburn9	=[	$death9,	ogre_dieburn10	] {self.burnz_origin = -8;
};
void() ogre_dieburn10	=[	$death10,	ogre_dieburn10	] {self.burnz_origin = -10;
};


var float autocvar_ogre = 5;     		// set cvar 'ogre' default to 5
var float autocvar_ogrecorpsehealth = 60;	// set cvar 'ogrecorpsehealth' default to 60
var float autocvar_ogrecorpseburnable = 1;	// set cvar 'ogrecorpseburnable' default to 1

//NEW RL DEATH

void()	ogre_dierl1	=[	$stand1,	ogre_dierl2	] {sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_dierl2	=[	$stand2,	ogre_dierl3	] {self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
self.backpack_thrower = 3; DropBackpack();};
void()	ogre_dierl3	=[	$stand2,	ogre_dierl3	] {if (self.flags & FL_ONGROUND) self.movetype = MOVETYPE_NONE;};

//////NEW SSG DEATH

void()	ogre_diessg1	=[	$shdeath1,	ogre_diessg2	] {makevectors(self.angles); self.fangle = v_forward;ai_back(4);};
void()	ogre_diessg2	=[	$shdeath2,	ogre_diessg3	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_spurt_corpse", self.origin, '0 0 0', 1);};
void()	ogre_diessg3	=[	$shdeath3,	ogre_diessg4	]
{self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
self.backpack_thrower = 3; DropBackpack();};
void()	ogre_diessg4	=[	$shdeath4,	ogre_diessg5	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_spurt", self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "misc/megagib.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_diessg5	=[	$shdeath5,	ogre_diessg6	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_spurt", self.origin, '0 0 0', 1);};
void()	ogre_diessg6	=[	$shdeath6,	ogre_diessg7	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_spurt", self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_diessg7	=[	$shdeath7,	ogre_diessg8	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_spurt", self.origin, '0 0 0', 1);};
void()	ogre_diessg8	=[	$shdeath8,	ogre_diessg9	] {};
void()	ogre_diessg9	=[	$shdeath9,	ogre_diessg10	] {};
void()	ogre_diessg10	=[	$shdeath10,	ogre_diessg11	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_blast", self.origin, '0 0 0', 1);};
void()	ogre_diessg11	=[	$shdeath11,	ogre_diessg12	] {};
void()	ogre_diessg12	=[	$shdeath12,	ogre_diessg13	] {sound7(self, CHAN_AUTO, "ogre/fall_backwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_diessg13	=[	$shdeath13,	ogre_diessg14	] {};
void()	ogre_diessg14	=[	$shdeath14,	ogre_diessg15	] {};
void()	ogre_diessg15	=[	$shdeath15,	ogre_diessg16	] {};
void()	ogre_diessg16	=[	$shdeath16,	ogre_diessg17	] {};
void()	ogre_diessg17	=[	$shdeath17,	ogre_diessg18	] {};
void()	ogre_diessg18	=[	$shdeath18,	ogre_diessg19	] {};
void()	ogre_diessg19	=[	$shdeath19,	ogre_diessg20	] {sound7(self, CHAN_AUTO, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_diessg20	=[	$shdeath20,	ogre_diessg21	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		sendParticle("blood_spurt_ogre", self.origin+(self.fangle*-30)-'0 0 10', '0 0 0', 1);};
void()	ogre_diessg21	=[	$shdeath21,	ogre_diessg22	] {};
void()	ogre_diessg22	=[	$shdeath21,	ogre_diessg23	] {};
void()	ogre_diessg23	=[	$shdeath21,	ogre_diessg24	] {};
void()	ogre_diessg24	=[	$shdeath21,	ogre_diessg25	] {};
void()	ogre_diessg25	=[	$shdeath21,	ogre_diessg26	] {};
void()	ogre_diessg26	=[	$shdeath22,	ogre_diessg26	] { 
		if (autocvar_ogrecorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/gib_ogfoot1.mdl");sendParticle("blood_spurt_ogre", self.origin+(self.fangle*-30)-'0 0 10', '0 0 0', 1);};
//Above is corpse gibbing code - FIND CORPSE


/////END NEW SSG DEATH

//////NEW NG DEATH

void()	ogre_dieng1	=[	$naildth1,	ogre_dieng2	] {};
void()	ogre_dieng2	=[	$naildth2,	ogre_dieng3	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1); sound7(self, CHAN_VOICE, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_dieng3	=[	$naildth3,	ogre_dieng4	]
{self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
self.backpack_thrower = 3; DropBackpack();};
void()	ogre_dieng4	=[	$naildth4,	ogre_dieng5	] {};
void()	ogre_dieng5	=[	$naildth5,	ogre_dieng6	] {};
void()	ogre_dieng6	=[	$naildth6,	ogre_dieng7	] {};
void()	ogre_dieng7	=[	$naildth7,	ogre_dieng8	] {};
void()	ogre_dieng8	=[	$naildth8,	ogre_dieng9	] {};
void()	ogre_dieng9	=[	$naildth9,	ogre_dieng10	] {};
void()	ogre_dieng10	=[	$naildth10,	ogre_dieng11	] {};
void()	ogre_dieng11	=[	$naildth11,	ogre_dieng12	] {};
void()	ogre_dieng12	=[	$naildth12,	ogre_dieng13	] {};
void()	ogre_dieng13	=[	$naildth13,	ogre_dieng14	] {};
void()	ogre_dieng14	=[	$naildth14,	ogre_dieng15	] {};
void()	ogre_dieng15	=[	$naildth15,	ogre_dieng16	] {};
void()	ogre_dieng16	=[	$naildth16,	ogre_dieng17	] {};
void()	ogre_dieng17	=[	$naildth17,	ogre_dieng18	] {};
void()	ogre_dieng18	=[	$naildth18,	ogre_dieng19	] {};
void()	ogre_dieng19	=[	$naildth19,	ogre_dieng20	] {};
void()	ogre_dieng20	=[	$naildth20,	ogre_dieng21	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);};
void()	ogre_dieng21	=[	$naildth21,	ogre_dieng22	] {};
void()	ogre_dieng22	=[	$naildth22,	ogre_dieng23	] {sound7(self, CHAN_AUTO, "misc/fall_backwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_dieng23	=[	$naildth23,	ogre_dieng24	] {};
void()	ogre_dieng24	=[	$naildth24,	ogre_dieng25	] {};
void()	ogre_dieng25	=[	$naildth25,	ogre_dieng26	] {};
void()	ogre_dieng26	=[	$naildth26,	ogre_dieng27	] {};
void()	ogre_dieng27	=[	$naildth27,	ogre_dieng28	] {};
void()	ogre_dieng28	=[	$naildth28,	ogre_dieng29	] {};
void()	ogre_dieng29	=[	$naildth29,	ogre_dieng30	] {};
void()	ogre_dieng30	=[	$naildth30,	ogre_dieng31	] {sound7(self, CHAN_AUTO, "ogre/fall_backwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_dieng31	=[	$naildth31,	ogre_dieng31	] { 
		if (autocvar_ogrecorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/gib_ogfoot1.mdl");};
//Above is corpse gibbing code - FIND CORPSE

/////END NEW NG DEATH

//AXE/CHAINSAW Death

void()	ogre_dieaxe1	=[	0,	ogre_dieaxe2	] {};
void()	ogre_dieaxe2	=[	1,	ogre_dieaxe3	] {if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1); sound7(self, CHAN_VOICE, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_dieaxe3	=[	2,	ogre_dieaxe4	]
{self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
self.backpack_thrower = 3; DropBackpack();};
void()	ogre_dieaxe4	=[	3,	ogre_dieaxe5	] {sound7(self, CHAN_AUTO, "misc/megagib.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_dieaxe5	=[	4,	ogre_dieaxe6	] {ai_forward(10);};
void()	ogre_dieaxe6	=[	5,	ogre_dieaxe7	] {};
void()	ogre_dieaxe7	=[	6,	ogre_dieaxe8	] {};
void()	ogre_dieaxe8	=[	7,	ogre_dieaxe9	] {ai_forward(6);};
void()	ogre_dieaxe9	=[	8,	ogre_dieaxe10	] {ai_forward(6);};
void()	ogre_dieaxe10	=[	9,	ogre_dieaxe11	] {};
void()	ogre_dieaxe11	=[	10,	ogre_dieaxe12	] {};
void()	ogre_dieaxe12	=[	11,	ogre_dieaxe13	] {};
void()	ogre_dieaxe13	=[	12,	ogre_dieaxe14	] {};
void()	ogre_dieaxe14	=[	13,	ogre_dieaxe15	] {};
void()	ogre_dieaxe15	=[	14,	ogre_dieaxe16	] {};
void()	ogre_dieaxe16	=[	15,	ogre_dieaxe17	] {};
void()	ogre_dieaxe17	=[	16,	ogre_dieaxe18	] {};
void()	ogre_dieaxe18	=[	17,	ogre_dieaxe19	] {};
void()	ogre_dieaxe19	=[	18,	ogre_dieaxe20	] {};
void()	ogre_dieaxe20	=[	19,	ogre_dieaxe21	] {ai_forward(6);sound7(self, CHAN_AUTO, "misc/fall_backwards.wav", 1, ATTN_IDLE, SNDSPD);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
		pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);};
void()	ogre_dieaxe21	=[	20,	ogre_dieaxe22	] {ai_forward(7);};
void()	ogre_dieaxe22	=[	21,	ogre_dieaxe22	] {ai_forward(10);
		if (autocvar_ogrecorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin 
	CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/gib_ogfoot2.mdl");};


void()	ogre_die1	=[	$death1,	ogre_die2	] {};
void()	ogre_die2	=[	$death2,	ogre_die3	] {};
void()	ogre_die3	=[	$death3,	ogre_die4	]
{self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
self.backpack_thrower = 3; DropBackpack();};
void()	ogre_die4	=[	$death4,	ogre_die5	] {};
void()	ogre_die5	=[	$death5,	ogre_die6	] {};
void()	ogre_die6	=[	$death6,	ogre_die7	] {};
void()	ogre_die7	=[	$death7,	ogre_die8	] {};
void()	ogre_die8	=[	$death8,	ogre_die9	] {};
void()	ogre_die9	=[	$death9,	ogre_die10	] {};
void()	ogre_die10	=[	$death10,	ogre_die11	] {};
void()	ogre_die11	=[	$death11,	ogre_die12	] {};
void()	ogre_die12	=[	$death12,	ogre_die13	] {sound7(self, CHAN_AUTO, "ogre/fall_backwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_die13	=[	$death13,	ogre_die14	] {};
void()	ogre_die14	=[	$death14,	ogre_die14	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 22;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_ogrecorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'ogrecorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/h_ogre.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/h_ogre1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'ogre' has been declared in code above already
	var float autocvar_ogrerandomness = 22;     	// set cvar 'ogrerandomness' default to 22%
	autocvar_ogrerandomness = autocvar_ogrerandomness * 0.01;
	if (autocvar_ogre == 1)			// if 'ogre' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_ogre == 2)		// if 'ogre' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/ogre.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/ogre1.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_ogre == 3)		// if 'ogre' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
			vengeance_ogre ("progs/ogre.mdl", $death14); 
		}
	else if (autocvar_ogre == 5)		// if 'ogre' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/ogre.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/ogre1.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_ogre ("progs/ogre.mdl", $death14);
			}
		}
	else				// if 'ogre' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/ogre.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/ogre1.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_ogre ("progs/ogre.mdl", $death14);
	}
};


void()	ogre_bdie1	=[	$bdeath1,	ogre_bdie2	] {};
void()	ogre_bdie2	=[	$bdeath2,	ogre_bdie3	] {ai_forward(5);};
void()	ogre_bdie3	=[	$bdeath3,	ogre_bdie4	]
{self.solid = SOLID_NOT;
self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
self.backpack_thrower = 3; DropBackpack();};
void()	ogre_bdie4	=[	$bdeath4,	ogre_bdie5	] {ai_forward(1);};
void()	ogre_bdie5	=[	$bdeath5,	ogre_bdie6	] {ai_forward(3);};
void()	ogre_bdie6	=[	$bdeath6,	ogre_bdie7	] {ai_forward(7);};
void()	ogre_bdie7	=[	$bdeath7,	ogre_bdie8	] {ai_forward(25);sound7(self, CHAN_AUTO, "ogre/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	ogre_bdie8	=[	$bdeath8,	ogre_bdie9	] {};
void()	ogre_bdie9	=[	$bdeath9,	ogre_bdie10	] {};
void()	ogre_bdie10	=[	$bdeath10,	ogre_bdie10	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 22;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_ogrecorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'ogrecorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/h_ogre.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_ogrecorpsehealth, "progs/h_ogre1.mdl");
  if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'ogre' has been declared in code above already
	var float autocvar_ogrerandomness = 22;     	// set cvar 'ogrerandomness' default to 22%
	autocvar_ogrerandomness = autocvar_ogrerandomness * 0.01;
	if (autocvar_ogre == 1)			// if 'ogre' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_ogre == 2)		// if 'ogre' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/ogre.mdl", $bdeath10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/ogre1.mdl", $bdeath10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_ogre == 3)		// if 'ogre' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
			vengeance_ogre ("progs/ogre.mdl", $bdeath10); 
		}
	else if (autocvar_ogre == 5)		// if 'ogre' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/ogre.mdl", $bdeath10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/ogre1.mdl", $bdeath10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_ogre ("progs/ogre.mdl", $bdeath10);
			}
		}
	else				// if 'ogre' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/ogre.mdl", $bdeath10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/ogre1.mdl", $bdeath10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_ogre ("progs/ogre.mdl", $bdeath10);
	}
};


void(float maxgibs, float gibscounter) producegibs_ogre =	  // creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowWeapon ("progs/w_ogregl.mdl", self.health);
	ThrowGib ("progs/gib_ogfoot1.mdl", self.health); 
	ThrowGib ("progs/gib_ogfoot2.mdl", self.health);
	ThrowWeapon ("progs/w_chainsaw.mdl", self.health);   	
	}
gibscounter = gibscounter + 1;
producegibs_ogre (maxgibs, gibscounter);
};

void()	ogre_pack =
{
	self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
	self.backpack_thrower = 3;
	DropBackpack();
}

void()	ogre_lightning_death	=[	$pain3,	ogre_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	{
	/*self.ammo_rockets = autocvar_backpack_ogre_grenades;	// default 2
	self.backpack_thrower = 3; */
	lightninggun_death_fade();
	}
};

void()	ogre_lightning_death1	=[	$pain3,	ogre_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_ogre.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_ogre1.mdl");
};


void() ogre_die;
void() ogre_inflamed9;
void() ogre_inflamed15;

void() ogre_inflamed1	=[	$run1,		ogre_inflamed2	] {ai_run_inflamed(9);
if (random() < 0.8)
	sound7(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM, SNDSPD);
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 20 + v_up * 38 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_inflamed2	=[	$run2,		ogre_inflamed3	] {ai_run_inflamed(12); ogre_footsteps (1); self.nextthink = time + 0.07;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 18 + v_up * 38 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_inflamed3	=[	$run3,		ogre_inflamed4	] {ai_run_inflamed(8); self.nextthink = time + 0.07;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 19 + v_up * 38 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_inflamed4	=[	$run4,		ogre_inflamed5	] {ai_run_inflamed(22); self.nextthink = time + 0.07;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 36 + v_forward * 3, '0 0 0', 1); 
}
};
void() ogre_inflamed5	=[	$run5,		ogre_inflamed6	] {ai_run_inflamed(16); self.nextthink = time + 0.07;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 35 + v_forward * -1, '0 0 0', 1); 
}
};
void() ogre_inflamed6	=[	$run6,		ogre_inflamed7	] {ai_run_inflamed(4); ogre_footsteps (1); self.nextthink = time + 0.07;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 34 + v_forward * -4, '0 0 0', 1); 
}
};
void() ogre_inflamed7	=[	$run7,		ogre_inflamed8	] {ai_run_inflamed(13); self.nextthink = time + 0.07;
if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 1)	// Original ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 22 + v_up * 42 + v_forward * 10, '0 0 0', 1); 
}
else if ((self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  == 2)	// Tea Monsters Ogre model
{
	makevectors(self.angles);
	pointparticles(particleeffectnum("ogre_chainsaw_run"), self.origin + v_right * 21 + v_up * 35 + v_forward * -8, '0 0 0', 1); 
}
};
void() ogre_inflamed8	=[	$run8,		ogre_inflamed1	] {ai_run_inflamed(24); self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	ogre_die ();
	return;
}
local float r;
r = random();
if (r < 0.25)
	ogre_inflamed9 ();	// part of pain anim (short)
else if (r < 0.45)
	ogre_inflamed15 ();	// part of pain anim (chainsaw drops)
};

void()	ogre_inflamed9	=[	$painc1,	ogre_inflamed10	] {self.nextthink = time + 0.07;
if (random() < 0.8)
	sound7(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM, SNDSPD);		
};
void()	ogre_inflamed10	=[	$painc2,	ogre_inflamed11	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed11	=[	$painc3,	ogre_inflamed12	] { ogre_footsteps (0.7);self.nextthink = time + 0.07;};
void()	ogre_inflamed12	=[	$painc4,	ogre_inflamed13	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed13	=[	$painc5,	ogre_inflamed14	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed14	=[	$painc6,	ogre_inflamed2	] {self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	ogre_die ();
	return;
}
};

void()	ogre_inflamed15	=[	$painc2,	ogre_inflamed16	] {self.nextthink = time + 0.07;
if (random() < 0.8)
	sound7(self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM, SNDSPD);		
};
void()	ogre_inflamed16	=[	$paine1,	ogre_inflamed17	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed17	=[	$paine2,	ogre_inflamed18	] {ai_pain(10);self.nextthink = time + 0.07;};
void()	ogre_inflamed18	=[	$paine3,	ogre_inflamed19	] {ai_pain(9);self.nextthink = time + 0.07;};
void()	ogre_inflamed19	=[	$paine4,	ogre_inflamed20	] {ai_pain(4);self.nextthink = time + 0.07;};
void()	ogre_inflamed20	=[	$paine5,	ogre_inflamed21	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed21	=[	$paine6,	ogre_inflamed22	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed22	=[	$paine7,	ogre_inflamed23	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed23	=[	$paine8,	ogre_inflamed24	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed24	=[	$paine9,	ogre_inflamed25	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed25	=[	$paine10,	ogre_inflamed26	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed26	=[	$paine11,	ogre_inflamed27	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed27	=[	$paine12,	ogre_inflamed28	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed28	=[	$paine13,	ogre_inflamed29	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed29	=[	$paine14,	ogre_inflamed30	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed30	=[	$paine15,	ogre_inflamed31	] {self.nextthink = time + 0.07;};
void()	ogre_inflamed31	=[	$painb1,	ogre_inflamed1	] {self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	ogre_die ();
	return;
}
};



void() ogre_die =
{
bodyCheck(); //Hexen 2 code - detect slope and adjust body angle

if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
	if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))		// when enemy was killed with lightning gun, go into baked mode
		{
		ogre_pack();
		ogre_lightning_death();
		return;
		}
	}
	else if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
	{
		ogre_pack();
		lg_death1();
		return;
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.model == "progs/ogre_half.mdl" && (self.health < -40 || self.enemy.weapon == IT_CHAINSAW))
	{
		pointparticles(particleeffectnum("blood_saw"), self.origin, '0 0 0', 1); 
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM, SNDSPD);
		if (self.skin == 0)
			ThrowGib ("progs/gib_ogre_h.mdl", self.health/2);
		else
			ThrowGib ("progs/gib_ogre_h1.mdl", self.health/2);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowHeart ("progs/gibheart.mdl", self.health);
		ThrowWeapon("progs/w_ogregl.mdl", self.health);
		
		remove(self);
		return;
	}
	else if (self.model == "progs/ogre_half.mdl")
	{
		pointparticles(particleeffectnum("blood_saw"), self.origin, '0 0 0', 1); 
		sound7(self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM, SNDSPD);
		if (self.skin == 0)
			ThrowBody ("progs/gib_ogre_half.mdl", self.health);
			//setmodel(self, "progs/h_ogre.mdl");
		else
			//setmodel(self, "progs/h_ogregib1.mdl");
			ThrowBody ("progs/gib_ogre_half1.mdl", self.health);
		ThrowWeapon("progs/w_ogregl.mdl", self.health);
		remove(self);
		return;
	}
	if (self.health < -80 || (self.enemy.weapon == IT_CHAINSAW && random()<0.6))
	{
		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_ogre * 0.01))
				{
				the_matrix = 1;
				SNDSPD = 70;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		play_gibsound();
		
		if ((world.model != "maps/e1m2.bsp") && random() > 0.8 && autocvar_chainsaw_drops == 1)
			saw_spawn();
		
		//5 randomized blood droplets that drip if stuck to the ceiling
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		
		//Comment below section to stop gibsmultiplier from overriding unique gib models
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			/*if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_ogre.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_ogre1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}*/
		//	else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				//{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_ogre.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_ogre1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				gibdeath_effects();
				producegibs_ogre (maxgibs, gibscounter);
				return;
				//}
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0) // enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER) && (self.enemy.meleeing == 0))	// when enemy was killed with explosives, set it on fire
			{
				self.delete_painskin = 1;	// remove painskin
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				ogre_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound7(self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM, SNDSPD);
			if (random() < 0.5)
				ogre_die1 ();
			else
				ogre_bdie1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'ogre' has been declared in code above already
var float autocvar_ogrerandomness = 22;     	// set cvar 'ogrerandomness' default to 22%
autocvar_ogrerandomness = autocvar_ogrerandomness * 0.01;
if (autocvar_ogre == 4)		// if 'ogre' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		ogre_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_ogre == 6)		// if 'ogre' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{			// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_ogrerandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			ogre_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'ogre' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_ogre * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound7(self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM, SNDSPD);
	if (random() < 0.5)
		ogre_die1 ();
	else
		ogre_bdie1 ();
		
	//FATALITIES
	
	if (self.enemy.meleeing == 0) //check before all fatalities to make sure attack type is not a kick
	{	
	// SSG DEATH CODE
	
		if (self.enemy.weapon == IT_SUPER_SHOTGUN)
		{
				if (random() < 0.5  || self.hitbox_pos == HEAD_SHOT)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_blast"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						ThrowGib ("progs/gib_ogre_h.mdl", self.health);
						setmodel (self, self.model = "progs/ogreblast.mdl");
						self.skin = 0;
					}
					else
					{
						ThrowGib ("progs/gib_ogre_h1.mdl", self.health);
						setmodel (self, self.model = "progs/ogreblast.mdl");
						self.skin = 1;
					}

					ogre_diessg1();
					
					//5 randomized blood droplets that drip if stuck to the ceiling
					CeilSplat();
					CeilSplat();
					CeilSplat();
					CeilSplat();
					CeilSplat();
						
				}
		}
		if (self.enemy.weapon == IT_ROCKET_LAUNCHER)
		{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/gib3.mdl", self.health);
					ThrowGib ("progs/gib3.mdl", self.health);
					ThrowGib ("progs/gib3.mdl", self.health);
					ThrowWeapon ("progs/w_ogregl.mdl", self.health);
					ThrowWeapon ("progs/w_chainsaw.mdl", self.health);
					
					//5 randomized blood droplets that drip if stuck to the ceiling
					CeilSplat();
					CeilSplat();
					CeilSplat();
					CeilSplat();
					CeilSplat();
					
					if ((world.model != "maps/e1m2.bsp") && random() > 0.98 && autocvar_chainsaw_drops == 1)
						saw_spawn();
					
					
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						ThrowGib ("progs/h_ogregib.mdl", self.health);
					}
					else
					{
						ThrowGib ("progs/h_ogregib1.mdl", self.health);
					}
					setmodel (self, self.model = "progs/ogregib.mdl");

					ogre_dierl1();
					
			
		}
		
		//NG DEATH CODE
		
		if (self.enemy.weapon == IT_NAILGUN)
		{
			if (random() < 0.5)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/ogrenail.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/ogrenail.mdl");
						self.skin = 1;
					}

					ogre_dieng1();
						
				}
			else
			{
				sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);
				setmodel (self, self.model = "progs/ogre_dmg.mdl");
			}
		}
		if (self.enemy.weapon == IT_SUPER_NAILGUN)
		{
			if (random() < 0.5 || self.hitbox_pos != HEAD_SHOT)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/ogrenail.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/ogrenail.mdl");
						self.skin = 1;
					}

					ogre_dieng1();
						
				}
			else
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_facepl"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/ogre_sng.mdl");
						StickGib ("progs/gib_ogre_h.mdl", self.health);
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/ogre_sng.mdl");
						StickGib ("progs/gib_ogre_h1.mdl", self.health);
						self.skin = 1;
					}

					ogre_dieng1();
						
				}
		}
		if (self.enemy.weapon == IT_AXE || self.enemy.weapon == IT_CHAINSAW)
		{
				if (random() < 0.2 || self.hitbox_pos == HEAD_SHOT)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_blast"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/ogreblast.mdl");
						self.skin = 0;
						ThrowGib ("progs/gib_ogre_h.mdl", self.health);
					}
					else
					{
						setmodel (self, self.model = "progs/ogreblast.mdl");
						self.skin = 1;
						ThrowGib ("progs/gib_ogre_h1.mdl", self.health);
					}

					ogre_diessg1();
						
				}
				else
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_blast"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/ogre_axe.mdl");
						self.skin = 0;
						ThrowGib ("progs/gib_ogarm.mdl", self.health);
					}
					else
					{
						setmodel (self, self.model = "progs/ogre_axe.mdl");
						self.skin = 1;
						ThrowGib ("progs/gib_ogarm.mdl", self.health);
						//ThrowWeapon ("progs/w_chainsaw.mdl", self.health);
					}
					ogre_dieaxe1();
				}
		}		
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);	
	}
	
};


void() ogre_melee =
{
	if (random() > 0.5)
		ogre_smash1 ();
	else
		ogre_swing1 ();
};

/*QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_ogre =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/ogre.mdl");
	precache_model ("progs/ogre_half.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/gib_ogre_half.mdl");
	precache_model ("progs/gib_ogre_half1.mdl");
	
	precachegibs_ogre();
	
	precache_sound("zombie/z_gib.wav");
	precache_sound("ogre/ogdrag.wav");
	precache_sound("ogre/ogdth.wav");
	precache_sound("ogre/ogidle.wav");
	precache_sound("ogre/ogidle2.wav");
	precache_sound("ogre/ogpain1.wav");
	precache_sound("ogre/ogsawatk.wav");
	precache_sound("ogre/ogwake.wav");
	precache_sound("ogre/fall_backwards.wav");
	precache_sound("ogre/fall_forwards.wav");
	precache_sound("walk/ogre1.wav");
	precache_sound("walk/ogre2.wav");
	precache_sound("walk/ogre3.wav");
	precache_sound("walk/ogre4.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

var float autocvar_ogremultiskin = 0;     	// set cvar 'ogremultiskin' default to 0
	local float zufall;
	if (autocvar_ogremultiskin == 1)	// if 'ogremultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/ogre.mdl");
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
	else if (autocvar_ogremultiskin == 2)	// if 'ogremultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/ogre1.mdl");
		precache_model ("progs/h_ogre1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/ogre.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/ogre1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_ogremultiskin == 3)	// if 'ogremultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/ogre1.mdl");
		precache_model ("progs/h_ogre1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/ogre.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/ogre.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/ogre1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_ogremultiskin == 4)	// if 'ogremultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/ogre1.mdl");
		precache_model ("progs/h_ogre1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/ogre.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/ogre.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/ogre1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/ogre1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/ogre.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

	if (autocvar_ogre_additional_particle_effects == 1)		// original ogre model only
		(self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  = 1;
	else if (autocvar_ogre_additional_particle_effects == 2)	// Tea Monsters Ogre model only
		(self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  = 2;
	else if (autocvar_ogre_additional_particle_effects == 3) 	// original model is 1st model, Tea Monsters model is 2nd model
	{
		if (self.monstermodel == 0)			 	// original ogre model
			(self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  = 1;
		else						 	// Tea Monsters ogre model
			(self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  = 2;
	}
	else if (autocvar_ogre_additional_particle_effects == 4) 	// Tea Monsters model is 1st model, original model is 2nd model
	{
		if (self.monstermodel == 0)				// Tea Monsters ogre model
			(self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  = 2;
		else							// original ogre model
			(self.model == "progs/ogre.mdl" || self.model == "progs/ogre1.mdl") && self.chainsaw_particles_original_model  = 1;
	}

var float autocvar_ogre_size = 2;     		// set cvar 'ogre_size' default to 2
	local float zuffa;
	if (autocvar_ogre_size == 1)		// if 'ogre_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DPճ .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 gr򟥲  (bei 24er Ausgangs bbox Mitte)
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
			setsize (self, VEC_HULL2_MIN + '10 10 0', VEC_HULL2_MAX - '10 10 23');
		}
	}
	else if (autocvar_ogre_size == 2)		// if 'ogre_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DPճ .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 gr򟥲  (bei 24er Ausgangs bbox Mitte)
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
			setsize (self, VEC_HULL2_MIN + '10 10 0', VEC_HULL2_MAX - '10 10 23');
		}
	}
	else if (autocvar_ogre_size == 3)		// if 'ogre_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DPճ .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 gr򟥲  (bei 24er Ausgangs bbox Mitte)
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
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
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
			setsize (self, VEC_HULL2_MIN + '10 10 0', VEC_HULL2_MAX - '10 10 23');
		}
	}
	else if (autocvar_ogre_size == 4)		// if 'ogre_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DPճ .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 gr򟥲  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			self.sizediff = '0 0 9';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			self.sizediff = '0 0 7';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN + '10 10 0', VEC_HULL2_MAX - '10 10 23');
		}
	}
	else if (autocvar_ogre_size > 4)		// if 'ogre_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DPճ .scale restrictions)
	{
		if (autocvar_ogre_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_ogre_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_ogre_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, VEC_HULL2_MIN + '10 10 0', VEC_HULL2_MAX - '10 10 23');
	}

var float autocvar_ogre_size_influenced_health = 0; 			// set cvar 'ogre_size_influenced_health' default to 0
	if (autocvar_ogre_size_influenced_health == 1)			// if 'ogre_size_influenced_health' is set via autoexec.cfg to '1' raise monsterճ health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_ogre_health * self.scale;	// default: 200
	else
		self.health = autocvar_ogre_health;			// default 200
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_ogre_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;

	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_torment_replace_ogre)	// if ogre shall be replaced by Torment. Check the chance and do it !!)
		{	
		local float replacerrr;		
		replacerrr = autocvar_torment_replace_ogre * 0.01;
		if (random () <= replacerrr)
			{
			self.health = autocvar_ogre_health;		// default 200
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_torment_start();
			return;
			}
		}

	if (autocvar_carnivean_replace_ogre)	// if ogre shall be replaced by Carnivean. Check the chance and do it !!)
		{	
		local float replacerrrrr;		
		replacerrrrr = autocvar_carnivean_replace_ogre * 0.01;
		if (random () <= replacerrrrr)
			{
			self.health = autocvar_ogre_health;		// default 200
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_carnivean_start();
			return;
			}
		}

	if (autocvar_warlord_replace_ogre)	// if ogre shall be replaced by Warlord. Check the chance and do it !!)
		{	
		local float replacerr;		
		replacerr = autocvar_warlord_replace_ogre * 0.01;
		if (random () <= replacerr)
			{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_hell_knight2_start();
			return;
			}
		}

	if (autocvar_yakman_replace_ogre)		// if ogre shall be replaced by Yakman. Check the chance and do it !!)
		{	
		local float replacerrrr;		
		replacerrrr = autocvar_yakman_replace_ogre * 0.01;
		if (random () <= replacerrrr)
			{
			self.health = autocvar_ogre_health + 50;	// default 200 + 50
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_yakman_start();
			return;
			}
		}

	if (autocvar_spider_replace_ogre)		// if ogre shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_ogre * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 7;
				self.health = autocvar_ogre_health;		// default 200
				self.scale = 1;
				setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_ogre)		// if ogre shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_ogre * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_ogre_health;		// default 200
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_ogre)		// if ogre shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_ogre * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_ogre_health;		// default 200
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

if (autocvar_reiver_supports_ogre)		// if reiver shall be spawned in ADDITION to an existing ogre. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_ogre * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_ogre)		// if afrit shall be spawned in ADDITION to an existing ogre. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_ogre * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}
	
var float autocvar_ogremass = 2600;
MonsterPhysics (self, autocvar_ogremass);
};

void() monster_ogre_marksman =
{
	monster_ogre ();
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
void(string modelname, float modelframe) vengeance_ogre; 

==============================================================================
*/


void() vengeance_ogre_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_ogre_touch = {		// player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg); 	// analog to meele attack dog/fiend
//   T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;			// um nicht endlos damage zu kriegen !

		self.think = vengeance_ogre_end1; 
		self.nextthink = time + 0.1;   
};


void() vengeance_ogre_skull =			//  calls skull in skull.qc   
{
	local	vector	offang, org;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;   
	org_z = org_z + 1;   		 // to adjust spawning coordinate of skull. Depending on the monster it spawnes.

	launch_vengeance_skull (org); 	
	newmis.classname = "skull";
	setmodel (newmis, "progs/skull.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	

	newmis.scale = 0.9;		//  set size of the skull here.  Depending on the monster it spawnes. ;)

	precache_sound("vengeance/skull.wav");	
	precache_sound("vengeance/skulltouch.wav");  
};

										//  from here on: run sequence. 

void() vengeance_ogre_run1 =[	$run1,	vengeance_ogre_run2 ]   {
	ai_face();
 	movetogoal (14);   // orig (9)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run2 =[	$run2,	vengeance_ogre_run3 ]   {
	ai_face();
 	movetogoal (16);   // orig (12)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.37;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run3 =[	$run3,	vengeance_ogre_run4 ]    {
	ai_face();
 	movetogoal (12);   // orig (8)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.34;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run4 =[	$run4,	vengeance_ogre_run5 ]    {
	ai_face();
 	movetogoal (26);   // orig (22)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.31;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run5 =[	$run5,	vengeance_ogre_run6 ]    {
	ai_face();
 	movetogoal (20);   // orig (16)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run6 =[	$run6,	vengeance_ogre_run7 ]    {
	ai_face();
 	movetogoal (8);   // orig (4)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run7 =[	$run7,	vengeance_ogre_run8 ]    {
	ai_face();
 	movetogoal (17);   // orig (13)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_run8 =[	$run8,	vengeance_ogre_random ]    {
	ai_face();
 	movetogoal (28);   // orig (24)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};

							//  from here on: attack/jump sequenz. 

void() vengeance_ogre_swing1 =[ $swing1,	vengeance_ogre_swing2 ]    {
	ai_face();
	movetogoal (5);   // orig(0)
sound7(self, CHAN_VOICE, "ogre/ogsawatk.wav", 1, ATTN_NORM, SNDSPD);  
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_swing2 =[ $swing2,	vengeance_ogre_swing3 ]    {
	ai_face();
	movetogoal (6);   // orig(1)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_swing3 =[ $swing3,	vengeance_ogre_swing4 ]    {
	ai_face();
	movetogoal (9);   // orig(4)
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_swing4 =[ $swing4,	vengeance_ogre_swing5 ]    {
	ai_face();
	movetogoal (18);   // orig(13)
self.touch = vengeance_ogre_touch;
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_swing5 =[ $swing5,	vengeance_ogre_end1 ]    {
	ai_face();
 	movetogoal (14);  // orig(9)
self.touch = vengeance_ogre_touch; 
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 200 + '0 0 10';
	self.alpha = 0.06;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: skull spawn sequenz. 

void() vengeance_ogre_skull1 =[ $shoot1,	vengeance_ogre_skull2 ]    {
	ai_face();
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_skull2 =[ $shoot2,	vengeance_ogre_skull3 ]    {
	ai_face();
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_skull3 =[ $shoot2,	vengeance_ogre_skull4 ]    {	    // original ID1 has $shoot2  TWICE !!!
	ai_face();
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_skull4 =[ $shoot3,	vengeance_ogre_skull5 ]    {	    
	ai_face();
self.touch = vengeance_ogre_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_skull5 =[ $shoot3,	vengeance_ogre_skull6 ]    {	   
	ai_face();
self.touch = vengeance_ogre_touch; 
sound7(self, CHAN_VOICE, "hknight/attack1.wav", 1, 4);	
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre_skull6 =[ $shoot4,	vengeance_ogre_end1 ]    {
	ai_face();
self.touch = vengeance_ogre_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_ogre_skull();
};



void()	vengeance_ogre_random 	= {		// random final animation selection
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.01;
		if (random() > 0.46)
			self.think = vengeance_ogre_swing1; 
		else
			self.think = vengeance_ogre_skull1;
};



										//  from here on: ressurection sequence 1. 

void() vengeance_ogre11 =[	$death13,	vengeance_ogre12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre12 =[	$death12,	vengeance_ogre13 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre13 =[	$death11,	vengeance_ogre14 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre14 =[	$death10,	vengeance_ogre15 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre15 =[	$death9,	vengeance_ogre16 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre16 =[	$death8,	vengeance_ogre17 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre17 =[	$death7,	vengeance_ogre18 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre18 =[	$death6,	vengeance_ogre19 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre19 =[	$death5,	vengeance_ogre120	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre120 =[	$death4,	vengeance_ogre121	]  {
sound7(self, CHAN_WEAPON, "ogre/ogwake.wav", 1, ATTN_NORM, SNDSPD);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre121 =[	$death3,	vengeance_ogre122	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre122 =[	$death2,	vengeance_ogre123	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre123 =[	$death1,	vengeance_ogre_run1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



									//  from here on: ressurection sequence 2. 

void() vengeance_ogre21 =[	$bdeath9,	vengeance_ogre22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre22 =[	$bdeath8,	vengeance_ogre23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre23 =[	$bdeath7,	vengeance_ogre24 	]  {
 //	movetogoal (25); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 25);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre24 =[	$bdeath6,	vengeance_ogre25 	]  {
// 	movetogoal (7); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 7);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre25 =[	$bdeath5,	vengeance_ogre26 	]  {
// 	movetogoal (3); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 3);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre26 =[	$bdeath4,	vengeance_ogre27 	]  {
sound7(self, CHAN_WEAPON, "ogre/ogwake.wav", 1, ATTN_NORM, SNDSPD);
// 	movetogoal (1); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 1);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre27 =[	$bdeath3,	vengeance_ogre28 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre28 =[	$bdeath2,	vengeance_ogre29 	]  {
// 	movetogoal (5); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 5);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_ogre29 =[	$bdeath1,	vengeance_ogre_run1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


								// from here on:  sequence where the corpse overbrights 
void()	vengeance_ogre_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death14)
			self.think = vengeance_ogre11;
		else
			self.think = vengeance_ogre21;
};
void()	vengeance_ogre_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_ogre_bright05;
};
void()	vengeance_ogre_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_ogre_bright04;
};
void()	vengeance_ogre_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_ogre_bright03;
}; 
void()	vengeance_ogre_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_ogre_bright02;
};
void()	vengeance_ogre_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_ogre_bright01;
};



void(string modelname, float modelframe) vengeance_ogre =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.

v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_model ("progs/skull.mdl");	// precached in worldspawn() due to savegame-bug
//	precache_sound("hknight/attack1.wav");	// precached in worldspawn() due to savegame-bug

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/ogre.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/ogre1.mdl"); 
	
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  // if value is NOT "0", player get hurt from this effect (see func "vengeance_ogre_touch")!

	vengeance_ogre_bright00 ();			 // starts the animation
};

