//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Airfist...
//               The Evolve team
//               Christopher Bolin: Concept and Artwork
//               Stephen F. Karl:	Model
//               Shane W. Powell:	QuakeC
//               Matt Houser:		QuakeC
//               Mark Lewis:		Sounds
//               Jon Skinner 
//               Travis Prebble (web help)
//               Stephen Heaslip (Blue)
//               Dan Martin, David Karl, Chris McGowen and Kirk Cooper for
//               "extensive" testing and included demos.
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
// Function count: 20
//
// Implements: Airfist firing effects main code.
//
// Description:
// Date: 3 Jan 1997
//
// Copyright and Distribution Permissions
// --------------------------------------
// The modifications included in this archive are Copyright 1997, the Evolve
// team.  Authors MAY NOT use these modifications as a basis for commercially
// available work.  You may distribute this Quake modification in any
// electronic format as long as all the files in this archive remain intact and
// unmodified and are distributed together. (See credits folder. -Qmaster)
//
// QuakeC, Model and artwork can be reused, but credit for the individual
// developers on the Airfist team is required.
//
// Max number of times that the weapon can fired in a period of time is 5.
// The maximum number of seconds that it can fire in is 6 secs.  If the
// player has reached 5 fires in under the shotTimeout then all
// shots up to the shotTimeout are "failed" shots that don't do anything.
// e.g.  time to fire is 0.5 seconds.
//
// If 5 shots where fired at the max rate this would take 2.5 seconds.
// So there would be a 3 seconds wait before the AirFist will fire again.
// Any fire rate greater than 2.5 seconds will incure a smaller or no
// wait time.  Any shots fired in that wait time are "failed" shots that
// will do nothing.
//=============================================================================

.float AIRG_Flags; // Used to flag states for entity's for the AirFist mod. At the moment the AIRG_Flags variable is used only for the exclusion routine but this may change.
.entity AIRG_FlyTracker; // Variables used to track when to turn of FLY movetype for flying entity's
float AIRG_STEPCONVERTEDTOFLY = 2; // Constant used on the AIRG_Flags to specifiy that we have converted this flying monsters movetype from MOVETYPE_STEP to MOVETYPE_FLY (see horn.qc for more info).
float AIRG_EXCLUDEENTITY = 1; // Air Gun flag constants. Setting an entity's AIRG_Flags excludes it from harm
.float AIRG_FireCount; // Used in the Max Fire Rate Calculations.
.float AIRG_Timeout;
void() launch_horn; // Prototypes used
void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite;
float (entity e) hornInfront;
void() removeFlyMode;
void() player_airgun1;
void() player_failedairgun1;
void(float num_bubbles) death_bubbles;

$cd id1/progs/airfist/s_ablast
$frame ablast1 ablast2 ablast3 ablast4 ablast5 ablast6

void() W_FireAirFist = { launch_horn(); }; // Redirect for consistent and clear naming. -Qmaster

// The main code for when the Airfist is fired.
void() launch_horn = {
	local entity e;
	local vector delta, dir;
	local float eSpeed, dist, percent, ldmg, nearAWall, inDamage, inRange, recoil;

	// Constants used in the control of how the Airfist works
	inDamage = 20; // Maximum damage that can be incurred by the Airfist.  The actual entity's damage is based on the distance from the center of the shot.
	inRange = 400; // Range of the Airfist blast.
	recoil = 300; // Recoil strength of the Airfist on the player that shot the weapon.
	if (self.tome_finished) {
		inDamage = inDamage * 2; // Double damage
		recoil = recoil * 2; // Double impact force for player
	}
	nearAWall = 0; // By default, assume not near a wall.

	if (!self.button0) { player_run (); return; } // Make such that all previous attack code completes.

	W_Reload(0.5); // How long the fire time is.

	// First attack in the shotTimeout period
	if(self.AIRG_FireCount == 0 || self.AIRG_Timeout < time) {
		self.AIRG_Timeout = time + 6; // Set timeoute length
		self.AIRG_FireCount = 1; // and the count
	} else if(self.AIRG_FireCount >= 5) { // Max Fire Rate reached, so this is a failed shot.
		if(self.waterlevel > 2) // Play failed AirFist sound
			sound (self, CHAN_AUTO, "weapons/agwfail.wav", 1, ATTN_NORM); // Below the water, play under water sound
		else
			sound (self, CHAN_AUTO, "weapons/agfail.wav", 1, ATTN_NORM); // Play above water sound

		player_failedairgun1(); // Play Failed AirFist animation
		return;					// and get out of here.
	} else {
		// Count number of shots.
		self.AIRG_FireCount = self.AIRG_FireCount + 1;
	}

	if(self.waterlevel > 2) { // if under water, change the variables
		inRange = inRange * 0.80; // reduced the range by %20
		inDamage = inDamage * 2; // double the damage possible
	}

	// Get all the entity's in the shot range
	makevectors(self.v_angle);
	e = findradius(self.origin, inRange);
	while (e) {
		if (e == self || e.solid == SOLID_BSP || e.movetype == MOVETYPE_NONE || (e.AIRG_Flags & AIRG_EXCLUDEENTITY)) {e = e.chain; continue; } // This is the exclusion code.  It excludes everything that is "Illegal" to move. eg. doors.

		if (visible(e) && (self.waterlevel > 2 || hornInfront(e)) && (AffectedByPhysics(e) || e.flags & FLx_CREATURE)) { // Affect monsters and projectiles
			// if flying creature and movetype is step then change to fly
			// NOTE: For some reason the normal quakeC, flying monsters has set a
			// movetype of MOVETYPE_STEP which means that changing the velocity
			// does not do anything.  Our workaround was to change the movetype
			// to MOVETYPE_FLY.  Flying monsters where then affected by
			// velocity.  In all our testing we found that this only affected the
			// entity's when they died.  When dead, they fall UP instead of down.
			// Other than this they did not seam to have any adverse affect.  If you
			// find that you have trouble with this code, let us know.
			if(e.flags & FL_FLY) {
				if(e.movetype == MOVETYPE_STEP) {
					e.movetype = MOVETYPE_FLY; // set so we can affect velocity

					// Create an entity to remove the MOVETYPE_FLY when we are done with it.
					// The only problem with using this method is that while the entity
					// is dead but the tracker has not converted it back to STEP, the
					// entity will fall up until changed.  For a generic method, we
					// at the Evolve team can live with that.
					e.AIRG_FlyTracker = spawn();
					e.AIRG_Flags = e.AIRG_Flags + AIRG_STEPCONVERTEDTOFLY;
					e.AIRG_FlyTracker.owner = e;
					e.AIRG_FlyTracker.nextthink = time + 2;
					e.AIRG_FlyTracker.think = removeFlyMode;
				} else if(e.AIRG_Flags & AIRG_STEPCONVERTEDTOFLY) {
					e.AIRG_FlyTracker.nextthink = time + 2; // We have already converted this one, just extend the time to convert
				}
			}

			// Calculate the distance from the entity.
			delta = e.origin - self.origin + self.view_ofs;
			dist = vlen(delta);
			percent = (inRange - dist) / inRange; // Convert distance to a percentage.
			if (e.flags & FL_ONGROUND) {
				setorigin(e, e.origin + '0 0 1'); // Raise the bugger a bit; if they're on the ground, we raise them up so that the velocity will take affect.

				// We biased the up direction when entity is on the ground.
				// Looks cooler and small entitys (heath, etc) go somewhere instead
				// of along the ground (because they're below the line of sight).
				e.flags = e.flags - FL_ONGROUND; // If on the ground, makem go up, up, and away
				if (delta_z < 0) delta_z = delta_z / -2;
				delta = delta * 0.7;
				if (delta_z < 100) delta_z = 100;
			}

			delta = normalize(delta);
			delta = delta * percent * 1000; // Calculate the velocity adjustment.  Maximum strength of the Airfist is 1000.  The strength of the affected entity's movement is based on the distance from the center of the shot.
			if(self.waterlevel > 2) { // if under water, change the blast amount
				if ((percent >= 0.50) && (e.classname == "player") && (self.radsuit_finished == 0)) self.air_finished = time - 1; // If within 1/2 radius of the blast and is a player and not wearing bio that's it, no more air for him, choke time!!!
				if (hornInfront(e)) { // infront of self
					delta = delta * 0.80; // reduce by %20
				} else { // All other entity's are hit by water movement.
					delta = delta * 0.50; // reduce by %50  
					percent = percent * 0.50; // reduce the damage possible as well
				}
			}

			if (IsMissile(e)) { // If its a missile, change the direction but keep the same speed.
				eSpeed = vlen(e.velocity);
				e.velocity = normalize(delta) * eSpeed;
			} else {
				e.velocity = e.velocity + delta; // Apply the velocity adjustment
				ldmg = percent * inDamage; // Calculate the damage amount

				// This section of code is to even of the "figure momentum add" in the
				// T_Damage function that recoils damaged entity's away from the attacker.
				// NOTE:  If that section of code in T_Damage changes, then this will have to change.
				if(e.movetype != MOVETYPE_WALK) { // to even out the T_Damage "figure momentum add"
				  dir = e.origin - (self.absmin + self.absmax) * 0.5;
				  dir = normalize(dir);
				  e.velocity = e.velocity + dir * ldmg * 8;
				}

				T_Damage(e, self, self, ldmg, NOARMOR); // Apply damage to the entity.
			}
		}
		e = e.chain;
	}
	if(self.waterlevel > 2) death_bubbles(3); // below the water, produce bubbles
	makevectors(self.v_angle);
	dir = self.origin + self.view_ofs;
	traceline (dir, dir + v_forward * 64, FALSE, self); // check if near a wall
	if (trace_fraction != 1.0 && !trace_ent.takedamage) nearAWall = 1;

	// Produce the AirFist fire blast sprites to the top left and right of the self's view.
	if(self.waterlevel > 2) { // under water, go slower (%50 slower)
		hornBlastSprite(nearAWall, 50, -50, 300, -20, 0.50);
		hornBlastSprite(nearAWall, 50, 50, 300, 20, 0.50);
		if (self.tome_finished) {
			hornBlastSprite(nearAWall, 48, -50, 305, -20, 0.6);
			hornBlastSprite(nearAWall, 48, 50, 305, 20, 0.6);
		}
	} else { // above water, normal speed
		hornBlastSprite(nearAWall, 50, -50, 300, -20, 1.0);
		hornBlastSprite(nearAWall, 50, 50, 300, 20, 1.0);
		if (self.tome_finished) {
			hornBlastSprite(nearAWall, 48, -50, 305, -20, 1.5);
			hornBlastSprite(nearAWall, 48, 50, 305, 20, 1.5);
		}
	}

	// Recoil code
	if (self.flags & FL_ONGROUND) { // Raise the bugger a bit; if self on the ground, raise me up so that the velocity will take affect.
		setorigin(self, self.origin + '0 0 1');
		self.flags = self.flags - FL_ONGROUND;
	}
	if(nearAWall) recoil = recoil + (recoil * (1.0 - trace_fraction) * 3); // hit wall, Bounce based on the distance from the wall
	self.velocity = self.velocity + v_forward * recoil * -1; // recoil self

	if(self.waterlevel > 2)	sound (self, CHAN_AUTO, "weapons/agwater.wav", 1, ATTN_NORM); // below the water, play under water sound
	else					sound (self, CHAN_AUTO, "weapons/agfire.wav", 1, ATTN_NORM); // play above water sound

	player_airgun1(); // AirFist gun frame animation
};

// Modification of infront() from ai.qc to be tighter
float (entity e) hornInfront = {
	local vector vec;
	local float dot;

	makevectors (self.v_angle);
	vec = normalize (e.origin - self.origin - self.view_ofs);
	dot = vec * v_forward;
	if (dot > 0.8) { return TRUE; }

	return FALSE;
};

// The Airfist fire blast sprite animation code.
void() run_ablast1   =[$ablast1, run_ablast2  ] {};
void() run_ablast2   =[$ablast2, run_ablast3  ] {};
void() run_ablast3   =[$ablast3, run_ablast4  ] {};
void() run_ablast4   =[$ablast4, run_ablast5  ] {};
void() run_ablast5   =[$ablast5, run_ablast6  ] {};
void() run_ablast6   =[$ablast6, run_ablast1  ] { remove(self); };

// Airfist fire blast sprite animation under water (slowed down).
void() run_ablastWater1   =[$ablast1, run_ablastWater2  ] {};
void() run_ablastWater2   =[$ablast1, run_ablastWater3  ] {};
void() run_ablastWater3   =[$ablast2, run_ablastWater4  ] {};
void() run_ablastWater4   =[$ablast2, run_ablastWater5  ] {};
void() run_ablastWater5   =[$ablast3, run_ablastWater6  ] {};
void() run_ablastWater6   =[$ablast3, run_ablastWater7  ] {};
void() run_ablastWater7   =[$ablast4, run_ablastWater8  ] {};
void() run_ablastWater8   =[$ablast4, run_ablastWater9  ] {};
void() run_ablastWater9   =[$ablast5, run_ablastWater10 ] {};
void() run_ablastWater10  =[$ablast5, run_ablastWater1  ] {remove(self);};

// Create a Airfist blast sprite
void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite = {
	local entity sprite, oldself;

	sprite = spawn(); // Create the blast sprite and sets the variables.
	sprite.solid = SOLID_NOT;
	if(oldself.waterlevel > 2) { // below the water, play under water animation
		sprite.movetype = MOVETYPE_NOCLIP;
	} else { // above water, play normal animation
		sprite.movetype = MOVETYPE_BOUNCE;
	}
	setmodel(sprite, "progs/airfist/s_ablast.spr");
	sprite.velocity = (v_forward * random() * adjustForward) + (v_right * random() * adjustRight) + (v_up * random() * adjustUp); // Set the velocity based on the parameters passed. [MWH:01/12/97] Reduced left/right/up/down variablilty
	sprite.velocity = sprite.velocity * spriteSpeed; // Set speed

	if(nearAWall)	setorigin(sprite, self.origin + self.view_ofs + (v_right * positionRight)); // If near a wall, blast in face.  [MWH:01/12/97] raised origin a bit
	else			setorigin(sprite, self.origin + self.view_ofs + (v_forward * 30) + (v_right * positionRight)); // Not near a wall, so set start position in front of the player.  [MWH:01/12/97] raised origin a bit

	setsize(sprite, '-8 -8 -8', '8 8 8');
	oldself = self;
	self = sprite; // play sprite animation.
	if(oldself.waterlevel > 2) { // below the water, play under water animation
		run_ablastWater1();
	} else { // above water, play normal animation
		run_ablast1();
	}
	self = oldself;
};

// Convert the movetype back to MOVETYPE_STEP cas we are finished with the velocity change (we should be anyway).
void() removeFlyMode = {
	self.owner.movetype = MOVETYPE_STEP;
	self.owner.AIRG_Flags = self.owner.AIRG_Flags - AIRG_STEPCONVERTEDTOFLY;
	remove(self); // don't need self anymore, remove self.
};