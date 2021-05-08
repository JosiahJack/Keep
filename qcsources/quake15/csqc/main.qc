/*float n;
string text;
local float h = floor(n / 3600), m = floor(n / 60) - h * 60, s = floor(n) - h * 3600 - m * 60;text = sprintf("%02f:%02f:%02f", h, m, s); */
float addlives;
float clonemonsters;
float wiztele;
float burnchance;
float gibtime;
float arrowPos;
float keytimer;
string ammocap;


void() CSQC_Init =
{	//note: the three arguments are engine-defined, and can be used to to detect if the engine version you're running in has bugs. Just call error("please update your engine") if it's got known fatal bugs, but try not to exclude engines you've not tested against (ie: forks where your code will otherwise work fine).
	//foo = spawn();//local entity foo = spawn();
	//precache_model("progs/player.mdl");	//or something else
	//setmodel(foo, "progs/player.mdl");	//same as ssqc, see, its easy!
	//setorigin(foo, '544 496 40');		//you'll need to fix the origin to ensure you don't put it in a wall...
	//foo.drawmask = MASK_ENGINE;		//cause the entity to be added to the scene automatically via the addentities(MASK_ENGINE) builtin.
	//foo.think = soundPlayer;
	//foo.nextthink = time + 0.1;
	
	mouse = cvar("sensitivity");
	if (!mouse)	cvar_set("sensitivity", "3");
	registercvar("hud_proxcount_big", "1");
	registercvar("hud_colored_ammo", "1");
	addlives = stof("coop_lives");
	clonemonsters = stof("clonemonsters");
	registercvar("hud_showtitle", "1");
	cvar_set("weapon_chain_thunderbolt", ftos(cvar("savedgamecfg")));
	
	
	init_servercmds();
	
	stGtype = gametype;
	
	
	create_maplist();
	
	//Menu Sounds
	precache_sound("misc/menu1.wav");
	precache_sound("misc/menu2.wav");
	precache_sound("misc/menu3.wav");
	
	//Client Side Entity precaching
	precache_model("progs/casing.mdl");
	precache_model("progs/nailcasing.mdl");
	precache_model("progs/missilecasing.mdl");
	precache_model("progs/s_smoke_muzz.spr");
	
	precache_sound ("weapons/casings1.wav");
	precache_sound ("weapons/casings2.wav");
	precache_sound ("weapons/casings3.wav");
	
	precache_sound ("weapons/nailcase1.wav");
	precache_sound ("weapons/nailcase2.wav");
	precache_sound ("weapons/nailcase3.wav");
	
	precache_sound ("weapons/rockcase1.wav");
	precache_sound ("weapons/rockcase.wav");
	
	loadCFG();
	
	mp_temp = maxplayers;
	
	if (!maxplayers)
		maxplayers = 8; 	//default
	if (isSingle())
		maxplayers = 1;
		
	if (cvar("shells_small") > 20)
		ammocap = "Double";
	else
		ammocap = "Normal";
	
	canPause = isLocal();
	
	mp_change = maxplayers;
	
	
	check_gamemode();
	
	loadScreenSize();
	updateScreenSize();
	
	
};


void CSQC_Shutdown( void ) {
    cvar_set("sensitivity", ftos(mouse));
    maxplayers = mp_temp;
    saveCFG();
}



void CSQC_UpdateView( float w, float h) {
	
	initConvars();
	clearscene();
	// Manipulate view, add entities below
	fixIntermission();

	setproperty( VF_DRAWWORLD, TRUE );
	if (!inMenu)
	{
		setproperty( VF_DRAWCROSSHAIR, TRUE );
		setproperty( VF_DRAWENGINESBAR, TRUE );
	}
	
	addentities( MASK_ENGINE );
	
	    
	renderscene();

	// Any 2D elements will be below
	
	if ((!intermission && !finale && showHUD > 0 && !inMenu) || UIDraw == 1)
	{
		
		fade_camera();
		DrawHUD();
		displayIntro();
		DrawLevelName('.9 .1 0');
		spawnBots();
		
		
		
	}
	
	
	DrawScoreboard();
	ShowMenu();
	ShowMapList();
	TogglePause();
	
	
	    
}

void CSQC_Ent_Update (float isnew)
{   
   self.enttype = ReadByte();
   float flags;
  // print(ftos(self.enttype), "\n");
   
   if (self.enttype == ENT_PARTICLE_EMITTER)
   {
      flags = ReadByte();
      if (flags & 1)
      {
	      //print("recieved emitter...\n");
	      Particle_Emitter( isnew );
      }
   }
   else if (self.enttype == ENT_SPRITE_EMITTER)
   {
      flags = ReadByte();
      if (flags & 1)
	      Sprite_Spawner( isnew );
   }
   else if (self.enttype == ENT_CASING)
   {
	flags = ReadByte();
	if (flags & 1)
	   Casing_Spawner(isnew);
   }
   else
	print("ERR: Unhandled CSQC entity\n");
}

void() CSQC_Ent_Remove =
{
	if (self.classname != "sprite")
		remove(self);
};

float CSQC_ConsoleCommand( string strCommand ) {
    return FALSE;
}

float CSQC_InputEvent( float flEventType, float flKey, float flCharacter )
{
	
	//Input handler for custom binds menu
	if (inMenu == 1)
		if (flKey == K_DEL)
			if (flEventType == INPUT_KEYDOWN && !bindMode)
				clearKey();
			
	//Is menu in key binding mode?
	if (bindMode == 1)
	{
		if (keySelect == 1)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "ThrowGrenade", 0);
				}
			}
		}
		else if (keySelect == 2)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "quickkick", 0);
				}
			}
		}
		else if (keySelect == 3)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "flashlight", 0);
				}
			}
		}
		else if (keySelect == 4)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "chasecam", 0);
				}
			}
		}
		else if (keySelect == 5)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "addbot", 0);
					keybound5 = flKey;
				}
			}
		}
		else if (keySelect == 6)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "addbotenemy", 0);
					keybound6 = flKey;
				}
			}
		}
		else if (keySelect == 7)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "removebot", 0);
					keybound7 = flKey;
				}
			}
		}
		else if (keySelect == 8)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				bindMode = 0;
				if (getkeybind(flKey) != "togglekeybinds" && flKey != K_ESCAPE && flKey != K_BACKSPACE)
				{
					clearKey();
					setkeybind_bindmap(flKey, "+hook", 0);
					keybound8 = flKey;
				}
			}
		}
		
	}
	if (inMenu == 2)
	{
		if (flKey == K_ENTER)
		{
			if (flEventType == INPUT_KEYDOWN && keySelect != 15 && keySelect != 16)
				sound(self, CHAN_AUTO, "misc/menu3.wav", 1, ATTN_NONE);
			if (keySelect == 1)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("lowspec") == 0)
					{
						localcmd("exec q15_config_coop.cfg\n");
						cvar_set("cl_decals_max", "2500");
						cvar_set("cl_decals_time", "240");
						cvar_set("lowspec", "1");
					}
					else if (cvar("lowspec") == 1)
					{
						localcmd("exec q15_config.cfg\n");
						cvar_set("cl_decals_max", "4500");
						cvar_set("cl_decals_time", "4170");
						cvar_set("lowspec", "0");
					}
				}
			}
			else if (keySelect == 2)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("cl_decals_max") > 4400)
						cvar_set("cl_decals_max", "1500");
					else if (cvar("cl_decals_max") == 1500)
						cvar_set("cl_decals_max", "2800");
					else
						cvar_set("cl_decals_max", "4500");
				}
			}
			else if (keySelect == 3)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("cl_decals_time") > 4100)
						cvar_set("cl_decals_time", "200");
					else if (cvar("cl_decals_time") <= 200)
						cvar_set("cl_decals_time", "900");
					else
						cvar_set("cl_decals_time", "4500");
				
				}
			}
			else if (keySelect == 4)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("coop_life_pool") == 0)
						cvar_set("coop_life_pool", "1");
					else
						cvar_set("coop_life_pool", "0");
				}
			}
			else if (keySelect == 5)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					/*
					if (cvar("coop_lives") == 3)
						cvar_set("coop_lives", "5");
					else if (cvar("coop_lives") == 5)
						cvar_set("coop_lives", "10");
					else if (cvar("coop_lives") == 10)
						cvar_set("coop_lives", "1");
					else if (cvar("coop_lives") == 1)
						cvar_set("coop_lives", "3");*/
					if (cvar("coop_lives") < 50)
					{
						addlives++;
						cvar_set("coop_lives", ftos(addlives));
					}
					else if (cvar("coop_lives") >= 50)
					{
						addlives = 1;
						cvar_set("coop_lives", ftos(addlives));
					}
				}
			}
			else if (keySelect == 6)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("clonemonsters") < 10)
					{
						clonemonsters++;
						cvar_set("clonemonsters", ftos(clonemonsters));
					}
					else
					{
						clonemonsters = 0;
						cvar_set("clonemonsters", ftos(clonemonsters));
					}
				}
			}
			else if (keySelect == 7)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("gibsduration") > 99)
					{
						gibtime = 0;
						cvar_set("gibsduration", ftos(gibtime));
					}
					else
					{
						gibtime++;
						cvar_set("gibsduration", ftos(gibtime));
					}
					
				}
			}
			else if (keySelect == 8)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("auto_save") == 1)
						cvar_set("auto_save", "0");
					else
						cvar_set("auto_save", "1");
				}
			}
			else if (keySelect == 9)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("hud_proxcount_big") == 1)
						cvar_set("hud_proxcount_big", "0");
					else
						cvar_set("hud_proxcount_big", "1");
				}
			}
			else if (keySelect == 10)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("hud_showtitle") == 1)
						cvar_set("hud_showtitle", "0");
					else
						cvar_set("hud_showtitle", "1");
				}
			}
			else if (keySelect == 11)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("qc_ssg") == 1)
						cvar_set("qc_ssg", "0");
					else
						cvar_set("qc_ssg", "1");
				}
			}
			else if (keySelect == 12)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("centered_weapons") == 1)
						cvar_set("centered_weapons", "0");
					else
						cvar_set("centered_weapons", "1");
				}
			}
			else if (keySelect == 13)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("flamestyle") == 2)
						cvar_set("flamestyle", "0");
					else
						cvar_set("flamestyle", "2");
				}
			}
			else if (keySelect == 14)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					localcmd("restart\n");
				}
			}
			
			if (keySelect == 15)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					sound(self, CHAN_ITEM, "misc/menu2.wav", 1, ATTN_NONE);
					if (inMenu == 2)
						inMenu = 1;
					keySelect = 9;
					return TRUE;
				}
					
			}
			
		}
		
	}
	if (inMenu == 3)
	{
		if (flKey == K_ENTER)
		{
			if (flEventType == INPUT_KEYDOWN && keySelect != 15)
				sound(self, CHAN_AUTO, "misc/menu3.wav", 1, ATTN_NONE);
			if (keySelect == 1)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("redarmor_backpack") == 0)
						cvar_set("redarmor_backpack", "1");
					else 
						cvar_set("redarmor_backpack", "0");
				}
			}
			else if (keySelect == 2)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("chainsaw_drops") == 0)
						cvar_set("chainsaw_drops", "1");
					else
						cvar_set("chainsaw_drops", "0");
				}
			}
			else if (keySelect == 3)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("soldier_nailgrunt") == 0)
						cvar_set("soldier_nailgrunt", "1");
					else
						cvar_set("soldier_nailgrunt", "0");
				
				}
			}
			else if (keySelect == 4)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("enforcer_defender") == 0)
						cvar_set("enforcer_defender", "1");
					else
						cvar_set("enforcer_defender", "0");
				}
			}
			else if (keySelect == 5)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("enforcer_defender_prox") == 0)
						cvar_set("enforcer_defender_prox", "1");
					else
						cvar_set("enforcer_defender_prox", "0");
				}
			}
			else if (keySelect == 6)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("wizardteleport") < 100)
					{
						
						wiztele++;
						cvar_set("wizardteleport", ftos(wiztele));
					}
					else
					{
						wiztele = 0;
						cvar_set("wizardteleport", ftos(wiztele));
					}
				}
			}
			else if (keySelect == 7)
			{
				//Save this value on game exit using savedgamecfg cvar
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("shalrath_mother") == 1)
						cvar_set("shalrath_mother", "0");
					else
						cvar_set("shalrath_mother", "1");
				}
			}
			else if (keySelect == 8)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("fire_projectiles_and_lava_inflame_time") < 100)
					{
						
						burnchance++;
						cvar_set("fire_projectiles_and_lava_inflame_time", ftos(burnchance));
					}
					else
					{
						burnchance = 0;
						cvar_set("fire_projectiles_and_lava_inflame_time", ftos(burnchance));
					}
				}
			}
			else if (keySelect == 9)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("yakman_replace_shambler") > 0)//(cvar("yakman_replace_knight") > 0 || cvar("yakman_replace_hellknight") > 0 || cvar("yakman_replace_ogre") > 0 || cvar("yakman_replace_shambler") > 0 || cvar("yakman_replace_shalrath") > 0)
					{
						/*yake = cvar("yakman_replace_hellknight");
						yakb = cvar("yakman_replace_ogre");
						yakc = cvar("yakman_replace_shalrath");
						yakd = cvar("yakman_replace_knight");*/
						//yaka = cvar("yakman_replace_shambler");
						
						/*cvar_set("yakman_replace_hellknight", "0"); 	
						cvar_set("yakman_replace_knight", "0");		
						cvar_set("yakman_replace_ogre", "0");	
						cvar_set("yakman_replace_shalrath", "0");*/	
						cvar_set("yakman_replace_shambler", "0");
					}
					else
					{
						cvar_set("yakman_replace_shambler", "15"); 		
						/*cvar_set("yakman_replace_ogre", ftos(yakb));	
						cvar_set("yakman_replace_shalrath", ftos(yakc));
						cvar_set("yakman_replace_knight", ftos(yakd));
						cvar_set("yakman_replace_hellknight", ftos(yake));*/
						
					}
				}
			}
			else if (keySelect == 10)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("warlord_replace_hknight") > 0)
					{
						cvar_set("warlord_replace_hknight", "0");
						cvar_set("warlord_replace_ogre", "0");
					}
					else
					{
						cvar_set("warlord_replace_ogre", "1");
						cvar_set("warlord_replace_hknight", "20");
					}
				}
			}
			else if (keySelect == 11)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("weapon_chain_thunderbolt") == 1)
					{
						cvar_set("weapon_chain_thunderbolt", "0");
						cvar_set("savedgamecfg", "0");
					}
					else
					{
						cvar_set("weapon_chain_thunderbolt", "1");
						cvar_set("savedgamecfg", "1");
					}
				}
			}
			else if (keySelect == 12)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("slowmotion") == 1)
						cvar_set("slowmotion", "0");
					else
						cvar_set("slowmotion", "1");
				}
			}
			else if (keySelect == 13)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("deathmatch_music") == 1)
						cvar_set("deathmatch_music", "0");
					else
						cvar_set("deathmatch_music", "1");
				}
			}
			else if (keySelect == 14)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (cvar("slowmo_powerup") == 0)
						cvar_set("slowmo_powerup", "1");
					else if (cvar("slowmo_powerup") == 1)
						cvar_set("slowmo_powerup", "2");
					else if (cvar("slowmo_powerup") == 2)
						cvar_set("slowmo_powerup", "3");
					else if (cvar("slowmo_powerup") == 3)
						cvar_set("slowmo_powerup", "4");
					else if (cvar("slowmo_powerup") == 4)
						cvar_set("slowmo_powerup", "0");
				}
			}
			else if (keySelect == 15)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					localcmd("restart\n");
				}
			}
			
			if (keySelect == 16)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					sound(self, CHAN_ITEM, "misc/menu2.wav", 1, ATTN_NONE);
					if (inMenu == 3)
						inMenu = 1;
				}
					
			}
			
		}
		
	}
	//Custom multiplayer menu
	if (inMenu == 5)
	{
		if (flKey == K_ENTER || flKey == K_RIGHTARROW || flKey == K_LEFTARROW)
		{
			if (flEventType == INPUT_KEYDOWN && keySelect != 15)
				sound(self, CHAN_AUTO, "misc/menu3.wav", 1, ATTN_NONE);
			if (keySelect == 1)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (!isSingle())
					{
						if (maxplayers < 32)
							maxplayers++;
						else
							maxplayers = 1;
							
						mp_temp = maxplayers;
					}
				}
			}
			else if (keySelect == 2)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					
					if (gt_cycle == 0) // CHANGE BASED ON GAMETYPE SELECTED
					{
						setDeathmatch();
						gt_cycle++;
					}
					else if (gt_cycle == 1)
					{
						setCTF();
						
						//enforce teamplay rules for bots
						if (cvar("teamplay") == 0)
							cvar_set("teamplay", "1");
						gt_cycle++;
					}
					else if (gt_cycle == 2)
					{
						gt_cycle++;
						//toggle MP gamemodes off before enabling coop
						setDefaults();
						
						//turn on coop
						setCoop();
					}
					else if (gt_cycle == 3)
					{
						setSP();	//reset gametypes and maxplayers for SP
						gt_cycle = 0;
					}
				}
			}
			else if (keySelect == 3)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (!weaponstay)
						weaponstay = 1;
					else
						weaponstay = 0;
				
				}
			}
			else if (keySelect == 4)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (scorelimit < 10)
						scorelimit++;
					else if (scorelimit >= 100)
						scorelimit = 0;
					else
						scorelimit+=5;
						
					if (gametype == "Capture the Flag")
					{
						cvar_set("ctf_capture_limit", ftos(scorelimit));
					}
					else
						cvar_set("fraglimit", ftos(scorelimit));
				}
			}
			else if (keySelect == 5)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (timelimit < 10)
						timelimit++;
					else if (timelimit >= 100)
						timelimit = 0;
					else
						timelimit+=5;
						
					cvar_set("timelimit", ftos(timelimit));
				}
			}
			else if (keySelect == 6)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					setTeamplay();
				}
			}
			else if (keySelect == 7)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (isCTF() || isDeathmatch())
					{
						if (!cvar("ctf_autobalance"))
							cvar_set("ctf_autobalance", "1");
						else
							cvar_set("ctf_autobalance", "0");
					}
					else
					{
						if (cvar("coop_life_pool") == 0)
							cvar_set("coop_life_pool", "1");
						else
							cvar_set("coop_life_pool", "0");
					}
				}
			}
			else if (keySelect == 8)
			{
				if (flEventType == INPUT_KEYDOWN)
					SkillSelect();
	
			}
			else if (keySelect == 9)
			{
				if (flEventType == INPUT_KEYDOWN)
				{
					if (isCTF() || isDeathmatch())
						setBots();
					else
						setAmmoCap();
				}
				
			}
			else if (keySelect == 10)
			{
				if (flEventType == INPUT_KEYDOWN)
					setHook();
					
				return TRUE;
			}
			else if (keySelect == 11)
			{
				if (flEventType == INPUT_KEYDOWN)
					if (inMenu == 5)
						inMenu = 4;
						
				return TRUE;
			}
			
		}
		
	}
	
	if (flKey == K_ENTER)
	{
		if (keySelect == 9 && inMenu == 1)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				sound(self, CHAN_ITEM, "misc/menu3.wav", 1, ATTN_NONE);
				if (sliderPos < 7)
					sliderPos++;
				else
					sliderPos = 0;
			}
		}
		if (keySelect == 10 && inMenu != 3)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				sound(self, CHAN_ITEM, "misc/menu2.wav", 1, ATTN_NONE);
				if (inMenu == 1)
					inMenu = 2;
				keySelect = 15;
			}
		}
		if (keySelect == 11 && inMenu == 1)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				sound(self, CHAN_ITEM, "misc/menu2.wav", 1, ATTN_NONE);
				if (inMenu == 1)
					inMenu = 3;
				keySelect = 16;
			}
		}
		if (keySelect == 15 && inMenu == 2)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				keySelect = 10;
	
			}
		}
		if (keySelect == 16)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				keySelect = 10;
	
			}
		}
		if (inMenu == 1 && (keySelect != 9 && keySelect != 10 && keySelect != 11 && keySelect != 15 && keySelect != 16))
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				sound(self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE); //only play sound when entering bind mode
				if (bindMode == 0)
					bindMode = 1;
				else if (bindMode == 1)
					bindMode = 0;
				
			}
			
		}
		
		if (inMenu == 4)
		{
			if (flEventType == INPUT_KEYDOWN)
				loadMap();
		}
		
	}
	if (inMenu == 1 && keySelect == 9)
	{
		if (flKey == K_RIGHTARROW)
		{
			if (flEventType == INPUT_KEYDOWN)
				{
					sound(self, CHAN_ITEM, "misc/menu3.wav", 1, ATTN_NONE);
					if (sliderPos < 7)
						sliderPos++;
				}
			

		}
		if (flKey == K_LEFTARROW)
		{
			if (flEventType == INPUT_KEYDOWN)
				{
					sound(self, CHAN_ITEM, "misc/menu3.wav", 1, ATTN_NONE);
					if (sliderPos > 0)
						sliderPos-=1;
				}
		}
	}
	
	//Maplist menu
	if (flKey == K_LEFTARROW)
	{
		if (flEventType == INPUT_KEYDOWN)
		{	
			if (inMenu == 4 && arrowPos >= 10)// && posveclist_y < maplist.length*4.7)
			{
				sound(self, CHAN_ITEM, "misc/menu3.wav", .5, ATTN_NONE);
				arrowPos-=10;
				posveclist -= '0 100';
			}
		}
	}
	if (flKey == K_RIGHTARROW)
	{
		if (flEventType == INPUT_KEYDOWN)
		{
			if (inMenu == 4 && arrowPos <= 590)// && posveclist_y < maplist.length*4.7)
			{
				sound(self, CHAN_ITEM, "misc/menu3.wav", .5, ATTN_NONE);
				arrowPos+=10;
				posveclist += '0 100';
			}
		}
	}
	if (flKey == K_DOWNARROW)
	{
		if (inMenu)
		{
			if (flEventType == INPUT_KEYDOWN)
			{

				sound(self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NONE);
				if (bindMode == 0)
				{
					if (inMenu == 1)
					{
						keySelect+=1;
						if (keySelect == 12)
							keySelect = 1;
					}
					else if (inMenu == 2)
					{
						keySelect+=1;
						if (keySelect == 16)
							keySelect = 1;
					}
					else if (inMenu == 3)
					{
						keySelect+=1;
						if (keySelect == 17)
							keySelect = 1;
					}
					else if (inMenu == 4)// && posveclist_y < maplist.length*4.7)
					{
						keytimer++;
						if(keytimer >= 30  && arrowPos <= 690)
						{
							arrowPos+=3;
							posveclist += '0 30';
						}
						else if (!POINTS_TO_BSP && arrowPos <= 300)
						{
							arrowPos+=20;
							posveclist += '0 200';
						}
						else
						{
							arrowPos++;
							posveclist += '0 10';
						}
					}
					else if (inMenu == 5)
					{
						keySelect+=1;
						if (keySelect == 12)
							keySelect = 1;
					}
					
				}
			}
			if (flEventType == INPUT_KEYUP)
				keytimer = 0;
			
			
		}
		
	}
	if (flKey == K_UPARROW)
	{
		if (inMenu)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				sound(self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NONE);
				if (bindMode == 0)
				{
					if (inMenu == 1)
					{
						keySelect-=1;
						if (keySelect == 0)
							keySelect = 11;
					}
					else if (inMenu == 2)
					{
						keySelect-=1;
						if (keySelect == 0)
							keySelect = 15;
					}
					else if (inMenu == 3)
					{
						keySelect-=1;
						if (keySelect == 0)
							keySelect = 16;
					}
					else if (inMenu == 4 && posveclist_y > 300)
					{
						keytimer++;
						if(keytimer >= 30  && arrowPos >= 10)
						{
							arrowPos-=3;
							posveclist -= '0 30';
						}
						else if (!POINTS_TO_BSP && arrowPos >= 20)
						{
							arrowPos-=20;
							posveclist -= '0 200';
						}
						else
						{
							arrowPos--;
							posveclist -= '0 10';
						}
					}
					else if (inMenu == 5)
					{
						keySelect-=1;
						if (keySelect == 0)
							keySelect = 11;
					}					
				}
				
			}
			if (flEventType == INPUT_KEYUP)
				keytimer = 0;
		}
	}
	if (flKey == K_END)
	{
		if (inMenu == 4)
		{
			if (flEventType == INPUT_KEYDOWN)
			{
				sound(self, CHAN_AUTO, "misc/menu1.wav", 1, ATTN_NONE);
				SkillSelect();
			}
			
		}
	}
	if (getkeybind(flKey) == "togglekeybinds" || flKey == K_HOME)
	{
		
		if (flEventType == INPUT_KEYUP)
		{
			//TogglePause();
			sound(self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
			if (!inMenu)
			{
				keySelect = 1;
				inMenu = 1;
			}
			else if (inMenu == 4)
			{
				keySelect = 1;
				inMenu = 5;
			}
			else if (inMenu == 5)
			{
				//TogglePause();
				inMenu = 4;
				//updateServerMaxPlayers();
			}
			else if (bindMode == 1)
				bindMode = 0;
			else if (inMenu)
				inMenu = 0;	
		}
	}
	if (flKey == K_BACKSPACE)
	{
		if (flEventType == INPUT_KEYDOWN)
		{
			//TogglePause();
			sound(self, CHAN_AUTO, "misc/menu2.wav", 1, ATTN_NONE);
			if (!inMenu)
			{
				//if (cvar("deathmatch") == 0 && cvar("coop") == 0)
				//	cvar_set("sv_freezenonclients", "1");
				inMenu = 4;
			}
			else if (inMenu == 5)
			{
				inMenu = 4;
				//updateServerMaxPlayers(); 
			}
			else if (inMenu)
				inMenu = 0;	
		}
	}
	//If in custom menu, disable player input
	if (inMenu)
	{
		if (flKey == K_ESCAPE)
			if (flEventType == INPUT_KEYDOWN)
			{
				inMenu = 0;
				//TogglePause();
			}
				
		return TRUE;
	}
	
	//Input handler for custom HUD
	if (getkeybind(flKey) == "+showscores")
	{
		
		if (flEventType == INPUT_KEYDOWN)
		{
			showscores = TRUE;
			return FALSE;
		}
		if (flEventType == INPUT_KEYUP)
		{
			showscores = FALSE;
			return FALSE;
		}
	}
        else return FALSE;
}