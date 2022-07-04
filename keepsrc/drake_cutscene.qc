//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Zerstorer
//               Drake by Patrick Martin
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
// Entity count: 6
// Function count: 18
//
// Implements: Drake Cutscene System
//
// Description:
// Legacy system built on some of the most ancient cutscene mods; use the AD
// cutscene system instead.  This is still useful if you want a player actor
// though.
//
// Heavily modified for Drake by Patrick Martin
//=============================================================================

void() DHM_CalcMoveDone;
void() move_camera;
void() player_run;

void() dummy_setup = {
	setorigin(self,self.oldorigin);
};

// Movie camera trigger  - dhm.  'o' should be other = the player who touched camera trigger.
void(entity o) spawn_dummy = { // [FUNCTION]
	local entity s;

	if (!o) return;

    s = spawn();
    s.velocity      = o.velocity;
    s.angles        = o.angles;
    s.health        = o.health;
    s.weapon        = o.weapon;
    s.classname     = "dummy";
    s.movetype      = MOVETYPE_NONE;
    s.solid         = SOLID_NOT;
    s.weaponmodel   = o.weaponmodel;
    s.flags         = o.flags;
    s.effects       = o.effects;
    s.items         = o.items;
    s.enemy         = o.enemy; // PM:  o.enemy changed to camera later.

	// Save powerups
	// Pentagram
    if (o.invincible_finished) {
		s.invincible_finished = o.invincible_finished - time;
        if (o.invincible_time) s.invincible_time = o.invincible_time - time;
    } else s.invincible_finished = s.invincible_time = 0;

	// Ring of Shadows
    if (o.invisible_finished) {
		s.invisible_finished = o.invisible_finished - time;
        if (o.invisible_time) s.invisible_time = o.invisible_time - time;
    } else s.invisible_finished = s.invisible_time = 0;

	// Quad Damage
    if (o.super_damage_finished) {
		s.super_damage_finished = o.super_damage_finished - time;
        if (o.super_time) s.super_time = o.super_time - time;
    } else s.super_damage_finished = s.super_time = 0;

	// Biosuit
    if (o.radsuit_finished) {
		s.radsuit_finished = o.radsuit_finished - time;
        if (o.rad_time) s.rad_time = o.rad_time - time;
    } else s.radsuit_finished = s.rad_time = 0;

	// Empathy Shields
    if (o.empathy_finished) {
		s.empathy_finished = o.empathy_finished - time;
        if (o.empathy_time) s.empathy_time = o.empathy_time - time;
    }
    else s.empathy_finished = s.empathy_time = 0;

	// Cross of Deflection
    if (o.cross_finished) {
		s.cross_finished = o.cross_finished - time;
        if (o.cross_time) s.cross_time = o.cross_time - time;
    } else s.cross_finished = s.cross_time = 0;

	// Dark Angel Wings
    if (o.wing_finished) {   s.wing_finished = o.wing_finished - time;
        if (o.wing_time) s.wing_time = o.wing_time - time;
    } else s.wing_finished = s.wing_time = 0;

	// Amulet of Reflection
    if (o.mirror_finished) {   s.mirror_finished = o.mirror_finished - time;
        if (o.mirror_time) s.mirror_time = o.mirror_time - time;
    } else s.mirror_finished = s.mirror_time = 0;

	// Tome of Power
    if (o.tome_finished) s.tome_finished = o.tome_finished - time;
    else s.tome_finished = 0;

	s.oldorigin = o.origin;
	s.nextthink = time + 0.1;
	s.think = dummy_setup; // Delay setorigin because we are in a touch.
    if (!o.trigger_field) o.trigger_field  = s; // PM:  Link player to dummy, for now.
};

void() go_back = { // [FUNCTION]
	local entity t, c, cvars, old;
	local string val;

    t = find (world, classname, "dummy");
    if (!t) objerror ("couldn't find dummy");
    t.solid = SOLID_NOT;    // So player won't bounce back.
    c = find (world, classname, "camera");
    if (!c) objerror ("couldn't find camera");
    c.oldorigin     = t.origin;     // So player won't bounce back to cam.
    setorigin (c, t.origin);
    c.velocity      = t.velocity;
    c.view_ofs      = '0 0 22'; // PM:  Morph should take care of itself.
    c.angles_x      = t.angles_x;
    c.angles_y      = t.angles_y;
    c.angles_z      = 0;
    c.health        = t.health;
    c.weapon        = t.weapon;
    c.weaponframe   = 0;
    c.weaponmodel   = t.weaponmodel;
    c.flags         = t.flags;
    c.effects       = t.effects;
    c.items         = t.items;
    c.enemy         = t.enemy; // PM:  Restore client's original enemy.
    c.invincible_finished = time + t.invincible_finished;
    c.invincible_time = time + t.invincible_time;
    c.invisible_finished = time + t.invisible_finished;
    c.invisible_time = time + t.invisible_time;
    c.super_damage_finished = time + t.super_damage_finished;
    c.super_time = time + t.super_time;
    c.radsuit_finished = time + t.radsuit_finished;
    c.rad_time = time + t.rad_time;
    c.empathy_finished = time + t.empathy_finished;
    c.empathy_time = time + t.empathy_time;
    c.cross_finished = time + t.cross_finished;
    c.cross_time = time + t.cross_time;
    c.wing_finished = time + t.wing_finished;
    c.wing_time = time + t.wing_time;
    c.mirror_finished = time + t.mirror_finished;
    c.mirror_time = time + t.mirror_time;
    c.tome_finished = time + t.tome_finished;
    c.fixangle      = 1;        // turn this way immediately
    c.takedamage    = DAMAGE_AIM;
    c.solid         = SOLID_SLIDEBOX;
    c.movetype      = MOVETYPE_WALK;
    c.nextthink     = time;
    c.think         = player_run;   // PM:  Reset player anim frames.
    c.air_finished = time + WATER_AIR; // No gasping from you!
    c.dmg = 2;        // initial water damage

	// Yes, you CAN change the classname here since the 'find' command already found the camera.  It is best to change the classname back to player now.
    c.classname     = "player";
    cutscene = 0; // Cutscene OFF
    Safe_stuffcmd (c, "-forward\n");

	// Look for any CVARSET entities to restore old cvars that were changed for the cut-scene
    if (c.ideal_yaw == -1) {
        cvars = find(world, classname, "cvar_done");
        while (cvars) { // != world)
            if (!cvars.message) cvars.message = cvars.model;
            cvar_set(cvars.netname, cvars.script);
            old = cvars;
            cvars = find (cvars, classname, "cvar_done");
            remove (old);
        }
        c.ideal_yaw = 0;
    }

    val = ftos (c.cnt);
    cvar_set ("viewsize", val); // Restore old viewsize
    t.nextthink = time + 0.1;
    t.think = SUB_Remove;
    remove (self);
};

// This routine short-circuits player turning and movement while in camera
// mode.  self.oldorigin is used as self.angles, and self.mangle is used as
// self.velocity.  This allows me to compute these figures in code, and
// overwrite what the game thinks they should be.  Called from 'client.qc'.
// PM:  Using Zerstorer style cutscene code...
void() look_ahead = { // [FUNCTION]
	local vector looky;

    self.angles = self.oldorigin;
    self.velocity = self.mangle;
    self.fixangle = 1;
    cvar_set ("viewsize", "120");        //keep screen maximized
    if (self.delay == 0) {
        looky_x = self.movedir_x - self.origin_x;
        looky_y = self.movedir_y - self.origin_y;
        looky_z = self.origin_z - self.movedir_z;
        self.oldorigin = vectoangles (looky);
    }
};

// This is a modified SUB_CalcMove routine.
void(vector tdest, float tspeed, entity cam) DHM_CalcMove = { // [FUNCTION]
	local vector vdestdelta;
	local float len, traveltime;

    self.finaldest = tdest;
    self.think = DHM_CalcMoveDone;
    if (tdest == cam.origin) { cam.velocity = cam.mangle = '0 0 0'; self.nextthink = time + 0.01; return; }

    vdestdelta = tdest - cam.origin; // Set vdestdelta to the vector needed to move.
    len = vlen (vdestdelta); // Calculate length of vector.
    traveltime = len / tspeed; // Divide by speed to get time to reach dest
    if (traveltime < 0.1) { cam.velocity = cam.mangle = '0 0 0'; self.nextthink = time + 0.01; return; }

    self.nextthink = time + traveltime; // Set nextthink to trigger a think when dest is reached.
    cam.velocity = cam.mangle = vdestdelta * (1/traveltime); // Scale the destdelta vector by the time spent traveling to get velocity.
};

// Zerstorer-only cutscene code.
void() wait_camera = { // [FUNCTION]
    if (!self.wait) {move_camera(); return;}
    
    self.nextthink = time + self.wait;
    self.think = move_camera;
};

// After moving, set origin to exact final destination.
void() DHM_CalcMoveDone = { // [FUNCTION]
    if (!cutscene) {remove(self); return;}

    setorigin(self.enemy, self.finaldest);
    self.enemy.velocity = self.enemy.mangle = '0 0 0';
    if (self.cnt == -1) {remove (self); return;}

    self.nextthink = time + 0.01;
    self.think = wait_camera;
};

void() move_camera = { // [FUNCTION]
	local entity cpt, fpt;
	local vector looky;

    if (!cutscene) {remove (self); return;}

    cpt = find (world, targetname, self.target);
    if (!cpt.target) { // If this is the end of the line, stop camera.
        self.think = SUB_Null;
        self.enemy.velocity = '0 0 0';
        self.enemy.mangle = '0 0 0';     //mangle == velocity in cut-scene
        DHM_CalcMoveDone();
        self.cnt = -1;    // Remove control entity in DHM_CalcMoveDone
    }

    if (cpt.focal_point) { // Is there a new focal point?
        fpt = find (world, targetname, cpt.focal_point);
        if (!fpt) { dprint("Couldn't find new focal point!\n"); cpt.focal_point = ""; return; }

        self.enemy.movedir = fpt.origin;
        looky_x = self.enemy.movedir_x - self.enemy.origin_x;
        looky_y = self.enemy.movedir_y - self.enemy.origin_y;
        looky_z = self.enemy.origin_z - self.enemy.movedir_z;
        self.enemy.oldorigin = vectoangles (looky);
        self.enemy.angles = self.enemy.oldorigin;    //oldorigin == angles in CS
    }

	// Check for auto-focus or still camera angle
    if (cpt.delay) self.enemy.delay = cpt.delay;
    else self.enemy.delay = 0;

    self.target = cpt.target;
    self.wait = cpt.wait;
    if (cpt.speed) self.speed = cpt.speed;
    DHM_CalcMove (cpt.origin, self.speed, self.enemy);    
};

// Change the player into a camera
// PM:  Ok, you win!  Too much stuff checks for 'player', so use 'camera'
// to be safe.  Just make sure alignment stuff doesn't break, namely
// friendly monsters getting mad at a player when they shouldn't.
void() go_camera = { // [FUNCTION]
	local vector looky;
	local entity control;

    cutscene = 1;   // Cutscene ON.

    self.classname  = "camera";
    self.velocity   = '0 0 0';
    self.view_ofs   = '0 0 0';
    // PM:  Change the modelindex to a non-zero number that points to an
    //  invisible model so that the camera entity is invisible if seen
    //  because of reflective textures or builtin chasecam (chase_active 1).
    //  Requires my custom invisible model (which is a sprite).
    self.modelindex  = modelindex_eyes;
    self.effects     = 0; // Turn off glowing effects.
    self.items       = 0;
    self.weaponmodel = "";      // Remove weapon from the screen.
	looky_x = self.movedir_x - self.enemy.origin_x;
	looky_y = self.movedir_y - self.enemy.origin_y;
	looky_z = self.enemy.origin_z - self.movedir_z;
	self.oldorigin = vectoangles (looky);
	self.angles = self.oldorigin;        //oldorigin == angles in CS

    // Check if camera is auto-focus or not
	if (self.enemy.delay) self.delay = self.enemy.delay;
	else self.delay = 0;

	self.velocity = self.mangle = '0 0 0';
	self.dmg         = 0;   // PM:  Do we need this?
	self.fixangle    = 1;        // turn this way immediately
	self.movetype    = MOVETYPE_NOCLIP;
	self.takedamage  = DAMAGE_NO;
	// PM:  Solid cannot be 0 or else camera can't trigger stuff by touch.

    // Spawn a control function to handle moving the camera
	if (self.enemy.target) {
		control = spawn();
		control.classname   = "camcontrol";
		control.enemy       = self;
		control.target      = self.enemy.target;
		control.speed       = self.enemy.speed;
		control.nextthink   = time + self.enemy.wait + 0.05;
		control.think       = move_camera;
	}

	// Setting script_count to 0 is what triggers the script to play,
	// It will then play the script number.
    if (!self.script) dprint ("trigger_camera needs a script number!");
    self.script_count = 0;

    self.cnt = cvar("viewsize");
    cvar_set ("viewsize", "120");     //Full screen
    Safe_stuffcmd (self, "sizedown\nsizeup\n");   //hack-fix for GLquake
    setorigin (self, self.enemy.origin);

	// PM:  Space invasion prevention.
	// Make the dummy solid to prevent monsters or other junk from occupying
	// the space where the player stood before the cutscene started.
	// After all, the player will be placed back when the cutscene ends,
	// and we don't want him stuck inside a monster or something.
	//
	// We need to wait until after the player becomes the camera, before we can
	// make the dummy solid.  If we make the dummy solid as it spawned, the
	// player could get stuck inside the dummy (instead of moving) between
	// trigger activation and transformation to camera.
	//
	// In Zer code, player becomes camera at the same time
	// the trigger activates.

	// 'self' is the player-turned-camera entity.
    // '!self.trigger_field' is the world, and its classname is worldspawn.
    if (self.trigger_field.classname == "dummy") {
        self.trigger_field.solid = SOLID_BBOX;
        setsize (self.trigger_field, self.mins, self.maxs);
        self.trigger_field = world;     // Unlink now that it's done.
    }
};

void() camera_remove = { // [FUNCTION]
    activator = self;
    SUB_UseTargets();
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
};

// PM:  Called from either touch or use.
void(entity who) camera_activate = { // [FUNCTION]
    local entity t, fpt;

    if (intermission_running || cinematic_running || cutscene) return; // Already in a cutscene
	if (!who) return;
    if (who.in_a_vehicle) return;
    if (who.health <= 0) return;
    if (who.deadflag) return; // In case of Alien Quake facehugger kill.
    if (!(who.flags & FL_CLIENT)) return; // only activate for player, 1st time touched.

    self.touch = self.use = SUB_Null; // You can't touch/use this again, once only.
    who.flags = who.flags - (who.flags & FL_ONGROUND); // If player is on ground, take him off ground so no one gets confused
    spawn_dummy(who); // Put a dummy where the player was
    t = find (world, targetname, self.target);
	while ((t != world) && (t.classname != "info_movie_camera")) t = find (t, targetname, self.target);
	if (!t) { dprint("Couldn't find target for cutscene camera_activate! Removed camera trigger.\n"); camera_remove(); return; }

    // Find focal point.
	fpt = find (world, targetname, self.focal_point);
	if (!fpt) { dprint ("You must have a focal point!  Removed camera trigger.\n"); camera_remove(); return; }
	else who.movedir = fpt.origin;    //movedir used to calc focal dir

    who.enemy = t; // Save camera position, etc.
    who.script = self.script; // Save script number
    who.script_delay = self.script_delay;  // Save delay for page 1. Go to the camera later because touch functions are called while looping through c code links.
	SUB_ThinkImmediate(who, go_camera);
	camera_remove(); //Remove the trigger_camera from level
};

void() camera_touch = { // [FUNCTION]
    if (self.targetname && self.nextthink < time) return;
    if (self.cnt == -1) return;

    camera_activate(other);
};
void() camera_point_touch = {camera_activate(other);}; // [FUNCTION]

void() imc_touch = { // [FUNCTION]
	local string temps;

    if (other.classname != "camera") return;
    temps = self.target;
    self.target = self.message;
    SUB_UseTargets();
    self.target = temps;
    if (self.cnt)
        return;

    self.think = SUB_Remove;
    self.nextthink = time + 10;
    self.solid = SOLID_NOT;
};

// This is the destination marker for a camera.  It should have a "targetname" field with the same value as a camera-trigger's "target" field.
void() info_movie_camera = { // [ENTITY]
    self.solid = SOLID_TRIGGER;
    setorigin(self, self.origin);
    setsize(self, '-8 -8 -8', '8 8 8');
    self.touch = imc_touch;
};

void() camera_use = { // [FUNCTION]
	camera_activate(find(world, classname, "player")); // Only one in single-player.
};

// Zerstorer-only cutscene code.
void() gocam_use = { // [FUNCTION]
	local entity control, temp;

    control = find(world, classname, "camcontrol");
	if (control) {
		temp = self;
		self = control;
		DHM_CalcMoveDone();
		self = temp;
	} else dprint ("Can't find control for gocam_use!\n");
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;
};

void() trigger_gocamera = {self.use = gocam_use;}; // [ENTITY]

// This is the point that the camera will face.  It should have a "targetname" field with the same value as a camera-trigger's "focal_point" field.
// PM:  This entity is kept only for map compatibility reasons, otherwise, this entity is redundant.  Use 'info_notnull' instead.
void() info_focal_point = {}; // Just holds a spot for the focal point, [ENTITY]

void(float pt) trigger_camera_spawn = { // [FUNCTION]
	// Update:  Don't let dm or coop muck up cutscenes and vice versa.
    if (deathmatch || coop) {remove (self);  return;}   // PM:  Fix -- abort if removed.

    if (pt) { // PM:  The new way, this is for you Tronyn.
        InitPointTrigger();
        if (!self.targetname)
            self.touch = camera_point_touch;
    } else { // The old way...
        InitTrigger();
        self.touch = camera_touch; // PM:  Must always allow touch because some old maps need it.
    }
    // find the destination
    if (!self.target) { dprint("Camera trigger with no target!\n"); self.touch = SUB_Null; return; }
    self.use = camera_use;
};

// A player touching this will be transported to the corresponding
// info_movie_camera entity.  You must set the "target" field, and put a
// info_movie_camera with a "targetname" field that matches.  The "script"
// key gives a starting script number, and the "script_delay" key is the
// amount of time(seconds) to stay on the first script page.
// If the trigger_camera has a targetname, it will only enter camera mode after it has been fired.
void() trigger_camera = {trigger_camera_spawn(FALSE);}; // [ENTITY]

void() trigger_camera_point = {trigger_camera_spawn(TRUE);}; // [ENTITY]

// Scripting function - dhm
// The original timing idea for scripts was inspired by Zoid.  Study the code for Zoid's CTF, it is an excellent example of good Quake-C coding.
// Also look at all of Quake Command's stuff.  Wedge rules.  Script_play is called from PlayerPreThink() indirectly through Cutscene_Think.
// 'self' is the player (aka "camera")
void() Script_play = { // [FUNCTION]
	local entity scrpt, temp;
    
    scrpt = find (world, script_num, self.script);  
	if (!scrpt) { dprint ("Error: script not found!"); return; }

	if (scrpt.target) {
		temp = self;
		self = scrpt;
		SUB_UseTargets(); // If script has a target...
		self.target = string_null; // ...trigger it once.
		self = temp;
	} 
    self.script_delay = scrpt.script_delay;
    self.script_time = time + 1;
    self.script_count = self.script_count + 1;
    centerprint (self, scrpt.message);
    if (self.script_count == self.script_delay) {
        self.script = scrpt.next_script;
        if (self.script != "0") self.script_count = 0;
        else {
            scrpt.nextthink = time + 3;
            scrpt.classname = "going_back";
            scrpt.think = go_back;
        }
    }
};

// PM:  Player thinking during a cutscene.  Called by 'PlayerPreThink'.  If we are in camera mode, play the script.
void() Cutscene_Think = { // [FUNCTION]
    local entity goback; // PM:  dhm's cutscene code.

	// PM:  Allow player to stop cutscene on any map. Qmaster: Oh heaven yes!
	if (self.impulse && self.script_count != 1000000) {
		self.script_count = 1000000;
		goback = find(world, classname, "going_back");
		if (!goback) { // If cut-scene has ended, and user tries to exit, don't spawn a second go_back control entity.
		   sprint(self, "...\n");
		   goback = spawn(); 
		   goback.nextthink = time + 1.5;
		   goback.think = go_back;
		   self.impulse = 0; // PM:  New -- just kill cutscene.
		}
	}

	if (cutscene) look_ahead();
	if (self.script_count < self.script_delay && self.script_time < time) Script_play();
};

// This is the destination marker for a script.  It should have a "script_num" field that signifies the script number,
// and a "next_script" to signal the next script ("0" if this is the last page of the script), a "script_delay" to
// signify how many seconds to display this page, and of course a "message" field with the text to display.
void() info_script = {}; // [ENTITY], PM:  Use 'info_notnull' instead.