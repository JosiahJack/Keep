//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Redfield, Joshua Skelton, Return to Castle Wolfenstein
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
// Function count: 64
//
// Implements: Miscellaneous Decorations and Effects
//
// Description:
// Contains various effects and specially animated models with associated
// effects.
//=============================================================================

void() godray_alpha_inc;
void() alice_skin;
void() misc_ufo_off;

// From Joshua Skelton
// Returns an indication of the sign of the given number.
// x: A number.
// Returns: -1 if x < 0, 0 if x == 0, 1 if x > 0.
float(float x) sign = { // [FUNCTION]
    if (x > 0) return 1;
    else if (x < 0) return -1;

    return 0;
};

// From Joshua Skelton
// Limits the given value to the given range and will wrap the value to the the other end of the range if exceeded.
// value: A number
// minValue: The minimum value of the range
// maxValue: The maximum value of the range
// Returns: A number within the given range.
float(float value, float minValue, float maxValue) wrap = { // [FUNCTION]
    return mod((value - minValue),((maxValue - minValue) + 1)) + minValue;
};

void() misc_decor_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	if (self.savedeffects) self.effects = self.savedeffects;
	if (self.mdl != "") { // Restore model/size/skin
		setmodel(self,self.mdl);
		setsize(self,VEC_ORIGIN,VEC_ORIGIN);
	}

	if (self.headmdl != "" && self.attachment) {
		setmodel(self.attachment,self.headmdl);
		setsize(self.attachment,VEC_ORIGIN,VEC_ORIGIN);
	}

	if (self.think1) self.think1();
};

void() misc_decor_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.th_die = SUB_Null;
	self.think = SUB_Null;
	self.savedeffects = self.effects;
	self.effects = 0;
	if (self.mdl != "") { // Turn off model if setup
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
	SUB_FinishAttachments();
};

void() cshiftflash_loop = { // [FUNCTION]
	if (screen_time < 1) localcmd("v_cshift 255 255 255 75\n");
	else if (screen_time == 1) localcmd("v_cshift 255 255 255 25\n");
	else { localcmd("v_cshift 0 0 0 0\n"); return; }

	screen_time = screen_time + 1;
	self.nextthink = time + 0.2;
	self.think = cshiftflash_loop;
};

void() misc_cshiftflash_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	screen_time = 0;
	cshiftflash_loop();
};

void() misc_cshiftflash_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
};

void() misc_cshiftflash_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_cshiftflash_on;
	self.estate_off = misc_cshiftflash_off;
	entity_state_off();
};

// CSHIFT FLASH EFFECT
// cshiftflash functions needed for triggered cshift effect on lightning flash
// This is a really brutal method and should be done more elegantly.  Used as a work around for lightning flash when max lightstyles is reached 
// This is unfortunate reality of working with ancient Quake engines.  Always starts off and waits for trigger.
void() misc_cshiftflash = { // [ENTITY]
	self.nextthink = time + 0.1;
	self.think = misc_cshiftflash_setup;
};

void() godray_alpha_dec = { // [FUNCTION]
	if (self.alpha <= 0.02) { godray_alpha_inc(); return; }
	self.alpha = self.alpha - 0.001;
	self.nextthink = time + 0.05;
	self.think = godray_alpha_dec;
};

void() godray_alpha_inc = { // [FUNCTION]
	if (self.alpha > 0.06) { godray_alpha_dec(); return; }

	self.alpha = self.alpha + 0.001;
	self.nextthink = time + 0.05;
	self.think = godray_alpha_inc;
};

void() misc_godray_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	if (self.mdl != "") { // Restore model/size/skin
		setmodel(self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		godray_alpha_dec();
	}
};

void() misc_godray_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_godray_on;
	self.estate_off = misc_decor_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_godray (1 .5 .25) (-16 -16 -16) (16 16 32)
// Godray meshes with animated opacity.
void() misc_godray = { // [ENTITY]
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_godray_setup;
};

void() saluteknight_hold = { // [FUNCTION]
	self.frame = 121;
	self.nextthink = time + LARGE_TIMER;
	self.think = saluteknight_hold;
};

void() saluteknight_transition = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame >= 121) {
		sound(self,CHAN_VOICE, "redfield/misc/armor_clink.wav",1,ATTN_NORM);
		saluteknight_hold();
		return;
	}
	self.nextthink = time + 0.1;
	self.think = saluteknight_transition;
};

void() saluteknight_use = { // [FUNCTION]
	self.frame = 117;
	self.nextthink = time + 0.1;
	self.think = saluteknight_transition;
};

void() saluteknight_animate = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > 8) self.frame = 0;
	self.nextthink = time + 0.1;
	self.think = saluteknight_animate;
};

void() misc_saluteknight_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.estate_use = saluteknight_use;
	self.think1 = saluteknight_animate; // Need to set for estate_on to use.
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_saluteknight (1 .5 .25) (-16 -16 -16) (16 16 32)
void() misc_saluteknight = { // [ENTITY]
	self.mdl = "progs/ad171/mon_knight.mdl";
	precache_model (self.mdl);
	precache_sound("redfield/misc/armor_clink.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_saluteknight_setup;
};

void() check_oldoneTrig = { // [FUNCTION]
	// Is there any trigger on the oldone?
	if (self.noise != "") {
		self.attachment = find(world, targetname, self.noise);
		if (self.attachment.target != "") trigger_strs(self.attachment.target, self);
	}
};

void() oldone_animate = { // [FUNCTION]
	self.count = self.count + 1;
	if (self.alpha < 1) self.alpha = self.alpha + 0.1;
	if (self.count > 9) self.frame = self.frame + 1;
	if (self.frame == 4) {
		sound(self,CHAN_VOICE, "redfield/karasu/spell.wav",1,ATTN_IDLE);
		check_oldoneTrig();		
	}
	if (self.frame > 63) self.frame = 44;
	self.nextthink = time + 0.1;
	self.think = oldone_animate;
};

void() misc_oldone_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel(self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.count = 0;
		self.alpha = 0.1;
		oldone_animate();
	}
};

void() misc_oldone_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_oldone_on;
	self.estate_off = misc_decor_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_intro_oldone (1 .5 .25) (-16 -16 -16) (16 16 32)
// Introduction cutscene animations & models by Redfield.
void() misc_intro_oldone = { // [ENTITY]
	self.mdl = "progs/redfield/intro/old_one.mdl";
	precache_model (self.mdl);
	precache_sound("redfield/karasu/spell.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_oldone_setup;
};

// QUAKED misc_wolfscene (1 .5 .25) (-16 -16 -16) (16 16 32)
// Wolf cutscene animation/model by Redfield.
void() wolfscene_animate = { // [FUNCTION]
	local entity ds;

	if (self.alpha < 1) self.alpha = self.alpha + 0.2;
	self.frame = self.frame + 1;
	if (self.frame == 13) sound(self,CHAN_VOICE, "redfield/wolf/s_howl.wav",1,ATTN_NORM);
	if (self.frame == 48) {
		BDW_BodyDropSound();
		self.owner = spawn();
		ds = self.owner;
		setmodel(ds, "progs/redfield/big_dust.mdl");
		setorigin(ds, self.origin + '192 -176 -96');
		ds.angles = self.angles;
		ds.alpha = 0.5;
		ds.nextthink = time + 0.4;
		ds.think = SUB_Remove;
	}
	if (self.frame == 49) { self.owner.alpha = 0.4; self.owner.frame = 1; }
	if (self.frame == 50) { self.owner.alpha = 0.2; self.owner.frame = 2; }
	if (self.frame == 51) { self.owner.alpha = 0.1; self.owner.frame = 3; }
	if (self.frame > 55) self.frame = 52;
	self.nextthink = time + 0.1;
	self.think = wolfscene_animate;
};

void() misc_wolfscene_setup = { // [FUNCTION]
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = wolfscene_animate; // Need to set for estate_on to use.
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_wolfscene = { // [ENTITY]
	self.mdl = "progs/redfield/wolf_cutscene.mdl";
	precache_model (self.mdl);
	precache_model ("progs/redfield/big_dust.mdl");
	precache_sound("redfield/wolf/s_howl.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_wolfscene_setup;
};

void() update_rakuyoattach = { // [FUNCTION]
	self.attachment.frame = self.frame;
	self.attachment.alpha = self.alpha;
};

void() huntress_spawnidle = { // [FUNCTION]
	self.frame = self.frame + 1;
	update_rakuyoattach();
	if (self.frame > 237) {
		self.frame = 226;
		update_rakuyoattach();
	}
	self.nextthink = time + 0.1;
	self.think = huntress_spawnidle;
};

void() huntress_spawntransition = { // [FUNCTION]
	self.frame = 226;
	update_rakuyoattach();
	self.nextthink = time + 0.1;
	self.think = huntress_spawnidle;
};

void() huntress_spawnplay = { // [FUNCTION]
	if (self.alpha < 1) self.alpha = self.alpha + 0.2;
	self.frame = self.frame + 1;
	update_rakuyoattach();
	if (self.frame > 237) {
		self.frame = 0;
		sound(self,CHAN_VOICE, "redfield/huntress/sight.wav",1,ATTN_NORM);
	}
	if (self.frame == 14) sound(self,CHAN_WEAPON,"redfield/huntress/ching.wav",1,ATTN_NORM);
	if (self.frame == 15) {
		particle_explode(self.origin + '0 20 24', 6+random()*4, 0.5+random()*0.5, 64, 512);
	}
	if (self.frame == 27) {
		huntress_spawntransition();
		return;
	}
	self.nextthink = time + 0.1;
	self.think = huntress_spawnplay;
};

void() huntress_spawn_setup = { // [FUNCTION]
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = huntress_spawnplay;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_huntress_spawn (1 .5 .25) (-16 -16 -16) (16 16 32)
// Huntress animation/model by Redfield.
void() misc_huntress_spawn = { // [ENTITY]
	self.mdl = "progs/redfield/mon_huntress.mdl";
	precache_model (self.mdl);
	self.headmdl = "progs/redfield/huntress/rakuyo.mdl";
	precache_model (self.headmdl);
	precache_sound("redfield/huntress/sight.wav");
	precache_sound("redfield/huntress/ching.wav");
	self.attachment = spawn();
	self.attachment.classtype = CT_ATTACHMENT;
	setmodel(self.attachment, "");
	setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
	self.attachment.movetype = MOVETYPE_NOCLIP;
	self.attachment.origin = self.origin;
	self.attachment.angles = self.angles;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.frame = 226;
	self.nextthink = time + 0.1;
	self.think = huntress_spawn_setup;
};

void() barmaid_animate = { // [FUNCTION]
	self.frame = self.frame + 1;
	self.attachment.frame = self.frame;
	self.attachment2.frame = self.frame;
	if (self.frame == 20 || self.frame == 60 || self.frame == 80 || self.frame == 140) self.attachment2.skin = 1;
	else self.attachment2.skin = 0;

	if (self.frame == 40) {
		if (random() < 0.65) {
			if (random() < 0.5) sound(self,CHAN_EXTRA1, "redfield/misc/barmaid_hum.wav",1,ATTN_IDLE);
			else sound(self,CHAN_EXTRA1, "redfield/misc/barmaid_hum2.wav",1,ATTN_IDLE);
		}
	}
	if (self.frame > 144) self.frame = 0;
	self.nextthink = time + 0.1;
	self.think = barmaid_animate;
};

void() barmaid_setup_attachment = { // [FUNCTION]
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.classtype = CT_ATTACHMENT;
		setmodel(self.attachment, "progs/redfield/barmaid/barmaid_legs.mdl");
		setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment, self.origin);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.angles = self.angles;
	}
	if (!self.attachment2) {
		self.attachment2 = spawn();
		self.attachment2.classtype = CT_ATTACHMENT;
		setmodel(self.attachment2, "progs/redfield/barmaid/barmaid_head.mdl");
		setsize(self.attachment2,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment2, self.origin);
		self.attachment2.movetype = MOVETYPE_NONE;
		self.attachment2.angles = self.angles;
	}
	barmaid_animate();
};

void() misc_barmaid_setup = { // [FUNCTION]
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = barmaid_setup_attachment;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_barmaid (1 .5 .25) (-16 -16 -24) (16 16 40)
// Barmaid model originally from Return to Castle Wolfenstein, edited by Redfield.
void() misc_barmaid = { // [ENTITY]
	self.mdl = "progs/redfield/barmaid/barmaid_body.mdl";
	precache_model (self.mdl);
	precache_model ("progs/redfield/barmaid/barmaid_legs.mdl");
	precache_model ("progs/redfield/barmaid/barmaid_head.mdl");
	precache_sound("redfield/misc/barmaid_hum.wav");
	precache_sound("redfield/misc/barmaid_hum2.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_barmaid_setup;
};

void() alice_reset = { // [FUNCTION]
	self.skin = 0;
	self.nextthink = time + 2.2;
	self.think = alice_skin;
};

void() alice_skin = { // [FUNCTION]
	self.skin = 1;
	self.nextthink = time + 0.1;
	self.think = alice_reset;
};

void() misc_alice_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = alice_skin;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_alice (1 .5 .25) (-16 -16 -16) (16 16 32)
// Alice model from American McGee's Alice. Modified by Redfield.
void() misc_alice = { // [ENTITY]
	self.mdl = "progs/redfield/alice.mdl";
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_alice_setup;
};

void() fountain_animate = { // [FUNCTION]
	self.count = self.count + 1;
	if (self.count > 56) self.count  = 0;
	self.frame = self.count;
	self.skin = self.skin + 1;
	if (self.skin > 7) self.skin  = 0;
	self.think = fountain_animate;
	self.nextthink = time + 0.1;
};

void() misc_fountain_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = fountain_animate;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_waterfountain (1 .5 .25) (-16 -16 -16) (16 16 32)
// Animated water model for fountain
void() misc_waterfountain = { // [ENTITY]
	self.mdl = "progs/redfield/fountain_water.mdl";
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_fountain_setup;
};

void() cat_anim = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame > 17) self.frame = 0;
	if (self.frame == 12) self.skin = 1;
	else self.skin = 0;

	self.think = cat_anim;
	self.nextthink = time + 0.1;
};

void() misc_cat_setup = { // [FUNCTION]
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = cat_anim;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_cat (1 .5 .25) (-16 -16 -16) (16 16 32)
// Black cat model by Redfield.
void() misc_cat = { // [ENTITY]
	self.mdl = "progs/redfield/cat.mdl";
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_cat_setup;
};

void() cutscenek_finish_attachment = { // [FUNCTION]
	if (self.attachment) {
		setmodel(self.attachment, "");
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

void() karasu_animate = { // [FUNCTION]
	self.count = self.count + 1;
	if (self.count > 134) cutscenek_finish_attachment();
	if (self.count > 164) self.count = 151;
	self.frame = self.count;
	self.attachment.frame = self.count;
	self.think = karasu_animate;
	self.nextthink = time + 0.1;
};

void() misc_karasucutscene_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = karasu_animate;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_karasucutscene (1 .5 .25) (-16 -16 -16) (16 16 32)
// Lord Karasu cutscene model with Raven attachment
void() misc_karasucutscene = { // [ENTITY]
	self.mdl = "progs/redfield/cutscene_karasu.mdl";
	precache_model (self.mdl);
	precache_model ("progs/redfield/cutscene_raven.mdl");
	self.attachment = spawn(); //Raven attachment setup
	self.attachment.angles = self.angles;
	self.attachment.movetype = MOVETYPE_NOCLIP;		// No movement
	self.attachment.solid = SOLID_NOT;			// no world interaction
	setmodel(self.attachment, "progs/redfield/cutscene_raven.mdl");
	setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self.attachment, self.origin);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_karasucutscene_setup;
};

void() misc_spiral_model = { // [FUNCTION]
	if (self.count > 8) self.frame = 9;
	else {
		self.count = self.count + 1;
		self.frame = self.count;
	}
	self.skin = self.skin + 1;
	if (self.skin > 9) self.skin = 0;
	self.nextthink = time + 0.1;
	self.think = misc_spiral_model;
};

void() misc_spiral_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = misc_spiral_model;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_spiral (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x STARTOFF x
// Spiral portal model 
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
// alpha      : alpha value for model (def=0.65)
// -------- SPAWNFLAGS --------
// STARTOFF   : Always Starts off and waits for trigger
// -------- NOTES --------
void() misc_spiral = { // [ENTITY]
	self.mdl = "progs/redfield/spiral_portal.mdl";
	precache_model (self.mdl);
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NOCLIP;		// No collision
	self.nextthink = time + 0.1;
	self.think = misc_spiral_setup;
};

void() misc_redrunes_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_redrunes (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x STARTOFF x
// Spiral portal runes
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
// alpha      : alpha value for model (def=0.65)
// -------- SPAWNFLAGS --------
// STARTOFF   : Always Starts off and waits for trigger
// -------- NOTES --------
void() misc_redrunes = { // [ENTITY]
	self.mdl = "progs/redfield/portal_runes.mdl";
	precache_model (self.mdl);
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NOCLIP;		// No collision
	self.nextthink = time + 0.1;
	self.think = misc_redrunes_setup;
};

void() ufo_setup_beam = { // [FUNCTION]
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.classtype = CT_ATTACHMENT;
		setmodel(self.attachment, "progs/redfield/ufo_beam.mdl");
		setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment, self.origin);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.angles = self.angles;
		self.attachment.alpha = 0.1;
		self.attachment.frame = 0;
	}
};

void() ufo_update_beam = { // [FUNCTION]
	self.attachment.frame = self.attachment.frame + 1;
	if (self.attachment.frame > 9) self.attachment.frame = 9;
};

void() ufo_remove_beam = { // [FUNCTION]
	if (self.attachment) {
		setmodel(self.attachment, "");
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

void() ufo_flyaway = { // [FUNCTION]
	self.frame = self.frame + 1;
	self.alpha = self.alpha - 0.1;
	if (self.frame == 139) misc_ufo_off();
	else {
		self.nextthink = time + 0.1;
		self.think = ufo_flyaway;
	}
};

void() check_beamTrig = { // [FUNCTION]
	if (self.target != "") trigger_strs(self.target, self); // Is there any trigger on the ufo?
};
	
void() ufo_animate = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.alpha < 1) self.alpha = self.alpha + 0.1;
	if (self.frame == 57) self.skin = 1;
	if (self.frame == 58) self.skin = 2;
	if (self.frame == 59) self.skin = 3;
	if (self.frame == 60) self.skin = 4;
	if (self.frame == 59) ufo_setup_beam();
	if (self.frame > 59 && self.frame < 69) ufo_update_beam();
	if (self.frame == 74) check_beamTrig(); 
	if (self.frame == 89) { self.skin = 3; self.attachment.frame = 7; }
	if (self.frame == 90) { self.skin = 2; self.attachment.frame = 5; }
	if (self.frame == 91) { self.skin = 1; self.attachment.frame = 2; }
	if (self.frame == 92) { self.skin = 0; ufo_remove_beam(); }
	if (self.frame == 129) {
		self.nextthink = time + 0.1;
		self.think = ufo_flyaway;
	} else {
		self.nextthink = time + 0.1;
		self.think = ufo_animate;
	}
};

void() misc_ufo_on = { // [FUNCTION]
	self.alpha = 0.1;
	misc_decor_on();
};

void() misc_ufo_setup = { // [FUNCTION]
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_ufo_on;
	self.estate_off = misc_decor_off;
	self.think1 = ufo_animate;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_ufo (1 .5 .25) (-16 -16 -16) (16 16 32)
// Secret UFO model.
void() misc_ufo = { // [ENTITY]
	self.mdl = "progs/redfield/ufo.mdl";
	precache_model (self.mdl);
	precache_model ("progs/redfield/ufo_beam.mdl");
	precache_sound("redfield/misc/ufo_beam.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_ufo_setup;
};

void() misc_firefx_model =  { // [FUNCTION]
	self.skin = self.skin + 1;
	if (self.skin > 19) { self.skin = 0; }
	self.think = misc_firefx_model;
	self.nextthink = time + 0.1;
};

void() misc_firefx_setup = { // [FUNCTION]
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_decor_on;
	self.estate_off = misc_decor_off;
	self.think1 = misc_firefx_model;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

// QUAKED misc_firefx (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x STARTOFF x
// Animated firel mesh 
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
// alpha      : alpha value for model
// frame      : frame 0 small or 1 for large flames
// -------- SPAWNFLAGS --------
// STARTOFF   : Always Starts off and waits for trigger
void() misc_firefx = { // [ENTITY]
	self.mdl = "progs/redfield/fx_fire.mdl";
	precache_model (self.mdl);
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NOCLIP;		// No collision
	self.skin = rint(random() * 19);
	self.nextthink = time + 0.1;
	self.think = misc_firefx_setup;
};

void() misc_grass_frame = { // [FUNCTION]
	fgrasscount = fgrasscount + 1;
	self.frame = self.frame + fgrasscount;
	if (self.frame > 34) { self.frame = 0; }
	fgrasscount = 0;
	self.think = misc_grass_frame;
	self.nextthink = time + 0.1;
};

// QUAKED misc_grass (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x x x
// Animated grass meshes 
// -------- KEYS --------
// angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
// -------- SPAWNFLAGS --------
// GrassB   : Alternate grass model
// -------- NOTES --------
void() misc_grass = { // [ENTITY]
	if (self.spawnflags & GRASS_B) {
		self.mdl = "progs/redfield/grass2.mdl";
		precache_model (self.mdl);
	}

	if (!(self.spawnflags & GRASS_B)) {
		self.mdl = "progs/redfield/grass1.mdl";
		precache_model (self.mdl);
	}
	setmodel(self, self.mdl);
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;			// No collision
	self.frame = rint(random() * 34);
	self.nextthink = time + 0.1;
	self.think = misc_grass_frame;
};

void() bell_loop = { // [FUNCTION]
	self.frame = self.frame + 1;
	if (self.frame == 3) { sound(self,CHAN_EXTRA1, "redfield/misc/bell_toll.wav",1,ATTN_NORM); }
	if (self.frame > 29) {
		self.frame = 0;
		return;
	} else self.nextthink = time + 0.1;
	self.think = bell_loop;
}

// Shoot the Bell
void(entity inflictor, entity attacker, float damage) misc_bell_toll = { // [FUNCTION]
	if (self.pain_finished > time) return;

	belltrig_count = belltrig_count + 1;
	if (self.target != "") { trigger_strs(self.target, other); } // Check for any triggers
	self.pain_finished = time + self.delay;
	self.health = 9999;
	bell_loop();
};

void() misc_bell_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.mdl);
	setsize(self, self.bbmins, self.bbmaxs);
	self.th_pain = misc_bell_toll;
	self.takedamage = DAMAGE_AIM;
};

void() misc_bell_setup = { // [FUNCTION]
	self.classtype = CT_MISCBELL;
	self.classgroup = CG_BREAKABLE;
	if (self.health < 1) self.health = 9999;
	if (!self.delay) self.delay = 4;
	self.bleedcolour = MON_BCOLOR_WHITE;
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_bell_on;
	self.estate_off = misc_decor_off;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

// QUAKED misc_bell (0 0.5 0.8) (-16 -16 0) (16 16 16) x x x x x x STARTOFF
// { model(":progs/tower_bell.mdl"); }
// -------- KEYS --------
// target        : trigger events when bell rings
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Shootable bell with animation/sound
void() misc_bellredfield = { // [ENTITY]
	self.mdl = "progs/redfield/tower_bell.mdl";	
	precache_model (self.mdl);
	precache_sound("redfield/misc/bell_toll.wav");
	self.frame = 0;
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';
	misc_bell_setup();
};

// Break the vase
void() misc_vase_break = { // [FUNCTION]
	if (self.attack_finished > time) return;

	self.attack_finished = time + LARGE_TIMER;
	self.estate_off(); // Switch off everything
	
	// Play breaking sound
	if (random() < 0.2) { sound(self,CHAN_EXTRA2, "ad171/break/ceramic_impact.wav",1,ATTN_IDLE); }
	else if (random() < 0.35) { sound(self,CHAN_EXTRA2, "ad171/break/ceramic_impact2.wav",1,ATTN_IDLE); }
	else if (random() < 0.5) { sound(self,CHAN_EXTRA2, "ad171/break/ceramic_impact3.wav",1,ATTN_IDLE); }
	else if (random() < 0.65) { sound(self,CHAN_EXTRA2, "ad171/break/ceramic_impact4.wav",1,ATTN_IDLE); }
	else if (random() < 0.8) { sound(self,CHAN_EXTRA2, "ad171/break/ceramic_impact5.wav",1,ATTN_IDLE); }
	else { sound(self,CHAN_EXTRA2, "ad171/break/ceramic_impact6.wav",1,ATTN_IDLE); }

	if (ext_dppart) pointparticles(particleeffectnum(DPP_TEBSMOKE), self.origin, '0 0 0', 1); //DP smoke effects
	if (self.target != "") trigger_strs(self.target, other); // Check for any explosion triggers
	if (self.spawnflags & 2) {
		ThrowGib(11, 1 + rint(random()*2));
		ThrowGib(12, 1 + rint(random()*2));
		ThrowGib(13, 1 + rint(random()*2));
		ThrowGib(14, 1 + rint(random()*2));
		SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, "");
		if (random() > 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 250);
	} else {
		ThrowGib(13, 1 + rint(random()*2));
		ThrowGib(14, 1 + rint(random()*2));
	}

	if (self.spawnflags & 4) DropBackpack();
	entity_hide(self);
};

void() misc_vase_use = { // [FUNCTION]
	// If box is setup off, switch on first
	if (self.spawnflags & ENT_STARTOFF) {
		self.spawnflags = self.spawnflags - ENT_STARTOFF;
		self.estate_on();
	} else misc_vase_break(); // No toggle function, just blow it up!
};

void() misc_vase_on = { // [FUNCTION]
	if (self.attack_finished > time) return; // If the box has exploded, do nothing
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.estate = ESTATE_ON;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.mdl);
	setsize(self, self.bbmins, self.bbmaxs);
	self.th_die = misc_vase_break;
	self.takedamage = DAMAGE_AIM;
};

void() misc_vase_setup = { // [FUNCTION]
	precache_sound("ad171/break/ceramic_impact.wav");
	precache_sound("ad171/break/ceramic_impact2.wav");
	precache_sound("ad171/break/ceramic_impact3.wav");
	precache_sound("ad171/break/ceramic_impact4.wav");
	precache_sound("ad171/break/ceramic_impact5.wav");
	precache_sound("ad171/break/ceramic_impact6.wav");
	self.gib1mdl = "progs/redfield/gib1_vase.mdl";
	self.gib2mdl = "progs/redfield/gib2_vase.mdl";
	self.gib3mdl = "progs/redfield/gib3_vase.mdl";
	self.gib4mdl = "progs/redfield/gib4_vase.mdl";
	precache_model (self.gib1mdl);
	precache_model (self.gib2mdl);
	precache_model (self.gib3mdl);
	precache_model (self.gib4mdl);
	self.classtype = CT_MISCVASE;
	self.classgroup = CG_BREAKABLE;
	if (self.health < 1) self.health = 1;		
	self.gibtype = GIBTYPE_CERAMIC;	
	self.bleedcolour = MON_BCOLOR_WHITE;
	self.ammo_shells = 1;
	SUB_CheckRandomizedAngles(); // Handle randomized rotation, if set.  Bound angles to range of 0 to 360.
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = misc_vase_on;
	self.estate_off = misc_decor_off;
	self.estate_use = misc_vase_use;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

// QUAKED misc_vase (0 0.5 0.8) (-16 -16 0) (16 16 16) FLAME LARGE x x x x STARTOFF
// { model(":progs/vase.mdl"); }
// -------- KEYS --------
// target        : trigger events when vase breaks
// health        : Amount of health before breaking (def = 1)
// -------- SPAWNFLAGS --------
// FLAME    : Animated incense burning flame
// LARGE	 : Large vase frame 
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Breakable Vase
void() misc_vase = { // [ENTITY]
	self.mdl = "progs/ad181/brk_vase1.mdl";	
	precache_model (self.mdl);
	
	if (self.spawnflags == 3 || self.spawnflags == 7 || self.spawnflags == 67 || self.spawnflags == 71) {
		self.frame = 3;
		self.bbmins = '-10 -10 -16';
		self.bbmaxs = '10 10 24';
	} else if (self.spawnflags == 2 || self.spawnflags == 6 || self.spawnflags == 66 || self.spawnflags == 70) {
		self.frame = 2;
		self.bbmins = '-10 -10 -16';
		self.bbmaxs = '10 10 24';
	} else if (self.spawnflags == 1 || self.spawnflags == 5 || self.spawnflags == 65 || self.spawnflags == 69) {
		self.frame = 1;
		self.bbmins = '-6 -6 -16';
		self.bbmaxs = '6 6 8';
	} else {
		self.frame = 0;
		self.bbmins = '-6 -6 -16';
		self.bbmaxs = '6 6 8';
	}	
	misc_vase_setup();
};

// Handles animation for misc_modelrdm entity.
void() misc_modelrdm_think = { // [FUNCTION]
    self.nextthink = time + fabs(self.speed);
    self.frame = self.frame + sign(self.speed);
    self.frame = wrap(self.frame, self.first_frame, self.last_frame);
};

// SERIOUSLY, ANOTHER ONE!!!! - Qmaster
// Author: Joshua Skelton joshua.skelton@gmail.com
// Adapted for Raven Keep by Redfield
// An entity for displaying models. A frame range can be given to animate the model.
// mdl: The model to display. Can be of type mdl, bsp, or spr.
// frame: The frame to display. Can be used to offset the animation.
// first_frame: The starting frame of the animation.
// last_frame: The last frame of the animation.
void() misc_modelrdm = { // [ENTITY]
    precache_model(self.mdl);
    setmodel(self, self.mdl);
    if (!self.frame) self.frame = self.first_frame;
    if (!self.last_frame) { makestatic(self); return; } // Only animate if given a frame range.

    if (!self.speed) self.speed = 0.1; // Default animation speed to 10 fps
    self.nextthink = time + self.speed;
    self.think = misc_modelrdm_think;
};

// Convert to new ladder system
void() func_ladder = { self.spawnflags = TRIG_LADDERVELOCITY; trigger_ladder(); }; // [ENTITY], Re-direct