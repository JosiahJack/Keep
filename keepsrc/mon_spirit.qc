//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Redfield
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
// Entity count: 
// Function count: 
//
// Implements: Vengeful Spirit
//
// Description:
// A ghostly ghoul of a woman that dissappears and reappears to attack from
// unexpected angles with a sword.
//=============================================================================

// Idle 
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10

// Walk 
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11

// Run 
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9

// Slash A
$frame slasha1 slasha2 slasha3 slasha4 slasha5 slasha6 slasha7 slasha8 slasha9

// Slash B
$frame slashb1 slashb2 slashb3 slashb4 slashb5 slashb6 slashb7 slashb8 
$frame slashb9 slashb10

// Stab
$frame stab1 stab2 stab3 stab4 stab5 stab6 stab7 stab8 
$frame stab9 stab10

// Spin
$frame spin1 spin2 spin3 spin4 spin5 spin6 spin7 spin8 
$frame spin9 spin10

// Pain 
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8
$frame pain9 pain10 

// Death
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

//Scream
$frame scream1 scream2 scream3 scream4 scream5 scream6 scream7 scream8 scream9
$frame scream10 scream11 scream12 scream13 scream14 scream15 scream16 scream17 
$frame scream18 scream19

//Laugh
$frame laugh1 laugh2 laugh3 laugh4 laugh5 laugh6 laugh7 laugh8 laugh9
$frame laugh10 laugh11 laugh12 laugh13 laugh14 laugh15 laugh16 laugh17 
$frame laugh18 laugh19 laugh20 laugh21

float SPIRIT_DISTMIN = 256;
float SPIRIT_DISTMAX = 512;

float spirit_atk;

void() spirit_sword_sound;

// Glowing aura attachment model, setup and management
void() spirit_glow = {	
	if (self.model == "") {
		setmodel(self.attachment, "");
	}
	else {
		setmodel(self.attachment, "progs/redfield/mon_spirit_glow.mdl");
	}
	if (self.attachment.movetype != MOVETYPE_STEP) self.attachment.movetype = MOVETYPE_STEP;
	self.attachment.frame = self.frame;
	setorigin(self.attachment, self.origin);
	self.attachment.angles = self.angles;
	self.attachment.velocity = self.velocity;
	self.attachment.alpha = self.alpha - 0.85;
	if (self.skin > 0) self.attachment.skin = 1;
	else self.attachment.skin = 0;
	if (self.attachment.alpha <= 0) self.attachment.alpha = 0.04;
};

void() spirit_glow_off = {
	if (self.attachment) {
		setmodel(self.attachment, "");
	}
};

void() spirit_remove_glow = {
	if (self.attachment) {
		self.attachment.state = FALSE;
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};


void() spirit_alphacontrol = {
	if (self.alpha < 1) { 
		self.alpha = self.alpha + 0.5;
	}
};


void()	spirit_laugh1	= [	$laugh1,	spirit_laugh2	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh2	= [	$laugh2,	spirit_laugh3	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh3	= [	$laugh3,	spirit_laugh4	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh4	= [	$laugh4,	spirit_laugh5	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh5	= [	$laugh5,	spirit_laugh6	] { ai_stand(); spirit_glow();
	sound (self, CHAN_VOICE, "redfield/spirit/idle_laugh.wav", 1, ATTN_NORM);
};
void()	spirit_laugh6	= [	$laugh6,	spirit_laugh7	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh7	= [	$laugh7,	spirit_laugh8	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh8	= [	$laugh8,	spirit_laugh9	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh9	= [	$laugh9,	spirit_laugh10	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh10	= [	$laugh10,	spirit_laugh11	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh11	= [	$laugh11,	spirit_laugh12	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh12	= [	$laugh12,	spirit_laugh13	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh13	= [	$laugh13,	spirit_laugh14	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh14	= [	$laugh14,	spirit_laugh15	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh15	= [	$laugh15,	spirit_laugh16	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh16	= [	$laugh16,	spirit_laugh17	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh17	= [	$laugh17,	spirit_laugh18	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh18	= [	$laugh18,	spirit_laugh19	] { ai_stand(); spirit_glow(); };
void()	spirit_laugh19	= [	$laugh19,	spirit_stand1	] { ai_stand(); spirit_glow(); };


void()	spirit_stand1	= [	$stand1,	spirit_stand2	] { ai_stand(); 
spirit_alphacontrol();
self.skin = 0;
spirit_glow();
};
void()	spirit_stand2	= [	$stand2,	spirit_stand3	] { ai_stand();
spirit_alphacontrol();
spirit_glow();
};
void()	spirit_stand3	= [	$stand3,	spirit_stand4	] { ai_stand(); spirit_glow(); };
void()	spirit_stand4	= [	$stand4,	spirit_stand5	] { ai_stand(); spirit_glow(); };
void()	spirit_stand5	= [	$stand5,	spirit_stand6	] { ai_stand(); spirit_glow(); };
void()	spirit_stand6	= [	$stand6,	spirit_stand7	] { ai_stand(); spirit_glow(); };
void()	spirit_stand7	= [	$stand7,	spirit_stand8	] { ai_stand(); spirit_glow(); };
void()	spirit_stand8	= [	$stand8,	spirit_stand9	] { ai_stand(); spirit_glow(); };
void()	spirit_stand9	= [	$stand9,	spirit_stand10	] { ai_stand(); spirit_glow(); };
void()	spirit_stand10	= [	$stand10,	spirit_stand1	] { ai_stand(); spirit_glow();
self.idlebusy = FALSE;
	if (random() < MON_IDLE_ANIMATION) {
		self.idlebusy = TRUE; 
		self.think = spirit_laugh1;		// Laugh
	}
};


void()	spirit_walk1	= [	$walk1,		spirit_walk2	] { self.skin = 0; ai_walk(4);
spirit_glow();
monster_idle_sound();
};
void()	spirit_walk2	= [	$walk2,		spirit_walk3	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk3	= [	$walk3,		spirit_walk4	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk4	= [	$walk4,		spirit_walk5	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk5	= [	$walk5,		spirit_walk6	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk6	= [	$walk6,		spirit_walk7	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk7	= [	$walk7,		spirit_walk8	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk8	= [	$walk8,		spirit_walk9	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk9	= [	$walk9,		spirit_walk10	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk10	= [	$walk10,	spirit_walk11	] { ai_walk(4); spirit_glow(); };
void()	spirit_walk11	= [	$walk11,	spirit_walk1	] { ai_walk(4); spirit_glow(); };


void()	spirit_run1	= [	$run1,		spirit_run2	] { ai_run(18);
spirit_alphacontrol();
spirit_glow(); 
monster_idle_sound();
};
void()	spirit_run2	= [	$run2,		spirit_run3	] { ai_run(18);
spirit_alphacontrol();
spirit_glow(); 
};
void()	spirit_run3	= [	$run3,		spirit_run4	] { ai_run(18); spirit_glow(); };
void()	spirit_run4	= [	$run4,		spirit_run5	] { ai_run(18); spirit_glow(); };
void()	spirit_run5	= [	$run5,		spirit_run6	] { ai_run(18); spirit_glow(); };
void()	spirit_run6	= [	$run6,		spirit_run7	] { ai_run(18); spirit_glow(); };
void()	spirit_run7	= [	$run7,		spirit_run8	] { ai_run(18); spirit_glow(); };
void()	spirit_run8	= [	$run8,		spirit_run9	] { ai_run(18); spirit_glow(); };
void()	spirit_run9	= [	$run9,		spirit_run1	] { ai_run(18); spirit_glow(); };

// Range - Fade to invisible and charge
void() spirit_ifin1 = {
	self.velocity = '0 0 0';
	// Always phase in facing the enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.angles_y = self.ideal_yaw;
	sound (self, CHAN_AUTO, "redfield/spirit/spin_laugh.wav", 1, ATTN_NORM);
	self.bodyphased = MONAI_SPIRITSOLID;
	self.takedamage = DAMAGE_AIM;
	self.skin = 1;
	spirit_glow();
	spirit_run1();
};

// Find new teleport location
void() spirit_fade = {
	local float dist, edist, fadefinished, fadecount;
	local vector org, org_ofs, angle_vec;

	fadefinished = TRUE; fadecount = 0;
	org = angle_vec = org_ofs = '0 0 0'; 
	org_ofs_z = 16;
	self.oldorigin = self.origin;
	
	// Trace upwards to find ceiling or maximum teleport height
	traceline(self.origin, self.origin+org_ofs, TRUE, self);
	org_ofs = trace_endpos;
	
	// Loop around for possible locations
	while(fadefinished) {
		fadecount = fadecount + 1;		// next loop
		angle_vec_y = random() * 360;		// Random direction
		makevectors(angle_vec);				// make vector
		
		// Generate random angle and trace teleport direction
		dist = self.distmin + (random() * self.distmax);
		org = org_ofs + (v_forward * dist);
		traceline(org_ofs, org, TRUE, self);
		
		// Check distance is far enough away from enemy
		// Move away from any walls (traceline is surface contact)
		dist = vlen(trace_endpos - org_ofs) - 32;
		org = org_ofs + (v_forward * dist);
		edist = vlen(self.enemy.origin - org);

		// Is the enemy far enough away?
		if (edist > MONAI_CLOSESPIRIT) {
			// Trace down to floor below new point
			traceline(org, org - '0 0 512', TRUE, self);
			org = trace_endpos + self.view_ofs;
			
			// The teleport fuction is working with a radius command
			// and this will ignore walls and just find any position
			// in all directions. This can lead to the spirit
			// teleporting behind walls or other parts of the map!
			// This can be prevent in two ways:
			// 1) linesight between spirit and player
			// - can leads to less interesting locations (always insight)
			// 2) linesight between new location and old
			// - This allows spirit to teleport around corner
			//   and still be within the same area!
			//
			// Trace through monsters and check trace fraction
			traceline(org, self.origin, TRUE, self);
			if (trace_fraction == 1) fadefinished = FALSE;
		}

		// Been looping too long, back to original location
		if (fadecount > 10) {
			fadefinished = FALSE;
			org = self.origin;
		}
	}
	
	// Move to new location
	self.solid = SOLID_SLIDEBOX;				// Standard monster movement
	setmodel(self, self.mdl);					// Setup model
	setsize (self, self.bbmins, self.bbmaxs);		// Restore BB size
	setorigin(self, org);						// move to new location
	
	// Test if new location is solid?
	if (!walkmove (0, 0)) {
		self.solid = SOLID_NOT;					// No world interaction yet
		setmodel(self,"");						// Turn off model
		//spirit_glow();						// Turn off glow
		setorigin(self, self.oldorigin);		// restore original location
		self.nextthink = time + 1;				// Keep checking
		self.think = spirit_fade;
	}
	else spirit_ifin1();
};

// Cycle around teleport chain lists instead
void() spirit_waitforlink = {
	self.nextthink = time + 0.5 + random();
	self.think = spirit_waitforlink;
	setorigin(self, self.movelast.origin);	// move to new location
	self.enemydist = range_distance(self.enemy, FALSE);

	// Is the enemy too close or dead?
	if (self.enemydist > self.movelast.distance || self.enemy.health < 1) {
		// Move to new location
		self.solid = SOLID_SLIDEBOX;				// Standard monster movement
		setmodel(self, self.mdl);					// Setup model
		setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	
		// Test if new location is solid?
		if (!walkmove (0, 0)) {
			self.solid = SOLID_NOT;					// No world interaction yet
			setmodel(self,"");						// Turn off model
			spirit_glow();						// Turn off glow
		}
		else spirit_ifin1();
	}
};

void() spirit_checkfadelist = {
		// Does the fade list exist already?
	if (self.movelast.classtype != CT_SPIRITTELEPORT) {
		self.movelast = find(world,targetname,self.target2);
		// Does the entity chain exist?
		if (self.movelast.classtype == CT_SPIRITTELEPORT)
			spirit_waitforlink();
		else {
			// target2 is not valid, do regular teleport
			self.target2 = "";
			spirit_fade();
		}
	} else {
		// Move forward in chain and try next spawn location
		self.movelast = self.movelast.enemy;
		spirit_waitforlink();
	}
};

// spin and fade to invisible
void() spirit_spin1	= [$spin1,	spirit_spin2    ] {
	self.pain_finished = time + 1.2;			// no pain during teleportation
	self.attack_finished = 2 + random();			// pause before next attack
	sound (self, CHAN_VOICE, "redfield/spirit/fadeout.wav", 1, ATTN_NORM);
	spirit_glow();
};
void() spirit_spin2	= [  $spin2,	spirit_spin3 ] { spirit_glow(); };
void() spirit_spin3	= [  $spin3,	spirit_spin4 ] {
	self.takedamage = DAMAGE_NO;	// No damage or impact, phasing out
	self.solid = SOLID_NOT;
	self.bodyphased = MONAI_SPIRITINVIS;
	particle_explode(self.origin, 100, 1, PARTICLE_BURST_WHITE, PARTICLE_BURST_UPWARD);
	spirit_glow();
};
void() spirit_spin4	= [  $spin4,	spirit_spin5 ] { spirit_glow(); };
void() spirit_spin5	= [  $spin5,	spirit_spin6 ] { spirit_glow(); };
void() spirit_spin6	= [  $spin6,	spirit_spin8 ] { spirit_glow(); };
void() spirit_spin7	= [  $spin7,	spirit_spin8 ] { spirit_glow(); };
void() spirit_spin8	= [  $spin8,	spirit_spin9 ] { self.alpha = 0.8; spirit_glow(); };
void() spirit_spin9	= [  $spin9,	spirit_spin10 ] { self.alpha = 0.4; spirit_glow(); };
void() spirit_spin10	= [  $spin10,	spirit_spin11 ] { self.alpha = 0.2; spirit_glow(); };
void() spirit_spin11	= {
	setmodel(self,"");
	spirit_glow();
	self.attachment.movetype = MOVETYPE_NOCLIP;
	// Check if a chain list has been defined
	if (self.target2 != "") spirit_checkfadelist();
	else spirit_fade();
};

void()	spirit_slasha1	= [	$slasha1,	spirit_slasha2	] { ai_charge(20); spirit_alphacontrol(); spirit_glow(); };
void()	spirit_slasha2	= [	$slasha2,	spirit_slasha3	] { ai_charge(16); spirit_alphacontrol(); spirit_glow(); };
void()	spirit_slasha3	= [	$slasha3,	spirit_slasha4	] { ai_charge_side(); self.skin = 0; spirit_glow(); };
void()	spirit_slasha4	= [	$slasha4,	spirit_slasha5	] { ai_charge_side(); spirit_glow(); };
void()	spirit_slasha5	= [	$slasha5,	spirit_slasha6	] { ai_charge_side(); spirit_sword_sound(); spirit_glow(); };
void()	spirit_slasha6	= [	$slasha6,	spirit_slasha7	] { ai_melee_side(); spirit_glow(); };
void()	spirit_slasha7	= [	$slasha7,	spirit_slasha8	] { ai_melee_side(); spirit_glow(); };
void()	spirit_slasha8	= [	$slasha8,	spirit_slasha9	] { ai_charge_side(); spirit_glow(); };
void()	spirit_slasha9	= [	$slasha9,	spirit_run1	] { ai_charge(12); spirit_glow();
	if (random() < 0.35) spirit_spin1();
};

void()	spirit_slashb1	= [	$slashb1,	spirit_slashb2	] { ai_charge(20); spirit_alphacontrol();
spirit_glow();
};
void()	spirit_slashb2	= [	$slashb2,	spirit_slashb3	] { ai_charge(14); spirit_alphacontrol(); spirit_glow(); };
void()	spirit_slashb3	= [	$slashb3,	spirit_slashb4	] { ai_charge_side(); self.skin = 0; spirit_glow(); };
void()	spirit_slashb4	= [	$slashb4,	spirit_slashb5	] { spirit_sword_sound(); ai_melee_side(); spirit_glow(); };
void()	spirit_slashb5	= [	$slashb5,	spirit_slashb6	] { ai_melee_side(); spirit_glow(); };
void()	spirit_slashb6	= [	$slashb6,	spirit_slashb7	] { ai_melee_side(); spirit_glow(); };
void()	spirit_slashb7	= [	$slashb7,	spirit_slashb8	] { ai_charge_side(); spirit_glow(); };
void()	spirit_slashb8	= [	$slashb8,	spirit_slashb9	] { ai_charge(8); spirit_glow(); };
void()	spirit_slashb9	= [	$slashb9,	spirit_slashb10	] { ai_charge(12); spirit_glow(); };
void()	spirit_slashb10	= [	$slashb10,	spirit_run1	] { ai_charge(16); spirit_glow();
if (random() < 0.3) spirit_spin1();
};

void()	spirit_stab1	= [	$stab1,		spirit_stab2	] { ai_charge(16); spirit_alphacontrol(); spirit_glow(); };
void()	spirit_stab2	= [	$stab2,		spirit_stab3	] { ai_charge(12); spirit_alphacontrol(); spirit_glow(); };
void()	spirit_stab3	= [	$stab3,		spirit_stab4	] { ai_charge(10); self.skin = 0; spirit_glow(); };
void()	spirit_stab4	= [	$stab4,		spirit_stab5	] { ai_charge(8); spirit_glow(); };
void()	spirit_stab5	= [	$stab5,		spirit_stab6	] { ai_charge(8); spirit_glow(); };
void()	spirit_stab6	= [	$stab6,		spirit_stab7	] { ai_charge(1); spirit_sword_sound();
spirit_glow();
ai_melee();
};
void()	spirit_stab7	= [	$stab7,		spirit_stab8	] { ai_charge(0); spirit_glow(); ai_melee(); };
void()	spirit_stab8	= [	$stab8,		spirit_stab9	] { ai_charge(0); spirit_glow(); ai_melee(); };
void()	spirit_stab9	= [	$stab9,		spirit_stab10	] { ai_charge(0); spirit_glow(); };
void()	spirit_stab10	= [	$stab10,	spirit_run1	] { ai_charge(8); spirit_glow();
if (random() < 0.25) spirit_spin1();
};

// Buildup particles for scream
void(vector leftofsb, vector rightofsb) spirit_charge = {	
	if (self.health < 1) return;

	// Work out each hand position
	makevectors(self.angles);
	self.pos1 = self.origin + attack_vector(leftofsb);
	self.pos2 = self.origin + attack_vector(rightofsb);	

	// Spawn some particles around the hands
	particle_explode(self.pos1, 3+random()*2, 0.2+random()*0.5, PARTICLE_BURST_WHITE, PARTICLE_BURST_LOSTUP);
	particle_explode(self.pos2, 3+random()*2, 0.2+random()*0.5, PARTICLE_BURST_WHITE, PARTICLE_BURST_LOSTUP);
};

//Scream
void()	spirit_scream1	= [	$scream1,	spirit_scream2	] { ai_charge(18); spirit_alphacontrol();
	// Cannot be interrupted
	self.pain_finished = time + 2;
	if (self.health > 0) sound (self, CHAN_WEAPON, "redfield/spirit/scream.wav", 1, ATTN_NORM);
	spirit_glow();
};
void()	spirit_scream2	= [	$scream2,	spirit_scream3	] { ai_charge(16); spirit_alphacontrol(); spirit_glow(); };
void()	spirit_scream3	= [	$scream3,	spirit_scream4	] { ai_charge(14); spirit_glow(); };
void()	spirit_scream4	= [	$scream4,	spirit_scream5	] { ai_charge(12); self.skin = 0; spirit_glow(); };
void()	spirit_scream5	= [	$scream5,	spirit_scream6	] { ai_charge(12); spirit_charge('8 -11 4','8 11 4');
	spirit_glow();
};
void()	spirit_scream6	= [	$scream6,	spirit_scream7	] { ai_charge(10); spirit_charge('9 -11 5','9 11 5');
	spirit_glow();
};
void()	spirit_scream7	= [	$scream7,	spirit_scream8	] { ai_charge(10); spirit_charge('12 -10 8','12 10 8');
	spirit_glow();
};
void()	spirit_scream8	= [	$scream8,	spirit_scream9	] { ai_charge(4); spirit_charge('13 -10 9','13 10 9');
	spirit_glow();
};
void()	spirit_scream9	= [	$scream9,	spirit_scream10	] { ai_chargenoturn(2); spirit_glow(); 
	local entity sb;

	self.owner = spawn();
	sb = self.owner;
	setmodel (sb, MODEL_SCREAM);
	setorigin (sb, self.origin + attack_vector(self.attack_offset));
	sb.angles = self.angles;
	sb.alpha = 0.3;
	sb.skin = 1;
	sb.nextthink = time + 0.5;
	sb.think = SUB_Remove;
	ai_shockwave(MONAI_SPIRITIMPACT, MONAI_SPIRITDAMAGE, MONAI_SPIRITRADIUS, MONAI_SPIRITFORWARD, MONAI_SPIRITUP);
};
void()	spirit_scream10	= [	$scream10,	spirit_scream11	] { ai_chargenoturn(0); spirit_glow();
	self.owner.frame = 1;
	self.owner.alpha = 0.3;
};
void()	spirit_scream11 = [	$scream11,	spirit_scream12	] { ai_chargenoturn(0); spirit_glow();
	self.owner.frame = 2;
	self.owner.alpha = 0.2;
};
void()	spirit_scream12	= [	$scream12,	spirit_scream13	] { ai_chargenoturn(0); spirit_glow();
	self.owner.frame = 3;
	self.owner.alpha = 0.1;
};
void()	spirit_scream13	= [	$scream13,	spirit_scream14	] { ai_chargenoturn(0); spirit_glow();
	self.owner.frame = 4;
	self.owner.alpha = 0.05;
};
void()	spirit_scream14	= [	$scream14,	spirit_scream15	] { ai_chargenoturn(0); spirit_glow(); };
void()	spirit_scream15	= [	$scream15,	spirit_scream16	] { ai_chargenoturn(0); spirit_glow(); };
void()	spirit_scream16	= [	$scream16,	spirit_scream17	] { ai_charge(4); spirit_glow(); };
void()	spirit_scream17	= [	$scream17,	spirit_scream18	] { ai_charge(8); spirit_glow(); };
void()	spirit_scream18	= [	$scream18,	spirit_scream19	] { ai_charge(12); spirit_glow(); };
void()	spirit_scream19	= [	$scream19,	spirit_run1	] { ai_charge(16); spirit_glow(); };

void() spirit_chooseatk = {
	if (!ai_checkmelee(self.meleerange,FALSE)) return;		// Too far away
	if (self.health < 1) return;				// Ghost is dead again

	spirit_atk = spirit_atk + 1;
	if (spirit_atk == 1)
		spirit_slasha1();
	else if (spirit_atk == 2)
		spirit_slashb1();
	else if (spirit_atk == 3)
		spirit_stab1();
	else if (spirit_atk == 4) {
		spirit_scream1();
		spirit_atk = 0;
	}
}; 

void() spirit_phased = { 
	self.nextthink = time + 0.1;	// Keep looking for player
	self.think = spirit_phased;		// Keep looping
	if (random() < 0.02) 
		particle_explode(self.origin, rint(10+random()*10), 1, PARTICLE_BURST_WHITE, PARTICLE_BURST_SKULLUP);
	monster_idle_sound(); 			// High chance of idle sound
	ai_stand(); 					// Keep looking
};

void() spirit_wakeup = {
	// Reset all monster state functions back to default
	self.th_stand = spirit_stand1;
	self.th_walk = spirit_walk1;
	self.th_run = spirit_run1;
	self.th_melee = spirit_chooseatk;

	// Temporarily restore model/bound box
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, self.mdl);
	setsize (self, self.bbmins, self.bbmaxs);
		
	// Can the spirit move?
	if (!walkmove (0, 0)) {
		// Something blocking, teleport elsewhere
		self.solid = SOLID_NOT;
		setmodel(self,"");
		spirit_glow();
		self.nextthink = time + 0.1;
		self.think = spirit_fade;
	}
	else spirit_ifin1();
};


void()	spirit_pain1	= [	$pain1,		spirit_pain2	] { sound (self, CHAN_VOICE, "redfield/spirit/pain.wav", 1, ATTN_NORM);
spirit_glow();
};
void()	spirit_pain2	= [	$pain2,		spirit_pain3	] { ai_back(2); spirit_glow(); };
void()	spirit_pain3	= [	$pain3,		spirit_pain4	] { ai_back(4); spirit_glow(); };
void()	spirit_pain4	= [	$pain4,		spirit_pain5	] { spirit_glow(); };
void()	spirit_pain5	= [	$pain5,		spirit_pain6	] { spirit_glow(); };
void()	spirit_pain6	= [	$pain6,		spirit_pain7	] { spirit_glow(); };
void()	spirit_pain7	= [	$pain7,		spirit_pain8	] { spirit_glow(); };
void()	spirit_pain8	= [	$pain8,		spirit_pain9	] { spirit_glow(); };
void()	spirit_pain9	= [	$pain9,		spirit_pain10	] { spirit_glow(); };
void()	spirit_pain10	= [	$pain10,	spirit_run1	] { spirit_glow();
if (random() < 0.75) spirit_spin1();
};

void(entity inflictor, entity attacker, float damage) spirit_pain = {
	
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);
	self.skin = 0;
	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);
		if (self.pain_check == 1) spirit_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 1.2;
			self.axhitme = 0;
			spirit_pain1();
		}
	}
};

void()	spirit_death1	= [	$death1,	spirit_death2	] { self.skin = 0; spirit_glow();
	sound (self, CHAN_VOICE, "redfield/spirit/death.wav", 1, ATTN_NORM);
};
void()	spirit_death2	= [	$death2,	spirit_death3	] { spirit_glow(); };
void()	spirit_death3	= [	$death3,	spirit_death4	] { self.solid = SOLID_NOT; spirit_glow(); };
void()	spirit_death4	= [	$death4,	spirit_death5	] { spirit_glow(); };
void()	spirit_death5	= [	$death5,	spirit_death6	] { spirit_glow(); };
void()	spirit_death6	= [	$death6,	spirit_death7	] { spirit_glow(); };
void()	spirit_death7	= [	$death7,	spirit_death8	] { spirit_glow(); };
void()	spirit_death8	= [	$death8,	spirit_death9	] { spirit_glow(); };
void()	spirit_death9	= [	$death9,	spirit_death10	] { self.alpha = 0.8; spirit_glow(); };
void()	spirit_death10	= [	$death10,	spirit_death11	] { self.alpha = 0.4; spirit_glow(); };
void()	spirit_death11	= [	$death11,	spirit_death12	] { self.alpha = 0.2; spirit_glow(); };
void()	spirit_death12	= [	$death12,	spirit_death12	] {
	// Stop thinking and hide entity (prevent spirit_death12 loop)
	spirit_glow_off();
	spirit_remove_glow();
	self.nextthink = LARGE_TIMER;
	self.think = SUB_Null;
	entity_hide(self);
};

void() spirit_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();

	// Special death, Instantly vaporize cloak
	// This is really a gib death without the gibs!
	if (self.health < -45) {
		// Play gib death sound
		sound (self, CHAN_VOICE, "redfield/spirit/deathb.wav", 1, ATTN_NORM);
		self.origin = self.origin + '0 0 24';
		Tent_Explosion2(self.origin,1,15);
		self.health = MON_NOGIBVELOCITY;	// Low gib directional modifier
		ThrowGib(11,1); 			// Throw sword
		spirit_glow_off();
		spirit_remove_glow();
		entity_hide(self);
	}
	// Regular death, collapse and fade away
	else {
		// Large particle explosion upwards
		particle_explode(self.origin, 100, 3, PARTICLE_BURST_WHITE, PARTICLE_BURST_SKULLUP);
		spirit_death1();
	}
};

void() spirit_sword_sound = {
	self.weaponstate = random();
	if (self.weaponstate < 0.35) sound (self, CHAN_WEAPON, "redfield/spirit/slash1.wav", 1, ATTN_NORM);
	else if (self.weaponstate < 0.65) sound (self, CHAN_WEAPON, "redfield/spirit/slash2.wav", 1, ATTN_NORM);
	else sound (self, CHAN_WEAPON, "redfield/spirit/slash3.wav", 1, ATTN_NORM);
};

void() monster_spirit_precache = {
	precache_model ("progs/redfield/mon_spirit.mdl");
	precache_model ("progs/redfield/mon_spirit_glow.mdl"); // Glowing aura attachment
	precache_model ("progs/redfield/sword_spirit.mdl");
	precache_model (MODEL_SCREAM);			// Scream blast
	precache_model(MODEL_PROJ_RINGSHOCK);	// Ground shockwave
	precache_sound ("redfield/spirit/idle1.wav");
	precache_sound ("redfield/spirit/idlecom1.wav");
	precache_sound ("redfield/spirit/idlecom2.wav");
	precache_sound ("redfield/spirit/slash1.wav");
	precache_sound ("redfield/spirit/slash2.wav");
	precache_sound ("redfield/spirit/slash3.wav");
	precache_sound ("redfield/spirit/scream.wav");			// Screaming explosion
	precache_sound ("redfield/spirit/pain.wav");			// Long pain		
	precache_sound ("redfield/spirit/death.wav");
	precache_sound ("redfield/spirit/deathb.wav");
	precache_sound ("redfield/spirit/fadeout.wav");			// Fade away
	precache_sound ("redfield/spirit/idle_laugh.wav");		// laughing animation
	precache_sound ("redfield/spirit/spin_laugh.wav");		// laughing from spin
	precache_sound ("redfield/spirit/sight.wav");
};

// QUAKED monster_spirit (0.5 0 1) (-16 -16 -24) (16 16 40)
void() monster_spirit = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/redfield/mon_spirit.mdl";			// Vengeful spirit model with multiple skins
	self.gib1mdl = "progs/redfield/sword_spirit.mdl";		// Sword for gib death
	self.gib1sound = GIB_IMPACT_METALA;	
	self.idle_sound = "redfield/spirit/idle1.wav";
	self.idle_soundcom = "redfield/spirit/idlecom1.wav";
	self.idle_soundcom2 = "redfield/spirit/idlecom2.wav";
	self.pain_sound = SOUND_EMPTY;
	self.sight_sound = "redfield/spirit/sight.wav";
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 225;
	self.gibhealth = MON_NEVERGIB;	// Cannot be gibbed by weapons
	self.gibbed = FALSE;			// Still in one piece
	self.pain_flinch = 20;			// Easy to stun
	self.pain_timeout = 2;				// Long pause on pain
	self.steptype = FS_FLYING;
	self.bleedcolour = MON_BCOLOR_WHITE;	
	self.meleecontact = FALSE;		// Scream smash contact
	self.pain_longanim = TRUE;		// Long pain animation
	self.attack_offset = '16 0 8';		// Between hands
	self.deathstring = " was murdered by Vengeful Spirit\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent

	//Glow attachment setup
	self.attachment = spawn();
	self.attachment.movetype = MOVETYPE_NOCLIP;		// No movement
	self.attachment.solid = SOLID_NOT;			// no world interaction
	setmodel(self.attachment, "");
	setsize(self.attachment,VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self.attachment, self.origin);
	self.attachment.state = TRUE;

	// Vengeful Spirits have special animation movement sets.  Need extra
	// parameters for their teleporting ability.  Can be setup to start phased
	// out and surprise the player.
	if (self.distmin == 0) self.distmin = SPIRIT_DISTMIN;
	if (self.distmax == 0) self.distmax = SPIRIT_DISTMAX;
	if (!self.bodyphased) self.bodyphased = MONAI_SPIRITSOLID;
	else self.bodyphased = MONAI_SPIRITINVIS;

	self.meleerange = MONAI_MELEESPIRIT;
	self.th_checkattack = SpiritCheckAttack;
	self.th_pain = spirit_pain;
	self.th_die = spirit_die;

	// Does the spirit start phased out?
	// Need to intercept idle/combat functions
	if (self.bodyphased == MONAI_SPIRITINVIS) {
		self.th_stand = spirit_phased;
		self.th_walk = spirit_phased;
		self.th_run = spirit_wakeup;
		self.th_melee = spirit_wakeup;
	} else {
		self.th_stand = spirit_stand1;
		self.th_walk = spirit_walk1;
		self.th_run = spirit_run1;
		self.th_melee = spirit_chooseatk;
	}
	
	self.classtype = CT_MONSPIRIT;
	self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEWALK;		
	monster_start();
};

// QUAKED info_spirit_destination (0.6 0 0.8) (-16 -16 -24) (16 16 40) x
// Teleport destination for Vengeful Spirit ONLY
// -------- KEYS --------
// targetname : part of a chain group (required)
// target   : next destination in the chain
// distance : Minimum distance enemy needs to be before spawning
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Teleport destination for Vengeful Spirit ONLY
void() info_spirit_link = {
	local entity currlink, master;
	local float loopcondition;
	
	// Teleport destination already been linked
	if (self.enemy) return;
	
	// The master entity is the start of the chain
	// the currlink is a link in the chain
	master = self;
	loopcondition = TRUE;
	
	while (loopcondition) {
		// Setup next link to master and find next link
		self.enemy = master;
		currlink = find(world, targetname, self.target);
		// reached end of list?
		if (!currlink || currlink == master) 
			loopcondition = FALSE;
		else {
			// Move forward in the chain
			self.enemy = currlink;
			self = currlink;
		}
	}
};

void() info_spirit_destination = {
	// All teleportation points need to be part of a chain otherwise the Spirit would have to use findradius which is expensive if lots of entities are around.
	if (SUB_HideIfNoTargetname()) return;
	if (SUB_HideIfNoTarget()) return;
	
	self.classtype = CT_SPIRITTELEPORT;
	self.mangle = self.angles;
	// Setup minimum player spawn distance
	if (self.distance <=0) self.distance = MONAI_CLOSESPIRIT;
	// Setup if the destination is active or not
	self.state = FALSE;

	// Check for targetname->target loops
	if (self.targetname == self.target) {
		self.enemy = self;
		self.owner = self;
	} else {
		// Wait for all targets to spawn
		self.think = info_spirit_link;
		self.nextthink = time + 0.2 + random();
	}
};