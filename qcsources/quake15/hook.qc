//====================================================================
//
// SWINGING GRAPPLING HOOK			by: Perecli Manole AKA Bort
//
//====================================================================
// Aside from this new file, the following are the modifications
// done to id's original source files:
//--------------------------------------------------------------------
// File: Progs.src
// Location: before the "weapons.qc" line
// Added: hook.qc
//--------------------------------------------------------------------
// File: Client.qc
// Procedure: PlayerPostThink
// Location: before line "W_WeaponFrame ();"
// Added: CheckGrapHook ();
//--------------------------------------------------------------------
// File: World.qc
// Procedure: worldspawn
// Location: after line "precache_model ("progs/s_spike.mdl");"
// Added: precache_model ("progs/hook.mdl");
//        precache_model ("progs/chain.mdl");
//--------------------------------------------------------------------
// File: Weapons.qc
// Procedure: W_Precache
// Location: end of procedure
// Added: precache_sound ("shambler/smack.wav");
//        precache_sound ("hook/chain1.wav");
//        precache_sound ("hook/chain2.wav");
//        precache_sound ("hook/retract.wav");
//--------------------------------------------------------------------


// prototypes
void(vector org, vector vel, float damage) SpawnBlood;
float () crandom;	

// new player entity bit flag 
.float hook;
float	HOOK_ON 	= 1;		// set if hook command is active
float HOOK_IN	= 2;		// set if hook has attached
float SHRINK_ON 	= 4;		// set if shrink chain is active 
float GROW_ON 	= 8;		// set if grow chain is active

// impulse constants
float I_HOOK 		= 98;
float	I_GROW 		= 97;
float	I_SHRINK	 	= 96;
float	I_STOP	 	= 95;

// constants
float MIN_CHAIN_LEN 	= 40;		// minimum chain length
float MAX_CHAIN_LEN 	= 1000;	// maximum chain length
float CHAIN_LINK_LEN	= 55;		// length between chain link origins
float GROW_SHRINK_RATE 	= 40;		// units of lengthen/shrink chain in 0.1 sec


//--------------------------------------------------------------------
// Removes hook and detaches player
//--------------------------------------------------------------------
void () DropHook =
{
      local entity linkptr;
      local entity nextptr;

	// remove all hook flags
	self.owner.hook = 0;

	// removes hook and chain
	linkptr = self;
	while (linkptr != world)
	{
		nextptr = linkptr.goalentity;
		remove (linkptr);
		linkptr = nextptr;
	}

	sound7(self.owner, CHAN_AUTO, "hook/retract.wav", 1, ATTN_NORM, SNDSPD);	
	self.owner.swing = 0;
};


//--------------------------------------------------------------------
// Spawn and removes and refreshes chain links
//--------------------------------------------------------------------
void () MaintainLinks =
{
	local vector chainvec;		// vector of the chain 
	local vector chainunit; 	// vector of chain with distance of 1
	local float chainlen;		// length of chain
	local entity newlink;		// pointer to chain link being added
	local entity currlink;		// pointer to current link being traversed
	local entity nextlink;		// pointer to next link after current link
	local float currpos;		// numeric position of currlink
	local float linknum;		// number of links that should exist
	local float linkstart;		// length from hook at which currlink starts
	local vector p_self_origin;	// predicted future hook origin

	// predicts hook's future position since chain links fall behind
	currpos = vlen(self.velocity) / 22;   // currpos used here just as an intermediate value
	p_self_origin = self.origin + normalize(self.velocity) * currpos;

      // get info about chain
	chainvec = ((self.owner.origin + '0 0 16') - p_self_origin);
	chainunit = normalize(chainvec);
	chainvec = chainvec - chainunit * 18;
	chainlen = vlen(chainvec);

	currlink = self;
	currpos = 0;
	

	// generate and refresh links
	linknum = ceil(chainlen / CHAIN_LINK_LEN);    
	while (currpos < linknum)
	{
		// add entities if chain's length grows
		if (currlink.goalentity == world)
		{
			newlink = spawn();
			newlink.movetype = MOVETYPE_NOCLIP;
			newlink.solid = SOLID_NOT;
			setmodel (newlink, "progs/chain.mdl");
			setsize (newlink, '0 0 0', '0 0 0');
			newlink.goalentity = world;
			currlink.goalentity = newlink;
		}
		currlink = currlink.goalentity;
		currpos = currpos + 1;
		
		// set angles 
		currlink.angles = vectoangles(chainvec);
		
		/*if (!self.owner.button0 && !(self.owner.flags & FL_ONGROUND) && ((checkUPS_forward(self.owner) > 20) || (checkUPS_forward(self.owner) < -20)))
		{
			local vector checkang = vectoangles(self.owner.velocity);
			self.owner.angles = checkang;
			self.owner.angles_z = currlink.angles_z;
		}*/

		// fixes vectoangles round off error
		if ((currlink.angles_y > 0) && (currlink.angles_y < 180))
			currlink.angles = currlink.angles + '0 1 0';

		// vibrates chain links on the z axis
		currlink.angles_z = currlink.angles_z + crandom() * 8;

		// set position and frames 
		linkstart = (currpos - 1) * CHAIN_LINK_LEN;
		if (currpos < linknum)
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + CHAIN_LINK_LEN / 2 ));
			currlink.frame = 9;
		}
		else
		{
			setorigin (currlink, p_self_origin + chainunit * (linkstart + (chainlen - linkstart) / 2 ));
			currlink.frame = floor((chainlen - linkstart) / CHAIN_LINK_LEN * 10);
		}
	}
	
	// remove remaining entities if chain's length shrinks
	nextlink = currlink.goalentity;
	currlink.goalentity = world;
	currlink = nextlink;
	while (currlink != world)
	{
		nextlink = currlink.goalentity;
		remove (currlink);
		currlink = nextlink;
	}
};


//--------------------------------------------------------------------
// Hook behavior function
//--------------------------------------------------------------------
void () HookBehavior =
{
      local vector chainvec;		// chain vector
	local vector velpart;		// player's velocity component moving to or away from hook
	local float chainlen;		// length of extended chain
	local float framestep;		// grow or shrink step per frame
	local float f1, f2;		// restrainment forces
		      
	// decide when to disconnect hook
	if (  (!(self.owner.hook & HOOK_ON)) ||		// if hook has been retracted
		(self.owner.teleport_time > time) || 	// if player goes through teleport
		(self.owner.view_ofs == '0 0 0') ||		// if intermission or finale
		(self.owner.deadflag) ||			// if player dies
		(self.enemy.solid == SOLID_NOT)	)	// if target dies
	{
		DropHook();
		return;
	}

	// gives hook same velocity as the entity it is stuck in
	self.velocity = self.enemy.velocity;

// chain sizing 

	// grow the length of the chain
	if ((self.owner.hook & GROW_ON) && (self.armorvalue < MAX_CHAIN_LEN))
	{
		if (time - self.ltime > 0.1) self.ltime = time - 0.1;
		framestep = 10 * (time - self.ltime) * GROW_SHRINK_RATE;
		self.armorvalue = self.armorvalue + framestep;
		if (self.armorvalue > MAX_CHAIN_LEN) self.armorvalue = MAX_CHAIN_LEN;
		self.ltime = time;

		// trigger climb sound
		if (time - self.delay >= 0.1)
		{
			sound7(self.owner, CHAN_AUTO, "hook/chain1.wav", 0.8, ATTN_NORM, SNDSPD);
			self.delay = time;
		}
	}

	// shrink the length of the chain
 	if ((self.owner.hook & SHRINK_ON) && (self.armorvalue > MIN_CHAIN_LEN))
	{
		if (time - self.ltime > 0.1) self.ltime = time - 0.1;
		framestep = 10 * (time - self.ltime) * GROW_SHRINK_RATE;
		self.armorvalue = self.armorvalue - framestep;
		if (self.armorvalue < MIN_CHAIN_LEN) self.armorvalue = MIN_CHAIN_LEN;
		self.ltime = time;

		// trigger slide sound
		if (time - self.delay >= 0.1)		
		{
			sound7(self.owner, CHAN_AUTO, "hook/chain2.wav", 0.8, ATTN_NORM, SNDSPD);
			self.delay = time;
		}
	}

// chain physics

      chainvec = self.origin - (self.owner.origin + '0 0 16');
	chainlen = vlen (chainvec);

	// if player's location is beyond the chain's reach
	if (chainlen > self.armorvalue)	
	{	 
		// determine player's velocity component of chain vector
		velpart = chainvec * ((self.owner.velocity * chainvec) / (chainvec * chainvec));
		
		// restrainment default force 
		f2 = (chainlen - self.armorvalue) * 5;

		// if player's velocity heading is away from the hook
		if ((self.owner.velocity * chainvec) < 0)
		{
			// if chain has streched for 25 units
			if (chainlen > self.armorvalue + 25)
				// remove player's velocity component moving away from hook
				self.owner.velocity = self.owner.velocity - velpart; 
			f1 = f2;
		}
		else  // if player's velocity heading is towards the hook
		{
			if (vlen(velpart) < f2)
				f1 = f2 - vlen(velpart);
			else		
				f1 = 0;
		}
	}
	else
		f1 = 0;
	
      // applys chain restrainment 
	self.owner.velocity = self.owner.velocity + normalize(chainvec) * f1;
	
	//prevents sticking on the ground caused by built in friction routines
	if (self.owner.velocity_z > (cvar("sv_gravity") / 20))
		self.owner.flags = self.owner.flags - (self.owner.flags & FL_ONGROUND);

	MaintainLinks ();

	self.nextthink = time + 0.01;
};


//--------------------------------------------------------------------
// Hook's touch function
//--------------------------------------------------------------------
void() HookTouch =
{
	local vector spray;		// for blood

	// armorvalue is used to hold current length of chain
	self.armorvalue = vlen (self.origin - (self.owner.origin + '0 0 16'));	

	// don't attach hook to sky
	if (	(!(self.owner.hook & HOOK_ON)) || 
		(pointcontents(self.origin) == CONTENT_SKY)  )
	{		
		DropHook();
		return;
	}

	// flags hook as being attached to something
	self.owner.hook = self.owner.hook | HOOK_IN;

	if (other.takedamage)
		T_Damage (other, self, self.owner, 10 );

 	if (other.solid == SOLID_SLIDEBOX)
	{
		sound7(self, CHAN_AUTO, "shambler/smack.wav", 1, ATTN_NORM, SNDSPD);
	      
            // three different length blood sprays
		spray_x = 40 * crandom();
		spray_y = 40 * crandom();
		spray_z = 40 * crandom();
		SpawnBlood (self.origin, spray, 10);
		spray_x = 80 * crandom();
		spray_y = 80 * crandom();
		spray_z = 80 * crandom();
		SpawnBlood (self.origin, spray, 10);
		spray_x = 120 * crandom();
		spray_y = 120 * crandom();
		spray_z = 120 * crandom();
		SpawnBlood (self.origin, spray, 10);

		// throw opponents
		other.velocity = other.velocity + normalize(self.velocity) * 300;
		
            DropHook();
	}
	else
	{
		sound7(self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM, SNDSPD);
		self.avelocity = '0 0 0';
	}

	self.velocity = other.velocity;

	self.enemy = other;
	self.think = HookBehavior;
	self.nextthink = time + 0.01;
	self.touch = SUB_Null;
};


//--------------------------------------------------------------------
// Limit hook length during launch 
//--------------------------------------------------------------------
void() LaunchHook =
{
      local float chainlen;			// length of extended chain
	
	chainlen = vlen (self.origin - (self.owner.origin + '0 0 16'));
	if ( (!(self.owner.hook & HOOK_ON)) || (chainlen > MAX_CHAIN_LEN) )
	{
		DropHook();
		return;
	}
		
	// trigger launch sound
	if (time - self.delay >= 0.25)
	{
			sound7(self.owner, CHAN_AUTO, "hook/chain1.wav", 0.8, ATTN_NORM, SNDSPD);
			self.delay = time;
	}
		
	MaintainLinks ();	

	self.nextthink = time + 0.02; 
};


//--------------------------------------------------------------------
// Initiates the hook
//--------------------------------------------------------------------
void(entity myself) InitiateHook =
{
	local entity newhook;

	newhook = spawn ();
	newhook.owner = myself;
	newhook.movetype = MOVETYPE_FLY;
	newhook.solid = SOLID_BBOX;
	setmodel (newhook, "progs/hook.mdl");
	setsize (newhook, '0 0 0', '0 0 0');     
	makevectors (myself.v_angle);
	setorigin (newhook, myself.origin + (v_forward*16) + '0 0 16' );
	newhook.velocity = v_forward*1000;
	newhook.angles = vectoangles(v_forward);
	newhook.avelocity = '0 0 600';
	sound7(myself, CHAN_AUTO, "hook/launch.wav", 1, ATTN_NORM, SNDSPD);
	
	sound7(myself, CHAN_AUTO, "hook/chain1.wav", 0.8, ATTN_NORM, SNDSPD);
	
	// used as pointer to first chain link
	newhook.goalentity = world;

	// smoothens clib and slide rates; tracks time between frames 
	newhook.ltime = time;  

	// keeps track of how frequent chain noise should occur 
	newhook.delay = time;   

	newhook.touch = HookTouch;
	newhook.nextthink = time + 0.01 ;     
	newhook.think = LaunchHook;
};


//--------------------------------------------------------------------
// Checks impulse
//--------------------------------------------------------------------
void() CheckGrapHook = 
{
	if ((!(self.hook & HOOK_ON)) && (self.impulse == I_HOOK))
	{
		// flags hook as being active 
		self.hook = HOOK_ON;   
		
		self.swing = 1;

		InitiateHook (self);
		return;
	}

	if (self.hook & HOOK_ON) 
	{ 
		// release hook	
		if (self.impulse == I_HOOK)
		{
			self.hook = self.hook - (self.hook & HOOK_ON);
			self.swing = 0;
			
			return;
		}

		// hop of chain and release hook when the following conditions apply
		if (	(self.button2) && 			// jump is pressed
			(self.flags & FL_JUMPRELEASED) &&	// previous jump cycle has finished
                  (self.hook & HOOK_IN) &&		// hook is attached
			(!(self.flags & FL_ONGROUND)) &&	// player not on ground
			(!(self.flags & FL_INWATER))	)	// player not in water
		{
			self.hook = self.hook - (self.hook & HOOK_ON);
			self.velocity_z = self.velocity_z + 200;
			sound7(self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM, SNDSPD);
			
			self.swing = 0;
			return;
		}

		// deactivate chain growth or shrink
		if (self.impulse == I_STOP)
		{
			self.hook = self.hook - (self.hook & (GROW_ON | SHRINK_ON));
			return;
		}
		
		if (autocvar_mp_grapple == 2)
		{
			// activate chain growth
			if (self.impulse == I_GROW) 
			{
				self.hook = self.hook | GROW_ON;
				self.hook = self.hook - (self.hook & SHRINK_ON);
				return;
			}

			// activate chain shrinking
			if (self.impulse == I_SHRINK)
			{
				self.hook = self.hook | SHRINK_ON;		
				self.hook = self.hook - (self.hook & GROW_ON);
			}
		}
	}
};