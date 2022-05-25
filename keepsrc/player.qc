//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All
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
// Entity count: 0
// Function count: 297
//
// Implements: Player Model Animation and Weapon Firing Passthrough
//
// Description:
// Animation frames for the player's model visible by others and for the view
// model visible by self of the currently held weapon along with firing code
// timed with the animation.
//=============================================================================

// Updated player idle/fire weapon frame logic to be consistent.  Bug highlighted by Stas "dwere" Kuznetsov
float IDLE_WEAPON_FRAME = 0; // Default idle state
float FIRE_WEAPON_FRAME = 1; // Start of firing frames

void(float altfoot) monster_footstep;
void() player_grapple4;
void() player_grapple5;
void (float tomefinTime) W_FireThunderbolt;
void(float cnt, float ox) W_FireLavaSpikes;
void() W_FireProximityGrenade;
void() misc_bubble_bob;

float() frame_pause = { return (intermission_running > 0 || cinematic_running > 0 || cutscene); }; // [FUNCTION]

// Grapple
void() player_grapple1 =[114,player_grapple2] { if (frame_pause()) return; self.weaponframe = 1; W_FireGrapple(); }; // [FUNCTION]
void() player_grapple2 =[111,player_grapple3] { if (frame_pause()) return; self.weaponframe = 2; }; // [FUNCTION]
void() player_grapple3 =[116,player_grapple3] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe = 2;
    if (!self.hook || self.hook.count) {player_grapple5(); return;} // Done.
    if (vlen(self.hook.origin - self.origin) >= HOOK_NEAR && self.hook.state && Grapple_Pull_Me()) player_grapple4(); // Time to fly.
};
void() player_grapple4 =[ 73, player_grapple4 ] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe = 2;
    if (!self.hook || self.hook.count) {player_grapple5(); return;}   // Done.
    if ((vlen(self.hook.origin - self.origin) < HOOK_NEAR) || !self.hook.state) {player_grapple3(); return;}
    if (!Grapple_Pull_Me()) player_grapple3(); // Did target gain weight all of a sudden?
};
void() player_grapple5 =[ 112, player_run   ] { if (frame_pause()) return; self.weaponframe = 1; }; // [FUNCTION]

// Axe
// Frame 0 - Idle LOW
// Frame 1 - Idle HIGH
// Axe A 	Original - 1,2,3,4		New - 3,4,5,7			a3,a4,a5,a7
// Axe B	Original - 5,6,7,8		New - 10,11,13,14		b3,b4,b6,b7
// Axe C	Original - 1,2,3,4		New - 17,18,20,21		c3,c4,c6,c7
// Axe D	Original - 5,6,7,8		New - 24,25,26,28		d3,d4,d5,d7
// Axe E	Original - x,x,x,x		New - 31,32,34,35		e3,e4,e6,e7
void()	player_axe1 =	[119, player_axe2	] {if (!frame_pause()) self.weaponframe=1;}; // [FUNCTION]
void()	player_axe2 =	[120, player_axe3	] {if (!frame_pause()) self.weaponframe=2;}; // [FUNCTION]
void()	player_axe3 =	[121, player_axe4	] {if (!frame_pause()) self.weaponframe=3;W_FireAxe();}; // [FUNCTION]
void()	player_axe4 =	[122, player_run	] {if (!frame_pause()) self.weaponframe=4;}; // [FUNCTION]

void()	player_axeb1 =	[125, player_axeb2	] {if (!frame_pause()) self.weaponframe=5;}; // [FUNCTION]
void()	player_axeb2 =	[126, player_axeb3	] {if (!frame_pause()) self.weaponframe=6;}; // [FUNCTION]
void()	player_axeb3 =	[127, player_axeb4	] {if (!frame_pause()) self.weaponframe=7;W_FireAxe();}; // [FUNCTION]
void()	player_axeb4 =	[128, player_run	] {if (!frame_pause()) self.weaponframe=8;}; // [FUNCTION]

void()	player_axec1 =	[131, player_axec2	] {if (!frame_pause()) self.weaponframe=9;}; // [FUNCTION]
void()	player_axec2 =	[132, player_axec3	] {if (!frame_pause()) self.weaponframe=10;}; // [FUNCTION]
void()	player_axec3 =	[133, player_axec4	] {if (!frame_pause()) self.weaponframe=11;W_FireAxe();}; // [FUNCTION]
void()	player_axec4 =	[134, player_run	] {if (!frame_pause()) self.weaponframe=12;}; // [FUNCTION]

void()	player_axed1 =	[137, player_axed2	] {if (!frame_pause()) self.weaponframe=13;}; // [FUNCTION]
void()	player_axed2 =	[138, player_axed3	] {if (!frame_pause()) self.weaponframe=14;}; // [FUNCTION]
void()	player_axed3 =	[139, player_axed4	] {if (!frame_pause()) self.weaponframe=15;W_FireAxe();}; // [FUNCTION]
void()	player_axed4 =	[140, player_run	] {if (!frame_pause()) self.weaponframe=16;}; // [FUNCTION]

void()	player_axee1 =	[137, player_axee2	] {if (!frame_pause()) self.weaponframe=17;}; // [FUNCTION]
void()	player_axee2 =	[138, player_axee3	] {if (!frame_pause()) self.weaponframe=18;}; // [FUNCTION]
void()	player_axee3 =	[139, player_axee4	] {if (!frame_pause()) self.weaponframe=19;W_FireAxe();}; // [FUNCTION]
void()	player_axee4 =	[140, player_run	] {if (!frame_pause()) self.weaponframe=20;}; // [FUNCTION]

void () player_axeoldc1 = [ 131.000, player_axeoldc2 ] {if (!frame_pause())  self.weaponframe = 1; }; // [FUNCTION]
void () player_axeoldc2 = [ 132.000, player_axeoldc3 ] {if (!frame_pause())  self.weaponframe = 2; }; // [FUNCTION]
void () player_axeoldc3 = [ 133.000, player_axeoldc4 ] {if (!frame_pause())  self.weaponframe = 3; W_FireAxe(); }; // [FUNCTION]
void () player_axeoldc4 = [ 134.000, player_run ] 	   {if (!frame_pause())  self.weaponframe = 4; }; // [FUNCTION]

void () player_axeoldd1 = [ 137.000, player_axeoldd2 ] {if (!frame_pause())  self.weaponframe = 5; }; // [FUNCTION]
void () player_axeoldd2 = [ 138.000, player_axeoldd3 ] {if (!frame_pause())  self.weaponframe = 6; }; // [FUNCTION]
void () player_axeoldd3 = [ 139.000, player_axeoldd4 ] {if (!frame_pause())  self.weaponframe = 7; W_FireAxe(); }; // [FUNCTION]
void () player_axeoldd4 = [ 140.000, player_run ]	   {if (!frame_pause())  self.weaponframe = 8; }; // [FUNCTION]

// Mjolnir
void(float fr, float wf) playham_frame = { // [FUNCTION]
	if (frame_pause()) return;

    self.frame = fr;
    if (wf) self.weaponframe=wf;
    else {
        if (self.attack_finished <= time + 0.1) self.weaponframe=0;
        else self.weaponframe=4;
    }
};

// Chainsaw
void() player_saw1 =[ 26, player_saw2 ] {if (!frame_pause()) self.weaponframe = 5; Attack_Saw();}; // [FUNCTION]
void() player_saw2 =[ 27, player_saw3 ] { // [FUNCTION]
	if (!frame_pause()) playham_frame(27,2);
    if (!self.button0) {player_run (); return;}
};
void() player_saw3 =[ 105, player_saw4 ] {if (!frame_pause()) playham_frame(26,3); Attack_Saw();}; // [FUNCTION]
void() player_saw4 =[ 106, player_saw5 ] { // [FUNCTION]
	if (!frame_pause()) playham_frame(27,4);
    if (!self.button0) {player_run ();return;}
};
void() player_saw5 =[ 105, player_saw6 ] {if (!frame_pause()) playham_frame(26,5); Attack_Saw();}; // [FUNCTION]
void() player_saw6 =[ 106, player_run  ] {if (!frame_pause()) playham_frame(27,6);}; // [FUNCTION]

// Standing
void() player_stand1 =[17,player_stand1] { // [FUNCTION]
	if (frame_pause()) return; // Stop if intermission/cinematic running
	
	self.weaponframe = IDLE_WEAPON_FRAME; // Get out of any weapon animation
	if (self.velocity_x || self.velocity_y) { self.walkframe=0; player_run(); return; }

	if (self.weapon == IT_AXE && !self.selfweaponismoditems) {
		if (self.walkframe >= 12) self.walkframe = 0;
		self.frame = 17 + self.walkframe;
	} else {
		if (self.weaponmodel == "") { // Using playham0 hamout model.
			if (self.walkframe >= 12) self.walkframe = 0;
			self.frame = 6 + self.walkframe;
		} else {
			if (self.walkframe >= 5) self.walkframe = 0;
			self.frame = 12 + self.walkframe;
		}
	}
	self.walkframe = self.walkframe + 1;	
};

// Running
void() player_run =[ 6, player_run ] { // [FUNCTION]
	if (frame_pause()) return; // Stop if intermission/cinematic running

	if (self.in_a_vehicle) {
		if (self.idletimer <= time) { // Reuse saw idle time for engine noises
			sound (self, CHAN_AUTO, "zerstorer/weapons/sawridle.wav", 0.5, ATTN_NORM);
			self.idletimer = time + 0.5;
		}		
		return;
	}

	self.weaponframe = IDLE_WEAPON_FRAME; // Get out of any weapon animation
	if (!self.velocity_x && !self.velocity_y) { // Standing around has different animation sets
		self.walkframe = 0;
		player_stand1();
		return;
	}

	if (self.weapon == IT_AXE && !self.selfweaponismoditems) {
		if (self.perms & IT_CHAINSAW) { // Check for chainsaw first because it needs a different player model.
			if (self.idletimer <= time) { // In Zerstorer, when the fifth idle frame was reached, the frame looped back to the first and the saw idle sound was played.
				if (self.view_ofs != '0 0 0') { // Volume used to be 1, but Tronyn et.al. wanted it quieter.  Pity, it was fun loud.
					sound (self, CHAN_AUTO, "zerstorer/weapons/sawridle.wav", 0.5, ATTN_NORM);
					self.idletimer = time + 0.5; // In Drake, the frames are grouped, so play sound periodically.
				}
			}
			if (self.walkframe >= 5) self.walkframe = 0;	
			self.walkframe = self.walkframe + 1;
			return;
		} else { // Standard player model with axe.
			if (self.walkframe >= 6) self.walkframe = 0; 
			self.frame = 0 + self.walkframe;
		}
	} else {
		if (self.weapon == IT2_GRAPPLE && !self.selfweaponismoditems) {
            if (self.hook && self.hook.count) self.weaponframe = 1;   // Hook is still out.
		}
		if (self.walkframe >= 6) self.walkframe = 0; // Same as playham0 or playham so no need to check if no weapon or if mjolnir held or thrown.
		self.frame = self.frame + self.walkframe;
	}
	
	// Check for player feet sound, using velocity & ground flag
	if ((self.walkframe == 2 || self.walkframe == 5) && (self.flags & FL_ONGROUND)) {
		self.cnt = fabs(self.velocity_x + self.velocity_y);
		if (self.cnt > 50) monster_footstep(FALSE); // Need to be moving before feet sounds
	}

	self.walkframe = self.walkframe + 1; // Update frame
};

void() player_run_nofeet =[ 6, player_run ] { // [FUNCTION]
	if (frame_pause()) return; // Stop if intermission/cinematic running
	
	self.weaponframe = IDLE_WEAPON_FRAME; // Get out of any weapon animation
	if (!self.velocity_x && !self.velocity_y) { self.walkframe = 0; player_stand1(); return; } // Standing around has different animation sets

	// make sure correct player animation active
	if (self.weapon == IT_AXE && !self.selfweaponismoditems) {
		if (self.walkframe >= 6) self.walkframe = 0;
		self.frame = self.walkframe;
	} else {
		if (self.walkframe >= 6) self.walkframe = 0;
		self.frame = self.frame + self.walkframe;
	}

	self.walkframe = self.walkframe + 1; // Update frame
};

void(entity targ) remoteplayer_run = { // [FUNCTION]
	local entity tself;
	tself = self; self = targ;
	// This has to run the block above otherwise weaponframe errors

	// The above code cannot be pasted into this function
	// Be careful with this function, it needs a certain layout!
	player_run_nofeet();
	self = tself;
};

// Shotgun
void()	player_sgreset = [113, player_sg2] {if (frame_pause()) return; self.weaponframe = FIRE_WEAPON_FRAME; }; // [FUNCTION]

void()	player_sg1 =	[113, player_sg1	] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe=IDLE_WEAPON_FRAME;
	if (!self.button0) { player_run(); return; }
	W_FireShotgun ();
};
void()	player_sg2 =	[114, player_sg3	] { if (!frame_pause()) self.weaponframe=2; }; // [FUNCTION]
void()	player_sg3 =	[115, player_sg4	] { if (!frame_pause()) self.weaponframe=3; }; // [FUNCTION]
void()	player_sg4 =	[116, player_sg5	] { if (!frame_pause()) self.weaponframe=4; }; // [FUNCTION]
void()	player_sg5 =	[117, player_sg1	] { if (!frame_pause()) self.weaponframe=5; }; // [FUNCTION]

// Airfist fire animation.
// For the external view we use the rocket fire animation with the recoil part lengthened.
void() player_airgun1   =[107, player_airgun2  ] { if (!frame_pause()) self.weaponframe=1;}; // [FUNCTION]
void() player_airgun2   =[108, player_airgun3  ] { if (!frame_pause()) self.weaponframe=2;}; // [FUNCTION]
void() player_airgun3   =[109, player_airgun4  ] { if (!frame_pause()) self.weaponframe=3;}; // [FUNCTION]
void() player_airgun4   =[109, player_airgun5  ] { if (!frame_pause()) self.weaponframe=4;}; // [FUNCTION]
void() player_airgun5   =[110, player_airgun6  ] { if (!frame_pause()) self.weaponframe=5;}; // [FUNCTION]
void() player_airgun6   =[110, player_airgun7  ] { if (!frame_pause()) self.weaponframe=6;}; // [FUNCTION]
void() player_airgun7   =[111, player_airgun8  ] { if (!frame_pause()) self.weaponframe=7;}; // [FUNCTION]
void() player_airgun8   =[112, player_run  ] { if (!frame_pause()) self.weaponframe = 7;}; // [FUNCTION]

// Airfist failed fire animation.
// For the external view we use the nail gun fire animation.
void() player_failedairgun1   =[103, player_failedairgun2  ] { if (!frame_pause()) self.weaponframe=6;}; // [FUNCTION]
void() player_failedairgun2   =[104, player_failedairgun3  ] { if (!frame_pause()) self.weaponframe=7;}; // [FUNCTION]
void() player_failedairgun3   =[104, player_run  ] { if (!frame_pause()) self.weaponframe=7;}; // [FUNCTION]

void()	player_ssgreset =	[113, player_supersg2	] { if (!frame_pause()) self.weaponframe=1;}; // [FUNCTION]

void()	player_supersg1 =	[113, player_supersg2	] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe=1;
	if (!self.button0) { player_run(); return; }
	W_FireSuperShotgun ();
};
void()	player_supersg2 =	[114, player_supersg3	] { if (!frame_pause())  self.weaponframe=2; }; // [FUNCTION]
void()	player_supersg3 =	[115, player_supersg4	] { if (!frame_pause())  self.weaponframe=3; }; // [FUNCTION]
void()	player_supersg4 =	[116, player_supersg5	] { if (!frame_pause())  self.weaponframe=4; }; // [FUNCTION]
void()	player_supersg5 =	[117, player_supersg6	] { if (!frame_pause())  self.weaponframe=5; }; // [FUNCTION]
void()	player_supersg6 =	[118, player_supersg1	] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe=6;
	if (self.ammo_shells < 2) forceweaponswitch(0.2);// If player has one shell left, switch to SG after SSG fire animation
};

// Nailgun
void(float oframe, float ox) nail_upd = { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe > 8) self.weaponframe = 0;
	W_FireSpikes (0,ox);
};

void() player_nail1 = [self.weaponframe, player_nail2 ] {nail_upd(1,2);}; // [FUNCTION]
void() player_nail2 = [self.weaponframe, player_nail3 ] {nail_upd(2,-2);}; // [FUNCTION]
void() player_nail3 = [self.weaponframe, player_nail4 ] {nail_upd(3,2);}; // [FUNCTION]
void() player_nail4 = [self.weaponframe, player_nail5 ] {nail_upd(4,-2);}; // [FUNCTION]
void() player_nail5 = [self.weaponframe, player_nail6 ] {nail_upd(5,2);}; // [FUNCTION]
void() player_nail6 = [self.weaponframe, player_nail7 ] {nail_upd(6,-2);}; // [FUNCTION]
void() player_nail7 = [self.weaponframe, player_nail8 ] {nail_upd(7,2);}; // [FUNCTION]
void() player_nail8 = [self.weaponframe, player_nail1 ] {nail_upd(8,-2);}; // [FUNCTION]

// Lava Nailgun
void(float oframe, float ox) lava_nail_upd = { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe > 8) self.weaponframe = 0;
	W_FireLavaSpikes (0,ox);
};

void() player_lava_nail1 = [self.weaponframe, player_lava_nail2 ] {lava_nail_upd(1,2);}; // [FUNCTION]
void() player_lava_nail2 = [self.weaponframe, player_lava_nail3 ] {lava_nail_upd(2,-2);}; // [FUNCTION]
void() player_lava_nail3 = [self.weaponframe, player_lava_nail4 ] {lava_nail_upd(3,2);}; // [FUNCTION]
void() player_lava_nail4 = [self.weaponframe, player_lava_nail5 ] {lava_nail_upd(4,-2);}; // [FUNCTION]
void() player_lava_nail5 = [self.weaponframe, player_lava_nail6 ] {lava_nail_upd(5,2);}; // [FUNCTION]
void() player_lava_nail6 = [self.weaponframe, player_lava_nail7 ] {lava_nail_upd(6,-2);}; // [FUNCTION]
void() player_lava_nail7 = [self.weaponframe, player_lava_nail8 ] {lava_nail_upd(7,2);}; // [FUNCTION]
void() player_lava_nail8 = [self.weaponframe, player_lava_nail1 ] {lava_nail_upd(8,-2);}; // [FUNCTION]

// Super Nailgun
// I really liked the idea of saving the frame number of the SNG
// so that when it stops/starts it remembers where it left off
// - SNG projectile offset idea by Kinn
void(float oframe, float oz, float ox) snail_upd = { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe > 8) self.weaponframe = 0;
	W_FireSpikes (oz,ox);
};

void() player_snail1 = [self.weaponframe, player_snail2 ] {snail_upd(1,8,2.5);}; // [FUNCTION]
void() player_snail2 = [self.weaponframe, player_snail3 ] {snail_upd(2,5.5,-3.5);}; // [FUNCTION]
void() player_snail3 = [self.weaponframe, player_snail4 ] {snail_upd(3,3,2.5);}; // [FUNCTION]
void() player_snail4 = [self.weaponframe, player_snail5 ] {snail_upd(4,9,0);}; // [FUNCTION]
void() player_snail5 = [self.weaponframe, player_snail6 ] {snail_upd(5,3,-2.5);}; // [FUNCTION]
void() player_snail6 = [self.weaponframe, player_snail7 ] {snail_upd(6,5.5,3.5);}; // [FUNCTION]
void() player_snail7 = [self.weaponframe, player_snail8 ] {snail_upd(7,8,-2.5);}; // [FUNCTION]
void() player_snail8 = [self.weaponframe, player_snail1 ] {snail_upd(8,2,0);}; // [FUNCTION]

// Lava Super Nailgun
void(float oframe, float oz, float ox) lava_snail_upd = { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe > 8) self.weaponframe = 0;
	W_FireLavaSpikes (oz,ox);
};

void() player_lava_snail1 = [self.weaponframe, player_lava_snail2 ] {lava_snail_upd(1,8,2.5);}; // [FUNCTION]
void() player_lava_snail2 = [self.weaponframe, player_lava_snail3 ] {lava_snail_upd(2,5.5,-3.5);}; // [FUNCTION]
void() player_lava_snail3 = [self.weaponframe, player_lava_snail4 ] {lava_snail_upd(3,3,2.5);}; // [FUNCTION]
void() player_lava_snail4 = [self.weaponframe, player_lava_snail5 ] {lava_snail_upd(4,9,0);}; // [FUNCTION]
void() player_lava_snail5 = [self.weaponframe, player_lava_snail6 ] {lava_snail_upd(5,3,-2.5);}; // [FUNCTION]
void() player_lava_snail6 = [self.weaponframe, player_lava_snail7 ] {lava_snail_upd(6,5.5,3.5);}; // [FUNCTION]
void() player_lava_snail7 = [self.weaponframe, player_lava_snail8 ] {lava_snail_upd(7,8,-2.5);}; // [FUNCTION]
void() player_lava_snail8 = [self.weaponframe, player_lava_snail1 ] {lava_snail_upd(8,2,0);}; // [FUNCTION]

void() player_plasma1   =[105, player_plasma2  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 5) self.weaponframe = FIRE_WEAPON_FRAME;
	W_FirePlasma();
};
void() player_plasma2   =[106, player_plasma1  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 5) self.weaponframe = FIRE_WEAPON_FRAME;
	W_FirePlasma();
};

void() player_light1   =[105, player_light2  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 5) self.weaponframe = FIRE_WEAPON_FRAME;
	W_FireLightning();
};
void() player_light2   =[106, player_light1  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 5) self.weaponframe = FIRE_WEAPON_FRAME;
	W_FireLightning();
};

// Shaft
void() player_tbolt = { // [FUNCTION]
    self.effects = self.effects | EF_MUZZLEFLASH;

    if (!self.button0 || (frame_pause())) {player_run ();  return;}

    self.weaponframe = self.weaponframe + 1;
    if (self.weapon == IT2_CHAINLIGHTNING && !self.selfweaponismoditems) {
		if (self.weaponframe == 17) self.weaponframe = FIRE_WEAPON_FRAME;
    } else {
		if (self.weaponframe == 5) self.weaponframe = FIRE_WEAPON_FRAME;
    }
    SuperDamageSound ();

	if (self.tome_finished) W_FireThunderbolt (TRUE);
	else					W_FireThunderbolt (FALSE);

	W_Reload(0.2);
};

void() player_chainlight1   =[105, player_chainlight2  ] {player_tbolt();}; // [FUNCTION]
void() player_chainlight2   =[106, player_chainlight3  ] { // [FUNCTION]
    if ((self.weapon != IT2_CHAINLIGHTNING)) self.think = player_chainlight1;     // Do before damage.
    player_tbolt();
};
void() player_chainlight3   =[106, player_chainlight1  ] {player_tbolt();}; // [FUNCTION]

void() player_plasmalight1   =[105, player_plasmalight1  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe >= 5) self.weaponframe = 1;
	W_FirePlasmaGun();
};

void() player_rockreset =[107,player_rocket2] { if (!frame_pause()) self.weaponframe=FIRE_WEAPON_FRAME; }; // [FUNCTION]

void() player_rocket1 =[107,player_rocket2] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe=FIRE_WEAPON_FRAME;
	W_FireRocket();
};
void() player_rocket2   =[108, player_rocket3  ] { if (!frame_pause())  self.weaponframe=2;}; // [FUNCTION]
void() player_rocket3   =[109, player_rocket4  ] { if (!frame_pause())  self.weaponframe=3;}; // [FUNCTION]
void() player_rocket4   =[110, player_rocket5  ] { if (!frame_pause())  self.weaponframe=4;}; // [FUNCTION]
void() player_rocket5   =[111, player_rocket6  ] { if (!frame_pause())  self.weaponframe=5;}; // [FUNCTION]
void() player_rocket6   =[112, player_rocket1  ] { if (!frame_pause())  self.weaponframe=6;}; // [FUNCTION]

void() player_multi_rocket1   =[107, player_multi_rocket2  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe=1;
	W_FireMultiRocket();
};
void() player_multi_rocket2   =[108, player_multi_rocket3  ] { if (!frame_pause())   self.weaponframe=2;}; // [FUNCTION]
void() player_multi_rocket3   =[109, player_multi_rocket4  ] { if (!frame_pause())   self.weaponframe=3;}; // [FUNCTION]
void() player_multi_rocket4   =[110, player_multi_rocket5  ] { if (!frame_pause())   self.weaponframe=4;}; // [FUNCTION]
void() player_multi_rocket5   =[111, player_multi_rocket6  ] { if (!frame_pause())   self.weaponframe=5;}; // [FUNCTION]
void() player_multi_rocket6   =[112, player_multi_rocket1  ] { if (!frame_pause())   self.weaponframe=6;}; // [FUNCTION]

// Same as player_rock* except weaponframe stays at 0.  This is because the stinger viewmodel only has one frame.
// Update 9/5/09:  Spawn another entity for muzzleflash to bypass Qrack flash.
void() player_bfg1 =[ 107, player_bfg2  ] { if (!frame_pause()) self.effects = self.effects | EF_MUZZLEFLASH; }; // [FUNCTION]
void() player_bfg2 =[ 108, player_bfg3  ] {}; // [FUNCTION]
void() player_bfg3 =[ 109, player_bfg4  ] {}; // [FUNCTION]
void() player_bfg4 =[ 110, player_bfg5  ] {}; // [FUNCTION]
void() player_bfg5 =[ 111, player_bfg6  ] {}; // [FUNCTION]
void() player_bfg6 =[ 112, player_run   ] {}; // [FUNCTION]

void() player_grenreset   =[107, player_grenade2  ] { // [FUNCTION] 
	if (!frame_pause()) self.weaponframe=FIRE_WEAPON_FRAME;
};


void() player_grenade1   =[107, player_grenade2  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe=IDLE_WEAPON_FRAME;
	W_FireGrenade();
};
void() player_grenade2   =[108, player_grenade3  ] { if (!frame_pause())  self.weaponframe=2;}; // [FUNCTION]
void() player_grenade3   =[109, player_grenade4  ] { if (!frame_pause())  self.weaponframe=3;}; // [FUNCTION]
void() player_grenade4   =[110, player_grenade5  ] { if (!frame_pause())  self.weaponframe=4;}; // [FUNCTION]
void() player_grenade5   =[111, player_grenade6  ] { if (!frame_pause())  self.weaponframe=5;}; // [FUNCTION]
void() player_grenade6   =[112, player_grenade1  ] { if (!frame_pause())  self.weaponframe=6;}; // [FUNCTION]

void() player_prox_grenade1   =[107, player_prox_grenade2  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe=IDLE_WEAPON_FRAME;
	W_FireProximityGrenade();
};
void() player_prox_grenade2   =[108, player_prox_grenade3  ] { if (!frame_pause())  self.weaponframe=2;}; // [FUNCTION]
void() player_prox_grenade3   =[109, player_prox_grenade4  ] { if (!frame_pause())  self.weaponframe=3;}; // [FUNCTION]
void() player_prox_grenade4   =[110, player_prox_grenade5  ] { if (!frame_pause())  self.weaponframe=4;}; // [FUNCTION]
void() player_prox_grenade5   =[111, player_prox_grenade6  ] { if (!frame_pause())  self.weaponframe=5;}; // [FUNCTION]
void() player_prox_grenade6   =[112, player_prox_grenade1  ] { if (!frame_pause())  self.weaponframe=6;}; // [FUNCTION]

void() player_multi_grenade1   =[107, player_multi_grenade2  ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) { player_run(); return; }

	self.weaponframe=IDLE_WEAPON_FRAME;
	W_FireMultiGrenade();
};
void() player_multi_grenade2   =[108, player_multi_grenade3  ] { if (!frame_pause()) self.weaponframe=2;}; // [FUNCTION]
void() player_multi_grenade3   =[109, player_multi_grenade4  ] { if (!frame_pause()) self.weaponframe=3;}; // [FUNCTION]
void() player_multi_grenade4   =[110, player_multi_grenade5  ] { if (!frame_pause()) self.weaponframe=4;}; // [FUNCTION]
void() player_multi_grenade5   =[111, player_multi_grenade6  ] { if (!frame_pause()) self.weaponframe=5;}; // [FUNCTION]
void() player_multi_grenade6   =[112, player_multi_grenade1  ] { if (!frame_pause()) self.weaponframe=6;}; // [FUNCTION]

void() player_crossbow1  =[1, player_crossbow2] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) {player_run(); return; }

	self.weaponframe = 1;
	if (self.ammo_poison > 0) W_Fire_Crossbow_Poison();
	else W_Fire_Crossbow();
};
void() player_crossbow2  =[2, player_crossbow3] { if (!frame_pause()) self.weaponframe = 2;}; // [FUNCTION]
void() player_crossbow3  =[3, player_crossbow4] { if (!frame_pause()) self.weaponframe = 3;}; // [FUNCTION]
void() player_crossbow4  =[4, player_crossbow5] { if (!frame_pause()) self.weaponframe = 4;}; // [FUNCTION]
void() player_crossbow5  =[5, player_crossbow6] { if (!frame_pause()) self.weaponframe = 5;}; // [FUNCTION]
void() player_crossbow6  =[6, player_crossbow7] { if (!frame_pause()) self.weaponframe = 6;}; // [FUNCTION]
void() player_crossbow7  =[0, player_crossbow8] { if (!frame_pause()) self.weaponframe = 0;}; // [FUNCTION]
void() player_crossbow8  =[0, player_crossbow1] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe = 0;
	if (self.ammo_poison < 1) W_SetCurrentAmmo(self);
};

// Asgard ARbalest
void() player_xbow1 =[105,player_xbow2] { // [FUNCTION]
	if (frame_pause()) return;

	self.weaponframe=1;
    if (self.tome_finished) sound (self, CHAN_WEAPON, "drake/necro/att_a2.wav", 1, ATTN_NORM);
    else sound (self, CHAN_WEAPON, "drake/necro/att_a.wav", 1, ATTN_NORM);
};
void() player_xbow2 =[106,player_xbow3] { if (frame_pause()) return; self.weaponframe=2; W_FireIceCrossbow ();}; // [FUNCTION]
void() player_xbow3 =[106,player_run] { if (frame_pause()) return; self.weaponframe=3; sound (self, CHAN_WEAPON, "drake/weapons/xbowdraw.wav", 1, ATTN_IDLE);}; // [FUNCTION]

// Mjolnir
void() player_hammer4t =[ 122,  player_hammer5  ] { playham_frame(35,4);}; // [FUNCTION]
void() player_mjolnir4t=[ 134, player_mjolnir5 ] { playham_frame(41,4);}; // [FUNCTION]

void () player_hammer1 = [ 32.000, player_hammer2 ] { playham_frame(32,1); self.nextthink = time + 0.05;}; // [FUNCTION]
void () player_hammer2 = [ 33.000, player_hammer3 ] { playham_frame(33,2); self.nextthink = time + 0.05;}; // [FUNCTION]
void () player_hammer3 = [ 34.000, player_hammer4 ] { // [FUNCTION]
	if (frame_pause()) return;

	playham_frame(34,3);
	if (HIP_ThrowMjolnir()) self.think = player_hammer4t; // TRUE if the hammer hits something or gets thrown.
	self.nextthink = time + 0.05;
};
void () player_hammer4 = [ 35.000, player_hammer5 ] { if (!frame_pause()) playham_frame(35,4); self.nextthink = time + 0.05; W_FireMjolnir ();}; // [FUNCTION]
void () player_hammer5 = [ 36.000, player_hammer6 ] { if (!frame_pause()) playham_frame(36,4); self.nextthink = time + 0.05;}; // [FUNCTION]
void () player_hammer6 = [ 37.000, player_run ] { if (!frame_pause()) playham_frame(37,0); self.nextthink = time + 0.05; }; // [FUNCTION]

void () player_mjolnir1 = [ 38.000, player_mjolnir2 ] { if (!frame_pause()) playham_frame(38,1); }; // [FUNCTION]
void () player_mjolnir2 = [ 39.000, player_mjolnir3 ] { if (!frame_pause()) playham_frame(39,2); }; // [FUNCTION]
void () player_mjolnir3 = [ 40.000, player_mjolnir4 ] { // [FUNCTION]
	if (frame_pause()) return;

	playham_frame(40,3);
	if (HIP_ThrowMjolnir()) self.think = player_mjolnir4t; // TRUE if the hammer hits something or gets thrown.
};
void () player_mjolnir4 = [ 41.000, player_mjolnir5 ] { if (frame_pause()) return; playham_frame(41,4); W_FireMjolnir();}; // [FUNCTION]
void () player_mjolnir5 = [ 42.000, player_mjolnir6 ] { playham_frame(42,4); }; // [FUNCTION]
void () player_mjolnir6 = [ 43.000, player_run ] { playham_frame(43,0);}; // [FUNCTION]

void () player_laser1 = [ 103.000, player_laser3 ] { // [FUNCTION]
	if (frame_pause()) return;
	if (!self.button0) {player_run(); return; }

	W_Reload(0.1);
	self.weaponframe = 1;
	HIP_FireLaser(0);
};
void () player_laser2 = [ 104.000, player_laser3 ] { // [FUNCTION]
	if (frame_pause()) return;

	W_Reload(0.1); 
	self.weaponframe = 2;
};
void () player_laser3 = [ 104.000, player_laser1 ] { // [FUNCTION]
	if (frame_pause()) return;
   if (!self.button0) {player_run(); return; }

	W_Reload(0.1);
	self.weaponframe = 4;
	HIP_FireLaser(1);
};
void () player_laser4 = [ 103.000, player_laser1 ] { // [FUNCTION]
	if (frame_pause()) return;

	W_Reload(0.1);
	self.weaponframe = 5;
};

// LASER - - - - - -
// Sets up timings for blaster and auto shotgun.
void() player_startblast = {self.baha_time = time;  self.nextthink = time + 4/30;}; // [FUNCTION]

void(float fr) player_blaster = { // [FUNCTION]
    local float am;

    am = self.baha_time + 4/30;
    if (am < self.nextthink) am = self.nextthink;
    self.nextthink = self.baha_time = am;
	if (frame_pause()) return;
    self.weaponframe = fr;
	W_Reload(0.2);
    HIP_FireLaser(2);
};
void() player_blast1  =[ 103, player_blast2  ] {player_startblast(); player_blaster(1);}; // [FUNCTION]
void() player_blast2  =[ 104, player_blast3  ] { if (self.attack_finished < time) player_blaster(2);}; // [FUNCTION]
void() player_blast3  =[ 103, player_blast2  ] { if (self.attack_finished < time)player_blaster(1);}; // [FUNCTION]

// Magic wand from Drake
void() player_wand1 =[103, player_wand2 ] { if (!frame_pause()) self.weaponframe=1; self.effects = self.effects | EF_MUZZLEFLASH;}; // [FUNCTION]
void() player_wand2 =[104, player_wand3 ] { if (!frame_pause()) self.weaponframe=2;}; // [FUNCTION]
void() player_wand3 =[104, player_wand4 ] { if (!frame_pause()) self.weaponframe=3;}; // [FUNCTION]
void() player_wand4 =[104, player_wand5 ] { if (!frame_pause()) self.weaponframe=4;}; // [FUNCTION]
void() player_wand5 =[104, player_run   ] {if (!self.button0) player_run();}; // [FUNCTION]

// Only used for the player when they die.  Added check for extras_r4/r5 water volumes.
void() death_bubble_spawn = { // [FUNCTION]
	local entity bubble;
	local vector	tmp_vec_up;
	local float		tmp_forward;
	
	if (self.owner.waterlevel != 3 && !self.owner.infuncwater) return;
	
	bubble = spawn();
	bubble.classtype = CT_BUBBLE;
	bubble.classname = "bubble";
	bubble.solid = SOLID_NOT;
	bubble.movetype = MOVETYPE_NOCLIP;
	setmodel (bubble, SBUBBLE_DROWN);
	bubble.frame = bubble.cnt = 0;
	if (self.owner.flags & FL_CLIENT) {
		tmp_vec_up = self.owner.maxs * 0.5;
		tmp_vec_up_x = tmp_vec_up_y = 0;
		tmp_vec_up = self.owner.origin + tmp_vec_up;
		tmp_forward = self.owner.maxs_x * 0.5;
		makevectors(self.owner.angles);
		setorigin (bubble, tmp_vec_up + v_forward * tmp_forward);// pOx - moved this infront a bit
	} else {
		setorigin (bubble, self.owner.origin + '0 0 24');
	}
	setsize (bubble, '-8 -8 -8', '8 8 8');
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = misc_bubble_bob;
	self.nextthink = time + 0.1;
	self.think = death_bubble_spawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count) remove(self);
};

void(float num_bubbles) death_bubbles = { // [FUNCTION]
	local entity bubble_spawner;
	
	bubble_spawner = spawn();
	bubble_spawner.owner = self;
	bubble_spawner.air_finished = 0;
	bubble_spawner.bubble_count = num_bubbles;
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = death_bubble_spawn;
};

void() PainSound = { // [FUNCTION]
	if (self.health < 0) return;
	if (self.pain_finished > time) { self.axhitme = 0; return;	}

	// don't make multiple pain sounds right after each other
	self.pain_finished = time + 0.5;

	if (damage_attacker.classname == "teledeath") {
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
	} else if (self.watertype == CONTENT_WATER && self.waterlevel == 3) { // water pain sounds
		death_bubbles(1);
		if (random() > 0.5) sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
	} else if (self.watertype == CONTENT_SLIME) { // slime pain sounds
		// FIX ME	put in some steam here
		if (random() > 0.5) sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
	} else if (self.watertype == CONTENT_LAVA) {
		if (random() > 0.5) sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
	} else {
		// ax pain sound
		if (self.axhitme == 1) {
			self.axhitme = 0;
			sound (self, CHAN_VOICE, SOUND_AXE_PLAYER, 1, ATTN_NORM); // Player been hit by an axe (MP thing)
		} else {
			self.lip = rint((random() * 5) + 1);
			if (self.lip == 1) self.noise = "player/pain1.wav";
			else if (self.lip == 2) self.noise = "player/pain2.wav";
			else if (self.lip == 3) self.noise = "player/pain3.wav";
			else if (self.lip == 4) self.noise = "player/pain4.wav";
			else if (self.lip == 5) self.noise = "player/pain5.wav";
			else self.noise = "player/pain6.wav";

			sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		}
	}
};

void()	player_pain1 =	[35,	player_pain2	] {PainSound();self.weaponframe=0;}; // [FUNCTION]
void()	player_pain2 =	[36,	player_pain3	] {}; // [FUNCTION]
void()	player_pain3 =	[37,	player_pain4	] {}; // [FUNCTION]
void()	player_pain4 =	[38,	player_pain5	] {}; // [FUNCTION]
void()	player_pain5 =	[39,	player_pain6	] {}; // [FUNCTION]
void()	player_pain6 =	[40,	player_run	] {}; // [FUNCTION]

void()	player_axpain1 =	[29,	player_axpain2	] {PainSound();self.weaponframe=0;}; // [FUNCTION]
void()	player_axpain2 =	[30,	player_axpain3	] {}; // [FUNCTION]
void()	player_axpain3 =	[31,	player_axpain4	] {}; // [FUNCTION]
void()	player_axpain4 =	[32,	player_axpain5	] {}; // [FUNCTION]
void()	player_axpain5 =	[33,	player_axpain6	] {}; // [FUNCTION]
void()	player_axpain6 =	[34,	player_run	] {}; // [FUNCTION]

void() player_sawpain1 = [11, player_sawpain2] {PainSound();self.weaponframe=0;}; // [FUNCTION]
void() player_sawpain2 = [12, player_sawpain3] {}; // [FUNCTION]
void() player_sawpain3 = [13, player_sawpain4] {}; // [FUNCTION]
void() player_sawpain4 = [14, player_sawpain5] {}; // [FUNCTION]
void() player_sawpain5 = [15, player_sawpain6] {}; // [FUNCTION]
void() player_sawpain6 = [16, player_run] {}; // [FUNCTION]

void(entity inflictor, entity attacker, float damage) player_pain = { // [FUNCTION]
	if (self.weaponframe) return; // Already in a pain frame.
	if (self.invisible_finished > time || self.in_a_vehicle) return;		// Cars and eyes don't have pain frames.
	if (self.weapon == IT2_GRAPPLE && self.hook && !self.selfweaponismoditems) return; // No pain while the hook is out.

	if (self.weapon == IT_AXE && !self.selfweaponismoditems) { 
		if (self.perms & IT_CHAINSAW) player_sawpain1();
		else player_axpain1();
	}
	else player_pain1 ();
};

// Allow respawn after a certain time.
void() player_dead = { self.nextthink = -1; self.deadflag = DEAD_DEAD; }; // [FUNCTION]

void()	player_diea1	=	[50,player_diea2] {}; // [FUNCTION]
void()	player_diea2	=	[51,player_diea3] {}; // [FUNCTION]
void()	player_diea3	=	[52,player_diea4] {}; // [FUNCTION]
void()	player_diea4	=	[53,player_diea5] {}; // [FUNCTION]
void()	player_diea5	=	[54,player_diea6] {}; // [FUNCTION]
void()	player_diea6	=	[55,player_diea7] {}; // [FUNCTION]
void()	player_diea7	=	[56,player_diea8] {}; // [FUNCTION]
void()	player_diea8	=	[57,player_diea9] {}; // [FUNCTION]
void()	player_diea9	=	[58,player_diea10] {}; // [FUNCTION]
void()	player_diea10	=	[59,player_diea11] {}; // [FUNCTION]
void()	player_diea11	=	[60,player_diea11] {player_dead();}; // [FUNCTION]

void()	player_dieb1	=	[61,player_dieb2] {}; // [FUNCTION]
void()	player_dieb2	=	[62,player_dieb3] {}; // [FUNCTION]
void()	player_dieb3	=	[63,player_dieb4] {}; // [FUNCTION]
void()	player_dieb4	=	[64,player_dieb5] {}; // [FUNCTION]
void()	player_dieb5	=	[65,player_dieb6] {}; // [FUNCTION]
void()	player_dieb6	=	[66,player_dieb7] {}; // [FUNCTION]
void()	player_dieb7	=	[67,player_dieb8] {}; // [FUNCTION]
void()	player_dieb8	=	[68,player_dieb9] {}; // [FUNCTION]
void()	player_dieb9	=	[69,player_dieb9] {player_dead();}; // [FUNCTION]

void()	player_diec1	=	[70,player_diec2] {}; // [FUNCTION]
void()	player_diec2	=	[71,player_diec3] {}; // [FUNCTION]
void()	player_diec3	=	[72,player_diec4] {}; // [FUNCTION]
void()	player_diec4	=	[73,player_diec5] {}; // [FUNCTION]
void()	player_diec5	=	[74,player_diec6] {}; // [FUNCTION]
void()	player_diec6	=	[75,player_diec7] {}; // [FUNCTION]
void()	player_diec7	=	[76,player_diec8] {}; // [FUNCTION]
void()	player_diec8	=	[77,player_diec9] {}; // [FUNCTION]
void()	player_diec9	=	[78,player_diec10] {}; // [FUNCTION]
void()	player_diec10	=	[79,player_diec11] {}; // [FUNCTION]
void()	player_diec11	=	[80,player_diec12] {}; // [FUNCTION]
void()	player_diec12	=	[81,player_diec13] {}; // [FUNCTION]
void()	player_diec13	=	[82,player_diec14] {}; // [FUNCTION]
void()	player_diec14	=	[83,player_diec15] {}; // [FUNCTION]
void()	player_diec15	=	[84,player_diec15] {player_dead();}; // [FUNCTION]

void()	player_died1	=	[85,player_died2] {}; // [FUNCTION]
void()	player_died2	=	[86,player_died3] {}; // [FUNCTION]
void()	player_died3	=	[87,player_died4] {}; // [FUNCTION]
void()	player_died4	=	[88,player_died5] {}; // [FUNCTION]
void()	player_died5	=	[89,player_died6] {}; // [FUNCTION]
void()	player_died6	=	[90,player_died7] {}; // [FUNCTION]
void()	player_died7	=	[91,player_died8] {}; // [FUNCTION]
void()	player_died8	=	[92,player_died9] {}; // [FUNCTION]
void()	player_died9	=	[93,player_died9] {player_dead();}; // [FUNCTION]

void()	player_diee1	= [94,player_diee2] {}; // [FUNCTION]
void()	player_diee2	= [95,player_diee3] {}; // [FUNCTION]
void()	player_diee3	= [96,player_diee4] {}; // [FUNCTION]
void()	player_diee4	= [97,player_diee5] {}; // [FUNCTION]
void()	player_diee5	= [98,player_diee6] {}; // [FUNCTION]
void()	player_diee6	= [99,player_diee7] {}; // [FUNCTION]
void()	player_diee7	= [100,player_diee8] {}; // [FUNCTION]
void()	player_diee8	= [101,player_diee9] {}; // [FUNCTION]
void()	player_diee9	= [102,player_diee9] {player_dead();}; // [FUNCTION]

void()	player_die_ax1	= [41,player_die_ax2] {}; // [FUNCTION]
void()	player_die_ax2	= [42,player_die_ax3] {}; // [FUNCTION]
void()	player_die_ax3	= [43,player_die_ax4] {}; // [FUNCTION]
void()	player_die_ax4	= [44,player_die_ax5] {}; // [FUNCTION]
void()	player_die_ax5	= [45,player_die_ax6] {}; // [FUNCTION]
void()	player_die_ax6	= [46,player_die_ax7] {}; // [FUNCTION]
void()	player_die_ax7	= [47,player_die_ax8] {}; // [FUNCTION]
void()	player_die_ax8	= [48,player_die_ax9] {}; // [FUNCTION]
void()	player_die_ax9	= [49,player_die_ax9] {player_dead();}; // [FUNCTION]

void()	player_die_saw1	= [17,player_die_saw2] {}; // [FUNCTION]
void()	player_die_saw2	= [18,player_die_saw3] {}; // [FUNCTION]
void()	player_die_saw3	= [19,player_die_saw4] {}; // [FUNCTION]
void()	player_die_saw4	= [20,player_die_saw5] {}; // [FUNCTION]
void()	player_die_saw5	= [21,player_die_saw6] {}; // [FUNCTION]
void()	player_die_saw6	= [22,player_die_saw7] {}; // [FUNCTION]
void()	player_die_saw7	= [23,player_die_saw8] {}; // [FUNCTION]
void()	player_die_saw8	= [24,player_die_saw9] {}; // [FUNCTION]
void()	player_die_saw9	= [25,player_die_saw9] {player_dead();}; // [FUNCTION]

void() player_die_weaponless1 = [24,player_die_weaponless2] {}; // [FUNCTION]
void() player_die_weaponless2 = [25,player_die_weaponless3] {}; // [FUNCTION]
void() player_die_weaponless3 = [26,player_die_weaponless4] {}; // [FUNCTION]
void() player_die_weaponless4 = [27,player_die_weaponless5] {}; // [FUNCTION]
void() player_die_weaponless5 = [28,player_die_weaponless6] {}; // [FUNCTION]
void() player_die_weaponless6 = [29,player_die_weaponless7] {}; // [FUNCTION]
void() player_die_weaponless7 = [30,player_die_weaponless8] {}; // [FUNCTION]
void() player_die_weaponless8 = [31,player_die_weaponless8] {player_dead();}; // [FUNCTION]

void() player_death_sound = { // [FUNCTION]
	if (self.waterlevel == 3) { // water death sounds
		death_bubbles(20);
		self.noise = "player/h2odeath.wav";
	} else {
		self.lip = rint ((random() * 4) + 1);
		if (self.lip == 2) self.noise = "player/death2.wav";
		else if (self.lip == 3) self.noise = "player/death3.wav";
		else if (self.lip == 4) self.noise = "player/death4.wav";
		else if (self.lip == 5) self.noise = "player/death5.wav";
		else self.noise = "player/death1.wav";
	}
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
};

void() player_gib = { // [FUNCTION]
	// Set all gib/death flags correctly
	self.gibbed = TRUE;
	self.deadflag = DEAD_DEAD;
	self.takedamage = DAMAGE_NO;
	self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE; // Let the head model bounce around.  Player's camera sticks with the head.
	setmodel(self, self.headmdl);
	setsize(self, '-16 -16 0', '16 16 32');
	self.frame = 0;		// Reset frame, head model only has 1 frame
	self.height = 1;	// Do not remove after model fadeout
	ThrowGib(1,1);
	ThrowGib(2,1);
	ThrowGib(3,1);
	ThrowGib(4,rint(random()*2));
	ThrowGib(5,1);
	self.velocity_x = 50 * crandom();
	self.velocity_y = 50 * crandom();
	self.velocity_z = 200 + 100 * random(); // Lots of vertical momentum
	self.avelocity = '0 0 0';
	self.avelocity_y = 200 + random() * 200;
	self.angles = '0 0 0';
	self.angles_y = self.ideal_yaw = random() * 360;
	if (damage_attacker.classname == "teledeath") sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);  // Play GIB death sound
	else if (damage_attacker.classname == "teledeath2") sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
	else {
		if (random() < 0.5) sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
		else sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}
};

void() player_death = { // [FUNCTION]
	if (self.health < -99) self.health = -99; // don't let sbar look bad if a player	
	if (deathmatch || coop) DropBackpack();
	
	ResetPowerSystem(self,0,TRUE); // Remove all powerup/debuff effects
	ResetDebuffSystem(self);
	self.weaponmodel=""; // Don't show a weapon viewmodel when dead.
	self.view_ofs = '0 0 8'; // I guess to keep our eyes out of the floor when we've been gibbed to a head.
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS; // Doesn't bounce unless gibbed, then changes to MOVETYPE_BOUNCE for bouncy head.
	self.flags = self.flags - (self.flags & FL_ONGROUND); // Remove floor/ground flag, time to fly
	setorigin(self, self.origin + '0 0 1');
	if (self.health < self.gibhealth) player_gib(); // Burst to bits from high damage.
	else {
		player_death_sound();
		self.angles_x = self.angles_z = 0;
		if (self.velocity_z < 10) self.velocity_z = self.velocity_z + random()*300;

		// Setting the modelindex here because ClientPowerups doesn't when player has health < 1.
		if (self.weaponmodel == "") { self.modelindex = modelindex_hamout; player_die_weaponless1(); return; }

		if (self.weapon == IT_AXE && !self.selfweaponismoditems) {
			if (self.perms & IT_CHAINSAW) {
				self.modelindex = modelindex_saw;
				player_die_saw1();
			} else {
				self.modelindex = modelindex_player;
				player_die_ax1 ();
			}
		} else if (self.weapon == IT2_MJOLNIR && !self.selfweaponismoditems) {
			if (self.hammer_finished) { // Hammer has been thrown out.
				self.modelindex = modelindex_hamout;
				player_die_weaponless1();
			} else {
				self.modelindex = modelindex_hammer;
				player_die_weaponless1(); // Same frames as weaponless version.
			}
		} else {
			self.modelindex = modelindex_player;
			self.lip = 1 + floor(random()*6);
			if (self.lip == 1) player_diea1();
			else if (self.lip == 2) player_dieb1();
			else if (self.lip == 3) player_diec1();
			else if (self.lip == 4) player_died1();
			else player_diee1();
		}
	}
};

// Used by kill or diconnect console commands.
void() set_suicide_frame = { // [FUNCTION]
	if (self.gibbed == TRUE) return; // Already gibbed.

	self.frame = 60;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};