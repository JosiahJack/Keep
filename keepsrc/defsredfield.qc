/*----------------------------------------------------------------------
Raven Keep specific defs
----------------------------------------------------------------------*/

//----------------------------------------------------------------------
/*
CONSTANTS AND STRINGS
*/
//----------------------------------------------------------------------

float 		autosave;

float MON_RAVEN_PERCH = 2;		// Start in perched idle animation
float MON_RAVEN_FEED = 4;		// Start in feeding idle animation
float MON_WOLF_HOWL = 2;		// Howl when angry
float MON_HUNTRESS_TAUNT = 2;		// Taunt the player when in sight
float MON_SWORD_EYES = 2;		// Glowing eyes with invisible sword
float MON_SWORD_BLUE = 4;		// Eyes are blue (red default)
float MON_SWORD_LEAN = 4096;		// Invisible sword starts leaning

float SPEED_KARASUROCKS = 500;		// Base speed of Karasu rock summon attacks
float SPEED_KARASUSKILL = 200;		// 500=easy, 700=normal, 900=hard, 1100=nm

float SPEED_WOLFSWORD = 500;		//Base speed of Wolf Moonlight Sword
float SPEED_WOLFSKILL = 200;		// 500=easy, 700=normal, 900=hard, 1100=nm 

float SPEED_ELENAGUN = 800;		// Base speed for Evelyn pistol (800=easy, 950=normal, 1100=hard, 1250=nm)
float SPEED_ELENASPEAR = 600;		// Base speed for Blood Spears (600=easy, 750=normal, 900=hard, 1050=nm)
float SPEED_ELENAFIRE = 650;		// Base speed for Blood Spears (650=easy, 800=normal, 950=hard, 1100=nm)
float SPEED_ELENASKILL = 150;		

vector DAMAGE_FIREWORK = '10 5 5';		// Fireworks are dangerous
vector DAMAGE_MOONSWORD = '50 10 80';		// Explosive Moon Sword high splash damage
vector DAMAGE_ELENAFIRE = '30 10 45';		// Huntress fire ball mid damage and splash damage

float DAMAGE_EVEBULLET = 10;		// High Damage from Evelyn pistol
float DAMAGE_BLDSPEAR = 10;		// Mid damage per spear

float MONAI_MELEEKARASU = 80;		// Lord Karasu fist range
float MONAI_KARASURANGE = 800;		// Lord Karasu beam range
float MONAI_KARASURANGE2 = 192;		// Lord Karasu lightning range
float MONAI_KARASURANGE3 = 304;		// Lord Karasu rocks range

float MONAI_RANGERAVEN = 90;		// Range for starting Raven attack
float MONAI_RANGERAVEN2 = 60;		// Range for completing Raven attack
float MONAI_MELEEWOLF = 160;		// Moonlight Guardian sword starting range
float MONAI_MELEE2WOLF = 144;		// Moonlight Guardian sword completing range
float MONAI_WOLFRANGE = 1500;		// Moonlight Guardian energy sword range

// Vengeful Spirit
float MONAI_SPIRITSOLID = 1;		// Regular spawn state
float MONAI_SPIRITINVIS = 2;		// Invisible
float MONAI_MELEESPIRIT = 80;		// Melee range
float MONAI_CLOSESPIRIT = 192;		// Too close, teleport away
float MONAI_RANGESPIRIT = 256;		// Distance to be after teleport
vector MONAI_SPIRITIMPACT = '16 0 0';	// Blast radius centre
float MONAI_SPIRITDAMAGE = 12;		// Impact damage
float MONAI_SPIRITRADIUS = 512;		// Radius of scream attack
float MONAI_SPIRITFORWARD = 400;	// Forward momentum
float MONAI_SPIRITUP = 0;		// Vertical momentum
float MONAI_SPIRITSCREAMRANGE = 120;	// Long range scream

// Elena the Blood Huntress
float MONAI_ELENAFRONT = 80;	
float MONAI_MELEEHUNTRESS = 90;		// Blood Huntress sword range
float MONAI_ELENARANGE = 480;		// Range to use Blood spears
float MONAI_JUMPELENATIME = 6;		// Time before next jump attack
float MONAI_JUMPELENANEAR = 150;	// Huntress jump attack distance
float MONAI_JUMPELENAFAR = 350;
vector MONAI_ELENAIMPACT = '0 0 -22';	// Blast radius centre
float MONAI_ELENADAMAGE = 10;		// Impact damage
float MONAI_ELENARADIUS = 512;		// Radius of blast attack
float MONAI_ELENAFORWARD = 400;		// Forward momentum
float MONAI_ELENAUP = 50;		// Vertical momentum

float CT_MONSPIRIT = 99;		// Ghostly invisible sword warrior
float CT_MONKARASU = 396;	// Lord Karasu the Master of Raven Keep!
float CT_MONKARASUSPELL = 397;	// Spell targets for Karasu
float CT_MONRAVEN = 398;	// A vicious raven.
float CT_MONWOLF = 399;		// The Moonlight Guardian!
float CT_MONHUNTRESS = 388;	// Elena the Blood Huntress!
float CT_ELENABLAST = 389;	// Targets for Elena fireblast trigger

float CT_PROJ_FIREWORK = 498;		// Fireworks
float CT_PROJ_ZRING = 499;		// Zena ring

float CT_FIREWORKSHOOTER = 668;		// Fireworks
float CT_MISCBELL = 695;		// Misc Bell
float CT_HEALGEM = 761;			// New Lifegem for Ravenkeep
float CT_HEALBEER = 762;		// New Q Brew for Ravenkeep

float CT_SPIRITTELEPORT = 939;		// info_skullwiz_destination

float CT_PROJ_KSPHERE = 1000;		// Lord Karasu energy sphere
float CT_PROJ_KLIGHT = 1001;		// Lord Karasu lightning
float CT_PROJ_KSPELL = 1002;		// Lord Karasu spell runes

float CT_PROJ_MOONSWORD = 1005;		// Moonlight Guardian sword

float CT_PROJ_EVEBULLET = 1006;		// Evelyn pistol bullet
float CT_PROJ_BLDSPEAR = 1007;		// Huntress blood spears
float CT_PROJ_ELENAFIRE = 1008;		// Huntress fireball

//Vases have unique frames for sizes and flames
float FLAME = 1;			//Incense burning flame
float LARGE =2;				//Larger vase
float LIFEGEM =4; 			//Contains a Lifegem

//----------------------------------------------------------------------
string MODEL_LIFEGEM = "progs/redfield/lifegem.mdl";	// Red Lifegem
string MODEL_HEALBEER = "progs/redfield/beer_heal.mdl";	// Red Beer Bottle
string MODEL_SWORDEYES = "progs/redfield/sword_eyes.mdl";	// Glowing eyes 
string MODEL_SCREAM = "progs/redfield/spirit_scream.mdl";		// Scream shockwave 
string MODEL_PROJ_KSPHERE = "progs/redfield/proj_ksphere.mdl";
string MODEL_PROJ_KLIGHT = "progs/redfield/proj_karasulit.mdl";
string MODEL_PROJ_KSPELL = "progs/redfield/proj_kspell.mdl";
string MODEL_PROJ_FIREWORK = "progs/redfield/proj_firework.mdl";
string MODEL_PROJ_ZRING = "progs/redfield/proj_zenaring.mdl";
string MODEL_PROJ_MOONSWORD = "progs/redfield/proj_moonsword.mdl";
string MODEL_PROJ_EVEBULLET = "progs/redfield/proj_evebullet.mdl";
string MODEL_PROJ_BLDSPEAR = "progs/redfield/proj_bloodspear.mdl";
string MODEL_PROJ_ELENAFIRE = "progs/redfield/proj_elenafire.mdl";

//----------------------------------------------------------------------
//Motion blur models
string MODEL_BLUR_WOLF = "progs/redfield/blur_wolf.mdl";

//----------------------------------------------------------------------
//Blood Huntress models
string MODEL_EVELYN = "progs/redfield/huntress/evelyn.mdl";
string MODEL_FIREBLAST = "progs/redfield/huntress/fireblast.mdl";
string MODEL_ELENASPIN = "progs/redfield/huntress/huntress_spiral.mdl";
string MODEL_ELENASLSH = "progs/redfield/huntress/huntress_blur.mdl";
string MODEL_ELENASPR = "progs/redfield/huntress/huntress_spark.mdl";
string MODEL_ELENADUST = "progs/redfield/huntress/huntress_dust.mdl";
string MODEL_ELENASMOKE = "progs/redfield/huntress/huntress_smoke.mdl";

float EXPLODE_FIREWORK = 44;
float EXPLODE_MOONSWORD = 45;

string MODEL_GWEAP_UPAXE_REDFIELD = "progs/redfield/g_longswordred.mdl";	// Red rune sword model
string MODEL_GWEAP_SG = "progs/redfield/g_shot1.mdl";		// New 'Evelyn' model for Ravenkeep

string MODEL_VWEAP_SSMOKE = "progs/redfield/v_ssmoke.mdl";	// Dragon pistol smoke
string MODEL_VWEAP_AXE = "progs/redfield/v_longsword.mdl";	// Default, no red runes
string MODEL_VWEAP_UPAXE = "progs/redfield/v_longswordred.mdl";	// Sword Upgrade