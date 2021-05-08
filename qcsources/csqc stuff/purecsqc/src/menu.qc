/*
This is a really basic crappy chunk of menu code.
The reason its so crappy is because people seem to run in terror when I show them
code with lots of classes and abstractions and all sorts of other things hidden in lots of 
code files that they shouldn't really need to read in the first place.
Okay, it would help if I wrote some documentation once in a while, but that's not the point.

This menu is intended to be simple, straight forward, and self contained.
Everything it needs is directly here without hiding it in classes or #defines.
If you want click+drag, mouse, etc, bug me to polish+release my menusys code, or write your owner.
*/

float menustate;
const float MENU_NONE = 0;
const float MENU_MAIN = 1;
const float MENU_MULTI = 2;
const float MENU_HELP = 3;
const float MENU_BIND = 4;
//I should add an options menu to give an example of checkboxes/sliders
//graphics presets intead of the built-in options menu helps avoid people running in fear.

//forward declare these so I can put the main menu first. because people should start at the start.
void() M_Main_Open;
void() M_Multi_Open;
void() M_Help_Open;
void() M_Bind_Open;

/*
=========================
The main menu
*/
float m_main_option;
void() M_Main_Open =
{
	sound(world, CHAN_AUTO, "menu/menu2.wav", 1, 0);
	menustate = MENU_MAIN;
};
void() M_Main_Draw =
{
	//find the middle 320*200 of the screen, and center upon that
	vector min = (getviewprop(VF_SCREENVSIZE) - '320 200')*0.5;
	//branding art
	drawpic(min+'16 4', "gfx/qplaque.lmp", '32 144', '1 1 1', 1, 0);

	//title art
	drawpic(min+'112 4', "gfx/ttl_main.lmp", '96 24', '1 1 1', 1, 0);

	//options are a single image
	drawpic(min+'72 32', "gfx/mainmenu.lmp", '240 112', '1 1 1', 1, 0);
	//and custom junk at the bottom
	drawstring(min+'72 132', "^aBinds", '20 20', '1 1 1', 1, 0);

	//draw cursor
	float cframe = floor(time*10);
	cframe = cframe - floor(cframe/6)*6;
	string cursor = sprintf("gfx/menudot%g.lmp", 1 + cframe);
	drawpic(min+'54 32' + '0 20'*m_main_option, cursor, '20 20', '1 1 1', 1, 0);
};
float(float scan) M_Main_Key =
{
	if (scan == K_ESCAPE)
	{
		menustate = MENU_NONE;
		sound(world, CHAN_AUTO, "menu/menu1.wav", 1, 0);
	}
	else if (scan == K_UPARROW)
	{
		m_main_option -= 1;
		if (m_main_option < 0)
			m_main_option += 6;
		sound(world, CHAN_AUTO, "menu/menu1.wav", 1, 0);
	}
	else if (scan == K_DOWNARROW)
	{
		m_main_option += 1;
		if (m_main_option >= 6)
			m_main_option -= 6;
		sound(world, CHAN_AUTO, "menu/menu1.wav", 1, 0);
	}
	else if (scan == K_ENTER)
	{
		switch(m_main_option)
		{
		case 0:	localcmd("menu_single\n");	break;
		case 1:	M_Multi_Open();			break;
		case 2:	localcmd("menu_options\n");	break;
		case 3:	M_Help_Open();				break;
		case 4:	localcmd("menu_quit\n");		break;
		case 5:	M_Bind_Open();				break;
		}
	}
	else
		return FALSE;
	return TRUE;
};

/*
=========================
crappy multiplayer menu. because multiplayer is supported, right?..
*/
void() M_Multi_Open =
{
	sound(world, CHAN_AUTO, "menu/menu2.wav", 1, 0);
	menustate = MENU_MULTI;
};
void() M_Multi_Draw =
{
	vector min = (getviewprop(VF_SCREENVSIZE) - '320 200')*0.5;
	drawstring(min+'0 0', "^aSorry,^a\r\n"
					"This is Pure CSQC\r\n"
					"There is no multiplayer support\r\n"
					"Try irc if you really want to be sociable", '8 8', '1 1 1', 1, 0);
};
float(float scan) M_Multi_Key =
{
	if (scan == K_ESCAPE)
		menustate = MENU_MAIN;
	else
		return FALSE;
	return TRUE;
};

/*
=========================
crappy help menu.
*/
float m_help_option;
void() M_Help_Open =
{
	sound(world, CHAN_AUTO, "menu/menu2.wav", 1, 0);
	menustate = MENU_HELP;
};
void() M_Help_Draw =
{
	vector min = (getviewprop(VF_SCREENVSIZE) - '320 200')*0.5;
	drawpic(min+'0 0', sprintf("gfx/help%g.lmp", m_help_option), '320 200', '1 1 1', 1, 0);
};
float(float scan) M_Help_Key =
{
	if (scan == K_ESCAPE)
		menustate = MENU_MAIN;
	else if (scan == K_LEFTARROW || scan == K_UPARROW)
	{
		m_help_option-=1;
		if (m_help_option < 0)
			m_help_option += 6;
	}
	else if (scan == K_RIGHTARROW || scan == K_DOWNARROW)
	{
		m_help_option+=1;
		if (m_help_option >= 6)
			m_help_option -= 6;
	}
	else
		return FALSE;
	return TRUE;
};

/*
=========================
crappy binds menu.
*/
struct {
	string desc;
	string cmd;
} bindlist[] =
{
	{"Attack", "+attack"},
	{"Next Weapon", "impulse 10"},
	{"Prev Weapon", "impulse 12"},
	{"Jump", "+jump"},
	{"Forward", "+forward"},
	{"Back", "+back"},
	{"Right", "+moveright"},
	{"Left", "+moveleft"},
	{"Turn Right", "+right"},
	{"Turn Wrong", "+left"},
	{"Voip", "+voip"}
};
float m_bind_option;
float m_bind_grab;	//true if we're currently trying to grab a key to bind
void() M_Bind_Open =
{
	sound(world, CHAN_AUTO, "menu/menu2.wav", 1, 0);
	menustate = MENU_BIND;
	m_bind_grab = FALSE;	//just in case
};
void() M_Bind_Draw =
{
	vector min = (getviewprop(VF_SCREENVSIZE) - '320 200')*0.5;

	float i;
	for (i = 0; i < bindlist.length; i++)
	{
		if (m_bind_option == i)
			drawstring(min, strcat("^a", bindlist[i].desc), '8 8', '1 1 1', 1, 0);
		else
			drawstring(min, bindlist[i].desc, '8 8', '1 1 1', 1, 0);


		tokenize(findkeysforcommand(bindlist[i].cmd));
		string key1 = argv(0);
		string key2 = argv(1);
		if (key1 != "") key1 = (key1=="-1")?"":keynumtostring(stof(key1));
		if (key2 != "") key2 = (key2=="-1")?"":keynumtostring(stof(key2));
		string line;
		if (key1 != "" && key2 != "")
			line = strcat(key1, " or ", key2);
		else if (key1 != "")
			line = key1;
		else if (key2 != "")
			line = key2;
		else
			line = "nothing";
		if (m_bind_option == i)
		{
			if (m_bind_grab)
				line = "<PRESS A KEY>";
			else
				line = strcat("^a", line);
		}
		drawstring(min+'160 0', line, '8 8', '1 1 1', 1, 0);
		min_y += 8;
	}
};
float(float scan) M_Bind_Key =
{
	if (m_bind_grab)
	{
		m_bind_grab = FALSE;
		if (scan != K_ESCAPE)
			localcmd(sprintf("bind \"%s\" \"%s\"\n", keynumtostring(scan), bindlist[m_bind_option].cmd));
		return TRUE;
	}

	if (scan == K_ESCAPE)
		menustate = MENU_MAIN;
	else if (scan == K_LEFTARROW || scan == K_UPARROW)
	{
		m_bind_option-=1;
		if (m_bind_option < 0)
			m_bind_option += bindlist.length;
	}
	else if (scan == K_RIGHTARROW || scan == K_DOWNARROW)
	{
		m_bind_option+=1;
		if (m_bind_option >= (float)bindlist.length)
			m_bind_option -= (float)bindlist.length;
	}
	else if (scan == K_DEL || scan == K_BACKSPACE)
	{
		//unbind the first key we see.
		//too lazy to unbind both.
		//and helps work around people bitching about the bind menu not working to accept more keys, when it merely doesn't display them.
		tokenize(findkeysforcommand(bindlist[m_bind_option].cmd));
		string key1 = argv(0);
		if (key1 != "") key1 = (key1=="-1")?"":keynumtostring(stof(key1));
		if (key1 != "")
			localcmd(sprintf("unbind \"%s\"\n", key1));
	}
	else if (scan == K_ENTER)
		m_bind_grab = TRUE;
	else
		return FALSE;
	return TRUE;
};

/*
=========================
Menu selection junk
Just invokes the relevent function instead.
*/
void() Menu_Init =
{
	registercommand("togglemenu");
	registercommand("csmenu_main");	//csqc isn't allowed to replace most engine commands
	registercommand("csmenu_multi");
	registercommand("csmenu_help");
	registercommand("csmenu_binds");
};
float(string cmd) Menu_Cmd =
{
	switch(cmd)
	{
	default: return FALSE;
	case "togglemenu":
	case "csmenu_main": M_Main_Open(); break;
	case "csmenu_multi": M_Multi_Open(); break;
	case "csmenu_help": M_Help_Open(); break;
	case "csmenu_binds": M_Bind_Open(); break;
	}
	return TRUE;
};
//draws whichever menu is active.
void() Menu_Draw =
{
	switch(menustate)
	{
	default:
	case MENU_NONE:	return;
	case MENU_MAIN:	M_Main_Draw(); break;
	case MENU_MULTI:	M_Multi_Draw(); break;
	case MENU_HELP:	M_Help_Draw(); break;
	case MENU_BIND:	M_Bind_Draw(); break;
	}
};
//dispatches the key to whichever menu is active.
//returns false if it should be handled by the game/engine.
float(float scan) Menu_Key =
{
	switch(menustate)
	{
	default:
		return FALSE;
	case MENU_MAIN:	M_Main_Key(scan); break;
	case MENU_MULTI:	M_Multi_Key(scan); break;
	case MENU_HELP:	M_Help_Key(scan); break;
	case MENU_BIND:	M_Bind_Key(scan); break;
	}
	return TRUE;
};
 