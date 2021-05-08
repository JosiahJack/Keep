/*======================================================================
 Math
======================================================================*/
/* From Joshua Skelton
 * sign
 *
 * Returns an indication of the sign of the given number.
 *
 * x: A number
 *
 * Returns: -1 if x < 0, 0 if x == 0, 1 if x > 0.
 */
float(float x) sign = {
    if (x > 0) {
        return 1;
    }
    else if (x < 0) {
        return -1;
    }

    return 0;
};

/*
 * wrap
 *
 * Limits the given value to the given range and will wrap the value to the
 * the other end of the range if exceeded.
 *
 * value: A number
 *
 * minValue: The minimum value of the range
 *
 * maxValue: The maximum value of the range
 *
 * Returns: A number within the given range.
 */
float(float value, float minValue, float maxValue) wrap = {
    local float range = maxValue - minValue;

    return mod(value - minValue, range + 1) + minValue;
};

//----------------------------------------------------------------------
/*
CSHIFT FLASH EFFECT
*/
//----------------------------------------------------------------------
//----------------------------------------------------------------------
// cshiftflash functions needed for triggered cshift effect on lightning flash
// This is a really brutal method and should be done more elegantly
// Used as a work around for lightning flash when max lightstyles is reached 
// This is unfortunate reality of working with ancient Quake engines
// Always starts off and waits for trigger

float screen_time;

void() cshiftflash_loop =
{
	
	if (screen_time < 1) {
		localcmd("v_cshift 255 255 255 75\n");
	}
	else if (screen_time == 1) {
		localcmd("v_cshift 255 255 255 25\n");
	}
	else {
		//ResetCShift(self);
		localcmd("v_cshift 0 0 0 0\n");
		return;
	}
	screen_time = screen_time + 1;
	self.nextthink = time + 0.2;
	self.think = cshiftflash_loop;
};

void() misc_cshiftflash_on =
{
	self.estate = ESTATE_ON;
	screen_time = 0;
	cshiftflash_loop();
};
void() misc_cshiftflash_off =
{
	self.estate = ESTATE_OFF;

};
void() misc_cshiftflash_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_cshiftflash_on;
	self.estate_off = misc_cshiftflash_off;
	entity_state_off();
};
void() misc_cshiftflash =
{
	self.nextthink = time + 0.1;
	self.think = misc_cshiftflash_setup;
};

//----------------------------------------------------------------------
/*
MISCELLANEOUS - PROPS, EFFECTS, ANIMATED MODELS FROM REDFIELD
*/
//----------------------------------------------------------------------

//----------------------------------------------------------------------
/*QUAKED misc_godray (1 .5 .25) (-16 -16 -16) (16 16 32)

Godray meshes with animated opacity.
*/

void() godray_alpha_inc;

void() godray_alpha_dec =
{
	if (self.alpha <= 0.02) {
		godray_alpha_inc();
		return;
	}
	self.alpha = self.alpha - 0.001;
	self.nextthink = time + 0.05;
	self.think = godray_alpha_dec;
};

void() godray_alpha_inc =
{
	if (self.alpha > 0.06) {
		godray_alpha_dec();
		return;
	}
	self.alpha = self.alpha + 0.001;
	self.nextthink = time + 0.05;
	self.think = godray_alpha_inc;
};
void() misc_godray_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		godray_alpha_dec();
	}
};
void() misc_godray_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_godray_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_godray_on;
	self.estate_off = misc_godray_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_godray =
{
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_godray_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_saluteknight (1 .5 .25) (-16 -16 -16) (16 16 32)

*/
void() saluteknight_hold = 
{
	self.frame = 121;
	self.nextthink = time + LARGE_TIMER;
	self.think = saluteknight_hold;
};

void() saluteknight_transition =
{
	self.frame = self.frame + 1;
	if (self.frame >= 121) {
		sound (self, CHAN_VOICE, "misc/armor_clink.wav", 1, ATTN_NORM);
		saluteknight_hold();
		return;
	}
	self.nextthink = time + 0.1;
	self.think = saluteknight_transition;
};

void() saluteknight_use =
{
	self.frame = 117;
	self.nextthink = time + 0.1;
	self.think = saluteknight_transition;
};

void() saluteknight_animate =
{
	self.frame = self.frame + 1;
	if (self.frame > 8) self.frame = 0;
	self.nextthink = time + 0.1;
	self.think = saluteknight_animate;
};

void() misc_saluteknight_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		saluteknight_animate();
	}
};
void() misc_saluteknight_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_saluteknight_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_saluteknight_on;
	self.estate_off = misc_saluteknight_off;
	self.estate_use = saluteknight_use;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_saluteknight =
{
	self.mdl = "progs/mon_knight.mdl";
	precache_model (self.mdl);
	precache_sound ("misc/armor_clink.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_saluteknight_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_intro_oldone (1 .5 .25) (-16 -16 -16) (16 16 32)

Introduction cutscene animations & models by Redfield.
*/
void() check_oldoneTrig =
// Is there any trigger on the oldone?
{
	if (self.noise != "") {
		self.attachment = find(world, targetname, self.noise);
				if (self.attachment.target != "") 
					trigger_strs(self.attachment.target, self);
	}
};


void() oldone_animate =
{
	self.count = self.count + 1;
	if (self.alpha < 1) self.alpha = self.alpha + 0.1;
	if (self.count > 9) {
		self.frame = self.frame + 1;
	}
	if (self.frame == 4) {
		sound (self, CHAN_VOICE, "karasu/spell.wav", 1, ATTN_IDLE);
		check_oldoneTrig();		
	}
	if (self.frame > 63) self.frame = 44;
	self.nextthink = time + 0.1;
	self.think = oldone_animate;
};
void() misc_oldone_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.count = 0;
		self.alpha = 0.1;
		oldone_animate();
	}
};
void() misc_oldone_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_oldone_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_oldone_on;
	self.estate_off = misc_oldone_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_intro_oldone =
{
	self.mdl = "progs/intro/old_one.mdl";
	precache_model (self.mdl);
	precache_sound ("karasu/spell.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_oldone_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_wolfscene (1 .5 .25) (-16 -16 -16) (16 16 32)

Wolf cutscene animation/model by Redfield.
*/

void() wolfscene_animate =
{
	if (self.alpha < 1) self.alpha = self.alpha + 0.2;
	self.frame = self.frame + 1;
	if (self.frame == 13) sound (self, CHAN_VOICE, "wolf/s_howl.wav", 1, ATTN_NORM);
	if (self.frame == 48) {
		sound (self, CHAN_EXTRA1, "demon/dland2.wav", 1, ATTN_NORM);
		local entity ds;
		self.owner = spawn();
		ds = self.owner;
		setmodel (ds, "progs/big_dust.mdl");
		setorigin (ds, self.origin + '192 -176 -96');
		ds.angles = self.angles;
		ds.alpha = 0.5;
		ds.nextthink = time + 0.4;
		ds.think = SUB_Remove;
	}
	if (self.frame == 49) {self.owner.alpha = 0.4; self.owner.frame = 1;}
	if (self.frame == 50) {self.owner.alpha = 0.2; self.owner.frame = 2;}
	if (self.frame == 51) {self.owner.alpha = 0.1; self.owner.frame = 3;}
	if (self.frame > 55) self.frame = 52;
	self.nextthink = time + 0.1;
	self.think = wolfscene_animate;
};
void() misc_wolfscene_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		wolfscene_animate();
	}
};
void() misc_wolfscene_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_wolfscene_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_wolfscene_on;
	self.estate_off = misc_wolfscene_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_wolfscene =
{
	self.mdl = "progs/wolf_cutscene.mdl";
	precache_model (self.mdl);
	precache_model ("progs/big_dust.mdl");
	precache_sound ("wolf/s_howl.wav");
	precache_sound ("demon/dland2.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_wolfscene_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_huntress_spawn (1 .5 .25) (-16 -16 -16) (16 16 32)

Huntress animation/model by Redfield.
*/

void() update_rakuyoattach = {
	self.attachment.frame = self.frame;
	self.attachment.alpha = self.alpha;
};

void() huntress_spawnidle =
{
	self.frame = self.frame + 1;
	update_rakuyoattach();
	if (self.frame > 237) {
		self.frame = 226;
		update_rakuyoattach();
	}
	self.nextthink = time + 0.1;
	self.think = huntress_spawnidle;
};

void() huntress_spawntransition =
{
	self.frame = 226;
	update_rakuyoattach();
	self.nextthink = time + 0.1;
	self.think = huntress_spawnidle;
};

void() huntress_spawnplay =
{
	if (self.alpha < 1) self.alpha = self.alpha + 0.2;
	self.frame = self.frame + 1;
	update_rakuyoattach();
	if (self.frame > 237) {
		self.frame = 0;
		sound(self, CHAN_VOICE, "huntress/sight.wav", 1, ATTN_NORM);
	}
	if (self.frame == 14) sound(self, CHAN_WEAPON, "huntress/ching.wav", 1, ATTN_NORM);
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

void() huntress_spawn_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		setmodel(self.attachment, "progs/huntress/rakuyo.mdl");
		setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
		huntress_spawnplay();
	}
};
void() huntress_spawn_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment.solid = SOLID_NOT;		// no world interaction
		setmodel(self.attachment,"");			// Hide model
	}
};
void() huntress_spawn_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = huntress_spawn_on;
	self.estate_off = huntress_spawn_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_huntress_spawn =
{
	self.mdl = "progs/mon_huntress.mdl";
	precache_model (self.mdl);
	precache_model ("progs/huntress/rakuyo.mdl");
	precache_sound ("huntress/sight.wav");
	precache_sound ("huntress/ching.wav");

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

//----------------------------------------------------------------------
/*QUAKED misc_barmaid (1 .5 .25) (-16 -16 -24) (16 16 40)

Barmaid model originally from Retrun to Castle Wolfenstein, edited by Redfield.
*/
void() barmaid_sound =
{
	if (random() < 0.5) {
		sound (self, CHAN_EXTRA1, "misc/barmaid_hum.wav", 1, ATTN_IDLE);
	}
	else {
		sound (self, CHAN_EXTRA1, "misc/barmaid_hum2.wav", 1, ATTN_IDLE);
	}
};

void() barmaid_animate =
{
	self.frame = self.frame + 1;
	self.attachment.frame = self.frame;
	self.attachment2.frame = self.frame;
	if (self.frame == 20 || self.frame == 60 || self.frame == 80 || self.frame == 140) {
		self.attachment2.skin = 1;
		}
	else {
		self.attachment2.skin = 0;
	}
	if (self.frame == 40) {
		if (random() < 0.65) barmaid_sound();
	}
	if (self.frame > 144) self.frame = 0;
	self.nextthink = time + 0.1;
	self.think = barmaid_animate;
};

void() barmaid_setup_attachment =
{
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.classtype = CT_ATTACHMENT;
		setmodel(self.attachment, "progs/barmaid/barmaid_legs.mdl");
		setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment, self.origin);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.angles = self.angles;
	}
	if (!self.attachment2) {
		self.attachment2 = spawn();
		self.attachment2.classtype = CT_ATTACHMENT;
		setmodel(self.attachment2, "progs/barmaid/barmaid_head.mdl");
		setsize(self.attachment2,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment2, self.origin);
		self.attachment2.movetype = MOVETYPE_NONE;
		self.attachment2.angles = self.angles;
	}
	barmaid_animate();
};

void() misc_barmaid_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		barmaid_setup_attachment();
	}
};
void() misc_barmaid_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment.solid = SOLID_NOT;			// no world interaction
		setmodel(self.attachment,"");
		self.attachment.velocity = '0 0 0';
	}
	if (self.attachment2) {
		self.attachment2.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment2.solid = SOLID_NOT;			// no world interaction
		setmodel(self.attachment2,"");
		self.attachment2.velocity = '0 0 0';
	}	
};
void() misc_barmaid_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_barmaid_on;
	self.estate_off = misc_barmaid_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_barmaid =
{
	self.mdl = "progs/barmaid/barmaid_body.mdl";
	precache_model (self.mdl);
	precache_model ("progs/barmaid/barmaid_legs.mdl");
	precache_model ("progs/barmaid/barmaid_head.mdl");
	precache_sound ("misc/barmaid_hum.wav");
	precache_sound ("misc/barmaid_hum2.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_barmaid_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_alice (1 .5 .25) (-16 -16 -16) (16 16 32)

Alice model from American McGee's Alice. Modified by Redfield.
*/
void() alice_skin;

void() alice_reset =
{
	self.skin = 0;
	self.nextthink = time + 2.2;
	self.think = alice_skin;
};
void() alice_skin =
{
	self.skin = 1;
	self.nextthink = time + 0.1;
	self.think = alice_reset;
};
void() misc_alice_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		alice_skin();
	}
};
void() misc_alice_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_alice_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_alice_on;
	self.estate_off = misc_alice_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_alice =
{
	self.mdl = "progs/alice.mdl";
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_alice_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_waterfountain (1 .5 .25) (-16 -16 -16) (16 16 32)

Animated water model for fountain
*/

float waterskin;

void() fountain_skin =
{
	waterskin = waterskin + 1;
	self.skin = self.skin + waterskin;
	if (self.skin > 7) {self.skin  = 0;}
	waterskin = 0;
};
void() fountain_animate =
{
	self.count = self.count + 1;
	if (self.count > 56) self.count  = 0;
	self.frame = self.count;
	fountain_skin();
	self.think = fountain_animate;
	self.nextthink = time + 0.1;
};
void() misc_fountain_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		fountain_animate();
	}
};
void() misc_fountain_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_fountain_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_fountain_on;
	self.estate_off = misc_fountain_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_waterfountain =
{
	self.mdl = "progs/fountain_water.mdl";
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_fountain_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_cat (1 .5 .25) (-16 -16 -16) (16 16 32)
Black cat model by Redfield.
*/
void() cat_anim = 
{
	self.frame = self.frame + 1;
	if (self.frame > 17) self.frame = 0;
	if (self.frame == 12) 
	{
	self.skin = 1;
	}
	else
	{
	self.skin = 0;
	}
	self.think = cat_anim;
	self.nextthink = time + 0.1;
};

void() misc_cat_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		cat_anim();
	}
};

//----------------------------------------------------------------------
void() misc_cat_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};

//----------------------------------------------------------------------
void() misc_cat_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_cat_on;
	self.estate_off = misc_cat_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_cat =

{
	self.mdl = "progs/cat.mdl";
	precache_model (self.mdl);
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_cat_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_karasucutscene (1 .5 .25) (-16 -16 -16) (16 16 32)
Lord Karasu cutscene model with Raven attachment
*/
//----------------------------------------------------------------------
void() cutscenek_finish_attachment =
{
	if (self.attachment) {
		setmodel(self.attachment, "");
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};
void() karasu_animate = 
{
	self.count = self.count + 1;
	if (self.count > 134) cutscenek_finish_attachment();
	if (self.count > 164) self.count = 151;
	self.frame = self.count;
	self.attachment.frame = self.count;
	self.think = karasu_animate;
	self.nextthink = time + 0.1;
};

void() misc_karasucutscene_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		karasu_animate();
	}
};

//----------------------------------------------------------------------
void() misc_karasucutscene_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};

//----------------------------------------------------------------------
void() misc_karasucutscene_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_karasucutscene_on;
	self.estate_off = misc_karasucutscene_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

void() misc_karasucutscene =

{
	self.mdl = "progs/cutscene_karasu.mdl";
	precache_model (self.mdl);
	precache_model ("progs/cutscene_raven.mdl");

	//Raven attachment setup
	self.attachment = spawn();
	self.attachment.angles = self.angles;
	self.attachment.movetype = MOVETYPE_NOCLIP;		// No movement
	self.attachment.solid = SOLID_NOT;			// no world interaction
	setmodel(self.attachment, "progs/cutscene_raven.mdl");
	setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self.attachment, self.origin);

	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_karasucutscene_setup;
};

//======================================================================
/*QUAKED misc_spiral (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x STARTOFF x
Spiral portal model 
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
alpha      : alpha value for model (def=0.65)
-------- SPAWNFLAGS --------
STARTOFF   : Always Starts off and waits for trigger
-------- NOTES --------

======================================================================*/
float skincount;

void() misc_spiral_model = 
{
	if (self.count > 8) self.frame = 9;
	else {
		self.count = self.count + 1;
		self.frame = self.count;
	}
	skincount = skincount + 1;
	self.skin = self.skin + skincount;
	if (self.skin > 9) {self.skin = 0;}
	skincount = 0;
	self.nextthink = time + 0.1;
	self.think = misc_spiral_model;
};

void() misc_spiral_on =
{
	self.estate = ESTATE_ON;


	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		misc_spiral_model();
	}
};

//----------------------------------------------------------------------
void() misc_spiral_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};

//----------------------------------------------------------------------
void() misc_spiral_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_spiral_on;
	self.estate_off = misc_spiral_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

//----------------------------------------------------------------------
void() misc_spiral =
{
	self.mdl = "progs/spiral_portal.mdl";
	precache_model (self.mdl);

	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NOCLIP;		// No collision
	self.nextthink = time + 0.1;
	self.think = misc_spiral_setup;
};

//======================================================================
/*QUAKED misc_redrunes (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x STARTOFF x
Spiral portal runes
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
alpha      : alpha value for model (def=0.65)
-------- SPAWNFLAGS --------
STARTOFF   : Always Starts off and waits for trigger
-------- NOTES --------

======================================================================*/

void() misc_redrunes_on =
{
	self.estate = ESTATE_ON;


	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
	}
};

//----------------------------------------------------------------------
void() misc_redrunes_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};

//----------------------------------------------------------------------
void() misc_redrunes_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_redrunes_on;
	self.estate_off = misc_redrunes_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

//----------------------------------------------------------------------
void() misc_redrunes =
{
	self.mdl = "progs/portal_runes.mdl";
	precache_model (self.mdl);

	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NOCLIP;		// No collision
	self.nextthink = time + 0.1;
	self.think = misc_redrunes_setup;
};

//----------------------------------------------------------------------
/*QUAKED misc_ufo (1 .5 .25) (-16 -16 -16) (16 16 32)

Secret UFO model.
*/

void() misc_ufo_off;

void() ufo_setup_beam =
{
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.classtype = CT_ATTACHMENT;
		setmodel(self.attachment, "progs/ufo_beam.mdl");
		setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment, self.origin);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.angles = self.angles;
		self.attachment.alpha = 0.1;
		self.attachment.frame = 0;
	}
};

void() ufo_update_beam =
{
	self.attachment.frame = self.attachment.frame + 1;
	if (self.attachment.frame > 9) self.attachment.frame = 9;
};

void() ufo_remove_beam =
{
	if (self.attachment) {
		setmodel(self.attachment, "");
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

void() ufo_flyaway =
{
	self.frame = self.frame + 1;
	self.alpha = self.alpha - 0.1;
	if (self.frame == 139) misc_ufo_off();
	else {
		self.nextthink = time + 0.1;
		self.think = ufo_flyaway;
	}
};

void() check_beamTrig =
// Is there any trigger on the ufo?
{
	if (self.target != "") trigger_strs(self.target, self);
};
	
void() ufo_animate =
{
	self.frame = self.frame + 1;
	if (self.alpha < 1) self.alpha = self.alpha + 0.1;
	if (self.frame == 57) self.skin = 1;
	if (self.frame == 58) self.skin = 2;
	if (self.frame == 59) self.skin = 3;
	if (self.frame == 60) self.skin = 4;
	if (self.frame == 59) ufo_setup_beam();
	if (self.frame > 59 && self.frame < 69) ufo_update_beam();
	if (self.frame == 74) check_beamTrig(); 
	if (self.frame == 89) {self.skin = 3; self.attachment.frame = 7;}
	if (self.frame == 90) {self.skin = 2; self.attachment.frame = 5;}
	if (self.frame == 91) {self.skin = 1; self.attachment.frame = 2;}
	if (self.frame == 92) {self.skin = 0; ufo_remove_beam();}
	if (self.frame == 129) {
		self.nextthink = time + 0.1;
		self.think = ufo_flyaway;
	}
	else {
		self.nextthink = time + 0.1;
		self.think = ufo_animate;
	}
};

void() misc_ufo_on =
{
	self.estate = ESTATE_ON;
	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		self.alpha = 0.1;
		ufo_animate();
	}
};
void() misc_ufo_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};
void() misc_ufo_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_ufo_on;
	self.estate_off = misc_ufo_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};
void() misc_ufo =
{
	self.mdl = "progs/ufo.mdl";
	precache_model (self.mdl);
	precache_model ("progs/ufo_beam.mdl");
	precache_sound ("misc/ufo_beam.wav");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	self.think = misc_ufo_setup;
};


//======================================================================
/*QUAKED misc_firefx (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x STARTOFF x
Animated firel mesh 
-------- KEYS --------
targetname : toggle state (use trigger ent for exact state)
angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
alpha      : alpha value for model
frame      : frame 0 small or 1 for large flames
-------- SPAWNFLAGS --------
STARTOFF   : Always Starts off and waits for trigger
-------- NOTES --------

======================================================================*/
float fskincount;

void() misc_firefx_model = 
{
	fskincount = fskincount + 1;
	self.skin = self.skin + fskincount;
	if (self.skin > 19) {self.skin = 0;}
	fskincount = 0;
	self.think = misc_firefx_model;
	self.nextthink = time + 0.1;
};

void() misc_firefx_on =
{
	self.estate = ESTATE_ON;


	// Restore model/size/skin
	if (self.mdl != "") {
		setmodel (self, self.mdl);
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		misc_firefx_model();
	}
};

//----------------------------------------------------------------------
void() misc_firefx_off =
{
	self.estate = ESTATE_OFF;
	// Turn off model if setup
	if (self.mdl != "") {
		self.modelindex = 0;	// Make sure no model
		self.model = "";		// Hide model
	}
};

//----------------------------------------------------------------------
void() misc_firefx_setup =
{
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_firefx_on;
	self.estate_off = misc_firefx_off;
	if (self.spawnflags & (MISC_STARTOFF | ENT_STARTOFF)) entity_state_off();
	else entity_state_on();
};

//----------------------------------------------------------------------
void() misc_firefx =
{
	self.mdl = "progs/fx_fire.mdl";
	precache_model (self.mdl);

	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NOCLIP;		// No collision
	self.skin = rint(random() * 19);
	self.nextthink = time + 0.1;
	self.think = misc_firefx_setup;
};

//======================================================================
/*QUAKED misc_grass (.5 .5 .75) (-8 -8 -8) (8 8 192) x x x x x x x x
Animated grass meshes 
-------- KEYS --------
angles     : 'pitch roll yaw' up/down, angle, tilt left/right 
-------- SPAWNFLAGS --------
GrassB   : Alternate grass model
-------- NOTES --------

======================================================================*/
float GRASS_B = 1;
float fgrasscount;

void() misc_grass_frame = 
{
	fgrasscount = fgrasscount + 1;
	self.frame = self.frame + fgrasscount;
	if (self.frame > 34) {self.frame = 0;}
	fgrasscount = 0;
	self.think = misc_grass_frame;
	self.nextthink = time + 0.1;
};


void() misc_grass =
{
	if (self.spawnflags & GRASS_B) {
		self.mdl = "progs/grass2.mdl";
		precache_model (self.mdl);
	}
	if (!(self.spawnflags & GRASS_B)) {
		self.mdl = "progs/grass1.mdl";
		precache_model (self.mdl);
	}
	setmodel (self, self.mdl);
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;			// No collision
	self.frame = rint(random() * 34);
	self.nextthink = time + 0.1;
	self.think = misc_grass_frame;
};

//============================================================================

/*======================================================================
/*QUAKED misc_bell (0 0.5 0.8) (-16 -16 0) (16 16 16) x x x x x x STARTOFF
{ model(":progs/tower_bell.mdl"); }
-------- KEYS --------
target        : trigger events when bell rings
-------- SPAWNFLAGS --------
STARTOFF : Starts off and waits for trigger
-------- NOTES --------
Shootable bell with animation/sound

======================================================================*/

//----------------------------------------------------------------------
float belltrig_count;

void() bell_loop =
{
	self.frame = self.frame + 1;
	if (self.frame == 3) {sound (self, CHAN_EXTRA1, "misc/bell_toll.wav", 1, ATTN_NORM);}
	if (self.frame > 29) {
		self.frame = 0;
		return;
	}
	else
	self.nextthink = time + 0.1;
	self.think = bell_loop;
}

// Shoot the Bell
void(entity inflictor, entity attacker, float damage) misc_bell_toll =
{
	if (belltrig_count == 0) {
		belltrig_count = belltrig_count + 1;
		// Check for any triggers
		if (self.target != "") {trigger_strs(self.target, other);}
	}
	
	self.pain_finished = time + 4;
	self.health = 9999;
	bell_loop();
};

//----------------------------------------------------------------------
void() misc_bell_on =
{
	self.estate = ESTATE_ON;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.mdl);
	setsize(self, self.bbmins, self.bbmaxs);
	
	self.th_pain = misc_bell_toll;
	self.takedamage = DAMAGE_AIM;
	
};

//----------------------------------------------------------------------
void() misc_bell_off = 
{
	self.estate = ESTATE_OFF;
	self.solid = SOLID_NOT;
	self.modelindex = 0;			// Make sure no model
	self.model = "";				// hide model
	self.takedamage = DAMAGE_NO;
	self.th_die = SUB_Null;
	self.think = SUB_Null;
};

//----------------------------------------------------------------------
void() misc_bell_setup =
{
	self.classtype = CT_MISCBELL;
	self.classgroup = CG_BREAKABLE;
	if (self.health < 1) self.health = 9999;		
	self.bleedcolour = MON_BCOLOR_WHITE;


	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_bell_on;
	self.estate_off = misc_bell_off;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

//----------------------------------------------------------------------
void() misc_bell =
{

	self.mdl = "progs/tower_bell.mdl";	
	precache_model (self.mdl);

	precache_sound ("misc/bell_toll.wav");

	self.frame = 0;
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';


	misc_bell_setup();
};

//============================================================================

/*======================================================================
/*QUAKED misc_vase (0 0.5 0.8) (-16 -16 0) (16 16 16) FLAME LARGE x x x x STARTOFF
{ model(":progs/vase.mdl"); }
-------- KEYS --------
target        : trigger events when vase breaks
health        : Amount of health before breaking (def = 1)
-------- SPAWNFLAGS --------
FLAME    : Animated incense burning flame
LARGE	 : Large vase frame 
STARTOFF : Starts off and waits for trigger
-------- NOTES --------
Breakable Vase

======================================================================*/

// Break the vase
//----------------------------------------------------------------------
void() misc_vase_break =
{
	if (self.attack_finished > time) return;
	self.attack_finished = time + LARGE_TIMER;
	
	// Switch off everything
	self.estate_off();
	
	// Play breaking sound
	if (random() < 0.2) {sound (self, CHAN_EXTRA2, "break/ceramic_impact.wav", 1, ATTN_IDLE);}
	else if (random() < 0.35) {sound (self, CHAN_EXTRA2, "break/ceramic_impact2.wav", 1, ATTN_IDLE);}
	else if (random() < 0.5) {sound (self, CHAN_EXTRA2, "break/ceramic_impact3.wav", 1, ATTN_IDLE);}
	else if (random() < 0.65) {sound (self, CHAN_EXTRA2, "break/ceramic_impact4.wav", 1, ATTN_IDLE);}
	else if (random() < 0.8) {sound (self, CHAN_EXTRA2, "break/ceramic_impact5.wav", 1, ATTN_IDLE);}
	else {sound (self, CHAN_EXTRA2, "break/ceramic_impact6.wav", 1, ATTN_IDLE);}

	//DP smoke effects
	if (ext_dppart) {
		pointparticles(particleeffectnum(DPP_TEBSMOKE), self.origin, '0 0 0', 1);
	}

	// Check for any explosion triggers
	if (self.target != "") trigger_strs(self.target, other);

	if (self.spawnflags & 2) {
	ThrowGib(11, 1 + rint(random()*2));
	ThrowGib(12, 1 + rint(random()*2));
	ThrowGib(13, 1 + rint(random()*2));
	ThrowGib(14, 1 + rint(random()*2));
	SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, "");
			if (random() > 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 250);
	}
	else {
	ThrowGib(13, 1 + rint(random()*2));
	ThrowGib(14, 1 + rint(random()*2));
	}

	if (self.spawnflags & 4) DropBackpack();
	
	entity_hide(self);
};

//----------------------------------------------------------------------
void() misc_vase_use =
{
	// If box is setup off, switch on first
	if (self.spawnflags & ENT_STARTOFF) {
		self.spawnflags = self.spawnflags - ENT_STARTOFF;
		self.estate_on();
	}
	// No toggle function, just blow it up!
	else misc_vase_break();
};

//----------------------------------------------------------------------
void() misc_vase_on =
{
	// If the box has exploded, do nothing
	if (self.attack_finished > time) return;
	// Stop re-triggering ON state
	if (self.estate == ESTATE_ON) return;

	self.estate = ESTATE_ON;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.mdl);
	setsize(self, self.bbmins, self.bbmaxs);
	
	self.th_die = misc_vase_break;
	self.takedamage = DAMAGE_AIM;
	
};

//----------------------------------------------------------------------
void() misc_vase_off = 
{
	self.estate = ESTATE_OFF;
	self.solid = SOLID_NOT;
	self.modelindex = 0;			// Make sure no model
	self.model = "";				// hide model
	self.takedamage = DAMAGE_NO;
	self.th_die = SUB_Null;
	self.think = SUB_Null;
};

//----------------------------------------------------------------------
void() misc_vase_setup =
{
	precache_sound ("break/ceramic_impact.wav");
	precache_sound ("break/ceramic_impact2.wav");
	precache_sound ("break/ceramic_impact3.wav");
	precache_sound ("break/ceramic_impact4.wav");
	precache_sound ("break/ceramic_impact5.wav");
	precache_sound ("break/ceramic_impact6.wav");

	self.gib1mdl = "progs/gib1_vase.mdl";
	self.gib2mdl = "progs/gib2_vase.mdl";
	self.gib3mdl = "progs/gib3_vase.mdl";
	self.gib4mdl = "progs/gib4_vase.mdl";

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

	// Setting the angle key in the editor to UP/DOWN = random rotation	
	if (self.angles_y <= 0) self.angles_y = rint(random()*359);


	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = misc_vase_on;
	self.estate_off = misc_vase_off;
	self.estate_use = misc_vase_use;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
};

//----------------------------------------------------------------------
void() misc_vase =
{

	self.mdl = "progs/vase.mdl";	
	precache_model (self.mdl);
	
	if (self.spawnflags == 3 || self.spawnflags == 7 || self.spawnflags == 67 || self.spawnflags == 71) {
	self.frame = 3;
	self.bbmins = '-10 -10 -16';
	self.bbmaxs = '10 10 24';
	}
	else if (self.spawnflags == 2 || self.spawnflags == 6 || self.spawnflags == 66 || self.spawnflags == 70) {
	self.frame = 2;
	self.bbmins = '-10 -10 -16';
	self.bbmaxs = '10 10 24';
	}
	else if (self.spawnflags == 1 || self.spawnflags == 5 || self.spawnflags == 65 || self.spawnflags == 69) {
	self.frame = 1;
	self.bbmins = '-6 -6 -16';
	self.bbmaxs = '6 6 8';
	}
	else {
	self.frame = 0;
	self.bbmins = '-6 -6 -16';
	self.bbmaxs = '6 6 8';
	}	

	misc_vase_setup();
};


/*======================================================================
 * misc_modelrdm.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 * Adapted for Raven Keep by Redfield
====================================================================== */

// The starting frame of the animation
.float first_frame;

// The ending frame of the animation
.float last_frame;

// Forward declarations
void() misc_model_think;

/*
 * misc_modelrdm
 *
 * An entity for displaying models. A frame range can be given to animate the
 * model.
 *
 *
 * mdl: The model to display. Can be of type mdl, bsp, or spr.
 *
 * frame: The frame to display. Can be used to offset the animation.
 *
 * first_frame: The starting frame of the animation.
 *
 * last_frame: The last frame of the animation.
 */
void() misc_modelrdm = {
    precache_model(self.mdl);
    setmodel(self, self.mdl);

    if (!self.frame) {
        self.frame = self.first_frame;
    }

    // Only animate if given a frame range
    if (!self.last_frame) {
        makestatic(self);
        return;
    }

    // Default animation speed to 10 fps
    if (!self.speed) {
        self.speed = 0.1;
    }

    self.nextthink = time + self.speed;
    self.think = misc_model_think;
};

/*
 * misc_model_think
 *
 * Handles animation for misc_model entity.
 */
void() misc_model_think = {
    self.nextthink = time + fabs(self.speed);
    self.frame = self.frame + sign(self.speed);
    self.frame = wrap(self.frame, self.first_frame, self.last_frame);
};

//----------------------------------------------------------------------
// Convert to new ladder system
void() func_ladder = { self.spawnflags = TRIG_LADDERVELOCITY; trigger_ladder(); };

//-----------------------------------------------------------------------
//New monster Check Attacks
//-----------------------------------------------------------------------

/*======================================================================
 KarasuCheckAttack
======================================================================*/
void() KarasuCheckAttack =
{
	//----------------------------------------------------------------------
	// Melee attack(punch)
	//----------------------------------------------------------------------
	if (ai_checkmelee(MONAI_MELEEKARASU)) {
		// Increasing chance of lightning strike with skill
		// Easy = 25%, Normal = 35%, Hard = 45%, NM = 55%
		self.attack_chance = 0.25 + (skill * 0.1);
		
		if (random() < self.attack_chance) self.attack_state = AS_MISSILE;
		else { self.attack_state = AS_MELEE; self.th_melee (); }
		return;
	}

	//----------------------------------------------------------------------
	// Range attack (beam, lightning, rocks)
	//----------------------------------------------------------------------
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (self.enemydist > MONAI_KARASURANGE && !self.attack_sniper) return;

	// Does the monster have a clear shot to the player?
	// sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE;
};

/*======================================================================
 WolfCheckAttack
======================================================================*/
void() WolfCheckAttack =
{
	// Does the monster have a clear shot to the player?
	// sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
		
	//----------------------------------------------------------------------
	// Melee attack
	// Uses larger check distance
	// Then shorter check before attack
	//----------------------------------------------------------------------
	if (ai_checkmelee(MONAI_MELEEWOLF)) {
		self.attack_state = AS_MELEE;
		self.th_melee (); 
		return;
	}
	//----------------------------------------------------------------------
	// Range attack (energy sword)
	//----------------------------------------------------------------------
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (self.enemydist > MONAI_WOLFRANGE && !self.attack_sniper) return;

	// Does the monster have a clear shot to the player?
	// sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE;
};

/*======================================================================
 HuntressCheckAttack
======================================================================*/
void() HuntressCheckAttack =
{
	//----------------------------------------------------------------------
	// Melee attack(swords)
	//----------------------------------------------------------------------
	if (ai_checkmelee(MONAI_MELEEHUNTRESS)) {
		// Increasing chance of ranged attack with skill
		// Easy = 15%, Normal = 25%, Hard = 35%, NM = 45%
		self.attack_chance = 0.15 + (skill * 0.1);
		
		if (random() < self.attack_chance) self.attack_state = AS_MISSILE;
		else { self.attack_state = AS_MELEE; self.th_melee (); }
		return;
	}

	//----------------------------------------------------------------------
	// Mid Range attack (JUMP)
	//----------------------------------------------------------------------
	// Jumped recently, facing right direction and not blocked?
	if ( self.jump_flag < time && infront(self.enemy) && !visblocked(self.enemy) ) {
		// Check for enemy above? (z axis)
		if (self.enemy.origin_z <= self.origin_z) {
			// Is the huntress within the right range?
			if (self.enemydist > MONAI_JUMPELENANEAR &&
				self.enemydist < MONAI_JUMPELENAFAR) {
				SUB_AttackFinished (random());
				self.jumptouch = world;			// Reset last object touched
				self.count = 0;				// Number of times jumped
				if (random() < 0.7) self.th_jump ();
				else {
					self.th_missile ();
				}
				return;
			}
		}
	}

	//----------------------------------------------------------------------
	// Range attack (pistol, spears)
	//----------------------------------------------------------------------
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	// Does the monster have a clear shot to the player?
	// sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE;
};

/*======================================================================
 SpiritCheckAttack (No ranged attack)
======================================================================*/
void() SpiritCheckAttack =
{
	
	if (self.enemydist < MONAI_MELEESPIRIT) {
		self.attack_state = AS_MELEE;
		return;
	}
};