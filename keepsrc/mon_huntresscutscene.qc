/*==============================================================================
Elena the Blood Huntress Cutscene Model 
==============================================================================*/

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9
$frame idle10 idle11 idle12 

$frame drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 drink9
$frame drink10 drink11 drink12 drink13 drink14 drink15 drink16 drink17
$frame drink18 drink19 drink20 drink21 drink22 drink23 drink24 drink25
$frame drink26 drink27 drink28 drink29 drink30 drink31 drink32 drink33 
$frame drink34 drink35 drink36 drink37

void() huntressmodel_drink1;

//============================================================================
// Attachment management (create, finish and delete the Chalice)
//============================================================================
void() huntress_create_attachment =
{
	// Are the attachments setup yet?
	if (!self.attachment2) {
		self.attachment2 = spawn();
		self.attachment2.classtype = CT_ATTACHMENT;
		setmodel(self.attachment2, "progs/redfield/huntress/cutscene_chalice.mdl");
		setsize(self.attachment2,VEC_ORIGIN, VEC_ORIGIN);
		setorigin(self.attachment2, self.origin);
		self.attachment2.movetype = MOVETYPE_NOCLIP;
		self.attachment2.angles = self.angles;
	}
};

//----------------------------------------------------------------------
void() huntress_update_attachment =
{
	self.attachment2.frame = self.frame;
};

//===========================================================================
//Update the Rakuoy model frame and position with the Huntress

void() create_rakuyo = {
	if (self.attachment.model == "") {
		setmodel(self.attachment, "progs/redfield/huntress/cutscene_rakuyo.mdl");
	}
};

void() huntressmodel_rakuyo = {
	
	if (self.attachment.movetype != MOVETYPE_STEP) self.attachment.movetype = MOVETYPE_STEP;
	setorigin(self.attachment, self.origin);
	self.attachment.angles = self.angles;
	self.attachment.frame = self.frame;
};

//===========================================================================
void() huntressmodel_stand = {
	self.movetype = MOVETYPE_NONE;
};

//===========================================================================
void(float dist) huntressmodel_walk = {
		if (self.movetype != MOVETYPE_STEP) self.movetype = MOVETYPE_STEP;
		movetogoal (dist);
		
		// Find out if the model is close enough to next path corner
		// The model is not a monster, negative health and no body!
		// The path_corner touch function won't work with models
		self.enemydist = range_distance(self.goalentity, FALSE);
		if (self.enemydist < 64) {
			// Check for any new targets to walk toward
			if (self.goalentity.target != "") {
				self.movetarget = find(world, targetname, self.goalentity.target);
				if (self.movetarget) {
					if (self.movetarget.classtype == CT_PATHCORNER) {
						self.goalentity = self.movetarget;
						self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
						return;
					}
				}
			}
			// It seems its time to stand around!
			self.th_stand();
			// Check for any path corner event triggers
			if (self.goalentity.corner_event) 
				trigger_strs(self.goalentity.corner_event, self);
		}
};


//===========================================================================
void()	huntressmodel_walk1	=[	$walk1,		huntressmodel_walk2	] {create_rakuyo(); huntressmodel_walk(4); self.skin = 0; huntressmodel_rakuyo();};
void()	huntressmodel_walk2	=[	$walk2,		huntressmodel_walk3	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk3	=[	$walk3,		huntressmodel_walk4	] {monster_footstep(FALSE); huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk4	=[	$walk4,		huntressmodel_walk5	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk5	=[	$walk5,		huntressmodel_walk6	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk6	=[	$walk6,		huntressmodel_walk7	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk7	=[	$walk7,		huntressmodel_walk8	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk8	=[	$walk8,		huntressmodel_walk9	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk9	=[	$walk9,		huntressmodel_walk10	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk10	=[	$walk10,	huntressmodel_walk11	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk11	=[	$walk11,	huntressmodel_walk12	] {monster_footstep(FALSE); huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk12	=[	$walk12,	huntressmodel_walk13	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk13	=[	$walk13,	huntressmodel_walk14	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk14	=[	$walk14,	huntressmodel_walk15	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk15	=[	$walk15,	huntressmodel_walk16	] {huntressmodel_walk(4); huntressmodel_rakuyo();};
void()	huntressmodel_walk16	=[	$walk16,	huntressmodel_walk1	] {huntressmodel_walk(4); huntressmodel_rakuyo();};


//----------------------------------------------------------------------
void()	huntressmodel_pain =
{
	 return;
};

float idle_speech;

void() idle_checktime =
{
	if (idle_speech >= 3)
	huntressmodel_drink1();
};

//----------------------------------------------------------------------
void()	huntressmodel_idle1 = [ $drink37,	huntressmodel_idle2 	] {huntress_create_attachment(); huntress_update_attachment(); huntressmodel_stand(); 
self.skin = 0; huntressmodel_rakuyo(); particle_explode(self.origin + '-12 4 8', 8, 0.3+random()*0.5, PARTICLE_BURST_WHITE, PARTICLE_BURST_CENTER);
	sound(self, CHAN_VOICE, "redfield/huntress/dialogue2.wav", 1, ATTN_NORM); };
void()	huntressmodel_idle2 = [ $drink36,	huntressmodel_idle3 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_idle3 = [ $drink35,	huntressmodel_idle4 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_idle4 = [ $drink34,	huntressmodel_idle5 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_idle5 = [ $drink33,	huntressmodel_idle6 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_idle6 = [ $drink32,	huntressmodel_idle7 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_idle7 = [ $drink31,	huntressmodel_idle8 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle8 = [	$idle1,		huntressmodel_idle9	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();
idle_speech = idle_speech + 1;};
void() 	huntressmodel_idle9 = [	$idle2,		huntressmodel_idle10	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle10 = [ $idle3,	huntressmodel_idle11	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle11 = [ $idle4,	huntressmodel_idle12	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle12 = [ $idle5,	huntressmodel_idle13	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle13 = [ $idle6,	huntressmodel_idle14	] {huntress_update_attachment(); self.skin = 1; huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle14 = [ $idle7,	huntressmodel_idle15	] {huntress_update_attachment(); self.skin = 0; huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle15 = [ $idle8,	huntressmodel_idle16	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle16 = [ $idle9,	huntressmodel_idle17 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle17 = [ $idle10,	huntressmodel_idle18 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_idle18 = [ $idle11,	huntressmodel_idle8	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();
idle_checktime();};


//----------------------------------------------------------------------
void() 	huntressmodel_drink1 = [	$drink1,		huntressmodel_drink2	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink2 = [	$drink2,		huntressmodel_drink3	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink3 = [	$drink3,		huntressmodel_drink4	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink4 = [	$drink4,		huntressmodel_drink5	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink5 = [	$drink5,		huntressmodel_drink6	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink6 = [	$drink6,		huntressmodel_drink7	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink7 = [	$drink7,		huntressmodel_drink8	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink8 = [	$drink8,		huntressmodel_drink9	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink9 = [	$drink9,		huntressmodel_drink10 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink10 = [	$drink10,		huntressmodel_drink11 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();
self.skin = 1;};
void() 	huntressmodel_drink11 = [	$drink11,		huntressmodel_drink12 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink12 = [	$drink12,		huntressmodel_drink13 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink13 = [	$drink13,		huntressmodel_drink14 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink14 = [	$drink14,		huntressmodel_drink15 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink15 = [	$drink15,		huntressmodel_drink16 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink16 = [	$drink16,		huntressmodel_drink17 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink17 = [	$drink17,		huntressmodel_drink18 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink18 = [	$drink18,		huntressmodel_drink19 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink19 = [	$drink19,		huntressmodel_drink20 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();
self.skin = 0;};
void() 	huntressmodel_drink20 = [	$drink20,		huntressmodel_drink21 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink21 = [	$drink21,		huntressmodel_drink22 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink22 = [	$drink22,		huntressmodel_drink23 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink23 = [	$drink23,		huntressmodel_drink24 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink24 = [	$drink24,		huntressmodel_drink25 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink25 = [	$drink25,		huntressmodel_drink26 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink26 = [	$drink26,		huntressmodel_drink27 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void() 	huntressmodel_drink27 = [	$drink27,		huntressmodel_drink28 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink28 = [	$drink28,		huntressmodel_drink29 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();
self.skin = 1;};
void()	huntressmodel_drink29 = [	$drink29,		huntressmodel_drink30 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();
self.skin = 0;};
void()	huntressmodel_drink30 = [	$drink30,		huntressmodel_drink31 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink31 = [	$drink31,		huntressmodel_drink32 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink32 = [	$drink32,		huntressmodel_drink33 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink33 = [	$drink33,		huntressmodel_drink34 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink34 = [	$drink34,		huntressmodel_drink35 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink35 = [	$drink35,		huntressmodel_drink36 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink36 = [	$drink36,		huntressmodel_drink37 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};
void()	huntressmodel_drink37 = [	$drink37,		huntressmodel_drink37 	] {huntress_update_attachment(); huntressmodel_stand(); huntressmodel_rakuyo();};

//----------------------------------------------------------------------
// The use function is for triggering the model to move
void() huntressmodel_use = { 
	// Check for a delay target route (using target2)
	if (self.estate == ESTATE_ON && self.target2 != "") {
		self.target = self.target2;
		self.target2 = "";
		self.estate = ESTATE_OFF;
	}
	// Always go to an on state
	self.estate_on();
};

//----------------------------------------------------------------------
void() huntressmodel_off = {
	// Block if already off
	if (self.estate == ESTATE_OFF) return;	
	
	self.estate = ESTATE_OFF;
	self.flags = 0;		// Always reset
	self.takedamage = DAMAGE_NO;		// No pain/death triggers
	self.movetype = MOVETYPE_NONE;		// Stationary
	self.solid = SOLID_NOT;				// no world interaction
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);		// No size, no impact
	self.velocity = self.avelocity = '0 0 0';	// Reset velocity
	setmodel (self, "");				// invisible
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
}

//----------------------------------------------------------------------
void() huntressmodel_on = {
	// Block if already ON
	if (self.estate == ESTATE_ON) return;	
	
	self.estate = ESTATE_ON;
	self.flags = 0;		// Always reset
	self.takedamage = DAMAGE_NO;		// No pain/death triggers
	self.movetype = MOVETYPE_NONE;		// Regular walking
	self.solid = SOLID_NOT;				// no world interaction
	setmodel(self, self.mdl);					// Setup model
	if (CheckZeroVector(self.bbmins)) monster_bbox();
	setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	self.velocity = self.avelocity = '0 0 0';	// Reset velocity
	

	// Check for any targets to walk toward
	if (self.target != "") {
		self.movetarget = find(world, targetname, self.target);
		if (self.movetarget) {
			if (self.movetarget.classtype == CT_PATHCORNER) {
				self.goalentity = self.movetarget;
				self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
				self.th_walk();
				return;
			}
		}
	}
	// No valid target, just stand around
	self.movetarget = self.goalentity = world;
	self.th_stand();
}

/*======================================================================
QUAKED monster_huntressmodel (1 0 0) (-16 -16 -24) (16 16 40) Ambush
======================================================================*/
void() monster_huntressmodel = {
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/redfield/huntress/cutscene_huntress.mdl";			// Animated Huntress cutscene model

	precache_model (self.mdl);
	
	precache_sound ("redfield/huntress/dialogue2.wav");

	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;	

	precache_model ("progs/redfield/huntress/cutscene_rakuyo.mdl");
	precache_model ("progs/redfield/huntress/cutscene_chalice.mdl");
		
	self.nomonstercount = TRUE;
	self.gibhealth = MON_NEVERGIB;
	self.health = LARGE_TIMER;
	self.yaw_speed = 20;

	// Custom feet sounds
	self.stepc1 = "redfield/huntress/step1.wav";
	self.stepc2 = "redfield/huntress/step2.wav";
	self.stepc3 = "redfield/huntress/step3.wav";
	self.stepc4 = "redfield/huntress/step4.wav";
	self.stepc5 = "redfield/huntress/step5.wav";
	precache_sound (self.stepc1);
	precache_sound (self.stepc2);
	precache_sound (self.stepc3);
	precache_sound (self.stepc4);
	precache_sound (self.stepc5);
	self.steptype = FS_TYPECUSTOM;
		
	self.th_stand = huntressmodel_idle1;
	self.th_walk = huntressmodel_walk1;
	self.th_run = huntressmodel_walk1;

	// Setup rakuyo model
	self.attachment = spawn();
	self.attachment.classtype = CT_ATTACHMENT;
	setmodel(self.attachment, "");
	setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
	self.attachment.movetype = MOVETYPE_NOCLIP;
		
	// The model is a scenery prop, not a monster
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = huntressmodel_on;
	self.estate_off = huntressmodel_off;
	self.estate_use = huntressmodel_use;

	// Always start off and wait for a trigger
	self.estate = ESTATE_OFF;
	self.takedamage = DAMAGE_NO;			// No pain/death triggers
	self.movetype = MOVETYPE_NONE;			// Stationary
	self.solid = SOLID_NOT;				// no world interaction
	setmodel (self, "");				// invisible
};