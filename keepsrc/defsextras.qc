//Written by Frank Condello <pox@planetquake.com>
//Prototypes and globals for extra junk...

// Globals ====================================================================
// Footsteps
//.float		spawnsilent;
//.vector		old_velocity;
.float frate2;
float	CAN_DROWN = 32768;				// Make an enemy able to drown

// Swimming
.float	infuncwater;	// In func_water flag (khreathor)
.float	inBSPwater;		// In regular water flag (khreathor)
.float	onSurface;		// Enemy near the surface (khreathor)
.float	drawntime;		// Delays between drawning damage (khreathor)
.float 	uwmuffle;		// underwater muffle playing flag
.float	outwsound;		// head out of water flag
.float	inwsound;		// head back in water flag
.float	drown_cnt;		// counter for drowning formula - see liquid_drown in extras_water.qc (khreathor)
.float	drown_dmg;		// damage for drowning formula - see liquid_drown in extras_water.qc (khreathor)


// No bleed triggers
.float	nobleed;

// Corpse
.string headmdl;

// func_liquid & func_ladder
.float fwatershift;
.float fwatershifttime;
.string cshift;
.string fmover;
.float drag;
.float laddertime;
.float ladderjump;
.float gravity;// actually a system global from the Mission Pack builds of Quake
.float oldgravity;
.float zerogtime;

// Swimming monsters
.entity tempgoal;

// General use
.float speed2;
.float wait2;
.string event, event2;
.string noise5;
.string	mdl2;
float START_ON = 1;
.string message2, killtarget2;

// Hipnotic Rotate
.vector neworigin;
.vector rotate;
.float  endtime;
.float  rotate_type;
.string path;
.string group;
.float	duration;

// Prototypes =================================================================

//void() extra_precache;
//void() become_corpse;
//void(float ox) spawn_ngspark;
//void() eject_shell;
void() CheckFuncWaterDeath;
void() train_ext_linkchild;
void() SUB_PushFrameMovers;
void(string action, float value) ai_fish_movement;
.float slowdowntime;