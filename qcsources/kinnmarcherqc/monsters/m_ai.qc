
//bdw - 29/03/04 - hopefully removed all the hipnotic charmer stuff.

// ben - fight.qc start...

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;

/*
=======================================================================
A monster is in fight mode if it thinks it can effectively attack its
enemy.

When it decides it can't attack, it goes into hunt mode.
=======================================================================
*/
/*
=======================================================================
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue

ben - removed knight bit - he has his own checkattack now.
=======================================================================
*/
float() CheckAttack =
{
	local vector	spot1, spot2;
	local entity	targ;
	local float		chance;

	targ = self.enemy;

// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

   	if (trace_ent != targ)
      	return FALSE;     // don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{			
			self.th_melee();
			return TRUE;
		}
	}

// missile attack
	if (!self.th_missile)
		return FALSE;

	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;
		else
			chance = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;
		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (2*random());
		return TRUE;
	}

	return FALSE;
};


/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
	ai_face ();
	movetogoal (d);		// done in C code...
};

void() ai_charge_side =
{
	local	vector	dtemp;
	local	float	heading;

// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);

	walkmove(heading, 20);
};


/*
=============
ai_melee

bdw - note this is currently only used by the knight and hellknight
it is called a number of times during a single swordstroke
i have added a sword impact sound here that uses the field voice_finished
so successive calls of this function over say 3 frames don't repeat the sound
(note trying to accomplish this playing on chan_auto doesn't seem to work...

=============
*/
void() ai_melee =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
	
	//bdw...
	if (gameflags1 & GF1_IMPACTS)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_WEAPON, "weapons/met2flsh.wav", 0.5, ATTN_NORM);	//bdw
			self.voice_finished = time + 0.7;
		}
	}

};

void() ai_melee_side =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke

	ai_charge_side();

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
	
	//bdw...
	if (gameflags1 & GF1_IMPACTS)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_WEAPON, "weapons/met2flsh.wav", 0.5, ATTN_NORM);	//bdw
			self.voice_finished = time + 0.7;
		}
	}
};

//=============================================================================
// ben - fight.qc end - ai.qc start...

/*
=============================================================================
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
=============================================================================
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
entity sight_entity;
float	sight_entity_time;
void() FoundTarget;

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

/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/

void() t_movetarget =
{
	local entity temp;

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
//MED
   	if (other.target)
      {
      	self.goalentity = self.movetarget = find (world, targetname, other.target);
      	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
      	if (!self.movetarget)
         	{
         		self.pausetime = time + 999999;
         		self.th_stand ();
         		return;
         	}
   //MED 01/20/97
      	else if (other.delay)
         	{
         		self.pausetime = time + other.delay;
         		self.th_stand ();
         	}
      }
   	else
      {
      	self.pausetime = time + 999999;

		//bdw - this is new (and very cool) - set angle in editor and monster will turn to face that direction when he stops
		//note - if you want angle 0, set it to 360, or something small like 1...
		if (other.angles_y)
			self.ideal_yaw = other.angles_y;

      	self.th_stand ();
      	return;
      }
};

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
"delay" delay to wait before proceeding to next segment;
*/
void() path_corner =
{
	movetarget_f ();
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
   traceline (spot1, spot2, TRUE, self);  // see through other monsters

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

//MED 11/21/96
	if (trace_fraction == 1)
      {
      	visible_distance = vlen(spot2-spot1);
      	return TRUE;
      }
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

void() bdw_change_pitch =
{
	//local string st;

	local float current_pitch, ideal, move;

	current_pitch = anglemod(self.angles_x);
	//current_pitch = self.angles_x;

	ideal = self.idealpitch;	
	
	if (current_pitch == ideal)
		return;

	move = ideal - current_pitch;

	if (ideal > current_pitch)
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

	current_pitch = anglemod(current_pitch + move);
	//current_pitch = current_pitch + move;

	self.angles_x = current_pitch;
};	


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

//bdw - now with optional silent monsters...
	if (self.spawnflags & M_NOSIGHT)
	{
		self.spawnflags = self.spawnflags - M_NOSIGHT;	//will be vocal on subsequent attacks
		return;
	}

// bdw - a much better way of doing it...
	if (self.sight_sound)	
	{
		self.sight_sound();
		return;
	}

	if (self.classname == "monster_ogre")
		sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_knight")
		sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shambler")
		sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_demon1")
		sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_wizard")
		sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_zombie")
		sound (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_dog")
		sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_hell_knight")
		sound (self, CHAN_VOICE, "hknight/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_tarbaby")
		sound (self, CHAN_VOICE, "blob/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_vomit")
		sound (self, CHAN_VOICE, "vomitus/v_sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_enforcer")
	{
		rsnd = rint(random() * 3);
		if (rsnd == 1)
			sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, ATTN_NORM);
		else if (rsnd == 2)
			sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, ATTN_NORM);
		else if (rsnd == 0)
			sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, ATTN_NORM);
	}
	else if (self.classname == "monster_army")
		sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
	else if (self.classname == "monster_shalrath")
		sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM);

//bdw 31/03/04 - disabled gremlins...
/*
   	else if (self.classname == "monster_gremlin")
      {
      	if (self.stoleweapon == 0)
         		sound (self, CHAN_VOICE, "grem/sight1.wav", 1, ATTN_NORM);
      }
*/
   	else if (self.classname == "monster_scourge")
      	sound (self, CHAN_VOICE, "scourge/sight.wav", 1, ATTN_NORM);
   	else if (self.classname == "monster_armagon")
      	sound (self, CHAN_VOICE, "armagon/sight.wav", 1, 0.1);
};

void() FoundTarget =
{
	if (self.enemy.classname == "player")
	{    	
      	// let other monsters see this monster for a while
      	if (!(self.enemy.flags & FL_NOTARGET))	//bdw - don't wake others if notarget
      	{
			sight_entity = self;
			sight_entity_time = time;
		}
  	}   	

	self.show_hostile = time + 1;		// wake up other monsters

	SightSound();
	HuntTarget();
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
// bdw - i have now changed this...
   	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & M_AMBUSH) )
      {
		client = sight_entity;
		if (client.enemy == self.enemy)
			return FALSE;	//bdw 05/11/04 - previously this had no return value
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

	// check for noticing a player
   	if (FindTarget())
      		return;

      movetogoal(dist);
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

	//bdw - new for path_corners
	if (self.movetarget)
	{
		if (self.ideal_yaw)
			ChangeYaw();
	}
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

//MED 11/10/96 added ai_turn_in_place
/*
=============
ai_turn_in_place

don't move, but turn towards ideal_yaw
=============
*/
void() ai_turn_in_place =
   {
   local float delta;

   self.nextthink = time + 0.1;
   enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
   delta = fabs(self.angles_y - enemy_yaw);
   if (delta > MIN_ANGLE_DELTA)
      {
      self.ideal_yaw = enemy_yaw;
      ChangeYaw();
      }
   else
      {
      self.think = self.th_run;
      }
   };

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void(vector desti) ChooseTurn =
{
	local vector	dir, newdir;

	dir = self.origin - desti;

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

//bdw 31/03/04 - disabled gremlins...
//float()  GremlinCheckAttack;

/*
float() CheckAnyAttack =
{
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
   	if (self.classname == "monster_gremlin")
      	return GremlinCheckAttack ();
   	if (self.classname == "monster_scourge")
      	return ScourgeCheckAttack ();
   	if (self.classname == "monster_armagon")
      	return ArmagonCheckAttack ();

   	return CheckAttack ();
};
*/

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
void() ai_run_slide =
{
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
};

//MED
/*
=============
ai_run_dodge

Strafe sideways, but continue moving towards the enemy
Used by the Scourge.
=============
*/
void() ai_run_dodge =
{
	local float	ofs;
   local float newyaw;

/*
// attempt to jump over missiles
   if (self.enemy.weaponframe == 1)
      {
      if (self.flags & FL_ONGROUND)
         {
         self.origin_z = self.origin_z + 1;
         self.velocity = self.velocity + '0 0 500';
         self.flags = self.flags - FL_ONGROUND;
         }
      self.ltime = self.ltime + 1.0;
      }
*/
   self.nextthink = time + 0.1;
   if (self.lefty)
      ofs = 40;
	else
      ofs = -40;

   if (time > self.ltime)
      {
      self.lefty = 1 - self.lefty;
      self.ltime = time + 0.8;
      }

   newyaw = enemy_yaw + ofs;
   self.ideal_yaw = enemy_yaw;
   if (walkmove (newyaw, movedist))
      {
      ChangeYaw ();
      return;
      }

   self.lefty = 1 - self.lefty;
   self.ltime = time + 0.8;
   newyaw = enemy_yaw - ofs;
   self.ideal_yaw = enemy_yaw;
   walkmove (newyaw, movedist);
   ChangeYaw ();
};

//
// bdw - ai_run_guided for use with trigger_monsterguides
//

float(entity e, entity g) BDW_CheckMonsterGuidePosition;
float() ai_run_guided =
{
	local vector d;

	if (!self.guide_ent)
	{
		dprint("warning: guide_ent removed\n");
		return FALSE;
	}

	if (!self.enemy)
		return FALSE;

	if (self.enemy.health <= 0)
		return FALSE;

	if (!(BDW_CheckMonsterGuidePosition(self.enemy, self.guide_ent)))
		return FALSE;	

	return TRUE;
};

void(float dist) ai_run;
void(float dist) ai_bdw_flyrun =
{
	if (!self.monsterflags & MF_SMOOTH_FLIGHT)
	{
		ai_run(dist);
		return;
	}

	local vector oldorg, neworg, dir;

	oldorg = self.origin;		//remember original position
	ai_run(dist);			//do a test move using normal movement code
	neworg = self.origin;		//remember new position
	setorigin(self, oldorg);	//reset monster back to original position

	dir = neworg - oldorg;

	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity = normalize(dir) * dist * 10;		//attempt to move to new position using velocity only
};


void() BDW_ReleaseFromGuidedState =
{	
	self.guide_ent = world;

	if (self.enemy == world)	//this happens in touch functions called inside movetogoal(), when self.enemy is temporarily set to world.
		self.goalentity = self.oldenemy;
	else
		self.goalentity = self.enemy;

	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	self.monsterflags = self.monsterflags - (self.monsterflags & MF_GUIDED);
	dprint(self.classname);dprint(" no longer guided\n");
};

/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/



void(float dist) ai_run =
{
	local	float	axis;
	local entity temp_oldenemy;	//bdw

	movedist = dist;

//bdw - experimental...
	if (self.monsterflags & MF_GUIDED)
	{
		if (!ai_run_guided())
			BDW_ReleaseFromGuidedState();	
	}

// see if the enemy is dead
   	if (self.enemy.health <= 0)
	{
		self.enemy = world;		
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
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

	if (enemy_vis)
	{
		if (self.check_attack())
			return;			// beginning an attack
	}	

	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide ();
		return;
	} 
       
// head straight in...
	
	if (self.monsterflags & MF_GUIDED)
	{
		//note that movetogoal() moves monsters into stuff, and therefore touch functions can be called inside movetogoal()
		//therefore, touched objects would think that a guided monster has no enemy, so you need to be prepared for this

		temp_oldenemy = self.oldenemy;
		self.oldenemy = self.enemy;
		self.enemy = world;		
		movetogoal(dist);
		self.enemy = self.oldenemy;
		self.oldenemy = temp_oldenemy;
	}
	else
		movetogoal(dist);      // done in C code...         
};
