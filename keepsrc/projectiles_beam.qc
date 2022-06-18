//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, though primarily Arcane Dimensions (AD)
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
// Function count: 
//
// Implements: Lightning System and Beam Attacks
//
// Description:
// Generic functions for firing and spawning lightning.
//=============================================================================

void(vector lstart, entity lsource, float ldamage) LightningReflection;
void(vector org, vector dir, float proj_type, float proj_speed) launch_projectile;
void(float lo, float hi) Thor_Slam;
void(vector pos, vector dir, float rubicon) make_spark;
void() lightning_orb_think;
void() Plasma_Fx;
void() Thor_Discharge;

void(vector p1, vector p2, entity from, float damage) LightningDamage = { // [FUNCTION]
	local entity e1, e2;
	local vector f;
	local float lighthit, temp_classgroup;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;
	temp_classgroup = from.classgroup; // Need to fool T_Damage that damage is coming from LG
	if (from) from.classgroup = CG_PROJCELLS;
	e1 = e2 = world;
	lighthit = FALSE;
	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage) {
		lighthit = TRUE;
		if ((self.flags & FL_CLIENT) && (other.flags & FL_CLIENT)) trace_ent.velocity_z = trace_ent.velocity_z + 400; // Some weird MP velocity hack! KEEP IT!!
	} else {
		e1 = trace_ent;
		traceline (p1 + f, p2 + f, FALSE, self);
		if (trace_ent != e1 && trace_ent.takedamage) lighthit = TRUE;
		else {
			e2 = trace_ent;
			traceline (p1 - f, p2 - f, FALSE, self);
			if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage) lighthit = TRUE;
		}
	}

	// Found a target to hit?
	if (lighthit) {
		// Check for breakable/pushable monster immunity
		if (ai_immunebreakable(self, trace_ent)) {
			if (self.lightning_timer < time) { // This is resist lightning function without pain sound.  Don't spawn smoke constantly (let the sprite finish)
				self.lightning_timer = time + 0.3;
				SpawnExplosion(EXPLODE_BURST_SMOKE, trace_endpos, "");
			}
			SpawnProjectileSmoke(trace_endpos, 200, 50, 150);
		} else if (trace_ent.resist_cells > 0) { // Check for any cell/lightning resistance
			Resist_Effects(trace_ent,trace_endpos,VEC_ORIGIN,0,AM_CELLS,trace_ent.pain_sound,""); // damage = damage * trace_ent.resist_cells;
			if (damage > 0) T_Damage (trace_ent, from, from, damage, DAMARMOR);
		} else {
			SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*4,225);
			T_Damage (trace_ent, from, from, damage, DAMARMOR);
		}
		if (trace_ent.reflectlightning) LightningReflection(trace_endpos, trace_ent, damage*0.5); // Check for any lightning reflection abilitites.  Source = Lightning originally came from player
	}
	if (from) from.classgroup = temp_classgroup;
};

// New ability to spawn lighting strikes in random directions
void(vector lstart, entity lsource, float ldamage) LightningReflection = { // [FUNCTION]
	local vector lfinish, dir;

	lfinish = lstart + vecrand(0,1000,1); // Setup a random XYZ direction (+/-)
	traceline(lstart, lfinish, FALSE, lsource); // Trace line in random direction
	if (random() < 0.5) { // Random chance of a plasma/lightning bolt!
		dir = normalize(trace_endpos - lstart);
		launch_projectile(lstart, dir, CT_REFLECTLIGHT, SPEED_REFLECTION);
	} else {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); // Draw lighting beam (32 model unit chunks)
		WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity (MSG_BROADCAST, lsource);
		WriteCoord (MSG_BROADCAST, lstart_x);
		WriteCoord (MSG_BROADCAST, lstart_y);
		WriteCoord (MSG_BROADCAST, lstart_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
		LightningDamage(lstart, trace_endpos, world, ldamage); // Check for damage with new lightning beam
	}
};

// This lightning damage check is designed for the lightning gun with many modifiers designed for the player and MP combat.
// This function should not be used for general lightning damage
void(vector p1, vector p2, entity from, float damage) PlayerLightningDamage = { // [FUNCTION]
	local entity e1, e2;
	local vector f, dir;
	local float lighthit, temp_classgroup, iter, dmg;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;
	dmg = damage;
	e1 = e2 = world;
	lighthit = FALSE;
	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage) {
		lighthit = TRUE;
		// Some weird MP velocity hack!
		// The story about this code (from quakeworld.nu)
		//
		// This code appears to have been there for a long, long time.
		// It was there in Quake 1.06 Shareware release, and it may have
		// been there before that. Someone must have been experimenting
		// with something and forgot it there, but no one noticed because
		// in that function, the 'other' entity is not usually set to
		// anything in particular, and the code never worked.
		//
		// But then QW came along, and in the QW engine it turns out
		// that 'other' will be set to 'self' if the player is touching
		// a platform. And so the dormant code stared working! It was
		// discovered by players, and players started using it to their
		// advantage. Now it's an integral part of dm6 gameplay.
		//
		// The code was apparently discovered and removed when Quake QC 
		// code was cleaned up before being released to public, so you
		// won't normally see it in NQ mods. But it is there in the
		// progs.dat in pak0.pak; and it will work in QuakeWorld engines
		// supporting progs.dat (currently FTE and ZQuake).
		if ((self.flags & FL_CLIENT) && (other.flags & FL_CLIENT)) trace_ent.velocity_z = trace_ent.velocity_z + 400;
	} else {
		e1 = trace_ent;
		traceline (p1 + f, p2 + f, FALSE, self);
		if (trace_ent != e1 && trace_ent.takedamage) lighthit = TRUE;
		else {
			e2 = trace_ent;
			traceline (p1 - f, p2 - f, FALSE, self);
			if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage) lighthit = TRUE;
		}
	}

	// Found a target to hit?
	if (lighthit) {
		if (self.tome_finished && trace_ent) {
			// Make some extra tome of power spark effects
			iter = 0;
			while (iter < 6) {
				dir = safe_client_forward();
				make_spark(trace_ent.origin, dir, FALSE); // False to use direction.
				newmis.velocity_z = 200 + crandom() * 300;
				newmis.velocity_y = crandom() * 300;
				newmis.velocity_x = crandom() * 300;
				newmis.solid = SOLID_NOT;
				newmis.touch = SUB_Null;
				newmis.skin = 8;
				iter = iter + 1;
			}
			dmg = dmg * 2; // Double damage
			if (trace_ent.health < dmg) { // Monster go pop!
				iter = 0;
				sound (self, CHAN_AUTO, "rrp/misc/spark.wav", 1, ATTN_STATIC);
				while (iter < 30) {
					dir = safe_client_forward();
					make_spark(trace_ent.origin, dir, FALSE); // False to use direction.
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
		}

		// Check for any cell/lightning resistance
		if (trace_ent.resist_cells > 0) {
			Resist_Effects(trace_ent,trace_endpos,VEC_ORIGIN,0,AM_CELLS,trace_ent.pain_sound,"");
			if (dmg > 0) {
				// Need to fool T_Damage that damage is coming from LG
				temp_classgroup = from.classgroup;
				from.classgroup = CG_PROJCELLS;
				T_Damage (trace_ent, from, from, dmg, DAMARMOR);
				from.classgroup = temp_classgroup;
			}
		} else {
			SpawnBlood(trace_ent, trace_endpos, '0 0 100', dmg*4,225);
			T_Damage (trace_ent, from, from, dmg, DAMARMOR);
		}

		// Check for any lightning reflection abilitites
		if (trace_ent.reflectlightning) {
			dmg = dmg * 0.5; // Lightning splits when reflected...I guess.
			LightningReflection(trace_endpos, trace_ent, dmg); // Source = Lightning originally came from player
		}
	} else {
		if (self.tome_finished) {
			// Make some extra tome of power spark effects
			iter = 0;
			while (iter < 6) {
				dir = safe_client_forward();	
				make_spark(trace_endpos, dir * 300, FALSE); // False to use direction.
				newmis.velocity_z = crandom() * 300;
				newmis.velocity_y = crandom() * 300;
				newmis.velocity_x = crandom() * 300;
				newmis.solid = SOLID_NOT;
				newmis.touch = SUB_Null;
				newmis.skin = 8;
				iter = iter + 1;
			}
		}
	}
};

void (entity prev, entity own, float dst) HIP_SpawnMjolnirLightning = { // [FUNCTION]
   local entity light;

   light = spawn ();
   light.delay = (time + 0.800);
   light.state = FALSE;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = FALSE;
   light.v_angle_z = FALSE;
   light.origin = own.origin;
   light.nextthink = time;
};

void () HIP_SpawnMjolnirBase = { // [FUNCTION]
	local entity light, stemp;

	if (self.tome_finished) { Thor_Slam(30,80); return;}

	light = spawn ();
	light.origin = trace_endpos;
	light.flags = FALSE;
	light.owner = light.master = self;
	light.struck_by_mjolnir = TRUE;
	light.think = SUB_Remove;
	light.nextthink = (time + TRUE);
	sound (light,CHAN_AUTO,"hipnotic/weapons/mjolslap.wav",TRUE,ATTN_NORM);
	sound (light,CHAN_WEAPON,"hipnotic/weapons/mjolhit.wav",TRUE,ATTN_NORM);
	makevectors (self.v_angle);
	light.movedir = v_forward;
	light.dmg = 100;
	light.ammo_cells = COST_MJOLNIR;
	light.count = 4;
	light.yaw_speed = 40;
	light.speed = THOR_SPEED;
	stemp = self;
	self = light;
	Thor_Discharge();
	Thor_Discharge();
	Thor_Discharge();
	Thor_Discharge();
	self = stemp;
	ShockWave(trace_endpos + '0 0 4',RING_BLUE,6,"progs/drake/s_wave.spr",FALSE);
};

void () HIP_FireMjolnirLightning = { // [FUNCTION]
   local float cells;

   if (self.waterlevel > 1) {
      cells = self.ammo_cells;
      self.ammo_cells = FALSE;
      discharged = TRUE;
      T_RadiusDamage(self,self,(35.000 * cells),world, DAMAGEALL);
      discharged = FALSE;
      W_SetCurrentAmmo(self);
      return;
   }
	self.struck_by_mjolnir = TRUE;
   HIP_SpawnMjolnirBase();
};

void (entity current, float life) SpawnLightningTrace = { // [FUNCTION]
	float dmg;
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST,current);
	WriteCoord (MSG_BROADCAST,current.origin_x);
	WriteCoord (MSG_BROADCAST,current.origin_y);
	WriteCoord (MSG_BROADCAST,current.origin_z);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);
	sound (self,CHAN_VOICE,"weapons/lhit.wav",TRUE,ATTN_NORM);
	if (current.classgroup == CG_ZOMBIE) dmg = current.max_health; // poor zombies die in so many ways
	else dmg = 30;

	LightningDamage(self.origin,current.origin,self,dmg);
};

void (vector startpos, float radius, float life) SpawnOrbLightning = { // [FUNCTION]
	local entity head;
	local vector org;

	head = findradius(startpos,radius); // find EVERYTHING within 250 unit radius
	while (head) {
		// Can be damaged and NOT immune to radius (splash) damage
		if ((head.takedamage > 0) && (head.flags & FLx_CREATURE)) {
			org = head.origin + (head.mins + head.maxs)*0.5;
			if (head.health > 0) SpawnLightningTrace(head,life); // create initial lightning for any monsters found
		}
		head = head.chain;
	}
};

// Initially written by Qmaster and tested in the Keep mod.  aDaya's lighting 
// orb, used as tome of power attack when using old hipnotic mjolnir.
void () SpawnLightningOrb = { // [FUNCTION]
	local entity light;

	light = spawn ();
	light.origin = trace_endpos;
	light.origin_z = light.origin_z + 32; //move it up a tad from the hit point
	light.flags = FALSE;
	light.owner = self;
	light.struck_by_mjolnir = TRUE;
	light.model = "progs/s_light4.spr";
	setmodel(light,light.model);
	setsize(light,VEC_ORIGIN,VEC_ORIGIN);
	light.solid = SOLID_NOT;
	light.think = lightning_orb_think;
	light.attack_finished = time + 1.9;
	light.nextthink = (time + 0.5);
	sound(light,CHAN_AUTO,"zerstorer/ambience/thunder2.wav",TRUE,ATTN_NORM);
};

void (vector p1, vector p2, entity from, float damage) PlasmaDamage = { // [FUNCTION]
   local entity e1;
   local entity e2;
   local vector f;

   f = (p2 - p1);
   normalize (f);
   f_x = (FALSE - f_y);
   f_y = f_x;
   f_z = FALSE;
   f = (f * FL_INWATER);
   e2 = world;
   e1 = world;
   traceline (p1,p2,FALSE,self);
   if ( trace_ent.takedamage ) {
      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * 4));
      T_Damage (trace_ent,from,from.owner,damage,DAMARMOR);
      if ( (self.classname == "player") ) {
         if ( (other.classname == "player") )
            trace_ent.velocity_z = (trace_ent.velocity_z + 400);
      }
   }
   e1 = trace_ent;
   traceline ((p1 + f),(p2 + f),FALSE,self);
   if ( ((trace_ent != e1) && trace_ent.takedamage) ) {
      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * 4));
      T_Damage (trace_ent,from,from.owner,damage,DAMARMOR);
   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ( (((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) ) {
      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * 4));
      T_Damage (trace_ent,from,from.owner,damage,DAMARMOR);
   }
};

void (entity current) PlasmaDischarge = { // [FUNCTION]
	float dmg;

	if (!current) return;

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST,current);
	WriteCoord (MSG_BROADCAST,current.origin_x);
	WriteCoord (MSG_BROADCAST,current.origin_y);
	WriteCoord (MSG_BROADCAST,current.origin_z);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);
	sound (self,CHAN_VOICE,"weapons/lhit.wav",TRUE,ATTN_NORM);
	if (self.owner.classtype == CT_MONGREMLIN) {
		dmg = 20;
	} else {
		dmg = 50;
	}
	PlasmaDamage(self.origin,current.origin,self,dmg);
};

void () PlasmaGroundOut = { // [FUNCTION]
   local entity current;
   local entity start;
   local float monstersHit;

   monstersHit = FALSE;
   current = findradius (self.origin,320.000);
   start = current;
   while ( (monstersHit < 5) ) {
      if ( ((current.flags & FL_MONSTER) || (current.classname == "player")) ) {
         if ( (current != self.owner) ) {
			if (Align_Opposing(self.owner,current)) {
            	traceline(self.origin,current.origin,TRUE,world);
				if (trace_fraction == 1.0) {
					monstersHit = monstersHit + 1;
					PlasmaDischarge(current);
				}
			}
         }
      }
      current = current.chain;
      if (start == current || !current) return;
   }
};

//###########################################
//#### PHASED PLASMA CANNON (BEAM WEAPON) ###
//###########################################
// Been toned down so that it doesn't require as much stuff as the original did.

void()	beamhit1	=	[0,		beamhit2] {}; // [FUNCTION]
void()	beamhit2	=	[1,		beamhit3] {}; // [FUNCTION]
void()	beamhit3	=	[2,		beamhit4] {}; // [FUNCTION]
void()	beamhit4	=	[3,		beamhit5] {}; // [FUNCTION]
void()	beamhit5	=	[4,		SUB_Remove] {}; // [FUNCTION]

void() BecomeBeamHit = { // [FUNCTION]
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/custents/beamhit.spr");
	self.solid = SOLID_NOT;
	beamhit1 ();
};

void() beamring1 =	[1,		beamring2] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring2 =	[2,		beamring3] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring3 =	[4,		beamring4] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring4 =	[6,		beamring5] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring5 =	[8,		beamring6] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring6 =	[10,	beamring7] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring7 =	[12,	beamring8] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring8 =	[14,	beamring9] {self.nextthink = time + 0.05;}; // [FUNCTION]
void() beamring9 =	[16,	SUB_Remove] {self.nextthink = time + 0.05;}; // [FUNCTION]

void() d_beamring1 =	[2,		d_beamring2] {}; // [FUNCTION]
void() d_beamring2 =	[4,		d_beamring3] {}; // [FUNCTION]
void() d_beamring3 =	[8,		d_beamring4] {}; // [FUNCTION]
void() d_beamring4 =	[12,	d_beamring5] {}; // [FUNCTION]
void() d_beamring5 =	[16,	SUB_Remove] {}; // [FUNCTION]

void(vector ringorg) MakeBeamRing = { // [FUNCTION]
	local entity ringent;
	
	ringent = spawn();
	ringent.movetype = MOVETYPE_NONE;
	setmodel (ringent, "progs/custents/dring.spr");
	ringent.solid = SOLID_NOT;
	setorigin(ringent, ringorg);
	ringent.angles = '90 0 0';
	ringent.frame = 0;
	if (deathmatch) ringent.think = d_beamring1;
	else {
		ringent.nextthink = time + 0.05;
		ringent.think = beamring1;
	}

	ringent = spawn();
	ringent.movetype = MOVETYPE_NONE;
	setmodel (ringent, "progs/custents/dring.spr");
	ringent.solid = SOLID_NOT;
	setorigin(ringent, ringorg);
	ringent.angles = '-90 0 0';
	ringent.frame = 0;
	if (deathmatch) ringent.think = d_beamring1;
	else {
		ringent.nextthink = time + 0.05;
		ringent.think = beamring1;
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
        // Draw from source point to target point, except for players.  For
        // players, draw from target point to source point because engine
        // always draws from origin in case of player.
        if (targ.flags & FL_CLIENT) Tent_Beam(TE_LIGHTNING2, targ, end, spot);
        else Tent_Beam(TE_LIGHTNING2, targ, spot, end);

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
    head = findradius(spot,radius);
    while (head) { // Notarget/stealth won't save you from discharge.  Don't waste hits on immune targets, though.
        if (head.takedamage == DAMAGE_AIM && head != attacker
            && head != ignore && head.resist_cells < 1
            && !(nofriendlyfire && Ally_Check(head,attacker))
            && Align_Opposing(head,attacker)) {
			// Go to the trouble of zapping live, highly vulnerable targets
            // first instead of dead or resistant targets.
			if (head.deadflag || (head.health <= 0) || (head.resist_cells > 0)) { // Dead or resistant -- save it for later.
				head.chain2 = saved;
				saved = head;
			} else if (BurstLit_Trace(head,inflictor,attacker,damage,spot,bang)) {
				hits = hits + 1;
				if (hits >= maxhits) {
					if (attacker.flags & FL_CLIENT) {
						attacker.ammo_cells = SUB_ClampFloat(attacker.ammo_cells - floor(maxhits * 3),0,attacker.ammo_cells);
						attacker.currentammo = attacker.ammo_cells;
					}
					return;
				}
			}
        }
        head = head.chain;
    }
	// Now we zap the saved targets because we ran out of other targets.
    while (saved) {
        if (BurstLit_Trace(saved,inflictor,attacker,damage,spot,bang)) {
            hits = hits + 1;
            if (hits >= maxhits) {
				if (attacker.flags & FL_CLIENT) {
					attacker.ammo_cells = SUB_ClampFloat(attacker.ammo_cells - floor(maxhits * 3),0,attacker.ammo_cells);
					attacker.currentammo = attacker.ammo_cells;
				}
				return; // I hate to burst your chain, but...
			}
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

//void(entity inflictor, entity attacker,
//	float damage, entity ignore,
//	vector spot, vector pak,
//	float bang) 
void(entity attacker) BurstLit_Discharge = { // [FUNCTION]
    local vector pak;

    pak_x = self.style; // nofriendlyfire
    pak_y = self.distance; // radius
    pak_z = self.count; // maxhits
    BurstLit_Chain(self,attacker,self.dmg * 0.5,self.enemy,self.origin,pak,TRUE);
};

// Called by exploding plasma balls.  Also by Mjolnir.
void() RyuPlasma_Discharge = { // [FUNCTION]
	BurstLit_Discharge(self.owner);
};

// "Storm" Lightning Strike  (a.k.a. Airstrike).  This creates a blank entity that will zap targets in the water within a radius for damage.
void(entity attacker, vector spot, float damage, entity ignore) Zapper_Spawn = { // [FUNCTION]
    local   entity  zap;

    zap = spawn();
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = world;
    setall (zap, "", '0 0 0', '0 0 0', spot);   // invisible
    Rocket_Explosion2 (zap.origin, 244, 3);
    T_RadiusDamage (zap, attacker, damage, ignore, DAMAGEALL);
    remove (zap);
};

// This creates a lightning bolt that flashes down from the sky and strikes with explosive impact.
void(entity attacker, vector spot, float damage) Thunderstrike_Ex = { // [FUNCTION]
	local float points, den, blud;
    local vector air, start, end;
    local entity targ, ignore, zap;

    air = '0 0 2048';   // Max limit of lightning draw length possible.
    traceline (spot, spot + air, TRUE, world);
    start = trace_endpos - '0 0 2';

    // WARNING:  Using 'world' as last traceline argument does not work.
    // Trying to do so causes the trace to ignore all, even if the third argument is FALSE.
    // Create dummy entity to serve as ignore for the traceline. That way, the lightning strike can hit even the attacker.
    zap = spawn();
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = world;
    setall (zap, "", '0 0 0', '0 0 0', spot);   // invisible   
    traceline (start, spot - air, FALSE, zap); // Execute trace.
    targ = trace_ent;
    // Don't remove zap now, we need it later for thunder effects.
    // Proceed with traceline results.
    if (targ.takedamage) { // Direct hit.
        end = Midpoint (targ);
        ignore = targ;
        traceline (end, end + air, TRUE, world); // Trace up from target center to new point in the sky.
        start = trace_endpos - '0 0 2';
        points = SUB_RandomDamage(damage);
		den = points * targ.resist_cells * 4;
		den = floor (den);
		if (den > 0) {
			if (targ.bloodtype == BLOOD_RED) blud = 225; // Lightning blood.
			else blud = targ.bloodtype;
				
			if (blud > 0) particle (end, '0 0 100', blud, den); // Hit/bleed
			else particle (end, '0 0 20', 0 - blud, 10);  // chunks
		}
		T_Damage(targ, attacker, attacker, points, DAMARMOR); // Damage the target.  NOTE:  Reflection won't save the target from the wrath of god.
    } else {
        end = trace_endpos;
        ignore = world;
    }

    // Create lightning and thunder effects.
    setorigin(zap,end);
    sound(zap,CHAN_AUTO,"hipnotic/weapons/mjolhit.wav",1,0.5);  // It's loud.
	QC_ParseBeam(TE_LIGHTNING1,string_null, zap, start, end, 32);
    remove(zap);   // Dummy served its purpose, now begone.
    if (pointcontents(end) == CONTENT_SKY) return;     // Don't explode if it hits sky below.

    Zapper_Spawn(attacker,end,damage,ignore); // Create explosion on impact.
    ShockWave(end + '0 0 4', 8, 4, "progs/drake/s_wave.spr",FALSE);
};

float(entity targ, entity attacker) Divine_Trace = { // [FUNCTION]
	local float dist;

    if (!(targ.flags & FLx_CREATURE)) return FALSE;
	if (targ.deadflag) return FALSE;
	if (targ.health <= 0) return FALSE;
	if (!targ.solid) return FALSE;
	if (!targ.modelindex) return FALSE;
    if (!Align_Opposing(attacker,targ)) return FALSE;

	traceline(attacker.origin + attacker.view_ofs, targ.origin + targ.view_ofs, TRUE, attacker); // Sees through monsters.
	if (trace_fraction != 1) return FALSE;
	if (UpIsSky(targ.origin,targ)) {
		dist = vlen(targ.origin - attacker.origin);
		if (dist >= 140 && dist <= 2000) return TRUE;
	} else return FALSE;
};

// Like CheckPowerups, except this sends a lethal bolt of lightning down to self.
void() Divine_Check = { // [FUNCTION]
	local entity attacker;

    if (!self.divine_finished || self.divine_finished >= time) return;

	attacker = self.divine_attacker;
	self.divine_finished = 0;
	self.divine_attacker = world;
	if (attacker.divine_hits <= 0) return;
	if (!Divine_Trace(self, attacker)) return;

	Thunderstrike_Ex(attacker,self.origin,80);  // Lightning can hit the target.  Send the lightning down.  Since a diety is attacking on behalf of the attacker, damage is indirect.
	LightZero_Set(20,0,-4);
	if (attacker) attacker.divine_hits = attacker.divine_hits - 1;
};

// Wrath of God (WOG).  Spawns a mini lightning storm.  The attacker is 'self'.
// 'shots' = Maximum bolts called down.
// 'dur' = How long the darkness lasts.
float(float shots, float dur) Divine_Wrath = { // [FUNCTION]
    local   entity  head;
    local   float   hits;
    local   vector  vx, dir;

    if (!self) return FALSE;
	
    if (self.flags & FL_CLIENT) vx = self.v_angle;
    else vx = self.angles;
	
    makevectors (vx);
    vx = v_forward;
    hits = 0;
    head = nextent (world);
    while (head) {
        if (Divine_Trace(head, self)) {
            dir = normalize (head.origin - self.origin);
            if (dir * vx > 0.7071) { // Must be within fov 90.
				// Send a bolt down.  Proxy damage due to divine intervention.
                // Note:  The latest attacker overrides previous attackers.
                head.divine_attacker = self;
                head.divine_finished = hits * 0.1 + time;
                hits = hits + 1;
            }
        }
        head = nextent (head);
    }
    if (hits) {
        if (!shots) shots = 255; // Set maximum hits an attacker may score.
        if (!lightzero_finished) sound (world, CHAN_AUTO, "drake/bane/thunder.wav", 1, ATTN_NONE);
        LightZero_Set(-1,dur,-2);
        self.divine_hits = shots; // Number of bolts in slam, so match that.
    }
    return hits;
};

// Mjolnir use for monsters!
void(vector spot) M_Slam = { // [FUNCTION]
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction < 1.0) {   // Slammed the ground, so fire off some lightning.
        Thor_Slam (10, 30);
        Quake_Spawn(self,800,10,trace_endpos,TRUE,2,VEC_QUAKE);
    }
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
	BurstLit_Discharge(self.master);
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
    setall(newmis, "", '0 0 0', '0 0 0', self.origin);
    SUB_ThinkImmediate(newmis, Thor_Pulse);
};