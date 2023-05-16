//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: FrikBot X by Ryan "FrikaC" Smith
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
// Entity count: 
// Function count: 
//
// Implements: FrikBot Misc
//
// Description:
// 
//=============================================================================

/***********************************************
*                                              *
*              FrikBot Misc Code               *
*   "Because you can't name it anything else"  *
*                                              *
***********************************************/

/*
This program is in the Public Domain. My crack legal
team would like to add:

RYAN "FRIKAC" SMITH IS PROVIDING THIS SOFTWARE "AS IS"
AND MAKES NO WARRANTY, EXPRESS OR IMPLIED, AS TO THE
ACCURACY, CAPABILITY, EFFICIENCY, MERCHANTABILITY, OR
FUNCTIONING OF THIS SOFTWARE AND/OR DOCUMENTATION. IN
NO EVENT WILL RYAN "FRIKAC" SMITH BE LIABLE FOR ANY
GENERAL, CONSEQUENTIAL, INDIRECT, INCIDENTAL,
EXEMPLARY, OR SPECIAL DAMAGES, EVEN IF RYAN "FRIKAC"
SMITH HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES, IRRESPECTIVE OF THE CAUSE OF SUCH DAMAGES. 

You accept this software on the condition that you
indemnify and hold harmless Ryan "FrikaC" Smith from
any and all liability or damages to third parties,
including attorney fees, court costs, and other
related costs and expenses, arising out of your use
of this software irrespective of the cause of said
liability. 

The export from the United States or the subsequent
reexport of this software is subject to compliance
with United States export control and munitions
control restrictions. You agree that in the event you
seek to export this software, you assume full
responsibility for obtaining all necessary export
licenses and approvals and for assuring compliance
with applicable reexport restrictions. 

Any reproduction of this software must contain
this notice in its entirety. 

*/

// Sets bot's name and colors to a preset.
string(float r) BotName = {
	self.b_num = r;
	if (r == 1) {	
		self.b_pants = 11;
		self.b_shirt = 0;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Vincent";
	} else if (r == 2) {
		self.b_pants = 1;
		self.b_shirt = 3;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Bishop";
	} else if (r == 3) {	
		self.b_pants = 13;
		self.b_shirt = 2;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Nomad";
	} else if (r == 4) {
		self.b_pants = 7;
		self.b_shirt = 6;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Hudson";
	} else if (r == 5) {
		self.b_pants = 12;
		self.b_shirt = 6;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Lore";
	} else if (r == 6) {
		self.b_pants = 4;
		self.b_shirt = 4;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Servo";
	} else if (r == 7) {
		self.b_pants = 2;
		self.b_shirt = 5;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Gort";
	} else if (r == 8) {	
		self.b_pants = 10;
		self.b_shirt = 3;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Kryten";
	} else if (r == 9) {
		self.b_pants = 9;
		self.b_shirt = 4;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Pimp Bot";
	} else if (r == 10) {
		self.b_pants = 4;
		self.b_shirt = 7;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Max";
	} else if (r == 11) {
		self.b_pants = 3;
		self.b_shirt = 11;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Marvin";
	} else if (r == 12) {
		self.b_pants = 13;
		self.b_shirt = 12;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Erwin";
	} else if (r == 13) {
		self.b_pants = 11;
		self.b_shirt = 2;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "FrikBot";
	} else if (r == 14) {
		self.b_pants = 0;
		self.b_shirt = 2;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Krosis";
	} else if (r == 15) {
		self.b_pants = 8;
		self.b_shirt = 9;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Gypsy";
	} else if (r == 16) {
		self.b_pants = 5;
		self.b_shirt = 10;
		// DRS: Weapon Preference / accuracy stuffs
		self.weap_acc1 = '0 0 0'; // Axe, Shotgun, Super Shotgun
		self.weap_acc2 = '0 0 0'; // Nailgun, Super Nailgun, GL
		self.weap_acc3 = '0 0 0'; // Rocket Launcher, LG, ???
		self.b_fav_weapon = IT_ROCKET_LAUNCHER;
		// ~ end Weapon Preference / accuracy stuffs
		return "Hal";
	}
};

string () PickARandomName = {
	local float y, test;
	local string h;
	local entity t;

	if (bot_count > 16) return "frikbot";

	y = TRUE;
	while(y) {
		test = ceil(random() * 16);
		h = BotName(test);
		t = find(world, netname, h);
		if (t == world) y = FALSE;
	}
	return h;
};

// I didn't like the old code so this is very stripped down

entity b_originator;
float b_topic;
/* FBX Topics

b_originator == self
 1 - sign on
 2 - killed targ
 3 - team message "friendly eyes"
 4 - team message "on your back"
 5 - team message "need back up"
 6 - excuses
 ----
 7 - gameover
 ----
 8 - welcoming someone onto server
 9 - ridicule lost frag (killed self?)
 10 - ridicule lost frag (lava)
 11 - lag
b_originator == targ

 
*/
void(float tpic) bot_start_topic = {
	if (random() < 0.2) {
		b_topic = tpic;
		b_originator = self;
	} else b_topic = 0;
};

void() bot_chat = {
	local float r;

	if (b_options & OPT_NOCHAT) return;

	r = ceil (random() * 6);
	if (self.b_chattime > time) {
		if (self.b_skill < 2) self.keys = self.button0 = self.button2 = 0;
		return;
	} else if (self.b_chattime) {
		if (b_topic == 1) {
			if (b_originator == self) {
				if (r == 1) {
					BotSay(": lo all\n");
					bot_start_topic(8);
				} else if (r == 2) {
					BotSay(": hey everyone\n");
					bot_start_topic(8);
				}
				else if (r == 3)
				{
					BotSay(": prepare to be fragged!\n");
					bot_start_topic(0);
				}
				else if (r == 4)
				{
					BotSay(": boy this is laggy\n");
					bot_start_topic(11);
				}
				else if (r == 5)
				{
					BotSay(": #mm getting some lag here\n");
					bot_start_topic(11);
				}
				else
				{
					BotSay(": hi everyone\n");
					bot_start_topic(8);
				}
			}
		}
		else if (b_topic == 2)
		{
			if (b_originator == self)
			{
				if (r == 1)
					BotSay(": take that\n");
				else if (r == 2)
					BotSay(": yehaww!\n");
				else if (r == 3)
					BotSay(": wh00p\n");
				else if (r == 4)
					BotSay(": j00_sawk();\n");
				else if (r == 5)
					BotSay(": i rule\n");
				else
					BotSay(": eat that\n");
				bot_start_topic(0);
			}
		}
		else if (b_topic == 3)
		{
			if (b_originator == self)
			{
				if (r < 3)
					BotSayTeam(": friendly eyes\n");
				else
					BotSayTeam(": team eyes\n");
				bot_start_topic(0);
			}
		}
		else if (b_topic == 4)
		{
			if (b_originator == self)
			{
				if (r < 3)
					BotSayTeam(": on your back\n");
				else
					BotSayTeam(": I'm with you\n");
				bot_start_topic(0);
			}
		}
		else if (b_topic == 5)
		{
			if (b_originator == self)
			{
				if (r < 3)
					BotSayTeam(": I need help\n");
				else
					BotSayTeam(": need backup\n");
				bot_start_topic(0);
			}
		}
		else if (b_topic == 6)
		{
			if (b_originator == self)
			{
				if (r == 1)
				{
					BotSay(": sun got in my eyes\n");
					bot_start_topic(0);
				}
				else if (r == 2)
				{
					BotSay(": mouse needs cleaning\n");
					bot_start_topic(0);
				}
				else if (r == 3)
				{
					BotSay(": i meant to do that\n");
					bot_start_topic(0);
				}
				else if (r == 4)
				{
					BotSay(": lag\n");
					bot_start_topic(11);
				}
				else if (r == 5)
				{
					BotSay(": killer lag\n");
					bot_start_topic(11);
				}
				else
				{
					BotSay(": 100% lag\n");
					bot_start_topic(11);
				}
			}
		}
		else if (b_topic == 7)
		{
			if (r == 1)
				BotSay(": gg\n");
			else if (r == 2)
				BotSay(": gg all\n");
			else if (r == 3)
				BotSay(": that was fun\n");
			else if (r == 4)
				BotSay(": good game\n");
			else if (r == 5)
				BotSay(": pah\n");
			else
				BotSay(": hrm\n");
			bot_start_topic(0);
		}
		else if (b_topic == 8)
		{
			if (b_originator != self)
			{
				if (r == 1)
				{
					BotSay(": heya\n");
					bot_start_topic(0);
				}
				else if (r == 2)
				{
					BotSay(": welcome\n");
					bot_start_topic(0);
				}
				else if (r == 3)
				{
					BotSayInit();
					BotSay2(": hi ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
					bot_start_topic(0);
				}
				else if (r == 4)
				{
					BotSayInit();
					BotSay2(": hey ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
					bot_start_topic(0);
				}
				else if (r == 5)
				{
					BotSay(": howdy\n");
					bot_start_topic(0);
				}
				else
				{
					BotSay(": yo\n");
					bot_start_topic(0);	
				}
			}
		}

		else if (b_topic == 9)
		{
			if (b_originator != self)
			{
				if (r == 1)
					BotSay(": hah\n");
				else if (r == 2)
					BotSay(": heheh\n");
				else if (r == 3)
				{
					BotSayInit();
					BotSay2(": good work ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
				}
				else if (r == 4)
				{
					BotSayInit();
					BotSay2(": nice1 ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
				}
				else if (r == 5)
					BotSay(": lol\n");
				else
					BotSay(": :)\n");
				b_topic = 6;
			}
		}
		else if (b_topic == 10)
		{
			if (b_originator != self)
			{
				if (r == 1)
					BotSay(": have a nice dip?\n");
				else if (r == 2)
					BotSay(": bah I hate levels with lava\n");
				else if (r == 3)
				{
					BotSayInit();
					BotSay2(": good job ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
				}
				else if (r == 4)
				{
					BotSayInit();
					BotSay2(": nice backflip ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
				}
				else if (r == 5)
					BotSay(": watch your step\n");
				else
					BotSay(": hehe\n");
				b_topic = 6;
			}
		}

		else if (b_topic == 11)
		{
			if (b_originator != self)
			{
				if (r == 1)
				{
					BotSayInit();
					BotSay2(": yeah right ");
					BotSay2(b_originator.netname);
					BotSay2("\n");
					bot_start_topic(0);
				}
				else if (r == 2)
				{
					BotSay(": ping\n");
					bot_start_topic(0);
				}
				else if (r == 3)
				{
					BotSay(": shuddup, you're an lpb\n");
					bot_start_topic(0);
				}
				else if (r == 4)
				{
					BotSay(": lag my eye\n");
					bot_start_topic(0);
				}
				else if (r == 5)
				{
					BotSay(": yeah\n");
					bot_start_topic(11);
				}
				else
				{
					BotSay(": totally\n");
					bot_start_topic(11);
				}
			}
		}
		self.b_chattime = 0;
	}
	else if (b_topic)
	{
		if (random() < 0.5)
		{
			if (self == b_originator)
			{
				if (b_topic <= 7)
					self.b_chattime = time + 2;
			}
			else
			{
				if (b_topic >= 7)
					self.b_chattime = time + 2;
			}
		}
	}
};

void() KickABot = {
	local entity ty;
	ty = find(world, classname, "player");
	while (ty != world) {
		if (ty.flags & FL_MONSTER) {	
			BotDisconnect(ty);
			ty.ishuman = TRUE;
			ty = world;
		} else ty = find(ty, classname, "player");
	}
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Simplified origin checking. 

God, I wish I had inline

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

vector(entity ent) realorigin =
{
// even more simplified...
	return (ent.absmin + ent.absmax) * 0.5;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

fisible

a version of visible that checks for corners
of the bounding boxes

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

float (entity targ) fisible = {
	local vector	spot1, org;
	local float thruwater, pc1, pc2;
	
	org = realorigin(targ);
	spot1 = self.origin + self.view_ofs;
	
	if (targ.solid == SOLID_BSP)
	{
		traceline (spot1, org, TRUE, self);
		if (trace_ent == targ)
			return TRUE;
		else if (trace_fraction == 1)
			return TRUE;
		return FALSE;
	} else {
		pc1 = pointcontents(org);
		pc2 = pointcontents(spot1);
		if (targ.classname == "player")
			thruwater = FALSE;
		else if (pc1 == CONTENT_LAVA)
			return FALSE;
		else	
			thruwater = TRUE;
	}
	
	if (pc1 < -1) { // targ's origin is in water or other liquid
		if (pc2 != pc1) {
			// look for their head
			traceline (spot1, org + targ.mins, TRUE, self);
			// cross the water check
			if (trace_inopen)
				if (trace_inwater)
					if (!thruwater)
						return FALSE;
			if (trace_ent == targ)
				return TRUE;
			else if (trace_fraction == 1)
				return TRUE;
			return FALSE;
		}
	} else {
		if (pc2 != pc1) {
			traceline (spot1, org + targ.maxs, TRUE, self);
			if (trace_inopen)
				if (trace_inwater)
					if (!thruwater)
						return FALSE;
			if (trace_ent == targ)
				return TRUE;
			else if (trace_fraction == 1)
				return TRUE;
			return FALSE;
		}
	}
	traceline (spot1, org, TRUE, self);
	if (trace_ent == targ)
		return TRUE;
	else if (trace_fraction == 1)
		return TRUE;
	traceline (spot1, org + targ.maxs, TRUE, self);
	if (trace_ent == targ)
		return TRUE;
	else if (trace_fraction == 1)
		return TRUE;
	traceline (spot1, org + targ.mins, TRUE, self);
	if (trace_ent == targ)
		return TRUE;
	else if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


// subtracts one angle from another
float (float y1, float y2) angcomp = {
	local float answer;

	y1 = frik_anglemod(y1);
	y2 = frik_anglemod(y2);
	answer = y1 - y2;
	if (answer > 180) return (answer - 360);
	if (answer < -180) return (answer + 360);
	return answer;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

fov

is the entity in the bot's field of view

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
float (entity targ) fov = {
	local vector yawn;
	local float g;
	yawn = realorigin(targ);
	yawn = (yawn + targ.view_ofs) - (self.origin + self.view_ofs);
	yawn = normalize(yawn);
	yawn = vectoangles(yawn);
	g = angcomp(self.v_angle_x, yawn_x);
	if (fabs(g) > 45)
		return FALSE;
	g = angcomp(self.v_angle_y, yawn_y);
	if (fabs(g) > 60)
		return FALSE;
 
	return TRUE;
};

float(float v) frik_anglemod = { return v - floor(v/360) * 360; };

// Returns accuracy of weapon.
float(float weap) DRS_W_Accuracy = {
	if(weap == IT_AXE) return self.weap_acc1_x;
	if(weap == IT_SHOTGUN) return self.weap_acc1_y;
	if(weap == IT_SUPER_SHOTGUN) return self.weap_acc1_z;
	if(weap == IT_NAILGUN) return self.weap_acc2_x;
	if(weap == IT_SUPER_NAILGUN) return self.weap_acc2_y;
	if(weap == IT_GRENADE_LAUNCHER) return self.weap_acc2_z;
	if(weap == IT_ROCKET_LAUNCHER) return self.weap_acc3_x;
	if(weap == IT_LIGHTNING) return self.weap_acc3_y;
	return 0;
};

// Returns impulse of weapon
float(float weap) DRS_PulseForWeapon = {
	if(weap == IT_AXE) return 1;
	if(weap == IT_SHOTGUN) return 2;
	if(weap == IT_SUPER_SHOTGUN) return 3;
	if(weap == IT_NAILGUN) return 4;
	if(weap == IT_SUPER_NAILGUN) return 5;
	if(weap == IT_GRENADE_LAUNCHER) return 6;
	if(weap == IT_ROCKET_LAUNCHER) return 7;
	if(weap == IT_LIGHTNING) return 8;
	return 1;
};

// Returns ammo type of weapon
float(float weap) DRS_ATFW = {
	if(weap == IT_AXE) return 0;
	if(weap == IT_SHOTGUN || weap == IT_SUPER_SHOTGUN) return self.ammo_shells;
	if(weap == IT_NAILGUN || weap == IT_SUPER_NAILGUN) return self.ammo_nails;
	if(weap == IT_GRENADE_LAUNCHER || weap == IT_ROCKET_LAUNCHER) return self.ammo_rockets;
	if(weap == IT_LIGHTNING) return self.ammo_cells; 
	return 0;
};

// Returns ammo amount requirements of weapon to allow shooting it.
float(float weap) DRS_AAFW = {
	if(weap == IT_AXE) return 0;
	if(weap == IT_SHOTGUN) return 1;
	if(weap == IT_SUPER_SHOTGUN) return 2;
	if(weap == IT_NAILGUN) return 1;
	if(weap == IT_SUPER_NAILGUN) return 2;
	if(weap == IT_GRENADE_LAUNCHER || weap == IT_ROCKET_LAUNCHER) return 1;
	if(weap == IT_LIGHTNING) return 1;
	return 0;
};

// Does condition checks for certain weapons, and returns true if they pass.
float(float weap) DRS_EWC = {
	if(weap == IT_ROCKET_LAUNCHER && (self.enemy.solid == SOLID_BSP && (vlen(realorigin(self.enemy) - self.origin) < 140))) return FALSE;
	if(weap == IT_GRENADE_LAUNCHER && (self.enemy.solid == SOLID_BSP && self.enemy != world)) return FALSE;
	if(weap == IT_LIGHTNING && self.waterlevel >= 1) return FALSE;
	return TRUE;
};

// Returns true if weapon accuracy is less than or equal to next weapon in line.
float(float weap) DRS_WAComp = {
	local vector w_rg;
	local float ac_comp, e_rg;

	ac_comp = DRS_W_Accuracy(weap);
	e_rg = vlen(self.enemy.origin - self.origin);
	w_rg = weapon_range(weap);
	if((weap == IT_ROCKET_LAUNCHER) && ((ac_comp <= DRS_W_Accuracy(IT_LIGHTNING) || (e_rg <= (w_rg_x*2))) && (self.items & IT_LIGHTNING))) return TRUE;
	if((weap == IT_LIGHTNING) && ((ac_comp <= DRS_W_Accuracy(IT_SUPER_NAILGUN) || (e_rg <= (w_rg_x*2))) && (self.items & IT_SUPER_NAILGUN))) return TRUE;
	if((weap == IT_SUPER_NAILGUN) && ((ac_comp <= DRS_W_Accuracy(IT_GRENADE_LAUNCHER) || (e_rg <= (w_rg_x*2))) && (self.items & IT_GRENADE_LAUNCHER))) return TRUE;
	if((weap == IT_GRENADE_LAUNCHER) && ((ac_comp <= DRS_W_Accuracy(IT_SUPER_SHOTGUN) || (e_rg <= (w_rg_x*2))) && (self.items & IT_SUPER_SHOTGUN))) return TRUE;
	if((weap == IT_SUPER_SHOTGUN) && ((ac_comp <= DRS_W_Accuracy(IT_NAILGUN) || (e_rg <= (w_rg_x*2))) && (self.items & IT_NAILGUN))) return TRUE;
	if((weap == IT_NAILGUN) && ((ac_comp <= DRS_W_Accuracy(IT_SHOTGUN) || (e_rg <= (w_rg_x*2))) && (self.items & IT_SHOTGUN))) return TRUE;
	return FALSE;
};
