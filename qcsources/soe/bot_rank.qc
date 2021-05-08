/***********************************************
*                                              *
*           FrikBot Ranking Code               *
*      "The stuff Alan Kivlin invented"        *
*                                              *
***********************************************/

// Bot Name -> almost exactly the same, just looks different
string(float r) BotName =
{
	if (r == 1)
	{	
		self.fPants = 11;
		self.fShirt = 0; 
		return "Vincent";
	}
	else if (r == 2)
	{
		self.fPants = 1;
		self.fShirt = 3;
		return "Bishop";
	}
	else if (r == 3)
	{	
		self.fPants = 13;
		self.fShirt = 2;
		return "Nomad";
	}
	else if (r == 4)
	{
		self.fPants = 7;
		self.fShirt = 6;
		return "Hudson";
	} 
	else if (r == 5)
	{
		self.fPants = 12;
		self.fShirt = 6;
		return "Lore";
	}
	else if (r == 6)
	{
		self.fPants = 4;
		self.fShirt = 4;
		return "Servo";
	}
	else if (r == 7)
	{
		self.fPants = 2;
		self.fShirt = 5;
		return "Gort";
	} 
	else if (r == 8)
	{	
		self.fPants = 10;
		self.fShirt = 3;
		return "Kryten";
	}
	else if (r == 9)
	{
		self.fPants = 9;
		self.fShirt = 4;
		return "Pimp Bot";
	}
	else if (r == 10)
	{
		self.fPants = 4;
		self.fShirt = 7;
		return "Maximillian";
	}
	else if (r == 11)
	{
		self.fPants = 3;
		self.fShirt = 11;
		return "Marvin";
	} 
	else if (r == 12)
	{
		self.fPants = 13;
		self.fShirt = 12;
		return "Erwin";
	}
	else if (r == 13)
	{
		self.fPants = 11;
		self.fShirt = 2;
		return "FrikBot";
	}
	else if (r == 14)
	{
		self.fPants = 0;
		self.fShirt = 2;
		return "Krosis";
	}
	else if (r == 15)
	{
		self.fPants = 8;
		self.fShirt = 9;
		return "Gypsy";
	}
	else 
	{
		self.fPants = 5;
		self.fShirt = 10;
		return "Hal";
	}
};
string () PickARandomName =
{
	local float y, test;
	local string h;
	local entity t;
	y = TRUE;
	while(y)
	{
		test = ceil(random() * 16);
		h = BotName(test);
		t = find(world, netname, h);
		if (t == world)
			y = FALSE;
	}
	return h;
};


.entity phys_obj;

void() BotInit =
{
   local entity ent, fisent;
    local float numents;
   // this works by counting the number of entities created after world
   // so you must call it right at the beginning of worldspawn in WORLD.QC

   ent = nextent( world );

   while( ent.classname != "worldspawn" )
   {
      fMaxClients = fMaxClients + 1;
      ent = nextent( ent );
   }
   // spawn entities for the physics
   ent = nextent( world );
   while (numents < fMaxClients)
   {
        fisent = spawn();
        ent.phys_obj = fisent;
	  fisent.owner = ent;
        numents = numents + 1;
        ent = nextent(ent);

   }

};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Rankings 'utilities'. Written by Alan Kivlin,
this code just fools clients by sending precisely
the same network messages as when a real player
signs on to the server.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/


void(float clientno, string clientname) msgUpdateNameToAll =
{
   WriteByte( MSG_ALL, MSG_UPDATENAME );
   WriteByte( MSG_ALL, clientno );
   WriteString( MSG_ALL, clientname );
};

void(float clientno, float clientshirt, float clientpants) msgUpdateColorsToAll =
{
   WriteByte( MSG_ALL, MSG_UPDATECOLORS );
   WriteByte( MSG_ALL, clientno );
   WriteByte( MSG_ALL, clientshirt * 16 + clientpants );
};

void(float clientno, float clientfrags) msgUpdateFragsToAll =
{
   WriteByte( MSG_ALL, MSG_UPDATEFRAGS );
   WriteByte( MSG_ALL, clientno );
   WriteShort( MSG_ALL, clientfrags );
};

float(float clientno) clientBitFlag =
{
   local float bitflag;
   bitflag = 1;
   while( clientno > 0 )
   {
      bitflag = bitflag * 2;
      clientno = clientno - 1;
   }
   return bitflag;
};

float(float clientno) clientIsActive =
{
   if(fActiveClients & clientBitFlag(clientno))
      return TRUE;
   return FALSE;
};

void(float clientno) clientSetUsed =
{
   fActiveClients = fActiveClients | clientBitFlag(clientno);
};

void(float clientno) clientSetFree =
{
   fActiveClients = fActiveClients - 
      (fActiveClients & clientBitFlag(clientno));
};

float() clientNextAvailable =
{
   local float clientno;
   clientno = 0;
   while(clientno < fMaxClients)
   {
      if(!clientIsActive(clientno))
         return clientno;

      clientno = clientno + 1;
   }

   return -1;
};

//----------------------------------------------------------------------------


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Find Another Color

Team finding code

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

float(float tcolor) FindAnotherColor =
{
	local entity t;
	local float bestbet, scolor, pcount, bestp;
	bestbet = -1;
	bestp = 16;
	while(scolor < 14)
	{
		if (scolor != tcolor)
		{
			t = find(world, classname, "player");
			pcount = 0;
			while(t != world)
			{
				if (t.team == scolor + 1)
					pcount = pcount + 1;
				t = find(t, classname, "player");
			}
			if ((pcount < bestp) && (pcount != 0))
			{
				bestbet = scolor;
				bestp = pcount;
			}
		}
		scolor = scolor + 1;
		
	}
	if (bestbet < 0)
	{
		bestbet = tcolor;
		while (bestbet == tcolor)
		{
			bestbet = floor(random() * 13);
		}
	}
	return bestbet;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

BotConnect and related functions.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/				
entity(float num) GetClientEntity =
{
	local entity upsy;
	upsy = world;
	num = num + 1;
	while (num > 0)
	{
		num = num - 1;
		upsy = nextent(upsy);
	} 
	return upsy;
};

void(float whichteam) botConnect =
{
	local float clientno;
	local entity bot;
	local entity uself;
	
	clientno = clientNextAvailable();
	uself = self;
	if(clientno == -1)
	{
		bprint("Unable to connect a bot, server is full.\n");
		return;
	}

	clientSetUsed(clientno);

	BOT_COUNT = BOT_COUNT + 1;
	bot = GetClientEntity(clientno);
	bot.fClientNo = clientno;
	bot.colormap = clientno + 1;
	self = bot;
	bot.netname = PickARandomName();

	if (teamplay)
	{
		if (whichteam)
			self.fPants = FindAnotherColor(uself.team - 1);
		else
			self.fPants = uself.team - 1;
		self.fShirt = self.fPants;
	}
	bot.team = bot.fPants + 1;

	msgUpdateColorsToAll( bot.fClientNo, bot.fShirt, bot.fPants );
	msgUpdateNameToAll( bot.fClientNo, bot.netname );
	msgUpdateFragsToAll( bot.fClientNo, bot.frags );
	SetNewParms();
	self.ishuman = 2; // testing?
	ClientConnect();
	self.ishuman = FALSE;
	PutClientInServer();
	self = uself;
};

void( entity bot ) botDisconnect =
{
	local entity whoself;
	whoself = self;
	self = bot;

	BOT_COUNT = BOT_COUNT - 1;
   if( bot.fClientNo != -1 )
   {

      // the bot's client number is not in use by a real player so we
      // must remove it's entry in the rankings

      msgUpdateNameToAll( bot.fClientNo, string_null );
      msgUpdateColorsToAll( bot.fClientNo, 0, 0 );
      msgUpdateFragsToAll( bot.fClientNo, 0 );

      clientSetFree( bot.fClientNo );

      bot.fClientNo = -1;
   }
	ClientDisconnect();
	self.tfrags = self.frags = 0;
	self.netname = "";
	self.classname = "";
	self.health = 0;
	self.items = 0;
	self.armorvalue = 0;
	self.weaponmodel = "";
	// Quake engine sets all fiels to 0, here I just do the most important

	self = whoself;
};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Kick A Bot. 

Update: version 0.05 this is now a stock feature.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() KickABot =
{
	local entity ty;
	ty = find(world, classname, "player");
	while (ty != world)
	{
		if (!(ty.ishuman))
		{
			
			botDisconnect(ty);
			ty.ishuman = TRUE;
			ty = world;
		}
		else
			ty = find(ty, classname, "player");
	}

};
/*
==============================================================================
botInvalidClientNo

moves the conflicting bot over to a free client number, if none it disconnects
==============================================================================
*/

void( float clientno ) botInvalidClientNo =
{
   local entity bot;

   bot = find( world, classname, "player" );
 // it's neccasary to kick the bot completely as they cannot simply be re-assigned a client number as before

   while( bot )
   {
      if(( bot.fClientNo == clientno ) && (!(bot.ishuman)))
      {
         bot.fClientNo = -1;
         botDisconnect( bot );
         return;
      }

      bot = find( bot, classname, "player" );
   }
};




