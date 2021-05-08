// AIRG_MAIN_START
/*
 * File: horn.qc
 * Date: 3 Jan 1997
 *
 * Description: Air gun main code.
 *
 *    Copyright and Distribution Permissions
 *    --------------------------------------
 *
 *  The modifications included in this archive are Copyright 1997, the Evolve team.
 *  The original QuakeC source is Copyright 1996, id software.
 *
 *  Authors MAY NOT use these modifications as a basis for commercially available work.
 *
 *  You may distribute this Quake modification in any electronic format as long as
 *  all the files in this archive remain intact and unmodified and are distributed
 *  together.
 *
 *  QuakeC, Model and artwork can be reused, but credit for the individual developers on
 *   the AirFist team is required.
 *
 */

void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite;
float (entity e) hornInfront;
void() removeFlyMode;


$cd id1/progs/s_ablast

$frame ablast1 ablast2 ablast3 ablast4 ablast5 ablast6



// The Main code for the AirFist that is called when the AirFist is fired.
void() launch_horn =
{
	// Local variables used in the function
  local entity e;
  local vector delta;
  local vector dir;
  local float eSpeed;
  local float dist;
  local float percent;
  local float ldmg;
  local float nearAWall;

  // Constants used in the control of how the AirFist is works

  // Maximum strength of the AirFist.  The strength of the affected entity's
  // movement is based on the distance from the center of the shot.
  local float strength;
  strength = 1000;  // full power of weapon

  // Maximum damage that can be incurred by the AirFist.  The actual entity's
  // damage is based on the distance from the center of the shot.
  local float inDamage;
  inDamage = 20;  // full damage of weapon

  // Range of the AirFist blast.
  local float inRange = 400;  // range of weapon

  // Number of bubbles generated when the AirFist is fired under water.
  local float numBubbles = 3; // number of bubbles generated in the water

  // Recoil strength of the AirFist on the player that shot the weapon.
  local float recoil = 300; // recoil strength of the gun

	// Reshot time for the airgun attack in seconds.
	local float attackTime = 0.5;

	// Max number of times that the weapon can fired in a period of time.
	local float maxFireRate = 5;

  // The maximum number of seconds that maxFireRate can fire in.  If the
  // player has reached the maxFireRate in under the shotTimeout then all
  // shots up to the shotTimeout are "failed" shots that don't do anything.
  // e.g.  time to fire is 0.5 seconds.
  //       maxFireRate is 5.
  //       shotTimeout is 5.5 seconds.
  //
  // If 5 shots where fired at the max rate this would take 2.5 seconds.
  // So there would be a 3 seconds wait before the AirFist will fire again.
  // Any fire rate greater than 2.5 seconds will incure a smaller or no
  // wait time.  Any shots fired in that wait time are "failed" shots that
  // will do nothing.
  local float shotTimeout = 5.5; // number of seconds for the maxFireRate

  // The AirFist fire codde:

  // By default, assume not near a wall.
  nearAWall = 0;

  // Make such that all previous attack code completes.
  if (!self.button0)
    {player_run ();return;}  // Complete any other attacks first.

  // How long the fire time is.
	self.attack_finished = time + attackTime;

  // First attack in the shotTimeout period
  if(self.AIRG_FireCount == 0 || self.AIRG_Timeout < time)
  {
     // Set count and timeout length
     self.AIRG_Timeout = time + shotTimeout + attackTime;
     self.AIRG_FireCount = 1;
  }
  // Max Fire Rate reached, so this is a failed shot.
  else if(self.AIRG_FireCount >= maxFireRate)
  {
    // play failed AirFist sound
    if(self.waterlevel > 2)
    {  // below the water, play under water sound
      sound (self, CHAN_AUTO, "weapons/agwfail.wav", 1, ATTN_NORM);
    }
    else
    { // play above water sound
      sound (self, CHAN_AUTO, "weapons/agfail.wav", 1, ATTN_NORM);
    }

    // play Failed AirFist animation
    player_failedairgun1();
    // and get out of here.
    return;
  }
  else
  {
    // Count number of shots.
    self.AIRG_FireCount = self.AIRG_FireCount + 1;
  }

  if(self.waterlevel > 2) // if under water, change the variables
  {
  	// reduced the range by %20
    inRange = inRange * 0.80;

    // double the damage possible
    inDamage = inDamage * 2;
  }

  // Get all the entity's in the shot range
  makevectors(self.v_angle);
  e = findradius(self.origin, inRange);

  while (e)
  {
    // This is the exclusion code.  It excludes everything that is "Illegal" to
    // move. eg. doors.

    // You may find this code looks funny,  it is the same is doing
    // a if( exp & exp & exp & exp) but this way is faster.
    //   (read the QuakeC manual for reason). 

    // only affect monsters and projectiles
    if (visible(e)) // must be visible AND
    if (self.waterlevel > 2 || hornInfront(e)) // infront of self or anywhere in the water AND
    if(e.movetype != MOVETYPE_NONE) // anything that can move
    if(e.movetype != MOVETYPE_PUSH)
    if(e.movetype != MOVETYPE_NOCLIP)
// AIRG_EXCLUDE_START
    if((e.AIRG_Flags & AIRG_EXCLUDEENTITY) != AIRG_EXCLUDEENTITY) // custom exclusion (like laser fire)
// AIRG_EXCLUDE_END
    if(e != self)  // but not myself!!
    {
      // if flying creature and movetype is step then change to fly
      // NOTE: For some reason the normal quakeC, flying monsters has set a
      //   movetype of MOVETYPE_STEP which means that changing the velocity
      //   does not do anything.  Our workaround was to change the movetype
      //   to MOVETYPE_FLY.  Flying monsters where then affected by
      //   velocity.  In all our testing we found that this only affected the
      //   entity's when they died.  When dead, they fall UP instead of down.
      //   Other than this they did not seam to have any adverse affect.  If you
      //   find that you have trouble with this code, let us know.
      if(e.flags & FL_FLY)
      {
      	if(e.movetype == MOVETYPE_STEP)
	      {
          // set so we can affect velocity
	        e.movetype = MOVETYPE_FLY;

          // create a entity to remove the MOVETYPE_FLY when we are done with it.
          //   the only problem with using this method is that while the entity
          //   is dead but the tracker has not converted it back to STEP, the
          //   entity will fall up until changed.  For a generic method, we
          //   at the Evolve team can live with that.
          e.AIRG_FlyTracker = spawn();
          e.AIRG_Flags = e.AIRG_Flags + AIRG_STEPCONVERTEDTOFLY;
          e.AIRG_FlyTracker.owner = e;
          e.AIRG_FlyTracker.nextthink = time + 2;
          e.AIRG_FlyTracker.think = removeFlyMode;

        }
        else if(e.AIRG_Flags & AIRG_STEPCONVERTEDTOFLY)
        {
          // We have already converted this one, just extend the time to convert
          e.AIRG_FlyTracker.nextthink = time + 2;
        }
      }

      // Calculate the distance from the entity.
      delta = e.origin - self.origin + self.view_ofs;
      dist = vlen(delta);

      // Convert distance to a percentage.
      percent = (inRange - dist) / inRange;

      if (e.flags & FL_ONGROUND)
      {
      	// If there on the ground, raise them up so that the velocity will
        // take affect.

        // raise the bugger a bit
        setorigin(e, e.origin + '0 0 1');

        // We biased the up direction when entity is on the ground.
        // Looks cooler and small entitys (heath, etc) go somewhere instead
        // of along the ground (cas there below the line of sight).

        // If on the ground, makem go up, up, and away
        e.flags = e.flags - FL_ONGROUND;
        if (delta_z < 0)
          delta_z = delta_z / -2;
        delta = delta * 0.7;

        if (delta_z < 100)
          delta_z = 100;
      }

      // calculate the velocity adjustment.
      delta = normalize(delta);
      delta = delta * percent * strength;

		  if(self.waterlevel > 2) // if under water, change the blast amount
      {
        // if within 1/2 radius of the blast
        if(percent >= 0.50)
        if(e.classname == "player") // and is a player
				if (self.radsuit_finished == 0) // and not wearing bio
        {
          // that's it, no more air for him, chock time!!!
					self.air_finished = time - 1;
        }

		    if(hornInfront(e)) // infront of self
        {
          // reduce by %20
          delta = delta * 0.80;
        }
        else // All other entity's are hit by water movement.
        {
          // reduce by %50
        	delta = delta * 0.50;

          // reduce the damage possible as well
          percent = percent * 0.50;
        }
      }

      if(e.movetype == MOVETYPE_FLYMISSILE)
      {
        // If its a missile, change the direction but keep the same speed.
        eSpeed = vlen(e.velocity);
        e.velocity = normalize(delta) * eSpeed;
      }
      else
      {
        // Apply the velocity adjustment
        e.velocity = e.velocity + delta;

        // calculate the damage amount
        ldmg = percent * inDamage;

        // This section of code is to even of the "figure momentum add" in the
        // T_Damage function that recoils damaged entity's away from the attacker.
        //   NOTE:  If that section of code in T_Damage changesm then this will have to
        //          change.
        if(e.movetype != MOVETYPE_WALK) // to even out the T_Damage "figure momentum add"
              {
          dir = e.origin - (self.absmin + self.absmax) * 0.5;
          dir = normalize(dir);
          e.velocity = e.velocity + dir * ldmg * 8;
        }

        // Apply damage to the entity.
        T_Damage(e, self, self, ldmg);
      }
    }
    e = e.chain;
  }

  if(self.waterlevel > 2)
  {  // below the water, produce bubbles
     DeathBubbles(numBubbles);
  }

  // check if near a wall
  makevectors(self.v_angle);
  dir = self.origin + self.view_ofs;
  traceline (dir, dir + v_forward * 64, FALSE, self);

  if (trace_fraction != 1.0 && !trace_ent.takedamage)
  {
    nearAWall = 1;
  }

  // Produce the AirFist fire blast sprites to the top left and right of the
	// self's view.
  //void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite =
  if(self.waterlevel > 2)
  {
  	// under water, go slower (%50 slower)
  	hornBlastSprite(nearAWall, 50, -50, 300, -20, 0.50);
	  hornBlastSprite(nearAWall, 50, 50, 300, 20, 0.50);
  }
  else
  {
    // above water, normal speed
  	hornBlastSprite(nearAWall, 50, -50, 300, -20, 1.0);
	  hornBlastSprite(nearAWall, 50, 50, 300, 20, 1.0);
  }

  // recoil code
  if (self.flags & FL_ONGROUND)
  {
   	// If self on the ground, raise me up so that the velocity will
    // take affect.

    // raise the bugger a bit
    setorigin(self, self.origin + '0 0 1');
    self.flags = self.flags - FL_ONGROUND;
   }

  if(nearAWall)
  {  // hit wall, Bounce based on the distance from the wall
    recoil = recoil + (recoil * (1.0 - trace_fraction) * 3);
  }

  // recoil self
  self.velocity = self.velocity + v_forward * recoil * -1;

  if(self.waterlevel > 2)
  {  // below the water, play under water sound
    sound (self, CHAN_AUTO, "weapons/agwater.wav", 1, ATTN_NORM);
  }
  else
  { // play above water sound
    sound (self, CHAN_AUTO, "weapons/agfire.wav", 1, ATTN_NORM);
  }

  // AirFist gun frame animation
  player_airgun1();
};


// modification of infront() from ai.qc to be tighter
float (entity e) hornInfront =
{
  local vector  vec;
  local float    dot;

  makevectors (self.v_angle);
  vec = normalize (e.origin - self.origin - self.view_ofs);
  dot = vec * v_forward;

  if ( dot > 0.8 )
  {
    return TRUE;
  }
  return FALSE;
};



// The AirFist fire blast sprite animation code.

void() run_ablast1   =[$ablast1, run_ablast2  ] {};
void() run_ablast2   =[$ablast2, run_ablast3  ] {};
void() run_ablast3   =[$ablast3, run_ablast4  ] {};
void() run_ablast4   =[$ablast4, run_ablast5  ] {};
void() run_ablast5   =[$ablast5, run_ablast6  ] {};
void() run_ablast6   =[$ablast6, run_ablast1  ]
{
  remove(self);
};


// AirFist fire blast sprite animation under water (slowed down).

void() run_ablastWater1   =[$ablast1, run_ablastWater2  ] {};
void() run_ablastWater2   =[$ablast1, run_ablastWater3  ] {};
void() run_ablastWater3   =[$ablast2, run_ablastWater4  ] {};
void() run_ablastWater4   =[$ablast2, run_ablastWater5  ] {};
void() run_ablastWater5   =[$ablast3, run_ablastWater6  ] {};
void() run_ablastWater6   =[$ablast3, run_ablastWater7  ] {};
void() run_ablastWater7   =[$ablast4, run_ablastWater8  ] {};
void() run_ablastWater8   =[$ablast4, run_ablastWater9  ] {};
void() run_ablastWater9   =[$ablast5, run_ablastWater10 ] {};
void() run_ablastWater10  =[$ablast5, run_ablastWater1  ]
{
  remove(self);
};




// Create a AirFist blast sprite
void(float nearAWall, float adjustForward, float adjustRight, float adjustUp, float positionRight, float spriteSpeed) hornBlastSprite =
{
  local entity sprite, oldself;

  oldself = self;

  // Create the blast sprite and sets the variables.

  sprite = spawn();

  sprite.solid = SOLID_NOT;

  if(oldself.waterlevel > 2)
  {  // below the water, play under water animation
	  sprite.movetype = MOVETYPE_NOCLIP;
  }
  else
  {  // above water, play normal animation
	  sprite.movetype = MOVETYPE_BOUNCE;
  }

  setmodel(sprite, "progs/s_ablast.spr");

  // Set the velocity based on the parameters passed
  sprite.velocity =
      v_forward * random() * adjustForward  +
      v_right * random() * adjustRight +  // [MWH:01/12/97] Reduced left/right/up/down variablilty
      v_up * random() * adjustUp;

  // set Speed
  sprite.velocity = sprite.velocity * spriteSpeed;

  if(nearAWall)
  {
    // If near a wall, blast in face.
    setorigin(sprite, self.origin + self.view_ofs + (v_right * positionRight));  // [MWH:01/12/97] raised origin a bit
  }
  else
  {
    // Not near a wall, so set start position in front of the player.
    setorigin(sprite, self.origin + self.view_ofs + (v_forward * 30) + (v_right * positionRight));  // [MWH:01/12/97] raised origin a bit
  }
  setsize(sprite, '-8 -8 -8', '8 8 8');

  // play sprite animation.
  self = sprite;

  if(oldself.waterlevel > 2)
  {  // below the water, play under water animation
	  run_ablastWater1();
  }
  else
  {  // above water, play normal animation
	  run_ablast1();
  }

  self = oldself;
};



void() removeFlyMode =
{
	// convert the movetype back to MOVETYPE_STEP cas we are finished with
  // the velocity change (we should be anyway).
  self.owner.movetype = MOVETYPE_STEP;
  self.owner.AIRG_Flags = self.owner.AIRG_Flags - AIRG_STEPCONVERTEDTOFLY;

  // don't need self anymore, remove self.
  remove(self);
};

// AIRG_MAIN_END

