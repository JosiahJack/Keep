/*
==============================================================================

Yakman 

Model from Hexen 2 (Kinn's Marcher Fortress)
with additional skins from Kinn's Bastion and Marcher
Quake implementation based on Kinn's Marcher with additions of Drake

Monster properties:
Ranged attack:
- He shoots various magical projectiles towards the player
Uses different melee attacks:
- He rips deep wounds with its sharp claws
- He also uses a chargeed/boost attack. Running towards the player pushing him away.

Yakman can replace a big number of id1 monsters

Yakman is fully adjustable.
Almost everything can be adjusted via cvars to personal likings.
Please see cvar descriptions in attached smc_config.cfg sample.

==============================================================================
*/

$cd id1/models/yakman
$origin 0 0 24
$base base        
$skin skin

$frame bwalk1 bwalk2 bwalk3 bwalk4 bwalk5 bwalk6 bwalk7 bwalk8 bwalk9
$frame bwalk10 bwalk11 bwalk12 bwalk13 bwalk14 bwalk15 bwalk16 bwalk17
$frame bwalk18 bwalk19 bwalk20 bwalk21 bwalk22 bwalk23 bwalk24

$frame charge1 charge2 charge3 charge4 charge5 charge6 charge7 charge8
$frame charge9 charge10 charge11 charge12

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17
$frame death18 death19 death20 death21 death22 death23 death24 death25

$frame gorech1 gorech2 gorech3 gorech4 gorech5 gorech6 gorech7 gorech8
$frame gorech9 gorech10 gorech11 gorech12

$frame howl1 howl2 howl3 howl4 howl5 howl6 howl7 howl8 howl9 howl10
$frame howl11 howl12 howl13 howl14 howl15 howl16 howl17 howl18 howl19
$frame howl20 howl21 howl22 howl23 howl24 howl25 howl26 howl27 howl28
$frame howl29 howl30 howl31 howl32 howl33 howl34 howl35 howl36

$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10
$frame jump11 jump12 jump13 jump14 jump15 jump16 jump17 jump18 jump19
$frame jump20 jump21 jump22 jump23 jump24

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8

$frame shake1 shake2 shake3 shake4 shake5 shake6 shake7 shake8 shake9
$frame shake10 shake11 shake12 shake13 shake14 shake15 shake16 shake17
$frame shake18 shake19 shake20

$frame shard1 shard2 shard3 shard4 shard5 shard6 shard7 shard8 shard9
$frame shard10 shard11 shard12 shard13 shard14 shard15 shard16 shard17
$frame shard18 shard19 shard20 shard21 shard22 shard23 shard24 shard25
$frame shard26 shard27 shard28 shard29 shard30 shard31 shard32

$frame slidel1 slidel2 slidel3 slidel4 slidel5

$frame slider1 slider2 slider3 slider4 slider5

$frame wait1 wait2 wait3 wait4 wait5 wait6 wait7 wait8 wait9 wait10
$frame wait11 wait12 wait13 wait14 wait15 wait16 wait17 wait18 wait19
$frame wait20 wait21 wait22 wait23 wait24

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24

//=============================================================================


void() yakman_walk1;


void(float loudness, float attn, float side) yakman_footsteps =
{
	if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
		local float select;
		select = random();
		if (select <= 0.5)
		{
			if (attn == 1)
				sound7(self, CHAN_AUTO, "yakman/step1.wav", loudness, ATTN_NORM, SNDSPD);
			else
				sound7(self, CHAN_AUTO, "yakman/step1.wav", loudness, ATTN_IDLE, SNDSPD);
		}
		else
		{
			if (attn == 1)
				sound7(self, CHAN_AUTO, "yakman/step2.wav", loudness, ATTN_NORM, SNDSPD);
			else
				sound7(self, CHAN_AUTO, "yakman/step2.wav", loudness, ATTN_IDLE, SNDSPD);
		}

		if (side && (autocvar_yakman_walking_quake >= 2))
		{
			makevectors (self.angles);
			if (side == 1)		// "1" left foot
				pointparticles(particleeffectnum("shambler_foot_dust"), self.origin + self.view_ofs + v_up * -40 + v_forward*7 + v_right*-15, '0 0 0', 1);
			else			// "2" right foot
				pointparticles(particleeffectnum("shambler_foot_dust"), self.origin + self.view_ofs + v_up * -40 + v_forward*7 + v_right*15, '0 0 0', 1);
		}
		
		if ((loudness > 0.8) && ((autocvar_yakman_walking_quake == 1) || (autocvar_yakman_walking_quake == 3)))
			shambler_walking_quake ();
	}
};




void() yakman_howl1  =[ $howl1,  yakman_howl2  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl2  =[ $howl2,  yakman_howl3  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl3  =[ $howl3,  yakman_howl4  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl4  =[ $howl4,  yakman_howl5  ] {ai_stand();self.nextthink = time + 0.07;sound7(self, CHAN_VOICE, "yakman/big3.wav", 1, ATTN_IDLE, SNDSPD);};
void() yakman_howl5  =[ $howl5,  yakman_howl6  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl6  =[ $howl6,  yakman_howl7  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl7  =[ $howl7,  yakman_howl8  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl8  =[ $howl8,  yakman_howl9  ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl9  =[ $howl9,  yakman_howl10 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl10 =[ $howl10, yakman_howl11 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl11 =[ $howl11, yakman_howl12 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl12 =[ $howl12, yakman_howl13 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl13 =[ $howl13, yakman_howl14 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl14 =[ $howl14, yakman_howl15 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl15 =[ $howl15, yakman_howl16 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl16 =[ $howl16, yakman_howl17 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl17 =[ $howl17, yakman_howl18 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl18 =[ $howl18, yakman_howl19 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl19 =[ $howl19, yakman_howl20 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl20 =[ $howl20, yakman_howl21 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl21 =[ $howl21, yakman_howl22 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl22 =[ $howl22, yakman_howl23 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl23 =[ $howl23, yakman_howl24 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl24 =[ $howl24, yakman_howl25 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl25 =[ $howl25, yakman_howl26 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl26 =[ $howl26, yakman_howl27 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl27 =[ $howl27, yakman_howl28 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl28 =[ $howl28, yakman_howl29 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl29 =[ $howl29, yakman_howl30 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl30 =[ $howl30, yakman_howl31 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl31 =[ $howl31, yakman_howl32 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl32 =[ $howl32, yakman_howl33 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl33 =[ $howl33, yakman_howl34 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl34 =[ $howl34, yakman_howl35 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl35 =[ $howl35, yakman_howl36 ] {ai_stand();self.nextthink = time + 0.07;};
void() yakman_howl36 =[ $howl36, yakman_stand1 ] {ai_stand();self.nextthink = time + 0.07;};


void() yakman_howl_walk1  =[ $howl1,  yakman_howl_walk2  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk2  =[ $howl2,  yakman_howl_walk3  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk3  =[ $howl3,  yakman_howl_walk4  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk4  =[ $howl4,  yakman_howl_walk5  ] {ai_walk(0);self.nextthink = time + 0.07;sound7(self, CHAN_VOICE, "yakman/big3.wav", 1, ATTN_IDLE, SNDSPD);};
void() yakman_howl_walk5  =[ $howl5,  yakman_howl_walk6  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk6  =[ $howl6,  yakman_howl_walk7  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk7  =[ $howl7,  yakman_howl_walk8  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk8  =[ $howl8,  yakman_howl_walk9  ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk9  =[ $howl9,  yakman_howl_walk10 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk10 =[ $howl10, yakman_howl_walk11 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk11 =[ $howl11, yakman_howl_walk12 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk12 =[ $howl12, yakman_howl_walk13 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk13 =[ $howl13, yakman_howl_walk14 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk14 =[ $howl14, yakman_howl_walk15 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk15 =[ $howl15, yakman_howl_walk16 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk16 =[ $howl16, yakman_howl_walk17 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk17 =[ $howl17, yakman_howl_walk18 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk18 =[ $howl18, yakman_howl_walk19 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk19 =[ $howl19, yakman_howl_walk20 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk20 =[ $howl20, yakman_howl_walk21 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk21 =[ $howl21, yakman_howl_walk22 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk22 =[ $howl22, yakman_howl_walk23 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk23 =[ $howl23, yakman_howl_walk24 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk24 =[ $howl24, yakman_howl_walk25 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk25 =[ $howl25, yakman_howl_walk26 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk26 =[ $howl26, yakman_howl_walk27 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk27 =[ $howl27, yakman_howl_walk28 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk28 =[ $howl28, yakman_howl_walk29 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk29 =[ $howl29, yakman_howl_walk30 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk30 =[ $howl30, yakman_howl_walk31 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk31 =[ $howl31, yakman_howl_walk32 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk32 =[ $howl32, yakman_howl_walk33 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk33 =[ $howl33, yakman_howl_walk34 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk34 =[ $howl34, yakman_howl_walk35 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk35 =[ $howl35, yakman_howl_walk36 ] {ai_walk(0);self.nextthink = time + 0.07;};
void() yakman_howl_walk36 =[ $howl36, yakman_walk1 ] {ai_walk(0);self.nextthink = time + 0.07;};




// Adds 'fadd' to frame 'fr'.  Used to animate monsters.
void(float fr, float fadd, float fmax) WalkFrame_Add =
{
    if ((self.walkframe < 0) || (self.walkframe > fmax))
        self.walkframe = 0;
    self.frame = fr + self.walkframe;
    self.walkframe = self.walkframe + fadd;
};



// STAND - - - - - - - - - - - - - - - -
void() yakman_stand_anim =
{
    if (self.walkframe == 24)  
    {
        if (random() < 0.2)
	{
         	if (random() < 0.5)
			sound7(self, CHAN_VOICE, "yakman/grunt.wav", 1, ATTN_IDLE, SNDSPD);
		else
	                sound7(self, CHAN_VOICE, "yakman/snort2.wav", 1, ATTN_IDLE, SNDSPD);
	}
	else if (random() < 0.11)
	{
		yakman_howl1 ();
		return;
	}
    }
    WalkFrame_Add ( $wait1, 1, 23 );
    ai_stand();
};
void() yakman_stand2 =[ $wait1,  yakman_stand2  ] {yakman_stand_anim();self.nextthink = time + 0.06;};
void() yakman_stand1 =
{
    if (( self.frame < $wait1 ) || ( self.frame > $wait24 ))
        self.walkframe = 0;
    yakman_stand2 ();
};



// WALK/RUN - - - - - - - - - - - - - -
// Walking animation.  Used by walking and running.
// 6 6 6 5 4 5 4 3 3 4 5 6 6 6 6 5 4 4 4 3 2 4 5 7
//  12 9 9 6 9 12 12 9 8 5 9 13
void(float mad) yakman_anim =
{
    local   float   move;

    if (self.walkframe == 24)
    {
        if (random() < 0.22)
	{
        	if (mad)	// running
			sound7(self, CHAN_VOICE, "yakman/snort1.wav", 1, ATTN_NORM, SNDSPD);
		else
		{
	         	if (random() < 0.5)
				sound7(self, CHAN_VOICE, "yakman/grunt.wav", 1, ATTN_IDLE, SNDSPD);
			else
		                sound7(self, CHAN_VOICE, "yakman/snort2.wav", 1, ATTN_IDLE, SNDSPD);
		}
	}
	else if ((random() < 0.11) && (!mad))
	{
		yakman_howl_walk1 ();
		return;
	}
    }
    WalkFrame_Add ( $walk1, 2, 22 );

    if (( self.frame == $walk1 ) || ( self.frame == $walk3 ) || ( self.frame == $walk13 ) || ( self.frame == $walk15 ))
        move = 12;
    else if ( self.frame == $walk7 )
    {
        move = 5;   //6;
       	if (mad)	// running
     	   yakman_footsteps (1, 1, 1);
	else
     	   yakman_footsteps (1, 0, 1);
    }
    else if (self.frame == $walk19 )
    {
        move = 5;   //6;
       	if (mad)	// running
     	   yakman_footsteps (1, 1, 2);
	else
     	   yakman_footsteps (1, 0, 2);
    }
    else if (( self.frame == $walk9 ) || ( self.frame == $walk21 ))
        move = 4;   //6;
    else    // walk5,11,17,23
        move = 9;   //8;

    if (mad)
        ai_run (move);
    else
        ai_walk (move);
};

void() yakman_reset =
{
    if (( self.frame < $walk1 ) || ( self.frame > $walk24 ))
        self.walkframe = 0;
};

void() yakman_walk2 =[ $walk1,  yakman_walk2 ] {yakman_anim(FALSE);self.nextthink = time + 0.1;};
void() yakman_walk1 = {yakman_reset(); yakman_walk2();};

void() yakman_run2  =[ $walk1,  yakman_run2  ] {yakman_anim(TRUE);self.nextthink = time + 0.08;};	// makes him run faster than walking
void() yakman_run1  = {yakman_reset(); yakman_run2();};




// ATTACK - - - - - - - - - - - - - - -
void() yakman_stop1   =[ $gorech1,  yakman_stop2  ] {movetogoal(40);};
void() yakman_stop2   =[ $gorech3,  yakman_stop3  ] {movetogoal(30);};
void() yakman_stop3   =[ $gorech5,  yakman_stop4  ] {movetogoal(40); yakman_footsteps (1, 1, 1);};
void() yakman_stop4   =[ $gorech7,  yakman_stop5  ] {movetogoal(40);};
void() yakman_stop5   =[ $gorech9,  yakman_stop6  ] {movetogoal(30);};
void() yakman_stop6   =[ $gorech11, yakman_run1   ] {
    self.waitmax = time + 5;    // Don't charge again for 5 sec.
    movetogoal (40);
    yakman_footsteps (1, 1, 2);
};


float(float dist) QC_CloseEnough =
{
    if (self.enemy.absmin_x > self.absmax_x + dist)  return FALSE;
    if (self.enemy.absmax_x < self.absmin_x - dist)  return FALSE;
    if (self.enemy.absmin_y > self.absmax_y + dist)  return FALSE;
    if (self.enemy.absmax_y < self.absmin_y - dist)  return FALSE;
    if (self.enemy.absmin_z > self.absmax_z + dist)  return FALSE;
    if (self.enemy.absmax_z < self.absmin_z - dist)  return FALSE;
    return TRUE;
};

// Note:  'd' must be higher than 32 to hit a client.
void(float d) yak_run =
{
    local   entity  targ;
    local   vector  dir, org, vel;
    local   float   ldmg;

    targ = self.enemy;

    if (targ)
    if (QC_CloseEnough (d))
    {
        if (infront (targ))
        if (CanDamage (targ, self))
        {   // We can ram the target!
            d = d / 2;
            if (!QC_CloseEnough (d))
            {   // Move the yakman a bit closer for appearance sake.
		walkmove (self.angles_y, d); 
                ai_face ();
            }

            makevectors (self.angles);
            dir = v_forward;

            sound7(self, CHAN_WEAPON, "yakman/crash.wav", 1, ATTN_NORM, SNDSPD);
        // Send the victim flying back.
                vel = dir * autocvar_yakman_ram_velocity;	// default 277
                if (targ.flags & FL_ONGROUND)
                {   // Knock the target up off the ground a bit.
                    targ.flags = targ.flags - FL_ONGROUND;
                    vel_z = autocvar_yakman_ram_velocity * 0.75;
                }
                targ.velocity = targ.velocity + vel;
	    ldmg = (random() + random() + random()) * autocvar_yakman_ram_damage;	// default 27
	    T_Damage (self.enemy, self, self, ldmg);
        // Fling some gore.
            org = self.origin + v_forward*16;
            dir = v_forward*100 + v_right*(random() * 200);
            SpawnMeatSpray (org, dir);
            dir = v_forward*100 + (random() * -200) * v_right;
            SpawnMeatSpray (org, dir);
        // Get out of the charge anim.
            if (self.health > 0)    // Confirm yakman is alive after impact.
            {
                if ( self.frame == $charge1 )
                    self.think = yakman_stop2;
                else if ( self.frame == $charge3 )
                    self.think = yakman_stop3;
                else if ( self.frame == $charge5 )
                    self.think = yakman_stop4;
                else if ( self.frame == $charge7 )
                    self.think = yakman_stop5;
                else if ( self.frame == $charge9 )
                    self.think = yakman_stop6;
                else
                    self.think = yakman_stop1;
            }
            return;
        }
    // Not facing the target?
        ai_face ();
        return;
    }
// Run toward the target.
    if (walkmove (self.angles_y, d))
        ai_face ();
    else
        movetogoal (d / 2);      // Bump around obstacles.
};

void() yakman_charge1   =[ $charge1,  yakman_charge2  ] {yak_run(40);};
void() yakman_charge2   =[ $charge3,  yakman_charge3  ] {yak_run(30);};
void() yakman_charge3   =[ $charge5,  yakman_charge4  ] {yak_run(40); yakman_footsteps (1, 1, 1);};
void() yakman_charge4   =[ $charge7,  yakman_charge5  ] {yak_run(40);};
void() yakman_charge5   =[ $charge9,  yakman_charge6  ] {yak_run(30);};
void() yakman_charge6   =[ $charge11, yakman_charge1  ] {yak_run(40); yakman_footsteps (1, 1, 2);
    if (time > self.waitmax)
    {
        self.waitmax = time + 5;    // Don't charge again for 5 sec.
        self.think = self.th_run;
    }
};





// walk5->bwalk7...bwalk17->walk19
// walk17->bwalk19...bwalk5->walk7
// 12 12 9 5 4 9
void(float side) yakman_slam =
{
    local   float   dist, ldmg;
    local   vector  org, vel;

    self.encore = 1;    // Flagged so he may attempt missile interrupt later.
    sound7(self, CHAN_WEAPON, "yakman/woosh.wav", 1, ATTN_NORM, SNDSPD);

    if (!self.enemy)
        return;
    if (!CanDamage (self.enemy, self))
        return;

    dist = vlen(self.enemy.origin - self.origin);
    if (dist > 100)
    	return;

    ldmg = (random() + random() + random()) * autocvar_yakman_melee_damage;	// default 17
    T_Damage (self.enemy, self, self, ldmg);
    sound7(self, CHAN_WEAPON, "yakman/slam.wav", 1, ATTN_NORM, SNDSPD);     // Overrides woosh.

    makevectors (self.angles);

// Toss the enemy around.
    self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
    self.enemy.velocity = (v_forward * 50) + (v_right*(100*side)) + '0 0 300';
    self.enemy.velocity = self.enemy.velocity * 0.5;

// Spawn some chunks from the impact.
    org = self.origin + v_forward*16 + '0 0 12';// + v_up*37;
    vel = v_right * side * (random() * 200);
    SpawnMeatSpray (org, vel);
};



void() yakman_left1   =[ $bwalk19, yakman_left2   ] {ai_charge(5); yakman_footsteps (0.8, 1, 1);};
void() yakman_left2   =[ $bwalk21, yakman_left3   ] {ai_charge(4);};
void() yakman_left3   =[ $bwalk23, yakman_left4   ] {ai_charge(9);};
void() yakman_left4   =[ $bwalk1,  yakman_left5   ] {ai_charge(12); yakman_slam(-1);};
void() yakman_left5   =[ $bwalk3,  yakman_left6   ] {ai_charge(12);};
void() yakman_left6   =[ $bwalk5,  yakman_left7   ] {ai_charge(9);
    if (skill >= 2)
    {   // Double backhand check.
        if (!self.cnt)
            {self.think = yakman_run2; self.walkframe = 6;}
        self.cnt = !self.cnt;
    }
};
void() yakman_left7   =[ $bwalk7,  yakman_run2    ] {ai_charge(5); yakman_footsteps (0.8, 1, 2); self.walkframe = 8;};


void() yakman_right1  =[ $bwalk7,  yakman_right2  ] {ai_charge(5); yakman_footsteps (0.8, 1, 1);};
void() yakman_right2  =[ $bwalk9,  yakman_right3  ] {ai_charge(4);};
void() yakman_right3  =[ $bwalk11, yakman_right4  ] {ai_charge(9);};
void() yakman_right4  =[ $bwalk13, yakman_right5  ] {ai_charge(12); yakman_slam(1);};
void() yakman_right5  =[ $bwalk15, yakman_right6  ] {ai_charge(12);};
void() yakman_right6  =[ $bwalk17, yakman_right7  ] {ai_charge(9);
    if (skill >= 2)
    {   // Double backhand check.
        if (!self.cnt)
            {self.think = yakman_run2; self.walkframe = 18;}
        self.cnt = !self.cnt;
    }
};
void() yakman_right7  =[ $bwalk19, yakman_run2    ] {ai_charge(5); yakman_footsteps (0.8, 1, 2); self.walkframe = 20;};


void() yakman_melee =
{
    if ( self.frame == $walk7 )
        yakman_right1 ();
    else if ( self.frame == $walk19 )
        yakman_left1 ();
    else if (self.encore && (random() < 0.1))
        self.th_missile ();
    else
        ai_charge (9);
};






void() s_explode_think =
{
    if (self.frame >= self.cnt)
        {SUB_Remove ();  return;}

    self.frame = self.frame + 1;
    self.nextthink = time + self.wait;
    if (self.frame == self.cnt)
        self.think = SUB_Remove;
};


// As 'BecomeAnyExplosion', with adjustable frames per second.
// Used by some custom explosions.
void(float base, float add, float fps, string text) BecomeFpsExplosion =
{
    if (!add)
        add = 6;    // Assume standard duration of six frames.
    if (!fps)
        fps = 10;

// Become explosion code.
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, text);
    self.solid      = SOLID_NOT;
//- - - -
    self.frame      = base;
    self.cnt        = base + add - 1;
    self.wait       = 1 / fps;
    self.nextthink  = time + self.wait;
    self.think      = s_explode_think;
};


void() YakStar_Touch =
{
    self.touch = SUB_Null;      // Stack overflow prevention.
    T_Damage (other, self, self.owner, autocvar_yakman_projectile_damage);	// default 7
    self.origin = self.origin - 8*normalize(self.velocity);
    sound7(self, CHAN_AUTO, "yakman/expsmall.wav", 1, ATTN_NORM, SNDSPD);
    BecomeFpsExplosion (self.cnt + 6, 5, 20, "progs/s_kinn.spr");
};


//==========================================================================
//  Particle Beam
// Spawns a beam of particles.

void(vector start, vector end, float color1, float color2, float density, float full)  Particle_Beam =
{
    local   vector  delta;
    local   float   points;
    local   float   dist;
    local   vector  next;

    delta = end - start;
    dist = vlen(delta);

    if (full)
    {   // Unbroken, continuous trail.  Used by meteor.
        points = dist / 24;
        points = ceil(points);
        dist = -24;
    }
    else
    {   // Sparse, broken trail.  Useful for frost trails.
        if (deathmatch || coop)
            points = 2;
        else
            points = 3;
        dist = dist / points;
        dist = 0 - dist;
    }

    delta = normalize(delta);
    next = delta * dist;
    full = color1;

    while (points > 0)
    {
        particle (end, delta, full, density);
        end = end + next;
        points = points - 1;
        if (full == color1)
            full = color2;
        else
            full = color1;
    }
};


// This creates a small particle trail behind the shot.
void(float rgb, float density, float full) Meteor_Trail =
{
    Particle_Beam (self.oldorigin, self.origin, rgb, rgb, density, full);
    self.oldorigin = self.origin;   // Update previous point.
};


void() YakStar_Think =
{
    if (self.frame < 11)
        Meteor_Trail (41, 2, TRUE);		// or traileffectnum
    else if (self.frame < 22)
        Meteor_Trail (105, 2, TRUE);		// or traileffectnum
    else
        Meteor_Trail (233, 2, TRUE);		// or traileffectnum

    if (self.delay <= time)
    {
	remove (self);
	return;
    }
    self.walkframe = self.walkframe + 1;
    if (self.walkframe > 5)
        self.walkframe = 0;
    self.frame = self.cnt + self.walkframe;
    self.nextthink = time + 0.05;
};


void(vector start, vector end, float sped) YakStar_Launch =
{
local vector dir;
    newmis = spawn ();
    newmis.owner = self;
    newmis.movetype = MOVETYPE_FLYMISSILE;
    newmis.solid = SOLID_BBOX;
    newmis.classname = "yakman_projectile";
    
    setmodel (newmis, "progs/s_kinn.spr");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);

// set missile speed
    dir = normalize (end - start);
    newmis.velocity = dir * sped;
    newmis.angles = vectoangles (newmis.velocity);

// set missile duration
    newmis.touch = YakStar_Touch;
    newmis.delay = time + 5;
    newmis.nextthink = 0.01;
    newmis.think = YakStar_Think;

    newmis.cnt = newmis.frame = self.yakman_particles * 11;
    newmis.walkframe = 0;
    newmis.oldorigin = start;    	// For proper particle trail drawing.   If no traileffectnum is used
};




void(vector left, vector right) yak_magic =
{
    local   vector  spot_right, spot_left;
    local   float   sped, zufall_right, zufall_left;

    zufall_right = 8 + (crandom() * 5);
    zufall_left = -8 + (crandom() * 5);
    sped = 1000;
    makevectors (self.enemy.v_angle);
    spot_right = self.enemy.origin + self.enemy.view_ofs + v_right * zufall_right + v_up * -24;   //  so that projectiles fly different paths (parallel)
    spot_left = self.enemy.origin + self.enemy.view_ofs + v_right * zufall_left + v_up * -24;     //  so that projectiles fly different paths (parallel)
    makevectors (self.angles);
    left = self.origin + (v_forward*left_x) + (v_right*left_y) + (v_up*left_z);
    right = self.origin + (v_forward*right_x) + (v_right*right_y) + (v_up*right_z);
    YakStar_Launch (left, spot_right, 1000);	// YakStar_Launch (left, dir, 1000);
    YakStar_Launch (right, spot_left, 1000);	// YakStar_Launch (right, dir, 1000);
};


void(vector left, vector right) yak_glitter =
{
    local   vector  up;

    up = '0 0 2';
    makevectors (self.angles);
    left = self.origin + (v_forward*left_x) + (v_right*left_y) + (v_up*left_z);
    right = self.origin + (v_forward*right_x) + (v_right*right_y) + (v_up*right_z);
    if (self.yakman_particles == 2)
    {
        particle (left, up, 233, 10);
        particle (right, up, 233, 10);
    }
    else if (self.yakman_particles == 1)
    {
        particle (left, up, 105, 10);
        particle (right, up, 105, 10);
    }
    else		
    {
        particle (left, up, 41, 5);
        particle (right, up, 41, 5);
        particle (left, up, 209, 5);
        particle (right, up, 209, 5);
    }
};

 
void() yakman_shard1  =[ $shard1,  yakman_shard2  ] {ai_face();sound7(self, CHAN_VOICE, "yakman/snort2.wav", 1, ATTN_NORM, SNDSPD);};
void() yakman_shard2  =[ $shard3,  yakman_shard3  ] {ai_face();};
void() yakman_shard3  =[ $shard5,  yakman_shard4  ] {ai_face();};
void() yakman_shard4  =[ $shard7,  yakman_shard5  ] {ai_face(); yak_glitter('6 -20 88', '-14 50 53');};
void() yakman_shard5  =[ $shard9,  yakman_shard6  ] {ai_face(); yak_glitter('-6 -41 78', '-18 48 70');};
void() yakman_shard6  =[ $shard11, yakman_shard7  ] {ai_face(); yak_glitter('8 -38 64', '-20 41 77');};
void() yakman_shard7  =[ $shard13, yakman_shard8  ] {ai_face(); yak_glitter('26 -22 52', '18 33 70');};
void() yakman_shard8  =[ $shard15, yakman_shard9  ] {ai_face(); yak_glitter('38 -9 48', '36 9 42');};
void() yakman_shard9  =[ $shard17, yakman_shard10 ] {ai_face();
    self.shots_max = self.shots_left = 3;
    sound7(self, CHAN_WEAPON, "yakman/firefblt.wav", 1, ATTN_NORM, SNDSPD);
    yak_magic('26 -5 50', '26 8 42');
};
void() yakman_shard10 =[ $shard19, yakman_shard11 ] {ai_face(); yak_magic('14 -1 54', '15 11 45');};
void() yakman_shard11 =[ $shard21, yakman_shard12 ] {ai_face(); yak_magic('26 -5 54', '26 10 45');};
void() yakman_shard12 =[ $shard23, yakman_shard13 ] {ai_face();
    if (skill >= 2)
        {yak_magic('38 -9 48', '36 9 42');}
};
void() yakman_shard13 =[ $shard25, yakman_shard14 ] {ai_face(); 
if (skill >= 2)
	self.attack_finished = time + 1 + random();
else
	self.attack_finished = time + 1.5 + random();};
void() yakman_shard14 =[ $shard27, yakman_shard15 ] {ai_face();};
void() yakman_shard15 =[ $shard29, yakman_shard16 ] {ai_face();};
void() yakman_shard16 =[ $shard31, yakman_run1    ] {ai_face();};


void() yakman_missile =
{
    self.encore = 0;    // Take our shot.

// Check for charge.
    if (time > self.waitmax)
    if (fabs(self.enemy.origin_z - self.origin_z) < 48)
    if (vlen(self.enemy.origin - self.origin) > 120)    //< 512)
    if (random() < 0.7)
    {
        self.waitmax = time + 6;   // Maximum time for charging.
        yakman_charge1 ();
        return;
    }

// Fling some magic.
    yakman_shard1 ();
};





////// Pain
void() yakman_pain1   =[ $pain1,   yakman_pain2   ] {self.nextthink = time + 0.08;};
void() yakman_pain2   =[ $pain2,   yakman_pain3   ] {self.nextthink = time + 0.08;};
void() yakman_pain3   =[ $pain3,   yakman_pain4   ] {self.nextthink = time + 0.08;};
void() yakman_pain4   =[ $pain4,   yakman_pain5   ] {self.nextthink = time + 0.08;};
void() yakman_pain5   =[ $pain5,   yakman_pain6   ] {self.nextthink = time + 0.1;};
void() yakman_pain6   =[ $pain6,   yakman_pain7   ] {self.nextthink = time + 0.08;};
void() yakman_pain7   =[ $pain7,   yakman_pain8   ] {self.nextthink = time + 0.08;};
void() yakman_pain8   =[ $pain8,   yakman_run1    ] {self.nextthink = time + 0.08;};
									

void() yakman_shake1  =[ $shake1,  yakman_shake2  ] {self.nextthink = time + 0.06;};
void() yakman_shake2  =[ $shake2,  yakman_shake3  ] {self.nextthink = time + 0.06;};
void() yakman_shake3  =[ $shake3,  yakman_shake4  ] {self.nextthink = time + 0.06;};
void() yakman_shake4  =[ $shake4,  yakman_shake5  ] {self.nextthink = time + 0.06;};
void() yakman_shake5  =[ $shake5,  yakman_shake6  ] {self.nextthink = time + 0.06;};
void() yakman_shake6  =[ $shake6,  yakman_shake7  ] {self.nextthink = time + 0.06;};
void() yakman_shake7  =[ $shake7,  yakman_shake8  ] {self.nextthink = time + 0.06;};
void() yakman_shake8  =[ $shake8,  yakman_shake9  ] {self.nextthink = time + 0.06;};
void() yakman_shake9  =[ $shake9,  yakman_shake10  ] {self.nextthink = time + 0.06;};
void() yakman_shake10  =[ $shake10,  yakman_shake11  ] {self.nextthink = time + 0.06;};
void() yakman_shake11  =[ $shake11,  yakman_shake12  ] {self.nextthink = time + 0.06;};
void() yakman_shake12  =[ $shake12,  yakman_shake13  ] {self.nextthink = time + 0.06;};
void() yakman_shake13  =[ $shake13,  yakman_shake14  ] {self.nextthink = time + 0.06;};
void() yakman_shake14  =[ $shake14,  yakman_shake15  ] {self.nextthink = time + 0.06;};
void() yakman_shake15  =[ $shake15,  yakman_shake16  ] {self.nextthink = time + 0.06;};
void() yakman_shake16  =[ $shake16,  yakman_shake17  ] {self.nextthink = time + 0.06;};
void() yakman_shake17  =[ $shake17,  yakman_shake18  ] {self.nextthink = time + 0.06;};
void() yakman_shake18  =[ $shake18,  yakman_shake19  ] {self.nextthink = time + 0.06;};
void() yakman_shake19  =[ $shake19,  yakman_shake20  ] {self.nextthink = time + 0.06;};
void() yakman_shake20  =[ $shake20,  yakman_run1     ] {self.nextthink = time + 0.06;};


void(entity attacker, float damage) yakman_pain =
{
    if (self.pain_finished > time)
        return;

      if (random()*200 > damage)
          return;     // didn't flinch

    self.walkframe = 0;
    if (random() < 0.5)
    {
        self.pain_finished = time + 2;
    	sound7(self, CHAN_VOICE, "yakman/pain.wav", 1, ATTN_NORM, SNDSPD);
        yakman_pain1 ();
    }
    else
    {   
        self.pain_finished = time + 3;
    	sound7(self, CHAN_VOICE, "yakman/big1.wav", 1, ATTN_NORM, SNDSPD);
        yakman_shake1 ();
    }
};




var float autocvar_yakmancorpsehealth = 60;	// set cvar 'yakmancorpsehealth' default to 60
									
void() yakman_die1  =[ $death1,   yakman_die2   ] {self.nextthink = time + 0.06;};
void() yakman_die2  =[ $death2,   yakman_die3   ] {self.nextthink = time + 0.06;};
void() yakman_die3  =[ $death3,   yakman_die4   ] {self.nextthink = time + 0.06; ai_forward(2);};
void() yakman_die4  =[ $death4,   yakman_die5   ] {self.nextthink = time + 0.06;};
void() yakman_die5  =[ $death5,   yakman_die6   ] {self.nextthink = time + 0.06; ai_forward(4);self.solid = SOLID_NOT;};
void() yakman_die6  =[ $death6,   yakman_die7   ] {self.nextthink = time + 0.06;};
void() yakman_die7  =[ $death7,   yakman_die8   ] {self.nextthink = time + 0.06; ai_forward(8);};
void() yakman_die8  =[ $death8,   yakman_die9   ] {self.nextthink = time + 0.06;};
void() yakman_die9  =[ $death9,   yakman_die10   ] {self.nextthink = time + 0.06; ai_forward(10);};
void() yakman_die10  =[ $death10,  yakman_die11   ] {self.nextthink = time + 0.06;};
void() yakman_die11  =[ $death11,  yakman_die12   ] {self.nextthink = time + 0.06; ai_forward(12);};
void() yakman_die12  =[ $death12,  yakman_die13   ] {self.nextthink = time + 0.06;};
void() yakman_die13  =[ $death13,  yakman_die14   ] {self.nextthink = time + 0.06; ai_forward(11);};
void() yakman_die14  =[ $death14,  yakman_die15   ] {self.nextthink = time + 0.06;};
void() yakman_die15  =[ $death15,  yakman_die16   ] {self.nextthink = time + 0.06; ai_forward(10);};
void() yakman_die16  =[ $death16,  yakman_die17   ] {self.nextthink = time + 0.06;};
void() yakman_die17  =[ $death17,  yakman_die18   ] {self.nextthink = time + 0.06;};
void() yakman_die18  =[ $death18,  yakman_die19   ] {self.nextthink = time + 0.06;};
void() yakman_die19  =[ $death19,  yakman_die20   ] {self.nextthink = time + 0.06;};
void() yakman_die20  =[ $death20,  yakman_die21   ] {self.nextthink = time + 0.06;};
void() yakman_die21  =[ $death21,  yakman_die22   ] {self.nextthink = time + 0.06;};
void() yakman_die22  =[ $death22,  yakman_die23   ] {self.nextthink = time + 0.06;};
void() yakman_die23  =[ $death23,  yakman_die24   ] {self.nextthink = time + 0.06;
pointparticles (particleeffectnum("shambler_falling_dust"), self.origin, '0 0 0', 1);
Monster_Animation_EarthQuake (20, 377);
sound7(self, CHAN_AUTO, "shambler/fall.wav", 1, ATTN_NORM, SNDSPD);
};
void() yakman_die24  =[ $death24,  yakman_die25   ] {self.nextthink = time + 0.06;};
void() yakman_die25  =[ $death25,  yakman_die25   ] {
self.delete_painskin = 1;		 	// remove painskin
CopyMonsterToBodyQue(autocvar_yakmancorpsehealth, "progs/h_yak.mdl");
};



void()	yakman_lightning_death =[ $pain5, yakman_lightning_death1 ] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	yakman_lightning_death1 =[ $pain5, yakman_lightning_death1 ] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
CopyMonsterToBodyQue(1, "progs/h_yak.mdl");
};


///////  Death
void() yakman_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))		// when enemy was killed with lightning gun, go into baked mode
		{
			yakman_lightning_death();
			return;
		}
	}
	else if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
	{
		lg_death1();
		return;
	}

// check for gib
	if (self.health < -70)
	{
		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_yakman * 0.01))
			{
				the_matrix = 1;
				SNDSPD = 70;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
		play_gibsound();
		
		//5 randomized blood droplets that drip if stuck to the ceiling
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		
		
		ThrowHead ("progs/h_yak.mdl", self.health);
		ThrowGib ("progs/gib_minoclaw1.mdl", self.health);
		ThrowGib ("progs/gib_minoleg1.mdl", self.health);
		ThrowGib ("progs/gib_minoclaw2.mdl", self.health);
		ThrowGib ("progs/gib_minoleg2.mdl", self.health);
		ThrowGib ("progs/gib_4.mdl", self.health);
		if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
			ThrowHeart ("progs/gibheart.mdl", self.health);
		gibdeath_effects();
		
		return;
	}

// regular death
	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_yakman * 0.01))
		{
			the_matrix = 1;
			SNDSPD = 70;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
		}
	}

	if (random() < 0.3)
		sound7(self, CHAN_VOICE, "yakman/death.wav", 1, ATTN_NORM, SNDSPD);
	else
		sound7(self, CHAN_VOICE, "yakman/die.wav", 1, ATTN_NORM, SNDSPD);
	
	yakman_die1();
};





//============
// --> QUAKED monster_yakman (1 0 0) (-32 -32 -24) (32 32 64) Ambush Boss
//============

void() monster_yakman =
{
	self.classname = "monster_yakman";
	if (deathmatch)
	{
		remove(self);
		return;
	}
/*  precache_model ("progs/yakman.mdl");	// all files precached in worldspawn() due to savegame-bug
    precache_model ("progs/h_yak.mdl");
    precache_model ("progs/s_kinn.spr");

    precache_sound("yakman/woosh.wav");
    precache_sound("yakman/big1.wav");
    precache_sound("yakman/big3.wav");
    precache_sound("yakman/grunt.wav");
    precache_sound("yakman/snort1.wav");
    precache_sound("yakman/snort2.wav");
    precache_sound("yakman/crash.wav");
    precache_sound("yakman/death.wav");
    precache_sound("yakman/die.wav");
    precache_sound("yakman/expsmall.wav");
    precache_sound("yakman/firefblt.wav");
    precache_sound("yakman/pain.wav");
    precache_sound("yakman/slam.wav");
    precache_sound("yakman/step1.wav");
    precache_sound("yakman/step2.wav");
    precache_sound("shambler/fall.wav");	// use shambler fall sound
*/

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/yakman.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (!self.health)
		self.health = autocvar_yakman_health;		// default: 555
	self.health_initial = self.health;

	self.scale = 1;
	self.alpha = 1;
	self.colormod = '1 1 1';
	self.painskin_helper = 3;			// "3" means yakman (needed for painskin feature)
	
	self.netname = "monster_yakman";

	if (autocvar_yakman_skin_selection == 1)
	{
		self.skin = 0;
		self.yakman_particles = 0;
	}
	else if (autocvar_yakman_skin_selection == 2)
	{
		self.skin = 1;
		self.yakman_particles = 1;
	}
	else if (autocvar_yakman_skin_selection == 3)
	{
		self.skin = 2;
		self.yakman_particles = 2;
	}
	else if (autocvar_yakman_skin_selection == 4)
	{
		self.skin = 3;
		self.yakman_particles = 1;
	}
	else if (autocvar_yakman_skin_selection == 5)
	{
		self.skin = 4;
		self.yakman_particles = 0;
	}
	else 
	{
		local float skinner;
		skinner = random();
		if (skinner < 0.2)
		{
			self.skin = 0;
			self.yakman_particles = 0;
		}
		else if (skinner < 0.4)
		{
			self.skin = 1;
			self.yakman_particles = 1;
		}
		else if (skinner < 0.6)
		{
			self.skin = 2;
			self.yakman_particles = 2;
		}
		else if (skinner < 0.8)
		{
			self.skin = 3;
			self.yakman_particles = 1;
		}
		else 
		{
			self.skin = 4;
			self.yakman_particles = 0;
		}
	}

	self.th_stand = yakman_stand1;
	self.th_walk = yakman_walk1;
	self.th_run = yakman_run1;
	self.th_melee = yakman_melee;
	self.th_missile = yakman_missile;
	self.th_pain = yakman_pain;
	self.th_die = yakman_die;

	if (autocvar_painskin_transparency)
	{
		entity pain_skin_entity;

		pain_skin_entity = spawn();
		pain_skin_entity.solid = SOLID_NOT;
		pain_skin_entity.movetype = MOVETYPE_NOCLIP;	
		pain_skin_entity.owner = self;
		setmodel (pain_skin_entity,self.model);
		setsize (pain_skin_entity, VEC_HULL2_MIN, VEC_HULL2_MAX);	
		setorigin (pain_skin_entity, '0 0 0');
		pain_skin_entity.skin = self.skin;
		pain_skin_entity.colormod_x = self.colormod_x;
		pain_skin_entity.colormod_y = self.colormod_y;
		pain_skin_entity.colormod_z = self.colormod_z;
		pain_skin_entity.monstermodel = self.monstermodel;
		pain_skin_entity.frame = self.frame;	
		pain_skin_entity.alpha = autocvar_painskin_transparency;
		pain_skin_entity.think = pain_skin_entity_think;
		pain_skin_entity.nextthink = time;

		setattachment(pain_skin_entity, self, "test");	
	}

	walkmonster_start();

var float autocvar_yakmanmass = 3500;
MonsterPhysics (self, autocvar_yakmanmass);	
};

void() monster_minotaur =
{
	self.classname = "monster_yakman";
	monster_yakman();
}

void() monster_yakman_start =
{
	local entity clone;
	self.scale = 1;
	clone = spawn();
	copyentity (self,clone);
	clone.think = monster_yakman;
	clone.nextthink = time + 0.0001;
};



