
void() T_MissileTouch;
void() info_player_start;
void(entity targ, entity attacker) ClientObituary;
void() execute_changelevel;

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
	local float i;
	i = cvar("temp1");

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
//----------------------------------------------------/ Code Change /-----//
// SoE: diked a check for PM_CountMonster(self)
		killed_monsters = killed_monsters + 1;
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);

// SoE: DMSP support starts
		if (serverflags & 16 || i == 1)
		{

/*	FC: Here I'd like something more sensible: Monsters killed by the world *don't* get
	credited to you :P */

/*	In DM game, get a frag for monsters *you* kill */
			if (attacker.classname == "player")
				attacker.frags = attacker.frags + 1;

	    	  	local entity o; //aard
     		local float n;
			local string nstring; // FC

			if((killed_monsters >= total_monsters) && totalmonsterspawn < 1) 
			{
				o = spawn();
		    		o.think = execute_changelevel;
			    	o.nextthink = time + 0.1;
	    		}
	    		n = totalmonsterspawn + total_monsters - killed_monsters;
			nstring = ftos(n);
			if (attacker.classname == "player")
			{
			    if(n == 1)
				{
					sprint (attacker, "There is only one left...\n");
				}
				else if ((n == 50) || (n == 40) || (n == 30) || (n == 20) || (n > 1 && n < 11))
				{
					sprint (attacker, "There are ");
					sprint (attacker, nstring);
					sprint (attacker, " more to go...\n");
				}		 
			}
		}

//------------------------------------------------------------------------//

	ClientObituary(self, attacker);
	
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();
	
//----------------------------------------------------/ New Code /--------//
    // Pet dragons die with their master.
    if (self.classname == "player")
        PM_KillAllPets (self, FALSE);
//------------------------------------------------------------------------//

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
//----------------------------------------------------/ Code Change /-----//
    // If player's dragon made the shot, show all messages to the player.
    if (attacker.master.classname == "player")
        damage_attacker = attacker.master;
    else
        damage_attacker = attacker;
//------------------------------------------------------------------------//

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
//----------------------------------------------------/ Code Change /-----//
        if (PM_EntIsPlayer (self.master))
        {
            // Dragons owned by players need special coding.

            // Special:  If attacked by bloodcube, hide until it goes away.
            if (inflictor.classname == "BloodCube")
                if (self.health > COST_PET_TELEPORT)
                {
                    self.health = self.health - COST_PET_TELEPORT;
                    PM_PetCubeReact (self, inflictor);
                    self = oldself;
                    return;
                }

            // Do normal reactions for familiars.
            PM_PetPainReact (self, attacker);
        }
        else
        {
            // Player does not control this monster.
            if (PM_GetMad (self, attacker))
                PM_NewEnemy (attacker);
        }
//------------------------------------------------------------------------//
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
//----------------------------------------------------/ Code Change /-----//
                    {
                        if (PM_BlastResistant (head))
                            points = points * 0.5;
                        T_Damage (head, inflictor, attacker, points);
					}
//------------------------------------------------------------------------//
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

