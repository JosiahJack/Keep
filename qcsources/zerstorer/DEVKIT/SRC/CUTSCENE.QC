void() DHM_CalcMoveDone;
void() move_camera;

/* ============================================ */
/* |        Movie camera trigger  - dhm       | */
/* ============================================ */


void(entity o) spawn_dummy =
{
local entity	s;

	s = spawn ();
	s.origin = o.origin;
	s.velocity = o.velocity;
	s.angles = o.angles;
	s.health = o.health;
	s.weapon = o.weapon;
	s.classname = "dummy";
	s.movetype = MOVETYPE_NONE;
	s.solid = SOLID_NOT;
	s.weaponmodel = o.weaponmodel;
	s.flags = o.flags;
	s.effects = o.effects;
	s.items = o.items;
	s.items2 = o.items2;

	if (o.invincible_finished > time)
	   s.invincible_finished = o.invincible_finished - time;
	else o.invincible_finished = 0;
	if (o.invisible_finished > time)
	   s.invisible_finished = o.invisible_finished - time;
	else o.invisible_finished = 0;
	if (o.super_damage_finished > time)
	   s.super_damage_finished = o.super_damage_finished - time;
	else o.super_damage_finished = 0;
	if (o.radsuit_finished > time)
	   s.radsuit_finished = o.radsuit_finished - time;
	else o.radsuit_finished = 0;
	if (o.wing_finished > time)
	   s.wing_finished = o.wing_finished - time;
	else o.wing_finished = 0;
	if (o.invincible_time == 1)
	   s.invincible_time = 1;
	else if (o.invincible_time > 1)
	   s.invincible_time = o.invincible_time - time;
	else o.invincible_time = 0;
	if (o.invisible_time == 1)
	   s.invisible_time = 1;
      else if (o.invisible_time > 1)
	   s.invisible_time = o.invisible_time - time;
	else o.invisible_time = 0;
	if (o.super_time > time)
	   s.super_time = 1;
	else if (o.super_time > 1)
	   s.super_time = o.super_time - time;
	else o.super_time = 0;
	if (o.rad_time == 1)
	   s.rad_time = 1;
	else if (o.rad_time > 1)
	   s.rad_time = o.rad_time - time;
	else o.rad_time = 0;
	if (o.wing_time == 1)
	   s.wing_time = 1;
	else if (o.wing_time > 1)
	   s.wing_time = o.wing_time - time;
	else o.wing_time = 0;

	setorigin (s, o.origin);
};

void() name_player =
{
local entity play;

	self.owner.classname = "player";
	stuffcmd(self.owner, "-forward\n");
	remove(self);
};

void() go_back = 
{
local entity	t,c,d,cvars,old;
local vector	org;
local string	val;

	t = find (world, classname, "dummy");
	if (!t)
		objerror ("couldn't find dummy");

	c = find (world, classname, "camera");
	if (!c)
		objerror ("couldn't find camera");

	setorigin (c, t.origin);
	c.velocity = t.velocity;
	c.view_ofs = '0 0 22';
	c.angles_x = t.angles_x;
	c.angles_y = t.angles_y;
	c.angles_z = 0;
	c.health = t.health;
	c.weapon = t.weapon;
	c.weaponframe = 0;
	c.weaponmodel = t.weaponmodel;
	c.flags = t.flags;
	c.effects = t.effects;
	c.items = t.items;
	c.items2 = t.items2;

	if (t.invincible_finished > 0)
	   c.invincible_finished = time + t.invincible_finished;
	if (t.invisible_finished > 0)
	   c.invisible_finished = time + t.invisible_finished;
	if (t.super_damage_finished > 0)
	   c.super_damage_finished = time + t.super_damage_finished;
	if (t.radsuit_finished > 0)
	   c.radsuit_finished = time + t.radsuit_finished;
	if (t.wing_finished > 0)
	   c.wing_finished = time + t.wing_finished;
	if (t.invincible_time > 0)
	   c.invincible_time = time + t.invincible_time;
	if (t.invisible_time > 0)
	   c.invisible_time = time + t.invisible_time;
	if (t.super_time > 0)
	   c.super_time = time + t.super_time;
	if (t.rad_time > 0)
	   c.rad_time = time + t.rad_time;
	if (t.wing_time > 0)
	   c.wing_time = time + t.wing_time;

	c.fixangle = 1;		// turn this way immediately
	c.takedamage = DAMAGE_AIM;
	c.solid = SOLID_SLIDEBOX;
	c.movetype = MOVETYPE_WALK;
	c.think = SUB_Null;
	c.air_finished = time + 12;  // No gasping from you!

/* If you change the classname during this frame, then the
   'find' command ABOVE will fail, so set a timer to change
   the classname back to player.  [grrrrr, I spent way too 
   long figuring that out.] */
	d = spawn();
	d.nextthink = time + 0.01;
	d.owner = c;
	d.think = name_player;

/* Look for any CVARSET entities to restore old cvars that
   were changed for the cut-scene */
	if(c.ideal_yaw == -1)
	{
	  cvars = find(world, classname, "cvar_done");
	  while(cvars != world)
	  {
		if(!cvars.message)
			cvars.message = cvars.model;
		cvar_set (cvars.netname, cvars.script);
		old = cvars;
		cvars = find(cvars, classname, "cvar_done");
		remove(old);
	  }
	  c.ideal_yaw = 0;
	}

	val = ftos (c.cnt);
	cvar_set ("viewsize", val);  	//restore old viewsize
	stuffcmd(c, "sizedown\nsizeup\n");    //hack-fix for GLquake

	t.nextthink = time + 0.1;
	t.think = SUB_Remove;
	remove(self);
};

/* This routine short-circuits player turning and movement while 
     in camera mode.  self.oldorigin is used as self.angles, and
     self.mangle is used as self.velocity.  This allows me to
     compute these figures in code, and overwrite what the game
     thinks they should be.  Called from 'client.qc'.
*/
void() look_ahead = 
{
local vector 	v_ang, looky;

	self.angles = self.oldorigin;
	self.velocity = self.mangle;
	self.fixangle = 1;
	cvar_set ("viewsize", "120");		//keep screen maximized
	if (self.delay == 0)
	{
		looky_x = self.movedir_x - self.origin_x;
		looky_y = self.movedir_y - self.origin_y;
		looky_z = self.origin_z - self.movedir_z;
		self.oldorigin = vectoangles (looky);
	}
};

// This is a modified SUB_CalcMove routine.
void(vector tdest, float tspeed, entity cam) DHM_CalcMove =
{
local vector	vdestdelta;
local float		len, traveltime;

	self.finaldest = tdest;
	self.think = DHM_CalcMoveDone;

	if (tdest == cam.origin)
	{
		cam.velocity = cam.mangle = '0 0 0';
		self.nextthink = time + 0.01;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - cam.origin;
	
// calculate length of vector
	len = vlen (vdestdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		cam.velocity = cam.mangle = '0 0 0';
		self.nextthink = time + 0.01;
		return;
	}
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = time + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	cam.velocity = cam.mangle = vdestdelta * (1/traveltime);
};

void() wait_camera =
{
	if(!self.wait)
	{
		move_camera();
		return;
	}
	
	self.nextthink = time + self.wait;
	self.think = move_camera;
};

/*
============
After moving, set origin to exact final destination
============
*/
void() DHM_CalcMoveDone =
{
	if(self.enemy.classname != "camera")
	{
		remove(self);
		return;
	}

	setorigin(self.enemy, self.finaldest);
	self.enemy.velocity = self.enemy.mangle = '0 0 0';

	if (self.cnt == -1) 
	{
		remove(self);
		return;
	}

	self.nextthink = time + 0.01;
	self.think = wait_camera;

};

void() move_camera =
{
local entity	cpt,fpt;
local vector	looky;

	if(self.enemy.classname != "camera")
	{
		remove(self);
		return;
	}

	cpt = find (world, targetname, self.target);
	if (!cpt.target)     //if this is the end of the line, stop camera
	{
		self.think = SUB_Null;
		self.enemy.velocity = '0 0 0';
		self.enemy.mangle = '0 0 0';     //mangle == velocity in cut-scene
		DHM_CalcMoveDone();
		self.cnt = -1;	// remove control entity in DHM_CalcMoveDone
		//return;
	}
	if(cpt.focal_point)	//is there a new focal point?
	{
		fpt = find (world, targetname, cpt.focal_point);
		if(!fpt)
			objerror("Couldn't find new focal point!");
		
		self.enemy.movedir = fpt.origin;
		looky_x = self.enemy.movedir_x - self.enemy.origin_x;
		looky_y = self.enemy.movedir_y - self.enemy.origin_y;
		looky_z = self.enemy.origin_z - self.enemy.movedir_z;
		self.enemy.oldorigin = vectoangles (looky);
		self.enemy.angles = self.enemy.oldorigin;    //oldorigin == angles in CS
	}
// Check for auto-focus or still camera angle
	if (cpt.delay)
		self.enemy.delay = cpt.delay;
	else
		self.enemy.delay = 0;

	self.target = cpt.target;
	self.wait = cpt.wait;
	if(cpt.speed)
		self.speed = cpt.speed;
	DHM_CalcMove (cpt.origin, self.speed, self.enemy);	
};

void() go_camera =
{
local entity	control;
local vector	looky;

// Change the player into a camera
	self.classname = "camera";
	self.velocity = '0 0 0';
	self.view_ofs = '0 0 0';

	looky_x = self.movedir_x - self.enemy.origin_x;
	looky_y = self.movedir_y - self.enemy.origin_y;
	looky_z = self.enemy.origin_z - self.movedir_z;
	self.oldorigin = vectoangles (looky);
	self.angles = self.oldorigin;		//oldorigin == angles in CS

// Check if camera is auto-focus or not
	if (self.enemy.delay)
		self.delay = self.enemy.delay;
	else
		self.delay = 0;

	self.velocity = self.mangle = '0 0 0';

	self.dmg = 0;
	self.fixangle = 1;		// turn this way immediately
	self.movetype = MOVETYPE_NOCLIP;
	self.takedamage = DAMAGE_NO;
	//self.solid = SOLID_NOT;
	self.effects = 0;
	self.items = 0;
	self.weaponmodel = "";

// Spawn a control function to handle moving the camera
	if(self.enemy.target)
	{
		control = spawn();
		control.classname = "camcontrol";
		control.enemy = self;
		control.target = self.enemy.target;
		control.speed = self.enemy.speed;
		control.nextthink = time + self.enemy.wait + 0.05;
		control.think = move_camera;
	}
 
//Setting script_count to 0 is what triggers the script to play,
//  It will then play the script number.
	if (!self.script)
		dprint ("trigger_camera needs a script number!");
	self.script_count = 0;

//Save current viewscreen size to return to after camera.
	self.cnt = cvar("viewsize");
	cvar_set ("viewsize", "120");	 //Full screen
	stuffcmd(self, "sizedown\nsizeup\n");   //hack-fix for GLquake

	setorigin (self, self.enemy.origin);
};

void() camera_touch =
{
local entity	t,fpt;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

// only activate for player, 1st time touched
	if (other.health <= 0 || other.classname != "player" || self.cnt == -1)
		return;

//If player is on ground, take him off ground so no one gets confused
	if (other.flags & FL_ONGROUND)
	    other.flags = other.flags - FL_ONGROUND;

// put a dummy where the player was
	spawn_dummy (other);

// find camera
	t = find (world, targetname, self.target);
	while ((t != world) && (t.classname != "info_movie_camera"))
		t = find (t, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");

// find focal point
	fpt = find (world, targetname, self.focal_point);
	if (!fpt)
		objerror ("You must have a focal point!\n");
	else
		other.movedir = fpt.origin;	//movedir used to calc focal dir
			
// Go to the camera - not in this function, because touch functions are
// called while looping through c code, and you don't want to move the 
// player, or something like that?
	other.enemy = t;		//save camera position, etc.
	other.script = self.script;	//save script number
	other.script_delay = self.script_delay;  //save delay for page 1

	fpt = self;
	self = other;
	go_camera ();
	self = fpt;	

	activator = self;
	SUB_UseTargets();
	self.cnt = -1;  //used to make sure only one dummy is spawned

//Remove the trigger_camera from level
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

/*QUAKED info_movie_camera (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a camera.  It should have a "targetname" field with the same value as a camera-trigger's "target" field.
*/
void() imc_touch =
{
local string temps;

	if (other.classname != "camera")
		return;
	temps = self.target;
	self.target = self.message;
	SUB_UseTargets();
	self.target = temps;
	if (self.cnt)
		return;

	self.think = SUB_Remove;
	self.nextthink = time + 10;
	self.solid = SOLID_NOT;
};

void() info_movie_camera =
{
// this does nothing, just serves as a target spot
	//self.use = SUB_Null;
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
	setsize(self, '-8 -8 -8', '8 8 8');
	self.touch = imc_touch;
};

void() camera_use =
{
	self.nextthink = time + 100000;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

void() gocam_use =
{
local entity	control, temp;

	control = find(world, classname, "camcontrol");
	if (control == world)
		dprint("Can't find camcontrol!\n");

	temp = self;
	self = control;
	DHM_CalcMoveDone ();
	self = temp;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

void() trigger_gocamera =
{
	self.use = gocam_use;
};

/*QUAKED info_focal_point (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the point that the camera will face.  It should have a "targetname"
field with the same value as a camera-trigger's "focal_point" field.
*/
void() info_focal_point =
{
// just holds a spot for the focal point.
};

/*QUAKED trigger_camera (.5 .5 .5) ?
A player touching this will be transported to the corresponding info_movie_camera entity. You must set the "target" field, and put a info_movie_camera with a "targetname" field that matches.  The "script" key gives a starting script number, and the "script_delay" key is the amount of time(seconds) to stay on the first script page.

If the trigger_camera has a targetname, it will only enter camera mode after it has been fired.
*/
void() trigger_camera =
{
	if (deathmatch || coop)
		remove (self);

	InitTrigger ();
	self.touch = camera_touch;
	// find the destination 
	if (!self.target)
		objerror ("Camera trigger with no target");
	self.use = camera_use;
};


/* ----------------------------------
  	   Scripting function - dhm
   ---------------------------------- */
/* The original timing idea for scripts was inspired by
	Zoid.  Study the code for Zoid's CTF, it is an
	excellent example of good Quake-C coding.  Also
	look at all of Quake Command's stuff.  Wedge rules.
*/
// Script_play is called from PlayerPreThink()
// 'self' is the player (camera)

void() Script_play =
{
local entity	scrpt, temp;
	
	scrpt = find (world, script_num, self.script);  
	if (!scrpt)
	   dprint ("Error: script not found!");

	/** if script has a target, trigger it once. **/
	if (scrpt.target)
	{
		temp = self;
		self = scrpt;
		SUB_UseTargets ();
		self.target = string_null;
		self = temp;
	}

	self.script_delay = scrpt.script_delay;
	self.script_time = time + 1;
	self.script_count = self.script_count + 1;
	centerprint(self, scrpt.message);

	if (self.script_count == self.script_delay)
	{
	   self.script = scrpt.next_script;
	   if (self.script != "0")
	       self.script_count = 0;
	   else
	     {
		 scrpt.nextthink = time + 3;
		 scrpt.classname = "going_back";
		 scrpt.think = go_back;
	     }
	}
	return;
};


/*QUAKED info_script (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a script.  
It should have a "script_num" field that signifies the script number, and a "next_script" to signal the next script ("0" if this is the last page of the script), a "script_delay" to signify how many seconds to display this page, and of course a "message" field with the text to display.
*/
void() info_script =
{
};


/* ------------------------------ */
/* |	   trigger_cvarset	  | */
/* ------------------------------ */
/*QUAKED trigger_cvarset (.5 .5 .5) (-8 -8 -8) (8 8 32)
You can set any CVAR on the server with this trigger.  Put the CVAR name
in "netname" and put the value in "message".  Useful CVAR's are sv_gravity,  sv_friction, fov, and v_idlescale.
*/
void() change_cvar =
{
local entity	check;

	cvar_set (self.netname, self.message);
	bprint("\n\n\n\n");

	self.classname = "cvar_done";
	check = find(world, classname, "player");
	if(!check)
		check = find(world, classname, "camera");

	check.ideal_yaw = -1;
	
	self.nextthink = time + 0.02;
	self.think = SUB_UseTargets;
};

void() cvarset_touch =
{
    if (self.cnt > time || other.health <= 0 || other.classname != "player")
		return;

	change_cvar();
};

void() trigger_cvarset = 
{
	if (deathmatch || coop)
		remove (self);

	InitTrigger ();
	self.use = change_cvar;
};


/* ------------------------------ */
/* |	   trigger_gravity	  | */
/* ------------------------------ */
/*QUAKED trigger_gravity (.5 .5 .5) (-8 -8 -8) (8 8 32)
This will change the gravity for objects that are inside it.
Put the value to change gravity to in the "gravity" field.
Ziggurat Vertigo used '100' for its low gravity.
*/
void() gravity_use =
{
	if (self.cnt == -1)
	{
		//dprint("Anti-gravity machine turned ON\n");
		self.cnt = 0;
	}
	else
	{
		//dprint("Anti-gravity machine turned OFF\n");
		self.cnt = -1;
	}
};

void() gravity_touch =
{
	if(self.cnt == -1)
		return;
	if(other.deadflag < 2)
	if(other.velocity_z != 0)
	if(other.movetype != MOVETYPE_FLYMISSILE)
	if(other.classname != "BloodCube")
		other.velocity_z = other.velocity_z + (self.delay * frametime);
};

void() trigger_gravity = 
{
local float	worldGravity;

	InitTrigger ();
	worldGravity = cvar("sv_gravity");
	self.delay = worldGravity - self.gravity;
	self.touch = gravity_touch;

	if(self.targetname)
	{
		self.cnt = -1;
		self.use = gravity_use;
	}
};


/* ------------------------------ */
/* |	   trigger_quake		  | */
/* ------------------------------ */
/*QUAKED trigger_quake (.5 .5 .5) (-8 -8 -8) (8 8 32)
Starts an earthquake.  Players view will shake for amount of time you
put in "wait".  Place the richter scale of the quake in the "dmg" field.
It will also trigger all targets like a 'trigger_once'.
*/

void() q_trig =
{
	SUB_UseTargets();
	remove(self);
};

void() kick_me = 
{
local float		n;
local entity 	play;

	if(self.cnt < time)
		remove(self);

	play = find(world, classname, "player");
	if(!play)
		return;

	if (!(play.flags & FL_ONGROUND))
	{
		self.nextthink = time + 0.15;
		if (self.delay < time)
		{
		   self.delay = time + 3;
		   sound(play, CHAN_AUTO, "ambience/equake.wav", 1, ATTN_NORM);
		}
		return;
	}
	if (self.delay < time)
	{
	    self.delay = time + 3;
	    sound(play, CHAN_AUTO, "ambience/equake.wav", 1, ATTN_NORM);
	}

	n = self.dmg / 2;
	play.punchangle_x = (random() * self.dmg) - n;
	play.punchangle_y = (random() * self.dmg) - n;
	play.punchangle_z = (random() * self.dmg) - n;
	self.nextthink = time + 0.15;
	self.think = kick_me;
};

void() tq_use =
{
local entity	kicker;

	if (activator.health <= 0 || activator.classname != "player")
		return;

	kicker = spawn();
	kicker.cnt = time + self.wait;    //remove kicker when wait expires.
	kicker.delay = 0;
	kicker.dmg = self.dmg;
	kicker.nextthink = time + 0.2;
	kicker.think = kick_me;

	q_trig();
};

void() tq_touch =
{
local entity	kicker;

	if (other.health <= 0 || other.classname != "player")
		return;

	kicker = spawn();
	kicker.cnt = time + self.wait;    //remove kicker when wait expires.
	kicker.delay = 0;
	kicker.dmg = self.dmg;
	kicker.nextthink = time + 0.2;
	kicker.think = kick_me;

	q_trig();
};

void() trigger_quake =
{
	if (deathmatch || coop)
	{
		self.think = q_trig;
		self.nextthink = time + 0.5;
		return;
	}

	precache_sound2 ("ambience/equake.wav");
	InitTrigger ();

      self.use = tq_use;
	self.touch = tq_touch;
};