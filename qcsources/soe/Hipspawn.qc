//=====================================================================
//
// Spawning Functions (Hipnotic)
//
//=====================================================================
// Since the horn is an item, and adding items is not the intent of Custents,
// All code refering to it has been simply commented out, so that you can
// easily uncomment it if you wish to add the horn to your patch.

//=========================
//
// SUB_CopyEntity
//
//=========================

void (entity srcent, entity destent) SUB_CopyEntity =
{
	destent.modelindex=srcent.modelindex;
	destent.absmin=srcent.absmin;
	destent.absmax=srcent.absmax;
	destent.ltime=srcent.ltime;
	destent.movetype=srcent.movetype;
	destent.solid=srcent.solid;
	destent.origin=srcent.origin;
	destent.oldorigin=srcent.oldorigin;
	destent.velocity=srcent.velocity;
	destent.angles=srcent.angles;
	destent.avelocity=srcent.avelocity;
	destent.punchangle=srcent.punchangle;
	destent.classname=srcent.classname;
	destent.model=srcent.model;
	destent.frame=srcent.frame;
	destent.skin=srcent.skin;
	destent.effects=srcent.effects;
	destent.mins=srcent.mins;
	destent.maxs=srcent.maxs;
	destent.size=srcent.size;
	destent.touch=srcent.touch;
	destent.use=srcent.use;
	destent.think=srcent.think;
	destent.blocked=srcent.blocked;
	destent.nextthink=srcent.nextthink;
	destent.groundentity=srcent.groundentity;
	destent.health=srcent.health;
	destent.frags=srcent.frags;
	destent.weapon=srcent.weapon;
	destent.weaponmodel=srcent.weaponmodel;
	destent.weaponframe=srcent.weaponframe;
	destent.currentammo=srcent.currentammo;
	destent.ammo_shells=srcent.ammo_shells;
	destent.ammo_nails=srcent.ammo_nails;
	destent.ammo_rockets=srcent.ammo_rockets;
	destent.ammo_cells=srcent.ammo_cells;
	destent.items=srcent.items;
	destent.takedamage=srcent.takedamage;
	destent.chain=srcent.chain;
	destent.deadflag=srcent.deadflag;
	destent.view_ofs=srcent.view_ofs;
	destent.button0=srcent.button0;
	destent.button1=srcent.button1;
	destent.button2=srcent.button2;
	destent.impulse=srcent.impulse;
	destent.fixangle=srcent.fixangle;
	destent.v_angle=srcent.v_angle;
	destent.idealpitch=srcent.idealpitch;
	destent.netname=srcent.netname;
	destent.enemy=srcent.enemy;
	destent.flags=srcent.flags;
	destent.colormap=srcent.colormap;
	destent.team=srcent.team;
	destent.max_health=srcent.max_health;
	destent.teleport_time=srcent.teleport_time;
	destent.armortype=srcent.armortype;
	destent.armorvalue=srcent.armorvalue;
	destent.waterlevel=srcent.waterlevel;
	destent.watertype=srcent.watertype;
	destent.ideal_yaw=srcent.ideal_yaw;
	destent.yaw_speed=srcent.yaw_speed;
	destent.aiment=srcent.aiment;
	destent.goalentity=srcent.goalentity;
	destent.spawnflags=srcent.spawnflags;
	destent.target=srcent.target;
	destent.targetname=srcent.targetname;
	destent.dmg_take=srcent.dmg_take;
	destent.dmg_save=srcent.dmg_save;
	destent.dmg_inflictor=srcent.dmg_inflictor;
	destent.owner=srcent.owner;
	destent.movedir=srcent.movedir;
	destent.message=srcent.message;
	destent.sounds=srcent.sounds;
	destent.noise=srcent.noise;
	destent.noise1=srcent.noise1;
	destent.noise2=srcent.noise2;
	destent.noise3=srcent.noise3;
	destent.wad=srcent.wad;
	destent.map=srcent.map;
	destent.worldtype=srcent.worldtype;
	destent.killtarget=srcent.killtarget;
	destent.light_lev=srcent.light_lev;
	destent.style=srcent.style;
	destent.th_stand=srcent.th_stand;
	destent.th_walk=srcent.th_walk;
	destent.th_run=srcent.th_run;
	destent.th_missile=srcent.th_missile;
	destent.th_melee=srcent.th_melee;
	destent.th_pain=srcent.th_pain;
	destent.th_die=srcent.th_die;
//	destent.th_turn=srcent.th_turn;
	destent.oldenemy=srcent.oldenemy;
	destent.speed=srcent.speed;
	destent.lefty=srcent.lefty;
	destent.search_time=srcent.search_time;
	destent.attack_state=srcent.attack_state;
	destent.walkframe=srcent.walkframe;
	destent.attack_finished=srcent.attack_finished;
	destent.pain_finished=srcent.pain_finished;
	destent.invincible_finished=srcent.invincible_finished;
	destent.invisible_finished=srcent.invisible_finished;
	destent.super_damage_finished=srcent.super_damage_finished;
	destent.radsuit_finished=srcent.radsuit_finished;
	destent.invincible_time=srcent.invincible_time;
	destent.invincible_sound=srcent.invincible_sound;
	destent.invisible_time=srcent.invisible_time;
	destent.invisible_sound=srcent.invisible_sound;
	destent.super_time=srcent.super_time;
	destent.super_sound=srcent.super_sound;
	destent.rad_time=srcent.rad_time;
	destent.fly_sound=srcent.fly_sound;
	destent.axhitme=srcent.axhitme;
	destent.show_hostile=srcent.show_hostile;
	destent.jump_flag=srcent.jump_flag;
	destent.swim_flag=srcent.swim_flag;
	destent.air_finished=srcent.air_finished;
	destent.bubble_count=srcent.bubble_count;
	destent.deathtype=srcent.deathtype;
	destent.mdl=srcent.mdl;
	destent.mangle=srcent.mangle;
	destent.oldorigin=srcent.oldorigin;
	destent.t_length=srcent.t_length;
	destent.t_width=srcent.t_width;
	destent.dest=srcent.dest;
	destent.dest1=srcent.dest1;
	destent.dest2=srcent.dest2;
	destent.wait=srcent.wait;
	destent.delay=srcent.delay;
	destent.trigger_field=srcent.trigger_field;
	destent.noise4=srcent.noise4;
	destent.pausetime=srcent.pausetime;
	destent.movetarget=srcent.movetarget;
	destent.aflag=srcent.aflag;
	destent.dmg=srcent.dmg;
	destent.cnt=srcent.cnt;
	destent.think1=srcent.think1;
	destent.finaldest=srcent.finaldest;
	destent.finalangle=srcent.finalangle;
	destent.count=srcent.count;
	destent.lip=srcent.lip;
	destent.state=srcent.state;
	destent.pos1=srcent.pos1;
	destent.pos2=srcent.pos2;
	destent.height=srcent.height;
	destent.waitmin=srcent.waitmin;
	destent.waitmax=srcent.waitmax;
	destent.distance=srcent.distance;
	destent.volume=srcent.volume;
	destent.spawnfunction=srcent.spawnfunction;
	destent.spawnthink=srcent.spawnthink;
	destent.spawnmodel=srcent.spawnmodel;
	destent.spawnsolidtype=srcent.spawnsolidtype;
	destent.spawnmins=srcent.spawnmins;
	destent.spawnmaxs=srcent.spawnmaxs;
	destent.spawnclassname=srcent.spawnclassname;
//	destent.duration=srcent.duration;
};

//================
//
// spawn_think
//
//================

void() spawn_think =
{
	self.think = spawn_think;
	self.nextthink = time + 1;
};

//================
//
// spawn_use
//
//================

void() spawn_use =
{
	local entity spawnentity;
	local entity tempself;

	if ((self.spawnmulti == 1) /* || (horn_active) */ )
      {
		// spawn the new entity
	      spawnentity = spawn();
	      // copy the master mold
	      SUB_CopyEntity(self.spawnmaster,spawnentity);
      }
	else
	      spawnentity = self.spawnmaster;
	// restore the model
	spawnentity.model = spawnentity.spawnmodel;
	//restore solid flag
	spawnentity.solid = spawnentity.spawnsolidtype;
	//restore thinking function
	spawnentity.think = spawnentity.spawnthink;
	setmodel (spawnentity, spawnentity.model);
	setorigin (spawnentity, self.origin);
	spawnentity.mins = spawnentity.spawnmins;
	spawnentity.maxs = spawnentity.spawnmaxs;
	setsize (spawnentity, spawnentity.mins, spawnentity.maxs);
	// spawn the teleport effect
	if (self.spawnsilent == 0)
		spawn_tfog (spawnentity.origin);
	// call spawnentity think function
/*	if (horn_active)
      {
		spawnentity.charmer = horn_charmer;
	      spawnentity.charmed = 1;
      } */
	// check to see if it is a monster
	if (spawnentity.flags & FL_MONSTER)
      {
		if ((self.spawnmulti != 0) /* && (horn_active == 0) */)
		{
			total_monsters = total_monsters + 1;
			WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
			WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
			WriteLong (MSG_BROADCAST, total_monsters);
		}
/*		if (horn_active)
			spawnentity.effects = spawnentity.effects | EF_DIMLIGHT;
*/
	}
	if ((self.spawnmulti == 0) /* && (horn_active == 0) */ )
	      remove(self);
};

//================
//
// func_spawn
//
//================
/*QUAKED func_spawn (0 .5 .8) (-32 -32 -24) (32 32 64) big/ambush megahealth
This will spawn a thing upon being used. The thing that
is spawned depends upon the value of "spawnfunction".
"spawnclassname" should contain the same value as "spawnfunction".
If "spawnfunction" is unspecified a random monster is chosen.
The angles, target and all flags are passed on
Think of it like setting up a normal entity.
"spawnsilent" set this to 1 if you want a silent spawn.
"spawnmulti" set this to 1 if you want this spawn to be reoccuring.
*/

// ### this function has been recoded to be much more code efficient
void() func_spawn =
{
	local entity tempself;
	local entity monster;
	local float tempdeathmatch;
	local float temptotal_monsters;
	local vector mn,mx;

	tempdeathmatch = cvar("temp1");
	if (tempdeathmatch && (self.targetname != "DMSP_boss"))
	{
		remove(self);
		return;
	}
	if (notHere())
	{
		remove(self);
		return;
	}

	// save off deathmatch and zero it out
	tempself = self;
	tempdeathmatch = deathmatch;
	deathmatch = 0;
	if (!self.spawnclassname)
      {
		local float spawnchance;

		spawnchance = random();
	      monster = tempself;

		if(self.spawnmulti != 0)
			self.currentammo = TRUE;

	      // save off monster count so it doesn't get f'ed up
	      temptotal_monsters = total_monsters;

	      if (spawnchance < 0.5)
		{
		      // spawn dog
		      // spawn the new entity
		      self = spawn();
		      // copy over everything
		      self.spawnfunction = monster_dog;
		      self.spawnclassname = "monster_dog";
		}
		else if (spawnchance < 0.8)
		{
			// spawn ogre
		      // spawn the new entity
		      self = spawn();
		      // copy over everything
		      self.spawnfunction = monster_ogre;
		      self.spawnclassname = "monster_ogre";
		}
		else if (spawnchance < 0.92)
		{
		      // spawn fiend
		      // spawn the new entity
		      self = spawn();
		      // copy over everything
		      self.spawnfunction = monster_demon1;
		      self.spawnclassname = "monster_demon1";
		}
		else if (spawnchance < 0.97)
		{
		      // spawn zombie
		      // spawn the new entity
		      self = spawn();
		      // copy over everything
		      self.spawnfunction = monster_zombie;
		      self.spawnclassname = "monster_zombie";
		}
		else
		{
			// spawn shambler
		      // spawn the new entity
		      self = spawn();
		      // copy over everything
		      self.spawnfunction = monster_shambler;
		      self.spawnclassname = "monster_shambler";
		}

	      self.classname = self.spawnclassname;

	      // call the named spawn function
	      self.spawnfunction();
	      self.spawnmodel = self.model;
	      self.spawnmins = self.mins;
	      self.spawnmaxs = self.maxs;
	      setmodel (self, string_null);
	      setsize (self, self.spawnmins, self.spawnmaxs);
	      //save off solid flag
	      self.spawnsolidtype = self.solid;
	      self.solid = SOLID_NOT;
	      //save off think func and
	      //get rid of his thinking
	      self.spawnthink = self.think;
	      self.think = spawn_think;
	      self.nextthink = time + 1;

		monster = self;

		// make sure monster count is correct
	      total_monsters = temptotal_monsters + 1;
	}
	else
	{
	      // spawn the new entity
	      self = spawn();
	      // copy over everything
	      SUB_CopyEntity(tempself,self);

	      // save off monster count so it doesn't get f'ed up
	      temptotal_monsters = total_monsters;
	      if (self.spawnclassname == string_null)
			objerror("No spawnclassname defined");
	      self.classname = self.spawnclassname;
	      // call the named spawn function

		self.spawnfunction();
	      if (self.spawnmulti != 0)
		{
			// make sure monster count is correct
			total_monsters = temptotal_monsters;
		}
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel (self, string_null);
	      self.model = string_null;
	      setsize (self, self.spawnmins, self.spawnmaxs);
	      //save off solid flag
	      self.spawnsolidtype = self.solid;
	      self.solid = SOLID_NOT;
	      //save off think func and
	      //get rid of his thinking
	      self.spawnthink = self.think;
	      self.think = spawn_think;
	      self.nextthink = time + 1;
	      monster = self;
	}
	self = tempself;
	deathmatch = tempdeathmatch;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = string_null;
	setmodel (self, self.model);  // set size and link into world
	self.use = spawn_use;
	self.spawnmaster = monster;
};

//================
//
// func_spawn_small
//
//================
/*QUAKED func_spawn_small (0 .5 .8) (-16 -16 -24) (16 16 40) big/ambush megahealth
This will spawn a thing upon being used. The thing that
is spawned depends upon the value of "spawnfunction".
"spawnclassname" should contain the same value as "spawnfunction".
If "spawnfunction" is unspecified a random monster is chosen.
The angles, target and all flags are passed on
Think of it like setting up a normal entity.
"spawnsilent" set this to 1 if you want a silent spawn.
"spawnmulti" set this to 1 if you want this spawn to be reoccuring.
*/

void() func_spawn_small =
{
	func_spawn();
};