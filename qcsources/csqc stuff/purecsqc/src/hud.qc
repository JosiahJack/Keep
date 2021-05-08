//fixme: needs to do intermission
//fixme: needs to do singleplyer +scores stuff

enumflags
{
	IT_WEAPON1	= 0x00001,
	IT_WEAPON2	= 0x00002,
	IT_WEAPON3	= 0x00004,
	IT_WEAPON4	= 0x00008,
	IT_WEAPON5	= 0x00010,
	IT_WEAPON6	= 0x00020,
	IT_WEAPON7	= 0x00040,
	IT_WEAPON8	= 0x00080,

	IT_AMMO1	= 0x00100,
	IT_AMMO2	= 0x00200,
	IT_AMMO3	= 0x00400,
	IT_AMMO4	= 0x00800,

	IT_WEAPON0	= 0x01000,

	IT_ARMOUR1	= 0x02000,
	IT_ARMOUR2	= 0x04000,
	IT_ARMOUR3	= 0x08000,
	IT_ARMOUR4	= 0x10000,

	IT_KEY1	= 0x20000,
	IT_KEY2	= 0x40000,
	IT_ARTIFACT1	= 0x80000,
	IT_ARTIFACT2	= 0x100000,
	IT_ARTIFACT3	= 0x200000,
	IT_ARTIFACT4	= 0x400000
};
enumflags
{
	IT2_RUNE1	= 0x020,
	IT2_RUNE2	= 0x040,
	IT2_RUNE3	= 0x080,
	IT2_RUNE4	= 0x100
};
var string number[10] = {
	"num_0",
	"num_1",
	"num_2",
	"num_3",
	"num_4",
	"num_5",
	"num_6",
	"num_7",
	"num_8",
	"num_9"
};
var string anumber[10] = {
	"anum_0",
	"anum_1",
	"anum_2",
	"anum_3",
	"anum_4",
	"anum_5",
	"anum_6",
	"anum_7",
	"anum_8",
	"anum_9"
};
var string facen[] =
{
	"face1",
	"face2",
	"face3",
	"face4",
	"face5"
};
var string faced[] =
{
	"face_p1",
	"face_p2",
	"face_p3",
	"face_p4",
	"face_p5"
};
var string facep[] =
{
	"face_invis",
	"face_invul2",
	"face_inv2",	//NOTE: NOT suit, but quad+pent instead
	"face_quad"
};
//for weapons, we generate the full names in our init function.
//here's the prefixes
//inv_ (active)
//inv2_ (owned)
//inva0..4_ (flashing)
var struct
{
	string state[7];
} weaponnames[] =
{
	{{"shotgun"}},
	{{"sshotgun"}},
	{{"nailgun"}},
	{{"snailgun"}},
	{{"rlaunch"}},
	{{"srlaunch"}},
	{{"lightng"}}
};
var string ammonames[] = {
	"sb_shells",
	"sb_nails",
	"sb_rocket",
	"sb_cells"
};
var string ammonames[] = {
	"sb_shells",
	"sb_nails",
	"sb_rocket",
	"sb_cells"
};
var string armournames[] = {
	"sb_armor1",
	"sb_armor2",
	"sb_armor3"
};
var string runenames[] =
{
	"sb_sigil1",
	"sb_sigil2",
	"sb_sigil3",
	"sb_sigil4"
};
var string itemnames[] =
{
	"sb_key1",
	"sb_key2",
	"sb_invis",
	"sb_invuln",
	"sb_suit",
	"sb_quad"
};
var string miscnames[] =
{
	"sbar",
	"ibar",
	"scorebar",
	"disc"
};
void() Hud_Init =
{
	float i, j;

	//pad out the weapon names, so our code isn't so ugly.
	//can't do this at run time because we may need to work around dp, and we want to precache things anyway.
	for (i = 0; i < sizeof(weaponnames)/sizeof(weaponnames[0]); i++)
	{
		string basic = weaponnames[i].state[0];
		weaponnames[i].state[0] = strzone(strcat("inv_", basic));
		weaponnames[i].state[1] = strzone(strcat("inv2_", basic));
		weaponnames[i].state[2] = strzone(strcat("inva1_", basic));
		weaponnames[i].state[3] = strzone(strcat("inva2_", basic));
		weaponnames[i].state[4] = strzone(strcat("inva3_", basic));
		weaponnames[i].state[5] = strzone(strcat("inva4_", basic));
		weaponnames[i].state[6] = strzone(strcat("inva5_", basic));
	}

	for (i = 0; i < sizeof(facen)/sizeof(facen[0]); i++)
	{
		precache_pic(facen[i], TRUE);
		precache_pic(faced[i], TRUE);
	}
	for (i = 0; i < sizeof(facep)/sizeof(facep[0]); i++)
		precache_pic(facep[i], TRUE);
	for (i = 0; i < sizeof(miscnames)/sizeof(miscnames[0]); i++)
		precache_pic(miscnames[i], TRUE);
	for (i = 0; i < sizeof(number)/sizeof(number[0]); i++)
	{
		precache_pic(number[i], TRUE);
		precache_pic(anumber[i], TRUE);
	}
	for (i = 0; i < sizeof(weaponnames)/sizeof(weaponnames[0]); i++)
	{
		for (j = 0; j < 7; j++)
			precache_pic(weaponnames[i].state[j], TRUE);
	}
	for (i = 0; i < sizeof(ammonames)/sizeof(ammonames[0]); i++)
		precache_pic(ammonames[i], TRUE);
	for (i = 0; i < sizeof(armournames)/sizeof(armournames[0]); i++)
		precache_pic(armournames[i], TRUE);
	for (i = 0; i < sizeof(itemnames)/sizeof(itemnames[0]); i++)
		precache_pic(itemnames[i], TRUE);

	precache_pic("num_colon", TRUE);
	precache_pic("num_slash", TRUE);
};

static vector screensize;
static float gottime[weaponnames.length], paintime;

static void(vector pos, float value, float threshhold) Hud_DrawLargeValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 24 * (3-len);
	

	if (value <= threshhold)
	{	//use alternate (red) numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '24 0 0', anumber[c-'0'], '24 24 0', '1 1 1', 1, 0);
		}
	}
	else
	{	//use normal numbers

		while(len>0)
		{
			len--;
			c = str2chr(s, len);

			drawpic(pos+len * '24 0 0', number[c-'0'], '24 24 0', '1 1 1', 1, 0);
		}
	}
};

static void(float value, vector pos, float drawback) Hud_DrawAmmoCount =
{
	string s;
	float len;
	float c;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	len = strlen(s);

	pos_x += 8 * (3-len);
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawcharacter(pos+len * '8 0 0', (18-'0') + c, '8 8 0', '1 1 1', 1, 0);
	}
};

static void(float num, vector pos) Hud_DrawWeapon =
{
	float st;
	st = floor((time - gottime[num])*10);	//10 fps
	if (st < 0)
		st = 2;//eep
	else if (st >= 10)
	{
		//we had the item for 10 frames
		if (self.weapon == pow(2, num))
			st = 1;
		else
			st = 0;
	}
	else if (st >= 5)
		st = st-5 + 2;
	else
		st = st+2;
	drawpic(pos, weaponnames[num].state[st], '24 16 0', '1 1 1', 1, 0);
};
static void(float num, vector pos) Hud_DrawWeaponWide	= //for LG
{
	float st;
	st = floor((time - gottime[num])*10);	//10 fps
	if (st < 0)
		st = 2;//eep
	else if (st >= 10)
	{
		//we had the item for 10 frames
		if (self.weapon == pow(2, num))
			st = 1;
		else
			st = 0;
	}
	else if (st >= 5)
		st = st-5 + 2;
	else
		st = st+2;
	drawpic(pos, weaponnames[num].state[st], '48 16 0', '1 1 1', 1, 0);
};

static void(vector pos) Hud_DrawFace =
{
	string face;
	//show powerups if needed
	if ((self.items & (IT_ARTIFACT2|IT_ARTIFACT4)) == (IT_ARTIFACT2|IT_ARTIFACT4))
		face = facep[2];	//this one is weird.
	else if (self.items & IT_ARTIFACT1)
		face = facep[0];
	else if (self.items & IT_ARTIFACT2)
		face = facep[1];
	else if (self.items & IT_ARTIFACT4)
		face = facep[3];
	else
	{	//regular faces
		float fr = floor((100 - self.health) / 20);
		if (fr < 0)
			fr = 0;
		if (fr > 4)
			fr = 4;
		if (paintime > time)	//taking damage
			face = faced[fr];
		else				//normal (possibly hurt) face
			face = facen[fr];
	}
	drawpic(pos, face, '24 24 0', '1 1 1', 1, 0);
};

static string(float f, float chars, string lead) FormatFloat =
{
	string s = ftos(f);
	if (f < 10 && chars >= 3)
		s = strcat(lead, lead, s);
	else if (f < 10 && chars == 2)
		s = strcat(lead, s);
	else if (f < 100 && chars >= 3)
		s = strcat(lead, s);
	return s;
};

void(vector pos) Hud_CoopScores_SBar =
{
	string s;
	float nsecs;
	float nmins;
	//When you press tab in single player/coop, you get some replacement info over the sbar
	drawpic(pos, miscnames[2], '320 24 0', '1 1 1', 0.333, 0);

	s = strcat("Monsters:", FormatFloat(getstatf(STAT_KILLEDMONSTERS), 3, " "), "/", FormatFloat(getstatf(STAT_TOTALMONSTERS), 3, " "));
	drawstring(pos + '8 4', s, '8 8 0', '1 1 1', 1, 0);
	s = strcat("Secrets :", FormatFloat(getstatf(STAT_FOUNDSECRETS), 3, " "), "/", FormatFloat(getstatf(STAT_TOTALSECRETS), 3, " "));
	drawstring(pos + '8 12', s, '8 8 0', '1 1 1', 1, 0);

	nmins = floor(time/60);
	nsecs = floor(time - nmins*60);
	s = strcat("Time :", FormatFloat(nmins, 3, " "), ":", FormatFloat(nsecs, 2, "0"));
	drawstring(pos + '184 4', s, '8 8 0', '1 1 1', 1, 0);

//	drawstring(pos + '232 12' - strlen(levelname)*'4 0', levelname, '8 8 0', '1 1 1', 1, 0);
};

void Hud_DrawSBar(vector pos)
{
	drawpic(pos, miscnames[0], '320 24 0', '1 1 1', 0.333, 0);

	if (self.items & IT_ARTIFACT2)
	{
		drawpic(pos, miscnames[3], '24 24 0', '1 1 1', 1, 0);
		Hud_DrawLargeValue(pos+'24 0 0', 666, 999);
	}
	else
	{
		Hud_DrawLargeValue(pos+'24 0 0', self.armorvalue, 25);
		if (self.items & IT_ARMOUR3)
			drawpic(pos, armournames[2], '24 24 0', '1 1 1', 1, 0);
		else if (self.items & IT_ARMOUR2)
			drawpic(pos, armournames[1], '24 24 0', '1 1 1', 1, 0);
		else if (self.items & IT_ARMOUR1)
			drawpic(pos, armournames[0], '24 24 0', '1 1 1', 1, 0);
	}

	Hud_DrawLargeValue(pos+'136 0 0', self.health, 25);

	if (self.items & IT_AMMO1)
		drawpic(pos+'224 0 0', ammonames[0], '24 24 0', '1 1 1', 1, 0);
	else if (self.items & IT_AMMO2)
		drawpic(pos+'224 0 0', ammonames[1], '24 24 0', '1 1 1', 1, 0);
	else if (self.items & IT_AMMO3)
		drawpic(pos+'224 0 0', ammonames[2], '24 24 0', '1 1 1', 1, 0);
	else if (self.items & IT_AMMO4)
		drawpic(pos+'224 0 0', ammonames[3], '24 24 0', '1 1 1', 1, 0);
	Hud_DrawLargeValue(pos+'248 0 0', self.currentammo, 10);

	Hud_DrawFace(pos + '112 0 0');
};

void Hud_DrawIBar(vector pos)
{
	drawpic(pos, miscnames[1], '320 24 0', '1 1 1', 0.333, 0);

	if (self.items & IT_WEAPON1)
		Hud_DrawWeapon(0, pos+'0 8 0');
	if (self.items & IT_WEAPON2)
		Hud_DrawWeapon(1, pos+'24 8 0');
	if (self.items & IT_WEAPON3)
		Hud_DrawWeapon(2, pos+'48 8 0');
	if (self.items & IT_WEAPON4)
		Hud_DrawWeapon(3, pos+'72 8 0');
	if (self.items & IT_WEAPON5)
		Hud_DrawWeapon(4, pos+'96 8 0');
	if (self.items & IT_WEAPON6)
		Hud_DrawWeapon(5, pos+'120 8 0');
	if (self.items & IT_WEAPON7)
		Hud_DrawWeaponWide(6, pos+'144 8 0');

	Hud_DrawAmmoCount(self.ammo_shells, pos + '10 0 0', FALSE);
	Hud_DrawAmmoCount(self.ammo_nails, pos + '58 0 0', FALSE);
	Hud_DrawAmmoCount(self.ammo_rockets, pos + '106 0 0', FALSE);
	Hud_DrawAmmoCount(self.ammo_cells, pos + '154 0 0', FALSE);

	if (self.items & IT_KEY1)
		drawpic(pos+'192 8 0', itemnames[0], '16 16 0', '1 1 1', 1, 0);
	if (self.items & IT_KEY2)
		drawpic(pos+'208 8 0', itemnames[1], '16 16 0', '1 1 1', 1, 0);
	if (self.items & IT_ARTIFACT1)
		drawpic(pos+'224 8 0', itemnames[2], '16 16 0', '1 1 1', 1, 0);
	if (self.items & IT_ARTIFACT2)
		drawpic(pos+'240 8 0', itemnames[3], '16 16 0', '1 1 1', 1, 0);
	if (self.items & IT_ARTIFACT3)
		drawpic(pos+'256 8 0', itemnames[4], '16 16 0', '1 1 1', 1, 0);
	if (self.items & IT_ARTIFACT4)
		drawpic(pos+'272 8 0', itemnames[5], '16 16 0', '1 1 1', 1, 0);

	if (serverflags & 1)
		drawpic(pos+'288 8 0', runenames[0], '8 16 0', '1 1 1', 1, 0);
	if (serverflags & 2)
		drawpic(pos+'296 8 0', runenames[1], '8 16 0', '1 1 1', 1, 0);
	if (serverflags & 4)
		drawpic(pos+'304 8 0', runenames[2], '8 16 0', '1 1 1', 1, 0);
	if (serverflags & 8)
		drawpic(pos+'312 8 0', runenames[3], '8 16 0', '1 1 1', 1, 0);
};

static float PointWithinBox(vector bmin, vector bsize, vector point)
{
	if (point_x < bmin_x || point_x >= bmin_x+bsize_x)
		return FALSE;
	if (point_y < bmin_y || point_y >= bmin_y+bsize_y)
		return FALSE;
	return TRUE;
};

static void(vector pos, float playerslot) drawfrags =
{
	string s = getplayerkeyvalue(playerslot, "frags");
	if not (s)	//if the frags field is empty, then assume the slot is empty
		return;

	drawfill(pos, '32 4', stov(getplayerkeyvalue(playerslot, "topcolor_rgb")), 1, 0);
	drawfill(pos + '0 4 0', '32 4', stov(getplayerkeyvalue(playerslot, "bottomcolor_rgb")), 1, 0);
	drawcharacter(pos, 0xe010, '8 8', '1 1 1', 1, 0);
	drawcharacter(pos+'24 0 0', 0xe011, '8 8', '1 1 1', 1, 0);

	float frags = stof(s);
	if (frags < -99)
		frags = -99;	//hrm
	if (frags>999)
		frags = 999;

	s = ftos(floor(frags));
	float len = strlen(s);

	pos_x += 8 * (3-len);
	while(len>0)
	{
		len--;
		float c = str2chr(s, len);
		drawcharacter(pos+len * '8 0 0', (18-'0') + c, '8 8 0', '1 1 1', 1, 0);
	}
};


static void(vector pos, float value, float rightalign, float pad) Hud_DrawIntermissionValue =
{
	float c;
	float len;
	string s;
	if (value < 0)
		value = 0;	//hrm
	if (value>999)
		value = 999;

	s = ftos(floor(value));
	if (pad && value < 10)
		s = strcat("0", s);
	len = strlen(s);
	if (rightalign)
		pos_x -= 24 * len;
	while(len>0)
	{
		len--;
		c = str2chr(s, len);
		drawpic(pos+len * '24 0 0', number[c-'0'], '24 24 0', '1 1 1', 1, 0);
	}
};
void Hud_DrawIntermission(vector ssize)
{
	screensize = ssize;
	vector tl;
	float mins;
	float secs;
	tl = (ssize-'320 240 0') * 0.5;

	drawpic(tl + '64 24', "gfx/complete.lmp", '192 24 0', '1 1 1', 1, 0);
	drawpic(tl + '0 56', "gfx/inter.lmp", '160 144 0', '1 1 1', 1, 0);

	mins = floor(completed_time/60);
	secs = completed_time - mins*60;
	Hud_DrawIntermissionValue(tl+'230 64 0', mins, TRUE, FALSE);
	drawpic(tl + '230 64', "num_colon", '16 24 0', '1 1 1', 1, 0);
	Hud_DrawIntermissionValue(tl+'254 64 0', secs, FALSE, TRUE);

	Hud_DrawIntermissionValue(tl+'230 104 0', found_secrets, TRUE, FALSE);
	drawpic(tl + '230 104', "num_slash", '16 24 0', '1 1 1', 1, 0);
	Hud_DrawIntermissionValue(tl+'254 104 0', total_secrets, FALSE, FALSE);

	Hud_DrawIntermissionValue(tl+'230 144 0', killed_monsters, TRUE, FALSE);
	drawpic(tl + '230 144', "num_slash", '16 24 0', '1 1 1', 1, 0);
	Hud_DrawIntermissionValue(tl+'254 144 0', total_monsters, FALSE, FALSE);
};

nonstatic void Hud_Draw(float scoreboard, float width, float height)
{
	static float oitems;
	static float ohealth;
	vector pos;

	screensize = [width, height];
	pos = [(screensize_x-320)/2, screensize_y];

	//use the pain-face animation within the 0.2 secs of getting hurt.
	if (self.health < ohealth)
		paintime = time + 0.2;

	//detect what time things were obtained, so we can flash (no flashing before 9pm!)
	oitems = self.items & ~oitems;
	if (oitems)
	{
		float i;
		for (i = 0; i < sizeof(gottime)/sizeof(gottime[0]); i++)
			if (oitems & pow(2,i))
				gottime[i] = time;
	}

	if (scoreboard)
	{
		Hud_CoopScores_SBar(pos - '0 24 0');
	}
	else
	{
		Hud_DrawSBar(pos - '0 24 0');
	}
	Hud_DrawIBar(pos - '0 48 0');

	if (scoreboard)
	{
		vector size = drawgetimagesize("gfx/ranking.lmp");
		pos = '0 0 0';
		drawpic(pos - [(screensize_x-size_x)*0.5,0,0], "gfx/ranking.lmp", size, '1 1 1', 1, 0);
		pos_y += size_y;
		drawfrags(pos, -1); pos_y += 8;
		drawfrags(pos, -2); pos_y += 8;
		drawfrags(pos, -3); pos_y += 8;
	}

	oitems = self.items;
	ohealth = self.health;
};

float HUD_Click(float isdown, float key, vector mpos)
{
	vector pos = [(screensize_x-320)/2, screensize_y];

	//sbar+ibar region
	if (PointWithinBox(pos - '0 48 0', '320 24 0', mpos))
	{
		//weapon row
		if (PointWithinBox(pos - '0 40 0', '320 16 0', mpos))
		{
			float slot = 0;
			if (mpos_x - pos_x > 8*24)
				if (mpos_x - pos_x > 8*24 + 6*16)
					slot = ((mpos_x - pos_x) - (8*24 + 6*16))/8 + 16;
				else
					slot = ((mpos_x - pos_x) - (8*24))/16 + 10;
			else
				slot = ((mpos_x - pos_x))/24 + 2;
			slot = floor(slot);

			if (isdown)
				localcmd(sprintf("impulse %g\n", slot));
		}
		return isdown;
	}
	return FALSE;
};
