//================
// QuakeEd only writes a single float for angles (bad idea), so up and down
// are just constant angles.
//================
void() SetMovedir =
{
    if (self.angles == '0 -1 0')
        self.movedir = '0 0 1';
    else if (self.angles == '0 -2 0')
        self.movedir = '0 0 -1';
    else
    {
        makevectors (self.angles);
        self.movedir = v_forward;
    }
    
    self.angles = '0 0 0';
};

//================
// InitTrigger
//================
void() InitTrigger =
{
// Trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
    if (self.angles != '0 0 0')
        SetMovedir ();
    self.solid      = SOLID_TRIGGER;
    setmodel (self, self.model);    // set size and link into world
    self.movetype   = MOVETYPE_NONE;
    self.modelindex = 0;
    self.model      = "";
};

// PM:  The point trigger version of InitTrigger.
void() InitPointTrigger =
{
    local   vector  v1, v2;

    v1 = self.origin;
    v2 = v1 + self.mangle;
    self.model = "";
    setorigin (self, '0 0 0');
    InitTrigger ();     // Calls 'setmodel', so do first.
    setsize (self, v1, v2);     // Calling 'setmodel' resets entity size.
};


//==========================================================================

float    SPAWNFLAG_NOMESSAGE = 1;
float    SPAWNFLAG_NOTOUCH = 1;
float    SPAWNFLAG_TRIGGERED = 2;   // Zerstorer -- must be triggered.


void() trigger_reactivate = {self.solid = SOLID_TRIGGER;};

//=============================================================================

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
//- - - - - - - - - - - - - - - - - - -
// The wait time has passed, so set back up for another activation
void() multi_wait =
{
    if (self.max_health)
    {
        self.health     = self.max_health;
        self.takedamage = DAMAGE_YES;
        self.solid      = SOLID_BBOX;
    }
};

// The trigger was just touched/killed/used. "self.enemy" should be set to
// the "activator" so it can be held through a delay so wait for the delay
// time before firing
void() multi_trigger =
{
    if (self.nextthink > time)
        return;     // Already triggered.

    if (self.classname == "trigger_secret")
    {
        if (self.enemy.classname != "player")
            return;
        if (cutscene)
            return;     // Don't activate in cutscene mode
        found_secrets = found_secrets + 1;
        WriteByte (MSG_ALL, SVC_FOUNDSECRET);
    }

    if (self.noise)
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

    self.takedamage = DAMAGE_NO;    // Don't trigger again until reset.
    activator = self.enemy;
    SUB_UseTargets ();

    if (self.wait > 0)
    {
        self.think = multi_wait;
        self.nextthink = time + self.wait;
    }
    else
    {   // We can't just remove (self) here, because this is a touch function
        // called while C code is looping through area links...
        self.touch      = SUB_Null;
        self.nextthink  = time + 0.1;
        self.think      = SUB_Remove;
    }
// Hipnotic's cnt stuff - - - - - - - -
    HipCntDown ();
//- - - - - - - - - - - - - - - - - - -
};

void() multi_killed = {self.enemy = damage_attacker; multi_trigger ();};

void() multi_use =
{
// Zerstorer -- if it hasn't been triggered yet, set it as being triggered.
    if (self.spawnflags & SPAWNFLAG_TRIGGERED)
        if (self.zerc)
            {self.zerc = 0; return;}

    self.enemy = activator;
    multi_trigger ();
};

void() multi_touch =
{
    if (other.classname != "player")
        if (other.classname != "actor")     // Zerstorer's cutscene drone.
            return;

// Zerstorer -- if it hasn't been triggered yet, set it as being triggered.
    if (self.spawnflags & SPAWNFLAG_TRIGGERED)
        if (self.zerc)
            return;

// if the trigger has an angles field, check player's facing direction
    if (self.movedir != '0 0 0')
    {
        makevectors (other.angles);
        if (v_forward * self.movedir < 0)
            return;        // not facing the right way
    }

    self.enemy = other;
    multi_trigger ();
};

//============
// --> QUAKED trigger_multiple (.5 .5 .5) ? notouch
// Variable sized repeatable trigger.  Must be targeted at one or more
// entities.  If "health" is set, the trigger must be killed to activate each
// time.  If "delay" is set, the trigger waits some time after activating
// before firing.
//
// "wait" : Seconds between triggerings. (.2 default)
// If notouch is set, the trigger is only fired by other entities, not by
// touching.
// NOTOUCH has been obsoleted by trigger_relay!
//
// "sounds"
// 1) secret
// 2) beep beep
// 3) large switch
// 4)
//
// set "message" to text string
//============
void(float pt) trigger_multiple_spawn =
{
    if (self.sounds == 1)
    {
        if (soul_evil)
            self.noise = "misc/secret2.wav";
        else
            self.noise = "misc/secret.wav";
    }
    else if (self.sounds == 2)
        self.noise = "misc/talk.wav";
    else if (self.sounds == 3)
        self.noise = "misc/trigger1.wav";

    if (self.noise)
        precache_sound (self.noise);
    
    if (!self.wait)
        self.wait = 0.2;
    self.use = multi_use;

    if (pt)
        InitPointTrigger ();
    else
        InitTrigger ();

    if (self.health)
    {
        if (self.spawnflags & SPAWNFLAG_NOTOUCH)
            objerror ("health and notouch don't make sense\n");
        self.max_health = self.health;
        self.th_die     = multi_killed;
        self.takedamage = DAMAGE_YES;
        self.solid      = SOLID_BBOX;
        self.bloodtype  = BLOOD_RED + 1;
        setorigin (self, self.origin);  // Make sure it links into the world
    }
    else if (!(self.spawnflags & SPAWNFLAG_NOTOUCH))
    {
        self.touch = multi_touch;
    }
// Hipnotic's cnt stuff - - - - - - - -
    if (!self.cnt)
        self.cnt = -1;
//- - - - - - - - - - - - - - - - - - -
// Zerstorer cnt stuff (can't use cnt, so zerc was defined for this purpose.)
    if (self.spawnflags & SPAWNFLAG_TRIGGERED)
        self.zerc = 1;
};
void() trigger_multiple = {trigger_multiple_spawn (FALSE);};
void() trigger_multiple_point = {trigger_multiple_spawn (TRUE);};


//============
// --> QUAKED trigger_once (.5 .5 .5) ? notouch
// Variable sized trigger. Triggers once, then removes itself.  You must set
// the key "target" to the name of another object in the level that has a
// matching "targetname".  If "health" is set, the trigger must be killed to
// activate.  If notouch is set, the trigger is only fired by other entities,
// not by touching.  If "killtarget" is set, any objects that have a matching
// "target" will be removed when the trigger is fired.  If "angle" is set,
// the trigger will only fire when someone is facing the direction of the
// angle.  Use "360" for an angle of 0.
//
// sounds
// 1) secret
// 2) beep beep
// 3) large switch
// 4)
// set "message" to text string
//============
void() trigger_once = {self.wait = -1; trigger_multiple_spawn (FALSE);};
void() trigger_once_point = {self.wait = -1; trigger_multiple_spawn (TRUE);};

//============
// --> QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
// This fixed size trigger cannot be touched, it can only be fired by other
// events.  It can contain killtargets, targets, delays, and messages.
//============
void() trigger_relay = {self.use = SUB_UseTargets;};

//============
// --> QUAKED trigger_secret (.5 .5 .5) ?
// secret counter trigger
// sounds
// 1) secret
// 2) beep beep
// 3)
// 4)
// set "message" to text string
//============
void(float pt) trigger_secret_spawn =
{
    total_secrets = total_secrets + 1;
    self.wait = -1;
    if (!self.message)
        self.message = "You found a secret area!";
    if (!self.sounds)
        self.sounds = 1;
    
    trigger_multiple_spawn (pt);    // This will precache and set the sound.
};
void() trigger_secret = {trigger_secret_spawn (FALSE);};
void() trigger_secret_point = {trigger_secret_spawn (TRUE);};


//============
void() counter_use =
{
    self.count = self.count - 1;
    if (self.count < 0)
        return;

    if (activator.classname == "player")
        if ((self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
        {
            if (self.count >= 4)
                centerprint (activator, "There are more to go...");
            else if (self.count == 3)
                centerprint (activator, "Only 3 more to go...");
            else if (self.count == 2)
                centerprint (activator, "Only 2 more to go...");
            else if (self.count == 1)
                centerprint (activator, "Only 1 more to go...");
            else
                centerprint (activator, "Sequence completed!");
        }

    if (self.count != 0)
        return;
    self.enemy = activator;
    multi_trigger ();
};

//============
// --> QUAKED trigger_counter (.5 .5 .5) ? nomessage
// Acts as an intermediary for an action that takes multiple inputs.
//
// If nomessage is not set, t will print "1 more.. " etc when triggered and
// "sequence complete" when finished.
//
// After the counter has been triggered "count" times (default 2), it will
// fire all of it's targets and remove itself.
//============
void() trigger_counter =
{
    self.wait = -1;
    if (!self.count)
        self.count = 2;

    self.use = counter_use;
};

//============
// --> QUAKED trigger_victory (.5 .5 .5) (-8 -8 -8) (8 8 8)
// Drake entity.
// This fixed size trigger cannot be touched, it can only be fired by
// killing the last monster on a level (i.e., 100% kills).
//
// It can contain killtargets, targets, delays, and messages.
//============
void() trigger_victory = {};


//==========================================================================
//  TELEPORT TRIGGERS
//==========================================================================

float    PLAYER_ONLY    = 1;
float    SILENT         = 2;
// Zerstorer spawnflags below (sans tele_dd).  Used by Drake.
float    RANDOM         = 4;
float    TELE_STEALTH   = 8;
//float    TELE_MISSILE   = 16;   // Teleport missiles ala DukeNukem3D.
float    TELE_GLITTER   = 32;   // Adds teleglitter like in Heretic.
                                // Don't use 16 or lower because of conflict.

void() play_teleport =
{
    local   float   v;
    local   string  text;

    v = random() * 5;
    if (v < 1)
        text = "misc/r_tele1.wav";
    else if (v < 2)
        text = "misc/r_tele2.wav";
    else if (v < 3)
        text = "misc/r_tele3.wav";
    else if (v < 4)
        text = "misc/r_tele4.wav";
    else
        text = "misc/r_tele5.wav";

    sound (self, CHAN_VOICE, text, 1, ATTN_NORM);
    remove (self);
};

void(vector org) spawn_tfog =
{
    local   entity  s;

    s = spawn ();
    s.origin    = org;
    s.nextthink = time + 0.2;
    s.think     = play_teleport;

    Tent_Point (TE_TELEPORT, org);
};

//---------------
// Update 7/24/09:  Use lavasplash for really big things.
void(entity ent) summon_tfog =
{
// FIXME:  Use a flag as ent.xxx to check.
    if (ent.maxs_x > 96)
    {   // Hack for oldone/wyrm.
        Tent_Point (TE_LAVASPLASH, ent.origin - '0 0 24');
        sound (ent, CHAN_VOICE, "boss1/out1.wav", 1, ATTN_NORM);
    }
    else
    {
        makevectors (ent.angles);
        spawn_tfog (ent.origin + v_forward*16);     // Was 'ent.origin' only.
    }
};

//---------------
void(entity ent, string dtype) tele_kill =
{
    if (!ent.takedamage)
    {
        if (!(ent.xfl & XFL_SHIELDS))
            return;
        ent.takedamage = DAMAGE_AIM;  // Bypass shields, bye mega enforcer.
    }
// Kill it!
    if (ent.takedamage)
        T_Kill (ent, self, self, -99, dtype);
};
float(entity ent) tele_rank =
{
    // Lower numbers are better.
    if (ent.classname == "player")
        return 1;
    if (ent.flags & FL_MONSTER)
    {
        if (ent.xfl & XFL_BOSS)     // SoE: BBEGs trump all but players.
            return 2;
        return 3;   // All other monsters regardless of alignment.
    }
    return 4;
};
float(entity ent) tele_shield =
{
    if (ent.invincible_finished)    // Invulnerability
        return TRUE;
    if (ent.xfl & XFL_SHIELDS)      // Mega-enforcer style shields
        return TRUE;

    return FALSE;
};
//---------------
// In Quake2 (and probably the older Doom games), invulnerability was trumped
// by the almighty telefrag.  Not so in Quake1, and I like it that way.
//
// --- Modified telefrag contest rules: ---
// The side who wins depends on two things:  shielding and rank.
//
// If both sides have shielding, the side with the better rank wins.
// If both sides have shielding and the same rank, then both sides lose,
// and a double telefrag occurs.  (Shields overload and crush their owners.)
//
// If one side has shielding, but the other does not, then the side with
// shielding always wins regardless of rank.
//
// If neither side has shielding, the side with the better rank wins.
// If both sides also have the same rank, then the tie (and win) goes
// to the attacker, and the defender is telefragged.
//---------------
void() tdeath_touch =
{
    if (other == self.owner)
        return;     // Don't telefrag the owner.

    local   entity  defender, attacker;
    local   float   prot_atk, prot_def;
    local   float   rank_atk, rank_def;

    attacker = self.owner;
    defender = other;

// Update 1/3/10:  Doom cube hack.
// If spawned from a cube, telefrag anyone who isn't the boss, even players.
    if (self.xsf & XSF_CUBE_SPAWN)
        if (!(defender.xfl & XFL_BOSS))
            tele_kill (defender, self.classname);
//- - - - - - - - -

    prot_atk = tele_shield (attacker);
    prot_def = tele_shield (defender);
    rank_atk = tele_rank (attacker);
    rank_def = tele_rank (defender);
// Update 8/20/10:  Dmsp boss protection.
// FIXME:  Only when spawning the first time, not after teleporting too.
    if (dmsp)
        if (attacker.targetname == "dmsp_boss")
            if (defender.flags & FLx_CREATURE)
                if (!(defender.xfl & XFL_BOSS))
                    rank_def = rank_atk + 1;
//- - - - - - - - -

    if ((prot_atk && prot_def) && (rank_atk && rank_def))
    {   // Double telefrag if both have shielding and the same rank.
        tele_kill (defender, "td_double");
        tele_kill (attacker, "td_double");
    }
    else if (prot_def)  // Reflect telefrag back at the attacker if true.
    {
        if (defender.invincible_finished)
            tele_kill (attacker, "td_reflect");
        else
            tele_kill (attacker, "td_reflect_me");
    }
    else if (prot_atk || (rank_def >= rank_atk))
        tele_kill (defender, self.classname);
    else
        tele_kill (attacker, self.classname);
};

void(vector org, entity death_owner) spawn_tdeath =
{
    local   entity  death;

    death = spawn();
    death.classname = "teledeath";
    death.movetype  = MOVETYPE_NONE;
    death.solid     = SOLID_TRIGGER;
    death.angles    = '0 0 0';
    setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
    setorigin (death, org);
    death.touch     = tdeath_touch;
    death.nextthink = time + 0.2;
    death.think     = SUB_Remove;
    death.owner     = death_owner;
// Update 1/3/10:  Doom cube hack.
    death.xsf       = death_owner.xsf & XSF_CUBE_SPAWN;     // Cube hack.
//- - - - - - - - -
    
    force_retouch = 2;      // Make sure even still objects get hit.
};

//- - - - - - - - -
// PM:  Zerstorer stuff.
//-----------------------------------------------//
//| teleport_randomspot - returns a random spot |//
//|   to teleport to among all of the           |//
//|   "info_teleport_random" entities in the    |//
//|   level.                                    |//
//-----------------------------------------------//
entity() teleport_randomspot =
{
    local   float   rndm;
    local   entity  spot, first;

    first = find(world, classname, "info_teleport_random");
    if (!first)
        return world;   // No spots available.
    spot = first;

    rndm = random() * randomspots;
    rndm = ceil(rndm);
    while (rndm > 0)
    {
        spot = find(spot, classname, "info_teleport_random");
        if (!spot)
            spot = first;
        rndm = rndm - 1;
    }
    return spot;
};
//- - - - - - - - -

float(float pc) teleport_check =
{
    if (pc)
        if (other.classname != "player")
            return FALSE;

// PM:  I'll leave this as is.  Considered teleport flag, but scrapped it.
// Note:  Wraiths cannot use touch/use teleporters because of their stats.
//    if (!(other.xfl & XFL_TELEPORT))
        if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
            return FALSE;     // Only teleport living creatures.

// PM:  Because successful teleportation creates an entity to play a sound,
// Repeated teleports within a frame can spawn excessive edicts and crash
// the game.  Therefore, when an entity uses a teleporter, don't let him
// use another for two frames.
    if (other.teleport_time > time + 0.5)   // T_time set to t + 0.7.
        return FALSE;

    return TRUE;
};

void(entity t, vector vang) teleport_set =
{
    makevectors (vang);
    if (!(self.spawnflags & TELE_STEALTH))  // Zerstorer:  No fx if stealth.
    {
    // put a tfog where the player was, and another in front of the
    // destination.
        spawn_tfog (other.origin);
        spawn_tfog (t.origin + 32 * v_forward);
    }
    spawn_tdeath (t.origin, other);

//- - - - - - - - -
// PM:  Setting oldorigin -- To do or not to do?  That is the question.
// If destination is occupied, and spawn_tdeath does not destroy whatever
// is there this frame, the player will bounce back to the source.
// Is this good or bad?  On the one hand, it stops the player from getting
// stuck if a moving platform occupies the destination, which is good.
// On the other hand, if the player kills a tarbaby or another ungibbable
// monster, such as Armagon, the player will bounce back, which sucks.
// Right now, I left oldorigin alone.
// Exception:  Leave oldorigin alone if noclip in on.
//- - - - - - - - -
//    if (other.movetype != MOVETYPE_NOCLIP)
//        other.oldorigin     = t.origin;

// move the player and lock him down for a little while
    setorigin (other, t.origin);
    other.angles        = vang;
    other.teleport_time = time + 0.7;
    if (other.classname == "player")
    {
        other.fixangle      = 1;    // Turn this way immediately
        // teleport_time done above for all.
        other.flags         = other.flags - (other.flags & FL_ONGROUND);
        other.velocity      = v_forward * 300;
        return;
    }
//- - - - - - - - - -
//    else if (IsMissile (other))
//    {
//        other.owner         = world;
//        other.movedir       = v_forward;
//        other.velocity      = other.dest    = v_forward * 1000; //vlen(self.velocity);
//    }
//- - - - - - - - - -
    other.flags = other.flags - (other.flags & FL_ONGROUND);
};

void() teleport_touch =
{
    if (self.targetname)
        if (self.nextthink < time)
            return;     // Not fired yet.

    if (!teleport_check (self.spawnflags & PLAYER_ONLY))
    {
        return;
//        if (!(self.spawnflags & TELE_MISSILE))
//            return;
//        if (!IsMissile (other))
//            return;
//        if (other.teleport_time > time + 0.5)   // T_time set to t + 0.7.
//            return;     // Too soon to re-teleport.
    }

// Now start the teleporting magic.
    local   entity  t;

    SUB_UseTargets ();

// Zerstorer support.
    if (self.spawnflags & RANDOM)
        t = teleport_randomspot ();
    else
        t = find (world, targetname, self.target);

    if (!t)
        objerror ("couldn't find target");

    teleport_set (t, t.mangle);
};

//- - - - - - - - - -
// Called by 'info_teleport_destination' and derivatives when spawned.
void() teleport_setup =
{
    self.mangle = self.angles;
    self.angles = '0 0 0';
    self.model  = "";
    self.origin = self.origin + '0 0 27';

// Glitter check.
    if (self.spawnflags & TELE_GLITTER)
        misc_glitter ();
};

//============
// --> QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
// This is the destination marker for a teleporter.  It should have a
// "targetname" field with the same value as a teleporter's "target" field.
//============
void() info_teleport_destination =
{
// This does nothing, just serves as a target spot.
    teleport_setup ();
    if (!self.targetname)
        objerror ("no targetname");
};

//============
// --> QUAKED info_teleport_random (.5 .5 .5) (-8 -8 -8) (8 8 32)
// Drake/Zerstorer entity.
// This is the destination marker for a random teleporter.
//============
void() info_teleport_random =
{
    teleport_setup ();
    randomspots = randomspots + 1;
};

// Called by 'trigger_teleport' below.
void() teleport_use =
{
    self.nextthink = time + 0.2;
    force_retouch = 2;        // make sure even still objects get hit
    self.think = SUB_Null;
};

//============
// --> QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
// Any object touching this will be transported to the corresponding
// info_teleport_destination entity. You must set the "target" field,
// and create an object with a "targetname" field that matches.
//
// If the trigger_teleport has a targetname, it will only teleport entities
// when it has been fired.
//============
void() trigger_teleport =
{
    InitTrigger ();
    self.touch = teleport_touch;

// Find the destination
// PM:  Random teleports search for targets when used.
    if (!(self.spawnflags & RANDOM))
        if (!self.target)
            objerror ("no target");
    self.use = teleport_use;

    if (!(self.spawnflags & SILENT))
    {
        local   vector  spot;

        spot = (self.mins + self.maxs)*0.5;
        precache_sound ("ambience/hum1.wav");
        ambientsound (spot, "ambience/hum1.wav", 0.5, ATTN_STATIC);
    }
    if (self.spawnflags & TELE_GLITTER)
        Glitter_Spawner ();
};

//============================================================================
//
//  trigger_setskill
//
//============================================================================

void() trigger_skill_touch =
{
    if (other.classname != "player")
        return;
// PM:  New 'Hell' difficulty check.
    if (self.message == "4")
        serverflags = serverflags | SVFL_HELL;
    else
    {
        local   float   gm;
        local   string  text;

        gm = cvar("temp1");
        if (gm & GM_HELL)
        {   // Turn off Hell skill.
            text = ftos(gm - GM_HELL);
            cvar_set ("temp1", text);
            bprint ("hell difficulty OFF\n");
        }
        serverflags = serverflags - (serverflags & SVFL_HELL);
    }
//- - - - - - - - -
    cvar_set ("skill", self.message);
};

//============
// --> QUAKED trigger_setskill (.5 .5 .5) ?
// sets skill level to the value of "message".  Only used on start map.
//============
void() trigger_setskill =
{
    InitTrigger();
    self.touch = trigger_skill_touch;
};
void() trigger_setskill_point =
    {InitPointTrigger();  self.touch = trigger_skill_touch;};


//============================================================================
//
//  ONLY REGISTERED TRIGGERS
//
//============================================================================

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
        return;
    }

// Playing with shareware?!  Access denied!
    if (self.message != "")
    {
        centerprint (other, self.message);
        sound (other, CHAN_BODY, "misc/talk.wav", 1, ATTN_NORM);
    }
};

//============
// --> QUAKED trigger_onlyregistered (.5 .5 .5) ?
// Only fires if playing the registered version, otherwise prints the message
//============
void() trigger_onlyregistered =
{
    precache_sound ("misc/talk.wav");
    InitTrigger ();
    self.touch = trigger_onlyregistered_touch;
};
// PM:  I do not see a need for a point version of onlyregistered.

//============================================================================

void() hurt_on =
{
    self.solid = SOLID_TRIGGER;
//    if (!zerstorer)
        self.nextthink = -1;
};

void() hurt_touch =
{
//    if (zerstorer)
//        if (self.spawnflags & 2)
//            if (other.classname != "actor")
//                return;

// Note:  NPCs take damage only if moving.  Maybe set force_retouch to fix?
    if (other.takedamage)
    {
        // Note:  Hits only the first entity touched.
        self.solid = SOLID_NOT;
        // PM:  Use new damage function for custom death messages.
        // Also, since the triggers' origin is at world origin, don't use
        // knockback because of improper velocities set by new damage code.
        T_NewDamage (other, self, self, self.dmg, DF_NO_KNOCK, self.deathtype);
        self.think = hurt_on;
        self.nextthink = time + 1;
// Hipnotic's cnt stuff - - - - - - - -
        HipCntDown ();
//- - - - - - - - - - - - - - - - - - -
    }
};

//============
// --> QUAKED trigger_hurt (.5 .5 .5) ?
// Any object touching this will be hurt
// set dmg to damage amount
// defalt dmg = 5
//============
void() trigger_hurt_spawn =
{
//- - - - - - - - -
    if (world.tronyn & DJG_VOID)
        {trigger_void_spawn();  return;}
//- - - - - - - - -
//    InitTrigger ();
    self.touch = hurt_touch;
    if (!self.dmg)
        self.dmg = 5;
// Hipnotic's cnt stuff - - - - - - - -
    if (!self.cnt)
        self.cnt = -1;
//- - - - - - - - - - - - - - - - - - -
// HACK:  If in shub's level, assume it is the one on her platform.
// Fun fact:  The only Id map with trigger_hurt is end.bsp, and the trigger
// is located on shub's platform.  Of course, there are numerous custom maps
// with trigger_hurt, such as coagula-style maps.
    if (!deathmatch)
    {
        if (world.model == "maps/end.bsp")
            if (world.message == "Shub-Niggurath's Pit")
                self.deathtype = "became one with Shub-Niggurath";
    }
};
void() trigger_hurt = //{InitTrigger ();  trigger_hurt_spawn();};
{   // SoE hack!
    if (world.model == "maps/nsoe2.bsp")
        {remove (self);  return;}   // Don't let the flames hurt.
    InitTrigger ();
    trigger_hurt_spawn();
};
void() trigger_hurt_point = {InitPointTrigger ();  trigger_hurt_spawn();};

//- - - - - - - - - - - - - - - - - - -
// Variant Damage Trigger Fields

//============
// Called when something touches a void trigger.
void() void_touch =
{
// Items get special treatment.
    if (other.flags & (FLx_CREATURE | FL_ITEM) == FL_ITEM)
    {   // Items disappear.
        other.flags      = other.flags - FL_ITEM;
        other.solid      = SOLID_NOT;
        other.movetype   = MOVETYPE_NONE;
        other.touch      = SUB_Null;
        other.use        = SUB_Null;
        other.targetname = world.null_string;
        other.modelindex = 0;
        other.nextthink  = 0.01;
        other.think      = SUB_Remove;
    // Item destruction does not expend trigger charges, so no HipCntDown.
        return;
    }

// For everything else...
    if (self.spawnflags & 1)
    {   // Sky spawnflag ON -- ignore those with flight.
        if (other.flags & FL_FLY)
            return;     // Flight capable.
        if ((other.movetype == MOVETYPE_FLY) || (other.movetype == MOVETYPE_NOCLIP))
            return;     // For players.
    }

// Kill anything that can die.
// Note:  A slain monster becomes solid_not as it dies, and once that
// happens, it cannot touch triggers anymore.  Thus, poof only the living.
    if (other.th_die)
        if (!other.deadflag)    // Here so HipCntDown isn't wasted.
        {   // Note:  T_Kill only kills things that have DEAD_NO.
            T_Kill (other, self, self, -99, self.deathtype);
// Hipnotic's cnt stuff - - - - - - - -
            HipCntDown ();
//- - - - - - - - - - - - - - - - - - -
        }
};

//============
// --> QUAKED trigger_void (.5 .5 .5) ?
// Trigger of death -- Any object touching this dies!
// Spawnflags:  Sky
//============
void() trigger_void_spawn =
{
//    InitTrigger ();
    self.classname = "trigger_void";
    self.touch = void_touch;
    if (!self.deathtype)
        self.deathtype = "void";
// Hipnotic's cnt stuff - - - - - - - -
    if (!self.cnt)
        self.cnt = -1;
//- - - - - - - - - - - - - - - - - - -
};
void() trigger_void = {InitTrigger ();  trigger_void_spawn();};
void() trigger_void_point = {InitPointTrigger ();  trigger_void_spawn();};

//============================================================================
//  Wind Tunnels

float PUSH_ONCE = 1;
float PUSH_CURRENT = 2;     // Zerstorer -- "Silent" PUSH for water currents.
float PUSH_JUMP_ONLY = 4;   // Drake -- Push only when jump is pressed.

void() push_use2 =   // This function is Zerstorer stuff.
{
    if (self.solid == SOLID_NOT)
        self.solid = SOLID_TRIGGER;
    else
        self.solid = SOLID_NOT;
};

void() trigger_push_touch =
{
// PM:  Use wind flag on projectiles to catch them.
// Replaced grenade classname check with wind flag check.
    if ((other.health > 0) || (other.xfl & XFL_WIND))
    {
        other.velocity = self.speed * self.movedir * 10;
        if (other.classname == "player")
        {
            if (other.fly_sound < time)
            {
                other.fly_sound = time + 1.5;
                if (!(self.spawnflags & PUSH_CURRENT))
                    sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
            }
        }
        else  // PM:  Monsters are blown away.  Non-existant in 1.06 source.
            other.flags = other.flags - (other.flags & FL_ONGROUND);
    }
//- - - - - - - - -
    if (self.spawnflags & PUSH_ONCE)
        remove (self);
};

//============
// --> QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
// Pushes the player
//============
void() trigger_push_spawn =
{
//    InitTrigger ();
    precache_sound ("ambience/windfly.wav");
    self.touch = trigger_push_touch;
    if (!self.speed)
        self.speed = 1000;
//- - - - - - - - -
// Zerstorer stuff
    if (self.targetname)
        {self.solid = SOLID_NOT; self.use = push_use2;}
//- - - - - - - - -
};
void() trigger_push = {InitTrigger ();  trigger_push_spawn();};
void() trigger_push_point = {InitPointTrigger ();  trigger_push_spawn();};


//============================================================================
void() trigger_monsterjump_touch =
{
    if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
        return;     // Not a walkmonster.
    if (!other.enemy)
        if (other.classname == "monster_bane")
            return;   // SoE:  The Bane does not jump unless he has an enemy.
//- - - - - - - - -
// PM:  Added directional jump trigger for Drake.
// My start map in Tronyn's Roman pack uses these.
    if (self.spawnflags & 1)    // FIXME:  Does this break existing maps?
    {
        makevectors (other.angles);
        if (v_forward * self.movedir < 0)
            return;        // not facing the right way
    }
//- - - - - - - - -

// set XY even if not on ground, so the jump will clear lips
    other.velocity_x = self.movedir_x * self.speed;
    other.velocity_y = self.movedir_y * self.speed;
    if (other.flags & FL_ONGROUND)
    {
        // Feet on the ground, so jump.
        other.flags      = other.flags - FL_ONGROUND;
        other.velocity_z = self.height;

    // 8/8/10:  Jump animation for some monsters (not all models have them).
        if (other.th_jump)
            if (!other.touch || (other.touch == SUB_Null) || (other.touch == monster_touch))
                if (!IsDead (other))
                    SUB_Think (other, other.th_jump);
    }
// Hipnotic's cnt stuff - - - - - - - -
    HipCntDown ();
//- - - - - - - - - - - - - - - - - - -
};

//============
// --> QUAKED trigger_monsterjump (.5 .5 .5) ?
// Walking monsters that touch this will jump in the direction of the
// trigger's angle
// "speed" default to 200, the speed thrown forward
// "height" default to 200, the speed thrown upwards
//============
void(float pt) trigger_monsterjump_spawn =
{
    if (!self.speed)
        self.speed = 200;
    if (!self.height)
        self.height = 200;
    if (self.angles == '0 0 0')
        self.angles = '0 360 0';
// Hipnotic's cnt stuff - - - - - - - -
    if (!self.cnt)
        self.cnt = -1;
//- - - - - - - - - - - - - - - - - - -
    if (pt)
        InitPointTrigger ();
    else
        InitTrigger ();
    self.touch = trigger_monsterjump_touch;
};
void() trigger_monsterjump = {trigger_monsterjump_spawn (FALSE);};
void() trigger_monsterjump_point = {trigger_monsterjump_spawn (TRUE);};

//- - - - - - - - -
// Update 8/19/09:  Jump/Dive Triggers

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
void() trigger_jump_point = {InitPointTrigger ();  trigger_jump_spawn ();};

void() trigger_superjump =
    {InitTrigger ();  self.spawnflags = self.spawnflags | PUSH_JUMP_ONLY;  trigger_jump_spawn ();};
void() trigger_superjump_point =
    {InitPointTrigger ();  self.spawnflags = self.spawnflags | PUSH_JUMP_ONLY;  trigger_jump_spawn ();};
//- - - - - - - - -

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


//============================================================================
//  Music Trigger

void() tmusic_touch =
{
    if (other.classname != "player")
        return;

    PlayMusic (self.noise, self.wait);

    activator = other;
    SUB_UseTargets ();

    // We can't just remove (self) here, because this is a touch function
    // called while C code is looping through area links...
    self.touch      = SUB_Null;
    self.nextthink  = time + 0.1;
    self.think      = SUB_Remove;
};
void() tmusic_use =
{
    PlayMusic (self.noise, self.wait);
    self.nextthink  = time + 0.1;
    self.think      = SUB_Remove;
};

//============
// --> QUAKED trigger_music (.5 .5 .5) ? NOTOUCH
// Pushes the player
//============
void() trigger_music_spawn =
{
    if (!self.noise)
        {remove (self);  return;}

    precache_sound (self.noise);

    // 'InitTrigger' already done elsewhere.
    if (self.targetname)
        self.use = tmusic_use;
    else
        self.touch = tmusic_touch;
};

void() trigger_music = {InitTrigger ();  trigger_music_spawn ();};
void() trigger_music_point = {InitPointTrigger ();  trigger_music_spawn ();};


//===========================================================================
//
//  INFO ENTITIES
//
//===========================================================================

//============
// --> QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
// Used as a positional target for spotlights, etc.
//============
void() info_null = {remove(self);};

//============
// --> QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
// Used as a positional target for lightning.
//
// PM:  Also used by czg for various special effects in his maps.
//
// Update 1/5/10: ...And by anything that needs a dummy entity to
// point to, such as spawn points for the cube spawner in roman3.
//============
void() info_notnull = {};


//===========================================================================
//  QUAKED FUNCTIONS
//===========================================================================

//============
// --> QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
// The normal starting point for a level.
//============
void() info_player_start        = {};

//============
// --> QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
// Only used on start map for the return point from an episode.
//============
void() info_player_start2       = {};

//============
// saved out by quaked in region mode
//============
void() testplayerstart          = {};

//============
// --> QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
// potential spawning position for deathmatch games
//============
void() info_player_deathmatch   = //{};
{
    if (dmsp)
    {
        DMSP_checkSpawnSize();
        self.netname = "dmsp_spawn";
    }
};

//============
// QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
// potential spawning position for coop games
//============
void() info_player_coop         = //{};
{
    if (!coop)  // Unused in non-coop, so remove them to free up a few edicts.
        remove (self);
};


//==========================================================================
// LEVEL CHANGING / INTERMISSION
//==========================================================================

// PM:  Globals moved to global.qc.

void(float on) Toggle_Dmsp =
{
    local   float   gm;
    local   string  text;

    if (on)
        gm = gamemode | GM_DMSP;
    else
        gm = gamemode - (gamemode & GM_DMSP);
    text = ftos(gm);
    cvar_set ("temp1", text);
};

//============
// --> QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
// This is the camera point for the intermission.
// Use mangle instead of angle, so you can set pitch or roll as well as yaw.
// 'pitch roll yaw'
//============
void() info_intermission = {};

//============
// FindIntermission
//
// Returns the entity to view from
//============
entity() FindIntermission =
{
    local   entity  spot;
    local   float   cyc;

// look for info_intermission first
    spot = find (world, classname, "info_intermission");
    if (spot)
    {    // pick a random one
        cyc = random() * 4;
        while (cyc > 1)
        {
            spot = find (spot, classname, "info_intermission");
            if (!spot)
                spot = find (spot, classname, "info_intermission");
            cyc = cyc - 1;
        }
        return spot;
    }

// then look for the start position
    spot = find (world, classname, "info_player_start");
    if (spot)
        return spot;
    
// testinfo_player_start is only found in regioned levels
    spot = find (world, classname, "testplayerstart");
    if (spot)
        return spot;
    
    objerror ("FindIntermission: no spot");
    return world;   // Just to make FrikQCC happy.
};

//============
void() GotoNextMap =
{
    if (cvar("samelevel"))    // if samelevel is set, stay on same level
        changelevel (mapname);
    else
        changelevel (nextmap);
};

//============
void() ExitIntermission =
{
// skip any text in deathmatch
    if (deathmatch)
    {
        GotoNextMap ();
        return;
    }

    intermission_exittime = time + 1;
    intermission_running = intermission_running + 1;

//
// run some text if at the end of an episode
//
    local   string  text;

    text = world.null_string;
    if (intermission_running == 2)
    {
        local   float   music;

        music = 2;
// Normal Quake
        if (world.model == "maps/e1m7.bsp")
        {
            if (world.message == "The House of Chthon")
            {
                if (cvar("registered"))
                    text = "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!";
                else
                    text = "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!";
            }
        }
        else if (world.model == "maps/e2m6.bsp")
        {
            if (world.message == "the Dismal Oubliette")
                text = "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.";
        }
        else if (world.model == "maps/e3m6.bsp")
        {
            if (world.message == "Chambers of Torment")
                text = "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.";
        }
        else if (world.model == "maps/e4m7.bsp")
        {
            if (world.message == "Azure Agony")
                text = "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.";
        }
// Hipnotic
//        else if (world.model == "maps/hip1m4.bsp")
//            {music = 6; text = "Deep within the bowels of the\nResearch Facility, you discover the\npassage that the followers of Quake\nhave used to enter our world.\nThe bastards used some type of\ngigantic teleporter to overload\none of our own slipgates!  As long as\nthis portal exists, Earth will never\nbe safe from Quake's cruel minions.";}
//        else if (world.model == "maps/hip2m5.bsp")
//            {music = 6; text = "After destroying the power generator,\nyou pass beyond the gate of Mortum's\nKeep.  A wave of nausea suddenly flows\nover you and you find yourself cast\nout into a liquid void.  You float\nlifelessly, yet aware, in a lavender\nsea of energy.";}
//        else if (world.model == "maps/hipend.bsp")
//            text = "After the last echoes of Armagon's\ndeath yell fade away, you breathe a\nheavy sigh of relief.  With the loss\nof his magic, Armagon's fortress\nbegins to collapse.  The rift he\ncreated to send his grisly troops\nthrough time slowly closes and seals\nitself forever.  In the chaos that\nensues, a wall collapses, revealing\none remaining time portal.  With your\nchances to escape rapidly growing\nslim, you race for the portal,\nmindless of your destination.  In a\nflash of light, you find yourself\nback at Command HQ, safe and sound.";
//- - - - - - - - -
// SoE
//        else if (world.model == "maps/demoend.bsp" || world.model == "maps/soedemo3.bsp")
//            text = "You've just completed the preview release\nof Soul Of Evil. We released this to hold\nover fans who've had to suffer during the\nnearly year-long development period, and\nmore importantly, so that we could recieve\nmajor feedback prior to the full release.\n\nWe want your opinions! Please email any\nquestions, comments, bug finds, or anything\nelse remotely Quake or SoE related, to\nnetgames@netdp.com. If you are interested\nin becoming a tester for the full SoE\nproject you can email the same address\nabout that.";
//        else if (world.model == "maps/soe1m5.bsp")
//            text = "As the warlord Bane's twisted body falls\nwith the clang of steel into the autumn\nleaves, a sense of closure engulfs you.\nYour quest here is done; the land is\nsafe from his dire power and brutality.\nBecause of you, this world is free and\nthe people here can emerge from hiding\nand try to rebuild their lives.\nYet you know that one liberation is\nnot enough; the evil behind the Bane\nis infinite, and continually manifests\nitself in many worlds. Bane came\nfrom somewhere, and one dimension is as\ngood as any other.\nIt seems like a thousand years ago, you\ntook the fight away from Earth and to an\nenemy codenamed Quake. Having found the\nhidden portal the Bane must have used\nto gain his hold on this world, it is\nlikely that you are now able to reach\nwherever he came from, and punish those\nresponsible for sending him here.";
//        else if (world.model == "maps/soe2m6.bsp")
//        {
//            if (serverflags & SVFL_TROG)    // Victory!
//                text = "The Cult Lord's corpse bursts into its\ncomponent atoms as you break his spell\nand destroy the being. The Cult Lord\nhoped to become invincible; a God, by\nmanifesting two artifacts at once and\nobtaining the power of both. He would\nhave become the unstoppable scourge of\nmany worlds, your own among them,\nwere it not for your actions.\n\nThe Shalrath Cult, through the Bane,\nobtained a foothold on the last world\nyou visited. Now, with their leader gone\nand the Cult's heart ripped out, these\ndisciples of Quake's Evil will no longer\npose a threat to any human world for a\nvery, very long time.";
//            else    // Failure!
//                text = "You have failed to destroy the Shalrath\nCult-Lord, and his hideous plans have\ncome to fruition. The Cult Lord has\n become a god, a god of death. His\nunholy combination of two of the three\nartifacts the Elders left to these\nuniverses has made him immortal,\ninvincible, and unstoppable. These\nartifacts were to remain as widely\nseparated as possible, in different\ndimensions, universes, spaces, times.\nBut the Cult Lord twisted the universes\nthrough his unspeakable magics and now,\nbecause you let him live, he has done\nwhat no being ever should have done.";
//        }
//        else if (world.model == "maps/soeexit.bsp")
//            text = "Soul Of Evil was created by the\nfollowing individuals:\n\nDustin 'Tronyn' Geeraert: Project Lead\nRob 'Fat Controller' Cruickshank: QuakeC\nTravis 'Skunk' Peterson: Website, Maps\nRich 'XeNoN' Thorne: Maps\nDean 'Rotpig' Turner: Maps\nDylan 'Lithiumbat' Sartain: Skins\nDavid Laurie: Maps\n\nWe hope you have enjoyed SOE. See the\ncredits section in the readme for more\ndetailed credits and for the\nacknowledgement of all those whose\nstuff was included herein...";
//        else if (world.model == "maps/soedm6.bsp")
//        {
//            if (dmsp)
//                text = "You have completed Soul Of Evil: Arena!\nYou have destroyed hundreds of monsters\nand defeated six dragons.\n\nCongratulations. Soul Of Evil: Arena is\nbased on DMSP by Wouter van Oortmerssen\n(http://wouter.fov120.com).\n\nOur thanks to Wouter for letting us use\nhis code and we hope you have enjoyed\nSoul Of Evil's arena mode.";
//        }
// NSoE:  Indian Summer story, including one for start.
        else if (world.model == "maps/start.bsp")   // NSoE story.
        {   if (world.message == "Indian Summer")
                text = "As you step into the shadows,\na voice echos in your mind...\n\n\"Baneslayer, thy return is most welcome\nfor we are in dire need of thy aid once\nmore. A great evil has swept across our\nland and laid upon it a terrible curse,\nwhich has brought ruin and devastation\nto us all. You must destroy the evil\nand break the curse, or we will all\nperish! Be warned that even thee, our\ngreat champion, are not immune to its\nfury, for the enemy knows of thee and\nwill stop at nothing to destroy thee!\nWe spirits of the land will shield thee\nas best we can, but we cannot stop its\nmalignant power completely. Go now,\nand good luck!\"";
//            else if (world.message == "The beginning of the end...")
//                text = "I never thought I'd see this day.\nThey're sending ME in, me of all people!\n-\n'We messed up and now you have to clean\nit up' they tell me. To hell with that.\nMy contract says two more weeks and\nthey want to send me off to some\nforsaken hell-hole to keep the\npopulation from coming here.\nI don't owe it to anyone to be there in\nthe service any longer than I have to\nbe. I've done more than enough killing\nalready.\n'We can only send one at a\ntime', they say. 'Otherwise the others\nget telefragged.' I'm sure as hell not\ntheir best man. I imagine the reasoning\nwas 'Let's send Bruce, he's expendable.\nHis time's almost up and I don't trust\nhim on the outside.' I kill, they pay\nme. and when my time is up, I'll be\nback here to collect my goddamn money,\nwhether the beasts at the other end\nhave hit the dirt or not.";
        }
        else if (world.model == "maps/arcanum5.bsp")
            text = "You have defeated the master magicians\nand banished the eldritch abomination\nback whence it came. Unfortunately,\nyou know it is not dead, and \"that\nwhich is not dead can eternal lie.\"\nYou realize it is only a matter of\ntime before another crazy cult tries\nto summon the abomination or its kin\nback to destroy the Earth. Will you\nbe able to foil such a plot again,\ntime after time? Can you?\n\nEven if you can, who will take your\nplace when you pass away? It feels\nyou are only delaying the inevitable,\nwhich is the utter annihilation of\nEarth by the Great Old Ones. The best\nyou can hope for is to live a full\nlife before that dreadful day.";
        else if (world.model == "maps/nsoe1.bsp")
            text = "As you dive into the portal, a deathly\ncold chill overwhelms you. You are\nfrozen in space. With horror, you\nwatch your combat gear corrode and\ndisintegrate right before your eyes.\nOnly your axe, shotgun, and a\nhandful of shells escape destruction.\n\nAs the chill fades, you feel warmth\nflood through your body. You can\nmove again. In fact, you feel like a\nnew man. Your cuts and bruises have\nvanished, as if nothing had happened.\nThen, you hear the voice of Mazarbul...\n\n\"This is the work of thy enemy! We have\nsaved thine health and what few weapons\nwe could. Now, the enemy wages war at\nye City of Angels where thee shall go.\"";
        else if (world.model == "maps/nsoe2.bsp")
            text = "While you knew something was wrong when\nyou met several of Bane's soldiers back\nin the Chamber of Mazarbul, you did\nnot expect an army of them garrisoned\nat the great City of Angels, backed by\nemissaries from the former Shal-Rath\nCult, a cult once so powerful they\nwould have sown chaos and destruction\neverywhere had you not slain its\nCult Lord years ago. How could the\nland you liberated fall back into\ndarkness and despair so soon?\n\nAlthough you and the rebels have won\nback the City of Angels, you know your\nvictory here will be for naught until\nyou destroy the source of this evil.\nReady to leave, you step into the\npentagram to continue your quest.";
        else if (world.model == "maps/nsoe3.bsp")
            text = "The armies of darkness roam the land\nonce more -- goblins, Bane's wizards\nand warriors, demons from beyond, and\neven dragons from the sea and sky.\nThis can mean only one thing: the\nShal-Rath Cult has returned, and you\nwonder in disbelief as to who would be\npowerful enough to resurrect so quickly\nthat which you destroyed years ago.\nYou know that you must find and destroy\nthe new Cult Lord before the cult rises\nto threaten the multiverse again.\n-\nAnd yet, even with their might, they\ncannot stop you from liberating The\nLost Land. As you enter the church\ntower which they zealously defended,\nyou discover a strange pool of water.\nYou dive in to discover the truth...";
        else if (world.model == "maps/nsoe4.bsp")
            text = "So the pool led to a whole subterranean\nworld! This must be where the Shal-Rath\nCult thrive - the deep, dark underworld.\nObviously this cavern was where they\nentered this world - but where was the\nCult Lord? And how did they swarm up\ninto the world above? The Church Tower\nwould have been guarded closely by\nhuman armies, if it led to such a\ndungeon. There must be another way\nup from the underground...\n\nAlthough you have no idea of the source\nof this vile infestation, you have no\ndoubt that, as is often the case, your\nbullets will find their mark. No matter\nwhat, for all these centuries, you\nalways find the evil you seek and lay\nit to permanent, blood-soaked rest...";
        else if (world.model == "maps/nsoe5.bsp")
            text = "In your quest for freedom, you have\nfought through hordes of goblins,\narmies of Bane's soldiers, packs of\nvile beasts, swarms of dragons, and\nremnants of the once mighty Shal-Rath\nCult led by a would-be Cult Lord. The\noverlord of the forces of darkness\nyou just vanquished is... Bane?!\n\nOnce again you fought the Bane in\nmortal combat, and once again you\ndefeated him and emerged victorious.\nDespite your triumph over the Bane\nand escape from his domain, you feel\nuneasy. How did the Bane return,\nand stronger than before?\nThen with dread, you wonder\nif you will see the Bane again.\nPerhaps the Bane has many copies...";
        else if (world.model == "maps/nsoe6.bsp")
            text = "The Bane must have used the four Runes\nof Quake, those very Runes you used to\nslay Shub-Niggurath so long ago, to\nresurrect the Shal-Rath Cult, return\nthem to this ravaged land, and resume\ntheir insidious plan of conquest.\nEven though the Bane is gone, he left\nthe sacred Runes in this stronghold,\nguarded by the most fanatical of his\nfollowers and his fiercest dragons.\nAfter an epic battle, even they cannot\nstop you, the Baneslayer, from victory.\n\nNow, with the four Runes, you release\ntheir power to banish all of the Bane's\nevil and influence from the land. With\nthe land free, your work here is done.\nYou step into the teleporter for\na ride with destiny.";
        else if (world.model == "maps/roman3.bsp")
            text = "With the death of Hell's mightiest\nwarrior, the demonic invasion has\nended. The Earth is safe... for now.\n\nThus ends this episode of the\nslipgate traveler.\n\nYou came, you saw, you conquered!\n\nThank you for playing\nA Roman Wilderness of Pain.";
// Rapture (Here for an possible merger of Tronyn's stuff later.)
//        else if (world.model == "maps/rainend.bsp")
//            text = "I've been here for a few days now.\nThis really is an ugly place. The\nendless rain and nightmarish parade of\nliving corpses is really starting to\nget to me. No place on Earth is this\ndespairing, this dark or dreary, or\nthis hostile. Out of all the time I\nhad to do for my contract, they saved\nthe very worst for the very last.\n-\nAfter shooting up metal soldiers and\nugly creatures, I finally got to what\nmight be the end. There to meet me was\na Baron, much stronger than the other\nknights. He had magic in his veins,\nand was very tough.\nTook me some time, but I got him.\n-";
//        else if (world.model == "maps/rapture.bsp")
//            text = "One gate to the next. The way it's\nsupposed to work is, I win the war, I\nfind a gate that goes back home, I get\nmy money. Not some fiery dismal domain\nand MORE of the bastards! How much\nmore of this can I take?\n-\nMy side hurts. That last knight, the\nFire Baron, got me in the side and it's\nbleeding quite badly. I'm standing over\nhis body and my side really hurts.\n-";
//        else if (world.model == "maps/sub.bsp")
//            text = "I have three Runes now. I am going to\nbe unstoppable pretty soon. I don't\neven have to USE these Runes, they use\nthemselves!\nThere's something strange about these\nartifacts I've got. It's like they're\ntalking to me, whispering in my mind.\nTelling me there are secrets that I\nneed to discover...\nI feel strange. I think they might be\nhaving some strange effect on me.\nI don't feel myself anymore.\nForgetting things. I can't even\nremember the name of my own home\nanymore! I just know that I'm here to\nkill, and find the last rune. I know\nthere is another one waiting, the\nother runes seem to tell me...";
//        else if (world.model == "maps/storm.bsp")
//            text = "When I close my eyes I see things.\nI see nails falling from the sky.\nMy mind no longer commands itself.\nI think that I still am, I have a\nweapon, but I cannot remember my name.\nI cannot remember where I was before I\nwas here. I have destroyed myself and\nothers like me and I have been reborn\nas my enemy.\nI have been appointed the new ruler of\nthese beasts. Someone destroyed their\nold rulers, and their masters require\na replacement. Was it me...\nthat killed them...?\n-\nSuddenly my thoughts become clear;\nIn the split second between now and\nprior to now, I saw Quake.\n-";
//        else if (world.model == "maps/rapend.bsp")
//            text = "And so a man who once thought that he\nwas 'a soldier' and 'in the army',\nthrough the dire effects upon his\npsyche of the haunted land he fought\nthrough, took to the desolation of\nQuake's realms and took up the throne\nof chaos that he had claimed for his\nown. He had conquered all elemental\nforces. And thus proven himself in the\neyes of his adversary.";
//- - - - - - - - -
        else if (world.model == "maps/unf3.bsp")
            text = "You have defeated the dark lord and\nended his terrible reign. Yet, you\nfeel this is only one of many such\nwarlords, and another will take his\nplace someday. Where does Quake find\nall of these powerful evil beings?\n\nOver the years, you have confronted\nand slain many forms of evil, beginning\nwith Shub-Niggurath, then moving on to\nother eldritch abominations, various\ncybernetic demon lords, demented\narchmagi, the Bane (twice), and now\nthis dark lord. Somehow, during the\nbattle, you felt a connection with him,\nas if he was once human. If so, what\ncaused him to turn away from humanity?";

        if (!IsEmptyString (text))
        {
            IntermissionMusic ();   // .wav music.

            WriteByte (MSG_ALL, SVC_CDTRACK);
            WriteByte (MSG_ALL, music);
            WriteByte (MSG_ALL, 3);

            WriteByte (MSG_ALL, SVC_FINALE);
            WriteString (MSG_ALL, text);
            return;
        }
    }
    else if (intermission_running == 3)
    {
// Normal Quake
        if (!cvar("registered"))
        {    // shareware episode has been completed, go to sell screen
            WriteByte (MSG_ALL, SVC_SELLSCREEN);
            return;
        }
        if ((serverflags & 15) == 15)
        {
// FIXME:  Check 'world.message' too?
            if ((world.model == "maps/e1m7.bsp") ||
                (world.model == "maps/e2m6.bsp") ||
                (world.model == "maps/e3m6.bsp") ||
                (world.model == "maps/e4m7.bsp"))
            {
                WriteByte (MSG_ALL, SVC_FINALE);
                WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
                return;
            }
        }
// Hipnotic
//        if (world.model == "maps/hip1m4.bsp")
//            text = "If you can find the source of the\nportal's power, you can shut it\ndown--possibly forever!  With only a\nmoment's consideration for your own\nsafety, you re-enter the dark domain,\nknowing Hell would be a better fate\nthan experiencing the reign of Quake.";
//        else if (world.model == "maps/hip2m5.bsp")
//            text = "After what seems like an eternity,\nyou feel the presence of a diabolical\nintelligence.  You are held helpless\nfor a moment as your mind is open to\nthat of Armagon--Quake's General and\nmaster of this realm.  Recognizing\nyou as the one who foiled his\nattempt to conquer Earth, a hellish\nhowl fills your mind and blots out\nall consciousness.  When you awake,\nyou find yourself on the shores of\nreality, but in a time and place\nunknown to you.";
//        else if (world.model == "maps/hipend.bsp")
//        {
//            text = "Congratulations!  You are victorious!\nThe minions of Quake have once again\nfallen before your mighty hand.\nIs this the last you will see of\nQuake's hellions?\n\nOnly time will tell...";
//            intermission_exittime = time + 10000000;    // Never allow exit!
//        }
//- - - - - - - - -
// SoE
//        if (world.model == "maps/soe2m6.bsp" && (serverflags & SVFL_TROG))
//            text = "As a hero of hundreds of worlds and as\nmany names, and a tireless warrior, you\nfear not man, beast or devil; you have\nbested all three. But you cannot help\nbut hope that one day, a gate such as\nthe one in front of you will lead you\nback home, and to all that you left\nbehind...";
        else if (world.model == "maps/nsoe6.bsp")
            text = "--- Soul Of Evil: Indian Summer ---\n\nƒıÛÙÈÓ ‡‘ÚÔÓ˘Ó‡ «ÂÂÚ·ÂÚÙ              \n  Project Director, Map Design, Story \n–·ÙÚÈ„Î Õ·ÚÙÈÓ                        \n  QC Coding, Models, Skins, Story     \nÃÔıÈÛ ‡ÈÍÂ‰‡ Õ·ÓÓÈÓÁ                  \n  Lead Tester, Skins                  \n¬ÂÓÁÙ ‡¡ÁıÈÚ“Â‡ Í·Ú‰Úı               \n  Quake Tools, Support, Testing, Skins\n“Ô‚ ‡∆·Ù √ÔÓÙÚÔÏÏÂÚ‡ √ÚıÈ„ÎÛË·ÓÎ      \n  Original SoE Code                   \n“˘·Ó ‡∆ÚÈÎ· √‡ ”ÌÈÙË                  \n  FrikBot Code, QC Compiler           \n‡⁄˜ÈÊÊÏÂ‡          ‡‘ÚÈÓ„·‡           \n  nsoe1 Author       nsoe2 Author     \n‡…ÓÂÚÙÈ·‡          ‡ÀÂÏÏ‡             \n‡…ÔÓÔıÛ‡             Skyboxes         \n  nsoe3 Testing                       ";
//        else if (world.model == "maps/demoend.bsp" || world.model == "soedemo3.bsp")
//            text = "We have started to update the web site again,\nso you can check\nhttp://www.planetquake.com/tronyn/soul\nfor SoE-related news and information.";
// In first nsoe release, now obsolete.
//    text = "But for now, you are safe,\nwith freedom and salvation at hand.\nWith the power from the Rune of\nEarth Magic, you dispel the terrible\ncurse that has ravaged this land and\nhaunted your being since your arrival.\nWith the curse broken, you feel free\nand unburdened. You are at peace.\nAny fear you had about the Bane is\ngone now. After all, you sent the\nBane to his doom -- twice. If you\nmeet him again, you feel confident on\nthe outcome: your victory, his defeat.\nNow that your work here is done,\nyou begin the journey to your next\ndestination, wherever that may be.";
//    text = "Special Thanks\n…ƒ ”ÔÊÙ˜·ÚÂ\n“·ˆÂÓ ”ÔÊÙ˜·ÚÂ\n»ÈÓÔÙÈ„ …ÓÙÂÚ·„ÙÈˆÂ¨ …Ó„Æ\n“ÔÁıÂ ≈ÓÙÂÚÙ·ÈÓÌÂÓÙ\nŒÂË·ËÚ· ‘Â·Ì\nŒÈËÈÏÈÛÌ ’ÓÏÈÌÈÙÂ‰\n‘Â·Ì ≈ˆÔÏˆÂ\n-\nSee the credits section in the readme\nfor more detailed credits and for the\nacknowledgement of all those whose\nstuff was included herein.";
//- - - - - - - - -
// Rapture
//        else if (world.model == "maps/rainend.bsp")
//            text = "When the Rain Baron hit the dirt he\ndropped some sort of odd shaped symbol.\nI've got it now. It's blue and it\nglows, kind of eerie like. I think\nit's what gave him all that power, but\nI have no idea how to use it. I don't\nthink it matters. I'll take this 'Rune'\nback home and collect some extra cash.\n'An Enemy Artifact!'\nNow there is a slipgate\nopen in front of me...";
//        else if (world.model == "maps/rapture.bsp")
//            text = "I have another of those Runes now, this\none has something to do with fire.\nIt seems those two regions so far have\nbeen under the power of a certain\nelemental ruler. Where I come from\nthere's only four elements, so it looks\nas if I've got half the power in the\nland. I shouldn't have much trouble\ndestroying whoever's behind this and\nreturning to home... Earth?\nThat name doesn't sound very, homely...";
//        else if (world.model == "maps/storm.bsp")
//            text = "I see now what I once did not.\nFrom Fire and Ice came life, and from\nFire and Ice it shall end. But though\nthese spirits obey me, though I am one\nwith what I once feared, and though I\nhave never been but conqueror, there\nremains one question in my mind:\nHave I conquered the elements,\nor have they conquered me?";
//        else if (world.model == "maps/rapend.bsp")
//            text = "From being seen as a minor annoyance,\nthe Masters soon saw him for what he\nwas - an engine of destruction - and\nsaw that his future was not as a lowly\ngrunt or zombie, but as a great leader\nwho would amass for the attack upon the\nhuman worlds. The ruin he brought to\nseveral legions of Quake's minions was\nregretted, but his future deeds, his\nmasters reasoned, would easily make up\nfor that little annoyance...\n-\nEven now, he wanders off into the\ndread-lands to survey his new kingdom\nand portion of the other worlds.\nHis rule will be long and his deeds\nterrible, and one day he will no\nlonger resemble any man...";
//- - - - - - - - -
        else if (world.model == "maps/unf3.bsp")
            text = "As you step through the portal to\nleave, visions flash before your eyes!\nYou see a ranger, much like yourself,\nbattling four elemental barons. Each\nbaron wielded mighty power and held a\nsacred rune of Quake. One by one, each\nbaron fell and yielded their rune.\nOnce the ranger grasped all four runes,\ndark forces surged through him. Twisted\nby evil, he transcended humanity and\nbecame a dark lord. With newfound\nmight, he lead the armies of Quake to\nconquer many worlds. The visions fade.\n\nYou held all four runes before, yet you\ndid not suffer the evil fate of your\npredecessor. For reasons unknown, you\ncan resist and defeat Quake's power.\nWill fortune smile on you next time?";
    }

    if (text)
    {
        WriteByte (MSG_ALL, SVC_FINALE);
        WriteString (MSG_ALL, text);
        return;
    }

    GotoNextMap ();
};

//============
// IntermissionThink
//
// When the player presses attack or jump, change to the next level
//============
void() IntermissionThink =
{
    if (time < intermission_exittime)
        return;

    if (!self.button0)
        if (!self.button1)
            if (!self.button2)
                return;
    
    ExitIntermission ();
};

// PM:  New common function to move all players to an intermission point.
// Called by execute_changelevel and finale_1 (shub kill).
void(entity pos) MoveToIntermission =
{
    local   entity  pl;

    pl = find (world, classname, "player");
    while (pl)
    {
        pl.view_ofs     = '0 0 0';
        pl.angles       = pl.v_angle    = pos.mangle;
        pl.fixangle     = TRUE;         // turn this way immediately
        pl.nextthink    = time + 0.5;
        pl.takedamage   = DAMAGE_NO;
        pl.solid        = SOLID_NOT;
        pl.movetype     = MOVETYPE_NONE;
        pl.modelindex   = 0;
        setorigin (pl, pos.origin);
//- - - - - - - - -
    // Clear any colored powerup haze from the screen.
        SUB_Think (pl, SUB_RemovePowerups);
//- - - - - - - - -
        pl = find (pl, classname, "player");
    }
// Check for custom music.
    IntermissionMusic ();
};

void() execute_changelevel =
{
    local   entity  pos;

    intermission_running = 1;

// enforce a wait time before allowing changelevel
    if (deathmatch)
        intermission_exittime = time + 5;
    else
        intermission_exittime = time + 2;

    WriteByte (MSG_ALL, SVC_CDTRACK);
    WriteByte (MSG_ALL, 3);
    WriteByte (MSG_ALL, 3);
    
    pos = FindIntermission ();

    MoveToIntermission (pos);
    other = world;      // Progs 1.06 used other to cycle all the players,
                        // stopping when other became world.

    if (cutscene)
    {   // If player was in a cutscene when the level ended, restore viewsize.
        pos = find (world, classname, "camera");
        if (pos)
        {
            local   string  val;

            val = ftos (pos.cnt);
            cvar_set ("viewsize", val);
        }
    }

//    IF (NoScore)    // PM:  Put bypass conditions here.
//        {ExitIntermission ();  return;}     // Skip scoreboard.

    WriteByte (MSG_ALL, SVC_INTERMISSION);
};


entity() SelectSpawnPoint;      // Defined in 'client.qc'.
//- - - - - - - - -
float() ThouShaltNotPass =
{
    if (world.model == "maps/nsoe1.bsp")
    {
        local   entity  sham;

        sham = find (world, classname, "monster_shambler");
        while (sham)
        {
            if (!sham.spawned)
            if (!sham.deadflag)
            if (teleport_check (TRUE))
            {
                sham = find (world, classname, "info_teleport_nsoe1");
                teleport_set (sham, '0 90 0');
                if (!sham.cnt)
                {
                    sham.cnt = 1;
                    sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
                    centerprint (other, "Destroy the shamblers first.");
                }
                return TRUE;
            }
            sham = find (sham, classname, "monster_shambler");
        }
    }
    else if (world.model == "maps/nsoe2.bsp")
    {
        local   entity  king;

        king = find (world, classname, "monster_dragon");
        while (king)
        {
            if (!king.spawned)
            if (!king.deadflag)
            {
                if (self.attack_finished < time)
                {
                    self.attack_finished = time + 2;
                    sound (other, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
                    if (king.modelindex)
                        centerprint (other, "You must slay the dragon\nbefore you can leave the city.");
                    else
                        centerprint (other, "Find a Runeswitch first.");
                }
                return TRUE;
            }
            king = find (king, classname, "monster_dragon");
        }
    }
    return FALSE;
};
//- - - - - - - - -

void() changelevel_activate =
{
// Proceed with normal operations...
    nextmap = self.map;

    SUB_UseTargets ();

    if (!deathmatch)
        if (self.spawnflags & 1)
        {   // NO_INTERMISSION
            GotoNextMap();
            return;
        }

    gameover = TRUE;    // PM:  Do this so 'StartFrame' doesn't check rules.
    self.touch = SUB_Null;

// We can't move people right now, because touch functions are called
// in the middle of C movement code, so set a think time to do it
    self.think = execute_changelevel;
    self.nextthink = time + 0.1;
};

void() changelevel_touch =
{
    if (other.classname != "player")
        return;

    if (deathmatch || dmsp)
    if (world.model != "maps/start.bsp")
    {
        local   float   death;

        death = cvar("noexit");
        if ((death == 1) || (death == 2))
        {
            local   string  text;

            if (random() < 0.5)
                text = "found a way out";
            else
                text = "tried to leave";
            T_Kill (other, self, self, -99, text);
        }
        else if (teleport_check (TRUE))
        {
            // Teleport to a deathmatch spawn point.
            local   entity  t;

            t = SelectSpawnPoint ();    // This will find a target or abort.
            teleport_set (t, t.angles);     // Don't use '.mangle'.
        }
        return;
    }
//- - - - - - - - -
// SoE:  BIG UGLY HACK!!! -- Prevent easy exit if shamblers live.
    if (ThouShaltNotPass ())
        return;
//- - - - - - - - -

    if (coop || deathmatch)
    {
        bprint (other.netname);
        bprint (" exited the level\n");
    }

    changelevel_activate ();
};

void() changelevel_use =
{
//- - - - - - - - -
// Update 5/31/09:  Check for opening exit instead of automatic exit.
    if ((self.spawnflags & 64) || cutscene)     // Latter for or1.bsp (OUM).
    {   // Open the exit.
        self.touch = changelevel_touch;
        self.use = SUB_Null;        // Activate once only.
        return;
    }
//- - - - - - - - -

// Attempt to exit level directly.
    local   entity  pl;

    pl = find (world, classname, "player");
    if (pl)
    {
        if (!deathmatch && !coop)
        {   // In single player, client must be alive to leave.
            if (IsDead (pl))
              // If unable to resurrect (always true for now), return.
                return;
        }
    }
// Hit it!
    self.use = SUB_Null;        // Activate once only.
    changelevel_activate ();
};

//============
// --> QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION x x DMSP_OFF DMSP_ON GLITTER TOGGLE
// When the player touches this, he gets sent to the map listed in the "map"
// variable.  Unless the NO_INTERMISSION flag is set, the view will go to the
// info_intermission spot and display stats.
//============
void() trigger_changelevel =
{
    if (!self.map)
        objerror ("changelevel trigger doesn't have map");
// SoE:  Indian Summer hacks.
    if (world.model == "maps/start.bsp")
    {   if (world.message == "Indian Summer")
            self.spawnflags = self.spawnflags | 1;
    }
    else if (world.model == "maps/nsoe2.bsp")
    {   self.spawnflags = self.spawnflags | 32;
        self.count = 145;   // Purple glitter.
    }
//- - - - - - - - -

    InitTrigger ();
// PM:  Teleglitter check.
    if (self.spawnflags & TELE_GLITTER)
        Glitter_Spawner ();
// PM:  If targeted, the trigger must be used (instead of touched) to exit.
// FIXME:  Breaks cryo1.  Disable and find another way.
    if (!IsEmptyString (self.targetname))
        {self.use = changelevel_use;  return;}
//- - - - - - - - -
    self.touch = changelevel_touch;
};


//==========================================================================
// MOVETARGET CODE
//
// The angle of the movetarget effects standing and bowing direction,
// but has no effect on movement, which always heads to the next target.
//
// "targetname"
// Must be present.  The name of this movetarget.
//
// "target"
// The next spot to move to.  If not present, stop here for good.
//
// "pausetime"
// The number of seconds to spend standing or bowing for path_stand or
// path_bow
//==========================================================================

//=============
// t_movetarget
//
// Something has bumped into a movetarget.  If it is a monster
// moving towards it, change the next destination and continue.
//==============
void() t_movetarget =
{
    if (other.movetarget != self)
        return;
    if (other.enemy)
      if (!(other.ryuflags & RYU_PATH))   // For big dragons (DoE and others).
        return;        // fighting, not following a path
    if (IsDead (other))     //other.health <= 0)
        return;     // dead

// PM:  Removed self/other swap gymnatics.

// PM:  Not happy with this here, but can't think of anything better to use.
// (No, I don't need to define another void() th_xxx field just for this.)
    if (other.classname == "monster_ogre")
        sound (other, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");
    other.goalentity = other.movetarget = find (world, targetname, self.target);
// Update 1/4/10:  If path_corner has a second target, pick it sometimes.
// Partly based on Nehahra.  (Saw it while source diving, good idea I think.)
    if (self.target2)
        if (random() < 0.4)
        {
            local   entity  targ2;

            targ2 = find (world, targetname, self.target2);
            if (targ2)
                other.goalentity = other.movetarget = targ2;
        }
//- - - - - - - - -
    other.ideal_yaw = vectoyaw(other.goalentity.origin - other.origin);
    if (!other.movetarget)
    {   // other is at the end of the line.
        // PM:  Removed pausetime.
        if (other.th_stand)
            SUB_Think (other, other.th_stand);
        return;
    }
};

//============
void() movetarget_f =
{
    if (!self.targetname)
        objerror ("monster_movetarget: no targetname");
        
    self.solid = SOLID_TRIGGER;
    self.touch = t_movetarget;
    setsize (self, '-8 -8 -8', '8 8 8');
};

//============
// --> QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
// Monsters will continue walking towards the next target corner.
//============
void() path_corner = {movetarget_f ();};


//===========================================================================
//
//  HIPNOTIC ADDITIONS
//
//===========================================================================

//--------------------
// hip_brk.qc
//--------------------

float MULTI_USE = 1;
float INVISIBLE = 2;

float(entity counter) counter_GetCount;     // hipcount.qc

void() damagethreshold_killed =
{
    self.health = self.max_health;

//    self.solid = SOLID_NOT;
    activator = damage_attacker;
    self.takedamage = DAMAGE_NO;
    SUB_UseTargets ();
    self.takedamage = DAMAGE_YES;

    if (!(self.spawnflags & MULTI_USE))
        remove (self);
};

void() damagethreshold_pain = {self.health = self.max_health;};

//============
// --> QUAKED trigger_damagethreshold (0 .5 .8) ? MULTI_USE INVISIBLE
// Triggers only when a threshold of damage is exceeded.
// When used in conjunction with func_breakawaywall, allows
// walls that may be destroyed with a rocket blast.
//
// MULTI_USE tells the trigger to not to remove itself after
// being fired.  Allows the trigger to be used multiple times.
//
// INVISIBLE tells the trigger to not be visible.
//
// "health" specifies how much damage must occur before trigger fires.
// Default is 60.
//============
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
    if (self.spawnflags & INVISIBLE)
        self.model = world.null_string;

    if (!self.health)
        self.health = 60;
    self.max_health = self.health;
    self.takedamage = DAMAGE_YES;

    self.blocked = SUB_Null;
    self.th_pain = damagethreshold_pain;
    self.th_die  = damagethreshold_killed;
};

//- - - - - - - - -
// PM:  OUM Additions
void() func_breakawaywall_use =
{
    if (self.cnt)
        if (counter_GetCount (other) != self.cnt)
            return;

    if (self.spawnflags & 2)
        Rocket_Explosion1 (self.origin);
    if (self.target)
        SUB_UseTargets ();

    if (self.spawnflags & 1)
        BecomeExplosion ();
    else
        remove (self);
};

void() func_breakawaywall_die =
{
    sound (self, CHAN_VOICE, "misc/wallbrk.wav", 1, ATTN_NORM);
    ThrowGib ("progs/rubble2.mdl", self.health);
    ThrowGib ("progs/rubble2.mdl", self.health);
    ThrowGib ("progs/rubble2.mdl", self.health);
    func_breakawaywall_use ();
};
//- - - - - - - - -

//============
// --> QUAKED func_breakawaywall (0 .5 .8) ?
// Special walltype that removes itself when triggered.
//============
void() func_breakawaywall =
{
    self.mangle = self.angles;
    self.angles = '0 0 0';

    self.classname  = "breakaway";
    self.solid      = SOLID_BSP;
    self.movetype   = MOVETYPE_PUSH;
    setorigin (self, self.origin);
    setmodel (self, self.model);
    setsize (self, self.mins, self.maxs);
/* DISABLED
// PM:  OUM Replacements
    if (oum)
    {
        self.use        = func_breakawaywall_use;
        if (self.health)
        {
            self.takedamage = DAMAGE_AIM;
            self.th_die     = func_breakawaywall_die;
            self.classname  = "func_wall";
            precache_model ("progs/rubble2.mdl");
            precache_sound ("misc/wallbrk.wav");
        }
    }
    else
*/
        self.use        = SUB_Remove;
};


//- - - - - - - - -
// hipmisc.qc
//- - - - - - - - -
//============
// --> QUAKED info_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
// Stuffs a command into the console to allow map designers
// to set server variables.
//
// "message" is the command to send to the console.
//============
void() info_command =
{
    if (self.message)
        localcmd (self.message);
};

void() effect_teleport_use =
{
    Tent_Point (TE_TELEPORT, self.origin);
    sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
};

//============
// --> QUAKED effect_teleport (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
// Create a teleport effect when triggered
//============
void() effect_teleport =
{
    precache_sound("misc/r_tele1.wav");
    self.use = effect_teleport_use;
};


//- - - - - - - - -
// hiptrig.qc
//- - - - - - - - -
float USE_GOLD_KEY = 1;

void() keytrigger_use =
{
    if (activator.classname != "player")
        return;
    if (self.attack_finished > time)
        return;

    self.attack_finished = time + 2;

// FIXME: blink key on player's status bar
    if ((self.items & activator.items) != self.items)
    {
        if (self.message != "")
        {
            centerprint (activator, self.message);
        }
        else
        {
            if (self.owner.items == IT_KEY1)
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
    self.touch      = SUB_Null;
    self.use        = SUB_Null;
    self.nextthink  = time + 0.1;
    self.think      = SUB_Remove;
    self.message    = "";

    sound (self, CHAN_VOICE, self.noise4, 1, ATTN_NORM);

    SUB_UseTargets ();
};

void() keytrigger_touch =
{
    activator = other;
    keytrigger_use ();
};

//============
// --> QUAKED trigger_usekey (0 .5 0) ? USE_GOLD_KEY
// Variable sized single use trigger that requires a key to trigger targets.
// Must be targeted at one or more entities.
//
// "message" is printed when the trigger is touched without having the
// right key.
//============
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


//============
//- - - - - - - - -
// Zerstorer stuff
void() tr_touch =
{
    if (other.classname != "player")
        if (vlen(other.velocity) > 0)
            remove (other);
};
//- - - - - - - - -

void() remove_touch =
{
    if (other.flags & self.cnt)
        return;
    other.touch = SUB_Null;
    other.model = "";
    remove (self);
//    other.nextthink = time + 0.1;
//    other.think = SUB_Remove;
};

//============
// --> QUAKED trigger_remove (.5 .5 .5) ? ignoremonsters ignoreplayers
// Variable sized trigger that removes the thing
// that touches it.  Does not affect monsters or players.
//============
void() trigger_remove =
{
// Zerstorer map hack - - - -
// Resolve conflict between Zerstorer and Hipnotic entities.
    if (world.model == "maps/zerend.bsp")
        {InitTrigger ();  self.touch = tr_touch;  return;}
//- - - - - - - - - - - - - -

// Now to our regularly scheduled code...
    self.cnt = FL_CLIENT|FL_MONSTER;
    if (self.spawnflags & 1)
        self.cnt = self.cnt - FL_MONSTER;
    if (self.spawnflags & 2)
        self.cnt = self.cnt - FL_CLIENT;
    InitTrigger ();
    self.touch = remove_touch;
};


//==========================================================================
//
// trigger_setgravity
//
//==========================================================================

void() oncount_use;     // In 'func.qc'.

void() trigger_gravity_touch =
{
    if (other.classname != "player")
        return;
    if (self.gravity == -1)
        other.gravity = 1.0;
    else
        other.gravity = self.gravity;
};

//============
// --> QUAKED trigger_setgravity (.5 .5 .5) ?
// set the gravity of a player
// "gravity" what to set the players gravity to
//  - 0 (default) normal gravity
//  - 1 no gravity
//  - 2 almost no gravity
//  - ...
//  - 101 normal gravity
//  - 102 slightly higher gravity
//  - ...
//  - 1000 very high gravity
//============
void() trigger_setgravity =
{
    InitTrigger ();
    self.touch = trigger_gravity_touch;
    if (!self.gravity)
        self.gravity = -1;
    else
        self.gravity = ((self.gravity - 1) / 100);
};

void() trigger_command_use =
{
    if (self.message)
        localcmd (self.message);
};

//============
// --> QUAKED trigger_command (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
// When triggered, stuffs a command into the console to allow map
// designers to set server variables.
//
// "message" is the command to send to the console.
//============
void() trigger_command = {self.use = oncount_use;  self.think = SUB_Null;};

void() trigger_decoy_touch =
{
    if (other.classname != "monster_decoy")
        return;
    self.touch = SUB_Null;
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
    SUB_UseTargets ();
};

//============
// --> QUAKED trigger_decoy_use (.5 .5 .5) ?
// only the decoy player can trigger this
// once triggers, all targets are used
//============
void() trigger_decoy_use =
{
    if (deathmatch)
        {remove(self); return;}
    InitTrigger ();
    self.touch = trigger_decoy_touch;
};

void() trigger_waterfall_touch =
{
    // only affect players
    if (!(other.flags & FL_CLIENT))
        return;

    other.velocity   = other.velocity + self.movedir;
    other.velocity_x = other.velocity_x + self.count * (random() - 0.5);
    other.velocity_y = other.velocity_y + self.count * (random() - 0.5);
};

//============
// --> QUAKED trigger_waterfall (.2 .5 .2) ?
// Pushes the player in the direction specified by angles.
//
// "speed" is the strength of the push (default 50).
// "count" amount of random xy movement to add to velocity (default 100).
//============
void() trigger_waterfall =
{
    InitTrigger ();
    self.touch = trigger_waterfall_touch;

    if (self.count == 0)
        self.count = 100;

    if (self.speed == 0)
        self.movedir = self.movedir * 50;
    else
        self.movedir = self.movedir * self.speed;
};


//===========================/  END OF FILE  /===========================//
