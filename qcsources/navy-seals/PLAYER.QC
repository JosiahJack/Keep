
void() bubble_bob;
void() reload_mossberg29;
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


/*
==============================================================================
PLAYER
==============================================================================
*/

void() player_run;

void()	player_stand1 =[	$axstnd1,	player_stand1	]
{
        if (self.weapon == IT_LIGHTNING && self.m60clip == 0)
          self.weaponframe = 15;
        else
          self.weaponframe=0;
	if (self.velocity_x || self.velocity_y)
	{
		self.walkframe=0;
		player_run();
		return;
	}

        if (self.weapon == WP_ONE)
	{
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

void()	player_run =[	$rockrun1,	player_run	]
{
        if (self.weapon == IT_LIGHTNING && self.m60clip == 0)
          self.weaponframe = 15;
        else
          self.weaponframe=0;
        self.reload = 0;
        self.fire = 0;
        if (!self.velocity_x && !self.velocity_y)
	{
		self.walkframe=0;
		player_stand1();
		return;
	}

        if (self.weapon == WP_ONE)
	{
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
self.effects = self.effects | EF_MUZZLEFLASH;};
void()	player_shot2 =	[$shotatt2, player_shot3	] {self.weaponframe=2;};
void()	player_shot3 =	[$shotatt3, player_shot4	] {self.weaponframe=3;};
void()	player_shot4 =	[$shotatt4, player_shot5	] {self.weaponframe=4;};
void()	player_shot5 =	[$shotatt5, player_shot6	] {self.weaponframe=5;};
void()	player_shot6 =	[$shotatt6, player_run	] {self.weaponframe=6;};

void()	player_axe1 =	[$axatt1, player_axe2	] {self.weaponframe=1;};
void()	player_axe2 =	[$axatt2, player_axe3	] {self.weaponframe=2;};
void()	player_axe3 =	[$axatt3, player_axe4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axe4 =	[$axatt4, player_run	] {self.weaponframe=4;};

void()	player_axeb1 =	[$axattb1, player_axeb2	] {self.weaponframe=5;};
void()	player_axeb2 =	[$axattb2, player_axeb3	] {self.weaponframe=6;};
void()	player_axeb3 =	[$axattb3, player_axeb4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axeb4 =	[$axattb4, player_run	] {self.weaponframe=8;};

void()	player_axec1 =	[$axattc1, player_axec2	] {self.weaponframe=1;};
void()	player_axec2 =	[$axattc2, player_axec3	] {self.weaponframe=2;};
void()	player_axec3 =	[$axattc3, player_axec4	] {self.weaponframe=3;W_FireAxe();};
void()	player_axec4 =	[$axattc4, player_run	] {self.weaponframe=4;};

void()	player_axed1 =	[$axattd1, player_axed2	] {self.weaponframe=5;};
void()	player_axed2 =	[$axattd2, player_axed3	] {self.weaponframe=6;};
void()	player_axed3 =	[$axattd3, player_axed4	] {self.weaponframe=7;W_FireAxe();};
void()	player_axed4 =	[$axattd4, player_run	] {self.weaponframe=8;};


//============================================================================

/******************************************/
/*         M60 Machine Gun                */
/******************************************/

void () player_m60_winchester;

void () player_m60 = [1, player_m60b]
{
   self.fire = 1;
   self.weaponframe = 1;
   self.nextthink = time + (0.04 - (frametime * 0.2));
   self.attack_finished = self.attack_finished + (0.04 - (frametime * 0.2));
   if (self.button0 == 0)
    {
     self.think = player_run;
    }
   W_FireM60 ();
};

void () player_m60b = [2, player_m60c]
{
   self.weaponframe = 2;
   self.nextthink = time + (0.04 - (frametime * 0.2));
   self.attack_finished = self.attack_finished + (0.04 - (frametime * 0.2));
   if (self.button0 == 0)
    {
     self.think = player_run;
    }
   if (self.m60clip == 5) 
    { 
     self.think = player_m60_winchester;
    }
};

void () player_m60c = [1, player_m60d]
{
   self.weaponframe = 3;
   self.nextthink = time + (0.04 - (frametime * 0.2));
   self.attack_finished = self.attack_finished + (0.04 - (frametime * 0.2));
   if (self.button0 == 0)
    {
     self.think = player_run;
    }
   W_FireM60 ();
};

void () player_m60d = [2, player_m60e]
{
   self.weaponframe = 4;
   self.nextthink = time + (0.04 - (frametime * 0.2));
   self.attack_finished = self.attack_finished + (0.04 - (frametime * 0.2));
   if (self.button0 == 0)
    {
     self.think = player_run;
    }
   if (self.m60clip == 5) 
    { 
     self.think = player_m60_winchester;
    }
};

void () player_m60e = [1, player_m60f]
{
   self.weaponframe = 5;
   self.nextthink = time + (0.04 - (frametime * 0.2));
   self.attack_finished = self.attack_finished + (0.04 - (frametime * 0.2));
   if (self.button0 == 0)
    {
     self.think = player_run;
    }
   W_FireM60 ();
};

void () player_m60f = [1, player_m60]
{
   self.weaponframe = 0;
   self.nextthink = time + (0.04 - (frametime * 0.2));
   self.attack_finished = self.attack_finished + (0.04 - (frametime * 0.2));
   if (self.button0 == 0)
    {
     self.think = player_run;
    }
   if (self.m60clip == 5) 
    { 
     self.think = player_m60_winchester;
    }
};
  
void () player_m60_winchester = [1, m60_winchester2]
{
   self.attack_finished = time + 0.6;
   self.weaponframe = 6;
   self.nextthink = time + 0.04;
   W_FireM60 ();
};

void () m60_winchester2 = [2, m60_winchester3]
{
   self.weaponframe = 7;
   self.nextthink = time + 0.04;
};

void () m60_winchester3 = [2, m60_winchester4]
{
   self.weaponframe = 8;
   self.nextthink = time + 0.04;
   W_FireM60 ();
};

void () m60_winchester4 = [2, m60_winchester5]
{
   self.weaponframe = 9;
   self.nextthink = time + 0.04;
};

void () m60_winchester5 = [2, m60_winchester6]
{
   self.weaponframe = 10;
   self.nextthink = time + 0.04;
   W_FireM60 ();
};

void () m60_winchester6 = [2, m60_winchester7]
{
   self.weaponframe = 11;
   self.nextthink = time + 0.04;
};

void () m60_winchester7 = [2, m60_winchester8]
{
   self.weaponframe = 12;
   self.nextthink = time + 0.04;
   W_FireM60 ();
};

void () m60_winchester8 = [2, m60_winchester9]
{
   self.weaponframe = 13;
   self.nextthink = time + 0.04;
};

void () m60_winchester9 = [2, m60_winchester10]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.04;
   W_FireM60 ();
};

void () m60_winchester10 = [2, m60_winchester10]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.04;
   self.reload = 0;
};

void () player_reload_m60 = [2, m60_reload2]
{
   self.weaponframe = 16;
   self.nextthink = time + 0.05;
   self.reload = 1;
};

void () m60_reload2 = [3, m60_reload3]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.05;
};

void () m60_reload3 = [3, m60_reload4]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.05;
};

void () m60_reload4 = [3, m60_reload5]
{
   self.weaponframe = 19;
   self.nextthink = time + 0.05;
};

void () m60_reload5 = [3, m60_reload6]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.05;
};

void () m60_reload6 = [3, m60_reload7]
{
   self.weaponframe = 21;
   self.nextthink = time + 0.05;
};

void () m60_reload7 = [3, m60_reload8]
{
   self.weaponframe = 22;
   self.nextthink = time + 0.05;
};

void () m60_reload8 = [3, m60_reload9]
{
   self.weaponframe = 23;
   self.nextthink = time + 0.05;
};

void () m60_reload9 = [3, m60_reload10]
{
   self.weaponframe = 24;
   self.nextthink = time + 0.25;
};

void () m60_reload10 = [3, m60_reload11]
{
   self.weaponframe = 25;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/chain.wav",1,ATTN_NORM);
};

void () m60_reload11 = [3, m60_reload12]
{
   self.weaponframe = 26;
   self.nextthink = time + 0.05;
};

void () m60_reload12 = [3, m60_reload13]
{
   self.weaponframe = 27;
   self.nextthink = time + 0.05;
};

void () m60_reload13 = [3, m60_reload14]
{
   self.weaponframe = 28;
   self.nextthink = time + 0.05;
};

void () m60_reload14 = [3, m60_reload15]
{
   self.weaponframe = 29;
   self.nextthink = time + 0.05;
};

void () m60_reload15 = [3, m60_reload16]
{
   self.weaponframe = 30;
   self.nextthink = time + 0.05;
};

void () m60_reload16 = [3, m60_reload17]
{
   self.weaponframe = 31;
   self.nextthink = time + 0.05;
};

void () m60_reload17 = [3, m60_reload18]
{
   self.weaponframe = 32;
   self.nextthink = time + 0.05;
};

void () m60_reload18 = [3, m60_reload19]
{
   self.weaponframe = 33;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/m60in.wav",1,ATTN_NORM);
};

void () m60_reload19 = [3, m60_reload20]
{
   self.weaponframe = 34;
   self.nextthink = time + 0.05;
};

void () m60_reload20 = [3, m60_reload21]
{
   self.weaponframe = 35;
   self.nextthink = time + 0.05;
};

void () m60_reload21 = [3, m60_reload22]
{
   self.weaponframe = 36;
   self.nextthink = time + 0.05;
};

void () m60_reload22 = [3, m60_reload23]
{
   self.weaponframe = 37;
   self.nextthink = time + 0.05;
};

void () m60_reload23 = [3, m60_reload24]
{
   self.weaponframe = 38;
   self.nextthink = time + 0.05;
};

void () m60_reload24 = [3, m60_reload25]
{
   self.weaponframe = 39;
   self.nextthink = time + 0.05;
};

void () m60_reload25 = [3, m60_reload26]
{
   self.weaponframe = 40;
   self.nextthink = time + 0.05;
};

void () m60_reload26 = [3, m60_reload27]
{
   self.weaponframe = 41;
   self.nextthink = time + 0.05;
};

void () m60_reload27 = [3, m60_reload28]
{
   self.weaponframe = 42;
   self.nextthink = time + 0.05;
};

void () m60_reload28 = [3, m60_reload29]
{
   self.weaponframe = 43;
   self.nextthink = time + 0.05;
};

void () m60_reload29 = [3, m60_reload30]
{
   self.weaponframe = 44;
   self.nextthink = time + 0.05;
};

void () m60_reload30 = [3, m60_reload31]
{
   self.weaponframe = 45;
   self.nextthink = time + 0.05;
};

void () m60_reload31 = [3, m60_reload32]
{
   self.weaponframe = 46;
   self.nextthink = time + 0.05;
};

void () m60_reload32 = [3, m60_reload33]
{
   self.weaponframe = 47;
   self.nextthink = time + 0.05;
};

void () m60_reload33 = [3, m60_reload34]
{
   self.weaponframe = 48;
   self.nextthink = time + 0.05;
};

void () m60_reload34 = [3, m60_reload35]
{
   self.weaponframe = 49;
   self.nextthink = time + 0.05;
};

void () m60_reload35 = [3, player_run]
{
   self.weaponframe = 50;
   self.nextthink = time + 0.05;
   if ((self.ammo_cells >= 1) && (self.ammo_cells <= 50) )
   {
      self.m60clip = self.ammo_cells * 4; 
      self.ammo_cells = 0;
   }
   else
   {
      self.m60clip = 200.000;
      self.ammo_cells = (self.ammo_cells - 50.000);
   }
   W_SetCurrentAmmo();
};

/******************************************/
/*         PSG-1 Sniper Rifle             */
/******************************************/

void () player_zoom = [1, zoom2]
{
   self.weaponframe = 42;
   self.nextthink = time + 0.05;
};

void () zoom2 = [2, zoom3]
{ 
   self.weaponframe = 43;
   self.nextthink = time + 0.05;
};

void () zoom3 = [2, zoom4]
{ 
   self.weaponframe = 44;
   self.nextthink = time + 0.05;
};

void () zoom4 = [2, zoom5]
{ 
   self.weaponframe = 45;
   self.nextthink = time + 0.05;
};

void () zoom5 = [2, zoom6]
{ 
   self.weaponframe = 46;
   self.nextthink = time + 0.05;  
};

void () zoom6 = [2, zoom7]
{ 
   self.weaponmodel = "";
   self.nextthink = time + 0.05;  
   stuffcmd(self,"fov 80 \n");
};

void () zoom7 = [2, zoom8]
{ 
   self.nextthink = time + 0.05;  
   stuffcmd(self,"fov 70 \n");
};

void () zoom8 = [2, zoom9]
{ 
   self.nextthink = time + 0.05;  
   stuffcmd(self,"fov 60 \n");
};

void () zoom9 = [2, player_run]
{ 
   self.nextthink = time + 0.05;  
   self.zoomlevel = 1;
   stuffcmd(self,"fov 50 \n");
};

void () player_zoomb = [1, zoomb2]
{ 
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 40 \n");
};

void () zoomb2 = [1, zoomb3]
{ 
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 30 \n");
};

void () zoomb3 = [1, zoomb4]
{ 
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 20 \n");
};

void () zoomb4 = [1, player_run]
{ 
   self.nextthink = time + 0.05;
   self.zoomlevel = 2;
   stuffcmd(self,"fov 15 \n");
};

void () player_zoomout = [1, zoomout2]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 20 \n");
};

void () zoomout2 = [2, zoomout3]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 30 \n");
};

void () zoomout3 = [2, zoomout4]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 40 \n");
};

void () zoomout4 = [2, zoomout5]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 50 \n");
};

void () zoomout5 = [2, zoomout6]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 60 \n");
};

void () zoomout6 = [2, zoomout7]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 70 \n");
};

void () zoomout7 = [2, zoomout8]
{
   self.nextthink = time + 0.05;
    if (self.weapon == WP_PSG1) 
   self.weaponmodel = ("progs/v_psg1.mdl");
    else if (self.weapon == WP_BARRETT)
   self.weaponmodel = ("progs/v_barret.mdl");
   self.weaponframe = 46;
   self.zoomlevel = 0;
   stuffcmd(self,"fov 80 \n");
};

void () zoomout8 = [2, zoomout9]
{
   self.nextthink = time + 0.05;
   stuffcmd(self,"fov 90 \n");
   self.weaponframe = 45;
};

void () zoomout9 = [2, zoomout10]
{
   self.nextthink = time + 0.05;
   self.weaponframe = 44;
};

void () zoomout10 = [2, zoomout11]
{
   self.nextthink = time + 0.05;
   self.weaponframe = 43;
};

void () zoomout11 = [2, player_run]
{
   self.nextthink = time + 0.05;
   self.weaponframe = 0;
};


void () player_psg1 = [1, psg1b]
{
   self.weaponframe = 1;
   self.nextthink = time + 0.05;
   self.effects = self.effects | EF_MUZZLEFLASH;
   sound(self,CHAN_WEAPON,"weapons/psg1fire.wav",1,ATTN_NORM);
   W_FirePSG1 ();
   self.fire = 1;
};

void () psg1b = [2, psg1c]
{
   self.weaponframe = 2;
   self.nextthink = time + 0.05;
};

void () psg1c = [2, psg1d]
{
   self.weaponframe = 3;
   self.nextthink = time + 0.05;
};

void () psg1d = [2, psg1e]
{
   self.weaponframe = 4;
   self.nextthink = time + 0.05;
};

void () psg1e = [2, player_run]
{
   self.weaponframe = 0;
   self.nextthink = time + 0.5;
};

void () player_reload_psg1 = [1, reload_psg2]
{
   self.weaponframe = 5;
   self.nextthink = time + 0.05;
   self.reload = 1;
};

void () reload_psg2 = [1, reload_psg3]
{
   self.weaponframe = 6;
   self.nextthink = time + 0.05;
};

void () reload_psg3 = [1, reload_psg4]
{
   self.weaponframe = 7;
   self.nextthink = time + 0.05;
};

void () reload_psg4 = [1, reload_psg5]
{
   self.weaponframe = 8;
   self.nextthink = time + 0.05;
};

void () reload_psg5 = [1, reload_psg6]
{
   self.weaponframe = 9;
   self.nextthink = time + 0.05;
};

void () reload_psg6 = [1, reload_psg7]
{
   self.weaponframe = 10;
   self.nextthink = time + 0.05;
};

void () reload_psg7 = [1, reload_psg8]
{
   self.weaponframe = 11;
   self.nextthink = time + 0.05;
};

void () reload_psg8 = [1, reload_psg9]
{
   self.weaponframe = 12;
   self.nextthink = time + 0.05;
};

void () reload_psg9 = [1, reload_psg10]
{
   self.weaponframe = 13;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/mp5out.wav",1,ATTN_NORM);
};

void () reload_psg10 = [1, reload_psg11]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.05;
};

void () reload_psg11 = [1, reload_psg12]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.05;
};

void () reload_psg12 = [1, reload_psg13]
{
   self.weaponframe = 16;
   self.nextthink = time + 0.05;
};

void () reload_psg13 = [1, reload_psg14]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.05;
};

void () reload_psg14 = [1, reload_psg15]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.05;
};

void () reload_psg15 = [1, reload_psg16]
{
   self.weaponframe = 19;
   self.nextthink = time + 0.05;
};

void () reload_psg16 = [1, reload_psg17]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.05;
};

void () reload_psg17 = [1, reload_psg18]
{
   self.weaponframe = 21;
   self.nextthink = time + 0.5;
};

void () reload_psg18 = [1, reload_psg19]
{
   self.weaponframe = 21;
   self.nextthink = time + 0.05;
};

void () reload_psg19 = [1, reload_psg20]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.05;
};

void () reload_psg20 = [1, reload_psg21]
{
   self.weaponframe = 19;
   self.nextthink = time + 0.05;
};

void () reload_psg21 = [1, reload_psg22]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.05;
};

void () reload_psg22 = [1, reload_psg23]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.05;
};

void () reload_psg23 = [1, reload_psg24]
{
   self.weaponframe = 16;
   self.nextthink = time + 0.05;
};

void () reload_psg24 = [1, reload_psg25]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.05;
};

void () reload_psg25 = [1, reload_psg26]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.05;
};

void () reload_psg26 = [1, reload_psg27]
{
   self.weaponframe = 22;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);
};

void () reload_psg27 = [1, reload_psg28]
{
   self.weaponframe = 23;
   self.nextthink = time + 0.05;
};

void () reload_psg28 = [1, reload_psg29]
{
   self.weaponframe = 24;
   self.nextthink = time + 0.05;
};

void () reload_psg29 = [1, reload_psg30]
{
   self.weaponframe = 25;
   self.nextthink = time + 0.05;
};

void () reload_psg30 = [1, reload_psg31]
{
   self.weaponframe = 26;
   self.nextthink = time + 0.05;
};

void () reload_psg31 = [1, reload_psg32]
{
   self.weaponframe = 27;
   self.nextthink = time + 0.05;
};

void () reload_psg32 = [1, reload_psg33]
{
   self.weaponframe = 28;
   self.nextthink = time + 0.05;
};

void () reload_psg33 = [1, reload_psg34]
{
   self.weaponframe = 29;
   self.nextthink = time + 0.05;
};

void () reload_psg34 = [1, reload_psg35]
{
   self.weaponframe = 30;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/clipslap.wav",1,ATTN_NORM); 
};

void () reload_psg35 = [1, reload_psg36]
{
   self.weaponframe = 31;
   self.nextthink = time + 0.05;
};

void () reload_psg36 = [1, reload_psg37]
{
   self.weaponframe = 32;
   self.nextthink = time + 0.05;
};

void () reload_psg37 = [1, reload_psg38]
{
   self.weaponframe = 33;
   self.nextthink = time + 0.05;
};

void () reload_psg38 = [1, reload_psg39]
{
   self.weaponframe = 34;
   self.nextthink = time + 0.05;
};

void () reload_psg39 = [1, reload_psg40]
{
   self.weaponframe = 35;
   self.nextthink = time + 0.05;
};

void () reload_psg40 = [1, reload_psg41]
{
   self.weaponframe = 36;
   self.nextthink = time + 0.05;
};

void () reload_psg41 = [1, reload_psg42]
{
   self.weaponframe = 37;
   self.nextthink = time + 0.05;
};

void () reload_psg42 = [1, reload_psg43]
{
   self.weaponframe = 38;
   self.nextthink = time + 0.05;
};

void () reload_psg43 = [1, reload_psg44]
{
   self.weaponframe = 39;
   self.nextthink = time + 0.05;
};

void () reload_psg44 = [1, reload_psg45]
{
   self.weaponframe = 40;
   self.nextthink = time + 0.05;
};

void () reload_psg45 = [1, player_run]
{
   self.weaponframe = 41;
   self.nextthink = time + 0.05;
   if((self.ammo_rockets >= 1) && (self.ammo_rockets <= 20) )
   {
     self.psg1clip = self.ammo_rockets; 
     self.ammo_rockets = 0;
   }
   else
   {
     self.psg1clip = 20.000;
     self.ammo_rockets = (self.ammo_rockets - 20.000);
   }
   W_SetCurrentAmmo();
};

/******************************************/
/*       Barrett Sniper Rifle             */
/******************************************/

void () player_barrett = [1, barrettb]
{
   self.weaponframe = 1;
   self.nextthink = time + 0.05;
   self.effects = self.effects | EF_MUZZLEFLASH;
   sound(self,CHAN_WEAPON,"weapons/barrett.wav",1,ATTN_NORM);
   W_FireBarrett ();
   self.fire = 1;
};

void () barrettb = [2, barrettc]
{
   self.weaponframe = 2;
   self.nextthink = time + 0.05;
};

void () barrettc = [2, barrettd]
{
   self.weaponframe = 3;
   self.nextthink = time + 0.05;
};

void () barrettd = [2, barrette]
{
   self.weaponframe = 4;
   self.nextthink = time + 0.05;
};

void () barrette = [2, player_run]
{
   self.weaponframe = 0;
   self.nextthink = time + 0.5;
};

void () player_reload_barrett = [1, reload_barrett2]
{
   self.weaponframe = 5;
   self.nextthink = time + 0.05;
   self.reload = 1;
};

void () reload_barrett2 = [1, reload_barrett3]
{
   self.weaponframe = 6;
   self.nextthink = time + 0.05;
};

void () reload_barrett3 = [1, reload_barrett4]
{
   self.weaponframe = 7;
   self.nextthink = time + 0.05;
};

void () reload_barrett4 = [1, reload_barrett5]
{
   self.weaponframe = 8;
   self.nextthink = time + 0.05;
};

void () reload_barrett5 = [1, reload_barrett6]
{
   self.weaponframe = 9;
   self.nextthink = time + 0.05;
};

void () reload_barrett6 = [1, reload_barrett7]
{
   self.weaponframe = 10;
   self.nextthink = time + 0.05;
};

void () reload_barrett7 = [1, reload_barrett8]
{
   self.weaponframe = 11;
   self.nextthink = time + 0.05;
};

void () reload_barrett8 = [1, reload_barrett9]
{
   self.weaponframe = 12;
   self.nextthink = time + 0.05;
};

void () reload_barrett9 = [1, reload_barrett10]
{
   self.weaponframe = 13;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/mp5out.wav",1,ATTN_NORM);
};

void () reload_barrett10 = [1, reload_barrett11]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.05;
};

void () reload_barrett11 = [1, reload_barrett12]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.05;
};

void () reload_barrett12 = [1, reload_barrett13]
{
   self.weaponframe = 16;
   self.nextthink = time + 0.05;
};

void () reload_barrett13 = [1, reload_barrett14]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.05;
};

void () reload_barrett14 = [1, reload_barrett15]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.05;
};

void () reload_barrett15 = [1, reload_barrett16]
{
   self.weaponframe = 19;
   self.nextthink = time + 0.05;
};

void () reload_barrett16 = [1, reload_barrett17]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.05;
};

void () reload_barrett17 = [1, reload_barrett18]
{
   self.weaponframe = 21;
   self.nextthink = time + 0.5;
};

void () reload_barrett18 = [1, reload_barrett19]
{
   self.weaponframe = 21;
   self.nextthink = time + 0.05;
};

void () reload_barrett19 = [1, reload_barrett20]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.05;
};

void () reload_barrett20 = [1, reload_barrett21]
{
   self.weaponframe = 19;
   self.nextthink = time + 0.05;
};

void () reload_barrett21 = [1, reload_barrett22]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.05;
};

void () reload_barrett22 = [1, reload_barrett23]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.05;
};

void () reload_barrett23 = [1, reload_barrett24]
{
   self.weaponframe = 16;
   self.nextthink = time + 0.05;
};

void () reload_barrett24 = [1, reload_barrett25]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.05;
};

void () reload_barrett25 = [1, reload_barrett26]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.05;
};

void () reload_barrett26 = [1, reload_barrett27]
{
   self.weaponframe = 22;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);
};

void () reload_barrett27 = [1, reload_barrett28]
{
   self.weaponframe = 23;
   self.nextthink = time + 0.05;
};

void () reload_barrett28 = [1, reload_barrett29]
{
   self.weaponframe = 24;
   self.nextthink = time + 0.05;
};

void () reload_barrett29 = [1, reload_barrett30]
{
   self.weaponframe = 25;
   self.nextthink = time + 0.05;
};

void () reload_barrett30 = [1, reload_barrett31]
{
   self.weaponframe = 26;
   self.nextthink = time + 0.05;
};

void () reload_barrett31 = [1, reload_barrett32]
{
   self.weaponframe = 27;
   self.nextthink = time + 0.05;
};

void () reload_barrett32 = [1, reload_barrett33]
{
   self.weaponframe = 28;
   self.nextthink = time + 0.05;
};

void () reload_barrett33 = [1, reload_barrett34]
{
   self.weaponframe = 29;
   self.nextthink = time + 0.05;
};

void () reload_barrett34 = [1, reload_barrett35]
{
   self.weaponframe = 30;
   self.nextthink = time + 0.05;
   sound(self,CHAN_WEAPON,"weapons/clipslap.wav",1,ATTN_NORM); 
};

void () reload_barrett35 = [1, reload_barrett36]
{
   self.weaponframe = 31;
   self.nextthink = time + 0.05;
};

void () reload_barrett36 = [1, reload_barrett37]
{
   self.weaponframe = 32;
   self.nextthink = time + 0.05;
};

void () reload_barrett37 = [1, reload_barrett38]
{
   self.weaponframe = 33;
   self.nextthink = time + 0.05;
};

void () reload_barrett38 = [1, reload_barrett39]
{
   self.weaponframe = 34;
   self.nextthink = time + 0.05;
};

void () reload_barrett39 = [1, reload_barrett40]
{
   self.weaponframe = 35;
   self.nextthink = time + 0.05;
};

void () reload_barrett40 = [1, reload_barrett41]
{
   self.weaponframe = 36;
   self.nextthink = time + 0.05;
};

void () reload_barrett41 = [1, reload_barrett42]
{

   self.weaponframe = 37;
   self.nextthink = time + 0.05;
};

void () reload_barrett42 = [1, reload_barrett43]
{
   self.weaponframe = 38;
   self.nextthink = time + 0.05;
};

void () reload_barrett43 = [1, reload_barrett44]
{
   self.weaponframe = 39;
   self.nextthink = time + 0.05;
};

void () reload_barrett44 = [1, reload_barrett45]
{
   self.weaponframe = 40;
   self.nextthink = time + 0.05;
};

void () reload_barrett45 = [1, player_run]
{
   self.weaponframe = 41;
   self.nextthink = time + 0.05;
   if ((self.ammo_rockets >= 1) && (self.ammo_rockets <= 20) )
   {
          self.psg1clip = self.ammo_rockets; 
          self.ammo_rockets = 0;
   }
   else
   {
          self.psg1clip = 20.000;
          self.ammo_rockets = (self.ammo_rockets - 20.000);
   }
   W_SetCurrentAmmo();
      
};

/******************************************/
/*         Assault Shotgun                */
/******************************************/

void () player_assaultshotgun = [1, assaultshotgun2]
{
   self.weaponframe = 1;
   self.nextthink = time + 0.05;
   self.effects = self.effects | EF_MUZZLEFLASH;
   sound(self,CHAN_WEAPON,"weapons/ashotfir.wav",1,ATTN_NORM);
   W_FireAssaultShotgun ();
   self.fire = 1;
};

void () assaultshotgun2 = [2, assaultshotgun3]
{
   self.weaponframe = 2;
   self.nextthink = time + 0.05;
};

void () assaultshotgun3 = [2, assaultshotgun4]
{
   sound(self,CHAN_BODY,"weapons/ashotcok.wav",1,ATTN_NORM);
   self.weaponframe = 3;
   self.nextthink = time + 0.05;
};

void () assaultshotgun4 = [2, assaultshotgun5]
{
   local vector dir;

   makevectors(self.v_angle);     
   eject_shell (((self.origin + (v_forward * 18.000))  + (v_up * 13.000)),dir);
//   sound(self,CHAN_BODY,"weapons/ashotrot.wav",1,ATTN_NORM);
   self.weaponframe = 4;
   self.nextthink = time + 0.05;
};

void () assaultshotgun5 = [2, assaultshotgun6]
{
   self.weaponframe = 5;
   self.nextthink = time + 0.05;
};

void () assaultshotgun6 = [2, player_run]
{
   self.weaponframe = 6;
   self.nextthink = time + 0.1;
};

/******************************************/
/*         Hand Grenades                  */
/******************************************/

void () player_hgrenade = [1, hgrenade2]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 1;
   self.nextthink = time + 0.035;
   self.fire = 1;
};

void () hgrenade2 = [2, hgrenade3]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 2;
   self.nextthink = time + 0.035;
};

void () hgrenade3 = [3, hgrenade4]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 3;
   self.nextthink = time + 0.035;
};

void () hgrenade4 = [2, hgrenade5]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 4;
   self.nextthink = time + 0.035;
};

void () hgrenade5 = [3, hgrenade6]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 5;
   self.nextthink = time + 0.035;
};

void () hgrenade6 = [2, hgrenade7]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 6;
   self.nextthink = time + 0.035;
};

void () hgrenade7 = [3, hgrenade8]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 7;
   self.nextthink = time + 0.035;
};

void () hgrenade8 = [2, hgrenade9]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 8;
   self.nextthink = time + 0.035;
};

void () hgrenade9 = [3, hgrenade10]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 9;
   sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
   self.nextthink = time + 0.035;
};

void () hgrenade10 = [1, hgrenade11]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 10;
   self.nextthink = time + 0.035;
};

void () hgrenade11 = [2, hgrenade12]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 11;
   self.nextthink = time + 0.035;
};

void () hgrenade12 = [3, hgrenade13]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 12;
   self.nextthink = time + 0.035;
};

void () hgrenade13 = [2, hgrenade14]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 13;
   self.nextthink = time + 0.035;
};

void () hgrenade14 = [3, hgrenade15]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 14;
   self.nextthink = time + 0.035;
};

void () hgrenade15 = [2, hgrenade16]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 15;
   self.nextthink = time + 0.035;
};

void () hgrenade16 = [3, hgrenade17]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 16;
   self.nextthink = time + 0.035;
};

void () hgrenade17 = [2, hgrenade18]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 17;
   self.nextthink = time + 0.035;
};

void () hgrenade18 = [3, hgrenade19]
{
   if (self.button0)
    {
     self.grenadetime = self.grenadetime + 1;
     self.attack_finished = self.attack_finished + 0.05;
    }
   self.weaponframe = 18;
   self.nextthink = time + 0.035;
};

void () hgrenade20;

void () hgrenade19 = [1, hgrenade19]
{
   if (self.button0)
    {
     if (self.grenadetime > 40)
      {
       self.nextthink = time + 0.05; 
       self.attack_finished = self.attack_finished + 0.05;
      }
     else
      {
       self.grenadetime = self.grenadetime + 1;      
       self.nextthink = time + 0.05;
       self.attack_finished = self.attack_finished + 0.05;
      }
    }
   else
    {
     self.nextthink = time + 0.05;
     self.attack_finished = time + 1.5;
     self.think = hgrenade20;
    }
};

void () hgrenade20 = [2, hgrenade22]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.025;
};

void () hgrenade21 = [3, hgrenade22]
{
   self.weaponframe = 21;
   self.nextthink = time + 0.025;
};

void () hgrenade22 = [2, hgrenade24]
{
   self.weaponframe = 22;
   self.nextthink = time + 0.025;
};

void () hgrenade23 = [3, hgrenade24]
{
   self.weaponframe = 23;
   self.nextthink = time + 0.025;
};

void () hgrenade24 = [2, hgrenade25]
{
   self.weaponframe = 24;
   self.nextthink = time + 0.025;
};

void () hgrenade25 = [3, hgrenade26]
{
   self.weaponframe = 25;
   self.nextthink = time + 0.025;
};

void () hgrenade26 = [2, hgrenade27]
{
   self.weaponframe = 26;
   self.nextthink = time + 0.025;
};

void () hgrenade27 = [3, hgrenade28]
{
   self.weaponframe = 27;
   self.nextthink = time + 0.025;
   W_FireHandGrenade ();
};

void () hgrenade28 = [1, hgrenade29]
{
   self.weaponframe = 28;
   self.nextthink = time + 0.05;
};

void () hgrenade29 = [2, hgrenade30]
{
   self.weaponframe = 29;
   self.nextthink = time + 0.05;
};

void () hgrenade30 = [3, hgrenade31]
{
   self.weaponframe = 30;
   self.nextthink = time + 0.05;
};

void () hgrenade31 = [2, hgrenade32]
{
   self.weaponframe = 31;
   self.nextthink = time + 0.05;
};

void () hgrenade32 = [3, hgrenade33]
{
   self.weaponframe = 32;
   self.nextthink = time + 0.05;
};

void () hgrenade33 = [2, hgrenade34]
{
   self.weaponframe = 33;
   self.nextthink = time + 0.05;
};

void () hgrenade34 = [3, hgrenade35]
{
   self.weaponframe = 34;
   self.nextthink = time + 0.05;
};

void () hgrenade35 = [2, hgrenade36]
{
   self.weaponframe = 35;
   self.nextthink = time + 0.05;
};

void () hgrenade36 = [3, hgrenade37]
{
   self.weaponframe = 36;
   self.nextthink = time + 0.05;
};

void () hgrenade37 = [2, hgrenade38]
{
   self.weaponframe = 37;
   self.nextthink = time + 0.05;
};

void () hgrenade38 = [3, player_run]
{
   self.weaponframe = 38;
   self.nextthink = time + 0.05;
};

/******************************************/
/*         KBAR                           */
/******************************************/

void () player_kbarb;

void () player_kbar = [103, kbara2]
{
   self.weaponframe = 1;
   self.fire = 1;
   self.attack_finished = self.attack_finished + 0.025;
   self.nextthink = time + 0.025;
};

void () kbara2 = [103, kbara3]
{
   self.weaponframe = 2;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbara3 = [103, kbara4]
{
   self.weaponframe = 3;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbara4 = [103, kbara5]
{
   self.weaponframe = 4;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbara5 = [103, kbara6]
{
   self.weaponframe = 5;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbara6 = [103, kbara7]
{
   self.weaponframe = 6; 
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbara7 = [103, kbara8]
{
   self.weaponframe = 7;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
   sound(self,CHAN_WEAPON,"weapons/swoosh.wav",TRUE,ATTN_NORM);
   W_FireKbar ();
};

void () kbara8 = [103, kbara9]
{
   self.weaponframe = 8;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
   makevectors(self.v_angle);
   W_FireKbar ();
   traceline (self.origin + '0 0 16',(self.origin + '0 0 16') + v_forward*64, FALSE, self);
   if ( (self.button0 == 0) || (trace_fraction == 1) )
    {
     self.think = player_kbarb;
    }
};

void () kbara9 = [103, kbara10]
{
   self.weaponframe = 9;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara10 = [103, kbara11]
{
   self.weaponframe = 10;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara11 = [103, kbara12]
{
   self.weaponframe = 11;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara12 = [103, kbara13]
{
   self.weaponframe = 12;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () kbara13 = [103, kbara14]
{
   self.weaponframe = 13;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () kbara14 = [103, kbara15]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () kbara15 = [103, kbara16]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.035;
   self.attack_finished = time + 0.35;
   W_FireKbar ();
};

void () kbara16 = [103, kbara17]
{
   self.weaponframe = 16; 
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () kbara17 = [103, kbara18]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () kbara18 = [103, kbara19]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara19 = [103, kbara20]
{
   self.weaponframe = 19;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara20 = [103, kbara21]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara21 = [103, kbara22]
{
   self.weaponframe = 21; 
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () kbara22 = [103, kbara23]
{
   self.weaponframe = 22;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara23 = [103, kbara24]
{
   self.weaponframe = 23;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara24 = [103, kbara25]
{
   self.weaponframe = 24;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
   W_FireKbar ();
};

void () kbara25 = [103, player_run]
{
   self.weaponframe = 25;
   self.nextthink = time + 0.035;
   self.attack_finished = self.attack_finished + 0.035;
};

void () player_kbarb = [1, kbarb2]
{
   self.weaponframe = 7;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbarb2 = [1, kbarb3]
{
   self.weaponframe = 6;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
   W_FireKbar ();
};

void () kbarb3 = [1, kbarb4]
{
   self.weaponframe = 5;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
   W_FireKbar ();
};

void () kbarb4 = [1, kbarb5]
{
   self.weaponframe = 4;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbarb5 = [1, kbarb6]
{
   self.weaponframe = 3;
   self.nextthink = time + 0.025;
   self.attack_finished = self.attack_finished + 0.025;
};

void () kbarb6 = [1, player_run]
{
   self.weaponframe = 2;
   self.nextthink = time + 0.025;
   self.attack_finished = time + 0.25;
};


/******************************************/
/*         M-16 Assault Rifle             */
/******************************************/

void () player_reload_m16 = [ 103.000, m16_reload2 ] {

   self.weaponframe = 5;
   self.nextthink = time + 0.04;
   self.reload = 1;
};

void () m16_reload2 = [ 103.000, m16_reload3 ] {

   self.weaponframe = 6;
   self.nextthink = time + 0.04;
};

void () m16_reload3 = [ 103.000, m16_reload4 ] {

   self.weaponframe = 7;
   self.nextthink = time + 0.04;
};

void () m16_reload4 = [ 103.000, m16_reload5 ] {

   self.weaponframe = 8;
   self.nextthink = time + 0.04;
};

void () m16_reload5 = [ 103.000, m16_reload6 ] {

   self.weaponframe = 9;
   self.nextthink = time + 0.04;
};

void () m16_reload6 = [ 103.000, m16_reload7 ] {

   self.weaponframe = 10;
   self.nextthink = time + 0.04;
};

void () m16_reload7 = [ 103.000, m16_reload8 ] {

   self.weaponframe = 11;
   self.nextthink = time + 0.04;

};

void () m16_reload8 = [ 103.000, m16_reload9 ] {

   self.weaponframe = 12.000;
   self.nextthink = time + 0.04;
   sound(self,CHAN_WEAPON,"weapons/mp5out.wav",TRUE,ATTN_NORM);
};

void () m16_reload9 = [ 103.000, m16_reload10 ] {

   self.weaponframe = 13.000;
   self.nextthink = time + 0.04;

};

void () m16_reload10 = [ 103.000, m16_reload11 ] {

   self.weaponframe = 14.000;
   self.nextthink = time + 0.04;

};

void () m16_reload11 = [ 103.000, m16_reload12 ] {

   self.weaponframe = 15.000;
   self.nextthink = time + 0.04;

};

void () m16_reload12 = [ 103.000, m16_reload13 ] {

   self.weaponframe = 16.000;
   self.nextthink = time + 0.04;

};

void () m16_reload13 = [ 103.000, m16_reload14 ] {

   self.weaponframe = 17;
   self.nextthink = time + 0.04;

};

void () m16_reload14 = [ 18.000, m16_reload15 ] {

   self.weaponframe = 18.000;
   self.nextthink = time + 0.04;

};

void () m16_reload15 = [ 19.000, m16_reload16 ] {

   self.weaponframe = 19;
   self.nextthink = time + 0.04;

};

void () m16_reload16 = [ 18.000, m16_reload17 ] {

   self.weaponframe = 20.000;
   self.nextthink = time + 0.04;
};

void () m16_reload17 = [ 19.000, m16_reload18 ] {

   self.weaponframe = 19;
   self.nextthink = time + 0.04;
};

void () m16_reload18 = [ 18.000, m16_reload19 ] {

   self.weaponframe = 18;
   self.nextthink = time + 0.04;
};

void () m16_reload19 = [ 19.000, m16_reload20 ] {

   self.weaponframe = 17;
   self.nextthink = time + 0.04;
};

void () m16_reload20 = [ 18.000, m16_reload21 ] {

   self.weaponframe = 16;
   self.nextthink = time + 0.04;
};

void () m16_reload21 = [ 19.000, m16_reload22 ] {

   self.weaponframe = 15.000;
   self.nextthink = time + 0.04;
};

void () m16_reload22 = [ 103.000, m16_reload23 ] {

   self.weaponframe = 14;
   self.nextthink = time + 0.04;
};

void () m16_reload23 = [ 103.000, m16_reload24 ] {

   self.weaponframe = 13;
   self.nextthink = time + 0.04;
};

void () m16_reload24 = [ 103.000, m16_reload25 ] {

   self.weaponframe = 12;
   self.nextthink = time + 0.04;
   sound(self,CHAN_WEAPON,"weapons/mp5in.wav",TRUE,ATTN_NORM);
};

void () m16_reload25 = [ 103.000, m16_reload26 ] {

   self.weaponframe = 21;
   self.nextthink = time + 0.04;
};

void () m16_reload26 = [ 103.000, m16_reload27 ] {

   self.weaponframe = 22;
   self.nextthink = time + 0.04;
};

void () m16_reload27 = [ 103.000, m16_reload28 ] {

   self.weaponframe = 23;
   self.nextthink = time + 0.04;

};

void () m16_reload28 = [ 103.000, m16_reload29 ] {

   self.weaponframe = 24.000;
   self.nextthink = time + 0.04;

};

void () m16_reload29 = [ 103.000, m16_reload30 ] {

   self.weaponframe = 25.000;
   self.nextthink = time + 0.04;

};

void () m16_reload30 = [ 103.000, m16_reload31 ] {

   self.weaponframe = 26.000;
   self.nextthink = time + 0.04;
   sound(self,CHAN_WEAPON,"weapons/slide.wav",TRUE,ATTN_NORM);
};

void () m16_reload31 = [ 103.000, m16_reload32 ] {

   self.weaponframe = 27.000;
   self.nextthink = time + 0.04;

};

void () m16_reload32 = [ 103.000, m16_reload33 ] {

   self.weaponframe = 28.000;
   self.nextthink = time + 0.04;

};

void () m16_reload33 = [ 103.000, m16_reload34 ] {

   self.weaponframe = 29;
   self.nextthink = time + 0.04;

};

void () m16_reload34 = [ 18.000, m16_reload35 ] {

   self.weaponframe = 30.000;
   self.nextthink = time + 0.04;

};

void () m16_reload35 = [ 19.000, m16_reload36 ] {

   self.weaponframe = 31;
   self.nextthink = time + 0.04;

};

void () m16_reload36 = [ 18.000, m16_reload37 ] {

   self.weaponframe = 32.000;
   self.nextthink = time + 0.04;
};

void () m16_reload37 = [ 19.000, m16_reload38 ] {

   self.weaponframe = 33;
   self.nextthink = time + 0.04;
};

void () m16_reload38 = [ 18.000, m16_reload39 ] {

   self.weaponframe = 34;
   self.nextthink = time + 0.04;
};

void () m16_reload39 = [ 19.000, m16_reload40 ] {

   self.weaponframe = 35;
   self.nextthink = time + 0.04;
};

void () m16_reload40 = [ 18.000, m16_reload41 ] {

   self.weaponframe = 36;
   self.nextthink = time + 0.04;
};

void () m16_reload41 = [ 19.000, m16_reload42 ] {

   self.weaponframe = 37.000;
   self.nextthink = time + 0.04;
};

void () m16_reload42 = [ 19.000, player_run ] {

   self.weaponframe = 38.000;
   self.nextthink = time + 0.04;
   if ((self.ammo_nails >= 1) && (self.ammo_nails <= 40))
   {
      self.m16clip = self.ammo_nails; 
      self.ammo_nails = 0;
   }
   else
   {
      self.m16clip = 40;
      self.ammo_nails = self.ammo_nails - 40;
   }
   W_SetCurrentAmmo();
     
};

void() player_m16_grenade = [1, m16_grenade2]
{
   self.weaponframe = 39;
   self.nextthink = time + 0.05;
   W_FireM16Grenade ();
   self.fire = 1;
};

void() m16_grenade2 = [1, m16_grenade3]
{  
   self.weaponframe = 40;
   self.nextthink = time + 0.05;
};

void() m16_grenade3 = [1, m16_grenade4]
{
   self.weaponframe = 41;
   self.nextthink = time + 0.05;
};

void() m16_grenade4 = [1,m16_grenade5]
{
   self.weaponframe = 42;
   self.nextthink = time + 0.05;
};

void() m16_grenade5 = [1, m16_grenade6]
{
   self.weaponframe = 43;
   self.nextthink = time + 0.05;
};

void() m16_grenade6 = [1, m16_grenade7]
{  
   self.weaponframe = 44;
   self.nextthink = time + 0.05;
};

void() m16_grenade7 = [1, m16_grenade8]
{
   self.weaponframe = 45;
   self.nextthink = time + 0.05;
};

void() m16_grenade8 = [1,player_run]
{
   self.weaponframe = 46;
   self.nextthink = time + 0.05;
};


/******************************************/
/*    M-16 with RAW Rocket Launcher       */
/******************************************/

void() player_raw = [1, raw2]
{
   self.weaponframe = 1;
   self.nextthink = time + 0.05;
   W_FireRaw ();
   self.fire = 1;
   self.reload = 1;
};

void() raw2 = [1, raw3]
{  
   self.weaponframe = 2;
   self.nextthink = time + 0.05;
};

void() raw3 = [1, raw4]
{
   self.weaponframe = 3;
   self.nextthink = time + 0.05;
};

void() raw4 = [1, raw5]
{
   self.weaponframe = 4;
   self.nextthink = time + 0.05;
};

void() raw5 = [1, raw6]
{
   self.weaponframe = 5;
   self.nextthink = time + 0.05;
};

void() raw6 = [1, raw7]
{  
   self.weaponframe = 6;
   self.nextthink = time + 0.05;
};

void() raw7 = [1, raw8]
{
   self.weaponframe = 7;
   self.nextthink = time + 0.05;
};

void() raw8 = [1, raw9]
{
   self.weaponframe = 8;
   self.nextthink = time + 0.05;
};

void() raw9 = [1, raw10]
{
   self.weaponframe = 9;
   self.nextthink = time + 0.05;
};

void() raw10 = [1, raw11]
{
   self.weaponframe = 10;
   self.nextthink = time + 0.05;
};

void() raw11 = [1, raw12]
{
   self.weaponframe = 11;
   self.nextthink = time + 0.05;
};

void() raw12 = [1, raw13]
{
   self.weaponframe = 12;
   self.nextthink = time + 0.05;
};

void() raw13 = [1, raw14]
{
   self.weaponframe = 13;
   self.nextthink = time + 0.5;
};

void() raw14 = [1, raw15]
{
   self.weaponframe = 14;
   self.nextthink = time + 0.05;
};

void() raw15 = [1, raw16]
{
   self.weaponframe = 15;
   self.nextthink = time + 0.05;
};

void() raw16 = [1, raw17]
{
   self.weaponframe = 16;
   self.nextthink = time + 0.05;
};

void() raw17 = [1, raw18]
{
   self.weaponframe = 17;
   self.nextthink = time + 0.05;
};

void() raw18 = [1, raw19]
{
   self.weaponframe = 18;
   self.nextthink = time + 0.05;
};

void() raw19 = [1, raw20]
{
   self.weaponframe = 8;
   self.nextthink = time + 0.05;
};

void() raw20 = [1,player_run]
{
   self.weaponframe = 20;
   self.nextthink = time + 0.05;
};

void() player_m16a = [1, player_m16a2]
{
   self.fire = 1;
   self.effects = self.effects | EF_MUZZLEFLASH;
   self.weaponframe = 1;
   self.nextthink = time + 0.03;
   self.punchangle_z = -1;
   W_FireM16 ();
   sound(self,CHAN_WEAPON,"weapons/m16fire.wav",TRUE,ATTN_NORM);
};

void() player_m16a2 = [1, player_m16a3]
{
   self.weaponframe = 2;
   self.nextthink = time + 0.03;
//   self.attack_finished = self.attack_finished + 0.06;
};

void() player_m16a3 = [1, player_m16b]
{
   self.weaponframe = 0;
   self.nextthink = time + 0.03;
//   self.attack_finished = self.attack_finished + 0.03;
   if ( (self.button0 == 0) || (self.m16clip <= 0) )
    self.think = player_run;
};


void() player_m16b = [1, player_m16b2]
{
   self.effects = self.effects | EF_MUZZLEFLASH;
   self.weaponframe = 3;
   self.nextthink = time + 0.03;
   self.punchangle_z = -1;
   W_FireM16 ();
   sound(self,CHAN_WEAPON,"weapons/m16fire.wav",TRUE,ATTN_NORM);
};

void() player_m16b2 = [1, player_m16b3]
{
   self.weaponframe = 4;
   self.nextthink = time + 0.03;
//   self.attack_finished = self.attack_finished + 0.06;
};

void() player_m16b3 = [1, player_m16a]
{
   self.weaponframe = 0;
   self.nextthink = time + 0.05;
//   self.attack_finished = self.attack_finished + 0.03;
   if ( (self.button0 == 0) || (self.m16clip <= 0) )
    self.think = player_run;
};


/******************************************/
/*   MOSSBERG SHOTGUN                     */
/******************************************/

void() player_mossberg = [1, mossberg2] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;
      self.weaponframe = 1;
      self.nextthink = time + 0.03;
      self.punchangle_x = -2;
      self.punchangle_z = 2;
      sound(self,CHAN_WEAPON,"weapons/shotfire.wav",TRUE,ATTN_NORM);
      W_FireMossberg ();
      self.fire = 1;
};

void() mossberg2 = [2, mossberg3] 
{
      self.weaponframe = 2;
      self.nextthink = time + 0.03;
};

void() mossberg3 = [3, mossberg4] 
{
      self.weaponframe = 3;
      self.nextthink = time + 0.03;
};

void() mossberg4 = [4, mossberg5] 
{
      self.weaponframe = 4;
      self.nextthink = time + 0.05;
};

void() mossberg5 = [5, mossberg6] 
{
      self.weaponframe = 5;
      self.nextthink = time + 0.055;
};

void() mossberg6 = [6, mossberg7] 
{
      self.weaponframe = 6;
      self.nextthink = time + 0.06;
};

void() mossberg7 = [7, mossberg8] 
{
      self.weaponframe = 7;
      self.nextthink = time + 0.06;
};

void() mossberg8 = [8, mossberg9] 
{
      self.weaponframe = 8;
      self.nextthink = time + 0.06;
      sound(self,CHAN_AUTO,"weapons/cock1.wav",TRUE,ATTN_NORM);
};

void() mossberg9 = [9, mossberg10] 
{

      self.weaponframe = 9;
      self.nextthink = time + 0.06;
};

void() mossberg10 = [10, mossberg11] 
{
      self.weaponframe = 10;
      self.nextthink = time + 0.06;
};

void() mossberg11 = [11, mossberg12] 
{
      self.weaponframe = 11;
      self.nextthink = time + 0.06;
};

void() mossberg12 = [2, mossberg13] 
{
      local vector dir;
      self.weaponframe = 12;
      self.nextthink = time + 0.06;
      sound(self,CHAN_AUTO,"weapons/cock2.wav",TRUE,ATTN_NORM);
      makevectors(self.v_angle);     
      eject_shell (((self.origin + (v_forward * 18.000))  + (v_up * 13.000)),dir);
};

void() mossberg13 = [3, mossberg14] 
{
      self.weaponframe = 13;
      self.nextthink = time + 0.06;
};

void() mossberg14 = [9, mossberg15] 
{

      self.weaponframe = 14;
      self.nextthink = time + 0.065;
};

void() mossberg15 = [10, mossberg16] 
{
      self.weaponframe = 15;
      self.nextthink = time + 0.07;
};

void() mossberg16 = [10, player_run] 
{
      self.weaponframe = 16;
      self.nextthink = time + 0.07;
};


void() player_reload_mossberg = [10, reload_mossberg2]
{
        self.weaponframe = 17;
	self.nextthink = time + 0.02;
        self.reload = 1;
};

void() reload_mossberg2 = [10, reload_mossberg3]
{
	self.weaponframe = 17;
	self.nextthink = time + 0.05;
};

void() reload_mossberg3 = [10, reload_mossberg4]
{
	self.weaponframe = 18;
	self.nextthink = time + 0.05;
};

void() reload_mossberg4 = [10, reload_mossberg5]
{
	self.weaponframe = 19;
	self.nextthink = time + 0.05;
};

void() reload_mossberg5 = [10, reload_mossberg6]
{
	self.weaponframe = 20;
	self.nextthink = time + 0.05;
};

void() reload_mossberg6 = [10, reload_mossberg7]
{
	self.weaponframe = 21;
	self.nextthink = time + 0.05;
};

void() reload_mossberg7 = [10, reload_mossberg8]
{
	self.weaponframe = 22;
	self.nextthink = time + 0.05;
};

void() reload_mossberg8 = [10, reload_mossberg9]
{
	self.weaponframe = 23;
	self.nextthink = time + 0.05;
};

void() reload_mossberg9 = [10, reload_mossberg10]
{
	self.weaponframe = 24;
	self.nextthink = time + 0.05;
};

void() reload_mossberg10 = [10, reload_mossberg11]
{
	self.weaponframe = 25;
	self.nextthink = time + 0.05;
};

void() reload_mossberg11 = [10, reload_mossberg12]
{
	self.weaponframe = 26;
	self.nextthink = time + 0.05;
};

void() reload_mossberg12 = [10, reload_mossberg13]
{
	self.weaponframe = 27;
	self.nextthink = time + 0.05;
};

void() reload_mossberg13 = [10, reload_mossberg14]
{
	self.weaponframe = 28;
	self.nextthink = time + 0.05;
};

void() reload_mossberg14 = [10, reload_mossberg15]
{
	self.weaponframe = 29;
	self.nextthink = time + 0.05;
};

void() reload_mossberg15 = [10, reload_mossberg16]
{
	self.weaponframe = 30;
	self.nextthink = time + 0.05;
};

void() reload_mossberg16 = [10, reload_mossberg17]
{
	self.weaponframe = 31;
	self.nextthink = time + 0.05;
};

void() reload_mossberg17 = [10, reload_mossberg18]
{
	self.weaponframe = 32;
	self.nextthink = time + 0.05;
};

void() reload_mossberg18 = [10, reload_mossberg19]
{
	self.weaponframe = 33;
	self.nextthink = time + 0.05;
};

void() reload_mossberg19 = [10, reload_mossberg20]
{
	self.weaponframe = 34;
	self.nextthink = time + 0.05;
};

void() reload_mossberg20 = [10, reload_mossberg21]
{
	self.weaponframe = 35;
	self.nextthink = time + 0.05;
};

void() reload_mossberg21 = [10, reload_mossberg22]
{
	self.weaponframe = 36;
	self.nextthink = time + 0.05;
};

void() reload_mossberg22 = [10, reload_mossberg23]
{
	self.weaponframe = 37;
	self.nextthink = time + 0.05;
};

void() reload_mossberg23 = [10, reload_mossberg24]
{
	self.weaponframe = 38;
        if (self.mossclip == 8 || self.ammo_shells == 0)
	  self.think = reload_mossberg29;    
	self.nextthink = time + 0.05;
};

void() reload_mossberg24 = [10, reload_mossberg25]
{
	self.weaponframe = 39;
	self.nextthink = time + 0.05;
        sound(self,CHAN_AUTO,"weapons/mk23in.wav",TRUE,ATTN_NORM);
};

void() reload_mossberg25 = [10, reload_mossberg26]
{
	self.weaponframe = 40;
	self.nextthink = time + 0.05;
};

void() reload_mossberg26 = [10, reload_mossberg27]
{
	self.weaponframe = 41;
	self.nextthink = time + 0.05;
};

void() reload_mossberg27 = [10, reload_mossberg28]
{
	self.weaponframe = 42;
	self.nextthink = time + 0.05;
};

void() reload_mossberg28 = [10, reload_mossberg23]
{
	self.weaponframe = 43;
	self.nextthink = time + 0.05;
        if (self.use_clip_as_ammo)
        {
          self.currentammo = self.mossclip = self.mossclip + 1;
          self.ammo_shells = self.ammo_shells - 1;
        }
        else
        {
          self.mossclip = self.mossclip + 1;      
          self.currentammo = self.ammo_shells = self.ammo_shells - 1;
        }
};

void() reload_mossberg29 = [10, reload_mossberg30]
{
	self.weaponframe = 44;
	self.nextthink = time + 0.05;
};

void() reload_mossberg30 = [10, reload_mossberg31]
{
	self.weaponframe = 45;
	self.nextthink = time + 0.05;
      //sound(self,CHAN_AUTO,"weapons/mk23in.wav",TRUE,ATTN_NORM);
};

void() reload_mossberg31 = [10, reload_mossberg32]
{
	self.weaponframe = 46;
	self.nextthink = time + 0.05;
};

void() reload_mossberg32 = [10, reload_mossberg33]
{
	self.weaponframe = 47;
	self.nextthink = time + 0.05;
};

void() reload_mossberg33 = [10, reload_mossberg34]
{
	self.weaponframe = 48;
	self.nextthink = time + 0.05;
};

void() reload_mossberg34 = [10, reload_mossberg35]
{
	self.weaponframe = 49;
	self.nextthink = time + 0.05;
};

void() reload_mossberg35 = [10, reload_mossberg36]
{
	self.weaponframe = 50;
	self.nextthink = time + 0.05;
};

void() reload_mossberg36 = [10, reload_mossberg37]
{
	self.weaponframe = 51;
	self.nextthink = time + 0.05;
};

void() reload_mossberg37 = [10, player_run]
{
	self.weaponframe = 52;
	self.nextthink = time + 0.05;
};


/********************MP5 SEQUENCE**************/

void () player_reload_mp5 = [ 103.000, player_reload_mp5 ] 
{
   self.weaponframe = self.weaponframe + 1;
   self.nextthink = time + 0.04;
   self.reload = 1;
   if (self.weaponframe == 12)
    sound(self,CHAN_WEAPON,"weapons/mp5out.wav",1,ATTN_NORM);
   if (self.weaponframe == 28)
    sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);
   if (self.weaponframe == 39)
    sound(self,CHAN_WEAPON,"weapons/slide.wav",1,ATTN_NORM);
   if (self.weaponframe == 54)
    {
      if((self.ammo_nails >= 1.000) && (self.ammo_nails <= 30))
      {
        self.mp5clip = self.ammo_nails;
        self.ammo_nails = 0;
      }
      else
      {
        self.mp5clip = 30;
        self.ammo_nails = self.ammo_nails - 30;
      }
      W_SetCurrentAmmo();
      self.think = player_run;
    }
};

void () player_mp5g = [ 103.000, player_mp5g2 ] 
{
   self.effects = self.effects | EF_MUZZLEFLASH;
   self.weaponframe = 55;
   self.nextthink = time + 0.03;
   self.fire = 1;
   W_FireMP5 ();
   self.muzzleclimb = 0;
};

void () player_mp5g2 = [103, player_mp5g3 ]
{
   self.weaponframe = 56;
   self.nextthink = time + 0.03;
};
 
void () player_mp5g3 = [104, player_run]
{
   self.weaponframe = 57;
   self.nextthink = time + 0.15;
};

void () player_mp5a = [ 103.000, player_mp5a2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   self.weaponframe = 55;  
   self.nextthink = time + 0.025;
   self.attack_finished = time + 0.085;

   self.fire = 1;
   W_FireMP5 ();
   self.muzzleclimb = 0;
};

void () player_mp5a2 = [ 103, player_mp5a3 ] {
   
   self.weaponframe = 56;
   self.nextthink = time + 0.025;
};

void () player_mp5a3 = [ 103, player_mp5b ] {
   
   self.weaponframe = 57;
   self.nextthink = time + 0.025;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
    {
     self.think = player_run;
     self.attack_finished = time + 0.05;
    }
};


void () player_mp5b = [ 103 , player_mp5b2]
 {
   self.effects = (self.effects | EF_MUZZLEFLASH);
   self.weaponframe = 58;
   self.attack_finished = time + 0.085;

   self.nextthink = time + 0.025;
   W_FireMP5 ();
   self.muzzleclimb = 1;
 };

void () player_mp5b2 = [ 103, player_mp5b3 ] {
   
   self.weaponframe = 59;
   self.nextthink = time + 0.025;
};

void () player_mp5b3 = [ 103, player_mp5c ] {
   
   self.weaponframe = 60;
   self.nextthink = time + 0.025;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
      {
       self.think = player_run;
       self.attack_finished = self.attack_finished + 0.05;
      }
};

void () player_mp5c = [ 103 , player_mp5c2]
 {
   self.effects = (self.effects | EF_MUZZLEFLASH);
   self.weaponframe = 61;
   self.attack_finished = time + 0.085;

   self.nextthink = time + 0.03;
   W_FireMP5 ();
   self.muzzleclimb = 2;
 };

void () player_mp5c2 = [ 103, player_mp5c3 ] {
   
   self.weaponframe = 62;
   self.nextthink = time + 0.025;
};

void () player_mp5c3 = [ 103, player_mp5d ] {
   
   self.weaponframe = 63;
   self.nextthink = time + 0.025;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
      {
       self.think = player_run;
       self.attack_finished = self.attack_finished + 0.05;
      }
};

void () player_mp5d = [ 103 , player_mp5d2]
 {
   self.effects = (self.effects | EF_MUZZLEFLASH);
   self.weaponframe = 64; 
   self.attack_finished = time + 0.085;

   self.nextthink = time + 0.025;
   W_FireMP5 ();
   self.muzzleclimb = 3;
 };

void () player_mp5d2 = [ 103, player_mp5d3 ] {
   
   self.weaponframe = 65;
   self.nextthink = time + 0.025;
};

void () player_mp5e;

void () player_mp5d3 = [ 103, player_mp5d ] {
   
   self.weaponframe = 66;
   self.nextthink = time + 0.025;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
      {
       self.think = player_mp5e;
       self.attack_finished = self.attack_finished + 0.05;
      }
};

void () player_mp5e = [103, player_run ]
{
    self.weaponframe = 67;
    self.nextthink = time + 0.04;
};

void () player_mp5f = [ 103, player_mp5f2]
{
    self.weaponframe = 55;

    self.nextthink = time + 0.03;
    W_FireMP5();
    self.fire = 1;
};

void () player_mp5f2 = [ 103, player_mp5f3]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.03;
};

void () player_mp5f3 = [ 103, player_mp5f4]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.03;
};

void () player_mp5f4 = [ 103, player_mp5f5]
{
    self.weaponframe = 55;
    if (self.mp5clip == 0)
    {
       player_run();
       return;
    }
    self.nextthink = time + 0.03;
    W_FireMP5();
};

void () player_mp5f5 = [ 103, player_mp5f6]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.03;
};

void () player_mp5f6 = [ 103, player_mp5f7]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.03;
};

void () player_mp5f7 = [ 103, player_mp5f8]
{
    self.weaponframe = 55;

    if (self.mp5clip == 0)
    {
       player_run();
       return;
    }

    self.nextthink = time + 0.03;
    W_FireMP5();
};

void () player_mp5f8 = [ 103, player_mp5f9]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.03;
};

void () player_mp5f9 = [ 103, player_run]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.2;
};

void () player_mp5_switch = [ 1, mp5_switch2 ]
{
    self.weaponframe = 1;
    self.nextthink = time + 0.04;
    self.reload = 1;
};

void () mp5_switch2 = [ 1, mp5_switch3 ]
{
    self.weaponframe = 55;
    self.nextthink = time + 0.04;
};

void () mp5_switch3 = [ 1, mp5_switch4 ]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.04;
};

void () mp5_switch4 = [ 1, mp5_switch5 ]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.04;
};

void () mp5_switch5 = [ 1, mp5_switch6 ]
{
    self.weaponframe = 58;
    self.nextthink = time + 0.04;
};

void () mp5_switch6 = [ 1, mp5_switch7 ]
{
    self.weaponframe = 59;
    self.nextthink = time + 0.04;
};

void () mp5_switch7 = [ 1, mp5_switch8 ]
{
    self.weaponframe = 60;
    self.nextthink = time + 0.04;
};

void () mp5_switch8 = [ 1, mp5_switch9 ]
{
    self.weaponframe = 61;
    self.nextthink = time + 0.04;
};

void () mp5_switch9 = [ 1, mp5_switch10 ]
{
    self.weaponframe = 62;
    self.nextthink = time + 0.04;
};

void () mp5_switch10 = [ 1, mp5_switch11 ]
{
    self.weaponframe = 63;
    self.nextthink = time + 0.04;
    sound(self,CHAN_WEAPON,"weapons/gpull.wav",1, ATTN_NORM);
};

void () mp5_switch11 = [ 1, mp5_switch12 ]
{
    self.weaponframe = 64;
    self.nextthink = time + 0.04;
};

void () mp5_switch12 = [ 1, mp5_switch13 ]
{
    self.weaponframe = 65;
    self.nextthink = time + 0.04;
};

void () mp5_switch13 = [ 1, mp5_switch14 ]
{
    self.weaponframe = 66;
    self.nextthink = time + 0.04;
};

void () mp5_switch14 = [ 1, mp5_switch15 ]
{
    self.weaponframe = 67;
    self.nextthink = time + 0.04;
};

void () mp5_switch15 = [ 1, mp5_switch16 ]
{
    self.weaponframe = 68;
    self.nextthink = time + 0.04;
};

void () mp5_switch16 = [ 1, mp5_switch17 ]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.04;
};

void () mp5_switch17 = [ 1, mp5_switch18 ]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.04;
};

void () mp5_switch18 = [ 1, mp5_switch19 ]
{
    self.weaponframe = 55;
    self.nextthink = time + 0.04;
};

void () mp5_switch19 = [ 1, player_run ]
{
    self.weaponframe = 1;
    self.nextthink = time + 0.04;
};

/********************MP5SD SEQUENCE**************/

void () player_reload_mp5sd = [ 103.000, player_reload_mp5sd ] 
{
   self.weaponframe = self.weaponframe + 1;
   self.nextthink = time + 0.04;
   self.reload = 1;
   if (self.weaponframe == 12)
    sound(self,CHAN_WEAPON,"weapons/mp5out.wav",1,ATTN_NORM);
   if (self.weaponframe == 28)
    sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);
   if (self.weaponframe == 39)
    sound(self,CHAN_WEAPON,"weapons/slide.wav",1,ATTN_NORM);
   if (self.weaponframe == 54)
    {
      if ((self.ammo_nails > 1.000) && (self.ammo_nails <= 30))
      {
        self.mp5clip = self.ammo_nails;
        self.ammo_nails = 0;
      }
      else
      {
        self.mp5clip = 30;
        self.ammo_nails = self.ammo_nails - 30;
      }
      W_SetCurrentAmmo();
      self.think = player_run;
    }
};

void () player_mp5sdg = [ 103.000, player_mp5sdg2 ] 
{
   self.weaponframe = 55;
   self.nextthink = time + 0.03;
   self.fire = 1;
   W_FireMP5SD ();
   self.muzzleclimb = 0;
};

void () player_mp5sdg2 = [103, player_mp5sdg3 ]
{
   self.weaponframe = 56;
   self.nextthink = time + 0.03;
};
 
void () player_mp5sdg3 = [104, player_run]
{
   self.weaponframe = 57;
   self.nextthink = time + 0.15;
};

void () player_mp5sdb;

void () player_mp5sda = [ 103.000, player_mp5sda2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   self.weaponframe = 55;  
   self.nextthink = time + 0.025;
   self.attack_finished = time + 0.085;

   self.fire = 1;
   W_FireMP5SD ();
   self.muzzleclimb = 0;
};

void () player_mp5sda2 = [ 103, player_mp5sda3 ] {
   
   self.weaponframe = 56;
   self.nextthink = time + 0.025;
};

void () player_mp5sda3 = [ 103, player_mp5sdb ] {
   
   self.weaponframe = 57;
   self.nextthink = time + 0.025;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
    {
     self.think = player_run;
     self.attack_finished = time + 0.05;
    }
};

void () player_mp5sdc;

void () player_mp5sdb = [ 103 , player_mp5sdb2]
 {
   self.weaponframe = 58;

   if (frametime == 0.1) {
    self.think = player_mp5sdc;
    self.nextthink = time;
    }

//   self.fire_finished = self.fire_finished + 0.03;
   self.nextthink = time + 0.03;
   W_FireMP5SD ();
   self.muzzleclimb = 1;
 };

void () player_mp5sdb2 = [ 103, player_mp5sdb3 ] {
   
   self.weaponframe = 59;
   self.nextthink = time + 0.03;
//   self.fire_finished = self.fire_finished + 0.03;
};

void () player_mp5sdb3 = [ 103, player_mp5sdc ] {
   
   self.weaponframe = 60;
   self.nextthink = time + 0.03;
//   self.fire_finished = self.fire_finished + 0.03;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
      {
       self.think = player_run;
       self.attack_finished = self.attack_finished + 0.05;
      }
};

void () player_mp5sdd;

void () player_mp5sdc = [ 103 , player_mp5sdc2]
 {
   self.weaponframe = 61;

   if (frametime == 0.1) {
    self.think = player_mp5sdd;
    self.nextthink = time; }

//   self.fire_finished = self.fire_finished + 0.03;
   self.nextthink = time + 0.03;
   W_FireMP5SD ();
   self.muzzleclimb = 2;
 };

void () player_mp5sdc2 = [ 103, player_mp5sdc3 ] {
   
   self.weaponframe = 62;
   self.nextthink = time + 0.03;
//   self.fire_finished = self.fire_finished + 0.03;
};

void () player_mp5sdc3 = [ 103, player_mp5sdd ] {
   
   self.weaponframe = 63;
   self.nextthink = time + 0.03;
//   self.fire_finished = self.fire_finished + 0.03;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
      {
       self.think = player_run;
       self.attack_finished = self.attack_finished + 0.05;
      }
};

void () player_mp5sde;

void () player_mp5sdd = [ 103 , player_mp5sdd2]
 {
   self.weaponframe = 64; 

   if (frametime == 0.1) {
    self.think = player_mp5sde;
    self.nextthink = time; }


//   self.fire_finished = self.fire_finished + 0.03;
   self.nextthink = time + 0.03;
   W_FireMP5SD ();
   self.muzzleclimb = 3;
 };

void () player_mp5sdd2 = [ 103, player_mp5sdd3 ] {
   
   self.weaponframe = 65;
   self.nextthink = time + 0.03;
//   self.fire_finished = self.fire_finished + 0.03;
};

void () player_mp5sdd3 = [ 103, player_mp5sdd ] {
   
   self.weaponframe = 66;
   self.nextthink = time + 0.03;
//   self.fire_finished = self.fire_finished + 0.03;
   if ( (self.button0 == 0) || (self.mp5clip <= 0) )
      {
       self.think = player_mp5sde;
       self.attack_finished = self.attack_finished + 0.05;
      }
};

void () player_mp5sde = [103, player_run ]
{
    self.weaponframe = 67;
    self.nextthink = time + 0.04;
};

void () player_mp5sdf4;

void () player_mp5sdf = [ 103, player_mp5sdf2]
{
    self.weaponframe = 55;

    if (frametime == 0.1) {
     self.think = player_mp5sdf4;
     self.nextthink = time; }

    self.nextthink = time + 0.03;
    W_FireMP5SD();
    self.fire = 1;
};

void () player_mp5sdf2 = [ 103, player_mp5sdf3]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.03;
};

void () player_mp5sdf3 = [ 103, player_mp5sdf4]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.03;
};

void () player_mp5sdf7;

void () player_mp5sdf4 = [ 103, player_mp5sdf5]
{
    self.weaponframe = 55;

    if (frametime == 0.1) {
     self.think = player_mp5sdf7;
     self.nextthink = time; }

    self.nextthink = time + 0.03;
    W_FireMP5SD();
};

void () player_mp5sdf5 = [ 103, player_mp5sdf6]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.03;
};

void () player_mp5sdf6 = [ 103, player_mp5sdf7]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.03;
};

void () player_mp5sdf9;

void () player_mp5sdf7 = [ 103, player_mp5sdf8]
{
    self.weaponframe = 55;

    if (frametime == 0.1) {
     self.think = player_mp5sdf9;
     self.nextthink = time; }

    self.nextthink = time + 0.03;
    W_FireMP5SD();
};

void () player_mp5sdf8 = [ 103, player_mp5sdf9]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.03;
};

void () player_mp5sdf9 = [ 103, player_run]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.2;
};

void () player_mp5sd_switch = [ 1, mp5sd_switch2 ]
{
    self.weaponframe = 1;
    self.nextthink = time + 0.04;
    self.reload = 1;
};

void () mp5sd_switch2 = [ 1, mp5sd_switch3 ]
{
    self.weaponframe = 55;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch3 = [ 1, mp5sd_switch4 ]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch4 = [ 1, mp5sd_switch5 ]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch5 = [ 1, mp5sd_switch6 ]
{
    self.weaponframe = 58;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch6 = [ 1, mp5sd_switch7 ]
{
    self.weaponframe = 59;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch7 = [ 1, mp5sd_switch8 ]
{
    self.weaponframe = 60;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch8 = [ 1, mp5sd_switch9 ]
{
    self.weaponframe = 61;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch9 = [ 1, mp5sd_switch10 ]
{
    self.weaponframe = 62;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch10 = [ 1, mp5sd_switch11 ]
{
    self.weaponframe = 63;
    self.nextthink = time + 0.04;
    sound(self,CHAN_WEAPON,"weapons/gpull.wav",1, ATTN_NORM);
};

void () mp5sd_switch11 = [ 1, mp5sd_switch12 ]
{
    self.weaponframe = 64;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch12 = [ 1, mp5sd_switch13 ]
{
    self.weaponframe = 65;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch13 = [ 1, mp5sd_switch14 ]
{
    self.weaponframe = 66;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch14 = [ 1, mp5sd_switch15 ]
{
    self.weaponframe = 67;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch15 = [ 1, mp5sd_switch16 ]
{
    self.weaponframe = 68;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch16 = [ 1, mp5sd_switch17 ]
{
    self.weaponframe = 57;
    self.nextthink = time + 0.04;
};


void () mp5sd_switch17 = [ 1, mp5sd_switch18 ]
{
    self.weaponframe = 56;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch18 = [ 1, mp5sd_switch19 ]
{
    self.weaponframe = 55;
    self.nextthink = time + 0.04;
};

void () mp5sd_switch19 = [ 1, player_run ]
{
    self.weaponframe = 1;
    self.nextthink = time + 0.04;
};

/********************** MK 23 HANDGUN ************************/

void () player_reload_mk23 = [ 1.000, mk23_reload3 ]
 {
   self.weaponframe = 9;
   self.nextthink = time + 0.03;
   self.reload = 1;
 };

void () mk23_reload2 = [ 1.000, mk23_reload3 ]
 {
   self.weaponframe = 10;
   self.nextthink = time + 0.03;
 };

void () mk23_reload3 = [ 1.000, mk23_reload5 ]
 {
   self.weaponframe = 11;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload4 = [ 1.000, mk23_reload5 ]
 {
   self.weaponframe = 12;
   self.nextthink = time + 0.03;
 };

void () mk23_reload5 = [ 1.000, mk23_reload7 ]
 {
   self.weaponframe = 13;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload6 = [ 1.000, mk23_reload7 ]
 {
   self.weaponframe = 14;
   self.nextthink = time + 0.03;
 };

void () mk23_reload7 = [ 1.000, mk23_reload9 ]
 {
   self.weaponframe = 15;
   self.nextthink = time + 0.03;
 };

void () mk23_reload8 = [ 1.000, mk23_reload9 ]
 {
   self.weaponframe = 16;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload9 = [ 1.000, mk23_reload11 ]
 {
   self.weaponframe = 17;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload10 = [ 1.000, mk23_reload11 ]
 {
   self.weaponframe = 18;
   self.nextthink = time + 0.03;
 };

void () mk23_reload11 = [ 1.000, mk23_reload13 ]
 {
   self.weaponframe = 19;
   self.nextthink = time + 0.03;
 };

void () mk23_reload12 = [ 1.000, mk23_reload13 ]
 {
   self.weaponframe = 20;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload13 = [ 1.000, mk23_reload15 ]
 {
   self.weaponframe = 21;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload14 = [ 1.000, mk23_reload15 ]
 {
   self.weaponframe = 22;
   self.nextthink = time + 0.03;
 };

void () mk23_reload15 = [ 1.000, mk23_reload16 ]
 {
   self.weaponframe = 23;
   sound(self,CHAN_WEAPON,"weapons/mp5out.wav",TRUE,ATTN_NORM);
   self.nextthink = time + 0.03;
 };

void () mk23_reload16 = [ 1.000, mk23_reload17 ]
 {
   self.weaponframe = 24;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload17 = [ 1.000, mk23_reload18 ]
 {
   self.weaponframe = 25;
   self.nextthink = time + 0.03;
 };

void () mk23_reload18 = [ 1.000, mk23_reload19 ]
 {
   self.weaponframe = 26;
   self.nextthink = time + 0.03;
 };

void () mk23_reload19 = [ 1.000, mk23_reload20 ]
 {
   self.weaponframe = 27;
   self.nextthink = time + 0.03;
 };

void () mk23_reload20 = [ 1.000, mk23_reload21 ]
 {
   self.weaponframe = 27;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload21 = [ 1.000, mk23_reload22 ]
 {
   self.weaponframe = 26;
   self.nextthink = time + 0.015;
 };

void () mk23_reload22 = [ 1.000, mk23_reload23 ]
 {
   self.weaponframe = 25;
   self.nextthink = time + 0.015;
 };

void () mk23_reload23 = [ 1.000, mk23_reload24 ]
 {
   self.weaponframe = 24;
   self.nextthink = time + 0.015;
 };

void () mk23_reload24 = [ 1.000, mk23_reload25 ]
 {
   self.weaponframe = 23;
   sound(self,CHAN_WEAPON,"weapons/mk23in.wav",TRUE,ATTN_NORM);
   self.nextthink = time + 0.015;
 }; 

void () mk23_reload25 = [ 1.000, mk23_reload27 ]
 {
   self.weaponframe = 22;
   self.nextthink = time + 0.03;
 };

void () mk23_reload26 = [ 1.000, mk23_reload27 ]
 {
   self.weaponframe = 21;
   self.nextthink = time + 0.03;
 };

void () mk23_reload27 = [ 1.000, mk23_reload29 ]
 {
   self.weaponframe = 20;
   self.nextthink = time + 0.03;
 };

void () mk23_reload28 = [ 1.000, mk23_reload29 ]
 {
   self.weaponframe = 19;
   self.nextthink = time + 0.03;
 };

void () mk23_reload29 = [ 1.000, mk23_reload31 ]
 {
   self.weaponframe = 18;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload30 = [ 1.000, mk23_reload31 ]
 {
   self.weaponframe = 17;
   self.nextthink = time + 0.03;
 };

void () mk23_reload31 = [ 1.000, mk23_reload33 ]
 {
   self.weaponframe = 16;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload32 = [ 1.000, mk23_reload33]
 {
   self.weaponframe = 29;
   self.nextthink = time + 0.03;
 };

void () mk23_reload33 = [ 1.000, mk23_reload35 ]
 {
   self.weaponframe = 30;
   self.nextthink = time + 0.03;
 };

void () mk23_reload34 = [ 1.000, mk23_reload35 ]
 {
   self.weaponframe = 31;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload35 = [ 1.000, mk23_reload37 ]
 {
   self.weaponframe = 32;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload36 = [ 1.000, mk23_reload37 ]
 {
   self.weaponframe = 33;
   self.nextthink = time + 0.03;
 };

void () mk23_reload37 = [ 1.000, mk23_reload39 ]
 {
   self.weaponframe = 34;
   self.nextthink = time + 0.03;
 };

void () mk23_reload38 = [ 1.000, mk23_reload39 ]
 {
   self.weaponframe = 35;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload39 = [ 1.000, mk23_reload41 ]
 {
   self.weaponframe = 36;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload40 = [ 1.000, mk23_reload41 ]
 {
   self.weaponframe = 37;
   self.nextthink = time + 0.03;
 };

void () mk23_reload41 = [ 1.000, mk23_reload43 ]
 {
   self.weaponframe = 38;
   self.nextthink = time + 0.03;
 };

void () mk23_reload42 = [ 1.000, mk23_reload43 ]
 {
   self.weaponframe = 39;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload43 = [ 1.000, mk23_reload45 ]
 {
   self.weaponframe = 40;
   self.nextthink = time + 0.03;
 };

void () mk23_reload44 = [ 1.000, mk23_reload45 ]
 {
   self.weaponframe = 41;
   self.nextthink = time + 0.03;
 };

void () mk23_reload45 = [ 1.000, mk23_reload46 ]
 {
   self.weaponframe = 42;
   self.nextthink = time + 0.03;
 };

void () mk23_reload46 = [ 1.000, mk23_reload47 ]
 {
   self.weaponframe = 43;
   self.nextthink = time + 0.03;
 }; 

void () mk23_reload47 = [ 1.000, mk23_reload48 ]
 {
   self.weaponframe = 44;
   self.nextthink = time + 0.015;
 };

void () mk23_reload48 = [ 1.000, mk23_reload49 ]
 {
   self.weaponframe = 45;
   sound(self,CHAN_WEAPON,"weapons/mk23sld.wav",TRUE,ATTN_NORM);
   self.nextthink = time + 0.015;
 };

void () mk23_reload49 = [ 1.000, mk23_reload50 ]
 {
   self.weaponframe = 46;
   self.nextthink = time + 0.015;
 };

void () mk23_reload50 = [ 1.000, mk23_reload51 ]
 {
   self.weaponframe = 47;
   self.nextthink = time + 0.015;
 }; 

void () mk23_reload51 = [ 1.000, mk23_reload52 ]
 {
   self.weaponframe = 48;
   self.nextthink = time + 0.015;
 };

void () mk23_reload52 = [ 1.000, mk23_reload53 ]
 {
   self.weaponframe = 49;
   self.nextthink = time + 0.015;
 };

void () mk23_reload53 = [ 1.000, mk23_reload54 ]
 {
   self.weaponframe = 50;
   self.nextthink = time + 0.015;
 };

void () mk23_reload54 = [ 1.000, mk23_reload55 ]
 {
   self.weaponframe = 51;
   self.nextthink = time + 0.015;
 }; 

void () mk23_reload55 = [ 1.000, mk23_reload56 ]
 {
   self.weaponframe = 52;
   self.nextthink = time + 0.015;
 };

void () mk23_reload56 = [ 1.000, mk23_reload58 ]
 {
   self.weaponframe = 41;
   self.nextthink = time + 0.03;
 };

void () mk23_reload58 = [ 1.000, mk23_reload59 ]
 {
   self.weaponframe = 38;
   self.nextthink = time + 0.03;
 };

void () mk23_reload59 = [ 1.000, mk23_reload60 ]
 {
   self.weaponframe = 30;
   self.nextthink = time + 0.03;
 }; 
void () mk23_reload60 = [ 1.000, mk23_reload61 ]
 {
   self.weaponframe = 20;
   self.nextthink = time + 0.03;
 };
void () mk23_reload61 = [1.000, mk23_reload62 ]
 {
   self.weaponframe = 14;
   self.nextthink = time + 0.03;
 };
void () mk23_reload62 = [1.000, player_run ]
 {
   self.weaponframe = 9;
   self.nextthink = time + 0.03;
   if ((self.ammo_shells >= 1) && (self.ammo_shells <= 13))
   {
      self.mk23clip = self.ammo_shells;
      self.ammo_shells = 0;
   }
   else
   {
      self.mk23clip = 13;
      self.ammo_shells = (self.ammo_shells - 13);
   }
   W_SetCurrentAmmo();
};

/** FIRE MK23 ***/

void () player_mk23a = [ 1.000, player_mk23a3 ]
 {
   self.effects = self.effects | EF_MUZZLEFLASH;
   self.weaponframe = 2;
   self.nextthink = time + 0.05;
   W_FireMK23 ();
   self.fire = 1;
 };

void () player_mk23a2 = [ 1.000, player_mk23a3 ]
 {
   self.weaponframe = 2;
   self.nextthink = time + 0.05;
 };

void () player_mk23a3 = [ 1.000, player_mk23a4 ]
 {
   self.weaponframe = 3;
   self.nextthink = time + 0.05;
 };

void () player_mk23a4 = [ 1.000, player_run ]
 {
   self.weaponframe = 4;
   self.nextthink = time + 0.12;
 };

void () player_mk23b = [ 1.000, player_mk23b3 ]
 {
   self.effects = self.effects | EF_MUZZLEFLASH;
   self.weaponframe = 6;
   self.nextthink = time + 0.05;
   W_FireMK23 ();
   self.fire = 1;
 };

void () player_mk23b2 = [ 1.000, player_mk23b3 ]
 {
   self.weaponframe = 6;
   self.nextthink = time + 0.05;
 };

void () player_mk23b3 = [ 1.000, player_mk23b4 ]
 {
   self.weaponframe = 7;
   self.nextthink = time + 0.05;
 };

void () player_mk23b4 = [ 1.000, player_run ]
 {
   self.weaponframe = 8;
   self.nextthink = time + 0.12;
 };

/*********** END MK. 23 Sequence ************/


void() player_nail1   =[$nailatt1, player_nail2  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (4);
	self.attack_finished = time + 0.2;
};
void() player_nail2   =[$nailatt2, player_nail1  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (-4);
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


void() player_rocket1   =[$rockatt1, player_rocket2  ] {self.weaponframe=1;
self.effects = self.effects | EF_MUZZLEFLASH;};
void() player_rocket2   =[$rockatt2, player_rocket3  ] {self.weaponframe=2;};
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
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		DeathBubbles(1);
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/drown2.wav", 1, ATTN_NORM);
		return;
	}

// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
// FIX ME	put in some steam here
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
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
		sound (self, CHAN_VOICE, "player/axhit1.wav", 1, ATTN_NORM);
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

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	return;
};

void()	player_pain1 =	[	$pain1,	player_pain2	] {PainSound();self.weaponframe=0;};
void()	player_pain2 =	[	$pain2,	player_pain3	] {};
void()	player_pain3 =	[	$pain3,	player_pain4	] {};
void()	player_pain4 =	[	$pain4,	player_pain5	] {};
void()	player_pain5 =	[	$pain5,	player_pain6	] {};
void()	player_pain6 =	[	$pain6,	player_run	] {};

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

        if (self.weapon == WP_ONE)
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
	if (self.waterlevel == 3)
	{
		DeathBubbles(20);
		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
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

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};


void() PlayerDead =
{
	self.nextthink = -1;
// allow respawn after a certain time
	self.deadflag = DEAD_DEAD;
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

void(string gibname, float dm) ThrowGib =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

void(string gibname, float dm) ThrowHead =
{
	setmodel (self, gibname);
	self.frame = 0;
	self.nextthink = -1;
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 0', '16 16 56');
	self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.avelocity = crandom() * '0 600 0';
};

void()	headless_corpse1	=	[9,		headless_corpse2] {self.nextthink = time + 0.09;
   Shoot_Blood (self.origin + '10 10 0',v_forward * 2000);
             Shoot_Blood (self.origin,v_forward * 2000);
   sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse2  =	[10,		headless_corpse3] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse3	=	[11,		headless_corpse4] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse4	=	[12,		headless_corpse5] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse5	=	[13,		headless_corpse6] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse6	=	[14,		headless_corpse7] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse7	=	[15,		headless_corpse8] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse8	=	[16,		headless_corpse9] {self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()	headless_corpse9	=	[17,		headless_corpse10]
{self.nextthink = time + 0.09;sound (self, CHAN_VOICE, "wizard/hit.wav", 1, ATTN_NONE);
};
void()      headless_corpse10 =     [0,         headless_corpse11]
{self.nextthink = time + 0.09;};
void()      headless_corpse11 =     [1,         headless_corpse12]
{self.nextthink = time + 0.09;};    
void()      headless_corpse12 =     [2,         headless_corpse13]
{self.nextthink = time + 0.09;};
void()      headless_corpse13 =     [3,         headless_corpse14]
{self.nextthink = time + 0.09;};  
void()      headless_corpse14 =     [4,         headless_corpse15]
{self.nextthink = time + 0.09;};
void()      headless_corpse15 =     [5,         headless_corpse16]
{self.nextthink = time + 0.09;};
void()      headless_corpse16 =     [6,         headless_corpse17]
{self.nextthink = time + 0.09;};   
void()      headless_corpse17 =     [7,         headless_corpse18]
{self.nextthink = time + 0.09;};
void()      headless_corpse18 =     [8,         headless_corpse18]
{self.nextthink = time + 112;};   

void(string gibname, float dm) ThrowHeadlessCorpse =
{
	setmodel (self, gibname);
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 -24', '16 16 35');
	self.flags = self.flags - (self.flags & FL_ONGROUND);
      self.avelocity = crandom() * '0 0 0';

      headless_corpse1 ();
};

void()	blasted_corpse1	=	[0,		blasted_corpse2] {self.nextthink = time + 0.09;
   particle ((self.origin),'0.000 0.000 3.000',72.000,38.000);
   particle ((self.origin),'0.000 3.000 3.000',72.000,38.000);
   particle ((self.origin),'0.000 -3.000 3.000',72.000,38.000);
   particle ((self.origin),'3.000 0.000 3.000',72.000,38.000);
   particle ((self.origin),'-3.000 0.000 3.000',72.000,38.000);
};
void()	blasted_corpse2	=	[1,		blasted_corpse3] {self.nextthink = time + 0.09;};
void()	blasted_corpse3	=	[2,		blasted_corpse4] {self.nextthink = time + 0.09;};
void()	blasted_corpse4	=	[3,		blasted_corpse5] {self.nextthink = time + 0.09;};
void()	blasted_corpse5	=	[4,		blasted_corpse6] {self.nextthink = time + 0.09;};
void()	blasted_corpse6	=	[5,		blasted_corpse7] {self.nextthink = time + 0.09;};
void()	blasted_corpse7	=	[6,		blasted_corpse8] {self.nextthink = time + 0.09;};
void()	blasted_corpse8	=	[7,		blasted_corpse9] {self.nextthink = time + 0.09;};
void()	blasted_corpse9	=	[8,		blasted_corpse9] 
{self.nextthink = time + 112;};

void(string gibname, float dm) ThrowBlastedCorpse =
{
	setmodel (self, gibname);
	self.movetype = MOVETYPE_BOUNCE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.view_ofs = '0 0 8';
	setsize (self, '-16 -16 -24', '16 16 35');
	self.flags = self.flags - (self.flags & FL_ONGROUND);
      self.avelocity = crandom() * '0 0 0';

      blasted_corpse1 ();
};

void(string gibname, float dm) ThrowChunk =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
      new.view_ofs = '0 0 8';
	setsize (new, '-16 -16 0', '16 16 56');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
      new.avelocity = crandom() * '0 600 0';
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = new.flags - (new.flags & FL_ONGROUND);
};


void() GibPlayer =
{
	ThrowHead ("progs/h_player.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
		
	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
};

void() PlayerDie =
{
	local	float	i;
	
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

	if (self.health < -40)
	{
		GibPlayer ();
		return;
	}

	DeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
        if (self.weapon == WP_ONE)
	{
		player_die_ax1 ();
		return;
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
	if (self.model != "progs/player.mdl")
		return;	// allready gibbed
	self.frame = $deatha11;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
};


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
