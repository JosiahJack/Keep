//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Qmaster
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 22
// Function count: 27
//
// Implements: Triggers (continued)	
//
// Description:
// Various invisible rectangular volumes that perform actions on things or when
// things enter them.
//=============================================================================

float COUNTER_TOGGLE    = 1.000;
float COUNTER_LOOP    = 2.000;
float COUNTER_STEP    = 4.000;
float COUNTER_RESET    = 8.000;
float COUNTER_RANDOM    = 16.000;
float COUNTER_FINISHCOUNT    = 32.000;
float COUNTER_START_ON    = 64.000;
float CMD_ACTIVATOR_ONLY = 2;
float CMD_UPDATE_ENV_VARIABLES = 4;
float CMD_DO_NOT_TERMINATE = 8;

void () counter_on_use;
void () counter_off_use;
void () oncount_use;
void() func_wall_use;

void () trigger_remove = { self.classname = "trigger_void"; trigger_void(); }; // [ENTITY], redirect to AD's improved version.

void () trigger_setgravity = { // [ENTITY], redirect to AD's improved version.
	self.classname = "trigger_gravity";
	self.spawnflags = self.spawnflags | TRIG_GRAVITYPLAYONLY;
	trigger_gravity();
};

void () command_use_server = { // [FUNCTION]
	local entity pent;
	
	if (self.spawnflags & CMD_ACTIVATOR_ONLY) {
		pent = other;
		if (pent != world && pent.flags & FL_CLIENT) {
			Safe_stuffcmd(pent,self.message);
			if (!(self.spawnflags & CMD_DO_NOT_TERMINATE)) {
				Safe_stuffcmd(pent,"\n");
			}
		} else {
			if (activator != world && activator.flags & FL_CLIENT) {
				Safe_stuffcmd(activator,self.message);
				if (!(self.spawnflags & CMD_DO_NOT_TERMINATE)) Safe_stuffcmd(activator,"\n");
			}
		}
	} else {
		pent = find(world,classname,"player"); // Stuff commands to all players on the server
		while (pent) {
			if (pent != world && pent.flags & FL_CLIENT) {
				Safe_stuffcmd(pent,self.message);
				if (!(self.spawnflags & CMD_DO_NOT_TERMINATE)) {
					Safe_stuffcmd(pent,"\n");
				}
			}
			pent = find(world, classname, "player");
		}
	}
};

void () command_use = { // [FUNCTION]
	localcmd (self.message);
	if (!(self.spawnflags & CMD_DO_NOT_TERMINATE)) localcmd("\n");
	if (self.classname == "info_command_spawn") entity_hide(self);
};

void () info_command_use_server = { command_use_server(); }; // [FUNCTION]

void () info_command_use = { command_use(); }; // [FUNCTION]

void () info_command = { // [ENTITY]
	if (self.message == "") {
		dprint("\b[INFO_CMD]\b Message cmd missing!\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}
	self.classtype = CT_CONTROL;
	self.use = info_command_use;
	self.think = SUB_Null;
};
void () info_command_server = { // [ENTITY]
	if (self.message == "") { remove(self); return; }
	self.use = info_command_use_server;
	self.think = SUB_Null;
};

void () info_command_spawn = { // [ENTITY]
	if (self.message == "") { remove(self); return; }
	self.use = info_command_use;
	self.think = SUB_Null;
};

void () trigger_command_touch = { if (other.flags & FL_CLIENT) command_use(); }; // [FUNCTION]

void () trigger_command = { // [ENTITY]
	if (self.message == "") { remove(self); return; }
	InitTrigger ();
	self.touch = trigger_command_touch;
};

void () trigger_waterfall_touch = { // [FUNCTION]
   if (!(other.flags & FL_CLIENT)) return ;
   other.velocity = (other.velocity + self.movedir);
   other.velocity_x = (other.velocity_x + (self.count * (random () - 0.500)));
   other.velocity_y = (other.velocity_y + (self.count * (random () - 0.500)));
};

void () trigger_waterfall = { // [ENTITY]
   InitTrigger ();
   self.touch = trigger_waterfall_touch;
   if (!self.count) self.count = 100.000;
   if (CheckZeroVector(self.movedir)) self.movedir = '0 -90 0';
   if (!self.speed) self.movedir = (self.movedir * 50.000);
   else self.movedir = (self.movedir * self.speed);
};

void () counter_think = { // [FUNCTION]
   self.cnt = (self.cnt + TRUE);
   if ( (self.spawnflags & COUNTER_RANDOM) ) {
      self.state = (random () * self.count);
      self.state = (floor (self.state) + TRUE);
   } else self.state = self.cnt;
   activator = other;
   SUB_UseTargets ();
   self.nextthink = (time + self.wait);
   if ( (self.spawnflags & COUNTER_STEP) ) counter_on_use ();
   if ( (self.cnt >= self.count) ) {
		self.cnt = 0;
		if ( (self.aflag || !(self.spawnflags & COUNTER_LOOP)) && self.spawnflags & COUNTER_TOGGLE ) counter_on_use ();
		else remove (self);
   }
};

void () counter_on_use = { // [FUNCTION]
   if (self.cnt != 0 && (self.spawnflags & COUNTER_FINISHCOUNT)) { self.aflag = TRUE; return; }
   self.use = counter_off_use;
   self.think = SUB_Null;
   self.aflag = FALSE;
};

void () counter_off_use = { // [FUNCTION]
   self.aflag = FALSE;
   if (self.spawnflags & COUNTER_TOGGLE) self.use = counter_on_use;
   else self.use = SUB_Null;

   if (self.spawnflags & COUNTER_RESET) {
      self.cnt = FALSE;
      self.state = FALSE;
   }

   self.think = counter_think;
   if (self.delay) self.nextthink = (time + self.delay);
   else counter_think ();
};
float (entity counter) counter_GetCount = { // [FUNCTION]
   if (counter.classname == "counter") return counter.state;
   return 0;
};

void () func_counter = { // [ENTITY]
   if ( !self.wait ) self.wait = TRUE;
   self.count = floor (self.count);
   if ( (self.count <= FALSE) ) self.count = MOVETYPE_BOUNCE;
   self.cnt = FALSE;
   self.state = FALSE;
   self.classname = "counter";
   self.use = counter_off_use;
   self.think = SUB_Null;
   if ( (self.spawnflags & COUNTER_START_ON) ) {
      self.think = counter_off_use;
      self.nextthink = (time + 0.100);
   }
};

void () oncount_use = { // [FUNCTION]
   if ( (counter_GetCount (other) == self.count) ) {
      activator = other;
      SUB_UseTargets ();
   }
};

void () func_oncount = { // [ENTITY]
   self.count = floor (self.count);
   if ( (self.count <= FALSE) ) self.count = TRUE;
   self.classname = "oncount";
   self.use = oncount_use;
   self.think = SUB_Null;
};

void() change_cvar = { // [FUNCTION]
	local entity check;

	cvar_set (self.netname, self.message);
	bprint("\n\n");
	self.classname = "cvar_done";
	check = find(world, classname, "player");
	if(!check) check = find(world, classname, "camera");
	check.ideal_yaw = -1;
	self.nextthink = time + 0.02;
	self.think = SUB_UseTargets;
};

void() cvarset_touch = { // [FUNCTION]
	if (other.health <= 0 || other.classname != "player") return;
	change_cvar();
};

void() trigger_cvarset = { // [ENTITY]
	if (deathmatch || coop) remove (self);
	InitTrigger ();
	self.use = change_cvar;
	self.touch = cvarset_touch;
};

// Update 8/19/09:  Jump/Dive Triggers
// Hipnotic's cnt stuff - - - - - - - -
// Code common to various triggers with Hip countdown on touch.
void() HipCntDown = { // [FUNCTION]
    if (self.cnt > 0) {
        self.cnt = self.cnt - 1;
        if (self.cnt == 0) {
            self.solid      = SOLID_NOT;    // PM:  Another safeguard.
            self.touch      = SUB_Null;
            self.nextthink  = time + 0.1;
            self.think      = SUB_Remove;
        }
    }
};

// Override velocity if a player jumps within one.
void() tjump_touch = { // [FUNCTION]
	local vector vec;

    if (other.health <= 0) return;
    if (!(other.flags & FLx_CREATURE)) return; // Only players and monsters can use jump pads.

    if (self.spawnflags & PUSH_JUMP_ONLY) {
        if (!other.jump_time || (other.jump_time + 0.2 < time)) return; // Didn't jump recently.
        other.jump_time = 0; // Time to fly!
    } else { // Automatic use.
        if (other.flags & FL_CLIENT) other.jump_flag = 0; // Players don't take damage if fell on trigger.
        if (!(other.flags & FL_ONGROUND)) return;
    }

	// Up, up, and away!
    if (!(self.spawnflags & PUSH_CURRENT)) { // First sound overrides jump sound.  Second sound is standard push sound.
        sound (other, CHAN_BODY, "rogue/runes/end1.wav", 1, ATTN_NORM);
        sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
    }

    if (self.speed) { // Unlike trigger_monsterjump, jump at a direction 'other' is facing.
        vec = '0 0 0';
        vec_y = other.angles_y;
        makevectors (vec);
        other.velocity = v_forward * self.speed;
    }
    other.velocity_z = self.height;
    other.flags = other.flags - (other.flags & FL_ONGROUND);
    HipCntDown (); // Hipnotic's cnt stuff 
};

// --> QUAKED trigger_jump (.5 .5 .5) ? PUSH_ONCE PUSH_CURRENT PUSH_JUMP_ONLY
// Pushes the player up
void() trigger_jump_spawn = { // [FUNCTION]
    precache_sound ("ambience/windfly.wav");
    precache_sound ("rogue/runes/end1.wav");       // Bounce sound.

    // 'InitTrigger' already done elsewhere.
    self.touch = tjump_touch;
    if (!self.height) self.height = 1000;     // PM:  Use 900 in roman3 and unforgiven2.
    if (!self.cnt) self.cnt = -1; // Hipnotic's cnt stuff
};

void() trigger_jump = {InitTrigger(); trigger_jump_spawn();}; // [ENTITY]

void() trigger_jump_point = {InitPointTrigger(); trigger_jump_spawn();}; // [ENTITY]

void() trigger_superjump = {InitTrigger(); self.spawnflags = self.spawnflags | PUSH_JUMP_ONLY; trigger_jump_spawn();}; // [ENTITY]

void() trigger_superjump_point = {InitPointTrigger(); self.spawnflags = self.spawnflags | PUSH_JUMP_ONLY; trigger_jump_spawn();}; // [ENTITY]

void () play_tfog = { spawn_tfog(self.origin); } // [FUNCTION], thanks Khreathor -- dumptruck_ds.  Exists since it is used as a think. -Qmaster

//johnfitz
// QUAKED tele_fog (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
// When triggered, tele_fog shows the teleport particle effects and sounds.
// Use this when killtageting an entity if the player can see.
void() tele_fog = { self.use = play_tfog; }; // [ENTITY]

void () play_meatspray = { // [FUNCTION]
	if (self.style == 1) {
		ThrowGib(1,2);
		ThrowGib(2,2);
		ThrowGib(3,2);
	} else {
		ThrowGib(1, 1);
		ThrowGib(2, 1);
		ThrowGib(3, 1);
	}

	if (self.fly_sound != 1) return;

	if (random() < 0.5) sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM);
	else sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
};

void() meat_shower = { self.use = play_meatspray; }; // [ENTITY]

// Touch trigger that prevents things from falling too fast.
void() trigger_dive_touch = { // [FUNCTION]
    if (!(other.flags & FL_ONGROUND))
    if ((other.health > 0) || (AffectedByPhysics(other)))
    if (other.velocity_z < self.speed) {
        other.velocity_z = self.speed;
        if (other.classname == "player") {
            if (other.fly_sound < time) {
                other.fly_sound = time + 1.5;
                if (!(self.spawnflags & PUSH_CURRENT)) sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
            }
        }
    }
};

// This function is Zerstorer stuff.
void() push_use2 = { // [FUNCTION]
    if (self.solid == SOLID_NOT) self.solid = SOLID_TRIGGER;
    else self.solid = SOLID_NOT;
};

// QUAKED trigger_dive (.5 .5 .5) ? x PUSH_CURRENT
// Slows downward velocity to prevent falling damage. Zerstorer stuff.
void() trigger_dive_spawn = { // [FUNCTION]
    precache_sound("ambience/windfly.wav");
    self.touch = trigger_dive_touch;
    if (!self.speed) self.speed = -500;
    if (self.targetname) {self.solid = SOLID_NOT; self.use = push_use2;}
};

void() trigger_dive = {InitTrigger();  trigger_dive_spawn();}; // [ENTITY]

void() trigger_dive_point = {InitPointTrigger();  trigger_dive_spawn();}; // [ENTITY]

void() keytrigger_use = { // [FUNCTION]
   if (!(activator.flags & FL_CLIENT)) return;
   if ( (activator.health <= FALSE) ) return;
   if (self.attack_finished > time) return;

   self.attack_finished = (time + FL_SWIM);
   if ((self.items & activator.items) != self.items) {
      centerprint(activator, "You need a special type of key\n to fit this lock.");
      sound(self,CHAN_VOICE,self.noise3,TRUE,ATTN_NORM);
      return;
   }

   self.touch = SUB_Null;
   self.use = SUB_Null;
   self.nextthink = (time + 0.100);
   self.think = SUB_Remove;
   self.message = "";
   SUB_UseTargets ();
};

void () keytrigger_touch = { // [FUNCTION]
   activator = other;
   keytrigger_use();
};

void () trigger_usekey_skeleton = { // [ENTITY]
   self.use = keytrigger_use;
   self.touch = keytrigger_touch;
   if (!self.items) self.items = IT2_KEY_SKELETON;
   precache_sound ("doors/runetry.wav");
   self.noise3 = "doors/runetry.wav";
   InitTrigger ();
};

void () requisit_use = { // [FUNCTION]
   if (!(activator.flags & FL_CLIENT)) return;
   if (activator.health <= 0) return;
   if ((self.items & activator.items) != self.items) return;
   if (self.attack_finished > time) return;

   self.attack_finished = (time + FL_SWIM);
   self.touch = SUB_Null;
   self.use = SUB_Null;
   self.nextthink = (time + 0.100);
   self.think = SUB_Remove;
   SUB_UseTargets ();
};

void() requisit_touch = { // [FUNCTION]
	activator = other;
	keytrigger_use ();
};

void() trigger_prerequisit = { // [ENTITY]
	self.use = requisit_use;
	self.touch = requisit_touch;
	if (!self.items) self.items = IT_KEY1;
	InitTrigger ();
};

// Thought this could be fun.  Good for ice or slick muddy surfaces. -Qmaster
void() func_slidebox = { // [ENTITY]
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_SLIDEBOX;
	self.use = func_wall_use;
	setmodel (self,self.model);
};

void() conv_touch = { // [FUNCTION]
	local vector vel;

	if (!other) return ;
	if (!(other.flags & FLx_CREATURE) && !AffectedByPhysics(other)) return;

	vel = (self.speed * self.movedir);
	if ((other.velocity_x + vel_x) < other.velocity_x) other.velocity_x = other.velocity_x - vel_x;
	else other.velocity_x = other.velocity_x + vel_x;

	if ( (other.velocity_y + vel_y) < other.velocity_y) other.velocity_y = other.velocity_y - vel_y;
	else other.velocity_y = other.velocity_y + vel_y;

	if ( (other.velocity_z + vel_z) < other.velocity_z) other.velocity_z = other.velocity_z - vel_z;
	else other.velocity_z = other.velocity_z + vel_z;
};

void () conv_use = { // [FUNCTION]
   if (self.cnt) {
      self.cnt = FALSE; // enabled
      self.touch = conv_touch;
   } else {
      self.cnt = TRUE; // disabled
      self.touch = SUB_Null;
   }
};

void () trigger_conveyor = { // [ENTITY]
	self.use = conv_use;
	if (!self.speed) self.speed = 10;
	if (self.targetname) {
		if (self.spawnflags & 1) {
			self.touch = SUB_Null;
			self.cnt = TRUE; // disabled
		} else {
			self.touch = conv_touch;
			self.cnt = FALSE; // enabled
		}
	} else {
		self.touch = conv_touch;
		self.cnt = FALSE; // enabled
	}
	InitTrigger ();
};