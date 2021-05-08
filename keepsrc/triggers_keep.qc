float COUNTER_TOGGLE    = 1.000;
float COUNTER_LOOP    = 2.000;
float COUNTER_STEP    = 4.000;
float COUNTER_RESET    = 8.000;
float COUNTER_RANDOM    = 16.000;
float COUNTER_FINISHCOUNT    = 32.000;
float COUNTER_START_ON    = 64.000;

void () counter_on_use;
void () counter_off_use;
void () oncount_use;

void () trigger_remove = { trigger_void(); };

void () trigger_setgravity_touch = {
	if (other.flags & FL_CLIENT) {
		other.gravity = self.gravity;
		other.gravtrigent = self;
		other.gravtrig = 1;
		//dprint("Gravity changed to:\n");  Removed since it spams the console every frame on developer 1
		//dprint(ftos(self.gravity));
		//dprint("\n");
	}
};

void () trigger_setgravity = {
   InitTrigger ();
   self.touch = trigger_setgravity_touch;
   if (self.gravity <= 0 || self.gravity > 1) self.gravity = 1;
};

float CMD_ACTIVATOR_ONLY = 2;
float CMD_UPDATE_ENV_VARIABLES = 4;
float CMD_DO_NOT_TERMINATE = 8;


void () command_use_server = {
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
				if (!(self.spawnflags & CMD_DO_NOT_TERMINATE)) {
					Safe_stuffcmd(activator,"\n");
				}
			}
		}
	} else {
		// Stuff commands to all players on the server
		pent = find(world,classname,"player");
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

void () command_use = {
	localcmd (self.message);
	if (!(self.spawnflags & CMD_DO_NOT_TERMINATE)) {
		localcmd("\n");
	}
	if (self.classname == "info_command_spawn") {
		entity_hide(self);
	}
};

void () info_command_use_server = { command_use_server(); };
void () info_command_use = { command_use(); };

void () info_command = {
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
void () info_command_server = {
	if (self.message == "") { remove(self); return; }
	self.use = info_command_use_server;
	self.think = SUB_Null;
};

void () info_command_spawn = {
	if (self.message == "") { remove(self); return; }
	//self.spawnflags = self.spawnflags | CMD_RESEND_ON_LOAD;
	self.use = info_command_use;
	self.think = SUB_Null;
};

void () trigger_command_touch = { if (other.flags & FL_CLIENT) command_use(); };
void () trigger_command = {
	if (self.message == "") { remove(self); return; }
	InitTrigger ();
	self.touch = trigger_command_touch;
};

void () trigger_waterfall_touch = {
   if ( !(other.flags & FL_CLIENT) ) return ;
   other.velocity = (other.velocity + self.movedir);
   other.velocity_x = (other.velocity_x + (self.count * (random () - 0.500)));
   other.velocity_y = (other.velocity_y + (self.count * (random () - 0.500)));
};

void () trigger_waterfall = {
   InitTrigger ();
   self.touch = trigger_waterfall_touch;
   if ( (self.count == FALSE) ) self.count = 100.000;
   if ( (self.movedir == '0 0 0') ) self.movedir = '0 -90 0';
   if ( (self.speed == FALSE) ) {
      self.movedir = (self.movedir * 50.000);
   } else {
      self.movedir = (self.movedir * self.speed);
   }
};



void () counter_think = {
   self.cnt = (self.cnt + TRUE);
   if ( (self.spawnflags & COUNTER_RANDOM) ) {
      self.state = (random () * self.count);
      self.state = (floor (self.state) + TRUE);
   } else {
      self.state = self.cnt;
   }
   activator = other;
   SUB_UseTargets ();
   self.nextthink = (time + self.wait);
   if ( (self.spawnflags & COUNTER_STEP) ) counter_on_use ();
   if ( (self.cnt >= self.count) ) {
		self.cnt = FALSE;
		if ( (self.aflag || !(self.spawnflags & COUNTER_LOOP)) && self.spawnflags & COUNTER_TOGGLE ) {
			counter_on_use ();
		} else {
			remove (self);
		}
   }
};

void () counter_on_use = {
   if ( ((self.cnt != FALSE) && (self.spawnflags & COUNTER_FINISHCOUNT)) ) { self.aflag = TRUE; return; }
   self.use = counter_off_use;
   self.think = SUB_Null;
   self.aflag = FALSE;
};

void () counter_off_use = {
   self.aflag = FALSE;
   if ( (self.spawnflags & COUNTER_TOGGLE) ) {
      self.use = counter_on_use;
   } else {
      self.use = SUB_Null;
   }
   if ( (self.spawnflags & COUNTER_RESET) ) {
      self.cnt = FALSE;
      self.state = FALSE;
   }
   self.think = counter_think;
   if ( self.delay ) {
      self.nextthink = (time + self.delay);
   } else {
      counter_think ();
   }
};
float (entity counter) counter_GetCount = {
   if ( (counter.classname == "counter") ) return ( counter.state );
   return ( FALSE );
};

void () func_counter = {
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

void () oncount_use = {
   if ( (counter_GetCount (other) == self.count) ) {
      activator = other;
      SUB_UseTargets ();
   }
};

void () func_oncount = {
   self.count = floor (self.count);
   if ( (self.count <= FALSE) ) self.count = TRUE;
   self.classname = "oncount";
   self.use = oncount_use;
   self.think = SUB_Null;
};

void() change_cvar = {
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

void() cvarset_touch = {
	if (other.health <= 0 || other.classname != "player") return;
	change_cvar();
};

void() trigger_cvarset = {
	if (deathmatch || coop) remove (self);
	InitTrigger ();
	self.use = change_cvar;
	self.touch = cvarset_touch;
};

//- - - - - - - - -
// Update 8/19/09:  Jump/Dive Triggers

// Hipnotic's cnt stuff - - - - - - - -
// Code common to various triggers with Hip countdown on touch.
void() HipCntDown =
{
    if (self.cnt > 0)
    {
        self.cnt = self.cnt - 1;
        if (self.cnt == 0)
        {
            self.solid      = SOLID_NOT;    // PM:  Another safeguard.
            self.touch      = SUB_Null;
            self.nextthink  = time + 0.1;
            self.think      = SUB_Remove;
        }
    }
};

// Override velocity if a player jumps within one.
void() tjump_touch =
{
    if (other.health <= 0)
        return;
    if (other.classname != "player")    //if (!(other.flags & FLx_CREATURE))
        return;     // Only creatures can use jump pads.

    if (self.spawnflags & PUSH_JUMP_ONLY)
    {   // Jump only when player presses jump button.
//        if (other.fly_sound < time)
//        {
//            other.fly_sound = time + 1.5;
//            if (!(self.spawnflags & PUSH_CURRENT))
//                sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
//        }
        if (!other.jump_time || (other.jump_time + 0.2 < time))
            return;     // Didn't jump recently.
        other.jump_time = 0;    // Time to fly!
    }
    else
    {   // Automatic use.
        if (other.flags & FL_CLIENT)    // Only clients use falling damage.
            other.jump_flag = 0;    // Don't take damage if fell on trigger.
        if (other.flags & FL_ONGROUND == 0)
            return;
    }

// Up, up, and away!
    if (!(self.spawnflags & PUSH_CURRENT))
    {   // First sound overrides jump sound.  Second sound is standard push sound.
        sound (other, CHAN_BODY, "items/reflect.wav", 1, ATTN_NORM);
        sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
    }
    if (self.speed)
    {   // Unlike trigger_monsterjump, jump at a direction 'other' is facing.
        local   vector  vec;

        vec = '0 0 0';
        vec_y = other.angles_y;
        makevectors (vec);
        other.velocity = v_forward * self.speed;
    }
    other.velocity_z = self.height;
    other.flags = other.flags - (other.flags & FL_ONGROUND);

//    if (self.spawnflags & PUSH_ONCE)
//        {remove (self);  return;}

// Hipnotic's cnt stuff - - - - - - - -
    HipCntDown ();
//- - - - - - - - - - - - - - - - - - -
};

//============
// --> QUAKED trigger_jump (.5 .5 .5) ? PUSH_ONCE PUSH_CURRENT PUSH_JUMP_ONLY
// Pushes the player up
//============
void() trigger_jump_spawn =
{
    precache_sound ("ambience/windfly.wav");
    precache_sound ("items/reflect.wav");       // Bounce sound.

    // 'InitTrigger' already done elsewhere.
    self.touch = tjump_touch;

    if (!self.height)
        self.height = 1000;     // PM:  Use 900 in roman3 and unforgiven2.
// Hipnotic's cnt stuff - - - - - - - -
    if (!self.cnt)
        self.cnt = -1;
//- - - - - - - - - - - - - - - - - - -
};

void() trigger_jump = {InitTrigger ();  trigger_jump_spawn ();};

//johnfitz

/*QUAKED tele_fog (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)

When triggered, tele_fog shows the teleport particle effects and sounds.

Use this when killtageting an entity if the player can see.

*/

void () play_tfog = //thanks Khreathor -- dumptruck_ds

{
  spawn_tfog(self.origin);
}

void() tele_fog = {
  self.use = play_tfog;
}


void () play_meatspray = {
	if (self.style == 1) {
		ThrowGib(1,2);
		ThrowGib(2,2);
		ThrowGib(3,2);
	} else {
		ThrowGib(1, 1);
		ThrowGib(2, 1);
		ThrowGib(3, 1);
	}

	if (self.fly_sound != 1)
		return;

	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
};


void() meat_shower =
{
  self.use = play_meatspray;
}
/*
//misc gore
// Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds
void() gib_head_demon =
{
	precache_model("progs/h_demon.mdl");
	setmodel(self, "progs/h_demon.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-13.64 -16.77 -0.11','17.44 16.22 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_dog =
{
	precache_model("progs/h_dog.mdl");
	setmodel(self, "progs/h_dog.mdl");
        self.frame = 0;  //was 1 -- dumptruck_ds

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-9.66 -11.89 -0.2','6.57 7.96 13.29');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_army =
{
	precache_model("progs/h_guard.mdl");
	setmodel(self, "progs/h_guard.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-9.67 -8.27 -0.28','4.05 4.8 13.41');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_hell_knight =
{
	precache_model("progs/h_hellkn.mdl");
	setmodel(self, "progs/h_hellkn.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-7.9 -12.97 -0.63','10.55 8.87 21.06');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_knight =
{
	precache_model("progs/h_knight.mdl");
	setmodel(self, "progs/h_knight.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-8.17 -7.47 -0.13','8.36 6.5 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_enforcer =
{
	precache_model("progs/h_mega.mdl");
	setmodel(self, "progs/h_mega.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-10.63 -10.23 -0.05','9.27 8.25 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_ogre =
{
	precache_model("progs/h_ogre.mdl");
	setmodel(self, "progs/h_ogre.mdl");
        self.frame = 0;

	if (self.spawnflags & 1)
	{
		self.solid = SOLID_BBOX;
               	setsize(self,'-12.35 -15.7 -0.17','10.67 13.88 30');
	}
	else
	{
		self.solid = SOLID_NOT;
	}
};

void() gib_head_player = {
	precache_model("progs/h_player.mdl");
	setmodel(self, "progs/h_player.mdl");
    self.frame = 0;

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-9.67 -12.38 -2.1','11.49 50.7 30');
	} else {
		self.solid = SOLID_NOT;
	}
};

void() gib_head_shalrath = {
	precache_model("progs/h_shal.mdl");
	setmodel(self, "progs/h_shal.mdl");

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-19.85 -19.09 -1.44','13.72 16.8 30');
	} else {
		self.solid = SOLID_NOT;
	}
};

void() gib_head_shambler = {
    precache_model("progs/h_shams.mdl");
    setmodel(self, "progs/h_shams.mdl");

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-15.15 -20.638 -0.45','21.44 21.76 30');
	} else {
		self.solid = SOLID_NOT;
	}
};

void() gib_head_wizard = {
	precache_model("progs/h_wizard.mdl");
	setmodel(self, "progs/h_wizard.mdl");

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-10.41 -8.66 -0.54','6.52 10.82 30');
	} else {
		self.solid = SOLID_NOT;
	}
};

void() gib_head = {
	if (self.count == 0) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 1) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 2) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 3) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 4) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 5) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 6) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 7) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 8) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 9) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }	
	if (self.count == 10) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 11) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 12) { self.mdl = "progs/h_dog.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 13) { self.mdl = "progs/h_bandit.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 14) { self.mdl = "progs/h_babe.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 15) { self.mdl = "progs/custents/h_axzomb.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 16) { self.mdl = "progs/drake/h_axeman.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 17) { self.mdl = "progs/h_archg.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 18) { self.mdl = "progs/drake/h_archer.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }
	if (self.count == 19) { self.mdl = "progs/alien/h_alien.mdl"; self.mins = '-9.66 -11.89 -0.2'; self.maxs = '6.57 7.96 13.29'; }

	precache_model(self.mdl);
	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
		setsize(self,self.mins,self.maxs);
	} else {
		self.solid = SOLID_NOT;
	}
}

void() gib_misc_1 = {
	precache_model("progs/gib1.mdl");
	setmodel(self, "progs/gib1.mdl");

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-3.57 -8.06 -3.34','3.69 8.31 30');
	} else {
		self.solid = SOLID_NOT;
	}
};

void() gib_misc_2 = {
	precache_model("progs/gib2.mdl");
	setmodel(self, "progs/gib2.mdl");

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-12.68 -14.83 -6.19','13.53 14.57 30');
	} else {
		self.solid = SOLID_NOT;
	}
};

void() gib_misc_3 = {
	precache_model("progs/gib3.mdl");
	setmodel(self, "progs/gib3.mdl");

	if (self.spawnflags & 1) {
		self.solid = SOLID_BBOX;
        setsize(self,'-18.95 -15.92 -3.13','13.17 15.66 30');
	} else {
		self.solid = SOLID_NOT;
	}
};
// END Scenic Dead Monster Patch stuff here from DeadStuff mod -- dumptruck_ds

*/

// Touch trigger that prevents things from falling too fast.
void() trigger_dive_touch =
{
// PM:  Use wind flag on projectiles to catch them.
// Replaced grenade classname check with wind flag check.
    if (!(other.flags & FL_ONGROUND))
    if ((other.health > 0) || (other.xfl & XFL_WIND))
    if (other.velocity_z < self.speed)
    {
        other.velocity_z = self.speed;
        if (other.classname == "player")
        {
            if (other.fly_sound < time)
            {
                other.fly_sound = time + 1.5;
                if (!(self.spawnflags & PUSH_CURRENT))
                    sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
            }
        }
    }
};

void() push_use2 =   // This function is Zerstorer stuff.
{
    if (self.solid == SOLID_NOT)
        self.solid = SOLID_TRIGGER;
    else
        self.solid = SOLID_NOT;
};

//============
// --> QUAKED trigger_dive (.5 .5 .5) ? x PUSH_CURRENT
// Slows downward velocity to prevent falling damage.
//============
void() trigger_dive_spawn =
{
//    InitTrigger ();
    precache_sound ("ambience/windfly.wav");
    self.touch = trigger_dive_touch;
    if (!self.speed)
        self.speed = -500;
//- - - - - - - - -
// Zerstorer stuff
    if (self.targetname)
        {self.solid = SOLID_NOT; self.use = push_use2;}
//- - - - - - - - -
};
void() trigger_dive = {InitTrigger ();  trigger_dive_spawn();};
void() trigger_dive_point = {InitPointTrigger ();  trigger_dive_spawn();};