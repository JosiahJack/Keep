
void CSQC_Parse_Print (string msg)
{
	print(msg);
}

void CSQC_Parse_CenterPrint (string msg)
{
	cprint(msg);
}

void SysParms_UPDATE (void)
{
	vid_width = cvar("vid_conwidth");
	vid_height = cvar("vid_conheight");
}




void CSQC_Ent_Update (float isnew)
{
	float i;
	i = ReadByte();
	
	
		if (i == SEND_INV)
			Update_Slot (isnew);
				
			else
				print ("^1ERROR: CSQC_Ent_Update unidentifiable header\n");
}



void CSQC_Ent_Remove ()
{
	remove(self);
};


void CSQC_Init (void)
{

	local float i;

	precache_pic ("gfx/loading");
	
	CursorContainer_Init();	// Spawn Cursor Container
	InvContainer_Init ();	// Spawn Inventory Container
	
	setwantsmousemove(1);

}


void CSQC_Shutdown (void)
{
}

void CSQC_ConsoleCommand (string str)
{
}


void CSQC_UpdateView (void)
{
	SysParms_UPDATE();
	View_Update();
	

		R_ClearScene();

		R_SetView(VF_DRAWWORLD, 1);

		R_SetView(VF_DRAWCROSSHAIR, 0);
		R_SetView(VF_DRAWENGINESBAR, 0);

		R_AddEntities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS);
		R_RenderScene();
	
	
	
	
	if (getstati(STAT_TOGGLEINVENTORY) == true)
	{
	
		// Make sure you render containers and check their collision in the same order.
	
		Render_Inventory();
		Render_Cursor();
		
		
		
		if (SaveMouseMove == true)
		{
		setwantsmousemove(1);
		SaveMouseMove = false;
		}
			return;
	}
	else
	{
		if (SaveMouseMove == false)
		{
		setwantsmousemove(0);
		SaveMouseMove = true;
		}
			return;

	}


}

float CSQC_InputEvent (float event, float parama)
{
	return false;
}


void GameCommand (string cmd) =
{

local float length, msgpart;

	msgpart = tokenize(cmd);

	if (argv(0) == "hud_print")
	{
		// cl_cmd hud_print <insert>  receives here.
	
	}
};


void CSQC_Parse_StuffCmd (string msg)
{
	if(isdemo())
		return;
		
	localcmd(msg);
}


