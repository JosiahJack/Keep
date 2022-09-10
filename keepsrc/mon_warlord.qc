//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Seven, Dawn of Darkness
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
// Function count: 259
//
// Implements: Warlord
//
// Description:
// A knight with a shield, similar in strength to a death knight.
//
// Model from: Dawn of Darkness Q2-TC (captain.md2)
// Quake implementation by Seven
//
// Additional features:
// - can dodge/duck in several animations
// - can throw grenades/multi-grenades, standard Hellknight projectiles and
//   homing projectiles
// - can perform shield-ram-attack which throws the player back
// - can go into immune state
//=============================================================================

$cd id1/models/warlord
$origin 0 0 24
$base base
$skin skin
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17 stand18 stand19 stand20
$frame stand21 stand22 stand23 stand24 stand25 stand26 stand27 stand28 stand29 stand30
$frame stand31 stand32 stand33 stand34 stand35 stand36 stand37 stand38 stand39 stand40
$frame stand41 stand42
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 
$frame run1 run2 run3 run4 run5 run6 run7 run8
$frame pain1 pain2 pain3 pain4 pain5
$frame painb1 painb2 painb3 painb4
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9
$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16
$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14
$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13
$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6
$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11
$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 
$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11
$frame throw1 throw2 throw3 throw4 throw5 throw6 throw7 throw8 throw9 throw10		// neue animation "throw"
$frame throw11 throw12 throw13 throw14 throw15 throw16 throw17 throw18 throw19 throw20
$frame throw21 throw22 throw23 throw24 throw25 throw26 throw27 throw28 throw29 throw30
$frame throw31 throw32 throw33
$frame block1 block2 block3 block4 block5 block6	// neue animation "block"
$frame dodge1 dodge2 dodge3 dodge4 dodge5		// neue animation "dodge"
$frame duck1 duck2 duck3 duck4 duck5 duck6		// neue animation "duck"
$frame shdeath1 shdeath2 shdeath3 shdeath4 shdeath5 shdeath6 shdeath7 shdeath8 shdeath9
$frame shdeath10 shdeath11 shdeath12
$frame naildth1 naildth2 naildth3 naildth4 naildth5 naildth6 naildth7 naildth8 naildth9
$frame naildth10 naildth11 naildth12 naildth13 naildth14 naildth15 naildth16 naildth17 naildth18 naildth19

void() hknight2_char_a1;
void() hknight2_run1;

void(float offset) hknight2_shot = {
	local vector offang, org, vec;

	if (!self.enemy) return;
	if (self.health < 1) return;	

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	makevectors(offang);
	org = self.origin + self.mins + self.size*0.5 + v_up * 5 + v_forward * 20;
	// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	self.attack_speed = 300;
	launch_projectile(org,vec,NO_SPIN,CT_PROJ_HKN2,self.attack_speed);
	sound(self,CHAN_WEAPON,"q15/warlord/attack1.wav",1,ATTN_NORM);
};

void()	hknight2_stand1	= [	$stand1,	hknight2_stand2	] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand2	= [	$stand2,	hknight2_stand3	] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand3	= [	$stand3,	hknight2_stand4	] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand4	= [	$stand4,	hknight2_stand5	] { ai_stand(); self.nextthink = time + 0.06; }; // Mitte
void()	hknight2_stand5	= [	$stand5,	hknight2_stand6	] { ai_stand(); self.nextthink = time + 0.06; if (random() < 0.2) sound(self,CHAN_VOICE, "q15/warlord/growl.wav",1,ATTN_NORM); };
void()	hknight2_stand6	= [	$stand6,	hknight2_stand7	] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand7	= [	$stand7,	hknight2_stand8	] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand8	= [	$stand8,	hknight2_stand9	] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand9	= [	$stand9,	hknight2_stand10] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand10= [	$stand10,	hknight2_stand11] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand11= [	$stand11,	hknight2_stand12] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand12= [	$stand12,	hknight2_stand13] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand13= [	$stand13,	hknight2_stand14] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand14= [	$stand14,	hknight2_stand15] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand15= [	$stand15,	hknight2_stand16] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand16= [	$stand16,	hknight2_stand17] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand17= [	$stand17,	hknight2_stand18] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand18= [	$stand18,	hknight2_stand19] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand19= [	$stand19,	hknight2_stand20] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand20= [	$stand20,	hknight2_stand21] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand21= [	$stand21,	hknight2_stand22] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand22= [	$stand22,	hknight2_stand23] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand23= [	$stand23,	hknight2_stand24] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand24= [	$stand24,	hknight2_stand25] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand25= [	$stand25,	hknight2_stand26] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand26= [	$stand26,	hknight2_stand27] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand27= [	$stand27,	hknight2_stand28] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand28= [	$stand28,	hknight2_stand29] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand29= [	$stand29,	hknight2_stand30] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand30= [	$stand30,	hknight2_stand31] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand31= [	$stand31,	hknight2_stand32] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand32= [	$stand32,	hknight2_stand33] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand33= [	$stand33,	hknight2_stand34] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand34= [	$stand34,	hknight2_stand35] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand35= [	$stand35,	hknight2_stand36] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand36= [	$stand36,	hknight2_stand37] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand37= [	$stand37,	hknight2_stand38] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand38= [	$stand38,	hknight2_stand39] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand39= [	$stand39,	hknight2_stand40] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand40= [	$stand40,	hknight2_stand41] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand41= [	$stand41,	hknight2_stand42] { ai_stand(); self.nextthink = time + 0.06; };
void()	hknight2_stand42= [	$stand42,	hknight2_stand1]  { ai_stand(); self.nextthink = time + 0.06; };

void()	hknight2_walk1	= [	$walk1,		hknight2_walk2	] { if (random() < 0.11) sound(self,CHAN_VOICE, "q15/warlord/growl.wav",1,ATTN_NORM); ai_walk(2); };
void()	hknight2_walk2	= [	$walk2,		hknight2_walk3	] { ai_walk(4); };
void()	hknight2_walk3	= [	$walk3,		hknight2_walk4	] { ai_walk(5); };
void()	hknight2_walk4	= [	$walk4,		hknight2_walk5	] { ai_walk(4); monster_footstep(FALSE); };
void()	hknight2_walk5	= [	$walk5,		hknight2_walk6	] { ai_walk(4); };
void()	hknight2_walk6	= [	$walk6,		hknight2_walk7	] { ai_walk(5); };
void()	hknight2_walk7	= [	$walk7,		hknight2_walk8	] { ai_walk(5); };
void()	hknight2_walk8	= [	$walk8,		hknight2_walk9	] { ai_walk(4); };
void()	hknight2_walk9	= [	$walk9,		hknight2_walk10	] { ai_walk(5); };
void()	hknight2_walk10	= [	$walk10,	hknight2_walk11	] { ai_walk(4); monster_footstep(FALSE); };
void()	hknight2_walk11	= [	$walk11,	hknight2_walk12	] { ai_walk(5); };
void()	hknight2_walk12	= [	$walk12,	hknight2_walk1	] { ai_walk(4); };

void()	hknight2_run1	= [	$run1,		hknight2_run2	] { if (random() < 0.1) sound(self,CHAN_VOICE, "drake/archer/growl2.wav",1,ATTN_NORM); ai_run(20); CheckForCharge_boss(30,80,hknight2_char_a1); };
void()	hknight2_run2	= [	$run2,		hknight2_run3	] { ai_run(25); monster_footstep(FALSE); };
void()	hknight2_run3	= [	$run3,		hknight2_run4	] { ai_run(18); };
void()	hknight2_run4	= [	$run4,		hknight2_run5	] { ai_run(16); };
void()	hknight2_run5	= [	$run5,		hknight2_run6	] { ai_run(18); };
void()	hknight2_run6	= [	$run6,		hknight2_run7	] { ai_run(25); monster_footstep(FALSE); };
void()	hknight2_run7	= [	$run7,		hknight2_run8	] { ai_run(18); };
void()	hknight2_run8	= [	$run8,		hknight2_run1	] { ai_run(13); };

void()	hknight2_pain1	= [	$pain1,		hknight2_pain2	] { sound(self,CHAN_VOICE, "q15/warlord/pain2.wav",1,ATTN_NORM); };
void()	hknight2_pain2	= [	$pain2,		hknight2_pain3	] {};
void()	hknight2_pain3	= [	$pain3,		hknight2_pain4	] {};
void()	hknight2_pain4	= [	$pain4,		hknight2_pain5	] {};
void()	hknight2_pain5	= [	$pain5,		hknight2_run1	] {};

void()	hknight2_painb1	= [	$painb1,	hknight2_painb2	] { sound(self,CHAN_VOICE, "q15/warlord/pain1.wav",1,ATTN_NORM); };
void()	hknight2_painb2	= [	$painb2,	hknight2_painb3	] {};
void()	hknight2_painb3	= [	$painb3,	hknight2_painb4	] {};
void()	hknight2_painb4	= [	$painb4,	hknight2_run1	] {};

void()	hknight2_die1	= [	$death1,	hknight2_die2	] { self.nextthink = time + 0.12; };
void()	hknight2_die2	= [	$death2,	hknight2_die3	] { monster_check_gib(); self.nextthink = time + 0.13; };
void()	hknight2_die3	= [	$death3,	hknight2_die4	] { monster_check_gib(); self.solid = SOLID_NOT; ai_back(3); };
void()	hknight2_die4	= [	$death4,	hknight2_die5	] { ai_back(4); };
void()	hknight2_die5	= [	$death5,	hknight2_die6	] { ai_back(5); };
void()	hknight2_die6	= [	$death6,	hknight2_die7	] { ai_back(1);sound(self,CHAN_AUTO,"q15/warlord/fall.wav",1,ATTN_IDLE); };
void()	hknight2_die7	= [	$death7,	hknight2_die8	] {};
void()	hknight2_die8	= [	$death8,	hknight2_die9	] {};
void()	hknight2_die9	= [	$death9,	hknight2_die10	] {};
void()	hknight2_die10	= [	$death10,	hknight2_die11	] {};
void()	hknight2_die11	= [	$death11,	hknight2_die12	] {};
void()	hknight2_die12	= [	$death12,	hknight2_die13	] { self.nextthink = time + 0.03; monster_death_postcheck(); };
void()	hknight2_die13	= [	$death13,	hknight2_die13	] { monster_deadbody_check(); };

void()	hknight2_dieb1	= [	$deathb1,	hknight2_dieb2	] { ai_back(5); };
void()	hknight2_dieb2	= [	$deathb2,	hknight2_dieb3	] { monster_check_gib(); ai_back(5); };
void()	hknight2_dieb3	= [	$deathb3,	hknight2_dieb4	] { monster_check_gib(); ai_back(5); self.solid = SOLID_NOT; };
void()	hknight2_dieb4	= [	$deathb4,	hknight2_dieb5	] { ai_back(3); };
void()	hknight2_dieb5	= [	$deathb5,	hknight2_dieb6	] { sound(self,CHAN_AUTO,"q15/warlord/fall.wav",1,ATTN_IDLE); };
void()	hknight2_dieb6	= [	$deathb6,	hknight2_dieb7	] {};
void()	hknight2_dieb7	= [	$deathb7,	hknight2_dieb8	] {};
void()	hknight2_dieb8	= [	$deathb8,	hknight2_dieb9	] { monster_death_postcheck(); };
void()	hknight2_dieb9	= [	$deathb9,	hknight2_dieb9	] { monster_deadbody_check(); };


void() hknight2_die = { // [FUNCTION]
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();
	
	// regular death
	if (!self.gibbed) {
		sound(self,CHAN_VOICE, "q15/warlord/death1.wav",1,ATTN_NORM);
		if (random() > 0.5)
			hknight2_die1();
		else
			hknight2_dieb1();
	}
};

void() hknight2_multigrenade_touch;

void() hknight2_minigrenade_explode = { // [FUNCTION]
	T_RadiusDamage(self, self.owner, 50, self.owner, DAMAGEALL); // make Warlord immune to his own multigrenades

	if (other.health) {
		if (ext_dppart) pointparticles(particleeffectnum("multigrenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	} else {
		if (ext_dppart) pointparticles(particleeffectnum("multigrenade_explosion"), self.origin, '0 0 0', 1);
	}
	R_Exp3(self.origin);
	BecomeExplosion();
};

void(float offsetAngle) hknight2_minigrenade_launch = { // [FUNCTION]
	local	entity missile;
	local	float	tempRand;
	
	missile = spawn();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MiniGrenade";
		
	// set missile speed	
	missile.v_angle = self.v_angle;
	missile.v_angle_y = missile.v_angle_y + offsetAngle;
	makevectors(missile.v_angle);
	missile.velocity = v_forward*100 + v_up*400;
	tempRand = (crandom()*60) - 30;
	missile.velocity = missile.velocity + tempRand * v_forward;
	tempRand = (crandom()*40) - 20;
	missile.velocity = missile.velocity + tempRand * v_right;
	tempRand = (crandom()*60) - 30;
	missile.velocity = missile.velocity + tempRand * v_up;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = hknight2_multigrenade_touch;
	setmodel(missile, "progs/q15/h_grenade2.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin(missile, self.origin);
	missile.scale = 0.7;	

	// set missile duration
	missile.nextthink = time + 1 + (crandom() * 0.5);
	missile.think = hknight2_minigrenade_explode;
};

void() hknight2_multigrenade_explode = { // [FUNCTION]
	hknight2_minigrenade_launch(0);
	hknight2_minigrenade_launch(72);
	hknight2_minigrenade_launch(144);
	hknight2_minigrenade_launch(216);
	hknight2_minigrenade_launch(288);
	remove (self);
};

void() hknight2_multigrenade_touch = { // [FUNCTION]
	if (other == self.owner) return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM) {
		hknight2_minigrenade_explode();
		return;
	}
	// bounce sound
	sound(self,CHAN_WEAPON,"weapons/bounce.wav",1,ATTN_NORM);	
	if (self.velocity == '0 0 0') self.avelocity = '0 0 0';
};

void() hknight2_grenade_explode = { // [FUNCTION]
	T_RadiusDamage(self, self.owner, 40, world,DAMAGEALL);
	R_Exp3(self.origin);

	if (other.health) {
		if (ext_dppart) pointparticles(particleeffectnum("multigrenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	} else {
		if (ext_dppart) pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
	}
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() hknight2_grenade_touch = { // [FUNCTION]
	if (other == self.owner) return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM) {
		hknight2_grenade_explode();
		return;
	}

	sound(self,CHAN_VOICE, "weapons/bounce.wav",1,ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0') self.avelocity = '0 0 0';
};

void() hknight2_throw = { // [FUNCTION]
	local vector distancedelta, nozdistancedelta, org, follow; 
	local	entity missile;
	
	sound(self,CHAN_WEAPON,"q15/warlord/throw.wav",1,ATTN_NORM);

	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

	makevectors(self.angles);
	org = self.origin + /* self.view_ofs +*/ v_right * 12 + v_up * 11 + v_forward * 20;
		
	// set missile speed	
	follow = self.enemy.velocity*0.2;		// "guess" players future position to make it harder to dodge
	follow_z = 0;	

	distancedelta = (self.enemy.origin + follow) - org; 	//work out distance vector  
	nozdistancedelta = distancedelta;  		//copy to no height distance vector 
	nozdistancedelta_z = 0;  			//remove height 
	
	missile.velocity = normalize(distancedelta); 	//set the velocity to the distance
	missile.velocity = missile.velocity * 525;   	//give it some power 
	missile.velocity_z = missile.velocity_z + 150 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	
	// set missile duration and type
	if (self.spawnflags & 2) { // use multi-grenades
		missile.touch = hknight2_multigrenade_touch;
		missile.nextthink = time + 2.5;
		missile.think = hknight2_multigrenade_explode;
		setmodel(missile, "progs/q15/h_grenade2.mdl");
	} else {
		// use regular grenades
		missile.touch = hknight2_grenade_touch;
		missile.nextthink = time + 2.5;
		missile.think = hknight2_grenade_explode;
		setmodel(missile, "progs/q15/h_grenade1.mdl");
	}
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin(missile, org);	
	missile.scale = 1.2;	
};

void()	hknight2_throwgrenade1	= [	$throw1,	hknight2_throwgrenade2	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade2	= [	$throw2,	hknight2_throwgrenade3	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade3	= [	$throw3,	hknight2_throwgrenade4	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade4	= [	$throw4,	hknight2_throwgrenade5	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade5	= [	$throw5,	hknight2_throwgrenade6	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade6	= [	$throw6,	hknight2_throwgrenade7	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade7	= [	$throw7,	hknight2_throwgrenade8	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade8	= [	$throw8,	hknight2_throwgrenade9	] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade9	= [	$throw9,	hknight2_throwgrenade10] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade10= [	$throw10,	hknight2_throwgrenade11] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade11= [	$throw11,	hknight2_throwgrenade12] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade12= [	$throw12,	hknight2_throwgrenade13] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade13= [	$throw13,	hknight2_throwgrenade14] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade14= [	$throw14,	hknight2_throwgrenade15] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade15= [	$throw15,	hknight2_throwgrenade16] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade16= [	$throw16,	hknight2_throwgrenade17] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade17= [	$throw17,	hknight2_throwgrenade18] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade18= [	$throw18,	hknight2_throwgrenade19] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade19= [	$throw19,	hknight2_throwgrenade20] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade20= [	$throw20,	hknight2_throwgrenade21] { ai_face(); self.nextthink = time + 0.06; hknight2_throw(); monster_footstep(FALSE); };
void()	hknight2_throwgrenade21= [	$throw21,	hknight2_throwgrenade22] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade22= [	$throw22,	hknight2_throwgrenade23] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade23= [	$throw23,	hknight2_throwgrenade24] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade24= [	$throw24,	hknight2_throwgrenade25] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade25= [	$throw25,	hknight2_throwgrenade26] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade26= [	$throw26,	hknight2_throwgrenade27] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade27= [	$throw27,	hknight2_throwgrenade28] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade28= [	$throw28,	hknight2_throwgrenade29] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade29= [	$throw29,	hknight2_throwgrenade30] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade30= [	$throw30,	hknight2_throwgrenade31] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade31= [	$throw31,	hknight2_throwgrenade32] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade32= [	$throw32,	hknight2_throwgrenade33] { ai_face(); self.nextthink = time + 0.06; };
void()	hknight2_throwgrenade33= [	$throw33,	hknight2_run1] { ai_face(); };

float() hknight2_throwdistance = { // [FUNCTION]
	local vector spot1, spot2;
	local float r;

	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	
	r = vlen (spot1 - spot2);
	if ((r > 190) && (r < 500))
		return TRUE;
	else
		return FALSE;
};

//  Teleport Face to a slightly other position near its origin  (harder to hit)
void() hknight2_homing_teleport = { // [FUNCTION]
	local vector spot, vec;

	// Select teleport destination within a 55 radius.
	spot = self.origin + (mathlib_randomvec()*55);
	vec = normalize(spot - self.origin);
	traceline (self.origin, spot, TRUE, self);	// look through monsters
	spot = trace_endpos - vec*13;
	if (SUB_BBoxInOccupied(self,self.mins,self.maxs,spot)) return; // Check for walls and obstacles.

	// Check if target is not blocked.
	traceline (spot, self.enemy.origin, FALSE, self);
	if (trace_fraction < 1.0)
		if (trace_ent != self.enemy) return;

	// Teleport and face opponent!
	setorigin(self, spot);
	self.angles_y = vectoyaw(self.enemy.origin - spot);
};

void(entity inflictor, entity attacker, float damage) hknight2_homing_pain = { // [FUNCTION]
	if (self.pain_finished > time) return;

	self.pain_finished = time + 0.5;
	sound(self,CHAN_VOICE, "q15/warlord/homing_pain.wav",1,ATTN_NORM);
	hknight2_homing_teleport();
};

void() hknight2_homing_death = { // [FUNCTION]
	R_Exp3(self.origin);
	remove(self);
};

void() hknight2_homing_touch = { // [FUNCTION]
	if (other.takedamage) {
		if (other.classname != "player") {
			hknight2_homing_teleport();
			return;
		}
		T_Damage(other, self, self.owner, 15, DAMARMOR);	 // default 15	
		sound(self,CHAN_WEAPON,"q15/warlord/homing_touch.wav",1,ATTN_NORM);	 // To abort the homing fly-sound. Use same channel !!!!
		remove(self);
	}

	if (!IsProjectile(other)) {
		sound(self,CHAN_WEAPON,"q15/warlord/homing_touch.wav",1,ATTN_NORM);	 // To abort the homing fly-sound. Use same channel !!!!
		remove(self);
	}
};

void() hknight2_homing_think = { // [FUNCTION]
	local vector dir, offang, vec;

	if (self.enemy.health < 1) { remove (self); return; } // to avoid endless homing above players corpse
	
	// to make it touchable again
	if (vlen((self.enemy.origin + '0 0 16') - self.origin) <= 70) {
		traceline ((self.enemy.origin + '0 0 16'), self.origin, FALSE, self);
		if (trace_fraction == 1) self.movetype = MOVETYPE_FLYMISSILE;
	}

	// when it got stuck
	if (self.origin == self.oldorigin) {
		sound(self,CHAN_WEAPON,"q15/warlord/homing_touch.wav",1,ATTN_NORM);	 // To abort the face fly-sound. Use same channel !!!!
		//T_RadiusDamage(self, self.owner, 33, self.owner);	
		remove (self);
	}
	self.oldorigin = self.origin;

	dir = normalize((self.enemy.origin + '0 0 16') - self.origin);
	offang = vectoangles ((self.enemy.origin + '0 0 12') - self.origin);
	makevectors(offang);
	
	// set homing-missile angles
	vec = normalize (v_forward);
	vec_z = vec_z * -1;
	self.angles = vectoangles(vec);  	// adjust the Face to always face the player !
	self.frame = self.frame + 1;		// Face animation
	if (self.frame >= 19) self.frame = 0; //  D3, was >= 44 // DS

	self.touch = hknight2_homing_touch; 			
	self.velocity = dir * 230;			// speed of Face.  Vore: 250;
	self.nextthink = time + 0.15;			// inertia of homing effect.  Vore: 0.2
	self.think = hknight2_homing_think;	
};

void(vector face_spawn_pos, vector face_spawn_vel) launch_hknight2_homing = { // [FUNCTION]
	newmis = spawn();
	newmis.owner = self;
	newmis.enemy = self.enemy;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.velocity = face_spawn_vel * 230;	
	newmis.angles = vectoangles (newmis.velocity);
	newmis.scale = 0.7;
	newmis.glow_color = 75;
	newmis.glow_size = 666;
	//newmis.frame = 14;			// start frame is 14    DS
	newmis.frame = 0;			// start frame is 0	D3
	newmis.classname = "hknight2_homing";
	newmis.think = hknight2_homing_think;	
	newmis.nextthink = time + 0.27;		// to move completely out of warlords model (to avoid touch function with it)
	setmodel(newmis, "progs/q15/face.mdl");		
	setsize (newmis, '-9 -9 -9', '9 9 9');
	if (ext_dppart) newmis.traileffectnum = particleeffectnum("TR_WARLORDHOMING");
	newmis.health = 30;
	newmis.takedamage = DAMAGE_AIM;
	setorigin(newmis, face_spawn_pos);
	newmis.th_pain = hknight2_homing_pain;
	newmis.th_die = hknight2_homing_death;
	sound(newmis,CHAN_WEAPON,"q15/warlord/homing.wav",1,ATTN_NORM);
};

void() hknight2_homing_shot = { // [FUNCTION]
	local vector offang, org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors(offang);
	org = self.origin + /* self.view_ofs +*/ v_right * 9 + v_up * 12 + v_forward * 17;

	// set homing-missile speed
	vec = normalize (v_forward);
	vec_z = vec_z * -1;
	
	launch_hknight2_homing (org, vec); 
};

void()	hknight2_magica1 = [	$magica1,	hknight2_magica2	] { ai_face(); };
void()	hknight2_magica2 = [	$magica2,	hknight2_magica3	] { ai_face(); };
void()	hknight2_magica3 = [	$magica3,	hknight2_magica4	] { ai_face(); };
void()	hknight2_magica4 = [	$magica4,	hknight2_magica5	] { ai_face(); };
void()	hknight2_magica5 = [	$magica5,	hknight2_magica6	] { ai_face(); };
void()	hknight2_magica6 = [	$magica6,	hknight2_magica7	] { ai_face();monster_footstep(FALSE); };
void()	hknight2_magica7 = [	$magica7,	hknight2_magica8	] { hknight2_shot(-2); };
void()	hknight2_magica8 = [	$magica8,	hknight2_magica9	] { hknight2_shot(-1); };
void()	hknight2_magica9 = [	$magica9,	hknight2_magica10] { hknight2_shot(0); };
void()	hknight2_magica10 = [	$magica10,	hknight2_magica11] { hknight2_shot(1); };
void()	hknight2_magica11 = [	$magica11,	hknight2_magica12] { hknight2_shot(2); };
void()	hknight2_magica12 = [	$magica12,	hknight2_magica13] { hknight2_shot(3); };
void()	hknight2_magica13 = [	$magica13,	hknight2_magica14] { ai_face(); };
void()	hknight2_magica14 = [	$magica14,	hknight2_run1	] { ai_face(); };



void()	hknight2_magicb1 = [	$magicb1,	hknight2_magicb2	] { ai_face(); };
void()	hknight2_magicb2 = [	$magicb2,	hknight2_magicb3	] { ai_face(); };
void()	hknight2_magicb3 = [	$magicb3,	hknight2_magicb4	] { ai_face(); };
void()	hknight2_magicb4 = [	$magicb4,	hknight2_magicb5	] { ai_face(); };
void()	hknight2_magicb5 = [	$magicb5,	hknight2_magicb6	] { ai_face(); };
void()	hknight2_magicb6 = [	$magicb6,	hknight2_magicb7	] { ai_face(); monster_footstep(FALSE); };
void()	hknight2_magicb7 = [	$magicb7,	hknight2_magicb8	] { ai_face();sound(self,CHAN_WEAPON,"q15/warlord/homing_shot.wav",1,ATTN_NORM); };
void()	hknight2_magicb8 = [	$magicb8,	hknight2_magicb9	] { ai_face(); };
void()	hknight2_magicb9 = [	$magicb9,	hknight2_magicb10] { hknight2_homing_shot(); };
void()	hknight2_magicb10 = [	$magicb10,	hknight2_magicb11] {};
void()	hknight2_magicb11 = [	$magicb11,	hknight2_magicb12] {};
void()	hknight2_magicb12 = [	$magicb12,	hknight2_magicb13] {};
void()	hknight2_magicb13 = [	$magicb13,	hknight2_run1] { ai_face(); };

void() ram_scan = { // [FUNCTION]
	local vector dir, spot1, spot2;
	local float r;	

	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	r = vlen (spot1 - spot2);
	if (r < 60) {
		sound(self,CHAN_AUTO,"q15/warlord/fall.wav",1,ATTN_IDLE);

		// damage can vary between 5 and 10 hitpoints
		T_Damage(self.enemy, self, self, rint(5 + (5 * random())), DAMARMOR); 

		dir = (self.origin - '0 0 7') - self.enemy.origin;
		dir = normalize(dir);
		if (self.enemy.flags & FL_CLIENT) self.enemy.velocity = self.enemy.velocity - (dir * 300);
	}
};

void()	hknight2_char_a1	= [	$char_a1,	hknight2_char_a2	] { ai_charge(1); };
void()	hknight2_char_a2	= [	$char_a2,	hknight2_char_a3	] { ai_charge(1); };
void()	hknight2_char_a3	= [	$char_a3,	hknight2_char_a4	] { ai_charge(3); };
void()	hknight2_char_a4	= [	$char_a4,	hknight2_char_a5	] { ai_charge(15); monster_footstep(FALSE); };
void()	hknight2_char_a5	= [	$char_a5,	hknight2_char_a6	] { ai_charge(17); };
void()	hknight2_char_a6	= [	$char_a6,	hknight2_char_a7	] { ai_charge(20);sound(self,CHAN_AUTO,"q15/warlord/ram.wav",1,ATTN_NORM); };
void()	hknight2_char_a7	= [	$char_a7,	hknight2_char_a8	] { ai_charge(20); ai_melee(); monster_footstep(FALSE); };
void()	hknight2_char_a8	= [	$char_a8,	hknight2_char_a9	] { ai_charge(20); ai_melee(); };
void()	hknight2_char_a9	= [	$char_a9,	hknight2_char_a10	] { ai_charge(20); ai_melee(); };
void()	hknight2_char_a10= [	$char_a10,	hknight2_char_a11	] { ai_charge(20); ai_melee(); ram_scan(); };	// shield HIT  !!!
void()	hknight2_char_a11= [	$char_a11,	hknight2_char_a12	] { ai_charge(18); ai_melee(); };
void()	hknight2_char_a12= [	$char_a12,	hknight2_char_a13	] { ai_charge(16); };
void()	hknight2_char_a13= [	$char_a13,	hknight2_char_a14	] { ai_charge(6); monster_footstep(FALSE); };
void()	hknight2_char_a14= [	$char_a14,	hknight2_char_a15	] { ai_charge(2); };
void()	hknight2_char_a15= [	$char_a15,	hknight2_char_a16	] { ai_charge(2); };
void()	hknight2_char_a16= [	$char_a16,	hknight2_run1	] { ai_charge(2); };

void()	hknight2_char_b1	= [	$char_b1,	hknight2_char_b2	]
{ CheckContinueCharge(); ai_charge(1); };
void()	hknight2_char_b2	= [	$char_b2,	hknight2_char_b3	] { SwordSwipeSound(); ai_charge(10); };
void()	hknight2_char_b3	= [	$char_b3,	hknight2_char_b4	] { ai_charge(15); ai_melee(); monster_footstep(FALSE); };
void()	hknight2_char_b4	= [	$char_b4,	hknight2_char_b5	] { ai_charge(22); ai_melee(); };
void()	hknight2_char_b5	= [	$char_b5,	hknight2_char_b6	] { ai_charge(18); ai_melee(); };
void()	hknight2_char_b6	= [	$char_b6,	hknight2_char_b1	] { ai_charge(8); ai_melee(); };

void()	hknight2_slice1	= [	$slice1,	hknight2_slice2	] { ai_charge(2); };
void()	hknight2_slice2	= [	$slice2,	hknight2_slice3	] { ai_charge(2); };
void()	hknight2_slice3	= [	$slice3,	hknight2_slice4	] { ai_charge(2); };
void()	hknight2_slice4	= [	$slice4,	hknight2_slice5	] { ai_charge(3);
if (random()<0.5)
	sound(self,CHAN_AUTO,"q15/warlord/attack2.wav",1,ATTN_NORM); };
void()	hknight2_slice5	= [	$slice5,	hknight2_slice6	] { ai_charge(7); ai_melee(); };
void()	hknight2_slice6	= [	$slice6,	hknight2_slice7	] { ai_charge(15); ai_melee(); };
void()	hknight2_slice7	= [	$slice7,	hknight2_slice8	] { ai_charge(20); ai_melee(); monster_footstep(FALSE); };
void()	hknight2_slice8	= [	$slice8,	hknight2_slice9	] { ai_charge(3); ai_melee(); };
void()	hknight2_slice9	= [	$slice9,	hknight2_slice10] { ai_melee(); };
void()	hknight2_slice10= [	$slice10,	hknight2_run1	] { ai_charge(1); };

void()	hknight2_smash1	= [	$smash1,	hknight2_smash2	] { ai_charge(1); };
void()	hknight2_smash2	= [	$smash2,	hknight2_smash3	] { ai_charge(1); };
void()	hknight2_smash3	= [	$smash3,	hknight2_smash4	] { ai_charge(1); };
void()	hknight2_smash4	= [	$smash4,	hknight2_smash5	] { ai_charge(2);
	if (random()<0.5) sound(self,CHAN_AUTO,"q15/warlord/attack2.wav",1,ATTN_NORM);
};
void()	hknight2_smash5	= [	$smash5,	hknight2_smash6	] { ai_charge(10); ai_melee(); };
void()	hknight2_smash6	= [	$smash6,	hknight2_smash7	] { ai_charge(15); ai_melee(); };
void()	hknight2_smash7	= [	$smash7,	hknight2_smash8	] { ai_charge(15); ai_melee(); monster_footstep(FALSE); };
void()	hknight2_smash8	= [	$smash8,	hknight2_smash9	] { ai_charge(7); ai_melee(); };
void()	hknight2_smash9	= [	$smash9,	hknight2_smash10] { ai_charge(3); ai_melee(); };
void()	hknight2_smash10= [	$smash10,	hknight2_smash11] { ai_charge(0); monster_footstep(FALSE); };
void()	hknight2_smash11= [	$smash11,	hknight2_run1	] { ai_charge(0); };

void()	hknight2_watk1	= [	$w_attack1,	hknight2_watk2	] { ai_charge(1); };
void()	hknight2_watk2	= [	$w_attack2,	hknight2_watk3	] { ai_charge(1);
	if (random()<0.5) sound(self,CHAN_AUTO,"q15/warlord/attack3.wav",1,ATTN_NORM);
};
void()	hknight2_watk3	= [	$w_attack3,	hknight2_watk4	] { ai_charge(10); monster_footstep(FALSE); };
void()	hknight2_watk4	= [	$w_attack4,	hknight2_watk5	] { ai_charge(5); ai_melee(); };
void()	hknight2_watk5	= [	$w_attack5,	hknight2_watk6	] { ai_melee(); };
void()	hknight2_watk6	= [	$w_attack6,	hknight2_watk7	] { ai_melee(); };
void()	hknight2_watk7	= [	$w_attack7,	hknight2_watk8	] { ai_charge(1); };
void()	hknight2_watk8	= [	$w_attack8,	hknight2_watk9	] { ai_charge(1); };
void()	hknight2_watk9	= [	$w_attack9,	hknight2_watk10	] { ai_charge(1); };
void()	hknight2_watk10	= [	$w_attack10,	hknight2_watk11	] { ai_charge(1); };
void()	hknight2_watk11	= [	$w_attack11,	hknight2_watk12	] { ai_charge(10); };
void()	hknight2_watk12	= [	$w_attack12,	hknight2_watk13	] { ai_charge(15); ai_melee(); };
void()	hknight2_watk13	= [	$w_attack13,	hknight2_watk14	] { ai_charge(10); ai_melee(); monster_footstep(FALSE); };
void()	hknight2_watk14	= [	$w_attack14,	hknight2_watk15	] { ai_charge(0); ai_melee(); };
void()	hknight2_watk15	= [	$w_attack15,	hknight2_watk16	] { ai_charge(0); };
void()	hknight2_watk16	= [	$w_attack16,	hknight2_watk17	] { ai_charge(1); monster_footstep(FALSE); };
void()	hknight2_watk17	= [	$w_attack17,	hknight2_watk18	] { ai_charge(1); };
void()	hknight2_watk18	= [	$w_attack18,	hknight2_watk19	] { ai_charge(1); };
void()	hknight2_watk19	= [	$w_attack19,	hknight2_watk20	] { ai_charge(1); ai_melee(); monster_footstep(FALSE); };
void()	hknight2_watk20	= [	$w_attack20,	hknight2_watk21	] { ai_charge(10); ai_melee(); };
void()	hknight2_watk21	= [	$w_attack21,	hknight2_watk22	] { ai_charge(10); ai_melee(); };
void()	hknight2_watk22	= [	$w_attack22,	hknight2_run1	] { ai_charge(2); };

void()	hknight2_duck1 = [	$duck1,		hknight2_duck2] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_duck2 = [	$duck2,		hknight2_duck3] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_duck3 = [	$duck3,		hknight2_duck4] { ai_face(); self.nextthink = time + 0.6; };	// am weitesten zusammengekauert !!!!!
void()	hknight2_duck4 = [	$duck4,		hknight2_duck5] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_duck5 = [	$duck5,		hknight2_duck6] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_duck6 = [	$duck6,		hknight2_run1 ] { ai_face(); self.nextthink = time + 0.11; self.takedamage = DAMAGE_AIM; };

void()	hknight2_dodge1 = [	$dodge1,	hknight2_dodge2	] { ai_face(); self.nextthink = time + 0.1; };
void()	hknight2_dodge2 = [	$dodge2,	hknight2_dodge3	] { ai_face(); self.nextthink = time + 0.5; };	// am weitesten zur Seite gelehnt !!!!!
void()	hknight2_dodge3 = [	$dodge3,	hknight2_dodge4	] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_dodge4 = [	$dodge4,	hknight2_dodge5	] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_dodge5 = [	$dodge5,	hknight2_run1	] { ai_face(); self.nextthink = time + 0.11; self.takedamage = DAMAGE_AIM; };

void()	hknight2_block1 = [	$block1,	hknight2_block2	] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_block2 = [	$block2,	hknight2_block3	] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_block3 = [	$block3,	hknight2_block4	] { ai_face(); self.nextthink = time + 0.6; };	// am weitesten nach hinten gelehnt !!!!!
void()	hknight2_block4 = [	$block4,	hknight2_block5	] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_block5 = [	$block5,	hknight2_block6	] { ai_face(); self.nextthink = time + 0.11; };
void()	hknight2_block6 = [	$block6,	hknight2_run1	] { ai_face(); self.nextthink = time + 0.11; self.takedamage = DAMAGE_AIM; };

void() hknight2_dodge = { // [FUNCTION]
	local float zufall;
	self.takedamage = DAMAGE_YES; 			// grenades bounces off of him
	zufall = random();
	if (zufall < 0.27)
		hknight2_duck1();		// ducken mit dem Schild 
	else if (zufall < 0.55)
		hknight2_block1();		// block animation 
	else
		hknight2_dodge1();		// dodge animationen (zur seite)
};

void(entity inflictor, entity attacker, float damage) hknight2_pain = { // [FUNCTION]
	self.touch = SUB_Null;
	if (self.dodging) {
		self.dodging = 0;
		hknight2_dodge();
		return;
	}

	if (self.dodge_finished > time) return;
	if (self.pain_finished > time) return;

	// always go into pain frame if it has been a while
	if (time - self.pain_finished > 5) {
		if (random() < 0.5)
			hknight2_pain1();
		else
			hknight2_painb1();
		self.pain_finished = time + 1.5;
		return;
	}
	
	if ((random()*30 > damage) ) return;		// didn't flinch

	self.pain_finished = time + 1.5;
	if (random() < 0.5)
		hknight2_pain1();
	else
		hknight2_painb1();
};

void() hknight2_melee = { // [FUNCTION]
	self.lefty = self.lefty + 1;
	sound(self,CHAN_WEAPON,"q15/warlord/slash1.wav",1,ATTN_NORM);
	if (self.lefty == 1) {
		hknight2_slice1();
	} else if (self.lefty == 2) {
		hknight2_smash1();
	} else if (self.lefty >= 3) {
		hknight2_watk1();
		self.lefty = 0;
	}
};

// adds random ranged attacks
void() hknight2_random_ranged_attack = { // [FUNCTION]			
	local float zufall;

	zufall = random();
	// if good range, throw grenade instead of magic-missile attack
	if (hknight2_throwdistance()) {
		if (zufall < 0.33) {
			hknight2_throwgrenade1();
		} else if (zufall < 0.77) {
			hknight2_magica1();		// regular magic missiles
		} else {
			if (random() < 0.23)
				hknight2_magicb1();		// homing missile (23% chance)
			else
				hknight2_magica1();		// regular magic missiles
		}
	} else {
		// do not throw grenades
		if (zufall < 0.72) {
			hknight2_magica1();		// regular magic missiles
		} else {
			if (random() < 0.23)
				hknight2_magicb1();		// homing missile (27% chance)
			else
				hknight2_magica1();		// regular magic missiles
		}
	}	
};

void() monster_hell_knight2_precache = { // [FUNCTION]
	precache_model("progs/q15/k_spike.mdl"); // referenced in projectiles.qc
	precache_model("progs/q15/h_grenade2.mdl");	// multi
	precache_model("progs/q15/h_grenade1.mdl");	
	precache_model("progs/q15/face.mdl");
	precache_model("progs/drake/s_explod.spr");
	precache_model("progs/q15/warlord.mdl");
	precache_model("progs/q15/h_warlord.mdl");
	precache_model(MODEL_PROJ_HKN);
	precache_model("progs/q15/w_wshield.mdl");
	precache_model("progs/q15/gib_warleg.mdl");
	precache_model("progs/q15/gib_wararm.mdl");
	precache_sound("q15/warlord/attack1.wav");		// all files precached in worldspawn() due to savegame-bug
	precache_sound("q15/warlord/attack2.wav");	
	precache_sound("q15/warlord/attack3.wav");	
	precache_sound("q15/warlord/death1.wav");
	precache_sound("q15/warlord/pain1.wav");
	precache_sound("q15/warlord/pain2.wav");
	precache_sound("drake/archer/sight2.wav");
	precache_sound("q15/warlord/slash1.wav");
	precache_sound("drake/archer/growl2.wav");
	precache_sound("q15/warlord/growl.wav");
	precache_sound("q15/warlord/ram.wav");
	precache_sound("q15/warlord/throw.wav");
	precache_sound("q15/warlord/fall.wav");
	precache_sound("q15/warlord/homing.wav");
	precache_sound("q15/warlord/homing_shot.wav");
	precache_sound("q15/warlord/homing_pain.wav");
	precache_sound("q15/warlord/homing_touch.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
};

//QUAKED monster_hell_knight2 (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_hell_knight2 = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/q15/warlord.mdl";			// New Hell Knight
	self.headmdl = "progs/q15/h_warlord.mdl";
	self.gib1mdl = "progs/q15/w_wshield.mdl";
	self.gib2mdl = "progs/q15/gib_warleg.mdl";
	self.gib3mdl = "progs/q15/gib_wararm.mdl";
	self.sight_sound = "drake/archer/sight2.wav";
	self.pain_sound = "q15/warlord/pain1.wav";
	self.pain_sound2 = "q15/warlord/pain2.wav";
	self.death_sound = "hknight/death1.wav";

	//Select chance for 2 available skins.
	if (random() <= 35) self.skin = 1;
	else self.skin = 0; // More common skin

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 250;
	self.gibhealth = -40;
	self.gibbed = FALSE;
	self.pain_flinch = 40;
	self.pain_longanim = TRUE;			// can be chopped with shadow axe
	self.pain_timeout = 1.5;			// Higher than a knight
	self.steptype = FS_TYPEHEAVY;
	if (self.deathstring == "") self.deathstring = " was bashed by a Warlord\n";
	self.th_stand = hknight2_stand1;
	self.th_walk = hknight2_walk1;
	self.th_run = hknight2_run1;
	self.th_melee = hknight2_melee;
  	self.th_missile = hknight2_random_ranged_attack;
	self.th_pain = hknight2_pain;
	self.th_die = hknight2_die;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.classtype = CT_MONWARLORD;
	self.classgroup = CG_DKNIGHT;
	self.classmove = MON_MOVEWALK;
	monster_start();
};