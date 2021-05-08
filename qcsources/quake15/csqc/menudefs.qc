//string keybind1, keybind2, keybind3;
float keySelect, sliderPos;
float bindMode;
float blinktimer;
float cursorselect[15];
float UIDraw;
string stGtype;




//Keybind tracker
float keybound1, keybound2, keybound3, keybound4, keybound5, keybound6, keybound7, keybound8;
//string grenbind, kickbind, flashbind, chasebind, addbind, addTbind, removebind;
string binds[8];

//monster settings
float yaka;//, yakb, yakc, yakd, yake;

void(vector pos, float alpha) drawSelectArrow =
{
	blinktimer++;
	if (blinktimer > 35)
		Sbar_DrawCharacter(pos, 13, alpha);
	if (blinktimer > 65)
		blinktimer = 0;
}

//Menu selector - sets up initial cursor position and skips blank spaces based on defined offsets

void() menuItemSelector =
{
	local vector pos[16];
	local vector posoffset;
	//pos = '-75 262';
	posoffset = '0 0';
	
	for (float i = 0; i <= 15; i++)
	{
		pos[i] = '-75 262'; //first menu option position
	}
	
	if (inMenu == 1)
	{
		for (float j = 0; j <= 15; j++)
		{
			if (j >= 1)
				posoffset+= '0 10'; //skip a line so selector arrow is drawn under the last
			if (j == 4)
				posoffset+= '0 30'; //Skip 30 to account for the title string
			if (j == 8)
				posoffset+= '0 2';//Skip 2 to get to UI slider (offset by 2 because I didn't account for modifying this menu with extra binds)
			if (j == 9)
				posoffset+= '0 8';//Skip 8 to get page changer
			
			pos[j] = pos[j] - posoffset;
			
		}
		
		drawSelectArrow(pos[keySelect - 1], 1); //Draw the arrow to show highlighted option, 
							   //keySelect is the tracker for how many times you pressed down/uparrow
							   
		if (keySelect == 9)
			UIDraw = 1;
		else
			UIDraw = 0;
	}
	else if (inMenu == 2)
	{
		for (float j = 0; j <= 15; j++)
		{
			if (j >= 1)
				posoffset+= '0 10'; //skip a line so selector arrow is drawn under the last
			if (j == 3)
				posoffset+= '0 30'; //Skip 30 to account for the title string
			if (j == 8)
				posoffset+= '0 20';//Skip 20 to get to HUD options
			if (j == 13)
				posoffset+= '0 10';//Skip 20 to get to page options
			
			pos[j] = pos[j] - posoffset;
		}
		
		drawSelectArrow(pos[keySelect - 1], 1);
		
	}
	else if (inMenu == 3)
	{
		
		for (float j = 0; j <= 15; j++)
		{
			if (j >= 1)
				posoffset+= '0 10'; //skip a line so selector arrow is drawn under the last
			if (j == 14)
				posoffset+= '0 50';//Skip 20 to get to page options
			
			pos[j] = pos[j] - posoffset;
		}
		
		drawSelectArrow(pos[keySelect - 1], 1);
	}
	else if (inMenu == 5)
	{
		
		for (float j = 0; j <= 14; j++)
		{
			if (j >= 1)
				posoffset+= '0 10'; //skip a line so selector arrow is drawn under the last
			if (j == 10)
				posoffset+= '0 30';//Skip 20 to get to page options
			
			pos[j] = pos[j] - posoffset;
		}
		
		drawSelectArrow(pos[keySelect - 1], 1);
	}	
		
}



void() saveCFG =
{
	local float fedit;
	local string savedcvar[20];
	
	//prep array to write into cfg file with the console values from the settings menu
	savedcvar[0] = strcat("'", ftos(cvar("redarmor_backpack")),"'");
	savedcvar[1] = strcat("'",ftos(cvar("chainsaw_drops")),"'");
	savedcvar[2] = strcat("'",ftos(cvar("soldier_nailgrunt")),"'");
	savedcvar[3] = strcat("'",ftos(cvar("enforcer_defender")),"'");
	savedcvar[4] = strcat("'",ftos(cvar("enforcer_defender_prox")),"'");
	savedcvar[5] = strcat("'",ftos(cvar("shalrath_mother")),"'");
	savedcvar[6] = strcat("'",ftos(cvar("wizardteleport")),"'");
	savedcvar[7] = strcat("'",ftos(cvar("fire_projectiles_and_lava_inflame_time")),"'");
	savedcvar[8] = strcat("'",ftos(cvar("yakman_replace_shambler")),"'");
	savedcvar[9] = strcat("'",ftos(cvar("hud_proxcount_big")),"'");
	savedcvar[10] = strcat("'",ftos(cvar("hud_showtitle")),"'");
	savedcvar[11] = strcat("'",ftos(cvar("qc_ssg")),"'");
	savedcvar[12] = strcat("'",ftos(cvar("centered_weapons")),"'");
	savedcvar[13] = strcat("'",ftos(cvar("flamestyle")),"'");
	savedcvar[14] = strcat("'",ftos(cvar("gibsduration")),"'");
	savedcvar[15] = strcat("'",ftos(cvar("slowmotion")),"'");
	savedcvar[16] = strcat("'",ftos(cvar("deathmatch_music")),"'");
	savedcvar[17] = strcat("'",ftos(cvar("slowmo_powerup")),"'");
	savedcvar[18] = strcat("'",ftos(maxplayers),"'");
	savedcvar[19] = strcat("'",ftos(cvar("auto_save")),"'");
	
	//open cfg file for editing
	fedit = fopen("config_menu.cfg", FILE_WRITE);
	
	//write cvars to config
	
	for (float x = 0; x <= 19; x++)
		fputs(fedit, strcat(" ",savedcvar[x]));
	
	//close
	fclose(fedit);
		
}


void() loadCFG =
{
	local float fedit;
	local string readcvar[20];
	
	
	//open cfg file
	fedit = fopen("config_menu.cfg", FILE_READ);
	
	//pull values out of cfg file, delimiter is singlequote (')
	tokenize(fgets(fedit));
	
	for (float x = 0; x <= 19; x++)
		readcvar[x] = argv(x);
	
	//close file
	fclose(fedit);
	
	//set cvars to values read from text file
	
	//tweaks menu
	cvar_set("redarmor_backpack", readcvar[0]);
	cvar_set("chainsaw_drops", readcvar[1]);
	cvar_set("soldier_nailgrunt", readcvar[2]);
	cvar_set("enforcer_defender", readcvar[3]);
	cvar_set("enforcer_defender_prox", readcvar[4]);
	cvar_set("shalrath_mother", readcvar[5]);
	cvar_set("wizardteleport", readcvar[6]);
	cvar_set("fire_projectiles_and_lava_inflame_time", readcvar[7]);
	cvar_set("yakman_replace_shambler", readcvar[8]);	
	
	//HUD
	cvar_set("hud_proxcount_big", readcvar[9]);
	cvar_set("hud_showtitle", readcvar[10]);
	cvar_set("qc_ssg", readcvar[11]);
	
	//effects
	cvar_set("centered_weapons", readcvar[12]);
	cvar_set("flamestyle", readcvar[13]);
	cvar_set("gibsduration", readcvar[14]);
	
	cvar_set("slowmotion", readcvar[15]);
	cvar_set("deathmatch_music", readcvar[16]);
	cvar_set("slowmo_powerup", readcvar[17]);
	
	maxplayers = stof(readcvar[18]);
	
	cvar_set("auto_save", readcvar[19]);
}

//Info panels for different menus
void() infoMenu1 =
{
	if (keySelect != 8 && keySelect != 9 && keySelect != 10)
			Sbar_DrawString('-150 62', "Press DELETE to clear keybinds", 1, '8 8 0', '1 .8 0');
		if (keySelect == 1)
		{
			Sbar_DrawString('-120 92', "Throws Proximity Grenade", 1, '8 8 0', '.7 .7 .7');
			Sbar_DrawString('-60 82', "Default: G", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 2)
		{
			Sbar_DrawString('-140 92', "Quick Melee Kick, knocks back enemies", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: Shift", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 3)
		{
			Sbar_DrawString('-90 92', "Toggle Flashlight", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: F", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 4)
		{
			Sbar_DrawString('-115 92', "Toggle 3rd person camera", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: C", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 5)
		{
			Sbar_DrawString('-145 92', "Add bot (friendly bot in team games)", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: F1", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 6)
		{
			Sbar_DrawString('-120 92', "Add enemy bot in team games", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: F2", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 7)
		{
			Sbar_DrawString('-60 92', "Remove a bot", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: F3", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 8)
		{
			Sbar_DrawString('-145 92', "Use offhand grapple (MP games only)", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-60 82', "Default: Q", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 9)
		{
			Sbar_DrawString('-90 92', "Scale HUD/UI up and down", 1, '8 8 0', '.6 .6 .6');
			//Sbar_DrawString('-120 82', "(does not apply to 4:3 resolutions)", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 10)
		{
			Sbar_DrawString('-120 92', "Visuals, HUD, and Server options", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 11)
		{
			Sbar_DrawString('-120 92', "Tweak additional monster/item settings", 1, '8 8 0', '.6 .6 .6');
		}
}

void() infoMenu2 =
{
	if (keySelect == 1)
		{
			Sbar_DrawString('-180 42', "Determines quality of particles, gib lifetime, ", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-180 32', "and other settings defined in q15_config_coop.cfg", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-180 22', "(low) and q15_config.cfg (high)", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-110 12', "-- REQUIRES MAP RESTART --", 1, '8 8 0', '1 .1 0');
		}
		if (keySelect == 2)
		{
			Sbar_DrawString('-140 42', "Determines the maximum amount of", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-140 32', "decals (blood, bullet holes, etc.)", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-140 22', "active before removing old ones", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-130 12', "Min: 1500", 1, '8 8 0', '1 0 0');
			Sbar_DrawString('-40 12', "Medium: 2800", 1, '8 8 0', '1 .8 0');
			Sbar_DrawString('70 12', "Max: 4500", 1, '8 8 0', '0 1 0');
		}
		if (keySelect == 3)
		{
			Sbar_DrawString('-140 42', "Determines the maximum amount of", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-160 32', "time (in seconds) decals remain before being removed", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-130 12', "Min: 200", 1, '8 8 0', '1 0 0');
			Sbar_DrawString('-40 12', "Medium: 900", 1, '8 8 0', '1 .8 0');
			Sbar_DrawString('70 12', "Max: 4500", 1, '8 8 0', '0 1 0');
		}
		if (keySelect == 4)
		{
			Sbar_DrawString('-180 42', "Enables lives in cooperative play - players respawn ", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-180 32', "where they died, megahealth gives a bonus life to all", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-180 22', "and the map restarts once all players are dead", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 5)
		{
			Sbar_DrawString('-150 42', "Amount of lives per player in coop -", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-160 32', "configurable with coop_lives in console", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 6)
		{
			Sbar_DrawString('-150 42', "Spawns additional monsters in a level based on", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-150 32', "the amount specified - good for coop scaling", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-110 22', "-- REQUIRES MAP RESTART --", 1, '8 8 0', '1 .1 0');
		}
		if (keySelect == 7)
		{
			Sbar_DrawString('-150 42', "Gibs stay for specified amount of time, lowering", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-150 32', "will help improve network performance in netgames ", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-150 22', "if set to forever, gibs will never be cleaned up ", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 8)
		{
			Sbar_DrawString('-150 42', "If enabled, autosaves every 2 minutes", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 9)
		{
			Sbar_DrawString('-130 42', "Choose size of proximity grenade indicator", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-130 32', "Large - same size as health/current ammo", 1, '8 8 0', '0 1 0');
			Sbar_DrawString('-130 22', "Tiny - aligned with ammo bar", 1, '8 8 0', '1 0 0');
		}
		if (keySelect == 10)
		{
			Sbar_DrawString('-130 42', "Display level title on map start", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-130 32', "with a fancy fade/twitching effect", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 11)
		{
			Sbar_DrawString('-130 42', "Choose whether to use the old Q15", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-130 32', "SSG Model or the new Quake Champions design", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 12)
		{
			Sbar_DrawString('-180 42', "Modified weapon models inspired by classic Quake -", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-70 32', "centered on screen with tweaked animations", 1, '8 8 0', '.6 .6 .6');
		}
		if (keySelect == 13)
		{
			Sbar_DrawString('-180 42', "If enabled, utilize particle effects for torches ", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-210 32', "and _flame light entities - otherwise use enhanced 3d variants", 1, '8 8 0', '.6 .6 .6');
			Sbar_DrawString('-110 22', "-- REQUIRES MAP RESTART --", 1, '8 8 0', '1 .1 0');
			Sbar_DrawString('-160 12', "-- Disabling can improve network performance --", 1, '8 8 0', '1 .8 0');
		}
		if (keySelect == 14)
			Sbar_DrawString('-120 42', "Restart level and apply config changes", 1, '8 8 0', '.6 .6 .6');
		if (keySelect == 15)
			Sbar_DrawString('-100 42', "Back to keybinds menu", 1, '8 8 0', '.6 .6 .6');
}

void() infoMenu3 =
{
	if (keySelect == 1)
	{
		Sbar_DrawString('-200 42', "When enabled, there's a 20% chance for a backpack with", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-200 32', "proximity grenades and ammo to spawn instead of red armor.", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-200 22', "Can also give you more than max ammo if you have enough. ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-110 12', "-- REQUIRES MAP RESTART --", 1, '8 8 0', '1 .1 0');
	}
	if (keySelect == 2)
	{
		Sbar_DrawString('-190 42', "When enabled, a small chance the chainsaw weapon will ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-150 32', "randomly drop from gibbed ogres.", 1, '8 8 0', '.6 .6 .6');

	}
	if (keySelect == 3)
	{
		Sbar_DrawString('-190 42', "When enabled, grunts with alternate glowing eye model", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-190 32', "use a nailgun instead of a shotgun and drop nails on death", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 4)
	{
		Sbar_DrawString('-180 42', "When enabled, turns the green enforcer variant into a", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-180 32', "Defender a la Quoth/AD - uses shotgun and rapid fire laser", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 5)
	{
		Sbar_DrawString('-180 42', "Gives the defender a chance to launch a proximity mine,", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-180 32', "slightly closer to his behavior in Quoth/AD mods ", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 6)
	{
		Sbar_DrawString('-180 42', "Gives Scrags the ability to teleport around,", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-190 32', " teleport chance is based on percentage specified", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-200 22', "-- TOO HIGH VALUES CAN MAKE THEM VERY IRRITATING TO FIGHT  --", 1, '8 8 0', '1 .8 0');
	}
	if (keySelect == 7)
	{
		Sbar_DrawString('-180 42', "Gives a chance for the vore to be replaced with a ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-180 32', "vore mother like AD - spawns vorelings, only attacks", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-180 22', "with voreballs if hanging from the ceiling", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 8)
	{
		Sbar_DrawString('-170 42', "When enabled, player gets set on fire by fireballs and ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-175 32', "other flame-based attacks for the specified length of time", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 9)
	{
		Sbar_DrawString('-150 42', "When enabled, there is a small chance to replace", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-150 32', "Enemies with the Yakman from Hexen II, chance ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-150 22', "based on values in q15_config.cfg", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 10)
	{
		Sbar_DrawString('-150 42', "When enabled, there is a small chance to replace", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-150 32', "ogres/hellknights with the warlord from SMC, ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-150 22', "chance based on values in q15_config.cfg", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 11)
	{
		Sbar_DrawString('-180 42', "The Thunderbolt becomes a BFG-type chain-lightning weapon", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-180 32', "that hits multiple targets, disable for legacy behavior", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-150 12', "-- Extremely Overpowered in Deathmatch --", 1, '8 8 0', '1 .8 0');
	}
	if (keySelect == 12)
	{
		Sbar_DrawString('-180 42', "Small chance to slow down time on enemy gibbed", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 13)
	{
		Sbar_DrawString('-180 42', "Enable unused Quake 3 songs during deathmatch games", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 14)
	{
		Sbar_DrawString('-190 42', "Chance to replace specified powerup with Time dilation rune", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-190 32', "(bullet time) NOTE: Replacing Biosuit or Pentagram is DM only, ", 1, '8 8 0', '.6 .6 .6');
		Sbar_DrawString('-190 22', "as there are segments in SP that rely on them for protection", 1, '8 8 0', '.6 .6 .6');
	}
	if (keySelect == 15)
		Sbar_DrawString('-120 42', "Restart level and apply config changes", 1, '8 8 0', '.6 .6 .6');
	if (keySelect == 16)
		Sbar_DrawString('-100 42', "Back to keybinds menu", 1, '8 8 0', '.6 .6 .6');
}

void() infoPanel =
{
	
	//Context-based text panel that provides details about the selected option
	if (inMenu == 1)
		infoMenu1();
	if (inMenu == 2)
		infoMenu2();
	if (inMenu == 3)
		infoMenu3();
}

void() prepKeybinds =
{
	binds[0] = findkeysforcommand("ThrowGrenade", 0);
	binds[1] = findkeysforcommand("quickkick", 0);
	binds[2] = findkeysforcommand("flashlight", 0);
	binds[3] = findkeysforcommand("chasecam", 0);
	
	binds[4] = findkeysforcommand("addbot", 0);
	binds[5] = findkeysforcommand("addbotenemy", 0);
	binds[6] = findkeysforcommand("removebot", 0);
	binds[7] = findkeysforcommand("+hook", 0);
}

void() clearKey =
{
	
	if (keySelect == 9)
		return;
		
	prepKeybinds();
		
	local string binding, keycode;
	
	if (keySelect == 1)
		binding = binds[0];
	else if (keySelect == 2)
		binding = binds[1];
	else if (keySelect == 3)
		binding = binds[2];
	else if (keySelect == 4)
		binding = binds[3];
	else if (keySelect == 5)
		binding = binds[4];
	else if (keySelect == 6)
		binding = binds[5];
	else if (keySelect == 7)
		binding = binds[6];
	else if (keySelect == 8)
		binding = binds[7];
	
	keycode = keynumtostring(stof(substring(binding, 2, 3)));
	
	if (keycode != "<KEY NOT FOUND>")
		localcmd("unbind ", keycode, "\n");
	
	sound(self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
		
		
}



void() ShowKeybinds =
{
	local string keystr[8];
	local vector col[8];
	local vector pos[8];
	local vector posoffset;

	posoffset = '0 10';
	
	//Find current bindings for commands
	prepKeybinds();

	//convert the first keycode returned into a float so it can be interpreted by keynumtostring, 
	//which then turns it into the actual key to print onscreen
	
	//populate local array with the key to print out onscreen
	for (float i = 0; i <= 7; i++)
	{
		keystr[i] = keynumtostring(stof(substring(binds[i], 2, 3)));
		pos[i] = '170 272';
	}
	
	//vector position for drawstring
	for (float j = 0; j <= 7; j++)
	{
		if (j >= 1)
			posoffset+='0 10'; //skip a line so each keybind is drawn under the last
		if (j == 4)
			posoffset+='0 30'; //Skip 30 to account for the title string
		pos[j] = pos[j] - posoffset;
	}
	
	//set up color for keybind strings and print them in the correct position
	for (float x = 0; x <= 7; x++)
	{
		if (keystr[x] == "<KEY NOT FOUND>") //system string value for no keycode
		{
			keystr[x] = "???";	//same as vanilla quake menus
			col[x] = '1 0 0';	//draw as red
		}
		else
			col[x] = '1 1 1';	//draw as white
		
		Sbar_DrawString(pos[x], keystr[x], 1, '8 8 0', col[x]); //drawstring using values above
		
	}
	
}
void() loadScreenSize =
{
	if ((cvar("vid_width")/cvar("vid_height")) != (4/3))
	{
		if (cvar("vid_conwidth") == 624)
			sliderPos = 0;
		if (cvar("vid_conwidth") == 640)
			sliderPos = 1;
		if (cvar("vid_conwidth") == 672)
			sliderPos = 2;
		if (cvar("vid_conwidth") == 688)
			sliderPos = 3;
		if (cvar("vid_conwidth") == 720)
			sliderPos = 4;
		if (cvar("vid_conwidth") == 752)
			sliderPos = 5;
		if (cvar("vid_conwidth") == 816)
			sliderPos = 6;
		if (cvar("vid_conwidth") == 1116)
			sliderPos = 7;
	}
}

void() updateScreenSize =
{

	if ((cvar("vid_width")/cvar("vid_height")) != (4/3))
	{
		if (sliderPos == 0)
		{
			wepbar_offset = 0;
			cvar_set("vid_conwidth", "624");
			cvar_set("vid_conheight", "351");
		}
		else if (sliderPos == 1)
		{
			wepbar_offset='10 5';
			cvar_set("vid_conwidth", "640");
			cvar_set("vid_conheight", "360");
		}
		else if (sliderPos == 2)
		{
			wepbar_offset='25 10';
			cvar_set("vid_conwidth", "672");
			cvar_set("vid_conheight", "378");
		}
		else if (sliderPos == 3)
		{
			wepbar_offset='35 15';
			cvar_set("vid_conwidth", "688");
			cvar_set("vid_conheight", "387");
		}
		else if (sliderPos == 4)
		{
			wepbar_offset='50 20';
			cvar_set("vid_conwidth", "720");
			cvar_set("vid_conheight", "405");
		}
		else if (sliderPos == 5)
		{
			wepbar_offset='65 25';
			cvar_set("vid_conwidth", "752");
			cvar_set("vid_conheight", "423");
		}
		else if (sliderPos == 6)
		{
			/*wepbar_offset='80 30';
			cvar_set("vid_conwidth", "784");
			cvar_set("vid_conheight", "441");*/
			wepbar_offset='95 35';
			cvar_set("vid_conwidth", "816");
			cvar_set("vid_conheight", "459");
			
		}
		else if (sliderPos == 7)
		{
			wepbar_offset='245 85';
			cvar_set("vid_conwidth", "1116");
			cvar_set("vid_conheight", "630");
		}
	}
	else
	{
		if (sliderPos == 0)
		{
			wepbar_offset = '0 90';
			cvar_set("vid_conwidth", "632");
			cvar_set("vid_conheight", "471");
		}
		else if (sliderPos == 1)
		{
			wepbar_offset='10 115';
			cvar_set("vid_conwidth", "640");
			cvar_set("vid_conheight", "480");
		}
		else if (sliderPos == 2)
		{
			wepbar_offset='25 130';
			cvar_set("vid_conwidth", "672");
			cvar_set("vid_conheight", "504");
		}
		else if (sliderPos == 3)
		{
			wepbar_offset='35 145';
			cvar_set("vid_conwidth", "688");
			cvar_set("vid_conheight", "516");
		}
		else if (sliderPos == 4)
		{
			wepbar_offset='50 160';
			cvar_set("vid_conwidth", "720");
			cvar_set("vid_conheight", "540");
		}
		else if (sliderPos == 5)
		{
			wepbar_offset='65 185';
			cvar_set("vid_conwidth", "752");
			cvar_set("vid_conheight", "564");
		}
		else if (sliderPos == 6)
		{
			wepbar_offset='80 200';
			cvar_set("vid_conwidth", "784");
			cvar_set("vid_conheight", "588");
		}
		else if (sliderPos == 7)
		{
			wepbar_offset='95 225';
			cvar_set("vid_conwidth", "816");
			cvar_set("vid_conheight", "612");
		}
	}	
	
}

void() ShowSlider =
{
	vector pos[8];
	local vector offsetMod;
	//vector sliderOffset[8];
	
	for (float i = 0; i <= 7; i++)
		pos[i] = '150 148';
		
	
	for (float j = 0; j <= 7; j++)
	{
		if (j == 0)
			offsetMod = '5 0';
		else
			offsetMod+= '5 0';
		
		pos[j] = pos[j] + offsetMod;
	}
	
	
	Sbar_DrawCharacter(pos[sliderPos], 131, 1);
	updateScreenSize();
	
}

void() DrawSliderSlot =
{
	
	Sbar_DrawCharacter('150 148', 128, 1);//start slider char
		
	Sbar_DrawCharacter('155 148', 129, 1);
	Sbar_DrawCharacter('160 148', 129, 1);
	Sbar_DrawCharacter('165 148', 129, 1);
	Sbar_DrawCharacter('170 148', 129, 1);
	Sbar_DrawCharacter('175 148', 129, 1);
	Sbar_DrawCharacter('180 148', 129, 1);
	Sbar_DrawCharacter('185 148', 129, 1);
	Sbar_DrawCharacter('190 148', 129, 1);
	
	Sbar_DrawCharacter('195 148', 130, 1);//end slider char
}

 float GSPEED_SAV;

void() TogglePause =
{
	if (cvar("slowmo") > 0)
		GSPEED_SAV = cvar("slowmo");
				
	if (canPause)
	{

		if (inMenu)
		{
			if (cvar("slowmo") > 0)
				cvar_set("slowmo", "0");
		}
		else
		cvar_set("slowmo", ftos(GSPEED_SAV));
		
	}
	else
		cvar_set("slowmo", ftos(GSPEED_SAV));
}

void() bindingsMenu =
{
	//SP Binds
	ShowKeybinds();
	Sbar_DrawString('-70 282', "Singleplayer Keybinds", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-70 280', "_____________________", 1, '8 8 0', '.7 1 .1');
	
	Sbar_DrawString('-60 262', "Throw Grenade", 1, '8 8 0', '1 .6 .3');
	
	Sbar_DrawString('-60 252', "Melee Kick", 1, '8 8 0', '1 .6 .3');
	
	Sbar_DrawString('-60 242', "Flashlight", 1, '8 8 0', '1 .6 .3');
	
	Sbar_DrawString('-60 232', "Chasecam", 1, '8 8 0', '1 .6 .3');
	
	
	//MP binds
	Sbar_DrawString('-70 212', "Multiplayer Keybinds", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-70 210', "____________________", 1, '8 8 0', '.7 1 .1');
	
	Sbar_DrawString('-60 192', "Add Bot", 1, '8 8 0', '1 .6 .3');
	//Sbar_DrawString('150 202', "Default: F1", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 182', "Add Enemy Bot (teamplay)", 1, '8 8 0', '1 .6 .3');
	//Sbar_DrawString('150 192', "Default: F2", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 172', "Remove Bot", 1, '8 8 0', '1 .6 .3');
	//Sbar_DrawString('150 182', "Default: F3", 1, '8 8 0', '1 0 0');
	Sbar_DrawString('-60 162', "Hook", 1, '8 8 0', '1 .6 .3');
	
	Sbar_DrawString('-60 148', "UI Scale:", 1, '8 8 0', '1 .6 .3');
	
	DrawSliderSlot();
	//Sbar_DrawCharacter('85 152', 131, 1);//slider pos char
	
	ShowSlider();
	
	//Sbar_DrawCharacter('15 152', 14, 1);
	//Sbar_DrawCharacter('18 152', 15, 1);
	//Sbar_DrawCharacter('21 152', 16, 1);
	
	//Next Page
	Sbar_DrawString('-60 132', "General Options", 1, '8 8 0', '1 1 1');
	
	//Other menu
	Sbar_DrawString('-60 122', "Game Tweaks", 1, '8 8 0', '1 1 1');
	/*Sbar_DrawString('-60 152', "Effects", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-60 150', "_______", 1, '8 8 0', '.7 1 .1');
	
	Sbar_DrawString('-60 132', "Quality:", 1, '8 8 0', '.5 1 .1');*/
	
	menuItemSelector();
}

void() gameplayMenu =
{
//Gameplay options
	Sbar_DrawString('-70 282', "General Options", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-70 280', "_______________", 1, '8 8 0', '.7 1 .1');
	
	//Overall Quality
	Sbar_DrawString('-60 262', "Quality:", 1, '8 8 0', '1 .6 .3');
	if (cvar("lowspec") == 0)
		Sbar_DrawString('120 262', "High", 1, '8 8 0', '0 1 0');
	else if (cvar("lowspec") == 1)
		Sbar_DrawString('120 262', "Low", 1, '8 8 0', '1 0 0');
	
	//Decals
	Sbar_DrawString('-60 252', "Max Active Decals:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("cl_decals_max") > 4400)
		Sbar_DrawString('120 252', "Max", 1, '8 8 0', '0 1 0');
	else if (cvar("cl_decals_max") >= 2800)
		Sbar_DrawString('120 252', "Medium", 1, '8 8 0', '1 .8 0');
	else if (cvar("cl_decals_max") < 2800)
		Sbar_DrawString('120 252', "Min", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 242', "Decal Time:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("cl_decals_time") > 4100)
		Sbar_DrawString('120 242', "Max", 1, '8 8 0', '0 1 0');
	else if (cvar("cl_decals_time") >= 700)
		Sbar_DrawString('120 242', "Medium", 1, '8 8 0', '1 .8 0');
	else if (cvar("cl_decals_time") < 300)
		Sbar_DrawString('120 242', "Min", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-70 222', "Server Options", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-70 220', "______________", 1, '8 8 0', '.7 1 .1');
	
	//Coop
	Sbar_DrawString('-60 202', "Coop - Lives System:", 1, '8 8 0', '1 .6 .3');
	if (cvar("coop_life_pool") == 0)
		Sbar_DrawString('120 202', "Disabled", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 202', "Enabled", 1, '8 8 0', '0 1 0');
	
	Sbar_DrawString('-60 192', "Coop - Life Count:", 1, '8 8 0', '1 .6 .3');
	Sbar_DrawString('120 192', ftos(cvar("coop_lives")), 1, '8 8 0', '1 0 0');
	
	//Clone Monsters
	Sbar_DrawString('-60 182', "Clone Monsters:", 1, '8 8 0', '1 .6 .3');
	
	
	if (cvar("clonemonsters") == 0)
		Sbar_DrawString('120 182', "Disabled", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 182', ftos(cvar("clonemonsters")), 1, '8 8 0', '1 0 0');
	
	
	//Gibs Duration
	Sbar_DrawString('-60 172', "Gib Duration:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("gibsduration") == 0)
		Sbar_DrawString('120 172', "Forever", 1, '8 8 0', '0 1 0');
	else if (cvar("gibsduration") == 1)
		Sbar_DrawString('120 172', strcat(ftos(cvar("gibsduration"))," Second"), 1, '8 8 0', '1 0 0');
	else if (cvar("gibsduration") == 10)
		Sbar_DrawString('120 172', strcat(ftos(cvar("gibsduration"))," Seconds (Q1 Default)"), 1, '7 7 0', '1 .5 0');
	else if (cvar("gibsduration") < 15)
		Sbar_DrawString('120 172', strcat(ftos(cvar("gibsduration"))," Seconds"), 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 172', strcat(ftos(cvar("gibsduration"))," Seconds"), 1, '8 8 0', '1 .9 0');
	
	//Chainsaw DM
	Sbar_DrawString('-60 162', "Autosaving (SP):", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("auto_save") == 0)
		Sbar_DrawString('120 162', "Disabled", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 162', "Enabled", 1, '8 8 0', '0 1 0');
		
	//HUD
	Sbar_DrawString('-70 148', "HUD/Misc Options", 1, '7 7 0', '.7 1 .1');
	Sbar_DrawString('-70 146', "________________", 1, '7 7 0', '.7 1 .1');
	
	//Grenade indicator
	Sbar_DrawString('-60 132', "Grenade icon size:", 1, '8 8 0', '1 .6 .3');
	
	if (!cvar("hud_proxcount_big"))
		Sbar_DrawString('120 132', "Tiny", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 132', "Large", 1, '8 8 0', '0 1 0');
	
	//HUD Title
	Sbar_DrawString('-60 122', "Show Level Name:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("hud_showtitle") == 0)
		Sbar_DrawString('120 122', "No", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 122', "Yes", 1, '8 8 0', '0 1 0');
		
	//Colored ammo bar
	Sbar_DrawString('-60 112', "Alternate SSG:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("qc_ssg") == 0)
		Sbar_DrawString('120 112', "No", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 112', "Yes", 1, '8 8 0', '0 1 0');
		
	//Centered weapons
	Sbar_DrawString('-60 102', "Centered Weapons:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("centered_weapons") == 0)
		Sbar_DrawString('120 102', "No", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 102', "Yes", 1, '8 8 0', '0 1 0');
		
	Sbar_DrawString('-60 92', "Particle Flames:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("flamestyle") != 2)
		Sbar_DrawString('120 92', "No", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('120 92', "Yes", 1, '8 8 0', '0 1 0');
	

	
	Sbar_DrawString('-60 72', "Restart Map", 1, '8 8 0', '1 1 1');
	
	//Back a Page
	Sbar_DrawString('-60 62', "Keybinds Menu", 1, '8 8 0', '1 1 1');
	
	menuItemSelector();
}

void() MonMenu =
{
	local string tele, burner;
	local vector percolor, percolor2;
	
	tele = ftos(cvar("wizardteleport"));
	burner = ftos(cvar("fire_projectiles_and_lava_inflame_time"));
	
	if (cvar("wizardteleport") > 50)
		percolor = '0 1 0';
	else if (cvar("wizardteleport") > 10)
		percolor = '1 .8 0';
	else
		percolor = '1 0 0';
		
	if (cvar("fire_projectiles_and_lava_inflame_time") > 50)
		percolor2 = '0 1 0';
	else if (cvar("fire_projectiles_and_lava_inflame_time") > 10)
		percolor2 = '1 .8 0';
	else
		percolor2 = '1 0 0';
	
	//Gameplay options
	Sbar_DrawString('-70 282', "Item/Monster Options", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-70 280', "____________________", 1, '8 8 0', '.7 1 .1');
	
	//Item Spawn options
	
	//Ammo
	Sbar_DrawString('-60 262', "Ammo pack spawns:", 1, '8 8 0', '1 .6 .3');
	if (cvar("redarmor_backpack") == 1)
		Sbar_DrawString('140 262', "On", 1, '8 8 0', '0 1 0');
	else if (cvar("redarmor_backpack") == 0)
		Sbar_DrawString('140 262', "Off", 1, '8 8 0', '1 0 0');
	
	//Chainsaw
	Sbar_DrawString('-60 252', "Chainsaw Drops:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("chainsaw_drops") == 1)
		Sbar_DrawString('140 252', "On", 1, '8 8 0', '0 1 0');
	else if (cvar("chainsaw_drops") == 0)
		Sbar_DrawString('140 252', "Off", 1, '8 8 0', '1 0 0');
	
	//Monsters	
	Sbar_DrawString('-60 242', "Nail Grunts:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("soldier_nailgrunt") == 1)
		Sbar_DrawString('140 242', "On", 1, '8 8 0', '0 1 0');
	else if (cvar("soldier_nailgrunt") == 0)
		Sbar_DrawString('140 242', "Off", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 232', "Defenders:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("enforcer_defender") == 1)
		Sbar_DrawString('140 232', "On", 1, '8 8 0', '0 1 0');
	else if (cvar("enforcer_defender") == 0)
		Sbar_DrawString('140 232', "Off", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 222', "Defender Prox Grenades:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("enforcer_defender_prox") == 1)
		Sbar_DrawString('140 222', "On", 1, '8 8 0', '0 1 0');
	else if (cvar("enforcer_defender_prox") == 0)
		Sbar_DrawString('140 222', "Off", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 212', "Scrag Teleport Chance:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("wizardteleport") >= 1)
		Sbar_DrawString('140 212', strcat(tele, "%"), 1, '8 8 0', percolor);
	else if (cvar("wizardteleport") == 0)
		Sbar_DrawString('140 212', "Off", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 202', "Shalrath Mother:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("shalrath_mother") == 1)
		Sbar_DrawString('140 202', "On", 1, '8 8 0', '0 1 0');
	else if (cvar("shalrath_mother") == 0)
		Sbar_DrawString('140 202', "Off", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 192', "Player Burn Time:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("fire_projectiles_and_lava_inflame_time") > 1)
		Sbar_DrawString('140 192', strcat(burner, " Seconds"), 1, '8 8 0', percolor2);
	else if(cvar("fire_projectiles_and_lava_inflame_time") == 1)
		Sbar_DrawString('140 192', strcat(burner, " Second"), 1, '8 8 0', percolor2);
	else if (cvar("fire_projectiles_and_lava_inflame_time") == 0)
		Sbar_DrawString('140 192', "Off", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 182', "Yakman Replacer:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("yakman_replace_shambler") > 0)//(cvar("yakman_replace_knight") > 0 || cvar("yakman_replace_hellknight") > 0 || cvar("yakman_replace_ogre") > 0 || cvar("yakman_replace_shambler") > 0 || cvar("yakman_replace_shalrath") > 0)
		Sbar_DrawString('140 182', "On", 1, '8 8 0', '0 1 0');
	else 
		Sbar_DrawString('140 182', "Off", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 172', "Warlord Replacer:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("warlord_replace_hknight") > 0)
		Sbar_DrawString('140 172', "On", 1, '8 8 0', '0 1 0');
	else 
		Sbar_DrawString('140 172', "Off", 1, '8 8 0', '1 0 0');
		
	//Chain Thunderbolt
	Sbar_DrawString('-60 162', "Chain Thunderbolt:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("weapon_chain_thunderbolt") == 0)
		Sbar_DrawString('140 162', "Disabled", 1, '8 8 0', '1 0 0');
	else
		Sbar_DrawString('140 162', "Enabled", 1, '8 8 0', '0 1 0');
		
	Sbar_DrawString('-60 152', "Slowmo Kills:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("slowmotion") == 1)
		Sbar_DrawString('140 152', "Enabled", 1, '8 8 0', '0 1 0');
	else 
		Sbar_DrawString('140 152', "Disabled", 1, '8 8 0', '1 0 0');
	
	//Deathmatch Music
	
	Sbar_DrawString('-60 142', "Deathmatch Music:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("deathmatch_music") == 1)
		Sbar_DrawString('140 142', "Enabled", 1, '8 8 0', '0 1 0');
	else 
		Sbar_DrawString('140 142', "Disabled", 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 132', "Slowmo Powerup Replaces:", 1, '8 8 0', '1 .6 .3');
	
	if (cvar("slowmo_powerup") == 1)
		Sbar_DrawString('140 132', "Ring of Shadows (recommended)", 1, '6 6 0', '1 .6 0');
	else if (cvar("slowmo_powerup") == 2)
		Sbar_DrawString('140 132', "Quad Damage", 1, '8 8 0', '0 1 0');
	else if (cvar("slowmo_powerup") == 3)
		Sbar_DrawString('140 132', "Biosuit (DM Only)", 1, '8 8 0', '0 1 0');
	else if (cvar("slowmo_powerup") == 4)
		Sbar_DrawString('140 132', "Pentagram (DM Only)", 1, '8 8 0', '0 1 0');
	else 
		Sbar_DrawString('140 132', "Disabled", 1, '8 8 0', '1 0 0');
	
	//Restart the level
	Sbar_DrawString('-60 72', "Restart Map", 1, '8 8 0', '1 1 1');
	
	//Back a Page
	Sbar_DrawString('-60 62', "Keybinds Menu", 1, '8 8 0', '1 1 1');
	
	menuItemSelector();
}

void() MPMenu =
{
	
	//maxplay = ftos(cvar("maxplayers"));
	teamplay = cvar("teamplay");
	
	SkillCheck();
	
	
	if (cvar("deathmatch") && cvar("ctf") == 0)
	{
		if(cvar("teamplay") > 0)
			gametype = "Team Deathmatch";
		else
			gametype = "Deathmatch";
	}
	else if (cvar("ctf") == 1)
		gametype = "Capture the Flag";
	else if (cvar("coop") == 1 && cvar("deathmatch") == 0)
		gametype = "Cooperative";
	else
		gametype = "Single Player";
	//Sbar_DrawString('-10 262', keybind1, 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 282', "Game Setup", 1, '8 8 0', '.7 1 .1');
	Sbar_DrawString('-60 280', "__________", 1, '8 8 0', '.7 1 .1');
	
	Sbar_DrawString('-60 262', "Max Players:", 1, '8 8 0', '1 .6 .3');
	Sbar_DrawString('110 262', ftos(maxplayers), 1, '8 8 0', '1 .6 .4');
	
	Sbar_DrawString('-60 252', "Gametype:", 1, '8 8 0', '1 .6 .3');
	
	Sbar_DrawString('110 252', gametype, 1, '8 8 0', '1 1 1');
	
	Sbar_DrawString('-60 242', "Weapons Stay:", 1, '8 8 0', '1 .6 .3');
	
	if (!isSingle() && !isCoop())
	{
		if (!weaponstay)
			Sbar_DrawString('110 242', "Off", 1, '8 8 0', '1 0 0');
		else
			Sbar_DrawString('110 242', "On", 1, '8 8 0', '0 1 0');
	}
	else
		Sbar_DrawString('110 242', "N/A", 1, '8 8 0', '1 0 0');
	
	if (gametype != "Capture the Flag")	
		Sbar_DrawString('-60 232', "Fraglimit:", 1, '8 8 0', '1 .6 .3');
	else
		Sbar_DrawString('-60 232', "Capture limit:", 1, '8 8 0', '1 .6 .3');
	
	if (!isSingle() && !isCoop())	
		Sbar_DrawString('110 232', ftos(scorelimit), 1, '8 8 0', '1 1 1');
	else
		Sbar_DrawString('110 232', "N/A", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 222', "Timelimit:", 1, '8 8 0', '1 .6 .3');
	
	if (!isSingle() && !isCoop())	
		Sbar_DrawString('110 222', ftos(timelimit), 1, '8 8 0', '1 1 1');
	else
		Sbar_DrawString('110 222', "N/A", 1, '8 8 0', '1 0 0');
	//Sbar_DrawString('150 202', "Default: F1", 1, '8 8 0', '1 0 0');
	
	Sbar_DrawString('-60 212', "Teamplay mode:", 1, '8 8 0', '1 .6 .3');
	if (!isSingle())	
	{
		if (teamplay == 1)
			Sbar_DrawString('110 212', "No Friendly Fire", 1, '8 8 0', '1 1 1');
		else if (teamplay == 2)
			Sbar_DrawString('110 212', "Friendly Fire", 1, '8 8 0', '1 1 1');
		else
			Sbar_DrawString('110 212', "No Teams", 1, '8 8 0', '.8 .8 .8');
	}
	else
			Sbar_DrawString('110 212', "N/A", 1, '8 8 0', '1 0 0');
	//Sbar_DrawString('150 192', "Default: F2", 1, '8 8 0', '1 0 0');
	
	if (isCTF() || isDeathmatch())
		Sbar_DrawString('-60 202', "Balance Teams:", 1, '8 8 0', '1 .6 .3');
	else
		Sbar_DrawString('-60 202', "Lives mode:", 1, '8 8 0', '1 .6 .3');
		
	if (isCTF())
	{
		if (autobalance())
			Sbar_DrawString('110 202', "On", 1, '8 8 0', '0 1 0');
		else
			Sbar_DrawString('110 202', "Off", 1, '8 8 0', '1 0 0');
	}
	else if (isDeathmatch() || isSingle())
		Sbar_DrawString('110 202', "N/A", 1, '8 8 0', '1 0 0');
	else if (cvar("coop_life_pool"))
		Sbar_DrawString('110 202', "On", 1, '8 8 0', '0 1 0');
	else
		Sbar_DrawString('110 202', "Off", 1, '8 8 0', '1 0 0');
	
	if (isCTF() || isDeathmatch())
		Sbar_DrawString('-60 192', "Bot Skill:", 1, '8 8 0', '1 .6 .3');
	else
		Sbar_DrawString('-60 192', "Difficulty:", 1, '8 8 0', '1 .6 .3');
	
	if (whatskill == 3)
		Sbar_DrawString('110 192' , skill[whatskill], 1, '8 8 0', '1 0 0');
	else if (whatskill == 0)
		Sbar_DrawString('110 192' , skill[whatskill], 1, '8 8 0', '0 1 .5');
	else
		Sbar_DrawString('110 192' , skill[whatskill], 1, '8 8 0', '1 .6 0');
	if (!isSingle() && !isCoop())	
		Sbar_DrawString('-60 182', "Bots:", 1, '8 8 0', '1 .6 .3');
	else
		Sbar_DrawString('-60 182', "Ammo Boxes:", 1, '8 8 0', '1 .6 .3');
		
	if (!isSingle() && !isCoop())
		Sbar_DrawString('110 182', ftos(botcount), 1, '8 8 0', '1 1 1');
	else
		Sbar_DrawString('110 182', ammocap, 1, '8 8 0', '1 0 0');
		
	Sbar_DrawString('-60 172', "Grapple:", 1, '8 8 0', '1 .6 .3');
	
	if (!isSingle() && !isCoop())
	{
		if (checkHook() == SWING)
			Sbar_DrawString('110 172' , "Swinging Hook", 1, '8 8 0', '0 1 0');
		else if (checkHook() == REEL)
			Sbar_DrawString('110 172' , "Classic Hook", 1, '8 8 0', '1 1 0');
		else
			Sbar_DrawString('110 172' , "OFF", 1, '8 8 0', '1 0 0');
	}
	else
		Sbar_DrawString('110 172' , "N/A", 1, '8 8 0', '1 0 0');
	
	
	//Back to level choice
	Sbar_DrawString('-60 132', "Level Select", 1, '8 8 0', '1 1 1');
	
	menuItemSelector();
}

void() menuSetup =
{
	cvar_set("sensitivity", "0");	
	drawfill('-70 -70','2000 2000', '0 0 0', .7, 0);
	if (inMenu == 1 || inMenu == 5)
		Sbar_DrawPic('-100 330', "gfx/ttl_cstm", 1, 1);
	else if (inMenu > 0 && inMenu < 4)
		Sbar_DrawPic('-80 330', "gfx/p_option", 1, 1);
	
	Sbar_DrawPic('-160 270', "gfx/qplaque", 1, 1);
	infoPanel();
		
}

void() showKeybindOverlay =
{
	drawfill('-70 -70','2000 2000', '0 0 0', .6, 0);
	if (keySelect == 1)
		Sbar_DrawString('-150 222', "Set custom keybind for Throw Grenade", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 2)
		Sbar_DrawString('-150 222', "Set custom keybind for Melee Kick", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 3)
		Sbar_DrawString('-150 222', "Set custom keybind for Flashlight", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 4)
		Sbar_DrawString('-150 222', "Set custom keybind for Chasecam", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 5)
		Sbar_DrawString('-150 222', "Set custom keybind for Add Bot", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 6)
		Sbar_DrawString('-150 222', "Set custom keybind for Add Enemy Bot", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 7)
		Sbar_DrawString('-150 222', "Set custom keybind for Remove Bot", 1, '8 8 0', '1 .7 0');
	else if (keySelect == 8)
		Sbar_DrawString('-150 222', "Set custom keybind for offhand grappling hook", 1, '8 8 0', '1 .7 0');
}

void() disableMouse =
{
	cvar_set("sensitivity", ftos(mouse));
}

void() ShowMenu = 
{
	
	//Menu background color and title
	if (inMenu)
		menuSetup();
	else //restore player mouse sensitivity in gameplay
		disableMouse();
	//keybinds/UI menu - set keybinds and go to other menu pages
	if (inMenu == 1)
		bindingsMenu();
	//overlay to inform player what keybind they are changing
	if (bindMode == 1)
		showKeybindOverlay();
	//gameplay and server options menu
	if (inMenu == 2)
		gameplayMenu();
	//monster and item menu	
	if (inMenu == 3)
		MonMenu();
	//custom MP menu for starting games	
	if (inMenu == 5)
		MPMenu();
	
	
	
	
}

