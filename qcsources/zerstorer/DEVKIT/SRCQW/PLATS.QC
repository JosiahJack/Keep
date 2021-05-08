

void() plat_center_touch;
void() plat_outside_touch;
void() plat_trigger_use;
void() plat_go_up;
void() plat_go_down;
void() plat_crush;
float PLAT_LOW_TRIGGER = 1;
float PLAT_TOGGLE = 2;

void() plat_spawn_inside_trigger =
{
	local entity	trigger;
	local vector	tmin, tmax;

//
// middle trigger
//	
	trigger = spawn();
	trigger.touch = plat_center_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;
	
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
		tmax_z = tmin_z + 8;
	
	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / 2;
		tmax_x = tmin_x + 1;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / 2;
		tmax_y = tmin_y + 1;
	}
	
	setsize (trigger, tmin, tmax);
};

void() plat_hit_top =
{
	sound (self, CHAN_NO_PHS_ADD+CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;
// ********
// * dhm - if PLAT_TOGGLE then don't set timer to go down.
// ********
	if (self.spawnflags & PLAT_TOGGLE)
		return;

	self.think = plat_go_down;
	self.nextthink = self.ltime + 3;
};

void() plat_hit_bottom =
{
	sound (self, CHAN_NO_PHS_ADD+CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() plat_go_down =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos1, self.speed, plat_hit_top);
};

void() plat_center_touch =
{
	if (other.classname != "player")
		return;
		
	if (other.health <= 0)
		return;

	self = self.enemy;
	if (self.state == STATE_BOTTOM)
		plat_go_up ();
	else if (self.state == STATE_TOP)
		self.nextthink = self.ltime + 1;	// delay going down
};

void() plat_outside_touch =
{
	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;
		
//dprint ("plat_outside_touch\n");
	self = self.enemy;
	if (self.state == STATE_TOP)
		plat_go_down ();
};

void() plat_trigger_use =
{
	if (self.think)
		return;		// allready activated
	plat_go_down();
};


void() plat_crush =
{
//dprint ("plat_crush\n");

	other.deathtype = "squish";
	T_Damage (other, self, self, 1);
	
	if (self.state == STATE_UP)
		plat_go_down ();
	else if (self.state == STATE_DOWN)
		plat_go_up ();
	else
		objerror ("plat_crush: bad self.state\n");
};

void() plat_use =
{
// ********
// * dhm - if PLAT_TOGGLE then move plat to the next state.
// ********
	if (self.spawnflags & PLAT_TOGGLE)
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
			plat_go_down ();
		else if (self.state == STATE_DOWN || self.state == STATE_BOTTOM)
			plat_go_up ();
		else dprint("Plat error: bad state on use.\n");
		return;
	}	

	self.use = SUB_Null;
	if (self.state != STATE_UP)
		objerror ("plat_use: not in up state");
	plat_go_down();
};


/*QUAKED func_plat (0 .5 .8) ? PLAT_LOW_TRIGGER
speed	default 150

Plats are always drawn in the extended position, so they will light correctly.

If the plat is the target of another trigger or button, it will start out disabled in the extended position until it is trigger, when it will lower and become a normal plat.

If the "height" key is set, that will determine the amount the plat moves, instead of being implicitly determined by the model's height.
Set "sounds" to one of the following:
1) base fast
2) chain slow
*/


void() func_plat =

{
local entity t;

	if (!self.t_length)
		self.t_length = 80;
	if (!self.t_width)
		self.t_width = 10;

	if (self.sounds == 0)
		self.sounds = 2;
// FIX THIS TO LOAD A GENERIC PLAT SOUND

	if (self.sounds == 1)
	{
		precache_sound ("plats/plat1.wav");
		precache_sound ("plats/plat2.wav");
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	}

	if (self.sounds == 2)
	{
		precache_sound ("plats/medplat1.wav");
		precache_sound ("plats/medplat2.wav");
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
	}


	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "plat";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);

	self.blocked = plat_crush;
	if (!self.speed)
		self.speed = 150;

// pos1 is the top position, pos2 is the bottom
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height)
		self.pos2_z = self.origin_z - self.height;
	else
		self.pos2_z = self.origin_z - self.size_z + 8;

	self.use = plat_trigger_use;

// *********
// * dhm - if PLAT_TOGGLE, don't set a trigger.  Must be used.
// *********
	if (!(self.spawnflags & PLAT_TOGGLE))
		plat_spawn_inside_trigger ();	// the "start moving" trigger	

	if (self.targetname)
	{
		self.state = STATE_UP;
		self.use = plat_use;
	}
	else
	{
		setorigin (self, self.pos2);
		self.state = STATE_BOTTOM;
	}
};

//============================================================================
//dhm - trains can now be restarted when they hit endpoints, by being
//	triggered again.

void() train_next;
void() func_train_find;

void() train_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	other.deathtype = "squish";
	T_Damage (other, self, self, self.dmg);
};

void() train_use =
{
		if (self.think != func_train_find)
			return;		// already activated
		train_next();
};

void() train_wait =
{
//dhm - If train hits a 'wait' of -1, reset self.think so it can be
//	  triggered to start moving again.

	if (self.wait)
	{
		if (self.wait < 0)
			self.think = func_train_find;
		else
			self.think = train_next;
		self.nextthink = self.ltime + self.wait;
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		return;
	}
	else
		self.nextthink = self.ltime + 0.1;
	
	self.think = train_next;
};

void() train_next =
{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
		objerror ("train_next: no next target");
	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;

//dhm - if the target has a speed field, copy it to the train
	if (targ.speed)
	 if (self.classname != "smtrain")
		self.speed = targ.speed;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait);
};

void() func_train_find =

{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	setorigin (self, targ.origin - self.mins);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

void() train_teleporter = 
{
local string	otarg;
local float		otime, oflag;

	otarg = self.target;
	otime = self.nextthink;
	self.target = self.netname;
	self.nextthink = time + 10000;
	teleport_touch();
	self.target = otarg;
	self.nextthink = otime;
};


/***  Modified by Darin McNeil ***/
/*QUAKED func_train (0 .5 .8) ? TRAIN_TOUCH TRAIN_TELEPORTER
Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin 
moving until activated.  You may now also put a "speed" field on a
path_corner, and the train will travel that speed when APPROACHING that
point.  

TRAIN_TOUCH(1) will cause the train to hurt the player on touch.
TRAIN_TELEPORTER(2) will make a teleporter out of the train.  If you want to
 target a specific destination, use the "netname" field to target it. Or,
 if you want to use random teleport destinations, you MUST USE a "spawnflags"
 of "6" on the func_train.  This will make it a random teleporter, and don't
 forget to put a "count" field with the number of random destination points
 in the level (like I did).

speed:	default 100
dmg:	default	2
sounds:
0) None
1) ratchet metal
2) stone
3) base
4) stone chain
5) screechy metal
*/

float TRAIN_TOUCH = 1;
float TRAIN_TELEPORTER = 2;
float TRAIN_LIGHT = 8;

void() func_train =
{	
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror ("func_train without a target");
	if (!self.dmg)
		self.dmg = 2;

	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}
	else if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound ("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound ("plats/train1.wav");
	}
//dhm - new sounds from 'func_door'
	else if (self.sounds == 2)
	{
		precache_sound ("doors/drclos4.wav");
		precache_sound ("doors/doormv1.wav");
		self.noise = "doors/drclos4.wav";
		self.noise1 = "doors/doormv1.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("doors/hydro1.wav");
		precache_sound ("doors/hydro2.wav");
		self.noise1 = "doors/hydro1.wav";
		self.noise = "doors/hydro2.wav";
	}
	else if (self.sounds == 4)
	{
		precache_sound ("doors/stndr1.wav");
		precache_sound ("doors/stndr2.wav");
		self.noise1 = "doors/stndr1.wav";
		self.noise = "doors/stndr2.wav";
	}
	else if (self.sounds == 5)
	{
		precache_sound ("doors/ddoor1.wav");
		precache_sound ("doors/ddoor2.wav");
		self.noise = "doors/ddoor2.wav";
		self.noise1 = "doors/ddoor1.wav";
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;

// *****
// * dhm - Add a self.touch so that a train can harm player when touched.
// *     Add a spawnflag of 1 to make a train hurt player when touched.
// *****
	if (self.spawnflags & TRAIN_TOUCH)
	{
		self.solid = SOLID_TRIGGER;
		self.touch = train_blocked;
	}
	if (self.spawnflags & TRAIN_TELEPORTER)
	{
		self.solid = SOLID_TRIGGER;
		self.touch = train_teleporter;
	}

	self.use = train_use;

	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

/*QUAKED misc_teleporttrain (0 .5 .8) (-8 -8 -8) (8 8 8)
This is used for the final bos
*/
void() misc_teleporttrain =
{	
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror ("func_train without a target");

	self.cnt = 1;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';

	self.noise = ("misc/null.wav");
	precache_sound ("misc/null.wav");
	self.noise1 = ("misc/null.wav");
	precache_sound ("misc/null.wav");

	precache_model2 ("progs/teleport.mdl");
	setmodel (self, "progs/teleport.mdl");
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

