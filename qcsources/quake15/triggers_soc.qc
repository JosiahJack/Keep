
/*======================================================================
 Player ladder (originally from Rubicon2 codebase by JohnFitz)
 - This is a very simple system, jump to attach to the ladder brush
 - move up down via jumpping (hook in preplayer code)
 - Added multiple climbing sounds (works with player footsound state)
 - Modified to have on/off/toggle state via triggers
 - Downsides to system, there is no abilty to go down a ladder
/*======================================================================
/*QUAKED trigger_ladder (.5 .5 .5) ? x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
Invisible brush based ladder (jump key to climb)
-------- KEYS --------
targetname : trigger entity (works with entity state system)
angle    : direction player must be facing to climb ladder (required)
waitmin  : time between climb sound (def = depends on sound type)
speed    : velocity speed to climb ladder (def=160)
sounds   : 1=metal, 2=wood, 3=rope, 4=silent, 5=custom (def=wood)
noise1-4 : custom sounds to play when climbing ladder
-------- SPAWNFLAGS --------
STARTOFF : Starts off and waits for trigger
-------- NOTES --------
Invisible brush based ladder (jump key to climb)
This entity cannot be damaged and is always touchable once activated

======================================================================*/
void() trigger_ladder_fire =
{
	// This is after bmodel _use, _killed and _touch, so any reference
	// to the trigger activator has to go through 'bmodel_act'
	
	
	//hacky targetname workaround because i'm lazy and haven't fully implemented entity states yet from AD
	if (self.spawnflags & ENT_STARTOFF)
		self.touch = trigger_ladder_fire;

	// Ladders ONLY work with players because of client.qc (PlayerPreThink)
	if (self.estate & ESTATE_BLOCK) return;
	if ( !(other.flags & FL_CLIENT) ) return;
	if ( other.health < 1 ) return;

	// Don't stick underwater, or in the middle of a waterjump
	if (other.waterlevel > 1) return;
	if (other.flags & FL_WATERJUMP) return;

	other.onladder = 1;		// Add everytime the player touches volume
	other.entladder = self;	// Link back to play sounds
	
	if (other.flags & FL_ONGROUND)
		other.flags = other.flags - FL_ONGROUND;	//fix for getting stuck on floor inside trigger
	
	
};

//----------------------------------------------------------------------
void() trigger_ladder =
{
	// Default = wood
	if (!self.sounds) self.sounds = 2;
	if (self.sounds == 1) {				// Metal
		if(!self.waitmin) self.waitmin = 0.45;
		self.noise1 = "player/ladmetal1.wav";
		self.noise2 = "player/ladmetal2.wav";
		self.noise3 = "player/ladmetal3.wav";
		self.noise4 = "player/ladmetal4.wav";
	}
	else if (self.sounds == 2) {		// Wood
		if(!self.waitmin) self.waitmin = 0.4;
		self.noise1 = "player/ladwood1.wav";
		self.noise2 = "player/ladwood2.wav";
		self.noise3 = "player/ladwood3.wav";
		self.noise4 = "player/ladwood4.wav";
	}
	else if (self.sounds == 3) {		// Old Rope
		if(!self.waitmin) self.waitmin = 0.7;
		self.noise1 = "player/ladrope1.wav";
		self.noise2 = "player/ladrope2.wav";
		self.noise3 = "player/ladrope3.wav";
		self.noise4 = "player/ladrope4.wav";
	}
	else {
		// Custom or empty
		if (!self.waitmin) self.waitmin = 0.5;
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
		if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
		if (self.noise3 == "") self.noise3 = SOUND_EMPTY;
		if (self.noise4 == "") self.noise4 = SOUND_EMPTY;
	}
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	precache_sound(self.noise4);
	
	self.classtype = CT_TRIGLADDER;
	InitTrigger ();
	if (!self.speed) self.speed = 160;
	// No trigger damage functionality and always touchable!
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE;

	// Cannot have ladder triggers touched by monsters
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS);

	// Setup Entity State functionality
	//self.estate_fire = trigger_ladder_fire;
	if (self.spawnflags & ENT_STARTOFF) {
		self.touch = SUB_Null;
		self.use = trigger_ladder_fire;
	}
	else
		self.touch = trigger_ladder_fire;
	//trigger_bmodel_setup();
};

/*======================================================================
/*QUAKED trigger_setgravity
trigger a change in gravity
-------- KEYS --------
gravity: gravity to change to
-------- NOTES --------
Invisible gravity changing trigger
use two triggers for entrance/exit (one to set it, one to restore it)
======================================================================*/
void() gravity_touch =
{
	local float grav;
	
	grav = self.gravity;
	
	if (other.classname == "player")
		cvar_set ("sv_gravity", ftos(grav));
};

void() trigger_setgravity =
{
	InitTrigger ();
	
	if (!self.gravity)
		self.gravity = 800;
	self.touch = gravity_touch;	
};

void() removeItems =
{
	if (other.classname == "player")
		other.weapon = IT_AXE;
		
}

void() trigger_weaponstrip =
{
	InitTrigger ();
	self.touch = removeItems;
}

void() removeEnts =
{
	if (other == world)
		return;
	if (other.flags & FL_CLIENT)
		return;
	if (other.flags & FL_MONSTER)
		return;
		
	remove(other);
}

void() trigger_removeEnts =
{
	InitTrigger ();
	self.touch = removeEnts;
}