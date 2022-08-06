
/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<

TRIGGER FUNCTIONS

self.triggerfunction will be called inside SUB_UseTargets, giving you
the option of doing extra stuff besides just calling use() on all your
targets.

it is delayed by self.delay, and thus should not reference any of the
targetn/delayn fields, which are always dealt with first, independantly 
of self.delay.

It is valid to change 	self.target, 
						self.killtarget,
						self.message, 
						self.triggerconsole,
						
inside a triggerfunction (typically to null them out), to influence the
rest of the SUB_UseTargets behaviour. See TF_RemoveNoGuideFlag, for an
example of nulling out self.target to prevent the trigger from then calling
the use() functions for its targets.

~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>*/
void() SUB_Remove;

void() TF_RemoveNoGuideFlag =
{
	local entity e;
	
	if (self.target == "")
		return;	
		
	e = find(world, targetname, self.target);	

	while(e)
	{
		if (e.flags & FL_MONSTER)
			e.spawnflags = e.spawnflags - (e.spawnflags & M_NOGUIDE);

		e = find(e, targetname, self.target);
	}	
	
	self.target = "";	//don't use targets after this
};

void() BDW_CorpseRemoveStart;
void() TF_PurgeCorpses =
{
	local entity head;
	local float h_count;
	
	if (gameflags1 & GF1_CORPSE_STAY)	//all corpses remain
	{
		dprint("corpse stay enabled, no corpses purged\n");
		return;
	}

	head = nextent(world);

	while (head)
	{
		if (head.flags & FL_MONSTER)
		if (head.health <= 0)				
		if (!(head.spawnflags & M_REMOVECORPSE))	//already fading, leave alone
		{			
			head.spawnflags = head.spawnflags + M_REMOVECORPSE;

			if (head.deadflag == DEAD_DEAD)	//inert corpse
			{
				head.nextthink = time + 5 + random()*5;
				head.think = BDW_CorpseRemoveStart;
			}

			h_count = h_count + 1;
		}

		head = nextent(head);
	}

	dprint("TF_PurgeCorpses: ");
	dprint(ftos(h_count));
	dprint(" corpses purged\n");
};


//Bastion compatibility, remove at some point...
void() BDW_PurgeCorpses =
{
	TF_PurgeCorpses();
}





float() BDW_Check_idMapName =
{
	if (world.model == "maps/start.bsp")
		return TRUE;
	if (world.model == "maps/e1m1.bsp")
		return TRUE;
	if (world.model == "maps/e1m2.bsp")
		return TRUE;
	if (world.model == "maps/e1m3.bsp")
		return TRUE;	
	if (world.model == "maps/e1m4.bsp")
		return TRUE;
	if (world.model == "maps/e1m5.bsp")
		return TRUE;
	if (world.model == "maps/e1m6.bsp")
		return TRUE;	
	if (world.model == "maps/e1m7.bsp")
		return TRUE;	
	if (world.model == "maps/e1m8.bsp")
		return TRUE;
	if (world.model == "maps/e2m1.bsp")
		return TRUE;
	if (world.model == "maps/e2m2.bsp")
		return TRUE;
	if (world.model == "maps/e2m3.bsp")
		return TRUE;	
	if (world.model == "maps/e2m4.bsp")
		return TRUE;
	if (world.model == "maps/e2m5.bsp")
		return TRUE;
	if (world.model == "maps/e2m6.bsp")
		return TRUE;	
	if (world.model == "maps/e2m7.bsp")
		return TRUE;	
	if (world.model == "maps/e3m1.bsp")
		return TRUE;
	if (world.model == "maps/e3m2.bsp")
		return TRUE;
	if (world.model == "maps/e3m3.bsp")
		return TRUE;	
	if (world.model == "maps/e3m4.bsp")
		return TRUE;
	if (world.model == "maps/e3m5.bsp")
		return TRUE;
	if (world.model == "maps/e3m6.bsp")
		return TRUE;	
	if (world.model == "maps/e3m7.bsp")
		return TRUE;	
	if (world.model == "maps/e4m1.bsp")
		return TRUE;
	if (world.model == "maps/e4m2.bsp")
		return TRUE;
	if (world.model == "maps/e4m3.bsp")
		return TRUE;	
	if (world.model == "maps/e4m4.bsp")
		return TRUE;
	if (world.model == "maps/e4m5.bsp")
		return TRUE;
	if (world.model == "maps/e4m6.bsp")
		return TRUE;	
	if (world.model == "maps/e4m7.bsp")
		return TRUE;	
	if (world.model == "maps/e4m8.bsp")
		return TRUE;
	if (world.model == "maps/end.bsp")
		return TRUE;
		
	return FALSE;
};	

/*
====================================================
BDW_TouchRemove 07/12/2004

This allows you to remove all entities directly
inside touch functions. SOLID_TRIGGER and SOLID_BSP
entities are added to trigger and clipping lists -
if you just remove these entities directly in a 
touch function, you can mess things up.
====================================================
*/

void(entity e) BDW_TouchRemove =
{
	e.solid = SOLID_NOT;
	setorigin(e, e.origin);
	remove(e);
};

/*
====================================================
BDW_DelayedRemove

This is a hack that prevents unwanted sprite frame
interpolation in DarkPlaces. It appears that a newly
spawned sprite will try to interpolate from the last
frame of the previous edict (whose slot it now fills).
====================================================
*/

void() BDW_DelayedRemove =
{
	self.model = "";
	self.modelindex = 0;
	self.frame = 0;	
	self.skin = 0;
	self.colormap = 0;
	self.effects = 0;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.angles = VEC_ORIGIN;
	self.origin = VEC_ORIGIN;

	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

/*
====================================================
BDW_CorpseRemove 03/04/04

A routine that fades a monster corpse before removal 
====================================================
*/
void() BDW_CorpseRemoveThink =
{	
	self.origin_z = self.origin_z - (20*frametime);	
	if (self.origin_z < (self.height - 24))
	{
		remove(self);
		return;
	}

	self.think = BDW_CorpseRemoveThink;
	self.nextthink = 1;	// next frame
};

void() BDW_CorpseRemoveStart =
{
	if (!(self.flags & FL_ONGROUND) )
	{
			remove(self);
			return;
	}

	self.monsterflags = self.monsterflags | MF_FADING;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;	//should already be non-solid, but this makes sure
	self.height = self.origin_z;	//for non-alpha "fall into ground" removal
	BDW_CorpseRemoveThink();
};

void() BDW_CorpseRemove =
{
	self.deadflag = DEAD_DEAD;	//indicate animations have finished.
	
	if ( (gameflags1 & GF1_CORPSE_REMOVE_ALL) || (self.monsterflags & MF_SHUFFLER_MINION) )//remove all corpses whatever
	{
		self.spawnflags = self.spawnflags | M_REMOVECORPSE;
		self.nextthink = time + 5 + random()*5;
		self.think = BDW_CorpseRemoveStart;
		return;
	}

	if (!(self.spawnflags & M_REMOVECORPSE) )	//do nothing
		return;
		
	if (gameflags1 & GF1_CORPSE_STAY)	//all corpses remain
		return;

	self.nextthink = time + 5 + random()*5;
	self.think = BDW_CorpseRemoveStart;
};



				


/*
// melee damage point calculation
vector(entity targ, entity inflictor) BDW_GetMeleeDamagePoint =
{
	local float r;
	local vector p;

	r = (targ.size_x + targ.size_y) * 0.25;		// this is a rough "radius" of the monster
	p = normalize(inflictor.origin - targ.origin);	// get unit vector pointing towards inflictor
	p = targ.origin + (p * r);				// work out damage point

	return p;
};
*/

/*
=======================================================================
SUB_BBoxTraceCheck

This checks for obstacles such as solid entities or walls inside
the bbox and along its borders.  If an obstacle is met, FALSE is
returned.

bdw - this is a variant of the bbox function to be found in chaos test qc
i have replaced the "head" entity with world, and the box entity with generic coordinates
=======================================================================
*/

float(vector box_mins, vector box_maxs, vector spot) SUB_BBoxTraceCheck =
{
        local   vector  p1, p2;

// Check for obstacles inside the bbox.

// Order:  1)--- to +++    2)+-- to -++    3)++- to --+    4)-+- to +-+

        p1 = spot + box_mins;
        p2 = spot + box_maxs;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1_x = spot_x + box_maxs_x;
        p2_x = spot_x + box_mins_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1_y = spot_y + box_maxs_y;
        p2_y = spot_y + box_mins_y;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1_x = spot_x + box_mins_x;
        p2_x = spot_x + box_maxs_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

// Check for obstacles along the bbox boundaries.

// Order:  1)+++ to ++-    2)+-+ to +--    3)--+ to ---    4)-++ to -+-
//         5)--- to +--    6)+-- to ++-    7)++- to -+-    8)-+- to ---
//         9)+++ to -++   10)-++ to --+   11)--+ to -+-   12)-+- to +++

        p1 = p2 = spot + box_maxs;
        p2_z = spot_z + box_mins_z;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1_x = p2_x = spot_x + box_mins_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1_y = p2_y = spot_y + box_mins_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1_x = p2_x = spot_x + box_maxs_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2 = spot + box_mins;
        p2_x = spot_x + box_maxs_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + box_maxs_y;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_x = spot_x + box_mins_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + box_mins_y;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2 = spot + box_maxs;
        p2_x = spot_x + box_mins_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + box_mins_y;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_x = spot_x + box_maxs_x;
        traceline (p1, p2, FALSE, world);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + box_maxs_y;
        traceline (p1, p2, FALSE, world);
        return (trace_fraction == 1);
};

/*
=======================================================================
SUB_BBoxInWall

This checks if a bbox is inside a wall or sky.  The bbox's origin
and corners are checked.  If any one points is within a solid or sky,
TRUE is returned.

bdw - variant - see above
=======================================================================
*/

float(vector box_mins, vector box_maxs, vector spot) SUB_BBoxInWall =
{
        local   vector  p;

// Check origin.

        p = spot;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

// Check bbox faces.

// Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+

        p_x = spot_x + box_mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_maxs_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p = spot;
        p_y = spot_y + box_mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_y = spot_y + box_maxs_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p = spot;
        p_z = spot_z + box_mins_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_z = spot_z + box_maxs_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

// Check bbox corners.

// Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---

        p_x = spot_x + box_maxs_x;
        p_y = spot_y + box_maxs_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_maxs_x;
        p_y = spot_y + box_mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_maxs_x;
        p_y = spot_y + box_maxs_y;
        p_z = spot_z + box_mins_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_maxs_x;
        p_y = spot_y + box_mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + box_mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        return (pointcontents(p) == CONTENT_SKY);
};

/*
=======================================================================
SUB_BBoxInOccupied

This checks if the spot is empty or occupied by a solid.

bdw - variant - see above. this a very rigorous way of checking whether
a given bbox is in an occupied space - use it for shuffler spawning, hell knight teleporting etc.
=======================================================================
*/

float(vector box_mins, vector box_maxs, vector spot) SUB_BBoxInOccupied =
{

// If a wall or other solid is in the way, 
// the monster can't respawn here.

        if (SUB_BBoxInWall(box_mins, box_maxs, spot))  return TRUE;

// Check if other obstacles such as entities are occupying the space.

        return !SUB_BBoxTraceCheck(box_mins, box_maxs, spot);
};

float(entity attacker) NotAGoonSlapper =
{
	//this function just returns true if attacker is not a goonslapper
	//it just saves typing in certain monster th_pain functions...

	if (!(attacker.flags & FL_MONSTER))
		return TRUE;
	if (!(attacker.monsterflags & MF_GOON_SLAP))
		return TRUE;

	dprint("ouch - i've been goonslapped.\n");

	return FALSE;	// it is a goonslapper
};