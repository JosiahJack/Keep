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
// Entity count: 1
// Function count: 149 
//
// Implements: Raven 
//
// Description:
// A black raven, typically a harmless denizen though sinister forces may make
// certain of them attack hapless travelers as used in Ravenkeep.  Capable of
// starting perched or feeding.
//=============================================================================

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10 fly11
$frame takeoff1 takeoff2 takeoff3 takeoff4 takeoff5 takeoff6 takeoff7 takeoff8
$frame takeoff9 takeoff10 takeoff11 takeoff12 
$frame eat1 eat2 eat3 eat4 eat5 eat6 eat7 eat8 eat9 eat10 eat11
$frame eat12 eat13 eat14 eat15 eat16 eat17 eat18 eat19 eat20 eat21 eat22
$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10 
$frame atk11 atk12 atk13 atk14 atk15 atk16 atk17 atk18 atk19 
$frame glide1 glide2 glide3 glide4 glide5 glide6 glide7 glide8 glide9 glide10 
$frame glide11 glide12 glide13 glide14 glide15 glide16 glide17 glide18 glide19 glide20 
$frame glide21 glide22 glide23
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19 stand20 
$frame stand21 stand22 stand23 stand24 stand25 stand26

void() raven_melee;

void()	raven_stand1	= [	$stand1,		raven_stand2	] { ai_stand(); };
void()	raven_stand2	= [	$stand2,		raven_stand3	] { ai_stand(); };
void()	raven_stand3	= [	$stand3,		raven_stand4	] { ai_stand(); };
void()	raven_stand4	= [	$stand4,		raven_stand5	] { ai_stand(); };
void()	raven_stand5	= [	$stand5,		raven_stand6	] { ai_stand(); };
void()	raven_stand6	= [	$stand6,		raven_stand7	] { ai_stand(); };
void()	raven_stand7	= [	$stand7,		raven_stand8	] { ai_stand(); };
void()	raven_stand8	= [	$stand8,		raven_stand9	] { ai_stand(); };
void()	raven_stand9	= [	$stand9,		raven_stand10	] { ai_stand(); };
void()	raven_stand10	= [	$stand10,		raven_stand11	] { ai_stand(); };
void()	raven_stand11	= [	$stand11,		raven_stand12	] { ai_stand(); };
void()	raven_stand12	= [	$stand12,		raven_stand13	] { ai_stand(); };
void()	raven_stand13	= [	$stand13,		raven_stand14	] { ai_stand(); };
void()	raven_stand14	= [	$stand14,		raven_stand15	] { ai_stand(); };
void()	raven_stand15	= [	$stand15,		raven_stand16	] { ai_stand(); };
void()	raven_stand16	= [	$stand16,		raven_stand17	] { ai_stand(); };
void()	raven_stand17	= [	$stand17,		raven_stand18	] { ai_stand(); };
void()	raven_stand18	= [	$stand18,		raven_stand19	] { ai_stand(); };
void()	raven_stand19	= [	$stand19,		raven_stand20	] { ai_stand(); };
void()	raven_stand20	= [	$stand20,		raven_stand21	] { ai_stand(); };
void()	raven_stand21	= [	$stand21,		raven_stand22	] { monster_idle_sound(); ai_stand(); };
void()	raven_stand22	= [	$stand22,		raven_stand23	] { ai_stand(); };
void()	raven_stand23	= [	$stand23,		raven_stand24	] { ai_stand(); };
void()	raven_stand24	= [	$stand24,		raven_stand25	] { ai_stand(); };
void()	raven_stand25	= [	$stand25,		raven_stand26	] { ai_stand(); };
void()	raven_stand26	= [	$stand26,		raven_stand1	] { ai_stand(); };

void()	raven_glide1	= [	$glide1,		raven_glide2	] { ai_walk(8); };
void()	raven_glide2	= [	$glide2,		raven_glide3	] { ai_walk(8); };
void()	raven_glide3	= [	$glide3,		raven_glide4	] { ai_walk(8); };
void()	raven_glide4	= [	$glide4,		raven_glide5	] { ai_walk(8); };
void()	raven_glide5	= [	$glide5,		raven_glide6	] { ai_walk(8); };
void()	raven_glide6	= [	$glide6,		raven_glide7	] { ai_walk(8); };
void()	raven_glide7	= [	$glide7,		raven_glide8	] { ai_walk(8); };
void()	raven_glide8	= [	$glide8,		raven_glide9	] { ai_walk(8); };
void()	raven_glide9	= [	$glide9,		raven_glide10	] { ai_walk(8); };
void()	raven_glide10	= [	$glide10,		raven_glide11	] { ai_walk(8); };
void()	raven_glide11	= [	$glide11,		raven_glide12	] { monster_idle_sound(); ai_walk(8); };
void()	raven_glide12	= [	$glide12,		raven_glide13	] { ai_walk(8); };
void()	raven_glide13	= [	$glide13,		raven_glide14	] { ai_walk(8); };
void()	raven_glide14	= [	$glide14,		raven_glide15	] { ai_walk(8); };
void()	raven_glide15	= [	$glide15,		raven_glide16	] { ai_walk(8); };
void()	raven_glide16	= [	$glide16,		raven_glide17	] { ai_walk(8); };
void()	raven_glide17	= [	$glide17,		raven_glide18	] { ai_walk(8); sound(self,CHAN_VOICE,"redfield/raven/wings.wav",1,ATTN_NORM); };
void()	raven_glide18	= [	$glide18,		raven_glide19	] { ai_walk(8); };
void()	raven_glide19	= [	$glide19,		raven_glide20	] { ai_walk(8); };
void()	raven_glide20	= [	$glide20,		raven_glide21	] { ai_walk(8); };
void()	raven_glide21	= [	$glide21,		raven_glide22	] { ai_walk(8); };
void()	raven_glide22	= [	$glide22,		raven_glide23	] { ai_walk(8); };
void()	raven_glide23	= [	$glide23,		raven_glide1	] { ai_walk(8); };

void()	raven_eat1	= [	$eat3,		raven_eat2	] { ai_stand(); };
void()	raven_eat2	= [	$eat4,		raven_eat3	] { ai_stand(); };
void()	raven_eat3	= [	$eat5,		raven_eat4	] { ai_stand(); };
void()	raven_eat4	= [	$eat6,		raven_eat5	] { ai_stand(); };
void()	raven_eat5	= [	$eat7,		raven_eat6	] { ai_stand(); };
void()	raven_eat6	= [	$eat8,		raven_eat7	] { ai_stand(); };
void()	raven_eat7	= [	$eat9,		raven_eat8	] { ai_stand(); };
void()	raven_eat8	= [	$eat10,		raven_eat9	] { ai_stand(); };
void()	raven_eat9	= [	$eat11,		raven_eat10	] { ai_stand(); };
void()	raven_eat10	= [	$eat12,		raven_eat11	] { ai_stand(); };
void()	raven_eat11	= [	$eat13,		raven_eat12	] { ai_stand(); };
void()	raven_eat12	= [	$eat14,		raven_eat13	] { ai_stand(); };
void()	raven_eat13	= [	$eat15,		raven_eat14	] { ai_stand(); };
void()	raven_eat14	= [	$eat16,		raven_eat15	] { ai_stand(); };
void()	raven_eat15	= [	$eat17,		raven_eat16	] { ai_stand(); };
void()	raven_eat16	= [	$eat18,		raven_eat17	] { ai_stand(); };
void()	raven_eat17	= [	$eat19,		raven_eat18	] { ai_stand(); };
void()	raven_eat18	= [	$eat20,		raven_eat19	] { ai_stand(); };
void()	raven_eat19	= [	$eat21,		raven_eat20	] { ai_stand(); };
void()	raven_eat20	= [	$eat22,		raven_eat1	] { ai_stand(); };

void()	raven_takeoff1	= [	$takeoff1,		raven_takeoff2	] { ai_run(8); };
void()	raven_takeoff2	= [	$takeoff2,		raven_takeoff3	] { ai_run(8); };
void()	raven_takeoff3	= [	$takeoff3,		raven_takeoff4	] { ai_run(8);
	sound(self,CHAN_VOICE, "redfield/raven/wings.wav",1,ATTN_NORM); };
void()	raven_takeoff4	= [	$takeoff4,		raven_takeoff5	] { ai_run(8); };
void()	raven_takeoff5	= [	$takeoff5,		raven_takeoff6	] { ai_run(8); };
void()	raven_takeoff6	= [	$takeoff6,		raven_takeoff7	] { ai_run(8); };
void()	raven_takeoff7	= [	$takeoff7,		raven_takeoff8	] { ai_run(8); };
void()	raven_takeoff8	= [	$takeoff8,		raven_takeoff9	] { ai_run(8); };
void()	raven_takeoff9	= [	$takeoff9,		raven_takeoff10	] { ai_run(8); };
void()	raven_takeoff10	= [	$takeoff10,		raven_takeoff11	] { ai_run(8); };
void()	raven_takeoff11	= [	$takeoff11,		raven_takeoff12	] { ai_run(8); };
void()	raven_takeoff12	= [	$takeoff12,		raven_run7	] { ai_run(8); };

void()	raven_run1	= [	$fly1,		raven_run2	] { ai_face(); ai_run(28); };
void()	raven_run2	= [	$fly2,		raven_run3	] { ai_run(28);sound(self,CHAN_VOICE,"redfield/raven/wings.wav",1,ATTN_NORM); };
void()	raven_run3	= [	$fly3,		raven_run4	] { ai_run(28); };
void()	raven_run4	= [	$fly4,		raven_run5	] { ai_run(28); };
void()	raven_run5	= [	$fly5,		raven_run6	] { ai_run(28); };
void()	raven_run6	= [	$fly6,		raven_run7	] { ai_run(28); };
void()	raven_run7	= [	$fly7,		raven_run8	] { ai_run(28); };
void()	raven_run8	= [	$fly8,		raven_run9	] { ai_run(28); };
void()	raven_run9	= [	$fly9,		raven_run10	] { ai_run(28); };
void()	raven_run10	= [	$fly10,		raven_run11	] { ai_run(28); };
void()	raven_run11	= [	$fly11,		raven_run1	] { ai_run(28); };

void()	raven_hover1	= [	$fly1,		raven_hover2	] { ai_stand(); };
void()	raven_hover2	= [	$fly2,		raven_hover3	] { ai_stand();sound(self,CHAN_VOICE,"redfield/raven/wings.wav",1,ATTN_NORM); };
void()	raven_hover3	= [	$fly3,		raven_hover4	] { ai_stand(); };
void()	raven_hover4	= [	$fly4,		raven_hover5	] { ai_stand(); };
void()	raven_hover5	= [	$fly5,		raven_hover6	] { ai_stand(); };
void()	raven_hover6	= [	$fly6,		raven_hover7	] { ai_stand(); };
void()	raven_hover7	= [	$fly7,		raven_hover8	] { ai_stand(); };
void()	raven_hover8	= [	$fly8,		raven_hover9	] { ai_stand(); };
void()	raven_hover9	= [	$fly9,		raven_hover10	] { ai_stand(); };
void()	raven_hover10	= [	$fly10,		raven_hover11	] { ai_stand(); };
void()	raven_hover11	= [	$fly11,		raven_hover1	] { ai_stand(); };

void()	raven_atk1  	= [ 	$atk1, 		raven_atk2 	] { ai_charge(26); };
void()	raven_atk2  	= [ 	$atk2, 		raven_atk3 	] { ai_charge(26); };
void()	raven_atk3  	= [ 	$atk3, 		raven_atk4 	] { ai_charge(26); };
void()	raven_atk4  	= [ 	$atk4, 		raven_atk5 	] { ai_charge(26); };
void()	raven_atk5  	= [ 	$atk5, 		raven_atk6 	] { ai_charge(24);raven_melee();
	sound(self,CHAN_VOICE, "redfield/raven/rclaw.wav",1,ATTN_NORM); };
void()	raven_atk6  	= [ 	$atk6, 		raven_atk7 	] { ai_charge(26); };
void()	raven_atk7  	= [ 	$atk7, 		raven_atk8 	] { ai_charge(24);raven_melee(); };
void()	raven_atk8  	= [ 	$atk8, 		raven_atk9 	] { ai_charge(26); };
void()	raven_atk9  	= [ 	$atk9, 		raven_atk10 	] { ai_charge(26); };
void()	raven_atk10  	= [ 	$atk10, 	raven_atk11 	] { ai_charge(26); };
void()	raven_atk11  	= [ 	$atk11, 	raven_atk12	] { ai_charge(26); };
void()	raven_atk12  	= [ 	$atk12, 	raven_atk13	] { ai_charge(24);raven_melee();
	sound(self,CHAN_VOICE, "redfield/raven/rsnap.wav",1,ATTN_NORM); };
void()	raven_atk13  	= [ 	$atk13, 	raven_atk14 	] { ai_charge(26); };
void()	raven_atk14  	= [ 	$atk14, 	raven_atk15	] { ai_charge(26); };
void()	raven_atk15  	= [ 	$atk15, 	raven_atk16	] { ai_charge(24);raven_melee();
	sound(self,CHAN_VOICE, "redfield/raven/ravencall.wav",1,ATTN_NORM); };
void()	raven_atk16  	= [ 	$atk16, 	raven_atk17	] { ai_charge(26); };
void()	raven_atk17  	= [ 	$atk17, 	raven_atk18	] { ai_charge(26); };
void()	raven_atk18  	= [ 	$atk18, 	raven_atk19	] { ai_charge(26); };
void()	raven_atk19  	= [ 	$atk19, 	raven_run1 	] { ai_charge(26); };

void() raven_glidechoose = { // [FUNCTION]
	if (random() < 0.5) raven_glide1();
	else raven_glide12();
};

// Raven Claw and Bite --- This is not a melee attack! Uses very short hitscan to circumvent flying monster z axis melee calculations. 
void() raven_melee = { // [FUNCTION]
	local float ldmg;
	local vector org, dir;
	if (self.health < 1) return;

	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);
	self.enemydist = MONAI_RANGERAVEN2;
	traceline (org, self.origin + dir*self.enemydist, TRUE, self); // Trace direct line in front of Raven
	ldmg = (random() + random() + random()) * 2; // Raven claws! 2-6 Damage
	if (ldmg < 2) ldmg = 2;	
	// Check for any breakables first
	if (ai_foundbreakable(self, trace_ent, FALSE)) {
		T_Damage(trace_ent, self, self, ldmg, DAMARMOR);
	} else LightningDamage(org, trace_endpos, self, ldmg); // Random hitscan damage

	spawn_touchblood (self, self.enemy, ldmg*3); // Spawn some touch blood (no explicit direction)
};

void() raven_wakeup = { // [FUNCTION]
	// Dead already?
	if (self.health < 1) return;

	// No longer need perch/feed spawnflag, remove it
	if (self.spawnflags & MON_RAVEN_PERCH) {
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_RAVEN_PERCH);
	}
	else if (self.spawnflags & MON_RAVEN_FEED) {
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_RAVEN_FEED);
	}
	self.spawnstatue = FALSE;		// No longer stationary

	self.takedamage = DAMAGE_AIM;		// Can receive damage
	self.use = SUB_Null;				// no re-trigger
	
	// Restore all think state functions
	self.th_stand = self.th_walk = raven_glide1;
	self.th_run = raven_run1;
	self.th_missile = raven_atk1;

	// Allow raven to fly up, no more ground checks
	self.flags = self.flags | FL_FLY;
	self.movetype = MOVETYPE_STEP;
	self.pain_finished = time + 1.5;		// No pain
	self.attack_finished = 1.5 + random();	// No skill adjustment
	raven_takeoff1();
};

void(entity inflictor, entity attacker, float damage) raven_pain = {
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		self.pain_finished = time + 1;
	}
	else if (self.pain_check == 2) {
		// reset axe hit and setup short pain recovery
		self.pain_finished = time + 1;
		self.axhitme = 0;	
	}
};

void() raven_death1 = [$death1, raven_death2 ] {};
void() raven_death2 = [$death2, raven_death3 ] { monster_check_gib(); };
void() raven_death3 = [$death3, raven_death4 ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() raven_death4 = [$death4, raven_death5 ] {};
void() raven_death5 = [$death5, raven_death6 ] {};
void() raven_death6 = [$death6, raven_death7 ] {};
void() raven_death7 = [$death7, raven_death8 ] {};
void() raven_death8 = [$death8, raven_death9 ] {};
void() raven_death9 = [$death9, raven_death10 ] {};
void() raven_death10 = [$death10, raven_death11 ] {};
void() raven_death11 = [$death11, raven_death12 ] {};
void() raven_death12 = [$death12, raven_death13 ] { monster_death_postcheck(); };
void() raven_death13 = [$death13, raven_death13 ] { monster_deadbody_check(); };

void() raven_deathb1 = [$deathb1, raven_deathb2 ] {};
void() raven_deathb2 = [$deathb2, raven_deathb3 ] { monster_check_gib(); };
void() raven_deathb3 = [$deathb3, raven_deathb4 ] { monster_check_gib(); self.solid = SOLID_NOT; };
void() raven_deathb4 = [$deathb4, raven_deathb5 ] {};
void() raven_deathb5 = [$deathb5, raven_deathb6 ] {};
void() raven_deathb6 = [$deathb6, raven_deathb7 ] { monster_death_postcheck(); };
void() raven_deathb7 = [$deathb7, raven_deathb7 ] { monster_deadbody_check(); };

void() raven_die = {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities

	if (!self.gibbed) {  //normal death
		if (random() < 0.5) { sound(self,CHAN_VOICE, "redfield/raven/rdeath.wav",1,ATTN_NORM); }
		else sound(self,CHAN_VOICE, "redfield/raven/rdeathb.wav",1,ATTN_NORM);
		self.flags = FL_MONSTER;			// reset all flag conditions
		self.movetype = MOVETYPE_TOSS;			// Affected by gravity
		self.velocity_x = -100 + 200*random();
		self.velocity_y = -100 + 200*random();
		self.velocity_z = 100 + 100*random();
		if (random() < 0.5)
			raven_deathb1(); 
		else
			raven_death1();
	}
};

void() monster_raven_precache = {
	precache_model("progs/redfield/mon_raven.mdl");
	precache_model("progs/redfield/h_raven.mdl");
	precache_model("progs/redfield/gib_ravenwing.mdl");
	precache_model("progs/redfield/gib_ravenfoot.mdl");
	precache_sound("redfield/raven/ravencall.wav");
	precache_sound("redfield/raven/wings.wav");
	precache_sound("redfield/raven/rdeath.wav");
	precache_sound("redfield/raven/rdeathb.wav");
	precache_sound("redfield/raven/rpain.wav");
	precache_sound("redfield/raven/rclaw.wav");
	precache_sound("redfield/raven/rsnap.wav");
	precache_sound("redfield/raven/rsight.wav");
};

// QUAKED monster_raven (1 0 0) (-16 -16 -24) (16 16 16) Ambush
void() monster_raven = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/redfield/mon_raven.mdl";
	self.headmdl = "progs/redfield/h_raven.mdl";
	self.gib1mdl = "progs/redfield/gib_ravenwing.mdl";	// Right wing
	self.gib2mdl = "progs/redfield/gib_ravenfoot.mdl";	// Left foot
	self.idle_sound = "redfield/raven/ravencall.wav";
	self.pain_sound = "redfield/raven/rpain.wav";
	self.sight_sound = "redfield/raven/rsight.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TINY;
	if (self.health < 1) self.health = 55;
	self.gibhealth = -35;
	self.pain_flinch = 35;				// causes pain sound but no pain animation
	self.pain_longanim = FALSE;			// Not able to be stunned with Cursed Blade
	self.blockudeath = TRUE;			// no humanoid death sound
	self.deathstring = " was a meal for the Ravens\n";
	self.attack_offset = '16 0 -8';		// Melee attack offset
	self.th_checkattack = RavenCheckAttack;
	self.th_pain = raven_pain;
	self.th_die = raven_die;

	// Perched and feeding ravens have special idle animation + idle sounds
	if (self.spawnflags & MON_RAVEN_PERCH) {
		self.th_stand = self.th_walk = raven_stand1;
		self.th_run = self.th_missile = raven_wakeup;
	} else if (self.spawnflags & MON_RAVEN_FEED) {
		self.th_stand = self.th_walk = raven_eat1;
		self.th_run = self.th_missile = raven_wakeup;
	} else if (self.spawnflags & MON_RAVEN_FEED && MON_RAVEN_PERCH) {
		self.spawnflags = self.spawnflags - (self.spawnflags & MON_RAVEN_PERCH);
		self.th_stand = self.th_walk = raven_eat1;
		self.th_run = self.th_missile = raven_wakeup;
	} else { // Default Raven setup
		self.th_stand = raven_hover1;
		self.th_walk = raven_glidechoose;
		self.th_run = raven_run1;
		self.th_missile = raven_atk1;
	}

	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	SetDefaultDenizenAttributes(self); // Standard DENIZEN AI
	self.classtype = CT_MONRAVEN;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEFLY;
	monster_start();
};