/*##########################################

Misc Entities for Quake: The Apocalypse

###########################################*/

//##########################################
//#### Particle Sprayer                 ####
//##########################################

void() partspray_think =
{
	particle (self.origin, self.movedir, self.color, self.count);

	if(!self.targetname || self.endtime > time)
		self.nextthink = time + self.delay;
};

void() partspray_use =
{
	self.endtime = time + self.duration;
	partspray_think();
};

void() func_particlespray =
{
	if ( !self.color )
		self.color = 47;
	if ( self.count == 0 )
		self.count = 15;
	if(self.delay == 0)
		self.delay = 0.1;
	self.classname = "particlespray";
	if (self.noise)
	      precache_sound(self.noise);
	self.think = partspray_think;
	if(!self.targetname)
		self.nextthink = time + 0.1 + self.delay;
	else
		self.use = partspray_use;
};


//##########################################
//#### Trigger Impulse                   ###
//##########################################

void() trigger_impulse_reset;

void() trigger_impulse_use =
{
	activator = other;
	SUB_UseTargets();
	if(self.wait)
	{
		self.use = SUB_Null;
		self.think = trigger_impulse_reset;
		self.nextthink = time + self.wait;
	}
};

void() trigger_impulse_reset =
{
	self.use = trigger_impulse_use;
	self.think = SUB_Null;
};

void() trigger_impulse=
{
	if(!self.impulse)
	{
		dprint("impulse trigger without impulse setting.\nat ");
		dprint(ftos(self.origin_x));
		dprint(" ");
		dprint(ftos(self.origin_y));
		dprint(" ");
		dprint(ftos(self.origin_z));
		dprint("\n");
		remove(self);
		return;
	}

	impulse_triggers = TRUE;

	self.use = trigger_impulse_use;
};


//##########################################
//#### Trigger Touch Impulse             ###
//##########################################

void() tti_reset;
void() tti_use=
{
	local string tmpstr;
	
	tmpstr = self.message;
	self.message = string_null;
	SUB_UseTargets();
	self.message = tmpstr;
	
	if(self.wait)
	{
		self.solid = SOLID_NOT;
		self.use = SUB_Null;
		self.think = tti_reset;
		self.nextthink = time + self.wait;
	}
};

void() tti_reset=
{
	self.think = SUB_Null;
	self.use = tti_use;
	self.solid = SOLID_TRIGGER;
};

void() tti_touch=
{
	if(other.flags & FL_CLIENT)
	{
		if(other.imp_touch < time)
		{
			centerprint(other, self.message);
		}
		other.imp_touch = time + 0.5;
	}
};

void() trigger_touch_impulse=
{
	if(!self.impulse)
	{
		dprint("impulse trigger without impulse setting.\nat ");
		dprint(ftos(self.origin_x));
		dprint(" ");
		dprint(ftos(self.origin_y));
		dprint(" ");
		dprint(ftos(self.origin_z));
		dprint("\n");
		remove(self);
		return;
	}

	InitTrigger();
	
	self.touch = tti_touch;
	self.use = tti_use;
};


//##########################################
//#### Trigger Interupt                  ###
//##########################################

void() interupt_touch =
{
	if(other.flags & FL_CLIENT)
	{
		if(self.spawnflags & INT_MONSTONLY)
			return;
		if(other.health <= 0)
			return;
		self.endtime = time + 0.2;
		if(self.spawnflags & INT_SETACTIVATOR)
		{
			self.enemy = other;
			self.search_time = time + 0.2;
		}
	}
	else if(other.flags & FL_MONSTER)
	{
		if(self.spawnflags & INT_PLAYERONLY)
			return;
		self.endtime = time + 0.2;
	}
};

void() interupt_use =
{
	if(self.spawnflags & INT_ENTIN)
	{
		if(self.endtime > time)
		{
			if((self.spawnflags & INT_SETACTIVATOR) &&
                        (self.search_time > time))
				activator = self.enemy;
			SUB_UseTargets();
		}
		else if(self.path)
		{
			local string ttemp1, ttemp2, ttemp3, ttemp4, mtemp;
			if(self.noise)
				sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
			mtemp = self.message;
			ttemp1 = self.target;
			ttemp2 = self.target2;
			ttemp3 = self.target3;
			ttemp4 = self.target4;
			self.target = self.path;
			self.target2 = self.target3 = self.target4 = string_null;
			self.message = self.group;
			SUB_UseTargets();
			self.target = ttemp1;
			self.target2 = ttemp2;
			self.target3 = ttemp3;
			self.target4 = ttemp4;
			self.message = mtemp;
		}
	}
	else
	{
		if(self.endtime < time)
			SUB_UseTargets();
		else if(self.path)
		{
			if((self.spawnflags & INT_SETACTIVATOR) &&
                        (self.search_time > time))
				activator = self.enemy;
			local string ttemp1, ttemp2, ttemp3, ttemp4, mtemp;
			if(self.noise)
				sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
			mtemp = self.message;
			ttemp1 = self.target;
			ttemp2 = self.target2;
			ttemp3 = self.target3;
			ttemp4 = self.target4;
			self.target = self.path;
			self.target2 = self.target3 = self.target4 = string_null;
			self.message = self.group;
			SUB_UseTargets();
			self.target = ttemp1;
			self.target2 = ttemp2;
			self.target3 = ttemp3;
			self.target4 = ttemp4;
			self.message = mtemp;
		}
	}
};

void() trigger_interupt =
{
	if (self.sounds == 1)
		self.noise = "doors/basetry.wav";
	else if (self.sounds == 2)
		self.noise = "doors/medtry.wav";
	else if (self.sounds == 3)
		self.noise = "doors/runetry.wav";
	if(self.noise)
		precache_sound(self.noise);

	self.touch = interupt_touch;
	self.use = interupt_use;

	InitTrigger ();
};

//##########################################
//#### Foot Steps                        ###
//##########################################

void(string stepsound, float chancea, float vola, float volb) FootFall =
{
	if (checkbottom(self) == FALSE)
		return;

	if(self.waterlevel != 0)
	{
		vola = vola*0.5;
		volb = volb*0.5;
	}
	if(random() < chancea)
		sound (self, 5, stepsound, vola, ATTN_NORM);
	else
		sound (self, 5, stepsound, volb, ATTN_NORM);
};


//##########################################
//#### Dummy Player (false avatar)       ###
//##########################################

void() dummy_think=
{
	if (self.flags & FL_GODMODE)
	{
		if (!(self.owner.flags & FL_GODMODE))
			self.flags = self.flags - FL_GODMODE;
	}
	else if (self.owner.flags & FL_GODMODE)
		self.flags = self.flags | FL_GODMODE;
	if(self.owner.trigger_field != self)
		remove(self);
	if(self.owner.flags & FL_ONGROUND)
		self.owner.flags = self.owner.flags - (self.owner.flags & FL_ONGROUND);
	droptofloor();
};

void() dummy_standb1= [	12, dummy_standb2 ] {dummy_think();};
void() dummy_standb2= [	13, dummy_standb3 ] {dummy_think();};
void() dummy_standb3= [	14, dummy_standb4 ] {dummy_think();};
void() dummy_standb4= [	15, dummy_standb5 ] {dummy_think();};
void() dummy_standb5= [	16, dummy_standb1 ] {dummy_think();};

void() dummy_stand1= [	17, dummy_stand2 ] {dummy_think();};
void() dummy_stand2= [	18, dummy_stand3 ] {dummy_think();};
void() dummy_stand3= [	19, dummy_stand4 ] {dummy_think();};
void() dummy_stand4= [	20, dummy_stand5 ] {dummy_think();};
void() dummy_stand5= [	21, dummy_stand6 ] {dummy_think();};
void() dummy_stand6= [	22, dummy_stand7 ] {dummy_think();};
void() dummy_stand7= [	23, dummy_stand8 ] {dummy_think();};
void() dummy_stand8= [	24, dummy_stand9 ] {dummy_think();};
void() dummy_stand9= [	25, dummy_stand10] {dummy_think();};
void() dummy_stand10= [	26, dummy_stand11] {dummy_think();};
void() dummy_stand11= [	27, dummy_stand12] {dummy_think();};
void() dummy_stand12= [	28, dummy_stand1 ] {dummy_think();};

void() dummy_pain1= [	29, dummy_pain2 ] {dummy_think();};
void() dummy_pain2= [	30, dummy_pain3 ] {dummy_think();};
void() dummy_pain3= [	31, dummy_pain4 ] {dummy_think();};
void() dummy_pain4= [	32, dummy_pain5 ] {dummy_think();};
void() dummy_pain5= [	33, dummy_pain6 ] {dummy_think();};
void() dummy_pain6= [	34, dummy_stand1] {dummy_think();};

void(entity attacker, float damage) dummy_pain=
{
	T_Damage(self.owner, attacker, attacker, damage);

	self.owner.items = self.items;
	self.owner.armorvalue = self.armorvalue;
	self.owner.armortype = self.armortype;
	self.enemy = attacker;

	if (self.weapon == IT_AXE)
		player_axpain1 ();
	else
		player_pain1 ();
};

void() dummy_finalthink=
{
	setorigin(self.owner, self.origin);
	remove(self);
};

void(entity dummy) dummy_lastright=
{
	dummy.frame = 0;
	setmodel(dummy, "progs/s_null.spr");
	dummy.solid = SOLID_NOT;
	dummy.movetype = MOVETYPE_NONE;
	setsize(dummy, '0 0 0', '0 0 0');
	dummy.nextthink = time + 0.1;
	dummy.think = dummy_finalthink;
};

void(entity dummy_owner) dummy_remove;
void() dummy_die=
{
	local entity kilt, kilr;
	
	self.owner.apocflags = self.apocflags;
	self.owner.health = self.health;
	kilt = self.owner;
	kilr = damage_attacker;
	dummy_remove(kilt);
	Killed (kilt, kilr);
};

// sets up the player so that he's ready to be placed
// as a camera, and also sets up a dummy player to make
// it appear as though the player is still there.
void(entity dummy_owner, float dummywalk, float dummynodmg) dummy_setup=
{
	local entity dummy, tmpent;
	
	// first setup player so his position won't conflict
	// with the dummy's when it is made.
	dummy_owner.apocflags = dummy_owner.apocflags | VIEW_RCAM;
	dummy_owner.dest1 = dummy_owner.angles;
	dummy_owner.solid = SOLID_NOT;
	dummy_owner.frame = 0;
	dummy_owner.takedamage = DAMAGE_YES;
	dummy_owner.solid = SOLID_NOT;
	dummy_owner.movetype = MOVETYPE_FLY;
	
	// now make the actual dummy
	dummy = spawn();
	dummy.classname = "dummy_player";
	if(dummynodmg)
		dummy.takedamage = DAMAGE_NO;
	else
		dummy.takedamage = DAMAGE_AIM;
	dummy.solid = SOLID_SLIDEBOX;
	dummy.movetype = MOVETYPE_STEP;
	setmodel(dummy, "progs/player.mdl");
	setsize (dummy, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(dummy, dummy_owner.origin);
	dummy.view_ofs = '0 0 22';
	dummy.frame = 17;
	dummy.angles = dummy_owner.dest1;
	dummy.health = dummy_owner.health;
	dummy.armorvalue = dummy_owner.armorvalue;
	dummy.armortype = dummy_owner.armortype;
	dummy.items = dummy_owner.items;
	dummy.owner = dummy_owner;
	dummy.skin = dummy_owner.skin;
	dummy.colormap = dummy_owner.colormap;
	dummy.team = dummy_owner.team;
	dummy.apocflags = dummy_owner.apocflags;
	dummy.th_pain = dummy_pain;
	dummy.th_die = dummy_die;
	dummy.walkframe = dummywalk;
	if(dummywalk == 0)
		dummy.think = dummy_stand1;
	else
		dummy.think = dummy_standb1;
	dummy.nextthink = time + 0.1;
	
	// do final setup to the player
	dummy_owner.view_ofs = '0 0 0.1';
	dummy_owner.frame = 0;
	dummy_owner.trigger_field = dummy;
	dummy_owner.modelindex = modelindex_null;
	setsize (dummy_owner, '0 0 0', '0 0 0');

	// replace dummy as the enemy for things attacking the player
	tmpent = nextent(world);
	while(tmpent)
	{
		if(tmpent.enemy == dummy_owner)
			tmpent.enemy = dummy;
		tmpent = nextent(tmpent);
	}
};

// this reinits the player to be a player again, and kills the dummy
void(entity dummy_owner) dummy_remove=
{
	local entity dummy, tmpent;
	local vector dorg, dangles;
	
	dummy = dummy_owner.trigger_field;
	dorg = dummy.origin;
	dangles = dummy.angles;

	// set dummy enemys back to the player
	tmpent = nextent(world);
	while(tmpent)
	{
		if(tmpent.enemy == dummy)
			tmpent.enemy = dummy_owner;
		tmpent = nextent(tmpent);
	}
	dummy_lastright(dummy);
	dummy_owner.trigger_field = world;
	dummy_owner.pausetime = time + 0.2;

	dummy_owner.apocflags = dummy_owner.apocflags - (dummy_owner.apocflags & VIEW_RCAM);

	msg_entity = dummy_owner;
	WriteByte (MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle( MSG_ONE, dangles_x); 
	WriteAngle( MSG_ONE, dangles_y);
	WriteAngle( MSG_ONE, dangles_z);

	setorigin(dummy_owner, dorg);

	dummy_owner.takedamage = DAMAGE_AIM;
	dummy_owner.solid = SOLID_SLIDEBOX;
	dummy_owner.movetype = MOVETYPE_WALK;
	dummy_owner.modelindex = modelindex_player;
	dummy_owner.view_ofs = '0 0 22';
	setsize (dummy_owner, VEC_HULL_MIN, VEC_HULL_MAX);
};

//##########################################
//#### Remote Camera                     ###
//##########################################

void() rcam_use=
{
	local entity tempself;

	if(!(activator.flags & FL_CLIENT))
		return;

	// make sure that external view is off
	if(activator.cament)
	{
		tempself = self;
		self = activator;
		Cam_toggle();
		self = tempself;
	}

	// move the player on to the next camera in the loop
	if(self.target2 != string_null && self.target2 != "end" && (activator.apocflags & NEXT_RCAM))
	{
		local entity nextcam;
		
		activator.apocflags = activator.apocflags - (activator.apocflags & NEXT_RCAM);
		nextcam = find(world, targetname, self.target2);
		// couldn't find next camera, so make this the end of the loop
		if(nextcam.classname != "func_remote_cam")
		{
			// print out an error to let people know an error happened
			bprint("Next camera in loop,");
			bprint(self.target2);
			bprint(", not found");

			self.target2 = "end";
			rcam_use();
			return;
		}

		setmodel(self, self.mdl);

		activator.rcam = nextcam;
		if(nextcam.spawnflags & RCAM_FREEZE)
			activator.apocflags = activator.apocflags | VIEW_SETVIEWANGLE;
		else
			activator.apocflags = activator.apocflags -(activator.apocflags & VIEW_SETVIEWANGLE);
		activator.weaponmodel = nextcam.spawnmodel;
		setorigin(activator, nextcam.origin);
		msg_entity = activator;
		WriteByte (MSG_ONE, SVC_SETVIEWANGLES);
		WriteAngle( MSG_ONE, nextcam.idealpitch);
		WriteAngle( MSG_ONE, nextcam.angles_y);
		WriteAngle( MSG_ONE, nextcam.angles_z);
		if(nextcam.message)
			centerprint(activator, nextcam.message);
		if(nextcam.model == nextcam.mdl)
		{
			nextcam.frame = 0;
			setmodel(nextcam, "progs/s_null.spr");
			setmodel(activator, nextcam.mdl);
		}
		else
		{
			activator.frame = 0;
			setmodel(activator, "progs/s_null.spr");
		}
		return;
	}
	activator.apocflags = activator.apocflags - (activator.apocflags & NEXT_RCAM);

	if(activator.rcam != self) // activate camera view
	{
		activator.rcam = self;
		if(self.spawnflags & RCAM_FREEZE)
			activator.apocflags = activator.apocflags | VIEW_SETVIEWANGLE;
		activator.weaponmodel = self.spawnmodel;

		dummy_setup(activator, self.walkframe, (self.spawnflags & RCAM_NODMG));
		setorigin(activator, self.origin);
		
		// do initial view angle setup
		msg_entity = activator;
		WriteByte (MSG_ONE, SVC_SETVIEWANGLES);
		WriteAngle( MSG_ONE, self.idealpitch);
		WriteAngle( MSG_ONE, self.angles_y);
		WriteAngle( MSG_ONE, self.angles_z);
		
		//display message to player if there is one
		if(self.message)
			centerprint(activator, self.message);

		// don't let the camera model get in the way of the view
		if(self.model == self.mdl)
		{
			setmodel(self, "progs/s_null.spr");
			activator.frame = 0;
			setmodel(activator, self.mdl);
		}		
	}
	else // deactivate camera view
	{
		local entity tmpent;

		activator.apocflags = activator.apocflags  - (activator.apocflags & VIEW_SETVIEWANGLE);
		activator.rcam = world;
		dummy_remove(activator);

		tmpent = self;
		self = activator;
		W_SetCurrentAmmo();
		self = tmpent;

		if(activator.cament)
		{
			msg_entity = activator;
			WriteByte (MSG_ONE, SVC_SETVIEWPORT);
			WriteEntity (MSG_ONE, activator.cament);
			stuffcmd(activator, "cl_bob 0\n");
		}
		else
		{
			msg_entity = activator;
			WriteByte (MSG_ONE, SVC_SETVIEWPORT);
			WriteEntity (MSG_ONE, activator);
			stuffcmd(activator, "cl_bob 0.02\n");
		}
		
		// make sure that it remains looking like a camera
		setmodel(self, self.mdl);
	}
};

void() rcam_use_all=
{
	local entity tmpent;

	tmpent = world;
	do
	{
		tmpent = nextent(tmpent);
		if(tmpent.flags & FL_CLIENT)
		{
			activator = tmpent;
			rcam_use();
		}
	} while(tmpent);
};

void() rcam_move=
{
	setorigin(self, self.movetarget.origin + self.pos1);
	self.velocity = self.movetarget.velocity;
	self.nextthink = time + self.search_time;
};

void() rcam_track=
{
	local vector tmpveca;

	tmpveca = self.origin - self.goalentity.origin;
	tmpveca = vectoangles(tmpveca);
	tmpveca_y = tmpveca_y - 180;
	camanglesmod(tmpveca);

	if(self.spawnflags & RCAM_MOVING)
		rcam_move();

	self.nextthink = time + self.search_time;
};

void() rcam_setup=
{
	local vector tmpvec;
	local entity tmpent;

	if(self.target)
	{
		tmpent = find(world, targetname, self.target);
		tmpvec = self.origin - tmpent.origin;
		self.angles = vectoangles(tmpvec);
		self.angles_y = self.angles_y - 180;
		self.goalentity = tmpent;

		if(self.spawnflags & RCAM_SMOOTH)
			self.search_time = 0.05;
		else
			self.search_time = 0.1;
	}
	else if(self.spawnflags & RCAM_TRACKING)
		objerror ("a target is needed for a tracking cam\n");

	if(self.spawnflags & RCAM_MOVING)
	{
		if(self.path)
			tmpent = find(world, targetname, self.path);
		else
			objerror ("a path is needed for a moving cam\n");
		self.movetarget = tmpent;
		self.movetype = MOVETYPE_FLY;
		setsize(self, '0 0 0', '0 0 0');
		if(self.pos1 == '-1 -1 -1')
			self.pos1 = tmpent.origin - self.origin;
		setorigin(self, self.movetarget.origin + self.pos1);
	}

	if(self.spawnflags & RCAM_TRACKING)
	{
		self.think = rcam_track;
		self.nextthink = time + 1;
	}
	else if(self.spawnflags & RCAM_MOVING)
	{
		self.think = rcam_move;
		self.nextthink = time + 1;
	}
	else
		self.think = SUB_Null;

	if(self.spawnflags & RCAM_ALL)
		self.use = rcam_use_all;
	else
		self.use = rcam_use;
};

void() func_remote_cam=
{
	precache_model ("progs/s_null.spr");
	if(self.spawnmodel)
		precache_model (self.spawnmodel);

	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize(self, '0 0 0', '0 0 0');

	if(self.model)
	{
		precache_model (self.model);
		setmodel(self, self.model);
	}
	else
		setmodel(self, "progs/s_null.spr");
		
	self.mdl = self.model;
	
	// make sure player doesn't just end up leaving a camera loop
	if(self.target2)
		self.spawnflags = self.spawnflags - (self.spawnflags & RCAM_EXITABLE);

	self.walkframe = 0;
	
	camanglesmod(self.angles);

	self.think = rcam_setup;
	self.nextthink = time + 0.2;
};

void() rcam_impulse_controls=
{
	// for trigger_impulse
	if(impulse_triggers)
	{
		local entity t, stemp;
		t = find(world, classname, "trigger_impulse");
		while(t)
		{
			// make sure that the impulses match
			if(self.impulse == t.impulse)
			{
				activator = stemp = self;
				self = t;
				self.use();
				self = stemp;
			}
			t = find(t, classname, "trigger_impulse");
		}
	}
	
	// for trigger_touch_impulse
	if(self.imp_touch > time)
	{
		local entity t, stemp;
		local vector testmin, testmax;
		t = find(world, classname, "trigger_touch_impulse");
		while(t)
		{
			// make sure that the impulses match
			if(self.impulse == t.impulse)
			{
				// make sure the player (or his dummy) is actually touching it
				if(self.trigger_field)
				{
					testmin = self.trigger_field.absmin;
					testmax = self.trigger_field.absmax;
				}
				else
				{
					testmin = self.absmin;
					testmax = self.absmax;
				}

				if(self.absmin_x < t.absmax_x &&
					self.absmax_x > t.absmin_x)
				{
					if(self.absmin_y < t.absmax_y &&
						self.absmax_y > t.absmin_y)
					{
						if(self.absmin_z < t.absmax_z &&
							self.absmax_z > t.absmin_z)
						{
							activator = self;
							stemp = self;
							self = t;
							self.use();
							self = stemp;
						}
					}
				}
			}
			t = find(t, classname, "trigger_touch_impulse");
		}
	}

	self.impulse = 0;
};

//##########################################
//#### Combination Trigger               ###
//##########################################

void() trigger_combo_use=
{
	//update currently set combo
	if(lastnameused == self.targetname)
	{
		if(self.currentammo & 1)
			self.currentammo = self.currentammo - 1;
		else
			self.currentammo = self.currentammo | 1;

		if(self.noise1)
			SUB_UseName(self.noise1);
	}
	else if(lastnameused == self.targetname2)
	{
		if(self.currentammo & 2)
			self.currentammo = self.currentammo - 2;
		else
			self.currentammo = self.currentammo | 2;

		if(self.noise2)
			SUB_UseName(self.noise2);
	}
	else if(lastnameused == self.targetname3)
	{
		if(self.currentammo & 4)
			self.currentammo = self.currentammo - 4;
		else
			self.currentammo = self.currentammo | 4;

		if(self.noise3)
			SUB_UseName(self.noise3);
	}
	else if(lastnameused == self.targetname4)
	{
		if(self.currentammo & 8)
			self.currentammo = self.currentammo - 8;
		else
			self.currentammo = self.currentammo | 8;

		if(self.noise4)
			SUB_UseName(self.noise4);
	}

	// check if correct combo is set
	if(self.currentammo == self.spawnflags)
	{
		if(self.noise)
			sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
		SUB_UseTargets();
		remove(self);
	}
};

void() trigger_combo=
{
	self.currentammo = 0;

	if(self.spawnflags > 15)
		objerror("inappropriate combination flags set");

	if(self.noise)
		precache_sound (self.noise);

	self.use = trigger_combo_use;
};

//##########################################
//#### Sequence trigger                  ###
//##########################################

void() trigger_sequence_use=
{
	local float seqfail;

	seqfail = FALSE;

	if(lastnameused == self.targetname)
	{
		if(self.currentammo == 0)
			self.currentammo = 1;
		else
			seqfail = TRUE;
	}
	else if(lastnameused == self.targetname2)
	{
		if(self.currentammo == 1)
			self.currentammo = 2;
		else
			seqfail = TRUE;
	}
	else if(lastnameused == self.targetname3)
	{
		if(self.currentammo == 2)
			self.currentammo = 3;
		else
			seqfail = TRUE;
	}
	else if(lastnameused == self.targetname4)
	{
		if(self.currentammo == 3)
			self.currentammo = 4;
		else
			seqfail = TRUE;
	}

	if(seqfail)
	{
		if(self.spawnflags & SEQ_FAILRESET)
			self.currentammo = 0;

		if(self.event)
			SUB_UseName(self.event);

		if(self.noise2)
			sound (self, CHAN_AUTO, self.noise2, 1, ATTN_NORM);
	}
	else if(self.currentammo = self.weapon)
	{
		SUB_UseTargets();

		if(self.noise)
			sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);

		if(self.spawnflags & SEQ_MULTIPLE)
			self.currentammo = 0;
		else
			remove(self);
	}
	else if(self.noise1)
		sound (self, CHAN_AUTO, self.noise1, 1, ATTN_NORM);
};

void() trigger_sequence=
{
	if(self.noise) // sequence complete sound
		precache_sound (self.noise);
	if(self.noise1) // successful progress sound
		precache_sound (self.noise1);
	if(self.noise2)// sequence failed sound
		precache_sound (self.noise2);

	if(self.targetname4)
		self.weapon = 4;
	else if(self.targetname3)
		self.weapon = 3;
	else if(self.targetname2)
		self.weapon = 2;
	else
		self.weapon = 1;

	self.currentammo = 0; // used to keep track of sequence

	self.use = trigger_sequence_use;
};


//##########################################
//#### GLASS                            ####
//##########################################

void(entity attacker, float damage)	glass_pain =
{
// check if one hit is required to break it
	if(self.spawnflags & GLASS_ONEHIT)
		self.health = self.max_health;
};

void() glass_die=
{
	local entity new;
	local vector tmpvec;
	local vector tmpmin, tmpmax, tmpsize;

	while(self.color > 0)
	{
		new = spawn();
		new.origin = self.origin;
		if(random() < 0.33)
			setmodel (new, "progs/rubble3.mdl" );
		else if(random() < 0.5)
			setmodel (new, "progs/rubble2.mdl" );
		else
			setmodel (new, "progs/rubble1.mdl" );
		setsize (new, '0 0 0', '0 0 0');
		new.velocity_x = 70 * crandom();
		new.velocity_y = 70 * crandom();
		new.velocity_z = 140 + 70 * random();
		new.movetype = MOVETYPE_BOUNCE;
		new.solid = SOLID_BBOX;
		new.avelocity_x = random()*600;
		new.avelocity_y = random()*600;
		new.avelocity_z = random()*600;
		new.nextthink = time + 2 + random()*3;
		new.think = SUB_Remove;
		new.skin = 11;

		self.absmin = self.origin + self.mins;
		self.absmax = self.origin + self.maxs;
		tmpvec_x = self.absmin_x + (random() * (self.absmax_x - self.absmin_x));
		tmpvec_y = self.absmin_y + (random() * (self.absmax_y - self.absmin_y));
		tmpvec_z = self.absmin_z + (random() * (self.absmax_z - self.absmin_z));

		setorigin(new, tmpvec);

		self.color = self.color - 1;
	}
	if(self.noise2)
		sound (self , CHAN_VOICE, self.noise2, 1, ATTN_NORM);

	if(self.event)
		SUB_UseName(self.event);

	remove(self);
};

void () blocker_use;
void() func_glass=
{
	local vector tmpvec;
	local float tmpflt;

	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	self.mdl = self.model;
	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);
	setorigin (self, self.origin);

	self.model = string_null;

	precache_sound ("misc/null.wav");

// setup stuff for the glass being broken
	if(self.health > 0)
	{
		if(!self.color)
		{
			tmpvec = self.maxs - self.mins;
			tmpvec = tmpvec * 0.031; //(divide by about 32)
			if(tmpvec_x < 1)
				tmpvec_x = 1;
			if(tmpvec_y < 1)
				tmpvec_y = 1;
			if(tmpvec_z < 1)
				tmpvec_z = 1;
			self.color = tmpvec_x * tmpvec_y * tmpvec_z;
		}
		else if(self.color == -1)
			self.color = 0;
		if(self.color > 16) // max number of chunks
			self.color = 16;
		self.takedamage = DAMAGE_YES;
		self.max_health = self.health;
		self.th_die  = glass_die;
		self.th_pain = glass_pain;
		precache_model( "progs/rubble1.mdl" );
		precache_model( "progs/rubble2.mdl" );
		precache_model( "progs/rubble3.mdl" );
	}

// setup as either moving or togglable
	if(self.target) // move like a train
	{
		if (!self.speed)
			self.speed = 100;
		if (!self.dmg)
			self.dmg = 2;

		if (self.sounds == 1)
		{
			if(!self.noise)
				self.noise = ("plats/train2.wav");
			if(!self.noise1)
				self.noise1 = ("plats/train1.wav");

			precache_sound( self.noise );
			precache_sound( self.noise1 );
		}

		self.cnt = 1;
		self.blocked = train_blocked;
		self.use = train_use;

		if(self.spawnflags & GLASS_SMOOTH)
		{
			self.classname = "smtrain";
			self.think = func_smtrain_setup;
		}
		else
		{
			self.classname = "train";
			self.think = func_train_find;
		}

		self.nextthink = self.ltime + 0.6;
	}
	else // move like a togglable wall
	{
		self.use = 	blocker_use;

		if ( self.spawnflags & GLASS_STARTOFF )
		{
			self.state = 0;
			setorigin( self, self.origin + '8000 8000 8000' );
		}
		else
		{
			self.state = 1;
			if(self.noise1)
				sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
		}
	}

	if ( !self.noise ) // move sound
		self.noise = ("misc/null.wav");
	if ( !self.noise1 ) // stop sound
		self.noise1 = ("misc/null.wav");
	if ( !self.noise2 ) // break sound
		self.noise2 = ("misc/shatter.wav");

	precache_sound( self.noise );
	precache_sound( self.noise1 );
	precache_sound( self.noise2 );
};


//##########################################
//#### STATIC MODEL ENTITY              ####
//##########################################

void() func_model_think=
{
	self.frame = self.frame + 1;
	if(self.frame > self.walkframe+self.count)
		self.frame = self.walkframe;
	self.nextthink = time + self.wait;
};

void() func_model_use=
{
	if(self.think == func_model_think)
	{
		self.think = SUB_Null;
		if(self.weaponframe >= 0)
			self.frame = self.weaponframe;
	}
	else
	{
		self.think = func_model_think;
		func_model_think();
	}
};

void() func_model=
{
	precache_model (self.model);
	setmodel (self, self.model);

	if(!(self.spawnflags & 1))
	{
		makestatic (self);
		return;
	}

	if(self.wait < 0.05)
		self.wait = 0.1;

	if(self.count < 2)
		self.count = 1;
	else
		self.count = self.count - 1;

	if(self.walkframe)
		self.frame = self.walkframe;
	else
		self.frame = self.walkframe = 0;

	if(self.weaponframe == 0)
		self.weaponframe = -1;
	else if(self.weaponframe < 0)
		self.weaponframe = 0;

	self.use = func_model_use;
	
	if(!self.spawnflags & 2)
	{
		self.think = func_model_think;
		self.nextthink = time + self.wait;
	}
	else if(self.weaponframe >= 0)
		self.frame = self.weaponframe;
};


//##########################################
//#### SUBS                              ###
//##########################################

// Vector dot product function
// when used with two normalized vectors,
// gives a fractional number for their
// directional corilation.
float (vector from, vector onto) SUB_Dot = {return from * onto;};

// same as the % operator in regular C
float(float a, float b) mod = {return a - (floor(a / b) * b);};

vector(vector invec, vector refnorm) SUB_ReflectVector=
{
	local vector outvec;
	local float refspeed;


	refspeed = vlen(invec);
	outvec = normalize(invec);
	outvec = outvec+(2*refnorm);
//	outvec = normalize(outvec);
	if (outvec_x > 1) outvec_x = 2 - outvec_x;
	if (outvec_x < -1) outvec_x = -2 - outvec_x;
	if (outvec_y > 1) outvec_y = 2 - outvec_y;
	if (outvec_y < -1) outvec_y = -2 - outvec_y;
	if (outvec_z > 1) outvec_z = 2 - outvec_z;
	if (outvec_z < -1) outvec_z = -2 - outvec_z;

	outvec = outvec * refspeed;
	return outvec;
};

// can pack three values into a single parm# value. each must be from 0 - 255
// there woulda been four in here, but Quake fugges up the decimal part
// of the parm values. >(
float(float parmvala, float parmvalb, float parmvalc) SUB_PackParm=
{
	local float parmout;

	parmout = 0;
	// restrict input values
	parmvala = floor(parmvala);
	parmvalb = floor(parmvalb);
	parmvalc = floor(parmvalc);
	if(parmvala < 0)
		parmvala = 0;
	else if(parmvala > 255)
		parmvala = 255;
	if(parmvalb < 0)
		parmvalb = 0;
	else if(parmvalb > 255)
		parmvalb = 255;
	if(parmvalc < 0)
		parmvalc = 0;
	else if(parmvalc > 255)
		parmvalc = 255;

	// pack the first value
	parmout = parmvala;

	// pack the second value
	parmvalb = parmvalb * 256;
	parmout = parmout + parmvalb;

	// pack the third value
	parmvalc = parmvalc * 65536;
	parmout = parmout + parmvalc;

	return parmout;
};

// unpack one of three values from a single, packed parm# value. each must be from 0 - 255
float(float parmin, float valnum) SUB_UnpackParm=
{
	local float valout;

	valout = 0;

	if(valnum == 1)
	{
		if(parmin < 0)
			parmin = parmin * (-1);

		if(parmin & BIT_1)
			valout = valout + BIT_1;
		if(parmin & BIT_2)
			valout = valout + BIT_2;
		if(parmin & BIT_3)
			valout = valout + BIT_3;
		if(parmin & BIT_4)
			valout = valout + BIT_4;
		if(parmin & BIT_5)
			valout = valout + BIT_5;
		if(parmin & BIT_6)
			valout = valout + BIT_6;
		if(parmin & BIT_7)
			valout = valout + BIT_7;
		if(parmin & BIT_8)
			valout = valout + BIT_8;
	}
	else if(valnum == 2)
	{
		if(parmin < 0)
			parmin = parmin * (-1);

		if(parmin & BIT_9)
			valout = valout + BIT_1;
		if(parmin & BIT_10)
			valout = valout + BIT_2;
		if(parmin & BIT_11)
			valout = valout + BIT_3;
		if(parmin & BIT_12)
			valout = valout + BIT_4;
		if(parmin & BIT_13)
			valout = valout + BIT_5;
		if(parmin & BIT_14)
			valout = valout + BIT_6;
		if(parmin & BIT_15)
			valout = valout + BIT_7;
		if(parmin & BIT_16)
			valout = valout + BIT_8;
	}
	else if(valnum == 3)
	{
		if(parmin < 0)
			parmin = parmin * (-1);

		if(parmin & BIT_17)
			valout = valout + BIT_1;
		if(parmin & BIT_18)
			valout = valout + BIT_2;
		if(parmin & BIT_19)
			valout = valout + BIT_3;
		if(parmin & BIT_20)
			valout = valout + BIT_4;
		if(parmin & BIT_21)
			valout = valout + BIT_5;
		if(parmin & BIT_22)
			valout = valout + BIT_6;
		if(parmin & BIT_23)
			valout = valout + BIT_7;
		if(parmin & BIT_24)
			valout = valout + BIT_8;
	}
	else
	{
		return 0;
		dprint("error unpacking parm value\n");
	}

	return valout;
};

// used to normalize pitch angles for cameras
void(vector vecin) camanglesmod =
{
	// store the angle for view setting
	self.idealpitch = vecin_x;

	// adjust camera's positioning angles
	self.angles_x = anglemod(vecin_x);
	if(self.angles_x > 270)
		self.angles_x = self.angles_x - 360;
	self.angles_x = self.angles_x * (-1);
	self.angles_y = anglemod(vecin_y);
};

//###########################################
//#### PHASED PLASMA CANNON (BEAM WEAPON) ###
//###########################################
// been tones down so that it doesn't require
// as much stuff as the original did.

void()	beamhit1	=	[0,		beamhit2] {};
void()	beamhit2	=	[1,		beamhit3] {};
void()	beamhit3	=	[2,		beamhit4] {};
void()	beamhit4	=	[3,		beamhit5] {};
void()	beamhit5	=	[4,		SUB_Remove] {};

void() BecomeBeamHit =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/beamhit.spr");
	self.solid = SOLID_NOT;
	beamhit1 ();
};

void() beamring1 =	[1,		beamring2] {self.nextthink = time + 0.05;};
void() beamring2 =	[2,		beamring3] {self.nextthink = time + 0.05;};
void() beamring3 =	[4,		beamring4] {self.nextthink = time + 0.05;};
void() beamring4 =	[6,		beamring5] {self.nextthink = time + 0.05;};
void() beamring5 =	[8,		beamring6] {self.nextthink = time + 0.05;};
void() beamring6 =	[10,	beamring7] {self.nextthink = time + 0.05;};
void() beamring7 =	[12,	beamring8] {self.nextthink = time + 0.05;};
void() beamring8 =	[14,	beamring9] {self.nextthink = time + 0.05;};
void() beamring9 =	[16,	SUB_Remove] {self.nextthink = time + 0.05;};

void() d_beamring1 =	[2,		d_beamring2] {};
void() d_beamring2 =	[4,		d_beamring3] {};
void() d_beamring3 =	[8,		d_beamring4] {};
void() d_beamring4 =	[12,	d_beamring5] {};
void() d_beamring5 =	[16,	SUB_Remove] {};

void(vector ringorg) MakeBeamRing =
{
	local entity ringent;
	
	ringent = spawn();
	ringent.movetype = MOVETYPE_NONE;
	setmodel (ringent, "progs/dring.spr");
	ringent.solid = SOLID_NOT;
	setorigin(ringent, ringorg);
	ringent.angles = '90 0 0';
	ringent.frame = 0;
	if(deathmatch)
		ringent.think = d_beamring1;
	else
	{
		ringent.nextthink = time + 0.05;
		ringent.think = beamring1;
	}

	ringent = spawn();
	ringent.movetype = MOVETYPE_NONE;
	setmodel (ringent, "progs/dring.spr");
	ringent.solid = SOLID_NOT;
	setorigin(ringent, ringorg);
	ringent.angles = '-90 0 0';
	ringent.frame = 0;
	if(deathmatch)
		ringent.think = d_beamring1;
	else
	{
		ringent.nextthink = time + 0.05;
		ringent.think = beamring1;
	}
};

void() beam_touch =
{
	local float totaldmg;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;   // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		totaldmg = self.currentammo * 1.25;
		totaldmg = ceil(totaldmg);
		// totally decimate the dude if doesn't have enough health
		if(other.health <= totaldmg)
		{
			T_Damage (other, self, self.owner, 99999);
			if(other.health <= 0)
			{
				MakeBeamRing(other.origin);

				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
				WriteCoord (MSG_BROADCAST, other.origin_x);
				WriteCoord (MSG_BROADCAST, other.origin_y);
				WriteCoord (MSG_BROADCAST, other.origin_z);

				remove(self);
				return;
			}
		}
		else
			T_Damage (other, self, self.owner, totaldmg);
	}

	sound (self, CHAN_ITEM, "turret/beamhit.wav", 1, ATTN_NORM);
	BecomeBeamHit();
};

void(float burstcharge) beam_water_burst=
{
	local entity current;
	local float totaldmg;
	local vector destvec;

	current = world;

	sound (self, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
	do
	{
		current = nextent(current);

		if (current.takedamage)
		{
//			destvec = current.origin + (current.mins + current.maxs)*0.5;
			destvec = current.origin;
			traceline(self.origin, destvec, TRUE, self);
			if(trace_fraction == 1 && current.waterlevel > 0)
			{
				totaldmg = vlen(self.origin - destvec) * 0.3;
				totaldmg = burstcharge * burstcharge / totaldmg;
				// check to see if the thing gets killed
				if(current.health <= totaldmg)
				{
					T_Damage (current, self, self, 99999);
					if(other.health <= 0)
					{
						MakeBeamRing(other.origin);

						WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
						WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
						WriteCoord (MSG_BROADCAST, other.origin_x);
						WriteCoord (MSG_BROADCAST, other.origin_y);
						WriteCoord (MSG_BROADCAST, other.origin_z);
					}
				}
				else
					T_Damage (current, self, self, totaldmg);
			}
		}
	} while(current);
};

void() beam_generate=
{
	local entity beamseg;

	beamseg = spawn ();
	beamseg.owner = self.owner;
	beamseg.solid = SOLID_BBOX;
	setmodel (beamseg, "progs/beam.mdl");
	setsize (beamseg, '0 0 0', '0 0 0');
	makevectors(self.owner.v_angle);
	if(self.owner.flags & FL_CLIENT)
	{
		self.owner.attack_finished = time + 0.5;
		setorigin (beamseg, self.owner.origin + v_forward*12 + self.owner.dest2);
		beamseg.velocity = aim(self.owner, 800) * 800;
	}
	else if(self.owner.flags & FL_MONSTER)
	{
		setorigin (beamseg, self.owner.origin);
		beamseg.velocity = normalize(self.owner.enemy.origin - self.owner.origin) * 800;
	}
	else
	{
		setorigin (beamseg, self.owner.origin);
		beamseg.velocity = self.owner.movedir * 800;
	}

	beamseg.angles = vectoangles(beamseg.velocity);
	beamseg.speed = 800;
	beamseg.classname = "beam";
	beamseg.movetype = MOVETYPE_FLYMISSILE;
	beamseg.currentammo = self.currentammo;
	beamseg.touch = beam_touch;
	beamseg.think = SUB_Remove;
	beamseg.nextthink = time + 6;

	sound (self.owner, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);

	self.currentammo = self.currentammo / 2;

	if((self.owner.flags & FL_CLIENT) && self.deadflag == DEAD_NO)
	{
		self.owner.punchangle_x = -6;
		self.owner.velocity = self.velocity - v_forward * self.currentammo * 2;
	}

	if(self.currentammo < 1)
		remove(self);

	self.nextthink = time + 0.05;
};

void() W_FireBeam =
{
// explode if under water
	if (self.waterlevel > 1)
	{
		beam_water_burst(self.ammo_cells*2);
		self.currentammo = self.ammo_cells = 0;
		return;
	}

	newmis = spawn();
	newmis.solid = SOLID_NOT;
	newmis.movetype = MOVETYPE_FLY;
	// amount of damage done is based apong how much cell ammo you've got
	newmis.currentammo = self.currentammo;
	setorigin(newmis, self.origin);
	newmis.owner = self;
	newmis.think = beam_generate;
	newmis.nextthink = time + 0.05;

	// like the damage, the ammo used is according to how much you've got
	self.currentammo = self.ammo_cells = floor(self.ammo_cells * 0.75);
};

//##########################################
//#### TIME LIMIT CHECKER                ###
//##########################################
// This replaces the old rule checking (which was
// done every frame) with a much faster equivelent
// that only checks it once a second.

void() TimeThink =
{
	local float timelimit;

	timelimit = cvar("timelimit") * 60;
	if (time >= timelimit)
		NextLevel ();
	self.nextthink = time + 1.0;
};

void() TimeMake =
{
	local entity timechecker;
	local float timelimit;

	// don't bother checking timelimit if there isn't one
	timelimit = cvar("timelimit");
	if(!timelimit)
		return;

	timechecker = spawn ();
	timechecker.classname = "timechecker";
	timechecker.think = TimeThink;
	timechecker.nextthink = time + 0.2;
};
