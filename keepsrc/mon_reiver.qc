// ==============================================================================
// Reiver

// Model by Razumen
// Quake implementation by Seven

// Monster properties:
// Flying monster escaped from hell to torture his enemies with a wide range of abilities

// Uses 4 different attacks:
// - long range: He summons ghosts who chase the player relentlessly
// - long range: He throws homing balls of fire at his enemies (can set the player on fire)
// - near range: He sucks health out of his pitiful enemies into his own body
// - melee range: He rips deep wounds with its sharp claws

// Defend:
// Reivers can summon a floating shield-circle around them which protects them from projectiles

// Try not to be too close to him when his health is low. He will go back to hell with a big BANG.

// Reiverճ can "hide" inside the ground. Waiting for unwary players to break out and devour their lifes.
// Reiverճ can replace and/or support all id1 monsters (except swimming ones :)
// ==============================================================================
$cd id1/models/reiver
$origin 0 0 24
$base base
$skin skin

$frame pose1 

$frame raise1 raise2 raise3 raise4 raise5 raise6 raise7 raise8 raise9 raise10
$frame raise11 raise12 raise13 raise14 raise15 raise16 raise17 raise18 raise19 raise20
$frame raise21 raise22 raise23 raise24

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10
$frame idle11 idle12 idle13

$frame look1 look2 look3 look4 look5 look6 look7 look8 look9 look10
$frame look11 look12 look13 look14

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9 shoot10
$frame shoot11 shoot12 shoot13 shoot14 shoot15 shoot16 shoot17

$frame meele_l1 meele_l2 meele_l3 meele_l4 meele_l5 meele_l6 meele_l7 meele_l8 meele_l9 meele_l10
$frame meele_l11 meele_l12 meele_l13 meele_l14 meele_l15 meele_l16

$frame meele_r1 meele_r2 meele_r3 meele_r4 meele_r5 meele_r6 meele_r7 meele_r8 meele_r9 meele_r10
$frame meele_r11 meele_r12 meele_r13 meele_r14 meele_r15

$frame defend1 defend2 defend3 defend4 defend5 defend6 defend7 defend8 defend9 defend10
$frame defend11 defend12 defend13 defend14 defend15 defend16

$frame scream1 scream2 scream3 scream4 scream5 scream6 scream7

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10
$frame pain11 pain12

$frame death1 death2 death3 death4 death5 death6 death7

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8 deatha9 deatha10
$frame deatha11 deatha12 deatha13 deatha14 deatha15

// flying + homing ghosts
void(entity inflictor, entity attacker, float damage) ghost_followers_pain = {
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 2', '0 0 0', 1);	// Fixme  Placeholder
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin - '0 0 2', '0 0 0', 1);	// Fixme  Placeholder
};

void() ghost_followers_death = {
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 4', '0 0 0', 1);	// Fixme  Placeholder
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 2', '0 0 0', 1);	// Fixme  Placeholder
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin, '0 0 0', 1);		// Fixme  Placeholder
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin - '0 0 2', '0 0 0', 1);	// Fixme  Placeholder
	if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin - '0 0 4', '0 0 0', 1);	// Fixme  Placeholder
	sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);	 			// To abort the fly-sound. Use same channel !!!!
	remove (self);
};

void() ghost_follower_touch = {
	if (other.takedamage) {
		if (!(self.enemy.flags & FL_CLIENT)) {
			T_Damage (other, self, self.owner, 7, NOARMOR);
			sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);	 // To abort the fly-sound. Use same channel !!!!
			remove(self);
			return;
		}
		if (!(other.flags & FL_CLIENT))	return; // flies through other monsters when chasing player
		T_Damage (other, self, self.owner, 7, NOARMOR); // ghost doesn't touch armor	
		sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);	 // To abort the fly-sound. Use same channel !!!!
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 3', '0 0 0', 1);	// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin, '0 0 0', 1);		// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 -3', '0 0 0', 1);	// Fixme  Placeholder
		//ghost_follower_psycho = time + 0.3; // Screen is turning in psycho-mode for a short time
		remove(self);
		return;
	} else return;		// flies through walls
};

void() ghost_follower_think = {
	local vector dir, offang, vec;
	local float zuffi;

	if (self.enemy.health < 1) {
		sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);	// To abort the fly-sound. Use same channel !!!!
		remove (self);
	}

	if (self.attack_finished < time) {
		sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);	 		// To abort the fly-sound. Use same channel !!!!
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 4', '0 0 0', 1);	// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 2', '0 0 0', 1);	// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin, '0 0 0', 1);		// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin - '0 0 2', '0 0 0', 1);	// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin - '0 0 4', '0 0 0', 1);	// Fixme  Placeholder
		remove (self);
	}

	if (self.origin == self.oldorigin)				// when it got stuck somewhere. You never know...
	{
		sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);	 		// To abort the fly-sound. Use same channel !!!!
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 3', '0 0 0', 1);	// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin, '0 0 0', 1);		// Fixme  Placeholder
		if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 -3', '0 0 0', 1);	// Fixme  Placeholder
		T_RadiusDamage (self, self.owner, 7 + 15, self.owner, DAMAGEALL);	
		remove (self);
	}
	self.oldorigin = self.origin;
	self.attack_offset_x = crandom()*60;
	self.attack_offset_y = crandom()*60;
	self.attack_offset_z = crandom()*45;

	// to bring them together short before touching the enemy
	if (vlen((self.enemy.origin + '0 0 16') - self.origin) <= 90) {
		dir = normalize((self.enemy.origin + '0 0 16') - self.origin);
		offang = vectoangles ((self.enemy.origin + '0 0 12') - self.origin);
		traceline ((self.enemy.origin + '0 0 16'), self.origin, FALSE, self);
		if (trace_fraction == 1.0) {
			self.movetype = MOVETYPE_FLYMISSILE;
		} else {
			// player is hiding directly behind a wall. CHEATER :)  Ghost can fly through walls anyway and does the damage !
			sound (self, CHAN_WEAPON, "q15/reiver/ghost_follower_death.wav", 1, ATTN_NORM);			// To abort the fly-sound. Use same channel !!!!
			if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 3', '0 0 0', 1);	// Fixme  Placeholder
			if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin, '0 0 0', 1);		// Fixme  Placeholder
			if (ext_dppart) pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + '0 0 -3', '0 0 0', 1);	// Fixme  Placeholder
			T_Damage (self.enemy, self, self.owner, 7, NOARMOR);	
			remove (self);
		}
	} else {
		dir = normalize((self.enemy.origin + '0 0 16') - (self.origin + self.attack_offset));
		offang = vectoangles ((self.enemy.origin + '0 0 12') - (self.origin + self.attack_offset));
	}
	makevectors (offang);
	
// set homing-missile angles
	vec = normalize (v_forward);
	vec_z = vec_z * -1;
	self.angles = vectoangles(vec); // adjust to always face the enemy (not needed for sprites !)

	self.frame = self.frame + 1;	// standard animation
	if (self.frame >= 2)			
		self.frame = 0;
	zuffi = random();
	if (zuffi < 0.15)
		self.frame = 2;		// bring some variation into animation. Make it look real.
	else if (zuffi < 0.3)
		self.frame = 4;		// bring some variation into animation. Make it look real.

	self.touch = ghost_follower_touch; 
				
	self.velocity = dir * 200;		// adjust speed here
	self.nextthink = time + 0.25;		// inertia of homing effect
	self.think = ghost_follower_think;	
};


void (vector spawn_pos, vector spawn_vel) launch_ghost_follower =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.enemy = self.enemy;
	newmis.movetype = MOVETYPE_NOCLIP; 	// so that it can fly through walls :)
	newmis.solid = SOLID_BBOX;	

	newmis.velocity = spawn_vel * 200;	// adjust speed
	newmis.angles = vectoangles (newmis.velocity);
	
	newmis.glow_color = 75;
	newmis.glow_size = 666;
	
	newmis.frame = 0;
	if (random() < 0.5)
		newmis.alpha = 0.95;
	else
		newmis.alpha = 0.8;
	if (random() < 0.5)
		newmis.scale = 0.4;
	else 
		newmis.scale = 0.51;
	newmis.classname = "ghost_follower";
	newmis.think = ghost_follower_think;	
	newmis.nextthink = time + 0.2;	
	newmis.attack_finished = time + 7;
	setmodel (newmis, "progs/ad171/misc_skull.mdl");
	setsize (newmis, '-8 -8 -8', '8 8 8');
	
	newmis.attack_offset_x = crandom()*10;
	newmis.attack_offset_y = crandom()*10;
	newmis.attack_offset_z = random()*3;

	spawn_pos_x = spawn_pos_x + newmis.attack_offset_x;
	spawn_pos_y = spawn_pos_y + newmis.attack_offset_y;
 	spawn_pos_z = spawn_pos_z + newmis.attack_offset_z;

	newmis.health = 7;
	newmis.takedamage = DAMAGE_AIM;				// make it killable
	newmis.th_pain = ghost_followers_pain;
	newmis.th_die = ghost_followers_death;
	setorigin (newmis, spawn_pos);
	sound (newmis, CHAN_WEAPON, "q15/warlord/homing.wav", 0.5, ATTN_NORM);
};

void()	ghost_followers = {
	local vector offang, org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + v_forward*20 + v_up*2;
	vec = normalize (v_forward); // set homing-missile speed
	vec_z = vec_z * -1;
	launch_ghost_follower (org, vec); 
};

// homing fireball (shootable or not)
void() reiver_fireball_death = {
	if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	R_Exp3 (self.origin);
	remove (self);
};

void() reiver_fireball_touch = {
	if (other == self.owner) return;		// don't explode on owner
	if (other.classgroup == CG_PROJALL) return;		// don't explode on projectiles

	if (other.takedamage == DAMAGE_AIM) {
		spawn_touchblood (self, other,20);
		T_Damage (other, self, self.owner, 20, DAMARMOR);	// default 20
		if (ext_dppart) pointparticles(particleeffectnum("torment_hellrod_explosion"), self.origin, '0 0 0', 1);
	 	R_Exp3 (self.origin);
		// checks if fireball inflame the player
		if (random() <= 0.3) {
			ApplyFireDmg(SUB_entEnemyTarget(), DAMAGE_PYROWRAITH, DAMAGE_PYROWRAITH);
			sound (other, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM); 		// play ignition sound
			sound (other, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
		}
	} else {
		// wall
		T_RadiusDamage (self, self.owner, 20 + 10, other, DAMAGEALL); // don't do radius damage to the other, because all the damage was done in the impact
		if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	 	R_Exp3 (self.origin);
	}
	remove (self);
};

void() reiver_fireball_homing = {
	local vector dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	
	self.movetype = MOVETYPE_FLYMISSILE;
	
	if (self.enemy.health < 1) {
		remove(self);
		return;
	}

	// when it got stuck, remove it
	if (self.origin == self.oldorigin) {
		T_RadiusDamage (self, self.owner, 20 + 10, self.owner, DAMAGEALL);
		R_Exp3(self.origin);
		if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
		remove (self);
		return;
	}
	self.oldorigin = self.origin;

	dir = normalize(vtemp - self.origin);
	if (skill == 3)
		self.velocity = dir * 450;
	else
		self.velocity = dir * 350;
	self.nextthink = time + 0.2;
	self.think = reiver_fireball_homing;	
};


void() reiver_fireball_no_homing = {
	self.movetype = MOVETYPE_FLYMISSILE;

	if (self.enemy.health < 1) { remove(self); return; }

	if (self.attack_finished < time) {
		T_RadiusDamage (self, self.owner, 20 + 10, self.owner, DAMAGEALL);
		R_Exp3(self.origin);
		if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
		remove (self);
		return;
	}

	if (self.origin == self.oldorigin) {
		 // when it got stuck
		T_RadiusDamage (self, self.owner, 20 + 10, self.owner, DAMAGEALL);
		R_Exp3(self.origin);
		if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
		remove (self);
		return;
	}
	self.oldorigin = self.origin;
	self.nextthink = time + 0.2;
	self.think = reiver_fireball_no_homing;	
};

void() reiver_fireball = {
	local entity missile;
	local vector dir, org;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	sound (self, CHAN_WEAPON, "q15/reiver/reiver_fireball_shoot.wav", 1, ATTN_NORM);
	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.scale = 0.9;	
	setmodel (missile, "progs/quoth/fireball.mdl");
	missile.solid = SOLID_BBOX;	
	missile.classname = "Reiver_fireball";
	setsize (missile, '-7 -7 -7', '7 7 7');
	missile.movetype = MOVETYPE_NOCLIP;		// only temporary to move outside of body (see above)
	missile.health = 20;	// default: 20
	missile.takedamage = DAMAGE_AIM;
	missile.th_die = reiver_fireball_death;
	missile.nextthink = time + 0.2;			// to move completely out of shalraths model (to avoid getting stuck)
	makevectors (self.angles);
	org = self.origin + v_forward*25 + v_up*-1;
	setorigin (missile, org );
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.touch = reiver_fireball_touch;
	missile.think = reiver_fireball_homing;
};

void() reiver_idle1;

// IDLE
void()	reiver_look1	=[	$look1,	reiver_look2	] {ai_stand();self.nextthink = time + 0.11;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_idle"), self.origin, self.velocity*10, 1);
	sound (self, CHAN_VOICE, "q15/reiver/raith3.wav", 1, ATTN_IDLE);
};
void()	reiver_look2	=[	$look2,	reiver_look3	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look3	=[	$look3,	reiver_look4	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look4	=[	$look4,	reiver_look5	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look5	=[	$look5,	reiver_look6	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look6	=[	$look6,	reiver_look7	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look7	=[	$look7,	reiver_look8	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look8	=[	$look8,	reiver_look9	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look9	=[	$look9,	reiver_look10	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look10	=[	$look10, reiver_look11	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look11	=[	$look11, reiver_look12	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look12	=[	$look12, reiver_look13	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look13	=[	$look13, reiver_look14	] {ai_stand();self.nextthink = time + 0.11;};
void()	reiver_look14	=[	$look14, reiver_idle1	] {ai_stand();self.nextthink = time + 0.11;};

void()	reiver_idle1	=[	$idle1,	reiver_idle2	] {ai_stand();self.nextthink = time + 0.07; self.th_stand = reiver_idle1; };
void()	reiver_idle2	=[	$idle2,	reiver_idle3	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle3	=[	$idle3,	reiver_idle4	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle4	=[	$idle4,	reiver_idle5	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle5	=[	$idle5,	reiver_idle6	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle6	=[	$idle6,	reiver_idle7	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle7	=[	$idle7,	reiver_idle8	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle8	=[	$idle8,	reiver_idle9	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle9	=[	$idle9,	reiver_idle10	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle10	=[	$idle10, reiver_idle11	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle11	=[	$idle11, reiver_idle12	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle12	=[	$idle12, reiver_idle13	] {ai_stand();self.nextthink = time + 0.07; };
void()	reiver_idle13	=[	$idle13, reiver_idle1	] {ai_stand();self.nextthink = time + 0.07; if (random() < 0.25) reiver_look1(); };

void()	reiver_run1;

void()	reiver_underground1	=[	$raise1,	reiver_underground2	] {ai_stand();self.nextthink = time + 0.08; 
	StopSound(self,CHAN_VOICE); // make him sight sound a little later in this animation !
	sound (self, CHAN_WEAPON, "player/inflame.wav", 1, ATTN_NORM); 	// play flame ignition sound
	self.alpha = 1;};
void() reiver_underground2	=[	$raise2,	reiver_underground3	] {ai_stand();self.nextthink = time + 0.08;};
void() reiver_underground3	=[	$raise3,	reiver_underground4	] {ai_stand();self.nextthink = time + 0.08;
	traceline (self.origin, self.origin - '0 0 66', TRUE, self);
	//if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak_decal"), trace_endpos, '0 0 0', 1);
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground4	=[	$raise4,	reiver_underground5	] {ai_stand();self.nextthink = time + 0.08;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground5	=[	$raise5,	reiver_underground6	] {ai_stand();self.nextthink = time + 0.09;
	sound (self, CHAN_VOICE, "q15/reiver/sight.wav", 1, ATTN_NORM);
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground6	=[	$raise6,	reiver_underground7	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground7	=[	$raise7,	reiver_underground8	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground8	=[	$raise8,	reiver_underground9	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground9	=[	$raise9,	reiver_underground10	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground10	=[	$raise10,	reiver_underground11	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground11	=[	$raise11,	reiver_underground12	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground12	=[	$raise12,	reiver_underground13	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1); };
void()	reiver_underground13	=[	$raise13,	reiver_underground14	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1);};
void()	reiver_underground14	=[	$raise14,	reiver_underground15	] {ai_stand();self.nextthink = time + 0.09;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1);};
void()	reiver_underground15	=[	$raise15,	reiver_underground16	] {ai_stand();self.nextthink = time + 0.08;
	if (ext_dppart) pointparticles(particleeffectnum("reiver_outbreak"), self.origin, '0 0 0', 1);
};
void()	reiver_underground16	=[	$raise16,	reiver_underground17	] {ai_stand();self.nextthink = time + 0.08;};
void()	reiver_underground17	=[	$raise17,	reiver_underground18	] {ai_stand();self.nextthink = time + 0.07; self.origin = self.origin + '0 0 2';};
void()	reiver_underground18	=[	$raise18,	reiver_underground19	] {ai_stand();self.nextthink = time + 0.07; self.origin = self.origin + '0 0 2';};
void()	reiver_underground19	=[	$raise19,	reiver_underground20	] {ai_stand();self.nextthink = time + 0.07; self.origin = self.origin + '0 0 2';};
void()	reiver_underground20	=[	$raise20,	reiver_underground21	] {ai_stand();self.nextthink = time + 0.07;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.origin = self.origin + '0 0 2';
};
void()	reiver_underground21	=[	$raise21,	reiver_underground22	] {ai_stand();self.nextthink = time + 0.05; self.origin = self.origin + '0 0 2'; };
void()	reiver_underground22	=[	$raise22,	reiver_underground23	] {ai_stand();self.nextthink = time + 0.05; self.origin = self.origin + '0 0 2'; };
void()	reiver_underground23	=[	$raise23,	reiver_underground24	] {ai_stand();self.nextthink = time + 0.05;};
void()	reiver_underground24	=[	$raise24,	reiver_run1	] {ai_stand();self.nextthink = time + 0.05;
	self.lefty = 0;				// reset
	self.th_run = reiver_run1;		// reset
    self.th_stand = reiver_idle1;	// reset
};

void()	reiver_wait_underground	=[	$raise1,	reiver_wait_underground	] {ai_stand();
	self.takedamage = DAMAGE_NO;		// during emerging out of underground, reiver is invulnerable
	self.solid = SOLID_NOT;			// in case player uses notarget cheat. He doesnt get stuck on bbox
	self.alpha = -1;			// in case reiver stands ontop of a slim bridge and can be seen beneath it otherwise
	self.lefty = 1;			// so that the shield is not spawned when he breaks out
	self.th_run = reiver_underground1;
};

// Reiver can emerge from underground
void()	reiver_idle_random = {			
	if (random() < 0.4) {
		traceline (self.origin, self.origin - '0 0 77', TRUE, self);
		self.origin_z = trace_endpos_z + 34; // Always align him towards ground beneath him. Reason: Walking monsters are always spawned above the floor and then droptofloor(). Flying monsters dont !! So that breakout animation looks right.
		reiver_wait_underground ();	// underground sneeking
	} else {
		reiver_idle1 (); // regular flying
	}
};

// WALK
void()	reiver_fly1	=[	$idle1,reiver_fly2	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
    self.th_stand = reiver_idle1;	// necessary due to initial random stand function !!
};
void()	reiver_fly2	=[	$idle2,	reiver_fly3	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly3	=[	$idle3,	reiver_fly4	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly4	=[	$idle4,	reiver_fly5	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly5	=[	$idle5,	reiver_fly6	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly6	=[	$idle6,	reiver_fly7	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly7	=[	$idle7,	reiver_fly8	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly8	=[	$idle8,	reiver_fly9	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly9	=[	$idle9,	reiver_fly10	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly10	=[	$idle10,reiver_fly11	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly11	=[	$idle11,reiver_fly12	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly12	=[	$idle12,reiver_fly13	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, self.velocity*10, 1);
};
void()	reiver_fly13	=[	$idle13,reiver_fly1	] {ai_walk(6);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
	if (random() < 0.2) sound (self, CHAN_VOICE, "q15/reiver/raith3.wav", 1, ATTN_IDLE);
};

// RUN
void()	reiver_run1	=[	$idle1,	reiver_run2	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run2	=[	$idle2,	reiver_run3	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run3	=[	$idle3,	reiver_run4	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run4	=[	$idle4,	reiver_run5	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run5	=[	$idle5,	reiver_run6	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run6	=[	$idle6,	reiver_run7	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run7	=[	$idle7,	reiver_run8	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run8	=[	$idle8,	reiver_run9	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run9	=[	$idle9,	reiver_run10	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run10	=[	$idle10,reiver_run11	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run11	=[	$idle11,reiver_run12	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run12	=[	$idle12,reiver_run13	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
};
void()	reiver_run13	=[	$idle13,reiver_run1	] {ai_run(12);self.nextthink = time + 0.07;
	//if (ext_dppart) pointparticles(particleeffectnum("Reiver_fly"), self.origin, '0 0 0', 1);
	if (random() < 0.25) sound (self, CHAN_VOICE, "q15/reiver/run.wav", 1, ATTN_IDLE);
};

// MELEE
void(float scratch_noise) reiver_melee_scratch = {
	local vector delta;
	local float ldmg;

	if (!self.enemy) return;		// removed before stroke

	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 77) return;
		
	ldmg = (random() + random() + random()) * 4;	// default 4
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
	makevectors (self.angles);
	particle (self.origin + v_forward*45 + v_up*-10, '0 0 0', 73, 17);		// spawn a little blood
	if (scratch_noise) {
		sound (self, CHAN_AUTO, "demon/dhit2.wav", 0.6, ATTN_NORM);
		SpawnMeatSpray(self,self.enemy,crandom() * 100); // spawn a little gore
	}
};

/////////   LEFT
void()	reiver_melee_left1 =[	$meele_l1,	reiver_melee_left2	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left2 =[	$meele_l2,	reiver_melee_left3	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left3 =[	$meele_l3,	reiver_melee_left4	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left4 =[	$meele_l4,	reiver_melee_left5	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left5 =[	$meele_l5,	reiver_melee_left6	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (1);};
void()	reiver_melee_left6 =[	$meele_l6,	reiver_melee_left7	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (0);};
void()	reiver_melee_left7 =[	$meele_l7,	reiver_melee_left8	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (0);};
void()	reiver_melee_left8 =[	$meele_l8,	reiver_melee_left9	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (0);};
void()	reiver_melee_left9 =[	$meele_l9,	reiver_melee_left10	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left10 =[	$meele_l10,	reiver_melee_left11	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left11 =[	$meele_l11,	reiver_melee_left12	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left12 =[	$meele_l12,	reiver_melee_left13	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left13 =[	$meele_l13,	reiver_melee_left14	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left14 =[	$meele_l14,	reiver_melee_left15	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left15 =[	$meele_l15,	reiver_melee_left16	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_left16 =[	$meele_l16,	reiver_run1	] {ai_charge(10);self.nextthink = time + 0.07;};

// RIGHT
void()	reiver_melee_right1 =[	$meele_r1,	reiver_melee_right2	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right2 =[	$meele_r2,	reiver_melee_right3	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right3 =[	$meele_r3,	reiver_melee_right4	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right4 =[	$meele_r4,	reiver_melee_right5	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right5 =[	$meele_r5,	reiver_melee_right6	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right6 =[	$meele_r6,	reiver_melee_right7	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right7 =[	$meele_r7,	reiver_melee_right8	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (1);};
void()	reiver_melee_right8 =[	$meele_r8,	reiver_melee_right9	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (0);};
void()	reiver_melee_right9 =[	$meele_r9,	reiver_melee_right10	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (0);};
void()	reiver_melee_right10 =[	$meele_r10,	reiver_melee_right11	] {ai_charge(10);self.nextthink = time + 0.07; reiver_melee_scratch (0);};
void()	reiver_melee_right11 =[	$meele_r11,	reiver_melee_right12	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right12 =[	$meele_r12,	reiver_melee_right13	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right13 =[	$meele_r13,	reiver_melee_right14	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right14 =[	$meele_r14,	reiver_melee_right15	] {ai_charge(10);self.nextthink = time + 0.07;};
void()	reiver_melee_right15 =[	$meele_r15,	reiver_run1	] {ai_charge(10);self.nextthink = time + 0.07;};

void()	reiver_melee = {
	if (self.dodge_finished > time) self.dodge_finished = time;	// remove multi_shield, when in melee fight
	
	if (random() < 0.5)
		reiver_melee_left1();
	else
		reiver_melee_right1();
};	

// RANGED
void(vector ofs, float scal) reiver_hand1 = {
	local vector org;

	makevectors (self.angles);
	org = self.origin + v_forward * ofs_x + v_right * ofs_y + v_up * ofs_z;
	setorigin (self.owner, org);
	self.owner.scale = scal;
};

void(vector ofs, float scal) reiver_hand2 = {
	local vector org;

	makevectors (self.angles);
	org = self.origin + v_forward * ofs_x + v_right * ofs_y + v_up * ofs_z;
	setorigin (self.owner2, org);
	self.owner2.scale = scal;
};

// Vampire (life drain):
void()	life_drain = {
	local vector spot1, spot2;	
	
	spot1 = self.origin + '0 0 12';
	spot2 = self.enemy.origin + self.enemy.view_ofs;

	traceline (spot1, spot2, FALSE, self);
	if (trace_ent != self.enemy) return;		// don't have a clear shot

	T_Damage (self.enemy, self, self, 7, DAMARMOR);	
	self.health = self.health + 7;			// give it to the reiver
	if (self.health > self.max_health) self.health = self.max_health; // max cap
};

void()	life_drain_effect = {
	makevectors (self.enemy.angles);
	local vector dir;
	dir = normalize(self.origin - self.enemy.origin);
	if (ext_dppart) pointparticles(particleeffectnum("reiver_vampire_drain1"), self.enemy.origin + self.enemy.view_ofs + v_up * -8 + v_forward*10, dir*10, 1); // spawn some nice particles which fly from player towards Reiverճ direction to simulate life drain effect 
};

void()	reiver_vampire1	=[	$scream1,	reiver_vampire2	] {ai_face(); self.nextthink = time + 0.08;
	reiver_hand1 ('32 23 1', 0.35);
	reiver_hand2 ('37 -20 2', 0.35);
	sound (self, CHAN_AUTO, "q15/reiver/vampire.wav", 1, ATTN_NORM);};
void()	reiver_vampire2	=[	$scream2,	reiver_vampire3	] {ai_face(); self.nextthink = time + 0.1;
	reiver_hand1 ('34 23 5', 0.5);
	reiver_hand2 ('37 -23 5', 0.5);
	life_drain_effect ();
};
void()	reiver_vampire3	=[	$scream3,	reiver_vampire4	] {ai_face(); self.nextthink = time + 0.12; life_drain();
	reiver_hand1 ('42 27 9', 0.75);
	reiver_hand2 ('42 -27 9', 0.75);
	life_drain_effect ();};
void()	reiver_vampire4	=[	$scream4,	reiver_vampire5	] {ai_face(); self.nextthink = time + 0.17; life_drain();
	reiver_hand1 ('47 31 12', 1);
	reiver_hand2 ('47 -30 11', 1);
	life_drain_effect ();
	sound (self, CHAN_AUTO, "q15/reiver/vampire.wav", 1, ATTN_NORM);
};
void()	reiver_vampire5	=[	$scream5,	reiver_vampire6	] {ai_face(); self.nextthink = time + 0.12; 
	if (skill >= 2) life_drain();
	reiver_hand1 ('45 30 11', 1);
	reiver_hand2 ('45 -29 10', 1);
	life_drain_effect ();
};
void()	reiver_vampire6	=[	$scream6,	reiver_vampire7	] {ai_face(); self.nextthink = time + 0.1;
	reiver_hand1 ('42 25 9', 0.85);
	reiver_hand2 ('42 -24 9', 0.85); 
	if (skill >= 2)
		self.attack_finished = time + 1 + random();
	else
		self.attack_finished = time + 1.5 + random();};
void()	reiver_vampire7	=[	$scream7,	reiver_run1	] {ai_face(); self.nextthink = time + 0.08;
	reiver_hand1 ('40 20 2', 0.7);
	reiver_hand2 ('37 -21 5', 0.7);
};

// Projectiles:
void()	reiver_shoot1	=[	$shoot1,	reiver_shoot2	] {ai_face(); self.nextthink = time + 0.07;
	if (self.projectile_type == 0) { // = fireball
		reiver_hand1 ('32 24 2', 0.35);
		reiver_hand2 ('37 -20 2', 0.35);
	}
};
void()	reiver_shoot2	=[	$shoot2,	reiver_shoot3	] {ai_face(); self.nextthink = time + 0.07;
	if (self.projectile_type == 0) {
		reiver_hand1 ('28 24 5', 0.5);
		reiver_hand2 ('33 -21 5', 0.5);
	}
};
void()	reiver_shoot3	=[	$shoot3,	reiver_shoot4	] {ai_face(); self.nextthink = time + 0.07;
	if (self.projectile_type == 0)	{
		reiver_hand1 ('24 24 8', 0.6);
		reiver_hand2 ('29 -21 8', 0.6);
	}
};
void()	reiver_shoot4	=[	$shoot4,	reiver_shoot5	] {ai_face(); self.nextthink = time + 0.07;
	if (self.projectile_type == 0)	{
		reiver_hand1 ('20 24 14', 0.7);
		reiver_hand2 ('25 -21 14', 0.7);
	}
};
void()	reiver_shoot5	=[	$shoot5,	reiver_shoot6	] {ai_face(); self.nextthink = time + 0.07;
	if (self.projectile_type == 0) {
		reiver_hand1 ('13 26 20', 0.8);
		reiver_hand2 ('17 -23 20', 0.8);
	}
};
void()	reiver_shoot6	=[	$shoot6,	reiver_shoot7	] {ai_face(); self.nextthink = time + 0.08;
	if (self.projectile_type == 0) {
		reiver_hand1 ('9 28 22', 0.8);
		reiver_hand2 ('13 -27 22', 0.8);
	}
};
void()	reiver_shoot7	=[	$shoot7,	reiver_shoot8	] {ai_face(); self.nextthink = time + 0.08;
	if (self.projectile_type == 0)	// = fireball
	{
		reiver_hand1 ('14 23 22', 0.8);
		reiver_hand2 ('18 -23 22', 0.8);
	}
};
void()	reiver_shoot8	=[	$shoot8,	reiver_shoot9	] {ai_face(); self.nextthink = time + 0.08;
	if (self.projectile_type == 0) {
		reiver_hand1 ('23 19 14', 0.8);
		reiver_hand2 ('26 -19 14', 0.8);
	}
};
void()	reiver_shoot9	=[	$shoot9,	reiver_shoot10	] {ai_face(); self.nextthink = time + 0.08;
	if (self.projectile_type == 0) {
		reiver_hand1 ('36 11 5', 0.8);
		reiver_hand2 ('36 -11 5', 0.8);
	}
};
void()	reiver_shoot10	=[	$shoot10, 	reiver_shoot11	] {ai_face(); self.nextthink = time + 0.12; 
	if (self.projectile_type == 0) {
		reiver_hand1 ('46 8 -1', 0.8);
		reiver_hand2 ('46 -8 -1', 0.8);
		reiver_fireball();
	} else {
		ghost_followers(); ghost_followers(); ghost_followers();
	}
};
void()	reiver_shoot11	=[	$shoot11, 	reiver_shoot12	] {ai_face(); self.nextthink = time + 0.12; 
	if (skill >= 2)
		self.attack_finished = time + 1.5 + random();
	else
		self.attack_finished = time + 2 + random();
};
void()	reiver_shoot12	=[	$shoot12, 	reiver_shoot13	] {ai_face(); self.nextthink = time + 0.07;};
void()	reiver_shoot13	=[	$shoot13, 	reiver_shoot14	] {ai_face(); self.nextthink = time + 0.07;};
void()	reiver_shoot14	=[	$shoot14, 	reiver_shoot15	] {ai_face(); self.nextthink = time + 0.07;};
void()	reiver_shoot15	=[	$shoot15, 	reiver_shoot16	] {ai_face(); self.nextthink = time + 0.07;};
void()	reiver_shoot16	=[	$shoot16,	 reiver_shoot17	] {ai_face(); self.nextthink = time + 0.07;};
void()	reiver_shoot17	=[	$shoot17,	 reiver_run1	] {ai_face(); self.nextthink = time + 0.07;};

// is started when enemy is RANGE_NEAR or RANGE_MID
// RANGE_NEAR --> between 120 ... 500
// RANGE_MID  --> between 500 ... 1000
void() reiver_missile =	{					
	local vector spot1, spot2, org, porg;	
	local float r;	
	local entity o, p;

	spot1 = self.origin + '0 0 15';
	spot2 = self.enemy.origin + '0 0 15';
	r = vlen (spot1 - spot2);
	if (r < 250) {
		// start vampire animation (life drain) when Reiver is close to his enemy
		makevectors (self.angles);
		self.owner = spawn();		// right hand
		o = self.owner;
		o.nextthink = (time + 0.85);
		o.think = SUB_Remove;
		o.effects = EF_ADDITIVE | EF_DIMLIGHT;
		o.scale = 0.25;
		o.alpha = 0.725;
		o.colormod = '0.3 1.3 0.3';
		setmodel (o, "progs/q15/reiverhands.spr");
		org = self.origin + v_forward *32 + v_right *23 + v_up *1; 
		setorigin (o, org);
		self.owner2 = spawn();		// left hand
		p = self.owner2;
		p.nextthink = (time + 0.85);
		p.think = SUB_Remove;
		p.effects = EF_ADDITIVE | EF_DIMLIGHT;
		p.scale = 0.25;
		p.alpha = 0.725;
		p.colormod = '0.3 1.3 0.3';
		setmodel (p, "progs/q15/reiverhands.spr");
		porg = self.origin + v_forward *36 + v_right *-20 + v_up *1; 
		setorigin (p, org);
		reiver_vampire1();
	} else {
		// start one of his projectile attacks
		if (random() <= 0.6) {
			self.projectile_type = 0;	// reiver_fireball
			makevectors (self.angles);
			self.owner = spawn();		// right hand
			o = self.owner;
			o.nextthink = (time + 0.75);
			o.think = SUB_Remove;
			o.effects = EF_ADDITIVE | EF_DIMLIGHT;
			o.scale = 0.25;
			o.alpha = 0.666;
			setmodel (o, "progs/q15/reiverhands.spr");
			org = self.origin + v_forward *32 + v_right *23 + v_up *1; 
			setorigin (o, org);
			self.owner2 = spawn();		// left hand
			p = self.owner2;
			p.nextthink = (time + 0.75);
			p.think = SUB_Remove;
			p.effects = EF_ADDITIVE | EF_DIMLIGHT;
			p.scale = 0.25;
			p.alpha = 0.666;
			setmodel (p, "progs/q15/reiverhands.spr");
			porg = self.origin + v_forward *36 + v_right *-20 + v_up *1; 
			setorigin (p, org);
			sound (self, CHAN_AUTO, "q15/reiver/ranged_attack.wav", 1, ATTN_NORM);
		} else {
			self.projectile_type = 1;	// ghost_followers
			sound (self, CHAN_AUTO, "q15/reiver/ranged_attack2.wav", 1, ATTN_NORM);
		}
		reiver_shoot1();
	}
};

// PAIN
void()	reiver_paina1	=[	$defend1,	reiver_paina2	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina2	=[	$defend2,	reiver_paina3	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina3	=[	$defend3,	reiver_paina4	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina4	=[	$defend4,	reiver_paina5	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina5	=[	$defend5,	reiver_paina6	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina6	=[	$defend6,	reiver_paina7	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina7	=[	$defend7,	reiver_paina8	] {ai_face(); self.nextthink = time + 0.08;};
void()	reiver_paina8	=[	$defend8,	reiver_paina9	] {ai_face(); self.nextthink = time + 0.07;};
void()	reiver_paina9	=[	$defend9,	reiver_paina10	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina10	=[	$defend10, 	reiver_paina11	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina11	=[	$defend11, 	reiver_paina12	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina12	=[	$defend12, 	reiver_paina13	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina13	=[	$defend13,	reiver_paina14	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina14	=[	$defend14, 	reiver_paina15	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina15	=[	$defend15, 	reiver_paina16	] {ai_face(); self.nextthink = time + 0.06;};
void()	reiver_paina16	=[	$defend16,	 reiver_run1	] {ai_face(); self.nextthink = time + 0.06;};

void()	reiver_painb1	=[	$pain1,		reiver_painb2	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb2	=[	$pain2,		reiver_painb3	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb3	=[	$pain3,		reiver_painb4	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb4	=[	$pain4,		reiver_painb5	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb5	=[	$pain5,		reiver_painb6	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb6	=[	$pain6,		reiver_painb7	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb7	=[	$pain7,		reiver_painb8	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb8	=[	$pain8,		reiver_painb9	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb9	=[	$pain9,		reiver_painb10	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb10	=[	$pain10, 	reiver_painb11	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb11	=[	$pain11, 	reiver_painb12	] {ai_face(); self.nextthink = time + 0.075;};
void()	reiver_painb12	=[	$pain12, 	reiver_run1	] {ai_face(); self.nextthink = time + 0.075;};

void(entity inflictor, entity attacker, float damage) reiver_pain = {
	// self.in_cocoon_shape = 0;	// remove invulnerability from cocoon shape

	if (self.dodge_finished > time) return;
	if (self.pain_finished > time) return;
	if (random()*60 > damage) return;			// didn't flinch

	if (random() > 0.5) {
		self.pain_finished = time + 1.7;
		sound (self, CHAN_VOICE, "q15/reiver/pain2.wav", 1, ATTN_NORM);
		reiver_paina1 ();
	} else {
		self.pain_finished = time + 1.5;
		sound (self, CHAN_VOICE, "q15/reiver/pain1.wav", 1, ATTN_NORM);
		reiver_painb1 ();
	}
};

// DEATH, let him go back to hell with a big BANG
void() reiver_death_touch = {       
	if (self.flags & FL_ONGROUND) {
		self.solid = SOLID_NOT;
		T_RadiusDamage (self, self, 66, world, DAMAGEALL);	// default 66	
		//if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
		if (ext_dppart) pointparticles(particleeffectnum("rocket_explosion"), self.origin, '0 0 0', 1);
		if (ext_dppart) pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
		R_Exp3(self.origin);
		// self.delete_painskin = 1;	 	 // remove painskin 
		remove (self);
		return;
	} else if (self.velocity == '0 0 0') {
		self.solid = SOLID_NOT;
		T_RadiusDamage (self, self, 66, world, DAMAGEALL);	// default 66		
		//if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
		if (ext_dppart) pointparticles(particleeffectnum("rocket_explosion"), self.origin, '0 0 0', 1);
		if (ext_dppart) pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
		R_Exp3(self.origin);
		// self.delete_painskin = 1;	 	 // remove painskin 
		remove (self);
		return;
	}

	if (self.origin == self.oldorigin)	{
		// when it got stuck somewhere. You never know...
		self.solid = SOLID_NOT;
		T_RadiusDamage (self, self, 66, world, DAMAGEALL);	// default 66		
		//if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
		if (ext_dppart) pointparticles(particleeffectnum("rocket_explosion"), self.origin, '0 0 0', 1);
		if (ext_dppart) pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
		R_Exp3(self.origin);
		remove(self);
		return;
	}
	self.oldorigin = self.origin;
	self.think = reiver_death_touch; 
	self.nextthink = time + 0.001;   
};

void()	reiver_death1	=[$deatha1, reiver_death2] {self.nextthink = time + 0.07;
	self.flags = self.flags - FL_ONGROUND;		// to keep him up a bit
	self.flags = self.flags | FL_FLY;		// to keep him up a bit
};
void()	reiver_death2	=[$deatha2, reiver_death3] {self.nextthink = time + 0.07; self.solid = SOLID_NOT; };
void()	reiver_death3	=[$deatha3, reiver_death4] {self.nextthink = time + 0.07;
	self.flags = self.flags - FL_FLY;		// remove fly ability and let him drop with a 'spin'
	self.velocity_x = -200 + 400*random();
	self.velocity_y = -200 + 400*random();
	self.velocity_z = 100 + 100*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};
void()	reiver_death4	=[$deatha4, reiver_death5] {self.nextthink = time + 0.07;};
void()	reiver_death5	=[$deatha5, reiver_death6] {self.nextthink = time + 0.07;};
void()	reiver_death6	=[$deatha6, reiver_death7] {self.nextthink = time + 0.07;};
void()	reiver_death7	=[$deatha7, reiver_death8] {self.nextthink = time + 0.07;};
void()	reiver_death8	=[$deatha8, reiver_death9] {self.nextthink = time + 0.07;};
void()	reiver_death9	=[$deatha9, reiver_death10] {self.nextthink = time + 0.07;
	reiver_death_touch ();
	return;
};
void()	reiver_death10	=[$deatha10, reiver_death11] {self.nextthink = time + 0.07;};
void()	reiver_death11	=[$deatha11, reiver_death12] {self.nextthink = time + 0.07;};
void()	reiver_death12	=[$deatha12, reiver_death13] {self.nextthink = time + 0.07;};
void()	reiver_death13	=[$deatha13, reiver_death14] {self.nextthink = time + 0.07;};
void()	reiver_death14	=[$deatha14, reiver_death15] {self.nextthink = time + 0.07;};
void()	reiver_death15	=[$deatha15, reiver_death15] {self.nextthink = time + 0.07;};

void() reiver_die = {
	self.dodge_finished = time - 1;		// just to be sure that the shield is gone
	sound (self, CHAN_VOICE, "q15/reiver/death.wav", 1, ATTN_NORM);
//	self.th_pain = SUB_Null;
//	self.th_die = SUB_Null;
	reiver_death1();
};

// Reiverճ multi_shield code:
void () animate_shield = {
	self.shield_finished = time + 0.07;
	self.frame = self.frame + 1;
	if (self.frame >= 20) self.frame = 0;
};

void () reiver_shield_think = {
	if (self.lefty) {
		self.lefty = 0;
		setmodel (self,"progs/q15/reiver_shield.mdl"); 
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		setorigin (self, '0 0 -9');
	}
	if (self.shield_finished < time) animate_shield ();
	
	self.scale = 0.9;	// 1;

	if ((self.owner.dodge_finished > time) && (!self.owner.lefty)) {
		self.alpha = 1;					// show multi_shield
		self.shield_time = 1;
		self.owner.takedamage = DAMAGE_YES; 		// grenades bounces off of Reiver
		self.resist_shells = self.resist_nails = 0.75;
		self.resist_rockets = self.resist_cells = 0.75;
		self.resist_plasma = 0.75;
		self.resist_multi_rockets = 0.75;
		self.resist_lava_nails = 0; // Lava nails pierce armor remember :)
		self.resist_plasma = 0.75;
		self.resist_bolts = 0.75;
		self.resist_poison = self.resist_acid = 0.75;
		self.reflectnails = TRUE;		// Reflect nail projectiles
	} else {
		self.alpha = 0.0001;				// hide multi_shield
		self.shield_time = 0;
		self.owner.takedamage = DAMAGE_AIM; 		// regular behaviour
		Resist_ChangeType(self,-1);
		self.reflectnails = FALSE;		// Reflect nail projectiles
	}

	// spawn multi_shield randomly when hunting an enemy (even when not got shot)
	if ((self.owner.enemy != world) && (self.shield_time == 0) && (!self.owner.lefty))	 {
		if (random() < 0.0009) self.owner.dodge_finished = time + 2 + random();
	}
	
	if (self.owner.health < 0) { remove (self); return; }

	setorigin (self, self.owner.origin +  '0 0 -9');
	self.think = reiver_shield_think;
	self.nextthink = time + 0.01;
};

void() monster_reiver_precache = {
	precache_model("progs/q15/reiver.mdl");
	precache_model("progs/quoth/fireball.mdl");
	precache_model("progs/ad171/misc_skull.mdl");
	precache_model("progs/q15/reiver_shield.mdl");
	precache_model("progs/q15/reiverhands.spr");
	precache_model("progs/q15/reiver_shield.mdl");
	precache_sound("demon/dhit2.wav");
	precache_sound("q15/warlord/homing.wav");
	precache_sound("q15/reiver/ghost_follower_death.wav");
	precache_sound("q15/reiver/reiver_fireball_shoot.wav");
	precache_sound("q15/reiver/raith3.wav");
	precache_sound("q15/reiver/pain1.wav");
	precache_sound("q15/reiver/pain2.wav");
	precache_sound("q15/reiver/ranged_attack.wav");
	precache_sound("q15/reiver/ranged_attack2.wav");
	precache_sound("q15/reiver/run.wav");
	precache_sound("q15/reiver/sight.wav");
	precache_sound("q15/reiver/death.wav");
	precache_sound("q15/reiver/vampire.wav");
	precache_sound("player/inflame.wav");
	precache_sound("zombie/corpse_fire.wav");
	if (ext_dppart) particleeffectnum("double_shotgun_muzzleflash");
	if (ext_dppart) particleeffectnum("reiver_vampire_drain1");
};

//QUAKED monster_reiver (1 0 0) (-16 -16 -24) (16 16 24) Ambush
void() monster_reiver = {
	local entity reiver_shield;
	
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/q15/reiver.mdl";
	self.solid = SOLID_NOT;					// No interaction with world
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_FISH;
	if (self.health < 1) self.health = 200;
	self.gibhealth = -40;
	self.gibbed = FALSE;
	self.th_stand = reiver_idle1;
	self.th_walk = reiver_fly1;
	self.th_run = reiver_run1;
	self.th_missile = reiver_missile;
	self.th_melee = reiver_melee;		
	self.th_pain = reiver_pain;
	self.th_die = reiver_die;
	reiver_shield = spawn();
	reiver_shield.solid = SOLID_NOT;
	reiver_shield.movetype = MOVETYPE_NOCLIP;	
	reiver_shield.owner = self;
	reiver_shield.avelocity = '0 77 0';
	reiver_shield.frame = 0;
	reiver_shield.lefty = 1;
	reiver_shield.think = reiver_shield_think;
	reiver_shield.nextthink = time;
	if (checkbuiltin(checkbuiltin) && checkbuiltin(setattachment)) setattachment(reiver_shield, self, "test");
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.deathstring == "")  self.deathstring = " was terrified by a Reiver\n\n";
	self.classtype = CT_MONREIVER;
	self.classgroup = CG_KNIGHT;
	self.classmove = MON_MOVEFLY;
	monster_start();	
};