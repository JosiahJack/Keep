/*
==============================================================================

CTF GAMEMODE - capture the flag (duh)

==============================================================================
*/

//CTF variables
var float autocvar_ctf = 0;
var float autocvar_ctf_autobalance = 0;
var float autocvar_ctf_capture_limit = 0;

float FLAG_COUNT;

.float side;
.float has_flag;
float BLUE = 1;
float RED = 2;
.float athome;
.vector oldangles;

.entity carrier;

float capture_limit;

float BLUE_CAPS, RED_CAPS;
float BLUE_CAP_COOLDOWN, RED_CAP_COOLDOWN;

.float blue_captures, red_captures, gametype; //workaround to send to CSQC HUD so I can avoid sending entities

float CTF_ENABLED;
float BLUE_PLAYERS;
float RED_PLAYERS;

float RED_CARRIED;
float BLUE_CARRIED;

void() respawn;


//broadcast string - broadcasts centerprints to all players for info such as flag captures and returns


void(string plrname, string msg) broadcast_string =
{
	local entity ent;

		if (msg != "" && !plrname)
		{
		    ent = find(world, classname, "player");
		    while (ent != world)
		    {
		    	if (ent.ishuman == 1) //player is not a bot
				centerprint(ent, msg);
			ent = find(ent, classname, "player");
		    }
		}
		else
		{
			ent = find(world, classname, "player");
			while (ent != world)
			{
				if (ent.ishuman == 1)
					centerprint(ent, strcat(plrname, " ", msg));
				ent = find(ent, classname, "player");
			 }
		}
}

//gametype setup

//turn on the gametype
void() enable_ctf =
{
	if (cvar("deathmatch") == 0)
		cvar_set("deathmatch", "1");
		
	if (cvar("ctf") == 1)
		CTF_ENABLED = 1;
	else
		CTF_ENABLED = 0;
}

//if

float(float player_team) checkSwapBalance =
{
	if (autocvar_ctf_autobalance)
	{
		if (player_team == BLUE) //if team is blue check amount of red players
			 if (RED_PLAYERS >= BLUE_PLAYERS)
				return FALSE; //if team playercounts are already balanced do not let player swap teams
			 else	 
				return TRUE;
		else if (player_team == RED) //if team is red check amount of blue players
			 if (BLUE_PLAYERS >= RED_PLAYERS)
				return FALSE; 
			 else	 
				return TRUE;
	}
	else
		return TRUE;
				
}

//team setup methods

void() teamchange_respawn =
{
	self.health = 0;
	
	//randomize death frame
	if (random(100) < 50)
		self.frame = 93;
	else
		self.frame = 102;
	setmodel(self, "progs/player.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.deadflag = DEAD_DEAD;
		
	self.frags--;
	respawn();
}

void() swap_team =
{
	
	if (self.side == BLUE)
	{
		if (checkSwapBalance(BLUE) == TRUE)
		{
			self.side = RED;
			BLUE_PLAYERS--;
			RED_PLAYERS++;
			centerprint(self, "You are on RED TEAM");
			teamchange_respawn();
		}
		else
			centerprint(self, "Teams are ^3balanced, ^7sorry!");
	}
	else
	{
		if (checkSwapBalance(RED) == TRUE)
		{
			self.side = BLUE;
			RED_PLAYERS--;
			BLUE_PLAYERS++;
			centerprint(self, "You are on BLUE TEAM");
			teamchange_respawn();
		}
		else
			centerprint(self, "Teams are ^3balanced, ^7sorry!");
	}
		
	//setmodel(self, string_null);
	
}

void() set_team_color =
{
	if (time - self.delay >= .1)	//delay to prevent network overflow
	{
		if (self.side == RED)
		{
			stuffcmd(self, "topcolor 4\n");	
			stuffcmd(self, "bottomcolor 4\n");
			
			self.b_shirt = 4;
			self.b_pants = 4;
			self.clientcolors = 4 * 16 + 4;
			self.team = RED;
		}
		else if (self.side == BLUE)
		{
			stuffcmd(self, "topcolor 13\n");
			stuffcmd(self, "bottomcolor 13\n");
			
			self.b_shirt = 13;
			self.b_pants = 13;
			self.clientcolors = 13 * 16 + 13;
			self.team = BLUE;
		}
		self.delay = time;
	}	
}

void() choose_team =
{
	if (BLUE_PLAYERS < RED_PLAYERS)
	{
		self.side = BLUE;
		self.team = BLUE;
		BLUE_PLAYERS++;
		if (self.ishuman == 1)
			centerprint(self, "You are on BLUE TEAM");
	}
	else if (RED_PLAYERS < BLUE_PLAYERS)
	{
		self.side = RED;
		self.team = RED;
		RED_PLAYERS++;
		if (self.ishuman == 1)
			centerprint(self, "You are on RED TEAM");
	}
	else if (RED_PLAYERS == BLUE_PLAYERS || !self.side)
	{
		if (random(100) < 50)
		{
			self.side = BLUE;
			self.team = BLUE;
			BLUE_PLAYERS++;
			if (self.ishuman == 1)
				centerprint(self, "You are on BLUE TEAM");
		}
		else
		{
			self.side = RED;
			self.team = RED;
			RED_PLAYERS++;
			if (self.ishuman == 1)
				centerprint(self, "You are on RED TEAM");
		}
	}
}

/*CTF flag functions 
=======================================================================================
Methods defined in here determine how the flag functions under different circumstances,
Used to handle flags being stolen, returned to base, flags that haven't been returned, and
scoring
=======================================================================================
*/

void() capture =
{
		
	local entity flagspawn;
	
	if (other.side == BLUE)
		flagspawn = find (world, netname, "red flag");
	else
		flagspawn = find (world, netname, "blue flag");
		
	
	setorigin(flagspawn, flagspawn.oldorigin);
	
	flagspawn.carrier = world;
	
	/*if (other.side == self.side)
	{
		other.frags += 10;
		if (other.side == BLUE && RED_CARRIED)
			BLUE_CAPS++;
		else if (other.side == RED && BLUE_CARRIED)
			RED_CAPS++;
	}*/
	
	if (other.side == BLUE && RED_CAP_COOLDOWN == 0)
	{
		flagspawn.athome = 1;
		broadcast_string(other.netname, strcat("captured the ^1", flagspawn.netname, "^7!"));
		if (RED_CARRIED)
			BLUE_CAPS++;
		other.frags += 10;  //give player a personal score boost	
		RED_CARRIED = 0;
		RED_CAP_COOLDOWN = 5;
		other.has_flag = 0;
		
		sound(flagspawn, CHAN_ITEM, flagspawn.noise1, 1, ATTN_NONE);
		
	}
	else if (other.side == RED && BLUE_CAP_COOLDOWN == 0)
	{
		flagspawn.athome = 1;
		broadcast_string(other.netname, strcat("captured the ^4", flagspawn.netname, "^7!"));
		if (BLUE_CARRIED)
			RED_CAPS++;
		other.frags += 10; //give player a personal score boost	
		BLUE_CARRIED = 0;
		BLUE_CAP_COOLDOWN = 5;
		other.has_flag = 0;
		
		sound(flagspawn, CHAN_ITEM, flagspawn.noise1, 1, ATTN_NONE);
	}
	
	
	
	self.nextthink = time + 0.1;
	
}

void() flag_return;
void() flag_touch_blue;
void() flag_touch_red;


void() flag_run_blue =
{
	
	if (self.frame < 25)
		self.frame+=.5;
	else
		self.frame = 0;
		
	self.angles = self.oldangles;
	
	if (pointcontents(self.origin - '0 0 1') != CONTENT_SOLID)
		self.origin = self.origin - '0 0 1';
		
	if (world.model == "maps/e1m2.bsp" && self.athome)
		setsize(self, VEC_HULL_MIN + '0 0 10', VEC_HULL_MAX + '0 0 10');
	
	if (self.owner.has_flag && (self.owner.items & IT_KEY1) && self.owner.health > 0)
	{
		makevectors(self.owner.angles);
		setorigin(self, self.owner.origin + v_forward*-20 + v_right*5 + v_up*-10);
		
		self.angles = self.owner.angles;
		
		
	}
	else if (!self.athome)
	{
		self.carrier = world;
		BLUE_CARRIED = 0;
			
		if (pointcontents(self.origin) == CONTENT_LAVA || pointcontents(self.origin) == CONTENT_SLIME)
			flag_return();
		if (time - self.delay >= 30)
		{
			flag_return();
			self.delay = time;
		}
	}
		
	if (self.athome && BLUE_CAP_COOLDOWN > 0)
		BLUE_CAP_COOLDOWN--;
		
	self.think = flag_run_blue;
	self.nextthink = time+0.03;
	//print("hello\n");
}

void() flag_run_red =
{
	
	if (self.frame < 25)
		self.frame+=.5;
	else
		self.frame = 0;
	
	
	if (pointcontents(self.origin - '0 0 1') != CONTENT_SOLID)
		self.origin = self.origin - '0 0 1';
	
	self.angles = self.oldangles;	
		

		
		
	if (self.owner.has_flag && (self.owner.items & IT_KEY2) && self.owner.health > 0)
	{
		makevectors(self.owner.angles);
		setorigin(self, self.owner.origin + v_forward*-20 + v_right*5 + v_up*-10);
		
		self.angles = self.owner.angles;
		
		
	}
	else if (!self.athome)
	{
		self.carrier = world;
		RED_CARRIED = 0;
		if (pointcontents(self.origin) == CONTENT_LAVA || pointcontents(self.origin) == CONTENT_SLIME)
			flag_return();
		if (time - self.delay >= 30)
		{
			flag_return(); //if x amount of time has passed without anyone grabbing the flag return flag to base
			self.delay = time;
		}
		
	}

	if (self.athome && RED_CAP_COOLDOWN > 0)
		RED_CAP_COOLDOWN--;
	
	self.think = flag_run_red;
	self.nextthink = time+0.03;

}

void() flag_return =
{
	if (self.carrier != world)
		return;
	if (self.owner.has_flag == 1)
		return;
		
	if (self.athome == 0)
		self.athome = 1;
	
	if (self.origin == self.oldorigin)
		return;
	
	setorigin(self, self.oldorigin);
	
	
		
	
		if (self.netname == "blue flag")
		{
			if (!BLUE_CAP_COOLDOWN)
			{
				self.think = flag_run_blue;
				BLUE_CARRIED = 0;
				broadcast_string("", strcat("^4", self.netname, "^7 has been returned!"));
				self.touch = flag_touch_blue;
				sound(self, CHAN_AUTO, self.noise, 1, ATTN_NONE);
			}
			
		}
		else
		{
			if (!RED_CAP_COOLDOWN)
			{
				self.think = flag_run_red;
				RED_CARRIED = 0;
				//if(other != world)
				broadcast_string("", strcat("^1", self.netname, "^7 has been returned!"));
				self.touch = flag_touch_red;
				sound(self, CHAN_AUTO, self.noise, 1, ATTN_NONE);
			}
			
		}
		
	
	//broadcast_string(self.netname, "returned!");
		
	self.nextthink = time + 0.1;
}

void() flag_touch_blue =
{
	if (self.carrier != world)
		return;
	if (other.classname != "player")
		return;
	if (self.origin != self.oldorigin && other.side == BLUE && self.athome == 0 && !self.owner.has_flag && !BLUE_CARRIED)
	{
		if (self.carrier != other)
		{
			self.think = flag_return;
			self.nextthink = time + 0.1;
		}
	}
	if (other.side == BLUE && !(other.has_flag))
		return;
	
	if (other.side == RED && other.classname == "player")
		self.owner = other;
		
	if (other.team == BLUE && other.ishuman != 1)
		other.bot_flagrunner = 1;
		
	
	if ((!other.has_flag && other.health > 0 && other.side != self.side && !BLUE_CARRIED) || (other.ishuman != 1 && !BLUE_CARRIED && other.team != self.side))
	{
		self.athome = 0;
		//self.think = flag_run;
		other.items += IT_KEY1;
		
		self.carrier = other;
		
		//self.nextthink = time;
		stuffcmd (other, "bf\n");
		other.has_flag = 1;
		if (BLUE_CAP_COOLDOWN == 0)
		{
			broadcast_string(other.netname, strcat("stole the ^4", self.netname, "^7!"));
			sound(self, CHAN_ITEM, self.noise2, 1, ATTN_NONE);
		}
		//centerprint3 (other, "You stole the ", self.netname, "!");
		
		BLUE_CARRIED = 1;
		
	}
	else if (other.has_flag && other.side == BLUE && self.athome == 1)
	{
		self.nextthink = time + 0.1;
		capture();
		other.items -= IT_KEY2;
		other.has_flag = 0;
		//self.owner = world;
		
	}
	
	
}

void() flag_touch_red =
{
	if (self.carrier != world)
		return;
	if (other.classname != "player")
		return;
	if (self.origin != self.oldorigin && (other.side == RED && other.ishuman == 1) && self.athome == 0 && !self.owner.has_flag && !RED_CARRIED)
	{
		if (self.carrier != other)
		{
			self.think = flag_return;
			self.nextthink = time + 0.1;
		}
	}
	if (other.side == RED && !(other.has_flag))
		return;
	
	if (other.side == BLUE && other.classname == "player")
		self.owner = other;
	
		
	if (other.team == BLUE && other.ishuman != 1)
		other.bot_flagrunner = 1;
	
	if ((!other.has_flag && other.health > 0 && other.side != self.side && !RED_CARRIED) || (other.ishuman != 1 && !RED_CARRIED && other.team != self.side))
	{
		self.athome = 0;
		//self.think = flag_run;
		other.items += IT_KEY2;
		
		self.carrier = other;
		
		//self.nextthink = time;
		stuffcmd (other, "bf\n");
		other.has_flag = 1;
		//centerprint3 (other, "You stole the ", self.netname, "!");
		if (RED_CAP_COOLDOWN == 0)
		{
			broadcast_string(other.netname, strcat("stole the ^1", self.netname, "^7!"));
			sound(self, CHAN_ITEM, self.noise2, 1, ATTN_NONE);
		}
		RED_CARRIED = 1;
		
	}
	else if (other.has_flag && other.side == RED && self.athome == 1)
	{
		self.nextthink = time + 0.1;
		capture();
		other.items -= IT_KEY1;
		other.has_flag = 0;
		//self.owner = world;
		
	}
	
	
	/*if (other.netname == "blue flag")
	{
		self.athome = 1;
		self.origin = self.oldorigin;
		setorigin (self,self.origin);
	}*/
}

void() CTF_Precache =
{
	precache_sound ("doors/runetry.wav");
	precache_sound ("ctf/flag/flagcap.wav");
	precache_sound ("ctf/flag/flagtk.wav");
	
	precache_model ("progs/flag.mdl");
}



void() item_flagblue =
{
	FLAG_COUNT++;
	
	if (FLAG_COUNT > 2)
		remove(self);
	
	CTF_Precache();
	
	self.touch = flag_touch_blue;
	self.items = IT_KEY1;
	self.oldorigin = self.origin;
	
	self.netname = "blue flag";
	//setsize (self, '-16 -16 -24', '16 16 32');
	setmodel(self, "progs/flag.mdl");
	self.side = BLUE;
	self.oldangles = self.angles;
	
	self.scale = 1.3;
	
	self.noise = "doors/runetry.wav"; //flag returned noise
	self.noise1 = "ctf/flag/flagcap.wav"; //flag capture noise
	self.noise2 = "ctf/flag/flagtk.wav"; //flag stolen noise
	
	self.effects = EF_FULLBRIGHT | EF_LOWPRECISION;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	
	if (world.model == "maps/e1m2.bsp")
	{
		setorigin(self, self.origin + '0 0 20');
		setsize(self, VEC_HULL_MIN + '0 0 10', VEC_HULL_MAX + '0 0 10');
	}
	
	//self.light_lev = 360;
	//self.color = '0 0 1';
	
	//self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW;
	self.traileffectnum = particleeffectnum("blue_flag");
	
	self.athome = 1; // flag is at base
	
	self.think = flag_run_blue;
	self.nextthink = time;
	
	
	
	//self.flags = FL_ITEM;		// make extra wide
	
	
	//StartItem ();
};

void() item_flagred =
{
	FLAG_COUNT++;
	
	if (FLAG_COUNT > 2)
		remove(self);
	
	CTF_Precache();
	
	self.touch = flag_touch_red;
	self.items = IT_KEY2;
	self.oldorigin = self.origin;
	self.netname = "red flag";
	
	//setsize (self, '-16 -16 -24', '16 16 32');
	setmodel(self, "progs/flag.mdl");
	self.skin = 1; // red flag skin
	//self.movetype = MOVETYPE_TOSS;
	self.side = RED;
	self.oldangles = self.angles;
	
	self.scale = 1.3;
	
	self.noise = "doors/runetry.wav"; //flag returned noise
	self.noise1 = "ctf/flag/flagcap.wav"; //flag capture noise
	self.noise2 = "ctf/flag/flagtk.wav"; //flag stolen noise
	
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX + '0 0 10');
	
	self.effects = EF_FULLBRIGHT | EF_LOWPRECISION;
	self.traileffectnum = particleeffectnum("red_flag");
	//self.light_lev = 360;
	//self.color = '1 1 0';
	
	//self.pflags = PFLAGS_FULLDYNAMIC | PFLAGS_NOSHADOW;
	
	self.athome = 1; //flag is at base
	
	self.think = flag_run_red;
	self.nextthink = time;
	
	//self.flags = FL_ITEM;		// make extra wide
	
	
	//StartItem ();
};

void() info_player_team1, info_player_team2;


//if it cannot find a suitable spawn point check 4 directions from flag and create a team spawnpoint

vector(vector org) createspawn =
{
	makevectors (self.angles);
	vector orgf, orgb, orgl, orgr;
	orgf = org + v_forward*400;
	orgb = -orgf;
	orgr = org + v_right*400;
	orgl = -orgr;
	
	if (pointcontents(orgf) != CONTENT_SOLID)
		return orgf;
	else if (pointcontents(orgb) != CONTENT_SOLID)
		return orgb;
	else if (pointcontents(orgr) != CONTENT_SOLID)
		return orgr;
	else if (pointcontents(orgl) != CONTENT_SOLID)
		return orgl;
	else
		return org;
}

void(vector spawnorg) makeTeamSpawns =
{
	local entity spawnblue, spawnred, findstart;
	local vector distance;
	
	if (self.classname == "info_player_start")
	{
		findstart = spawn();
		findstart = find(world, classname, "info_player_deathmatch");
		distance = self.origin - findstart.origin;
		
		if (!findstart)
			findstart = find(world, classname, "path_corner");
		distance = self.origin - findstart.origin;
			
		if (findstart && (vlen(distance) < 2700))
		{
			print(strcat("converting ", findstart.classname, " to red spawn\n\n"));
				
			spawnred = spawn();
			spawnred.origin = findstart.origin;
			spawnred.think = info_player_team1;
			spawnred.nextthink = time;
		
		}
		else
		{
			spawnred = spawn();
			spawnred.origin = createspawn(spawnorg); 
			spawnred.think = info_player_team1;
			spawnred.nextthink = time;	
		}			
		
	}
	else if (self.classname == "trigger_changelevel")
	{
		findstart = find(world, classname, "info_player_deathmatch");
		distance = self.origin - findstart.origin;
		
		if (!findstart)
			findstart = find(world, classname, "path_corner");
		distance = self.origin - findstart.origin;
			
		if (findstart && (vlen(distance) < 2700))
		{
			print(strcat("converting ", findstart.classname, " to blue spawn\n\n"));
				
			spawnblue = spawn();
			spawnblue.origin = findstart.origin; //+ v_forward*30;
			spawnblue.think = info_player_team2;
			spawnblue.nextthink = time;
		
		}
		else
		{
			spawnblue = spawn();
			spawnblue.origin = createspawn(spawnorg); //+ v_forward*30;
			spawnblue.think = info_player_team2;
			spawnblue.nextthink = time;

			
		}
		
	}
	remove(self);
}

void(vector loc) ctf_replacer =
{
	if (self.classname == "info_player_start")
	{
		local entity findred;
		findred = find(world, netname, "red flag");
		if (!findred)
		{
			local entity replacerred = spawn();
			
			replacerred.origin = loc;
			replacerred.think = item_flagred;
			replacerred.nextthink = time;
			
			makeTeamSpawns(replacerred.origin);
			
			//remove(self);
		}
	}
	else if (self.classname == "trigger_changelevel")
	{
		local entity replacerblue = spawn();
		replacerblue.origin = loc;
		replacerblue.think = item_flagblue;
		replacerblue.nextthink = time;
		
		makeTeamSpawns(replacerblue.origin);
		
		//remove(self);
	}
}


//Threewave compatibility
void() item_flag_team1 =
{
	if (world.model == "maps/ctf8.bsp")
		self.origin = self.origin + '0 0 16';
	item_flagred();
}
	
void() item_flag_team2 =
{
	if (world.model == "maps/ctf8.bsp")
		self.origin = self.origin + '0 0 16';
	item_flagblue();
}

void() info_player_team1 =
{self.side = RED;
self.netname = "red start";};

void() info_player_team2 =
{self.side = BLUE;
self.netname = "blue start";};

