void() main = 
{
	dprint("main function\n");
	precache_file("progs.dat");
	precache_file("gfx.wad");
	precache_file("quake.rc");
	precache_file("default.cfg");
	precache_file("end1.bin");
	precache_file2("end2.bin");
	precache_file("demo1.dem");
	precache_file("demo2.dem");
	precache_file("demo3.dem");
	precache_file("gfx/palette.lmp");
	precache_file("gfx/colormap.lmp");
	precache_file2("gfx/pop.lmp");
	precache_file("gfx/complete.lmp");
	precache_file("gfx/inter.lmp");
	precache_file("gfx/ranking.lmp");
	precache_file("gfx/vidmodes.lmp");
	precache_file("gfx/finale.lmp");
	precache_file("gfx/conback.lmp");
	precache_file("gfx/qplaque.lmp");
	precache_file("gfx/menudot1.lmp");
	precache_file("gfx/menudot2.lmp");
	precache_file("gfx/menudot3.lmp");
	precache_file("gfx/menudot4.lmp");
	precache_file("gfx/menudot5.lmp");
	precache_file("gfx/menudot6.lmp");
	precache_file("gfx/menuplyr.lmp");
	precache_file("gfx/bigbox.lmp");
	precache_file("gfx/dim_modm.lmp");
	precache_file("gfx/dim_drct.lmp");
	precache_file("gfx/dim_ipx.lmp");
	precache_file("gfx/dim_tcp.lmp");
	precache_file("gfx/dim_mult.lmp");
	precache_file("gfx/mainmenu.lmp");
	precache_file("gfx/box_tl.lmp");
	precache_file("gfx/box_tm.lmp");
	precache_file("gfx/box_tr.lmp");
	precache_file("gfx/box_ml.lmp");
	precache_file("gfx/box_mm.lmp");
	precache_file("gfx/box_mm2.lmp");
	precache_file("gfx/box_mr.lmp");
	precache_file("gfx/box_bl.lmp");
	precache_file("gfx/box_bm.lmp");
	precache_file("gfx/box_br.lmp");
	precache_file("gfx/sp_menu.lmp");
	precache_file("gfx/ttl_sgl.lmp");
	precache_file("gfx/ttl_main.lmp");
	precache_file("gfx/ttl_cstm.lmp");
	precache_file("gfx/mp_menu.lmp");
	precache_file("gfx/netmen1.lmp");
	precache_file("gfx/netmen2.lmp");
	precache_file("gfx/netmen3.lmp");
	precache_file("gfx/netmen4.lmp");
	precache_file("gfx/netmen5.lmp");
	precache_file("gfx/sell.lmp");
	precache_file("gfx/help0.lmp");
	precache_file("gfx/help1.lmp");
	precache_file("gfx/help2.lmp");
	precache_file("gfx/help3.lmp");
	precache_file("gfx/help4.lmp");
	precache_file("gfx/help5.lmp");
	precache_file("gfx/pause.lmp");
	precache_file("gfx/loading.lmp");
	precache_file("gfx/p_option.lmp");
	precache_file("gfx/p_load.lmp");
	precache_file("gfx/p_save.lmp");
	precache_file("gfx/p_multi.lmp");
	precache_sound("misc/menu1.wav");
	precache_sound("misc/menu2.wav");
	precache_sound("misc/menu3.wav");
	precache_sound("ambience/water1.wav");
	precache_sound("ambience/wind2.wav");
	precache_file("maps/start.bsp");
	precache_file("maps/e1m1.bsp");
	precache_file("maps/e1m2.bsp");
	precache_file("maps/e1m3.bsp");
	precache_file("maps/e1m4.bsp");
	precache_file("maps/e1m5.bsp");
	precache_file("maps/e1m6.bsp");
	precache_file("maps/e1m7.bsp");
	precache_file("maps/e1m8.bsp");
	precache_file2("gfx/pop.lmp");
	precache_file2("maps/e2m1.bsp");
	precache_file2("maps/e2m2.bsp");
	precache_file2("maps/e2m3.bsp");
	precache_file2("maps/e2m4.bsp");
	precache_file2("maps/e2m5.bsp");
	precache_file2("maps/e2m6.bsp");
	precache_file2("maps/e2m7.bsp");
	precache_file2("maps/e3m1.bsp");
	precache_file2("maps/e3m2.bsp");
	precache_file2("maps/e3m3.bsp");
	precache_file2("maps/e3m4.bsp");
	precache_file2("maps/e3m5.bsp");
	precache_file2("maps/e3m6.bsp");
	precache_file2("maps/e3m7.bsp");
	precache_file2("maps/e4m1.bsp");
	precache_file2("maps/e4m2.bsp");
	precache_file2("maps/e4m3.bsp");
	precache_file2("maps/e4m4.bsp");
	precache_file2("maps/e4m5.bsp");
	precache_file2("maps/e4m6.bsp");
	precache_file2("maps/e4m7.bsp");
	precache_file2("maps/e4m8.bsp");
	precache_file2("maps/end.bsp");
	precache_file2("maps/dm1.bsp");
	precache_file2("maps/dm2.bsp");
	precache_file2("maps/dm3.bsp");
	precache_file2("maps/dm4.bsp");
	precache_file2("maps/dm5.bsp");
	precache_file2("maps/dm6.bsp");
};

void() worldspawn = 
{
	local string str;
	local float rnd;
	lastspawn = world;
	InitBodyQue();
	if (init_done != 1)
	{
		inter_race_time = 5;
		SetInterRaceTime = 0;
		init_done = 1;
	}
	num_markers = 0;
	num_bots = 0;
	if (self.model == "maps/e1m8.bsp")
	{
		cvar_set("sv_gravity", "100");
	}
	else
	{
		cvar_set("sv_gravity", "800");
	}
	first_startfinish_flag = 1;
	race_finish_time = 0;
	teamplay = cvar("teamplay");
	cvar_set("sv_maxspeed", "2000");
	cvar_set("sv_gravity", "600");
	cvar_set("sv_friction", "1.7");
	cvar_set("sv_accelerate", "0.8");
	cvar_set("cl_movespeedkey", "1");
	cvar_set("cl_anglespeedkey", "1");
	cvar_set("cl_forwardspeed", "1700");
	cvar_set("cl_rollangle", "2.5");
	cvar_set("cl_sidespeed", "0");
	cvar_set("cl_backspeed", "300");
	cvar_set("cl_bob", "0");
	global_racing_flags = QR_NO_STARTFINISH;
	race_start_time = time;
	W_Precache();
	precache_sound("demon/dland2.wav");
	precache_sound("misc/h2ohit1.wav");
	precache_sound("items/itembk2.wav");
	precache_sound("player/plyrjmp8.wav");
	precache_sound("player/land.wav");
	precache_sound("player/land2.wav");
	precache_sound("player/drown1.wav");
	precache_sound("player/drown2.wav");
	precache_sound("player/gasp1.wav");
	precache_sound("player/gasp2.wav");
	precache_sound("player/h2odeath.wav");
	precache_sound("misc/talk.wav");
	precache_sound("player/teledth1.wav");
	precache_sound("misc/r_tele1.wav");
	precache_sound("misc/r_tele2.wav");
	precache_sound("misc/r_tele3.wav");
	precache_sound("misc/r_tele4.wav");
	precache_sound("misc/r_tele5.wav");
	precache_sound("weapons/lock4.wav");
	precache_sound("weapons/pkup.wav");
	precache_sound("items/armor1.wav");
	precache_sound("weapons/lhit.wav");
	precache_sound("weapons/lstart.wav");
	precache_sound("items/damage3.wav");
	precache_sound("misc/power.wav");
	precache_sound("player/gib.wav");
	precache_sound("player/udeath.wav");
	precache_sound("player/tornoff2.wav");
	precache_sound("player/pain1.wav");
	precache_sound("player/pain2.wav");
	precache_sound("player/pain3.wav");
	precache_sound("player/pain4.wav");
	precache_sound("player/pain5.wav");
	precache_sound("player/pain6.wav");
	precache_sound("player/death1.wav");
	precache_sound("player/death2.wav");
	precache_sound("player/death3.wav");
	precache_sound("player/death4.wav");
	precache_sound("player/death5.wav");
	precache_sound("weapons/ax1.wav");
	precache_sound("player/axhit1.wav");
	precache_sound("player/axhit2.wav");
	precache_sound("player/h2ojump.wav");
	precache_sound("player/slimbrn2.wav");
	precache_sound("player/inh2o.wav");
	precache_sound("player/inlava.wav");
	precache_sound("misc/outwater.wav");
	precache_sound("player/lburn1.wav");
	precache_sound("player/lburn2.wav");
	precache_sound("misc/water1.wav");
	precache_sound("misc/water2.wav");
	precache_sound("rally/rev2.wav");
	precache_sound("rally/rev3.wav");
	precache_sound("rally/rev4.wav");
	precache_sound("rally/tone1.wav");
	precache_sound("rally/meepmeep.wav");
	precache_sound("rally/lapcom.wav");
	precache_sound("rally/start.wav");
	precache_sound("rally/start2.wav");
	precache_sound("rally/roll.wav");
	precache_sound("rally/crash.wav");
	precache_sound("rally/crash1.wav");
	precache_sound("rally/crash2.wav");
	precache_sound("rally/crash3.wav");
	precache_sound("rally/crash4.wav");
	precache_sound("rally/crash5.wav");
	precache_sound("rally/slide.wav");
	precache_sound("rally/skidtarm.wav");
	precache_sound("rally/skidgrav.wav");
	precache_sound("rally/skidmud.wav");
	precache_sound("rally/bangbang.wav");
	precache_sound("rally/minebeep.wav");
	precache_sound("items/protect.wav");
	precache_sound("items/protect2.wav");
	precache_sound("items/protect3.wav");
	precache_sound("rally/process/bang01.wav");
	precache_sound("rally/process/bang02.wav");
	precache_sound("rally/process/bang03.wav");
	precache_sound("rally/process/crsh01.wav");
	precache_sound("rally/process/elect02.wav");
	precache_sound("rally/process/drft01.wav");
	precache_sound("rally/process/drft02.wav");
	precache_sound("rally/process/htcone01.wav");
	precache_sound("rally/process/rolltest.wav");
	precache_sound("rally/process/buzztst1.wav");
	precache_sound("rally/process/spark4.wav");
	precache_sound("rally/voice/win3.wav");
	precache_sound("rally/voice/gotst01.wav");
	precache_sound("rally/voice/lapcm01.wav");
	precache_sound("rally/voice/tone01.wav");
	precache_sound("rally/voice/tone04.wav");
	precache_sound("rally/voice/tone05.wav");
	precache_sound("rally/voice/checkpnt.wav");
	precache_sound("rally/nexus/wall.wav");
	precache_sound("rally/nexus/horn.wav");
	precache_sound("rally/ray/susp1.wav");
	precache_sound("rally/ray/crash2.wav");
	precache_sound("rally/ray/crash3.wav");
	precache_sound("rally/ray/crash4.wav");
	precache_sound("rally/ray/crash5.wav");
	precache_sound("rally/ray/engstart.wav");
	precache_sound("rally/ray/skidgrav.wav");
	precache_sound("rally/ray/screech1.wav");
	precache_sound("rally/ray/screech2.wav");
	precache_sound("rally/ray/screech3.wav");
	precache_sound("rally/ray/screech4.wav");
	precache_sound("rally/dude/sevpain1.wav");
	precache_sound("rally/dude/sevpain2.wav");
	precache_sound("enforcer/enfire.wav");
	precache_sound("rally/engine/suidle.wav");
	precache_sound("rally/engine/su01.wav");
	precache_sound("rally/engine/su02.wav");
	precache_sound("rally/engine/su03.wav");
	precache_sound("rally/engine/su04.wav");
	precache_sound("rally/engine/su05.wav");
	precache_sound("rally/engine/su06.wav");
	precache_sound("rally/engine/su07.wav");
	precache_sound("rally/engine/su08.wav");
	precache_sound("rally/engine/su09.wav");
	precache_sound("rally/engine/su10.wav");
	precache_sound("rally/engine/su11.wav");
	precache_sound("rally/engine/su12.wav");
	precache_sound("rally/engine/su13.wav");
	precache_sound("rally/engine/su14.wav");
	precache_sound("rally/engine/su15.wav");
	precache_sound("rally/engine/su16.wav");
	precache_sound("rally/engine/su17.wav");
	precache_sound("rally/engine/su18.wav");
	precache_sound("rally/engine/su19.wav");
	precache_sound("rally/engine/su20.wav");
	precache_sound("rally/engine/test01.wav");
	precache_sound("rally/engine/test02.wav");
	precache_sound("rally/engine/test03.wav");
	precache_sound("rally/engine/test04.wav");
	precache_sound("rally/engine/test05.wav");
	precache_sound("rally/engine/test06.wav");
	precache_sound("rally/engine/test07.wav");
	precache_sound("rally/engine/test08.wav");
	precache_sound("rally/engine/test09.wav");
	precache_sound("rally/engine/test10.wav");
	precache_sound("rally/engine/tri01.wav");
	precache_sound("rally/engine/tri02.wav");
	precache_sound("rally/engine/tri03.wav");
	precache_sound("rally/engine/tri04.wav");
	precache_sound("rally/engine/tri05.wav");
	precache_sound("rally/engine/tri06.wav");
	precache_sound("rally/engine/tri07.wav");
	precache_sound("rally/engine/tri08.wav");
	precache_sound("rally/engine/tri09.wav");
	precache_sound("rally/engine/tri10.wav");
	precache_sound("rally/engine/ma01.wav");
	precache_sound("rally/engine/ma02.wav");
	precache_sound("rally/engine/ma03.wav");
	precache_sound("rally/engine/ma04.wav");
	precache_sound("rally/engine/ma05.wav");
	precache_sound("rally/engine/ma06.wav");
	precache_sound("rally/engine/ma07.wav");
	precache_sound("rally/engine/ma08.wav");
	precache_sound("rally/engine/ma09.wav");
	precache_sound("rally/engine/ma10.wav");
	precache_sound("rally/engine/aa01.wav");
	precache_sound("rally/engine/aa02.wav");
	precache_sound("rally/engine/aa03.wav");
	precache_sound("rally/engine/aa04.wav");
	precache_sound("rally/engine/aa05.wav");
	precache_sound("rally/engine/aa06.wav");
	precache_sound("rally/engine/aa07.wav");
	precache_sound("rally/engine/aa08.wav");
	precache_sound("rally/engine/aa09.wav");
	precache_sound("rally/engine/aa10.wav");
	precache_sound("rally/engine/rev/highrev.wav");
	precache_sound("rally/engine/rev/highrev2.wav");
	precache_sound("rally/engine/rev/takeoff.wav");
	precache_sound("rally/engine/rev/backrev.wav");
	precache_sound("rally/engine/rev/backrev2.wav");
	precache_sound("rally/engine/rev/backrev3.wav");
	precache_model("progs/player.mdl");
	precache_model("progs/eyes.mdl");
	precache_model("progs/h_player.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_model("progs/s_bubble.spr");
	precache_model("progs/s_explod.spr");
	precache_model("progs/bolt.mdl");
	precache_model("progs/bolt2.mdl");
	precache_model("progs/bolt3.mdl");
	precache_model("progs/lavaball.mdl");
	precache_model("models/missile.mdl");
	precache_model("progs/grenade.mdl");
	precache_model("progs/spike.mdl");
	precache_model("progs/laser.mdl");
	precache_model("models/detnator.mdl");
	precache_model("progs/s_spike.mdl");
	precache_model("models/w_mine.mdl");
	precache_model("models/w_detntr.mdl");
	precache_model("models/gibs.mdl");
	precache_model("models/trophy.mdl");
	precache_model("progs/backpack.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_model("progs/v_light.mdl");
	precache_model("models/sumacar.mdl");
	precache_model("models/triton.mdl");
	precache_model("models/cone.mdl");
	precache_model("models/baracade.mdl");
	precache_model("models/stopsign.mdl");
	precache_model("models/stoptop.mdl");
	precache_model("models/stoppost.mdl");
	precache_model("models/roobar.mdl");
	precache_model("models/zumacar.mdl");
	precache_model("models/mycar.mdl");
	precache_model("models/fwhl.mdl");
	precache_model("models/whl.mdl");
	precache_model("models/mine.mdl");
	precache_model("models/null.mdl");
	precache_model("models/wheel.mdl");
	precache_model("models/wheelsm.mdl");
	precache_model("models/qr_rock.mdl");
	precache_model("models/qr_rock2.mdl");
	precache_model("models/qr_nail2.mdl");
	precache_model("models/qr_light.mdl");
	precache_model("maps/b_nail0.bsp");
	precache_model("models/kangaroo.mdl");
	precache_model("models/dude.mdl");
	precache_model("models/marker.mdl");
	precache_model("models/finish.mdl");
	precache_model("models/zumabase.mdl");
	precache_model("models/zumaroo.mdl");
	precache_model("models/zumalght.mdl");
	precache_model("models/zumanail.mdl");
	precache_model("models/zumamine.mdl");
	precache_model("models/zumadetn.mdl");
	precache_model("models/zumarock.mdl");
	precache_model("models/sumabase.mdl");
	precache_model("models/sumaroo.mdl");
	precache_model("models/sumalght.mdl");
	precache_model("models/sumanail.mdl");
	precache_model("models/sumamine.mdl");
	precache_model("models/sumadetn.mdl");
	precache_model("models/sumarock.mdl");
	precache_model("models/tritbase.mdl");
	precache_model("models/tritroo.mdl");
	precache_model("models/tritlght.mdl");
	precache_model("models/tritnail.mdl");
	precache_model("models/tritmine.mdl");
	precache_model("models/tritdetn.mdl");
	precache_model("models/tritrock.mdl");
	precache_model("models/mgnabase.mdl");
	precache_model("models/mgnaroo.mdl");
	precache_model("models/mgnalght.mdl");
	precache_model("models/mgnanail.mdl");
	precache_model("models/mgnamine.mdl");
	precache_model("models/mgnadetn.mdl");
	precache_model("models/mgnarock.mdl");
	lightstyle(0, "m");
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	lightstyle(4, "mamamamamama");
	lightstyle(5, "jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	lightstyle(6, "nmonqnmomnmomomno");
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	lightstyle(9, "aaaaaaaazzzzzzzz");
	lightstyle(10, "mmamammmmammamamaaamammma");
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	lightstyle(63, "a");
	if (world.racing_flags & QR_NO_SIDEWAYS_ROLL)
	{
		global_racing_flags = global_racing_flags | QR_NO_SIDEWAYS_ROLL;
	}
	if (!deathmatch && !coop)
	{
		rnd = random() * 5;
		if (rnd <= 1)
		{
			precache_sound("rally/music/funk.wav");
			ambientsound('0 0 0', "rally/music/funk.wav", 1, ATTN_NONE);
		}
		else
		{
			if (rnd <= 2)
			{
				precache_sound("rally/music/rock.wav");
				ambientsound('0 0 0', "rally/music/rock.wav", 1, ATTN_NONE);
			}
			else
			{
				if (rnd <= 3)
				{
					precache_sound("rally/music/soft.wav");
					ambientsound('0 0 0', "rally/music/soft.wav", 1, ATTN_NONE);
				}
				else
				{
					if (rnd <= 4)
					{
						precache_sound("rally/music/hiphop.wav");
						ambientsound('0 0 0', "rally/music/hiphop.wav", 1, ATTN_NONE);
					}
					else
					{
						if (rnd <= 5)
						{
							precache_sound("rally/music/indust.wav");
							ambientsound('0 0 0', "rally/music/indust.wav", 1, ATTN_NONE);
						}
					}
				}
			}
		}
	}
	rally_type_index = 0;
	racing_type = 0;
	if (world.model == "maps/start.bsp")
	{
		return;
	}
	if (world.race_type == "racing")
	{
		if (teamplay < 11 || teamplay > 13)
		{
			rally_type_index = 1;
		}
	}
	else
	{
		if (world.race_type == "racing_timetrial")
		{
			if (teamplay < 11 || teamplay > 13)
			{
				rally_type_index = 1;
				racing_type = RT_TIME_TRIAL;
			}
		}
		else
		{
			if (world.race_type == "racing_dm")
			{
				if (teamplay < 11 || teamplay > 13)
				{
					rally_type_index = 2;
				}
			}
			else
			{
				if (world.race_type == "dm")
				{
					rally_type_index = 3;
				}
				else
				{
					if (world.race_type == "cult_kill")
					{
						if (teamplay != 13)
						{
							rally_type_index = 4;
							cult_kills = 0;
						}
					}
					else
					{
						if (world.race_type == "gib_duke")
						{
							if (teamplay != 13)
							{
								rally_type_index = 5;
							}
						}
						else
						{
							if (world.race_type == "last_man")
							{
								if (teamplay != 13)
								{
									rally_type_index = 6;
								}
							}
						}
					}
				}
			}
		}
	}
	if (rally_type_index == 0)
	{
		rally_type_index = 3;
	}
};

void() StartFrame = 
{
	local entity laser;
	local vector vect;
	if (teamplay == 0)
	{
		teamplay = cvar("teamplay");
	}
	skill = cvar("skill");
	framecount = framecount + 1;
	laser = find(world, classname, "laser");
	while (laser != world)
	{
		if (laser.last_jump_z != 0)
		{
			laser.old_velocity = laser.velocity;
			vect = normalize(laser.velocity);
			laser.angles = vectoangles(vect);
			laser.last_jump_z = 0;
		}
		laser.velocity_z = laser.old_velocity_z + cvar("sv_gravity") * frametime;
		laser = find(laser, classname, "laser");
	}
};

void() bodyque = 
{
};

void() InitBodyQue = 
{
	local entity e;
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};

void(entity ent) CopyToBodyQue = 
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	setorigin(bodyque_head, ent.origin);
	setsize(bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};

