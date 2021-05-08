/*
 * $Header: /H2 Mission Pack/HCode/Buttons.hc 3     3/02/98 11:51a Mgummelt $
 */
// button and multiple button

float SPAWNFLAG_BUTTON_ACTIVATE = 1;
float FIRE_MULTIPLE				= 4;
float BUTTON_TOGGLE				= 8;
float FACING_ANGLE				= 16;

void() button_wait;
void() button_return;

void() button_wait =
{
   self.state = STATE_TOP;
	if(self.wait==-1)
		if(!self.inactive)
			self.nextthink=-1;
		else
			self.nextthink=self.ltime+0.3;
	else
		self.nextthink = self.ltime + self.wait;
	self.think = button_return;
	activator = self.enemy;
	if (!self.inactive)
		SUB_UseTargets();
	self.frame = 1;			// use alternate textures
};

void() button_done =
{
	self.state = STATE_BOTTOM;
};

void() button_return =
{
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos1, self.speed, button_done);
	self.frame = 0;			// use normal textures
	if (self.health)
		self.takedamage = DAMAGE_NO;	// can be shot again
	
	//Inky 20201213 A fire toggle button triggers its target upon return as well
	//(use in conjunction with a trigger_message_transfer to have a different effect when being pushed or released)
	if(self.spawnflags & BUTTON_TOGGLE && self.health > 0 && !self.inactive)
		SUB_UseTargets();
};

void() button_blocked =
{	// do nothing, just don't come all the way back out
};

void() button_fire =
{
	if (self.inactive)
	{
		if (other.classname == "player" && self.map) 
		{
			centerprint(other, self.map);
		}
		return;	
	}

	if(self.spawnflags&BUTTON_TOGGLE&&self.state==STATE_TOP)
	{//Toggle button, done moving
		button_return();
		return;
	}
	else if (self.state == STATE_UP && self.deathtype!="use")
		return;

	if (self.soundtype > -1) //Inky 20200725 -1 means silent
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	
	self.state = STATE_UP;
	if (self.spawnflags & /*Frame then move*/32) self.frame = 1;			// use alternate textures
	SUB_CalcMove (self.pos2, self.speed, button_wait);
};

void() button_use =
{
	self.enemy = activator;
	self.deathtype="use";
	button_fire ();
};

void() button_touch =
{	
//	if(self.inactive)
//		return;

	if (self.state == STATE_TOP) return;

	if (self.spawnflags & /*Player touch only*/64 && other.classname != "player") return;
	
	//Inky 20201104 If the button has the "Facing angle" spawnflags, ensure that the player is facing the button
	if (self.spawnflags & FACING_ANGLE)
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	self.deathtype="touch";
	button_fire ();
};

void() button_killed =
{
	self.enemy = damage_attacker;
	self.health = self.max_health;
	if(!(self.spawnflags & BUTTON_TOGGLE && self.health > 0)) self.takedamage = DAMAGE_NO;	// wil be reset upon return //Inky 20201213 Added the if condition
	self.deathtype="killed";
	button_fire ();
};

/*QUAKED func_button (0 .5 .8) ? deactivated FIREONLY FIRE_MULTIPLE TOGGLE x x
When a button is touched, it moves some distance in the direction of it's angle, triggers all of it's targets, waits some time, then returns to it's original position where it can be triggered again,
unless it's a pressure plate, in which case it will not return to it's position until it's not being touched anymore.
FIREONLY - has to be killed, touching won't do it.
FIRE_MULTIPLE - can be shot over and over (give it a high health)
TOGGLE - Button will wait at up and down positions for activations, assumes a wait of -1
-----------------------FIELDS-------------------------
"angle"		determines the opening direction
"target"	all entities with a matching targetname will be used
"speed"		override the default 40 speed
"wait"		override the default 1 second wait (-1 = never return)
"lip"		override the default 4 pixel lip remaining at end of move
"health"	if set, the button can be killed and touched
"abslight" - to set the absolute light level
"soundtype"
-1) Silent      //Inky 20200725
0) steam metal
1) wooden clunk
2) metallic click
3) in-out

deactivated - button must be activated before it will work
--------------------------------------------------------
*/
void() func_button =
{

	if (self.noise)
	{
		precache_sound (self.noise);
	}
	else if (self.sounds == 0)
	{
		precache_sound ("buttons/airbut1.wav");
		self.noise = "buttons/airbut1.wav";
	}
	else if (self.sounds == 1)
	{
		precache_sound ("buttons/switch21.wav");
		self.noise = "buttons/switch21.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("buttons/switch02.wav");
		self.noise = "buttons/switch02.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("buttons/switch04.wav");
		self.noise = "buttons/switch04.wav";
	}
	else if (self.sounds == 4)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	
	SetMovedir ();

	self.classname="button";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel (self, self.model);

	self.blocked = button_blocked;
	self.use = button_use;

	if (self.health)
	{
		self.max_health = self.health;
		if(self.spawnflags&FIRE_MULTIPLE)
			self.th_pain = button_use;//for multiple uses
		self.th_die = button_killed;
		self.takedamage = DAMAGE_YES;
	}
	
	if (!self.spawnflags & 2)
	{
		//if (!self.health) self.health = 10;
		self.touch = button_touch;
	}

	if (!self.speed)
		self.speed = 40;
	if(self.spawnflags&BUTTON_TOGGLE)
		self.wait=-1;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 4;
	if (self.lip>0 && self.lip<1) //Inky 20210110 Trick to have a lip exactly equal to zero (put a dummy 0.1 or w/e value)
		self.lip = 0;
	
	//If activatable, set usable flags off
	if(self.spawnflags&SPAWNFLAG_BUTTON_ACTIVATE)
	   self.inactive=TRUE;
	else self.inactive=FALSE;

	self.state = STATE_BOTTOM;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

	self.ltime = time;
};