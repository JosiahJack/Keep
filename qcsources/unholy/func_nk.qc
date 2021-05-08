float SPAWN_TELEPORT=1;

/*QUAKED func_spawner (1 .8 0) (-16 -16 0) (16 16 56)
If something is blocking the spawnspot, this will telefrag it.
If used to spawn monsters, the total count of monsters in the map is dynamically increased accordingly.
Transfers its angles & spawnflags to the spawned thing.
Effects can be used to make a teleport effect (sound & particles).
*/

void update_monstercount (void)
{
	WriteByte(MSG_ALL, /*SVC_UPDATESTAT*/3);
	WriteByte(MSG_ALL, /*STAT_TOTALMONSTERS*/12);
	WriteLong(MSG_ALL, total_monsters);	
}

void post_spawn (void)
{
	entity newmis = self.enemy;
	update_monstercount();
	remove(self);
	if(newmis.enemy != world)
	{
		self=newmis;
		FoundTarget ();
	}
	else if (newmis.flags & FL_MONSTER)
	{
		self=newmis;
		walkmonster_start();
	}
}

void spawn_something (string spawn_classname, vector spawnspot, vector facing_angles, float spawn_spawnflags, float teleport_effect, entity spawn_enemy, string spawn_killtarget, string spawn_target, string spawn_msg)
{
	if(teleport_effect) spawn_tfog(spawnspot);
	
	newmis = spawn();
	setorigin(newmis,spawnspot);
	spawn_tdeath(spawnspot,newmis);
	newmis.angles = facing_angles;
	newmis.classname = spawn_classname;
	newmis.spawnflags = spawn_spawnflags;
	newmis.target = spawn_target;
	newmis.message = spawn_msg;
	newmis.killtarget = spawn_killtarget;

	     if (newmis.classname=="monster_army")				    newmis.think = monster_army;                  //Grunt
	else if (newmis.classname=="monster_dog")                   newmis.think = monster_dog;                   //Dog
	else if (newmis.classname=="monster_ogre")                  newmis.think = monster_ogre;                  //Ogre
	else if (newmis.classname=="monster_knight")                newmis.think = monster_knight;                //Knight
	else if (newmis.classname=="monster_hell_knight")           newmis.think = monster_hell_knight;           //Hell Knight
	else if (newmis.classname=="monster_wizard")                newmis.think = monster_wizard;                //Scrag
	else if (newmis.classname=="monster_demon1")                newmis.think = monster_demon1;                //Fiend
	else if (newmis.classname=="monster_shambler")              newmis.think = monster_shambler;              //Shambler
	else if (newmis.classname=="monster_boss")                  newmis.think = monster_boss;                  //Chton
	else if (newmis.classname=="monster_enforcer")              newmis.think = monster_enforcer;              //Enforcer
	else if (newmis.classname=="monster_shalrath")              newmis.think = monster_shalrath;              //Vore
	else if (newmis.classname=="monster_tarbaby")               newmis.think = monster_tarbaby;               //Spawn
	else if (newmis.classname=="monster_fish")                  newmis.think = monster_fish;                  //Rotfish
	else if (newmis.classname=="monster_oldone")                newmis.think = monster_oldone;                //Shub-Niggurath
	else if (newmis.classname=="monster_zombie")                newmis.think = monster_zombie;                //Zombie
	else if (newmis.classname=="item_cells")                    newmis.think = item_cells;                    //Thunderbolt ammo
	else if (newmis.classname=="item_rockets")                  newmis.think = item_rockets;                  //Rockets
	else if (newmis.classname=="item_shells")                   newmis.think = item_shells;                   //Shells
	else if (newmis.classname=="item_spikes")                   newmis.think = item_spikes;                   //Nailgun/Perforator ammo
	else if (newmis.classname=="item_health")                   newmis.think = item_health;                   //Health pack
	else if (newmis.classname=="item_artifact_envirosuit")      newmis.think = item_artifact_envirosuit;      //Environmental protection suit
	else if (newmis.classname=="item_artifact_super_damage")    newmis.think = item_artifact_super_damage;    //Quad damage
	else if (newmis.classname=="item_artifact_invulnerability") newmis.think = item_artifact_invulnerability; //Pentagram of Protection
	else if (newmis.classname=="item_artifact_invisibility")    newmis.think = item_artifact_invisibility;    //Ring of Shadows
	else if (newmis.classname=="item_armorInv")                 newmis.think = item_armorInv;                 //Red armor (200%)
	else if (newmis.classname=="item_armor2")                   newmis.think = item_armor2;                   //Yellow armor (150%)
	else if (newmis.classname=="item_armor1")                   newmis.think = item_armor1;                   //Green armor (100%)
	else if (newmis.classname=="item_key1")                     newmis.think = item_key1;                     //Silver key
	else if (newmis.classname=="item_key2")                     newmis.think = item_key2;                     //Gold key
	else if (newmis.classname=="item_sigil")                    newmis.think = item_sigil;                    //Sigil
	else if (newmis.classname=="weapon_supershotgun")           newmis.think = weapon_supershotgun;           //Double-barrelled shotgun
	else if (newmis.classname=="weapon_nailgun")                newmis.think = weapon_nailgun;                //Nailgun
	else if (newmis.classname=="weapon_supernailgun")           newmis.think = weapon_supernailgun;           //Super nailgun
	else if (newmis.classname=="weapon_grenadelauncher")        newmis.think = weapon_grenadelauncher;        //Grenade launcher
	else if (newmis.classname=="weapon_rocketlauncher")         newmis.think = weapon_rocketlauncher;         //Rocket launcher
	else if (newmis.classname=="weapon_lightning")              newmis.think = weapon_lightning;              //Thunderbolt
	else if (newmis.classname=="misc_fireball")                 newmis.think = misc_fireball;                 //Small fireball
	else if (newmis.classname=="misc_explobox")                 newmis.think = misc_explobox;                 //Large exploding container
	else if (newmis.classname=="misc_explobox2")                newmis.think = misc_explobox2;                //Small exploding container
	else if (newmis.classname=="misc_model")                    newmis.think = misc_model;                    //External model
	
	if(spawn_enemy != world) newmis.enemy = spawn_enemy;
	
	entity t = spawn ();
	t.enemy = newmis;
	t.think = post_spawn;
	t.nextthink = time + 0.2;
	
	if(newmis.think) newmis.nextthink = time;	
}

void func_spawner_use (void)
{
	spawn_something(self.model, self.origin, self.angles, self.spawnflags, self.effects&SPAWN_TELEPORT, self.enemy, self.killtarget, self.target, self.message);
}

void func_spawner (void)
{
	setsize(self,'-16 -16 0','16 16 56');
	setorigin(self,self.origin);

	self.use=func_spawner_use;
}

/*QUAKED func_mover (1 .8 0) (-16 -16 0) (16 16 56)
Synchronizes the slave point entity sharing its netname on the moves of its target solid entity in a very basic way
*/
void do_mover_use (void)
{
	if(self.solid==1)
		setorigin(self.chain, (self.groundentity.absmin+self.groundentity.absmax)*0.5 + self.oldorigin);
	else
		self.chain.origin = (self.groundentity.absmin+self.groundentity.absmax)*0.5 + self.oldorigin;
	self.nextthink = time + self.frags;
}

void mover_use (void)
{
	if(self.think == SUB_Null)
	{
		self.nextthink = time + self.frags;
		self.think = do_mover_use;
	}
	else
	{
		self.nextthink = -1;
		self.think = SUB_Null;
	}
}

void mover_init (void)
{
	self.groundentity = find(world,targetname,self.target); //master
	self.chain = find(world,targetname,self.map); //slave
	if(self.chain.origin=='0 0 0'||self.solid==1)
	{
		self.solid=1;
		self.oldorigin = ((self.chain.absmin+self.chain.absmax) - (self.groundentity.absmin+self.groundentity.absmax))*0.5;
	}
	else
		self.oldorigin = self.chain.origin - (self.groundentity.absmin+self.groundentity.absmax)*0.5;
	self.think = SUB_Null;
	self.use = mover_use;
}

void func_mover (void)
{
	self.map = self.netname;
	self.netname = string_null;
	if(!self.frags) self.frags = 0.1;
	
	self.nextthink = time + 1;
	self.think = mover_init;
}

/*QUAKED func_rotator (1 .8 0) (-16 -16 0) (16 16 56)
Very basic entity able to rotate
*/
void rotator_use (void)
{
	if(self.finalangle == '0 0 0')
	{
		cvar_set("gl_affinemodels", "0"); //Totally out of place here but never mind, since we're already setting a cvar just below, let's make a wholesale! This setting keeps the torture room models' skins from warping
		cvar_set("sv_gameplayfix_multiplethinks", "1");
		self.finalangle = self.angles + self.mangle; //Set when entering the function for the first time only
		if(self.noise) sound (self, CHAN_VOICE, self.noise, self.volume, ATTN_NORM);
	}

	//Angle calculation
	float alen = vlen(self.mangle)*10;			// calculate length of the vector needed to move
	self.angletime = self.delay / alen;		// divide desired duration of the rotation by the distance to go

	if(fabs(vlen(self.finalangle-self.angles)) < 1)
	{	
		self.angles = self.finalangle;
		self.finalangle = '0 0 0';
		self.mangle = self.mangle * -1; //Back and forth
		self.nextthink = 0;
		if(self.noise2)
			sound (self, CHAN_VOICE, self.noise2, self.volume, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "misc/null.wav", self.volume, ATTN_NORM);
		return;
	}
	else
	{
		// scale the self.mangle vector by the time spent traveling to get velocity
		self.angles	= self.angles + self.mangle * (1/alen);
	}
	
	// set nextthink to trigger a think when dest is reached
	self.nextthink = time + self.angletime;
}

void func_rotator (void)
{
	if(self.noise) precache_sound (self.noise);
	if(self.noise2) precache_sound (self.noise2);
	if(self.volume==0) self.volume = 0.7;
	
	self.solid = SOLID_BSP;
	setmodel (self, self.model);
	if(!self.delay) self.delay=3;
	self.use = rotator_use;
	self.think = rotator_use;
	self.nextthink = 0;
}

/*QUAKED func_doomdoor (1 .8 0) (-16 -16 0) (16 16 56)
Slice of a door à la Doom upper-pegged door
*/
void doomdoor_usenext (void) { self = self.enemy; self.use(); }

void doomdoor_use (void)
{
	entity myself = self;
	
	//Find the next func_doomdoor (the one just above)
	entity next = world;
	do
	{
		next = find (next, classname, "func_doomdoor");
		if (!next) break;
		if (!(next.mins_x == myself.mins_x && next.maxs_x == myself.maxs_x && next.mins_y == myself.mins_y && next.maxs_y == myself.maxs_y && next.mins_z == myself.maxs_z)) continue;
		myself.enemy = next;
		myself.think = doomdoor_usenext;
		myself.nextthink = time + 0.01;
	} while (1);
	
	self.solid = SOLID_NOT;
	setmodel (self, "");
}

void func_doomdoor (void)
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;
	setmodel (self, self.model);
	self.use = doomdoor_use;
}

/*QUAKED func_playtrack (1 .8 0) (-16 -16 0) (16 16 56)
Plays the CD track or music file in self.sounds
Range [2-11] (or higher values)
*/

void func_playtrack_use (void)
{
	WriteByte (MSG_ALL, SVC_CDTRACK);
	WriteByte (MSG_ALL, self.sounds);
	WriteByte (MSG_ALL, self.sounds);
}

void func_playtrack (void)
{
	setsize(self,'-8 -8 -8','8 8 8');
	setorigin(self,self.origin);
	self.use=func_playtrack_use;
}

/*QUAKED func_playerclip
A bbox entity which is solid for the player only
*/
void() func_playerclip =
{
	setmodel (self, self.model);	// set size and link into world
};

/*QUAKED func_cvarbuffer (.5 .5 .5) (-8 -8 -8) (8 8 8)
*/

void () cvarbuffer_use =
{
	if(self.armortype>0)
	{
		//Time to restore
		cvar_set("fov", ftos(self.armortype));
		cvar_set("crosshair", ftos(self.ammo_nails));
		player.invisible_finished = 0;
		//Reset for a potential next use
		self.armortype = 0;
	}
	else
	{
		//Time to store
		self.armortype = cvar("fov");
		self.ammo_nails = cvar("crosshair");
		player.flags = player.flags - (player.flags & FL_ONGROUND);
	}
};

void() func_cvarbuffer =
{	
	self.use = cvarbuffer_use;
};

/*QUAKED func_veil
A bbox entity which is non solid and can be killed (unlike the func_illusionary)
*/
void() func_veil =
{
	setmodel (self, self.model);	// set size and link into world
	self.solid=SOLID_NOT;
};