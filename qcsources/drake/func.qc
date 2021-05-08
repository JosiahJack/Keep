// button and multiple button
//============
void() button_blocked = {};     // Do nothing, just don't come all the way
                                // back out.
//============
void() button_done = {self.state = STATE_BOTTOM;};
//============
void() button_return =
{
    self.state = STATE_DOWN;
    SUB_CalcMove (self.pos1, self.speed, button_done);
    self.frame = 0;            // use normal textures
    if (self.health)
        self.takedamage = DAMAGE_YES;    // can be shot again
};
//============
void() button_wait =
{
    self.state      = STATE_TOP;
    self.nextthink  = self.ltime + self.wait;
    self.think      = button_return;
    activator       = self.enemy;
    SUB_UseTargets ();
    self.frame      = 1;    // use alternate textures
};
//============
void() button_fire =
{
    if (self.state == STATE_UP || self.state == STATE_TOP)
        return;

    sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    self.state = STATE_UP;
    SUB_CalcMove (self.pos2, self.speed, button_wait);
};
//============
void() button_use =
{
    self.enemy = activator;
    button_fire ();
};
//============
void() button_touch =
{
    if (other.classname != "player")
        return;
    self.enemy = other;
    button_fire ();
};
//============
void() button_killed =
{
    self.enemy      = damage_attacker;
    self.health     = self.max_health;
    self.takedamage = DAMAGE_NO;    // wil be reset upon return
    button_fire ();
};


//============
// --> QUAKED func_button (0 .5 .8) ?
// When a button is touched, it moves some distance in the direction of it's
// angle, triggers all of it's targets, waits some time, then returns to it's
// original position where it can be triggered again.
//
// "angle"      determines the opening direction
// "target"     all entities with a matching targetname will be used
// "speed"      override the default 40 speed
// "wait"       override the default 1 second wait (-1 = never return)
// "lip"        override the default 4 pixel lip remaining at end of move
// "health"     if set, the button must be killed instead of touched
// "sounds"
// 0) steam metal
// 1) wooden clunk
// 2) metallic click
// 3) in-out
//============
void() func_button =
{
    local   string  text;

// SoE:  Fix nsoe2.
    if (soul_evil)
        if (world.model == "maps/nsoe2.bsp")
            if (self.target == "plat")
                self.message = "Stairs above the\nsilver door have risen.";
//- - - - - - - - -
    if (self.sounds == 0)
        text = "buttons/airbut1.wav";
    else if (self.sounds == 1)
        text = "buttons/switch21.wav";
    else if (self.sounds == 2)
        text = "buttons/switch02.wav";
    else if (self.sounds == 3)
        text = "buttons/switch04.wav";
    else //if (self.sounds == 4)    // Zerstorer
        text = "misc/null.wav";
    precache_sound (text);
    self.noise = text;
    
    SetMovedir ();

    self.movetype = MOVETYPE_PUSH;
    self.solid = SOLID_BSP;
    setmodel (self, self.model);

    self.blocked = button_blocked;
    self.use = button_use;

    if (self.health)
    {
        self.max_health = self.health;
        self.th_die     = button_killed;
        self.takedamage = DAMAGE_YES;
        self.bloodtype  = BLOOD_RED + 1;
    }
    else
        self.touch = button_touch;

    if (!self.speed)
        self.speed = 40;
    if (!self.wait)
        self.wait = 1;
    if (!self.lip)
        self.lip = 4;

    self.state = STATE_BOTTOM;

    self.pos1 = self.origin;
    self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
};


//===========================================================================

float   DOOR_START_OPEN = 1;
float   DOOR_DONT_LINK  = 4;
float   DOOR_GOLD_KEY   = 8;
float   DOOR_SILVER_KEY = 16;
float   DOOR_TOGGLE     = 32;

// Doors are similar to buttons, but can spawn a fat trigger field around
// them to open without a touch, and they link together to form simultaneous
// double/quad doors.
//
// Door.owner is the master door.  If there is only one door, it points to
// itself.  If multiple doors, all will point to a single one.
//
// Door.enemy chains from the master door through all doors linked in the
// chain.

//===========================================================================
//  THINK FUNCTIONS
//===========================================================================
void() door_go_down;
void() door_go_up;

void() door_blocked =
{
    T_Damage (other, self, self, self.dmg);

// If a door has a negative wait, it would never come back if blocked,
// so let it just squash the object to death real fast.
    if (self.wait >= 0)
    {
        if (self.state == STATE_DOWN)
            door_go_up ();
        else
            door_go_down ();
    }
};

//============
void() door_hit_top =
{
    sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
    self.state = STATE_TOP;
    if (self.spawnflags & DOOR_TOGGLE)
        return;        // don't come down automatically
    self.think = door_go_down;
    self.nextthink = self.ltime + self.wait;
};

//============
void() door_hit_bottom =
{
    sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
    self.state = STATE_BOTTOM;
};

//============
void() door_go_down =
{
    sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
    if (self.max_health)
    {
        self.takedamage = DAMAGE_YES;
        self.health = self.max_health;
    }

    self.state = STATE_DOWN;
    SUB_CalcMove (self.pos1, self.speed, door_hit_bottom);
};

//============
void() door_go_up =
{
    if (self.state == STATE_UP)
        return;        // already going up

    if (self.state == STATE_TOP)
    {    // reset top wait time
        self.nextthink = self.ltime + self.wait;
        return;
    }
    
    sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
    self.state = STATE_UP;
    SUB_CalcMove (self.pos2, self.speed, door_hit_top);

    SUB_UseTargets();
};


//===========================================================================
//  ACTIVATION FUNCTIONS
//===========================================================================
void() door_fire =
{
    local   entity  oself;
    local   entity  starte;

    if (self.owner != self)
        objerror ("door_fire: self.owner != self");

// play use key sound
// PM:  Use CHAN_AUTO instead of CHAN_VOICE because the door uses the
// voice channel to play self.noise2.
    if (self.items)
        sound (self, CHAN_AUTO, self.noise4, 1, ATTN_NORM);

    self.message = world.null_string;   // no more message
    oself = self;

    if (self.spawnflags & DOOR_TOGGLE)
        if (self.state == STATE_UP || self.state == STATE_TOP)
        {
            starte = self;
            do
            {
                door_go_down ();
                self = self.enemy;
            } while ( (self != starte) && (self != world) );
            self = oself;
            return;
        }
    
// trigger all paired doors
    starte = self;
    do
    {
        door_go_up ();
        self = self.enemy;
    } while ( (self != starte) && (self != world) );
    self = oself;
};

//============
void() door_use =
{
    local   entity  oself;

    self.message        = "";   // door message are for touch only
    self.owner.message  = "";    
    self.enemy.message  = "";

    oself = self;
    self = self.owner;
    door_fire ();
    self = oself;
};

//============
void() door_trigger_touch =
{
    if (other.health <= 0)
        return;

    if (time < self.attack_finished)
        return;
    self.attack_finished = time + 1;

    activator = other;

    self = self.owner;
    door_use ();
};

//============
void() door_killed =
{
    local   entity  oself;

    oself = self;
    self = self.owner;
    self.health = self.max_health;
    self.takedamage = DAMAGE_NO;    // will be reset upon return
    door_use ();
    self = oself;
};


//================
// door_touch
//
// Prints messages and opens key doors
//================
void() door_touch =
{
    if (other.classname != "player")
        return;
    if (self.owner.attack_finished > time)
        return;

    self.owner.attack_finished = time + 2;

    if (self.owner.message != "")
    {
        centerprint (other, self.owner.message);
        sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    }
    
// key door stuff
    if (!self.items)
        return;

// FIXME: blink key on player's status bar
    if ( (self.items & other.items) != self.items )
    {
// PM (Todo):  Maybe use "keyop" fields from Dragons to make keys blink?
        local   string  text;
        local   float   need;

        need = self.owner.items - (self.owner.items & other.items);
        need = need & ITx_ALL_KEYS;
        if (need == IT_KEY1)
        {
            if (world.worldtype == 2)
                text = "You need the silver keycard";
            else if (world.worldtype == 1)
                text = "You need the silver runekey";
            else //if (world.worldtype == 0)
                text = "You need the silver key";
        }
        else if (need == IT_KEY2)
        {
            if (world.worldtype == 2)
                text = "You need the gold keycard";
            else if (world.worldtype == 1)
                text = "You need the gold runekey";
            else //if (world.worldtype == 0)
                text = "You need the gold key";
        }
        else if (need)  // Door needs two keys to open!
        {
            if (world.worldtype == 2)
                text = "You need both keycards";
            else if (world.worldtype == 1)
                text = "You need both runekeys";
            else //if (world.worldtype == 0)
                text = "You need both keys";
        }
        else    // Door requires an item that isn't a key.  Shouldn't happen.
        {
            text = "Locked";
        }
        centerprint (other, text);
        sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
        return;
    }

//- - - - - - - - -
// Remove item_keys.
    if (self.items & IT_KEY1)
        if (other.keyop1)
            remove (other.keyop1);
    if (self.items & IT_KEY2)
        if (other.keyop2)
            remove (other.keyop2);
//- - - - - - - - -
    other.items = other.items - self.items;
    self.touch = SUB_Null;
    if (self.enemy)
        self.enemy.touch = SUB_Null;    // get paired door
    door_use ();
};

//===========================================================================
//  SPAWNING FUNCTIONS
//===========================================================================

entity(vector fmins, vector fmaxs) spawn_field =
{
    local   entity  trigger;

    trigger = spawn();
    trigger.movetype    = MOVETYPE_NONE;
    trigger.solid       = SOLID_TRIGGER;
    trigger.owner       = self;
    trigger.touch       = door_trigger_touch;

    fmins = fmins - '60 60 8';
    fmaxs = fmaxs + '60 60 8';
    setsize (trigger, fmins, fmaxs);
    return (trigger);
};

float(entity e1, entity e2) EntitiesTouching =
{
    if (e1.mins_x > e2.maxs_x)  return FALSE;
    if (e1.mins_y > e2.maxs_y)  return FALSE;
    if (e1.mins_z > e2.maxs_z)  return FALSE;
    if (e1.maxs_x < e2.mins_x)  return FALSE;
    if (e1.maxs_y < e2.mins_y)  return FALSE;
    if (e1.maxs_z < e2.mins_z)  return FALSE;
    return TRUE;
};


//=============
// LinkDoors
//=============
void() LinkDoors =
{
    if (self.enemy)
        return;        // already linked by another door
    if (self.spawnflags & 4)
    {
        self.owner = self.enemy = self;
        return;        // don't want to link this door
    }

    local   entity  t, starte;
    local   vector  cmins, cmaxs;

    cmins = self.mins;
    cmaxs = self.maxs;
    
    starte = self;
    t = self;
    
    do
    {
        self.owner = starte;            // master door

        if (self.health)
            starte.health = self.health;
        if (self.targetname)
            starte.targetname = self.targetname;
        if (self.message != "")
            starte.message = self.message;

        t = find (t, classname, self.classname);
        if (!t)
        {
            self.enemy = starte;        // make the chain a loop

        // shootable, fired, or key doors just needed the owner/enemy links,
        // they don't spawn a field
    
            self = self.owner;

            if (self.health)
                return;
            if (self.targetname)
                return;
            if (self.items)
                return;

            self.owner.trigger_field = spawn_field(cmins, cmaxs);

            return;
        }

        if (EntitiesTouching (self, t))
        {
            if (t.enemy)
                objerror ("cross connected doors");
            
            self.enemy = t;
            self = t;

            if (t.mins_x < cmins_x)
                cmins_x = t.mins_x;
            if (t.mins_y < cmins_y)
                cmins_y = t.mins_y;
            if (t.mins_z < cmins_z)
                cmins_z = t.mins_z;
            if (t.maxs_x > cmaxs_x)
                cmaxs_x = t.maxs_x;
            if (t.maxs_y > cmaxs_y)
                cmaxs_y = t.maxs_y;
            if (t.maxs_z > cmaxs_z)
                cmaxs_z = t.maxs_z;
        }
    } while (1);

};


//============
// --> QUAKED func_door (0 .5 .8) ? START_OPEN x DOOR_DONT_LINK GOLD_KEY SILVER_KEY TOGGLE
// if two doors touch, they are assumed to be connected and operate as a unit.
//
// TOGGLE causes the door to wait in both the start and end states for a
// trigger event.
//
// START_OPEN causes the door to move to its destination when spawned, and
// operate in reverse.  It is used to temporarily or permanently close off
// an area when triggered (not useful for touch or takedamage doors).
//
// Key doors are always wait -1.
//
// "message"    is printed when the door is touched if it is a trigger door
//     and it hasn't been fired yet
// "angle"      determines the opening direction
// "targetname" if set, no touch field will be spawned and a remote button or
//     trigger field activates the door.
// "health"     if set, door must be shot open
// "speed"      movement speed (100 default)
// "wait"       wait before returning (3 default, -1 = never return)
// "lip"        lip remaining at end of move (8 default)
// "dmg"        damage to inflict when blocked (2 default)
// "sounds"
// 0)    no sound
// 1)    stone
// 2)    base
// 3)    stone chain
// 4)    screechy metal
//============
void() func_door =
{
// DISABLED -- Obsolete (but could be useful to test other maps).
// Hack:  Remove the door with no model.  Prevents engine crash.
//    if (!self.model)
//    {
//        dprint ("unmodeled func_door removed\n");
//        remove (self);
//        return;
//    }
//- - - - - - - - -

// Key sounds
    if (world.worldtype == 2)
    {
        self.noise3 = "doors/basetry.wav";
        self.noise4 = "doors/baseuse.wav";
    }
    else if (world.worldtype == 1)
    {
        self.noise3 = "doors/runetry.wav";
        self.noise4 = "doors/runeuse.wav";
    }
    else //if (world.worldtype == 0)
    {
        self.noise3 = "doors/medtry.wav";
        self.noise4 = "doors/meduse.wav";
    }
// Door sounds
    if (self.sounds == 4)
    {
        self.noise1 = "doors/ddoor2.wav";
        self.noise2 = "doors/ddoor1.wav";
    }
    else if (self.sounds == 3)
    {
        self.noise2 = "doors/stndr1.wav";
        self.noise1 = "doors/stndr2.wav";
    }
    else if (self.sounds == 2)
    {
        self.noise2 = "doors/hydro1.wav";
        self.noise1 = "doors/hydro2.wav";
    }
    else if (self.sounds == 1)
    {
        self.noise1 = "doors/drclos4.wav";
        self.noise2 = "doors/doormv1.wav";
    }
    else //if (self.sounds == 0)
    {
        self.noise1 = "misc/null.wav";
        self.noise2 = "misc/null.wav";
    }

    precache_sound (self.noise1);   precache_sound (self.noise2);
    precache_sound (self.noise3);   precache_sound (self.noise4);

    SetMovedir ();

    self.max_health = self.health;
    self.solid      = SOLID_BSP;
    self.movetype   = MOVETYPE_PUSH;
    setorigin (self, self.origin);    
    setmodel (self, self.model);
    self.classname  = "door";
//// Zerstorer stuff.  FIXME!
//    if (self.spawnflags & 64)
//        {self.mdl = self.model;  self.model = world.null_string;}

    self.blocked    = door_blocked;
    self.use        = door_use;
    
// PM:  Rewritten to allow doors require two keys to unlock.
// FIXME:  Are there any custom maps with both key sf on that shouldn't?
    self.items = 0;
// SoE nsoe5 hack:  Remove gold door and make silver door take two keys.
    if (self.spawnflags & DOOR_SILVER_KEY)
    {   if (world.model == "maps/nsoe5.bsp")
            self.items = self.items | IT_KEY2;
        self.items = self.items | IT_KEY1;
    }
    if (self.spawnflags & DOOR_GOLD_KEY)
    {   if (world.model == "maps/nsoe5.bsp")
            {remove(self);  return;}
        self.items = self.items | IT_KEY2;
        // Hack:  Fix Rapture maps.
        if (world.model == "maps/sub.bsp")  // Rapture: A Cross to Bear
            self.items = IT_KEY2;   // Don't let gold door require two keys.
    }
//    if (self.items & ITx_ALL_KEYS == ITx_ALL_KEYS)
//        dprint ("  >> 2 keys!\n");
//- - - - - - - - -
    
    if (!self.speed)
        self.speed = 100;
    if (!self.wait)
        self.wait = 3;
    if (!self.lip)
        self.lip = 8;
    if (!self.dmg)
        self.dmg = 2;

    self.pos1 = self.origin;
    self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);

// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
// but spawn in the open position
    if (self.spawnflags & DOOR_START_OPEN)
    {
        setorigin (self, self.pos2);
        self.pos2 = self.pos1;
        self.pos1 = self.origin;
    }

    self.state = STATE_BOTTOM;

    if (self.health)
    {
        self.bloodtype = BLOOD_RED + 1;
        self.takedamage = DAMAGE_YES;
        self.th_die = door_killed;
    }
    
    if (self.items)
        self.wait = -1;
        
    self.touch = door_touch;

// LinkDoors can't be done until all of the doors have been spawned, so
// the sizes can be detected properly.
    self.think      = LinkDoors;
    self.nextthink  = self.ltime + 0.1;
};

//===========================================================================
//  SECRET DOORS
//===========================================================================

void() fd_secret_move1;
void() fd_secret_move2;
void() fd_secret_move3;
void() fd_secret_move4;
void() fd_secret_move5;
void() fd_secret_move6;
void() fd_secret_done;

float   SECRET_OPEN_ONCE    =  1;   // stays open
float   SECRET_1ST_LEFT     =  2;   // 1st move is left of arrow
float   SECRET_1ST_DOWN     =  4;   // 1st move is down from arrow
float   SECRET_NO_SHOOT     =  8;   // only opened by trigger
float   SECRET_YES_SHOOT    = 16;   // shootable even if targeted

void () fd_secret_use =
{
    local   float   temp;
    
    self.health = 10000;

    // exit if still moving around...
    if (self.origin != self.oldorigin)
        return;
    
    self.message = world.null_string;   // no more message

    SUB_UseTargets ();              // fire all targets / killtargets

    if (!(self.spawnflags & SECRET_NO_SHOOT))
    {
        self.th_pain    = SUB_Null;
        self.takedamage = DAMAGE_NO;
    }
    self.velocity = '0 0 0';

    // Make a sound, wait a little...
    
    sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
    self.nextthink = self.ltime + 0.1;

    temp = 1 - (self.spawnflags & SECRET_1ST_LEFT);    // 1 or -1
    makevectors (self.mangle);
    
    if (!self.t_width)
    {
        if (self.spawnflags & SECRET_1ST_DOWN)
            self.t_width = fabs(v_up * self.size);
        else
            self.t_width = fabs(v_right * self.size);
    }

    if (!self.t_length)
        self.t_length = fabs(v_forward * self.size);

    if (self.spawnflags & SECRET_1ST_DOWN)
        self.dest1 = self.origin - v_up * self.t_width;
    else
        self.dest1 = self.origin + v_right * (self.t_width * temp);

    self.dest2 = self.dest1 + v_forward * self.t_length;
    SUB_CalcMove (self.dest1, self.speed, fd_secret_move1);
    sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
};

// Wait after first movement...
void() fd_secret_move1 = 
{
    self.nextthink = self.ltime + 1.0;
    self.think = fd_secret_move2;
    sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};
// Start moving sideways w/sound...
void() fd_secret_move2 =
{
    sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
    SUB_CalcMove(self.dest2, self.speed, fd_secret_move3);
};
// Wait here until time to go back...
void() fd_secret_move3 =
{
    sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
    if (!(self.spawnflags & SECRET_OPEN_ONCE))
    {
        self.nextthink = self.ltime + self.wait;
        self.think = fd_secret_move4;
    }
};
// Move backward...
void() fd_secret_move4 =
{
    sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
    SUB_CalcMove (self.dest1, self.speed, fd_secret_move5);        
};
// Wait 1 second...
void() fd_secret_move5 = 
{
    self.nextthink = self.ltime + 1.0;
    self.think = fd_secret_move6;
    sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};
void() fd_secret_move6 =
{
    sound (self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
    SUB_CalcMove (self.oldorigin, self.speed, fd_secret_done);
};
void() fd_secret_done =
{
    if (!self.targetname || (self.spawnflags & SECRET_YES_SHOOT))
    {
        self.health     = 10000;
        self.takedamage = DAMAGE_YES;
        self.th_pain    = fd_secret_use;    
    }
    sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
};

void() secret_blocked =
{
    if (time < self.attack_finished)
        return;
    self.attack_finished = time + 0.5;
    T_Damage (other, self, self, self.dmg);
};

//================
// secret_touch
//
// Prints messages
//================
void() secret_touch =
{
    if (other.classname != "player")
        return;
    if (self.attack_finished > time)
        return;

    self.attack_finished = time + 2;
// PM:  Can be TRUE for <self.message != "">, yet FALSE for <self.message>.
    if (self.message)
    {
        centerprint (other, self.message);
        sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
    }
};


//============
// --> QUAKED func_door_secret (0 .5 .8) ? open_once 1st_left 1st_down no_shoot always_shoot
// Basic secret door. Slides back, then to the side. Angle determines
// direction.
// wait  = # of seconds before coming back
// 1st_left = 1st move is left of arrow
// 1st_down = 1st move is down from arrow
// always_shoot = even if targeted, keep shootable
// t_width = override WIDTH to move back (or height if going down)
// t_length = override LENGTH to move sideways
// "dmg"        damage to inflict when blocked (2 default)
//
// If a secret door has a targetname, it will only be opened by it's button
// or trigger, not by damage.
// "sounds"
// 1) medieval
// 2) metal
// 3) base
//============
void () func_door_secret =
{
    if (self.sounds == 0)
        self.sounds = 3;

    if (self.sounds == 1)
    {
        precache_sound ("doors/latch2.wav");
        precache_sound ("doors/winch2.wav");
        precache_sound ("doors/drclos4.wav");
        self.noise1 = "doors/latch2.wav";
        self.noise2 = "doors/winch2.wav";
        self.noise3 = "doors/drclos4.wav";
    }
    else if (self.sounds == 2)
    {
        precache_sound ("doors/airdoor1.wav");
        precache_sound ("doors/airdoor2.wav");
        self.noise1 = "doors/airdoor2.wav";
        self.noise2 = "doors/airdoor1.wav";
        self.noise3 = "doors/airdoor2.wav";
    }
    else if (self.sounds == 3)
    {
        precache_sound ("doors/basesec1.wav");
        precache_sound ("doors/basesec2.wav");
        self.noise1 = "doors/basesec2.wav";
        self.noise2 = "doors/basesec1.wav";
        self.noise3 = "doors/basesec2.wav";
    }
    else
    {
        precache_sound ("misc/null.wav");
        self.noise1 = self.noise2 = self.noise3 = "misc/null.wav";
    }

    if (!self.dmg)
        self.dmg = 2;
        
    // Magic formula...
    self.mangle     = self.angles;
    self.angles     = '0 0 0';
    self.solid      = SOLID_BSP;
    self.movetype   = MOVETYPE_PUSH;
    self.classname  = "door";
    setmodel (self, self.model);
    setorigin (self, self.origin);    
    
    self.touch      = secret_touch;
    self.blocked    = secret_blocked;
    self.speed      = 50;
    self.use        = fd_secret_use;
    if ( !self.targetname || (self.spawnflags & SECRET_YES_SHOOT))
    {
        self.health     = 10000;
        self.takedamage = DAMAGE_YES;
        self.bloodtype  = BLOOD_RED + 1;
        self.th_pain    = fd_secret_use;
        self.th_die     = fd_secret_use;
    }
    self.oldorigin  = self.origin;
    if (!self.wait)
        self.wait   = 5;        // 5 seconds before closing
};


//==========================================================================
//  PLATS
//==========================================================================
void() plat_center_touch;
void() plat_outside_touch;
void() plat_trigger_use;
void() plat_go_up;
void() plat_go_down;
void() plat_crush;
float PLAT_LOW_TRIGGER = 1;
float PLAT_TOGGLE      = 2;     // Zerstorer

void() plat_spawn_inside_trigger =
{
    local   entity  trigger;
    local   vector  tmin, tmax;

// Middle trigger
    trigger = spawn();
    trigger.touch     = plat_center_touch;
    trigger.movetype  = MOVETYPE_NONE;
    trigger.solid     = SOLID_TRIGGER;
    trigger.enemy     = self;
    
    tmin = self.mins + '25 25 0';
    tmax = self.maxs - '25 25 -8';
    tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);
    if (self.spawnflags & PLAT_LOW_TRIGGER)
        tmax_z = tmin_z + 8;
    
    if (self.size_x <= 50)
    {
        tmin_x = (self.mins_x + self.maxs_x) / 2;
        tmax_x = tmin_x + 1;
    }
    if (self.size_y <= 50)
    {
        tmin_y = (self.mins_y + self.maxs_y) / 2;
        tmax_y = tmin_y + 1;
    }
    
    setsize (trigger, tmin, tmax);
};

void() plat_hit_top =
{
    sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
    self.state      = STATE_TOP;
    if (self.spawnflags & PLAT_TOGGLE)
        return;     // Zerstorer -- Don't set timer to go down if toggle.
    self.think      = plat_go_down;
    self.nextthink  = self.ltime + 3;
};

void() plat_hit_bottom =
{
    sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
    self.state = STATE_BOTTOM;
};

void() plat_go_down =
{
    sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    self.state = STATE_DOWN;
    SUB_CalcMove (self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up =
{
    sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    self.state = STATE_UP;
    SUB_CalcMove (self.pos1, self.speed, plat_hit_top);
};

void() plat_center_touch =
{
    if (other.classname != "player")
        return;
    if (other.health <= 0)
        return;

    self = self.enemy;
    if (self.state == STATE_BOTTOM)
        plat_go_up ();
    else if (self.state == STATE_TOP)
        self.nextthink = self.ltime + 1;    // delay going down
};

void() plat_outside_touch =
{
    if (other.classname != "player")
        return;
    if (other.health <= 0)
        return;

//dprint ("plat_outside_touch\n");
    self = self.enemy;
    if (self.state == STATE_TOP)
        plat_go_down ();
};

void() plat_trigger_use =
{
    if (self.think)
        return;        // already activated
    plat_go_down();
};

void() plat_crush =
{
//dprint ("plat_crush\n");
    T_Damage (other, self, self, 1);

    if (self.state == STATE_UP)
        plat_go_down ();
    else if (self.state == STATE_DOWN)
        plat_go_up ();
    else
        objerror ("plat_crush: bad self.state\n");
};

void() plat_use =
{
//- - - - - - - - -
// Zerstorer -- Move plat to the next state if toggle.
    if (self.spawnflags & PLAT_TOGGLE)
    {
        if (self.state == STATE_UP || self.state == STATE_TOP)
            plat_go_down ();
        else if (self.state == STATE_DOWN || self.state == STATE_BOTTOM)
            plat_go_up ();
        else
            dprint ("plat_use: bad state in use\n");    // should be objerror
        return;
    }
//- - - - - - - - -
    self.use = SUB_Null;
    if (self.state != STATE_UP)
        objerror ("plat_use: not in up state");
    plat_go_down();
};

//============
// --> QUAKED func_plat (0 .5 .8) ? PLAT_LOW_TRIGGER
// speed    (default 150)
//
// Plats are always drawn in the extended position, so they will light
// correctly.
//
// If the plat is the target of another trigger or button, it will start out
// disabled in the extended position until it is triggered, when it will
// lower and become a normal plat.
//
// If the "height" key is set, that will determine the amount the plat moves,
// instead of being implicitly determined by the model's height.
// Set "sounds" to one of the following:
// 1) base fast
// 2) chain slow
//============
void() func_plat =
{
    if (!self.t_length)
        self.t_length = 80;
    if (!self.t_width)
        self.t_width = 10;

    if (!self.sounds)
        self.sounds = 2;
    if (self.sounds == 1)
    {
        self.noise  = "plats/plat1.wav";
        self.noise1 = "plats/plat2.wav";
    }
    else if (self.sounds == 2)
    {
        self.noise  = "plats/medplat1.wav";
        self.noise1 = "plats/medplat2.wav";
    }
    else
    {   // Here's your generic plat sound!
        self.noise  = self.noise1   = "misc/null.wav";
    }
    precache_sound (self.noise);
    precache_sound (self.noise1);

    self.mangle = self.angles;
    self.angles = '0 0 0';

    self.classname  = "plat";
    self.solid      = SOLID_BSP;
    self.movetype   = MOVETYPE_PUSH;
    setorigin (self, self.origin);    
    setmodel (self, self.model);
    setsize (self, self.mins , self.maxs);

    self.blocked    = plat_crush;
    if (!self.speed)
        self.speed  = 150;

// pos1 is the top position, pos2 is the bottom
    self.pos1 = self.origin;
    self.pos2 = self.origin;
    if (self.height)
        self.pos2_z = self.origin_z - self.height;
    else
        self.pos2_z = self.origin_z - self.size_z + 8;

    self.use = plat_trigger_use;

//- - - - - - - - -
    if (!(self.spawnflags & PLAT_TOGGLE))   // Zerstorer.
        plat_spawn_inside_trigger ();    // the "start moving" trigger    
//- - - - - - - - -

    if (self.targetname)
    {
        self.state  = STATE_UP;
        self.use    = plat_use;
    }
    else
    {
        setorigin (self, self.pos2);
        self.state  = STATE_BOTTOM;
    }
};

//============================================================================

// PM:  Prototypes moved to proto.qc

void() train_blocked =
{
    if (time < self.attack_finished)
        return;
    self.attack_finished = time + 0.5;
    T_Damage (other, self, self, self.dmg);
};

void() train_use =
{
    if (self.think != func_train_find)
    {   // Already activated.
        if (self.velocity != '0 0 0')       // Hipnotic
            return;     // already activated
        if (self.classname != "train2")
            return;     // Old trains ignore even if stopped.
    }
//- - - - - - - - -
// Zerstorer -- trains can be restarted when they hit endpoints by triggering
// them again.
//
// Update:  Breaks crushing wall in E1M6, so do this only in Zer mode.
//- - - -
//    if (zerstorer)
//        if (self.delay)
//        {
//            self.think      = train_next;
//            self.nextthink  = time + self.delay;
//            return;
//        }
//- - - - - - - - -
    train_next ();
};

void() train_wait =
{
//- - - - - - - - -
// From Zerstorer -- If train hits a negative 'wait', reset self.think
// so it triggered to start moving again.  Similar code is found in OUM.
//
// I checked all id, Zerstorer, and OUM maps; and found no trains with
// a negative wait.  With that in mind, I'll merge Hipnotic's train code
// with the standard train code and call it a day.
//- - - - - - - - -
    if (self.wait)
    {
        if (self.wait != -1)    // Hipnotic's train2.
        {   self.nextthink = self.ltime + self.wait;
            self.wait = 0;      // Will be refreshed in train_next.
        }
        if (self.noise)
            sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
// DISABLED -- Unused Zerstorer/OUM stuff.
//        if (self.wait < 0)
//            {self.think = func_train_find;  return;}
    }
    else
        self.nextthink = self.ltime + 0.1;
    self.think = train_next;

// Old code
//    if (self.wait)
//    {   self.nextthink = self.ltime + self.wait;
//        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
//    }
//    else
//        self.nextthink = self.ltime + 0.1;
//    self.think = train_next;
};

//============
void() train_next =
{
    local   entity  targ;
    local   float   sped;

// Hip's func_train2 - - - - -
// Get the speed of the current path_corner.
// We must save this off at each path change since
// we don't have a pointer to the current path_corner.
    sped = self.cnt;
//- - - - - - - - - - - - - -

    targ = find (world, targetname, self.target);
    self.cnt = targ.speed;      // Save speed in cnt for later use.
    self.target = targ.target;

    if (!self.target)
        objerror ("train_next: no next target");
    self.wait = targ.wait;
//    if (zerstorer)
//        if (targ.speed)
//            self.speed = targ.speed;    // Zerstorer -- copy speed to train.

    sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
// Replaced
//    SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait);
// with Hip's train code below...
//- - - - - - - - -
    if (targ.wait)
        self.think = train_wait;
    else
        self.think = train_next;

    // Event stuff.
    if (self.goalentity.event)
    {
        // Trigger any events that should happen at the corner.
        local   string  temp;

        temp = self.target;
        self.target = self.goalentity.event;
        self.message = self.goalentity.message;
        SUB_UseTargets ();
        self.target = temp;
        self.message = world.null_string;
    }

    self.goalentity = targ;     // Save current entity.
    if (sped == -1)
    {   // Warp to the next path_corner.
        setorigin (self, targ.origin - self.mins);
        self.nextthink = 0.01;      // Think ASAP.
    }
    else
    {
        if (sped > 0)
            self.speed = sped;      // Speed change.
        SUB_CalcMove (targ.origin - self.mins, self.speed, self.think);
    }
//- - - - - - - - -
};

//============
void() func_train_find =
{
    local   entity  targ;

    targ = find (world, targetname, self.target);
// PM:  Merged with Hipnotic's func_train2.
    self.goalentity = targ;     // Save current entity.
    self.cnt = targ.speed;
//- - - - - - - - -
    self.target = targ.target;

    setorigin (self, targ.origin - self.mins);
    if (!self.targetname)
    {   // Not triggered, so start immediately.
        self.nextthink = self.ltime + 0.1;
        self.think = train_next;
    }
};

//============
// Zerstorer stuff
//void() train_teleporter =
//{
//    local   string  otarg;
//    local   float   otime;
//
//    otarg = self.target;
//    otime = self.nextthink;
//    self.target = self.netname;
//    self.nextthink = time + 10000;
//    teleport_touch ();
//    self.target = otarg;
//    self.nextthink = otime;
//};

//============
// --> QUAKED func_train (0 .5 .8) ?
// Trains are moving platforms that players can ride.
// The targets origin specifies the min point of the train at each corner.
// The train spawns at the first target it is pointing at.
// If the train is the target of a button or trigger, it will not begin
// moving until activated.
// speed    (default 100)
// dmg      (default 2)
// sounds
// 1) ratchet metal
//============
void() func_train =
{
// DISABLED -- Debugging tool to find map trains and their wait times.
// Written to find possible conflicts resulting from train code merger.
//    dprint(" > train wait: "); dprint(ftos(self.wait));
//    if (self.wait < 0)
//        dprint(" NEGATIVE!");   // Oops!
//    dprint("\n");
//- - - - - - - - -
    if (!self.speed)
        self.speed = 100;
    if (!self.target)
        objerror ("func_train without a target");
    if (!self.dmg)
        self.dmg = 2;

    if (!self.noise)
    {
        if (self.sounds == 1)
            self.noise  = "plats/train2.wav";
    // Extra sounds used in Zerstorer.  (Door sounds.)
        else if (self.sounds == 2)
        {   if (oum)
                self.noise  = "misc/b_rot2.wav";
            else
                self.noise  = "doors/drclos4.wav";
        }
        else if (self.sounds == 3)
            self.noise  = "doors/hydro2.wav";
        else if (self.sounds == 4)
            self.noise  = "doors/stndr2.wav";
        else if (self.sounds == 5)
            self.noise  = "doors/ddoor2.wav";
        else    // Assume 0.
            self.noise  = "misc/null.wav";
    //- - - - - - - - -
    }
    if (!self.noise1)
    {
        if (self.sounds == 1)
            self.noise1 = "plats/train1.wav";
    // Extra sounds used in Zerstorer.
        else if (self.sounds == 2)
        {   if (oum)
                self.noise1 = "misc/liftloop.wav";
            else
                self.noise1 = "doors/doormv1.wav";
        }
        else if (self.sounds == 3)
            self.noise1 = "doors/hydro1.wav";
        else if (self.sounds == 4)
            self.noise1 = "doors/stndr1.wav";
        else if (self.sounds == 5)
            self.noise1 = "doors/ddoor1.wav";
        else    // Assume 0.
            self.noise1  = "misc/null.wav";
    //- - - - - - - - -
    }
    precache_sound (self.noise);
    precache_sound (self.noise1);

    self.cnt        = 1;
    self.solid      = SOLID_BSP;
    self.movetype   = MOVETYPE_PUSH;
    self.blocked    = train_blocked;

    self.use        = train_use;
// Zerstorer -- Add self.touch so that a train can harm player when touched.
//              Add spawnflag 1 to make train hurt player when touched.
// NOTE:  Some of id's levels have unnecessary sf's that would break
// the trains if Zer's mods were applied unconditionally.  Therefore,
// do it only in Zer mode.
//    if (zerstorer)
//    {
//        if (self.spawnflags & 1)
//            {self.solid = SOLID_TRIGGER; self.touch = train_blocked;}
//        if (self.spawnflags & 2)
//            {self.solid = SOLID_TRIGGER; self.touch = train_teleporter;}
//    }
//    else
        self.classname  = "train";

    setmodel (self, self.model);
    setsize (self, self.mins, self.maxs);
    setorigin (self, self.origin);

// Start trains on the second frame, to make sure their targets have had
// a chance to spawn.
    self.nextthink  = self.ltime + 0.1;
    self.think      = func_train_find;
};

// Merged func_train and func_train2.
// Here to support func_train2 found in other maps.
void() func_train2 =
{
    func_train();
//    if (zerstorer)      // Resolve conflict from code merger.
//        self.spawnflags = self.spawnflags - (self.spawnflags & 3);
    self.classname = "train2";
};

//============
// --> QUAKED misc_teleporttrain (0 .5 .8) (-8 -8 -8) (8 8 8)
// This is used for the final boss
//============
void() misc_teleporttrain =
{    
    if (!self.speed)
        self.speed = 100;
    if (!self.target)
        objerror ("func_train without a target");

    self.cnt        = 1;
    self.solid      = SOLID_NOT;
    self.movetype   = MOVETYPE_PUSH;
    self.blocked    = train_blocked;
    self.use        = train_use;
    self.avelocity  = '100 200 300';

    self.noise      = self.noise1     = "misc/null.wav";
    precache_sound ("misc/null.wav");

// PM (Todo):  Use '.mdl' for trains that don't look like a crude spiked ball.
    cache_set ("progs/teleport.mdl");
    setsize (self, self.mins, self.maxs);
    setorigin (self, self.origin);

// Start trains on the second frame, to make sure their targets have had
// a chance to spawn.
    self.nextthink  = self.ltime + 0.1;
    self.think      = func_train_find;
};


//==========================================================================
//  SIMPLE BMODELS
//==========================================================================

//- - - - - - - - - - - - - - - - - - -
// DISABLED -- Hip's 'func_togglewall' does everything and more.
//============
// --> QUAKED func_invisible (0 .5 .8) ?
// This is an invisible wall.
//============
//void() func_invisible =
//{
//    self.angles     = '0 0 0';
//    self.movetype   = MOVETYPE_PUSH;  // So it doesn't get pushed by anything.
//    self.solid      = SOLID_BSP;
//    // Note:  Because the wall is invisible, alt textures is pointless.
//    setmodel (self, "");
//};
//- - - - - - - - - - - - - - - - - - -
void() func_togglewall;

// Change to alternate textures.
void() func_wall_use = {self.frame = 1 - self.frame;};

//============
// --> QUAKED func_wall (0 .5 .8) ?
// This is just a solid wall if not inhibitted
//============
void() func_wall =
{
    self.angles     = '0 0 0';
    self.movetype   = MOVETYPE_PUSH;  // So it doesn't get pushed by anything.
    self.solid      = SOLID_BSP;
    self.use        = func_wall_use;
    setmodel (self, self.model);
//- - - - - - - - - - - - - -
// Arcanum Hack:  Invisible walls.
// Note:  Don't use this method outside of Arcanum because it makes
// id's start episode gates invisible.
    if (self.spawnflags & 1)
        if (world.model == "maps/arcanum2.bsp")
            {self.model = "";  return;}
//- - - - - - - - - - - - - -
//- - - - - - - - -
// SoE Indian Summer Hack...
// PM:  Fix disappearing torch posts by spawning a static copy of func_wall.
// Without it, posts vanish anytime the player stands near '-144 -1952 z'.
// FIXME:  Disable or erase as soon as Tronyn or AguirRe fix nsoe4.
//         Update:  It probably won't ever get fixed, so leave it.
    if (world.model == "maps/nsoe4.bsp")
    {
        if (AddOne() == 4)  // It's the fourth func_wall entity spawned.
        {
            local   entity  hack;

            hack = spawn();
            setform (hack, self.model, self.mins, self.maxs);
            makestatic (hack);
            dprint ("Invoked pillar fix hack.\n");
        }
    }
//- - - - - - - - -
};

//============
// --> QUAKED func_illusionary (0 .5 .8) ?
// A simple entity that looks solid but lets you walk through it.
//============
void() func_illusionary =
{
    self.angles     = '0 0 0';
    self.movetype   = MOVETYPE_NONE;
    self.solid      = SOLID_NOT;
    setmodel (self, self.model);
    makestatic (self);
};

//============
// --> QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
// This bmodel will appear if the episode has already been completed,
// so players can't reenter it.
//============
void() func_episodegate =
{
    if (!(serverflags & self.spawnflags & 255))   // PM:  Check only 8 bits.
        return;            // Can still enter episode.

    func_wall ();
};

//============
// --> QUAKED func_bossgate (0 .5 .8) ?
// This bmodel appears unless players have all of the episode sigils.
//============
void() func_bossgate =
{
    if ((serverflags & 15) == 15)
        return;        // All episodes completed.

    func_wall ();
};


//===========================================================================
//
//  HIPNOTIC ADDITIONS
//
//===========================================================================

//--------------------
// hipcount.qc
//--------------------
// NOTE:  Replaced 'aflag' with 'lefty'.

float COUNTER_TOGGLE      = 1;
float COUNTER_LOOP        = 2;
float COUNTER_STEP        = 4;
float COUNTER_RESET       = 8;
float COUNTER_RANDOM      = 16;
float COUNTER_FINISHCOUNT = 32;
float COUNTER_START_ON    = 64;

void() counter_on_use;
void() counter_off_use;

void() counter_think =
{
    self.cnt = self.cnt + 1;
    if (self.spawnflags & COUNTER_RANDOM)
    {
        self.state = random() * self.count;
        self.state = floor(self.state) + 1;
    }
    else
    {
        self.state = self.cnt;
    }

    activator = other;
    SUB_UseTargets ();
    self.nextthink = time + self.wait;

    if (self.spawnflags & COUNTER_STEP)
        counter_on_use();

    if (self.cnt >= self.count)
    {
        self.cnt = 0;
        if ( self.lefty  ||  !(self.spawnflags & COUNTER_LOOP) )
        {
            if (self.spawnflags & COUNTER_TOGGLE)
                counter_on_use ();
            else
                remove (self);
        }
    }
};

void() counter_on_use =
{
    if (self.cnt != 0)
        if (self.spawnflags & COUNTER_FINISHCOUNT)
            {self.lefty = TRUE;  return;}

    self.use    = counter_off_use;
    self.think  = SUB_Null;
    self.lefty  = FALSE;
};

void() counter_off_use =
{
    self.lefty = FALSE;
    if (self.spawnflags & COUNTER_TOGGLE)
        self.use = counter_on_use;
    else
        self.use = SUB_Null;

    if (self.spawnflags & COUNTER_RESET)
        {self.cnt = 0; self.state = 0;}
    self.think = counter_think;
    if (self.delay)
        self.nextthink = time + self.delay;
    else
        counter_think ();
};

float(entity counter) counter_GetCount =
{
    if (counter.classname == "counter")
        return counter.state;
    return 0;
};

//============
// --> QUAKED func_counter (0 0 0.5) (0 0 0) (32 32 32) TOGGLE LOOP STEP RESET RANDOM FINISHCOUNT START_ON
// TOGGLE causes the counter to switch between an on and off state
// each time the counter is triggered.
//
// LOOP causes the counter to repeat infinitly.  The count resets to zero
// after reaching the value in "count".
//
// STEP causes the counter to only increment when triggered.  Effectively,
// this turns the counter into a relay with counting abilities.
//
// RESET causes the counter to reset to 0 when restarted.
//
// RANDOM causes the counter to generate random values in the range 1 to
// "count" at the specified interval.
//
// FINISHCOUNT causes the counter to continue counting until it reaches
// "count" before shutting down even after being set to an off state.
//
// START_ON causes the counter to be on when the level starts.
//
// "count" specifies how many times to repeat the event.  If LOOP is set,
// it specifies how high to count before reseting to zero.  Default is 10.
//
// "wait"  the length of time between each trigger event. Default is 1 second.
//
// "delay" how much time to wait before firing after being switched on.
//============
void() func_counter =
{
    if (!self.wait)
        self.wait = 1;

    self.count = floor(self.count);
    if (self.count <= 0)
        self.count  = 10;
    self.cnt    = 0;
    self.state  = 0;

    self.classname  = "counter";
    self.use        = counter_off_use;
    self.think      = SUB_Null;
    if (self.spawnflags & COUNTER_START_ON)
    {
        self.think = counter_off_use;
        self.nextthink = time + 0.1;
    }
};

void() oncount_use =
{
    if (counter_GetCount (other) == self.count)
    {
        activator = other;
        SUB_UseTargets();
    }
};

//============
// --> QUAKED func_oncount (0 0 0.5) (0 0 0) (16 16 16)
// Must be used as the target for func_counter.  When the counter
// reaches the value set by count, func_oncount triggers its targets.
//
// "count" specifies the value to trigger on.  Default is 1.
//
// "delay" how much time to wait before firing after being triggered.
//============
void() func_oncount =
{
    self.count = floor(self.count);
    if (self.count <= 0)
        self.count  = 1;

    self.classname  = "oncount";
    self.use        = oncount_use;
    self.think      = SUB_Null;
};

//--------------------
// hipwater.qc
//--------------------
void() bobbingwater_think =
{
    local   vector  ang;

    self.count = self.count + self.speed * (time - self.ltime);
    if (self.count > 360)
        self.count = self.count - 360;      // FIXME:  Use 'anglemod'?
    ang_x = self.count;
    ang_y = 0;
    ang_z = 0;
    makevectors (ang);
    self.origin_z = v_forward_z * self.cnt;
    setorigin (self, self.origin);
    self.ltime = time;
    self.nextthink = time + 0.02;
};

//============
// --> QUAKED func_bobbingwater (0 .5 .8) ?
// Used to emulate water.  To use, create a thin water brush and center it
// on the water line of the body of water to bob.  The amount of the bob
// is the depth of the brush.
//
// "speed" is how long in seconds it takes the brush to do one full bob.
//============
void() func_bobbingwater =
{
    self.angles = '0 0 0';
    self.movetype = MOVETYPE_STEP;
    self.solid = SOLID_NOT;
    setmodel (self,self.model);
    self.think = bobbingwater_think;

    self.count = 0;
    self.cnt = self.size_z / 2;
    if (!self.speed)
        self.speed = 4;

    self.speed = 360 / self.speed;

    self.nextthink = time + 0.02;
    self.ltime = time;
};


//--------------------
// hip_expl.qc
//
// Used by monster_armagon.
//--------------------

float USE_PARTICLES = 1;

//void() BecomeExplosion;
void() rubble_use;      // Used by SoE/Custents modifications.

void() exploder_fire =
{
    local   entity  temp;

    temp = self;
    activator = other;
    SUB_UseTargets ();
    self = temp;
    other = self;
    if (self.dmg < 120)
        sound (self, CHAN_AUTO, "misc/shortexp.wav", self.volume, self.speed);
    else
        sound (self, CHAN_AUTO, "misc/longexpl.wav", self.volume, self.speed);
    T_RadiusDamage (self, self.owner, self.dmg, other);
    if (self.spawnflags & USE_PARTICLES)
        Rocket_Explosion1 (self.origin);    //Tent_Point (TE_EXPLOSION, self.origin);
// SoE:  Legacy code from Custents, used by soe1m2, throw rubble.
    rubble_use ();
//- - - - - - - - -
    BecomeExplosion();
};

void() exploder_use =
{
    if (self.delay)
    {
        self.nextthink = time + self.delay;
        self.delay = 0;
        self.think = exploder_fire;
    }
    else
        exploder_fire();
};

//============
// --> QUAKED func_exploder (0.4 0 0) (0 0 0) (8 8 8) particles
//  Spawns an explosion when triggered.  Triggers any targets.
//
//  "dmg" specifies how much damage to cause.  Negative values
//  indicate no damage.  Default or 0 indicates 120.
//  "volume" volume at which to play explosions (default 1.0)
//  "speed" attenuation for explosions (default normal)
//============
void() func_exploder =
{
    precache_sound ("misc/shortexp.wav");
    precache_sound ("misc/longexpl.wav");
    self.classname = "exploder";
    self.use = exploder_use;
    if (self.dmg == 0)
       self.dmg = 120;
    if (self.dmg < 0)
       self.dmg = 0;
    if (self.speed == 0)
        self.speed = 1;
    if (self.volume == 0)
        self.volume = 1.0;
// SoE:  Legacy code from Custents, used by soe1m2.
//    if (self.count)
    {
        precache_model ("progs/rubble1.mdl");
        precache_model ("progs/rubble2.mdl");
        precache_model ("progs/rubble3.mdl");

        precache_sound ("misc/wallbrk.wav"); 
        precache_sound ("zombie/z_hit.wav");
        if (self.skin < 0)
            {self.skin = random()*14;  self.skin = floor(self.skin);}
    }
//- - - - - - - - -
};

void() multi_exploder_fire =
{
    local   entity  temp;
    local   entity  expl;

    self.nextthink = time + self.wait;
    if (self.state == 0)
    {
        self.state = 1;
        self.duration = time + self.duration;
        temp = self;
        activator = other;
        SUB_UseTargets ();
        self = temp;
        other = self;
    }
    if (time > self.duration)
    {
        remove (self);
        return;
    }

    expl = spawn();
    expl.owner = self.owner;
    expl.dmg = self.dmg;
    expl.origin_x = self.absmin_x + (random() * (self.absmax_x - self.absmin_x));
    expl.origin_y = self.absmin_y + (random() * (self.absmax_y - self.absmin_y));
    expl.origin_z = self.absmin_z + (random() * (self.absmax_z - self.absmin_z));
    sound (expl, CHAN_VOICE, "misc/shortexp.wav", self.volume, self.speed);
    T_RadiusDamage (expl, self.owner, self.dmg, other);
    if (self.spawnflags & USE_PARTICLES)
        Rocket_Explosion1 (expl.origin);    //Tent_Point (TE_EXPLOSION, expl.origin);
    temp = self;
    self = expl;
// SoE:  Legacy code from Custents.
    if (temp.count)
    {
        self.count  = temp.count;
        self.skin   = temp.skin;
        rubble_use ();
    }
//- - - - - - - - -
    BecomeExplosion ();
    self = temp;
};

void(vector loc, float rad, float damage, float dur, float pause, float vol)
    multi_explosion =
{
    local   entity  temp;

    temp = self;

    self = spawn();
    self.origin     = loc;
    self.dmg        = damage;
    self.duration   = dur;
    self.wait       = pause;
    self.owner      = world;
    self.absmin     = self.origin - (rad * '1 1 1');
    self.absmax     = self.origin + (rad * '1 1 1');
    self.think      = multi_exploder_fire;
    self.volume     = vol;
    multi_exploder_fire ();

    self = temp;
};

void() multi_exploder_use =
{
    if (self.delay)
    {
        self.nextthink = time + self.delay;
        self.delay = 0;
        self.think = multi_exploder_fire;
    }
    else
    {
        self.think = multi_exploder_fire;
        multi_exploder_fire();
    }
};

//============
// --> QUAKED func_multi_exploder (0.4 0 0) ?
//  Spawns an explosion when triggered.  Triggers any targets.
//  size of brush determines where explosions will occur.
//
//  "dmg" specifies how much damage to cause from each explosion
//  Negative values indicate no damage.  Default or 0 indicates 120.
//  "delay" delay before exploding (Default 0 seconds)
//  "duration" how long to explode for (Default 1 second)
//  "wait" time between each explosion (default 0.25 seconds)
//  "volume" volume to play explosion sound at (default 0.5)
//  "speed" attenuation for explosions (default normal)
//============
void() func_multi_exploder =
{
    precache_sound ("misc/shortexp.wav");
    precache_sound ("misc/longexpl.wav");
    self.classname = "exploder";
    self.use = multi_exploder_use;
    setmodel (self,self.model);
    self.movetype = MOVETYPE_NONE;
    self.modelindex = 0;
    self.model = "";
    if (self.dmg == 0)
       self.dmg = 120;
    if (self.dmg < 0)
       self.dmg = 0;
    if (self.duration == 0)
        self.duration = 1.0;
    if (self.speed == 0)
        self.speed = 1.0;
    if (self.volume == 0)
        self.volume = 0.5;
    if (self.wait == 0)
        self.wait = 0.25;
    self.state = 0;
// SoE:  Legacy code from Custents, used by soe1m2.
//    if (self.count)
    {
        precache_model ("progs/rubble1.mdl");
        precache_model ("progs/rubble2.mdl");
        precache_model ("progs/rubble3.mdl");

        precache_sound ("misc/wallbrk.wav"); 
        precache_sound ("zombie/z_hit.wav");
        if (self.skin < 0)
            {self.skin = random()*14;  self.skin = floor(self.skin);}
    }
//- - - - - - - - -
};


//--------------------
// hip_part.qc
//--------------------
// 'color' field moved to 'defs.qc', and changed to vector type
// to avoid conflict with dpextensions.qc for the DarkPlaces progs.

//float START_OFF = 1;
float USE_COUNT = 1;

void() particlefield_XZ =
{
    local   vector  pos;
    local   vector  start;
    local   vector  end;

    if (self.spawnflags & USE_COUNT)
        if (counter_GetCount (other) != self.cnt)
            return;
//    dprint("XZ\n");

    self.ltime = time + 0.25;
    if (self.noise)
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    // Only show particles if client is visible.
    // This helps to keep network traffic down to a minimum.
    if (!checkclient ())
        return;

    start = self.dest1 + self.origin;
    end   = self.dest2 + self.origin;
    pos_y = start_y;
    pos_z = start_z;
    while (pos_z <= end_z)
    {
        pos_x = start_x;
        while (pos_x <= end_x)
        {
            particle (pos, '0 0 0', self.color_x, self.count);
            pos_x = pos_x + 16;
        }
        pos_z = pos_z + 16;
    }
};

void() particlefield_YZ =
{
    local   vector  pos;
    local   vector  start;
    local   vector  end;

    if (self.spawnflags & USE_COUNT)
        if (counter_GetCount (other) != self.cnt)
            return;

//    dprint("YZ: ");
//    dprint(vtos(self.dest1)); dprint(" - ");
//    dprint(vtos(self.dest2)); dprint("\n");
    self.ltime = time + 0.25;
    if (self.noise)
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    // Only show particles if client is visible.
    // This helps to keep network traffic down to a minimum.
    if (!checkclient ())
        return;

    start = self.dest1 + self.origin;
    end   = self.dest2 + self.origin;
    pos_x = start_x;
    pos_z = start_z;
    while (pos_z < end_z)
    {
        pos_y = start_y;
        while (pos_y < end_y)
        {
            particle (pos, '0 0 0', self.color_x, self.count);
            pos_y = pos_y + 16;
        }
        pos_z = pos_z + 16;
    }
};

void() particlefield_XY =
{
    local   vector  pos;
    local   vector  start;
    local   vector  end;

    if (self.spawnflags & USE_COUNT)
        if (counter_GetCount(other) != self.cnt)
            return;

//    dprint("XY\n");
    self.ltime = time + 0.25;
    if (self.noise)
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    // Only show particles if client is visible.
    // This helps to keep network traffic down to a minimum.
    if (!checkclient ())
        return;

    start = self.dest1 + self.origin;
    end   = self.dest2 + self.origin;
    pos_x = start_x;
    pos_z = start_z;
    while (pos_x < end_x)
    {
        pos_y = start_y;
        while (pos_y < end_y)
        {
            particle (pos, '0 0 0', self.color_x, self.count);
            pos_y = pos_y + 16;
        }
        pos_x = pos_x + 16;
    }
};

void() particlefield_touch =
{
    if (!self.dmg)
        return;

    if (time > self.ltime)
        return;

    if (time < self.attack_finished)
        return;
    self.attack_finished = time + 0.5;
    T_Damage (other, self, self, self.dmg);
};

//============
// --> QUAKED func_particlefield (0 .5 .8) ? USE_COUNT
// Creates a brief particle flash roughly the size of the defining
// brush each time it is triggered.
//
// USE_COUNT when the activator is a func_counter, the field will only
//    activate when count is equal to "cnt".  Same as using a func_oncount
//    to trigger.
//
// "cnt" is the count to activate on when USE_COUNT is set.
// "color" is the color of the particles.  Default is 192 (yellow).
// "count" is the density of the particles.  Default is 2.
// "noise" is the sound to play when triggered.  Do not use a looping sound
//    here.
// "dmg" is the amount of damage to cause when touched.
//============
void() func_particlefield =
{
    if (!self.color_x)
    {   self.color = self.color;    // Appease FTEqcc.
        self.color_x = 192;
    }
    if ( self.count == 0 )
        self.count = 2;

    self.classname  = "particlefield";
    self.solid      = SOLID_NOT;
    self.movetype   = MOVETYPE_NONE;
    setmodel (self, self.model);
    self.model      = world.null_string;

    self.origin = (self.mins + self.maxs) * 0.5;
    setorigin (self, self.origin);
    self.dest   = self.maxs - self.mins - '16 16 16';
    self.dest1  = self.mins + '8 8 8' - self.origin;
    self.dest2  = self.maxs + '7.9 7.9 7.9' - self.origin;
    setsize (self, self.mins, self.maxs);
    self.touch  = particlefield_touch;
//    dprint(vtos(self.dest)); dprint("  ");
    if ( self.dest_x > self.dest_z )
    {
        if ( self.dest_y > self.dest_z )
        {
//            dprint("XY1 - "); dprint(ftos(self.cnt)); dprint("\n");
            self.use = particlefield_XY;
            self.dest1_z = ( self.dest1_z + self.dest2_z ) / 2;
            }
        else
        {
//            dprint("XZ1 - "); dprint(ftos(self.cnt)); dprint("\n");
            self.use = particlefield_XZ;
            self.dest1_y = ( self.dest1_y + self.dest2_y ) / 2;
        }
    }
    else
    {
        if ( self.dest_y > self.dest_x )
        {
//            dprint("YZ2 - "); dprint(ftos(self.cnt)); dprint("\n");
            self.use = particlefield_YZ;
            self.dest1_x = ( self.dest1_x + self.dest2_x ) / 2;
        }
        else
        {
//            dprint("XZ2 - "); dprint(ftos(self.cnt)); dprint("\n");
            self.use = particlefield_XZ;
            self.dest1_y = ( self.dest1_y + self.dest2_y ) / 2;
        }
    }

    if (self.noise)
        precache_sound (self.noise);
    self.ltime = time;
};

void() blocker_touch =
{
    if (!self.dmg)
        return;

    if (time < self.attack_finished)
        return;
    self.attack_finished = time + 0.5;
    T_Damage (other, self, self, self.dmg);
};

void() blocker_use =
{
    if (self.state)
    {
        self.state = 0;
        setorigin (self, self.origin + '8000 8000 8000');
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
    }
    else
    { 
        self.state = 1;
        setorigin (self, self.origin - '8000 8000 8000');
        sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
    }
};

// PM:  Below in the rest of hip_part.qc is invisible wall stuff.
//============
// --> QUAKED func_togglewall (0 .5 .8) ? START_OFF
// Creates a invisible wall that can be toggled on and off.
//
// START_OFF wall doesn't block until triggered.
//
// "noise" is the sound to play when wall is turned off.
// "noise1" is the sound to play when wall is blocking.
// "dmg" is the amount of damage to cause when touched.
//============
void() func_togglewall =
{
    self.classname  = "togglewall";
    self.movetype   = MOVETYPE_PUSH;
    self.mdl        = self.model;
    setmodel (self, self.model);
    setsize (self, self.mins, self.maxs);
    setorigin (self, self.origin);
    self.touch      = blocker_touch;
    self.use        = blocker_use;

    if (!self.noise)
        self.noise      = ("misc/null.wav");
    if (!self.noise1)
        self.noise1     = ("misc/null.wav");

    precache_sound (self.noise);
    precache_sound (self.noise1);

    self.solid      = SOLID_BSP;
    self.model      = world.null_string;
    if (self.spawnflags & START_OFF)
        {self.state = 0; setorigin (self, self.origin + '8000 8000 8000');}
    else
        {self.state = 1; sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);}
};
//- - - - - - - - - - - - - - - - - - -


//--------------------
// hip_push.qc
//--------------------

void() push_use =
{
    local   vector  delta;
    local   float   x, y;

//    makevectors(other.angles);
    
//    x = fabs( v_forward_x );
//    y = fabs( v_forward_y );
    x = fabs(other.velocity_x);
    y = fabs(other.velocity_y);

//    dprint(ftos(x)); dprint(", " ); dprint(ftos(y));
    if (x > y)
    {
//        dprint( " x move\n\n\n\n" );
        if (other.velocity_x > 0)
            walkmove (0, 16 * frametime);
        else
            walkmove (180, 16 * frametime);
    }
    else
    {
//        dprint( " y move\n\n\n\n" );
        if (other.velocity_y > 0)
            walkmove (90, 16 * frametime);
        else
            walkmove (270, 16 * frametime);
    }
    
    delta = self.origin - self.oldorigin;
    setorigin (self.owner, self.owner.oldorigin + delta);
};

//============
// --> QUAKED func_pushable (0 .5 .8) ?
// Pushable walls.
//============
void() func_pushable =
{
    local   entity  new;
    local   vector  newsize;

    self.mangle = self.angles;
    self.angles = '0 0 0';

    self.classname  = "pushablewall";
    self.solid      = SOLID_BSP;
    self.movetype   = MOVETYPE_PUSH;
    setmodel (self, self.model);
    setorigin(self, self.origin);
    setsize (self, self.mins, self.maxs);
    self.oldorigin  = self.origin;

    new = spawn();
    new.owner   = self;
    new.mangle  = self.mangle;
    new.angles  = self.angles;

    new.classname   = "pushablewallproxy";
    new.solid       = SOLID_BBOX;
    new.movetype    = MOVETYPE_STEP;
    new.origin      = (self.mins + self.maxs) * 0.5 + '0 0 1';
    newsize = (self.maxs - self.mins) * 0.5;
    new.mins        = '-1 -1 0' - newsize;
    new.maxs        = '1 1 -2' + newsize;
    setsize (new, new.mins, new.maxs);
    setorigin (new, new.origin);
    new.oldorigin   = new.origin;
    new.touch       = push_use;
};


//--------------------
// hiprubbl.qc
//--------------------
// NOTE:  Replaced 'pausetime' with 'delay'.

void() hipRubbleTouch =
{
    if (self.ltime < self.delay)
        return;
       
    if (other.takedamage)
    {
        T_Damage (other, self, self.owner, 10);
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        self.delay = self.ltime + 0.1;
    }
};

void(string rubblename) hipThrowRubble =
{
    local   entity  new;
    
    new = spawn();
    new.origin = self.origin;
    setmodel (new, rubblename);
    setsize (new, '0 0 0', '0 0 0');
    new.velocity_x  = 70 * crandom();
    new.velocity_y  = 70 * crandom();
    new.velocity_z  = 140 + 70 * random();
    new.movetype    = MOVETYPE_BOUNCE;
    new.solid       = SOLID_BBOX;
    new.avelocity_x = random()*600;
    new.avelocity_y = random()*600;
    new.avelocity_z = random()*600;
    new.think       = SUB_Remove;
    new.touch       = hipRubbleTouch;
    new.ltime       = time;
    new.nextthink   = time + 13 + random()*10;
    self.delay      = time;
    new.frame       = 0;
    new.flags       = 0;
// SoE:  Extra stuff from older SoE progs.
    new.classname   = "rubble";
    // Colored rubble from Custents, so the old comments say.
    if (self.skin < 0)
        {new.skin = random()*14;  new.skin = floor(new.skin);}
    else
        new.skin = self.skin;
};

void() rubble_use =
{
    local   float   which;
    local   float   index;
    
    index = 0;

// SoE/OUM:  Make rubbly noise.
    sound (self, CHAN_AUTO, "misc/wallbrk.wav", 1, ATTN_NORM);
//- - - - - - - - -
    do 
    {
        which = self.cnt;
        if (self.cnt == 0)
            {which = 1 + 3*random();  which = floor(which);}

        if (which == 1)
            hipThrowRubble ("progs/rubble1.mdl");
        else if (which == 2)
            hipThrowRubble ("progs/rubble3.mdl");
        else
            hipThrowRubble ("progs/rubble2.mdl");
        index = index + 1;
    }
    while (index < self.count);
};

//============
// --> QUAKED func_rubble (0.4 0.4 0.2) (0 0 0) (32 32 32)
// Spawns random sized rubble when triggered.  
//  
// "count" is the number of pieces of rubble to spawn.  Default is 1.
//============
void() func_rubble =
{
    precache_model ("progs/rubble1.mdl");
    precache_model ("progs/rubble2.mdl");
    precache_model ("progs/rubble3.mdl");
    precache_sound ("zombie/z_hit.wav");
    precache_sound ("misc/wallbrk.wav");    // PM:  Used by SoE.
    self.classname = "rubble";
    self.cnt = 0;
    self.use = rubble_use;
};
    
//============
// --> QUAKED func_rubble1 (0.4 0.4 0.2) (0 0 0) (8 8 8)
// Spawns small rubble when triggered.  
//  
// "count" is the number of pieces of rubble to spawn.  Default is 1.
//============
void() func_rubble1 =
{
    precache_model ("progs/rubble1.mdl");
    precache_sound ("zombie/z_hit.wav");
    precache_sound ("misc/wallbrk.wav");    // PM:  Used by SoE.
    self.classname = "rubble1";
    self.cnt = 1;
    self.use = rubble_use;
};
    
//============
// --> QUAKED func_rubble2 (0.4 0.4 0.2) (0 0 0) (16 16 16)
// Spawns medium rubble when triggered.  
//  
// "count" is the number of pieces of rubble to spawn.  Default is 1.
//============
void() func_rubble2 =
{
    precache_model ("progs/rubble2.mdl");   // rubble3?
    precache_sound ("zombie/z_hit.wav");
    precache_sound ("misc/wallbrk.wav");    // PM:  Used by SoE.
    self.classname = "rubble2";
    self.cnt = 2;
    self.use = rubble_use;
};
    
//============
// --> QUAKED func_rubble3 (0.4 0.4 0.2) (0 0 0) (32 32 32)
// Spawns large rubble when triggered.  
//
// "count" is the number of pieces of rubble to spawn.  Default is 1.
//============
void() func_rubble3 =
{
    precache_model ("progs/rubble3.mdl");   // rubble2?
    precache_sound ("zombie/z_hit.wav");
    precache_sound ("misc/wallbrk.wav");    // PM:  Used by SoE.
    self.classname = "rubble3";
    self.cnt = 3;
    self.use = rubble_use;
};


//===========================/  END OF FILE  /===========================//
