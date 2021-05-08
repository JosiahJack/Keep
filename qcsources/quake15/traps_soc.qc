float TRAP_GASSTEAM = 1;		// Gas particle types (default)
float TRAP_GASFIRE = 2;
float TRAP_GASPOISON = 4;
float TRAP_GASSILENT = 16;		// No particle sound effects

float TRAP_TOGGLE = 32;			// Toggle function with triggered
float TRAP_TRACKING = 128;		// Keep updating the target position

float TRAP_LIGHTLARGE = 1;		// Cthton Lightning effect
float TRAP_LIGHTDUST = 8;		// Dust/Smoke effects at impact
float TRAP_LIGHTPART = 16;		// Particle effects at impact

//======================================================================
/*QUAKED trap_gasshooter (0 .5 .8) (-8 -8 -8) (8 8 8) STEAM FIRE POISON x SILENT TOGGLE x TRACK
When triggered, fires a gas particle in the direction determined by angle
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
target : targetting entity used for custom direction
angle  : direction for stream to follow, use "360" for angle 0
wait   : time between particles (def=0.05s)
speed  : velocity speed (def=200)
waitmin: auto switch off timer (def=0.5s)
dmg    : damage from contact with particles (def=1)
-------- SPAWNFLAGS --------
STEAM  : White hot clouds of steam (default)
FIRE   : Will add burning debuff to player
POISON : Will add poison debuff to player
SILENT : No on/off sound, its silent!
TOGGLE : Trigger will toggle the shooter on/off instead
TRACK  : Will update target entity origin before firing
-------- NOTES --------
When triggered, fires a gas particle in the direction determined by angle

======================================================================*/
void() trap_tracking =
{
	if (self.target == "") return;
	if (!self.movetarget)
		self.movetarget = find(world, targetname, self.target);
	
	if (self.movetarget) {
		// Check for a Bmodel object (special origin)
		if (self.movetarget.bsporigin) self.dest1 = bmodel_origin(self.movetarget);
		else self.dest1 = self.movetarget.origin;
		// Calculate facing angle towards target
		self.movedir = normalize(self.dest1 - self.origin);
	}
};

void() trap_gasshooter_touch =
{
	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return;
	if (other.health < 1) return;
	if (other.takedamage == DAMAGE_NO) return;
	if (self.attack_finished > time) return;
	if (other.classtype == self.owner.classtype) return;

	self.attack_finished = time + 1;
	
	// Check contact is a player?
	if (other.flags & FL_CLIENT) {
		// Check for debuff particle type first
		if (self.owner.spawnflags & TRAP_GASFIRE)
			ApplyFireDmg(other, self.owner.dmg, self.owner.dmg);
		else if (self.owner.spawnflags & TRAP_GASPOISON)
			ApplyFireDmg(other, self.owner.dmg, self.owner.dmg);
			//PoisonDeBuff(other);
		else T_Damage (other, self, self, self.owner.dmg, NOARMOR);
	}
	// Monsters have special damage to kill them quicker
	else if (other.flags & FL_MONSTER) T_Damage (other, self, self, DAMAGE_MONFLAME, NOARMOR);
	else T_Damage (other, self, self, self.owner.dmg, NOARMOR);
	self.velocity = '0 0 0';
};

//----------------------------------------------------------------------
void() trap_gasshooter_think =
{
	self.cnt = self.cnt + 1;
	if (self.cnt > 6) remove(self);
	else {
		self.frame = self.cnt;
		self.nextthink = time + 0.1 + random() * 0.05;
	}
};

//----------------------------------------------------------------------
void() trap_gasshooter_spawn =
{
	local entity partemit;
	
	// Check if disabled/off first
	if (self.estate & ESTATE_BLOCK) self.state = STATE_OFF;
	if (self.state == STATE_OFF) return;

	// Check for any target entity tracking changes
	if (self.spawnflags & TRAP_TRACKING) trap_tracking();
	
	partemit = spawn();
	partemit.classtype = CT_TEMPSTREAM;
	partemit.owner = self;
	partemit.frame = partemit.cnt = 0;

	partemit.movetype = MOVETYPE_FLY;	// Fly, no gravity, but contact
	partemit.solid = SOLID_TRIGGER;		// collision, touch required
	setmodel (partemit, self.mdl);
	setorigin (partemit, self.origin);
	setsize (partemit, VEC_ORIGIN, VEC_ORIGIN);

	partemit.oldorigin = vecrand(0,20,TRUE);
	partemit.velocity = (self.movedir * self.speed) + partemit.oldorigin;
	partemit.angles_z = random() * 360;

	// If DP engine active remove particle shadow
	if (engine == ENG_DPEXT) partemit.effects = partemit.effects + EF_NOSHADOW;

	partemit.nextthink = time + 0.1 + random() * 0.05;
	partemit.think = trap_gasshooter_think;
	partemit.touch = trap_gasshooter_touch;

	// Continuous mode or auto switch off mode still on?
	if (self.spawnflags & TRAP_TOGGLE || self.waitmin2 > time) {
		self.think = trap_gasshooter_spawn;
		self.nextthink = time + self.wait;
	}
	// Time to switch off
	else {
		self.state = STATE_OFF;
		sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	}
};

//----------------------------------------------------------------------
void() trap_gasshooter_off =
{ 
	self.estate = ESTATE_OFF;
	// If gas shooter currently on, play switch off sound
	if (self.state == STATE_ON) 
		sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	else sound (self, CHAN_VOICE, SOUND_EMPTY, 1, ATTN_NORM);
	self.state = STATE_OFF;
};

//----------------------------------------------------------------------
void() trap_gasshooter_reset =
{ 
	self.estate = ESTATE_ON;
	// clear any sounds playing
	sound (self, CHAN_VOICE, SOUND_EMPTY, 1, ATTN_NORM);
	self.state = STATE_OFF;
};

//----------------------------------------------------------------------
void() trap_gasshooter_on =
{ 
	self.estate = ESTATE_ON;
	self.state = STATE_ON;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.waitmin2 = time + self.waitmin;
	trap_gasshooter_spawn();
};

//----------------------------------------------------------------------
void() trap_gasshooter_use =
{
	// Check if disabled/off first
	if (self.estate & ESTATE_BLOCK) return;
	
	// Toggle shooter on/off
	if (self.state == STATE_ON) {
		self.state = STATE_OFF;
		sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
	}
	else trap_gasshooter_on();
};

//----------------------------------------------------------------------
void() trap_gasshooter =
{
	if (self.spawnflags & TRAP_GASFIRE) {
		self.mdl = "progs/s_flame.spr";
		self.noise1 = "traps/flame_loop.wav";
		self.noise2 = "traps/flame_off.wav";
	}
	else if (self.spawnflags & TRAP_GASPOISON) {
		self.mdl = "progs/s_poison.spr";
		self.noise1 = "traps/steam_loop.wav";
		self.noise2 = "traps/steam_off.wav";
		self.alpha = 1;
	}
	else {
		// Steam particles is the default
		self.spawnflags = self.spawnflags | TRAP_GASSTEAM;
		self.mdl = "progs/s_steam.spr";
		self.noise1 = "traps/steam_loop.wav";
		self.noise2 = "traps/steam_off.wav";
	}

	if (self.spawnflags & TRAP_GASSILENT) {
		self.noise1 = SOUND_EMPTY;
		self.noise2 = SOUND_EMPTY;
	}
	precache_model (self.mdl);
	precache_sound (self.noise1);
	precache_sound (self.noise2);
	
	self.classtype = CT_GASSHOOTER;
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement

	if (!self.dmg) self.dmg = 1;
	if (self.speed < 1) self.speed = 200;
	if (self.wait <0.05) self.wait = 0.05;
	if (self.waitmin <=0) self.waitmin = 0.5;
	
	// Does not auto switch off anymore
	if (self.spawnflags & TRAP_TOGGLE) self.waitmin = LARGE_TIMER;
	
	// setup any angle direction
	if (self.angles_y == 0) self.angles_y = 360;
	self.mangle = self.angles;
	SetMovedir();
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_use = trap_gasshooter_use;
	self.estate_reset = trap_gasshooter_reset;
	self.estate_off = trap_gasshooter_off;
	self.estate_on = trap_gasshooter_on;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;

	// If target is setup, calculate new facing angle
	if (self.target != "") {
		self.nextthink = time + 1 + random();
		self.think = trap_tracking;
	}
};

void() trap_shooter_fire =
{
	local vector lightn_start, lightn_finish;
	
	// Check if disabled/off first
	if (self.estate & ESTATE_BLOCK) self.state = STATE_OFF;
	if (self.state == STATE_OFF) return;

	// Check for any target entity tracking changes
	if (self.spawnflags & TRAP_TRACKING) trap_tracking();

	// Fire projectile sound
	if (self.classname == "trap_lightningshooter") {
		// Time for a new LG hit sound?
		if (self.t_width < time) {
			// Lower volume and attenuation just in case of several together
			sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM);
			self.t_width = time + 0.6;
		}
	}
	else if (self.noise != "") 
		sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM);

	// Determine type of projectile shooter
	if (self.classname == "trap_lightningshooter") {
		// Double check a destination origin exists
		if (CheckZeroVector(self.dest1)) return;
		
		self.effects = self.effects | EF_MUZZLEFLASH;
		
		// setup any random X/Y/Z start/end point wobble
		lightn_start = lightn_finish = '0 0 0';
		if (CheckZeroVector(self.pos1) == FALSE) {
			lightn_start_x = self.pos1_x * crandom();
			lightn_start_y = self.pos1_y * crandom();
			lightn_start_z = self.pos1_z * crandom();
		}
		lightn_start = lightn_start + self.origin;
		if (CheckZeroVector(self.pos2) == FALSE) {
			lightn_finish_x = self.pos2_x * crandom();
			lightn_finish_y = self.pos2_y * crandom();
			lightn_finish_z = self.pos2_z * crandom();
		}
		lightn_finish = lightn_finish + self.dest1;

		// trace a line from trap in direction or an exact end point 
		traceline(lightn_start, lightn_finish, TRUE, self);

		// Check for particle effects at impact
		// Designed to spray dust back towards source origin
		if (self.spawnflags & TRAP_LIGHTDUST && random() < 0.7) {
			// Classic temporary entity
			newmis = spawn();
			newmis.classgroup = CG_TEMPENT;
			newmis.movetype = MOVETYPE_TOSS;
			newmis.solid = SOLID_NOT;
			setmodel(newmis, "progs/proj_smoke.mdl");
			setorigin(newmis, trace_endpos);
			setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
			
			// Work out vector between source and target
			self.pos3 = normalize(lightn_finish - lightn_start);
			// Convert vector to angle so v_forward/v_right correct
			self.pos3 = vectoangles(self.pos3);
			makevectors(self.pos3);
			
			// Randomize the X/Y and push the vector back to source
			newmis.velocity = (crandom()*v_right)*150 + v_forward*(150+random()*300);

			// Temporary ents, quickly remove afterward
			newmis.nextthink = time + 1 + random()*3;
			newmis.think = SUB_Remove;
		}
		if (self.spawnflags & TRAP_LIGHTPART)
			particle_explode(trace_endpos, 5+random()*5, 1, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
		
		// Generate the lightning effect
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, self.lip);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, lightn_start_x);
		WriteCoord (MSG_BROADCAST, lightn_start_y);
		WriteCoord (MSG_BROADCAST, lightn_start_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
		// Check for things to damage in between the two points
		LightningDamage (lightn_start, trace_endpos, self, self.dmg);		
	}

	// Check for temporary continuous mode
	if (self.waitmin > 0 && time < self.pausetime) {
		self.think = trap_shooter_fire;
		self.nextthink = time + self.waitmin2;
	}
	else {
		// Continuous mode?
		if (self.spawnflags & TRAP_TOGGLE) {
			self.think = trap_shooter_fire;
			self.nextthink = time + self.wait + random()*self.delay;
		}
		// Fire once and switch off
		else self.state = STATE_OFF;
	}
};


void() trap_shooter_use =
{
	// Check if disabled/off first
	if (self.estate & ESTATE_BLOCK) return;
	
	// Check for firing conditions (nightmare, coop)
	//if (skill == 3) return;
	//if (coop) return;

	// Toggle shooter on/off
	if (self.state == STATE_OFF) {
		self.state = STATE_ON;
		if (self.waitmin > 0) self.pausetime = time + self.waitmin;
		if (!self.waitmin2) self.waitmin2 = 0.1;
	}
	else self.state = STATE_OFF;
	
	trap_shooter_fire();
};


//----------------------------------------------------------------------
void() trap_shooter_reset =
{
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;
};


/*======================================================================
/*QUAKED trap_lightningshooter (0 0.5 0.8) (-8 -8 -8) (8 8 8) LARGE x x DUST PART TOGGLE x TRACK
When triggered, fires a LIGHTNING at the target entity (can be blocked)
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
target   : targeting entity used for destination (required)
wait     : time between projectiles (def=1s)
delay    : random time between projectile (def=0s)
volume   : Lightning hit sound volume (def=0.75)
dmg      : Damage from lightning strike (def=15, large=30)
pos1     : Random XYZ wobble to source position
pos2     : Random XYZ wobble to target position
-------- SPAWNFLAGS --------
LARGE   : Cthton Boss Lightning
DUST    : Produce dust/smoke at point of impact
PARTICLE: Produce particles at point of impact
TOGGLE  : Trigger will toggle the shooter on/off instead
TRACK   : Will update target entity origin before firing
-------- NOTES --------
When triggered, fires a LIGHTNING at the target entity (can be blocked)
Use TOGGLE spawnflag and trigger to enable continuous mode

======================================================================*/
void() trap_lightningshooter = 
{
	self.noise = "weapons/lhit.wav";
	precache_sound (self.noise);

	//self.classtype = CT_LIGHTSHOOTER;
	if (self.wait <= 0) self.wait = 1;
	if (self.delay < 0) self.delay = 0;
	if (!self.volume) self.volume = 0.75;
	self.t_width = 0;		// Light sound timer

	// Sort out lightning damage
	if (self.dmg < 1) {
		self.dmg = 15;
		// Double for large lightning
		if (self.spawnflags & TRAP_LIGHTLARGE) self.dmg = 30;
	}
	
	// Work out which lightning bolt to use
	if (self.spawnflags & TRAP_LIGHTLARGE) self.lip = TE_LIGHTNING3;
	else self.lip = TE_LIGHTNING2;

	// Must have target for destination of lightning
	if (self.target == "") {
		dprint("\b[TRAP]\b Lightning trap missing target!\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_use = trap_shooter_use;
	self.estate_reset = trap_shooter_reset;
	self.estate = ESTATE_ON;
	self.state = STATE_OFF;

	// Find target once everything has spawned
	self.nextthink = time + 1 + random();
	self.think = trap_tracking;
};

//HIPNOTIC

entity tesla_target;
float tesla_numtargets;
void() trap_tesla_scan =
   {
   local entity head;
   local entity prev;

// look in our immediate vicinity

   tesla_numtargets = 0;
   head = findradius(self.origin, self.distance);
   while(head)
      {
      if(!(head.flags & FL_NOTARGET) && (head.flags & self.cnt))
         {
         if (visible(head) && (head.health > 0))
            {
            if (tesla_numtargets == 0)
               {
               tesla_target = head;
               }
            else
               {
               prev.next_ent = head;
               }
            tesla_numtargets = tesla_numtargets + 1;
            prev = head;
            if (tesla_numtargets==self.count)
               return;
            }
         }
      head = head.chain;
      }
   };

void() trap_gravity_touch =
   {
   if ( self.attack_finished > time )
      return;

   if (other.takedamage)
      {
      T_Damage (other, self, self, self.dmg );
      self.attack_finished = time + 0.2;
      }
   };

void() trap_gravity_think =
   {
   local vector vel;
   local vector dir;
   local vector delta;

   self.ltime = time;
   trap_tesla_scan();
   while (tesla_numtargets > 0)
      {
      delta = self.origin - tesla_target.origin;
      dir = normalize( delta );
      vel = dir * self.speed;
      if ( ( tesla_target.wetsuit_finished > time ) &&
         ( self.waterlevel >= 2 ) )
         {
         vel = vel * 0.6;
         }

      tesla_target.velocity = tesla_target.velocity + vel;
      tesla_target = tesla_target.next_ent;
      tesla_numtargets = tesla_numtargets - 1;
      }
   self.nextthink = time + 0.1;
   };

/*QUAKED trap_gravity_well (.8 .5 0) (-8 -8 -8) (8 8 8) targetenemies UNDERWATER
targets enemies in vicinity and draws them near, gibbing them on contact.

UNDERWATER cuts the pull in half for players wearing the wetsuit

"distance" how far the gravity well should reach (600 default)
"count" number of people to target (2 default)
"speed" is how strong the pull is. (210 default)
"dmg" is how much damage to do each touch. (10000 default)
*/
void() trap_gravity_well =
   {
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_NONE;
   setsize( self, '-16 -16 -16','16 16 16');
   if ( self.dmg == 0)
      {
      self.dmg = 10000;
      }
   if ( self.speed == 0 )
      self.speed = 210;
   if (self.distance == 0)
      self.distance = 600;
   if (self.spawnflags & 1)
      self.cnt = FL_CLIENT | FL_MONSTER;
   else
      self.cnt = FL_CLIENT;

   self.attack_finished = 0;
   self.think = trap_gravity_think;
   self.touch = trap_gravity_touch;
   self.lastvictim = world;
   tesla_numtargets = 0;
   self.nextthink = time + 0.1;
   self.ltime = time;
   };
