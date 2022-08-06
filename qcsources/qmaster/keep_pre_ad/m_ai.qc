void() bdw_change_pitch =
{
   local float current_pitch;
   local float ideal;
   local float move;

   current_pitch = anglemod(self.angles_x);

   ideal = self.idealpitch;	
	
   if (current_pitch == ideal) {

      return;

   }
   move = ideal - current_pitch;

   if (ideal > current_pitch) {

      if (move > 180)

         move = move - 360;

      } else {

         if (move < -180) {

            move = move + 360;

	 }

      }
	
   if (move > 0)
   {
      if (move > self.yaw_speed) {

         move = self.yaw_speed;

      }

   } else {
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
		