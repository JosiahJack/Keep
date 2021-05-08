//==========================================================================
//  defs2.qc -- by Patrick Martin               Last updated:  3-26-2001
//--------------------------------------------------------------------------
//  This contains more definitions that are placed here instead of in
//  'defs.qc'.
//==========================================================================

//-----------------//
//  NEW CONSTANTS  //
//-----------------//
// Borrowed from DOE source.  Used for colored explosions.
float   TE_EXPLOSION2   = 12;

// Used for Zerstorer's sf64 monsters.
float   TRIGGER_SPAWN   = 64;


//--------------------//
//  NEW EDICT FIELDS  //
//--------------------//
// Cutscenes -- Borrowed from Zerstorer.
.string     script;         //dhm - denotes which script to read.
.string		next_script;	//dhm - denotes the current script.
.string		script_num;		//dhm - number for info_scripts.
.string		camera_point;	//dhm - target for camera to move to.
.string		focal_point;	//dhm - focus point for camera.
.float		script_delay;	//dhm - time until next script.
.float		script_time;	//dhm - used for script timing.
.float		script_count;	//dhm - ditto.
.float		gravity;		//dhm - Used for dynamic gravity.

float totalmonsterspawn; //aard
entity lastmspawn;
float lasttime;
float nspawned;

//SoE: This entry was moved from combat2.qc in order to stop Frikbots
//shooting dragons on their own team.
.entity master;         // Monster's owner.

//===========================/  END OF FILE  /===========================//
