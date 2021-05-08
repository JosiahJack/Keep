
/*
======================================
FrikBot version 0.08
======================================

FrikBot, and all functions and code writen by Ryan "Frika C" Smith are copyrighted (C) 1999. You are allowed to use and distribute this mod as long as this comment remains intact and the mod is provided free of charge. You *are* allowed to modify and incorporate this bot into your own mods, as long as adequate credit is given and the end result of your modifications is also provided free of charge. If you have questions or comments regarding the bot, the code, or just the universe in general, please write me at frika-c@earthling.net. Have a nice day!

======================================
--------------------------------------
To install on a new mod, do all this:
--------------------------------------
Place all included bot*.qc files in the subdirectory "frikbot"
in your source folder, then...

* Add the following lines to progs.src right after the defs.qc line
frikbot/bot.qc
frikbot/bot_way.qc
frikbot/bot_ai.qc
frikbot/bot_rank.qc
frikbot/bot_phys.qc
frikbot/bot_move.qc
--------------------------------------
* Comment out the following five functions in defs.qc
stuffcmd, sprint, centerprint, aim, and sound
--------------------------------------
* Add this to worldspawn() in world.qc, right at the very top, before InitBodyQue();
BotInit();  // FrikBot
--------------------------------------
* add this line to StartFrame() in world.qc, at the very top
BotFrame();
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
if (self.ishuman)
	clientSetFree( self.fClientNo ); // FrikBot
--------------------------------------
*/

// ----- entity fields ---
.float wallhug, keys, ishuman, tfrags, fClientNo, fShirt, fPants; 
.float chat_subj, chat_time, priority, ai_time, f_sound, missile_speed;
.entity temp_way;
.vector b_angle, ldest1;

// --------defines-----
float MSG_UPDATENAME   = 13; // message id for update name
float MSG_UPDATEFRAGS  = 14; // message id for update frags
float MSG_UPDATECOLORS = 17; // message id for update colors

// used for the physics & movement AI
float KEY_MOVEUP 		= 1;
float KEY_MOVEDOWN 	= 2;
float KEY_MOVELEFT 	= 4;
float KEY_MOVERIGHT 	= 8;
float KEY_MOVEFORWARD	= 16;
float KEY_MOVEBACK	= 32;
float KEY_LOOKUP		= 64;
float KEY_LOOKDOWN	= 128;
float KEY_LOOKLEFT	= 256;
float KEY_LOOKRIGHT	= 512;

// -------globals-----
float fActiveClients;
float fMaxClients;
float BOT_COUNT;

// -------ProtoTypes------
void() ClientConnect;
void() ClientDisconnect;
float(float v) anglemod;
float( float fClientNo ) clientBitFlag;
float( float fClientNo ) clientIsActive;
void( float fClientNo ) clientSetUsed;
void( float fClientNo ) clientSetFree;
float() clientNextAvailable;
void() DynamicWaypoint;
void(float whichteam) botConnect;
void( entity bot ) botDisconnect;
void( float clientno ) botInvalidClientNo;
void( float clientno, string clientname ) msgUpdateNameToAll;
void( float clientno, float clientshirt, float clientpants ) msgUpdateColorsToAll;
void( float clientno, float clientfrags ) msgUpdateFragsToAll;
void() BotChat;
void() KickABot;
void() SetNewParms;
float(vector weird) frik_walkmove;
void() frik_movetogoal;
float (entity targ) visible;


// ----------Commands---------
void(entity client, string s) frik_stuffcmd = #21;
void(entity client, string s) frik_sprint = #24;
void(entity client, string s) frik_centerprint = #73;	// sprint, but in middle
vector(entity e, float sped) frik_aim = #44;	
void(entity e, float chan, string samp, float vol, float atten) frik_sound = #8;

//----------------------------------------------------------------------------

		
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Function redclarations. These allow function 
designed to work for clients (sprint, so forth)
to mainly not complain when working with a bot

Although these shouldn't be needed anymore,
as the bots truly are clients now, if you don't
stop the SZ_ buffer from filling up by disabling
direct messages to the bots, it crashes quake :-(

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void(entity	client, string s) stuffcmd =
{
	local entity jj;
	if (client.ishuman)
		frik_stuffcmd(client, s);
	jj = find(world, classname, "botcam");
	while(jj != world)
	{
		if ((jj.enemy == client) && jj.ishuman)
			frik_stuffcmd(jj, s);
		jj = find(jj, classname, "botcam");	
	}
};
void(entity	client, string s) sprint =
{
	local entity jj;
	if (client.ishuman)
		frik_sprint(client, s);
	jj = find(world, classname, "botcam");
	while(jj != world)
	{
		if ((jj.enemy == client) && jj.ishuman)
			frik_sprint(jj, s);
		jj = find(jj, classname, "botcam");	
	}

};
void(entity	client, string s) centerprint =
{
	local entity jj;
	if (client.ishuman)
		frik_centerprint(client, s);
	jj = find(world, classname, "botcam");
	while(jj != world)
	{
		if ((jj.enemy == client) && jj.ishuman)
			frik_centerprint(jj, s);
		jj = find(jj, classname, "botcam");	
	}
};

vector(entity e, float sped) aim =
{
	e.missile_speed = sped;
	return frik_aim(e, sped);
};

void(entity e, float chan, string samp, float vol, float atten) sound = 
{
	e.f_sound = time + 0.5;
	frik_sound(e, chan, samp, vol, atten);
};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bot Cam, see what the bot sees (or any other player)

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() botImpulses;

void() botcam =
{

	if (self.classname != "botcam")
		return FALSE;
	setorigin(self, self.enemy.origin);
	self.items = self.enemy.items;
	self.weapon = self.enemy.weapon;
	self.weaponmodel = self.enemy.weaponmodel;
	self.currentammo = self.enemy.currentammo;
	self.weaponframe = self.enemy.weaponframe;
	self.ammo_shells = self.enemy.ammo_shells;
	self.ammo_nails = self.enemy.ammo_nails;
	self.ammo_rockets= self.enemy.ammo_rockets;
	self.ammo_cells = self.enemy.ammo_cells;
	self.view_ofs = self.enemy.view_ofs;
	self.health = self.enemy.health;
	self.armorvalue = self.enemy.armorvalue;
	self.dmg_take = self.enemy.dmg_take;
	self.dmg_save = self.enemy.dmg_save;
	self.dmg_inflictor = self.enemy.dmg_inflictor;
	if (self.enemy.ishuman == FALSE)
	{
		self.enemy.dmg_take = 0;
		self.enemy.dmg_save =0;
        }
	self.punchangle = self.enemy.punchangle;
	self.deadflag = self.enemy.deadflag;
	msg_entity = self;
      WriteByte (MSG_ONE,5);
      WriteEntity (MSG_ONE, self.enemy); //uhh maybe?
	WriteByte (MSG_ONE, 10);
     	WriteAngle (MSG_ONE,self.enemy.v_angle_x);
     	WriteAngle (MSG_ONE,self.enemy.v_angle_y);
     	WriteAngle (MSG_ONE,self.enemy.v_angle_z);
	self.modelindex = 0;
	
	self.impulse = 0;	
	return TRUE;
	
};

void() botcam_u = 
{
	local float loopcount;
	loopcount = 0;
	if (self.classname != "botcam")
		self.enemy = world;
	self.classname = "botcam";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	
	self.enemy = find(self.enemy, classname, "player");
	if (self.enemy == world)
	{
		sprint(self, "No one left to track! \n");
		msg_entity = self;
		WriteByte (MSG_ONE,5);
		WriteEntity (MSG_ONE, self);
		PutClientInServer();
		return;
	}
	if (self.enemy.ishuman == FALSE)
	{
		self.enemy.dmg_take = 0;
		self.enemy.dmg_save = 0;
	}
	sprint(self, "Now tracking ");
	sprint(self, self.enemy.netname);
	sprint(self, "\n");
};


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

fisible, a version of visible that checks for corners of the bounding boxes

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/


float (entity targ) fisible =
{
	local vector	spot1, spot2, org;
	local float thruwater;
	if (targ.classname == "player")
		thruwater = FALSE;
	else
		thruwater = TRUE;
	org = targ.origin;
	if (org == '0 0 0')
		org = (targ.absmin + targ.absmax) * 0.5;

	spot1 = self.origin + self.view_ofs;
	spot2 = org;
	traceline (spot1, spot2, TRUE, self);	
	if (!(trace_inopen && trace_inwater) || thruwater)	
		if ((trace_ent == targ) || (trace_fraction == 1))
			return TRUE;
	if (targ.solid == SOLID_BSP)
		return FALSE;
	spot2 = org + targ.mins;
	traceline (spot1, spot2, TRUE, self);
	if (!(trace_inopen && trace_inwater) || thruwater)	
		if ((trace_ent == targ) || (trace_fraction == 1))
			return TRUE;
	spot2 = org + targ.maxs;
	traceline (spot1, spot2, TRUE, self);	
	if (!(trace_inopen && trace_inwater) || thruwater)	
		if ((trace_ent == targ) || (trace_fraction == 1))
			return TRUE;
	return FALSE;
};
float (float y1, float y2) angcomp = // This is handy :)
{
	// apparent bugs in angcomp are likely caused by
	// grossly un-normalized angles, so I changed
	// this to use my own form of anglemod

	while (y1 > 180)
		y1 = y1 - 360;
	while (y1 < -179)
		y1 = y1 + 360;
	while (y2 > 180)
		y2 = y2 - 360;
	while (y2 < -179)
		y2 = y2 + 360;

	local float answer;
	answer = y1 - y2;
	if (fabs(answer) > 180)
                answer = (fabs(answer) - 360) * -1;
	return answer;

};


float (entity targ) fov =
{
	local vector yawn;
	local float g;
	yawn = (targ.origin + targ.view_ofs) - (self.origin + self.view_ofs);
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
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Frag Update, just updates frags to all clients
when it senses a change.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() DoFragUpdate =
{
	if (self.frags > self.tfrags)
		self.chat_subj = 3;
	else 
		self.chat_subj = 2;
	self.chat_time = time + 3;
	msgUpdateFragsToAll (self.fClientNo, self.frags);
	self.tfrags = self.frags;
};


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Stuff mentioned up top
it just links the bot into the mod

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() ClientInRankings =
{
   local float cno;
   if (self.ishuman == 2)
   {
		self.ishuman = FALSE;
		return;
   }
   cno = self.colormap - 1;
   botInvalidClientNo (cno);
   clientSetUsed (cno);
   msgUpdateNameToAll (cno, self.netname);
   self.fClientNo = cno;
   self.ishuman = TRUE;
};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

BotPreFrame & BotPostFrame, used to make the
bot easier to install

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() frik_obstacles;

float () BotPreFrame =
{
	local vector test;
	if (self.classname == "botcam")
		return TRUE;
	else
	{
		if (self.ishuman)
			DynamicWaypoint();
		return FALSE;
	}
};
float () BotPostFrame =
{
	botImpulses();
	if (botcam())
		return TRUE;
	else
		return FALSE;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bot Impulses. You might have to edit this if
the impulses conflict with impulses in your
mod.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() DumpWaypoints;

void() botImpulses =
{
	if (self.impulse == 100)
	{
		botConnect(0);
		self.impulse = 0;
	}
	else if (self.impulse == 101)
	{
		botConnect(1);
		self.impulse = 0;
	}
	else if (self.impulse == 102)
	{
		KickABot();
		self.impulse = 0;
	}
	else if (self.impulse == 103)
	{
		botcam_u();
		self.impulse = 0;
	}
	else if (self.impulse == 104)
	{
		DumpWaypoints();
		self.impulse = 0;
	}
	// add more later
	else if (self.impulse == 111)
	{
		if (serverflags & 16)
		{
			serverflags = serverflags & 15;
			centerprint(self, "DMSP mode: OFF\nThis will take effect next level.");
		}
		else
		{
			serverflags = serverflags & 31;
			centerprint(self, "DMSP mode:  ON\nThis will take effect next level.");
		}
		self.impulse = 0;
	}
};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bot Chat code

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void(string h) BotSay = // simulate talking by composing a 'chat' message
{
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, self.netname);
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 2);
	WriteString(MSG_ALL, h);
};
void() BotChat =
{
	if (self.chat_subj == 0)
		return;

	if (self.chat_time > time)
		return;
	if (random() > 0.2) // speak very rarely
		self.chat_subj = 0;
	local float r;
	r = ceil(random() * 10);

	if (self.chat_subj == 1) // lost a waypoint or an item..
	{
		if (r == 1)
			BotSay(": this level sucks\n");
		else if (r == 1)
			BotSay(": i hate this damn map\n");
		else if (r == 2)
			BotSay(": i'm lost\n");
		else if (r == 3)
			BotSay(": hmmmm\n");
		else if (r == 4)
			BotSay(": this blows\n");
		else if (r == 5)
			BotSay(": my navigation sucks\n");
		else if (r == 6)
			BotSay(": i can't find a thing\n");
		else if (r == 7)
			BotSay(": sigh\n");
		else if (r == 8)
			BotSay(": arghh\n");
		else if (r == 9)
			BotSay(": can you change map, please!\n");
		else
			BotSay(": grrr\n");
	}
	else if (self.chat_subj == 2) // got a frag less on update 
	//committed suicide or fell into a trap)
	{
		if (r == 1)
			BotSay(": oh man!\n");
		else if (r == 2)
			BotSay(": grrr\n");
		else if (r == 3)
			BotSay(": heh, oops\n");
		else if (r == 4)
			BotSay(": that was lag!\n");
		else if (r == 5)
			BotSay(": i need practice\n");
		else if (r == 6)
			BotSay(": damnit\n");
		else if (r == 7)
			BotSay(": i suck\n");
		else if (r == 8)
			BotSay(": doh!\n");
		else if (r == 9)
			BotSay(": whoops\n");
		else
			BotSay(": my mouse needs cleaning\n");
	}
	else if (self.chat_subj == 3) // got a frag more on last update
	{
		if (r == 1)
			BotSay(": yeeehaw!\n");
		else if (r == 2)
			BotSay(": take that\n");
		else if (r == 3)
			BotSay(": heh heh\n");
		else if (r == 4)
			BotSay(": eat that\n");
		else if (r == 5)
			BotSay(": i rule\n");
		else if (r == 6)
			BotSay(": you suck\n");
		else if (r == 7)
			BotSay(": i can kick your butt anyday\n");
		else if (r == 8)
			BotSay(": that's gotta hurt\n");
		else if (r == 9)
			BotSay(": no chance against me, pal\n");
		else
			BotSay(": lol\n");
	}
	self.chat_subj = 0;
	self.chat_time = time;
};
