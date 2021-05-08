/*
=========================================================
m_paths.qc

bdw - this deals with the various ways mappers 
can influence the movement of monsters, by placing 
entities to provoke monster movements that would 
not otherwise be produced with the standard ai routines.
=========================================================
*/



/*
===================================================================================================================

bdw - MONSTERGUIDE TRIGGERS

this is a way of improving the route finding abilities of monsters in combat. use this when monsters get "stuck" in
various places when they are trying to chase their enemy. it can also be used just to send monsters running off to unusual
places, by not specifying an ".enemy_pos" condition.

when touched by a monster, this trigger will compare its location to the monster's enemy location;
if the monster's enemy is located at a vector position equal to or exceeding it's own location + its enemy_pos
field, it will send the monster off on a path to help it hunt its enemy better, and the monster becomes
"guided". whilst guided, a monster will continue to check the position of it's enemy relative to the 
monsterguide; if at any time the guiding condition evaluates false, the guiding path is assumed to no longer be 
of any use, and the monster is released from its guided state and continues to hunt it's enemy using the standard ai.

"Using" a trigger_monsterguide searches through all the ents whose targetname matches self.netname, and removes the M_NOGUIDE spawnflag,
if it is set. This basically lets you create situations where monsters will hang around in a certain place until "summoned" to start following
paths.

TODO: make a spawnflag "inert until triggered", i.e. the trigger will be invisible to all monsters until "used".

===================================================================================================================
*/

float(entity e, entity g) BDW_CheckMonsterGuidePosition =
{
	local float p1, p2;

	if (g.enemy_pos_z)	//z position checks the ground level, i.e. min_z only (for mapping convenience)
	{
		if (g.enemy_pos_z < 0)
		{
			if (e.absmin_z > (g.absmin_z + g.enemy_pos_z) )
				return FALSE;
		}
		else if (e.absmin_z < (g.absmin_z + g.enemy_pos_z) )
			return FALSE;
	}
	if (g.enemy_pos_x)	//x and y positions are from the centre of the brush
	{
		p1 = (e.absmin_x + e.absmax_x) * 0.5;
		p2 = (g.absmin_x + g.absmax_x) * 0.5;

		if (g.enemy_pos_x < 0)
		{
			if (p1 > (p2 + g.enemy_pos_x) )
				return FALSE;
		}
		else if (p1 < (p2 + g.enemy_pos_x) )
			return FALSE;
	}
	if (g.enemy_pos_y)
	{
		p1 = (e.absmin_y + e.absmax_y) * 0.5;
		p2 = (g.absmin_y + g.absmax_y) * 0.5;

		if (g.enemy_pos_y < 0)
		{
			if (p1 > (p2 + g.enemy_pos_y) )
				return FALSE;
		}
		if (p1 < (p2 + g.enemy_pos_y) )
			return FALSE;
	}

	return TRUE;
};

void() trigger_monsterguide_touch =
{
	local entity temp, en;

	if (other.guide_ent == self)
		return;	//already being guided by it

	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return;	

	if (other.spawnflags & M_NOGUIDE)
		return;	//new spawnflag lets a monster ignore monsterguides	

	if ((other.monsterflags & MF_GUIDED) && (other.enemy == world))	//remember, as far as movetogoal is concerned, guided monsters have no enemy.
		en = other.oldenemy;
	else
		en = other.enemy;		

	if (en == world)
		return;	

	if (!(BDW_CheckMonsterGuidePosition(en, self)))
		return;

	//send him off to a path corner	

	other.goalentity = find(world, targetname, self.target);
   	other.ideal_yaw = vectoyaw(other.goalentity.origin - other.origin);

	
	//dprint(other.classname);dprint(" is being guided\n");
   	
	other.monsterflags = other.monsterflags | MF_GUIDED;
	other.guide_ent = self;
};

/*
==================================

when "guided", a monster has the MF_GUIDED monsterflag; he will be sent to a path_monsterguide. 

=================================
*/

void() path_monsterguide_touch = 
{
	local entity temp;

	if (other.goalentity != self)		
		return;	

	temp = self;
	self = other;
	other = temp;	

   	if (other.target)
      {
      	self.goalentity = find(world, targetname, other.target);
		if (!self.goalentity)
		{
			dprint("warning: path_monsterguide can't find target\n");
         		BDW_ReleaseFromGuidedState();
			return;
		}
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);      	
      }  
	else
	{
		dprint(self.classname);dprint(" reached end of path\n");
		BDW_ReleaseFromGuidedState();
	}
};


void() path_monsterguide =
{
	if (!self.targetname)
		objerror ("path_monsterguide: no targetname");

	self.solid = SOLID_TRIGGER;
	self.touch = path_monsterguide_touch;
	setsize (self, '-16 -16 -16', '16 16 16');	//bigger, i.e. "fuzzier" than a path_corner
};
/*
void() trigger_monsterguide_use =
{
	local entity e;

	e = find(world, targetname, self.netname);

	while(e)
	{
		e.spawnflags = e.spawnflags - (e.spawnflags & M_NOGUIDE);
		e = find(e, targetname, self.netname);
	}

	self.use = SUB_Null;
};
*/

void() trigger_monsterguide =
{
	if (!self.target)
		objerror ("trigger_monsterguide: no target");

	//if enemy_pos is not set, monsters will move to path_corners regardless,
	//so not an error, just a warning in case you didn't intend this behaviour...
	if (!self.enemy_pos)	
		dprint("trigger_monsterguide with no enemy_pos\n");
	
	self.solid = SOLID_TRIGGER;
   	self.touch = trigger_monsterguide_touch;
	//self.use = trigger_monsterguide_use;

   	setmodel (self, self.model);  // set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";	
};

/*
========================================================

MONSTERJUMP TRIGGERS

bdw - monsterjump triggers - used to be in triggers.qc

now has an enemy_pos condition, that will only
cause the monster to jump if the condition is met.

also, todo: give certain monsters self.th_jump - if they
have a jumping animation (fiends, shufflers)

========================================================
*/

void() trigger_monsterjump_touch =
{
	local entity en;	
	
	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return;

	//bdw - new spawnflag
	if (other.spawnflags & M_NOJUMP)
		return;		

	//bdw - enemy_pos condition...
	if (self.enemy_pos != '0 0 0')
	{
		if ((other.monsterflags & MF_GUIDED) && (other.enemy == world))	//remember, as far as movetogoal is concerned, guided monsters have no enemy.
			en = other.oldenemy;
		else
			en = other.enemy;	

		if (en == world)
			return;

		else if (!(BDW_CheckMonsterGuidePosition(en, self)))
			return;
	}		

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;

	if ( !(other.flags & FL_ONGROUND) )
		return;

	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
//MED 12/01/96 added count stuff
   	if (self.cnt > 0)
      {
      	self.cnt = self.cnt - 1;
      	if (self.cnt == 0)
         	{
         		self.touch = SUB_Null;
         		self.nextthink = time + 0.1;
         		self.think = SUB_Remove;
         	}
      }
};

//MED 12/01/96 added count field
/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
"cnt" default infinite, how many times to trigger
"enemy_pos" - bdw - works like trigger_monsterguide - see above
*/
void() trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
//MED 12/01/96 added count stuff
   	if (self.cnt == 0)
      	self.cnt = -1;

	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};






