//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Arcane Dimensions (AD), id1
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
// Entity count: 2
// Function count: 78
//
// Implements: Shub-Niggurath (vanilla version) and misc_teleporttrain
//
// Description:
// The unholy being that is the main causator of all manner of evil in the four
// original episodes.  Cannot be killed by normal means though will gladly
// bleed to taunt you and remind you of your insignificance.  Also known as the
// Old One, a reference to Chthulu mythos by H.P. Lovecraft from whose writings
// this tentacled horror is derived.
//
// Triggers a final CONGRATULATIONS screen on death with the typical "id
// salutes you!" message, overridable by setting `message` to a custom text.
//
// The misc_teleporttrain is a moving teleport destination used to telefrag
// Shub-Niggurath but also quite useful for randomizing arenas and saving on
// entities, not needing to place many different teleport destinations.
//=============================================================================

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8
$frame idle9 idle10 idle11 idle12 idle13 idle14 idle15 idle16
$frame idle17 idle18 idle19 idle20 idle21 idle22 idle23 idle24
$frame idle25 idle26 idle27 idle28 idle29 idle30 idle31 idle32
$frame idle33 idle34 idle35 idle36 idle37 idle38 idle39 idle40
$frame idle41 idle42 idle43 idle44 idle45 idle46

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8
$frame shake9 shake10 shake11 shake12 shake13 shake14 shake15
$frame shake16 shake17 shake18 shake19 shake20

void() finale_1;
void() finale_2;
void() finale_3;
void() finale_4;

void() idshub_idle1 = [$idle1, idshub_idle2 ] {};
void() idshub_idle2 = [$idle2, idshub_idle3 ] {};
void() idshub_idle3 = [$idle3, idshub_idle4 ] {};
void() idshub_idle4 = [$idle4, idshub_idle5 ] {};
void() idshub_idle5 = [$idle5, idshub_idle6 ] {};
void() idshub_idle6 = [$idle6, idshub_idle7 ] {};
void() idshub_idle7 = [$idle7, idshub_idle8 ] {};
void() idshub_idle8 = [$idle8, idshub_idle9 ] {};
void() idshub_idle9 = [$idle9, idshub_idle10 ] {};
void() idshub_idle10 = [$idle10, idshub_idle11 ] {};
void() idshub_idle11 = [$idle11, idshub_idle12 ] {};
void() idshub_idle12 = [$idle12, idshub_idle13 ] {};
void() idshub_idle13 = [$idle13, idshub_idle14 ] {};
void() idshub_idle14 = [$idle14, idshub_idle15 ] {};
void() idshub_idle15 = [$idle15, idshub_idle16 ] {};
void() idshub_idle16 = [$idle16, idshub_idle17 ] {};
void() idshub_idle17 = [$idle17, idshub_idle18 ] {};
void() idshub_idle18 = [$idle18, idshub_idle19 ] {};
void() idshub_idle19 = [$idle19, idshub_idle20 ] {};
void() idshub_idle20 = [$idle20, idshub_idle21 ] {};
void() idshub_idle21 = [$idle21, idshub_idle22 ] {};
void() idshub_idle22 = [$idle22, idshub_idle23 ] {};
void() idshub_idle23 = [$idle23, idshub_idle24 ] {};
void() idshub_idle24 = [$idle24, idshub_idle25 ] {};
void() idshub_idle25 = [$idle25, idshub_idle26 ] {};
void() idshub_idle26 = [$idle26, idshub_idle27 ] {};
void() idshub_idle27 = [$idle27, idshub_idle28 ] {};
void() idshub_idle28 = [$idle28, idshub_idle29 ] {};
void() idshub_idle29 = [$idle29, idshub_idle30 ] {};
void() idshub_idle30 = [$idle30, idshub_idle31 ] {};
void() idshub_idle31 = [$idle31, idshub_idle32 ] {};
void() idshub_idle32 = [$idle32, idshub_idle33 ] {};
void() idshub_idle33 = [$idle33, idshub_idle34 ] {};
void() idshub_idle34 = [$idle34, idshub_idle35 ] {};
void() idshub_idle35 = [$idle35, idshub_idle36 ] {};
void() idshub_idle36 = [$idle36, idshub_idle37 ] {};
void() idshub_idle37 = [$idle37, idshub_idle38 ] {};
void() idshub_idle38 = [$idle38, idshub_idle39 ] {};
void() idshub_idle39 = [$idle39, idshub_idle40 ] {};
void() idshub_idle40 = [$idle40, idshub_idle41 ] {};
void() idshub_idle41 = [$idle41, idshub_idle42 ] {};
void() idshub_idle42 = [$idle42, idshub_idle43 ] {};
void() idshub_idle43 = [$idle43, idshub_idle44 ] {};
void() idshub_idle44 = [$idle44, idshub_idle45 ] {};
void() idshub_idle45 = [$idle45, idshub_idle46 ] {};
void() idshub_idle46 = [$idle46, idshub_idle1 ] {};

void() idshub_pain1 = [$shake1,  idshub_pain2 ] { lightstyle(0, "m"); };
void() idshub_pain2 = [$shake2,  idshub_pain3 ] { lightstyle(0, "k"); };
void() idshub_pain3 = [$shake3,  idshub_pain4 ] { lightstyle(0, "k"); };
void() idshub_pain4 = [$shake4,  idshub_pain5 ] { lightstyle(0, "i"); };
void() idshub_pain5 = [$shake5,  idshub_pain6 ] { lightstyle(0, "g"); };
void() idshub_pain6 = [$shake6,  idshub_pain7 ] { lightstyle(0, "e"); };
void() idshub_pain7 = [$shake7,  idshub_pain8 ] { lightstyle(0, "c"); };
void() idshub_pain8 = [$shake8,  idshub_pain9 ] { lightstyle(0, "a"); };
void() idshub_pain9 = [$shake9,  idshub_pain10 ] { lightstyle(0, "c"); };
void() idshub_pain10 = [$shake10, idshub_pain11 ] { lightstyle(0, "e"); };

void() idshub_pain11 = [$shake11, idshub_pain12 ] { lightstyle(0, "g"); };
void() idshub_pain12 = [$shake12, idshub_pain13 ] { lightstyle(0, "i"); };
void() idshub_pain13 = [$shake13, idshub_pain14 ] { lightstyle(0, "k"); };
void() idshub_pain14 = [$shake14, idshub_pain15 ] { lightstyle(0, "m"); };
void() idshub_pain15 = [$shake15, idshub_pain16 ] { lightstyle(0, "m");
self.cnt = self.cnt + 1; if (self.cnt < 3) self.think = idshub_pain1; };

void() idshub_pain16 = [$shake16, idshub_pain17 ] { lightstyle(0, "g"); };
void() idshub_pain17 = [$shake17, idshub_pain18 ] { lightstyle(0, "c"); };
void() idshub_pain18 = [$shake18, idshub_pain19 ] { lightstyle(0, "b"); };
void() idshub_pain19 = [$shake19, idshub_pain20 ] { lightstyle(0, "a"); };
void() idshub_pain20 = [$shake20, idshub_pain20 ] { finale_4(); };


// Final thrash, explosion and on screen text waffle

void() finale_1 = { // [FUNCTION]
	intermission_running = INTERMISSION_ENDGAME;	//End of the game!
	intermission_exittime = time + 100000;			// never allow exit

	// find the intermission spot
	self.owner = find (world, classname, "info_intermission");
	if (!self.owner) dprint("Cannot find info_intermission");
		
	// Find misc teleport thing and remove it
	self.enemy = find (world, classname, "misc_teleporttrain");
	if (!self.enemy) dprint("Cannot find teleporttrain");
	else remove (self.enemy);

	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, "");

	// Cycle through all players and reset them as below
	self.enemy = find (world, classname, "player");
	while (self.enemy != world) {
		self.enemy.view_ofs = '0 0 0';
		self.enemy.angles = self.enemy.v_angle = self.owner.mangle;
		self.enemy.fixangle = TRUE;		// turn this way immediately
		self.enemy.map = self.map;
		self.enemy.nextthink = time + 0.5;
		self.enemy.takedamage = DAMAGE_NO;
		self.enemy.solid = SOLID_NOT;
		self.enemy.movetype = MOVETYPE_NONE;
		self.enemy.modelindex = 0;
		setorigin(self.enemy, self.owner.origin);
		self.enemy = find (self.enemy, classname, "player");
	}	
	
	self.nextthink = time + 0.3;
	self.think = finale_2;
	self.count = 10;
};

// Randomnly spawn 10 teleporter sparkle effects
void() finale_2 = { // [FUNCTION]
	if (self.count < 0) finale_3();
	else {
		self.view_ofs_x = crandom()*50; // start a teleport splash inside shub
		self.view_ofs_y = -100;
		self.view_ofs_z = random()*100;
		self.oldorigin = self.origin + self.view_ofs;
		spawn_tfog(self.oldorigin);
		self.count = self.count - 1;
		self.nextthink = time + random()*0.5;
		self.think = finale_2;
	}
};

void() finale_3 = {  // [FUNCTION] Start shub thrashing wildly.
	sound(self,CHAN_VOICE,"boss2/death.wav",1,ATTN_NORM);
	lightstyle(0,"abcdefghijklmlkjihgfedcb");	
	idshub_pain1();
};

// Called after thrash animation (last frame)
void() finale_4 = { // [FUNCTION]
	sound(self,CHAN_VOICE, "boss2/pop2.wav",1,ATTN_NORM); // Play exploding sound
	self.oldorigin = self.origin;

	// Setup temp entity for directional force for gibs
	self.movelast = spawn();
	self.movelast.oldorigin = self.origin - '0 0 -300';
	setorigin(self.movelast, self.movelast.oldorigin);
	setmodel(self.movelast, "progs/q15/misc_broken.mdl");
	self.enemy = self.movelast;

	// loop through old one x/y/z space and throw tons of meat chunks	
	self.count = 16;
	while (self.count > 0) {
		self.view_ofs = vecrand(0,64,TRUE);				// random xyz volume loc
		self.view_ofs_z = 50 + random()*200;			// Extra lift up
		self.origin = self.oldorigin + self.view_ofs;	// Move origin around
		self.health = 0 - random()*200;					// Velocity boast
		
		self.lip = random();
		if (self.lip < 0.1) ThrowGib(1, 1);
		else if (self.lip < 0.3) ThrowGib(2, 1);
		else if (self.lip < 0.5) ThrowGib(4, 1+random()*3);
		else ThrowGib(5, 1+random()*3);

		self.count = self.count - 1;
	}
	// start the end text
	WriteByte (MSG_ALL, SVC_FINALE);
	WriteString (MSG_ALL, self.message);

	// put a player model down
	self.oldorigin = self.oldorigin - '32 264 0';
	setorigin(self.movelast, self.oldorigin);
	setmodel(self.movelast, "progs/player.mdl");
	self.movelast.angles = '0 290 0';
	self.movelast.frame = 1;

	// switch cd track
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, 3);
	WriteByte (MSG_ALL, 3);
	lightstyle(0, "m");

	remove(self);	
};

void(entity inflictor, entity attacker, float damage) idshub_nopain = { self.health = self.max_health; }; // [FUNCTION]

// QUAKED monster_oldone (1 0 0) (-16 -16 -24) (16 16 32)
void() monster_oldone = { // [ENTITY]
	self.mdl = "progs/oldone.mdl";
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	// Use to be 128 square, reduced size to help with
	// radius/splash damage being more effective
	if (self.bboxtype < 1) {
		self.bbmins = '-96 -96 -24';	// has own entity setup
		self.bbmaxs = '96 96 192';
		self.bboxtype = BBOX_CUSTOM;	// Custom BBox size
	}
	self.bossflag = TRUE;			// Boss flag (like FL_MONSTER)
	self.no_liquiddmg = TRUE;		// no slime/lava damage
	self.gibbed = FALSE;			// Still in one piece
	Resist_ChangeType(self,1); // Always reset Ammo Resistance to be consistent
	self.reflectnails = TRUE;		// Reflect nail projectiles
	self.reflectlightning = TRUE;
	self.reflectplasma = TRUE;
	self.reflectaxe = TRUE;			// Prevent axe damage
	if (self.deathstring == "")  self.deathstring = " became one with Shub-Niggurath\n";
	if (self.message == "") self.message = "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salutes you.";
	self.classtype = CT_MONIDSHUB;
	self.classgroup = CG_BOSS;
	if (self.health < 1) self.health = 40000;
	self.max_health = self.health;
	self.think = idshub_idle1;
	self.nextthink = time + 0.1;	
	self.takedamage = DAMAGE_YES;
	self.th_pain = idshub_nopain;
	self.th_die = finale_1;
	self.th_stand = self.th_walk = self.th_run = SUB_Null;
	self.th_missile = SUB_Null;
	monster_start();
};

void() teleporttrain_next;
void() teleporttrain_target = { // [FUNCTION]
	local vector dir;

	if (self.target != "") { // Path following, not entity I/O
		// Find next target entity
		self.enemy = find (world, targetname, self.target);
		if (self.enemy) {
			// Work out distance and angle to turn towards
			dir = normalize(self.enemy.origin - self.origin);
			self.ideal_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin);
			self.velocity = dir * self.speed;
	
			// Shift target to next target in the entity chain
			self.target = self.enemy.target;
			self.nextthink = time + 0.1;
			self.think = teleporttrain_next;
			return;
		}
	}
	// No target or entity to follow, full stop
	self.velocity = '0 0 0';
	self.enemy = world;
};

void() teleporttrain_next = { // [FUNCTION]
	if (!self.enemy) return;

	// Work out how close to the next target (self.enemy)		
	self.t_length = vlen(self.enemy.origin - self.origin);
	if (self.t_length < 64) teleporttrain_target();
	else {
		// Keep checking
		self.nextthink = time + 0.1;
		self.think = teleporttrain_next;
	}		
};

// QUAKED misc_teleporttrain (0 0.5 0.8) (-8 -8 -8) (8 8 8) x
// This is used for the final boss ONLY
// Flying ball needed to teleport kill Shub-Niggurath
// This is used for the final boss ONLY.  Flying ball needed to teleport kill Shub-Niggurath
// Originally used bmodel train functions, setup to work like the shalrath homing missile.
void() misc_teleporttrain = { // [ENTITY]
	self.mdl = "progs/teleport.mdl";
	precache_model (self.mdl);
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_FLY; // Push movetype cannot rotate, fly can
	self.use = teleporttrain_target;
	self.avelocity = vecrand(50,250,FALSE);
	setmodel(self, self.mdl);
	setsize (self, VEC_ORIGIN , VEC_ORIGIN);
	if (!self.speed) self.speed = 100;
	if (SUB_HideIfNoTarget()) return;
};