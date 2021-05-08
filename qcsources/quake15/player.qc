
void() bubble_bob;

/*
==============================================================================

PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base		
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6

//fatalities

$frame melt1 melt2 melt3 melt4 melt5 melt6 melt7 melt8 melt9 //new melting anim
$frame melt10 melt11 melt12 melt13 melt14 melt15 melt16 melt17
$frame melt18

$frame ssgdeath1 ssgdeath2 ssgdeath3 ssgdeath4 ssgdeath5 ssgdeath6 ssgdeath7 ssgdeath8 ssgdeath9
$frame ssgdeath10 ssgdeath11 ssgdeath12 ssgdeath13 ssgdeath14 ssgdeath15

$frame axde1 axde2 axde3 axde4 axde5 axde6 axde7 axde8 axde9 axde10 axde11 axde12 axde13 axde14

$frame naildth1 naildth2 naildth3 naildth4 naildth5 naildth6 naildth7 naildth8
$frame naildth9 naildth10 naildth11 naildth12 naildth13 naildth14 naildth15 naildth16 naildth17

$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7

$frame swimax1 swimax2 swimax3 swimax4 swimax5 swimax6 swimax7

$frame swimsh1 swimsh2 swimsh3 swimsh4 swimsh5 swimsh6

$frame swimaxat1 swimaxat2 swimaxat3 swimaxat4 swimaxat5 swimaxat6

$frame kick1 kick2 kick3 kick4 kick5

$frame kickax1 kickax2 kickax3 kickax4 kickax5

$frame axjump1 axjump2 axjump3 axjump4

$frame jump1 jump2 jump3 jump4 jump5 jump6

/*
==============================================================================
PLAYER
==============================================================================
*/


void(entity e, float waterwalk) walksound ={
	local float surfnum, r;
	local string s;

	makevectors(e.v_angle);


	surfnum = getsurfacenearpoint(world, e.origin - '0 0 24');
	if (vlen(self.velocity) < 100)
		return;

	if (surfnum >= 0)
	{
		
		s = getsurfacetexture(world, surfnum);
		if (waterwalk == 0)
		{
			if (returnsurface(s) == GROUND || returnsurface(s) == ROCK)
			{
				r = rint(random() * 3);			
				if (r == 0)
				sound7(e, CHAN_AUTO, "walk/pl_dirt1.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 1)
					sound7(e, CHAN_AUTO, "walk/pl_dirt2.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 2)
					sound7(e, CHAN_AUTO, "walk/pl_dirt3.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else
					sound7(e, CHAN_AUTO, "walk/pl_dirt4.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
			}
			else if (returnsurface(s) == METAL)
			{
				r = rint(random() * 3);			
				if (r == 0)
					sound7(e, CHAN_AUTO, "walk/metal1.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 1)
					sound7(e, CHAN_AUTO, "walk/metal2.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 2)
					sound7(e, CHAN_AUTO, "walk/metal3.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else
					sound7(e, CHAN_AUTO, "walk/metal4.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
			}
			else if (returnsurface(s) == MEAT)
			{
				r = rint(random() * 3);			
				if (r == 0)
					sound7(e, CHAN_AUTO, "custom/flesh1.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 1)
					sound7(e, CHAN_AUTO, "custom/flesh5.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 2)
					sound7(e, CHAN_AUTO, "custom/flesh3.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else
					sound7(e, CHAN_AUTO, "custom/flesh4.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
			}
			else
			{
				r = rint(random() * 4);			
				if (r == 0)
					sound7(e, CHAN_AUTO, "walk/generic1.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 1)
					sound7(e, CHAN_AUTO, "walk/generic2.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 2)
					sound7(e, CHAN_AUTO, "walk/generic3.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else if (r == 3)
					sound7(e, CHAN_AUTO, "walk/generic4.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
				else
					sound7(e, CHAN_AUTO, "walk/generic5.wav", autocvar_playerfootsteps, ATTN_NORM, SNDSPD);
			}
		}
		else
		{
			if (random() < 0.65)
				sound7(e, CHAN_AUTO, "walk/waterwade1.wav", 0.7, ATTN_NORM, SNDSPD);
			else
				sound7(e, CHAN_AUTO, "walk/waterwade2.wav", 0.7, ATTN_NORM, SNDSPD);
		}
	}
};

void() player_run;
void() player_swim;

/*void(float plr) playerMdlSwap =
{
	if (plr == 1 && self.health > 0)
		setmodel(self, "progs/player_add.mdl");
	else
		setmodel(self, "progs/player.mdl");
	modelindex_player = self.modelindex;
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
}; */

void()	player_stand1 =[	$axstnd1,	player_stand1	]
{	
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		player_run();
		return;
	}
	
	if (self.weapon == IT_CHAINSAW)
	{
		self.weaponframe = self.weaponframe + 1;
		if(self.weaponframe >= 5)
		{
			self.weaponframe = 0;
			if (self.view_ofs != '0 0 0')
				sound7 (self, CHAN_WEAPON, "weapons/sawridle.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		}
		if (self.weaponframe == 0 || self.weaponframe == 2 || self.weaponframe == 4)
			self.punchangle_x = -.5;
		if (self.walkframe >= 5)
			self.walkframe = 0;
		if (self.waterlevel >= 2) //Swim animation check, kept out of the swim frames to prevent redundant code (although it's a little late for that lol)
		{
			self.frame = $swim1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		else if (!(self.flags & FL_ONGROUND))
		{
			self.frame = $jump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.walkframe >= 5)
				self.walkframe = 4;
		}
		else
		{
			self.frame = $stand1 + self.walkframe;
			self.walkframe = self.walkframe + 1;	
		}
		return;
	}
	
	if (self.weapon == IT_SUPER_NAILGUN && self.spindown == 1)
	{
		//self.weaponframe = 10;
		self.weaponframe++;
		if(self.weaponframe < 10)
			self.weaponframe = 10;
		self.spintimer++;
		if(self.weaponframe >= 19)
			self.weaponframe = 1;
		if(self.spintimer >= 9)
		{
			sound7 (self, CHAN_WEAPON, "weapons/spikespn.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
			self.weapontimer = 0;
			self.spindown = 0;
		}
		if (self.walkframe == 5)
			self.walkframe = 0;
		if (self.waterlevel >= 2)
		{
			self.frame = $swim1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		else if (!(self.flags & FL_ONGROUND))
		{
			if (self.walkframe >= 5)
				self.walkframe = 4;
			self.frame = $jump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		else
		{
			self.frame = $stand1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		return;
	}
	
	if (self.weapon == IT_ROCKET_LAUNCHER && self.weaponframe >= 6)
	{
			self.weaponframe++;
			if (self.weaponframe ==8)
				sound7(self, CHAN_AUTO, "weapons/rockload.wav", 1, ATTN_NORM, SNDSPD);
			if (self.weaponframe >=9)
				self.weaponframe=0;
	}
	
	if (autocvar_mage_weapon) 
	{
		if (self.weapon != IT_LIGHTNING)
			self.weaponframe=0;
	}
	else if (self.weapon != IT_ROCKET_LAUNCHER)
		self.weaponframe=0;
		
	if (self.waterlevel >= 2)
	{
		//self.walkframe=0;
		player_swim();
		return;
	}
	if (self.weapon == IT_LIGHTNING)
	{
		self.weapontimer++;
		if(self.weapontimer == 7)
		{
			sound7(self, CHAN_AUTO, "weapons/lg_hum.wav", .7, ATTN_NORM, SNDSPD);
			self.weapontimer = 0;
		}
			
	}
	
	if (!(self.flags & FL_ONGROUND) && (self.weapon != IT_AXE))
	{
			self.frame = $jump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.walkframe >= 6)
				self.walkframe = 5;
			self.weaponframe=0;
			return;
	}

	if (self.weapon == IT_AXE)
	{
		if (!(self.flags & FL_ONGROUND))
		{
			self.frame = $axjump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.walkframe >= 5)
			{
				self.walkframe = 4;
				self.frame = $axjump4;
			}
			return;
		}
		if (self.walkframe >= 12)
			self.walkframe = 0;
		self.frame = $axstnd1 + self.walkframe;
	}
	else
	{
		if (self.walkframe >= 5)
			self.walkframe = 0;
		self.frame = $stand1 + self.walkframe;
	}
	self.walkframe = self.walkframe + 1;	
};

void() player_swim =[ 	$swim1,		player_swim	]
{
	if (self.weapon == IT_ROCKET_LAUNCHER && self.weaponframe >= 6)
	{
			self.weaponframe++;
			if (self.weaponframe ==8)
				sound7(self, CHAN_AUTO, "weapons/rockload.wav", 1, ATTN_NORM, SNDSPD);
			if (self.weaponframe >=9)
				self.weaponframe=0;
		//	self.walkframe = self.walkframe + 1;
			//return;
	}
	else
		self.weaponframe=0;
		
	if (self.waterlevel >= 2)
	{
		if (self.walkframe == 7)
			self.walkframe = 0;
		if (self.weapon == IT_AXE)
			self.frame = $swimax1 + self.walkframe;
		else
			self.frame = $swim1 + self.walkframe;
		
		self.walkframe = self.walkframe + 1;
	}
	else
	{
		//setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		self.walkframe=0;
		player_stand1();
		return;
	}
};

void()	player_run =[	$rockrun1,	player_run	]	
{
	self.meleeing = 0;
	if (self.throwing == 1)
	{
		self.weaponframe = 0;
		self.throwing = 0;
	}
	if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe=0;
		player_stand1();
		return;
	}
	/*if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe=0;
		player_stand1();
		return;
	}*/
	
	
	if (self.weapon == IT_CHAINSAW)
	{
		self.weaponframe = self.weaponframe + 1;
		if(self.weaponframe >= 5)
		{
			self.weaponframe = 0;
			if (self.view_ofs != '0 0 0')
				sound7 (self, CHAN_WEAPON, "weapons/sawridle.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		}
		if (self.weaponframe == 0 || self.weaponframe == 2 || self.weaponframe == 4)
			self.punchangle_x = -.4;
		if (self.walkframe == 6)
			self.walkframe = 0;
		if (self.waterlevel >= 2)
		{
			self.frame = $swim1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		else if (!(self.flags & FL_ONGROUND))
		{
			self.frame = $jump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.walkframe >= 5)
				self.walkframe = 4;
		}
		else
		{
			self.frame = $rockrun1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		return;
	}
	if (self.weapon == IT_SUPER_NAILGUN && self.spindown == 1)
	{
		
		//self.weaponframe = 10;
		self.weaponframe++;
		if(self.weaponframe < 10)
			self.weaponframe = 10;
		self.spintimer++;
		if(self.weaponframe >= 19)
			self.weaponframe = 1;
		if(self.spintimer >= 9)	//TURN OFF spin anim and play click sound
		{
			sound7 (self, CHAN_WEAPON, "weapons/spikespn.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
			self.weapontimer = 0;
			self.spindown = 0;
		}
		if (self.walkframe == 6)
			self.walkframe = 0;
		if (self.waterlevel >= 2)
		{
			self.frame = $swim1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		else if (!(self.flags & FL_ONGROUND))
		{
			self.frame = $jump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.walkframe >= 5)
				self.walkframe = 4;
		}
		else
		{
			self.frame = $rockrun1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
		}
		return;
	}
	if (self.weapon == IT_ROCKET_LAUNCHER && self.weaponframe >= 6)
	{
			self.weaponframe++;
			if (self.weaponframe ==8)
				sound7(self, CHAN_AUTO, "weapons/rockload.wav", 1, ATTN_NORM, SNDSPD);
			if (self.weaponframe >=9)	
				self.weaponframe=0;
		//	self.walkframe = self.walkframe + 1;
			//return;
	}
	
	
	if (self.waterlevel >= 2)
	{
		//self.walkframe=0;
		player_swim();
		return;
	}
	
	if ((self.waterlevel == 0) && (autocvar_playerfootsteps))
	{
		if (checkbottom(self) == TRUE)
		{
			if (self.walkframe == 1 || self.walkframe == 4 )
				walksound(self, 0);
		}
	}
	else if ((self.waterlevel == 1 || self.waterlevel == 2) && (autocvar_waterwalk_and_swim_sound))
	{
		if (self.walkframe == 1)
		{
			if (autocvar_waterwalk_and_swim_sound >= 2)	// if 'waterwalk_and_swim_sound' is set to "2", also play watersound when swimming
				walksound(self, 1);
			else						// if 'waterwalk_and_swim_sound' is set to '1' do NOT play watersound when swimming
			{
				if (checkbottom(self) == TRUE)
					walksound(self, 1);
			}
		}
	}
	if (self.weapon == IT_LIGHTNING)
	{
		self.weapontimer++;
		if(self.weapontimer == 7)
		{
			sound7(self, CHAN_AUTO, "weapons/lg_hum.wav", .7, ATTN_NORM, SNDSPD);
			self.weapontimer = 0;
		}
			
	}
	if (!(self.flags & FL_ONGROUND) && (self.weapon != IT_AXE))
	{
			if (self.walkframe >= 6)
				self.walkframe = 5;
			self.frame = $jump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.weapon == IT_ROCKET_LAUNCHER && self.weaponframe >= 6)
			{
				self.weaponframe++;
				if (self.weaponframe ==8)
					sound7(self, CHAN_AUTO, "weapons/rockload.wav", 1, ATTN_NORM, SNDSPD);
				if (self.weaponframe >=9)	
					self.weaponframe=0;
			//	self.walkframe = self.walkframe + 1;
				//return;
			}
			else
				self.weaponframe=0;
			return;
	}
	

	if (autocvar_mage_weapon) 
	{
		if (self.weapon != IT_LIGHTNING)
			self.weaponframe=0;
	}
	else if (self.weapon != IT_ROCKET_LAUNCHER)
		self.weaponframe=0;
		

	if (self.weapon == IT_AXE)
	{
		if (!(self.flags & FL_ONGROUND))
		{
			self.frame = $axjump1 + self.walkframe;
			self.walkframe = self.walkframe + 1;
			if (self.walkframe >= 5)
			{
				self.walkframe = 4;
				self.frame = $axjump4;
			}
			return;
		}
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = $axrun1 + self.walkframe;
	}
	else
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = self.frame + self.walkframe;
	}
	
	self.walkframe = self.walkframe + 1;
};


void()	player_shot1 =	[$shotatt1, player_shot2	] {self.weaponframe=1;
self.effects = self.effects | EF_MUZZLEFLASH;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 0))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
		
	
	
	}
};
void()	player_shot2 =	[$shotatt2, player_shot3	] {self.weaponframe=2;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	
	
	}
};
void()	player_shot3 =	[$shotatt3, player_shot4	] {self.weaponframe=3;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 2))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shot4 =	[$shotatt4, player_shot5	] {self.weaponframe=4;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 3))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
		
		
	}
};
void()	player_shot5 =	[$shotatt5, player_shot6	] {self.weaponframe=5;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 4))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
		
	if (self.weapon == IT_SHOTGUN && autocvar_shotgun_cycle_fix && self.button0)
		self.nextthink = time + 0.002;
		
	}
};
void()	player_shot6 =	[$shotatt6, player_run	] {self.weaponframe=6;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 5))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	
		
	}
};

void()	player_shotswim1 =	[$swimsh1, player_shotswim2	] 
{
	//if (self.waterlevel >= 2)
	//{
		self.weaponframe=1;
		self.effects = self.effects | EF_MUZZLEFLASH;
		if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 0))
			{
			casing (0);
			if (self.weapon == IT_SUPER_SHOTGUN)
				casing (0);
			}
	//}
	//else
		//return;
};
void()	player_shotswim2 =	[$swimsh2, player_shotswim3	] {self.weaponframe=2;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shotswim3 =	[$swimsh3, player_shotswim4	] {self.weaponframe=3;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shotswim4 =	[$swimsh4, player_shotswim5	] {self.weaponframe=4;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shotswim5 =	[$swimsh5, player_shotswim6	] {self.weaponframe=5;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};
void()	player_shotswim6 =	[$swimsh6, player_swim		] {self.weaponframe=6;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe == 1))
	{
	casing (0);
	if (self.weapon == IT_SUPER_SHOTGUN)
		casing (0);
	}
};

void()	player_axe1 =	[$axatt1, player_axe2	] {self.weaponframe=1;};
void()	player_axe2 =	[$axatt2, player_axe3	] {self.weaponframe=2;self.punchangle_x = 3;self.punchangle_y = -1;};
void()	player_axe3 =	[$axatt3, player_axe4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axe4 =	[$axatt4, player_run	] {self.weaponframe=4;};

void()	player_axeb1 =	[$axattb1, player_axeb2	] {self.weaponframe=5;};
void()	player_axeb2 =	[$axattb2, player_axeb3	] {self.weaponframe=6;self.punchangle_x = .2;self.punchangle_y = 3;};
void()	player_axeb3 =	[$axattb3, player_axeb4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axeb4 =	[$axattb4, player_run	] {self.weaponframe=8;};

void()	player_axec1 =	[$axattc1, player_axec2	] {self.weaponframe=1;};
void()	player_axec2 =	[$axattc2, player_axec3	] {self.weaponframe=2;self.punchangle_x = 3;self.punchangle_y = -1;};
void()	player_axec3 =	[$axattc3, player_axec4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axec4 =	[$axattc4, player_run	] {self.weaponframe=4;};

void()	player_axed1 =	[$axattd1, player_axed2	] {self.weaponframe=5;};
void()	player_axed2 =	[$axattd2, player_axed3	] {self.weaponframe=6;self.punchangle_x = .2;self.punchangle_y = 5;};
void()	player_axed3 =	[$axattd3, player_axed4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axed4 =	[$axattd4, player_run	] {self.weaponframe=8;};

void()	player_axes1 =	[$swimaxat1, player_axes2	] {self.weaponframe=1;};
void()	player_axes2 =	[$swimaxat3, player_axes3	] {self.weaponframe=2;};
void()	player_axes3 =	[$swimaxat4, player_axes4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axes4 =	[$swimaxat6, player_swim	] {self.weaponframe=4;};

//Chainsaw anims

void() player_chainsaw1   =[$nailatt1, player_chainsaw2 ] 
{self.weaponframe=5; W_FireSaw();self.punchangle_x = -1;};
void() player_chainsaw2   =[$nailatt2, player_chainsaw3 ] {self.weaponframe=6; 	if (!self.button0)
		{player_run ();return;self.punchangle_x = -.5;}
};
void() player_chainsaw3   =[$nailatt1, player_chainsaw4 ] {self.weaponframe=7; W_FireSaw();self.punchangle_x = -1;};
void() player_chainsaw4   =[$nailatt2, player_chainsaw5 ] {self.weaponframe=8; 	if (!self.button0)
		{player_run ();return;self.punchangle_x = -.5;}
};
void() player_chainsaw5   =[$nailatt1, player_chainsaw6 ] {self.weaponframe=9; W_FireSaw();self.punchangle_x = -1;};
void() player_chainsaw6   =[$nailatt2, player_run  ] {self.weaponframe=10;self.punchangle_x = -.5;};

//underwater saw

void() player_swimsaw1   =[$swimsh1, player_swimsaw2 ] 
{self.weaponframe=5; W_FireSaw();self.punchangle_x = -1;};
void() player_swimsaw2   =[$swimsh2, player_swimsaw3 ] {self.weaponframe=6; 	if (!self.button0)
		{player_run ();return;self.punchangle_x = -.5;}
};
void() player_swimsaw3   =[$swimsh1, player_swimsaw4 ] {self.weaponframe=7; W_FireSaw();self.punchangle_x = -1;};
void() player_swimsaw4   =[$swimsh2, player_swimsaw5 ] {self.weaponframe=8; 	if (!self.button0)
		{player_run ();return;self.punchangle_x = -.5;}
};
void() player_swimsaw5   =[$swimsh1, player_swimsaw6 ] {self.weaponframe=9; W_FireSaw();self.punchangle_x = -1;};
void() player_swimsaw6   =[$swimsh2, player_run  ] {self.weaponframe=10;self.punchangle_x = -.5;};


//duke kick with gun drawn

void()   melee_kick1 =   [$kick1, melee_kick2] {self.weaponframe=1;};			// instant melee axe attack
void()   melee_kick2 =   [$kick2, melee_kick3] {self.weaponframe=2;self.punchangle_x = -3;};
void()   melee_kick3 =   [$kick3, melee_kick4] {self.weaponframe=3; W_FireAxe();};
void()   melee_kick4 =   [$kick1, melee_kick5] {self.weaponframe=4;};
void()   melee_kick5 =   [$kick4, player_run] {self.weaponframe=4; self.meleeing=0; W_SetCurrentAmmo();};

void()   melee_kick6 =   [$kick1, melee_kick7] {self.weaponframe=5;};			// instant melee axe attack
void()   melee_kick7 =   [$kick2, melee_kick8] {self.weaponframe=6;self.punchangle_x = 2;self.punchangle_y = -3;};
void()   melee_kick8 =   [$kick3, melee_kick9] {self.weaponframe=7; W_FireAxe();};
void()   melee_kick9 =   [$kick1, melee_kick10] {self.weaponframe=7;};
void()   melee_kick10 =   [$kick4, player_run] {self.weaponframe=7; self.meleeing=0; W_SetCurrentAmmo();};

//duke kick with axe drawn

void()   melee_kickax1 =   [$kickax1, melee_kickax2] {self.weaponframe=1;};			// instant melee axe attack
void()   melee_kickax2 =   [$kickax2, melee_kickax3] {self.weaponframe=2;self.punchangle_x = -3;};
void()   melee_kickax3 =   [$kickax3, melee_kickax4] {self.weaponframe=3; W_FireAxe();};
void()   melee_kickax4 =   [$kickax1, melee_kickax5] {self.weaponframe=4;};
void()   melee_kickax5 =   [$kickax4, player_run] {self.weaponframe=4; self.meleeing=0; W_SetCurrentAmmo();};

void()   melee_kickax6 =   [$kickax1, melee_kickax7] {self.weaponframe=5;};			// instant melee axe attack
void()   melee_kickax7 =   [$kickax2, melee_kickax8] {self.weaponframe=6;self.punchangle_x = 2;self.punchangle_y = -3;};
void()   melee_kickax8 =   [$kickax3, melee_kickax9] {self.weaponframe=7; W_FireAxe();};
void()   melee_kickax9 =   [$kickax1, melee_kickax10] {self.weaponframe=7;};
void()   melee_kickax10 =   [$kickax4, player_run] {self.weaponframe=7; self.meleeing=0; W_SetCurrentAmmo();};

//============================================================================

void() player_nail1   =[$nailatt1, player_nail2  ] 
{
	if (self.weapon == IT_SUPER_NAILGUN && self.ammo_nails < 2)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1)&&(self.weapon != IT_NAILGUN))
	{
		nailcasing (0);
	}
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (self.weaponframe >= 10)
			self.weaponframe = 1;
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe == 9)
			self.weaponframe = 1;
	}
	/*if (self.weaponframe >= 6)
		self.weaponframe = 1;
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;*/
	SuperDamageSound();
	if (cvar("chase_active"))
		W_FireSpikes (2);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to a FIXED right position
			W_FireSpikes (10);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			W_FireSpikes (autocvar_weapon_position_adjustable_projectile_nail1a_offset);
		else
			W_FireSpikes (3);
	}
	self.attack_finished = time + 0.2;
};
void() player_nail2   =[$nailatt2, player_nail1  ]
{
	if (self.weapon == IT_SUPER_NAILGUN && self.ammo_nails < 2)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1)&&(self.weapon != IT_NAILGUN))
	{
		nailcasing (0);
	}
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (self.weaponframe >= 10)
			self.weaponframe = 1;
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe == 9)
			self.weaponframe = 1;
	}
	/*if (self.weaponframe >= 6)
		self.weaponframe = 1;
	self.weaponframe = self.weaponframe + 1;
	//if (self.weaponframe == 9)
	if (self.weaponframe == 5)
		self.weaponframe = 1;*/
	SuperDamageSound();
	if (cvar("chase_active"))
		W_FireSpikes (-4);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to a FIXED right position
			W_FireSpikes (6);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			W_FireSpikes (autocvar_weapon_position_adjustable_projectile_nail1b_offset);
		else
			W_FireSpikes (-3);
	}
	self.attack_finished = time + 0.2;
};

//swimming

void() player_swimnail1   =[$swimsh3, player_swimnail2  ] 
{
	if (self.weapon == IT_SUPER_NAILGUN && self.ammo_nails < 2)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1)&&(self.weapon != IT_NAILGUN))
	{
		nailcasing (0);
	}
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (self.weaponframe >= 10)
			self.weaponframe = 1;
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe == 9)
			self.weaponframe = 1;
	}
	SuperDamageSound();
	if (cvar("chase_active"))
		W_FireSpikes (2);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to a FIXED right position
			W_FireSpikes (10);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			W_FireSpikes (autocvar_weapon_position_adjustable_projectile_nail1a_offset);
		else
			W_FireSpikes (3);
	}
	self.attack_finished = time + 0.2;
};
void() player_swimnail2   =[$swimsh5, player_swimnail1  ]
{
	if (self.weapon == IT_SUPER_NAILGUN && self.ammo_nails < 2)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1)&&(self.weapon != IT_NAILGUN))
	{
		nailcasing (0);
	}
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (self.weaponframe >= 10)
			self.weaponframe = 1;
		self.weaponframe = self.weaponframe + 1;
		if (self.weaponframe == 9)
			self.weaponframe = 1;
	}
	SuperDamageSound();
	if (cvar("chase_active"))
		W_FireSpikes (-4);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to a FIXED right position
			W_FireSpikes (6);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			W_FireSpikes (autocvar_weapon_position_adjustable_projectile_nail1b_offset);
		else
			W_FireSpikes (-3);
	}
	self.attack_finished = time + 0.2;
};

//============================================================================

void() player_light1   =[$light1, player_light2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};
void() player_light2   =[$light2, player_light1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

//============================================================================

void() player_mage1   =[$light1, player_mage2  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = 18;
	self.animate_mage_weapon_helper = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};

void() player_mage2   =[$light2, player_mage1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = 19;
	self.animate_mage_weapon_helper = 1;
	SuperDamageSound();
	W_FireLightning();
	self.attack_finished = time + 0.2;
};


//HIP Weapon
void() player_nade1   =[$axatt1, player_nade2  ] {sound7 (self, CHAN_WEAPON, "weapons/grenarm.wav", 1, ATTN_NORM, self.PLR_SNDSPD);self.weaponframe=0;self.throwing = 1;
	self.weaponmodel = "progs/v_nade.mdl"; if (autocvar_cheat_crazyexplosives == 1) self.attack_finished = time + 0.07; else self.attack_finished = time + 0.6;};
void() player_nade2   =[$axatt2, player_nade3  ] {self.weaponframe=1;self.punchangle_x = -3;};
void() player_nade3   =[$axatt3, player_nade4  ] {self.weaponframe=2;W_FireProximityGrenade();};
void() player_nade4   =[$axatt4, player_nade5  ] {sound7 (self, CHAN_WEAPON, "weapons/grenthrow.wav", 1, ATTN_NORM, self.PLR_SNDSPD);self.weaponframe=3;};
void() player_nade5   =[$axatt5, player_run  ] {self.weaponframe=4;};

void() player_laser1   =[$nailatt1, player_laser3  ] {self.attack_finished = time + 0.1;HIP_FireLaser(0);};
void() player_laser2   =[$nailatt2, player_laser3  ] {self.attack_finished = time + 0.1;};
void() player_laser3   =[$nailatt2, player_laser1  ] {self.attack_finished = time + 0.1;HIP_FireLaser(1);};
void() player_laser4   =[$nailatt1, player_laser1  ] {self.attack_finished = time + 0.1;};
/*
void() player_laser1   =[$nailatt1, player_laser3  ] {self.attack_finished = time + 0.1;self.weaponframe=1;self.nextthink = time + 0.1;HIP_FireLaser(0);};
void() player_laser2   =[$nailatt2, player_laser3  ] {self.attack_finished = time + 0.1;self.weaponframe=2;self.nextthink = time + 0.1;};
void() player_laser3   =[$nailatt2, player_laser1  ] {self.attack_finished = time + 0.1;self.weaponframe=4;self.nextthink = time + 0.1;HIP_FireLaser(1);};
void() player_laser4   =[$nailatt1, player_laser1  ] {self.attack_finished = time + 0.1;self.weaponframe=5;self.nextthink = time + 0.1;};
*/
void() ThrowNade =
{
	if (self.health < 1)
		return;
	if (self.grenade_ammo <= 0)
	{
		sprint(self, "No Proximity Grenades.\n");
		return;
	}
	else
		player_nade1();
};

//============================================================================



void() player_rocket1   =[$rockatt1, player_rocket2  ] {self.weaponframe=1;
self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_rocket2   =[$rockatt2, player_rocket3  ] {self.weaponframe=2;
if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1)&& self.weapon == IT_ROCKET_LAUNCHER)
	{
	missilecase (0);
	}};
void() player_rocket3   =[$rockatt3, player_rocket4  ] {self.weaponframe=3;};
void() player_rocket4   =[$rockatt4, player_rocket5  ] {self.weaponframe=4;};
void() player_rocket5   =[$rockatt5, player_rocket6  ] {self.weaponframe=5;};
void() player_rocket6   =[$rockatt6, player_run  ] {self.weaponframe=6;};

void(float num_bubbles) DeathBubbles;

void() PainSound =
{
local float		rs;

	if (self.health < 0)
		return;

	if (damage_attacker.classname == "teledeath")
	{
		sound7(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE, SNDSPD);
		return;
	}

// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		DeathBubbles(1);
		if (random() > 0.5)
			sound(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound(self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}

// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
// FIX ME	put in some steam here
		if (random() > 0.5)
			sound7(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM, SNDSPD);
		else
			sound7(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM, SNDSPD);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound7(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM, SNDSPD);
		else
			sound7(self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM, SNDSPD);
		return;
	}

	if (self.pain_finished > time)
	{
		self.axhitme = 0;
		return;
	}
	self.pain_finished = time + 0.5;

// don't make multiple pain sounds right after each other

// ax pain sound
	if (self.axhitme == 1)
	{
		self.axhitme = 0;
		sound7(self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM, SNDSPD);
		return;
	}
	

	rs = rint((random() * 5) + 1);

	self.noise = "";
	if (rs == 1)
		self.noise = "player/pain1.wav";
	else if (rs == 2)
		self.noise = "player/pain2.wav";
	else if (rs == 3)
		self.noise = "player/pain3.wav";
	else if (rs == 4)
		self.noise = "player/pain4.wav";
	else if (rs == 5)
		self.noise = "player/pain5.wav";
	else
		self.noise = "player/pain6.wav";

	sound7 (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, SNDSPD);
	return;
};

void()	player_pain1 =	[	$pain1,	player_pain2	] {PainSound();self.weaponframe=0;};
void()	player_pain2 =	[	$pain2,	player_pain3	] {};
void()	player_pain3 =	[	$pain3,	player_pain4	] {};
void()	player_pain4 =	[	$pain4,	player_pain5	] {};
void()	player_pain5 =	[	$pain5,	player_pain6	] {};
void()	player_pain6 =	[	$pain6,	player_run	] {};

void()	player_jump =
{
	if (self.weapon == IT_AXE)
		self.frame = $axjump1;
	else	
		self.frame = $jump1;
	self.frame++;
}
	


void()	player_axpain1 =	[	$axpain1,	player_axpain2	] {PainSound();self.weaponframe=0;};
void()	player_axpain2 =	[	$axpain2,	player_axpain3	] {};
void()	player_axpain3 =	[	$axpain3,	player_axpain4	] {};
void()	player_axpain4 =	[	$axpain4,	player_axpain5	] {};
void()	player_axpain5 =	[	$axpain5,	player_axpain6	] {};
void()	player_axpain6 =	[	$axpain6,	player_run	] {};

void() player_pain =
{
	if (self.weaponframe)
		return;

	if (self.invisible_finished > time)
		return;		// eyes don't have pain frames

	if (self.weapon == IT_AXE)
		player_axpain1 ();
	else
		player_pain1 ();
};

void() player_diea1;
void() player_dieb1;
void() player_diec1;
void() player_died1;
void() player_diee1;
void() player_die_ax1;
void() player_die_melt1;
void() player_die_scorch1;
void() player_diessg1;
void() player_dieaxe1;
void() player_dieaxb1;
void() player_dieaxc1;
void() player_diesng1;
void() player_dielg1;
void() player_dienail1;

void() DeathBubblesSpawn =
{
local entity	bubble;
	if (self.owner.waterlevel != 3)
		return;
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.1;
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

void(float num_bubbles) DeathBubbles =
{
local entity	bubble_spawner;
	
	bubble_spawner = spawn();
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};


void() DeathSound =
{
local float		rs;

	// water death sounds
	if (self.waterlevel == 3 && self.watertype == CONTENT_WATER)
	{
		DeathBubbles(20);
		sound7(self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NORM, SNDSPD);
		return;
	}
	//slime death sounds
	if (self.watertype == CONTENT_SLIME)
	{
		DeathBubbles(20);
		sound7(self, CHAN_VOICE, "player/slimedeath.wav", 1, ATTN_NORM, SNDSPD);
		return;
	}
	//lava death sounds
	if (self.watertype == CONTENT_LAVA)
	{
		DeathBubbles(20);
		sound7(self, CHAN_VOICE, "player/lavadeath.wav", 1, ATTN_NORM, SNDSPD);
		return;
	}
	
	rs = rint ((random() * 4) + 1);
	if (rs == 1)
		self.noise = "player/death1.wav";
	if (rs == 2)
		self.noise = "player/death2.wav";
	if (rs == 3)
		self.noise = "player/death3.wav";
	if (rs == 4)
		self.noise = "player/death4.wav";
	if (rs == 5)
		self.noise = "player/death5.wav";

	sound7 (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, SNDSPD);
	return;
};


void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
	self.avelocity = '0 0 0';
};

vector(float dm) VelocityForDamage =
{
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();

	if (dm > -50)
	{
//		dprint ("level 1\n");
		v = v * 0.7;
	}
	else if (dm > -200)
	{
//		dprint ("level 3\n");
		v = v * 2;
	}
	else
		v = v * 10;

	return v;
};



void() gibsfade_noblood = 
{
if (self.alpha && self.scale <= 0.01)
	{
	remove (self);
   	return;
	}
else
   	self.alpha = self.alpha - 0.06;
   	self.scale = self.scale - 0.04;

self.nextthink = time + 0.06;	
self.think = gibsfade_noblood;
};


void() gibsfade_blood = 
{
local vector v;   
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

if (self.alpha && self.scale <= 0.5)
	{
	sound7(self, CHAN_VOICE, "player/gibexplode.wav", 1, ATTN_NORM, SNDSPD);
	te_blood (v,'0 80 1000', 7);
	te_blood (v,'80 0 1000', 7);
	te_blood (v,'-80 0 1000', 7);
	te_blood (v,'0 -80 1000', 7);
	remove (self);
   	return;
	}
else
   	self.alpha = self.alpha - 0.06;
   	self.scale = self.scale - 0.04;

self.nextthink = time + 0.06;	
self.think = gibsfade_blood;
};

vector(vector m1, vector m2) randompos;

void() wepTouch =
{
	if (time - self.delay < 0.2)
		return;
	if (pointcontents(self.origin) == CONTENT_LAVA)				// checks for lava
   	{
   		self.velocity/=2;
		self.colormod = '0.4 0.1 0.1'; //change model color	
		return;
      	}
      	if (pointcontents(self.origin) == CONTENT_SLIME)			// checks for slime
	{
		self.velocity/=2;
		self.colormod = '0.3 1.6 0.3';					
		return;
	}
	//self.solid = SOLID_NOT;
	if (deathmatch)
	{
		self.think = SUB_Remove;
		self.nextthink = time + 60;
	}
	if (other.classname == "player" || other == self.owner)
		return;
	if (other.classname != "player" || !(other.flags & FL_MONSTER))
	{
		if (other == world)
		{
			if (self.model == "progs/p_axe.md3" || self.model == "progs/w_chainsaw.mdl" || self.model == "progs/w_knightsword.mdl" || self.model == "progs/w_wsword.mdl" || self.model == "progs/w_dknightsword.mdl")
				sound7(self, CHAN_BODY, "kickgib/gib_metal.wav", 1, ATTN_NORM, SNDSPD);
			else if (self.model == "progs/gib_freddie_leg.mdl")
			{
				if (random() < 0.5)
					sound7(self, CHAN_BODY, "debris/metal2.wav", 1, ATTN_NORM, SNDSPD);
				else
					sound7(self, CHAN_BODY, "debris/metal1.wav", 1, ATTN_NORM, SNDSPD);
			}
			else
				sound7(self, CHAN_BODY, "kickgib/gib_plastic.wav", 1, ATTN_NORM, SNDSPD);
				
			self.delay = time;
		}
	}
	else
		return;
	
};

void(string gibname, float dm) ThrowWeapon =
{
	local	entity new;
	local	float gibsfadetime;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-positionճ randomness
	new.origin = org;
	new.origin_z = new.origin_z + 5;
	if (gibname == "progs/gib_freddie_leg.mdl")
	{
		new.origin_z = new.origin_z + 15;
		new.avelocity = crandom() * '600 600 0';	 // special spin for freddie legs
	}
	else
		new.avelocity = crandom() * '0 600 0';	 // only spin around yaw to keep weapon aligned
	if (gibname == "progs/w_playergun.mdl")
		{
			switch (self.weapon)
			{
				case IT_SHOTGUN:
					gibname = "progs/p_shot.md3";
					break;
				case IT_SUPER_SHOTGUN:
					if (autocvar_qc_ssg == 1)
						gibname = "progs/QC/p_ssg.md3";
					else
						gibname = "progs/p_ssg.md3";
					break;
				case IT_NAILGUN:
					gibname = "progs/p_nail.md3";
					break;
				case IT_SUPER_NAILGUN:
					gibname = "progs/p_nail2.md3";
					break;
				case IT_GRENADE_LAUNCHER:
					gibname = "progs/p_rock.md3";
					break;
				case IT_ROCKET_LAUNCHER:
					gibname = "progs/p_rock2.md3";
					break;
				case IT_LIGHTNING:
					gibname = "progs/p_light.md3";
					break;
				case IT_LASER_CANNON:
					gibname = "progs/p_laser.md3";
					break;
				case IT_CHAINSAW:
					gibname = "progs/p_saw.md3";
					break;
				case IT_AXE:
					gibname = "progs/p_shot.md3";
					break;
			}
			new.frame = 256;
			
		}
	if (gibname == "progs/p_axe.md3")
		new.frame = 256;
	setmodel (new, gibname);
	//setsize (new, '-8 -8 0', '8 8 18');
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm/2);
	new.gravity = 1.1;
	new.owner = self;
	new.solid = SOLID_CORPSE;//SOLID_TRIGGER;
	new.movetype = MOVETYPE_BOUNCE;
	new.cansplash = TRUE;			   // create a splash when fall into liquid
	new.touch = wepTouch;
	//new.touch = GibTouch;
	//new.owner = new;
	
	GibPhysics(new);

	

};

void(string gibname, float dm) ThrowBody =
{
		local	entity new;
	local	float gibsfadetime;
	local vector org;
	local vector dir;

	new = spawn();
	org = self.origin;
	//org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	//org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-positionճ randomness
	new.origin = org;
	new.origin_z = new.origin_z - 8;
	setmodel (new, gibname);
	new.colormap = self.colormap;
	if (new.model == "progs/coal.mdl")
	{
		new.gravity = 0.6;
		new.origin_z = new.origin_z - random(0,4);
		new.scale = random(0.9,1.1);
		new.think = SUB_Remove;
		new.nextthink = time + 45;
	}
	//setsize (new, '-8 -8 0', '8 8 18');
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm/2);
	new.solid = SOLID_NOT;
	new.movetype = MOVETYPE_BOUNCE;
	new.cansplash = TRUE;			   // create a splash when fall into liquid
	//new.touch = wepTouch;
	//new.touch = GibTouch;
	new.owner = new;
	dir = vectoangles (new.velocity);
	new.angles_y = -dir_y;
	
	
	GibPhysics(new);

	//new.angles_y = (self.v_angle_y);
	if (new.model == "progs/coal.mdl")
		new.avelocity = crandom() * '300 100 200';
	else
		new.avelocity = crandom() * '0 100 0';	 // only spin around yaw to keep weapon aligned

	
}


void(string gibname, float dm) ThrowGib =
{
	local	entity new;
	local	float gibsfadetime;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-positionճ randomness
	new.origin = org;
	if (gibname != "progs/gib_soldhead.mdl")
		new.origin_z = new.origin_z + 15;
	else
	{
		new.origin_z = new.origin_z + 9;
		new.angles = self.angles;
	}
	
	
	
	if (self.classname == "player")
	{
		new.colormod = self.colormod;
		new.colormap = self.colormap;
	}
		
	new.effects = EF_LOWPRECISION;
		
	setmodel (new, gibname);
	//setsize (new, '-8 -8 0', '8 8 18');
	
	if (gibname == "progs/gib_soldhead.mdl")
		setsize (new, '0 0 -1', '0 0 0');
	else if (gibname == "progs/gib_skull.mdl")
		setsize (new, '0 0 -2', '0 0 0');
	else
		setsize (new, '0 0 0', '0 0 0');
	
	new.classname = "gib";
	new.velocity = VelocityForDamage (dm);//VelocityForDamage (dm/1.1);
	new.movetype = MOVETYPE_BOUNCE;
	new.cansplash = TRUE;			   // create a splash when fall into liquid
	//new.touch = GibTouch;
	if ((self.enemy.weapon == IT_ROCKET_LAUNCHER || self.enemy.weapon == IT_GRENADE_LAUNCHER || self.sticky == 1) && random() < 0.1)
	{	
		new.traileffectnum = particleeffectnum("burning_gib");
		new.colormod = '0.85 0.9 0.9';
		setsize (new, '0 0 -2', '0 0 0');
		//Dlight from fire
		/*new.light_lev = 40;
		new.color = '4 2.5 1.8';
		
		//randomly choose between flicker style
		if (random(100) < 50)
			new.style = 6;
		else
			new.style = 1;
		
		//set flags to enable light, draw corona, and disable shadows	
		new.pflags = new.pflags | PFLAGS_FULLDYNAMIC | PFLAGS_CORONA | PFLAGS_NOSHADOW;*/
		
	}
	else if (self.enemy.weapon == IT_LASER_CANNON || self.enemy.classname == "monster_enforcer" || self.enemy.classname == "monster_jim")
	{
		new.traileffectnum = particleeffectnum("burning_gib");
		new.colormod = '0.35 0.4 0.4';
		new.velocity/=3;
		setsize (new, '0 0 -2', '0 0 0');
	}
		
	new.owner = new;
	
	var float autocvar_kickgibs = 1;           // set cvar 'kickgibs' default to 1
	if (autocvar_kickgibs == 1)			 // if 'kickgibs' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
		{
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch;      // Call kick_touch when touched
		}
	else 							// if 'kickgibs' is set via autoexec.cfg to any other value
		{						// --> all gibs cannot be kicked
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		//new.touch = GibTouch;
		new.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
		}
	if ( gibname != "progs/gibheart.mdl")	// "gibheart" model must not be spinned around all axis !
		{
		var float autocvar_gibspinstyle = 1;		// set cvar 'gibspinstyle' default to 1
		if (autocvar_gibspinstyle == 1)
			new.avelocity = crandom() * '0 600 0';	 // make gibs behave like head-gibs (only spin around yaw)
		else 						
			{ 					 // make gibs spin around all 3 axis independently (more like original Quake behaviour)
			new.avelocity_x = crandom()*600;
			new.avelocity_y = crandom()*600;
			new.avelocity_z = crandom()*600;
			}
		}
	else 
		new.avelocity = crandom() * '0 600 0';	 // makes "gibheart" model  behave like head-gibs (only spin around yaw)
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		{					 // --> gibs will NEVER disappear !!!
	 	new.nextthink = -1;
		}
	else 							// if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{						// --> gibs fade out
		new.alpha = 1;
		new.scale = 1;
		gibsfadetime = autocvar_gibsduration;
		var float autocvar_gibsexplode = 1;      	// set cvar 'gibsexplode' default to 1 
			if (autocvar_gibsexplode == 0)	// if 'gibsduration' is set via autoexec.cfg to '0'
				{
				new.think = gibsfade_noblood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
			else					// if 'gibsexplode' is set via autoexec.cfg to any other value than '1'
				{
				precache_sound("player/gibexplode.wav");  
				new.think = gibsfade_blood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
		}
	new.frame = 0;
	new.flags = 0;
	
	GibPhysics(new);
	
	if (self.shocked > 0)
	{
		if (!deathmatch && !coop)
			new.traileffectnum = particleeffectnum("gib_lg");
		
		new.colormod = '.1 .1 .1';
		new.think = chargib_think;
		new.nextthink = time + 0.1;
		return;
	}
	if (self.weapon == IT_SUPER_SHOTGUN)
		new.velocity = new.velocity + v_forward*60;
		
	
	//if (new.flags & FL_ONGROUND)	
		//sound7(new, CHAN_AUTO, "gib/gibhit1.wav", 1, ATTN_NORM, SNDSPD);
};


void(string gibname, float dm, float skincolor) ThrowGibSpider =
{
	local	entity new;
	local	float gibsfadetime;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-positionճ randomness
	new.origin = org;
	setmodel (new, gibname);
	setsize (new, '-16 -16 0', '16 16 48');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.skin = skincolor;
	new.cansplash = TRUE;			   // create a splash when fall into liquid

	var float autocvar_kickgibs = 1;           // set cvar 'kickgibs' default to 1
	if (autocvar_kickgibs == 1)			 // if 'kickgibs' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
		{
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch;      // Call kick_touch when touched
		}
	else 							// if 'kickgibs' is set via autoexec.cfg to any other value
		{						// --> all gibs cannot be kicked
		new.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		new.touch = kick_touch3;     // Call kick_touch3 only when gib interacts with liquids
		}
	new.avelocity = crandom() * '0 600 0';	 // makes "gibheart" model  behave like head-gibs (only spin around yaw)
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		{					 // --> gibs will NEVER disappear !!!
	 	new.nextthink = -1;
		}
	else 							// if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{						// --> gibs fade out
		new.alpha = 1;
		new.scale = 1;
		gibsfadetime = autocvar_gibsduration;
		var float autocvar_gibsexplode = 1;      	// set cvar 'gibsexplode' default to 1 
			if (autocvar_gibsexplode == 0)	// if 'gibsduration' is set via autoexec.cfg to '0'
				{
				new.think = gibsfade_noblood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
			else					// if 'gibsexplode' is set via autoexec.cfg to any other value than '1'
				{
				precache_sound("player/gibexplode.wav");  
				new.think = gibsfade_blood;
				new.ltime = time;
				new.nextthink = time + gibsfadetime + random()*10;
				}
		}
	new.frame = 0;
	new.flags = 0;
	
GibPhysics(new);
};


void () gib_heart_movement;
.float heartcounter;

void() gib_heart_stop_beating =
{
	local	float gibsfadetime;

	var float autocvar_kickgibs = 1;           // set cvar 'kickgibs' default to 1
	if (autocvar_kickgibs == 1)		  // if 'kickgibs' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
		{
		self.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		self.touch = kick_touch_heart1_nobeating; // Call kick_touch_heart1 when touched
		}
	else 						// if 'kickgibs' is set via autoexec.cfg to any other value
		{					// --> all gibs cannot be kicked
		self.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		self.touch = kick_touch_heart2_nobeating; // Call kick_touch_heart2 only when heart-gib interacts with liquids
		}
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		 // if 'gibsduration' is set via autoexec.cfg to '0'
		{				 // --> gibs will NEVER disappear !!!
	 	self.nextthink = -1;
		}
	else 							// if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{						// --> gibs fade out
		gibsfadetime = autocvar_gibsduration;
		var float autocvar_gibsexplode = 1;      	// set cvar 'gibsexplode' default to 1 
			if (autocvar_gibsexplode == 0)		// if 'gibsduration' is set via autoexec.cfg to '0'
				{
				self.think = gibsfade_noblood;
				self.ltime = time;
				self.nextthink = time + gibsfadetime;
				}
			else					// if 'gibsexplode' is set via autoexec.cfg to any other value than '1'
				{
				precache_sound("player/gibexplode.wav");  
				self.think = gibsfade_blood;
				self.ltime = time;
				self.nextthink = time + gibsfadetime;
				}
		}
};


void() gib_heart_movement2 = 		// scale the heart smaller
{
local float deadheart;
deadheart = autocvar_heartgiblifetime * 3;	// cvar 'heartgiblifetime' to adjust how long the heart beats  ;-)   default is 7 seconds.  Factor to convert from seconds for the function is approx. '3'
if (self.heartcounter >= deadheart)	
	{
	self.scale = 1; 
	self.traileffectnum = particleeffectnum("gib_heart_nobeating");
	precache_sound("player/gibexplode.wav");  
	self.think = gib_heart_stop_beating;
	self.nextthink = time;
	return;
	}
if (self.scale > 0.92)
	{
	self.nextthink = time + 0.014;
	self.scale = self.scale - 0.007;    //frametime * 0.5; 
	self.think = gib_heart_movement2; 
	}
else
	{
	sound7(self, CHAN_VOICE, "ambience/gibheartbeat.wav", 0.8, ATTN_NORM);
	self.nextthink = time; //0.01;
	self.think = gib_heart_movement; 
	self.heartcounter = self.heartcounter + 1;
	}
};

void() gib_heart_movement =		// scale the heart bigger
{
if (self.scale < 1.08)
	{
	self.nextthink = time + 0.014;
	self.scale = self.scale + 0.007;   //frametime * 0.5; 	
	self.think = gib_heart_movement; 
	}
else
	{
	self.nextthink = time; //0.001;
	self.think = gib_heart_movement2; 
	self.heartcounter = self.heartcounter + 1;
	}
};


void(string gibname, float dm) ThrowHeart =
{
	local	entity new;
	local vector org;

	new = spawn();
	org = self.origin + randompos(self.mins + '16 16 0', self.maxs - '16 16 0');	// use approx. the bbox area to spawn the gibs (makes all gibs spawn at random positions inside the bbox)
	org_z = self.origin_z + (random() * 21); 		 // dont spawn gibs from too high (looks bad).  limits the z-positionճ randomness
	new.origin = org;
	setmodel (new, gibname);
	setsize (new, '-16 -16 0', '16 16 48');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;

	var float autocvar_kickgibs = 1;           // set cvar 'kickgibs' default to 1
	if (autocvar_kickgibs == 1)		  // if 'kickgibs' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
		{
		new.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		new.touch = kick_touch_heart1;      // Call kick_touch_heart1 when touched
		}
	else 						// if 'kickgibs' is set via autoexec.cfg to any other value
		{					// --> all gibs cannot be kicked
		new.solid = SOLID_TRIGGER;   	  // Set it up for a trigger event
		new.touch = kick_touch_heart2;     // Call kick_touch_heart2 only when heart-gib interacts with liquids
		}

	new.avelocity = crandom() * '80 600 20';	 // make gibs behave like head-gibs (only spin around yaw)
	new.traileffectnum = particleeffectnum("gib_heart");
	new.scale = 1;
	new.alpha = 1;
	new.heartcounter = 0;
	new.nextthink = time + 0.1;  
	new.think = gib_heart_movement;
	new.frame = 0;
	new.flags = 0;
	
	if (self.shocked > 0)
		new.velocity = new.velocity/5;
	
GibPhysics(new);
};


void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.cansplash = TRUE;		// create a splash when fall into liquid
	self.frame = 0;
	self.scale = 1;		// I had to decide whether gibs match the .scale value of killed monster or not. I chose not, as head gibs are always bigger than the "living" size head.
	if (autocvar_head_gibs_always_face_player)
	{
		self.nextthink = time + 2;
		self.think = head_gib_faceplayer;
	}
	else
		self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	
	if (self.shocked > 0)
	{
		self.colormod = '.2 .2 .2';
		self.traileffectnum = particleeffectnum("charred_gib");
	}

	var float autocvar_kickgibs = 1;          // set cvar 'kickgibs' default to 1
	if (autocvar_kickgibs == 1)			// if 'kickgibs' doesnt exist or in autoexec.cfg, or is set via autoexec.cfg to '1'
		{
		self.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		self.touch = kick_touch2;     // Call kick_touch2 when touched
		}
	else 							// if 'kickgibs' is set via autoexec.cfg to any other value
		{						// --> all gibs cannot be kicked
		self.solid = SOLID_TRIGGER;   // Set it up for a trigger event
		self.touch = kick_touch3;     // Call kick_touch3 when gib interacts with liquids
		}
	if (self.flags & FL_ONGROUND)
	{
		if (self.angles_z >= 80 || self.angles_z <= -80)
			self.angles_z = 0;
		if (self.angles_x >= 80 || self.angles_x <= -80)
			self.angles_x = 0;
	}

	if (self.shocked > 0)
		self.velocity = self.velocity/5;
		
		
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.velocity = VelocityForDamage (dm);
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	
	if (self.enemy.weapon == IT_SUPER_SHOTGUN)
		self.velocity = self.velocity + v_forward*60;
	
	if (self.enemy.weapon == IT_LASER_CANNON)
	{
		self.colormod = '0.25 0.3 0.3';
		self.velocity/=3;
		//setsize (new, '0 0 -1', '0 0 0');
	}
	if (self.shocked > 0)
		self.velocity/=4;
		
	
	
	if (self.model != "progs/player_swim.mdl")
		self.avelocity = crandom() * '600 600 0';
	else	
		self.avelocity = crandom() * '0 600 0';
Gyro_Object_ClearPhysics(self);
GibPhysics(self);
};

void() debTouch = 
{
	if (other.classname == "player" || other.classname == "debris" || (other.flags & FL_MONSTER))
		return;
	if (random() > 0.34)
		sound7(self, CHAN_ITEM, "debris/metal1.wav", 1, ATTN_NORM, SNDSPD);
	else if (random() < 0.64)
		sound7(self, CHAN_ITEM, "debris/metal2.wav", 1, ATTN_NORM, SNDSPD);
	else	
		sound7(self, CHAN_ITEM, "debris/metal3.wav", 1, ATTN_NORM, SNDSPD);
}

void(vector org, vector vel, string debrisname) Throwdebris =
{
	local	entity debris;

	debris = spawn();
debris.cansplash = TRUE;					// so that debris will create a splash when fall into liquid
	setorigin(debris, org);
	setmodel (debris, debrisname);
	setsize (debris, '0 0 0', '0 0 0');
debris.traileffectnum = particleeffectnum("debris");	//  adds particle effect to debris (customize the effect in your effectinfo.txt)
	debris.velocity = vel + randomvec() * 2;  
	debris.movetype = MOVETYPE_BOUNCE;
	debris.classname = "debris";
	debris.effects = EF_LOWPRECISION;

	var float autocvar_kickdebris = 1;         // set cvar 'kickdebris' default to 1
	if (autocvar_kickdebris == 1)			 // if 'kickdebris' is set to '1'
		{
		debris.solid = SOLID_TRIGGER;   	// Set it up for a trigger event
		debris.touch = kick_touch4;      	// Call kick_touch4 when touched
		}
	else 							// if 'kickdebris' is set to any other value
		{						// --> all debris cannot be kicked
		debris.solid = SOLID_TRIGGER;   	// dont stop player
		debris.touch = debTouch;//debris.solid = SOLID_NOT;
		}

	debris.avelocity = crandom() * '0 600 0';	 // make debris only spin around yaw
	debris.alpha = 1;
	debris.scale = 1;
	self.nextthink = -1;
	debris.frame = 0;
	debris.flags = 0;
	debris.gravity = 0.8;
	
Gyro_Object_Activate(debris, 3977);
};


void(vector org, vector vel, string gibname, float skintype) ThrowAfritGibs =
{
	local	entity afritgib;
	local	float gibsfadetime;

	afritgib = spawn();
	afritgib.cansplash = TRUE;					// so that afritgib will create a splash when fall into liquids
	setorigin(afritgib, org);
	setmodel (afritgib, gibname);
	setsize (afritgib, '0 0 0', '0 0 0');				//  temporary remove bbox to not hang in walls
	if (skintype)
		{
		afritgib.traileffectnum = particleeffectnum("Afrit_gib_grey");	//  adds particle effect to afritgib (customize the effect in your effectinfo.txt)
		afritgib.skin_type = 1;
		}
	else
		{
		afritgib.traileffectnum = particleeffectnum("Afrit_gib_red");	//  adds particle effect to afritgib (customize the effect in your effectinfo.txt)
		afritgib.skin_type = 0;
		}
	afritgib.velocity = vel + randomvec() * 25;  
	afritgib.velocity_z = afritgib.velocity_z + 100;
	afritgib.movetype = MOVETYPE_BOUNCE;

	local float zufall;
	zufall = random();		// randomize gib sizes
	    if (zufall > 0.8)  
	    	afritgib.scale = 0.8;
	    else if (zufall > 0.6)  
	    	afritgib.scale = 0.65;
	    else if (zufall > 0.4)  
	    	afritgib.scale = 0.5;
	    else if (zufall > 0.2) 
	    	afritgib.scale = 0.35;
	    else 
	    	afritgib.scale = 0.2;

	afritgib.alpha = 1;

	var float autocvar_kick_afrit_gibs = 0;        	// set cvar 'kick_afrit_gibs' default to 0
	if (autocvar_kick_afrit_gibs)		 	// if 'kick_afrit_gibs' is set via autoexec.cfg to any other value
		{
		afritgib.solid = SOLID_TRIGGER;		// Set it up for a trigger event
		afritgib.touch = kick_touch5temp;	// Call kick_touch5temp when touched
		}
	else 						// if 'kick_afrit_gibs' is 0
		{					// --> all gibs cannot be kicked
		afritgib.solid = SOLID_TRIGGER;    	// Set it up for a trigger event
		afritgib.touch = kick_touch6temp;	// Call kick_touch6temp only when gib interacts with liquids
		}

	afritgib.avelocity_x = crandom()*600;
	afritgib.avelocity_y = crandom()*600;
	afritgib.avelocity_z = crandom()*600;
	
	var float autocvar_gibsduration = 10;      // set cvar 'gibsduration' default to 10 == original ID1 behaviour
	if (autocvar_gibsduration == 0)		   // if 'gibsduration' is set via autoexec.cfg to '0'
		{				   // --> gibs will NEVER disappear !!!
	 	afritgib.nextthink = -1;
		}
	else 					  // if 'gibsduration' is set via autoexec.cfg to any other value than '0'
		{				  // --> gibs fade out
		gibsfadetime = autocvar_gibsduration;
		afritgib.think = gibsfade_noblood;
		afritgib.ltime = time;
		afritgib.nextthink = time + gibsfadetime + random()*10;
		}

	afritgib.frame = 0;
	afritgib.flags = afritgib.flags - (afritgib.flags & FL_ONGROUND);
	
GibPhysics(afritgib);
};


void() GibPlayer =
{
	if (autocvar_player_model == 1)
		ThrowHead ("progs/h_player1.mdl", self.health);
	else if (autocvar_player_model == 2)
		ThrowHead ("progs/h_player2.mdl", self.health);
	else if (autocvar_player_model == 3)
		ThrowHead ("progs/h_player3.mdl", self.health);
	else if (autocvar_player_model == 4)
		ThrowHead ("progs/h_player4.mdl", self.health);
	else 
		ThrowHead ("progs/h_player.mdl", self.health);
	self.delete_painskin = 1;		//prevent "ghost" player over body
	ThrowGib ("progs/gib_5.mdl", self.health);
	ThrowGib ("progs/gib_soldfoot1.mdl", self.health);
	ThrowGib ("progs/gib_soldfoot2.mdl", self.health);
	ThrowGib ("progs/chop.mdl", self.health);
	ThrowGib ("progs/chop.mdl", self.health);
	//ThrowGib ("progs/chop.mdl", self.health);
	ThrowWeapon ("progs/w_playergun.mdl", self.health);
	
	CeilSplat();
	CeilSplat();
	CeilSplat();
	CeilSplat();
	CeilSplat();
	
	if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
		ThrowHeart ("progs/gibheart.mdl", self.health);

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound7(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE, SNDSPD);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound7(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE, SNDSPD);
		return;
	}
		
	play_gibsound();
		
	gibdeath_effects();
};

void() setDamageSkin =
{
	if (self.watertype == CONTENT_LAVA)
	{
		self.skin = 0;
	}
	if (self.watertype == CONTENT_SLIME)
	{
		self.skin = 1;
	}
};

void() PlayerDie =
{
	local	float	i;

if ((autocvar_chasecam_death_view) && (!cvar("chase_active")))
	{
		stuffcmd (self, "chase_active 1\n");
		stuffcmd (self, "chase_back 65\n");
		stuffcmd (self, "chase_up 70\n");
		stuffcmd (self, "chase_overhead 1\n");
		if (!deathmatch && !coop && !CTF_ENABLED)
		{
			if (random () <= (autocvar_slowmotion_randomness_player * 0.01))
			{
				the_matrix = 1;
				SNDSPD = 70;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	}

	self.items = self.items - (self.items & IT_INVISIBILITY);
	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.modelindex = modelindex_player;	// don't use eyes

	if (deathmatch || coop)
		DropBackpack();
	
	self.weaponmodel="";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;
		
	if (self.health < -40 || (self.enemy.weapon == IT_CHAINSAW && random()<0.5))
	{
		GibPlayer ();
		return;
	}
	if (!self.ishuman)
		self.angles_y = 0;
		
	DeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
	//fatalities
	spawn_bloodpool(.5);
	
	if (self.model == "progs/player_torso.mdl")
	{
		setmodel(self, "progs/player.mdl");
		setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	}
	
	if (self.enemy.meleeing == 0) //check before all fatalities to make sure attack type is not a kick
	{	
	// SG DEATH CODE
	
		if (self.enemy.weapon == IT_SHOTGUN)
		{
			if (random() < 0.3)
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_ssg.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_diessg1();
				sound7(self, CHAN_AUTO, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);
			}
			else
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		}
		if (self.enemy.weapon == IT_NAILGUN)
		{
			if (random() < 0.5)
			{
				//ThrowGib ("progs/chop.mdl", self.health);
				//ThrowWeapon ("progs/p_axe.md3", self.health);
				
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_ng.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dienail1();
				return;
				
			}
			else
			{
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_holes.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_diea1();
				pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);
				sound7(self, CHAN_AUTO, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);
			}
			
		}
		if (self.enemy.weapon == IT_SUPER_SHOTGUN)
		{
			CeilSplat();
			CeilSplat();
			CeilSplat();

			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				if (random() < 0.3)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					ThrowWeapon ("progs/w_playergun.mdl", self.health);
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_ssg.mdl");

					player_diessg1();
					setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
					return;
						
				}
				else if (random() >= 0.5 && random() <= 0.7)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					ThrowWeapon ("progs/w_playergun.mdl", self.health);
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_ssg.mdl");
					setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
					player_diessg1();
					sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowHead ("progs/gib_player_torso_head.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_legs.mdl", self.health);
				
				}
				else
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
						ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					ThrowWeapon ("progs/w_playergun.mdl", self.health);
					self.delete_painskin = 1;
					//setmodel (self, self.model = "progs/player_ssg.mdl");
					player_diea1();
					sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowHead ("progs/gib_player_torso.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_head.mdl", self.health);
					ThrowGib ("progs/gib_player_legs.mdl", self.health);
				}
		}
		
		//AXE FATALITY CODE
		
		if (self.enemy.weapon == IT_AXE || self.enemy.weapon == IT_CHAINSAW)
		{
			if (random() < 0.2)
			{
				
				ThrowWeapon ("progs/p_axe.md3", self.health);
				//ThrowGib ("progs/w_soldiergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_axe.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxe1();
				return;
			}
			else if (random() >= 0.2 && random() < 0.5)
			{
				//ThrowGib ("progs/chop.mdl", self.health);
				//ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_disarm.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxc1();
				return;
			}
			else
			{
			
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_decap.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxb1();
				return;
			}	
			
		}
		
		//SUPER NAILGUN DEATH CODE
		
		if (self.enemy.weapon == IT_SUPER_NAILGUN)
		{
			if (random() < 0.5)
			{
				
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_deleg.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_diesng1();
				StickGib ("progs/gib_player_torso_sng.mdl");
				return;
			}
			else
			{
				
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_deleg.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_diesng1();
				ThrowGib ("progs/gib_player_arm_sng.mdl", self.health);
				StickGib ("progs/gib_player_head_sng.mdl");
				StickGib ("progs/gib_player_torso_sng_b.mdl");
				return;
			}
			
		}
		//ROCKET DEATH CODE
		if (self.enemy.weapon == IT_ROCKET_LAUNCHER)
		{
			CeilSplat();
			CeilSplat();
			CeilSplat();
			CeilSplat();

			setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
			if (random() < 0.6)
			{
				pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_deleg.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_diea1();
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/gib_player_head.mdl", self.health);
				sound7(self, CHAN_VOICE, "misc/z_gib.wav", 1, ATTN_IDLE, SNDSPD);
				return;
			}
			else
			{
				pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				//setmodel (self, self.model = "progs/player_deleg.mdl");
				player_diea1();
				//ThrowGib ("progs/gib_soldfoot1.mdl", self.health);
				//ThrowGib ("progs/gib_soldfoot2.mdl", self.health);
				ThrowGib ("progs/gib_player_larm.mdl", self.health);
				ThrowHead ("progs/gib_player_legs.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/gib_player_head.mdl", self.health);
				sound7(self, CHAN_VOICE, "misc/z_gib.wav", 1, ATTN_IDLE, SNDSPD);
				//return;
			}
		}
		
		//LIGHTNING GUN DEATH CODE
		
		if (self.enemy.weapon == IT_LIGHTNING)
		{
			if (random() < 0.3)
			{
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_melt.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				self.skin = 1;
				player_die_melt1 ();
				
				sound7(self, CHAN_VOICE, "player/blasterdeath.wav", 1, ATTN_IDLE, SNDSPD);
				return;
			}
			else
			{
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_melt.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				self.skin = 1;
				player_dielg1();
				return;
			}
			
		}
		//HIPNOTIC LASER DEATH
		
		if (self.enemy.weapon == IT_LASER_CANNON)
		{
			if (random() < 0.4)
			{
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_melt.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				self.skin = 1;
				player_die_melt1 ();
				sound7(self, CHAN_VOICE, "player/blasterdeath.wav", 1, ATTN_IDLE, SNDSPD);
				return;
			}
			else
				gibdeath_effects();
			
		}
		
		
		
		//Monster fatalities - these happen
		
		//Grunt 
		if (self.enemy.classname == "monster_army")
		{
			if (self.enemy.model == "progs/soldier1.mdl" || self.enemy.model == "progs/soldier1_pain.mdl")
			{
				if (random() < 0.5)
				{
					//ThrowGib ("progs/chop.mdl", self.health);
					//ThrowWeapon ("progs/p_axe.md3", self.health);
					
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_ng.mdl");
					setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
					player_dienail1();
					return;
					
				}
				else
				{
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_holes.mdl");
					setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
					player_diea1();
					pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);
					sound7(self, CHAN_AUTO, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);
				}
				
			}
			else if (self.enemy.model == "progs/soldier.mdl" || self.enemy.model == "progs/soldier_pain.mdl")
			{
				if (random() < 0.4)
					{
						if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
							pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
						ThrowGib ("progs/chop.mdl", self.health);
						ThrowGib ("progs/chop.mdl", self.health);
						ThrowGib ("progs/chop.mdl", self.health);
						ThrowWeapon ("progs/p_axe.md3", self.health);
						ThrowWeapon ("progs/w_playergun.mdl", self.health);
						self.delete_painskin = 1;
						setmodel (self, self.model = "progs/player_ssg.mdl");
						setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
						player_diessg1();
						return;
							
					}
					else
					{
					//	if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					//		pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					//	ThrowGib ("progs/chop.mdl", self.health);
					//	ThrowGib ("progs/chop.mdl", self.health);
					//	ThrowGib ("progs/chop.mdl", self.health);
					//	ThrowWeapon ("progs/p_axe.md3", self.health);
						ThrowWeapon ("progs/w_playergun.mdl", self.health);
						self.delete_painskin = 1;
						setmodel (self, self.model = "progs/player_ssg.mdl");
						setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
						if (random() < 0.5)
							player_dieb1();
						else if (random() >= 0.5 && random() <= 0.8)
							player_died1();
						else
							player_diec1();
						sound7(self, CHAN_AUTO, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);
						//return;
						
					}
			}
		}
		
		else if (self.enemy.classname == "monster_enforcer" && self.enemy.skin != 1)
		{
			if (random() < 0.4)
				{
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					//ThrowGib ("progs/w_soldiergun.mdl", self.health);
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_melt.mdl");
					self.skin = 1;
					player_die_melt1 ();
					sound7(self, CHAN_VOICE, "player/blasterdeath.wav", 1, ATTN_IDLE, SNDSPD);
					return;
						
				}
		}
		else if (self.enemy.classname == "monster_wizard")
			{
				if (random() < 0.4)
				{
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					//ThrowGib ("progs/w_soldiergun.mdl", self.health);
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_melt.mdl");
					self.skin = 0;
					player_die_melt1 ();
					sound7(self, CHAN_VOICE, "player/slimedeath.wav", 1, ATTN_NONE);
					return;
						
				}
			}
		else if (self.enemy.classname == "monster_knight" || self.enemy.classname == "monster_zombiek")
		{
			if (random() < 0.4)
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_axe.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxe1();
				return;
			}
			else
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_decap.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxb1();
				return;
			}
			
		}
		else if (self.enemy.classname == "monster_hell_knight")
		{
			if (random() < 0.4)
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_axe.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxe1();
				return;
			}
			else if (random() >= 0.4 && random() < 0.8)
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_decap.mdl");
				setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
				player_dieaxb1();
				return;
			}
			
		}
		else if (self.enemy.classname == "monster_ogre")
		{
				if (random() < 0.4)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					ThrowWeapon ("progs/w_playergun.mdl", self.health);
					self.delete_painskin = 1;
					//setmodel (self, self.model = "progs/player_ssg.mdl");
					player_diea1();
					sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowHead ("progs/gib_player_torso.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_head.mdl", self.health);
					ThrowGib ("progs/gib_player_legs.mdl", self.health);
				}
			
		}
		else if (self.enemy.classname == "buzzsaw")
		{
				//if (random() < 0.4)
				//{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowWeapon ("progs/p_axe.md3", self.health);
					ThrowWeapon ("progs/w_playergun.mdl", self.health);
					self.delete_painskin = 1;
					setmodel (self, self.model = "progs/player_buzz.mdl");
					//player_die_melt1 ();
					sound7(self, CHAN_VOICE, "player/buzzdeath.wav", 1, ATTN_IDLE, SNDSPD);
					if (random() < 0.4)
					{
						ThrowHead ("progs/gib_player_torso.mdl", self.health);
						ThrowGib ("progs/gib_player_head.mdl", self.health);
					}
					else
						ThrowHead ("progs/gib_player_torso_head.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_larm.mdl", self.health);
					ThrowGib ("progs/gib_player_legs.mdl", self.health);
					
					setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
					//return;
				//}
			
		}
		else if (self.enemy.classname == "pendulum")
		{
			if (random() < 0.6)
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				ThrowGib ("progs/gib_player_torso_head.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_deleg.mdl");
				player_dieb1();
				sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);
				sound7(self, CHAN_AUTO, "player/axeflesh3.wav", 1, ATTN_IDLE, SNDSPD);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
				return;
			}
			else
			{
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowGib ("progs/chop.mdl", self.health);
				ThrowWeapon ("progs/p_axe.md3", self.health);
				ThrowWeapon ("progs/w_playergun.mdl", self.health);
				self.delete_painskin = 1;
				setmodel (self, self.model = "progs/player_decap.mdl");
				player_dieaxb1();
				setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
				return;
			}
			
		}
		else if (self.enemy.classname != "player")
			ThrowWeapon ("progs/w_playergun.mdl", self.health);
	}
	
	
	
	//lava death anim
	
	if (self.watertype == CONTENT_LAVA)
	{
		if (self.waterlevel == 1)
		{
			setmodel (self, self.model = "progs/player_scorchlegs.mdl");
		}
		else
			setmodel (self, self.model = "progs/player_scorch.mdl");
		
		player_die_scorch1 ();
		return;
	}
	
	//slime death
	if (self.watertype == CONTENT_SLIME)
	{
		setmodel (self, self.model = "progs/player_melt.mdl");
		player_die_melt1 ();
		return;
	}
	
	//drown
	if (self.watertype == CONTENT_WATER && self.waterlevel >= 2)
	{
		player_dieb1 ();
		PlayerDead();
		if (deathmatch || coop)
		{
			ThrowBody ("progs/player_swim.mdl", self.health);
			ThrowHead ("progs/chop.mdl", self.health);
		}
		else
			ThrowHead ("progs/player_swim.mdl", self.health);
		
		//ThrowWeapon ("progs/w_playergun.mdl", self.health);
		
		return;
	}
	
	if (self.weapon == IT_AXE)
	{
		//if (self.watertype != CONTENT_LAVA && self.watertype != CONTENT_SLIME)
		//{
			player_die_ax1 ();
			return;
		//}
	}
	
	
	
	
	i = cvar("temp1");
	if (!i)
		i = 1 + floor(random()*6);
	
	if (i == 1)
		player_diea1();
	else if (i == 2)
		player_dieb1();
	else if (i == 3)
		player_diec1();
	else if (i == 4)
		player_died1();
	else
		player_diee1();
	


};

void() set_suicide_frame =
{	// used by klill command and diconnect command
	if ((self.model != "progs/player_torso.mdl")||(self.model != "progs/player.mdl")||(self.model != "progs/player1.mdl")||(self.model != "progs/player2.mdl")||(self.model != "progs/player3.mdl")||(self.model != "progs/player4.mdl")||(self.model != "progs/player_shot.mdl")||(self.model != "progs/player_shot2.mdl")||(self.model != "progs/player_nail.mdl")||(self.model != "progs/player_nail2.mdl")||(self.model != "progs/player_rock.mdl")||(self.model != "progs/player_rock2.mdl")||(self.model != "progs/player_light.mdl"))
		return;	// allready gibbed
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};

void() lg_shock_player;


void()	player_diea1	=	[	$deatha1,	player_diea2	] {};
void()	player_diea2	=	[	$deatha2,	player_diea3	] {};
void()	player_diea3	=	[	$deatha3,	player_diea4	] {};
void()	player_diea4	=	[	$deatha4,	player_diea5	] {};
void()	player_diea5	=	[	$deatha5,	player_diea6	] {};
void()	player_diea6	=	[	$deatha6,	player_diea7	] {};
void()	player_diea7	=	[	$deatha7,	player_diea8	] {};
void()	player_diea8	=	[	$deatha8,	player_diea9	] {};
void()	player_diea9	=	[	$deatha9,	player_diea10	] {};
void()	player_diea10	=	[	$deatha10,	player_diea11	] {};
void()	player_diea11	=	[	$deatha11,	player_diea11 ] {PlayerDead();};

void()	player_dieb1	=	[	$deathb1,	player_dieb2	] {};
void()	player_dieb2	=	[	$deathb2,	player_dieb3	] {};
void()	player_dieb3	=	[	$deathb3,	player_dieb4	] {};
void()	player_dieb4	=	[	$deathb4,	player_dieb5	] {};
void()	player_dieb5	=	[	$deathb5,	player_dieb6	] {};
void()	player_dieb6	=	[	$deathb6,	player_dieb7	] {};
void()	player_dieb7	=	[	$deathb7,	player_dieb8	] {};
void()	player_dieb8	=	[	$deathb8,	player_dieb9	] {};
void()	player_dieb9	=	[	$deathb9,	player_dieb9	] {PlayerDead();};

void()	player_diec1	=	[	$deathc1,	player_diec2	] {};
void()	player_diec2	=	[	$deathc2,	player_diec3	] {};
void()	player_diec3	=	[	$deathc3,	player_diec4	] {};
void()	player_diec4	=	[	$deathc4,	player_diec5	] {};
void()	player_diec5	=	[	$deathc5,	player_diec6	] {};
void()	player_diec6	=	[	$deathc6,	player_diec7	] {};
void()	player_diec7	=	[	$deathc7,	player_diec8	] {};
void()	player_diec8	=	[	$deathc8,	player_diec9	] {};
void()	player_diec9	=	[	$deathc9,	player_diec10	] {};
void()	player_diec10	=	[	$deathc10,	player_diec11	] {};
void()	player_diec11	=	[	$deathc11,	player_diec12	] {};
void()	player_diec12	=	[	$deathc12,	player_diec13	] {};
void()	player_diec13	=	[	$deathc13,	player_diec14	] {};
void()	player_diec14	=	[	$deathc14,	player_diec15	] {};
void()	player_diec15	=	[	$deathc15,	player_diec15 ] {PlayerDead();};

void()	player_died1	=	[	$deathd1,	player_died2	] {};
void()	player_died2	=	[	$deathd2,	player_died3	] {};
void()	player_died3	=	[	$deathd3,	player_died4	] {};
void()	player_died4	=	[	$deathd4,	player_died5	] {};
void()	player_died5	=	[	$deathd5,	player_died6	] {};
void()	player_died6	=	[	$deathd6,	player_died7	] {};
void()	player_died7	=	[	$deathd7,	player_died8	] {};
void()	player_died8	=	[	$deathd8,	player_died9	] {};
void()	player_died9	=	[	$deathd9,	player_died9	] {PlayerDead();};

void()	player_diee1	=	[	$deathe1,	player_diee2	] {};
void()	player_diee2	=	[	$deathe2,	player_diee3	] {};
void()	player_diee3	=	[	$deathe3,	player_diee4	] {};
void()	player_diee4	=	[	$deathe4,	player_diee5	] {};
void()	player_diee5	=	[	$deathe5,	player_diee6	] {};
void()	player_diee6	=	[	$deathe6,	player_diee7	] {};
void()	player_diee7	=	[	$deathe7,	player_diee8	] {};
void()	player_diee8	=	[	$deathe8,	player_diee9	] {};
void()	player_diee9	=	[	$deathe9,	player_diee9	] {PlayerDead();};

void()	player_die_ax1	=	[	$axdeth1,	player_die_ax2	] {};
void()	player_die_ax2	=	[	$axdeth2,	player_die_ax3	] {};
void()	player_die_ax3	=	[	$axdeth3,	player_die_ax4	] {};
void()	player_die_ax4	=	[	$axdeth4,	player_die_ax5	] {};
void()	player_die_ax5	=	[	$axdeth5,	player_die_ax6	] {};
void()	player_die_ax6	=	[	$axdeth6,	player_die_ax7	] {};
void()	player_die_ax7	=	[	$axdeth7,	player_die_ax8	] {};
void()	player_die_ax8	=	[	$axdeth8,	player_die_ax9	] {};
void()	player_die_ax9	=	[	$axdeth9,	player_die_ax9	] {PlayerDead();};

void()	player_die_melt1 =	[	$melt1, 	player_die_melt2 ] {};
void()	player_die_melt2 =	[	$melt2, 	player_die_melt3 ] {};
void()	player_die_melt3 =	[	$melt3, 	player_die_melt4 ] {};
void()	player_die_melt4 =	[	$melt4, 	player_die_melt5 ] {};
void()	player_die_melt5 =	[	$melt5, 	player_die_melt6 ] {};
void()	player_die_melt6 =	[	$melt6, 	player_die_melt7 ] {};
void()	player_die_melt7 =	[	$melt7, 	player_die_melt8 ] {};
void()	player_die_melt8 =	[	$melt8, 	player_die_melt9 ] {};
void()	player_die_melt9 =	[	$melt9, 	player_die_melt10 ] {};
void()	player_die_melt10 =	[	$melt10, 	player_die_melt11 ] {};
void()	player_die_melt11 =	[	$melt11, 	player_die_melt12 ] {};
void()	player_die_melt12 =	[	$melt12, 	player_die_melt13 ] {};
void()	player_die_melt13 =	[	$melt13, 	player_die_melt14 ] {};
void()	player_die_melt14 =	[	$melt14, 	player_die_melt15 ] {};
void()	player_die_melt15 =	[	$melt15, 	player_die_melt16 ] {};
void()	player_die_melt16 =	[	$melt16, 	player_die_melt17 ] {};
void()	player_die_melt17 =	[	$melt17, 	player_die_melt18 ] {};
void()	player_die_melt18 =	[	$melt18, 	player_die_melt18 ] {PlayerDead();};

void()	player_die_scorch1 =	[	$melt1, 	player_die_scorch2 ] {};
void()	player_die_scorch2 =	[	$melt2, 	player_die_scorch3 ] {};
void()	player_die_scorch3 =	[	$melt3, 	player_die_scorch4 ] {};
void()	player_die_scorch4 =	[	$melt4, 	player_die_scorch5 ] {};
void()	player_die_scorch5 =	[	$melt5, 	player_die_scorch6 ] {};
void()	player_die_scorch6 =	[	$melt6, 	player_die_scorch7 ] {};
void()	player_die_scorch7 =	[	$melt7, 	player_die_scorch8 ] {};
void()	player_die_scorch8 =	[	$melt8, 	player_die_scorch9 ] {};
void()	player_die_scorch9 =	[	$melt9, 	player_die_scorch10 ] {};
void()	player_die_scorch10 =	[	$melt10, 	player_die_scorch11 ] {};
void()	player_die_scorch11 =	[	$melt11, 	player_die_scorch12 ] {};
void()	player_die_scorch12 =	[	$melt12, 	player_die_scorch13 ] {};
void()	player_die_scorch13 =	[	$melt13, 	player_die_scorch14 ] {};
void()	player_die_scorch14 =	[	$melt14, 	player_die_scorch15 ] {};
void()	player_die_scorch15 =	[	$melt15, 	player_die_scorch16 ] {};
void()	player_die_scorch16 =	[	$melt16, 	player_die_scorch17 ] {};
void()	player_die_scorch17 =	[	$melt17, 	player_die_scorch18 ] {PlayerDead(); if (deathmatch || coop) 
												{
													ThrowGib ("progs/gib_player_helmet.mdl", self.health);ThrowHead ("progs/p_axe.md3", self.health);
												}
												else 
													ThrowHead ("progs/gib_player_helmet.mdl");
									      };	
void()	player_die_scorch18 =	[	$melt18, 	player_die_scorch18 ] {};

void()	player_diessg1	=	[	$ssgdeath1,	player_diessg2	] {};
void()	player_diessg2	=	[	$ssgdeath2,	player_diessg3	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_diessg3	=	[	$ssgdeath3,	player_diessg4	] {};
void()	player_diessg4	=	[	$ssgdeath4,	player_diessg5	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diessg5	=	[	$ssgdeath5,	player_diessg6	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_diessg6	=	[	$ssgdeath6,	player_diessg7	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diessg7	=	[	$ssgdeath7,	player_diessg8	] {};
void()	player_diessg8	=	[	$ssgdeath8,	player_diessg9	] {};
void()	player_diessg9	=	[	$ssgdeath9,	player_diessg10	] {};
void()	player_diessg10	=	[	$ssgdeath10,	player_diessg11	] {};
void()	player_diessg11	=	[	$ssgdeath11,	player_diessg12 ] {};
void()	player_diessg12	=	[	$ssgdeath12,	player_diessg13	] {pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_diessg13	=	[	$ssgdeath13,	player_diessg14	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_diessg14	=	[	$ssgdeath14,	player_diessg15	] {};
void()	player_diessg15	=	[	$ssgdeath15,	player_diessg15	] {PlayerDead();};

void()	player_dieaxe1	=	[	$axde1,		player_dieaxe2	] {};
void()	player_dieaxe2	=	[	$axde2,		player_dieaxe3	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxe3	=	[	$axde3,		player_dieaxe4	] {};
void()	player_dieaxe4	=	[	$axde4,		player_dieaxe5	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxe5	=	[	$axde5,		player_dieaxe6	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxe6	=	[	$axde6,		player_dieaxe7	] {};
void()	player_dieaxe7	=	[	$axde7,		player_dieaxe8	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxe8	=	[	$axde8,		player_dieaxe9	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxe9	=	[	$axde9,		player_dieaxe10	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxe10	=	[	$axde10,	player_dieaxe11	] {};
void()	player_dieaxe11	=	[	$axde11,	player_dieaxe12 ] {};
void()	player_dieaxe12	=	[	$axde12,	player_dieaxe13	] {};
void()	player_dieaxe13	=	[	$axde13,	player_dieaxe14	] {pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxe14	=	[	$axde14,	player_dieaxe14	] {PlayerDead();};

void()	player_dieaxb1	=	[	$deatha1,	player_dieaxb2	] {};
void()	player_dieaxb2	=	[	$deatha2,	player_dieaxb3	] {ThrowGib ("progs/gib_player_head.mdl", self.health);sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxb3	=	[	$deatha3,	player_dieaxb4	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxb4	=	[	$deatha4,	player_dieaxb5	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxb5	=	[	$deatha5,	player_dieaxb6	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxb6	=	[	$deatha6,	player_dieaxb7	] {};
void()	player_dieaxb7	=	[	$deatha7,	player_dieaxb8	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxb8	=	[	$deatha8,	player_dieaxb9	] {};
void()	player_dieaxb9	=	[	$deatha9,	player_dieaxb10	] {pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxb10	=	[	$deatha10,	player_dieaxb11	] {};
void()	player_dieaxb11	=	[	$deatha11,	player_dieaxb11 ] {PlayerDead();};

void()	player_dieaxc1	=	[	$pain1,		player_dieaxc2	] {};
void()	player_dieaxc2	=	[	$pain2,		player_dieaxc3	] {ThrowGib ("progs/gib_player_larm.mdl", self.health);};
void()	player_dieaxc3	=	[	$pain3,		player_dieaxc4	] {sound7(self, CHAN_VOICE, "soldier/decap.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxc4	=	[	$pain4,		player_dieaxc5	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxc5	=	[	$pain5,		player_dieaxc6	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxc6	=	[	$deatha4,	player_dieaxc7	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxc7	=	[	$deatha5,	player_dieaxc8	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxc8	=	[	$deatha6,	player_dieaxc9	] {};
void()	player_dieaxc9	=	[	$deatha7,	player_dieaxc10	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dieaxc10	=	[	$deatha8,	player_dieaxc11	] {};
void()	player_dieaxc11	=	[	$deatha9,	player_dieaxc12	] {pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dieaxc12	=	[	$deatha10,	player_dieaxc13	] {};
void()	player_dieaxc13	=	[	$deatha11,	player_dieaxc13 ] {PlayerDead();};

void()	player_diesng1	=	[	$pain1,		player_diesng2	] {};
void()	player_diesng2	=	[	$pain2,		player_diesng3	] {};
void()	player_diesng3	=	[	$pain3,		player_diesng4	] {sound7(self, CHAN_VOICE, "player/gibexplode.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_diesng4	=	[	$pain4,		player_diesng5	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diesng5	=	[	$pain5,		player_diesng6	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diesng6	=	[	$deatha4,	player_diesng7	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diesng7	=	[	$deatha5,	player_diesng8	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diesng8	=	[	$deatha6,	player_diesng9	] {};
void()	player_diesng9	=	[	$deatha7,	player_diesng10	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_diesng10	=	[	$deatha8,	player_diesng11	] {};
void()	player_diesng11	=	[	$deatha9,	player_diesng12	] {pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);sound7(self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_diesng12	=	[	$deatha10,	player_diesng13	] {};
void()	player_diesng13	=	[	$deatha11,	player_diesng13 ] {PlayerDead();};

void()	player_dielg1	=	[	$pain1,		player_dielg2	] {self.shocked = 1;self.colormod = '.1 .1 .1';};
void()	player_dielg2	=	[	$pain3,		player_dielg3	] {sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg3	=	[	$pain5,		player_dielg4	] {ThrowGib ("progs/chop.mdl", self.health);sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg4	=	[	$pain2, 	player_dielg5	] {lg_shock_player();ThrowGib ("progs/chop.mdl", self.health);sound7(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg5	=	[	$pain5,		player_dielg6	] {sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg6	=	[	$pain1, 	player_dielg7	] {lg_shock_player();sound7(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg7	=	[	$pain5,		player_dielg8	] {ThrowGib ("progs/chop.mdl", self.health);sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg8	=	[	$pain1, 	player_dielg9	] {lg_shock_player();ThrowGib ("progs/chop.mdl", self.health);sound7(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg9	=	[	$pain5,		player_dielg10	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);sound7(self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dielg10	=	[	$pain1,		player_dielg11	] {PlayerDead();pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);ThrowGib ("progs/gib_player_head.mdl", self.health);ThrowGib ("progs/gib_player_larm.mdl", self.health);ThrowHead ("progs/gib_player_torso.mdl", self.health);ThrowWeapon ("progs/p_axe.md3", self.health);ThrowGib ("progs/gib_soldfoot2.mdl", self.health);
									   sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);ThrowGib ("progs/gib_player_larm.mdl", self.health);ThrowGib ("progs/gib_soldfoot1.mdl", self.health);ThrowWeapon ("progs/w_playergun.mdl", self.health);};
void()	player_dielg11	=	[	$pain6,		player_dielg11	] {};


void()	player_dienail1		=	[	$naildth1,	player_dienail2		] {};
void()	player_dienail2		=	[	$naildth2,	player_dienail3		] {sound7(self, CHAN_VOICE, "player/gibexplode.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dienail3		=	[	$naildth3,	player_dienail4		] {};
void()	player_dienail4		=	[	$naildth4,	player_dienail5		] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dienail5		=	[	$naildth5,	player_dienail6		] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dienail6		=	[	$naildth6,	player_dienail7		] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	player_dienail7		=	[	$naildth7,	player_dienail8		] {};
void()	player_dienail8		=	[	$naildth8,	player_dienail9		] {};
void()	player_dienail9		=	[	$naildth9,	player_dienail10	] {};
void()	player_dienail10	=	[	$naildth10,	player_dienail11	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dienail11	=	[	$naildth11,	player_dienail12 	] {};
void()	player_dienail12	=	[	$naildth12,	player_dienail13	] {};
void()	player_dienail13	=	[	$naildth13,	player_dienail14	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	player_dienail14	=	[	$naildth14,	player_dienail15	] {};
void()	player_dienail15	=	[	$naildth15,	player_dienail16	] {};
void()	player_dienail16	=	[	$naildth16,	player_dienail17	] {ThrowWeapon ("progs/w_playergun.mdl", self.health);};
void()	player_dienail17	=	[	$naildth17,	player_dienail17	] {sound7(self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE, SNDSPD);pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);PlayerDead();};

