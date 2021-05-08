
entity stemp, otemp, s, old;


void() trigger_reactivate =
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

// the wait time has passed, so set back up for another activation
void() multi_wait =
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void() multi_trigger =
{
	if (self.nextthink > time)
	{
		return;		// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;
		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);
	}

	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;
	
	SUB_UseTargets();

	if (self.wait > 0)	
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
};

void() multi_killed =
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use =
{
	self.enemy = activator;
	multi_trigger();
};

void() multi_touch =
{
	if (other.classname != "player")
		return;
	
// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	multi_trigger ();
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_multiple =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}
	
	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) )
		{
			self.touch = multi_touch;
		}
	}
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void() trigger_once =
{
	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void() trigger_relay =
{
	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void() trigger_secret =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	total_secrets = total_secrets + 1;
	self.wait = -1;
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = 1;
	
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = "misc/talk.wav";
	}

	trigger_multiple ();
};

//=============================================================================


void() counter_use =
{
	local string junk;

	self.count = self.count - 1;
	if (self.count < 0)
		return;
	
	if (self.count != 0)
	{
		if (activator.classname == "player"
		&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			if (self.count >= 4)
				centerprint (activator, "There are more to go...");
			else if (self.count == 3)
				centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint (activator, "Only 2 more to go...");
			else
				centerprint (activator, "Only 1 more to go...");
		}
		return;
	}
	
	if (activator.classname == "player"
	&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		centerprint(activator, "Sequence completed!");
	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void() trigger_counter =
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};

/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/

float	PLAYER_ONLY	= 1;
float	SILENT = 2;

void() play_teleport =
{
	local	float v;
	local	string tmpstr;

	v = random() * 5;
	if (v < 1)
		tmpstr = "misc/r_tele1.wav";
	else if (v < 2)
		tmpstr = "misc/r_tele2.wav";
	else if (v < 3)
		tmpstr = "misc/r_tele3.wav";
	else if (v < 4)
		tmpstr = "misc/r_tele4.wav";
	else
		tmpstr = "misc/r_tele5.wav";

	sound (self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove (self);
};

void(vector org) spawn_tfog =
{
	s = spawn ();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};


void() tdeath_touch =
{
	if (other == self.owner)
		return;

// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
//----------------------------------------------------/ New Code /--------//
            if (self.owner.flags & FL_MONSTER)
            {
                // Make sure all protection is removed.
                if (self.owner.invincible_finished)
                {
                    // Remove invulnerability.
                    self.owner.items = self.owner.items - (self.owner.items & IT_INVULNERABILITY);
                    self.owner.invincible_finished = 0;
                    self.owner.invincible_time = 0;
                }
                if ((!self.owner.takedamage) && (self.owner.health > 0))
                {
                    // Negate mega enforcer's shields.
                    self.owner.takedamage = DAMAGE_AIM;
                }
            }
//------------------------------------------------------------------------//
			T_Damage (self.owner, self, self, 50000);
			return;
		}
		
	}
//----------------------------------------------------/ New Code /--------//
    else if (other.flags & FL_MONSTER)
    {
        if (other.master.classname == "player")
        {
            // Enemy monsters who try to teleport on top of a player's
            // familiar are destroyed unless they are invulnerable.
            // If defender is invulnerable, the teleporting monster
            // always loses regardless of invulnerability.
            if (self.owner.classname != "player")
            {
                if (other.invincible_finished > time)
                {
                    // Familiar is invulnerable.
                    self.classname = "teledeath2";
                    if (self.owner.flags & FL_MONSTER)
                    {
                        // Make sure all protection is removed.
                        if (self.owner.invincible_finished)
                        {
                            // Remove invulnerability.
                            self.owner.items = self.owner.items - (self.owner.items & IT_INVULNERABILITY);
                            self.owner.invincible_finished = 0;
                            self.owner.invincible_time = 0;
                        }
                        if ((!self.owner.takedamage) && (self.owner.health > 0))
                        {
                            // Negate mega enforcer's shields.
                            self.owner.takedamage = DAMAGE_AIM;
                        }
                    }
                }
                else if (other != other.master.draco)
                {
                    if (self.owner.master.classname == "player")
                        if (self.owner == self.owner.master.draco)
                        {
                            // Exception:  Draco has priority over minors.
                            if (other.health)
                                T_Damage (other, self, self, 50000);
                            return;
                        }
                }

                // If not protected (or if already dead), then die.
                if ((!self.owner.invincible_finished) &&
                    (self.owner.takedamage || (self.owner.health <= 0)))
                {
                    // other monsters explode themselves
                    T_Damage (self.owner, self, self, 50000);
                    return;
                }

                // If the function makes its here, it will go to the bottom,
                // and the familiar will be destroyed.
            }
        }
        else if ( (other.invincible_finished > time) || ((!other.takedamage) && (other.health > 0)) )
        {
            // Frag monsters who teleport into an invulnerable monster.
            // (Invulnerable also includes mega enforcer with shields on.)
            // Attacking monsters always lose even if invulnerable.
            // Players should bounce back automatically like the NOCLIP
            // cheat (in later versions of Quake).
            self.classname = "teledeath2";
            if (self.owner.classname != "player")
            {
                // other monsters explode themselves
                if (self.owner.flags & FL_MONSTER)
                {
                    if (self.owner.invincible_finished)
                    {
                        // Remove invulnerability.
                        self.owner.items = self.owner.items - (self.owner.items & IT_INVULNERABILITY);
                        self.owner.invincible_finished = 0;
                        self.owner.invincible_time = 0;
                    }
                    if ((!self.owner.takedamage) && (self.owner.health > 0))
                    {
                        // Negate mega enforcer's shields.
                        self.owner.takedamage = DAMAGE_AIM;
                    }
                }
                T_Damage (self.owner, self, self, 50000);
                return;
            }
        }
    }
//------------------------------------------------------------------------//
//----------------------------------------------------/ New Code /--------//
    else if (other.flags & FL_MONSTER)
    {
        if (other.master.classname == "player")
        {
            // Enemy monsters who try to teleport on top of a player's
            // familiar are destroyed unless they are invulnerable.
            // If defender is invulnerable, the teleporting monster
            // always loses regardless of invulnerability.
            if (self.owner.classname != "player")
            {
                if (other.invincible_finished > time)
                {
                    // Familiar is invulnerable.
                    self.classname = "teledeath2";
                    if (self.owner.flags & FL_MONSTER)
                    {
                        // Make sure all protection is removed.
                        if (self.owner.invincible_finished)
                        {
                            // Remove invulnerability.
                            self.owner.items = self.owner.items - (self.owner.items & IT_INVULNERABILITY);
                            self.owner.invincible_finished = 0;
                            self.owner.invincible_time = 0;
                        }
                        if ((!self.owner.takedamage) && (self.owner.health > 0))
                        {
                            // Negate mega enforcer's shields.
                            self.owner.takedamage = DAMAGE_AIM;
                        }
                    }
                }
                else if (other != other.master.draco)
                {
                    if (self.owner.master.classname == "player")
                        if (self.owner == self.owner.master.draco)
                        {
                            // Exception:  Draco has priority over minors.
                            if (other.health)
                                T_Damage (other, self, self, 50000);
                            return;
                        }
                }

                // If not protected (or if already dead), then die.
                if ((!self.owner.invincible_finished) &&
                    (self.owner.takedamage || (self.owner.health <= 0)))
                {
                    // other monsters explode themselves
                    T_Damage (self.owner, self, self, 50000);
                    return;
                }

                // If the function makes its here, it will go to the bottom,
                // and the familiar will be destroyed.
            }
        }
        else if ( (other.invincible_finished > time) || ((!other.takedamage) && (other.health > 0)) )
        {
            // Frag monsters who teleport into an invulnerable monster.
            // (Invulnerable also includes mega enforcer with shields on.)
            // Attacking monsters always lose even if invulnerable.
            // Players should bounce back automatically like the NOCLIP
            // cheat (in later versions of Quake).
            self.classname = "teledeath2";
            if (self.owner.classname != "player")
            {
                // other monsters explode themselves
                if (self.owner.flags & FL_MONSTER)
                {
                    if (self.owner.invincible_finished)
                    {
                        // Remove invulnerability.
                        self.owner.items = self.owner.items - (self.owner.items & IT_INVULNERABILITY);
                        self.owner.invincible_finished = 0;
                        self.owner.invincible_time = 0;
                    }
                    if ((!self.owner.takedamage) && (self.owner.health > 0))
                    {
                        // Negate mega enforcer's shields.
                        self.owner.takedamage = DAMAGE_AIM;
                    }
                }
                T_Damage (self.owner, self, self, 50000);
                return;
            }
        }
    }
//------------------------------------------------------------------------//

	if (other.health)
	{
		T_Damage (other, self, self, 50000);
	}
};


void(vector org, entity death_owner) spawn_tdeath =
{
local entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;
	
	force_retouch = 2;		// make sure even still objects get hit
};

void() teleport_touch =
{
local entity	t;
local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets ();

// put a tfog where the player was
	spawn_tfog (other.origin);

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
		
// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org);
	spawn_tdeath(t.origin, other);

// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
//----------------------------------------------------/ New Code /--------//
        other.lastwarp = self;  // Pets need this to follow master.
//------------------------------------------------------------------------//
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
//----------------------------------------------------/ New Code /--------//
    else if (other.master.classname == "player")
	{
        // If user is a dragon familiar, check its path after teleport.
        PM_PetUseTeleport (other);      // Function in 'petnode.qc'.
	}
//------------------------------------------------------------------------//
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
void() info_teleport_destination =
{
// this does nothing, just serves as a target spot
	if (notHere())
	{
		remove(self);
		return;
	}
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
		objerror ("no targetname");
};

void() teleport_use =
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/
void() trigger_teleport =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	local vector o;

	InitTrigger ();
	self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o, "ambience/hum1.wav",0.5 , ATTN_STATIC);
	}
};

/*
==============================================================================

trigger_setskill

==============================================================================
*/

void() trigger_skill_touch =
{
	if (other.classname != "player")
		return;
		
	cvar_set ("skill", self.message);
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void() trigger_setskill =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	InitTrigger ();
	self.touch = trigger_skill_touch;
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void() trigger_onlyregistered_touch =
{
	if (other.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint (other, self.message);
			sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void() trigger_onlyregistered =
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		T_Damage (other, self, self, self.dmg);
		self.think = hurt_on;
		self.nextthink = time + 1;
	}

	return;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void() trigger_hurt =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
};

//============================================================================

float PUSH_ONCE = 1;

void() trigger_push_touch =
{
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void() trigger_push =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void() trigger_monsterjump_touch =
{
	if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
		return;

// SoE: The Bane doesn't jump unless he has an enemy
	if ( other.classname == "monster_bane" && other.enemy == world )
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	
	if ( !(other.flags & FL_ONGROUND) )
		return;
	
	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
*/
void() trigger_monsterjump =
{
	if (notHere())
	{
		remove(self);
		return;
	}
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

/*-----------
	SOE: Reading Materiel triggers and associated entities

	have a trigger_read targeting the first page entity, an info_page.
	switch from one info_page to the next targetted IF:
	player is still in trigger brush AND an impulse has been sent by the player
	(AND player angle is facing brush?)
	Close book with EITHER an impulse OR removing oneself from trigger brush
	May have to have all info_pages with same targetname, but different script numbers
	How to identify when a touch is over?

trigger_read touch function asks if the last "impulse" was, oh, 100 or something.
If so, then cnt of trigger = current info_page's cnt and look for
 an info_page with matching targetname and cnt value.
If none or cnt = 0, return to start (cnt = 1)
*/
void() read_use;

void() read_touch ={
local entity page;

	if (self.state == 0)
		return; //locked

	if (other.classname != "player")
		return;
	
	makevectors (other.angles);
	if (v_forward * self.movedir < 0)
	{
		dprint("trigger_read: not facing the right way.\n");
		return;		// not facing the right way
	}

	if (time - self.script_time < 1)
	// could be the same guy
	{
		if (other != self.enemy)
			self.script = self.netname; // different guy
	}
	else
		self.script = self.netname; // been >= 1s since last touch, reset

	// Now, the toucher may be firing an impulse. Let's see.
	if (other.impulse == 100)
	{
		dprint("trigger_read: impulse 100 detected\n");
		self.script = self.next_page;
		if (self.script == "0") // end of book
			self.script = self.netname;
	}

	// do reading stuff:
	self.script_time = time;
	self.enemy = other;

	dprint ("trigger_read: seeking next page\n");

	// find info_page with same script value
	page = find(world, page_num, self.script);
	if (!page)
		objerror("trigger_read: no info_page found");

	// read its message and cnt value
	self.next_page = page.next_page;

	// centerprint the message
	centerprint(other, page.message);

	// If the info_page has targets, fire them once.
	if (page.target)
	{
		page.think = SUB_UseTargets;
		page.target = string_null;
	}

//	self.state = 0;
//	self.think = read_use;
//	self.nextthink = time + 0.1;
};

void() read_use ={
// this just toggles between "locked" and "unlocked" states
	if (self.state == 0)
	{
		self.state = 1;
		return;
	}
		self.state = 0;
};

/*QUAKED trigger_read (.8 .4 .8) ?
brush trigger for providing pageable reading material. Uses impulse 100 to turn pages. Once the
last page is reached, the trigger will ignore the player until he leaves the field for 1 sec.
Then reading returns to the start.

If the player departs in the middle of a book, returning will resume reading at that point.

page_num	first "page" to start from, default is 1
angles		angle player must face in order to read the material. Set to 0,0,360 default (due East)
message		message player reads if trigger_read is "locked"
targetname	allows the mapper to alternately "lock" or "unlock" the material as
			desired. For example, a set of trigger_reads in front of a display screen
			could have a sequence of mission orders that are "unlocked" as the game
			progresses.
			Repeated triggerings alternate "lock" and "unlock" states.
			Use Spawn Flag 1 to make a trigger_read work for the player until triggered.
target		optional.
*/
void() trigger_read =
{
	if (notHere() != 0)
	{
		remove(self);
		return;
	}
	if (!self.page_num)
		self.page_num = "1";
	self.netname = self.page_num;
	self.script = self.page_num;
	self.page_num = string_null;
/* What was that last one all about? Well, we'll search for pages *by* page_num, so in order to
	avoid finding the damn trigger, we need to ditch its page_num value.
*/
	self.state = 1;
	if (self.targetname)
	{
		if (self.spawnflags & 1)
			self.state = 1;
		else
			self.state = 0;
		self.use = read_use;
	}
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';

	InitTrigger ();

	setorigin (self, self.origin);	// make sure it links into the world

	self.touch = read_touch;
	self.script_time = 0;
	self.enemy = world;
};

/*QUAKED info_page (.8 .4 .8) (-8 -8 -8) (8 8 8)
contains page information for use by a trigger_read.
page_num		mandatory, current page number
message		text to display
next_page	next page in the series. 0 is end marker/default value
target		any fun things to happen at a point in reading
*/
void() info_page ={
	if (notHere() != 0)
	{
		remove(self);
		return;
	}
	if (!self.page_num)
		objerror("info_page with no script_num value\n");
	if (!self.message)
		objerror("info_page with no message text\n");
	if (!self.next_page)
		self.next_page = "0";
};