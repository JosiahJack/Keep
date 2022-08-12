
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

// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;

// check for quad damage powerup on the attacker
	if (attacker.super_damage_finished > time)
		damage = damage * 4;

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
	if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
		return;
		
// do the damage
	if (targ.classname == "monster_hell_knight2")
	{
		if ((targ.enemy == world) || (inflictor.model == "progs/missile.mdl"))  	// when shot from unseen inflictor !  ( => Did not see inflicter/player)   Warlord can not dodge rockets, only grenades !
			targ.health = targ.health - take;
		else if (targ.dodge_finished < time)			// chance to dodge
		{
			local float dodge;
			dodge = autocvar_warlord_dodge_chance * 0.01;
			if (random () > dodge)				// checks if Warlord resists this attack and dodge
				targ.health = targ.health - take;
			else
			{
				targ.dodge_finished = time + 1.2;		// finetune invulnerable/dodging time !
				targ.dodging = 1;
			}
		}	
	}	
	else if (targ.classname == "monster_enforcer")
	{
		if (targ.enemy == world)  				// when shot from unseen inflictor !  ( => Did not see inflicter/player)  
			targ.health = targ.health - take;
		else if (targ.dodge_finished < time)			// chance to dodge
		{
			local float shield;
			shield = autocvar_enforcer_shield_chance * 0.01;
			if (random () > shield)				// checks if Enforcer enables shield and blocks attack
				targ.health = targ.health - take;
			else
				targ.dodge_finished = time + autocvar_enforcer_shield_lifetime + random();
		}
	}
	else if (targ.classname == "monster_reiver")
	{
		if (targ.enemy == world)  				// when shot from unseen inflictor !  ( => Did not see inflicter/player)  
			targ.health = targ.health - take;
		else if (targ.dodge_finished < time)			// chance to dodge
		{
			local float multi_shield;
			multi_shield = autocvar_reiver_multi_shield_chance * 0.01;
			if ((random () < multi_shield) && (!targ.meleeing))	// checks if Reiver enables his multi_shield and blocks attack. multi_shields cannot be spawned when he is in melee fight
				targ.dodge_finished = time + autocvar_reiver_multi_shield_lifetime + random();
			else
				targ.health = targ.health - take;
		}
	}
	else if (!targ.in_cocoon_shape)	
	{
		targ.health = targ.health - take;
		if (targ.classname == "monster_zombie")		// for painskin feature
			targ.painskin_helper = 1;		// "1" is zombie
	}

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
			// Afrits will never make other monsters mad and begin to attack, nor they ever become mad themself from other monster attacks.
			if ( ((self.classname != attacker.classname) || (self.classname == "monster_army" )) && (((attacker.classname != "monster_afrit") && (self.classname != "monster_afrit")) || ((attacker.classname == "player") && (self.classname == "monster_afrit"))) )
			{
				if (self.enemy.classname == "player")
					self.oldenemy = self.enemy;
				self.enemy = attacker;
				FoundTarget ();
			}
		}
	}

	if (self.th_pain)
	{
		if ((random () > (autocvar_monster_skip_pain_animation_chance * 0.01)) || (self.classname == "player"))
		{
		    	self.tactic = 0;
			self.th_pain (attacker, take);
		// nightmare mode monsters don't go into pain frames often
			if ((skill == 3) && (self.classname != "player"))
				self.pain_finished = time + 5;	
		}	
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

////  added GYRO below

	local entity	explo;
	explo = Gyro_Force_Create("explosion", inflictor.origin);
	Gyro_Force_ApplyFalloff_AreaQuadratic(explo, '4 4 4' * damage);
	Gyro_Force_ApplyAffector_Point(explo, '0 0 -24', '1 1 1', damage* 7, FALSE);
	Gyro_Force_AddProperty_Instant(explo);
	Gyro_Force_AddProperty_AirOnly(explo);
	
	explo = Gyro_Force_Create("explosion", inflictor.origin);
	Gyro_Force_ApplyFalloff_AreaLinear(explo, '2 2 2' * damage);
	Gyro_Force_ApplyAffector_Point(explo, '0 0 -24', '1 1 1', damage* 3.5, FALSE);
	Gyro_Force_AddProperty_Instant(explo);
	Gyro_Force_AddProperty_WaterOnly(explo);


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


/*
===============
Player bleeding
===============
*/

void(entity org) Bleeding1 =		// called when health is between 21 and 40
{
if (org.velocity == 0)
	return;
pointparticles(particleeffectnum("TE_BLEED1"), org.origin + org.view_ofs + v_up * -20, org.velocity*0.7, 1); //+ v_forward
};

void(entity org) Bleeding2 =		// called when health is between 1 and 20
{
if (org.velocity == 0)
	return;
pointparticles(particleeffectnum("TE_BLEED2"), org.origin + org.view_ofs + v_up * -20, org.velocity*0.7, 1); // + v_forward
};

void(entity org) Bleedingnull =	// dont bleed
{
pointparticles(particleeffectnum("TE_BLEEDNULL"), org.origin, '0 0 0', 1);
};
