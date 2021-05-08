
//Sbar properties - set by console vars
float vid_conwidth, vid_conheight;
float sbar_alpha;
vector wepbar_offset, ctfbar_offset;

// finale and intermission
vector viewang, viewpos; 
vector discrepancy;
float finale, mouse;

//HUD
float showscores, showHUD;
float shell_ammo, nail_ammo, rocket_ammo, cell_ammo;
float grenade_ammo;
float items, items2;
float invis_count, quad_count, pent_count, bio_count;
float player_health;
float currentweap;
float sg, ssg, ng, sng, gl, rl, lg, csaw, las, axe;
float cl_items;
float time_limit, frag_limit, life_count;
float title_timer;
float introtimer;
float slow_count;
float SNDSPD;

//CTF
float BLUE_CAPS, RED_CAPS;

.string		message;
.float		fadein;

void() getItems =
{
	items = getstati(STAT_ITEMS, 0, 23);
	items2 = getstati(STAT_ITEMS, 23, 9);
	cl_items = getstati(STAT_ITEMS);
}

vector(vector v) sbar_align =
{
	// align to bottom of screen
	v_x = v_x + (vid_conwidth / 2);
	v_y = vid_conheight - v_y;
	return v;
};

void(vector pos, string pic, float alph, float scale) Sbar_DrawPic =
{
	local vector siz;
	siz = drawgetimagesize(pic) * scale;
	pos = sbar_align(pos);
	drawpic(pos, pic, siz, VEC_1, alph, DRAWFLAG_NORMAL);
};

void(vector pos, float char, float alph) Sbar_DrawCharacter =
{
	pos = sbar_align(pos);
	drawcharacter(pos, char, '8 8 0', VEC_1, alph, DRAWFLAG_NORMAL);
};

void(vector pos, string str, float alph,vector med,vector color) Sbar_DrawString =
{
	pos = sbar_align(pos);
	drawstring(pos, str, med, color, alph, DRAWFLAG_NORMAL);
};

void(vector pos, float num, float digits, float color, float alpha) Sbar_DrawNum =
{
	string pic, s, digit;
	float i, len, cnt;
	vector v;

	s = ftos(num);
	len = strlen(s);
	
	// draw the last 'digits' chars of s
	cnt = digits;
	if (len < digits) cnt = len;

	for (i=1; i<=cnt; i=i+1)
	{
		digit = substring(s, len - i, 1);
		if (digit == "-")
			digit = "minus";
		if (color)
			pic = strcat("gfx/anum_", digit);
		else
			pic = strcat("gfx/num_", digit);

		v = pos + ('24 0 0' * (digits - i));
		Sbar_DrawPic(v, pic, alpha,1);
	}
};

void(vector pos, string pic, float itemnum, float item2num, float transparency, float scale) DrawInventory =
{
	vector v;
	v = pos;
	if ((items & itemnum) || (cl_items & itemnum) || (items2 & item2num))
	{
		Sbar_DrawPic(v, pic, transparency, scale);
	}
};

void(vector valor, string pic1, string pic2, float itemnum, float blink) DrawInventoryWeapon =
{
	vector v;
	string pic;
	float wb;

	v = valor;
	//v_y = v_y + weapons_offset;

	if (blink > 0)
	{
		wb = time - blink;
		if (wb >= 0.5 && wb < 1) wb = wb - 0.5;			// blink two times

		if	(wb < 0.1) pic = strzone(strcat("gfx/inva1_", substring(pic1, 8, strlen(pic1) - 8)));
		else if (wb < 0.2) pic = strzone(strcat("gfx/inva2_", substring(pic1, 8, strlen(pic1) - 8)));
		else if (wb < 0.3) pic = strzone(strcat("gfx/inva3_", substring(pic1, 8, strlen(pic1) - 8)));
		else if (wb < 0.4) pic = strzone(strcat("gfx/inva4_", substring(pic1, 8, strlen(pic1) - 8)));
		else if (wb < 0.5) pic = strzone(strcat("gfx/inva5_", substring(pic1, 8, strlen(pic1) - 8)));
		else return;
		
		Sbar_DrawPic(v, pic, sbar_alpha, 1);
		strunzone(pic);
	}
	else if ((items & itemnum) || (cl_items & itemnum))
	{
		if (currentweap == itemnum)
			pic = pic2;
		else	pic = pic1;
		Sbar_DrawPic(v, pic, sbar_alpha, 1);
	}
};

void() displayIntro =
{
	if (!isLocal() || hasRunes())
		return;
		
	vector optioncol, mapcol;
	
	if (introtimer < 2)
		introtimer+=0.01;
	else
		introtimer = 0;
	
	
	optioncol_x = 0;
	optioncol_y = introtimer;
	optioncol_z = 0;
	
	mapcol_x = 0;
	mapcol_y = introtimer;
	mapcol_z = introtimer;
	
	/*Sbar_DrawString('-290 347', "Quake 1.5 Private Beta 2 test build", .7, '8 8 0', '1 0 0');
	
	if (time < 18)
	{
		Sbar_DrawString('-290 347', "Quake 1.5 Private Beta 2 test build", .5, '8 8 0', '1 0 0');
		Sbar_DrawString('-290 337', "build date - 14 Nov 2018", 1, '8 8 0', optioncol);
		Sbar_DrawString('-290 327', "Author: BloodShot", 1, '8 8 0', optioncol + '.5 0 1');	
	}
	else
	{
		Sbar_DrawString('-290 337', "build date - 14 Nov 2018", .4, '8 8 0', '1 0 0');
		Sbar_DrawString('-290 327', "Author: BloodShot", .4, '8 8 0', '1 0 0');
	}*/
	
	if (time < 18 && world.message == "Introduction")// && (!deathmatch && !coop))
	{
		Sbar_DrawString('-280 212', "Welcome to          , forked from Seven's Small Mod Compilation 5.30", 1, '8 8 0', '1 1 1');
		Sbar_DrawString('-280 212', "           Quake 1.5", 1, '8 8 0', '1 1 0');
		Sbar_DrawString('-285 172', "Press the '    ' key to access mod menus for keybinds and game options", 1, '8 8 0', '1 1 1');
		Sbar_DrawString('-285 172', "           Home", 1, '8 8 0', optioncol);
		
		Sbar_DrawString('-205 132', "The '         ' key opens the custom level menu", 1, '8 8 0', '1 1 1');
		Sbar_DrawString('-205 132', "     Backspace", 1, '8 8 0', mapcol);
	}
	
}

void() setHUDparms =
{ 
	//ammo types
	grenade_ammo = getstati(40);
	shell_ammo = getstati(STAT_SHELLS);
	nail_ammo = getstati(STAT_NAILS);
	rocket_ammo = getstati(STAT_ROCKETS);
	cell_ammo = getstati(STAT_CELLS);
	player_health = getstati(STAT_HEALTH);
	
	//DM
	time_limit = getstati(STAT_TIMELIMIT);
	
	if (ctf)
		frag_limit = cvar("ctf_capture_limit");
	else
		frag_limit = cvar("fraglimit");
	
	//Coop
	life_count = getstati(45);
	
	//CTF
	BLUE_CAPS = getstati(49);
	RED_CAPS = getstati(50);
	
	ctf = getstati(51);
	
	
	//powerup counter display
	invis_count = getstati(41);
	quad_count = getstati(42);
	bio_count = getstati(43);
	pent_count = getstati(44);
	slow_count = getstati(46);
	SNDSPD = getstati(47);
	
	
	//selected weapon
	currentweap = getstati(STAT_ACTIVEWEAPON);
	
}

void() fixIntermission = 
{
	//finale sequence player entity position change check
	discrepancy = getpropertyvec(VF_ORIGIN) - getentityvec(player_localentnum, E_ORIGIN);
	if ((fabs(discrepancy_x)>100)||(fabs(discrepancy_y)>100)||(fabs(discrepancy_z)>100)) finale = 1;	
	if ((intermission && !finale) || finale == 1)
	{
		if (finale == 1) finale = 2;
		cvar_set("sensitivity", "0");			// disable mouselook
		viewpos = getentityvec(player_localentnum, E_ORIGINANDVECTORS);
		viewang = vectoangles2(v_forward, v_up);
		viewang_x = - viewang_x;

		viewang_x = viewang_x + sin(time * 0.5) * 0.75;	// camera sway
		viewang_y = viewang_y + sin(time * 1) * 0.75;
		viewang_z = viewang_z + sin(time * 0.25) * 0.25;
		viewang_x++;

		setproperty(VF_ORIGIN, viewpos);
		setproperty(VF_ANGLES, viewang);
	}
	else if	(cvar("sensitivity"))	mouse = cvar("sensitivity");
}

void() wepFlash =
{
	// weapon icons flash
	if ((items & IT_AXE         ) && axe  == 0) axe = time;
	if ((items & IT_SHOTGUN          ) && sg  == 0) sg = time;
	if ((items & IT_SUPER_SHOTGUN    ) && ssg == 0) ssg = time;
	if ((items & IT_NAILGUN          ) && ng  == 0) ng = time;
	if ((items & IT_SUPER_NAILGUN	 ) && sng == 0) sng = time;
	if ((items & IT_GRENADE_LAUNCHER ) && gl  == 0) gl = time;
	if ((items & IT_ROCKET_LAUNCHER  ) && rl  == 0) rl = time;
	if ((items & IT_LIGHTNING        ) && lg  == 0) lg = time;
	//if ((cl_items & IT_CHAINSAW        ) && csaw  == 0) csaw = time;
	//if ((items & IT_LASER_CANNON        ) && las  == 0) las = time;
	
	if (axe > 0 && (time - axe ) >= 1) axe  = -1;
	if (sg > 0 && (time - sg ) >= 1) sg  = -1;
	if (ssg> 0 && (time - ssg) >= 1) ssg = -1;
	if (ng > 0 && (time - ng ) >= 1) ng  = -1;
	if (sng> 0 && (time - sng) >= 1) sng = -1;
	if (gl > 0 && (time - gl ) >= 1) gl  = -1;
	if (rl > 0 && (time - rl ) >= 1) rl  = -1;
	if (lg > 0 && (time - lg ) >= 1) lg  = -1;
	//if (csaw > 0 && (time - csaw ) >= 1) csaw  = -1;
	//if (las > 0 && (time - las ) >= 1) las  = -1;
}

//float fadealpha[] = {1, .95, .9, .85, .8, .75, .7, .65, .6, .55, .5, .45, .4, .3, .2, .1};


void() fade_camera =
{
	/*for (float i = 0; i <= 10; i++)
	{
		drawfill('-70 -70','2000 2000', '0 0 0', fadealpha[i], 0);
	}*/
	
	if (world.message == "the Slipgate Complex" || world.message == "Introduction" || world.message == "Termination Central" || world.message == "the Sewage System" || world.message == "the Installation")
	{
	
	//Hardcoded alpha values because for some reason passing a variable into alpha isn't updating correctly
		if (cltime < 2)
			drawfill('-70 -70','2000 2000', '0 0 0', 2, 0);
		else if (cltime < 2.1)
			drawfill('-70 -70','2000 2000', '0 0 0', .98, 0);
		else if (time < 2.15)
			drawfill('-70 -70','2000 2000', '0 0 0', .95, 0);
		else if (time < 2.2)
			drawfill('-70 -70','2000 2000', '0 0 0', .9, 0);
		else if (time < 2.25)
			drawfill('-70 -70','2000 2000', '0 0 0', .85, 0);
		else if (time < 2.3)
			drawfill('-70 -70','2000 2000', '0 0 0', .8, 0);
		else if (time < 2.35)
			drawfill('-70 -70','2000 2000', '0 0 0', .75, 0);
		else if (time < 2.4)
			drawfill('-70 -70','2000 2000', '0 0 0', .7, 0);
		else if (time < 2.45)
			drawfill('-70 -70','2000 2000', '0 0 0', .65, 0);
		else if (time < 2.5)
			drawfill('-70 -70','2000 2000', '0 0 0', .6, 0);
		else if (time < 2.55)
			drawfill('-70 -70','2000 2000', '0 0 0', .55, 0);
		else if (time < 2.6)
			drawfill('-70 -70','2000 2000', '0 0 0', .5, 0);
		else if (time < 2.65)
			drawfill('-70 -70','2000 2000', '0 0 0', .45, 0);
		else if (time < 2.7)
			drawfill('-70 -70','2000 2000', '0 0 0', .4, 0);
		else if (time < 2.75)
			drawfill('-70 -70','2000 2000', '0 0 0', .35, 0);
		else if (time < 2.8)
			drawfill('-70 -70','2000 2000', '0 0 0', .3, 0);
		else if (time < 2.85)
			drawfill('-70 -70','2000 2000', '0 0 0', .25, 0);
		else if (time < 2.9)
			drawfill('-70 -70','2000 2000', '0 0 0', .2, 0);
		else if (time < 2.95)
			drawfill('-70 -70','2000 2000', '0 0 0', .18, 0);
		else if (time < 3)
			drawfill('-70 -70','2000 2000', '0 0 0', .17, 0);
		else if (time < 3.05)
			drawfill('-70 -70','2000 2000', '0 0 0', .15, 0);
		else if (time < 3.1)
			drawfill('-70 -70','2000 2000', '0 0 0', .13, 0);
		else if (time < 3.15)
			drawfill('-70 -70','2000 2000', '0 0 0', .1, 0);
		else if (time < 3.2)
			drawfill('-70 -70','2000 2000', '0 0 0', .09, 0);
		else if (time < 3.25)
			drawfill('-70 -70','2000 2000', '0 0 0', .07, 0);
		else if (time < 3.3)
			drawfill('-70 -70','2000 2000', '0 0 0', .05, 0);
		else if (time < 3.35)
			drawfill('-70 -70','2000 2000', '0 0 0', .03, 0);
		else if (time < 3.4)
			drawfill('-70 -70','2000 2000', '0 0 0', .01, 0);
	}
}


void(vector color) DrawLevelName =
{
	if (!cvar("hud_showtitle"))
		return;
		
	local vector pos = '-130, 872';
	
	
	//Recenter the title based on string length
	if (strlen(world.message) >= 28)
		pos = '-260, 872';
	else if (strlen(world.message) >= 20)
		pos = '-190, 872';
	else if (strlen(world.message) > 17)
		pos = '-160, 872';
	else if (strlen(world.message) <= 13)
		pos = '-100, 872';
	else if (strlen(world.message) <= 10)
		pos = '-80, 872';
			
		
	//Random jitter on title
	if( random() < 0.9)
	{
		pos_x += random() * .2;
		pos_y += (random() * .2) + 280;
	}
	else if (random() < 0.2)
	{
		pos_x += random() * 5;
		pos_y += (random() * 5) + 280;
	}
	pos_z = 0;
	//alpha+=1;

	//if (title_timer < 1900)
		//title_timer++;
	
	//Hardcoded alpha values because for some reason passing a variable into alpha isn't updating correctly
	if (cltime < 5)
		Sbar_DrawString(pos, world.message, 0.1, '18 18 0', color);
	else if (cltime < 5.5)
		Sbar_DrawString(pos, world.message, 0.2, '18 18 0', color);
	else if (time < 6)
		Sbar_DrawString(pos, world.message, 0.3, '18 18 0', color);
	else if (time < 6.5)
		Sbar_DrawString(pos, world.message, 0.4, '18 18 0', color);
	else if (time < 7)
		Sbar_DrawString(pos, world.message, 0.5, '18 18 0', color);
	else if (time < 7.5)
		Sbar_DrawString(pos, world.message, 0.7, '18 18 0', color);
	else if (time < 8)
		Sbar_DrawString(pos, world.message, 0.8, '18 18 0', color);
	else if (time < 8.5)
		Sbar_DrawString(pos, world.message, 0.9, '18 18 0', color);
	else if (time < 9)
		Sbar_DrawString(pos, world.message, 1, '18 18 0', color);
	else if (time < 11)
		Sbar_DrawString(pos, world.message, 0.9, '18 18 0', color);
	else if (time < 11.5)
		Sbar_DrawString(pos, world.message, 0.8, '18 18 0', color);
	else if (time < 12)
		Sbar_DrawString(pos, world.message, 0.7, '18 18 0', color);
	else if (time < 12.5)
		Sbar_DrawString(pos, world.message, 0.6, '18 18 0', color);
	else if (time < 13)
		Sbar_DrawString(pos, world.message, 0.5, '18 18 0', color);
	else if (time < 13.5)
		Sbar_DrawString(pos, world.message, 0.3, '18 18 0', color);
	else if (time < 14)
		Sbar_DrawString(pos, world.message, 0.2, '18 18 0', color);
}

void() DrawScoreboard =
{
	if (!ctf && ((deathmatch && showscores) || (deathmatch && player_health < 1) || (deathmatch && intermission)))
	{
		Sbar_DrawPic('100 252', "textures/HUD/Fraglimit_banner.png", sbar_alpha, 1);
		//Sbar_DrawString('80 320', "fraglimit", 1, '8 8 0', '0 1 0');
		//Sbar_DrawString('100 310', ftos(frag_limit), 1, '8 8 0', '1 .5 0');
		Sbar_DrawNum('120 220', frag_limit, 4, 0, 1);
	}
	else if ((ctf && showscores) || (ctf && player_health < 1) || (ctf && intermission))
	{
		Sbar_DrawPic('90 252', "textures/HUD/caplimit_banner.png", sbar_alpha, .8);
		//blue captures
			Sbar_DrawPic('110 163', "textures/HUD/HUD_ctf_blue.png", sbar_alpha, .5);
			Sbar_DrawNum('170 163', BLUE_CAPS, 2, 1, sbar_alpha);
			
		//red captures
			Sbar_DrawPic('110 113', "textures/HUD/HUD_ctf_red.png", sbar_alpha, .5);
			Sbar_DrawNum('170 113', RED_CAPS, 2, 1, sbar_alpha);
		
		//frag limit repurposed as cap limit	
		Sbar_DrawNum('120 220', frag_limit, 4, 0, 1);
	
	}
	/*if (deathmatch && intermission)
	{
		Sbar_DrawString('50 302', "--- 1st Place", 1, '8 8 0', '0 1 .1');
		
	}*/
}

void() DrawHUD = 
{
	
	setHUDparms();
	
	if (player_health < 1)
		return;
	
	if (showscores)
		return;
	
	
	if (coop)
	{
		if (life_count > 0) //don't draw life counter in regular coop games
		{
			Sbar_DrawPic('-34 350', "textures/HUD/HUD_lives.png", sbar_alpha, .95);
			if (life_count >= 100)
				Sbar_DrawNum('-13 350', life_count, 3, 1, sbar_alpha);
			else if (life_count > 10)
				Sbar_DrawNum('-27 350', life_count, 3, 1, sbar_alpha);
			else 
				Sbar_DrawNum('-33 350', life_count, 3, 1, sbar_alpha);
		}
	}
		
	if (ctf)
	{
		
		ctfbar_offset_x = 0;
		ctfbar_offset_y = wepbar_offset_y;
		//blue captures
			Sbar_DrawPic('0 353' + ctfbar_offset, "textures/HUD/HUD_ctf_blue.png", sbar_alpha, .5);
			Sbar_DrawNum('22 351' + ctfbar_offset, BLUE_CAPS, 2, 1, sbar_alpha);
			
		//red captures
			Sbar_DrawPic('-32 353' + ctfbar_offset, "textures/HUD/HUD_ctf_red.png", sbar_alpha, .5);
			Sbar_DrawNum('-91 351' + ctfbar_offset, RED_CAPS, 2, 1, sbar_alpha);
	
	}	
		
	wepFlash();
	
	//Grenade Counter
	if (cvar("hud_proxcount_big")) //Choose between large/small grenade indicators
	{
		if (grenade_ammo > 0)
			Sbar_DrawPic('170 23', "textures/HUD/HUD_prox.png", sbar_alpha, .98);
		else
			Sbar_DrawPic('170 23', "textures/HUD/HUD_prox_empty.png", sbar_alpha, .98);
		//display prox ammo with HUD font
		if (grenade_ammo > 9)
			Sbar_DrawNum('204 24', grenade_ammo, 2, 0, sbar_alpha);
		else
			Sbar_DrawNum('203 24', grenade_ammo, 2, 2, sbar_alpha);
		
	}
	else
	{
		if (grenade_ammo > 0)
			Sbar_DrawPic('-171 48', "textures/HUD/HUD_prox.png", 1, .4);
		else
			Sbar_DrawPic('-171 48', "textures/HUD/HUD_prox_empty.png", 1, .4);
		
		Sbar_DrawString('-184 48', ftos(grenade_ammo), 1, '8 8 0', '1 .5 .2');
	}
	
	//Items and Powerups
	
	getItems(); //grab keys/powerup info from player
	
	if (showHUD == 1)
	{
		//Keys
		if (ctf)
		{
			DrawInventory('270 68' + wepbar_offset, "gfx/bluflag",   IT_KEY1, 0, sbar_alpha, 1.3);
			DrawInventory('270 68' + wepbar_offset, "gfx/redflag",   IT_KEY2, 0, sbar_alpha, 1.3);
		}
		else
		{
			DrawInventory('270 68' + wepbar_offset, "gfx/sb_key1",   IT_KEY1, 0, sbar_alpha, 1.2);
			DrawInventory('290 68' + wepbar_offset, "gfx/sb_key2",   IT_KEY2, 0, sbar_alpha, 1.2);
		}
		
		//Powerup Sidebar - counters change to red when powerup is running low
		
		//Ring + Counter
		DrawInventory('270 98' + wepbar_offset, "gfx/sb_invis",  IT_INVISIBILITY, 0, sbar_alpha, 1.2);
		
		if (items & IT_INVISIBILITY)
		{
			if (invis_count > 8)
				Sbar_DrawString('263 89' + wepbar_offset, ftos(invis_count), 1, '8 8 0', '1 .8 .1');
			else if (invis_count > 0)
				Sbar_DrawString('263 89' + wepbar_offset, ftos(invis_count), 1, '8 8 0', '1 .1 0');
		}
		
		//Pent + Counter
		DrawInventory('270 128' + wepbar_offset, "gfx/sb_invuln", IT_INVULNERABILITY, 0, sbar_alpha, 1.2);
		if (items & IT_INVULNERABILITY)
		{
		
			if (pent_count > 8)
				Sbar_DrawString('263 119' + wepbar_offset, ftos(pent_count), 1, '8 8 0', '1 .8 .1');
			else if (pent_count > 0)
				Sbar_DrawString('263 119' + wepbar_offset, ftos(pent_count), 1, '8 8 0', '1 .1 0');
		
		}	
		
		//Biosuit + Counter
		DrawInventory('270 158' + wepbar_offset, "gfx/sb_suit",   IT_SUIT, 0, sbar_alpha, 1.2);
		if (items & IT_SUIT)
		{
			
			
			if (bio_count > 8)
				Sbar_DrawString('263 149' + wepbar_offset, ftos(bio_count), 1, '8 8 0', '1 .8 .1');
			else if (bio_count > 0)
				Sbar_DrawString('263 149' + wepbar_offset, ftos(bio_count), 1, '8 8 0', '1 .1 0');
			
		}
			
		//Quad + Counter
		DrawInventory('270 188' + wepbar_offset, "gfx/sb_quad",   IT_QUAD, 0, sbar_alpha, 1.2);
		if (items & IT_QUAD)
		{
			if (quad_count > 8)
				Sbar_DrawString('263 179' + wepbar_offset, ftos(quad_count), 1, '8 8 0', '1 .8 .1');
			else if (quad_count > 0)
				Sbar_DrawString('263 179' + wepbar_offset, ftos(quad_count), 1, '8 8 0', '1 .1 0');
		}
		
		//Bullet time powerup
		if (slow_count > 0)
		{
			Sbar_DrawPic('-283 179' - wepbar_offset, "gfx/tmrune", 1, 1);
			Sbar_DrawString('-281 170' - wepbar_offset, ftos(slow_count), 1, '8 8 0', '1 .8 .1');
		}
		
		//Runes
		DrawInventory('270 40' + wepbar_offset, "gfx/sb_sigil1", 0, RUNE_EP1, sbar_alpha, 1.3);
		DrawInventory('280 40' + wepbar_offset, "gfx/sb_sigil2", 0, RUNE_EP2, sbar_alpha, 1.3);
		DrawInventory('290 40' + wepbar_offset, "gfx/sb_sigil3", 0, RUNE_EP3, sbar_alpha, 1.3);
		DrawInventory('300 40' + wepbar_offset, "gfx/sb_sigil4", 0, RUNE_EP4, sbar_alpha, 1.3);
		
		//Weapon bar
		DrawInventoryWeapon('280 231' + wepbar_offset, "gfx/inv_shotgun",  "gfx/inv2_shotgun",  IT_SHOTGUN, sg);
		DrawInventoryWeapon('280 248' + wepbar_offset, "gfx/inv_sshotgun", "gfx/inv2_sshotgun", IT_SUPER_SHOTGUN, ssg);
		DrawInventoryWeapon('280 265' + wepbar_offset, "gfx/inv_nailgun",  "gfx/inv2_nailgun",  IT_NAILGUN, ng);
		DrawInventoryWeapon('280 282' + wepbar_offset, "gfx/inv_snailgun", "gfx/inv2_snailgun", IT_SUPER_NAILGUN, sng);
		DrawInventoryWeapon('280 299' + wepbar_offset, "gfx/inv_rlaunch",  "gfx/inv2_rlaunch",  IT_GRENADE_LAUNCHER, gl);
		DrawInventoryWeapon('280 316' + wepbar_offset, "gfx/inv_srlaunch", "gfx/inv2_srlaunch", IT_ROCKET_LAUNCHER, rl);
		DrawInventoryWeapon('260 333' + wepbar_offset, "gfx/inv_lightng",  "gfx/inv2_lightng",  IT_LIGHTNING, lg);
		
		//Custom weapons from q15
		DrawInventoryWeapon('280 214' + wepbar_offset, "textures/HUD/HUD_saw",  "textures/HUD/HUD_saw_select",  IT_CHAINSAW, -1);
		DrawInventoryWeapon('260 350' + wepbar_offset, "textures/HUD/HUD_Laser.png", "textures/HUD/HUD_Laser_select", IT_LASER_CANNON, -1);
		
		//180 200
		
	}
	
	//Ammo icons and counters
	
	//if statement controls hiding of the new ammo counter depending on user settings
	if ((showHUD > 0 && cvar("hud_colored_ammo") == 1) || (showHUD > 1 && cvar("hud_colored_ammo") == 0) )
	{
		//Shells icon
		Sbar_DrawPic('-119 48', "textures/HUD/HUD_shells.png", sbar_alpha, .4);
		
		
		//Nails icon
		Sbar_DrawPic('-72 48', "textures/HUD/HUD_nails.png", sbar_alpha, .4);
		
		
		//Rockets Icon
		Sbar_DrawPic('-22 48', "textures/HUD/HUD_rockets.png", sbar_alpha, .4);
		
		
		//Cells Icon
		Sbar_DrawPic('23 48', "textures/HUD/HUD_cells.png", sbar_alpha, .4);
		
		if (showHUD == 1) //alternate mini-ammo counters
		{
			
			//Shellcount
			if (shell_ammo < 10)
				Sbar_DrawString('-135 48', ftos(shell_ammo), 1, '8 8 0', '1 .1 0');
			else if (shell_ammo < 15)
				Sbar_DrawString('-139 48', ftos(shell_ammo), 1, '8 8 0', '1 .1 0');
			else if (shell_ammo < 50)
				Sbar_DrawString('-139 48', ftos(shell_ammo), 1, '8 8 0', '1 .5 .2');
			else if (shell_ammo >= 100)
				Sbar_DrawString('-147 48', ftos(shell_ammo), 1, '8 8 0', '.7 .8 .2');
			else
				Sbar_DrawString('-139 48', ftos(shell_ammo), 1, '8 8 0', '.7 .8 .2');
			//nailcount
			if (nail_ammo < 25)
				Sbar_DrawString('-91 48', ftos(nail_ammo), 1, '8 8 0', '1 .1 0');
			else if (nail_ammo < 100)
				Sbar_DrawString('-91 48', ftos(nail_ammo), 1, '8 8 0', '1 .5 .2');
			else
				Sbar_DrawString('-99 48', ftos(nail_ammo), 1, '8 8 0', '.7 .8 .2');
			
			//rocketcount
			if (rocket_ammo < 15)
				Sbar_DrawString('-42 48', ftos(rocket_ammo), 1, '8 8 0', '1 .1 0');
			else if (rocket_ammo < 50)
				Sbar_DrawString('-42 48', ftos(rocket_ammo), 1, '8 8 0', '1 .5 .2');
			else if (rocket_ammo >= 100)
				Sbar_DrawString('-50 48', ftos(rocket_ammo), 1, '8 8 0', '.7 .8 .2');
			else
				Sbar_DrawString('-42 48', ftos(rocket_ammo), 1, '8 8 0', '.7 .8 .2');
			//Cellcount
			if (cell_ammo < 15)
				Sbar_DrawString('3 48', ftos(cell_ammo), 1, '8 8 0', '1 .1 0');
			else if (cell_ammo < 50)
				Sbar_DrawString('3 48', ftos(cell_ammo), 1, '8 8 0', '1 .5 .2');
			else if (cell_ammo >= 100)
				Sbar_DrawString('-5 48', ftos(cell_ammo), 1, '8 8 0', '.7 .8 .2');
			else
				Sbar_DrawString('3 48', ftos(cell_ammo), 1, '8 8 0', '.7 .8 .2');
			
		}
	}
	
	
	
	//cvar_set("hud_size", ftos(hideHUD));

	
}

void() initConvars = 
{
	vid_conwidth = cvar("vid_conwidth");
	vid_conheight = cvar("vid_conheight");
	sbar_alpha = cvar("sbar_alpha_fg");
	
	if (cvar("viewsize") == 100)
		showHUD = 2;
	else if (cvar("viewsize") == 110)
		showHUD = 1;
	else if (cvar("viewsize") == 120)
		showHUD = 0;
}