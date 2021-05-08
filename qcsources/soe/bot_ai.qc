/***********************************************
*                                              *
*            FrikBot Generalt AI               *
*     "The I'd rather be playing Quake AI"     *
*                                              *
***********************************************/





/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

The new [old] bot targeting stuff. Completely reworked
from scratch, ALMOST the same functionality.

Sigh, I remember when this was a small little function

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() bot_check_lost =
{
	local vector test;
	test = self.goalentity.origin;
	if (test == '0 0 0')
		test = (self.goalentity.absmin + self.goalentity.absmax * 0.5);
	test = test - self.origin;
	if (self.goalentity.classname == "temp_waypoint")
	{
		
		if (vlen(self.goalentity.origin - self.origin) < 50)
		{ 
			self.goalentity.search_time = time + 2;
			self.goalentity = world;
		}
		else if (time > self.search_time)
		{
			self.goalentity.search_time = time + 10;
			self.goalentity = world;
		}
		else if (time < self.teleport_time)
		{
			self.goalentity.search_time = time + 10;
			self.goalentity = world;
		}
		else if (test_z > 64)
		{
			test_z = 0;
			if (vlen(test) <= 48)
			{
				self.goalentity.search_time = time + 10;
				self.goalentity = world;
			}
		}
		return;
	}
	else if ((self.enemy.health <= 0) && (self.enemy != world))
	{
		self.goalentity = world;
		self.enemy = world;
		return;
	}
	else if (!fisible(self.goalentity))
	{
		
		if (self.goalentity.classname != "player")
		{
			self.goalentity.search_time = time + 15;
			self.goalentity = world;
		}
		else if (self.goalentity.health > 0)
			SpawnTempWaypoint(self.ldest1, 34);
		self.enemy = world;
		return;
	}
	else if (self.enemy != world)
		return; // Attacking this target, if it's still visible,
	if (test_z > 64)
	{
		test_z = 0;
		if (vlen(test) <= 48)
		{
			self.goalentity.search_time = time + 10;
			self.goalentity = world;
			return;
		} // if we were smart, we'd jump or rocket jump here
	}
	if (self.goalentity.classname == "func_button")
	{
		if (self.goalentity.state != 1)
		{
			self.goalentity.search_time = time + 6;
			self.goalentity = world;
			return;
		}
	}
	if (time > self.search_time) 
	{
		self.goalentity.search_time = time + 30;
		self.goalentity.priority = self.goalentity.priority - 1;
		self.goalentity = world;
		self.chat_subj = 1;
		self.chat_time = time + 1;
	}
	else if (vlen(self.goalentity.origin - self.origin) < 50)
	{ 
		if (self.goalentity.classname == "waypoint")
			WaypointPriority(self.goalentity);
		self.goalentity.search_time = time + 10;
		self.goalentity = world;
	}
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bot Priority Look. What a stupid name. This is where
the bot finds things it wants to kill/grab.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

float(entity thing) priority_for_thing =
{
	local float thisp;
	thisp = 0;
	// This is the most executed function in the bot. Careful what you do here.

	// This was one of the major lag causes in 0.07, aside from norse.
	// it's current format is pretty effcient, but it could be better

	if ((thing.flags & FL_ITEM) && thing.model != string_null && thing.search_time < time)
		thisp = 20;
	else if ((thing.solid == SOLID_BSP) && (thing.health > 0))
		thisp = 20;
	if ((thing.flags & FL_MONSTER) && thing.health > 0)
	{
		if (thing.classname == "monster_dragon" && thing.master.team == self.team)
			thisp = 0;
		else
			thisp = 35;
	}
	else if (thing.classname == "player")
	{ 
		if (deathmatch && thing.health > 0)
		{
			thisp = 45;
		
			if (thing == self)
				thisp = 0;
			else
			{
				if ((!fov(thing)) && (thing.f_sound < time))
					thisp = 5;
				if (thing.items & IT_INVISIBILITY)
					thisp = 2;
				if (thing.netname == "observer")
					thisp = 0;
				else if (teamplay && thing.team == self.team)
					thisp = 0;
				else if (coop)
					thisp = 0;
			}
		}
	}
	else if (thing.classname == "waypoint")
	{ 
		if(thing.search_time < time)
			thisp = 10;
	}
	else if (thing.classname == "temp_waypoint")
	{
		if ((thing.goalentity == self) && thing.search_time < time)
			thisp = 1;
	}
	else if (thing.classname == "item_artifact_super_damage")
	{
		if (thing.model != string_null && thing.search_time < time)
			thisp = 50;
	}
	else if (thing.classname == "item_artifact_invulnerability")
	{
		if (thing.model != string_null && thing.search_time < time)
			thisp = 50;
	}
	else if (thing.classname == "func_button")
	{
		if ((thing.state == 1) && (thing.search_time < time))
			thisp = 30;
	}
	else if ((thing.classname == "trigger_teleport") || (thing.classname == "trigger_push"))
	{
		if (thing.search_time < time)
			thisp = 20;
	}

	if (thisp)
	{
		thisp = thisp + thing.priority;
		if (!(fisible(thing)))
			thisp = 0;
	}
	if (thing.priority > 0)
		thing.priority = 0;

	return thisp;

};
void() bot_priority_look =
{
	local entity foe, best;
	local float thatp, bestp, dist;

	foe = findradius(self.origin, 800);
	bestp = 1;
	while(foe)
	{
		
		thatp = priority_for_thing(foe);
		if (thatp > bestp)
		{
			bestp = thatp;
			best = foe;
			dist = vlen(self.origin - foe.origin);
		} else if (thatp == bestp)
		{
			if (vlen(self.origin - foe.origin) < dist)
			{
				bestp = thatp;
				best = foe;
				dist = vlen(self.origin - foe.origin);
			}
		}
		foe = foe.chain;

	}

	if ((self.goalentity != best) && ((self.goalentity == world) || (bestp > 30)))
	{
		self.goalentity = best;
		self.search_time = time + 6;
	}

	if ((self.goalentity.takedamage) && (self.goalentity.health > 0))
		self.enemy = self.goalentity;
	else
		self.enemy = world; 
};


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bot_fight_style, bots select an attack style
for their current weapon

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() BotShoot = // quick little function to stop making him shoot the wrong way ! Argh

{
	local float g;
	g = angcomp(self.v_angle_x, self.b_angle_x);
	if (fabs(g) > 30)
		return; // argh, too far away
	g = angcomp(self.v_angle_y, self.b_angle_y);
	if (fabs(g) > 30)
		return; // not again!
	self.button0 = TRUE;
};
void() switch_to_close_wep =
{
	if (random() < 0.2)
	{
	 	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && self.items & 64)
			self.impulse = 8; 
		else if (self.ammo_nails >= 2 && self.items & 8)
			self.impulse = 5;
	}
};
void() bot_fight_style =
{
	local vector holly, strafe;
	local float fightstyle;
	self.ldest1 = self.enemy.origin;

	// Implemented fight styles
	// ========================
	// 0: Run in, attack all the way (Frikbot 0.01 thru 0.03 behavior)
	// 1: Maintain a distance between 200 and 550 units, 
	//    attack in that range and further away(rocket, grenade)
	// 2: Maintain a distance between 150 and 250 units, strafe from 
	//	side to side. Attack always (nailgun, SNG and LG)
	// 3: Same as 1, except jump randomly

	if (self.weapon == 4) // IT_NAILGUN
		fightstyle = 2;
	else if (self.weapon == 8) // IT_SUPER_NAILGUN
		fightstyle = 2;
	else if (self.weapon == 16) // IT_GRENADE_LAUNCHER
		fightstyle = 1;
	else if (self.weapon == 32) // IT_ROCKET_LAUNCHER
		fightstyle = 3;
	else if (self.weapon == 64) // IT_LIGHTNING
		fightstyle = 2;
	else
		fightstyle = 0;

	self.button0 = FALSE;
	holly = (self.enemy.absmin + self.enemy.absmax) * 0.5;
	if (fightstyle == 0) // Basic fight style, move in while shooting
	{
		traceline(self.origin + self.view_ofs, holly, FALSE, self);
		if ((trace_fraction == 1) || (trace_ent == self.enemy))
		{
			frik_movetogoal();
			BotShoot();
		}
		else 
		{
			holly = normalize(holly - self.origin);
			strafe_x = holly_y * -1;
			strafe_y = holly_x;
			if (self.wallhug == 90)
				strafe = strafe * -1;

			frik_walkmove(strafe);

			if (random() <= 0.05)
				if (self.wallhug == 90)
					self.wallhug = -90;
				else self.wallhug = 90;

		}
	} else
	if (fightstyle == 1) // stay between 200 and 550 units away and shoot (grenade)
	{
		if (vlen(holly - self.origin) < 180)
		{
			strafe = normalize(self.origin - holly);
			frik_walkmove(strafe);

			switch_to_close_wep();
			if (self.search_time < time + 4)
				BotShoot(); // screw it
                } else if (vlen(holly - self.origin) > 450)
                {
			BotShoot();
			frik_movetogoal();
		} else
			BotShoot();
	} else
	if (fightstyle == 2)
	{
		BotShoot();
                if (vlen(holly - self.origin) < 150)
		    {
			strafe = normalize(self.origin - holly);
			frik_walkmove(strafe);
                } else if (vlen(holly - self.origin) > 250)
                {
			frik_movetogoal();
		    } else
		    {
			holly = normalize(holly - self.origin);
			strafe_x = holly_y * -1;
			strafe_y = holly_x;
			if (self.wallhug == 90)
				strafe = strafe * -1;
			
			frik_walkmove(strafe);

			if (random() <= 0.05)
				if (self.wallhug == 90)
					self.wallhug = -90;
				else self.wallhug = 90;

		    }
      } else 
	if (fightstyle == 3) // stay between 200 and 550 units away and shoot (rocket)
	{
                if (vlen(self.enemy.origin - self.origin) < 180)
		{
			strafe = normalize(self.origin - holly);
			frik_walkmove(strafe);
			switch_to_close_wep();
			if (self.search_time < time + 4)
				BotShoot(); // screw it
                } else if (vlen(self.enemy.origin - self.origin) > 450)
                {
			BotShoot();
			frik_movetogoal();
		} else
			BotShoot();
		if (random() < 0.2)
			if (random() < 0.2)
				self.button2 = TRUE;
	} 

};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

The new "hook" method of navigation. This nav
system is copyrighted 1999 by Ryan "Frika C" 
Smith, keep that in mind when you steal it.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() frik_bot_roam =
{
	local vector org, ang, org1;
	local float loopcount, flag;
	if (self.temp_way != world)
		if (self.temp_way.search_time > time)
			return;

	loopcount = 26;
	flag = FALSE;
	while(loopcount > 0)
	{
		loopcount = loopcount - 1;
		if (flag != TRUE)
		{
			org = self.origin + self.view_ofs;
			ang = self.angles;
			ang_y = anglemod(ang_y - 90 + (random() * 180));
			ang_x = 0; // avoid upward sloping
			makevectors(ang);
			traceline(org, org + v_forward * 2300, TRUE, self);
			if (trace_fraction != 1)
			{
				org1 = trace_endpos;
				ang = normalize(trace_plane_normal);
				ang_z = 0; // avoid upward sloping
				traceline(org1, org1 + (ang * 2300), TRUE, self);
				if ((trace_fraction != 1) && (vlen(trace_endpos - org1) >= 64))
				{
					org = trace_endpos;
					traceline(org, self.origin + self.view_ofs, TRUE, self);
					if (trace_fraction != 1)
					{
						flag = vlen(org1 - org) /2;
						org = org1 + (ang * flag);
						traceline(org, org - '0 0 48', TRUE, self);
						if (trace_fraction != 1)
						{
							SpawnTempWaypoint(org, 18);
							flag = TRUE;
						}
					}
				}
			}
		}
	}
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

The traditional bot roaming code.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() frika_move =
{
	local float frik_test;

	frik_test = frik_walkmove(v_forward);

	if (random() <= 0.02)
		if (random() <= 0.05)
			frik_test = FALSE;

	if (frik_test)
		return;
	else
		self.b_angle_y = anglemod(self.b_angle_y + (self.wallhug / 3));
	self.b_angle_x = 0;

	if (random() <= 0.02)
		if (self.wallhug == 90)
			self.wallhug = -90;
		else self.wallhug = 90;

};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bot Impulse stuff. This code causes the bot to
try to select a weapon based on what he sees
on the statusbar.

You might want to edit or remove this function
if the bot does stupid things or never selects a
new weapon you put in.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

float() BotImpulse =
{
	local	float	it;
	
	it = self.items;
	if ((self.ammo_rockets >= 1) && (it & 32)) // IT_ROCKET_LAUNCHER
		return 7;
	else if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & 64) ) // IT_LIGHTNING
		return 8;
	else if(self.ammo_nails >= 2 && (it & 8) ) // IT_SUPER_NAILGUN
		return 5;
	else if ((self.ammo_rockets >= 1) && (it & 16)) // IT_GRENADE_LAUNCHER
		return 6;
	else if(self.ammo_shells >= 2 && (it & 2) ) // IT_SUPER_SHOTGUN
		return 3;
	else if(self.ammo_nails >= 1 && (it & 4) ) // IT_NAILGUN
		return 4;
	else if(self.ammo_shells >= 1 && (it & 2) ) // IT_SHOTGUN
		return 2;
	else return 0;
};




/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

bot_angle_set

Same name, relatively different thing. Now it's main purpose
is to just set the bot's keys to look at things. Mostly the same
code though. Just thought you'd like to know.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/


void() bot_angle_set =
{

	local float h;
	local vector view;
	
	if (self.goalentity != world)
	{
		if (self.enemy != world)
		{
			if (self.missile_speed == 0)
				self.missile_speed = 1000;
			h = vlen(self.enemy.origin - self.origin) / self.missile_speed;
			view = self.enemy.velocity * h;
			view = self.enemy.origin + view;
			view = normalize(view - self.origin);
			if (self.enemy.origin == '0 0 0')
				view = (((self.enemy.absmin + self.enemy.absmax) * 0.5) - self.origin);
			view = vectoangles(view);
			view_x = view_x * -1;
			self.b_angle = view;
		} else {
			view = self.goalentity.origin;
			if (view == '0 0 0')
				view = (self.goalentity.absmin + self.goalentity.absmax) * 0.5;
			if (self.goalentity.flags & FL_ITEM)
				view = view + '0 0 48';
			view = view - (self.origin + self.view_ofs);
			self.b_angle = vectoangles(view);
			self.b_angle_x = self.b_angle_x * -1;
		}
	}
	else
		self.b_angle_x = 0;

	if (self.b_angle_x > 180)
		self.b_angle_x = self.b_angle_x - 360;
	self.keys = self.keys - (self.keys & (KEY_LOOKLEFT + KEY_LOOKRIGHT + KEY_LOOKUP + KEY_LOOKDOWN));

	if (angcomp(self.b_angle_y, self.v_angle_y) > 10)
		self.keys = self.keys | KEY_LOOKLEFT;
	if (angcomp(self.b_angle_y, self.v_angle_y) < -10)
		self.keys = self.keys | KEY_LOOKRIGHT;
	if (angcomp(self.b_angle_x, self.v_angle_x) < -10)
		self.keys = self.keys | KEY_LOOKUP;
	if (angcomp(self.b_angle_x, self.v_angle_x) > 10)
		self.keys = self.keys | KEY_LOOKDOWN;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

BotAI, this is the core of the bots functioning.
This is where the bot makes all decisiions.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
float stagger_think;

void() BotAI =
{
	if (self.ai_time > time)
		return;
	self.ai_time = time + 0.05;
	if ((time - stagger_think) < (0.1 / BOT_COUNT))
		self.ai_time = self.ai_time + 0.1 / (2 * BOT_COUNT);
	stagger_think = time;
	self.button2 = 0;

	if (self.health <= 0)
	{ // if I am dead, blink the fire button till I respawn (hack)
                self.button0 = floor(random() * 2);
		    self.button1 = 0;
		    self.button2 = 0;
			self.keys = 0;
		    self.goalentity = self.enemy = world;
	}
	else 
	{

		bot_priority_look();
		if (self.attack_finished < time) 
			if (random() < 0.2)
				self.impulse = BotImpulse();
		if (self.goalentity != world)
		{
			bot_check_lost();
			if ((self.enemy != world) && (self.enemy.health > 0))
				bot_fight_style();
			else
			{
				frik_movetogoal();
				self.button0 = FALSE;
			}
		}
		else 
		{
			self.button0 = FALSE;
			frik_bot_roam();
                	frika_move();
		}
		if (time > (self.air_finished - 2) && self.waterlevel > 2)
  		{
   	 	// checks to see if bot needs to start going up for air
      		traceline (self.origin, self.origin + '0 0 6800', TRUE, self);
			if (trace_inopen)	
			{
				self.keys = KEY_LOOKUP | KEY_MOVEFORWARD;
				self.button2 = TRUE; // swim!
				if (self.tfrags != self.frags)
					DoFragUpdate();
				BotChat();
				return;
			}
   	  	}
		bot_angle_set();

	}

	if (self.tfrags != self.frags)
		DoFragUpdate();
	BotChat();
};

