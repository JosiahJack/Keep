//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Hexen2, Qmaster
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
// Function count: 
//
// Implements: Hexen2 Ballista Useable Turret and Control Trigger
//
// Description:
// A giant crossbow turret that can be used by the player or triggered by an
// event to simulate monsters using it.
//=============================================================================

float SPAWNFLAG_BALLISTA_TRACK = 1;

void() ballista_think;

// self = player
// self.tetherfocus.tetherfocus = trigger_control
// self.tetherfocus = ballista
void() ResetControlTether = { // [FUNCTION]
    self.tetherfocus.tetherfocus.enemy = world;
    self.tetherfocus.tetherfocus.attack_finished = time + 2; // Prevent immediate retrigger.
    self.tetherfocus.tetherfocus = world; // Done resetting the trigger_control.
    self.tetherfocus.think1 = SUB_Null; // Do nothing once player has used it, go limp.
    self.tetherfocus.think = SUB_CalcAngleMoveThink;
    self.tetherfocus.nextthink = time + 0.1;
    self.tetherfocus.enemy.think = SUB_Remove; // Remove the aiment.
    self.tetherfocus.enemy.nextthink = time + 0.1;
    self.tetherfocus.oldenemy = world;
    self.tetherfocus.enemy = world; // Done resetting the aiment.
    self.tetherfocus = world; // Done resetting the ballista.
    self.tethered = FALSE;
    self.tetherdist = 0;
    self.attack_finished = time + 0.2;
    W_SetCurrentAmmo(self,TRUE);
};

void() PlayerBallistaThink { // [FUNCTION]
    local vector source;

    if (vlen(self.tetherfocus.dest1 - self.origin) > self.tetherdist) { ResetControlTether(); return; }

    if (self.tetherfocus.enemy.classname == "ballista_aiment") {
        source = (self.origin + '0 0 16');
        makevectors(self.v_angle); // Done in PreThink before this is called, but being explicit in case any added rules later might affect it.
        traceline(source,(source + (v_forward * 8192)),FALSE,self);
        if (vlen(trace_endpos - self.tetherfocus.dest1) > self.tetherdist
            && vlen(trace_endpos - self.origin) > self.tetherdist) {
            setorigin(self.tetherfocus.enemy,trace_endpos); // Set the aiment position where player is looking.
        }
    }
};

void() trigger_control_touch = { // [FUNCTION]
    local vector org, dir;
    local float fire_range;
    local entity aiment;

    if (!(other.flags & FL_CLIENT)) return;
    if (other.in_a_vehicle) return;
    if (self.enemy && self.enemy.flags & FL_CLIENT && self.enemy.tethered) return; // Already under control
    if (self.enemy && other != self.enemy) return;
    if (self.goalentity.health <= 0) return;
    if (vlen(self.goalentity.origin - other.origin) > self.meleerange) return;

    self.attack_finished = time + 2; // Give time for the player to move away.
    other.attack_finished = time + 0.1;
    other.tethered = TRUE;
    other.tetherdist = self.meleerange;
    other.tetherfocus = self.goalentity;
    W_SetCurrentAmmo(other,TRUE);
    self.enemy = other;
    traceline(other.origin, (org + (dir * 10000)), FALSE, self.enemy);
    aiment = spawn();
    if (aiment) {
        aiment.classname = "ballista_aiment";
        setorigin(aiment,trace_endpos);
        self.goalentity.enemy = aiment;
    }
    self.goalentity.oldenemy = other;
    self.goalentity.tetherfocus = self;
    self.goalentity.tethered = TRUE;
};

void() trigger_control_find_target =  { // [FUNCTION]
    self.goalentity = find(world, targetname, self.target);
    if (!self.goalentity) { dprint(self.classname); dprint( ": Could not find target: "); dprint(self.target); dprint("\n"); return; }

    self.goalentity.mangle = self.goalentity.angles;
};

void() trigger_control = { // [ENTITY]
    if (SUB_HideIfNoTarget()) return; 

    if (self.meleerange <= 0) self.meleerange = 112;
    self.enemy = world;
    self.touch = trigger_control_touch;
    self.ltime = time;
    InitTrigger();
    self.think = trigger_control_find_target;
    self.nextthink = time + 1.00;
    self.attack_finished = 0;
};

void() chunk_death =  { // [FUNCTION]
    self.gibtype = GIBTYPE_STONE;
    if (self.classtype == CT_BALLISTA) self.max_health = 500; // Push the gibs more.
    ThrowGib(11,rint(7));
    ThrowGib(12,rint(3));
    ThrowGib(13,rint(6));
    ThrowGib(14,rint(4));
    if (self.classtype == CT_BALLISTA) SUB_UseTargets();
    self.touch = SUB_Null;
    self.solid = SOLID_NOT;
    self.think = SUB_Remove;
    self.nextthink = time + 0.1;
};

void() BalBoltTouch =  { // [FUNCTION]
    local vector dir;

    if (other.takedamage) {
        if (other != self.goalentity && !VectorIsAllZeros(self.velocity)) {
            self.goalentity = other;
            dir = normalize (self.velocity);
            traceline ( (self.origin - (dir * 25.00000)), (self.origin + (dir * 25)), FALSE, self);
            if (other.flags & FLx_CREATURE) {
                SpawnMeatSpray(self,trace_ent,(crandom() * 300));
                SpawnMeatSpray(self,trace_ent,(crandom() * 300));
            }
            T_Damage(other, self, self.owner.enemy.enemy, self.dmg,DAMARMOR);
        }
        self.think = chunk_death;
        self.nextthink = time + 0.2;
        if ( ((other.solid == SOLID_BSP) || (normalize(self.velocity) != self.movedir)) ) {
            chunk_death();
        }
    } else {
        if (other.solid == SOLID_BSP || other == world) {
            self.velocity = VEC_ORIGIN;
            self.avelocity = VEC_ORIGIN;
            self.solid = SOLID_NOT;
            self.touch = SUB_Null;
            self.think = chunk_death;
            self.nextthink = time + 10;
            return;
        }
        chunk_death();
    }
};

entity() FireBalBolt =  { // [FUNCTION]
    local vector launchPoint, targetPoint;
    local entity balbolt;

    balbolt = spawn();
    if (!balbolt) return world;

    balbolt.owner = self;
    if (self.goalentity.oldenemy.flags & FL_CLIENT) balbolt.owner = self.goalentity.oldenemy;
    makevectors(self.angles);
    launchPoint = ((self.origin + self.view_ofs) + (v_forward * 10));
    if ((self.spawnflags & SPAWNFLAG_BALLISTA_TRACK) && (self.enemy.flags & FLx_CREATURE)) {
        targetPoint = (self.enemy.absmax + self.enemy.absmin) * 0.5;
    } else {
        if (self.tethered) { // Player controlled
            targetPoint = self.enemy.origin;
        } else {
            targetPoint = self.view_ofs;
            traceline(launchPoint,(launchPoint + balbolt.velocity), FALSE,self);
            if (trace_ent != self.goalentity && self.goalentity.health > 0) {
                targetPoint = (self.goalentity.absmin + self.goalentity.absmax) * 0.5;
            }
        }
    }
    balbolt.velocity = normalize(targetPoint - launchPoint) * 1000;
    balbolt.movedir = normalize ( balbolt.velocity);
    balbolt.movetype = MOVETYPE_FLYMISSILE;
    balbolt.solid = SOLID_BBOX;
    balbolt.classgroup = CG_PROJALL;
    balbolt.classtype = CT_PROJ_BALSHAFT;
    balbolt.touch = BalBoltTouch;
    balbolt.angles = vectoangles(balbolt.velocity);
    balbolt.avelocity_z = 500;
    balbolt.dmg = self.dmg;
    balbolt.goalentity = balbolt;
    balbolt.gib1mdl = MODEL_BRK_WOOD2A;
    balbolt.gib2mdl = MODEL_BRK_WOOD2B;
    balbolt.th_die = chunk_death;
    balbolt.health = 10;
    balbolt.death_sound = "hexen2/fx/woodbrk.wav";
    setmodel(balbolt, "progs/hexen2/balbolt.mdl");
    setsize(balbolt,'-4 -4 -4','4 4 4');
    setorigin(balbolt,launchPoint);
    return balbolt;
};

void() ballista_fire = { // [FUNCTION]
    if (self.goalentity.oldenemy.flags & FL_CLIENT) {
        self.ammo_bolts = self.ammo_bolts - 1;
        if (self.ammo_bolts < 1) {
            sound(self,CHAN_WEAPON,"weapons/noammo.wav",1,ATTN_NORM);
            self.think = SUB_Null;
            return;
        }
    }
    SUB_AdvanceFrame(1,30);
    if (self.frame == 2) sound(self,CHAN_WEAPON,"hexen2/weapons/ballista.wav",1,ATTN_NORM);
    else if (self.frame == 4) FireBalBolt();
    else if (self.frame == 15) sound(self,CHAN_WEAPON,"hexen2/weapons/ballwind.wav",1,ATTN_NORM);
    if (self.frame == 30) {
        self.frame = 0;
        self.attack_finished = time + 1.5;
        if (self.spawnflags & SPAWNFLAG_BALLISTA_TRACK || self.tethered) self.think = ballista_think;
        else self.think = SUB_Null;
    }
};

void() ballista_track = { // [FUNCTION]
    local float pitchmod;
    local vector my_pitch, ideal_pitch;

    ai_face();
    if (FacingIdeal()) {
        if (self.attack_state == AS_MISSILE && self.th_missile) {
            self.th_missile();
        } else if (self.attack_state == AS_MELEE && self.th_melee) {
            self.th_melee();
        }
        self.attack_state = AS_STRAIGHT;
    }
    makevectors(self.angles);
    my_pitch = normalize(v_forward);
    ideal_pitch = normalize(self.enemy.origin - self.origin);
    ideal_pitch = vectoangles(ideal_pitch);
    if ( (ideal_pitch_z > my_pitch_z) ) {
        if ((ideal_pitch_z - my_pitch_z) > self.count) pitchmod = self.count;
        else pitchmod = (ideal_pitch_z - my_pitch_z);

        self.angles_z += pitchmod;
    } else {
        if ( (ideal_pitch_z < my_pitch_z) ) {
            if ((my_pitch_z - ideal_pitch_z) > self.count) pitchmod = self.count;
            else pitchmod = (my_pitch_z - ideal_pitch_z);

            self.angles_z -= pitchmod;
        }
    }

    if (self.tethered) return; // Don't fire automatically when player controlled, just aim.

    if ((self.attack_finished + self.speed) < time) {
        if (visible(self.enemy) ) {
            if (infront(self.enemy)) {
                if (random() < 0.20000) ballista_fire();
            }
        }
    }
};

void() ballista_think = { // [FUNCTION]
    if (self.spawnflags & SPAWNFLAG_BALLISTA_TRACK && !self.tethered) {
        if (self.enemy) {
            if (self.enemy.health < 1) {
                FindTarget();
            } else if (self.enemy.alignment == self.alignment) {
                self.enemy = world;
                FindTarget();
            } else if (Invisible(self.enemy)) { // Just checking states.
                FindTarget();
            } else if(!visible(self.enemy)) { // Trace check last for performance.
                FindTarget();
            }
        } else {
            FindTarget();
        }
    }

    if (self.enemy || self.tethered) ballista_track();
    if (self.tethered && self.frame > 15) SUB_AdvanceFrame(1,30);
    self.nextthink = self.ltime + 0.1;
    self.think = ballista_think;
};

void() obj_ballista =  { // [ENTITY]
    self.mdl = "progs/hexen2/ballista.mdl";
    precache_model(self.mdl); // The giant crossbow turret.
    precache_model("progs/hexen2/balbolt.mdl"); // The bolt it shoots.
    precache_model("progs/hexen2/xhair.mdl"); // Player crosshair
    precache_model(MODEL_BRK_WOOD1A);
    precache_model(MODEL_BRK_WOOD1B);
    precache_model(MODEL_BRK_WOOD1C);
    precache_model(MODEL_BRK_WOOD1D);
    precache_model(MODEL_BRK_WOOD2A);
    precache_model(MODEL_BRK_WOOD2B);
    precache_sound("weapons/noammo.wav"); // For when the turret is out.
    precache_sound("hexen2/weapons/ballista.wav");
    precache_sound("hexen2/weapons/ballwind.wav");
    self.death_sound = "hexen2/fx/leafbrk.wav";
    self.gib1mdl = MODEL_BRK_WOOD1A;
    self.gib2mdl = MODEL_BRK_WOOD1B;
    self.gib3mdl = MODEL_BRK_WOOD1C;
    self.gib4mdl = MODEL_BRK_WOOD1D;
    precache_sound(self.death_sound); // Death sound
    setmodel(self,self.mdl);
    setsize(self,'-16 -16 -8', '16 16 32');
    self.dest1 = bmodel_origin(self); // Check for bmodel origin on self/angletarget entities
    if (self.health <= 0) self.health = 40;
    self.max_health = self.health;
    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_SLIDEBOX;
    self.bouncegrenade = TRUE;
    self.takedamage = DAMAGE_YES; // Grenades bounce off.
    self.mass = MASS_HEAVY; // Grappling causes player to move, not this.
    self.th_die = chunk_death;
    self.ammo_bolts = 30;
    self.view_ofs = '0 0 24';
    self.tethered = FALSE;
    self.hull = 3; // HULL_SCORPION
    if (self.cnt <= 0) self.cnt = 30;
    if (self.count <=0 ) self.count = 5;
    if (self.health <= 0) { self.takedamage = DAMAGE_NO; self.health = 0; }
    if (self.dmg < 1) self.dmg = 50;
    if (self.speed < 1)  self.speed = 5;
    self.oldorigin = self.angles;
    self.yaw_speed = self.count;
    self.th_missile = ballista_fire;
    self.attack_finished = time + 0.5;
    self.use = ballista_fire;
    self.th_missile = ballista_fire;
    self.view_ofs = '0 0 48';
    self.classtype = CT_BALLISTA;
    self.classgroup = CG_TRAPS;
    self.think = ballista_think;
    self.nextthink = time + 0.5;
};