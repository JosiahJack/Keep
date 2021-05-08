/*
  These globals are typically a restating of the obvious. These are the per-frame values valid for the current input frame which is being run. Any persistant state is stored in ent fields

bugs: double-jump exists. holding jump while airstepping adds a second velocity of 270.
*/
float input_timelength;
vector input_angles;
vector input_movevalues;
float input_buttons;
/*
  Fields modified:
  .float pmove_flags; (FL_ONGROUND)
  .vector velocity;
  .vector origin;
  .float teleport_time;
  Fields written:
  .float waterlevel;
  .float watertype;
  .float flags; (FL_ONGROUND duped)

  Any 'progressive' field needs to be handled in cs_pred.qc and sent from the server to the client.
  Fields which are not handled like that will result in miss-prediction.

  Note that touch functions will trigger in the middle of this code, including teleporters and such.

  This code _must not_ use the 'time' global.
  'time' is the server time. The client cannot reliably know what the time will be when its packet arrives at the server, and thus it is not predictable. Any use of 'time' can result in errors.
  Any such uses should use a timer of some kind based around input_timelength. This includes self.teleport_time.
*/

/*FIXME: these should be tied to cvars instead, but replicated somehow for csqc (assigned to by other parts of code)*/
var float movevars_stepheight = 18;
var float movevars_airstepheight = 18;
var float movevars_friction = 4;
var float movevars_edgefriction = 2;
var float movevars_gravity = 800;
var float movevars_accelerate = 10;
var float movevars_stopspeed = 100;
var float movevars_maxspeed = 320;
var float movevars_jumpheight = 270;

.float waterlevel;
.float watertype;
.float teleport_time;

#define USEABSTIME
#ifdef USEABSTIME
	#define TIME_BASE time
#else
	#define TIME_BASE 0
#endif

/*Figures out where the player is in the world. Whether they're in water, etc*/
void() PM_Categorize =
{
	vector p;
	float pc;
	/*noclip is never onground*/
	if (self.movetype == MOVETYPE_NOCLIP)
		self.pmove_flags = self.pmove_flags - (self.pmove_flags & FL_ONGROUND);
	else
	/*if we're moving upwards, we can't be on ground*/
	if (self.velocity_z > 180)
		self.pmove_flags = self.pmove_flags - (self.pmove_flags & FL_ONGROUND);
	else
	{
		tracebox(self.origin, self.mins, self.maxs, self.origin - '0 0 1', FALSE, self);
		//only onground if we hit it, it faces upwards, and we're actually moving towards it
		if (trace_fraction < 1 && trace_plane_normal_z > 0.7 && self.velocity*trace_plane_normal < 0.01)
		{
			self.pmove_flags |= FL_ONGROUND;
			self.groundentity = trace_ent;
		}
		else
			self.pmove_flags = self.pmove_flags - (self.pmove_flags & FL_ONGROUND);
	}

	/*check water levels*/
	p = self.origin;
	p_z = self.origin_z + self.mins_z + 1;
	pc = pointcontents(p);
	if (pc < CONTENT_SOLID)
	{
		self.watertype = pc;
		p_z = self.origin_z + (self.mins_z + self.maxs_z) * 0.5;
		if (pointcontents(p) < CONTENT_SOLID)
		{
			p_z = self.origin_z + self.maxs_z;
			if (pointcontents(p) < CONTENT_SOLID)
				self.waterlevel = 3;
			else
				self.waterlevel = 2;
		}
		else
			self.waterlevel = 1;
	}
	else
	{
		self.watertype = CONTENT_EMPTY;
		self.waterlevel = 0;
	}

	self.flags &~= FL_ONGROUND | FL_JUMPRELEASED;
	self.flags |= self.pmove_flags;
};

/*This function applies the velocity changes the player wishes to apply*/
void(float movetime, float before) PM_Run_Acceleration =
{
	local vector wishvel, wishdir, v;
	local float wishspeed, f;

	makevectors(input_angles);

	PM_Categorize();

#ifndef USEABSTIME
	/*keep timers ticking*/
	self.teleport_time -= movetime;
#endif

	/*corpses can't move!*/
	if (self.movetype == MOVETYPE_TOSS)
	{
		self.velocity_z = self.velocity_z - movevars_gravity * movetime;
		return;
	}

	// swim
	if (self.waterlevel >= 2)
	if (self.movetype != MOVETYPE_NOCLIP)
	{
		self.pmove_flags = self.pmove_flags - (self.pmove_flags & FL_ONGROUND);

		if (input_movevalues == '0 0 0')
			wishvel = '0 0 -60'; // drift towards bottom
		else
			wishvel = v_forward * input_movevalues_x + v_right * input_movevalues_y + '0 0 1' * input_movevalues_z;

		wishspeed = vlen (wishvel);
		if (wishspeed > movevars_maxspeed)
			wishspeed = movevars_maxspeed;

		wishspeed = wishspeed * 0.7;

		// water friction
		if (self.velocity != '0 0 0')
		{
			f = vlen(self.velocity) * (1 - movetime * movevars_friction);
			if (f > 0)
				self.velocity = normalize(self.velocity) * f;
			else
				self.velocity = '0 0 0';
		}
		else
			f = 0;

		// water acceleration
		if (wishspeed <= f)
			return;

		f = min(wishspeed - f, movevars_accelerate * wishspeed * movetime);
		self.velocity = self.velocity + normalize(wishvel) * f;
		return;
	}

	// hack to not let you back into teleporter
	if (self.teleport_time > TIME_BASE && input_movevalues_x < 0)
		wishvel = v_right * input_movevalues_y;
	else
	{
		if (self.pmove_flags & FL_ONGROUND)
			makevectors (input_angles_y * '0 1 0');

		wishvel = v_forward * input_movevalues_x + v_right * input_movevalues_y;
	}

	if (self.movetype != MOVETYPE_FLY && self.movetype != MOVETYPE_NOCLIP)
		wishvel_z = 0;
	if (self.movetype != MOVETYPE_WALK)
		wishvel_z += input_movevalues_z;

	wishdir = normalize(wishvel);
	wishspeed = vlen(wishvel);
	if (wishspeed > movevars_maxspeed)
		wishspeed = movevars_maxspeed;

	if (self.movetype == MOVETYPE_FLY || self.movetype == MOVETYPE_NOCLIP) // noclip
	{
		self.pmove_flags = self.pmove_flags - (self.pmove_flags & FL_ONGROUND);

		//friction
		f = vlen(self.velocity);
		if (f < movevars_stopspeed)
			f = 1 - movetime * (movevars_stopspeed / f) * movevars_friction;
		else
			f = 1 - movetime * movevars_friction;
		if (f < 0)
			self.velocity = '0 0 0';
		else
			self.velocity = self.velocity * f;

		//acceleration
		f = wishspeed - (self.velocity * wishdir);
		if (f > 0)
			self.velocity = self.velocity + wishdir * min(f, movevars_accelerate * movetime * wishspeed);
	}
	else
	{
		/*FIXME: pogostick*/
		if (self.pmove_flags & FL_ONGROUND)
		if (self.pmove_flags & FL_JUMPRELEASED)
		if (input_buttons & 2 && before)
		{
			if (self.velocity_z < 0)
				self.velocity_z = 0;

			self.velocity_z += movevars_jumpheight;

#ifdef SSQC
			sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
#endif

			self.pmove_flags &~= FL_ONGROUND;
			
			self.pmove_flags &~= FL_JUMPRELEASED;
		}
		// not pressing jump, set released flag
		if (!(input_buttons & 2))
			self.pmove_flags |= FL_JUMPRELEASED;
		
		if (self.pmove_flags & FL_ONGROUND) // walking
		{
			// friction
			if (self.velocity_x || self.velocity_y)
			{
				v = self.velocity;
				v_z = 0;
				f = vlen(v);

				// if the leading edge is over a dropoff, increase friction
				v = self.origin + normalize(v) * 16 + '0 0 1' * self.mins_z;

				traceline(v, v + '0 0 -34', TRUE, self);

				// apply friction
				if (trace_fraction == 1.0)
				{
					if (f < movevars_stopspeed)
						f = 1 - movetime * (movevars_stopspeed / f) * movevars_friction * movevars_edgefriction;
					else
						f = 1 - movetime * movevars_friction * movevars_edgefriction;
				}
				else
				{
					if (f < movevars_stopspeed)
						f = 1 - movetime * (movevars_stopspeed / f) * movevars_friction;
					else
						f = 1 - movetime * movevars_friction;
				}

				if (f < 0)
					self.velocity = '0 0 0';
				else
					self.velocity = self.velocity * f;
			}

			// acceleration
			f = wishspeed - (self.velocity * wishdir);
			if (f > 0)
				self.velocity = self.velocity + wishdir * min(f, movevars_accelerate * movetime * wishspeed);
		}
		else // airborn
		{
			/*apply gravity*/
			self.velocity_z = self.velocity_z - movevars_gravity * movetime;

			if (wishspeed < 30)
				f = wishspeed - (self.velocity * wishdir);
			else
				f = 30 - (self.velocity * wishdir);
			if (f > 0)
				self.velocity = self.velocity + wishdir * (min(f, movevars_accelerate) * wishspeed * movetime);
		}
	}
};

/*This function just calls the other's touch function with the right context*/
static void(entity tother) PM_DoTouch =
{
	entity oself = self;

	if (tother.touch)
	{
		other = self;
		self = tother;

		self.touch();
	}

	self = oself;
};

/*this function 'bounces' off any surfaces that were hit*/
static void(vector surfnorm) PM_Rebound =
{
	float v;
	v = self.velocity*surfnorm;
	self.velocity = self.velocity - surfnorm*(v);
};

/*if BSP precision messes up, this function will attempt to correct the origin to stop it from being invalid*/
float() PM_Fix_Origin =
{
	float x, y, z;
	vector norg, oorg = self.origin;

//check current position.
	tracebox(oorg, self.mins, self.maxs, oorg, FALSE, self);
	if (!trace_startsolid)
		return TRUE;

//truncate to network accuracy
	oorg_x = floor(oorg_x*8 + (1.0/16))*0.125;
	oorg_y = floor(oorg_y*8 + (1.0/16))*0.125;
	oorg_z = floor(oorg_z*8 + (1.0/16))*0.125;

//try and find an empty spot nearby
	for (z = 0; z < 3; z++)
	{
		norg_z = oorg_z + ((z==2)?-1:z)*0.125;
		for (x = 0; x < 3; x++)
		{
			norg_x = oorg_x + ((x==2)?-1:x)*0.125;
			for (y = 0; y < 3; y++)
			{
				norg_y = oorg_y + ((y==2)?-1:y)*0.125;

				tracebox(norg, self.mins, self.maxs, norg, FALSE, self);
				if (!trace_startsolid)
				{
					//dprint("unstuck\n");
					self.origin = norg;
					return TRUE;
				}
			}
		}
	}
	//dprint("stuck\n");
	return FALSE;
};

/*This function is responsible for moving the entity forwards according to the various inputs/state*/
void() PM_Run_Move =
{
	vector destp;
	vector saved_plane_normal;
	float stepped;
	float movetime;
	float attempts;

	if (self.movetype == MOVETYPE_NOCLIP)
	{
		self.origin = self.origin + self.velocity * input_timelength;
		return;
	}

	//we need to bounce off surfaces (in order to slide along them), so we need at 2 attempts
	for (attempts = 3, movetime = input_timelength; movetime>0 && attempts; attempts--)
	{
		destp = self.origin + self.velocity*movetime;
		tracebox(self.origin, self.mins, self.maxs, destp, FALSE, self);	//try going straight there
		if (trace_startsolid)
		{
			if (!PM_Fix_Origin())
				return;
			continue;
		}
		self.origin = trace_endpos;

		if (trace_fraction < 1)
		{
			saved_plane_normal = trace_plane_normal;

			movetime -= movetime * trace_fraction;

			if (movetime)
			{
				//step up if we can
				trace_endpos = self.origin;
				if (self.pmove_flags & FL_ONGROUND)
					trace_endpos_z += movevars_stepheight;
				else
					trace_endpos_z += movevars_airstepheight;
				tracebox(self.origin, self.mins, self.maxs, trace_endpos, FALSE, self);
				stepped = trace_endpos_z - self.origin_z;

				float roof_fraction = trace_fraction;
				vector roof_plane_normal = trace_plane_normal;

				destp = trace_endpos + self.velocity*movetime;
				destp_z = trace_endpos_z; /*only horizontally*/
				//move forwards
				tracebox(trace_endpos, self.mins, self.maxs, destp, FALSE, self);

				//if we got anywhere, make this raised-step move count
				if (trace_fraction != 0)
				{
					float fwfrac = trace_fraction;
					vector fwplane = trace_plane_normal;

					movetime -= movetime * trace_fraction;

					//move down
					destp = trace_endpos;
					destp_z -= stepped+1;
					tracebox(trace_endpos, self.mins, self.maxs, destp, FALSE, self);
					/*bounce off the ceiling if we hit it while airstepping*/
					if (roof_fraction < 1)
						PM_Rebound(roof_plane_normal);
					if (trace_fraction < 1 /*FIXME: you probably want this: && self.velocity_z < 0*/)
						PM_Rebound(trace_plane_normal);
					else if (fwfrac < 1)
						PM_Rebound(fwplane);
					self.origin = trace_endpos;

					continue;
				}
			}
			
			//stepping failed, just bounce off
			PM_Rebound(saved_plane_normal);

			PM_DoTouch(trace_ent);
		}
		else
			break;
	}
};


/*Runs all physics for an input frame*/
void(entity pent) PM_Run =
{
	local entity oself = self;
	self = pent;

	self.mins = VEC_HULL_MIN;
	self.maxs = VEC_HULL_MAX;
	PM_Fix_Origin();

	/*Call accelerate before and after the actual move, with half the move each time. This reduces framerate dependance.*/
	PM_Run_Acceleration(input_timelength/2, TRUE);
	PM_Run_Move();
	PM_Run_Acceleration(input_timelength/2, FALSE);

	/*NOTE: should clip to network precision here if lower than a float*/
#ifdef SSQC
	if (!self.fixangle)
	{
		self.angles = input_angles;
		self.angles_x *= -0.333;
	}
#endif

	/*touch buttons and stuff*/
	if (trace_ent.touch)
	{
		self = trace_ent;
		other = pent;
		self.touch();
		self = pent;
	}
	/*if we're standing in any triggers, touch them now*/
	touchtriggers();	//also relinks+sets absmin
	self = oself;
};

 