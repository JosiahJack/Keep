
void() GF1_Update =
{
	local string s;
	s = ftos(gameflags1);
	cvar_set("saved1", s);
};


void() BDW_ResetMapHack =
{
	//this is a jolly (awful) little hack :}
	
	if (!cvar("developer"))
		return;
		
	//store player pos in some harmless console variables (that we reset after respawning)
	local string s;
	
	s = ftos(self.origin_x);
	cvar_set("cl_forwardspeed", s);
	
	s = ftos(self.origin_y);
	cvar_set("cl_backspeed", s);

	s = ftos(self.origin_z);
	cvar_set("cl_sidespeed", s);
	
	
	gameflags1 = gameflags1 | GF1_MAP_RESET_HACK;	
	GF1_Update();
	
	// restart the entire server
	localcmd ("restart\n");


}



void() ReportGameflags =
{
	
	
	if (gameflags1 & GF1_ALT_GIBS)
		dprint("new gib sounds enabled.     ");
	else
		dprint("original gib sounds enabled.");

	//dprint("use \"impulse 152\" to toggle\n");
	dprint("\n");
	
	if (gameflags1 & GF1_NO_GROUPING)
		dprint("entity grouping disabled.   ");
	else
		dprint("entity grouping enabled.    ");
		
	dprint("use \"impulse 152\" to toggle\n");
	
	if (gameflags1 & GF1_CORPSE_STAY)
		dprint("all corpses stay.        	");
	else if (gameflags1 & GF1_CORPSE_REMOVE_ALL)
		dprint("all corpses are removed. 	");
	else
		dprint("corpse removal follows map standard. ");
	dprint("\n");
			
	//dprint("use \"impulse 153\" to toggle\n");
};
		




/*
void() GF2_Update =
{
	local string s;
	s = ftos(gameflags2);
	cvar_set("saved2", s);
};
void() GF3_Update =
{
	local string s;
	s = ftos(gameflags3);
	cvar_set("saved3", s);
};
void() GF4_Update =
{
	local string s;
	s = ftos(gameflags4);
	cvar_set("saved4", s);
};
*/

void() BDW_ToggleImpactSounds =
{
	if (gameflags1 & GF1_IMPACTS)
	{
		bprint("new impact sounds disabled.\n");
		gameflags1 = gameflags1 - GF1_IMPACTS;
	}
	else
	{
		bprint("new impact sounds enabled.\n");
		gameflags1 = gameflags1 | GF1_IMPACTS;	
	}
	
	GF1_Update();
}

void() BDW_ToggleGibStyles =
{
	if (gameflags1 & GF1_ALT_GIBS)
	{
		bprint("classic giblets restored, restart level for changes to take effect.\n");
	}
	else
	{
		bprint("unreal giblets enabled, restart level for changes to take effect\n");
	}
	
	gameflags1 = gameflags1 | GF1_GIBS_CHANGED;

	
	GF1_Update();
}


void() GF_ToggleNoGrouping =
{
	if (gameflags1 & GF1_NO_GROUPING)
	{
		gameflags1 = gameflags1 - GF1_NO_GROUPING;
		bprint("entity grouping enabled, restart level for changes to take effect\n");
	}
	else
	{
		gameflags1 = gameflags1 | GF1_NO_GROUPING;
		bprint("entity grouping disabled, restart level for changes to take effect\n");
	}

	GF1_Update();
};

/*void() GF_ToggleCorpseStay =
{
	if (gameflags1 & GF1_CORPSE_STAY)
	{
		gameflags1 = gameflags1 - GF1_CORPSE_STAY;
		bprint("corpse stay disabled, restart level for changes to take effect\n");
	}
	else
	{
		gameflags1 = gameflags1 | GF1_CORPSE_STAY;
		bprint("corpse stay enabled, restart level for changes to take effect\n");
	}

	GF1_Update();
};*/

void() GF_CorpseRemoveAll =
{
	gameflags1 = gameflags1 - (gameflags1 & GF1_CORPSE_STAY);	
	gameflags1 = gameflags1 | GF1_CORPSE_REMOVE_ALL;
	GF1_Update();
	bprint("corpse remove all enabled, restart level for changes to take effect\n");
};

void() GF_CorpseRemoveCustom =
{
	gameflags1 = gameflags1 - (gameflags1 & GF1_CORPSE_STAY);	
	gameflags1 = gameflags1 - (gameflags1 & GF1_CORPSE_REMOVE_ALL);
	GF1_Update();
	bprint("corpse remove custom enabled, restart level for changes to take effect\n");
};

void() GF_CorpseRemoveNone =
{
	gameflags1 = gameflags1 - (gameflags1 & GF1_CORPSE_REMOVE_ALL);
	gameflags1 = gameflags1 | GF1_CORPSE_STAY;
	GF1_Update();
	bprint("corpse remove disabled, restart level for changes to take effect\n");
};
	

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
	local	float	it, am, fl;

	it = self.items;
	am = 0;

	if (self.impulse == 1)
	{
		//bdw - sickle/axe toggle
	
		if (!(self.items & IT_SICKLE))
			fl = IT_AXE;	//always axe if sickle not in inventory			
		else
		{	//toggle
			if (self.weapon == IT_SICKLE)
				fl = IT_AXE;
			else
      				fl = IT_SICKLE;      			
      		}
   	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
      	fl = IT_SUPER_NAILGUN;
      	if (self.ammo_nails < 2)
         		am = 1;
	}
	else if (self.impulse == 6)
	{      	
         	fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}	
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
      	fl = IT_LIGHTNING;
      	if (self.ammo_cells < 1)
         	am = 1;
   	}
   	else if (self.impulse == 225)
	{
      	fl = IT_LASER_CANNON;
      	if (self.ammo_cells < 1)
         	am = 1;
   	}
   	
   	/* bdw - removed mjolnir
   	else if (self.impulse == 226)
	{
      	fl = IT_MJOLNIR;
   	}
   	*/

	self.impulse = 0;

	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}

	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
   self.weapon = fl;
	BDW_SetCurrentWeapon();
};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
	if (deathmatch || coop)
		return;

//bdw - max ammo...
	self.ammo_shells = self.ammo_nails = self.ammo_rockets = self.ammo_cells = 250;

	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_LIGHTNING |
		IT_SICKLE;
//BDW
		//| IT_KEY1 | IT_KEY2;

	//self.weapon = IT_ROCKET_LAUNCHER;
	//self.impulse = 0;
	//BDW_SetCurrentWeapon();
};

void() BDW_KeyToggle =
{
	if (deathmatch || coop)
		return;
		
	if ( !(self.items & (IT_KEY1 | IT_KEY2)) )	//if no keys
		self.items = self.items | IT_KEY1 | IT_KEY2;
	else
		self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2));
};		


/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			BDW_SetCurrentWeapon();
			return;
		}
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local	float	it, am;
	
	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			BDW_SetCurrentWeapon();
			return;
		}
	}

};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
	if (deathmatch || coop)
		return;
		
	//bdw - rewrote this...
		
	if (self.super_damage_finished < time)
	{		
		self.super_time = 1;
		self.super_damage_finished = time + 100000;
		self.items = self.items | IT_QUAD;
		self.effects = self.effects | EF_DIMLIGHT;
   		bprint("quad cheat on\n");   		
   	}	
   	else
   	{
   		self.super_time = 0;
   		self.super_damage_finished = 0;
   		self.items = self.items - (self.items & IT_QUAD);
		self.effects = self.effects - (self.effects & EF_DIMLIGHT);		
		bprint("quad cheat off\n");		
	}
};

void() DumpEntities =
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      dprint(ftos(i));
      dprint(" ");
      dprint(head.classname);
      dprint("\n");
      head = nextent(head);
      i = i + 1;
      }
   };

void() DumpLiveEntities =
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      if (head.health > 0)
         {
         dprint(ftos(i));
         dprint(" ");
         dprint(head.classname);
         dprint(" ");
         dprint(vtos(head.origin));
         dprint("\n");
         dprint("--------------------\n");
         }
      head = nextent(head);
      i = i + 1;
      }
   };

void() Genocide =
{
   	local entity   head;

   	if (deathmatch || coop)
		return;

   	bprint("Genocide!\n");
   	head = nextent(world);
   	while (head!=world)
      {
      	if ((head.health > 0) && (head.flags & FL_MONSTER))
         	{
			if (head.monsterflags & MF_ZOMBIE_GIB)	//quick hack to stop too many zombie gibs 
			{
				head.think = SUB_Remove;
				head.nextthink = time + random()*0.1;
			}
			else
         			T_Damage(head,world,world,head.health+10);
         	}
      	head = nextent(head);
      }
};

float dump_coord;
void() ToggleDump =
{
   	dump_coord = 1 - dump_coord;
   	if (dump_coord == 1)
      bprint("Dumping Player Location\n");
};

void() DumpCoordinates =
{
   	local entity pl;
   	pl = checkclient();
   	if (pl)
      {
      	bprint("Player: ");
      	bprint(vtos(pl.origin));
      	bprint("\n");
		
		//bdw - dump view angle
		bprint("View Angle: ");
		bprint(vtos(pl.v_angle));
      	bprint("\n");
      }
};

void() BDW_MonsterStats =
{
	local entity head;
	local float m_live, m_dead, m_gangs, m_gangtot, m_items;

	head = nextent(world);
   	while (head)
      {
      	if (head.flags & FL_MONSTER)
         	{
			if (head.health > 0)
				m_live = m_live + 1;
			else
				m_dead = m_dead + 1;
		}

		else if (head.classname == "bdw_monsterspawn_gang")
		{
			m_gangs = m_gangs + 1;
			m_gangtot = m_gangtot + head.count;
		}

		else if (head.flags & FL_ITEM)
         	{
			m_items = m_items + 1;
		}

      	head = nextent(head);
      }

	bprint("no. live monsters = ");
	bprint(ftos(m_live));
	bprint("\n");
	bprint("no. corpses = ");
	bprint(ftos(m_dead));
	bprint("\n");
	bprint("no. gang spawners = ");
	bprint(ftos(m_gangs));
	bprint("\n");
	bprint("total gang monsters = ");
	bprint(ftos(m_gangtot));
	bprint("\n");
	bprint("no. pickup items = ");
	bprint(ftos(m_items));
	bprint("\n");
};

void() BDW_RemoveGlobalSounds =
{
	local entity snd;

	snd = nextent(world);

	while (snd)
	{
		if (snd.classname == "bdw_sound_ghosty")
		{
			snd.think = SUB_Remove;
			snd.nextthink = time + 0.1;
			bprint("global ambient sound removed\n");
		}

		snd = nextent(snd);
	}
};


/*
============
ImpulseCommands

============
*/




void() BDW_MonsterListReport;

void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

   	else if (self.impulse >= 225 && self.impulse <= 226)	
		W_ChangeWeapon ();

	else if (self.impulse == 9)		CheatCommand();
   	else if (self.impulse == 10)	CycleWeaponCommand();
	else if (self.impulse == 11)	ServerflagsCommand();
	else if (self.impulse == 12)	CycleWeaponReverseCommand();
//bdw
	else if (self.impulse == 100)	ReportGameflags();
	else if (self.impulse == 101) 	BDW_ToggleImpactSounds();
	else if (self.impulse == 102)	TF_PurgeCorpses();
	else if (self.impulse == 103)	BDW_ResetMapHack();
	else if (self.impulse == 104)	BDW_ItemListReport();
	else if (self.impulse == 105)	BDW_MonsterListReport();
	else if (self.impulse == 106)	BDW_ToggleGibStyles();
	else if (self.impulse == 150)	BDW_RemoveGlobalSounds();
	else if (self.impulse == 151)	BDW_KeyToggle();
	else if (self.impulse == 152)	GF_ToggleNoGrouping();
	else if (self.impulse == 153)	GF_CorpseRemoveAll();
	else if (self.impulse == 154)	GF_CorpseRemoveCustom();
	else if (self.impulse == 155)	GF_CorpseRemoveNone();

	else if (self.impulse == 202)	DumpEntities();
  	else if (self.impulse == 203)	DumpLiveEntities();    
   	else if (self.impulse == 205)  	Genocide();
  	else if (self.impulse == 206)	ToggleDump();
  	
//entity selector stuff...
	else if (self.impulse == 210)	EntSelector_ToggleState();
   	else if (self.impulse == 211)	EntSelector_Kill();
	else if (self.impulse == 212)	EntSelector_Use();
	else if (self.impulse == 213)	EntSelector_Touch();	
	else if (self.impulse == 214)	EntSelector_Print();

  	else if (self.impulse == 255)   QuadCheat();		
		
   	if (dump_coord == 1)
    	DumpCoordinates();

	self.impulse = 0;
};

float(float w) BDW_ImpulseForWeapon =
{
	if (w == IT_AXE)
		return 1;
	if (w == IT_SHOTGUN)
		return 2;
	if (w == IT_SUPER_SHOTGUN)
		return 3;
	if (w == IT_NAILGUN)
		return 4;
	if (w == IT_SUPER_NAILGUN)
		return 5;
	if (w == IT_GRENADE_LAUNCHER)
		return 6;
	if (w == IT_ROCKET_LAUNCHER)	
		return 7;
	if (w == IT_LIGHTNING)
		return 8;

	return 0;
};


