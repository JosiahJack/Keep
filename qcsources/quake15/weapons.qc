/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;
void(float damage) spawn_touchblood;


// called by worldspawn
void() W_Precache =
{
	
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/xpld_wat.wav");
	precache_sound (SOUND_REXP3);
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/ngslow.wav");	// spike gun slowmo
	precache_sound ("weapons/sngslow.wav");	// super spike gun slowmo
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/spikespn.wav");// super nailgun spin click
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
	precache_sound ("weapons/lg_hum.wav");	//LG idle sound
	precache_sound ("weapons/rockload.wav");// rocket chambering sound
	precache_sound ("weapons/grenarm.wav");	// offhand grenade
	precache_sound ("weapons/grenthrow.wav");	// offhand grenade
	precache_sound ("weapons/proxexp.wav");	// offhand grenade
	
	//QC
	precache_sound ("weapons/ssg2.wav");	// QC super shotgun
	
	//hip weapons
	precache_sound ("hipweap/laserg.wav");   // laser cannon
	precache_sound ("hipweap/laserric.wav");   // laser cannon ricochet
	precache_sound2 ("enforcer/enfstop.wav");  // Laser dispersal
	precache_sound ("hipweap/proxwarn.wav");   // proximity bomb
	precache_sound ("hipweap/proxbomb.wav");   // proximity bomb
	precache_sound ("hipweap/proxstick.wav");   // proximity bomb
	
	precache_sound ("hipweap/hipmelt.wav");
	precache_sound ("hipweap/hipmelt2.wav");
	
	//chainsaw
	precache_sound ("weapons/sawatck.wav");
	precache_sound ("weapons/sawguts.wav");
	precache_sound ("weapons/saw_metal.wav");
	precache_sound ("weapons/sawridle.wav");
	precache_sound ("weapons/sawidle.wav");
	
	//grappling hook
	precache_sound ("shambler/smack.wav");
        precache_sound ("hook/chain1.wav");
        precache_sound ("hook/chain2.wav");
        precache_sound ("hook/launch.wav");
        precache_sound ("hook/retract.wav");
	
};

void() gib_stuck_think = 
{ 

   setorigin(self, self.pos1 + self.owner.origin - self.pos2); 
   self.think = gib_stuck_think;
   self.nextthink = time; 
}; 

//SNG EFFECTS
void() stickgib_touch = 
{
	if (other.classname == "player")
		return;
	else if (other.solid != SOLID_BSP)
		return;
	else if (other.classname == "func_breakable")
		self.gravity = 1;
	else
		self.movetype = MOVETYPE_FLY;
	self.solid = SOLID_NOT;
	self.velocity = 0;

	self.traileffectnum = particleeffectnum("gibd");
	if (other.solid == SOLID_BSP && other != world && other.classname != "func_breakable") 
	{ 
	        self.owner = other; 
	        self.pos1 = self.origin; 
	        self.pos2 = other.origin; 
	       // self.aflag = time + 10; 
	        self.think = gib_stuck_think; 
	        self.nextthink = time; 
	} 
	/*else 
	{ 
	        self.nextthink = time + autocvar_spikelifetime;     	//add this, to prevent packet overflows 
	        self.think = SUB_Remove;        			//add this for same reason as above 
	} */
	//self.think = SUB_Remove;
	//self.nextthink = time + 
}

void(string gibname, float skintype) StickGib = 
{
	local vector dir;
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	
	if (self.classname == "player")
		new.colormap = self.colormap;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	
	dir = normalize(v_forward); //make sure "dir" has length 1
	makevectors(self.enemy.v_angle);
	
	if (gibname == "progs/gib_enforcer_torso_sng2.mdl" || gibname == "progs/gib_enforcer_torso_nail.mdl" || gibname == "progs/gib_soldhead.mdl")
		new.origin_z = new.origin_z + 15;
	new.velocity = aim(self.enemy, 2);
	
	if (cvar("slowmo") > 0.7)
	{
		new.gravity = 0.8;
		new.velocity = v_forward*3000;
	}
	else
	{
		new.gravity = 0.5;
		new.velocity = v_forward * 1000;
	}
	//new.velocity_z = self.owner.v_angle_x * 100;
        //new.velocity = dir * (1050 + 50*random());
	//new.velocity = dir*1050; 
	new.movetype = MOVETYPE_TOSS;
	new.angles = vectoangles(-new.velocity);
	
	new.traileffectnum = particleeffectnum("hldecalB");
	
	if (skintype == 1)
		new.skin = 1;
	else
		new.skin = 0;
	//new.angles_y = new.angles_x - 40;
	//new.gravity = 0.1;
	new.solid = SOLID_TRIGGER;
	new.touch = stickgib_touch;
	//new.avelocity_x = random()*100;
	//if (other.solid == SOLID_BSP) 
              //  new.velocity = 0; 
	//new.avelocity_y = random()*100;
	//new.avelocity_z = random()*600;
	//new.think = SUB_Remove;
	//new.ltime = time;
	//new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	//new.flags = 0;
};

/*
================
HIPNOTIC WEAPONS
================
*/

void() exploderun;

void() laserdie =
{
	local entity spark;
	
	spark = spawn();
	
	setmodel(spark, "progs/s_plasma.spr");
	setorigin(spark, self.origin);
	
	spark.think = exploderun;
	spark.scale = 0.7;
	if (self.classname == "hiplaser" || self.model == "progs/lasrspik.mdl")
		spark.colormod = '1 0 0';
	else
		spark.colormod = '1 .4 0';
		
	spark.effects = spark.effects + EF_ADDITIVE;
	
	spark.nextthink = time;
	
}

void() HIP_LaserTouch =
{
	local vector org;
   local vector spot1,spot2;
   local vector oldvel;
   local float mag;
   local float r;
   

   self.owner = world;
   self.cnt = self.cnt + 1;
   if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID)
	{
		remove(self);
		return;
	}
   oldvel = normalize(self.old_velocity);
   spot1 = self.origin - (16*oldvel);
   spot2 = self.origin + (16*oldvel);
   traceline (spot1, spot2, FALSE, self);  // see through other monsters
   self.origin = trace_endpos;

   org = self.origin;
   

	if (other.health)
      {
      if (self.lastvictim == other)
         {
         self.dmg = self.dmg / 2;
         }
      spawn_touchblood (self.dmg);
      
      if(other.health < 22)
      {
	T_Damage (other, self, self.lastvictim, self.dmg*10);
      }
      else
	T_Damage (other, self, self.lastvictim, self.dmg);
	
      
	sendParticle("hiplaser_impact", org, '0 0 0', 1); 
	
      laserdie(); //laser effect
      
      }
   else if ((self.cnt == 3) || (random()<0.15))
      {
		/*WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);*/
		sendParticle("hiplaser_impact", org, '0 0 0', 1); 
		laserdie();
      }
   else
      {
//      self.dmg = 0.66 * self.dmg;
      self.dmg = 0.9 * self.dmg;
//      self.speed = 0.95 * self.speed;
      self.velocity = oldvel+(2*trace_plane_normal);
      self.velocity = normalize(self.velocity);
      self.velocity = self.speed * self.velocity;
      self.old_velocity = self.velocity;
      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;
      r = random();
      sound7 (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC, SNDSPD);
/*
      if (r<0.33)
         sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
      else if (r<0.66)
         sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
      else
         sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/

      return;
      }
   sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
   remove(self);

};
void() HIP_LaserThink =
   {
   local float delta;


   if (time>self.attack_finished)
      {
      remove(self);
      return;
      }
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;
   self.velocity = self.old_velocity;
   self.angles = vectoangles(self.velocity);
   self.nextthink = time+0.1;
   };

void(vector org, vector vec, float light) HIP_LaunchLaser =
{
//   sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	sound7 (self ,CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM, SNDSPD);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.classname = "hiplaser";
	newmis.lastvictim = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	//if (light)
	//newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/lasrspik.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.traileffectnum = particleeffectnum("hiplaser_trail");

	newmis.speed = 1000;
	newmis.dmg = 18;
	newmis.velocity = vec * newmis.speed;
	newmis.old_velocity = newmis.velocity;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.avelocity = '0 0 400';

	newmis.nextthink = time;
	newmis.attack_finished = time + 5;
	newmis.think = HIP_LaserThink;
	newmis.touch = HIP_LaserTouch;
	newmis.count = 0;

};

/*
=================
HIP_FireLaser
=================
*/

//muzzleflash prototypes
/*void(float spscale, vector offset, vector color, float spritealpha) SpawnSpark_Flash;
void(float spscale, vector offset, float smokedir, vector color, float spritealpha) SpawnSmoke_Flash;
void(vector offset, vector color) SpawnSNGFlash;*/


void(float stat) HIP_FireLaser =
   {
	local vector org;
   local vector dir;
   local vector out;
   local float ofs;
   local float aofs;
	
	if (!self.button0)
	{
		//if (self.weaponframe >= 1)
		self.weaponframe++;
		//if (self.weaponframe >= 7)
		//	self.weaponframe = 0;
		self.nextthink = time + 0.1;
		player_run ();
		return;
	}
     self.weaponframe++;
     if (self.weaponframe >= 7)
	self.weaponframe = 1;
   if (self.ammo_cells < 1)
      {
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
      }
   SuperDamageSound();
   self.effects = self.effects | EF_MUZZLEFLASH;
   makevectors (self.v_angle);
 

   ofs = 6;
   out = v_forward;
   out_z = 0;
   out = normalize(out);
   if (autocvar_centered_weapons)
	org = self.origin + ((12-ofs) * v_up) + (12*out);
   else
	org = self.origin + ((12-ofs) * v_up) + (12*out) + v_right*5;
//   org = self.origin + (1*v_forward);
   dir = aim (self, 1000);
   aofs = ofs * 0.707;
   if (stat == 0 && (self.weaponframe == 3 || self.weaponframe == 6))
      {
      self.currentammo = self.ammo_cells = self.ammo_cells - 1;
      org = org + (aofs*v_right);
      org = org - (aofs*v_up);
      HIP_LaunchLaser(org, dir, 0);
      org = org - (2*aofs*v_right);
      HIP_LaunchLaser(org, dir, 0);
      
      if (!autocvar_centered_weapons)
      {
	     SpawnSmoke_Flash(.3, '0 35 -17', 1, 0, .5);
	      
	      SpawnSpark_Flash(1.1, '15 -6 -10', '1 0 0.1', 1);
	      
	      SpawnSNGFlash('0 23 -18','1 0.1 0.1'); 
	}
      
     // SpawnSpark_Flash(.9, '15 -16 0', '1 0 0.1', 1);
      }
   else if (stat == 1 && (self.weaponframe == 3 || self.weaponframe == 6))
      {
      	if (!autocvar_centered_weapons)
        {
		SpawnSpark_Flash(.9, '15 -8 11', '1 0 0.1', 1);
		
		SpawnSmoke_Flash(.3, '0 24 -15', 1, 0, .7);
		
		 SpawnSNGFlash('0 17 -13','1 0.1 0.1'); 
	}
      	 
      self.currentammo = self.ammo_cells = self.ammo_cells - 1;
      org = org + (ofs*v_up);
      if (random()<0.1)
         {
         HIP_LaunchLaser(org, dir, 1);
         newmis.dmg = 25;
         }
      else
         HIP_LaunchLaser(org, dir, 0);
      }
   self.punchangle_x = -1;
   self.nextthink = time + 0.035;
   };
 
// END HIP WEAPONS
// END HIP WEAPONS

/*float() crandom =
{
	return 2*(random() - 0.5);
};*/


float() crandom =	
{
	return 2*(random() - 0.5);
};


void(vector org, vector vel) SpawnMeatSpray_eviltexture =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity_x = vel_x * crandom() * 2.5;
	missile.velocity_y = vel_y * crandom() * 2.5;
	missile.velocity_z = vel_z + 130 + 100*random();

	missile.avelocity = '3000 1000 2000';
	
	local float zufall;
	zufall = random();		// randomize gib sizes
	    if (zufall > 0.8)  
	    	missile.scale = 1.6;
	    else if (zufall > 0.6)  
	    	missile.scale = 1.3;
	    else if (zufall > 0.4)  
	    	missile.scale = 1;
	    else if (zufall > 0.2) 
	    	missile.scale = 0.7;
	    else 
	    	missile.scale = 0.4;

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};


void() melee_kick1;
void() melee_kick6;
void() melee_kickax1;
void() melee_kickax6;
void() W_FireAxe2;

void() meleeaxe =		// starts instant melee axe attack.  
{
	//if (!autocvar_zombieaxeanimation)	
		self.weaponmodel = "progs/v_boot.mdl";
	//else
	//	self.weaponmodel = "progs/v_boot.mdl";
	sound7 (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
	self.attack_finished = time + 0.6;
	self.meleeing = 1;
	

	if (random() < 0.5)
	{
		if (self.weapon == IT_AXE)
			melee_kickax1();
		else
			melee_kick1();
	}
	else
		if (self.weapon == IT_AXE)
			melee_kickax6();
		else
			melee_kick6();
	W_FireAxe2();		// needed for gibbing corpses 
};



/*
================
W_FireAxe
================
*/


void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;
	local float 	zufall;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	if (trace_endpos_z > (trace_ent.origin_z + 16) && trace_ent != world)
		trace_ent.hitbox_pos = HEAD_SHOT; // Tag as headshot in entity
		
	////  added GYRO below
	local entity axeforce;
	local vector axevec;
	local vector dir;

	dir = aim (self, 1000);
	axevec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	axeforce = Gyro_Force_Create("axe_hit", self.origin);

	Gyro_Force_ApplyFalloff_ConeLinear(axeforce, axevec, 20, 20);
	//If kicking, set gyro force really high for knockback, else set force low - lets you kick smaller dudes into lava and fun shit like that
	if (self.meleeing == 1)
	{
		//apply some velocity on top of gyro to ensure enemy is moved by kick
		if (trace_ent.flags & FL_MONSTER)
		{
			setorigin(trace_ent, trace_ent.origin + '0 0 5');
			//trace_ent.velocity_z = 3;
			trace_ent.flags = trace_ent.flags - FL_ONGROUND;
			trace_ent.velocity = trace_ent.velocity+v_forward*70+v_up*100;
			
			//enforce stunned state
			trace_ent.pain_finished = time - 1.5;
		}
		
		Gyro_Force_ApplyAffector_Directional(axeforce, axevec, 1955, FALSE);
	}
	else
		Gyro_Force_ApplyAffector_Directional(axeforce, axevec, 5, FALSE);
	Gyro_Force_AddProperty_Instant(axeforce);
	Gyro_Force_Ignore(axeforce, self); 	

	org = trace_endpos - v_forward*4;
	
	if (trace_ent.takedamage)
	{
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			//check if entity is breakable first
			if (trace_ent.classtype == CT_FUNCBREAK) 
			{
				if (trace_ent.noise == "boss2/pop2.wav" || trace_ent.noise == "blob/death1.wav")
					sound (self, CHAN_WEAPON,"player/axeflesh3.wav", 1, ATTN_NORM);
				if (trace_ent.style == BTYPE_WOOD) 
					sound (self, CHAN_AUTO, SOUND_AXE_WOOD, 1, ATTN_NORM);
				else if (trace_ent.style == BTYPE_GLASS) 
					sound (self, CHAN_WEAPON, SOUND_AXE_GLASS, 1, ATTN_NORM);
				else if (trace_ent.style == BTYPE_METAL) 
					sound (self, CHAN_WEAPON, SOUND_AXE_METAL, 1, ATTN_NORM);
				else
					sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
			}
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2") && (trace_ent.classname != "monster_enforcer") && (trace_ent.classname != "monster_reiver") && (trace_ent.classname != "monster_oldone"))	// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					sendParticle("secret", org, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					sendParticle("TE_GUNSHOT", org, '0 0 0', 1); 
				if (trace_ent.classtype != CT_FUNCBREAK)
					sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
				T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
				T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
				return;
			}
		}

		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		SpawnMeatSpray (self.origin + v_forward * 30 + v_up*-10, v_right*-75 + v_up*-10);
		//SpawnMeatSpray (self.origin + v_forward * 30 + v_up*-2, v_right*-15);
		
		if (autocvar_zombienewmodelproperties >= 1)		// new zombie model is killable with axe 
			{
			if ((trace_ent.classname == "monster_zombie")&&(trace_ent.monstermodel == 2))   
				{
				if (trace_ent.axehitcount < 2)			
					T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
				else	
					T_Damage (trace_ent, self, self, 500);		// when hitting the 3rd (!) time, do 500 damage --> zombie dies
				}
			else
				T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
			}
		else	
			T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
		
		

		zufall = random();
		if (self.meleeing == 1)
		{
			if (zufall > 0.66)
				sound7 (self, CHAN_WEAPON, "player/kickflesh.wav", 0.7, ATTN_NORM), SNDSPD;
			else
				sound7 (self, CHAN_WEAPON, "player/kickflesh2.wav", 0.7, ATTN_NORM, SNDSPD);
		}
		else
		{
			if (zufall > 0.66)
				sound7 (self, CHAN_WEAPON, "player/axeflesh1.wav", 0.7, ATTN_NORM, SNDSPD);
			else if (zufall < 0.34)
				sound7 (self, CHAN_WEAPON, "player/axeflesh2.wav", 0.7, ATTN_NORM, SNDSPD);
			else
				sound7 (self, CHAN_WEAPON, "player/axeflesh3.wav", 0.7, ATTN_NORM, SNDSPD);
		}
						

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
			ThrowBloodSplat(dir, trace_endpos, trace_ent);
			ThrowBloodSplat(dir, trace_endpos, trace_ent);

			/*
			if (trace_ent.classname == "monster_wizard")
			{        
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1);
		 		ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
			}
			else if (trace_ent.classname == "monster_army")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_ogre")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_hell_knight")
			{
				sendParticle("sparks", org, '0 0 0', 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
			}
			else if (trace_ent.classname == "monster_hell_knight2")
			{
				sendParticle("sparks", org, '0 0 0', 1); 
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				}
			}
			else if (trace_ent.classname == "monster_enforcer")
			{
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				}
			}
			else if (trace_ent.classname == "monster_knight")
			{
				sendParticle("sparks", org, '0 0 0', 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_demon1")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
			}
			else if (trace_ent.classname == "monster_dog")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
			}
			else if (trace_ent.classname == "monster_shalrath")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
			}
			else if (trace_ent.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
			}
			else if (trace_ent.classname == "monster_shambler")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_reiver")
			{
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				}
			}
			else 
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}*/
		}
				
	}
	else
	{	// hit wall
		if (autocvar_evil_faces)
		{
			local float surfnum, zu;
			local string s;
			surfnum = getsurfacenearpoint(world, trace_endpos);
			if (surfnum >= 0)
			{
				s = getsurfacetexture(world, surfnum);
				if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
				{
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnBlood (org, '0 0 0', 20);
					zu = random();
					if (zu > 0.66)
						sound (self, CHAN_WEAPON, "player/axeflesh1.wav", 0.7, ATTN_NORM);
					else if (zu < 0.34)
						sound (self, CHAN_WEAPON, "player/axeflesh2.wav", 0.7, ATTN_NORM);
					else
						sound (self, CHAN_WEAPON, "player/axeflesh3.wav", 0.7, ATTN_NORM);
					if (facetime < time)
					{
						facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
						local vector face_spawn_pos, face_spawn_vel;
						face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
						face_spawn_vel = normalize (trace_plane_normal);	
						face_spawn_vel = face_spawn_vel * 10;
						spawn_face (face_spawn_pos, face_spawn_vel, 1);
					}
					return;						
				}
			}
		}
		if (trace_ent.inflamed == 1)
		{
			trace_ent.health = -1;
			trace_ent.nextthink = time;
			trace_ent.think = trace_ent.th_die;
			return;
		}
			
		local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, org);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if (returnsurface(tex) == GROUND)
			{
				sendParticle("TE_DIRT", org, '0 0 0', 1);
				sound7 (self, CHAN_AUTO, "player/kickhitw.wav", 1, ATTN_NORM, SNDSPD);
				return;
			}
			else if (returnsurface(tex) == MEAT)
			{
				sendParticle("TE_BLOOD", org, '0 0 0', 1);
				sound7 (self, CHAN_WEAPON, "kickgib/gib_hit.wav", 1, ATTN_NORM, SNDSPD);
				return;
			}
			else if (returnsurface(tex) == VOID)
				return;
				
				
		}
		
		if (self.meleeing == 1)
			sound7 (self, CHAN_AUTO, "player/kickhitw.wav", 1, ATTN_NORM, SNDSPD);
		else
			sound7 (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM, SNDSPD);
		
		if (self.meleeing == 1)
			sendParticle("TE_DIRT", org, '0 0 0', 1);
		else
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
		}
	}
};


void() W_FireAxe2 =		// function which takes care of axe gibbing corpses
{
	local	vector	source;
	local	vector	org;
	

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*70, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.i_am_a_corpse)
	{
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
		local float zufall;
		zufall = random();
		if (zufall > 0.66)
			sound7 (self, CHAN_WEAPON, "player/axeflesh1.wav", 0.7, ATTN_NORM, SNDSPD);
		else if (zufall < 0.34)
			sound7 (self, CHAN_WEAPON, "player/axeflesh2.wav", 0.7, ATTN_NORM, SNDSPD);
		else
			sound7 (self, CHAN_WEAPON, "player/axeflesh3.wav", 0.7, ATTN_NORM, SNDSPD);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	missile.traileffectnum = particleeffectnum("gibnull");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};

/*
void()	spriterun =
{
	self.frame++;
	self.think = spriterun;
	self.nextthink = time + 0.03;
	if (self.frame > 16)
		remove(self);
}*/


/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	if (trace_ent.classname == "ShalrathMissile" || trace_ent.classname == "monster_jim" || trace_ent.classname == "func_breakable")	// do not spawn blood on non-flesh materials
	{
		sendParticle("TE_GUNSHOT", org, '0 0 0', 1); //spark effect
		return;	
	}
	
	/*local entity sprite;
	sprite = spawn();
	setorigin(sprite, org);
	setmodel(sprite, "progs/bhlblood.spr32");
	sprite.alpha = 0.4;
	sprite.scale = 0.4;
	sprite.think = spriterun;
	sprite.nextthink = time;*/
	
	if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
		particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
================
W_FireSaw
================
*/

void zombie_die();

void() W_FireSaw =
{
	local	vector	source;
	local	vector	org;
	
	
	//self.nextthink = time + 0.1;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	if (trace_endpos_z > (trace_ent.origin_z + 16) && trace_ent != world)
		trace_ent.hitbox_pos = HEAD_SHOT; // Tag as headshot in entity
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 2;
		
		if (trace_ent.classname == "func_breakable" || trace_ent.classname == "light_fluoropost")
			sendParticle("TE_SUPERSPIKE", org, '0 0 0', 1); 
		else if (trace_ent.classname == "monster_hell_knight" || trace_ent.classname == "monster_knight" || trace_ent.classname == "monster_hell_knight2" || (trace_ent.classname == "monster_ogre" && trace_ent.hitbox_pos != HEAD_SHOT) || trace_ent.classname == "monster_jim" || trace_ent.classname == "monster_freddie")
		{
			sound7 (self, CHAN_ITEM, "weapons/saw_metal.wav", .6, ATTN_NORM,SNDSPD);
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_SPIKE);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
			ThrowBloodSplat(v_forward*2, trace_endpos, trace_ent);
			SpawnMeatSpray (self.origin + v_forward*16, ((random()*300) - 150) * v_right + (100 * v_forward));
		}
		else
		{
			SpawnBlood(trace_endpos, '0 0 5', 20);
			ThrowBloodSplat(v_forward*2, trace_endpos, trace_ent);
			SpawnMeatSpray (self.origin + v_forward*16, ((random()*300) - 150) * v_right + (100 * v_forward));
			
			if (random()>0.5)
				CeilSplat();
			sendParticle("blood_saw", org, '0 0 0', 1); 
		}
		
		if(trace_ent.model == "progs/zombie_noarms.mdl" || trace_ent.model == "progs/zombie1_noarms.mdl" || trace_ent.model == "progs/zombie_new.mdl" || trace_ent.meleeattack > 7)
			T_Damage (trace_ent, self, self, 65);
		if (deathmatch == 1)
			T_Damage (trace_ent, self, self, 25);
		else if (trace_ent.classname == "monster_hell_knight" || trace_ent.classname == "monster_knight" || trace_ent.classname == "monster_ogre")
			T_Damage (trace_ent, self, self, 7);
		else
			T_Damage (trace_ent, self, self, 12);
		
		if (trace_ent != world)
			trace_ent.velocity = trace_ent.velocity * 0.5;
			
		
		if (trace_ent.classname != "func_breakable" && trace_ent.classname != "light_fluoropost")
			sound7 (self, CHAN_WEAPON, "weapons/sawguts.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		
	}
	else
	{	// hit wall
	
		//catch wood and dirt materials and change particle accordingly
		local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, org);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if (returnsurface(tex) == GROUND)
			{
				sendParticle("TE_DIRT", org, '0 0 0', 1);
				return;
			}
			else if (returnsurface(tex) == MEAT)
			{
				sendParticle("TE_BLOOD", org, '0 0 0', 1);
				return;
			}
			else if (returnsurface(tex) == VOID)
				return;
		}
		//sound (self, CHAN_WEAPON, "weapons/sawguts.wav", 1, ATTN_NORM);
		sound7 (self, CHAN_ITEM, "weapons/saw_metal.wav", .6, ATTN_NORM, SNDSPD);
		//sendParticle("TE_SPIKE", org, '0 0 0', 1);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	self.punchangle_x = -2;
	self.attack_finished = time + 0.1;
};


/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/

void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		if (trace_endpos_z > (trace_ent.origin_z + 16))
		{
			trace_ent.hitbox_pos = HEAD_SHOT; // This is a head shot
		}
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2") && (trace_ent.classname != "monster_enforcer") && (trace_ent.classname != "monster_reiver") && (trace_ent.classname != "monster_oldone"))	// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
				{
					if (self.weapon == IT_SUPER_SHOTGUN)
						sendParticle("secret_shot2", org, '0 0 0', 1); 
					else
						sendParticle("secret_shot1", org, '0 0 0', 1); 
				}
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					sendParticle("TE_GUNSHOT", org, '0 0 0', 1); 
				AddMultiDamage (trace_ent, damage);
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				AddMultiDamage (trace_ent, damage);
				return;
			}

		}
		
		if (trace_ent.classname == "monster_spider")
			{
			local float resist;
			resist = autocvar_spider_attack_resistance * 0.01;
			if (random () > resist)		// decides if spider will resist this attack
				{
				SpawnBlood (org, vel*0.2, damage);
				AddMultiDamage (trace_ent, damage);
				}
			else
				return;
			}
		else
			{
			SpawnBlood (org, vel*0.2, damage);
			AddMultiDamage (trace_ent, damage);
			}

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
			if (trace_ent.classname == "monster_wizard")
			{        
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 0); 
			}
			else if (trace_ent.classname == "monster_army")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			else if (trace_ent.classname == "monster_ogre")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			else if (trace_ent.classname == "monster_hell_knight")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
				sendParticle("sparks", org, '0 0 0', 1); 
			}
			else if (trace_ent.classname == "monster_hell_knight2")
			{
				sendParticle("sparks", org, '0 0 0', 1); 
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
				}
			}
			else if (trace_ent.classname == "monster_enforcer")
			{
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
				}
			}
			else if (trace_ent.classname == "monster_reiver")
			{
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
				}
			}
			else if (trace_ent.classname == "monster_knight")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
				sendParticle("sparks", org, '0 0 0', 1); 
			}
			else if (trace_ent.classname == "monster_demon1")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 0);
			}
			else if (trace_ent.classname == "monster_dog")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
			}
			else if (trace_ent.classname == "monster_shalrath")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 0); 
			}
			else if (trace_ent.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 0); 
			}
			else if (trace_ent.classname == "monster_shambler")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			else 
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			ThrowBloodSplat(dir, trace_endpos, trace_ent);
		}

	}	
	else
	{
		if (autocvar_evil_faces)
		{
			local float surfnum;
			local string s;
			surfnum = getsurfacenearpoint(world, trace_endpos);
			if (surfnum >= 0)
			{
				s = getsurfacetexture(world, surfnum);
				if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
				{
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnBlood (org, '0 0 0', 5);
					if (facetime < time)
					{
						facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
						local vector face_spawn_pos, face_spawn_vel;
						face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
						face_spawn_vel = normalize (trace_plane_normal);	
						face_spawn_vel = face_spawn_vel * 10;
						spawn_face (face_spawn_pos, face_spawn_vel, 1);
					}
					return;
				}						
			}
		}
		
	 	local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, trace_endpos);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if ((tex == "sky1") || (tex == "sky4"))
				return;
		}
		
		if (trace_ent.inflamed == 1)
		{
			trace_ent.health = -1;
			trace_ent.nextthink = time;
			trace_ent.think = trace_ent.th_die;
			return;
		}
		
		//catch wood and dirt materials and change particle accordingly
		local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, org);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if (returnsurface(tex) == GROUND)
			{
				sendParticle("TE_DIRT", org, '0 0 0', 1);
				return;
			}
			else if (returnsurface(tex) == MEAT)
			{
				sendParticle("TE_BLOOD", org, '0 0 0', 1);
				return;
			}
			else if (returnsurface(tex) == VOID)
				return;
		}
		
		//spawn ent for ric sound because sound() requires an entity to function
		if (!coop && !deathmatch)
		{
			local entity ric = spawn();
			ric.origin = trace_endpos;
			ric.think = SUB_Remove;
			ric.nextthink = time + 0.1;
			
			if (random() < 0.5)
				sound7(ric, CHAN_AUTO, "weapons/ric1.wav", .5, ATTN_NORM, SNDSPD);
			else
				sound7(ric, CHAN_AUTO, "weapons/ric3.wav", .5, ATTN_NORM, SNDSPD);
			
		}
			
		

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
=========================
W_BulletSplash    (Thanx to Qrv for the code !)
=========================
*/
void (vector org) spawn_splash =
{
   	sendParticle("watersplash", org, '0 0 0', 1);
	precache_sound ("player/watersplash.wav");	
	sound (self, CHAN_VOICE, "player/watersplash.wav", 0.5, ATTN_NORM); 
};

void (vector org) spawn_lavasplash =
{
   	sendParticle("lavasplash", org, '0 0 0', 1);
	precache_sound ("ambience/lavasplash_shotgun.wav");	
	sound (self, CHAN_VOICE, "ambience/lavasplash_shotgun.wav", 0.5, ATTN_NORM); 
};


void(vector dir ) W_BulletSplash =
{
   local vector shot_src;
   local float steps;
   local float stepsize;
   local float shot_length;
   local float old_contents;
   
   // How far the bullets travel, FireBullets has this as 2048
   shot_length = 2048;
   
   // How large the check step is, larger = less accurate, but faster probably.
   // Keep this as a multiple of 2, ie, 2, 4, 8, 16, 32, ...
   stepsize = 2;
   
   // This calculates the correct stepping between shot_length and stepsize;
   steps = shot_length / stepsize;
   
   // Nicked from FireBullets, but we increase the Z a little, for strange situations when stood in water... o.O
   shot_src = self.origin + v_forward*10;
   shot_src_z = self.absmin_z + self.size_z * 0.75;
   
   // If the 'gun' is underwater here, we wont make a splash...
   if (( pointcontents(shot_src) == CONTENT_WATER )||( pointcontents(shot_src) == CONTENT_SLIME )||( pointcontents(shot_src) == CONTENT_LAVA))
   {
      //bprint("Hmm, shot started in water...\n");
      return;
   }

   // This may not be needed, but meh, it seems to work... o.o
   old_contents = pointcontents(shot_src);   
   
   // K, trace the line to the end of the shot
   traceline( shot_src, shot_src + dir * shot_length, FALSE, self );
   
   // We in water?
   if ( trace_inwater )
   {
      //bprint("Hit in water!\n");
      
      // Now, we'l check the traceline, till we find the point we enter the water
      while ( steps > 0 )
      {   
         shot_src = shot_src + dir * stepsize;
         
         if ( (pointcontents(shot_src) == CONTENT_WATER) || (pointcontents(shot_src) == CONTENT_SLIME) && ( old_contents != CONTENT_WATER) )
         {
            //bprint("In Water!\n");
            
            // Here, is where you would spawn your splash effect, shot_src is the closest origin to the
            // water brush intersection of the bullets our trace stepper has found.
		   spawn_splash (shot_src);

            // All done here
            return;
         }
         if ( (pointcontents(shot_src) == CONTENT_LAVA) && ( old_contents != CONTENT_WATER) )
         {
            //bprint("In Lava!\n");
            
            // Here, is where you would spawn your splash effect, shot_src is the closest origin to the
            // water brush intersection of the bullets our trace stepper has found.
		   spawn_lavasplash (shot_src);

            // All done here
            return;
         }
         steps = steps - 1;
      }
   }
};


/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/

void() bullet_enemy_touch;

void(vector org, vector dir) launch_bullet =
{
	newmis = spawn ();
	newmis.cansplash = TRUE;
	newmis.owner = self;
	if (autocvar_oldprojectiles)
		newmis.movetype = MOVETYPE_FLYMISSILE;
	else
		newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = bullet_enemy_touch;
	newmis.classname = "playershot";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 20;
	//newmis.think = BecomeExplosion;
	newmis.traileffectnum = particleeffectnum("spike_bubble_trail");
	newmis.nextthink = time + 6;
	newmis.effects = EF_FULLBRIGHT;
	setmodel (newmis, "progs/bullettr.mdl");
	if (self.waterlevel >= 3 && (cvar("slowmo") > 0.9))
		newmis.alpha = 0.01;
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	//nail speed
	if (cvar("slowmo") > .7)
		newmis.velocity = dir * 2000;
	else
		newmis.velocity = dir * self.bulletspeed;
};


void() FireBullets_Projectile =
{
	vector dir, org;
	if (autocvar_centered_weapons)
		org = self.origin + self.view_ofs + v_up * -8;
	else
		org = self.origin + self.view_ofs + v_up * -8 + v_right * 9;
	dir = aim (self, 1000);
	local float randomdir1, randomdir2, randomdir3;
	
	randomdir1 = random(0.02,-0.02);
	randomdir2 = random(0.05,-0.04);
	randomdir3 = random(-0.03,0);
	
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		launch_bullet (org, dir+(v_right*.1));
		launch_bullet (org, dir+(v_right*-.1));
		launch_bullet (org, dir+(v_up*.06)+(v_right*randomdir1));
		launch_bullet (org, dir+(v_up*-.03)+(v_right*.01));
		launch_bullet (org, dir+(v_up*.01));
		launch_bullet (org, dir+(v_up*-.02)+(v_right*randomdir1));
		
		launch_bullet (org, dir+(v_right*.1));
		launch_bullet (org, dir+(v_right*-.1));
		launch_bullet (org, dir+(v_up*.06)+(v_right*randomdir2));
		launch_bullet (org, dir+(v_up*-.03)+(v_right*-randomdir3));
		launch_bullet (org, dir+(v_up*-.03));
		launch_bullet (org, dir+(v_up*-.02)+(v_right*randomdir2));
		launch_bullet (org, dir+(v_up*randomdir2));
		launch_bullet (org, dir+(v_right*-randomdir2));
		//Gyro_Force_ApplyAffector_Directional(shot, shotvector, 30, FALSE);	// if player fires supershotgun (=14 shotcount)
	}
	else
	{
		launch_bullet (org, dir+(v_right*-randomdir3));
		launch_bullet (org, dir+(v_right*randomdir3));
		launch_bullet (org, dir+(v_up*randomdir2)+(v_right*randomdir1));
		launch_bullet (org, dir+(v_up*randomdir2)+(v_right*.01));
		launch_bullet (org, dir+(v_up*.01));
		launch_bullet (org, dir+(v_up*-randomdir3)+(v_right*-randomdir3));
		//Gyro_Force_ApplyAffector_Directional(shot, shotvector, 130, FALSE);	// if player fires shotgun (=6 shotcount)
	}
	local entity buckshot;
	local	vector align, shotvec;
	

	makevectors(self.v_angle);
	align = dir + v_up*0.27;
	traceline (self.origin, self.origin + align*200, FALSE, self);
	shotvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	buckshot = Gyro_Force_Create("shothit", self.origin);
	Gyro_Force_ApplyFalloff_ConeLinear(buckshot, shotvec, 16, 16);
	Gyro_Force_ApplyAffector_Directional(buckshot, shotvec, 2, FALSE);
	Gyro_Force_AddProperty_Instant(buckshot);
	Gyro_Force_Ignore(buckshot, self); 
};

void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);
	
	if ((cvar("slowmo") < 0.9) || (autocvar_bullet_projectiles == 1) || self.waterlevel >= 3)
	{
		FireBullets_Projectile();
		return;
	}

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (autocvar_player_shotgun_pellets, direction);	// default 4

		W_BulletSplash (direction);    	// Calls the water splash function	

		shotcount = shotcount - 1;

		////  added GYRO below
		local entity shot;
		local vector shotvector, align;
		align = dir + v_up * 0.25;								// aligns the angle of the force
		traceline (self.origin, self.origin + align*200, FALSE, self);		// sets the max distance of the force
		shotvector = (trace_endpos - self.origin) + (normalize(dir) * 80);	// sets the force vector
		shot = Gyro_Force_Create("gunshot", self.origin);				
		Gyro_Force_ApplyFalloff_ConeLinear(shot, shotvector, 18, 18);
		if (self.weapon == IT_SUPER_SHOTGUN)
		{
			Gyro_Force_ApplyAffector_Directional(shot, shotvector, 110, FALSE);	// if player fires supershotgun (=14 shotcount)
		}
		else
			Gyro_Force_ApplyAffector_Directional(shot, shotvector, 130, FALSE);	// if player fires shotgun (=6 shotcount)
		Gyro_Force_AddProperty_Instant(shot);
		Gyro_Force_Ignore(shot, self); 

	}
	ApplyMultiDamage ();
};

void(vector org, vector dir) launch_enemy_bullet;

void() FireBullets_Projectiles_Enemy =
{
	local	vector	dir, org;
	local	entity	en;
	
	ai_face();
		

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	if (autocvar_skill_adjusted_soldier_aiming)
	{
		if (skill == 2)
			dir = en.origin + en.velocity*0.1; 
		else
			dir = en.origin + en.velocity*0.05; 
	}
	else
		dir = en.origin;
		
	
	org = self.origin + v_up*12 - v_right*12 + v_forward*19;
	
	dir = normalize (dir - org);
	makevectors (self.angles);
	
	if (self.classname == "monster_army")
	{
		//sound7 (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM, SNDSPD);
		launch_enemy_bullet (org, dir+(v_right*.1));
		launch_enemy_bullet (org, dir+(v_right*-.1));
		launch_enemy_bullet (org, dir+(v_up*.06)+(v_right*-.02));
		launch_enemy_bullet (org, dir+(v_up*-.03)+(v_right*.01));
	}
	else if (self.classname == "monster_enforcer")
	{
		//sound7 (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM, SNDSPD);
		launch_enemy_bullet (org+v_right*17, dir+(v_right*.1));
		launch_enemy_bullet (org+v_right*17, dir+(v_right*-.1));
		launch_enemy_bullet (org+v_right*17, dir+(v_up*.06)+(v_right*-.02));
		launch_enemy_bullet (org+v_right*17, dir+(v_up*-.03)+(v_right*.01));
		
		launch_enemy_bullet (org+v_right*17, dir+(v_right*.12));
		launch_enemy_bullet (org+v_right*17, dir+(v_right*-.07));
		launch_enemy_bullet (org+v_right*17, dir+(v_up*.09)+(v_right*-.03));
		launch_enemy_bullet (org+v_right*17, dir+(v_up*-.05)+(v_right*.03));
	}
	
};


void(float shotcount, vector dir, vector spread) FireBullets_soldier =
{
	local	vector direction;
	local	vector	src;
	
	if ((cvar("slowmo") < 0.9) || (autocvar_bullet_projectiles == 1))	
	{
		FireBullets_Projectiles_Enemy();
		return;
	}
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
		{
			var float autocvar_soldier_size_influenced_attack = 0; 			// set cvar 'soldier_size_influenced_attack' default to 0
			if (autocvar_soldier_size_influenced_attack == 1)			// if 'soldier_size_influenced_attack' is set via autoexec.cfg to '1' raise monster큦 attack values according to its size 
				TraceAttack (autocvar_soldier_gun * self.scale, direction);	// default 4
			else
				TraceAttack (autocvar_soldier_gun, direction);			// default 4
		}

		W_BulletSplash (direction);    	// Calls the water splash function	

		shotcount = shotcount - 1;

	////  added GYRO below
	local entity shot;
	local vector shotvector, align;
	align = dir + v_up * 0.25;								// aligns the angle of the force
	traceline (self.origin, self.origin + align*200, FALSE, self);		// sets the max distance of the force
	shotvector = (trace_endpos - self.origin) + (normalize(dir) * 80);	// sets the force vector
	shot = Gyro_Force_Create("gunshot", self.origin);				
	Gyro_Force_ApplyFalloff_ConeLinear(shot, shotvector, 18, 18);
	if (self.weapon == IT_SUPER_SHOTGUN)
		Gyro_Force_ApplyAffector_Directional(shot, shotvector, 88, FALSE);	// if player fires supershotgun (=14 shotcount)
	else
		Gyro_Force_ApplyAffector_Directional(shot, shotvector, 130, FALSE);	// if player fires shotgun (=6 shotcount)
	Gyro_Force_AddProperty_Instant(shot);
	Gyro_Force_Ignore(shot, self); 

	}
	ApplyMultiDamage ();
};

/*
===============
Weapon Effects
===============
*/
void(entity e, string spritepath, float spscale, vector pos_mod, vector startvelocity, vector velocityrandom, float startalpha, float emittertype) Sprite_Emitter;


void() updateSNG =
{
	if (self.owner.health <= 0 || intermission_running)
	{
		remove(self);
		return;
	}
	
	if (self.owner.weapon == IT_SUPER_NAILGUN && self.owner.meleeing == 0 && self.owner.throwing == 0)
	{
		if (autocvar_centered_weapons)
			setmodel(self, "progs/centered/v_nail2_barrel.mdl");
		else
			setmodel(self, "progs/v_nail2_barrel.mdl");
	}
	else
		setmodel(self, string_null);
	
	
	//overheating effect
	if (self.owner.weapon == IT_SUPER_NAILGUN)
	{
		if (self.owner.button0 && self.alpha < 1)
			self.alpha+=.005;
		else
		{
			if (self.alpha >= 0)
				self.alpha-=.002;
		}
	}
	
	if (!self.owner.button0 && self.owner.weapon == IT_SUPER_NAILGUN)
	{
		//if (self.alpha > 0.873 && self.alpha < 0.874 || self.alpha > 0.676 && self.alpha < 0.677 || self.alpha > 0.780 && self.alpha < 0.781 || self.alpha > 0.983 && self.alpha < 0.984 || self.alpha > 0.986 && self.alpha < 0.987)
		if (random(100) < 2 && self.alpha > 0.6)
			Sprite_Emitter(self.owner, "progs/s_smoke_muzz.spr", random(.02, .04), '23 -5 -6', '1 1 .2', '5 1 .3', .4, TYPE_STANDARD);
			
		//if (self.alpha > 0.5 && self.alpha < 0.51 || self.alpha > 0.6 && self.alpha < 0.61 || self.alpha > 0.7 && self.alpha < 0.71 || self.alpha > 0.9 && self.alpha < 0.91)
		if (random(100) < 7 && self.alpha > 0.5)
			Sprite_Emitter(self.owner, "progs/s_gunsmoke.spr", random(.1, .15), '36 -5 -9', '0 0 1', '0 0 0', .4, TYPE_STANDARD);
	}

			
	//match to fake idle anims
	if ((self.owner.button0) || ((self.owner.velocity != '0 0 0') && (self.owner.earthquake_finished < time)) || (self.owner.super_damage_finished))	// go into initial pos when shooting or walking/running (quad effect would not match to animation, so do the same when then)
	{
		//if (autocvar_centered_weapons)
		//	self.origin = self.owner.gunof + '-1 6.6 -1.5';
		//else
		self.origin = self.owner.gunof;
		self.angles = self.owner.gunang;
		
		self.weapon_anim_x_offset_downwards = self.owner.weapon_anim_x_offset_downwards;
		self.weapon_anim_y_offset_downwards = self.owner.weapon_anim_y_offset_downwards;
		self.weapon_anim_z_offset_downwards = self.owner.weapon_anim_z_offset_downwards;
		
		self.weapon_anim_x_angles_downwards = self.owner.weapon_anim_x_angles_downwards;
		self.weapon_anim_y_angles_downwards = self.owner.weapon_anim_y_angles_downwards;
		self.weapon_anim_z_angles_downwards = self.owner.weapon_anim_z_angles_downwards;
	}
	else
	{
		//if (autocvar_centered_weapons)
		//	self.origin = self.owner.gunof + '-1 6.6 -1.5';
		//else
		self.origin = self.owner.gunof;
		self.angles = self.owner.gunang;
		
		self.weapon_anim_x_offset_downwards = self.owner.weapon_anim_x_offset_downwards;
		self.weapon_anim_y_offset_downwards = self.owner.weapon_anim_y_offset_downwards;
		self.weapon_anim_z_offset_downwards = self.owner.weapon_anim_z_offset_downwards;
		
		self.weapon_anim_x_angles_downwards = self.owner.weapon_anim_x_angles_downwards;
		self.weapon_anim_y_angles_downwards = self.owner.weapon_anim_y_angles_downwards;
		self.weapon_anim_z_angles_downwards = self.owner.weapon_anim_z_angles_downwards;
	}
	
	//self.angles = self.owner.gunang;
	
	self.frame = self.owner.weaponframe;
	self.think = updateSNG;
	self.nextthink = time;
	
	//v_weapon_position(self);
	//if (self.owner.v_weapon_animation < time)
	//idle_weapon_animation (autocvar_weapon_position_fully_adjustable_nail2_x_offset, autocvar_weapon_position_fully_adjustable_nail2_y_offset, autocvar_weapon_position_fully_adjustable_nail2_z_offset, autocvar_weapon_position_fully_adjustable_nail2_x_angle, autocvar_weapon_position_fully_adjustable_nail2_y_angle, autocvar_weapon_position_fully_adjustable_nail2_z_angle);
}

void() SNGHeater =			//Spawns a first person overlay on the SNG
{
	entity sngb;
		
	sngb = spawn();
	sngb.movetype = MOVETYPE_NONE;
	sngb.solid = SOLID_NOT;
	sngb.viewmodelforclient = self;
	sngb.owner = self;
	sngb.classname = "barrelheat";
	
	//sngb.effects = sngb.effects + EF_ADDITIVE;
	if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (autocvar_centered_weapons)
			setmodel(sngb, "progs/centered/v_nail2_barrel.mdl");
		else
			setmodel(sngb, "progs/v_nail2_barrel.mdl");
	}
	sngb.alpha = .01;
	sngb.scale = 1;
	setsize(sngb, '0 0 0', '0 0 0');
	setorigin(sngb, '4 -6 5');	//Don't worry about this showing up in weird places on higher resolutions -
					// all viewmodels are scaled to fit the res perfectly
	//setattachment(sngb, self.viewmodelforclient, "guntest");
	sngb.think = updateSNG;
	sngb.nextthink = time + 0.01;		//Adjust this as you wish
	
	
};



/*
================
W_FireShotgun
================
*/


void() W_FireShotgun =
{
	local vector dir;
	
	sound7 (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM, self.PLR_SNDSPD);	
	var float autocvar_muzzleflash = 1;     // set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1 && !autocvar_centered_weapons)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
			sendParticle("shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -10.5 + v_right * 4 + v_forward*15, self.velocity*50, 1);
		else
		{
			if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))		// if 'weapon_position_right' is set, move muzzleflash to the right
				sendParticle("shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*30 + v_right*7, self.velocity*50, 1);
			else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move muzzleflash to an ADJUSTABLE position 
				sendParticle("shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*30 + v_right * autocvar_weapon_position_adjustable_muzzleflash_shot1_offset, self.velocity*50, 1);
			else
				sendParticle("shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*30, self.velocity*50, 1);
		}
	}
	
	self.punchangle_x = -2;
	SpawnMuzzleFlash();
	SpawnSpark_Flash(1, '15 -13 25', '1 0.7 0.4', 1);
	
	
	//underwater muzzle flash
	if (self.waterlevel >= 3)
	{
		Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 -13 -20', '320 30 -10', '25 18 10', .7, TYPE_SMOKE);
		Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 -13 -20', '150 -10 -30', '25 18 10', .7, TYPE_SMOKE);
	}
	///////// pushback SG
	var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)	// if 'pushback' is other than '0', pushback is enabled
	{
		var float autocvar_pushbackshot1 = 60;    // set cvar 'pushbackshot1' default to 60
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackshot1, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
	}
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
 	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
	
	if (autocvar_qc_ssg)
		sound7 (self ,CHAN_WEAPON, "weapons/ssg2.wav", 1, ATTN_NORM, self.PLR_SNDSPD);	
	else	
		sound7 (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM, self.PLR_SNDSPD);	

	var float autocvar_muzzleflash = 1;    	// set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1 && !autocvar_centered_weapons)	// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
			sendParticle("double_shotgun_muzzleflash", self.origin + self.view_ofs + v_right * -1.5 + v_forward*17 + v_up * -5, self.velocity*50, 1);
		else
		{
			if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, move muzzleflash to the right
				sendParticle("double_shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*20 + v_right*6, self.velocity*50, 1);
			else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move muzzleflash to an ADJUSTABLE position 
				sendParticle("double_shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*20 + v_right * autocvar_weapon_position_adjustable_muzzleflash_shot2_offset, self.velocity*50, 1);
			else
				sendParticle("double_shotgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*20, self.velocity*50, 1);
		}
	}

	self.punchangle_x = -4;
	SpawnSSGFlash();
	SpawnSpark_Flash(1, '15 -18 19', '1 0.8 1', 1);
	
	SpawnSmoke_Flash(1, '5 0 13', 1, '.5 .5 .5', 0.5);
	if (self.waterlevel >= 3)
	{
		Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 -18 -20', '320 30 -10', '25 18 10', .7, TYPE_SMOKE);
		Sprite_Emitter(self, "progs/s_bubble.spr", 2, '20 -18 -20', '150 -10 -30', '25 18 10', .7, TYPE_SMOKE);
	}
	
	///////// pushback SSG
	var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
	{
		var float autocvar_pushbackshot2 = 75;    // set cvar 'pushbackshot2' default to 75
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackshot2, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
	}
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

void() exploderun  =
{
	
	self.frame++;
	self.think = exploderun;
	
	
	if (self.frame <= 2)
		exp_check_collision();
	
	if (self.model == "progs/s_explodbigp.spr")
	{
		self.nextthink = time + 0.05;
		if (self.frame >= 13)
			remove(self);
			
	}
	else if (self.model == "progs/s_plasma.spr")
	{
		self.nextthink = time + 0.08;
		if (self.frame >= 6)
			remove(self);
	}
	else
	{
		self.nextthink = time + 0.055;
		if (self.frame >= 16)
			remove(self);
	}
		
};

void() screenshake =
{
	if (autocvar_effects_explosion_shake == 0)
		return;
	local entity plyr;
	local float	d;

	// Is the shaking over?
	if (self.attack_finished < time) 
	{
		return;
	}
	
	// Create a list of entities to check for players
	plyr = findradius(self.origin, 1300);
	while(plyr) {
		// Only shake players (clients)
		if (plyr.flags & FL_CLIENT) {	
			// Scale effect by distance
			d = vlen(self.origin - plyr.origin);
			d = (1300 - d)/180;
			
			if (d > 0) {
				// shake up the view
				plyr.punchangle_x = -1 * (random(-1,1) + (0.025*2*d));
				plyr.punchangle_y = -1 * (random(-1,1) + (0.025*2*d));
				plyr.punchangle_z = -1 * (random(-2,2) + (0.025*2*d));
				
			}
		}
		// Find next entity in chain
		plyr = plyr.chain;
	}
	
	// keep shaking!
	self.nextthink = time + 0.1;
	self.think = screenshake;
};

void() BecomeExplosion =
{
	local entity explod, shake;
	
	
	
	explod = spawn();
	explod.movetype = MOVETYPE_NOCLIP;
	explod.velocity = '0 0 60';
	explod.touch = SUB_Null;
	explod.solid = SOLID_NOT;

	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		explod.alpha = 0.3;
	else
		explod.alpha = 0.8;
	
	explod.scale = 1.1;
	if (self.classname != "light_destruct")
	{
		//Half-Life 1 style explosion shake
		shake = spawn();
		setorigin(shake, self.origin + '0 0 15');
		shake.think = screenshake;
		shake.attack_finished = time + .3;
		shake.nextthink = time + 0.1;
		
		if (self.classname == "resistexp")
			setmodel (explod, "progs/s_smoke.spr");
		else if (self.classname == "misc_explobox")
		{
			if (random() > 0.3)
				setmodel (explod, "progs/s_explodbigp.spr");
			else
				setmodel (explod, "progs/s_explodbig.spr");
			explod.scale = 1.4;
		}
		else
		{
			setmodel (explod, "progs/s_explodbig.spr");
			if (self.classname == "proximity_grenade")
				explod.scale = 1.3;
			else
				explod.scale = 1.05;
		}
		if (self.classname == "slimeball" || self.netname == "slimeball")
		{
			setmodel (explod, "progs/s_explodbigp.spr");
			explod.colormod = '1 2 0';
			explod.scale = 0.6;
			explod.alpha = 0.7;
			explod.velocity = '0 0 40';
		}
		if (self.classname == "monster_tarbaby")
		{
			setmodel (explod, "progs/s_explodbigp.spr");
			explod.colormod = '.3 0 2';
			explod.scale = 0.9;
			explod.alpha = 0.7;
		}
	}	
	
	 
	
	setorigin(explod, self.origin + '0 0 15');
	explod.frame = 0;
	
		
	explod.think = exploderun;
	explod.nextthink = time + 0.1;
	
	
	
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	//FireGibs();
	//FireGibs();
	//FireGibs();
	//FireGibs();
	//FireGibs();
	s_explode1 ();
};

void() T_MissileTouch =
{
	local float	damg;
	local vector detonate;		// for seperation of explosion effect

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
		{
			remove(self);
			return;
		}
	}

	if (other.inflamed == 1)
	{
		other.health = -100;
		other.enemy = self.owner;
		other.nextthink = time;
		other.think = other.th_die;
	}
	if (random(100) < 30)
		spawn_fire();

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

	if (self.classname == "jimrocket") 
	{
		if (other.health < 25)  //For gibbing at low health
			damg = autocvar_player_rocket_impact/2 + random()*20;	// default 100
		else
			damg = autocvar_player_rocket_impact/4 + random()*15;	// default 100
	}
	else		
		damg = autocvar_player_rocket_impact + random()*20;	// default 100

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		if (other.classname == "monster_shambler")
		{
			sendParticle("rocket_resist", self.origin, '0 0 0', 1);
			self.classname = "resistexp";
			sparklers(1);
		}
		else
		{
			if (autocvar_effects_classic_explosion == 1)
				sendParticle("rocket_explo_classic", detonate, '0 0 0', 1);
			else
				sendParticle("rocket_explosion_nodebris", detonate, '0 0 0', 1);
		}
	}
	else
	{
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		if (pointcontents(self.origin) == CONTENT_SLIME)
			sendParticle("slimesplash", detonate, '0 0 0', 1);
		else if (autocvar_effects_classic_explosion == 1)
			sendParticle("rocket_explo_classic", detonate, '0 0 0', 1);
		else
			sendParticle("rocket_explosion", detonate, '0 0 0', 1);
	}
}
else
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
		{
			sendParticle("rocket_resist", self.origin, '0 0 0', 1);
			sparklers(1);
			sparklers(1);
			self.classname = "resistexp";
			damg = damg * 0.5;	// mostly immune
		}
		else
			sparklers(2);
			
		T_Damage (other, self, self.owner, damg );
	}
	detonate = self.origin;
	detonate = detonate - 8*normalize(self.velocity);
	if (pointcontents(self.origin) == CONTENT_SLIME)
		sendParticle("slimesplash", detonate, '0 0 0', 1);
	else if (autocvar_effects_classic_explosion == 1)
		sendParticle("rocket_explo_classic", detonate, '0 0 0', 1);
	else
		sendParticle("rocket_explosion", detonate, '0 0 0', 1);
}	
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	if (self.classname == "jimrocket") 
		T_RadiusDamage (self, self.owner, autocvar_player_rocket_radius/1.5, other);
	else
		T_RadiusDamage (self, self.owner, autocvar_player_rocket_radius, other);	// default 120
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		sound (self, CHAN_WEAPON, "weapons/xpld_wat.wav", 1, ATTN_NORM);
	else if (self.classname == "jimrocket") 
	{
		sound7 (self, CHAN_WEAPON, "weapons/proxexp.wav", 1, ATTN_NORM, SNDSPD);
		sound7 (self, CHAN_AUTO, "weapons/explodedist.wav", .3, ATTN_NONE, SNDSPD);
	}
	else
	{
		sound7 (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);
		sound7 (self, CHAN_AUTO, "weapons/explodedist.wav", .3, ATTN_NONE, SNDSPD);
	}
/*	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	sparklers();
	BecomeExplosion ();
};



void() T_MissileTouch_chton =
{
	local float	damg;
	local vector detonate;		// for seperation of explosion effect

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
		{
			remove(self);
			return;
		}
	}
	
	if (random(100) < 10)
		spawn_fire();

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

	damg = autocvar_chton_lavaballs + random()*20;	// default 100

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		sendParticle("cthon_fireball", detonate, '0 0 0', 1);
	}
	else
	{
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		sendParticle("cthon_fireball", detonate, '0 0 0', 1);
	}
}
else
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}
	detonate = self.origin;
	detonate = detonate - 8*normalize(self.velocity);
	sendParticle("cthon_fireball", detonate, '0 0 0', 1);
}	
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

	sound (self, CHAN_WEAPON, "boss1/fireball.wav", 1, ATTN_NORM);
/*	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity missile;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound7 (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM, self.PLR_SNDSPD);


///////// pushback RL
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbackrocket = 90;    // set cvar 'pushbackrocket' default to 90
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackrocket, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

	missile = spawn ();
missile.cansplash = TRUE;
	missile.owner = self;
	
	if (autocvar_oldprojectiles)
		missile.movetype = MOVETYPE_FLYMISSILE;
	else
		missile.movetype = MOVETYPE_FLY;
		
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_MissileTouch;
	
// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
	
	SpawnSpark_Flash(1.3, '5 0 0', '1 .5 0', 1);
	
	SpawnRockFlash('5 -15 48', '1 1 .7');
	
	

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	if ((autocvar_weapon_position_right)  && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move all projectiles to the right
		setorigin (missile, self.origin + self.view_ofs + v_forward*8 + v_up * -8 + v_right * 6);
	else if (autocvar_centered_weapons)	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
		setorigin (missile, self.origin + self.view_ofs + v_forward*8 + v_up * -8);
	else if ((!autocvar_weapon_position_right)  && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
		setorigin (missile, self.origin + self.view_ofs + v_forward*8 + v_up * -8 + v_right * autocvar_weapon_position_adjustable_projectile_rocket_offset);
	else
		setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};


/*
void() army_inflamed1;



void() T_FlameTouch =
{
	local float	damg;
	local vector detonate;		// for seperation of explosion effect

	if (other == self.owner)
		return;		// don't explode on owner
	if (other == world)
	{
		remove(self);
		return;
	}

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
		{
			remove(self);
			return;
		}
	}
		
	if (self.health < 20)
	{
		trace_ent.inflamed = 1;
		trace_ent.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
		trace_ent.think = army_inflamed1;
		trace_ent.nextthink = time + 0.1;
		trace_ent.traileffectnum = particleeffectnum("burning_monster");
	}
	else
		T_Damage (other, self, self.owner, 5);
		//trace_ent.th_die();
	/*if (other.inflamed == 1)
	{
		other.health = -100;
		other.enemy = self.owner;
		other.nextthink = time;
		other.think = other.th_die;
	}
	
}

void() W_FireFlame =
{
	local	entity missile;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	//sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -4;

///////// pushback RL
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbackrocket = 90;    // set cvar 'pushbackrocket' default to 90
		local vector pushback1, direc;
		direc = aim (self, 10);
		traceline (self.origin, self.origin + direc*autocvar_pushbackrocket, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

	missile = spawn ();
missile.cansplash = TRUE;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
// set missile speed	

	makevectors (self.v_angle);
	missile.velocity = aim(self, 300);
	missile.velocity = missile.velocity * 300;
	missile.angles = vectoangles(missile.velocity);
	missile.alpha = 0.001;
	
	missile.touch = T_FlameTouch;
	missile.traileffectnum = particleeffectnum("burning_monster");
	
// set missile duration
	missile.nextthink = time + .7;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/k_spike.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	if ((autocvar_weapon_position_right)  && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move all projectiles to the right
		setorigin (missile, self.origin + self.view_ofs + v_forward*8 + v_up * -8 + v_right * 6);
	else if ((!autocvar_weapon_position_right)  && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
		setorigin (missile, self.origin + self.view_ofs + v_forward*8 + v_up * -8 + v_right * autocvar_weapon_position_adjustable_projectile_rocket_offset);
	else
		setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};
*/

/*
===============================================================================

LIGHTNING

===============================================================================
*/


/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f, ziel;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			ziel = trace_endpos + '0 0 2';
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2") && (trace_ent.classname != "monster_enforcer") && (trace_ent.classname != "monster_reiver") && (trace_ent.classname != "monster_oldone"))	// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					sendParticle("secret", ziel, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					sendParticle("Lightning_gun_impact", ziel, '0 0 0', 1); 
				T_Damage (trace_ent, from, from, damage);
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				T_Damage (trace_ent, from, from, damage);
				return;
			}
		}
		if ((trace_ent.classname != "ShalrathMissile") && (trace_ent.dodge_finished < time))	// do not spawn blood on shootable shalrath missile or when monster is in dodge mode (in combat.qc it will not get hurt in this time)
			particle (trace_endpos, '0 0 100', 225, damage);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}

		////  added GYRO below
		
		local entity lightforce;
		local vector lightvec, dir, align;
		dir = aim (self, 10000);
		align = dir + v_up*0.33;
		traceline (p1, p2 + align*200, FALSE, self);
		lightvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
		lightforce = Gyro_Force_Create("light_hit", self.origin);
		Gyro_Force_ApplyFalloff_ConeLinear(lightforce, lightvec, 20, 20);
		Gyro_Force_ApplyAffector_Directional(lightforce, lightvec, 666, FALSE);
		Gyro_Force_AddProperty_Instant(lightforce);
		Gyro_Force_Ignore(lightforce, self); 	

	}
	else if ((trace_fraction != 1.0)&&(!trace_ent.health))
	{
	 	local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, trace_endpos);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if ((tex == "sky1") || (tex == "sky4"))
				return;
			else
			{
				ziel = trace_endpos; // + '0 0 2';
				sendParticle("Lightning_gun_impact", ziel, '0 0 0', 1);
			}
		}
	}

     	if ((trace_ent.inflamed == 1) && (trace_ent.inflamekillafterdeath == 0))
	{
		trace_ent.inflamekillafterdeath = 1;
		trace_ent.health = -1;
		trace_ent.nextthink = time;
		trace_ent.think = trace_ent.th_die;
		return;
	}

	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*2);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*2);
		T_Damage (trace_ent, from, from, damage);
		
	}
};

void() lg_shock_player;

void() ChainLightningHit =
{        
	local	vector org; // creates org vector
	local	float damage=0; // floats damage starting at 0
	local	entity head; //creates head entity

	org = self.origin + '0 0 16'; // vector org origin
	head = findradius(self.origin, 200); //send lightning line to anything in 250 radius
	while (head) // while looking for head
	{
		if (head.takedamage && head.baked != 1)  // if head has health, attack it
		{
			if(head != self.owner) // don't attack thunderbolt owner!!
			{
				//if (head.classname != "monster_afrit")
				//{
					if (head.classname != "monster_shambler" && head.classname != "monster_afrit" && head.classname != "door" && head.classname != "func_breakable" && head.classname != "button" && head.classname != "trigger_multiple" && head.classname != "monster_dfury_boss")
					//if (head.classname == "monster_army" || head.classname == "monster_dog" || head.classname == "monster_knight")
					{
						WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); // temp entity
						WriteByte (MSG_BROADCAST, TE_LIGHTNING2); // makes lightning line i think
						WriteEntity (MSG_BROADCAST, head); // write head entity
						WriteCoord (MSG_BROADCAST, org_x); // write orgs x coord
						WriteCoord (MSG_BROADCAST, org_y); // write orgs y coord
						WriteCoord (MSG_BROADCAST, org_z); // write orgs z coord
						WriteCoord (MSG_BROADCAST, head.origin_x); // write heads x coord
						WriteCoord (MSG_BROADCAST, head.origin_y); // write heads y coord
						WriteCoord (MSG_BROADCAST, head.origin_z); // write heads z coord
						sound7 (head, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM, SNDSPD); // its sound
						
						damage = 4; // 4 damage
						T_Damage (head, self, self.owner, damage); // its damage
					}
				//}
			}
		}
			head = head.chain; // go to next enemy
	}
	lg_shock_player();
	remove(self);
};

//Chain LG (TEST CODE)

void() W_FireLightning2 =
{
	local	entity thunderbolt; // create thunderbolt entity

    //if (self.ammo_cells < 1) // if u have more than 1 cell, this is the best weapon
	//{
		//self.weapon = W_BestWeapon ();
		//W_SetCurrentAmmo ();
			//return;
	//}
	//self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	//self.punchangle_x = -2; // kickback angle
	thunderbolt = spawn (); // spawn invisible missile
	thunderbolt.owner = self; // self is owner of thunderbolt
	thunderbolt.movetype = MOVETYPE_FLYMISSILE; // flies straight on
	thunderbolt.solid = SOLID_BBOX; // its solid
	thunderbolt.classname = "thunderbolt"; // name it thunderbolt
	makevectors (self.v_angle); // i dont know
	thunderbolt.velocity = aim(self, 10000); 
	thunderbolt.velocity = thunderbolt.velocity * 100000; //speed of 1000
	thunderbolt.angles = vectoangles(thunderbolt.velocity);
	thunderbolt.touch = ChainLightningHit; // calls ChainLightningHit when touched
	thunderbolt.nextthink = time + .5; // disappears after flying for 1 second
	thunderbolt.think = SUB_Remove; // does nothing after 5 seconds
	setsize (thunderbolt, '0 0 0', '0 0 0'); // thunderbolt bbox size
	setorigin (thunderbolt, self.origin + v_forward*8 + '0 0 4'); // thunderbolt spawn origin
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound7 (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

///////// pushback LG
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacklight = 15;    // set cvar 'pushbacklight' default to 15
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacklight, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}


	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	if ((autocvar_weapon_position_right == 1) && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move all projectiles to the right
		org = self.origin + self.view_ofs + v_forward*8 + v_up * -6.5 + v_right * 6;
	else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable == 1) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
		org = self.origin + self.view_ofs + v_forward*8 + v_up * -6.5 + v_right * autocvar_weapon_position_adjustable_projectile_lighting_offset;
	else
		org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		surfnum = getsurfacenearpoint(world, trace_endpos);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
				SpawnBlood (trace_endpos, '0 0 0', 2);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					spawn_face (face_spawn_pos, face_spawn_vel, 1);
				}
			}
		}		
	}

	if ((autocvar_mage_weapon) && (!cvar("chase_active")))	// if mage_weapon is set, use "beam.mdl" model in 1st person view
	{	
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_BEAM);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity (MSG_BROADCAST, self);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
	}
	if (autocvar_weapon_chain_thunderbolt == 1)
		W_FireLightning2();
	LightningDamage (self.origin, trace_endpos + v_forward*4, self, autocvar_player_lightninggun);	// default 30
	
};

//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, autocvar_player_grenades, world);	// default 120

	var float autocvar_explosiondebris = 0;
	if (random(100) < 50 && other.classname != "monster_shambler")
		spawn_fire();
	
	if (other.classname == "monster_shambler")
	{
		sendParticle("rocket_resist", self.origin, '0 0 0', 1);
		sparklers(1);
		sparklers(1);
	}
	else
	{
		sparklers();
		sparklers(2);
		if ( autocvar_explosiondebris == 0 )
		{
			if (pointcontents(self.origin) == CONTENT_SLIME)
				sendParticle("slimesplash", self.origin, '0 0 0', 1);
			else if (autocvar_effects_classic_explosion == 1)
				sendParticle("rocket_explo_classic", self.origin, '0 0 0', 1);
			else
			{
				if (other.health)
					sendParticle("grenade_explosion_nodebris", self.origin, '0 0 0', 1);
				else
					sendParticle("grenade_explosion", self.origin, '0 0 0', 1);
			}
		}
		else
		{
			if (pointcontents(self.origin) == CONTENT_SLIME)
				sendParticle("slimesplash", self.origin, '0 0 0', 1);
			else if (autocvar_effects_classic_explosion == 1)
				sendParticle("rocket_explo_classic", self.origin, '0 0 0', 1);
			else
				sendParticle("grenade_explosion", self.origin, '0 0 0', 1);
		}
	}
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		sound (self, CHAN_WEAPON, "weapons/xpld_wat.wav", 1, ATTN_NORM);
	else
		sound7 (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM, SNDSPD);
		
	sound7 (self, CHAN_AUTO, "weapons/explodedist.wav", .1, ATTN_NONE, SNDSPD);
	
	if (other.classname == "monster_shambler")
	{
		setmodel (self, "progs/s_smoke.spr");
		self.classname = "resistexp";
		BecomeExplosion ();
	}
	else
		BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.inflamed == 1)
	{
		other.health = -100;
		other.enemy = self.owner;
		other.nextthink = time;
		other.think = other.th_die;
		GrenadeExplode();
		return;
	}

	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	
	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

	sound7 (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM, SNDSPD);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local	entity missile;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound7 (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM, self.PLR_SNDSPD);

	self.punchangle_x = -2;

///////// pushback GL
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbackgrenade = 70;    // set cvar 'pushbackgrenade' default to 70
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackgrenade, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}


	missile = spawn ();
missile.cansplash = TRUE;
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed	

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	
	SpawnSmoke_Flash(1.3, '0 0 0', 1, 0, .7);		

	if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move all projectiles to the right
		setorigin (missile, self.origin + self.view_ofs + v_up * -13 + v_right * 6);
	else if (autocvar_centered_weapons)
		setorigin (missile, self.origin);
	else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
		setorigin (missile, self.origin + self.view_ofs + v_up * -13 + v_right * autocvar_weapon_position_adjustable_projectile_grenade_offset);
	else
		setorigin (missile, self.origin);
};



void() ProximityExplode =
{
   T_RadiusDamage (self, self.owner, 125, world);

	/*WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);*/
	
	if (pointcontents(self.origin) == CONTENT_SLIME)
		sendParticle("slimesplash", self.origin, '0 0 0', 1);
	else if (autocvar_effects_classic_explosion == 1)
		sendParticle("rocket_explo_classic", self.origin, '0 0 0', 1);
	else
		sendParticle("grenade_explosion", self.origin, '0 0 0', 1);
	if (pointcontents(self.origin) == CONTENT_WATER || pointcontents(self.origin) == CONTENT_SLIME || pointcontents(self.origin) == CONTENT_LAVA)
		sound (self, CHAN_WEAPON, "weapons/xpld_wat.wav", 1, ATTN_NORM);
	else
		sound7 (self, CHAN_WEAPON, "weapons/proxexp.wav", 1, ATTN_NORM, SNDSPD);
	sound7 (self, CHAN_AUTO, "weapons/explodedist.wav", .3, ATTN_NONE, SNDSPD);
	sparklers();
	sparklers(2);
	sparklers(2);
	self.origin_z+=5;
	BecomeExplosion ();
};

//MED 10/31/96
float NumProximityGrenades;

/*
================
ProximityGrenadeExplode
================
*/


void() ProximityGrenadeExplode =
{
   self.takedamage = DAMAGE_NO;
   NumProximityGrenades = NumProximityGrenades - 1;
   self.deathtype = "exploding";
   self.nextthink = time + 0.1;
   self.owner = self.lastvictim;
   self.think = ProximityExplode;
};
 


/*
================
ProximityGrenadeTouch
================
*/



void() ProximityStuckEnemy =
{
	entity vbomb;
	
	
	self.ltime++;
	if (self.ltime == 1)
	{
		sound7 (self, CHAN_WEAPON, "hipweap/proxstick.wav", 1, ATTN_NORM, SNDSPD);
		
		self.enemy.sticky = 1;
		vbomb = spawn();
		vbomb.owner = self;
		vbomb.solid = SOLID_NOT;
		vbomb.movetype = MOVETYPE_NOCLIP;
		vbomb.think = SUB_Remove;
		vbomb.nextthink = time + 2.5;
		
		
		setattachment(vbomb, self.enemy, "sticky");
		setmodel (vbomb, "progs/proxbomb.mdl");
		setmodel (self, "");
	}
	
	if (self.ltime < 26)
	{
		self.movetype = MOVETYPE_NOCLIP;
		self.solid = SOLID_NOT;
		//ProximityGrenadeExplode();
		if (self.enemy.health > 1)
			setorigin(self, self.enemy.origin + -v_forward*2 + '0 0 -7');
		else
			setorigin(self, self.enemy.origin + -v_forward*10 + '0 0 -15');
		self.angles = self.enemy.angles;
		self.think = ProximityStuckEnemy;
		self.nextthink = time + 0.1;
		if (self.ltime == 18)
		{
			sound7 (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM, SNDSPD);
		}
		//eprint (self.enemy);
	}
	else
	{
		ProximityGrenadeExplode();
		self.think();
		return;
	}
	

};


void() ProximityGrenadeTouch =
{
	if (other == self)
		return;
	if (other.classname == self.classname)
		return;
	self.movetype = MOVETYPE_TOSS;
	if (self.state == 1)
		return;
	if (vlen(other.velocity) > 0 && other.health < 1)
	{
		ProximityGrenadeExplode();
		self.think();
		return;
	}
	if (other.takedamage == DAMAGE_AIM && other.health > 1)
	{
		
		//ProximityGrenadeExplode();
		
		self.enemy = other;
		
		self.think = ProximityStuckEnemy;
		self.nextthink = time + 0.04;
		
		//self.think();
		
		return;
	}
		sound7 (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM, SNDSPD); // bounce sound
		self.movetype = MOVETYPE_NONE;
		setsize (self, '-8 -8 -8', '8 8 8');
		self.state = 1;
		self.spawnmaster = other;
};


/*
================
ProximityBomb
================
*/


void() ProximityBomb =
   {
   local entity   head;
   local float    blowup;

   if ((time > self.delay) || (NumProximityGrenades > 15) || (vlen(self.spawnmaster.velocity)>0) )
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   self.owner = world;
   self.takedamage = DAMAGE_YES;
   head = findradius(self.origin, 140);
   blowup = 0;

   while (head)
      {
      if ((head != self) && (head.health > 0) && (head.flags & (FL_CLIENT|FL_MONSTER)) && (head.classname!=self.classname))
         blowup = 1;
      if ((head.classname == self.classname) && (head.state==0))
         blowup = 1;
      traceline(self.origin,head.origin,TRUE,self);
      if (trace_fraction != 1.0)
         blowup = 0;
      if (blowup==1)
         {
      
	sound7 (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM, SNDSPD);
         ProximityGrenadeExplode();
         self.nextthink = time + 0.5;
         return;
         }
      head = head.chain;
      }
   self.nextthink = time + 0.25;
   };
   
 

/*
================
W_FireProximityGrenade
================
*/

void() ThrowNade;

void() W_FireProximityGrenade = 
 {
   local entity missile, mpuff;
   local string s;

	NumProximityGrenades = NumProximityGrenades + 1;
	self.grenade_ammo -=1;

	//sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);

	

	missile = spawn ();
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = 5;
	missile.state = 0;
	missile.scale = 0.9;

	// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '100 600 100';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = ProximityGrenadeTouch;

	// set missile duration
	missile.nextthink = time + 2;
	missile.delay = time + 15 + (10*random());
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;
	

	setmodel (missile, "progs/proxbomb.mdl");
	setorigin (missile, self.origin + v_right*8);
	setsize (missile, '-1 -1 -1', '1 1 1');
 };

//====================================================

//=============================================================================

void() spike_touch;
void() superspike_touch;
void() spike_enemy_touch; //ooppee addon, need to make enemy projectiles (knight and scrag projectils use a copy of the id1 code WITHOUT the stuck in walls code)

/*
===============
start OoPpEe
Launch enemy spike! Needs to be different so it DOESNT call "spike_touch" which results in stuck in walls
===============
*/
void(vector org, vector dir) launch_enemy_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_enemy_touch; //OoPpEe no more calling the in wall code now :D
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};
//end ooppee

void() bullet_enemy_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		if ((other.flags & FL_MONSTER) || (other.flags & FL_CLIENT))
			spawn_touchblood (9);	// leave this alone, as blood amount would look wrong
		if (self.classname == "playershot")
			T_Damage (other, self, self.owner, autocvar_player_shotgun_pellets); //player shotgun pellet damage (default 4)
		else
			T_Damage (other, self, self.owner, 5);		// 5 dmg per pellet
	}
	else// if (other == world)
	{
		//catch wood and dirt materials and change particle accordingly
		local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, self.origin);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if (returnsurface(tex) == GROUND)
			{
				sendParticle("TE_DIRT", self.origin, '0 0 0', 1);
				remove(self);
				return;
			}
			else if (returnsurface(tex) == MEAT)
			{
				sendParticle("TE_BLOOD", self.origin, '0 0 0', 1);
				remove(self);
				return;
			}
			else if (returnsurface(tex) == VOID)
			{
				remove(self);
				return;
			}
			else if (other.flags & FL_MONSTER)
				sendParticle("TE_BLOOD", self.origin, '0 0 0', 1);
			else
				sendParticle("TE_GUNSHOT", self.origin, '0 0 0', 1);
		}
			
		if (random() < 0.5)
			sound7(self, CHAN_AUTO, "weapons/ric1.wav", .7, ATTN_NORM, SNDSPD);
		else
			sound7(self, CHAN_AUTO, "weapons/ric3.wav", .7, ATTN_NORM, SNDSPD);
		/*WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);*/
	}

	remove(self);

};
/*
void() trailTouch =
{
	if (other == self.owner || other.classname == "gruntshot")
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID)
	{
		remove(self);
		return;
	}
	
	//remove(self);
	
}

void() trailThink =
{
	if (pointcontents(self.origin) == CONTENT_SKY || pointcontents(self.origin) == CONTENT_SOLID)
		remove(self);
	
	
}*/

void(vector org, vector dir) launch_enemy_bullet =
{
	local entity trail, bullet;
	bullet = spawn ();
	bullet.owner = self;
	bullet.movetype = MOVETYPE_FLYMISSILE;
	bullet.solid = SOLID_BBOX;
	
	//trail = spawn();
	//trail.owner = self;
	
	//setmodel(trail, "progs/bullettr.mdl");
	
	//setattachment(trail, bullet, "bullet trail");
	//trail.solid = SOLID_NOT;
	//trail.movetype = MOVETYPE_FLY;
	//trail.alpha = 0.8;

	bullet.angles = vectoangles(dir);
	
	//trail.angles = vectoangles(dir);
	
	bullet.touch = bullet_enemy_touch; //OoPpEe no more calling the in wall code now :D
	bullet.classname = "gruntshot";
	bullet.think = SUB_Remove;
	bullet.nextthink = time + 10;
	setmodel (bullet, "progs/bullettr.mdl");
	bullet.effects = EF_FULLBRIGHT;
	setsize (bullet, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (bullet, org);
	
	
	/*trail.touch = trailTouch;
	trail.think = trailThink;
	trail.nextthink = time + .3;*/
	if (cvar("slowmo") < .7)
		bullet.velocity = dir * 600;
	else
		bullet.velocity = dir * 1000;
	
	//setorigin (trail, org);
	//trail.velocity = dir * 1000;
};

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.cansplash = TRUE;
	newmis.owner = self;
	
	if (autocvar_oldprojectiles)
		newmis.movetype = MOVETYPE_FLYMISSILE;
	else
		newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.scale = 1.3;
	newmis.colormod = '2.5 2 1';
	//newmis.think = BecomeExplosion;
	newmis.traileffectnum = particleeffectnum("spike_bubble_trail");
	newmis.nextthink = time + 10;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.effects = EF_FULLBRIGHT;		
	setorigin (newmis, org);

	//nail speed, use bullet speed as a modifier for more satisfying slowmo/bullet time powerup
	if (cvar("slowmo") > 0.7)
		newmis.velocity = dir * 2400;
	else
		newmis.velocity = dir * self.bulletspeed/1.6;
};


void() W_FireSuperSpikes =
{
	
	local vector	dir;
	
		if (cvar("slowmo") < 0.7 && cvar("slowmo") >= 0.3)
			sound (self, CHAN_AUTO, "weapons/sngslow.wav", .7, ATTN_NORM);
		else
			sound7 (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
	self.weapontimer++;

	var float autocvar_muzzleflash = 1;     	// set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1 && !autocvar_centered_weapons)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
			sendParticle("supernailgun_muzzleflash", self.origin + self.view_ofs + v_up * -7 + v_right * -1.5 + v_forward * 14, self.velocity*50, 1);
		else
		{
			if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))		// if 'weapon_position_right' is set, move muzzleflash to the right
				sendParticle("supernailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*20 + v_right*7, self.velocity*50, 1);
			else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move muzzleflash to an ADJUSTABLE position 
				sendParticle("supernailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*20 + v_right * autocvar_weapon_position_adjustable_muzzleflash_nail2_offset, self.velocity*50, 1);
			else
				sendParticle("supernailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_forward*20, self.velocity*50, 1);
		}
	}

	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	if (cvar("chase_active"))
		launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right * -2, dir);
	else
	{
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable)) 		// if 'weapon_position_right' is set, move all projectiles to the right
			launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right * 9, dir);
		else if (autocvar_centered_weapons)
			launch_spike (self.origin + self.view_ofs + v_up * -8 , dir);
		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable)) 	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
			launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right * autocvar_weapon_position_adjustable_projectile_nail2_offset, dir);
		else
			launch_spike (self.origin + self.view_ofs + v_up * -8 , dir);
	}
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;
	
	newmis.scale = 1.3;
	
	newmis.effects = EF_FULLBRIGHT;	
	newmis.colormod = '9.5 2.3 0';

	SpawnSNGFlash();
	SpawnHLFlash();
	
	SpawnSmoke_Flash(0.6, '5 15 5', 0, 0, .7);
	
	if(self.weapontimer <= 4)
		self.nextthink = time + 0.16;
	else if(self.weapontimer <= 7)
		self.nextthink = time + 0.13;
	
///////// pushback SNG
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacknail2 = 30;    // set cvar 'pushbacknail2' default to 30
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacknail2, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

	
////  added GYRO below
	local entity nail;
	local	vector align, nailvec;

	makevectors(self.v_angle);
	align = dir + v_up*0.27;
	traceline (self.origin, self.origin + align*200, FALSE, self);
	nailvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	nail = Gyro_Force_Create("nailhit", self.origin);
	Gyro_Force_ApplyFalloff_ConeLinear(nail, nailvec, 16, 16);
	Gyro_Force_ApplyAffector_Directional(nail, nailvec, 2, FALSE);
	Gyro_Force_AddProperty_Instant(nail);
	Gyro_Force_Ignore(nail, self); 
	
	self.spindown = 1;
	self.spintimer = 0;

};

void(float checkgrunt) nailcasing;

void(float ox) W_FireSpikes =
{
	local vector	dir, muzzoff;
	local float naila;
	local float nailb;
	
	naila = autocvar_weapon_position_adjustable_projectile_nail1a_offset;
	nailb = autocvar_weapon_position_adjustable_projectile_nail1b_offset;
	
	makevectors (self.v_angle);
	
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}
	
	if (!self.button0)
	{
		//if (self.weaponframe >= 1)
		self.weaponframe++;
		//if (self.weaponframe >= 7)
		//	self.weaponframe = 0;
		//self.nextthink = time + 0.1;
		player_run ();
		return;
	}
	self.weaponframe++;
	if (self.weaponframe >= 5)
		self.weaponframe = 1;
	

	var float autocvar_muzzleflash = 1;     	// set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1 && !autocvar_centered_weapons)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
		{
			sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right * 2 + v_forward * 13, self.velocity*50, 1);
			sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right * -4.6 + v_forward * 13, self.velocity*50, 1);
		}
		else
		{
			if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))		// if 'weapon_position_right' is set, move muzzleflash to the right
			{
				if (self.weaponframe == 2)
					sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right*10 + v_forward*19, self.velocity*50, 1);
				if (self.weaponframe == 4)
					sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right*5.5 + v_forward*19, self.velocity*50, 1);
			}
			else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_fully_adjustable' is set, move muzzleflash to an ADJUSTABLE position 
			{
				if (self.weaponframe == 2)
					sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right * autocvar_weapon_position_adjustable_muzzleflash_nail1a_offset + v_forward*19, self.velocity*50, 1);
				if (self.weaponframe == 4)
					sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right * autocvar_weapon_position_adjustable_muzzleflash_nail1b_offset + v_forward*19, self.velocity*50, 1);
			}
			else
			{
				sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right*3.3 + v_forward*20, self.velocity*50, 1);
				sendParticle("nailgun_muzzleflash", self.origin + self.view_ofs + v_up * -8 + v_right*-3.3 + v_forward*20, self.velocity*50, 1);
			}
		}
	}

	
	self.attack_finished = time + 0.1;
	self.nextthink = time + 0.053;
	//self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	
	/*//if (self.weaponframe == 2 || self.weaponframe == 4)
	//{
	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*ox, dir);
	//}*/
	if (self.weaponframe == 2)
	{
		muzzoff = '0 -20 0';
		//custom slowmo sound
		if (cvar("slowmo") < 0.7 && cvar("slowmo") >= 0.3)
			sound (self, CHAN_AUTO, "weapons/ngslow.wav", .7, ATTN_NORM);
		else
			sound7 (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		if (autocvar_centered_weapons)
			launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*5, dir);
		else
			launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*9, dir);
		
		SpawnNailgunFlash(muzzoff);
		SpawnSmoke_Flash(0.8, muzzoff + '0 10 -15', 0, 0, .7);
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;
		
		if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1))
			nailcasing (0);

	}
	else if (self.weaponframe == 4)
	{
		muzzoff = '0 12 0';
		//custom slowmo sound
		if (cvar("slowmo") < 0.7 && cvar("slowmo") >= 0.3)
			sound (self, CHAN_AUTO, "weapons/ngslow.wav", .7, ATTN_NORM);
		else	
			sound7 (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		//launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*nailb, dir);
		
		if (autocvar_centered_weapons)
			launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*-6, dir);
		else
			launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*2, dir);
		SpawnNailgunFlash(muzzoff);
		SpawnSmoke_Flash(0.8, muzzoff + '0 20 -15', 0, 0, .7);
		self.currentammo = self.ammo_nails = self.ammo_nails - 1;
		
		if ((autocvar_shellcasing == 1)&&(autocvar_casingejectframe >= 1))
			nailcasing (0);
	}
	

	self.punchangle_x = -2;

///////// pushback NG
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacknail1 = 20;    // set cvar 'pushbacknail1' default to 20
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacknail1, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}


////  added GYRO below
	local entity nail;
	local	vector align, nailvec;

	makevectors(self.v_angle);
	align = dir + v_up*0.27;
	traceline (self.origin, self.origin + align*200, FALSE, self);
	nailvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	nail = Gyro_Force_Create("nailhit", self.origin);
	Gyro_Force_ApplyFalloff_ConeLinear(nail, nailvec, 16, 16);
	Gyro_Force_ApplyAffector_Directional(nail, nailvec, 2, FALSE);
	Gyro_Force_AddProperty_Instant(nail);
	Gyro_Force_Ignore(nail, self); 
};



.float hit_z;
void() spike_stuck_think = 
{ 
   if (self.aflag <= time) 
   { 
      remove (self); 
      return; 
   } 

   setorigin(self, self.pos1 + self.owner.origin - self.pos2); 
   
	   
   

   self.nextthink = time; 
}; 

//OoPpEe - now to copy over the old id1 code that DOESNT stick in walls. A simple copy and paste
void() spike_enemy_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);	// leave this alone, as blood amount would look wrong
		if (self.classname == "gruntshot")
		{
			T_Damage (other, self, self.owner, 5);		// 5 dmg per pellet
		}
		else if (self.classname == "wizspike")
		{
			var float autocvar_wizard_size_influenced_attack = 0; 	  	// set cvar 'wizard_size_influenced_attack' default to 0
			if (autocvar_wizard_size_influenced_attack == 1)		// if 'wizard_size_influenced_attack' is set via autoexec.cfg to '1' raise monster큦 attack values according to its size 
				T_Damage (other, self, self.owner, autocvar_wizard_missile * self.owner.scale);	// default 9
			else
				T_Damage (other, self, self.owner, autocvar_wizard_missile);			// default 9
			if (autocvar_wizard_projectiles_poison_chance)
			{
				local float zufall;
				zufall = random() * 100;
				if (zufall <= autocvar_wizard_projectiles_poison_chance)	// checks if wizards projectile impact poisons the player
				{
					other.poisoned = 1;
					other.poisontime = time + autocvar_wizard_projectiles_and_slime_poison_time;	  	// max total time of poison hurting the player
					other.poisonpause = time + autocvar_wizard_projectiles_and_slime_poison_frequence;  	// to avoid more damage from projectile
					stuffcmd(other, "v_cshift 1 0 1 0\n");
					//stuffcmd (other, "bf\n");
				}
			}
		}
		else if (self.classname == "knightspike")
		{
			var float autocvar_hknight_size_influenced_attack = 0; 	  	// set cvar 'hknight_size_influenced_attack' default to 0
			if (autocvar_hknight_size_influenced_attack == 1)		// if 'hknight_size_influenced_attack' is set via autoexec.cfg to '1' raise monster큦 attack values according to its size 
				T_Damage (other, self, self.owner, autocvar_hellknight_missile * self.owner.scale);  // default 9
			else
				T_Damage (other, self, self.owner, autocvar_hellknight_missile);		// default 9
			if (autocvar_hellknight_projectiles_inflame_chance)
			{
				local float zufal;
				zufal = random() * 100;
				if (zufal <= autocvar_hellknight_projectiles_inflame_chance)	// checks if hellknights projectile impact inflame the player
				{
					other.inflamed = 1;
					other.inflametime = time + autocvar_fire_projectiles_and_lava_inflame_time;		// max total time of fire hurting the player
					other.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence;  	// to avoid more damage from projectile
					stuffcmd (self, "bf\n"); //Q1 screen effect
					if ((autocvar_fire_projectiles_and_lava_inflame_particles) && (self.inflamed ==0)) 	// play sounds only once
					{
						sound (other, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM); 		// play ignition sound
						sound (other, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
					}
				}
			}
		}
		else if (self.classname == "furyspike")
		{
			var float autocvar_hknight_size_influenced_attack = 0; 	  	// set cvar 'hknight_size_influenced_attack' default to 0
			if (other.classname != "monster_knight")
			{
				T_Damage (other, self, self.owner, autocvar_hellknight_missile);		// default 9
			}
		}
		else if (self.classname == "furyspike")
		{
			if (other.classname != "monster_knight")
				T_Damage (other, self, self.owner, autocvar_hellknight_missile);		// default 9
		}
		else if (self.classname == "gruntspike" || self.classname == "freddiespike")
		{
			T_Damage (other, self, self.owner, 7);		// default 9
		}
		else	// warlord
		{
			T_Damage (other, self, self.owner, autocvar_warlord_missile);				// default 9
			if (autocvar_warlord_projectiles_inflame_chance)
			{
				local float zufa;
				zufa = random() * 100;
				if (zufa <= autocvar_warlord_projectiles_inflame_chance)	// checks if warlords projectile impact inflame the player
				{
					other.inflamed = 1;
					other.inflametime = time + autocvar_fire_projectiles_and_lava_inflame_time;		// max total time of fire hurting the player
					other.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence;  	// to avoid more damage from projectile
					if ((autocvar_fire_projectiles_and_lava_inflame_particles) && (self.inflamed ==0)) 	// play sounds only once
					{
						sound (other, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM); 		// play ignition sound
						sound (other, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
					}
				}
			}
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if ((self.classname == "knightspike")||(self.classname == "knight2spike"))
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};
//OoPpEe end

void() spike_touch = 
{ 
        if (other == self.owner) 
                return; 

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

        if (pointcontents(self.origin) == CONTENT_SKY) 
        { 
                remove(self); 
                return; 
        } 
        

 	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	
	self.effects = 0;	
	
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
		{
			remove(self);
			return;
		}
	}
       
     	if ((other.inflamed == 1) && (other.inflamekillafterdeath == 0))
	{
		other.inflamekillafterdeath = 1;
		other.health = -1;
		other.nextthink = time;
		other.think = other.th_die;
	}

	if (other.classname == "monster_hell_knight2")
	{
		if (other.dodging == 1)
		{
			sendParticle("TE_GUNSHOT", self.origin, '0 0 0', 1);
			remove(self);
			return;
		}
	} 
	if (other.takedamage)  // hit something that bleeds
        { 
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2") && (trace_ent.classname != "monster_enforcer") && (trace_ent.classname != "monster_reiver") && (trace_ent.classname != "monster_oldone"))		// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					sendParticle("secret", self.origin, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					sendParticle("TE_SPIKE", self.origin, '0 0 0', 1); 
				T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
				remove(self);   //add this so they don't float... 
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
				remove(self);   //add this so they don't float... 
				return;
			}
		}

		if (other.classname == "monster_spider")
			{
			local float resist;
			resist = autocvar_spider_attack_resistance * 0.01;
			if (random () > resist)		// decides if spider will resist this attack
				{
        		        spawn_touchblood (9); 
				T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
				}
			else
				return;
			}
		else
			{
        	        spawn_touchblood (9); 
			T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
			}

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
			self.angles_x = self.angles_x*-1; //account for error in makevectors with non-player entities
			makevectors(self.angles); //find direction nail is facing

			if (other.classname == "monster_wizard")
			{        
				ThrowBloodSplat(v_forward, self.origin, other, 1, 1); 
			}
			else if (other.classname == "monster_army")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else if (other.classname == "monster_ogre")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
				if (random(100) < 40)
					sendParticle("TE_SPIKE", self.origin, '0 0 0', 1);
			}
			else if (other.classname == "monster_hell_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				if (random(100) < 50)
					sendParticle("TE_SPIKE", self.origin, '0 0 0', 1);
			}
			else if (other.classname == "monster_hell_knight2")
			{
				if (random(100) < 40)
					sendParticle("TE_SPIKE", self.origin, '0 0 0', 1);
					
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_enforcer")
			{
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_reiver")
			{
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
				if (random(100) < 40)
					sendParticle("TE_SPIKE", self.origin, '0 0 0', 1);
			}
			else if (other.classname == "monster_demon1")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 3, 1);
			}
			else if (other.classname == "monster_dog")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
			}
			else if (other.classname == "monster_shalrath")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 4, 1); 
			}
			else if (other.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 5, 1); 
			}
			else if (other.classname == "monster_shambler")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else 
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
		}
                
                remove(self);   //add this so they don't float... 
                return;         //add this to avoid errors 
        } 

        else if (other.solid != SOLID_BSP) 
        { 
                remove(self); 
                return; 
        } 
	
	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 5);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

      
                
        if (self.classname == "wizspike") 
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); 
                WriteByte (MSG_BROADCAST, TE_WIZSPIKE); 
                
                 WriteCoord (MSG_BROADCAST, self.origin_x); 
		WriteCoord (MSG_BROADCAST, self.origin_y); 
		WriteCoord (MSG_BROADCAST, self.origin_z); 
	}
        else if (self.classname == "knightspike") 
        {
        	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); 
                WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE); 
                
                WriteCoord (MSG_BROADCAST, self.origin_x); 
		WriteCoord (MSG_BROADCAST, self.origin_y); 
		WriteCoord (MSG_BROADCAST, self.origin_z); 
	}
	else if (cvar("slowmo") < 0.9)
        {
        	sendParticle("TE_SPIKE", self.origin, '0 0 0', 1); 
		if (random() < 0.8)
			sound7(self, CHAN_WEAPON, "weapons/ric1.wav", .6, ATTN_NORM, SNDSPD);
		else if (random() < 0.4)
			sound7(self, CHAN_ITEM, "weapons/ric2.wav", .6, ATTN_NORM, SNDSPD);
		else
			sound7(self, CHAN_BODY, "weapons/ric3.wav", .6, ATTN_NORM, SNDSPD);
	}
        else 
        {
		//catch wood and dirt materials and change particle accordingly
		local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, self.origin);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if (returnsurface(tex) == GROUND)
			{
				sendParticle("TE_DIRT", self.origin, '0 0 0', 1);
				remove(self);
				return;
			}
			else if (returnsurface(tex) == MEAT)
			{
				sendParticle("TE_BLOOD", self.origin, '0 0 0', 1);
				remove(self);
				return;
			}
			else if (returnsurface(tex) == VOID)
			{
				remove(self);
				return;
			}
		}
			
	
        	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); 
                WriteByte (MSG_BROADCAST, TE_SPIKE);
                
                WriteCoord (MSG_BROADCAST, self.origin_x); 
		WriteCoord (MSG_BROADCAST, self.origin_y); 
		WriteCoord (MSG_BROADCAST, self.origin_z);  
	}
                
       
        
        

        self.solid = SOLID_NOT; 
        self.movetype = MOVETYPE_NONE; 
        
        self.colormod = '1 1 1';	//reset glow

        setorigin (self, self.origin - normalize(self.velocity) * 3); 
        self.velocity = '0 0 0';         //add this, it makes the nail stop 

	if (other.solid == SOLID_BSP && other != world) 
	{ 
	        self.owner = other; 
	        self.pos1 = self.origin; 
	        self.pos2 = other.origin; 
	        self.aflag = time + 10; 
	        self.think = spike_stuck_think; 
	        self.nextthink = time; 
	} 
	else 
	{ 
	        self.nextthink = time + autocvar_spikelifetime;     	//add this, to prevent packet overflows 
	        self.think = SUB_Remove;        			//add this for same reason as above 
	} 
};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

        if (pointcontents(self.origin) == CONTENT_SKY) 
        { 
                remove(self); 
                return; 
        } 
        if(other != world)
	{
		if (trace_endpos_z > (trace_ent.origin_z + 16))
			trace_ent.hitbox_pos = HEAD_SHOT; // Tag as headshot in entity
	}
	

	self.effects = 0;	
 	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4"))
		{
			remove(self);
			return;
		}
	}

     	if ((other.inflamed == 1) && (other.inflamekillafterdeath == 0))
	{
		other.inflamekillafterdeath = 1;
		other.health = -1;
		other.nextthink = time;
		other.think = other.th_die;
	}

// hit something that bleeds 
        if (other.takedamage) 
        { 
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2") && (trace_ent.classname != "monster_enforcer") && (trace_ent.classname != "monster_reiver") && (trace_ent.classname != "monster_oldone"))		// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					sendParticle("secret", self.origin, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					sendParticle("TE_SUPERSPIKE", self.origin, '0 0 0', 1); 
				T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
				remove(self);   //add this so they don't float... 
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
				remove(self);   //add this so they don't float... 
				return;
			}
		}
		
		if (other.classname == "monster_spider")
			{
			local float resist;
			resist = autocvar_spider_attack_resistance * 0.01;
			if (random () > resist)		// decides if spider will resist this attack
				{
           		    	spawn_touchblood (18); 
				T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
				}
			else
				return;
			}
		else if (other.classname == "monster_dfury_boss")
		{
			self.velocity_x = -self.velocity_x;
			self.velocity_y = -self.velocity_y;
			T_Damage (other, self, self.owner, autocvar_player_supernailgun/2);
			sendParticle("sparks", self.origin, '0 0 0', 1);
		}
		else
			{
           	   	spawn_touchblood (18); 
			T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
			}

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
		    self.angles_x = self.angles_x*-1; //account for error in makevectors with non-player entities
		    makevectors(self.angles); //find direction nail is facing

			if (other.classname == "monster_wizard")
			{        
				ThrowBloodSplat(v_forward, self.origin, other, 1, 1); 
			}
			else if (other.classname == "monster_army")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else if (other.classname == "monster_ogre")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
				if (random(100) < 40)
					sendParticle("TE_SUPERSPIKE", self.origin, '0 0 0', 1);
			}
			else if (other.classname == "monster_hell_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				if (random(100) < 40)
					sendParticle("TE_SUPERSPIKE", self.origin, '0 0 0', 1);
			}
			else if (other.classname == "monster_hell_knight2")
			{
				if (random(100) < 40)
					sendParticle("TE_SUPERSPIKE", self.origin, '0 0 0', 1);
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_enforcer")
			{
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_reiver")
			{
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
				if (random(100) < 40)
					sendParticle("TE_SUPERSPIKE", self.origin, '0 0 0', 1); 
			}
			else if (other.classname == "monster_demon1")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 3, 1);
			}
			else if (other.classname == "monster_dog")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
			}
			else if (other.classname == "monster_shalrath")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 4, 1); 
			}
			else if (other.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 5, 1); 
			}
			else if (other.classname == "monster_shambler")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else 
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
		}

                remove(self);   //add this so they don't float... 
                return;         //add this to avoid errors 
        } 

        else if (other.solid != SOLID_BSP) 
        { 
                remove(self); 
                return; 
        }

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 5);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}
	if (cvar("slowmo") < 0.9)
        {
        	sendParticle("TE_SUPERSPIKE", self.origin, '0 0 0', 1); 
		if (random() < 0.8)
			sound7(self, CHAN_WEAPON, "weapons/ric1.wav", .6, ATTN_NORM, SNDSPD);
		else if (random() < 0.4)
			sound7(self, CHAN_ITEM, "weapons/ric2.wav", .6, ATTN_NORM, SNDSPD);
		else
			sound7(self, CHAN_BODY, "weapons/ric3.wav", .6, ATTN_NORM, SNDSPD);
	}
	else
	{
		//catch wood and dirt materials and change particle accordingly
		//local float surfacenum;
		//local string tex;
		surfacenum = getsurfacenearpoint(world, self.origin);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if (returnsurface(tex) == GROUND)
			{
				sendParticle("TE_DIRT", self.origin, '0 0 0', 1);
				remove(self);
				return;
			}
			else if (returnsurface(tex) == MEAT)
			{
				sendParticle("TE_BLOOD", self.origin, '0 0 0', 1);
				remove(self);
				return;
			}
			else if (returnsurface(tex) == VOID)
				return;
		}
		
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
		
        self.solid = SOLID_NOT; 
        self.movetype = MOVETYPE_NONE; 

        setorigin (self, self.origin - normalize(self.velocity) * 3); 
        self.velocity = '0 0 0';         //add this, it makes the nail stop 
        
        self.colormod = '1.6 1.3 1';

      if (other.solid == SOLID_BSP && other != world) 
      { 
         self.owner = other; 
         self.pos1 = self.origin; 
         self.pos2 = other.origin; 
         self.aflag = time + 10; 
         self.think = spike_stuck_think; 
         self.nextthink = time; 
      } 
      else 
      { 
        
         self.nextthink = time + autocvar_spikelifetime;    	//add this, to prevent packet overflows 
         self.think = SUB_Remove;        			//add this for same reason as above 
      } 
};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	var float autocvar_weaponandplayertransparency = 100;	// set cvar 'weaponandplayertransparency' default to 100 (= 100% = fully opaque).  Set the percentage how much transparent the view_weapons / player shall be (0= fully invisible). Choose any value you want between 0 and 100
	self.alpha = autocvar_weaponandplayertransparency * 0.01;

	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		if (autocvar_zombieaxeanimation == 1)		// Axe is animated when aiming at new zombies
			self.weaponmodel = "progs/v_axe_zombie00.mdl";
		else
			self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
		axeequipped = 1;
	}
	else if (self.weapon == IT_CHAINSAW)
	{
		self.skin = 1;
		//self.currentammo = 0;
		self.weaponmodel = "progs/v_saw.mdl";
		sound7 (self, 6, "weapons/sawidle.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, use view_weapons models set, which is moved to the right side
			self.weaponmodel = "progs/v_shot_right.mdl";
		else
		{
			if (autocvar_centered_weapons)
				self.weaponmodel = "progs/centered/v_shot.mdl";
			else
				self.weaponmodel = "progs/v_shot.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, use view_weapons models set, which is moved to the right side
			self.weaponmodel = "progs/v_shot2_right.mdl";
		else
		{
		
			if (autocvar_centered_weapons && !autocvar_qc_ssg)
				self.weaponmodel = "progs/centered/v_shot2.mdl";
			else if (autocvar_qc_ssg && autocvar_centered_weapons)
				self.weaponmodel = "progs/centered/QC/v_shot2.mdl";
			else if (autocvar_qc_ssg)
				self.weaponmodel = "progs/QC/v_shot2.mdl";
			else
				self.weaponmodel = "progs/v_shot2.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, use view_weapons models set, which is moved to the right side
			self.weaponmodel = "progs/v_nail_right.mdl";
		else
			self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, use view_weapons models set, which is moved to the right side
			self.weaponmodel = "progs/v_nail2_right.mdl";
		else
			self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		axeequipped = 0;
	}
	/*else if (self.weapon == IT2_PROXIMITY_GUN)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_prox.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}*/
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, use view_weapons models set, which is moved to the right side
			self.weaponmodel = "progs/v_rock_right.mdl";
		else
			self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set, use view_weapons models set, which is moved to the right side
			self.weaponmodel = "progs/v_rock2_right.mdl";
		else
			self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		if ((autocvar_weapon_position_right == 1) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set to '1', use COMPLETE view_weapons models set, which is moved to the right side
		{
			cvar_set ("cl_beams_quakepositionhack", "0");	// if 'weapon_position_right' is set to '1', change DP큦 lightning-hack cvar setting to be able to move the lightning to the right
			self.weaponmodel = "progs/v_light_right.mdl";
		}
		else if ((autocvar_weapon_position_right == 2) && (!autocvar_weapon_position_fully_adjustable))	// if 'weapon_position_right' is set to '2', use view_weapons models set (except Lightning gun), which is moved to the right side
		{
			cvar_set ("cl_beams_quakepositionhack", "1");	// restore default setting of DP큦 lightning-hack cvar setting
			self.weaponmodel = "progs/v_light.mdl";
		}
		else
		{
			cvar_set ("cl_beams_quakepositionhack", "1");	// restore default setting of DP큦 lightning-hack cvar setting
			self.weaponmodel = "progs/v_light.mdl";
		}
		if (autocvar_mage_weapon)
		{
			cvar_set ("cl_beams_quakepositionhack", "1");	// restore default setting of DP큦 lightning-hack cvar setting
			self.weaponmodel = "progs/v_mage1.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
		axeequipped = 0;
	}
	//HIPNOTIC WEAPONS
	else if (self.weapon == IT_LASER_CANNON)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_laserg.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
		axeequipped = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;
	
	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
			return IT_LIGHTNING;
	if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
	if(it & IT_CHAINSAW)
		return IT_CHAINSAW;
	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;
		
	if (self.weapon == IT_CHAINSAW)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
	
// drop the weapon down
	return FALSE;
};


void() shellcasing_touch =
{
	if (other.solid == SOLID_BSP)		// noting can touch it, only the map brushes
		{
		self.velocity = self.velocity * 0.9;	// make it less bouncing
		if (autocvar_casingdropsound)
			{
			
			local float zufall;
			zufall = random();
			if (zufall <= 0.4)
				sound7 (self, CHAN_WEAPON, "weapons/casings1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			else if (zufall >= 0.6)
				sound7 (self, CHAN_WEAPON, "weapons/casings2.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			else 
				sound7 (self, CHAN_WEAPON, "weapons/casings3.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			}
		self.touch = SUB_Null;
		}
};

void() nailcasing_touch =
{
	if (other.solid == SOLID_BSP)		// noting can touch it, only the map brushes
		{
		//self.velocity = self.velocity * 0.7;	// make it less bouncing
		if (autocvar_casingdropsound)
			{
			
			local float zufall;
			zufall = random();
			if (self.owner.waterlevel >= 3)
			{
				if (zufall <= 0.4)
					sound7 (self, CHAN_WEAPON, "weapons/nailcase1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
				else if (zufall >= 0.6)
					sound7 (self, CHAN_WEAPON, "weapons/nailcase2.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
				else 
					sound7 (self, CHAN_WEAPON, "weapons/nailcase3.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
			}
			else 
			{
				if (zufall <= 0.4)
					sound7 (self, CHAN_WEAPON, "weapons/nailcase1.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
				else if (zufall >= 0.6)
					sound7 (self, CHAN_WEAPON, "weapons/nailcase2.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
				else 
					sound7 (self, CHAN_WEAPON, "weapons/nailcase3.wav", autocvar_casingdropsound, ATTN_NORM, SNDSPD);
				}
			}
		self.touch = SUB_Null;
		}
};

void() rockcasing_touch =
{
	if (other.solid == SOLID_BSP)		// noting can touch it, only the map brushes
		{
		//self.velocity = self.velocity * 0.7;	// make it less bouncing
		if (autocvar_casingdropsound)
			{
			
			local float zufall;
			zufall = random();
			if (self.waterlevel >= 3)
			{
				if (zufall <= 0.2)
					sound7 (self, CHAN_WEAPON, "weapons/rockcase1.wav", autocvar_casingdropsound/2, ATTN_NORM, SNDSPD);
				else
					sound7 (self, CHAN_WEAPON, "weapons/rockcase.wav", autocvar_casingdropsound/2, ATTN_NORM, SNDSPD);
			}
			else 
			{
				if (zufall <= 0.2)
					sound7 (self, CHAN_WEAPON, "weapons/rockcase1.wav", autocvar_casingdropsound/3, ATTN_NORM, random(90,100));
				else
					sound7 (self, CHAN_WEAPON, "weapons/rockcase.wav", autocvar_casingdropsound/3, ATTN_NORM, random(90,100));
				}
			}
		//self.touch = SUB_Null;
		}
};

float(entity to, float sendFlags) casing_sendtocsqc =
{
	
   WriteByte( MSG_ENTITY, ENT_CASING );
   WriteByte( MSG_ENTITY, sendFlags);
   
   if (sendFlags & 1)
   {
	   // Emitter origin
	   WriteCoord( MSG_ENTITY, self.origin_x );
	   WriteCoord( MSG_ENTITY, self.origin_y );
	   WriteCoord( MSG_ENTITY, self.origin_z );

	  // Emitter velocity
	   WriteCoord( MSG_ENTITY, self.velocity_x );
	   WriteCoord( MSG_ENTITY, self.velocity_y );
	   WriteCoord( MSG_ENTITY, self.velocity_z );
	   
	   //Type of casing (shotgun/nailgun/rocket)
	   WriteCoord( MSG_ENTITY, self.casetype );
	   
   }

   return TRUE;
};

void() gibsfade_noblood;
void() casing_placement =		// place it on ground, so that it looks a little bit random, but does not sink into floor
{
	if (self.flags & FL_ONGROUND)
		{
		self.angles_x = 0 + crandom() * 10;		// makes it look random but still keeps it flat
		if (autocvar_casingusegyro == 1)
			MonsterPhysics (self, autocvar_casingmass);
		self.nextthink = time + autocvar_casinglifetime;
		self.think = gibsfade_noblood;			// casings will fade away
		return;
		}
	self.nextthink = time + 0.1;
};

void(float checkgrunt) casing =
{
		
	local entity shellcasing;
	local vector ejectpos;
	local float correction;

	shellcasing = spawn();
	correction = autocvar_casingejectpos - 8;	// makes the z-position adjustable via cvar  (-8 is default)
	if (checkgrunt == 0)				// player did the shot
		{
 		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move shells to the side
			ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * 8 + v_up * correction;	
 		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move shells to an ADJUSTABLE position
			ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * autocvar_weapon_position_adjustable_projectile_casing_offset + v_up * correction;	
		else
			ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * 2 + v_up * correction;	
		shellcasing.angles = self.v_angle;
		shellcasing.angles_x = shellcasing.angles_x * -1;	// old Quake bug...
		}
	else						// grunt did the shot
		{
		makevectors (self.angles);	
		ejectpos = self.origin + v_up*13 + v_right*7 + v_forward*8;
		shellcasing.angles = self.angles;
		}
		
	setorigin (shellcasing, ejectpos);
	setmodel (shellcasing, "progs/casing.mdl");
	shellcasing.scale = .9;	
	setsize (shellcasing, '0 0 -2', '0 0 0');
	shellcasing.alpha = 1;
	shellcasing.movetype = MOVETYPE_BOUNCE;
	shellcasing.solid = SOLID_TRIGGER;
	shellcasing.touch = shellcasing_touch;
	shellcasing.takedamage = DAMAGE_NO;
	shellcasing.velocity = self.velocity*2.5 * 0.25 + v_right * 97 + v_up * 143 + v_forward * 20 + randomvec() * 22;
	if (coop || deathmatch)
	{
		 shellcasing.casetype = CASING_SHELL;
		 shellcasing.SendEntity = casing_sendtocsqc;
		 shellcasing.SendFlags |= 1;
		 shellcasing.think = SUB_Remove;
		 shellcasing.nextthink = time + 0.01;
		 return;
		
	}
	shellcasing.avelocity = '390 322 290' + randomvec() * 44;
	shellcasing.nextthink = time;
	shellcasing.think = casing_placement;
	shellcasing.cansplash = TRUE;		// Yes, its fun  ;)
	shellcasing.gravity = 1.3;
};

void(float checkgrunt) nailcasing =
{
	local entity nailcasing;
	local vector ejectpos;
	local float correction;

	nailcasing = spawn();
	correction = autocvar_casingejectpos - 8;	// makes the z-position adjustable via cvar  (-8 is default)
	if (checkgrunt == 0)				// player did the shot
		{
 		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move shells to the side
			ejectpos = self.origin + self.view_ofs + v_forward * 8 + v_right * 8 + v_up * correction;	
 		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move shells to an ADJUSTABLE position
			ejectpos = self.origin + self.view_ofs + v_forward * 8 + v_right * autocvar_weapon_position_adjustable_projectile_casing_offset + v_up * correction;	
		else
			ejectpos = self.origin + self.view_ofs + v_forward * 8 + v_right * 2 + v_up * correction;	
		nailcasing.angles = self.v_angle;
		nailcasing.angles_x = nailcasing.angles_x * -1;	// old Quake bug...
		}
	else						// grunt did the shot
		{
		makevectors (self.angles);	
		ejectpos = self.origin + v_up*13 + v_right*7 + v_forward*8;
		nailcasing.angles = self.angles;
		}
	setorigin (nailcasing, ejectpos);
	setmodel (nailcasing, "progs/nailcasing.mdl");
	nailcasing.scale = .7;	
	setsize (nailcasing, '0 0 0', '0 0 0');
	nailcasing.alpha = 1;
	nailcasing.movetype = MOVETYPE_BOUNCE;
	nailcasing.solid = SOLID_TRIGGER;
	nailcasing.touch = nailcasing_touch;
	nailcasing.takedamage = DAMAGE_NO;
	nailcasing.velocity = self.velocity*3 * 0.25 + v_right * 87 + v_up * 103 + v_forward * 40 + randomvec() * 22;
	if (coop || deathmatch)
	{
		 nailcasing.casetype = CASING_NAIL;
		 nailcasing.SendEntity = casing_sendtocsqc;
		 nailcasing.SendFlags |= 1;
		 nailcasing.think = SUB_Remove;
		 nailcasing.nextthink = time + 0.01;
		 return;
		
	}
	nailcasing.avelocity = '390 222 400' + randomvec() * 44;
	nailcasing.nextthink = time;
	nailcasing.think = casing_placement;
	nailcasing.cansplash = TRUE;		// Yes, its fun  ;)
	nailcasing.gravity = 1.3;
};

void(float checkgrunt) missilecase =
{
	local entity rocketcase;
	local vector ejectpos;
	local float correction;

	rocketcase = spawn();
	correction = autocvar_casingejectpos - 8;	// makes the z-position adjustable via cvar  (-8 is default)
	if (checkgrunt == 0)				// player did the shot
		{
 		if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move shells to the side
			ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * 8 + v_up * correction;	
 		else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move shells to an ADJUSTABLE position
			ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * autocvar_weapon_position_adjustable_projectile_casing_offset + v_up * correction;	
		else
			ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * 2 + v_up * correction;	
		rocketcase.angles = self.v_angle;
		rocketcase.angles_x = rocketcase.angles_x * -1;	// old Quake bug...
		}
	else						// grunt did the shot
		{
		makevectors (self.angles);	
		ejectpos = self.origin + v_up*13 + v_right*7 + v_forward*8;
		rocketcase.angles = self.angles;
		}
	setorigin (rocketcase, ejectpos);
	setmodel (rocketcase, "progs/missilecasing.mdl");
	rocketcase.scale = 1;	
	setsize (rocketcase, '0 0 0', '0 0 0');
	rocketcase.alpha = 1;
	rocketcase.movetype = MOVETYPE_BOUNCE;
	rocketcase.solid = SOLID_TRIGGER;
	rocketcase.touch = rockcasing_touch;
	rocketcase.takedamage = DAMAGE_NO;
	rocketcase.velocity = self.velocity*2.5 * 0.25 + v_right * 77 + v_up * 33 + randomvec() * 22;
	if (coop || deathmatch)
	{
		 rocketcase.casetype = CASING_ROCKET;
		 rocketcase.SendEntity = casing_sendtocsqc;
		 rocketcase.SendFlags |= 1;
		 rocketcase.think = SUB_Remove;
		 rocketcase.nextthink = time + 0.03;
		 return;
		
	}
	rocketcase.avelocity = '0 22 0' + randomvec() * 44;
	rocketcase.nextthink = time;
	rocketcase.think = casing_placement;
	rocketcase.cansplash = TRUE;		// Yes, its fun  ;)
};


/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_axes1;
void()	player_shot1;
void()	player_shotswim1;
void()	player_swimnail1;
void()	player_nail1;
void()	player_light1;
void() player_mage1;
void()	player_rocket1;
void() player_chainsaw1;
void() player_swimsaw1;
void() player_laser1;

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	if (self.meleeing == 1)
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound7 (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		if (self.waterlevel >= 2)
			player_axes1 ();
		else
		{
			r = random();
			if (r < 0.25)
				player_axe1 ();
			else if (r<0.5)
				player_axeb1 ();
			else if (r<0.75)
				player_axec1 ();
			else
				player_axed1 ();
		}
		W_FireAxe2();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		if (self.waterlevel >= 2)
			player_shotswim1 ();
		else
			player_shot1 ();
		W_FireShotgun ();
		if (autocvar_shotgun_cycle_fix)
			self.attack_finished = time + 0.54;
		else
			self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		if (self.waterlevel >= 2)
			player_shotswim1 ();
		else
			player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		if (self.waterlevel >= 2)
			player_swimnail1 ();
		else
			player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		if (self.waterlevel >= 2)
			player_swimnail1 ();
		else
			player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		if (self.waterlevel >= 2)
			player_shotswim1 ();
		else
			player_rocket1();
		W_FireGrenade();
		if (autocvar_cheat_crazyexplosives == 1)
		{
			self.attack_finished = time + 0.07;
		}
		else
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		if (self.waterlevel >= 2)
			player_shotswim1 ();
		else
			player_rocket1();
		W_FireRocket();
		if (autocvar_cheat_crazyexplosives == 1)
		{
			self.attack_finished = time + 0.07;
		}
		else
			self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		if ((autocvar_mage_weapon) && (!cvar("chase_active")))
		{
			player_mage1();
			self.attack_finished = time + 0.1;
		}
		else	
		{
			player_light1();
			self.attack_finished = time + 0.1;
			sound7 (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		}
	}
	else if (self.weapon == IT_CHAINSAW) //BASE CHAINSAW SPEED
	{
		if (self.waterlevel >= 2)
			player_swimsaw1 ();
		else
			player_chainsaw1();
		if (!trace_ent.takedamage)
			sound7 (self, CHAN_WEAPON, "weapons/sawatck.wav", 1, ATTN_NORM, self.PLR_SNDSPD);
		self.attack_finished = time + 0.55;
	}
	else if (self.weapon == IT_LASER_CANNON)
	{
		player_laser1();
	}
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
	
	self.idletimer = 1;
	self.switchtimer = -5;
	
		
	if (self.impulse == 1)
	{
		if (self.weapon == IT_AXE)
		{
			fl = IT_CHAINSAW;
			if (self.items & IT_CHAINSAW)
				sprint(self, "Chainsaw\n");
		}
		else
			fl = IT_AXE;
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
	/*else if (self.impulse == 6)
	{
		if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			fl = IT2_PROXIMITY_GUN;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else
		{
			fl = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
			am = 1;
		}
	}*/
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	//else if (self.impulse == 6)
	//{
	//	fl = IT_GRENADE_LAUNCHER;
	//	if (self.ammo_rockets < 1)
	//		am = 1;
	//}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		if ((self.items == IT_LASER_CANNON) && (self.items != IT_LIGHTNING))
		{
			fl = IT_LASER_CANNON;
			if (self.ammo_cells < 1)
			am = 1;
		}
		else if (self.items == IT_LIGHTNING)
		{
			fl = IT_LIGHTNING;
			if (self.ammo_cells < 1)
			am = 1;
		}
		/*if (self.weapon == IT_LASER_CANNON)
		{
			fl = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}*/
		else if (self.weapon == IT_LIGHTNING)
		{
			fl = IT_LASER_CANNON;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else
		{
			fl = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
		
	}
	/*else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}*/
	/*else if (self.impulse == 225)
	{
		fl = IT_LASER_CANNON;
		if (self.ammo_cells < 1)
		am = 1;
	}*/
	else if (self.impulse == 252)
	{
		fl = IT_CHAINSAW;
		if (self.items & IT_CHAINSAW)
			sprint(self, "Chainsaw\n");
	}

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
	W_SetCurrentAmmo ();
	
// plays weapon-change-sound when player uses keyboard keys to change weapons
	if (autocvar_changeweaponsounds && self.ishuman == TRUE)
	{
		if (fl == IT_AXE)
			sound7 (self, CHAN_VOICE, "weapons/weapon1.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_SHOTGUN)
			sound7 (self, CHAN_VOICE, "weapons/weapon2.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_SUPER_SHOTGUN)
			sound7 (self, CHAN_VOICE, "weapons/weapon3.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_NAILGUN)
			sound7 (self, CHAN_VOICE, "weapons/weapon4.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_SUPER_NAILGUN)
			sound7 (self, CHAN_VOICE, "weapons/weapon5.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_GRENADE_LAUNCHER)
			sound7 (self, CHAN_VOICE, "weapons/weapon6.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_ROCKET_LAUNCHER)
			sound7 (self, CHAN_VOICE, "weapons/weapon7.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		else if (fl == IT_LIGHTNING) 
		{
			if ((!autocvar_mage_weapon) || (cvar("chase_active")))
				sound7 (self, CHAN_VOICE, "weapons/weapon8.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
		}
		else if (fl == IT_LASER_CANNON) 
			sound7 (self, CHAN_VOICE, "hipweap/weapon9.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
	}
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

	self.ammo_rockets = autocvar_rockets_max_capacity;	// default 100
	self.ammo_nails = autocvar_nails_max_capacity;		// default 200
	self.ammo_shells = autocvar_shells_max_capacity;	// default 100
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_CHAINSAW |
		IT_LASER_CANNON |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = autocvar_cells_max_capacity;		// default 100
	self.items = self.items | IT_LIGHTNING;
	self.grenade_ammo = 15;
		
	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
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
	
	self.idletimer = 1;
	self.switchtimer = -8;
	
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LASER_CANNON)
		{
			self.weapon = IT_AXE;
		}
		/*if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}*/
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_CHAINSAW;
		}
		else if (self.weapon == IT_CHAINSAW)
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
		/*else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT2_PROXIMITY_GUN;
			if (self.ammo_rockets < 1)
				am = 1;
		}*/
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
		else if (self.weapon == IT_LIGHTNING)
		{
			 self.weapon = IT_LASER_CANNON;
			 if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			// plays weapon-change-sound when player uses mouse-wheel to change weapons
			if (autocvar_changeweaponsounds)
			{
				if (self.weapon == IT_AXE)
					sound7 (self, CHAN_VOICE, "weapons/weapon1.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_SHOTGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon2.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_SUPER_SHOTGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon3.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_NAILGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon4.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_SUPER_NAILGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon5.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_GRENADE_LAUNCHER)
					sound7 (self, CHAN_VOICE, "weapons/weapon6.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_ROCKET_LAUNCHER)
					sound7 (self, CHAN_VOICE, "weapons/weapon7.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_LIGHTNING) 
				{
					if ((!autocvar_mage_weapon) || (cvar("chase_active")))
						sound7 (self, CHAN_VOICE, "weapons/weapon8.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				}
				else if (self.weapon == IT_LASER_CANNON) 
					sound7 (self, CHAN_VOICE, "hipweap/weapon9.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
			}
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
	
	self.idletimer = 1;
	self.switchtimer = -8;

	while (1)
	{
		am = 0;
		
		if (self.weapon == IT_LASER_CANNON)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == IT_LIGHTNING)
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
			self.weapon = IT_CHAINSAW;
		}
		else if (self.weapon == IT_CHAINSAW)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LASER_CANNON;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			// plays weapon-change-sound when player uses mouse-wheel to change weapons
			if (autocvar_changeweaponsounds)
			{
				if (self.weapon == IT_AXE)
					sound7 (self, CHAN_VOICE, "weapons/weapon1.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_SHOTGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon2.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_SUPER_SHOTGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon3.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_NAILGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon4.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_SUPER_NAILGUN)
					sound7 (self, CHAN_VOICE, "weapons/weapon5.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_GRENADE_LAUNCHER)
					sound7 (self, CHAN_VOICE, "weapons/weapon6.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_ROCKET_LAUNCHER)
					sound7 (self, CHAN_VOICE, "weapons/weapon7.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				else if (self.weapon == IT_LIGHTNING) 
				{
					if ((!autocvar_mage_weapon) || (cvar("chase_active")))
						sound7 (self, CHAN_VOICE, "weapons/weapon8.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
				}
				else if (self.weapon == IT_LASER_CANNON) 
					sound7 (self, CHAN_VOICE, "hipweap/weapon9.wav", autocvar_changeweaponsounds, ATTN_NORM, self.PLR_SNDSPD);
			}
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
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	sound7 (self, CHAN_ITEM, "items/damage.wav", 1, ATTN_NORM, SNDSPD);
	sprint (self, "You got the ");
	sprint (self, "Quad Damage");
	sprint (self,"\n");
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.super_damage_counter = 30;
	self.items = self.items | IT_QUAD;
//	dprint ("quad cheat\n");
};

void() RingCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	sound (self, CHAN_ITEM, "items/inv1.wav", 1, ATTN_NORM);
	sprint (self, "You got the ");
	sprint (self, "Ring of Shadows");
	sprint (self,"\n");
	self.invisible_time = 1;
	self.invisible_finished = time + 30;
	self.invisible_counter = 30;
	self.items = self.items | IT_INVISIBILITY;
//	dprint ("ring cheat\n");
};

void() PentCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	sound (self, CHAN_ITEM, "items/protect.wav", 1, ATTN_NORM);
	sprint (self, "You got the ");
	sprint (self, "Pentagram of Protection");
	sprint (self,"\n");
	self.invincible_time = 1;
	self.invincible_finished = time + 30;
	self.invincible_counter = 30;
	self.items = self.items | IT_INVULNERABILITY;
//	dprint ("pent cheat\n");
};

void() BiosuitCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	sound (self, CHAN_ITEM, "items/suit.wav", 1, ATTN_NORM);
	sprint (self, "You got the ");
	sprint (self, "Biosuit");
	sprint (self,"\n");
	self.rad_time = 1;
	self.radsuit_finished = time + 30;
	self.radsuit_counter = 30;
	self.items = self.items | IT_SUIT;
//	dprint ("biosuit cheat\n");
};


void() Genocide =
   {
   local entity   head;

   if (deathmatch || coop)
		return;
	
   if (self.classname == "player")
	bprint("Genocide!\n");
	
	
   head = nextent(world);
   while (head!=world)
      {
      if ((head.health > 0) && (head.flags & FL_MONSTER))
         {
          if (self.classname == "monster_dfury_boss")	
		T_Damage(head,world,world,head.health);
	  else
		T_Damage(head,world,world,head.health+10);
         }
      head = nextent(head);
      }
   };
   
void() ChaseCam =
{
	if (cvar("chase_active"))
		stuffcmd(self, "chase_active 0\n");
	else
		stuffcmd(self, "chase_active 1\n");

}
   
/*
============
ImpulseCommands

============
*/
void() DebugMenu;


void() ImpulseCommands =
{
	
	//debug
	//centerprint3(self, strcat("Team: ", ftos(self.side), " has flag?: ", ftos(self.has_flag)));
	
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();
	
	//if (self.impulse == -2)
		//SpawnRebreather();
	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	if (self.impulse == 13)
		swap_team();
	if (self.impulse == 20) 	// instant melee attack
		meleeaxe();
	if (self.impulse == 21)
		saw_spawn();
	if (self.impulse == 30) 	// flashlight 
	{
		if (autocvar_flashlight_type == 1)
		        flash_toggle();
		else if (autocvar_flashlight_type == 2)
		        flash_toggle_cubemap();
	}

	if (self.impulse == 40) 	// personal player teleport effect
	{
		if (self.personal_teleporter_spawned)
			self.personal_teleporter_start_beam = 1;
		else
			player_teleport();
	}
	if (self.impulse == 204)
		self.dmenu = TRUE;
   	if (self.impulse == 205)
      		Genocide();
      	if (self.impulse == 206)
		ChaseCam();		
      	if (self.impulse == 215)
		ThrowNade();
	if (self.impulse == 250)
		TimeRuneCheat();
	if (self.impulse == 251)
		RingCheat ();
	if (self.impulse == 253)
		PentCheat ();
	if (self.impulse == 254)
	{
		SpawnRebreather();
		BiosuitCheat ();
	}
	if (self.impulse == 255)
		QuadCheat ();
		
	self.impulse = 0;
};


void() checkzombie =		// checks for NEW zombie via traceline in a distance of max. 777 Quake units
{
local vector source;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*777, FALSE, self);

	if ((trace_ent.model == "progs/zombie_new.mdl")||(trace_ent.model == "progs/zombie_new_headless.mdl"))
		{
		self.weaponmodel = "progs/v_axe_zombie01.mdl";		// Axe + glow is animated
		self.glow_color = 75;
		self.glow_size = 888;
		}
	else						// Axe + glow is fading out
		{
		self.weaponmodel = "progs/v_axe_zombie00.mdl";
		self.glow_color = 0;
		self.glow_size = 0;
		}
};


/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/


void() W_WeaponFrame =
{
//Multiplayer config to prevent lag
if ((deathmatch || coop) && (mapstart == 0))
{
	if (autocvar_z_coopconfig == 0)
	{
		stuffcmd(self, "exec q15_config_coop.cfg\n");
		cvar_set ("z_coopconfig", "1");
		stuffcmd(self, "restart\n");
	}
	mapstart = 1;
	
}
else if ((!deathmatch || !coop) && (mapstart == 0))
{
	if (autocvar_z_coopconfig == 1)
	{
		stuffcmd(self, "exec q15_config.cfg\n");
		cvar_set ("z_coopconfig", "0");

		stuffcmd(self, "restart\n");
	}
	mapstart = 1;
}

if (!(deathmatch || coop))
{
if (world.model == "maps/start.bsp")
	{
	if ( welcomenote == 1 )
		{
if (self.welcomeshown <= 20)		// set endtime of welcome message here
			{
			if (time > self.welcomeshown)	// needed to set delay for welcome message
				{
				if (self.welcomeshown == 0)
					self.welcomeshown = time + 1;	// set delay for welcome message here
				else
					{
					self.welcomeshown = time + 1.9;
					//centerprint(self, "Welcome to Quake 1.5 based on Seven's Small Mod Compilation\n^2Bind^7 a key to ^2'quickkick'^7 for the melee kick.\n\n\nPress ^5F1^7 or type in console 'lowspec' and restart the map if \nyou want to ^5load the LOWSPEC/LAPTOP settings (default for coop)^7.\n\n type 'highspec' if \nyou want to ^1revert to SP defaults^7 (better effects)\n");
					centerprint(self, "Welcome to Quake 1.5, \n\n\n forked from Seven's Small Mod Compilation 5.30\n\n\n\nPress the ^2'Home'^7 key to access mod menus for keybinds and game options\n");
					}
				}
			}
		}
	}
}


if (autocvar_zombieaxeanimation == 1)		// if cvar "zombieaxeanimation" is enabled, axe is animated when aiming at NEW zombies
	{
	if (autocvar_zombienewmodelproperties >= 1)	// new zombie model is killable with axe
		{
		if (self.weapon == IT_AXE)
			checkzombie();
		else
			{
			self.glow_color = 0;
			self.glow_size = 0;
			}
		}
	}


	if (time < self.attack_finished)
		return;

	ImpulseCommands ();
	
// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound7 (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM, SNDSPD);
		}
	}
	return;
};


