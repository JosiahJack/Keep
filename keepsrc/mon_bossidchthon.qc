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
// Function count: 117
//
// Implements: Chthon (vanilla version)
//
// Description:
// A giant lava being who's presence is only visible as a torso jutting out of
// a pool of lava.  Can only be killed by using the environment to electrocute
// him with a bolt of lightning.
//=============================================================================

$frame rise1 rise2 rise3 rise4 rise5 rise6 rise7 rise8 rise9 rise10
$frame rise11 rise12 rise13 rise14 rise15 rise16 rise17 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8
$frame walk9 walk10 walk11 walk12 walk13 walk14 walk15
$frame walk16 walk17 walk18 walk19 walk20 walk21 walk22
$frame walk23 walk24 walk25 walk26 walk27 walk28 walk29 walk30 walk31

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15
$frame attack16 attack17 attack18 attack19 attack20 attack21 attack22
$frame attack23

$frame shocka1 shocka2 shocka3 shocka4 shocka5 shocka6 shocka7 shocka8
$frame shocka9 shocka10 

$frame shockb1 shockb2 shockb3 shockb4 shockb5 shockb6

$frame shockc1 shockc2 shockc3 shockc4 shockc5 shockc6 shockc7 shockc8 
$frame shockc9 shockc10

entity	le1, le2;
float	lightning_end;

void() idchthon_tracking = { // [FUNCTION]
	// Find a player
	if (!self.enemy) {
		self.enemy = find(world, classname, "player");
		if (!self.enemy) self.enemy = world;
	}
	
	// Check for any no combat conditions
	if (Invisible(self.enemy)) self.enemy = world;
	else if (frame_pause()) self.enemy = world;
	else if (self.enemy.health < 1) self.enemy = world;
	if (self.enemy) self.th_missile();
};

void() idchthon_idle1	= [	$walk1, idchthon_idle2 ] { idchthon_tracking(); }; // [FUNCTION]
void() idchthon_idle2	= [	$walk2, idchthon_idle3 ] {}; // [FUNCTION]
void() idchthon_idle3	= [	$walk3, idchthon_idle4 ] {}; // [FUNCTION]
void() idchthon_idle4	= [	$walk4, idchthon_idle5 ] {}; // [FUNCTION]
void() idchthon_idle5	= [	$walk5, idchthon_idle6 ] {}; // [FUNCTION]
void() idchthon_idle6	= [	$walk6, idchthon_idle7 ] {}; // [FUNCTION]
void() idchthon_idle7	= [	$walk7, idchthon_idle8 ] {}; // [FUNCTION]
void() idchthon_idle8	= [	$walk8, idchthon_idle9 ] {}; // [FUNCTION]
void() idchthon_idle9	= [	$walk9, idchthon_idle10 ] {}; // [FUNCTION]
void() idchthon_idle10	= [	$walk10, idchthon_idle11 ] { idchthon_tracking(); }; // [FUNCTION]
void() idchthon_idle11	= [	$walk11, idchthon_idle12 ] {}; // [FUNCTION]
void() idchthon_idle12	= [	$walk12, idchthon_idle13 ] {}; // [FUNCTION]
void() idchthon_idle13	= [	$walk13, idchthon_idle14 ] {}; // [FUNCTION]
void() idchthon_idle14	= [	$walk14, idchthon_idle15 ] {}; // [FUNCTION]
void() idchthon_idle15	= [	$walk15, idchthon_idle16 ] {}; // [FUNCTION]
void() idchthon_idle16	= [	$walk16, idchthon_idle17 ] {}; // [FUNCTION]
void() idchthon_idle17	= [	$walk17, idchthon_idle18 ] {}; // [FUNCTION]
void() idchthon_idle18	= [	$walk18, idchthon_idle19 ] {}; // [FUNCTION]
void() idchthon_idle19	= [	$walk19, idchthon_idle20 ] {}; // [FUNCTION]
void() idchthon_idle20	= [	$walk20, idchthon_idle21 ] {}; // [FUNCTION]
void() idchthon_idle21	= [	$walk21, idchthon_idle22 ] { idchthon_tracking(); }; // [FUNCTION]
void() idchthon_idle22	= [	$walk22, idchthon_idle23 ] {}; // [FUNCTION]
void() idchthon_idle23	= [	$walk23, idchthon_idle24 ] {}; // [FUNCTION]
void() idchthon_idle24	= [	$walk24, idchthon_idle25 ] {}; // [FUNCTION]
void() idchthon_idle25	= [	$walk25, idchthon_idle26 ] {}; // [FUNCTION]
void() idchthon_idle26	= [	$walk26, idchthon_idle27 ] {}; // [FUNCTION]
void() idchthon_idle27	= [	$walk27, idchthon_idle28 ] {}; // [FUNCTION]
void() idchthon_idle28	= [	$walk28, idchthon_idle29 ] {}; // [FUNCTION]
void() idchthon_idle29	= [	$walk29, idchthon_idle30 ] {}; // [FUNCTION]
void() idchthon_idle30	= [	$walk30, idchthon_idle31 ] {}; // [FUNCTION]
void() idchthon_idle31	= [	$walk31, idchthon_idle1 ] { idchthon_tracking(); }; // [FUNCTION]

void(vector orgofs) idchthon_missile = { // [FUNCTION]
	local vector offang, org, vec, dir, mdest, avel;
	local float projlen;

	// No enemy, player dead or intermission/cinematic?
	if (!self.enemy || self.enemy.health < 1 || cinematic_running > 0 || cutscene > 0) {
		self.th_stand();
		return;
	}
	
	sound(self,CHAN_WEAPON,"ad171/chthon/attack1.wav",1,ATTN_NORM);
	offang = vectoangles (self.enemy.origin - self.origin);	
	makevectors(offang);
	org = self.origin + attack_vector(orgofs);
	
	// Skill level adjustment (easy=250, normal=300, hard=350, nm=400)
	self.attack_speed = SPEED_LAVABALL + (skill*SPEED_LAVASKILL);
	
	// Lead the missile on hard mode (This formula is not perfect) 
	// There are plenty of missiles that go in strange directions, 
	// especially if the player strafes a lot from side to side.
	if (skill > SKILL_NORMAL) {
		projlen = vlen(self.enemy.origin - org) / self.attack_speed;
		vec = self.enemy.velocity;
		vec_z = 0;
		mdest = self.enemy.origin + projlen * vec;		
	}
	else mdest = self.enemy.origin;
	
	dir = normalize (mdest - org);
	avel = vecrand(100,200,FALSE);
	launch_projectile(org,dir,avel,CT_PROJ_LAVA,self.attack_speed);
};

void() idchthon_face = { // [FUNCTION]
	// Find a player
	if (!self.enemy) {
		self.enemy = find(world, classname, "player");
		if (!self.enemy) self.enemy = world;
	}
	
	// Check for any no combat conditions
	if (Invisible(self.enemy)) self.enemy = world;
	else if (cinematic_running > 0 || cutscene > 0) self.enemy = world;
	else if (self.enemy.health < 1) self.enemy = world;
	if (self.enemy) ai_face();
};

void() idchthon_missile1	= [	$attack1, idchthon_missile2 ] { idchthon_face(); };
void() idchthon_missile2	= [	$attack2, idchthon_missile3 ] { idchthon_face(); };
void() idchthon_missile3	= [	$attack3, idchthon_missile4 ] { idchthon_face(); };
void() idchthon_missile4	= [	$attack4, idchthon_missile5 ] { idchthon_face(); };
void() idchthon_missile5	= [	$attack5, idchthon_missile6 ] { idchthon_face(); };
void() idchthon_missile6	= [	$attack6, idchthon_missile7 ] { idchthon_face(); };
void() idchthon_missile7	= [	$attack7, idchthon_missile8 ] { idchthon_face(); };
void() idchthon_missile8	= [	$attack8, idchthon_missile9 ] { idchthon_face(); };
void() idchthon_missile9	= [	$attack9, idchthon_missile10 ] { idchthon_missile('100 100 200'); };
void() idchthon_missile10	= [	$attack10, idchthon_missile11 ] { idchthon_face(); };
void() idchthon_missile11	= [	$attack11, idchthon_missile12 ] { idchthon_face(); };
void() idchthon_missile12	= [	$attack12, idchthon_missile13 ] { idchthon_face(); };
void() idchthon_missile13	= [	$attack13, idchthon_missile14 ] { idchthon_face(); };
void() idchthon_missile14	= [	$attack14, idchthon_missile15 ] { idchthon_face(); };
void() idchthon_missile15	= [	$attack15, idchthon_missile16 ] { idchthon_face(); };
void() idchthon_missile16	= [	$attack16, idchthon_missile17 ] { idchthon_face(); };
void() idchthon_missile17	= [	$attack17, idchthon_missile18 ] { idchthon_face(); };
void() idchthon_missile18	= [	$attack18, idchthon_missile19 ] { idchthon_face(); };
void() idchthon_missile19	= [	$attack19, idchthon_missile20 ] { idchthon_face(); };
void() idchthon_missile20	= [	$attack20, idchthon_missile21 ] { idchthon_missile('100 -100 200'); };
void() idchthon_missile21	= [	$attack21, idchthon_missile22 ] { idchthon_face(); };
void() idchthon_missile22	= [	$attack22, idchthon_missile23 ] { idchthon_face(); };
void() idchthon_missile23	= [	$attack23, idchthon_missile1 ] { idchthon_face(); };

void() idchthon_rise1	= [	$rise1, idchthon_rise2 ] {};
void() idchthon_rise2	= [	$rise2, idchthon_rise3 ] { sound(self,CHAN_VOICE, self.sight_sound,1,ATTN_NORM); };
void() idchthon_rise3	= [	$rise3, idchthon_rise4 ] {};
void() idchthon_rise4	= [	$rise4, idchthon_rise5 ] { ai_face(); };
void() idchthon_rise5	= [	$rise5, idchthon_rise6 ] {};
void() idchthon_rise6	= [	$rise6, idchthon_rise7 ] { ai_face(); };
void() idchthon_rise7	= [	$rise7, idchthon_rise8 ] {};
void() idchthon_rise8	= [	$rise8, idchthon_rise9 ] { ai_face(); };
void() idchthon_rise9	= [	$rise9, idchthon_rise10 ] {};
void() idchthon_rise10	= [	$rise10, idchthon_rise11 ] { ai_face(); };
void() idchthon_rise11	= [	$rise11, idchthon_rise12 ] {};
void() idchthon_rise12	= [	$rise12, idchthon_rise13 ] { ai_face(); };
void() idchthon_rise13	= [	$rise13, idchthon_rise14 ] {};
void() idchthon_rise14	= [	$rise14, idchthon_rise15 ] { ai_face(); };
void() idchthon_rise15	= [	$rise15, idchthon_rise16 ] {};
void() idchthon_rise16	= [	$rise16, idchthon_rise17 ] { ai_face(); };
void() idchthon_rise17	= [	$rise17, idchthon_missile1 ] {};

void() idchthon_awake = {
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_NO;
	self.velocity = '0 0 0';
	setmodel(self, self.mdl);					// Setup model
	setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	if (self.health < 1) {
		if (skill == SKILL_EASY) self.health = 1;
		else self.health = 3;
		self.lefty = 1;
	}

	if (self.lefty < 1) self.lefty = 1;
	self.enemy = activator;

	// DP particle spark and smoke effect to Chthon 
	// original idea by Seven, green version added later by me
	if (ext_dppart) self.traileffectnum = particleeffectnum(self.dpp_name);
	Tent_LavaSplash(self.origin,0,"ad171/chthon/lavasplash.wav");
	idchthon_rise1();
};

void() idchthon_shocka1 = [	$shocka1, idchthon_shocka2 ] {};
void() idchthon_shocka2 = [	$shocka2, idchthon_shocka3 ] {};
void() idchthon_shocka3 = [	$shocka3, idchthon_shocka4 ] {};
void() idchthon_shocka4 = [	$shocka4, idchthon_shocka5 ] {};
void() idchthon_shocka5 = [	$shocka5, idchthon_shocka6 ] {};
void() idchthon_shocka6 = [	$shocka6, idchthon_shocka7 ] {};
void() idchthon_shocka7 = [	$shocka7, idchthon_shocka8 ] {};
void() idchthon_shocka8 = [	$shocka8, idchthon_shocka9 ] {};
void() idchthon_shocka9 = [	$shocka9, idchthon_shocka10 ] {};
void() idchthon_shocka10 = [	$shocka10, idchthon_missile1 ] {};

void() idchthon_shockb1 = [	$shockb1, idchthon_shockb2 ] {};
void() idchthon_shockb2 = [	$shockb2, idchthon_shockb3 ] {};
void() idchthon_shockb3 = [	$shockb3, idchthon_shockb4 ] {};
void() idchthon_shockb4 = [	$shockb4, idchthon_shockb5 ] {};
void() idchthon_shockb5 = [	$shockb5, idchthon_shockb6 ] {};
void() idchthon_shockb6 = [	$shockb6, idchthon_shockb7 ] {};
void() idchthon_shockb7 = [	$shockb1, idchthon_shockb8 ] {};
void() idchthon_shockb8 = [	$shockb2, idchthon_shockb9 ] {};
void() idchthon_shockb9 = [	$shockb3, idchthon_shockb10 ] {};
void() idchthon_shockb10 = [	$shockb4, idchthon_missile1 ] {};

void() idchthon_shockc1 = [	$shockc1, idchthon_shockc2 ] {};
void() idchthon_shockc2 = [	$shockc2, idchthon_shockc3 ] {};
void() idchthon_shockc3 = [	$shockc3, idchthon_shockc4 ] {};
void() idchthon_shockc4 = [	$shockc4, idchthon_shockc5 ] {};
void() idchthon_shockc5 = [	$shockc5, idchthon_shockc6 ] {};
void() idchthon_shockc6 = [	$shockc6, idchthon_shockc7 ] {};
void() idchthon_shockc7 = [	$shockc7, idchthon_shockc8 ] {};
void() idchthon_shockc8 = [	$shockc8, idchthon_shockc9 ] {};
void() idchthon_shockc9 = [	$shockc9, idchthon_shockc10 ] {};
void() idchthon_shockc10 = [	$shockc10, idchthon_death1 ] {};

void() lightning_fire = { // [FUNCTION]
	local vector p1, p2;
	
	// done here, put the terminals back up
	if (time >= lightning_end) {
		self = le1;
		func_door_go_down();
		self = le2;
		func_door_go_down();
		return;
	}
	
	p1 = (le1.mins + le1.maxs) * 0.5;
	p1_z = le1.absmin_z - 16;
	
	p2 = (le2.mins + le2.maxs) * 0.5;
	p2_z = le2.absmin_z - 16;
	
	// compensate for length of bolt
	p2 = p2 - normalize(p2-p1)*100;

	self.nextthink = time + 0.1;
	self.think = lightning_fire;

	WriteByte (MSG_ALL, SVC_TEMPENTITY);
	WriteByte (MSG_ALL, TE_LIGHTNING3);
	WriteEntity (MSG_ALL, world);
	WriteCoord (MSG_ALL, p1_x);
	WriteCoord (MSG_ALL, p1_y);
	WriteCoord (MSG_ALL, p1_z);
	WriteCoord (MSG_ALL, p2_x);
	WriteCoord (MSG_ALL, p2_y);
	WriteCoord (MSG_ALL, p2_z);
};

void() lightning_use = { // [FUNCTION]
	if (lightning_end >= time + 1) return;

	le1 = find( world, target, "lightning");
	le2 = find( le1, target, "lightning");
	if (!le1 || !le2) {
		dprint ("\b[CHTHON]\b missing lightning targets\n");
		return;
	}
	
	// Check for lightning block alignment
	if ((le1.state != STATE_TOP && le1.state != STATE_BOTTOM) || (le2.state != STATE_TOP && le2.state != STATE_BOTTOM) || (le1.state != le2.state) ) { return; }

	// don't let the electrodes go back up until the bolt is done
	le1.nextthink = -1;
	le2.nextthink = -1;
	lightning_end = time + 1;
	sound(self,CHAN_VOICE, "misc/power.wav",1,ATTN_NORM);  // vanilla id1 sound
	lightning_fire();		
	self = find (world, classname, "monster_boss");
	if (!self) return;

	self.enemy = activator;
	if (le1.state == STATE_TOP && self.health > 0) {
		sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
		self.health = self.health - self.lefty; // advance the boss pain if down
		if (self.health >= 2) idchthon_shocka1();
		else if (self.health == 1) idchthon_shockb1();
		else if (self.health == 0) idchthon_shockc1();
	}	
};

void() idchthon_death1 = [$death1, idchthon_death2] {
sound(self,CHAN_VOICE, "ad171/chthon/death1.wav",1,ATTN_NORM); };
void() idchthon_death2 = [$death2, idchthon_death3] {};
void() idchthon_death3 = [$death3, idchthon_death4] {};
void() idchthon_death4 = [$death4, idchthon_death5] {};
void() idchthon_death5 = [$death5, idchthon_death6] {};
void() idchthon_death6 = [$death6, idchthon_death7] {};
void() idchthon_death7 = [$death7, idchthon_death8] {};
void() idchthon_death8 = [$death8, boss_death9] {};
void() boss_death9 = [$death9, boss_death10] {
	Tent_LavaSplash(self.origin,0,"ad171/chthon/lavasplash.wav");
};

void() boss_death10 = [$death9, SUB_Null] { // No plans to support map hacks anymore, function name changed.  Aaahh, nope.  Let the hacks live. -Qmaster
	AddToKills(self,self.enemy);
	SUB_UseTargets();
	entity_hide(self);
};

// QUAKED monster_boss (1 0 0) (-128 -128 -24) (128 128 256)
void() monster_boss = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/ad171/mon_bosschthon.mdl";
	self.pain_sound = "ad171/chthon/pain1.wav";
	self.sight_sound = "ad171/chthon/sight1.wav"; // Rise from lava roar + splash
	self.solid = SOLID_NOT;			// No interaction with world
	self.movetype = MOVETYPE_NONE;	// Static item, no movement
	if (self.bboxtype < 1) {
		self.bbmins = '-80 -80 -24';	// Use to be 128 square, reduced size to help with radius/splash damage being more effective
		self.bbmaxs = '80 80 256';
		self.bboxtype = BBOX_CUSTOM;
	}
	self.bossflag = TRUE;			// Boss flag (like FL_MONSTER)
	self.health = 3;
	self.takedamage = DAMAGE_NO;	// Cannot be damaged
	self.bouncegrenade = TRUE;		// Grenades bounce off!
	self.dpp_name = "TR_BOSSCHTHON";// Lava smoke and sparks
	self.yaw_speed = 20;			// Fast turner
	Resist_ChangeType(self,1); // Always reset Ammo Resistance to be consistent
	self.reflectnails = TRUE;		// Reflect nail projectiles
	self.reflectlightning = TRUE;
	self.reflectplasma = TRUE;
	self.reflectaxe = TRUE;			// Prevent axe damage
	self.th_stand = idchthon_idle1;
	self.th_walk = idchthon_idle1;
	self.th_run = idchthon_idle1;
	self.th_missile = idchthon_missile1;
	if (self.deathstring == "") self.deathstring = " was blown apart by Chthon\n";
	self.classtype = CT_MONIDCHTHON;
	self.classgroup = CG_BOSS;
	self.th_stand = self.th_walk = self.th_run = SUB_Null;
	self.th_missile = self.th_die = SUB_Null;
	self.th_pain = SUB_Null_pain;
	monster_start();
	if (self.targetname) self.use = idchthon_awake;
	else idchthon_awake();
};

//QUAKED event_lightning (0 1 1) (-16 -16 -16) (16 16 16) x
// Just for boss level. Used for killing Cthon.
void() event_lightning = { self.use = lightning_use; }; // [ENTITY]