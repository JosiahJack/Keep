//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Entity count: 0
// Function count: 5
//
// Implements: Intermission Camera System
//
// Description:
// SetupIntermissionCamera - Find/setup all camera(s)
// StartIntermissionCamera - Setup player ready for viewing
// NextIntermissionCamera - Move player to first/next camera
// CycleIntermissionCamera - wait for player input
// FinishIntermissionCamera - No more viewing
//=============================================================================

float CAMERA_NOINTERMIS = 1;	// Will not work if intermission active
float CAMERA_SOLID = 2;			// Intermission camera interacts with world
float INTERMISSION_ACTIVE = 2;	// Regular Intermission active
float INTERMISSION_RUNE = 3;	// Check for end of episode
float INTERMISSION_ENDGAME = 4;	// End of game!?! (set in oldone.qc)
float INTERMISSION_CAMERA = 10;	// Special Camera only mode

// Find 1
//   camera_ent is 1
//   prevcam is 1
// Find 2
//   prevcam(1).owner is 2
//   prevcam is 2
// Find 3
//   prevcam(2).owner is 3
//   prevcam is 3
// Loop done
// prevcam(3).owner = camera_ent(1)
// camera_ent(1).owner(2).owner(3).owner(1)
// camera_ent(1).master(3).master(2)

void() SetupIntermissionCamera = {
	local entity intercam, prevcam;

	if (camera_ent) return;	// Intermission camera chain been setup already?

	// Try to find the first intermission camera
	intercam = find (world, classname, "info_intermission");
	prevcam = world;
	if (intercam) {
		// Cycle through all intermission cameras and link them together
		while(intercam) {
			// first camera in chain? setup first and previous camera
			if (!prevcam) { camera_ent = intercam; camera_ent.count = 0; }
			else prevcam.owner = intercam;

			intercam.master = prevcam;
			prevcam = intercam; // Save current camera to previous ready for loop
			camera_ent.count = camera_ent.count + 1;
			if (developer > 1) {
				dprint("[CAM] ("); dprint(ftos(camera_ent.count));
				dprint(") Org ("); dprint(vtos(intercam.origin)); dprint(")\n");
			}	
			intercam = find(intercam, classname, "info_intermission");
		}
		// Close the camera chain
		prevcam.owner = camera_ent;
		camera_ent.master = prevcam;
		dprint("\b[CAMERA]\b Intermissions found (");
		dprint(ftos(camera_ent.count)); dprint(")\n");
	} else {
		dprint("\b[CAMERA]\b Intermissions missing!\n");
		// Cannot find any info_intermission cameras, so use player start
		// If there is no player start then use player's last location!
		if (deathmatch) intercam = find (world, classname, "info_player_deathmatch");
		else intercam = find (world, classname, "info_player_start");
		if (!intercam) intercam = client_ent;
			
		// Spawn a new camera entity
		camera_ent = spawn();
		camera_ent.classtype = CT_CAMERA;
		setsize (camera_ent, VEC_ORIGIN, VEC_ORIGIN);
		camera_ent.movetype = MOVETYPE_NONE;
		camera_ent.solid = SOLID_NOT;
		setorigin(camera_ent, intercam.origin);
		setmodel(camera_ent, MODEL_EMPTY);
		camera_ent.mangle = intercam.angles;
		camera_ent.count = 1;
		camera_ent.owner = camera_ent;
	}
};

void() FinishIntermissionCamera = {
	// skip any text in deathmatch
	if (deathmatch) { GotoNextMap(); return; }
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;

	// Run some text if at the end of an each episode
	if (intermission_running == INTERMISSION_RUNE) {
		if (world.model == "maps/e1m7.bsp") {
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			if (!cvar("registered")) {
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else {
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		} else if (world.model == "maps/e2m6.bsp") {
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		} else if (world.model == "maps/e3m6.bsp") {
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
			return;
		} else if (world.model == "maps/e4m7.bsp") {
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
			return;
		} else if (world.model == "maps/r1m7.bsp") {
			WriteByte(MSG_ALL, SVC_CDTRACK);
			WriteByte(MSG_ALL, 2);
			WriteByte(MSG_ALL, 3);
			WriteByte(MSG_ALL, SVC_FINALE);
			WriteString(MSG_ALL, "Victory! The Overlord's mangled\nremains are the evidence.  His evil\nWrath army?  Cast out to wander\naimlessly throughout time.\n\nAs the Slipgate fog surrounds you,\nthoughts rage into your consciousness:\nHas Quake's oppressive reign ended?\nIs it Salvation, or Damnation, which\nwaits beyond the Vortex?\n\nAnother thought, not quite your own,\nrazors through the haze.  \"Forgiveness\ncan yet be granted; Our Master remains\nto absolve your sins against his Chosen.\nFall down upon your knees-pray for\nQuake's mercy.\"");
			return;
		} else if (world.model == "maps/hip1m4.bsp") {
			WriteByte(MSG_ALL,SVC_CDTRACK);
			WriteByte(MSG_ALL,6);
			WriteByte(MSG_ALL,3);
			WriteByte(MSG_ALL,SVC_FINALE);
			WriteString(MSG_ALL,"Deep within the bowels of the\nResearch Facility, you discover the\npassage that the followers of Quake\nhave used to enter our world.\nThe bastards used some type of\ngigantic teleporter to overload\none of our own slipgates!  As long as\nthis portal ...");
			return;
		} else if (world.model == "maps/hip2m5.bsp") {
            WriteByte(MSG_ALL,SVC_CDTRACK);
            WriteByte(MSG_ALL,6);
            WriteByte(MSG_ALL,3);
            WriteByte(MSG_ALL,SVC_FINALE);
            WriteString(MSG_ALL,"After destroying the power generator,\nyou pass beyond the gate of Mortum's\nKeep.  A wave of nausea suddenly flows\nover you and you find yourself cast\nout into a liquid void.  You float\nlifelessly, yet aware, in a lavender\nsea of energy.");
            return;
        } else if (world.model == "maps/hipend.bsp") {
			WriteByte(MSG_ALL,SVC_CDTRACK);
			WriteByte(MSG_ALL,2);
			WriteByte(MSG_ALL,3);
			WriteByte(MSG_ALL,SVC_FINALE);
			WriteString(MSG_ALL,"After the last echoes of Armagon's\ndeath yell fade away, you breathe a\nheavy sigh of relief.  With the loss\nof his magic, Armagon's fortress\nbegins to collapse.  The rift he\ncreated to send his grisly troops\nthrough time slowly closes and seals\n...");
			return;
        }
		GotoNextMap(); // No special end text? go straight to next map
	} else if (intermission_running == INTERMISSION_ENDGAME) {
		// If the player has all four runes, print more text!?!
		if (!cvar("registered")) {	
			// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		
		if ( (serverflags & SVR_RUNE_ALL) == SVR_RUNE_ALL) {
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
	} else GotoNextMap(); // Finished episode text and shub waking up text, then finally next map!
};

void(float reverse) NextIntermissionCamera = {
	if (camera_ent.count > 1 && intermission_running > 0 && intermission_running < INTERMISSION_CAMERA) { // Exclude the special intermission cameras (special impulse)
		// Cycle through list trying to find a camera.  Designed for the intermission at the end of a map.
		while(self.goalentity.spawnflags & CAMERA_NOINTERMIS) { // Can have special cameras designed for impulse 145!
			self.goalentity = self.goalentity.owner;
		}
	}

	// Switch player view to intermission camera
	self.view_ofs = '0 0 0';
	setorigin(self, self.goalentity.origin);
	self.angles = self.v_angle = self.goalentity.mangle;
	self.fixangle = TRUE; 
	
	// Change the camera to allow for environment interaction
	if (self.goalentity.spawnflags & CAMERA_SOLID) {
		self.solid = SOLID_TRIGGER;
		setsize(self, VEC_HULLE_MIN, VEC_HULLE_MAX);
	} else {
		// no interaction, static
		self.solid = SOLID_NOT;
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	}
	
	// If target exists on camera fire triggers (once)
	if (HasTargets(self.goalentity)) {
		SUB_UseTargetsOnEnt(self.goalentity);
		clear_trigstrs(self.goalentity);
	}

	// CHANGE fog for intermission camera
	if (fog_active && self.goalentity.fog_density > 0) fade_fog(self.goalentity.fog_density, self.goalentity.fog_colour, self.goalentity.speed); // Double check for quake.rc parameter
	if (fog_active && self.goalentity.skyfog_density > 0) fade_skyfog(self.goalentity.skyfog_density, self.goalentity.speed); // Double check for quake.rc parameter
	
	// CHANGE skybox for intermission camera
	if (self.goalentity.skybox != "") {
		trig_skybox = self.goalentity.skybox;
		trigger_skybox_change(self);
	}
};

void() CycleIntermissionCamera = {
	// Is the intermission camera still being setup?
	if (intermission_running < INTERMISSION_ACTIVE) return;
	if (self.waitmin > time) return;		// delay input from keyboard
	
	// check for jump button to exit
	if (self.button1 || self.button2 || (self.button0 && camera_ent.count == 1) ) {
		self.button0 = self.button1 = self.button2 = 0;
		if (intermission_running != INTERMISSION_CAMERA) {
			self.waitmin = time + 1;
			if (time > intermission_exittime) {
				if (self.enemy) {
					if (self.enemy.message != "") {
						self.waitmin = time + 2;
						self.sintermission_running = 3;
						WriteByte(MSG_ALL,SVC_FINALE);
						WriteString(MSG_ALL,self.enemy.message);
						if (self.enemy.message2 != "") {
							self.enemy.message = self.enemy.message2;
							self.enemy.message2 = "";
						} else if (self.enemy.message3 != "") {
							self.enemy.message = self.enemy.message3;
							self.enemy.message3 = "";
						} else if (self.enemy.message4 != "") {
							self.enemy.message = self.enemy.message4;
							self.enemy.message4 = "";
						} else self.enemy = world;
					} else {
						FinishIntermissionCamera();
					}
				} else {
					FinishIntermissionCamera();
				}
			}
		}
	} else if (self.button0 || self.impulse == 10) {
		// Check for attack button or weapon cycling to switch cameras
		self.impulse = 0;
		self.button0 = self.button1 = self.button2 = 0;
		self.waitmin = time + 0.5;
		self.goalentity = self.goalentity.owner;
		dprint("Intermission cycle forward\n");
		NextIntermissionCamera(FALSE); // Shift forward to next camera
	} else if (self.impulse == 12) {
		self.impulse = 0;
		self.button0 = self.button1 = self.button2 = 0;
		self.waitmin = time + 0.5;
		self.goalentity = self.goalentity.master; // Shift reverse to previous camera
		dprint("Intermission cycle reverse\n");
		NextIntermissionCamera(TRUE);
	}
};

void() StartIntermissionCamera = {
	local entity changeleveltrig;
	
	changeleveltrig = self;
	if (camera_ent) {
		self = client_ent; // Switch self to client (stored when client is setup)
		self.enemy = changeleveltrig;
		
		// Switch on notarget so monsters don't attack player.  Add god mode to prevent any damage, is reset on map change
		self.flags = self.flags + (FL_NOTARGET || FL_GODMODE);
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	
		// reset player model to nothing and no world interaction
		self.view_ofs = self.velocity = self.avelocity = '0 0 0';
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;		// no more movement
		self.takedamage = DAMAGE_NO;		// no more damage
		setmodel(self, MODEL_EMPTY);		// Hide player model
		setsize(self, VEC_ORIGIN, VEC_ORIGIN);
		self.weaponmodel = "";		// No vmodel updates
		self.frame = self.weaponframe = 0;	// reset all frames
		self.waitmin = time + 0.5;			// Delay before start
		self.think = SUB_Null;				// Stop player.qc
		ResetPowerSystem(self,0,FALSE); // Finish artifacts timers, except vania items
		self.goalentity = camera_ent; // Setup default - first camera to look through
		// Is there more than 1 camera and intermission time?  Always start at the first camera if using camera test mode
		if (camera_ent.count > 1 && intermission_running > 0) {
			// Randomly pick a camera to cycle forward to
			self.lip = rint(random() * camera_ent.count);
			while (self.lip > 0) {
				self.goalentity = self.goalentity.owner;// Cycle through list
				self.lip = self.lip - 1;				// Keep looping
			}
		}
		NextIntermissionCamera(TRUE); // Switch player to the currently selected camera
		
		// Check if end of map intermission is really running?  Can enter this function via camera test mode (impulse xxx)
		if (intermission_running == 0) intermission_running = INTERMISSION_CAMERA;
		else intermission_running = INTERMISSION_ACTIVE;
	} else FinishIntermissionCamera(); // If camera entity not setup, go straight to next map
};
