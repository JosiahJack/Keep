/*================================
DMSP code for Soul of Evil

DMSP in SoE is activated with setting bit 4 (value 16) in serverflags; this
is done with a trigger_changelevel with bit 4 set. See client.qc.

Original DMSP code by Aardappel (http://wouter.fov120.com)

What I, Fat Controller, have done here is put the DMSP code in its own little
file, as well as tweak the normal monster spawn functions to remove themselves
when serverflags has bit 4 set.
==================================*/

void () dmsp_army ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 30;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.classname = "dmsp_army";

	walkmonster_start ();
};

void () dmsp_knight ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/knight.mdl");


	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 75;

	self.classname = "dmsp_knight";
	if (self.spawnflags && 2)
	{
		self.classname = "dmsp_soldier";
		self.skin = 1;
		self.health = 150;
	}
	self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_pain = knight_pain;
	self.th_die = knight_die;
	
	walkmonster_start ();
};

void () dmsp_ogre ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/ogre.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 200;

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;
	self.classname = "dmsp_ogre";
	
	walkmonster_start();
};

void () dmsp_enforcer ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/enforcer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
	self.classname = "dmsp_enforcer";

	walkmonster_start();
};

void () dmsp_dog ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/dog.mdl");

	setsize (self, '-32 -32 -24', '32 32 40');
	self.health = 25;

	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	self.classname = "dmsp_dog";

	walkmonster_start();
};

void () dmsp_hell_knight ={

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	if (self.spawnflags && 2)
	{
		setmodel (self, "progs/hlord.mdl");
		self.th_missile = hknight_magic;	// random selection of hell knight attacks
		self.health = 500;
		self.classname = "dmsp_lord";
	}
	else
	{
		self.classname = "dmsp_hell_knight";
		setmodel (self, "progs/hknight.mdl");
		self.health = 250;
		self.th_missile = hknight_magicc1;
	}
	setsize (self, '-16 -16 -24', '16 16 40');

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
	
	walkmonster_start ();
};

void () dmsp_wizard ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/wizard.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;

	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = Wiz_Missile;
	self.th_pain = Wiz_Pain;
	self.th_die = wiz_die;
	self.classname = "dmsp_wizard";
		
	flymonster_start ();
};

void () dmsp_zombie ={
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/zombie.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 60;

	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_missile = zombie_missile;
	self.classname = "dmsp_zombie";

	walkmonster_start();
};

void () dmsp_axeman ={

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/axeman.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 300;

	self.th_stand = axe_stand1;
	self.th_walk = axe_walk1;
	self.th_run = axe_run1;
	self.th_melee = axe_atk;
	self.th_pain = axe_pain;
	self.th_die = axe_die;
	self.classname = "dmsp_axeman";
	
	walkmonster_start ();
};

void () dmsp_mage ={
	self.th_pain = fwiz_pain;
	self.th_die = fwiz_die;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.pain_finished = 1;

	if(self.ammo_shells == 2)	// warlock
	{
		self.health = 600;
		self.th_stand = war_stand1;
		self.th_walk = war_walk1;
		self.th_run = war_run1;
		self.th_missile = war_attack1;
		self.th_melee = ac_slice1;
		self.classname = "dmsp_warlock";
	}
	else if (self.ammo_shells == 1)
	{
		self.health = 400;
		self.th_stand = sor_stand1;
		self.th_walk = sor_walk1;
		self.th_run = sor_run1;
		self.th_missile = sor_attack1;
		self.th_melee = ac_slice1;
		self.classname = "dmsp_sorceror";
	}
	else
	{
		self.health = 200;
		self.th_stand = ac_stand1;
		self.th_walk = ac_walk1;
		self.th_run = ac_run1;
		self.th_missile = ac_attack1;
		self.th_melee = ac_slice1;
		self.classname = "dmsp_acolyte";
	}

	setmodel (self, "progs/necro.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	walkmonster_start ();
};

/* This piece of code is referenced by world.qc. It preloads all the monster models and sounds
to be used in the DMSP game mode.
*/
void () DMSP_precaches ={
	local float i;
	i = cvar("temp1");

	if (i != 1)
		return;

	totalmonsterspawn = 20*(cvar("skill")+2);
//	total_monsters = totalmonsterspawn + total_monsters;
	if(cvar("teamplay")!=0)
	{
		totalmonsterspawn = 0;
		bprint("deathmatch mode not supported!");
	}
	lastmspawn = world;
	lasttime = time+10;
	nspawned = 0;

	precache_sound ("ra/3.wav");
	precache_sound ("ra/2.wav");
	precache_sound ("ra/1.wav");
	precache_sound ("ra/fight.wav");

//FC: Your less than gracious host :P
	precache_sound ("misc/pkdream.wav");
	precache_sound ("bishop/rip.wav");
	precache_sound ("bishop/rot.wav");
	precache_sound ("bishop/journey.wav");
	precache_sound ("bishop/skull.wav");

//aard: merged in from monsters we're using

	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/s_death.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/s_pain.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/s_arrow.wav");
	precache_sound ("soldier/s_sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
	precache_model ("progs/knight.mdl");
	precache_model ("progs/h_knight.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");
	precache_model ("progs/ogre.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");

	precache_sound ("ogre/ogdrag.wav");
	precache_sound ("ogre/ogdth.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogsawatk.wav");
	precache_sound ("ogre/ogwake.wav");
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/e_death.wav");
	precache_sound2 ("enforcer/e_arrow.wav");
//	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/e_idle.wav");
	precache_sound2 ("enforcer/e_pain1.wav");
//	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/e_sight1.wav");
	precache_sound2 ("enforcer/e_sight2.wav");
	precache_sound2 ("enforcer/e_sight3.wav");
//	precache_sound2 ("enforcer/sight4.wav");
	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog.mdl");

	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");

	
	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");
	precache_model("progs/lavaball.mdl");
	precache_sound("boss1/throw.wav");
	precache_sound("weapons/rocket1i.wav");
	precache_model2 ("progs/hlord.mdl");
	precache_sound("lord/sight2.wav");
	precache_sound("lord/growl2.wav");
	precache_sound("lord/growl3.wav");
	precache_sound("lord/pain2.wav");
	precache_sound("lord/death2.wav");
	precache_sound("lord/sight2.wav");
	precache_sound("lord/growl2.wav");
	precache_sound("lord/growl3.wav");
	precache_sound("lord/pain2.wav");
	precache_sound("lord/death2.wav");

	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound ("wizard/widle1.wav");
	precache_sound ("wizard/widle2.wav");
	precache_sound ("wizard/wpain.wav");
	precache_sound ("wizard/wsight.wav");
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");

	precache_model ("progs/axeman.mdl");
	precache_model ("progs/h_knight.mdl");

	precache_sound ("axeman/adeath.wav");
	precache_sound ("axeman/apain.wav");
	precache_sound ("axeman/asight.wav");
	precache_sound ("axeman/axe1.wav");
	precache_sound ("axeman/axe2.wav");
	precache_sound ("axeman/aidle.wav");

	precache_model ("progs/necro.mdl");
	precache_model ("progs/trogball.mdl");
	precache_model ("progs/fbolt2.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("fwiz/fwiz_i1.wav");	// idle
	precache_sound ("fwiz/fwiz_i2.wav");
	precache_sound ("fwiz/fwiz_i3.wav");
	precache_sound ("fwiz/fwiz_s1.wav");	// sight
	precache_sound ("fwiz/fwiz_p1.wav");	// pain
	precache_sound ("fwiz/fwiz_d1.wav");	// death
	precache_sound ("trog/frblatck.wav");	// sorceror fire sounds
	precache_sound ("trog/frblfly.wav");
	precache_sound ("fwiz/dsbospit.wav");	// warlock fire sound
	precache_sound ("player/teledth1.wav");
	precache_sound ("player/tornoff2.wav");	// decapitation :)
	precache_sound ("wizard/wattack.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("hknight/hit.wav");

};

/* FC: isSpawnPointEmpty checks against telefragging. From Rogue mission pack */
float(entity thePoint) isSpawnPointEmpty =
{
	local entity	neighbors;
	local entity	start;

	neighbors = findradius ( thePoint.origin, 32 );
	if (neighbors == world)
		return 1;

	start = neighbors;
	while (neighbors)
	{
		if (neighbors != thePoint)
		{
			if (neighbors.flags & FL_MONSTER)
			{
				return 0; // monster here
			}
			else if (neighbors.classname == "player")
			{
				return 0; // player here
			}
			// there was a check for anything with a think here,
			// but I diked that. After all, items have thinks.
		}
			neighbors = neighbors.chain;
		if (neighbors == start)
			return 1;
	}
	return 1;
};

void() DMSP_monsterspawner =
{
    local entity tself;
    local entity cl;
    local float n;
	local float i;
	i = cvar("temp1");
	if (i != 1) return;

    if(time - lasttime > 2 && totalmonsterspawn > 0)
// Note here that the time between spawns is now 2. This is due to there being more
// powerful monsters about.
    {
        if(nspawned == 0)
        {
                cl = find(world, classname, "player");
                centerprint(cl, "The invasion has begun!");
        }

		// FC: if the player is dead, stop the spawning
		cl = find(world, classname, "player");
		if (cl.deadflag) return;

        nspawned = nspawned + 1;
        lasttime = time;
        lastmspawn = find(lastmspawn, netname, "dmsp_spawn");
        if(lastmspawn==world) return;

		/*	FC: need a check here to avoid spawns which're occupied.
			This loop will run at most once through all the spawns; if all are occupied
			then we use the one originally selected.
		*/
		tself = lastmspawn;
		n = isSpawnPointEmpty(lastmspawn);
		while(n == 0) // also exits if we run out of spawns
		{
			lastmspawn = find(lastmspawn, netname, "dmsp_spawn");
			n = isSpawnPointEmpty(lastmspawn);
			if (lastmspawn == world)
				n == 0;
			if (lastmspawn == tself)
				n == 1;
		}
		// shouldn't need this check, but just in case...
		if (lastmspawn == world)	return;

        tself = self;
        self = spawn();

		if (lastmspawn.cnt == 1) // it's a fat one!
		{
			n = totalmonsterspawn & 15;
			if(n==0)      { dmsp_knight(); }
			else if(n==1) { dmsp_ogre(); }
			else if(n==2) { dmsp_enforcer(); }
			else if(n==3) { dmsp_dog(); }
			else if(n==4) { dmsp_hell_knight(); }
			else if(n==5) { dmsp_wizard(); }
			else if(n==6) { dmsp_zombie(); }
			else if(n==7) { dmsp_axeman(); }
			else if(n==8) { dmsp_mage(); }
			else if(n==9) { self.ammo_shells = 1; dmsp_mage(); }
			else if(n==10){ self.ammo_shells = 2; dmsp_mage(); }
			else if(n==11){ self.spawnflags = self.spawnflags & 2; dmsp_hell_knight(); }
			else if(n==12){ self.spawnflags = self.spawnflags & 2; dmsp_knight(); }
			else          { dmsp_army(); }
		}
		else // thin bugger - c/f the info_player_deathmatch in client.qc - FC
		{
			n = totalmonsterspawn & 15;
			if(n==0 || n==12)      { dmsp_knight(); }
			else if(n==1 || n == 13) { self.spawnflags = self.spawnflags & 2; dmsp_knight(); }
			else if(n==2) { dmsp_enforcer(); }
			else if(n==3) { dmsp_axeman(); }
			else if(n==4) { dmsp_hell_knight(); }
			else if(n==5 || n==14) { dmsp_wizard(); }
			else if(n==6) { dmsp_zombie(); }
			else if(n==7) { dmsp_army(); }
			else if(n==8) { dmsp_mage(); }
			else if(n==9) { self.ammo_shells = 1; dmsp_mage(); }
			else if(n==10){ self.ammo_shells = 2; dmsp_mage(); }
			else if(n==11){ self.spawnflags = self.spawnflags & 2; dmsp_hell_knight(); }
			else { dmsp_army(); }
		}
        setorigin(self, lastmspawn.origin);
		self.angles = lastmspawn.angles;
		self.fixangle = TRUE;		// turn this way immediately
		spawn_tfog (self.origin);	// FC: effects!
        spawn_tdeath (self.origin, self); // no other way?
        self = tself;
        totalmonsterspawn = totalmonsterspawn - 1;

// SoE: The last monster is a special affair
		if(totalmonsterspawn == 1)
		{
			cl = find(world, targetname, "DMSP_boss");
			if (cl != world)
			{
				self.target="DMSP_boss";
				SUB_UseTargets();
				totalmonsterspawn = 0;
				nspawned = nspawned + 1;
			}
		}

        if(totalmonsterspawn < 1)
        {
                cl = find(world, classname, "player");
                centerprint(cl, "The invasion has ended!");
        }
    }
};

/* FC: Countdown timer to invasion start. Referenced from info_player_start.
*/
void() DMSP_countdown ={
	local string ticker;
	local entity sucker;

	if (self.cnt < 0)
	{
		self.nextthink = time + 1;
		self.think = SUB_Remove;
	}

	sucker = find (world, classname, "player");
	if (sucker != world)
	{
		ticker = ftos(self.cnt);
		if (self.cnt > 0)
			centerprint (sucker, ticker);
		if (self.cnt == 3)
			sound(sucker, CHAN_AUTO, "ra/3.wav", 1, ATTN_NONE);
		else if (self.cnt == 2)
			sound(sucker, CHAN_AUTO, "ra/2.wav", 1, ATTN_NONE);
		else if (self.cnt == 1)
			sound(sucker, CHAN_AUTO, "ra/1.wav", 1, ATTN_NONE);
		else if (self.cnt == 0)
		{
			centerprint (sucker, "FIGHT!");
			sound(sucker, CHAN_AUTO, "ra/fight.wav", 1, ATTN_NONE);
		}
	}

	self.cnt = self.cnt - 1;
	self.nextthink = time + 1;
	self.think = DMSP_countdown;
	return;
};

/* FC: Here we do a little trickie where "fat monsters" are concerned.

	Since fiends and ogres have double-width bounding boxes (64 wide), we need spawnpoints that
	are at least 48 units away from any wall. We discern these by running a passel of
	traceline() calls to find out whether a spawn is "fat" or "thin". Ogres etc. will only
	be spawned in designated "fat" points!
*/
void() DMSP_checkSpawnSize ={
local vector source;
local vector org;
	self.cnt = 0;

	source = self.origin;
	org = source + '48 0 0';
	traceline (source, org, TRUE, self);
	if (trace_fraction < 1.0)
		return;

	org = source + '-48 0 0';
	traceline (source, org, TRUE, self);
	if (trace_fraction < 1.0)
		return;

	org = source + '0 48 0';
	traceline (source, org, TRUE, self);
	if (trace_fraction < 1.0)
		return;

	org = source + '0 -48 0';
	traceline (source, org, TRUE, self);
	if (trace_fraction < 1.0)
		return;

	dprint("Fat spawn detected!\n");
	self.cnt = 1;
};

/********************
 *	info_dmsp_spawn
 *	This item indicates a monster only spawnpoint for Arena games.
 ********************/

void() info_dmsp_spawn ={
	local float i;
	i = cvar("temp1");
	if (serverflags & 16 || i)
	{
		self.netname = "dmsp_spawn";
		dprint("dmsp_spawn created");
		info_player_deathmatch();
	}
	else
	{
		remove(self);
	}
};