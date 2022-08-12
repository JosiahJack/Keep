void() movetarget_f;
void() t_movetarget;
void() knight_walk1;
void() knight_bow6;
void() knight_bow1;
void(entity etemp, entity stemp, entity stemp, float dmg) T_Damage;
/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/


//
// globals
//
float	current_yaw;

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;

float(float v) anglemod =
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/


void() movetarget_f =
{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void() path_corner =
{
	movetarget_f ();
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void() t_movetarget =
{
local entity	temp;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other;
	other = temp;

	if (self.classname == "monster_ogre")
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand ();
		return;
	}
};



//============================================================================

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/
float(entity targ) range =
{
local vector	spot1, spot2;
local float		r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 120)
		return RANGE_MELEE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};


//============================================================================

/*
===========
ChangeYaw

Turns towards self.ideal_yaw at self.yaw_speed
Sets the global variable current_yaw
Called every 0.1 sec by monsters
============
*/
/*

void() ChangeYaw =
{
	local float		ideal, move;

//current_yaw = self.ideal_yaw;
// mod down the current angle
	current_yaw = anglemod( self.angles_y );
	ideal = self.ideal_yaw;
	
	if (current_yaw == ideal)
		return;
	
	move = ideal - current_yaw;
	if (ideal > current_yaw)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
		
	if (move > 0)
	{
		if (move > self.yaw_speed)
			move = self.yaw_speed;
	}
	else
	{
		if (move < 0-self.yaw_speed )
			move = 0-self.yaw_speed;
	}

	current_yaw = anglemod (current_yaw + move);

	self.angles_y = current_yaw;
};

*/


//============================================================================

void() HuntTarget =
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished (1);	// wait a while before first attack
};

void() SightSound =
{
local float	rsnd;

	if (self.classname == "monster_ogre")	
		sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_knight")
		sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shambler")
		sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_demon1")
	{
		if (self.monstermodel == 2)  
			sound (self, CHAN_VOICE, "teneb/sight.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM);
	}
	else if (self.classname == "monster_wizard")
		sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_zombie")
		sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_dog")
		sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_hell_knight")
		sound (self, CHAN_VOICE, "hknight/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_hell_knight2")
		sound (self, CHAN_VOICE, "warlord/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_tarbaby")
		sound (self, CHAN_VOICE, "blob/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_vomit")
		sound (self, CHAN_VOICE, "vomitus/v_sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_enforcer") 
	{
		rsnd = rint(random() * 3);			
		if (self.enforcer_type == "monster_defender") 
		{
			if (rsnd == 1)
				sound (self, CHAN_VOICE, "defender/sight1.wav", 1, ATTN_NORM);
			else if (rsnd == 2)
				sound (self, CHAN_VOICE, "defender/sight2.wav", 1, ATTN_NORM);
			else if (rsnd == 0)
				sound (self, CHAN_VOICE, "defender/sight3.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "defender/sight4.wav", 1, ATTN_NORM);
		}
		else if (self.enforcer_type == "monster_eliminator") 
		{
			if (random() < 0.5)
				sound (self, CHAN_VOICE, "eliminator/sight.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "eliminator/acknow.wav", 1, ATTN_NORM);
		}
		else if (self.enforcer_type == "monster_pyro") 
			sound (self, CHAN_VOICE, "pyro/sight.wav", 1, ATTN_NORM);
		else
		{
			if (rsnd == 1)
				sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
			else if (rsnd == 2)
				sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM);
			else if (rsnd == 0)
				sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM);
		}
	}
	else if (self.classname == "monster_army")
		sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shalrath")
		sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM);
	else if ((self.classname == "monster_spider") && (!self.spider_jumped_ceiling_at_map_start))	// to better suprise the player
		sound (self, CHAN_VOICE, "spider/spider_sight.wav", 1, ATTN_NORM);
	else if ((self.classname == "monster_afrit")&&(!self.in_cocoon_shape))
		sound (self, CHAN_VOICE, "afrit/sight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_torment")
		sound (self, CHAN_VOICE, "torment/alert.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_carnivean")
		sound (self, CHAN_VOICE, "carnivean/scream.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_yakman")
	{
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "yakman/big1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "yakman/big3.wav", 1, ATTN_NORM);
	}
	else if (self.classname == "monster_reiver")
		sound (self, CHAN_VOICE, "reiver/sight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_necromancer")
		sound (self, CHAN_VOICE, "necromancer/sight.wav", 1, ATTN_NORM);
};

void() FoundTarget =
{
	if (self.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}
	
	self.show_hostile = time + 1;		// wake up other monsters

	SightSound ();
	HuntTarget ();
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float() FindTarget =
{
	local entity	client;
	local float		r;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if ( /* client.show_hostile < time || */ !infront (client))
			return FALSE;
	}
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	FoundTarget ();

	return TRUE;
};


//=============================================================================

void(float dist) ai_forward =
{
	walkmove (self.angles_y, dist);
};

void(float dist) ai_back =
{
	walkmove ( (self.angles_y+180), dist);
};


/*
=============
ai_pain

stagger back a bit
=============
*/
void(float dist) ai_pain =
{
	ai_back (dist);
/*
	local float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void(float dist) ai_painforward =
{
	walkmove (self.ideal_yaw, dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
	movedist = dist;
	
	if (self.classname == "monster_dragon")
	{
		movetogoal (dist);
		return;
	}
	// check for noticing a player
	if (FindTarget ())
		return;

	movetogoal (dist);
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void() ai_stand =
{
	if (FindTarget ())
		return;
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
	
// change angle slightly

};

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn =
{
	if (FindTarget ())
		return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void(vector dest3) ChooseTurn =
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

/*
============
FacingIdeal

============
*/
float() FacingIdeal =
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};


//=============================================================================

float()	WizardCheckAttack;
float()	DogCheckAttack;
float()	SpiderCheckAttack;
float()	AfritCheckAttack;
float()	NecromancerCheckAttack;
float()	PyroCheckAttack;

float() CheckAnyAttack = 
{
	if (!enemy_vis)
		return;
	if (self.classname == "monster_army")
		return SoldierCheckAttack ();
	if (self.classname == "monster_ogre")
		return OgreCheckAttack ();
	if (self.classname == "monster_shambler")
		return ShamCheckAttack ();
	if (self.classname == "monster_demon1")
		return DemonCheckAttack ();
	if (self.classname == "monster_dog")
		return DogCheckAttack ();
	if (self.classname == "monster_wizard")
		return WizardCheckAttack ();
	if (self.classname == "monster_spider")
		return SpiderCheckAttack ();
	if (self.classname == "monster_afrit")
		return AfritCheckAttack ();
	if (self.classname == "monster_necromancer")
		return NecromancerCheckAttack ();
	if ((self.classname == "monster_enforcer") && (self.enforcer_type == "monster_pyro"))
		return (PyroCheckAttack());
	return CheckAttack ();
};


/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
void() ai_run_melee =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void() ai_run_missile =
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void(float dist) ai_run_slide =
{
	movedist = dist;
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, movedist))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, movedist);
	ai_face();
};


/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/
void(float dist) ai_run =
{
local vector check;
check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';

var float autocvar_monsterlavaslime = 1;     	// set cvar 'monsterlavaslime' default to 1
	if (autocvar_monsterlavaslime == 1)		// if 'monsterlavaslime' is '1' 
	{
	if (pointcontents(check) == CONTENT_LAVA)			// checks for lava
		{
		self.traileffectnum = particleeffectnum("monsterburn");	// adds particle effect to monsters when in lava (customize the effect in your effectinfo.txt)
		self.colormod = '0.4 0.1 0.1';					// change the color of the monster to  burned  dark red
		self.nodeathanim = 1;
		}
	if (pointcontents(check) == CONTENT_SLIME)			// checks for slime
		{
		self.traileffectnum = particleeffectnum("monsteracid");	// adds particle effect to monsters when in slime (customize the effect in your effectinfo.txt)
		self.colormod = '0.3 1.6 0.3';					// change the color of the monster to  slimy/etchy  green
		self.nodeathanim = 1;
		}
	if ((pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA))	// needed to STOP the particle effect when monster moves (is kicked/shot) out of slime or lava !!
		{
		self.traileffectnum = particleeffectnum("monsternull");		// REMOVES the particle effect from monsters (it is a null effect in your effectinfo.txt)
		}
	}	

	else if (autocvar_monsterlavaslime == 2)		// if 'monsterlavaslime' is '2', they take damage too
	{
	if (pointcontents(check) == CONTENT_LAVA)			// checks for lava
		{
		self.traileffectnum = particleeffectnum("monsterburn");	// adds particle effect to monsters when in lava (customize the effect in your effectinfo.txt)
		self.colormod = '0.4 0.1 0.1';					// change the color of the monster to  burned  dark red
		self.nodeathanim = 1;
		if (self.classname != "monster_zombie")		// Zombies take no damage !!
			{
			if (self.monstdamag < time)
				{
				T_Damage (self, world, world, 14);
				if (self.health <= 0)
					{
					self.th_die ();
					return;
					}
				self.monstdamag = time + 0.5; 
				}
			}
		}
	if (pointcontents(check) == CONTENT_SLIME)			// checks for slime
		{
		self.traileffectnum = particleeffectnum("monsteracid");	// adds particle effect to monsters when in slime (customize the effect in your effectinfo.txt)
		self.colormod = '0.3 1.6 0.3';					// change the color of the monster to  slimy/etchy  green
		self.nodeathanim = 1;
		if (self.classname != "monster_zombie")		// Zombies take no damage !!
			{
			if (self.monstdamag < time)
				{
				T_Damage (self, world, world, 7);
				if (self.health <= 0)
					{
					self.th_die ();
					return;
					}
				self.monstdamag = time + 1; 
				}
			}
		}
	if ((pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA))	// needed to STOP the particle effect when monster moves (is kicked/shot) out of slime or lava !!
		{
		self.traileffectnum = particleeffectnum("monsternull");		// REMOVES the particle effect from monsters (it is a null effect in your effectinfo.txt)
		}
	}


if (self.classname == "monster_zombie")	
	{
	var float autocvar_zombieflies = 2;	    	// set cvar 'zombieflies' default to 2
	if ((autocvar_zombieflies == 1 ) && (pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA))	// if cvar 'zombieflies' is 1 and not in slime or lava, zombies have BLACK flies around them
		self.traileffectnum = particleeffectnum("zombiefliesblack");
	else if ((autocvar_zombieflies == 2 ) && (pointcontents(check) != CONTENT_SLIME) && (pointcontents(check) != CONTENT_LAVA))	// if cvar 'zombieflies' is 2 and not in slime or lava, zombies have BROWN flies around them
		self.traileffectnum = particleeffectnum("zombiefliesbrown");
	}


if (autocvar_monster_bleeding)
	{
	makevectors (self.angles);	
	if (self.health < self.health_initial) 		// if health is below initial health
		{
		if (autocvar_monster_bleeding == 1)
			pointparticles(particleeffectnum("TE_BLEED1"), self.origin + v_up * -5 + v_forward * 7, '0 0 0', 1);
		else if (autocvar_monster_bleeding == 2)
			pointparticles(particleeffectnum("TE_BLEED2"), self.origin + v_up * -5 + v_forward * 7, '0 0 0', 1);
		}
	}
	

	movedist = dist;
// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget ();
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;

// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			return;
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
		ai_run_missile ();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
//dprint ("ai_run_melee\n");
		ai_run_melee ();
		return;
	}

	if (CheckAnyAttack ())
		return;					// beginning an attack
		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide (dist); 
		return;
	}
		
// head straight in
	movetogoal (dist);		// done in C code...
};


/*
=============
ai_run_inflamed

The monster runs around in panic
=============
*/
void(float dist) ai_run_inflamed =
{

	self.colormod = '0.35 0.26 0.26';	// skins gets darker (looks burned)

	if (autocvar_monster_bleeding)
	{
		makevectors (self.angles);	
		if (self.health < self.health_initial) 		// if health is below initial health
			{
			if (autocvar_monster_bleeding == 1)
				pointparticles(particleeffectnum("TE_BLEED1"), self.origin + v_up * -5 + v_forward * 7, '0 0 0', 1);
			else if (autocvar_monster_bleeding == 2)
				pointparticles(particleeffectnum("TE_BLEED2"), self.origin + v_up * -5 + v_forward * 7, '0 0 0', 1);
			}
	}
	
	movedist = dist;

	self.enemy = world;		// do not hunt player anymore !!
	self.show_hostile = time + 1;	// wake up other monsters

// head straight in
	movetogoal (dist);		// done in C code...
};

