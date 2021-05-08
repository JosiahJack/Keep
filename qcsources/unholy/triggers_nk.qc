
float TRIGGER_RELAY = 1;

/*QUAKED trigger_interval (.5 .5 .5) (-8 -8 -8) (8 8 8)
*/

void () interval_use =
{
	SUB_UseTargets();
	self.nextthink = time + self.wait;
};

void() trigger_interval =
{	
	if (!self.wait) self.wait = 5;
	self.think = self.use = interval_use;
};

/*QUAKED trigger_aircushion
Make the player land smoothly with no damage
*/
void() trigger_aircushion_touch =
{
	float h;
	
	if(self.inactive == TRUE)
		return;
	
	if(other.classname != "player")
		return;
	
	if (self.jump_flag==0 && other.velocity_z < -650)
	{
		self.jump_flag = 1;
		self.health = other.absmin_z - self.absmin_z; //Actually storing the starting distance at first contact, from which the velocity will decrease from its initial value to 0
		//jbprint("self.health==",ftos(self.health),"\n");
	}
	
	//if (self.jump_flag==1) jbprint("trigger_softfall_touch: self.jump_flag==",ftos(self.jump_flag)," ; other.velocity_z==",ftos(other.velocity_z),"\n");
	
	if (self.jump_flag==1 && other.velocity_z < 0)
	{
		h = other.absmin_z - self.absmin_z;
		
		//jbprint("Reducing other.velocity_z from v=",ftos(other.velocity_z)," to v/(",ftos(self.health)," pow 2) x ",ftos(h)," pow 2 =",ftos(other.velocity_z / (self.health*self.health) * h * h),"\n");
		
		other.velocity_z = other.velocity_z / (self.health*self.health) * h * h;
		other.jump_flag = other.velocity_z;
	}

	if (self.jump_flag==1 && other.velocity_z > -10)
	{
		self.jump_flag = 0;
		sound (other, CHAN_AUTO, "misc/whoosh.wav", 1, ATTN_NORM);
	}
	
};

void() trigger_aircushion =
{
	InitTrigger ();
	precache_sound ("misc/whoosh.wav");
	self.touch = trigger_aircushion_touch;
};

/*QUAKED trigger_random
Randomly triggers only one of its targets
===================
FIELDS
*/
float RANDOM_CONSUME = 1;

void trigger_random_use ()
{
	local entity targ;

	//First pass: count the number of current targets
	self.count=0;
	if (self.target)
	{
		targ = world;
		do
		{
			targ = find (targ, targetname, self.target);
			if (!targ) break;
			self.count += 1;
		} while (1);
	}

	//Second pass: choose a random target and fire it
	if (self.count>0)
	{
		//Choose a random target
		float chosen_num, current_num;
		chosen_num = rint(random(1,self.count));

		//Find it
		current_num = 0;
		targ = world;
		do
		{
			targ = find (targ, targetname, self.target);
			if (!targ) break;
			current_num += 1;
		} while (current_num<chosen_num);

		//Fire it
		string oldtargetname = self.target;
		self.target = targ.targetname = ftos(self.waterlevel);
		SUB_UseTargets();
		self.target = targ.targetname = oldtargetname;
		if(self.spawnflags&RANDOM_CONSUME) targ.targetname = ""; //This target is no longer able to be fired
	}
}

void trigger_random ()
{
	self.waterlevel=random(1,32767);
	self.use = trigger_random_use;
}

/*QUAKED trigger_message_transfer (.5 .5 .5) ?
Special case- will player it's message and transfer it's activating trigger's next target to it's target.
Does NOT activate it's target, only transfers the name to the activating trigger
These triggers also cannot be deactivated by touch
===================
FEILDS
.message = A message to display when used.
*/
void trigger_message_transfer_do () { self.enemy.target=self.target; }

void trigger_message_transfer_use ()
{
	if (self.message) centerprint(player, self.message);
	
	self.enemy=other;
	self.nextthink = time + 0.1;
	self.think = trigger_message_transfer_do;
}

void trigger_message_transfer ()
{
	InitTrigger();
	self.use=trigger_message_transfer_use;

}


//=============================================================================


/*QUAKED trigger_aim
A volume trigger fired only if while touching it the player is also looking at any entity with the same netname as this trigger
*/
void() aim_touch =
{
	vector player_eyes, torigin, aim;

	if (other.classname != "player")
		return;

	//Check for every target to know whether it is in the player's "facing cone"
	entity t = world;
	do
	{
		t = find (t, netname, self.map);
		if (!t) return;

		makevectors (other.v_angle);
		player_eyes = other.origin + other.view_ofs;
		
		if(t.origin=='0 0 0')
			torigin = (t.absmin+t.absmax)*0.5;
		else
			torigin = t.origin;
		
		aim = torigin - player_eyes;
		if (normalize(v_forward) * normalize(aim) < self.ideal_yaw)
			continue;		// not in the facing cone

		//In the facing cone, but is it directly visible ?
		traceline(player_eyes, torigin, FALSE, self);
		if(trace_ent==t || trace_ent==player) break;
		
	} while(TRUE);
	
	//jdprint("Saw ");jdprint(trace_ent.classname);jdprint(".");jdprint(trace_ent.targetname);jdprint(" at ");jdprint(vtos(torigin));jdprint("\n");
	
	self.enemy = other;
	multi_trigger ();
};

void() trigger_aim =
{
	InitTrigger ();
	self.map=self.netname;
	self.netname=string_null;
	self.touch = aim_touch;
};

//=============================================================================
void SetBackgroundDarker() { stuffcmd(player, "v_cshift 0 0 0 80\n"); }
void SetBackgroundNormal() { stuffcmd(player, "v_cshift 0 0 0 0\n"); }
//=============================================================================

float found_privates;
float total_privates;

void() count_privates_printmessage =
{
	if(self.rad_time <= 0)
	{
		SetBackgroundNormal();
		remove(self);
		return;
	}
	
	SetBackgroundDarker();
	centerprint(player,self.map,"\n\n\nRetrieved: ",ftos(found_privates),"/",ftos(total_privates));
	self.rad_time--;
	
	self.think = count_privates_printmessage;
	self.nextthink = time + 1.5;
};

void() count_privates_use =
{
	self.count = self.count - 1;
	if (self.count < -0.5)
		return;
	
	if (self.count > 0) return; //Not all the required privates have been "found" (well... killed actually!)
	
	found_privates += self.frags;
	
	self.map=self.message;
	self.message="";
	SUB_UseTargets();
	
	self.rad_time = 3;
	count_privates_printmessage();
};

void() count_privates_touch =
{
	if(other.classname!="player") return;
	count_privates_use();
};

/*QUAKED trigger_count_privates (.5 .5 .5) ? nomessage
A modifier trigger_counter specifically for counting the retrieved soldiers in in mod Church of the Unholy and display the appropriate messages
After the counter has been triggered "count" times (default 1), it will fire all of it's targets and remove itself.
*/
void() trigger_count_privates =
{
	InitTrigger ();

	self.wait = -1;
	if (!self.count) self.count = 1;
	self.frags = self.count;
	
	if(self.targetname)
		self.use = count_privates_use;
	else
		self.touch = count_privates_touch;

	total_privates = total_privates + self.count;
};

/*QUAKED trigger_action (.5 .5 .5)
Run one of its target's 'action' methods
*/

void() trigger_action_use =
{
	if(self.inactive == TRUE)
		return;
	
	entity oself;
	
	if (self.target)
	{
		entity t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t) break;
			
			if(self.spawnflags & 2 && t.action1)
			{
				oself = self;
				self = t;
				t.action1();
				self = oself;
			}
			
			if(self.spawnflags & 4 && t.action2)
			{
				oself = self;
				self = t;
				t.action2();
				self = oself;
			}

		} while(TRUE);
	}

};

void() trigger_action =
{
	InitTrigger ();
	
	if(self.spawnflags & TRIGGER_RELAY)
		self.use = trigger_action_use;
	else
		self.touch = trigger_action_use;
		
};

/*QUAKED trigger_switch (.5 .5 .5)
Switches other triggers, buttons, doors, etc. active/inactive
*/

float SWITCH_ACTIVATE = 0;
float SWITCH_DEACTIVATE = 1;
float SWITCH_TOGGLE = 2;

void() trigger_switch_use =
{
	if(self.inactive == TRUE)
		return;
	
	if (self.target)
	{
		entity t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t) break;

			if(self.impulse == SWITCH_ACTIVATE)
				t.inactive = FALSE;
			else if(self.impulse == SWITCH_DEACTIVATE)
				t.inactive = TRUE;
			else if(self.impulse == SWITCH_TOGGLE)
				t.inactive = 1 - t.inactive;

		} while(TRUE);
	}
};

void() trigger_switch =
{
	InitTrigger ();
	
	if(self.spawnflags & TRIGGER_RELAY)
		self.use = trigger_switch_use;
	else
		self.touch = trigger_switch_use;
};


/*QUAKED trigger_centerprint (.5 .5 .5)
Displays a long text across the screen, during as long as the player stays inside the boundaries of the trigger
*/

void() trigger_centerprint_use =
{
	if(self.inactive == TRUE) return;

	if(self.spawnflags&/*plaque*/2)
	{
		if(!self.spawnflags & TRIGGER_RELAY)
		{
			makevectors (player.v_angle);
			vector viewvec=(self.absmax+self.absmin)*0.5-player.origin;
			if (vlen(viewvec) >= 16 || viewvec*v_forward <= 0) return;
		}
		player.light_lev=1;
		centerprint(player, "/P", self.message);
	}
	else
	{
		if(self.wait > 0 && self.delay == 0) self.delay = time + self.wait;
	
		WriteByte (MSG_ALL, SVC_CENTERPRINT);
		WriteString (MSG_ALL, self.message);
	
		if(time < self.delay)
			self.nextthink = time + 1;
		else
		{
			self.nextthink = -1;
			self.delay = 0;
		}
	}
};

void() trigger_centerprint_touch =
{
	if(other.classname != "player") return;
	
	trigger_centerprint_use();
};

void() trigger_centerprint =
{
	InitTrigger ();
	self.use = trigger_centerprint_use;
	if(!self.spawnflags&/*plaque*/2) self.think = trigger_centerprint_use;
	
	if(!self.spawnflags & TRIGGER_RELAY)
		self.touch = trigger_centerprint_touch;
};


/*QUAKED trigger_teleport_stealth (.5 .5 .5)
Any player touching this will be transported to its twin trigger_teleport_stealth entity with conservation of relative position, movement and facing angles so that the teleportation is unnoticeable.
Any non-player entity seen teleporting by the player would ruin the stealthiness, hence it's player only.
Even so the player would discover the trick if they land in a place where something suddenly appears or disappears.
So carefully use it in places with static geometry only (or even smarter: with connected objects breaking simultaneously in both places :))
Works in pairs with an identical twin trigger_teleport_stealth entity (target) standing in a same looking place in the same position.
If not meant to be one-way only, another pair must be placed 64 units away (too far away for the player to fire both pairs simultaneously);
Both pairs must reference each other through close_target to toggle one each other.
If only one pair is used, there will be no reactivation once used and the trip will be one-way, like if the player started a new map (actually a new submap) with no turning back.
Pay attention to setting to inactive (spawnflags 8) the very first "backward" trigger_teleport_stealth the player will encounter otherwise they will cross the line twice and nothing will have happened for good!
(except a super short 64 units long visit to the destination place!)
===================
FIELDS
.target         Points to an identical trigger_teleport_stealth standing in a same looking place in the same position.
.close_target   Points to another trigger_teleport_stealth standing 64 units away which, once touched, will teleport the player then instantly deactivate itself and reactivate this one.
*/

void() teleport_stealth_touch =
{
	entity	twin;
	string closetarget;

	if (self.inactive)               return;
	if (other.classname != "player") return;

	//Instantly put itself in deactivated mode to be sure it won't fire again before the player has left the volume
	self.inactive=TRUE;
	
	//Fire its targets
	SUB_UseTargets ();
	
	//Find its twin destination
	twin = find (world, targetname, self.target);
	while(twin!=world&&twin.classname!="trigger_teleport_stealth")
		twin = find (twin, targetname, self.target);
	if (!twin) objerror ("couldn't find target");

	//Move the player there smartly
	twin.inactive=TRUE;
	vector offset = other.origin - self.finaldest;
	setorigin (other, twin.finaldest + offset);
	other.flags(-)FL_ONGROUND;
	
	//Find its backward counterpart and set it active to allow the player turning back
	/* close_target not currently supported by QuakeC. Not bothering with it since it won't be used anyway in Unholy
	if(twin.close_target)
	{
		closetarget = twin.close_target;
		twin = find (world, targetname, closetarget);
		while(twin!=world&&twin.classname!="trigger_teleport_stealth")
			twin = find (twin, targetname, closetarget);
		if (twin) twin.inactive=FALSE;
	}
	*/
};

void() trigger_teleport_stealth =
{
	InitTrigger ();
	self.finaldest = (self.absmax+self.absmin)*0.5; //Calculate the trigger's center of gravity
	self.touch = teleport_stealth_touch;
};

/*QUAKED trigger_cleanremains
Removes any dead body, head or gib touching it as long as its netname is "disposable"
=====================================================================================
*/

void() cleanremains_use =
{
	entity disposed;
	entity disposable = find (world, netname, "disposable");
	while (disposable != world)
	{
		if(disposable.health<=0)
		{
			if(disposable.origin_x >= self.absmin_x && disposable.origin_x <= self.absmax_x && disposable.origin_y >= self.absmin_y && disposable.origin_y <= self.absmax_y && disposable.origin_z >= self.absmin_z && disposable.origin_z <= self.absmax_z)
			{
				disposed = disposable;
			}
		}
		disposable = find (disposable, netname, "disposable");
		if(disposed!=world)
		{
			remove(disposed);
			disposed = world;
		}
	}
};

void() trigger_cleanremains =
{
	InitTrigger ();
	self.use = cleanremains_use;
};

/*QUAKED trigger_nonades
Fires its targets if the player touching it has no more grenades
================================================================
*/

void() nonades_use =
{
	if (self.inactive)	return;
	if (other.classname != "player") return;
	if (other.ammo_rockets > 0) return;
	
	//Fire its targets
	SUB_UseTargets ();
	
	self.inactive = TRUE;
};

void() trigger_nonades =
{
	InitTrigger ();
	self.touch = nonades_use;
};

/*QUAKED trigger_setproperty
Changes the value of one of its targets properties
===================
FIELDS
.delay      = delay to wait before actually doing the change
.netname    = the property whose value has to be changed (within a range of preset hard coded choices)
.waterlevel = the new value for the property if it's a float property
.map        = how to inject the value. Ex.: "+" for adding the value, "-" for subtracting it
.angles     = the new value for the property if it's a vector property
.message    = the new value for the property if it's a string property
*/
float SET_ONE_BY_ONE = 1;

void trigger_setproperty_use ()
{
	local entity targ;
	local entity referenced;
	local entity temp;

	if(self.delay)
	{
		self.nextthink = time + self.delay;
		self.wait = self.delay;
		self.delay = 0;
		self.think = trigger_setproperty_use;
		return;
	}
	self.delay = self.wait;

	if (self.target)
	{
		targ = world;
		do
		{
			targ = find (targ, targetname, self.target);
			if (!targ)
				return;

			//button1
			if (self.netname == "button1")
			{
				targ.button1 = self.waterlevel;
			}
			//button2
			else if (self.netname == "button2")
			{
				targ.button2 = self.waterlevel;
				targ.nextthink = time;
			}
			//camera_time
			else if (self.netname == "camera_time")
			{
				player.camera_time = self.waterlevel;
			}
			//delay
			else if (self.netname == "delay")
			{
				targ.delay = self.waterlevel;
			}
			//effects
			else if (self.netname == "effects" && self.map == "+")
			{
				targ.effects (+) self.waterlevel;
			}
			else if (self.netname == "effects" && self.map == "-")
			{
				targ.effects (-) self.waterlevel;
			}
			//enemy
			else if (self.netname == "enemy")
			{
				if(self.message == "player")
					referenced = find (world, classname, "player");
				else
					referenced = find (world, targetname, self.message);
				targ.enemy = referenced;
				if(targ.flags & FL_MONSTER)
				{
					temp=self;
					self=targ;
					FoundTarget();
					self=temp;
				}
			}
			//frame
			else if (self.netname == "frame")
			{
				targ.frame = self.waterlevel;
			}
			//items
			else if (self.netname == "items")
			{
				targ.items = self.waterlevel;
			}
			//message
			else if (self.netname == "message")
			{
				targ.message = self.message;
			}
			//model
			else if (self.netname == "model")
			{
				targ.model = self.message;
				setmodel(targ, targ.model);
			}
			//movetype
			else if (self.netname == "movetype")
			{
				targ.movetype = self.waterlevel;
			}
			//noise
			else if (self.netname == "noise")
			{
				targ.noise = self.message;
			}
			//noise1
			else if (self.netname == "noise1")
			{
				targ.noise1 = self.message;
			}
			//noise4
			else if (self.netname == "noise4")
			{
				targ.noise4 = self.message;
				if (targ.noise4=="") targ.noise4 = string_null;
			}
			//origin
			else if (self.netname == "origin")
			{
				if(self.oldorigin)
					setorigin (targ, self.oldorigin);
				else
				{
					referenced = find (world, targetname, self.message);
					if(referenced) setorigin (targ, referenced.origin);
				}

				if(targ.classname=="camera_remote" && self.mangle!='0 0 0')
				{
					targ.mangle = self.mangle;
					msg_entity = find (world, classname, "player");
					WriteByte (MSG_ONE, SVC_SETVIEWANGLES);//change to interpolation 
					WriteAngle(MSG_ONE, 90-self.mangle_x);
					WriteAngle(MSG_ONE, self.mangle_y);
					WriteAngle(MSG_ONE, self.mangle_z);
				}
			}
			//owner
			else if (self.netname == "owner")
			{
				if(self.message == "player")
					referenced = find (world, classname, "player");
				else if(self.message == "world")
					referenced = world;
				else
					referenced = find (world, targetname, self.message);

				targ.owner = referenced;
			}
			//rad_time
			else if (self.netname == "rad_time")
			{
				targ.rad_time = self.waterlevel;
			}
			//skin
			else if (self.netname == "skin")
			{
				targ.skin = self.waterlevel;
			}
			//solid
			else if (self.netname == "solid")
			{
				targ.solid = self.waterlevel;
			}
			//spawnflags
			else if (self.netname == "spawnflags")
			{
				targ.spawnflags = self.waterlevel;
			}
			//speed
			else if (self.netname == "speed")
			{
				targ.speed = self.waterlevel;
			}
			//takedamage
			else if (self.netname == "takedamage")
			{
				targ.takedamage=self.waterlevel;
			}
			//target
			else if (self.netname == "target")
			{
				targ.target=self.message;
			}
			//targetname
			else if (self.netname == "targetname")
			{
				targ.targetname=self.message;
			}
			//wait
			else if (self.netname == "wait")
			{
				targ.wait=self.waterlevel;
			}
			//otherwise
			else
			{
				bprint("trigger_setproperty didn't know what to do\n");
				eprint(self);
			}
			
			if(self.spawnflags & SET_ONE_BY_ONE) break;
			
		} while (1);
	}
}

void trigger_setproperty ()
{
	InitTrigger();
	self.use=trigger_setproperty_use;
}
