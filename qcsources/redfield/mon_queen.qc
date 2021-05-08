/*==============================================================================
Red Queen (Prop monster by Redfield)
==============================================================================*/

$frame bow1 bow2 bow3 bow4 bow5 bow6 bow7 bow8 bow9 bow10
$frame bow11 bow12 bow13 bow14 bow15 bow16 bow17 bow18 bow19 bow20
$frame bow21 bow22 bow23 bow24 bow25 bow26 bow27 bow28 bow29 bow30 bow31

$frame spell1 spell2 spell3 spell4 spell5 spell6 spell7 spell8 spell9
$frame spell10 spell11 spell12 spell13 spell14 spell15 spell16 spell17
$frame spell18 spell19 spell20 spell21 spell22 spell23 spell24 spell25
$frame spell26 spell27 spell28 

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9
$frame idle10 idle11

$frame idleb1 idleb2 idleb3 idleb4 idleb5 idleb6 idleb7 idleb8 idleb9
$frame idleb10 idleb11 idleb12 idleb13 idleb14 idleb15 idleb16 idleb17 idleb18
$frame idleb19 idleb20 idleb21 idleb22 idleb23 idleb24 idleb25 idleb26 idleb27
$frame idleb28 idleb29 idleb30

//===========================================================================
void() queen_stand = {
	self.movetype = MOVETYPE_NONE;
};

//===========================================================================
void(float dist) ghost_walk = {
		if (self.movetype != MOVETYPE_STEP) self.movetype = MOVETYPE_STEP;
		movetogoal (dist);
		
		// Find out if the ghost is close enough to next path corner
		// The ghost is not a monster, negative health and no body!
		// The path_corner touch function won't work with ghosts
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

//Unfinished and unused walking animation
//----------------------------------------------------------------------
void()	queen_walk1	=[	$spell1,		queen_walk1	] {ghost_walk(5);};


//----------------------------------------------------------------------
void()	ghost_pain =
{
	 return;
};


//============================================================================
// The Ghost Queen system (this is not a monster)
//============================================================================
void() queen_ghostnull = {};


//============================================================================
// Attachment management (create, finish and delete)
//============================================================================
void() redqueen_create_attachment =
{
	// Are the attachments setup yet?
	if (!self.attachment) {
		self.attachment = spawn();
		//self.attachment.owner = self;
		self.attachment.classtype = CT_ATTACHMENT;
		self.attachment.state = FALSE;
	}
};

//----------------------------------------------------------------------
void() redqueen_reset_attachment =
{
	if (self.attachment) {
		if (self.attachment.state) {
			// Move attachment into place ready for use
			self.attachment.movetype = MOVETYPE_NONE;
			self.attachment.solid = SOLID_NOT;
			self.attachment.frame = 0;
			self.attachment.skin = 0;
			setmodel(self.attachment, "");
			setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
			setorigin(self.attachment, self.origin);
			// Using empty model, so reset angle, frame and skin.
			self.attachment.angles = self.angles;
			self.attachment.state = FALSE;
		}
	}
};

//----------------------------------------------------------------------
void() redqueen_setup_attachment =
{
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		setmodel(self.attachment, "progs/proj_rqspell.mdl");
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.state = TRUE;
	}
};

//----------------------------------------------------------------------
void() redqueen_remove_attachment =
{
	if (self.attachment) {
		self.attachment.state = FALSE;
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

void(float rqframe, float rqskin, float rqalpha) redqueen_drawq =
{
	local vector org, dir;
	
	// Check if attachment has been setup yet
	if (!self.attachment) redqueen_create_attachment();

	// Frame 0 is start of the sequence (move everything into place)
	if (rqframe == 0) redqueen_setup_attachment();
	
	// Place Q in center of Red Queen model
	setorigin(self.attachment, self.origin);
	self.attachment.angles = self.angles;
	self.attachment.frame = rqframe;	
	self.attachment.skin = rqskin;
	self.attachment.alpha = rqalpha;
};

float idleswitch;

//----------------------------------------------------------------------
void() redqueen_idleb1 = [	$idleb1,	redqueen_idleb2	 ] {self.skin = 0; idleswitch = 0;}
void() redqueen_idleb2 = [	$idleb2,	redqueen_idleb3	 ] {}
void() redqueen_idleb3 = [	$idleb3,	redqueen_idleb4	 ] {}
void() redqueen_idleb4 = [	$idleb4,	redqueen_idleb5	 ] {}
void() redqueen_idleb5 = [	$idleb5,	redqueen_idleb6	 ] {}
void() redqueen_idleb6 = [	$idleb6,	redqueen_idleb7	 ] {}
void() redqueen_idleb7 = [	$idleb7,	redqueen_idleb8	 ] {}
void() redqueen_idleb8 = [	$idleb8,	redqueen_idleb9	 ] {}
void() redqueen_idleb9 = [	$idleb9,	redqueen_idleb10 ] {}
void() redqueen_idleb10 = [	$idleb10,	redqueen_idleb11 ] {}
void() redqueen_idleb11 = [	$idleb11,	redqueen_idleb12 ] {}
void() redqueen_idleb12 = [	$idleb12,	redqueen_idleb13 ] {}
void() redqueen_idleb13 = [	$idleb13,	redqueen_idleb14 ] {}
void() redqueen_idleb14 = [	$idleb14,	redqueen_idleb15 ] {}
void() redqueen_idleb15 = [	$idleb15,	redqueen_idleb16 ] {self.skin = 1;}
void() redqueen_idleb16 = [	$idleb16,	redqueen_idleb17 ] {}
void() redqueen_idleb17 = [	$idleb17,	redqueen_idleb18 ] {self.skin = 0;}
void() redqueen_idleb18 = [	$idleb18,	redqueen_idleb19 ] {}
void() redqueen_idleb19 = [	$idleb19,	redqueen_idleb20 ] {}
void() redqueen_idleb20 = [	$idleb20,	redqueen_idleb21 ] {}
void() redqueen_idleb21 = [	$idleb21,	redqueen_idleb22 ] {}
void() redqueen_idleb22 = [	$idleb22,	redqueen_idleb23 ] {}
void() redqueen_idleb23 = [	$idleb23,	redqueen_idleb24 ] {}
void() redqueen_idleb24 = [	$idleb24,	redqueen_idleb25 ] {}
void() redqueen_idleb25 = [	$idleb25,	redqueen_idleb26 ] {}
void() redqueen_idleb26 = [	$idleb26,	redqueen_idleb27 ] {}
void() redqueen_idleb27 = [	$idleb27,	redqueen_idleb28 ] {}
void() redqueen_idleb28 = [	$idleb28,	redqueen_idleb29 ] {}
void() redqueen_idleb29 = [	$idleb29,	redqueen_idleb30 ] {}
void() redqueen_idleb30 = [	$idleb30,	redqueen_idle1 ] {self.skin = 1;}

//----------------------------------------------------------------------
void() 	redqueen_idle1 = [	$idle1,		redqueen_idle2	] {self.skin = 0; redqueen_reset_attachment();
idleswitch = idleswitch + 1;};
void() 	redqueen_idle2 = [	$idle2,		redqueen_idle3	] {};
void() 	redqueen_idle3 = [	$idle3,		redqueen_idle4	] {};
void() 	redqueen_idle4 = [	$idle4,		redqueen_idle5	] {};
void() 	redqueen_idle5 = [	$idle5,		redqueen_idle6	] {};
void() 	redqueen_idle6 = [	$idle6,		redqueen_idle7	] {if (random() < 0.5) self.skin = 1;};
void() 	redqueen_idle7 = [	$idle7,		redqueen_idle8	] {self.skin = 0;};
void() 	redqueen_idle8 = [	$idle8,		redqueen_idle9	] {};
void() 	redqueen_idle9 = [	$idle9,		redqueen_idle10 ] {};
void() 	redqueen_idle10 = [	$idle10,	redqueen_idle11 ] {};
void() 	redqueen_idle11 = [	$idle11,	redqueen_idle1 ] {
if (idleswitch > 5) {
	if (random() < 0.3) redqueen_idleb1();
	}
};


//----------------------------------------------------------------------
void() 	redqueen_bow1 = [	$bow1,		redqueen_bow2	] {self.alpha = 0.5;
	sound (self, CHAN_VOICE, "misc/queen_hum.wav", 1, ATTN_NORM);};
void() 	redqueen_bow2 = [	$bow2,		redqueen_bow3	] {self.alpha = 0.75;};
void() 	redqueen_bow3 = [	$bow3,		redqueen_bow4	] {self.alpha = 1;};
void() 	redqueen_bow4 = [	$bow4,		redqueen_bow5	] {};
void() 	redqueen_bow5 = [	$bow5,		redqueen_bow6	] {};
void() 	redqueen_bow6 = [	$bow6,		redqueen_bow7	] {};
void() 	redqueen_bow7 = [	$bow7,		redqueen_bow8	] {};
void() 	redqueen_bow8 = [	$bow8,		redqueen_bow9	] {};
void() 	redqueen_bow9 = [	$bow9,		redqueen_bow10 ] {self.skin = 1;};
void() 	redqueen_bow10 = [	$bow10,		redqueen_bow11 ] {};
void() 	redqueen_bow11 = [	$bow11,		redqueen_bow12 ] {};
void() 	redqueen_bow12 = [	$bow12,		redqueen_bow13 ] {self.skin = 0;};
void() 	redqueen_bow13 = [	$bow13,		redqueen_bow14 ] {};
void() 	redqueen_bow14 = [	$bow14,		redqueen_bow15 ] {};
void() 	redqueen_bow15 = [	$bow15,		redqueen_bow16 ] {};
void() 	redqueen_bow16 = [	$bow16,		redqueen_bow17 ] {};
void() 	redqueen_bow17 = [	$bow17,		redqueen_bow18 ] {self.skin = 1;};
void() 	redqueen_bow18 = [	$bow18,		redqueen_bow19 ] {self.skin = 0;};
void() 	redqueen_bow19 = [	$bow19,		redqueen_bow20 ] {};
void() 	redqueen_bow20 = [	$bow20,		redqueen_bow21 ] {};
void() 	redqueen_bow21 = [	$bow21,		redqueen_bow22 ] {};
void() 	redqueen_bow22 = [	$bow22,		redqueen_bow23 ] {};
void() 	redqueen_bow23 = [	$bow23,		redqueen_bow24 ] {};
void() 	redqueen_bow24 = [	$bow24,		redqueen_bow25 ] {};
void() 	redqueen_bow25 = [	$bow25,		redqueen_bow26 ] {};
void() 	redqueen_bow26 = [	$bow26,		redqueen_bow27 ] {};
void() 	redqueen_bow27 = [	$bow27,		redqueen_bow28 ] {};
void()	redqueen_bow28 = [	$bow28,		redqueen_bow29 ] {};
void()	redqueen_bow29 = [	$bow29,		redqueen_bow30 ] {self.skin = 1;};
void()	redqueen_bow30 = [	$bow30,		redqueen_bow31 ] {self.skin = 0;};
void()	redqueen_bow31 = [	$bow31,		redqueen_spell1 ] {};

//----------------------------------------------------------------------
void() 	redqueen_spell1 = [	$spell1,	redqueen_spell2	] {};
void() 	redqueen_spell2 = [	$spell2,	redqueen_spell3	] {};
void() 	redqueen_spell3 = [	$spell3,	redqueen_spell4	] {self.skin = 1;};
void() 	redqueen_spell4 = [	$spell4,	redqueen_spell5	] {self.skin = 0;};
void() 	redqueen_spell5 = [	$spell5,	redqueen_spell6	] {};
void() 	redqueen_spell6 = [	$spell6,	redqueen_spell7	] {};
void() 	redqueen_spell7 = [	$spell7,	redqueen_spell8	] {};
void() 	redqueen_spell8 = [	$spell8,	redqueen_spell9	] {redqueen_drawq(0,1,1);};
void() 	redqueen_spell9 = [	$spell9,	redqueen_spell10 ] {redqueen_drawq(1,1,1);};
void() 	redqueen_spell10 = [	$spell10,	redqueen_spell11 ] {redqueen_drawq(2,2,1);};
void() 	redqueen_spell11 = [	$spell11,	redqueen_spell12 ] {redqueen_drawq(3,3,1);};
void() 	redqueen_spell12 = [	$spell12,	redqueen_spell13 ] {redqueen_drawq(4,4,1);self.skin = 1;};
void() 	redqueen_spell13 = [	$spell13,	redqueen_spell14 ] {redqueen_drawq(5,5,1);self.skin = 0;};
void() 	redqueen_spell14 = [	$spell14,	redqueen_spell15 ] {redqueen_drawq(6,6,1);};
void() 	redqueen_spell15 = [	$spell15,	redqueen_spell16 ] {redqueen_drawq(7,7,1);};
void() 	redqueen_spell16 = [	$spell16,	redqueen_spell17 ] {redqueen_drawq(8,7,1);};
void() 	redqueen_spell17 = [	$spell17,	redqueen_spell18 ] {redqueen_drawq(9,7,1);};
void() 	redqueen_spell18 = [	$spell18,	redqueen_spell19 ] {redqueen_drawq(10,8,1);self.skin = 1;};
void() 	redqueen_spell19 = [	$spell19,	redqueen_spell20 ] {redqueen_drawq(11,8,1);self.skin = 0;};
void() 	redqueen_spell20 = [	$spell20,	redqueen_spell21 ] {redqueen_drawq(12,9,1);};
void() 	redqueen_spell21 = [	$spell21,	redqueen_spell22 ] {redqueen_drawq(13,9,1);};
void() 	redqueen_spell22 = [	$spell22,	redqueen_spell23 ] {redqueen_drawq(14,0,1);};
void() 	redqueen_spell23 = [	$spell23,	redqueen_spell24 ] {redqueen_drawq(15,0,1);
	sound (self, CHAN_WEAPON, "karasu/spell.wav", 0.5, ATTN_IDLE);};
void() 	redqueen_spell24 = [	$spell24,	redqueen_spell25 ] {redqueen_drawq(16,0,1);};
void() 	redqueen_spell25 = [	$spell25,	redqueen_spell26 ] {redqueen_drawq(17,0,1);};
void() 	redqueen_spell26 = [	$spell26,	redqueen_spell27 ] {redqueen_drawq(18,0,1);};
void() 	redqueen_spell27 = [	$spell27,	redqueen_spell28 ] {redqueen_drawq(19,0,0.5);};
void()	redqueen_spell28 = [	$spell28,	redqueen_spell29 ] {redqueen_drawq(20,0,0.25);self.skin = 1;};
void()	redqueen_spell29 = [	$spell28,	redqueen_idle1 	 ] {redqueen_reset_attachment();self.skin = 0;};

//----------------------------------------------------------------------
// The use function is for triggering the ghost to move
void() queen_ghost_use = { 
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

float ghost_timer; 

void() queen_ghost_fade =
{
	if (self.estate == ESTATE_ON) return;	
    ghost_timer = ghost_timer - FADEMODEL_TIME;

	if (ghost_timer <= 0.8) self.effects = self.effects | EF_MUZZLEFLASH;

	if (ghost_timer <= 0.7) setmodel (self, "");
	else self.nextthink = time + FADEMODEL_TIME;
};
//----------------------------------------------------------------------
void() queen_ghost_off = {
	// Block if already off
	if (self.estate == ESTATE_OFF) return;	
	
	self.estate = ESTATE_OFF;
	particle_explode(self.origin+'0 0 -20', 75, 2, PARTICLE_BURST_RED, PARTICLE_BURST_UPWARD);
	particle_explode(self.origin+'0 0 16', 75, 2, PARTICLE_BURST_RED, PARTICLE_BURST_UPWARD);
	self.flags = 0;		// Always reset
	self.takedamage = DAMAGE_NO;		// No pain/death triggers
	self.movetype = MOVETYPE_NONE;		// Stationary
	self.solid = SOLID_NOT;				// no world interaction
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);		// No size, no impact
	self.velocity = self.avelocity = '0 0 0';	// Reset velocity
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment.solid = SOLID_NOT;			// no world interaction
		setmodel(self.attachment,"");
		self.attachment.velocity = '0 0 0';
	}
	sound (self, CHAN_VOICE, SOUND_EMPTY, 1, ATTN_NORM);
	self.think = queen_ghost_fade;
	self.nextthink = time + FADEMODEL_TIME;
}

//----------------------------------------------------------------------
void() queen_ghost_on = {
	// Block if already ON
	if (self.estate == ESTATE_ON) return;	
	
	self.estate = ESTATE_ON;
	ghost_timer = 1;
	particle_explode(self.origin, 30, 2, PARTICLE_BURST_RED, PARTICLE_BURST_SKULLUP);
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
QUAKED monster_queen (1 0 0) (-16 -16 -24) (16 16 40) Ambush
======================================================================*/
void() monster_queen =
{
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/red_queen.mdl";			// Ghost Queen

	precache_model (self.mdl);
	
	precache_sound ("misc/queen_hum.wav");
	precache_sound ("karasu/spell.wav");

	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;	

	precache_model ("progs/proj_rqspell.mdl");
		
	self.steptype = FS_FLYING;
	self.nomonstercount = TRUE;
	self.gibhealth = MON_NEVERGIB;
	self.health = LARGE_TIMER;
	self.yaw_speed = 20;
		
	self.th_stand = redqueen_bow1;
	self.th_walk = queen_walk1;
	self.th_run = queen_walk1;
		
	// The ghost is a scenery prop, not a monster
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = queen_ghost_on;
	self.estate_off = queen_ghost_off;
	self.estate_use = queen_ghost_use;

	// Always start off and wait for a trigger
	self.estate = ESTATE_OFF;
	self.takedamage = DAMAGE_NO;			// No pain/death triggers
	self.movetype = MOVETYPE_NONE;			// Stationary
	self.solid = SOLID_NOT;				// no world interaction
	setmodel (self, "");				// invisible

};
