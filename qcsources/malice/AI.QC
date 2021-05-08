/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () movetarget_f;
void () t_movetarget;
float current_yaw;
float current_pitch;
entity sight_entity;
float sight_entity_time;

float (float v) anglemod =
	{
	while (v >= 360)
		{
		v = v - 360;
		}
	while (v < 0)
		{
		v = v + 360;
		}
	return (v);
	};


void () movetarget_f =
	{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	};


void () path_corner =
	{
	movetarget_f ();
	};


void () t_movetarget =
	{
	local entity temp;

	if ((other.movetarget != self))
		return;
	if (other.enemy)
		return;

	temp = self;
	self = other;
	other = temp;
	/*
	// ACC, Quake only, removed
	if (self.classname == "monster_ogre")
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1.00, ATTN_IDLE);
	*/
	self.movetarget = find (world, targetname, other.target);
	self.goalentity = find (world, targetname, other.target);
	self.ideal_yaw = vectoyaw (self.goalentity.origin - self.origin);
	if (!self.movetarget)
		{
		self.pausetime = time + 999999;
		self.th_stand ();
		return;
		}
	};


float (entity targ) range =
	{
	local vector spot1;
	local vector spot2;
	local float r;

	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen (spot1 - spot2);
	if (r < 120)
		return (RANGE_MELEE);
	if (r < 500)
		return (RANGE_NEAR);
	if (r < 1000)
		return (RANGE_MID);
	return (RANGE_FAR);
	};


float (entity targ) visible =
	{
	local vector spot1;
	local vector spot2;

	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);
	if (trace_inopen && trace_inwater)
		return (FALSE);
	if (trace_fraction == TRUE)
		return (TRUE);
	return (FALSE);
	};


float (entity targ) infront =
	{
	local vector vec;
	local float dot;

	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	if (dot > 0.3)
		return (TRUE);
	return (FALSE);
	};


void () ChangePitch =
	{
	local float ideal;
	local float move;

	current_pitch = self.angles_x;
	ideal = self.ideal_pitch;
	if (ideal > 54)
		ideal = 54;
	else if (ideal < -54)
		ideal = -54;
	if (current_pitch == ideal)
		return;
	move = ideal - current_pitch;
	if (move > 0)
		{
		if (move > 6)
			move = 6;
		}
	else
		{
		if (move < -6)
			move = -6;
		}
	current_pitch = current_pitch + move;
	self.angles_x = current_pitch;
	};


void () HuntTarget =
	{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw (self.enemy.origin - self.origin);
	self.nextthink = time + 0.10;
	SUB_AttackFinished (1.00);
	};


void () SightSound =
	{
	if (self.classname == "monster_swat")
		{
		if (random () < 0.50)
			sound (self, CHAN_VOICE, "swat/sight1.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "swat/sight2.wav", 1.00, ATTN_NORM);
		}
	else if (self.classname == "monster_merc")
		sound (self, CHAN_VOICE, "mercbabe/sight1.wav", 1.00, ATTN_NORM);
	else if (self.classname == "monster_torcher")
		sound (self, CHAN_VOICE, "torcher/stop.wav", 1.00, ATTN_NORM);
	else if (self.classname == "monster_frogman")
		sound (self, CHAN_VOICE, "frogman/sight.wav", 1.00, ATTN_NORM);
	else if (self.classname == "monster_banshee")
		{
		if (random () < 0.50)
			sound (self, CHAN_VOICE, "banshee/sight.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "banshee/sight2.wav", 1.00, ATTN_NORM);
		}
	else if (self.classname == "monster_hunter")
		{
		if (random () < 0.50)
			sound (self, CHAN_VOICE, "hunter/sight1.wav", 1.00, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "hunter/sight2.wav", 1.00, ATTN_NORM);
		}
	};


void () FoundTarget =
	{
	if ((self.enemy.classname == "player") || (self.enemy.classname == "hologram"))
		{
		sight_entity = self;
		sight_entity_time = time;
		}
	self.show_hostile = time + 1.00;
	SightSound ();
	HuntTarget ();
	};


float () FindTarget =
	{
	local entity themark;
	local float r;
	local entity beef;

	if ((sight_entity_time >= (time - 0.10)) && !(self.spawnflags & 3))
		{
		themark = sight_entity;
		if (themark.enemy == self.enemy)
			return (FALSE);
		}
	else
		{
		if ((active_probes != FALSE) && (random () < 0.50))
			{
			beef = find (world, classname, "hologram");
			if ((beef != world) && (beef.holo_owner.flags != (beef.holo_owner.flags | FL_NOTARGET)))
				themark = beef;
			else
				themark = checkclient ();
			}
		else
			themark = checkclient ();
		if (!themark)
			return (FALSE);
		}
	if (themark == self.enemy)
		return (FALSE);
	if (themark.flags & FL_NOTARGET)
		return (FALSE);
	r = range (themark);
	if ((r == RANGE_FAR))
		return (FALSE);
	if (!visible (themark))
		return (FALSE);
	if (r == RANGE_NEAR)
		{
		if ((themark.show_hostile < time) && !infront (themark))
			return (FALSE);
		}
	else if (r == RANGE_MID)
		{
		if (!infront (themark))
			return (FALSE);
		}
	self.enemy = themark;
	if ((self.enemy.classname != "player") && (self.enemy.classname != "hologram"))
		{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
			{
			self.enemy = world;
			return (FALSE);
			}
		}
	FoundTarget ();
	return (TRUE);
	};


void (float dist) ai_forward =
	{
	walkmove (self.angles_y, dist);
	};


void (float dist) ai_back =
	{
	walkmove (self.angles_y + 180, dist);
	};


void (float dist) ai_pain =
	{
	ai_back (dist);
	};


void (float dist) ai_painforward =
	{
	walkmove (self.ideal_yaw, dist);
	};


void (float dist) ai_walk =
	{
	local vector mtemp;

	movedist = dist;
	if (FindTarget ())
		return;
	movetogoal (dist);
	};


void () ai_stand =
	{
	if (FindTarget ())
		return;
	if (time > self.pausetime)
		{
		self.th_walk ();
		return;
		}
	};


void () ai_turn =
	{
	if (FindTarget ())
		return;
	ChangeYaw ();
	};


void (vector dest3) ChooseTurn =
	{
	local vector dir;
	local vector newdir;

	dir = self.origin - dest3;
	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	if ((dir * newdir) > 0)
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
	self.ideal_yaw = vectoyaw (dir);
	};


float () FacingIdeal =
	{
	local float delta;

	delta = anglemod (self.angles_y - self.ideal_yaw);
	if ((delta > 45) && (delta < 315))
		return (FALSE);
	return (TRUE);
	};

float  () CheckAnyAttack =
	{
	if (!enemy_vis)
		return 0;
	/*
	// ACC, Quake-only, removed
	if (self.classname == "monster_army")
		return (SoldierCheckAttack ());
	if (self.classname == "monster_ogre")
		return (OgreCheckAttack ());
	if (self.classname == "monster_shambler")
		return (ShamCheckAttack ());
	*/
	return (CheckAttack ());
	};

void () ai_run_melee =
	{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal ())
		{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
		}
	};


void () ai_run_missile =
	{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal ())
		{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
		}
	};


void () ai_run_slide =
	{
	local float ofs;

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

float RUN_STRAIGHT; 

void (float dist) ai_run =
	{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;

	movedist = dist;
	if (self.enemy.health <= 0)
		{
		self.enemy = world;
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
	self.show_hostile = time + 1.00;
	enemy_vis = visible (self.enemy);
	if (enemy_vis)
		self.search_time = time + 5.00;
	if (coop && (self.search_time < time))
		{
		if (FindTarget ())
			return;
		}
	enemy_infront = infront (self.enemy);
	enemy_range = range (self.enemy);
	enemy_yaw = vectoyaw (self.enemy.origin - self.origin);
	if (self.attack_state == AS_MISSILE)
		{
		ai_run_missile ();
		return;
		}
	if (self.attack_state == AS_MELEE)
		{
		ai_run_melee ();
		return;
		}
	if (CheckAnyAttack ())
		return;
	if (self.attack_state == AS_SLIDING)
		{
		ai_run_slide ();
		return;
		}
	if (RUN_STRAIGHT && (time > self.ltime))
		{
		RUN_STRAIGHT = FALSE;
		axis = walkmove (self.angles_y, movedist);
		if (!axis)
			{
			self.ltime = time + 3.00;
			movetogoal (dist);
			}
		}
	else
		movetogoal (dist);
	};

