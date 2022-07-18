// Elena the Blood Huntress (New Ravenkeep monster by Redfield)

// 000-027 (Taunt and seperate Rakuyo)
$frame taunt1 taunt2 taunt3 taunt4 taunt5 taunt6 taunt7 taunt8 taunt9
$frame taunt10 taunt11 taunt12 taunt13 taunt14 taunt15 taunt16 taunt17
$frame taunt18 taunt19 taunt20 taunt21 taunt22 taunt23 taunt24 taunt25 
$frame taunt26 taunt27 taunt28

// 028-035 (Slash A)
$frame slasha1 slasha2 slasha3 slasha4 slasha5 slasha6 slasha7 slasha8 

// 036-045 (Slash B Follow-up)
$frame slashb1 slashb2 slashb3 slashb4 slashb5 slashb6 slashb7 slashb8 slashb9 slashb10 

// 046-055 (Double stab)
$frame stab1 stab2 stab3 stab4 stab5 stab6 stab7 stab8 stab9 stab10 

// 056-069 (Shoot Evelyn pistol)
$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9
$frame shoot10 shoot11 shoot12 shoot13 shoot14

// 070-090 (Spin jump)
$frame spin1 spin2 spin3 spin4 spin5 spin6 spin7 spin8 spin9
$frame spin10 spin11 spin12 spin13 spin14 spin15 spin16 spin17
$frame spin18 spin19 spin20 spin21

// 091-114 (Seppuku - stabbing transition)
$frame transa1 transa2 transa3 transa4 transa5 transa6 transa7 transa8 transa9
$frame transa10 transa11 transa12 transa13 transa14 transa15 transa16 transa17
$frame transa18 transa19 transa20 transa21 transa22 transa23 transa24

// 115-143 (Launch blood spears with Rakuyo joined for anticipation frames)
$frame spear1 spear2 spear3 spear4 spear5 spear6 spear7 spear8 spear9
$frame spear10 spear11 spear12 spear13 spear14 spear15 spear16 spear17
$frame spear18 spear19 spear20 spear21 spear22 spear23 spear24 spear25 
$frame spear26 spear27 spear28 spear29

// 144-154 (Cross blades and attack)
$frame cross1 cross2 cross3 cross4 cross5 cross6 cross7 cross8 cross9
$frame cross10 cross11

// 155-170 (Walk + run)
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16

// 171-179 (Pain)
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9

// 180-197 (Death - fade to ghost before hitting ground as seen in 'Bloodborne')

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17 death18

// 198-225 (Fireblast - phase 3)
$frame blast1 blast2 blast3 blast4 blast5 blast6 blast7 blast8 blast9
$frame blast10 blast11 blast12 blast13 blast14 blast15 blast16 blast17
$frame blast18 blast19 blast20 blast21 blast22 blast23 blast24 blast25 
$frame blast26 blast27 blast28

// 226-237 (Idle breathing)
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9
$frame idle10 idle11 idle12

// 238-253 (Idle gun check)
$frame idleb1 idleb2 idleb3 idleb4 idleb5 idleb6 idleb7 idleb8 idleb9
$frame idleb10 idleb11 idleb12 idleb13 idleb14 idleb15 idleb16

void() check_FireTrig;
void() elena_Phase3Run;
void() elena_choosemelee;
void() elena_choose_atk;

// Attachment management (create, finish and delete)
void() elena_create_attachment2 = {
	// Are the attachments setup yet?
	if (!self.attachment2) {
		self.attachment2 = spawn();
		//self.attachment2.owner = self;
		self.attachment2.classtype = CT_ATTACHMENT;
		self.attachment2.state = FALSE;
	}
};

void() elena_setup_attachment2 = {
	if (self.attachment2) {
		self.attachment2.movetype = MOVETYPE_NOCLIP;
		self.attachment2.solid = SOLID_NOT;
		setmodel(self.attachment2, MODEL_EVELYN);
		setsize (self.attachment2, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment2.state = TRUE;
	}
};

// Quick Customizable particle function for Rakuyo effects 
void(vector offset, float amount, float life, float clr, float style) elena_particles = {
	local vector org;
	
	if (self.health < 1) return;

	makevectors(self.angles);
	self.pos1 = self.origin + attack_vector(offset);

	// Spawn some particles
	particle_explode(self.pos1, amount+random()*4, life+random()*0.5, clr, style);
};

void() rakuyo_run = {	
	if (self.attachment.model == "") {
		setmodel(self.attachment, "progs/redfield/huntress/rakuyo.mdl");
	}
	if (self.attachment.movetype != MOVETYPE_STEP) self.attachment.movetype = MOVETYPE_STEP;
	setorigin(self.attachment, self.origin);
	self.attachment.angles = self.angles;
	self.attachment.frame = self.frame;
	self.attachment.velocity = self.velocity;
};

void()	elena_taunt1	= [	$taunt1,	elena_taunt2	] { SUB_FinishAttachment2(); ai_stand(); rakuyo_run(); };
void()	elena_taunt2	= [	$taunt2,	elena_taunt3	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt3	= [	$taunt3,	elena_taunt4	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt4	= [	$taunt4,	elena_taunt5	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt5	= [	$taunt5,	elena_taunt6	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt6	= [	$taunt6,	elena_taunt7	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt7	= [	$taunt7,	elena_taunt8	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt8	= [	$taunt8,	elena_taunt9	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt9	= [	$taunt9,	elena_taunt10	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt10	= [	$taunt10,	elena_taunt11	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt11	= [	$taunt11,	elena_taunt12	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt12	= [	$taunt12,	elena_taunt13	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt13	= [	$taunt13,	elena_taunt14	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt14	= [	$taunt14,	elena_taunt15	] { ai_stand(); rakuyo_run(); self.skin = 1; };
void()	elena_taunt15	= [	$taunt15,	elena_taunt16	] { ai_stand(); rakuyo_run(); self.skin = 0; sound(self,CHAN_WEAPON,"redfield/huntress/ching.wav",1,ATTN_NORM); };
void()	elena_taunt16	= [	$taunt16,	elena_taunt17	] { ai_stand(); elena_particles('20 0 24',6,0.5,64,512);  rakuyo_run(); };
void()	elena_taunt17	= [	$taunt17,	elena_taunt18	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt18	= [	$taunt18,	elena_taunt19	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt19	= [	$taunt19,	elena_taunt20	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt20	= [	$taunt20,	elena_taunt21	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt21	= [	$taunt21,	elena_taunt22	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt22	= [	$taunt22,	elena_taunt23	] { ai_stand(); rakuyo_run(); self.skin = 1; };
void()	elena_taunt23	= [	$taunt23,	elena_taunt24	] { ai_stand(); rakuyo_run(); self.skin = 0; };
void()	elena_taunt24	= [	$taunt24,	elena_taunt25	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt25	= [	$taunt25,	elena_taunt26	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt26	= [	$taunt26,	elena_taunt27	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt27	= [	$taunt27,	elena_taunt28	] { ai_stand(); rakuyo_run(); };
void()	elena_taunt28	= [	$taunt28,	elena_run1	] { ai_stand(); rakuyo_run();
};

void(float gprime) elena_usegun = {
	if (self.health < 1) return;

	// Check if attachment has been setup yet
	if (!self.attachment2) elena_create_attachment2();

	// Gprime starts off the sequence
	if (gprime == 0) elena_setup_attachment2();
	
	// Place pistol in correct position
	setorigin(self.attachment2, self.origin);
	self.attachment2.angles = self.angles;
	self.attachment2.frame = self.frame;	
};

float hunt_idletime;

void()	elena_idleb1	= [	$idleb1,	elena_idleb2	] { ai_stand(); self.skin = 0; rakuyo_run();
hunt_idletime = 0;
};
void()	elena_idleb2	= [	$idleb2,	elena_idleb3	] { ai_stand(); elena_usegun(0); rakuyo_run();
sound(self,CHAN_WEAPON,"redfield/huntress/pistol_cock.wav",1,ATTN_NORM);
};
void()	elena_idleb3	= [	$idleb3,	elena_idleb4	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb4	= [	$idleb4,	elena_idleb5	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb5	= [	$idleb5,	elena_idleb6	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb6	= [	$idleb6,	elena_idleb7	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb7	= [	$idleb7,	elena_idleb8	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb8	= [	$idleb8,	elena_idleb9	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb9	= [	$idleb9,	elena_idleb10	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb10	= [	$idleb10,	elena_idleb11	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb11	= [	$idleb11,	elena_idleb12	] { ai_stand(); elena_usegun(1); rakuyo_run(); self.skin = 1; };
void()	elena_idleb12	= [	$idleb12,	elena_idleb13	] { ai_stand(); elena_usegun(1); rakuyo_run(); self.skin = 0; };
void()	elena_idleb13	= [	$idleb13,	elena_idleb14	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb14	= [	$idleb14,	elena_idleb15	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb15	= [	$idleb15,	elena_idleb16	] { ai_stand(); elena_usegun(1); rakuyo_run(); };
void()	elena_idleb16	= [	$idleb16,	elena_idle1	] { ai_stand(); SUB_FinishAttachment2(); rakuyo_run(); };

void()	elena_idle1	= [	$idle1,		elena_idle2	] { SUB_FinishAttachment2(); ai_stand(); self.skin = 0; 
monster_idle_sound();
rakuyo_run();
hunt_idletime = hunt_idletime + 1;
};
void()	elena_idle2	= [	$idle2,		elena_idle3	] { ai_stand(); rakuyo_run(); };
void()	elena_idle3	= [	$idle3,		elena_idle4	] { ai_stand(); rakuyo_run(); };
void()	elena_idle4	= [	$idle4,		elena_idle5	] { ai_stand(); rakuyo_run(); };
void()	elena_idle5	= [	$idle5,		elena_idle6	] { ai_stand(); rakuyo_run(); };
void()	elena_idle6	= [	$idle6,		elena_idle7	] { ai_stand(); rakuyo_run(); self.skin = 1; };
void()	elena_idle7	= [	$idle7,		elena_idle8	] { ai_stand(); rakuyo_run(); self.skin = 0; };
void()	elena_idle8	= [	$idle8,		elena_idle9	] { ai_stand(); rakuyo_run(); };
void()	elena_idle9	= [	$idle9,		elena_idle10	] { ai_stand(); rakuyo_run(); };
void()	elena_idle10	= [	$idle10,	elena_idle11	] { ai_stand(); rakuyo_run(); };
void()	elena_idle11	= [	$idle11,	elena_idle12	] { ai_stand(); rakuyo_run(); };
void()	elena_idle12	= [	$idle12,	elena_idle1	] { rakuyo_run();
		if (hunt_idletime > 5) {
			if (random() < 0.3) {
				self.think = elena_idleb1;		// Check gun
			}
	}
ai_stand();
};

void()	elena_walk1	= [	$walk1,		elena_walk2	] { SUB_FinishAttachment2(); ai_walk(2); self.skin = 0;
rakuyo_run(); };
void()	elena_walk2	= [	$walk2,		elena_walk3	] { ai_walk(3); rakuyo_run(); };
void()	elena_walk3	= [	$walk3,		elena_walk4	] { monster_footstep(FALSE); ai_walk(5); rakuyo_run(); };
void()	elena_walk4	= [	$walk4,		elena_walk5	] { ai_walk(4); rakuyo_run(); };
void()	elena_walk5	= [	$walk5,		elena_walk6	] { ai_walk(4); rakuyo_run(); };
void()	elena_walk6	= [	$walk6,		elena_walk7	] { ai_walk(2); rakuyo_run(); };
void()	elena_walk7	= [	$walk7,		elena_walk8	] { ai_walk(2); rakuyo_run(); };
void()	elena_walk8	= [	$walk8,		elena_walk9	] { ai_walk(3); rakuyo_run(); };
void()	elena_walk9	= [	$walk9,		elena_walk10	] { ai_walk(3); rakuyo_run(); };
void()	elena_walk10	= [	$walk10,	elena_walk11	] { ai_walk(4); rakuyo_run(); };
void()	elena_walk11	= [	$walk11,	elena_walk12	] { monster_footstep(FALSE); ai_walk(3); rakuyo_run(); };
void()	elena_walk12	= [	$walk12,	elena_walk13	] { ai_walk(4); rakuyo_run(); };
void()	elena_walk13	= [	$walk13,	elena_walk14	] { ai_walk(3); rakuyo_run(); };
void()	elena_walk14	= [	$walk14,	elena_walk15	] { ai_walk(4); rakuyo_run(); };
void()	elena_walk15	= [	$walk15,	elena_walk16	] { ai_walk(6); rakuyo_run(); };
void()	elena_walk16	= [	$walk16,	elena_walk1	] { ai_walk(2); rakuyo_run(); };

float phase_Counter;
void() stab_partring = {
	particle_ring(self.origin + '0 0 -16', '0 0 4', '4 4 16', 60, 64, 1.2, 4);
} 


// Phase transition - Stab self with Rakuyo and scream

void()	elena_transa1	= [	$transa1,	elena_transa2	] { rakuyo_run();
self.skin = 0;
self.pain_finished = time + 2.4;
phase_Counter = phase_Counter + 1;
local entity b;
self.owner = spawn();
b = self.owner;
setmodel(b, MODEL_PROJ_KSPELL);
setorigin(b, self.origin);
b.nextthink = time + 2.3;
b.think = SUB_Remove;
};
void()	elena_transa2	= [	$transa2,	elena_transa3	] { rakuyo_run(); };
void()	elena_transa3	= [	$transa3,	elena_transa4	] { rakuyo_run(); };
void()	elena_transa4	= [	$transa4,	elena_transa5	] { rakuyo_run(); };
void()	elena_transa5	= [	$transa5,	elena_transa6	] { rakuyo_run(); };
void()	elena_transa6	= [	$transa6,	elena_transa7	] { rakuyo_run(); };
void()	elena_transa7	= [	$transa7,	elena_transa8	] { rakuyo_run(); self.attachment.skin = 1;
sound(self,CHAN_VOICE, "redfield/huntress/stabbed.wav",1,ATTN_NORM);
spawn_touchblood(self, other, 24); 
};
void()	elena_transa8	= [	$transa8,	elena_transa9	] { rakuyo_run(); self.skin = 1; };
void()	elena_transa9	= [	$transa9,	elena_transa10	] { ai_back(4); rakuyo_run(); };
void()	elena_transa10	= [	$transa10,	elena_transa11	] { rakuyo_run(); };
void()	elena_transa11	= [	$transa11,	elena_transa12	] { rakuyo_run(); };
void()	elena_transa12	= [	$transa12,	elena_transa13	] { rakuyo_run(); };
void()	elena_transa13	= [	$transa13,	elena_transa14	] { rakuyo_run(); };
void()	elena_transa14	= [	$transa14,	elena_transa15	] { rakuyo_run(); };
void()	elena_transa15	= [	$transa15,	elena_transa16	] { rakuyo_run(); self.skin = 0; };
void()	elena_transa16	= [	$transa16,	elena_transa17	] { rakuyo_run(); };
void()	elena_transa17	= [	$transa17,	elena_transa18	] { rakuyo_run(); };
void()	elena_transa18	= [	$transa18,	elena_transa19	] { rakuyo_run(); };
void()	elena_transa19	= [	$transa19,	elena_transa20	] { rakuyo_run();
sound(self,CHAN_VOICE, "redfield/huntress/blood_scream.wav",1,ATTN_NORM);
local entity eb;
self.owner = spawn();
eb = self.owner;
setmodel(eb, MODEL_FIREBLAST);
setorigin(eb, self.origin);
eb.angles = self.angles;
eb.alpha = 0.3;
eb.skin = 1;
eb.nextthink = time + 0.5;
eb.think = SUB_Remove;
};
void()	elena_transa20	= [	$transa20,	elena_transa21	] { ai_forward(4); rakuyo_run();
self.owner.frame = 1;
self.owner.alpha = 0.25;
ai_shockwave(MONAI_ELENAIMPACT, MONAI_ELENADAMAGE, MONAI_ELENARADIUS, MONAI_ELENAFORWARD, MONAI_ELENAUP);
ThrowGib(11,6); 			// Blood toss
};
void()	elena_transa21	= [	$transa21,	elena_transa22	] { rakuyo_run();
self.owner.frame = 2;
self.owner.alpha = 0.2;
};
void()	elena_transa22	= [	$transa22,	elena_transa23	] { rakuyo_run();
self.owner.frame = 3;
self.owner.alpha = 0.1;
};
void()	elena_transa23	= [	$transa23,	elena_run1	] { rakuyo_run();
self.owner.frame = 4;
self.owner.alpha = 0.05;
};

// Check if HP is at 2/3 and setup phase 2 attack
float() elena_Phase2Check = {
	if (self.health > 1 && self.health < 650 && phase_Counter == 0) return TRUE;
	return FALSE;
};

void() elena_Phase2Run = {
	if (elena_Phase2Check() == TRUE) { elena_transa1(); return; }
};

void() elena_PhaseGate = {
	if (phase_Counter == 0) {
		elena_Phase2Run();
	}
	else if (phase_Counter == 1) {
		elena_Phase3Run();
	}
	else return;
}

void()	elena_run1	= [	$walk1,		elena_run2	] { ai_run(5); rakuyo_run(); elena_PhaseGate(); self.skin = 0; SUB_FinishAttachment2(); };
void()	elena_run2	= [	$walk2,		elena_run3	] { ai_run(6); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run3	= [	$walk3,		elena_run4	] { monster_footstep(FALSE); ai_run(7); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run4	= [	$walk4,		elena_run5	] { ai_run(6); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run5	= [	$walk5,		elena_run6	] { ai_run(6); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run6	= [	$walk6,		elena_run7	] { ai_run(4); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run7	= [	$walk7,		elena_run8	] { ai_run(4); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run8	= [	$walk8,		elena_run9	] { ai_run(5); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run9	= [	$walk9,		elena_run10	] { ai_run(5); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run10	= [	$walk10,	elena_run11	] { ai_run(6); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run11	= [	$walk11,	elena_run12	] { monster_footstep(FALSE); ai_run(5); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run12	= [	$walk12,	elena_run13	] { ai_run(6); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run13	= [	$walk13,	elena_run14	] { ai_run(5); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run14	= [	$walk14,	elena_run15	] { ai_run(5); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run15	= [	$walk15,	elena_run16	] { ai_run(6); rakuyo_run(); elena_PhaseGate(); };
void()	elena_run16	= [	$walk16,	elena_run1	] { ai_run(4); rakuyo_run(); elena_PhaseGate(); };

// Fireball damage - Hitscan based on radius of blastsize per frame
void(float fbfactor) fireblast = {
	local vector	delta;
	local float 	ldmg;
	
	if (!enemy_vis) return;
	if (!self.enemy) return;	
		
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > fbfactor) return;
		
	ldmg = 2 + (3 * skill);
	T_Damage(self.enemy, self, self, ldmg, DAMARMOR);
};

//Floating blast attack - transition to boss phase 3
void()	elena_blast1	= [	$blast1,	elena_blast2	] {
	rakuyo_run();
	self.skin = 0;
	self.pain_finished = time + 2.8;
	phase_Counter = phase_Counter + 1;
};
void()	elena_blast2	= [	$blast2,	elena_blast3	] { rakuyo_run(); };
void()	elena_blast3	= [	$blast3,	elena_blast4	] { rakuyo_run(); };
void()	elena_blast4	= [	$blast4,	elena_blast5	] { rakuyo_run(); };
void()	elena_blast5	= [	$blast5,	elena_blast6	] { rakuyo_run(); };
void()	elena_blast6	= [	$blast6,	elena_blast7	] { rakuyo_run(); };
void()	elena_blast7	= [	$blast7,	elena_blast8	] { rakuyo_run(); };
void()	elena_blast8	= [	$blast8,	elena_blast9	] { rakuyo_run(); };
void()	elena_blast9	= [	$blast9,	elena_blast10	] { rakuyo_run(); };
void()	elena_blast10	= [	$blast10,	elena_blast11	] { rakuyo_run(); };
void()	elena_blast11	= [	$blast11,	elena_blast12	] { rakuyo_run(); };
void()	elena_blast12	= [	$blast12,	elena_blast13	] { rakuyo_run(); };
void()	elena_blast13	= [	$blast13,	elena_blast14	] { rakuyo_run(); };
void()	elena_blast14	= [	$blast14,	elena_blast15	] { rakuyo_run(); };
void()	elena_blast15	= [	$blast15,	elena_blast16	] { rakuyo_run(); };
void()	elena_blast16	= [	$blast16,	elena_blast17	] { rakuyo_run(); };
void()	elena_blast17	= [	$blast17,	elena_blast18	] {
	local entity fb;

	rakuyo_run();
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"redfield/huntress/fireball.wav",1,ATTN_NORM);
	self.owner = spawn();
	fb = self.owner;
	setmodel(fb, MODEL_FIREBLAST);
	setorigin(fb, self.origin);
	fb.angles = self.angles;
	fb.alpha = 0.2;
	fb.nextthink = time + 0.5;
	fb.think = SUB_Remove;
	ai_shockwave(MONAI_ELENAIMPACT, MONAI_ELENADAMAGE, MONAI_ELENARADIUS, MONAI_ELENAFORWARD, MONAI_ELENAUP);
};
void()	elena_blast18	= [	$blast18,	elena_blast19	] {
rakuyo_run();
self.effects = self.effects | EF_MUZZLEFLASH;
self.owner.frame = 1;
self.owner.alpha = 0.35;
fireblast(100);
check_FireTrig();
};
void()	elena_blast19	= [	$blast19,	elena_blast20	] {
rakuyo_run();
self.owner.frame = 2;
self.owner.alpha = 0.5;
fireblast(230);
};
void()	elena_blast20	= [	$blast20,	elena_blast21	] {
rakuyo_run();
self.owner.frame = 3;
self.owner.alpha = 0.8;
fireblast(450);
};
void()	elena_blast21	= [	$blast21,	elena_blast22	] {
rakuyo_run();
self.owner.frame = 4;
self.owner.alpha = 0.1;
if (skill == SKILL_NIGHTMARE) fireblast(512);
};
void()	elena_blast22	= [	$blast22,	elena_blast23	] { rakuyo_run(); };
void()	elena_blast23	= [	$blast23,	elena_blast24	] { rakuyo_run(); };
void()	elena_blast24	= [	$blast24,	elena_blast25	] { rakuyo_run(); };
void()	elena_blast25	= [	$blast25,	elena_blast26	] { rakuyo_run(); };
void()	elena_blast26	= [	$blast26,	elena_blast27	] { rakuyo_run(); };
void()	elena_blast27	= [	$blast27,	elena_blast28	] { ai_charge(2); rakuyo_run(); };
void()	elena_blast28	= [	$blast28,	elena_run1	] { rakuyo_run(); };


//----------------------------------------------------------------------
// Check if HP is at 1/3 and setup phase 3
//----------------------------------------------------------------------

float() elena_Phase3Check = {
	if (self.health > 1 && self.health < 350 && phase_Counter == 1) 
		{
		return TRUE;
		}
	return FALSE;
};

void() elena_Phase3Run = {
	if (elena_Phase3Check() == TRUE) { elena_blast1(); return; }
};

void() check_FireTrig =
// Is there any trigger for the fireblast?
{
	if (self.noise != "") {
		self.attachment3 = find(world, targetname, self.noise);
			if (self.attachment3.classtype == CT_ELENABLAST) {
				// Spawn any adds to keep player busy
				if (self.attachment3.target != "") 
					trigger_strs(self.attachment3.target, self);
		}
	}
};

/*======================================================================
 elena_melee (ai melee with added damage spice factor!)
======================================================================*/
void() elena_melee = {
	local float ldmg;

	if (!self.enemy) return;			// removed before stroke
	ai_damagebreakable(20);				// Damage any breakables
	if (!ai_checkmelee(MONAI_ELENAFRONT, FALSE)) return;	// Too far away

	// Can the target bleed? - no blood/damage, quick exit
	// This candamage test not in origina id code (sync'd to melee_side)
	if (!CanDamage (self.enemy, self)) return;

	// 3-10 damage depending on boss phase
	ldmg = ((random() + random() + random()) * 2) + (2 * phase_Counter);
	if (ldmg < 3) ldmg = 3;
	T_Damage(self.enemy, self, self, ldmg, DAMARMOR);

	// Only spawn blood/gore/sound every second
	if (self.meleetimer < time) {
		self.meleetimer = time + 1;
		SpawnMeatSpray (self, self.enemy, random() * 100);
	}
	
	// Some melee weapons have swing and hit as separate sounds
	// This is trigger_once per melee combat swing
	// No check if meleehitsound is defined or not
	if (self.meleecontact) {
		self.meleecontact = FALSE;
		sound(self,CHAN_WEAPON,self.meleehitsound,1,ATTN_NORM);
	}
};
	
//----------------------------------------------------------------------
// Spinning leap - Jumps upward while spinning and slams down for heavy damage
void() elena_SpinTouch = {
	local float ldmg;
	
	if (self.health < 1) return;
	ai_jumpbreakable(60);			// Damage any breakables
	self.touch = SUB_Null;			// No more touching
	//self.count = self.count + 1;	// Total amount of touch jumps
	self.think = self.th_jumpexit;	// Exit frame
	self.jumptouch = other;			// Keep track of touch target

	if ( CanDamage(other, self) ) {
		if ( vlen(self.velocity) > 300 ) {
		  ldmg = 20 + 10*random();
			T_Damage(other, self, self, ldmg, DAMARMOR);	
			spawn_touchblood (self, self.enemy, ldmg*3);
		}
	}

	// Is the huntress floating in the air?
	if (!checkbottom(self)) {
		// Is the huntress standing on something?		
		if (self.flags & FL_ONGROUND) {	
			// Do an extra jump if got the count
			if (self.count < 2)  self.think = self.th_jump;
		}
	}

	// Next timer
	self.nextthink = time + 0.1;
};

//===========================================================================
void()	elena_spin1	= [	$spin1,		elena_spin2	] { ai_face();
rakuyo_run();
self.skin = 0;
self.pain_finished = time + 2.2;		// No pain
self.jump_flag = time + MONAI_JUMPELENATIME;
};
void()	elena_spin2	= [	$spin2,		elena_spin3	] { ai_face(); rakuyo_run(); };
void()	elena_spin3	= [	$spin3,		elena_spin4	] { ai_face(); rakuyo_run();
	sound(self,CHAN_WEAPON,"redfield/huntress/spin.wav",1,ATTN_NORM);
};
void()	elena_spin4	= [	$spin4,		elena_spin5	] { ai_face(); rakuyo_run(); };
void()	elena_spin5	= [	$spin5,		elena_spin6	] {
	local entity sb;

	ai_face(); 
	self.jump_flag = time + MONAI_JUMPELENATIME;
	self.touch = elena_SpinTouch;
	makevectors(self.angles);
	self.velocity = v_forward * 500 + '0 0 250';
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.oldorigin = self.origin;
	setmodel(self.attachment,"");
	self.owner = spawn();
	sb = self.owner;
	setmodel(sb, MODEL_ELENASPIN);
	setorigin(sb, self.origin);
	sb.angles = self.angles;
	if (phase_Counter < 2) {
		sb.skin = 0;
		sb.alpha = 0.2;
	} else {
		sb.skin = 1;
		sb.alpha = 0.8;
	}

	sb.nextthink = time + 0.6;
	sb.think = SUB_Remove;
};
void()	elena_spin6	= [	$spin6,		elena_spin7	] { self.owner.frame = 1; self.owner.origin = self.origin;
self.owner.angles = self.angles;
if (phase_Counter > 0) ThrowGib(11,1); 			// Blood toss
};
void()	elena_spin7	= [	$spin7,		elena_spin8	] { self.owner.frame = 2; self.owner.origin = self.origin;
self.owner.angles = self.angles;
if (phase_Counter > 0) ThrowGib(11,2); 			// Blood toss
};
void()	elena_spin8	= [	$spin8,		elena_spin9	] { self.owner.frame = 3; self.owner.origin = self.origin;
self.owner.angles = self.angles;
if (phase_Counter > 0) ThrowGib(11,2); 			// Blood toss
};
void()	elena_spin9	= [	$spin9,		elena_spin10	] { self.owner.frame = 4; self.owner.origin = self.origin;
self.owner.angles = self.angles;
if (phase_Counter > 0) ThrowGib(11,2); 			// Blood toss
};
void()	elena_spin10	= [	$spin10,	elena_spin11	] { self.owner.frame = 5; self.owner.origin = self.origin;
self.owner.angles = self.angles;
if (phase_Counter > 0) ThrowGib(11,2); 			// Blood toss
};
void()	elena_spin11	= [	$spin11,	elena_spin12	] { self.owner.frame = 6; self.owner.origin = self.origin;
self.owner.angles = self.angles;
if (phase_Counter > 0) ThrowGib(11,2); 			// Blood toss
};
void()	elena_spin12	= [	$spin12,	elena_spin12	] { self.owner.frame = 7; self.owner.origin = self.origin;
self.owner.angles = self.angles;
// Double check huntress is still falling?
	if (VectorIsAllZeros(self.velocity) || self.oldorigin == self.origin) {
		self.ideal_yaw = random() * 360; 	//random jump angle
		self.think = elena_spin5;			// Keep jumping
	}
	self.oldorigin = self.origin;

};
void()	elena_spin13	= [	$spin13,	elena_spin14	] { monster_footstep(FALSE);
self.owner.frame = 8; 
self.owner.origin = self.origin;
self.owner.angles = self.angles;
	sound(self,CHAN_VOICE, "redfield/huntress/landing_scream.wav",1,ATTN_NORM);
};
void()	elena_spin14	= [	$spin14,	elena_spin15	] { rakuyo_run(); elena_melee();
local entity ds;
self.owner = spawn();
ds = self.owner;
setmodel(ds, MODEL_ELENADUST);
setorigin(ds, self.origin);
ds.angles = self.angles;
ds.alpha = 0.5;
ds.nextthink = time + 0.4;
ds.think = SUB_Remove;
};
void()	elena_spin15	= [	$spin15,	elena_spin16	] { rakuyo_run(); elena_melee();
self.owner.frame = 1;
self.owner.alpha = 0.4;
};
void()	elena_spin16	= [	$spin16,	elena_spin17	] { rakuyo_run(); elena_melee();
self.owner.frame = 2;
self.owner.alpha = 0.2;
};
void()	elena_spin17	= [	$spin17,	elena_spin18	] { rakuyo_run();
self.owner.frame = 3;
self.owner.alpha = 0.1;
};
void()	elena_spin18	= [	$spin18,	elena_spin19	] { rakuyo_run(); };
void()	elena_spin19	= [	$spin19,	elena_spin20	] { rakuyo_run(); };
void()	elena_spin20	= [	$spin20,	elena_spin21	] { rakuyo_run(); };
void()	elena_spin21	= [	$spin21,	elena_run1	] { monster_footstep(FALSE); ai_resetangles();
rakuyo_run();
};

/*===========================================================================
Melee Attacks
=============================================================================*/
//----------------------------------------------------------------------
void()	elena_slashb1	= [	$slashb1,	elena_slashb2	] { ai_charge(4); rakuyo_run(); self.skin = 0; };
void()	elena_slashb2	= [	$slashb2,	elena_slashb3	] { ai_charge(8); rakuyo_run(); };
void()	elena_slashb3	= [	$slashb3,	elena_slashb4	] { ai_charge(2); rakuyo_run(); };
void()	elena_slashb4	= [	$slashb4,	elena_slashb5	] { ai_charge(3); rakuyo_run(); };
void()	elena_slashb5	= [	$slashb5,	elena_slashb6	] { ai_charge(6); elena_melee(); rakuyo_run();
SwordSwipeSound(); };
void()	elena_slashb6	= [	$slashb6,	elena_slashb7	] { ai_charge(8); elena_melee(); rakuyo_run(); };
void()	elena_slashb7	= [	$slashb7,	elena_slashb8	] { ai_charge(2); elena_melee(); rakuyo_run();
local entity slb;
self.owner = spawn();
slb = self.owner;
setmodel(slb, MODEL_ELENASLSH);
setorigin(slb, self.origin);
slb.angles = self.angles;
if (phase_Counter == 0) { slb.skin = 0; slb.alpha = 0.4; }
	else if (phase_Counter == 1) { slb.skin = 2; slb.alpha = 1; }
	else { slb.skin = 1; slb.alpha = 0.8; }
slb.frame = 1;
slb.nextthink = time + 0.1;
slb.think = SUB_Remove;
};
void()	elena_slashb8	= [	$slashb8,	elena_slashb9	] { ai_charge(1); rakuyo_run(); };
void()	elena_slashb9	= [	$slashb9,	elena_run1	] { ai_charge(1); rakuyo_run(); };

//===========================================================================
void()	elena_slasha1	= [	$slasha1,	elena_slasha2	] { ai_charge(4); rakuyo_run(); self.skin = 0; };
void()	elena_slasha2	= [	$slasha2,	elena_slasha3	] { ai_charge(8); rakuyo_run(); };
void()	elena_slasha3	= [	$slasha3,	elena_slasha4	] { ai_charge(2); rakuyo_run(); };
void()	elena_slasha4	= [	$slasha4,	elena_slasha5	] { ai_charge(3); rakuyo_run(); };
void()	elena_slasha5	= [	$slasha5,	elena_slasha6	] { ai_charge(6); elena_melee(); rakuyo_run();
SwordSwipeSound(); };
void()	elena_slasha6	= [	$slasha6,	elena_slasha7	] { ai_charge(8); elena_melee(); rakuyo_run(); };
void()	elena_slasha7	= [	$slasha7,	elena_slasha8	] { ai_charge(2); elena_melee(); rakuyo_run();
local entity slb;
self.owner = spawn();
slb = self.owner;
setmodel(slb, MODEL_ELENASLSH);
setorigin(slb, self.origin);
slb.angles = self.angles;
if (phase_Counter == 0) { slb.skin = 0; slb.alpha = 0.4; }
	else if (phase_Counter == 1) { slb.skin = 2; slb.alpha = 1; }
	else { slb.skin = 1; slb.alpha = 0.8; }
slb.nextthink = time + 0.1;
slb.think = SUB_Remove;
};
void()	elena_slasha8	= [	$slasha8,	elena_run1	] { ai_charge(1); rakuyo_run();
	if (ai_checkmelee(MONAI_ELENAFRONT, FALSE) && self.enemy.health > 0) self.think = elena_slashb1;
};

void()	elena_stab1	= [	$stab1,		elena_stab2	] { ai_charge(2); rakuyo_run(); self.skin = 0; };
void()	elena_stab2	= [	$stab2,		elena_stab3	] { ai_charge(8); rakuyo_run();
	local entity spr;

	sound(self,CHAN_EXTRA1, "redfield/huntress/chingb.wav", 0.5,ATTN_IDLE);
	self.owner = spawn();
	spr = self.owner;
	setmodel(spr, MODEL_ELENASPR);
	setorigin(spr, self.origin);
	spr.angles = self.angles;
	spr.nextthink = time + 0.1;
	spr.think = SUB_Remove;
};
void()	elena_stab3	= [	$stab3,		elena_stab4	] { ai_charge(8); rakuyo_run(); };
void()	elena_stab4	= [	$stab4,		elena_stab5	] { ai_charge(12); rakuyo_run(); };
void()	elena_stab5	= [	$stab5,		elena_stab6	] { ai_charge(2); rakuyo_run(); };
void()	elena_stab6	= [	$stab6,		elena_stab7	] { ai_chargenoturn(3); elena_melee(); rakuyo_run(); SwordSwipeSound(); };
void()	elena_stab7	= [	$stab7,		elena_stab8	] { ai_chargenoturn(1); elena_melee(); rakuyo_run(); };
void()	elena_stab8	= [	$stab8,		elena_stab9	] { ai_chargenoturn(0); elena_melee(); rakuyo_run(); };
void()	elena_stab9	= [	$stab9,		elena_stab10	] { ai_chargenoturn(0); rakuyo_run(); };
void()	elena_stab10	= [	$stab10,	elena_run1	] { ai_charge(1); rakuyo_run(); };

void()	elena_cross1	= [	$cross1,		elena_cross2	] { ai_charge(2); rakuyo_run(); self.skin = 0; };
void()	elena_cross2	= [	$cross2,		elena_cross3	] { ai_charge(8); rakuyo_run(); };
void()	elena_cross3	= [	$cross3,		elena_cross4	] { ai_charge(8); rakuyo_run();
	sound(self,CHAN_EXTRA1, "redfield/huntress/ching.wav", 0.5,ATTN_IDLE); };
void()	elena_cross4	= [	$cross4,		elena_cross5	] { ai_chargenoturn(12); rakuyo_run(); elena_melee();
SwordSwipeSound(); };
void()	elena_cross5	= [	$cross5,		elena_cross6	] { ai_chargenoturn(2); self.meleecontact = TRUE; ai_meleesmash(10);
rakuyo_run();
local entity slb;
self.owner = spawn();
slb = self.owner;
setmodel(slb, MODEL_ELENASLSH);
setorigin(slb, self.origin);
slb.angles = self.angles;
if (phase_Counter == 0) { slb.skin = 0; slb.alpha = 0.4; }
	else if (phase_Counter == 1) { slb.skin = 2; slb.alpha = 1; }
	else { slb.skin = 1; slb.alpha = 0.8; }
slb.frame = 2;
slb.nextthink = time + 0.1;
slb.think = SUB_Remove;
};
void()	elena_cross6	= [	$cross6,		elena_cross7	] { ai_chargenoturn(0); self.meleecontact = FALSE; elena_melee();
rakuyo_run();
};
void()	elena_cross7	= [	$cross7,		elena_cross8	] { ai_chargenoturn(0); rakuyo_run(); };
void()	elena_cross8	= [	$cross8,		elena_cross9	] { ai_charge(2); rakuyo_run(); };
void()	elena_cross9	= [	$cross9,		elena_cross10	] { ai_charge(8); rakuyo_run(); };
void()	elena_cross10	= [	$cross10,		elena_run1	] { ai_charge(5); rakuyo_run(); };



//----------------------------------------------------------------------
void() elena_choosemelee = {
	// Make sure next attack is different to previous (randomly while loop)
	self.lip = self.meleeattack;
	while (self.lip == self.meleeattack) { self.lip = rint(random()*2);	}
	self.meleeattack = self.lip;
	if (self.meleeattack == 0) elena_slasha1();		// slash to left
	else if (self.meleeattack == 1) elena_stab1();		// double stab
	else elena_cross1();					// cross blades and slash out

};

void()	elena_pain1	= [	$pain1,		elena_pain2	] { elena_PhaseGate(); self.skin = 0; rakuyo_run(); };
void()	elena_pain2	= [	$pain2,		elena_pain3	] { monster_footstep(FALSE); ai_back(5); rakuyo_run(); };
void()	elena_pain3	= [	$pain3,		elena_pain4	] { rakuyo_run(); };
void()	elena_pain4	= [	$pain4,		elena_pain5	] { self.skin = 1; rakuyo_run(); };
void()	elena_pain5	= [	$pain5,		elena_pain6	] { rakuyo_run(); };
void()	elena_pain6	= [	$pain6,		elena_pain7	] { self.skin = 0; rakuyo_run(); };
void()	elena_pain7	= [	$pain7,		elena_pain8	] { rakuyo_run(); };
void()	elena_pain8	= [	$pain8,		elena_pain9	] { rakuyo_run(); };
void()	elena_pain9	= [	$pain9,		elena_run1	] { rakuyo_run(); };

void(entity inflictor, entity attacker, float damage) elena_pain = {
	//Reset Evelyn pistol if holding
	SUB_FinishAttachment2();	
	
	//Reset skin
	self.skin = 0;

	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);	
		if (self.pain_check == 1) elena_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 2;
			self.axhitme = 0;
			elena_pain1();
		}
	}
};

// RANGE ATTACK 1 - Shoot the Evelyn Pistol!
void() elena_shootgun = {
	local vector org, vec;

	if (!self.enemy) return;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self,CHAN_WEAPON,"redfield/huntress/pistol.wav",1,ATTN_NORM);
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	vec = normalize((self.enemy.origin + '0 0 -8') - self.origin);
	self.attack_speed = SPEED_ELENAGUN + (skill * SPEED_ELENASKILL);
	launch_projectile(org,vec,NO_SPIN,CT_PROJ_EVEBULLET,self.attack_speed);
};

void()	elena_shoot1	= [	$shoot1,	elena_shoot2	] { self.skin = 0; rakuyo_run(); };
void()	elena_shoot2	= [	$shoot2,	elena_shoot3	] { ai_face(); elena_usegun(0); rakuyo_run();
	sound(self,CHAN_WEAPON,"redfield/huntress/pistol_cock.wav",1,ATTN_NORM); };
void()	elena_shoot3	= [	$shoot3,	elena_shoot4	] { ai_face(); elena_usegun(1); rakuyo_run(); };
void()	elena_shoot4	= [	$shoot4,	elena_shoot5	] { ai_face(); elena_usegun(1); rakuyo_run(); };
void()	elena_shoot5	= [	$shoot5,	elena_shoot6	] { ai_face(); elena_usegun(1); rakuyo_run(); };
void()	elena_shoot6	= [	$shoot6,	elena_shoot7	] { ai_face(); elena_usegun(1); elena_shootgun();
	rakuyo_run();
	sound(self,CHAN_WEAPON,"redfield/huntress/pistol.wav",1,ATTN_NORM); };
void()	elena_shoot7	= [	$shoot7,	elena_shoot8	] { self.skin = 1; elena_usegun(1);
	rakuyo_run();
	local entity gs;
	self.owner = spawn();
	gs = self.owner;
	setmodel(gs, MODEL_ELENASMOKE);
	setorigin(gs, self.origin);
	gs.angles = self.angles;
	gs.alpha = 0.5;
	gs.nextthink = time + 0.3;
	gs.think = SUB_Remove;
};
void()	elena_shoot8	= [	$shoot8,	elena_shoot9	] { self.skin = 0; elena_usegun(1); 
	rakuyo_run();
	self.owner.frame = 1;
	self.owner.alpha = 0.4;
};
void()	elena_shoot9	= [	$shoot9,	elena_shoot10	] { elena_usegun(1);
	rakuyo_run();
	self.owner.frame = 2;
	self.owner.alpha = 0.2;
};
void()	elena_shoot10	= [	$shoot10,	elena_shoot11	] { elena_usegun(1); rakuyo_run(); };
void()	elena_shoot11	= [	$shoot11,	elena_shoot12	] { elena_usegun(1); rakuyo_run(); };
void()	elena_shoot12	= [	$shoot12,	elena_shoot13	] { SUB_FinishAttachment2(); rakuyo_run(); };
void()	elena_shoot13	= [	$shoot13,	elena_run1	] { rakuyo_run(); };

// RANGE ATTACK 2 - Blood Spears - from Golem rock storm
void() elena_bldspears =  {
	local float shotcount, zpart;
	local vector org, dir, yrand, zrand;

	if (!self.enemy) return;
	if (self.health < 1) return;

	// Make sure facing the right direction
	makevectors(self.angles);

	// Randomize quantity each time called
	if (random() < 0.5) shotcount = 2;
	else shotcount = 3;

	while (shotcount > 0) {
		// Randomly spawn spears from the Huntress' chest
		yrand = (crandom()*30)*v_right;
		zrand = (crandom()*30)*v_up;
		org = self.origin + attack_vector('36 0 8') + yrand + zrand;

		// Straight line velocity from source to target
		dir = (self.enemy.origin - org) + (v_right*(crandom()*50));
		dir = normalize (dir);

		// Variable speed based on skill level with extra random spice
		self.attack_speed = SPEED_ELENASPEAR + (skill * SPEED_ELENASKILL) + random()*10;
		launch_projectile(org,dir,NO_SPIN,CT_PROJ_BLDSPEAR,self.attack_speed);
		shotcount = shotcount - 1;
	}
};

// RANGE ATTACK 3 - Blood and FIRE! - From Ad 1.8 BossJudicator
void() elena_fireflameline = {
	local vector org, dir;
	local float fire_col;

	// Judge cannot find target!
	if (!self.enemy) return;

	// Turn toward enemy
	makevectors(self.angles);	
	org = self.origin + attack_vector('36 0 8');
	dir = v_forward;
	
	// Fire that flame!
	fire_col = FLAME_RED;
	// Origin, v_forward, colour, sfx
	Launch_Trail (org, dir, fire_col, "");
};

void()	elena_spear1	= [	$spear1,	elena_spear2	] { ai_stand(); rakuyo_run();
	self.skin = 0;
	self.pain_finished = time + 2.9;
};
void()	elena_spear2	= [	$spear2,	elena_spear3	] { ai_face(); rakuyo_run(); };
void()	elena_spear3	= [	$spear3,	elena_spear4	] { ai_face(); rakuyo_run(); };
void()	elena_spear4	= [	$spear4,	elena_spear5	] { ai_face(); rakuyo_run(); };
void()	elena_spear5	= [	$spear5,	elena_spear6	] { ai_face(); rakuyo_run(); };
void()	elena_spear6	= [	$spear6,	elena_spear7	] { ai_face(); rakuyo_run(); };
void()	elena_spear7	= [	$spear7,	elena_spear8	] { ai_face(); rakuyo_run();
	sound(self,CHAN_WEAPON,"redfield/huntress/spears.wav",1,ATTN_NORM); };
void()	elena_spear8	= [	$spear8,	elena_spear9	] { ai_face(); rakuyo_run(); };
void()	elena_spear9	= [	$spear9,	elena_spear10	] { ai_face(); rakuyo_run(); };
void()	elena_spear10	= [	$spear10,	elena_spear11	] { ai_face(); rakuyo_run(); };
void()	elena_spear11	= [	$spear11,	elena_spear12	] { ai_face(); elena_particles('8 8 16',16,0.4,4,512);
	rakuyo_run();
};
void()	elena_spear12	= [	$spear12,	elena_spear13	] { ai_face(); rakuyo_run();
	local entity spr;

	self.owner = spawn();
	spr = self.owner;
	setmodel(spr, MODEL_ELENASPR);
	setorigin(spr, self.origin);
	spr.angles = self.angles;
	spr.frame = 1;
	spr.nextthink = time + 0.3;
	spr.think = SUB_Remove;
};
void()	elena_spear13	= [	$spear13,	elena_spear14	] { ai_face(); rakuyo_run(); };
void()	elena_spear14	= [	$spear14,	elena_spear15	] { ai_face(); rakuyo_run();
	self.effects = self.effects | EF_MUZZLEFLASH;
};
void()	elena_spear15	= [	$spear15,	elena_spear16	] { ai_face(); rakuyo_run(); elena_bldspears(); };
void()	elena_spear16	= [	$spear16,	elena_spear17	] { ai_face(); rakuyo_run(); elena_bldspears(); };
void()	elena_spear17	= [	$spear17,	elena_spear18	] { ai_face(); rakuyo_run(); elena_bldspears(); };
void()	elena_spear18	= [	$spear18,	elena_spear19	] { ai_face(); rakuyo_run();
	if (phase_Counter > 1) elena_fireflameline(); };
void()	elena_spear19	= [	$spear19,	elena_spear20	] { rakuyo_run(); };
void()	elena_spear20	= [	$spear20,	elena_spear21	] { rakuyo_run(); };
void()	elena_spear21	= [	$spear21,	elena_spear22	] { rakuyo_run(); elena_particles('20 0 24',6,0.5,4,512);
	sound(self,CHAN_EXTRA1, "redfield/huntress/chingb.wav", 0.5,ATTN_IDLE); };
void()	elena_spear22	= [	$spear22,	elena_spear23	] { rakuyo_run(); };
void()	elena_spear23	= [	$spear23,	elena_spear24	] { rakuyo_run(); };
void()	elena_spear24	= [	$spear24,	elena_spear25	] { rakuyo_run(); };
void()	elena_spear25	= [	$spear25,	elena_spear26	] { rakuyo_run(); };
void()	elena_spear26	= [	$spear26,	elena_spear27	] { rakuyo_run(); };
void()	elena_spear27	= [	$spear27,	elena_spear28	] { rakuyo_run(); };
void()	elena_spear28	= [	$spear28,	elena_run1	] { rakuyo_run(); };

void() elena_choose_atk = {
	local vector delta;
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) < MONAI_ELENARANGE) { 
		if (phase_Counter < 1) { elena_shoot1(); }
		else {
			if (random() < 0.6) elena_spear1();
				else elena_shoot1();
		} 
	} else {
		elena_shoot1();
	}
};

// Only functions when monster spawns standing -- No walking / path corners
void() elena_wakeup = {
	// Dead already?
	if (self.health < 1) return;

	// No longer need taunt spawnflag, remove it
	if (self.spawnflags & MON_HUNTRESS_TAUNT) {
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_HUNTRESS_TAUNT); }
	self.takedamage = DAMAGE_AIM;		// Can receive damage
	self.use = SUB_Null;				// no re-trigger
	
	// Restore all think state functions
	self.th_run = elena_run1;
	self.th_melee = elena_choosemelee;
	self.th_missile = elena_choose_atk;
	self.movetype = MOVETYPE_STEP;
	self.pain_finished = time + 3;		// No pain
	self.attack_finished = 2.8 + random();	// No skill adjustment
	elena_taunt1();
};

void()	elena_die1	= [	$death1,	elena_die2	] { ai_back(4); self.skin = 0; rakuyo_run(); };
void()	elena_die2	= [	$death2,	elena_die3	] { ai_back(2); rakuyo_run(); };
void()	elena_die3	= [	$death3,	elena_die4	] { rakuyo_run(); };
void()	elena_die4	= [	$death4,	elena_die5	] { self.skin = 1; rakuyo_run(); };
void()	elena_die5	= [	$death5,	elena_die6	] { self.skin = 0; rakuyo_run(); };
void()	elena_die6	= [	$death6,	elena_die7	] { rakuyo_run(); };
void()	elena_die7	= [	$death7,	elena_die8	] { rakuyo_run(); };
void()	elena_die8	= [	$death8,	elena_die9	] { rakuyo_run();
	sound(self,CHAN_WEAPON,GIB_SOUND_METALB,1,ATTN_NORM); };
void()	elena_die9	= [	$death9,	elena_die10	] { ai_forward(5); rakuyo_run(); };
void()	elena_die10	= [	$death10,	elena_die11	] { ai_forward(4); self.skin = 1; rakuyo_run(); };
void()	elena_die11	= [	$death11,	elena_die12	] { self.skin = 2; rakuyo_run(); };
void()	elena_die12	= [	$death12,	elena_die13	] { self.solid = SOLID_NOT;
rakuyo_run();
};
void()	elena_die13	= [	$death13,	elena_die14	] { self.alpha = 0.9; rakuyo_run();
particle_explode(self.origin + '0 0 -22', 24+(8*(random()*2)), 0.5+random()*0.5, PARTICLE_BURST_BLUE, PARTICLE_BURST_UPWARD); };
void()	elena_die14	= [	$death14,	elena_die15	] { self.alpha = 0.75; rakuyo_run(); };
void()	elena_die15	= [	$death15,	elena_die16	] { self.alpha = 0.6; rakuyo_run(); };
void()	elena_die16	= [	$death16,	elena_die17	] { self.skin = 3; self.alpha = 0.45; rakuyo_run(); 
particle_explode(self.origin + '0 0 -18', 16+(8*(random()*2)), 1+random()*0.5, PARTICLE_BURST_BLUE, PARTICLE_BURST_UPWARD); };
void()	elena_die17	= [	$death17,	elena_die18	] { self.alpha = 0.2; rakuyo_run(); };
void()	elena_die18	= [	$death18,	elena_die18	] {
	rakuyo_run();
	// Stop thinking and hide entity (prevent elena_die18 loop)
	self.nextthink = LARGE_TIMER;
	self.think = SUB_Null;
	entity_hide(self);
};

void() elena_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	SUB_FinishAttachment2();
	SUB_RemoveAttachment2(); // Make sure Evelyn pistol is removed
	if (!self.gibbed) {
		sound(self,CHAN_VOICE, self.death_sound,1,ATTN_NORM);
		elena_die1(); // regular death
	}
};

void() monster_huntress_precache = {
	precache_model ("progs/redfield/mon_huntress.mdl");
	precache_model ("progs/redfield/huntress/rakuyo.mdl");
	precache_model (MODEL_PROJ_KSPELL);
	precache_model (MODEL_PROJ_EVEBULLET);
	precache_model (MODEL_PROJ_BLDSPEAR);
	precache_model (MODEL_PROJ_ELENAFIRE);
	precache_model (MODEL_EVELYN);
	precache_model (MODEL_FIREBLAST);
	precache_model (MODEL_ELENASPIN);
	precache_model (MODEL_ELENASLSH);
	precache_model (MODEL_ELENASPR);
	precache_model (MODEL_ELENADUST);
	precache_model (MODEL_ELENASMOKE);
	precache_model (SBURST_FLAME);
	precache_model ("progs/redfield/huntress/empty_blood.mdl");
	PreCache_Flame(); // Flame Attack
	precache_model(MODEL_PROJ_RINGSHOCK);	// Ground shockwave
	precache_sound("redfield/huntress/pistol.wav");
	precache_sound("redfield/huntress/pistol_cock.wav");
	precache_sound("redfield/huntress/fireball.wav");
	precache_sound("redfield/huntress/stabbed.wav");
	precache_sound("redfield/huntress/spin.wav");
	precache_sound("redfield/huntress/landing_scream.wav");
	precache_sound("redfield/huntress/blood_scream.wav");
	precache_sound("redfield/huntress/spears.wav");
	precache_sound("redfield/huntress/ching.wav");
	precache_sound("redfield/huntress/chingb.wav");
	precache_sound("redfield/huntress/idlea.wav");
	precache_sound("redfield/huntress/sight.wav");
	precache_sound("redfield/huntress/pain.wav");
	precache_sound("redfield/huntress/death1.wav");
	precache_sound("hknight/hit.wav");
	precache_sound("redfield/huntress/step1.wav");
	precache_sound("redfield/huntress/step2.wav");
	precache_sound("redfield/huntress/step3.wav");
	precache_sound("redfield/huntress/step4.wav");
	precache_sound("redfield/huntress/step5.wav");
};

// QUAKED monster_huntress (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_huntress = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/redfield/mon_huntress.mdl";			// Elena the Blood Huntress with multiple skins
	self.gib1mdl = "progs/redfield/huntress/empty_blood.mdl";	// Empty model for blood toss on spin attack
	self.idle_sound = "redfield/huntress/idlea.wav";
	self.sight_sound = "redfield/huntress/sight.wav";
	self.pain_sound = "redfield/huntress/pain.wav";
	self.death_sound = "redfield/huntress/death1.wav";
	self.solid = SOLID_NOT;					// No interaction with world
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 900;
	self.gibhealth = MON_NEVERGIB;			// Cannot be gibbed by weapons
	self.gibbed = FALSE;					// Still in one piece
	self.pain_flinch = 200;					// Highpain threshold
	self.pain_timeout = 3;				// Very high pain tolerance
	self.pain_longanim = FALSE;		// cannot be stunned with Cursed Blade
	self.infightextra = 1.5;			// High damage to monsters
	self.blockudeath = TRUE;		// No player gib sound
	self.attack_offset = '32 5 24';		// End of pistol
	self.meleerange = MONAI_MELEEHUNTRESS;	// Melee Smash
	self.meleecontact = FALSE;	
	self.deathstring = " fell victim to the Blood Huntress\n";
	self.attachment = spawn(); //Rakuyo attachment setup
	self.attachment.movetype = MOVETYPE_NOCLIP;		// No movement
	self.attachment.solid = SOLID_NOT;			// no world interaction
	setmodel(self.attachment, "");
	setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self.attachment, self.origin);
	self.stepc1 = "redfield/huntress/step1.wav"; // Custom feet sounds
	self.stepc2 = "redfield/huntress/step2.wav";
	self.stepc3 = "redfield/huntress/step3.wav";
	self.stepc4 = "redfield/huntress/step4.wav";
	self.stepc5 = "redfield/huntress/step5.wav";
	self.steptype = FS_TYPECUSTOM;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent.  Resistant to all ranged attacks - using a sword is wise
	self.resist_shells = self.resist_nails = 0.75;
	self.resist_rockets = self.resist_cells = 0.75;
	self.th_checkattack = HuntressCheckAttack;
	self.th_stand = elena_idle1;
	self.th_walk = elena_walk1;
	self.th_pain = elena_pain;
	self.th_die = elena_die;
	self.th_jump = elena_spin1;
	self.th_jumpexit = elena_spin13;
	if (self.jumprange_x <= 0) self.jumprange_x = MONAI_JUMPELENANEAR;
	if (self.jumprange_y <= self.jumprange_x) self.jumprange_y = MONAI_JUMPELENAFAR;
	if (self.spawnflags & MON_HUNTRESS_TAUNT) { //Huntress taunt start
		self.th_run = self.th_missile = self.th_melee = elena_wakeup;
	} else { //Default Huntress start	
		self.th_melee = elena_choosemelee;
		self.th_missile = elena_choose_atk;
		self.th_run = elena_run1;
	}

	self.classgroup = CG_BOSS;	
	self.classtype = CT_MONHUNTRESS;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

// QUAKED monster_huntress_firetrig (0.75 0.25 1) (-32 -32 -8) (32 32 8) x
// Target for boss spell trigger
// -------- KEYS --------
// targetname : name of wave event (links to noise key on boss)
// target     : trigger name of adds to spawn
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Used to trigger events when the Huntress does a fireblast
void() monster_huntress_firetrig = {
	self.classtype = CT_ELENABLAST;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
};