//purecsqc is (currently) dependant upon FTE
//so if you want more qcvm features or better performance, you can uncomment out the following line.
//#pragma target FTE


//standard ssqc stuff missing in csqc
.float modelflags;
const float MF_ROCKET = 1;
const float MF_GRENADE = 2;
const float MF_GIB = 4;
const float MF_ROTATE = 8;
const float MF_TRACER = 16;
const float MF_ZOMGIB = 32;
const float MF_TRACER2 = 64;
const float MF_TRACER3 = 128;
.float traileffectnum;
.float health;
.string targetname;
float completed_time;	//time to show on completion scoreboard

var float autocvar_purecsqc_noreset = 0;

noref entity msg_entity;

void() Lerp_ResetSelf;	//call this when an entity gets teleported/spawned to avoid interpolation glitches.
void() Lerp_ResetAll;		//called at startup to avoid monsters being so weird on e1m2
string dochangelevel;		//name of the next map. blocks further changelevels so as to not break physics code.
entity theplayer;		//this is the local player. and there's only one. no multiplayer. it sucks.

/*many builtins are not implemented in csqc because the player argument makes no sense. mostly prints.*/
#define stuffcmd(e,s) localcmd(s)	//no singlecasts
#define sprint(e,s) print(s)		//no singlecasts
#define bprint print				//no broadcasts
#define centerprint(e,s) cprint(s)	//no singlecasts
#define aim(e,s) v_forward			//no autoaim!
void(string newmap) changelevel;

/*wrap localcmd to catch 'restart\n' commands*/
void(string s) mylocalcmd =
{
	if (s == "restart\n")
	{
		localcmd("disconnect\n");
	}
	else
		localcmd(s);
};
#define localcmd mylocalcmd

/*wrap Write* so that we can just do the right thing without changing all the existing ssqc code
  If you're serious about this stuff, you'd disable this and fix your code instead*/
float svclen;
float svcdata[9];
entity svcent;
void(float to, float f) WriteByte =
{
	if (svclen == (float)svcdata.length)
	{
		for (to = 0; to < (float)svcdata.length; to++)
			print(sprintf("%g: %g\n", to, svcdata[to]));
		error("overflowed svc buffer\n");	//panic
	}
	svcdata[svclen++] = f;

	switch(svcdata[0])
	{
	case SVC_CDTRACK:
		if (svclen < 3)
			break;
		localcmd(sprintf("cd loop %g %g\n", svcdata[1], svcdata[2]));
		svclen = 0;
		break;
	case SVC_SELLSCREEN:
		localcmd("help\n");
		svclen = 0;
		break;
	case SVC_FINALE:
		break;	//terminated by a string, and handled there.
	case SVC_TEMPENTITY:
		if (svclen == 1)
			break;
		switch(svcdata[1])//double switch is inefficient, but less copypasta
		{
		case TE_LIGHTNING1:
		case TE_LIGHTNING2:
		case TE_LIGHTNING3:
			if (svclen < 9)
				return;
			break;
		default:
			if (svclen < 5)
				return;
			break;
		}
		svclen = 0;
		switch(svcdata[1])
		{
		case TE_SPIKE:
			te_spike([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_SUPERSPIKE:
			te_superspike([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_GUNSHOT:
			te_gunshot([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_EXPLOSION:
			te_explosion([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_TAREXPLOSION:
			te_tarexplosion([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_LIGHTNING1:
			te_lightning1(svcent, [svcdata[3], svcdata[4], svcdata[5]], [svcdata[6], svcdata[7], svcdata[8]]);
			break;
		case TE_LIGHTNING2:
			te_lightning2(svcent, [svcdata[3], svcdata[4], svcdata[5]], [svcdata[6], svcdata[7], svcdata[8]]);
			break;
		case TE_WIZSPIKE:
			te_wizspike([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_KNIGHTSPIKE:
			te_knightspike([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_LIGHTNING3:
			te_lightning3(svcent, [svcdata[3], svcdata[4], svcdata[5]], [svcdata[6], svcdata[7], svcdata[8]]);
			break;
		case TE_LAVASPLASH:
			te_lavasplash([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		case TE_TELEPORT:
			te_teleport([svcdata[2], svcdata[3], svcdata[4]]);
			break;
		default:
			error(sprintf("unsupported te %g", svcdata[1]));	//panic
			break;
		}
		break;
	case SVC_INTERMISSION:
		if (!completed_time)
			completed_time = time;
	case SVC_KILLEDMONSTER:
	case SVC_FOUNDSECRET:
		svclen = 0;	//single byte.
		break;
	default:
		error(sprintf("unsupported svc %g", svcdata[0]));	//panic
		break;
	}
};
#define WriteShort WriteByte
#define WriteLong WriteByte
#define WriteCoord WriteByte
#define WriteAngle WriteByte
#define WriteFloat WriteByte
void(float to, entity e) WriteEntity =
{	//only support one ent per svc.
	svcent = e;
	WriteByte(to, 0);
};
void(float to, string s) WriteString =
{
	switch(svcdata[0])
	{
	case SVC_FINALE:
		if (!completed_time)
			completed_time = time;
		cprint(strcat("/Igfx/finale.lmp:/W/S/T/.", s));
		svclen = 0;
		break;
	default:
		error("WriteString not handled for that svc");	//panic
		break;
	}
};

//this is implemented in csqc, however, if we're in noreset mode, there's no way to remove static entities again.
//this means that we may need to wrap it for that case. but its better to not need to if we're allowed to flush the world properly.
void(entity e) mymakestatic =
{
	if (autocvar_purecsqc_noreset)
	{
		e.solid = SOLID_NOT;
		e.targetname = __NULL__;
		e.classname = "madestatic";
	}
	else
		makestatic(e);
};
#define makestatic mymakestatic

entity() checkclient =
{
	if (theplayer.health <= 0)
		return world;
	//single player only makes this simple.
	vector disp = theplayer.origin - self.origin;
	if (disp*disp > 2048*2048)	//ignore it outright if they're too far away.
		return world;
	//do a pvs check. because.
	if (checkpvs(self.origin, theplayer))
		return theplayer;
	return world;
};

//parms should still be set from earlier, as there's only one player.
void(entity e) setspawnparms =
{
};
 