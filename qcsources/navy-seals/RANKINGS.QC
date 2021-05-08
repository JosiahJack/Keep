/*
==============================================================================
RANKINGS.QC by Alan Kivlin <e-mail: alan.kivlin@cybersurf.co.uk>

07 / JUNE / 1997

Copyright (C) 1997 by Alan Kivlin.
==============================================================================
*/

// client number of the player/bot
.float fClientNo;

// bit flags for the (maximum) sixteen clients in standard quake
float fActiveClients;

// number of client entities available for the current game
float fMaxClients;

//----------------------------------------------------------------------------

// stores in fMaxClients, the maximum number of client's allowed in the game
void() clientInitMaxClients;

// returns the client's bit flag
float( float fClientNo ) clientBitFlag;

// returns TRUE if the client number specified is in use by a bot or player
float( float fClientNo ) clientIsActive;

// marks the client's bit flag as being in use
void( float fClientNo ) clientSetUsed;

// marks the client's bit flag as being available
void( float fClientNo ) clientSetFree;

// returns the next available free client number (-1 = none available)
float() clientNextAvailable;

//----------------------------------------------------------------------------

// bot's shirt and pants color
.float fShirt;
.float fPants;

//----------------------------------------------------------------------------

// sample routine for connecting a bot
void(entity bot) botConnect;

// sample routine for disconnecting a bot
void( entity bot ) botDisconnect;

// moves the conflicting bot over to a free client number, if none it disconnects
void( float clientno ) botInvalidClientNo;

//----------------------------------------------------------------------------

float MSG_UPDATENAME   = 13; // message id for update name
float MSG_UPDATEFRAGS  = 14; // message id for update frags
float MSG_UPDATECOLORS = 17; // message id for update colors

//----------------------------------------------------------------------------

// sends an update client name message to a player in the game
void( entity player, float clientno, string clientname ) msgUpdateNameToPlayer;

// sends an update client colors message to a player in the game
void( entity player, float clientno, float clientshirt, float clientpants ) msgUpdateColorsToPlayer;

// sends an update client frags message to a player in the game
void( entity player, float clientno, float clientfrags ) msgUpdateFragsToPlayer;

// sends an update client name message to all players in the game
void( float clientno, string clientname ) msgUpdateNameToAll;

// sends an update client colors message to all players in the game
void( float clientno, float clientshirt, float clientpants ) msgUpdateColorsToAll;

// sends an update client frags message to all players in the game
void( float clientno, float clientfrags ) msgUpdateFragsToAll;

//----------------------------------------------------------------------------

/*
==============================================================================
clientInitMaxClients

stores in fMaxClients, the maximum number of client's allowed in the game
==============================================================================
*/

void() clientInitMaxClients =
{
   local entity ent;

   // this works by counting the number of entities created after world
   // so you must call it right at the beginning of worldspawn in WORLD.QC

   ent = nextent( world );

   while( ent.classname != "worldspawn" )
   {
      fMaxClients = fMaxClients + 1;
      ent = nextent( ent );
   }
};

/*
==============================================================================
clientBitFlag

returns the client's bit flag
==============================================================================
*/

float( float clientno ) clientBitFlag =
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

/*
==============================================================================
clientIsActive

returns TRUE if the client number specified is in use by a bot or player
==============================================================================
*/

float( float clientno ) clientIsActive =
{
   if( fActiveClients & clientBitFlag( clientno ) )
      return TRUE;

   return FALSE;
};

/*
==============================================================================
clientSetUsed

marks the client's bit flag as being in use
==============================================================================
*/

void( float clientno ) clientSetUsed =
{
   fActiveClients = fActiveClients | clientBitFlag( clientno );
};

/*
==============================================================================
clientSetFree

marks the client's bit flag as being available
==============================================================================
*/

void( float clientno ) clientSetFree =
{
   fActiveClients = fActiveClients -
      ( fActiveClients & clientBitFlag( clientno ) );
};

/*
==============================================================================
clientNextAvailable

returns the next available free client number (-1 = none available)
==============================================================================
*/

float() clientNextAvailable =
{
   local float clientno;

   clientno = 0;

   while( clientno < fMaxClients )
   {
      if( ! clientIsActive( clientno ) )
         return clientno;

      clientno = clientno + 1;
   }

   return -1;
};

//----------------------------------------------------------------------------

/*
==============================================================================
botConnect

sample routine for connecting a bot
==============================================================================
*/

void (entity bot) botConnect =
{
   local float clientno;
   local entity bot;

   clientno = clientNextAvailable();

   if( clientno == -1 )
   {
      //bprint( "Unable to connect a bot, server is full.\n" );
      return;
   }

   clientSetUsed( clientno );

   //bot = spawn(); // already done in squad code

   bot.fClientNo = clientno;
   bot.colormap = clientno + 1;

   // give the bot a name - you provide this routine
   //botSetName( bot ); // already done in squad code

   //bot.fShirt = floor( random() * 13 );
   //bot.fPants = floor( random() * 13 );

   msgUpdateNameToAll( bot.fClientNo, bot.netname );
   msgUpdateColorsToAll( bot.fClientNo, bot.fShirt, bot.fPants );
   msgUpdateFragsToAll( bot.fClientNo, bot.frags );

   bprint( bot.netname );
   bprint( " entered the game\n" );

   // add code to initialise the bot
};

/*
==============================================================================
botDisconnect

sample routine for disconnecting a bot
==============================================================================
*/

void( entity bot ) botDisconnect =
{
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

   bprint( bot.netname );
   bprint( " left the game with " );
   bprint( ftos( bot.frags ) );
   bprint( " frags\n" );

   sound( bot, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE );

   // add code to set the bot's suicide frame, copy it to the bodyque, etc
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

   bot = find( world, classname, "bot" );

   while( bot )
   {
      if( bot.fClientNo == clientno )
      {
         clientno = clientNextAvailable();

         if( clientno != -1 )
         {
            clientSetUsed( clientno );

            bot.fClientNo = clientno;
            bot.colormap = bot.fClientNo + 1;

            msgUpdateNameToAll( bot.fClientNo, bot.netname );
            msgUpdateColorsToAll( bot.fClientNo, bot.fShirt, bot.fPants );
            msgUpdateFragsToAll( bot.fClientNo, bot.frags );
         }
         else
         {
            bot.fClientNo = -1;
            botDisconnect( bot );
         }

         return;
      }

      bot = find( bot, classname, "bot" );
   }
};

//----------------------------------------------------------------------------

/*
==============================================================================
The following player specific update routines didn't work as I expected.

For some reason, sending messages via MSG_ONE to a player that's just
connected has no effect. My first thought was that the player would still be
in the init stage so I sent via MSG_INIT but this also had no effect.

Messages sent via MSG_ALL *DO* get to a player that's just connected so these
routines aren't really necessary but I left them in anyway and made them call
the relevent ToAll routines.
==============================================================================
*/

/*
==============================================================================
msgUpdateNameToPlayer

sends an update client name message to a player in the game
==============================================================================
*/

void( entity player, float clientno, string clientname ) msgUpdateNameToPlayer =
{
   msgUpdateNameToAll( clientno, clientname );
   return;

   msg_entity = player;
   WriteByte( MSG_ONE, MSG_UPDATENAME );
   WriteByte( MSG_ONE, clientno );
   WriteString( MSG_ONE, clientname );
};

/*
==============================================================================
msgUpdateColorsToPlayer

sends an update client colors message to a player in the game
==============================================================================
*/

void( entity player, float clientno, float clientshirt, float clientpants ) msgUpdateColorsToPlayer =
{
   msgUpdateColorsToAll( clientno, clientshirt, clientpants );
   return;

   msg_entity = player;
   WriteByte( MSG_ONE, MSG_UPDATECOLORS );
   WriteByte( MSG_ONE, clientno );
   WriteByte( MSG_ONE, clientshirt * 16 + clientpants );
};

/*
==============================================================================
msgUpdateFragsToPlayer

sends an update client frags message to a player in the game
==============================================================================
*/

void( entity player, float clientno, float clientfrags ) msgUpdateFragsToPlayer =
{
   msgUpdateFragsToAll( clientno, clientfrags );
   return;

   msg_entity = player;
   WriteByte( MSG_ONE, MSG_UPDATEFRAGS );
   WriteByte( MSG_ONE, clientno );
   WriteShort( MSG_ONE, clientfrags );
};

/*
==============================================================================
msgUpdateNameToAll

sends an update client name message to all players in the game
==============================================================================
*/

void( float clientno, string clientname ) msgUpdateNameToAll =
{
   WriteByte( MSG_ALL, MSG_UPDATENAME );
   WriteByte( MSG_ALL, clientno );
   WriteString( MSG_ALL, clientname );
};

/*
==============================================================================
msgUpdateColorsToAll

sends an update client colors message to all players in the game
==============================================================================
*/

void( float clientno, float clientshirt, float clientpants ) msgUpdateColorsToAll =
{
   WriteByte( MSG_ALL, MSG_UPDATECOLORS );
   WriteByte( MSG_ALL, clientno );
   WriteByte( MSG_ALL, clientshirt * 16 + clientpants );
};

/*
==============================================================================
msgUpdateFragsToAll

sends an update client frags message to all players in the game
==============================================================================
*/

void( float clientno, float clientfrags ) msgUpdateFragsToAll =
{
   WriteByte( MSG_ALL, MSG_UPDATEFRAGS );
   WriteByte( MSG_ALL, clientno );
   WriteShort( MSG_ALL, clientfrags );
};


