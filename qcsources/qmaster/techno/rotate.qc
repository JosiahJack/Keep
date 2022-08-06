
/* rotate.qc ==============Contains information for rotating doors and brushes. Taken from so-called "quake 2" source code. =========

#define	STATE_TOP		0

#define	STATE_BOTTOM		1

#define STATE_UP		2
#define STATE_DOWN		3


#define DOOR_START_OPEN		1

#define DOOR_REVERSE		2
#define DOOR_CRUSHER		4

#define DOOR_NOMONSTER		8

#define DOOR_TOGGLE		32
#define DOOR_X_AXIS		64

#define DOOR_Y_AXIS		128

#define MOD_CRUSH		20


vec3_origin = {0,0,0};

/* Rotating Brush */

void rotating_blocked = {


	T_Damage (other,self,self,self.dmg);

}


void rotating_touch = {


	
}



void rotating_use = {


   	if ( ((self.state != STATE_TOP) && (self.state != STATE_BOTTOM)) ) {

      		return ;

   	}

	if (!VectorCompare (self.avelocity, vec3_origin))
	{

		self.s.sound = 0;
		VectorClear (self.avelocity);

		self.touch = NULL;


	}  else
 {


		self.s.sound = self.moveinfo.sound_middle;

		VectorScale (self.movedir, self.speed, self.avelocity);

		if (self.spawnflags & 16)

			self.touch = rotating_touch;

	}


}


void SP_func_rotating = 
{


	self.solid = SOLID_BSP;

	if (self.spawnflags & DOOR_TOGGLE)

		self.movetype = MOVETYPE_STOP;

	else

		self.movetype = MOVETYPE_PUSH;



	// set the axis of rotation

	VectorClear(self.movedir);

	if (self.spawnflags & 4)

		self.movedir[2] = 1.0;

	else if (ent.spawnflags & 8)

		self.movedir[0] = 1.0;

	else

        // Z_AXIS

		self.movedir[1] = 1.0;



	// check for reverse rotation

	if (self.spawnflags & 2)

		VectorNegate (ent.movedir, ent.movedir);


	if (!self.speed)

		self.speed = 100;

	if (!self.dmg)

		self.dmg = 2;


//	ent.moveinfo.sound_middle = "doors/hydro1.wav";


	ent.use = rotating_use;

	if (ent->dmg)

		ent->blocked = rotating_blocked;


	if (ent->spawnflags & 1)

		ent->use (ent, NULL, NULL);


	if (ent->spawnflags & 64)

		ent->s.effects |= EF_ANIM_ALL;

	if (ent->spawnflags & 128)

		ent->s.effects |= EF_ANIM_ALLFAST;


	gi.setmodel (ent, ent->model);

	gi.linkentity (ent);

}

/* Rotating Door */

/*
======================================================================


DOORS

  spawn a trigger surrounding the entire team unless it is
  already targeted by another


======================================================================
*/



/*QUAKED func_door (0 .5 .8) 

? START_OPEN 
x CRUSHER
 NOMONSTER
 ANIMATED
 TOGGLE
 ANIMATED_FAST
TOGGLE
		wait in both the start and end states for a trigger event.

START_OPEN	the door to moves to its destination when spawned, and operate in reverse.
		It is used to temporarily or permanently close off an area when triggered (not useful for touch or takedamage doors).


NOMONSTER	monsters will not trigger this door


"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet

"angle"		determines the opening direction

"targetname" 	if set, no touch field will be spawned and a remote button or trigger field activates the door.

"health"	if set, door must be shot open

"speed"		movement speed (100 default)

"wait"		wait before returning (3 default, -1 = never return)

"lip"		lip remaining at end of move (8 default)

"dmg"		damage to inflict when blocked (2 default)

"sounds"

	1)	silent
	
2)	light
	
3)	medium

	4)	heavy

*/


void door_use_areaportals (edict_t *self, qboolean open)
{


	edict_t	*t = NULL;



	if (!self->target)

		return;


	while ((t = G_Find (t, FOFS(targetname), self->target)))
	{

		if (Q_stricmp(t->classname, "func_areaportal") == 0)
		{

			gi.SetAreaPortalState (t->style, open);

		}

	}


}


void door_go_down (edict_t *self); // Post-declaration


void door_hit_top (edict_t *self)
{


	if (!(self->flags & FL_TEAMSLAVE))
	{

		if (self->moveinfo.sound_end)

			gi.sound (self, CHAN_NO_PHS_ADD+CHAN_VOICE, self->moveinfo.sound_end, 1, ATTN_STATIC, 0);

		self->s.sound = 0;

	}

	self->moveinfo.state = STATE_TOP;

	if (self->spawnflags & DOOR_TOGGLE)

		return;

	if (self->moveinfo.wait >= 0)
	{

		self->think = door_go_down;

		self->nextthink = level.time + self->moveinfo.wait;

	}


}


void door_hit_bottom (edict_t *self)
{


	if (!(self->flags & FL_TEAMSLAVE))
	{

		if (self->moveinfo.sound_end)

			gi.sound (self, CHAN_NO_PHS_ADD+CHAN_VOICE, self->moveinfo.sound_end, 1, ATTN_STATIC, 0);

		self->s.sound = 0;

	}

	self->moveinfo.state = STATE_BOTTOM;

	door_use_areaportals (self, false);


}


void door_go_down (edict_t *self)
{


	if (!(self->flags & FL_TEAMSLAVE))
	{

		if (self->moveinfo.sound_start)

			gi.sound (self, CHAN_NO_PHS_ADD+CHAN_VOICE, self->moveinfo.sound_start, 1, ATTN_STATIC, 0);

		self->s.sound = self->moveinfo.sound_middle;

	}

	if (self->max_health)
	{

		self->takedamage = DAMAGE_YES;

		self->health = self->max_health;

	}

	
	self->moveinfo.state = STATE_DOWN;

	if (strcmp(self->classname, "func_door") == 0)

		Move_Calc (self, self->moveinfo.start_origin, door_hit_bottom);

	else if (strcmp(self->classname, "func_door_rotating") == 0)

		AngleMove_Calc (self, door_hit_bottom);


}


void door_go_up (edict_t *self, edict_t *activator)
{


	if (self->moveinfo.state == STATE_UP)

		return;		// already going up


	if (self->moveinfo.state == STATE_TOP)
	{	// reset top wait time

		if (self->moveinfo.wait >= 0)

			self->nextthink = level.time + self->moveinfo.wait;

		return;

	}

	
	if (!(self->flags & FL_TEAMSLAVE))
	{

		if (self->moveinfo.sound_start)

			gi.sound (self, CHAN_NO_PHS_ADD+CHAN_VOICE, self->moveinfo.sound_start, 1, ATTN_STATIC, 0);

		self->s.sound = self->moveinfo.sound_middle;

	}

	self->moveinfo.state = STATE_UP;

	if (strcmp(self->classname, "func_door") == 0)

		Move_Calc (self, self->moveinfo.end_origin, door_hit_top);

	else if (strcmp(self->classname, "func_door_rotating") == 0)

		AngleMove_Calc (self, door_hit_top);


	G_UseTargets (self, activator);
	door_use_areaportals (self, true);


}


void door_use (edict_t *self, edict_t *other, edict_t *activator)
{



	edict_t	*ent;



	if (self->flags & FL_TEAMSLAVE)

		return;


	if (self->spawnflags & DOOR_TOGGLE)
	{

		if (self->moveinfo.state == STATE_UP || self->moveinfo.state == STATE_TOP)
{
	// trigger all paired doors

			for (ent = self ; ent ; ent = ent->teamchain)
{

				ent->message = NULL;

				ent->touch = NULL;

				door_go_down (ent);

			}

			return;

		}

	}
	
	// trigger all paired doors


	for (ent = self ; ent ; ent = ent->teamchain)
	{

		ent->message = NULL;

		ent->touch = NULL;

		door_go_up (ent, activator);

	}


};


void Touch_DoorTrigger (edict_t *self, edict_t *other, cplane_t *plane, csurface_t *surf)
{


	if (other->health <= 0)

		return;


	if (!(other->svflags & SVF_MONSTER) && (!other->client))

		return;


	if ((self->owner->spawnflags & DOOR_NOMONSTER) && (other->svflags & SVF_MONSTER))

		return;


	if (level.time < self->touch_debounce_time)

		return;

	self->touch_debounce_time = level.time + 1.0;


	door_use (self->owner, other, other);


}


void Think_CalcMoveSpeed (edict_t *self)
{


	edict_t	*ent;

	float	min;

	float	time;

	float	newspeed;

	float	ratio;

	float	dist;



	if (self->flags & FL_TEAMSLAVE)

		return;		// only the team master does this


				// find the smallest distance any member of the team will be moving


	min = fabs(self->moveinfo.distance);

	for (ent = self->teamchain; ent; ent = ent->teamchain)
	{

		dist = fabs(ent->moveinfo.distance);

		if (dist < min)

		min = dist;

	}


	time = min / self->moveinfo.speed;

	// adjust speeds so they will all complete at the same time


	for (ent = self; ent; ent = ent->teamchain)
	{

		newspeed = fabs(ent->moveinfo.distance) / time;
	
	ratio = newspeed / ent->moveinfo.speed;

		if (ent->moveinfo.accel == ent->moveinfo.speed)

			ent->moveinfo.accel = newspeed;

		else

			ent->moveinfo.accel *= ratio;

		if (ent->moveinfo.decel == ent->moveinfo.speed)

			ent->moveinfo.decel = newspeed;

		else

			ent->moveinfo.decel *= ratio;

		ent->moveinfo.speed = newspeed;

	}


}


void Think_SpawnDoorTrigger (edict_t *ent)
{


	edict_t		*other;

	vec3_t		mins, maxs;



	if (ent->flags & FL_TEAMSLAVE)

		return;		// only the team leader spawns a trigger



	VectorCopy (ent->absmin, mins);

	VectorCopy (ent->absmax, maxs);


	for (other = ent->teamchain ; other ; other=other->teamchain)
	{

		AddPointToBounds (other->absmin, mins, maxs);

		AddPointToBounds (other->absmax, mins, maxs);

	}

	// expand

 
	mins[0] -= 60;

	mins[1] -= 60;

	maxs[0] += 60;

	maxs[1] += 60;


	other = G_Spawn ();

	VectorCopy (mins, other->mins);

	VectorCopy (maxs, other->maxs);

	other->owner = ent;

	other->solid = SOLID_TRIGGER;

	other->movetype = MOVETYPE_NONE;

	other->touch = Touch_DoorTrigger;

	gi.linkentity (other);


	if (ent->spawnflags & DOOR_START_OPEN)

		door_use_areaportals (ent, true);


	Think_CalcMoveSpeed (ent);


}


void door_blocked  (edict_t *self, edict_t *other)
{


	edict_t	*ent;



	if (!(other->svflags & SVF_MONSTER) && (!other->client) ){
		// give it a chance to go away on it's own terms (like gibs)

		T_Damage (other, self, self, vec3_origin, other->s.origin, vec3_origin, 100000, 1, 0, MOD_CRUSH);
// if it's still there, nuke it

		if (other)
			BecomeExplosion1 (other);

		return;

	}


	T_Damage (other, self, self, vec3_origin, other->s.origin, vec3_origin, self->dmg, 1, 0, MOD_CRUSH);


	if (self->spawnflags & DOOR_CRUSHER)

		return;


	// if a door has a negative wait, it would never come back if blocked,
			
// so let it just squash the object to death real fast

	if (self->moveinfo.wait >= 0)
	{

		if (self->moveinfo.state == STATE_DOWN)
		{

			for (ent = self->teammaster ; ent ; ent = ent->teamchain)

				door_go_up (ent, ent->activator);
		}
else
{

			for (ent = self->teammaster ; ent ; ent = ent->teamchain)

				door_go_down (ent);

		}

	}


}


void door_killed (edict_t *self, edict_t *inflictor, edict_t *attacker, int damage, vec3_t point)
{

	edict_t	*ent;

	for (ent = self->teammaster ; ent ; ent = ent->teamchain)
	{
		ent->health = ent->max_health;

		ent->takedamage = DAMAGE_NO;

	}

	door_use (self->teammaster, attacker, attacker);

}


void door_touch (edict_t *self, edict_t *other, cplane_t *plane, csurface_t *surf)
{


	if (!other->client)

		return;


	if (level.time < self->touch_debounce_time)

		return;

	self->touch_debounce_time = level.time + 5.0;


	gi.centerprintf (other, "%s", self->message);

	gi.sound (other, CHAN_AUTO, gi.soundindex ("misc/talk1.wav"), 1, ATTN_NORM, 0);


}


void SP_func_door (edict_t *ent)
{


	vec3_t	abs_movedir;


	if (ent->sounds != 1){

		ent->moveinfo.sound_start = gi.soundindex  ("doors/dr1_strt.wav");

		ent->moveinfo.sound_middle = gi.soundindex  ("doors/dr1_mid.wav");

		ent->moveinfo.sound_end = gi.soundindex  ("doors/dr1_end.wav");
	}


	G_SetMovedir (ent->s.angles, ent->movedir);

	ent->movetype = MOVETYPE_PUSH;

	ent->solid = SOLID_BSP;

	gi.setmodel (ent, ent->model);


	ent->blocked = door_blocked;

	ent->use = door_use;

	
if (!ent->speed)

		ent->speed = 100;
	if (deathmatch->value)
		ent->speed *= 2;

	if (!ent->accel)

		ent->accel = ent->speed;

	if (!ent->decel)

		ent->decel = ent->speed;


	if (!ent->wait)

		ent->wait = 3;

	if (!st.lip)

		st.lip = 8;

	if (!ent->dmg)

		ent->dmg = 2;

	// calculate second position

	VectorCopy (ent->s.origin, ent->pos1);

	abs_movedir[0] = fabs(ent->movedir[0]);

	abs_movedir[1] = fabs(ent->movedir[1]);

	abs_movedir[2] = fabs(ent->movedir[2]);

	ent->moveinfo.distance = abs_movedir[0] * ent->size[0] + abs_movedir[1] * ent->size[1] + abs_movedir[2] * ent->size[2] - st.lip;

	VectorMA (ent->pos1, ent->moveinfo.distance, ent->movedir, ent->pos2);

	// if it starts open, switch the positions


	if (ent->spawnflags & DOOR_START_OPEN)
	{

		VectorCopy (ent->pos2, ent->s.origin);

		VectorCopy (ent->pos1, ent->pos2);

		VectorCopy (ent->s.origin, ent->pos1);

	}


	ent->moveinfo.state = STATE_BOTTOM;


	if (ent->health)
	{

		ent->takedamage = DAMAGE_YES;

		ent->die = door_killed;
		ent->max_health = ent->health;

	}

	else if (ent->targetname && ent->message)
	{

		gi.soundindex ("misc/talk.wav");

		ent->touch = door_touch;

	}

	
ent->moveinfo.speed = ent->speed;

	ent->moveinfo.accel = ent->accel;

	ent->moveinfo.decel = ent->decel;

	ent->moveinfo.wait = ent->wait;

	VectorCopy (ent->pos1, ent->moveinfo.start_origin);

	VectorCopy (ent->s.angles, ent->moveinfo.start_angles);

	VectorCopy (ent->pos2, ent->moveinfo.end_origin);

	VectorCopy (ent->s.angles, ent->moveinfo.end_angles);


	if (ent->spawnflags & 16)

		ent->s.effects |= EF_ANIM_ALL;

	if (ent->spawnflags & 64)

		ent->s.effects |= EF_ANIM_ALLFAST;


	// to simplify logic elsewhere, make non-teamed doors into a team of one

	if (!ent->team)
		ent->teammaster = ent;

	gi.linkentity (ent);


	ent->nextthink = level.time + FRAMETIME;

	if (ent->health || ent->targetname)

		ent->think = Think_CalcMoveSpeed;

	else

		ent->think = Think_SpawnDoorTrigger;


}




/*QUAKED func_door_rotating (0 .5 .8)

 ? START_OPEN
 REVERSE
 CRUSHER
 NOMONSTER
 ANIMATED
 TOGGLE
 X_AXIS
 Y_AXIS


TOGGLE	 	causes the door to wait in both the start and end states for a trigger event.


START_OPEN	the door to moves to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not useful for touch or takedamage doors).

NOMONSTER	monsters will not trigger this door

You need to have an origin brush as part of this entity.  The center of that brush will be
the point around which it is rotated. It will rotate around the Z axis by default.  You can
check either the X_AXIS or Y_AXIS box to change that.


"distance" 	is how many degrees the door will be rotated.

"speed" 	determines how fast the door moves; default value is 100.


REVERSE 	will cause the door to rotate in the opposite direction.


"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet

"angle"		determines the opening direction

"targetname" 	if set, no touch field will be spawned and a remote button or trigger field activates the door.

"health"	if set, door must be shot open

"speed"		movement speed (100 default)

"wait"		wait before returning (3 default, -1 = never return)

"dmg"		damage to inflict when blocked (2 default)

"sounds"

	1)	silent

	2)	light

	3)	medium
	
4)	heavy

*/



void SP_func_door_rotating (edict_t *ent)
{


	VectorClear (ent->s.angles);

	// set the axis of rotation

	VectorClear(ent->movedir);


	if (ent->spawnflags & DOOR_X_AXIS)

		ent->movedir[2] = 1.0;

	else if (ent->spawnflags & DOOR_Y_AXIS)

		ent->movedir[0] = 1.0;
	else // Z_AXIS

		ent->movedir[1] = 1.0;

	// check for reverse rotation

	if (ent->spawnflags & DOOR_REVERSE)

		VectorNegate (ent->movedir, ent->movedir);


	if (!st.distance)
	{
		gi.dprintf("%s at %s with no distance set\n", ent->classname, vtos(ent->s.origin));
		st.distance = 90;
	}
	VectorCopy (ent->s.angles, ent->pos1);

	VectorMA (ent->s.angles, st.distance, ent->movedir, ent->pos2);

	ent->moveinfo.distance = st.distance;


	ent->movetype = MOVETYPE_PUSH;

	ent->solid = SOLID_BSP;

	gi.setmodel (ent, ent->model);


	ent->blocked = door_blocked;

	ent->use = door_use;

	if (!ent->speed)

		ent->speed = 100;

	if (!ent->accel)

		ent->accel = ent->speed;

	if (!ent->decel)

		ent->decel = ent->speed;


	if (!ent->wait)

		ent->wait = 3;

	if (!ent->dmg)

		ent->dmg = 2;

	if (ent->sounds != 1)	{

		ent->moveinfo.sound_start = gi.soundindex  ("doors/dr1_strt.wav");

		ent->moveinfo.sound_middle = gi.soundindex  ("doors/dr1_mid.wav");

		ent->moveinfo.sound_end = gi.soundindex  ("doors/dr1_end.wav");
	}

	// if it starts open, switch the positions

	if (ent->spawnflags & DOOR_START_OPEN)
	{

		VectorCopy (ent->pos2, ent->s.angles);

		VectorCopy (ent->pos1, ent->pos2);

		VectorCopy (ent->s.angles, ent->pos1);

		VectorNegate (ent->movedir, ent->movedir);

	}


	if (ent->health)
	{

		ent->takedamage = DAMAGE_YES;

		ent->die = door_killed;

		ent->max_health = ent->health;

	}

	
if (ent->targetname && ent->message)	{
		gi.soundindex ("misc/talk.wav");
		ent->touch = door_touch;
	}

	ent->moveinfo.state = STATE_BOTTOM;

	ent->moveinfo.speed = ent->speed;

	ent->moveinfo.accel = ent->accel;

	ent->moveinfo.decel = ent->decel;

	ent->moveinfo.wait = ent->wait;

	VectorCopy (ent->s.origin, ent->moveinfo.start_origin);

	VectorCopy (ent->pos1, ent->moveinfo.start_angles);

	VectorCopy (ent->s.origin, ent->moveinfo.end_origin);

	VectorCopy (ent->pos2, ent->moveinfo.end_angles);


	if (ent->spawnflags & 16)

		ent->s.effects |= EF_ANIM_ALL;

	// to simplify logic elsewhere, make non-teamed doors into a team of one
	if (!ent->team)
		ent->teammaster = ent;

	gi.linkentity (ent);


	ent->nextthink = level.time + FRAMETIME;

	if (ent->health || ent->targetname)

		ent->think = Think_CalcMoveSpeed;

	else

		ent->think = Think_SpawnDoorTrigger;


}




/*QUAKED func_water (0 .5 .8)
 ? START_OPEN		func_water is a moveable water brush. It must be targeted to operate. Use a non-water texture at your own risk.


START_OPEN		causes the water to move to its destination when spawned and operate in reverse.


"angle"			determines the opening direction (up or down only)

"speed"			movement speed (25 default)

"wait"			wait before returning (-1 default, -1 = TOGGLE)

"lip"			lip remaining at end of move (0 default)

"sounds"		(yes, these need to be changed)

	0)	no sound

	1)	water

	2)	lava

*/


void SP_func_water (edict_t *self)
{


	vec3_t	abs_movedir;


	G_SetMovedir (self->s.angles, self->movedir);

	self->movetype = MOVETYPE_PUSH;

	self->solid = SOLID_BSP;

	gi.setmodel (self, self->model);


	switch (self->sounds)
	{

		default:

			break;


		case 1: // water

			self->moveinfo.sound_start = gi.soundindex  ("world/mov_watr.wav");

			self->moveinfo.sound_end = gi.soundindex  ("world/stp_watr.wav");

			break;


		case 2: // lava

			self->moveinfo.sound_start = gi.soundindex  ("world/mov_watr.wav");

			self->moveinfo.sound_end = gi.soundindex  ("world/stp_watr.wav");

			break;

	}


	// calculate second position


	VectorCopy (self->s.origin, self->pos1);

	abs_movedir[0] = fabs(self->movedir[0]);

	abs_movedir[1] = fabs(self->movedir[1]);

	abs_movedir[2] = fabs(self->movedir[2]);

	self->moveinfo.distance = abs_movedir[0] * self->size[0] + abs_movedir[1] * self->size[1] + abs_movedir[2] * self->size[2] - st.lip;

	VectorMA (self->pos1, self->moveinfo.distance, self->movedir, self->pos2);



	// if it starts open, switch the positions


	if (self->spawnflags & DOOR_START_OPEN)
	{

		VectorCopy (self->pos2, self->s.origin);

		VectorCopy (self->pos1, self->pos2);

		VectorCopy (self->s.origin, self->pos1);

	}
	VectorCopy (self->pos1, self->moveinfo.start_origin);

	VectorCopy (self->s.angles, self->moveinfo.start_angles);

	VectorCopy (self->pos2, self->moveinfo.end_origin);

	VectorCopy (self->s.angles, self->moveinfo.end_angles);


	self->moveinfo.state = STATE_BOTTOM;


	if (!self->speed)

		self->speed = 25;
	self->moveinfo.accel = self->moveinfo.decel = self->moveinfo.speed = self->speed;


	if (!self->wait)

		self->wait = -1;

	self->moveinfo.wait = self->wait;


	self->use = door_use;


	if (self->wait == -1)

		self->spawnflags |= DOOR_TOGGLE;


	self->classname = "func_door";


	gi.linkentity (self);

}


