
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;

void() monster_death_use;

//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};

/*
============
Killed
============
*/
void(entity targ, entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;

	if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player 

	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die();
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
   	if (self.flags & FL_MONSTER)
	{
     	 	killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);

		//give the shuffler a frag back...
		if (self.monsterflags & MF_SHUFFLER_MINION)
			self.spawnmaster.frags = self.spawnmaster.frags + 1;
		else if (attacker.flags & FL_MONSTER)
		{
			if (attacker.monsterflags & MF_COUNT_FRAGS) //bdw - shufflers keep track of how many they've killed...
				attacker.frags = attacker.frags + 1;
		}		
	}


	ClientObituary(self, attacker);

	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();

	self = oself;
};

float(entity attacker) NotAGoonSlapper =
{
	//this function just returns true if attacker is not a goonslapper
	//it just saves typing in certain monster th_pain functions...

	if (!attacker.flags & FL_MONSTER)
		return TRUE;
	if (!attacker.monsterflags & MF_GOON_SLAP)
		return TRUE;

	dprint("ouch - i've been goonslapped.\n");

	return FALSE;	// it is a goonslapper
};		

float(entity targ, entity attacker) BDW_CheckForFight =
{
	local float d;
	local entity oself;

	if (!(targ.flags & FL_MONSTER))
		return FALSE;

	if (attacker == targ.enemy)
		return FALSE;

	if (attacker == targ)
		return FALSE;

	if (attacker == world)
		return FALSE;

	/*if (attacker.flags & FL_CLIENT)
	{
		//bdw - spawnflags 2 is now the new "ultra ambush" mode, 
		//where a monster won't even get angry at damage if the player is not visible

		if (!targ.enemy)	//lying in wait
		{	
			if (targ.spawnflags & M_AMBUSH2)	//ultra ambush
			{
				oself = self;
				self = targ;
				if (!visible(attacker))
				{
					self = oself;
					dprint("ultra ambush\n");
					return FALSE;
				}
				self = oself;
			}
		}
	}*/
	
	if (targ.monsterflags & MF_GOON_SLAP)
		return FALSE;	//don't disturb a goon slapping shuffler

	if (attacker.flags & FL_MONSTER)
	{
		if (time < targ.monster_fight_time)
		{
			dprint(targ.classname);
			dprint(" currently busy, new challenger ignored.\n");
			return FALSE;
		}

		if (attacker.monsterflags & MF_GOON_SLAP)
			return FALSE;	//just a shuffler slapping some goons into shape

		//shuffler minions don't get angry at their masters unless it's deliberate
		if (targ.monsterflags & MF_SHUFFLER_MINION)
			if (attacker == targ.spawnmaster)
				if (attacker.enemy != targ)
					return FALSE;

		//bdw - this stops monsters getting angry at "notarget" monsters, 
		//unless the notarget monster started it deliberately...
		if (attacker.spawnflags & M_NOTARGET)
		{
			if (attacker.enemy != targ)
				return FALSE;
		}
		if (attacker.spawnflags & M_MISSILETARGET)
		{
			if (targ.max_attack_height)
			{
				d = attacker.origin_z - targ.origin_z;
				d = fabs(d);
				if (d > targ.max_attack_height)
				{
					dprint(targ.classname);				
					dprint(" can't reach ");
					dprint(attacker.classname);
					dprint(" with missile, fight avoided\n");
					return FALSE;
				}
			}
		}

		//bdw
		targ.monster_fight_time = time + 2;	//time to spend focusing on current attacker
	}

	return TRUE;
};	

/*
============================================================
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.

ben 16/04/03 - optimised && statements
============================================================
*/
//MED 01/10/97 added empathyused variable
float empathyused;
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;   	

	// ben - 26/12/01 - new doom-style gameplay where monsters of the same class cannot hurt each other (or themselves)
	if (attacker.flags & FL_MONSTER)
	{
		if (targ.flags & FL_MONSTER)
		{
			if (targ.classname == attacker.classname)
			{
				if (targ.classname != "monster_army")
				{
					return;
				}
			}
			else if (targ.classname == "monster_shuffler")
				damage = damage * 0.5;	//shufflers take half damage from other monster attacks
		}
	}
	// ben end	

//MED moved damage_attacker down a bit
/*
   dprint("netname = ");
   dprint(attacker.netname);
   dprint(" classname = ");
   dprint(attacker.classname);
   dprint(" classname = ");
   dprint(inflictor.classname);
   dprint("\n");
*/
// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
		damage = damage * 4;


//MED
// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

//MED
// used to keep track of what hit us
   	damage_inflictor = inflictor;

// save damage based on the target's armor level

	save = ceil(targ.armortype*damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = 0;	// lost all armor
      	targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
   	}

	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage-save);

// add to the damage total for clients, which will be sent as a single
// message at the end of the frame
// FIXME: remove after combining shotgun blasts?
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

// figure momentum add
	if (targ.movetype == MOVETYPE_WALK)
	{
		if (inflictor != world)
		{
			dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
			dir = normalize(dir);			
			targ.velocity = targ.velocity + dir*damage*8;
		}
	}

// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

// team play damage avoidance
	if (teamplay == 1) 
		if (targ.team > 0)
			if (targ.team == attacker.team)
				return;

// do the damage
	targ.health = targ.health - take;

	if (targ.health <= 0)
	{		

		Killed (targ, attacker);
		return;
	}

// react to the damage
	oldself = self;
	self = targ;

	if (BDW_CheckForFight(self, attacker))
	{
		if (self.enemy.classname == "player")
			self.oldenemy = self.enemy;
		self.enemy = attacker;
		FoundTarget();
	}	

	if (self.th_pain)
	{
		self.th_pain (attacker, take);
	// nightmare mode monsters don't go into pain frames often
		if (skill == 3)
			self.pain_finished = time + 5;
	}

	self = oldself;
};

/*
============
T_RadiusDamage
============
*/
void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);

	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (inflictor.origin - org);
				if (points < 0)
					points = 0;
				points = damage - points;
				if (head == attacker)
					points = points * 0.5;
				if (points > 0)
				{
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (head.classname == "monster_shambler")
							T_Damage (head, inflictor, attacker, points*0.5);
						else
							T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

/*
============
T_BeamDamage
============
*/
/*
void(entity attacker, float damage) T_BeamDamage =
{
	local	float 	points;
	local	entity	head;

	head = findradius(attacker.origin, damage+40);

	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5*vlen (attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, attacker))
				{
					if (head.classname == "monster_shambler")
						T_Damage (head, attacker, attacker, points*0.5);
					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};
*/


