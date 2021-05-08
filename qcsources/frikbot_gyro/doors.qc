//qb:  door rotation code from goldenboy and avirox


float DOOR_START_OPEN = 1;
float DOOR_DONT_LINK = 4;
float DOOR_GOLD_KEY = 8;
float DOOR_SILVER_KEY = 16;
float DOOR_TOGGLE = 32;
//float DOOR_BRONZE_KEY = 64;
//float DOOR_PLATINUM_KEY = 128;

/*

Doors are similar to buttons, but can spawn a fat trigger field around them
to open without a touch, and they link together to form simultanious
double/quad doors.

Door.owner is the master door.  If there is only one door, it points to itself.
If multiple doors, all will point to a single one.

Door.enemy chains from the master door through all doors linked in the chain.

*/

/*
=============================================================================

THINK FUNCTIONS

=============================================================================
*/

void() door_go_down;
void() door_go_up;

void () door_killed;	// gb
void () door_touch // gb

void() door_blocked =
{
	other.deathtype = "squish";
	T_Damage (other, self, self.goalentity, self.dmg);

	if (!self.model)
		return;

// if a door has a negative wait, it would never come back if blocked,
// so let it just squash the object to death real fast
	if (self.wait >= 0)
	{
		if (self.state == STATE_DOWN)
			door_go_up ();
		else
			door_go_down ();
	}
};

void() door_hit_top =
{
	if (self.continue_movesound)
		sound (self, CHAN_AUTO, self.noise1, 1, ATTN_NORM);	// gb, was CHAN_VOICE
	else
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	
	self.state = STATE_TOP;

	if (self.spawnflags & DOOR_TOGGLE)
	{
		// ROTATE
		if (self.classname == "door_rotating") {
			self.touch = SUB_Null;
			self.th_die = SUB_Null;
		}
		// R
		return;		// don't come down automatically
	}
	self.think = door_go_down;
	self.nextthink = self.ltime + self.wait;
	// ROTATE
	if (self.classname == "door_rotating") {
		if (self.health)
		{
			self.takedamage = 1;
			self.th_die = door_killed;
		}
	}
	// R
};

void() door_hit_bottom =
{
	if (self.continue_movesound)
		sound (self, CHAN_AUTO, self.noise1, 1, ATTN_NORM);	// gb, plays the stop sound *and* the move sound 
	else
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM); // gb, cuts the movesound
	
	self.state = STATE_BOTTOM;

	// ROTATE
	if (self.classname == "door_rotating") {
		if (!(self.spawnflags & DOOR_TOGGLE))
		{
			self.touch = door_touch;
			self.solid = SOLID_BSP;
		}

		if (self.health)
		{
			self.takedamage = 1;
			self.th_die = door_killed;
		}
	}
	// R
};

void() door_go_down =
{
	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	if (self.max_health)
	{
		self.takedamage = DAMAGE_YES;
		self.health = self.max_health;
	}

	self.state = STATE_DOWN;

	// ROTATE
	if (self.classname == "door_rotating") {
		SUB_CalcAngleMove (self.pos1, self.speed, door_hit_bottom);
		SUB_UseTargets();
		self.takedamage = 0;
	}
	else
	// R
	SUB_CalcMove (self.pos1, self.speed, door_hit_bottom);
};

void() door_go_up =
{
	if (self.state == STATE_UP)
		return;		// allready going up

	if (self.state == STATE_TOP)
	{	// reset top wait time
		self.nextthink = self.ltime + self.wait;
		return;
	}

	sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	self.state = STATE_UP;

	// ROTATE
	if (self.classname == "door_rotating") {
		SUB_CalcAngleMove (self.pos2, self.speed, door_hit_top);
		self.takedamage = 0;
	}
	else
	// R
	SUB_CalcMove (self.pos2, self.speed, door_hit_top);

	SUB_UseTargets();
};


/*
=============================================================================

ACTIVATION FUNCTIONS

=============================================================================
*/

void() door_fire =
{
	local entity 	oself;
	local entity	starte, te, finder_ent;	// ROTATE

	if (self.owner != self)
		objerror ("door_fire: self.owner != self");

// play use key sound

	if ((self.items)/* || (self.items2)*/)
		sound (self, CHAN_ITEM, self.noise4, 1, ATTN_NORM);

	self.message = string_null;		// no more message
	oself = self;

	if (self.spawnflags & DOOR_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			starte = self;
			do
			{
				door_go_down ();
				self = self.enemy;
			} while ( (self != starte) && (self != world) );
			self = oself;
			return;
		}
	}

// trigger all paired doors
	
	// ROTATE
	if (self.classname == "door_rotating" && (self.linkname))
	{
		// linking rotating doors is fubar'd... hence we do it manually, and this time it even works
		finder_ent = find (world,linkname,self.linkname);
		
		while (finder_ent)
		{
			if (/* finder_ent != self && */finder_ent.linkname != string_null && finder_ent.linkname == self.linkname/* && finder_ent.touch != SUB_Null*/ )
			{
				te = self;
				self = finder_ent;
				door_go_up();
				self = te;
			}
			finder_ent = find (finder_ent, linkname, self.linkname);
		}
	}
	// R
	else
	{
		starte = self;
		do
		{
			self.goalentity = activator;	// QIP
			door_go_up ();
			self = self.enemy;
		} while ( (self != starte) && (self != world) );
		self = oself;
	}
};


void() door_use =
{
	local entity oself;
	
	self.message = "";			// door message are for touch only
	self.owner.message = "";
	self.enemy.message = "";
	oself = self;
	self = self.owner;
	door_fire ();
	self = oself;
};


void() door_trigger_touch =
{
	if (other.health <= 0)
		return;

	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 1;

	activator = other;

	self = self.owner;
	door_use ();
};


void() door_killed =
{
	local entity oself;

	oself = self;
	self = self.owner;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	door_use ();
	self = oself;
};


//float (entity e1, entity e2) EntitiesTouching;
/*
================
door_touch

Prints messages and opens key doors
================
*/
void() door_touch =
{
	// ROTATE
	local entity finder_ent, te;
	// R
	if (other.classname != "player")
		return;
	if (self.owner.attack_finished > time)
		return;

	if (other.classname == "player" && (self.health > 0) )	// gb, any door with health set must be shot open
		return;

	self.owner.attack_finished = time + 2;

	if (self.owner.message != "")
	{
		centerprint (other, self.owner.message);
		sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

// key door stuff
	if ((!self.items)/* && (!self.items2)*/ && (!self.classname == "door_rotating"))	// gb, the latter must touch
		return;

// FIXME: blink key on player's status bar
	if ( ((self.items & other.items) != self.items)
	/*|| ((self.items2 & other.items2) != self.items2)*/ )
	{
		if (self.owner.items == IT_KEY1)
		{
			if (world.worldtype == 2)
			{
				centerprint (other, "You need the silver keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 1)
			{
				centerprint (other, "You need the silver runekey");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 0)
			{
				centerprint (other, "You need the silver key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
		}
		else if (self.owner.items == IT_KEY2)
		{
			if (world.worldtype == 2)
			{
				centerprint (other, "You need the gold keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 1)
			{
				centerprint (other, "You need the gold runekey");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 0)
			{
				centerprint (other, "You need the gold key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
		}
	/*	else if (self.owner.items2 == IT_KEY3)
		{
			if (world.worldtype == 2)
			{
				centerprint (other, "You need the bronze keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 1)
			{
				centerprint (other, "You need the bronze runekey");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 0)
			{
				centerprint (other, "You need the bronze key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
		}
		else
		{
			if (world.worldtype == 2)
			{
				centerprint (other, "You need the platinum keycard");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 1)
			{
				centerprint (other, "You need the platinum runekey");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
			else if (world.worldtype == 0)
			{
				centerprint (other, "You need the platinum key");
				sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
			}
		}*/
		return;
	}
	
	other.items = other.items - self.items;
//	other.items2 = other.items2 - self.items2;
	
	self.touch = SUB_Null;
	
	if (self.enemy)
		self.enemy.touch = SUB_Null;	// get paired door
	
	door_use ();

	// ROTATE
	if (self.classname == "door_rotating") {
		// linking rotating doors is fubar'd... hence we do it manually, and this time it even works
		finder_ent = find (world,linkname,self.linkname);
		
		while (finder_ent)
		{
			if ( finder_ent != self && finder_ent.linkname != string_null && finder_ent.linkname == self.linkname && finder_ent.touch != SUB_Null )
			{
				te = self;
				self = finder_ent;
				self.touch();
				self = te;
			}
			finder_ent = find (finder_ent, linkname, self.linkname);
		}
	}
	// R

};

/*
=============================================================================

SPAWNING FUNCTIONS

=============================================================================
*/


entity(vector fmins, vector fmaxs) spawn_field =
{
	local entity	trigger;
	local	vector	t1, t2;

	trigger = spawn();
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.owner = self;
	trigger.touch = door_trigger_touch;

	t1 = fmins;
	t2 = fmaxs;
	setsize (trigger, t1 - '60 60 8', t2 + '60 60 8');
	return (trigger);
};


float (entity e1, entity e2) EntitiesTouching =
{
	if (e1.mins_x > e2.maxs_x)
		return FALSE;
	if (e1.mins_y > e2.maxs_y)
		return FALSE;
	if (e1.mins_z > e2.maxs_z)
		return FALSE;
	if (e1.maxs_x < e2.mins_x)
		return FALSE;
	if (e1.maxs_y < e2.mins_y)
		return FALSE;
	if (e1.maxs_z < e2.mins_z)
		return FALSE;
	return TRUE;
};


/*
=============
LinkDoors
=============
*/
void() LinkDoors =
{
	local entity	t, starte;
	local vector	cmins, cmaxs;

	if (self.enemy)
		return;		// already linked by another door
	if (self.spawnflags & 4)
	{
		self.owner = self.enemy = self;
		return;		// don't want to link this door
	}

	//cmins = self.mins;
	//cmaxs = self.maxs;

	//ijed Thanks Preach - fix for trigger field
	cmins = self.mins + self.origin; 
	cmaxs = self.maxs + self.origin; 
	
	starte = self;
	t = self;

	do
	{
		self.owner = starte;			// master door

		if (self.health)
			starte.health = self.health;
		if (self.targetname)
			starte.targetname = self.targetname;
		if (self.message != "")
			starte.message = self.message;

		t = find (t, classname, self.classname);
		if (!t)
		{
			self.enemy = starte;		// make the chain a loop

		// shootable, fired, or key doors just needed the owner/enemy links,
		// they don't spawn a field

			self = self.owner;

			if (self.health)
				return;
			if (self.targetname)
				return;
			if (self.items)
				return;
	/*		if (self.items2)
				return;*/
			
			self.owner.trigger_field = spawn_field(cmins, cmaxs);

			return;
		}

		if (EntitiesTouching(self,t))
		{
			if (t.enemy)
				objerror ("cross connected doors");

			self.enemy = t;
			self = t;

			if (t.mins_x < cmins_x)
				cmins_x = t.mins_x;
			if (t.mins_y < cmins_y)
				cmins_y = t.mins_y;
			if (t.mins_z < cmins_z)
				cmins_z = t.mins_z;
			if (t.maxs_x > cmaxs_x)
				cmaxs_x = t.maxs_x;
			if (t.maxs_y > cmaxs_y)
				cmaxs_y = t.maxs_y;
			if (t.maxs_z > cmaxs_z)
				cmaxs_z = t.maxs_z;
		}
	} while (1 );

};


/*QUAKED func_door (0 .5 .8) ? START_OPEN x DOOR_DONT_LINK GOLD_KEY SILVER_KEY TOGGLE BRONZE_KEY PLATINUM_KEY
if two doors touch, they are assumed to be connected and operate as a unit.

TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN causes the door to move to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not usefull for touch or takedamage doors).

Key doors are allways wait -1.

"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"angle"		determines the opening direction
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"lip"		lip remaining at end of move (8 default)
"dmg"		damage to inflict when blocked (2 default)
"noise1"	overrides the stopping sound if sounds 0
"noise2"	overrides the moving sound if sounds 0
"continue_movesound"	allows the move sound to continue, usually it is cut out as soon as the stop sound plays
"sounds"
0)	no sound / sounds set manually
1)	stone
2)	base
3)	stone chain
4)	screechy metal
*/

void() func_door =

{
	if (world.worldtype == 0)
	{
		precache_sound ("doors/medtry.wav");
		precache_sound ("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (world.worldtype == 1)
	{
		precache_sound ("doors/runetry.wav");
		precache_sound ("doors/runeuse.wav");
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (world.worldtype == 2)
	{
		precache_sound ("doors/basetry.wav");
		precache_sound ("doors/baseuse.wav");
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}
	else
	{
		dprint ("no worldtype set!\n");
	}
	
	if (self.sounds == 0)
	{
		if (!self.noise1)	// gb
			self.noise1 = "misc/null.wav";

		if (!self.noise2)	// gb
			self.noise2 = "misc/null.wav";

		precache_sound (self.noise1);
		precache_sound (self.noise2);
	}
	if (self.sounds == 1)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}


	SetMovedir ();

	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	self.classname = "door";

	self.blocked = door_blocked;
	self.use = door_use;

	if (self.spawnflags & DOOR_SILVER_KEY)
		self.items = IT_KEY1;
	if (self.spawnflags & DOOR_GOLD_KEY)
		self.items = IT_KEY2;
/*	if (self.spawnflags & DOOR_BRONZE_KEY)
		self.items2 = IT_KEY3;			//items2  -otp
	if (self.spawnflags & DOOR_PLATINUM_KEY)
		self.items2 = IT_KEY4;			//items2  -otp
*/
	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		setorigin (self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = door_killed;
	//	self.nobleed = TRUE;// pOx - No bleed patch
	}

	if ((self.items)/* || (self.items2)*/)
		self.wait = -1;

	self.touch = door_touch;

// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
};
/*
void() func_door_model = //ijed A model instead of being a brush entity
{
	if ((self.mdl) || (self.model))
	{
		if (self.mdl)
		{
			precache_model (self.mdl);
			self.model = self.mdl;
		}
		precache_model (self.model);
		setmodel (self, self.model);
	}
	else
	{
		dprint ("null func_door_model at: ");
		dprint (vtos (self.origin));
		dprint ("\n");
	}
	
	func_door();
};
*/

/*
=============================================================================

SECRET DOORS

=============================================================================
*/

void() fd_secret_move1;
void() fd_secret_move2;
void() fd_secret_move3;
void() fd_secret_move4;
void() fd_secret_move5;
void() fd_secret_move6;
void() fd_secret_done;

float SECRET_OPEN_ONCE = 1;		// stays open
float SECRET_1ST_LEFT = 2;		// 1st move is left of arrow
float SECRET_1ST_DOWN = 4;		// 1st move is down from arrow
float SECRET_NO_SHOOT = 8;		// only opened by trigger
float SECRET_YES_SHOOT = 16;	// shootable even if targeted


void () fd_secret_use =
{
	local float temp;

	self.health = 10000;

	// exit if still moving around...
	if (self.origin != self.oldorigin)
		return;

	self.message = string_null;		// no more message

	SUB_UseTargets();				// fire all targets / killtargets

	if (!(self.spawnflags & SECRET_NO_SHOOT))
	{
		self.th_pain = SUB_Null;
		self.takedamage = DAMAGE_NO;
	}
	self.velocity = '0 0 0';

	// Make a sound, wait a little...

	sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.nextthink = self.ltime + 0.1;

	temp = 1 - (self.spawnflags & SECRET_1ST_LEFT);	// 1 or -1
	makevectors(self.mangle);

	if (!self.t_width)
	{
		if (self.spawnflags & SECRET_1ST_DOWN)
			self. t_width = fabs(v_up * self.size);
		else
			self. t_width = fabs(v_right * self.size);
	}

	if (!self.t_length)
		self. t_length = fabs(v_forward * self.size);

	if (self.spawnflags & SECRET_1ST_DOWN)
		self.dest1 = self.origin - v_up * self.t_width;
	else
		self.dest1 = self.origin + v_right * (self.t_width * temp);

	self.dest2 = self.dest1 + v_forward * self.t_length;
	SUB_CalcMove(self.dest1, self.speed, fd_secret_move1);
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

// Wait after first movement...
void () fd_secret_move1 =
{
	self.nextthink = self.ltime + 1.0;
	self.think = fd_secret_move2;
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

// Start moving sideways w/sound...
void () fd_secret_move2 =
{
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	SUB_CalcMove(self.dest2, self.speed, fd_secret_move3);
};

// Wait here until time to go back...
void () fd_secret_move3 =
{
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	if (!(self.spawnflags & SECRET_OPEN_ONCE))
	{
		self.nextthink = self.ltime + self.wait;
		self.think = fd_secret_move4;
	}
};

// Move backward...
void () fd_secret_move4 =
{
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	SUB_CalcMove(self.dest1, self.speed, fd_secret_move5);
};

// Wait 1 second...
void () fd_secret_move5 =
{
	self.nextthink = self.ltime + 1.0;
	self.think = fd_secret_move6;
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

void () fd_secret_move6 =
{
	sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	SUB_CalcMove(self.oldorigin, self.speed, fd_secret_done);
};

void () fd_secret_done =
{
	if (!self.targetname || self.spawnflags&SECRET_YES_SHOOT)
	{
		self.health = 10000;
		self.takedamage = DAMAGE_YES;
		self.th_pain = fd_secret_use;
	}
	sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

void () secret_blocked =
{
	if (time < self.attack_finished)
		return;
	
	self.attack_finished = time + 0.5;
	other.deathtype = "squish";	// QIP
	T_Damage (other, self, self, self.dmg);
};

/*
================
secret_touch

Prints messages
================
*/
void() secret_touch =
{
	if (other.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;

	if (self.message)
	{
		centerprint (other, self.message);
		sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
	}
};


/*QUAKED func_door_secret (0 .5 .8) ? open_once 1st_left 1st_down no_shoot always_shoot
Basic secret door. Slides back, then to the side. Angle determines direction.
wait  = # of seconds before coming back
1st_left = 1st move is left of arrow
1st_down = 1st move is down from arrow
always_shoot = even if targeted, keep shootable
t_width = override WIDTH to move back (or height if going down)
t_length = override LENGTH to move sideways
"dmg"		damage to inflict when blocked (2 default)

If a secret door has a targetname, it will only be opened by it's botton or trigger, not by damage.
"sounds"
1) medieval
2) metal
3) base
*/

void () func_door_secret =
{
	if (self.sounds == 0)
		self.sounds = 3;
	if (self.sounds == 1)
	{
		precache_sound ("doors/latch2.wav");
		precache_sound ("doors/winch2.wav");
		precache_sound ("doors/drclos4.wav");
		self.noise1 = "doors/latch2.wav";
		self.noise2 = "doors/winch2.wav";
		self.noise3 = "doors/drclos4.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/airdoor1.wav");
		precache_sound ("doors/airdoor2.wav");
		self.noise2 = "doors/airdoor1.wav";
		self.noise1 = "doors/airdoor2.wav";
		self.noise3 = "doors/airdoor2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/basesec1.wav");
		precache_sound ("doors/basesec2.wav");
		self.noise2 = "doors/basesec1.wav";
		self.noise1 = "doors/basesec2.wav";
		self.noise3 = "doors/basesec2.wav";
	}

	if (!self.dmg)
		self.dmg = 2;

	// Magic formula...
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.classname = "door";
	setmodel (self, self.model);
	setorigin (self, self.origin);

	self.touch = secret_touch;
	self.blocked = secret_blocked;
	self.speed = 50;
	self.use = fd_secret_use;
	if ( !self.targetname || self.spawnflags&SECRET_YES_SHOOT)
	{
		self.health = 10000;
		self.takedamage = DAMAGE_YES;
		self.th_pain = fd_secret_use;
		self.th_die = fd_secret_use;
	//	self.nobleed = TRUE;// pOx - No bleed patch
	}
	self.oldorigin = self.origin;
	if (!self.wait)
		self.wait = 5;		// 5 seconds before closing
};


/*
 * HL rotating things
 *
 * from QuakeLife by avirox
 * 
 * Pros: Simpler and use less models
 * Cons: Engine and map compiler must support (origin brushes)
 * Possible solution: Set the origin some other way
 * It's messy though - Quake wasn't made for this
 *
 */

// for now only doors, gb

void() rot_crush =
{
//dprint ("plat_crush\n");

	T_Damage (other, self, self, 1000);
};

// DOOR_START_OPEN 1
float DOOR_REVERSE		= 2;
// DOOR_DONT_LINK 4
// DOOR_GOLD_KEY 8
// DOOR_SILVER_KEY 16
// TOGGLE 32
float DOOR_X_AXIS		= 64;
float DOOR_Y_AXIS		= 128;

/*QUAKED rotate_door (0 .5 .8) ? START_OPEN DOOR_REVERSE DOOR_DONT_LINK GOLD_KEY SILVER_KEY TOGGLE DOOR_X_AXIS DOOR_Y_AXIS
if two doors touch, they are assumed to be connected and operate as a unit.

TOGGLE causes the door to wait in both the start and end states for a trigger event.

START_OPEN causes the door to move to its destination when spawned, and operate in reverse.  It is used to temporarily or permanently close off an area when triggered (not usefull for touch or takedamage doors).

Key doors are allways wait -1.

"target"	must target an info_null or info_rotate with matching targetname, which marks the center of rotation
"linkname"	rotating doors must be linked manually; give linked doors the same linkname (string)
"message"	is printed when the door is touched if it is a trigger door and it hasn't been fired yet
"distance"	amount in degrees to rotate
"targetname" if set, no touch field will be spawned and a remote button or trigger field activates the door.
"health"	if set, door must be shot open
"speed"		movement speed (100 default)
"wait"		wait before returning (3 default, -1 = never return)
"lip"		lip remaining at end of move (8 default)
"dmg"		damage to inflict when blocked (2 default)
"noise1"	overrides the stopping sound if sounds 0
"noise2"	overrides the moving sound if sounds 0
"sounds"
0)	no sound
1)	stone
2)	base
3)	stone chain
4)	screechy metal
*/

// avirox, Urre, LordHavoc, Baker, gb

void() rotate_door =
{
/*	local entity ent;

	ent = find( world, targetname, self.target);
  */ 
	if (!self.target)	// gb
		objerror ("rotate_door without target\n");

	if (world.worldtype == 0)
	{
		precache_sound ("doors/medtry.wav");
		precache_sound ("doors/meduse.wav");
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (world.worldtype == 1)
	{
		precache_sound ("doors/runetry.wav");
		precache_sound ("doors/runeuse.wav");
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (world.worldtype == 2)
	{
		precache_sound ("doors/basetry.wav");
		precache_sound ("doors/baseuse.wav");
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}
	else
	{
		dprint ("no worldtype set!\n");
	}
	if (self.sounds == 0)
	{
		if (!self.noise1)	// gb, stopping sound
			self.noise1 = "misc/null.wav";

		if (!self.noise2)	// gb, moving sound
			self.noise2 = "misc/null.wav";

		precache_sound (self.noise1);
		precache_sound (self.noise2);
	}
	if (self.sounds == 1)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise2 = "doors/stndr1.wav";
		self.noise1 = "doors/stndr2.wav";
	}
	if (self.sounds == 4)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}


	if (self.spawnflags & DOOR_X_AXIS)
		self.movedir_z = 1.0;
	else if (self.spawnflags & DOOR_Y_AXIS)
		self.movedir_x = 1.0;
	else // Z_AXIS
		self.movedir_y = 1.0;

	// check for reverse rotation
	if (self.spawnflags & DOOR_REVERSE)
		self.movedir = '0 0 0' - self.movedir;



	self.max_health = self.health;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH; // gb
	
	setorigin (self, self.origin);  // self.origin
	
	setmodel (self, self.model);
	
	self.classname = "door_rotating";
	
	if (!self.linkname)
		self.linkname = string_null;

	self.blocked = door_blocked;
	self.use = door_use;
	
	if (self.spawnflags & DOOR_SILVER_KEY)
		self.items = IT_KEY1;
	if (self.spawnflags & DOOR_GOLD_KEY)
		self.items = IT_KEY2;
	
	if (!self.speed)
		self.speed = 100;
	if (!self.wait)
		self.wait = 3;
	if (!self.lip)
		self.lip = 8;
	if (!self.dmg)
		self.dmg = 2;

//	self.pos1 = self.origin;
//	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

	self.pos1 = self.angles;
	self.pos2 = self.angles + self.movedir * self.distance;

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)	// fixed this, gb
	{
		
		self.pos2 = self.angles;
		self.pos1 = self.angles - self.movedir * self.distance;
		self.angles = self.angles + self.movedir * self.distance;
	//	setorigin (self, self.pos1);
	}

	self.state = STATE_BOTTOM;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.nobleed = TRUE;
		self.th_die = door_killed;
	}
	
	if (self.items)
		self.wait = -1;
		
	//if (!(self.spawnflags & 256))	// use only - but use is touch in quake anyways lol
		self.touch = door_touch;
	
	if (self.targetname) {		// Door is locked if it must be triggered
		self.touch = SUB_Null;
		self.th_die = SUB_Null;
	}	
		
// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
	if (!(self.spawnflags & 4))
		self.spawnflags = self.spawnflags | 4;		// so we DONT link doors
	
	self.think = LinkDoors;
	self.nextthink = self.ltime + 0.1;
};

/*
 * gb - another rotating bmodel using origin brushes / origin vector - for testing purposes
 * this is from the quakesrc.org avelocity engine / qc tutorial
 * and should work in conjunction with avirox' engine avelocity tutorial
 * or any engine that supports avelocity (angle velocity)
 *
 */

float STATE_WAITING = 0;
float STATE_SPINNING = 1;

// gb
void() accelerator_think =
{
	local float accel_factor;

	if (self.reverse_rotate)	// backwards
	{
		if (self.cnt >= self.reverse_rotate)	// reached top speed?
		{
			self.think = SUB_Remove;
			self.nextthink = time + 0.1;
			dprint("removing accelerator\n");
			return;
		}

		accel_factor = self.reverse_rotate / self.delay / 10;
	}
	else
	{
		if (self.cnt >= self.speed)	// reached top speed?
		{
			self.think = SUB_Remove;
			self.nextthink = time + 0.1;
			dprint("removing accelerator\n");
			return;
		}

		accel_factor = self.speed / self.delay / 10;	// 10 FPS; delay 10 = 100 frames
	}

	self.cnt = self.cnt + accel_factor; 	// keep count

	if (self.wait == 4)	// lol
	{
		if (self.reverse_rotate)	// backwards?
			self.owner.avelocity_z = self.owner.avelocity_z - accel_factor;
		else
			self.owner.avelocity_z = self.owner.avelocity_z + accel_factor;
	}
	else if (self.wait == 8)	// yup, save globals
	{
		if (self.reverse_rotate)	// backwards?
			self.owner.avelocity_x = self.owner.avelocity_x - accel_factor;
		else
			self.owner.avelocity_x = self.owner.avelocity_x + accel_factor;
	}
	else
	{
		if (self.reverse_rotate)	// backwards?
			self.owner.avelocity_y = self.owner.avelocity_y - accel_factor;
		else
			self.owner.avelocity_y = self.owner.avelocity_y + accel_factor;
	}
	
	self.nextthink = time + 0.1;	// accelerate every frame
};

// gb
void() decelerator_think =
{
	local float accel_factor;

	if (self.owner.avelocity == '0 0 0')	// make very sure it stopped completely
	{
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
		dprint("removing decelerator\n");
		return;
	}

	if (self.reverse_rotate)	// backwards
		accel_factor = self.reverse_rotate / self.delay / 10;
	else
		accel_factor = self.speed / self.delay / 10;	// 10 FPS; delay 10 = 100 frames

	if (self.wait == 4)	// lol
	{
		if (self.owner.avelocity_z < 10 && self.owner.avelocity_z > -10) // have to account for both - might be reverse
			self.owner.avelocity_z = 0;	// make sure it doesn't go the other direction
		else if (self.reverse_rotate)	// backwards
			self.owner.avelocity_z = self.owner.avelocity_z + accel_factor;
		else
			self.owner.avelocity_z = self.owner.avelocity_z - accel_factor;
	}
	else if (self.wait == 8)	// yup, save globals
	{
		if (self.owner.avelocity_x < 10 && self.owner.avelocity_x > -10)
			self.owner.avelocity_x = 0;
		else if (self.reverse_rotate)	// backwards
			self.owner.avelocity_x = self.owner.avelocity_x + accel_factor;
		else
			self.owner.avelocity_x = self.owner.avelocity_x - accel_factor;
	}
	else
	{
		if (self.owner.avelocity_y < 10 && self.owner.avelocity_y > -10)
			self.owner.avelocity_y = 0;
		else if (self.reverse_rotate)	// backwards
			self.owner.avelocity_y = self.owner.avelocity_y + accel_factor;
		else
			self.owner.avelocity_y = self.owner.avelocity_y - accel_factor;
	}
	
	self.nextthink = time + 0.1;	// accelerate every frame
};

// gb
void() rotate_continuous_use =
{
	local entity e;				// we're dumb, so use a helper

	if (self.state == STATE_SPINNING)	// gb, already spinning, got toggled off - stop moving
	{
		if (self.spawnflags & 4)
		{
			if (self.delay > 0)	// shall I decelerate? 
			{
				e = spawn();
				e.owner = self;
				e.delay = self.delay;
				e.speed = self.speed;
				e.reverse_rotate = self.reverse_rotate;	// backwards?
				e.wait = 4;	// lol
				e.think = decelerator_think;
				e.nextthink = time + 0.1;
				dprint ("decelerator spawned\n");
				//return;
			}
			else			// nope, just go for it
			{
				self.avelocity_z = 0;
			}
		}
		else if (self.spawnflags & 8)
		{
			if (self.delay > 0)	// shall I decelerate? 
			{
				e = spawn();
				e.owner = self;
				e.delay = self.delay;
				e.speed = self.speed;
				e.reverse_rotate = self.reverse_rotate;	// backwards?
				e.wait = 8;	// lol
				e.think = decelerator_think;
				e.nextthink = time + 0.1;
				dprint("decelerator spawned\n");
				//return;
			}
			else			// nope, just go for it
			{
				self.avelocity_x = 0;
			}
		}
		else
		{
			if (self.delay > 0)	// shall I decelerate? 
			{
				e = spawn();
				e.owner = self;
				e.delay = self.delay;
				e.speed = self.speed;
				e.reverse_rotate = self.reverse_rotate;	// backwards?
				// no wait
				e.think = decelerator_think;
				e.nextthink = time + 0.1;
				dprint("decelerator spawned\n");
				//return;
			}
			else			// nope, just go for it
			{
				self.avelocity_y = 0;
			}
		}

		self.state = STATE_WAITING;	// possibly let the helper set this once stopped
	}
	else	// STATE_WAITING		// gb, got toggled on - start spinning
	{
		if (self.spawnflags & 4)
		{
			self.avelocity_x = 0;
			self.avelocity_y = 0;
			self.avelocity_z = 0;	// null it out
			
			if (self.delay > 0)	// shall I accelerate? 
			{
				e = spawn();
				e.owner = self;
				e.delay = self.delay;
				e.speed = self.speed;
				e.reverse_rotate = self.reverse_rotate;	// backwards?
				e.wait = 4;	// lol
				e.think = accelerator_think;
				e.nextthink = time + 0.1;
				dprint ("accelerator spawned\n");
				//return;
			}
			else			// nope, just go for it
			{
				self.avelocity_z = self.speed;
			}
		}
		else if (self.spawnflags & 8)
		{
			self.avelocity_z = 0;
			self.avelocity_y = 0;
			self.avelocity_x = 0;	// null it out

			if (self.delay > 0)	// shall I accelerate? 
			{
				e = spawn();
				e.owner = self;
				e.delay = self.delay;
				e.speed = self.speed;
				e.reverse_rotate = self.reverse_rotate;	// backwards?
				e.wait = 8;	// lol
				e.think = accelerator_think;
				e.nextthink = time + 0.1;
				dprint("accelerator spawned\n");
				//return;
			}
			else			// nope, just go for it
			{
				self.avelocity_x = self.speed;
			}
		}
		else
		{
			self.avelocity_z = 0;
			self.avelocity_x = 0;
			self.avelocity_y = 0;	// null it out
			
			if (self.delay > 0)	// shall I accelerate? 
			{
				e = spawn();
				e.owner = self;
				e.delay = self.delay;
				e.speed = self.speed;
				e.reverse_rotate = self.reverse_rotate;	// backwards?
				// no wait
				e.think = accelerator_think;
				e.nextthink = time + 0.1;
				dprint("accelerator spawned\n");
				//return;
			}
			else			// nope, just go for it
			{
				self.avelocity_y = self.speed;
			}
		}
		
		self.state = STATE_SPINNING;	// possibly let the helper set this once fully spun up

		self.think = SUB_Null;
		self.nextthink = self.ltime + 9999999;
	}
};

/*QUAKED rotate_continuous (0 .5 .8) ? x REVERSE Z_AXIS X_AXIS x x NONSOLID 
RMQ Origin-rotating bmodel - experimental

"targetname"	if set, waits for trigger and can be toggled on/off
"speed"		nominal rotating speed (100 default)
"delay"		if set, duration of acceleration / deceleration
"target"	must target an info_null, which marks the center of rotation
*/

// gb
void() rotate_continuous =	
{
	if (!self.target)
		objerror ("rotate_continuous without target\n");

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	//self.think = SUB_Null;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	self.classname = "rotate_continuous";
	setsize (self, self.mins, self.maxs);
	
	if (!self.speed)
		self.speed = 100;

	if (self.spawnflags & 2) // reverse direction
	{
		self.reverse_rotate = self.speed;	// yeah
		self.speed = 0 - self.speed;
	}

	if (self.spawnflags & 64) // not solid
		self.solid = SOLID_NOT;
	
	if (!self.targetname)
	{
		self.state = STATE_WAITING;
		rotate_continuous_use();
	}
	else
	{
		self.state = STATE_WAITING;
		self.use = rotate_continuous_use;
	}

	self.blocked = rot_crush;
};

void() rotate_continuous_model = //ijed, gb A model instead of being a brush entity
{
	if ((self.mdl) || (self.model))
	{
		if (self.mdl)
		{
			precache_model (self.mdl);
			self.model = self.mdl;
		}
		precache_model (self.model);
		setmodel (self, self.model);
	}
	else
	{
		dprint ("null rotate_continuous_model at: ");
		dprint (vtos (self.origin));
		dprint ("\n");
	}
	
	rotate_continuous();
};


// still more rotating crap, this time by urre
// must target something to get its origin
/*
void () rotate_obejct =
{
	setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);

	self.classname = self.netname;

	if (self.classname == "func_rotating_door")
		func_rotating_door();

	else if (self.classname == "func_rotating_banana")
		func-rotating_banana();
};
*/

