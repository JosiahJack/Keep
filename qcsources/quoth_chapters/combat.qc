.float		activated_time; //necros: to keep monsters from getting angry at too many different monsters at once.

//void() GauntSwitchTarget;

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
		self.th_die ();
		self = oself;
		return;
	}

	self.enemy = attacker;

// bump the monster counter
	if (self.flags & FL_MONSTER)
	{
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}

	ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();
	
	self = oself;
};

void() PolypFoundTarget;

/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage=
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;

	if (!targ.takedamage)
		return;

	//bprint (ftos(damage));
	//bprint ("\n");
// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
		damage = damage * 4;

	if (targ.classname == "monster_death_lord" && targ.shield == 1)
		damage = damage * 0.5;

	/*
	if (targ.classname == "monster_death_lord")
	{
		bprint (ftos(damage));
		bprint ("\n");
	}
	*/ //bit of testing stuff here...
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

	if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir*damage*8;
	}


	if (targ.invincible_finished >= time && attacker.classname != "trigger_void")  //still kill the player if he falls in void with pent
	{
		if (self.invincible_sound < time)
		{
			sound (targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + 2;
		}
		return;
	}

	if (targ.cross_finished >= time && attacker.classname != "trigger_void")  //still kill the player if he falls in void with cross
	{
		take = take * 0.5;

		if (self.cross_sound < time)
		{
			sound (targ, CHAN_ITEM, "items2/crosuse.wav", 1, ATTN_NORM);
			self.cross_sound = time + 0.5;
		}
	}


// check for godmode or invincibility
	if (targ.flags & FL_GODMODE)
		return;



// team play damage avoidance
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
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

	if ( (self.flags & FL_MONSTER) && attacker != world)
	{
	// get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy)
		{
			if ((self.classname != attacker.classname) || (self.classname == "monster_army") || (self.classname == "monster_cyaegha") )
			{
				if ( 
				      (self.class != attacker.class || (self.class == "" && attacker.class == "") ) 
				   && ( 
				      ( (self.activated_time < time && attacker.classname == "player" && self.enemy.classname == "player") )
				   || ( (self.activated_time < time && attacker.flags & FL_MONSTER && self.enemy.flags & FL_MONSTER) )
				   || ( !(attacker.flags & FL_MONSTER) && self.enemy.flags & FL_MONSTER))  
				   || ( (attacker.flags & FL_MONSTER) && !(self.enemy.flags & FL_MONSTER) ) 
				   )
				{
					
						if (self.enemy.classname == "player")
							self.oldenemy = self.enemy;

						if (self.classname == "monster_cyaegha")
							self.activated_time = time + 20;
						else if (self.classname == "monster_vermis")
							self.activated_time = time + 10;
						else if (self.classname == "monster_gug")
							self.activated_time = time + 7;
						else
							self.activated_time = time + 5;
						self.enemy = attacker;
					
						if (self.classname == "monster_polyp" && self.startonground == 1)
							PolypFoundTarget();
						//else if (self.classname == "monster_gaunt" && self.carry)
						//	GauntSwitchTarget();
						else
							FoundTarget();
						
							
					
				}
				if (self.enemy == world)
				{
						if (self.enemy.classname == "player")
							self.oldenemy = self.enemy;

						if (self.classname == "monster_cyaegha")
							self.activated_time = time + 20;
						else if (self.classname == "monster_vermis")
							self.activated_time = time + 10;
						else if (self.classname == "monster_gug")
							self.activated_time = time + 7;
						else
							self.activated_time = time + 5;
						self.enemy = attacker;
					
						if (self.classname == "monster_polyp" && self.startonground == 1)
							PolypFoundTarget();
						//else if (self.classname == "monster_gaunt" && self.carry)
						//	GauntSwitchTarget();
						else
							FoundTarget();		
				}
				/*
				if ( (self.class != attacker.class || (self.class == "" && attacker.class == "") ) 
				   && (self.enemy.health <= 0))
				{
					
						if (self.enemy.classname == "player")
							self.oldenemy = self.enemy;

						if (self.classname == "monster_cyaegha")
							self.activated_time = time + 20;
						else if (self.classname == "monster_vermis")
							self.activated_time = time + 10;
						else if (self.classname == "monster_gug")
							self.activated_time = time + 7;
						else
							self.activated_time = time + 5;
					
						if (self.classname == "monster_polyp" && self.startonground == 1)
							PolypFoundTarget();
						else
							FoundTarget();
						
							
					
				}*/
			}
		}
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
	local	vector	dir;
	
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
						if (!(head.cross_finished >= time))
						{
							if (head.classname == "monster_shambler")						
								T_Damage (head, inflictor, attacker, points*0.5);
							else
								T_Damage (head, inflictor, attacker, points);
						}
						if (head.cross_finished >= time && head.classname == "player")
						{
							if (self.cross_sound < time)
							{
								sound (self, CHAN_ITEM, "items2/crosuse.wav", 1, ATTN_NORM);
								self.cross_sound = time + 0.5;
							}
							dir = head.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
							dir = normalize(dir);
							head.velocity = head.velocity + dir*points*8;
						}



					}
				}
			}
		}
		head = head.chain;
	}
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_WeakRadiusDamage =
{
	local	float 	points;
	local	entity	head;
	local	vector	org;
	local	vector	dir;

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
					points = points * 0.4 + 6;
					if (CanDamage (head, inflictor))
					{	// shambler takes half damage from all explosions
						if (!(head.cross_finished >= time))
						{
							if (head.classname == "monster_shambler")						
								T_Damage (head, inflictor, attacker, points*0.5);
							else
								T_Damage (head, inflictor, attacker, points);
						}
						if (head.cross_finished >= time && head.classname == "player")
						{
							if (self.cross_sound < time)
							{
								sound (self, CHAN_ITEM, "items2/crosuse.wav", 1, ATTN_NORM);
								self.cross_sound = time + 0.5;
							}
							dir = head.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
							dir = normalize(dir);
							head.velocity = head.velocity + dir*points*8;
						}
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

