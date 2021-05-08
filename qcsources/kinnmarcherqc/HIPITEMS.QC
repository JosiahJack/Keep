/* Items QuickC program
   By Jim Dose'  9/13/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

//bdw - removed hip powerups
//bdw - removed hip weapons
//bdw - removed spikemine

//============================================================================


//bdw - replaced .lastvictim with .oldenemy - just an arbitrary choice and you might want to consider something more appropriate in future...

float LIGHTNING_RANDOM = 1;
float LIGHTNING_BOOM = 2;
//BDW quiet noise...
float LIGHTNING_QUIET =4;

void() SpawnLightningThink =
   {
   if (time > self.delay)
      {
      remove(self);
      return;
      }
   self.think = SpawnLightningThink;
   if (checkclient())
      {
      WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
      WriteEntity (MSG_BROADCAST, self);
      WriteCoord (MSG_BROADCAST, self.origin_x);
      WriteCoord (MSG_BROADCAST, self.origin_y);
      WriteCoord (MSG_BROADCAST, self.origin_z);
      WriteCoord (MSG_BROADCAST, self.oldorigin_x);
      WriteCoord (MSG_BROADCAST, self.oldorigin_y);
      WriteCoord (MSG_BROADCAST, self.oldorigin_z);
      }
   LightningDamage(self.origin, self.oldorigin, self.oldenemy, self.dmg);
   self.nextthink = time + 0.1;
   };



void() bdw_lightning_switch_light =
{
	local entity temp;
	
	temp = self;
	self = self.trigger_field;
	self.use();
	self = temp;
};

void() bdw_lightning_switch_light_off =
{
	bdw_lightning_switch_light();
	remove(self);
};

void() trap_lightning_use =
{
   	local vector p1, p2;
   	local vector dir;
   	local float dst;
   	local float remainder;
      local entity temp;
	local entity loff;	//bdw - spawns an ent to turn the light off.


//bdw - trigger light - remember to turn it off!
	if (self.trigger_field)
	{
		/*if (self.trigger_field.spawnflags & 1)	//off, as it should be*/
			bdw_lightning_switch_light();		//turn it on
		/*else
			dprint("error! lightning light on when it shouldn't be!\n");*/

		loff = spawn();
		loff.trigger_field = self.trigger_field;
		loff.think = bdw_lightning_switch_light_off;	//turn it off later
		loff.nextthink = time + self.duration;		
	}
//bdw end


   	if (time >= self.pausetime)
      {
      	if (self.spawnflags & LIGHTNING_BOOM)
         		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);

//BDW 09/09/00 option for quiet sound...
		else if (self.spawnflags & LIGHTNING_QUIET)
			sound (self, CHAN_AUTO, "weapons/lhit.wav", 0.5, 2);
//BDW
      	else
         		sound (self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
      
		if (self.classname == "trap_lightning_triggered")
         		self.pausetime = time + 0.1;
      }

   	if (self.target)
      {
      	p1 = self.origin;
      	p2 = self.enemy.origin;
      }
   	else
      {
      	makevectors (self.angles);
      	self.movedir = v_forward;
      	traceline (self.origin, self.origin + self.movedir*600, TRUE, self);
      	p1 = self.origin;
      	p2 = trace_endpos;
      }
   	// fix up both ends of the lightning
   	// lightning bolts are 30 units long each
   	dir = normalize( p2-p1 );
   	dst = vlen(p2-p1);
   	dst = dst / 30.0;
   	remainder = dst - floor(dst);
   	if (remainder > 0)
      {
      	remainder = remainder - 1;
      	// split half the remainder with the front and back
      	remainder = remainder * 15;
      	p1 = p1 + (remainder*dir);
      	p2 = p2 - (remainder*dir);
      }
   	if (self.duration > 0.1)
      {

      	temp = self;
      	self = spawn();
      	self.origin = p1;
      	self.oldorigin = p2;
      	self.oldenemy = temp;
      	self.dmg = temp.dmg;
      	self.delay = time + temp.duration;
      	SpawnLightningThink();
      	self = temp;
      }
   	else if (checkclient())
      {
      	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
      	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
      	WriteEntity (MSG_BROADCAST, self);
      	WriteCoord (MSG_BROADCAST, p1_x);
      	WriteCoord (MSG_BROADCAST, p1_y);
      	WriteCoord (MSG_BROADCAST, p1_z);
      	WriteCoord (MSG_BROADCAST, p2_x);
      	WriteCoord (MSG_BROADCAST, p2_y);
      	WriteCoord (MSG_BROADCAST, p2_z);
      	LightningDamage(p1, p2, self, self.dmg);
      }
   	else
      	LightningDamage(p1, p2, self, self.dmg);
};

void() lightning_think =
{
   	local float timedelay;

   	if (self.state)
      {
      	trap_lightning_use();
      }
   	if (self.cnt == 0)
      {
      	if (self.spawnflags & LIGHTNING_RANDOM)
         	{
         		timedelay = self.wait*random();
         	}
      	else
         	{
         		timedelay = self.wait;
         	}
      	self.cnt = 1;
      	self.t_length = time + self.duration - 0.1;
      	self.pausetime = time + self.duration - 0.1;
      	if (self.pausetime  < time + 0.3)
         		self.pausetime = time + 0.3;
      	if (timedelay < self.duration)
         		timedelay = self.duration;
      	self.t_width = time + timedelay;
      }
   	if (time >= self.t_length)
      {
      	self.cnt = 0;
      	self.nextthink = self.t_width;
      }
   	else
      {
      	self.nextthink = time + 0.2;
      }
   };

void() lightning_firstthink =
{
   	local entity targ, temp;

   	if (self.target)
      {
      	targ = find(world, targetname, self.target);

	//bdw 22/03/04 - can now trigger lights
		//self.dest = targ.origin;
      	//self.enemy = targ;

		while(targ)
		{
			if (targ.classname == "info_notnull")
			{
				self.dest = targ.origin;
      			self.enemy = targ;
			}
			else if (targ.classname == "light")
			{
				temp = self;
				self = targ;				
				lightstyle(self.style, "a");
				self.spawnflags = self.spawnflags | 1;	//this just makes sure the light starts off
											//in practice, you should always set "start off" in the editor anyway.
				self = temp;
			
				self.trigger_field = targ;	//bdw - "trigger_field" is arbitrary
			}

			targ = find(targ, targetname, self.target);
		}      	
      }

   	self.think = SUB_Null;
   	self.nextthink = 0;
   	if (self.classname != "trap_lightning_triggered")
      {
      	self.nextthink = self.huntingcharmer + self.wait + self.ltime;
      	self.think = lightning_think;
      }
};

/*QUAKED trap_lightning_triggered (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
When triggered, fires lightning in the direction set in QuakeEd.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
*/

void() trap_lightning_triggered =
   {
   if (self.wait == 0)
      self.wait = 1.0;
   if (self.dmg == 0)
      self.dmg = 30;
   if (self.duration == 0)
      self.duration = 0.1;
   self.cnt = 0;
   self.use = trap_lightning_use;
   precache_sound ("weapons/lhit.wav");
   precache_sound ("weapons/lstart.wav");
   self.huntingcharmer = self.nextthink;
   self.think = lightning_firstthink;
   self.nextthink = time + 0.25;
   self.deathtype = "is electrocuted";
   };


/*QUAKED trap_lightning (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
Continuously fire lightning.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"nextthink" delay before firing first lightning, so multiple traps can be stagered.
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
*/
void() trap_lightning =
   {
   trap_lightning_triggered ();
   self.state = 1;
   };

void() trap_lightning_switched_use =
   {
   self.state = 1 - self.state;
   if (self.state == 1)
      self.nextthink = self.huntingcharmer;
   };
/*QUAKED trap_lightning_switched (0 .5 .8) (-8 -8 -8) (8 8 8) random boom
Continuously fires lightning.
"wait" how long to wait between blasts (1.0 default)
       if in random mode wait is multiplied by random
"nextthink" delay before firing first lightning, so multiple traps can be stagered.
"dmg" how much damage lightning should inflict (30 default)
"duration" how long each lightning attack should last (0.1 default)
"state" 0 (default) initially off, 1 initially on.
*/
void() trap_lightning_switched =
   {
   trap_lightning_triggered ();
   self.use = trap_lightning_switched_use;
   };

//bdw - removed god's wrath, tesla trap, gravity stuff etc...


