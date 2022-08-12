const entity NULL = world;

const float MASK_ENGINE			= 1;
const float MASK_ENGINEVIEWMODELS	= 2;
const float MASK_NORMAL			= 4;

const float RF_VIEWMODEL	= 1;
const float RF_EXTERNALMODEL	= 2;
const float RF_DEPTHHACK	= 4;
const float RF_ADDATIVE		= 8;
const float RF_USEAXIS		= 16;

const float VF_MIN		= 1;	//(vector)
const float VF_MIN_X		= 2;	//(float)
const float VF_MIN_Y		= 3;	//(float)
const float VF_SIZE		= 4;	//(vector) (viewport size)
const float VF_SIZE_Y		= 5;	//(float)
const float VF_SIZE_X		= 6;	//(float)
const float VF_VIEWPORT		= 7;	//(vector, vector)
const float VF_FOV		= 8;	//(vector)
const float VF_FOVX		= 9;	//(float)
const float VF_FOVY		= 10;	//(float)
const float VF_ORIGIN		= 11;	//(vector)
const float VF_ORIGIN_X		= 12;	//(float)
const float VF_ORIGIN_Y		= 13;	//(float)
const float VF_ORIGIN_Z		= 14;	//(float)
const float VF_ANGLES		= 15;	//(vector)
const float VF_ANGLES_X		= 16;	//(float)
const float VF_ANGLES_Y		= 17;	//(float)
const float VF_ANGLES_Z		= 18;	//(float)
const float VF_DRAWWORLD	= 19;	//(float)
const float VF_DRAWENGINESBAR	= 20;	//(float)
const float VF_DRAWCROSSHAIR	= 21;	//(float)

const float VF_CL_VIEWANGLES	= 33;	//(vector)
const float VF_CL_VIEWANGLES_X	= 34;	//(float)
const float VF_CL_VIEWANGLES_Y	= 35;	//(float)
const float VF_CL_VIEWANGLES_Z	= 36;	//(float) 

const float STAT_HEALTH		= 0;
const float STAT_WEAPONMODEL	= 2;
const float STAT_AMMO		= 3;
const float STAT_ARMOR		= 4;
const float STAT_WEAPONFRAME	= 5;
const float STAT_SHELLS		= 6;
const float STAT_NAILS		= 7;
const float STAT_ROCKETS	= 8;
const float STAT_CELLS		= 9;
const float STAT_ACTIVEWEAPON	= 10;
const float STAT_ITEMS		= 15;

const float true	= 1;
const float false	= 0;

const float EXTRA_LOW = -99999999;
const float EXTRA_HIGH = 99999999;

const vector VEC_1	= '1 1 1';
const vector VEC_0	= '0 0 0';
const vector VEC_M1	= '-1 -1 -1';

const float M_PI = 3.14159265358979323846;

vector	VEC_HULL_MIN = '-16 -16 -24';
vector	VEC_HULL_MAX = '16 16 32';

const float EF_ADDITIVE		= 32;
const float EF_BLUE		= 64;
const float EF_FLAME		= 1024;
const float EF_FULLBRIGHT	= 512;
const float EF_NODEPTHTEST	= 8192;
const float EF_NODRAW		= 16;
const float EF_NOSHADOW		= 4096;
const float EF_RED		= 128;
const float EF_STARDUST		= 2048;
const float EF_SELECTABLE 	= 16384;

const float PFL_ONGROUND	= 1;
const float PFL_CROUCH		= 2;
const float PFL_DEAD		= 4;
const float PFL_GIBBED		= 8;


