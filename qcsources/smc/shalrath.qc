/*
==============================================================================

SHAL-RATH

==============================================================================
*/
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5 

$frame death1 death2 death3 death4 death5 death6 death7

$frame	walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame	walk11 walk12


void() shalrath_pain;
void() ShalMissile;
void() shal_run1;
void() shal_upatt;
void() shal_flipdown;
void() shal_attack1;
void() shalrath_die;
void() shal_stand;
void() shal_walk1;
void() shal_death7;
void() shal_stand_ceiling_map_start;

.float nojump;
.float speed_reducer;
.float shalrath_residence_time;
.float shalrath_residence;
.float shalrath_just_jumped_or_dropped;
.float shalrath_jumped_ceiling_at_map_start;
.float shalrath_checked_ceiling_at_map_start;
.float afrit_supports_me;


float() shal_checkroof =
{
	local vector end;
	local float contents, num;
	end = self.origin + '0 0 1000';
	traceline(self.origin, end, TRUE, self);
	contents = pointcontents(trace_endpos);
	end = trace_endpos;
	num = end_z - self.origin_z;
	if (num < (autocvar_shalrath_free_space_limit_for_jumping + 20))	// 222  // 300
	    return 0;
	if (contents == CONTENT_SKY) 
	    return 0;
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, end);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
			return 0;
	}
	if (trace_fraction == 1.0) 
	    return 0;
	else
	    return 1;
};


float() shal_clearance =
{
	local vector end, end1, end2;
	local float end_true, end1_true, end2_true;
	makevectors (self.angles);
	end = self.origin;							// check multiple positions to better check complete bbox	
	end_z = end_z + autocvar_shalrath_free_space_limit_for_jumping;		// 200  //250
	end1 = self.origin + v_forward * 33;					// check multiple positions to better check complete bbox
	end1_z = end1_z + autocvar_shalrath_free_space_limit_for_jumping;	// 200  // 250
	end2 = self.origin + v_forward * -33;					// check multiple positions to better check complete bbox
	end2_z = end2_z + autocvar_shalrath_free_space_limit_for_jumping;	// 200  // 250
	traceline(self.origin, end, TRUE, self);
	if (trace_fraction == 1.0)
		end_true = 1;
	traceline(self.origin, end1, TRUE, self);
	if (trace_fraction == 1.0)
		end1_true = 1;
	traceline(self.origin, end2, TRUE, self);
	if (trace_fraction == 1.0)
		end2_true = 1;
	if ((end_true == 1) && (end1_true == 1) && (end2_true == 1))
	    return 1;
	else
	    return 0;
};


float() shal_nosky =
{
	local vector end;
	local float surfacenum;
	local string tex;
	end = self.origin + '0 0 200';
	traceline(self.origin, end, TRUE, self);
	surfacenum = getsurfacenearpoint(world, trace_endpos);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
			return 1;
	}
	if (pointcontents(trace_endpos) == CONTENT_SKY) 
	    return 1;
	else
	    return 0;
};



void() shal_updie     =[      $death1,       shal_updie2    ] {
self.movetype = MOVETYPE_STEP;
if (self.health < -90) 		// gibbed
{
	shalrath_die();
	return;
}
self.angles_z = 150;
sound(self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
self.solid = SOLID_NOT;};
void() shal_updie2     =[      $death2,       shal_updie3    ] {ai_face();self.angles_z = 120;};
void() shal_updie3     =[      $death3,       shal_updie4    ] {ai_face();self.angles_z = 90;};
void() shal_updie4     =[      $death4,       shal_updie5    ] {ai_face();self.angles_z = 60;};
void() shal_updie5     =[      $death5,       shal_updie6    ] {ai_face();self.angles_z = 30;};
void() shal_updie6     =[      $death6,       shal_updie7    ] {ai_face();self.angles_z = 0;};
void() shal_updie7     =[      $death7,       shal_updie7    ] {self.angles_z = 0;
shal_death7 (); 	// to do after death animations and make corpses gibbable
return;};



void() shal_uppain =
{
	if (self.pain_finished > time)
		return;

	if (autocvar_shalrath_pain_drop_down_from_ceiling)
	{
		if ((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER) || (self.enemy.weapon == IT_LIGHTNING))
			shal_flipdown ();
	}
	else
		shal_flipdown ();

	sound(self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	self.pain_finished = time + 1.5;
};


void() shal_reaching =
{
if (self.nojump == -1) 
{
	self.th_stand = shal_flipdown;
	self.th_walk = shal_flipdown;
	self.th_pain = shal_uppain;
	self.th_run = shal_upatt;
	self.th_missile = shal_upatt;
	self.th_die = shal_updie;
	shal_upatt();
	return;
}
if (self.velocity_z < 100) 
{
	shal_flipdown();
	return;
}
	self.think = shal_reaching;
	self.nextthink = time + 0.1;
	ai_face();
};


void() shal_reaching_map_start =
{
if (self.nojump == -1) 
{
	self.th_stand = shal_stand_ceiling_map_start;
	self.th_walk = shal_flipdown;
	self.th_pain = shal_uppain;
	self.th_run = shal_upatt;
	self.th_missile = shal_upatt;
	self.th_die = shal_updie;
	shal_stand_ceiling_map_start();
	return;
}
if (self.velocity_z < 100) 
{
	shal_flipdown();
	return;
}
	self.think = shal_reaching_map_start;
	self.nextthink = time + 0.1;
};


void() shal_flipdown2 =
{
if (self.angles_z <= 0)
{
	if (self.enemy != world) 
	{
		self.angles_z = 0;
  		shal_run1();
		return;
	}
	else
	{
		self.angles_z = 0;
		shal_stand();
		return;
	}
}
	self.angles_z = self.angles_z - 30;
	self.think = shal_flipdown2;
	self.nextthink = time + 0.1;
};

void() shal_flipdown =
{
	self.shalrath_just_jumped_or_dropped = time + 3;	// do not jump to ceiling too often
	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;
	self.think = shal_flipdown2;
	self.nextthink = time + 0.03;
};


void() shal_flipup =
{
	if (self.angles_z >= 180)
	{
		self.angles_z = 180;
		shal_reaching();
		return;
	}
	self.think = shal_flipup;
	self.nextthink = time + 0.1;

	self.angles_z = self.angles_z + 30;
	ai_face();
	self.velocity_z = 666;
	if (self.angles_z == 90) 
		sound(self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);	
};


void() shal_flipup_map_start =
{
	if (self.angles_z >= 180)
	{
		self.angles_z = 180;
		shal_reaching_map_start();
		return;
	}
	self.think = shal_flipup_map_start;
	self.nextthink = time + 0.1;

	self.angles_z = self.angles_z + 30;
	self.velocity_z = 666;
};


void() shal_grabroof =
{
	if (other.takedamage || other.health) 
		return;
	self.nojump = -1;
	self.touch = SUB_Null;
	self.velocity = '0 0 0';	// to reduce ceiling sliding when ceiling is uneven
};



void() shal_upidle =
{
	if ((self.shalrath_residence_time < time) && (self.shalrath_residence == 1))	// flip down if enemy is too long out of sight
	{
		self.shalrath_residence = 0;
		shal_flipdown();
		return;
	}
	if (self.enemy) 
	{
		if (visible(self.enemy)) 
		{
			self.shalrath_residence = 0;
			shal_upatt();
			return;
		}
		else if (self.shalrath_residence == 0)
		{
			self.shalrath_residence_time = time + autocvar_shalrath_hanging_no_enemy_in_sight_time;
			self.shalrath_residence = 1;
		}
	}
	else
		ai_stand();

	if (shal_nosky()) 
	{
		self.shalrath_residence = 0;
		shal_flipdown();
		return;
	}
	self.frame = $walk1;
	self.think = shal_upidle;
	self.nextthink = time + 0.02;		// use high frequence to reduce flickering (moving up and down in low frequence)

	if (self.flags & FL_ONGROUND) 
	{
		self.origin_z = self.origin_z + 1;
		self.flags = self.flags - FL_ONGROUND;
	}
	self.velocity_x = 0;			// to reduce ceiling sliding when ceiling is uneven
	self.velocity_y = 0;			// to reduce ceiling sliding when ceiling is uneven
	self.velocity_z = 500;
	if (self.th_stand != shal_flipdown) 
	{
		self.th_stand = shal_flipdown;
		self.th_walk = shal_flipdown;
	}
};


void() shal_stand_ceiling_map_start = [ $walk1, shal_stand_ceiling_map_start]{ ai_stand(); self.nextthink = time + 0.02;	// use high frequence to reduce flickering (moving up and down in low frequence)
	if (shal_nosky()) 
	{
		shal_flipdown();
		return;
	}
	if (self.flags & FL_ONGROUND) 
	{
		self.origin_z = self.origin_z + 1;
		self.flags = self.flags - FL_ONGROUND;
	}
	self.velocity_x = 0;			// to reduce ceiling sliding when ceiling is uneven
	self.velocity_y = 0;			// to reduce ceiling sliding when ceiling is uneven
	self.velocity_z = 500;
};


void() shal_upatt =
{
	self.speed_reducer = self.speed_reducer + 1;		// needed to keep shalrath on ceiling, but avoid up/down flickering. Use only every 5th frame to do actions, but use every frame to keep it on the ceiling
	if ((self.walkframe >= 10) && (self.speed_reducer == 4))
		self.walkframe = 0;
	if ((self.enemy.health < 1) && (self.speed_reducer == 4))
	{
		self.enemy = world;
		self.th_stand();
		return;
	}
	if ((!visible(self.enemy)) && (self.speed_reducer == 4))
	{
		self.frame = $walk1;
		shal_upidle();
		return;
	}
	if ((shal_nosky()) && (self.speed_reducer == 4))
	{
		shal_flipdown();
		return;
	}

	self.think = shal_upatt;
	self.nextthink = time + 0.02;		// use high frequence to reduce flickering (moving up and down in low frequence)

	if (self.speed_reducer == 4)
	{	
		self.frame = $attack1 + self.walkframe;
		self.walkframe = self.walkframe + 1;
		ai_face();
	}
	self.velocity_x = 0;			// to reduce ceiling sliding when ceiling is uneven
	self.velocity_y = 0;			// to reduce ceiling sliding when ceiling is uneven
	self.velocity_z = 500;			// to keep shalrath on ceiling
	if ((self.enemy == world) && (self.speed_reducer >= 4))
	{
		shal_flipdown();
		return;
	}
	if ((visible(self.enemy)) && (self.speed_reducer == 4))
	{
		if (self.walkframe == 4) 
			sound(self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
		if (self.walkframe == 8)
			ShalMissile();
	}
	if (self.speed_reducer > 4)
		self.speed_reducer = 0;
};



void() shal_jump =
{
	if (self.walkframe >= 10) 
	{
		self.walkframe = 0;
		if (visible(self.enemy)) 
		{
			shal_attack1();
			return;
		}
		shal_run1();
		return;
	}
	self.think = shal_jump;
	self.nextthink = time + 0.1;

	self.frame = $attack1 + self.walkframe;
	self.walkframe = self.walkframe + 1;
	ai_face();
	if (self.walkframe == 4)
		sound(self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
	if (self.walkframe == 8) 
		ShalMissile();
};



void() shal_bounce     =[      $attack10,       shal_bounce1    ] {ai_face();};
void() shal_bounce1    =[      $attack10,       shal_bounce2    ] {ai_face();};
void() shal_bounce2    =[      $attack11,       shal_bounce3    ] {ai_face();};
void() shal_bounce3    =[      $pain5,       shal_bounce4    ] {ai_face();};
void() shal_bounce4    =[      $pain4,       shal_jump    ] {ai_face();
self.walkframe = 0;
if (self.flags & FL_ONGROUND) 
{
	self.flags = self.flags - FL_ONGROUND;
	self.origin_z = self.origin_z + 1;
	self.velocity_z = 666;
}
local float shalrath_hanging;
shalrath_hanging = autocvar_shalrath_hanging_on_ceiling_chance * 0.01;
if (random() < shalrath_hanging)	 
{
	if (shal_checkroof()) 	
	{
		self.frame = $death1;
		self.touch = shal_grabroof;
		self.origin_z = self.origin_z + 1;
		self.angles_z = 0;
		shal_flipup();	
		return;
	}
}
};



void(float loudness) shalrath_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.5)
		sound(self, CHAN_AUTO, "walk/shalrath1.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/shalrath2.wav", loudness, ATTN_IDLE);
	}
};


void() shal_stand     =[      $walk1,       shal_stand    ] {ai_stand();
local float shalrath_map_start_ceiling;
shalrath_map_start_ceiling = autocvar_shalrath_hanging_on_ceiling_on_map_start_chance * 0.01;
if ((!self.shalrath_checked_ceiling_at_map_start) && (!self.afrit_supports_me) && (self.shalrath_jumped_ceiling_at_map_start == 0) && (autocvar_shalrath_hanging_on_ceiling_chance) && (random() < shalrath_map_start_ceiling))
{
	if (shal_clearance())
	{
		if (shal_checkroof())
		{
			if (self.flags & FL_ONGROUND) 
			{
				self.flags = self.flags - FL_ONGROUND;
				self.origin_z = self.origin_z + 1;
				self.velocity_z = 666;
			}
			self.shalrath_jumped_ceiling_at_map_start = 1;
			self.frame = $death1;
			self.touch = shal_grabroof;
			self.origin_z = self.origin_z + 1;
			self.angles_z = 0;
			shal_flipup_map_start();	
			return;
		}
	}
}
self.shalrath_checked_ceiling_at_map_start = 1;
};

void() shal_walk1     =[      $walk2,       shal_walk2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_walk(6);};
void() shal_walk2     =[      $walk3,       shal_walk3    ] {ai_walk(4);};
void() shal_walk3     =[      $walk4,       shal_walk4    ] {ai_walk(0); shalrath_footsteps (1);};
void() shal_walk4     =[      $walk5,       shal_walk5    ] {ai_walk(0);};
void() shal_walk5     =[      $walk6,       shal_walk6    ] {ai_walk(0);};
void() shal_walk6     =[      $walk7,       shal_walk7    ] {ai_walk(0);};
void() shal_walk7     =[      $walk8,       shal_walk8    ] {ai_walk(5);};
void() shal_walk8     =[      $walk9,       shal_walk9    ] {ai_walk(6);};
void() shal_walk9     =[      $walk10,       shal_walk10    ] {ai_walk(5); shalrath_footsteps (1);};
void() shal_walk10    =[      $walk11,       shal_walk11    ] {ai_walk(0);};
void() shal_walk11    =[      $walk12,       shal_walk12    ] {ai_walk(4);};
void() shal_walk12    =[      $walk1,       shal_walk1    ] {ai_walk(5);};

void() shal_run1     =[      $walk2,       shal_run2    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
self.angles_z = 0;
local float shalrath_jumping;
shalrath_jumping = autocvar_shalrath_jumping_chance * 0.01;
if ((visible(self.enemy)) && (random() < shalrath_jumping) && (self.shalrath_just_jumped_or_dropped < time))	
{
	self.shalrath_just_jumped_or_dropped = time + 3;	// do not jump too often
    	if (self.nojump < 1) 
	{
      		if (shal_clearance()) 	
		{
		        shal_bounce();	
		        return;
	        }
      	}
}
ai_run(6);};
void() shal_run2     =[      $walk3,       shal_run3    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_run(4);};
void() shal_run3     =[      $walk4,       shal_run4    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0); shalrath_footsteps (1);};
void() shal_run4     =[      $walk5,       shal_run5    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() shal_run5     =[      $walk6,       shal_run6    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() shal_run6     =[      $walk7,       shal_run7    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() shal_run7     =[      $walk8,       shal_run8    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(5);};
void() shal_run8     =[      $walk9,       shal_run9    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(6);};
void() shal_run9     =[      $walk10,       shal_run10    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(5); shalrath_footsteps (1);};
void() shal_run10    =[      $walk11,       shal_run11    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() shal_run11    =[      $walk12,       shal_run12    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(4);};
void() shal_run12    =[      $walk1,       shal_run1    ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(5);};

void() shal_run_frantically1     =[      $walk2,       shal_run_frantically2    ] {self.nextthink = (time + 0.03); movetogoal(8);};
void() shal_run_frantically2     =[      $walk3,       shal_run_frantically3    ] {self.nextthink = (time + 0.03);movetogoal(6);};
void() shal_run_frantically3     =[      $walk4,       shal_run_frantically4    ] {self.nextthink = (time + 0.03);movetogoal(2); shalrath_footsteps (1);};
void() shal_run_frantically4     =[      $walk5,       shal_run_frantically5    ] {self.nextthink = (time + 0.03);movetogoal(1);
if ((self.cnt == 0) || (self.cnt == 3))
	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);};
void() shal_run_frantically5     =[      $walk6,       shal_run_frantically6    ] {self.nextthink = (time + 0.03);movetogoal(1);};
void() shal_run_frantically6     =[      $walk7,       shal_run_frantically7    ] {self.nextthink = (time + 0.03);movetogoal(2);};
void() shal_run_frantically7     =[      $walk8,       shal_run_frantically8    ] {self.nextthink = (time + 0.03);movetogoal(7);};
void() shal_run_frantically8     =[      $walk9,       shal_run_frantically9    ] {self.nextthink = (time + 0.03);movetogoal(8);};
void() shal_run_frantically9     =[      $walk10,      shal_run_frantically10   ] {self.nextthink = (time + 0.03);movetogoal(7); shalrath_footsteps (1);};
void() shal_run_frantically10    =[      $walk11,      shal_run_frantically11   ] {self.nextthink = (time + 0.03);movetogoal(2);};
void() shal_run_frantically11    =[      $walk12,      shal_run_frantically12   ] {self.nextthink = (time + 0.03);movetogoal(6);};
void() shal_run_frantically12    =[      $walk1,       shal_run_frantically1    ] {self.nextthink = (time + 0.03);movetogoal(7);
self.cnt = self.cnt + 1;
if ((vlen(self.origin - self.enemy.origin) < 300) || (self.cnt >= 5))
{
	self.cnt = 0;
	shal_run1 ();
	return;
}
};

void() shal_attack1     =[      $attack1,       shal_attack2    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
local float shalrath_running_frantically;
shalrath_running_frantically = autocvar_shalrath_runs_frantically_towards_player * 0.01;
if ((random() < shalrath_running_frantically) && (vlen(self.origin - self.enemy.origin) > 377))
{
	shal_run_frantically1();
	return;
}
sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
ai_face();
};
void() shal_attack2     =[      $attack2,       shal_attack3    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack3     =[      $attack3,       shal_attack4    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack4     =[      $attack4,       shal_attack5    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack5     =[      $attack5,       shal_attack6    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack6     =[      $attack6,       shal_attack7    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack7     =[      $attack7,       shal_attack8    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack8     =[      $attack8,       shal_attack9    ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack9     =[      $attack9,       shal_attack10   ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ShalMissile();};
void() shal_attack10    =[      $attack10,      shal_attack11   ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() shal_attack11    =[      $attack11,      shal_run1   ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};

void() shal_pain1       =[      $pain1, shal_pain2      ] {};
void() shal_pain2       =[      $pain2, shal_pain3      ] {};
void() shal_pain3       =[      $pain3, shal_pain4      ] {};
void() shal_pain4       =[      $pain4, shal_pain5      ] {};
void() shal_pain5       =[      $pain5, shal_run1      ] {};



void() shal_dieburn1	=[	$death1,	shal_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() shal_dieburn2	=[	$death2,	shal_dieburn3	] {self.burnz_origin = 10;
};
void() shal_dieburn3	=[	$death3,	shal_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() shal_dieburn4	=[	$death4,	shal_dieburn5	] {self.burnz_origin = 3;
};
void() shal_dieburn5	=[	$death5,	shal_dieburn6	] {self.burnz_origin = -1;
};
void() shal_dieburn6	=[	$death6,	shal_dieburn7	] {self.burnz_origin = -3;
};
void() shal_dieburn7	=[	$death7,	shal_dieburn7	] {self.burnz_origin = -7;
};


var float autocvar_shalrath = 5;     		// set cvar 'shalrath' default to 5
var float autocvar_shalrathcorpsehealth = 60;	// set cvar 'shalrathcorpsehealth' default to 60
var float autocvar_shalrathcorpseburnable = 0;	// set cvar 'shalrathcorpseburnable' default to 0

void() shal_death1      =[      $death1,        shal_death2     ] {self.angles_z = 0;};
void() shal_death2      =[      $death2,        shal_death3     ] {};
void() shal_death3      =[      $death3,        shal_death4     ] {};
void() shal_death4      =[      $death4,        shal_death5     ] {};
void() shal_death5      =[      $death5,        shal_death6     ] {};
void() shal_death6      =[      $death6,        shal_death7     ] {};
void() shal_death7      =[      $death7,        shal_death7     ] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 30;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_shalrathcorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'shalrathcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_shalrathcorpsehealth, "progs/h_shal.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_shalrathcorpsehealth, "progs/h_shal1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'shalrath' has been declared in code above already
	var float autocvar_shalrathrandomness = 30;     	// set cvar 'shalrathrandomness' default to 30%
	autocvar_shalrathrandomness = autocvar_shalrathrandomness * 0.01;
	if (autocvar_shalrath == 1)		// if 'shalrath' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_shalrathrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_shalrath == 2)	// if 'shalrath' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_shalrathrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/shalrath.mdl", $death7, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/shalrath1.mdl", $death7, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_shalrath == 3)	// if 'shalrath' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_shalrathrandomness)	// checks if death animation shall be started
			vengeance_shalrath ("progs/shalrath.mdl", $death7);
		}
	else if (autocvar_shalrath == 5)	// if 'shalrath' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_shalrathrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/shalrath.mdl", $death7, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/shalrath1.mdl", $death7, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_shalrath ("progs/shalrath.mdl", $death7);
			}
		}
	else				// if 'shalrath' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.monstermodel == 0)  
			soul ("progs/shalrath.mdl", $death7, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/shalrath1.mdl", $death7, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_shalrath ("progs/shalrath.mdl", $death7);
	}
};



void() shalrath_pain =
{
	if (self.pain_finished > time)
		return;
		
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_shalrath * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
	shal_pain1();
	self.pain_finished = time + 3;
};



void(float maxgibs, float gibscounter) producegibs_shalrath =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);   	
	}

gibscounter = gibscounter + 1;
producegibs_shalrath (maxgibs, gibscounter);
};


void()	shalrath_lightning_death	=[	$attack8,	shalrath_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	shalrath_lightning_death1	=[	$attack8,	shalrath_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_shal.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_shal1.mdl");
};


void() shalrath_die;
void() shal_inflamed13;

void() shal_inflamed1 =[ $walk2, shal_inflamed2    ] {ai_run_inflamed(8); self.nextthink = time + 0.06;
if (random() < 0.75)
	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
};
void() shal_inflamed2 =[ $walk3, shal_inflamed3    ] {ai_run_inflamed(6); self.nextthink = time + 0.06;};
void() shal_inflamed3 =[ $walk4, shal_inflamed4    ] {ai_run_inflamed(1); shalrath_footsteps (1); self.nextthink = time + 0.06;};
void() shal_inflamed4 =[ $walk5, shal_inflamed5    ] {ai_run_inflamed(1); self.nextthink = time + 0.06;};
void() shal_inflamed5 =[ $walk6, shal_inflamed6    ] {ai_run_inflamed(1); self.nextthink = time + 0.06;};
void() shal_inflamed6 =[ $walk7, shal_inflamed7    ] {ai_run_inflamed(1); self.nextthink = time + 0.06;};
void() shal_inflamed7 =[ $walk8, shal_inflamed8    ] {ai_run_inflamed(7); self.nextthink = time + 0.06;};
void() shal_inflamed8 =[ $walk9, shal_inflamed9    ] {ai_run_inflamed(8); self.nextthink = time + 0.06;};
void() shal_inflamed9 =[ $walk10, shal_inflamed10    ] {ai_run_inflamed(7); shalrath_footsteps (1); self.nextthink = time + 0.06;};
void() shal_inflamed10 =[ $walk11, shal_inflamed11    ] {ai_run_inflamed(1); self.nextthink = time + 0.06;};
void() shal_inflamed11 =[ $walk12, shal_inflamed12    ] {ai_run_inflamed(6); self.nextthink = time + 0.06;
if (self.inflametime < time)
{
	shalrath_die ();
	return;
}
if (random() < 0.65)
	shal_inflamed13 ();	// start pain anim
};
void() shal_inflamed12 =[ $walk1,  shal_inflamed1    ] {ai_run_inflamed(5); self.nextthink = time + 0.06;};

void() shal_inflamed13 =[ $pain1, shal_inflamed14      ] { self.nextthink = time + 0.09;
if (random() < 0.8)
	sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);
};
void() shal_inflamed14 =[ $pain2, shal_inflamed15      ] { self.nextthink = time + 0.09;};
void() shal_inflamed15 =[ $pain3, shal_inflamed16      ] { self.nextthink = time + 0.09;};
void() shal_inflamed16 =[ $pain4, shal_inflamed17      ] { self.nextthink = time + 0.09;};
void() shal_inflamed17 =[ $pain5, shal_inflamed12      ] { self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	shalrath_die ();
	return;
}
};




void() shalrath_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			shalrath_lightning_death();
			return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -90)
	{
		if ((!cvar("chase_active")) && (self.enemy.classname == "player") && (autocvar_HUD_blood_splatter))	// we are in 1st person mode
		{
			if (vlen (self.enemy.origin - self.origin) < autocvar_HUD_blood_splatter)
				blood_HUD_splat = 1;
		}

		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_shalrath * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				self.angles_z = 0;	// be sure headgib has correct angle, even when gibbed on ceiling
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_shal.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_shal1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				self.angles_z = 0;	// be sure headgib has correct angle, even when gibbed on ceiling
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_shal.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_shal1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_shalrath (maxgibs, gibscounter);
				return;
				}
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0)		// enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER))	// when enemy was killed with explosives, set it on fire
			{
				self.delete_painskin = 1;	// remove painskin
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				shal_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
			shal_death1();
			self.solid = SOLID_NOT;
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'shalrath' has been declared in code above already
var float autocvar_shalrathrandomness = 30;     	// set cvar 'shalrathrandomness' default to 30%
autocvar_shalrathrandomness = autocvar_shalrathrandomness * 0.01;
if (autocvar_shalrath == 4)		// if 'shalrath' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_shalrathrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		shal_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_shalrath == 6)		// if 'shalrath' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_shalrathrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			shal_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'shalrath' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_shalrath * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
	shal_death1();
	self.solid = SOLID_NOT;
	// insert death sounds here
};



/*
================
ShalMissile
================
*/
void() ShalMissileTouch;
void() ShalHome;

void() shalrath_homing_teleport =		//  Teleport missile to a slightly other position near its origin  (harder to hit)
{
local vector spot, vec;

// Select teleport destination within a specified radius.
	spot = self.origin + (randomvec() * autocvar_shalrath_shootable_missile_teleporting);	// default: 50
	vec = normalize(spot - self.origin);
	traceline (self.origin, spot, TRUE, self);	// look through monsters
	spot = trace_endpos - vec*13;

// Check for walls and obstacles.
	if (PM_InWall(self, spot))
		return;
	if (!PM_TraceCheck(self, spot))
		return;

// Check if target is not blocked.
	traceline (spot, self.enemy.origin, FALSE, self);
	if (trace_fraction < 1.0)
		if (trace_ent != self.enemy)
			return;

// Teleport and face opponent!
	setorigin (self, spot);
//	self.angles_y = vectoyaw(self.enemy.origin - spot);
};

void() shalrath_homing_pain =
{
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 0.5;
	sound (self, CHAN_VOICE, "warlord/homing_pain.wav", 1, ATTN_NORM);
	if (autocvar_shalrath_shootable_missile_teleporting)
		shalrath_homing_teleport ();
};

void() shalrath_homing_death =
{
	pointparticles(particleeffectnum("voreball_explosion"), self.origin, '0 0 0', 1);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	remove (self);
};

void() ShalMissile =
{
	local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;	
	setmodel (missile, "progs/v_spike.mdl");

	if (autocvar_shalrath_shootable_missile)
	{		
		setsize (missile, '-8 -8 -8', '8 8 8');
		missile.movetype = MOVETYPE_NOCLIP;	// only temporary to move outside of body (see below)
		missile.classname = "ShalrathMissile";
		missile.health = autocvar_shalrath_shootable_missile_health;	// default: 30
		missile.takedamage = DAMAGE_AIM;
		missile.th_pain = shalrath_homing_pain;
		missile.th_die = shalrath_homing_death;
		missile.nextthink = time + 0.3;		// to move completely out of shalraths model (to avoid getting stuck)
	}
	else
	{
		missile.movetype = MOVETYPE_FLYMISSILE;
		setsize (missile, '0 0 0', '0 0 0');
		missile.nextthink = flytime + time;
	}

	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.think = ShalHome;
	missile.enemy = self.enemy;
	missile.touch = ShalMissileTouch;
};

void() ShalHome =
{
	local vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	self.movetype = MOVETYPE_FLYMISSILE;
	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}

	if (self.origin == self.old_origin)				// when it got stuck, remove it
	{
//		T_RadiusDamage (self, self.owner, autocvar_shalrath_missile, self.owner);
		sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
		pointparticles(particleeffectnum("voreball_explosion"), self.origin, '0 0 0', 1);
		remove (self);
		return;
	}
	self.old_origin = self.origin;

	dir = normalize(vtemp - self.origin);
	if (skill == 3)
		self.velocity = dir * 350;
	else
		self.velocity = dir * 250;
	self.nextthink = time + 0.2;
	self.think = ShalHome;	
};

var float autocvar_shalrath_size_influenced_attack = 0; 	// set cvar 'shalrath_size_influenced_attack' default to 0

void() ShalMissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (((other.model == "progs/spike.mdl") || (other.model == "progs/s_spike.mdl") || (other.model == "progs/grenade.mdl") || (other.model == "progs/missile.mdl")))
		return;		// don't explode on projectiles

	if (other.classname == "monster_zombie")
		T_Damage (other, self, self, 110);	
	if (autocvar_shalrath_shootable_missile)
	{
		if (autocvar_shalrath_size_influenced_attack == 1)		// if 'shalrath_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
			T_Damage (other, self, self.owner, (autocvar_shalrath_missile-7) * self.owner.scale);	// default 40
		else
			T_Damage (other, self, self.owner, autocvar_shalrath_missile-7);		// default 40
	}
	else
	{
		if (autocvar_shalrath_size_influenced_attack == 1)		// if 'shalrath_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
			T_RadiusDamage (self, self.owner, autocvar_shalrath_missile * self.owner.scale, world);  // default 40
		else
			T_RadiusDamage (self, self.owner, autocvar_shalrath_missile, world);		// default 40
	}
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
pointparticles(particleeffectnum("voreball_explosion"), self.origin, '0 0 0', 1);
remove(self);

/*
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
*/
};

//=================================================================

/*QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void() monster_shalrath =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");
	
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");
	precache_sound ("walk/shalrath1.wav");
	precache_sound ("walk/shalrath2.wav");
	precache_sound ("warlord/homing_pain.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_shalrathmultiskin = 0;     	// set cvar 'shalrathmultiskin' default to 0
	local float zufall;
	if (autocvar_shalrathmultiskin == 1)		// if 'shalrathmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/shalrath.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
	}
	else if (autocvar_shalrathmultiskin == 2)	// if 'shalrathmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/shalrath1.mdl");
		precache_model ("progs/h_shal1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/shalrath.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/shalrath1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_shalrathmultiskin == 3)	// if 'shalrathmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/shalrath1.mdl");
		precache_model ("progs/h_shal1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/shalrath.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/shalrath.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/shalrath1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_shalrathmultiskin == 4)	// if 'shalrathmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/shalrath1.mdl");
		precache_model ("progs/h_shal1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/shalrath.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/shalrath.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/shalrath1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/shalrath1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/shalrath.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}
	
var float autocvar_shalrath_size = 2;     		// set cvar 'shalrath_size' default to 2
	local float zuffa;
	if (autocvar_shalrath_size == 1)		// if 'shalrath_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shalrath_size == 2)		// if 'shalrath_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shalrath_size == 3)		// if 'shalrath_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			self.sizediff = '0 0 7';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shalrath_size == 4)		// if 'shalrath_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			self.sizediff = '0 0 9';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			self.sizediff = '0 0 7';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_shalrath_size > 4)		// if 'shalrath_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_shalrath_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_shalrath_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_shalrath_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	}

var float autocvar_shalrath_size_influenced_health = 0; 		// set cvar 'shalrath_size_influenced_health' default to 0
	if (autocvar_shalrath_size_influenced_health == 1)		// if 'shalrath_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_shalrath_health * self.scale;	// default 400
	else
		self.health = autocvar_shalrath_health; 		// default 400
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_shalrath_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
	{												// limit values to avoid extreme colors
		self.colormod_x = random ();
		if (self.colormod_x < 0.5)
			self.colormod_x = self.colormod_x + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_x < 0.75)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_x < 0.65)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_x < 0.55)
				self.colormod_x = self.colormod_x + 0.25;
		}
		self.colormod_y = random ();
		if (self.colormod_y < 0.5)
			self.colormod_y = self.colormod_y + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_y < 0.75)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_y < 0.65)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_y < 0.55)
				self.colormod_y = self.colormod_y + 0.25;
		}
		self.colormod_z = random ();
		if (self.colormod_z < 0.5)
			self.colormod_z = self.colormod_z + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_z < 0.75)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_z < 0.65)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_z < 0.55)
				self.colormod_z = self.colormod_z + 0.25;
		}
	}

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;

	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_carnivean_replace_shalrath)	// if shalrath shall be replaced by Carnivean. Check the chance and do it !!)
		{	
		local float replacerr;		
		replacerr = autocvar_carnivean_replace_shalrath * 0.01;
		if (random () <= replacerr)
			{
			self.health = autocvar_shalrath_health;		// default 400
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_carnivean_start();
			return;
			}
		}

	if (autocvar_yakman_replace_shalrath)		// if shalrath shall be replaced by Yakman. Check the chance and do it !!)
		{	
		local float replacerrr;		
		replacerrr = autocvar_yakman_replace_shalrath * 0.01;
		if (random () <= replacerrr)
			{
			self.health = autocvar_shalrath_health;		// default 400
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_yakman_start();
			return;
			}
		}

	if (autocvar_spider_replace_shalrath)		// if shalrath shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_shalrath * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 2;
				self.health = autocvar_shalrath_health; 	// default 400
				self.scale = 1;
				setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_shalrath)		// if shalrath shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_shalrath * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_shalrath_health; 	// default 400
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_shalrath)		// if shalrath shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_shalrath * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_shalrath_health; 	// default 400
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}
		
	if (autocvar_shalrath_hanging_on_ceiling_chance) 	// when shalrath "hanging on ceiling" feature is enabled, reduce bbox height to so that shalrath´s feet really touch the ceiling and not float with a big gap beneath it.
	{							// For real-model-closer-fit-to-ceiling sake.  ATTENTION: bbox widths MUST be max 16. Otherwise bbox will not touch ceiling and gap is there again !
		if (self.sizediff_z == 0)		// regular size
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 35' - self.sizediff);
		if (self.sizediff_z < 2)		// approx. 7% bigger
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 38' - self.sizediff);
		else if (self.sizediff_z < 4)		// approx. 14% bigger
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 42' - self.sizediff);
		else if (self.sizediff_z < 6)		// approx. 21% bigger
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 46' - self.sizediff);
		else if (self.sizediff_z < 8)		// approx. 28% bigger
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 50' - self.sizediff);
		else if (self.sizediff_z < 10)		// approx. 35% bigger
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 54' - self.sizediff);
		else 					
			setsize (self, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);	// if bigger than 35%, keep original bbox size
	}

	if (autocvar_painskin_transparency)
	{
		entity pain_skin_entity;

		pain_skin_entity = spawn();
		pain_skin_entity.solid = SOLID_NOT;
		pain_skin_entity.movetype = MOVETYPE_NOCLIP;	
		pain_skin_entity.owner = self;
		setmodel (pain_skin_entity,self.model);
		setsize (pain_skin_entity, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);	
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

	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random ()*0.1;	

do_the_cloning();

if (autocvar_reiver_supports_shalrath)		// if reiver shall be spawned in ADDITION to an existing shalrath. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_shalrath * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_shalrath)		// if afrit shall be spawned in ADDITION to an existing shalrath. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_shalrath * 0.01;
	if (random () <= replace)
		{
		self.afrit_supports_me = 1;
		add_afrit_support_walk ();
		}
	}

var float autocvar_shalrathmass = 2200;
MonsterPhysics (self, autocvar_shalrathmass);
};


///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////  below code added by Seven  //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/*
==============================================================================

Creates "Vengeance of the deceased" effect.    

Modelname and Modelframe is taken from call after regular death animations:    
void(string modelname, float modelframe) vengeance;
Example: 
vengeance ("progs/soldier.mdl", $death10);

This function must be declared at the end of defs.qc:
void(string modelname, float modelframe) vengeance_shalrath; 

==============================================================================
*/


void() vengeance_shalrath_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_shalrath_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg); 	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;				// um nicht endlos damage zu kriegen !

	self.think = vengeance_shalrath_end1; 
	self.nextthink = time + 0.1;   
};


void() vengeance_shalrath_skull =			//  calls skull in skull.qc   
{
	local	vector	offang, org;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;   
	org_z = org_z + 4;   		 // to adjust spawning coordinate of skull. Depending on the monster it spawnes.

	launch_vengeance_skull (org); 	
	newmis.classname = "skull";
	setmodel (newmis, "progs/skull.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	

	newmis.scale = 0.9;		//  set size of the skull here.  Depending on the monster it spawnes. 

	precache_sound ("vengeance/skull.wav");	
	precache_sound ("vengeance/skulltouch.wav"); 
};


										//  from here on: run sequence. 

void() vengeance_shalrath_run1 =[	$walk1,	vengeance_shalrath_run2 ]   {
	ai_face();
 	movetogoal (16);  // orig(6)
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_run2 =[	$walk2,	vengeance_shalrath_run3 ]   {
	ai_face();
 	movetogoal (14);  // orig(4)
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.35;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_run3 =[	$walk3,	vengeance_shalrath_run4 ]    {
	ai_face();
 	movetogoal (10);  // orig(0)
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_run4 =[	$walk4,	vengeance_shalrath_run5 ]    {
	ai_face();
 	movetogoal (10);  // orig(0)
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_run5 =[	$walk5,	vengeance_shalrath_attack1 ]    {
// sound (self, CHAN_VOICE, "shalrath/attack.wav", 4, ATTN_NORM);
	ai_face();
 	movetogoal (10);   // orig(0)
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


										//  from here on: magic attack sequenz. 

void() vengeance_shalrath_attack1 =[ $attack1,	vengeance_shalrath_attack2 ]    {
sound (self, CHAN_VOICE, "vengeance/shalthrow.wav", 1, ATTN_NORM);
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack2 =[ $attack2,	vengeance_shalrath_attack3 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack3 =[ $attack3,	vengeance_shalrath_attack4 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack4 =[ $attack4,	vengeance_shalrath_attack5 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack5 =[ $attack5,	vengeance_shalrath_attack6 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack6 =[ $attack6,	vengeance_shalrath_attack7 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack7 =[ $attack7,	vengeance_shalrath_attack8 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath_attack8 =[ $attack8,	vengeance_shalrath_end1 ]    {
	ai_face();
self.touch = vengeance_shalrath_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_shalrath_skull();	
};



//  from here on: ressurection sequenz. ATTENTION: Damit es flüssig aussieht evtl. noch anderen frame vor RUN einfügen.

void() vengeance_shalrath1 =[	$death6,	vengeance_shalrath2 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath2 =[	$death5,	vengeance_shalrath3 	]  {
sound (self, CHAN_WEAPON, "shalrath/sight.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath3 =[	$death4,	vengeance_shalrath4 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath4 =[	$death3,	vengeance_shalrath5 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath5 =[	$death2,	vengeance_shalrath6 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_shalrath6 =[	$death1,	vengeance_shalrath_run1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_shalrath_bright05	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = vengeance_shalrath1;
};
void()	vengeance_shalrath_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_shalrath_bright05;
};
void()	vengeance_shalrath_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_shalrath_bright04;
};
void()	vengeance_shalrath_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_shalrath_bright03;
}; 
void()	vengeance_shalrath_bright01	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_shalrath_bright02;
};
void()	vengeance_shalrath_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_shalrath_bright01;
};



void(string modelname, float modelframe) vengeance_shalrath =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_sound ("vengeance/shalthrow.wav");  	// precached in worldspawn() due to savegame-bug
//	precache_model ("progs/skull.mdl");		// precached in worldspawn() due to savegame-bug

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/shalrath.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/shalrath1.mdl"); 

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  // if value is NOT "0", player get hurt from this effect (see func "vengeance_shalrath_touch")!

	vengeance_shalrath_bright00 ();	 // starts the animation
};

