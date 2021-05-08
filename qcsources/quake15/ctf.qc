/*
	RMQ CTF
	
	2009-09-29 Supa initial implementation, TODO: ?runes? (spawn two at our flag ala Q3 3WCTF), flag models, flag sounds, scoring, bot support, if team specific spawns exist initial player spawns will use those
	2009-09-30 Supa i swear i hate these migraines so much i could vomit oh hey i just did DONE: flag models, fixed capture & flag restore logic, fixed carried flag offsets, basically everthing that was broken last night TODO: write DEF/FGD entries, fix flag positioning - refer to ctf1.bsp for proper positions of 3WCTF flags, looks like we need to nudge the bboxes up
	2009-10-01 Supa I get this sinking feeling that I've forgot something important, will need to raid the 3WCTF docs in the future to check if we're missing anything DONE: Adjusted flag bboxes so they'll stop hovering in midair
	2009-10-14 Supa is it october already? really? DONE: added CTF AI events
	2009-10-19 Supa Still trying to figure out why bots are losing flag targets DONE: Redid more CTF AI event triggers
	2009-10-20 Supa fixed a stupid touchlinks-infringing oversight that crashinated fitzquake after a flag return
	2009-11-24 Supa added team specific initial spawns
	2009-11-25 Supa added flag capture sfx
*/

// defs moved to defs_ctf.qc

void() StartItem;

void(float addfrags, float whatteam) AddFragsToTeam =
{
	local entity head;

	head = find (world, classname, "player");
	while (head)
	{
		if (head.assigned_team == whatteam)
			head.frags = head.frags + addfrags;
			
		head = find (head, classname, "player");
	}
};

void(string whatstring, float whatteam) CenterprintToTeam =
{
	local entity head;

	head = find (world, classname, "player");
	while (head)
	{
		if (head.assigned_team == whatteam)
		{
			head.motd_wait = time + 2;	// sigh, CheckMOTD issues
		
			centerprint(head, whatstring);
		}
			
		head = find (head, classname, "player");
	}
};

void() DropFlag =	// called by killed() in CTF
{
	local float whichteam;

	local entity placeholder;
	
	// this is kind of clumsy
	if		(red_flag.owner	== self)	placeholder = red_flag;
	else if (blue_flag.owner == self)	placeholder = blue_flag;
	else	{dprint("\bDropFlag\b: what happen? Non-FC called DropFlag, aborting\n");	return;}	// barf and run away

	setorigin(placeholder, self.origin - '0 0 24');
	
	bprint(self.netname);
	bprint(" \bdropped\b the ");
	if (placeholder == blue_flag)	bprint("\bBLUE\b flag!\n");
	else							bprint("\bRED\b flag!\n");

	placeholder.velocity_z = 300;
	placeholder.velocity_x = self.velocity_x;
	placeholder.velocity_y = self.velocity_y;

	if (!self.ishuman)	// bot FC? switch their role if so
	{
		self.ctf_role		= MIDFIELDER;
		self.ctf_roletime	= time + 15;
	}
	
	placeholder.owner = world;
	placeholder.solid = SOLID_TRIGGER;
	placeholder.movetype = MOVETYPE_TOSS;

	placeholder.touch = flag_touch;

	placeholder.cnt			= time + 20;	// return after 20s, down from 45s
	placeholder.nextthink	= time + 0.5;	// check if we've entered slime||lava and return if so
	placeholder.think		= flag_dropped_think;
	
	CenterprintToTeam("\bYour flag was dropped!\b\n", placeholder.assigned_team);
	
	if (placeholder.assigned_team == RED)	whichteam = BLUE;
	else									whichteam = RED;
		
	CenterprintToTeam("\bWe lost the enemy flag!\b\n", whichteam);
	
	// tell our team to return the flag, tell enemies to take the dropped flag
	AssignTeam_TakeDroppedEnemyFlag(placeholder.assigned_team);
	AssignHostiles_ReturnOurFlag(placeholder.assigned_team);
};

void() flag_dropped_think =	// return after 20s or if we enter dangerous liquids
{
	local entity placeholder, placeholder_flagbase;

	if (pointcontents(self.origin)	<= CONTENT_SLIME	||	// CONTENT_SLIME -4, CONTENT_LAVA -5 - return if we enter slime||lava
		self.cnt < time									)	// always return after 45s
	{
		if (blue_flag == self)	bprint("The \bBLUE\b ");
		else					bprint("The \bRED\b ");
		bprint("flag was returned!\n");
	
//		sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NONE);
	
		if (blue_flag == self)	{placeholder = blue_flag;	placeholder_flagbase = blue_flagbase;	}
		else					{placeholder = red_flag;	placeholder_flagbase = red_flagbase;	}
	
		setorigin (placeholder, placeholder.originhack);
	
		// restore everything
		
		placeholder.owner = world;
			
		placeholder.think = SUB_Null;
		placeholder.touch = flag_touch;
		placeholder.solid = SOLID_TRIGGER;
		placeholder.angles = placeholder_flagbase.angles;
		
		placeholder.cnt = 0;
		
		placeholder.velocity = '0 0 0';
		
		CenterprintToTeam("\bYour flag was returned!\b\n", placeholder.assigned_team);
		
		AssignTeam_DefendTheBase(placeholder.assigned_team);
		
		return;	// BACK FROM WHENCE YOU CAME
	}
	
	// okay, let's burn processor time on AI
	
	placeholder = findradius(self.origin, 1024);
	
	while (placeholder)		// check for nearby bots, tell hostiles to attack and take the flag, tell friendlies to chase and return the flag
	{
		if (placeholder.flags & FL_CLIENT	)
		if (!placeholder.ishuman			)
		if (!placeholder.observer			)	// this will never happen, and if it ever does then we may as well assume causality has been shattered, rendering existence a nightmare without beginning or end, etc
		{
			if	(placeholder.assigned_team == self.assigned_team)	{placeholder.ctf_role = CHASER;		placeholder.ctf_roletime = time + 9999999;	}
			else													{placeholder.ctf_role = ATTACKER;	placeholder.ctf_roletime = time + 180;		}
		}

		placeholder = placeholder.chain;
	}
	
	self.nextthink = time + 0.5;
};

void() flag_carried_think =
{
	setorigin (self, self.owner.origin - '0 0 16');

	self.nextthink = time + 0.05;

	self.angles = self.owner.angles + '0 90 -20';	// offset so it looks nicer
	self.angles_x = 0;
};

void() flag_restore = // restore touch/solid after capping + restore origin one frame later in order to avoid irritating sv_touchlinks
{
	setorigin (self, self.originhack);

   	self.touch = flag_touch;
	self.solid = SOLID_TRIGGER;
	
	self.think = SUB_Null;
};

void() flagbase_touch =
{
	local float you_may_cap;
	local entity placeholder, placeholder_flagbase;

	if (other.health		<= 0					)	return;
	if (other.classname		!= "player"				)	return;
	if (other.assigned_team != self.assigned_team	)	return;	// only friendlies can cap here
	
	if (red_flagbase	== self		)
	if (blue_flag.owner	== other	)
	if (red_flag.cnt	== 0		)	// true if the flag is at base or held ..
	if (red_flag.owner	== world	)	// .. so we need to check if the enemy has it
		you_may_cap = TRUE;	// only respond to flag carriers, and only if the flag is at the base
	
	if (blue_flagbase	== self		)
	if (red_flag.owner	== other	)
	if (blue_flag.cnt	== 0		)
	if (blue_flag.owner == world	)
		you_may_cap = TRUE; // ditto

	if (!you_may_cap)
		return;
		
	bprint(other.netname);
	bprint(" \bcaptured\b the ");
	if (self.assigned_team == RED)	bprint("\bBLUE\b flag!\n");
	else							bprint("\bRED\b flag!\n");

	// cap bonus
	AddFragsToTeam(10, other.assigned_team);
	
	sound(other, CHAN_ITEM, "misc/capture.wav", 1, ATTN_NONE);
	stuffcmd (other, "bf\n");
	
// need to award points here

	if (red_flagbase == self)	{placeholder = blue_flag;	placeholder_flagbase = blue_flagbase;	}
	else						{placeholder = red_flag;	placeholder_flagbase = red_flagbase;	}

//	setorigin (placeholder, placeholder.originhack);

// restore everything
	
	placeholder.cnt = 0;	// mostly used to tell if the flag is at base, held or dropped - at base is .cnt 0, .touch flag_touch, held is .cnt 0 .touch sub_null, dropped is .cnt !0 .touch flag_touch - yeah, I know
	
	placeholder.owner = world;
		
   	placeholder.think = flag_restore;	// okay, I'm dumb, apparently I can't restore .touch and SOLID_TRIGGER until the next frame, okay
	placeholder.nextthink = time;
//   	placeholder.touch = flag_touch;
//	placeholder.solid = SOLID_TRIGGER;
	
	placeholder.angles = placeholder_flagbase.angles;
	
	// tell our escorts and carrier to defend, tell hostile chasers to attack now
	if (!other.ishuman)
	{
		other.ctf_role		= DEFENDER;
		other.ctf_roletime	= time + 15;
	}
	
	CenterprintToTeam	("\bYour team captured the enemy flag!\b\n",	other.assigned_team			);
	CenterprintToTeam	("\bThe enemy has captured your flag!\b\n",	placeholder.assigned_team	);

	centerprint			(other,	"\bYou captured the enemy flag!\b\n");
	
	AssignTeam_DefendTheBase(placeholder.assigned_team);
	AssignHostiles_AttackTheBase(placeholder.assigned_team);
};

void() flag_touch =
{
	local float whichteam;

	local entity placeholder, placeholder_flagbase;

	if (other.health		<= 0					)	return;
	if (other.classname		!= "player"				)	return;
	if (other.assigned_team == self.assigned_team	&&
		self.cnt			== 0					)	return;	// only give the flag to a hostile unless dropped, in which case we allow friendlies to return it

	bprint(other.netname);

	stuffcmd (other, "bf\n");

	if (self.cnt			!= 0					&&
		other.assigned_team == self.assigned_team	)	// returned
	{
		bprint(" \breturned\b the ");
	
		// award return bonus
		other.frags = other.frags + 2;
	
//	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NONE);	

		if (blue_flag == self)	{placeholder = blue_flag;	placeholder_flagbase = blue_flagbase;	}
		else					{placeholder = red_flag;	placeholder_flagbase = red_flagbase;	}
	
//		setorigin (placeholder, placeholder.originhack);
	
		// restore everything

		placeholder.cnt = 0;
		
		placeholder.owner = world;
			
		placeholder.think = flag_restore;	// okay, I'm dumb, apparently I can't restore .touch and SOLID_TRIGGER until the next frame, okay
		placeholder.nextthink = time;

//		placeholder.touch = flag_touch;
//		placeholder.solid = SOLID_TRIGGER;
		
		placeholder.angles = placeholder_flagbase.angles;
		
		placeholder.velocity = '0 0 0';	// as fun as it may be to sit right next to a flying flag and let it inherit velocity by returning it before it lands, it tends to drive the bots mad.
		
		/*
		// check if a carrier returned the flag and return their role if so
		
		if (red_flag.owner	== other	||
			blue_flag.owner	== other	)
		{
			other.ctf_role		= CARRIER;
			other.ctf_roletime	= time + 9999999;
		}*/
		
		CenterprintToTeam("\bYour flag was returned!\b\n", placeholder.assigned_team);
		
		if (placeholder.assigned_team == RED)	whichteam = BLUE;
		else									whichteam = RED;
		
		CenterprintToTeam("\bThe enemy flag was returned!\b\n", whichteam);
		
		AssignTeam_DefendTheBase(placeholder.assigned_team);
	}
	else	// taken
	{
		bprint(" \btook\b the ");
	
		// award take bonus
		other.frags = other.frags + 2;
	
//	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NONE);
	
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;
		self.movetype = MOVETYPE_NONE;	// for when a dropped flag is picked up
		
//		setorigin (self, other.origin);
	
		self.cnt = 0;
	
		self.owner = other;	// start updating position every x time
		
		self.think = flag_carried_think;
		self.nextthink = time; //+ 0.05;	// update next frame, then @ 20hz

		if (!other.ishuman)	// sigh
		{
			other.ctf_role		= CARRIER;
			other.ctf_roletime	= time + 9999999;
		}
		
		CenterprintToTeam	("\bYour team has the enemy flag!\b\n",	other.assigned_team	);
		CenterprintToTeam	("\bYour flag was taken!\b\n",			self.assigned_team	);
		
		centerprint			(other, "\bYou have the enemy flag!\b\n");
		
		// tell the carrier's teammates to escort, tell the flag owners to chase
		AssignHostiles_EscortFlagCarrier(self.assigned_team);
		AssignTeam_ReturnOurFlag(self.assigned_team);
	}
	
	if (self.assigned_team == BLUE) bprint("\bBLUE\b flag!\n");
	else							bprint("\bRED\b flag!\n");
};


void(entity flag) spawn_flagbase =
{
	local entity helper, stemp;

	helper = spawn();
	
	setsize (helper, VEC_HULL_MIN, VEC_HULL_MAX);
	
	helper.dest		= VEC_HULL_MIN;	// working around falling out of level issues in the same way we fixed shard/vial pickups
	helper.dest2	= VEC_HULL_MAX;
	
	setorigin (helper, flag.origin);

	helper.angles = flag.angles;	// so the flag's angles can be retrieved later
	
	helper.flags = FL_ITEM;			// make flag caps a little easier
	helper.solid = SOLID_TRIGGER;	// so it can picked up by findradius
	
	helper.assigned_team = flag.assigned_team;
	helper.touch = flagbase_touch;
	helper.owner = flag;
	
	helper.ctf_item = TRUE;
	
	helper.classname = "flagbase";

	if (flag.assigned_team == RED)		red_flagbase = helper;
	else								blue_flagbase = helper;
	
	stemp = self;
	self = helper;	// how many times have you seen this before? yeah, I know
	
	StartItem();
	
	self = stemp;
};

void() item_flag_blue =
{
	if (gametype != CTF		&&
		gametype != CTF_FF	)	// don't spawn in non-CTF games
	{
		remove(self);
		return;
	}
	
	precache_sound ("misc/capture.wav");

	precache_model ("progs/flag.mdl");
	setmodel (self, "progs/flag.mdl");
	setsize (self, '-16 -16 0', '16 16 74');

	blue_flag = self;
	self.assigned_team = BLUE;
	
	self.ctf_item = TRUE;
	
	spawn_flagbase(self);
	
	Spawn_TeamBrain(self.assigned_team);
	
	self.classname = "item_flag_blue";
	self.skin = 1;

	self.touch = flag_touch;

	StartItem();
}

void() item_flag_red =
{
	if (gametype != CTF		&&
		gametype != CTF_FF	)	// don't spawn in non-CTF games
	{
		remove(self);
		return;
	}

	precache_sound ("misc/capture.wav");
	
	precache_model ("progs/flag.mdl");
	setmodel (self, "progs/flag.mdl");
	setsize (self, '-16 -16 0', '16 16 74');
	
	red_flag = self;
	self.assigned_team = RED;
	
	self.ctf_item = TRUE;
	
	spawn_flagbase(self);
	
	Spawn_TeamBrain(self.assigned_team);
	
	self.classname = "item_flag_red";
	self.skin = 0;

	self.touch = flag_touch;

	StartItem();
};

// 3WCTF flag ent support
void() item_flag_team1 = {item_flag_red();	};
void() item_flag_team2 = {item_flag_blue();	};

void() info_player_redspawn		= {if (!deathmatch)	remove(self);	}; // initial spawn point for red players
void() info_player_bluespawn	= {if (!deathmatch)	remove(self);	}; // ... and for blue

// 3WCTF spawn support
void() info_player_team1 = {info_player_redspawn();	};
void() info_player_team2 = {info_player_bluespawn();};