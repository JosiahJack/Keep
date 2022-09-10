//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake by Patrick Martin
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
// Implements:  Ranger
//
// Description:
// The player turned into a combatant.  TODO: currently unimplemented as I want
// to incorporate multiple bot ai into this with mapper selectable one, such as
// Frikbot, or simple Drake ranger version.
//
// This file contains code for the ranger, a renegade clone of the player.
// Named ranger because that is what the model of the Quake1 player is
// called in the Quake3 manual.
//
// Also capable of being a friendly aid.
//=============================================================================

$cd id1/models/player_4
$origin 0 -6 24
$base base        
$skin skin
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6 // running
$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6
$frame stand1 stand2 stand3 stand4 stand5 // standing
$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6 // pain
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6 // death
$frame axdeth7 axdeth8 axdeth9
$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9
$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15
$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9
$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9
$frame nailatt1 nailatt2 // attacks
$frame light1 light2
$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6
$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6
$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6
$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6
$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6
$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6
$frame axdecap1 axdecap2 axdecap3 axdecap4 axdecap5 axdecap6 // decap
$frame axdecap7 axdecap8
$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8
$frame decap9 decap10 decap11
$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6 decapb7 decapb8
$frame decapb9

void() ranger_axstand1  = [$axstnd1,  ranger_axstand2   ] { ai_stand(); };
void() ranger_axstand2  = [$axstnd2,  ranger_axstand3   ] { ai_stand(); };
void() ranger_axstand3  = [$axstnd3,  ranger_axstand4   ] { ai_stand(); };
void() ranger_axstand4  = [$axstnd4,  ranger_axstand5   ] { ai_stand(); };
void() ranger_axstand5  = [$axstnd5,  ranger_axstand6   ] { ai_stand(); };
void() ranger_axstand6  = [$axstnd6,  ranger_axstand7   ] { ai_stand(); };
void() ranger_axstand7  = [$axstnd7,  ranger_axstand8   ] { ai_stand(); };
void() ranger_axstand8  = [$axstnd8,  ranger_axstand9   ] { ai_stand(); };
void() ranger_axstand9  = [$axstnd9,  ranger_axstand10  ] { ai_stand(); };
void() ranger_axstand10 = [$axstnd10, ranger_axstand11  ] { ai_stand(); };
void() ranger_axstand11 = [$axstnd11, ranger_axstand1   ] { ai_stand(); };

void() ranger_stand1    = [$stand1,  ranger_stand2  ] { ai_stand(); };
void() ranger_stand2    = [$stand2,  ranger_stand3  ] { ai_stand(); };
void() ranger_stand3    = [$stand3,  ranger_stand4  ] { ai_stand(); };
void() ranger_stand4    = [$stand4,  ranger_stand5  ] { ai_stand(); };
void() ranger_stand5    = [$stand5,  ranger_stand1  ] { ai_stand(); };

void() ranger_stand = { // [FUNCTION]
    if (self.war & WARx_AXE_FRAMES)
        ranger_axstand1();
    else
        ranger_stand1();
};

// Since player model does not have a proper walk scene, animate the run scene at half speed.
void() ranger_axwalk1  = [$axrun1,  ranger_axwalk2  ] { ai_walk(10); };
void() ranger_axwalk2  = [$axrun1,  ranger_axwalk3  ] { ai_walk(10); };
void() ranger_axwalk3  = [$axrun2,  ranger_axwalk4  ] { M_Step(); ai_walk(8); };
void() ranger_axwalk4  = [$axrun2,  ranger_axwalk5  ] { ai_walk(8); };
void() ranger_axwalk5  = [$axrun3,  ranger_axwalk6  ] { ai_walk(5); };
void() ranger_axwalk6  = [$axrun3,  ranger_axwalk7  ] { ai_walk(4); };
void() ranger_axwalk7  = [$axrun4,  ranger_axwalk8  ] { ai_walk(10); };
void() ranger_axwalk8  = [$axrun4,  ranger_axwalk9  ] { ai_walk(10); };
void() ranger_axwalk9  = [$axrun5,  ranger_axwalk10 ] { M_Step(); ai_walk(8); };
void() ranger_axwalk10 = [$axrun5,  ranger_axwalk11 ] { ai_walk(8); };
void() ranger_axwalk11 = [$axrun6,  ranger_axwalk12 ] { ai_walk(5); };
void() ranger_axwalk12 = [$axrun6,  ranger_axwalk1  ] { ai_walk(4); };

void() ranger_walk1  = [$rockrun1,  ranger_walk2  ] { ai_walk(10); };
void() ranger_walk2  = [$rockrun1,  ranger_walk3  ] { ai_walk(10); };
void() ranger_walk3  = [$rockrun2,  ranger_walk4  ] { M_Step(); ai_walk(8); };
void() ranger_walk4  = [$rockrun2,  ranger_walk5  ] { ai_walk(8); };
void() ranger_walk5  = [$rockrun3,  ranger_walk6  ] { ai_walk(6); };
void() ranger_walk6  = [$rockrun3,  ranger_walk7  ] { ai_walk(6); };
void() ranger_walk7  = [$rockrun4,  ranger_walk8  ] { ai_walk(10); };
void() ranger_walk8  = [$rockrun4,  ranger_walk9  ] { ai_walk(10); };
void() ranger_walk9  = [$rockrun5,  ranger_walk10 ] { M_Step(); ai_walk(8); };
void() ranger_walk10 = [$rockrun5,  ranger_walk11 ] { ai_walk(8); };
void() ranger_walk11 = [$rockrun6,  ranger_walk12 ] { ai_walk(8); };
void() ranger_walk12 = [$rockrun6,  ranger_walk1  ] { ai_walk(8); };

void() ranger_walk = { // [FUNCTION]
    if (self.war & WARx_AXE_FRAMES) ranger_axwalk1();
    else ranger_walk1();
};

void() ranger_axrun1    = [$axrun1,  ranger_axrun2  ] { ai_run(self.speed); };
void() ranger_axrun2    = [$axrun2,  ranger_axrun3  ] { M_Step(); ai_run(self.speed); };
void() ranger_axrun3    = [$axrun3,  ranger_axrun4  ] { ai_run(self.speed); };
void() ranger_axrun4    = [$axrun4,  ranger_axrun5  ] { ai_run(self.speed); };
void() ranger_axrun5    = [$axrun5,  ranger_axrun6  ] { M_Step(); ai_run(self.speed); };
void() ranger_axrun6    = [$axrun6,  ranger_axrun1  ] { ai_run(self.speed); };

void() ranger_run1  = [$rockrun1,  ranger_run2  ] { ai_run(self.speed); };
void() ranger_run2  = [$rockrun2,  ranger_run3  ] { M_Step(); ai_run(self.speed); };
void() ranger_run3  = [$rockrun3,  ranger_run4  ] { ai_run(self.speed); };
void() ranger_run4  = [$rockrun4,  ranger_run5  ] { ai_run(self.speed); };
void() ranger_run5  = [$rockrun5,  ranger_run6  ] { M_Step(); ai_run(self.speed); };
void() ranger_run6  = [$rockrun6,  ranger_run1  ] { ai_run(self.speed); };

void() ranger_run = { // [FUNCTION]
    self.cnt = 0;   // Reset Nightmare fire counter.
    if (self.war & WARx_AXE_FRAMES) ranger_axrun1();
    else ranger_run1();
};

void(float dist) ranger_charge = { // [FUNCTION]
    ai_face();
    if (QC_CloseEnough (dist)) safe_goal (8);   // Given speed was too fast, so slow down.
    else safe_goal (dist);
};

void(float dist) ranger_strafe = { ai_face(); ai_run_strafe (dist); }; // [FUNCTION]

void(float dist) ranger_axe_step = { // [FUNCTION]
    local vector p1, p2;

    p1 = self.origin + self.view_ofs;
    p2 = self.enemy.origin + self.enemy.view_ofs;
    if (vlen(p2 - p1) > (self.enemy.maxs_x * 1.25 + 90 + dist)) ai_charge(dist);   // Head straight in.
    else ranger_strafe (dist);   // Strafe to the side.
};

void() ranger_axe = { // [FUNCTION]
    local vector  p1, p2;
    
    ai_face();
    p1 = self.origin + '0 0 16';
    p2 = Midpoint (self.enemy);
    p2 = normalize (p2 - p1);
    Attack_Axe (self.enemy, p2);
};

// This checks if the attack combo should be broken.
void(void() thinkst) ranger_break = { // [FUNCTION]
    if (self.enemy.health <= 0) self.think = thinkst;   // Target dead, end it.
    else if (!visible (self.enemy)) self.think = thinkst;
};

void() sfx_axe = { sound(self,CHAN_WEAPON,"drake/axeman/axe1.wav",1,ATTN_NORM); }; // [FUNCTION]

// NOTE:  Modified axe attacks to be like CoE's axeman instead of player.
// FIXME:  Change attacks to be more like the Bane's.
void() ranger_axer;

// Standard four single axe attacks.
// Steps for axatt* should be = {8, 8, 8, 15, 10, 8}.
void() ranger_axe1  = [$axatt1,  ranger_axe2  ] { sfx_axe(); ranger_charge(self.speed); };
void() ranger_axe2  = [$axatt2,  ranger_axe3  ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axe3  = [$axatt3,  ranger_axe4  ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axe4  = [$axatt4,  ranger_axe5  ] { ranger_charge(self.speed); ai_melee();SUB_CheckRefire(ranger_axer); };
void() ranger_axe5  = [$axatt5,  ranger_axe6  ] { ranger_axe_step(self.speed); };
void() ranger_axe6  = [$axatt6,  ranger_run   ] { ranger_axe_step(self.speed); };

void() ranger_axeb1 = [$axattb1, ranger_axeb2 ] { sfx_axe(); ranger_charge(self.speed); };
void() ranger_axebx = [$axattb2, ranger_axeb3 ] { sfx_axe(); ranger_charge(self.speed); ai_melee(); };
void() ranger_axeb2 = [$axattb2, ranger_axeb3 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axeb3 = [$axattb3, ranger_axeb4 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axeb4 = [$axattb4, ranger_axeb5 ] { ranger_charge(self.speed); ai_melee();SUB_CheckRefire(ranger_axer); };
void() ranger_axeb5 = [$axattb5, ranger_axeb6 ] { ranger_axe_step(self.speed); };
void() ranger_axeb6 = [$axattb6, ranger_run   ] { ranger_axe_step(self.speed); };

void() ranger_axec1 = [$axattc1, ranger_axec2 ] { sfx_axe(); ranger_charge(self.speed); };
void() ranger_axec2 = [$axattc2, ranger_axec3 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axec3 = [$axattc3, ranger_axec4 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axec4 = [$axattc4, ranger_axec5 ] { ranger_charge(self.speed); ai_melee();SUB_CheckRefire(ranger_axer); };
void() ranger_axec5 = [$axattc5, ranger_axec6 ] { ranger_axe_step(self.speed); };
void() ranger_axec6 = [$axattc6, ranger_run   ] { ranger_axe_step(self.speed); };

void() ranger_axed1 = [$axattd1, ranger_axed2 ] { sfx_axe(); ranger_charge(self.speed); };
void() ranger_axed2 = [$axattd2, ranger_axed3 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axed3 = [$axattd3, ranger_axed4 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axed4 = [$axattd4, ranger_axed5 ] { ranger_charge(self.speed); ai_melee();SUB_CheckRefire(ranger_axer); };
void() ranger_axed5 = [$axattd5, ranger_axed6 ] { ranger_axe_step(self.speed); };
void() ranger_axed6 = [$axattd6, ranger_run   ] { ranger_axe_step(self.speed); };

// Three hit flurry.  First hit chains into flyby combo.
void() ranger_axee1 = [$axatt1,  ranger_axee2 ] { sfx_axe(); ranger_charge(self.speed); };
void() ranger_axee2 = [$axatt2,  ranger_axee3 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axee3 = [$axatt3,  ranger_axee4 ] { ranger_charge(self.speed); ai_melee(); };
void() ranger_axee4 = [$axatt4,  ranger_axefx ] { ranger_break(ranger_axe5);ranger_charge(self.speed); ai_melee(); };

// Fast one-two flyby combo.
void() ranger_axef1 = [$axattd1, ranger_axef2 ] { sfx_axe(); ai_charge_left(self.speed); };
void() ranger_axefx = [$axattd2, ranger_axef3 ] { sfx_axe(); ai_charge_left(self.speed); ai_melee(); };
void() ranger_axef2 = [$axattd2, ranger_axef3 ] { ai_charge_left(self.speed); ai_melee(); };
void() ranger_axef3 = [$axattd3, ranger_axef4 ] { ai_charge_left(self.speed); ai_melee(); };
void() ranger_axef4 = [$axattd4, ranger_axeg  ] { ranger_break(ranger_axed5); ai_charge_left(self.speed); ai_melee(); };

// Common combo ender.
void() ranger_axeg  = [$axattb1, ranger_axebx ] { // [FUNCTION]
    M_Reload (0.5);     // Making another swing.
    if (random() < 0.5) self.think = ranger_axec1;
    ranger_charge(self.speed);
};

void() ranger_axer = { // [FUNCTION]
    local float combo, r;

    combo = TRUE;
    if (self.cnt == 1) combo = FALSE;  // Don't allow a combo on a refire.
    else if (skill < 1) combo = FALSE;  // Hold back on Easy.
    r = random();
    if (r < 0.25) {
        if (combo) ranger_axee1();    // 3-hit combo.
        else ranger_axe1();
    } else if (r < 0.5) {
        ranger_axeb1();
    } else if (r < 0.75) {
        ranger_axec1();
    } else {
        if (combo) ranger_axef1();    // 2-hit combo.
        else ranger_axed1();
    }

    M_Reload (0.5);
};

entity() Ranger_Target = { if (skill >= 2) return self.enemy; return world; }; // [FUNCTION]

void() ranger_shotgun = { // [FUNCTION]
    local vector p1, p2;
    local float shotty;
    
    ai_face();
    p1 = self.origin + '0 0 16';
    p2 = Midpoint (self.enemy);
    p2_x = p2_x + crandom(); p2_y = p2_y + crandom(); p2_z = p2_z + crandom();
    if (self.enemy.classname == "player") { // Aim just behind a player.
        if (skill < 2) p2 = p2 - self.enemy.velocity*0.1; // Easy or Normal
        else { // Hard or Nightmare
            if (random() < 0.5) p2 = p2 - self.enemy.velocity*0.1;
            else p2 = p2 - self.enemy.velocity*0.05;
        }
    }

    if (self.war & WAR_SUPER_SHOTGUN) shotty = TRUE; // Fire shotgun
    else shotty = FALSE;
    M_FireShotgun(p1, p2,self.enemy,VEC_ORIGIN,FALSE,shotty);
};
void() ranger_shot1  = [$shotatt1,  ranger_shot2  ] { ai_face();ranger_shotgun(); };
void() ranger_shot2  = [$shotatt2,  ranger_shot3  ] { ai_face(); };
void() ranger_shot3  = [$shotatt3,  ranger_shot4  ] { ai_face(); };
void() ranger_shot4  = [$shotatt4,  ranger_shot5  ] { ai_face(); };
void() ranger_shot5  = [$shotatt5,  ranger_shot6  ] { ai_face(); };
void() ranger_shot6  = [$shotatt6,  ranger_run    ] { ai_face(); SUB_CheckRefire(ranger_shot1); };

void() ranger_auto1  = [$nailatt1,  ranger_auto2  ] { ranger_strafe(self.speed); ranger_shotgun(); };
void() ranger_auto2  = [$nailatt2,  ranger_auto3  ] { ranger_strafe(self.speed); };
void() ranger_auto3  = [$nailatt1,  ranger_auto4  ] { ranger_strafe(self.speed); ranger_shotgun();if (self.ammo_shells >= 1) SUB_CheckRefire(ranger_auto2); };
void() ranger_auto4  = [$nailatt2,  ranger_run    ] { ranger_strafe(self.speed); };

void() ranger_nailgun = { // [FUNCTION]
    local vector p1, p2;
    local float super;
    local entity targ;

    ai_face();
    targ = Ranger_Target();
    p1 = self.origin + '0 0 16';
    p2 = Aimpoint (self.enemy);
    p2_x = p2_x + crandom(); p2_y = p2_y + crandom(); p2_z = p2_z + crandom();
    if (self.war & WAR_SUPER_NAILGUN) super = TRUE;
    else {
        if (self.frame == $nailatt1) super = 3;
        else super = -3;
        makevectors(self.angles);
        v_right = v_right*super;
        p1 = p1 + v_right;
        p2 = p2 + v_right;
        super = FALSE;
    }
    M_FireNailgun (p1, p2, targ, '0 0 0', super);
    self.attack_finished = time + 0.2; // Override time finished to let ranger use nailgun like a machinegun.
};
void() ranger_nail1  = [$nailatt1,  ranger_nail2  ] { ranger_strafe(self.speed); ranger_nailgun(); };
void() ranger_nail2  = [$nailatt2,  ranger_nail3  ] { ranger_strafe(self.speed); ranger_nailgun(); };
void() ranger_nail3  = [$nailatt1,  ranger_nail4  ] { ranger_strafe(self.speed); ranger_nailgun();if (self.ammo_nails >= 1) SUB_CheckRefire(ranger_nail2); };
void() ranger_nail4  = [$nailatt2,  ranger_run    ] { ranger_strafe(self.speed); };   // if (self.war & WAR_CHAINGUN) ranger_nailgun(); };

void(float lite) ranger_laser = { // [FUNCTION]
    local vector p1, p2;
    local float up;
    local entity targ;

    ai_face();

    // After first shot, terminate if not visible to avoid suicide by ricochet.
    if (lite)
        if ((self.war & WAR_LASER_CANNON) || (lite != 1))   // Blech!
            if (!visible (self.enemy))
                { self.think = ranger_run; return; }

    targ = Ranger_Target();
    up = self.enemy.maxs_z - self.enemy.mins_z - 2;
    if (up < 0)
        up = 0;
    p1 = self.origin + '0 0 12';
    p2 = self.enemy.origin;
    p2_z = p2_z + self.enemy.mins_z + (up * lite / 3 + 1);
    p2_x = p2_x + crandom(); p2_y = p2_y + crandom(); p2_z = p2_z + crandom();
    lite = lite & 1;
    if (self.war & WAR_LASER_CANNON) M_FireHipLC (p1, p2, targ, '0 0 0', lite);
    else {
        if (lite) lite = LF_GLOW;
        else lite = 0;
        M_FireLaser (p1, p2, targ, '0 0 0', LF_RED|LF_BOUNCE|lite);
    }

    self.attack_finished = time + 0.2; // Override attack time.
};
void() ranger_laser1 = [$nailatt1, ranger_laser2 ] { ranger_strafe(self.speed); ranger_laser(1); };
void() ranger_laser2 = [$nailatt2, ranger_laser3 ] { ranger_strafe(self.speed); ranger_laser(2); };
void() ranger_laser3 = [$nailatt2, ranger_run    ] { ranger_strafe(self.speed); if (self.ammo_cells >= 1) SUB_CheckRefire(ranger_laser1); };

void() ranger_lc1 = [$nailatt1, ranger_lc2 ] { ranger_strafe(self.speed); ranger_laser(0); };
void() ranger_lc2 = [$nailatt2, ranger_lc3 ] { ranger_strafe(self.speed); ranger_laser(1); };
void() ranger_lc3 = [$nailatt1, ranger_lc4 ] { ranger_strafe(self.speed); ranger_laser(2); };
void() ranger_lc4 = [$nailatt2, ranger_run ] { ranger_strafe(self.speed); ranger_laser(3); if (self.ammo_cells >= 1) SUB_CheckRefire(ranger_lc1); };

void() ranger_rocket = { // [FUNCTION]
    local vector p1, p2;
    local entity targ;

    ai_face();
    targ = Ranger_Target();
    p1 = self.origin + '0 0 16';
    p2 = Aimpoint (self.enemy);
    p2_x = p2_x + crandom(); p2_y = p2_y + crandom(); p2_z = p2_z + crandom();
    if (self.war & WAR_CRUISE_MISSILE) { // Since this is a homing missile, no need to lead.
        M_FireMirv (p1, p2, world, '0 0 0', FALSE);
        return;
    }

    if (self.war & WAR_ROCKET_LAUNCHER) {
        if (cranked)
        if (targ)
        if (targ.flags & FL_ONGROUND)
        if (targ.movetype != MOVETYPE_FLY)
        if (random() < 0.5) { // Aim at the feet!  This is too good, so do it only under stringent conditions.
            local float feet;

            feet = (targ.mins_z + targ.maxs_z)*0.5;
            feet = feet - targ.mins_z;
            if (feet < 0) feet = 0;
            p2_z = p2_z - feet;
        }
        M_FireRocket (p1, p2, targ,VEC_ORIGIN, FALSE);
        return;
    }
    if (self.war & WAR_SIDEWINDER) { // Since this is a homing missile, no need to lead.
        M_FireSidewinder (p1, p2, world,VEC_ORIGIN, FALSE);
        return;
    }

    if (self.war & WAR_PLASMA_GUN) {
        M_FirePlasma (p1, p2, targ, '1 1 0', FALSE);
        return;
    }

    M_FireBuriza (p1, p2, targ,VEC_ORIGIN);
};
void() ranger_rock1  = [$rockatt1,  ranger_rock2  ] { ai_face();ranger_rocket(); self.effects = self.effects | EF_MUZZLEFLASH; };
void() ranger_rock2  = [$rockatt2,  ranger_rock3  ] { ai_face(); };
void() ranger_rock3  = [$rockatt3,  ranger_rock4  ] { ai_face(); };
void() ranger_rock4  = [$rockatt4,  ranger_rock5  ] { ai_face(); };
void() ranger_rock5  = [$rockatt5,  ranger_rock6  ] { ai_face(); };
void() ranger_rock6  = [$rockatt6,  ranger_run    ] { ai_face();
    if (!(self.war & WAR_CRUISE_MISSILE)) { // No encore allowed with MIRVs.
        if (self.ammo_rockets >= 1) SUB_CheckRefire(ranger_rock1);
    }
};

// Note:  Don't allow strafing with lightning or plasma guns because a single 
// careless move into water will cause a discharge with the attacker at the
// center.
void(float cl) ranger_tbolt = { // [FUNCTION]
    local vector p1, p2;
    
    ai_face();
    p1 = self.origin + '0 0 16';
    p2 = Midpoint(self.enemy);
    M_FireThunderbolt(p1,p2,self.enemy,VEC_ORIGIN,FALSE,cl);
};

// No 'SUB_CheckRefire' for Thunderbolt here.
void() ranger_light1  = [$light1,  ranger_light2  ] { ai_face();ranger_tbolt(self.war & WAR_CHAIN_LIGHTNING); };
void() ranger_light2  = [$light2,  ranger_light3  ] { ai_face();ranger_tbolt(self.war & WAR_CHAIN_LIGHTNING); };
void() ranger_light3  = [$light1,  ranger_light4  ] { ai_face();ranger_tbolt(self.war & WAR_CHAIN_LIGHTNING); };    //if (self.ammo_cells >= 1) SUB_CheckRefire(ranger_light2); };
void() ranger_light4  = [$light2,  ranger_run     ] { ai_face();
    if (self.t_width > self.attack_finished)    // So sound is played at
        self.attack_finished = self.t_width;    // next attack.
};

void() ranger_plasma1  = [$light1,  ranger_plasma2  ] { ai_face(); ranger_rocket(); };
void() ranger_plasma2  = [$light2,  ranger_plasma3  ] { ai_face(); };
void() ranger_plasma3  = [$light1,  ranger_plasma4  ] { ai_face(); ranger_rocket(); };
void() ranger_plasma4  = [$light2,  ranger_run      ] { ai_face();
    if (self.ammo_cells >= 1)
        SUB_CheckRefire(ranger_plasma1);
};

void() ranger_xbow1   = [$light1,  ranger_xbow2   ] { ai_face(); ranger_rocket(); };
void() ranger_xbow2   = [$light2,  ranger_run     ] { ai_face(); };

float(float dist) RangerUse_RapidFire = {
    if (self.waitmin > time) {
        if (self.arsenal & (WAR_LASER_CANNON | WAR_BLASTER))
            if (self.ammo_cells >= 1) return TRUE;   // Strafe with laser gun instead.
        if (self.arsenal & WARx_USES_NAILS)
            if (self.ammo_nails >= 1) return TRUE;   // Strafe with nailgun instead.
    }
    return FALSE;
};

float(float dist) RangerUse_Plasma = {
    if (self.ammo_cells < 1) return FALSE; // No ammo.
    if (self.h2olevel > 1) return FALSE; // Using lightning while underwater is suicide.
    if (self.enemy.h2olevel == 3) return FALSE; // Can't penetrate water to hit target.
    if (RangerUse_RapidFire (dist)) return FALSE; // Strafe with another weapon instead.
    return (dist > 120); // Fire away if far enough.
};

float(float dist) RangerUse_Lightning = {
    if (self.ammo_cells < 1) return FALSE; // No ammo.
    if (self.h2olevel > 1) return FALSE; // Using lightning while underwater is suicide.
    if (self.enemy.classname == "monster_zombie") { // Lightning can't kill zombies.
        if (self.arsenal & WARx_USES_ROCKETS)
            if (self.ammo_rockets >= 1) return FALSE; // Only rockets kill zombies -- use them!
        if (self.arsenal & WAR_PLASMA_GUN) return FALSE; // Plasma will work too.
    }
    if (RangerUse_RapidFire (dist)) return FALSE; // Strafe with another weapon instead.

    return (dist < 600); // Fire away if close enough.
};

float(float dist) RangerUse_Rocket = {
    if (self.ammo_rockets < 1) return FALSE; // No ammo.
    if ((self.arsenal & WARx_USES_ROCKETS) == WAR_CRUISE_MISSILE)
        if (self.ammo_rockets < COST_MIRV) return FALSE;   // Only has the big gun but not enough ammo.

    // Always use rockets against zombies unless we have plasma to use.
    if (self.enemy.classname == "monster_zombie")
    if (!(self.arsenal & WAR_PLASMA_GUN) || (self.ammo_cells < 1) || (self.h2olevel > 1)) return TRUE; // "It's the only way to be sure."

    if (dist <= 250) {
        if (!cranked && (self.enemy.classname == "player")) return FALSE;   // Too close.
        // ELSE... we have a railgun we can use!
    }

    if (self.xfl & XFL_USE_AMMO) {
        if (self.ammo_nails < 1)
            if (self.ammo_shells < 1)
                if (self.ammo_cells < 1) return TRUE;   // No other ammo, so go for broke.
        if ((self.arsenal & (WARx_USES_SHELLS | WARx_USES_NAILS)) == 0)
            if ((self.arsenal & (WAR_LASER_CANNON | WAR_BLASTER)) == 0) return TRUE;    // No other weapons.
    }

    if (self.waitmin > time) {
        if (random() < 0.5) {
            if (self.ammo_cells >= 1) {
                if (self.arsenal & (WAR_LASER_CANNON | WAR_BLASTER)) return FALSE;
            }
            if (self.arsenal & WARx_USES_NAILS) {
                if (self.ammo_nails >= 1) return FALSE;   // Strafe with nailgun instead.
            }
        }
    }

    // 10% chance per rocket to use.  If ranger has few rockets, he tends
    // to save them.  If ranger has many, he will use them liberally.
    return (random() < (self.ammo_rockets * 0.1));
};

float(float dist) RangerUse_Laser = {
    if (self.ammo_cells < 1) return FALSE;   // No ammo.
    if (self.arsenal & WAR_LASER_CANNON) return TRUE;    // LC is nearly as strong as Tbolt, use as primary.

    // Blaster is mid-level with damage rate between Nailgun and Super Nailgun,
    // and should abide by rules used for nailguns.
    // Average damage per frame:  Nailgun = 9, Blaster = 12, Super Nailgun = 18.
    if (self.arsenal & WAR_SUPER_NAILGUN)
        if (self.ammo_nails >= 2) return FALSE;   // Use super nailgun instead.
    if ((self.arsenal & WARx_USES_SHELLS) == 0) return TRUE;    // No shotguns to use.
    if (self.ammo_shells < 1) return TRUE;    // No shells for shotguns.
    if (self.enemy.attack_finished > time) return TRUE;    // Enemy is attacking.
    if (self.waitmin > time) return TRUE;    // Recently injured.
    return FALSE;   // No compelling reason to use instead of shotgun.
};

float(float dist) RangerUse_Nailgun = {
    dist = self.arsenal & WARx_USES_SHELLS; // We don't need 'dist' for anything, so make use of it.
    if (self.ammo_nails < 1) {
        if (self.xfl & XFL_USE_AMMO) return FALSE;   // No ammo.
        if (dist) return FALSE; // Unlimited ammo but no nails?  Use only if player has no shotgun.  Has shotgun to fall back on.
    }
    if (!dist) return TRUE; // No shotguns to use.
    if (self.ammo_shells < 1) return TRUE; // No shells, so use nails.
    if (self.enemy.attack_finished > time) return TRUE; // Enemy is attacking.
    if (self.waitmin > time) return TRUE; // Recently injured.
    return FALSE;   // No compelling reason to use instead of shotgun.
};

void() ranger_fire = { // [FUNCTION]
    local vector  p1, p2;
    local float dist, shot, MASK;

    self.punked = FALSE;
    Mirv_Use();
    p1 = self.origin + '0 0 16';
    p2 = Midpoint (self.enemy);
    dist = vlen(p2 - p1);
    if (self.arsenal & WAR_BURIZA) { // One gun to rule them all!
        if (self.ammo_super >= 1)
        if (!(self.enemy.xfl & XFL_BOSS) || (self.enemy.health > 1000)) {
            self.war = WAR_BURIZA;
            ranger_xbow1();
            return;
        }
    }

    if (self.arsenal & (WAR_THUNDERBOLT | WAR_CHAIN_LIGHTNING)) { // Removed:  Railgun check.
        if (RangerUse_Lightning (dist)) { // Update 11/19/09:  Chain lit. supercedes thunderbolt.
            if (self.arsenal & WAR_CHAIN_LIGHTNING) self.war = WAR_CHAIN_LIGHTNING;
            else self.war = WAR_THUNDERBOLT;

            ranger_light1();
            M_Lstart();
            return;
        }
    }

    if (self.arsenal & WARx_USES_ROCKETS) {
        if (RangerUse_Rocket (dist)) {
            if (self.arsenal & WAR_CRUISE_MISSILE) {
                shot = TRUE;
                mask = (self.arsenal & WARx_USES_ROCKETS);
                if (mask)
                    if (mask != WAR_CRUISE_MISSILE)
                        if (dist <= 320) shot = FALSE; // 190+40+90=320. Too close, use smaller gun.
            } else shot = FALSE;

            if (shot) self.war = WAR_CRUISE_MISSILE;
            else if (self.arsenal & WAR_ROCKET_LAUNCHER) {
                self.war = WAR_ROCKET_LAUNCHER;
                if (random() < 0.2)
                    if ((self.arsenal & WAR_SIDEWINDER) && (dist < 1000)) self.war = WAR_SIDEWINDER;
            }
            else if ((self.arsenal & WAR_SIDEWINDER) && (dist < 1000)) self.war = WAR_SIDEWINDER;
            else if (self.arsenal & WAR_GRENADE_LAUNCHER) self.war = WAR_GRENADE_LAUNCHER;
            else self.war = WAR_SIDEWINDER;
            ranger_rock1();
            return;
        }
    }

    if (self.arsenal & WAR_PLASMA_GUN) {
        if (RangerUse_Plasma (dist)) {
            self.war = WAR_PLASMA_GUN;
            ranger_plasma1();
            return;
        }
    }

    if (self.arsenal & (WAR_LASER_CANNON | WAR_BLASTER)) {
        if (RangerUse_Laser (dist)) {
            if (self.arsenal & WAR_LASER_CANNON) { self.war = WAR_LASER_CANNON; ranger_lc1(); }
            else { self.war = WAR_BLASTER; ranger_laser1(); }
            return;
        }
    }

    if (self.arsenal & WARx_USES_NAILS) {
        if (RangerUse_Nailgun (dist)) {
            if (self.arsenal & WAR_SUPER_NAILGUN) self.war = WAR_SUPER_NAILGUN;
            else self.war = WAR_NAILGUN;
            ranger_nail1();
            return;
        }
    }

    if (self.arsenal & WARx_USES_SHELLS) {
        if ( (self.ammo_shells >= 1) || !(self.xfl & XFL_USE_AMMO)) {
            if (self.arsenal & WAR_SUPER_SHOTGUN) self.war = WAR_SUPER_SHOTGUN;
            else self.war = WAR_SHOTGUN;
            ranger_shot1();
            return;
        }
    }

    // Can't use guns, so use the axe.  If he doesn't have an axe, give him one!
    self.arsenal = self.arsenal | WAR_AXE; // Make sure he has an axe.
    self.war = WAR_AXE;
    ranger_axer(); // Attack sound will be played there.
};

void() ranger_pain1  = [$pain1,  ranger_pain2  ] {};
void() ranger_pain2  = [$pain2,  ranger_pain3  ] {};
void() ranger_pain3  = [$pain3,  ranger_pain4  ] {};
void() ranger_pain4  = [$pain4,  ranger_pain5  ] {};
void() ranger_pain5  = [$pain5,  ranger_pain6  ] {};
void() ranger_pain6  = [$pain6,  ranger_run    ] {};

void() ranger_axpain1 = [$axpain1, ranger_axpain2 ] {};
void() ranger_axpain2 = [$axpain2, ranger_axpain3 ] {};
void() ranger_axpain3 = [$axpain3, ranger_axpain4 ] {};
void() ranger_axpain4 = [$axpain4, ranger_axpain5 ] {};
void() ranger_axpain5 = [$axpain5, ranger_axpain6 ] {};
void() ranger_axpain6 = [$axpain6, ranger_run     ] {};

void(entity inflictor, entity attacker, float damage) ranger_pain = {
    if (!PainSound()) return; // Use same sounds as players. Didn't make a sound.
    if (SUB_IgnorePain ()) return; // No pain anims in Nightmare.
    if (self.waitmin > time) return; // No pain anim this time even if played pain sound.

    self.waitmin = time + 1;
    if (self.war == WAR_AXE) ranger_axpain1();
    else ranger_pain1();
};

// Normal death
void() ranger_diea1  = [$deatha1,  ranger_diea2  ] {
	self.reviveframestart = $deatha11;
	self.reviveframeend = $deatha1;
};
void() ranger_diea2  = [$deatha2,  ranger_diea3  ] { monster_check_gib(); };
void() ranger_diea3  = [$deatha3,  ranger_diea4  ] { monster_check_gib(); };
void() ranger_diea4  = [$deatha4,  ranger_diea5  ] {};
void() ranger_diea5  = [$deatha5,  ranger_diea6  ] {};
void() ranger_diea6  = [$deatha6,  ranger_diea7  ] {};
void() ranger_diea7  = [$deatha7,  ranger_diea8  ] {};
void() ranger_diea8  = [$deatha8,  ranger_diea9  ] {};
void() ranger_diea9  = [$deatha9,  ranger_diea10 ] {};
void() ranger_diea10 = [$deatha10, ranger_diea11 ] { monster_death_postcheck(); };
void() ranger_diea11 = [$deatha11, monster_end   ] { monster_deadbody_check(); };

void() ranger_dieb1  = [$deathb1,  ranger_dieb2  ] {
	self.reviveframestart = $deathb9;
	self.reviveframeend = $deathb1;
};
void() ranger_dieb2  = [$deathb2,  ranger_dieb3  ] {};
void() ranger_dieb3  = [$deathb3,  ranger_dieb4  ] { monster_check_gib(); };
void() ranger_dieb4  = [$deathb4,  ranger_dieb5  ] { monster_check_gib(); };
void() ranger_dieb5  = [$deathb5,  ranger_dieb6  ] {};
void() ranger_dieb6  = [$deathb6,  ranger_dieb7  ] {};
void() ranger_dieb7  = [$deathb7,  ranger_dieb8  ] {};
void() ranger_dieb8  = [$deathb8,  ranger_dieb9  ] { monster_death_postcheck(); };
void() ranger_dieb9  = [$deathb9,  monster_end   ] { monster_deadbody_check(); };

void() ranger_diec1  = [$deathc1,  ranger_diec2  ] {
	self.reviveframestart = $deathc15;
	self.reviveframeend = $deathc1;
};
void() ranger_diec2  = [$deathc2,  ranger_diec3  ] {};
void() ranger_diec3  = [$deathc3,  ranger_diec4  ] { monster_check_gib(); };
void() ranger_diec4  = [$deathc4,  ranger_diec5  ] { monster_check_gib(); };
void() ranger_diec5  = [$deathc5,  ranger_diec6  ] {};
void() ranger_diec6  = [$deathc6,  ranger_diec7  ] {};
void() ranger_diec7  = [$deathc7,  ranger_diec8  ] {};
void() ranger_diec8  = [$deathc8,  ranger_diec9  ] {};
void() ranger_diec9  = [$deathc9,  ranger_diec10 ] {};
void() ranger_diec10 = [$deathc10, ranger_diec11 ] {};
void() ranger_diec11 = [$deathc11, ranger_diec12 ] {};
void() ranger_diec12 = [$deathc12, ranger_diec13 ] {};
void() ranger_diec13 = [$deathc13, ranger_diec14 ] {};
void() ranger_diec14 = [$deathc14, ranger_diec15 ] { monster_death_postcheck(); };
void() ranger_diec15 = [$deathc15, monster_end   ] { monster_deadbody_check(); };

void() ranger_died1  = [$deathd1,  ranger_died2  ] {
	self.reviveframestart = $deathd9;
	self.reviveframeend = $deathd1;
};
void() ranger_died2  = [$deathd2,  ranger_died3  ] {};
void() ranger_died3  = [$deathd3,  ranger_died4  ] { monster_check_gib(); };
void() ranger_died4  = [$deathd4,  ranger_died5  ] { monster_check_gib(); };
void() ranger_died5  = [$deathd5,  ranger_died6  ] {};
void() ranger_died6  = [$deathd6,  ranger_died7  ] {};
void() ranger_died7  = [$deathd7,  ranger_died8  ] {};
void() ranger_died8  = [$deathd8,  ranger_died9  ] { monster_death_postcheck(); };
void() ranger_died9  = [$deathd9,  monster_end   ] { monster_deadbody_check(); };

void() ranger_diee1  = [$deathe1,  ranger_diee2  ] {
	self.reviveframestart = $deathe9;
	self.reviveframeend = $deathe1;
};
void() ranger_diee2  = [$deathe2,  ranger_diee3  ] {};
void() ranger_diee3  = [$deathe3,  ranger_diee4  ] { monster_check_gib(); };
void() ranger_diee4  = [$deathe4,  ranger_diee5  ] { monster_check_gib(); };
void() ranger_diee5  = [$deathe5,  ranger_diee6  ] {};
void() ranger_diee6  = [$deathe6,  ranger_diee7  ] {};
void() ranger_diee7  = [$deathe7,  ranger_diee8  ] {};
void() ranger_diee8  = [$deathe8,  ranger_diee9  ] { monster_death_postcheck(); };
void() ranger_diee9  = [$deathe9,  monster_end   ] { monster_deadbody_check(); };

void() ranger_axdie1 = [$axdeth1,  ranger_axdie2 ] {
	self.reviveframestart = $axdeth9;
	self.reviveframeend = $axdeth1;
};
void() ranger_axdie2 = [$axdeth2,  ranger_axdie3 ] {};
void() ranger_axdie3 = [$axdeth3,  ranger_axdie4 ] { monster_check_gib(); };
void() ranger_axdie4 = [$axdeth4,  ranger_axdie5 ] { monster_check_gib(); };
void() ranger_axdie5 = [$axdeth5,  ranger_axdie6 ] {};
void() ranger_axdie6 = [$axdeth6,  ranger_axdie7 ] {};
void() ranger_axdie7 = [$axdeth7,  ranger_axdie8 ] {};
void() ranger_axdie8 = [$axdeth8,  ranger_axdie9 ] { monster_death_postcheck(); };
void() ranger_axdie9 = [$axdeth9,  monster_end   ] { monster_deadbody_check(); };

void() ranger_die = { // [FUNCTION]
    local float r;
    local string sfx;

    monster_death_precheck();
    if (Decapitated()) {
        if (self.war == WAR_AXE)
            monster_decap ('-11 0 20', ranger_axdecap1);
        else
        {
            r = (random() * 2) & 1;     //(random() * 4) & 3;
            if (r == 0)
                monster_decap ('-14 -3 20', ranger_decap1);
            else //if (r == 1)
                monster_decap ('3 1 21', ranger_decapb1);
//            else if (r == 2)
//                monster_decap ('-14 2 17', ranger_decapd1);
//            else
//                monster_decap ('-1 0 23', ranger_decape1);
        }
        return;
    }
// check for gib
    if (ranger_gib (self.health))
        return;

// regular death
    if (self.h2olevel == 3) {
        DeathBubbles(4);    // 20 is too many!
        sfx = "player/h2odeath.wav";
    } else {
        r = ((random() * 4) & 3) + 1;
        if (r == 1)
            sfx = "player/death1.wav";
        else if (r == 2)
            sfx = "player/death2.wav";
        else if (r == 3)
            sfx = "player/death3.wav";
        else //if (r == 4)
            sfx = "player/death4.wav";
    }
    sound(self,CHAN_VOICE, sfx,1,ATTN_NORM);

    if (self.war == WAR_AXE) {
        ranger_axdie1();
        return;
    }
    r = 1 + floor(random()*6);
    if (r == 1)
        ranger_diea1();
    else if (r == 2)
        ranger_dieb1();
    else if (r == 3)
        ranger_diec1();
    else if (r == 4)
        ranger_died1();
    else
        ranger_diee1();
};

void(float hello) ranger_sight = { // [FUNCTION]
    if (hello) sound(self,CHAN_VOICE, "drake/ranger/idle.wav",1,ATTN_NORM);
    else if (random() < 0.5) sound(self,CHAN_VOICE, "drake/ranger/sight1.wav",1,ATTN_NORM);
    else sound(self,CHAN_VOICE, "drake/ranger/sight2.wav",1,ATTN_NORM);
};

void() monster_ranger_precache = { // [FUNCTION]
    precache_model("progs/drake/ranger.mdl");
    precache_sound("drake/axeman/axe1.wav");
    precache_sound("drake/ranger/idle.wav");     // Was 'soldier/idle.wav'.
    precache_sound("drake/ranger/sight1.wav");
    precache_sound("drake/ranger/sight2.wav");
};

void() ranger_stats = { // [FUNCTION]
    local float sklevel, axe, am, s, n, r, c, arm;

    am = 0;
    sklevel = skill;
    sklevel = floor(sklevel);
    if (cranked) sklevel = sklevel + 1;
    if (sklevel >= 2) self.speed  = 32;   // Running speed.
    else self.speed  = 20;   // Walking speed.

    if ( !(self.drama1 || (self.items & ITx_ALL_WEAPONS)) ) {   // No predefined weapons.  Give default setup.
        s = WAR_SHOTGUN;
        n = WAR_NAILGUN;
        r = c = arm = 0;
        if (sklevel >= 2) {
            r = WAR_GRENADE_LAUNCHER;
            if (sklevel >= 3)
                arm = IT_ARMOR3;
            else
                arm = IT_ARMOR2;
        }
        else if (sklevel == 1)
            arm = IT_ARMOR1;

    // Set 'drama1' so there is no chance of override in 'monster_items'.
        self.war = s;
        self.drama1 = s | n | r | c;
        self.items = (self.items | arm) & ITx_ALL_ARMOR;
    }

    axe = (self.spawnflags & 4);
    if (axe)
    {   // In axe mode, ranger has limited ammo.
        // Also, if the ranger only has the axe, which is possible by
        // presetting drama*/items in map editor, set weapon to axe.
        axe = WAR_AXE;
        self.xfl = self.xfl | XFL_USE_AMMO;
        am = am * 3;
        if (self.drama1)
        {
            self.drama1 = self.drama1 | axe;
            if (self.drama1 & legalized == axe)
                self.war = axe;
        }
        else
        {
            self.items = self.items | 4096;
            if (self.items & ITx_ALL_WEAPONS == 4096)
                self.war = axe;
        }
    }
};

// --> QUAKED monster_ranger (1 0 0) (-16 -16 -24) (16 16 40) Ambush x Axe
void() monster_ranger = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

    // Changed from 'player.mdl' because ranger has decap scenes.
    self.mdl = "progs/drake/ranger.mdl";
    self.headmdl   = "progs/h_player.mdl";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
    if (self.health < 1) self.health = 100;
	self.gibhealth = -40;
	self.pain_flinch = 35; // Dag!  Oof!  Awf!
    self.mass = MASS_MEDIUM;
    ranger_stats();
    self.th_stand   = ranger_stand;
    self.th_walk    = ranger_walk;
    self.th_run     = ranger_run;
    self.th_missile = ranger_fire;
    self.th_pain    = ranger_pain;
    self.th_die     = ranger_die;
    self.th_sight   = ranger_sight;
    self.th_gib     = ranger_gib;
    self.th_revive  = ranger_revive;
    self.th_spawn   = monster_ranger;
    Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
    self.ryuflags   = self.ryuflags | RYU_ALERT; // From Dragons.
    if (soul_evil) self.purse = '1 0 1'; // Guaranteed gold coin.
	if (!self.classtype) self.classtype = CT_MONRANGER;
	if (!self.classgroup) self.classgroup = CG_ARMY;
	self.classmove = MON_MOVEFLY;
    monster_start();
};
