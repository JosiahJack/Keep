//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \ 
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Mission Pack 2 (Rogue)
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
// Function count: 122
//
// Implements: Wrath Overlord
//
// Description:
// Much like the wrath, but with 4 arms, much more powerful, and able to
// teleport around the arena to info_overlord_destination entities.  Dies in an
// explosive shower of blood.  Also known as the Super Wrath.
//
// Also includes the info_overlord_destination definition.
//=============================================================================

float() overlord_smash;

void() overlord_teleport = { // [FUNCTION]
   local float chance;
   local entity theDest;
   local vector org;

   if (self.spawnflags & FL_SWIM) return;

   chance = random();
   if (chance > 0.750) return;

   theDest = SUB_FindTeleportDestinationEntity();
   if (!theDest) return;

   spawn_tfog (self.origin);
   makevectors(self.angles);
   org = (theDest.origin + (FL_MONSTER * v_forward));
   spawn_tfog (org);
   spawn_tdeath (theDest.origin,self);
   setorigin(self,theDest.origin);
   self.flags = (self.flags - (self.flags & FL_ONGROUND));
};

void() overlord_stand1 = [ 1.000, overlord_stand1 ] { ai_stand(); };
void() overlord_walk01 = [ 1.000, overlord_walk02 ] { ai_walk(8); };
void() overlord_walk02 = [ 2.000, overlord_walk03 ] { ai_walk(8); };
void() overlord_walk03 = [ 3.000, overlord_walk04 ] { ai_walk(8); };
void() overlord_walk04 = [ 4.000, overlord_walk05 ] { ai_walk(8); };
void() overlord_walk05 = [ 5.000, overlord_walk06 ] { ai_walk(8); };
void() overlord_walk06 = [ 6.000, overlord_walk07 ] { ai_walk(8); };
void() overlord_walk07 = [ 7.000, overlord_walk08 ] { ai_walk(8); };
void() overlord_walk08 = [ 8.000, overlord_walk09 ] { ai_walk(8); };
void() overlord_walk09 = [ 9.000, overlord_walk10 ] { ai_walk(8); };
void() overlord_walk10 = [ 10.000, overlord_walk11 ] { ai_walk(8); };
void() overlord_walk11 = [ 11.000, overlord_walk12 ] { ai_walk(8); };
void() overlord_walk12 = [ 12.000, overlord_walk13 ] { ai_walk(8); };
void() overlord_walk13 = [ 13.000, overlord_walk14 ] { ai_walk(8); };
void() overlord_walk14 = [ 14.000, overlord_walk15 ] { ai_walk(8); };
void() overlord_walk15 = [ 15.000, overlord_walk01 ] {  ai_walk(8); };

void() overlord_run01 = [ 1.000, overlord_run02 ] { ai_run(12); };
void() overlord_run02 = [ 2.000, overlord_run03 ] { ai_run(12); };
void() overlord_run03 = [ 3.000, overlord_run04 ] { ai_run(12); };
void() overlord_run04 = [ 4.000, overlord_run05 ] { ai_run(12); };
void() overlord_run05 = [ 5.000, overlord_run06 ] { ai_run(12); };
void() overlord_run06 = [ 6.000, overlord_run07 ] { ai_run(12); };
void() overlord_run07 = [ 7.000, overlord_run08 ] { ai_run(12); };
void() overlord_run08 = [ 8.000, overlord_run09 ] { ai_run(12); };
void() overlord_run09 = [ 9.000, overlord_run10 ] { ai_run(12); };
void() overlord_run10 = [ 10.000, overlord_run11 ] { ai_run(12); };
void() overlord_run11 = [ 11.000, overlord_run12 ] { ai_run(12); };
void() overlord_run12 = [ 12.000, overlord_run13 ] { ai_run(12); };
void() overlord_run13 = [ 13.000, overlord_run14 ] { ai_run(12); };
void() overlord_run14 = [ 14.000, overlord_run15 ] { ai_run(12); };
void() overlord_run15 = [ 15.000, overlord_run01 ] { ai_run(12); };

void() overlord_at_a01 = [ 16.000, overlord_at_a02 ] { ai_charge(12); };
void() overlord_at_a02 = [ 17.000, overlord_at_a03 ] { ai_charge(12); };
void() overlord_at_a03 = [ 18.000, overlord_at_a04 ] { ai_charge(12); };
void() overlord_at_a04 = [ 19.000, overlord_at_a05 ] { ai_charge(12); };
void() overlord_at_a05 = [ 20.000, overlord_at_a06 ] { ai_charge(12); };
void() overlord_at_a06 = [ 21.000, overlord_at_a07 ] { ai_charge(12); };
void() overlord_at_a07 = [ 22.000, overlord_at_a08 ] { overlord_smash(); };
void() overlord_at_a08 = [ 23.000, overlord_at_a09 ] { ai_charge(12); };
void() overlord_at_a09 = [ 24.000, overlord_at_a10 ] { ai_charge(12); };
void() overlord_at_a10 = [ 25.000, overlord_run01 ] { ai_charge(12); };

void() overlord_at_b01 = [ 26.000, overlord_at_b02 ] { ai_charge(12); };
void() overlord_at_b02 = [ 27.000, overlord_at_b03 ] { ai_charge(12); };
void() overlord_at_b03 = [ 28.000, overlord_at_b04 ] { ai_charge(12); };
void() overlord_at_b04 = [ 29.000, overlord_at_b05 ] { ai_charge(12); };
void() overlord_at_b05 = [ 30.000, overlord_at_b06 ] { ai_charge(12); };
void() overlord_at_b06 = [ 31.000, overlord_at_b07 ] { ai_charge(12); };
void() overlord_at_b07 = [ 32.000, overlord_at_b08 ] { ai_charge(12); };
void() overlord_at_b08 = [ 33.000, overlord_at_b09 ] { overlord_smash(); };
void() overlord_at_b09 = [ 34.000, overlord_at_b10 ] { ai_charge(12); };
void() overlord_at_b10 = [ 35.000, overlord_at_b11 ] { ai_charge(12); };
void() overlord_at_b11 = [ 36.000, overlord_at_b12 ] { ai_charge(12); };
void() overlord_at_b12 = [ 37.000, overlord_at_b13 ] { ai_charge(12); };
void() overlord_at_b13 = [ 38.000, overlord_at_b14 ] { ai_charge(12); };
void() overlord_at_b14 = [ 39.000, overlord_run01 ] { ai_charge(12); };

void() overlord_at_c01 = [ 40.000, overlord_at_c02 ] { ai_charge(12); };
void() overlord_at_c02 = [ 41.000, overlord_at_c03 ] { ai_charge(12); };
void() overlord_at_c03 = [ 42.000, overlord_at_c04 ] { ai_charge(12); };
void() overlord_at_c04 = [ 43.000, overlord_at_c05 ] { ai_charge(12); };
void() overlord_at_c05 = [ 44.000, overlord_at_c06 ] { ai_charge(12); };
void() overlord_at_c06 = [ 45.000, overlord_at_c07 ] { overlord_smash(); };
void() overlord_at_c07 = [ 46.000, overlord_at_c08 ] { ai_charge(12); };
void() overlord_at_c08 = [ 47.000, overlord_at_c09 ] { ai_charge(12); };
void() overlord_at_c09 = [ 48.000, overlord_at_c10 ] { ai_charge(12); };
void() overlord_at_c10 = [ 49.000, overlord_at_c11 ] { ai_charge(12); };
void() overlord_at_c11 = [ 50.000, overlord_at_c12 ] { overlord_smash(); };
void() overlord_at_c12 = [ 51.000, overlord_at_c13 ] { ai_charge(12); };
void() overlord_at_c13 = [ 52.000, overlord_at_c14 ] { ai_charge(12); };
void() overlord_at_c14 = [ 53.000, overlord_run01 ] { ai_charge(12); };

float() overlord_smash = {  // [FUNCTION] PM:  Changed from void to float type so overlord can shoot on a miss.
	local vector delta;
	local float smashDmg;

	if (detected_mod == MOD_DRAKE) ai_charge(self.speed);

	if (self.health < 1) return FALSE;
	if (!self.enemy) return FALSE;
	if (!CanDamage(self.enemy,self)) return FALSE; // Don't even charge.

	if (detected_mod != MOD_DRAKE) {
		ai_charge(10);
		self.enemydist = range_distance(self.enemy,FALSE);
		if (self.enemydist > 100) return FALSE; // Enemy too far away.
	}

	smashDmg = 20 + (random() * 10);
	sound(self,CHAN_WEAPON,"rogue/s_wrath/smash.wav",TRUE,ATTN_NORM);
	T_Damage(self.enemy,self,self,smashDmg,DAMARMOR);
	delta = normalize(((SUB_orgEnemyTarget() - self.origin) + self.enemy.view_ofs));
	SpawnBlood(self.enemy,(self.enemy.origin - (delta * SVC_INTERMISSION)),(delta * -100.000),smashDmg,0);
	return TRUE;
};

void() overlord_melee = { // [FUNCTION]
   local float r;

   r = random();
   if ( (r < 0.330) ) {
      overlord_at_a01();
   } else {
      if ( (r < 0.660) ) {
         overlord_at_b01();
      } else {
         overlord_at_c01();
      }
   }
};

void() overlord_msl_a01 = [ 54.000, overlord_msl_a02 ] { ai_charge(12); };
void() overlord_msl_a02 = [ 55.000, overlord_msl_a03 ] { ai_charge(12); };
void() overlord_msl_a03 = [ 56.000, overlord_msl_a04 ] { ai_charge(12); };
void() overlord_msl_a04 = [ 57.000, overlord_msl_a05 ] { ai_charge(12); };
void() overlord_msl_a05 = [ 58.000, overlord_msl_a06 ] { ai_charge(12); };
void() overlord_msl_a06 = [ 59.000, overlord_msl_a07 ] { WrathMissile (MOVETYPE_STEP); };
void() overlord_msl_a07 = [ 60.000, overlord_msl_a08 ] { ai_charge(12); };
void() overlord_msl_a08 = [ 61.000, overlord_msl_a09 ] { ai_charge(12); };
void() overlord_msl_a09 = [ 62.000, overlord_msl_a10 ] { ai_charge(12); };
void() overlord_msl_a10 = [ 63.000, overlord_msl_a11 ] { ai_charge(12); };
void() overlord_msl_a11 = [ 64.000, overlord_msl_a12 ] { ai_charge(12); };
void() overlord_msl_a12 = [ 65.000, overlord_run01 ] { overlord_teleport(); };

void() overlord_missile = { // [FUNCTION]
	if (self.spawnflags & 4) {
		SUB_CreateSelfAttachment(MODEL_PROJ_WBALL,0.85); // Make sure the attachments are setup ready
		SUB_CreateSelfAttachment2(MODEL_PROJ_WBALL,0.85);
		SUB_CreateSelfAttachment3(self.weaponglow,0.5);
		if (random() < 0.7 && !self.enemy.burning) {
			wraith_debuff1();
		} else overlord_msl_a01();
	} else overlord_msl_a01(); };

void() overlord_pn_a01 = [ 66.000, overlord_pn_a02 ] {};
void() overlord_pn_a02 = [ 67.000, overlord_pn_a03 ] {};
void() overlord_pn_a03 = [ 68.000, overlord_pn_a04 ] { overlord_teleport(); };
void() overlord_pn_a04 = [ 69.000, overlord_pn_a05 ] {};
void() overlord_pn_a05 = [ 70.000, overlord_pn_a06 ] {};
void() overlord_pn_a06 = [ 71.000, overlord_pn_a07 ] {};
void() overlord_pn_a07 = [ 72.000, overlord_run01 ] {};

void() overlord_pn_b01 = [ 80.000, overlord_pn_b02 ] {};
void() overlord_pn_b02 = [ 81.000, overlord_pn_b03 ] {};
void() overlord_pn_b03 = [ 82.000, overlord_pn_b04 ] { overlord_teleport(); };
void() overlord_pn_b04 = [ 83.000, overlord_pn_b05 ] {};
void() overlord_pn_b05 = [ 84.000, overlord_pn_b06 ] {};
void() overlord_pn_b06 = [ 85.000, overlord_pn_b07 ] {};
void() overlord_pn_b07 = [ 86.000, overlord_run01 ] {};

void(entity inflictor, entity attacker, float damage) overlord_pain = { // [FUNCTION]
   if (self.pain_finished > time) return;
   if (random() > 0.2) return;

	SUB_FinishAttachments(); // Hide any attachments
   if (random() < 0.5)  overlord_pn_a01();
   else overlord_pn_b01();

   self.pain_finished = (time + FL_SWIM);
   sound(self,CHAN_VOICE,"rogue/wrath/wpain.wav",TRUE,ATTN_NORM);
};

void(string gibName) ol_toss = { // [FUNCTION]
	local vector flingVelocity;
	local entity myGib;

	if (detected_mod == MOD_DRAKE) {
		// PM:  More random velocity code.
		flingVelocity = self.angles;
		flingVelocity_y = random() * 360;
		makevectors(flingVelocity);
    	flingVelocity = (v_forward * 250) + (v_up * (300 + (random() * 100 - 50)));
	} else {
		makevectors(self.angles);
		flingVelocity = ((v_forward * 250.000) + (v_up * 300.000));
		flingVelocity = (flingVelocity + (v_up * ((random () * 100.000) - 50.000)));
		flingVelocity = (flingVelocity + (v_right * ((random () * 200.000) - 100.000)));
	}

	myGib = spawn();
	setmodel(myGib,gibName);
	setsize (myGib,VEC_ORIGIN,VEC_ORIGIN);
	myGib.movetype = MOVETYPE_BOUNCE;
	myGib.classtype = CT_TEMPGIB;
	myGib.classgroup = CG_MISCENT;
	myGib.solid = SOLID_NOT;
	setorigin(myGib, self.origin);
	myGib.think = SUB_Remove;
	myGib.ltime = time;
	myGib.nextthink = ((time + 10) + (random () * 10));
	myGib.frame = FALSE;
	myGib.flags = FALSE;
	myGib.velocity = flingVelocity;
};

void() overlord_die01 = [ 91.000, overlord_die02 ] { self.nextthink = (time + 0.050); };
void() overlord_die02 = [ 92.000, overlord_die03 ] { self.flags = (self.flags | FL_FLY); self.nextthink = (time + 0.050); };
void() overlord_die03 = [ 93.000, overlord_die04 ] { self.nextthink = (time + 0.050); };
void() overlord_die04 = [ 94.000, overlord_die05 ] { self.nextthink = (time + 0.050); };
void() overlord_die05 = [ 95.000, overlord_die06 ] { self.nextthink = (time + 0.050); };
void() overlord_die06 = [ 96.000, overlord_die07 ] { self.nextthink = (time + 0.050); };
void() overlord_die07 = [ 97.000, overlord_die08 ] { self.nextthink = (time + 0.050); };
void() overlord_die08 = [ 98.000, overlord_die09 ] { self.nextthink = (time + 0.050); };
void() overlord_die09 = [ 99.000, overlord_die10 ] { self.nextthink = (time + 0.050); };
void() overlord_die10 = [ 99.000, overlord_die11 ] { self.nextthink = (time + 0.050); };
void() overlord_die11 = [ 100.000, overlord_die12 ] { self.nextthink = (time + 0.050); };
void() overlord_die12 = [ 101.000, overlord_die13 ] { self.nextthink = (time + 0.050); };
void() overlord_die13 = [ 102.000, overlord_die14 ] { self.nextthink = (time + 0.050); };
void() overlord_die14 = [ 103.000, overlord_die15 ] { self.nextthink = (time + 0.050); };
void() overlord_die15 = [ 104.000, overlord_die16 ] { self.nextthink = (time + 0.050); };
void() overlord_die16 = [ 105.000, overlord_die17 ] { self.nextthink = (time + 0.050); };
void() overlord_die17 = [ 106.000, overlord_die18 ] {
	self.model = "";
	T_RadiusDamage(self,self,80,world,DAMAGEALL); // PM:  Old code didn't have splash damage, which is silly if the lesser wraths have it but their lords don't.  So go boom once.
	Tent_Explosion2(self.origin,0,4);
	ol_toss ("progs/drake/s_wrtgb2.mdl");
	ol_toss ("progs/drake/s_wrtgb3.mdl");
	ol_toss ("progs/rogue/wrthgib1.mdl");
	ol_toss ("progs/rogue/wrthgib2.mdl");
	ol_toss ("progs/rogue/wrthgib3.mdl");
	self.nextthink = (time + 0.100);
};

void() overlord_die18 = [ 107.000, overlord_die19 ] { // [FUNCTION]
   Tent_Explosion2(self.origin,0,4);
   ThrowGib(1,2);
   ThrowGib(2,2);
   ThrowGib(3,2);
   self.nextthink = (time + 0.100);
};

void() overlord_die19 = [ 107.000, overlord_die19 ] { // [FUNCTION]
   Tent_Explosion2(self.origin,0,4);
   ThrowGib(1,2);
   ThrowGib(2,2);
   ThrowGib(3,2);
   entity_remove(self,0.1);
};

void() monster_super_wrath_precache = { // [FUNCTION]
	precache_model("progs/rogue/s_wrath.mdl");
	precache_model("progs/ad171/mon_wraith_glow.mdl");
	precache_model(MODEL_PROJ_WTRAIL);		// Hitscan blood bolt
	precache_model(MODEL_PROJ_WBALL);
	precache_model(SBURST_FLAME); // Flames
	precache_model("progs/drake/s_wrtgb2.mdl");
	precache_model("progs/drake/s_wrtgb3.mdl");
	precache_model("progs/rogue/wrthgib1.mdl");
	precache_model("progs/rogue/wrthgib2.mdl");
	precache_model("progs/rogue/wrthgib3.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_model("progs/drake/w_ball.mdl");
	precache_sound("rogue/wrath/wsee.wav");
	precache_sound("rogue/wrath/watt.wav");
	precache_sound("rogue/wrath/wpain.wav");
	precache_sound("rogue/wrath/wdthc.wav");
	precache_sound("rogue/s_wrath/smash.wav");
};

void() monster_super_wrath = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

	self.mdl = "progs/rogue/s_wrath.mdl";
	self.gib1mdl = "progs/rogue/wrthgib1.mdl";
	self.gib2mdl = "progs/rogue/wrthgib2.mdl";
	self.gib3mdl = "progs/rogue/wrthgib3.mdl";
	self.pain_sound = "rogue/wrath/wpain.wav";
	self.weaponglow = "progs/ad171/mon_wraith_glow.mdl";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_WIDE;
	if (self.health < 1) self.health = 1000.000;
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	self.gibbed = FALSE;				// not falling apart
	self.pain_flinch = 70;				// High pain threshold
	self.blockudeath = TRUE;			// no humanoid death sound
	self.height = MONAI_ABOVEDIST;		// Enemytarget distance above
	self.pain_finished = FALSE;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.th_stand = overlord_stand1;
	self.th_walk = overlord_walk01;
	self.th_run = overlord_run01;
	self.th_missile = overlord_missile;
	self.th_melee = overlord_melee;
	self.th_pain = overlord_pain;
	self.th_die = overlord_die02;
	self.classtype = CT_MONWRATHOVERLORD;
	self.classgroup = CG_SPIDER;
	self.classmove = MON_MOVEFLY;
	if (self.deathstring == "")  self.deathstring = " was obliterated by a Wrath Overlord\n";
	monster_start();
};

//============
// --> QUAKED info_overlord_destination (.5 .5 .5) (-8 -8 -8) (8 8 32) 
// This is the destination marker for the overlord.
//
// It does not require any other fields filled in.
//============
void() info_overlord_destination = { // [ENTITY]
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.model = "";
	self.origin = (self.origin + '0.000 0.000 27.000');
};