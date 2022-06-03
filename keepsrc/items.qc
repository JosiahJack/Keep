//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Many, though main systems are Arcane Dimensions (AD) based.
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
// Entity count: 20
// Function count: 35
//
// Implements: Item System
//
// Description:
// Contains the systems and entity definitions for items such as ammo, health,
// powerups, weapons, and other miscellaneous pickups.
//=============================================================================

void(entity e) senddevdata; // Used to tally up ammo, health, etc.
float AIRTANK_SILENT = 8;	// No sound with airtank
float ITEM_CKEY1 = 1;	// Custom Key 1
float ITEM_CKEY2 = 2;	// Custom Key 2
float ITEM_CKEY3 = 4;	// Custom Key 3
float ITEM_CKEY4 = 8;	// Custom Key 4
string WEAPON_PICKUP = "weapons/pkup.wav"; // Used for weapons only
string AMMO_PICKUP   = "weapons/lock4.wav"; // Used for ammo, custom items, and backpacks

// Default respawn timers for items
float RESPAWN_HEALTH = 20;		// 15,25,100+
float RESPAWN_ARMOR = 20;		// Green, Yellow, Red
float RESPAWN_WEAPON = 30;		// SG -> LG
float RESPAWN_AMMO = 30;		// Shells,Nails,Rockets,Cells
float RESPAWN_KEY = 60;			// Gold,Silver,Custom
float RESPAWN_RUNE = 60;		// Sigil/runes
float RESPAWN_ARTIFACT1 = 60;	// Quad + Suit
float RESPAWN_ARTIFACT2 = 300;	// Pent + Invisibilty
float RESPAWN_BACKPACK = 30;	// Random Ammo Drop
float RESPAWN_COOP = 5;			// Default timer for coop
float RESPAWN_PARTICLES = 32;	// Particle burst for ring/center
float RESPAWN_EXPTIME = 1;		// Particles burst lifetime
float RESPAWN_EXPRADIUS = 12;	// Particle ring radius

void() weapon_touch;
void() ammo_touch;
void() item_estate_setup;
float GetWepIDIndex (float wep, float inhackbank);
vector GetWepIT_FromID(float id);

// Some items have pickup conditions which prevent targets from firing when coop mode is active, show console warning
void() item_coopcheck = { // [FUNCTION]
	if (coop <= 0) return; // coop active?
	if (self.progspawnlist) return; // Coop checks for prog list done elsewhere
	if (!HasTargets(self)) return; // No need to warn about targets if not set.
 
	dprint("\b[Coop]\b (");
	dprint(self.classname);
	dprint(") unreliable target(s) in coop on item at: '\n");
	dprint(ftos(self.origin_x)); dprint(" "); dprint(ftos(self.origin_y)); dprint(" "); dprint(ftos(self.origin_z));
	dprint("'\n");
};

// Check floor under item and animated skin for new BASE health boxes
void() item_thinkloop = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Check for entity states
	if (self.attack_finished > time) return; // Has the item been turned off?
	if (self.item_expired > 0 && self.item_expired < time) remove(self); // Has the item removal timer been reached?
	
	// Revisit this once we have an updated model for Mjolnir (the mod, not the weapon, well ok both).
	//if (self.classtype == CT_MJOLNIR) {
	//	if (random() < 0.4) make_glitter();
	//}

	if (self.item_skinanim > 0) {
		self.item_skincycle = self.item_skincycle + 1;
		if (self.item_skincycle > 3) {
			self.item_skincycle = 0;
			self.item_skinanim_no = self.item_skinanim_no + 1;
			if (self.item_skinanim_no > 3) self.item_skinanim_no = 0;
		}
		self.skin = self.item_skinanim_no; // Update skin
	}

	if (self.item_flrcheck > 0) { // Check floor below item (global function)
		ent_floorcheck(self, self.item_flrcheck);
		self.oldorigin = self.origin; // Record any movement for respawn function
	}
	self.think = item_thinkloop; // Keep checking
	self.nextthink = time + 0.1;
};

// Reset trigger_once conditions
void() item_reset = { // [FUNCTION]
	self.attack_finished = 0; 
	if (!self.estate_on) item_estate_setup();
	self.estate_on();
};

void(string defaultmdl, float defaultskin) item_setupmodel = { // [FUNCTION]
	if (self.mdl != "") {
		dprint("\b[ITEMS]\b "); dprint(self.classname);
		dprint(" with Custom override mdl ("); dprint(self.mdl);
		dprint(")\n");
	} else {
		self.mdl = defaultmdl;
		if (self.exactskin == 0) {
			if (self.randomskin > 1) self.skin = rint(random()*(self.randomskin-1));
			else self.skin = defaultskin; 
		} else self.skin = self.exactskin; // HUD skin priority (ckeyhudskin > exactskin > skin)
		if (self.skin < 0) self.skin = 0;
		if (self.ckeyhudskin == 0) self.ckeyhudskin = self.skin;
	}
	if (self.mdl != "") precache_model(self.mdl);
};

void(string defaultnoise) item_setupnoise = { // [FUNCTION]
	if (self.noise == "") self.noise = defaultnoise;
	if (self.noise != "") precache_sound(self.noise);
};

// Check for coop respawn options.  This system can easily be abused by switching coop on/off, but its better the respawns are added, rather than not.
void() item_finished = { // [FUNCTION]
	if (coop > 0 && self.respawn_time > 0) {
		if (self.classgroup == CG_WEAPON && coop_weapons == FALSE) self.spawnflags = self.spawnflags | ITEM_RESPAWN; // This is just crazy back to front logic!  The id default is respawning weapons for coop which means coop_weapons is FALSE when TRUE!!!	
		else if (self.classgroup == CG_HEALTH && coop_health) self.spawnflags = self.spawnflags | ITEM_RESPAWN;
		else if (self.classgroup == CG_AMMOITEM && coop_ammoboxes) self.spawnflags = self.spawnflags | ITEM_RESPAWN;
		else if (self.classgroup == CG_ARTIFACT && coop_powerups) self.spawnflags = self.spawnflags | ITEM_RESPAWN;
	}
	self.attack_finished = LARGE_TIMER;
	if (!self.estate_off) item_estate_setup();
	self.estate_off();
};

void() item_respawn = { // [FUNCTION]
	// Create respawn effect if particles enabled.
	if (query_configflag(SVR_PARTICLES)) {
		if (self.respawn_part.classtype == CT_PARTICLEEMIT) misc_particle_off(self.respawn_part); // Switch off any respawn emitter.

		if (self.respawn_style & PARTICLE_BURST_RING) 
			particle_ring(self.origin + self.respawn_ofs, '0 0 4', '4 4 16', RESPAWN_EXPRADIUS, RESPAWN_PARTICLES, RESPAWN_EXPTIME, self.respawn_style ); 
		else if (self.respawn_style & PARTICLE_BURST_CENTER)
			particle_explode(self.origin + self.respawn_ofs, RESPAWN_PARTICLES*2, RESPAWN_EXPTIME, self.respawn_style, self.respawn_style); 
	}
	
	sound (self, CHAN_VOICE, SOUND_RESPAWN, 1, ATTN_NORM); // Classic quake re-spawn sound
	self.alpha = 1;
	self.estate_reset();
};

// Re-direction for map hacks (not used normally)
void() SUB_regen = { sound (self, CHAN_VOICE, SOUND_RESPAWN, 1, ATTN_NORM); item_reset(); }; // [FUNCTION]

void() alphafade_item_respawn = { // [FUNCTION]
	if (self.waitmin > time) {
		self.speed = 1 - ((self.waitmin - time) / self.respawn_time);
		self.alpha = 0.1 + ((self.speed*0.4)*random());

		// If respawn effect active, modify total particles
		if (self.respawn_part.part_style == PARTICLE_STYLE_RESPAWN) self.respawn_part.part_limit = rint(RESPAWN_PARTICLES * self.speed);
		self.think = alphafade_item_respawn;
		self.nextthink = time + 0.1;
	} else item_respawn();
};

void() start_item_respawn = { // [FUNCTION]
	if (self.waitmin > time) return; // Is the item being respawned at the moment?
	
	// Is the item setup to instantly respawn? (time = -1)
	if (self.respawn_time < 1 && self.spawnflags & ITEM_RESPAWN) {
		// Check for any respawn quantity counts and disable further respawns.
		if (self.respawn_count > 0) {
			self.respawn_count = self.respawn_count - 1;
			if (self.respawn_count == 0) self.spawnflags = self.spawnflags - (self.spawnflags & ITEM_RESPAWN);
		}
		item_respawn(); // Instantly spawn item.
	} else {
		// deathmatch 2 is the silly old rules
		if (deathmatch == 1 || self.spawnflags & ITEM_RESPAWN) {
			setmodel(self,self.mdl);
			setsize (self, self.bbmins, self.bbmaxs);
			self.waitmin = time + self.respawn_time;
			self.alpha = 0.1;

			// Check for any respawn quantity counts and disable further respawns.
			if (self.respawn_count > 0) {
				self.respawn_count = self.respawn_count - 1;
				if (self.respawn_count == 0) self.spawnflags = self.spawnflags - (self.spawnflags & ITEM_RESPAWN);
			}
			
			// Are particles enabled?
			if (query_configflag(SVR_PARTICLES)) {
				if (self.part_emitter) misc_particle_off(self.part_emitter); // Switch off any particle emitters.
				
				// Is there any need for respawn effect?
				if (self.respawn_effect) {
					// If emitter does not exist? create one, else switch on.
					if (self.respawn_part.classtype == CT_PARTICLEEMIT) misc_particle_on(self.respawn_part);
					else self.respawn_part = spawn_pemitter(self, self, PARTICLE_STYLE_RESPAWN, PARTICLE_START_ON);
				}
			}
			alphafade_item_respawn(); // Switch on gradual alpha fade.
		}
	}
};

void() item_use = { // [FUNCTION]
	// Check for any trigger respawn conditions first
	// Respawn spawnflag, trigger condition and not trigger once
	if (self.spawnflags & ITEM_RESPAWN && self.respawn_trig &&
		self.estate == ESTATE_OFF) start_item_respawn();
	else {
		// usual trigger blocks, OFF, DISABLE and trigger_ONCE
		if (self.estate & ESTATE_BLOCK) return;
		if (self.attack_finished > time) return;

		// Was item setup to be floating?
		if(self.spawnflags & ITEM_FLOATING){
			// Removed checkbottom check, it often fails and leaves items floating in midair when they should fall
			// A quick toss of the item instead
			self.movetype = MOVETYPE_TOSS;	
			self.origin_z = self.origin_z + 4;
			self.flags = self.flags - (self.flags & FL_ONGROUND);
		}
	}
};

void() item_touch = { // [FUNCTION]
	if (self.touchedvoid) {entity_hide(self); return;}
	if (self.estate & ESTATE_BLOCK) return;
	if ( !(other.flags & FL_CLIENT) ) return;
	if ( other.health < 1 ) return;
	if (self.attack_finished > time) return;

	// Check for and allow for purchases in versus survivor mode
	if (coop > 2 && other.versustype == VT_SURVIVOR && self.cost > 0) {
		if (other.usingfinished > time) {
			if (coins >= self.cost) {
				coins = coins - self.cost;
				other.usingfinished = 0;
			} else {
				centerprint(other,"You do not have enough for this.");
				return;
			}
		} else {
			centerprint3(other,"Press \b'e'\b to purchase for ",ftos(self.cost)," coins.");
			return;
		}
	}

	self.touch2(); // Defined by item_start.
};

void() item_restore = { // [FUNCTION]
	// Ammo boxes can have special animation frames or lids!
	if (self.classgroup == CG_AMMOITEM) {
		// Any lid (shells/spikes) defined?
		if (self.spawnflags & A_LID && self.attachment) {
			// Setup lid attachment entity (match angles/origin)
			self.attachment.solid = SOLID_NOT;
			self.attachment.movetype = self.movetype;
			setmodel(self.attachment, self.headmdl);
			setsize(self.attachment, self.mins, self.maxs); // Give the lid the same bbox setup so it can move
			setorigin(self.attachment, self.origin + '0 0 1'); // Start lid off the ground and remove ground flag.  This will let the lid naturally settle on the surface.
			self.attachment.flags = self.attachment.flags - (self.attachment.flags & FL_ONGROUND);
			self.attachment.angles = self.angles; // Match angle and stored frame setup from ammo box.
			
			// Always generate a new lid position for respawning items.  lid frame options -1/0=random, 1-7=exact
			if (self.frame_box <= 0) self.attachment.frame = rint(1 + random()*6);
			else if (self.frame_box > 7) self.frame_box = 1;

			if (self.frame_box > 0) self.attachment.frame = self.frame_box;
			if (self.classtype == CT_AMMOSHELLS) self.attachment.skin = self.skin; // Lid has different skins for shells and spikes
			else self.attachment.skin = 2 + self.skin;
		} else if (self.frame_override) {
			// Any special frames (rockets/plasma) defined?
			// Always generate a new frame number for respawning items.  frame options -1=random 0=nothing, 1-7=exact
			if (self.frame_box == -1) self.frame = rint(1 + random()*6);
			else if (self.frame_box > 7) self.frame_box = 1;

			if (self.frame_box > 0) self.frame = self.frame_box;
		}
	}
	
	// Setup animated textures for old style ID health boxes.  Check floor under item for any changes.
	if (self.item_flrcheck > 0 || self.item_skinanim > 0 || self.classtype == CT_MJOLNIR) {
		self.nextthink = time + random()*0.5;
		self.think = item_thinkloop;
	}
};

void() item_delay = { // [FUNCTION]
	if (self.touchedvoid) {entity_hide(self); return;}
	if (self.estate == ESTATE_DISABLE) return;
	
	// Check for Axe / Shotgun / LG upgrade monster spawn exceptions?
	if (self.upgrade_axe || self.upgrade_ssg || self.upgrade_lg) {
		// Has ANY player (server test not individual) 
		// picked up the relevant upgrade weapons?
		if (self.upgrade_axe && !query_configflag(SVR_UPDAXE) ) return;
		if (self.upgrade_ssg && !query_configflag(SVR_UPDSSG) ) return;
		if (self.upgrade_lg && !query_configflag(SVR_UPDLG) ) return;
	}

	// Reset use function and any touch/skin triggers
	self.estate_use = item_use;
	self.touch = item_touch;
	self.attack_finished = 0;
	self.estate = ESTATE_ON;
	
	// Setup enough parameters to test drop to floor
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	setmodel(self,self.mdl);
	setsize (self, self.bbmins, self.bbmaxs);
	setorigin(self, self.oldorigin);
	self.velocity = '0 0 0';
	
	// Check if item is floating? = does not interact with world
	if(self.spawnflags & ITEM_FLOATING) {
		if (self.item_flrcheck > 0) self.item_flrcheck = 0; // Cannot check the floor of an item if its floating!
	} else {
		// Finalize item location (check drop to floor)
		// Need this movetype for items to move with bmodels
		self.movetype = MOVETYPE_TOSS;	
		self.velocity = '0 0 0';
		self.origin_z = self.origin_z + 6;
		// ID originally used a droptofloor test for space check
		// Tried a pointcontents check but it can allows things
		// to fall through the floor and just keep going
		//if (pointcontents(self.origin) == CONTENT_SOLID) {
		if (!droptofloor()) {
			dprint("\n\b[Item]\b "); dprint (self.classname);
			dprint(" didn't droptofloor at ("); dprint(vtos(self.origin)); 
			// The item is stuck, might still be useful to the player
			// Originally the item was removed which is not super useful
			// The mapper should see the console warning and yellow marker
			// Changed to check for origin in solid instead
			if (pointcontents(self.origin) == CONTENT_SOLID) {
				dprint (") and was also placed in a solid, removed!\n");
				remove(self); 
			}
			dprint(") but was in open space and thus left intact.\n");
			return;
		} 
	}

	// Toss velocity is designed for breakable objects to spawn items
	// Will add forward/up velocity to an item so it does not get stuck
	// Has to happen after the droptofloor otherwise position is wrong
	if (self.item_tossvel > 0) {
		self.movetype = MOVETYPE_TOSS; // Make sure item can fly/move
		self.velocity = '0 0 0';
		self.flags = self.flags - (self.flags & FL_ONGROUND); // Must remove onground flag otherwise velocity does nothing.
		makevectors(self.angles);
		self.velocity = v_forward * self.item_tossvel; // Push the item in the angle direction
		self.velocity_z = self.velocity_z + self.item_tossvel; // Push the item upward to make it travel
	}
	
	if (self.item_flrcheck > 0) self.item_flrcheck = fabs(self.mins_z) + 16; // If check floor under item enabled, workout distance check.  Use the bottom of the bounding box + 16 for step height.
	
	// Spawn particle emitter if particles active and not blocked
	if (query_configflag(SVR_PARTICLES) == SVR_PARTICLES) {
		if (!(self.spawnflags & ITEM_NOEFFECTS) && self.part_active > 0) self.part_emitter = spawn_pemitter(self, self, self.part_active, PARTICLE_START_ON);
	}

	self.oldorigin = self.origin; // Finally setup entity ready for use
	
	// Remove the START OFF functionality
	if (self.spawnflags & ENT_STARTOFF) {
		self.spawnflags = self.spawnflags - ENT_STARTOFF;
		// Check for respawn effect?
		if (self.spawnflags & ITEM_RESPAWN) start_item_respawn();
		else item_restore();
	} else item_restore();
};

void() item_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_NONE;
	if (self.classtype == CT_SHROOM) dprint("...item...on!?!?!\n");
	if (self.savedeffects > 0) self.effects = self.savedeffects; // Restore any effect flags settings (various dlight glows)
	
	// Check for delayed/trigger_once functionality?
	if (self.spawnflags & ENT_STARTOFF || self.attack_finished > time) {
		if (self.classtype == CT_SHROOM) dprint("...hiding shroom!?!?!\n");
		self.solid = SOLID_NOT;
	} else {
		// Restore movement, solid and model parameters
		if(self.spawnflags & ITEM_FLOATING) self.movetype = MOVETYPE_NONE;
		else self.movetype = MOVETYPE_TOSS;
		self.solid = SOLID_TRIGGER;
		setmodel(self,self.mdl);
		setsize (self, self.bbmins, self.bbmaxs);
		self.velocity = '0 0 0';
		// Restore particle emitter
		if (self.part_emitter) misc_particle_on(self.part_emitter);
		// Setup touch/damage/bounding box functionality
		self.think = SUB_Null;
		item_restore();
		if (self.classtype == CT_SHROOM) dprint("finished shroom!\n");
	}
};

void() item_off =  { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self,"");
	self.effects = 0;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	if( !(self.spawnflags & ITEM_FLOATING) ) setorigin(self, self.oldorigin); // If item was setup to float then it will be trigger item, so don't reset origin as it might have fallen somewhere better.
	SUB_FinishAttachments();
};

void() item_estate_setup = { // [FUNCTION]
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = item_on;
	self.estate_off = item_off;
	self.estate_use = item_delay;
	self.estate_reset = item_reset;
};

void() item_start = { // [FUNCTION]
	self.oldorigin = self.origin;		// Save origin
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.flags = self.flags | FL_ITEM;
	if (world.devdata & DEV_AMMO_N_HEALTH) senddevdata(self);
	if (self.effects) self.savedeffects = self.effects; // Save effects flag before spawning because we need to...
	self.effects = 0; // ...reset effects flag because some engines will show effects.  This is especially obvious for delay spawned items.
	
	// Check for Axe / Shotgun item exceptions?
	if (self.upgrade_axe || self.upgrade_ssg) {
		if ( !(self.spawnflags & ENT_STARTOFF) ) {
			dprint("\b[ITEM]\b need spawn delay for axe/shotgun\n");
			spawn_marker(self.origin, SPNMARK_YELLOW);
			remove(self);
			return;
		}
	}

	if (self.respawn_time < 0) self.respawn_trig = TRUE; // If respawn timer negative then wait for a trigger
	if (self.respawn_time > 0 && self.respawn_time < 1) self.respawn_time = 1; // Respawn times < 1 break sound and particle spawners
	if (self.respawn_count < 0) self.respawn_count = 1; // Cannot start with a negative number for counting down

	// Override default item pickup sound with silence?
	// It would have been good to offer the other sounds (1-6)
	// on all items, but there is a good chance that a mapper
	// has left a rogue sounds key on some item somewhere!
	if (self.sounds == 4) self.noise = SOUND_EMPTY;

	// Check if item is part of a progression spawner list
	// Hide all progression items, only required for caching
	if (self.progspawnlist) item_proglist_setup(self);
	else {
		// Check for spawning conditions (nightmare, coop)
		if (check_nightmare() == TRUE) return;
		if (check_coop() == TRUE) return;
	
		item_estate_setup(); // Setup Entity State functionality
		if (self.spawnflags & ENT_STARTOFF) self.estate_off();
		else {
			if (self.classtype == CT_SHROOM) { item_on(); return; }
			// delay drop to floor to make sure all doors have been spawned
			// spread think times so they don't all happen at same time
			self.nextthink = time + 0.1 + random()*0.5;
			self.think = self.estate_use;
		}
	}
};

float(entity hpplayer, entity hpitem) health_pickupcondition = { // [FUNCTION]
	if (hpplayer.health <= 0) return TRUE; // Simple test first, player dead?
	if ((hpitem.classtype == CT_HEALMEGA && hpplayer.health >= hpplayer.mega_health)) return TRUE; // Mega Health pickups are awkward because the player can keep picking them up, unless they are at max HP already!
	else if (hpplayer.health >= hpplayer.max_health) return TRUE; // Regular Health pack can be wasteful with amount
	return FALSE; // Health Pack good to use!
};

// targ - entity to receive healing
// t_healamount - the quanity to heal entity with
// ignore - whether to ignore max health amount
// returns FALSE if cannot heal entity by healamount
// returns TRUE if healamount applied
float (entity targ, float t_healamount, float ignore) T_Heal = { // [FUNCTION]
	dprint("T_Heal targets health: "); dprint(ftos(targ.health));
	dprint(", max_health: "); dprint(ftos(targ.max_health));
	dprint(", and mega_health: "); dprint(ftos(targ.mega_health));
	if (targ.health <= 0) return FALSE;
	if ((!ignore) && (targ.health >= targ.max_health)) return FALSE;
	
	t_healamount = ceil(t_healamount);
	targ.health = targ.health + t_healamount;
	if ((!ignore) && (targ.health >= targ.max_health)) targ.health = targ.max_health;
	if (targ.health > targ.mega_health) targ.health = targ.mega_health;
	return TRUE;
};

void() health_touch = { // [FUNCTION]
	// Megahealth?  Ignore max_health...
	if (self.classtype == CT_HEALMEGA) {
		if (other.health >= other.mega_health) return;
		if (!T_Heal(other, self.healamount, 1)) return;
	} else {
		if (!T_Heal(other, self.healamount, 0)) return;
		if (self.classtype == CT_HEALVIAL) ResetDebuffRotting(other);
	}

	health_touchrandomizer(); // Check for randomizer megahealth
	ResetDebuffBurning(other); // Healing the player negates some debuffs
	ResetDebuffPoisoned(other);
	sprint(other, "You receive ");
	sprint(other, ftos(self.healamount));
	sprint(other, " health\n");
	if (self.noise != SOUND_EMPTY) sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	Safe_stuffcmd (other, "bf\n");
	activator = other;
	SUB_UseTargets();

	// Megahealth = rot down the player's super health
	// Moved functionality to debuff (rotting) system
	// Rotting_Qty is set to zero (default) on item spawn
	if (self.classtype == CT_HEALMEGA && !(self.perms & POW_REGEN || self.perms & POW_ARMORBERSERKER || self.perms & POW_REGENLESSER)) RotDeBuff(other, self.rotting_qty);
	if (self.progspawnlist) return; // Quick exit, no need for following stuff
	
	item_finished();
	if (!self.respawn_trig) start_item_respawn();
};

// QUAKED item_health (0.3 0.3 1) (-16 -16 0) (16 16 32) ROTTEN MEGA x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/health_25.mdl"); }
// 15, 25 or 100 Health
// -------- KEYS --------
// targetname    : toggle state (use trigger ent for exact state)
// angle         : = -1 Random rotation everytime spawned (default)
// skin_override : Override world type 1=Base Green, 2=Medieval Wood
// healamount    : Override heal quantity for pickup (def=15/25/100)
// message       : centerprint message when item is picked up
// respawn_time  : time to wait before respawning (1-x seconds, default varies)
// respawn_count : Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// -------- SPAWNFLAGS --------
// ROTTEN   : 15 health
// MEGA     : MegaHealth +100 health, rot down to 100
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Health box gives 15, 25 or 100 points depending on spawnflags.
void() item_health = { // [ENTITY]
	if (health_checkrandomizer() == TRUE) return;
	
	if (self.spawnflags & H_ROTTEN) {
		// worldtype 0 = medieval, 1 = metal, 2 = base
		if (self.skin_override == 2) {
			self.mdl = MODEL_HEAL15; // New Medieval style red flask
			self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
		} else {
			self.mdl = MODEL_HEAL15B; // Original ID pickup model
			self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
		}
		item_setupnoise(SOUND_HEAL15);
		if (self.healamount < 1) self.healamount = HEAL_ROT;
		self.classtype = CT_HEALROT;
		self.respawn_effect = TRUE;
		self.respawn_ofs = '0 0 16';
	} else if (self.spawnflags & H_MEGA) {
		if (self.skin_override == 2) { // New Medieval style red flask
			self.mdl = MODEL_HEAL100;
			self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
		} else { // Original ID pickup model
			self.mdl = MODEL_HEAL100B;
			self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
			self.item_skinanim = TRUE;
		}
		item_setupnoise(SOUND_HEAL100);
		if (self.healamount < 1) self.healamount = HEAL_MEGA;
		self.classtype = CT_HEALMEGA;
		self.part_active = PARTICLE_STYLE_MEGAH;
		self.respawn_effect = TRUE;
		self.respawn_ofs = '0 0 28';
		self.rotting_qty = 0; // Use default rotting value
	} else {
		if (self.skin_override == 2) {
			self.mdl = MODEL_HEAL25; // New Medieval style red flask
			self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_RING;
			self.respawn_ofs = '0 0 24';
		} else {
			if (self.mdl == "") self.item_skinanim = TRUE;
			item_setupmodel(MODEL_HEAL25B,0); // Original ID pickup model
			self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
			self.respawn_ofs = '0 0 16';
		}
		item_setupnoise(SOUND_HEAL25);
		if (self.healamount < 1) self.healamount = HEAL_NORM;
		self.classtype = CT_HEALNORM;
		self.respawn_effect = TRUE;
	}
	
	// Query console variable 'temp1' for model upgrade option.
	// Cannot use global vars because they don't exist at this point
	// Move the new centered ammo models to match old ammo origin
	// The default is to move all ammo items to suit original id maps
	if (query_configflag(SVR_ITEMOFFSET) == FALSE) {
		self.oldorigin = self.origin + '16 16 0';
		setorigin(self, self.oldorigin);
	}
	
	if (world.no_item_rotate && self.angles_y == 0) self.angles_y = 360; // Will force all items to have an angle	
	if (self.angles_y <= 0) self.angles_y = rint(random()*359); // Setting the angle key in the editor to UP/DOWN/0 = random rotation	
	self.touch2 = health_touch;
	self.classgroup = CG_HEALTH;
	self.bbmins = VEC_ITEM_MIN;
	self.bbmaxs = VEC_ITEM_MAX;
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_HEALTH;
	item_coopcheck();
	item_start ();
};

// Redirect for Nehahra medieval healthkit
void() item2_health = { // [ENTITY]
	self.skin_override = 2;
	self.classname = "item_health";
	item_health();
};

// QUAKED item_healthvial (0.3 0.3 1) (-8 -8 0) (8 8 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad181/health_5.mdl"); }
// Health item giving 2-5 points
// -------- KEYS --------
// targetname    : toggle state (use trigger ent for exact state)
// angle         : = -1 Random rotation everytime spawned (default)
// healamount    : Override heal quantity for pickup (def=2+random*3)
// message       : centerprint message when item is picked up
// respawn_time  : time to wait before respawning (1-x seconds, default varies)
// respawn_count : Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// -------- SPAWNFLAGS --------
// RESPAWN   : Can respawn after being picked up
// FLOAT     : No drop to floor test
// STARTOFF  : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Health item giving 5 points
void() item_healthvial = { // [ENTITY]
	self.classtype = CT_HEALVIAL;
	self.respawn_effect = TRUE;
	self.respawn_ofs = '0 0 20';
	item_setupmodel(MODEL_HEAL5,0);
	if (self.healamount < 1) self.healamount = rint(2 + (random() * 3));
	item_setupnoise(SOUND_HEAL05);
	self.respawn_style = PARTICLE_BURST_RED + PARTICLE_BURST_CENTER;
	self.touch2 = health_touch;
	self.classgroup = CG_HEALTH;
	self.bbmins = '-8 -8 0';
	self.bbmaxs = '8 8 32';
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_HEALTH;
	item_coopcheck();
	item_start ();
};

void() item_healthgem = { item_healthvial(); } // [ENTITY], Used to be called a gem, renamed to vial

void() item_health_potion = { item_healthvial(); } // [ENTITY] From drake, redirect

// KEYS (Silver, Gold and Custom)
void() key_touchbindmsg = { // [FUNCTION]
	sound (self.enemy, CHAN_VOICE, SOUND_TALK, 1, ATTN_NORM);
	centerprint(self.enemy, "Press 'i' Key to open Inventory\nTo see what \bArcane keys\b you have!\n");
};

// Check if player has the key already
float(entity keyplayer, entity keyitem) key_pickupcondition = { // [FUNCTION]
	if (keyitem.classtype == CT_CUSTOMKEY) return (keyplayer.moditems & keyitem.moditems);
	return (keyplayer.items & keyitem.items);
};

void() key_touch = { // [FUNCTION]
	if (key_pickupcondition(other, self)) return;
	
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other,"\n");
	if (self.noise != SOUND_EMPTY) sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	Safe_stuffcmd(other, "bf\n");
	
	// Add key to player inventory (items / customkey)
	if (self.moditems > 0) {
		other.moditems = other.moditems | self.moditems;
		// Store the key netname on the player/client for door ref later
		// Skin number is used by the ClientServerQC AD HUD
		// Sanity range check are done in the HUD, just in case!
		if (self.moditems & IT_CKEY1) {
			other.ckeyname1 = self.netname;
			other.ckeyskin1 = self.ckeyhudskin;
		} else if (self.moditems & IT_CKEY2) {
			other.ckeyname2 = self.netname;
			other.ckeyskin2 = self.ckeyhudskin;
		} else if (self.moditems & IT_CKEY3) {
			other.ckeyname3 = self.netname;
			other.ckeyskin3 = self.ckeyhudskin;
		} else {
			other.ckeyname4 = self.netname;
			other.ckeyskin4 = self.ckeyhudskin;
		}
	} else if (self.items2 > 0) {
		other.items2 = other.items2 | self.items2;
		dprint("Gave items2 value of "); dprint(ftos(self.items2)); dprint("\n");
	} else other.items = other.items | self.items; // Add silver/gold key to player inventory

	// Setup respawn for co-op
	if (coop > 0 && self.respawn_time > 0) {
		self.respawn_time = RESPAWN_COOP;
		self.spawnflags = self.spawnflags | ITEM_RESPAWN;
	}

	activator = other;
	SUB_UseTargets();
	if (self.progspawnlist) return; // Quick exit, no need for following stuff

	item_finished(); // hide item and check for respawn
	if (!self.respawn_trig) start_item_respawn();
	if (coop > 0) self.target = ""; // Triggers events work once in co-op
	
	// Warn player about new key binding for inventory (first time only)
	if (self.moditems > 0 && other.ckeyhint == FALSE) {
		self.enemy = other;		// Store for later
		// Check if custom key message is suppressed?
		if (self.ckeyhint == TRUE) other.ckeyhint = TRUE;
		else {
			other.ckeyhint = TRUE;	// Only works once
			self.think = key_touchbindmsg;
			self.nextthink = time + 3;
		}
	}
};

void() key_setup = { // [FUNCTION]
	if (self.worldtype == 1) item_setupnoise("misc/runekey.wav");
	else if (self.worldtype == 2) item_setupnoise("misc/basekey.wav");
	else item_setupnoise("misc/medkey.wav");
	self.touch2 = key_touch;
	self.classgroup = CG_KEY;
	self.bbmins = VEC_HULL_MIN;
	self.bbmaxs = VEC_HULL_MAX;
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_KEY;
	item_coopcheck();	
	item_start();
};

void() item_key1 = { // [ENTITY]
	if (!self.worldtype) self.worldtype = world.worldtype; // Check for any self worldtype override
	if (self.worldtype == 1) {
		item_setupmodel("progs/ad171/key_runic.mdl",2);
		if (self.netname == "") self.netname = "silver runekey";
	} else if (self.worldtype == 2) {
		item_setupmodel("progs/ad171/key_base.mdl",2);
		if (self.netname == "") self.netname = "silver keycard";
	} else {
		item_setupmodel("progs/ad171/key_medieval.mdl",2);
		if (self.netname == "") self.netname = "silver key";
	}
	self.items = IT_KEY1;
	self.classtype = CT_SILVERKEY;
	self.part_active = PARTICLE_STYLE_KEYSILVER;
	self.respawn_style = PARTICLE_BURST_BLUE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 20';
	key_setup();
};

void() item_key2 = { // [ENTITY]
	if (!self.worldtype) self.worldtype = world.worldtype; // Check for any self worldtype override
	if (self.worldtype == 1) {
		item_setupmodel("progs/ad171/key_runic.mdl",6);
		if (self.netname == "") self.netname = "gold runekey";
	} else if (self.worldtype == 2) {
		item_setupmodel("progs/qmaster/key_base.mdl",6);
		if (self.netname == "") self.netname = "gold keycard";
	} else {
		item_setupmodel("progs/ad171/key_medieval.mdl",6);
		if (self.netname == "") self.netname = "gold key";
	}
	self.items = IT_KEY2;
	self.classtype = CT_GOLDKEY;
	self.part_active = PARTICLE_STYLE_KEYGOLD;
	self.respawn_style = PARTICLE_BURST_YELLOW + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 20';
	key_setup();
};

void() item_key_skeleton = { // [ENTITY]
	if (!self.worldtype) self.worldtype = world.worldtype; // Check for any self worldtype override
	if (self.worldtype == 1) {
		item_setupmodel("progs/qmaster/w_sk_key.mdl",0);
		if (self.netname == "") self.netname = "a skeleton key";
	} else if (self.worldtype == 2) {
		item_setupmodel("progs/qmaster/key_base.mdl",0);
		if (self.netname == "") self.netname = "a skeleton keycard";
	} else {
		item_setupmodel("progs/qmaster/w_sk_key.mdl",0);
		if (self.netname == "") self.netname = "a skeleton key";
	}
	self.items2 = IT2_KEY_SKELETON;
	self.classtype = CT_SKELETONKEY;
	self.part_active = PARTICLE_STYLE_KEYWHITE;
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_CENTER;
	self.respawn_ofs = '0 0 20';
	key_setup();
};

void() item_keyx = { // [ENTITY]
	if (!self.worldtype) self.worldtype = world.worldtype; // Check for any self worldtype override
	item_setupmodel("progs/ad171/key_medieval.mdl",0);	

	// Setup custom key reference number (must exist)
	if (self.spawnflags & ITEM_CKEY1) {
		self.moditems = IT_CKEY1;
		if (self.netname == "") self.netname = "Arcane Key 1";
		self.ckeyskin1 = self.ckeyhudskin;
	} else if (self.spawnflags & ITEM_CKEY2) {
		self.moditems = IT_CKEY2;
		if (self.netname == "") self.netname = "Arcane Key 2";
	} else if (self.spawnflags & ITEM_CKEY3) {
		self.moditems = IT_CKEY3;
		if (self.netname == "") self.netname = "Arcane Key 3";
	} else if (self.spawnflags & ITEM_CKEY4) {
		self.moditems = IT_CKEY4;
		if (self.netname == "") self.netname = "Arcane Key 4";
	} else {
		self.spawnflags = self.spawnflags | ITEM_CKEY1;
		self.moditems = IT_CKEY1;
		if (self.netname == "") self.netname = "Arcane Key 1";
		self.ckeyskin1 = self.ckeyhudskin;
		dprint("\b[CUSTOM KEY]\b Missing spawnflag key number.  Set to Arcane Key 1.\n");
	}
	
	self.classtype = CT_CUSTOMKEY;
	self.items = IT_KEY1 | IT_KEY2;

	// Check for any AD defined particle effects
	if (self.message2 == "KEYGOLD") self.part_active = PARTICLE_STYLE_KEYGOLD;
	else if (self.message2 == "KEYSILVER") self.part_active = PARTICLE_STYLE_KEYSILVER;
	else if (self.message2 == "KEYRED") self.part_active = PARTICLE_STYLE_KEYRED;
	else if (self.message2 == "KEYGREEN") self.part_active = PARTICLE_STYLE_KEYGREEN;
	else if (self.message2 == "KEYPURPLE") self.part_active = PARTICLE_STYLE_KEYPURPLE;
	else if (self.message2 == "KEYWHITE") self.part_active = PARTICLE_STYLE_KEYWHITE;
	else self.part_active = 0;

	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_CENTER;
	if (!self.respawn_ofs) self.respawn_ofs = '0 0 20';
	self.message2 = ""; // Default respawn parameters, clear message2 just in case
	key_setup();
};

// QUAKED item_custom (0 .5 .8) (-16 -16 -24) (16 16 32) x x x x RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/key_base.mdl"); }
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// mdl          : model name to load/display (progs/model.mdl)
// netname      : XXX Part of pickup string "You got the XXX"
// noise1       : Custom pickup sound (def=weapons/lock4.wav)
// pos1         : Pickup bounding box minimum (def=-16 -16 -24)
// pos2         : Pickup bounding box maximum (def=16 16 32)
// bodyfadeaway : Model will fade away on pickup
// respawn_time : time to wait before respawning (1-x seconds, default varies)
// respawn_count: Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// part_active   : = 1 Enable particle burst on pickup
// part_ofs      : Particle Origin Offset (def='0 0 0')
// part_tcount   : Particle Quantity (def=20)
// part_life     : Particle Life Time (def=2s)
// part_style    : 1=yellow, 2=green, 3=red, 4=blue, 5=purple, 6=fire, 7=white
// part_movetype : 2=center, 3=up, 4=shockwave, 5=skull, 6=lost, 7=minotaur
// -------- SPAWNFLAGS --------
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Custom Pickup Item
void() item_custom_touch = { // [FUNCTION]
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other,"\n");
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	Safe_stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
	if (self.progspawnlist) return; // Quick exit, no need for following stuff

	if (self.part_style > 0 && !(self.spawnflags & ITEM_NOEFFECTS)) misc_particle_burst_use(); // Check for a particle pickup burst (can be blocked)
	
	// Once only, fade away function
	if (self.bodyfadeaway == TRUE) {
		self.use = self.touch = SUB_Null;
		self.think = model_fade;
		self.nextthink = time + 0.1;
		self.ltime = self.nextthink;
		self.wait = self.delay = 0;
	} else {
		item_finished();
		if (!self.respawn_trig) start_item_respawn();
	}		
};

void() item_custom = { // [ENTITY]
	item_setupmodel(MODEL_BROKEN,0);
	item_setupnoise(AMMO_PICKUP);
	self.classtype = CT_CUSTOMITEM;
	self.classgroup = CG_KEY; // Essentially this item is used like a key pickup, collect and trigger an event
	if (self.netname == "") self.netname = "Custom Item";
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_KEY;	
	if (self.part_active == TRUE) misc_particle_burst_setup(); // Check for a particle burst setup
	self.part_active = 0;	// Must clear this afterward
	if (self.angles_y <= 0) self.angles_y = rint(random()*359); // Setup random rotation, will be ignored if spinning model	
	self.touch2 = item_custom_touch;
	if (CheckZeroVector(self.pos1)) self.bbmins = VEC_HULL_MIN;
	else self.bbmins = self.pos1;
	if (CheckZeroVector(self.pos2)) self.bbmaxs = VEC_HULL_MAX;
	else self.bbmaxs = self.pos2;
	item_start();
};

// ITEM BACKPACKS
// * Dropped from monsters and players
// * Can be setup as an item with random ammo/armour
// * Will monitor ground below so can fall further
float(entity backent, string backtext1, string backtext2, float backcomma) BackpackText = { // [FUNCTION]
	if (backcomma > 0) sprint(backent, ", ");
	if (backtext1 != "") sprint(backent, backtext1);
	if (backtext2 != "") sprint(backent, backtext2);
	return 1;
};

void() BackpackTouch = { // [FUNCTION]
	local string s;
	local float pickupweapon, acount;
	
	acount = 0;
	sprint(other, "You get ");

	// A Coop player can pickup all of the weapons dropped by previous player (go through list).
	if (coop > 0) {
		if (self.moditems & IT_UPGRADE_AXE && !(other.moditems & IT_UPGRADE_AXE)) {
			pickupweapon = IT_UPGRADE_AXE;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "ShadowAxe", "", acount);
			other.moditems = other.moditems | pickupweapon;
			update_configflag(SVR_UPDAXE, TRUE);
		}
		
		if (self.items & IT_SHOTGUN && !(other.items & IT_SHOTGUN)) {
			pickupweapon = IT_SHOTGUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "SG", "", acount);
		}
		
		if (self.moditems & IT_UPGRADE_SSG && !(other.moditems & IT_UPGRADE_SSG)) {
			pickupweapon = IT_UPGRADE_SSG;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "WidowMaker", "", acount);
			other.moditems = other.moditems | pickupweapon;
			update_configflag(SVR_UPDSSG, TRUE);
		}
		else if (self.items & IT_SUPER_SHOTGUN && !(other.items & IT_SUPER_SHOTGUN)) {
			pickupweapon = IT_SUPER_SHOTGUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "SSG", "", acount);
		}
		
		if (self.items & IT_NAILGUN && !(other.items & IT_NAILGUN)) {
			pickupweapon = IT_NAILGUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "NG", "", acount);
		}
		if (self.items & IT_LAVA_NAILGUN && !(other.items & IT_LAVA_NAILGUN)) {
			pickupweapon = IT_LAVA_NAILGUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "LAVANG", "", acount);
		}
		if (self.items & IT_SUPER_NAILGUN && !(other.items & IT_SUPER_NAILGUN)) {
			pickupweapon = IT_SUPER_NAILGUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "SNG", "", acount);
		}
		if (self.items & IT_LAVA_SUPER_NAILGUN && !(other.items & IT_LAVA_SUPER_NAILGUN)) {
			pickupweapon = IT_LAVA_SUPER_NAILGUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "LAVASNG", "", acount);
		}
		if (self.items & IT_GRENADE_LAUNCHER && !(other.items & IT_GRENADE_LAUNCHER)) {
			pickupweapon = IT_GRENADE_LAUNCHER;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "GL", "", acount);
		}
		if (self.items & IT_MULTI_GRENADE && !(other.items & IT_MULTI_GRENADE)) {
			pickupweapon = IT_MULTI_GRENADE;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "MULTIGL", "", acount);
		}
		if (self.items & IT_ROCKET_LAUNCHER && !(other.items & IT_ROCKET_LAUNCHER)) {
			pickupweapon = IT_ROCKET_LAUNCHER;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "RL", "", acount);
		}
		if (self.items & IT_MULTI_ROCKET && !(other.items & IT_MULTI_ROCKET)) {
			pickupweapon = IT_MULTI_ROCKET;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "MULTIRL", "", acount);
		}
		if (self.items & IT_PLASMA_GUN && !(other.items & IT_PLASMA_GUN)) {
			pickupweapon = IT_PLASMA_GUN;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "PLASMALG", "", acount);
		}

		if (self.items2 & IT2_PROXIMITY_GUN && !(other.items2 & IT2_PROXIMITY_GUN)) {
			pickupweapon = IT2_PROXIMITY_GUN;
			other.items2 = other.items2 | pickupweapon;
			acount = BackpackText(other, "PROX", "", acount);
		}
		if (self.items2 & IT2_LASER_CANNON && !(other.items2 & IT2_LASER_CANNON)) {
			pickupweapon = IT2_LASER_CANNON;
			other.items2 = other.items2 | pickupweapon;
			acount = BackpackText(other, "LASERC", "", acount);
		}
		if (self.items2 & IT2_MJOLNIR && !(other.items2 & IT2_MJOLNIR)) {
			pickupweapon = IT2_MJOLNIR;
			other.items2 = other.items2 | pickupweapon;
			acount = BackpackText(other, "MJOL", "", acount);
		}

		if (self.items & IT_EXTRA_WEAPON && !(other.items & IT_EXTRA_WEAPON)) {
			pickupweapon = IT_EXTRA_WEAPON;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "XBOW", "", acount);
		}
		
		if (self.moditems & IT_UPGRADE_LG && !(other.moditems & IT_UPGRADE_LG)) {
			pickupweapon = IT_UPGRADE_LG;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "PLASMAGUN", "", acount);
			other.moditems = other.moditems | pickupweapon;
			update_configflag(SVR_UPDLG, TRUE);
		}
		else if (self.items & IT_LIGHTNING && !(other.items & IT_LIGHTNING)) {
			pickupweapon = IT_LIGHTNING;
			other.items = other.items | pickupweapon;
			acount = BackpackText(other, "LG", "", acount);
		}
	} else { // DM backpacks have only one weapon
		// Setup name of weapon first
		if (self.items & IT_LIGHTNING && self.moditems & IT_UPGRADE_LG) self.netname = "Plasma Gun";
		else if (self.items & IT_LIGHTNING) self.netname = "Thunderbolt";
		else if (self.items & IT_ROCKET_LAUNCHER) self.netname = "Rocket Launcher";
		else if (self.items & IT_MULTI_GRENADE) self.netname = "Multi-Grenade Launcher";
		else if (self.items & IT_MULTI_ROCKET) self.netname = "Multi-Rocket Launcher";
		else if (self.items & IT_PLASMA_GUN) self.netname = "Plasma Lightning Gun";
		else if (self.items & IT_GRENADE_LAUNCHER) self.netname = "Grenade Launcher";
		else if (self.items & IT_SUPER_NAILGUN) self.netname = "Super Nailgun";
		else if (self.items & IT_NAILGUN) self.netname = "Nailgun";
		else if (self.items & IT_SUPER_SHOTGUN && self.moditems & IT_UPGRADE_SSG)  self.netname = "Widow Maker Shotgun";
		else if (self.items & IT_SUPER_SHOTGUN) self.netname = "Double-barrelled Shotgun";
		else if (self.items & IT_SHOTGUN) self.netname = "Shotgun";
		else if (self.items & IT_AXE && self.moditems & IT_UPGRADE_AXE) self.netname = "Shadow Axe";
		else if (self.items & IT_AXE) self.netname = "Axe";
		else self.netname = "";

		if (self.items2 & IT2_PROXIMITY_GUN) self.netname = "Proximity Gun";
		else if (self.items2 & IT2_LASER_CANNON) self.netname = "Laser Cannon";
		else if (self.items2 & IT2_MJOLNIR) self.netname = "Mjolnir's Hammer";
		
		// Check if the player has the weapon already?
		if (((other.items & self.items) == 0 && self.netname != "") ||((other.items2 & self.items2) == 0) && self.netname != "") {
			other.items = other.items | self.items;
			other.items2 = other.items2 | self.items2;
			other.moditems = other.moditems | self.moditems;
			acount = BackpackText(other, "the ", self.netname, acount);
		}
	}

	// Calculate random amounts of ammo
	if (self.count > 0) {
		if (self.spawnflags & BACKPACK_SHELLS) self.ammo_shells = rint(1 + random()*self.count);
		if (self.spawnflags & BACKPACK_NAILS) self.ammo_nails = rint(1 + random()*self.count);
		if (self.spawnflags & BACKPACK_ROCKETS) self.ammo_rockets = rint(1 + random()*self.count);
		if (self.spawnflags & BACKPACK_CELLS) self.ammo_cells = rint(1 + random()*self.count);
		if (self.spawnflags & 4096) self.ammo_bolts = rint(1 + random()*self.count);
		if (self.spawnflags & 8192) self.ammo_poison = rint(1 + random()*self.count);
		if (self.spawnflags & 16384) self.ammo_lava_nails = rint(1 + random()*self.count);
		if (self.spawnflags & 32768) self.ammo_multi_rockets = rint(1 + random()*self.count);
		if (self.spawnflags & 65536) self.ammo_plasma = rint(1 + random()*self.count);
		if (self.spawnflags & 131072) self.ammo_bloodcrystals = rint(1 + random()*self.count);
		if (self.spawnflags & 262144) self.ammo_voidshards = rint(1 + random()*self.count);
		if (self.spawnflags & 524288) self.ammo_elemental = rint(1 + random()*self.count);
		if (self.armortype == 1) self.armorvalue = rint(1 + random()*self.count);
	}

	// Give ammo to player
	if (self.ammo_shells > 0) {
		other.ammo_shells = other.ammo_shells + self.ammo_shells;
		s = ftos(self.ammo_shells);
		acount = BackpackText(other, s, " shells", acount);
	}
	if (self.ammo_nails > 0) {
		other.ammo_nails = other.ammo_nails + self.ammo_nails;
		s = ftos(self.ammo_nails);
		acount = BackpackText(other, s, " nails", acount);
	}
	if (self.ammo_rockets > 0) {
		other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
		s = ftos(self.ammo_rockets);
		acount = BackpackText(other, s, " rockets", acount);
	}
	if (self.ammo_cells > 0) {
		other.ammo_cells = other.ammo_cells + self.ammo_cells;
		s = ftos(self.ammo_cells);
		acount = BackpackText(other, s, " cells", acount);
	}
	if (self.ammo_bolts > 0) {
		other.ammo_bolts = other.ammo_bolts + self.ammo_bolts;
		s = ftos(self.ammo_bolts);
		acount = BackpackText(other, s, " bolts", acount);
	}
		if (self.ammo_poison > 0) {
		other.ammo_poison = other.ammo_poison + self.ammo_poison;
		s = ftos(self.ammo_bolts);
		acount = BackpackText(other, s, " poison", acount);
	}
	if (self.ammo_plasma > 0) {
		other.ammo_plasma = other.ammo_plasma + self.ammo_plasma;
		s = ftos(self.ammo_plasma);
		acount = BackpackText(other, s, " plasma", acount);
	}
	if (self.ammo_lava_nails > 0) {
		other.ammo_lava_nails = other.ammo_lava_nails + self.ammo_lava_nails;
		s = ftos(self.ammo_lava_nails);
		acount = BackpackText(other, s, " lava nails", acount);
	}
	if (self.ammo_multi_rockets > 0) {
		other.ammo_multi_rockets = other.ammo_multi_rockets + self.ammo_multi_rockets;
		s = ftos(self.ammo_multi_rockets);
		acount = BackpackText(other, s, " multi-rockets", acount);
	}
	if (self.ammo_bloodcrystals > 0) {
		other.ammo_bloodcrystals = other.ammo_bloodcrystals + self.ammo_bloodcrystals;
		s = ftos(self.ammo_bloodcrystals);
		acount = BackpackText(other, s, " blood crystals", acount);
	}
	if (self.ammo_voidshards > 0) {
		other.ammo_voidshards = other.ammo_voidshards + self.ammo_voidshards;
		s = ftos(self.ammo_voidshards);
		acount = BackpackText(other, s, " void shards", acount);
	}
	if (self.ammo_elemental > 0) {
		other.ammo_elemental = other.ammo_elemental + self.ammo_elemental;
		s = ftos(self.ammo_elemental);
		acount = BackpackText(other, s, " elemental mana", acount);
	}
	
	// Check for armor in backpack
	if (self.armorvalue > 0 && deathmatch == 0) {
		// For coop backpacks can be dropped from players
		// These can contain huge amounts of armour and needed
		// to be treated as upgrade/replace, not the shard system
		if (coop > 0 && self.items2 & IT2_ALLARMOR) {
			if (other.armortype*other.armorvalue < self.armortype*self.armorvalue) {
				other.armortype = self.armortype;
				other.armorvalue = self.armorvalue;
				other.items2 = other.items2 - (other.items2 & IT2_ALLARMOR);
				other.items2 = other.items2 + (self.items2 & IT2_ALLARMOR);
				acount = BackpackText(other, "armor upgraded", "", acount);
			}
		} else {
			// For Singleplayer backpack items can contain shards
			// Shards add to the armour value and can go above limit
			// If no armour present (add a green jacket)
			other.armorvalue = other.armorvalue + self.armorvalue;
			// Does the player have any armor already?
			if (other.armortype == 0 ) {
				// No armor present, give green with armor shards
				other.armortype = ARMOR_GRN_TYPE;
				other.items2 = other.items2 | IT2_ARMOR1;
			}
			if (self.armorvalue > 0) {
				s = ftos(self.armorvalue);
				acount = BackpackText(other, s, " armor shards", acount);
			}
		}
	}
	
	// Check for Silver/Gold/Custom keys if coop active
	if (coop > 0) {
		if (self.items & IT_KEY1) {
			other.items = other.items | IT_KEY1;
			acount = BackpackText(other, "Silver Key", "", acount);
		}
		if (self.items & IT_KEY2) {
			other.items = other.items | IT_KEY2;
			acount = BackpackText(other, "Gold Key", "", acount);
		}
		if (self.moditems & IT_CKEY1) {
			other.moditems = other.moditems | IT_CKEY1;
			other.ckeyname1 = self.ckeyname1;
			acount = BackpackText(other, self.ckeyname1, "", acount);
		}
		if (self.moditems & IT_CKEY2) {
			other.moditems = other.moditems | IT_CKEY2;
			other.ckeyname2 = self.ckeyname2;
			acount = BackpackText(other, self.ckeyname2, "", acount);
		}
		if (self.moditems & IT_CKEY3) {
			other.moditems = other.moditems | IT_CKEY3;
			other.ckeyname3 = self.ckeyname3;
			acount = BackpackText(other, self.ckeyname3, "", acount);
		}
		if (self.moditems & IT_CKEY4) {
			other.moditems = other.moditems | IT_CKEY4;
			other.ckeyname4 = self.ckeyname4;
			acount = BackpackText(other, self.ckeyname4, "", acount);
		}
	}

	// Check for Powerups if coop active
	if (coop > 0) {
		if (self.items & IT_INVISIBILITY) {
			other.items = other.items | IT_INVISIBILITY;
			acount = BackpackText(other, "InvRing", "", acount);
			other.invisible_finished = self.invisible_finished;
			other.invisible_time = self.invisible_time;
			other.invisible_sound = self.invisible_sound;
		}
		if (self.items & IT_SUIT) {
			other.items = other.items | IT_SUIT;
			acount = BackpackText(other, "EnvSuit", "", acount);
			other.radsuit_finished = self.radsuit_finished;
			other.rad_time = self.rad_time;
		}
		if (self.items & IT_QUAD) {
			other.items = other.items | IT_QUAD;
			acount = BackpackText(other, "QuadDam", "", acount);
			other.super_damage_finished = self.super_damage_finished;
			other.super_time = self.super_time;
			other.super_sound = self.super_sound;
		}
		if (self.moditems & IT_ARTSHARP) {
			other.moditems = other.moditems | IT_ARTSHARP;
			acount = BackpackText(other, "ShpShoot", "", acount);
			other.sharpshoot_finished = self.sharpshoot_finished;
			other.sharpshoot_time = self.sharpshoot_time;
			other.sharpshooter_sound = self.sharpshooter_sound;
		}
		if (self.moditems & IT_ARTWETSUIT) {
			other.moditems = other.moditems | IT_ARTWETSUIT;
			acount = BackpackText(other, "WetSuit", "", acount);
			other.wetsuit_finished = self.wetsuit_finished;
			other.wetsuit_time = self.wetsuit_time;
			other.wetsuit_sound = self.wetsuit_sound;
		}
		if (self.moditems & IT_ARTPIERCE) {
			other.moditems = other.moditems | IT_ARTPIERCE;
			acount = BackpackText(other, "Piercer", "", acount);
			other.nailpiercer_finished = self.nailpiercer_finished;
			other.nailpiercer_time = self.nailpiercer_time;
			other.nailpiercer_sound = self.nailpiercer_sound;
		}		
	}
	sprint(other, " from a backpack\n");
	if (self.perms & IT_CHAINSAW) sound (other, CHAN_ITEM, "zerstorer/weapons/sawidle.wav", 1, ATTN_NORM);
	else sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	Safe_stuffcmd (other, "bf\n");

	// Check ammo limts, change to best weapon and set ammo type
	bound_other_ammo (other);
	if (deathmatch) other.weapon = W_BestWeapon(other);
	W_SetCurrentAmmo (other);
	
	// Random ammo backpacks are actual items
	if (self.classtype == CT_AMMORANDOM) {
		item_finished(); // hide item and check for respawn
		if (!self.respawn_trig) start_item_respawn();
	} else remove(self); // Temporary backpack
};

void() DropBackpack = { // [FUNCTION]
	local entity item;

	item = spawn();
	item.classtype = CT_AMMOPACK;
	item.classgroup = CG_AMMOITEM;
	item.classname = "item_backpack";
	item.origin = self.origin - '0 0 20';
	
	// Pyro and Fumigator Enforcers drop armor shards.
	if (self.classtype == CT_MONPYRO || self.classtype == CT_MONFUMIGATOR) item.armorvalue = rint(1 + random() * self.ammo_shells);

	// Everything else drops ammo
	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
	item.ammo_lava_nails  = self.ammo_lava_nails;
	item.ammo_plasma = self.ammo_plasma;
	item.ammo_multi_rockets = self.ammo_multi_rockets;
	item.ammo_plasma = self.ammo_plasma;
	item.ammo_bolts = self.ammo_bolts;
	item.ammo_poison = self.ammo_poison;
	item.ammo_bloodcrystals = self.ammo_bloodcrystals;
	item.ammo_voidshards = self.ammo_voidshards;
	item.ammo_elemental = self.ammo_elemental;

	item.items = item.moditems = item.customkey = 0; // Reset backpack inventory before any test

	// If player dropping backpack check for extra stuff
	if ((self.flags & FL_CLIENT) || self.classtype == CT_MONGREMLIN) {
		// Copy over items for coop players to pickup
		if (coop > 0 && self.classtype != CT_MONGREMLIN) {
			item.items = self.items; // Copy all items + keys but not perms
			item.moditems = self.moditems;
			item.customkey = self.customkey;
			item.armortype = self.armortype; // Copy current armour type + value
			item.armorvalue = self.armorvalue;
			if (self.moditems & IT_CKEY1) item.ckeyname1 = self.ckeyname1; // Copy over custom key netnames
			if (self.moditems & IT_CKEY2) item.ckeyname2 = self.ckeyname2;
			if (self.moditems & IT_CKEY3) item.ckeyname3 = self.ckeyname3;
			if (self.moditems & IT_CKEY4) item.ckeyname4 = self.ckeyname4;

			// Copy over any powerup timers
			// Cannot die with invulnerability so not checked!
			if (coop_artifacts == TRUE) {
				if (self.items & IT_INVISIBILITY) {
					item.invisible_finished = self.invisible_finished;
					item.invisible_time = self.invisible_time;
					item.invisible_sound = self.invisible_sound;
				}
				if (self.items & IT_SUIT) {
					item.radsuit_finished = self.radsuit_finished;
					item.rad_time = self.rad_time;
				}
				if (self.items & IT_QUAD) {
					item.super_damage_finished = self.super_damage_finished;
					item.super_time = self.super_time;
					item.super_sound = self.super_sound;
				}
				if (self.moditems & IT_ARTSHARP) {
					item.sharpshoot_finished = self.sharpshoot_finished;
					item.sharpshoot_time = self.sharpshoot_time;
					item.sharpshooter_sound = self.sharpshooter_sound;
				}
				if (self.moditems & IT_ARTWETSUIT) {
					item.wetsuit_finished = self.wetsuit_finished;
					item.wetsuit_time = self.wetsuit_time;
					item.wetsuit_sound = self.wetsuit_sound;
				}
				if (self.moditems & IT_ARTPIERCE) {
					item.nailpiercer_finished = self.nailpiercer_finished;
					item.nailpiercer_time = self.nailpiercer_time;
					item.nailpiercer_sound = self.nailpiercer_sound;
				}
			}
		} else { // Default is DM only, current weapon only
			// Check for any special MOD weapons
			if (self.weapon == IT_AXE && self.moditems & IT_UPGRADE_AXE) 
				item.moditems = IT_UPGRADE_AXE;
			else if (self.weapon == IT_SUPER_SHOTGUN && self.moditems & IT_UPGRADE_SSG) 
				item.moditems = IT_UPGRADE_SSG;
			else if (self.weapon == IT_LIGHTNING && self.moditems & IT_UPGRADE_LG) 
				item.moditems = IT_UPGRADE_LG;
			// Copy over current weapon ONLY to backpack
			if (self.weapon == IT2_LASER_CANNON || self.weapon == IT2_PROXIMITY_GUN || self.weapon == IT2_MJOLNIR) {
				item.items2 = self.weapon;
			} else {
				item.items = self.weapon;
			}
		}
	}
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200); // Give the backpack some random toss!
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, MODEL_BACKPACK);
	setsize (item,VEC_ITEM_MIN, '16 16 56');
	item.touch = item_touch;
	item.touch2 = BackpackTouch;
	item.skin = 0;
	
	// 1=green, 2=blue, 3=red, 4=golden, 5=swampy, 6=white, 7=flesh  green=shells, blue=cells, red=rockets
	if (self.classtype == CT_MONDEFENDER) item.skin = 1;
	else if (self.classtype == CT_MONARMYGRENADE) item.skin = 1;
	else if (self.classtype == CT_MONARMYPLASMA) item.skin = 2;
	else if (self.classtype == CT_MONELIMATOR) item.skin = 2;
	else if (self.classtype == CT_MONCENTURION) item.skin = 2;
	else if (self.classtype == CT_MONARMYROCKET) item.skin = 3;
	else if (self.classtype == CT_MONPYRO) item.skin = 4;
	else if (self.classtype == CT_MONFUMIGATOR) item.skin = 5;
	else if (self.classtype == CT_MONENFORCER) item.skin = 7;
	
	// Default = remove after 2 minutes, stay if coop active
	if (coop == 0) item.item_expired = time + 120;
	else item.item_expired = 0;
	
	item.item_flrcheck = fabs(item.mins_z) + 16;
	item.think = item_thinkloop;		// Check floor
	item.nextthink = time + 0.3;		// Let backpack drop first
};

void() item_backpack_setup = { // [FUNCTION]
	self.netname = ""; // Empty netname for backpack routine
	self.origin = self.origin + '0 0 12';	
	self.frame = self.weapon = self.items = self.frame_override = self.frame_box = 0; // reset frame, weapon and armour type, but not value
	if (self.ammo_shells < 0) self.ammo_shells = 0; // Make sure the ammo/armor quantites are NOT negative!
	if (self.ammo_nails < 0) self.ammo_nails = 0;
	if (self.ammo_rockets < 0) self.ammo_rockets = 0;
	if (self.ammo_cells < 0) self.ammo_cells = 0;
	if (self.ammo_lava_nails < 0) self.ammo_lava_nails = 0;
	if (self.ammo_multi_rockets < 0) self.ammo_multi_rockets = 0;
	if (self.ammo_plasma < 0) self.ammo_plasma = 0;
	if (self.ammo_bolts < 0) self.ammo_bolts = 0;
	if (self.ammo_poison < 0) self.ammo_poison = 0;
	if (self.ammo_bloodcrystals < 0) self.ammo_bloodcrystals = 0;
	if (self.ammo_voidshards < 0) self.ammo_voidshards = 0;
	if (self.ammo_elemental < 0) self.ammo_elemental = 0;
	if (self.armorvalue < 0) self.armorvalue = 0;
	if(self.exactskin < 0 || self.exactskin > 7) self.exactskin = 0; // Check if exact skin is within range
	self.skin = self.exactskin;
	
	// Check for random ammo setup (uses spawnflags)
	if (self.spawnflags & BACKPACK_SHELLS) self.ammo_shells = -1;
	if (self.spawnflags & BACKPACK_NAILS) self.ammo_nails = -1;
	if (self.spawnflags & BACKPACK_ROCKETS) self.ammo_rockets = -1;
	if (self.spawnflags & BACKPACK_CELLS) self.ammo_cells = -1;
	if (self.spawnflags & 16384) self.ammo_lava_nails = -1;
	if (self.spawnflags & 32768) self.ammo_multi_rockets = -1;
	if (self.spawnflags & 65536) self.ammo_plasma = -1;
	if (self.spawnflags & 4096) self.ammo_bolts = -1;
	if (self.spawnflags & 8192) self.ammo_poison = -1;
	if (self.spawnflags & 131072) self.ammo_bloodcrystals = -1;
	if (self.spawnflags & 262144) self.ammo_voidshards = -1;
	if (self.spawnflags & 524288) self.ammo_elemental = -1;
	if (self.armortype == 1) self.armorvalue = -1;
	else self.armortype = 0;

	// setup random quantity (default = 5)
	if (self.ammo_shells < 0 || self.ammo_nails < 0 ||
		self.ammo_rockets < 0 || self.ammo_cells < 0 ||
		self.armorvalue < 0 || self.ammo_bolts < 0 || 
		self.ammo_poison < 0 || self.ammo_lava_nails < 0 || 
		self.ammo_multi_rockets < 0 || self.ammo_plasma < 0 || 
		self.ammo_bloodcrystals < 0 || self.ammo_voidshards < 0 ||
		self.ammo_elemental < 0) {
		if (!self.count) self.count = 5;
	} else self.count = 0; // No random ammo required, reset count

	// Check backpack has ammo to pickup
	if (self.ammo_shells == 0 && self.ammo_nails == 0 &&
		self.ammo_rockets == 0 && self.ammo_cells == 0 &&
		self.armorvalue == 0 && self.ammo_bolts == 0 && 
		self.ammo_poison == 0 && self.ammo_multi_rockets == 0 &&
		self.ammo_lava_nails == 0 && self.ammo_plasma == 0 &&
		self.ammo_bloodcrystals == 0 && self.ammo_voidshards == 0 &&
		self.ammo_elemental == 0) {
		self.ammo_shells = floor(random() * 8);
		self.ammo_nails = floor(random() * 10);
		self.ammo_rockets = floor(random() * 5);
		self.ammo_cells = floor(random() * 5);
	}
	item_start ();
};

// QUAKED item_backpack (0 .5 .8) (-16 -16 0) (16 16 56) SHELLS NAILS ROCKETS CELLS RESPAWN FLOAT STARTOFF NOEFFECTS NOT_EASY NOT_NORMAL NOT_HARD NOT_DM
// { model(":progs/ad171/w_backpack.mdl"); }
// Backpack with random/exact amount of ammo
// -------- KEYS --------
// targetname   : toggle state (use trigger ent for exact state)
// count        : random amount of ammo to give (works with spawnflags)
// ammo_shells  : exact amount of shells
// ammo_nails   : exact amount of spikes
// ammo_rockets : exact amount of rockets
// ammo_cells   : exact amount of cells
// armorvalue   : armor shards (gives green armor if none present)
// armortype    : 1 = random amount of armor shards (uses count)
// exactskin    : 0=Original, 1=green, 2=blue, 3=red, 4=yellow, 5=swamp, 6=white, 7=pale
// upgrade_ssg  : = 1 will only spawn if shotgun upgrade active on server
// upgrade_axe  : = 1 will only spawn if axe upgrade active on server
// upgrade_lg   : = 1 will only spawn if lightning gun upgrade active on server
// message       : centerprint message when item is picked up
// respawn_time  : time to wait before respawning (=-1 instant)
// respawn_count : Total amount of times to respawn (counts down to zero)
// respawn_trig : = 1 Wait for trigger before respawning
// -------- SPAWNFLAGS --------
// SHELLS  : ammo for SG / SSG / RG
// NAILS   : ammo for NG / SNG
// ROCKETS : ammo for GL / RL
// CELLS   : ammo for LG
// RESPAWN  : Can respawn after being picked up
// FLOAT    : No drop to floor test
// STARTOFF : Starts off and waits for trigger
// NOEFFECTS : No particle or effects active
// -------- NOTES --------
// Backpack with random/exact amount of ammo
// Cannot be used to drop weapons or armour!
void() item_backpack = { // [ENTITY]
	item_setupmodel(MODEL_BACKPACK,0);
	item_setupnoise("ad171/items/backpack_ammo.wav");
	self.flags = FL_ITEM;
	if (self.classtype <= 0) self.classtype = CT_AMMOITEMPACK;
	self.classgroup = CG_AMMOITEM;
	self.bbmins = '-16 -16 -12';
	self.bbmaxs = VEC_HULL_MAX;
	self.part_active = PARTICLE_STYLE_BACKPACK;
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_BACKPACK;
	self.respawn_ofs = '0 0 12';
	self.touch2 = BackpackTouch;
	if (self.exactskin == 1) self.respawn_style = PARTICLE_BURST_GREEN; // Match particle effect to skin colour
	else if (self.exactskin == 2) self.respawn_style = PARTICLE_BURST_BLUE;
	else if (self.exactskin == 3) self.respawn_style = PARTICLE_BURST_RED;
	else if (self.exactskin == 4) self.respawn_style = PARTICLE_BURST_YELLOW;
	else if (self.exactskin == 5) self.respawn_style = PARTICLE_BURST_GREEN;
	else self.respawn_style = PARTICLE_BURST_WHITE;
	self.respawn_style = self.respawn_style | PARTICLE_BURST_CENTER;
	self.think = item_backpack_setup;
	self.nextthink = time + 0.1 + random(); // Double checking all the different ammo combinations can be time consuming, delay spawn the backpack instead
};

void() item_artifact_super_pack = { self.classname = "item_backpack"; item_backpack(); }; // [ENTITY]

void() DropHealthpack = { // [FUNCTION]
	local entity item;
	
	item = spawn();
	item.classgroup = CG_HEALTH;
	item.classname = "item_health";
	item.origin = self.origin - '0 0 20';
	item.skin_override = FALSE;

	// Check for regular Health Pack
	if (self.healamount == HEAL_NORM) {
		item.classtype = CT_HEALNORM;
		item.healamount = floor((HEAL_NORM/2) + (random()* HEAL_NORM/2)); // Randomize the health pack, defaults are boring!
		item.noise = SOUND_HEAL25;
		if (item.skin_override == 2) item.mdl = "progs/ad171/health_25.mdl"; // Pick new medieval version or original
		else item.mdl = "progs/ad171/health_25b.mdl";
	} else if (self.healamount == HEAL_MEGA) { // Check for megahealth! - This is crazy!
		item.classtype = CT_HEALMEGA;
		item.healamount = HEAL_MEGA;
		item.noise = SOUND_HEAL100;
		if (item.skin_override == 2) item.mdl = "progs/ad171/health_100.mdl"; // Pick new medieval version or original
		else item.mdl = "progs/ad171/health_100b.mdl";
	} else { // Default = rotten Health Pack
		item.classtype = CT_HEALROT;
		item.healamount = floor((HEAL_ROT/2) + (random()* HEAL_ROT/2)); // Randomize the health pack, defaults are boring!
		item.noise = SOUND_HEAL15;
		if (item.skin_override == 2) item.mdl = "progs/ad171/health_15.mdl"; // Pick new medieval version or original
		else item.mdl = "progs/ad171/health_15b.mdl";
	}
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200); // Give the backpack some random toss!
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, item.mdl);
	item.bbmins = VEC_ITEM_MIN;
	item.bbmaxs = VEC_ITEM_MAX;
	setsize(item, item.bbmins, item.bbmaxs);
	item.touch = item_touch;
	item.touch2 = health_touch;
	item.respawn_time = 0; // Once only
	item.angles_y = rint(random()*359); // Random rotation
	if (coop == 0) item.item_expired = time + 120; // Default is remove after 2 minutes...
	else item.item_expired = 0; // ...stay if coop.
	item.item_flrcheck = fabs(item.mins_z) + 16;
	item.think = item_thinkloop; // Check floor
	item.nextthink = time + 0.3; // Let item drop first
};

void(string m, float wep, float clas) DropWeapon = { // [FUNCTION]
	local entity item;

	if (!m) return; // Can't spawn nothing!

	item = spawn();
	item.classname = "weapon_toss";
	item.origin = self.origin + '0 0 20';
	item.mdl = m;
	item.weapon = wep;
	item.classtype = clas;
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200); // Give it some random toss!
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	item.touch = item_touch;
	item.respawn_time = 0; // Once only
	item.classgroup = CG_WEAPON;
	item.touch2 = weapon_touch;
	item.item_expired = 0;
	setmodel(item, item.mdl);
	item.bbmins = VEC_ITEM_MIN;
	item.bbmaxs = VEC_ITEM_MAX;
	setsize(item, item.bbmins, item.bbmaxs);
	item.item_flrcheck = fabs(item.mins_z) + 16;
	item.think = item_thinkloop; // Check floor
	item.nextthink = time + 0.3; // Let item drop first
	dprint("Tossed a weapon!\n");
};

void(entity e) senddevdata { // [FUNCTION]
	if (!world.deventity) return;

	world.deventity.health = world.deventity.health + e.healamount;
	world.deventity.ammo_shells			= world.deventity.ammo_shells + e.ammo_shells;
	world.deventity.ammo_nails			= world.deventity.ammo_nails + e.ammo_nails;
	world.deventity.ammo_rockets		= world.deventity.ammo_rockets + e.ammo_rockets;
	world.deventity.ammo_cells			= world.deventity.ammo_cells + e.ammo_cells;
	world.deventity.ammo_lava_nails		= world.deventity.ammo_lava_nails + e.ammo_lava_nails;
	world.deventity.ammo_multi_rockets	= world.deventity.ammo_multi_rockets + e.ammo_multi_rockets;
	world.deventity.ammo_plasma			= world.deventity.ammo_plasma + e.ammo_plasma;
	world.deventity.ammo_bolts			= world.deventity.ammo_bolts + e.ammo_bolts;
	world.deventity.ammo_poison			= world.deventity.ammo_poison + e.ammo_poison;
	world.deventity.ammo_bloodcrystals	= world.deventity.ammo_bloodcrystals + e.ammo_bloodcrystals;
	world.deventity.ammo_voidshards		= world.deventity.ammo_voidshards + e.ammo_voidshards;
	world.deventity.ammo_elemental		= world.deventity.ammo_elemental + e.ammo_elemental;
};

// Can't touch dis!
void () item_taunt = { // [ENTITY]
	if (self.mdl == "" && self.model == "") { dprint("No model for item_taunt, removed.\n"); remove(self); }

	if (self.model) self.mdl = self.model;
	self.touch2 = SUB_Null;
	precache_model(self.mdl);
	setmodel(self,self.mdl);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setsize(self,VEC_HULL_MIN,VEC_HULL_MAX);
};

// HACK alert! ...meh, including this here to be nice.  From Drake.  This is an item_taunt and it should have a push trigger and a killtarget to remove this and the trigger after jumping
void () item_pushup = { // [ENTITY]
	self.mdl = "progs/drake/wings2.mdl";
	item_taunt();
};

// From Rubicon 2 by ijed, MFX, & Hrimfaxi
void () circuitboard_touch = { // [FUNCTION]
	if (other.classname != "player") return;
	if (other.health <= 0) return;
	if (other.in_a_vehicle) return;

	Safe_stuffcmd(other, "bf\n");
	centerprint(other, "You got a 17-centimeter Fromitz board!");
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	activator = other;
	SUB_UseTargets();
	remove(self);
};

void () item_circuitboard = { // [ENTITY]
	item_setupmodel("progs/rrp/fromitz.mdl",0);
	item_setupnoise("items/protect.wav");
	setmodel (self, self.mdl);
	self.touch2 = circuitboard_touch;
	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
	self.classtype = CT_CIRCUIT;
	item_start();
};

void() item_flag_team1 = {}; // [ENTITY]

void() item_flag_team2 = {}; // [ENTITY]

void() item_flagblue = {}; // [ENTITY]

void() item_flagred = {}; // [ENTITY]

void() mariomushroom_touch = { // [FUNCTION]
	if (other.health < 1) return;
	if (!(other.flags & FL_CLIENT)) return;
	if (other.in_a_vehicle) return;
	if (other.shroom_finished >= time) return;
	
	other.shroom_finished = time + self.cnt;
	sound(other,CHAN_VOICE,"qmaster/items/smb_powerup.wav",1,ATTN_NORM);
	other.velocity_z = other.velocity_z + 360; // pop up
	other.flags = other.flags - FL_ONGROUND;
	other.view_ofs = '0 0 72';
	other.legsattachment.scale = 2;
	other.scale = 2;
	setsize(other,VEC_HULL2_MIN,VEC_HULL2_MAX); // grow up
	other.effects = other.effects | EF_BRIGHTLIGHT;
	entity_hide(self);
};

void() item_mariomushroom = { // [ENTITY]
	item_setupmodel("progs/madfox/mushroom_item.mdl",0);
	setmodel(self, self.mdl);
	precache_sound ("qmaster/items/smb_powerup.wav");
	precache_sound ("qmaster/items/smb_bowserfalls.wav");
	precache_sound ("qmaster/items/smb_stomp.wav");
	precache_sound ("qmaster/player/jumpmario.wav");
	self.netname = "A Strange Shroom";
	if (self.cnt <=0) self.cnt = 60;
	self.frame = rint(random()*4);
	self.touch2 = mariomushroom_touch;
	self.scale = 2;
	self.solid = SOLID_TRIGGER;
	setmodel (self,self.mdl);
	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
	self.estate_use = item_on;
	self.classtype = CT_SHROOM;
	dprint("Starting a mushroom powerup...");
	self.touch = mariomushroom_touch;
};