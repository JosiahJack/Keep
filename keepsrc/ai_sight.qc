/*======================================================================
 AI (monster) FUNCTIONALITY
 
 Visibility checks
 - float(vector org_source, vector org_targ) check_liquidblock
 - float(entity targ) visible
 - float(entity targ, vector s_offset, vector t_offset, float nomonsters) visxray
 - float(entity targ, vector s_offset, vector targang, float nomonsters) visang
 - float(entity targ) visblocked
 - float (entity targ, vector s_ofset, vector t_ofset) visblocked_wide
 - float(entity targ) infront
 
 Distance checks
 - float(entity targ) range
 - float(entity targ, float flat2d) range_distance
 - float (entity source, entity targ) rangeattack_check
 
 Angle checks
 - float(entity source, entity targ, float offset, float reverse) targangle
 - float(entity source, entity targ) targzone

 Hunt & Target Enemies
 - void() HuntTarget
 - void() FoundTarget
 - void(float wakeupothers) FoundHuntTarget
 - float() FindTarget
*/

/*======================================================================
 check_liquidblock
 - Checks pointcontents of source+target because traceline parms
   are not 100% reliable for flagging water/air content
 - One function check for all the different visibility functions
 - Designed to work with the new liquidblock entity flag
======================================================================*/
void() MonsterDeBuff;
float() Ryu_BlockCrossfire;

float(vector org_source, vector org_targ) check_liquidblock = {
	local float pc_source, pc_targ;
	
	// Is r_wateralpha set or monsters forced to check liquid surfaces?
	if (liquid_alpha == 1 || self.liquidblock) {
		// Check point contents first
		pc_source = pointcontents(org_source);
		pc_targ = pointcontents(org_targ);
		if (pc_source != pc_targ) return TRUE; // Are point content different? (like water/air)
		
		if (trace_inopen && trace_inwater) {
			if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM) {
				if (Ryu_BlockCrossfire ()){
					if (vlen(org_targ - org_source) > 120) return FALSE;
				}
			} else {
				return TRUE; // Standard traceline check (not 100% reliable)
			}
		}
	}
	return FALSE; 	// No liquid check required
};

/*======================================================================
 visible (target entity)
 Conditions added to water surface check
 - most maps are compiled with transparent water nowadays
======================================================================*/
float(entity targ) visible = {
	local vector spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	// Debug system (enabled via axe) uses funcs from subs_soc.qc
	// This will draw a diamond model where the AI is looking
	if (self.debuglvl) {
		if (!debugent1) debugent1 = spawn_devmarker(self.origin);
		spot1 = vectoangles(self.origin - trace_endpos);
		makevectors(spot1);
		spot2 = trace_endpos + (v_up * -16) + (v_forward * 50);
		setorigin(debugent1,'0 0 0');
		setorigin(debugent1, spot2);
	}

	// Check for liquid surface block condition
	if (check_liquidblock(spot1, spot2) == TRUE) return FALSE;
	visible_distance = vlen ((trace_endpos - spot1));
	if (trace_fraction == 1) return TRUE;
	return FALSE;
};

/*======================================================================
 visxray (variable options)
  Returns TRUE if there is no blocking, FALSE if something in the way
  Custom options for variable source/target offsets and monster blocking
  (nomonsters) TRUE = no block, FALSE = blocked
  self is excluded from any trace starting points
======================================================================*/
float(entity targ, vector s_offset, vector t_offset, float nomonsters) visxray = {
	local vector spot1, spot2;

	// Bmodels don't have proper origins
	if (self.bsporigin) spot1 = bmodel_origin(self) + s_offset;
	else spot1 = self.origin + s_offset;

	spot2 = targ.origin + t_offset;
	traceline (spot1, spot2, nomonsters, self);	// custom options
	
	// Check for liquid surface block condition
	if (check_liquidblock(spot1, spot2) == TRUE) return FALSE;

	visible_distance = vlen ((trace_endpos - spot1));
	// monster blocking changes which test to use
	if (nomonsters) {
		// Has the traceline gone from source>target without anything blocking?
		if (trace_fraction == 1) return TRUE;
		return FALSE;
	} else {
		// Is the entity hit by the traceline the targ destination?
		if (trace_ent == targ) return TRUE;
		return FALSE;
	}
};

/*======================================================================
 visang (works similar to visxray function)
  The enemy location is based on the source facing angles
  Returns TRUE if there is no blocking, FALSE if something in the way
  Custom options for variable source offsets and monster blocking
  (nomonsters) TRUE = no block, FALSE = blocked
  self is excluded from any trace starting points
======================================================================*/
float(entity targ, vector s_offset, vector targang, float nomonsters) visang = {
	local vector spot1, spot2;

	// Bmodels don't have proper origins
	if (self.bsporigin) spot1 = bmodel_origin(self) + s_offset;
	else spot1 = self.origin + s_offset;

	// Use supplied ang + v_forward for direction
	makevectors(targang);
	spot2 = spot1 + (v_forward * 4096);
	
	// Trace a line using angle vector instead of enemy origin
	traceline (spot1, spot2, nomonsters, self);
	
	// Check for liquid surface block condition
	if (check_liquidblock(spot1, spot2) == TRUE) return FALSE;

	visible_distance = vlen ((trace_endpos - spot1));
	// monster blocking changes which test to use
	if (nomonsters) {
		// Has the traceline gone from source>target without anything blocking?
		if (trace_fraction == 1) return TRUE;
		return FALSE;
	} else {
		// Is the entity hit by the traceline the targ destination?
		if (trace_ent == targ) return TRUE;
		return FALSE;
	}
};

/*======================================================================
 visblocked (target entity)
 check to see if sightline is blocked by other monsters
 Really only used in CheckAttack functions (was in org ID code)
======================================================================*/
float(entity targ) visblocked = {
	local vector spot1, spot2;
	
	if (!targ) return FALSE; // Can't check against the world
	if (targ == self) return FALSE; // Can't block ourself

	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, FALSE, self);	// blocked by monsters

	// Check for liquid surface block condition
	if (check_liquidblock(spot1, spot2) == TRUE) return FALSE;

	visible_distance = vlen ((trace_endpos - spot1));
	// Original ID behaviour for this type of function
	if (trace_ent == targ) return FALSE; // Traceline entity hit = enemy?
	return TRUE;
};

/*======================================================================
 viswide (target entity)
  check to see if sightline is blocked by other monsters
  extra wide check using 3 traces, +/- 16 left/right and origin
  All three traces have to complete for a positive result
======================================================================*/
float (entity targ, vector s_ofset, vector t_ofset) visblocked_wide = {
	local vector spot1, spot2, spot3, tr_line;
	local float tr_leftmon, tr_rightmon, tr_result;

	tr_line = '0 0 0';
	tr_leftmon = tr_rightmon = 0;
	makevectors(self.angles);

	// Traceline 1 - MIDDLE
	spot1 = self.origin + s_ofset_x * v_forward + s_ofset_y * v_right + s_ofset_z * v_up;
	spot2 = targ.origin + t_ofset;
	traceline (spot1, spot2, FALSE, self);

	visible_distance = vlen ((trace_endpos - spot1)); // just set once to middle
	// Is trace entity the same as the target entity?
	if (trace_ent == targ) tr_line_x = 1;
	// Check for liquid surface block condition
	// Only need to do this once for the central traceline
	// If this fails then the left/right should as well
	if (check_liquidblock(spot1, spot2) == TRUE) tr_line_x = 0;

	// Traceline 2 - 32 units LEFT
	spot3 = spot1 - (v_right * 16);
	traceline (spot3, spot2, FALSE, self);
	// Work out if clear shot, hit world or another entity
	if (trace_ent == targ) tr_line_y = 1;
	else if (trace_ent != world) tr_leftmon = 1;

	if (self.debuglvl) {
		if (!debugent2) debugent2 = spawn_devmarker(self.origin);
		setorigin(debugent2, trace_endpos);
	}
		
	// Traceline 3 - 32 units RIGHT
	spot3 = spot1 + (v_right * 16);
	traceline (spot3, spot2, FALSE, self);
	// Work out if clear shot, hit world or another entity
	if (trace_ent == targ) tr_line_z = 1;
	else if (trace_ent != world) tr_rightmon = 1;

	if (self.debuglvl) {
		if (!debugent3) debugent3 = spawn_devmarker(self.origin);
		setorigin(debugent3, trace_endpos);
	}

	// Default = no clear shot (keep aim/moving)
	tr_result = TRUE;
	// SIMPLE 3 complete traces = nothing blocking visibility
	if (tr_line_x + tr_line_y + tr_line_z == 3) tr_result = FALSE;
	// Central trace is good but either side has hit something?
	else if (tr_line_x) {
		// Hit a monster on either side = always fail!
		if (tr_leftmon || tr_rightmon) tr_result = TRUE;
		// The crssbow bolt is fired from the LEFT side, only right can be clear
		else if (self.classtype == CT_MONDCROSS) {
			if (tr_line_y == 0 && tr_line_z == 1) tr_result = FALSE;
		}
		// Default - space available on either side
		else if (tr_line_y + tr_line_z == 1) tr_result = FALSE;
	}

	if (self.debuglvl) {
		dprint("Trace ("); dprint(ftos(tr_line_x));
		dprint(" "); dprint(ftos(tr_line_y));
		dprint(" "); dprint(ftos(tr_line_z));
		dprint(") Ent ("); dprint(ftos(tr_leftmon));
		dprint(" "); dprint(ftos(tr_rightmon));
		dprint(") = ("); dprint(ftos(tr_result));
		dprint(")\n");	
	}

	return tr_result;
};

/*======================================================================
 infront (target entity)
 - relies on self being set correctly before entering this function
 - returns 1 if the entity is in front (in sight) of self
======================================================================*/
float(entity targ) infront = {
	local vector vec, imporg, selforg;
	local float dot, f;
	
	makevectors (self.angles);	// sets v_forward, etc globals
	if (self.flags & FL_CLIENT) makevectors (self.v_angle);

	// Checks for turrets and func based enemies
	imporg = targ.origin;
	if (targ.bsporigin) imporg = bmodel_origin(targ);
	selforg = self.origin;
	if (self.bsporigin) selforg = bmodel_origin(self);

	vec = normalize (imporg - selforg);
	dot = vec * v_forward;

	if (self.fov > 0 && self.fov <= 1) f = self.fov;
	else if (self.fov < 0) {
		self.fov = 0.3; // Not very elegant is it?
		f = self.fov;
	}
	if ( dot > f) return TRUE; // Custom field of view...because monster_wyrm needed it
	else return FALSE;
};

/*======================================================================
 range (target entity)
  returns the range catagorization of an entity reletive to self
  uses constants defined in defs.qc
======================================================================*/
float(entity targ) range = {
	local vector	spot1, spot2;
	local float		r;
		
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen (spot1 - spot2);
	
	if (r < MON_RANGE_MELEE) return RANGE_MELEE;		// <120 = MELEE
	else if (r < MON_RANGE_NEAR) {
		// PM:  Extend melee range for huge monsters like the dragon.
		if (r < (self.maxs_x + targ.maxs_x) * SQRT2 + 30) return RANGE_MELEE; // <120 = MELEE
		else return RANGE_NEAR;							// <500 = NEAR
	}
	else if (r < MON_RANGE_MID) return RANGE_MID;		// <1000 = MID
	return RANGE_FAR;									// >1000 = FAR
};

/*======================================================================
 range_distance (target entity)
 	returns the vector distance between two points
======================================================================*/
float(entity targ, float flat2d) range_distance = {
	local vector spot1, spot2;
	local float r;
		
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	if (flat2d) { spot1_z = spot2_z = 0; }
	r = vlen (spot1 - spot2);
	
	return r;
};

/*======================================================================
 rangeattack_check
  check to see if (source) can get a clear shot at (targ)
  Ignores any water/air content checks
======================================================================*/
float (entity source, entity targ) rangeattack_check = {
	local vector spot1, spot2;
	local float r;

	// origin+offset, otherwise cannot see player up/down slopes
	spot1 = source.origin + source.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen(spot1 - spot2);
	
	// Maximum range attack (was 600 taken from shambler, changed to 1000)
	if (r > MON_RANGE_MID) return FALSE;

	// Monsters without melee should always range anything really close
	if (!source.th_melee && r < MON_RANGE_MELEE) return TRUE;

	traceline (spot1, spot2, FALSE, source);	// trace hits monsters (infighting)
	if (trace_ent != targ) return FALSE;			// don't have a clear shot

	// Does the world define any water transparency
	if (liquid_alpha == 1 || source.liquidblock) {	
		// sight line crossed contents
		if (trace_inopen && trace_inwater) return FALSE;
	}

	return TRUE;
};

/*======================================================================
 targangle
  Returns what angle the target entity is relative to the source entity
  Useful for checking where the player is located.
  source, targ = entity origins to create vector angle
  reverse = the creation of the vector can be reversed
  offset = shift the final angle clockwise. (frontal sight cone 315-45)
======================================================================*/
float(entity source, entity targ, float offset, float reverse) targangle = {
	local float targ_dir, targ_ang;

	// Calculate vector angle between two points (source, target)
	if (reverse) targ_dir = vectoyaw(source.origin - targ.origin);
	else targ_dir = vectoyaw(targ.origin - source.origin);

	targ_ang = anglemod( (source.angles_y - targ_dir) + offset );
	return targ_ang;
};

// Modified version of targangle not using entities but supplied origins
// Targets Y angles needs to be supplied as no entity reference available
float(vector source, vector targ, float offset, float reverse, float dst_ang) viewangle = {
	local float targ_dir, targ_ang;

	// Calculate vector angle between two points (source, target)
	if (reverse) targ_dir = vectoyaw(source - targ);
	else targ_dir = vectoyaw(targ - source);

	targ_ang = anglemod( (dst_ang - targ_dir) + offset );
	return targ_ang;
};

/*======================================================================
 targzone (source entity, target entity)
 - Checks which zone the target enemy is located in relation to source (self)
  0 = Behind (315-45), 1 = Left (45-135), 2 = Front (135-225), Right = (225-315)
======================================================================*/
float(entity source, entity targ) targzone = {
	local float target_ang;
	
	// Work out angle the angle of the player based on the monster (source)
	// Add 45 degree offset to shift clockwise the frontal sight cone
	target_ang = targangle(source, targ, 45, TRUE);

	if (target_ang > 270) return TARGET_RIGHT;
	else if (target_ang > 180) return TARGET_FRONT;
	else if (target_ang > 90) return TARGET_LEFT;
	else return TARGET_BACK;
};

// Reaction Events:
// sight
// near
// hear
// pain

// Sight
// Normal is to only get angry when seeing a player in front of us and nothing blocked

// Near
// Normal is to only get angry when a player is near and no wall in between

// Hear
// Normal is to only hear when ambush flag isn't checked

// Pain
// Normal is to get angry at anything that hurts us so long as the classname is different


// Normal monsters are
	// alignment == EVIL - attack GOOD, but not EVIL
	// temperament == TEMPRA_ANGRY - react on sight, hear, pain, and nearness, if same alignment will attack if not same classgroup
	// vulnerability == VULN_NORMAL - full damage from same alignment monsters

float(entity decider, entity targ) GetAngryOnSight = {
	if (!decider || !targ) return FALSE;
	if (decider.enemy) return FALSE; 	// already have an enemy

	if (decider.alignment == EVIL) {
		if (decider.temperament == TEMPRA_ANGRY) {
			return Align_Opposing(decider,targ);
		} else if (decider.temperament == TEMPRA_COWARDLY) {
			return Align_Opposing(decider,targ);
		} else if (decider.temperament == TEMPRA_PASSIVE) {
			return FALSE;
		} else if (decider.temperament == TEMPRA_CALM) {
			if (targ.alignment == NEUTRAL) return FALSE;
			if (targ.alignment == GOOD) return TRUE;
			if (targ.alignment == EVIL) return FALSE;
		} else if (IsInsane(decider)) {
			return TRUE;
		}
	} else if (decider.alignment == GOOD) {
		if (decider.temperament == TEMPRA_ANGRY) {
			if (targ.alignment == NEUTRAL) return FALSE; // they're not bothering us
			if (Classgroup_Match(decider, targ)) return FALSE; // they're in my faction
			if (Align_Match(decider, targ)) return FALSE; // they're on my team
			return TRUE; // fight fight fight
		} else if (decider.temperament == TEMPRA_COWARDLY) {
			if (targ.alignment == NEUTRAL) return FALSE; // they're not bothering us
			if (Classgroup_Match(decider, targ)) return FALSE; // they're in my faction
			if (Align_Match(decider, targ)) return FALSE; // they're on my team
			return TRUE; // fight fight fight
		} else if (decider.temperament == TEMPRA_PASSIVE) {

		} else if (decider.temperament == TEMPRA_CALM) {

		} else if (IsInsane(decider)) {
			return TRUE;
		}
	} else {
		// We are neutral and don't care.  Much.
	}
	return FALSE;
};

float(entity decider, entity targ) GetAngryOnNear = {
	if (!decider || !targ) return FALSE;
	if (decider.enemy) return FALSE; 	// already have an enemy

	if (decider.alignment == NEUTRAL) return FALSE;
	
	if (decider.temperament == TEMPRA_ANGRY) {
		
	} else if (decider.temperament == TEMPRA_COWARDLY) {

	} else if (decider.temperament == TEMPRA_PASSIVE) {

	} else if (decider.temperament == TEMPRA_CALM) {

	} else if (IsInsane(decider)) {
		return TRUE;
	}
	return FALSE;
};

float(entity decider, entity targ) GetAngryOnHear = {
	if (!decider || !targ) return FALSE;
	if (decider.enemy) return FALSE; 	// already have an enemy

	if (decider.alignment == EVIL) {
		if (decider.temperament == TEMPRA_ANGRY) {
			return Align_Opposing(decider,targ);
		} else if (decider.temperament == TEMPRA_COWARDLY) {
			return Align_Opposing(decider,targ);
		} else if (decider.temperament == TEMPRA_PASSIVE) {
			return FALSE;
		} else if (decider.temperament == TEMPRA_CALM) {
			return Align_Opposing(decider,targ);
		} else if (IsInsane(decider)) {
			return TRUE;
		}
	} else if (decider.alignment == GOOD) {
		if (decider.temperament == TEMPRA_ANGRY) {
			if (targ.alignment == NEUTRAL) return FALSE; // they're not bothering us
			if (Classgroup_Match(decider, targ)) return FALSE; // they're in my faction
			if (Align_Match(decider, targ)) return FALSE; // they're on my team
			return TRUE; // fight fight fight
		} else if (decider.temperament == TEMPRA_COWARDLY) {
			if (targ.alignment == NEUTRAL) return FALSE; // they're not bothering us
			if (Classgroup_Match(decider, targ)) return FALSE; // they're in my faction
			if (Align_Match(decider, targ)) return FALSE; // they're on my team
			return TRUE; // fight fight fight
		} else if (decider.temperament == TEMPRA_PASSIVE) {

		} else if (decider.temperament == TEMPRA_CALM) {

		} else if (IsInsane(decider)) {
			return TRUE;
		}
	} else {
		// We are neutral and don't care.  Much.
	}
	return FALSE;
};

float(entity decider, entity targ) GetAngryOnPain = {
	if (targ.classname != decider.classname) return TRUE; // Normal
	if (targ.classtype != decider.classtype) return TRUE;
	if (Align_Opposing(decider,targ)) return TRUE;
	if (targ.enemy == decider) return TRUE;
	return FALSE;
};

void () polyp_wake1_prethink;

/*======================================================================
 HuntTarget
  Go into main routine - constantly running/turning towards the enemy
======================================================================*/
void() HuntTarget = {
	if (self.health < 1) return; // Dead monsters don't hunt!

	self.oldorigin = self.origin; // Save origin
	self.goalentity = self.enemy; // Focus on enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1; // Some monsters have special wakeup animations before attacking
	if (self.classtype == CT_MONPOLYP && self.startonground == 1) {
		self.think = polyp_wake1_prethink;
	} else {
		self.think = self.th_run; // Start running
	}

	// Default 1s wait (NM adjusted) before attacking
	if (self.ryuflags & RYU_ALERT)
		SUB_AttackFinished (0.5);   // alert monsters don't wait as long...
	else
		if (!self.attack_instant) SUB_AttackFinished (1); // wait a while before first attack	
};

/*======================================================================
 FoundTarget
 - An enemy target has been found, wakeup and hunt target
 - Used by FindTarget once an enemy target has been found
 - used by T_Damage (combat.qc) for infighting
======================================================================*/
void() FoundTarget = {
	if (self.health < 1) return FALSE;	// Dead monsters don't hunt!

	// Check for Liquid surface block entity key if the monster has range attack, can NOW see through liquid surface
	if (self.liquidblock == TRUE && self.th_missile) self.liquidblock = FALSE;

	if ( self.charmed ) {
		if ( ((self.charmer == self.enemy) || (self.charmer == self.enemy.charmer)) && !(IsInsane(self))) {
			self.enemy = world;
			return;
		}
	}

	// If current enemy is alive and can take damage then wakeup the rest of the groupsight group using global entity
	if (self.sightgroup != "") {
		if (self.enemy.health > 0 && self.enemy.takedamage > DAMAGE_NO) {
			sightgroup_entity = self;		// Highlight target for others
			sightgroup_entity_time = time;	// reset wakeup timer
			if (self.enemy.flags & FL_CLIENT) monster_sightsound();
			HuntTarget ();					// Keep running after enemy
			return;
		}
	} else {
		// DEFAULT wakeup method for all monsters
		if ( (self.enemy.flags & FLx_CREATURE) ) {
			sight_entity = self;			// Highlight an angry monster for others
			sight_entity_time = time;		// reset wakeup timer
		} // else, we don't stay angry at non monster or non player!
	}
	
	//----------------------------------------------------------------------
	// This will cause a group of monsters to all attack the same target
	// Using the global sight enemy system which works with FindTarget()
	// Always check for an empty sighttarget first because the
	// the global sight entity could have an empty targetname
	//----------------------------------------------------------------------
	if (self.sighttarget != "") {
		if (self.enemy.targetname == self.sighttarget) {
			// Make sure the sight target is alive before chasing it
			self.oldenemy = find(world, targetname, self.sighttarget);
			if (self.oldenemy.health > 0) {
				if (self.oldenemy.takedamage > DAMAGE_NO) {
					sight_entity = self.enemy;		// Highlight target for others
					sight_entity_time = time;		// Reset wakeup timer
					monster_sightsound();			// Always make wakeup noise!
				}
			}
			self.oldenemy = world;
		}
	}
	
	self.show_hostile = time + 1;		// Wake up other monsters
	monster_sightsound();				// Make sight sound regardless of who hit us
	HuntTarget ();						// Keep running after enemy
};

/*======================================================================
 FoundHuntTarget
 - This is a combination of FoundTarget and HuntTarget
 - Does not do any sight sound, needs to be done outside this func
 - Does not pause or wait for any monster, straight to combat
 - Has no end funtion state, can decide this afterwards
======================================================================*/
void(float wakeupothers) FoundHuntTarget = {
	if (self.health < 1) return;	// Dead monsters don't hunt!
	if (!self.enemy) return;

	// Passive mode active and about to switch state?
	if (check_passivestate_switch(self)) return;

	// Check for Liquid surface block entity key
	// if the monster has range attack, can NOW see through liquid surface
	if (self.liquidblock == TRUE && self.th_missile) self.liquidblock = FALSE;

	if (self.enemy.flags & FL_CLIENT && wakeupothers == TRUE) {
		if (self.charmed) {
			if ((self.charmer == self.enemy) || (self.charmer == self.enemy.charmer)) {
				self.enemy = world;
				return;
			}
		}
		sight_entity = self;			// Highlight an angry monster for others
		sight_entity_time = time;		// reset wakeup timer
	}
	
	self.show_hostile = time + 1;		// wake up other monsters
	self.oldorigin = self.origin;		// Save origin
	self.goalentity = self.enemy;		// Focus on enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);

	// Default 1s wait (NM adjusted) before attacking
	if (self.ryuflags & RYU_ALERT)
		SUB_AttackFinished (0.5);   // alert monsters don't wait as long...
	else
		if (!self.attack_instant) SUB_AttackFinished (1); // wait a while before first attack
};

entity() SeeOpposing = {
	local float dist;
	local entity selected, head;

	if (self.alignment == NEUTRAL && !(IsInsane(self))) return FALSE; // I don't care

	selected = world;
	if (self.horn_active) dist = CHARMED_RADIUS; // Shorter sight to keep closer to player who summoned us, maybe
	else dist = MON_MAX_RANGE; // NORMAL SIGHT

	if (self.enemymaxdist == TRUE || self.attack_sniper) dist = 8192; // yikes
	head = findradius (self.origin,dist);
	while (head) {
		if ((!(head.flags & FL_NOTARGET) && (head.flags & FLx_CREATURE) && head.invisible_finished < time)) {
			if ( ((visible (head)) && (head.health > FALSE)) ) {
				if (!Align_Match(self,head) || IsInsane(self)){
					if (head.alignment != NEUTRAL) selected = head; 
				}
			}
		}
		head = head.chain;
	}
	return selected;
};

entity() SeeFriendly = {
	local float dist;
	local entity selected, head;

	if (self.alignment == NEUTRAL && !(IsInsane(self))) return FALSE; // I careth not

	selected = world;
	if (self.horn_active && self.charmer) return world; // Already have a leader to follow
	dist = MON_MAX_RANGE; // NORMAL SIGHT

	if (self.enemymaxdist == TRUE || self.attack_sniper) dist = 8192; // yikes
	head = findradius (self.origin,dist);
	while (head) {
		if ((!(head.flags & FL_NOTARGET) && (head.flags & FLx_CREATURE) && head.invisible_finished < time)) {
			if ( ((visible (head)) && (head.health > FALSE)) ) {
				if (Align_Match(self,head) || IsInsane(self)) {
					if (head.alignment != NEUTRAL) selected = head;
				}
			}
		}
		head = head.chain;
	}
	return selected;
};

/*======================================================================
 FindTarget
 - Main routine for finding a target
 - Returns TRUE if an enemy was sighted
======================================================================*/
float() FindTarget = {
	local entity client, selected, head;
	local float r, dist, charmdist,charmmaxdist, charmrand;

	if (self.health < 1) return FALSE;	// Dead monsters don't hunt!
	if (intermission_running > 0) return FALSE; // If intermission is running, no sight checks
	if ((cinematic_running > 0 || cutscene > 0) && !coop) return FALSE; // If cinematic is running in singleplayer, no sight checks

	// Wraith AI - - - -
    if (self.movetype == MOVETYPE_NOCLIP) {  // Most monsters aren't wraiths.
        if (pointcontents (self.origin + self.view_ofs) == CONTENT_SOLID) return FALSE;   // Don't let wraiths see targets while in the wall.
	}

	MonsterDeBuff();

	self.enemyexit = FALSE; // Reset any combat exit conditions

	// All following monsters (could be evil) such as Horn of Conjouring monsters (always friendly to the player who summoned them)
	if (self.charmed) {
		if (self.horn_active) self.effects = (self.effects | EF_DIMLIGHT); // Horn summon player followers are always lit regardless of other effects and shields
		if ( (self.huntingcharmer > FALSE) ) {
			UpdateCharmerGoal(); // Move our goal point to be 300units towards our charmer's position, goes past when close
			r = vlen ((self.origin - self.goalentity.origin));
			if ( (r < MIN_CHARMER_DISTANCE) ) {
				if ( ((self.huntingcharmer == MOVETYPE_WALK) && (r > TOOCLOSE_CHARMER_DISTANCE)) ) return FALSE; // 120units or closer to our charmer
				StopHuntingCharmer (); // Stay put, we're at our charmer's heels, remove goal point
				return TRUE;
			}
		} else {
			charmmaxdist = MAX_CHARMER_DISTANCE;
			charmrand = random();
			if (self.temperament == TEMPRA_COWARDLY && charmrand < 0.1) charmmaxdist = 512;
			if ( (vlen ((self.origin - self.charmer.origin)) > MAX_CHARMER_DISTANCE) ) {
				HuntCharmer ();
				return FALSE;
			} else {
				charmdist = TOOCLOSE_CHARMER_DISTANCE;
				if (self.temperament == TEMPRA_COWARDLY && charmrand < 0.1) charmdist = 384;
 				if ( (vlen ((self.origin - self.charmer.origin)) < charmdist) ) { // 120units or closer to our charmer
					FleeCharmer (); // Get out of our charmer's way
					return FALSE;
				}
 			}
		}
	}

	// SIGHT TARGET CHECK Does the global sight entity match the enemy sight group? Check for an empty sighttarget first because global sight entity could have an empty targetname
	if (self.sighttarget != "" && !self.charmed) {
		if (sight_entity.targetname == self.sighttarget) {
			// Make sure the sight target is alive before chasing it
			if (sight_entity.health < 0) self.sighttarget = "";
			else {
				// If using enemytarget system, switch off tracking entity first
				if (self.enemy.classtype == CT_ENEMYTARGET) SUB_switchEnemyTarget();
				self.enemy = sight_entity;	// Switch to new enemy
				self.passive_state = 0;
				FoundTarget ();				// Run+turn towards new enemy
				return TRUE;
			}
		}
	}

	// SIGHT GROUP CHECK
	// This is designed to co-ordination wakeup and attack as a group.  Check the gobal entity has the same sightgroup string (trigger)
	// sightgroup + NO Ambush = ALL wake up when sight of combat/fire/player
	// sightgroup + Ambush = All wake up when sight of player
	// sightgroup + passive + No Ambush = All wake up sight of combat/fire
	// sightgroup + passive + Ambush = All wake up with direct damage ONLY
	if (self.sightgroup != "" && !self.charmed) {
		// Let ambush still override wakeup (ambush=req direct damage)
		if (sightgroup_entity_time >= time - 0.1) {
			if (self.sightgroup == sightgroup_entity.sightgroup) {
				self.enemy = sightgroup_entity.enemy;	// Monster who wokeup
				self.passive_state = MON_PASSIVESTATE_OFF;
				FoundTarget ();							// Run+turn at new enemy
				return TRUE;
			}
		}
	}

	// PASSIVE SYSTEM CHECK
	// passive_state + NO ambush = wake up when sight of combat/fire, unless cowardly or passive temperament
	// passive_state + Ambush = wake up from direct damage ONLY
	if (check_passivestate_switch(self)) return FALSE;

	// if the first spawnflag bit is set, the monster will only wake up on
	// really seeing the player, not another monster getting angry
	// Zombies had their ambush/crucified spawnflag mix up fixed, fixed in mon_zombie.qc
	// sight_entity is assigned to self by a monster getting angry
	// sight_entity_time is also set at the same time
	if ((sight_entity_time >= (time - 0.1)) && !(self.spawnflags & MON_AMBUSH) && Align_Opposing(self,sight_entity)) {
		client = sight_entity;		// Global variable, angry monster nearby
		if (client.enemy == self.enemy) return TRUE; // we were already angry at this thing? get outta here
	} else {
		client = SeeOpposing(); // check for enemies before finding a leader
		if (!client) {
			if (!self.charmer) { // already have a leader to follow
				if (self.temperament == TEMPRA_COWARDLY || self.temperament == TEMPRA_CALM || self.relations >= 3) { // Find a leader
					client = SeeFriendly(); // hey buddy!
					if (!client) return FALSE; // didna see nobody
					if (!(IsLeader(client))) return FALSE; // Not a leader
					self.charmer = client;
					self.charmed = TRUE;
					self.goalentity = self.movetarget = self.charmer;
					self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
					self.nextthink = time + 0.1 + random()*0.5;
					self.think = self.th_walk;
					return TRUE;
				} else {
					return FALSE; // Nothin to see here
				}
			}
		}
	}
	
	if (client == self.enemy) return FALSE; // if we assigned to a nearby angry monster sight_entity above, we'd never be here if this if were true, FYI
	enemy_range = range (client);

	if (!self.charmed) {
		if ( (enemy_range == RANGE_NEAR) ) {
			if ( ((client.show_hostile < time) && !infront (client)) ) {
				return ( FALSE );
			}
		} else {
			if ( (enemy_range == RANGE_MID) ) {
				if ( !infront (client) ) {
					return ( FALSE );
				}
			}
		}
	}
	// dprint("Infront or close!\n");

	// The only two things that alert monsters when invisible besides damage: firing a weapon or bumping into a dog
	if (client.items & IT_INVISIBILITY) {
		if (self.classtype == CT_MONDOG && client.flags & FL_CLIENT) {
			if (enemy_range != RANGE_MELEE) return FALSE; // Not close enough to sniff us out
		} else if (client.show_hostile < time) {
			return FALSE; // Too quiet to hear
		}
	}

	self.enemy = client; // Alright, let's do this!

	// Boss specific functionality, merged from bosses' special custom FindTarget functions:
	if (self.classtype == CT_MONEIDOLON) {
		if (self.style == EIDOLON_PHASE1) return FALSE; // Stage 1 is trapped, boss cannot attack or run
	}

	if (self.charmed) self.passive_state = FALSE; // Temporarily get angry.  DON'T CHANGE passive_mode, WE NEED TO REMEMBER THAT IF OUR ENEMY DIES!		
	FoundTarget ();			// Run+turn towards new enemy
	return TRUE;			// stop previous routine got a target
};