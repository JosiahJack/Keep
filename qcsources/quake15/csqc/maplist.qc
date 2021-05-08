//file handle
float mapindex;
float mapcount;
//arrays to store maps
string mapstring[1000];
string maplist[1000];
//float MDL_INDEX_START = 0;
//float MDL_INDEX_LEN;
float POINTS_TO_BSP;
float FILE_EXT = 9;

vector posveclist;


void() create_maplist =
{
	mapindex = search_begin("maps/*.bsp", TRUE, TRUE );
	mapcount = search_getsize(mapindex);
	posveclist = '-60 292';
	for (float j = 0; j < mapcount; j++)
	{
		
		mapstring[j] = strzone(search_getfilename(mapindex, j));
		//maplist[j] = strstrofs(mapstring[j],".bsp", 0);
		//mapstring[j] = strzone(substring(mapstring[j], -4, -5));
		
		//Check for filenames starting with b_, these are BSP models and should not be in your map list
		//IS_MODEL = strstrofs(mapstring[j],"b_", 0);
		//if (IS_MODEL == -1)
			maplist[j] = strzone(substring(mapstring[j],5, strlen(mapstring[j])-FILE_EXT));
			
		//else
			//MDL_INDEX_LEN+=1;
	

		
	}
	search_end(mapindex);
}

void() draw_cursor = 
{
	 drawSelectArrow('-80 282', 1);
}

float arrowPos;

void() loadMap =
{
	local float IS_MODEL;
	IS_MODEL = strstrofs(maplist[arrowPos],"b_", 0);
				
	if(IS_MODEL == -1)
	{
		//If SP, use map command, else use changelevel to keep clients connected
		if(cvar("deathmatch") == 0 && cvar("coop") == 0)
		{
			updateServerMaxPlayers();
			localcmd(strcat("map ", maplist[arrowPos], "\n"));
		}
		else if (mp_change != maxplayers)
		{
			updateServerMaxPlayers();
			localcmd(strcat("map ", maplist[arrowPos], "\n"));
			//updateServerMaxPlayers();
			
		}
		else
		{
			updateServerMaxPlayers();
			localcmd(strcat("changelevel ", maplist[arrowPos], "\n"));
			
		}
	}
}

void() SkillSelect =
{
	if (cvar("skill") == 0)
		cvar_set("skill", "1");
	else if (cvar("skill") == 1)
		cvar_set("skill", "2");
	else if (cvar("skill") == 2)
		cvar_set("skill", "3");
	else if (cvar("skill") == 3)
		cvar_set("skill", "0");
}

void() ShowMapList =
{
	
	if (inMenu == 4)
	{
		SkillCheck();
		
		POINTS_TO_BSP = strstrofs(maplist[arrowPos],"b_", 0);
		Sbar_DrawPic('-115 330', "gfx/cust_maps", 1, 1);
		
		vector posvecoff = '0 0';
		
		
		draw_cursor();
		Sbar_DrawString('80 42' , "Skill:", 1, '8 8 0', '1 1 1');
		
		if (whatskill == 3)
			Sbar_DrawString('140 42' , skill[whatskill], 1, '8 8 0', '1 0 0');
		else if (whatskill == 0)
			Sbar_DrawString('140 42' , skill[whatskill], 1, '8 8 0', '0 1 .5');
		else
			Sbar_DrawString('140 42' , skill[whatskill], 1, '8 8 0', '1 .6 0');
			
		Sbar_DrawString('80 32' , "(END to change)", 1, '8 8 0', '.7 .7 .7');
		
		for (float j = 0; j < 1000; j++)
		{
			local float IS_MODEL;
			
			IS_MODEL = strstrofs(maplist[j],"b_", 0);
			posvecoff+= '0 -10';
			
				
				{
					

					if ((posveclist_y+posvecoff_y <= 292) && (posveclist_y+posvecoff_y >= 70))
					{
						if (IS_MODEL == -1)
							Sbar_DrawString(posveclist+posvecoff , maplist[j], 1, '8 8 0', '1 .6 .3');
						else
							Sbar_DrawString(posveclist+posvecoff , maplist[j], 1, '8 8 0', '.6 .6 .6');
							//Sbar_DrawString(posveclist+posvecoff , strcat(maplist[j]," - (BSP MODEL)"), 1, '8 8 0', '1 0 0');
					}
				}
			
	
		}
		
		//Subtract 19 from map count, hard coded as that is the amount of bsp models in the mod
		Sbar_DrawString('-80 42', strcat(ftos(mapcount - 19), " maps found"), 1, '8 8 0', '1 .3 .1');
		//Sbar_DrawString('-100 32', "maps found", 1, '8 8 0', '1 .3 .1');
		
		if (!POINTS_TO_BSP)
			Sbar_DrawString('70 22', "!BSP MODEL, NOT A MAP!", 1, '8 8 0', '1 0 0');
			
		Sbar_DrawString('80 62' , "Start Server/Botmatch", 1, '8 8 0', '0 1 0');
		Sbar_DrawString('80 52' , "(HOME)", 1, '8 8 0', '0 1 .5');
			
		Sbar_DrawString('-150 12', "Up and Down arrow to scroll, left and right to skip", 1, '8 8 0', '.7 .7 .7');
			
	}
	
}
