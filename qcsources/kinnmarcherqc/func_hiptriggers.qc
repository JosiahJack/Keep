/* Trigger QuickC program
   By Jim Dose'  12/2/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

float USE_GOLD_KEY = 1;

void() keytrigger_use =
{
   	if (activator.classname != "player")
		return;
   	if (self.attack_finished > time)
		return;

   	self.attack_finished = time + 2;

	// FIXME: blink key on player's status bar
   	if ( (self.items & activator.items) != self.items )
      {
      	if (self.message != "")
         		centerprint (activator, self.message);
      	else
         	{
			if (self.items == IT_KEY1)	//bdw - bugfix
            	{
            		if (world.worldtype == 2)
               			centerprint (activator, "You need the silver keycard");
            		else if (world.worldtype == 1)
               			centerprint (activator, "You need the silver runekey");
            		else if (world.worldtype == 0)
               			centerprint (activator, "You need the silver key");
            	}
         		else
            	{
            		if (world.worldtype == 2)
               			centerprint (activator, "You need the gold keycard");
            		else if (world.worldtype == 1)
               			centerprint (activator, "You need the gold runekey");
            		else if (world.worldtype == 0)
               			centerprint (activator, "You need the gold key");
            	}
         	}
      	sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
      	return;
      }

   activator.items = activator.items - self.items;

   // we can't just remove (self) here, because this is a touch function
   // called while C code is looping through area links...
   self.touch = SUB_Null;
   self.use = SUB_Null;
   self.nextthink = time + 0.1;
   self.think = SUB_Remove;
   self.message = "";

   sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);

   SUB_UseTargets();
};

void() keytrigger_touch =
   {
   activator = other;
   keytrigger_use();
   };

/*QUAKED trigger_usekey (0 .5 0) ? USE_GOLD_KEY
Variable sized single use trigger that requires a key to trigger targets.  Must be targeted at one or more entities.

"message" is printed when the trigger is touched without having the right key.
*/

void() trigger_usekey =
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

   if (self.spawnflags & USE_GOLD_KEY)
      self.items = IT_KEY2;
   else
      self.items = IT_KEY1;

   self.use = keytrigger_use;
   self.touch = keytrigger_touch;

	InitTrigger ();
   };

void() remove_touch =
   {
   if (other.flags & self.cnt)
      return;
   other.touch = SUB_Null;
   other.model = "";
   remove(self);
//   other.nextthink = time + 0.1;
//   other.think = SUB_Remove;
   };

/*QUAKED trigger_remove (.5 .5 .5) ? ignoremonsters ignoreplayers
Variable sized trigger that removes the thing
that touches it.  Does not affect monsters or
players.
*/
void() trigger_remove =
   {
   self.cnt = FL_CLIENT|FL_MONSTER;
   if (self.spawnflags & 1)
      self.cnt = self.cnt - FL_MONSTER;
   if (self.spawnflags & 2)
      self.cnt = self.cnt - FL_CLIENT;
   InitTrigger ();
   self.touch = remove_touch;
   };



/*void() trigger_command_use =
   {
   if ( self.message )
      localcmd( self.message );
   };*/

/*QUAKED trigger_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
 When triggered, stuffs a command into the console to allow map
 designers to set server variables.

 "message" is the command to send to the console.
*/

/*void() trigger_command =
   {
   self.use = oncount_use;
	self.think = SUB_Null;
   };*/

void() trigger_decoy_touch =
   {
   if (other.classname != "monster_decoy")
      return;
   self.touch = SUB_Null;
   self.nextthink = time + 0.1;
   self.think = SUB_Remove;
   SUB_UseTargets();
   };

/*QUAKED trigger_decoy_use (.5 .5 .5) ?
 only the decoy player can trigger this
 once triggers, all targets are used
*/

void() trigger_decoy_use =
   {
   if (deathmatch)
	{
		remove(self);
		return;
	}
   InitTrigger ();
   self.touch = trigger_decoy_touch;
   };

void() trigger_waterfall_touch =
   {
   // only affect players
   if (!(other.flags & FL_CLIENT))
      {
      return;
      }

   other.velocity = other.velocity + self.movedir;
   other.velocity_x = other.velocity_x + self.count * ( random() - 0.5 );
   other.velocity_y = other.velocity_y + self.count * ( random() - 0.5 );
   };

/*QUAKED trigger_waterfall (.2 .5 .2) ?
 Pushes the player in the direction specified by angles.

 "speed" is the strength of the push (default 50).
 "count" amount of random xy movement to add to velocity (default 100).
*/

void() trigger_waterfall =
   {
   InitTrigger ();
   self.touch = trigger_waterfall_touch;

   if ( self.count == 0 )
      {
      self.count = 100;
      }

   if ( self.speed == 0 )
      {
      self.movedir = self.movedir * 50;
      }
   else
      {
      self.movedir = self.movedir * self.speed;
      }
   };

/*
================
BEN'S STUFF
================
*/

//BDW 06/09/00 - a simple yet obvious trigger...
/*QUAKED trigger_activated (.5 .5 .5) ?
Variable sized trigger. Needs to be triggered by another entity self.cnt times. It is then "activated" and behaves exactly 
like a normal trigger, and can even be triggered by touching. Uses exactly the same fields as a trigger_multiple.

target
targetname
sounds	-	same as usual triggers (default none)
message	- 	message displayed when fired properly (default none)
deathtype  	-	message displayed when it becomes active
delay		- 	delay before it fires its targets (when activated) (default none)
killtarget	-	removes this entity(s) from world
cnt		-	no. of times it needs to be triggered before it becomes active (default 1)

*/

float ACTIVATE_MULTIPLE = 2;

void() trigger_activated_use =
{
	self.cnt = self.cnt - 1;
	if (self.cnt == 0)
	{
		//print the "deathtype" message...
		if (activator.classname == "player" && self.deathtype != "")
		{
			centerprint(activator, self.deathtype);
			sound(activator, CHAN_AUTO, "misc/talk.wav", 1, ATTN_NORM);
		}
		self.use = multi_use;
		self.touch = multi_touch;
	}
};

void() trigger_activated =
{
	if (self.cnt < 1)
		objerror("you need to set self.cnt\n");

	if (!self.spawnflags & ACTIVATE_MULTIPLE)
		self.wait = -1;	//trigger once
	
	trigger_multiple();
	self.use = trigger_activated_use;
	self.touch = SUB_Null;
	self.health = 0;	//don't really need this
};

//=====================================================================

void() trigger_multimessage_change =
{
	local float d;

	if (self.cnt == 2)
	{
		self.message = self.target2;
		d = self.delay2;
	}
	else if (self.cnt == 3)
	{
		self.message = self.target3;
		d = self.delay3;
	}
	else if (self.cnt == 4)
	{
		self.message = self.target4;
		d = self.delay4;
	}
	else if (self.cnt == 5)
	{
		self.message = self.target5;
		d = self.delay5;
	}
	else
	{
		remove(self);
		return;
	}	

	self.voice_finished = self.voice_finished + d;
};

void() trigger_multimessage_use =
{
	self.use = SUB_Null;

	if (!self.enemy)
		self.enemy = activator;	

	if (!self.cnt)	//just been activated
	{
		self.message = self.target1;
		self.voice_finished = time + self.delay1;
		self.cnt = 1;
		self.sounds = TRUE;
	}

	if (self.enemy.classname == "player")
	{
		centerprint(self.enemy, self.message);
		if ((self.sounds) && (self.message != ""))
			sound(self.enemy, CHAN_AUTO, "misc/talk.wav", 1, ATTN_NORM);
	}

	self.think = trigger_multimessage_use;

	if (time + 1.5 < self.voice_finished)
	{
		self.sounds = FALSE;
		self.nextthink = time + 1.5;		//refresh the centerprint (centerprints disappear after ~ 2 secs)
	}
	else
	{
		self.sounds = TRUE;
		self.cnt = self.cnt + 1;
		self.nextthink = self.voice_finished;
		trigger_multimessage_change();
	}
};

/*
=======================================================================
trigger_multimessage

A rather cool trigger that lets you do some nice centerprinted text sequences. Up to five "pages" allowed.
You can set the duration of the text for each page using the delay keys.

<target1-5>		put the messages in here
<delay>		self.delay is the master delay value, if this is set but not the others, then they will adopt this value
<delay1-5> 		use these to override .delay for the corresponding messages
=======================================================================
*/

void() trigger_multimessage =
{	
	if (!self.delay)
		self.delay = 2;

	if (!self.delay1)
		self.delay1 = self.delay;
	if (!self.delay2)
		self.delay2 = self.delay;
	if (!self.delay3)
		self.delay3 = self.delay;
	if (!self.delay4)
		self.delay4 = self.delay;
	if (!self.delay5)
		self.delay5 = self.delay;

	self.cnt = 0;
	self.use = trigger_multimessage_use;
};

/*
=================================

VORTAL FIRE

A rather visual sprite-based teleporter

Must be triggered to appear, and then functions just like
a normal teleporter. Target info_teleport_destination

Alternatively, if you specify a mapname in the .map field, the vortal fire
will function as a trigger_changelevel. Remember that you don't need any
fancy stuff with the mapname, eg. for maps/e1m1.bsp, just put "map" "e1m1".

Place 64 units off the ground to look right.

=================================
*/
/*
void() vortal_bob =
{
	local vector ang;

	self.count = self.count + (200 * frametime);	//increment imaginary angle
	if (self.count > 360)
      	self.count = self.count - 360;

	ang_x = self.count;
   	ang_y = 0;
   	ang_z = 0;
   	makevectors(ang);
   	self.origin_z = self.aflag + v_forward_z * 10;
   	setorigin(self, self.origin );

	self.nextthink = 1;	//called every frame.
};

void() spawn_vortalfire =
{
	local entity new;

	new = spawn();


	setmodel(new, "sprites/vortfire/vortfire.spr");
	setsize(new, '0 0 0', '0 0 0');
	setorigin(new, self.origin);

	new.aflag = new.origin_z;
	
	new.think = vortal_bob;
	new.nextthink = time + 0.1;
};
*/

//this function allows you to spawn ambient sounds at any time, not just at level start...
void(float soundnum, vector org, float ambvolume, float atten) spawnambient = 
{ 
	WriteByte(MSG_ALL, SVC_SPAWNSTATICSOUND); 
	WriteCoord(MSG_ALL, org_x); 
	WriteCoord(MSG_ALL, org_y); 
	WriteCoord(MSG_ALL, org_z); 
	WriteByte(MSG_ALL, soundnum); 		//see number of sound in world.qc
	WriteByte(MSG_ALL, ambvolume * 255); 	//translate this into a value between 0 and 255... 
	WriteByte(MSG_ALL, atten * 64); 		//attenuation multiplier
}; 

void() vortalfire_use =
{
	self.use = SUB_Null;
	self.targetname = "";	//so teleport_touch works properly

	if (self.map != "")
		self.touch = changelevel_touch;
	else
		self.touch = teleport_touch;

	self.solid = SOLID_TRIGGER;		

	setmodel(self, "sprites/vortfire/vortfire.spr");
	setsize(self, '-32 -32 -32', '32 32 32');

	spawnambient(1, self.origin, 1, ATTN_STATIC);

	//spawn_vortalfire();
};

void() trigger_teleport_vortalfire =
{
	precache_model("sprites/vortfire/vortfire.spr");

	if (!self.targetname)
		vortalfire_use();
	else
		self.use = vortalfire_use;
};













