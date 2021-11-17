//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
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
// Entity count: 0
// Function count: 86
//
// Implements: Projectile System for Players and Monsters - continued
//
// Description:
// More functions for spawning various projectiles that cause damage.
//=============================================================================

float SPIKEY_RANGE = 8192; // Quake2 railgun range.
float SPIKEY_DAMAGE = 9;	
float THOR_SPEED = 600;	

// Average rocket damage is 100-120.  Scaling maximum damage down to 35, the new range is from 29.17 to 35, with the average at 32.08.
// 32*3 = 96, which is double of an equalized shotgun's 6*8 (or 12*4) = 48.  Super shotgun's damage rate is doubled similarly by the Tome.
// Damage based on unmodified shotguns (or those in nsoe).  Recent decision was made to buff shotguns for Drake.
float EXSHELL_DAMAGE = 35;

void(float reload) W_Reload;
void() Axe_Watch;
void(vector p1, vector p2, entity attacker, float damage, entity inflictor, float fx) Piercer_Trace;
void() StackDamage_Clear;
void(vector pos, vector dir, float rubicon) make_spark;
void(float lo, float hi) Thor_Slam;
.float  struck_by_mjolnir; // Hipnotic Slam.  Must use 'struck_by...' because tesla code uses that too.
void(entity hit, float damage) AddMultiDamage;
void() monster_death_precheck;
void(float shotcount, vector spread) FireBullets;

// ECHO SHOTS
// Used to create more shots between frames to give firing rates faster
// than 10 frames per second.  Only clients should use this because of
// intermission and fire button checks, which do not apply to monsters.
void() Echo_Think = { // [FUNCTION]
    if ((!intermission_running && !cutscene) && ((self.owner.button0 || self.tome_finished || self.owner.perms & POW_DOUBLE)) && (self.owner.health > 0)) SUB_ThinkImmediate (self.owner, self.think1);
    remove (self);
};

// Spawns a dummy entity that will fire a shot for its owner.
void(float pause, void() thinkst) Echo_Shot = { // [FUNCTION]
    local   entity  echo;

    echo = spawn();
    echo.owner      = self;
    echo.nextthink  = time + pause;
    echo.think      = Echo_Think;
    echo.think1     = thinkst;
    echo.tome_finished  = self.tome_finished;
};

//  Archer Knight Arrows
// Update 11/24/09:  Constants moved to defs.
// Magic arrow explosion code.
void() AkArrow_Explode = { // [FUNCTION]
    self.count = self.count & 3;
    sound (self, CHAN_AUTO, "hexen2/weapons/explode.wav", 1, ATTN_NORM);
    Colored_Explosion (self.origin, self.count);
    BecomeFancy (X80_SPARK_ORANGE + (self.count * 6), 6);
};

void() AkArrow_Magic_Touch = { // [FUNCTION]
	local float sped;

	// Other, more powerful and explosive arrow types.
    if (self.worldtype && (other.flags & FLx_CREATURE) && !Ally_Check(other,self.master) && !HasReflection(other,self.origin,0) && other.mass > 0 && other.mass <= MASS_SUPER) { // Knockback effect.
		sped = self.speed;
		if (other.mass == MASS_SUPER) sped = sped / 2;
		other.velocity = other.velocity + (self.movedir * sped);
		if (other.flags & FL_ONGROUND) {
			other.flags = other.flags - FL_ONGROUND;
			if (other.velocity_z < 150) other.velocity_z = 150;
		}
    }
    Touch_Missile();
};

// Called when an arrow hits something.
void() AkArrow_Wood_Touch = { // [FUNCTION]
    local vector org;

    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected ()) return;

    self.touch = SUB_Null; // Stack overflow prevention.
    if (other.takedamage) {
        spawn_touchblood(self, other, self.dmg);
        T_Damage(other, self, self.master, self.dmg,DAMARMOR);
        sound(self, CHAN_WEAPON, "drake/archer/arrow1.wav", 1, ATTN_IDLE);
        remove(self);
        return;
    }
    if (other.solid != SOLID_BSP) { // Break on impact. e.g., shielded mega enforcer.
        org = self.origin - (8 * normalize(self.velocity));
        sound(self, CHAN_WEAPON, "drake/archer/arrowbrk.wav", 1, ATTN_IDLE);
        Tent_Point(TE_GUNSHOT,org);
        remove(self);
        return;
    }

	// Imbed into the surface.
    if (random() < 0.5) sound (self, CHAN_WEAPON, "drake/archer/arrow2.wav", 1, ATTN_IDLE);
    else sound (self, CHAN_WEAPON, "drake/archer/arrow3.wav", 1, ATTN_IDLE);

    self.movetype = MOVETYPE_NONE;
    self.velocity = self.avelocity = '0 0 0';
    self.nextthink= time + 1.5; // Reset think so arrow sticks in wall for a moment then vanishes.
    self.think    = SUB_Remove;
    self.touch    = SUB_Remove;
    if (other) { // Hit something that may move later.  Watch the axe... er, arrow.
        self.enemy      = other;
        self.delay      = self.nextthink;
        self.nextthink  = time + 0.100;
        self.think      = Axe_Watch;
    }
};

void() AkArrow_Think = { // [FUNCTION]
    if (self.delay <= time) {remove (self); return;}

    self.speed   = vlen (self.velocity);
    self.movedir = self.dest = normalize (self.velocity);
    self.angles  = vectoangles(self.movedir);
    if (self.cnt) Meteor_Trail (self.cnt, 1, FALSE);
	else particle (self.origin, '0 0 0', 6, 1);	//ijed: subtle basic arrow trail

    self.nextthink = time + 0.05;
};

void(vector start, vector dir, float type) AkArrow_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "arrow";
    newmis.movedir      = dir;
	newmis.speed        = AKARROW_SPEED_FLY;
	newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_z  = newmis.speed;     // Makes arrow model spiral.
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dest         = dir;      // for 'spawn_touchblood'.

	// Hexen2 Damage: green = 5-7, red = 8-12, gold = 13-17.  For Quake, do x*3 so that orange = 15-20, gold = 25-35, blue = 40-50.  Update/Drake:  Green = 9, Red = 18, Yellow/Orange = 30.
    if (type & 2) { // Energy arrow.
        type = newmis.count = 0; // Was LF_YELLOW.
        Laser_Color (newmis, type);
        newmis.worldtype    = TRUE; // Indicate super type
        newmis.dmg          = 30;
        newmis.think1       = AkArrow_Explode; // Arrows don't explode in Hexen2, but I am making them so in Drake. -PM
        newmis.cnt          = newmis.waitmax;
        newmis.effects      = newmis.effects | EF_DIMLIGHT;
        newmis.oldorigin    = start;
        newmis.skin         = ARROW_MAGIC + type;  // Yes, use + not |.
    } else {
        newmis.worldtype    = FALSE;
        newmis.cnt          = 0; // Normal wooden arrow.
        if (type & 4) newmis.dmg = 9; // Goblin arrow.
        else if (type & 1) newmis.dmg = 18; // Lord arrow.
        else newmis.dmg     = 15; // Orc arrow.
        newmis.skin         = type & 1;
    }
    newmis.enemy        = world;
    newmis.touch        = AkArrow_Magic_Touch;
    newmis.delay        = time + 5;         // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = AkArrow_Think;
    if (!newmis.cnt) newmis.touch = AkArrow_Wood_Touch; // ijed regular arrows now have a continual think to produce a subtle particle trail, not one of the more magical built in mdl variants
    if (self.classtype == CT_MONREBEL) newmis.frame = 1; // Crossbow bandit hack.
    setall(newmis,"progs/drake/arrow.mdl",'0 0 0','0 0 0',start);
};

// From Drake's throwing axe.  This removes the axe if its surface moves or if its been out too long.  Update:  Also called by goblin arrow code for the same purpose.
void() Axe_Watch = { // [FUNCTION]
    if (self.delay <= time) remove(self);
    else if (vlen (self.enemy.velocity) > 0) remove(self);      // Surface moved, so remove the axe now.
    else {
		self.nextthink = time + 0.1;
		self.think = Axe_Watch;
	}
};

//  Burst Lightning
//  The "Burst" is a form of chain lightning cast at a target.  If the
//  target is struck, and there are more targets near the one first struck,
//  secondary bolts will erupt from the primary target and strike as many
//  extra targets as possible.
//
//  This form of chain lightning is based from the description of the Chain Lightning spell in the 3rd edition of Dungeons and Dragons.
//  This returns the endpoint where a bolt of chain lightning should strike.  The spot returned is usually the center of the target struck.
vector(entity attacker, entity targ, vector start, vector end) ChainLit_Point = { // [FUNCTION]
    local vector spot, dir;
	local float d_impact, d_ideal, dist;

    spot = Midpoint (targ);
    traceline (start, spot, FALSE, attacker);
    if (trace_ent == targ) { // We can hit the center.  
        dir = spot - start;
        d_impact = vlen (spot - trace_endpos);
        d_ideal = vlen (dir);
        dir = normalize (dir);
        dist = floor (d_ideal / 32) * 32; // Bolts in beam TEs are drawn in intervals of 30. UPDATE: Using new qc method which more accurately uses 32.

		// Find the best endpoint of the bolt so that it looks good when drawn.  This point is located between the targer's center and where the bolt hit.
        if (dist >= d_impact) end = start + dir*dist;
        else {
            spot = start + dir*(dist+30);
            if (spot_x >= targ.absmin_x && spot_x <= targ.absmax_x && spot_y >= targ.absmin_y && spot_y <= targ.absmax_y && spot_z >= targ.absmin_z && spot_z <= targ.absmax_z) end = spot;
        }
    }
    return end;
};

// Called within 'BurstLit_Chain' below.
float(entity targ, entity inflictor, entity attacker, float damage, vector spot, float bang) BurstLit_Trace = { // [FUNCTION]
    local vector end;

    if (targ.flags & FL_CLIENT) end = targ.origin; // Use origin because of TE beam code for clients.
    else end = Midpoint(targ);

    // Update:  Traceline must hit intended target! Targets can take damage from one bolt once because they can neither stack nor pierce.
    // Ghost touch code must be called before calling this function if ghosts are to be hit.
    traceline (spot, end, FALSE, inflictor); // 3rd was TRUE.
    if (trace_ent == targ) {
        // Draw from source point to target point, except for players.  For players, draw from target point to source point because engine always draws from origin in case of player.
        if (targ.flags & FL_CLIENT) Tent_Beam (TE_LIGHTNING2, targ, end, spot);
        else Tent_Beam (TE_LIGHTNING2, targ, spot, end);

        if (bang == 2) sound (inflictor, CHAN_VOICE, "weapons/lstart.wav", 1, ATTN_NORM);
        else if (bang) sound (inflictor, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);

        end = trace_endpos; // Use where bolt hit for blood spot.
        BoltDamage(targ,inflictor,attacker,end,damage);
        return TRUE;
    }
    return FALSE;
};

// Shoots multiple lightning bolts at nearby targets from a common point.  Used by burst lightning gun.  Also used by plasma discharge.
void(entity inflictor, entity attacker, float damage, entity ignore, vector spot, vector pak, float bang) BurstLit_Chain = { // [FUNCTION]
    local entity head, saved;
    local float hits, nofriendlyfire, radius, maxhits;

    nofriendlyfire = pak_x;
    radius = pak_y;
    maxhits = pak_z;
    hits = 0;
    saved = world;
    head = findradius (spot, radius);
    while (head) { // Notarget/stealth won't save you from discharge.  Don't waste hits on immune targets, though.
        if (head.takedamage == DAMAGE_AIM && head != attacker && head != ignore && head.resist_cells < 1 && !(nofriendlyfire && Ally_Check(head,attacker))) {
			// Go to the trouble of zapping live, highly vulnerable targets first instead of dead or resistant targets.
			if (head.deadflag || (head.health <= 0) || (head.resist_cells > 0)) { // Dead or resistant -- save it for later.
				head.chain2 = saved;
				saved = head;
			} else if (BurstLit_Trace(head,inflictor,attacker,damage,spot,bang)) {
				hits = hits + 1;
				if (hits >= maxhits) return;
			}
        }
        head = head.chain;
    }
	// Now we zap the saved targets because we ran out of other targets.
    while (saved) {
        if (BurstLit_Trace(saved,inflictor,attacker,damage,spot,bang)) {
            hits = hits + 1;
            if (hits >= maxhits) return; // I hate to burst your chain, but...
        }
        saved = saved.chain2;
    }
};

// Fires a fat bolt of lightning, then splits into three thinner bolts after hitting a target.
// 'inflictor' = Don't hit this entity during the traceline.
// 'src'       = From whom the lightning gets drawn from.
// 'targ'      = Target by traceline.
void(vector p1, vector p2, entity attacker, float damage, float reach) BurstLit_Bolt = { // [FUNCTION]
    local   entity  inflictor, src, targ;
    local   vector  pak, dir;
    local   float   boing, iter;

    pak_x = TRUE; // No friendly fire.
    pak_y = reach;
    pak_z = 3; // Max number of targets.

    inflictor = src = attacker;
    while (src) {
		// Scan for a hit.
        reach = vlen(p2 - p1);
        traceline (p1, p2, FALSE, inflictor);
        p2 = trace_endpos;
        targ = trace_ent;

		// Check for reflection.
        boing = FALSE;
        if (targ) {
            if (HasReflection (targ, p2, damage) || targ.resist_cells >= 1) boing = TRUE;
		}

		// Draw beam.
        if (targ.takedamage) { // Hit something?  Aim bolt at its center.
            if (!boing) p2 = ChainLit_Point (attacker, targ, p1, p2);
		}
        Tent_Beam (TE_LIGHTNING1, src, p1, p2);   // Use the fat beam.
        src = world;    // Unless reflected later, end loop when done.

		// Do hit effects and damage.
        if (boing) {
            ReflectSound(targ);
            if (src != lightning) {
                reach = reach - vlen(p2 - p1);  // Get remaining dist.
                p1 = p2;
                p2 = p2 + (normalize(p2 - targ.origin) * reach);
                inflictor = targ;
                src = lightning;
            }
        } else {
            if (targ.takedamage) {
                // Direct hit does full damage and splits the beam.

				if (self.tome_finished) {
					// Make some extra tome of power spark effects
					iter = 0;
					while (iter < 8) {
						dir = safe_client_forward();
						make_spark(targ.origin, dir, FALSE); // False to use direction.
						newmis.velocity_z = 200 + crandom() * 300;
						newmis.velocity_y = crandom() * 300;
						newmis.velocity_x = crandom() * 300;
						newmis.solid = SOLID_NOT;
						newmis.touch = SUB_Null;
						newmis.skin = 8;
						iter = iter + 1;
					}
					damage = damage * 2;
				}

				if (targ.health < damage) { // Monster go pop!
					iter = 0;
					sound (self, CHAN_AUTO, "rrp/misc/spark.wav", 1, ATTN_STATIC);
					while (iter < 30) {
						dir = safe_client_forward();
						make_spark(targ.origin, dir, FALSE); // False to use direction.
						if (iter < 15) newmis.velocity_z = 200;
						else newmis.velocity_z = -200;
						newmis.velocity_y = crandom() * 100;
						newmis.velocity_x = crandom() * 100;
						newmis.solid = SOLID_NOT;
						newmis.touch = SUB_Null;
						newmis.skin = 8;
						iter = iter + 1;
					}
				}
                BoltDamage(targ,inflictor,attacker,p2,damage);
                BurstLit_Chain(targ,attacker,damage * 2 / 3,targ,p2,pak,FALSE);
            }
        }
    }
};

// Called by exploding plasma balls.  Also by Mjolnir.
void() RyuPlasma_Discharge = { // [FUNCTION]
    local vector pak;

    pak_x = self.style;
    pak_y = self.distance;
    pak_z = self.count; //5
    BurstLit_Chain(self,self.owner,self.dmg * 0.5,self.enemy,self.origin,pak,TRUE);
};

void() RyuPlasma_Explode = { // [FUNCTION]
    local float dmg1, dmg2;

    if (!self.dmg) self.dmg = 100;
    if (!self.distance) self.distance = 320;
    if (!self.count) self.count = 5;

    if (self.enemy) {
        dmg1 = (0.8 + random()*0.2) * self.dmg;
        dmg2 = self.dmg * 0.5; // PM:  Add discharge damage to impact damage, then ignore other in the discharge call.
		self.classgroup = CG_PROJROCKETS; // Saves a hit in the discharge for someone else.
        T_Damage(self.enemy,self,self.owner,dmg1,DAMARMOR);
		self.classgroup = CG_PROJPLASMAROGUE;
		T_Damage(self.enemy,self,self.owner,dmg2,DAMARMOR);
    }
    T_RadiusDamage(self,self.owner,self.dmg*0.7,self.enemy,DAMAGEALL); // Don't do radius damage to the other, because all the damage was done in the impact.
    sound (self, CHAN_AUTO, "rogue/plasma/explode.wav", 1, ATTN_NORM);
    setorigin(self, self.origin - 8*normalize(self.velocity)); // PM:  Do it right.
    Tent_Explosion2 (self.origin, 244, 3);
    RyuPlasma_Discharge ();
    BecomeAnyExplosion (138, 6, "progs/drake/s_fancy.spr");
};

void() RyuPlasma_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self);  return;}

    self.enemy = other;
    RyuPlasma_Explode();
};

void() RyuPlasma_Think = { // [FUNCTION]
    local float pc;

    if (self.delay <= time) {remove (self);  return;}

    pc = pointcontents(self.origin);
    if ((pc <= CONTENT_WATER) && (pc >= CONTENT_LAVA)) {RyuPlasma_Explode();  return;}

    particle(self.origin, self.velocity * 0.005, 9, self.waitmin);   //2
    particle(self.origin, self.velocity * 0.01, 41, self.waitmax);   //4
    self.nextthink = time + 0.05;
};

void(vector start, vector dir, float sped, float damage) RyuPlasma_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup   = CG_PROJPLASMAROGUE;
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "plasma";
    newmis.movedir      = dir;
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = damage;
    newmis.distance     = damage + 220; // 320 when dmg == 100.  Mjolnir has a range of 350.
    newmis.enemy        = world;
    newmis.style        = FALSE; // TRUE is 'no friendly fire' discharge.
    newmis.touch        = RyuPlasma_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = RyuPlasma_Think;
    newmis.waitmin      = 2;
    newmis.waitmax      = 4;
    newmis.effects      = EF_DIMLIGHT;  // DoE used EF_BRIGHTLIGHT.
    setmodel (newmis, "progs/plasma.mdl");  // Big plasma balls from DoE.
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};

void() Acidball_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}

    self.touch = SUB_Null;
    self.enemy = other;
    if (!self.dmg) self.dmg = 120;
    if (self.enemy) T_Damage (self.enemy,self,self.owner,self.dmg / 6 * (5 + random()),DAMARMOR); // Don't check health, just if there is a target.  Someone took a direct hit.
    T_RadiusDamage(self,self.owner,self.dmg,self.enemy,DAMAGEALL); // Don't do radius damage to the enemy, because all the damage was done in the impact.
	setorigin(self, self.origin - (8 * normalize(self.velocity))); // PM:  Do it right.
    Tent_Explosion2(self.origin,48,16);
    BecomeAnyExplosion(115,5,"progs/drake/s_fancy.spr");
};

//  Acid Bomb -- Used by green dragon.
void(vector start, vector dir, float sped, float damage) Acidball_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.owner        = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = damage;
    newmis.dest         = dir;
    newmis.touch        = Acidball_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;
    setmodel (newmis, "progs/drake/acidbal1.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
};

//  Acid -- Used by scrag and green dragon.
void() Acid_Think = { // [FUNCTION]
    if (self.delay <= time) {remove (self); return;}

    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Acid_Toss = { // [FUNCTION]
    launch_projectile(start, dir, CT_PROJ_WIZ, sped);
    newmis.movetype  = MOVETYPE_TOSS;
    newmis.speed     = sped;
    newmis.velocity  = (dir * sped) + '0 0 200';
    newmis.angles    = vectoangles (newmis.velocity);
    newmis.delay     = newmis.nextthink;
    newmis.nextthink = time + 0.1;
    newmis.think     = Acid_Think;
};

//  Meat -- Used by zombie and nightshade (wraith dragon).
void() Meat_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self); return; }
    if (Reflected()) return;

    if (other.takedamage) {
        self.touch = SUB_Null;      // Stack overflow prevention.
        T_Damage(other,self,self.master,self.dmg,DAMARMOR);
        sound(self,CHAN_WEAPON,"zombie/z_hit.wav",1,ATTN_NORM);
        remove(self);
        return;
    }

    sound(self,CHAN_WEAPON,"zombie/z_miss.wav",1,ATTN_NORM); // bounce sound
    self.velocity = self.avelocity = '0 0 0';
    self.touch = SUB_Remove;
};

void(vector start, vector dir) Meat_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJALL;
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.velocity_z   = newmis.velocity_z + 200;  // Used to be 200 only.
    newmis.avelocity    = '3000 1000 2000';
    newmis.dmg          = 10;
    newmis.touch        = Meat_Touch;
    newmis.nextthink    = time + 2.5;
    newmis.think        = SUB_Remove;
    setall(newmis,"progs/zom_gib.mdl",'0 0 0','0 0 0',start);
};

//  Rain Storm -- Used by the elemental boss barons.  Various missile functions for the rainstorm.
void() RainStorm_Ice = { // [FUNCTION]
    Ice_Launch (trace_endpos, '0 0 -1', 1000); // Use flymissile instead of toss for the missile clip bonus.  Then set speed to a reasonably fast value to use for terminal velocity.
    newmis.master   = newmis.owner  = self.owner;
    newmis.delay    = time + 2.5;
    newmis.dmg      = self.dmg;
};

void() RainStorm_Think = { // [FUNCTION]
    local vector p1, p2, dir;

    if (self.delay <= time) { super_active = 0; remove (self); return; }

    p1 = self.enemy.origin; // Find a point to spawn a rain drop.
    p2_x = crandom() * self.distance + p1_x;
    p2_y = crandom() * self.distance + p1_y;
    p2_z = p1_z;
    traceline (p1, p2, TRUE, self);
    p2 = trace_endpos;
    if (trace_fraction < 1) { // Move away from the wall a tiny bit.
        dir = normalize (p2 - p1);
        p2 = p2 - dir*2;
    }
    traceline (p2, p2 + '0 0 2048', TRUE, self);
    if (trace_fraction < 1) trace_endpos = trace_endpos - '0 0 2'; // Move endpoint away from the ceiling.  We can't pass vectors to a think function, so use trace_endpos.

    if (self.think1) self.think1 ();
    else { remove(self); return; }

    self.nextthink = time + self.wait;
};

// Spawns a missile spawner that drops shots on a target from the ceiling.
void() RainStorm = { // [FUNCTION]
    if (super_active) return;

    super_active = 1; // This chews through a lot of edicts.
    newmis = spawn();
    setorigin (newmis, '0 0 0');
    newmis.owner    = self;
    newmis.enemy    = self.enemy;
    newmis.delay    = time + 5;
    newmis.think    = RainStorm_Think;
    newmis.think1   = RainStorm_Ice;
    newmis.dmg      = 18;
    newmis.wait     = 1 / 20;
    newmis.distance = 64;
    newmis.nextthink= 0.01;
};

void() Attack_Saw = { // [FUNCTION]
    local vector  spot, source, org, vec, vec2;
	local float src_dist, dotprod, axedmg, damage, pain, save, ignore;
	local entity onflr, tself, tother;

	makevectors(self.v_angle); // Calculate viewing angle
	source = self.origin + '0 0 16'; // Move source point up body
	onflr = find(world, bodyonflr, MON_ONFLR);
	while (onflr) { // See if there are any bodies lying around
		src_dist = vlen(source - onflr.origin);
		if (src_dist < RANGE_CHOPAXE) {			// Is the body close to the player?
			org = onflr.origin - '0 0 16';		// move origin close to floor	
			vec2 = normalize (org - self.origin);
			dotprod = vec2 * v_forward;
			if (dotprod > 0.6) {				// Is the body infront of the player
				onflr.origin = org;				// Move gib closer to floor
				onflr.bodyonflr = string_null;	// no more body gibbing
				tself = self; tother = other;	// save self/other
				self = onflr; other = tself;	// switch around
				if (onflr.classgroup == CG_ZOMBIE) {
					self.health = 0;
					Killed(onflr, tself);
				} else {
					self.max_health = MON_NOGIBVELOCITY; // use minimal velocity
					monster_ThrowGib();			// throw parts
				}
				
				self = tself; other = tother;	// switch back
				SpawnBlood (onflr, onflr.origin, '0 0 50', axedmg*4);
				return;																// Finished
			}
		}
		// See if there are anymore bodies close by
		onflr = find(onflr,bodyonflr, MON_ONFLR);
	}

    spot = self.origin + '0 0 16';      // 'source'
    traceline (spot, spot + v_forward*64, FALSE, self);
    if (trace_fraction == 1.0) return;

    spot = trace_endpos - v_forward*4;        // 'org'
    if (trace_ent.takedamage) {
        damage = 40;

		// Suck life like Heretic's necro gauntlets.
        if (self.tome_finished && trace_ent.flags & FLx_CREATURE) {
			save = ignore = 0;
			if (trace_ent.classtype == CT_MONWRAITH || trace_ent.classtype == CT_MONWRAITH || trace_ent.classtype == CT_MONWRAITH) {
                    save = 0.5;      // Assume life drain attack.
                    ignore = TRUE;          // Exceed normal health limit.
			} else save = 0.1;

            if (self.dmg > trace_ent.health)
                save = ceil(trace_ent.health * save);
            else
                save = ceil(self.dmg * save);

            if ((self.perms & POW_VAMPIRE) && (!(trace_ent.classgroup & CG_ZOMBIE))) save = save + ceil(1.2 * save);
			if (save > 0) T_Heal (self, save, ignore);
		}

        vec = ((random()*300) - 150) * v_right + (100 * v_forward);
        SpawnBlood (trace_ent, trace_endpos, '0 0 5', damage); // Blood!
        if (self.weaponframe & 1) SpawnMeatSpray(self,trace_ent,(crandom() * 300));
        pain = FeelsPain(trace_ent); // Damage!
        T_Damage(trace_ent, self, self, damage, DAMARMOR);
        if (trace_ent.flags & FL_MONSTER){
            trace_ent.velocity = trace_ent.velocity * 0.5;
			sound(self, CHAN_WEAPON, "zerstorer/weapons/sawguts.wav", 1, ATTN_NORM);
			if ((trace_ent.hittype == HIT_METAL || trace_ent.spawnflags & MON_OGRE_GREEN || trace_ent.spawnflags & MON_HOGRE_METAL) && (pain && (trace_ent.pain_finished > time))) sound (self, CHAN_AUTO, "drake/weapons/clang.wav", 1, ATTN_NORM);
			else if ((trace_ent.hittype == HIT_STONE) && (pain && (trace_ent.pain_finished > time))) sound (self, CHAN_AUTO, "drake/weapons/axhitwal.wav", 1, ATTN_NORM);

			self.punchangle_x = -8;
		} else if (trace_ent.classtype == CT_FUNCBREAK) { // Breakable impact sounds (def=stone/brick)
			if (trace_ent.style == BTYPE_WOOD) sound (self, CHAN_WEAPON, SOUND_AXE_WOOD, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_GLASS) sound (self, CHAN_WEAPON, SOUND_AXE_GLASS, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_METAL) sound (self, CHAN_WEAPON, SOUND_AXE_METAL, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_FLESH) sound (self, CHAN_WEAPON, SOUND_AXE_FLESH, 1, ATTN_NORM);
			else sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		}
    } else { // Hit wall.
		sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		Tent_Point(TE_GUNSHOT,org);
    }
};

// Homing Rockets.  Returns a linked list of targets, with the best at the head of list.  Uses .chain2 to link targtes.
entity(entity attacker, vector org, vector dir, float radius, float scope) SuperRocket_Target = { // [FUNCTION]
    local entity head, targ, link, old;
    local vector vec, end;
    local float dotproduct;

    targ = world;
    head = findradius(org, radius);
    while (head) {
		// Target must be a living creature without any stealth tech.
        if (head.health > 0)
        if (!head.invisible_finished)
        if (!(head.flags & FL_NOTARGET))
        if (head.flags & FLx_CREATURE)
        if (!(head.charmer == attacker)) {
			// Get the target whose direction matches aim vector the closest.
            end = Midpoint (head);
            vec = normalize (end - org);
            dotproduct = vec * dir;
            if (dotproduct > scope) {
                traceline (org, end, TRUE, head);
                if (trace_fraction == 1) {
					// Accept as a possible target and make a chain of targets.
                    head.chain2 = world;
                    head.frate2 = dotproduct;
                    if (targ) {
						// Sort the chain by dot product in descending order.
                        old = world;
                        link = targ;
                        while (link) {
                            if (dotproduct > link.frate2) {
								// This target is more desirable.
                                head.chain2 = link;
                                if (old) old.chain2 = head;
                                else targ = head;

                                link = world;   // End this sub-loop.
                            } else {
								// Next!
                                old = link;
                                link = link.chain2;
                                if (!link) old.chain2 = head;
                            }
                        }
                    } else targ = head;
                }
            }
        }
        head = head.chain;
    }
    return targ;
};

// Sidewinder Rockets - - - - - - - - -
// Used by players and mega enforcers.
// Some of the sidewinder code is also used by other monsters (SoE acolyte).

// Missile angles oscillate around ideal_yaw.
// Use when missile needs to sidewind along a straight line.
void() Sidewind_Ideal = { // [FUNCTION]
    local float diff, yaw;

    yaw = self.ideal_yaw;
    diff = anglemod(yaw - self.angles_y);
    if ((diff > 0) && (diff <= 180)) self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;

    ChangeYaw ();
    self.ideal_yaw = yaw;
};

// Missile changes pitch and yaw to face its target point.
// The missile must always turn toward ideal_yaw at full yaw_speed.
void(vector spot) Sidewind_Face = { // [FUNCTION]
    local vector ang;
    local float diff, up;

    if (self.lefty) { // Oscillate up and down slightly.
        up = (self.cnt & 7) * 45;
        up = SUB_cos(up) * 5;
        self.cnt = self.cnt + 1;
    } else up = 0;

    ang = normalize (spot - self.origin);
    ang = vectoangles (ang);
    self.angles_y = anglemod(self.angles_y);
    self.ideal_yaw = anglemod(ang_x + up); // Copy pitch into yaw to fool Quake into changing the pitch for us.
    diff = self.angles_y; // Remember this so we can restore yaw later.
    self.angles_y = self.angles_x;
    ChangeYaw(); // Change fake yaw using builtin.
    self.angles_x = self.angles_y;
    self.angles_y = diff;   // Restore yaw now that pitch has changed.
    diff = anglemod(ang_y - self.angles_y);
    if ((diff > 0) && (diff <= 180)) self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;

    self.ideal_yaw = anglemod(self.ideal_yaw);
    ChangeYaw(); // Change actual yaw using builtin.
};

// The next three functions are designed specifically for the mega enforcers' sidewinder missiles (which the player may use too). but are also used for the Necromancer boss's Necrosnake attack
void() Sidewinder_Think = { // [FUNCTION]
    local vector vec, dir;
    local float sped, d1, d2;

    if (self.delay < time) {
        if (self.classgroup == CG_PROJROCKETS) Touch_Missile(); // Out of gas.
        else remove(self); // For acolytes' venom shots.
        return;
    }

    if (self.enemy) sped = (!(self.enemy.items & IT_INVISIBILITY) && !(self.enemy.flags & FL_NOTARGET));
    else sped = FALSE;

    if (sped) {
        vec = Aimpoint (self.enemy);    // Was self.enemy.origin;
        Sidewind_Face (vec);
        if (!self.volume) { // Lose track if missile flies past its target.
            dir = normalize(self.velocity);
            d1 = normalize(self.enemy.origin - self.origin) * dir;
            if (d1 < 0) { // Target is behind the missile.
                if (self.master.flags & FL_MONSTER) {
                    d1 = vlen (vec - self.owner.origin); // Check if missile is further away than the target...
                    d2 = vlen (self.origin - self.owner.origin); // ...then assume the missile flew behind the target and drop the target.
                    if (d2 > (d1 + 50)) self.enemy = world; // Assumed to be behind target.
                }
            }
        }
    } else if ((self.master == self.owner) && (!self.oldenemy)) Sidewind_Face (self.pos2);      // No target to begin with.
    else Sidewind_Ideal ();

    sped = random() * 50 + 450;
    vec = self.angles;
    vec_x = 0 - vec_x;
    makevectors (vec);
    self.velocity = v_forward * sped;
    if (self.lefty & 1) {self.lefty = 2; self.nextthink = time + 0.1;}
    else self.nextthink = time + 0.2;
};

// Update 4/2/10:  Adapted for player use.  Mega enforcer still uses this.
void(vector start, vector dir, entity targ) Sidewinder_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
    newmis.yaw_speed    = 30;   // For sidewinding code.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.velocity     = dir * (450 + (random() * 50));
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 90;
    newmis.oldenemy     =
    newmis.enemy        = targ;
    newmis.ideal_yaw    = newmis.angles_y;
    newmis.cnt          = 0;
    newmis.lefty        = 1;
	newmis.classtype 	= CT_PROJ_SIDEWINDER;
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5)); // Get the spot we want to hit if fired straight without a target.
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2.5;       // Total duration
    newmis.nextthink    = time + 0.2;       // Was T+0.25
    newmis.think        = Sidewinder_Think;
    newmis.think1       = Old_Explosion1;
    setall(newmis,"progs/drake/memissil.mdl",VEC_ORIGIN,VEC_ORIGIN,start);
};

void() W_FireSidewinder = { // [FUNCTION]
    local vector start, dir;
    local entity targ;

    if (self.ammo_rockets < 1) return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "zerstorer/weapons/stunfire.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;
    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;
    targ = SuperRocket_Target (self, start, dir, 2000, COS30); // Select a target in front of the player's sights.
    Sidewinder_Launch (start, dir, targ);
};

//  Coven of Ebony Attacks
void() NecroSnake_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }
    if (Reflected()) return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage && (other.classname != self.master.classname)) {
        spawn_touchblood(self,other,self.dmg);
        T_Damage(other,self,self.master,self.dmg,DAMARMOR); // Update 6/11/2011:  Removed poison critical hits.
    } else Tent_Point(TE_WIZSPIKE,self.origin);
    remove (self);
};

// Launches a sidewinding poison shot.  Used by acolytes.
void(vector start, vector dir, float sped) NecroSnake_Launch = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup   = CG_PROJALL;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "wizspike";
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = 9;
    newmis.enemy        = self.enemy;
    newmis.speed        = sped;
    newmis.yaw_speed    = 10;
    newmis.ideal_yaw    = self.angles_y;
    newmis.pos2         = start + (dir * ((newmis.speed + newmis.height) * 5)); // Get the spot we want to hit if fired straight without a target.
    newmis.touch        = NecroSnake_Touch;     //spike_touch;
    newmis.delay        = time + 5;     // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = Sidewinder_Think;
    setall(newmis, "progs/w_spike.mdl", '0 0 0', '0 0 0', start);
};

//  Explosive Runes -- Used by Ebon Sorcerer.  Deposits an explosive rune where the necro is standing.
void(vector org) NecroBomb = { // [FUNCTION]
    newmis = spawn();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLY;
    newmis.solid        = SOLID_TRIGGER;
    newmis.classname    = "necrobomb";
    newmis.velocity     = '0 0 0';
    newmis.angles       = '0 0 0';
    newmis.angles_y     = random() * 360;   //self.angles_y;
    newmis.dmg          = 70;
    newmis.touch        = Touch_Missile;
    newmis.wait         = time + 0.2;
    newmis.nextthink    = time + 1;     //(1 + random()) * 0.5
    newmis.think        = Touch_Missile;
    setall(newmis,"progs/drake/nec_rune.mdl",VEC_HULL_MIN,VEC_HULL_MAX,org);
};

//  Necrobolt -- Used by Ebon Warlock and Dark Lord
// Update:  Instead of splitting into multiple mini-spikes, the bolt now
// redirects like shal-rath homing bombs, except update frequency is longer (slower).
// It resembles more like the Amazon's Guided Arrows from Diablo 2.
void() NecroBolt_Think = { // [FUNCTION]
    local vector vec;

    if (self.delay <= time) {
        if ((self.dmg <= 40) || (self.enemy.health <= 0)) { BecomeFancy(X32_STAR_RED + 3,2); return; } // The bolt dies.

        vec = Aimpoint(self.enemy);
        vec = normalize(vec - self.origin);
        self.dmg        = self.dmg - 10; // Each update weakens the bolt, so long distance attacks are less effective (lost magic).
        self.delay      = time + 1; // Much like Diablo2 Guided Arrow.
        self.velocity   = vec * self.speed;
        self.angles     = vectoangles(self.velocity);
        self.owner      = world;    // Let bolt hit the source now.
    }
    particle (self.origin, self.velocity * 0.005, 73, 2); // Draw particle trail.
    particle (self.origin, self.velocity * 0.01, 225, 4);
    self.nextthink = time + 0.1;
};

void() NecroBolt_Touch = { // [FUNCTION]
    local float damage;

    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return;

    self.touch = SUB_Null; // Stack overflow prevention.
    if (other.classname != self.master.classname) { // Warlocks are immune, and shamblers take full damage.
        damage = (self.dmg - 20) + (random() * 20); // PM:  Half strength would be 50+d10, but since older progs used 50+d20 and gives the shot more oomph, I'll leave damage alone.
        if (damage > 0) T_Damage (other, self, self.master, damage, DAMARMOR);
    }
    T_RadiusDamage (self, self.master, self.dmg, other, DAMAGEALL); // PM:  Don't use 120 radius damage because that is too much.  Also, even though effects look like lightning, it isn't -- it's magic!
    self.origin = self.origin - 8*normalize(self.velocity);
    sound(self, CHAN_AUTO, "rogue/plasma/explode.wav", 1, ATTN_NORM);
    Rocket_Explosion2(self.origin, 247, 5); // Create wicked red electric explosion.
    BecomeFancy (X56_PLASMA_RED, 6);
};

// Launches a crimson energy seeker bolt.  Used by warlocks.
void(vector start, vector dir) NecroBolt_Launch = { // [FUNCTION]
    newmis = spawn ();
	newmis.classgroup = CG_PROJROCKETS;
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "necrobolt";
    newmis.speed        = 600;
    newmis.velocity     = dir * 600;
    newmis.avelocity    = '0 0 1200';
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.yaw_speed    = 360;  // PM: Let dragons know this cannot be dodged.
    newmis.dmg          = 70;   // max(50+d20) = 70.
    newmis.enemy        = self.enemy;
    newmis.touch        = NecroBolt_Touch;
    newmis.delay        = time + 0.8;   // Total duration
    newmis.nextthink    = time + 0.1;
    newmis.think        = NecroBolt_Think;
    setall(newmis,"progs/drake/r_bolt.mdl",'0 0 0','0 0 0',start);
};

// ATTACK.  SoE:  Check added so hell lords don't summon meteors at inappropriate times.
float(vector p) M_MeteorCheck = { // [FUNCTION]
    local vector org, spot, vec;

    spot = self.enemy.origin;
    vec = spot - self.origin;
    if (vlen(vec) < 200) return FALSE; // Enemy too close to attacker.

    org = vectoangles (vec);
    makevectors (org);
    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
    if (vlen(spot - org) < 200) return FALSE; // Not enough time for target to react.

    traceline (self.origin, org, TRUE, self);
    if (trace_fraction < 1) return FALSE; // Spawn point blocked.
    return TRUE;
};

// SoE:  Split off from boss_missile so Hell Lord can use as well.
void(vector p, float sped) boss_meteor = { // [FUNCTION]
    local vector org, vec, d, avel;

    vec = vectoangles (self.enemy.origin - self.origin);
    makevectors (vec);
    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
	// SoE:  Monsters must have unbroken line to spawn point.  Do that to minimize chances of meteors appearing in the wall.
    if (self.flags & FL_MONSTER) { // If TRUE, self is probably a Hell Lord.
        traceline (self.origin, org, TRUE, self);
        if (trace_fraction < 1) {
            org = org - self.origin;
            sped = vlen(org) - 32;
            org = normalize(org);
            org = self.origin + org*sped;
        }
    }
		
    d = self.enemy.origin; // lead the player on hard mode
    if (skill >= 2) d = Aim_Lead (org, d, sped, self.enemy);
    vec = normalize (d - org);
	avel = vecrand(100,200,FALSE);
    Launch_Missile (org, vec, avel, CT_PROJ_LAVA, self.attack_speed); // Classic chthonic lavaball.
    sound (self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
};

// Mjolnir use for monsters!
void(vector spot) M_Slam = { // [FUNCTION]
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction < 1.0) {   // Slammed the ground, so fire off some lightning.
        Thor_Slam (10, 30);
        Quake_Spawn(self,800,10,trace_endpos,TRUE,2,VEC_QUAKE);
    }
};

//  MJOLNIR (Thor's hammer) Throwing Hammer
//  This part of the Mjolnir code is custom, added for SoE's modified
//  Mjolnir.  This lets the attacker throw the hammer.  The hammer will
//  select an enemy, fly toward it, then return back to the attacker.
//  In that respect, it is similar to the soulcube from Doom3.
//  If the hammer hits a target, the hammer will discharge like
//  the plasma balls from DoE.
void() Plasma_Fx = { // [FUNCTION]
    if (random() < 0.5) sound (self, CHAN_AUTO, "drake/weapons/zap1.wav", 1, ATTN_NORM);
    else sound (self, CHAN_AUTO, "drake/weapons/zap2.wav", 1, ATTN_NORM);

	self.effects = EF_MUZZLEFLASH;
	Particle_Explosion (self.origin, '6 9 2', '10 41 3');
    BecomeFancy (X32_PLASMA_BLUE, 6);
};

// Fires a cone of electric death that zaps everyone within 30 degrees of the aim vector infront of start point, up to a range defined by radius. Attacker is assumed to be self.
void(vector start, vector dir, float damage, float radius, float ang) DeathRay = { // [FUNCTION]
    local entity attacker, inflictor, head, ent;
    local vector end, vec;

    // Create dummy entity at spawn point so that 'CanDamage' works right.
    inflictor = spawn();
    setorigin (inflictor, start);
    attacker = self;
    head = findradius(start, radius);
    while (head) {
        if ((head.takedamage) && (head != attacker) && (head.health > 0) && (head.solid > SOLID_NOT)) { // So DarkPlaces won't gib the fallen.
            if (CanDamage(head,inflictor)) {
                end = Midpoint(head);
                vec = normalize(end - start);
                if (dir * vec > ang) {
                    end = end - 8*vec;
					ent = spawn();
					setorigin(ent,end);
					SUB_ThinkImmediate(ent,Plasma_Fx);
                    T_Damage(head,attacker,attacker,damage,DAMARMOR);
                }
            }
        }
        head = head.chain;
    }
    remove (inflictor);
};

// Think function for the delayed discharge.
void() Thor_Pulse = { // [FUNCTION]
	local vector pak;

    if (self.count < 1) {remove (self);  return;}

    self.nextthink = time + 0.2;
    self.count = self.count - 1;
    pak_x = self.style;
    pak_y = self.distance;
    pak_z = self.count;     //5;
    BurstLit_Chain(self, self.master, self.dmg*0.5, self.enemy, self.origin, pak, TRUE); // Was Plasma_Discharge from Drake light.qc
};

// Spawns a special discharge entity for Mjolnir impacts.
// Cannot use BecomeExplosion derivates because hammer remains after impact, so we need to create the explosion effects.
void() Thor_Discharge = { // [FUNCTION]
    newmis = spawn();
    if (self.master.tome_finished) newmis.count = 3;
    else newmis.count = 2;

    newmis.master   = self.master;  // The attacker.
    newmis.enemy    = self.enemy;   // Who to ignore.
    newmis.dmg      = self.dmg;
    newmis.distance = self.dmg + 220;   //320;
    newmis.style    = 1;    // Don't let discharge zap allies.
    newmis.classname= "Mjolnir";    // For obituary.
    newmis.movetype = MOVETYPE_NONE;
    newmis.velocity = '0 0 0';
    newmis.touch    = SUB_Null;
    newmis.solid    = SOLID_NOT;
    newmis.think    = Thor_Pulse;
    setall (newmis, "", '0 0 0', '0 0 0', self.origin);
    SUB_ThinkImmediate (newmis, Thor_Pulse);
    MakeFancy (self.origin, X56_PLASMA_BLUE, 6); // Spawn a second entity for the explosion sprite.
};

// Remove a thrown hammer.
// *** Always call this to remove a hammer! ***
void() Thor_Remove = { // [FUNCTION]
    local entity thor;

    thor = self.master;
    if (thor) {
        thor.hammer_finished = 0;
        if (thor.items2 & IT2_MJOLNIR) { // Confirm ownership of hammer.
            sound (thor, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
            if (thor.flags & FL_CLIENT) { // So far, only clients use ammo.
                if (self.ammo_cells) thor.ammo_cells = thor.ammo_cells + self.ammo_cells; // Recover all unused cells.

				// if (thor.war & WARx_USES_CELLS) SUB_ThinkImmediate (thor, War_UpdateCurrentAmmo);
				W_SetCurrentAmmo (thor);
				if (!thor.selfweaponismoditems && thor.weapon == IT2_MJOLNIR) { // Hammer selected, so restore weapon model and ammo.
					if (thor.attack_finished < time + 0.2) thor.attack_finished = time + 0.2; // Delay next attack a bit so player doesn't throw immediately.
					if (cutscene) thor = find (world, classname, "dummy"); // If TRUE, update dummy, not camera.
					thor.weaponmodel = MODEL_VWEAP_MJOL;
				}
            }
        }
    }
    remove (self);
};

// Removes hammer by teleporting back to master.  Any cells the hammer had are lost.
void() Thor_Poof = { // [FUNCTION]
    self.ammo_cells = 0;
    spawn_tfog (self.origin);
    Thor_Remove ();
};

// Called when a thrown hammer hits something.
void() Thor_Touch = { // [FUNCTION]
    local vector org;
    local float damage, dmg1, dmg2;
    local entity  swap;

    if (other == self.master) { Thor_Remove (); return; } // Returned to attacker, so simply catch the hammer.
    if (Reflected ()) return;

    if (self.owner == self.master) { // Bounce straight back.
        self.movedir = self.movedir * -1;
        self.velocity = self.movedir * THOR_SPEED;
    }

    self.enemy = self.owner = other;
    if (other && other.takedamage) { // Hammers do not draw blood like edged weapons, so no spawn_touchblood. After all, this is why clerics in AD&D can use only blunt weapons. Hammer in melee may draw blood, but not when thrown.
        damage = 50;
        if (other.classname == "monster_zombie") damage = other.health + 10;
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        T_Damage (other, self, self.master, damage, DAMARMOR);
        if (self.ammo_cells > 0) {
            damage = self.dmg * 0.7;
            damage = damage * 1.5;
            org = Midpoint (self.master);
            if (vlen(self.origin - org) > damage + 40) { // Discharge.
                self.ammo_cells = 0;
                dmg1 = (0.8 + random()*0.2) * self.dmg; // Combine two different sources of damage into one. dmg1 = Splash damage, dmg2 = Discharge.
                if (Ally_Check (other, self.master)) { // Unlike plasma, this explosion discharges not once, but twice.
                    dmg2 = 0;   // Discharge would not hit target.
                } else {
                    dmg2 = self.dmg;
                    dmg2 = dmg2 * 1.5;
                }

                // Send monsters flying.
                T_Damage (other, self, self.master, dmg1 + dmg2, DAMARMOR);
                if (!other.bossflag && (other.health > 0) && other != self.master) {
					damage_attacker = self.master;
					damage_velocity = VEC_ORIGIN;
					other.health = -99;
					Killed(other,self.master);
				}
                T_RadiusDamage (self, self.master, damage, other, DAMAGEALL);

				// Don't move sprite back because hammer is still there.
                sound (self, CHAN_AUTO, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
                Rocket_Explosion2 (self.origin, 244, 3);
                Thor_Discharge ();    // Spawn new, separate explosion entity.
                if (self.master.tome_finished) {
                    ShockWave (self.origin + '0 0 4', RING_BLUE, 6, "progs/drake/s_wave.spr",FALSE);
                    swap = self;
                    self = self.master;
					Quake_Spawn(self,800,10,self.origin,TRUE,2,VEC_QUAKE);
                    DeathRay(swap.origin,'0 0 0',100,1000,-2); // Use BFG9000-like trace attack instead of static field.
                    Divine_Wrath(4,2);
                    self = swap;
                } else ShockWave (self.origin + '0 0 4',RING_BLUE,4,"progs/drake/s_wave.spr",FALSE);
            }
        }
    } else {   // Hammer slammed a wall or something.
        if (pointcontents(self.origin) != CONTENT_SKY) {
            org = self.origin - 8*normalize(self.velocity);
            Tent_Point (TE_GUNSHOT, org);
            sound (self, CHAN_WEAPON, "hipnotic/weapons/mjoltink.wav", 1, ATTN_NORM);
        }

        if (self.count < 10) {
            self.count = self.count + 1;
        } else { // Stuck, so teleport back to the attacker's hand.
            Thor_Poof ();
            return;
        }
    }
};

// Controls hammer velocity.  Called by Thor_Think.  Cause thrown hammer to fly towards a given target.
void(entity targ) Thor_Fly = { // [FUNCTION]
    local vector ang;
    local float diff;

    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.avelocity_x = 0 - THOR_SPEED;
    ang = self.angles; // Temporarily set angles to the direction the missile is traveling.
    self.angles = vectoangles (self.movedir);
    diff = ang_x - self.angles_x;
    Missile_Seek (targ); // Update velocity and angles based on missile angles.
    self.angles_x = anglemod (self.angles_x + diff); // Restore pitch to what it should be now.
    if (self.angles_x >= 180) self.angles_x = self.angles_x - 360;
};

// Track the nearest target.
void() Thor_Think =[ 0, Thor_Think ] { // [FUNCTION]
    local entity targ;

    if (self.master.hammer_finished < time) { // Time's up, return to attacker now!
        Thor_Poof ();
        return;
    }

    if (self.owner == self.master) { // Outgoing for an attack.
        if (self.enemy) { // Return to attacker if target is gone. ToP:  If no juice, return after a short delay.
            if (((self.enemy.solid < SOLID_BBOX) && (self.enemy.takedamage != DAMAGE_AIM) || (self.enemy.health <= 0)) || (!self.enemy.modelindex) || ((!self.ammo_cells) && (self.delay <= time))) self.owner = world;
        } else {
            if (self.delay <= time) self.owner = world; // Return to attacker if hammer flew long enough.
        }
        targ = self.enemy;
    } else
        targ = self.master;     // Returning back to attacker.

    Thor_Fly(targ);
};

// This throws the mighty hammer.
void(vector start, vector dir, entity targ) Thor_Launch = { // [FUNCTION]
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "Mjolnir";    //"hammer";
    newmis.yaw_speed    = 40;
    newmis.speed        = THOR_SPEED;
    newmis.velocity     = dir * THOR_SPEED;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_x  = 0 - THOR_SPEED;
    newmis.movedir      = dir;
    newmis.dmg          = 100;
    newmis.ammo_cells   = COST_MJOLNIR;
    newmis.enemy        = targ;
    newmis.count        = 0;
    newmis.touch        = Thor_Touch;
    newmis.delay        = time + 1.5;   // 1,5 sec. gives about 900 range.
    newmis.nextthink    = time + 0.1;
    newmis.think        = Thor_Think;
	newmis.classgroup	= CG_WEAPON;
    setmodel (newmis, "progs/drake/throwham.mdl");
    setsize (newmis, '0 0 0', '0 0 0');        
    setorigin (newmis, start);

    if (self.flags & FL_CLIENT) { // Update attacker.
        if (self.ammo_cells >= COST_MJOLNIR) {   
            self.ammo_cells = self.ammo_cells - COST_MJOLNIR; // Throw hammer at full power.
        } else { // No juice!
            newmis.ammo_cells   = 0;
            if (self.tome_finished) newmis.delay = time + 1;
            else newmis.delay = time + 0.5;
        }
        self.weaponmodel = "";
    }
    self.hammer_finished= time + 10;    // Automatically returns later.
};

entity() W_ThorTarget = { // [FUNCTION]
    local   entity  head, targ;
    local   float   best, dist, dot;
    local   vector  org, spot, vec, vx;

    if (self.flags & FL_CLIENT) makevectors (self.v_angle);
    else makevectors (self.angles);
    vx = v_forward;
    org = self.origin + self.view_ofs;
    targ = world;
    best = 10000000;
    head = findradius (org, 2000); // Don't give hammer more range.
    while (head) {
        if ((head.modelindex) && (!(head.flags & FL_NOTARGET)) && (head.flags & FLx_CREATURE) && (head.health > 0) && (head.solid >= SOLID_BBOX) &&(!Ally_Check (head, self))) {
            spot = Midpoint (head);
            traceline (org, spot, TRUE, self);
            if (trace_fraction == 1) {
                vec = head.origin - org;
                dot = normalize (vec) * vx;
                if (dot > 0.7071) { // Must be within 90 fov.
					dist = vlen(vec) / dot;
					if (dist < best) {
						best = dist;
						targ = head;
					}
                }
            }
        }
        head = head.chain;
    }
    return targ;
};

// Checks if self has enough power to throw the hammer.
float() HasPowerToThrow = { // [FUNCTION]
    if (self.tome_finished) return TRUE;
    if (self.ammo_cells >= COST_MJOLNIR) return TRUE;
    return FALSE;
};

void() W_FireThor = { // [FUNCTION]
    local entity targ;

    if (frame_pause()) return; // There is a delay before firing, so don't throw if not an appropriate time.
    if (self.hammer_finished) return; // No hammer!
    if (!HasPowerToThrow ()) return; // No ammo or power!

    targ = W_ThorTarget ();      // This calls 'makevectors (self.v_angle)'.
    sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
    Thor_Launch(self.origin + '0 0 12', v_forward, targ); // We can throw.
};

// Added 12/23/2009:
// Used by hammer slam to repel missiles and crush fallen zombies.
void(entity inflictor, float damage) Hammer_Block = { // [FUNCTION]
    local   entity  head;
    local   vector  spot, org;
    local   float   points;

    spot = inflictor.origin;
    head = QC_FindRadius (spot, damage + 40);
    while (head) {
        if (head.owner != self)
        if (head.solid == SOLID_NOT) { // Hit zombies!
            if (head.takedamage && head.modelindex && (head.health > 0) && head.classgroup == CG_ZOMBIE && (head.classtype != CT_MONMUMMY || self.tome_finished) &&(head.bodyonflr == MON_ONFLR)) {
                org = Midpoint (head);
                points = 0.5 * vlen(spot - org);
                points = damage - points;
                if (points > 0)
                if (CanDamage (head, inflictor)) {
                    if (points < self.health) points = self.health; // Insta-kill.
					monster_flrbody_gib(head, points);
                }
            }
        } else {
            if (IsMissile (head)) {
                traceline (spot, head.origin, TRUE, self);
                if (trace_fraction == 1) Block_Missile (head, spot);
            }
        }
        head = head.chain;
    }
};

void(float lo, float hi) Thor_Slam = { // [FUNCTION]
    local entity base, lite;
    local float loop;
    local vector ang, spot; // PM: New.

    spot = trace_endpos;
	ang = vectoangles (trace_plane_normal);
    ang_x = anglemod (ang_x - 90);
    ang_y = self.angles_y;

	// spawn lightning base
    base = spawn();
    base.origin    = trace_endpos;
    base.flags     = 0;
    base.owner     = self;
    base.struck_by_mjolnir = 1;
    base.think     = SUB_Remove;
    base.nextthink = time + 1;
    sound (base, CHAN_AUTO, "hipnotic/weapons/mjolslap.wav", 1, ATTN_NORM);
    sound (base, CHAN_WEAPON, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
    if (self.flags & FL_CLIENT)
        makevectors (self.v_angle);
    else
        makevectors (self.angles);

    base.movedir = v_forward;
    loop = 4;
    while (loop > 0) { // spawn actual lightning
        lite = spawn();
        lite.delay     = time + 0.8;
        lite.state     = 0;
        lite.owner     = self;      // Was base.
        lite.distance  = 350;
        lite.v_angle   = ang;       // Was '0 0 0';
        lite.origin    = base.origin;
        lite.think     = HIP_LightningThink;
        lite.nextthink = time;
        lite.ryuflags  = RYU_ALERT; // PM:  Allow sight across contents.
        lite.waitmin   = lo;    //30; PM:  Damage set here.
        lite.waitmax   = hi;    //80;

		// Yes, I know it may be faster to define these once at the
		// lightning base than multiple times, once on each bolt.
		// However, I wanted to eliminate any reference to the
		// lightning base when the bolts think.  Now, the base is
		// just there as a sound source.
        lite.dest      = base.origin;
        lite.movedir   = base.movedir;
        loop = loop - 1;
    }

    ShockWave(base.origin + '0 0 4', RING_BLUE, 6, "progs/drake/s_wave.spr",FALSE);
    Hammer_Block(lite, 100); // Added on 12/23/09.
};

// PM:  Custom shockwave attack for enhanced Mjolnir.
void() HIP_FireMjolnirShockwave = { // [FUNCTION]
    local entity wave;
    local vector spot;
    local float damage, fr, wc;

    spot = trace_endpos;
    wave = spawn();
    setorigin (wave, spot);
    sound (wave, CHAN_AUTO, "hipnotic/weapons/mjolslap.wav", 1, ATTN_NORM);
    sound (wave, CHAN_WEAPON, "drake/weapons/nova.wav", 1, ATTN_NORM);
    wc = RING_BLUE;
    if (self.tome_finished) { 
        damage = 100; // More damage plus a tremor to shake things up.
		fr = 5;
		Quake_Spawn(self,150,3,spot,TRUE,0.5,VEC_QUAKE); // Update 9/10/10:  Reduced dist(200), damage(4) and time(1). Quake is for the player to feel powerful.
    } else {
		damage = 70;
		fr = 4;
	}
    ShockWave(spot + '0 0 4', wc, fr, "progs/drake/s_wave.spr",FALSE);
    T_RadiusDamage (wave, self, damage, self,DAMAGEALL);
    if (self.tome_finished) { // Spawn mini-slam effects with Tome of Power. Do after radius damage so dead things won't be targeted.
        if (pointcontents (spot) > CONTENT_WATER) BurstLit_Chain(wave,self,30,self,spot,'1 350 4',2); // No discharge for you!
        Divine_Wrath(1,1);
    }
    Hammer_Block(wave,damage); // PM: Added on 12/23/09. (Just in time for Christmas! -Qmaster)
    remove(wave);
};

void(entity who, vector spot) StaticFx = { // [FUNCTION]
    local float zap;

    zap = random() * 2; // For sounds.  Was 3.
    who.effects = who.effects | EF_MUZZLEFLASH;
    if (zap < 1) sound (who, CHAN_AUTO, "drake/weapons/zap1.wav", 1, ATTN_NORM);
    else sound (who, CHAN_AUTO, "drake/weapons/zap2.wav", 1, ATTN_NORM);

    MakeFancy (spot, X32_STAR_BLUE, 5);
};

// Reduce current health of enemies around the inflictor by 25%.  Assumes self to be the attacker and ignore entity.
void(entity inflictor, float radius) StaticField = { // [FUNCTION]
    local entity head;
    local vector p1, p2;

	// Damage flags:
	// Lightning - Static Field was a lightning skill in Diablo 2.
	// Percent   - Remove health by % instead of flat number, like in Diablo 2.
	// Note, no armor is a possibility -- could go either way.
    p1 = inflictor.origin;
    head = findradius(p1, radius);
    while (head) {
        if (head != self)
        if (head.takedamage)
        if (head.flags & FLx_CREATURE)  // Don't zap objects.
        if (head.health > 0)
        if (head.solid > SOLID_NOT)     // So DarkPlaces won't gib the fallen.
        if (!Ally_Check (head, self)) { // Zap only enemies.
            if (CanDamage (head, inflictor)) {
                p2 = Midpoint (head);
                p2 = p2 - 8*normalize(p2 - p1);
                StaticFx (head, p2);
                T_Damage(head, inflictor, self, 25, NOARMOR);
            }
        }
        head = head.chain;
    }
};

// Checks if the super slam is safe to use.
float() Thor_Safe = { // [FUNCTION]
    if (deathmatch) return TRUE;    // Allow for possible net frag gain.
    if (self.waterlevel <= 1) return TRUE; // Not in the water.
    if (self.cross_finished) return TRUE; // Immune to radius damage.
    if (self.radsuit_finished) return TRUE; // Inherited wetsuit powers...protected from lightning damage.
    return ImmuneToDamage (self);
};

// Slammed the ground, so fire off some lightning.
void() HIP_SlamMjolnir = { // [FUNCTION]
    local float hits;

    if (self.button0)
    if (self.ammo_cells >= COST_MJOLNIR)
    if (Thor_Safe ()) { // Super slam.  Update 11/30/09:  Don't discharge if deadly.
        if (self.tome_finished) hits = 6;
        else hits = 4;

		Quake_Spawn(self,800,10,trace_endpos,TRUE,2,VEC_QUAKE);
		HIP_FireMjolnirLightning ();
		Divine_Wrath (hits, 2);     // Do after Hip lightning.
		if (!lightzero_finished) sound (world, CHAN_AUTO, "drake/bane/thunder.wav", 1, ATTN_NONE);
        if (self.tome_finished) StaticField(self,400); // Soften 'em up before delayed smashing. Was 500.
		W_Reload(1.5);
    } else HIP_FireMjolnirShockwave (); // Mini-slam.
};

float() Hip_ThrewMjolnir = { // [FUNCTION]
	if ((world.hipnoticoptions & HIPNOTIC_OLDMJOLNIR) && !self.tome_finished) return FALSE; 
	if (self.button0 && HasPowerToThrow()) {W_FireThor();  return TRUE;} // Throw if player has the juice.
    return FALSE;
};

// PM:  Called on third frame of attack, before the slam on the fourth.
float() HIP_ThrowMjolnir = { // [FUNCTION]
    local vector org, source;
    local float damage, frac, stat;

    if (frame_pause()) return 0; // Not while viewing through a cam.
	if (!self.tome_finished) return FALSE;

    source = self.origin + '0 0 16';
    makevectors (self.v_angle);
    // PM:  Distance of 32 is obnoxiously short.  Use normal axe range if slam is not desired.
    if (self.button0 || (self.ammo_cells < COST_MJOLNIR)) {
		damage = 64;
		frac = 0.5;
	} else {
		damage = 32;
		frac = 1;
	}

    traceline (source, source + v_forward*damage, FALSE, self);
    org = trace_endpos - v_forward*4;
    if (trace_ent.takedamage) {
        stat = 0;
		damage = 50;
		if ((trace_ent.classgroup == CG_ZOMBIE) && trace_ent.classname != "monster_mummy") damage = trace_ent.max_health * 2;
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		SpawnBlood (trace_ent, org, '0 0 50', damage);
		T_Damage (trace_ent, self, self, damage, DAMARMOR); // As a blessed artifact of the gods, use scar damage.
		if (random() < 0.2) stat = 1; // Multiple procs are checked independently of each other, and may activate simultaneously.
		if (random() < 0.1) { // Thunderstorm proc.
			if (!Divine_Wrath (3, 1)) stat = stat + 1; // 3 shots, 1 sec of darkness.
		} else Divine_Wrath (1, 1);

		if (stat) {
			stat = stat + 1;
			stat = stat * 100 + 100;
			StaticField(trace_ent,stat);
		}
        return TRUE;
    } else if (trace_fraction != 1.0) { // Hit wall
        if (other.solid == SOLID_BSP && trace_plane_normal * '0 0 1' > COS45) { HIP_SlamMjolnir (); return TRUE; } // Check for premature hit on the ground.

        sound (self, CHAN_WEAPON, "hipnotic/weapons/mjoltink.wav", 1, ATTN_NORM);
        Tent_Point (TE_GUNSHOT, org);
        return TRUE;
    } else { // Whiff
		if (!(self.flags & FL_CLIENT)) { // Frikbot code!  Emulate a double-click, since required timing varies.
			if (random() < (skill * 0.1 + 0.7)) self.b0_click = 2; // Frikbot tries to throw hammer.  With lag, enforce a chance of failure.
		}
        self.attack_finished = self.attack_finished + 0.1;  // Update 12/11/09:  T+0.6+0.1=T+0.7.  Changed rate in impulse.qc.
        return Hip_ThrewMjolnir(); // Aww yeah!
    }
	return 0;
};

// Super Grenades from Drake
void() SuperGrenade_Think = { // [FUNCTION]
    if (self.delay <= time) {Explode_Grenade();  return;}

    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.05;
};

void() SuperRocket_Think = { // [FUNCTION]
	local float seen;

    if (self.delay <= time) {
		other = self.enemy;
        Touch_Missile();
        return;
    }

	spark_spawn();
	spark_spawn();
	spark_spawn();
    seen = Missile_Vis();
    self.yaw_speed = self.yaw_speed + self.cnt;     // See launch func below.
    self.velocity = normalize(self.velocity);
    if (!seen) {
        if (self.wait <= time) {
            self.wait = time + 0.5;
			// Use owner instead of master because missile passes owner.
			// FIXME:  Use master if owner is the world?
            self.enemy = SuperRocket_Target (self.master, self.origin, self.velocity, 1000, self.volume);
            if (self.enemy) seen = TRUE;
        }
    }
    if (seen) Missile_Seek_3D (self.enemy);
    self.speed = self.speed + self.height;
    if (self.speed > 1500) self.speed = 1500;
    self.velocity = normalize(self.velocity)*self.speed;
    self.nextthink = time + 0.1;
};

// Sample exploding function to use when calling 'xfx' in 'FireExpShots'
void() TraceExploShell_Think = { // [FUNCTION]
    T_RadiusDamage(self, self.owner, self.dmg, self.enemy, DAMAGEALL);
	R_ExpSmall(self.origin); //Replaced Rocket_Explosion2 (self.origin, 224, 16); with R_ExpSmall and Tent_Explosion2 in order to have more distinct and abrupt blast sound.
	Tent_Explosion2(self.origin, 224, 16);
    BecomeFancy(X32_PUFF_ORANGE, 5);
};

void(float damage, vector dir, float addedtime) TraceExploAttack = { // [FUNCTION]
    local vector org;
	local float ldmg;
    
    if (pointcontents(trace_endpos) == CONTENT_SKY) return;

    org = trace_endpos - dir*8;     // Yes, use 8 for sprite placement.
    if (trace_ent.takedamage) { // Adding explosive fuel to the fire...
        ldmg = SUB_RandomDamage (damage);
		AddMultiDamage (trace_ent, ldmg);
    }

    // Spawn an explosion entity to put on a linked list.
    newmis = spawn();
    newmis.owner     = self;
    newmis.enemy     = trace_ent;
    newmis.oldenemy  = shot_head;
    newmis.dmg       = damage;
    newmis.think    = TraceExploShell_Think;
	newmis.nextthink = time + 0.1 + addedtime;
    setmodel (newmis, "");
    setorigin (newmis, org);
    shot_head = newmis; // Don't use chain because findradius will overwrite that. Some engines, like DarkPlaces, pick up even SOLID_NOT.
};

// BURIZA-DO KYANON, Now called the Asgard Arbalest in Keep and Quake: Mjolnir.
// Buriza-Do Kyanon is an artifact crossbow based on the unique "ballista"
// from Diablo 2 Lord of Destruction.  The Buriza in Diablo 2 featured
// unusually high damage that was typed cold and physical, and shots that
// always pierced and froze most enemies on a hit.  Most enemies that died
// shattered into ice cubes.
// Here, the shots will always pierce, and they will one-hit kill most small
// targets struck.  This is also similar to the super shot powerup in
// the games Gauntlet 2 and Gauntlet Legends.
// Burizado kyanon is the transliteration from Japanese which translates to Blizzard Cannon.

// Generic slow timer.  Inflicted by Buriza.
void(entity targ, entity attacker, float dur) T_Slow = { // [FUNCTION]
    if (!targ) return;
    if (targ.invincible_finished) return;
    if (targ.cross_finished) return;

	if (targ.slow_finished < time) {
		targ.slow_finished = time + dur;
	} else { // Stacks up to 120 seconds (115 + 5)
		if ((targ.slow_finished - time) < 116) targ.slow_finished = targ.slow_finished + dur; 
	}
};

void() Shattered;

void() FrozenThink = { // [FUNCTION]
	if (self.health < self.cnt) {
		self.count = self.count + (self.cnt - self.health);
		if (self.health < self.gibhealth || self.health < 600) { sound (self, CHAN_ITEM, "drake/weapons/shatter.wav", 1, ATTN_NORM); Shattered(); return; }
		sound (self, CHAN_ITEM, "drake/weapons/icehit.wav", 1, ATTN_NORM);
	}
	self.cnt = self.health;
	self.think = FrozenThink;
	self.nextthink = time + 0.1;
};

void() Frozen_Touch = { // [FUNCTION]
	if (self.classtype == CT_MONSPAWN) dprint("Frozen spawn touched\n");

	if (other.health > 0 && other.flags & FLx_CREATURE) {
		if (self.pain_finished < time) {
			self.flags = self.flags - (self.flags & FL_ONGROUND);
			self.velocity_x = self.velocity_x + other.velocity_x*2;
			self.velocity_y = self.velocity_y + other.velocity_y*2;
			self.velocity_z = vlen(self.velocity) * 0.5;
			self.avelocity = crandom() * '0 600 0';
			sound(self, CHAN_VOICE,"drake/weapons/icewall.wav", 1, self.volume); // Has any impact sounds been defined?
			self.pain_finished = time + 2 + random() * 2; // 2 to 4 seconds
		}
	}
};

void(entity targ, entity attacker) T_Freeze = { // [FUNCTION]
	if (!(targ.flags & FLx_CREATURE)) return;

	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	self.deadflag = DEAD_DEAD; 
	sound (targ, CHAN_ITEM, "drake/weapons/freeze.wav", 1, ATTN_NORM);
	Particle_Cube (self, 1, 41);
	take_monster_object(targ); // drop our stuff
	if (targ.attachment) entity_remove(targ.attachment, 0.1);
	if (targ.attachment2) entity_remove(targ.attachment2, 0.1);
	if (targ.attachment3) entity_remove(targ.attachment3, 0.1);
	targ.velocity = targ.avelocity = '0 0 0';
	targ.movetype = MOVETYPE_TOSS;
	targ.colormod = '1 1 2'; // Pale blue white
	targ.alpha = 0.6; // Transparent ice
	targ.effects = 0;
	targ.solid = SOLID_SLIDEBOX;
	targ.takedamage = DAMAGE_AIM;
	targ.think = FrozenThink;
	targ.nextthink = time + 0.1;
	targ.count = 0;
	targ.health = 0;
	if (targ.gibhealth >= 0) targ.gibhealth = -60;
	targ.touch = Frozen_Touch;
	targ.enemy = attacker; // remember for later if needed
	Gyro_Object_Activate(targ,MASS_GIB); // Light weight and floats, ice floats
	Gyro_Object_SetBouyancy(targ,BOUY_GIB);
	Gyro_Object_SetResistance(targ,RESIST_GIB);
	if (targ.targetname) targ.use = BecomeIcyExp;
	if (pointcontents(targ.origin) == CONTENT_LAVA) BecomeIcyExp(); // Can't freeze that which under lava lies; so burst away!
};

// Called when an arrow hits something.
void() Buriza_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected()) return;

    if (other) {
        self.owner = other; // So arrow may pass through target.
        if (other == self.fallen) return; // Do not hit this target.
        if (other == self.oldenemy) return; // Do not retouch the same target twice in a row.

		T_Damage (other, self, self.master, 100, DAMARMOR); // Hit for 100 damage like in Heretic (ToP firemace vs. bosses).
		T_Slow (other, self.master, 5); // Knock off some hp, and slow for 5 seconds.
		particle (self.origin, crandom() * 100 * '1 1 1', 41 + rint(random()*7), 20);
		particle (self.origin, crandom() * 100 * '1 1 1', 9 + rint(random()*7), 20);
        if (other.solid != SOLID_BSP) {self.oldenemy = other;  return;}   // Pierce the target.

        self.owner = world; // Arrow will shatter, so set owner to the world so that targets hiding behind 'other' aren't hit by T_RadiusDamage.
    }

	// Explode on impact on a solid surface.
    self.touch = SUB_Null; // Stack overflow prevention.
    T_RadiusDamage (self, self.master, 60, world, DAMAGEALL);
    self.origin = self.origin - 8*normalize(self.velocity);
    sound (self, CHAN_AUTO, "drake/weapons/icewall.wav", 1, ATTN_NORM); // Don't spawn shockwaves like the dragons' iceballs.
    Particle_Explosion (self.origin, '9 33 4', '15 41 3'); // Formerly 'Tent_Explosion2 (self.origin, 32, 16);'.
    BecomeIcyExp();
};

void() Buriza_Think = { // [FUNCTION]
    if (self.delay <= time) {remove (self); return;}

    self.nextthink = time + 0.05;
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = self.dest;
    self.movedir = normalize (self.dest);
    self.angles  = vectoangles(self.movedir);
    Meteor_Trail (41, 1, FALSE);
};

void(vector start, vector dir) Buriza_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master       = newmis.owner        = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "Buriza";
    newmis.movedir      = dir;
    newmis.speed        = SPEED_BURIZA;
    newmis.dest         = newmis.velocity     = dir * newmis.speed;
    newmis.avelocity    = '0 0 0';
    newmis.avelocity_z  = newmis.speed;     // Makes arrow model spiral.
    newmis.angles       = vectoangles(newmis.velocity);
	newmis.classtype	= CT_FROSTSHARD; // To allow for freezing effect to work
	newmis.classgroup	= CG_PROJICE; // To allow for resist_cold to work
    newmis.cnt          = 41; // Blue particle color index
    newmis.oldorigin    = start;
    newmis.frame        = 1;
    newmis.skin         = ARROW_ICE;
    newmis.oldenemy     = newmis.enemy = world;
    newmis.fallen       = self;     // Second owner, used by reflection.
    newmis.touch        = Buriza_Touch;
    newmis.delay        = time + 10;    // Give it long range.
    newmis.nextthink    = 0.01;
    newmis.think        = Buriza_Think;
    setall (newmis, "progs/drake/arrow.mdl", '0 0 0', '0 0 0', start);
};

void(float ox) W_EchoSpike = { // [FUNCTION]
    local vector org, dir;
    local float cost;

    cost = 1;
    if (self.perms & POW_DOUBLE) {
        if (self.weapon == IT_NAILGUN) cost = 0;
        else if (!self.tome_finished || (ox < 0)) cost = 0; // Assume super nailgun.
    }
    if (self.ammo_nails < cost) return;

    makevectors (self.v_angle);
    if (self.weapon == IT_NAILGUN)
        sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    else    // Assume super nailgun.
        sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - cost;
    if (self.tome_finished) { // Tome of Power SPIKES which are hitscan
        if (self.weapon == IT_NAILGUN) {
            org = self.origin + '0 0 16' + v_right*(ox*3);
        } else {
            org = self.origin + '0 0 16' + v_right*(ox*2);
        }
        dir = aim (self, 100000);
        Piercer_Trace (org, org + dir*SPIKEY_RANGE, self, SPIKEY_DAMAGE, self, TE_GUNSHOT);
        StackDamage_Clear();
    } else {
        dir = aim (self, 1000);
        if (self.weapon == IT_NAILGUN) {
			ox = ox * 1.5;
			launch_projectile (self.origin + '0 0 16' + v_right*ox, dir, CT_PROJ_NG, SPEED_PLAYSPIKE);
        } else launch_projectile (self.origin + '0 0 16' + v_up*ox, dir, CT_PROJ_SNG, SPEED_PLAYSPIKE); // '8 10 12+ox'
        if (self.weapon == IT_SUPER_NAILGUN) newmis.classname = "spike2";    // For obituary.
    }
};
void() W_EchoSpike_Up = {W_EchoSpike(2);}; // [FUNCTION]
void() W_EchoSpike_Down = {W_EchoSpike(-2);}; // [FUNCTION]

void(float ox) W_EchoLavaSpike = { // [FUNCTION]
    local vector org, dir;
    local float cost;

    cost = 1;
    if (self.perms & POW_DOUBLE) {
        if (self.weapon == IT_LAVA_NAILGUN) cost = 0;
        else {   
            if (!self.tome_finished || (ox < 0)) cost = 0; // Assume super nailgun.
        }
    }
    if (self.ammo_nails < cost) return;

    makevectors (self.v_angle);
    if (self.weapon == IT_LAVA_NAILGUN) sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    else sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM); // Assume super nailgun.

    self.attack_finished = time + 0.2;
    self.currentammo = self.ammo_nails = self.ammo_nails - cost;
    if (self.tome_finished) {
        if (self.weapon == IT_LAVA_NAILGUN) org = self.origin + '0 0 16' + v_right*(ox*3);
        else org = self.origin + '0 0 16' + v_right*(ox*2);

        dir = aim (self, 100000);
        Piercer_Trace (org, org + dir*SPIKEY_RANGE, self, DAMAGE_LAVANGSPIKE, self, TE_GUNSHOT);
        StackDamage_Clear();
    } else {
        dir = aim (self, 1000);
        if (self.weapon == IT_LAVA_NAILGUN) {
			ox = ox * 1.5;
			launch_projectile (self.origin + '0 0 16' + v_right*ox, dir, CT_PROJ_LAVANG, SPEED_PLAYSPIKE);
        } else launch_projectile (self.origin + '0 0 16' + v_up*ox, dir, CT_PROJ_LAVASNG, SPEED_PLAYSPIKE); // '8 10 12+ox'
        if (self.weapon == IT_LAVA_SUPER_NAILGUN) newmis.classname = "spike2";    // For obituary.
    }
};
void() W_EchoLavaSpike_Up = {W_EchoLavaSpike(2);}; // [FUNCTION]
void() W_EchoLavaSpike_Down = {W_EchoLavaSpike(-2);}; // [FUNCTION]

// Loop through all entities and damage everyone who has damage stacked
// against them (from the piercing shotgun effect).  Not as fast as
// MultiDamage*, but necessary when piercing shots are involved.
// Assumes inflictor and attacker are both self.
void() StackDamage_Clear = { // [FUNCTION]
    local   entity  head;
    head = nextent (world);
    while (head) {
        if (head.dmg_stack) {
			if (self.weapon == IT_LAVA_SUPER_NAILGUN || self.weapon == IT_LAVA_NAILGUN) {
				if (head.resist_fire > 0) head.dmg_stack = head.dmg_stack * (1 - head.resist_fire);
				else Burn_Add(head,self,head.dmg_stack); // Lavanails have a chance to set targets on fire!
			}
            T_Damage(head,self,self,head.dmg_stack,NOARMOR); // Armor piercing!
            head.dmg_stack = 0;
        }
        head = nextent (head);
    }
};

// Shoots a piercing hitscan bullet.
void(vector p1, vector p2, entity attacker, float damage, entity inflictor, float fx) Piercer_Trace = { // [FUNCTION]
    local entity ruler, ignore, targ, newent, stemp;
    local vector start, dir;
    local float dist, delta, hits;

    hits = 3;
    ruler = inflictor;
    dir = p2 - p1;
    delta = vlen(dir);  // Get total length in case of reflection.
    dir = normalize(dir);
    while (ruler) {
        ignore = inflictor = ruler;
        ruler = world;      // End loop unless set otherwise by reflection.
        start = p1;
        do {
            traceline (p1, p2, FALSE, ignore);
            p1 = trace_endpos;
            targ = trace_ent;
            if ((targ.solid != SOLID_BSP) && targ.takedamage) ignore = targ;
            else ignore = world;

            if (targ != inflictor) { // Dirty hack to prevent suicide.
                if (HasReflection (targ, p1, damage)) {
                    if (hits > 0) {
                        hits = hits - 1;
                        ruler = targ;
                        delta = delta - vlen(p1 - start);   // Get remaining dist.
                        dir = normalize(p1 - targ.origin);
                        p2 = p1 + dir*delta;
                    }
                    else trace_fraction = 1;     // We give up.
                    ignore = world;     // Stop the trace.
                    ReflectSound (targ);
                } else if (targ.takedamage) {
					// Note:  Because we may call the function we are in multiple times for a shotgun-like attack, don't apply damage now.  Just put the damage number in a stack, then apply it when we are ready.
					SpawnBlood(targ,trace_endpos,dir * damage,damage);
                    targ.dmg_stack = targ.dmg_stack + damage;
                }
            }
    
			// If current trace hits inflictor/attacker, next trace will miss all.
			// Move the new start point ahead slightly to prevent attacker from
			// hitting himself and preventing the bolt from piercing anymore.
			// (Note:  If attacker is inside the monster because of noclip,
			// he can still hit himself.)
            if (ignore) { // Always world if 'p2 == trace_endpos'.
                dist = vlen(p2 - p1);
                if (dist > 1) p1 = p1 + dir;
                else ignore = world; // Not enough distance left, so just stop.
            }
        }
        while(ignore);
    }

    if (trace_fraction < 1 && pointcontents(p1) != CONTENT_SKY) Tent_Point(fx, p1);    // fx should be TE_SPIKE or TE_SUPERSPIKE.

	if (attacker.weapon == IT_LAVA_SUPER_NAILGUN || attacker.weapon == IT_LAVA_NAILGUN) {
		newent = spawn();
		setorigin(newent,p1);
		stemp = self;
		self = newent;
		Ember_Shower (2);
		self.think      = SUB_Remove;
		self.nextthink  = time + 0.1;
		self = stemp;
	}
};

// In 35 fps Doom, delays in the loop were 4/4/1.  The third frame was the same as first, but not fullbright, and did a vis check.
void() M_ChaingunNextthink = { // [FUNCTION]
    self.b0_click = !self.b0_click;     // Use client-only field for this.
    if (self.b0_click) self.nextthink = time + 0.11428; // Was Doom_NextThink which does (time + fr/35) which in this case was 4/35
    else self.nextthink = time + 0.14286; // 5/35. Assumed 35 frames per second for Doom or Heretic game emulation.
};

void(vector org, vector dir, entity targ, vector err) M_FireChaingun = { // [FUNCTION]
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "drake/weapons/dsshotgn.wav", 1, ATTN_NORM);
    dir = Maim_Line (org, dir, 0, targ, err);
	FireBullets(1, '0.14 0.08 0'); // Chaingunners were lousy shots in Doom2, so use a wide spread.  Normal SSG spread should do nicely.  Also, Doom's damage is 1d3*5.  Yaw scatter should be crandom * 3.125.
    M_ChaingunNextthink(); // Slow down thinking to give a rate-of-fire of Doom's chaingun zombie.
    M_Reload(0.2);
};