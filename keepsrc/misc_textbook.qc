//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Function count: 99
//
// Implements: Readable Message System
//
// Description:
// Allows for placing messages in maps that can be read, typically on books,
// but also as brush built or misc_model based objects such as pillars or
// computer screens.  Darkens screen while reading to assist with readability.
// 
// Will only display if player is within the trigger bounds and facing the
// correct angle.  Requires reentry of the player to read if player has left.
//
// Only supports one centerprint message with option for a header plus lower
// text.
//
// The storybook system allows for multiple sequential messages to be read in
// order regardless of which book is found first.  Useful for secret stories.
//=============================================================================

// Closed
$frame closed1 closed2 closed3 closed4 closed5 closed6 closed7 closed8 closed9 closed10

// Idle B - looking around turning left and then right (based on closed)
$frame idleb1 idleb2 idleb3 idleb4 idleb5 idleb6 idleb7 idleb8 idleb9 idleb10
$frame idleb11 idleb12 idleb13 idleb14 idleb15 idleb16 idleb17 idleb18 idleb19 idleb20

// Idle C - spin around 360 degrees (based on closed)
$frame idlec1 idlec2 idlec3 idlec4 idlec5 idlec6 idlec7 idlec8 idlec9 idlec10
$frame idlec11 idlec12 idlec13 idlec14 idlec15 idlec16 idlec17 idlec18 idlec19 idlec20

// Opening (closed -> open)
$frame opening1 opening2 opening3 opening4 opening5 opening6 opening7 opening8 opening9 opening10

// Open
$frame open1 open2 open3 open4 open5 open6 open7 open8 open9 open10

void() book_closed1;
void(float fadedir) info_book_fadesetup;

float MISCBOOK_NOMODEL = 1;		// Will not use any model and particles
float MISCBOOK_PLINTH1 = 2;		// setup and spawn on plinth1
float MISCBOOK_PLINTH2 = 4;		// setup and spawn on plinth2
float MISCBOOK_STORY = 8;		// setup book as part of story
float MISCBOOK_COLLISION = 16;	// Use bounding box collision for plinth
float MISCBOOK_ANGLEONLY = 32;  // Will only work when standing infront of entity
float MISCBOOK_NOEFFECTS = 128;	// Disable particles and effects
float MISCBOOK_FADEOUT = 192;	// Background density while reading books
float MISCBOOK_LOOPADVANCE = 0.01;
float MISCBOOK_CLOSED = 1;
float MISCBOOK_OPENING = 2;
float MISCBOOK_CLOSING = 4;
float MISCBOOK_OPEN = 8;
float MISCBOOK_STAYOPEN = 16;

// Idle B - looking around turning left and then right (based on closed)
void()	book_idleb1 =	[$idleb1, book_idleb2 ] {}; // [FUNCTION]
void()	book_idleb2 =	[$idleb2, book_idleb3 ] {}; // [FUNCTION]
void()	book_idleb3 =	[$idleb3, book_idleb4 ] {}; // [FUNCTION]
void()	book_idleb4 =	[$idleb4, book_idleb5 ] {}; // [FUNCTION]
void()	book_idleb5 =	[$idleb5, book_idleb6 ] {}; // [FUNCTION]
void()	book_idleb6 =	[$idleb6, book_idleb7 ] {}; // [FUNCTION]
void()	book_idleb7 =	[$idleb7, book_idleb8 ] {}; // [FUNCTION]
void()	book_idleb8 =	[$idleb8, book_idleb9 ] {}; // [FUNCTION]
void()	book_idleb9 =	[$idleb9, book_idleb10 ] {}; // [FUNCTION]
void()	book_idleb10 = [$idleb10, book_idleb11 ] {}; // [FUNCTION]
void()	book_idleb11 = [$idleb11, book_idleb12 ] {}; // [FUNCTION]
void()	book_idleb12 = [$idleb12, book_idleb13 ] {}; // [FUNCTION]
void()	book_idleb13 = [$idleb13, book_idleb14 ] {}; // [FUNCTION]
void()	book_idleb14 = [$idleb14, book_idleb15 ] {}; // [FUNCTION]
void()	book_idleb15 = [$idleb15, book_idleb16 ] {}; // [FUNCTION]
void()	book_idleb16 = [$idleb16, book_idleb17 ] {}; // [FUNCTION]
void()	book_idleb17 = [$idleb17, book_idleb18 ] {}; // [FUNCTION]
void()	book_idleb18 = [$idleb18, book_idleb19 ] {}; // [FUNCTION]
void()	book_idleb19 = [$idleb19, book_idleb20 ] {}; // [FUNCTION]
void()	book_idleb20 = [$idleb20, book_closed1 ] {}; // [FUNCTION]

// Idle C - spin around 360 degrees (based on closed)
void()	book_idlec1 =	[$idlec1, book_idlec2 ] {}; // [FUNCTION]
void()	book_idlec2 =	[$idlec2, book_idlec3 ] {}; // [FUNCTION]
void()	book_idlec3 =	[$idlec3, book_idlec4 ] {}; // [FUNCTION]
void()	book_idlec4 =	[$idlec4, book_idlec5 ] {}; // [FUNCTION]
void()	book_idlec5 =	[$idlec5, book_idlec6 ] {}; // [FUNCTION]
void()	book_idlec6 =	[$idlec6, book_idlec7 ] {}; // [FUNCTION]
void()	book_idlec7 =	[$idlec7, book_idlec8 ] {}; // [FUNCTION]
void()	book_idlec8 =	[$idlec8, book_idlec9 ] {}; // [FUNCTION]
void()	book_idlec9 =	[$idlec9, book_idlec10 ] {}; // [FUNCTION]
void()	book_idlec10 = [$idlec10, book_idlec11 ] {}; // [FUNCTION]
void()	book_idlec11 = [$idlec11, book_idlec12 ] {}; // [FUNCTION]
void()	book_idlec12 = [$idlec12, book_idlec13 ] {}; // [FUNCTION]
void()	book_idlec13 = [$idlec13, book_idlec14 ] {}; // [FUNCTION]
void()	book_idlec14 = [$idlec14, book_idlec15 ] {}; // [FUNCTION]
void()	book_idlec15 = [$idlec15, book_idlec16 ] {}; // [FUNCTION]
void()	book_idlec16 = [$idlec16, book_idlec17 ] {}; // [FUNCTION]
void()	book_idlec17 = [$idlec17, book_idlec18 ] {}; // [FUNCTION]
void()	book_idlec18 = [$idlec18, book_idlec19 ] {}; // [FUNCTION]
void()	book_idlec19 = [$idlec19, book_idlec20 ] {}; // [FUNCTION]
void()	book_idlec20 = [$idlec20, book_closed1 ] {}; // [FUNCTION]

// Book closed
void()	book_closed1 =	[$closed1, book_closed2	] { // [FUNCTION]
	self.state = MISCBOOK_CLOSED;
	if (random() <	0.1 && self.search_time < time) {
		self.search_time = time + 2 + (random()*5);
		self.lefty = 1 - self.lefty;
		if (self.lefty > 0) book_idleb1();	// Turn left and right
		else book_idlec1();					// spin around
	}
};
void()	book_closed2 =	[$closed2, book_closed3 ] {}; // [FUNCTION]
void()	book_closed3 =	[$closed3, book_closed4 ] {}; // [FUNCTION]
void()	book_closed4 =	[$closed4, book_closed5 ] {}; // [FUNCTION]
void()	book_closed5 =	[$closed5, book_closed6 ] {}; // [FUNCTION]
void()	book_closed6 =	[$closed6, book_closed7 ] {}; // [FUNCTION]
void()	book_closed7 =	[$closed7, book_closed8 ] {}; // [FUNCTION]
void()	book_closed8 =	[$closed8, book_closed9 ] {}; // [FUNCTION]
void()	book_closed9 =	[$closed9, book_closed10 ] {}; // [FUNCTION]
void()	book_closed10 =	[$closed10, book_closed1 ] {}; // [FUNCTION]

// Book closing (open -> close)
void()	book_closing1 =	[$opening10, book_closing2	] { // [FUNCTION]
	self.state = MISCBOOK_CLOSING;
	self.search_time = time + 2 + (random()*5); // make sure book idles don't start straight away
};
void()	book_closing2 =	[$opening9, book_closing3	] {}; // [FUNCTION]
void()	book_closing3 =	[$opening8, book_closing4	] {}; // [FUNCTION]
void()	book_closing4 =	[$opening7, book_closing5	] {}; // [FUNCTION]
void()	book_closing5 =	[$opening6, book_closing6	] {}; // [FUNCTION]
void()	book_closing6 =	[$opening5, book_closing7	] {}; // [FUNCTION]
void()	book_closing7 =	[$opening4, book_closing8	] {}; // [FUNCTION]
void()	book_closing8 =	[$opening3, book_closing9	] {}; // [FUNCTION]
void()	book_closing9 =	[$opening2, book_closing10	] {}; // [FUNCTION]
void()	book_closing10= [$opening1, book_closed1	] {}; // [FUNCTION]

// Book always open (final stage of book)
void()	book_stayopen1 = [$open1, book_stayopen2 ] { self.state = MISCBOOK_STAYOPEN;}; // [FUNCTION]
void()	book_stayopen2 = [$open2, book_stayopen3 ] {}; // [FUNCTION]
void()	book_stayopen3 = [$open3, book_stayopen4 ] {}; // [FUNCTION]
void()	book_stayopen4 = [$open4, book_stayopen5 ] {}; // [FUNCTION]
void()	book_stayopen5 = [$open5, book_stayopen6 ] {}; // [FUNCTION]
void()	book_stayopen6 = [$open6, book_stayopen7 ] {}; // [FUNCTION]
void()	book_stayopen7 = [$open7, book_stayopen8 ] {}; // [FUNCTION]
void()	book_stayopen8 = [$open8, book_stayopen9 ] {}; // [FUNCTION]
void()	book_stayopen9 = [$open9, book_stayopen10 ] {}; // [FUNCTION]
void()	book_stayopen10 = [$open10, book_stayopen1 ] {}; // [FUNCTION]

// Players has walked away, decide what to do with the book
void() book_finish = { // [FUNCTION]
	info_book_fadesetup(-1);
	if (self.enemy.flags & FL_CLIENT) {	
		self.enemy.suppressCenterPrint = FALSE; // Clear client centerprint suppression
		centerprint(self.enemy, "");
	}
	if (self.pain_finished > 0) book_stayopen1();
	else book_closing1();
};

// Book is open (waiting to close)
void()	book_open1 = [$open1, book_open2 ] { self.state = MISCBOOK_OPEN;}; // [FUNCTION]
void()	book_open2 = [$open2, book_open3 ] { if (self.wait < time) book_finish(); }; // [FUNCTION]
void()	book_open3 = [$open3, book_open4 ] {}; // [FUNCTION]
void()	book_open4 = [$open4, book_open5 ] { if (self.wait < time) book_finish(); }; // [FUNCTION]
void()	book_open5 = [$open5, book_open6 ] {}; // [FUNCTION]
void()	book_open6 = [$open6, book_open7 ] { if (self.wait < time) book_finish(); }; // [FUNCTION]
void()	book_open7 = [$open7, book_open8 ] {}; // [FUNCTION]
void()	book_open8 = [$open8, book_open9 ] { if (self.wait < time) book_finish(); }; // [FUNCTION]
void()	book_open9 = [$open9, book_open10 ] {}; // [FUNCTION]
void()	book_open10= [$open10, book_open1 ] { if (self.wait < time) book_finish(); }; // [FUNCTION]

// Book opening (closed -> open)
void()	book_opening1 =	[$opening1, book_opening2 ] { self.state = MISCBOOK_OPENING;}; // [FUNCTION]
void()	book_opening2 =	[$opening2, book_opening3 ] {}; // [FUNCTION]
void()	book_opening3 =	[$opening3, book_opening4 ] {}; // [FUNCTION]
void()	book_opening4 =	[$opening4, book_opening5 ] {}; // [FUNCTION]
void()	book_opening5 =	[$opening5, book_opening6 ] {}; // [FUNCTION]
void()	book_opening6 =	[$opening6, book_opening7 ] {}; // [FUNCTION]
void()	book_opening7 =	[$opening7, book_opening8 ] {}; // [FUNCTION]
void()	book_opening8 =	[$opening8, book_opening9 ] {}; // [FUNCTION]
void()	book_opening9 =	[$opening9, book_opening10 ] {}; // [FUNCTION]
void()	book_opening10 = [$opening10, book_open1 ] {}; // [FUNCTION]

void() info_book_fade = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;

	self.lip = self.lip + (self.height * 4); // Fade direction needs to be -1 or +1 (0.48s fade time)
	if (self.lip <= 0) self.lip = 0; // Check if fade has reached 0 or max screen fade value
	else if (self.lip >= MISCBOOK_FADEOUT) self.lip = MISCBOOK_FADEOUT;
	else self.nextthink = time + MISCBOOK_LOOPADVANCE;
	
	// Only update the screen if the debuff system is NOT active and the client does NOT have any powerups active.
	if (!self.enemy.cshift_upd && (self.enemy.items & ALL_ITEMSARTIFACTS == 0)&& (self.enemy.items2 & ALL_ITEMS2ARTIFACTS == 0) && (self.enemy.moditems & ALL_MODITEMSARTIFACTS == 0)) {	
		Safe_stuffcmd(self.enemy, "v_cshift 0 0 0 "); // Change screen background density (makes text easier to read)
		Safe_stuffcmd(self.enemy, ftos(self.lip));
		Safe_stuffcmd(self.enemy, "\n");
	}
};

void(float fadedir) info_book_fadesetup = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;

	// Is the fade controller setup?
	if (self.attachment) {
		if (fadedir > 0 && self.attachment.lip == MISCBOOK_FADEOUT) return; // Double check if screen fade is setup already
		if (fadedir < 0 && self.attachment.lip == 0) return;
		
		// Copy over client and fadedir to controller
		self.attachment.enemy = self.enemy;
		self.attachment.height = fadedir;
		self.attachment.think = info_book_fade;
		self.attachment.nextthink = time + MISCBOOK_LOOPADVANCE;
		self.attachment.ltime = self.attachment.nextthink;
	}
};

void() info_book_displaystory = { // [FUNCTION]
	// Is this book part of a storyline?  The controller has been setup/validated already.
	if (self.spawnflags & MISCBOOK_STORY) {
		self.spawnflags = self.spawnflags - (self.spawnflags & MISCBOOK_STORY); // Check controller once!
		if (self.attachment.estate == ESTATE_OFF) self.message = "Story controller broken!\n\n";
		else { // Copy over story chapter
			self.message = self.attachment.oldenemy.message;
			self.message2 = self.attachment.oldenemy.message2;
			self.message3 = self.attachment.oldenemy.message3;
			self.message4 = self.attachment.oldenemy.message4;
		}

		// Work out which centerprint to use
		if (self.message3 != "" && self.message4 != "") self.cnt = 2;
		else if (self.message3 != "") self.cnt = 1;
		else self.cnt = 0;

		// Move controller on to next story chapter
		if (self.attachment.height < self.attachment.count) {
			self.attachment.count = self.attachment.count + 1;
			self.attachment.oldenemy = self.attachment.oldenemy.oldenemy;
		}
	}

	self.enemy.suppressCenterPrint = TRUE; // Suppress any other centerprint messages and show story

	// Check for any additional strings and use correct centerprint.  The engine function will merge several strings together.
	if (self.cnt == 1) centerprint_msg3(self.enemy, self.message, self.message2, self.message3);
	else if (self.cnt == 2) centerprint_msg4(self.enemy, self.message, self.message2, self.message3, self.message4);
	else centerprint_msg(self.enemy, self.message, self.message2);

	// Check for any additional trigger events
	if (self.target != "") { // No need to do all targets, special setup for target2
		trigger_strs(self.target, self.enemy);
		self.target = "";
	}
};

void() info_book_touch = { // [FUNCTION]
	local float book_yaw, book_angle1, book_angle2, play_yaw, play_angle;

	if (self.estate & ESTATE_BLOCK) return;
	if (intermission_running > 0) return;		// intermission or finale
	if (cinematic_running > 0 || cutscene > 0 || other.in_a_vehicle > 0) return;
	if ( !(other.flags & FL_CLIENT) ) return;
	if (other.health < 1) return;
		
	self.enemy = other; // Store player entity for later use
	if (self.spawnflags & MISCBOOK_ANGLEONLY) {
		play_angle = anglemod(self.enemy.v_angle_y+360); // Check the players facing direction against book angle direction make sure the player angle is never negative, + 360 just in case.
		book_yaw = fabs(self.v_angle_y - self.v_angle_x); // Work out angle cone based on book angle direction; use previously defined angles for viewing angle of book.
		book_angle1 = anglemod(self.angles_y + 180 + (360-book_yaw));
		book_angle2 = anglemod(self.angles_y + 180 + book_yaw);
		if (play_angle < book_angle1 || play_angle > book_angle2) return; // Is the players angle outside the book's viewing range?
	}
	
	// The angle at the which the book is facing the player
	// book_yaw = vectoyaw(self.enemy.origin - self.origin);
	// book_angle = anglemod((self.angles_y - book_yaw) + 0);
	// The angle the player is facing towards the book (45 = forward)
	play_yaw = vectoyaw(self.origin - self.enemy.origin);
	play_angle = anglemod((self.enemy.v_angle_y - play_yaw) + 45);

	// Is the player looking at the book?
	if (play_angle > self.v_angle_x && play_angle < self.v_angle_y) {
		if (self.state == MISCBOOK_CLOSED) { // Is the book closed?
			self.wait = time + 1.3;
			book_opening1();
		} else if (self.state == MISCBOOK_STAYOPEN) { // Is the book currently open and been read before?
			info_book_fadesetup(1);
			self.wait = time + 0.3;
			self.attack_finished = time + 0.2;
			book_open1();
		} else if (self.state == MISCBOOK_OPEN && self.pain_finished == FALSE) { // Has the book just opened and never been read before?
			self.pain_finished = TRUE;
			info_book_fadesetup(1);
			self.wait = time + 0.3;
			self.attack_finished = time + 0.2;
			if (self.part_emitter) misc_particle_update(self.part_emitter, PARTICLE_STYLE_OPENBOOK);
			info_book_displaystory();
		} else if (self.state == MISCBOOK_OPEN) { // Is the book open and ready for a story?
			info_book_fadesetup(1);
			self.wait = time + 0.3;
			if (self.attack_finished < time) {
				self.attack_finished = time + 0.2;
				info_book_displaystory();
			}
		}
	}
};

void() info_book_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	if ( !(self.spawnflags & MISCBOOK_NOMODEL) ) {
		setmodel(self, self.mdl);
		self.skin = self.exactskin;
	}

	if (self.part_emitter) misc_particle_on(self.part_emitter); // Make sure particle emitter is turned on
	self.touch = info_book_touch; // Setup touch trigger and function
	setsize (self, self.pos1, self.pos2);
	
	// If no model, don't need book animations + attachment models
	if ( !(self.spawnflags & MISCBOOK_NOMODEL) ) {
		if (self.attachment2) { // Check for any plinth models
			if (self.spawnflags & MISCBOOK_COLLISION) self.attachment2.solid = SOLID_BBOX; // Use bounding box coillsion?
			else self.attachment2.solid = SOLID_NOT;
			setmodel(self.attachment2,self.noise1);
		}

		self.search_time = time + 5 + (random()*5);	// delay idle animation

		// Setup book in correct animation state
		if (self.state == MISCBOOK_CLOSED) book_closed1();
		else book_stayopen1();
	}
};

void() info_book_off =  { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.solid = SOLID_NOT;
	setmodel(self, "");
	self.touch = self.think = SUB_Null; // Stop any touch/animations
	if (self.attachment) { // Check if the screen is faded?
		if (self.attachment.lip != 0) {
			self.attachment.lip = 0;
			if (!self.enemy.cshift_upd && (self.enemy.items & ALL_ITEMSARTIFACTS == 0) && (self.enemy.items2 & ALL_ITEMS2ARTIFACTS == 0) && (self.enemy.moditems & ALL_MODITEMSARTIFACTS == 0)) {	
				Safe_stuffcmd(self.enemy, "v_cshift 0 0 0 0\n");
			}
		}
	}
	
	SUB_FinishAttachment2(); // If any plinth exists, turn that off as well but preserve self.attachment controller.
};

void() info_book_setup = { // [FUNCTION]
	self.attachment = spawn(); // Setup book fade controller
	self.attachment.owner = self;
	self.attachment.classtype = CT_CONTROL;
	self.attachment.movetype = MOVETYPE_NONE;
	setorigin(self.attachment,self.origin + '0 0 32');
	setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);

	// Check for plinth and spawn/setup
	if (self.mdl != "" && self.noise1 != "") {
		self.attachment2 = spawn();
		self.attachment2.owner = self;
		self.attachment2.classtype = CT_MISCMODEL;
		self.attachment2.movetype = MOVETYPE_NONE;
		
		// Trace downward to find the ground and place plinth
		traceline (self.origin, self.origin + '0 0 -512', TRUE, self);
		self.origin = trace_endpos + '0 0 32';
		setorigin(self.attachment2, self.origin);
		self.attachment2.angles = self.angles;
		if (self.spawnflags & MISCBOOK_PLINTH2) self.origin = self.origin + '0 0 4'; // Plinth2 has flat surface which conflicts with book angle.
	}

	if (self.randomskin > 1) self.exactskin = rint(random()*(self.randomskin-1)); // Check for random skin options.

	// The particle colours are based on the book skin
	if (self.exactskin < 1) self.exactskin = 0;
	if (self.exactskin >= 6) self.style = MISCBOOK_RED;
	else if (self.exactskin >= 4) self.style = MISCBOOK_BLUE;
	else self.style = MISCBOOK_GREEN;
	
	// Default viewing angle is min 30 and max 60 looking at origin
	if (CheckZeroVector(self.v_angle)) self.v_angle = '30 60 0';
	if (self.angles_y == 0) self.angles_y = 360;

	// Check for story book setup first
	// Story is supplied from story system when book is opened
	if (self.spawnflags & MISCBOOK_STORY) {
		// Reset all storybook message strings
		self.message = "Waiting for story!"; 
		self.message2 = "";
		self.message3 = ""; self.message4 = "";
		self.cnt = 0;
		self.attachment = find(world, targetname, self.target2);
		// Is this entity a storybook controller?
		if (!self.attachment || self.attachment.classtype != CT_STORYCONTROL)
		{
			dprint("\b[STORYBOOK]\b Missing controller!\n");
			spawn_marker(self.origin, SPNMARK_YELLOW);
			entity_hide(self);
			return;
		}
	} else { // Setup default message for testing.
		if (self.message == "") self.message = "\b--[ Dark Elder Magic ]--\b\n\n";
		if (self.message2 == "") self.message2 = "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import.\n";

		// Check for additional strings to display.  This is to fix quark editor limit of 128 characters per string.
		if (self.message3 != "" && self.message4 != "") self.cnt = 2;
		else if (self.message3 != "") self.cnt = 1;
		else self.cnt = 0;
	}

	if ( !(self.spawnflags & MISCBOOK_NOMODEL) ) {
		self.part_active = PARTICLE_STYLE_BOOK;
		if (self.spawnflags & ENT_STARTOFF) self.count = PARTICLE_START_OFF;
		else self.count = PARTICLE_START_ON;

		if (query_configflag(SVR_PARTICLES) == SVR_PARTICLES) {
			if (!(self.spawnflags & MISCBOOK_NOEFFECTS) && self.part_active > 0) self.part_emitter = spawn_pemitter(self, self, self.part_active, self.count); // Spawn particle emitter if particles active and not blocked
		}
	}

	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = info_book_on;
	self.estate_off = info_book_off;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

// QUAKED misc_textbook (0 0.5 0.5) (-16 -16 -8) (16 16 8) NOMODEL PLINTH1 PLINTH2 STORY COLLISION ANGLEONLY STARTOFF NOEFFECTS
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target     : trigger event when book is opened (only works once)
// target2    : name of story controller (only works with spawnflag)
// angle      : facing angle for model or direction player must be standing
// v_angle    : The viewing angle the book is active (def=30,60,0)
// exactskin  : skin number for book (1-8, Brown1/2,Green1/2,Blue1/2,Red1/2)
// pos1       : Touch trigger minimin size (def=-48 -48 -32)
// pos2       : Touch trigger maximum size (def=48 48 32)
// message    : header message
// message2   : Body Text 1 (need to add linefeeds)
// message3   : Body Text 2 (displayed after message2)
// message4   : Body Text 3 (displayed after message3)
// -------- SPAWNFLAGS --------
// NOMODEL   : Will not use book model + particles
// PLINTH1   : Setup book on top of plinth1 model
// PLINTH2   : Setup book on top of plinth2 model
// STORY     : Book is part of a story (use target2)
// COLLISION : Use bounding box collision for plinth
// ANGLEONLY : Will only work when standing infront of entity (angle key)
// STARTOFF  : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Display custom text messages
// Maximum size of message is 1024 characters, 256 is the original limit
void() misc_textbook = { // [ENTITY]
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.classtype = CT_STORYBOOK;
	if (CheckZeroVector(self.pos1)) self.pos1 = '-48 -48 -32'; // Setup large bounding box for touch trigger
	if (CheckZeroVector(self.pos2)) self.pos2 = '48 48 32';
	self.takedamage = DAMAGE_NO;	// No damage from anything
	if (self.spawnflags & MISCBOOK_NOMODEL) {
		self.mdl = "";
		self.state = MISCBOOK_STAYOPEN;	// no book animation
		self.pain_finished = TRUE;		// No read delay
	} else {
		self.state = MISCBOOK_CLOSED;	// Current state
		self.pain_finished = FALSE;		// Book not read yet
		// Default medieval book
		self.mdl = "progs/ad171/misc_textbook.mdl";
		precache_model (self.mdl);
		self.noise1 = "";

		// Check for any predefined plinth model setups
		if (self.spawnflags & MISCBOOK_PLINTH1) {
			self.noise1 = "progs/ad171/misc_plinth1.mdl";
			precache_model(self.noise1);
		} else if (self.spawnflags & MISCBOOK_PLINTH2) {
			self.noise1 = "progs/ad171/misc_plinth2.mdl";
			precache_model(self.noise1);
		}
	}

	self.nextthink = time + 0.1 + random()*0.4; // Don't spawn straight away
	self.think = info_book_setup;
};

void() info_bookcont_setup = { // [FUNCTION]
	local entity storychap, prevchap;
	
	// Is there any story chapters?
	storychap = find(world, targetname, self.target);
	if (!storychap) {
		dprint("\b[STORYCTRL]\b Missing start chapter!\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		return;
	}

	// Can only link to story chapter entities
	if (storychap.classtype != CT_STORYCHAPTER) {
		dprint("\b[STORYCTRL]\b First chapter wrong entity!\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		return;
	}
	
	// Setup controller
	prevchap = self;	// Start controller at chapter 1
	self.count = 0;		// Total chapters in story
	self.height = 1;	// Current chapter in story
	
	// Work through list
	while (storychap) {
		spawn_marker(storychap.origin, SPNMARK_BLUE); // Visual debug for chapters
		prevchap.oldenemy = storychap; // Link chapters and move forward
		prevchap = storychap;
		self.count = self.count + 1;
		if (prevchap.target == "") storychap = world; // Check for next target in chain
		else storychap = find(world, targetname, prevchap.target);
	}
	
	prevchap.oldenemy = prevchap; // Point final chapter at itself
	self.estate = ESTATE_ON; // Controller finally active
	spawn_marker(self.origin, SPNMARK_GREEN); // Visual debug for controller
	dprint("\b[STORYCTRL]\b Chapters found ("); // Console message for chapters found
	dprint(ftos(self.count));
	dprint(")\n");
};

// QUAKED misc_textstoryctrl (0 0.1 1.0) (-16 -16 -8) (16 16 8) x
// -------- KEYS --------
// targetname : name of controller for story
// target : name of first chapter
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Text Book Story Controller
void() misc_textstoryctrl = { // [ENTITY]
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.classtype = CT_STORYCONTROL;
	// Start in disabled state until chapters setup
	self.estate = ESTATE_OFF;
	if (self.target == "") { // Not using SUB_HideIfNoTarget, special case that doesn't hide and prints unique message.
		dprint("\b[STORYCTRL]\b Missing story start!\n"); 
		spawn_marker(self.origin, SPNMARK_YELLOW);
		return;
	}
	
	// Wait for chapter and books to spawn first
	self.nextthink = time + 1 + random();
	self.think = info_bookcont_setup;
};

// QUAKED misc_textstory (0 0.5 1.0) (-16 -16 -8) (16 16 8) x
// -------- KEYS --------
// targetname : name of current chapter
// target     : name of next chapter
// message    : header message
// message2   : Body Text 1 (need to add linefeeds)
// message3   : Body Text 2 (displayed after message2)
// message4   : Body Text 3 (displayed after message3)
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Text Book Story Chapters
void() misc_textstory = { // [ENTITY]
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.classtype = CT_STORYCHAPTER;
};