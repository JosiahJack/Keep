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
// Implements: FrikBot Main Code
//
// Description:
// 
//=============================================================================

/*
======================================
FrikBot X (Version 0.10.2)
======================================

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

======================================
These installation instructions only apply to Normal Quake (as does this
entire file). For QuakeWorld, please refer to bot_qw.qc

--------------------------------------
To install on a new mod, do all this:
--------------------------------------
Place all included bot*.qc files in the subdirectory "frikbot"
in your source folder, then...

* Add the following lines to progs.src right after the defs.qc line
frikbot/bot.qc
frikbot/bot_way.qc
frikbot/bot_fight.qc 
frikbot/bot_ai.qc
frikbot/bot_misc.qc
frikbot/bot_phys.qc
frikbot/bot_move.qc
frikbot/bot_ed.qc

--------------------------------------
* Comment out the following functions in defs.qc
sound, stuffcmd, sprint, aim, centerprint, setspawnparms
WriteByte, WriteChar, WriteShort, WriteLong, WriteCoord
WriteAngle, WriteString, WriteEntity
--------------------------------------
* Add this to worldspawn() in world.qc, right at the very top, before InitBodyQue();
BotInit();  // FrikBot
--------------------------------------
* Add this line to StartFrame() in world.qc, at the very top
BotFrame(); // FrikBot
--------------------------------------
* Add these two lines to PlayerPreThink in client.qc at the very top
if (BotPreFrame()) // FrikBot
	return;
--------------------------------------
* Add this line to PlayerPostThink in client.qc at the very top
if (BotPostFrame()) // FrikBot
	return;
--------------------------------------
* Add the following line to the very top of Client Connect in client.qc
ClientInRankings(); // FrikBot
--------------------------------------
* Add these lines to the very top of ClientDisconnect in client.qc
ClientDisconnected(); // FrikBot
--------------------------------------

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Variables and shtuff

bot.qc has become pretty much a header file
for all variables in the bot...

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

// ----- entity fields ---
//.float	wallhug, keys, oldkeys, ishuman;
//.float	b_frags, b_clientno, b_shirt, b_pants; 
//.float	priority, ai_time, b_sound, missile_speed;
//.float	portal_time, b_skill, switch_wallhug;
//.float	b_aiflags, b_num, b_chattime;
//.float	b_menu, b_menu_time, b_menu_value;
//.float route_failed, dyn_flags, dyn_time;
//.float dyn_plat;
//.entity	temp_way, last_way, phys_obj;
//.entity	target1, target2, target3, target4;
//.entity	_next, _last;
//.entity	current_way;
//.vector	b_angle, b_dest, mouse_emu, obs_dir;
//.vector	movevect, b_dir;
//.vector dyn_dest;

// --------defines-----
//float SVC_UPDATENAME	= 13;
//float SVC_UPDATEFRAGS	= 14;
//float SVC_UPDATECOLORS	= 17;

// used for the physics & movement AI
//float KEY_MOVEUP 		= 1;
//float KEY_MOVEDOWN 	= 2;
//float KEY_MOVELEFT 	= 4;
//float KEY_MOVERIGHT 	= 8;
//float KEY_MOVEFORWARD	= 16;
//float KEY_MOVEBACK	= 32;
//float KEY_LOOKUP		= 64;
//float KEY_LOOKDOWN	= 128;
//float KEY_LOOKLEFT	= 256;
//float KEY_LOOKRIGHT	= 512;

// these are aiflags for waypoints
// some overlap to the bot
//float AI_TELELINK_1	= 1; // link type
//float AI_TELELINK_2	= 2; // link type
//float AI_TELELINK_3	= 4; // link type
//float AI_TELELINK_4	= 8; // link type
//float AI_DOORFLAG		= 16; // read ahead
//float AI_PRECISION	= 32; // read ahead + point
//float AI_SURFACE		= 64; // point 
//float AI_BLIND		= 128; // read ahead + point
//float AI_JUMP		= 256; // point + ignore
//float AI_DIRECTIONAL	= 512; // read ahead + ignore
//float AI_PLAT_BOTTOM	= 1024; // read ahead 
//float AI_RIDE_TRAIN	= 2048; // read ahead 
//float AI_SUPER_JUMP	= 4096; // point + ignore + route test
//float AI_SNIPER		= 8192; // point type 
//float AI_AMBUSH		= 16384; // point type
//float AI_DOOR_NO_OPEN	= 32768; // read ahead
//float AI_DIFFICULT	= 65536; // route test
//float AI_TRACE_TEST	= 131072; // route test

// these are flags for bots/players (dynamic/editor flags)
//float AI_OBSTRUCTED	= 1;
//float AI_HOLD_SELECT	= 2;
//float AI_ROUTE_FAILED	= 2;
//float AI_WAIT		= 4;
//float AI_DANGER		= 8;

// addition masks
//float AI_POINT_TYPES 	= 29152;
//float AI_READAHEAD_TYPES	= 36528;
//float AI_IGNORE_TYPES	= 4864;

//float OPT_SAVEBOTS	= 1;
//float OPT_NOCHAT	= 2;

// -------globals-----
//float 	active_clients;
//float		max_clients, real_frametime;
//float		bot_count, b_options;
//entity	fixer;
//entity	b_temp1, b_temp2, b_temp3;
//entity 	player_head, phys_head, way_head;
//float		busy_waypoints;
//float		saved_bots, saved_skills1, saved_skills2, current_bots;

// -------ProtoTypes------
// external
//void()				ClientConnect;
//void()				ClientDisconnect;
//void()				SetNewParms;

// rankings
//float(float clientno)		ClientBitFlag;
//void(float whichteam, float whatbot, float whatskill) BotConnect;
//void(entity bot)			BotDisconnect;
//void(float clientno)		BotInvalidClientNo;

// physics & movement
//float(entity e)			bot_can_rj;
//void()				bot_jump;
//void()				frik_bot_roam;
//float(vector weird)		frik_walkmove;
//void()				frik_movetogoal;
//void()				frik_obstacles;
//float(float flag)			frik_recognize_plat;
//float(vector sdir)		frik_KeysForDir;
//void(vector whichway, float danger) frik_obstructed;
//void()				SV_Physics_Client;
//void()				SV_ClientThink;
//void() 				CL_KeyMove;

// ai & misc
//float(entity targ)		fov;
//float(float y1, float y2)	angcomp;
//float(entity targ1, entity targ2)		wisible;
//float(entity targ)		fisible;
//vector(entity ent)		realorigin;
//void(entity ent)			target_drop;
//void(entity ent)			target_add;
//void()				KickABot;
//void(entity targ, float success) bot_lost;
//float(float v)			frik_anglemod;
//void() bot_chat;
//void(float tpic) bot_start_topic;

// DRS: Extra shizz here
//.float dontshoot;
//.float real_teleport_time;
//.entity bot_teleport_dest;
//.float deathtime;

// DRS: Weapon Preferencing stuffs
// Skill Globals first
//float SKILL0_ACC = 55;
//float SKILL1_ACC = 45;
//float SKILL2_ACC = 36;
//float SKILL3_ACC = 15;

// Personal Weapon Accuracy, used for selecting favorite weapon of a bot
// as well as accuracy with a given weapon

// First Block: Axe, Shotgun, Super Shotgun
//.vector weap_acc1;

// Second Block: Nailgun, Super Nailgun, Grenade Launcher
//.vector weap_acc2;

//  Third Block: Rocket Launcher, Lightning gun, ??? (TODO: aimspeed?)
//.vector weap_acc3;

// Return accuracy of given weapon
//float(float weap) DRS_W_Accuracy;

// Extra Weapon Checks
//float(float weap) DRS_EWC;

// impulse for weapon
//float(float weap) DRS_PulseForWeapon;

// Favorite weapon
//.float b_fav_weapon;

// ammotype for weapon and ammo amount for weapon
//float(float weap) DRS_ATFW;
//float(float weap) DRS_AAFW;

// Tries to pick most accurate weapon for task...Not very good.
//float(float weap) DRS_WAComp;

// DRS: Invisibility stuffs
//.float lockon_time;
//.float e_sensed_lag;
//.float enemy_lastseen;
//.vector b_enemy_last_origin;

void() ClientInRankings = {
	local float cno;

   	cno = self.colormap - 1;
	BotInvalidClientNo (cno);
	
	if (player_head)
		player_head._last = self;

	self._next = player_head;
	self._last = world;
	player_head = self;

	if (!self.phys_obj)
	{
		b_temp2 = phys_head;
		while (b_temp2 != world && b_temp2.owner != self)
			b_temp2 = b_temp2._next;
		self.phys_obj = b_temp2;
	}

	if (self.ishuman == 2)
	{
		self.ishuman = FALSE;
		return;
	}
	active_clients = active_clients | ClientBitFlag(cno);
	
	self.b_clientno = cno;
	self.ishuman = TRUE;
	self.switch_wallhug = time + 1;
};


void() ClientDisconnected = {
	if (player_head == self) player_head = self._next;
	if (self._next) self._next._last = self._last;
	if (self._last) self._last._next = self._next;
	active_clients = active_clients - active_clients & ClientBitFlag(self.b_clientno);
};

float () BotPreFrame = {
	local float cno;

	if (self.b_clientno == -1) return TRUE;
	if (self.flags & FL_CLIENT) {
		if (self.switch_wallhug) {
			if (self.switch_wallhug <= time) { // Fix rankings
				self.switch_wallhug = 0;
				b_temp2 = nextent(world);
				cno = 0;
				while (cno < max_clients) {
					//if ((b_temp2.flags & FL_MONSTER) && (active_clients & ClientBitFlag(cno))) UpdateClient(b_temp2);
					cno = cno + 1;
					b_temp2 = nextent(b_temp2);
				}
			}
		}
	}

	if (self.b_frags != self.frags) {
		if (self.b_frags > self.frags) {
			if (pointcontents(self.origin) == CONTENT_LAVA) bot_start_topic(10);
			else bot_start_topic(9);
		} else bot_start_topic(2);
		self.b_frags = self.frags;
	}

	DynamicWaypoint();
	return FALSE;
};

float () BotPostFrame = {
	if (self.b_clientno == -1) return TRUE;
	return FALSE;
};

void(string h) BotSay = { // simulate talking by composing a 'chat' message
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, self.netname);
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 2);
	WriteString(MSG_ALL, h);
};

void() BotSayInit = {
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, self.netname);
};

void(string h) BotSay2 = {
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 2);
	WriteString(MSG_ALL, h);
};

void(string h) BotSayTeam = {
	local entity t;
	if (!teamplay) return;

	t = player_head;
	while(t) {
		if (t.team == self.team) {
			msg_entity = t;
			WriteByte(MSG_ONE, 8);
			WriteByte(MSG_ONE, 1);
			WriteByte(MSG_ONE, 40);
			WriteString(MSG_ONE, self.netname);
			WriteByte(MSG_ONE, 8);
			WriteByte(MSG_ONE, 2);
			WriteByte(MSG_ONE, 41);
			WriteString(MSG_ONE, h);
		}
		t = t._next;
	}
};

void() BotInit = {
	local entity ent, fisent;
	local float numents;
	
	// spawn entities for the physics
	ent = nextent(world);
	max_clients = 0;

	while(ent != world) {
		max_clients = max_clients + 1;
		ent = nextent(ent);
	}

	if (max_clients > 16) max_clients = 16;
	ent = nextent(world);
	fisent = world;
	while (numents < max_clients) {
		phys_head = spawn();
		if (fisent)
			fisent._next = phys_head;
		phys_head._last = fisent;
		fisent = phys_head;
		ent.phys_obj = phys_head;
		phys_head.classname = "phys_obj";
		phys_head.owner = ent;
		numents = numents + 1;
		ent = nextent(ent);
	}
};

// Rankings 'utilities'. Written by Alan Kivlin, this code just fools clients by
// sending precisely the same network messages as when a real player signs on
// to the server.
float(float clientno) ClientBitFlag = { // Bigger, but faster
	if (clientno == 0) return 1;
	else if (clientno == 1) return 2;
	else if (clientno == 2) return 4;
	else if (clientno == 3) return 8;
	else if (clientno == 4) return 16;
	else if (clientno == 5) return 32;
	else if (clientno == 6) return 64;
	else if (clientno == 7) return 128;
	else if (clientno == 8) return 256;
	else if (clientno == 9) return 512;
	else if (clientno == 10) return 1024;
	else if (clientno == 11) return 2048;
	else if (clientno == 12) return 4096;
	else if (clientno == 13) return 8192;
	else if (clientno == 14) return 16384;
	else if (clientno == 15) return 32768;
	return 0;
};

// Team finding code
float(float tcolor) FindAnotherColor = {
	local float bestbet, scolor, pcount, bestp;

	bestbet = -1;
	bestp = 16;
	while(scolor < 14) {
		if (scolor != tcolor) {
			b_temp2 = player_head;
			pcount = 0;
			while(b_temp2 != world) {
				if (b_temp2.team == scolor + 1)
					pcount = pcount + 1;
				b_temp2 = b_temp2._next;
			}

			if ((pcount < bestp) && pcount) {
				bestbet = scolor;
				bestp = pcount;
			}
		}
		scolor = scolor + 1;
	}

	if (bestbet < 0) {
		bestbet = tcolor;
		while (bestbet == tcolor)bestbet = floor(random() * 13);
	}
	return bestbet;
};
			
entity(float num) GetClientEntity = {
	local entity upsy;
	upsy = world;
	num = num + 1;
	while (num > 0) {
		num = num - 1;
		upsy = nextent(upsy);
	} 
	return upsy;
};

void() BotConnect = {
	local float f, clientno. whatskill;
	local string h;
	local entity uself;
	
	clientno = max_clients;
	f = -1;
	while(clientno > 0) {
		clientno = clientno - 1;
		if(!(active_clients & ClientBitFlag(clientno))) f = clientno;
	}

	uself = self;
	if(f == -1) {
		bprint("Unable to connect a bot, server is full.\n");
		return;
	}
	
	bot_count = bot_count + 1;
	self = GetClientEntity(f);
	if (!saved_bots) bot_start_topic(1);
	self.b_clientno = f;
	self.colormap = f + 1;
	self.netname = PickARandomName();	
	whatskill = rint(cvar("skill"));     // Players can set skill all weird, so 
	if (whatskill > 3) self.b_skill = 3; // leave these checks in.
	else if (whatskill < 0) self.b_skill = 0;
	else self.b_skill = whatskill;

	if (teamplay) {
		self.b_pants = FindAnotherColor(uself.team - 1);
		self.b_shirt = self.b_pants;
	}

	self.team = self.b_pants + 1;
	SetNewParms();
	self.ishuman = 2;
	ClientConnect();
	PutClientInServer();
	active_clients = active_clients | ClientBitFlag(f);
	f = ClientBitFlag(self.b_num - 1);
	current_bots = current_bots | f;
	if (self.b_num <= 8) {
		saved_skills1 = (saved_skills1 & (65536 - (3 * f)) | (self.b_skill * f));
	} else {
		f = ClientBitFlag(self.b_num - 9);
		saved_skills2 = (saved_skills2 & (65536 - (3 * f)) | (self.b_skill * f));
	}
	self = uself;
};

void(entity bot) BotDisconnect = {
	local string h;
	local entity uself;
	uself = self;
	self = bot;

	bot_count = bot_count - 1;
	current_bots = current_bots - (current_bots & ClientBitFlag(self.b_num - 1));
	ClientDisconnect();
	if (self.b_clientno != -1) {
      	// the bot's client number is not in use by a real player so we
		// must remove it's entry in the rankings
		// Quake engine sets all fields to 0, can only do the most important here
		self.b_frags = self.frags = 0;
		self.netname = "";
		self.classname = "";
		self.health = 0;
		self.items = 0;
		self.armorvalue = 0;
		self.weaponmodel = "";
		self.b_pants = 0;
		self.b_shirt = 0;
		self.ammo_shells = self.ammo_nails = self.ammo_rockets = self.ammo_cells = 0;
		active_clients = active_clients - (active_clients & ClientBitFlag(self.b_clientno));
	    self.b_clientno = -1;
   	}
	self = uself;
};

// Kicks a bot if a player connects and takes the bot's space.
void(float clientno) BotInvalidClientNo = {
	local entity bot;

	bot = GetClientEntity(clientno);
	if(bot.b_clientno > 0) {
		if (active_clients & ClientBitFlag(self.b_clientno)) {
			bot.b_clientno = -1;
			BotDisconnect(bot);
			active_clients = active_clients | ClientBitFlag(self.b_clientno);
			BotConnect(0, bot.b_num, bot.b_skill); 
			return;
		}
	}
};

void() BotFrame = {
	local float num;

	real_frametime = frametime; // in NQ this is alright
	self = nextent(world);
	num = 0;
	while (num < max_clients) {
		if (self.ishuman == FALSE) {
			if (active_clients & ClientBitFlag(num)) {
				frik_obstacles();
				CL_KeyMove();
				SV_ClientThink();
				SV_Physics_Client();
			}
		}
		self = nextent(self);
		num = num + 1;
	}
};

