
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
	setorigin (s, o.origin);
};

void() name_player =
{
local entity play;

	play = find(world, classname, "camera");
	play.classname = "player";
	stuffcmd(play, "-forward\n");
};

void() go_back = 
{
local entity	t,c,d;
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
	c.weaponmodel = t.weaponmodel;
	c.flags = t.flags;
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
	d.nextthink = time + 0.1;
	d.think = name_player;

	val = ftos (c.cnt);
	cvar_set ("viewsize", val);  	//restore old viewsize
	cvar_set ("v_idlescale", "0");  //stop the swaying camera

	t.nextthink = time + 0.1;
	t.think = SUB_Remove;
	remove(self);
};

/* This routine short-circuits player turning movement while 
     in camera mode.
*/
void() look_ahead = 
{
	self.angles = self.enemy.mangle;
	self.fixangle = 1;
	self.nextthink = time + 0.01;
};

void() go_camera =
{
// Change the player into a camera
	self.classname = "camera";
	self.velocity = '0 0 0';
	self.view_ofs = '0 0 0';
	self.angles = self.enemy.mangle;
	self.fixangle = 1;		// turn this way immediately
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.weaponmodel = "";

// Keep player looking straight ahead
	self.nextthink = time + 0.05;
	self.think = look_ahead;
 
//Setting script_count to 0 is what triggers the script to play,
//  It will then play the script number.
	if (!self.script)
		dprint ("trigger_camera needs a script number");
	self.script_count = 0;

//Save current viewscreen size to return to after camera.
	self.cnt = cvar("viewsize");
	cvar_set ("viewsize", "120");	 //Full screen
	cvar_set ("v_idlescale", "1");  //Swaying camera

	setorigin (self, self.enemy.origin);
};

void() camera_touch =
{
local entity	t;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

// only activate for player
	if (other.health <= 0 || other.classname != "player" || self.cnt == -1)
		return;

	SUB_UseTargets ();

//If player is on ground, take him off ground so no one gets confused
	if (other.flags & FL_ONGROUND)
	    other.flags = other.flags - FL_ONGROUND;

// put a dummy where the player was
	spawn_dummy (other);

// find camera
	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");

// Go to the camera - not in this function, because touch functions are
// called while looping through c code, and you don't want to move the 
// player, or something like that?
	other.enemy = t;		//save camera position, etc.
	other.script = self.script;	//save script number
	other.script_delay = self.script_delay;  //save delay for page 1
	other.nextthink = time + 0.05;
	other.think = go_camera;

	self.cnt = -1;  //used to make sure only one dummy is spawned;

//Remove the trigger_camera from level
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

/*QUAKED info_movie_camera (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a camera.  It should have a "targetname" field with the same value as a camera-trigger's "target" field.  The "mangle" controls the view just like a info_intermission(pitch roll yaw).
*/
void() info_movie_camera =
{
// this does nothing, just serves as a target spot
};

void() camera_use =
{
	self.nextthink = time + 100000;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
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
		objerror ("no target");
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

void() Script_play =
{
local entity	scrpt;
	
	scrpt = find (world, script_num, self.script);  
	if (!scrpt)
	   dprint ("Error: script not found!");

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
		 scrpt.nextthink = time + 4;
		 scrpt.think = go_back;
	     }
	}
	return;
};


/*QUAKED info_script (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a script.  
It should have a "script_num" field that signifies the script number, and a "next_script" to
signal the next script ("0" if this is the last page of the script), a "script_delay" to
signify how many seconds to display this page, and of course a "message" field with the text to
display.
*/
void() info_script =
{
};