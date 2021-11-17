//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD) and Drake by Patrick Martin
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
// Entity count: 3
// Function count: 12
//
// Implements: Music
//
// Description:
// Triggers and point entities for changing the global engine played music and
// for playing specialty music using entities setup in map corners for faked
// stereo (Drake idea, clever dude).
//
//  Drake MUSIC (Custom addition) - Secondary Music in addition to engine's:
//    Two entities to play music.
//    For music to play from both speakers, we need two edicts, with each at
//    the opposite points of the map, diametrically opposed.
//
//    Two speaker entities are not enough to guarantee stereo sound, Four
//    speakers in each corner of the xy-plane are required.
//
//    Tying up four entities permanently for stereo sound is a bit much. Two
//    entities it is!
//
//    Qmaster: Technically 8, but whatever.
//=============================================================================

entity  stereo1, stereo2;
float drakemusic;

void(string text, float dur) PlayMusic;

void() trigger_cdtrack_change = { // [FUNCTION]
	msg_entity = self;
	WriteByte (MSG_ALL, SVC_CDTRACK); // Write CD track to all clients
	WriteByte (MSG_ALL, trig_cdtrack);
	WriteByte (MSG_ALL, trig_cdtrack);
};

void() trigger_cdtrack_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check for entity state system block
	
	trig_cdtrack = self.count; // Make sure CD track change in savefile
	trigger_cdtrack_change(); // Write message to all clients
};

// QUAKED trigger_cdtrack (0.8 0.5 0) (-8 -8 -16) (8 8 16) x
// -------- KEYS --------
// targetname : trigger entity
// count      : CD track number (eg. 0-x)
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Change CD track for all clients
void() trigger_cdtrack = { // [ENTITY]
	self.classtype = CT_TRIGCDTRACK;
	self.classgroup = CG_TARGETS;
	if (check_nightmare() == TRUE) return; // Check for firing conditions (nightmare, coop)
	if (check_coop() == TRUE) return;
	if (SUB_HideIfNoTargetname()) return;

	self.count = fabs(rint(self.count)); // Make sure specified cd track is integer number
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trigger_cdtrack_use;
	self.estate = ESTATE_ON;
};

void() SpawnStereo = { // [FUNCTION]
	// One placed at the low end.
    if (!stereo1) {
        stereo1 = spawn();
        stereo1.movetype  = MOVETYPE_NONE;
        stereo1.solid     = SOLID_NOT;
        stereo1.classname = "stereo1";
        stereo1.noise     = "";
        stereo1.lefty     = 0;
        setorigin (stereo1, '-4000 -4000 -4000');
    }

	// Other placed at the high end.
    if (!stereo2) {
        stereo2 = spawn();
        stereo2.movetype  = MOVETYPE_NONE;
        stereo2.solid     = SOLID_NOT;
        stereo2.classname = "stereo2";
        setorigin (stereo2, '4000 4000 4000');
    }
};

// Function for non-looped music.
void() ReplayMusic = {PlayMusic (self.noise, self.wait);}; // [FUNCTION]

// Note:  The sound played should be looped.
// 'dur' - Looped sounds should use 0.  Unlooped sounds should use non-zero.
void(string text, float dur) PlayMusic = { // [FUNCTION]
    if (text == "") return; // No music to play.

	// Channel:  Use channel 7 instead of the random CHAN_AUTO.
	// Volume:  Always use max volume.  Client has a volume knob on hardware.
	// Attenuation:  Distance is not a factor, so use ATTN_NONE.
    SpawnStereo(); // Create stereo entities if necessary.
    if (text == "misc/null.wav") {
        stereo1.lefty = 1;
        dur = 0;    // In case of idiot code.
    } else {
        if (!stereo1.lefty && stereo1.noise == text) return;     // Already playing the same music.

        stereo1.noise = text; // Set the music.
        stereo1.wait = dur;
		if (!drakemusic) return; // Turned off.

		stereo1.lefty = 0;
    }

    if (stereo1) sound(stereo1, 7, text, 1, ATTN_NONE);
    if (stereo2) sound(stereo2, 7, text, 1, ATTN_NONE);
    if (dur) {
        stereo1.nextthink = time + dur;
        stereo1.think     = ReplayMusic;
    }  else {   
        stereo1.nextthink = 0; // Assumed looped.
        stereo1.think = SUB_Null;
    }
};

void() MusicStart_Think = { // [FUNCTION]
    if (self.cnt) {
        self.nextthink = time + 0.1;
        self.think = MusicStart_Think;

		// At the start of a level, we cannot play music as soon as a client is detected.  We must delay the music a frame so the client can hear the music.
        if (find (world, classname, "player")) {
            self.cnt = 0;
            if (deathmatch || coop) self.nextthink = time + 3; // Give more time for all to spawn.
        }
        return;
    }

    PlayMusic(self.noise, self.wait); // Client was detected earlier.
};

// This should only be called by worldspawn.
void() InitMusic = { // [FUNCTION]
    local string music1, music2, music3;
    local float abort;

	drakemusic = TRUE;
    stereo1 = stereo2 = world;
    abort = TRUE;
    if (world.noise) music1 = world.noise;
    else music1 = world.noise1;
    music2 = world.noise2;

    music3 = world.noise3;
    if (music1 != "") {abort = FALSE;  precache_sound (music1);}
    if (music2 != "") {abort = FALSE;  precache_sound (music2);}
    if (music3 != "") {abort = FALSE;  precache_sound (music3);}
    if (abort) return; // No music to play.

    SpawnStereo();
	// Hack:  SoE music doesn't loop.
	// halo     = 1:17:998 (78)
	// shadows  = 0:49:920 (50)
	// soultrap = 1:18:713 (79)
    // Replay music roughly 70 sec. after end.
    if ((music1 == "music/halo.wav") || (music1 == "music/soultrap.wav")) stereo1.wait = 150;
    else if (music1 == "music/shadows.wav") stereo1.wait = 120;

    stereo1.cnt       = 1;
    stereo1.lefty     = 1;
    stereo1.noise = stereo1.noise1  = music1;   // Start music.
    stereo1.noise2    = music2;   // End of level music.
    stereo1.noise3    = music3;   // End of episode music.
    stereo1.nextthink = time + 0.2;     // Wait until other stuff spawns.
    stereo1.think     = MusicStart_Think;
};

// Toggles music on and off.  It is not really a cheat, but since music
// only works in single-player, might as well lump it with the rest of the
// single-player exclusive features.
void() Toggle_Music = { // [FUNCTION]
    if (!drakemusic) {
		drakemusic = TRUE;
        PlayMusic(stereo1.noise,stereo1.wait);
        sprint(self,"Secondary music ON\n");
    } else {
		drakemusic = FALSE;
        PlayMusic ("misc/null.wav", 0);
        sprint(self,"Secondary music OFF\n");
    }
};

void() IntermissionMusic = { // [FUNCTION]
	if (!stereo1) return;

	if (intermission_running >= 2) PlayMusic(stereo1.noise3,0);
	else PlayMusic(stereo1.noise2,0);
};

void() tmusic_use = { // [FUNCTION]
	
    PlayMusic(self.noise, self.wait);
    SUB_UseTargets ();
    self.touch      = SUB_Null; // We can't just remove (self) here, because this could be a touch function.
    self.nextthink  = time + 0.1;
    self.think      = SUB_Remove;
};

void() tmusic_touch = { // [FUNCTION]
    if (!(other.flags & FL_CLIENT)) return;

	activator = other;
	tmusic_use();
};

void() trigger_music_spawn = { // [FUNCTION]
    if (!self.noise) {remove (self);  return;}

    precache_sound (self.noise);
    if (self.targetname) self.use = tmusic_use;
    else self.touch = tmusic_touch;
};

void() trigger_music = {InitTrigger ();  trigger_music_spawn ();}; // [ENTITY]

void() trigger_music_point = {InitPointTrigger ();  trigger_music_spawn ();}; // [ENTITY]