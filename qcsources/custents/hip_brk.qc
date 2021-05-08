/* Breakaway walls QuickC program
   By Jim Dose'  9/11/96
	Modified by General WarT
*/

float MULTI_USE = 1;
float INVISIBLE = 2;

void() damagethreshold_killed =
{
	self.health = self.max_health;

	activator = damage_attacker;
	self.takedamage = DAMAGE_NO;
	SUB_UseTargets ();
	self.takedamage = DAMAGE_YES;

	if ( !( self.spawnflags & MULTI_USE ) )
	{
		remove( self );
	}
};

void() damagethreshold_pain =
{
	self.health = self.max_health;
};

/*QUAKED trigger_damagethreshold (0 .5 .8) ? MULTI_USE INVISIBLE
Triggers only when a threshold of damage is exceeded.
When used in conjunction with func_breakawaywall, allows
walls that may be destroyed with a rocket blast.

MULTI_USE tells the trigger to not to remove itself after
being fired.  Allows the trigger to be used multiple times.

INVISIBLE tells the trigger to not be visible.

"health" specifies how much damage must occur before trigger fires.
Default is 60.

*/

void() trigger_damagethreshold =
{
	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "damagethreshold";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	if ( self.spawnflags & INVISIBLE )
	{
      self.model = string_null;
	}

	if (!self.health)
	{
		self.health = 60;
	}
	self.max_health = self.health;
	self.takedamage = DAMAGE_YES;

	self.blocked = SUB_Null;
	self.th_pain = damagethreshold_pain;
	self.th_die  = damagethreshold_killed;
};

// ### Added feature for Custents
// allows the break down of walls using the func_counter and also
// the make the breakawaywalls optionally trigger another entity and/or
// blow up when they are triggered.
void() func_breakawaywall_use =
{
	local float which, index;

	if(self.cnt != 0)
	{
		if(counter_GetCount (other) != self.cnt)
			return;
	}
	
	// positions it for correct placement of explosion stuff
	self.use = SUB_Null;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setorigin(self, self.neworigin);

	if (self.spawnflags & 2) // use particles
	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST,self.origin_x);
		WriteCoord (MSG_BROADCAST,self.origin_y);
		WriteCoord (MSG_BROADCAST,self.origin_z);
	}

	if(self.target)
		SUB_UseTargets();

//	allows it to throw rubble when it explodes.
	if(self.count)
	{
		self.cnt = 0;
		rubble_use();
	}

	if (self.spawnflags & 1) // become explosion
	{
		BecomeBigExplosion();
//		BecomeExplosion();
		sound (self, CHAN_VOICE, "misc/shortexp.wav", 1, ATTN_NORM);
	}
	else
		remove(self);
};
// ###

/*QUAKED func_breakawaywall (0 .5 .8) ?
Special walltype that removes itself when triggered.
*/

void() func_breakawaywall =
{
	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "breakaway";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
// ### Added features for Custents
	self.use = func_breakawaywall_use;
	
	// the origin in the center for explosion stuff
	self.neworigin = (self.absmin + self.absmax)*0.5;

	
	if (self.spawnflags & 1) // become explosion
		precache_sound ("misc/shortexp.wav");

// allows it to throw rubble when it is triggered.
	if(self.count)
	{
		precache_model ("progs/rubble1.mdl");
		precache_model ("progs/rubble2.mdl");
		precache_model ("progs/rubble3.mdl");
		precache_sound ("zombie/z_hit.wav");
		if(self.skin < 0)
			self.skin = floor(random()*14);
	}
// ###
};
